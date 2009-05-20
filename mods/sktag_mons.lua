----------------------------------------------------------------
--  MODULE: Skulltag Monsters and Items
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2009 Andrew Apted
--                     (C) 2009 Chris Pisarczyk
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
----------------------------------------------------------------

SKULLTAG_THINGS =
{
  -- monsters
  darkimp    = { id=5003, kind="monster", r=20,h=56 },
  bldemon    = { id=5004, kind="monster", r=30,h=56 },
  superguy   = { id=5005, kind="monster", r=20,h=56 },
  cacolant   = { id=5006, kind="monster", r=31,h=56 },
  hectebus   = { id=5007, kind="monster", r=48,h=64 },
  belphegor  = { id=5008, kind="monster", r=24,h=64 },
  abaddon    = { id=5015, kind="monster", r=31,h=56 },

  -- weapons
  glaunch = { id=5011, kind="pickup", r=20,h=16, pass=true },
  railgun = { id=5012, kind="pickup", r=20,h=16, pass=true },
  bfg10k  = { id=5013, kind="pickup", r=20,h=16, pass=true },
  minigun = { id=5014, kind="pickup", r=20,h=16, pass=true },

  -- pickups
  red_armor = { id=5040, kind="pickup", r=20,h=16, pass=true },
}


SKULLTAG_MONSTERS =
{
  -- NOTE: Super shotgun guy requires DOOM II (there is no super
  --       shotgun in DOOM 1).  Hectebus too, it needs mancubus
  --       sounds.

  darkimp =
  {
    prob=55, guard_prob=11, trap_prob=11, cage_prob=40,
    health=120, damage=30, attack="missile",
  },

  superguy =
  {
    prob=33, guard_prob=21, trap_prob=11, cage_prob=30,
    health=120, damage=65, attack="hitscan",
    give={ {weapon="super"} },
  },

  bldemon =
  {
    prob=25, guard_prob=11, trap_prob=31,
    health=300, damage=25, attack="melee",
  },

  cacolant =
  {
    prob=25, guard_prob=21, trap_prob=11,
    health=800, damage=55, attack="missile",
    float=true,
  },

  hectebus =
  {
    prob=35, guard_prob=21, trap_prob=21, cage_prob=88,
    health=1200, damage=120, attack="missile",
  },

  abaddon =
  {
    prob=15, guard_prob=21, trap_prob=11,
    health=1200, damage=65, attack="missile",
    float=true,
  },

  belphegor =
  {
    prob=15, guard_prob=21, trap_prob=21, cage_prob=5,
    health=1500, damage=80, attack="missile",
  },
}


SKULLTAG_WEAPONS =
{
  minigun =
  {
    pref=85, add_prob=40,  start_prob=20,
    rate=15, damage=10, attack="hitscan",
    ammo="bullet", per=1,
    give={ {ammo="bullet",count=20} },
  },

  glaunch =
  {
    pref=50, add_prob=40,  start_prob=20,
    rate=1.7, damage=90, attack="missile", --FIXME splash damage
    ammo="rocket", per=1,
    give={ {ammo="rocket",count=2} },
  },

  railgun =
  {
    pref=20, add_prob=20, start_prob=7,
    rate=3, damage=200, attack="hitscan",
    ammo="cell", per=10,
    give={ {ammo="cell",count=40} },
  },

  bfg10k =
  {
    pref=15, add_prob=2, start_prob=0.2,
    rate=1.2, damage=300, attack="missile", --FIXME splash damage
    ammo="cell", per=5,
    give={ {ammo="cell",count=40} },
  },
}


SKULLTAG_PICKUPS =
{
  red_armor =
  {
    prob=2, armor=true, big_item=true,
    give={ {health=90} },
  },
}


-- TODO MONSTER/WEAPON PREFS
--  hectebus = { super=2.0, lauch=2.0, railgun=1.5 },
--  belphegor = { launch=1.5, plasma=1.5, bfg=1.0, railgun=1.5 },
--  darkimp   = { chain=2.0, shotty=6.0, minigun=1.0 },
--  cacolant  = { super=2.0, launch=0.7, railgun=1.0, minigun=0.4 },
--  abaddon   = { super=2.0, launch=1.33, railgun=1.5 },
--  bldemon   = { super=3.0, launch=0.4 },
--  superguy  = { shotty=4.0, super=4.0, chain=3.0, railgun=0.3 }




OB_MODULES["sktag_mons"] =
{
  label = "Skulltag Monsters and Items",

  for_games = { doom2=1, freedoom=1 },
  for_modes = { sp=1, coop=1 },
  for_engines = { skulltag=1 },

  tables =
  {
    "things",   SKULLTAG_THINGS,
    "monsters", SKULLTAG_MONSTERS,
    "weapons",  SKULLTAG_WEAPONS,
    "pickups",  SKULLTAG_PICKUPS,
  },
}

