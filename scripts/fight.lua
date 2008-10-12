----------------------------------------------------------------
--  FIGHT SIMULATOR
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2008 Andrew Apted
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


-- ===================
--  BATTLE SIMULATION
-- ===================
--
-- Inputs:
--    monsters : list of monsters that the player must kill
--    weapons  : list of weapons that player can use
--    skill    : skill level
--
-- Output:
--    health   : health that player needs to survive the battle
--    ammos    : ammo quantities required by the player
--
-- Notes:
--
-- *  Health result is stored in the 'ammos' table.  All the
--    values are >= 0 and can be partial (like 3.62 rockets).
--
-- *  Armor is not directly modelled.  Instead you can assume
--    that some percentage of the returned 'health' would have
--    been saved if the player was wearing armor.
--
-- *  Powerups are not modelled.  The assumption here is that
--    any powerups on the level are bonuses for the player
--    and not a core part of gameplay.  It could be handled
--    by being stingy on health/ammo in the room containing
--    the powerup (and subsequent rooms).
--
-- *  Monsters are "fought" one by one in the given list.
--    Typically they should be in order of distance from the
--    room's entrance (with some preference for having the
--    toughest monsters first, which is how the real player
--    would tackle them).  Your weapons can damage other
--    monsters though, to model such things as rocket splash,
--    shotgun spread, the BFG etc...
--
--    All of the monsters are fighting the player.  They are
--    assumed to be linearly spread out (first one is closest
--    and last one is far away), 2D layouts are not modelled.
--    Further away monsters do less damage, we also assume
--    that closer monsters get in the way (especially for
--    missile attacks), and that melee monsters can only hurt
--    you when they are first (at most second) in the list.
--
-- *  Infighting between monsters is modelled but is toned
--    down, since the real layout will make a big difference
--    to the results, so we aim for some kind of average.
--
-- TODO: this routine should accept some information
--       about the environment, such as amount of cover
--       the player has, and take it into account.
--

function fight_simulator(monsters, weapons, skill, ammos)

  local active_mon = {}

  local shoot_accuracy = PLAYER_ACCURACIES[skill]


  local function remove_dead_mon()
    for i = #active_mon,1,-1 do
      if active_mon[i].health <= 0 then
        table.remove(active_mon, i)
      end
    end
  end

  local function select_weapon()

    local first_mon = active_mon[1].info.name
    assert(first_mon)

    -- preferred weapon based on monster
    local MW_prefs
-- FIXME   if GAME.mon_weap_prefs then MW_prefs = GAME.mon_weap_prefs[first_mon] end

    local probs = {}

    for idx,W in ipairs(weapons) do
      probs[idx] = assert(W.pref)

      -- FIXME: other source of weapon preference [Theme??]

      -- handle monster-based weapon preferences
      if MW_prefs and MW_prefs[W.name] then
        probs[idx] = probs[idx] * MW_prefs[W.name]
      end

    end

    assert(#probs == #weapons)

    local wp_idx = rand_index_by_probs(probs)
    local W = weapons[wp_idx]
    assert(W)

    local time = 2.0

    return W, time
  end


  local function hurt_mon(idx, damage)
    local M = active_mon[idx]
    if M then
      M.health = M.health - damage
    end
  end

  local function splash_mons(first, num, damage)
    for i = 1,num do
      local factor = (num-i+2) / (num+1)
      hurt_mon(first+i-1, damage * factor)
    end
  end

  local function player_shoot(W, time)

    hurt_mon(1, W.dm * time * shoot_accuracy)

    -- shotguns can hit multiple monsters
    if W.spread then
      hurt_mon(2, W.dm * time * shoot_accuracy * W.spread)
    end 

    -- simulate splash damage
    if W.splash_dm then
      splash_mons(W.splash_first or 1, W.splash_num or 3,
                  W.splash_dm * time)
    end

    -- update ammo counter
    if W.info.ammo then
      ammos[W.info.ammo] = (ammos[W.info.ammo] or 0) + W.per * time
    end
  end


  local function monsters_shoot()
    -- FIXME
  end


  ---===| fight_simulator |===---

  ammos.health = 0

  for _,info in ipairs(monsters) do
    table.insert(active_mon, { info=info, health=info.hp })
  end

  -- let the monsters throw the first punch
  monsters_shoot(0.5)

  while #active_mon > 0 do
    local W, time = select_weapon()
    player_shoot(W, time)
    monsters_shoot(time)
    remove_dead_mon()
  end

  -- Hexen fixup for double-mana weapons
  if ammos.dual_mana then
    ammos.blue_mana  = (ammos.blue_mana  or 0) + ammos.dual_mana
    ammos.green_mana = (ammos.green_mana or 0) + ammos.dual_mana
    ammos.dual_mana  = nil
  end
end

