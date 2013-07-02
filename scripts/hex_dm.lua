----------------------------------------------------------------
--  HEXAGONAL DEATH-MATCH
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2013 Andrew Apted
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

class HEXAGON
{
    cx, cy   -- position in cell map

    neighbor[HDIR] : HEXAGON   -- neighboring cells
                               -- will be NIL at edge of map
                               -- HDIR is 1 .. 6

    is_edge : bool  -- true if at edge of map (one neighbor is NIL)

    mid_x, mid_y  -- coordinate of mid point

    vertex[HDIR] : { x=#, y=# }  -- leftmost vertex for each edge
}


Directions:
        _______
       /   5   \
      /4       6\
     /           \
     \           /
      \1       3/
       \___2___/

----------------------------------------------------------------]]


-- two dimensional grid / map
--
-- rows with an _even_ Y value are offset to the right:
--
--      1   2   3   4
--    1   2   3   4
--      1   2   3   4
--    1   2   3   4

HEX_MAP = {}

HEX_W = 30
HEX_H = 90


HEX_LEFT  = { 2, 3, 6, 1, 4, 5 }
HEX_RIGHT = { 4, 1, 2, 5, 6, 3 }
HEX_OPP   = { 6, 5, 4, 3, 2, 1 }
HEX_DIRS  = { 1, 4, 5, 6, 3, 2 }


HEXAGON_CLASS = {}

function HEXAGON_CLASS.new(cx, cy)
  local C =
  {
    cx = cx
    cy = cy
    neighbor = {}
    vertex = {}
  }
  table.set_class(C, HEXAGON_CLASS)
  return C
end


function HEXAGON_CLASS.tostr(C)
  return string.format("CELL[%d,%d]", C.cx, C.cy)
end


function HEXAGON_CLASS.to_brush(C)
  local brush = {}

  for i = 6, 1, -1 do
    local dir = HEX_DIRS[i]

    local coord =
    {
      x = C.vertex[dir].x
      y = C.vertex[dir].y
    }

    table.insert(brush, coord)
  end

  return brush
end


function HEXAGON_CLASS.build(C)
  
  local f_h = rand.irange(0,6) * 4
  local c_h = rand.irange(4,8) * 32


  if C.is_edge or (not C.is_start and rand.odds(25)) then
    local w_brush = C:to_brush()

    Brush_set_mat(w_brush, "ASHWALL4", "ASHWALL4")

    brush_helper(w_brush)
  else
    local f_brush = C:to_brush()

    local f_mat = rand.pick({ "GRAY7", "MFLR8_3", "MFLR8_4", "STARTAN3",
                              "TEKGREN2", "BROWN1" })

    Brush_add_top(f_brush, f_h)
    Brush_set_mat(f_brush, f_mat, f_mat)

    brush_helper(f_brush)


    local c_brush = C:to_brush()

    Brush_add_bottom(c_brush, 256)
    Brush_mark_sky(c_brush)

    brush_helper(c_brush)
  end


  if C.is_start then
    entity_helper("dm_player", C.mid_x, C.mid_y, f_h, {})

    if not LEVEL.has_p1_start then
      entity_helper("player1", C.mid_x, C.mid_y, f_h, {})
      LEVEL.has_p1_start = true
    end
  end
end


----------------------------------------------------------------

H_WIDTH  = 80
H_HEIGHT = 64


function Hex_middle_coord(cx, cy)
  local x = H_WIDTH  * (1 + (cx - 1) * 3 + (1 - (cy % 2)) * 1.5)
  local y = H_HEIGHT * cy

  return math.round(x), math.round(y)
end


function Hex_neighbor_pos(cx, cy, dir)
  if dir == 2 then return cx, cy - 2 end
  if dir == 5 then return cx, cy + 2 end

  if (cy % 2) == 0 then
    if dir == 1 then return cx, cy - 1 end
    if dir == 4 then return cx, cy + 1 end
    if dir == 3 then return cx + 1, cy - 1 end
    if dir == 6 then return cx + 1, cy + 1 end
  else
    if dir == 1 then return cx - 1, cy - 1 end
    if dir == 4 then return cx - 1, cy + 1 end
    if dir == 3 then return cx, cy - 1 end
    if dir == 6 then return cx, cy + 1 end
  end
end


function Hex_vertex_coord(C, dir)
  local x, y

  if dir == 1 then
    x = C.mid_x - H_WIDTH / 2
    y = C.mid_y - H_HEIGHT
  elseif dir == 2 then
    x = C.mid_x + H_WIDTH / 2
    y = C.mid_y - H_HEIGHT
  elseif dir == 3 then
    x = C.mid_x + H_WIDTH
    y = C.mid_y
  elseif dir == 4 then
    x = C.mid_x - H_WIDTH
    y = C.mid_y
  elseif dir == 5 then
    x = C.mid_x - H_WIDTH / 2
    y = C.mid_y + H_HEIGHT
  elseif dir == 6 then
    x = C.mid_x + H_WIDTH / 2
    y = C.mid_y + H_HEIGHT
  end

  return math.round(x), math.round(y)
end


function Hex_setup()
  HEX_MAP = table.array_2D(HEX_W, HEX_H)

  -- 1. create the hexagon cells

  for cx = 1, HEX_W do
  for cy = 1, HEX_H do
    local C = HEXAGON_CLASS.new(cx, cy)

    C.mid_x, C.mid_y = Hex_middle_coord(cx, cy)

    HEX_MAP[cx][cy] = C
  end
  end

  -- 2. setup neighbor links

  for cx = 1, HEX_W do
  for cy = 1, HEX_H do
    local C = HEX_MAP[cx][cy]

    for dir = 1,6 do
      local nx, ny = Hex_neighbor_pos(cx, cy, dir)

      if (nx >= 1) and (nx <= HEX_W) and
         (ny >= 1) and (ny <= HEX_H)
      then
        C.neighbor[dir] = HEX_MAP[nx][ny]
      else
        C.is_edge = true
      end
    end
  end
  end

  -- 3. setup vertices

  for cx = 1, HEX_W do
  for cy = 1, HEX_H do
    local C = HEX_MAP[cx][cy]
  
    for dir = 1,6 do
      local x, y = Hex_vertex_coord(C, dir)

      C.vertex[dir] = { x=x, y=y }
    end
  end
  end
end


function Hex_build_all()
  for cx = 1, HEX_W do
  for cy = 1, HEX_H do
    local C = HEX_MAP[cx][cy]

    C:build()
  end
  end
end


function Hex_create_level()
  Hex_setup()

  LEVEL.sky_light = 192
  LEVEL.sky_shade = 160

  HEX_MAP[9][40].is_start = true

  Hex_build_all()
end

