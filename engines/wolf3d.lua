----------------------------------------------------------------
--  Engine: Wolfenstein 3D
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

WOLF_3D = {}


WOLF_3D.ENTITIES =
{

}


WOLF_3D.PARAMETERS =
{

}


----------------------------------------------------------------


OB_ENGINES["wolf_3d"] =
{
  label = _("Vanilla"),

  priority = 100,

  game = "wolf",

  tables =
  {
    WOLF_3D
  },

  hooks =
  {
  
  }
}
