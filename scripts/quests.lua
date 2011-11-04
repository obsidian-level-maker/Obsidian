----------------------------------------------------------------
--  QUEST ASSIGNMENT
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2011 Andrew Apted
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

  id : number

  start : ROOM   -- room which player enters this quest.
                 -- for first quest, this is the map's starting room.
                 -- Never nil.
                 --
                 -- start.entry_conn is the entry connection

  target : ROOM  -- room containing the goal of this quest (key or switch).
                 -- the room object will contain more information.
                 -- Never nil.

  rooms : list(ROOM / HALL)  -- all the rooms in the quest

  zone : ZONE

  parent : QUEST  -- the quest which this one branched off (if any)

  parent_room : ROOM / HALL  -- the room or hall branched off

  branches : list(QUEST)  -- the quests which branch of this one

  volume : number  -- size of quest (sum of tvols)
}


class ZONE
{
  -- a zone is a group of quests    FIXME: MORE INFO

  id : number

  quests : list(QUEST)

  volume : number  -- total of all quests

  parent : ZONE
}


class LOCK
{
  kind : keyword  -- "KEY" or "SWITCH"

  key    : string   -- name of key (game specific)
  switch : string   -- name of switch (to match door with)

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
  local Q = { id=id, start=start, rooms={}, branches={} }
  table.set_class(Q, QUEST_CLASS)
  table.insert(LEVEL.quests, Q)
  return Q
end


function QUEST_CLASS.tostr(quest)
  return string.format("QUEST_%d", quest.id)
end


function QUEST_CLASS.calc_volume(quest)
  quest.volume = 0

  each L in quest.rooms do
    quest.volume = quest.volume + L.base_tvol
  end
end


function QUEST_CLASS.add_room_or_hall(quest, L)
  L.quest = quest

  table.insert(quest.rooms, L)
end


----------------------------------------------------------------


ZONE_CLASS = {}

function ZONE_CLASS.new()
  local id = 1 + #LEVEL.zones
  local Z = { id=id, quests={} }
  table.set_class(Z, ZONE_CLASS)
  table.insert(LEVEL.zones, Z)
  return Z
end


function ZONE_CLASS.tostr(Z)
  return string.format("ZONE_%d", Z.id)
end


function ZONE_CLASS.remove(Z)
  assert(Z.id)

  table.kill_elem(LEVEL.zones, Z)

  Z.id = nil
  Z.quests = nil
end


function ZONE_CLASS.add_quest(Z, quest)
  quest.zone = Z

  table.insert(Z.quests, quest)
end


function ZONE_CLASS.calc_volume(Z)
  Z.volume = 0

  each Q in Z.quests do
    Z.volume = Z.volume + Q.volume
  end
end


function ZONE_CLASS.merge(Z1, Z2)
  assert(Z2.parent == Z1)

  -- transfer the quests
  each Q in Z2.quests do
    Z1:add_quest(Q)
  end

  Z1:calc_volume()

  -- fix any parent fields which refer to Z2
  each Z in LEVEL.zones do
    if Z.parent == Z2 then
       Z.parent = Z1
    end
  end

  ZONE_CLASS.remove(Z2)
end


----------------------------------------------------------------

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

    -- FIXME !!!
    lock.distance = gui.random() --!!!  dist_to_door(lock.target, nil, {})
--[[
    gui.debugf("  %s --> %s  lock_dist:%1.1f\n",
        lock.conn.R1.quest:tostr(), lock.conn.R2.quest:tostr(),
        lock.distance)
--]]
  end 
end



function Quest_distribute_unused_keys()
  local next_L = GAME.levels[LEVEL.index + 1]

  if not next_L then return end
  if next_L.episode != LEVEL.episode then return end

  each name,prob in LEVEL.usable_keys do
    next_L.usable_keys[name] = prob
    LEVEL .usable_keys[name] = nil
  end
end



function Quest_choose_keys()
  local num_locks = #LEVEL.locks

  if num_locks <= 0 then
    gui.printf("Locks: NONE\n\n")
    return
  end

  local key_probs = table.copy(LEVEL.usable_keys or THEME.keys or {}) 
  local num_keys  = table.size(key_probs)

  -- use less keys when number of locked doors is small
  local want_keys = num_keys

  if not THEME.switches then
    assert(num_locks <= num_keys)
  else
    while want_keys > 1 and (want_keys*2 > num_locks) and rand.odds(70) do
      want_keys = want_keys - 1
    end
  end

  gui.printf("Lock count:%d  want_keys:%d (of %d)  has_switches:%s\n",
              num_locks, want_keys, num_keys,
              string.bool(THEME.switches));


  --- STEP 1 : assign keys (distance based) ---

  local lock_list = table.copy(LEVEL.locks)

  each LOCK in lock_list do
    -- when the distance gets large, keys are better than switches
    LOCK.key_score = LOCK.distance or 0

    -- prefer not to use keyed doors between two outdoor rooms
    if LOCK.conn and LOCK.conn.L1.outdoor and LOCK.conn.L2.outdoor then
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

      if LEVEL.usable_keys then
        LEVEL.usable_keys[LOCK.key] = nil
      end

      want_keys = want_keys - 1
    end
  end


  --- STEP 2 : assign switches (random spread) ---

  local switches = table.copy(assert(THEME.switches))

  for _,LOCK in ipairs(lock_list) do
    if not LOCK.kind then
      LOCK.kind = "SWITCH"
      LOCK.switch = rand.key_by_probs(switches)
      -- make it less likely to choose the same switch again
      switches[LOCK.switch] = switches[LOCK.switch] / 5
    end
  end

  gui.printf("Lock list:\n")

  each LOCK in LEVEL.locks do
    gui.printf("  %d = %s %s\n", _index, LOCK.kind, LOCK.key or LOCK.switch or "")
  end

  gui.printf("\n")
end



function Quest_add_weapons()
 
  local function prob_for_weapon(name, info, R)
    local prob  = info.add_prob
    local level = info.level or 1

    -- ignore weapons which lack a pick-up item
    if not prob or prob <= 0 then return 0 end

    if R.purpose == "START" then
      if info.start_prob then
        prob = info.start_prob
      else
        prob = prob / level
      end
    end

    -- make powerful weapons only appear in later levels
    if level > LEVEL.max_level then return 0 end

    -- theme adjustment
    if LEVEL.weap_prefs then
      prob = prob * (LEVEL.weap_prefs[name] or 1)
    end

    if THEME.weap_prefs then
      prob = prob * (THEME.weap_prefs[name] or 1)
    end

    return prob
  end


  local function decide_weapon(R)
    -- determine probabilities 
    local name_tab = {}

    each name,info in GAME.WEAPONS do
      -- ignore weapons already given
      if LEVEL.added_weapons[name] then continue end

      local prob = prob_for_weapon(name, info, R)

      if prob > 0 then
        name_tab[name] = prob
      end
    end

    gui.debugf("decide_weapon list:\n%s\n", table.tostr(name_tab))

    -- nothing is possible? ok
    if table.empty(name_tab) then return nil end

    local weapon = rand.key_by_probs(name_tab)

    return weapon
  end


  local function should_swap(early, later)
    assert(early and later)

    local info1 = assert(GAME.WEAPONS[early])
    local info2 = assert(GAME.WEAPONS[later])

    -- only swap when the ammo is the same
    if info1.ammo != info2.ammo then return false end

    -- determine firepower
    local fp1 = info1.rate * info1.damage
    local fp2 = info2.rate * info2.damage

    return (fp1 > fp2)
  end


  local function reorder_weapons(list)
    for pass = 1,2 do
      for i = 1, (#list - 1) do
        for k = (i + 1), #list do
          if should_swap(list[i].weapon, list[k].weapon) then
            local A = list[i].weapon
            local B = list[k].weapon

            list[i].weapon = B
            list[k].weapon = A
          end
        end
      end
    end
  end


  local function add_weapon(R, name)
    if not R.weapons then R.weapons = { } end

    table.insert(R.weapons, name)
  end


  local function hexen_add_weapons()
    local idx = 2

    if #LEVEL.rooms <= 2 or rand.odds(30) then idx = 1 end

    if LEVEL.hub_weapon then
      local R = LEVEL.rooms[idx]
      add_weapon(R, LEVEL.hub_weapon)
    end

    idx = idx + 1

    if LEVEL.hub_piece then
      local R = LEVEL.rooms[idx]
      add_weapon(R, LEVEL.hub_piece)
    end
  end


  ---| Quest_add_weapons |---

  -- special handling for HEXEN and HEXEN II
  if PARAM.hexen_weapons then
    hexen_add_weapons()
    return
  end

  LEVEL.added_weapons = {}

  local list = {}
  local next_weap_at = 0  -- start room guaranteed to have one

  each R in LEVEL.rooms do
    -- putting weapons in the exit room is a tad silly
    if R.purpose == "EXIT" then continue end

    for loop = 1,3 do
      if R.weap_along < next_weap_at then break end

      -- allow a second weapon only if room is large
      if loop == 2 and R.svolume < 15 then break end
      if loop == 3 and R.svolume < 60 then break end

      weapon = decide_weapon(R)

      if not weapon then break end

      table.insert(list, { weapon=weapon, room=R })

      -- mark it as used
      LEVEL.added_weapons[weapon] = true

      -- melee weapons are not worth as much as other ones
      local worth = 1
      local info = GAME.WEAPONS[weapon]

      if info.attack == "melee" then worth = 0.5 end

      next_weap_at = next_weap_at + worth
    end
  end

  gui.printf("Weapon List:\n")

  if table.empty(list) then
    gui.printf("  NONE!\n")
  end

  -- make sure weapon order is reasonable, e.g. the shotgun should
  -- appear before the super shotgun, plasma rifle before BFG, etc...
  reorder_weapons(list)

  each loc in list do
    gui.printf("  %s: %s\n", loc.room:tostr(), loc.weapon)

    add_weapon(loc.room, loc.weapon)
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
       not R.purpose and not R.weapons
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



function Quest_create_zones()

  local function initial_zones()
    -- initially have one zone for every quest

    LEVEL.zones = {}

    each Q in LEVEL.quests do
      local Z = ZONE_CLASS.new()

      Z:add_quest(Q)

      -- determine size of each quest too
      Q:calc_volume()
    end

    -- clone the structure too (just the 'parent' field)
    each Q in LEVEL.quests do
      if Q.parent then
        Q.zone.parent = Q.parent.zone
      end
    end

    -- calculate volumes
    each Z in LEVEL.zones do
      Z:calc_volume()
    end
  end


  local function min_zone_tvol()
    local low_vol
    local low_Z

    each Z in LEVEL.zones do
      if not low_vol or Z.volume < low_vol then
        low_vol = Z.volume
        low_Z = Z
      end
    end
      
    return low_vol, low_Z
  end

  
  local function score_for_merge(Z1, Z2)
    -- prefer smallest
    local score = 200 - Z1.volume

    return score + gui.random()  -- tie breaker
  end


  local function merge_a_zone(Z2)
    -- merges Z2 into an existing zone

    -- A zone can only merge with its parent or one of its children.

    local Z1
    local best_score

    each Z in LEVEL.zones do
      if Z != Z2 and (Z.parent == Z2 or Z2.parent == Z) then
        
        local score = score_for_merge(Z, Z2)

        if not best_score or score > best_score then
          Z1 = Z ; best_score = score
        end
      end
    end

    assert(Z1)

    -- can only merge the child into the parent
    if Z1.parent == Z2 then
      Z1, Z2 = Z2, Z1
    end

    Z1:merge(Z2)
  end


  local function dump_zones()
    gui.printf("Zone list:\n")

    each Z in LEVEL.zones do
      local q_line = "{ "

      each Q in Z.quests do
        q_line = q_line .. string.format("%d ", Q.id)
      end

      q_line = q_line .. "}"

      gui.printf("  %d: parent:%2d vol:%5.1f quests=%s\n", Z.id,
                 (Z.parent ? Z.parent.id ; -1), Z.volume, q_line) 
    end
  end


  ---| Quest_create_zones |---


  local base = (MAP_W + MAP_H) / 6
  local zone_quota = base * rand.pick({ 1.3, 1.7, 2.1, 2.5 })

  local keys = LEVEL.usable_keys or THEME.keys or {}
  local num_keys = table.size(keys)

  if zone_quota > 1 + num_keys then
     zone_quota = 1 + num_keys
  end

  -- TODO: this will need tweaking
  local min_tvol = 6.5

  gui.printf("Zone quota: %1.1f (tvol >= %1.1f)\n\n", zone_quota, min_tvol)

  initial_zones()

  --- dump_zones()

  while #LEVEL.zones > 1 do
    local vol, Z = min_zone_tvol()

    -- stop merging when all zones are large enough
    if vol >= min_tvol and #LEVEL.zones <= zone_quota then break end

    merge_a_zone(Z)

    --- gui.printf("AFTER MERGE\n")
    --- dump_zones()
  end

  dump_zones()
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


  local function get_exits(L)
    local exits = {}

    each D in L.conns do
      if D.L1 == L and D.kind != "double_R" then
        table.insert(exits, D)
      end
    end

    return exits
  end


  local function calc_travel_volume(L)
    -- returns volume for given room + all descendants

    local vol

    -- larger rooms have bigger volume 
    if L.is_hall then
      vol = 0.2
    else
      vol = 1 + L.svolume / 50
    end

    L.base_tvol = vol

    local exits = get_exits(L)

    each D in exits do
      vol = vol + calc_travel_volume(D.L2)
    end

    L.travel_vol = vol

    return L.travel_vol
  end


  local function add_lock(D)
-- stderrf("   Locking conn to room %s\n", D.R2:tostr())

    local LOCK =
    {
      conn = D
      tag = Plan_alloc_id("tag")
    }

    D.lock = LOCK

    -- for double hallways, put the lock in both connections
    if D.kind == "double_L" then
      assert(D.peer)
      D.peer.lock = LOCK
    end

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


  local function crossover_volume(L)
    local count = 0
    if L.is_room then count = L:num_crossovers() end

    each D in L.conns do
      if D.L1 == L and D.kind != "double_R" then
        count = count + crossover_volume(D.L2)
      end
    end

    return count
  end


  local function evaluate_exit(L, D)
    -- generally want to visit the SMALLEST section first, since that
    -- means the player's hard work to find the switch is rewarded
    -- with a larger new area to explore.  In theory anyway :-)
    local score = 100 - math.min(D.L2.travel_vol, 100)

    -- prefer to visit rooms which have crossovers first
    score = score + crossover_volume(D.L2) * 3.1

    -- prefer exit to be away from entrance
    if D.dir1 and L.entry_conn and L.entry_conn.dir2 then
      local x1, y1 = L.entry_conn.K2:approx_side_coord(L.entry_conn.dir2)
      local x2, y2 =            D.K1:approx_side_coord(D.dir1)

      local dist = geom.dist(x1, y1, x2, y2)
      if dist > 4 then dist = 4 end

      -- preference to avoid 180 degree turns
      if D.dir1 != L.entry_conn.dir2 then
        dist = dist + 2
      end

      score = score + dist / 2.0
    end

    -- tie breaker
    return score + gui.random() / 10
  end


  local function pick_free_exit(L, exits)
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
      local score = evaluate_exit(L, exit)

-- stderrf("exit score[%d] = %1.1f", _index, score)
      if score > best_score then
        best_score = score
        best_exit  = exit
      end
    end

    return assert(best_exit)
  end


  local function dump_room_flow(L, indents, is_locked)
    if not indents then
      indents = {}
    else
      indents = table.copy(indents)
    end

    local line = ""

    for i = 1, #indents do
      if i == #indents then
        if is_locked then
          line = line .. "|## "
        elseif L.is_room and L:has_teleporter() then
          line = line .. "|== "
        else
          line = line .. "|-- "
        end
      elseif indents[i] then
        line = line .. "|   "
      else
        line = line .. "    "
      end
    end

    gui.debugf("%s%s (%1.1f)\n", line, L:tostr(), L.travel_vol)

    local exits = get_exits(L)

    --[[
      while #exits == 1 do
        L = exits[1].L2 ; exits = get_exits(L)
      end
    --]]

    table.insert(indents, true)

    each D in exits do
      if _index == #exits then
        indents[#indents] = false
      end

      dump_room_flow(D.L2, indents, D.lock)
    end
  end


  local function quest_flow(L, quest)
    while true do
      quest:add_room_or_hall(L)

      -- stderrf("quest_flow @ %s\n", L:tostr())

      if L.is_room then
        table.insert(LEVEL.rooms, L)
      end

      local exits = get_exits(L)

      if #exits == 0 then
        -- hit a leaf room
        assert(L.is_room)

        quest.target = L

        local lock = add_goal(L)

        -- finished?
        if not lock then return end

        -- create new quest
        local new_quest = QUEST_CLASS.new(L)

        table.insert(quest.branches, new_quest)

        new_quest.parent = quest

        -- continue on with new room and quest
        L = lock.conn.L2
        quest = new_quest
      else

        local free_exit = pick_free_exit(L, exits)

        L.exit_conn = free_exit

        -- lock up any excess branches
        each exit in exits do
          if exit != free_exit then
            add_lock(exit)
          end
        end

        -- continue down the free exit
        L = free_exit.L2
      end
    end -- while
  end


  local function no_quest_order(start, quest)
    each R in LEVEL.rooms do
      quest:add_room_or_hall(R)

      table.insert(quest.rooms, R)

      if R != start then
        -- FIXME !!!
        best_exit = R
      end
    end

    each H in LEVEL.halls do
      quest:add_room_or_hall(H)
    end

    LEVEL.exit_room = best_exit
    LEVEL.exit_room.purpose = "EXIT"
  end


  local function setup_lev_alongs()
    local w_along = LEVEL.mon_along

    each R in LEVEL.rooms do
      R.lev_along  = _index / #LEVEL.rooms

      local w_step = R.kvolume / SECTION_W
 
      R.weap_along = w_along + w_step / 3
      R.weap_along = R.weap_along * (PARAM.weapon_factor or 1)

--stderrf("WEAPON ALONG : %1.2f\n", R.weap_along)

      w_along = w_along + w_step * rand.range(0.5, 0.8)
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


  local function update_crossovers()
    each H in LEVEL.halls do
      if H.crossover then H:set_cross_mode() end
    end
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

  calc_travel_volume(Q.start)

  if THEME.switches then
    -- room list will be rebuilt in visit order
    LEVEL.rooms = {}

    quest_flow(Q.start, Q)
  else
    -- room list remains in the "natural flow" order
    no_quest_order(Q.start, Q)
  end

  gui.debugf("Level Flow:\n\n")
  dump_room_flow(Q.start)

  setup_lev_alongs()

  assert(LEVEL.exit_room)
  assert(LEVEL.exit_room.is_room)

  gui.printf("Exit room is %s\n", LEVEL.exit_room:tostr())

  dump_visit_order()

  update_crossovers()


--??? Quest_find_storage_rooms()

  Quest_key_distances()

  Quest_select_textures()
  Quest_choose_keys()

  -- left over keys can be used in the next level of a hub
  if LEVEL.usable_keys and LEVEL.hub_links then
    Quest_distribute_unused_keys()
  end

  Monsters_max_level()

  Quest_create_zones()

  Quest_add_weapons()
end


----------------------------------------------------------------


function Hub_connect_levels(epi, keys)

  local function connect(src, dest, kind)
    assert(src!= dest)

    local LINK =
    {
      kind = kind
      src  = src
      dest = dest
    }

    table.insert( src.hub_links, LINK)
    table.insert(dest.hub_links, LINK)
    table.insert( epi.hub_links, LINK)
  end


  local function dump()
    gui.debugf("\nHub links:\n")

    each link in epi.hub_links do
      gui.debugf("  %s --> %s\n", link.src.name, link.dest.name)
    end

    gui.debugf("\n")
  end


  local function OLD__find_free_away(L)
    local count = 0

    each link in L.hub_links do
      if not link.key and link.src == L then
        count = count + 1

        -- the first free away will stay unlocked, require second one
        if count == 2 then
          return link
        end
      end
    end

    return nil  -- not found
  end


  local function OLD__find_junction()
    each L in epi.levels do
      local link = find_free_away(L)
      if link then return link end
    end

    return nil -- not found
  end


  ---| Hub_connect_levels |---

  local levels = table.copy(epi.levels)

  assert(#levels >= 4)

  keys = table.copy(keys)

  rand.shuffle(keys)

  -- setup
  epi.hub_links = { }
  epi.used_keys = { }

  each L in levels do
    L.hub_links = { }
  end

  -- create the initial chain, which consists of the start level, end
  -- level and possibly a level or two in between.

  local start_L = table.remove(levels, 1)
  local end_L   = table.remove(levels, #levels)

  assert(end_L.kind == "BOSS")

  local chain = { start_L }

  for loop = 1, rand.sel(75, 2, 1) do
    assert(#levels >= 1)

    table.insert(chain, table.remove(levels, 1))
  end

  table.insert(chain, end_L)

  for i = 1, #chain - 1 do
    connect(chain[i], chain[i+1], "chain")
  end

  -- the remaining levels just branch off the current chain

  each L in levels do
    -- pick existing level to branch from (NEVER the end level)
    local src = chain[rand.irange(1, #chain - 1)]

    -- prefer an level with no branches so far
    if #src.hub_links > 0 then
      src = chain[rand.irange(1, #chain - 1)]
    end

    connect(src, L, "branch")

    -- assign keys to these branch levels

    if L.kind != "SECRET" and not table.empty(keys) then
      L.hub_key = rand.key_by_probs(keys)

      keys[L.hub_key] = nil

      table.insert(epi.used_keys, L.hub_key)

      gui.debugf("Hub: assigning key '%s' --> %s\n", L.hub_key, L.name)
    end
  end

  dump()
end



function Hub_assign_keys(epi, keys)
  -- determines which keys can be used on which levels

  keys = table.copy(keys)

  local function level_for_key()
    for loop = 1,999 do
      local idx = rand.irange(1, #epi.levels)
      local L = epi.levels[idx]

      if L.kind == "SECRET" then continue end

      if L.hub_key and rand.odds(95) then continue end

      local already = #L.usable_keys

      if already == 0 then return L end
      if already == 1 and rand.odds(20) then return L end
      if already >= 2 and rand.odds(4)  then return L end
    end

    error("level_for_key failed.")
  end

  each L in epi.levels do
    L.usable_keys = { }
  end

  -- take away keys already used in the branch levels
  each name in epi.used_keys do
    keys[name] = nil
  end

  while not table.empty(keys) do
    local name = rand.key_by_probs(keys)
    local prob = keys[name]

    keys[name] = nil

    local L = level_for_key()

    L.usable_keys[name] = prob

    gui.debugf("Hub: may use key '%s' --> %s\n", name, L.name)
  end
end



function Hub_assign_weapons(epi)

  -- Hexen and Hexen II only have two pick-up-able weapons per class.
  -- The normal weapon placement logic does not work well for that,
  -- instead we pick which levels to place them on.

  local a = rand.sel(75, 2, 1)
  local b = rand.sel(75, 3, 4)

  epi.levels[a].hub_weapon = "weapon2"
  epi.levels[b].hub_weapon = "weapon3"

  gui.debugf("Hub: assigning 'weapon2' --> %s\n", epi.levels[a].name)
  gui.debugf("Hub: assigning 'weapon3' --> %s\n", epi.levels[b].name)

  local function mark_assumes(start, weapon)
    for i = start, #epi.levels do
      local L = epi.levels[i]
      if not L.assume_weapons then L.assume_weapons = { } end
      L.assume_weapons[weapon] = true
    end
  end

  mark_assumes(a, "weapon2")
  mark_assumes(b, "weapon3")

  mark_assumes(#epi.levels, "weapon4")
end



function Hub_assign_pieces(epi, pieces)

  -- assign weapon pieces (for HEXEN's super weapon) to levels

  assert(#pieces < #epi.levels)

  local levels = { }

  each L in epi.levels do
    if L.kind != "BOSS" and L.kind != "SECRET" then
      table.insert(levels, L)
    end
  end

  assert(#levels >= #pieces)

  rand.shuffle(levels)

  each piece in pieces do
    local L = levels[_index]

    L.hub_piece = piece

    gui.debugf("Hub: assigning piece '%s' --> %s\n", piece, L.name)
  end 
end

