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
--  as published by the Free Software Foundation; either version 2,
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
gui.import("params")

gui.import("entities")
gui.import("monsters")
gui.import("pickups")
gui.import("weapons")
gui.import("shapes")

gui.import("materials")
gui.import("themes")
gui.import("levels")
gui.import("resources")

------------------------------------------------------------

OB_GAMES["hexen"] =
{
  label = _("Hexen"),
  priority = 34,

  -- Hexen map format is a minor variation on the DOOM format
  format = "doom",
  sub_format = "hexen",

  game_dir = "hexen",
  iwad_name = "hexen.wad",

  tables =
  {
    HEXEN
  },

  hooks =
  {
    get_levels = HEXEN.get_levels,
    all_done   = HEXEN.all_done
  },
}

