----------------------------------------------------------------
--  TILE-BASED LAYOUTER
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2009 Andrew Apted
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


function Tiler_insert_entity(tx, ty, name, angle, skill, flags)
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


function Tiler_add_entity(S, ...)
  local tx = (S.sx - 1) * 3 + 1
  local ty = (S.sy - 1) * 3 + 2

  Tiler_insert_entity(tx, ty, ...)
end


function Tiler_do_basic_room(R, wall, w_hue, floor)
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


function Tiler_layout_room(R)
  local mat = GAME.MATERIALS[R.main_tex]

  if not mat then
    gui.printf("LACKING MATERIAL : %s\n", tostring(R.main_tex))
    mat = assert(GAME.MATERIALS["_ERROR"])
  end

  assert(mat.t)

  Tiler_do_basic_room(R, mat.t, mat.hue, 108)

  if R.purpose == "START" then
    local tx = (R.sx1 - 1) * 3 + 3
    local ty = (R.sy1 - 1) * 3 + 3

    Tiler_insert_entity(tx, ty, "player1")
  end
end


function Tiler_layout_all()

  gui.printf("\n--==| Tiler_layout_all |==--\n\n")


  --==| Tiler_layout_all |==--

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

