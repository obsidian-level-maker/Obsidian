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

  teleporters = true,

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
  -- Hexen's actions work differently, so will revisit this - Dasho
  --[[
  -- These are used for converting generic linedef types
  
  Generic_Key_One = { id=700, rid=27 },
  Generic_Key_Two = { id=701, rid=28 },
  Generic_Key_Three = { id=702, rid=26 },

  --
  -- These keywords are used by prefabs that are remotely
  -- triggered (by a switch or walk-over line).
  --

  S1_OpenDoor = { id=103,  kind="open" },    -- opens and stays open
  W1_OpenDoor = { id=2,    kind="open" },    --
  GR_OpenDoor = { id=46,   kind="open" },    --

  W1_OpenDoorFast = { id=2, kind="open" },   -- [ Heretic lacks this ]

  S1_RaiseStair = { id=106,  kind="stair" },  -- 16 units
  W1_RaiseStair = { id=107,  kind="stair" },  --

  S1_FloorUp    = { id=18,  kind="floor_up" }, -- up to next highest floor

  S1_LowerFloor = { id=23, kind="lower" },  -- down to lowest nb floor
  W1_LowerFloor = { id=38, kind="lower" }  --
  ]]--
}