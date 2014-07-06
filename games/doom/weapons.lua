--------------------------------------------------------------------
--  DOOM WEAPONS
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

--
-- Usable keywords
-- ===============
--
-- pref       : usage preference [absent = never]
-- add_prob   : probabiliiy of adding into level [absent = never]
-- start_prob : chance of appearing in start room
-- mp_prob    : chance of being used in a Multi-Player map
--
-- rate   : firing rate (shots per second)
-- damage : damage can inflict per shot
-- attack : kind of attack (hitscan | missile | melee)
-- splash : splash damage done to monsters (1st, 2nd, etc)
--
-- ammo  : ammo type [absent for no ammo weapons]
-- per   : ammo per shot
-- give  : ammo given when weapon is picked up
--
-- NOTES:
--
-- Berserk is not really an extra weapon, but a powerup which
-- makes fist do much more damage.  The effect lasts until the
-- end of the level, so a weapon is a pretty good fit.
--
-- Shotgun has a fairly low add_prob, since it is likely the
-- player will have encountered a shotgun zombie and already
-- have that weapon.
--

DOOM.WEAPONS =
{
  fist =
  {
    attack = "melee"
    rate = 1.5
    damage = 10
  }

  saw =
  {
    id = 2005
    level = 1
    pref = 3
    add_prob = 2
    attack = "melee"
    rate = 8.7
    damage = 10
  }

  berserk =
  {
    id = 2023
    level = 5
    pref = 10
    add_prob = 5
    mp_prob = 2
    attack = "melee"
    rate = 1.5
    damage = 90
    give = { {health=70} }
  }

  pistol =
  {
    pref = 5
    attack = "hitscan"
    rate = 1.8
    damage = 10
    ammo = "bullet"
    per = 1
  }

  chain =
  {
    id = 2002
    level = 1
    pref = 60
    add_prob = 35
    start_prob = 15
    attack = "hitscan"
    rate = 8.5
    damage = 10
    ammo = "bullet"
    per = 1
    give = { {ammo="bullet",count=20} }
    bonus_ammo = 50
  }

  shotty =
  {
    id = 2001
    level = 1
    pref = 70
    add_prob = 10
    start_prob = 60
    attack = "hitscan"
    rate = 0.9
    damage = 70
    splash = { 0,10 }
    ammo = "shell"
    per = 1
    give = { {ammo="shell",count=8} }
    bonus_ammo = 8
  }

  launch =
  {
    id = 2003
    level = 3
    pref = 30
    add_prob = 25
    attack = "missile"
    rate = 1.7
    damage = 80
    splash = { 50,20,5 }
    ammo = "rocket"
    per = 1
    give = { {ammo="rocket",count=2} }
    bonus_ammo = 5
  }

  plasma =
  {
    id = 2004
    level = 5
    pref = 30
    add_prob = 15
    attack = "missile"
    rate = 11
    damage = 20
    ammo = "cell"
    per = 1
    give = { {ammo="cell",count=40} }
    bonus_ammo = 40
  }

  bfg =
  {
    id = 2006
    level = 7
    pref = 15
    add_prob = 20
    mp_prob = 6
    attack = "missile"
    rate = 0.65  -- tweaked value, normally 0.8
    damage = 300
    splash = {70,70,70,70, 70,70,70,70, 70,70,70,70}
    ammo = "cell"
    per = 40
    give = { {ammo="cell",count=40} }
    bonus_ammo = 40
  }
}


DOOM2.WEAPONS =
{
  super =
  {
    id = 82
    level = 4
    pref = 50
    add_prob = 20
    start_prob = 40
    attack = "hitscan"
    rate = 0.6
    damage = 170
    splash = { 0,30 }
    ammo = "shell"
    per = 2
    give = { {ammo="shell",count=8} }
    bonus_ammo = 12
  }
}

