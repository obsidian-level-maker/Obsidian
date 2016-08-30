------------------------------------------------------------------------
--  BASIC DEFINITIONS
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2016 Andrew Apted
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
------------------------------------------------------------------------

-- important global tables
GAME   = {}
PARAM  = {}
STYLE  = {}
LEVEL  = {}
THEME  = {}
SEEDS  = {}

EPISODE = {}
PREFABS = {}
GROUPS  = {}


-- a place for unfinished stuff
UNFINISHED = {}


-- tables which interface with GUI code
OB_CONFIG = {}

OB_GAMES   = {}
OB_THEMES  = {}
OB_ENGINES = {}
OB_MODULES = {}


-- internationalization / localization
function _(s) return gui.gettext(s) end


-- the default engine (basically Vanilla + limit removing)
OB_ENGINES["nolimit"] =
{
  label = _("Limit Removing")
  priority = 95
}


-- special theme types, usable by all games
OB_THEMES["original"] =
{
  label = _("As Original")
  priority = -80
}

OB_THEMES["mixed"] =
{
  label = _("A Bit Mixed")
  priority = -85,
}

OB_THEMES["jumble"] =
{
  label = _("Jumbled Up")
  priority = -90
}


-- important constants

SEED_SIZE = 128

EXTREME_H = 32000


-- special value for merging tables
REMOVE_ME = "__REMOVE__"


-- constants for gui.spots_xxx API functions
SPOT_CLEAR    = 0
SPOT_LOW_CEIL = 1
SPOT_WALL     = 2
SPOT_LEDGE    = 3


-- monster and item stuff
MONSTER_QUANTITIES =
{
  scarce=0.35, less=0.7, normal=1.0, more=1.5, heaps=2.5, nuts=7.7
}

MONSTER_KIND_TAB =
{
  scarce=0.5, less=0.75, normal=1.0, more=1.33, heaps=1.6, nuts=2.0
}

STRENGTH_FACTORS =
{
  weak=0.7, easier=0.85, medium=1.0, harder=1.2, tough=1.5
}

HEALTH_FACTORS =
{
  none=0, scarce=0.40, less=0.64, normal=1.00, more=1.60, heaps=2.50
}

AMMO_FACTORS =
{
  none=0, scarce=0.65, less=0.85, normal=1.00, more=1.20, heaps=1.50
}


-- adjustments for Co-operative game mode
COOP_MON_FACTOR = 1.3

COOP_HEALTH_FACTOR = 1.2
COOP_AMMO_FACTOR   = 1.2


--
-- styles control quantities of things in each level
--
GLOBAL_STYLE_LIST =
{
  -- these two correspond to buttons in the GUI
  outdoors    = { none=0,  few=60, some=40, heaps=20 }
  caves       = { none=60, few=40, some=20, heaps=5 }

  big_rooms   = { none=10, few=20, some=40, heaps=20 }
  symmetry    = { none=10, few=40, some=60, heaps=10 }
  steepness   = { none=0,  few=20, some=60, heaps=10 }
  hallways    = { none=0,  few=60, some=30, heaps=10 }

  cages       = { none=10, few=20, some=40, heaps=10 }
  traps       = { none=0,  few=20, some=60, heaps=20 }
  secrets     = { none=0,  few=20, some=50, heaps=10 }
  closets     = { none=0,  few=0,  some=60, heaps=20 }

  -- room connections --

  teleporters = { none=20, few=20, some=40, heaps=30 }
  doors       = { none=5,  few=30, some=60, heaps=5 }
  windows     = { none=0,  few=20, some=70, heaps=35 }
  fences      = { none=30, few=30, some=10 }
  switches    = { none=20, few=20, some=40, heaps=10 }
  keys        = { none=0,  few=10, some=20, heaps=60 }

  -- decoration stuff --

  liquids     = { none=0,  few=20, some=20, heaps=80 }
  porches     = { none=0,  few=10, some=60, heaps=10 }
  pictures    = { none=0,  few=10, some=50, heaps=10 }

  pillars     = { none=0,  few=60, some=30, heaps=10 }
  crates      = { none=20, few=0,  some=40, heaps=10 }
  barrels     = { none=0,  few=50, some=50, heaps=10 }

  -- monster stuff --

  ambushes    = { none=10, few=0,  some=50, heaps=10 }

  -- these are currently broken --

  cycles      = { none=50, few=0,  some=50, heaps=50 }
  ex_floors   = { none=0,  few=40, some=60, heaps=20 }
  crossovers  = { none=40 } --!!!! , some=40, heaps=40 }

  scenics     = { none=0,  few=30, some=50, heaps=10 }
  lakes       = { none=0,  few=60, some=0,  heaps=10 }
  islands     = { none=0,  few=60, some=0,  heaps=40 }
  beams       = { none=0,  few=25, some=50, heaps=5  }
}


--
-- default parameters (each game can override these settings)
--
GLOBAL_PARAMETERS =
{
  map_limit = 10000

  step_height = 16
  jump_height = 24

  spot_low_h  = 72
  spot_high_h = 128
}


--
-- prefab stuff
-- 
GLOBAL_PREFAB_FIELDS =
{
   tex__WALL   = "?wall"
  flat__WALL   = "?wall"

   tex__OUTER  = "?outer"
  flat__OUTER  = "?outer"

   tex__FLOOR  = "?floor"
  flat__FLOOR  = "?floor"

   tex__CEIL   = "?ceil"
  flat__CEIL   = "?ceil"

   tex__FLOOR2 = "?floor2"
  flat__FLOOR2 = "?floor2"

  thing_8166   = "?object"

  line_888     = "?action"
}


GLOBAL_SKIN_DEFAULTS =
{
  wall   = "_ERROR"

  outer  = "?wall"
  fence  = "?wall"
  floor  = "?wall"
  ceil   = "?wall"
  floor2 = "?outer"

  -- Doom engine stuff
  tag = ""
  light = ""
  action = ""
  object = ""

  -- Quake engine stuff
  style = ""
  message = ""
  wait = ""
  targetname = ""
}

