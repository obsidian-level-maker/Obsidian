----------------------------------------------------------------
--  QUEST ASSIGNMENT
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

class Quest
{
}

--------------------------------------------------------------]]

require 'defs'
require 'util'


function Quest_leafiness()

  -- This determines distance of the room to a leaf:
  --   0 = room is a leaf
  --   1 = room has a leaf neighbour
  --   etc....

  local function determine_leaf_dist(R)

    if R.branch_num == 1 then
      return 0
    end

    local dist

    for _,C in ipairs(R.conns) do
      local N = sel(C.src == R, C.dest, C.src)
      if N.leaf_dist and (not dist or N.leaf_dist < dist) then
        dist = N.leaf_dist
      end
    end

    for _,T in ipairs(R.teleports) do
      local N = sel(T.src == R, T.dest, T.src)
      if N.leaf_dist and (not dist or N.leaf_dist < dist) then
        dist = N.leaf_dist
      end
    end

    if dist then
      return dist+1
    end

    return nil -- UNKNOWN --
  end

  --| Quest_leafiness |--

  for loop = 1,999 do
    local changes = 0

    for _,R in ipairs(PLAN.all_rooms) do
      local dist = determine_leaf_dist(R)
      if dist ~= R.leaf_dist then
         R.leaf_dist = dist
         changes = changes + 1
con.debugf("Room (%d,%d) : leaf_dist:%d\n", R.lx1,R.ly1, R.leaf_dist or -1)
      end
    end
con.debugf("Quest_leafiness: loop %d, changes %d\n", loop, changes)

    if changes == 0 then break; end
  end -- loop

  -- validation
  for _,R in ipairs(PLAN.all_rooms) do
    if not R.leaf_dist then
      error("Quest_leafiness: failed! (circular connections?)")
    end
  end
end


function Quest_travel_volume(R, exclude_set)
  -- Determine number of rooms that are reachable from the
  -- given room, including itself, but excluding connections
  -- that have been "locked" and rooms in the exclude_set.

  local count = 1

  exclude_set[R] = true

  for _,C in ipairs(R.conns) do
    if not C.lock then
      local N = sel(C.src == R, C.dest, C.src)
      if not exclude_set[N] then
        exclude_set[N] = true
        count = count + Quest_travel_volume(N, copy_table(exclude_set))
      end
    end
  end

  for _,T in ipairs(R.teleports) do
    -- (teleport connections are never locked)
    local N = sel(T.src == R, T.dest, T.src)
    if not exclude_set[N] then
      exclude_set[N] = true
      count = count + Quest_travel_volume(N, copy_table(exclude_set))
    end
  end

  return count
end


function Quest_update_trav_diff()
  -- The 'trav_diff' value of a connection between two rooms is the
  -- difference in the number of travelable rooms on either side of
  -- the connection.

  -- Note: we don't do teleporters, as they are never lockable

  for _,C in ipairs(PLAN.all_conns) do
    local t1 = Quest_travel_volume(C.src,  { [C.dest]=true })
    local t2 = Quest_travel_volume(C.dest, { [C.src] =true })

    C.trav_diff = math.abs(t1 - t2)

con.debugf("Room (%d,%d) <--> (%d,%d) trav_diff:%d\n",
        C.src.lx1, C.src.ly1, C.dest.lx1, C.dest.ly1, C.trav_diff)
  end -- C
end


function Quest_divide_group(parent)

  -- Primary function is to find a suitable connection amongst the
  -- rooms in the list which can be locked (by a key or switch).
  --
  -- One side of the connection needs >= 2 other branches (one is
  -- the START and


  -- find_good_candidate may swap 'src' and 'dest'
  -- Hence here: C.src is earlier and C.dest is later (quest progression)

  C = find_good_candidate(parent)

  if not C then
    if parent.key then
      store parent.key somewhere.... (far from pivot)
    end
    if parent.need_start then
      store "START" somewhere.... (far from pivot and key)
    end
    if parent.need_exit then
      store "EXIT" somewhere.... (far from pivot)
    end

    return
  end

  C.lock = "KEY_" .. tostring(C)

  Quest_update_trav_diff()

  local front, back = split_group(parent, C)
  -- now we have two separate groups of rooms

  front.pivot = C.src
  front.key = C.lock
  front.need_start = parent.need_start

  back.pivot = C.dest
  back.key = parent.key
  back.need_exit = parent.need_exit
 
  Quest_divide_group(front)
  Quest_divide_group(back)

--[[
  if Quest_divide_group(front) then
    -- the start room would have been created now (we don't need to
    -- do it here).

  else
    -- must add start room ourselves
    
    if C.src.free_branches >= 2 then
      
      store_in_furthest_branch(C.src, "START") -- marks the used branch
    else
      store(C.src, "START")
    end

    store_in_furthest_branch(C.src, "KEY_N")
  end


  if Quest_divide_group(back, false, "EXIT") then
    -- the end room would have been created now
  else

    store_in_furthest_branch(C.dest, "EXIT")
  end
--]]
end


function Quest_assign()

  -- FIXME proper Quest_assign() function

  -- make a random room the start room (TEMP CRUD)

  con.printf("\n--==| Quest_assign |==--\n\n")

  -- count branches in each room
  for _,R in ipairs(PLAN.all_rooms) do
    R.branch_num = #R.conns + #R.teleports
    if R.branch_num == 0 then
      error("Room exists with no connections!")
    end
con.printf("Room (%d,%d) branches:%d\n", R.lx1,R.ly1, R.branch_num)
  end

---??  Quest_leafiness()

  Quest_update_trav_diff()

  local group =
  {
    rooms = PLAN.all_rooms,
    conns = PLAN.all_conns,

    need_start = true,
    need_exit  = true,
  }

  Quest_divide_group(group)

--[[
  local conn_list = copy_table(PLAN.all_conns)

  table.sort(conn_list, function(A,B) return A.trav_diff < B.trav_diff end)

  local C = conn_list[1]
  con.debugf("Lowest conn: %d -- LOCKED\n", C.trav_diff)

  C.locked = true
  Quest_update_trav_diff()
--]]


  local sx, sy

  repeat
    sx = rand_irange(1, SEED_W)
    sy = rand_irange(1, SEED_H)
  until SEEDS[sx][sy][1].room and not SEEDS[sx][sy][1].room.nowalk


--[[ older method

  local start_R

  repeat
    start_R = rand_element(PLAN.all_rooms)
  until not start_R.zone_kind

  start_R.is_start = true

  local sx, sy

  repeat
    sx = rand_irange(start_R.sx1, start_R.sx2)
    sy = rand_irange(start_R.sy1, start_R.sy2)
  until SEEDS[sx][sy][1].room == start_R

--]]
  SEEDS[sx][sy][1].is_start = true

  con.printf("Start seed @ (%d,%d)\n", sx, sy)

end

