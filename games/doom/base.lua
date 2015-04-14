------------------------------------------------------------------------
--  BASE FILE for DOOM, DOOM II (etc)
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2015 Andrew Apted
--  Copyright (C) 2011,2014 Chris Pisarczyk
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

DOOM = { }


ob_require("params")

ob_require("entities")
ob_require("monsters")
ob_require("pickups")
ob_require("weapons")

ob_require("materials")
ob_require("themes")
ob_require("levels")
ob_require("resources")

ob_require("x_doom1")
ob_require("x_tnt")
ob_require("x_plutonia")
ob_require("x_freedoom")


------------------------------------------------------------

OB_GAMES["doom2"] =
{
  label = "Doom 2"

  priority = 99  -- keep at top

  format = "doom"
  game_dir = "doom"

  tables =
  {
    DOOM, DOOM2
  }

  hooks =
  {
    get_levels = DOOM.get_levels
    end_level  = DOOM.end_level
    all_done   = DOOM.all_done
  }
}

