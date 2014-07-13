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
    add_prob = 20
    cluster = { 4,7 }
    give = { {health=1} }
  }

  stimpack =
  {
    id = 2011
    kind = "health"
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
    add_prob = 10
    cluster = { 4,7 }
    give = { {health=1} }
  }

  -- AMMO --

  bullets =
  {
    id = 2007
    kind = "ammo"
    add_prob = 10
    cluster = { 2,5 }
    give = { {ammo="bullet",count=10} }
  }

  bullet_box =
  {
    id = 2048
    kind = "ammo"
    rank = 2
    add_prob = 40
    give = { {ammo="bullet",count=50} }
  }

  shells =
  {
    id = 2008
    kind = "ammo"
    add_prob = 20
    cluster = { 2,5 }
    give = { {ammo="shell",count=4} }
  }

  shell_box =
  {
    id = 2049
    kind = "ammo"
    rank = 2
    add_prob = 40
    give = { {ammo="shell",count=20} }
  }

  rocket =
  {
    id = 2010
    kind = "ammo"
    add_prob = 10
    cluster = { 4,7 }
    give = { {ammo="rocket",count=1} }
  }

  rocket_box =
  {
    id = 2046
    kind = "ammo"
    rank = 2
    add_prob = 40
    give = { {ammo="rocket",count=5} }
  }

  cells =
  {
    id = 2047
    kind = "ammo"
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
  -- Armor (all types) is modelled as health, because it merely
  -- saves the player's health when you are hit with damage.
  -- The BLUE jacket saves 50% of damage, hence it is roughly
  -- equivalent to 100 units of health.
}


--------------------------------------------------------------------


DOOM.NICE_ITEMS =
{
  --- Note: 'saw' and 'berserk' could have been here, instead of
  --        being weapons.  But as weapons their quantity can be
  --        controlled via the Weapon Control module.

  -- HEALTH / ARMOR --

  green_armor =
  {
    id = 2018
    kind = "armor"
    add_prob = 30
    start_prob = 60
    crazy_prob = 5
    give = { {health=30} }
  }

  blue_armor =
  {
    id = 2019
    kind = "armor"
    add_prob = 5
    start_prob = 10
    secret_prob = 50
    give = { {health=80} }
  }

  soul =
  {
    id = 2013
    kind = "health"
    add_prob = 20
    start_prob = 5
    secret_prob = 50
    give = { {health=150} }
  }

  backpack =
  {
    id = 8
    kind = "other"
    add_prob = 40
    start_prob = 80
    secret_prob = 10
  }

  -- POWERUP --

  invis =
  {
    id = 2024
    kind = "powerup"
    add_prob = 5
    secret_prob = 70
    time_limit = 100
  }

  invul =
  {
    id = 2022
    kind = "powerup"
    add_prob = 1
    secret_prob = 110
    time_limit = 30
  }

  allmap =
  {
    id = 2026
    kind = "powerup"
    secret_prob = 90
  }

  goggles =
  {
    id = 2045
    kind = "powerup"
    add_prob = 5
    secret_prob = 25
    crazy_prob  = 10
    time_limit = 120
  }

  --
  -- NOTES:
  --
  -- Radiation suit is not here, since it needs special logic
  -- (namely to create areas with a nukage or lava floor which the
  --  player is forced to cross).
  --
  -- The All-map is for secrets only, hence has no 'add_prob'.
  --
}


DOOM2.NICE_ITEMS =
{
  mega =
  {
    id = 83
    kind = "health"
    add_prob = 1
    secret_prob = 70
    give = { {health=200} }
  }
}

