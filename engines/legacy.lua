----------------------------------------------------------------
--  Engine: Doom Legacy
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


OB_ENGINES["legacy"] =
{
  label = "Legacy 1.42",

  for_games = { doom1=1, doom2=1 },

  hooks =
  {
    all_done = BOOM.all_done,
  },

  param =
  {
    boom_lines = true,
    boom_sectors = true,

    extra_floors = true,
    liquid_floors = true,
  },
}

