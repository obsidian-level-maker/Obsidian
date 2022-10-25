------------------------------------------------------------------------
--  Base File for Operation Body Count
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

OBC = { }

gui.import("factory")

-- These empty tables are needed not to throw errors in obsidian.lua

OBC.PARAMETERS = { }

OBC.THEMES = { }

OBC.ROOM_THEMES = { }

OBC.ROOMS = { }

------------------------------------------------------------

OB_GAMES["obc"] =
{
	label = _("Op. Body Count"),
	priority = 25,
	
	engine = "idtech_0",
	format = "wolf3d",
	
	game_dir = "obc",
	
	tables =
	{
	  OBC
	},
	
	hooks =
	{
      factory_setup = OBC.factory_setup,
	},
}

