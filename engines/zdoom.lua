----------------------------------------------------------------
--  Engine: ZDoom
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2008 Andrew Apted
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

ZDOOM = { }

ZDOOM.PARAMETERS =
{
  -- TODO
}

OB_ENGINES["zdoom"] =
{
  label = "ZDoom 2.31",

  extends = "boom",

  for_games =
  {
    chex3=1, doom1=1, doom2=1, heretic=1, hexen=1
  },

  tables = { ZDOOM },
}


----------------------------------------------------------------

GZDOOM = { }

OB_ENGINES["gzdoom"] =
{
  label = "GZDoom 1.2",
  priority = -1,  -- keep at bottom with ZDoom

  extends = "zdoom",

  for_games =
  {
    chex3=1, doom1=1, doom2=1, heretic=1, hexen=1
  },

  tables = { GZDOOM },
}

