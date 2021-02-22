------------------------------------------------------------------------
--  QUAKE WEAPONS
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2012 Andrew Apted
--  Copyright (C)      2011 Chris Pisarczyk
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

QUAKE.WEAPONS =
{
  axe =
  {
    attack = "melee"
    rate = 2.0
    damage = 20
  }

  pistol =
  {
    pref = 10
    attack = "hitscan"
    rate = 2.0
    damage = 20
    ammo = "shell"
    per = 1
  }

  ssg =
  {
    id = "weapon_supershotgun"
    level = 2
    add_prob = 40
    pref = 50
    attack = "hitscan"
    rate = 1.4
    damage = 45
    splash = {0,3}
    ammo = "shell"
    per = 2
    give = { {ammo="shell",count=5} }
  }

  grenade =
  {
    id = "weapon_grenadelauncher"
    level = 3
    add_prob = 15
    pref = 12
    attack = "missile"
    rate = 1.5
    damage = 5
    splash = {60,15,3}
    ammo = "rocket"
    per = 1
    give = { {ammo="rocket",count=5} }
  }

  rocket =
  {
    id = "weapon_rocketlauncher"
    level = 5
    add_prob = 10
    pref = 30
    attack = "missile"
    rate = 1.2
    damage = 80
    splash = {0,20,6,2}
    ammo = "rocket"
    per = 1
    give = { {ammo="rocket",count=5} }
  }

  nailgun =
  {
    id = "weapon_nailgun"
    level = 1
    add_prob = 30
    pref = 50
    attack = "missile"
    rate = 5.0
    damage = 8
    ammo = "nail"
    per = 1
    give = { {ammo="nail",count=30} }
  }

  nailgun2 =
  {
    id = "weapon_supernailgun"
    level = 3
    add_prob = 10
    pref = 80
    attack = "missile"
    rate = 5.0
    damage = 18
    ammo = "nail"
    per = 2
    give = { {ammo="nail",count=30} }
  }

  zapper =
  {
    id = "weapon_lightning"
    level = 5
    add_prob = 25
    pref = 30
    attack = "hitscan"
    rate = 10
    damage = 30
    splash = {0,4}
    ammo = "cell"
    per = 1
    give = { {ammo="cell",count=15} }
  }


  -- NOTES:
  --
  -- Grenade damage (for a direct hit) is really zero, all of
  -- the actual damage comes from splash.
  --
  -- Rocket splash damage does not hurt the monster that was
  -- directly hit by the rocket.
  --
  -- Lightning bolt damage is done by three hitscan attacks
  -- over the same range (16 units apart).  As I read it, you
  -- can only hit two monsters if (a) the hitscan passes by
  -- the first one, or (b) the first one is killed.
  --
}

