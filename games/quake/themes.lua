------------------------------------------------------------------------
--  QUAKE THEMES
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2015 Andrew Apted
--  Copyright (C)      2011 Reisal
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

QUAKE.SINKS =
{
  -- sky holes --

  sky_plain =
  {
    mat   = "_SKY",
    dz    = 64,
  },

  -- liquid floor --

  liquid_plain =
  {
    mat = water,
    dz  = -12
  },

  -- street sink def, do not use for anything else
  floor_default_streets =
  {
    mat = "GROUND1_1",
    dz = 2,
  
    trim_mat = "GROUND1_1",
    trim_dz = 2,
  }
}


QUAKE.THEMES =
{
  DEFAULTS =
  {
    keys =
    {
      k_silver = 60,
      k_gold   = 20,
    },

    fences =
    {
      ROCK5_2 = 50,
    },

    cage_lights = { 0, 8, 12, 13 },

    pool_depth = 24,

    skyboxes = 
    {

    }

  },


  q1_tech =
  {
    worldtype = 2,

    skies =
    {
      sky4 = 80,
      sky1 = 20,
    },

    liquids =
    {
      slime0 = 25,
      slime  = 50,
    },

    narrow_halls =
    {
      vent = 50
    },

    wide_halls =
    {
      curve = 50
    },

    floor_sinks =
    {
      liquid_plain = 50
    },

    ceiling_sinks =
    {
      sky_plain = 50
    },

    fences =
    {
      TECH14_2 = 50,
    },

    cage_mats =
    {
      TECH14_2 = 50,
    },

    facades =
    {
      TECH14_2 = 50,
    },

    fence_groups =
    {
      PLAIN = 50
    },

    fence_posts =
    {
      Post = 50
    },

    beam_groups =
    {
      beam_metal = 50
    },

    window_groups =
    {
      straddle = 70,
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
      CLIP_RAIL = 50
    },

    sink_style =
    {
      sharp = 1,
      curved = 0.1
    },

    steps_mat = "TECH14_2",

    post_mat  = "TECH14_2"
  },


  q1_castle =
  {
    worldtype = 0,

    skies =
    {
      sky1 = 80,
      sky4 = 20,
    },

    liquids =
    {
      lava1 = 50,
    },

    narrow_halls =
    {
      vent = 50
    },

    wide_halls =
    {
      curve = 50
    },

    floor_sinks =
    {
      liquid_plain = 50
    },

    ceiling_sinks =
    {
      sky_plain = 50
    },

    fences =
    {
      BRICKA2_4 = 50,
    },

    cage_mats =
    {
      BRICKA2_4 = 50,
    },

    facades =
    {
      BRICKA2_4 = 50,
    },  

    fence_groups =
    {
      PLAIN = 50
    },

    fence_posts =
    {
      Post = 50
    },

    beam_groups =
    {
      beam_metal = 50
    },

    window_groups =
    {
      straddle = 70,
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
      CLIP_RAIL = 50
    },

    sink_style =
    {
      sharp = 1,
      curved = 0.1
    },

    steps_mat = "BRICKA2_4",

    post_mat  = "BRICKA2_4"
  },
}


QUAKE.ROOM_THEMES =
{
  any_Hallway =
  {
    env = "hallway",
    prob = 50,

    walls =
    {
      WOOD1_5 = 30,
    },

    floors =
    {
      WOODFLR1_5 = 50,
    },

    ceilings =
    {
      WOODFLR1_4 = 50,
    },
  },

  any_curve_Hallway =
  {
    env = "hallway",
    group = "curve",
    prob = 50,

    walls =
    {
      WOOD1_5 = 30,
    },

    floors =
    {
      WOODFLR1_5 = 50,
    },

    ceilings =
    {
      WOODFLR1_4 = 50,
    },
  },

  any_vent_Hallway =
  {
    env = "hallway",
    group = "vent",
    prob = 50,

    walls =
    {
      WOOD1_5 = 30,
    },

    floors =
    {
      WOODFLR1_5 = 50,
    },

    ceilings =
    {
      WOODFLR1_4 = 50,
    },
  },


  ----- TECH BASE ----------------------------------

  q1_tech_Generic =
  {
    env = "building",
    prob = 50,

    walls =
    {
      TECH06_1=50, TECH08_2=50, TECH09_3=50, TECH08_1=50,
      TECH13_2=50, TECH14_1=50, TWALL1_4=50, TECH14_2=50,
      TWALL2_3=50, TECH03_1=50, TECH05_1=50,
    },

    floors =
    {
      FLOOR01_5=50, METAL2_4=50, METFLOR2_1=50, MMETAL1_1=50,
      SFLOOR4_1=50, SFLOOR4_5=50, SFLOOR4_6=50, SFLOOR4_7=50,
      WIZMET1_2=50, MMETAL1_6=50, MMETAL1_7=50, MMETAL1_8=50,
      WMET4_5=50, WMET1_1=50,
    },

    ceilings =
    {
      FLOOR01_5=50, METAL2_4=50, METFLOR2_1=50, MMETAL1_1=50,
      SFLOOR4_1=50, SFLOOR4_5=50, SFLOOR4_6=50, SFLOOR4_7=50,
      WIZMET1_2=50, MMETAL1_6=50, MMETAL1_7=50, MMETAL1_8=50,
      WMET4_5=50, WMET1_1=50,
    },
  },


  -- TODO : these are duplicate of castle ones -- make them distinct

  q1_tech_Cave =
  {
    env = "cave",
    prob = 50,

    floors =
    {
      ROCK1_2=10, ROCK5_2=40, ROCK3_8=20,
      WALL11_2=10, GROUND1_6=10, GROUND1_7=10,
      GRAVE01_3=10, WSWAMP1_2=20,
    },

    walls =
    {
      ROCK1_2=10, ROCK5_2=40, ROCK3_8=20,
      WALL11_2=10, GROUND1_6=10, GROUND1_7=10,
      GRAVE01_3=10, WSWAMP1_2=20,
    },
  },


  q1_tech_Outdoors =
  {
    env = "outdoor",
    prob = 50,

    floors =
    {
      CITY4_6=30, CITY6_7=30,
      CITY4_5=30, CITY4_8=30, CITY6_8=30,
      WALL14_6=20, CITY4_1=30, CITY4_2=30, CITY4_7=30,
    },

    naturals =
    {
      GROUND1_2=50, GROUND1_5=50, GROUND1_6=20,
      GROUND1_7=30, GROUND1_8=20,
      ROCK3_7=50, ROCK3_8=50, ROCK4_2=50,
      VINE1_2=50,
    },

    porch_floors = 
    {
      CITY4_6=30, CITY6_7=30,
      CITY4_5=30, CITY4_8=30, CITY6_8=30,
      WALL14_6=20, CITY4_1=30, CITY4_2=30, CITY4_7=30,
    },
  },


  ----- CASTLE ----------------------------------

  q1_castle_Generic =
  {
    env = "building",
    prob = 50,

    walls =
    {
      BRICKA2_4=30, CITY5_4=30, WALL14_5=30, CITY1_4=30, METAL4_4=20, METALT1_1=15,
      CITY5_8=40, CITY5_7=50, CITY6_3=50, CITY6_4=50, METAL4_3=20, METALT2_2=5,
      CITY2_1=30, CITY2_2=30, CITY2_3=30, CITY2_5=30, METAL4_2=15, METALT2_3=20,
      CITY2_6=30, CITY2_7=30, CITY2_8=30, CITY6_7=20, METAL4_7=20, METALT2_6=5,
      CITY8_2=30, WALL3_4=30, WALL5_4=30, WBRICK1_5=30, METAL4_8=20, METALT2_7=20, WMET4_8=15,
      WIZ1_4=30, WSWAMP1_4=30, WSWAMP2_1=30, WSWAMP2_2=30, ALTARC_1=20, WMET4_3=15, WMET4_7=15,
      WWALL1_1=30, WALL3_4=30, ALTAR1_3=20, ALTAR1_6=5, ALTAR1_7=20, WMET4_4=15, WMET4_6=15,
    },

    floors =
    {
      AFLOOR1_4=50, AFLOOR3_1=25, AZFLOOR1_1=20, ROCK3_8=20, METAL5_4=30, FLOOR01_5=30,
      CITY4_1=15, CITY4_2=25, CITY4_5=15, CITY4_6=20, ROCK3_7=20, METAL5_2=30, MMETAL1_2=15,
      CITY4_7=15, CITY4_8=15, CITY5_1=30, CITY5_2=30, WALL3_4=30, CITY6_8=20,
      CITY8_2=20, GROUND1_8=20, ROCK3_7=20, AFLOOR1_3=20, BRICKA2_4=30, WALL9_8=30,
      AFLOOR1_8=20, WOODFLR1_5=20, BRICKA2_1=30, BRICKA2_2=30, CITY6_7=20, WOODFLR1_5=30,
    },

    ceilings =
    {
      DUNG01_4=50, DUNG01_5=50, ECOP1_8=50, ECOP1_4=50, ECOP1_6=50, WSWAMP1_4=30,
      WIZMET1_1=50, WIZMET1_4=50, WIZMET1_6=50, WIZMET1_7=50, WIZ1_1=50, WSWAMP2_1=30,
      GRAVE01_1=50, GRAVE01_3=50, GRAVE03_2=50, WALL3_4=30, WALL5_4=30, WALL11_2=20,
      WSWAMP2_2=30, WBRICK1_5=30, WIZ1_4=20, COP1_1=30, COP1_2=30, COP1_8=30, COP2_2=30,
      MET5_1=20, METAL1_1=20, METAL1_2=20, METAL1_3=20, WMET1_1=15,
    },
  },


  q1_castle_Outdoors =
  {
    env = "outdoor",
    prob = 50,

    floors =
    {
      CITY4_6=30, CITY6_7=30,
      CITY4_5=30, CITY4_8=30, CITY6_8=30,
      WALL14_6=20, CITY4_1=30, CITY4_2=30, CITY4_7=30,
    },

    naturals =
    {
      GROUND1_2=50, GROUND1_5=50, GROUND1_6=20,
      GROUND1_7=30, GROUND1_8=20,
      ROCK3_7=50, ROCK3_8=50, ROCK4_2=50,
      VINE1_2=50,
    },

    porch_floors = 
    {
      CITY4_6=30, CITY6_7=30,
      CITY4_5=30, CITY4_8=30, CITY6_8=30,
      WALL14_6=20, CITY4_1=30, CITY4_2=30, CITY4_7=30,
    },

  },


  q1_castle_Cave =
  {
    env = "cave",
    prob = 50,

    floors =
    {
      ROCK1_2=10, ROCK5_2=40, ROCK3_8=20,
      WALL11_2=10, GROUND1_6=10, GROUND1_7=10,
      GRAVE01_3=10, WSWAMP1_2=20,
    },

    walls =
    {
      ROCK1_2=10, ROCK5_2=40, ROCK3_8=20,
      WALL11_2=10, GROUND1_6=10, GROUND1_7=10,
      GRAVE01_3=10, WSWAMP1_2=20,
    },
  },
}


------------------------------------------------------------------------

QUAKE.NAMES =
{
  -- TODO
}


QUAKE.ROOMS =
{
  GENERIC =
  {
    env = "any"
  },

  OUTSIDE =
  {
    env = "outdoor",
    prob = 50
  }

}


------------------------------------------------------------------------


OB_THEMES["q1_tech"] =
{
  label = _("Tech"),
  game = "quake",
  name_theme = "TECH",
  mixed_prob = 50,
}


OB_THEMES["q1_castle"] =
{
  label = _("Castle"),
  game = "quake",
  name_theme = "URBAN",
  mixed_prob = 50,
}

