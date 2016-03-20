------------------------------------------------------------------------
--  EPISODE / WHOLE GAME PLANNING
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
    id : number        -- index number (in GAME.episodes)

    description       -- a name generated for this episode

    hub : HUB_INFO    -- present for hub-based games (esp. Hexen)

    levels : list(LEVEL)  -- all the levels to generate (may be empty)


--]]


--class HUB_INFO
--[[
    used_keys : table  -- for hubs, remember keys which have been used
                       -- on any level in the hub (cannot use them again)
--]]



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



function Episode_monster_stuff()
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


  ---| Episode_monster_stuff |---

  each LEV in GAME.levels do
    calc_monster_level(LEV)
  end
end



function Episode_weapon_stuff()
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
      weap_along = math.min(1.0, weap_along * 3.0)
    end

    -- small adjustment for the 'Weapons' setting
    if OB_CONFIG.weapons == "more" then
      weap_along = weap_along ^ 0.8 + 0.2
    end

    LEV.weapon_level = 1 + 9 * weap_along

    gui.debugf("Weapon level in %s : %1.1f\n", LEV.name, LEV.weapon_level)
  end


  ---| Episode_weapon_stuff |---

  each LEV in GAME.levels do
    calc_weapon_level(LEV)
  end
end



function Episode_item_stuff()
  --
  -- Handles certain items that should only appear quite rarely and
  -- not clumped together, e.g. the DOOM invulnerability sphere.
  --

  ---| Episode_item_stuff |---

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

  Episode_pick_names()

  Episode_monster_stuff()
  Episode_weapon_stuff()
  Episode_item_stuff()
end

