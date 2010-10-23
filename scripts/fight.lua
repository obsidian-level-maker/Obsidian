----------------------------------------------------------------
--  FIGHT SIMULATOR
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2010 Andrew Apted
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

require 'defs'
require 'util'


function Fight_Simulator(monsters, weapons, weap_prefs, stats)

  local active_mons = {}

  local PLAYER_ACCURACY = 0.8

  local HITSCAN_DODGE = 0.25
  local MISSILE_DODGE = 0.85
  local MELEE_DODGE   = 0.95

  local HITSCAN_RATIOS = { 1.0, 0.8, 0.6, 0.4, 0.2, 0.1 }
  local MISSILE_RATIOS = { 1.0, 0.3, 0.1 }
  local MELEE_RATIOS   = { 1.0, 0.1 }


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

    for idx,W in ipairs(weapons) do
      probs[idx] = assert(W.pref)

      -- support a 'pref_equiv' name, useful for modules
      for pass = 1,2 do
        local name = sel(pass==1, W.name, W.pref_equiv)
        if name then
          probs[idx] = probs[idx] * (weap_prefs[name] or 1)

          -- handle monster-based weapon preferences
          if first_mon.weap_prefs then
            probs[idx] = probs[idx] * (first_mon.weap_prefs[name] or 1)
          end
        end
      end -- for pass
    end -- for W

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
      stats[W.ammo] = (stats[W.ammo] or 0) + W.per
    end

    return 1 / W.rate
  end


  local function monster_hit_player(M, idx, time)
    local info = M.info

    -- how likely the monster is to hit the player
    -- (depends on distance between them).
    local hit_ratio

    -- how well the player can dodge the monster's attack
    -- TODO: take 'cover' and/or 'space' into account here
    local dodge_ratio


    if info.no_dist then
      hit_ratio   = 1.0
      dodge_ratio = 0.0

    elseif info.attack == "melee" then
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


  local function monster_infight(M, N, time)
    -- FIXME: properly model pseudo-infighting, where one monster
    --        accidentally hits (and hurt) another, but the other
    --        monster doesn't retaliate.

    if not PARAM.infighting then
      return
    end

    if N.health <= 0 then
      return
    end

    -- FIXME: provide a table-based way instead !!!!
    if GAME.check_infight_func then
      if not GAME.check_infight_func(M.info, N.info) then
        return
      end
    else
      -- default -> only different species infight 
      if M.info == N.info then
        return
      end
    end

    -- monster on monster action!
    local dm1 = M.info.damage * (M.info.activity or 0.5) * time
    local dm2 = N.info.damage * (N.info.activity or 0.5) * time

    local factor = 0.25 -- assume it happens rarely

    M.health = M.health - dm2 * factor
    N.health = N.health - dm1 * factor
  end


  local function monsters_shoot(time)
    for idx,M in ipairs(active_mons) do
      if M.health > 0 then
        monster_hit_player(M, idx, time)
        if idx >= 2 then
          monster_infight(M, active_mons[idx-1], time)
        end
      end
    end
  end


  local function fixup_hexen_mana()
    if stats.dual_mana then
      stats.blue_mana  = (stats.blue_mana  or 0) + stats.dual_mana
      stats.green_mana = (stats.green_mana or 0) + stats.dual_mana
      stats.dual_mana  = nil
    end
  end


  ---==| Fight_Simulator |==---

  stats.health = 0

  for _,info in ipairs(monsters) do
    local MON =
    {
      info=info, health=info.health,
      power=info.damage + info.health/30 + gui.random(),
    }
    table.insert(active_mons, MON)
  end

  -- put toughest monster first, weakest last.
  table.sort(active_mons, function(A,B) return A.power > B.power end)

  -- let the monsters throw the first punch (albeit a weak one)
  monsters_shoot(0.5)

  while #active_mons > 0 do
    local W = select_weapon()

    local shots = int(rand.range(2.0, 8.0) * W.rate + 0.5)

    if shots < 2  then shots = 2  end
    if shots > 30 then shots = 30 end

    for loop = 1,shots do
      local time = player_shoot(W)
      monsters_shoot(time)
      remove_dead_mon()
    end
  end

  fixup_hexen_mana()
end

