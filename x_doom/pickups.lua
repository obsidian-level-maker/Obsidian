
-- Pickup List
-- ===========

DOOM.PICKUPS =
{
  -- HEALTH --

  potion =
  {
    id = 2014
    prob = 20
    cluster = { 4,7 }
    give = { {health=1} }
  }

  stimpack =
  {
    id = 2011
    prob = 60
    cluster = { 2,5 }
    give = { {health=10} }
  }

  medikit =
  {
    id = 2012
    prob = 100
    give = { {health=25} }
  }

  soul =
  {
    id = 2013
    prob = 3
    big_item = true
    start_prob = 5
    give = { {health=150} }
  }

  -- ARMOR --

  helmet =
  {
    id = 2015
    prob = 10
    armor = true
    cluster = { 4,7 }
    give = { {health=1} }
  }

  green_armor =
  {
    id = 2018
    prob = 5
    armor = true
    big_item = true
    start_prob = 80
    give = { {health=30} }
  }

  blue_armor =
  {
    id = 2019
    prob = 2
    armor = true
    big_item = true
    start_prob = 30
    give = { {health=80} }
  }

  -- AMMO --

  bullets =
  {
    id = 2007
    prob = 10
    cluster = { 2,5 }
    give = { {ammo="bullet",count=10} }
  }

  bullet_box =
  {
    id = 2048
    prob = 40
    give = { {ammo="bullet",count=50} }
  }

  shells =
  {
    id = 2008
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="shell",count=4} }
  }

  shell_box =
  {
    id = 2049
    prob = 40
    give = { {ammo="shell",count=20} }
  }

  rocket =
  {
    id = 2010
    prob = 10
    cluster = { 4,7 }
    give = { {ammo="rocket",count=1} }
  }

  rocket_box =
  {
    id = 2046
    prob = 40
    give = { {ammo="rocket",count=5} }
  }

  cells =
  {
    id = 2047
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="cell",count=20} }
  }

  cell_pack =
  {
    id = 17
    prob = 40
    give = { {ammo="cell",count=100} }
  }

  -- Doom II only --

  mega =
  {
    id = 83
    prob = 1
    armor = true
    big_item = true
    start_prob = 8
    give = { {health=200} }
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

