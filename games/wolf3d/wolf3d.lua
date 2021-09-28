----------------------------------------------------------------
-- GAME DEF : Wolfenstein 3D
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2010 Andrew Apted
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
--
-- WISHLIST
-- ========
--
--   !  get it working (see tiler.lua)
--
--   +  push-walls for secret areas!
--   +  secret elevators
--   +  bosses!
--
--   -  decide_monster : skills are "tiered"
--   -  health/ammo : no skills! -- use medium one
--   -  place_items : never where monsters are!
--   -  create rooms with 'endgame' object
--
--   +  ensure limits are enforced:
--      - MAXACTORS = 150  (remove actors at random)
--      - MAXSTATS  = 400  (remove statics at random)
--      - MAXDOORS  = 64   (remove unneeded doors at random)
--
--   -  patrolling monsters (need to create path with arrows)
--   -  secret levels (full of treasure)
--   -  something interesting in middle of big rooms
--   -  elevator "entry" in first room
--
----------------------------------------------------------------

WOLF  = { }
SPEAR = { }


----------------------------------------------------------------

SPEAR.MATERIALS =
{
  BRN_CONC  = { t=0x3e, hue="#C60" },
  CONCRETE1 = { t=0x39, hue="#CCC" },
  CONCRETE2 = { t=0x36, hue="#CCC" },
  CONCRETE3 = { t=0x37, hue="#CCC" },
  ELEVATOR2 = { t=0x3c, hue="#FF0" },
  PURP_BRIK = { t=0x3f, hue="#F0F" },
  WHIT_PANL = { t=0x3d, hue="#FFF" },

  SP_BLOOD  = { t=0x38, hue="#F00" },
  SP_BROWN1 = { t=0x3a, hue="#C60" },
  SP_BROWN2 = { t=0x3b, hue="#C60" },
  SP_GRAY1  = { t=0x32, hue="#BBB" },
  SP_GRAY2  = { t=0x33, hue="#BBB" },
  SPGR_FLAG = { t=0x34, hue="#CCC" },
  SPGR_WRET = { t=0x35, hue="#CCC" },
}

-- FIXME: UNSORTED or SPECIAL --

--- DOOR      = { 0x5a, 0x5b }
--- DOOR_GOLD = { 0x5c, 0x5d }
--- DOOR_SILV = { 0x5e, 0x5f }
--  DOOR_ELEV = { 0x64, 0x65 }
--  ELEV_SECR = { 0x6b }
--
--- 0x55 Dead elevator rails    | Elevator
--- 0x60 Stuck door-N/S holo    | Stuck door-N/S holo
--- 0x61 Stuck door-E/W holo    | Stuck door-E/W holo
--- 0x6a Deaf guard             | Floor (deaf guard)


----------------------------------------------------------------

WOLF.COMBOS =
{
  TMP_WOOD   = { wall="WOOD1" },
  TMP_GSTONE = { wall="GSTONE1" },
  TMP_BLUE   = { wall="BLU_STON1" },
  TMP_RED    = { wall="RED_BRIK" },

  WOOD =
  {
    mat_pri = 5,
    wall = 12, void = 12, floor=0, ceil=0,
    decorate = 10, door_side = 23,

    theme_probs = { BUNKER=120, CELLS=25  },
  },

  GRAY_STONE =
  {
    mat_pri = 7,
    wall = 1, void = 1, floor=0, ceil=0,
    decorate = { 4,6 }, door_side = 28,

    theme_probs = { BUNKER=60, CAVE=30 },
  },

  GRAY_BRICK =
  {
    mat_pri = 7,
    wall = 35, void = 35, floor=0, ceil=0,
    decorate = { 37,43 }, door_side = 49,

    theme_probs = { CELLS=60, BUNKER=40 },
  },

  BLUE_STONE =
  {
    mat_pri = 6,
    wall = 8, void = 8, floor=0, ceil=0,
    decorate = { 5,7 }, door_side = 41,

    theme_probs = { CELLS=140 },
  },

  BLUE_BRICK =
  {
    mat_pri = 6,
    wall = 40, void = 40, floor=0, ceil=0,
    decorate = { 34,36 },

    theme_probs = { CELLS=80 },
  },

  RED_BRICK =
  {
    mat_pri = 5,
    wall = 17, void = 17, floor=0, ceil=0,
    decorate = { 18,38 }, door_side = 20,

    theme_probs = { BUNKER=80 },
  },

  PURPLE_STONE =
  {
    mat_pri = 1,
    wall = 19, void = 19, floor=0, ceil=0,
    decorate = 25,

    theme_probs = { CAVE=30 },
  },

  BROWN_CAVE =
  {
    mat_pri = 3,
    wall = 29, void = 29, floor=0, ceil=0,
    decorate = { 30,31,32 },

    theme_probs = { CAVE=90 },
  },

  BROWN_BRICK =
  {
    mat_pri = 5,
    wall = 42, void = 42, floor=0, ceil=0,
    door_side = 47,

    theme_probs = { CAVE=20 },
  },

  BROWN_STONE =
  {
    mat_pri = 5,
    wall = 44, void = 44, floor=0, ceil=0,

    theme_probs = { CAVE=50, CELLS=20 },
  },
}

WOLF.EXITS =
{
  ELEVATOR =  -- FIXME: not needed, remove
  {
    mat_pri = 0,
    wall = 21, void = 21, floor=0, ceil=0,
  },
}


WOLF.MISC_PREFABS =
{
  elevator =
  {
    prefab = "WOLF_ELEVATOR",
    add_mode = "extend",

    skin = { elevator=21, front=14, }
  },
}



---------------------------------------------------------------

UNFINISHED["spear"] =
{
  label = "Spear of Destiny",

  priority = -2,  -- keep at bottom (with Wolf3d)

  format = "wolf3d",

  tables =
  {
    WOLF  -- SPEAR
  },

  hooks =
  {
    setup      = SPEAR.setup,
    get_levels = SPEAR.get_levels,
  },
}


-----------------------------------------------------------

