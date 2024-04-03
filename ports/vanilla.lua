----------------------------------------------------------------
--  Port: Vanilla
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


VANILLA.PARAMETERS =
{

}


----------------------------------------------------------------


OB_PORTS["vanilla"] =
{
  label = _("Vanilla"),

  priority = 100,

  engine = {idtech_0=1,idtech_1=0},

  game = {doom1=0,doom2=0,hacx=0,heretic=0,noah=1,wolf=1},

  tables =
  {
    VANILLA
  },

  hooks =
  {
  
  }
}

----------------------------------------------------------------

LIMIT_ENFORCING = {}


LIMIT_ENFORCING.ENTITIES =
{

}


LIMIT_ENFORCING.PARAMETERS =
{

}

OB_PORTS["limit_enforcing"] =
{
  label = _("Vanilla"), -- Keep Vanilla labeling for consistency
  engine = "idtech_1",
  game = { chex1=1,doom1=1,doom2=1,ultdoom=1,heretic=1,hacx=1,wolf=0,noah=0 },
  priority = 99
}