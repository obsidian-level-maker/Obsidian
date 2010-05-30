----------------------------------------------------------------
-- BASIC DEFINITIONS
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2009 Andrew Apted
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

-- important global tables
GAME   = {}
PARAM  = {}
STYLE  = {}
LEVEL  = {}
THEME  = {}

SEEDS  = {}

SKILLS = { "easy", "medium", "hard" }
   
MODES =
{
  { "sp",   "Single Player" },
  { "coop", "Co-op" },
  { "dm",   "Deathmatch" },
  { "ctf",  "Capture Flag" },
}

-- all prefabs go here
PREFAB = {}

-- a place for unfinished stuff
UNFINISHED = {}


-- tables which interface with GUI code
OB_CONFIG = {}

OB_GAMES   = {}
OB_THEMES  = {}
OB_ENGINES = {}
OB_MODULES = {}


-- various special settings
OB_ENGINES["nolimit"] =
{
  label = "Limit Removing",
  priority = 95,  -- top most
}


OB_THEMES["original"] =
{
  label = "As Original",
  priority = -97,
}

OB_THEMES["mixed"] =
{
  label = "Mix It Up",
  priority = -98,
}

OB_THEMES["psycho"] =
{
  label = "Psychedelic",
  priority = -99,  -- bottom most
}


-- room layout stuff
EXTREME_H = 4000

ROOM_SIZE_TABLE = { 0,1,5,9,5,1 }


-- monster amounts and toughness
MONSTER_QUANTITIES =
{
  scarce=9, less=18, normal=27, more=40, heaps=60
}

COOP_MON_FACTOR = 1.5

MONSTER_MAX_TIME   = { weak=12,  medium=18,  tough=24 }
MONSTER_MAX_DAMAGE = { weak=80,  medium=200, tough=360, }
MONSTER_LOW_DAMAGE = { weak=0.1, medium=1.0, tough=4, }

MON_VARIATION_LOW  = 0.5
MON_VARIATION_HIGH = 1.5


-- Fight Simulator constants and tables
HEALTH_AMMO_ADJUSTS =
{
  none=0, scarce=0.4, less=0.7, normal=1.0, more=1.5, heaps=2.5,
}

COOP_HEALTH_FACTOR = 1.3
COOP_AMMO_FACTOR   = 1.6

PLAYER_ACCURACIES = { easy=0.65, medium=0.75, hard=0.85 }

HITSCAN_RATIOS = { 1.0, 0.8, 0.6, 0.4, 0.2, 0.1 }
MISSILE_RATIOS = { 1.0, 0.3, 0.1 }
MELEE_RATIOS   = { 1.0, 0.1 }

HITSCAN_DODGES = { easy=0.05, medium=0.15, hard=0.25 }
MISSILE_DODGES = { easy=0.75, medium=0.90, hard=0.90 }
MELEE_DODGES   = { easy=0.80, medium=0.90, hard=0.95 }

