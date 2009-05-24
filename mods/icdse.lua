----------------------------------------------------------------
--  MODULE: Immoral Conduct - Special Edition
----------------------------------------------------------------
--
--  Copyright (C) 2009 Andrew Apted
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

-- === NOTES ===
--
-- The Ammo in Immoral Conduct is a bit different than
-- standard DOOM, there is a couple new ones and some
-- existing ones have a new meaning.  The most important
-- are:
--     bullets  -> bullets
--     shells   -> shells
--     rockets  -> grenades
--     cells    -> rifle ammo
--
--     gas      -> flak shells (new)
--     nails    -> knives (new)
--     pellets  -> satchel charges (new)
--
-- (Knives and Charges are not modelled by OBLIGE).
--
-- The "Silencer" is another starting weapon, but I assume
-- it's equivalent to the pistol and hence is not modelled.
--


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

  pistol_pair   = { id=2018, kind="pickup", r=20,h=16, pass=true },
  uzi_pair      = { id=2022, kind="pickup", r=20,h=16, pass=true },
  upgraded_shot = { id=2006, kind="pickup", r=20,h=16, pass=true },
  gren_launch   = { id=  17, kind="pickup", r=20,h=16, pass=true },
  satchel       = { id=2010, kind="pickup", r=20,h=16, pass=true },

  -- pickups
  flak_shells   = { id=2024, kind="pickup", r=20,h=16, pass=true },
}


ICDSE_MONSTERS =
{
  uzi_trooper =
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

  -- FIXME 
}


ICDSE_WEAPONS =
{
  bfg = REMOVE_ME,   -- became: upgraded_shotgun

  -- FIXME
}


ICDSE_PICKUPS =
{
  green_armor = REMOVE_ME,  -- became: pistol_pair
  rocket      = REMOVE_ME,  -- became: satchel
  cell_box    = REMOVE_ME,  -- became: gren_launch

  flak_shells =
  {
    prob=20, cluster={ 2,5 },
    give={ {ammo="flak",count=4} },
  },
}


ICDSE_POWERUPS =
{
  invul = REMOVE_ME,  -- became: uzi_pair
  invis = REMOVE_ME,  -- became: flak_shells
}


ICDSE_PLAYER_MODEL =
{
  doomguy =
  {
    stats   = { health=0, flak=0, bullet=0, shell=0, rocket=0, cell=0 },
    weapons = { pistol=1, fist=1 },
  }
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

    "player_model", ICDSE_PLAYER_MODEL,
  },
}

