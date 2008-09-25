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
  -- or switch).  There is a start room and a target room.

  rooms : array(ROOM)  -- all the rooms in this arena

  conns : array(CONN)  -- all the direct connections between rooms
                       -- in this arena.  Note that teleporters always
                       -- go between rooms in the same arena

  start : ROOM  -- room which player enters this arena
                -- (map's start room for the very first arena)
                -- Never nil.

  target : ROOM -- room containing the key/switch to exit this
                -- arena, _OR_ the level's exit room itself.
                -- Never nil.

  lock : LOCK   -- what kind of key/switch will be in the 'target'
                -- room, or the string "EXIT" if this arena leads
                -- to the exit room.
                -- Never nil
  
  path : array(CONN)  -- full path of rooms from 'start' to 'target'
                      -- NOTE: may contain teleporters.

}


class LOCK
{
  conn : CONN   -- connection between two rooms (and two arenas)
                -- which is locked (keyed door, lowering bars, etc)

  kind : keyword  -- "KEY" or "SWITCH"

  item : string   -- denotes specific kind of key or switch

  -- used while decided what locks to add:

  branch_mode : keyword  -- "ON" or "OFF"

---###  before, after : ARENA  -- the arenas on each side

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
gui.debugf("Room (%d,%d) : leaf_dist:%d\n", R.lx1,R.ly1, R.leaf_dist or -1)
      end
    end
gui.debugf("Quest_leafiness: loop %d, changes %d\n", loop, changes)

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

gui.debugf("Connection cost: %1.2f\n", C.cost)
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
    cost = cost + R.svolume * 6

---##    -- should not start in a hallway!
---##    if R.hallway then cost = cost + 666 end

    -- add a touch of randomness
    return cost + rand_range(-2, 2)
  end

  local function swap_conn(C)
    C.src, C.dest = C.dest, C.src
    C.src_S, C.dest_S = C.dest_S, C.src_S
  end

  local function natural_flow(R, visited)
    visited[R] = true

    for _,C in ipairs(R.conns) do
      if R == C.dest and not visited[C.src] then
        swap_conn(C)
      end
      if R == C.src and not visited[C.dest] then
        natural_flow(C.dest, visited)
      end
    end

    for _,T in ipairs(R.teleports) do
      if R == T.dest and not visited[T.src] then
        swap_conn(T)
      end
      if R == T.src and not visited[T.dest] then
        natural_flow(T.dest, visited)
      end
    end
  end


  ---| Quest_decide_start_room |---

  for _,R in ipairs(arena.rooms) do
    R.start_cost = eval_room(R)
    gui.debugf("Room (%d,%d) : START COST : %1.4f\n", R.lx1,R.ly1, R.start_cost)
  end

  arena.start = table_sorted_first(arena.rooms, function(A,B) return A.start_cost < B.start_cost end)

  arena.start.purpose = "START"

  PLAN.start_room = arena.start

  gui.debugf("Start room (%d,%d)\n", arena.start.lx1, arena.start.ly1)

  -- update connections so that 'src' and 'dest' follow the natural
  -- flow of the level, i.e. player always walks src -> dest (except
  -- when backtracking).
  natural_flow(arena.start, {})
end


function Quest_decide_exit_room(arena)

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
    if R.kind ~= "indoor" then
      cost = cost + 50
    end

    -- should be small
    cost = cost + math.min(95, R.svolume * 1.5)

    return cost + gui.random()
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
----gui.debugf("CONN DIST: %d+%d\n",
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
    dist = dist - math.min(95, R.svolume * 1.5)

    -- bonus for indoor room
    if (R.kind == "indor") then
      dist = dist + 50
    end

    R.exit_dist = dist + gui.random()
  end

  local function main_path_to(R, E)
    if R == E then return {} end

    for _,C in ipairs(R.conns) do
      if R == C.src then
        local path = main_path_to(C.dest, E)
        if path then table.insert(path, 1, C); return path end
      end
    end

    for _,T in ipairs(R.teleports) do
      if R == T.src then
        local path = main_path_to(T.dest, E)
        if path then table.insert(path, 1, T); return path end
      end
    end

    return nil -- NOT FOUND --
  end

  local function mark_main_path()
    arena.path = main_path_to(arena.start, arena.target)

    if not arena.path then
      error("cannot find main path!!")
    end

---###    for _,C in ipairs(path) do
---###      C.     main_path = true
---###      C. src.main_path = true
---###      C.dest.main_path = true
---###    end
  end


  ---| Quest_decide_exit_room |---

  if PLAN.num_puzz == 0 then
    -- when no keys/switches : find room furthest from start

    iterate_exit_dists(arena.start, 0)

    for _,R in ipairs(arena.rooms) do
      gui.debugf("Room (%d,%d) : EXIT DIST : %1.4f\n", R.lx1,R.ly1, R.exit_dist)
    end

    arena.target = table_sorted_first(arena.rooms, function(A,B) return A.exit_dist > B.exit_dist end)
  else
    for _,R in ipairs(arena.rooms) do
      R.exit_cost = eval_room(R)
      gui.debugf("Room (%d,%d) : EXIT COST : %1.4f\n", R.lx1,R.ly1, R.exit_cost)
    end

    arena.target = table_sorted_first(arena.rooms, function(A,B) return A.exit_cost < B.exit_cost end)
  end

  arena.target.purpose = "EXIT"

  PLAN.exit_room = arena.target

  gui.debugf("Exit room (%d,%d)\n", arena.target.lx1, arena.target.ly1)

  mark_main_path()
end


function Quest_travel_volume(R, exclude_set)
  -- Determine number of rooms that are reachable from the
  -- given room, including itself, but excluding connections
  -- that have been "locked" and rooms in the exclude_set.

  local total = assert(R.svolume)

  exclude_set[R] = true

  for _,C in ipairs(R.conns) do
    if not C.lock then
      local N = sel(C.src == R, C.dest, C.src)
      if not exclude_set[N] then
        exclude_set[N] = true
        total = total + Quest_travel_volume(N, copy_table(exclude_set))
      end
    end
  end

  for _,T in ipairs(R.teleports) do
    -- (teleport connections are never locked)
    local N = sel(T.src == R, T.dest, T.src)
    if not exclude_set[N] then
      exclude_set[N] = true
      total = total + Quest_travel_volume(N, copy_table(exclude_set))
    end
  end

  return total
end


function Quest_update_tvols(arena)
  -- The 'trav_diff' value of a connection between two rooms is the
  -- difference in the number of travelable rooms on either side of
  -- the connection.

  -- Note: we don't do teleporters, as they are never lockable

  for _,C in ipairs(arena.conns) do
    C.src_tvol  = Quest_travel_volume(C.src,  { [C.dest]=true })
    C.dest_tvol = Quest_travel_volume(C.dest, { [C.src] =true })

    local trav_diff = math.abs(C.src_tvol - C.dest_tvol)

--[[
 gui.debugf("Room (%d,%d) <--> (%d,%d) trav_diff:%d\n",
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
  gui.debugf("(Pivot was in back group)\n")
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
    
    Quest_update_tvols()

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
gui.debugf("No lockable connections : %d  pivot=%s\n", #parent.rooms, sel(parent.pivot, "yes", "NO"))

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



gui.debugf("Candidate: (%d,%d) --> (%d,%d) diff:%d lock:%s sum:%d\n",
C.src.lx1, C.src.ly1, C.dest.lx1, C.dest.ly1, C.trav_diff, tostring(C.lock), C.lock.trav_sum)


  local front, back = split_group(C)
  -- now we have two separate groups of rooms

gui.debugf("Group (%d rooms, %d conns) split:\n", #parent.rooms, #parent.conns)
gui.debugf("  Front (%d rooms, %d conns)\n", # front.rooms, # front.conns)
gui.debugf("  Back  (%d rooms, %d conns)\n", #  back.rooms, #  back.conns)

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


function Quest_num_puzzles(num_rooms)
  local PUZZLE_MINS = { less=18, normal=12, more=8, mixed=16 }
  local PUZZLE_MAXS = { less=10, normal= 8, more=4, mixed=6  }

  if not PUZZLE_MINS[OB_CONFIG.puzzles] then
    gui.printf("Puzzles disabled\n")
    return 0
  end

  local p_min = num_rooms / PUZZLE_MINS[OB_CONFIG.puzzles]
  local p_max = num_rooms / PUZZLE_MAXS[OB_CONFIG.puzzles]

  local result = int(0.25 + rand_range(p_min, p_max))

  gui.printf("Number of puzzles: %d  (%1.2f-%1.2f) rooms=%d\n", result, p_min, p_max, num_rooms)

  return result
end


function Quest_add_puzzle()

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

  local function free_branches(R)
    local count = 0
    for _,C in ipairs(R.conns) do
      if C and not C.lock then
        count = count + 1
      end
    end
    return count
  end

  local function eval_arena(A)
    local score = -1

    for _,C in ipairs(A.path) do
      if free_branches(C.src) >= sel(C.src == A.start, 2, 3) then
        score = score + 1.6
      end
    end

    if score < 0 then return -1 end

    score = score + math.min(90, #A.rooms)

    if A.lock ~= "EXIT" then
      score = score + 20
    end

    return score
  end

  local function eval_lock(C, mode, back_mul)
    -- Factors to consider:
    --
    -- 1) primary factor is how well this connection breaks up the
    --    arena: a perfectly 50% split is normally ideal (for the
    --    EXIT arena a higher ratio is better).
    --
    -- 2) distance to the new target room is also important, need
    --    to give the player some challenge to get that key.
    --
    -- 3) entering a big room through its main entrance is nice
    --    
    -- 4) entering a hallway is anti-climactic.
    --
    -- 5) try to avoid Outside-->Outside connections, since we
    --    cannot use keyed doors in DOOM (or if we do, then they
    --    create an ugly tall door-frame).  Worse is when there
    --    is a height difference (though going UP has potential to
    --    use a raising stair for the puzzle).
    --
    -- 6) prefer no teleporters in source room

--!!!!!!!!!
if not C.src_tvol then C.src_tvol = 99 end
if not C.dest_tvol then C.dest_tvol = 99 end

    local cost = math.abs(C.src_tvol - C.dest_tvol * back_mul)

--!!!!!
gui.debugf("src_tvol = %d  dest_tvol = %d\n", C.src_tvol, C.dest_tvol)

---##    if C.dest.hallway then cost = cost + 10 end

    if C.dest.big_entrance == C.src then cost = cost - 20 end

    if #C.src.teleports > 0 then cost = cost + 4 end

    if (C.src.kind ~= "indoor") and (C.dest.kind ~= "indoore") then
      cost = cost + 32
    end

    return cost + gui.random()
  end


  ---| Quest_add_puzzle |---

  for _,A in ipairs(PLAN.all_arenas) do
    if not A.split_score then
      A.split_score = eval_arena(A)
gui.debugf("Arena %s  split_score:%1.4f\n", tostring(A), A.split_score)
    end
  end

  local arena = table_sorted_first(PLAN.all_arenas, function(X,Y) return X.split_score > Y.split_score end)

  if arena.split_score < 0 then
    gui.debugf("No more puzzles could be made!\n")
    return
  end


  Quest_update_tvols(arena)

  local poss_locks = {}

  for _,C in ipairs(arena.conns) do
    C.lock_cost = nil
  end


  local back_mul = 1
  
  if (arena.lock == "EXIT") and (PLAN.num_puzz > 1) then
    back_mul = math.max(3, PLAN.num_puzz)
  end

  for _,C in ipairs(arena.path) do
    if free_branches(C.src) >= sel(C.src == arena.start, 2, 3) then
      C.lock_cost = eval_lock(C, "ON", back_mul)
      C.lock_mode = "ON"
      table.insert(poss_locks, C)

      if arena.lock ~= "EXIT" then
        for _,D in ipairs(C.src.conns) do
          if not D.lock then
            if D.src == C.src and D.dest ~= C.dest then
              D.lock_cost = eval_lock(D, "OFF", back_mul)
              D.lock_mode = "OFF"
              table.insert(poss_locks, D)
            end
          end
        end -- D
      end
    end
  end -- C


  assert(#poss_locks > 0)

  for _,C in ipairs(arena.conns) do
    if C.lock_cost then
      gui.debugf("Lock (%d,%d) --> (%d,%d) cost=%1.2f mode=%s\n",
                 C.src.lx1,C.src.ly1, C.dest.lx1,C.dest.ly1,
                 C.lock_cost, C.lock_mode or "???")
    end
  end


  local lock_C = table_sorted_first(poss_locks, function(X,Y) return X.lock_cost < Y.lock_cost end)
  assert(lock_C)

  gui.debugf("Lock conn has COST:%1.2f\n", lock_C.lock_cost)


  local LOCK =
  {
    conn = lock_C,
    kind = "key",
    item = #PLAN.all_arenas  -- HACK !!!!
  }

  lock_C.lock = LOCK


local KS = lock_C.dest_S
if KS and lock_C.src_S then
local dir = delta_to_dir(lock_C.src_S.sx - KS.sx, lock_C.src_S.sy - KS.sy)
KS.borders[dir].kind = "lock_door"
KS.borders[dir].key_item = LOCK.item
end


  --- perform split ---

  gui.debugf("Splitting arena, old sizes: %d+%d", #arena.rooms, #arena.conns)

  local back_A =
  {
    rooms = {},
    conns = {},

    start  = lock_C.dest,
    target = arena.target,
    lock   = arena.lock,
  }

  arena.rooms = {}
  arena.conns = {}
  arena.lock  = LOCK


  -- arena.start remains the same
  -- arena.target / path are handled below

  arena.split_score = nil


  local function collect_arena(A, R, visited)
    visited[R] = true

gui.debugf(" -- Room (%d,%d)\n", R.lx1, R.ly1)
    table.insert(A.rooms, R)

    for _,C in ipairs(R.conns) do
      if not C.lock then
        local N = sel(R == C.src, C.dest, C.src)
        if not visited[N] then
gui.debugf(" -- Conn (%d,%d) / (%d,%d)\n", C.src.lx1, C.src.ly1,
           C.dest.lx1, C.dest.ly1)
          table.insert(A.conns, C)
          collect_arena(A, N, visited)
        end
      end
    end

    for _,T in ipairs(R.teleports) do
      local N = sel(R == T.src, T.dest, T.src)
      if not visited[N] then
        collect_arena(A, N, visited)
      end
    end
  end

gui.debugf("Collecting FRONT:\n")
  collect_arena(arena,  lock_C.src,  {})

gui.debugf("Collecting BACK:\n")
  collect_arena(back_A, lock_C.dest, {})

  gui.debugf("New arena sizes: %d+%d | %d+%d\n", #arena.rooms, #arena.conns,
             #back_A.rooms, #back_A.conns)


  local T_start = lock_C.dest
  local visited = { [lock_C.src]=true }


  if lock_C.lock_mode == "OFF" then
    
    -- arena.target / path remain the same

    -- SEE BELOW: find back_A.target / path  [ from back_A.start ]

  else  -- "ON" --

    back_A.path = arena.path ; arena.path = {}

    while true do
      if #back_A.path == 0 then
        error("Failed truncating back path!")
      end

      local C = table.remove(back_A.path, 1)

      if C == lock_C then
        break;
      end

      table.insert(arena.path, C)
    end 

    T_start = lock_C.src

    local prev_R
    if #arena.path > 0 then
      prev_R = arena.path[#arena.path].src
      visited[prev_R] = true
    end

--[[
    T_start = nil
    local best_vol = -9999

    for _,C in ipairs(lock_C.src.conns) do
      if not C.lock then
        local N = sel(lock_C.src == C.src, C.dest, C.src)
        local VOL = sel(lock_C.src == C.src, C.dest_tvol, C.src_tvol)
        if N ~= prev_R then
          if not T_start or (VOL > best_vol) then
            T_start, best_vol = N, VOL
          end
        end
      end
    end -- C

    if not T_start then
      error("Mucked up selecting alternative branch!")
    end
--]]
    -- SEE BELOW: find arena.target & __rest__ of path  [ from lock_C.src ]
  end

  assert(T_start)


  -- find new target room
  -- FIXME: BORKED FOR TELEPORTERS !!!

  local function find_target(R, visited)
    
    visited[R] = true

    local best
    local best_vol = -9999

    for _,C in ipairs(R.conns) do
      if not C.lock then
        local N = sel(R == C.src, C.dest, C.src)
        assert(N)
        local VOL = sel(R == C.src, C.dest_tvol, C.src_tvol)
        if not visited[N] then
          if not best or (VOL > best_vol) then
            best, best_vol = C, VOL
          end
        end
      end
    end -- C

    if best then
      local N = sel(R == best.src, best.dest, best.src)
      assert(N)
      local path, t_end = find_target(N, visited)
      table.insert(path, 1, best)
      return path, t_end
    end

    return {}, R
  end


  local T_path, T_end = find_target(T_start, visited)
  assert(T_end)

  if lock_C.lock_mode == "ON" then
    assert(T_end ~= T_start)
  end

  gui.debugf("New Target Room (%d,%d).  Path:\n", T_end.lx1, T_end.ly1)

  for _,C in ipairs(T_path) do
    gui.debugf(" -- (%d,%d) / (%d,%d)\n", C.src.lx1, C.src.ly1,
               C.dest.lx1, C.dest.ly1)
  end


  if lock_C.lock_mode == "OFF" then

    back_A.target = T_end
    back_A.path   = T_path
  
  else -- "ON" --

    arena.target = T_end

    while #T_path > 0 do
      table.insert(arena.path, table.remove(T_path, 1))
    end
  end

gui.debugf("Front Path:\n")
for _,C in ipairs(arena.path) do
gui.debugf(" -- (%d,%d) / (%d,%d)\n", C.src.lx1, C.src.ly1,
           C.dest.lx1, C.dest.ly1)
end

gui.debugf("Back Path:\n")
for _,C in ipairs(back_A.path) do
gui.debugf(" -- (%d,%d) / (%d,%d)\n", C.src.lx1, C.src.ly1,
           C.dest.lx1, C.dest.ly1)
end


  assert(arena.lock ~= "EXIT")
  arena.target.key_item = arena.lock.item

  if back_A.lock ~= "EXIT" then
    back_A.target.key_item = back_A.lock.item
  end


  -- DONE!  link in the newbie...
  table.insert(PLAN.all_arenas, back_A)

  gui.debugf("Successful split\n")
end


function Quest_assign()

  gui.printf("\n--==| Quest_assign |==--\n\n")

  -- need at least a START room and an EXIT room
  assert(#PLAN.all_rooms >= 2)

  -- count branches in each room
  for _,R in ipairs(PLAN.all_rooms) do
    R.sw, R.sh = box_size(R.sx1, R.sy1, R.sx2, R.sy2)
    R.svolume  = (R.sw+1) * (R.sh+1) / 2
    R.num_branch = #R.conns + #R.teleports
    if R.num_branch == 0 then
      error("Room exists with no connections!")
    end
gui.printf("Room (%d,%d) branches:%d\n", R.lx1,R.ly1, R.num_branch)
  end

  PLAN.num_puzz = Quest_num_puzzles(#PLAN.all_rooms)

---##  Quest_hallways()

  local arena =
  {
    rooms = copy_table(PLAN.all_rooms),
    conns = copy_table(PLAN.all_conns),

    lock = "EXIT",
  }

  Quest_decide_start_room(arena)
  Quest_decide_exit_room(arena)


  PLAN.all_arenas = { arena }

  for i = 1,PLAN.num_puzz do
    Quest_add_puzzle()
  end


  for _,A in ipairs(PLAN.all_arenas) do
    for _,R in ipairs(A.rooms) do
      R.arena = A
    end
  end

--[[
Quest_update_trav_diff()

local lock, a_back = Quest_divide_group(arena)

PLAN.root_lock = lock
--]]


  local START_R = PLAN.start_room
  assert(START_R)

  local sx = int((START_R.sx1 + START_R.sx2) / 2.0)
  local sy = int((START_R.sy1 + START_R.sy2) / 2.0)


  SEEDS[sx][sy][1].is_start = true

  gui.printf("Start seed @ (%d,%d)\n", sx, sy)


  local EXIT_R = PLAN.exit_room
  assert(EXIT_R)
  assert(EXIT_R ~= START_R)

  local ex = int((EXIT_R.sx1 + EXIT_R.sx2) / 2.0)
  local ey = int((EXIT_R.sy1 + EXIT_R.sy2) / 2.0)


  SEEDS[ex][ey][1].is_exit = true

  gui.printf("Exit seed @ (%d,%d)\n", ex, ey)
end

