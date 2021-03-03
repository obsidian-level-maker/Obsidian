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

  --
  -- NOTES:
  --
  -- Armor gives different amounts (and different decay rates)
  -- for each player class.  We cannot model that completely.
  -- Instead the 'best_class' gets the full amount and all
  -- other classes get half the amount.
  --
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
    give = { {health=150} },
    best_class = "fighter",
  },

  ar_shield =
  {
    id = 8006,
    kind = "armor",
    add_prob = 5,
    give = { {health=150} },
    best_class = "cleric",
  },

  ar_amulet =
  {
    id = 8008,
    kind = "armor",
    add_prob = 5,
    give = { {health=150} },
    best_class = "mage",
  },

  ar_helmet =
  {
    id = 8007,
    kind = "armor",
    add_prob = 5,
    give = { {health=60} }  -- rough average
  },

  -- FIXME : ARTIFACTS

--[[ TODO

  p1 = { pickup="flechette", prob=9 },
  p2 = { pickup="bracer",    prob=5 },
  p3 = { pickup="torch",     prob=2 },

--]]
}

