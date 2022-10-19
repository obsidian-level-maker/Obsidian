------------------------------------------------------------------------
--  Base File for Super Noah's Ark 3D
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

NOAH = { }

gui.import("factory")

-- These empty tables are needed not to throw errors in obsidian.lua

NOAH.PARAMETERS = { }

NOAH.THEMES = { }

NOAH.ROOM_THEMES = { }

NOAH.ROOMS = { }

------------------------------------------------------------

OB_GAMES["noah"] =
{
	label = _("Noah's Ark 3D"),
	priority = 46,
	
	engine = "idtech_0",
	format = "wolf3d",
	
	game_dir = "noah",
	
	tables =
	{
	  NOAH
	},
	
	hooks =
	{
      factory_setup = NOAH.factory_setup,
	},
}

