----------------------------------------------------------------
--  FIGHT SIMULATOR
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


--[[

===================
 BATTLE SIMULATION
===================

Inputs:
   monsters   : list of monsters that the player must kill
   weapons    : list of weapons that player can use
   weap_prefs : weapon preference table (can be empty)

Output:
   stats    : health that player needs to survive the battle
              + ammo quantities required by the player

Notes:
------

*  Health result is stored in the 'stats' table.  All the
   values are >= 0 and can be partial (like 3.62 rockets).

*  Armor is not directly modelled.  Instead you can assume
   that some percentage of the returned 'health' would have
   been saved if the player was wearing armor.

*  Powerups are not modelled.  The assumption here is that
   any powerups on the level are bonuses for the player
   and not a core part of gameplay.  It could be handled
   by being stingy on health/ammo in the room containing
   the powerup (and subsequent rooms).

*  Monsters are "fought" one by one in the given list,
   sorted from most threatening to least threatening
   (which is likely how the real player would tackle them).
   Your weapons can damage other monsters though, including
   such things as rocket splash, shotgun spread, the BFG
   etc...

   All of the monsters are fighting the player.  They are
   assumed to be linearly spread out (first one is closest
   and last one is far away), 2D layouts are not modelled.
   Further away monsters do less damage, we also assume
   that closer monsters get in the way (especially for
   missile attacks), and that melee monsters can only hurt
   you when they are first (at most second) in the list.

*  Infighting between monsters is modelled but is toned
   down, since the real layout will make a big difference
   to the results, so we aim for some kind of average.

TODO: this routine should accept some information
      about the environment, such as amount of cover
      the player has, and take it into account.

----------------------------------------------------------------]]


function Fight_Simulator(monsters, weapons, weap_prefs, stats)

  local active_mons = {}

  local PLAYER_ACCURACY = 0.8

  local HITSCAN_DODGE = 0.25  -- UNUSED, REMOVE THESE
  local MISSILE_DODGE = 0.85
  local MELEE_DODGE   = 0.95

  local HITSCAN_RATIOS = { 1.0, 0.75, 0.5, 0.25 }  -- UNUSED, REMOVE THESE
  local MISSILE_RATIOS = { 1.0, 0.25 }
  local MELEE_RATIOS   = { 1.0 }

  local INFIGHT_RATIOS = { 0.7, 0.5, 0.3 }


  local function remove_dead_mon()
    for i = #active_mons,1,-1 do
      if active_mons[i].health <= 0 then
        table.remove(active_mons, i)
      end
    end
  end


  local function select_weapon()
    local first_mon = active_mons[1].info
    assert(first_mon)

    -- determine probability for each weapon
    local probs = {}

    each W in weapons do
      local pref = W.pref * (weap_prefs[W.name] or 1)

      -- handle monster-based weapon preferences
      if first_mon.weap_prefs then
        pref = pref * (first_mon.weap_prefs[W.name] or 1)
      end

      table.insert(probs, pref)
    end

    assert(#probs == #weapons)

    local index = rand.index_by_probs(probs)

    return assert(weapons[index])
  end


  local function hurt_mon(idx, W, damage)
    local M = active_mons[idx]

    if not M then return end

    if M.info.immunity and M.info.immunity[W.name] then
      damage = damage * (1 - M.info.immunity[W.name])
    end

    M.health = M.health - damage
  end


  local function splash_mons(W, list)
    for idx,damage in ipairs(list) do
      hurt_mon(idx, W, damage)
    end
  end


  local function player_shoot(W)
    hurt_mon(1, W, W.damage * PLAYER_ACCURACY)

    -- simulate splash damage | shotgun spread
    if W.splash then
      splash_mons(W, W.splash)
    end

    -- update ammo counter
    if W.ammo then
      stats[W.ammo] = (stats[W.ammo] or 0) + (W.per or 1)
    end

    return 1 / W.rate
  end


  local function OLD__monster_hit_player(M, idx, time)
    local info = M.info

    -- how likely the monster is to hit the player
    -- (depends on distance between them).
    local hit_ratio

    -- how well the player can dodge the monster's attack
    -- TODO: take 'cover' and/or 'space' into account here
    local dodge_ratio


    if info.attack == "melee" then
      hit_ratio   = MELEE_RATIOS[idx]
      dodge_ratio = MELEE_DODGE

    elseif info.attack == "hitscan" then
      hit_ratio   = HITSCAN_RATIOS[idx]
      dodge_ratio = HITSCAN_DODGE

    elseif info.attack == "missile" then
      hit_ratio   = MISSILE_RATIOS[idx]
      dodge_ratio = MISSILE_DODGE

    else
      error("Unknown monster attack kind: " .. tostring(info.attack))
    end

    assert(dodge_ratio)

    -- monster is too far away to hurt player?
    if not hit_ratio then return end

    -- how often the monster fights the player (instead of running
    -- around or being in a pain state).
    local active_ratio = info.activity or 0.5

    local damage = info.damage * time * hit_ratio * active_ratio * (1.0 - dodge_ratio)

    stats.health = stats.health + damage
  end


  local function calc_infight_mode(info1, info2)
    -- looks up the monster pair in the infighting table.
    -- this table has entries like this:
    --    xxx__yyy  = "friend"
    --    aaaa__bbb = "hurt"
    --
    -- result can be:
    --    "friend"  : completely immune to each other
    --    "hurt"    : can hurt each other, but won't retaliate
    --    "infight" : can hurt and fight each other
    --
    -- the monster field 'infights' can be set to true, but
    -- this only applies to monsters of the same species.
    -- 

    local species1 = info1.species or info1.name
    local species2 = info2.species or info2.name

    if species1 == species2 and info1.infights then
      return "infight"
    end

    local sheet = GAME.INFIGHT_SHEET

    -- have a reasonable default
    if not sheet then
      return sel(species1 == species2, "friend", "hurt")
    end

    local result

    result = sheet[species1 .. "__" .. species2]
    if result then return result end

    -- try the pair reversed
    result = sheet[species2 .. "__" .. species1]
    if result then return result end

    if species1 == species2 then
      return sheet["same"] or "friend"
    else
      return sheet["different"]  or "hurt"
    end
  end


  local function OLD__monster_hit_monster(M, other_idx, time, factor)
    if other_idx < 1 then return end

    -- 'N' for the monster nearer the player (earlier in the list)
    local N = active_mons[other_idx] 

    if M.health <= 0 or N.health <= 0 then return end

    local mode = calc_infight_mode(M.info, N.info)

    if mode == "friend" then return end

    -- furthest monster hurts the nearest one
    local dm1 = M.info.damage * (M.info.activity or 0.5) * time

    N.health = N.health - dm1 * factor

    if mode != "infight" then return end

    -- nearest one retaliates sometimes
    local dm2 = N.info.damage * (N.info.activity or 0.5) * time

    M.health = M.health - dm2 * factor * 0.5
  end


  local function OLD__monsters_shoot(time)
    for idx,M in ipairs(active_mons) do
      -- skip dead monsters
      if M.health <= 0 then continue end

      if idx < 9 then
        monster_hit_player(M, idx, time)
      end

      local infight_dist   = rand.irange(1,3)
      local infight_factor = INFIGHT_RATIOS[infight_dist]

      monster_hit_monster(M, idx - infight_dist, time, infight_factor)
    end
  end


  local function fixup_hexen_mana()
    if stats.dual_mana then
      stats.blue_mana  = (stats.blue_mana  or 0) + stats.dual_mana
      stats.green_mana = (stats.green_mana or 0) + stats.dual_mana
      stats.dual_mana  = nil
    end
  end


  local function calc_monster_threat(info)
    local threat = info.health + info.damage * 7

    return threat + gui.random() * 20  -- tie breaker
  end


  ---==| Fight_Simulator |==---

  stats.health = stats.health or 0

  each name,info in monsters do
    local MON =
    {
      info   = info
      health = info.health
      threat  = calc_monster_threat(info)
    }
    table.insert(active_mons, MON)
  end

  -- put toughest monster first, weakest last.
  table.sort(active_mons,
      function(A,B) return A.threat > B.threat end)

---##  -- let the monsters throw the first punch (albeit a weak one)
---##  monsters_shoot(0.5)

  -- TODO: new infight logic : run through active_mons _once_ and
  --       allow neighbors separated by 4 monsters to hurt each other.

  -- compute health needed by player
  each M in active_mons do
    stats.health = stats.health + M.info.damage
  end
 
  -- run simulation until all monsters are dead
  while #active_mons > 0 do
    local W = select_weapon()

    local shots = int(rand.range(2.0, 8.0) * W.rate + 0.5)

    if shots < 2  then shots = 2  end
    if shots > 30 then shots = 30 end

    for loop = 1,shots do
      player_shoot(W)
 
---##  monsters_shoot(time)

      remove_dead_mon()
    end
  end

  fixup_hexen_mana()
end

