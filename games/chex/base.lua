----------------------------------------------------------------
-- GAME DEF : Chex Quest 3
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

CHEX3 = { }

----------------------------------------------------------------
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
----------------------------------------------------------------

OB_GAMES["chex3"] =
{
	label = _("Chex Quest 3 (Exp)"),
	priority = 30,
	
	engine = "zdoom",

	format = "doom",
	--sub_format = "hexen",
	
	game_dir = "chex",
	iwad_name = "chex3.wad",

	use_generics = true,
	
	tables =
	{
		CHEX3
	},
	
	hooks =
	{
		get_levels = CHEX3.get_levels,
		all_done = CHEX3.all_done
	},
}
