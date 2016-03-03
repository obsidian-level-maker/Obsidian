------------------------------------------------------------------------
--  HEXEN WEAPONS
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2011 Andrew Apted
--  Copyright (C) 2011-2012 Jared Blackburn
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

HEXEN.WEAPONS =
{
  -- CLERIC --

  c_mace =
  {
    pref = 10
    attack = "melee"
    rate = 1.6
    damage = 32
    class = "cleric"
    slot = 1
  }

  c_staff =
  {
    pref = 30
    add_prob = 10
    rate = 3.5
    damage = 36
    attack = "missile"
    ammo = "blue_mana"
    per = 1
    give = { {ammo="blue_mana",count=25} }
    class = "cleric"
    slot = 2
  }

  c_fire =
  {
    pref = 60
    add_prob = 10
    attack = "missile"
    rate = 1.6
    damage = 64
    ammo = "green_mana"
    per = 4
    give = { {ammo="green_mana",count=25} }
    class = "cleric"
    slot = 3
  }

  c_wraith =
  {
    pref = 20
    attack = "missile"
    rate = 1.7
    damage = 200
    splash = { 50,35,20,1 }
    ammo = "dual_mana"
    per = 18
    class = "cleric"
    slot = 4
  }

  -- FIGHTER --

  f_gaunt =
  {
    pref = 10
    attack = "melee"
    rate = 2.0
    damage = 47
    class = "fighter"
    slot = 1
  }

  f_axe =
  {
    pref = 30
    add_prob = 10
    attack = "melee"
    rate = 1.6
    damage = 70
    ammo = "blue_mana"
    per = 2
    give = { {ammo="blue_mana",count=25} }
    class = "fighter"
    slot = 2
  }

  f_hammer =
  {
    pref = 60
    add_prob = 10
    attack = "missile"
    rate = 1.1
    damage = 100
    ammo = "green_mana"
    per = 3
    give = { {ammo="green_mana",count=25} }
    class = "fighter"
    slot = 3
  }

  f_quietus =
  {
    pref = 20
    attack = "missile"
    rate = 1.1
    damage = 200
    splash = { 50,35,20,1 }
    ammo = "dual_mana"
    per = 14
    class = "fighter"
    slot = 4
  }

  -- MAGE --

  m_wand =
  {
    pref = 10
    attack = "missile"
    rate = 2.3
    damage = 8
    splash = { 0, 6, 4, 2 }  -- model the penetrative nature
    class = "mage"
    slot = 1
  }

  m_cone =
  {
    pref = 30
    add_prob = 10
    attack = "missile"
    rate = 1.1
    damage = 30
    ammo = "blue_mana"
    per = 3
    give = { {ammo="blue_mana",count=25} }
    class = "mage"
    slot = 2
  }

  m_blitz =
  {
    pref = 60
    add_prob = 10
    attack = "missile"
    rate = 1.0
    damage = 80
    ammo = "green_mana"
    per = 5
    give = { {ammo="green_mana",count=25} }
    class = "mage"
    slot = 3
  }

  m_scourge =
  {
    pref = 20
    attack = "missile"
    rate = 1.7
    damage = 200
    splash = { 50,35,20,1 }
    ammo = "dual_mana"
    per = 15
    class = "mage"
    slot = 4
  }

  --
  -- NOTES:
  --
  -- No 'id' numbers here (Oblige has special logic for selecting and
  -- placing these weapons).
  --
  -- Weapon change their behavior (and hence damage) based on which
  -- types of Mana the player has.  This is not handled yet.
  --
  -- Some weapons have both melee and projectile modes (e.g. the
  -- Fighter's hammer will throw a hammer when no monsters are in
  -- melee range).  The damage value is somewhere in-between.
  --
  -- The big weapons are not found lying around the level, rather
  -- the player must find three pieces to make them.  Hence they
  -- have no 'add_prob' value.
  --
  -- Exactly how much damage the BIG weapons can do depends a lot
  -- on how many monsters are in view.  The damage values above
  -- are just guesses.
  --
}


HEXEN.WEAPON_PIECES =
{
  fighter = { "f1_hilt",  "f2_cross", "f3_blade" }
  cleric  = { "c1_shaft", "c2_cross", "c3_arc"   }
  mage    = { "m1_stick", "m2_stub",  "m3_skull" }
}

