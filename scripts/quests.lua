----------------------------------------------------------------
--  QUEST ASSIGNMENT
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2010 Andrew Apted
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

  start : ROOM   -- room which player enters this arena
                 -- (map's start room for the very first arena)
                 -- Never nil.
                 --
                 -- start.entry_conn is the entry to this arena

  target : ROOM  -- room containing the key/switch to exit this
                 -- arena, _OR_ the level's exit room itself.
                 -- Never nil.

  lock : LOCK    -- lock info, which defines what the 'target' room
                 -- will hold (key, switch or an EXIT).  Also defines
                 -- connection to the next arena (the keyed door etc).
                 -- Never nil.
                 --
                 -- lock.conn is the connection leaving this arena.
                 --
                 -- NOTE: the room on the front side of the connection
                 --       may belong to a different arena.

  path : array(CONN)  -- full path of rooms from 'start' to 'target'
                      -- (actually only the connections are stored).
                      -- The list may be empty.

  back_path : array(CONN)
                 -- path from 'target' to the room with the connection
                 -- to the next arena.  You need to follow the full
                 -- path to know whether each connection goes forward
                 -- or backwards.  Not used for EXIT.
                 --
                 -- NOTE: some rooms may belong to other arenas.
}


class LOCK
{
  kind : keyword  -- "UNSET" or "KEY" or "SWITCH" or "EXIT"
  item : string   -- what kind of key or switch (game specific)

  conn : CONN     -- connection between two rooms (and two arenas)
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
This algorithm assumes that in each group of rooms (an ARENA)
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

Once we have found the connection to lock, the arena is split
into two new arenas: FRONT (which always contains the same
start room) and BACK.  The two types (ON vs OFF) require
different logic for splitting the arenas.  After the split,
the new arenas will have their own start room, target room
and path, and they might get split again in the future.


--------------------------------------------------------------]]

require 'defs'
require 'util'

Quest = { }



function Quest.update_tvols(arena)

  local function travel_volume(R, seen_conns)
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


  --| Quest.update_tvols |---  

  for _,C in ipairs(arena.conns) do
    C.src_tvol  = travel_volume(C.src,  { [C]=true })
    C.dest_tvol = travel_volume(C.dest, { [C]=true })
  end
end



function OLD_Quest_num_locks(num_rooms)
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


function Quest.find_path_to_room(src, dest)
  local seen_rooms = {}

  local function recurse(R)
    if R == dest then
      return {}
    end

    if seen_rooms[R] then
      return nil
    end

    seen_rooms[R] = true

    for _,C in ipairs(R.conns) do
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



function Quest.key_distances()
  -- determine distance (approx) between key and the door it opens.
  -- the biggest distances will use actual keys (which are limited)
  -- whereas everything else will use switched doors.

  gui.debugf("Key Distances:\n")

  for index,A in ipairs(LEVEL.all_arenas) do
    if A.lock.kind == "EXIT" then
      A.lock.distance = 0
    elseif A.back_path then
      A.lock.distance = 1 + #A.back_path 
    else
      A.lock.distance = rand.irange(1,12)
    end
    gui.debugf("  Arena #%d : lock_dist %1.1f\n", index, A.lock.distance)
  end
end


function Quest.choose_keys()
  -- there is always at least one "lock" (for EXIT room)
  local locks_needed = #LEVEL.all_locks - 1
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

  for _,LOCK in ipairs(LEVEL.all_locks) do
    -- when the distance gets large, keys are better than switches
    LOCK.key_score = LOCK.distance or 0

    -- prefer not to use keyed doors between two outdoor rooms
    if LOCK.conn and LOCK.conn.src.outdoor and LOCK.conn.dest.outdoor then
      LOCK.key_score = 0
    end

    LOCK.key_score = LOCK.key_score + gui.random() / 5.0
  end

  local lock_list = table.copy(LEVEL.all_locks)
  table.sort(lock_list, function(A,B) return A.key_score > B.key_score end)

  for _,LOCK in ipairs(lock_list) do
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

  for _,LOCK in ipairs(lock_list) do
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
  for idx,LOCK in ipairs(LEVEL.all_locks) do
    gui.printf("  %d = %s : %s\n", idx, LOCK.kind, LOCK.item or "NIL")
  end
  gui.printf("}\n")
end


function Quest.add_keys()

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

  --| Quest.add_keys |--

  for _,arena in ipairs(LEVEL.all_arenas) do
    local R = arena.target

    assert(arena.lock.kind ~= "UNSET")

    R.lock = arena.lock

    if arena.lock.kind == "EXIT" then
      assert(LEVEL.exit_room == R)

      if not (R.outdoor or R.natural) and
         not R:has_any_lock() and
         R.svolume < 25 and THEME.exit
      then
        make_small_exit(R)
      end

    elseif arena.lock.kind ~= "NULL" then
      R.purpose = arena.lock.kind
    end
  end
end


function Quest.add_weapons()
 
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

    arena.weapon = weapon

    arena.start.weapon = weapon
    arena.start.weapon_ammo = info.ammo

    do_mark_weapon(weapon)
  end

  local function do_new_weapon(arena)
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
      gui.debugf("No weapon @ ARENA_%d\n", arena.id)
      return
    end

    local weapon = rand.key_by_probs(name_tab)
    local info = GAME.WEAPONS[weapon]

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

    if #neighbors >= 1 and rand.odds(75) then
      R = rand.pick(neighbors)
    end

    -- putting weapons in the exit room is a tad silly
    if R.purpose == "EXIT" then
      return
    end

    arena.weapon = weapon

    R.weapon = weapon
    R.weapon_ammo = info.ammo

    do_mark_weapon(weapon)

    gui.debugf("New weapon: %s @ %s ARENA_%d\n", weapon, R:tostr(), arena.id)
  end


  ---| Quest.add_weapons |---

  for index,A in ipairs(LEVEL.all_arenas) do
    if index == 1  then
      do_start_weapon(A)
    elseif (index == 2) or rand.odds(sel((index % 2) == 1, 80, 20)) then
      do_new_weapon(A)
    end
  end
end


function Quest.find_storage_rooms()
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


function Quest.select_textures()
  if not LEVEL.building_facades then
    LEVEL.building_facades = {}

    for num = 1,2 do
      local name = rand.key_by_probs(THEME.building_facades or THEME.building_walls)
      LEVEL.building_facades[num] = name
    end
  end

  if not LEVEL.building_walls then
    LEVEL.building_walls = {}

    for num = 1,3 do
      local name = rand.key_by_probs(THEME.building_walls)
      LEVEL.building_walls[num] = name
    end
  end

  if not LEVEL.courtyard_floors then
    LEVEL.courtyard_floors = {}

    if not THEME.courtyard_floors then
      LEVEL.courtyard_floors[1] = rand.key_by_probs(THEME.building_floors)
    else
      for num = 1,2 do
        local name = rand.key_by_probs(THEME.courtyard_floors)
        LEVEL.courtyard_floors[num] = name
      end
    end
  end

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

  gui.printf("Selected room textures:\n")

  gui.printf("building_facades =\n%s\n\n", table.tostr(LEVEL.building_facades))
  gui.printf("building_walls =\n%s\n\n",   table.tostr(LEVEL.building_walls))
  gui.printf("courtyard_floors =\n%s\n\n", table.tostr(LEVEL.courtyard_floors))
end


function OLD_Quest_assign_quests()

  gui.printf("\n--==| Assign Quests |==--\n\n")

  -- need at least a START room and an EXIT room
  if #LEVEL.all_rooms < 2 then
    error("Level only has one room! (2 or more are needed)")
  end

  local LOCK =
  {
    kind = "EXIT",
    item = "normal",
  }

  local ARENA =
  {
    rooms = table.copy(LEVEL.all_rooms),
    conns = table.copy(LEVEL.all_conns),
    lock = LOCK,
    start = LEVEL.start_room,
  }


  LEVEL.all_arenas = { ARENA }
  LEVEL.all_locks  = { LOCK  }


  Quest.initial_path(ARENA)

  local want_lock = Quest.num_locks(#ARENA.rooms)

  for i = 1,want_lock do
    Quest.add_a_lock()
  end

  gui.printf("Arena count: %d\n", #LEVEL.all_arenas)

  for index,A in ipairs(LEVEL.all_arenas) do
    A.id = index

    for _,R in ipairs(A.rooms) do
      R.arena = A
    end

    if A.back_path == "FIND" then
      A.back_path = Quest.find_path_to_room(A.target, A.lock.conn.src)
    end
  end


  LEVEL.exit_room = LEVEL.all_arenas[#LEVEL.all_arenas].target
  LEVEL.exit_room.purpose = "EXIT"

  gui.printf("Exit room: %s\n", LEVEL.exit_room:tostr())


  Quest.order_by_visit()
  Quest.key_distances()

  Quest.add_weapons()
  Quest.find_storage_rooms()

  Quest.select_textures()
---###  Quest.decide_outdoors()

  Quest.choose_keys()
  Quest.add_keys()
end


function Quest_make_quests()

  -- ALGORITHM NOTES:
  --
  -- The main idea in this algorithm is that you LOCK all but one exits
  -- in each room, and continue down the free exit.  Each lock is added
  -- to an active list.  When you hit a leaf room, pick a lock from the
  -- active list (removing it) and mark the room as having its key.
  -- Then the algorithm continues on the other side of the locked door
  -- (creating a new quest for those rooms).
  -- 

  local active_locks = {}

  local function new_quest(R)
    local QUEST = { start = R }

    table.insert(LEVEL.all_quests, QUEST)

    QUEST.id = #LEVEL.all_quests

    return QUEST
  end


  local function get_exits(R)
    local exits = {}

    for _,C in ipairs(R.conns) do
      if C.R1 == R then
        table.insert(exits, C)
      end
    end

    return exits
  end


  local function add_lock(C)
    local LOCK =
    {
      conn = C,
    }

    C.lock = LOCK

    table.insert(active_locks, LOCK)
    table.insert(LEVEL.all_locks, LOCK)
  end


  local function add_key(R)
    if table.empty(active_locks) then
      LEVEL.exit_room = R
      R.purpose = "EXIT"
      return false
    end

    -- FIXME: need heuristics for picking the lock
    --        (e.g. using newest one gives less back-tracking)
    rand.shuffle(active_locks)

    local lock = table.remove(active_locks, 1)

    R.purpose = "KEY"
    R.purpose_lock = lock

    lock.key_room = R

    return lock
  end


  local function visit_room(R, quest)
    while true do
      R.quest = quest

      table.insert(LEVEL.all_rooms, R)

      local exits = get_exits(R)

      if #exits == 0 then
        -- hit a leaf room
        quest.target = R

        local lock = add_key(R)

        if not lock then
          return  -- FINISHED
        end

        -- create new quest and continue
        R = lock.conn.R2
        quest = new_quest(R)

      else

        -- FIXME !!! score them, pick best
        local free_idx = rand.irange(1, #exits)

        -- lock up any excess branches
        for idx = 1,#exits do
          local C = exits[idx]

          if idx ~= free_idx then
-- stderrf("   Locking conn to room %s\n", C.R2:tostr())
            add_lock(C)
          end
        end

        -- continue down the free exit
        R = exits[free_idx].R2
      end
    end -- while
  end


  --==| Quest_make_quests |==--

  LEVEL.all_quests = {}
  LEVEL.all_locks  = {}

  -- the room list will be rebuilt in visit order
  LEVEL.all_rooms = {}

  local QUEST = new_quest(LEVEL.start_room)

  visit_room(QUEST.start, QUEST)

  assert(LEVEL.exit_room)

  gui.debugf("Room Visit Order:\n")
  for _,R in ipairs(LEVEL.all_rooms) do
    gui.debugf("%s : quest %d : purpose %s\n", R:tostr(), R.quest.id, R.purpose or "-")
  end
end

