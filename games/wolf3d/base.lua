------------------------------------------------------------------------
--  BASE FILE for WOLF3D
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2015 Andrew Apted
--  Copyright (C) 2011-2012 Jared Blackburn
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
------------------------------------------------------------------------

-- constants
WF_NO_TILE = 48
WF_NO_OBJ  = 0

WOLF = { }


------------------------------------------------------------
gui.import("params")

gui.import("entities")
gui.import("monsters")
gui.import("pickups")
gui.import("weapons")
gui.import("materials")
gui.import("themes")
gui.import("levels")

------------------------------------------------------------

OB_GAMES["wolf3d"] =
{
  label = _("Wolfenstein 3-D (Exp)"),
  priority = 34,

  format = "wolf3d",

  game_dir = "wolf3d",

  tables =
  {
    WOLF
  },

  hooks =
  {
    setup      = WOLF.setup,
    get_levels = WOLF.get_levels,
  },
}

