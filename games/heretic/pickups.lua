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
    add_prob = 70
    rank = 1
    cluster = { 1,4 }
    give = { {health=10} }
  }

  flask =
  {
    id = 82
    add_prob = 25
    rank = 2
    give = { {health=25} }
  }


  -- AMMO --

  crystal =
  {
    id = 10
    add_prob = 20
    rank = 0
    cluster = { 1,4 }
    give = { {ammo="crystal",count=10} }
  }

  geode =
  {
    id = 12
    add_prob = 40
    rank = 1
    give = { {ammo="crystal",count=50} }
  }

  arrow =
  {
    id = 18
    add_prob = 20
    rank = 0
    cluster = { 1,3 }
    give = { {ammo="arrow",count=5} }
  }

  quiver =
  {
    id = 19
    add_prob = 40
    rank = 1
    give = { {ammo="arrow",count=20} }
  }

  claw_orb1 =
  {
    id = 54
    add_prob = 20
    rank = 0
    cluster = { 1,3 }
    give = { {ammo="claw_orb",count=10} }
  }

  claw_orb2 =
  {
    id = 55
    add_prob = 40
    rank = 1
    give = { {ammo="claw_orb",count=25} }
  }

  runes1 =
  {
    id = 20
    add_prob = 20
    rank = 1
    cluster = { 1,4 }
    give = { {ammo="rune",count=20} }
  }

  runes2 =
  {
    id = 21
    add_prob = 40
    rank = 2
    give = { {ammo="rune",count=100} }
  }

  flame_orb1 =
  {
    id = 22
    add_prob = 20
    rank = 0
    cluster = { 2,5 }
    give = { {ammo="flame_orb",count=1} }
  }

  flame_orb2 =
  {
    id = 23
    add_prob = 40
    rank = 1
    give = { {ammo="flame_orb",count=10} }
  }

  mace_orb1 =
  {
    id = 13
    add_prob = 20
    rank = 1
    cluster = { 1,4 }
    give = { {ammo="mace_orb",count=20} }
  }

  mace_orb2 =
  {
    id = 16
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
    add_prob = 20
    rank = 2
    give = { {health=50} }
  }

  shield2 =
  {
    id = 31
    add_prob = 5
    rank = 3
    give = { {health=100} }
  }


  -- ARTIFACTS --

  urn =
  {
    id = 32
    add_prob = 5
    rank = 3
    give = { {health=100} }
  }

  bag =
  {
    id=8
  }

  wings =
  {
    id=83
  }

  ovum =
  {
    id=30
  }

  torch =
  {
    id=33
  }

  bomb =
  {
    id=34
  }

  map =
  {
    id=35
  }

  chaos =
  {
    id=36
  }

  shadow =
  {
    id=75
  }

  ring =
  {
    id=84
  }

  tome =
  {
    id=86
  }
}

