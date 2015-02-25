------------------------------------------------------------------------
--  HERETIC MONSTERS
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2012 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

HERETIC.MONSTERS =
{
  gargoyle =
  {
    id = 66
    r = 16
    h = 36
    level = 1
    prob = 30
    health = 20
    damage = 5
    attack = "melee"
    float = true
  }

  fire_garg =
  {
    id = 5
    r = 16
    h = 36
    level = 3
    prob = 10
    health = 80
    damage = 8
    attack = "missile"
    float = true
  }

  mummy =
  {
    id = 68
    r = 22
    h = 64
    level = 1
    prob = 60
    health = 80
    damage = 8
    attack = "melee"
    give = { {ammo="crystal",count=1} }
  }

  mummy_inv =
  {
    id = 69
    r = 22
    h = 64
    replaces = "mummy"
    replace_prob = 15
    health = 80
    damage = 8
    attack = "melee"
    give = { {ammo="crystal",count=1} }
    invis = true
  }

  sabreclaw =  -- MT_CLINK
  {
    id = 90
    r = 20
    h = 64
    level = 5
    prob = 25
    health = 150
    damage = 12
    attack = "melee"
    give = { {ammo="rune",count=6} }
  }

  knight =
  {
    id = 64
    r = 24
    h = 80
    level = 1
    prob = 70
    health = 200
    damage = 12
    attack = "missile"
    give = { {ammo="arrow",count=1.6} }
  }

  knight_inv =
  {
    id = 65
    r = 24
    h = 80
    replaces = "knight"
    replace_prob = 15
    health = 200
    damage = 14
    attack = "missile"
    give = { {ammo="arrow",count=1.6} }
    invis = true
  }

  leader =
  {
    id = 45
    r = 22
    h = 64
    level = 4
    prob = 70
    health = 100
    damage = 16
    attack = "missile"
    give = { {ammo="crystal",count=1} }
  }

  leader_inv =
  {
    id = 46
    r = 22
    h = 64
    replaces = "leader"
    replace_prob = 15
    health = 100
    damage = 16
    attack = "missile"
    give = { {ammo="crystal",count=1} }
    invis = true
  }

  disciple =  -- MT_WIZARD
  {
    id = 15
    r = 16
    h = 72
    level = 6
    prob = 25
    health = 180
    damage = 20
    attack = "missile"
    give = { {ammo="claw_orb",count=3} }
    float = true
  }

  weredragon =  -- MT_BEAST
  {
    id = 70
    r = 34
    h = 80
    level = 6
    prob = 30
    health = 220
    damage = 25
    attack = "missile"
    give = { {ammo="arrow",count=3} }
  }

  ophidian =  -- MT_SNAKE
  {
    id = 92
    r = 22
    h = 72
    level = 7
    prob = 30
    health = 280
    damage = 25
    attack = "missile"
    give = { {ammo="flame_orb",count=1.6} }
  }


  ---| HERETIC BOSSES |---

  -- FIXME: damage values are crap, need 'attack' type

  Ironlich =  -- MT_HEAD
  {
    id = 6
    r = 40
    h = 72 
    health = 700
    damage = 60
    give = { {ammo="claw_orb",count=3} }
    float = true
  }

  Maulotaur =
  {
    id = 9
    r = 28
    h = 104
    health = 3000
    damage = 80
    give  = 
    {
      {ammo="flame_orb",count=3}
      {health=10}  -- occasionally drops an Urn
    }
  }

  D_Sparil =
  {
    id = 7
    r = 28
    h = 104
    health = 2000
    damage = 100
  }

  --
  -- NOTES:
  --
  -- Most monsters who drop an item after death only do so 33%
  -- of the time (randomly).  The give amounts are therefore
  -- just an average.  Some of them also (but rarely) drop
  -- artifacts (egg/tome) -- this is not modelled.
  --
}

