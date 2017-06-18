--------------------------------------------------------------------
--  DOOM WEAPONS
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
-- id         : editor number used to place weapon on the map
--
-- level      : how far along (over episode) it should appear (1..9)
-- add_prob   : probabiliiy of adding into level [absent = never]
--
-- pref       : usage preference [absent = never]
-- upgrades   : when present, always prefer this weapon over named one
--              (e.g. always use chaingun instead of the pistol)
--
-- rate     : firing rate (shots per second)
-- accuracy : percentage that a good player will actually hit something
-- damage   : damage can inflict per shot (maximum possible)
-- splash   : splash damage to other monsters (2nd, 3rd, etc)
--
-- attack : kind of attack: hitscan / missile / melee
-- ammo   : ammo type [absent for no ammo weapons]
-- per    : ammo per shot
-- give   : ammo given when weapon is picked up
--
-- NOTES:
--
-- Berserk and Chainsaw are in the NICE_ITEMS table.
--

DOOM.WEAPONS =
{
  fist =
  {
    attack = "melee"
    rate = 1.5
    damage = 10
  }

  pistol =
  {
    pref = 1
    attack = "hitscan"
    rate = 1.8
    accuracy = 75
    damage = 10
    ammo = "bullet"
    per = 1
  }

  shotty =
  {
    id = 2001
    level = 1.5
    pref = 40
    add_prob = 40
    attack = "hitscan"
    rate = 0.9
    accuracy = 65
    damage = 70
    splash = { 15 }
    ammo = "shell"
    per = 1
    give = { {ammo="shell",count=8} }
    bonus_ammo = 8
  }

  chain =
  {
    id = 2002
    level = 1.5
    pref = 70
    upgrades = "pistol"
    add_prob = 40
    attack = "hitscan"
    rate = 8.5
    accuracy = 85
    damage = 10
    ammo = "bullet"
    per = 1
    give = { {ammo="bullet",count=20} }
    bonus_ammo = 50
  }

  -- the super shotgun is Doom II only
  super =
  {
    id = 82
    level = 2.7
    pref = 40
    upgrades = "shotty"
    add_prob = 70
    attack = "hitscan"
    rate = 0.6
    accuracy = 65
    damage = 150
    -- use splash to simulate hitting a second monster (etc)
    splash = { 40,20,10 }
    ammo = "shell"
    per = 2
    give = { {ammo="shell",count=8} }
    bonus_ammo = 12
  }

  launch =
  {
    id = 2003
    level = 4
    pref = 30
    add_prob = 65
    hide_prob = 10
    attack = "missile"
    rate = 1.7
    accuracy = 80
    damage = 170
    splash = { 65,20,5 }
    ammo = "rocket"
    per = 1
    give = { {ammo="rocket",count=2} }
    bonus_ammo = 5
  }

  plasma =
  {
    id = 2004
    level = 5.2
    pref = 25
    add_prob = 50
    attack = "missile"
    rate = 11
    accuracy = 70
    damage = 22
    ammo = "cell"
    per = 1
    give = { {ammo="cell",count=40} }
    bonus_ammo = 40
  }

  bfg =
  {
    id = 2006
    level = 8
    pref = 12
    upgrades = "plasma"
    add_prob = 20
    hide_prob = 35
    attack = "missile"
    rate = 0.8
    accuracy = 80
    damage = 640
    splash = { 150,150,150,150, 80,80,80,80 }
    ammo = "cell"
    per = 40
    give = { {ammo="cell",count=40} }
    bonus_ammo = 40
  }
}

