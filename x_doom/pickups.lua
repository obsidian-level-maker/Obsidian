--------------------------------------------------------------------
--  DOOM PICKUPS
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2013 Andrew Apted
--  Copyright (C)      2011 Chris Pisarczyk
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------

DOOM.PICKUPS =
{
  -- HEALTH --

  potion =
  {
    id = 2014
    kind = "health"
    rank = 0
    prob = 20
    cluster = { 4,7 }
    give = { {health=1} }
  }

  stimpack =
  {
    id = 2011
    kind = "health"
    rank = 1
    prob = 60
    cluster = { 2,5 }
    give = { {health=10} }
  }

  medikit =
  {
    id = 2012
    kind = "health"
    rank = 2
    prob = 100
    give = { {health=25} }
  }

  soul =
  {
    id = 2013
    kind = "health"
    rank = 5
    prob = 3
    start_prob = 5
    give = { {health=150} }
  }

  -- ARMOR --

  helmet =
  {
    id = 2015
    kind = "armor"
    rank = 0
    prob = 10
    cluster = { 4,7 }
    give = { {health=1} }
  }

  green_armor =
  {
    id = 2018
    kind = "armor"
    rank = 3
    prob = 5
    start_prob = 80
    give = { {health=30} }
  }

  blue_armor =
  {
    id = 2019
    kind = "armor"
    rank = 4
    prob = 2
    start_prob = 30
    give = { {health=80} }
  }

  -- AMMO --

  bullets =
  {
    id = 2007
    kind = "ammo"
    rank = 0
    prob = 10
    cluster = { 2,5 }
    give = { {ammo="bullet",count=10} }
  }

  bullet_box =
  {
    id = 2048
    kind = "ammo"
    rank = 1
    prob = 40
    give = { {ammo="bullet",count=50} }
  }

  shells =
  {
    id = 2008
    kind = "ammo"
    rank = 0
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="shell",count=4} }
  }

  shell_box =
  {
    id = 2049
    kind = "ammo"
    rank = 1
    prob = 40
    give = { {ammo="shell",count=20} }
  }

  rocket =
  {
    id = 2010
    kind = "ammo"
    rank = 0
    prob = 10
    cluster = { 4,7 }
    give = { {ammo="rocket",count=1} }
  }

  rocket_box =
  {
    id = 2046
    kind = "ammo"
    rank = 1
    prob = 40
    give = { {ammo="rocket",count=5} }
  }

  cells =
  {
    id = 2047
    kind = "ammo"
    rank = 0
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="cell",count=20} }
  }

  cell_pack =
  {
    id = 17
    kind = "ammo"
    rank = 2
    prob = 40
    give = { {ammo="cell",count=100} }
  }


  -- NOTES:
  --
  -- Berserk is handled as a WEAPON instead of a pickup.
  --
  -- The backpack is handled as a POWERUP.
  --
  -- Armor (all types) is modelled as health, because it merely
  -- saves the player's health when you are hit with damage.
  -- The BLUE jacket saves 50% of damage, hence it is roughly
  -- equivalent to 100 units of health.
}


DOOM2.PICKUPS =
{
  mega =
  {
    id = 83
    kind = "health"
    rank = 6
    prob = 1
    start_prob = 8
    give = { {health=200} }
  }
}

