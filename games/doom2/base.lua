------------------------------------------------------------------------
--  BASE FILE for DOOM2, DOOM2 II (etc)
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C) 2011,2014, 2022 Armaetus
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

DOOM2 = { }


gui.import("params")

gui.import("entities")
gui.import("factory") -- For earlier Oblige versions
gui.import("monsters")
gui.import("pickups")
gui.import("weapons")

gui.import("materials")
gui.import("themes")
gui.import("levels")
gui.import("resources")
gui.import("vanilla_mats")

-- pull in the other Doom 2 games...

gui.import("x_tnt")
gui.import("x_plutonia")

------------------------------------------------------------------------

OB_GAMES["doom2"] =
{
  label = _("Doom 2"),

  priority = 99,  -- keep at top

  engine = "idtech_1",
  format = "doom",
  game_dir = "doom2",
  iwad_name = "doom2.wad",

  tables =
  {
    DOOM2
  },

  hooks =
  {
    factory_setup = DOOM2.factory_setup,
    get_levels = DOOM2.get_levels,
    end_level  = DOOM2.end_level,
    all_done   = DOOM2.all_done
  },
}