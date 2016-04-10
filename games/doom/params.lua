--------------------------------------------------------------------
--  DOOM PARAMETERS (Feature Set)
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2013 Andrew Apted
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------

DOOM.PARAMETERS =
{
  teleporters = true

  jump_height = 24

  map_limit = 12800

  -- this is roughly how many characters can fit on the
  -- intermission screens (the CWILVxx patches).  It does not
  -- reflect any buffer limits in the DOOM.EXE
  max_name_length = 28

  skip_monsters = { 20,30,45 }

  monster_factor = 1.25
  health_factor  = 1.0
  ammo_factor    = 1.0
  time_factor    = 1.0

  bex_map_prefix = "HUSTR_"

  -- meh, get rid of these (find a better way)
  doom2_monsters = true
  doom2_weapons  = true
  doom2_skies    = true  -- RSKY# patches
}


DOOM.ACTIONS =
{
  --
  -- These keywords are used by prefabs with an "action" value.
  --

  S1_OpenDoor = 103    -- opens and stays open
  W1_OpenDoor = 2      --
  GR_OpenDoor = 46

  S1_RaiseStair = 127  -- 16 units
  W1_RaiseStair = 100  --

  S1_FloorUp  = 18     -- up to next highest floor
  W1_FloorUp  = 119    --

  S1_LowerFloor = 23  -- down to lowest nb floor
  W1_LowerFloor = 38  --
}

