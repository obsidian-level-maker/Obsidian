----------------------------------------------------------------
--  V4 Layouting Logic
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

  long  --  real length of edge

  corn1, corn2 : CORNER

  L_long, R_long  -- length allocated to corners
  L_deep, R_deep  -- depth (sticking out) at corners

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


----------------------------------------------------------------]]

require 'defs'
require 'util'


-- FIXME: appropriate place
DOOR_SILVER_KEY = 16
DOOR_GOLD_KEY   = 8


function Layout_initial_space(R)
  local S = SPACE_CLASS.new()

  if R.shape == "rect" then
    local K1 = SECTIONS[R.kx1][R.ky1]
    local K2 = SECTIONS[R.kx2][R.ky2]

    S:initial_rect(K1.x1, K1.y1, K2.x2, K2.y2)
  else
    for _,K in ipairs(R.sections) do
      S:initial_rect(K.x1, K.y1, K.x2, K.y2)
    end
  end

  return S
end


function Layout_monotonic_spaces(R)
  -- Monotonic here means that if you cut the space in half either
  -- horizontally or vertically, you will always end up with two
  -- contiguous pieces.
  --
  -- Rectangles, regular polygons, axis-aligned L shapes are all
  -- monotonic.  A counter example is a U shape, which if you cut it
  -- horizontally the top half will have two separated bits.
  --
  -- ALGORITHM:
  --   the basic idea is that "allocating" a free square will
  --   check each side, if the neighbor is solid then all free
  --   squares beyond that solid get "shadowed" and cannot be
  --   allocated for the current group.  The next square can be
  --   a free non-shadowed neighbor of one of the used squares.

  local list = {}
  local pass = 1


  local function starter()
    for x = R.kx1,R.kx2 do for y = R.ky1,R.ky2 do
      local K = SECTIONS[x][y]
      if K.room == R and not K.m_used then
        return K
      end
    end end

    return nil, nil  -- no more free squares
  end


  local function clear_shadows()
    for x = R.kx1,R.kx2 do for y = R.ky1,R.ky2 do
      local K = SECTIONS[x][y]
      K.m_shadowed = nil
    end end
  end


  local function alloc(K)
    assert(not K.m_used)
    assert(not K.m_shadowed)

    K.m_used = pass

    for side = 2,8,2 do
      local N = K:neighbor(side)

      if N and N.room ~= R then
        -- do the shadowing
        for dist = 2,60 do
          local P = K:neighbor(side, dist)
          if not P then break; end

          if P.room == R then
            P.m_shadowed = pass
          end
        end
      end
    end
  end


  local function find_next()
    for x = R.kx1,R.kx2 do for y = R.ky1,R.ky2 do
      local K = SECTIONS[x][y]
      if K.room == R and K.m_used == pass then

        for side = 2,8,2 do
          local N = K:neighbor(side)
          if N and N.room == R and not (N.m_used or N.m_shadowed) then
            return N
          end
        end
        
      end
    end end

    return nil  -- nothing usable
  end


  local function grab_space()
    clear_shadows()

    local K = starter()

    if not K then  -- finished?
      return false
    end

    local INFO =
    {
      sections = {},

      space = SPACE_CLASS.new(),

      blocks = {},
    }

    table.insert(list, INFO)

    repeat
      table.insert(INFO.sections, K)

      INFO.space:initial_rect(K.x1, K.y1, K.x2, K.y2)

      alloc(K)

      K = find_next()
    until not K

    return true
  end


  local function dump_space()
    gui.debugf("space %d:\n", pass)

    for y = R.ky2,R.ky1,-1 do
      local line = ""
      for x = R.kx1,R.kx2 do
        local K = SECTIONS[x][y]

        if K.room ~= R then
          line = line .. "#"
        elseif K.m_used == pass then
          line = line .. "/"
        elseif K.m_used or K.m_shadowed then
          line = line .. "-"
        else
          line = line .. " "
        end
      end
      gui.debugf("  #%s#\n", line)
    end

    gui.debugf("\n")
  end


  local function block_is_contig(kx1, ky1, kw, kh)
    local kx2 = kx1 + kw - 1
    local ky2 = ky1 + kh - 1

    if kx2 > R.kx2 or ky2 > R.ky2 then
      return false
    end

    local id = SECTIONS[kx1][ky1].m_used

    for x = kx1,kx2 do for y = ky1,ky2 do
      local K = SECTIONS[x][y]
      if K.room ~= R    then return false end
      if K.m_used ~= id then return false end
      if K.contig_used  then return false end
    end end

    return true
  end


  local function mark_block(x, y, kw, kh)
    for dx = 0,kw-1 do for dy = 0,kh-1 do
      SECTIONS[x+dx][y+dy].contig_used = true
    end end
  end


  local function biggest_block(x, y)
    local kw, kh = 1,1

    if R.shape == "rect" then return R.kw, R.kh end

    while true do
      if block_is_contig(x, y, kw+1, kh) then
        kw = kw + 1
      elseif block_is_contig(x, y, kw, kh+1) then
        kh = kh + 1
      else
        return kw, kh
      end
    end
  end


  local function break_into_blocks()
    gui.debugf("Blocks:\n")

    for x = R.kx1,R.kx2 do for y = R.ky1,R.ky2 do
      local K = SECTIONS[x][y]
      if K.room == R and not K.contig_used then

        local kw,kh = biggest_block(x, y)
        mark_block(x, y, kw, kh)

        local BLOCK = { kx1=x, ky1=y, kx2=x+kw-1, ky2=y+kh-1 }

        table.insert(list[K.m_used].blocks, BLOCK)

        gui.debugf("  space:%d  K: (%d %d) .. (%d %d)\n", K.m_used,
                   BLOCK.kx1, BLOCK.ky1, BLOCK.kx2, BLOCK.ky2)
      end
    end end

    gui.debugf("\n")
  end

  
  --| Layout_monotonic_spaces |--

  gui.debugf("Monotonic spaces in %s\n", R:tostr())

  while grab_space() do
    dump_space()

    pass = pass + 1
  end

  break_into_blocks()

  return list
end



function Layout_add_span(E, long1, long2, deep, kind)

-- stderrf("********** add_span %s @ %s : %d\n", kind, E.K:tostr(), E.side)

  assert(long2 > long1)

  assert(E.usage)

  -- check if valid

  assert(long1 >= 16)
  assert(long2 <= E.long - 16)

  -- corner check
  if E.L_long then assert(long1 >= E.L_long) end
  if E.R_long then assert(long2 <= E.R_long) end

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


function Layout_place_straddlers()
  -- Straddlers are architecture which sits across two rooms.
  -- Currently there are only two kinds: DOORS and WINDOWS.
  -- 
  -- There are placed (i.e. allocated on a 2D map) before
  -- everything else.  The actual prefab and heights will be
  -- decided later in the normal layout code.

  local function place_straddler(kind, K, N, dir)
    R = K.room

    local long = geom.vert_sel(dir, K.x2 - K.x1, K.y2 - K.y1)

    assert(long >= 256)

    local deep
    
    if kind == "door" then
      long = 208
      deep = 128
    else
      -- windows use most of the length
      long = long - 72*2
      deep = 32
    end

    -- FIXME : pick these properly
    local deep1 = deep / 2
    local deep2 = deep / 2


    local STRADDLER = { kind=kind, K=K, N=N, dir=dir,
                        long=long, out=deep1, back=deep2,
                      }

    assert(K.edges[dir])
    assert(N.edges[10-dir])

    K.edges[dir]   .straddler = STRADDLER
    N.edges[10-dir].straddler = STRADDLER


    local edge_long = K.edges[dir].long

    local long1 = (edge_long - long) / 2
    local long2 = (edge_long + long) / 2


    local SP
    
    SP = Layout_add_span(K.edges[dir], long1, long2, deep1, kind)
    SP.usage = "straddler"
    SP.straddler = STRADDLER

    -- NOTE: if not centred, would need different long1/long2 for other side
    SP = Layout_add_span(N.edges[10-dir], long1, long2, deep2, kind)
    SP.usage = "straddler"
    SP.straddler = STRADDLER

    return STRADDLER
  end


  ---| Layout_place_straddlers |---

  -- do doors after windows, as doors may want to become really big
  -- and hence would need to know about the windows.

  for _,R in ipairs(LEVEL.all_rooms) do
    for _,K in ipairs(R.sections) do
      for _,E in pairs(K.edges) do
        if E.usage and E.usage.kind == "window" and not E.usage.placed then
          local W = E.usage
          place_straddler("window", W.K1, W.K2, W.dir)
          E.usage.placed = true
        end
      end
    end
  end

  for _,R in ipairs(LEVEL.all_rooms) do
    for _,K in ipairs(R.sections) do
      for _,E in pairs(K.edges) do
        if E.usage and E.usage.kind == "door" and not E.usage.placed then
          local C = E.usage.conn
          local STR = place_straddler("door", C.K1, C.K2, C.dir)
          STR.conn = C
          E.usage.placed = true
        end
      end
    end
  end
end



function Layout_check_brush(coords, data)
  local R = data.R

  local allow = true

  local mode
  local m = coords[1].m

      if m == "used" then
    mode = "solid" ; allow = false
  elseif m == "walk" then
    mode = "walk" ; allow = false
  elseif m == "air" then
    mode = "air" ; allow = false
  elseif not m or m == "solid" or m == "sky" then
    mode = "solid"
  else
    -- don't update the space (e.g. light brushes)
  end

  if mode then
    local POLY = POLYGON_CLASS.from_brush(mode, coords)
    table.insert(data.polys, POLY:copy())
    R.wall_space:merge(POLY)
  end

  return false
end


function Layout_shrunk_section_coords(K)
  local x1, y1 = K.x1, K.y1
  local x2, y2 = K.x2, K.y2

  if not K:same_room(4) then K.x1 = K.x1 + 8 end
  if not K:same_room(6) then K.x2 = K.x2 - 8 end
  if not K:same_room(2) then K.y1 = K.y1 + 8 end
  if not K:same_room(8) then K.y2 = K.y2 - 8 end

  return x1,y1, x2,y2
end



function Layout_place_importants()

  local function pick_imp_spot(IM, middles, corners, walls)
    for loop = 3,19 do
      if rand.odds(loop * 10) and #middles > 0 then
        IM.place_kind = "MIDDLE"
        IM.place_K = table.remove(middles, 1)
        IM.place_K.usage = { kind="important" }

gui.debugf("IMPORTANT '%s' in middle of %s\n", IM.kind, IM.place_K:tostr())

        if IM.lock and IM.lock.kind == "KEY" then
          IM.prefab = "OCTO_PEDESTAL"
          IM.skin = { item = IM.lock.item, top = "CEIL1_2", base = "FLAT1" }
        end

        return
      end

      if rand.odds(loop * 10) and #walls > 0 then
        IM.place_kind = "WALL"
        IM.place_E = table.remove(walls, 1)
        IM.place_E.usage = { kind="important" }
gui.debugf("IMPORTANT '%s' on WALL:%d of %s\n", IM.kind, IM.place_E.side, IM.place_E.K:tostr())

        local E = IM.place_E

        local prefab, skin
        local long, deep

        if IM.kind == "START" then
          prefab = "START_LEDGE"
          skin = {}
          long = 200
          deep = 128
        
        elseif IM.kind == "EXIT" then
          prefab = "WALL_SWITCH"
          skin = { line_kind=11, switch="SW1HOT", x_offset=0, y_offset=0 }
          long = 200
          deep = 64

        elseif IM.lock and IM.lock.kind == "SWITCH" then
          if GAME.format == "quake" then
            prefab = "QUAKE_WALL_SWITCH"
            skin = { target = string.format("t%d", IM.lock.tag), }
            long = 192
            deep = 32
          else
            prefab = "WALL_SWITCH"
            skin = { line_kind=103, tag=IM.lock.tag, switch="SW1BLUE", x_offset=0, y_offset=0 }
            long = 200
            deep = 64
          end

        elseif IM.lock and IM.lock.kind == "KEY" then
          prefab = "ITEM_NICHE"
          skin = { item = IM.lock.item }
          long = 200
          deep = 64

        else
          prefab = "ITEM_NICHE"
          skin = { item = "mega", key="LITE5" }
          long = 200
          deep = 64
        end

        local long1 = int(E.long - long) / 2
        local long2 = int(E.long + long) / 2

        local SP = Layout_add_span(E, long1, long2, deep, prefab)

        SP.usage = "prefab"
        SP.prefab = prefab
        SP.skin = skin

        return
      end

      if rand.odds(loop * 10) and #corners > 0 then
        IM.place_kind = "CORNER"
        IM.place_C = table.remove(corners, 1)
        IM.place_C.usage = { kind="important" }
gui.debugf("IMPORTANT '%s' in CORNER:%d of %s\n", IM.kind, IM.place_C.side, IM.place_C.K:tostr())
        return
      end
    end

    -- TODO: allow up to 4 stuff in a "middle" (subdivide section 2 or 4 ways)

    error("could not place important stuff!")
  end


  local function collect_free_edges(R, edges, corners, middles)
    for _,K in ipairs(R.sections) do
      if not K.usage then
        table.insert(middles, K)
      end

      for _,C in pairs(K.corners) do
        if not C.usage then
          table.insert(corners, C)
        end
      end
      
      for _,E in pairs(K.edges) do
        if not E.usage then
          table.insert(edges, E)
        end
      end
    end
  end


  local function place_importants(R)
    -- determine available places

    local edges   = {}
    local corners = {}
    local middles = {}

    collect_free_edges(R, edges, corners, middles)


    table.sort(middles, function(A, B) return A.num_conn < B.num_conn end)

    rand.shuffle(corners)
    rand.shuffle(edges)

    R.middles = middles

    -- determine the stuff which MUST go into this room

    R.importants = {}

    if R.purpose then
      table.insert(R.importants, { kind=R.purpose, lock=R.purpose_lock })
    end

    if R:has_teleporter() then
      table.insert(R.importants, { kind="TELEPORTER" })
    end

--[[ FIXME (currently added by pickup code)
    if R.weapon then
      table.insert(R.importants, { kind="WEAPON" })
    end
--]]

    -- TODO: more combinations, check what prefabs can be used

    for _,IM in ipairs(R.importants) do

      if false then --!!! FIXME  IM.kind == "SOLUTION" and IM.lock and IM.lock.kind == "KEY" then
        pick_imp_spot(IM, middles, {}, {})
      else
        pick_imp_spot(IM, {}, {}, edges)
      end
    end
  end


  --| Layout_place_importants |--

  for _,R in ipairs(LEVEL.all_rooms) do
    place_importants(R)
  end
end



function Layout_the_room(R)


--  R.entry_conn

--  if R.purpose then add_purpose() end
--  if R:has_teleporter() then add_teleporter() end
--  if R.weapon  then add_weapon(R.weapon)  end


  local function edge_near_corner(corn, want_horiz)
    -- want_horiz : true for the edge travelling horizontally,
    --              false for the vertical edge
    local side

    if want_horiz then
      side = sel(corn.side == 1 or corn.side == 3, 2, 8)
    else
      side = sel(corn.side == 1 or corn.side == 7, 4, 6)
    end

    if not corn.concave then
      return assert(corn.K.edges[side])
    end

    -- trickier for concave corners, edge is in a different section
    local kx = corn.K.kx
    local ky = corn.K.ky

    local dx, dy = geom.delta(corn.side)

    if want_horiz then
      kx = kx + dx
    else
      ky = ky + dx
    end

    assert(Plan_is_section_valid(kx, ky))

    local K = SECTIONS[kx][ky]
    assert(K.room == corn.K.room)

    return assert(K.edges[side])
  end


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
    local L_long, L_deep
    local R_long, R_deep

    if E.spans[1] then
      L_long = E.spans[1].long1
      L_deep = E.spans[1].deep1

      R_long = E.long - E.spans[#E.spans].long2
      R_deep = E.spans[#E.spans].deep2

      if E.corn1 then
        adjust_corner(E.corn1, E.side, L_long, L_deep)
      end

      if E.corn2 then
        adjust_corner(E.corn2, E.side, L_long, L_deep)
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


  local function Fab_with_update(fab, T, skin1, skin2, skin3) 
    gui.debugf("Fab_with_update : %s\n", tostring(fab))

    local POST_FAB =
    {
      fab = fab,
      trans = T,

      skin1 = skin1,
      skin2 = skin2,
      skin3 = skin3,

      R = R,
      fab_tag = Plan_alloc_id("prefab"),

      polys = {},
    }

    -- save info to render it later
    -- FIXME: only process the skins ONCE
    table.insert(R.post_fabs, POST_FAB)

    Trans.set_override(Layout_check_brush, POST_FAB, true)

    Fabricate(fab, T, skin1, skin2, skin3)

    Trans.clear_override()

    -- associate the walk/air polygons to this POST-FAB
    if not (fab == "MARK_USED" or fab == "MARK_WALK" or fab == "MARK_AIR") then
      for _,P in ipairs(POST_FAB.polys) do
        if P.kind == "walk" or P.kind == "air" then
          P.post_fab = POST_FAB
          table.insert(R.poly_assoc, P)
        end
      end
    end

    return POST_FAB
  end


  local function inner_outer_tex(skin, R, N)
    assert(R)
    if not N then return end

    if R.outdoor and not N.outdoor then
      skin.wall = N.skin.wall
    end

    if N.outdoor and not R.outdoor then
      skin.outer = R.skin.wall
    else
      skin.outer = N.skin.wall
    end
  end


  local function build_corner(C)
    local K = C.K
    
    local T = Trans.corner_transform(K.x1, K.y1, K.x2, K.y2, ROOM.entry_floor_h,
                                     C.side, C.horiz, C.vert)

    local fab = "CORNER" -- sel(C.concave, "CORNER_CONCAVE_CURVED", "CORNER_CURVED")

    Fab_with_update(fab, T)
  end


  local function build_wall(E, SP)
    assert(SP.long1 < SP.long2)
    assert(SP.deep1 > 0)

    local K = E.K

    local T = Trans.edge_transform(K.x1, K.y1, K.x2, K.y2, ROOM.entry_floor_h,
                                   E.side, SP.long1, SP.long2, 0, SP.deep1)
  
    local fab = "WALL"
    local skin = {}

if SP.long2 >= SP.long1+128 then fab = "PICTURE" end

    local N = E.K:neighbor(E.side)

    inner_outer_tex(skin, E.K.room, N and N.room)

    Fab_with_update(fab, T, skin)
  end


  local function build_fake_span(E, long1, long2)
    assert(long2 > long1)

    local deep = 64
    
    local SPAN =
    {
      long1 = long1,
      long2 = long2,
      deep1 = deep,
      deep2 = deep,
      usage = "fake"
    }

    build_wall(E, SPAN)

    E.fake_deep = deep  -- FIXME hack
  end


  local function do_straddler_solid(E, SP, same_room, POST_FAB)
    local K = E.K
    local info = assert(SP.straddler)

    local gap = 80 -- FIXME put in span and/or STRADDLER

    local T = Trans.edge_transform(K.x1, K.y1, K.x2, K.y2, ROOM.entry_floor_h, E.side,
                                   SP.long1, SP.long2, 0, SP.deep1)

    Fab_with_update("MARK_USED", T)

    local T = Trans.edge_transform(K.x1, K.y1, K.x2, K.y2, ROOM.entry_floor_h, E.side,
                                   SP.long1, SP.long2, SP.deep1, SP.deep1 + gap)

    local PF

    if info.kind == "window" then
      PF = Fab_with_update("MARK_AIR", T)
    else
      PF = Fab_with_update("MARK_WALK", T)
    end

    -- associate the walk/area polygons with this prefab (if any)
gui.debugf("########################### MARK_WALK ##################\n")
      for _,P in ipairs(PF.polys) do
        if P.kind == "walk" or P.kind == "air" then
gui.debugf("found one: kind = %s  fab = %s\n", P.kind, (POST_FAB and POST_FAB.fab) or "NONE")
          P.post_fab = POST_FAB
          table.insert(R.poly_assoc, P)
        end

        -- find the entry walk area (a bit presumptuous)
        if P.kind == "walk" and not same_room then
          P.is_entry = true
        end
      end
  end


  local function build_straddler_span(kind, E, SP, z, back, fab, skin1, skin2, skin3)
    local K = E.K

    local T = Trans.edge_transform(K.x1, K.y1, K.x2, K.y2, z, E.side,
                                   SP.long1, SP.long2, -back, SP.deep1)

    -- Note: not using Fab_with_update() for automatic space updating,
    --       because straddlers affect TWO rooms at the same time.
    --       instead we mark the quads directly.

    local POST_FAB =
    {
      fab = fab,
      trans = T,

      skin1 = skin1,
      skin2 = skin2,
      skin3 = skin3,

      R = R,
      fab_tag = Plan_alloc_id("prefab"),
    }

    if kind == "window" then
      POST_FAB.z = z
    end

    table.insert(R.post_fabs, POST_FAB)

    return POST_FAB
  end


  local function build_straddler(E, SP)
    local K = E.K

    local info = assert(SP.straddler)


    local back = info.back

    local other_R = info.N.room

    if ROOM ~= info.K.room then
      other_R = info.K.room
      back = info.out
    end


    local fab
    local z = ROOM.entry_floor_h

    local skin = {}
    local sk2
    local sk3


    inner_outer_tex(skin, ROOM, other_R)


    if info.kind == "window" then
      fab = "WINDOW_W_BARS"
      if R.outdoor and other_R.outdoor then fab = "FENCE" end
      z = math.max(z, other_R.floor_min_h or 0)
      z = z + 32
      sk2 = { frame="METAL1_1" }
    elseif GAME.format == "quake" then
      fab = "QUAKE_ARCH"
      sk2 = { frame="METAL1_1" }

      if info.conn and info.conn.lock then
        fab = "QUAKE_DOOR"
        sk2 = { door="DOOR01_2" }
        if info.conn.lock.item == "k_silver" then sk2.door_flags = DOOR_SILVER_KEY end
        if info.conn.lock.item == "k_gold"   then sk2.door_flags = DOOR_GOLD_KEY end

        if info.conn.lock.kind == "SWITCH" then
          sk2.door = "ADOOR09_1"
          sk2.targetname = string.format("t%d", info.conn.lock.tag)
          sk2.message = "Find the button dude!"
          sk2.wait = -1
        end
      end
    else
      fab = "DOOR"

      if info.conn and info.conn.lock then
        sk2 = GAME.DOORS[info.conn.lock.item]
        sk3 = { tag = info.conn.lock.tag }
      else
        sk2 = GAME.DOORS["silver"]
        sk2.door = "BIGDOOR4"

        -- TEST
        fab = "ARCH_W_STAIR"
        sk2.top = "FLAT1"
        sk2.step = "FLAT23"
      end
      assert(sk2)
    end


    local long1 = SP.long1
    local long2 = SP.long2

    local long = long2 - long1
    local count = 1


    local fab_info = assert(PREFAB[fab])

    if fab_info.repeat_width and (long / fab_info.repeat_width) >= 2 then
      count = int(long / fab_info.repeat_width)
    end


    -- build it only once :
    --    DOOR on first room (as it sets up the initial floor height for second room) 
    --    WINDOW on second room (since there it knows height range on both sides)

    if info.kind == "window" then
      if not info.seen then
        info.seen = true
        do_straddler_solid(E, SP, false)
        return
      end
    else
      if info.built then
        do_straddler_solid(E, SP, false)
        return
      end
      info.built = true
    end


    gui.debugf("Building straddler %s at %s side:%d\n", fab, K:tostr(), E.side)

    -- TODO: might be better to do the "repeat" thing in render_post_fab()
    --       instead of here

    local POST_FAB

    for i = 1,count do
      SP.long1 = long1
      SP.long2 = long2

      if i > 1     then SP.long1 = long1 + int(long * (i-1) / count) end
      if i < count then SP.long2 = long1 + int(long * (i)   / count) end

      POST_FAB = build_straddler_span(info.kind, E, SP, z, back, fab, skin, sk2, sk3)

      do_straddler_solid(E, SP, true, POST_FAB)
    end


    -- setup door prefab to transmit height to next room
    -- (cannot be done here, we don't know the height yet)

    if info.kind == "door" then
      POST_FAB.set_height_in = other_R
      -- TODO: if any Z scaling, apply to room_dz
      POST_FAB.set_height_dz =   (fab_info.room_dz or 0)
    end
  end


  local function build_edge_prefab(E, SP)
    assert(SP.prefab)
    assert(SP.skin)

    local K = E.K
    local z = ROOM.entry_floor_h

-- stderrf("build_edge_prefab: %s @ z:%d\n", SP.prefab, z)

    local T = Trans.edge_transform(K.x1, K.y1, K.x2, K.y2, z, E.side,
                                   SP.long1, SP.long2, 0, SP.deep1)

    Fab_with_update(SP.prefab, T, SP.skin)
  end


  local function build_edge(E)
    local max_deep = 0

    local L_long = 0
    local R_long = E.long

    local goes_horiz = geom.is_vert(E.side)
    
    if E.corn1 and not E.corn1.concave then
      L_long = sel(goes_horiz, E.corn1.horiz, E.corn1.vert)
    end

    if E.corn2 and not E.corn2.concave then
      R_long = E.long - sel(goes_horiz, E.corn2.horiz, E.corn2.vert)
    end

    for _,SP in ipairs(E.spans) do
      if SP.long1 > L_long+1 then
        build_fake_span(E, L_long, SP.long1)
      end

      if SP.usage == "straddler" then
        build_straddler(E, SP)
      else
        build_edge_prefab(E, SP)
      end

      if SP.deep1 > max_deep then max_deep = SP.deep1 end

      L_long = SP.long2
    end

    if R_long > L_long then
      build_fake_span(E, L_long, R_long)
    end

    E.max_deep = math.max(max_deep, E.fake_deep or 0)
  end


  local function build_corners()
    for _,K in ipairs(R.sections) do
      for _,C in pairs(K.corners) do
        build_corner(C)
      end
    end
  end

  local function build_edges()
    for _,K in ipairs(R.sections) do
      for _,E in pairs(K.edges) do
        build_edge(E)
      end
    end
  end


  local function build_middles()
    for _,K in ipairs(R.middles) do
      local w, h = geom.box_size(K.x1, K.y1, K.x2, K.y2)
      if w >= 600 and h >= 600 then
        
        local mx, my = geom.box_mid(K.x1, K.y1, K.x2, K.y2)

        local T = Trans.spot_transform(mx, my, ROOM.entry_floor_h)

        fab = "TECH_DITTO_1"
        skin = { carpet = "FLAT14", computer = "SPACEW3",
                 compside = "COMPSPAN", feet = "FLAT4" }

--      local fab = "CAGE"
--      local skin = { pillar="GRAY5", rail="MIDGRATE" }


        Fab_with_update(fab, T, skin)
      end
    end

    for _,IM in ipairs(R.importants) do
      if IM.place_K and IM.prefab then
        local K = IM.place_K
        local mx, my = geom.box_mid(K.x1, K.y1, K.x2, K.y2)

        local T = Trans.spot_transform(mx, my, ROOM.entry_floor_h)
        
        Fab_with_update(IM.prefab, T, IM.skin)
      end
    end
  end


  local function fill_polygons(space, values)
    for _,P in ipairs(space.polys) do
      local val = values[P.kind]
      if val then
        gui.spots_fill_poly(val, P.coords)
      end
    end
  end


  local function merge_walks(polys, tag1, tag2)
    if tag1 > tag2 then
      tag1, tag2 = tag2, tag1
    end

    for _,P in ipairs(polys) do
      if P.walk_tag == tag2 then
         P.walk_tag = tag1
      end
    end
  end


  local function try_merge_walks(polys, P1, P2)
    if P1.walk_tag == P2.walk_tag then
      return
    end

    if P1:touches(P2) then
      merge_walks(polys, P1.walk_tag, P2.walk_tag)
    end
  end


  local function collect_walk_groups()
    -- first collect the walk polys
    local walk_polys = {}

    for idx,P in ipairs(R.poly_assoc) do
      if P.kind == "walk" then
        P.walk_tag = idx
gui.debugf("walk poly #%d kind:%s fab:%s  loc: (%d %d)\n",
           idx, P.kind, (P.post_fab and P.post_fab.fab) or "NONE", P.bx1, P.by1)
        table.insert(walk_polys, P)
      end
    end
gui.debugf("walk_polys: %d\n", #walk_polys)

    -- now merge tags of walk areas which touch / overlap
    for pn1 = 1,#walk_polys do
      for pn2 = pn1+1,#walk_polys do
        local P1 = walk_polys[pn1]
        local P2 = walk_polys[pn1]
        try_merge_walks(walk_polys, P1, P2)
      end
    end

    -- finally collect all polys with same walk_tag, and compute bbox
    local walk_groups  = {}
    local tag_to_group = {}

    for _,P in ipairs(walk_polys) do
      local GROUP = tag_to_group[P.walk_tag]
      if not GROUP then
        GROUP = { polys={} }
        table.insert(walk_groups, GROUP)
        tag_to_group[P.walk_tag] = GROUP
      end
      table.insert(GROUP.polys, P)
    end

gui.debugf("%s has %d walk groups:\n", R:tostr(), #walk_groups)

    for _,G in ipairs(walk_groups) do
      -- FIXME: big hack (assumes GROUP == SPACE)
      G.x1, G.y1, G.x2, G.y2 = SPACE_CLASS.calc_bbox(G)

---## stderrf("  polys:%d  bbox: (%d %d) .. (%d %d)\n",
---##        #G.polys, G.x1, G.y1, G.x2, G.y2)
    end  

    return walk_groups
  end


  local function collect_airs()
    local air_polys = {}

    for idx,P in ipairs(R.poly_assoc) do
      if P.kind == "air" then
        table.insert(air_polys, P)
      end
    end

    return air_polys
  end


  local function narrow_zone_for_edge(zone, E)
    if not E.max_deep then return end

    local K = E.K

    if E.side == 4 then
      local x = K.x1 + E.max_deep
      if x > zone.x1 then zone.x1 = x end

    elseif E.side == 6 then
      local x = K.x2 - E.max_deep
      if x < zone.x2 then zone.x2 = x end

    elseif E.side == 2 then
      local y = K.y1 + E.max_deep
      if y > zone.y1 then zone.y1 = y end

    elseif E.side == 8 then
      local y = K.y2 - E.max_deep
      if y < zone.y2 then zone.y2 = y end

    else
      error("bad edge side")
    end
  end

  
  local function narrow_zone_for_walk(zone, G)
    -- this is meant to handle a walk group penetrating a small
    -- distance into one side of the zone.
    --
    -- it is NOT meant for a walk group IN THE MIDDLE of the zone
    -- (from a pickup or switch).  That should be prevented, e.g.
    -- create multiple zones around it.

    if zone.x2 < zone.x1 or zone.y2 < zone.y1 then
      return
    end

    if geom.boxes_overlap(zone.x1, zone.y1, zone.x2, zone.y2,
                          G.x1, G.y1, G.x2, G.y2)
    then
      local dx = math.max(16, zone.x2 - zone.x1)
      local dy = math.max(16, zone.y2 - zone.y1)

      -- pick side which wastes the least volume
      local vol_x1 = int(G.x2 - zone.x1) * int(dy)
      local vol_x2 = int(zone.x2 - G.x1) * int(dy)

      local vol_y1 = int(G.y2 - zone.y1) * int(dx)
      local vol_y2 = int(zone.y2 - G.y1) * int(dx)

      local min_vol = math.min(vol_x1, vol_y1, vol_x2, vol_y2)

          if vol_x1 == min_vol then zone.x1 = G.x2  -- move left side
      elseif vol_x2 == min_vol then zone.x2 = G.x1  -- move right side
      elseif vol_y1 == min_vol then zone.y1 = G.y2  -- move bottom side
      else                          zone.y2 = G.y1  -- move top side
      end
    end
  end


  local function zone_from_block(block, walks)
    local kx1, ky1 = block.kx1, block.ky1
    local kx2, ky2 = block.kx2, block.ky2

    local K1 = SECTIONS[kx1][ky1]
    local K2 = SECTIONS[kx2][ky2]

    local zone = 
    {
      x1 = K1.x1,
      y1 = K1.y1,
      x2 = K2.x2,
      y2 = K2.y2,
    }

    -- check wall edges

    for kx = kx1,kx2 do for ky = ky1,ky2 do
      local K = SECTIONS[kx][ky]
      for _,E in pairs(K.edges) do
        narrow_zone_for_edge(zone, E)
      end
    end end

    -- FIXME: check corners too

    -- allow some room for player
    zone.x1 = zone.x1 + 64
    zone.y1 = zone.y1 + 64
    zone.x2 = zone.x2 - 64
    zone.y2 = zone.y2 - 64

    -- check walk groups
    -- (done AFTER allowing some room for player, since walk areas
    --  already guarantee the player can fit).

    for _,G in ipairs(walks) do
      narrow_zone_for_walk(zone, G)
    end

    zone.x1 = zone.x1 + 8
    zone.y1 = zone.y1 + 8
    zone.x2 = zone.x2 - 8
    zone.y2 = zone.y2 - 8

    return zone
  end


  local function determine_safe_zones(mono, walks)
    --
    -- A "safe zone" is a rectangle inside the current room which
    -- could be make solid while still allowing the player to fully
    -- traverse the room (from one door to another etc).
    --
    -- Since safe zones must be rectangles, but rooms can be more
    -- interesting shapes (plus, L, odd) then we allow multiple
    -- (non overlapping) safe zones to exist.

    local list = {}

    for _,block in ipairs(mono.blocks) do
      local zone = zone_from_block(block, walks)

      if zone.x2 > zone.x1 and zone.y2 > zone.y1 then
        table.insert(list, zone)
      end
    end

    return list
  end


  local function neg_nb_coord(x)
    if not x then return nil end
    return -x
  end

  local function rotate_neighborhood_rect(NB, angle)
    local NB2 = table.copy(NB)

    if angle < 0 then angle = angle + 360 end
    
    if angle == 0 then
      -- nothing needed
    elseif angle == 90 then
      NB2.y1 = NB.x1
      NB2.y2 = NB.x2
      NB2.x1 = neg_nb_coord(NB.y2)
      NB2.x2 = neg_nb_coord(NB.y1)
    elseif angle == 180 then
      NB2.x1 = neg_nb_coord(NB.x2)
      NB2.x2 = neg_nb_coord(NB.x1)
      NB2.y1 = neg_nb_coord(NB.y2)
      NB2.y2 = neg_nb_coord(NB.y1)
    elseif angle == 270 then
      NB2.x1 = NB.y1
      NB2.x2 = NB.y2
      NB2.y1 = neg_nb_coord(NB.x2)
      NB2.y2 = neg_nb_coord(NB.x1)
    else
      error("bad angle for rotate_neighborhood_rect: " .. tostring(angle))
    end

    return NB2
  end


  local function translate_neighborhood(list, loc)
    local new_nb = {}

    for _,NB in ipairs(list) do
      table.insert(new_nb, rotate_neighborhood_rect(NB, loc.rotate))
    end

    local base_x, base_y

        if loc.rotate ==   0 then base_x, base_y = loc.x1, loc.y1
    elseif loc.rotate ==  90 then base_x, base_y = loc.x2, loc.y1
    elseif loc.rotate == 180 then base_x, base_y = loc.x2, loc.y2
    elseif loc.rotate == 270 then base_x, base_y = loc.x1, loc.y2
    else error("Bad rotate in floor loc")
    end

    loc.base_x = base_x
    loc.base_y = base_y

    for _,NB in ipairs(new_nb) do
      if NB.x1 then NB.x1 = NB.x1 + base_x end
      if NB.y1 then NB.y1 = NB.y1 + base_y end

      if NB.x2 then NB.x2 = NB.x2 + base_x end
      if NB.y2 then NB.y2 = NB.y2 + base_y end
    end

    return new_nb
  end


  local function transmit_height(PF, z)
    if not PF.z or z > PF.z then
      PF.z = z
    end
  end


  local function transmit_height_to_fabs(floor, z)
    for _,PF in ipairs(floor.fabs) do
      transmit_height(PF, z)
    end
  end


  local function collect_floor_fabs(floor)
    for _,G in ipairs(floor.walks) do
      for _,P in ipairs(G.polys) do
        if P.post_fab then
          table.insert(floor.fabs, P.post_fab)
        end
      end

      if G.fabs then
        for _,PF in ipairs(G.fabs) do
          table.insert(floor.fabs, PF)
        end
      end
    end

    for _,A in ipairs(floor.airs) do
      if A.post_fab then
        table.insert(floor.fabs, A.post_fab)
      end
    end
  end


  local function render_floor(floor)
    assert(floor.z)

    local mat = R.skin.wall

    if not R.outdoor and THEME.building_floors then
      mat = rand.key_by_probs(THEME.building_floors)
    end

    local flavor = "floor:1"
    if floor.three_d then flavor = "exfloor:1" end

    for _,P in ipairs(floor.space.polys) do
      local BRUSH = P:to_brush(mat)

      table.insert(BRUSH, 1, { m="solid", flavor=flavor })
      table.insert(BRUSH,    { t=floor.z, tex=mat })

      if floor.three_d then
        table.insert(BRUSH,  { b=floor.z - floor.three_d, tex=mat })
      end

      Trans.brush(BRUSH)
    end
  end


  local function render_liquid(floor)
    assert(floor.z)

    for _,P in ipairs(floor.space.polys) do
      if GAME.format == "doom" then
        local BRUSH = P:to_brush("LAVA1")
        table.insert(BRUSH, { t=floor.z - 64, tex="LAVA1", special=16 })
        Trans.brush(BRUSH)

      else  -- QUAKE

        local mat = R.skin.wall
        local liq = "*lava1"

        local BRUSH = P:to_brush(mat)
        table.insert(BRUSH, { t=floor.z - 128, tex=mat })
        Trans.brush(BRUSH)

        local LIQUID = P:to_brush(liq)
        table.insert(LIQUID, 1, { m="liquid", medium="lava" })
        table.insert(LIQUID, { t=floor.z - 64, tex=liq })
        Trans.brush(LIQUID)
      end
    end
  end


  local function inside_nb_rect(NB, x1,y1, x2,y2)
    if NB.x1 and x1 < NB.x1 - 0.1 then return false end
    if NB.x2 and x2 > NB.x2 + 0.1 then return false end

    if NB.y1 and y1 < NB.y1 - 0.1 then return false end
    if NB.y2 and y2 > NB.y2 + 0.1 then return false end

    return true
  end


  local function find_walk_in_neighborhood(nb_list, x1,y1, x2,y2)

    -- FIXME: this fails if a walk group crosses the line where two
    --        rectangles of the same space touch.

    for _,NB in ipairs(nb_list) do
      if not NB.m then
        if inside_nb_rect(NB, x1,y1, x2,y2) then
          return assert(NB.space)
        end
      end
    end

    return -1  -- not found
  end


  local function transfer_walks(floor, loc, new_floors)
    for _,G in ipairs(floor.walks) do
      local space = find_walk_in_neighborhood(loc.neighborhood, G.x1,G.y1, G.x2,G.y2)
      
      assert(space >= 1)
      assert(new_floors[space])

      table.insert(new_floors[space].walks, G)
    end
  end


  local function transfer_airs(floor, loc, new_floors)
    -- air spaces may exist in both halves

    for _,A in ipairs(floor.airs) do
      local space = find_walk_in_neighborhood(loc.neighborhood, A.bx1,A.by1, A.bx2,A.by2)

      if space >= 1 then
        assert(new_floors[space])
        table.insert(new_floors[space].airs, A)
      else
        -- add it to all floors (FIXME)
        for _,F in ipairs(new_floors) do
          table.insert(F.airs, A)
        end
      end
    end
  end


  local function brush_bbox(coords)
    -- TODO
  end


  local function floor_check_brush(coords, data)
    local m = coords[1].m

    if m == "floor" then
      local space = coords[1].space
      if not space then
        error("bad or missing space field in floor brush")
      end

      local F = data.new_floors[space]
      local POLY = POLYGON_CLASS.from_brush("free", coords)

      F.space:merge(POLY)

    elseif m == "walk" then
      local space = coords[1].space
      if not space then
        error("bad or missing space field in walk brush")
      end

      local F = data.new_floors[space]
      local POLY = POLYGON_CLASS.from_brush("walk", coords)

      -- new walk group
      local G =
      {
        polys = { POLY },
        x1 = POLY.bx1, y1 = POLY.by1,
        x2 = POLY.bx2, y2 = POLY.by2,
        walk_dz = coords[1].walk_dz,
      }

      if G.walk_dz then data.walk_dz = G.walk_dz end

      table.insert(F.walks, G)

      if not data.new_walks[space] then
        data.new_walks[space] = G
      end
    end

    return false
  end


  local function check_floor_fab(floor, loc)
    -- Requirements:
    --   1. at least one walk group in each new space
    --   2. no walk group is "cut" by dividing lines

gui.debugf("check_floor_fab:\n%s\n", table.tostr(loc, 1))

    local fab_info = PREFAB[loc.fab]

    local neighborhood = translate_neighborhood(fab_info.neighborhood, loc)

    loc.neighborhood = neighborhood


    local num_spaces = fab_info.num_spaces or 2

    local walk_counts = {}

    for _,G in ipairs(floor.walks) do
      local space = find_walk_in_neighborhood(neighborhood, G.x1,G.y1, G.x2,G.y2)

      if space < 0 then
gui.debugf("  cut walk space: (%d %d) .. (%d %d)\n", G.x1,G.y1, G.x2,G.y2)
        return false  -- the group was cut
      end

      walk_counts[space] = 1
    end

gui.debugf("  walk counts: %d %d\n", walk_counts[1] or 0, walk_counts[2] or 0)
    for n = 1,num_spaces do
      if not walk_counts[n] then return false end
    end

    return true  -- OK
  end


  local function space_from_neighborhood(old_space, space_index, loc)
    local new_space = SPACE_CLASS.new()

    for _,NB in ipairs(loc.neighborhood) do
      if not NB.m and NB.space == space_index then
        local piece = old_space:intersect_rect(NB.x1, NB.y1, NB.x2, NB.y2)

        new_space:raw_union(piece)
      end
    end

    return new_space
  end


  local function zone_clip_to_nb(old_zone, NB)
    local new_zone = table.copy(old_zone)

    if NB.x1 and NB.x1 > new_zone.x1 then new_zone.x1 = NB.x1 end
    if NB.y1 and NB.y1 > new_zone.y1 then new_zone.y1 = NB.y1 end
    if NB.x2 and NB.x2 < new_zone.x2 then new_zone.x2 = NB.x2 end
    if NB.y2 and NB.y2 < new_zone.y2 then new_zone.y2 = NB.y2 end

    return new_zone
  end


  local function zones_from_neighborhood(old_list, space_index, loc)
    local new_list = {}

    for _,old_zone in ipairs(old_list) do
      for _,NB in ipairs(loc.neighborhood) do
        if NB.m == "zone" and NB.space == space_index then
          local zone = zone_clip_to_nb(old_zone, NB)

          if zone.x2 > zone.x1 and zone.y2 > zone.y1 then
            table.insert(new_list, zone)
          end
        end
      end
    end

    return new_list
  end


  local function liquid_from_neighborhood(old_space, loc)
    local new_space  -- return nothing if no liquid rects

    for _,NB in ipairs(loc.neighborhood) do
      if NB.m == "liquid" then
        if not new_space then
          new_space = SPACE_CLASS.new()
        end

        local piece = old_space:intersect_rect(NB.x1, NB.y1, NB.x2, NB.y2)

        new_space:raw_union(piece)
      end
    end

    return new_space
  end



  local function choose_division(floor, zone)
    local zone_dx = zone.x2 - zone.x1
    local zone_dy = zone.y2 - zone.y1
gui.debugf("choose_division: zone = %dx%d\n", zone_dx, zone_dy)

    -- FIXME we only support subdividing single monotones right now
    if #R.mono_list > 1 then return nil end

    -- FIXME: try lots of different floor prefabs
    local fab = "H1_DOWN_4"
    local fab_info = assert(PREFAB[fab])

    -- FIXME: ARGH, rotate affects size
    local rotate = 0

    local x_size = fab_info.x_size
    local y_size = fab_info.y_size

    if rotate == 90 or rotate == 270 then
      x_size, y_size = y_size, x_size
    end

---    if fab_info.z_size and fab_info.z_size > zone_dz then
---      return
---    end

    local extra_x = zone_dx - x_size
    local extra_y = zone_dy - y_size

    if extra_x < 0 or extra_y < 0 then
gui.debugf("choose_division: zone too small: %dx%d < %dx%d\n", zone_dx, zone_dy,
           x_size, y_size)
      return nil
    end

    local locs = {}

    local half_ex = int(extra_x / 2)
    local half_ey = int(extra_y / 2)

gui.debugf("extra_x/y: %dx%d\n", extra_x, extra_y)
    -- FIXME: rotations!! 

    for xp = 1,3 do for yp = 1,3 do
      local can_x = (xp == 1) or (xp == 2 and half_ex >= 32) or (xp == 3 and extra_x >= 32)
      local can_y = (yp == 1) or (yp == 2 and half_ey >= 32) or (yp == 3 and extra_y >= 32)

      if can_x and can_y then
        local x1, x2
        if xp == 1 then x1 = zone.x1 ; x2 = x1 + x_size end
        if xp == 2 then x1 = zone.x1 + half_ex ; x2 = x1 + x_size end
        if xp == 3 then x2 = zone.x2 ; x1 = x2 - x_size end

        local y1, y2
        if yp == 1 then y1 = zone.y1 ; y2 = y1 + y_size end
        if yp == 2 then y1 = zone.y1 + half_ey ; y2 = y1 + y_size end
        if yp == 3 then y2 = zone.y2 ; y1 = y2 - y_size end

        table.insert(locs, { fab=fab, x1=x1, y1=y1, x2=x2, y2=y2, rotate=rotate })
      end
    end end

    rand.shuffle(locs)

    for _,loc in ipairs(locs) do
      if check_floor_fab(floor, loc) then
        return loc
      end
    end
gui.debugf("[all locs failed]\n")

    return nil
  end


  local function subdivide_floor(floor, recurse_lev)
    gui.debugf("\nsubdivide_floor in %s  lev:%d\n", R:tostr(), recurse_lev)

    for _,Z in ipairs(floor.zones) do
      gui.debugf("zone: (%d %d) .. (%d %d)\n", Z.x1, Z.y1, Z.x2, Z.y2)
    end
    for _,G in ipairs(floor.walks) do
      gui.debugf("WALK: (%d %d) .. (%d %d)\n", G.x1,G.y1, G.x2,G.y2)
    end

    local loc, zone

    -- !!!!
    if recurse_lev <= 7 and #floor.walks >= 2 then
      -- try each safe zone
      rand.shuffle(floor.zones)
      for _,Z in ipairs(floor.zones) do
        zone = Z
        loc  = choose_division(floor, zone)
        if loc then break; end
      end
    end

gui.debugf("location =\n%s\n", table.tostr(loc, 3))

    if not loc then
      table.insert(R.all_floors, floor)

      for _,G in ipairs(floor.walks) do G.floor = floor end
      for _,A in ipairs(floor.airs)  do A.floor = floor end

      return
    end


    ----- DO THE SUBDIVISION -----

    local fab        = loc.fab
    local fab_info   = PREFAB[fab]
    local num_spaces = fab_info.num_spaces or 2

    local new_floors = {}

    for i = 1,num_spaces do
      new_floors[i] = { walks={}, airs={}, fabs={} }
    end

    transfer_walks(floor, loc, new_floors)
    transfer_airs (floor, loc, new_floors)

    for idx,F in ipairs(new_floors) do
      F.space = space_from_neighborhood(floor.space, idx, loc)
      F.zones = zones_from_neighborhood(floor.zones, idx, loc)

      if fab_info.neighborhood[1].z1 and idx == 2 then  -- FIXME !!!!!
        F.three_d = 16
      end
    end


    local liquid = liquid_from_neighborhood(floor.space, loc)

    if liquid then
      table.insert(R.all_liquids, { space=liquid })
    end


    -- create transform
    local T = {}

    T.add_x = loc.base_x
    T.add_y = loc.base_y
    T.add_z = 0  -- dummy value

    T.rotate = loc.rotate

    if loc.rotate == 90 or loc.rotate == 270 then
      T.fit_width = loc.y2 - loc.y1
      T.fit_depth = loc.x2 - loc.x1
    elseif loc.rotate == 0 or loc.rotate == 180 then
      T.fit_width = loc.x2 - loc.x1
      T.fit_depth = loc.y2 - loc.y1
    else
      error("Bad floor rotate: " .. tostring(loc.rotate))
    end


    local skin1 = { top="WIZMET1_1" }

    -- save info to render it later
    local POST_FAB =
    {
      fab = fab,
      trans = T,

      skin1 = skin1,
      skin2 = skin2,
      skin3 = skin3,

      R = R,
      fab_tag = Plan_alloc_id("prefab"),

      polys = {},

      loc = loc,
      new_floors = new_floors,
      new_walks = {},
    }

    -- FIXME: only process the skins ONCE
    table.insert(R.post_fabs, POST_FAB)

    Trans.set_override(floor_check_brush, POST_FAB)

    Fabricate(fab, T, skin)

    Trans.clear_override()


    -- the prefab for this floor is associated with it's first walk area
    -- in the old space.  That is the mechanism which allows the old
    -- space to tbe further sub-divided and yet allow the prefab to
    -- get the correct floor height.
    assert(POST_FAB.new_walks[1])

    if not POST_FAB.new_walks[1].fabs then POST_FAB.new_walks[1].fabs = {} end

    table.insert(POST_FAB.new_walks[1].fabs, POST_FAB)


    -- similar logic for stairs, use the walk area to determine the
    -- correct floor -- cannot reference the floor directly since
    -- they "die" when they are split into two.

    -- FIXME: does not handle triple spaces
    local STAIR =
    {
      walk1 = assert(POST_FAB.new_walks[1]),
      walk2 = assert(POST_FAB.new_walks[2]),

      delta = assert(POST_FAB.walk_dz),
    }

    table.insert(R.all_stairs, STAIR)

    -- recursively handle new pieces (order does not matter)

    for _,F in ipairs(new_floors) do
      subdivide_floor(F, recurse_lev+1)
    end
  end


  local function assign_floor_heights()
    -- find the floor which touches the entrance
    local start_F

    for _,floor in ipairs(R.all_floors) do
      for _,G in ipairs(floor.walks) do
        for _,P in ipairs(G.polys) do
          if P.is_entry then
            start_F = floor
            break;
          end
        end
      end
      if start_F then break; end
    end

    -- if not found (e.g. start room, teleporter entry), pick any one
    if not start_F then
      start_F = R.all_floors[1]
    end

    assert(start_F)

    start_F.z = R.entry_floor_h

    for loop = 1, 2*#R.all_floors do
      for _,ST in ipairs(R.all_stairs) do
        local F1 = assert(ST.walk1.floor)
        local F2 = assert(ST.walk2.floor)
        assert(ST.delta)

        if F1.z and not F2.z then F2.z = F1.z + ST.delta end
        if F2.z and not F1.z then F1.z = F2.z - ST.delta end
      end
    end

    -- validate
    for _,F in ipairs(R.all_floors) do
      if not F.z then
        error("floor space did not get any height!")
      end
    end
  end


  local function build_floor()

    -- initial floor space

    local floor =
    {
      space = Layout_initial_space(R),
      walks = collect_walk_groups(),  -- FIXME only walks in each monotone
      airs  = collect_airs(),
      fabs  = {},
    }

    floor.zones = determine_safe_zones(R.mono_list[1], floor.walks)

    R.all_floors = {}
    R.all_stairs = {}
    R.all_liquids = {}

    subdivide_floor(floor, 1)

    assign_floor_heights()

    R.floor_min_h =  9e9
    R.floor_max_h = -9e9

    for _,F in ipairs(R.all_floors) do
      collect_floor_fabs(F)

      render_floor(F)

      R.floor_min_h = math.min(R.floor_min_h, F.z)
      R.floor_max_h = math.max(R.floor_max_h, F.z)

      transmit_height_to_fabs(F, F.z)

--[[ TEST : fill zone with a solid
      for _,Z in ipairs(F.zones) do
        if Z.x2 >= Z.x1+16 and Z.y2 >= Z.y1+16 then
          Trans.quad(Z.x1, Z.y1, Z.x2, Z.y2, nil, nil, Mat_normal("ASHWALL"))
        end
      end
--]]
    end

    for _,F in ipairs(R.all_liquids) do
      F.z = R.floor_min_h
      render_liquid(F)
    end
  end


  local function build_ceiling()
    -- TEMP CRUD
    local h   = ROOM.floor_max_h + rand.pick { 192, 256, 320, 384 }
    local mat = sel(R.outdoor, "_SKY", "METAL1")

    if R.outdoor then
      R.sky_h = h
      return
    end

    for _,K in ipairs(R.sections) do
      local x1, y1, x2, y2 = Layout_shrunk_section_coords(K)
      Trans.quad(x1, y1, x2, y2, h, nil, Mat_normal(mat))
    end
  end


  local function ambient_lighting()
    if GAME.format ~= "doom" then return end

    local light = rand.pick { 128, 144, 160 }
    if R.outdoor then light = 192 end

    for _,K in ipairs(R.sections) do
      gui.add_brush(
      {
        { m="light", ambient=light },
        { x=K.x1, y=K.y1 },
        { x=K.x2, y=K.y1 },
        { x=K.x2, y=K.y2 },
        { x=K.x1, y=K.y2 },
      })
    end
  end


  local function render_post_fab(PF)
    PF.trans.add_z = PF.z or 256

    Fabricate(PF.fab, PF.trans, PF.skin1, PF.skin2, PF.skin3)

    -- FIXME: do this in assign_floor_heights OR render_floors
    if PF.set_height_in then
      assert(PF.z)
      local other_R = PF.set_height_in
      other_R.entry_floor_h = PF.z + PF.set_height_dz
    end

    if PF.set_window_h then
      assert(PF.window)
      if not PF.window.z then
        PF.window.z = PF.z
      else
        PF.window.z = math.max(PF.window.z, PF.z)
      end
    end
  end


  local function spots_for_floor(floor)
    gui.spots_begin(floor.space:calc_bbox())

    fill_polygons(floor.space, { free=0, air=0, walk=0 })

    fill_polygons(R.wall_space, { solid=1 })

    for _,F in ipairs(R.all_floors) do
      if F ~= floor and F.layer == floor.layer then
        fill_polygons(F.space, { free=1, air=1, walk=1 })
      end
    end

    gui.spots_dump("Spot grid")

    local mon_spots  = {}
    local item_spots = {}

    gui.spots_get_mons (mon_spots)
    gui.spots_get_items(item_spots)

    gui.spots_end()

    -- set Z positions

    for _,spot in ipairs(mon_spots) do
      spot.z1 = floor.z
      spot.z2 = floor.z2 or (spot.z1 + 200)  -- FIXME
      table.insert(R.mon_spots, spot)
    end

    for _,spot in ipairs(item_spots) do
      spot.z = floor.z
      table.insert(R.item_spots, spot)
    end

--[[  TEST
    for _,spot in ipairs(R.item_spots) do
      Trans.entity("potion", spot.x, spot.y, 0)
    end
--]]
  end


  ---===| Layout_the_room |===---

  ROOM = R  -- set global

  gui.debugf("\nLayout_the_room @ %s\n\n", ROOM:tostr())

  if not ROOM.entry_floor_h then
    ROOM.entry_floor_h = rand.pick { 128, 192, 256, 320 }
  end

  R.cage_spots = {}
  R.trap_spots = {}
  R.mon_spots  = {}
  R.item_spots = {}

  R.post_fabs = {}
  R.poly_assoc = {}


  R.mono_list = Layout_monotonic_spaces(R)

  R.wall_space = Layout_initial_space(R)


  decide_corner_sizes()


  build_corners()

  build_edges()

--FIXME  build_middles()


-- TODO  R.ceil_space  = R.floor_space:copy()


  local K = R.sections[1]

  local ex = (K.x1 + K.x2) / 2
  local ey = (K.y1 + K.y2) / 2


  if R.purpose == "START" then
    local skin = { top="O_BOLT", x_offset=36, y_offset=-8, peg=1 }
    local T = Trans.spot_transform(ex, ey, ROOM.entry_floor_h)

--- Fab_with_update("START_SPOT", T, skin)
  
  elseif R.purpose == "EXIT" then

    local T = Trans.spot_transform(ex, ey, ROOM.entry_floor_h)

--[[ !!!!
    if GAME.format == "quake" then
      local skin = { floor="SLIP2", wall="SLIPSIDE", nextmap = LEVEL.next_map }
      Fab_with_update("QUAKE_EXIT_PAD", T, skin)
    else
--]]

---      local skin_name = rand.key_by_probs(THEME.exits)
---      local skin = assert(GAME.EXITS[skin_name])
---
---      Fab_with_update("EXIT_PILLAR", T, skin)
 
  else

    Trans.entity("potion", ex, ey, 0)
  end


  build_floor()

  build_ceiling()


  if not R.outdoor then
    Trans.entity("light", ex, ey, R.entry_floor_h + 170, { light=100, _radius=360 })
  end


  ambient_lighting()


  for _,PF in ipairs(R.post_fabs) do
    render_post_fab(PF)
  end


  -- collect spots for the monster code
  for _,F in ipairs(R.all_floors) do
    spots_for_floor(F)
  end
    
end



function Layout_the_ceiling(R)
  if R.sky_h then
    for _,K in ipairs(R.sections) do
      local x1, y1, x2, y2 = Layout_shrunk_section_coords(K)
      Trans.quad(x1, y1, x2, y2, R.sky_h, nil, Mat_normal("_SKY"))
    end
  end
end


