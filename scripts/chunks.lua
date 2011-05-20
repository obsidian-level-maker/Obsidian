----------------------------------------------------------------
--  CHUNKY STUFF
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2011 Andrew Apted
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

class CHUNK
{
  sx1, sy1, sx2, sy2  -- seed range

  x1, y1, x2, y2  -- 2D map coordinates

  room : ROOM
  hall : HALL

  section : SECTION
  hx, hy  --  coordinates of chunk in section

  link[DIR] : LINK

  parts[DIR] : PART  -- divides the chunk into 3x3 sub-areas
                     -- 2/4/6/8 directions are edges
                     -- 1/3/7/9 directions are corners
                     -- each can be NIL if nothing is there
                     -- edges may occupy whole side (no corner then)

  floor_h, ceil_h -- floor and ceiling heights

  f_tex,   c_tex  -- floor and ceiling textures
}


class LINK
{
  C1, C2  -- chunks which are linked

  dir     -- direction from C1 to C2

  conn : CONN

  x1, x2  |  y1, y2  -- coordinate range shared between chunks
}


class PART
{
  chunk, side   -- identification

  x1, y1, x2, y2   -- coverage on 2D map

  fab  -- a prefab which fills the whole 2d area
}


--------------------------------------------------------------]]

require 'defs'
require 'util'


CHUNK_CLASS = {}

function CHUNK_CLASS.new(sx1, sy1, sx2, sy2)
  local C = { sx1=sx1, sy1=sy1, sx2=sx2, sy2=sy2, parts={}, link={} }
  table.set_class(C, CHUNK_CLASS)
  return C
end


function CHUNK_CLASS.tostr(C)
  return string.format("CHUNK [%d,%d]", C.sx1, C.sy1)
end


function CHUNK_CLASS.install(C)
  for sx = C.sx1, C.sx2 do for sy = C.sy1, C.sy2 do
    local S = SEEDS[sx][sy]
    assert(S)

    -- verify not already allocated
    if S.chunk then
      error("tried to allocate overlapping chunks!")
    end

    S.chunk = C
  end end

  -- set map coordinates
  local S1 = SEEDS[C.sx1][C.sy1]
  local S2 = SEEDS[C.sx2][C.sy2]

  C.x1, C.y1 = S1.x1, S1.y1
  C.x2, C.y2 = S2.x2, S2.y2
end


function CHUNK_CLASS.joining_chunks(C, dir)
  local list = {}

  local sx1, sy1, sx2, sy2 = geom.side_coords(dir, C.sx1, C.sy1, C.sx2, C.sy2)

  sx1, sy1 = geom.nudge(sx1, sy1, dir)
  sx2, sy2 = geom.nudge(sx2, sy2, dir)

  for sx = sx1,sx2 do for sy = sy1,sy2 do
    assert(Seed_valid(sx, sy))

    local S = SEEDS[sx][sy]

    if S and S.chunk and not table.has_elem(list, S.chunk) then
      table.insert(list, S.chunk)
    end
  end end

  return list
end


function CHUNK_CLASS.mid_point(C)
  return int((C.x1 + C.x2) / 2), int((C.y1 + C.y2) / 2)
end


function CHUNK_CLASS.seed_volume(C)
  return (C.sx2 - C.sx1 + 1) * (C.sy2 - C.sy1 + 1)
end


function CHUNK_CLASS.side_len(C, dir)
  return geom.vert_sel(dir, C.x2 - C.x1, C.y2 - C.y1)
end


function CHUNK_CLASS.is_adjacent(C1, C2)
  if C1.x1 > (C2.x2 + 1) then return false end
  if C1.x2 < (C2.x1 - 1) then return false end

  if C1.y1 > (C2.y2 + 1) then return false end
  if C1.y2 < (C2.y1 - 1) then return false end

  -- only touches at a corner?
  if (C1.x1 > C2.x2 or C1.x2 < C2.x1) and
     (C1.y1 > C2.y2 or C1.y2 < C2.y1)
  then return false end 

  return true
end


function CHUNK_CLASS.good_neighbor(C1, dir)
  -- a 'good' neighbor is one which is at least the same size as
  -- the current chunk (can be bigger, but not smaller).
  -- If such a chunk exists, return it, otherwise NIL.

  local nx, ny = C1.sx1, C1.sy1

  if dir == 2 then ny = C1.sy1 - 1 end
  if dir == 8 then ny = C1.sy2 + 1 end
  if dir == 4 then nx = C1.sx1 - 1 end
  if dir == 6 then nx = C1.sx2 + 1 end

  if not Seed_valid(nx, ny) then return nil end

  local C2 = SEEDS[nx][ny].chunk

  if not C2 then return nil end

  if geom.is_vert(dir) then
    if (C2.x1 > C1.x1) or (C2.x2 < C2.x2) then return nil end
  else
    if (C2.y1 > C1.y1) or (C2.y2 < C2.y2) then return nil end
  end

  return C2  -- OK --
end


----------------------------------------------------------------


function CHUNK_CLASS.similar_neighbor(C, dir)
  local sx, sy

  local mx = int((C.sx1 + C.sx2) / 2)
  local my = int((C.sy1 + C.sy2) / 2)

      if dir == 2 then sx, sy = mx, C.sy1 - 1
  elseif dir == 8 then sx, sy = mx, C.sy2 + 1
  elseif dir == 4 then sx, sy = C.sx1 - 1, my
  elseif dir == 6 then sx, sy = C.sx2 + 1, my
  end

  if not Seed_valid(sx, sy) then
    return false
  end

  local S = SEEDS[sx][sy]

--do return (S and (S.room or S.hall)) end --!!!!!!!1

  if C.hall then return (S.hall == C.hall) end
  if C.room then return (S.room == C.room) end

  return false
end



function CHUNK_CLASS.purpose_start(C)
  local mx, my = C:mid_point()

  local T = Trans.spot_transform(mx, my, C.floor_h or 0, 0)

  local skin1 = { top="O_BOLT" }

  Fabricate("START_SPOT", T, { skin1 })
end


function CHUNK_CLASS.purpose_exit(C)
  -- FIXME QUAKE_EXIT_PAD

  local mx, my = C:mid_point()

  local T = Trans.spot_transform(mx, my, C.floor_h or 0, 0)

  local skin1 = { switch="SW1BLUE", line_kind=11, tag=0, exit="EXITSIGN", exitside="COMPSPAN" }

  Fabricate("EXIT_PILLAR", T, { skin1 })
end


function CHUNK_CLASS.purpose_key(C)
  local R = C.room

  local LOCK = assert(C.lock)
  assert(LOCK.key)

  local mx, my = C:mid_point()

  Trans.entity(LOCK.key, mx, my, C.floor_h or 0)
end


function CHUNK_CLASS.purpose_switch(C)
  -- FIXME: determine skin1 properly

  assert(C.lock)

  local skin1 = assert(GAME.SKINS["Switch_blue1"])
  local skin2 = { tag=C.lock.tag }

  local mx, my = C:mid_point()

  local T = Trans.spot_transform(mx, my, C.floor_h or 0, 0)

  Fabricate("SMALL_SWITCH", T, { skin1, skin2 })
end


function CHUNK_CLASS.do_purpose(C)
  if C.purpose == "START" then
    C:purpose_start()

  elseif C.purpose == "EXIT" then
    C:purpose_exit()

  elseif C.purpose == "KEY" then
    C:purpose_key()

  elseif C.purpose == "SWITCH" then
    C:purpose_switch()
  end
end



function CHUNK_CLASS.unpack_parts(C, filter_field)
  -- returns a list of rectangles which represent the area of the
  -- chunk _minus_ the areas of the parts.

  local spaces =
  {
    { x1=C.x1, y1=C.y1, x2=C.x2, y2=C.y2 }
  }

  local function split_space_X(S, N)
    if N.x1 > S.x1 then
      local T = table.copy(S)
      S.x1 = N.x1 ; T.x2 = N.x1
      table.insert(spaces, T)
    end

    if N.x2 < S.x2 then
      local T = table.copy(S)
      S.x2 = N.x2 ; T.x1 = N.x2
      table.insert(spaces, T)
    end

    if N.y1 > S.y1 then
      local T = table.copy(S)
      S.y1 = N.y1 ; T.y2 = N.y1
      table.insert(spaces, T)
    end

    if N.y2 < S.y2 then
      local T = table.copy(S)
      S.y2 = N.y2 ; T.y1 = N.y2
      table.insert(spaces, T)
    end
  end

  local function split_space_Y(S, N)
    -- same code as above, but do Y first

    if N.y1 > S.y1 then
      local T = table.copy(S)
      S.y1 = N.y1 ; T.y2 = N.y1
      table.insert(spaces, T)
    end

    if N.y2 < S.y2 then
      local T = table.copy(S)
      S.y2 = N.y2 ; T.y1 = N.y2
      table.insert(spaces, T)
    end
     
    if N.x1 > S.x1 then
      local T = table.copy(S)
      S.x1 = N.x1 ; T.x2 = N.x1
      table.insert(spaces, T)
    end

    if N.x2 < S.x2 then
      local T = table.copy(S)
      S.x2 = N.x2 ; T.x1 = N.x2
      table.insert(spaces, T)
    end
  end

  local function split_space(S, N)
    local x_dist = math.min(
      math.abs(S.x1 - N.x1), math.abs(S.x1 - N.x2),
      math.abs(S.x2 - N.x1), math.abs(S.x2 - N.x2))

    local y_dist = math.min(
      math.abs(S.y1 - N.y1), math.abs(S.y1 - N.y2),
      math.abs(S.y2 - N.y1), math.abs(S.y2 - N.y2))

    if x_dist < y_dist then
      split_space_X(S, N)
    else
      split_space_Y(S, N)
    end
  end

  local function remove_rect(N)
    -- rebuild the list
    local old_spaces = spaces
    spaces = {}

    each S in old_spaces do
      if geom.boxes_overlap(S.x1,S.y1,S.x2,S.y2, N.x1,N.y1,N.x2,N.y2) then
        split_space(S, N)
      end
    end
  end

  each P in C.parts do
    if filter_field and P[filter_field] then continue end
    remove_rect(P)
  end

  return spaces
end



function CHUNK_CLASS.build(C)

  -- TEMP TEMP CRUD CRUD

  local f_h = assert(C.floor_h)
  local c_h = f_h + 256
  local c_medium = "solid"
  local light = 0

  local w_mat, w_tex
  local f_mat, f_tex
  local c_mat, c_tex

  local x1, y1 = C.x1, C.y1
  local x2, y2 = C.x2, C.y2


  if C.room then
    w_mat = assert(C.room.main_tex)
    f_mat = C.room:pick_floor_mat(f_h)
    c_mat = C.room:pick_ceil_mat()

  elseif C.hall then
    w_mat = assert(C.hall.wall_tex)
    f_mat = assert(C.hall.floor_tex)
    c_mat = assert(C.hall.ceil_tex)

    c_h = f_h + C.hall.height
  else
    error("Chunk not in room or hall??")
  end

  if C.room and C.room.outdoor then
    c_mat = "_SKY"
    c_medium = "sky"
    c_h = assert(C.room.sky_h)

  else
    light = rand.irange(40, 100)
    if C.hall then light = light * 0.5 end
  end


  -- floor

  f_mat = Mat_lookup(f_mat)
  f_tex = f_mat.f or f_mat.t

  local brush = Trans.bare_quad(C.x1, C.y1, C.x2, C.y2)

  Trans.set_tex(brush, f_mat.t)

  table.insert(brush, { t=f_h, tex=f_tex })

  gui.add_brush(brush)


  -- ceiling

  c_mat = Mat_lookup(c_mat)
  c_tex = c_mat.f or f_mat.t

  brush = Trans.bare_quad(C.x1, C.y1, C.x2, C.y2)

  if c_medium == "sky" then
    table.insert(brush, 1, { m="sky" })
  end

  Trans.set_tex(brush, c_mat.t)

  table.insert(brush, { b=c_h, tex=c_tex })

  gui.add_brush(brush)


  -- parts

  for dir = 1,9,2 do
    local P = C.parts[dir]

    if P then --[[ FIXME --]] end
  end


  -- walls

  w_mat = Mat_lookup(w_mat)
  w_tex = w_mat.t

  local thick = 16

  for dir = 2,8,2 do
    if not C:similar_neighbor(dir) then
      local bx1, by1, bx2, by2 = x1,y1, x2,y2

      if dir == 2 then by2 = by1 + thick end
      if dir == 8 then by1 = by2 - thick end
      if dir == 4 then bx2 = bx1 + thick end
      if dir == 6 then bx1 = bx2 - thick end

      if C.link[dir] then
        local LINK = C.link[dir]

        local cx1, cy1, cx2, cy2 = bx1, by1, bx2, by2

        if geom.is_vert(dir) then
          bx2 = assert(LINK.x1)
          cx1 = assert(LINK.x2)
        else
          by2 = assert(LINK.y1)
          cy1 = assert(LINK.y2)
        end

        if bx2 > bx1 then
          brush = Trans.bare_quad(bx1, by1, bx2, by2)
          Trans.set_tex(brush, w_mat.t)
          gui.add_brush(brush)
        end

        if cx2 > cx1 then
          brush = Trans.bare_quad(cx1, cy1, cx2, cy2)
          Trans.set_tex(brush, w_mat.t)
          gui.add_brush(brush)
        end

      else
          brush = Trans.bare_quad(bx1, by1, bx2, by2)
          Trans.set_tex(brush, w_mat.t)
          gui.add_brush(brush)
      end
    end


    -- locked doors
    if C.link[dir] then
      local LINK = C.link[dir]

      if LINK.conn and LINK.conn.lock and LINK.conn.lock.kind == "KEY" then
        local list = THEME.lock_doors

        local edge_fabs = Layout_possible_prefab_from_list(list, "edge", LINK.conn.lock.key)

        local name = rand.key_by_probs(edge_fabs)

        local skin = assert(GAME.SKINS[name])

        local T = Trans.edge_transform(C.x1, C.y1, C.x2, C.y2, f_h, dir,
                                       0, 192, 32, 32)

        local skin2 = { inner="CRACKLE2", outer="CRACKLE4", wall="COMPSPAN" }

        Fabricate(skin._prefab, T, { skin, skin2 })
      end

      if LINK.conn and LINK.conn.lock and LINK.conn.lock.kind == "SWITCH" then
        local name = "Door_SW_blue"  -- FIXME: determine properly

        local skin = assert(GAME.SKINS[name])

        local T = Trans.edge_transform(C.x1, C.y1, C.x2, C.y2, f_h, dir,
                                       0, 192, 32, 32)

        local skin2 = { tag=LINK.conn.lock.tag, inner="CRACKLE2", outer="CRACKLE4", wall="TEKWALL4" }

        Fabricate(skin._prefab, T, { skin, skin2 })
      end
    end
  end


  -- object

  local ent = "dummy"

  if C.purpose then C:do_purpose() end

  if C.weapon then ent = C.weapon end

  local mx, my = C:mid_point()

  Trans.entity(ent, mx, my, 32)


  -- lighting

  if light > 0 and GAME.format != "doom" then
    local z = rand.irange(64, c_h-32)
    Trans.entity("light", mx, my, z, { light=light, _radius=400 })
  end


  -- spots [FIXME : do it properly]
  if C.room and not C.purpose then
    local R = C.room

    -- begin with a completely solid area
    gui.spots_begin(C.x1, C.y1, C.x2, C.y2, 2)

    -- carve out the floor brushes (make them empty)
    local B = Trans.bare_quad(C.x1 + 40, C.y1 + 40, C.x2 - 40, C.y2 - 40)

    gui.spots_fill_poly(B, 0)

--[[
    -- solidify brushes from prefabs
    for _,fab in ipairs(R.prefabs) do
      remove_prefab(fab)
    end

    -- remove solid decor entities
    for _,dec in ipairs(R.decor) do
      remove_decor(dec)
    end

    -- mark edges with neighboring floors
    for _,F in ipairs(R.all_floors) do
      if F != floor then
        remove_neighbor_floor(floor, F)
      end
    end
--]]

--  gui.spots_dump("Spot grid")

    -- use local lists, since we will process multiple floors
    local mon_spots  = {}
    local item_spots = {}

    gui.spots_get_mons (mon_spots)
    gui.spots_get_items(item_spots)

    gui.spots_end()

    if table.empty(item_spots) and mon_spots[1] then
      table.insert(item_spots, mon_spots[1])
    end

    -- set Z positions

    each spot in mon_spots do
      spot.z1 = f_h
      spot.z2 = f_h2 or (spot.z1 + 200)  -- FIXME

      table.insert(R.mon_spots, spot)
    end

    each spot in item_spots do
      spot.z1 = f_h
      spot.z2 = f_h2 or (spot.z1 + 64)

      table.insert(R.item_spots, spot)
    end

--[[ TEST
    each spot in R.item_spots do
      Trans.entity("potion", spot.x1 + 8, spot.y1 + 8, 0)
    end
--]]
  end


  -- TEST CRUD : pillars

  if ent != "player1" and C.section and false then
    local hx = 777 -- C.section:mid_HX()
    local hy = 888 -- C.section:mid_HY()

    if C.hx == hx and C.hy == hy then

      local mx = math.imid(x1, x2)
      local my = math.imid(y1, y2)
      
      local T = Trans.spot_transform(mx, my, f_h, 0)

      local skin1 = { pillar="TEKWALL4" }

      Fabricate("ROUND_PILLAR", T, { skin1 })
    end
  end
end

