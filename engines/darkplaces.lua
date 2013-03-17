----------------------------------------------------------------
--  Engine: Darkplaces (QUAKE)
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2008,2010 Andrew Apted
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

DARKPLACES = { }

DARKPLACES.PARAMETERS =
{
  colored_lighting = true
  sky_box = true
}


function DARKPLACES.setup()
end


OB_ENGINES["darkplaces"] =
{
  label = "DarkPlaces"

  game = "quake"

  tables =
  {
    DARKPLACES
  }

  hooks =
  {
    setup = DARKPLACES.setup
  }
}

