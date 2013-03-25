----------------------------------------------------------------
-- BASIC DEFINITIONS
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2012 Andrew Apted
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

SEEDS    = {}
SECTIONS = {}
EPISODE  = {}

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
  priority = -96,
}

OB_THEMES["mixed"] =
{
  label = "A Bit Mixed",
  priority = -97,
}

OB_THEMES["jumble"] =
{
  label = "Jumbled Up",
  priority = -98,
}

OB_THEMES["psycho"] =
{
  label = "Psychedelic",
  priority = -99,  -- bottom most
}


-- important constants

SEED_SIZE = 256

SPARE_SEEDS = 2

EXTREME_H = 4000

LIFT_H = 104

