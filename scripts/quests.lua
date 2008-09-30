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


}


--------------------------------------------------------------]]

require 'defs'
require 'util'


--[[
function OLD_Quest_decide_start_room(arena)

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
      local N = C:neighbor(R)
      if not visited[N] then
        cost = cost + eval_recursive(N, visited) + C.cost * sel(R == C.src,1,-1)
      end
    end

    for _,T in ipairs(R.teleports) do
      eval_connection(T)
      local N = T:neighbor(R)
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
--]]


function Quest_decide_start_room(arena)

  local function eval_room(R)
    -- small preference for indoor rooms
    local cost = sel(R.outdoor, 15, 0)

    -- preference for leaf rooms
    cost = cost + 40 * (#R.conns ^ 0.6)

    -- large amount of randomness
    cost = cost + 100 * gui.random() * gui.random()

    return cost
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
    gui.debugf("Room L(%d,%d) : START COST : %1.4f\n", R.lx1,R.ly1, R.start_cost)
  end

  arena.start = table_sorted_first(arena.rooms, function(A,B) return A.start_cost < B.start_cost end)

  gui.printf("Start room S(%d,%d)\n", arena.start.sx1, arena.start.sy1)

  -- update connections so that 'src' and 'dest' follow the natural
  -- flow of the level, i.e. player always walks src -> dest (except
  -- when backtracking).
  natural_flow(arena.start, {})
end


--[[
function Quest_decide_exit_room(arena)

  local function eval_room(R)
    local cost = 0

    -- checks for being near the start room
    for _,C in ipairs(R.conns) do
      local N = C:neighbor(R)
      if N == arena.start then cost = 1000 end
    end

    for _,T in ipairs(R.teleports) do
      local N = T:neighbor(R)
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
--]]



function Quest_update_tvols(arena)

  function travel_volume(R, seen_conns)
    -- Determine total volume of rooms that are reachable from the
    -- given room R, including itself, but excluding connections
    -- that have been "locked" or already seen.

    local total = assert(R.svolume)

    for _,C in ipairs(R.conns) do
      if not C.lock and not seen_conns[C] then
        local N = C:neighbor(R)
        seen_conns[C] = true
        total = total + travel_volume(N, seen_conns)
      end
    end

    return total
  end


  --| Quest_update_tvols |---  

  for _,C in ipairs(arena.conns) do
    C.src_tvol  = travel_volume(C.src,  { [C]=true })
    C.dest_tvol = travel_volume(C.dest, { [C]=true })
  end
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


function Quest_lock_up_arena(arena)

  local function free_branches(R)
    local count = 0
    for _,C in ipairs(R.conns) do
      if C and not C.lock then
        count = count + 1
      end
    end
    return count
  end

  local function eval_arena(arena)
    local junctions = 0

    for _,R in ipairs(arena.rooms) do
      local free_br = free_branches(R)
      if free_br >= 2 then
        junctions = junctions + 1
      end
    end

    -- a lock is impossible without a junction
    if junctions == 0 then
      return -1
    end

    local score = junctions + gui.random() / 2.0

    return score
  end

  local function eval_lock(C)
    -- Factors to consider:
    --
    -- 1) primary factor is how well this connection breaks up the
    --    arena: a 50/50 split is the theoretical ideal, however we
    --    actually go for 66/33 split, because locked doors are
    --    better closer to the exit room than the start room
    --    [extra space near the start room can be used for weapons
    --    and other pickups].
    --
    -- 2) distance to the new target room is also important, need
    --    to give the player some challenge to get that key.
    --
    -- 4) try to avoid Outside-->Outside connections, since we
    --    cannot use keyed doors in DOOM without creating a tall
    --    (ugly) door frame.  Worse is when there is a big height
    --    difference.

    assert(C.src_tvol and C.dest_tvol)

    local cost = math.abs(C.src_tvol - C.dest_tvol * 1.5)

    if C.src.outdoor and C.dest.outdoor then
      cost = cost + 30
    end

    return cost + gui.random()
  end

  local function dump_locks(list)
    for _,C in ipairs(list) do
      gui.debugf("Lock S(%d,%d) --> S(%d,%d) cost=%1.2f\n",
                 C.src.sx1,C.src.sy1, C.dest.sx1,C.dest.sy1, C.lock_cost)
    end
  end


  ---| Quest_lock_up_arena |---

  -- choose connection that will get locked
  local poss_locks = {}

  for _,C in ipairs(arena.conns) do
    local free_br = free_branches(C.src)
    if free_br >= 2 then
      C.lock_cost = eval_lock(C)
      table.insert(poss_locks, C)
    end
  end

  assert(#poss_locks > 0)
  dump_locks(poss_locks)

  local LC = table_sorted_first(poss_locks, function(X,Y) return X.lock_cost < Y.lock_cost end)
  assert(LC)

  gui.debugf("Lock conn has COST:%1.2f\n", LC.lock_cost)


  local LOCK =
  {
    conn = LC,
    tag  = PLAN:alloc_tag(),
  }

  LC.lock = LOCK
  arena.lock = LOCK

  table.insert(PLAN.all_locks, LOCK)


-- temp crud for debugging
local KS = LC.dest_S
if KS and LC.src_S then
local dir = delta_to_dir(LC.src_S.sx - KS.sx, LC.src_S.sy - KS.sy)
KS.borders[dir].kind = "lock_door"
KS.borders[dir].key_item = #PLAN.all_locks
end


  --- perform split ---

  gui.debugf("Splitting arena, old sizes: %d+%d", #arena.rooms, #arena.conns)

  local front_A =
  {
    rooms = {},
    conns = {},

    start  = arena.start,
    lock   = LOCK,
  }

  local back_A =
  {
    rooms = {},
    conns = {},

    start  = lock_C.dest,
    lock   = LOCK,
  }

  local function collect_arena(A, R)
    table.insert(A.rooms, R)

    for _,C in ipairs(R.conns) do
      if C.src == R and C == LC then
        visit(back_A, C.dest)
      elseif C.src == R and not C.lock then
        table.insert(A.conns, C)
        visit(A, C.dest)
      end
    end
  end

  collect_arena(front_A, arena.start)


  -- link in the newbies...
  table.insert(PLAN.all_arenas, front_A)
  table.insert(PLAN.all_arenas, back_A)

  -- remove the oldie....
  for index,A in ipairs(PLAN.all_arenas) do
    if arena == A then
      table.remove(PLAN.all_arenas, index)
      break;
    end
  end

  gui.debugf("Successful split, new sizes: %d+%d | %d+%d\n",
             #front_A.rooms, #front_A.conns,
              #back_A.rooms,  #back_A.conns)
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


  -- choose arena to add the locked door into
  for _,A in ipairs(PLAN.all_arenas) do
    A.split_score = eval_arena(A)
gui.debugf("Arena %s  split_score:%1.4f\n", tostring(A), A.split_score)
  end

  local arena = table_sorted_first(PLAN.all_arenas, function(X,Y) return X.split_score > Y.split_score end)

  if arena.split_score < 0 then
    gui.debugf("No more puzzles could be made!\n")
    return
  end

  Quest_update_tvols(arena)

  Quest_lock_up_arena(arena)
end


function Quest_assign()

  gui.printf("\n--==| Quest_assign |==--\n\n")

  -- need at least a START room and an EXIT room
  assert(#PLAN.all_rooms >= 2)

  -- count branches in each room
  for _,R in ipairs(PLAN.all_rooms) do
    R.sw, R.sh = box_size(R.sx1, R.sy1, R.sx2, R.sy2)
    R.svolume  = (R.sw+1) * (R.sh+1) / 2

    if R.kind ~= "scenic" then
      R.num_branch = #R.conns + #R.teleports
      if R.num_branch == 0 then
        error("Room exists with no connections!")
      end
gui.printf("Room (%d,%d) branches:%d\n", R.lx1,R.ly1, R.num_branch)
    end
  end

  PLAN.num_puzz = Quest_num_puzzles(#PLAN.all_rooms)


  local ARENA =
  {
    rooms = {},
    conns = copy_table(PLAN.all_conns),
  }

  for _,R in ipairs(PLAN.all_rooms) do
    if R.kind ~= "scenic" then
      table.insert(ARENA.rooms, R)
    end
  end


  PLAN.all_arenas = { ARENA }
  PLAN.all_locks  = {}

  Quest_decide_start_room(ARENA)

  PLAN.start_room = PLAN.all_arenas[1].start
  PLAN.start_room.purpose = "START"


  for i = 1,PLAN.num_puzz do
    Quest_add_puzzle()
  end


  for _,A in ipairs(PLAN.all_arenas) do
    for _,R in ipairs(A.rooms) do
      R.arena = A
    end
  end


  -- TEMP CRUD FOR BUILDER....


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

