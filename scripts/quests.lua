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

class ARENA
{
  -- an Arena is a group of rooms, generally with a locked door
  -- to a different arena (requiring the player to find the key
  -- or switch).

  rooms : array(ROOM)  -- all the rooms in this arena

  conns : array(CONN)  -- all the direct connections between rooms
                       -- in this arena.  Note that teleporters always
                       -- go between rooms in the same arena

  start : ROOM  -- room which player enters this arena
                -- (map's start room for the very first arena)
                -- Never nil.

  exit : ROOM   -- room which player exits this arena
                -- (map's exit room for the very last arena)
                -- Never nil.

  path : array(ROOM)   -- full path of rooms from 'start' to 'exit'

  path_set : set(ROOM) -- set for each room in the above path

  lock : LOCK   -- lock which leads to next arena, or nil for last

  target : ROOM -- room containing the key/switch, or nil

}


class LOCK
{
  conn : CONN   -- connection between two rooms (and two arenas)
                -- which is locked (keyed door, lowering bars, etc)

  front, back : LOCK  -- binary tree of locks
                      -- front for 'src' side, back for 'dest' side
}


--------------------------------------------------------------]]

require 'defs'
require 'util'


--[[ OLD CRUD
function Quest_leafiness()

  -- This determines distance of the room to a leaf:
  --   0 = room is a leaf
  --   1 = room has a leaf neighbour
  --   etc....

  local function determine_leaf_dist(R)

    if R.num_branch == 1 then
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
--]]


function Quest_decide_start_room(arena)

  local GROUND_COSTS =
  {
    ["valley/ground"] = -100,
    ["valley/hill"]   = -237,
    ["ground/hill"]   = -100,

    ["hill/ground"]   =  100,
    ["hill/valley"]   =  237,
    ["ground/valley"] =  100,
  }

  local function eval_connection(C)
    if C.cost then return end

    local A = C.src
    local B = C.dest

    local kind_AB = A.kind .. "/" .. B.kind

    local cost = GROUND_COSTS[kind_AB] or 0

    cost = cost + (#A.conns     - #B.conns)     * 23
    cost = cost + (#A.teleports - #B.teleports) * 144

    if C.big_entrance then
      cost = cost + sel(C.dest == C.big_entrance, -1, 1) * 70
    end

    C.cost = cost

con.debugf("Connection cost: %1.2f\n", C.cost)
  end

  local function eval_recursive(R, visited)
    visited[R] = true

    local cost = 0

    for _,C in ipairs(R.conns) do
      eval_connection(C)
      local N = sel(R == C.src, C.dest, C.src)
      if not visited[N] then
        cost = cost + eval_recursive(N, visited) + C.cost * sel(R == C.src,1,-1)
      end
    end

    for _,T in ipairs(R.teleports) do
      eval_connection(T)
      local N = sel(R == T.src, T.dest, T.src)
      if not visited[N] then
        cost = cost + eval_recursive(N, visited) + T.cost * sel(R == T.src,1,-1)
      end
    end

    return cost
  end

  local function eval_room(R)
    local cost = eval_recursive(R, {})

    -- really big rooms are wasted for the starting room
    cost = cost + R.sw * R.sh * 7

    -- should not start in a hallway!
    if R.hallway then cost = cost + 666 end

    -- add a touch of randomness
    return cost + rand_range(-2, 2)
  end

  local function natural_flow(R, visited)
    visited[R] = true

    for _,C in ipairs(R.conns) do
      if R == C.dest and not visited[C.src] then
        C.src, C.dest = C.dest, C.src
      end
      if R == C.src and not visited[C.dest] then
        natural_flow(C.dest, visited)
      end
    end

    for _,T in ipairs(R.teleports) do
      if R == T.dest and not visited[T.src] then
        T.src, T.dest = T.dest, T.src
      end
      if R == T.src and not visited[T.dest] then
        natural_flow(T.dest, visited)
      end
    end
  end


  ---| Quest_decide_start_room |---

  for _,R in ipairs(arena.rooms) do
    R.start_cost = eval_room(R)
    con.debugf("Room (%d,%d) : START COST : %1.4f\n", R.lx1,R.ly1, R.start_cost)
  end

  arena.start = table_sorted_first(arena.rooms, function(A,B) return A.start_cost < B.start_cost end)

  arena.start.purpose = "START"

  con.debugf("Start room (%d,%d)\n", arena.start.lx1, arena.start.ly1)

  -- update connections so that 'src' and 'dest' follow the natural
  -- flow of the level, i.e. player always walks src -> dest (except
  -- when backtracking).
  natural_flow(arena.start, {})
end


function Quest_decide_end_room(arena)

  local function eval_room(R)
    local cost = 0

    -- checks for being near the start room
    for _,C in ipairs(R.conns) do
      local N = sel(R == C.src, C.dest, C.src)
      if N == arena.start then cost = 1000 end
    end

    for _,T in ipairs(R.teleports) do
      local N = sel(R == T.src, T.dest, T.src)
      if N == arena.start then cost = 2000 end
    end

    if R == arena.start then cost = 4000 end

    -- should be a leaf
    if #R.teleports > 0 then cost = cost + 500 end
    if #R.conns > 1 then cost = cost + 200 end
    if #R.conns > 2 then cost = cost + 100 end

    -- prefer an indoor room
    if not (R.kind == "building" or R.kind == "cave") then
      cost = cost + 50
    end

    -- should be small
    cost = cost + math.min(95, R.sw * R.sh)

    return cost + con.random()
  end

  local function room_conn_dist(R, C)
    local x1 = (R.sx1 + R.sx2) / 2
    local y1 = (R.sy1 + R.sy2) / 2

    local x2 = (C.src_S.sx + C.dest_S.sx) / 2
    local y2 = (C.src_S.sy + C.dest_S.sy) / 2

    return math.abs(x2 - x1) + math.abs(y2 - y1)
  end

  local function conn_conn_dist(B, C)
    local x1 = (B.src_S.sx + B.dest_S.sx) / 2
    local y1 = (B.src_S.sy + B.dest_S.sy) / 2

    local x2 = (C.src_S.sx + C.dest_S.sx) / 2
    local y2 = (C.src_S.sy + C.dest_S.sy) / 2

    return math.abs(x2 - x1) + math.abs(y2 - y1)
  end

  local function iterate_exit_dists(R, dist, via_C)
----    if C0 and C1 then
----      dist = dist + math.abs(conn.src_S.sx - conn.dest_S.sx)
----      dist = dist + math.abs(conn.src_S.sy - conn.dest_S.sy)
----con.debugf("CONN DIST: %d+%d\n",
----      math.abs(conn.src_S.sx - conn.dest_S.sx) ,
----      math.abs(conn.src_S.sy - conn.dest_S.sy) )
----    end

    for _,C in ipairs(R.conns) do
      if R == C.src then
        local new_dist = dist
        if via_C then
          new_dist = new_dist + conn_conn_dist(via_C, C)
        else
          new_dist = new_dist + room_conn_dist(R, C)
        end

        iterate_exit_dists(C.dest, new_dist, C)
      end
    end

    for _,T in ipairs(R.teleports) do
      if R == T.src then
        iterate_exit_dists(T.dest, dist + 2)
      end
    end

    if via_C then
      dist = dist + room_conn_dist(R, via_C)
    end

    -- penalty for start room
    if R == arena.start then
      dist = dist - 1000
    end

    -- penalty for non-leafs
    if R.num_branch > 1 then
      dist = dist - 200
    end

    -- penalty for large rooms
    dist = dist - math.min(95, R.sw * R.sh)

    -- bonus for indoor room
    if (R.kind == "building" or R.kind == "cave") then
      dist = dist + 50
    end

    R.exit_dist = dist + con.random()
  end

  local function main_path_to(R, E)
    if R == E then return {} end

    for _,C in ipairs(R.conns) do
      if R == C.src then
        local path = main_path_to(C.dest, E)
        if path then table.insert(C, 1, path); return path end
      end
    end

    for _,T in ipairs(R.teleports) do
      if R == T.src then
        local path = main_path_to(T.dest, E)
        if path then table.insert(T, 1, path); return path end
      end
    end

    return nil -- NOT FOUND --
  end

  local function mark_main_path()
    local path = main_path_to(arena.start, arena.exit)

    if not path then error("cannot find main path!!") end

    for _,C in ipairs(path) do
      C.     main_path = true
      C. src.main_path = true
      C.dest.main_path = true
    end
  end


  ---| Quest_decide_start_room |---

  if PLAN.num_puzz == 0 then
    -- when no keys/switches : find room furthest from start

    iterate_exit_dists(arena.start, 0)

    for _,R in ipairs(arena.rooms) do
      con.debugf("Room (%d,%d) : EXIT DIST : %1.4f\n", R.lx1,R.ly1, R.exit_dist)
    end

    arena.exit = table_sorted_first(arena.rooms, function(A,B) return A.exit_dist > B.exit_dist end)
  else
    for _,R in ipairs(arena.rooms) do
      R.exit_cost = eval_room(R)
      con.debugf("Room (%d,%d) : EXIT COST : %1.4f\n", R.lx1,R.ly1, R.exit_cost)
    end

    arena.exit = table_sorted_first(arena.rooms, function(A,B) return A.exit_cost < B.exit_cost end)
  end

  arena.exit.purpose = "EXIT"

  con.debugf("Exit room (%d,%d)\n", arena.exit.lx1, arena.exit.ly1)

  mark_main_path()
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
    C.trav_src  = Quest_travel_volume(C.src,  { [C.dest]=true })
    C.trav_dest = Quest_travel_volume(C.dest, { [C.src] =true })

    C.trav_diff = math.abs(C.trav_src - C.trav_dest)

--[[
 con.debugf("Room (%d,%d) <--> (%d,%d) trav_diff:%d\n",
        C.src.lx1, C.src.ly1, C.dest.lx1, C.dest.ly1, C.trav_diff)
--]]
  end -- C
end


function Quest_divide_group(parent)

  -- Primary function is to find a suitable connection amongst the
  -- rooms in the list which can be locked (by a key or switch).

  -- FIXME : more detail of algorithm.....

  local function free_branches(R)
    local count = 0
    for _,C in ipairs(R.conns) do
      if C and not C.lock then
        count = count + 1
      end
    end
    return count
  end

  local function room_group_contains(start_R, R, exclude_set)
    if start_R == R then return true end
    if exclude_set[start_R] then return false end

    exclude_set[start_R] = true

    for _,C in ipairs(start_R.conns) do
      local N = sel(C.src == start_R, C.dest, C.src)
      if room_group_contains(N, R, exclude_set) then return true end
    end

    for _,T in ipairs(start_R.teleports) do
      local N = sel(T.src == start_R, T.dest, T.src)
      if room_group_contains(N, R, exclude_set) then return true end
    end

    return false
  end

  local function find_lockable_conn(group)
    if #group.rooms < 5 or #group.conns < 4 then
      return nil
    end

    table.sort(group.conns, function(A,B) return A.trav_diff < B.trav_diff end)

    for _,C in ipairs(group.conns) do

      -- generally we require the pivot room to be in the front group.
      -- Hence swap 'src' and 'dest' to satisfy that condition.

      local s_free = free_branches(C.src)
      local d_free = free_branches(C.dest)

      local can_swap = true

      if group.pivot and not group.need_start then 
        can_swap  = false
        if room_group_contains(C.dest, group.pivot, { [C.src]=true }) then
  con.debugf("(Pivot was in back group)\n")
          C.src,  C.dest = C.dest, C.src
          s_free, d_free = d_free, s_free
        end
      end

      -- also require the source room to have >= 3 branches
      -- (entry branch, key branch and branch through locked door).
      -- 
      -- Need to check for locked connections ????
      --
      -- For need_start groups, 2 branches is OK (one for key and
      -- one for exit), and we'll put the start in the same room.
      -- FIXME: IMPLEMENT THAT!

      if can_swap and s_free < d_free then
        C.src,  C.dest = C.dest, C.src
        s_free, d_free = d_free, s_free
      end

      if s_free >= 3 then
        return C -- FOUND ONE
      end
    end

    return nil -- failed
  end


  local function collect_group_at(child, R, seen_rooms, seen_conns)
    if not child then
      child = { rooms={}, conns={} }
    end

    if seen_rooms[R] then
      return child
    end

    seen_rooms[R] = true
    table.insert(child.rooms, R)

    for _,C in ipairs(R.conns) do
      if not C.lock and not seen_conns[C] then
        seen_conns[C] = true
        table.insert(child.conns, C)
        local N = sel(R == C.src, C.dest, C.src)
        collect_group_at(child, N, seen_rooms, seen_conns)
      end
    end

    for _,T in ipairs(R.teleports) do
      if not seen_conns[T] then
        seen_conns[T] = true
        local N = sel(R == T.src, T.dest, T.src)
        collect_group_at(child, N, seen_rooms, seen_conns)
      end
    end

    return child
  end

  local function split_group(C)
    assert(C.lock)
    
    Quest_update_trav_diff()

    return collect_group_at(nil, C.src,  { [C.dest]=true }, {}) ,
           collect_group_at(nil, C.dest, { [C.src]=true },  {})
  end

  local function find_unused_leaf(R, exclude_set)
    
    if not exclude_set then exclude_set = {} end

    if exclude_set[R] then return nil end

    exclude_set[R] = true

    if free_branches(R) <= 1 and not R.purpose then
      return R
    end

    for _,C in ipairs(R.conns) do
      if not C.lock then
        local N = sel(C.src == R, C.dest, C.src)
        local L = find_unused_leaf(N, exclude_set)
        if L then return L end
      end
    end -- C

    for _,T in ipairs(R.conns) do
      local N = sel(T.src == R, T.dest, T.src)
      local L = find_unused_leaf(N, exclude_set)
      if L then return L end
    end -- T

    return nil
  end


  ---| Quest_divide_group |---


  -- find_lockable_conn may swap 'src' and 'dest'
  -- Hence here: C.src is earlier and C.dest is later (quest progression)

  C = find_lockable_conn(parent)

  if not C then
con.debugf("No lockable connections : %d  pivot=%s\n", #parent.rooms, sel(parent.pivot, "yes", "NO"))

    if parent.lock_item then
      -- The lock item is not placed now, but later on when we have
      -- decided exactly which locks we shall implement.

      parent.lock_item.pivot = parent.pivot or parent.rooms[1]
    end

    if parent.need_exit then
----      local EXIT_R = find_unused_leaf(parent.pivot or parent.rooms[1])
----      if not EXIT_R then error("Cannot find room for EXIT!!") end
----      EXIT_R.purpose = "exit"
----      PLAN.exit_room = EXIT_R
    end

    if parent.need_start then
---      local START_R = find_unused_leaf(parent.pivot or parent.rooms[1])
---      if not START_R then error("Cannot find room for START!!") end
---      START_R.purpose = "start"
---      PLAN.start_room = START_R
    end

    return
  end


  -- create lock information
  local LOCK =
  {
    conn = C,
    trav_sum = C.trav_src + C.trav_dest,
  }

  C.lock = LOCK

con.debugf("Candidate: (%d,%d) --> (%d,%d) diff:%d lock:%s sum:%d\n",
C.src.lx1, C.src.ly1, C.dest.lx1, C.dest.ly1, C.trav_diff, tostring(C.lock), C.lock.trav_sum)


  local front, back = split_group(C)
  -- now we have two separate groups of rooms

con.debugf("Group (%d rooms, %d conns) split:\n", #parent.rooms, #parent.conns)
con.debugf("  Front (%d rooms, %d conns)\n", # front.rooms, # front.conns)
con.debugf("  Back  (%d rooms, %d conns)\n", #  back.rooms, #  back.conns)

  front.pivot = C.src
  front.lock_item = C.lock
  front.need_start = parent.need_start

  back.pivot = C.dest
  back.lock_item = parent.lock_item
  back.need_exit = parent.need_exit
 
  LOCK.front = Quest_divide_group(front)
  LOCK.back  = Quest_divide_group(back)

  return LOCK

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


function Quest_hallways()
  -- Marks certain rooms to be hallways, using the following criteria:
  --   - indoor non-leaf room
  --   - MIN(w,h) == 1 (sometimes 2)
  --   - all neighbours are indoor
  --   - no purpose (not a start room, exit room, key room)
  --   - no teleporters

  local HALL_SIZE_PROBS = { 99, 75, 50, 25 }
  local REVERT_PROBS    = {  0, 50, 84, 99 }

  local function eval_hallway(R)
    if not (R.kind == "building" or R.kind == "cave") then
      return false
    end

--  if R.purpose then return false end
    if #R.teleports > 0 then return false end
    if R.num_branch < 2 then return false end
    if R.num_branch > 5 then return false end

    for _,C in ipairs(R.conns) do
      local N = sel(C.src == R, C.dest, C.src)
      if not (N.kind == "building" or N.kind == "cave") then
        return false
      end
    end

    local rw = math.min(R.sw, R.sh)

    if rw > 4 then return false end

    return rand_odds(HALL_SIZE_PROBS[rw])
  end

  local function surrounded_by_halls(R)
    local hall_nb = 0
    for _,C in ipairs(R.conns) do
      local N = sel(C.src == R, C.dest, C.src)
      if N.hallway then hall_nb = hall_nb + 1 end
    end

    return (hall_nb == #R.conns) or (hall_nb >= 3)
  end

  ---| Quest_hallways |---
  
  for _,R in ipairs(PLAN.all_rooms) do
    if eval_hallway(R) then
      R.hallway = true
    end
  end

  -- large rooms which are surrounded by hallways are wasted,
  -- hence look for them and revert them back to normal.
  for _,R in ipairs(PLAN.all_rooms) do
    if R.hallway and surrounded_by_halls(R) then
      local rw = math.min(R.sw, R.sh)
      assert(rw <= 4)

      if rand_odds(REVERT_PROBS[rw]) then
        R.hallway = nil
con.debugf("Reverted HALLWAY @ (%d,%d)\n", R.lx1,R.ly1)
      end
    end
  end

  -- !!!! TEMP CRUD
  for _,R in ipairs(PLAN.all_rooms) do
    if R.hallway then
      local rw, rh = R.sw, R.sh

      if math.min(rw,rh) >= 3 and #R.conns >= 3 then
        for x = R.sx1+1, R.sx2-1 do for y = R.sy1+1, R.sy2-1 do
          SEEDS[x][y][1].room = nil
        end end -- x, y
      end
    end
  end
end


local function Quest_add_final_lock(arena)
end


local function Quest_num_puzzles(arena)
  PLAN.num_puzz = 0

  local PUZZLE_MINS = { less=18, normal=12, more=8, mixed=16 }
  local PUZZLE_MAXS = { less=10, normal= 8, more=4, mixed=6  }

  if not PUZZLE_MINS[OB_CONFIG.puzzles] then
    con.printf("Puzzles disabled\n")
    return
  end

  local p_min = #arena.rooms / PUZZLE_MINS[OB_CONFIG.puzzles]
  local p_max = #arena.rooms / PUZZLE_MAXS[OB_CONFIG.puzzles]

  PLAN.num_puzz = int(0.25 + rand_range(p_min, p_max))

  con.printf("Number of puzzles: %d  (%1.2f-%1.2f) rooms=%d\n", PLAN.num_puzz, p_min, p_max, #arena.rooms)
end


local function Quest_add_puzzle()

  -- Algorithm:
  --
  -- The first puzzle is special, it will lock a connection that
  -- leads to the EXIT room of the map.  Any connection is possible,
  -- including one from the start room or one leading to the exit
  -- room itself, as long as the source contains a "free" branch
  -- (which will lead to the key or switch).
  --
  -- After we create the first puzzle (splitting the arena), we'd
  -- rather not process the second arena (containing the exit) again,
  -- because the only thing we can do with it is what we did before:
  -- lock a connection that leads to the exit.  Hence how we choose
  -- the first puzzle connection, its the distance to the exit room,
  -- is quite important.  Too close is bad for big maps with only a
  -- few puzzles, too far is bad for maps with many puzzles.
  --
  -- For subsequent puzzles (in non-EXIT arenas) there are two types
  -- of locks, either a connection along the start->exit path (as
  -- for EXIT arenas) or alternatively one of the branches OFF the
  -- main path.
  --
  -- Locking a branch OFF the arena's path (including the start)
  -- means that the key that was placed for the original locked
  -- door is replaced with a key for the new lock, and the old key
  -- must be placed somewhere beyond the new locked door.
end


function Quest_assign()

  con.printf("\n--==| Quest_assign |==--\n\n")

  -- need at least a START room and an EXIT room
  assert(#PLAN.all_rooms >= 2)

  -- count branches in each room
  for _,R in ipairs(PLAN.all_rooms) do
    R.sw, R.sh = box_size(R.sx1, R.sy1, R.sx2, R.sy2)
    R.num_branch = #R.conns + #R.teleports
    if R.num_branch == 0 then
      error("Room exists with no connections!")
    end
con.printf("Room (%d,%d) branches:%d\n", R.lx1,R.ly1, R.num_branch)
  end

  Quest_hallways()

  local arena =
  {
    rooms = copy_table(PLAN.all_rooms),
    conns = copy_table(PLAN.all_conns),

    need_start = true,
    need_exit  = true,
  }

  PLAN.all_arenas = { arena }


  Quest_num_puzzles(arena)

  Quest_decide_start_room(arena)
  Quest_decide_end_room(arena)

  for i = 1,PLAN.num_puzz do
    Quest_add_puzzle()
  end


--[[
Quest_update_trav_diff()

local lock, a_back = Quest_divide_group(arena)

PLAN.root_lock = lock
--]]


  local START_R = arena.start
  assert(START_R)

  local sx = int((START_R.sx1 + START_R.sx2) / 2.0)
  local sy = int((START_R.sy1 + START_R.sy2) / 2.0)


  SEEDS[sx][sy][1].is_start = true

  con.printf("Start seed @ (%d,%d)\n", sx, sy)


  local EXIT_R = arena.exit
  assert(EXIT_R)
  assert(EXIT_R ~= START_R)

  local ex = int((EXIT_R.sx1 + EXIT_R.sx2) / 2.0)
  local ey = int((EXIT_R.sy1 + EXIT_R.sy2) / 2.0)


  SEEDS[ex][ey][1].is_exit = true

  con.printf("Exit seed @ (%d,%d)\n", ex, ey)
end

