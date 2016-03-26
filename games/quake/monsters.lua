------------------------------------------------------------------------
--  QUAKE MONSTERS
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2016 Andrew Apted
--  Copyright (C)      2011 Chris Pisarczyk
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

QUAKE.MONSTERS =
{
  dog =
  {
    id = "monster_dog"
    r = 32  -- dogs are fat!
    h = 80 
    -- we use 'replaces' here to simulate the way dogs
    -- usually appear with grunts.
    replaces = "grunt"
    replace_prob = 30
    crazy_prob = 20
    health = 25
    damage = 8
    attack = "melee"
  }

  fish =
  {
    id = "monster_fish"
    r = 16
    h = 80 
    -- only appears in water
    health = 25
    damage = 3
    attack = "melee"
    weap_prefs = { grenade=0.2 }
  }

  grunt =
  {
    id = "monster_army"
    r = 16
    h = 80 
    level = 1
    prob = 80
    health = 30
    damage = 14
    attack = "hitscan"
    give = { {ammo="shell",count=5} }
    disloyal = true
  }

  enforcer =
  {
    id = "monster_enforcer"
    r = 16
    h = 80 
    level = 2
    prob = 40
    health = 80
    damage = 18
    attack = "missile"
    give = { {ammo="cell",count=5} }
    density  =  0.5
  }

  zombie =
  {
    id = "monster_zombie"
    r = 16
    h = 80 
    level = 2
    prob = 40
    health = 60
    damage = 8
    attack = "melee"
    weap_needed = { grenade=1,rocket=1 }
    weap_prefs = { grenade=99,rocket=99 }
  }

  scrag =
  {
    id = "monster_wizard"
    r = 16
    h = 80 
    level = 2
    prob = 60
    health = 80
    damage = 18
    attack = "missile"
    weap_prefs = { grenade=0.2 }
  }

  tarbaby =
  {
    id = "monster_tarbaby"
    r = 16
    h = 80 
    level = 3
    prob = 1
    health = 80
    damage = 30
    attack = "melee"
    density = 0.3
    weap_prefs = { rocket=0.2,grenade=0.2 }
  }

  knight =
  {
    id = "monster_knight"
    r = 16
    h = 80 
    level = 1
    prob = 60
    density  =  0.6
    health = 75
    damage = 15
    attack = "melee"
  }

  ogre =
  {
    id = "monster_ogre"
    r = 32
    h = 80 
    level = 3
    prob = 40
    health = 200
    damage = 25
    attack = "missile"
    give = { {ammo="rocket",count=2} }
    density  =  0.4
  }

  fiend =
  {
    id = "monster_demon1"
    r = 32
    h = 80 
    level = 4
    prob = 10
    health = 300
    damage = 40
    attack = "melee"
    density  =  0.3
    weap_prefs = { grenade=0.2 }
  }

  ---| BOSSES |---

  dth_knight =
  {
    id = "monster_hell_knight"
    r = 32
    h = 80 
    level = 5
    boss_type = "minor"
    prob = 30
    density  =  0.4
    health = 250
    damage = 30
    attack = "missile"
  }

  Vore =
  {
    id = "monster_shalrath"
    r = 32
    h = 80 
    level = 7
    boss_type = "tough"
    prob = 10
    health = 400
    damage = 60
    attack = "missile"
    density  =  0.2
  }

  Shambler =
  {
    id = "monster_shambler"
    r = 32
    h = 80 
    boss_type = "tough"
    level = 7
    prob = 10
    health = 600
    damage = 50
    attack = "hitscan"
    immunity   = { rocket=0.5,grenade=0.5 }
    weap_prefs = { rocket=0.2,grenade=0.2 }
    density  =  0.2
  }
}

