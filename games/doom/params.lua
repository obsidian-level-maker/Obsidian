--------------------------------------------------------------------
--  DOOM PARAMETERS (Feature Set)
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2016 Andrew Apted
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------

DOOM.PARAMETERS =
{
  teleporters = true,

  jump_height = 24,

  map_limit = 12800,
  -- this is roughly how many characters can fit on the
  -- intermission screens (the CWILVxx patches).  It does not
  -- reflect any buffer limits in the DOOM.EXE
  max_name_length = 28,

  -- number of lines for intermission and end-of-episode texts
  max_screen_lines = 16,

  titlepic_lump   = "TITLEPIC",
  titlepic_format = "patch",

  interpic_lump   = "INTERPIC",
  interpic_format = "patch",

  skip_monsters = { 20,30,45 },

  monster_factor = 1.25,
  health_factor  = 1.0,
  ammo_factor    = 1.0,
  time_factor    = 1.0,

  mon_along_factor = 8.4,

  bex_map_prefix = "HUSTR_",

  bex_secret_name  = "C5TEXT",
  bex_secret2_name = "C6TEXT",

  -- meh, get rid of these (find a better way)
  doom2_monsters = true,
  doom2_weapons  = true,
  doom2_skies    = true,  -- RSKY# patches
}


DOOM.ACTIONS =
{
  --
  -- These keywords are used by prefabs that are remotely
  -- triggered (by a switch or walk-over line).
  --

  S1_OpenDoor = { id=103,  kind="open" },    -- opens and stays open
  W1_OpenDoor = { id=2,    kind="open" },    --
  GR_OpenDoor = { id=46,   kind="open" } ,   --

  W1_OpenDoorFast = { id=109, kind="open" },

  S1_UnlockBlue   = { id=133, kind="unlock" },
  S1_UnlockRed    = { id=135, kind="unlock" },
  S1_UnlockYellow = { id=137, kind="unlock" },

  S1_RaiseStair = { id=127,  kind="stair" }, -- 16 units
  W1_RaiseStair = { id=100,  kind="stair" },  --

  S1_FloorUp  = { id=18,   kind="floor_up" }, -- up to next highest floor
  W1_FloorUp  = { id=119,  kind="floor_up" }, --

  S1_LowerFloor = { id=23, kind="lower" },  -- down to lowest nb floor
  W1_LowerFloor = { id=38, kind="lower" },  --
}

