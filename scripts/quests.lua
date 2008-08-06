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


class Lock
{
  conn : CONN
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


function Quest_decide_start_room()

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

    cost = cost + rand_range(-1, 1)

    C.cost = cost

con.debugf("Connection cost: %1.2f\n", C.cost)
  end

  local function eval_area(R, visited)
    visited[R] = true

    local cost = 0

    for _,C in ipairs(R.conns) do
      eval_connection(C)
      local N = sel(R == C.src, C.dest, C.src)
      if not visited[N] then
        cost = cost + eval_area(N, visited) + C.cost * sel(R == C.src,1,-1)
      end
    end

    for _,T in ipairs(R.teleports) do
      eval_connection(T)
      local N = sel(R == T.src, T.dest, T.src)
      if not visited[N] then
        cost = cost + eval_area(N, visited) + T.cost * sel(R == T.src,1,-1)
      end
    end

    return cost
  end


  ---| Quest_decide_start_room |---

  for _,R in ipairs(PLAN.all_rooms) do
    R.start_cost = eval_area(R, {}) -- + rand_range(-5, 5)
    con.debugf("Room (%d,%d) : START COST : %1.4f\n", R.lx1,R.ly1, R.start_cost)
  end


  -- sort rooms by cost and select lowest one

  local list = copy_table(PLAN.all_rooms)

  table.sort(list, function(A, B) return A.start_cost < B.start_cost end)

  con.debugf("LIST=%s\n",table_to_str(list,2))

  PLAN.start_room = list[1]
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

---##  local function split_do_move(S, D, front, back)
---##    assert(not S.split_n or not D.split_n)
---##    if not S.split_n then
---##      S.split_n = D.split_n
---##      table.insert(sel(S.split_n==1, front.rooms, back.rooms), S)
---##    else
---##      D.split_n = S.split_n
---##      table.insert(sel(D.split_n==1, front.rooms, back.rooms), D)
---##    end
---##  end
---##
---##  local function split_group(group, join_C)
---##    local front = { rooms={}, conns={} }
---##    local back  = { rooms={}, conns={} }
---##
---##    table.insert(front.rooms, join_C.src)
---##    table.insert( back.rooms, join_C.dest)
---##
---##    join_C. src.split_n = 1
---##    join_C.dest.split_n = 2
---##
---##    for loop = 1,999 do
---##      for _,C in ipairs(group.conns) do if not C.lock then
---##        if C.src.split_n ~= C.dest.split_n then
---##          split_do_move(C.src, C.dest, front, back)
---##          table.insert(sel(C.src.split_n==1, front.conns, back.conns), C)
---##        end
---##      end end -- C
---##
---##---!!!      for _,T in ipairs(group.conns) do
---##---!!!        if T.src.split_n ~= T.dest.split_n then
---##---!!!          split_do_move(T.src, T.dest, front, back)
---##---!!!        end
---##---!!!      end -- T
---##
---##      local R_done = #front.rooms + #back.rooms
---##      local C_done = #front.conns + #back.conns
---##
---##con.debugf("Loop %d:  R_done:%d (of %d)  C_done:%d (of %d)\n",
---##loop, R_done, #group.rooms, C_done, #group.conns)
---##
---##      if (R_done == #group.rooms) and (C_done == #group.conns-1) then
---##        break;
---##      end
---##    end -- loop
---##
---##    for _,R in ipairs(PLAN.all_rooms) do
---##      R.split_n = nil
---##    end
---##
---##    return front, back
---##  end


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
      local EXIT_R = find_unused_leaf(parent.pivot or parent.rooms[1])
      if not EXIT_R then error("Cannot find room for EXIT!!") end
      EXIT_R.purpose = "exit"
      PLAN.exit_room = EXIT_R
    end

    if parent.need_start then
      local START_R = find_unused_leaf(parent.pivot or parent.rooms[1])
      if not START_R then error("Cannot find room for START!!") end
      START_R.purpose = "start"
---      PLAN.start_room = START_R
    end

    return
  end


  -- create lock information
  local LOCK =
  {
    id = 1 + #PLAN.all_locks,
    conn = C,
    trav_sum = C.trav_src + C.trav_dest,
  }

  table.insert(PLAN.all_locks, LOCK)

  C.lock = LOCK

con.debugf("Candidate: (%d,%d) --> (%d,%d) diff:%d lock:%s sum:%d\n",
C.src.lx1, C.src.ly1, C.dest.lx1, C.dest.ly1, C.trav_diff, C.lock.id, C.lock.trav_sum)


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

  con.printf("\n--==| Quest_assign |==--\n\n")

  -- need at least a START room and an EXIT room
  assert(#PLAN.all_rooms >= 2)

  -- count branches in each room
  for _,R in ipairs(PLAN.all_rooms) do
    R.num_branch = #R.conns + #R.teleports
    if R.num_branch == 0 then
      error("Room exists with no connections!")
    end
con.printf("Room (%d,%d) branches:%d\n", R.lx1,R.ly1, R.num_branch)
  end

  Quest_decide_start_room()

  Quest_update_trav_diff()

  local group =
  {
    rooms = PLAN.all_rooms,
    conns = PLAN.all_conns,

    need_start = true,
    need_exit  = true,
  }

  PLAN.all_locks = {}

  Quest_divide_group(group)


  local START_R = PLAN.start_room
  assert(START_R)

  local sx = int((START_R.sx1 + START_R.sx2) / 2.0)
  local sy = int((START_R.sy1 + START_R.sy2) / 2.0)


  SEEDS[sx][sy][1].is_start = true

  con.printf("Start seed @ (%d,%d)\n", sx, sy)


  local EXIT_R = PLAN.exit_room
  assert(EXIT_R)
--!!!!  assert(EXIT_R ~= START_R)

  local ex = int((EXIT_R.sx1 + EXIT_R.sx2) / 2.0)
  local ey = int((EXIT_R.sy1 + EXIT_R.sy2) / 2.0)


  SEEDS[ex][ey][1].is_exit = true

  con.printf("Exit seed @ (%d,%d)\n", ex, ey)
end

