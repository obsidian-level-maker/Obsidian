------------------------------------------------------------------------
--  WOLF3D PARAMETERS and ACTIONS
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

WOLF.KEY_DOORS =
{
  k_silver = { door_kind="door_silver", door_side=14 },
  k_gold   = { door_kind="door_gold",   door_side=14 },
}

WOLF.TILE_NUMS =
{
  area_min = 108,
  area_max = 143,

  deaf_guard = 106,
  elevator_secret = 107,

  door = { 90, 91 },  -- E/W then N/S

  door_gold   = { 92, 93 },
  door_silver = { 94, 95 },

  door_elevator = { 100, 101 },
}

WOLF.KEY_NUM_PROBS =
{
  small   = { 90, 50, 20 },
  regular = { 40, 90, 40 },
  large   = { 20, 50, 90 },
}

WOLF.PARAMETERS =
{
  tiled  = true,

  block_limit = 64,

  border_seeds = 1,
  free_seeds   = 0,

  no_height = true,
  no_sky = true,
  one_lock_tex = true,
  elevator_exit = true,
  blocky_items = true,
  blocky_doors = true,
  tiered_skills = true,
  four_dirs = true,
  sealed_start = true,

  time_factor   = 1.0,
  damage_factor = 1.0,
  ammo_factor   = 0.8,
  health_factor = 0.7,
}

WOLF.ACTIONS =
{

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
}
