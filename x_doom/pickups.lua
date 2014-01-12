--------------------------------------------------------------------
--  DOOM PICKUPS
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2014 Andrew Apted
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
    add_prob = 20
    cluster = { 4,7 }
    give = { {health=1} }
  }

  stimpack =
  {
    id = 2011
    kind = "health"
    rank = 1
    add_prob = 60
    cluster = { 2,5 }
    give = { {health=10} }
  }

  medikit =
  {
    id = 2012
    kind = "health"
    rank = 2
    add_prob = 100
    give = { {health=25} }
  }

  -- ARMOR --

  helmet =
  {
    id = 2015
    kind = "armor"
    rank = 0
    add_prob = 10
    cluster = { 4,7 }
    give = { {health=1} }
  }

  -- AMMO --

  bullets =
  {
    id = 2007
    kind = "ammo"
    rank = 0
    add_prob = 10
    cluster = { 2,5 }
    give = { {ammo="bullet",count=10} }
  }

  bullet_box =
  {
    id = 2048
    kind = "ammo"
    rank = 1
    add_prob = 40
    give = { {ammo="bullet",count=50} }
  }

  shells =
  {
    id = 2008
    kind = "ammo"
    rank = 0
    add_prob = 20
    cluster = { 2,5 }
    give = { {ammo="shell",count=4} }
  }

  shell_box =
  {
    id = 2049
    kind = "ammo"
    rank = 1
    add_prob = 40
    give = { {ammo="shell",count=20} }
  }

  rocket =
  {
    id = 2010
    kind = "ammo"
    rank = 0
    add_prob = 10
    cluster = { 4,7 }
    give = { {ammo="rocket",count=1} }
  }

  rocket_box =
  {
    id = 2046
    kind = "ammo"
    rank = 1
    add_prob = 40
    give = { {ammo="rocket",count=5} }
  }

  cells =
  {
    id = 2047
    kind = "ammo"
    rank = 0
    add_prob = 20
    cluster = { 2,5 }
    give = { {ammo="cell",count=20} }
  }

  cell_pack =
  {
    id = 17
    kind = "ammo"
    rank = 2
    add_prob = 40
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


--------------------------------------------------------------------


DOOM.NICE_ITEMS =
{
  -- WEAPONS --

  saw =
  {
    id = 2005
    kind = "weapon"
  }

  berserk =
  {
    id = 2023
    kind = "weapon"
  }

  -- HEALTH / ARMOR --

  green_armor =
  {
    id = 2018
    kind = "armor"
    rank = 3
    add_prob = 4
    start_prob = 40
    secret_prob = 20
    give = { {health=30} }
  }

  blue_armor =
  {
    id = 2019
    kind = "armor"
    rank = 4
    add_prob = 2
    start_prob = 20
    secret_prob = 50
    give = { {health=80} }
  }

  soul =
  {
    id = 2013
    kind = "health"
    rank = 5
    add_prob = 3
    secret_prob = 50
    give = { {health=150} }
  }

  -- POWERUP --

  backpack =
  {
    id = 8
    kind = "powerup"
    add_prob = 50
    start_prob = 70
    secret_prob = 10
  }

  invis =
  {
    id = 2024
    kind = "powerup"
    last_time = 100
    add_prob = 1
    secret_prob = 90
  }

  invul =
  {
    id = 2022
    kind = "powerup"
    last_time = 30
    add_prob = 1
    secret_prob = 90
  }

  allmap =
  {
    id = 2026
    kind = "powerup"
    add_prob = 1
    secret_prob = 90
  }

  goggles =
  {
    id = 2045
    kind = "powerup"
    last_time = 120
    add_prob = 1
    secret_prob = 90
  }


  -- NOTES:
  --
  -- Radiation suit is not here, since it needs special logic
  -- (namely to create areas with a nukage or lava floor which the
  --  player is forced to cross).
}


DOOM2.NICE_ITEMS =
{
  mega =
  {
    id = 83
    kind = "health"
    rank = 6
    add_prob = 1
    secret_prob = 50
    give = { {health=200} }
  }
}

