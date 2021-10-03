------------------------------------------------------------------------
--  WOLF3D WEAPONS
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

WOLF.WEAPONS =
{
  knife =
  {
    pref=1,
    rate=3.0, damage=7, attack="melee",
  },

  pistol =
  {
    pref=10,
    rate=3.0, damage=17, attack="hitscan",
    ammo="bullet", per=1,
  },

  machine_gun =
  {
    pref=20, add_prob=20,
    rate=8.0, damage=17, attack="hitscan",
    ammo="bullet", per=1,
    give={ {ammo="bullet",give=6} },
  },

  gatling_gun =
  {
    pref=30, add_prob=50, rarity=4,
    rate=16,  damage=17, attack="hitscan",
    ammo="bullet", per=1,
    give={ {ammo="bullet",give=6} },
  },
}


