------------------------------------------------------------------------
--  STRIFE PICKUP ITEMS
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2015 Andrew Apted
--  Copyright (C) 2011-2012 Jared Blackburn
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

STRIFE.PICKUPS =
{

 -- Health --

 medpatch =
 {
   id = 2011,
   kind = "health",
   add_prob = 60,
   cluster = { 2,5 },
   give = { {health=10} },
 },

 medkit =
 {
   id = 2012,
   kind = "health",
   rank = 2,
   add_prob = 120,
   closet_prob = 20,
   secret_prob = 5,
   storage_prob = 80,
   storage_qty  = 2,
   give = { {health=50} },
 },

 -- ammo -- 

   bullet_clip =
  {
    id = 2007,
    add_prob = 10,
    cluster = { 2,5 },
    give = { {ammo="bullet",count=10} }
  },

  bullet_box =
  {
    id = 2048,
    add_prob = 10,
    give = { {ammo="bullet",count=50} }
  },

  energy_pod =
  {
    id = 2047,
    add_prob = 10,
    cluster = { 2,5 },
    give = { {ammo="cell",count=20} }
  },

  mini_missile =
  {
    id = 2010,
    add_prob = 10,
    cluster = { 1,2 },
    give = { {ammo="missile",count=4} }
  },

  electric_bolts =
  {
    id = 114,
    add_prob = 10,
    cluster = { 1,2 },
    give = { {ammo="bolt",count=20} }
  },

  poison_bolts =
  {
    id = 115,
    add_prob = 2,
    cluster = { 1,2 },
    give = { {ammo="bolt",count=10} }
  },

  explosive_grenades =
  {
    id = 152,
    add_prob = 10,
    cluster = { 1,2 },
    give = { {ammo="grenade",count=6} }
  },

  phosphorous_grenades =
  {
    id = 153,
    add_prob = 2,
    cluster = { 1,2 },
    give = { {ammo="grenade",count=4} }
  },

}


--------------------------------------------------

STRIFE.NICE_ITEMS =
{

  energy_pack =
  {
    id = 17,
    add_prob = 10,
    give = { {ammo="cell",count=100} }
  },

  missile_crate =
  {
    id = 2046,
    add_prob = 10,
    give = { {ammo="missile",count=20} }
  },

}

