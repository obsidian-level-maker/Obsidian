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

  diagonal : DIR  -- if non-nil, then seed is split into two halves.
                  -- DIR is the corner associated with the triangle
                  -- (and the direction *away* from the diagonal line)

                     +---+   +---+
                     |\ 9|   |7 /|
                     | \ |   | / |
                     |1 \|   |/ 3|
                     +---+   +---+

  top : SEED   -- if seed is split by a diagonal, then this refers to the
               -- information for the TOP half (i.e. the half occupying the
               -- top edge), and the main seed contains the BOTTOM half.

  bottom : SEED   -- used in 'top' seed to refer to the other half.


  ////////////////////////

  area : AREA

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

  mid_x, mid_y  -- mid point coordinate

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

BASE_X = 0
BASE_Y = 0


SEED_CLASS = {}

function SEED_CLASS.tostr(S)
  return string.format("SEED [%d,%d]", S.sx, S.sy)
end


--
-- convert a square seed to a pair of diagonal seeds.
-- the 'S' parameter becomes the bottom half.
--
-- NOTE: must be done fairly early, e.g. assumes nothing in border[] yet
--
function SEED_CLASS.split(S, diagonal)
  assert(diagonal == 1 or diagonal == 3)
  assert(not S.diagonal)

  S.diagonal = diagonal

  local S2 = Seed_create(S.sx, S.sy, S.x1, S.y1)

  S2.diagonal = 10 - diagonal

  S2.x1 = S.x1 ; S2.y1 = S.y1
  S2.x2 = S.x2 ; S2.y2 = S.y2

  S2.edge_of_map = S.edge_of_map

  -- link fake seed with real one
  S.top = S2 ; S2.bottom = S

  -- update mid-points
  S :calc_mid_point()
  S2:calc_mid_point()
end


function SEED_CLASS.join_halves(S)
  assert(S.diagonal)
  assert(S.top and not S.bottom)

  local S2 = S.top

  for dir = 2,8,2 do
    S.border[dir].edge_kind = S.border[dir].edge_kind or S2.border[dir].edge_kind
  end

  each dir in geom.CORNERS do
    S.border[dir].edge_kind = nil
  end

  S.diagonal = nil
  S.top = nil

  -- kill the other half
  S2.kind = "dead"
  S2.diagonal = "dead"

  S2.border = nil
  S2.area = nil
  S2.room = nil
end


-- NOTE: this is "raw" and does not handle diagonal seeds
function SEED_CLASS.neighbor(S, dir, dist)
  local nx, ny = geom.nudge(S.sx, S.sy, dir, dist)
  if nx < 1 or nx > SEED_W or ny < 1 or ny > SEED_H then
    return nil
  end
  return SEEDS[nx][ny]
end


--
-- for WEIRD experiment : for a diagonal seed, 'S' should be one particular
-- half ('top' or 'bottom'), and the result 'N' will also be a certain half.
--
-- returns 'nodir' parameter when 'dir' makes no sense
-- (i.e. for square seed, only 2/4/6/8, and for a diagonal, only 3 dirs).
-- returns NIL for edge of map (as normal neighbor method).
--
function SEED_CLASS.diag_neighbor(S, dir, nodir)
  local N

  -- handle square seeds

  if not S.diagonal then
    if not (dir == 2 or dir == 4 or dir == 6 or dir == 8) then
      return nodir
    end

    N = S:neighbor(dir)

    if N then
      if dir == 2 and N.diagonal then return N.top end

      if dir == 4 and N.diagonal == 1 then return N.top end
      if dir == 6 and N.diagonal == 3 then return N.top end
    end

    return N
  end

  -- handle diagonal seeds

  if (S.diagonal == 7 or S.diagonal == 9) and dir == 8 then
    return S:neighbor(dir)
  end
  
  if (S.diagonal == 1 or S.diagonal == 3) and dir == 2 then
    N = S:neighbor(dir)
    if N and N.diagonal then return N.top end
    return N
  end

  if (S.diagonal == 1 or S.diagonal == 7) and dir == 4 then
    N = S:neighbor(dir)
    if N and N.diagonal == 1 then return N.top end
    return N
  end
  
  if (S.diagonal == 3 or S.diagonal == 9) and dir == 6 then
    N = S:neighbor(dir)
    if N and N.diagonal == 3 then return N.top end
    return N
  end
  
  -- diagonal directions in directions seeds

  if S.diagonal == 1 and dir == 9 then return S.top end
  if S.diagonal == 3 and dir == 7 then return S.top end

  if S.diagonal == 7 and dir == 3 then return S.bottom end
  if S.diagonal == 9 and dir == 1 then return S.bottom end

  return nodir
end


function SEED_CLASS.same_room(S, dir)
  local N = S:diag_neighbor(dir)

  return N and (N.room == S.room)
end


function SEED_CLASS.calc_mid_point(S)
  -- 'S' can be a half-seed too
  local mx = (S.x1 + S.x2) / 2
  local my = (S.y1 + S.y2) / 2

  if S.diagonal == 1 then
    mx = (S.x1 + mx) / 2
    my = (S.y1 + my) / 2

  elseif S.diagonal == 3 then
    mx = (S.x2 + mx) / 2
    my = (S.y1 + my) / 2

  elseif S.diagonal == 7 then
    mx = (S.x1 + mx) / 2
    my = (S.y2 + my) / 2

  elseif S.diagonal == 9 then
    mx = (S.x2 + mx) / 2
    my = (S.y2 + my) / 2
  end 

  S.mid_x = int(mx)
  S.mid_y = int(my)
end


function SEED_CLASS.mid_point(S)
  assert(S.mid_x)

  return S.mid_x, S.mid_y
end


function SEED_CLASS.midstr(S)
  return string.format("SEED(%+5d %+5d)", S.mid_x, S.mid_y)
end


function SEED_CLASS.edge_coord(S, side)
  -- FIXME !!!  borked for half-seeds
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


function Seed_create(sx, sy, x1, y1)
  local S =
  {
    sx = sx
    sy = sy

    x1 = x1
    y1 = y1

    thick  = {}
    border = {}
    chunk  = {}
  }

  S.x2 = S.x1 + SEED_SIZE
  S.y2 = S.y1 + SEED_SIZE

  table.set_class(S, SEED_CLASS)

  each dir in geom.ALL_DIRS do
    S.border[dir] = {}
    S.thick [dir] = 16
  end

  S:calc_mid_point()

  return S
end


function Seed_init(map_W, map_H, depot_H)
  gui.printf("Seed_init: %dx%d  Depot: %dx%d\n", map_W, map_H, map_W, depot_H)

  -- setup globals 
  SEED_W = map_W
  SEED_H = map_H


  SEEDS = table.array_2D(SEED_W, SEED_H)

  BASE_X = 0
  BASE_Y = 0

  -- Centre the map : needed for Quake, Hexen2 (etc).
  -- This formula ensures that 'coord 0' is still a seed boundary,
  -- which is VITAL for the Quake visibility code.
  if PARAM.centre_map then
    BASE_X = 0 - int(SEED_W / 2) * SEED_SIZE
    BASE_Y = 0 - int(SEED_H / 2) * SEED_SIZE
  end

  for sx = 1, SEED_W do
  for sy = 1, SEED_H do
    local x1 = BASE_X + (sx-1) * SEED_SIZE
    local y1 = BASE_Y + (sy-1) * SEED_SIZE

    SEEDS[sx][sy] = Seed_create(sx, sy, x1, y1)
  end -- x,y
  end

  -- create depot area [ for teleport-in monsters ]

  DEPOT_SEEDS = table.array_2D(map_W, depot_H)

  for sx = 1, DEPOT_SEEDS.w do
  for sy = 1, DEPOT_SEEDS.h do
    local x1 = BASE_X + (sx-1) * SEED_SIZE
    local y1 = BASE_Y + (SEED_H + sy) * SEED_SIZE

    local S = Seed_create(sx, sy, x1, y1)
    S.kind = "depot"

    DEPOT_SEEDS[sx][sy] = S
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
    if S.free then return "!" end
    if not S.room then return "#" end
    if S.diagonal == 1 then return "/" end
    if S.diagonal == 3 then return "\\" end

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

