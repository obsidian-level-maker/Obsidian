------------------------------------------------------------------------
--  STRIFE WEAPONS
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

STRIFE.WEAPONS =
{
  dagger =
  {
    attack = "melee",
    rate = 1.5,
    damage = 10,
  },

  assault =
  {
    id = 2002,
    level = 1,
    pref = 20,
    add_prob = 10,
    attack = "hitscan",
    rate = 1.8,
    accuracy = 75,
    damage = 8,
    ammo = "bullet",
    per = 3,
    give = { {ammo="bullet", count=20} }
  },

  crossbow = -- Base stats are based on electric bolt usage - Dasho
  {
    id = 2001,
    level = 1,
    pref = 20,
    add_prob = 10,
    attack = "missile",
    rate = 1.2,
    accuracy = 100,
    damage = 10,
    ammo = "bolt",
    per = 1,
    give = { {ammo="bolt", count=8} }
  },

  grenade_launcher = -- Base stats are based on explosive grenade usage - Dasho
  {
    id = 154,
    level = 1,
    pref = 20,
    add_prob = 10,
    attack = "missile",
    rate = 1.2,
    accuracy = 100,
    damage = 192,
    ammo = "grenade",
    per = 2,
    give = { {ammo="grenade", count=12} }
  },

  mauler =
  {
    id = 2004,
    level = 1,
    pref = 20,
    add_prob = 10,
    attack = "hitscan",
    rate = 1.8,
    accuracy = 75,
    damage = 15,
    ammo = "cell",
    per = 3,
    give = { {ammo="cell", count=40} }
  },

  flamethrower =
  {
    id = 2005,
    level = 1,
    pref = 20,
    add_prob = 10,
    attack = "hitscan",
    rate = 1.8,
    accuracy = 75,
    damage = 20,
    ammo = "cell",
    per = 3,
    give = { {ammo="cell", count=100} }
  },

}

