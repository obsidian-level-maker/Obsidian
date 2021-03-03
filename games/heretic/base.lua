------------------------------------------------------------------------
--  BASE FILE for HERETIC
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
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

HERETIC = { }


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

OB_GAMES["heretic"] =
{
  label = _("Heretic"),
  priority = 40,

  format = "doom",
  game_dir = "heretic",
  iwad_name = "heretic.wad",

  tables =
  {
    HERETIC
  },

  hooks =
  {
    get_levels = HERETIC.get_levels,
    all_done   = HERETIC.all_done
  },
}

