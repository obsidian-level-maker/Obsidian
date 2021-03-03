------------------------------------------------------------------------
--  STRIFE THEMES
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
--  Copyright (C) 2019-2020 MsrSgtShooterPerson
--  --Adapted from MsrSgtShooterPerson's Doom themes.lua file
    --Into a singular theme (Castle) for Heretic
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

STRIFE.SINKS =
{
  -- sky holes --

  sky_plain =
  {
    mat   = "_SKY",
    dz    = 64,
    light = 16,
  },

  -- liquid floor --

  liquid_plain =
  {
    mat = "F_WATR01",
    dz  = -12,
  },

}


STRIFE.THEMES =
{
  DEFAULTS =
  {

    keys =
    {
      k_yellow = 50,
    },

    skyboxes =
    {

    },

    cage_lights = { 0, 8, 12, 13 },

    pool_depth = 24,
  },


  town =
  {

   style_list =
    {
      caves = { none=60, few=40, some=12, heaps=2 },
      outdoors = { none=10, few=35, some=90, heaps=30 },
      pictures = { few=20, some=80, heaps=30 },
      hallways = { none=30, few=80, some=15, heaps=10 },
      windows = { few=25, some=50, heaps=90 },
      cages = { none=30, few=50, some=20, heaps=10 },
      liquids = { none=45, few=30, some=20, heaps=5 },
      doors = { few=20, some=70, heaps=30 },
      steepness = { few=25, some=50, heaps=90 },
      big_rooms = { none=25, few=40, some=25, heaps=15 },
      ambushes = { none=5, few=20, some=75, heaps=30 },
      teleporters = { none=20, few=30, some=65, heaps=10 },
      keys = { none=15, few=50, some=50, heaps=20 },
      symmetry = { none=40, few=30, some=35, heaps=25 },
      switches = { none=20, few=60, some=40, heaps=10 },
      secrets = { few=5, some=80, heaps=25 },
      traps   = { none=10, few=40, some=70, heaps=25 },
      barrels = { none=10, few=50, some=20, heaps=5 },
    },

    liquids =
    {

    },

    narrow_halls =
    {
      vent = 50,
    },

    wide_halls =
    {
      deuce = 50,
    },

    floor_sinks =
    {
      liquid_plain = 50,
    },

    ceiling_sinks =
    {
      sky_plain = 50,
    },

    fences =
    {
      BRKGRY01 = 80,
    },

    cage_mats =
    {
      BRKGRY01 = 80,
    },

    facades =
    {
      BRKGRY01 = 80,
      BRKGRY17 = 40,
    },

    fence_groups =
    {
      PLAIN = 50,
    },

    fence_posts =
    {
      Post = 50,
    },

    beam_groups =
    {
      beam_metal = 50,
    },

    window_groups =
    {
      square = 70,
      tall   = 30,
    },

    wall_groups =
    {
      PLAIN = 50,
    },

    cave_torches =
    {

    },

    outdoor_torches =
    {

    },

    ceil_light_prob = 70,

    scenic_fences =
    {
      BRKGRY01 = 80,
    },

    sink_style =
    {
      sharp = 1,
      curved = 0.1,
    },

    steps_mat = "F_BRKTOP",

    post_mat  = "BRKGRY01",

  },

}


STRIFE.ROOM_THEMES =
{
  any_Hallway =
  {
    env  = "hallway",
    prob = 1,

    walls =
    {
      BRKGRY01  = 60,
      BRKGRY17  = 20,
    },

    floors =
    {
      F_BRKTOP = 50,
    },

    ceilings =
    {
      F_BRKTOP = 50,
    },
  },

  ---- TOWN THEME --------------------------------

  town_Gray =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      BRKGRY01  = 60,
      BRKGRY17  = 20,
    },

    floors =
    {
      F_BRKTOP = 50,
    },

    ceilings =
    {
      F_BRKTOP = 50,
    },
  },

  town_Outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      F_CAVE01 = 50,
    },

    naturals =
    {
      F_CAVE01 = 50,
    },

    porch_floors =
    {
      F_CAVE01 = 50,
    },

  },

  town_Cave =
  {
    env  = "cave",
    prob = 50,

    floors =
    {
      F_CAVE01 = 50,
    },

    naturals =
    {
      F_CAVE01 = 50,
    },

    porch_floors =
    {
      F_CAVE01 = 50,
    },

  },

}
------------------------------------------------------------------------


STRIFE.ROOMS =
{
  GENERIC =
  {
    env = "any",
  },

  OUTSIDE =
  {
    env = "outdoor",
    prob = 50,
  },

}


------------------------------------------------------------------------


OB_THEMES["town"] =
{
  label = _("Town"),
  game = "strife",
  name_class = "CASTLE",
  mixed_prob = 50,
}

