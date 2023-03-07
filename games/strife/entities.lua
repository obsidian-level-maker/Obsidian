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
  --- players
  player1 = { id=1, r=16, h=56 },
  player2 = { id=2, r=16, h=56 },
  player3 = { id=3, r=16, h=56 },
  player4 = { id=4, r=16, h=56 },

  dm_player     = { id=11 },
  teleport_spot = { id=14 },

  --- pickups ---
  k_id   = { id=40 }, -- This should be 13, experimenting - Dasho
  k_badge   = { id=184 },
  k_passcard   = { id=185 },

  --- scenery ---
  wall_torch  = { id=107, r=10, h=64, light=255, pass=true, add_mode="extend" },
  pole_lamp  = { id=46, r=28, h=80, light=255 },
  huge_torch  = { id=50, r=20, h=80, light=255 },
  ceiling_light = { id=28, r=31, h=60, light=255, pass=true, ceil=true, add_mode="island" },
  standalone_light = { id=2028, r=12, h=54, light=255 },
  wide_light    = { id=105, r=16, h=44, light=255 },
  small_pillar  = { id=69, r=16, h=36 },

  barrel  = { id=94,   r=12, h=32 },
  passable_ceiling_decor = { id=80, r=16, h=24, pass=true, ceil=true },

  --- nature ---
  big_tree  = { id=202, r=30, h=109, pass=true },
  palm_tree  = { id=51, r=30, h=109, pass=true },
  tree_stub  = { id=33, r=30, h=80, pass=true },
  tall_bush  = { id=62, r=40, h=64, pass=true },
  short_bush  = { id=62, r=30, h=40, pass=true },

  light  = { id="light", r=1, h=1, pass=true },
  secret = { id="oblige_secret", r=1, h=1, pass=true },
  depot_ref = { id="oblige_depot", r=1, h=1, pass=true },

}

STRIFE.PLAYER_MODEL =
{
  strifeguy =
  {
    stats   = { health=0 },
    weapons = { dagger=1 },
  },
}
