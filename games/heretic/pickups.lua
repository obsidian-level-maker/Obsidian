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
  -- HEALTH and ARMOR --

  vial =
  {
    id = 81
    kind = "health"
    add_prob = 70
    cluster = { 1,4 }
    give = { {health=10} }
  }

  shield1 =
  {
    id = 85
    kind = "armor"
    add_prob = 20
    give = { {health=50} }
  }


  -- AMMO --

  crystal =
  {
    id = 10
    kind = "ammo"
    rank = 1
    add_prob = 20
    cluster = { 1,4 }
    give = { {ammo="crystal",count=10} }
  }

  geode =
  {
    id = 12
    kind = "ammo"
    rank = 2
    add_prob = 40
    give = { {ammo="crystal",count=50} }
  }

  arrow =
  {
    id = 18
    kind = "ammo"
    rank = 1
    add_prob = 20
    cluster = { 1,3 }
    give = { {ammo="arrow",count=5} }
  }

  quiver =
  {
    id = 19
    kind = "ammo"
    rank = 2
    add_prob = 40
    give = { {ammo="arrow",count=20} }
  }

  claw_orb1 =
  {
    id = 54
    kind = "ammo"
    rank = 1
    add_prob = 20
    cluster = { 1,3 }
    give = { {ammo="claw_orb",count=10} }
  }

  claw_orb2 =
  {
    id = 55
    kind = "ammo"
    rank = 2
    add_prob = 40
    give = { {ammo="claw_orb",count=25} }
  }

  runes1 =
  {
    id = 20
    kind = "ammo"
    rank = 1
    add_prob = 20
    cluster = { 1,4 }
    give = { {ammo="rune",count=20} }
  }

  runes2 =
  {
    id = 21
    kind = "ammo"
    rank = 2
    add_prob = 40
    storage_prob = 50
    give = { {ammo="rune",count=100} }
  }

  flame_orb1 =
  {
    id = 22
    kind = "ammo"
    rank = 1
    add_prob = 20
    cluster = { 2,5 }
    give = { {ammo="flame_orb",count=1} }
  }

  flame_orb2 =
  {
    id = 23
    kind = "ammo"
    rank = 2
    add_prob = 40
    storage_prob = 50
    give = { {ammo="flame_orb",count=10} }
  }

  mace_orb1 =
  {
    id = 13
    kind = "ammo"
    rank = 1
    add_prob = 20
    cluster = { 1,4 }
    give = { {ammo="mace_orb",count=20} }
  }

  mace_orb2 =
  {
    id = 16
    kind = "ammo"
    rank = 2
    add_prob = 40
    storage_prob = 50
    give = { {ammo="mace_orb",count=100} }
  }
}


--------------------------------------------------


HERETIC.NICE_ITEMS =
{
  -- HEALTH and AMMO --

  flask =
  {
    id = 82
    kind = "health"
    add_prob = 30
    closet_prob = 30
    give = { {health=25} }
  }

  urn =
  {
    id = 32
    kind = "health"
    add_prob = 5
    closet_prob = 5
    secret_prob = 30
    give = { {health=100} }
  }

  shield2 =
  {
    id = 31
    kind = "armor"
    add_prob = 20
    closet_prob = 20
    give = { {health=100} }
  }


  -- ARMOR --

  bag =
  {
    id = 8
    kind = "ammo"
    add_prob = 5
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

    -- NOTE: never added, since it can allow the player to fly over
    --       fences (and break the quest structure).
  }

  ovum =
  {
    id = 30
    kind = "powerup"
    secret_prob = 20
    closet_prob = 5
  }

  torch =
  {
    id = 33
    kind = "powerup"
    add_prob = 10
    closet_prob = 10
  }

  time_bomb =
  {
    id = 34
    kind = "powerup"
    add_prob = 20
    closet_prob = 20
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
    secret_prob = 20
    closet_prob = 5
  }

  shadow =
  {
    id = 75
    kind = "powerup"
    add_prob = 5
    secret_prob = 20
  }

  ring =
  {
    id = 84
    kind = "powerup"
    secret_prob = 10
  }

  tome =
  {
    id = 86
    kind = "powerup"
    add_prob = 20
    closet_prob = 20
    secret_prob = 10
  }
}

