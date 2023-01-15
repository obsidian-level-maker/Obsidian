------------------------------------------------------------------------
--  HEXEN PICKUP ITEMS
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

HEXEN.PICKUPS =
{
  -- HEALTH --

  h_vial =
  {
    id = 81,
    kind = "health",
    add_prob = 60,
    cluster = { 1,4 },
    give = { {health=10} },
  },

  h_flask =
  {
    id = 82,
    kind = "health",
    add_prob = 120,
    give = { {health=25} },
  },

  -- AMMO --

  blue_mana =
  {
    id = 122,
    kind = "ammo",
    add_prob = 20,
    give = { {ammo="blue_mana",count=15} },
  },

  green_mana =
  {
    id = 124,
    kind = "ammo",
    add_prob = 20,
    give = { {ammo="green_mana",count=15} },
  },

-- ARMOR --

  ar_helmet =
  {
    id = 8007,
    kind = "armor",
    add_prob = 5,
    give = { {health=25} }
  },

}


--------------------------------------------------

HEXEN.NICE_ITEMS =
{
  -- HEALTH --

  h_urn =
  {
    id = 32,
    kind = "health",
    add_prob = 5,
    give = { {health=100} },
  },

  -- ARMOR --

  ar_mesh =
  {
    id = 8005,
    kind = "armor",
    add_prob = 5,
    give = { {health=50} },
  },

  ar_shield =
  {
    id = 8006,
    kind = "armor",
    add_prob = 5,
    give = { {health=100} },
  },

  ar_amulet =
  {
    id = 8008,
    kind = "armor",
    add_prob = 5,
    give = { {health=50} },
  },

  dragonskin_bracers =
  {
    id = 10110,
    kind = "armor",
    add_prob = 7,
    start_prob = 0,
    closet_prob = 15,
    give = { {health=50} },
  },

-- AMMO --

dual_mana =
{
  id = 8004,
  kind = "ammo",
  add_prob = 50,
  give =
  {
    {ammo="blue_mana", count=20},
    {ammo="green_mana",count=20},
  },
},

krater_of_might =
{
  id = 8003,
  kind = "ammo",
  add_prob = 7,
  start_prob = 0,
  closet_prob = 15,
  give =
  {
    {ammo="blue_mana", count=200},
    {ammo="green_mana",count=200},
  },
},

-- ARTIFACTS --

banishment_device =
{
  id = 10040,
  kind = "powerup",
  add_prob = 7,
  start_prob = 0,
  closet_prob = 15,
},

boots_of_speed =
{
  id = 8002,
  kind = "powerup",
  add_prob = 7,
  start_prob = 0,
  closet_prob = 15,
},

chaos_device =
{
  id = 36,
  kind = "powerup",
  add_prob = 7,
  start_prob = 0,
  closet_prob = 15,
},

dark_servant =
{
  id = 86,
  kind = "powerup",
  add_prob = 7,
  start_prob = 0,
  closet_prob = 15,
},

disc_of_repulsion =
{
  id = 10110,
  kind = "powerup",
  add_prob = 7,
  start_prob = 0,
  closet_prob = 15,
},

flechette =
{
  id = 8000,
  kind = "powerup",
  add_prob = 15,
  start_prob = 0,
  closet_prob = 30,
},

icon_of_the_defender =
{
  id = 84,
  kind = "powerup",
  add_prob = 7,
  start_prob = 0,
  closet_prob = 15,
  time_limit = 30,
},

mystic_ambit_incant =
{
  id = 10120,
  kind = "powerup",
  add_prob = 7,
  start_prob = 0,
  closet_prob = 15,
},

porkalator =
{
  id = 30,
  kind = "powerup",
  add_prob = 7,
  start_prob = 0,
  closet_prob = 15,
},

torch =
{
  id = 33,
  kind = "powerup",
  add_prob = 7,
  start_prob = 0,
  closet_prob = 15,
  time_limit = 120,
},

wings_of_wrath =
{
  id = 83,
  kind = "powerup",
  add_prob = 7,
  start_prob = 0,
  closet_prob = 15,
  time_limit = 60,
},

-- Weapon Pieces

h_ultimate_piece_one = 
{
  id = 7002,
  kind = "other",
  add_prob = 1,
  secret_prob = 1,
  once_only = true,
  weapon_piece_ids = 
  {
    { id=20, flags=0x0040 }, 
    { id=16, flags=0x0020 },
    { id=23, flags=0x0080 }
  }
},

h_ultimate_piece_two = 
{
  id = 7003,
  kind = "other",
  add_prob = 1,
  secret_prob = 1,
  once_only = true,
  weapon_piece_ids = 
  {
    { id=19, flags=0x0040 }, 
    { id=13, flags=0x0020 },
    { id=22, flags=0x0080 }
  }
},

h_ultimate_piece_three = 
{
  id = 7004,
  kind = "other",
  add_prob = 1,
  secret_prob = 1,
  once_only = true,
  weapon_piece_ids = 
  {
    { id=18, flags=0x0040 }, 
    { id=12, flags=0x0020 },
    { id=21, flags=0x0080 }
  }
},

}

