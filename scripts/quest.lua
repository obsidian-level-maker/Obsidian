----------------------------------------------------------------
--  QUEST ASSIGNMENT
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2013 Andrew Apted
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

  storage_rooms : list(ROOM)

  zone : ZONE

  entry_conn : CONN  -- the connection used to enter this quest
                     -- Only nil for the very first quest

  volume : number  -- size of quest (sum of tvols)
}


class ZONE
{
  -- a zone is a group of quests forming a large part of the level.
  -- the whole level might be a single zone.  Zones are generally
  -- connected via _Keyed_ doors, whereas all the puzzles inside a
  -- zone are switched doors.
  --
  -- Zones are also meant to have a distinctive look, e.g. each one
  -- has a difference facade for buildings, and inside have different
  -- room themes, hallway themes (etc), perhaps even a different
  -- monster palette.

  id : number

  rooms : list(ROOM / HALL)

  volume : number  -- total of all rooms

  themes[kind] : list(name)  -- main room themes to use

  previous[kind] : list(name)

  facade_mat  -- material to use for building exteriors (can be NIL)
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
}


--------------------------------------------------------------]]


QUEST_CLASS = {}

function QUEST_CLASS.new(start)
  local id = 1 + #LEVEL.quests
  local Q =
  {
    id = id
    start = start
    rooms = {}
    storage_rooms = {}
  }
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

  L.visit_id = Plan_alloc_id("visit_id")

  table.insert(quest.rooms, L)
end


function QUEST_CLASS.add_storage_room(quest, R)
  -- a "storage room" is a dead-end room which does not contain a
  -- specific purpose (key, switch or exit).  We place some of the
  -- ammo and health needed by the player elsewhere into these rooms
  -- to encourage exploration.
  R.is_storage = true

  table.insert(quest.storage_rooms, R)
end


function QUEST_CLASS.remove_storage_room(quest, R)
  R.is_storage = nil

  table.kill_elem(quest.storage_rooms, R)
end


----------------------------------------------------------------


ZONE_CLASS = {}

function ZONE_CLASS.new()
  local id = 1 + #LEVEL.zones
  local Z =
  {
    id = id
    rooms = {}
    themes = {}
    previous = {}
    rare_used = {}
  }
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
  Z.rooms = nil
end


function ZONE_CLASS.add_room_or_hall(Z, R)
  R.zone = Z

  table.insert(Z.rooms, R)
end


function ZONE_CLASS.calc_volume(Z)
  Z.volume = 0

  each L in Z.rooms do
    Z.volume = Z.volume + L.base_tvol
  end
end


function ZONE_CLASS.merge(Z1, Z2)
  --- assert(Z2.parent == Z1)

  -- transfer the rooms and halls
  each L in Z2.rooms do
    Z1:add_room_or_hall(L)
  end

  Z1:calc_volume()

---##  -- fix any parent fields which refer to Z2
---##  each Z in LEVEL.zones do
---##    if Z.parent == Z2 then
---##       Z.parent = Z1
---##    end
---##  end

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

  gui.printf("Weapon list:\n")

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



function Quest_assign_room_themes()
 
  -- figure out how many room themes to use for each kind of room.
  -- table keys are room kinds ("building" etc) and value is number of
  -- themes per ZONE, where zero means the whole level.
  local EXTENT_TAB = {}

  local function total_of_room_kind(kind)
    local total = 0

    if kind == "hallway" then
      each H in LEVEL.halls do
        total = total + (H.base_tvol or 0.4)
      end

    else
      each R in LEVEL.rooms do
        if R.kind == kind then
          total = total + R.base_tvol
        end
      end
    end

    return total
  end


  local function extent_for_room_kind(kind, A, B)
    local qty = total_of_room_kind(kind)

    -- rough calculation of room area per zone
    qty = qty / #LEVEL.zones

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


  local function pick_rare_room(L)
    local tab_name = L.kind .. "s"
    local tab_orig = THEME[tab_name]

    if not tab_orig then return nil end

    local tab = table.copy(tab_orig)

    -- remove non-rare themes and already used themes
    each name,prob in tab_orig do
      local rt = assert(GAME.ROOM_THEMES[name])

      if not rt.rarity or
         (rt.rarity == "zone"  and L.zone.rare_used[name]) or
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


  local function assign_room_theme(L, try_rare)
    local theme_list = L.zone.themes[L.kind]
    local  prev_list = L.zone.previous[L.kind]

    assert(theme_list)
    assert( prev_list)

    local theme_name

    if try_rare then
      theme_name = pick_rare_room(L)
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

    L.theme = GAME.ROOM_THEMES[theme_name]

    if not L.theme then
      error("No such room theme: " .. tostring(theme_name))
    end

    gui.printf("Room theme for %s : %s\n", L:tostr(), theme_name)

    if not L.theme.rarity then
      table.insert(prev_list, 1, theme_name)
    elseif L.theme.rarity == "minor" then
      -- do nothing
    elseif L.theme.rarity == "zone" then
      L.zone.rare_used[theme_name] = 1
    elseif L.theme.rarity == "level" then
      LEVEL.rare_used[theme_name] = 1
    elseif L.theme.rarity == "episode" then
      EPISODE.rare_used[theme_name] = 1
    end
  end


  local function assign_hall_theme(H)
    local conn_rooms = {}

    each D in H.conns do
      local L = D:neighbor(H)

      if L.kind == "building" then  -- TODO: caves
        table.insert(conn_rooms, L)
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
    local theme_name = H.zone.themes[H.kind][1]

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
    assign_room_theme(R, rare_ok)
  end

  each H in LEVEL.halls do
    assign_hall_theme(H)
  end

  select_facades_for_zones()

  pictures_for_zones()

  -- verify each room and hallway got a theme
  each R in LEVEL.rooms do assert(R.theme) end
  each H in LEVEL.halls do assert(H.theme) end
end



function Quest_spread_facades()

  local function char_for_facade(sx, sy)
    local S = SEEDS[sx][sy]

    local facade = (S.section and S.section.facade) or S.facade

    if not facade then
      if S.edge_of_map or S.free then return "/" end

      return " "
    end

    return string.sub(facade, 1, 1)
  end


  local function dump_facades(title)
    gui.printf("%s\n", title)

    for y = SEED_TOP,1,-1 do
      local line = ""

      for x = 1,SEED_W do
        line = line .. char_for_facade(x, y)
      end

      gui.printf("%s\n", line)
    end

    gui.printf("\n")
  end



  local function facades_for_indoor_rooms()
    each R in LEVEL.rooms do
      if R.kind != "outdoor" then
        each K in R.sections do
          K.facade = R.zone.facade_mat
        end
      end
    end

    each H in LEVEL.halls do
      each K in H.sections do
        K.facade = H.zone.facade_mat
      end
    end
  end

  local function facades_for_top_right()
    local KK = SECTIONS[SECTION_W][SECTION_H]

    if not KK.facade then
      local L = KK.room or KK.hall

      if L then
        KK.facade = L.zone.facade_mat
      else
        KK.facade = LEVEL.zones[1].facade_mat
      end
    end
  end


  local function facades_in_between()
    -- this fills the "gaps" between an indoor and outdoor room.

    for kx = 1,SECTION_W do
    for ky = 1,SECTION_H do
      local K = SECTIONS[kx][ky]

      if K.facade then continue end

      if (K.room and K.room.kind == "outdoor") then continue end

      for dir = 2,8,2 do
        local N1 = K:neighbor(dir)
        local N2 = K:neighbor(10 - dir)

        if not (N1 and N2) then continue end

        -- want 'N1' to be an indoor room, 'N2' to be an outdoor room

        if     (N1.room and N1.room.kind == "outdoor") then continue end
        if not (N2.room and N2.room.kind == "outdoor") then continue end

        if N1.facade then
          K.facade = N1.facade
          break;
        end

      end -- dir

    end -- kx, ky
    end
  end


  local function facades_at_corners()
    -- this tries to fill empty corners near outdoor rooms.
    -- it is mainly important for the edges of the map.

    for kx = 1,SECTION_W do
    for ky = 1,SECTION_H do
      local K = SECTIONS[kx][ky]

      if K.facade then continue end

      if (K.room and K.room.kind == "outdoor") then continue end

      each dir in geom.DIAGONALS do
        local N = K:neighbor(dir)

        if not (N and N.room and N.room.kind == "outdoor") then continue end

        local N1 = K:neighbor(geom.RIGHT_45[dir])
        local N2 = K:neighbor(geom. LEFT_45[dir])

        if (N1 and N1.room == N.room) then continue end
        if (N2 and N2.room == N.room) then continue end

        local found

        for dir2 = 2,8,2 do
          local T = K:neighbor(dir2)

          if T and T.facade then
            K.facade = T.facade ; found = true ; break
          end
        end

        if found then break; end

      end -- dir

    end -- kx, ky
    end
  end


  local function facades_around_outdoors(no_edge)
    -- this fills "around" outdoor rooms, e.g. a section K above a room
    -- can be filled by section to the left or right of K.

    for kx = 1,SECTION_W do
    for ky = 1,SECTION_H do
      local K = SECTIONS[kx][ky]

      if K.facade then continue end

      if (K.room and K.room.kind == "outdoor") then continue end

      if no_edge and (kx == 1 or kx == SECTION_W or
                      ky == 1 or ky == SECTION_H)
      then continue end

      for dir = 2,8,2 do
        local N = K:neighbor(dir)

        if not (N and N.room and N.room.kind == "outdoor") then continue end

        local T1 = K:neighbor(geom.LEFT [dir])
        local T2 = K:neighbor(geom.RIGHT[dir])

        local out1 = (T1 and T1.room and T1.room.kind == "outdoor")
        local out2 = (T2 and T2.room and T2.room.kind == "outdoor")

        if T1.facade and not out1 then
          K.facade = T1.facade
          break;
        end

        if T2.facade and not out2 then
          K.facade = T2.facade
          break;
        end

      end -- dir

    end -- kx, ky
    end
  end


  local function facades_flood(allow_outdoor)
    -- this simply fills empty sections from any neighbor.
    -- returns true if something was changed

    local changes = false

    for kx = 1,SECTION_W do
    for ky = 1,SECTION_H do
      local K = SECTIONS[kx][ky]

      if K.facade then continue end

      if (not allow_outdoor) and (K.room and K.room.kind == "outdoor") then continue end

      local N2 = K:neighbor(2)
      local N4 = K:neighbor(4)
      local N6 = K:neighbor(6)
      local N8 = K:neighbor(8)

      local F2 = N2 and N2.facade
      local F4 = N4 and N4.facade
      local F6 = N6 and N6.facade
      local F8 = N8 and N8.facade

      if F2 and F2 == F8 then
        K.facade = F2 ; changes = true ; continue

      elseif F4 and (F4 == F6 or F4 == F2 or F4 == F8) then
        K.facade = F4 ; changes = true ; continue

      elseif F2 and (F2 == F4 or F2 == F6) then
        K.facade = F2 ; changes = true ; continue
      end

      if F6 or F8 then
        K.facade = F6 or F8
        changes = true
      end

    end -- kx, ky
    end

    return changes
  end


  local function facades_transfer_to_seeds()
    for kx = 1,SECTION_W do
    for ky = 1,SECTION_H do
      local K = SECTIONS[kx][ky]

      if not K.facade then
        error("Not all sections got a facade")
      end

      for sx = K.sx1, K.sx2 do
      for sy = K.sy1, K.sy2 do
        SEEDS[sx][sy].facade = K.facade
      end
      end

    end  -- kx, ky
    end
  end


  local function facades_edge_pass(sx, sy, dir, face_dir)
    local num = sel(geom.is_horiz(dir), SEED_W, SEED_TOP)

    local S1 = SEEDS[sx][sy]

    for k = 0, num - 1 do
      local S = S1:neighbor(dir, k)

      if S.facade then continue end

      local N = S:neighbor(face_dir)
      assert(N)

      S.facade = N.facade  -- may be nil
    end
  end


  local function facades_do_edge_seeds()
    -- ensure seeds at edge of map (which have no section) get a facade

    for x = EDGE_SEEDS, 1, -1 do
      facades_edge_pass(x, 1, 8, 6)
      facades_edge_pass(1, x, 6, 8)

      facades_edge_pass(SEED_W - (x - 1), 1,   8, 4)
      facades_edge_pass(1, SEED_TOP - (x - 1), 6, 2)
    end
  end


  local function verify_all_seeds_got_a_facade()
    for sx = 1,SEED_W   do
    for sy = 1,SEED_TOP do
      if not SEEDS[sx][sy].facade then
        gui.debugf("Bad seed : (%d %d)\n", sx, sy)
        error("Not all seeds got a facade")
      end
    end  -- kx, ky
    end
  end


  ---| Quest_spread_facades |---

  facades_for_indoor_rooms()

  facades_in_between()
  facades_at_corners()

  for pass = 1,6 do
    facades_around_outdoors(pass < 4)
    facades_at_corners()
  end

  -- ensure at least one section has a facade
  facades_for_top_right()

  while facades_flood(false) do end
  while facades_flood(true)  do end

  facades_transfer_to_seeds()
  facades_do_edge_seeds()

  verify_all_seeds_got_a_facade()
end



function Quest_get_exits(L)
  local exits = {}

  each D in L.conns do
    if D.L1 == L and not (D.kind == "double_R" or D.kind == "closet") then
      table.insert(exits, D)
    end
  end

  return exits
end



function calc_travel_volumes(L, zoney)
  -- returns volume for given room + all descendants.
  -- if zoney is true => treat a child room with a zone as locked

  local vol

  if L.kind != "hallway" then
    -- larger rooms have bigger volume 
    vol = 1 + L.svolume / 50
  else
    vol = #L.sections / 8 - 0.1  -- very low for mini-halls
    assert(vol > 0)
  end

  L.base_tvol = vol

  local exits = Quest_get_exits(L)

  each D in exits do
    calc_travel_volumes(D.L2, zoney)

    -- exclude locked exits
    if not (D.lock or (zoney and D.L2.zone)) then
      vol = vol + D.L2.travel_vol
    end

    D.L2.PARENT = L
  end

  L.travel_vol = vol
end



function dump_room_flow(L, indents, is_locked)
  if not indents then
    indents = {}
  else
    indents = table.copy(indents)
  end

  local line = ""

  for i = 1, #indents do
    if i == #indents then
      if is_locked == "tele" then
        line = line .. "|== "
      elseif is_locked then
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

  gui.debugf("%s%s (%1.1f)\n", line, L:tostr(), L.travel_vol)

  local exits = Quest_get_exits(L)

  --[[
    while #exits == 1 do
      L = exits[1].L2 ; exits = Quest_get_exits(L)
    end
  --]]

  table.insert(indents, true)

  each D in exits do
    if _index == #exits then
      indents[#indents] = false
    end

    dump_room_flow(D.L2, indents, sel(D.kind == "teleporter", "tele", D.lock))
  end
end


function Quest_create_zones()

  local all_rooms_and_halls = {}


  local function collect_rooms_and_halls()
    each R in LEVEL.rooms do
      table.insert(all_rooms_and_halls, R)
    end

    each H in LEVEL.halls do
      table.insert(all_rooms_and_halls, H)
    end
  end


  local function update_zone_volumes()
    each Z in LEVEL.zones do
      Z:calc_volume()
    end
  end


  local function score_for_merge(Z1, Z2)
    -- prefer smallest
    local score = 400 - (Z1.volume + Z2.volume)

    return score + gui.random()  -- tie breaker
  end


  local function merge_a_zone()
    -- merge two zones together

    -- A zone can only merge with its parent or one of its children.

    local best_Z1
    local best_Z2
    local best_score

    each L in all_rooms_and_halls do
      local Z1 = L.zone

      if not L.PARENT then continue end

      local Z2 = L.PARENT.zone

      if Z2 == Z1 then continue end

      local score = score_for_merge(Z1, Z2)

      if not best_score or score > best_score then
        best_Z1 = Z1
        best_Z2 = Z2
        best_score = score
      end
    end

    assert(best_Z1 and best_Z2)
    assert(best_Z1 !=  best_Z2)

    gui.debugf("Merging %s --> %s\n", best_Z2:tostr(), best_Z1:tostr())

    best_Z1:merge(best_Z2)

    best_Z1:calc_volume()
  end


  local function dump_zones()
    gui.printf("Zone list:\n")

    each Z in LEVEL.zones do
      gui.printf("  %d: vol:%3.1f rooms:%d head:%s\n", Z.id,
                 Z.volume or 0, #Z.rooms,
                 (Z.rooms[1] and Z.rooms[1]:tostr()) or "NIL")
    end
  end


  local function has_lockable_exit(L, child)

    local count = 0

    each exit in Quest_get_exits(L) do
      local L2 = exit.L2

      if L2.zone then continue end

      if exit.kind == "secret" then continue end

      if L2 == child and exit.kind == "teleporter" then return false end

      count = count + 1
    end

    return (count >= 2)
  end


  local function find_branch_for_zone(min_tvol)
    local best

    each L in all_rooms_and_halls do
      if L.zone then continue end

      if L.travel_vol < min_tvol then continue end

      if L.PARENT and not has_lockable_exit(L.PARENT, L) then continue end

      if not best or L.travel_vol < best.travel_vol then
        best = L
      end
    end

if not best then gui.debugf("find_branch_for_zone: NONE\n")
else gui.debugf("find_branch_for_zone: %s tvol:%1.1f\n", best:tostr(), best.travel_vol)
end

    return best
  end


  local function create_zone_at_room(L, Z)
    assert(not L.zone)

    if not Z then
      Z = ZONE_CLASS.new()
gui.debugf("Created %s\n", Z:tostr())
    end

    Z:add_room_or_hall(L)
gui.debugf("Added %s --> %s\n", L:tostr(), Z:tostr())

    each exit in Quest_get_exits(L) do
      local L2 = exit.L2

      if L2.zone then continue end

      create_zone_at_room(L2, Z)
    end

    return Z
  end


  local function assign_zone_to_root(min_tvol)
    if #LEVEL.zones == 0 then
      return create_zone_at_room(LEVEL.start_room)
    end

    local best_Z

    each Z in LEVEL.zones do
      local L1 = Z.rooms[1] ; assert(L1)

      assert(L1.PARENT)

      if L1.PARENT.zone then continue end

      if not best_Z -- or L1.zone.volume < best_Z.volume
      then
        best_Z = Z
      end
    end

    assert(best_Z)

    gui.debugf("assign_zone_to_root: using %s\n", best_Z:tostr())

    create_zone_at_room(LEVEL.start_room, best_Z)

    update_zone_volumes()
  end


  ---| Quest_create_zones |---

  LEVEL.zones = {}

  local keys = LEVEL.usable_keys or THEME.keys or {}
  local num_keys = table.size(keys)

  local min_tvol = 4.5

  collect_rooms_and_halls()

  while true do
    local L = find_branch_for_zone(min_tvol)

    -- finished?
    if not L then
      if not LEVEL.start_room.zone then
        assign_zone_to_root()
      end

      break
    end

    create_zone_at_room(L)

    calc_travel_volumes(LEVEL.start_room, "zoney")

    update_zone_volumes()

gui.debugf("AFTER CREATING ZONE:\n")
dump_room_flow(LEVEL.start_room)
  end

  -- verify everything got a zone
  each L in all_rooms_and_halls do
    assert(L.zone)
  end

  -- if too many zones, merge some
  while #LEVEL.zones > 1 + num_keys do
    merge_a_zone()
  end

  dump_zones()
end



function Quest_choose_keys()

  local function dump_locks()
    gui.printf("Lock list:\n")

    each LOCK in LEVEL.locks do
      gui.printf("  %d = %s %s\n", _index, LOCK.kind, LOCK.key or LOCK.switch or "")
    end

    gui.printf("\n")
  end


  ---| Quest_choose_keys |---

  local num_locks = #LEVEL.locks

  if num_locks <= 0 then
    gui.printf("Lock list: NONE\n\n")
    return
  end


  local key_probs = table.copy(LEVEL.usable_keys or THEME.keys or {}) 
  local num_keys  = table.size(key_probs)

--!!!!!!
--num_keys = math.min(num_keys, #LEVEL.zones - 1)

  assert(THEME.switches)

  local switches = table.copy(THEME.switches)

  gui.printf("Lock count:%d  want_keys:%d (of %d)  switches:%d\n",
              num_locks, #LEVEL.zones - 1, num_keys, table.size(switches));


  --- Step 1: assign keys to places where a new ZONE is entered ---

  local function add_key(LOCK)
    if num_keys < 1 then error("Quests: Run out of keys!") end

    LOCK.kind = "KEY"
    LOCK.key  = rand.key_by_probs(key_probs)

    -- cannot use this key again
    key_probs[LOCK.key] = nil

    if LEVEL.usable_keys then
      LEVEL.usable_keys[LOCK.key] = nil
    end

    num_keys = num_keys - 1
  end

  each LOCK in LEVEL.locks do
    ---### if LOCK.conn.L1.zone != LOCK.conn.L2.zone then
    if LOCK.kind == "KEY" then
      add_key(LOCK)
    end
  end


  -- Step 2. assign keys or switches everywhere else

  -- TODO: use left-over keys

  local function add_switch(LOCK)
    LOCK.kind = "SWITCH"
    LOCK.switch = rand.key_by_probs(switches)

    -- make it less likely to choose the same switch again
    switches[LOCK.switch] = switches[LOCK.switch] / 5
  end

  each LOCK in LEVEL.locks do
    if LOCK.kind == "SWITCH" then
      add_switch(LOCK)
    end
  end

  dump_locks()
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


  local function add_lock(L, D)

    local LOCK =
    {
      conn = D
      tag = Plan_alloc_id("tag")
    }

    if D.L1.zone == D.L2.zone then
      LOCK.kind = "SWITCH"
    else
      LOCK.kind = "KEY"
    end

    D.lock = LOCK

-- gui.debugf("add_lock: LOCK_%d to %s\n", LOCK.tag, D.L2:tostr())

    assert(D.kind != "double_L")
    assert(D.kind != "closet")

    -- keep newest locks at the front of the active list
    table.insert(active_locks, 1, LOCK)

    table.insert(LEVEL.locks, LOCK)
  end


  local function get_matching_locks(req_kind, req_zone)
    -- req_kind is the required kind, or NIL for any
    -- req_zone is the required zone (front side of doo), or NIL for any

    local indexes = {}

    each LOCK in active_locks do
      if req_kind and LOCK.kind != req_kind then continue end

      if req_zone and LOCK.conn.L1.zone != req_zone then continue end

      table.insert(indexes, _index)
    end

    return indexes
  end


  local function pick_lock_to_solve(cur_zone)
    
    -- for switched doors we require that the solution room lies in the
    -- same zone as the room with the locked door.  So the only reason
    -- the player needs to back-track out of a zone is because they
    -- found a key which will provide access into a new zone.

    assert(#active_locks > 0)

    local poss_locks = get_matching_locks("SWITCH", cur_zone)

    if table.empty(poss_locks) then
      poss_locks = get_matching_locks("KEY", nil)
    end

    -- the above SHOULD work -- but this is emergency fallback
    if table.empty(poss_locks) then
      gui.printf("WARNING: could not pick an appropriate lock.\n")
      poss_locks = get_matching_locks(nil, nil)
    end

    -- choosing the newest lock (at index 1) produces the most linear
    -- progression, which is easiest on the player.  Choosing older
    -- locks produces more back-tracking and memory strain, which on
    -- large levels could make it very confusing to navigate.
    --
    -- [Note: the zone system alleviates this problem a lot]

    assert(#poss_locks > 0)

    local p = 1

    while (p + 1) <= #poss_locks and rand.odds(50) do
       p = p + 1
    end

    return table.remove(active_locks, poss_locks[p])
  end


  local function add_solution(R)
    assert(R.kind != "hallway")
    assert(not R.purpose)  -- especially: secret exit

    if table.empty(active_locks) then
-- gui.debugf("add_solution: EXIT\n")
      R.purpose = "EXIT"
      LEVEL.exit_room = R
      return false
    end

    local lock = pick_lock_to_solve(R.zone)

-- gui.debugf("add_solution: LOCK_%d @ %s\n", lock.tag, R:tostr())

    R.purpose = "SOLUTION"
    R.purpose_lock = lock

    lock.target = R

    return lock
  end


  local function crossover_volume(L)
    local count = 0
    if L.kind != "hallway" then count = L:num_crossovers() end

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
    local vol = math.clamp(2.5, D.L2.travel_vol, 50)

    local score = 50 - vol

    -- prefer to visit rooms which have crossovers first
    score = score + crossover_volume(D.L2) * 2.3

    -- prefer exit to be away from entrance
    if D.dir1 and L.entry_conn and L.entry_conn.dir2 then
      local x1, y1 = L.entry_conn.K2:approx_side_coord(L.entry_conn.dir2)
      local x2, y2 =            D.K1:approx_side_coord(D.dir1)

      local dist = geom.dist(x1, y1, x2, y2)
      if dist > 4 then dist = 4 end

      -- preference to avoid 180 degree turns
      if D.dir1 != L.entry_conn.dir2 then
        dist = dist + 3
      end

      score = score + dist / 2.0
    end

    -- small preference for joiners
    if D.L1.is_joiner or D.L2.is_joiner then
      score = score + 0.3
    end

    -- tie breaker
    return score + gui.random() / 10
  end


  local function pick_free_exit(L, exits)
    if #exits == 1 then
      return exits[1]
    end

    local best
    local best_score = -9e9

    each D in exits do
      assert(D.kind != "teleporter")

      local score = evaluate_exit(L, D)

-- gui.debugf("exit score for %s = %1.1f", D:tostr(), score)

      if score > best_score then
        best = D
        best_score = score
      end
    end

    return assert(best)
  end


  local function storage_flow(L, quest)
    -- used when a branch of the level is dudded
    
    gui.debugf("storage_flow @ %s : %s\n", L:tostr(), quest:tostr())

    L.dudded = true

     quest:add_room_or_hall(L)
    L.zone:add_room_or_hall(L)

    if L.kind != "hallway" then
      table.insert(LEVEL.rooms, L)
    end

    local exits = Quest_get_exits(L)

    -- hit a leaf?
    if #exits == 0 then
      assert(L.kind != "hallway")

      quest:add_storage_room(L)

      return L
    end


    local best_leaf

    each D in exits do
      local leaf = storage_flow(D.L2, quest)

      -- choose largest leaf [only needed in NO-QUEST mode]
      if leaf and (not best_leaf or leaf.svolume > best_leaf.svolume) then
        best_leaf = leaf
      end

      -- normally this should be impossible, since zones are large
      -- (over a minimum size) but we only dud up small branches.
      -- It commonly occurs in NO-QUEST mode though.
      if D.L1.zone != D.L2.zone then
        gui.printf("WARNING: dudded %s\n", D.L2.zone:tostr())
      end
    end

    return best_leaf  -- NIL is ok
  end


  local function quest_flow(L, quest)
-- gui.debugf("quest_flow @ %s : %s\n", L:tostr(), quest:tostr())

     quest:add_room_or_hall(L)
    L.zone:add_room_or_hall(L)

    if L.kind != "hallway" then
      table.insert(LEVEL.rooms, L)
    end

    local exits = Quest_get_exits(L)

    -- handle secrets
    each D in table.copy(exits) do
      if D.kind == "secret" then
        table.kill_elem(exits, D)
        storage_flow(D.L2, quest)
      end
    end

    if #exits > 0 then

      --- branching room ---

      local free_exit

      -- handle exits which MUST be either free or locked
      for index = #exits, 1, -1 do
        local D = exits[index]

        if D.L1.zone != D.L2.zone then
          add_lock(L, D)

          table.remove(exits, index)

        -- teleporters cannot be locked
        -- [they could become storage, but we don't do it]
        elseif D.kind == "teleporter" then
          assert(not free_exit)
          free_exit = D

          table.remove(exits, index)
        end
      end

      -- pick the free exit now
      if not free_exit then
        free_exit = pick_free_exit(L, exits)

        table.kill_elem(exits, free_exit)
      end

      L.exit_conn = free_exit

      -- turn some branches into storage
      each D in table.copy(exits) do
        if D.L2.travel_vol < 1.9 and rand.odds(50) then
          table.kill_elem(exits, D)

          storage_flow(D.L2, quest)
        end
      end

      -- lock up all other branches
      each D in exits do
        add_lock(L, D)
      end

      -- continue down the free exit
      quest_flow(free_exit.L2, quest)

      return "ok"
    end


    --- leaf room ---

-- gui.debugf("hit leaf\n")

    quest.target = L

    local lock = add_solution(L)

    -- finished?
    if not lock then return end

    -- create new quest
    local old_room = lock.conn.L1
    local new_room = lock.conn.L2

    local old_Q = assert(old_room.quest)

    local new_Q = QUEST_CLASS.new(lock.conn.L2)

    new_Q.entry_conn = lock.conn

-- gui.debugf("new %s branches off %s\n", new_Q:tostr(), old_Q:tostr())

    -- continue on with new room and quest
    quest_flow(new_Q.start, new_Q)

    return "ok"
  end


  local function no_quest_mode(start, quest)
    -- this is used when there are no quests (except to find the exit)

    -- FIXME: can merrily overwrite a secret exit room

    local leaf = storage_flow(start, quest)

    assert(leaf)
    assert(leaf != start)

    quest:remove_storage_room(leaf)

    leaf.purpose = "EXIT"

    LEVEL.exit_room = leaf
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
      gui.printf("Room %2d : %1.2f : quest %d : zone %d : purpose %s\n",
                 R.id, R.lev_along, R.quest.id, R.zone.id, R.purpose or "-")
    end

    gui.printf("\n")
  end


  local function create_quests()
    local Q = QUEST_CLASS.new(LEVEL.start_room)

    -- room lists will be rebuilt in visit order
    LEVEL.rooms = {}

    each Z in LEVEL.zones do
      Z.rooms = {}
    end

    if THEME.switches and THEME.keys then
      quest_flow(Q.start, Q)
    else
      no_quest_mode(Q.start, Q)
    end

    setup_lev_alongs()

    assert(LEVEL.exit_room)

    gui.printf("Exit room: %s\n", LEVEL.exit_room:tostr())

    dump_visit_order()
  end


  local function update_crossovers()
    each H in LEVEL.halls do
      if H.crossover then H:set_cross_mode() end
    end
  end


  --==| Quest_make_quests |==--

  gui.printf("\n--==| Make Quests |==--\n\n")

  Monsters_max_level()

  -- need at least a START room and an EXIT room
  if #LEVEL.rooms < 2 then
    error("Level only has one room! (2 or more are needed)")
  end

  LEVEL.quests = {}
  LEVEL.locks  = {}


  calc_travel_volumes(LEVEL.start_room, "zoney")

  gui.debugf("Level Flow:\n\n")
  dump_room_flow(LEVEL.start_room)

  Quest_create_zones()

  calc_travel_volumes(LEVEL.start_room)

  create_quests()

  update_crossovers()


  -- create cycles now, before theming logic kicks in...
  Connect_cycles()

  each H in LEVEL.halls do
    H:calc_lev_along()
  end


  -- do weapons and switches now, so that we can create closets for them
  Quest_add_weapons()

  Quest_choose_keys()


  Room_add_voids()
  Room_add_closets()

  Plan_expand_rooms()
  Plan_dump_rooms("Expanded Map:")


  Quest_assign_room_themes()
  Quest_spread_facades()

  -- left over keys can be used in the next level of a hub
  if LEVEL.usable_keys and LEVEL.hub_links then
    Quest_distribute_unused_keys()
  end
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


function Hub_find_link(kind)
  each link in LEVEL.hub_links do
    if kind == "START" and link.dest.name == LEVEL.name then
      return link
    end

    if kind == "EXIT" and link.src.name == LEVEL.name then
      return link
    end
  end

  return nil  -- none
end

