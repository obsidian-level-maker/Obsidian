----------------------------------------------------------------
-- GAME DEF : Chex Quest 1
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

CHEX1 = { }

----------------------------------------------------------------
gui.import("params")
gui.import("themes")
gui.import("resources")
gui.import("names")
----------------------------------------------------------------

function CHEX1.all_done()
	gui.wad_insert_file("data/endoom/ENDOOM.bin", "ENDOOM")
end

OB_GAMES["chex1"] =
{
	label = _("Chex Quest 1"),
	priority = 93,
	
	engine = "idtech_1",

	format = "doom",
	
	game_dir = "chex1",
	iwad_name = "chex.wad",

	tables =
	{
		CHEX1
	},
	
	hooks =
	{
		slump_setup = CHEX1.slump_setup,
		all_done = CHEX1.all_done
	},
}
