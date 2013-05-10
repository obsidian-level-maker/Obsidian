----------------------------------------------------------------
--  SEED and SECTION management
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2008-2013 Andrew Apted
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
  -- a seed is a square region on the 2D map.
  -- the size of each seed is 256x256 units.

  sx, sy  -- location in seed map

  x1, y1, x2, y2  -- 2D map coordinates

  section : SECTION

  room   : ROOM
  hall   : HALLWAY
  closet : CLOSET
  border : BORDER

  portals[dir] : PORTAL
  walls[dir]   : WALL

  chunk : CHUNK  -- connection/important chunk

  chunks[v_area] : CHUNK

  cost[DIR]  -- used when marking paths

  is_walk  -- TRUE if seed must be remain walkable
           -- (i.e. cannot use for void / cage / liquid)

  wall_dist : number  -- roughly how far away the edge of the room is
                      -- (in seeds).  applies to all room kinds.
}


class BORDER
{
  kind : keyword   -- "edge"
                   -- "corner"
                   -- "outie"

  room : ROOM  -- the outdoor room this borders
  dir          -- direction towards room

  sx1, sy1, sx2, sy2   -- seed range
}


class PORTAL
{
  -- a portal is the side of a seed (or row of seeds) where the
  -- player will cross at some time.  Primary use is for connections
  -- between a room and another room or hallway.
  --
  -- portals are one-way.  There is generally one where a hallway
  -- meets a room (the hallway doesn't need it), but where two rooms
  -- are directly connected there will be two portals back-to-back.
  --
  -- In the future there may be other kinds of portals, such as
  -- "drop_off", "liquid" or "window" portals.

  kind : keyword   -- "walk" (etc, depends on sub-class)

  sx1, sy1, sx2, sy2  -- seed range

  side : DIR  -- which side of the seed range

  conn : CONN

  peer : PORTAL  -- for back-to-back connections

  floor_h  -- floor height (set during room layouting)

  door_kind : keyword   -- can be NIL, or "door" or "arch"
}


class SECTION
{
  -- a section is a rectangular group of seeds.
  -- sections are used for planning where to place rooms and hallways.

  kx, ky  -- location in section map 

  sx1, sy1, sx2, sy2, sw, sh  -- location in seed map

  shape : keyword  -- "vert"     : tall and skinny
                   -- "horiz"    : wide and skinny
                   -- "junction" : 1x1 touching vert(s) and horiz(s)
                   -- "big_junc" : large size junction
                   -- "rect"     : everything else

  used : boolean

  room   : ROOM
  hall   : HALLWAY
  closet : CLOSET

  num_conn  -- number of connections

  hall_link[dir] : SECTION  -- for hallways, possible travel dirs
                            -- (may exit the hallway)

  crossover_hall : HALLWAY
}

--------------------------------------------------------------]]


SEED_W = 0
SEED_H = 0
SEED_TOP = 0

BASE_X = 0
BASE_Y = 0

SECTION_W = 0
SECTION_H = 0


SEED_CLASS = {}

SECTION_CLASS = { }


function SEED_CLASS.new(x, y)
  local S = { sx=x, sy=y, cost={}, portals={}, walls={}, chunks={}, v_areas={} }
  table.set_class(S, SEED_CLASS)
  return S
end


function SEED_CLASS.tostr(S)
  return string.format("SEED [%d,%d]", S.sx, S.sy)
end


function SEED_CLASS.neighbor(S, dir, dist)
  local nx, ny = geom.nudge(S.sx, S.sy, dir, dist)
  if nx < 1 or nx > SEED_W or ny < 1 or ny > SEED_TOP then
    return nil
  end
  return SEEDS[nx][ny]
end


function SEED_CLASS.same_room(S, dir)
  local N = S:neighbor(dir)
  return N and N.room == S.room
end


function SEED_CLASS.need_lake_fence(S, dir)
  --| need a lake fence at:
  --| (1) very edge of map
  --| (2) border to a different outdoor room
  local N = S:neighbor(dir)
  if not N then return true end
  if not (S.room and N.room) then return false end
  if S.room == N.room then return false end
  return N.room.is_outdoor
end


function SEED_CLASS.mid_point(S)
  return geom.box_mid(S.x1, S.y1, S.x2, S.y2)
end


function SEED_CLASS.used(S)
  return S.room or S.hall or S.closet or S.border or
         S.chunk or not table.empty(S.chunks)
end


function SEED_CLASS.edge_of_room(S)
  for dir = 2,8,2 do
    if not S:same_room(dir) then
      return false
    end
  end

  return true
end


--------------------------------------------------------------------


function Seed_init(map_W, map_H, free_W, free_H)
  gui.printf("Seed_init: %dx%d  Free: %dx%d\n", map_W, map_H, free_W, free_H)

  local W = map_W + free_W
  local H = map_H + free_H

  --- setup seed array ---

  SEED_W = W
  SEED_H = H

  SEED_TOP = map_H

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

  for x = 1,SEED_W do
  for y = 1,SEED_H do
    local S = SEED_CLASS.new(x, y)

    SEEDS[x][y] = S

    S.x1 = BASE_X + (x-1) * SEED_SIZE
    S.y1 = BASE_Y + (y-1) * SEED_SIZE

    S.x2 = S.x1 + SEED_SIZE
    S.y2 = S.y1 + SEED_SIZE

    if x > map_W or y > map_H then
      S.free = true
    elseif x <= EDGE_SEEDS or x >= map_W - (EDGE_SEEDS - 1) or
           y <= EDGE_SEEDS or y >= map_H - (EDGE_SEEDS - 1)
    then
      S.edge_of_map = true
    end
  end -- x, y
  end
end


function Seed_valid(x, y)
  return (x >= 1 and x <= SEED_W) and
         (y >= 1 and y <= SEED_H)
end


function Seed_from_coord(x, y)
  local sx = 1 + math.floor((x - BASE_X) / SEED_SIZE)
  local sy = 1 + math.floor((y - BASE_Y) / SEED_SIZE)

  -- clamp to usable range, mainly to handle edge cases
  sx = math.clamp(1, sx, SEED_W)
  sy = math.clamp(1, sy, SEED_H)

  return SEEDS[sx][sy]
end


function Seed_group_edge_coords(P, dir, thick)
  local x1 = SEEDS[P.sx1][P.sy1].x1
  local y1 = SEEDS[P.sx1][P.sy1].y1
  local x2 = SEEDS[P.sx2][P.sy2].x2
  local y2 = SEEDS[P.sx2][P.sy2].y2

  if dir == 2 then y2 = y1 + thick end
  if dir == 8 then y1 = y2 - thick end
  if dir == 4 then x2 = x1 + thick end
  if dir == 6 then x1 = x2 - thick end

  return x1, y1, x2, y2
end


function Portal_set_floor(P, floor_h)
  P.floor_h = floor_h

  if P.peer then P.peer.floor_h = floor_h end
end


--------------------------------------------------------------------


function SECTION_CLASS.new(shape, kx, ky)
  local K =
  {
    shape = shape
    kx = kx
    ky = ky
    num_conn = 0
    link = {}
    hall_link = {}
  }
  table.set_class(K, SECTION_CLASS)
  return K
end


function SECTION_CLASS.tostr(K)
  return string.format("%s [%d,%d]", string.upper(K.shape), K.kx, K.ky)
end


function SECTION_CLASS.set_seed_range(K, sx, sy, sw, sh)
  K.sx1 = sx
  K.sy1 = sy

  K.sw  = sw
  K.sh  = sh

  K.sx2 = K.sx1 + K.sw - 1
  K.sy2 = K.sy1 + K.sh - 1
end


function SECTION_CLASS.usable_for_room(K)
  if K.used then return false end
  if K.shape == "big_junc" then return false end
  return true
end


function SECTION_CLASS.install(K)
  for sx = K.sx1, K.sx2 do
  for sy = K.sy1, K.sy2 do
    SEEDS[sx][sy].section = K
  end
  end
end


function SECTION_CLASS.set_room(K, R)
  assert(not K.used)
  K.room = R ; K.used = true
end

function SECTION_CLASS.set_hall(K, H)
  assert(not K.used)
  K.hall = H ; K.used = true

  -- TODO: review this (wrong place?)
  for sx = K.sx1, K.sx2 do for sy = K.sy1, K.sy2 do
    SEEDS[sx][sy].hall = H
  end end
end

function SECTION_CLASS.set_crossover(K, H)
  assert(K.used)
  K.crossover_hall = H
end

function SECTION_CLASS.set_closet(K, CL)
  assert(not K.used)
  K.closet = CL ; K.used = true
end


function SECTION_CLASS.update_size(K)
  K.sw, K.sh = geom.group_size(K.sx1, K.sy1, K.sx2, K.sy2)
end


function SECTION_CLASS.long_deep(K, dir)
  return geom.long_deep(K.sw, K.sh, dir)
end


function SECTION_CLASS.get_coords(K)
  local x1 = SEEDS[K.sx1][K.sy1].x1
  local y1 = SEEDS[K.sx1][K.sy1].y1

  local x2 = SEEDS[K.sx2][K.sy2].x2
  local y2 = SEEDS[K.sx2][K.sy2].y2

  return x1, y1, x2, y2
end


function SECTION_CLASS.mid_point(K)
  local x1, y1, x2, y2 = SECTION_CLASS.get_coords()

  return (x1 + x2) / 2, (y1 + y2) / 2
end


function Section_is_valid(x, y)
  return 1 <= x and x <= SECTION_W and
         1 <= y and y <= SECTION_H
end


function Section_get_room(mx, my)
  if mx < 1 or mx > MAP_W or my < 1 or my > MAP_H then
    return nil
  end

  return SECTIONS[1 + mx*2][1 + my*2]
end


function Section_random_visits()
  local list = {}

  for kx = 1,SECTION_W do
  for ky = 1,SECTION_H do
    table.insert(list, SECTIONS[kx][ky])
  end
  end

  rand.shuffle(list)

  return list
end


function SECTION_CLASS.neighbor(K, dir, dist)
  local nx, ny = geom.nudge(K.kx, K.ky, dir, dist)

  if Section_is_valid(nx, ny) then
    return SECTIONS[nx][ny]
  end

  return nil
end


function SECTION_CLASS.touch_neighbor(K, dir)
  local nx, ny

  if dir == 2 or dir == 8 then
    nx = int((K.sx1 + K.sx2) / 2)
    ny = sel(dir == 2, K.sy1 - 1, K.sy2 + 1)
  else
    ny = int((K.sy1 + K.sy2) / 2)
    nx = sel(dir == 4, K.sx1 - 1, K.sx2 + 1)
  end

  if Seed_valid(nx, ny) then
    return SEEDS[nx][ny].section
  end

  return nil
end


function SECTION_CLASS.same_room(K, dir, dist)
  local N = K:neighbor(dir, dist)
  return N and N.room == K.room
end


--[[
function SECTION_CLASS.same_room_mask(K)  -- MEH
  local result = 0
  
  if K:same_room(8,2) then result = result + 8 end
  if K:same_room(4,2) then result = result + 4 end
  if K:same_room(2,2) then result = result + 2 end
  if K:same_room(6,2) then result = result + 1 end

  return result
end


function SECTION_CLASS.same_neighbors(K)
  local count = 0
  
  for dir = 2,8,2 do
    if K:same_room(dir, 2) then
      count = count + 1
    end
  end

  return count
end
--]]


function SECTION_CLASS.approx_side_coord(K, dir)
  return geom.nudge(K.kx, K.ky, dir, 0.5)
end


function SECTION_CLASS.touches_edge(K)
  for dir = 2,8,2 do
    if not K:same_room(dir) then return true end
  end

  return false
end


function SECTION_CLASS.divide(K, side, chop_num)
  -- divide this section in two pieces.
  -- when dir == 8 then this object becomes the bottom, and the new section
  -- is the top (similarly for other directions).
  -- chop_num specifies the depth (in seeds) to remove at the edge.
  -- returns the new section.

  assert(chop_num > 0)

  if geom.is_vert(side) then
    assert(K.sh > chop_num)
  else
    assert(K.sw > chop_num)
  end

  local N = SECTION_CLASS.new("chop")

  N.used = K.used
  N.room = K.room
  N.hall = K.hall

  N.sx1 = K.sx1
  N.sx2 = K.sx2
  N.sy2 = K.sy2
  N.sy2 = K.sy2

  if side == 2 then
    K.sy1 = K.sy1 + chop_num
    N.sy2 = K.sy1 - 1
  elseif side == 8 then
    K.sy2 = K.sy2 - chop_num
    N.sy1 = K.sy2 + 1
  elseif side == 4 then
    K.sx1 = K.sx1 + chop_num
    N.sx2 = K.sx1 - 1
  elseif side == 6 then
    K.sx2 = K.sx2 - chop_num
    N.sx1 = K.sx2 + 1
  else
    error("bad direction for section divide()");
  end

  K:update_size()
  N:update_size()

  N:install()

  return N
end


function SECTION_CLASS.contains_chunk(K, C)
  return (C.sx1 >= K.sx1) and (C.sx2 <= K.sx2) and
         (C.sy1 >= K.sy1) and (C.sy2 <= K.sy2)
end


function SECTION_CLASS.clear_expanded(K)
  K.expanded_dirs = nil
end


function SECTION_CLASS.set_expanded(K, dir)
  if not K.expanded_dirs then
    K.expanded_dirs = {}
  end

  K.expanded_dirs[dir] = true
end


function SECTION_CLASS.is_foot(K)  -- returns direction, or nil
  for dir = 2,8,2 do
    if not K:same_room(dir) and
       not K:same_room(geom.RIGHT[dir]) and
       not K:same_room(geom. LEFT[dir]) and
       K:same_room(10 - dir)
    then
      return dir
    end
  end
end


function SECTION_CLASS.eval_exit(K, dir)
  -- evaluate exit from this section + direction
  -- returns value between 0 and 10, or -1 if not possible at all

  local N = K:neighbor(dir)

  if not N then return -1 end

  -- check if direction is unique
  local uniq_dir = true

  local parent = K.room or K.hall
  assert(parent)

  each D in parent.conns do
    if D.L1 == parent and D.dir1 == dir then
      uniq_dir = false ; break
    end
  end

  local rand = (sel(uniq_dir, 1, 0) + gui.random()) / 2

  -- a free section please
  if K.num_conn > 0 then
    return math.min(K.num_conn, 4) / 4 + rand
  end

  -- a "foot" is a section sticking out (three non-room neighbors).
  -- these are considered the best possible place for an exit
  -- TODO: determine this in preparation phase
  if K.room and K.room.map_volume >= 3 then
    local foot_dir = K:is_foot()

    if foot_dir then
      return sel(foot_dir == dir, 9, 8) + rand 
    end
  end

  -- sections far away from existing connections are preferred
  local conn_d
  
  if K.room then
    conn_d = K.room:dist_to_closest_conn(K, dir)
  end

  conn_d = (conn_d or 10) / 2  -- adjust for hallway channels

  if conn_d > 4 then conn_d = 4 end

  -- an "uncrowded middler" is the middle of a wide edge and does
  -- not have any neighbors with connections
  if K.room and K.shape == "rect" and conn_d >= 2 and
     K:same_room(geom.RIGHT[dir], 2) and
     K:same_room(geom. LEFT[dir], 2)
  then
    return 7 + rand
  end

  -- all other cases
  return 2 + conn_d + rand
end


