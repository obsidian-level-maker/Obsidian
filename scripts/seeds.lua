----------------------------------------------------------------
--  SEED MANAGEMENT
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2008-2011 Andrew Apted
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

class SEED
{
  sx, sy  -- location in seed map

  x1, y1, x2, y2  -- 2D map coordinates

  room : ROOM
  hall : HALLWAY

  chunk : CHUNK

  edge[DIR]  -- keyword can be "solid", "air", "walk"
             -- can be nil (unallocated)
             -- only 2 and 4 directions are used

  floor_h, ceil_h -- floor and ceiling heights
  f_tex,   c_tex  -- floor and ceiling textures
}


--------------------------------------------------------------]]

require 'defs'
require 'util'


SEED_W = 0
SEED_H = 0

MAP_BASE_X = 0
MAP_BASE_Y = 0


SEED_CLASS = {}

function SEED_CLASS.new(x, y)
  local S = { sx=x, sy=y, border={} }
  table.set_class(S, SEED_CLASS)
  return S
end


function SEED_CLASS.tostr(S)
  return string.format("SEED [%d,%d]", S.sx, S.sy)
end


function SEED_CLASS.neighbor(S, dir, dist)
  local nx, ny = geom.nudge(S.sx, S.sy, dir, dist)
  if nx < 1 or nx > SEED_W or ny < 1 or ny > SEED_H then
    return nil
  end
  return SEEDS[nx][ny]
end


function SEED_CLASS.mid_point(S)
  return int((S.x1 + S.x2) / 2), int((S.y1 + S.y2) / 2)
end


function SEED_CLASS.get_edge(S, dir)
  -- far edges of map are always solid
  if (dir == 2 and S.sy == 1) or
     (dir == 4 and S.sx == 1) or
     (dir == 6 and S.sx == SEED_W) or
     (dir == 8 and S.sy == SEED_H)
  then
    return "solid"
  end

  if dir == 6 or dir == 8 then  
    S, dir = S:neighbor(dir), (10 - dir)
  end

  return S.edge[dir]
end


function SEED_CLASS.set_edge(S, dir, value)
  -- ignore edge of map
  if (dir == 2 and S.sy == 1) or
     (dir == 4 and S.sx == 1) or
     (dir == 6 and S.sx == SEED_W) or
     (dir == 8 and S.sy == SEED_H)
  then
    return
  end

  if dir == 6 or dir == 8 then  
    S, dir = S:neighbor(dir), (10 - dir)
  end

  -- validate (can never set it twice)
  if S.edge[dir] and value and S.edge[dir] ~= value then
    error("Seed_set_edge : already set!")
  end

  S.edge[dir] = value
end



--------------------------------------------------------------------


function Seed_init(map_W, map_H, free_W, free_H)
  gui.printf("Seed_init: %dx%d  Free: %dx%d\n", map_W, map_H, free_W, free_H)

  local W = map_W + free_W
  local H = map_H + free_H

  --- setup seed array ---

  SEED_W = W
  SEED_H = H

  SEEDS = table.array_2D(SEED_W, SEED_H)

  MAP_BASE_X = -SEED_SIZE
  MAP_BASE_Y = -SEED_SIZE

  -- Centre the map : needed for Quake, Hexen2 (etc).
  -- This formula ensures that 'coord 0' is still a seed boundary,
  -- which is VITAL for the Quake visibility code.
  if PARAM.centre_map then
    MAP_BASE_X = 0 - int(SEED_W / 2) * SEED_SIZE
    MAP_BASE_Y = 0 - int(SEED_H / 2) * SEED_SIZE
  end

  for x = 1,SEED_W do for y = 1,SEED_H do
    local S = SEED_CLASS.new(x, y)

    SEEDS[x][y] = S

    S.x1 = MAP_BASE_X + (x-1) * SEED_SIZE
    S.y1 = MAP_BASE_Y + (y-1) * SEED_SIZE

    S.x2 = S.x1 + SEED_SIZE
    S.y2 = S.y1 + SEED_SIZE

    if x > map_W or y > map_H then
      S.free = true
    elseif x == 1 or x == map_W or y == 1 or y == map_H then
      S.edge_of_map = true
    end
  end end -- x, y
end



function Seed_valid(x, y)
  return (x >= 1 and x <= SEED_W) and
         (y >= 1 and y <= SEED_H)
end



function Seed_flood_fill_edges()
  local active = {}

  for x = 1,SEED_W do for y = 1,SEED_H do
    local S = SEEDS[x][y]
    if S.edge_of_map then
      table.insert(active, S)
    end
  end end -- for x, y

  while not table.empty(active) do
    local new_active = {}

    for _,S in ipairs(active) do for side = 2,8,2 do
      local N = S:neighbor(side)
      if N and not N.edge_of_map and not N.free and not N.room and not N.hall then
        N.edge_of_map = true
        table.insert(new_active, N)
      end
    end end -- for S, side

    active = new_active
  end
end

