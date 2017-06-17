--------------------------------------------------------------------
--  DOOM PICKUPS
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2016 Andrew Apted
--  Copyright (C)      2011 Chris Pisarczyk
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------

--
-- Usable keywords
-- ===============
--
-- id          : editor number used to place item on the map
--
-- add_prob    : chance of adding as a general pickup [absent = never]
-- start_prob  : if present, use instead of add_prob in start rooms
-- crazy_prob  : if present, use instead of add_prob in "crazy" mode
--
-- closet_prob  : chance of using in a small secret closet
-- secret_prob  : chance of using in a large secret room
-- storage_prob : chance of using in a storage room
--
-- level       : how far along (over episode) it should appear (1..9)
--
-- kind        : a keyword: health / armor / ammo / powerup / other
-- rank        : the general niceness of the item (1..3)
-- cluster     : how many to place together (a range of values)
-- give        : list of what the player gets (e.g. quantity of ammo)
--
-- time_limit  : how long a powerup lasts (in seconds)
--


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
    add_prob = 120
    closet_prob = 20
    secret_prob = 5
    storage_prob = 80
    storage_qty  = 2
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
    add_prob = 50
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
    closet_prob = 20
    secret_prob = 5
    storage_prob = 20
    storage_qty  = 3
    give = { {ammo="rocket",count=5} }
  }

  cells =
  {
    id = 2047
    kind = "ammo"
    add_prob = 20
    closet_prob = 20
    cluster = { 2,5 }
    give = { {ammo="cell",count=20} }
  }

  cell_pack =
  {
    id = 17
    kind = "ammo"
    rank = 2
    add_prob = 40
    secret_prob = 5
    storage_prob = 40
    storage_qty  = 2
    give = { {ammo="cell",count=100} }
  }

  --
  -- NOTES:
  --
  -- Armor (all types) is modelled as health, because it merely
  -- saves the player's health when you are hit with damage.
  -- For example, the BLUE jacket saves 50% of damage, hence
  -- it is roughly equivalent to 100 units of health.
  --
}


--------------------------------------------------------------------


DOOM.NICE_ITEMS =
{
  -- HEALTH / ARMOR --

  green_armor =
  {
    id = 2018
    kind = "armor"
    add_prob = 40
    start_prob = 60
    crazy_prob = 5
    closet_prob = 10
    give = { {health=30} }
  }

  blue_armor =
  {
    id = 2019
    kind = "armor"
    add_prob = 5
    start_prob = 10
    secret_prob = 60
    give = { {health=80} }
  }

  soul =
  {
    id = 2013
    kind = "health"
    add_prob = 5
    start_prob = 0
    closet_prob = 2
    secret_prob = 40
    give = { {health=150} }
  }

  backpack =
  {
    id = 8
    kind = "ammo"
    add_prob = 40
    start_prob = 80
    closet_prob = 10
    give = { {ammo="bullet",count=10 }, {ammo="shell", count=4 },
             {ammo="cell",  count=20 }, {ammo="rocket",count=1 } }
  }

  -- WEAPONS --

  saw =
  {
    id = 2005
    kind = "other"  -- really a weapon
    add_prob = 5
    secret_prob = 10
    once_only = true
  }

  berserk =
  {
    id = 2023
    kind = "health"  -- treat it like a big health item
    add_prob = 10
    secret_prob = 20
    give = { {health=70} }
  }

  -- POWERUP --

  invis =
  {
    id = 2024
    kind = "powerup"
    add_prob = 7
    start_prob = 0
    closet_prob = 15
    time_limit = 100
  }

  invul =
  {
    id = 2022
    kind = "powerup"
    level = 4
    add_prob = 2
    start_prob = 0
    closet_prob = 7
    secret_prob = 7
    time_limit = 30
  }

  allmap =
  {
    id = 2026
    kind = "powerup"
    secret_prob = 10
    once_only = true
  }

  goggles =
  {
    id = 2045
    kind = "powerup"
    secret_prob = 10
    time_limit = 120
  }

  radsuit =
  {
    id = 2025
    kind = "powerup"
    time_limit = 60
  }

  -- Doom II only --

  mega =
  {
    id = 83
    kind = "health"
    level = 3
    add_prob = 1
    start_prob = 0
    secret_prob = 20
    give = { {health=200} }
  }

  --
  -- NOTES:
  --
  -- The All-map is for secrets only, hence has no add_prob.
  --
  -- Radiation suit has no probs (and hence is never added) since it
  -- needs special logic, e.g. when creating areas of nukage or lava
  -- which the player is forced to cross.
  --
}

