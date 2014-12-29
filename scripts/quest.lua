------------------------------------------------------------------------
--  QUEST ASSIGNMENT
------------------------------------------------------------------------
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
------------------------------------------------------------------------

--|
--| See doc/Quests.txt for an overview of the quest system
--|

--class QUEST
--[[
    id, name   -- debugging aids

???    kind : keyword  -- "major", "minor"  [ "secret" ?? ]

    areas[id] : AREA

    svolume   : total svolume of all areas

    entry : CONN

    targets : list(TARGET)

---???    unused_leafs : list(AREA)

    zone : ZONE

???    storage_leafs : list(ROOM)
???     secret_leafs : list(ROOM)

--]]


--class ZONE
--[[
    -- A zone is group of quests.
    -- Each zone is meant to be distinctive (visually and game-play).

    id, name   -- debugging aids

    quests : list(QUEST)   -- entry into zone is in quests[1]


    -- FIXME : more stuff  e.g. building_mat, cave_mat, monster palette !!!
--]]


--class TARGET
--[[
    kind : keyword  -- "exit" or "goal"

    room : AREA   -- used for MAJOR quests
    area : AREA   -- used for MINOR quests

    lock : LOCK
--]]


--class LOCK
--[[
    kind : keyword  -- "KEY" or "SWITCH" or "LEVEL_EXIT"

    switch : string  -- the type of key or switch
    key    : string  --

    conn : CONN     -- connection between two rooms (and two quests)
                    -- which is locked (keyed door, lowering bars, etc)
                    -- Not used for EXITs.

    tag : number    -- tag number to use for a switched door
--]]


--------------------------------------------------------------]]


function Quest_new(precede_Q)
  local id = 1 + #LEVEL.quests

  local QUEST =
  {
    id = id
    name  = "QUEST_" .. id
    areas = {}
    targets = {}
    svolume = 0
  }

  if precede_Q then
    table.add_before(LEVEL.quests, precede_Q, QUEST)
  else
    table.insert(LEVEL.quests, QUEST)
  end

  return QUEST
end


function Zone_new()
  local id = 1 + #LEVEL.zones

  local ZONE =
  {
    id = id
    name = "ZONE_" .. id
    quests = {}
    svolume = 0
  }

  table.insert(LEVEL.zones, ZONE)

  return ZONE
end



function size_of_area_set(areas)
  local total = 0

  each id, A in areas do
    total = total + A.svolume
  end

  return total
end



function Quest_create_initial_quest()
  --
  -- Turns the whole map into a single Quest object, and pick an exit room
  -- as the target of the quest.
  --
  -- This quest can be divided later on into major and minor quests.
  --

  local function eval_exit_room(R)
    if R.is_hallway then return -1 end
    if R.purpose    then return -1 end

    return R.svolume + gui.random() * 5
  end


  local function pick_exit_room()
    --
    -- We want a large room for the exit, so can have a big battle with
    -- one or more boss-like monsters.
    --
    local best
    local best_score = 0

    each R in LEVEL.rooms do
      local score = eval_exit_room(R)

      if score > best_score then
        best = R
        best_score = score
      end
    end

    if not best then
      error("Unable to pick exit room!")
    end

    best.purpose = "EXIT"

    return best
  end


  ---| Quest_create_initial_quest |---


  local Q = Quest_new()

  each A in LEVEL.areas do
    if A.room then
      Q.areas[A.id] = A
      Q.svolume = Q.svolume + A.svolume

      A.quest = Q
    end
  end

  local R = pick_exit_room()

  gui.printf("Exit room: %s\n", R:tostr())

  LEVEL.exit_room = R

  local TARGET =
  {
    kind = "goal"

    sub_kind = "EXIT"

    room = R
    area = R.areas[1]
  }

  table.insert(Q.targets, TARGET)

  -- TODO : secret exit
end


function Quest_eval_divide_at_conn(C, info)
  --
  -- Evaluate whether we can divide a quest at the given connection.
  --
  -- The 'info' table contains the current best division (if any),
  -- and contains the following fields:
  --
  --    mode      : either "minor" or "MAJOR"
  --    lock_kind : the lock to place on the connection
  --    num_goals : goals used to solve the lock (usually 1)
  --
  --    score   :  best current score  (must be initialised to zero)
  --
  --    conn    :  the best connection  [ NIL if none yet ]
  --    quest   :  the quest to divide
  --    before  :  area set before best connection
  --    after   :  area set after best connection
  --    leafs   :  list of rooms / areas to place goals (#leafs >= num_goals)
  -- 

  local quest  -- current quest


  local function same_quest(C)
    return C.A1.quest == C.A2.quest
  end


  local function collect_areas(A, mode, areas)
    -- mode is either "before" or "after"

    areas[A.id] = A

    each C in A.conns do
      local next_A = sel(mode == "before", C.A1, C.A2)

      if next_A != A and same_quest(C) then
        collect_areas(next_A, mode, areas)
      end
    end

    return areas
  end


  local function area_exits_in_set(A, areas)
    local count = 0

    each C in A.conns do
      local N = C:neighbor(A)

      if areas[N.id] then count = count + 1 end
    end

    assert(count > 0)

    return count
  end


  local function room_exits_in_set(R, areas)
    local count = 0

    each A in R.areas do
    each C in A.conns do
      if C.A1.room == C.A2.room then continue end

      local N = C:neighbor(A)

      if areas[N.id] then count = count + 1 end
    end
    end

    -- FIXME: in MINOR mode we might only be doing a single room
    assert(count > 0)

    return count
  end


  local function unused_rooms_in_set(C, areas)
    local leafs = {}

    -- Note : we visit the same room multiple times (not worth optimising)

    each id, A in areas do
      local R = A.room

      -- skip the room immediately next to the proposed connection
      -- FIXME area check in "MINOR" mode
      if C.A1.room == R or C.A2.room == R then continue end

      if room_exits_in_set(R, areas) == 1 then
        table.add_unique(leafs, R)
      end
    end

    return leafs
  end


  local function check_targets(areas)
    -- returns 0 if no targets in the area set [ NO GOOD ]
    --         1 if a non-goal target is in the set [ USABLE ]
    --         2 if a goal target is in the set [ BEST ]

    local has_non_goal = false

    each target in Q2.targets do
      if (target.room and areas[target.room.areas[1].id]) or
         (target.area and areas[target.area.id])
      then
        if target.kind == "goal" then return 2 end
        has_non_goal = true
      end
    end

    return sel(has_non_goal, 1, 0)
  end


  local function eval_split_possibility(C, before, after)
    -- FIXME evaluate stuff !!

    local score = 200

    -- 
    if C.A2.room.is_hallway then
      score = score - 100
    end

    -- tie breaker
    return score + gui.random()
  end


  ---| Quest_eval_divide_at_conn |---

  -- connection must be same quest
  if C.A1.quest != C.A2.quest then
    return
  end

  -- zones must not divide a room in half
  if info.mode == "MAJOR" and C.A1.room == C.A2.room then
    return
  end

  -- no locking end of hallways in MAJOR mode
  if info.mode == "MAJOR" and C.A1.room.is_hallway then
    return
  end

  quest = C.A1.quest

  -- collect areas before / after the connection
  local before = collect_areas(C.A1, "before", {})
  local  after = collect_areas(C.A2, "after",  {})

  -- entry of quest MUST be in first half
  if quest.entry then
    if not before[quest.entry.id] then return end
  end

  -- one existing target MUST be in second half
  if check_targets(after) < 2 then return end

  -- FIXME : in "MINOR" mode check areas not rooms
  local leafs = unused_rooms_in_set(before)

  if #leafs < info.num_goals then return end

  local score = eval_split_possibility(C, before, after)

  if score > info.score then
    info.conn   = C
    info.quest  = quest
    info.score  = score
    info.before = before
    info.after  = after
    info.leafs  = leafs
  end
end


function Quest_perform_division(info)

  local function assign_quest(Q)
    each id, A in Q.areas do
      A.quest = Q
    end
  end


  local function transfer_existing_targets(Q1, Q2)
    for i = #Q2.targets, 1, -1 do
      local targ = Q2.targets[i]

      if (targ.room and targ.room.areas[1].quest == Q1) or
         (targ.area and targ.area.quest == Q1)
      then
        table.insert(Q1.targets, table.remove(Q2.targets, i))
      end
    end
  end


  local function add_new_targets(Q1)
    -- FIXME !!!!
  end


  ---| Quest_perform_division |---

  local Q2 = assert(info.quest)

  -- new quest is the first half (is added before Q2 in LEVEL.quests)

  local Q1 = Quest_new(Q2)

  Q2.entry = info.conn.A2

  Q1.areas = info.before
  Q2.areas = info.after

  Q1.svolume = size_of_area_set(Q1.areas)
  Q2.svolume = size_of_area_set(Q2.areas)

  assign_quest(Q1)
  assign_quest(Q2)

  transfer_existing_targets(Q1, Q2)

  add_new_targets(Q1)

  -- FIXME : actually lock the connection !!!
end



function Quest_try_divide(mode)
  local info =
  {
    mode = mode
    lock_kind = "Foo"
    num_goals = 1

    score = 0
  }

  each C in LEVEL.conns do
    Quest_eval_divide_at_conn(C, info)
  end

  if not info.conn then
    return false
  end

  Quest_perform_division(info)
  return true
end



function Quest_add_major_quests()

  ---| Quest_add_major_quests |---

  local map_svolume = LEVEL.quests[1].svolume

  local want_splits = 3  -- three keys  ( FIXME : base it on map_svolume )

  for i = 1, want_splits do
    if not Quest_try_divide("MAJOR") then
      break;
    end
  end

end



function Quest_add_minor_quests()
  
  ---| Quest_add_minor_quests |---

  -- TODO
end



function Quest_group_into_zones()

  -- Note : assumes quests are in a visit order


  local function assign_zone(Q, zone)
    Q.zone = zone

    table.insert(zone.quests, Q)

    zone.svolume = zone.svolume + Q.svolume
    
    each id, A in Q.areas do
      A.zone = zone
      A.room.zone = zone
    end
  end


  ---| Quest_group_into_zones |---

  local rough_size = rand.pick({ 200, 250, 300 })  -- TODO: REVIEW

  local cur_zone = Zone_new()

  each Q in LEVEL.quests do
    if cur_zone.svolume >= rough_size then
      cur_zone = Zone_new()
    end

    assign_zone(Q, cur_zone)
  end
end


------------------------------------------------------------------------


function Quest_start_room()

  local function eval_start_room(R)
    local score = 1

    -- never in a stairwell
    if R.kind == "stairwell" then
      return -1
    end

    -- never in a hallway
    -- TODO : occasionally allow it -- but require a void area nearby
    --        which we can use for a start closet
    if R.is_hallway then
      return -1
    end

    -- really really don't want to see a goal (like a key)
    if not R.purpose then
      score = score + 1000
    end

    -- not too big !!
    if R.svolume < 25 then score = score + 20 end
    if R.svolume < 50 then score = score + 10 end

    -- prefer no teleporter
    if not R:has_teleporter() then score = score + 7 end

    -- TODO: prefer a place for start closet

    -- tie breaker
    return score + gui.random() * 4
  end


  local function do_entry_conns(A, entry_conn, seen)
    A.entry_conn = entry_conn

    seen[A] = 1

    each C in A.conns do
      local A2 = C:neighbor(A)

      if not seen[A2] then
        do_entry_conns(A2, C, seen)
      end
    end
  end


  ---| Quest_start_room |---

  local best_R
  local best_score = 0

  local first_quest = LEVEL.quests[1]

  each R in LEVEL.rooms do
    if R.areas[1].quest != first_quest then continue end

    local score = eval_start_room(R)

    if score > best_score then
      best_R = R
      best_score = score
    end
  end

  if not best_R then
    error("Could not find a usable start room")
  end

  -- OK --

  local R = best_R

  gui.printf("Start room: %s\n", R:tostr())

  R.purpose = "START"

  LEVEL.start_room = R
  LEVEL.start_area = R.areas[1]  -- TODO

  LEVEL.quests[1].entry = LEVEL.start_area

  do_entry_conns(LEVEL.start_area, nil, {})
end



function Quest_order_by_visit()
  --
  -- Put all rooms in the level into the order the player will most
  -- likely visit them.  When there are choices or secrets, then the
  -- order chosen here will be quite arbitrary.
  --


-- DEBUG CRUD....
--[[
each A in LEVEL.areas do
  if not A.room then continue end
  stderrf("%s in %s (%s)\n", A:tostr(), A.room:tostr(), (A.quest and A.quest.name) or "NO_QUEST")
  stderrf("{\n")
  each C in A.conns do
    stderrf("  %s : (%s in %s) <---> (%s in %s)\n", C:tostr(),
            C.A1:tostr(), C.A1.room:tostr(),
            C.A2:tostr(), C.A2.room:tostr())
  end
  stderrf("}\n")
end
--]]




  local cur_along   = 1
  local total_rooms = #LEVEL.rooms


local via_conn_name = "-"

  
  local function visit_room(R, quest)
stderrf("visit_room %s (via %s)\n", R:tostr(), via_conn_name)
    R.lev_along = cur_along / total_rooms

    cur_along = cur_along + 1

    each A in R.areas do
    each C in A.conns do
      assert(A.quest == quest)

      if not (C.A1 == A or C.A2 == A) then continue end

      local A2 = C:neighbor(A)

      if A2.quest != quest then continue end

      if A2.room == R then continue end

via_conn_name = C:tostr()

      if not A2.room.lev_along then
        visit_room(A2.room, quest)
      end
    end
    end
  end


  ---| Quest_order_by_visit |---

  each Q in LEVEL.quests do
    assert(Q.entry)

    visit_room(Q.entry.room, Q)
  end

-- sanity check
each R in LEVEL.rooms do
  if not R.lev_along then
    error("Room not visited: " .. R:tostr())
  end
end


  -- sort the rooms
  table.sort(LEVEL.rooms, function(A,B) return A.lev_along < B.lev_along end)

  gui.debugf("Room Visit Order:\n")

  each R in LEVEL.rooms do
    gui.debugf("  %1.3f : %s  %s  %s\n",
               R.lev_along, R:tostr(), R.areas[1].quest.name, R.zone.name)
  end
end



function Quest_add_weapons()
  --
  -- Decides which weapons to use for this level, and determines
  -- which rooms to place them in.
  --

  local function prob_for_weapon(name, info, is_start)
    local prob  = info.add_prob
    local level = info.level or 1

    -- ignore weapons which lack a pick-up item
    if not prob or prob <= 0 then return 0 end

    -- ignore weapons already given
    if LEVEL.added_weapons[name] then return 0 end

    -- for crazy monsters mode, player may need a bigger weapon
    if is_start and OB_CONFIG.strength != "crazy" then
      if info.start_prob then
        prob = info.start_prob
      else
        prob = prob / level
      end
    end

    -- make powerful weapons only appear in later levels
    if OB_CONFIG.strength != "crazy" then
      if level > LEVEL.weap_level then return 0 end
    end

    -- theme adjustments
    if LEVEL.weap_prefs then
      prob = prob * (LEVEL.weap_prefs[name] or 1)
    end
    if THEME.weap_prefs then
      prob = prob * (THEME.weap_prefs[name] or 1)
    end

    return prob
  end


  local function decide_weapon(is_start)
    -- determine probabilities 
    local name_tab = {}

    each name,info in GAME.WEAPONS do
      local prob = prob_for_weapon(name, info, is_start)

      if prob > 0 then
        name_tab[name] = prob
      end
    end

    gui.debugf("decide_weapon list:\n%s\n", table.tostr(name_tab))

    -- nothing is possible? ok
    if table.empty(name_tab) then return nil end

    local weapon = rand.key_by_probs(name_tab)

    -- mark it as used
    LEVEL.added_weapons[weapon] = true

    return weapon
  end


  local function should_swap(early, later)
    assert(early and later)

    local info1 = assert(GAME.WEAPONS[early])
    local info2 = assert(GAME.WEAPONS[later])

    -- only swap when the ammo is the same
    if info1.ammo != info2.ammo then return false end

    if info1.level != info2.level then
      return info1.level > info2.level
    end

    -- same level, so test the firepower
    local fp1 = info1.rate * info1.damage
    local fp2 = info2.rate * info2.damage

    return (fp1 > fp2)
  end


  local function reorder_weapons(list)
    for pass = 1,3 do
      for i = 1, (#list - 1) do
      for k = (i + 1), #list do
        if should_swap(list[i], list[k]) then
          local A, B = list[i], list[k]

          list[i], list[k] = B, A
        end
      end -- i, k
      end
    end -- pass
  end


  local function num_weapons_for_zones(quota)
    local counts = {}

    for k = 1, #LEVEL.zones do
      counts[k] = 0
    end

    -- first zone always gets a weapon
    counts[1] = 1
    quota = quota - 1

    for i = 2, 99 do
      if quota <= 0 then break; end

      if rand.odds(60) then
        local zone_idx = 1 + (i - 1) % #LEVEL.zones

        counts[zone_idx] = counts[zone_idx] + 1

        quota = quota - 1
      end
    end

    return counts
  end


  local function eval_room_for_weapon(R, is_start, is_new)
    -- alternate starting rooms have special handling
    if R == LEVEL.alt_start then return -200 end

    -- never in secrets!
    if R.quest.kind == "secret" then return -100 end

    -- putting weapons in the exit room is a tad silly
    if R.purpose == "EXIT" then return -60 end

    -- too many weapons already? (very unlikely to occur)
    if #R.weapons >= 2 then return -30 end

    -- basic fitness of the room is the size
    local score = R.svolume

    if is_start and not is_new and R.purpose == "START" then
      return rand.pick { 20, 120, 220 }
    end

    -- big bonus for leaf rooms
    if table.empty(Quest_get_zone_exits(R)) then
      score = score + 60
    end

    -- small bonus for storage (bigger for new weapons)
    if R.is_storage then
      score = score + sel(is_new, 40, 10)
    end

    -- if there is a purpose or another weapon, adjust the size
    if R.purpose then score = score / 5 end
    if #R.weapons > 0 then score = score / 10 end
    if R.kind == "hallway" then score = score / 20 end

    return score
  end


  local function add_weapon(Z, name, is_start)
    gui.debugf("Add weapon '%s' --> ZONE_%d\n", name, Z.id)

    -- check if weapon is "new" (player has never seen it before).
    -- new weapons deserve their own quest, or at least require
    -- some exploration to find it.

    local is_new = false
    if not EPISODE.seen_weapons[name] then
      is_new = true
      EPISODE.seen_weapons[name] = 1
    end

    -- berserk only lasts a single level : treat like a new weapon
    if name == "berserk" then is_new = true end

    -- evaluate each room and pick the best
    each R in Z.rooms do
      R.weap_score = eval_room_for_weapon(R, is_start, is_new)

      -- tie breaker
      R.weap_score = R.weap_score + gui.random() * 4
    end

    local room = table.pick_best(Z.rooms,
        function(A, B) return A.weap_score > B.weap_score end)

    table.insert(room.weapons, name)

    gui.debugf("|--> %s\n", room:tostr())
  end


  local function fallback_start_weapon()
    -- be a meanie sometimes...
    if rand.odds(70) or OB_CONFIG.weapons == "less" then
      return
    end

    -- collect usable weapons, nothing too powerful
    local tab = {}

    each name,info in GAME.WEAPONS do
      local prob = info.start_prob or info.add_prob

      if prob and info.level and info.level <= 2 then
        tab[name] = prob
      end
    end

    if table.empty(tab) then
      gui.printf("No possible fallback weapons!")
      return
    end

    local name = rand.key_by_probs(tab)

    table.insert(LEVEL.start_room.weapons, name)

    LEVEL.added_weapons[name] = true

    gui.debugf("Fallback start weapon: %s\n", name)
  end


  ---| Quest_add_weapons |---

  LEVEL.added_weapons = {}

  if not EPISODE.seen_weapons then
    EPISODE.seen_weapons = {}
  end

  if OB_CONFIG.weapons == "none" then
    gui.printf("Weapon quota: NONE\n")
    return
  end


  -- decide how many weapons to give

  local quota = #LEVEL.zones * rand.range(0.66, 1.33)

  if OB_CONFIG.weapons == "less" then quota = quota / 1.7 end
  if OB_CONFIG.weapons == "more" then quota = quota * 1.7 end

  if OB_CONFIG.weapons == "mixed" then
    quota = quota * rand.pick({ 0.6, 1.0, 1.7 })
  end

  quota = quota * (PARAM.weapon_factor or 1)
  quota = int(quota + 0.5)

  if quota < 1 then quota = 1 end

  gui.printf("Weapon quota: %d\n", quota)


  -- decide which weapons to use

  local list = {}

  for k = 1, quota do
    local weapon = decide_weapon(k == 1)

    if not weapon then break; end

    table.insert(list, weapon)
  end

  if #list == 0 then
    gui.printf("Weapon list: NONE\n")
    return
  end


  quota = #list

  reorder_weapons(list)

  gui.printf("Weapon list:\n")
  each name in list do
    gui.printf("   %s\n", name)
  end


  -- distribute these weapons to the zones

  local counts = num_weapons_for_zones(quota)

  for i = 1, #LEVEL.zones do
    local Z = LEVEL.zones[i]

    for num = 1, counts[i] do
      local weapon = table.remove(list, 1)
      assert(weapon)

      add_weapon(Z, weapon, i == 1)
    end
  end

  -- ensure there is usually something (e.g. shotgun) in the
  -- starting room of the level

  if table.empty(LEVEL.start_room.weapons) then
    fallback_start_weapon()
  end

  -- mirror weapons in a Co-op alternate start room
  if LEVEL.alt_start then
    LEVEL.alt_start.weapons = table.copy(LEVEL.start_room.weapons)
  end
end



function Quest_do_hexen_weapons()
  -- TODO
end



function Quest_nice_items()
  --
  -- Decides which nice items, including powerups, to use on this level,
  -- especially for secrets but also for storage rooms, the start room,
  -- and (rarely) in normal rooms.
  --

  local mixed_mul = rand.pick({ 0.3, 1.0, 4.0 })

  local function adjust_powerup_probs(pal, factor)
    -- apply the "Powerups" setting from the GUI

    if not factor then factor = 5 end

    each name,info in GAME.NICE_ITEMS do
      if info.kind != "powerup" then continue end

      if not pal[name] then continue end

      if OB_CONFIG.powers == "none" then
        pal[name] = nil
      elseif OB_CONFIG.powers == "less" then
        pal[name] = pal[name] / factor
      elseif OB_CONFIG.powers == "more" then
        pal[name] = pal[name] * factor
      elseif OB_CONFIG.powers == "mixed" then
        pal[name] = pal[name] * mixed_mul
      end
    end
  end


  local function secret_palette()
    local pal = {}

    each name,info in GAME.NICE_ITEMS do
      if info.secret_prob then
        pal[name] = info.secret_prob
      end
    end

    adjust_powerup_probs(pal)

    return pal
  end


  local function normal_palette()
    local pal = {}

    each name,info in GAME.NICE_ITEMS do
      if info.add_prob then
        pal[name] = info.add_prob
      end
    end

    adjust_powerup_probs(pal)

    return pal
  end


  local function start_palette()
    local pal = {}

    -- Note: no powerups in start room

    each name,info in GAME.NICE_ITEMS do
      if info.kind == "powerup" then
        continue
      end

      local prob = info.start_prob or info.add_prob
      if prob then
        pal[name] = prob
      end
    end

    return pal
  end


  local function crazy_palette()
    local pal = {}

    each name,info in GAME.NICE_ITEMS do
      -- ignore secret-only items
      if not info.add_prob then continue end

      pal[name] = info.crazy_prob or 50
    end

    adjust_powerup_probs(pal)

    return pal
  end


  local function mark_item_seen(name)
    -- prefer not to use this item again

    local info = GAME.NICE_ITEMS[name]
    assert(info)

    if not LEVEL.secret_items[name] then return end

    if info.kind == "powerup" or info.kind == "weapon" then
      local old_prob = LEVEL.secret_items[name]

      LEVEL.secret_items[name] = old_prob / 8
    end
  end


  local function handle_secret_rooms()
    if table.empty(LEVEL.secret_items) then
      return
    end

    -- collect all secret leafs
    -- we need to visit them in random order
    local rooms = {}

    each Q in LEVEL.quests do
      each R in Q.secret_leafs do
        table.insert(rooms, R)
      end
    end

    rand.shuffle(rooms)

    each R in rooms do
      local item = rand.key_by_probs(LEVEL.secret_items)

      table.insert(R.items, item)
      mark_item_seen(item)

      gui.debugf("Secret item '%s' --> %s\n", item, R:tostr())
    end
  end


  local function eval_other_room(R)
    -- primary criterion is the room size.
    -- the final score will often be < 0

    local score = R.svolume

    -- never in secrets or the starting room
    if R.is_secret then return -1 end
    if R.purpose == "START" then return -1 end

    if R.purpose    then score = score - 8 end
    if R.is_storage then score = score - 30 end

    score = score - 16 * (#R.weapons + #R.items)

--!!!??    score = score - 1.4 * #R.conns

--[[ FIXME
    each C in R.conns do
      if C.kind == "teleporter" then
        score = score - 10 ; break
      end
    end
--]]

    -- tie breaker
    return score + rand.skew() * 5.0
  end


  local function choose_best_other_room()
    local best_R
    local best_score

    each R in LEVEL.rooms do
      local score = eval_other_room(R)

      if score > (best_score or 0) then
        best_R = R
        best_score = score
      end
    end

    return best_R  -- may be NIL
  end


  local function calc_extra_quota()
    local quota = (SEED_W + SEED_H) / rand.pick({ 10, 20, 35, 55, 80 })

    if OB_CONFIG.powers == "none" then return 0 end
    if OB_CONFIG.powers == "less" then return 0 end

    if OB_CONFIG.powers == "more"  then quota = 1 + quota * 2 end
    if OB_CONFIG.powers == "mixed" then quota = quota * rand.pick({ 0.5, 1, 2 }) end

    quota = int(quota + 0.7)

    gui.debugf("Extra bonus quota: %d\n", quota)

    return quota
  end


  local function handle_normal_rooms()
    -- collect all unused storage leafs
    -- (there is no need to shuffle them here)
    local rooms = {}

    each Q in LEVEL.quests do
      each R in Q.storage_leafs do
        if #R.weapons == 0 then
          table.insert(rooms, R)
        end
      end
    end

    -- add the start room too, sometimes twice
    table.insert(rooms, 1, LEVEL.start_room)

    if LEVEL.alt_start then
      table.insert(rooms, 1, LEVEL.alt_start)
    elseif rand.odds(25) then
      table.insert(rooms, 1, LEVEL.start_room)
    end

    -- choose items for each of these rooms
    local normal_tab = normal_palette()
    local  start_tab = start_palette()

    if OB_CONFIG.strength == "crazy" then
      normal_tab = crazy_palette()
       start_tab = crazy_palette()
    end

    each R in rooms do
      local tab

      if R.purpose == "START" then
        tab = start_tab
      else
        tab = normal_tab
      end

      if table.empty(tab) then continue end

      local item = rand.key_by_probs(tab)

      table.insert(R.items, item)
      mark_item_seen(item)

      gui.debugf("Nice item '%s' --> %s\n", item, R:tostr())
    end

    -- add extra items in a few "ordinary" rooms
    local quota = calc_extra_quota()

    for i = 1, quota do
      local R = choose_best_other_room()
      if not R then break; end

      if table.empty(normal_tab) then continue end

      local item = rand.key_by_probs(normal_tab)

      table.insert(R.items, item)
      mark_item_seen(item)

      gui.debugf("Extra item '%s' --> %s\n", item, R:tostr())
    end
  end


  ---| Quest_nice_items |---

  LEVEL.secret_items = secret_palette()
 
  handle_secret_rooms()
  handle_normal_rooms()

  -- TODO: extra health/ammo in every secret room
end



function Quest_select_textures()

  local function setup_cave_theme(R)
    R.main_tex = R.zone.cave_wall_mat

    for loop = 1,2 do
      R.floor_mat = rand.key_by_probs(LEVEL.cave_theme.naturals)
      if R.floor_mat != R.main_tex then break; end
    end

    if not R.is_outdoor then
      if rand.odds(20) then
        R.ceil_mat = rand.key_by_probs(LEVEL.cave_theme.naturals)
      elseif rand.odds(20) then
        R.ceil_mat = R.floor_mat
      else
        R.ceil_mat = R.main_tex
      end
    end
  end


  local function setup_theme(R)
    R.facade = assert(R.zone.facade_mat)

    if R.kind == "cave" then
      setup_cave_theme(R)
    else
      if R.is_outdoor then
        R.main_tex = R.zone.natural_mat
      else
        R.main_tex = rand.key_by_probs(R.theme.walls)
      end
    end

    -- create a skin (for prefabs)
    R.skin =
    {
      wall  = R.main_tex
      floor = R.floor_mat
      ceil  = R.ceil_mat
    }
  end


  local function total_volume_of_room_kind(kind)
    local vol = 0

    each R in LEVEL.rooms do
      if R.kind == kind then
        vol = vol + R.svolume
      end
    end

    return vol
  end


  ---| Quest_select_textures |---

  local outdoor_volume = total_volume_of_room_kind("outdoor")
  local cave_volume    = total_volume_of_room_kind("cave")

  gui.debugf("outdoor_volume : %d\n", outdoor_volume)
  gui.debugf("cave_volume : %d\n", cave_volume)


  if THEME.fences then
    LEVEL.fence_mat = rand.key_by_probs(THEME.fences)
  end


  each Z in LEVEL.zones do
    -- when outdoors is limited, prefer same texture in each room
    if _index >= 2 and outdoor_volume < 140 then
      Z.natural_mat = LEVEL.zones[1].natural_mat
    else
      Z.natural_mat = rand.key_by_probs(LEVEL.outdoors_theme.naturals)
    end

    -- similarly for caves, if not many then use a consistent texture
    if _index >= 2 and cave_volume < 180 then
      Z.cave_wall_mat = LEVEL.zones[1].cave_wall_mat
    else
      Z.cave_wall_mat = rand.key_by_probs(LEVEL.cave_theme.naturals)
    end

    if LEVEL.hallway_theme then
      local theme = LEVEL.hallway_theme
      Z.hall_tex   = rand.key_by_probs(theme.walls)
      Z.hall_floor = rand.key_by_probs(theme.floors)
      Z.hall_ceil  = rand.key_by_probs(theme.ceilings)
    end

    Z.corner_mats = Z.building_theme.corners or THEME.corners
  end


  each R in LEVEL.rooms do
    setup_theme(R)
  end

  each R in LEVEL.scenic_rooms do
    setup_theme(R)
  end
end



function Quest_final_battle()
  -- Generally the last battle of the map is in the EXIT room.
  -- however the previous room will often be a better place, so
  -- look for that here.  [ Idea for this by flyingdeath ]

  ---| Quest_final_battle |---

  local E = assert(LEVEL.exit_room)

  gui.printf("Exit room: %s\n", E:tostr())

  -- will clear this if we choose a different room
  E.final_battle = true

  -- check previous room...
  assert(E.entry_conn)

  local prev = E.entry_conn:neighbor(E)

  if prev.purpose == "START" then return end

  -- a locked connection means the player must do other stuff first
  -- (find a key or switch) -- hence other room would not be _THE_
  -- final battle.
  if E.entry_conn.lock then return end

  if prev.svolume > (E.svolume * 1.4 + 2) then
    -- always pick previous room if significantly bigger

  elseif E.svolume > (prev.svolume * 1.4 + 2) then
    -- never pick if significantly smaller
    return

  else
    -- rooms are roughly similar sizes
    if rand.odds(25) then return end
  end

  -- OK --

  E.final_battle = false
  E.cool_down = true

  prev.final_battle = true
  prev.cool_down = false

  gui.printf("Final Battle in %s\n", prev:tostr())
end



function Quest_choose_themes()
  --
  --  FIXME: describe this...
  --

  local function match_level_theme(name)
    local kind = string.match(name, "([%w]+)_")

    if string.match(name, "DEFAULT") then return false end

    return (kind == LEVEL.theme_name) or (kind == "generic")
  end


  local function collect_usable_themes(kind)
    local tab = {}

    each name,info in GAME.THEMES do
      if info.kind == kind and match_level_theme(name) then
        tab[name] = info.prob or 50
      end
    end

    return tab
  end


  local function pick_zone_theme(theme_tab, previous)
    assert(theme_tab)

    if table.empty(theme_tab) then
      error("pick_zone_theme: nothing matched!")
    end

    local tab = table.copy(theme_tab)

    -- prefer not to use same theme as the last one
    for n = 1,2 do
      local prev = previous and previous[n]
      local factor = sel(i == 1, 5, 2)

      if prev and tab[prev] then
        tab[prev] = tab[prev] / factor
      end
    end

    local name = rand.key_by_probs(tab)

    return assert(GAME.THEMES[name])
  end


  local function themes_for_zones()
    local tab = {}

    LEVEL.outdoors_theme  = pick_zone_theme(collect_usable_themes("outdoors"))
    LEVEL.cave_theme      = pick_zone_theme(collect_usable_themes("cave"))
    LEVEL.hallway_theme   = pick_zone_theme(collect_usable_themes("hallway"))
    LEVEL.stairwell_theme = pick_zone_theme(collect_usable_themes("stairwell"))

    local building_tab = collect_usable_themes("building")

    -- Note: this logic is not ideal, since zones are not necessarily
    --       linear, e.g. zones[3] may be entered from zones[1]
    local previous = {}

    each Z in LEVEL.zones do
      Z.building_theme = pick_zone_theme(building_tab, previous)

      table.insert(previous, 1, Z.building_theme)
    end
  end


  local function themes_for_rooms()
    local all_rooms = {}
    table.append(all_rooms, LEVEL.rooms)
    table.append(all_rooms, LEVEL.scenic_rooms)

    each R in all_rooms do
      local Z = assert(R.zone)

      -- Note: hallways and stairwells have not been decided yet

      if R.kind == "cave" then
        R.theme = Z.cave_theme or LEVEL.cave_theme
      elseif R.is_outdoor then
        R.theme = Z.outdoors_theme or LEVEL.outdoors_theme
      else
        R.theme = Z.building_theme or LEVEL.building_theme
      end

      assert(R.theme)
    end
  end


  local function facades_for_zones()
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

    -- FIXME !!!!  bottom up approach...

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

--[[ DEBUG
    gui.debugf("Pictures for zones:\n")
    each Z in LEVEL.zones do
      gui.debugf("ZONE_%d =\n%s\n", Z.id, table.tostr(Z.pictures))
    end
--]]
  end


  ---| Quest_choose_themes |---

  themes_for_zones()
  themes_for_rooms()

  facades_for_zones()

  pictures_for_zones()
end



function Quest_make_quests()

  gui.printf("\n--==| Make Quests |==--\n\n")

  Monsters_max_level()

  -- need at least a START room and an EXIT room
  if #LEVEL.rooms < 2 then
    error("Level only has one room! (2 or more are needed)")
  end

  LEVEL.quests = {}
  LEVEL.zones  = {}
  LEVEL.locks  = {}

  Quest_create_initial_quest()

--!!!!!!  Quest_add_major_quests()

  Quest_start_room()

  Quest_group_into_zones()
  Quest_order_by_visit()

  Quest_add_minor_quests()

---???  Quest_final_battle()

---!!!  Connect_reserved_rooms()

  Area_spread_zones()

  Quest_choose_themes()
  Quest_select_textures()

  -- special weapon handling for HEXEN and HEXEN II
  if PARAM.hexen_weapons then
    Quest_do_hexen_weapons()
  else
--!!!!!!    Quest_add_weapons()
  end

--!!!!  Quest_nice_items()
end

