------------------------------------------------------------------------
--  STRIFE ENTITIES
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2011 Andrew Apted
--  Copyright (C) 2011-2012 Jared Blackburn
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

STRIFE.ENTITIES =
{

  --- entities for generic prefabs, the rid field stands for "Real ID" --
  generic_barrel = { id=11000, rid=94, r=12, h=32 },
  generic_ceiling_light = { id=11001, rid=28, r=31, h=60, light=255, pass=true, ceil=true, add_mode="island" },
  generic_standalone_light = { id=11002, rid=2028, r=12, h=54, light=255 }, -- "torches" and such, freestanding on a floor
  generic_wall_light    = { id=11003, rid=107, r=10, h=64, light=255, pass=true, add_mode="extend" }, -- "torches" and such, attached to a wall
  generic_wide_light    = { id=11004, rid=105, r=16, h=44, light=255 }, -- wide standalone light, braziers, etc
  generic_small_pillar  = { id=11005, rid=69, r=16, h=36 },
  k_one = { id=11006, rid=13 },
  k_two = { id=11007, rid=184 },
  k_three = { id=11008, rid=185 },
  generic_p1_start = { id=11009, rid=1, r=16, h=56 },
  generic_p2_start = { id=11010, rid=2, r=16, h=56 },
  generic_p3_start = { id=11011, rid=3, r=16, h=56 },
  generic_p4_start = { id=11012, rid=4, r=16, h=56 },
  generic_teleport_spot = { id=11013, rid=14},

  --- players
  player1 = { id=1, r=16, h=56 },
  player2 = { id=2, r=16, h=56 },
  player3 = { id=3, r=16, h=56 },
  player4 = { id=4, r=16, h=56 },

  dm_player     = { id=11 },
  teleport_spot = { id=14 },

  --- pickups ---
  k_id   = { id=13 },
  k_badge   = { id=184 },
  k_passcard   = { id=185 },

  --- scenery ---
  wall_torch  = { id=107, r=10, h=64, light=255, pass=true, add_mode="extend" },
  pole_lamp  = { id=46, r=28, h=80, light=255 },
  huge_torch  = { id=50, r=20, h=80, light=255 },

  barrel  = { id=94,   r=12, h=32 },

  --- nature ---
  big_tree  = { id=202, r=30, h=109, pass=true },
  palm_tree  = { id=51, r=30, h=109, pass=true },
  tree_stub  = { id=33, r=30, h=80, pass=true },
  tall_bush  = { id=62, r=40, h=64, pass=true },
  short_bush  = { id=62, r=30, h=40, pass=true },

}

STRIFE.GENERIC_REQS =
{
  -- These are used for fulfilling fab pick requirements in prefab.lua
  Generic_Key_One = { kind = "k_one", rkind = "k_id" },
  Generic_Key_Two = { kind = "k_two", rkind = "k_badge" },
  Generic_Key_Three = { kind = "k_three", rkind = "k_passcard" }
}

STRIFE.PLAYER_MODEL =
{
  strifeguy =
  {
    stats   = { health=0 },
    weapons = { dagger=1 },
  },
}
