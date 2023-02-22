--------------------------------------------------------------------
--  DOOM MONSTERS
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C) 2011, 2019 Armaetus
--  Copyright (C) 2019-2022 MsrShooterPerson
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------

-- Usable keywords
-- ===============
--
-- id         : editor number used to place monster on the map
-- level      : how far along (over episode) it should appear (1..9)
--
-- prob       : general probability of being used
-- crazy_prob : probability for "Crazy" setting (default is 50)
--
-- health : hit points of monster
-- damage : total damage inflicted on player (on average)
-- attack : kind of attack (hitscan | missile | melee)
-- density : how many too use (e.g. 0.5 = half the normal amount)
--
-- float  : true if monster floats (flies)
-- invis  : true if invisible (or partially)
--
-- weap_needed : weapons player must have to fight this monster
-- weap_min_damage : damage (per second) of player weapon required
-- weap_prefs : weapon preferences table (usage by player)
-- disloyal   : can hurt a member of same species
-- infight_damage : damage inflicted on one (or more) other monsters
--
--
-- NOTES
-- =====
--
-- Some monsters (e.g. IMP) have both a close-range melee
-- attack and a longer range missile attack.  This is not
-- modelled, we just pick the one with the most damage.
--

DOOM.MONSTERS =
{
  zombie =
  {
    id = 3004,
    r = 20,
    h = 56,
    level = 1,
    prob = 50,
    health = 20,
    damage = 1.2,
    attack = "hitscan",
    replaces = "shooter",
    replace_prob = 20,
    give = { {ammo="bullet",count=5} },
    weap_prefs = { shotty=1.2, chain=1.5 },
    density = 1.5,
    room_size = "any", --small
    disloyal = true,
    trap_factor = 0.75,
    infight_damage = 1.9,
  },

  shooter =
  {
    id = 9,
    r = 20,
    h = 56,
    level = 1.7,
    prob = 90,
    health = 30,
    damage = 3.0,
    attack = "hitscan",
    density = 1.0,
    give = { {weapon="shotty"}, {ammo="shell",count=4} },
    weap_prefs = { shotty=1.2, chain=1.5 },
    weap_needed = { shotty=true },
    species = "zombie",
    replaces = "zombie",
    replace_prob = 20,
    room_size = "any", --small
    disloyal = true,
    trap_factor = 1.0, --2.0,
    infight_damage = 6.1,
  },

  imp =
  {
    id = 3001,
    r = 20,
    h = 56,
    level = 1,
    prob = 140,
    health = 60,
    damage = 1.3,
    attack = "missile",
    density = 1.0,
    replaces = "demon",
    replace_prob = 20,
    weap_prefs = { shotty=1.5, chain=1.25, super=1.2 },
    room_size = "any", --small
    trap_factor = 0.5, --0.3,
    infight_damage = 4.0,
  },

  skull =
  {
    id = 3006,
    r = 16,
    h = 56,
    level = 4, -- STOP SHOWING UP ON MAP01!!
    prob = 25,
    health = 100,
    damage = 1.7,
    attack = "melee",
    density = 0.5,
    float = true,
    weap_prefs = { super=1.5, chain=1.3, launch=0.3 },
    room_size = "any", --small
    disloyal = true,
    trap_factor = 0.35, --0.2,
    cage_factor = 0,
    infight_damage = 2.1,
  },

  demon =
  {
    id = 3002,
    r = 30,
    h = 56,
    level = 3, --2 --1.75,
    prob = 50,
    health = 150,
    damage = 0.4,
    attack = "melee",
    density = 0.85,
    weap_min_damage = 40,
    weap_prefs = { super=1.75, shotty=1.35, chain=1.3, plasma=1.1, launch=0.3 },
    trap_factor = 0.4,
    room_size = "any",
    infight_damage = 3.5,
  },

  spectre =
  {
    id = 58,
    r = 30,
    h = 56,
    level = 3, --2.8 --1.75,
    replaces = "demon",
    replace_prob = 35,
    crazy_prob = 25,
    health = 150,
    damage = 1.0,
    attack = "melee",
    density = 0.5,
    invis = true,
    outdoor_factor = 3.0,
    weap_min_damage = 40,
    weap_prefs = { super=1.75, shotty=1.5, chain=1.4, plasma=1.1, launch=0.1 },
    species = "demon",
    room_size = "any",
    trap_factor = 0.3,
    infight_damage = 2.5,
  },

  caco =
  {
    id = 3005,
    r = 31,
    h = 56,
    level = 4, --3 --3.8,
    prob = 30,
    health = 400,
    damage = 4.0,
    attack = "missile",
    density = 0.6,
    weap_min_damage = 40,
    float = true,
    weap_prefs = { launch=1.25, super=1.75, chain=1.2, shotty=0.7, plasma=1.2 },
    replaces = "pain",
    replace_prob = 15,
    room_size = "any", --large
    trap_factor = 0.5,
    infight_damage = 21,
  },


  ---| BOSSES |---

  baron =
  {
    id = 3003,
    r = 24,
    h = 64,
    level = 6,
    boss_type = "minor",
    boss_prob = 50,
    prob = 6.4,
    crazy_prob = 20,
    weap_prefs = { launch=1.75, super=1.5, plasma=1.75, bfg=1.5 },
    health = 1000,
    damage = 7.5,
    attack = "missile",
    density = 0.3,
    weap_min_damage = 88,
    room_size = "any", --medium
    trap_factor = 0.15,
    infight_damage = 40,
  },

  Cyberdemon =
  {
    id = 16,
    r = 40,
    h = 110,
    level = 8, --7,
    boss_type = "tough",
    boss_prob = 50,
    prob = 1.6,
    crazy_prob = 10,
    health = 4000,
    damage = 125,
    attack = "missile",
    density = 0.1,
    weap_min_damage = 150,
    weap_prefs = { bfg=10.0 },
    room_size = "large", --medium
    infight_damage = 1600,
    cage_factor = 0,
    boss_replacement = "baron",
  },

  Spiderdemon =
  {
    id = 7,
    r = 128,
    h = 100,
    level = 9,
    boss_type = "tough",
    boss_prob = 15,
    boss_limit = 1, -- because they infight
    prob = 1.0,
    crazy_prob = 10,
    health = 3000,
    damage = 100,
    attack = "hitscan",
    density = 0.1,
    weap_min_damage = 200,
    weap_prefs = { bfg=10.0 },
    room_size = "large",
    infight_damage = 700,
    boss_replacement = "Cyberdemon",
  },
}
