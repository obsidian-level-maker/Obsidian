----------------------------------------------------------------
-- BASIC DEFINITIONS
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2009 Andrew Apted
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

GAME   = {}
PARAM  = {}
HOOKS  = {}
STYLE  = {}

LEVEL  = {}
SEEDS  = {}

SKILLS = { "easy", "medium", "hard" }
   
MODES =
{
  { "sp",   "Single Player" },
  { "coop", "Co-op" },
  { "dm",   "Deathmatch" },
  { "ctf",  "Capture Flag" },
}

-- a place for unfinished stuff
UNFINISHED = {}


-- tables which interface with GUI code --

OB_CONFIG = {}

OB_GAMES   = {}
OB_THEMES  = {}
OB_ENGINES = {}
OB_MODULES = {}


-- the catch-all engine
OB_ENGINES["nolimit"] =
{
  label = "Limit Removing",
  priority = 95,  -- top most
}

OB_THEMES["mixed"] =
{
  label = "Mix It Up",
  priority = -99,  -- bottom most
}

OB_THEMES["psycho"] =
{
  label = "Psychedelic",
  priority = -98,
}



-- Room layout stuff
SKY_H = 512

EXTREME_H = 4000

ROOM_SIZE_TABLE = { 0,4,9,6,2 }

BIG_ROOM_TABLE =
{
  [11] = 10,
  [12] = 20, [22] = 50,
  [23] = 20, [33] = 20,
  [34] = 1,  [44] = 1,
}


-- Monster stuff

MONSTER_QUANTITIES =
{
  scarce=10, less=18, normal=27, more=40, heaps=60
}

MONSTER_TOUGHNESS =
{
  scarce=0.8, less=0.9, normal=1.0, more=1.1, heaps=1.2
}

MON_VARIATION_LOW  = 0.5
MON_VARIATION_HIGH = 1.5


-- Fight Simulator constants and tables

HEALTH_AMMO_ADJUSTS =
{
  none=0, scarce=0.4, less=0.7, normal=1.0, more=1.5, heaps=2.5,
}

PLAYER_ACCURACIES = { easy=0.65, medium=0.75, hard=0.85 }

HITSCAN_RATIOS = { 1.0, 0.8, 0.6, 0.4, 0.2, 0.1 }
MISSILE_RATIOS = { 1.0, 0.3, 0.1 }
MELEE_RATIOS   = { 1.0, 0.1 }

HITSCAN_DODGES = { easy=0.05, medium=0.15, hard=0.25 }
MISSILE_DODGES = { easy=0.75, medium=0.90, hard=0.90 }
MELEE_DODGES   = { easy=0.80, medium=0.90, hard=0.95 }

