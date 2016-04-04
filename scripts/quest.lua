------------------------------------------------------------------------
--  QUEST ASSIGNMENT
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2016 Andrew Apted
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

    rooms[id] : ROOM

    svolume   : total svolume of all rooms

    entry : ROOM

    goals : list(GOAL)

    parent_node : QUEST_NODE

--]]


--class QUEST_NODE
--[[
    --
    -- The quests are placed in a binary tree.  The QUEST objects are the
    -- leaves, and this structure represents the nodes.
    --

    node_id : number   (distinguishes nodes from quests)

    before  : NODE or QUEST
    after   : NODE or QUEST

    conn : CONN  -- where the division occurred
--]]


--class ZONE
--[[
    --
    -- A zone is a group of rooms and areas which form a distinct
    -- section of the map.  Zones are always separated by walls,
    -- except at room connections which cross a zone barrier.
    --

    id, name  -- debugging aids

    rooms : list(ROOM)
    areas : list(AREA)

    sky_h : number   -- height of sky for this zone


    === Theme stuff ===

    cave_theme     : ROOM_THEME
    hallway_theme  : ROOM_THEME
    outdoor_theme  : ROOM_THEME
    building_theme : ROOM_THEME

    facade_mat      -- material for outer walls of buildings
    other_facade    -- another one

    fence_mat       -- material for fences

    cave_wall_mat   -- main material for cave walls


    === Monster stuff ===

    mon_palette     -- palette of monsters for this zone
                    -- [ a table of mon=prob pairs ]

    weap_palette    -- weapon usage palette

--]]


--class GOAL
--[[
    kind : keyword  --  "KEY" or "SWITCH" or "EXIT" or "SECRET_EXIT"

    item : keyword  -- name of key or switch

    special : number  -- linedef special for switches

    lock : LOCK   -- lock which this solves  (NIL for exit goals)

    room : AREA   -- where the goal is

    tag : number  -- tag number to use for a switched door
--]]


--class LOCK
--[[
    goals : list(GOAL)  -- the goal(s) which solve the lock

    conn : CONN         -- connection which is locked
--]]


--------------------------------------------------------------]]


function Quest_new()
  local id = 1 + #LEVEL.quests

  local QUEST =
  {
    id = id
    name  = "QUEST_" .. id
    rooms = {}
    goals = {}
    svolume = 0
  }

  table.insert(LEVEL.quests, QUEST)

  return QUEST
end


function QuestNode_new()
  local NODE =
  {
    node_id = alloc_id("quest_node")
  }

  return NODE
end


function Zone_new()
  local id = 1 + #LEVEL.zones

  local ZONE =
  {
    id = id
    name = "ZONE_" .. id
    rooms = {}
    areas = {}
  }

  table.insert(LEVEL.zones, ZONE)

  return ZONE
end


function Goal_new(kind)
  local id = alloc_id("goal")

  local GOAL =
  {
    id = id
    name = "GOAL_" .. (kind or "XX") .. "_" .. id
    kind = kind
  }

  return GOAL
end



function size_of_room_set(rooms)
  local total = 0

  each id, R in rooms do
    total = total + R.svolume
  end

  return total
end



function Quest_create_initial_quest()
  --
  -- Turns the whole map into a single Quest object, and pick an exit room
  -- as the goal of the quest.
  --
  -- This quest can be divided later on into major and minor quests.
  --

  local function eval_exit_room(R, secret_mode)
    if R.kind == "hallway"   then return -1 end
    if R.kind == "stairwell" then return -1 end

    if R.is_exit then return -1 end

    -- must be a leaf room
    if R:total_conns() > 1 then return -1 end

    -- cannot teleport into a secret exit
    -- [ WISH : support this, a secret teleporter closet somewhere ]
    if secret_mode and R:has_teleporter() then return -1 end

    -- don't waste big rooms on a secret exit
    if secret_mode then
      return 100 - math.min(R.svolume,99) + gui.random()
    end

    local score = R.svolume

    return score + gui.random() * 10
  end


  local function pick_exit_room(secret_mode)
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

    return best
  end


  local function add_normal_exit(quest)
    local R = pick_exit_room()

    if not R then
      error("Unable to pick exit room!")
    end

    gui.printf("Exit room: %s\n", R.name)

    R.is_exit = true

    LEVEL.exit_room = R

    -- create the goal for the entire map
    local GOAL = Goal_new("EXIT")

    GOAL.room = R

    table.insert(R.goals, GOAL)
    table.insert(quest.goals, GOAL)

    R.used_chunks = R.used_chunks + 1
  end


  local function add_secret_exit()
    -- check if needed ?
    if not LEVEL.secret_exit then
      return
    end

    -- FIXME : support secret exits again
    do return end

    local R = pick_exit_room("secret_mode")

    if not R then
      gui.printf("WARNING : no room for secret exit!\n")
      return
    end

    -- OK --

    gui.printf("Secret Exit: %s\n", R.name)

    R.is_exit = true

    LEVEL.secret_exit = R

    Quest_make_room_secret(R)

    local GOAL = Goal_new("SECRET_EXIT")

    table.insert(R.goals, GOAL)
    R.used_chunks = R.used_chunks + 1
  end


  ---| Quest_create_initial_quest |---

  local Q = Quest_new()

  -- this quest becomes head of the quest tree
  LEVEL.quest_root = Q

  each R in LEVEL.rooms do
    R.quest = Q

    Q.rooms[R.id] = R
    Q.svolume = Q.svolume + R.svolume
  end

  add_normal_exit(Q)
  add_secret_exit()
end



function Quest_eval_divide_at_conn(C, goal, info)
  --
  -- Evaluate whether we can divide a quest at the given connection,
  -- locking up the given goal (which already exists in the quest).
  --
  -- The 'info' table contains the current best division (if any),
  -- and contains the following input fields:
  --
  --    lock_kind : the lock to place on the connection
  --    new_goals : goals used to solve the lock (usually 1)
  --
  -- and the following output fields:
  --
  --    score   :  best current score  (must be initialised to zero)
  --    conn    :  the best connection  [ NIL if none yet ]
  --    goal    :  the goal to lock up
  --    quest   :  the quest to divide
  --
  --    before  :  room set of first half
  --    after   :  room set of second half
  --    leafs   :  list of rooms place goals (#leafs >= #new_goals)
  --

  local quest  -- current quest


  local function same_quest(C2)
    return C2.R1.quest == C2.R2.quest
  end


  local function collect_rooms(R, list)
    list[R.id] = R

    each C2 in R.conns do
      -- never pass through connection we are examining
      if C2 == C then continue end

      if not same_quest(C2) then continue end

      local R2
      if C2.R1 == R then
        R2 = C2.R2
      else
        R2 = C2.R1
      end

      -- already seen?
      if list[R2.id] then continue end

      collect_rooms(R2, list)
    end

    return list
  end


  local function room_exits_in_set(R, rooms)
    local count = 0

    each C in R.conns do
      local R2 = C:other_room(R)

      if rooms[R2.id] then count = count + 1 end
    end

    assert(count > 0)

    return count
  end


  local function unused_rooms_in_set(rooms)
    local leafs = {}

    each id, R in rooms do
      if R.is_secret then continue end

      if R.kind == "hallway"   then continue end
      if R.kind == "stairwell" then continue end

      -- some goals already?
      if #R.goals > 0 then continue end

      if quest.entry and quest.entry == R then continue end

      -- skip the room immediately next to the proposed connection
      if C.R1 == R or C.R2 == R then continue end

      if room_exits_in_set(R, rooms) == 1 then
        table.add_unique(leafs, R)
      end
    end

    return leafs
  end


  local function check_has_goal(rooms)
    if goal.room and rooms[goal.room.id] then
      return true
    end

    return false
  end


  local function eval_split_possibility(C, before, after, before_R, after_R)
    local before_size = size_of_room_set(before)
    local  after_size = size_of_room_set(after)

    local score = 300

    -- strongly prefer not to enter a hallway from a locked door
    if after_R.kind == "stairwell" then
      score = score - 200
    elseif after_R.kind == "hallway" then
      score = score - 100
    end

    -- try to avoid very unbalanced splits

    local   min_size = math.min(before_size, after_size)
    local total_size = before_size + after_size

    local frac = min_size / total_size

    if frac < 0.166 then
      score = score - 20
    elseif frac < 0.333 then
      score = score - 10
    end

    -- tie breaker
    return score + gui.random()
  end


  ---| Quest_eval_divide_at_conn |---

gui.debugf("  goal: %s/%s @ %s / %s\n", goal.kind or "???", goal.item or "???",
goal.room.name, goal.room.quest.name)

  -- must be same quest (caller guarantees this)
  assert(C.R1.quest == C.R2.quest)

  -- cannot lock teleporter connections
  if C.kind == "teleporter" then return end

  quest = C.R1.quest

gui.debugf("  quest : %s\n", quest.name)

  -- must not divide a room in half
  if C.R1 == C.R2 then
    return
  end

  -- collect rooms on each side of the connection
  local before = collect_rooms(C.R1, {})
  local  after = collect_rooms(C.R2, {})

--[[
stderrf("BEFORE =\n  ")
each id,_ in before do stderrf("%d ", id) end stderrf("\n\n")
stderrf("AFTER =\n  ")
each id,_ in after do stderrf("%d ", id) end stderrf("\n\n")
--]]

  local before_R = C.R1
  local  after_R = C.R2

  if check_has_goal(after) then
    -- OK
  elseif check_has_goal(before) then
    before, after = after, before
    before_R, after_R = after_R, before_R
  else
    error("Cannot find goal inside quest")
  end

  -- entry of quest MUST be in first half
  if quest.entry then
    if not before[quest.entry.id] then
      assert(after[quest.entry.id])
      return
    end
  end

  -- no locking end of hallways
  if before_R.kind == "hallway" or before_R.kind == "stairwell" then
    return
  end

  local leafs = unused_rooms_in_set(before)

  if #leafs < #info.new_goals then return end

  local score = eval_split_possibility(C, before, after, before_R, after_R)

gui.debugf("--> possible @ %s : score %1.1f\n", C.name, score)

  if score > info.score then
    info.score  = score

    info.conn   = C
    info.goal   = goal
    info.quest  = quest
    info.leafs  = leafs

    info.before   = before
    info.before_R = before_R
    info.after    = after
    info.after_R  = after_R
  end
end


function Quest_perform_division(info)
  --
  -- Splits the current quest into two, adding the new quest into the
  -- binary tree.  Also locks the connection.
  --

  local function create_lock()
    local LOCK =
    {
      goals = info.new_goals
      conn  = info.conn
    }

    return LOCK
  end


  local function replace_with_node(Q, new_node)
    if not Q.parent_node then
      assert(LEVEL.quest_root == Q)
      LEVEL.quest_root = new_node
      return
    end

    if Q.parent_node.before == Q then
       Q.parent_node.before = new_node
      return
    end

    if Q.parent_node.after == Q then
       Q.parent_node.after = new_node
      return
    end

    error("Bad parent_node in quest")
  end


  local function assign_quest(Q)
    each id, R in Q.rooms do
      R.quest = Q
    end
  end


  local function transfer_existing_goals(Q1, Q2)
gui.debugf("transfer_existing_goals:\n")
    for i = #Q2.goals, 1, -1 do
      local targ = Q2.goals[i]

      if targ.room and targ.room.quest == Q1 then
gui.debugf("   %s\n", targ.name)
        table.insert(Q1.goals, table.remove(Q2.goals, i))
      end
    end
  end


  local function eval_goal_room(Q1, R)
    local score = 100

    -- TODO : compute travel distance from R to where goal is used

    score = score + R:usable_chunks() * 10

    -- tie breaker
    return score + gui.random()
  end


  local function pick_room_for_goal(Q1)
    local best
    local best_score = 0

    each R in info.leafs do
      local score = eval_goal_room(Q1, R)

      if score > best_score then
        best = R
        best_score = score
      end
    end

    assert(best)

    table.kill_elem(info.leafs, best)

    return best
  end


  local function place_goal_in_room(Q1, R, goal)
    goal.room = R

    table.insert( R.goals, goal)
    table.insert(Q1.goals, goal)

    R.used_chunks = R.used_chunks + 1

    -- for switched doors we need a tag value
    if goal.same_tag then
      goal.tag = assert(info.new_goals[1].tag)
    elseif goal.kind == "SWITCH" then
      goal.tag = alloc_id("tag")
    end
  end


  local function place_new_goals(Q1)
    assert(#info.leafs >= #info.new_goals)

    rand.shuffle(info.leafs)

gui.debugf("PLACING NEW GOALS:\n")

    each goal in info.new_goals do
      local R = pick_room_for_goal(Q1)

gui.debugf("  %s @ %s in %s\n", goal.name, R.name, Q1.name)

      place_goal_in_room(Q1, R, goal)
    end
  end


  local function downgrade_stairwell(A)
    A.room.kind = "hallway"

    A.is_stairwell = nil

    if A.sister then
      downgrade_stairwell(A)
    end
  end


  local function check_special_rooms()
    -- we don't want stairwells to be locked

    local C = info.conn

    if C.A1.is_stairwell then downgrade_stairwell(C.A1) end
    if C.A2.is_stairwell then downgrade_stairwell(C.A2) end
  end


  ---| Quest_perform_division |---

  -- create the node
  local node = QuestNode_new()

  local Q2 = assert(info.quest)

  -- create the new quest
  -- (for the first half, existing quest becomes second half)

  local Q1 = Quest_new()

gui.debugf("Dividing %s,  first half is %s\n", Q2.name, Q1.name)


  -- link quests into node heirarchy

  node.before = Q1
  node.after  = Q2
  node.conn   = info.conn

  replace_with_node(Q2, node)

  Q1.parent_node = node
  Q2.parent_node = node


  -- setup quests, transfer stuff

  Q1.entry = Q2.entry
  Q2.entry = info.after_R

  Q1.rooms = info.before
  Q2.rooms = info.after

  Q1.svolume = size_of_room_set(Q1.rooms)
  Q2.svolume = size_of_room_set(Q2.rooms)

  assign_quest(Q1)
  assign_quest(Q2)

  -- do this AFTER assigning new 'quest' fields
  transfer_existing_goals(Q1, Q2)


  -- lock the connection
  local LOCK = create_lock()

  info.conn.lock = LOCK

  check_special_rooms()


  -- finally, add the new goals to the first quest
  place_new_goals(Q1)

  assert(not table.empty(Q1.goals))
  assert(not table.empty(Q2.goals))
end



function Quest_scan_all_conns(new_goals, do_quest)
  -- do_quest can be NIL, or a particular quest to try dividing

  gui.debugf("Quest_scan_all_conns.....\n")

  local info =
  {
    new_goals = new_goals
    score = 0
  }


  each C in LEVEL.conns do
    local quest = C.R1.quest
    assert(quest)

    if do_quest and quest != do_quest then continue end

    -- must be same quest on each side
    if C.R2.quest != quest then continue end

    each goal in quest.goals do
      Quest_eval_divide_at_conn(C, goal, info)
    end
  end


  -- nothing possible?
  if not info.conn then

gui.debugf("---> NOTHING POSSIBLE\n")
    return false
  end


  gui.printf("Dividing %s @ %s (%s -- %s)\n", info.quest.name,
             info.conn.name, info.conn.R1.name, info.conn.R2.name)

gui.debugf("   VIA: %s (x%d)\n", info.new_goals[1].item or "???", #info.new_goals)
gui.debugf("   Entry: %s\n", (info.quest.entry and info.quest.entry.name) or "--")

  Quest_perform_division(info)
  return true
end



function Quest_add_major_quests()
  --
  -- Divides the map into major quests, typically requiring a key to
  -- progress between the quests.
  --

  local function count_unused_leafs(quest)
    local unused = 0

    each id, R in quest.rooms do
      if R:is_unused_leaf() then
        unused = unused + 1
      end
    end

    return unused
  end


  local function collect_key_goals(list)
    local key_tab = LEVEL.usable_keys or THEME.keys or {}

    each name,_ in key_tab do
      local GOAL = Goal_new("KEY")

      GOAL.item = name
      GOAL.prob = 100

      table.insert(list, GOAL)
    end
  end


  local function collect_switch_goals(list)
--FIXME
do return false end

    if not THEME.switches then return {} end

    local skip_prob = style_sel("switches", 100, 20, 0, 0)
    if rand.odds(skip_prob) then return {} end

    -- we want at least four kinds, so duplicate some if necessary
    local switch_tab = THEME.switches

    local dup_num
    if table.size(switch_tab) < 2 then
      dup_num = 4
    elseif table.size(switch_tab) < 4 then
      dup_num = 2
    else
      dup_num = 1
    end

    for loop = 1, dup_num do
      each name,_ in switch_tab do
        local GOAL = Goal_new("SWITCH")

        GOAL.item = name
        GOAL.action = 103  -- open door
        GOAL.prob = 25

        table.insert(list, GOAL)
      end
    end
  end


  local function pick_goal(list)
    if table.empty(list) then
      return nil
    end

    local prob_tab = {}

    each G in list do
      prob_tab[_index] = assert(G.prob)
    end

    local idx = rand.index_by_probs(prob_tab)

    return table.remove(list, idx)
  end


  local function add_triple_key_door(key_list)
--FIXME
do return false end

    if #key_list < 3 then return false end

    -- FIXME: check "game" field in prefab def
    if not THEME.has_triple_key_door then return false end

    local prob = 25

    if OB_CONFIG.mode == "coop" then
      prob = 50
    end

    if not rand.odds(prob) then return false end

    rand.shuffle(key_list)

    local K1 = table.remove(key_list, 1)
    local K2 = table.remove(key_list, 1)
    local K3 = table.remove(key_list, 1)

    assert(K1 and K2 and K3)
    assert(K3.kind == "KEY")

    return Quest_scan_all_conns({ K1, K2, K3 })
  end


  local function add_double_switch_door(quest)
--FIXME
do return false end


    local prob = 25

    if OB_CONFIG.mode == "coop" then
      prob = 75
    end

    if not rand.odds(prob) then return false end

    -- this is VERY dependent on the sw_pair.wad prefab
    local fab_def = PREFABS["Locked_double"]
    assert(fab_def)

    -- FIXME: check "game" in prefab
    if not THEME.has_double_switch_door then return false end

    local GOAL1 = Goal_new("SWITCH")
    local GOAL2 = Goal_new("SWITCH")

    GOAL1.item = "sw_metal"
    GOAL1.action = fab_def.action1

    GOAL2.item = "sw_metal"
    GOAL2.action = fab_def.action2
    GOAL2.same_tag = true

    return Quest_scan_all_conns({ GOAL1, GOAL2 }, quest)
  end


  local function lock_up_double_doors()
    local list = table.copy(LEVEL.quests)

    each Q in list do
      if count_unused_leafs(Q) >= 3 then
        add_double_switch_door(Q)
      end
    end
  end


  -- index by unused :  1   2   3    4
  local LOCK_PROBS = { 10, 60, 90, 100 }


  local function lock_up_a_quest(quest, goal_list)
    -- the goal is removed from goal_list

    local unused = count_unused_leafs(quest)

    if quest.no_more_locks then return end

    if unused < 1 then return end
    if unused > 4 then unused = 4 end

    if not rand.odds(LOCK_PROBS[unused]) then
--!!!! FIXME      quest.no_more_locks = true
--!!!! FIXME      return
    end

    local goal = pick_goal(goal_list)

    if goal then
      Quest_scan_all_conns({ goal }, quest)
    end
  end


  local function lock_up_quests(goal_list)
    local list = table.copy(LEVEL.quests)
    rand.shuffle(list)

    each Q in list do
      lock_up_a_quest(Q, goal_list)
    end
  end


  ---| Quest_add_major_quests |---

  -- use keys to lock zone connections

  local goal_list = {}

  collect_key_goals(goal_list)

  -- triple key door?

  if rand.odds(50*2) then
    if add_triple_key_door(goal_list) then
      LEVEL.has_triple_key = true
      goal_list = { }
    end
  end

  -- normal keyed doors...

  for pass = 1, 6 do
    lock_up_quests(goal_list)
  end 


  goal_list = {}

  collect_switch_goals(goal_list)


  -- double switched doors
  -- [ never make them if disabled by "switches" style ]

  if not table.empty(goal_list) then
    lock_up_double_doors()
  end


  -- lastly, normal switched doors

  for pass = 1, 4 do
    lock_up_quests(goal_list)
  end


each Q in LEVEL.quests do
Q.svolume = size_of_room_set(Q.rooms)
end

end



function Quest_create_zones()
  --
  -- Divides the map into a few distinct sections.
  --

  local function calc_quota()
    --
    -- determine # of zones based on total used seeds
    --
    local total_svol = 0

    each A in LEVEL.areas do
      if A.room then
        total_svol = total_svol + A.svolume
      end
    end

    local num = rand.int(total_svol / 240)

---##  stderrf("Map size : %d seeds --> %1.2f ZONES\n", total_svol, num)

    num = math.clamp(1, num, 5)

    gui.printf("Zone quota: %d\n", num)

    return num
  end


  local function assign_area(A, zone)
    if A.zone then return end

    A.zone = zone

    table.insert(zone.areas, A)
  end


  local function assign_room(R, zone)
    -- already has a zone?
    if R.zone then return end

    R.zone = zone

    table.insert(zone.rooms, R)

    each A in R.areas do
      assign_area(A, zone)
    end
  end


  local function other_zone(unwanted_zone)
    local list = {}

    each Z in LEVEL.zones do
      if Z != unwanted_zone then
        table.insert(list, Z)
      end
    end

    if table.empty(list) then
      return unwanted_zone
    end

    return rand.pick(list)
  end


  local function check_if_finished()
    each R in LEVEL.rooms do
      if not R.zone then return false end
    end

    return true
  end


  local function spread_zones_via_conns(do_locks)
    local conn_list = table.copy(LEVEL.conns)
    rand.shuffle(conn_list)

    each C in conn_list do
      local R = C.R1
      local N = C.R2

      if R.zone and N.zone then continue end

      if not R.zone then R, N = N, R end
      if not R.zone then continue end

      -- prefer not to cross quest boundaries
      if C.lock and not do_locks then continue end

      if C.is_secret or C.kind == "teleporter" or C.lock then
        assign_room(N, other_zone(R.zone))

        -- only do one locked connection per group
        if C.lock then return end

        continue
      end

      if rand.odds(50) then
        assign_room(N, R.zone)
      end
    end

-- stderrf("spread_zones_via_conns: done = %s\n", string.bool(is_done))

    return is_done
  end


  local function sort_zones()
    each Z in LEVEL.zones do
      Z.min_along = 99

      each R in Z.rooms do
        Z.min_along = math.min(Z.min_along, R.lev_along)
      end
    end

    table.sort(LEVEL.zones, function(A, B)
        return A.min_along < B.min_along end)
  end


  local function dump_zones()
    gui.printf("Zone list:\n")

    each Z in LEVEL.zones do
      gui.printf("  %s : rooms:%d areas:%d\n", Z.name, #Z.rooms, #Z.areas)
    end
  end


  ---| Quest_create_zones |---

  local quota = calc_quota()

  if quota > #LEVEL.quests then
     quota = #LEVEL.quests
  end

  -- handle exit room first
  local exit_zone = Zone_new()

  assign_room(LEVEL.exit_room, exit_zone)

  -- start room(s) are usually the 2nd zone
  local start_zone = exit_zone

  if quota >= 2 then
    start_zone = Zone_new()
  end

  each R in LEVEL.rooms do
    if R.is_start then
      assign_room(R, start_zone)
    end
  end

  -- handle quest entry rooms
  local quest_list = table.copy(LEVEL.quests)
  rand.shuffle(quest_list)

  each Q in quest_list do
    -- hit the quota limit?
    if #LEVEL.zones >= quota then break; end

    local R = Q.entry

    if not R or R.zone then continue end

    if table.has_elem(Q.rooms, LEVEL.exit_room) then
      --???  assign_room(R, exit_zone)
      continue
    end

    assign_room(R, Zone_new())
  end

  -- flow zones between room connections
  while not check_if_finished() do
    for loop = 1, 50 do
      spread_zones_via_conns(loop == 50)
    end
  end

  -- sanity check
  each R in LEVEL.rooms do
    assert(R.zone)
  end

  sort_zones()

  Area_spread_zones()

  dump_zones()
end


------------------------------------------------------------------------


function Quest_calc_exit_dists()
  --
  -- For each room, determine a distance metric for the room to the
  -- nearest exit of the quest, which may be the level's exit room.
  -- If a quest does not have any exits, rooms will lack a dist.
  --


  local function mark_exit_to_quest(Q)
    -- find the room which exits into the given quest
    local exit_R

    each C in LEVEL.conns do
      if C.R1 == Q.entry and C.R2.quest != Q then
        exit_R = C.R2
        break;
      end

      if C.R2 == Q.entry and C.R1.quest != Q then
        exit_R = C.R1
        break;
      end
    end

    if exit_R then
      assert(exit_R.quest != Q)
      exit_R.dist_to_exit = 0
    end
  end


  local function spread_through_conn(C)
    local R1 = C.R1
    local R2 = C.R2

    -- NEVER cross quest boundaries
    if R1.quest != R2.quest then return false end

    if not R1.dist_to_exit then
      R1, R2 = R2, R1
    end

    if not R1.dist_to_exit then
      return false
    end

    local step = 1.0

    if R1.kind == "hallway" or R2.kind == "hallway" then
      step = 0.3
    end

    local new_dist = R1.dist_to_exit + step

    if not R2.dist_to_exit or (R2.dist_to_exit > new_dist) then
      R2.dist_to_exit = new_dist
      return true
    end

    return false
  end


  local function spread_dists()
    local did_spread = false

    each C in LEVEL.conns do
      if spread_through_conn(C) then
        did_spread = true
      end
    end

    return did_spread
  end


  ---| Quest_calc_exit_dists |---

  LEVEL.exit_room.dist_to_exit = 0

  each Q in LEVEL.quests do
    mark_exit_to_quest(Q)
  end

  for loop = 1,99 do
    if not spread_dists() then break; end
  end
end



function Quest_start_room()

  local start_quest


  local function find_start_quest()
    -- will be the quest without a current 'entry' area
    each Q in LEVEL.quests do
      if not Q.entry then
        start_quest = Q
        return
      end
    end

    error("Failed to find starting quest")
  end


  local function eval_start_room(R, alt_mode)
    local score = 1

    -- never in a stairwell
    if R.kind == "stairwell" then
      return -1
    end

    -- never in a hallway
    -- TODO : occasionally allow it -- but require a closety void area nearby
    --        which we can use for a start closet
    if R.kind == "hallway" then
      return -1
    end

    -- really really don't want to see a goal (like a key)
    if #R.goals > 0 then
      if alt_mode then return -1 end
    else
      score = score + 1000
    end

    -- need somewhere for starting pad, weapon and nice item
    local space = math.min(3, R:usable_chunks())
    score = score + space * 20

    -- far away from first locked door (or exit room)
    score = score + (R.dist_to_exit or 0) * 25

    -- prefer indoors
    if not R.is_outdoor then score = score + 7 end

    -- prefer no teleporter
    if not R:has_teleporter() then score = score + 1 end

    gui.debugf("eval_start_room in %s --> space:%d dist:%d %1.2f\n", R.name, space, R.dist_to_exit or -1, score)

    -- tie breaker
    return score + gui.random() * 2
  end


  local function pick_best_start(alt_mode)
    local best_R
    local best_score = 0

    each R in LEVEL.rooms do
      if R.quest != start_quest then continue end

      local score = eval_start_room(R, alt_mode)

      if score > best_score then
        best_R = R
        best_score = score
      end
    end

    return best_R
  end


  local function add_normal_start()
    local R = pick_best_start()

    if not R then
      error("Could not find a usable start room")
    end

    gui.printf("Start room: %s\n", R.name)

    R.is_start = true

    LEVEL.start_room  = R
    start_quest.entry = R

    local GOAL = Goal_new("START")

    table.insert(R.goals, GOAL)
    R.used_chunks = R.used_chunks + 1
  end


  local function partition_coop_players()
    --
    -- partition players between the two rooms.  Since Co-op is often
    -- played by two people, have a large tendency to place 'player1'
    -- and 'player2' in different rooms.
    --

    local set1, set2

    if rand.odds(10) then
      set1 = { "player1", "player2", "player5", "player6" }
      set2 = { "player3", "player4", "player7", "player8" } 
    elseif rand.odds(50) then
      set1 = { "player1", "player3", "player5", "player7" }
      set2 = { "player2", "player4", "player6", "player8" } 
    else
      set1 = { "player1", "player4", "player6", "player7" }
      set2 = { "player2", "player3", "player5", "player8" } 
    end

    if rand.odds(50) then
      set1, set2 = set2, set1
    end

    LEVEL.start_room.player_set = set1
    LEVEL.alt_start .player_set = set2
  end


  local function find_alternate_start()
    -- only for Co-operative games
    if OB_CONFIG.mode != "coop" then return end

    -- disabled by gameplay_tweaks module?
    if PARAM.start_together then return end

    local R = pick_best_start("alt_mode")

    if not R then return end

    -- OK --

    gui.printf("Alternate Start room: %s\n", R.name)

    R.is_start = true

    LEVEL.alt_start = R

    local GOAL = Goal_new("START")

    GOAL.alt_start = true

    table.insert(R.goals, GOAL)
    R.used_chunks = R.used_chunks + 1

    partition_coop_players()
  end


  ---| Quest_start_room |---

  Quest_calc_exit_dists()

  find_start_quest()

  add_normal_start()

  find_alternate_start()
end



function Quest_order_by_visit()
  --
  -- Put all rooms in the level into the order the player will most
  -- likely visit them.  When there are choices or secrets, then the
  -- order chosen here will be quite arbitrary.
  --

  local room_along  = 1
  local quest_along = 1


  local function visit_quest_node(Q)
    if Q.node_id then
      visit_quest_node(Q.before)
      visit_quest_node(Q.after)
      return
    end

    Q.lev_along = quest_along / #LEVEL.quests

    quest_along = quest_along + 1
  end

 
  local function visit_room(R, quest, via_conn_name)
--stderrf("visit_room %s (via %s) for %s\n", R.name, via_conn_name or "???", quest.name or "???")
    R.lev_along = room_along / #LEVEL.rooms

    room_along = room_along + 1

    assert(R.quest == quest)

    each C in R.conns do
--stderrf("  conn '%s'  %s <--> %s\n", C.name, C.R1.name, C.R2.name)
      assert(C.R1)

      local R2 = C:other_room(R)

      if R2.quest != quest then continue end

      if not R2.lev_along then
        visit_room(R2, quest, C.name)
      end
    end
  end


  local function dump_quests()
    gui.printf("Quest list:\n")

    each Q in LEVEL.quests do
      gui.printf("  %s : svolume:%d\n", Q.name, Q.svolume)
    end
  end


  local function dump_room_order()
    gui.debugf("Room Visit Order:\n")

    each R in LEVEL.rooms do
      gui.debugf("  %1.3f : %s  %s\n",
                 R.lev_along, R.name, R.quest.name)
    end
  end


  local function do_entry_conns(R, entry_conn, seen)
    R.entry_conn = entry_conn

    seen[R] = 1

    each C in R.conns do
      local R2 = C:other_room(R)

      if not seen[R2] then
        do_entry_conns(R2, C, seen)
      end
    end
  end


  local function do_flip_connections()
    -- mark which doors needs to be built on the other side

    each C in LEVEL.conns do
      if C.kind != "teleporter" then
        if C.R1.lev_along > C.R2.lev_along then
          C.flip_it = true
        end
      end
    end
  end


  ---| Quest_order_by_visit |---

  visit_quest_node(LEVEL.quest_root)

  -- sanity check
  each Q in LEVEL.quests do
    assert(Q.lev_along)
  end

  -- sort the quests
  table.sort(LEVEL.quests, function(A, B)
      return A.lev_along < B.lev_along end)

  dump_quests()


  -- visit each quest, and recurse through it only
  each Q in LEVEL.quests do
    assert(Q.entry)
    visit_room(Q.entry, Q)
  end

  -- sanity check
  each R in LEVEL.rooms do

--[[ "fubar" debug stuff
if not R.lev_along then R.lev_along = 0.5 end
--]]

    if not R.lev_along then
      error("Room not visited: " .. R.name)
    end
  end

  -- sort the rooms
  table.sort(LEVEL.rooms, function(A,B)
      return A.lev_along < B.lev_along end)

  dump_room_order()

  do_entry_conns(LEVEL.start_room, nil, {})

  do_flip_connections()
end


------------------------------------------------------------------------


function Quest_add_weapons()
  --
  -- The weapons to use on the level are already decided, this function
  -- just decides in which rooms to place them.
  --

  local function should_swap(R1, R2, name1, name2)
    if R1.lev_along > R2.lev_along then
      R1, R2 = R2, R1
      name1, name2 = name2, name1
    end

    local info1 = assert(GAME.WEAPONS[name1])
    local info2 = assert(GAME.WEAPONS[name2])

    -- only swap when the ammo is the same
    if info1.ammo != info2.ammo then
      return false
    end

    if info1.level != info2.level then
      return info1.level > info2.level
    end

    -- same level, so test the firepower
    local fp1 = info1.rate * info1.damage
    local fp2 = info2.rate * info2.damage

    return (fp1 > fp2)
  end


  local function reorder_weapons(room_list)
    for idx1 = 1, #room_list do
    for idx2 = idx1 + 1, #room_list do
      local R1 = room_list[idx1]
      local R2 = room_list[idx2]

      for w1 = 1, #R1.weapons do
      for w2 = 1, #R2.weapons do
        local name1 = R1.weapons[w1]
        local name2 = R2.weapons[w2]

        if should_swap(R1, R2, name1, name2) then
stderrf("@@@@@@!!!!  Swapping %s in %s <--> %s in %s\n", name1, R1.name, name2, R2.name)
          R1.weapons[w1] = name2
          R2.weapons[w2] = name1
        end
      end -- w1, w2
      end
    end -- idx1, idx2
    end
  end


  local function do_start_weapons(R)
    if not R then return end

    R.weapons = table.copy(LEVEL.start_weapons)

    R.used_chunks = R.used_chunks + #R.weapons
  end


  local function eval_weapon_room(R)
    -- never in hallways!
    if R.kind == "stairwell" then return -250 end
    if R.kind == "hallway"   then return -200 end

    -- never in secrets!
    if R.is_secret then return -150 end

    -- starting rooms are done separately
    if R.is_start then return -100 end

    -- putting weapons in the exit room is a tad silly
    if R.is_exit then return -50 end

    -- really don't want more than one per room
    if #R.weapons > 0 then return -20 end

    -- basic fitness of the room is # of free chunks
    local score = R:usable_chunks() * 10 + 1

    -- big bonus for leaf rooms
    if R:total_conns("ignore_secrets") < 2 then
      score = score + 45
    end

    -- try to avoid rooms with a goal
    if #R.goals == 0 then
      score = score + 17
    end

    -- Note: tie breaker is added by caller

    return score
  end


  local function usable_rooms_in_zone(Z)
    local count = 0

    each R in Z.rooms do
      if eval_weapon_room(R) > 0 then
        count = count + 1
      end
    end

    return count
  end


  local function pick_room(Z)
    -- the zone 'Z' can be NIL, meaning try ALL rooms.
    -- also, when a zone is given we skip any "unusable" rooms.

    local list = LEVEL.rooms

    if Z then list = Z.rooms end

    -- evaluate each room and pick the best
    local best_R
    local best_score

    each R in list do
      local score = eval_weapon_room(R)

      -- unusable room?
      if Z and score < 0 then continue end

      -- tie breaker
      score = score + gui.random() * 4

      if not best_R or score > best_score then
        best_R = R
        best_score = score
      end
    end

--  gui.debugf("|--> %s\n", best_R.name)

    return best_R
  end


  local function do_other_weapons()
    -- copy the weapon list, so we can modify it
    local list = table.copy(LEVEL.other_weapons)

    if table.empty(list) then return end

    local rooms = {}

    -- firstly, assign a weapon to every zone except the first

    for idx = 2, #LEVEL.zones do
      local Z = LEVEL.zones[idx]

      local R = pick_room(Z)

      if R then
        table.insert(R.weapons, table.remove(list, 1))
        table.insert(rooms, R)
      end

      if table.empty(list) then break; end
    end

    -- secondly, if we have any left over then assign to best scoring rooms

    while not table.empty(list) do
      local weapon = table.remove(list, 1)

      local R = pick_room(nil)
      assert(R)

      table.insert(R.weapons, weapon)
      table.insert(rooms, R)
    end

    -- finally, swap weapons if the order seems strange

    if not LEVEL.alt_start then
      table.insert(rooms, 1, LEVEL.start_room)
    end

    reorder_weapons(rooms)
  end


  local function dump_weapons()
    gui.debugf("Weapon assignment:\n")

    each R in LEVEL.rooms do
      gui.debugf("  %s %s weapons = %s\n", R.zone.name, R.name,
                 table.list_str(R.weapons))
    end
  end


  ---| Quest_add_weapons |---

  if OB_CONFIG.weapons == "none" then
    return
  end

  -- the Co-op alternate start room gets the same weapons
  do_start_weapons(LEVEL.start_room)
  do_start_weapons(LEVEL.alt_start)

  do_other_weapons()

  dump_weapons()
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

  local max_level


  local function adjust_powerup_probs(pal, factor)  -- NOT USED ATM
    -- apply the "Powerups" setting from the GUI

    if not factor then factor = 5 end

    each name,info in GAME.NICE_ITEMS do
      if info.kind != "powerup" then continue end

      if not pal[name] then continue end
--[[
      if OB_CONFIG.powers == "none" then
        pal[name] = nil
      elseif OB_CONFIG.powers == "less" then
        pal[name] = pal[name] / factor
      elseif OB_CONFIG.powers == "more" then
        pal[name] = pal[name] * factor
      elseif OB_CONFIG.powers == "mixed" then
        pal[name] = pal[name] * mixed_mul
      end
--]]
    end
  end


  local function secret_palette()
    local pal = {}

    each name,info in GAME.NICE_ITEMS do
      if (info.level or 1) > max_level then
        continue
      end

      if info.secret_prob then
        pal[name] = info.secret_prob
      end
    end

---##    adjust_powerup_probs(pal)

    return pal
  end


  local function normal_palette()
    local pal = {}

    each name,info in GAME.NICE_ITEMS do
      if (info.level or 1) > max_level then
        continue
      end

      if info.add_prob then
        pal[name] = info.add_prob
      end
    end

---##    adjust_powerup_probs(pal)

    return pal
  end


  local function start_palette()
    local pal = {}

    -- Note: no powerups in start room

    each name,info in GAME.NICE_ITEMS do
      if (info.level or 1) > max_level then
        continue
      end

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

---##    adjust_powerup_probs(pal)

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


  local function visit_secret_rooms()
    LEVEL.secret_items = secret_palette()

    if table.empty(LEVEL.secret_items) then
      return
    end

    -- collect all secret leafs
    local rooms = {}

    each R in LEVEL.rooms do
      if R.is_secret and R.kind != "hallway" then
        table.insert(rooms, R)
      end
    end

    each R in rooms do
      local item = rand.key_by_probs(LEVEL.secret_items)

      table.insert(R.items, item)
      mark_item_seen(item)

      gui.debugf("Secret item '%s' --> %s\n", item, R.name)
    end
  end


  local function visit_start_rooms()
    local start_items = start_palette()

    if table.empty(start_items) then
      return
    end

    -- collect start rooms
    local rooms = {}

    table.insert(rooms, 1, LEVEL.start_room)

    if LEVEL.alt_start then
      table.insert(rooms, 1, LEVEL.alt_start)
    end

    -- apply Items setting
    local quota = 1

    if OB_CONFIG.items == "less" and rand.odds(50) then return end
    if OB_CONFIG.items == "more" and rand.odds(50) then quota = 2 end

    for loop = 1, quota do
      -- add the same item into each start room
      local item = rand.key_by_probs(start_items)

      each R in rooms do
        table.insert(R.items, item)
        mark_item_seen(item)

        gui.debugf("Start item '%s' --> %s\n", item, R.name)
      end
    end
  end


  local function eval_other_room(R)
    if R.is_secret  then return -1 end
    if R.is_start   then return -1 end
    if R.is_exit    then return -1 end

    if R.kind == "hallway"   then return -1 end
    if R.kind == "stairwell" then return -1 end

    -- primary criterion is the # of unused chunks
    local score = R:usable_chunks() * 20

    -- unused leaf rooms take priority
    if R:is_unused_leaf() then
      score = score + 90;
    end

    if score < 1 then return -1 end

    if #R.goals   > 0 then score = score / 2 end
    if #R.weapons > 0 then score = score / 2 end

    -- tie breaker
    return score + gui.random() * 4
  end


  local function collect_other_rooms()
    local list = {}

    each R in LEVEL.rooms do
      local score = eval_other_room(R)

      if score > 0 then
        R.nice_item_score = score

        table.insert(list, R)
      end
    end

    -- sort them (best first)
    table.sort(list, function(A, B) return A.nice_item_score > B.nice_item_score end)

--[[ DEBUG
stderrf("Other rooms:\n")
each LOC in list do
stderrf("  %1.2f = %s  unused_leaf = %s\n", LOC.nice_item_score, LOC.name, string.bool(LOC:is_unused_leaf()))
end
--]]

    return list
  end


  local function visit_other_rooms(locs, normal_items)
    for i = 1, quota do
      if table.empty(locs) then break; end

      local R = table.remove(locs)

      local item = rand.key_by_probs(normal_items)

      table.insert(R.items, item)
      mark_item_seen(item)

      gui.debugf("Nice item '%s' --> %s\n", item, R.name)
    end
  end


  local function find_storage_rooms()
    each R in LEVEL.rooms do
      if R.kind == "hallway" then continue end

      if R:is_unused_leaf() and #R.items == 0 then
        R.is_storage = true
      end
    end
  end


  ---| Quest_nice_items |---

  if OB_CONFIG.items == "none" then
    gui.printf("Nice items : disabled (user setting).\n")
    find_storage_rooms()
    return
  end

  max_level = 1 + LEVEL.ep_along * 9

  visit_secret_rooms()

  -- start rooms usually get one (occasionally two)
  visit_start_rooms()

  -- everything else uses a quota...

  local quota = (SEED_W + SEED_H) / rand.pick({ 15, 25, 45 })

  if OB_CONFIG.items == "less"  then quota = quota / 2.0 end
  if OB_CONFIG.items == "more"  then quota = quota * 2.0 end
  if OB_CONFIG.items == "mixed" then quota = quota * rand.pick({ 0.5, 1.0, 2.0 }) end

  quota = rand.int(quota)

  gui.printf("Item quota : %1.2f\n", quota)


  local normal_items = normal_palette()

  if OB_CONFIG.strength == "crazy" then
    normal_items = crazy_palette()
  end

  local locs = collect_other_rooms()

--WTF   no 'quota' value FIXME
--!!!!  visit_other_rooms(locs, normal_items)


  -- mark all remaining unused leafs as STORAGE rooms
  find_storage_rooms()
end



function Quest_make_room_secret(R)
  R.is_secret = true

  local C = secret_entry_conn(R)
  assert(C)

  -- if connected to a hallway or stairwell, make it secret too
  -- [ hallways with two or more other rooms are not changed ]

  local H = sel(C.R1 == R, C.R2, C.R1)

  if (H.kind == "hallway" or H.kind == "stairwell") and
     H:total_conns() <= 2
  then

    H.is_secret = true

    -- downgrade a stairwell
    if H.kind == "stairwell" then
      H.kind = "hallway"
      H.areas[1].is_stairwell = nil
    end

    C = secret_entry_conn(H, R)
    assert(C)
  end

  -- mark connection to get a secret door
  C.is_secret = true
end



function Quest_big_secrets()
  --
  -- Finds unused leaf rooms and turns some of them into secrets.
  -- These are "big" secrets, but we also create small ("closet") secrets
  -- elsewhere (ONLY PLANNED ATM).
  --

  local function eval_secret_room(R)
    if R.kind == "hallway"   then return -1 end
    if R.kind == "stairwell" then return -1 end

    if R.is_start   then return -1 end
    if R.is_exit    then return -1 end

    if #R.goals > 0 then return -1 end

    -- must be a leaf room
    if #R.conns > 1 then return -1 end

    -- cannot teleport into a secret exit
    -- [ WISH : support this, a secret teleporter closet somewhere ]
    local conn = R.conns[1]

    if conn.kind == "teleporter" then return -1 end

    -- split connections are no good because they create TWO sectors with
    -- the secret special (type #9).
    if conn.F1 then return -1 end

    -- smaller is better (don't waste large rooms)
    return 200 - math.min(R.svolume,99) + gui.random() * 5
  end


  local function collect_possible_secrets()
    local list = {}

    each R in LEVEL.rooms do
      local score = eval_secret_room(R)

      if score > 0 then
        table.insert(list, R)
      end
    end

    return list
  end


  local function pick_room(list)
    -- TODO (a) use score !
    --      (b) a preference for secrets in different zones

    assert(not table.empty(list))

    rand.shuffle(list)

    return table.remove(list, 1)
  end


  ---| Quest_big_secrets |---

  if STYLE.secrets == "none" then
    gui.printf("Secrets: NONE (by style)\n")
    return
  end

  local poss_list = collect_possible_secrets()
  local poss_count = #poss_list

  -- quantities : use first possible secret + using the rest
  local first = style_sel("secrets", 0, 0.40, 0.70, 0.90)
  local  rest = style_sel("secrets", 0, 0.25, 0.50, 0.75)

  local quota = 0

  if poss_count >= 1 then
    quota = rand.int(first + rest * (poss_count - 1))
  end

  quota = math.clamp(0, quota, poss_count)

  gui.debugf("Secrets: %d (from %d possible)\n", quota, poss_count)

  -- create them now

  for i = 1, quota do
    local R = pick_room(poss_list)

    Quest_make_room_secret(R)

    gui.debugf("Secret room in %s\n", R.name)
  end
end



function Quest_room_themes()
  --
  -- This decides the room themes to use in each room, and also
  -- various textures (e.g. the fence material for each zone).
  --

  local function match_level_theme(name)
    if string.match(name, "^any_") or
       string.match(name, "^" .. LEVEL.theme_name .. "_")
    then
      return true
    end

    return false
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


  local function collect_usable_themes(kind, rarity)
    local tab = {}

    each name,info in GAME.ROOM_THEMES do
      if info.kind == kind and
         info.rarity == rarity and
         match_level_theme(name)
      then
        tab[name] = info.prob or 50
      end
    end

    if table.empty(tab) then
      -- allow nothing for certain cases
      if rarity then return nil end

      error("No rooms themes for: " .. kind)
    end

    return tab
  end


  local function pick_zone_theme(theme_tab, previous)
    assert(theme_tab)

    local tab = table.copy(theme_tab)

    -- prefer not to use same theme as the last one
    for n = 1,2 do
      local prev = previous and previous[n]

      if prev and tab[prev] then
        tab[prev] = tab[prev] / 4
      end
    end

    local name = rand.key_by_probs(tab)

    return assert(GAME.ROOM_THEMES[name])
  end


  local function major_building_themes(theme_tab)
    local tab = table.copy(theme_tab)

    each Z in LEVEL.zones do
      local name = rand.key_by_probs(tab)

      tab[name] = tab[name] / 20

      Z.building_theme = assert(GAME.ROOM_THEMES[name])
    end
  end


  local function building_themes_str(Z)
    local names = {}

    each RT in Z.building_themes do
      table.insert(names, RT.name)
    end

    return table.list_str(names)
  end


  local function is_unset_building(R)
    if R.kind != "normal" then return false end

    if R.theme then return false end

    return (not R.is_outdoor and not R.is_cave)
  end


  local function do_rare_buildings(Z, rare_bd_tab)
    -- TODO usage prob
    if #Z.rooms < 2 then return end

    local rare_building = pick_zone_theme(rare_bd_tab)

    -- FIXME !!!
    Z.rooms[#Z.rooms].theme = rare_building
  end


  local function do_buildings_in_zones(Z)
    -- sanity check
    assert(Z.building_themes[1])
    assert(Z.building_themes[2])
    assert(Z.building_themes[3])

    -- firstly, collect all unset indoor rooms
    local room_list = {}

    each R in Z.rooms do
      if R.kind == "normal" and not R.theme and
         not R.is_outdoor and not R.is_cave
      then
        table.insert(room_list, R)
      end
    end

    if table.empty(room_list) then return end

    -- a single room is an easy case
    if #room_list == 1 then
      room_list[1].theme = Z.building_themes[1]
      return
    end

    -- for multiple rooms, we assign the 2nd and 3rd theme to some
    -- random rooms (upto a certain limit), and the remaining rooms
    -- simply become the major theme.

    rand.shuffle(room_list)

    local limit = 0 ---!!! math.floor(#room_list * 0.37)

    for i = 1, limit do
      local R = table.remove(room_list, 1)

      local idx = rand.sel(75, 2, 3)

      R.theme = Z.building_themes[idx]
    end

    each R in room_list do
      R.theme = Z.building_themes[1]
    end
  end


  local function rare_level_theme(tab)
    tab = table.copy(tab)
    tab["NONE"] = 50

    local name = rand.key_by_probs(tab)

    if name == "NONE" then return end

    local room_list = {}

    each R in LEVEL.rooms do
      if is_unset_building(R) then
        table.insert(room_list, R)
      end
    end

    if #room_list < 1 then return end

    -- when level only has a few rooms, limit how often we use it
    local use_prob = 5 + (#room_list - 1) * 15
    if not rand.odds(use_prob) then return end

    local R = rand.pick(room_list)

    R.theme = assert(GAME.ROOM_THEMES[name])
  end


  local function pick_rare_zone_theme(Z, tab)
    local name = rand.key_by_probs(tab)

    if name == "NONE" then return end

    local room_list = {}

    each R in Z.rooms do
      if is_unset_building(R) then
        table.insert(room_list, R)
      end
    end

    if #room_list < 1 then return end

    -- when zone only has a few rooms, limit how often we use it
    local use_prob = 10 + (#room_list - 1) * 20
    if not rand.odds(use_prob) then return end

    local R = rand.pick(room_list)

    R.theme = assert(GAME.ROOM_THEMES[name])
  end


  local function rare_zone_themes(tab)
    tab = table.copy(tab)
    tab["NONE"] = 50

    each Z in LEVEL.zones do
      pick_rare_zone_theme(Z, tab)
    end
  end


  local function choose_building_themes()
    local common_tab = collect_usable_themes("building")
    local   zone_tab = collect_usable_themes("building", "zone")
    local  level_tab = collect_usable_themes("building", "level")

    major_building_themes(common_tab)

    if level_tab then rare_level_theme(level_tab) end
    if  zone_tab then rare_zone_themes(zone_tab)  end

--[[ OLD
    -- building stuff --

      Z.building_themes = {}

    assign_building_theme(building_tab, 1)

    each Z in LEVEL.zones do
      gui.debugf("Building themes for %s : %s\n", Z.name, building_themes_str(Z))

      if rare_bd_tab then
        do_rare_buildings(Z, rare_bd_tab)
      end

      do_buildings_in_zones(Z)
    end
--]]
  end


  local function choose_other_themes()
    local outdoors_tab = collect_usable_themes("outdoors")
    local  hallway_tab = collect_usable_themes("hallway")
    local     cave_tab = collect_usable_themes("cave")

    local cave_theme = pick_zone_theme(cave_tab)

    each Z in LEVEL.zones do
      Z.cave_theme = cave_theme

      Z.outdoors_theme = pick_zone_theme(outdoors_tab)
      Z. hallway_theme = pick_zone_theme(hallway_tab)

      -- apply it to all rooms in this zone
      each R in Z.rooms do
        if R.kind == "cave" then
          R.theme = Z.cave_theme
        elseif R.kind == "hallway" then
          R.theme = Z.hallway_theme
        elseif R.is_outdoor then
          R.theme = Z.outdoors_theme
        end
      end
    end
  end


  local function misc_textures()
--[[  UNUSED ATM
    local outdoor_volume = total_volume_of_room_kind("outdoor")
    local cave_volume    = total_volume_of_room_kind("cave")

    gui.debugf("outdoor_volume : %d\n", outdoor_volume)
    gui.debugf("cave_volume : %d\n", cave_volume)
--]]
    LEVEL.cliff_mat = rand.key_by_probs(THEME.cliff_mats)

    each Z in LEVEL.zones do
      Z.cave_wall_mat = rand.key_by_probs(Z.cave_theme.naturals)

      if Z.hallway_theme then
        local theme = Z.hallway_theme

        Z.hall_tex   = rand.key_by_probs(theme.walls)
        Z.hall_floor = rand.key_by_probs(theme.floors)
        Z.hall_ceil  = rand.key_by_probs(theme.ceilings)
      end

      assert(THEME.fences)

      Z.fence_mat = rand.key_by_probs(THEME.fences)
      Z.steps_mat = THEME.steps_mat
    end
  end


  local function facade_textures()
    if not THEME.facades then
      error("Theme is missing facades table")
    end

    local tab = table.copy(THEME.facades)

    for pass = 1,2 do
    each Z in LEVEL.zones do
      local mat = rand.key_by_probs(tab)

      -- less likely to use it again
      tab[mat] = tab[mat] / 20

      if pass == 1 then
        Z.facade_mat = mat
      else
        Z.other_facade = mat
      end
    end -- pass, Z
    end
  end


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


  local function setup_room_theme(R)
if not R.theme then
stderrf("\n FUCK!!!!!!!!\n\nR =\n%s\n", table.tostr(R, 1))
end
    assert(R.theme)

    if R.kind == "cave" then
      setup_cave_theme(R)
    elseif R.is_outdoor then
      R.main_tex = rand.key_by_probs(R.theme.floors)
    else
      R.main_tex = rand.key_by_probs(R.theme.walls)
    end

    -- create a skin (for prefabs)
    R.skin =
    {
      wall  = R.main_tex
      floor = R.floor_mat  -- can be NIL
      ceil  = R.ceil_mat   -- ditto
    }
  end


  local function room_textures()
    each R in LEVEL.rooms do
      setup_room_theme(R)
    end
  end


  local function dump_themes()
    gui.debugf("\nRoom themes:\n");

    each Z in LEVEL.zones do
      gui.debugf("%s:\n", Z.name)
      gui.debugf("   facades   : %s / %s\n", Z.facade_mat, Z.other_facade)
      gui.debugf("   fence     : %s\n", Z.fence_mat)
      gui.debugf("   cave_wall : %s\n", Z.cave_wall_mat)

      each R in Z.rooms do
        gui.debugf("   %s = %s  (main_tex: %s)\n", R.name, R.theme.name, R.main_tex)
      end
    end
  end


  ---| Quest_room_themes |---

  choose_building_themes()
  choose_other_themes()

    misc_textures()
  facade_textures()
    room_textures()

  dump_themes()
end



function Quest_make_quests()

  gui.printf("\n--==| Make Quests |==--\n\n")

  Monster_prepare()

  LEVEL.quests = {}
  LEVEL.zones  = {}

  -- special handlign for Deathmatch and Capture-The-Flag

  if OB_CONFIG.mode == "dm" or
     OB_CONFIG.mode == "ctf"
  then
    Multiplayer_setup_level()
    return
  end

  Quest_create_initial_quest()

  Quest_add_major_quests()

  Quest_start_room()
  Quest_order_by_visit()

  -- this must be after quests have been ordered
  Quest_create_zones()

  Grower_hallway_kinds()

--FIXME : get secret rooms working again
--  Quest_big_secrets()

  -- special weapon handling for HEXEN and HEXEN II
  if PARAM.hexen_weapons then
    Quest_do_hexen_weapons()
  else
    Quest_add_weapons()
  end

  Quest_nice_items()
  Quest_room_themes()

  Monster_pacing()
end

