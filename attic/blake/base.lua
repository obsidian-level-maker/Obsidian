------------------------------------------------------------------------
--  Base File for Blake Stone
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

BLAKE = { }

gui.import("factory")

-- These empty tables are needed not to throw errors in obsidian.lua

BLAKE.PARAMETERS = { }

BLAKE.THEMES = { }

BLAKE.ROOM_THEMES = { }

BLAKE.ROOMS = { }

------------------------------------------------------------

OB_GAMES["blake"] =
{
	label = _("Blake Stone 1"),
	priority = 25,
	
	engine = "idtech_0",
	format = "wolf3d",
	
	game_dir = "blake",
	
	tables =
	{
	  BLAKE
	},
	
	hooks =
	{
      factory_setup = BLAKE.factory_setup,
	},
}

