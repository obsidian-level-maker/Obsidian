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
-- prob       : general probability
-- crazy_prob : probability for "Crazy" strength setting
--
-- health : hit points of monster
-- damage : damage can inflict per second (rough approx)
-- attack : kind of attack (hitscan | missile | melee)
--
-- float  : true if monster floats (flys)
-- invis  : true if invisible (or partially)
--
-- weap_prefs : weapon preferences table
--
-- NOTES:
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
-- Damage value is a rough guess / completely bogus.
--
-- Spider Mastermind damage has been lowered (from 200),
-- since it was creating way too much health in levels.
--

DOOM.MONSTERS =
{
  zombie =
  {
    id = 3004
    r = 20
    h = 56 
    level = 1
    prob = 40
    health = 20
    damage = 4
    attack = "hitscan"
    give = { {ammo="bullet",count=5} }
    density = 1.5
    infights = true
  }

  shooter =
  {
    id = 9
    r = 20
    h = 56 
    level = 2
    prob = 50
    health = 30
    damage = 15
    attack = "hitscan"
    give = { {weapon="shotty"}, {ammo="shell",count=4} }
    species = "zombie"
    infights = true
  }

  imp =
  {
    id = 3001
    r = 20
    h = 56 
    level = 1
    prob = 60
    health = 60
    damage = 20
    attack = "missile"
  }

  skull =
  {
    id = 3006
    r = 16
    h = 56 
    level = 3
    prob = 16
    health = 100
    damage = 7
    attack = "melee"
    density = 0.5
    float = true
    weap_prefs = { launch=0.2 }
    infights = true
  }

  demon =
  {
    id = 3002
    r = 30
    h = 56 
    level = 1
    prob = 35
    health = 150
    damage = 25
    attack = "melee"
    weap_prefs = { launch=0.5 }
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
    damage = 25
    attack = "melee"
    invis = true
    outdoor_factor = 3.0
    weap_prefs = { launch=0.2 }
    species = "demon"
  }

  caco =
  {
    id = 3005
    r = 31
    h = 56 
    level = 3
    prob = 40
    health = 400
    damage = 35
    attack = "missile"
    density = 0.5
    float = true
  }

  baron =
  {
    id = 3003
    r = 24
    h = 64 
    level = 7
    prob = 20
    health = 1000
    damage = 45
    attack = "missile"
    density = 0.5
    weap_prefs = { bfg=3.0 }
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
    skip_prob = 150
    health = 4000
    damage = 150
    attack = "missile"
    density = 0.1
    weap_prefs = { bfg=5.0 }
  }

  Mastermind =
  {
    id = 7
    r = 128
    h = 100
    level = 9
    prob = 20
    crazy_prob = 18
    skip_prob = 150
    health = 3000
    damage = 70
    attack = "hitscan"
    density = 0.2
    weap_prefs = { bfg=5.0 }
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
    prob = 20
    health = 70
    damage = 50
    attack = "hitscan"
    give = { {weapon="chain"}, {ammo="bullet",count=10} }
    species = "zombie"
    infights = true
  }

  revenant =
  {
    id = 66
    r = 20
    h = 64 
    level = 5
    prob = 40
    skip_prob = 90
    health = 300
    damage = 70
    attack = "missile"
    density = 0.6
  }

  knight =
  {
    id = 69
    r = 24
    h = 64 
    level = 5
    prob = 60
    skip_prob = 90
    crazy_prob = 40
    health = 500
    damage = 45
    attack = "missile"
    density = 0.7
    species = "baron"
  }

  mancubus =
  {
    id = 67
    r = 48
    h = 64 
    level = 6
    prob = 37
    health = 600
    damage = 70
    attack = "missile"
    density = 0.6
  }

  arach =
  {
    id = 68
    r = 64
    h = 64 
    level = 6
    prob = 25
    health = 500
    damage = 70
    attack = "missile"
    density = 0.8
  }

  vile =
  {
    id = 64
    r = 20
    h = 56 
    level = 7
    prob = 17
    skip_prob = 120
    health = 700
    damage = 40
    attack = "hitscan"
    density = 0.2
    never_promote = true
  }

  pain =
  {
    id = 71
    r = 31
    h = 56 
    level = 6
    prob = 8
    crazy_prob = 15
    skip_prob = 180
    health = 800  -- 400 + skulls
    damage = 20
    attack = "missile"
    density = 0.2
    never_promote = true
    float = true
    weap_prefs = { launch=0.2 }
  }

  -- NOTE: not generated in normal levels
  ss_dude =
  {
    id = 84
    r = 20
    h = 56 
    level = 1
    crazy_prob = 7
    skip_prob = 300
    health = 50
    damage = 15
    attack = "hitscan"
    give = { {ammo="bullet",count=5} }
    density = 2.0
  }
}


DOOM.INFIGHT_SHEET =
{
  -- default for same species : friends (no harm)
  same = "friend"

  -- default for different species : hurt and fight each other
  different = "infight"
}

