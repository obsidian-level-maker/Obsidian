------------------------------------------------------------------------
--  BASE FILE for QUAKE
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2015 Andrew Apted
--  Copyright (C)      2011 Chris Pisarczyk
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

QUAKE = { }


------------------------------------------------------------

ob_require("entities")
ob_require("monsters")
ob_require("pickups")
ob_require("weapons")

ob_require("materials")
ob_require("themes")
ob_require("levels")
ob_require("resources")

------------------------------------------------------------

QUAKE.PARAMETERS =
{
  -- Quake engine needs all coords to lie between -4000 and +4000.
  -- (limitation of the client/server protocol).
  map_limit = 8000

  centre_map = true

  use_spawnflags = true
  entity_delta_z = 24

  -- keys are lost when you open a locked door
  lose_keys = true

  extra_floors = true
  deep_liquids = true

  jump_height = 42

  -- the name buffer in Quake can fit 39 characters, however
  -- the on-screen space for the name is much less.
  max_name_length = 20

  skip_monsters = { 20,30 }

  time_factor   = 1.0
  damage_factor = 1.0
  ammo_factor   = 1.0
  health_factor = 1.0

  monster_factor = 0.6
}

------------------------------------------------------------

OB_GAMES["quake"] =
{
  label = "Quake"

  format = "quake"
  game_dir = "quake"

  tables =
  {
    QUAKE
  }

  hooks =
  {
    get_levels  = QUAKE.get_levels
    begin_level = QUAKE.begin_level
  }
}

