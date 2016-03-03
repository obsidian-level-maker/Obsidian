------------------------------------------------------------------------
--  Engine: Doom Legacy
------------------------------------------------------------------------
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
------------------------------------------------------------------------

LEGACY = { }


LEGACY.PARAMETERS =
{
  bridges = true
  extra_floors = true
  liquid_floors = true
}


function LEGACY.setup()
  gui.property("ef_solid_type",  281)
  gui.property("ef_liquid_type", 301)
  gui.property("ef_thing_mode", 1)
end


OB_ENGINES["legacy"] =
{
  label = "Legacy"
  extends = "boom"

  game = { doom1=1, doom2=1 }

  tables =
  {
    LEGACY
  }

  hooks =
  {
    setup = LEGACY.setup
  }
}

