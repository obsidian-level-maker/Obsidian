----------------------------------------------------------------
-- GAME DEF : HacX 1.2
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

HACX = { }

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

function HACX.all_done()
	local wad_file = "games/hacx/data/HAC_EXIT.wad"
	gui.wad_transfer_lump(wad_file, "HAC_EXIT", "HAC_EXIT")
end

OB_GAMES["hacx"] =
{
	label = _("HacX 1.2 (Exp)"),
	priority = 30,
	
	format = "doom",

	game_dir = "hacx",
	iwad_name = "hacx.wad",

	use_generics = true,
	
	tables =
	{
		HACX
	},
	
	hooks =
	{
		get_levels = HACX.get_levels,
		all_done   = HACX.all_done
	},
}
