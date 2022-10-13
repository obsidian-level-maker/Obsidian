------------------------------------------------------------------------
--  Base File for Wolf 3D/SoD
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

WOLF = { }

gui.import("factory")

-- These empty tables are needed not to throw errors in obsidian.lua

WOLF.PARAMETERS = { }

WOLF.THEMES = { }

WOLF.ROOM_THEMES = { }

WOLF.ROOMS = { }

------------------------------------------------------------

OB_GAMES["wolf"] =
{
	label = _("Wolfenstein 3D"),
	priority = 20,
	
	format = "wolf3d",
	
	game_dir = "wolf",
	
	tables =
	{
	  WOLF
	},
	
	hooks =
	{
      factory_setup = WOLF.factory_setup,
	},
}

