------------------------------------------------------------------------
--  LEVEL MANAGEMENT
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


--class EPISODE
--[[
    id : number       -- index number (in GAME.episodes)

    description       -- a name generated for this episode

    levels : list(LEVEL)  -- all the levels to generate (may be empty)

    used_keys : table  -- for hubs, remember keys which have been used
                       -- on any level in the hub (cannot use them again)

--]]


--class LEVEL
--[[
    name : string  -- engine name for this level, e.g. MAP01

    description : string  -- level name or title (optional)

    kind  -- keyword: "NORMAL", "BOSS", "SECRET"

    episode : EPISODE

    hub : HUB_INFO     -- used in hub-based games (like Hexen)

      ep_along  -- how far along in the episode:    0.0 --> 1.0
    game_along  -- how far along in the whole game: 0.0 --> 1.0

    is_secret   -- true if level is a secret level
    prebuilt    -- true if level will is prebuilt (not generated)


    === General planning ===

    liquid : table  -- the main liquid in the level (can be nil)

    is_dark : bool  -- true if outdoor rooms will be dark

    special : keyword  -- normally nil
                       -- [ not used at the moment ]


    === Monster planning ===

    monster_level   -- the maximum level of a monster usable here [ except bosses ]


    === Weapon planning ===

    weapon_level    -- the maximum level of a weapon we can use [ except secret_weapon ]

    start_weapons   -- a weapon or two for the start room
      new_weapons   -- weapons which player does not have yet [ may overlap with start_weapons ]
    other_weapons   -- non-new weapons which MAY be given

    secret_weapon   -- an unseen weapon, for usage in a secret room


    === Item planning ===

    usable_keys : prob table  -- if present, can only use these keys


    === Other stuff ===

    ids     : table  -- used for allocating tag numbers (etc)

    rooms   : list(ROOM)
    areas   : list(AREA)
    conns   : list(CONN)

    quests  : list(QUEST)
    zones   : list(ZONE)
    locks   : list(LOCK)

    start_room : ROOM  -- the starting room
     exit_room : ROOM  -- the exit room

    -- TODO: lots of other fields : document important ones
--]]


--class HUB_INFO
--[[
    hub_key    : name   -- goal of this level must be this key
    hub_weapon : name   -- weapon to place on this level
    hub_piece  : name   -- weapon PIECE for this level
--]]



function Level_determine_map_size(LEV)
  --
  -- Determines size of map (Width x Height) in grid points, based on the
  -- user's settings and how far along in the episode or game we are.
  --

  local ob_size = OB_CONFIG.size

  -- there is no real "progression" when making a single level.
  -- hence use mixed mode instead.
  if OB_CONFIG.length == "single" then
    if ob_size == "prog" or ob_size == "epi" then
      ob_size = "mixed"
    end
  end

  -- Mix It Up --

  if ob_size == "mixed" then
    local SIZES = { 21,23,25, 29,33,37, 41,43,49 }

    if OB_CONFIG.mode == "dm" then
      SIZES = { 21,23,25, 29,33,39 }
    end

    local W = rand.pick(SIZES)
    local H = rand.pick(SIZES)

    -- prefer the map to be wider than it is tall
    if W < H then W, H = H, W end

    return W, H
  end

  -- Progressive --

  if ob_size == "prog" or ob_size == "epi" then
    local along = LEV.game_along ^ 0.66

    if ob_size == "epi" then along = LEV.ep_along end

    local n = int(1 + along * 8.9)

    if n < 1 then n = 1 end
    if n > 9 then n = 9 end

    local SIZES = { 25,27,29, 31,33,35, 37,39,41 }

    local W = SIZES[n]
    local H = W - 4

    -- not so big in Deathmatch mode
    if OB_CONFIG.mode == "dm" then return H, H - 2 end

    return W, H
  end

  -- Named sizes --

  -- smaller maps for Deathmatch mode
  if OB_CONFIG.mode == "dm" then
    local SIZES = { small=21, regular=27, large=35, extreme=51 }

    local W = SIZES[ob_size]

    return W, W
  end

  local SIZES = { small=27, regular=35, large=45, extreme=61 }

  local W = SIZES[ob_size]

  if not W then
    error("Unknown size keyword: " .. tostring(ob_size))
  end

  return W, W - 4
end



function Episode_determine_map_sizes()
  each LEV in GAME.levels do
    local W, H = Level_determine_map_size(LEV)

    LEV.map_W = W - 1
    LEV.map_H = H - 1
  end
end



function Episode_pick_names()
  -- game name (for title screen)
  GAME.title     = Naming_grab_one("TITLE")
  GAME.sub_title = Naming_grab_one("SUB_TITLE")

  gui.printf("Game title: %s\n\n", GAME.title)
  gui.printf("Game sub-title: %s\n\n", GAME.sub_title)

  each EPI in GAME.episodes do
    -- only generate names for used episodes
    if table.empty(EPI.levels) then continue end

    EPI.description = Naming_grab_one("EPISODE")

    gui.printf("Episode %d title: %s\n\n", _index, EPI.description)
  end
end



function Episode_decide_specials()


  ---| Episode_decide_specials |---

  each EPI in GAME.episodes do
    -- TODO
  end

  -- dump the results

  local count = 0

  gui.printf("\nSpecial levels:\n")

  each LEV in GAME.levels do
    if LEV.special then
      gui.printf("  %s : %s\n", LEV.name, LEV.special)
      count = count + 1
    end
  end

  if count == 0 then
    gui.printf("  none\n")
  end
end



function Episode_plan_bosses()
  --
  -- Decides various monster stuff :
  --   
  -- (1) the boss fights in end-of-episode maps
  -- (2) the boss fights of special maps (like MAP07 of DOOM 2)
  -- (3) the end-of-level boss of each level
  -- (4) guarding monsters (aka "mini bosses")
  --

  local function calc_monster_level(LEV)
    local mon_along = LEV.game_along

    if LEV.is_secret then
      -- secret levels are easier
      mon_along = rand.skew(0.4, 0.25)

    elseif OB_CONFIG.length == "single" then
      -- for single level, use skew to occasionally make extremes
      mon_along = rand.skew(0.5, 0.35)

    elseif OB_CONFIG.length == "game" then
      -- reach peak strength after about 70% of the full game
      mon_along = math.min(1.0, mon_along / 0.70)
    end

    assert(mon_along >= 0)

    if OB_CONFIG.strength == "crazy" then
      mon_along = 1.2
    else
      local FACTORS = { weak=1.7, lower=1.3, medium=1.0, higher=0.8, tough=0.6 }

      local factor = FACTORS[OB_CONFIG.strength]
      assert(factor)

      mon_along = mon_along ^ factor

      if OB_CONFIG.strength == "higher" or
         OB_CONFIG.strength == "tough"
      then
        mon_along = mon_along + 0.1
      end
    end

    LEV.monster_level = 1 + 9 * mon_along

    gui.debugf("Monster level in %s : %1.1f\n", LEV.name, LEV.monster_level)
  end


  ---| Episode_plan_bosses |---

  each LEV in GAME.levels do
    calc_monster_level(LEV)
  end
end



function Episode_plan_weapons()
  --
  -- Decides weapon stuff for each level:
  --
  -- (1) the starting weapon(s) of a level
  -- (2) other must-give weapons of a level
  -- (3) optional weapons [ for large maps ]
  -- (4) a weapon for secrets [ provided earlier than normal ]
  --

  local function calc_weapon_level(LEV)
    local weap_along = LEV.game_along

    -- allow everything in a single level, or the "Mixed" choice
    if OB_CONFIG.length == "single" or OB_CONFIG.weapons == "mixed" then
      weap_along = 1.0

    elseif OB_CONFIG.length == "game" then
      -- reach peak sooner in a full game (after about an episode)
      weap_along = weap_along * 3.0
    end

    -- small adjustment for the 'Weapons' setting
    if OB_CONFIG.weapons == "more" then
      weap_along = weap_along ^ 0.8 + 0.2
    end

    weap_along = math.min(1.0, weap_along)

    LEV.weapon_level = 1 + 9 * weap_along

    gui.debugf("Weapon level in %s : %1.1f\n", LEV.name, LEV.weapon_level)
  end


  local function decide_weapon_quota(LEV)
    -- decide how many weapons to give

    -- normal quota should give 1-2 in small maps, 2-3 in regular maps, and 3-4
    -- in large maps (where 4 is rare).

    if OB_CONFIG.weapons == "none" then
      LEV.weapon_quota = 0
      return
    end

    local lev_size = math.clamp(30, LEV.map_W + LEV.map_H, 100)

    local quota = (lev_size - 20) / 25 + gui.random()

    -- more as game progresses
    quota = quota + LEV.game_along * 2.0

    if OB_CONFIG.weapons == "less" then quota = quota / 1.7 end
    if OB_CONFIG.weapons == "more" then quota = quota * 1.7 end

    if OB_CONFIG.weapons == "mixed" then
      quota = quota * rand.pick({ 0.6, 1.0, 1.7 })
    end

    quota = quota * (PARAM.weapon_factor or 1)
    quota = int(quota)

    if quota < 1 then quota = 1 end

    LEV.weapon_quota = quota
  end


  local function next_level_in_episode(lev_idx)
    while true do
      local LEV = GAME.levels[lev_idx + 1]

      if not LEV then return nil end

      if LEV.episode != GAME.levels[lev_idx].episode then return nil end

      lev_idx = lev_idx + 1

      if LEV.is_secret then continue end
      if LEV.prebuilt  then continue end

      return LEV
    end
  end


  local function dump_weapon_info()
    gui.debugf("Planned weapons:\n\n")

    each LEV in GAME.levels do
      gui.debugf("%s\n", LEV.name)
      gui.debugf("  level = %1.2f\n", LEV.weapon_level)
      gui.debugf("  quota = %d\n",    LEV.weapon_quota)

      gui.debugf("  new = %s\n",   table.list_str(LEV.new_weapons))
      gui.debugf("  start = %s\n", table.list_str(LEV.start_weapons))
      gui.debugf("  other = %s\n", table.list_str(LEV.other_weapons))
      gui.debugf("  secret = %s\n", LEV.secret_weapon or "NONE")
    end
  end


  local function spread_new_weapons(L1, L2)
    local num1 = #L1.new_weapons
    local num2 = #L2.new_weapons

    if num2 >= L2.weapon_quota then return end

    local diff = num1 - num2

    if num1 < 2 or diff < 0 then return end

    -- chance of moving a single weapon
    local move_prob = 100

    if diff == 0 then move_prob = 10 end
    if diff == 1 then move_prob = 33 end
    if diff == 2 then move_prob = 80 end

    if not rand.odds(move_prob) then return end

    -- Ok, move a weapon
    -- [ removing one from beginning of L1, append to the end of L2, which
    --   prevents weapons moving too far ahead ]
    local name = table.remove(L1.new_weapons, 1)
    table.insert(L2.new_weapons, name)

    gui.debugf("spread new weapon '%s' : %s --> %s\n", name, L1.name, L2.name)

    -- try again
    spread_new_weapons(L1, L2)
  end


  local function pick_new_weapons()
    local seen_weapons = {}

    each LEV in GAME.levels do
      LEV.new_weapons = {}

      if LEV.prebuilt  then continue end
      if LEV.is_secret then continue end

      local w_names = table.keys(GAME.WEAPONS)
      rand.shuffle(w_names)

      each name in w_names do
        local info = GAME.WEAPONS[name]
        if (info.add_prob or 0) == 0 then continue end
        if (info.level or 1) <= LEV.weapon_level and not seen_weapons[name] then
          table.insert(LEV.new_weapons, name)
          seen_weapons[name] = true
        end

        -- prevent having too many new weapons in this map
        -- [ they get added to a later map, or simply dropped if no later maps ]
        if table.size(LEV.new_weapons) >= LEV.weapon_quota then
          break;
        end
      end
    end

    -- spread them out, esp. when next level has none and previous has >= 2,
    -- but also sometimes just to randomize things a bit.

    each LEV in GAME.levels do
      local NL = next_level_in_episode(_index)

      if NL and _index >= 2 then
        spread_new_weapons(LEV, NL)
      end
    end
  end


  local function pick_start_weapons()
    -- TODO
  end


  local function pick_other_weapons()
    -- TODO
  end


  local function pick_secret_weapons()
    -- TODO
  end


  ---| Episode_plan_weapons |---

  each LEV in GAME.levels do
    calc_weapon_level(LEV)
    decide_weapon_quota(LEV)
  end

  pick_new_weapons()

  pick_start_weapons()
  pick_other_weapons()
  pick_secret_weapons()

  dump_weapon_info()
end



function Episode_plan_items()
  --
  -- Handles certain items that should only appear quite rarely and
  -- not clumped together, e.g. the DOOM invulnerability sphere.
  --

  ---| Episode_plan_items |---

  -- TODO
end


------------------------------------------------------------------------


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


------------------------------------------------------------------------


function Episode_plan_game()
  --
  -- This plans stuff for the whole game, e.g. what weapons will
  -- appear on each level, etc....
  --
  each EPI in GAME.episodes do
    EPI.id = _index
  end

  Episode_decide_specials()

  Episode_determine_map_sizes()

  Episode_pick_names()

  Episode_plan_bosses()
  Episode_plan_weapons()
  Episode_plan_items()
end


------------------------------------------------------------------------


function Level_choose_themes()
  local theme_tab = {}


  local function collect_mixed_themes()
    each name,info in OB_THEMES do
      if info.shown and info.mixed_prob then
        theme_tab[name] = info.mixed_prob
      end
    end

    if table.empty(theme_tab) then
      error("Game is missing usable themes.")
    end
  end


  local function set_level_theme(LEV, name)
    -- don't overwrite theme of special levels
    if LEV.theme_name then
      name = LEV.theme_name
    end

    local info = OB_THEMES[name]

    if not info then
      error("Internal error : unknown OB_THEME: " .. tostring(name))
    end

    LEV.theme_name = name

    LEV.theme = GAME.THEMES[name]

    if not LEV.theme then
      error("Unknown theme : " .. name)
    end

    -- this is optional (may be nil)
    LEV.name_class = LEV.name_class or info.name_class

    gui.printf("Theme for level %s = %s\n", LEV.name, LEV.theme_name)
  end


  local function set_single_theme(name)
    each LEV in GAME.levels do
      set_level_theme(LEV, name)
    end
  end


  local function set_jumbled_themes()
    each LEV in GAME.levels do
      set_level_theme(LEV, rand.key_by_probs(theme_tab))
    end
  end


  local function set_mostly_a_theme(theme)
    if not theme_tab[theme] then
      error("Broken mostly_" .. theme .." theme")
    end

    theme_tab[theme] = nil

    local last_same = 0
    local last_diff = 99  -- force first map to be desired theme

    local max_same = 3
    local max_diff = 1

    if OB_CONFIG.length == "game" then
      max_same = 5
      max_diff = 2
    end

    each LEV in GAME.levels do
      local what

      if last_diff >= max_diff then
        what = theme
      elseif (last_same < max_same) and rand.odds(65) then
        what = theme
      else
        what = rand.key_by_probs(theme_tab)
      end

      set_level_theme(LEV, what)

      if what == theme then
        last_same = last_same + 1
        last_diff = 0
      else
        last_diff = last_diff + 1
        last_same = 0
      end
    end
  end


  local function batched_episodic_themes(episode_list)
    local pos = 1
    local count = 0

    each LEV in GAME.levels do
      if count >= 4 or (count >= 2 and rand.odds(50)) then
        pos = pos + 1
        count = 0
      end

      set_level_theme(LEV, episode_list[pos])
      count = count + 1
    end
  end


  local function set_themes_by_episode(episode_list)
    each LEV in GAME.levels do
      set_level_theme(LEV, episode_list[LEV.episode.index])
    end
  end


  local function create_episode_list(total)
    local episode_list = {}

    local tab = table.copy(theme_tab)

    while not table.empty(tab) do
      local name = rand.key_by_probs(tab)
      tab[name] = nil

      local info = OB_THEMES[name]
      local pos = rand.irange(1, total)

      if OB_CONFIG.theme == "original" then
        each epi in GAME.episodes do
          if name == epi.theme and not episode_list[_index] then
            -- this can leave gaps, but they are filled later
            pos = _index ; break
          end
        end
      end

      if episode_list[pos] then
        pos = table.find_unused(episode_list)
      end

      episode_list[pos] = name 
    end

    gui.debugf("Initial theme list = \n%s\n", table.tostr(episode_list))

    -- fill any gaps when in "As Original" mode
    if OB_CONFIG.theme == "original" then
      each epi in GAME.episodes do
        if not episode_list[_index] then
          episode_list[_index] = epi.theme
        end
      end

      assert(# episode_list == total)
    end

    return episode_list
  end


  local function flesh_out_episodes(episode_list, total)
    if total == 2 then
      local dist = rand.sel(70, 0, 1)
      table.insert(episode_list, episode_list[1 + dist])
      table.insert(episode_list, episode_list[2 - dist])
    end

    while #episode_list < 90 do
      table.insert(episode_list, episode_list[rand.irange(1, total)])
    end
  end


  ---| Level_choose_themes |---

  gui.printf("\n")

  -- need to do this first
  collect_mixed_themes()


  local mostly_theme = string.match(OB_CONFIG.theme, "mostly_(%w+)")

  -- the user can specify the main theme
  if OB_CONFIG.theme != "mixed"    and OB_CONFIG.theme != "jumble" and
     OB_CONFIG.theme != "original" and not mostly_theme
  then
    set_single_theme(OB_CONFIG.theme)
    return
  end


  -- Jumbled Up : every level is purely random
  if OB_CONFIG.theme == "jumble" then
    set_jumbled_themes()
    return
  end

  if mostly_theme then
    set_mostly_a_theme(mostly_theme)
    return
  end


  local total = table.size(theme_tab)

  if OB_CONFIG.theme == "original" then
    total = math.max(total, #GAME.episodes)
  end

  local episode_list = create_episode_list(total)

  gui.printf("Theme for episodes =\n%s\n", table.tostr(episode_list))


  flesh_out_episodes(episode_list, total)

  -- single episode is different : have a few small batches
  if OB_CONFIG.length == "episode" then
    batched_episodic_themes(episode_list)
    return
  end

  set_themes_by_episode(episode_list)
end



function Level_do_styles()
  local style_tab = table.copy(GLOBAL_STYLE_LIST)

  -- adjust styles for Co-operative multiplayer
  if OB_CONFIG.mode == "coop" then
    style_tab.cycles = { some=30, heaps=50 }
  end

  -- per game, per level and per theme style_lists
  if GAME.STYLE_LIST then
    table.merge(style_tab, GAME.STYLE_LIST)
  end
  if LEVEL.style_list then
    table.merge(style_tab, LEVEL.style_list)
  end
  if THEME.style_list then
    table.merge(style_tab, THEME.style_list)
  end

  -- decide the values
  STYLE = {}

  each name,prob_tab in style_tab do
    STYLE[name] = rand.key_by_probs(prob_tab)
  end

  -- GUI overrides...
  each name in { "outdoors", "caves", "traps" } do
    if OB_CONFIG[name] and OB_CONFIG[name] != "mixed" then
      STYLE[name] = OB_CONFIG[name]
    end
  end

  -- if level needs a secret exit, make lots of secrets
  -- (this is not strictly necessary, more an aesthetic choice)
  if LEVEL.secret_exit then
    STYLE.secrets = "heaps"
  end

  SKY_H = rand.sel(5, 768, 512)
end



function Level_choose_liquid()
  -- always have a '_LIQUID' material.
  -- this is the default, it usually gets set to a proper material
  GAME.MATERIALS["_LIQUID"] = GAME.MATERIALS["_ERROR"]

  LEVEL.liquid_usage = 0

  if not THEME.liquids then
    gui.printf("Liquid: disabled by theme.\n\n")
    return
  end

  local usage     = style_sel("liquids", 0, 25, 50, 90)
  local skip_prob = style_sel("liquids", 100, 30, 10, 0)

  if rand.odds(skip_prob) then
    gui.printf("Liquid: skipped for level (by style).\n\n")
    return
  end

  -- allow liquids, but control how much we use
  LEVEL.liquid_usage = usage
  
  -- pick the liquid to use
  local name = rand.key_by_probs(THEME.liquids)
  local liquid = GAME.LIQUIDS[name]

  if not liquid then
    error("No such liquid: " .. name)
  end

  LEVEL.liquid = liquid

  gui.printf("Liquid: %s (usage %d%%)\n\n", name, LEVEL.liquid_usage)

  -- setup the special '_LIQUID' material
  assert(liquid.mat)
  assert(GAME.MATERIALS[liquid.mat])

  GAME.MATERIALS["_LIQUID"] = GAME.MATERIALS[liquid.mat]
end



function Level_choose_darkness()
  local prob = EPISODE.dark_prob or 0

  -- FIXME: episode control currently off [ lack of decent lighting outdoors ]
  prob = 0

  -- NOTE: this style is only set via the Level Control module
  if STYLE.darkness then
    prob = style_sel("darkness", 0, 10, 30, 90)
  end

  LEVEL.indoor_light = 144
  LEVEL.sky_bright   = rand.sel(75, 192, 176)
  LEVEL.sky_shade    = LEVEL.sky_bright - 32

  if rand.odds(prob) then
    gui.printf("Darkness falls across the land...\n\n")

    LEVEL.is_dark = true
    LEVEL.sky_bright = 128
    LEVEL.sky_shade  = 128
  end
end


function Level_init()
  LEVEL.ids = {}

  LEVEL.areas = {}
  LEVEL.rooms = {}
  LEVEL.conns = {}

  LEVEL.scenic_rooms = {}
  LEVEL.map_borders  = {}
  LEVEL.depots = {}

  Level_choose_liquid()
  Level_choose_darkness()
end


function Level_build_it()
  Level_init()

  Seed_init(LEVEL.map_W, LEVEL.map_H)

  Area_create_rooms()
    if gui.abort() then return "abort" end

  Quest_make_quests()
    if gui.abort() then return "abort" end

  Room_build_all()
    if gui.abort() then return "abort" end

  Monster_make_battles()
    if gui.abort() then return "abort" end

  Item_add_pickups()
    if gui.abort() then return "abort" end

  return "ok"
end


function Level_handle_prebuilt()
  -- randomly pick one
  local probs = {}

  each info in LEVEL.prebuilt do
    probs[_index] = info.prob or 50
  end

  local info = LEVEL.prebuilt[rand.index_by_probs(probs)]

  assert(info)
  assert(info.file)
  assert(info.map)

  if GAME.format == "doom" then
    gui.wad_transfer_map(info.file, info.map, LEVEL.name)
  else
    -- FIXME: support other games (Wolf3d, Quake, etc)
  end

  return "ok"
end


function Level_between_clean()
  LEVEL    = nil
  SEEDS    = nil
  SECTIONS = nil

  collectgarbage("collect")
end


function Level_make_level(LEV)
  assert(LEV)
  assert(LEV.name)

  local index = LEV.index
  local total = #GAME.levels

  -- debugging aid : ability to build only a particular level
  if OB_CONFIG.only_map and
     string.lower(OB_CONFIG.only_map) != string.lower(LEV.name)
  then
    gui.printf("\nSkipping level: %s....\n\n", LEV.name)
    return
  end

  -- must create the description before the copy (else games/modules won't see it)
  if not LEV.description and LEV.name_class then
    LEV.description = Naming_grab_one(LEV.name_class)
  end

  -- copy level info, so that all new information added into the LEVEL
  -- object by the generator can be garbage collected once this level is
  -- finished.
  LEVEL = table.copy(LEV)

  gui.at_level(LEVEL.name, index, total)

  gui.printf("\n\n~~~~~~| %s |~~~~~~\n", LEVEL.name)

  LEVEL.seed = OB_CONFIG.seed + index * 10
  LEVEL.ids  = {}

  THEME = table.copy(assert(LEVEL.theme))

  if GAME.THEMES.DEFAULTS then
    table.merge_missing(THEME, GAME.THEMES.DEFAULTS)
  end

  gui.rand_seed(LEVEL.seed + 0)


  -- use a pre-built level ?

  if LEVEL.prebuilt then
    ob_invoke_hook("begin_level")

    local res = Level_handle_prebuilt()
    if res != "ok" then
      return res
    end

    ob_invoke_hook("end_level")
    return "ok"
  end


  gui.begin_level()
  gui.property("level_name", LEVEL.name);

  gui.rand_seed(LEVEL.seed + 1)

  Level_do_styles()

  ob_invoke_hook("begin_level")

  gui.printf("\nStyles = \n%s\n\n", table.tostr(STYLE, 1))


  local error_mat = assert(GAME.MATERIALS["_ERROR"])

  gui.property("error_tex",  error_mat.t)
  gui.property("error_flat", error_mat.f or error_mat.t)

  if LEVEL.description then
    gui.property("description", LEVEL.description)
  end


  gui.rand_seed(LEVEL.seed + 2)

  local res = Level_build_it()
  if res != "ok" then
    return res
  end


  ob_invoke_hook("end_level")

  if LEVEL.indoor_light then gui.property("indoor_light", LEVEL.indoor_light) end
  if LEVEL.sky_bright   then gui.property("sky_bright", LEVEL.sky_bright) end
  if LEVEL.sky_shade    then gui.property("sky_shade",  LEVEL.sky_shade)  end

  gui.end_level()


  if index < total then
    Level_between_clean()
  end

  if gui.abort() then return "abort" end

  return "ok"
end


function Level_make_all()
  GAME.levels   = {}
  GAME.episodes = {}


  gui.rand_seed(OB_CONFIG.seed + 1)

  ob_invoke_hook("get_levels")

  if #GAME.levels == 0 then
    error("Level list is empty!")
  end

  table.index_up(GAME.levels)
  table.index_up(GAME.episodes)


  gui.rand_seed(OB_CONFIG.seed + 2)

  Level_choose_themes()


  gui.rand_seed(OB_CONFIG.seed + 3)

  Episode_plan_game()

  Title_generate()


  each EPI in GAME.episodes do
    EPISODE = EPI

    EPISODE.seen_weapons = {}

    each LEV in EPI.levels do
      LEV.allowances = {}

      if Level_make_level(LEV) == "abort" then
        return "abort"
      end
    end
  end

  ob_invoke_hook("all_done")

  return "ok"
end

