----------------------------------------------------------------
--  SEED MANAGEMENT / GROWING
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2008-2009 Andrew Apted
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

  room : ROOM

  kind : keyword  -- main usage of seed:
                  --   "walk", "void", "diagonal",
                  --   "stair", "curve_stair", "tall_stair",
                  --   "liquid"

  usage : keyword  -- normally nil, but can be:
                   --   "pillar"

  border[DIR] : BORDER   -- can be nil

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

  thick : number  -- thickness of this border

  other : SEED  -- seed we are connected to, or nil 

}

--------------------------------------------------------------]]

require 'defs'
require 'util'


SEED_W = 0
SEED_H = 0


SEED_CLASS = {}

function SEED_CLASS.new(x, y)
  local S = { sx=x, sy=y, border={} }
  table.set_class(S, SEED_CLASS)
  return S
end

function SEED_CLASS.tostr(self)
  return string.format("SEED [%d,%d,%s]",
      self.sx, self.sy, self.kind or "-")
end

function SEED_CLASS.neighbor(self, dir, dist)
  local nx, ny = geom.nudge(self.sx, self.sy, dir, dist)
  if nx < 1 or nx > SEED_W or ny < 1 or ny > SEED_H then
    return nil
  end
  return SEEDS[nx][ny]
end

function SEED_CLASS.has_conn(self, C)
  assert(C)
  for side = 2,8,2 do
    local B = self.border[side]
    if B and B.conn == C then return true end
  end
  return false
end

function SEED_CLASS.has_any_conn(self)
  for side = 2,8,2 do
    local B = self.border[side]
    if B and B.conn then return true end
  end
  return false
end

function SEED_CLASS.add_border(S, side, kind, thick)
  local BORDER = { kind=kind, thick=thick }

  S.border[side] = BORDER

  return BORDER
end

function SEED_CLASS.mid_point(self)
  return int((self.x1 + self.x2) / 2), int((self.y1 + self.y2) / 2)
end

function SEED_CLASS.x3(self)
  if self.border[4] then return self.x1 + self.border[4].thick end
  return self.x1
end

function SEED_CLASS.x4(self)
  if self.border[6] then return self.x2 - self.border[6].thick end
  return self.x2
end

function SEED_CLASS.y3(self)
  if self.border[2] then return self.y1 + self.border[2].thick end
  return self.y1
end

function SEED_CLASS.y4(self)
  if self.border[8] then return self.y2 - self.border[8].thick end
  return self.y2
end



function Seed_init(map_W, map_H, free_W, free_H)
  gui.printf("Seed_init: %dx%d  Free: %dx%d\n", map_W, map_H, free_W, free_H)

  local W = map_W + free_W
  local H = map_H + free_H

  -- setup globals 
  SEED_W = W
  SEED_H = H

  SEEDS = table.array_2D(W, H)

  for x = 1,W do for y = 1,H do

      local S = SEED_CLASS.new(x, y)

      S.x1 = (x-1) * SEED_SIZE
      S.y1 = (y-1) * SEED_SIZE

      -- centre the map : needed for Quake, OK for other games
      -- (this formula ensures that 'coord 0' is still a seed boundary)
      S.x1 = S.x1 - int(SEED_W / 2) * SEED_SIZE
      S.y1 = S.y1 - int(SEED_H / 2) * SEED_SIZE

      S.x2 = S.x1 + SEED_SIZE
      S.y2 = S.y1 + SEED_SIZE

      if x > map_W or y > map_H then
        S.free = true
      elseif x == 1 or x == map_W or y == 1 or y == map_H then
        S.edge_of_map = true
      end

      SEEDS[x][y] = S

  end end -- x,y
end


function Seed_valid(x, y)
  return (x >= 1 and x <= SEED_W) and
         (y >= 1 and y <= SEED_H)
end


function Seed_safe_get(x, y)
  return Seed_valid(x, y) and SEEDS[x][y]
end


function Seed_dump_rooms(title)

  local function seed_to_char(S)
    if not S then return "!" end
    if S.free then return "." end
    if S.edge_of_map then return "#" end
    if not S.room then return "?" end

    if S.room.kind == "scenic" then return "=" end

    local n = 1 + ((S.room.id-1) % 26)

    if S.room.natural then
      return string.sub("abcdefghijklmnopqrstuvwxyz", n, n)
    else
      return string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZ", n, n)
    end
  end

  if title then
    gui.printf("%s\n", title)
  end

  for y = SEED_H,1,-1 do
    local line = "@c"
    for x = 1,SEED_W do
      line = line .. seed_to_char(SEEDS[x][y])
    end
    gui.printf("%s\n", line)
  end

  gui.printf("\n")
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
      if N and not N.edge_of_map and not N.free and not N.room then
        N.edge_of_map = true
        table.insert(new_active, N)
      end
    end end -- for S, side

    active = new_active
  end
end

