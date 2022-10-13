----------------------------------------------------------------
--  Engine: Vanilla DOOM/DOOM2.EXE
----------------------------------------------------------------
--
--  Obsidian Level Maker
--
--  Copyright (C) 2021-2022 Dashodanger (?)
--  Copyright (C) 2021-2022 MsrSgtShooterPerson (?)
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

VANILLA = {}


VANILLA.ENTITIES =
{

}


VANILLA.PARAMETERS = -- These probably aren't required - Dasho
{
  boom_lines = false,
  boom_sectors = false
}


----------------------------------------------------------------


OB_ENGINES["vanilla"] =
{
  label = _("Vanilla"),

  priority = 100,

  game = "doomish",

  tables =
  {
    VANILLA
  },

  hooks =
  {
  
  }
}
