--------------------------------------------------------------------
--  DOOM MONSTERS
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2015 Andrew Apted
--  Copyright (C)      2011 Chris Pisarczyk
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------

-- Usable keywords
-- ===============
--
-- prob       : general probability of being used
-- crazy_prob : probability for "Crazy" setting (default is 50)
--
-- health : hit points of monster
-- damage : total damage inflicted on player (average * accuracy)
-- attack : kind of attack (hitscan | missile | melee)
-- density : how many too use (e.g. 0.5 = half the normal amount)
--
-- float  : true if monster floats (flies)
-- invis  : true if invisible (or partially)
--
-- min_weapon : level of weapon required for monster to appear
-- weap_prefs : weapon preferences table (usage by player)
-- disloyal   : can hurt a member of same species
-- infight_damage : damage inflicted on one (or more) other monsters
--
-- NOTES
-- =====
--
-- Some monsters (e.g. IMP) have both a close-range melee
-- attack and a longer range missile attack.  This is not
-- modelled, we just pick the one with the most damage.
--
-- Archvile attack is not a real hitscan, but for modelling
-- purposes that is a reasonable approximation.
--
-- Similarly the Pain Elemental attack is not a real missile
-- but actually a Lost Soul.  It spawns at least three (when
-- killed), and often more, hence the health is much higher.
--

DOOM.MONSTERS =
{
  zombie =
  {
    id = 3004
    r = 20
    h = 56 
    level = 1
    prob = 50
    health = 20
    damage = 1.2
    attack = "hitscan"
    give = { {ammo="bullet",count=5} }
    density = 1.5
    room_size = "small"
    disloyal = true
    infight_damage = 1.9
  }

  shooter =
  {
    id = 9
    r = 20
    h = 56 
    level = 2
    prob = 90
    health = 30
    damage = 3.0
    attack = "hitscan"
    give = { {weapon="shotty"}, {ammo="shell",count=4} }
    species = "zombie"
    room_size = "small"
    disloyal = true
    infight_damage = 6.1
  }

  imp =
  {
    id = 3001
    r = 20
    h = 56 
    level = 1
    prob = 140
    health = 60
    damage = 1.3
    attack = "missile"
    room_size = "small"
    infight_damage = 4.0
  }

  skull =
  {
    id = 3006
    r = 16
    h = 56 
    level = 3
    prob = 25
    health = 100
    damage = 1.7
    attack = "melee"
    float = true
    weap_prefs = { launch=0.3 }
    room_size = "small"
    disloyal = true
    infight_damage = 2.1
  }

  demon =
  {
    id = 3002
    r = 30
    h = 56 
    level = 2
    prob = 50
    health = 150
    damage = 0.4
    attack = "melee"
    min_weapon = 1
    weap_prefs = { launch=0.3 }
    room_size = "any"
    infight_damage = 3.5
  }

  spectre =
  {
    id = 58
    r = 30
    h = 56 
    replaces = "demon"
    replace_prob = 35
    crazy_prob = 25
    health = 150
    damage = 1.0
    attack = "melee"
    invis = true
    outdoor_factor = 3.0
    min_weapon = 1
    weap_prefs = { launch=0.1 }
    species = "demon"
    room_size = "any"
    infight_damage = 2.5
  }

  caco =
  {
    id = 3005
    r = 31
    h = 56 
    level = 3
    prob = 30
    health = 400
    damage = 4.0
    attack = "missile"
    density = 0.5
    min_weapon = 1
    float = true
    room_size = "large"
    infight_damage = 21
  }

  baron =
  {
    id = 3003
    r = 24
    h = 64 
    level = 7
    prob = 6.4
    crazy_prob = 20
    health = 1000
    damage = 7.5
    attack = "missile"
    density = 0.35
    min_weapon = 3
    room_size = "medium"
    infight_damage = 40
  }


  ---| DOOM BOSSES |---

  Cyberdemon =
  {
    id = 16
    r = 40
    h = 110
    level = 9
    prob = 1.6
    crazy_prob = 10
    health = 4000
    damage = 125
    attack = "missile"
    density = 0.1
    min_weapon = 4
    weap_prefs = { bfg=10.0 }
    room_size = "medium"
    infight_damage = 1600
  }

  Mastermind =
  {
    id = 7
    r = 128
    h = 100
    level = 9
    prob = 1.0
    crazy_prob = 10
    health = 3000
    damage = 100
    attack = "hitscan"
    density = 0.2
    min_weapon = 5
    weap_prefs = { bfg=10.0 }
    room_size = "large"
    infight_damage = 700
  }


  ---== Doom II only ==---

  gunner =
  {
    id = 65
    r = 20
    h = 56 
    level = 3
    prob = 65
    health = 70
    damage = 4.5
    attack = "hitscan"
    give = { {weapon="chain"}, {ammo="bullet",count=10} }
    min_weapon = 1
    species = "zombie"
    room_size = "large"
    disloyal = true
    infight_damage = 15
  }

  revenant =
  {
    id = 66
    r = 20
    h = 64 
    level = 5
    prob = 32
    health = 300
    damage = 8.5
    attack = "missile"
    min_weapon = 1
    density = 0.6
    room_size = "any"
    infight_damage = 20
  }

  knight =
  {
    id = 69
    r = 24
    h = 64 
    level = 5
    prob = 26
    health = 500
    damage = 4.0
    attack = "missile"
    min_weapon = 1
    density = 0.7
    species = "baron"
    room_size = "medium"
    infight_damage = 36
  }

  mancubus =
  {
    id = 67
    r = 48
    h = 64 
    level = 6
    prob = 20
    health = 600
    damage = 8.0
    attack = "missile"
    density = 0.5
    min_weapon = 3
    room_size = "large"
    infight_damage = 70
  }

  arach =
  {
    id = 68
    r = 64
    h = 64 
    level = 6
    prob = 12
    health = 500
    damage = 10.7
    attack = "missile"
    min_weapon = 1
    density = 0.7
    room_size = "medium"
    infight_damage = 62
  }

  vile =
  {
    id = 64
    r = 20
    h = 56 
    level = 7
    prob = 5
    crazy_prob = 15
    health = 700
    damage = 25
    attack = "hitscan"
    density = 0.2
    room_size = "medium"
    min_weapon = 4
    nasty = true
    infight_damage = 18
  }

  pain =
  {
    id = 71
    r = 31
    h = 56 
    level = 6
    prob = 10
    crazy_prob = 15
    health = 900  -- 400 + 5 skulls
    damage = 14.5 -- about 5 skulls
    attack = "missile"
    density = 0.1
    float = true
    min_weapon = 3
    weap_prefs = { launch=0.1 }
    room_size = "large"
    cage_factor = 0  -- never put in cages
    nasty = true
    infight_damage = 4.5 -- guess
  }

  -- NOTE: not generated in normal levels
  ss_nazi =
  {
    id = 84
    r = 20
    h = 56 
    level = 1
    theme = "wolf"
    prob = 40
    crazy_prob = 2
    health = 50
    damage = 2.8
    attack = "hitscan"
    give = { {ammo="bullet",count=5} }
    density = 1.5
    infight_damage = 6.0
  }
}

