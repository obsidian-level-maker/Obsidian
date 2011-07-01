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
                 -- start.entry_conn is the entry connection

  target : ROOM  -- room containing the goal of this quest (key or switch).
                 -- the room object will contain more information.
                 -- Never nil.

  rooms : list(ROOM)  -- all the rooms in the quest
}


class LOCK
{
  kind : keyword  -- "KEY" or "SWITCH"
  key  : string   -- name of key (game specific)

  tag : number    -- tag number to use for a switched door
                  -- (also an identifying number)

  target : ROOM   -- the room containing the key or switch
  conn   : CONN   -- the connection which is locked

  distance : number  -- number of rooms between key and door
}


--------------------------------------------------------------]]

require 'defs'
require 'util'


QUEST_CLASS = {}

function QUEST_CLASS.new(start)
  local id = 1 + #LEVEL.quests
  local Q = { id=id, start=start, rooms={} }
  table.set_class(Q, QUEST_CLASS)
  table.insert(LEVEL.quests, Q)
  return Q
end


function QUEST_CLASS.tostr(Q)
  return string.format("QUEST_%d", Q.id)
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

  each lock in LEVEL.locks do
    want_lock = lock

    lock.distance = dist_to_door(lock.target, nil, {})

    gui.debugf("  %s --> %s  lock_dist:%1.1f\n",
        lock.conn.R1.quest:tostr(), lock.conn.R2.quest:tostr(),
        lock.distance)
  end 
end


function Quest_choose_keys()
  local num_locks = #LEVEL.locks

  if num_locks <= 0 then
    gui.printf("Locks: NONE\n\n")
    return
  end

  local key_probs = table.copy(THEME.keys or {}) 
  local num_keys  = table.size(key_probs)

  -- use less keys when number of locked doors is small
  local want_keys = num_keys

  if not THEME.switch_doors then
    assert(num_locks <= num_keys)
  else
    while want_keys > 1 and (want_keys*2 > num_locks) and rand.odds(80) do
      want_keys = want_keys - 1
    end
  end

  gui.printf("Lock count:%d  want_keys:%d (of %d)  switch_doors:%s\n",
              num_locks, want_keys, num_keys,
              string.bool(THEME.switch_doors));


  --- STEP 1 : assign keys (distance based) ---

  local lock_list = table.copy(LEVEL.locks)

  each LOCK in lock_list do
    -- when the distance gets large, keys are better than switches
    LOCK.key_score = LOCK.distance or 0

    -- prefer not to use keyed doors between two outdoor rooms
    if LOCK.conn and LOCK.conn.R1.outdoor and LOCK.conn.R2.outdoor then
      LOCK.key_score = LOCK.key_score / 2
    end

    LOCK.key_score = LOCK.key_score + gui.random() / 1.5
  end

  table.sort(lock_list, function(A,B) return A.key_score > B.key_score end)

  each LOCK in lock_list do
    if table.empty(key_probs) or want_keys <= 0 then
      break;
    end

    if not LOCK.kind then
      LOCK.kind = "KEY"
      LOCK.key  = rand.key_by_probs(key_probs)

      -- cannot use this key again
      key_probs[LOCK.key] = nil

      want_keys = want_keys - 1
    end
  end


  --- STEP 2 : assign switches (random spread) ---

  for _,LOCK in ipairs(lock_list) do
    if not LOCK.kind then
      LOCK.kind = "SWITCH"
    end
  end

  gui.printf("Lock list:\n")

  each LOCK in LEVEL.locks do
    gui.printf("  %d = %s %s\n", _index, LOCK.kind, LOCK.key or "")
  end

  gui.printf("\n")
end



function Quest_add_weapons()
 
  local function do_mark_weapon(name)
    LEVEL.added_weapons[name] = true

    local allow = LEVEL.allowances[name]
    if allow then
      LEVEL.allowances[name] = sel(allow > 1, allow-1, 0)
    end
  end


  local function add_weapon(R)
    -- putting weapons in the exit room is a tad silly
    if R.purpose == "EXIT" then
      return
    end

    -- determine probabilities, ignore already gotten weapons
    local name_tab = {}

    for name,info in pairs(GAME.WEAPONS) do
      local prob = info.add_prob

      if R.purpose == "START" and not (OB_CONFIG.strength == "crazy") then
        prob = info.start_prob
      end

      if LEVEL.added_weapons[name] or LEVEL.allowances[name] == 0 then
        prob = 0
      end

      if prob and prob > 0 then
        name_tab[name] = prob
      end
    end

    if table.empty(name_tab) then
      return
    end

    local weapon = rand.key_by_probs(name_tab)
    local info = GAME.WEAPONS[weapon]

    R.weapon = weapon
    R.weapon_ammo = info.ammo

    do_mark_weapon(weapon)
  end


  local function should_swap(early, later)
    if not early or not later then return false end

    local info1 = assert(GAME.WEAPONS[early])
    local info2 = assert(GAME.WEAPONS[later])

---## -AJA- DISABLED, tends to make Berserk the first weapon, voilating 'start_prob'
---##    -- tend to place non-melee weapons before normal ones
---##    if info2.attack == "melee" and info1.attack != "melee" and rand.odds(65) then
---##      return true
---##    end

    -- otherwise only swap when the ammo is the same
    if info1.ammo == info2.ammo and
       (info1.rate * info1.damage) > (info2.rate * info2.damage)
    then
      return true
    end

    return false
  end


  local function swap_weapons(R, index)
    for i = index+1, #LEVEL.rooms do
      local N = LEVEL.rooms[i]

      if should_swap(R.weapon, N.weapon) then
        R.weapon, N.weapon = N.weapon, R.weapon
        R.weapon_ammo, N.weapon_ammo = N.weapon_ammo, R.weapon_ammo
      end
    end
  end


  ---| Quest_add_weapons |---

  LEVEL.added_weapons = {}

  add_weapon(LEVEL.rooms[1])

  local next_weap_at = 1.0

  each R in LEVEL.rooms do
    if R.weap_along >= next_weap_at then
      add_weapon(R)
      next_weap_at = next_weap_at + 1
    end
  end

  gui.printf("Weapon List:\n")

  -- make sure weapon order is reasonable, e.g. the shotgun should
  -- appear before the super shotgun, plasma rifle before BFG, etc...

  each R in LEVEL.rooms do
    swap_weapons(R, _index)

    if R.weapon then
      gui.printf("  %s: %s\n", R:tostr(), R.weapon)
    end
  end

  gui.printf("\n")
end


function Quest_find_storage_rooms()  -- NOT USED ATM

  -- a "storage room" is a dead-end room which does not contain
  -- anything special (keys, switches or weapons).  We place some
  -- of the ammo and health needed by the player elsewhere into
  -- these rooms to encourage exploration (i.e. to make these
  -- rooms not totally useless).

  each Q in LEVEL.quests do
    Q.storage_rooms = {}
  end

  each R in LEVEL.rooms do
    if R.kind != "scenic" and #R.conns == 1 and
       not R.purpose and not R.weapon
    then
      R.is_storage = true
      table.insert(R.arena.storage_rooms, R)
      gui.debugf("Storage room @ %s in ARENA_%d\n", R:tostr(), R.arena.id)
    end
  end
end


function Quest_select_textures()
  local base_num = 3

  -- more variety in large levels
  if SECTION_W * SECTION_H >= 30 then
    base_num = 4
  end

  if not LEVEL.building_facades then
    LEVEL.building_facades = {}

    for num = 1,base_num - rand.sel(75,1,0) do
      local name = rand.key_by_probs(THEME.building_facades or THEME.building_walls)
      LEVEL.building_facades[num] = name
    end
  end

  if not LEVEL.building_walls then
    LEVEL.building_walls = {}

    for num = 1,base_num do
      local name = rand.key_by_probs(THEME.building_walls)
      LEVEL.building_walls[num] = name
    end
  end

  if not LEVEL.building_floors then
    LEVEL.building_floors = {}

    for num = 1,base_num do
      local name = rand.key_by_probs(THEME.building_floors)
      LEVEL.building_floors[num] = name
    end
  end

  if not LEVEL.courtyard_floors then
    LEVEL.courtyard_floors = {}

    if not THEME.courtyard_floors then
      LEVEL.courtyard_floors[1] = rand.key_by_probs(THEME.building_floors)
    else
      for num = 1,base_num do
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

  gui.printf("\nSelected textures:\n")

  gui.printf("facades =\n%s\n", table.tostr(LEVEL.building_facades))
  gui.printf("walls =\n%s\n", table.tostr(LEVEL.building_walls))
  gui.printf("floors =\n%s\n", table.tostr(LEVEL.building_floors))
  gui.printf("courtyards =\n%s\n", table.tostr(LEVEL.courtyard_floors))

  gui.printf("\n")
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


  local function add_lock(D)
-- stderrf("   Locking conn to room %s\n", D.R2:tostr())

    local LOCK =
    {
      conn = D
      tag = Plan_alloc_id("tag")
    }

    D.lock = LOCK

    -- keep newest locks at the front of the active list
    table.insert(active_locks, 1, LOCK)

    table.insert(LEVEL.locks, LOCK)
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


  local function crossover_volume(D)
    local count = D.R2:num_crossovers()

    each D2 in D.R2.conns do
      if D2.R1 == D.R2 then
        count = count + crossover_volume(D2)
      end
    end

    return count
  end


  local function evaluate_exit(R, D)
    local score = 0

    -- prefer to visit rooms which have crossovers first
    score = score + crossover_volume(D) * 7.3

    local entry_kx = R.kx1
    local entry_ky = R.ky1

    if D.dir1 and R.entry_conn and R.entry_conn.dir2 then
      local x1, y1 = R.entry_conn.K2:approx_side_coord(R.entry_conn.dir2)
      local x2, y2 =            D.K1:approx_side_coord(D.dir1)

      local dist = geom.dist(x1, y1, x2, y2)
      if dist > 4 then dist = 4 end

      score = score + dist
    end

    -- strong preference to avoid 180 degree turns
    if D.dir1 and R.entry_conn and R.entry_conn.dir2 and D.dir1 != R.entry_conn.dir2 then
      score = score + 3
    end

    -- tie breaker
    return score + gui.random() / 5
  end


  local function pick_free_exit(R, exits)
    if #exits == 1 then
      return exits[1]
    end

    -- teleporters cannot be locked, hence must pick it when present
    each exit in exits do
      if exit.kind == "teleporter" then
        return exit
      end
    end

    local best_score = -9e9
    local best_exit

    each exit in exits do
      local score = evaluate_exit(R, exit)

-- stderrf("exit score[%d] = %1.1f", _index, score)
      if score > best_score then
        best_score = score
        best_exit  = exit
      end
    end

    return assert(best_exit)
  end


  local function visit_room(R, quest)
    while true do
      R.quest = quest

      table.insert(LEVEL.rooms, R)
      table.insert(quest.rooms, R)

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

        local free_exit = pick_free_exit(R, exits)

        -- lock up any excess branches
        each exit in exits do
          if exit != free_exit then
            add_lock(exit)
          end
        end

        -- continue down the free exit
        R = free_exit.R2
      end
    end -- while
  end


  local function no_quest_order(start, quest)
    each R in LEVEL.rooms do
      R.quest = quest

      table.insert(quest.rooms, R)

      if not LEVEL.exit_room and R != start and #R.conns <= 1 then
        LEVEL.exit_room = R
        R.purpose = "EXIT"
      end
    end
  end


  local function setup_lev_alongs()
    local w_along = 0

    each R in LEVEL.rooms do
      R.lev_along  = _index / #LEVEL.rooms
 
      R.weap_along = (w_along + R.kvolume / 3) / SECTION_W
      R.weap_along = R.weap_along * (PARAM.weapon_factor or 1)

      w_along = w_along + R.kvolume * rand.range(0.5, 0.8)
    end
  end


  local function dump_visit_order()
    gui.printf("Room Visit Order:\n")

    each R in LEVEL.rooms do
      gui.printf("%s : %1.2f : quest %d : purpose %s\n", R:tostr(),
                 R.lev_along, R.quest.id, R.purpose or "-")
    end

    gui.printf("\n")
  end


  --==| Quest_make_quests |==--

  gui.printf("\n--==| Make Quests |==--\n\n")

  -- need at least a START room and an EXIT room
  if #LEVEL.rooms < 2 then
    error("Level only has one room! (2 or more are needed)")
  end

  LEVEL.quests = {}
  LEVEL.locks  = {}

  local Q = QUEST_CLASS.new(LEVEL.start_room)

  if THEME.switch_doors then
    -- room list will be rebuilt in visit order
    LEVEL.rooms = {}

    visit_room(Q.start, Q)
  else
    -- room list remains in the "natural flow" order
    no_quest_order(Q.start, Q)
  end

  setup_lev_alongs()

  assert(LEVEL.exit_room)

  gui.printf("Exit room is %s\n", LEVEL.exit_room:tostr())

  dump_visit_order()


--[[
if not total_cross then total_cross = 0 ; cross_after = 0 ; cross_before = 0 end
each D in LEVEL.conns do
  if D.crossover then
    total_cross = total_cross + 1
    local R_src  = D.R1
    local R_over = D.crossover.MID_K.room
    assert(R_src and R_over)
    if R_over.quest.id < R_src.quest.id then cross_before = cross_before + 1 end
    if R_over.quest.id > R_src.quest.id then cross_after  = cross_after  + 1 end
  end
end
stderrf("CROSS STATS: %d + %d = %d\n", cross_before, cross_after, total_cross)
--]]


--??? Quest_find_storage_rooms()

  Quest_key_distances()

  Quest_select_textures()
  Quest_choose_keys()

  Quest_add_weapons()
end

