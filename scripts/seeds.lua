----------------------------------------------------------------
--  SEED MANAGEMENT / GROWING
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2008 Andrew Apted
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

  border[DIR] : BORDER

  thick[DIR]  -- thickness of each border

  x1, y1, x2, y2  -- 2D map coordinates

  floor_h, ceil_h -- floor and ceiling heights

  layout : LAYOUT
}


class BORDER
{
  kind  : "solid" | "view" | "walk"

  other : SEED  -- seed we are connected to, or nil 

}

--------------------------------------------------------------]]

require 'defs'
require 'util'


SEED_W = 0
SEED_H = 0
SEED_D = 0


SEED_CLASS =
{
  neighbor = function(self, dir)
    local nx, ny = nudge_coord(self.sx, self.sy, dir)
    if nx < 1 or nx > SEED_W or ny < 1 or ny > SEED_H then
      return nil
    end
    return SEEDS[nx][ny][1]
  end,

  mid_point = function(self)
    return int((self.x1 + self.x2) / 2), int((self.y1 + self.y2) / 2)
  end,
}


function Seed_init(W, H, D)

  -- setup globals 
  SEED_W = W
  SEED_H = H
  SEED_D = D

  SEEDS = array_2D(W, H)

  local SIZE = assert(PARAMS.seed_size)

  for x = 1,W do for y = 1,H do
    SEEDS[x][y] = {}

    for z = 1,D do
      local S =
      {
        sx=x, sy=y, sz=z,

        -- offset by 32 units so that DOOM flats align with a
        -- 64x64 pedestal (etc) at the center of the seed.
        x1 = (x-1) * SIZE + 32,
        y1 = (y-1) * SIZE + 32,

        thick  = {},
        border = {},
      }

      -- adjustment needed for Quake 1
      if CAPS.center_map then
        S.x1 = S.x1 - int(SEED_W * SIZE / 2)
        S.y1 = S.y1 - int(SEED_H * SIZE / 2)
      end

      S.x2 = S.x1 + SIZE
      S.y2 = S.y1 + SIZE

      set_class(S, SEED_CLASS)

      for side = 2,8,2 do
        S.border[side] = {}
        S.thick[side] = 16
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
  gui.printf("Seed Map:\n")

  local function seed_to_char(S)
    if not S then return "!" end
    if not S.room then return "." end

    if S.room.is_scenic then return "/" end
    if S.room.dump_char then return S.room.dump_char end

    if S.room.parent then
      local n = 1 + (S.room.id % 26)
      return string.sub("abcdefghijklmnopqrstuvwxyz", n, n)
    end

    local n = 1 + (S.room.id % 26)
    return string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZ", n, n)
---###    if not S.room.dump_char then
---###      if S.room.kind == "hall" then
---###        S.room.dump_char = string.sub(HALLS, 1+HALL_IDX, 1+HALL_IDX)
---###        HALL_IDX = (HALL_IDX + 1) % string.len(HALLS)
---###      else
---###        S.room.dump_char = string.sub(ROOMS, 1+ROOM_IDX, 1+ROOM_IDX)
---###        ROOM_IDX = (ROOM_IDX + 1) % string.len(ROOMS)
---###      end
---###    end
  end

  for y = SEED_H,1,-1 do
    for x = 1,SEED_W do
      gui.printf("%s", seed_to_char(SEEDS[x][y][1]))
    end
    gui.printf("\n")
  end

  gui.printf("\n")
end


function Seed_dump_fabs()
  local function char_for_seed(S)

    if not S or not S.kind then return "." end

    if S.kind == "ground" then return "2" end
    if S.kind == "valley" then return "1" end
    if S.kind == "hill"   then return "3" end

    if S.kind == "indoor" then return "#" end
    if S.kind == "hall"   then return "+" end
    if S.kind == "liquid" then return "~" end

    return "?"
  end

  gui.printf("Room Fabs:\n")

  for y = SEED_H,1,-1 do
    
    for x = 1,SEED_W do
      gui.printf("%s", char_for_seed(SEEDS[x][y][1].room))
    end

    gui.printf("\n")
  end

  gui.printf("\n")
end

