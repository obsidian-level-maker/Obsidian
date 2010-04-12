----------------------------------------------------------------
--  Engine: Skulltag
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2009 Andrew Apted
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


OB_ENGINES["skulltag"] =
{
  label = "Skulltag 98b",

  for_games =
  {
    chex3=1, doom1=1, doom2=1, heretic=1, hexen=1
  },

  -- FIXME: this is only for level names, use MAPINFO instead
  hooks =
  {
    all_done = Boom_all_done,
  },

  param =
  {
    boom_lines = true,
    boom_sectors = true,

    -- FIXME: more stuff
  },
}

