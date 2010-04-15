----------------------------------------------------------------
--  Engine: ZDoom
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2008 Andrew Apted
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

ZDOOM = { }

ZDOOM.THINGS =
{
  -- monsters --

  stealth_arach    = { id=9050, kind="monster", r=66,h=64 },
  stealth_vile     = { id=9051, kind="monster", r=20,h=56 },
  stealth_baron    = { id=9052, kind="monster", r=24,h=64 },
  stealth_caco     = { id=9053, kind="monster", r=31,h=56 },
  stealth_gunner   = { id=9054, kind="monster", r=20,h=56 },
  stealth_demon    = { id=9055, kind="monster", r=30,h=56 },
  stealth_knight   = { id=9056, kind="monster", r=24,h=64 },
  stealth_imp      = { id=9057, kind="monster", r=20,h=56 },
  stealth_mancubus = { id=9058, kind="monster", r=48,h=64 },
  stealth_revenant = { id=9059, kind="monster", r=20,h=64 },
  stealth_shooter  = { id=9060, kind="monster", r=20,h=56 },
  stealth_zombie   = { id=9061, kind="monster", r=20,h=56 },

  marine_fist    = { id=9101, kind="monster", r=16,h=56 },
  marine_berserk = { id=9102, kind="monster", r=16,h=56 },
  marine_saw     = { id=9103, kind="monster", r=16,h=56 },
  marine_pistol  = { id=9104, kind="monster", r=16,h=56 },
  marine_shotty  = { id=9105, kind="monster", r=16,h=56 },
  marine_ssg     = { id=9106, kind="monster", r=16,h=56 },
  marine_chain   = { id=9107, kind="monster", r=16,h=56 },
  marine_rocket  = { id=9108, kind="monster", r=16,h=56 },
  marine_plasma  = { id=9109, kind="monster", r=16,h=56 },
  marine_rail    = { id=9110, kind="monster", r=16,h=56 },
  marine_bfg     = { id=9111, kind="monster", r=16,h=56 },
}

ZDOOM.PARAMETERS =
{
  -- TODO
}

OB_ENGINES["zdoom"] =
{
  label = "ZDoom 2.31",

  extends = "boom",

  for_games =
  {
    chex3=1, doom1=1, doom2=1, heretic=1, hexen=1
  },

  tables = { ZDOOM },
}


----------------------------------------------------------------

GZDOOM = { }

OB_ENGINES["gzdoom"] =
{
  label = "GZDoom 1.2",
  priority = -1,  -- keep at bottom with ZDoom

  extends = "zdoom",

  for_games =
  {
    chex3=1, doom1=1, doom2=1, heretic=1, hexen=1
  },

  tables = { GZDOOM },
}

