------------------------------------------------------------------------
--  BASE FILE for HEXEN
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2015 Andrew Apted
--  Copyright (C) 2011-2012 Jared Blackburn
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

HEXEN = { }


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

HEXEN.PARAMETERS =
{
  -- special logic for Hexen weapon system
  hexen_weapons = true

  teleporters = true

  jump_height = 66

  max_name_length = 28

  skip_monsters = { 20,30 }

  time_factor   = 1.0
  damage_factor = 1.0
  ammo_factor   = 1.0
  health_factor = 1.0
}

------------------------------------------------------------

OB_GAMES["hexen"] =
{
  label = "Hexen"

  -- Hexen map format is a minor variation on the DOOM format 
  format = "doom"
  sub_format = "hexen"

  game_dir = "hexen"

  tables =
  {
    HEXEN
  }

  hooks =
  {
    get_levels = HEXEN.get_levels
    all_done   = HEXEN.all_done
  }
}

