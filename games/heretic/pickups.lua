------------------------------------------------------------------------
--  HERETIC PICKUPS
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

HERETIC.PICKUPS =
{
  -- HEALTH --

  vial =
  {
    id = 81
    kind = "health"
    add_prob = 70
    rank = 1
    cluster = { 1,4 }
    give = { {health=10} }
  }

  flask =
  {
    id = 82
    kind = "health"
    add_prob = 25
    rank = 2
    give = { {health=25} }
  }


  -- AMMO --

  crystal =
  {
    id = 10
    kind = "ammo"
    add_prob = 20
    rank = 1
    cluster = { 1,4 }
    give = { {ammo="crystal",count=10} }
  }

  geode =
  {
    id = 12
    kind = "ammo"
    add_prob = 40
    rank = 2
    give = { {ammo="crystal",count=50} }
  }

  arrow =
  {
    id = 18
    kind = "ammo"
    add_prob = 20
    rank = 1
    cluster = { 1,3 }
    give = { {ammo="arrow",count=5} }
  }

  quiver =
  {
    id = 19
    kind = "ammo"
    add_prob = 40
    rank = 2
    give = { {ammo="arrow",count=20} }
  }

  claw_orb1 =
  {
    id = 54
    kind = "ammo"
    add_prob = 20
    rank = 1
    cluster = { 1,3 }
    give = { {ammo="claw_orb",count=10} }
  }

  claw_orb2 =
  {
    id = 55
    kind = "ammo"
    add_prob = 40
    rank = 2
    give = { {ammo="claw_orb",count=25} }
  }

  runes1 =
  {
    id = 20
    kind = "ammo"
    add_prob = 20
    rank = 1
    cluster = { 1,4 }
    give = { {ammo="rune",count=20} }
  }

  runes2 =
  {
    id = 21
    kind = "ammo"
    add_prob = 40
    rank = 2
    give = { {ammo="rune",count=100} }
  }

  flame_orb1 =
  {
    id = 22
    kind = "ammo"
    add_prob = 20
    rank = 1
    cluster = { 2,5 }
    give = { {ammo="flame_orb",count=1} }
  }

  flame_orb2 =
  {
    id = 23
    kind = "ammo"
    add_prob = 40
    rank = 2
    give = { {ammo="flame_orb",count=10} }
  }

  mace_orb1 =
  {
    id = 13
    kind = "ammo"
    add_prob = 20
    rank = 1
    cluster = { 1,4 }
    give = { {ammo="mace_orb",count=20} }
  }

  mace_orb2 =
  {
    id = 16
    kind = "ammo"
    add_prob = 40
    rank = 2
    give = { {ammo="mace_orb",count=100} }
  }
}


--------------------------------------------------


HERETIC.NICE_ITEMS =
{
  -- ARMOR --

  shield1 =
  {
    id = 85
    kind = "armor"
    add_prob = 20
    give = { {health=50} }
  }

  shield2 =
  {
    id = 31
    kind = "armor"
    add_prob = 5
    give = { {health=100} }
  }


  -- HEALTH and AMMO --

  urn =
  {
    id = 32
    kind = "health"
    add_prob = 5
    give = { {health=100} }
  }

  bag =
  {
    id = 8
    kind = "ammo"
    add_prob = 20
    start_prob = 10
    closet_prob = 10

    give = { {ammo="crystal",  count=10},
             {ammo="arrow",    count=5},
             {ammo="claw_orb", count=10},
             {ammo="runes",    count=20},
             {ammo="flame_orb",count=1},
             {ammo="mace_orb", count=20} }
  }


  -- ARTIFACTS --

  wings =
  {
    id = 83
    kind = "powerup"
  }

  ovum =
  {
    id = 30
    kind = "powerup"
  }

  torch =
  {
    id = 33
    kind = "powerup"
  }

  time_bomb =
  {
    id = 34
    kind = "powerup"
  }

  map =
  {
    id = 35
    kind = "powerup"
    secret_prob = 20
    once_only = true
  }

  chaos =
  {
    id = 36
    kind = "powerup"
  }

  shadow =
  {
    id = 75
    kind = "powerup"
  }

  ring =
  {
    id = 84
    kind = "powerup"
  }

  tome =
  {
    id = 86
    kind = "powerup"
  }
}

