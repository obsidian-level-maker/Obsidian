----------------------------------------------------------------
--  SECTIONS : a rectangular group of seeds
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2013 Andrew Apted
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

TODO: describe the section/map system

class SECTION
{
  kx, ky  -- location in section map 

  sx1, sy1, sx2, sy2, sw, sh  -- location in seed map

  kind : keyword   -- "section", "section2", "annex", "intrusion"
                   -- "junction", "big_junc", "vert", "horiz"

  orig_kind : keyword  -- "section", "junction", "vert", "horiz"

  used : boolean

  room : ROOM
  hall : HALLWAY

  num_conn  -- number of connections

  crossover_hall : HALLWAY

  hall_link[dir] : ROOM/HALL  -- non-nil means that this section in a
                              -- hallway is "pathing" in the given
                              -- direction to the given room, which
                              -- is usually the same as 'hall' field.
}

----------------------------------------------------------------]]

SECTION_W = 0
SECTION_H = 0

SECTION_CLASS = { }


function SECTION_CLASS.new(kind, kx, ky)
  local K =
  {
    kind = kind
    orig_kind = kind
    kx = kx
    ky = ky
    num_conn = 0
    hall_link = {}
  }
  table.set_class(K, SECTION_CLASS)
  return K
end


function SECTION_CLASS.tostr(K)
  return string.format("%s [%d,%d]", string.upper(K.kind), K.kx, K.ky)
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

function SECTION_CLASS.set_big_junc(K)
  assert(not K.used)
  K.kind = "big_junc" ; K.used = true
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


function Section_is_valid(x, y)
  return 1 <= x and x <= SECTION_W and
         1 <= y and y <= SECTION_H
end


function Section_get_room(mx, my)
  if mx < 1 or mx > MAP_W or my < 1 or my > MAP_H then
    return nil
  end

  return SECTIONS[mx*2][my*2]
end


function Section_random_visits()
  local list = {}

  for kx = 1,SECTION_W do for ky = 1,SECTION_H do
    table.insert(list, SECTIONS[kx][ky])
  end end

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

  if not K:neighbor(dir) then return -1 end

  -- check if direction is unique
  local uniq_dir = true

  local parent = K.room or K.hall
  assert(parent)

  each D in parent.conns do
    if D.L1 == parent and D.dir1 == dir then
      uniq_dir = false ; break
    end
  end

  local rand = ((uniq_dir ? 1 ; 0) + gui.random()) / 2

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
      return (foot_dir == dir ? 9 ; 8) + rand 
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
  if K.room and K.kind == "section" and conn_d >= 2 and
     K:same_room(geom.RIGHT[dir], 2) and
     K:same_room(geom. LEFT[dir], 2)
  then
    return 7 + rand
  end

  -- all other cases
  return 2 + conn_d + rand
end

