----------------------------------------------------------------
--  V4 WALL Layouting
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2011 Andrew Apted
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
----------------------------------------------------------------

--[[ *** CLASS INFORMATION ***

class EDGE
{
  K, side  -- identification

  real_len  --  real length of edge

  corn_L, corn_R : CORNER

  long_L, long_R  -- length allocated to corners
  deep_L, deep_R  -- depth (sticking out) at corners

  usage : USAGE   -- primary usage (door, window, etc)

  spans[] : SPAN  -- allocated stuff on this edge
}


class SPAN
{
  long1, long2  -- length range along edge
  deep1, deep2  -- depth (sticking out)

  FIXME: usage stuff
}


class CORNER
{
  K, side  -- identification

  concave  -- true for 270 degree corners

  horiz, vert  -- connecting sizes

  usage : USAGE  -- primary usage
}


class MIDDLE
{
  K  -- section

  usage : USAGE
}


----------------------------------------------------------------]]

require 'defs'
require 'util'


----
---  MINIMUM SIZES
---  -------------
---  
---  Door / Window / Important  @  EDGE  -->  192 x 64  (64 walk)
--- 
---  Item / Switch  @  MIDDLE  -->  128 x 128  (64 walk)
---  
---  Basic wall -->  32 thick
---  
---  Basic corner -->  32 x 32
--  

  --
  -- Straddlers are architecture which sits across two rooms.
  -- Currently there are only two kinds: DOORS and WINDOWS.
  -- 
  -- The prefab to use (and hence their size) are decided before
  -- everything else.  The actual prefab and heights will be
  -- decided later in the normal layout code.
  --


function Layout_inner_outer_tex(skin, K, K2)
  assert(K)
  if not K2 then return end

  local R = K.room
  local N = K2.room

  if N.kind == "REMOVED" then return end

  skin.wall  = R.skin.wall
  skin.outer = N.skin.wall

  if R.outdoor and not N.outdoor then
    skin.wall  = N.facade or skin.outer
  elseif N.outdoor and not R.outdoor then
    skin.outer = R.facade or skin.wall
  end
end


function Layout_add_span(E, long1, long2, deep)

-- stderrf("********** add_span %s @ %s : %d\n", kind, E.K:tostr(), E.side)

  assert(long2 > long1)

  -- check if valid
  assert(long1 >= 16)
  assert(long2 <= E.real_len - 16)

  -- corner check
  if E.long_L then assert(long1 >= E.long_L) end
  if E.long_R then assert(long2 <= E.long_R) end

  for _,SP in ipairs(E.spans) do
    if (long2 <= SP.long1) or (long1 >= SP.long2) then
      -- OK
    else
      error("Layout_add_span: overlaps existing one!")
    end
  end

  -- create and add it
  local SPAN =
  {
    long1 = long1,
    long2 = long2,
    deep1 = deep,
    deep2 = deep,
  }

  table.insert(E.spans, SPAN)

  -- keep them sorted
  if #E.spans > 1 then
    table.sort(E.spans,
        function(A, B) return A.long1 < B.long1 end)
  end

  return SPAN
end



function Layout_used_walls(R)

  local function is_minimal_edge(skin)
    if not skin._long then return false end
    if not skin._deep then return false end

    return skin._long <= 192 and skin._deep <= 64
  end


  local function possible_doors(E)
    local list, lock, key

    local C = E.usage.conn

    if C.lock and C.lock.kind == "KEY" then
      list = THEME.lock_doors
      lock = C.lock
      key  = lock.key
    elseif C.lock and C.lock.kind == "SWITCH" then
      list = THEME.switch_doors
      lock = C.lock
    elseif rand.odds(20) then
      list = THEME.doors
    else
      list = THEME.arches
    end

    E.usage.edge_fabs = Layout_possible_prefab_from_list(list, "edge", key)
  end


  local function possible_windows(E)
    if E.usage.K1.room.outdoor and E.usage.K2.room.outdoor then
      list = THEME.fences
    else
      list = THEME.windows
    end

    E.usage.edge_fabs = Layout_possible_prefab_from_list(list, "edge")
  end


  local function create_span(E, skin, extra_skins)
    local long = assert(skin._long)
    local deep = assert(skin._deep)

    local long1 = int(E.real_len - long) / 2
    local long2 = int(E.real_len + long) / 2

    local SP = Layout_add_span(E, long1, long2, deep, prefab)

    if E.usage.FOOBIE then return end
    E.usage.FOOBIE = true


    if R.skin then table.insert(extra_skins, 1, R.skin) end

    local skins = table.copy(extra_skins)
    table.insert(skins, skin)

    local fab = Fab_create(skin._prefab)

    Fab_apply_skins(fab, skins)


    fab.room = R
    table.insert(R.prefabs, fab)

    SP.fab = fab
    SP.extra_skins = extra_skins


    local back = 0

    if E.usage.kind == "window" or E.usage.kind == "door" then
      back = -deep

      -- add the straddler prefab to the other room too

      local N = E.K:neighbor(E.side)

      fab.straddler = { E = E, R2 = N.room }

      table.insert(N.room.prefabs, fab)
    end

    local T = Trans.edge_transform(E.K.x1, E.K.y1, E.K.x2, E.K.y2, 0, E.side,
                                   long1, long2, back, deep)

    Fab_transform_XY(fab, T)
  end


  local function initial_edge(E)
    if E.usage.kind == "door" then
      possible_doors(E)
    elseif E.usage.kind == "window" then
      possible_windows(E)
    end

    local fabs = assert(E.usage.edge_fabs)

    if fabs == "SWITCH" then
      fabs = assert(E.usage.lock.switches)
    end

    local fabs2 = table.copy(fabs)

    for name,_ in pairs(fabs) do
      local skin = GAME.SKINS[name]
      if not skin then
        error("No such skin: " .. tostring(name))
      end

      if is_minimal_edge(skin) then
        gui.printf("  minimal_fab @ %s:%d ---> %s\n", E.K:tostr(), E.side, name)
      else
        fabs2[name] = nil
      end
    end

    if table.empty(fabs2) then
      gui.printf("E.usage =\n%s\n", table.tostr(E.usage, 2))
      error("Lacking minimal prefab for: " .. tostring(E.usage.kind))
    end

    local name = rand.key_by_probs(fabs2)
    E.minimal = { skin=GAME.SKINS[name] }

    if E.usage.kind == "door" and E.usage.conn.lock and E.usage.conn.lock.kind == "SWITCH" then
      E.usage.conn.lock.switches = assert(E.minimal.skin._switches)
    end

    local extra_skins = {}

--!!!!!!
local CRUD = { item="none", outer="COMPBLUE",track="_ERROR",frame="_ERROR",
               rail="STEPTOP", metal="METAL", }
table.insert(extra_skins, CRUD)


    local in_out = {}
    Layout_inner_outer_tex(in_out, E.K, E.K:neighbor(E.side))
    table.insert(extra_skins, in_out)


    if E.usage.kind == "door" and E.usage.conn.lock then
      local lock = E.usage.conn.lock
      if lock.tag then
        table.insert(extra_skins, { tag = lock.tag, targetname = "sw" .. tostring(lock.tag) })
      end
    end

    if E.usage.kind == "important" and E.usage.lock and E.usage.lock.kind == "KEY" then
      table.insert(extra_skins, { item = E.usage.lock.key })
    end

    if E.usage.kind == "important" and E.usage.lock and E.usage.lock.kind == "SWITCH" then
      local lock = E.usage.lock
      table.insert(extra_skins, { tag = lock.tag, targetname = "sw" .. tostring(lock.tag) })
    end

    if E.usage.sub == "EXIT" and GAME.format == "quake" then
      table.insert(extra_skins, { next_map = LEVEL.next_map })
    end


    create_span(E, E.minimal.skin, extra_skins)
  end


  ---| Layout_used_walls |---

  for pass = 1,2 do
    for _,K in ipairs(R.sections) do
      for _,E in pairs(K.edges) do
        -- do doors before everything else, since switched doors
        -- control what switches will be available.
        local is_door = sel(E.usage and E.usage.kind == "door", 1, 2)
        if E.usage and pass == is_door then
          initial_edge(E)
        end
      end
    end
  end
end



function Layout_make_corners(R)
  --
  -- this function decides what to place in every corner of the room,
  -- including concave (270 degree) corners.  This is done before the
  -- edges, determining the sides of each edge so that the edges will
  -- merely need to fill in the gap(s).
  --

  local function find_edges(C)
    local side_L = geom.LEFT_45 [C.side]
    local side_R = geom.RIGHT_45[C.side]

    local H  -- edge connecting Horizontally
    local V  -- edge connecting Vertically

    if C.concave then
      local K1 = C.K:neighbor(side_L)
      local K2 = C.K:neighbor(side_R)

      H = K1.edges[side_R]
      V = K2.edges[side_L]
    else
      H = C.K.edges[side_R]
      V = C.K.edges[side_L]
    end

    if C.side == 1 or C.side == 9 then
      H, V = V, H
    end

    assert(H and V)

    return H, V
  end


  local function edge_max_depth(E)
    -- NOTE: assumes no more than one span on any edge
    local SP = E.spans[1]

    if SP then
      return math.max(SP.deep1, SP.deep2, 64)
    end

    return 64
  end


  local function corner_length(C, E)
    if C.concave then return 64 end

    local SP = E.spans[1]

    if SP then
      -- FIXME: assumes span is centered
      local long = SP.long2 - SP.long1

      return (E.real_len - long) / 2
    end

    return E.real_len / 2 - 48
  end


  local function make_corner(C)
    local H, V = find_edges(C)

    local long_H = corner_length(C, H)
    local long_V = corner_length(C, V)

    local deep_H = edge_max_depth(H)
    local deep_V = edge_max_depth(V)

    H.max_deep = deep_H
    V.max_deep = deep_V

    gui.debugf("Corner @ %s:%d : long_H:%d long_V:%d  deep_H:%d deep_V:%d\n",
               C.K:tostr(), C.side, long_H, long_V, deep_H, deep_V)

    -- long_H,V are the upper limit on the size of the corner

    -- FIXME!!! look for a prefab that fits in that limit,
    --          and test if it fits OK (no overlapping e.g. walk brushes)

if true then
long_V = 64
long_H = 64
end

    C.horiz = long_H
    C.vert  = long_V

    H.max_deep = math.max(long_V, deep_H)
    V.max_deep = math.max(long_H, deep_V)

    -- the EDGE long_L,R and deep_L,R fields are done in flesh_out_walls()

    local skin = {}

    local neighbor = C.K:neighbor(C.side)

    if R.outdoor then
      local A = C.K:neighbor(geom.RIGHT_45[C.side])
      local B = C.K:neighbor(geom. LEFT_45[C.side])

      if A and A.room and not A.room.outdoor then neighbor = A end
      if B and B.room and not B.room.outdoor then neighbor = B end
    end

    Layout_inner_outer_tex(skin, C.K, neighbor)

    local fab_name = "CORNER"

    if GAME.format == "quake" and not C.concave and not R.outdoor then
      fab_name = "CORNER_DIAG_W_TORCH"
    end

    -- build something

    local T = Trans.corner_transform(C.K.x1, C.K.y1, C.K.x2, C.K.y2, nil,
                                     C.side, C.horiz, C.vert)

    local fab = Fab_create(fab_name)

    Fab_apply_skins(fab, { R.skin or {}, skin })

    Fab_transform_XY(fab, T)

    fab.room = R
    table.insert(R.prefabs, fab)
  end


  ---| Layout_make_corners |---

  for _,K in ipairs(R.sections) do
    for _,C in pairs(K.corners) do
      make_corner(C)
    end
  end
end


-- FIXME: TEMP CRUD - REMOVE
function geom.horiz_sel(A, B, C)
  return geom.vert_sel(A, C, B)
end


function Layout_picture_hack(R)
  -- FIXME: TEMP HACK : add some picture prefabs

  local function do_edge(E)
    if E.spans[1] then return end
    if not THEME.piccies then return end
    if R.outdoor then return end
    if not rand.odds(30) then return end

    if not R.pic_name then
      -- FIXME: use possible_prefabs ??
      R.pic_name = rand.key_by_probs(THEME.piccies)
    end

    local skin = assert(GAME.SKINS[R.pic_name])

    -- FIXME: similar code to create_span() -- check if can merge them

    local long = skin._long
    local deep = skin._deep

    local long1 = int(E.real_len - long) / 2
    local long2 = int(E.real_len + long) / 2

    Layout_add_span(E, long1, long2, deep)

    local skins = { }

    if R.skin then table.insert(skins, R.skin) end
    table.insert(skins, skin)

    local fab = Fab_create(skin._prefab)

    Fab_apply_skins(fab, skins)


    fab.room = R
    table.insert(R.prefabs, fab)

    local T = Trans.edge_transform(E.K.x1, E.K.y1, E.K.x2, E.K.y2, 0, E.side,
                                   long1, long2, 0, deep)

    Fab_transform_XY(fab, T)
  end

  for _,K in ipairs(R.sections) do
    for _,E in pairs(K.edges) do
      do_edge(E)
    end
  end
end


function Layout_flesh_out_walls(R)
  --
  -- the goal of this function is to fill in the gaps along walls
  -- with either prefabs or trapezoid-shaped brushes.
  --

  local function edge_extents(E)
    E.long_L = 0
    E.deep_L = 64

    if E.corn_L and not E.corn_L.concave then
      -- FIXME: SHOULD BE vert_sel : WHAT IS WRONG ???
      E.long_L = geom.horiz_sel(E.side, E.corn_L.vert,  E.corn_L.horiz)
      E.deep_L = geom.horiz_sel(E.side, E.corn_L.horiz, E.corn_L.vert)
    end

    E.long_R = 0  -- temporarily use offset from right, fixed soon
    E.deep_R = 64

    if E.corn_R and not E.corn_R.concave then
      E.long_R = geom.horiz_sel(E.side, E.corn_R.vert,  E.corn_R.horiz)
      E.deep_R = geom.horiz_sel(E.side, E.corn_R.horiz, E.corn_R.vert)
    end

    E.long_R = E.real_len - E.long_R
  end


  local function flesh_out_range(E, long1, deep1, long2, deep2)
    if long1 >= long2 then
      return
    end

    -- FIXME: handle small gaps

    local my = int((deep1 + deep2) / 2)

---    if (long2 - long1) >= 360 then
---      local mx = int((long1 + long2) / 2)
---      RECURSIVE SUB-DIVISION
---    end
    
    gui.debugf("flesh_out_range @ %s:%d : (%d %d) .. (%d %d)\n",
               E.K:tostr(), E.side, long1, deep1, long2, deep2)

    local deep

    if true then
      deep = 16
    else
      deep = math.max(deep1, deep2)
    end

    local skin = {}

    Layout_inner_outer_tex(skin, E.K, E.K:neighbor(E.side))

    -- build something

    local T = Trans.edge_transform(E.K.x1, E.K.y1, E.K.x2, E.K.y2, nil,
                                   E.side, long1, long2, 0, deep)

    local fab = Fab_create("WALL")

    Fab_apply_skins(fab, { R.skin or {}, skin })

    Fab_transform_XY(fab, T)

    fab.room = R
    table.insert(R.prefabs, fab)
  end


  local function flesh_out_edge(E)
    -- NOTE: assumes no more than one span so far
    local SP = E.spans[1]

    if SP then
      local span_L = SP.long1
      local span_R = SP.long2

      -- FIXME: key stuff / torches on either side of door

      flesh_out_range(E, E.long_L, E.deep_L, span_L, SP.deep1)
      flesh_out_range(E, span_R, SP.deep2, E.long_R, E.deep_R)
    else
      flesh_out_range(E, E.long_L, E.deep_L, E.long_R, E.deep_R)
    end
  end


  ---| Layout_flesh_out_walls |---

  for _,K in ipairs(R.sections) do
    for _,E in pairs(K.edges) do
      edge_extents(E)
      flesh_out_edge(E)
    end
  end
end



function Layout_all_walls()
  for _,R in ipairs(LEVEL.all_rooms) do
    Layout_used_walls(R)
  end

  for _,R in ipairs(LEVEL.all_rooms) do
   Layout_picture_hack(R)
   Layout_make_corners(R)
   Layout_flesh_out_walls(R)
  end
end



function Layout_build_walls(R)
  for _,fab in ipairs(R.prefabs) do
    if fab.room == R and not fab.rendered then

      if not fab.bumped then
        local z = fab.air_z or R.floor_max_h
        assert(z)

        Fab_transform_Z(fab, { add_z = z })
      end

      Fab_render(fab)
    end
  end
end


