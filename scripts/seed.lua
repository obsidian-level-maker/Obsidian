------------------------------------------------------------------------
--  SEED MANAGEMENT / GROWING
------------------------------------------------------------------------
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
------------------------------------------------------------------------

--[[ *** CLASS INFORMATION ***

class SEED
{
  sx, sy  -- location in seed map

  room : ROOM

  kind : keyword  -- main usage of seed:
                  -- "walk", "void", "diagonal",
                  -- "stair", "curve_stair", "tall_stair",
                  -- "liquid"

  content : keyword  -- normally nil, but can be:
                     -- "wotsit", "pillar"

  border[DIR] : BORDER

  thick[DIR]  -- thickness of each border

  x1, y1, x2, y2  -- 2D map coordinates

  chunk[1..n] : CHUNK  -- [1] is the ground floor (or liquid), NIL for void (etc)
                       -- [2] is the 3D floor above (usually NIL)
                       -- [3] can be yet another 3D floor, etc...

  floor_h, ceil_h -- floor and ceiling heights
  f_tex,   c_tex  -- floor and ceiling textures
}


class BORDER
{
  kind  : nil (when not decided yet)
          "nothing", "straddle",
          "wall", "facade", "window", "fence",
          "arch", "door", "locked_door", "secret_door"

  other : SEED  -- seed we are connected to, or nil 

}


class CHUNK
{
  kind : keyword  -- "floor", "liquid", "void" (etc)

  floor : FLOOR
}

--------------------------------------------------------------]]


SEED_W = 0
SEED_H = 0
SEED_TOP = 0


SEED_CLASS = {}

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


function SEED_CLASS.same_room(S, dir)
  local N = S:neighbor(dir)

  return N and (N.room == S.room)
end


function SEED_CLASS.mid_point(S)
  return int((S.x1 + S.x2) / 2), int((S.y1 + S.y2) / 2)
end


function SEED_CLASS.midstr(S)
  local mx, my = S:mid_point()
  return string.format("SEED(%+5d %+5d)", mx, my)
end


function SEED_CLASS.edge_coord(S, side)
  local mx, my = S:mid_point()
  local dx, dy = geom.delta(side)

  mx = mx + dx * (SEED_SIZE / 2)
  my = my + dy * (SEED_SIZE / 2)

  return mx, my
end


function SEED_CLASS.in_use(S)
  return S.room or S.closet or S.map_border
end


function SEED_CLASS.need_lake_fence(S, dir)
  --| need a lake fence at:
  --| (1) very edge of map
  --| (2) border to a different outdoor room
  if S.conn or S.content then return false end

  local N = S:neighbor(dir)
  if not N or N.free then return true end
  if not N.room then return true end

  if S.room == N.room then return false end

  return N.room.is_outdoor
end


----------------------------------------------------------------------


function Seed_init(map_W, map_H, free_W, free_H)
  gui.printf("Seed_init: %dx%d  Free: %dx%d\n", map_W, map_H, free_W, free_H)

  local W = map_W + free_W
  local H = map_H + free_H

  -- setup globals 
  SEED_W = W
  SEED_H = H
  SEED_TOP = map_H

  SEEDS = table.array_2D(W, H)

  BASE_X = 0
  BASE_Y = 0

  -- Centre the map : needed for Quake, Hexen2 (etc).
  -- This formula ensures that 'coord 0' is still a seed boundary,
  -- which is VITAL for the Quake visibility code.
  if PARAM.centre_map then
    BASE_X = 0 - int(SEED_W / 2) * SEED_SIZE
    BASE_Y = 0 - int(SEED_H / 2) * SEED_SIZE
  end

  for x = 1, SEED_W do
  for y = 1, SEED_H do

    local S =
    {
      sx = x
      sy = y

      x1 = (x-1) * SEED_SIZE
      y1 = (y-1) * SEED_SIZE

      thick  = {}
      border = {}
      chunk  = {}
    }

    SEEDS[x][y] = S

    S.x1 = BASE_X + (x-1) * SEED_SIZE
    S.y1 = BASE_Y + (y-1) * SEED_SIZE

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

  end -- x,y
  end
end


function Seed_close()
  SEEDS = nil

  SEED_W = 0
  SEED_H = 0
end


function Seed_valid(x, y)
  return (x >= 1 and x <= SEED_W) and
         (y >= 1 and y <= SEED_H)
end


function Seed_get_safe(x, y)
  return Seed_valid(x, y) and SEEDS[x][y]
end


function Seed_is_free(x, y)
  assert(Seed_valid(x, y))

  return not SEEDS[x][y].room
end


function Seed_valid_and_free(x, y)
  if not Seed_valid(x, y) then
    return false
  end

  return Seed_is_free(x, y)
end


function Seed_block_valid_and_free(x1,y1, x2,y2)

  assert(x1 <= x2 and y1 <= y2)

  if not Seed_valid(x1, y1) then return false end
  if not Seed_valid(x2, y2) then return false end

  for x = x1,x2 do
  for y = y1,y2 do
    local S = SEEDS[x][y][z]
    if S.room then
      return false
    end
  end -- x, y
  end

  return true
end


function Seed_coord_range(sx1, sy1, sx2, sy2)
  assert(Seed_valid(sx1, sy1))
  assert(Seed_valid(sx2, sy2))

  local S1 = SEEDS[sx1][sy1]
  local S2 = SEEDS[sx2][sy2]

  return S1.x1, S1.y1, S2.x2, S2.y2
end


function Seed_from_coord(x, y)
  local sx = 1 + math.floor((x - BASE_X) / SEED_SIZE)
  local sy = 1 + math.floor((y - BASE_Y) / SEED_SIZE)

  -- clamp to usable range, mainly to handle edge cases
  sx = math.clamp(1, sx, SEED_W)
  sy = math.clamp(1, sy, SEED_H)

  return SEEDS[sx][sy]
end


function Seed_dump_rooms()
  local function seed_to_char(S)
    if not S then return "!" end
    if S.free then return "." end
    if not S.room then return "#" end

    if S.room.kind == "scenic"   then return "=" end
    if S.room.kind == "reserved" then return "*" end

    if S.room.kind == "cave" then
      local n = 1 + ((S.room.id - 1) % 26)
      return string.sub("abcdefghijklmnopqrstuvwxyz", n, n)
    end

    local n = 1 + ((S.room.id - 1) % 26)
    return string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZ", n, n)
  end

  for y = SEED_H,1,-1 do
    local line = "  "
    for x = 1,SEED_W do
      line = line .. seed_to_char(SEEDS[x][y])
    end
    gui.printf("%s\n", line)
  end

  gui.printf("\n")
end

