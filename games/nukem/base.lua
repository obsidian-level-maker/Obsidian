----------------------------------------------------------------
-- GAME DEF : Duke Nukem 3D
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2009 Enhas
--  Copyright (C) 2011 Andrew Apted
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

NUKEM = { }

----------------------------------------------------------------
gui.import("params")
gui.import("entities")
gui.import("monsters")
gui.import("pickups")
gui.import("weapons")
gui.import("materials")
gui.import("themes")
gui.import("levels")
gui.import("resources")
----------------------------------------------------------------

UNFINISHED["nukem"] =
{
	label = _("Duke Nukem 3D (Exp)"),
	priority = 30,
	
	engine = "build",
	format = "nukem",
	
	game_dir = "nukem",

	tables =
	{
		NUKEM
	},
	
	hooks =
	{
		get_levels = NUKEM.get_levels,
		all_done   = NUKEM.all_done
	},
}
