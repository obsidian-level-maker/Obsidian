------------------------------------------------------------------------
--  HERETIC THEMES
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
--  Copyright (C) 2019-2020 MsrSgtShooterPerson
--  Adapted for Heretic by Dashodanger
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

HERETIC.SINKS =
{
  -- sky holes --

  sky_plain =
  {
    mat   = "_SKY",
    dz    = 64,
    light = 16,
  },

-- sky ceilings

  sky_ceiling =
  {
    mat   = "_SKY",
    dz    = 48,
    light = 16,

    trim_mat = "_WALL",
    trim_dz  = -9,
    trim_light = 16,
  },

  -- liquid floor --

  liquid_plain =
  {
    mat = "_LIQUID",
    dz  = -12,
  },

  liquid_trim =
  {
    mat   = "_LIQUID",
    dz    = -16,

    trim_mat = "_WALL",
    trim_dz  = -8,
  },

  -- ceiling lights --


  light_plain =
  {
    mat = "_FLOOR",
    dz  = 8,
    light = 32,

    trim_mat = "_WALL",
    trim_dz  = -5,
    trim_light = 16,
  },

-- plain ceilings

  ceiling_plain =
  {
    mat   = "_CEIL",
    dz    = 64,
    light = 16,
  },

-- plain floors

  floor_plain =
  {
    mat = "_FLOOR",
    dz = -16,
    light = 32,

    trim_mat = "_WALL",
    trim_dz = -8,
  },

  -- fantastic floors

  floor_trim_sky =
  {
    mat = "_FLOOR",

    trim_mat = "_SKY",
    trim_dz = -8,
  },

  floor_trim_liquid =
  {
    mat = "_FLOOR",
    dz = -4,

    trim_mat = "_LIQUID",
    trim_dz = -8,
  },

  floor_mixup =
  {
    mat = "_CEIL",
    dz = -8,

    trim_mat = "_WALL",
    trim_dz = -4,
  },

  --[[ street sink def, do not use for anything else
  floor_default_streets =
  {
    mat = "FLOOR30",
    dz = 2,

    trim_mat = "FLOOR10",
    trim_dz = 2,
  } ]]
}


HERETIC.THEMES =
{
  DEFAULTS =
  {
    -- Note: there is no way to control the order which keys are used

    keys =
    {
      k_yellow = 70,
      k_green  = 50,
      k_blue   = 30,
    },

    skyboxes =
    {
      -- Heretic needs a 3D skybox, bois
    },

    cage_lights = { 0, 8, 12, 13 },

    pool_depth = 24,
  },


  city =
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
      water2 = 40,
      water  = 50,
      lava   = 10,
      sludge = 15,
      magma  = 10,
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
      floor_plain = 50,
      liquid_plain = 40,
      liquid_trim = 40,
      floor_trim_sky = 5,
      floor_trim_liquid = 5,
      floor_mixup = 5,
    },

    ceiling_sinks =
    {
      ceiling_plain = 50,
      --sky_plain = 50,
      --sky_ceiling = 50,
      light_plain = 25,
    },

    fences =
    {
      CSTLRCK = 80,
      GRSTNPB = 40,
    },

    cage_mats =
    {
      CSTLRCK = 80,
      GRSTNPB = 40,
    },

    facades =
    {
      GRSTNPB = 50,
      GRSTNPBV = 15,
      CSTLRCK = 40,
      CTYSTUC4 = 15,
      SPINE2 = 5,
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
      torches1 = 50,
    },

    maw_torches =
    {
      fire_brazier  = 20,
      wall_torch   = 70,
      mercury_lamp  = 10,
    },

    outdoor_torches =
    {
      fire_brazier   = 10,
      mercury_lamp  = 40,
    },

--    ceil_light_prob = 70,

    scenic_fences =
    {
      WDGAT64 = 50,
    },

    sink_style =
    {
      sharp = 1,
      curved = 0.1,
    },

    skyboxes =
    {
      Skybox_castle_skybox = 50,
    },

    steps_mat = "CSTLRCK",

    post_mat  = "WOODWL",

  },

  maw =
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
      water2 = 40,
      water  = 50,
      lava   = 20,
      magma  = 10,
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
      floor_plain = 50,
      liquid_plain = 40,
      liquid_trim = 40,
      floor_trim_sky = 5,
      floor_trim_liquid = 5,
      floor_mixup = 5,
    },

    ceiling_sinks =
    {
      ceiling_plain = 50,
      --sky_plain = 50,
      --sky_ceiling = 50,
      light_plain = 25,
    },

    fences =
    {
      LOOSERCK = 80,
    },

    cage_mats =
    {
      LOOSERCK = 80,
    },

    facades =
    {
      LOOSERCK = 80,
      LAVA1 = 40,
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
      torches1 = 50,
    },

    maw_torches =
    {
      fire_brazier  = 20,
      wall_torch   = 70,
      mercury_lamp  = 10,
    },

    outdoor_torches =
    {
      fire_brazier   = 10,
      mercury_lamp  = 40,
    },

--    ceil_light_prob = 70,

    scenic_fences =
    {
      GATMETL2 = 50,
      GATMETL3 = 50,
      GATMETL4 = 50,
      GATMETL5 = 50,
    },

    sink_style =
    {
      sharp = 1,
      curved = 0.1,
    },

    steps_mat = "SQPEB1",

    post_mat  = "SQPEB1",

  },

  dome =
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
      water2 = 40,
      water  = 50,
      lava   = 5,
      sludge = 15,
      magma  = 5,
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
      floor_plain = 50,
      liquid_plain = 40,
      liquid_trim = 40,
      floor_trim_sky = 5,
      floor_trim_liquid = 5,
      floor_mixup = 5,
    },

    ceiling_sinks =
    {
      ceiling_plain = 50,
      --sky_plain = 50,
      --sky_ceiling = 50,
      light_plain = 25,
    },

    fences =
    {
      GRSTNPB = 80,
      BRWNRCKS = 40,
    },

    cage_mats =
    {
      GRSTNPB = 80,
      BRWNRCKS = 40,
    },

    facades =
    {
      GRSTNPB = 50,
      ROOTWALL = 50,
      CSTLRCK = 50,
      BRWNRCKS = 50,
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
      torches1 = 50,
    },

    maw_torches =
    {
      fire_brazier  = 20,
      wall_torch   = 70,
      mercury_lamp  = 10,
    },

    outdoor_torches =
    {
      fire_brazier   = 10,
      mercury_lamp  = 40,
    },

--    ceil_light_prob = 70,

    scenic_fences =
    {
      GATMETL2 = 50,
      GATMETL3 = 50,
      GATMETL4 = 50,
      GATMETL5 = 50,
    },

    sink_style =
    {
      sharp = 1,
      curved = 0.1,
    },

    steps_mat = "GRSTNPB",

    post_mat  = "WOODWL",

  },

   ossuary =
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
      water2 = 40,
      water  = 50,
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
      floor_plain = 50,
      liquid_plain = 40,
      liquid_trim = 40,
      floor_trim_sky = 5,
      floor_trim_liquid = 5,
      floor_mixup = 5,
    },

    ceiling_sinks =
    {
      ceiling_plain = 50,
      --sky_plain = 50,
      --sky_ceiling = 50,
      light_plain = 25,
    },

    fences =
    {
      CSTLRCK = 40,
    },

    cage_mats =
    {
      CSTLRCK = 40,
    },

    facades =
    {
      CSTLMOSS = 50,
      SNDBLCKS = 25,
      CSTLRCK = 40,
      CHAINSD = 15,
      LOOSERCK = 30,
      GRNBLOK1 = 10,
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
      torches1 = 50,
    },

    maw_torches =
    {
      fire_brazier  = 20,
      wall_torch   = 70,
      mercury_lamp  = 10,
    },

    outdoor_torches =
    {
      fire_brazier   = 10,
      mercury_lamp  = 40,
    },

--    ceil_light_prob = 70,

    scenic_fences =
    {
      WDGAT64 = 50,
    },

    sink_style =
    {
      sharp = 1,
      curved = 0.1,
    },

    steps_mat = "SQPEB2",

    post_mat  = "WOODWL",

  },


  demense =
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
      water2 = 40,
      water  = 50,
      lava   = 10,
      magma  = 10,
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
      floor_plain = 50,
      liquid_plain = 40,
      liquid_trim = 40,
      floor_trim_sky = 5,
      floor_trim_liquid = 5,
      floor_mixup = 5,
    },

    ceiling_sinks =
    {
      ceiling_plain = 50,
      --sky_plain = 50,
      --sky_ceiling = 50,
      light_plain = 25,
    },

    fences =
    {
      SQPEB1 = 20,
      GRSTNPB = 20,
    },

    cage_mats =
    {
      SQPEB1 = 20,
      GRSTNPB = 20,
    },

    facades =
    {
      RCKSNMUD = 40,
      BRWNRCKS = 30,
      TRISTON1 = 20,
      LOOSERCK = 40,
      SNDBLCKS = 30,
      CSTLRCK = 20,
      GRSTNPB = 20,
      METL2 = 10,
      SQPEB1 = 20,
      TRISTON2 = 10,
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
      torches1 = 50,
    },

    maw_torches =
    {
      fire_brazier  = 20,
      wall_torch   = 70,
      mercury_lamp  = 10,
    },

    outdoor_torches =
    {
      fire_brazier   = 10,
      mercury_lamp  = 40,
    },

--    ceil_light_prob = 70,

    scenic_fences =
    {
      WDGAT64 = 50,
    },

    sink_style =
    {
      sharp = 1,
      curved = 0.1,
    },

    steps_mat = "SQPEB1",

    post_mat  = "WOODWL",

  },

}


HERETIC.ROOM_THEMES =
{

  ---- CITY THEME --------------------------------
  -- Combos observed during Episode 1,


  city_Floor03_Floor04 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      GRSTNPB = 50,
      GRSTNPBV = 20,
      WOODWL = 15,
      SKULLSB1 = 5,
    },

    floors =
    {
      FLOOR03 = 50,
      FLOOR04 = 25,
    },

    ceilings =
    {
      FLOOR03 = 50,
      FLOOR04 = 25,
    },
  },

    city_Floor10_Floor12 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      GRSTNPB = 50,
      WOODWL = 25,
      CTYSTCI2 = 10,
      CTYSTUC4 = 10,
    },

    floors =
    {
      FLOOR10 = 50,
    },

    ceilings =
    {
      FLOOR12 = 50,
    },
  },

  city_Floor06_Floor11 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      SNDBLCKS = 50,
      SANDSQ2 = 50,
    },

    floors =
    {
      FLOOR06 = 50,
    },

    ceilings =
    {
      FLOOR11 = 50,
    },
  },

  city_Floor04_Floor19 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      SKULLSB1 = 50,
      CHAINSD = 50,
      SANDSQ2 = 25,
    },

    floors =
    {
      FLOOR19 = 50,
      FLOOR04 = 25,
    },

    ceilings =
    {
      FLOOR04 = 50,
      FLOOR19 = 25,
    },
  },

  city_Grstnpb_Misc =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      GRSTNPB = 50,
    },

    floors =
    {
      FLOOR10 = 50,
      FLOOR00 = 25,
      FLOOR04 = 25,
      METL1 = 15,
    },

    ceilings =
    {
      FLOOR00 = 50,
      FLOOR19 = 25,
      FLOOR03 = 25,
    },
  },

  city_Sndblcks_Misc =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      SNDBLCKS = 50,
    },

    floors =
    {
      METL1 = 15,
      FLOOR06 = 50,
    },

    ceilings =
    {
      FLOOR11 = 50,
      FLOOR25 = 50,
    },
  },

  city_Grstnpbv_Misc =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      GRSTNPBV = 50,
    },

    floors =
    {
      FLOOR06 = 50,
    },

    ceilings =
    {
      FLOOR04 = 50,
    },
  },

  city_Spine2_Misc =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      SPINE2 = 50,
    },

    floors =
    {
      FLOOR04 = 50,
    },

    ceilings =
    {
      FLOOR25 = 50,
    },
  },

  city_deuce_Hallway_Floor03 =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      GRSTNPB = 50,
      GRSTNPBV = 50,
      WOODWL = 20,
    },

    floors =
    {
      FLOOR03 = 50,
    },

    ceilings =
    {
      FLOOR03 = 50,
    },

  },

  city_vent_Hallway_Floor03 =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      GRSTNPB = 50,
      GRSTNPBV = 50,
      WOODWL = 20,
    },

    floors =
    {
      FLOOR03 = 50,
    },

    ceilings =
    {
      FLOOR03 = 50,
    },

  },

  city_deuce_Hallway_Floor04 =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      GRSTNPB = 50,
      GRSTNPBV = 50,
    },

    floors =
    {
      FLOOR04 = 50,
    },

    ceilings =
    {
      FLOOR04 = 50,
    },

  },

  city_vent_Hallway_Floor04 =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      GRSTNPB = 50,
      GRSTNPBV = 50,
    },

    floors =
    {
      FLOOR04 = 50,
    },

    ceilings =
    {
      FLOOR04 = 50,
    },

  },

    city_deuce_Hallway_Sndchnks =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 15,

    walls =
    {
      SNDCHNKS = 50,
    },

    floors =
    {
      FLOOR06 = 50,
    },

    ceilings =
    {
      FLOOR06 = 20,
    },

  },

  city_vent_Hallway_Sndcnks =
  {
    env   = "hallway",
    group = "vent",
    prob  = 15,

    walls =
    {
      SNDCHNKS = 50,
    },

    floors =
    {
      FLOOR06 = 50,
    },

    ceilings =
    {
      FLOOR06 = 20,
    },

  },

  city_Outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      FLOOR00 = 50,
      FLOOR04 = 50,
      FLOOR01 = 50,
      FLOOR10 = 50,
    },

    naturals =
    {
      FLOOR17 = 50,
      FLOOR27 = 50,
    },

    porch_floors =
    {
      FLOOR00 = 50,
      FLOOR04 = 50,
      FLOOR01 = 50,
      FLOOR10 = 50,
      FLOOR19 = 10,
    },

  },

  --------- MAW THEME -------------
  -- Combos observed during Episode 2,

  maw_Looserck =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      LOOSERCK = 50,
    },

    floors =
    {
      FLAT516 = 50,
      FLAT510 = 50,
      FLOOR04 = 50,
      FLOOR01 = 50,
      FLAT521 = 50,
    },

    ceilings =
    {
      FLAT509 = 50,
      FLOOR01 = 50,
      FLAT510 = 50,
    },

  },

  maw_Lava1 =
  {
    env  = "building",
    prob = 30,

    walls =
    {
      LAVA1 = 50,
    },

    floors =
    {
      FLOOR04 = 50,
      FLAT510 = 50,
      FLAT521 = 50,
    },

    ceilings =
    {
      FLAT509 = 50,
      FLOOR04 = 50,
      FLAT510 = 50,
    },

  },

  maw_Misc =
  {
    env  = "building",
    prob = 15,

    walls =
    {
      GRSTNPB = 50,
      GRSTNPBV = 25,
    },

    floors =
    {
      FLOOR04 = 50,
      FLAT510 = 50,
    },

    ceilings =
    {
      FLAT509 = 50,
      FLOOR04 = 50,
    },

  },

  maw_deuce_Hallway_Looserck =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      LOOSERCK = 50,
    },

    floors =
    {
      FLAT516 = 50,
    },

    ceilings =
    {
      FLAT509 = 50,
    },

  },

  maw_vent_Hallway_Looserck =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      LOOSERCK = 50,
    },

    floors =
    {
      FLAT516 = 50,
    },

    ceilings =
    {
      FLAT509 = 50,
    },

  },

  maw_deuce_Hallway_Grstnpb =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      GRSTNPB = 50,
      GRSTNPBV = 25,
    },

    floors =
    {
      FLOOR04 = 50,
    },

    ceilings =
    {
      FLOOR04 = 50,
    },

  },

  maw_vent_Hallway_Grstnpb =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      GRSTNPB = 50,
      GRSTNPBV = 25,
    },

    floors =
    {
      FLOOR04 = 50,
    },

    ceilings =
    {
      FLOOR04 = 50,
    },

  },

  maw_deuce_Hallway_Lava1 =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      LAVA1 = 50,
    },

    floors =
    {
      FLAT510 = 50,
    },

    ceilings =
    {
      FLAT509 = 50,
    },

  },

  maw_vent_Hallway_Lava1 =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      LAVA1 = 50,
    },

    floors =
    {
      FLAT510 = 50,
    },

    ceilings =
    {
      FLAT509 = 50,
    },

  },


  maw_Outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      FLAT516 = 20,
    },

    naturals =
    {
      FLAT516 = 20,
      FLAT517 = 20,
    },

    porch_floors =
    {
      FLOOR04 = 20,
      FLOOR01 = 20,
      FLAT503 = 20,
      FLAT521 = 20,
    },

  },

  --------- DOME THEME -------------
  -- Combos observed during Episode 3,


  dome_Grstnpb =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      GRSTNPB = 50,
    },

    floors =
    {
      FLAT503 = 50,
      FLAT523 = 50,
      FLAT521 = 50,
    },

    ceilings =
    {
      FLAT503 = 50,
      FLOOR27 = 50,
      FLAT521 = 50,
    },

  },

  dome_Grnblok1 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      GRNBLOK1 = 50,
    },

    floors =
    {
      FLAT522 = 50,
      FLAT503 = 50,
    },

    ceilings =
    {
      FLAT520 = 50,
      FLAT522 = 50,
      FLAT506 = 50,
    },

  },

  dome_Cstlrck =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      CSTLRCK = 50,
    },

    floors =
    {
      FLOOR04 = 50,
      FLOOR27 = 50,
      FLAT523 = 50,
    },

    ceilings =
    {
      FLOOR04 = 50,
      FLAT504 = 50,
    },

  },

  dome_Spine2_Sndplain =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      SPINE2 = 50,
      SNDPLAIN = 25,
    },

    floors =
    {
      FLAT522 = 50,
      FLAT521 = 50,
    },

    ceilings =
    {
      FLAT522 = 50,
      FLOOR01 = 50,
      FLAT521 = 50,
    },

  },

  dome_Triston1 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      TRISTON1 = 50,
    },

    floors =
    {
      FLAT507 = 50,
      FLAT523 = 50,
    },

    ceilings =
    {
      FLAT508 = 50,
      FLAT521 = 50,
    },

  },

  dome_Mosaic =
  {
    env  = "building",
    prob = 15,

    walls =
    {
      MOSAIC1 = 50,
      MOSAIC3 = 50,
    },

    floors =
    {
      FLAT504 = 50,
      FLAT502 = 50,
      FLOOR04 = 50,
      FLTWAWA1 = 5,
    },

    ceilings =
    {
      FLAT502 = 50,
      FLAT504 = 50,
      FLOOR07 = 50,
    },

  },

  dome_deuce_Hallway_Grstnpb =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      GRSTNPB = 50,
    },

    floors =
    {
      FLAT503 = 50,
      FLAT523 = 50,
    },

    ceilings =
    {
      FLAT503 = 50,
      FLOOR27 = 50,
    },

  },

  dome_vent_Hallway_Grstnpb =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      GRSTNPB = 50,
    },

    floors =
    {
      FLAT503 = 50,
      FLAT523 = 50,
    },

    ceilings =
    {
      FLAT503 = 50,
      FLOOR27 = 50,
    },

  },

  dome_deuce_Hallway_Grnblok1 =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 25,

    walls =
    {
      GRNBLOK1 = 50,
    },

    floors =
    {
      FLAT522 = 50,
    },

    ceilings =
    {
      FLAT522 = 50,
    },

  },

  dome_vent_Hallway_Grnblok1 =
  {
    env   = "hallway",
    group = "vent",
    prob  = 25,

    walls =
    {
      GRNBLOK1 = 50,
    },

    floors =
    {
      FLAT522 = 50,
    },

    ceilings =
    {
      FLAT522 = 50,
    },

  },

  dome_deuce_Hallway_Sndplain =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 25,

    walls =
    {
      SNDPLAIN = 50,
    },

    floors =
    {
      FLAT521 = 50,
    },

    ceilings =
    {
      FLAT521 = 50,
    },

  },

  dome_vent_Hallway_Sndplain =
  {
    env   = "hallway",
    group = "vent",
    prob  = 25,

    walls =
    {
      SNDPLAIN = 50,
    },

    floors =
    {
      FLAT521 = 50,
    },

    ceilings =
    {
      FLAT521 = 50,
    },

  },

  dome_Outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      FLAT503 = 20,
      FLAT523 = 20,
      FLOOR04 = 20,
      FLOOR05 = 20,
    },

    naturals =
    {
      FLTWAWA1 = 20,
    },

    porch_floors =
    {
      FLAT503 = 20,
      FLAT523 = 20,
      FLOOR04 = 20,
      FLOOR05 = 20,
    },

  },

------- OSSUARY THEME -------
-- Combos observed during Episode 4,

   ossuary_Grstnpb =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      GRSTNPB = 50,
    },

    floors =
    {
      FLAT503 = 50,
      FLAT523 = 50,
      FLOOR10 = 50,
      FLAT521 = 50,
      FLOOR03 = 50,
    },

    ceilings =
    {
      FLAT522 = 50,
      FLAT504 = 50,
      FLOOR10 = 50,
      FLOOR03 = 50,
    },

  },

   ossuary_Spine2 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      SPINE2 = 50,
    },

    floors =
    {
      FLOOR19 = 50,
      FLOOR25 = 50,
    },

    ceilings =
    {
      FLAT522 = 50,
      FLAT523 = 50,
    },

  },

   ossuary_Chainsd =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      CHAINSD = 50,
    },

    floors =
    {
      FLAT503 = 50,
      FLAT504 = 50,
      FLOOR19 = 50,
    },

    ceilings =
    {
      FLAT522 = 50,
      FLAT504 = 50,
    },

  },

   ossuary_Cstlrck =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      CSTLRCK = 50,
    },

    floors =
    {
      FLAT522 = 50,
      FLAT521 = 50,
    },

    ceilings =
    {
      FLAT523 = 50,
      FLAT507 = 50,
      FLOOR12 = 50,
    },

  },

   ossuary_Metl2 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      METL2 = 50,
    },

    floors =
    {
      FLOOR28 = 50,
      FLAT521 = 50,
    },

    ceilings =
    {
      FLAT512 = 50,
      FLAT504 = 50,
      FLOOR29 = 50,
    },

  },

   ossuary_Grnblok =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      GRNBLOK1 = 50,
      GRNBLOK2 = 10,
    },

    floors =
    {
      FLOOR25 = 50,
      FLAT521 = 50,
      FLOOR19 = 50,
    },

    ceilings =
    {
      FLAT521 = 50,
      FLAT522 = 50,
    },

  },

   ossuary_Triston2_Sndplain =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      TRISTON2 = 50,
      SNDPLAIN = 50,
    },

    floors =
    {
      FLAT523 = 50,
      FLAT522 = 50,
    },

    ceilings =
    {
      FLAT523 = 50,
      FLAT503 = 50,
    },

  },

   ossuary_Triston1 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      TRISTON1 = 50,
    },

    floors =
    {
      FLOOR19 = 50,
      FLOOR28 = 50,
    },

    ceilings =
    {
      FLAT523 = 50,
      FLOOR28 = 50,
    },

  },

   ossuary_Grstnpbv =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      GRSTNPBV = 50,
    },

    floors =
    {
      FLAT523 = 50,
      FLAT504 = 50,
    },

    ceilings =
    {
      FLAT523 = 50,
      FLAT522 = 50,
    },

  },

   ossuary_Metl1 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      METL1 = 50,
    },

    floors =
    {
      FLAT523 = 50,
    },

    ceilings =
    {
      FLOOR29 = 50,
    },

  },

   ossuary_Woodwl =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      WOODWL = 50,
    },

    floors =
    {
      FLOOR10 = 50,
    },

    ceilings =
    {
      FLOOR11 = 50,
    },

  },

  ossuary_deuce_Hallway_Cstlrck =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      CSTLRCK = 50,
    },

    floors =
    {
      FLAT522 = 50,
    },

    ceilings =
    {
      FLAT523 = 50,
    },

  },

  ossuary_vent_Hallway_Cstlrck =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      CSTLRCK = 50,
    },

    floors =
    {
      FLAT522 = 50,
    },

    ceilings =
    {
      FLAT523 = 50,
    },

  },

  ossuary_deuce_Hallway_Grstnpb =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      GRSTNPB = 50,
    },

    floors =
    {
      FLAT521 = 50,
    },

    ceilings =
    {
      FLOOR19 = 50,
    },

  },

  ossuary_vent_Hallway_Grstnpb =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      GRSTNPB = 50,
    },

    floors =
    {
      FLAT521 = 50,
    },

    ceilings =
    {
      FLOOR19 = 50,
    },

  },

  ossuary_deuce_Hallway_Sndplain =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      SNDPLAIN = 50,
    },

    floors =
    {
      FLAT522 = 50,
    },

    ceilings =
    {
      FLAT503 = 50,
    },

  },

  ossuary_vent_Hallway_Sndplain =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      SNDPLAIN = 50,
    },

    floors =
    {
      FLAT522 = 50,
    },

    ceilings =
    {
      FLAT503 = 50,
    },

  },

  ossuary_deuce_Hallway_Woodwl =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      WOODWL = 50,
    },

    floors =
    {
      FLOOR10 = 50,
      FLAT523 = 50,
    },

    ceilings =
    {
      FLOOR11 = 50,
      FLOOR10 = 50,
    },

  },

  ossuary_vent_Hallway_Woodwl =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      WOODWL = 50,
    },

    floors =
    {
      FLOOR10 = 50,
      FLAT523 = 50,
    },

    ceilings =
    {
      FLOOR11 = 50,
      FLOOR10 = 50,
    },

  },

  ossuary_Outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      FLOOR18 = 50,
      FLAT522 = 50,
      FLAT523 = 50,
      SQPEB2 = 25,
    },

    naturals =
    {
      FLOOR17 = 50,
    },

    porch_floors =
    {
      FLOOR18 = 50,
      FLAT522 = 50,
      FLAT523 = 50,
      SQPEB2 = 25,
    },

  },


--------- DEMENSE THEME -------------
-- Combos observed during Episode 5,

  demense_Sqpeb2 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      SQPEB2 = 50,
    },

    floors =
    {
      FLOOR01 = 50,
      FLOOR05 = 50,
    },

    ceilings =
    {
      FLOOR05 = 50,
    },

  },

  demense_Mossrck1 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      MOSSRCK1 = 50,
    },

    floors =
    {
      FLOOR01 = 50,
      FLAT523 = 50,
      FLOOR10 = 50,
    },

    ceilings =
    {
      FLOOR01 = 50,
      FLAT522 = 50,
      FLAT521 = 50,
    },

  },

  demense_Looserck =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      LOOSERCK = 50,
    },

    floors =
    {
      FLOOR03 = 50,
    },

    ceilings =
    {
      FLOOR01 = 50,
      FLOOR03 = 50,
    },

  },

  demense_Sndplain =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      SNDPLAIN = 50,
    },

    floors =
    {
      FLOOR06 = 50,
      FLOOR19 = 50,
    },

    ceilings =
    {
      FLAT503 = 50,
    },

  },

  demense_Cstlrck =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      CSTLRCK = 50,
    },

    floors =
    {
      FLAT521 = 50,
      FLAT523 = 50,
      FLOOR19 = 50,
      FLOOR28 = 50,
    },

    ceilings =
    {
      FLAT521 = 50,
      FLAT522 = 50,
      FLOOR04 = 50,
    },

  },

  demense_Grskull_Chainsd =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      GRSKULL1 = 50,
      GRSKULL2 = 50,
      CHAINSD = 50,
    },

    floors =
    {
      FLAT521 = 50,
      FLAT523 = 50,
    },

    ceilings =
    {
      FLAT522 = 50,
      FLAT521 = 50,
    },

  },

  demense_Spine2_Sndchnks =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      SPINE2 = 50,
      SNDCHNKS = 50,
    },

    floors =
    {
      FLAT522 = 50,
      FLAT523 = 50,
    },

    ceilings =
    {
      FLAT523 = 50,
      FLOOR19 = 50,
    },

  },

  demense_Triston1 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      TRISTON1 = 50,
    },

    floors =
    {
      FLOOR19 = 50,
    },

    ceilings =
    {
      FLOOR19 = 50,
    },

  },

  demense_Sqpeb1 =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      SQPEB1 = 50,
    },

    floors =
    {
      FLOOR17 = 50,
    },

    ceilings =
    {
      FLOOR27 = 50,
    },

  },

  demense_Grstnpb =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      GRSTNPB = 50,
    },

    floors =
    {
      FLAT523 = 50,
    },

    ceilings =
    {
      FLAT503 = 50,
    },

  },

  demense_deuce_Hallway_Sqpeb1 =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      SQPEB1 = 50,
    },

    floors =
    {
      FLOOR17 = 50,
      FLAT523 = 50,
    },

    ceilings =
    {
      FLOOR27 = 50,
      FLAT523 = 50,
    },

  },

  demense_vent_Hallway_Sqpeb1 =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      SQPEB1 = 50,
    },

    floors =
    {
      FLOOR17 = 50,
      FLAT523 = 50,
    },

    ceilings =
    {
      FLOOR27 = 50,
      FLAT523 = 50,
    },

  },

  demense_deuce_Hallway_Sndplain_Sndblcks =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      SNDPLAIN = 50,
      SNDBLCKS = 50,
    },

    floors =
    {
      FLAT523 = 50,
      FLOOR06 = 50,
      FLOOR19 = 50,
    },

    ceilings =
    {
      FLAT503 = 50,
      FLAT521 = 50,
    },

  },

  demense_vent_Hallway_Sndplain_Sndblcks =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      SNDPLAIN = 50,
      SNDBLCKS = 50,
    },

    floors =
    {
      FLAT523 = 50,
      FLOOR06 = 50,
      FLOOR19 = 50,
    },

    ceilings =
    {
      FLAT503 = 50,
      FLAT521 = 50,
    },

  },

  demense_deuce_Hallway_Metl2 =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      METL2 = 50,
    },

    floors =
    {
      FLAT523 = 50,
      FLAT522 = 50,
      FLOOR28 = 50,
    },

    ceilings =
    {
      FLAT523 = 50,
      FLAT521 = 50,
    },

  },

  demense_vent_Hallway_Metl2 =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      METL2 = 50,
    },

    floors =
    {
      FLAT523 = 50,
      FLAT522 = 50,
      FLOOR28 = 50,
    },

    ceilings =
    {
      FLAT523 = 50,
      FLAT521 = 50,
    },

  },

  demense_deuce_Hallway_Cstlrck_Grstnpb =
  {
    env   = "hallway",
    group = "deuce",
    prob  = 50,

    walls =
    {
      CSTLRCK = 50,
      GRSTNPB = 50,
    },

    floors =
    {
      FLAT523 = 50,
    },

    ceilings =
    {
      FLAT523 = 50,
      FLAT504 = 50,
    },

  },

  demense_vent_Hallway_Cstlrck_Grstnpb =
  {
    env   = "hallway",
    group = "vent",
    prob  = 50,

    walls =
    {
      CSTLRCK = 50,
      GRSTNPB = 50,
    },

    floors =
    {
      FLAT523 = 50,
    },

    ceilings =
    {
      FLAT523 = 50,
      FLAT504 = 50,
    },

  },

  demense_Outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      FLAT513 = 50,
      FLOOR04 = 50,
      FLOOR18 = 50,
      FLAT522 = 50,
      FLOOR05 = 50,
    },

    naturals =
    {
      FLAT513 = 20,
      FLOOR27 = 20,
    },

    porch_floors =
    {
      FLOOR19 = 20,
      FLAT523 = 20,
    },

  },


--------- GENERIC ITEMS ----------

  any_Cave =
  {
    env  = "cave",
    prob = 50,

    walls =
    {
      LOOSERCK=20, LAVA1=20, BRWNRCKS=20, ROOTWALL=20,
    },

    floors =
    {
      FLAT516=20, FLAT506=20, FLOOR01=20,
    },
  },

}
------------------------------------------------------------------------


HERETIC.ROOMS =
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


OB_THEMES["city"] =
{
  label = _("City"),
  game = "heretic",
  name_class = "CASTLE",
  mixed_prob = 50,
}

OB_THEMES["maw"] =
{
  label = _("Maw"),
  game = "heretic",
  name_class = "CASTLE",
  mixed_prob = 50,
}

OB_THEMES["dome"] =
{
  label = _("Dome"),
  game = "heretic",
  name_class = "CASTLE",
  mixed_prob = 50,
}

OB_THEMES["ossuary"] =
{
  label = _("Ossuary"),
  game = "heretic",
  name_class = "CASTLE",
  mixed_prob = 50,
}

OB_THEMES["demense"] =
{
  label = _("Demense"),
  game = "heretic",
  name_class = "CASTLE",
  mixed_prob = 50,
}

