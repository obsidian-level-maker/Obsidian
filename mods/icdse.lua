----------------------------------------------------------------
--  MODULE: Immoral Conduct - Special Edition
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2009 Andrew Apted
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

ICDSE_THINGS =
{
  -- players
  -- (replaces COOP_HELPER_SPAWNER with SPACE_MARINE_PRIVATE)
  player4 = { id=3000, kind="player", r=20,h=56 },

  -- monsters
  uzi_trooper     = { id=3042, kind="monster", r=20,h=56 },
  super_shooter   = { id=3043, kind="monster", r=20,h=56 },
  m16_zombie      = { id=3044, kind="monster", r=20,h=56 },
  chainsaw_zombie = { id=3046, kind="monster", r=20,h=56 },

  -- weapons
  sawed_off   = { id=4444, kind="pickup", r=20,h=16, pass=true },
  beretta     = { id=4445, kind="pickup", r=20,h=16, pass=true },
  revolver    = { id=4446, kind="pickup", r=20,h=16, pass=true },
  minigun     = { id=2999, kind="pickup", r=20,h=16, pass=true },

  -- pickups : TODO
  
}


ICDSE_MONSTERS =
{
  enhanced_trooper =
  {
    prob=30, guard_prob=21, trap_prob=11, cage_prob=30,
    health=120, damage=65, attack="hitscan",
    give={ {weapon="super"}, {ammo="shell",count=4} },
  },

  chainsaw_zombie =
  {
    prob=20, guard_prob=11, trap_prob=31,
    health=100, damage=15, attack="melee",
  },

  -- FIXME : the rest
}


ICDSE_WEAPONS =
{
  -- TODO
}


ICDSE_PICKUPS =
{
  -- TODO
}


OB_MODULES["icdse"] =
{
  label = "Immoral Conduct - Special Edition",

  for_games = { doom2=1 },
  for_modes = { sp=1, coop=1 },
  for_engines = { edge=1 },

  tables =
  {
    "things",   ICDSE_THINGS,
    "monsters", ICDSE_MONSTERS,
    "weapons",  ICDSE_WEAPONS,
    "pickups",  ICDSE_PICKUPS,
  },
}

