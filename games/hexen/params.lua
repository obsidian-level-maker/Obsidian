------------------------------------------------------------------------
--  HEXEN PARAMETERS and ACTIONS
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2015 Andrew Apted
--  Copyright (C) 2011-2012 Jared Blackburn

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

HEXEN.PARAMETERS =
{
  -- special logic for Hexen weapon system
  hexen_weapons = true,

  teleporters = false,

  jump_height = 66,

  max_name_length = 28,

  skip_monsters = { 20,30 },

  monster_factor = 1.0,
  health_factor  = 1.0,
  ammo_factor    = 1.0,
  time_factor    = 1.0,
}

HEXEN.ACTIONS =
{
  --
  -- These keywords are used by prefabs that are remotely
  -- triggered (by a switch or walk-over line).
  --
  S1_OpenDoor = { id=11, arg1="tag", arg2=16, flags=0x0400, kind="open" },    -- opens and stays open
  W1_OpenDoor = { id=11, arg1="tag", arg2=16, kind="open" },
  GR_OpenDoor = { id=11, arg1="tag", arg2=16, flags=0x2E00, kind="open" },

  W1_OpenDoorFast = { id=11, arg1="tag", arg2=64, kind="open" },   -- [ Heretic lacks this ]

  S1_RaiseStair = { id=217, arg1="tag", arg2=2, arg3=16, kind="stair", flags=0x0400 },  -- 16 units
  W1_RaiseStair = { id=217, arg1="tag", arg2=2, arg3=16, kind="stair" },

  S1_FloorUp    = { id=25, arg1="tag", arg2=8, flags=0x0400, kind="floor_up" },

  S1_LowerFloor = { id=22, arg1="tag", arg2=8, flags=0x0400, kind="lower" }, -- down to lowest nb floor
  W1_LowerFloor = { id=22, arg1="tag", arg2=8, kind="lower" },  --
}