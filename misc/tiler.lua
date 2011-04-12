----------------------------------------------------------------
--  TILE-BASED LAYOUTER
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


function Tiler_add_entity(name, tx, ty, angle, skill, flags)
  assert(1 <= tx and tx <= 64)
  assert(1 <= ty and ty <= 64)

  local info = assert(GAME.ENTITIES[name])
  
  local id = info.id

  if type(id) == "table" then
    -- FIXME support skills and angles
    id = assert(id.easy)
  end

  gui.wolf_block(tx, ty, 2, id)
end


function Tiler_add_monster(name, spot, skill)
  Tiler_add_entity(name, spot.block_x, spot.block_y, 0, skill)
end


function OLD__Tiler_do_basic_room(R, wall, w_hue, floor)
  local x1 = (R.sx1 - 1) * 3 + 1
  local y1 = (R.sy1 - 1) * 3 + 1

  local x2 = (R.sx2 - 1) * 3 + 3
  local y2 = (R.sy2 - 1) * 3 + 3

  assert(1 <= x1 and x1 <= x2 and x2 <= 64)
  assert(1 <= y1 and y1 <= y2 and y2 <= 64)

  for tx = x1,x2 do for ty = y1,y2 do
    local sx = int( (tx + 2) / 3 )
    local sy = int( (ty + 2) / 3 )

    local S = SEEDS[sx][sy]
    if S.room == R then

      if ((tx == x1) or (tx == x2) or (ty == y1) or (ty == y2)) then
        gui.wolf_block(tx, ty, 1, wall)
        gui.wolf_mini_map(tx, ty, w_hue)
      else
        gui.wolf_block(tx, ty, 1, floor)
        gui.wolf_mini_map(tx, ty, "#777")
      end
    end
  end end -- for tx, ty

  -- doors --

  local function do_door(S, side, tile_ew, tile_ns)
    local tx = (S.sx - 1) * 3 + 2
    local ty = (S.sy - 1) * 3 + 2

    tx, ty = nudge_coord(tx, ty, side)
    
    if side == 2 or side == 8 then
      gui.wolf_block(tx, ty, 1, tile_ns)
    else
      gui.wolf_block(tx, ty, 1, tile_ew)
    end
  end

  for sx = R.sx1, R.sx2 do for sy = R.sy1, R.sy2 do
    local S = SEEDS[sx][sy]
    if S.room == R then

      for side = 2,8,2 do
        local B_kind = nil --!!!!!! FIXME  S.border[side].kind
        if B_kind == "door" then
          do_door(S, side, 90, 91)
        elseif B_kind == "arch" or B_kind == "straddle" or B_kind == "nothing" then
          do_door(S, side, floor, floor)
        end
      end

    end
  end end -- for sx, sy
end


function Tiler_near_wall(x, y)
  if x == 1 or x == 64 or y == 1 or y == 64 then
    return true
  end

  for dir = 2,8,2 do
    local nx, ny = geom.nudge(x, y, dir)

    if gui.wolf_read(nx, ny, 1) < 96 then
      return true
    end
  end

  return false
end


function Tiler_create_spots(R)
  local dither = 0

  local function add_spot(K, x, y)
    -- places near a wall get mostly items,
    -- places in the middle get mostly monsters.

    local near_wall = Tiler_near_wall(x, y)

    local spot = { block_x = x, block_y = y }

    if rand.odds(sel(near_wall, 0, 95)) then
      table.insert(R.mon_spots, spot)
    else
      table.insert(R.item_spots, spot)
    end
  end

  ---| Tiler_create_spots |---

  local floor_id = 108

  for _,K in ipairs(R.sections) do
    for x = K.bx1, K.bx2 do for y = K.by1, K.by2 do
      local wall  = gui.wolf_read(x, y, 1)
      local thing = gui.wolf_read(x, y, 2)

      if wall == floor_id and thing == 0 then
        add_spot(K, x, y)
      end
    end end
  end
end


function Tiler_fill_section(K, wall, w_hue, floor)
 
  -- floor --

  for x = K.bx1, K.bx2 do for y = K.by1, K.by2 do
    gui.wolf_block(x, y, 1, floor)
    gui.wolf_mini_map(x, y, "#777")
  end end

  -- corners --

  for corner = 1,9,2 do if corner ~= 5 then
    local x, y = geom.pick_corner(corner, K.bx1,K.by1, K.bx2,K.by2)

    gui.wolf_block(x, y, 1, wall)
    gui.wolf_mini_map(x, y, w_hue)
  end end

  -- edges --

  for side = 2,8,2 do
    local lx, ly = K.bx1, K.by1
    local ax, ay = 1, 0

    local long = K.bx2 - K.bx1 - 1
    local deep = K.by2 - K.by1 - 1

    if side == 6 then lx = K.bx2 end
    if side == 8 then ly = K.by2 end

    if geom.is_horiz(side) then
      ly = ly + 1
      long, deep = deep, long
      ax, ay = ay, ax
    else
      lx = lx + 1
    end

    if not K:same_room(side) then
      local door_pos = int((long+1) / 2)

      for n = 1,long do
        local x = lx + ax * (n-1)
        local y = ly + ay * (n-1)

        if n == door_pos and K:side_has_conn(side) then
          local N = K:neighbor(side)
          if K.room.id < N.room.id and rand.odds(30) then
            -- add a door
            local door = sel(geom.is_horiz(side), 90, 91)
            gui.wolf_block(x, y, 1, door)
          else
            -- keep it blank
          end
        else
          gui.wolf_block(x, y, 1, wall)
          gui.wolf_mini_map(x, y, w_hue)
        end
      end
    end
  end
end


function Tiler_layout_room(R)
  local mat = GAME.MATERIALS[R.main_tex]

  if not mat then
    gui.printf("LACKING MATERIAL : %s\n", tostring(R.main_tex))
    mat = assert(GAME.MATERIALS["_ERROR"])
  end

  assert(mat.t)

  for _,K in ipairs(R.sections) do
    Tiler_fill_section(K, mat.t, mat.hue, 108)
  end

  if R.purpose == "START" or R.purpose == "EXIT" then
    local K = R.sections[1]    

    local x = K.bx1 + int(K.bw / 2)
    local y = K.by1 + int(K.bh / 2)

    if R.purpose == "START" then
      Tiler_add_entity("player1", x, y)
    else
      Tiler_add_entity("chest", x, y)
    end
  end

  Tiler_create_spots(R)
end


function Tiler_setup_sections()

  local function dump_sizes(line, t, total)
    for i = 1,#t do
      line = line .. tostring(t[i]) .. " "
    end
    gui.printf("%s = %d\n", line, total)
  end

  ---| Tiler_setup_sections |---

  -- calculate section coordinates in BLOCKS
  local section_W = {}
  local section_H = {}

  local section_X = {}
  local section_Y = {}

  local total_W = PARAM.border_seeds * 2
  local total_H = PARAM.border_seeds * 2

  for x = 1,SECTION_W do
    section_W[x] = SECTIONS[x][1].sw * 2 + 1
    section_X[x] = total_W + 1

    total_W = total_W + section_W[x]
  end

  for y = 1,SECTION_H do
    section_H[y] = SECTIONS[1][y].sh * 2 + 1
    section_Y[y] = total_H + 1

    total_H = total_H + section_H[y]
  end

  total_W = total_W + PARAM.border_seeds * 2
  total_H = total_H + PARAM.border_seeds * 2

  dump_sizes("Tiler Column widths: ", section_W, total_W)
  dump_sizes("Tiler Row heights:   ", section_H, total_H)

  if total_W > PARAM.block_limit or total_H > PARAM.block_limit then
    error("Tiler planner failure, map is too large")
  end

  -- assign coordinates to all sections

  for x = 1,SECTION_W do for y = 1,SECTION_H do
    local K = SECTIONS[x][y]

    K.bx1 = section_X[x]
    K.by1 = section_Y[y]

    K.bw = section_W[x]
    K.bh = section_H[y]

    K.bx2 = K.bx1 + K.bw - 1
    K.by2 = K.by1 + K.bh - 1
  end end
end


function Tiler_layout_all()

  gui.printf("\n--==| Tiler_layout_all |==--\n\n")

  --==| Tiler_layout_all |==--

  Tiler_setup_sections()

  for _,R in ipairs(LEVEL.all_rooms) do
    Tiler_layout_room(R)
  end
end


----------------------------------------------------------------

function Tiler_test()
  for x = 1,64 do for y = 1,64 do

    local wall = 108
    if x <= 4 or x >= 31 or y <= 4 or y >= 31 then
      wall = 18
    end

    local thing = 0
    if x == 8  and y == 8  then thing = 19 end
    if x == 12 and y == 12 then thing = 24 end
    if x == 16 and y == 16 then thing = 25 end

    gui.wolf_block(x, y, 1, wall)
    gui.wolf_block(x, y, 2, thing)
  end end
end

