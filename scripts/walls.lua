----------------------------------------------------------------
--  V4 WALL Layouting
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2010 Andrew Apted
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


  local function inner_outer_tex(skin, R, N)
    assert(R)
    if not N then return end

    skin.wall  = R.skin.wall
    skin.outer = N.skin.wall

    if R.outdoor and not N.outdoor then
      skin.wall  = skin.outer
    elseif N.outdoor and not R.outdoor then
      skin.outer = skin.inner
    end
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

    for name,_ in pairs(fabs) do
      local skin = GAME.SKINS[name]
      if not skin then
        error("No such skin: " .. tostring(name))
      end

      if is_minimal_edge(skin) then
        gui.printf("  minimal_fab @ %s:%d ---> %s\n", E.K:tostr(), E.side, name)
        E.minimal = { skin=skin }
        break;
      end
    end

    if not E.minimal then
      gui.printf("E.usage =\n%s\n", table.tostr(E.usage, 2))
      error("Lacking minimal prefab for: " .. tostring(E.usage.kind))
    end

    if E.usage.kind == "door" and E.usage.conn.lock and E.usage.conn.lock.kind == "SWITCH" then
      E.usage.conn.lock.switches = assert(E.minimal.skin._switches)
    end

    local extra_skins = {}

local CRUD = { item="none", outer="_ERROR",track="_ERROR",frame="_ERROR",
               rail="STEPTOP", metal="METAL", }
table.insert(extra_skins, CRUD)

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

  local function adjust_corner(C, side, long, deep)
    if geom.is_vert(side) then
      C.horiz = math.min(C.horiz, long)
--    C.vert  = math.min(C.vert,  deep)
    else
      C.vert  = math.min(C.vert,  long)
--    C.horiz = math.min(C.horiz, deep)
    end
  end


  local function adjust_corner_sizes(E)
    local long_L, deep_L
    local long_R, deep_R

    if E.spans[1] then
      long_L = E.spans[1].long1
      deep_L = E.spans[1].deep1

      long_R = E.real_len - E.spans[#E.spans].long2
      deep_R = E.spans[#E.spans].deep2

      if E.corn_L then
        adjust_corner(E.corn_L, E.side, long_L, deep_L)
      end

      if E.corn_R then
        adjust_corner(E.corn_R, E.side, long_R, deep_R)
      end
    end
  end


  local function decide_corner_sizes()
    for _,R in ipairs(LEVEL.all_rooms) do
      for _,K in ipairs(R.sections) do
        for _,C in pairs(K.corners) do
          if C.concave then
            C.horiz = 64
            C.vert  = 64
          else
            C.horiz = 72
            C.vert  = 72
          end
        end
      end
      for _,K in ipairs(R.sections) do
        for _,E in pairs(K.edges) do
---       adjust_corner_sizes(E)
        end
      end
    end
  end


  local function make_corner(C)
    -- FIXME
  end


  ---| Layout_make_corners |---

  for _,K in ipairs(R.sections) do
    for _,C in pairs(K.corners) do
      make_corner(C)
    end
  end
end



function Layout_flesh_out_walls(R)
  --
  -- the goal of this function is to fill in the gaps along walls
  -- with either prefabs or trapezoid-shaped brushes.
  --

  function flesh_out_edge(E)
    -- FIXME
  end

  ---| Layout_flesh_out_walls |---

  for _,K in ipairs(R.sections) do
    for _,E in pairs(K.edges) do
      flesh_out_edge(E)
    end
  end
end



function Layout_all_walls()
  for _,R in ipairs(LEVEL.all_rooms) do
    Layout_used_walls(R)
  end

  for _,R in ipairs(LEVEL.all_rooms) do
   Layout_make_corners(R)
   Layout_flesh_out_walls(R)
  end
end



function Layout_build_walls(R)
  for _,fab in ipairs(R.prefabs) do
    if fab.room == R and not fab.rendered then

      if not fab.bumped then
        --FIXME !!!!!!!! TEMP CRUD
        local T = { add_z = R.entry_floor_h or 256 }

        Fab_transform_Z(fab, T)
      end

      Fab_render(fab)
    end
  end
end


