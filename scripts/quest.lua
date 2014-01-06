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

class ZONE
{
  -- A zone is a group of quests forming a large part of the level.
  -- The whole level might be a single zone.  Zones are generally
  -- connected via KEYED doors, whereas all the puzzles inside a
  -- zone are SWITCHED doors.
  --
  -- Zones are also meant to have a distinctive look, e.g. each one
  -- has a difference facade for buildings, different room and hallway
  -- themes (etc), even a different monster palette.

  id : number  -- debugging aid

  rooms : list(ROOM)

  start : ROOM  -- first room in the zone

  solution  : LOCK  -- the key (etc) which this zone must solve

  quests : list(QUEST)
}


class QUEST
{
  -- A quest is a group of rooms with a particular purpose at the
  -- end (the last room of the quest) -- often a switch to gain
  -- access to a new quest, or a key to gain access to a new zone.
  --
  -- The final quest (in the final zone) always leads to a room
  -- with an exit switch -- the end of the current map.
  --
  -- Quests and Zones are similar ideas, the main difference is
  -- their scope (zones are large and contain one or more quests).

  id : number  -- debugging aid

  kind : keyword  -- "normal", "secret"

  zone : ZONE

  rooms : list(ROOM)

  start : ROOM

  target : ROOM  -- room containing the solution

  storage_leafs : list(ROOM)
   secret_leafs : list(ROOM)
}


class LOCK
{
  kind : keyword  -- "KEY" or "SWITCH" or "EXIT"

  switch : string  -- the type of key or switch
  key    : string  --

  conn : CONN     -- connection between two rooms (and two quests)
                  -- which is locked (keyed door, lowering bars, etc)
                  -- Not used for EXITs.

  tag : number    -- tag number to use for a switched door
}


--------------------------------------------------------------]]


function Quest_compute_tvols(same_zone)

  local function travel_volume(R, seen_conns)
    -- Determine total volume of rooms that are reachable from the
    -- given room R, including itself, but excluding connections
    -- that have been "locked" or already seen.

    local rooms    = 1
    local volume   = assert(R.svolume)

    each C in R.conns do
      if (same_zone and C.R1.zone != C.R2.zone) or
         C.lock or seen_conns[C]
      then
        continue
      end

      local N = C:neighbor(R)
      seen_conns[C] = true

      local trav = travel_volume(N, seen_conns)

      rooms  = rooms  + trav.rooms
      volume = volume + trav.volume
    end

    return { rooms=rooms, volume=volume }
  end


  --| Quest_compute_tvols |---  

  each C in LEVEL.conns do
    C.trav_1 = travel_volume(C.R1, { [C]=true })
    C.trav_2 = travel_volume(C.R2, { [C]=true })
  end
end


function Quest_get_zone_exits(R)
  -- filter out exits which leave the zone
  local exits = {}

  each C in R:get_exits() do
    if C.R2.zone == R.zone then
      table.insert(exits, C)
    end
  end

  return exits
end


function Quest_dump_zone_flow(Z)

  function flow(R, indents, conn)
    assert(R)

    if not indents then
      indents = {}
    else
      indents = table.copy(indents)
    end

    local line = "   "

    for i = 1, #indents do
      if i == #indents then
        if conn.kind == "teleporter" then
          line = line .. "|== "
        elseif conn.lock then
          line = line .. "|## "
        else
          line = line .. "|-- "
        end
      elseif indents[i] then
        line = line .. "|   "
      else
        line = line .. "    "
      end
    end

    gui.debugf("%s%s%s%s\n", line, R:tostr(),
               sel(R.must_visit, "*", ""),
               sel(R.is_exit_leaf, "^", ""))

    local exits = Quest_get_zone_exits(R)

    table.insert(indents, true)

    each C in exits do
      if _index == #exits then
        indents[#indents] = false
      end

      flow(C.R2, indents, C)
    end
  end


  ---| Quest_dump_zone_flow |---

  gui.debugf("ZONE_%d FLOW:\n", Z.id)

  flow(Z.start)

  gui.debugf("\n")
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



function Quest_order_by_visit()
  -- put all rooms in the level into the order the player will most
  -- likely visit them.  When there are choices or secrets, then the
  -- order chosen here will be quite arbitrary.

  local function sort_room_list(list)
    table.sort(list, function(A,B) return A.lev_along < B.lev_along end)
  end


  ---| Quest_order_by_visit |---

  each Z in LEVEL.zones do
    local Z_len   = 1 / #LEVEL.zones
    local Z_along = (_index - 1) * Z_len

    Z.along = Z_along

    each Q in Z.quests do
      local Q_len   = 1 / #Z.quests
      local Q_along = (_index - 1) * Q_len

      each R in Q.rooms do
        local R_len   = 1 / #Q.rooms
        local R_along = _index * R_len

        R.lev_along = Z_along + Z_len * (Q_along + Q_len * R_along)
      end

      sort_room_list(Q.rooms)
    end

    sort_room_list(Z.rooms)
  end

  sort_room_list(LEVEL.rooms)

  gui.debugf("Room Visit Order:\n")
  each R in LEVEL.rooms do
    gui.debugf("  %1.3f : ZONE_%d  QUEST_%d  %s\n",
               R.lev_along, R.zone.id, R.quest.id, R:tostr())
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

--!!!!!! FIXME: Quest_add_weapons
do return end

  for index,A in ipairs(LEVEL.quests) do
    if index == 1  then
      do_start_weapon(A)
    elseif (index == 2) or rand.odds(sel((index % 2) == 1, 80, 20)) then
      do_new_weapon(A)
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



function Quest_create_zones()

  local function new_zone()
    local Z =
    {
      id = Plan_alloc_id("zone")
      rooms = {}
      quests = {}
      themes = {}
      previous = {}
      rare_used = {}
    }

    return Z
  end


  local function new_lock(kind)
    local LOCK =
    {
      kind = kind
      id   = Plan_alloc_id("lock")
      tag  = Plan_alloc_id("tag")
    }
    table.insert(LEVEL.locks, LOCK)
    return LOCK
  end


  local function initial_zone()
    local Z = new_zone()

    each R in LEVEL.rooms do
      R.zone = Z
    end

    Z.start = LEVEL.start_room

    Z.solution = new_lock("EXIT")

    return Z
  end


  local function pick_connection()
    local best_C
    local best_score = -1

    each C in LEVEL.conns do
      if C.lock then continue end
      if C.kind == "teleporter" then continue end

      -- start room, key room, branch-off room
      if C.trav_1.rooms < 3 then continue end 

      -- other side should not be too small either
      if C.trav_2.rooms < 2 then continue end 

      local score = math.min(C.trav_1.volume, C.trav_2.volume)

      score = score + gui.random()  -- tie breaker

      if score > best_score then
        best_C = C
        best_score = score
      end
    end

    return best_C
  end


  local function assign_new_zone(R, Z1, Z2, seen_conns)
    assert(R.zone == Z1)

    R.zone = Z2

    each C in R.conns do
      if not C.lock and not seen_conns[C] then
        seen_conns[C] = true

        assign_new_zone(C:neighbor(R), Z1, Z2, seen_conns)
      end
    end
  end


  local function try_split_a_zone()
    Quest_compute_tvols()

    local C = pick_connection()

    if not C then return false end

    local LOCK = new_lock("ZONE")

    C.lock = LOCK
    LOCK.conn = C

    local Z = assert(C.R1.zone)

    gui.debugf("splitting ZONE_%d at %s\n", Z.id, C.R1:tostr())


    local Z2 = new_zone()

    Z2.start = C.R2

    -- insert new zone, it must be AFTER current zone
    local old_pos
    for i = 1, #LEVEL.zones do
      if LEVEL.zones[i] == Z then
        old_pos = i ; break
      end
    end
    assert(old_pos)

    table.insert(LEVEL.zones, old_pos + 1, Z2)

    assign_new_zone(Z2.start, Z, Z2, {})

    -- new zone gets the previous lock to solve
    -- current zone must solve _this_ lock
    Z2.solution = Z.solution
    Z .solution = LOCK

    return true
  end


  local function collect_rooms(Z)
    each R in LEVEL.rooms do
      if R.zone == Z then
        table.insert(Z.rooms, R)
      end
    end
  end


  local function find_head(Z)
    each R in LEVEL.rooms do
      if R.zone == Z then
        return R
      end
    end

    error("No room for zone!")
  end


  local function dump_zones()
    gui.printf("Zone list:\n")

    each Z in LEVEL.zones do
      local R1 = find_head(Z)
      local lock = Z.solution
      gui.printf("  ZONE_%d : rooms:%d head:%s solve:%s(%s)\n", Z.id,
                 #Z.rooms, R1:tostr(),
                 lock.kind, lock.item or lock.switch or "")
    end
  end


  local function is_zone_start(R)
    each Z in LEVEL.zones do
      if R == Z.start then
        return true
      end
    end

    return false
  end


  local function mark_paths__OLD()
    -- mark the rooms between a zone's start and its exit room as
    -- being "on path" (including both start and exit).  These will
    -- be bad places to put a key.
    each lock in LEVEL.locks do
      if lock.kind != "EXIT" then
        local C = assert(lock.conn)
        local R = C.R1

        while true do
          R.on_zone_path = true

          if is_zone_start(R) then break; end
          if not R.entry_conn then break; end

          R = R.entry_conn.R1
        end
      end
    end
  end


  local function mark_room_and_ancestors(R)
    while true do
      R.must_visit = true

      if not R.entry_conn then return end

      local prev_R = R.entry_conn.R1

      if prev_R.zone != R.zone then return end

      R = prev_R
    end
  end


  local function mark_must_visits(Z)
    -- mark rooms which the player definitely needs to visit,
    -- especially rooms which leave the zone (and their ancestors).
    -- This allows us to know what we can safely turn into a secret.

    Z.start.must_visit = true

    each C in LEVEL.conns do
      if C.R1.zone == Z and C.R2.zone != Z then
        mark_room_and_ancestors(C.R1)
      end
    end
  end


  local function find_zone_exit_leaf(Z)
    -- find a room which exits the zone using the same lock which the
    -- zone solves _and_ is a leaf room.  It often does not exist, as
    -- the solution of some zones is merely to unlock an earlier zone,
    -- or because of the leaf requirement.

    if Z.solution.kind == "EXIT" then
      return nil
    end

    assert(Z.solution.conn)

    local R = Z.solution.conn.R1

    if R.zone != Z then return end

    each C in R:get_exits() do
      if C.R2.zone == Z then return nil end
    end

    R.is_exit_leaf = true

    return R
  end


  local function has_teleporter_exit(R)
    each C in R.conns do
      if C.R1 == R and C.kind == "teleporter" then
        return true
      end
    end

    return false
  end


  local function try_mark_free_branch(R, next_R)
    if has_teleporter_exit(R) then
      return false
    end

    local exits = Quest_get_zone_exits(R)

    if #exits < 2 then return false end

    --- do it ---

    local conn = next_R.entry_conn

    assert(conn and conn.R1 == R)

    conn.free_exit_score = 999999
    gui.debugf("Marked conn to %s as free_exit\n", next_R:tostr())

    -- also must ensure one of the exits gets locked (and not turned
    -- into a secret or storage).
    R.need_a_lock = true

    -- Note: since this room (or a descendant) leaves the zone, it is
    --       already guaranteed that it never becomes secret/storage.
    assert(R.must_visit)

    return true
  end


  local function prevent_key_in_same_room(Z)
    -- attempt to prevent adding a key to the same room as the door
    -- which it locks.  We do that by finding a branch which leads
    -- to a zone exit leaf, and marking it as best candidate for a
    -- free exit.

    local LE = find_zone_exit_leaf(Z)

    if not LE then return end

    local last = LE
    local R = last.entry_conn and last.entry_conn.R1

    while R and R.zone == Z do
      if try_mark_free_branch(R, last) then
        return  -- OK!
      end

      -- keep going back until we run out of rooms
      last = R
      R = last.entry_conn and last.entry_conn.R1
    end

    -- failed!
  end


  local function choose_keys()
    assert(THEME.switches)

    local key_list = table.copy(LEVEL.usable_keys or THEME.keys or {}) 
    local switches = table.copy(THEME.switches)

    local lock_list = table.copy(LEVEL.locks)
    rand.shuffle(lock_list)

    each lock in lock_list do
      if lock.kind != "ZONE" then continue end

      if table.empty(key_list) then
        lock.kind = "SWITCH"
        lock.switch = "sw_hot" --FIXME !!!! rand.key_by_probs(switches)
      else
        lock.kind = "KEY"
        lock.item = rand.key_by_probs(key_list)

        -- cannot use this key again
        key_list[lock.item] = nil
      end
    end
  end


  ---| Quest_create_zones |---

  local want_zones = int((LEVEL.W + LEVEL.H) / 4 + gui.random() * 3)

  gui.debugf("want_zones = %d\n", want_zones)

  local Z = initial_zone()

  table.insert(LEVEL.zones, Z)

  for i = 2, want_zones do
    if not try_split_a_zone() then
      break;
    end
  end

  each Z in LEVEL.zones do
    collect_rooms(Z)
    mark_must_visits(Z)
    prevent_key_in_same_room(Z)

    Quest_dump_zone_flow(Z)
  end

  choose_keys()

  dump_zones()
end



function Quest_divide_zones()
  --
  -- this divides the zones into stuff for the player to do ("quests"),
  -- typically just finding a switch to open a remote door.  each zone
  -- will consist of at least one quest, but usually several.
  --
  local active_locks = {}


  local function new_quest(start)
    local id = 1 + #LEVEL.quests

    local QUEST =
    {
      kind  = "normal"
      id = id
      start = start
      zone  = start.zone
      rooms = {}
      storage_leafs = {}
       secret_leafs = {}
    }

    table.insert(LEVEL.quests, QUEST)
    table.insert(QUEST.zone.quests, QUEST)

    return QUEST
  end


  local function add_lock(R, C)
    assert(C.kind != "double_L")
    assert(C.kind != "closet")
    assert(C.kind != "teleporter")

    local LOCK =
    {
      kind = "SWITCH"
      switch = rand.key_by_probs(THEME.switches)
      tag = Plan_alloc_id("tag")
    }

    gui.debugf("locking conn to %s (SWITCH)\n", C.R2:tostr())

    C.lock = LOCK
    LOCK.conn = C

    -- keep newest locks at the front of the active list
    table.insert(active_locks, 1, LOCK)

    table.insert(LEVEL.locks, LOCK)
  end


  local function pick_lock_to_solve()
    if table.empty(active_locks) then
      return nil
    end

    -- choosing the newest lock (at index 1) produces the most linear
    -- progression, which is easiest on the player.  Choosing older
    -- locks produces more back-tracking.  Due to the zone system,
    -- it doesn't matter too much which lock we choose.

    local p = 1

    while (p + 1) <= #active_locks and rand.odds(40) do
       p = p + 1
    end

    return table.remove(active_locks, p)
  end


  local function add_solution(R, lock)
--stderrf("add_solution @ %s : LOCK %s\n", R:tostr(), lock.kind)
    assert(not R.purpose)

    R.purpose = lock.kind
    R.purpose_lock = lock

    if R.purpose == "EXIT" then
      LEVEL.exit_room = R
    end

-- [[ DEBUG
each C in R.conns do
  if C.lock == lock then
    stderrf("*********** SAME LOCK @ %s\n", R:tostr())
  end
end
--]]

    gui.debugf("solving %s(%s) in %s\n", lock.kind, tostring(lock.item or lock.switch), R:tostr())
  end


  local function evaluate_exit(R, C)
    -- generally want to visit the SMALLEST group of rooms first, since
    -- that means the player's hard work to find the switch is rewarded
    -- with a larger new area to explore.  In theory anyway :-)

    if C.free_exit_score then
      return C.free_exit_score
    end

    -- FIXME !!!!
    return gui.random() * 10
  end


  local function pick_free_exit(R, exits)
    assert(#exits > 0)

    if #exits == 1 then
      return exits[1]
    end

    local best
    local best_score = -9e9

    each C in exits do
      assert(C.kind != "teleporter")

      local score = evaluate_exit(R, C)

-- gui.debugf("exit score for %s = %1.1f", D:tostr(), score)

      if score > best_score then
        best = C
        best_score = score
      end
    end

    return best
  end


  local function should_make_secret(C)
    if C.kind == "teleporter" then return false end

    if C.R2.must_visit then return false end

    -- sub-rooms don't make good secrets
    if C.R2.parent and C.R2.parent == C.R1 and rand.odds(80) then
      return false
    end

    local prob      = style_sel("secrets", 0,  33,  50,  90)
    local max_rooms = style_sel("secrets", 0, 1.8, 3.3, 6.5)
    local max_vol   = style_sel("secrets", 0,  58,  98, 198)

    max_rooms = int(max_rooms + gui.random())

    if C.trav_2.rooms  >= max_rooms then return false end
    if C.trav_2.volume >= max_vol   then return false end

    if not rand.odds(prob) then return false end

    return true
  end


  local function check_make_storage(C)
    if C.kind == "teleporter" and rand.odds(70) then return false end

    if STYLE.switches == "none" then return true end

    local prob      = style_sel("switches", 0,  80,  50,  15)
    local max_rooms = style_sel("switches", 0, 6.5, 3.3, 1.8)
    local max_vol   = style_sel("switches", 0, 198,  98,  58)

    max_rooms = int(max_rooms + gui.random())

    if C.trav_2.rooms  >= max_rooms then return false end
    if C.trav_2.volume >= max_vol   then return false end

    if not rand.odds(prob) then return false end

    return true
  end


  local function secret_flow(R, quest)
    if not quest then
      quest = new_quest(R)
      quest.kind = "secret"

      gui.debugf("Secret quest @ %s\n", R:tostr())
    end

    R.quest = quest

    table.insert(quest.rooms, R)

    local exits = Quest_get_zone_exits(R)

    if table.empty(exits) then
      table.insert(quest.secret_leafs, R)
      return
    end

    each C in exits do
      -- sometime make a "super" secret
      if rand.odds(20) and should_make_secret(C) then
        secret_flow(C.R2)
        C.R2.quest.super_secret = true
      else
        secret_flow(C.R2, quest)
      end
    end
  end


  local function boring_flow(R, quest)
    -- no locks will be added in this sub-tree of the zone

    R.quest = quest
    R.is_storage = true

    table.insert(quest.rooms, R)

    local exits = Quest_get_zone_exits(R)

    if table.empty(exits) then
      if not R.must_visit then
        table.insert(quest.storage_leafs, R)
      end

      return
    end

    rand.shuffle(exits)

    each C in exits do
      if should_make_secret(C) then
        secret_flow(C.R2)
      else
        boring_flow(C.R2, quest)
      end
    end
  end


  local function boring_exit(quest)
    local R
    local num_leaf = #quest.storage_leafs

    if num_leaf > 0 then
      R = table.remove(quest.storage_leafs, num_leaf)
    else
      -- emergency fall back : use the last room
      R = quest.rooms[#quest.rooms]
    end

    -- final room must solve the zone's lock instead
    add_solution(R, R.zone.solution)
  end


  local function quest_flow(R, quest)
    R.quest = quest

    table.insert(quest.rooms, R)

    local exits = Quest_get_zone_exits(R)


    if table.empty(exits) then
      --
      -- room is a leaf
      --

      quest.target = R

      local lock = pick_lock_to_solve()

      if not lock then
        -- room must solve the zone's lock instead
        add_solution(R, R.zone.solution)

        -- we are completely finished now
        return
      end

      add_solution(R, lock)
 
      local new_Q = new_quest(lock.conn.R2)

      -- continue on with new room and quest
      quest_flow(new_Q.start, new_Q)

    else
      --
      -- room has branches
      --

      local free_exit

      -- pick the exit we will continue travelling down.
      -- if one of them is a teleporter, we must use it.
      each C in exits do
        if C.kind == "teleporter" then
          assert(not free_exit)
          free_exit = C
        end
      end

      if not free_exit then
        free_exit = pick_free_exit(R, exits)
      end

      gui.debugf("using free exit --> %s\n", free_exit.R2:tostr())

      table.kill_elem(exits, free_exit)

      rand.shuffle(exits)
      
      local made_a_lock = false

      -- lock up all other branches
      -- FIXME: probabilities for secret / storage
      each C in exits do
        if not made_a_lock and R.need_a_lock then
          add_lock(R, C)
        elseif should_make_secret(C) then
          secret_flow(C.R2)
        elseif check_make_storage(C) then
          boring_flow(C.R2, quest)
        else
          add_lock(R, C)
        end
      end

      -- continue down the free exit
      quest_flow(free_exit.R2, quest)
    end
  end


  ---| Quest_divide_zones |---

  Quest_compute_tvols("same_zone")

  each Z in LEVEL.zones do
    gui.debugf("\nDividing ZONE_%d\n", Z.id)

    local Q = new_quest(Z.start)

    if THEME.switches and STYLE.switches != "none" then
      quest_flow(Q.start, Q)
    else
      boring_flow(Q.start, Q)
      boring_exit(Q)
    end
  end

end



function Quest_assign_room_themes()
  --
  -- figure out how many room themes to use for each kind of room.
  -- table keys of EXTENT_TAB are room kinds ("building" etc) and
  -- value is number of themes per ZONE, where zero means the whole level.
  --
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
      gui.debugf("@ ZONE_%d:\n", Z.id)

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
      gui.debugf("ZONE_%d =\n%s\n", Z.id, table.tostr(Z.pictures))
    end
    --]]
  end


  local function select_facades_for_zones()
    if not THEME.facades then
      error("Theme is missing facades table")
    end

    local tab = table.copy(THEME.facades)

    each Z in LEVEL.zones do
      local mat = rand.key_by_probs(tab)

      Z.facade_mat = mat

      -- less likely to use it again
      tab[mat] = tab[mat] / 5

      gui.printf("Facade for ZONE_%d : %s\n", Z.id, Z.facade_mat)
    end
  end


  ---| Quest_assign_room_themes |---

  LEVEL.rare_used = {}

  if not EPISODE.rare_used then
    EPISODE.rare_used = {}
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


function Quest_make_quests()

  gui.printf("\n--==| Make Quests |==--\n\n")

  Monsters_max_level()

  -- need at least a START room and an EXIT room
  if #LEVEL.rooms < 2 then
    error("Level only has one room! (2 or more are needed)")
  end

  LEVEL.zones  = {}
  LEVEL.quests = {}
  LEVEL.locks  = {}


  Quest_create_zones()

  Quest_divide_zones()


  assert(LEVEL.exit_room)

  gui.printf("Exit room: %s\n", LEVEL.exit_room:tostr())


  Quest_order_by_visit()

  Quest_add_weapons()

  Quest_assign_room_themes()
  Quest_select_textures()
end

