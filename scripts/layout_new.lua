----------------------------------------------------------------
--  Layouting Logic
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


function Layout_prepare_rooms()

  local function add_corners(K)
    for side = 1,9,2 do if side ~= 5 then
      local R_dir = geom.RIGHT_45[side]
      local L_dir = geom. LEFT_45[side]

      local N  = K:neighbor(side)
      local N1 = K:neighbor(R_dir)
      local N2 = K:neighbor(L_dir)

      local same1 = (N1 and N1.room == K.room)
      local same2 = (N2 and N2.room == K.room)

      if not same1 and not same2 then
        K.corners[side] = { K=K, side=side }
      end

      -- detect the "concave" kind, these turn 270 degrees
      if same1 and same2 and not (N and N.room == K.room) then
        K.corners[side] = { K=K, side=side, concave=true }
      end
    end end
  end


  local function add_edges(K)
    for side = 2,8,2 do
      local N = K:neighbor(side)

      if not (N and N.room == K.room) then
        local EDGE = { K=K, side=side, spans={} }

        if geom.is_vert(side) then
          EDGE.long = K.x2 - K.x1
        else
          EDGE.long = K.y2 - K.y1
        end

        K.edges[side] = EDGE
      end
    end
  end


  local function corner_near_edge(E, want_left)
    local side
    if want_left then side = geom.LEFT_45 [E.side]
                 else side = geom.RIGHT_45[E.side]
    end

    local C = E.K.corners[side]

    if C then
      assert(not C.concave)
      return C
    end

    -- check for concave corners, a bit trickier since it will be
    -- in a different section.

    if want_left then side = geom.LEFT_45 [side]
                 else side = geom.RIGHT_45[side]
    end

    local N = E.K:neighbor(side)

    if not (N and N.room == E.K.room) then
      return nil
    end

    if want_left then side = geom.RIGHT_45[E.side]
                 else side = geom.LEFT_45 [E.side]
    end

    return N.corners[side]
  end


  local function prepare_room(R)
    for _,K in ipairs(R.sections) do
      add_corners(K)
      add_edges(K)
    end
  end


  local function connect_corners(R)
    for _,K in ipairs(R.sections) do
      for _,E in pairs(K.edges) do
        E.corn1 = corner_near_edge(E, true)
        E.corn2 = corner_near_edge(E, false)
      end
    end
  end


  ---| Layout_prepare_rooms |---

  for _,R in ipairs(LEVEL.all_rooms) do
    prepare_room(R)
    connect_corners(R)
  end
end


function Layout_add_span(E, long1, long2, deep)
  assert(long2 > long1)

  E.place_used = true

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
    
    SP = Layout_add_span(K.edges[dir], long1, long2, deep1)
    SP.usage = "straddler"
    SP.straddler = STRADDLER

    -- NOTE: if not centred, would need different long1/long2 for other side
    SP = Layout_add_span(N.edges[10-dir], long1, long2, deep2)
    SP.usage = "straddler"
    SP.straddler = STRADDLER

    return STRADDLER
  end


  ---| Layout_place_straddlers |---

  -- do doors after windows, as doors may want to become really big
  -- and hence would need to know about the windows.

  for _,R in ipairs(LEVEL.all_rooms) do
    for _,W in ipairs(R.windows) do
      if not W.placed and W.K1.room == R then
        place_straddler("window", W.K1, W.K2, W.dir)
        W.placed = true
      end
    end
  end

  for _,R in ipairs(LEVEL.all_rooms) do
    for _,C in ipairs(R.conns) do
      if not C.placed and C.K1.room == R and C.kind == "normal" then
        local STR = place_straddler("door", C.K1, C.K2, C.dir)
        STR.conn = C
        C.placed = true
      end
    end
  end
end


--[[  STRADDLER
      local mx = int((K.x1 + K.x2) / 2)
      local my = int((K.y1 + K.y2) / 2)

      local x1,y1, x2,y2

      if geom.is_vert(dir) then
        x1 = mx - long/2
        x2 = mx + long/2

        if dir == 8 then
          y1 = K.y2 - deep1
          y2 = K.y2 + deep2
        else
          y1 = K.y1 - deep2
          y2 = K.y1 + deep1
        end
      else
        y1 = my - long/2
        y2 = my + long/2

        if dir == 6 then
          x1 = K.x2 - deep1
          x2 = K.x2 + deep2
        else
          x1 = K.x1 - deep2
          x2 = K.x1 + deep1
        end
      end


      local res_kind = sel(kind == "door", "walk", "air")
      local res_d = 80
      

      spacelib.make_current(K.room.spaces)

      spacelib.merge(spacelib.quad("solid", x1,y1, x2,y2))

      if dir == 2 then
        spacelib.merge(spacelib.quad(res_kind, x1,y2, x2,y2+res_d))
      elseif dir == 8 then
        spacelib.merge(spacelib.quad(res_kind, x1,y1-res_d, x2,y1))
      elseif dir == 6 then
        spacelib.merge(spacelib.quad(res_kind, x1-res_d,y1, x1,y2))
      elseif dir == 4 then
        spacelib.merge(spacelib.quad(res_kind, x2,y1, x2+res_d,y2))
      end


      spacelib.make_current(N.room.spaces)

      spacelib.merge(spacelib.quad("solid", x1,y1, x2,y2))

      -- place walk areas (etc) in front of spaces

      if dir == 8 then
        spacelib.merge(spacelib.quad(res_kind, x1,y2, x2,y2+res_d))
      elseif dir == 2 then
        spacelib.merge(spacelib.quad(res_kind, x1,y1-res_d, x2,y1))
      elseif dir == 4 then
        spacelib.merge(spacelib.quad(res_kind, x1-res_d,y1, x1,y2))
      elseif dir == 6 then
        spacelib.merge(spacelib.quad(res_kind, x2,y1, x2+res_d,y2))
      end
--]]



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
    POLY.fab_tag = data.fab_tag
    R.wall_space:merge(POLY)
  end

  return false
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


  local function pick_imp_spot(IM, middles, corners, walls)
    for loop = 3,19 do
      if rand.odds(loop * 10) and #middles > 0 then
        IM.place_kind = "MIDDLE"
        IM.place_K = table.remove(middles, 1)
        IM.place_K.place_used = true
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
        IM.place_E.place_used = true
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

        local SP = Layout_add_span(E, long1, long2, deep)

        SP.usage = "prefab"
        SP.prefab = prefab
        SP.skin = skin

        return
      end

      if rand.odds(loop * 10) and #corners > 0 then
        IM.place_kind = "CORNER"
        IM.place_C = table.remove(corners, 1)
        IM.place_C.place_used = true
gui.debugf("IMPORTANT '%s' in CORNER:%d of %s\n", IM.kind, IM.place_C.side, IM.place_C.K:tostr())
        return
      end
    end

    -- TODO: allow up to 4 stuff in a "middle" (subdivide section 2 or 4 ways)

    error("could not place important stuff!")
  end


  local function place_importants()
    -- determine available places

    local middles = table.copy(R.sections)
    local corners = {}
    local walls = {}

    for _,K in ipairs(R.sections) do
      for _,C in pairs(K.corners) do
        if not C.place_used then
          table.insert(corners, C)
        end
      end
      for _,E in pairs(K.edges) do
        if not E.place_used then
          table.insert(walls, E)
        end
      end
    end

    table.sort(middles, function(A, B) return A.num_conn < B.num_conn end)

    rand.shuffle(corners)
    rand.shuffle(walls)

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
        pick_imp_spot(IM, {}, {}, walls)
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
      fab_tag = Plan_alloc_mark(),
    }

    -- save info to render it later
    -- FIXME: only process the skins ONCE
    table.insert(R.post_fabs, POST_FAB)

    Trans.set_override(Layout_check_brush, POST_FAB, true)

    Fabricate(fab, T, skin1, skin2, skin3)

    Trans.clear_override()
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


  local function do_straddler_solid(E, SP)
    -- TODO: do it with the prefab, clip the polygons at edge

    local K = E.K
    local info = assert(SP.straddler)

    local gap = 80 -- FIXME put in span and/or STRADDLER

    local T = Trans.edge_transform(K.x1, K.y1, K.x2, K.y2, ROOM.entry_floor_h, E.side,
                                   SP.long1, SP.long2, 0, SP.deep1)

    Fab_with_update("MARK_USED", T)

    local T = Trans.edge_transform(K.x1, K.y1, K.x2, K.y2, ROOM.entry_floor_h, E.side,
                                   SP.long1, SP.long2, SP.deep1, SP.deep1 + gap)

    if info.kind == "window" then
      Fab_with_update("MARK_AIR", T)
    else
      Fab_with_update("MARK_WALK", T)
    end
  end


  local function build_straddler_span(E, SP, z, back, fab, skin1, skin2, skin3)
    local K = E.K

    local T = Trans.edge_transform(K.x1, K.y1, K.x2, K.y2, z, E.side,
                                   SP.long1, SP.long2, -back, SP.deep1)

    -- Note: not using Fab_with_update() for automatic space updating,
    --       because straddlers affect TWO rooms at the same time.
    --       instead we mark the quads directly.

    do_straddler_solid(E, SP)

    local POST_FAB =
    {
      fab = fab,
      trans = T,

      skin1 = skin1,
      skin2 = skin2,
      skin3 = skin3,

      R = R,
      fab_tag = Plan_alloc_mark(),
    }

    table.insert(R.post_fabs, POST_FAB)
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


    inner_outer_tex(skin, ROOM, other_R)


    if info.kind == "window" then
      fab = "WINDOW_W_BARS"
      z = math.max(z, other_R.entry_floor_h or 0)
      z = z + 40
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
        sk2.tag = info.conn.lock.tag
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

    if info.kind == "door" and not info.seen then
      -- TODO: if any Z scaling, apply to room_dy
      other_R.entry_floor_h = ROOM.entry_floor_h - (fab_info.room_dz or 0)
    end

    if fab_info.repeat_width and (long / fab_info.repeat_width) >= 2 then
      count = int(long / fab_info.repeat_width)
    end


    -- build it only once :
    --    DOOR on first room (as it sets up the initial floor height for second room) 
    --    WINDOW on second room (since there it knows height range on both sides)

    if info.kind == "window" or info.kind == "door" then
      if not info.seen then
        info.seen = true
        do_straddler_solid(E, SP)
        return
      end
    else
      if info.built then
        do_straddler_solid(E, SP)
        return
      end
      info.built = true
    end


    for i = 1,count do
      SP.long1 = long1
      SP.long2 = long2

      if i > 1     then SP.long1 = long1 + int(long * (i-1) / count) end
      if i < count then SP.long2 = long1 + int(long * (i)   / count) end

      build_straddler_span(E, SP, z, back, fab, skin, sk2)
    end
  end


  local function build_edge_prefab(E, SP)
    assert(SP.prefab)
    assert(SP.skin)

    local K = E.K
    local z = ROOM.entry_floor_h

stderrf("build_edge_prefab: %s @ z:%d\n", SP.prefab, z)
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


  local function floor_polygon(S)
if S.kind == "solid" then return end

    local mat = "FLAT18"

    if S.kind == "walk"   then mat = "LAVA1"   end
    if S.kind == "air"    then mat = "NUKAGE1" end

    if S.kind == "floor"  then mat = "FLAT18" end
    if S.kind == "liquid" then mat = "FWATER1" end
    if S.kind == "solid"  then mat = "CEIL5_2" end

    local BRUSH = P:to_brush(mat)

    table.insert(BRUSH, { t=0, tex=mat, mark=Plan_alloc_mark() })

    Trans.brush(BRUSH)
  end


  local function shrunk_section_coords(K)
    local x1, y1 = K.x1, K.y1
    local x2, y2 = K.x2, K.y2

    if not K:same_room(4) then K.x1 = K.x1 + 8 end
    if not K:same_room(6) then K.x2 = K.x2 - 8 end
    if not K:same_room(2) then K.y1 = K.y1 + 8 end
    if not K:same_room(8) then K.y2 = K.y2 - 8 end

    return x1,y1, x2,y2
  end


  local function path_square(grid, x, y, h, mat)
    local x1 = grid.base_x + (x-1) * 64
    local y1 = grid.base_y + (y-1) * 64

    Trans.quad(x1, y1, x1+64, y1+64, nil, h, Mat_normal(mat))
  end


  local function build_a_path(grid, A, B)

    local function scorer(cx,cy, nx,ny, dir)
      local G = grid[nx][ny]
      if not (G.walk or G.free) then return -1 end
      if G.solid then return 9 end
      return 1
    end

    local path = astar_find_path(grid.w, grid.h, A.x, A.y, B.x, B.y, scorer)

    if not path then
stderrf("******************* NO PATH *****************\n")
stderrf("******************* NO PATH *****************\n")
stderrf("******************* NO PATH *****************\n")
stderrf("******************* NO PATH *****************\n")
      return
    end

    for _,p in ipairs(path) do
      path_square(grid, p.x, p.y, 16, "FLAT18")
    end
  end


  local function expand_walk_group(grid, x, y)
    local x1 = x
    local x2 = x

    grid[x][y].walk = 2

    -- clear current row first, which will limit the amount of recursion

    while x1-1 >= 1 and grid[x1-1][y].walk == 1 do
      x1 = x1 - 1
      grid[x1][y].walk = 2
    end

    while x2+1 <= grid.w and grid[x2+1][y].walk == 1 do
      x2 = x2 + 1
      grid[x2][y].walk = 2
    end

    for x = x1,x2 do
      if y-1 >= 1 and grid[x][y-1].walk == 1 then
        expand_walk_group(grid, x, y-1)
      end
      if y+1 <= grid.h and grid[x][y+1].walk == 1 then
        expand_walk_group(grid, x, y+1)
      end
    end
  end


  local function find_walk_groups(grid)
    local list = {}
 
    for x = 1,grid.w do for y = 1,grid.h do
      local G = grid[x][y]
      if G.walk == 1 then
        local GROUP = { x=x, y=y, id=1 + #list }
        table.insert(list, GROUP)
stderrf("WALK GROUP @ (%d %d)\n", x, y)
        expand_walk_group(grid, x, y)
      end
    end end

stderrf("\n\n")
    return list
  end


  local function dump_floor(grid)
    gui.debugf("FLOOR AREAS:\n")
    for y = grid.h,1,-1 do
      local line = ""
      for x = 1,grid.w do
        local G = grid[x][y]
            if G.solid then line = line .. "#"
        elseif G.walk  then line = line .. "/"
        elseif G.free  then line = line .. "."
        else                line = line .. "?"
        end
      end
      gui.debugf("  %s\n", line)
    end
  end



  local function OLD__build_floor()
    -- TEMPER CRUDDIER CRUD
    local h = ROOM.entry_floor_h
    local mat = R.skin.wall
    if not R.outdoor and THEME.building_floors then
      mat = rand.key_by_probs(THEME.building_floors)
    end
ROOM.floor_mat = mat

    for _,K in ipairs(R.sections) do
      local x1, y1, x2, y2 = shrunk_section_coords(K)
      local kind, w_face, p_face = Mat_normal(mat)
      Trans.quad(x1, y1, x2, y2, nil, h, { m=kind, flavor="floor:1" }, w_face, p_face)
    end


-- BRIDGE TEST
if false and R.kw == 1 and R.kh == 2 then
  local x1, y1, x2, y2 = shrunk_section_coords(SECTIONS[R.kx1][R.ky1])
  local y2 = SECTIONS[R.kx1][R.ky2].y2 - 8

  local mx, my = geom.box_mid(x1,y1, x2,y2)

  local T = Trans.box_transform(x1, my - 128, x2, my + 128, h, 8)

  Fabricate("BRIDGE_TEST", T, { liquid="LAVA1" } )
end


    do return end


    -- TEMP EXPERIMENTAL PATH CRUD
--[[
    local bx1,by1, bx2,by2 = R.wall_space:calc_bbox()

    local fw = int((bx2 - bx1) / 64.0)
    local fh = int((by2 - by1) / 64.0)

    gui.spots_begin(bx1,by1, bx2,by2)

    fill_polygons(R.wall_space, { free=0, air=0 })
    fill_polygons(R.wall_space, { walk=2 })
    fill_polygons(R.wall_space, { solid=1 })

    gui.spots_dump("Floor grid")

    local grid = table.array_2D(fw, fh)

    grid.base_x = bx1
    grid.base_y = by1

    for x = 1,fw do for y = 1,fh do
      local G = {}
      grid[x][y] = G

      local val = gui.spots_read_grid((x-1)*4+1, (y-1)*4+1, 4, 4);

      if bit.btest(val, 1) then G.free  = 1 end
      if bit.btest(val, 2) then G.walk  = 1 end
      if bit.btest(val, 4) then G.solid = 1 end
    end end

    gui.spots_end()

    dump_floor(grid)

    for x = 1,fw do for y = 1,fh do
      if grid[x][y].walk and not grid[x][y].solid then
        path_square(grid, x, y, 8, "LAVA1")
      end
    end end

    local walks = find_walk_groups(grid)

    for i = 1,#walks-1 do
      build_a_path(grid, walks[i], walks[i+1])
    end
--]]
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


  -- FIXME: THIS PROBABLY BELONGS IN THE SPACE MANAGER
  local function collect_walk_groups()
    -- first collect the walk polys
    local walk_polys = {}

    for idx,P in ipairs(R.wall_space.polys) do
      if P.kind == "walk" then
        P.walk_tag = idx
        table.insert(walk_polys, P)
      end
    end

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

stderrf("%s has %d walk groups:\n", R:tostr(), #walk_groups)

    for _,G in ipairs(walk_groups) do
      -- FIXME: big hack (assumes GROUP == SPACE)
      G.x1, G.y1, G.x2, G.y2 = SPACE_CLASS.calc_bbox(G)

stderrf("  polys:%d  bbox: (%d %d) .. (%d %d)\n",
        #G.polys, G.x1, G.y1, G.x2, G.y2)
    end  

    return walk_groups
  end


  local function narrow_zone_for_edge(edge_deeps, E)
    if E.max_deep then
      assert(E.side and edge_deeps[E.side])

      if edge_deeps[E.side] < E.max_deep then
         edge_deeps[E.side] = E.max_deep
      end
    end
  end


  local function safe_walking_zone()

    -- determine a rectangle inside the current room which
    -- could be make solid while still allowing the player to
    -- traverse the room (from one door to another etc).

    -- FIXME this assumes a rectangular room
    local K1 = SECTIONS[R.kx1][R.ky1]
    local K2 = SECTIONS[R.kx2][R.ky2]

    local zone = 
    {
      x1 = K1.x1,
      y1 = K1.y1,
      x2 = K2.x2,
      y2 = K2.y2,
    }

    local edge_deeps =
    {
      [2] = 16, [4] = 16, [6] = 16, [8] = 16
    }

    for _,K in ipairs(R.sections) do
      for _,E in pairs(K.edges) do
        narrow_zone_for_edge(edge_deeps, E)
      end
    end

    -- FIXME: check corners too

    for side = 2,8,2 do
      if side == 4 then zone.x1 = zone.x1 + edge_deeps[4] end
      if side == 6 then zone.x2 = zone.x2 - edge_deeps[6] end
      if side == 2 then zone.y1 = zone.y1 + edge_deeps[2] end
      if side == 8 then zone.y2 = zone.y2 - edge_deeps[8] end
    end

    -- allow some room for player
    zone.x1 = zone.x1 + 96
    zone.y1 = zone.y1 + 96

    zone.x2 = zone.x2 - 96
    zone.y2 = zone.y2 - 96

    return zone
  end


  local function render_floor(floor)
floor.h = ROOM.entry_floor_h - rand.irange(1,16) * 4

    local mat = R.skin.wall

    if not R.outdoor and THEME.building_floors then
      mat = rand.key_by_probs(THEME.building_floors)
    end

    for _,P in ipairs(floor.space.polys) do
      local BRUSH = P:to_brush(mat)

      table.insert(BRUSH, 1, { m="solid", flavor="floor:1" })
      table.insert(BRUSH,    { t=floor.h, tex=mat })

      Trans.brush(BRUSH)
    end
  end


  local function check_binary_subdiv(floor, loc)
    -- Requirements:
    --   1. at least one walk group in each half
    --   2. staircase must fit completely inside the SWZ
    --   3. no walk group is "cut" by dividing lines

    if not geom.box_inside_box(loc.stair.x1, loc.stair.y1,
                               loc.stair.x2, loc.stair.y2,
                               floor.zone.x1, floor.zone.y1,
                               floor.zone.x2, floor.zone.y2)
    then
      return false
    end

    local in_walks  = 0
    local out_walks = 0

    assert(loc.x or loc.y)

    for _,G in ipairs(floor.walks) do
      if loc.x then
            if G.x2 - 1 < loc.x then in_walks  = in_walks  + 1
        elseif G.x1 + 1 > loc.x then out_walks = out_walks + 1
        else return false -- cuts the group
        end
      else
            if G.y2 - 1 < loc.y then in_walks  = in_walks  + 1
        elseif G.y1 + 1 > loc.y then out_walks = out_walks + 1
        else return false -- cuts the group
        end
      end
    end

stderrf("  in_walks:%d  out_walks:%d\n", in_walks, out_walks)

    if in_walks < 1 or out_walks < 1 then
      return false
    end

    return true  -- OK
  end


  local function choose_division(floor)
    local zone_dx = floor.zone.x2 - floor.zone.x1
    local zone_dy = floor.zone.y2 - floor.zone.y1

    -- FIXME we only support subdividing rectangles right now
    if R.shape ~= "rect" then
      return nil
    end

    if zone_dx < 64 or zone_dy < 64 then
gui.debugf("choose_division: zone too small: %dx%d\n", zone_dx, zone_dy)
      return nil  -- not enough room to swing a cat
    end

    local locs = {}

    -- Man, this is way too simplistic (pure cut in half),
    -- but we gotta start somewhere!!

    local x1, y1 = floor.zone.x1, floor.zone.y1
    local x2, y2 = floor.zone.x2, floor.zone.y2

    local mx = int((x1 + x2)/2)
    local my = int((y1 + y2)/2)

    table.insert(locs, { x=x1, stair={ x1=x1, x2=x1+128, y1=my-64, y2=my+64 }})
    table.insert(locs, { x=x2, stair={ x2=x2, x1=x2-128, y1=my-64, y2=my+64 }})

    table.insert(locs, { y=y1, stair={ y1=y1, y2=y1+128, x1=mx-64, x2=mx+64 }})
    table.insert(locs, { y=y2, stair={ y2=y2, y1=y2-128, x1=mx-64, x2=mx+64 }})

    rand.shuffle(locs)

    table.insert(locs, 1, { x=mx, stair={ x1=mx-64, y1=my-64, x2=mx+64, y2=my+64 }})
    table.insert(locs, 1, { y=my, stair={ x1=mx-64, y1=my-64, x2=mx+64, y2=my+64 }})

    for _,loc in ipairs(locs) do
      if check_binary_subdiv(floor, loc) then
        return loc
      end
    end
gui.debugf("[all locs failed]\n")
  end


  local function subdivide_floor(floor)
    gui.debugf("\nsubdivide_floor in %s\n", R:tostr())
    gui.debugf("SWZ: (%d %d) .. (%d %d)  walks:%d\n",
               floor.zone.x1, floor.zone.y1,
               floor.zone.x2, floor.zone.y2, #floor.walks)
    for _,G in ipairs(floor.walks) do
      gui.debugf("WALK: (%d %d) .. (%d %d)\n", G.x1,G.y1, G.x2,G.y2)
    end

    local loc

    if #floor.walks >= 2 then
      loc = choose_division(floor)
    end

gui.debugf("location =\n%s\n", table.tostr(loc, 3))

    if not loc then
      table.insert(R.all_floors, floor)
      return
    end

    ----- DO THE SUBDIVISION -----

    local floor1 = { walks={} }
    local floor2 = { walks={} }

    -- actually split the space
    floor1.space, floor2.space = floor.space:cut_in_half(loc.x, loc.y)

    -- transfer walking groups

    for _,G in ipairs(floor.walks) do
      if (loc.x and G.x1 < loc.x) or (loc.y and G.y1 < loc.y) then
        table.insert(floor1.walks, G)
      else
        table.insert(floor2.walks, G)
      end
    end

    assert(#floor1.walks >= 1)
    assert(#floor2.walks >= 1)

    -- create stair
    -- FIXME FIXME !!!
    Trans.brush(
    {
      { x=loc.stair.x1, y=loc.stair.y1, tex="COMPBLUE" },
      { x=loc.stair.x2, y=loc.stair.y1, tex="COMPBLUE" },
      { x=loc.stair.x2, y=loc.stair.y2, tex="COMPBLUE" },
      { t=ROOM.entry_floor_h + 8, tex="FLAT14" },
    })

    -- create walk groups for stair
    -- TODO: create POLYGON objects
    local G1 = table.copy(loc.stair)
    local G2 = table.copy(loc.stair)

    if loc.x then
      G1.x2 = G1.x1 ; G1.x1 = G1.x1 - 64 
      G2.x1 = G2.x2 ; G2.x2 = G2.x2 + 64 
    else
      G1.y2 = G1.y1 ; G1.y1 = G1.y1 - 64
      G2.y1 = G2.y2 ; G2.y2 = G2.y2 + 64
    end

    table.insert(floor1.walks, G1)
    table.insert(floor2.walks, G2)

    -- create new SWZ (safe walking zones)

    floor1.zone = table.copy(floor.zone)
    floor2.zone = table.copy(floor.zone)

    if loc.x then
      floor1.zone.x2 = G1.x1
      floor2.zone.x1 = G2.x2
    else
      floor1.zone.y2 = G1.y1
      floor2.zone.y1 = G2.y2
    end

    -- recursively handle new pieces

    subdivide_floor(floor1)
    subdivide_floor(floor2)
  end


  local function build_floor()

    local floor =
    {
      space = Layout_initial_space(R),
      zone  = safe_walking_zone(),
      walks = collect_walk_groups(),
    }

    R.all_floors = {}

    subdivide_floor(floor)

    for _,F in ipairs(R.all_floors) do
      render_floor(F)

--[[ TEST : fill SWZ with a solid
      if F.zone.x2 >= F.zone.x1+16 and F.zone.y2 >= F.zone.y1+16 then
        Trans.quad(zone.x1, zone.y1, zone.x2, zone.y2, nil, nil, Mat_normal("ASHWALL"))
      end
--]]
    end
  end


  local function build_ceiling()
    -- TEMP CRUD
    local h   = ROOM.entry_floor_h + sel(R.outdoor, 512, 384)
    local mat = sel(R.outdoor, "_SKY", "METAL1")

    for _,K in ipairs(R.sections) do
      local x1, y1, x2, y2 = shrunk_section_coords(K)
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
    Fabricate(PF.fab, PF.trans, PF.skin1, PF.skin2, PF.skin3)
  end


  local function spots_for_floor(floor)
    gui.spots_begin(floor.space:calc_bbox())

    fill_polygons(floor.space, { free=0, air=0, walk=0 })

    fill_polygons(R.wall_space, { solid=1 })

    for _,F in ipairs(R.all_floors) do
      if F ~= floor then
        fill_polygons(F.space, { free=1, air=1, walk=1 })
      end
    end

    gui.spots_dump("Spot grid")

    gui.spots_get_mons (R.mon_spots)
    gui.spots_get_items(R.item_spots)

    gui.spots_end()

--[[  TEST
    for _,spot in ipairs(R.item_spots) do
      Trans.entity("potion", spot.x, spot.y, 0)
    end
--]]
  end


  ---===| Layout_the_room |===---

  ROOM = R  -- set global

  if not ROOM.entry_floor_h then
    ROOM.entry_floor_h = rand.pick { 128, 192, 256, 320 }
  end

  R.cage_spots = {}
  R.trap_spots = {}
  R.mon_spots  = {}
  R.item_spots = {}

  R.post_fabs = {}

  R.wall_space = Layout_initial_space(R)

  decide_corner_sizes()

  place_importants()


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

    if GAME.format == "quake" then
      local skin = { floor="SLIP2", wall="SLIPSIDE", nextmap = LEVEL.next_map }
      Fab_with_update("QUAKE_EXIT_PAD", T, skin)
    else
---      local skin_name = rand.key_by_probs(THEME.exits)
---      local skin = assert(GAME.EXITS[skin_name])
---
---      Fab_with_update("EXIT_PILLAR", T, skin)
    end
  
  else

    Trans.entity("potion", ex, ey, 0)
  end


  if not R.outdoor then
    Trans.entity("light", ex, ey, 170, { light=150, _radius=600 })
  end


  build_floor()

  build_ceiling()

  ambient_lighting()


  for _,PF in ipairs(R.post_fabs) do
    render_post_fab(PF)
  end


  -- collect spots for the monster code
  for _,F in ipairs(R.all_floors) do
    spots_for_floor(F)
  end
    
end


function Layout_rooms()
  for _,R in ipairs(LEVEL.all_rooms) do
    Layout_the_room(R)
  end
end


----------------------------------------------------------------


function Layout_edge_of_map()
  
  local function stretch_buildings()
    -- TODO: OPTIMISE
    for loop = 1,3 do
      for x = 1,SEED_W do for y = 1,SEED_H do
        local S = SEEDS[x][y]
        if (S.room and not S.room.outdoor) or (S.edge_of_map and S.building) then
          if (S.move_loop or 0) < loop then
            for side = 2,8,2 do
              if not S.edge_of_map or S.building_side == side then
                local N = S:neighbor(side)
                if N and N.edge_of_map and not N.building then
                  N.building = S.room or S.building
                  N.building_side = side
                  N.move_loop = loop
                end
              end
            end -- for side
          end
        end
      end end -- for x, y
    end -- for loop
  end

  local function determine_walk_heights()
    -- TODO: OPTIMISE
    for loop = 1,5 do
      for x = 1,SEED_W do for y = 1,SEED_H do
        local S = SEEDS[x][y]
        if S.edge_of_map and not S.building then
          for side = 2,8,2 do
            local N = S:neighbor(side)
            local other_h
            if N and N.edge_of_map and not N.building then
              other_h = N.walk_h
            elseif N and N.room and N.room.outdoor then
              other_h = N.room.floor_max_h
            end

            if other_h then
              S.walk_h = math.max(S.walk_h or 0, other_h)
            end
          end -- for side
        end
      end end -- for x, y
    end -- for loop
  end

  local function build_edge(S)
if not S.walk_h then S.walk_h = 16 end

    if S.building then
      local tex = S.building.cave_tex or S.building.facade or S.building.main_tex
      assert(tex)

      local kind, w_face, p_face = Mat_normal(tex)

      Trans.quad(S.x1,S.y1, S.x2,S.y2, nil,nil, { m=kind }, w_face, p_face)
      return
    end

    S.fence_h = SKY_H - 128  -- fallback value

    if S.walk_h then
      S.fence_h = math.min(S.walk_h + 64, SKY_H - 64)
    end

    local x1 = S.x1
    local y1 = S.y1
    local x2 = S.x2
    local y2 = S.y2

    local function side_quad(side,len, z1,z2, props, w_face, p_face)
      local ax1, ay1 = x1, y1
      local ax2, ay2 = x2, y2

      if side == 2 then ay2 = ay1 + len end
      if side == 8 then ay1 = ay2 - len end
      if side == 4 then ax2 = ax1 + len end
      if side == 6 then ax1 = ax2 - len end

      Trans.quad(ax1,ay1, ax2,ay2, z1,z2, props, w_face, p_face)
    end

    local function sky_side(side, fh, ch, props, w_face, p_face)
      if GAME.format == "doom" then
        -- use delta_z to make the sky go down to the floor
        -- (as per MAP01 of DOOM II)
        local p_face2 = table.copy(p_face)
        p_face2.delta_z = fh - (ch-4);

        side_quad(side, 16, ch-4,nil, props, w_face, p_face2)
      else
        -- solid sky wall for Quake engines
        side_quad(side, 16, nil,nil, props, w_face, p_face)
      end
    end

    local kind, w_face, p_face = Mat_normal(LEVEL.outer_fence_tex)
    Trans.quad(x1,y1, x2,y2, nil,S.fence_h, { m=kind }, w_face, p_face)

    kind, w_face, p_face = Mat_sky()
    Trans.quad(x1,y1, x2,y2, SKY_H,nil, { m=kind }, w_face, p_face)

    for side = 2,8,2 do
      local N = S:neighbor(side)
      if not N or N.free then
        sky_side(side, S.fence_h, SKY_H, { m=kind }, w_face, p_face)
      end

      if N and ((N.room and not N.room.outdoor) or
                (N.edge_of_map and N.building))
      then
--!!!!        Build_shadow(S, side, 64)
      end
    end
  end

  ---| Layout_edge_of_map |---
  
  gui.debugf("Layout_edge_of_map\n")

  stretch_buildings()

  determine_walk_heights()

  for x = 1,SEED_W do for y = 1,SEED_H do
    local S = SEEDS[x][y]
    if S.edge_of_map then
      build_edge(S)
    end
  end end -- for x, y
end

