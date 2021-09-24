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
    damage = 10,
    ammo = "bullet",
    per = 3,
    give = { {ammo="bullet", count=20} }
  },

}

