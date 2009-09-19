----------------------------------------------------------------
--  QUEST ASSIGNMENT
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2009 Andrew Apted
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

class ARENA  (( QUEST ))
{
  -- an Arena is a group of rooms, generally with a locked door
  -- to a different arena (requiring the player to find the key
  -- or switch).  There is a start room and a target room.

  rooms : array(ROOM)  -- all the rooms in this arena

  conns : array(CONN)  -- all the direct connections between rooms
                       -- in this arena.  Note that teleporters always
                       -- go between rooms in the same arena

  start : ROOM   -- room which player enters this arena
                 -- (map's start room for the very first arena)
                 -- Never nil.

  target : ROOM  -- room containing the key/switch to exit this
                 -- arena, _OR_ the level's exit room itself.
                 -- Never nil.

  lock : LOCK    -- lock info, which defines what the 'target' room
                 -- will hold (key, switch or an EXIT).
                 -- Never nil.

  path : array(CONN)  -- full path of rooms from 'start' to 'target'

}


class LOCK
{
  kind : keyword  -- "KEY" or "SWITCH" or "EXIT"
  item : string   -- what kind of key or switch (game specific)

  conn : CONN     -- connection between two rooms (and two arenas)
                  -- which is locked (keyed door, lowering bars, etc)

  distance : number  -- number of rooms between key and door

  tag : number    -- tag number to use for a switched door
}


ALGORITHM NOTES
~~~~~~~~~~~~~~~

The fundamental requirement of a locked door is that the player
needs to reach the door _before_ he/she reaches the key.  Then
the player knows what they are looking for.  Without this, the
player can just stumble on the key before finding the door and
says to themselves "what the hell is this key for ???".

Hence we cannot add locked doors just anywhere into the level.
This algorithm assumes that in each group of rooms (an ARENA)
there is a path from the start to the target room (that's the
room which holds either a key or is the EXIT room of the map).
So a locked door can be added somewhere along that path.

It can either block the target room (an "ON" type) or branch
"OFF" the path.  The room where it is added must be a "junction",
i.e. must have a free branch where the player travels along to
find the key to that locked door.

The "ON" type creates more linear progression (see door A,
find key A, see door B, find key B, etc...).  The "OFF" type
creates more memory strain (see door A, then see door B, then
see door C, finally find C key, then find key B, then key A)
and the level requires more back-tracking.

Once we have found the connection to lock, the arena is split
into two new arenas: FRONT (which always contains the same
start room) and BACK.  The two types (ON vs OFF) require
different logic for splitting the arenas.  After the split,
the new arenas will have their own start room, target room
and path, and they might get split again in the future.


--------------------------------------------------------------]]

require 'defs'
require 'util'


function Quest_decide_start_room(arena)

  local function eval_room(R)
    local cost = 0

    -- preference for leaf rooms
    cost = cost + 40 * ((#R.conns) ^ 0.6)

    -- large amount of randomness
    cost = cost + 100 * (1 - gui.random() * gui.random())

    return cost
  end

  local function swap_conn(C)
    C.src, C.dest = C.dest, C.src
    C.src_S, C.dest_S = C.dest_S, C.src_S
    C.dir = 10 - C.dir
  end

  local function natural_flow(R, visited)
    assert(R.kind ~= "scenic")

    visited[R] = true

    for _,C in ipairs(R.conns) do
      if R == C.dest and not visited[C.src] then
        swap_conn(C)
      end
      if R == C.src and not visited[C.dest] then
        natural_flow(C.dest, visited)
        C.dest.entry_conn = C
      end
    end

    for _,T in ipairs(R.teleports) do
      if R == T.dest and not visited[T.src] then
        swap_conn(T)
      end
      if R == T.src and not visited[T.dest] then
        natural_flow(T.dest, visited)
        T.dest.entry_conn = T
      end
    end
  end


  ---| Quest_decide_start_room |---

  for _,R in ipairs(arena.rooms) do
    R.start_cost = eval_room(R)
    gui.debugf("%s : START COST : %1.4f\n", R:tostr(), R.start_cost)
  end

  arena.start = table_pick_best(arena.rooms, function(A,B) return A.start_cost < B.start_cost end)

  assert(#arena.start.conns > 0)

  gui.printf("Start room: %s\n", arena.start:tostr())

  -- update connections so that 'src' and 'dest' follow the natural
  -- flow of the level, i.e. player always walks src -> dest (except
  -- when backtracking).
  natural_flow(arena.start, {})
end


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


function Quest_initial_path(arena)

  -- TODO: preference for paths that contain many junctions
  --       [might be more significant than travel volume]

  local function select_next_room(R, path)
    local best_C
    local best_tvol = -1

    for _,C in ipairs(R.conns) do
      if C.src == R and not C.lock then
        if best_tvol < C.dest_tvol then
          best_tvol = C.dest_tvol
          best_C = C
        end
      end
    end

    if not best_C then
      return nil
    end

    table.insert(path, best_C)

    return best_C.dest
  end


  --| Quest_initial_path |--

  Quest_update_tvols(arena)

  arena.path = {}

  local R = arena.start

  for loop = 1,999 do
    if loop == 999 then
      error("Quest_initial_path infinite loop!")
    end

    if not R then break; end

    arena.target = R
    R = select_next_room(R, arena.path)
  end

  gui.debugf("Arena %s  start: S(%d,%d)  target: S(%d,%d)\n",
             tostring(arena), arena.start.sx1, arena.start.sy1,
             arena.target.sx1, arena.target.sy1)
end


function Quest_num_keys(num_rooms)
  if PARAM.no_keys then return 0 end

  local PUZZLE_NUMS = { less=16, normal=10, more=5, mixed=10  }

---  if not PUZZLE_NUMS[OB_CONFIG.puzzles] then
---    gui.printf("Puzzles disabled\n")
---    return 0
---  end

  local approx = num_rooms / 8 +  ---  PUZZLE_NUMS[OB_CONFIG.puzzles] +
                 gui.random() * gui.random() * 4

  local result = int(approx)

  if PARAM.one_lock_tex then -- FIXME !!!! TEMP CRUD
    result = math.min(2, result)
  end

  gui.printf("Number of keys: %1.2f -> %d  rooms=%d\n", approx, result, num_rooms)

  return result
end


function Quest_lock_up_arena(arena)

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
    -- 2) try to avoid Outside-->Outside connections, since we
    --    cannot use keyed doors in DOOM without creating a tall
    --    (ugly) door frame.  Worse is when there is a big height
    --    difference.
    --
    -- 3) preference for "ON" locks (less back-tracking)

    assert(C.src_tvol and C.dest_tvol)

    local cost = math.abs(C.src_tvol - C.dest_tvol * 2)

    if C.src.outdoor and C.dest.outdoor then
      cost = cost + 40
    end

    if not C.on_path then
      cost = cost + 10
    end

    return cost + gui.random() * 5
  end

  local function add_lock(list, C)
    if not table_contains(list, C) then
      C.on_path = table_contains(arena.path, C)
      C.lock_cost = eval_lock(C)
      table.insert(list, C)
    end
  end

  local function locks_for_room(R, list)
    if R.is_junction then
      for _,C in ipairs(R.conns) do
        if C.src == R and C.can_lock then
          add_lock(list, C)
        end
      end
    end
  end

  local function dump_locks(list)
    for _,C in ipairs(list) do
      gui.debugf("Lock S(%d,%d) --> S(%d,%d) cost=%1.2f\n",
                 C.src.sx1,C.src.sy1, C.dest.sx1,C.dest.sy1, C.lock_cost)
    end
  end

  local function dump_arena(A, name)
    gui.debugf("%s ARENA  %s  %d+%d\n", name, tostring(A), #A.rooms, #A.conns)
    gui.debugf("{\n")

    gui.debugf("  start room  S(%d,%d)\n",  A.start.sx1, A.start.sy1)
    gui.debugf("  target room S(%d,%d)\n", A.target.sx1, A.target.sy1)
    -- NOTE: item not set yet!
    gui.debugf("  lock: %s %s\n", A.lock.kind or "????", A.lock.item or "????")

    gui.debugf("  PATH:\n")
    gui.debugf("  {\n")

    for _,C in ipairs(A.path) do
      gui.debugf("  conn  %s  (%d,%d) -> (%d,%d)\n",
                 tostring(C), C.src.sx1, C.src.sy1, C.dest.sx1, C.dest.sy1)
    end

    gui.debugf("  }\n")
    gui.debugf("}\n")
  end


  ---| Quest_lock_up_arena |---

  dump_arena(arena, "INPUT")

  -- choose connection which will get locked
  local poss_locks = {}

  locks_for_room(arena.start, poss_locks)

  for _,C in ipairs(arena.path) do
    locks_for_room(C.dest, poss_locks)
  end
 
  -- should always have at least one possible lock, otherwise the
  -- Quest_lock_up_arena() function should never have been called.
  assert(#poss_locks > 0)

  dump_locks(poss_locks)

  local LC = table_pick_best(poss_locks, function(X,Y) return X.lock_cost < Y.lock_cost end)
  assert(LC)

  gui.debugf("Lock conn has COST:%1.2f on_path:%s\n",
             LC.lock_cost, sel(LC.on_path, "YES", "NO"))


  local LOCK =
  {
    -- kind and item set later!
    kind = "UNSET",

    conn = LC,
    tag  = alloc_tag(),
  }

  LC.lock = LOCK

  table.insert(LEVEL.all_locks, LOCK)



  --- perform split ---

  gui.debugf("Splitting arena, old sizes: %d+%d", #arena.rooms, #arena.conns)

  local front_A =
  {
    rooms = {},
    conns = {},
    start = arena.start,
    lock  = LOCK,
  }

  local back_A =
  {
    rooms = {},
    conns = {},
    start = LOCK.conn.dest,
    lock  = arena.lock,
  }


  local function collect_arena(A, R)
    table.insert(A.rooms, R)

    for _,C in ipairs(R.conns) do
      if C.src == R and not C.lock then
        table.insert(A.conns, C)
        collect_arena(A, C.dest)
      end
    end
  end

  collect_arena(front_A, front_A.start)
  collect_arena(back_A,  back_A.start)


  Quest_initial_path(back_A)

  if not LC.on_path then
    -- this is easy (front path stays the same)
    front_A.target = arena.target
    front_A.path   = arena.path
  else
    -- create second half of front path
    front_A.start = LOCK.conn.src
    Quest_initial_path(front_A)
    front_A.start = arena.start

    -- add first half of path (upto the locked connection)
    local hit_lock = false
    for index,C in ipairs(arena.path) do
      if C == LOCK.conn then
        hit_lock = true; break;
      end
      table.insert(front_A.path, index, C)
    end

    assert(hit_lock)
  end


  -- find oldie to replace with the newbies...
  -- [this logic ensures the 'all_arenas' list stays in visit order]

  local old_pos
  for index,A in ipairs(LEVEL.all_arenas) do
    if arena == A then old_pos = index ; break end
  end
  assert(old_pos)


  table.insert(LEVEL.all_arenas, old_pos+1, front_A)
  table.insert(LEVEL.all_arenas, old_pos+2, back_A)

  table.remove(LEVEL.all_arenas, old_pos)

  gui.debugf("Successful split, new sizes: %d+%d | %d+%d\n",
             #front_A.rooms, #front_A.conns,
              #back_A.rooms,  #back_A.conns)

  dump_arena(front_A, "FRONT")
  dump_arena( back_A, "BACK")
end


function Quest_add_lock()

  local function conn_is_lockable(C)
    if C.lock then
      return false
    end

    -- Wolf3d: require two locked doors to be perpendicular
    if PARAM.one_lock_tex and #LEVEL.all_locks == 2 then
      local old_dir = LEVEL.all_locks[1].conn.dir -- FIXME !!!
      assert(old_dir and C.dir)

      if not is_perpendicular(old_dir, C.dir) then
        return false
      end
    end

    return true
  end

  local function room_is_junction(R)
    local has_lockable = false
    local traversable = 0

    for _,C in ipairs(R.conns) do
      if C.src == R then
        if C.can_lock then
          has_lockable = true
        end

        if not C.lock then
          traversable = traversable + 1
        end
      end
    end

    return has_lockable and (traversable >= 2)
  end

  local function eval_arena(arena)
    -- count junctions along path
    local R = arena.start
    local junctions = sel(R.is_junction, 1, 0)

    for _,C in ipairs(arena.path) do
      if C.dest.is_junction then
        junctions = junctions + 1
      end
    end

    -- a lock is impossible without a junction
    if junctions == 0 then
      return -1
    end

    local score = junctions + gui.random()

    return score
  end


  --| Quest_add_lock |--

  for _,C in ipairs(LEVEL.all_conns) do
    C.can_lock = conn_is_lockable(C)
  end

  for _,R in ipairs(LEVEL.all_rooms) do
    R.is_junction = room_is_junction(R)
  end

  -- choose arena to add the locked door into
  for _,A in ipairs(LEVEL.all_arenas) do
    A.split_score = eval_arena(A)
gui.debugf("Arena %s  split_score:%1.4f\n", tostring(A), A.split_score)
  end

  local arena = table_pick_best(LEVEL.all_arenas, function(X,Y) return X.split_score > Y.split_score end)

  if arena.split_score < 0 then
    gui.debugf("No more locks could be made!\n")
    return
  end

  Quest_update_tvols(arena)

  Quest_lock_up_arena(arena)
end


function Quest_add_keys()

  local function make_small_exit(R)
    R.kind = "smallexit"

    local C = assert(R.conns[1])

    local S = C.src_S
    local T = C.dest_S

    local B1 = S.border[S.conn_dir]
    local B2 = T.border[T.conn_dir]

    B1.kind = "straddle"
    B2.kind = "straddle"
  end

  for _,arena in ipairs(LEVEL.all_arenas) do
    local R = arena.target
    assert(R)

    if arena.lock.kind == "EXIT" then
      assert(LEVEL.exit_room == R)

      if R.kind == "building" and not R:has_any_lock() and
         R.svolume < 25 and LEVEL.theme.exit
      then
        make_small_exit(R)
      end

    elseif arena.lock.kind == "KEY" then
      R.purpose = arena.lock.kind
      R.key_item = arena.lock.item  -- BLEH!
      R.lock_for_item = arena.lock

    elseif arena.lock.kind == "SWITCH" then
      R.purpose = arena.lock.kind
      R.do_switch = arena.lock.item  -- BLEH!
      R.lock_for_item = arena.lock
    end
  end
end


function Quest_order_by_visit()
  -- put rooms in the 'all_rooms' list into the order which the
  -- player will most likely visit them.

  local visit_time = 1

  local function visit_room(R, path, p_idx)
    assert(not R.visit_time)

    R.visit_time = visit_time
    visit_time = visit_time + 1

    for _,C in ipairs(R.conns) do
      C.tmp_visit = 0

      if C.src ~= R or C.lock then
        -- ignore it
      elseif C == path[p_idx] then
        C.tmp_visit = 9  -- do path-to-key last
      elseif C.dest.parent == R then
        C.tmp_visit = 2 + gui.random()
      else
        C.tmp_visit = 4 + gui.random()
      end
    end

    table.sort(R.conns, function(A,B) return A.tmp_visit < B.tmp_visit end)

    for _,C in ipairs(R.conns) do
      if C.src ~= R or C.lock then
        -- ignore it
      elseif C == path[p_idx] then
        visit_room(C.dest, path, p_idx+1)
      else
        visit_room(C.dest, {}, 1)
      end
    end
  end

  ---| Quest_order_by_visit |---

  for _,A in ipairs(LEVEL.all_arenas) do
    visit_room(A.start, A.path, 1)
  end

  table.sort(LEVEL.all_rooms, function(A,B) return A.visit_time < B.visit_time end)

  gui.debugf("Room Visit Order:\n")
  for _,R in ipairs(LEVEL.all_rooms) do
    gui.debugf("  %d : %s %s %s\n",
               R.visit_time, R:tostr(), R.kind, R.purpose or "-");
  end
end


function Quest_key_distances()
  -- determine distance (approx) between key and the door it opens.
  -- the biggest distances will use actual keys (which are limited)
  -- whereas everything else will use switched doors.

  local function lock_in_path(A, lock)
    if table_empty(A.path) then
      if A.start:has_lock(lock) then return 1 end
    else
      for c_idx,C in ipairs(A.path) do
        if C.src:has_lock(lock) then
          return 1 + #A.path - c_idx
        end
      end
    end

    if A.target:has_lock(lock) then return 0 end

    return nil -- not here
  end

  local function dist_to_lock(arena_idx, lock)
    local dist = 0

    while arena_idx >= 1 do
      local d = lock_in_path(LEVEL.all_arenas[arena_idx], lock)
      if d then
        return dist + d  -- Yay!
      end

      -- try earlier arena
      dist = dist + #LEVEL.all_arenas[arena_idx].path
      arena_idx = arena_idx - 1
    end

    -- FIXME: this may be normal, verify!
    gui.printf("WARNING: Quest_key_distances: cannot find locked door")
    return 12
  end

  ---| Quest_key_distances |---

  gui.debugf("Key Distances:\n")

  for index,A in ipairs(LEVEL.all_arenas) do
    if A.lock.kind == "EXIT" then
      A.lock.distance = 0
    else
      A.lock.distance = 2 + dist_to_lock(index, A.lock) 
    end
    gui.debugf("  Arena #%d : lock_dist %1.1f\n", index, A.lock.distance)
  end
end


function Quest_choose_keys()
  -- there is always at least one "lock" (for EXIT room)
  if #LEVEL.all_locks <= 1 then return end

  for _,LOCK in ipairs(LEVEL.all_locks) do
    LOCK.kscore = LOCK.distance

    -- prefer not to use KEY doors between two Outside rooms
    if LOCK.conn and LOCK.conn.src.outdoor and LOCK.conn.dest.outdoor then
      LOCK.kscore = 1
    end

    LOCK.kscore = LOCK.kscore + gui.random() / 5.0
  end

  table.sort(LEVEL.all_locks, function(A,B) return A.kscore > B.kscore end)

  local use_keys     = shallow_copy(THEME.key_list or GAME.key_list) 
  local use_switches = shallow_copy(THEME.switch_list or GAME.switch_list)
  local use_bars     = shallow_copy(THEME.bar_list or GAME.bar_list)

  rand_shuffle(use_keys)
  rand_shuffle(use_switches)

  -- use less keys when number of locked doors is small
  local want_keys = #use_keys
  while want_keys > 1 and (#LEVEL.all_locks-1 < want_keys * 2) and rand_odds(80) do
    want_keys = want_keys - 1
  end

  -- assign keys first (to locks with biggest distance from key to door)
  local cur_k = 1

  for _,LOCK in ipairs(LEVEL.all_locks) do
    if cur_k > want_keys then
      break;
    end

    if not LOCK.item then
      LOCK.kind = "KEY"
      LOCK.item = use_keys[cur_k]
      cur_k = cur_k + 1
    end
  end

  -- assign switches second (random spread)
  rand_shuffle(LEVEL.all_locks)

  local cur_sw = 0

  for _,LOCK in ipairs(LEVEL.all_locks) do
    if not LOCK.item then
      LOCK.kind = "SWITCH"

      if LOCK.conn.src.outdoor and LOCK.conn.dest.outdoor then
        LOCK.item = rand_element(use_bars)
      else
        LOCK.item = use_switches[1 + cur_sw % #use_switches]
        cur_sw = cur_sw + 1
      end
    end
  end
end


function Quest_add_weapons()
 
  LEVEL.added_weapons = {}

  local function do_mark_weapon(name)
    LEVEL.added_weapons[name] = true

    local allow = LEVEL.allowances[name]
    if allow then
      LEVEL.allowances[name] = sel(allow > 1, allow-1, 0)
    end
  end

  local function do_start_weapon(arena)
    local name_tab = {}

    for name,info in pairs(GAME.weapons) do
      local prob = info.start_prob

      if OB_CONFIG.strength == "crazy" then
        prob = info.add_prob
      end

      if LEVEL.allowances[name] == 0 then
        prob = 0
      end

      if prob and prob > 0 then
        name_tab[name] = info.add_prob
      end
    end -- for weapons

    if table_empty(name_tab) then
      gui.debugf("Start weapon: NONE!!\n")
      return
    end

    local weapon = rand_key_by_probs(name_tab)
    gui.debugf("Start weapon: %s\n", weapon)

    arena.weapon = weapon
    arena.start.weapon = weapon

    do_mark_weapon(weapon)
  end

  local function do_new_weapon(arena)
    local name_tab = {}

    for name,info in pairs(GAME.weapons) do
      local prob = info.add_prob

      if LEVEL.added_weapons[name] or LEVEL.allowances[name] == 0 then
        prob = 0
      end

      if prob and prob > 0 then
        name_tab[name] = info.add_prob
      end
    end

    if table_empty(name_tab) then
      gui.debugf("No weapon @ ARENA_%d\n", arena.id)
      return
    end

    local weapon = rand_key_by_probs(name_tab)

    -- Select a room to put the weapon in.
    -- This is very simplistic, either the start room of the
    -- arena or a neighboring room.
    local R = arena.start
    local neighbors = {}

    for _,C in ipairs(R.conns) do
      local N = C:neighbor(R)
      if N.arena == R.arena and not N.purpose then
        table.insert(neighbors, N)
      end
    end

    if #neighbors >= 1 and rand_odds(75) then
      R = rand_element(neighbors)
    end

    -- putting weapons in the exit room is a tad silly
    if R.purpose == "EXIT" then
      return
    end

    R.weapon = weapon
    arena.weapon = weapon

    do_mark_weapon(weapon)

    gui.debugf("New weapon: %s @ %s ARENA_%d\n", weapon, R:tostr(), arena.id)
  end


  ---| Quest_add_weapons |---

  for index,A in ipairs(LEVEL.all_arenas) do
    if index == 1  then
      do_start_weapon(A)
    elseif (index == 2) or rand_odds(sel((index % 2) == 1, 80, 20)) then
      do_new_weapon(A)
    end
  end
end


function Quest_find_storage_rooms()
  -- a "storage room" is a dead-end room which does not contain
  -- anything special (keys, switches or weapons).  We place some
  -- of the ammo and health needed by the player elsewhere into
  -- these rooms to encourage exploration (i.e. to make these
  -- rooms not totally useless).

  for _,A in ipairs(LEVEL.all_arenas) do
    A.storage_rooms = {}
  end

  for _,R in ipairs(LEVEL.all_rooms) do
    if R.kind ~= "scenic" and #R.conns == 1 and
       not R.purpose and not R.weapon
    then
      R.is_storage = true
      table.insert(R.arena.storage_rooms, R)
      gui.debugf("Storage room @ %s in ARENA_%d\n", R:tostr(), R.arena.id)
    end
  end
end


function Quest_assign()

  gui.printf("\n--==| Quest_assign |==--\n\n")

  -- need at least a START room and an EXIT room
  assert(#LEVEL.all_rooms >= 2)

  -- count branches in each room
  for _,R in ipairs(LEVEL.all_rooms) do
    R.teleports = {} --!!!!

    if R.kind ~= "scenic" then
      R.num_branch = #R.conns + #R.teleports
      if R.num_branch == 0 then
        error("Room exists with no connections!")
      end
gui.debugf("%s branches:%d\n", R:tostr(), R.num_branch)
    end
  end

  local EXIT_LOCK =
  {
    kind = "EXIT",
    item = "normal",
  }

  local ARENA =
  {
    rooms = {},
    conns = shallow_copy(LEVEL.all_conns),
    lock = EXIT_LOCK,
  }

  for _,R in ipairs(LEVEL.all_rooms) do
    if R.kind ~= "scenic" then
      table.insert(ARENA.rooms, R)
    end
  end


  LEVEL.all_arenas = { ARENA }
  LEVEL.all_locks  = { EXIT_LOCK }

  Quest_decide_start_room(ARENA)

  LEVEL.start_room = LEVEL.all_arenas[1].start
  LEVEL.start_room.purpose = "START"

  LEVEL.max_keys = Quest_num_keys(#ARENA.rooms)


  Quest_initial_path(ARENA)

  for i = 1,LEVEL.max_keys do
    Quest_add_lock()
  end

  gui.printf("Total arenas: %d\n", #LEVEL.all_arenas)

  for id,A in ipairs(LEVEL.all_arenas) do
    A.id = id

    for _,R in ipairs(A.rooms) do
      R.arena = A
    end
  end

  LEVEL.exit_room = LEVEL.all_arenas[#LEVEL.all_arenas].target
  LEVEL.exit_room.purpose = "EXIT"

  gui.printf("Exit room: %s\n", LEVEL.exit_room:tostr())


  Quest_order_by_visit()
  Quest_key_distances()

  Quest_add_weapons()
  Quest_find_storage_rooms()
end

