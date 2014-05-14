--------------------------------------------------------------------
--  DOOM MONSTERS
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2013 Andrew Apted
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
-- crazy_prob : probability for "Crazy" strength setting
--
-- health : hit points of monster
-- damage : total damage inflicted on player (on average)
-- attack : kind of attack (hitscan | missile | melee)
-- density : how many too use (e.g. 0.5 = half the normal amount)
--
-- float  : true if monster floats (flies)
-- invis  : true if invisible (or partially)
--
-- weap_prefs : weapon preferences table
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
-- killed), hence the health is set to 700 instead of 400.
--

DOOM.MONSTERS =
{
  zombie =
  {
    id = 3004
    r = 20
    h = 56 
    level = 1
    prob = 35
    health = 20
    damage = 1
    attack = "hitscan"
    give = { {ammo="bullet",count=5} }
    density = 1.5
    room_size = "small"
    infights = true
  }

  shooter =
  {
    id = 9
    r = 20
    h = 56 
    level = 2
    prob = 55
    health = 30
    damage = 8
    attack = "hitscan"
    give = { {weapon="shotty"}, {ammo="shell",count=4} }
    species = "zombie"
    room_size = "small"
    infights = true
  }

  imp =
  {
    id = 3001
    r = 20
    h = 56 
    level = 1
    prob = 65
    health = 60
    damage = 3
    attack = "missile"
    room_size = "small"
  }

  skull =
  {
    id = 3006
    r = 16
    h = 56 
    level = 3
    prob = 20
    health = 100
    damage = 1
    attack = "melee"
    float = true
    weap_prefs = { launch=0.2 }
    room_size = "small"
    infights = true
  }

  demon =
  {
    id = 3002
    r = 30
    h = 56 
    level = 1
    prob = 40
    health = 150
    damage = 2
    attack = "melee"
    weap_prefs = { launch=0.5 }
    room_size = "any"
  }

  spectre =
  {
    id = 58
    r = 30
    h = 56 
    replaces = "demon"
    replace_prob = 25
    crazy_prob = 21
    health = 150
    damage = 3
    attack = "melee"
    invis = true
    outdoor_factor = 3.0
    weap_prefs = { launch=0.2 }
    species = "demon"
    room_size = "any"
  }

  caco =
  {
    id = 3005
    r = 31
    h = 56 
    level = 3
    prob = 40
    health = 400
    damage = 5
    attack = "missile"
    density = 0.5
    float = true
    room_size = "large"
  }

  baron =
  {
    id = 3003
    r = 24
    h = 64 
    level = 7
    prob = 20
    health = 1000
    damage = 20
    attack = "missile"
    density = 0.5
    weap_prefs = { bfg=3.0 }
    room_size = "medium"
  }


  ---| DOOM BOSSES |---

  Cyberdemon =
  {
    id = 16
    r = 40
    h = 110
    level = 9
    prob = 17
    crazy_prob = 12
    health = 4000
    damage = 150
    attack = "missile"
    density = 0.1
    weap_prefs = { bfg=5.0 }
    room_size = "medium"
  }

  Mastermind =
  {
    id = 7
    r = 128
    h = 100
    level = 9
    prob = 20
    crazy_prob = 18
    health = 3000
    damage = 200
    attack = "hitscan"
    density = 0.2
    weap_prefs = { bfg=5.0 }
    room_size = "large"
  }
}


DOOM2.MONSTERS =
{
  gunner =
  {
    id = 65
    r = 20
    h = 56 
    level = 3
    prob = 25
    health = 70
    damage = 15
    attack = "hitscan"
    give = { {weapon="chain"}, {ammo="bullet",count=10} }
    species = "zombie"
    room_size = "large"
    infights = true
  }

  revenant =
  {
    id = 66
    r = 20
    h = 64 
    level = 5
    prob = 40
    health = 300
    damage = 15
    attack = "missile"
    density = 0.6
    room_size = "any"
  }

  knight =
  {
    id = 69
    r = 24
    h = 64 
    level = 5
    prob = 60
    crazy_prob = 40
    health = 500
    damage = 10
    attack = "missile"
    density = 0.7
    species = "baron"
    room_size = "medium"
  }

  mancubus =
  {
    id = 67
    r = 48
    h = 64 
    level = 6
    prob = 37
    health = 600
    damage = 20
    attack = "missile"
    density = 0.6
    room_size = "large"
  }

  arach =
  {
    id = 68
    r = 64
    h = 64 
    level = 6
    prob = 25
    health = 500
    damage = 15
    attack = "missile"
    density = 0.7
    room_size = "medium"
  }

  vile =
  {
    id = 64
    r = 20
    h = 56 
    level = 7
    prob = 17
    health = 700
    damage = 50
    attack = "hitscan"
    density = 0.2
    room_size = "medium"
    nasty = true
  }

  pain =
  {
    id = 71
    r = 31
    h = 56 
    level = 6
    prob = 8
    crazy_prob = 15
    health = 800  -- 400 + skulls
    damage = 20
    attack = "missile"
    density = 0.2
    float = true
    weap_prefs = { launch=0.2 }
    room_size = "large"
    cage_factor = 0  -- never put in cages
    nasty = true
  }

  -- NOTE: not generated in normal levels
  ss_dude =
  {
    id = 84
    r = 20
    h = 56 
    level = 1
    theme = "wolf"
    prob = 20
    crazy_prob = 7
    health = 50
    damage = 5
    attack = "hitscan"
    give = { {ammo="bullet",count=5} }
    density = 1.5
  }
}

