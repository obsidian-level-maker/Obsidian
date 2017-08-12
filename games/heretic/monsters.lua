------------------------------------------------------------------------
--  HERETIC MONSTERS
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

HERETIC.MONSTERS =
{
  gargoyle =
  {
    id = 66
    r = 16
    h = 36
    level = 1
    prob = 60
    density = 1.5
    health = 20
    damage = 0.7
    attack = "melee"
    float = true
  }

  fire_garg =
  {
    id = 5
    r = 16
    h = 36
    level = 2
    prob = 40
    density = 0.8
    health = 80
    damage = 2.5
    attack = "missile"
    float = true
  }

  golem =
  {
    id = 68
    r = 22
    h = 64
    level = 1
    prob = 40
    density = 1.0
    health = 80
    damage = 1.5
    attack = "melee"
    give = { {ammo="crystal",count=1} }
  }

  golem_ghost =
  {
    id = 69
    r = 22
    h = 64
    level = 2.2
    prob = 5
    density = 0.2
    health = 80
    damage = 2.0
    attack = "melee"
    give = { {ammo="crystal",count=1} }
    weap_prefs = { staff=0.1, crossbow=0.1, hellstaff=0.1, firemace=0.1 }
    invis = true
  }

  warrior =
  {
    id = 64
    r = 24
    h = 80
    level = 1.7
    prob = 22
    density = 1.0
    health = 200
    damage = 3.5
    attack = "missile"
    give = { {ammo="arrow",count=1.6} }
  }

  warrior_ghost =
  {
    id = 65
    r = 24
    h = 80
    level = 3.1
    prob = 5
    density = 0.2
    health = 200
    damage = 5.0
    attack = "missile"
    give = { {ammo="arrow",count=1.6} }
    weap_prefs = { staff=0.1, crossbow=0.1, hellstaff=0.1, firemace=0.1 }
    invis = true
  }

  nitro =   -- a golem on steroids
  {
    id = 45
    r = 22
    h = 64
    level = 2.7
    prob = 20
    density = 0.5
    health = 100
    damage = 2.2
    attack = "missile"
    give = { {ammo="crystal",count=1} }
  }

  nitro_ghost =
  {
    id = 46
    r = 22
    h = 64
    level = 3.7
    prob = 5
    density = 0.2
    health = 100
    damage = 5.0
    attack = "missile"
    give = { {ammo="crystal",count=1} }
    weap_prefs = { staff=0.1, crossbow=0.1, hellstaff=0.1, firemace=0.1 }
    invis = true
  }

  sabreclaw =
  {
    id = 90
    r = 20
    h = 64
    level = 2.9
    prob = 45
    density = 0.5
    health = 150
    damage = 1.2
    attack = "melee"
    give = { {ammo="rune",count=6} }
  }

  disciple =
  {
    id = 15
    r = 16
    h = 72
    level = 3.4
    prob = 30
    density = 0.3
    health = 180
    damage = 10.0
    attack = "missile"
    give = { {ammo="claw_orb",count=3} }
    float = true
  }

  weredragon =
  {
    id = 70
    r = 34
    h = 80
    level = 4.1
    prob = 30
    density = 0.5
    health = 220
    damage = 4.0
    attack = "missile"
    give = { {ammo="arrow",count=3} }
  }

  ophidian =
  {
    id = 92
    r = 22
    h = 72
    level = 4.5
    prob = 22
    density = 0.3
    health = 280
    damage = 12.5
    attack = "missile"
    give = { {ammo="flame_orb",count=1.6} }
  }


  ---| BOSSES |---

  Ironlich =
  {
    id = 6
    r = 40
    h = 72 
    level = 5
    boss_type = "minor"
    boss_prob = 50
    prob = 4
    density = 0.1
    health = 700
    attack = "missile"
    damage = 30.0
    give = { {ammo="claw_orb",count=3} }
    float = true
  }

  Maulotaur =
  {
    id = 9
    r = 28
    h = 104
    level = 7
    boss_type = "nasty"
    boss_prob = 50
    prob = 2
    density = 0.1
    health = 3000
    attack = "missile"
    damage = 100
    give  = 
    {
      {ammo="flame_orb",count=3}
      {health=10}  -- occasionally drops an Urn
    }
  }

  D_Sparil =
  {
    id = 7
    r = 28
    h = 104
    level = 9
    boss_type = "tough"
    boss_prob = 50
    prob = 1
    density = 0.1
    health = 5000
    attack = "missile"
    damage = 250
  }

  --
  -- NOTES:
  --
  -- Most monsters who drop an item after death only do so 33%
  -- of the time (randomly).  The give amounts are therefore
  -- just an average.  Some of them also (but rarely) drop
  -- artifacts (egg/tome) -- this is not modelled.
  --
  -- Some weapons are ineffective against the "Ghost" versions
  -- of monsters (the projectiles pass through them).  This is
  -- handled using "weap_prefs" (though it is not ideal).
  --
}

