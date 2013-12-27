----------------------------------------------------------------
--  QUEST ASSIGNMENT
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2014 Andrew Apted
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

class QUEST
{
  -- an Quest is a group of rooms, generally with a locked door
  -- to a different quest (requiring the player to find the key
  -- or switch).  There is a start room and a target room.

  rooms : array(ROOM)  -- all the rooms in this quest

  conns : array(CONN)  -- all the direct connections between rooms
                       -- in this quest.  Note that teleporters always
                       -- go between rooms in the same quest

  start : ROOM   -- room which player enters this quest
                 -- (map's start room for the very first quest)
                 -- Never nil.
                 --
                 -- start.entry_conn is the entry to this quest

  target : ROOM  -- room containing the key/switch to exit this
                 -- quest, _OR_ the level's exit room itself.
                 -- Never nil.

  lock : LOCK    -- lock info, which defines what the 'target' room
                 -- will hold (key, switch or an EXIT).  Also defines
                 -- connection to the next quest (the keyed door etc).
                 -- Never nil.
                 --
                 -- lock.conn is the connection leaving this quest.
                 --
                 -- NOTE: the room on the front side of the connection
                 --       may belong to a different quest.

  path : array(CONN)  -- full path of rooms from 'start' to 'target'
                      -- (actually only the connections are stored).
                      -- The list may be empty.

  back_path : array(CONN)
                 -- path from 'target' to the room with the connection
                 -- to the next quest.  You need to follow the full
                 -- path to know whether each connection goes forward
                 -- or backwards.  Not used for EXIT.
                 --
                 -- NOTE: some rooms may belong to other quests.
}


class LOCK
{
  kind : keyword  -- "UNSET" or "KEY" or "SWITCH" or "EXIT"
  item : string   -- what kind of key or switch (game specific)

  conn : CONN     -- connection between two rooms (and two quests)
                  -- which is locked (keyed door, lowering bars, etc)
                  -- Not used for EXITs.

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
This algorithm assumes that in each group of rooms (a QUEST)
there is a path from the start to the target room (that's the
room which holds either a key or is the EXIT room of the map).
So a locked door can be added to a room somewhere along that
path.

There are two different ways to add a lock:
   - the "ON" type simply blocks the original path.

   - the "OFF" type does not block the path itself, instead it
     locks one of the connections coming off the path.  This
     causes the existing target to change to a new room.

The room where the lock is added must be a "junction", i.e. it
must have a free branch where the player can travel along to
find the key to the locked door.

The "ON" type creates more linear progression (see door A,
find key A, see door B, find key B, etc...).  The "OFF" type
creates more memory strain (see door A, then see door B, then
see door C, finally find C key, then find key B, then key A)
and the level requires more back-tracking.

Once we have found the connection to lock, the quest is split
into two new quests: FRONT (which always contains the same
start room) and BACK.  The two types (ON vs OFF) require
different logic for splitting the quests.  After the split,
the new quests will have their own start room, target room
and path, and they might get split again in the future.


--------------------------------------------------------------]]


function Quest_quest_before_lock(LOCK)
  assert(LOCK.conn)
  return assert(LOCK.conn.src.quest)
end

function Quest_quest_after_lock(LOCK)
  if LOCK.kind == "EXIT" then
    return nil
  end

  assert(LOCK.conn)
  return assert(LOCK.conn.dest.quest)
end


function Quest_decide_start_room(quest)

  local function eval_room(R)
    local cost = R.svolume

    -- preference for leaf rooms
    cost = cost + 20 * #R.conns

    -- large amount of randomness
    cost = cost + 75 * (gui.random() ^ 0.5)

--  gui.printf("Start cost @ %s (svol:%d rconns:%d) --> %1.3f\n", R.svolume, #R.conns, cost)

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

    each C in R.conns do
      if R == C.dest and not visited[C.src] then
        swap_conn(C)
      end
      if R == C.src and not visited[C.dest] then
        natural_flow(C.dest, visited)
        C.dest.entry_conn = C
      end
    end

    each T in R.teleports do
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

  each R in quest.rooms do
    R.start_cost = eval_room(R)
    gui.debugf("%s : START COST : %1.4f\n", R:tostr(), R.start_cost)
  end

  quest.start = table.pick_best(quest.rooms, function(A,B) return A.start_cost < B.start_cost end)

  assert(#quest.start.conns > 0)

  gui.printf("Start room: %s\n", quest.start:tostr())

  -- update connections so that 'src' and 'dest' follow the natural
  -- flow of the level, i.e. player always walks src -> dest (except
  -- when backtracking).
  natural_flow(quest.start, {})
end


function Quest_update_tvols(quest)

  local function travel_volume(R, seen_conns)
    -- Determine total volume of rooms that are reachable from the
    -- given room R, including itself, but excluding connections
    -- that have been "locked" or already seen.

    local total = assert(R.svolume)

    each C in R.conns do
      if not C.lock and not seen_conns[C] then
        local N = C:neighbor(R)
        seen_conns[C] = true
        total = total + travel_volume(N, seen_conns)
      end
    end

    return total
  end


  --| Quest_update_tvols |---  

  each C in quest.conns do
    C.src_tvol  = travel_volume(C.src,  { [C]=true })
    C.dest_tvol = travel_volume(C.dest, { [C]=true })
  end
end


function Quest_initial_path(quest)

  -- TODO: preference for paths that contain many junctions
  --       [might be more significant than travel volume]

  local function select_next_room(R, path)
    local best_C
    local best_tvol = -1

    each C in R.conns do
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

  Quest_update_tvols(quest)

  quest.path = {}

  local R = assert(quest.start)

  for loop = 1,999 do
    if loop == 999 then
      error("Quest_initial_path infinite loop!")
    end

    quest.target = R

    R = select_next_room(R, quest.path)

    if not R then break; end
  end

  gui.debugf("Quest %s  start: S(%d,%d)  target: S(%d,%d)\n",
             tostring(quest), quest.start.sx1, quest.start.sy1,
             quest.target.sx1, quest.target.sy1)
end


function Quest_num_locks(num_rooms)
  local result

  local num_keys     = table.size(THEME.keys or {})
  local num_switches = table.size(THEME.switches or {})

  if STYLE.switches == "none" then
    result = 0
  elseif STYLE.switches == "heaps" then
    result = num_rooms
  elseif STYLE.switches == "few" then
    result = int(num_rooms / 14 + gui.random())
  else
    result = int(num_rooms / 7 + (gui.random() ^ 2) * 4)
  end

  -- if we have no switches, then limit is number of keys
  -- (since keys can only be used once per level)
  if num_switches == 0 then
    result = math.min(result, num_keys)
  end

  gui.printf("Number of locks: %d  (rooms:%d)\n", result, num_rooms)

  return result
end


function Quest_find_path_to_room(src, dest)
  local seen_rooms = {}

  local function recurse(R)
    if R == dest then
      return {}
    end

    if seen_rooms[R] then
      return nil
    end

    seen_rooms[R] = true

    each C in R.conns do
      local p = recurse(C:neighbor(R))
      if p then
        table.insert(p, 1, C)
        return p
      end
    end

    return nil -- no way
  end

  local path = recurse(src)

  if not path then
    gui.debugf("No path %s --> %s\n", src:tostr(), dest:tostr())
    error("Failed to find path between two rooms!")
  end

  return path
end


function Quest_decide_split(quest)  -- returns a LOCK

  local function eval_lock(C)
    --
    -- Factors to consider:
    --
    -- 1) primary factor is how well this connection breaks up the
    --    quest: a 50/50 split is the theoretical ideal, however we
    --    actually go for 66/33 split, because locked doors are
    --    better closer to the exit room than the start room
    --    [extra space near the start room can be used for weapons
    --    and other pickups].
    --
    -- 2) try to avoid Outside-->Outside connections, since we
    --    cannot use keyed doors in DOOM without creating a tall
    --    (ugly) door frame.  Worse is when there is a big height
    --    difference.

    assert(C.src_tvol and C.dest_tvol)

    local cost = math.abs(C.src_tvol - C.dest_tvol * 2)

    if C.src.outdoor and C.dest.outdoor then
      cost = cost + 40
    end

--??  -- small preference for "ON" kind
--??  if not C.on_path then
--??    cost = cost + 10
--??  end

    return cost + gui.random() * 5
  end

  local function add_lock(list, C)
    if not table.has_elem(list, C) then
      C.on_path = table.has_elem(quest.path, C)
      C.lock_cost = eval_lock(C)
      table.insert(list, C)
    end
  end

  local function locks_for_room(R, list)
    if R.is_junction then
      each C in R.conns do
        if C.src == R and C.can_lock then
          add_lock(list, C)
        end
      end
    end
  end

  local function dump_locks(list)
    each C in list do
      gui.debugf("Lock S(%d,%d) --> S(%d,%d) cost=%1.2f\n",
                 C.src.sx1,C.src.sy1, C.dest.sx1,C.dest.sy1, C.lock_cost)
    end
  end


  ---| Quest_decide_split |---

  Quest_update_tvols(quest)

  -- choose connection which will get locked
  local poss_locks = {}

  locks_for_room(quest.start, poss_locks)

  each C in quest.path do
    locks_for_room(C.dest, poss_locks)
  end
 
  -- should always have at least one possible lock, otherwise the
  -- Quest_decide_split() function should never have been called.
  assert(#poss_locks > 0)

  dump_locks(poss_locks)

  local LC = table.pick_best(poss_locks, function(X,Y) return X.lock_cost < Y.lock_cost end)
  assert(LC)

  gui.debugf("Lock conn has COST:%1.2f on_path:%s\n",
             LC.lock_cost, sel(LC.on_path, "YES", "NO"))

  local LOCK =
  {
    -- kind and item set later!
    kind = "UNSET",

    conn = LC,
    tag  = Plan_alloc_id("tag")
  }

  return LOCK
end


function Quest_split_quest(quest, LOCK)

  local function dump_quest(A, name)
    gui.debugf("%s QUEST  %s  %d+%d\n", name, tostring(A), #A.rooms, #A.conns)
    gui.debugf("{\n")

    gui.debugf("  start room  S(%d,%d)\n",  A.start.sx1, A.start.sy1)
    gui.debugf("  target room S(%d,%d)\n", A.target.sx1, A.target.sy1)
    -- NOTE: item not set yet!
    gui.debugf("  lock: %s %s\n", A.lock.kind or "????", A.lock.item or "????")

    gui.debugf("  PATH:\n")
    gui.debugf("  {\n")

    each C in A.path do
      gui.debugf("  conn  %s  (%d,%d) -> (%d,%d)\n",
                 tostring(C), C.src.sx1, C.src.sy1, C.dest.sx1, C.dest.sy1)
    end

    gui.debugf("  }\n")
    gui.debugf("}\n")
  end

  ---| Quest_split_quest |---

  dump_quest(quest, "INPUT")

  local LC = LOCK.conn

  LC.lock = LOCK

  table.insert(LEVEL.locks, LOCK)


  --- perform split ---

  gui.debugf("Splitting quest, old sizes: %d+%d", #quest.rooms, #quest.conns)

  local front_A =
  {
    rooms = {},
    conns = {},
    start = quest.start,
    lock  = LOCK,
  }

  local back_A =
  {
    rooms = {},
    conns = {},
    start = LOCK.conn.dest,
    lock  = quest.lock,
  }


  local function collect_quest(A, R)
    table.insert(A.rooms, R)

    each C in R.conns do
      if C.src == R and not C.lock then
        table.insert(A.conns, C)
        collect_quest(A, C.dest)
      end
    end
  end

  collect_quest(front_A, front_A.start)
  collect_quest(back_A,  back_A.start)


  -- FRONT STUFF --

  if LC.on_path then -- "ON" kind

    -- create second half of front path
    front_A.start = LOCK.conn.src
    
    Quest_initial_path(front_A)

    front_A.start = quest.start

    -- create the back_path
    front_A.back_path = table.copy(front_A.path)
    table.reverse(front_A.back_path)

    -- add first half of path
    local hit_lock = false
    for index,C in ipairs(quest.path) do
      if C == LOCK.conn then
        hit_lock = true ; break
      end
      table.insert(front_A.path, index, C)
    end
    assert(hit_lock)

  else  -- "OFF" kind

    -- this is easy (front path stays the same)
    front_A.target = quest.target
    front_A.path   = quest.path

    -- a bit harder : create the back_path
    front_A.back_path = {}

    local hit_lock = false
    for idx = #front_A.path, 1, -1 do
      local C = front_A.path[idx]
      table.insert(front_A.back_path, C)
      if C.src == LOCK.conn.src then
        hit_lock = true ; break
      end
    end
    assert(hit_lock)
  end


  -- BACK STUFF --

  Quest_initial_path(back_A)

  if quest.back_path then
    -- create back_path

    if LC.on_path then -- "ON" kind
      back_A.back_path = quest.back_path

    else  -- "OFF" kind
      back_A.back_path = "FIND"  -- find it later
    end
  end


  -- find oldie to replace with the newbies...
  -- [this logic ensures the 'quests' list stays in visit order]

  local old_pos
  for index,A in ipairs(LEVEL.quests) do
    if quest == A then old_pos = index ; break end
  end
  assert(old_pos)


  table.insert(LEVEL.quests, old_pos+1, front_A)
  table.insert(LEVEL.quests, old_pos+2, back_A)

  table.remove(LEVEL.quests, old_pos)

  gui.debugf("Successful split, new sizes: %d+%d | %d+%d\n",
             #front_A.rooms, #front_A.conns,
              #back_A.rooms,  #back_A.conns)

  dump_quest(front_A, "FRONT")
  dump_quest( back_A, "BACK")
end


function Quest_add_a_lock()

  local function conn_is_lockable(C)
    if C.lock then
      return false
    end

    -- Wolf3d: require two locked doors to be perpendicular
    if PARAM.one_lock_tex and #LEVEL.locks == 2 then
      local old_dir = LEVEL.locks[1].conn.dir -- FIXME !!!
      assert(old_dir and C.dir)

      if not geom.is_perpendic(old_dir, C.dir) then
        return false
      end
    end

    return true
  end

  local function room_is_junction(R)
    local has_lockable = false
    local traversable = 0

    each C in R.conns do
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

  local function eval_quest(quest)
    -- count junctions along path
    local R = quest.start
    local junctions = sel(R.is_junction, 1, 0)

    each C in quest.path do
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


  --| Quest_add_a_lock |--

  each C in LEVEL.conns do
    C.can_lock = conn_is_lockable(C)
  end

  each R in LEVEL.rooms do
    R.is_junction = room_is_junction(R)
  end

  -- choose quest to add the locked door into

  each A in LEVEL.quests do
    A.split_score = eval_quest(A)
gui.debugf("Quest %s  split_score:%1.4f\n", tostring(A), A.split_score)
  end

  local quest = table.pick_best(LEVEL.quests, function(X,Y) return X.split_score > Y.split_score end)

  if quest.split_score < 0 then
    gui.debugf("No more locks could be made!\n")
    return
  end

  local LOCK = Quest_decide_split(quest)

  Quest_split_quest(quest, LOCK)
end


function Quest_order_by_visit()
  -- put rooms in the 'all_rooms' list into the order which the
  -- player will most likely visit them.

  local visit_time = 1

  local function visit_room(R, path, p_idx)
    assert(not R.visit_time)

    R.visit_time = visit_time
    visit_time = visit_time + 1

    each C in R.conns do
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

    each C in R.conns do
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

  each A in LEVEL.quests do
    visit_room(A.start, A.path, 1)
  end

  table.sort(LEVEL.rooms, function(A,B) return A.visit_time < B.visit_time end)

  gui.debugf("Room Visit Order:\n")
  each R in LEVEL.rooms do
    gui.debugf("  %d : %s %s %s\n",
               R.visit_time, R:tostr(), R.kind, R.purpose or "-");
  end
end


function Quest_key_distances()
  -- determine distance (approx) between key and the door it opens.
  -- the biggest distances will use actual keys (which are limited)
  -- whereas everything else will use switched doors.

  gui.debugf("Key Distances:\n")

  for index,A in ipairs(LEVEL.quests) do
    if A.lock.kind == "EXIT" then
      A.lock.distance = 0
    elseif A.back_path then
      A.lock.distance = 1 + #A.back_path 
    else
      A.lock.distance = rand.irange(1,12)
    end
    gui.debugf("  Quest #%d : lock_dist %1.1f\n", index, A.lock.distance)
  end
end


function Quest_choose_keys()
  -- there is always at least one "lock" (for EXIT room)
  local locks_needed = #LEVEL.locks - 1
  if locks_needed <= 0 then return end

  local key_tab    = table.copy(THEME.keys     or {}) 
  local switch_tab = table.copy(THEME.switches or {})
  local bar_tab    = table.copy(THEME.bars     or {})

  local num_keys     = table.size(key_tab)
  local num_switches = table.size(switch_tab)
  local num_bars     = table.size(bar_tab)

  -- use less keys when number of locked doors is small
  local want_keys = num_keys

  if num_switches == 0 then
    assert(locks_needed <= num_keys)
  else
    while want_keys > 1 and (want_keys*2 > locks_needed) and rand.odds(80) do
      want_keys = want_keys - 1
    end
  end

  gui.printf("locks_needed:%d  keys:%d (of %d)  switches:%d  bars:%d\n",
              locks_needed, want_keys, num_keys, num_switches, num_bars);

  --- STEP 1 : assign keys (distance based) ---

  each LOCK in LEVEL.locks do
    -- when the distance gets large, keys are better than switches
    LOCK.key_score = LOCK.distance or 0

    -- prefer not to use keyed doors between two outdoor rooms
    if LOCK.conn and LOCK.conn.src.outdoor and LOCK.conn.dest.outdoor then
      LOCK.key_score = 0
    end

    LOCK.key_score = LOCK.key_score + gui.random() / 5.0
  end

  local lock_list = table.copy(LEVEL.locks)
  table.sort(lock_list, function(A,B) return A.key_score > B.key_score end)

  each LOCK in lock_list do
    if table.empty(key_tab) or want_keys <= 0 then
      break;
    end

    if LOCK.kind == "UNSET" then
      LOCK.kind = "KEY"
      LOCK.item = rand.key_by_probs(key_tab)

      -- cannot use this key again
      key_tab[LOCK.item] = nil

      want_keys = want_keys - 1
    end
  end

  --- STEP 2 : assign switches (random spread) ---

  each LOCK in lock_list do
    if LOCK.kind == "UNSET" then
      assert(num_switches > 0)

      LOCK.kind = "SWITCH"

      if num_bars > 0 and LOCK.conn.src.outdoor and LOCK.conn.dest.outdoor then
        LOCK.item = rand.key_by_probs(bar_tab)
        bar_tab[LOCK.item] = bar_tab[LOCK.item] / 8
      else
        LOCK.item = rand.key_by_probs(switch_tab)
        switch_tab[LOCK.item] = switch_tab[LOCK.item] / 8
      end
    end
  end

  gui.printf("all_locks =\n{\n")
  for idx,LOCK in ipairs(LEVEL.locks) do
    gui.printf("  %d = %s : %s\n", idx, LOCK.kind, LOCK.item or "NIL")
  end
  gui.printf("}\n")
end


function Quest_add_keys()

  local function make_small_exit(R)
    R.kind = "small_exit"

    local C = assert(R.conns[1])

    local S = C.src_S
    local T = C.dest_S

    local B1 = S.border[S.conn_dir]
    local B2 = T.border[T.conn_dir]

    B1.kind = "straddle"
    B2.kind = "straddle"
  end

  --| Quest_add_keys |--

  each quest in LEVEL.quests do
    local R = quest.target

    assert(quest.lock.kind ~= "UNSET")

    R.lock = quest.lock

    if quest.lock.kind == "EXIT" then
      assert(LEVEL.exit_room == R)

      if not (R.outdoor or R.natural) and
         not R:has_any_lock() and
         R.svolume < 25 and THEME.exit
      then
        make_small_exit(R)
      end

    elseif quest.lock.kind ~= "NULL" then
      R.purpose = quest.lock.kind
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

  local function do_start_weapon(quest)
    local name_tab = {}

    for name,info in pairs(GAME.WEAPONS) do
      local prob = info.start_prob

      if OB_CONFIG.strength == "crazy" then
        prob = info.add_prob
      end

      if LEVEL.allowances[name] == 0 then
        prob = 0
      end

      if prob and prob > 0 then
        name_tab[name] = prob
      end
    end -- for weapons

    if table.empty(name_tab) then
      gui.debugf("Start weapon: NONE!!\n")
      return
    end

    local weapon = rand.key_by_probs(name_tab)
    local info = GAME.WEAPONS[weapon]

    gui.debugf("Start weapon: %s\n", weapon)

    table.insert(quest.start.weapons, weapon)

    quest.start.weapon_ammo = info.ammo  -- FIXME

    do_mark_weapon(weapon)
  end

  local function do_new_weapon(quest)
    local name_tab = {}

    for name,info in pairs(GAME.WEAPONS) do
      local prob = info.add_prob

      if LEVEL.added_weapons[name] or LEVEL.allowances[name] == 0 then
        prob = 0
      end

      if prob and prob > 0 then
        name_tab[name] = info.add_prob
      end
    end

    if table.empty(name_tab) then
      gui.debugf("No weapon @ QUEST_%d\n", quest.id)
      return
    end

    local weapon = rand.key_by_probs(name_tab)
    local info = GAME.WEAPONS[weapon]

    -- Select a room to put the weapon in.
    -- This is very simplistic, either the start room of the
    -- quest or a neighboring room.
    local R = quest.start
    local neighbors = {}

    each C in R.conns do
      local N = C:neighbor(R)
      if N.quest == R.quest and not N.purpose then
        table.insert(neighbors, N)
      end
    end

    if #neighbors >= 1 and rand.odds(75) then
      R = rand.pick(neighbors)
    end

    -- putting weapons in the exit room is a tad silly
    if R.purpose == "EXIT" then
      return
    end

    table.insert(R.weapons, weapon)

    R.weapon_ammo = info.ammo  -- FIXME

    do_mark_weapon(weapon)

    gui.debugf("New weapon: %s @ %s QUEST_%d\n", weapon, R:tostr(), quest.id)
  end


  ---| Quest_add_weapons |---

  each R in LEVEL.rooms do
    R.weapons = {}
  end

  for index,A in ipairs(LEVEL.quests) do
    if index == 1  then
      do_start_weapon(A)
    elseif (index == 2) or rand.odds(sel((index % 2) == 1, 80, 20)) then
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

  each A in LEVEL.quests do
    A.storage_rooms = {}
  end

  each R in LEVEL.rooms do
    if R.kind ~= "scenic" and #R.conns == 1 and
       not R.purpose and #R.weapons == 0
    then
      R.is_storage = true
      table.insert(R.quest.storage_rooms, R)
      gui.debugf("Storage room @ %s in QUEST_%d\n", R:tostr(), R.quest.id)
    end
  end
end


function Quest_select_textures()

  if not LEVEL.outer_fence_tex then
    if THEME.outer_fences then
      LEVEL.outer_fence_tex = rand.key_by_probs(THEME.outer_fences)
    end
  end

  if not LEVEL.step_skin then
    if not THEME.steps then
      error("Theme is missing step skins") 
    else
      local name = rand.key_by_probs(THEME.steps)
      LEVEL.step_skin = assert(GAME.STEPS[name])
    end
  end

  if not LEVEL.lift_skin then
    if not THEME.lifts then
      -- OK
    else
      local name = rand.key_by_probs(THEME.lifts)
      LEVEL.lift_skin = assert(GAME.LIFTS[name])
    end
  end


  -- TODO: caves and landscapes

end


function Quest_decide_outdoors()
  local function choose(R)
    if R.parent and R.parent.outdoor then return false end
    if R.parent then return rand.odds(5) end

    if R.natural then
      if not THEME.landscape_walls then return false end
    else
      if not THEME.courtyard_floors then return false end
    end

    if STYLE.outdoors == "none"   then return false end
    if STYLE.outdoors == "always" then return true end

    if R.natural then
      if STYLE.outdoors == "heaps" then return rand.odds(75) end
      return rand.odds(25)
    end

    -- we would prefer KEY locked doors to touch at least one
    -- indoor room.  However keys/switches are not decided yet,
    -- so the following is a compromise solution.
    if R:has_any_lock() and rand.odds(20) then return false end

    if R.children then
      if STYLE.outdoors == "few" then
        return rand.odds(33)
      else
        return rand.odds(80)
      end
    end

    if STYLE.outdoors == "heaps" then return rand.odds(50) end
    if STYLE.outdoors == "few"   then return rand.odds(5) end

    -- room on edge of map?
    if R.touches_edge then
      return rand.odds(30)
    end

    return rand.odds(10)
  end

  ---| Quest_decide_outdoors |---

  each R in LEVEL.rooms do
    if R.outdoor == nil then
      R.outdoor = choose(R)
    end
    if R.outdoor then
      R.sky_h = SKY_H
    end
  end
end


function Quest_create_zones()
  --
  -- NOTE: temp rubbish to get the 5.10 monster code working
  --

  local function new_zone()
    local Z = 
    {
      id = 1 + #LEVEL.zones
      rooms = {}
      themes = {}
      previous = {}
      rare_used = {}
    }
    table.insert(LEVEL.zones, Z)
    Z.tostr = function(Z) return "ZONE_" .. Z.id end
    return Z
  end

  local function dump_zones()
    gui.printf("Zone list:\n")

    each Z in LEVEL.zones do
      gui.printf("  %d: vol:%3.1f rooms:%d head:%s\n", Z.id,
                 Z.volume or 0, #Z.rooms,
                 (Z.rooms[1] and ("ROOM_" .. Z.rooms[1].id)) or "NIL")
    end
  end


  ---| Quest_create_zones |---

  LEVEL.zones = {}

  local zone

  each quest in LEVEL.quests do
    if not zone or #zone.rooms > 8 then
      zone = new_zone()
    end

    quest.zone = zone

    each R in quest.rooms do
      R.zone = zone
      table.insert(zone.rooms, R)
    end
  end

  dump_zones()
end


function Quest_assign_room_themes()
 
  -- figure out how many room themes to use for each kind of room.
  -- table keys are room kinds ("building" etc) and value is number of
  -- themes per ZONE, where zero means the whole level.
  local EXTENT_TAB = {}

  local function total_of_room_kind(kind)
    local total = 0

      each R in LEVEL.rooms do
        if R.kind == kind or
           (kind == "hallway" and R.kind == "stairwell")
        then
          total = total + R.svolume
        end
      end

    return total
  end


  local function extent_for_room_kind(kind, A, B)
    local qty = total_of_room_kind(kind)

    -- rough calculation of room area per zone
    qty = qty / #LEVEL.zones

    A = A * 5
    B = B * 5

        if qty < A then EXTENT_TAB[kind] = 0
    elseif qty < B then EXTENT_TAB[kind] = 1
    else                EXTENT_TAB[kind] = 2
    end

    gui.debugf("EXTENT_TAB[%s] --> %d (qty:%1.1f)\n", kind, EXTENT_TAB[kind], qty)
  end


  local function determine_extents()
    extent_for_room_kind("building", 3, 8)
    extent_for_room_kind("cave",     3, 8)
    extent_for_room_kind("outdoor",  3, 12)
    extent_for_room_kind("hallway",  3, 20)
  end


  local function dump_dominant_themes()
    gui.debugf("Dominant themes:\n")

    each Z in LEVEL.zones do
      gui.debugf("@ %s:\n", Z:tostr())

      each kind,extent in EXTENT_TAB do
        local line = ""

        each name in Z.themes[kind] do
          line = line .. " " .. name
        end

        gui.debugf("   %s : {%s }\n", kind, line)
      end
    end
  end


  local function dominant_themes_for_kind(kind, extent)
    if THEME.max_dominant_themes then
      extent = math.min(extent, THEME.max_dominant_themes)
    end

    -- figure out which table to use
    local tab_name = kind .. "s"
    local tab = THEME[tab_name]

    if not tab and kind == "hallway" then
      tab = THEME["buildings"]
    end

    if not tab then
      error("Theme is missing " .. tab_name .. " choices")
    end

    -- copy the table, so we can modify probabilities
    local old_tab = tab ; tab = table.copy(tab)

    -- remove the rare rooms
    each name,prob in old_tab do
      local rt = GAME.ROOM_THEMES[name]
      if rt and rt.rarity then tab[name] = nil end
    end

    assert(not table.empty(tab))

    local global_theme

    if extent == 0 then
      global_theme = rand.key_by_probs(tab)
    end

    each Z in LEVEL.zones do
      Z.themes[kind] = {}
      Z.previous[kind] = {}

      if global_theme then
        table.insert(Z.themes[kind], global_theme)
        continue
      end

      for loop = 1, extent do
        local name = rand.key_by_probs(tab)
        -- try not to re-use the same theme again
        tab[name] = tab[name] / 20

        table.insert(Z.themes[kind], name)
      end
    end
  end


  local function pick_rare_room(R)
    do return nil end  -- FIXME

    local tab_name = R.kind .. "s"
    local tab_orig = THEME[tab_name]

    if not tab_orig then return nil end

    local tab = table.copy(tab_orig)

    -- remove non-rare themes and already used themes
    each name,prob in tab_orig do
      local rt = assert(GAME.ROOM_THEMES[name])

      if not rt.rarity or
         (rt.rarity == "zone"  and R.zone.rare_used[name]) or
         (rt.rarity == "level" and  LEVEL.rare_used[name]) or
         (rt.rarity == "episode" and EPISODE.rare_used[name])
      then
        tab[name] = nil
      end
    end

    -- nothing is possible?
    if table.empty(tab) then
      return nil
    end

    return rand.key_by_probs(tab)
  end


  local function assign_room_theme(R, try_rare)
    local kind = R.kind
    if kind == "stairwell" then kind = "hallway" end

    local theme_list = R.zone.themes[kind]
    local  prev_list = R.zone.previous[kind]

    assert(theme_list)
    assert( prev_list)

    local theme_name

    if try_rare then
      theme_name = pick_rare_room(R)
    end

    if not theme_name and #theme_list == 1 then
      theme_name = theme_list[1]
    end

    if not theme_name then
      local prev_count = 0

      if prev_list[1] then prev_count = 1 end
      if prev_list[2] and prev_list[2] == prev_list[1] then prev_count = 2 end
      if prev_list[3] and prev_list[3] == prev_list[1] then prev_count = 3 end

      -- logic to re-use a previous theme
      if (prev_count == 1 and rand.odds(80)) or
         (prev_count == 2 and rand.odds(50)) or
         (prev_count == 3 and rand.odds(20))
      then
        theme_name = prev_list[1]
      else
        -- use a new one
        theme_name = theme_list[1]

        -- rotate the theme list
        table.insert(theme_list, table.remove(theme_list, 1))
      end
    end

    R.theme = GAME.ROOM_THEMES[theme_name]

    if not R.theme then
      error("No such room theme: " .. tostring(theme_name))
    end

    gui.printf("Room theme for %s : %s\n", R:tostr(), theme_name)

    if not R.theme.rarity then
      table.insert(prev_list, 1, theme_name)
    elseif R.theme.rarity == "minor" then
      -- do nothing
    elseif R.theme.rarity == "zone" then
      R.zone.rare_used[theme_name] = 1
    elseif R.theme.rarity == "level" then
      LEVEL.rare_used[theme_name] = 1
    elseif R.theme.rarity == "episode" then
      EPISODE.rare_used[theme_name] = 1
    end
  end


  local function assign_hall_theme(H)
    local conn_rooms = {}

    each C in H.conns do
      local R = C:neighbor(H)

      if R.kind == "building" then  -- TODO: caves
        table.insert(conn_rooms, R)
      end
    end

    -- mini-halls just use the theme of the connected room
    -- (unless between two outdoor rooms)
    -- FIXME!!!! a way to FORCE this for larger halls
    if #H.sections == 1 and #conn_rooms > 0 then
      H.theme = conn_rooms[1].theme
      return
    end

    -- see if any room themes specify hallways
    -- (TODO: consider if this list needs sorting, e.g. by visit_id)
    local theme_name = H.zone.themes["hallway"][1]

    each R in conn_rooms do
      if R.theme.hallways then
        theme_name = rand.key_by_probs(R.theme.hallways)
      end
    end

    assert(theme_name)

    H.theme = GAME.ROOM_THEMES[theme_name]

    if not H.theme then
      error("No such room theme: " .. tostring(theme_name))
    end
  end


  local function facade_from_room_themes(r_theme1, r_theme2, seen)
    -- the first room theme must be valid, the second one is optional
    assert(r_theme1)

    r_theme1 = assert(GAME.ROOM_THEMES[r_theme1])

    local facades1 = r_theme1.facades or THEME.facades or
                     r_theme1.walls   or THEME.walls
    assert(facades1)

    local tab = table.copy(facades1)

    if r_theme2 then
      r_theme2 = assert(GAME.ROOM_THEMES[r_theme2])

      local facades2 = r_theme2.facades or THEME.facades or
                       r_theme2.walls   or THEME.walls
      assert(facades2)

      -- merge the two together, giving priority to the first theme
      -- Note: it does not matter if facades1 == facades2
      table.merge_missing(tab, facades2)
    end

    -- prefer not to use the same facade material again
    each name in seen do
      if tab[name] then
        tab[name] = tab[name] / 10
      end
    end

    local mat = rand.key_by_probs(tab)

    seen[mat] = 1

    return mat
  end


  local function pictures_for_zones()
    each Z in LEVEL.zones do
      Z.logo_name = "BLAH" ---##  rand.key_by_probs(THEME.logos)
      Z.fake_windows = rand.odds(25)
    end

    if not THEME.pictures or STYLE.pictures == "none" then
      return
    end

    each Z in LEVEL.zones do
      Z.pictures = {}
    end

    --- distribute the pictures amongst the zones ---

    local names = table.keys(THEME.pictures)

    assert(#names >= 1)

    -- ensure there are enough pictures to go round
    while table.size(names) < #LEVEL.zones do
      names = table.append(names, table.copy(names))
    end

    rand.shuffle(names)

    each Z in LEVEL.zones do
      local name = table.remove(names, 1)
      Z.pictures[name] = THEME.pictures[name]
    end

    -- one extra picture per zone (unless already there)
    names = table.keys(THEME.pictures)

    each Z in LEVEL.zones do
      local name = rand.pick(names)

      Z.pictures[name] = THEME.pictures[name] / 4
    end

    -- [[ debugging
    gui.debugf("Pictures for zones:\n")
    each Z in LEVEL.zones do
      gui.debugf("%s =\n%s\n", Z:tostr(), table.tostr(Z.pictures))
    end
    --]]
  end


  local function select_facades_for_zones()
    local seen = {}

    each Z in LEVEL.zones do
      local r_theme1 = Z.themes["building"][1]
      local r_theme2 = Z.themes["building"][2]  -- may be NIL

      Z.facade_mat = facade_from_room_themes(r_theme1, r_theme2, seen)

      assert(Z.facade_mat)

      gui.printf("Facade for %s : %s\n", Z:tostr(), Z.facade_mat)
    end
  end


  ---| Quest_assign_room_themes |---

  LEVEL.rare_used = {}

  if not EPISODE.rare_used then EPISODE.rare_used = {} end

  if THEME.facades then
    LEVEL.global_facades = table.copy(THEME.facades)
  end

  determine_extents()

  each kind,extent in EXTENT_TAB do
    dominant_themes_for_kind(kind, extent)
  end

  dump_dominant_themes()

  each R in LEVEL.rooms do
    local rare_ok = (_index % 2 == 0) and rand.odds(THEME.rare_prob or 30)

    if R.kind == "hallway" then
      assign_hall_theme(R)
    else
      assign_room_theme(R, rare_ok)
    end
  end

  select_facades_for_zones()

  pictures_for_zones()

  -- verify each room and hallway got a theme
  each R in LEVEL.rooms do assert(R.theme) end
end


function Quest_setup_lev_alongs()
  local w_along = LEVEL.mon_along or 0.5

  each R in LEVEL.rooms do
    R.lev_along  = _index / #LEVEL.rooms

    local w_step = (R.svolume ^ 0.5) / ((SEED_W * SEED_H) ^ 0.5)
 
    R.weap_along = w_along + w_step / 3
    R.weap_along = R.weap_along * (PARAM.weapon_factor or 1)

--stderrf("WEAPON ALONG : %1.2f\n", R.weap_along)

    w_along = w_along + w_step * rand.range(0.5, 0.8)
  end
end


function Quest_assign_quests()

  gui.printf("\n--==| Assign Quests |==--\n\n")

  Monsters_max_level()

  -- need at least a START room and an EXIT room
  if #LEVEL.rooms < 2 then
    error("Level only has one room! (2 or more are needed)")
  end

  local LOCK =
  {
    kind = "EXIT",
    item = "normal",
  }

  local QUEST =
  {
    rooms = table.copy(LEVEL.rooms),
    conns = table.copy(LEVEL.conns),
    lock = LOCK,
  }


  LEVEL.quests = { QUEST }
  LEVEL.locks  = { LOCK  }

  Quest_decide_start_room(QUEST)

  LEVEL.start_room = QUEST.start
  LEVEL.start_room.purpose = "START"


  Quest_initial_path(QUEST)

  local want_lock = Quest_num_locks(#QUEST.rooms)

  for i = 1,want_lock do
    Quest_add_a_lock()
  end

  gui.printf("Quest count: %d\n", #LEVEL.quests)

  for index,A in ipairs(LEVEL.quests) do
    A.id = index

    each R in A.rooms do
      R.quest = A
    end

    if A.back_path == "FIND" then
      A.back_path = Quest_find_path_to_room(A.target, A.lock.conn.src)
    end
  end


  LEVEL.exit_room = LEVEL.quests[#LEVEL.quests].target
  LEVEL.exit_room.purpose = "EXIT"

  gui.printf("Exit room: %s\n", LEVEL.exit_room:tostr())


  Quest_order_by_visit()
  Quest_create_zones()
  Quest_setup_lev_alongs()
  Quest_key_distances()

  Quest_add_weapons()
  Quest_find_storage_rooms()

  Quest_decide_outdoors()
  Quest_assign_room_themes()
  Quest_select_textures()

  Quest_choose_keys()
  Quest_add_keys()
end

