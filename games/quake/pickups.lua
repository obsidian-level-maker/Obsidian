------------------------------------------------------------------------
--  QUAKE PICKUPS
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

QUAKE.PICKUPS =
{
  -- HEALTH --

  heal_10 =
  {
    id = "item_health"
    spawnflags = 1
    prob = 20
    cluster = { 1,2 }
    give = { {health=8} }   -- real amount is 5-10 units
  }

  heal_25 =
  {
    id = "item_health"
    spawnflags = 0
    prob = 50
    give = { {health=25} }
  }

  -- AMMO --

  shell_20 =
  {
    id = "item_shells"
    spawnflags = 0
    prob = 10
    give = { {ammo="shell",count=20} }
  }

  shell_40 =
  {
    id = "item_shells"
    spawnflags = 1
    prob = 20
    give = { {ammo="shell",count=40} }
  }

  nail_25 =
  {
    id = "item_spikes"
    spawnflags = 0
    prob = 10
    give = { {ammo="nail",count=25} }
  }

  nail_50 =
  {
    id = "item_spikes"
    spawnflags = 1
    prob = 20
    give = { {ammo="nail",count=50} }
  }

  rocket_5 =
  {
    id = "item_rockets"
    spawnflags = 0
    prob = 10
    give = { {ammo="rocket",count=5} }
  }

  rocket_10 =
  {
    id = "item_rockets"
    spawnflags = 1
    prob = 20
    give = { {ammo="rocket",count=10} }
  }

  cell_6 =
  {
    id = "item_cells"
    spawnflags = 0
    prob = 10
    give = { {ammo="cell",count=6} }
  }

  cell_12 =
  {
    id = "item_cells"
    spawnflags = 1
    prob = 20
    give = { {ammo="cell",count=12} }
  }
}


----------------------------------------------------


QUAKE.NICE_ITEMS =
{
  mega =
  {
    id = "item_health"
    spawnflags = 2
    add_prob = 3
    big_item = true
    give = { {health=70} }  -- gives 100 but it rots aways
  }

  -- ARMOR --

  green_armor =
  {
    id = "item_armor1"
    add_prob = 9
    give = { {health=30} }
  }

  yellow_armor =
  {
    id = "item_armor2"
    add_prob = 3
    give = { {health=90} }
  }

  red_armor =
  {
    id = "item_armorInv"
    add_prob = 1
    give = { {health=160} }
  }

  -- POWERUPS --

  -- FIXME : quake powerups
}

