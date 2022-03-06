------------------------------------------------------------------------
--  HEXEN WEAPONS
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2011 Andrew Apted
--  Copyright (C) 2011-2012 Jared Blackburn
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

HEXEN.WEAPONS =
{

  h_weapon_one =
  {
    pref = 10,
    attack = "melee",
    rate = 2.0,
    damage = 30,
  },

  h_weapon_two = 
  {
    id = 7000,
    pref = 30,
    attack = "missile",
    add_prob = 10,
    rate = 2.0,
    damage = 45,
    ammo = "blue_mana",
    per = 2,
    give = { {ammo="blue_mana",count=25} },
    level = 2,
    class_weapon_ids = 
    {
      { id=10, flags=0x0040 }, 
      { id=8010, flags=0x0020 },
      { id=53, flags=0x0080 }
    }
  },

  h_weapon_three = 
  {
    id = 7001,
    pref = 60,
    attack = "missile",
    add_prob = 10,
    rate = 1.25,
    damage = 81,
    ammo = "green_mana",
    per = 4,
    give = { {ammo="green_mana",count=25} },
    level = 4,
    class_weapon_ids = 
    { 
      { id=8009, flags=0x0040 },
      { id=123, flags=0x0020 },
      { id=8040, flags=0x0080 }
    }
  },
}

