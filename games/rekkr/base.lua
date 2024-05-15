----------------------------------------------------------------
-- GAME DEF : REKKR
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

REKKR = { }

----------------------------------------------------------------
gui.import("params")
gui.import("themes")
gui.import("resources")
gui.import("names")

----------------------------------------------------------------

function REKKR.all_done()
	gui.wad_insert_file("data/endoom/ENDOOM.bin", "ENDOOM")
end

OB_GAMES["rekkr"] =
{
	label = _("REKKR"),
	priority = 93,
	
	engine = "idtech_1",

	format = "doom",
	
	game_dir = "rekkr",
	iwad_name = "rekkr.wad",

	tables =
	{
		REKKR
	},
	
	hooks =
	{
		slump_setup = REKKR.slump_setup,
		all_done = REKKR.all_done
	},
}
