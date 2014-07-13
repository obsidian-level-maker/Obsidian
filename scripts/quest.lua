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
  --

  id : number  -- debugging aid

  rooms : list(ROOM)

  start : ROOM  -- first room in the zone

  solution  : LOCK  -- the key (etc) which this zone must solve

  quests : list(QUEST)

  themes[kind] : ZONE_THEME
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


function Quest_new(start)
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

    score = score - 1.4 * #R.conns

    each C in R.conns do
      if C.kind == "teleporter" then
        score = score - 10 ; break
      end
    end

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
    local quota = (LEVEL.W + LEVEL.H) * rand.range(0.05, 0.25)

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



function Quest_create_zones()

  local function new_zone()
    local Z =
    {
      id = Plan_alloc_id("zone")
      rooms = {}
      quests = {}
      themes = {}
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
    table.add_after(LEVEL.zones, Z, Z2)

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

  local want_zones = int((LEVEL.W + LEVEL.H) / 4 + gui.random() * 2.5)

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

    if THEME.bars and C.R1.is_outdoor and C.R2.is_outdoor then
      LOCK.switch = rand.key_by_probs(THEME.bars)
    end

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

--[[ DEBUG
each C in R.conns do
  if C.lock == lock then
    stderrf("*********** SAME LOCK @ %s\n", R:tostr())
  end
end
--]]

    gui.debugf("solving %s(%s) in %s\n", lock.kind, tostring(lock.item or lock.switch), R:tostr())
  end


  local function evaluate_exit(R, C, mode)
    --
    -- we generally want to visit the LARGEST group first, to ensure
    -- there isn't large sections of the zone turning into storage or
    -- secrets.
    --

    if C.free_exit_score then
      return C.free_exit_score
    end

    local score

    score = 20 + math.sqrt(C.trav_2.volume)

    -- prefer exit to be away from entrance
    if C.dir and R.entry_conn and R.entry_conn.dir then
      local S1 = C:get_seed(R)
      local S2 = R.entry_conn:get_seed(R)

      local dist = geom.dist(S1.sx, S1.sy, S2.sx, S2.sy)
      if dist > 6 then dist = 6 end

      score = score + dist / 2
    end

    -- tie breaker
    return score + gui.random() / 5
  end


  local function pick_free_exit(R, exits, mode)
    assert(#exits > 0)

    if #exits == 1 then
      return exits[1]
    end

    local best
    local best_score = -9e9

    each C in exits do
      local score = evaluate_exit(R, C, mode)

--- gui.debugf("exit score %1.1f for %s", score, C:roomstr())

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
      quest = Quest_new(R)
      quest.kind = "secret"

      gui.debugf("Secret quest @ %s\n", R:tostr())
    end

    R.quest = quest
    R.is_secret = true

    table.insert(quest.rooms, R)

    local exits = Quest_get_zone_exits(R)
    local normal_exits = 0

    each C in exits do
      -- sometime make a "super" secret
      if rand.odds(20) and should_make_secret(C) then
        secret_flow(C.R2)
        C.R2.quest.super_secret = true
      else
        secret_flow(C.R2, quest)
        normal_exits = normal_exits + 1
      end
    end

    if normal_exits == 0 then
      table.insert(quest.secret_leafs, R)
    end 
  end


  local function boring_flow(R, quest, need_solution)
    -- no locks will be added in this sub-tree of the zone

    R.quest = quest
    R.is_storage = true

    table.insert(quest.rooms, R)

    local exits = Quest_get_zone_exits(R)
    local normal_exits = 0

    local free_exit

    if need_solution then
      -- final room must solve the zone's lock instead
      if table.empty(exits) then
        add_solution(R, R.zone.solution)
        return
      end

      free_exit = pick_free_exit(R, exits, "storage")
      table.kill_elem(exits, free_exit)
    end

    rand.shuffle(exits)

    each C in exits do
      if should_make_secret(C) then
        secret_flow(C.R2)
      else
        boring_flow(C.R2, quest, false)
        normal_exits = normal_exits + 1
      end
    end

    if free_exit then
      return boring_flow(free_exit.R2, quest, "need_solution")
    end

    if normal_exits == 0 and not R.must_visit then
      table.insert(quest.storage_leafs, R)
    end 
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
 
      local new_Q = Quest_new(lock.conn.R2)

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
        free_exit = pick_free_exit(R, exits, "quest")
      end

      gui.debugf("using free exit --> %s\n", free_exit.R2:tostr())

      table.kill_elem(exits, free_exit)

      rand.shuffle(exits)
      
      local made_a_lock = false

      -- lock up all other branches
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

    local Q = Quest_new(Z.start)

    if THEME.switches and STYLE.switches != "none" then
      quest_flow(Q.start, Q)
    else
      boring_flow(Q.start, Q, "need_solution")
    end

    -- make room after a keyed door often be a breather
    if Z.id >= 2 and not Z.start.purpose and rand.odds(70) then
      Z.start.cool_down = true
      gui.debugf("Cooling down @ %s\n", Z.start:tostr())
    end
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



function Quest_zones_for_scenics()
  local total = #LEVEL.scenic_rooms
  local scenic_list = table.copy(LEVEL.scenic_rooms)

  local function grow_pass()
    rand.shuffle(scenic_list)

    each R in scenic_list do
      if R.zone then continue end

      each N in R.neighbors do
        if N.zone then
          R.zone = N.zone
          total = total - 1
          break;
        end
      end
    end
  end

  for loop = 1,100 do
    if total == 0 then
      return
    end

    grow_pass()
  end

  error("Failed to assign zones to scenic rooms")
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

  LEVEL.zones  = {}
  LEVEL.quests = {}
  LEVEL.locks  = {}

  Quest_create_zones()
  Quest_divide_zones()
  Quest_final_battle()

  Connect_reserved_rooms()

  Quest_order_by_visit()
  Quest_zones_for_scenics()

  Quest_choose_themes()
  Quest_select_textures()

  -- special weapon handling for HEXEN and HEXEN II
  if PARAM.hexen_weapons then
    Quest_do_hexen_weapons()
  else
    Quest_add_weapons()
  end

  Quest_nice_items()
end

