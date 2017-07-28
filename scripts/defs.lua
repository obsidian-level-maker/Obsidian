------------------------------------------------------------------------
--  BASIC DEFINITIONS
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2017 Andrew Apted
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
TEMPLATES = {}


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
  label = _("Original")
  priority = 91
}

OB_THEMES["mostly_original"] =
{
  label = _("Original-ish")
  priority = 90
}


OB_THEMES["epi"] =
{
  label = _("Episodic")
  priority = 85,
}

OB_THEMES["mostly_epi"] =
{
  label = _("Episode-ish")
  priority = 84,
}


OB_THEMES["jumble"] =
{
  label = _("Jumbled Up")
  priority = 80
}

OB_THEMES["bit_mixed"] =
{
  label = _("Bit Mixed")
  priority = 81
}


-- choices for Length button
LENGTH_CHOICES =
{
  "single",  _("Single Level"),
  "few",     _("A Few Maps"),
  "episode", _("One Episode"),
  "game",    _("Full Game"),
}


-- important constants --

-- size of each seed square
SEED_SIZE = 128

-- largest map size
SEED_W    = 80
SEED_H    = 64

-- highest possible Z coord (and lowest, when negative)
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
  scarce = 0.35
  less   = 0.7
  normal = 1.0
  more   = 1.5
  heaps  = 2.5
  nuts   = 7.7
}

MONSTER_KIND_TAB =
{
  scarce = 0.5
  less   = 0.75
  normal = 1.0
  more   = 1.33
  heaps  = 1.6
  nuts   = 2.0
}

RAMP_UP_FACTORS =
{
  slow   = 0.60
  medium = 1.00
  fast   = 1.70
}

BOSS_FACTORS =
{
  easier = 0.30
  medium = 0.60
  harder = 1.00
}

HEALTH_FACTORS =
{
  none     = 0
  scarce   = 0.4
  less     = 0.64
  bit_less = 0.8
  normal   = 1.0
  bit_more = 1.3
  more     = 1.6
  heaps    = 2.5
}

AMMO_FACTORS =
{
  none     = 0
  scarce   = 0.64
  less     = 0.8
  bit_less = 0.9
  normal   = 1.0
  bit_more = 1.1
  more     = 1.25
  heaps    = 1.6
}


--
-- styles control quantities of things in each level
--
GLOBAL_STYLE_LIST =
{
  outdoors    = { none=0,  few=60, some=40, heaps=20 }
  caves       = { none=60, few=20, some=20, heaps=5 }
  liquids     = { none=0,  few=20, some=20, heaps=80 }

  parks       = { none=10, few=40, some=50, heaps=10 }
  hallways    = { none=0,  few=60, some=30, heaps=10 }
  big_rooms   = { none=10, few=20, some=40, heaps=20 }
  teleporters = { none=20, few=40, some=60, heaps=10 }
  steepness   = { none=0,  few=10, some=70, heaps=10 }

  traps       = { none=0,  few=20, some=65, heaps=15 }
  cages       = { none=10, few=20, some=40, heaps=10 }
  secrets     = { none=0,  few=20, some=50, heaps=10 }
  ambushes    = { none=10, few=0,  some=50, heaps=10 }

  doors       = { none=5,  few=30, some=60, heaps=5 }
  windows     = { none=0,  few=20, some=80, heaps=20 }
  switches    = { none=10, few=30, some=50, heaps=10 }
  keys        = { none=0,  few=10, some=20, heaps=60 }

  symmetry    = { none=20, few=40, some=60, heaps=10 }
  pictures    = { none=0,  few=10, some=50, heaps=10 }
  barrels     = { none=10, few=50, some=50, heaps=10 }

  -- PLANNED or UNFINISHED stuff --

  cycles      = { none=50, few=0,  some=50, heaps=50 }
  ex_floors   = { none=0,  few=40, some=60, heaps=20 }
  porches     = { none=0,  few=10, some=60, heaps=10 }
  fences      = { none=30, few=30, some=10, heaps=10 }
  lakes       = { none=0,  few=60, some=0,  heaps=10 }
  islands     = { none=0,  few=60, some=0,  heaps=40 }
}


STYLE_CHOICES =
{
  "none",   _("NONE"),
  "rare",   _("Rare"),
  "few",    _("Few"),
  "less",   _("Less"),
  "some",   _("Some"),
  "more",   _("More"),
  "heaps",  _("Heaps"),
  "mixed",  _("Mix It Up"),
}


--
-- default parameters (each game can override these settings)
--
GLOBAL_PARAMETERS =
{
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
  -- Note the double underscore, since these materials actually
  -- begin with an underscore (like "_WALL" and "_FLOOR").

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

   tex__CEIL2  = "?ceil2"
  flat__CEIL2  = "?ceil2"

  thing_8166   = "?object"

  line_888     = "?switch_action"

  offset_301   = "?x_offset1"
  offset_302   = "?x_offset2"
  offset_303   = "?x_offset3"
  offset_304   = "?x_offset4"

  offset_401   = "?y_offset1"
  offset_402   = "?y_offset2"
  offset_403   = "?y_offset3"
  offset_404   = "?y_offset4"
}


GLOBAL_SKIN_DEFAULTS =
{
  wall   = "_ERROR"

  fence  = "?wall"
  floor  = "?wall"
  ceil   = "?wall"

  outer  = "?wall"
  floor2 = "?outer"
  ceil2  = "?outer"

  x_offset1 = ""
  x_offset2 = ""
  x_offset3 = ""
  x_offset4 = ""

  y_offset1 = ""
  y_offset2 = ""
  y_offset3 = ""
  y_offset4 = ""

  -- Doom engine stuff
  tag = ""
  light = ""
  object = ""
  switch_action = ""
  scroller = ""

  -- Quake engine stuff
  style = ""
  message = ""
  wait = ""
  targetname = ""
}

