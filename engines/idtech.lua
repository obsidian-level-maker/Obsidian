----------------------------------------------------------------
--  Engine: idTech
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

IDTECH_0 = {}

OB_ENGINES["idtech_0"] =
{
  label = _("id Tech 0"),

  priority = 100,

  game = {wolf=1, noah=1},

  tables =
  {
    IDTECH_0
  },

  hooks =
  {
  
  }
}

----------------------------------------------------------------

IDTECH_1 = {}

OB_ENGINES["idtech_1"] =
{
  label = _("id Tech 1"),

  priority = 100,

  game = { chex3=1, doom1=1, doom2=1, hacx=1, harmony=1, heretic=1, hexen=1, strife=1 },

  tables =
  {
    IDTECH_1
  },

  hooks =
  {
  
  }
}

----------------------------------------------------------------

IDTECH_2 = {}

UNFINISHED["idtech_2"] =
{
  label = _("id Tech 2"),

  priority = 100,

  game = { quake=1 },

  tables =
  {
    IDTECH_2
  },

  hooks =
  {
  
  }
}
