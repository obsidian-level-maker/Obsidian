------------------------------------------------------------------------
--  QUEST ASSIGNMENT
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2015 Andrew Apted
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

    zone : ZONE

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
    -- A zone is group of quests.
    -- Each zone is meant to be distinctive (visually and game-play).

    id, name   -- debugging aids

    quests : list(QUEST)

    rooms : list(ROOM)

    sky_h : number   -- height of sky for this zone

    is_leaf : bool   -- true if no more than 1 conn to another zone

    num_areas   -- total # of non-border areas in the zone
    svolume     -- total size of zone (excl. border areas)

    map_group : number   -- used when connecting zones

    -- FIXME : more stuff  e.g. building_mat, cave_mat, monster palette !!!
--]]


--class GOAL
--[[
    kind : keyword  --  "KEY" or "SWITCH" or "LEVEL_EXIT"

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
    quests = {}
    rooms = {}
    num_areas = 0
    svolume = 0
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

    -- must be a leaf zone too
    -- (otherwise will fail to lock all the zone connections)
    if not R.areas[1].zone.is_leaf then return -1 end

    -- cannot teleport into a secret exit
    -- [ WISH : support this, a secret teleporter closet somewhere ]
    if secret_mode and R:has_teleporter() then return -1 end

    -- don't waste big rooms on a secret exit
    if secret_mode then
      return 100 - math.min(R.svolume,99) + gui.random()
    end

    return R.svolume + gui.random() * 5
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

    gui.printf("Exit room: %s\n", R:tostr())

    R.is_exit = true

    LEVEL.exit_room = R

    -- create the goal for the entire map
    local GOAL = Goal_new("LEVEL_EXIT")

    GOAL.room = R

    table.insert(R.goals, GOAL)
    table.insert(quest.goals, GOAL)
  end


  local function add_secret_exit()
    -- check if needed ?
    if not LEVEL.secret_exit then
      return
    end

    local R = pick_exit_room("secret_mode")

    if not R then
      gui.printf("WARNING : no room for secret exit!\n")
      return
    end

    -- OK --

    gui.printf("Secret Exit: %s\n", R:tostr())

    R.is_exit = true

    Quest_make_room_secret(R)

    local GOAL = Goal_new("SECRET_EXIT")

    table.insert(R.goals, GOAL)
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


  local function same_quest(C)
    return C.A1.room.quest == C.A2.room.quest
  end


  local function collect_rooms(R, list)
    list[R.id] = R

    each C2 in R.ext_conns do
      -- never pass through connection we are examining
      if C2 == C then continue end

      if not same_quest(C2) then continue end

      local R2
      if C2.A1.room == R then
        R2 = C2.A2.room
      else
        R2 = C2.A1.room
      end

      -- already seen?
      if list[R2.id] then continue end

      collect_rooms(R2, list)
    end

    return list
  end


  local function room_exits_in_set(R, rooms)
    local count = 0

    each A in R.areas do
    each C in A.conns do
      if C.A1.room == C.A2.room then continue end

      local N = C:neighbor(A)

      if rooms[N.room.id] then count = count + 1 end
    end
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
      if C.A1.room == R or C.A2.room == R then continue end

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
goal.room:tostr(), goal.room.quest.name)

  -- must be same quest (caller guarantees this)
  assert(C.A1.room.quest == C.A2.room.quest)

  -- cannot lock teleporter connections
  if C.kind == "teleporter" then return end

  quest = C.A1.room.quest

gui.debugf("  quest : %s\n", quest.name)

  -- must not divide a room in half
  if C.A1.room == C.A2.room then
    return
  end

  -- collect rooms on each side of the connection
  local before = collect_rooms(C.A1.room, {})
  local  after = collect_rooms(C.A2.room, {})

--[[
stderrf("BEFORE =\n  ")
each id,_ in before do stderrf("%d ", id) end stderrf("\n\n")
stderrf("AFTER =\n  ")
each id,_ in after do stderrf("%d ", id) end stderrf("\n\n")
--]]

  local before_R = C.A1.room
  local  after_R = C.A2.room

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

gui.debugf("--> possible @ %s : score %1.1f\n", C:tostr(), score)

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

    -- FIXME : compute travel distance from entry (if exists)

    -- tie breaker
    return score + gui.random()
  end


  local function pick_room_for_goal(Q1)
    -- TODO : evaluate each leaf room
    --        especially: far away from Q1.entry

    assert(not table.empty(info.leafs))

--[[
    local best
    local best_score = 0

    each R in info.leafs do
      local score = eval_goal_room(Q1, R)
      if score > best_score then
        best = R
        best_score = score
      end
    end
--]]

    return table.remove(info.leafs, 1)
  end


  local function place_new_goals(Q1, LOCK)
    rand.shuffle(info.leafs)

gui.debugf("PLACING NEW GOALS:\n")

    each goal in info.new_goals do
      local R = pick_room_for_goal(Q1)

gui.debugf("  %s @ %s in %s\n", goal.name, R:tostr(), Q1.name)
      goal.room = R

      table.insert( R.goals, goal)
      table.insert(Q1.goals, goal)

      -- for switched doors we need a tag value
      if goal.same_tag then
        goal.tag = assert(info.new_goals[1].tag)
      elseif goal.kind == "SWITCH" then
        goal.tag = alloc_id("tag")
      end
    end
  end


  local function downgrade_stairwell(A)
    A.room.kind = "building"

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

  if info.conn.A1.room != info.before_R then
    assert(info.conn.A2.room == info.before_R)

    info.conn:swap()
  end

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

  local conn_list = LEVEL.conns
  local is_zoney  = false

  -- handle all zone connections before anything else

  if #LEVEL.zone_conns > 0 then
    conn_list = LEVEL.zone_conns
    is_zoney  = true
  end


  each C in conn_list do
    local quest = C.A1.room.quest
    assert(quest)

    if do_quest and quest != do_quest then continue end

    -- must be same quest on each side
    if C.A2.room.quest != quest then continue end

    each goal in quest.goals do
      Quest_eval_divide_at_conn(C, goal, info)
    end
  end


  -- nothing possible?
  if not info.conn then

    -- if doing zones, then we failed to lock between two zones.
    -- we can live with that though, but try no more zone conns.
    if is_zoney then
      LEVEL.zone_conns = {}
    end

gui.debugf("---> NOTHING POSSIBLE\n")
    return false
  end


  -- for zone connections, must remove it from the global list
  if is_zoney then
    assert(table.kill_elem(LEVEL.zone_conns, info.conn))
  end


  gui.printf("Dividing %s @ %s (%s -- %s)\n", info.quest.name,
             info.conn:tostr(), info.conn.A1.room:tostr(), info.conn.A2.room:tostr())

gui.debugf("   VIA: %s (x%d)\n", info.new_goals[1].item or "???", #info.new_goals)
gui.debugf("   Entry: %s\n", (info.quest.entry and info.quest.entry:tostr()) or "--")

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
    local switch_tab = THEME.switches or {} 

    -- we want at least four kinds, so duplicate some if necessary
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
    if #key_list < 3 then return false end

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
    local prob = 35

    if OB_CONFIG.mode == "coop" then
      prob = 75
    end

    if not rand.odds(prob) then return false end

    -- this is VERY dependent on the sw_pair.wad prefab
    local fab_def = PREFABS["Locked_double"]
    assert(fab_def)

    local GOAL1 = Goal_new("SWITCH")
    local GOAL2 = Goal_new("SWITCH")

    GOAL1.item = "sw_metal"
    GOAL1.action = fab_def.action1

    GOAL2.item = "sw_metal"
    GOAL2.action = fab_def.action2
    GOAL2.same_tag = true

    return Quest_scan_all_conns({ GOAL1, GOAL2 }, quest)
  end

  
  local function lock_up_zones(goal_list)
    for i = 1, 99 do
      if table.empty(LEVEL.zone_conns) then return end

      local goal = pick_goal(goal_list)
      if not goal then return end

      Quest_scan_all_conns({ goal })
    end

    error("Infinite loop in lock_up_zones")
  end


  local function lock_up_a_quest(quest, goal_list)
    local unused = count_unused_leafs(quest)

    if unused >= 3 and add_double_switch_door(quest) then
      unused = unused - 2
    end

    -- number of switch quest to try
    -- (have some random variation)
    if rand.odds(25) then unused = unused - 1 end
    if rand.odds(20) then unused = unused + 1 end
    if rand.odds(20) then unused = unused + 1 end

    unused = int(unused / 2)

    for i = 1, unused do
      local goal = pick_goal(goal_list)
      if not goal then break; end

      Quest_scan_all_conns({ goal }, quest)
    end
  end


  ---| Quest_add_major_quests |---

  -- use keys to lock zone connections

  local goal_list = {}

  collect_key_goals(goal_list)

  if #LEVEL.zone_conns > 0 then
    if add_triple_key_door(goal_list) then
      LEVEL.has_triple_key = true
    end
  end

  lock_up_zones(goal_list)


  -- lock remaining zone connections with switches

  collect_switch_goals(goal_list)

  lock_up_zones(goal_list)
end



function Quest_fixup_zones()
  each A in LEVEL.areas do
    local zone = assert(A.zone)

    if A.room and not A.room.zone then
      A.room.zone = zone

      table.add_unique(zone.rooms, A.room)
    end

    if A.room and A.room.quest and not A.room.quest.zone then
      A.room.quest.zone = zone

      table.insert(zone.quests, A.room.quest)
    end
  end
end


------------------------------------------------------------------------


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

    -- not too big !!
    if R.svolume < 25 then score = score + 20 end
    if R.svolume < 50 then score = score + 10 end

    -- prefer no teleporter
    if not R:has_teleporter() then score = score + 7 end

    -- TODO: prefer a place for start closet

    -- tie breaker
    return score + gui.random() * 4
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

    gui.printf("Start room: %s\n", R:tostr())

    local GOAL = Goal_new("START")

    table.insert(R.goals, GOAL)

    R.is_start = true

    LEVEL.start_room = R
    LEVEL.start_area = R.areas[1]  -- TODO

    start_quest.entry = LEVEL.start_room
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

    gui.printf("Alternate Start room: %s\n", R:tostr())

    local GOAL = Goal_new("START")

    GOAL.alt_start = true

    table.insert(R.goals, GOAL)

    R.is_start = true

    LEVEL.alt_start = R

    partition_coop_players()
  end


  ---| Quest_start_room |---

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
--- stderrf("visit_room %s (via %s)\n", R:tostr(), via_conn_name)
    R.lev_along = room_along / #LEVEL.rooms

    room_along = room_along + 1

    assert(R.quest == quest)

    each A in R.areas do
    each C in A.conns do
      if not (C.A1 == A or C.A2 == A) then continue end

      local A2 = C:neighbor(A)

      if A2.room == R then continue end
      if A2.room.quest != quest then continue end

      if not A2.room.lev_along then
        visit_room(A2.room, quest, C:tostr())
      end
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
                 R.lev_along, R:tostr(), R.quest.name)
    end
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
      error("Room not visited: " .. R:tostr())
    end
  end

  -- sort the rooms
  table.sort(LEVEL.rooms, function(A,B)
      return A.lev_along < B.lev_along end)

  dump_room_order()

  do_entry_conns(LEVEL.start_area, nil, {})
end


------------------------------------------------------------------------


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
      if level > LEVEL.weapon_level then return 0 end
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
    local num_zones = #LEVEL.zones

    if num_zones == 1 then
      return { quota }
    end


    local counts = {}

    for k = 1, #LEVEL.zones do
      counts[k] = 0
    end

    -- first zone always gets a weapon, often two, occasionally three
    counts[1] = 1

    if quota >= 2 and rand.odds((quota - 1) * 40) then
      counts[1] = 2
    end

    if quota >= 3 and rand.odds((quota - 2) * 25) then
      counts[1] = 3
    end

    quota = quota - counts[1]


    -- assign remaining quota to other zones

    for i = 0, 99 do
      if quota <= 0 then break; end

      if rand.odds(80) then
        local zone_idx = 2 + (i % (num_zones - 1))

        counts[zone_idx] = counts[zone_idx] + 1

        quota = quota - 1
      end
    end

    return counts
  end


  local function eval_weapon_room(R, is_start, is_new)
    -- never in hallways!
    if R.kind == "stairwell" then return -250 end
    if R.kind == "hallway"   then return -200 end

    -- never in secrets!
    if R.is_secret then return -150 end

    -- putting weapons in the exit room is a tad silly
    if R.is_exit then return -100 end

    -- alternate starting rooms have special handling
    if R == LEVEL.alt_start then return -60 end

    -- too many weapons already? (very unlikely to occur)
    if #R.weapons >= 2 then return -30 end

    -- basic fitness of the room is the size
    local score = R.svolume

    if is_start and R.is_start and not is_new then
      return rand.pick { 20, 120, 220 }
    end

    -- big bonus for leaf rooms
    if R:total_conns("ignore_secrets") < 2 then
      score = score + 60
    end

    -- if there is a goal or another weapon, try to avoid it
    if #R.goals > 0 or #R.weapons > 0 then score = score / 8 end

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

    -- evaluate each room and pick the best
    local best_R
    local best_score

    each R in Z.rooms do
      local score = eval_weapon_room(R, is_start, is_new)

      -- tie breaker
      score = score + gui.random() * 4

      if not best_R or score > best_score then
        best_R = R
        best_score = score
      end
    end

    table.insert(best_R.weapons, name)

    gui.debugf("|--> %s\n", best_R:tostr())
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

  -- normal quota should give 1-2 in small maps, 2-3 in regular maps, and 3-4
  -- in large maps (where 4 is rare).

  local lev_size = math.clamp(30, SEED_W + SEED_H, 100)

  local quota = (lev_size - 20) / 25 + gui.random()

  -- more as game progresses
  quota = quota + LEVEL.game_along

  if OB_CONFIG.weapons == "less" then quota = quota / 1.7 end
  if OB_CONFIG.weapons == "more" then quota = quota * 1.7 end

  if OB_CONFIG.weapons == "mixed" then
    quota = quota * rand.pick({ 0.6, 1.0, 1.7 })
  end

  quota = quota * (PARAM.weapon_factor or 1)
  quota = int(quota)

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

  local  start_items
  local normal_items


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


  local function visit_secret_rooms()
    if table.empty(LEVEL.secret_items) then
      return
    end

    -- collect all secret leafs
    -- we need to visit them in random order
    local rooms = {}

    each R in LEVEL.rooms do
      if R.is_secret and R.kind != "hallway" then
        table.insert(rooms, R)
      end
    end

    rand.shuffle(rooms)

    each R in rooms do
      local item = rand.key_by_probs(LEVEL.secret_items)

      table.insert(R.items, item)
      mark_item_seen(item)

      -- TODO: extra health/ammo in every secret room

      gui.debugf("Secret item '%s' --> %s\n", item, R:tostr())
    end
  end


  local function visit_unused_leafs()
    -- collect all the unused storage leafs
    -- (there is no need to shuffle them here)
    local rooms = {}

    each R in LEVEL.rooms do
      if R:is_unused_leaf() then
        table.insert(rooms, R)
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
    normal_items = normal_palette()
     start_items =  start_palette()

    if OB_CONFIG.strength == "crazy" then
      normal_items = crazy_palette()
       start_items = crazy_palette()
    end

    each R in rooms do
      local tab

      if R.is_start then
        tab = start_items
      else
        tab = normal_items
      end

      if table.empty(tab) then continue end

      local item = rand.key_by_probs(tab)

      table.insert(R.items, item)
      mark_item_seen(item)

      gui.debugf("Nice item '%s' --> %s\n", item, R:tostr())
    end
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


  local function eval_other_room(R)
    if R.kind == "hallway"   then return -1 end
    if R.kind == "stairwell" then return -1 end

    if R.is_secret  then return -1 end
    if R.is_start   then return -1 end

    -- leafs are already handled
    if R:total_conns("ignore_secrets") < 2 then return -1 end

    -- primary criterion is the room size.
    -- [ the final score will often be negative ]

    local score = R.svolume

    if #R.goals > 0 then score = score - 8 end

    score = score - 16 * (#R.weapons + #R.items)

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


  local function visit_other_rooms()
    -- add extra items in a few "ordinary" rooms
    local quota = calc_extra_quota()

    for i = 1, quota do
      local R = choose_best_other_room()
      if not R then break; end

      if table.empty(normal_items) then continue end

      local item = rand.key_by_probs(normal_items)

      table.insert(R.items, item)
      mark_item_seen(item)

      gui.debugf("Extra item '%s' --> %s\n", item, R:tostr())
    end
  end


  ---| Quest_nice_items |---

  LEVEL.secret_items = secret_palette()
 
  visit_secret_rooms()
  visit_unused_leafs()
  visit_other_rooms()
end



function Quest_make_room_secret(R)
  R.is_secret = true

  local C = secret_entry_conn(R)
  assert(C)

  -- if connected to a hallway or stairwell, make it secret too
  -- [ hallways with two or more other rooms are not changed ]

  local H = sel(C.A1.room == R, C.A2.room, C.A1.room)

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
  C.kind = "secret"
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
    if R:total_conns() > 1 then return -1 end

    -- cannot teleport into a secret exit
    -- [ WISH : support this, a secret teleporter closet somewhere ]
    if R:has_teleporter() then return -1 end

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

    gui.debugf("Secret room in %s\n", R:tostr())
  end
end



function Quest_final_battle()
  --
  -- Generally the last battle of the map is in the EXIT room.
  -- however the previous room will often be a better place, so
  -- look for that here.  [ Idea for this by flyingdeath ]
  --

  -- CURRENTLY DISABLED  (TODO)

  ---| Quest_final_battle |---

  local E = assert(LEVEL.exit_room)

  gui.printf("Exit room: %s\n", E:tostr())

  -- will clear this if we choose a different room
  E.final_battle = true

  -- check previous room...
  assert(E.entry_conn)

  local prev = E.entry_conn:neighbor(E)

  if prev.is_start then return end

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

  Monster_prepare()

  LEVEL.quests = {}

  -- special handlign for Deathmatch and Capture-The-Flag

  if OB_CONFIG.mode == "dm" or
     OB_CONFIG.mode == "ctf"
  then
    Multiplayer_setup_level()
    return
  end

  Quest_create_initial_quest()

  Quest_add_major_quests()

  Quest_fixup_zones()

  Quest_start_room()
  Quest_order_by_visit()

---???  Quest_final_battle()

  Quest_big_secrets()

  -- special weapon handling for HEXEN and HEXEN II
  if PARAM.hexen_weapons then
    Quest_do_hexen_weapons()
  else
    Quest_add_weapons()
  end

  Quest_nice_items()

  Quest_choose_themes()
  Quest_select_textures()
end

