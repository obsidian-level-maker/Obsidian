----------------------------------------------------------------
-- BASIC DEFINITIONS
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2008 Andrew Apted
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

GAME  = {}
CAPS  = {}
HOOKS = {}
LEVEL = {}
PLAN  = {}
SEEDS = {}

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


OB_THEMES["mixed"] =
{
  label = "Mix It Up",

  priority = -99,  -- bottom-most
}


-- Fight Simulator constants and tables

PLAYER_ACCURACIES = { easy=0.50, medium=0.65, hard=0.80 }

HITSCAN_RATIOS = { 1.0, 0.8, 0.6, 0.4, 0.2, 0.1 }
MISSILE_RATIOS = { 1.0, 0.5, 0.2, 0.05 }
MELEE_RATIOS   = { 1.0, 0.2 }

HITSCAN_DODGES = { easy=0.05, medium=0.15, hard=0.30 }
MISSILE_DODGES = { easy=0.50, medium=0.70, hard=0.85 }
MELEE_DODGES   = { easy=0.50, medium=0.80, hard=0.98 }

