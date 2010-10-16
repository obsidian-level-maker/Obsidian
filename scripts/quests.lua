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

class QUEST
{
  -- a quest is a group of rooms with a particular goal, usually
  -- a key or switch which allows progression to the next quest.
  -- The final quest always leads to a room with an exit switch.

  start : ROOM   -- room which player enters this quest.
                 -- for first quest, this is the map's starting room.
                 -- Never nil.
                 --
                 -- start.entry_conn is the entry to this arena

  target : ROOM  -- room containing the goal of this quest (key or switch).
                 -- the room object will contain more information.
                 -- Never nil.
}


class LOCK
{
  kind : keyword  -- "KEY" or "SWITCH"
  item : string   -- what kind of key or switch (game specific)

  target : ROOM   -- the room containing the key or switch
  conn   : CONN   -- the connection which is locked

  distance : number  -- number of rooms between key and door

  tag : number    -- tag number to use for a switched door
}


--------------------------------------------------------------]]

require 'defs'
require 'util'


QUEST_CLASS = {}

function QUEST_CLASS.new(start)
  local id = 1 + #LEVEL.all_quests
  local QT = { id=id, start=start }
  table.set_class(QT, QUEST_CLASS)
  table.insert(LEVEL.all_quests, QT)
  return QT
end

function QUEST_CLASS.tostr(self)
  return string.format("QUEST_%d", self.id)
end



function Quest_update_tvols(arena)  -- NOT USED ATM

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


  --| Quest_update_tvols |---  

  for _,C in ipairs(arena.conns) do
    C.src_tvol  = travel_volume(C.src,  { [C]=true })
    C.dest_tvol = travel_volume(C.dest, { [C]=true })
  end
end



function Quest_num_locks(num_rooms)  -- NOT USED ATM
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


function Quest_find_path_to_room(src, dest)  -- NOT USED ATM
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



function Quest_key_distances()
  -- determine distance (approx) between key and the door it opens.
  -- the biggest distances will use actual keys (which are limited)
  -- whereas everything else will use switched doors.

  -- TODO: proper measurement between connections

  local want_lock

  local function dist_to_door(R, entry_C, seen_rooms)
    seen_rooms[R] = true

    if R:has_lock(want_lock) then
      return 1
    end

    for _,C in ipairs(R.conns) do
      local R2 = C:neighbor(R)
      if not seen_rooms[R2] then
        local d = dist_to_door(R2, C, seen_rooms)
        if d then
          return d + 1
        end
      end
    end

    -- not in this part of the connection map
    return nil
  end

  gui.debugf("Key Distances:\n")

  for _,lock in ipairs(LEVEL.all_locks) do
    want_lock = lock

    lock.distance = dist_to_door(lock.target, nil, {})

    gui.debugf("  %s --> %s  lock_dist:%1.1f\n",
        lock.conn.R1.quest:tostr(), lock.conn.R2.quest:tostr(),
        lock.distance)
  end 
end


function Quest_choose_keys()
  local locks_needed = #LEVEL.all_locks

  if locks_needed <= 0 then return end

  local key_probs    = table.copy(THEME.keys     or {}) 
  local switch_probs = table.copy(THEME.switches or {})
  local bar_probs    = table.copy(THEME.bars     or {})

  local num_keys     = table.size(key_probs)
  local num_switches = table.size(switch_probs)
  local num_bars     = table.size(bar_probs)

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

  local lock_list = table.copy(LEVEL.all_locks)

  for _,LOCK in ipairs(lock_list) do
    -- when the distance gets large, keys are better than switches
    LOCK.key_score = LOCK.distance or 0

    -- prefer not to use keyed doors between two outdoor rooms
    if LOCK.conn and LOCK.conn.R1.outdoor and LOCK.conn.R2.outdoor then
      LOCK.key_score = LOCK.key_score / 2
    end

    LOCK.key_score = LOCK.key_score + gui.random() / 1.5
  end

  table.sort(lock_list, function(A,B) return A.key_score > B.key_score end)

  for _,LOCK in ipairs(lock_list) do
    if table.empty(key_probs) or want_keys <= 0 then
      break;
    end

    if not LOCK.kind then
      LOCK.kind = "KEY"
      LOCK.item = rand.key_by_probs(key_probs)

      -- cannot use this key again
      key_probs[LOCK.item] = nil

      want_keys = want_keys - 1
    end
  end


  --- STEP 2 : assign switches (random spread) ---

  for _,LOCK in ipairs(lock_list) do
    if not LOCK.kind then
      assert(num_switches > 0)

      -- FIXME: redo bars
      if false and num_bars > 0 and LOCK.conn.R1.outdoor and LOCK.conn.R2.outdoor then
        LOCK.kind = "BARS"
        LOCK.item = rand.key_by_probs(bar_probs)
        bar_probs[LOCK.item] = bar_probs[LOCK.item] / 8
      else
        LOCK.kind = "SWITCH"
        LOCK.item = rand.key_by_probs(switch_probs)
        switch_probs[LOCK.item] = switch_probs[LOCK.item] / 8
      end

      LOCK.tag  = Plan_alloc_tag()
    end
  end

  gui.printf("all_locks =\n{\n")
  for idx,LOCK in ipairs(LEVEL.all_locks) do
    gui.printf("  %d = %s : %s\n", idx, LOCK.kind, LOCK.item or "NIL")
  end
  gui.printf("}\n")
end



function Quest_add_weapons()
 
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

    quest.weapon = weapon

    quest.start.weapon = weapon
    quest.start.weapon_ammo = info.ammo

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

    for _,C in ipairs(R.conns) do
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

    quest.weapon = weapon

    R.weapon = weapon
    R.weapon_ammo = info.ammo

    do_mark_weapon(weapon)

    gui.debugf("New weapon: %s @ %s QUEST_%d\n", weapon, R:tostr(), quest.id)
  end


  ---| Quest_add_weapons |---

  LEVEL.added_weapons = {}

  for index,Q in ipairs(LEVEL.all_quests) do
    if index == 1  then
      do_start_weapon(Q)
    elseif (index == 2) or rand.odds(sel((index % 2) == 1, 80, 20)) then
      do_new_weapon(Q)
    end
  end
end


function Quest_find_storage_rooms()  -- NOT USED ATM

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


function Quest_select_textures()
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
      gui.printf("WARNING: Theme is missing step skins\n") 
      LEVEL.step_skin = {}
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


function Quest_make_quests()

  -- ALGORITHM NOTES:
  --
  -- A fundamental requirement of a locked door is that the player
  -- needs to reach the door _before_ he/she reaches the key.  Then
  -- the player knows what they are looking for.  Without this, the
  -- player can just stumble on the key before finding the door and
  -- says to themselves "what the hell is this key for ???".
  --
  -- The main idea in this algorithm is that you LOCK all but one exits
  -- in each room, and continue down the free exit.  Each lock is added
  -- to an active list.  When you hit a leaf room, pick a lock from the
  -- active list (removing it) and mark the room as having its key.
  -- Then the algorithm continues on the other side of the locked door
  -- (creating a new quest for those rooms).
  -- 

  local active_locks = {}


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
    local LOCK = { conn=C }

    C.lock = LOCK

    -- keep newest locks at the front of the active list
    table.insert(active_locks, 1, LOCK)

    table.insert(LEVEL.all_locks, LOCK)
  end


  local function pick_lock_to_solve()
    --
    -- choosing the newest lock (at index 1) produces the most linear
    -- progression, which is easiest on the player.  Choosing older
    -- locks produces more back-tracking and memory strain, which on
    -- large levels can make it very confusing to navigate.
    --

    assert(#active_locks > 0)

    if PERVERSE_MODE then  -- TODO
      return #active_locks
    end

    local index = 1

    while (index+1) <= #active_locks and rand.odds(30) do
      index = index + 1
    end

    return index
  end


  local function add_goal(R)
    if table.empty(active_locks) then
      LEVEL.exit_room = R
      R.purpose = "EXIT"
      return false
    end

    local lock_idx = pick_lock_to_solve()

-- stderrf("ADDING GOAL : %d / %d\n", lock_idx, table.size(active_locks))

    local lock = table.remove(active_locks, lock_idx)

    R.purpose = "SOLUTION"
    R.purpose_lock = lock

    lock.target = R

    return lock
  end


  local function pick_free_exit(R, exits)
    if #exits == 1 then return 1 end

    -- teleporters cannot be locked, hence must pick it when present
    for idx,C in ipairs(exits) do
      if C.kind == "teleporter" then
        return idx
      end
    end

    local scores = {}

    local entry_kx = R.kx1
    local entry_ky = R.ky1

    if R.entry_conn then
      entry_kx = R.entry_conn.K2.kx
      entry_ky = R.entry_conn.K2.ky
    end

    for idx,C in ipairs(exits) do
      -- TODO: better distance calc
      scores[idx] = geom.dist(entry_kx, entry_ky, C.K2.kx, C.K2.ky)

      if R.entry_conn and R.entry_conn.dir and C.dir ~= (10 - R.entry_conn.dir) then
        -- strong preference to avoid 180 degree turns
        scores[idx] = scores[idx] + 4
      end

      -- tie breaker
      scores[idx] = scores[idx] + gui.random() / 3
    end

    local value,index = table.pick_best(scores)
    assert(value)

-- stderrf("scores = { %1.2f %1.2f %1.2f %1.2f } --> %d\n",
--         scores[1] or 0, scores[2] or 0,
--         scores[3] or 0, scores[4] or 0, index)
    return index
  end


  local function visit_room(R, quest)
    while true do
      R.quest = quest

      table.insert(LEVEL.all_rooms, R)

      local exits = get_exits(R)

      if #exits == 0 then
        -- hit a leaf room
        quest.target = R

        local lock = add_goal(R)

        -- finished?
        if not lock then return end

        -- create new quest and continue
        R = lock.conn.R2
        quest = QUEST_CLASS.new(R)

      else

        local free_idx = pick_free_exit(R, exits)

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


  local function no_quest_order(start, quest)
    for _,R in ipairs(LEVEL.all_rooms) do
      R.quest = quest
    
      if not LEVEL.exit_room and R ~= start and #R.conns <= 1 then
        LEVEL.exit_room = R
        R.purpose = "EXIT"
      end
    end
  end


  --==| Quest_make_quests |==--

  gui.printf("\n--==| Make Quests |==--\n\n")

  -- need at least a START room and an EXIT room
  if #LEVEL.all_rooms < 2 then
    error("Level only has one room! (2 or more are needed)")
  end

  LEVEL.all_quests = {}
  LEVEL.all_locks  = {}

  local QT = QUEST_CLASS.new(LEVEL.start_room)

  if not THEME.switches then
    no_quest_order(QT.start, QT)
  else
    -- the room list will be rebuilt in visit order
    LEVEL.all_rooms = {}

    visit_room(QT.start, QT)
  end

  assert(LEVEL.exit_room)

  gui.printf("Exit room is %s\n", LEVEL.exit_room:tostr())

  gui.debugf("Room Visit Order:\n")
  for _,R in ipairs(LEVEL.all_rooms) do
    gui.debugf("%s : quest %d : purpose %s\n", R:tostr(), R.quest.id, R.purpose or "-")
  end

--??? Quest_find_storage_rooms()

  Quest_key_distances()

  Quest_select_textures()
  Quest_choose_keys()
  Quest_add_weapons()
end

