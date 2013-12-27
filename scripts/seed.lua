----------------------------------------------------------------
--  SEED MANAGEMENT / GROWING
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2008-2014 Andrew Apted
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
  sx, sy, sz  -- location in seed map

  room : ROOM

  kind : keyword  -- main usage of seed:
                  -- "walk", "void", "diagonal",
                  -- "stair", "curve_stair", "tall_stair",
                  -- "liquid"

  content : keyword  -- normally nil, but can be:
                     -- "pillar"

  border[DIR] : BORDER

  thick[DIR]  -- thickness of each border

  x1, y1, x2, y2  -- 2D map coordinates

  floor_h, ceil_h -- floor and ceiling heights
  f_tex,   c_tex  -- floor and ceiling textures
}


class BORDER
{
  kind  : nil (when not decided yet)
          "nothing", "straddle",
          "wall", "facade", "fence", "window",
          "arch", "door", "locked_door",

  other : SEED  -- seed we are connected to, or nil 

}

--------------------------------------------------------------]]


SEED_W = 0
SEED_H = 0
SEED_D = 0


SEED_CLASS = {}

function SEED_CLASS.tostr(S)
  return string.format("SEED [%d,%d,%s]",
      S.sx, S.sy, S.kind or "-")
end

function SEED_CLASS.neighbor(S, dir, dist)
  local nx, ny = geom.nudge(S.sx, S.sy, dir, dist)
  if nx < 1 or nx > SEED_W or ny < 1 or ny > SEED_H then
    return nil
  end
  return SEEDS[nx][ny][1]
end

function SEED_CLASS.mid_point(S)
  return int((S.x1 + S.x2) / 2), int((S.y1 + S.y2) / 2)
end


function Seed_init(map_W, map_H, map_D, free_W, free_H)
  gui.printf("Seed_init: %dx%d  Free: %dx%d\n", map_W, map_H, free_W, free_H)

  local W = map_W + free_W
  local H = map_H + free_H
  local D = map_D

  -- setup globals 
  SEED_W = W
  SEED_H = H
  SEED_D = D

  SEEDS = table.array_2D(W, H)

  for x = 1,W do for y = 1,H do
    SEEDS[x][y] = {}

    for z = 1,D do
      local S =
      {
        sx=x, sy=y, sz=z,

        x1 = (x-1) * SEED_SIZE,
        y1 = (y-1) * SEED_SIZE,

        thick  = {},
        border = {},
      }

      -- centre the map : needed for Quake, OK for other games
      -- (this formula ensures that 'coord 0' is still a seed boundary)
      S.x1 = S.x1 - int(SEED_W / 2) * SEED_SIZE
      S.y1 = S.y1 - int(SEED_H / 2) * SEED_SIZE

      S.x2 = S.x1 + SEED_SIZE
      S.y2 = S.y1 + SEED_SIZE

      table.set_class(S, SEED_CLASS)

      for side = 2,8,2 do
        S.border[side] = {}
        S.thick[side] = 16
      end

      if x > map_W or y > map_H then
        S.free = true
      elseif x == 1 or x == map_W or y == 1 or y == map_H then
        S.edge_of_map = true
      end

      SEEDS[x][y][z] = S
    end
  end end -- x,y
end


function Seed_close()
  SEEDS = nil

  SEED_W = 0
  SEED_H = 0
  SEED_D = 0
end


function Seed_valid(x, y, z)
  return (x >= 1 and x <= SEED_W) and
         (y >= 1 and y <= SEED_H) and
         (z >= 1 and z <= SEED_D)
end


function Seed_get_safe(x, y, z)
  return Seed_valid(x, y, z) and SEEDS[x][y][z]
end


function Seed_is_free(x, y, z)
  assert(Seed_valid(x, y, z))

  return not SEEDS[x][y][z].room
end


function Seed_valid_and_free(x, y, z)
  if not Seed_valid(x, y, z) then
    return false
  end

  if SEEDS[x][y][z].room then
    return false
  end

  return true
end


function Seed_block_valid_and_free(x1,y1,z1, x2,y2,z2)

  assert(x1 <= x2 and y1 <= y2 and z1 <= z2)

  if not Seed_valid(x1, y1, z1) then return false end
  if not Seed_valid(x2, y2, z2) then return false end

  for x = x1,x2 do for y = y1,y2 do for z = z1,z2 do
    local S = SEEDS[x][y][z]
    if S.room then
      return false
    end
  end end end -- x, y, z

  return true
end


function Seed_dump_rooms()
  local function seed_to_char(S)
    if not S then return "!" end
    if S.free then return "." end
    if S.edge_of_map then return "#" end
    if not S.room then return "?" end

    if S.room.kind == "scenic" then return "=" end

    if S.room.parent then
      local n = 1 + (S.room.id % 26)
      return string.sub("abcdefghijklmnopqrstuvwxyz", n, n)
    end

    local n = 1 + (S.room.id % 26)
    return string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZ", n, n)
  end

  for y = SEED_H,1,-1 do
    local line = "@c"
    for x = 1,SEED_W do
      line = line .. seed_to_char(SEEDS[x][y][1])
    end
    gui.printf("%s\n", line)
  end

  gui.printf("\n")
end


function Seed_flood_fill_edges()
  local active = {}

  for x = 1,SEED_W do for y = 1,SEED_H do
    local S = SEEDS[x][y][1]
    if S.edge_of_map then
      table.insert(active, S)
    end
  end end -- for x, y

  while not table.empty(active) do
    local new_active = {}

    each S in active do for side = 2,8,2 do
      local N = S:neighbor(side)
      if N and not N.edge_of_map and not N.free and not N.room then
        N.edge_of_map = true
        table.insert(new_active, N)
      end
    end end -- for S, side

    active = new_active
  end
end

