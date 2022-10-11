------------------------------------------------------------------------
--  BASE FILE for DOOM, DOOM II (etc)
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C) 2011,2014, 2022 Armaetus
--
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

DOOM.FACTORY = { }

DOOM.FACTORY.DM_LINE_TYPES =
{
  --- general ---

  A1_scroll_left = { kind=48 },

  S1_exit = { kind=11 },
  W1_exit = { kind=52 },

  S1_secret_exit = { kind=51  },
  W1_secret_exit = { kind=124 },
  
  WR_teleport = { kind=97  },
  MR_teleport = { kind=126 },  -- monster only

  S1_bars = { kind=23 },

  --- doors ---

  PR_door = { kind=1 },
  PR_blaze_door = { kind=117 },

  W1_door = { kind=2 },
  S1_door = { kind=103 },

  SR_door = { kind=63 },
  SR_blaze_door = { kind=114 },

  P1_blue_door   = { kind=32 },
  PR_blue_door   = { kind=26 },
  P1_yellow_door = { kind=34 },
  PR_yellow_door = { kind=27 },
  P1_red_door    = { kind=33 },
  PR_red_door    = { kind=28 },

  --- lifts ---

  SR_lift = { kind=62 },
  WR_lift = { kind=88 },

  SR_blaze_lift = { kind=123 },
  WR_blaze_lift = { kind=120 },
}

DOOM.FACTORY.DM_SECTOR_TYPES =
{
  secret = { kind=9 },

  random_off = { kind=1 },
  blink_fast = { kind=2 },
  blink_slow = { kind=3 },

  glow    = { kind=8 },
  flicker = { kind=17 },

  damage_5  = { kind=7 },
  damage_10 = { kind=5 },
  damage_20 = { kind=16 },
}


----------------------------------------------------------------

DOOM.FACTORY.DM_COMBOS =
{
  ---- TECH ------------

  TECH_BASE =
  {
    theme_probs = { TECH=80 },
    mat_pri = 8,

    wall  = "STARTAN3",
    floor = "FLOOR4_8",
    ceil  = "CEIL3_6",

    pic_wd = "COMPSTA2",    -- "COMP2" for Doom 1 !!
    pic_wd_h = 64,

    lift = "PLAT1",
    step = "STEP1",
    step_floor = "STEP2",

    scenery = "lamp",
    good_liquid = "blood",

    sc_fabs = { pillar_COMPWERD=50, other=30 },
  },

  TECH_BASE2 =
  {
    theme_probs = { TECH=40 }, 
    mat_pri = 8,

    wall  = "STARG3",
    floor = "FLOOR5_1",
    ceil  = "FLOOR4_5",

    lift = "PLAT1",
    step = "STEP1",
    step_floor = "STEP1",

    scenery = "tech_column",

    sc_fabs = { pillar_COMPWERD=50, other=30 },
  },

  TECH_SILVER =
  {
    theme_probs = { TECH=40 },
    mat_pri = 8,

    wall  = "STARGR2",
    floor = "FLOOR0_1",
    ceil  = "FLAT3",

    lift = "PLAT1",
    step = "STEP1",
    step_floor = "STEP1",

    scenery = "tech_column",
  },

  TECH_BROWN =
  {
    theme_probs = { TECH=60 },
    mat_pri = 8,

    wall  = "STARBR2",
    floor = "FLOOR5_1",
    ceil  = "CEIL4_3",

    lift = "PLAT1",
    step = "STEP1",
    step_floor = "STEP1",

    scenery = "tech_column",
  },

  ---- HELL ----------

  HELL_MARBLE =
  {
    theme_probs = { HELL=70 },
    mat_pri = 6,

    wall = "MARBLE2",
    void = "SP_DUDE5",
    step = "STEP1",
    pic_wd  = "SP_DUDE1",

    lift = "SKSPINE1",
    lift_floor = "FLAT5_6",

    floor = "FLOOR7_2",
    ceil = "FLOOR7_1",

    scenery = { red_pillar=5, red_column=5, red_column_skl=5 },

    bad_liquid = "nukage",
    good_liquid = "blood",

    sc_fabs = { pillar_GSTLION=50, other=30 },
  },

  HELL_HOT =
  {
    theme_probs = { HELL=60 },
    mat_pri = 6,

    wall = "SP_HOT1",
    step = "STEP6",  -- STEP4

    floor = "FLAT5_1",  -- was: FLAT5_7
    ceil  = "FLAT5_3",  -- was: FLOOR6_1

    lift = "SKSPINE1",
    lift_floor = "FLAT5_6",

    scenery = "red_torch",

    bad_liquid = "blood",
    good_liquid = "lava",
  },

  HELL_VINE =
  {
    theme_probs = { HELL=20 },
    mat_pri = 1,

    wall  = "GSTVINE1",
    floor = "SFLR6_1",
    ceil  = "FLOOR7_1",

    step = "STONE3",

    lift = "SKSPINE1",
    lift_floor = "FLAT5_6",

    scenery = "red_torch",
  },

  ---- URBAN --------

  URBAN_STONE =
  {
    theme_probs = { URBAN=70 },
    outdoor = true,
    mat_pri = 5,

    wall  = "STONE",
    floor = "MFLR8_1",
    ceil  = "MFLR8_1",

--  void = "STONE3",
    step = "STEP4",
    piller = "STONE5",

    scenery = { blue_torch=5, blue_torch_sm=3 },

    door_probs = { out_diff=75, combo_diff=10, normal=5 }
  },

  URBAN_BROWN =
  {
    theme_probs = { URBAN=50 },
    outdoor = true,
    mat_pri = 3,

    wall  = "BROWN1",
    floor = "MFLR8_2",  -- "RROCK16" (not in doom 1)
    ceil  = "MFLR8_2",

--  void = "BROWNPIP",
    step = "STEP5",
    lift = "SUPPORT3",
    pillar = "BROWN96",  -- was "BRONZE2" (not in doom 1)

  --  lift_floor = "FLOOR4_8",

    scenery = { skull_pole=5, skull_kebab=5 },
    good_liquid = "blood",

    door_probs = { out_diff=75, combo_diff=10, normal=5 }
  },

  URBAN_WOOD =
  {
    theme_probs = { URBAN=30 },
    mat_pri = 7,

    wall  = "WOOD1",
    floor = "FLAT5_1",
    ceil  = "CEIL1_1",

--  void = "WOOD3",
    step = "STEP1",
    pillar = "WOODGARG", -- "WOODMET4" not in doom 1
    pic_wd = "MARBFACE",

    scenery = { impaled_human=5, hang_twitching=5 },
  },

  ---- INDUSTRIAL --------

  INDY_CEMENT =
  {
    theme_probs = { INDUSTRIAL=50 },
    mat_pri = 1,

    wall  = "CEMENT6",
    floor = "FLAT9",
    ceil  = "CEIL3_5",  -- "SLIME14" not in doom 1

    step = "STEP1",
    pillar = "BROWNGRN",  -- "CEMENT8" not in doom 1

    lift = "SUPPORT3",
--  lift_floor = "FLOOR4_8",

    wall_fabs = { solid_CEMENT4=20, solid_CEMENT5=20, other=50 },
  },

  INDY_SLAD =
  {
    theme_probs = { INDUSTRIAL=50, TECH=10 },
    mat_pri = 4,

    wall  = "SLADWALL",
    floor = "FLOOR0_5",
    ceil  = "CEIL5_1",

--  void = "SLADSKUL",
    step = "STEP1",

    vista_support = "DOORSTOP",

    scenery = "burning_barrel",
    good_liquid = "nukage",

    sc_fabs = { pillar_rnd_sm_POIS=50, other=30 },

    wall_fabs = { solid_SLADSKUL=30, other=50 },
  },

  INDY_GRAY =
  {
    theme_probs = { INDUSTRIAL=50 },
    mat_pri = 3,

    wall  = "GRAY7",
    floor = "FLOOR0_5",
    ceil  = "FLAT1",

    lift = "SUPPORT3",
    pic_wd = "REDWALL",

--  lift_floor = "FLOOR4_8",

    scenery = { green_pillar=5, green_column=5, green_column_hrt=5 },

    sc_fabs = { crate_rotnar_GRAY2=30, other=50 },
  },

  INDY_PIPES =
  {
    theme_probs = { INDUSTRIAL=45 },
    mat_pri = 4,

    wall  = "PIPE2",
    floor = "FLAT1_1",
    ceil  = "FLAT1_1",

    step = "STEP1",
    lift = "SUPPORT3",
    pic_wd = "REDWALL",

--  lift_floor = "FLOOR4_8",

    scenery = { green_pillar=5, green_column=5, green_column_hrt=5 },

    wall_fabs = { solid_PIPE4=20, other=30 },
  },

  INDY_ICKY =
  {
    theme_probs = { INDUSTRIAL=25 },
    mat_pri = 4,

    wall  = "ICKWALL3",
    floor = "FLAT4",
    ceil  = "CEIL3_1", -- CEIL1_3

    step = "STEP4",
    lift = "SUPPORT3",
    pic_wd = "REDWALL",

--  lift_floor = "FLOOR4_8",

    scenery = { green_pillar=5, green_column=5, green_column_hrt=5 },

    wall_fabs = { solid_ICKWALL4=20, solid_ICKWALL5=20,
                  solid_ICKWALL7=20, other=60 },
  },

  ---- CAVE ----------

  CAVE_BROWN =
  {
    theme_probs = { CAVE=50 },
    mat_pri = 3,

    wall  = "BROWNHUG",
    floor = "FLAT10",
    ceil  = "FLAT10",

    arch  = "arch_hole",

    sc_fabs = { stalagmite_MED=90, other=10 },
  },

  -- FIXME: SP_ROCK1

}

DOOM.FACTORY.DM_EXITS =
{
  TECH =
  {
    mat_pri = 9,

    wall  = "TEKWALL1",
    floor = "CEIL4_3",
    ceil  = "TLITE6_5",

    sign = "EXITSIGN",
    sign_ceil="CEIL5_2",

    switch =
    {
      prefab="SWITCH_NICHE",
      add_mode="wall",
      skin =
      {
        switch_w="SW1COMP", switch_h=64,
        lite_w="LITE5",
--      frame_f="FLAT14", frame_c="FLAT14",

        x_offset=0, y_offset=64, kind=11, tag=0,
      }
    },

    door = { wall="EXITDOOR", w=64, h=72,
             frame_ceil="TLITE6_5", -- frame_wall="BROWN96"
           },
  },

  STONE =
  {
    mat_pri = 9,

    wall = "STONE2",
    void = "STONE",

    floor = "FLOOR7_2",
    ceil  = "FLAT1",

    hole_tex = "MARBLE1",
    
    front_mark = "EXITSTON", 

    switch =
    {
      prefab="SWITCH_FLOOR",
      skin =
      {
        switch_w="SW1HOT", side_w="SP_HOT1",
        switch_f="FLAT5_3", switch_h=64,

        x_offset=0, y_offset=56, kind=11, tag=0,
      }
    },

    door = { wall="EXITDOOR", w=64, h=72,
             frame_ceil="TLITE6_6", frame_wall="LITE5" },
  },

  BROWN =
  {
    mat_pri = 6,

    wall = "BROWN96",
    void = "BROWN1",

    floor = "FLOOR3_3",
    ceil  = "CEIL5_2",

    sign = "EXITSIGN",
    sign_ceil="CEIL5_2",

    switch =
    {
      prefab="SWITCH_WIDE",
      add_mode="wall",
      skin =
      {
        switch_w="SW1BRCOM", wall="BROWN96",
        kind=11, tag=0,
      }
    },

    door = { wall="EXITDOOR", w=64, h=72,
             frame_ceil="TLITE6_5",
             frame_floor="FLOOR3_3"
           },
  },

  --- Small Exits ---

  BLUE =
  {
    small_exit = true,
    mat_pri = 9,

    wall = "TEKWALL1",
    floor = "FLAT14",
    ceil  = "FLAT22",

---  void = "COMPBLUE",

    sign = "EXITSIGN",
    sign_ceil="CEIL5_2",

    switch =
    {
      prefab="SWITCH_FLOOR",
      skin =
      {
        switch_w="SW1COMM", side_w="SHAWN2",
        switch_f="FLAT23", switch_h=64,

        x_offset=0, y_offset=0, kind=11, tag=0,
      }
    },


    door = { wall="EXITDOOR", w=64, h=72, frame_ceil="TLITE6_5" },
  },

  STARTAN =
  {
    small_exit = true,
    mat_pri = 6,

    wall  = "STARTAN2",
    floor = "FLOOR5_2",
    ceil  = "TLITE6_4",

    sign = "EXITSIGN",
    sign_ceil="CEIL5_2",

    switch =
    {
      prefab="SWITCH_FLUSH",
      add_mode="wall",
      skin =
      {
        switch_w="SW1STRTN", wall="STARTAN2",
        kind=11, tag=0,
      }
    },

    door = { wall="EXITDOOR", w=64, h=72,
             frame_ceil="TLITE6_5",
             frame_floor="FLOOR5_2",
             frame_wall="LITE3"
           },
  },

  BLOODY =
  {
    secret_exit = true,
    small_exit = true,

    mat_pri = 9,

    exit_h = 128,

    wall  = "GSTVINE2",
    floor = "BLOOD1",
    ceil  = "FLOOR7_2",

--  void = "GSTONE2",

    liquid_prob = 0,

    sign = "EXITSIGN",
    sign_ceil="CEIL5_2",

    flush = true,
    flush_left  = "GSTFONT1",
    flush_right = "GSTFONT2",

    switch =
    {
      prefab="SWITCH_FLUSH",
      add_mode="wall",
      skin =
      {
        switch_w="SW1GSTON", wall="GSTONE2",
        left_w="GSTFONT1", right_w="GSTFONT2",
        kind=51, tag=0,
      }
    },

    door = { wall="EXITDOOR", w=64, h=72,
             frame_ceil="FLOOR7_2",
             frame_floor="FLOOR7_2" },
  },

}

DOOM.FACTORY.DM_HALLWAYS =
{
  BROWN1 =
  {
    mat_pri = 0,

    wall = "BROWNPIP",
    void = "BROWN1",
    step = "BROWN1",
    pillar = "BROVINE2",

    floor = "FLOOR5_1",
    ceil  = "CEIL5_2",

    theme_probs = { INDUSTRIAL=50,URBAN=20 },
    trim_mode = "guillotine",
  },

  SP_ROCK =
  {
    mat_pri = 0,

    wall = "SP_ROCK1",
    void = "SP_ROCK1",
    step = "STEP6",
    pillar = "GRAYVINE",

    floor = "MFLR8_3",
    ceil  = "FLOOR6_2",

    arch = "arch_arched",

    theme_probs = { HELL=70,CAVE=30 },
    trim_mode = "rough_hew",
  },

  BLUECARPET =
  {
    mat_pri = 0,

    wall = "STARTAN2",
    void = "STARTAN3",
    step = "STEP1",
    pillar = "STARGR2", -- or STARBR2

    floor = "FLAT14",
    ceil  = "TLITE6_4",

    arch_floor = "FLAT20",
    arch_ceil  = "CEIL3_2",

    theme_probs = { TECH=80,INDUSTRIAL=30 },
    well_lit = true,
    trim_mode = "guillotine",
  },
}

---- BASE MATERIALS ------------

DOOM.FACTORY.DM_MATS =
{
  METAL =
  {
    mat_pri = 5,

    wall  = "METAL",
    void  = "METAL1",
    floor = "CEIL5_2",
    ceil  = "CEIL5_2",
  },

  ARCH =
  {
    wall  = "METAL",
    void  = "METAL1",
    floor = "CEIL5_2",
    ceil  = "CEIL5_2",
  },

  SHINY =
  {
    wall  = "SHAWN2",
    void  = "SHAWN1",
    floor = "FLAT23",
    ceil  = "FLAT23",
  },

  STEP =
  {
    wall  = "STEP1",
    floor = "FLAT1",
  },

  LIFT =
  {
    wall  = "SUPPORT2",
    floor = "STEP2"
  },

  CAGE =
  {
    wall  = "METAL",
    floor = "CEIL5_2",
    ceil  = "TLITE6_4",
  },

  TRACK =
  {
    wall  = "DOORTRAK",
    floor = "FLOOR6_2",
  },

  DOOR_FRAME =
  {
    wall  = "LITE5",
    floor = "FLAT1",
    ceil  = "TLITE6_6",
  },

  SW_FRAME =
  {
    wall  = "LITE5",
    floor = "TLITE6_6",
  },
}

--- PEDESTALS --------------

DOOM.FACTORY.DM_PEDESTALS =
{
  PLAYER =
  {
    wall = "SHAWN2",  void = "SHAWN2",
    floor = "FLAT22", ceil = "FLAT22",
    h = 8,
  },

  QUEST =
  {
    wall  = "METAL", void = "METAL",
    floor = "GATE4", ceil = "GATE4",
    h = 24,
  },

  WEAPON =
  {
    wall  = "METAL",   void = "METAL",
    floor = "CEIL1_2", ceil = "CEIL1_2",
    h = 12,
  },
}

---- OVERHANGS ------------

DOOM.FACTORY.DM_OVERHANGS =
{
  METAL =
  {
    ceil = "CEIL5_1",
    upper = "METAL",
    thin = "METAL",
  },

  MARBLE =
  {
    thin = "MARBLE1",
    upper = "MARBLE3",
    ceil = "DEM1_6",
  },

  STONE =
  {
    thin = "STONE",
    upper = "STONE",
    ceil = "FLAT5_4",
  },

  WOOD =
  {
    thin = "WOOD1",
    upper = "WOOD1",
    ceil = "FLAT5_1",
  },
}

---- CRATES ------------

DOOM.FACTORY.DM_CRATES =
{
  CRATE1 =
  {
    wall = "CRATE1", h=64, floor = "CRATOP2"
  },
  
  CRATE2 =
  {
    wall = "CRATE2", h=64, floor = "CRATOP1"
  },
  
  CRATELIT =
  {
    wall = "CRATELIT", h=128, floor = "CRATOP1"
  },

  GRAY =
  {
    wall = "GRAY2", h=64, floor = "FLAT5_4", can_rotate=true
  },

  ICKWALL =
  {
    wall = "ICKWALL4", h=64, floor = "FLAT19",
    can_rotate=true, can_yshift=64
  },

  SHAWN =
  {
    wall = "SHAWN3", h=64, floor = "FLAT23", can_rotate=true
  },
  
  WOOD3A =
  {
    wall = "WOOD3", h=64, floor = "CEIL1_1",
    side_x_offset=64
  },

  WOOD3B =
  {
    wall = "WOOD3", h=64, floor = "CEIL1_1",
    x_offset=128, y_offset=59, side_x_offset=64
  },

  WOODSKUL =
  {
    wall = "WOOD4", h=64, floor = "CEIL1_1",
    can_rotate=true, can_yshift=59
  },
}


---- ARCH STUFF ------------

DOOM.FACTORY.DM_LIQUIDS =
{
  water = { floor="FWATER1", wall="FIREMAG1" },
  blood = { floor="BLOOD1",  wall="BFALL1",   sec_kind=7 }, --  5% damage
  nukage= { floor="NUKAGE1", wall="SFALL1",   sec_kind=5 }, -- 10% damage
  lava  = { floor="LAVA1",   wall="ROCKRED1", sec_kind=16, add_light=64 }, -- 20% damage
}

DOOM.FACTORY.DM_SWITCHES =
{
  sw_blue =
  {
    switch =
    {
      prefab = "SWITCH_FLOOR",
      skin =
      {
        switch_w="SW1BLUE", side_w="COMPBLUE",
        switch_f="FLAT14", switch_h=64,

        beam_w="WOOD1", beam_f="FLAT5_2",

        x_offset=0, y_offset=56, kind=103,
      }
    },

    switch2 =
    {
      prefab = "SWITCH_FLOOR_BEAM",
      skin =
      {
        switch_w="SW1BLUE", side_w="COMPBLUE",
        switch_f="FLAT14", switch_h=64,

        beam_w="WOOD1", beam_f="FLAT5_2",

        x_offset=0, y_offset=56, kind=103,
      }
    },

    door =
    {
      w=128, h=112,
      prefab = "DOOR_LIT_LOCKED",
      skin =
      {
        key_w="COMPBLUE",
        door_w="BIGDOOR3", door_c="FLOOR7_2",
        step_w="STEP1",  track_w="DOORTRAK",
        frame_f="FLAT1", frame_c="FLAT1",
        door_h=112,
        door_kind=0,
      }
    },
  },

  sw_hot =
  {
    switch =
    {
      prefab = "SWITCH_PILLAR",
      skin =
      {
        switch_w="SW1HOT", wall="SP_HOT1", kind=103,
      }
    },

    door =
    {
      w=128, h=112,
      prefab = "DOOR_LIT_LOCKED",
      skin =
      {
        key_w="SP_HOT1",
        door_w="BIGDOOR3", door_c="FLOOR7_2",
        step_w="STEP1",  track_w="DOORTRAK",
        frame_f="FLAT1", frame_c="FLAT1",
        door_h=112,
        door_kind=0,
      }
    },

    bars =
    {
      w=128, h=112,
      prefab = "BARS_FENCE_DOOR",
      environment = "outdoor",
      skin =
      {
        door_w="BIGDOOR7", door_f="CEIL5_2",
        side_w="METAL",
--      beam_w="SP_HOT1", beam_f="FLAT5_3",
        door_kind=0,
      }
    },
  },

  sw_skin =
  {
    --FIXME: SKINBORD is doom1 only
    switch =
    {
      prefab = "SWITCH_PILLAR",
      skin =
      {
        switch_w="SW1SKIN", wall="SKINBORD", kind=103,
      }
    },

    door =
    {
      w=128, h=112,
      prefab = "DOOR_LIT_LOCKED",
      skin =
      {
        key_w="SKINFACE",
        door_w="BIGDOOR3", door_c="FLOOR7_2",
        step_w="STEP1",  track_w="DOORTRAK",
        frame_f="FLAT1", frame_c="FLAT1",
        door_h=112,
        door_kind=0,
      }
    },
  },

  sw_vine =
  {
    switch =
    {
      prefab = "SWITCH_PILLAR",
      skin =
      {
        switch_w="SW1VINE", wall="GRAYVINE", kind=103,
      }
    },

    door =
    {
      w=128, h=112,
      prefab = "DOOR_LIT_LOCKED",
      skin =
      {
        key_w="GRAYVINE",
        door_w="BIGDOOR3", door_c="FLOOR7_2",
        step_w="STEP1",  track_w="DOORTRAK",
        frame_f="FLAT1", frame_c="FLAT1",
        door_h=112,
        door_kind=0,
      }
    },
  },

  sw_metl =
  {
    switch =
    {
      prefab = "SWITCH_CEILING",
      environment = "indoor",
      skin =
      {
        switch_w="SW1GARG", side_w="METAL",
        switch_c="CEIL5_2", switch_h=56,

        beam_w="SUPPORT3", beam_c="CEIL5_2",

        x_offset=0, y_offset=64, kind=23,
      }
    },

    door =
    {
      w=128, h=128,
      prefab = "BARS_1",
      skin =
      {
        bar_w="SUPPORT3", bar_f="CEIL5_2",
        door_kind=0,
      }
    },
  },

  sw_gray =
  {
    switch =
    {
      prefab = "SWITCH_PILLAR",
      skin =
      {
        switch_w="SW1GRAY1", wall="GRAY1", kind=23,
      }
    },

    door =
    {
      w=128, h=128,
      prefab = "BARS_2",
      skin =
      {
        bar_w="GRAY7", bar_f="FLAT19",
        door_kind=0
      },
    },

  },

--FIXME: (not in doom1)  sw_rock = { wall="ROCK3",    switch="SW1ROCK",  floor="RROCK13", bars=true },
--FIXME:  sw_wood = { wall="WOODMET1", switch="SW1WDMET", floor="FLAT5_1", bars=true, stand_h=128 },

}

DOOM.FACTORY.DM_DOORS =
{
  -- Note: most of these with h=112 are really 128 pixels
  --       tall, but work fine when truncated.

  d_big2   = { prefab="DOOR_LIT", w=128, h=112,

               skin =
               {
                 door_w="BIGDOOR2", door_c="FLAT1",
                 lite_w="LITE5", step_w="STEP1",
                 frame_f="FLAT1", frame_c="TLITE6_6",
                 track_w="DOORTRAK",
                 door_h=112,
               }
             },

--[[ !!! DOOM.FACTORY.DM_DOORS
  d_uac    = { wall="BIGDOOR1", w=128, h=72  },  -- actual height is 96
  d_big1   = { wall="BIGDOOR2", w=128, h=112 },
  d_big2   = { wall="BIGDOOR3", w=128, h=112 },
  d_big3   = { wall="BIGDOOR4", w=128, h=112 },

  d_wood1  = { wall="BIGDOOR5", ceil="CEIL5_2", w=128, h=112 },
  d_wood2  = { wall="BIGDOOR6", ceil="CEIL5_2", w=128, h=112 }, -- this is the real height!
  d_wood3  = { wall="BIGDOOR7", ceil="CEIL5_2", w=128, h=112 },
--]]

  d_small1 = { wall="DOOR1",    w=64, h=72 },
  d_small2 = { wall="DOOR3",    w=64, h=72 },
}

DOOM.FACTORY.DM_KEY_DOORS =
{
  k_blue =
  {
    w=128, h=112,

    prefab = "DOOR_LIT_LOCKED",
    
    skin =
    {
      key_w="DOORBLU2",
      door_w="BIGDOOR4", door_c="FLOOR3_3",
      step_w="STEP1",  track_w="DOORTRAK",
      frame_f="FLAT1", frame_c="FLAT1",
      door_h=112,
      door_kind=26, tag=0,  -- kind_once=32
    }
  },

  k_yellow =
  {
    w=128, h=112,

    prefab = "DOOR_LIT_LOCKED",

    skin =
    {
      key_w="DOORYEL2",
      door_w="BIGDOOR4", door_c="FLOOR3_3",
      step_w="STEP1",  track_w="DOORTRAK",
      frame_f="FLAT1", frame_c="FLAT1",
      door_h=112,
      door_kind=27, tag=0, -- kind_once=34
    }
  },

  k_red =
  {
    w=128, h=112,

    prefab = "DOOR_LIT_LOCKED",

    skin =
    {
      key_w="DOORRED2",
      door_w="BIGDOOR4", door_c="FLOOR3_3",
      step_w="STEP1",  track_w="DOORTRAK",
      frame_f="FLAT1", frame_c="FLAT1",
      door_h=112,
      door_kind=28, tag=0, -- kind_once=33
    }
  },

}

DOOM.FACTORY.DM_LIFTS =
{
  slow = { kind=62,  walk=88  },
  fast = { kind=123, walk=120 },
}

DOOM.FACTORY.DM_IMAGES =
{
  { wall = "CEMENT1", w=128, h=128, glow=true },
  { wall = "CEMENT2", w=64,  h=64,  floor="MFLR8_3" }
}

DOOM.FACTORY.DM_LIGHTS =
{
  metal = { floor="CEIL1_2",  side="METAL" },
  wood  = { floor="CEIL1_3",  side="WOOD1" },
  star  = { floor="CEIL3_4",  side="STARTAN2" },

  gray1 = { floor="FLAT2",    side="GRAY5" },
  gray2 = { floor="FLAT17",   side="GRAY5" },
  hot   = { floor="FLOOR1_7", side="SP_HOT1" },

  tl61 = { floor="TLITE6_1", side="METAL" },
  tl64 = { floor="TLITE6_4", side="METAL" },
  tl65 = { floor="TLITE6_5", side="METAL" },
  tl66 = { floor="TLITE6_6", side="METAL" },
}


DOOM.FACTORY.DM_SCENERY_PREFABS =
{
  pillar_COMPWERD =
  {
    prefab = "PILLAR", add_mode = "island",
    environment = "indoor",
    skin = { wall="COMPWERD" },
  },
  
  pillar_GSTLION =
  {
    prefab = "PILLAR", add_mode = "island",
    environment = "indoor",
    skin = { wall="GSTLION" },
  },
  
  pillar_SPDUDE5 =
  {
    prefab = "PILLAR", add_mode = "island",
    environment = "indoor",
    skin = { wall="SP_DUDE5" },
  },
  
  pillar_light1_METAL =
  {
    prefab = "PILLAR_LIGHT1",
    add_mode = "island",

    environment = "indoor",

    skin = { beam_w="METAL", beam_f="CEIL5_2",
             lite_w="LITE5" },

    theme_probs = { TECH=5, INDUSTRIAL=12 },
  },

  pillar_rnd_sm_POIS =
  {
    prefab = "PILLAR_ROUND_SMALL",
    add_mode = "island",
    environment = "indoor",

    skin = { wall="BRNPOIS" },
  },

  stalagmite_MED =
  {
    prefab = "STALAGMITE",
    add_mode = "island",
    environment = "indoor",
    min_height = 128,
    skin = {},
  },

  billboard_lit_SHAWN =
  {
    prefab = "BILLBOARD_LIT",
    environment = "outdoor",
    add_mode = "extend",
    min_height = 160,

    skin =
    {
      pic_w  = "SHAWN1", pic_back = "SHAWN2",
      pic_f = "CEIL3_5", pic_h = 88,

      corn_w = "SHAWN2", corn2_w = "DOORSTOP",
      corn_f = "FLAT19", corn_h  = 112,

      step_w = "STEP4", step_f = "CEIL3_5",
      lite_w = "LITE5",
    },

    theme_probs = { NATURE=20, URBAN=10 },
  },

  ground_light_SILVER =
  {
    prefab = "GROUND_LIGHT",
    environment = "outdoor",
    min_height = 96,

    skin =
    { 
      shawn_w = "SHAWN3", shawn_f = "FLAT1",
      lite_w  = "LITE5",  lite_f  = "CEIL5_1",
    },

    theme_probs = { NATURE=50, URBAN=5 },
    force_dir = 2, -- optimisation
  },

  rock_pieces_BROWN =
  {
    prefab = "ROCK_PIECES",
    environment = "outdoor",
    theme_probs = { NATURE=60 },
    skin = { rock_w="BROWNHUG", rock_f="FLAT1_2", rock_h=12 },
  },

  rock_pieces_WHITE =
  {
    prefab = "ROCK_PIECES",
    environment = "outdoor",
    theme_probs = { NATURE=20 },
    skin = { rock_w="GRAYBIG", rock_f="MFLR8_3", rock_h=6 },
  },

  rock_pieces_ASH_HOLE =
  {
    prefab = "ROCK_PIECES",
    environment = "outdoor",
    theme_probs = { NATURE=60 },
    skin = { rock_f="FLAT5_7", rock_h=-6 },
  },

  pentagram_RED =
  {
    prefab = "PENTAGRAM",
    add_mode = "island",
    theme_probs = { HELL=30 },
    skin =
    {
      gram_w="REDWALL", gram_f="FLAT5_3",
      gram_h=12, gram_lt=240, kind=8,
      gram_t="candle",
    }
  },

  pentagram_LAVA =
  {
    prefab = "PENTAGRAM",
    add_mode = "island",
    theme_probs = { HELL=20 },
    skin =
    {
      gram_f="LAVA1", gram_h=-10, gram_lt=192, kind=0,
      gram_t="none"
    }
  },

  skylight_cross_sm_METAL =
  {
    prefab = "SKYLIGHT_CROSS_SMALL",
    environment = "indoor",
    add_mode = "island",
    min_height = 80,

    skin =
    { 
      sky_c = "F_SKY1",
      frame_w = "METAL", frame_c = "CEIL5_2",
    },

    prob = 10,
  },

  crate_CRATE1 =
  {
    prefab = "CRATE",

    skin =
    {
      crate_h = 64,
      crate_w = "CRATE1",
      crate_f = "CRATOP2",
    }
  },

  crate_CRATE2 =
  {
    prefab = "CRATE",

    skin =
    {
      crate_h = 64,
      crate_w = "CRATE2",
      crate_f = "CRATOP1",
    }
  },

  crate_WIDE =
  {
    prefab = "CRATE_BIG",

    skin =
    {
      crate_h = 128,
      crate_w = "CRATWIDE",
      crate_f = "CRATOP1",
    },

    force_dir = 2, -- optimisation
  },

  crate_WOODSKUL =
  {
    prefab = "CRATE",

    skin =
    {
      crate_h = 64,
      crate_w = "WOOD4",
      crate_f = "CEIL1_1",
    }
  },

  crate_rotate_CRATE1 =
  {
    prefab = "CRATE_ROTATE",

    skin =
    {
      crate_h = 64,
      crate_w = "CRATE1",
      crate_f = "CRATOP2",
    }
  },

  crate_rotate_CRATE2 =
  {
    prefab = "CRATE_ROTATE",

    skin =
    {
      crate_h = 128,
      crate_w = "CRATE2",
      crate_f = "CRATOP1",
    }
  },

  crate_rot22_CRATE1 =
  {
    prefab = "CRATE_ROTATE_22DEG",

    skin =
    {
      crate_h = 64,
      crate_w = "CRATE1",
      crate_f = "CRATOP2",
    }
  },

  crate_rot22_CRATE2 =
  {
    prefab = "CRATE_ROTATE_22DEG",

    skin =
    {
      crate_h = 128,
      crate_w = "CRATE2",
      crate_f = "CRATOP1",
    }
  },

  crate_triple_A =
  {
    prefab = "CRATE_TRIPLE",
    add_mode = "island",
    min_height = 144,

    skin =
    {
      crate_w1 = "CRATE1", crate_f1 = "CRATOP2",
      crate_w2 = "CRATE1", crate_f2 = "CRATOP2",
      crate_w3 = "CRATE2", crate_f3 = "CRATOP1",
      small_w  = "CRATELIT", small_f = "CRATOP1",
    },
  },

  crate_triple_B =
  {
    prefab = "CRATE_TRIPLE",
    add_mode = "island",
    min_height = 144,

    skin =
    {
      crate_w1 = "CRATE2", crate_f1 = "CRATOP1",
      crate_w2 = "CRATE1", crate_f2 = "CRATOP2",
      crate_w3 = "CRATE1", crate_f3 = "CRATOP2",
      small_w  = "CRATELIT", small_f = "CRATOP1",
    },
  },

  crate_rotnar_GRAY2 =
  {
    prefab = "CRATE_ROTATE_NARROW",
    add_mode = "island",

    skin =
    {
      crate_h = 58,
      crate_w = "GRAY2",
      crate_f = "FLAT5_4"
    }
  },

  cage_pillar_METAL =
  {
    prefab = "CAGE_PILLAR",
    add_mode = "island",
    min_height = 160,
    is_cage = true,

    skin =
    {
      cage_w = "METAL",
      cage_f = "CEIL5_2", cage_c = "TLITE6_4",
      rail_w = "MIDGRATE", rail_h = 72,
    },

    prob = 3
  },

}

DOOM.FACTORY.DM_FEATURE_PREFABS =
{
  pillar_rnd_med_COMPSTA =
  {
    prefab = "PILLAR_ROUND_MEDIUM",
    add_mode = "island",

    skin = { wall="COMPSTA1" },
  },

  pillar_rnd_bg_COMPSTA =
  {
    prefab = "PILLAR_ROUND_LARGE",
    add_mode = "island",

    skin = { wall="COMPSTA2" },

    theme_probs = { TECH=30, INDUSTRIAL=10 },
  },

  overhang1_WOOD =
  {
    prefab = "OVERHANG_1",
    environment = "outdoor",
    add_mode = "island",
    min_height = 128,
    max_height = 320,

    skin =
    {
      beam_w = "WOOD1",
      hang_u = "WOOD1",
      hang_c = "FLAT5_1",
    },

    pickup_specialness = 35,
    theme_probs = { NATURE=40, URBAN=15 },
  },

  overhang1_MARBLE =
  {
    prefab = "OVERHANG_1",
    environment = "outdoor",
    add_mode = "island",
    min_height = 128,
    max_height = 320,

    skin =
    {
      beam_w = "MARBLE1",
      hang_u = "MARBLE3",
      hang_c = "DEM1_6",
    },

    pickup_specialness = 35,
    theme_probs = { HELL=25, NATURE=10 },
  },

  street_lamp_1 =
  {
    prefab = "STREET_LAMP_TWO_SIDED",
    environment = "outdoor",
    add_mode = "island",
    min_height = 160,
    max_height = 512,
    theme_probs = { URBAN=25, NATURE=5 },

    skin =
    {
      lite_w="METAL",  lite_c="CEIL1_2",
      arm_w="BROWN1",  arm_f="FLOOR3_3",
      arm_u="BROWN96", arm_c="CEIL5_2",
      beam_w="METAL"
    },
  },

  stalagmite_HUGE =
  {
    prefab = "STALAGMITE_HUGE",
    environment = "indoor",
    min_height = 144,
    theme_probs = { CAVE=150 },
    skin = {},
  },

  cave_in_FLOOR7 =
  {
    prefab = "CAVE_IN_SMALL",
    environment = "indoor",
    theme_probs = { CAVE=90 },
    skin =
    {
      rock_f="FLOOR7_1", -- rock_w="BROWN144",
      sky_c="F_SKY1",
    },
  },

  pond_small_LAVA =
  {
    prefab = "POND_SMALL",
    theme_probs = { CAVE=30 },
    skin = 
    {
      pond_f="LAVA1", pond_w="ROCKRED1",
      liquid_f="LAVA1", -- outer_w
      kind=16
    },
  },

--[[
  rock_volcano_SPROCK_LAVA =
  {
    prefab = "ROCK_VOLCANO",
    environment = "outdoor",
    theme_probs = { NATURE=40 },
    min_height = 256,
    skin = 
    {
      rock_w="SP_ROCK1", rock_f="MFLR8_3",
      liquid_w="ROCKRED1", liquid_f="LAVA1",
    },
  },
--]]

  leakage_pool_LAVA =
  {
    prefab = "LEAKAGE_POOL",
    environment = "indoor",
    min_height = 128,
    max_height = 192,
    theme_probs = { CAVE=90 },
    skin = { liquid_f="LAVA1", liquid_w="ROCKRED1", kind=16 },
  },

  pump_vat_NUKAGE =
  {
    prefab = "PUMP_INTO_VAT",
    environment = "indoor",
    min_height = 160,
    max_height = 256,
    theme_probs = { INDUSTRIAL=40 },
    skin =
    {
      vat_w="SHAWN2", vat_f="FLAT23",
      hose_w="PIPE2", hose_c="FLAT5",
      liquid_w="SFALL1", liquid_f="NUKAGE1",
      kind=16
    }
  },

  pump_vat_WATER =
  {
    prefab = "PUMP_INTO_VAT",
    environment = "indoor",
    min_height = 160,
    max_height = 256,
    theme_probs = { INDUSTRIAL=2 },
    skin =
    {
      vat_w="METAL", vat_f="CEIL5_2",
      hose_w="METAL", hose_c="CEIL5_2",
      liquid_w="FIREMAG1", liquid_f="FWATER1",
      kind=0
    }
  },

  launch_pad_big_H =
  {
    prefab = "LAUNCH_PAD_LARGE",
    environment = "outdoor",
    add_mode = "island",

    skin =
    {
      pad_f="FLAT1", letter_f="CRATOP1",
      outer_w="METAL1", outer_f="FLOOR4_8",
      step_w="STEP1", side_w="METAL1", step_f="FLOOR4_8",
    },

    prob = 5,
    pickup_specialness = 90,
    force_dir = 2, -- optimisation
  },
  
  launch_pad_med_F =
  {
    prefab = "LAUNCH_PAD_MEDIUM",
    environment = "outdoor",
    add_mode = "island",

    skin =
    {
      pad_f="FLAT1", letter_f="CRATOP1",
      outer_w="METAL1", outer_f="FLOOR4_8",
      step_w="STEP1", side_w="METAL1", step_f="FLOOR4_8",
    },

    prob = 5,
    pickup_specialness = 80,
    force_dir = 4, -- optimisation
  },
  
  launch_pad_sml_S =
  {
    prefab = "LAUNCH_PAD_SMALL",
    environment = "outdoor",
    add_mode = "island",

    skin =
    {
      pad_f="FLAT1", letter_f="CRATOP1",
      outer_w="METAL1", outer_f="FLOOR4_8",
      step_w="STEP1", side_w="METAL1", step_f="FLOOR4_8",
    },

    prob = 5,
    pickup_specialness = 80,
    force_dir = 2, -- optimisation
  },
 
  tech_pickup_STONE =
  {
    prefab = "TECH_PICKUP_LARGE",
    environment = "indoor",
    add_mode = "island",
    min_height = 224,
    max_height = 320,

    skin =
    {
      wall="STONE2", floor="CEIL5_2", ceil="CEIL3_5",
      lite_w="LITE5", sky_c="F_SKY1",
      step_w="STEP1", carpet_f="FLOOR1_1",
    },

    prob = 5,
    pickup_specialness = 100,
    force_dir = 2, -- optimisation
  },

  liquid_pickup_NUKAGE =
  {
    prefab = "LIQUID_PICKUP",
    min_height = 144,
    max_height = 384,

    skin =
    {
      wall="METAL", floor="CEIL5_2", ceil="CEIL5_2",

      liquid_f="NUKAGE1", sky_c="F_SKY1",
    },

    prob = 5,
    pickup_specialness = 95,
  },

  light_groovy_RED =
  {
    prefab = "LIGHT_GROOVY",
    environment = "indoor",
    add_mode = "island",
    theme_probs = { TECH=50 },
    force_dir = 2,

    skin =
    {
      frame_c="CEIL5_2", frame_w="SKINSYMB",
      lite_c="FLOOR1_7",
      lite_lt=255, frame_lt=168, kind=8,
    }
  },
  
  skylight_mega_METAL =
  {
    prefab = "SKYLIGHT_MEGA_1",
    environment = "indoor",
    add_mode = "island",
    min_height = 96,
    -- max_height = 304,  ???

    skin =
    { 
      sky_c = "F_SKY1",
      frame_w = "METAL", frame_c = "CEIL5_2",
      beam_w = "METAL", beam_c = "CEIL5_2",
    },

    prob = 10,
  },

  crate_jumble =
  {
    prefab = "CRATE_JUMBLE",
    add_mode = "island",
    min_height = 224,

    skin =
    {
      tall_w   = "CRATE1",   tall_f = "CRATOP2",
      wide_w   = "CRATWIDE", wide_f = "CRATOP1",

      crate_w1 = "CRATE1", crate_f1 = "CRATOP2",
      crate_w2 = "CRATE2", crate_f2 = "CRATOP1",
    },

    theme_probs = { INDUSTRIAL=20 },
  },

  fountain_STONE =
  {
    prefab = "FOUNTAIN_SQUARE",
    environment = "outdoor",
    add_mode = "island",

    skin =
    {
      edge_w="STONE", edge_f="FLAT19",
      beam_w="STONE", beam_f="FLAT1",
      liquid_f="FWATER1", liquid_w="FIREMAG1",
    },

    theme_probs = { URBAN=90, NATURE=50, HELL=5 },
  },

  cage_w_posts_WOOD_MIDGRATE =
  {
    prefab = "CAGE_OPEN_W_POSTS",
    add_mode = "island",
    min_height = 208,
    is_cage = true,

    skin =
    {
      beam_w="SUPPORT3", beam_f="CEIL5_2",
      cage_w="WOOD1",    cage_f="FLAT5_2",
      rail_w="MIDGRATE", rail_h=128,
    },

    prob = 4
  },
}

DOOM.FACTORY.DM_WALL_PREFABS =
{
  solid_CEMENT4 =
  {
    prefab = "SOLID_WIDE", skin = { wall="CEMENT4" },
  },
  
  solid_CEMENT5 =
  {
    prefab = "SOLID_WIDE", skin = { wall="CEMENT5" },
  },
  
  solid_ICKWALL4 =
  {
    prefab = "SOLID", skin = { wall="ICKWALL4" },
  },
  
  solid_ICKWALL5 =
  {
    prefab = "SOLID", skin = { wall="ICKWALL5" },
  },
  
  solid_ICKWALL7 =
  {
    prefab = "SOLID", skin = { wall="ICKWALL7" },
  },
  
  solid_PIPE4 =
  {
    prefab = "SOLID_WIDE", skin = { wall="PIPE4" },
  },
  
  solid_SLADSKUL =
  {
    prefab = "SOLID", skin = { wall="SLADSKUL" },
  },
  
  wall_lamp_RED_TORCH =
  {
    prefab = "WALL_LAMP",
    skin = { lamp_t="red_torch_sm" },
    theme_probs = { CAVE=90, HELL=70 }, 
  },

  wall_lamp_GREEN_TORCH =
  {
    prefab = "WALL_LAMP",
    skin = { lamp_t="green_torch_sm" },
    theme_probs = { CAVE=90, HELL=30, URBAN=10 }, 
  },

  wall_lamp_BLUE_TORCH =
  {
    prefab = "WALL_LAMP",
    skin = { lamp_t="blue_torch_sm" },
    theme_probs = { CAVE=90, URBAN=20 }, 
  },

  wall_pic_MARBFACE =
  {
    prefab = "WALL_PIC",
    min_height = 160,
    skin = { pic_w="MARBFACE", pic_h=128 },
    theme_probs = { HELL=90 },
  },

  wall_pic_MARBFAC2 =
  {
    prefab = "WALL_PIC",
    min_height = 160,
    skin = { pic_w="MARBFAC2", pic_h=128 },
    theme_probs = { HELL=60, CAVE=10 },
  },

  wall_pic_MARBFAC3 =
  {
    prefab = "WALL_PIC",
    min_height = 160,
    skin = { pic_w="MARBFAC3", pic_h=128 },
    theme_probs = { HELL=50, URBAN=5 },
  },

  wall_pic_FIREWALL =
  {
    prefab = "WALL_PIC_SHALLOW",
    min_height = 144,
    skin = { pic_w="FIREWALL", pic_h=112 },
    theme_probs = { HELL=120 },
  },

  wall_pic_SPDUDE1 =
  {
    prefab = "WALL_PIC",
    min_height = 160,
    skin = { pic_w="SP_DUDE1", pic_h=128 },
  },

  wall_pic_SPDUDE2 =
  {
    prefab = "WALL_PIC",
    min_height = 160,
    skin = { pic_w="SP_DUDE2", pic_h=128 },
  },

  wall_scroll_FACES =
  {
    prefab = "WALL_PIC_SCROLLER",
    min_height = 144,
    theme_probs = { HELL=4 },
    skin = { pic_w="SP_FACE1", pic_h=96, kind=48 },
  },

  wall_scroll_SPINE =
  {
    prefab = "WALL_PIC_SCROLLER",
    min_height = 144,
    theme_probs = { HELL=8 },
    skin = { pic_w="SKSPINE2", pic_h=96, kind=48 },
  },

  wall_cross_RED =
  {
    prefab = "WALL_CROSS",
    min_height = 160,
    theme_probs = { HELL=200 },
    skin =
    {
      cross_w="REDWALL", back_w="REDWALL",
      cross_f="FLAT5_3",
      cross_lt=255, kind=0,
    },
  },

  lights_thin_LITE5 =
  {
    prefab = "WALL_LIGHTS_THIN",
    min_height = 128,
    theme_probs = { TECH=40, INDUSTRIAL=10 },
    skin =
    {
      lite_w="LITE5", lite_side="LITE5",
      frame_f="FLAT20",
      wall_lt=255, kind=8,
    },
  },

  lights_wide_LITEBLU4 =
  {
    prefab = "WALL_LIGHTS_WIDE",
    min_height = 128,
    theme_probs = { INDUSTRIAL=40 },
    skin =
    {
      lite_w="LITEBLU4", lite_side="LITEBLU4",
      frame_f="FLAT22",
      wall_lt=255, kind=8,
    },
  },
}

DOOM.FACTORY.DM_ARCH_PREFABS =
{
  arch_fence =
  {
    prefab = "ARCH_FENCE",
--  environment = "outdoor",
    skin = {},
  },
 
  arch_wire_fence =
  {
    prefab = "ARCH_WIRE_FENCE",
--  environment = "outdoor",
    skin = {},
  },
}

DOOM.FACTORY.DM_DOOR_PREFABS =
{
  backup_plan =
  {
    w=64, h=112, prefab="DOOR_SUPER_NARROW",

    skin =
    {
      door_w="SPCDOOR1", door_c="FLAT1",
      track_w="DOORTRAK",
      door_h=112,
      door_kind=1, tag=0,
    },
  },

  silver_lit =
  {
    w=128, h=112, prefab="DOOR_LIT",

    skin =
    {
      door_w="BIGDOOR2", door_c="FLAT1",
      lite_w="LITE5", step_w="STEP1",
      frame_f="FLAT1", frame_c="TLITE6_6",
      track_w="DOORTRAK",
      door_h=112,
      door_kind=1, tag=0,
    },

    theme_probs = { INDUSTRIAL=70,TECH=70,URBAN=10 },
  },

  uac_lit =  -- actual height is 96
  {
    w=128, h=72, prefab="DOOR_LIT",

    skin =
    {
      door_w="BIGDOOR1", door_c="FLAT23",
      lite_w="LITE5", step_w="STEP1",
      frame_f="FLAT1", frame_c="TLITE6_6",
      track_w="DOORTRAK",
      door_h=72,
      door_kind=1, tag=0,
    },

    theme_probs = { INDUSTRIAL=20,TECH=50 },
  },

  wooden =
  {
    w=128, h=112, prefab="DOOR",

    skin =
    {
      door_w="BIGDOOR5", door_c="FLAT5_2",
      lite_w="LITE5", step_w="STEP1",
      frame_f="FLAT1", frame_c="FLAT1",
      track_w="DOORTRAK",
      door_h=112,
      door_kind=1, tag=0,
    },

    theme_probs = { URBAN=70,CAVE=30,HELL=5 }
  },

  wood_garg =
  {
    w=128, h=112, prefab="DOOR",

    skin =
    {
      door_w="BIGDOOR6", door_c="CEIL5_2",
      lite_w="LITE5", step_w="STEP1",
      frame_f="FLAT1", frame_c="FLAT1",
      track_w="DOORTRAK",
      door_h=112,
      door_kind=1, tag=0,
    },

    theme_probs = { CAVE=50,HELL=30 },
  },

  wood_skull =
  {
    w=128, h=112, prefab="DOOR",

    skin =
    {
      door_w="BIGDOOR7", door_c="CEIL5_2",
      lite_w="LITE5", step_w="STEP1",
      frame_f="FLAT1", frame_c="FLAT1",
      track_w="DOORTRAK",
      door_h=112,
      door_kind=1, tag=0,
    },

    theme_probs = { HELL=90,CAVE=5 },
  },
 
}

DOOM.FACTORY.DM_WINDOW_PREFABS =
{
  window_narrow =
  {
    prefab = "WINDOW_NARROW",
    skin = { },
  },

  window_rail_nar_MIDGRATE =
  {
    prefab = "WINDOW_RAIL_NARROW",
    skin = { rail_w="MIDGRATE" },
  },

  window_cross_big =
  {
    prefab = "WINDOW_CROSS_BIG",
    skin = { },
  },
}

DOOM.FACTORY.DM_MISC_PREFABS =
{
  pedestal_PLAYER =
  {
    prefab = "PEDESTAL",
    skin = { wall="SHAWN2", floor="FLAT22", ped_h=8 },
  },

  pedestal_ITEM =
  {
    prefab = "PEDESTAL",
    skin = { wall="METAL", floor="CEIL1_2", ped_h=12 },
  },

  fence_wire_STD =
  {
    prefab = "FENCE_RAIL",
    skin = { rail_w="BRNSMALC" },
  },
  
  arch_arched =
  {
    prefab = "ARCH_ARCHED", skin = {},
  },

  arch_hole =
  {
    prefab = "ARCH_HOLE1", skin = {},
  },

  arch_russian_WOOD =
  {
    prefab = "ARCH_RUSSIAN",
    skin = { beam_w="WOOD1", beam_c="FLAT5_2" },
  },

  fence_beam_BLUETORCH =
  {
    prefab = "FENCE_BEAM_W_LAMP",

    skin = { lamp_t="blue_torch", beam_h=72,
             beam_w="METAL", beam_f="CEIL5_2",
           },
  },

  image_1 =
  {
    prefab = "CRATE",
    add_mode = "island",
    skin = { crate_h=64, crate_w="CEMENT2", crate_f="MFLR8_3" },
  },

  image_2 =
  {
    prefab = "WALL_PIC_SHALLOW",
    add_mode = "wall",
    min_height = 144,
    skin = { pic_w="CEMENT1", pic_h=128 },
  },

  exit_DOOR =
  {
    w=64, h=72,

    prefab = "EXIT_DOOR",

    skin =
    {
      door_w = "EXITDOOR", door_c = "CEIL5_2",
      exit_w = "EXITSIGN", exit_c = "CEIL5_2",

      step_w="STEP1",  track_w="DOORTRAK",
      frame_f="FLAT1", frame_c="TLITE6_5",
      door_h=72,
      door_kind=1, tag=0,
    }
  },

  exit_DOOR_WIDE =
  {
    w=64, h=72,

    prefab = "EXIT_DOOR_WIDE",

    skin =
    {
      front_w = "EXITSTON",
      door_w = "EXITDOOR", door_c = "CEIL5_2",
      exit_w = "EXITSIGN", exit_c = "CEIL5_2",

      step_w="STEP1",  track_w="DOORTRAK",
      frame_f="FLAT1", frame_c="TLITE6_5",
      door_h=72,
      door_kind=1, tag=0,
    }
  },

  secret_DOOR =
  {
    w=128, h=128, prefab = "DOOR",

    skin = { track_w="DOORSTOP", door_h=128,
             door_kind=31, tag=0,
           }
  },
}

DOOM.FACTORY.DM_DEATHMATCH_EXITS =
{
  exit_deathmatch_TECH =
  {
    prefab = "EXIT_DEATHMATCH",

    skin = { wall="TEKWALL4", front_w="TEKWALL4",
             floor="CEIL4_3", ceil="TLITE6_5",
             switch_w="SW1COMM", side_w="SHAWN2", switch_f="FLAT23",
             frame_f="FLAT1", frame_c="FLAT1", step_w="STEP1",
             door_w="EXITDOOR", door_c="FLAT1", track_w="DOORTRAK",

             inside_h=80, door_h=72,
             switch_yo=0,
             door_kind=1, tag=0, switch_kind=11
           },
  },

  exit_deathmatch_METAL =
  {
    prefab = "EXIT_DEATHMATCH",

    skin = { wall="METAL1", front_w="METAL1",
             floor="FLOOR5_1", ceil="CEIL5_1",
             switch_w="SW1BLUE", side_w="COMPBLUE", switch_f="FLAT14",
             frame_f="FLOOR5_1", frame_c="TLITE6_6", step_w="STEP1",
             door_w="EXITDOOR", door_c="FLAT1", track_w="DOORTRAK",

             inside_h=80, door_h=72,
             switch_yo=56,
             door_kind=1, tag=0, switch_kind=11
           },
  },

  exit_deathmatch_STONE =
  {
    prefab = "EXIT_DEATHMATCH",

    skin = { wall="STONE2", front_w="EXITSTON",
             floor="FLOOR7_2", ceil="FLAT1",
             switch_w="SW1HOT", side_w="SP_HOT1", switch_f="FLAT5_3",
             frame_f="FLOOR5_1", frame_c="TLITE6_6", step_w="STEP1",
             door_w="EXITDOOR", door_c="FLAT1", track_w="DOORTRAK",

             inside_h=80, door_h=72,
             switch_yo=56,
             door_kind=1, tag=0, switch_kind=11
           },
  },
}



DOOM.FACTORY.DM_ROOMS =
{
  PLAIN =
  {
  },

  HALLWAY =
  {
    liquid_prob = 0,

    room_heights = { [96]=50, [128]=50 },
    door_probs   = { out_diff=75, combo_diff=50, normal=5 },
    window_probs = { out_diff=1, combo_diff=1, normal=1 },
    space_range  = { 33, 66 },
  },
 
  SCENIC =
  {
  },

  WAREHOUSE =
  {
    space_range = { 80, 99 },

    pf_count = { 6,12 },

    -- crate it up baby!
    sc_fabs =
    {
      crate_CRATE1 = 50, crate_triple_A = 40,
      crate_CRATE2 = 50, crate_triple_B = 40,
      crate_WIDE = 20,

      crate_rotate_CRATE1 = 10, crate_rot22_CRATE1 = 20,
      crate_rotate_CRATE2 = 20, crate_rot22_CRATE2 = 10,

      other = 20
    },
  },

  WAREHOUSE2 =
  {
  },

}

DOOM.FACTORY.DM_THEMES =
{
--[[  
   (a) nature  (outdoor, grassy/rocky/muddy, water)
   (b) urban   (outdoor, bricks/concrete,  slime)

   (c) gothic     (indoor, gstone, blood, castles) 
   (d) tech       (indoor, computers, lights, lifts) 
   (e) cave       (indoor, rocky/ashy, darkness, lava)
   (f) industrial (indoor, machines, lifts, crates, nukage)

   (h) hell    (indoor+outdoor, fire/lava, bodies, blood)
--]]

  URBAN =
  {
    room_probs=
    {
      PLAIN=40, WAREHOUSE2=10, WAREHOUSE=10, PRISON=5,
    },

    exit_probs=
    {
      STONE=70, BROWN=50,
    },

    monster_prefs =
    {
      zombie=2.0, shooter=2.0, gunner=2.0,
    },
  },


  INDUSTRIAL =
  {
    room_probs=
    {
      PLAIN=30, PLANT=90, WAREHOUSE=50, COMPUTER=5,
    },

    exit_probs=
    {
      BROWN=50, TECH=20, STONE=10, BLUE=5,
    },

    monster_prefs =
    {
      caco=2.0, barrel=4.0,
    },
  },


  TECH =
  {
    room_probs=
    {
      PLAIN=20, COMPUTER=25, WAREHOUSE=5,
    },

    exit_probs=
    {
      TECH=50, BLUE=50, STARTAN=50, BROWN=5,
    },

    monster_prefs =
    {
      zombie=2.0, shooter=2.0, gunner=2.0,
      barrel=2.7,
    },
  },


  NATURE =
  {
    room_probs=
    {
      PLAIN=50,
    },

    exit_probs=
    {
      STONE=40, BROWN=20,
    },

    monster_prefs =
    {
      demon=2.5, knight=2.0, baron=2.0, pain=2.0,
      barrel=0.5,
    },

    door_probs   = { out_diff=75, combo_diff=10, normal=5 },
    window_probs = { out_diff=75, combo_diff=40, normal=40 },
    space_range  = { 50, 90 },

    prefer_stairs = true,
    trim_mode = "rough_hew",
  },


  CAVE =
  {
    room_probs=
    {
      PLAIN=25, WAREHOUSE2=10, TORTURE=5, PRISON=20
    },

    exit_probs=
    {
      BROWN=50, STONE=10,
    },

    room_heights = { [96]=50, [128]=50 },

    monster_prefs =
    {
      imp=3.0, skull=2.0, revenant=2.0,
      barrel=0.5,
    },

    diff_probs = { [0]=10, [16]=40, [32]=80, [64]=60, [96]=20 },
    bump_probs = { [0]=5, [16]=30, [32]=30, [64]=20 },
    door_probs   = { out_diff=10, combo_diff= 3, normal=1 },
    window_probs = { out_diff=20, combo_diff=30, normal=5 },
    space_range  = { 1, 50 },

    prefer_stairs = true,
    trim_mode = "rough_hew",
  },


  HELL =
  {
    room_probs=
    {
      PLAIN=20, TORTURE=25, PRISON=10,
    },

    exit_probs=
    {
      STONE=10, BROWN=10, BLOODY=50,
    },

    monster_prefs =
    {
      zombie=0.2, shooter=0.5, gunner=0.5,
      spectre=2.0, vile=2.0, arach=2.0,
    },
  },


  WOLF =
  {
    room_probs=
    {
      PLAIN=50,
    },

    monster_prefs =
    {
      -- the SS guard normally has a very low probability, hence
      -- we need a very large multiplier to make him dominant.
      ss_dude=5000,
    },
  },
}

DOOM.FACTORY.DM_QUEST_LEN_PROBS =
{
  ----------  2   3   4   5   6   7   8  9  10  -------

  key    = {  0, 17, 50, 90, 65, 30, 10, 2 },
  exit   = {  0, 17, 50, 90, 65, 30, 10, 2 },

  switch = {  0, 50, 90, 50, 25, 5, 1 },

  weapon = { 25, 90, 50, 10, 2 },
  item   = { 15, 70, 70, 15, 2 },
}


------------------------------------------------------------

-- Monster list
-- ============
--
-- r  : radius
-- h  : height
-- hp : health-points
-- dm : damage can inflict per second (rough approx)
-- fp : firepower needed by player

DOOM.FACTORY.DM_MONSTERS =
{
  -- FIXME: probs for CLOSET/DEPOT
  zombie    = { prob=60, hp=20,  dm=4,  fp=1.0, cage_fallback=14, hitscan=true, },
  shooter   = { prob=40, hp=30,  dm=10, fp=1.3, cage_prob= 8, hitscan=true, },

  imp       = { prob=80, hp=60,  dm=20, fp=1.6, cage_prob=50, },
  caco      = { prob=80, hp=400, dm=45, fp=2.0, cage_prob=14, float=true },
  baron     = { prob=50, hp=1000,dm=45, fp=3.8, cage_prob= 3, },

  -- MELEE only monsters
  demon     = { prob=45, hp=150, dm=25, fp=2.3, cage_prob=66,melee=true },
  spectre   = { prob=20, hp=150, dm=25, fp=2.3, cage_prob=40,melee=true },
  skull     = { prob=14, hp=100, dm=7,  fp=2.6, cage_prob= 2, melee=true, float=true },
 
  barrel    = { prob=17, hp=10,  dm=2,  fp=1.0, melee=true, passive=true },
}

DOOM.FACTORY.DM_BOSSES =
{
  -- special monsters (only for boss levels)
  cyber     = { hp=4000,dm=150, fp=4.0 },
  spider    = { hp=3000,dm=200, fp=4.0, hitscan=true },

  -- FIXME: added just for kicks
  keen = { hp=300, dm=1, fp=2.0 },
}

DOOM.FACTORY.D2_MONSTERS =
{
  gunner    = { prob=17, hp=70,  dm=40, fp=2.5, hitscan=true, cage_prob=70, },
  ss_dude   = { prob=0.1,hp=50,  dm=15, fp=2.4, hitscan=true, cage_prob=1 },

  revenant  = { prob=70, hp=300, dm=55, fp=2.9, cage_prob=50, },
  knight    = { prob=70, hp=500, dm=45, fp=2.9, cage_prob=50, },
  mancubus  = { prob=95, hp=600, dm=80, fp=3.5, cage_prob=88, },

  arach     = { prob=36, hp=500, dm=70, fp=2.5, cage_prob=95, },
  vile      = { prob=20, hp=700, dm=50, fp=3.7, cage_prob=12, hitscan=true },
  pain      = { prob=14, hp=400, dm=88, fp=3.0, float=true },
}

DOOM.FACTORY.DM_MONSTER_GIVE =
{
  zombie   = { { ammo="bullet", give=10 } },
  shooter  = { { weapon="shotty" } },
  gunner   = { { weapon="chain" } }
}

-- Weapon list
-- ===========
--
-- fp   : firepower level
-- per  : ammo per shot
-- rate : firing rate (shots per second)
-- dm   : damage can inflict per shot
-- freq : usage frequency (in the ideal)
-- held : already held at level start

DOOM.FACTORY.DM_WEAPONS =
{
  fist    = { fp=0, melee=true, rate=1.5, dm=10, freq=0.1, held=true },

  saw     = { fp=1, melee=true, rate=8.7, dm=10, freq=3 },
  berserk = { fp=1, melee=true, rate=1.5, dm=50, freq=6 },

  pistol  = { fp=1, ammo="bullet",         per=1, rate=1.8, dm=10 , freq=10, held=true },
  shotty  = { fp=2, ammo="shell",  give=8, per=1, rate=0.9, dm=70 , freq=81 },

  super   = { fp=3, ammo="shell",  give=8, per=2, rate=0.6, dm=170, freq=50 },
  chain   = { fp=3, ammo="bullet", give=20,per=1, rate=8.5, dm=10 , freq=91 },

  launch  = { fp=4, ammo="rocket", give=2, per=1, rate=1.7, dm=90,  freq=50, dangerous=true },
  plasma  = { fp=4, ammo="cell",   give=40,per=1, rate=11,  dm=22 , freq=80 },
  bfg     = { fp=5, ammo="cell",   give=40,per=40,rate=0.8, dm=450, freq=30 },

  -- Note: Berserk is not really an extra weapon, but a powerup
  -- which makes fist do much more damage.  The effect lasts till
  -- the end of the level, so a weapon is a pretty good fit.
}

-- sometimes a certain weapon is preferred against a certain monster.
-- These values are multiplied with the weapon's "freq" field.

DOOM.FACTORY.DM_MONSTER_WEAPON_PREFS =
{
  zombie  = { shotty=6.0 },
  shooter = { shotty=6.0 },
  imp     = { shotty=6.0 },
  demon   = { super=3.0, launch=0.3 },
  spectre = { super=3.0, launch=0.3 },

  pain    = { launch=0.1 },
  skull   = { launch=0.1 },

  cyber   = { launch=3.0, bfg=6.0 },
  spider  = { launch=3.0, bfg=9.0 },
}


-- Pickup List
-- ===========

DOOM.FACTORY.DM_PICKUPS =
{
  bullets    = { stat="bullet", give=10, prob=10 },
  bullet_box = { stat="bullet", give=50, prob=70, clu_max=1 },
  shells     = { stat="shell",  give= 4, prob=30 },
  shell_box  = { stat="shell",  give=20, prob=70, clu_max=3 },

  rockets    = { stat="rocket", give= 1, prob=20 },
  rocket_box = { stat="rocket", give= 5, prob=70, clu_max=1 },
  cells      = { stat="cell",   give=20, prob=30 },
  cell_pack  = { stat="cell",   give=100,prob=70, clu_max=1 },

  potion   = { stat="health", give=1,  prob=20 },
  stimpack = { stat="health", give=10, prob=40 },
  medikit  = { stat="health", give=25, prob=70, clu_max=1 },
  soul     = { stat="health", give=100,prob=15, clu_max=1, limit=200 },

  -- BERSERK and MEGA are quest items

  helmet      = { stat="armor", give=   1, limit=200 },
  green_armor = { stat="armor", give= 100, limit=100, clu_max=1 },
  blue_armor  = { stat="armor", give= 200, limit=200, clu_max=1 },

  -- Note: armor is handled with special code, since
  --       BLUE ARMOR is a quest item.

  -- Note 2: the BACKPACK is a quest item
}

DOOM.FACTORY.DM_NICENESS =
{
  w1 = { weapon="shotty", quest=1, prob=70, always=true  },
  w2 = { weapon="chain",  quest=3, prob=20, always=false },
  w3 = { weapon="plasma", quest=5, prob=35, always=true  },

  p1 = { pickup="green_armor", prob=2.0 },
}


-- DeathMatch stuff
-- ================

DOOM.FACTORY.DM_DEATHMATCH =
{
  weapons =
  {
    shotty=60, super=40, chain=40, launch=40,
    plasma=20, saw=10, bfg=3
  },

  health =
  { 
    potion=30, stimpack=60, medikit=20,
    helmet=20
  },

  ammo =
  { 
    bullets=5,  bullet_box=30,
    shells=60,  shell_box=5,
    rockets=10, rocket_box=20,
    cells=40,   cell_pack=1,
  },

  items =
  {
    invis=40, goggle=10, berserk=50,
    soul=5, green_armor=40, blue_armor=5,
  },

  max_clu =
  {
    potion = 8, helmet = 8,
    stimpack = 4, medikit = 2,
    bullets = 4, shells = 4,
    rockets = 4,
  },

  min_clu =
  {
    potion = 3, helmet = 3,
    bullets = 2, rockets = 2,
  },
}

DOOM.FACTORY.DM_INITIAL_MODEL =
{
  doomguy =
  {
    -- Note: bullet numbers are understated (should be 50)
    -- so that the player isn't forced to empty the pistol.

    health=100, armor=0,
    bullet=20, shell=0, rocket=0, cell=0,
    fist=true, pistol=true,
  }
}

DOOM.FACTORY.DM_THINGS =
{
  --- PLAYERS ---

  player1 = { id=1, kind="other", r=16,h=56 },
  player2 = { id=2, kind="other", r=16,h=56 },
  player3 = { id=3, kind="other", r=16,h=56 },
  player4 = { id=4, kind="other", r=16,h=56 },

  dm_player     = { id=11, kind="other", r=16,h=56 },
  teleport_spot = { id=14, kind="other", r=16,h=56 },

  --- MONSTERS ---

  zombie    = { id=3004,kind="monster", r=20,h=56 },
  shooter   = { id=9,   kind="monster", r=20,h=56 },
  gunner    = { id=65,  kind="monster", r=20,h=56 },
  imp       = { id=3001,kind="monster", r=20,h=56 },

  caco      = { id=3005,kind="monster", r=31,h=56 },
  revenant  = { id=66,  kind="monster", r=20,h=64 },
  knight    = { id=69,  kind="monster", r=24,h=64 },
  baron     = { id=3003,kind="monster", r=24,h=64 },

  mancubus  = { id=67,  kind="monster", r=48,h=64 },
  arach     = { id=68,  kind="monster", r=66,h=64 },
  pain      = { id=71,  kind="monster", r=31,h=56 },
  vile      = { id=64,  kind="monster", r=20,h=56 },
  demon     = { id=3002,kind="monster", r=30,h=56 },
  spectre   = { id=58,  kind="monster", r=30,h=56 },
  skull     = { id=3006,kind="monster", r=16,h=56 },

  spider    = { id=7,  kind="monster", r=128,h=100 },
  cyber     = { id=16, kind="monster", r=40, h=110 },
  ss_dude   = { id=84, kind="monster", r=20, h=56 },
  keen      = { id=72, kind="monster", r=16, h=72, ceil=true },

  --- PICKUPS ---

  k_red     = { id=38, kind="pickup", r=20,h=16, pass=true },
  k_yellow  = { id=39, kind="pickup", r=20,h=16, pass=true },
  k_blue    = { id=40, kind="pickup", r=20,h=16, pass=true },

  kc_blue   = { id=5,  kind="pickup", r=20,h=16, pass=true },
  kc_yellow = { id=6,  kind="pickup", r=20,h=16, pass=true },
  kc_red    = { id=13, kind="pickup", r=20,h=16, pass=true },

  shotty = { id=2001, kind="pickup", r=20,h=16, pass=true },
  super  = { id=  82, kind="pickup", r=20,h=16, pass=true },
  chain  = { id=2002, kind="pickup", r=20,h=16, pass=true },
  launch = { id=2003, kind="pickup", r=20,h=16, pass=true },
  plasma = { id=2004, kind="pickup", r=20,h=16, pass=true },
  saw    = { id=2005, kind="pickup", r=20,h=16, pass=true },
  bfg    = { id=2006, kind="pickup", r=20,h=16, pass=true },

  backpack = { id=   8, kind="pickup", r=20,h=16, pass=true },
  mega     = { id=  83, kind="pickup", r=20,h=16, pass=true },
  invul    = { id=2022, kind="pickup", r=20,h=16, pass=true },
  berserk  = { id=2023, kind="pickup", r=20,h=16, pass=true },
  invis    = { id=2024, kind="pickup", r=20,h=16, pass=true },
  suit     = { id=2025, kind="pickup", r=20,h=60, pass=true },
  map      = { id=2026, kind="pickup", r=20,h=16, pass=true },
  goggle   = { id=2045, kind="pickup", r=20,h=16, pass=true },

  potion   = { id=2014, kind="pickup", r=20,h=16, pass=true },
  stimpack = { id=2011, kind="pickup", r=20,h=16, pass=true },
  medikit  = { id=2012, kind="pickup", r=20,h=16, pass=true },
  soul     = { id=2013, kind="pickup", r=20,h=16, pass=true },

  helmet      = { id=2015, kind="pickup", r=20,h=16, pass=true },
  green_armor = { id=2018, kind="pickup", r=20,h=16, pass=true },
  blue_armor  = { id=2019, kind="pickup", r=20,h=16, pass=true },

  bullets    = { id=2007, kind="pickup", r=20,h=16, pass=true },
  bullet_box = { id=2048, kind="pickup", r=20,h=16, pass=true },
  shells     = { id=2008, kind="pickup", r=20,h=16, pass=true },
  shell_box  = { id=2049, kind="pickup", r=20,h=16, pass=true },
  rockets    = { id=2010, kind="pickup", r=20,h=16, pass=true },
  rocket_box = { id=2046, kind="pickup", r=20,h=16, pass=true },
  cells      = { id=2047, kind="pickup", r=20,h=16, pass=true },
  cell_pack  = { id=  17, kind="pickup", r=20,h=16, pass=true },


  --- SCENERY ---

  -- lights --
  lamp         = { id=2028,kind="scenery", r=16,h=48, light=255, },
  mercury_lamp = { id=85,  kind="scenery", r=16,h=80, light=255, },
  short_lamp   = { id=86,  kind="scenery", r=16,h=60, light=255, },
  tech_column  = { id=48,  kind="scenery", r=16,h=128,light=255, },

  candle         = { id=34, kind="scenery", r=16,h=16, light=111, pass=true },
  candelabra     = { id=35, kind="scenery", r=16,h=56, light=255, },
  burning_barrel = { id=70, kind="scenery", r=16,h=44, light=255, },

  blue_torch     = { id=44, kind="scenery", r=16,h=96, light=255, },
  blue_torch_sm  = { id=55, kind="scenery", r=16,h=72, light=255, },
  green_torch    = { id=45, kind="scenery", r=16,h=96, light=255, },
  green_torch_sm = { id=56, kind="scenery", r=16,h=72, light=255, },
  red_torch      = { id=46, kind="scenery", r=16,h=96, light=255, },
  red_torch_sm   = { id=57, kind="scenery", r=16,h=72, light=255, },

  -- decoration --
  barrel = { id=2035, kind="scenery", r=12, h=44 },

  green_pillar     = { id=30, kind="scenery", r=16,h=56, },
  green_column     = { id=31, kind="scenery", r=16,h=40, },
  green_column_hrt = { id=36, kind="scenery", r=16,h=56, add_mode="island" },

  red_pillar     = { id=32, kind="scenery", r=16,h=52, },
  red_column     = { id=33, kind="scenery", r=16,h=56, },
  red_column_skl = { id=37, kind="scenery", r=16,h=56, add_mode="island" },

  burnt_tree = { id=43, kind="scenery", r=16,h=56, add_mode="island" },
  brown_stub = { id=47, kind="scenery", r=16,h=56, add_mode="island" },
  big_tree   = { id=54, kind="scenery", r=31,h=120,add_mode="island" },

  -- gore --
  evil_eye    = { id=41, kind="scenery", r=16,h=56, add_mode="island" },
  skull_rock  = { id=42, kind="scenery", r=16,h=48, },
  skull_pole  = { id=27, kind="scenery", r=16,h=52, },
  skull_kebab = { id=28, kind="scenery", r=20,h=64, },
  skull_cairn = { id=29, kind="scenery", r=20,h=40, add_mode="island" },

  impaled_human  = { id=25,kind="scenery", r=20,h=64, },
  impaled_twitch = { id=26,kind="scenery", r=16,h=64, },

  gutted_victim1 = { id=73, kind="scenery", r=16,h=88, ceil=true },
  gutted_victim2 = { id=74, kind="scenery", r=16,h=88, ceil=true },
  gutted_torso1  = { id=75, kind="scenery", r=16,h=64, ceil=true },
  gutted_torso2  = { id=76, kind="scenery", r=16,h=64, ceil=true },
  gutted_torso3  = { id=77, kind="scenery", r=16,h=64, ceil=true },
  gutted_torso4  = { id=78, kind="scenery", r=16,h=64, ceil=true },

  hang_arm_pair  = { id=59, kind="scenery", r=20,h=84, ceil=true, pass=true },
  hang_leg_pair  = { id=60, kind="scenery", r=20,h=68, ceil=true, pass=true },
  hang_leg_gone  = { id=61, kind="scenery", r=20,h=52, ceil=true, pass=true },
  hang_leg       = { id=62, kind="scenery", r=20,h=52, ceil=true, pass=true },
  hang_twitching = { id=63, kind="scenery", r=20,h=68, ceil=true, pass=true },

  gibs          = { id=24, kind="scenery", r=20,h=16, pass=true },
  gibbed_player = { id=10, kind="scenery", r=20,h=16, pass=true },
  pool_blood_1  = { id=79, kind="scenery", r=20,h=16, pass=true },
  pool_blood_2  = { id=80, kind="scenery", r=20,h=16, pass=true },
  pool_brains   = { id=81, kind="scenery", r=20,h=16, pass=true },

  -- Note: id=12 exists, but is exactly the same as id=10

  dead_player  = { id=15, kind="scenery", r=16,h=16, pass=true },
  dead_zombie  = { id=18, kind="scenery", r=16,h=16, pass=true },
  dead_shooter = { id=19, kind="scenery", r=16,h=16, pass=true },
  dead_imp     = { id=20, kind="scenery", r=16,h=16, pass=true },
  dead_demon   = { id=21, kind="scenery", r=16,h=16, pass=true },
  dead_caco    = { id=22, kind="scenery", r=16,h=16, pass=true },
  dead_skull   = { id=23, kind="scenery", r=16,h=16, pass=true },
}

DOOM.FACTORY.D2_COMBOS =
{
  ---- URBAN ------------

  URBAN_PANEL =
  {
    theme_probs = { URBAN=50 },
    mat_pri = 6,

    wall  = "PANEL7",
    floor = "FLOOR5_4",
    ceil  = "CEIL1_2",

    step = "STEP2",
    pillar = "PANBLUE",
    pic_wd = "SPACEW3",

    scenery = { candelabra=6, evil_eye=3 },

    -- FIXME: 'LIBRARY" room type
    sc_fabs = { bookcase_WIDE=50, other=30 },

    wall_fabs = { solid_PANEL8=30, solid_PANEL9=30, other=50 },
  },

  URBAN_BRICK =
  {
    theme_probs = { URBAN=30 },
    mat_pri = 6,

    wall  = "BRICK7",
    floor = "FLOOR0_7",
    ceil  = "CEIL5_2",

    step = "STEP1",
    pillar = "BRICKLIT",
    pic_wd = "BRWINDOW",

    scenery = { red_torch=5, red_torch_sm=3 },
    bad_liquid = "slime",
  },

  URBAN_BRICK2 =
  {
    theme_probs = { URBAN=20 },
    mat_pri = 6,

    wall = "BIGBRIK1",
    void = "BIGBRIK3",
    step = "STEP1",
    pillar = "BRICK12",

    floor = "RROCK12",
    ceil = "FLAT1",

    scenery = { green_torch=5, green_torch_sm=3 },
  },

  URBAN_STUCCO =
  {
    theme_probs = { URBAN=30 },
    mat_pri = 2,

    wall  = "STUCCO3",
    floor = "FLAT8",
    ceil  = "CEIL3_5",

    sc_fabs = { pillar_PANBLUE=20, pillar_PANRED=20, other=70 },

    wall_fabs = { solid_STUCCO2=30, other=60 },
  },

  URBAN_GREENBRK =
  {
    theme_probs = { URBAN=40 },
    outdoor = true,
    mat_pri = 2,

    wall  = "BRICK10",
    floor = "RROCK14",
    ceil  = "GRNROCK",

    step  = "STEP5",  -- BIGBRIK1
  },

  URBAN_BLACK =
  {
    theme_probs = { URBAN=20 },
    outdoor = true,
    mat_pri = 6,

    wall  = "BLAKWAL1",
    floor = "MFLR8_4",
    ceil  = "MFLR8_4",

    step = "STEP4",

    piller = "STONE5",
    pic_wd = "MODWALL2", pic_wd_h = 64,  -- FIXME

    scenery = { skull_rock=5, brown_stub=3, evil_eye=5 },
  },

  ---- INDUSTRIAL ------------

  INDY_STONE4 =
  {
    theme_probs = { INDUSTRIAL=15 },
    mat_pri = 2,

    wall  = "STONE4",
    floor = "FLAT5_5",
    ceil  = "FLAT1",

    step  = "STEP1",
  },

  ---- TECH -----------------

  TECH_BLUECARPET =
  {
    theme_probs = { TECH=20 },
    mat_pri = 4,

    wall  = "TEKGREN2",
    floor = "FLOOR1_1",
    ceil  = "FLAT4",

    step = "STEP1",
    pillar = "TEKLITE2",  -- TODO: doom 1: "COMPUTE1"

    pic_wd = "COMPSTA1", pic_wd_h = 64,

    scenery = { mercury_lamp=5, short_lamp=5 },
    bad_liquid = "water",

    sc_fabs = { crate_rotnar_SILVER=30, other=50 },

    wall_fabs = { solid_TEKGREN3=30, solid_TEKGREN4=30, other=30 },
  },

  ---- HELL ----------------

  HELL_MARBLE =
  {
    theme_probs = { HELL=70 },
    mat_pri = 6,

    wall  = "MARBLE2",
    floor = "GRNROCK",
    ceil  = "RROCK04",

    lift = "SKSPINE1",
    lift_floor = "FLAT5_6",

    step = "STEP1",
    pic_wd  = "SP_DUDE1",

    scenery = { red_pillar=5, red_column=5, red_column_skl=5 },

    bad_liquid = "nukage",
    good_liquid = "blood",

    sc_fabs = { pillar_MARBFAC4=30, other=50 },
  },

  HELL_GRAY =
  {
    theme_probs = { HELL=70 },
    mat_pri = 6,

    wall  = "MARBGRAY",
    floor = "DEM1_6",
    ceil  = "CEIL1_1",

    lift = "SKSPINE1",
    lift_floor = "FLAT5_6",

    step = "STEP1",
    pic_wd  = "SP_DUDE1",

    scenery = "red_torch",

    bad_liquid = "nukage",
    good_liquid = "blood",

---   sc_fabs = { pillar_MARBFAC4=30, other=50 },
  },


  ---- CAVE ----------------
  
  CAVE_ASH =
  {
    theme_probs = { CAVE=30 },
    mat_pri = 2,

    wall  = "ASHWALL2",
    floor = "FLOOR6_2",
    ceil  = "FLAT5_8",

    arch  = "arch_russian_WOOD",

    sc_fabs = { stalagmite_MED=40, other=10 },
  },

  CAVE_ZIMMER =
  {
    theme_probs = { CAVE=10 },
    mat_pri = 2,

    wall  = "ZIMMER4",
    floor = "RROCK04",
    ceil  = "RROCK03",

    arch  = "arch_hole",

    sc_fabs = { stalagmite_MED=40, other=10 },
  },

  CAVE_ROCK =
  {
    theme_probs = { CAVE=30 },
    mat_pri = 2,

    wall  = "ROCK2",
    floor = "RROCK13",
    ceil  = "CEIL5_1",

    arch  = "arch_arched",

    sc_fabs = { stalagmite_MED=40, other=10 },
  },

  ----- NATURE -----------------

  NAT_GRASS =
  {
    theme_probs = { NATURE=50 },
    outdoor = true,
    mat_pri = 2,

    wall = "ZIMMER7",
    step = "ASHWALL2",

    floor = "RROCK19",
    ceil  = "RROCK19",

    scenery = "brown_stub",

    bad_liquid = "nukage",

  },

  NAT_SWAMP =
  {
    theme_probs = { NATURE=70 },
    outdoor = true,
    mat_pri = 2,

    wall = "ZIMMER8",
    step = "ASHWALL2",

    floor = "GRASS2",
    ceil  = "GRASS2",

    scenery = "brown_stub",

    bad_liquid = "nukage",
  },

  NAT_TANROCK7 =
  {
    theme_probs = { NATURE=30 },
    outdoor = true,
    mat_pri = 3,

    wall = "TANROCK7",
    void = "ZIMMER4",
    step = "STEP6",
    lift = "SUPPORT3",
    piller = "ASHWALL7",

    floor = "RROCK04",
    ceil  = "RROCK04",
  --  lift_floor = "FLOOR4_8",

    scenery = { burnt_tree=5, big_tree=5 },
    bad_liquid = "slime",
  },

  NAT_TANROCK8 =
  {
    theme_probs = { NATURE=20 },
    outdoor = true,
    mat_pri = 3,

    wall = "TANROCK8",
    void = "ROCK4",
    step = "STEP6",
    lift = "SUPPORT3",

    floor = "RROCK17",
    ceil  = "RROCK17",
  --  lift_floor = "FLOOR4_8",

    scenery = "brown_stub",
    bad_liquid = "slime",
  },

  NAT_MUDDY =
  {
    theme_probs = { NATURE=50 },
    outdoor = true,
    mat_pri = 2,

    wall = "ASHWALL4",
    void = "TANROCK5",
    step = "STEP5",

    floor = "FLAT10",
    ceil  = "FLAT10",

    scenery = "burnt_tree",

    bad_liquid = "slime",
  },


  ---- Wolf3D Secret Levels ----

  WOLF_CELLS =
  {
    mat_pri = 5,

    wall = "ZZWOLF9",
    void = "ZZWOLF9",

    floor = "FLAT1",
    ceil  = "FLAT1",

    theme_probs = { WOLF=50 },
  },

  WOLF_BRICK =
  {
    mat_pri = 6,

    wall = "ZZWOLF11",
    void = "ZZWOLF11",
    -- decorate =  { ZZWOLF12, ZZWOLF13 }

    floor = "FLAT1",
    ceil  = "FLAT1",

    theme_probs = { WOLF=60 },
  },

  WOLF_STONE =
  {
    mat_pri = 4,

    wall = "ZZWOLF1",
    void = "ZZWOLF1",
    -- decorate =  { ZZWOLF2, ZZWOLF3, ZZWOLF4 }

    floor = "FLAT1",
    ceil  = "FLAT1",

    theme_probs = { WOLF=70 },
  },

  WOLF_WOOD =
  {
    mat_pri = 4,

    wall = "ZZWOLF5",
    void = "ZZWOLF5",
    -- decorate =  { ZZWOLF6, ZZWOLF7 }

    ceil  = "CEIL1_1",
    floor = "FLAT5_2",

    theme_probs = { WOLF=30 },
  },
}

DOOM.FACTORY.D2_EXITS =
{
  METAL =
  {
    mat_pri = 8,

    wall = "METAL1",
    void = "METAL5",

    floor = "FLOOR5_1",
    ceil  = "TLITE6_4",

    hole_tex = "LITE3",

    sign = "EXITSIGN",
    sign_ceil="CEIL5_2",

    switch =
    {
      prefab="SWITCH_NICHE_TINY_DEEP",
      add_mode="wall",
      skin =
      {
        switch_w="SW1COMP", switch_h=32,
        frame_w="LITEBLU4", frame_f="FLAT14", frame_c="FLAT14",

        x_offset=16, y_offset=72, kind=11, tag=0,
      }
    },

    door = { wall="EXITDOOR", w=64, h=72,
             frame_ceil="TLITE6_6", frame_floor="FLOOR5_1" },
  },

  REDBRICK =
  {
    mat_pri = 8,

    wall = "BRICK11",
    void = "BRICK11",
    step = "WOOD1",

    floor = "FLAT5_2",
    ceil  = "FLOOR6_2",

    sign = "EXITSIGN",
    sign_ceil="CEIL5_2",

    switch =
    {
      prefab="SWITCH_PILLAR",
      skin =
      {
        switch_w="SW1WOOD", side_w="WOOD1",
        kind=11, tag=0,
      }
    },

    door = { wall="EXITDOOR", w=64, h=72,
             frame_ceil="TLITE6_6", frame_floor="FLAT5_2" },
  },

  SLOPPY =
  {
    small_exit = true,
    mat_pri = 1,

    wall = "SKINMET2",
    void = "SLOPPY1",
    step = "SKINMET2",

    floor = "FWATER1",
    ceil  = "SFLR6_4",

    liquid_prob = 0,

    sign = "EXITSIGN",
    sign_ceil="CEIL5_2",

    switch =
    {
      prefab="SWITCH_FLUSH",
      add_mode="wall",
      skin =
      {
        switch_w="SW1SKULL", wall="SLOPPY1",
        left_w="SK_LEFT", right_w="SK_RIGHT",
        kind=11, tag=0,
      }
    },

    door = { wall="EXITDOOR", w=64, h=72,
             frame_ceil="FLAT5_5", frame_floor="CEIL5_2" },
  },
}

DOOM.FACTORY.D2_HALLWAYS =
{
  PANEL =
  {
    mat_pri = 0,

    wall = "PANEL2",
    void = "PANEL3",
    step = "STEP2",
    pillar = "PANRED",  -- PANEL5

    floor = "FLOOR0_2",
    ceil  = "FLAT5_5",

    theme_probs = { URBAN=70 },
    trim_mode = "guillotine",
  },

  BRICK =
  {
    mat_pri = 0,

    wall = "BIGBRIK1",
    void = "BIGBRIK2",
    step = "STEP4",
    pillar = "STONE3",

    floor = "FLAT5_7",
    ceil  = "FLAT5_4",

    theme_probs = { URBAN=70,NATURE=10,HELL=10 },
    trim_mode = "guillotine",
  },

  BSTONE =
  {
    theme_probs = { URBAN=50,NATURE=50,CAVE=30 },
    mat_pri = 0,

    wall = "BSTONE2",
    floor = "FLAT5",
    ceil  = "FLAT1",

    step = "METAL",
    pillar = "BSTONE3",

    trim_mode = "guillotine",
  },

  WOOD =
  {
    mat_pri = 0,

    wall = "WOODMET1",
    void = "WOOD5",
    step = "STEP5",
    pillar = "WOODMET2",

    floor = "FLAT5_2",
    ceil  = "MFLR8_2",

    theme_probs = { URBAN=30 },
    trim_mode = "guillotine",
  },

  METAL =
  {
    mat_pri = 0,

    wall = "METAL3",
    void = "METAL2",
    step = "STEP5",
    pillar = "SW1SATYR",

    floor = "FLAT5_5",
    ceil  = "CEIL5_1",

    theme_probs = { INDUSTRIAL=70,TECH=30 },
    trim_mode = "guillotine",
  },

  TEKGREN =
  {
    mat_pri = 0,

    wall = "TEKGREN2",
    floor = "FLOOR3_3",
    ceil  = "GRNLITE1",

    step = "STEP2",
    pillar = "TEKGREN3",  -- was: "BRONZE2"

    well_lit = true,

    theme_probs = { TECH=80,INDUSTRIAL=40 },
    trim_mode = "guillotine",

    wall_fabs = { solid_TEKGREN5=30, other=50 },
  },

  PIPES =
  {
    mat_pri = 0,

    wall = "PIPEWAL2",
    void = "PIPEWAL1",
    step = "STEP4",
    pillar = "STONE4",

    floor = "FLAT5_4",
    ceil  = "FLAT5_4",

    theme_probs = { INDUSTRIAL=70 },
    trim_mode = "guillotine",
  },
}

DOOM.FACTORY.D2_MATS =
{
  ARCH =
  {
    wall  = "METAL",
    void  = "METAL1",
    floor = "SLIME14",
    ceil  = "SLIME14",
  },
}

DOOM.FACTORY.D2_OVERHANGS =
{
  METAL =
  {
    ceil = "CEIL5_1",
    upper = "METAL6",
    thin = "METAL",
  },

  MARBLE =
  {
    thin = "MARBLE1",
    upper = "MARBLE3",
    ceil = "SLIME13",
  },

  PANEL =
  {
    thin = "PANBORD2",
    thick = "PANBORD1",
    upper = "PANCASE2",
    ceil = "CEIL3_1",
  },

  STONE =
  {
    thin = "STONE4",
    upper = "STONE4",
    ceil = "FLAT5_4",
  },

  STONE2 =
  {
    thin = "STONE6",
    upper = "STONE6",
    ceil = "FLAT5_5",
  },

}

DOOM.FACTORY.D2_DOORS =
{
  d_thin1  = { wall="SPCDOOR1", w=64, h=112 },
  d_thin2  = { wall="SPCDOOR2", w=64, h=112 },
  d_thin3  = { wall="SPCDOOR3", w=64, h=112 },

  d_weird  = { wall="SPCDOOR4", w=64, h=112 },
}

DOOM.FACTORY.D2_CRATES =
{
  MODWALL =
  {
    wall = "MODWALL3", h=64, floor = "FLAT19"
  },
  
  PIPES =
  {
    wall = "PIPES", h=64, floor = "CEIL3_2", can_rotate=true
  },

  SILVER2 =
  {
    wall = "SILVER2", h=64, floor = "FLAT23",
    can_rotate=true, rot_x_offset=0
  },

  SILVER3 =
  {
    wall = "SILVER3", h=128, floor = "FLAT23", can_rotate=true
  },

  TVS =
  {
    wall = "SPACEW3", h=64, floor = "CEIL5_1"
  },
}

DOOM.FACTORY.D2_RAILS =
{
  r_1 = { wall="MIDBARS3", w=128, h=72  },
  r_2 = { wall="MIDGRATE", w=128, h=128 },
}

DOOM.FACTORY.D2_LIGHTS =
{
  green1 = { floor="GRNLITE1", side="TEKGREN2" },
}

DOOM.FACTORY.D2_LIQUIDS =
{
--###  slime = { floor="SLIME01", wall="BLODRIP1", sec_kind=7 }  -- 5% damage
}

DOOM.FACTORY.D2_SCENERY =
{
}

DOOM.FACTORY.D2_SCENERY_PREFABS =
{
  billboard_NAZI =
  {
    prefab = "BILLBOARD",
--  environment = "outdoor",
    add_mode = "extend",

    min_height = 160,

    skin =
    {
      pic_w = "ZZWOLF2", pic_back = "ZZWOLF1",
      pic_f = "FLAT5_4",  pic_h = 128,

      corn_w = "ZZWOLF5", corn_f = "FLAT5_1",
      corn_h = 112,

      step_w = "ZZWOLF5", step_f = "FLAT5_1",
    },

    theme_probs = { WOLF=5 },
  },

  billboard_stilts_FLAGGY =
  {
    prefab = "BILLBOARD_ON_STILTS",
    environment = "outdoor",
    add_mode = "island",
    min_height = 160,

    skin =
    {
      pic_w  = "ZZWOLF12", pic_offset_h = 64,
      beam_w = "WOOD1", beam_f = "FLAT5_2",
    },

    theme_probs = { NATURE=2 },
  },

  pond_small_GRASS =
  {
    prefab = "POND_SMALL",
    environment = "outdoor",
    theme_probs = { NATURE=90 },
    skin = 
    {
      pond_w="ZIMMER4", pond_f="RROCK18",
      outer_w="BROWNHUG", liquid_f="FWATER1",
      kind=0
    },
  },

  rock_pieces_GRNROCK =
  {
    prefab = "ROCK_PIECES",
    environment = "outdoor",
    theme_probs = { NATURE=2 },
    skin = { rock_w="ROCK2", rock_f="GRNROCK", rock_h=16 },
  },

  comp_tall_STATION1 =
  {
    prefab = "COMPUTER_TALL",
    skin   = { comp_w="COMPSTA1", comp_f="FLAT23", side_w="SILVER1" },
  },
 
  comp_tall_STATION2 =
  {
    prefab = "COMPUTER_TALL",
    skin   = { comp_w="COMPSTA2", comp_f="FLAT23", side_w="SILVER1" },
  },
 
  comp_thin_STATION1 =
  {
    prefab = "COMPUTER_TALL_THIN",
    skin   = { comp_w="COMPSTA1", comp_f="FLAT23", side_w="SILVER1" },
  },
 
  comp_thin_STATION2 =
  {
    prefab = "COMPUTER_TALL_THIN",
    skin   = { comp_w="COMPSTA2", comp_f="FLAT23", side_w="SILVER1" },
  },
 
  comp_desk_EW8 =
  {
    prefab = "COMPUTER_DESK",
    add_mode = "extend",
    skin   = { comp_f="CONS1_5", side_w="SILVER1" },
    force_dir = 2,
  },

  comp_desk_EW2 =
  {
    prefab = "COMPUTER_DESK",
    add_mode = "extend",
    skin   = { comp_f="CONS1_1", side_w="SILVER1" },
    force_dir = 8,
  },

  comp_desk_NS6 =
  {
    prefab = "COMPUTER_DESK",
    add_mode = "extend",
    skin   = { comp_f="CONS1_7", side_w="SILVER1" },
    force_dir = 4,
  },

  comp_desk_USHAPE1 =
  {
    prefab = "COMPUTER_DESK_U_SHAPE",
    add_mode = "island",
    skin   =
    {
      comp_Nf="CONS1_1", comp_Wf="CONS1_7",
      comp_Sf="CONS1_5",
      comp_cf="COMP01", side_w ="SILVER1"
    },

--  pickup_specialness = 60,
    force_dir = 2,
  },

  bookcase_WIDE =
  {
    prefab = "BOOKCASE_WIDE",
    skin   = { book_w="PANBOOK", book_f="FLAT5_2", side_w="PANCASE1" },
  },

  drinks_bar_WOOD_POTION =
  {
    prefab = "DRINKS_BAR",
    min_height = 64,

    skin = { bar_w = "PANBORD1", bar_f = "FLAT5_2",
             drink_t = "potion",
           },

    prob = 2,
  },

  crate_WOOD3 =
  {
    prefab = "CRATE_TWO_SIDED",

    skin =
    {
      crate_h = 62,
      crate_w = "WOOD3", crate_w2 = "WOOD3",
      crate_f = "CEIL1_1",
      x_offset = 128,
    }
  },

  crate_WOODSKULL =
  {
    prefab = "CRATE",

    skin =
    {
      crate_h = 62,
      crate_w = "WOOD4",
      crate_f = "CEIL1_1",
    }
  },

  crate_WOODMET1 =
  {
    prefab = "CRATE_TWO_SIDED",

    skin =
    {
      crate_h = 64,
      crate_w = "WOODMET1", crate_w2 = "WOODMET3",
      crate_f = "CEIL5_1",
      x_offset = 0,
    }
  },

  crate_rotate_WOOD3 =
  {
    prefab = "CRATE_ROTATE",

    skin =
    {
      crate_h = 62,
      crate_w = "WOOD3",
      crate_f = "CEIL1_1",
    }
  },

  crate_rot22_WOODMET1 =
  {
    prefab = "CRATE_ROTATE",

    skin =
    {
      crate_h = 64,
      crate_w = "WOODMET1",
      crate_f = "CEIL5_1",
    }
  },

  crate_big_WOOD10 =
  {
    prefab = "CRATE_BIG",
    min_height = 144,

    skin =
    {
      crate_h = 128,
      crate_w = "WOOD10",
      crate_f = "FLAT5_2"
    }
  },

  crate_TV =
  {
    prefab = "CRATE",

    skin =
    {
      crate_h = 64,
      crate_w = "SPACEW3",
      crate_f = "CEIL5_1"
    }
  },

  crate_rotnar_SILVER =
  {
    prefab = "CRATE_ROTATE_NARROW",
    add_mode = "island",

    skin =
    {
      crate_h = 64,
      crate_w = "SILVER2",
      crate_f = "FLAT23"
    }
  },

  pillar_MARBFAC4 =
  {
    prefab = "PILLAR", add_mode = "island",
    environment = "indoor",
    skin = { wall="MARBFAC4" },
  },
  
  pillar_PANBLUE =
  {
    prefab = "PILLAR", add_mode = "island",
    environment = "indoor",
    skin = { wall="PANBLUE" },
  },
 
  pillar_PANRED =
  {
    prefab = "PILLAR", add_mode = "island",
    environment = "indoor",
    skin = { wall="PANRED" },
  },
 
  pillar_PANEL5 =
  {
    prefab = "PILLAR", add_mode = "island",
    environment = "indoor",
    skin = { wall="PANEL5" },
  },
 
  cage_small_METAL =
  {
    prefab = "CAGE_SMALL",
    add_mode = "island",
    min_height = 144,
    is_cage = true,

    skin =
    {
      cage_w = "METAL",
      cage_f = "CEIL5_2",

      rail_w = "MIDBARS3",
    }
  },

  cage_medium_METAL =
  {
    prefab = "CAGE_MEDIUM",
    add_mode = "island",
    is_cage = true,

    skin =
    {
      cage_w = "METAL",
      cage_f = "CEIL5_2",

      rail_w = "MIDBARS3",
    },

    prob = 1,
    force_dir = 2, -- optimisation
  },

}


DOOM.FACTORY.D2_FEATURE_PREFABS =
{
  overhang3_METAL6 =
  {
    prefab = "OVERHANG_3",
    environment = "outdoor",
    add_mode = "island",
    min_height = 128,
    max_height = 320,

    skin =
    {
      beam_w = "METAL",
      hang_u = "METAL6",
      hang_c = "CEIL5_1",
    },

    pickup_specialness = 35,
    theme_probs = { URBAN=30 },
  },

  billboard_stilts4_WREATH =
  {
    prefab = "BILLBOARD_STILTS_HUGE",
    environment = "outdoor",
    add_mode = "island",
    min_height = 160,

    skin =
    {
      pic_w  = "ZZWOLF13", pic_offset_h = 128,
      beam_w = "WOOD1", beam_f = "FLAT5_2",
    },

    theme_probs = { NATURE=3 },
    pickup_specialness = 61,
    force_dir = 2, -- optimisation
  },

  statue_tech1 =
  {
    prefab = "STATUE_TECH_1",
    environment = "indoor",
    min_height = 176,
    max_height = 248,

    skin =
    {
      wall="COMPWERD", floor="FLAT14", ceil="FLOOR4_8",
      step_w="STEP1", carpet_f="FLOOR1_1",
      
      comp_w="SPACEW3", comp2_w="COMPTALL", span_w="COMPSPAN",
      comp_f="CEIL5_1", lite_c="TLITE6_5",

      lamp_t="lamp"
    },
    
    theme_probs = { TECH=80, INDUSTRIAL=20 },
    force_dir = 2, -- optimisation
  },

  statue_tech2 =
  {
    prefab = "STATUE_TECH_2",
    environment = "indoor",
    min_height = 160,
    max_height = 256,

    skin =
    {
      wall="METAL", floor="FLAT23", ceil="FLAT23",
      outer_w="STEP4",

      carpet_f="FLAT14", lite_c="TLITE6_5",

      tv_w="SPACEW3", tv_f="CEIL5_1",
      span_w="COMPSPAN", span_f="FLAT4",
    },

    theme_probs = { TECH=80, INDUSTRIAL=20 },
    force_dir = 2, -- optimisation
  },

  machine_pump1 =
  {
    prefab = "MACHINE_PUMP",
    environment = "indoor",
    add_mode = "island",
    theme_probs = { INDUSTRIAL=80 },

    min_height = 192,
    max_height = 240,

    skin =
    {
      ceil="FLAT1",

      metal3_w="METAL3", metal_f="CEIL5_1",
      metal4_w="METAL4", metal_c="CEIL5_1",
      metal5_w="METAL5",

      pump_w="SPACEW4", pump_c="FLOOR3_3",
      beam_w="DOORSTOP",

      kind=48 -- scroll left
    },

  },

  pillar_double_TEKLITE =
  {
    prefab = "PILLAR_DOUBLE_TECH_LARGE",
    environment = "indoor",
    add_mode = "island",
    min_height = 160,
    theme_probs = { TECH=90 },

    skin =
    {
      outer_f ="FLOOR0_3", outer_w ="STEP4",   outer_lt =160,
      inner_f ="FLOOR0_2", inner_w ="STEP5",   inner_lt =160,
      shine_f ="RROCK03",  shine_w ="METAL6",  shine_lt =160,
      pillar_f="FLOOR7_1", pillar_w="TEKLITE", pillar_lt=240,
      shine_side="METAL2", light_w ="LITEBLU4", kind=8,
    },
  },

  statue_tech_jr_BLUE_METAL =
  {
    prefab = "STATUE_TECH_JR",
    environment = "indoor",
    add_mode = "island",
    min_height = 160,
    max_height = 480,
    theme_probs = { TECH=70 },

    skin =
    {
      outer_f ="CEIL5_1",  outer_w ="METAL5",   outer_lt =176,
      tech_f  ="FLAT14",   tech_w  ="TEKWALL4", tech_lt  =255,
      tech_c  ="FLAT14",   beam_w  ="SUPPORT3",
      lite_f  ="FLAT14",   lite_w  ="LITEBLU4",
      shine_f ="RROCK03",  shine_w ="METAL6",   shine_lt =144,
      shine_side="METAL2", kind=3,
    },
  },

  pond_medium_GRASS =
  {
    prefab = "POND_MEDIUM",
    environment = "outdoor",
    skin = 
    {
      pond_w="BROWNHUG", pond_w2="ZIMMER2",
      pond_f="RROCK18",  pond_f2="RROCK19",
      outer_w="ZIMMER2", liquid_f="FWATER1",
      kind=0
    },
    theme_probs = { NATURE=100 },
  },
  
  pond_large_GRASS =
  {
    prefab = "POND_LARGE",
    environment = "outdoor",
    theme_probs = { NATURE=170 },
    skin = 
    {
      pond_w="ZIMMER2", pond_f="RROCK19",
      outer_w="BROWNHUG", liquid_f="FWATER1",
      kind=0
    },
  },

  four_sided_pic_ADOLF =
  {
    prefab = "WALL_PIC_FOUR_SIDED",
    environment = "outdoor",
    add_mode = "island",
    min_height = 192,

    skin = { pic_w="ZZWOLF7" },
    theme_probs = { WOLF=40, URBAN=5 },
    force_dir = 2, -- optimisation
  },

  skylight_mega_METALWOOD =
  {
    prefab = "SKYLIGHT_MEGA_2",
    environment = "indoor",
    add_mode = "island",
    min_height = 96,

    skin =
    { 
      sky_c = "F_SKY1",
      frame_w = "METAL", frame_c = "CEIL5_2",
      beam_w = "WOOD12", beam_c = "FLAT5_2",
    },

    prob = 10,
  },

  comp_desk_USHAPE2 =
  {
    prefab = "COMPUTER_DESK_HUGE",
    add_mode = "island",
    skin   =
    {
      comp_Nf="CONS1_1", comp_Wf="CONS1_7",
      comp_Sf="CONS1_5",
      comp_cf="COMP01", side_w ="SILVER1"
    },
    pickup_specialness = 60,
    force_dir = 2,
  },

  cage_large_METAL =
  {
    prefab = "CAGE_LARGE",
    add_mode = "island",
    is_cage = true,

    skin =
    {
      cage_w = "METAL",
      cage_f = "CEIL5_2",

      rail_w = "MIDBARS3",
    },

    prob = 1,
    force_dir = 2, -- optimisation
  },

  cage_large_liq_NUKAGE =
  {
    prefab = "CAGE_LARGE_W_LIQUID",
    add_mode = "island",
    min_height = 256,
    is_cage = true,

    skin =
    {
      liquid_f = "NUKAGE1",

      cage_w = "SLADWALL",
      cage_f = "CEIL5_2",
      cage_sign_w = "SLADPOIS",

      rail_w = "MIDBARS3",
    },

    prob = 4,
    force_dir = 2, -- optimisation
  },

  cage_medium_liq_BLOOD =
  {
    prefab = "CAGE_MEDIUM_W_LIQUID",
    add_mode = "island",
    min_height = 160,
    is_cage = true,

    skin =
    {
      liquid_f = "BLOOD1",

      cage_w = "GSTFONT1",
      cage_f = "FLOOR7_2",

      rail_w = "MIDBARS3",
    },

    prob = 2,
    force_dir = 2, -- optimisation
  },

  cage_medium_liq_LAVA =
  {
    prefab = "CAGE_MEDIUM_W_LIQUID",
    add_mode = "island",
    is_cage = true,

    skin =
    {
      liquid_f = "LAVA1",

      cage_w = "BRNPOIS",
      cage_f = "CEIL5_2",

      rail_w = "MIDBARS3",
    },

    prob = 2,
    force_dir = 2, -- optimisation
  },
}

DOOM.FACTORY.D2_WALL_PREFABS =
{
  solid_STUCCO2 =
  {
    prefab = "SOLID", skin = { wall="STUCCO2" },
  },
  
  solid_TEKGREN3 =
  {
    prefab = "SOLID", skin = { wall="TEKGREN3" },
  },
  
  solid_TEKGREN4 =
  {
    prefab = "SOLID", skin = { wall="TEKGREN4" },
  },
  
  solid_TEKGREN5 =
  {
    prefab = "SOLID", skin = { wall="TEKGREN5" },
  },
  
  solid_PANEL8 =
  {
    prefab = "SOLID", skin = { wall="PANEL8" },
  },
  
  solid_PANEL9 =
  {
    prefab = "SOLID", skin = { wall="PANEL9" },
  },
  
  wall_pic_TV =
  {
    prefab = "WALL_PIC",
    min_height = 160,
    skin = { pic_w="SPACEW3", lite_w="SUPPORT2", pic_h=128 },
    theme_probs = { TECH=90, INDUSTRIAL=30 },
  },

  wall_pic_2S_EAGLE =
  {
    prefab = "WALL_PIC_SHALLOW",
    min_height = 160,
    skin = { pic_w="ZZWOLF6", lite_w="LITE5", pic_h=128 },

    theme_probs = { URBAN=8 }, 
  },

  wall_pic_SPDUDE7 =
  {
    prefab = "WALL_PIC",
    min_height = 160,
    skin = { pic_w="SP_DUDE7", pic_h=128 },
  },

  wall_pic_SPDUDE8 =
  {
    prefab = "WALL_PIC",
    min_height = 160,
    skin = { pic_w="SP_DUDE8", pic_h=128 },
  },

  cage_niche_MIDGRATE =
  {
    prefab = "CAGE_NICHE",
---  environment = "indoor",
    add_mode = "wall",
    is_cage = true,

    min_height = 160,

    skin =
    {
      rail_w = "MIDGRATE",
      rail_h = 128,
    },

    prob = 2,
  },
}

DOOM.FACTORY.D2_DOOR_PREFABS =
{
  spacey =
  {
    w=64, h=112, prefab="DOOR_LIT_NARROW",

    skin =
    {
      door_w="SPCDOOR3", door_c="FLAT23",
      lite_w="LITE5", step_w="STEP1",
      frame_f="FLAT1", frame_c="TLITE6_6",
      track_w="DOORTRAK",
      door_h=112,
      door_kind=1, tag=0,
    },

    theme_probs = { TECH=60,INDUSTRIAL=5 },
  },

  wolfy =
  {
    w=128, h=128, prefab="DOOR_WOLFY",

    skin =
    {
      door_w="ZDOORF1", door_c="FLAT23",
      back_w="ZDOORB1", trace_w="ZZWOLF10",
      door_h=128,
      door_kind=1, tag=0,
    },

    theme_probs = { WOLF=50 },
  },
}

DOOM.FACTORY.D2_MISC_PREFABS =
{
  fence_wire_STD =
  {
    prefab = "FENCE_RAIL",
    skin = { rail_w="MIDBARS3" },
  },
  
  exit_hole_SKY =
  {
    prefab = "EXIT_HOLE_ROUND",
    add_mode = "island",

    skin =
    {
      hole_f="F_SKY1",
      walk_kind = 52  -- exit_W1
    },

--FIXME  HOLE.is_cage = true  -- don't place items/monsters here
  },

  end_switch_667 =
  {
    prefab = "DOOM2_667_END_SWITCH",
    add_mode = "island",

    skin =
    {
      switch_w="SW1SKIN", switch_f="SFLR6_4",
      kind=9, tag=667,
    }
  },
}

DOOM.FACTORY.D2_ROOMS =
{
  PLANT =
  {
    sc_fabs =
    {
      crate_TV = 50,
      comp_desk_EW8 = 30,
      comp_desk_EW2 = 30,
      comp_desk_NS6 = 30,
      comp_desk_USHAPE1 = 20,
      other = 30
    },

    wall_fabs =
    {
      wall_pic_TV = 30, 
      other = 100
    },
  },

  COMPUTER =
  {
    pf_count = { 2,4 },

    sc_fabs =
    {
      comp_tall_STATION1 = 10, comp_tall_STATION2 = 10,
      comp_thin_STATION1 = 30, comp_thin_STATION2 = 30,

      other = 50
    },

    wall_fabs =
    {
      wall_pic_TV = 30, 
      other = 100
    },
  },

  TORTURE =
  {
    space_range = { 60, 90 },

    sc_count = { 6,16 },

    scenery =
    {
      impaled_human  = 40, impaled_twitch = 40,
      gutted_victim1 = 40, gutted_victim2 = 40,
      gutted_torso1  = 40, gutted_torso2  = 40,
      gutted_torso3  = 40, gutted_torso4  = 40,

      hang_arm_pair  = 40, hang_leg_pair  = 40,
      hang_leg_gone  = 40, hang_leg       = 40,
      hang_twitching = 40,

---   pool_blood_1  = 10, pool_blood_2  = 10, pool_brains = 10,

      other = 50
    },

    sc_fabs =
    {
      pillar_SPDUDE5=30, other=50
    },

    wall_fabs =
    {
      cage_niche_MIDGRATE = 50,
      wall_pic_SPDUDE1 = 20, wall_pic_SPDUDE2 = 20,
      wall_pic_SPDUDE7 = 30, wall_pic_SPDUDE8 = 30,

      other = 50
    },
  },

  PRISON =
  {
    space_range = { 40, 80 },

    sc_fabs =
    {
      cage_pillar_METAL=50, other=10
    },

    wall_fabs =
    {
      cage_niche_MIDGRATE = 50, other = 10
    },
  },

  WAREHOUSE2 =
  {
    space_range = { 80, 99 },

    pf_count = { 5,10 },

    -- crate it up baby!
    sc_fabs =
    {
      crate_WOOD3 = 50,
      crate_WOODMET1 = 40,
      crate_WOODSKULL = 30,
      crate_big_WOOD10 = 25,

      crate_rotate_WOOD3 = 10,
      crate_rot22_WOODMET1 = 15,

      other = 20
    },
  },

  -- TODO: check in-game level names for ideas
}

DOOM.FACTORY.D2_THEMES =
{
}

------------------------------------------------------------

DOOM.FACTORY.D2_QUESTS =
{
  key =
  {
    k_blue=50, k_red=50, k_yellow=50
  },

  switch =
  {
    sw_blue=50, sw_hot=30,
    sw_vine=10, -- sw_skin=40,
    sw_metl=50, sw_gray=20,
    -- FIXME: sw_rock=10,
    -- FIXME: sw_wood=30, 
  },

  weapon =
  {
    saw=10, super=40, launch=80, plasma=60, bfg=5
  },

  item =
  {
    blue_armor=40, invis=40, mega=25, backpack=25,
    berserk=20, goggle=5, invul=2, map=3
  },
}

DOOM.FACTORY.D2_EPISODE_THEMES =
{
  { URBAN=4, INDUSTRIAL=3, TECH=3, NATURE=9, CAVE=2, HELL=2 },
  { URBAN=9, INDUSTRIAL=5, TECH=7, NATURE=4, CAVE=2, HELL=4 },
  { URBAN=3, INDUSTRIAL=2, TECH=5, NATURE=3, CAVE=6, HELL=8 },

  -- this entry used for a single episode or level
  { URBAN=5, INDUSTRIAL=4, TECH=6, NATURE=5, CAVE=4, HELL=6 },
}

DOOM.FACTORY.D2_SECRET_KINDS =
{
  MAP31 = "wolfy",
  MAP32 = "wolfy",
}

DOOM.FACTORY.D2_SECRET_EXITS =
{
  MAP15 = true,
  MAP31 = true,
}

DOOM.FACTORY.D2_LEVEL_BOSSES =
{
  MAP07 = "mancubus",
  MAP20 = "spider",
  MAP30 = "boss_brain",
  MAP32 = "keen",
}

DOOM.FACTORY.D2_SKY_INFO =
{
  { color="brown",  light=192 },
  { color="gray",   light=192 }, -- bright clouds + dark buildings
  { color="red",    light=192 },
}

DOOM.FACTORY.D2_EPISODE_INFO =
{
  { start=1,  len=11 },
  { start=12, len=11 },  -- last two are MAP31, MAP32
  { start=21, len=10 },
}

function doom2_get_levels(episode)

  assert(GAME.sky_info)

  local level_list = {}

  local theme_probs = DOOM.FACTORY.D2_EPISODE_THEMES[episode]
  if SETTINGS.length ~= "full" then
    theme_probs = DOOM.FACTORY.D2_EPISODE_THEMES[4]
  end
  assert(theme_probs)

  local ep_start  = DOOM.FACTORY.D2_EPISODE_INFO[episode].start
  local ep_length = DOOM.FACTORY.D2_EPISODE_INFO[episode].len

  for map = 1,ep_length do
    local Level =
    {
      name = string.format("MAP%02d", ep_start + map-1),

      episode   = episode,
      ep_along  = map,
      ep_length = ep_length,

      theme_probs = theme_probs,

      -- allow TNT and Plutonia to override the sky stuff
      sky_info = GAME.sky_info[episode],

      toughness_factor = 1 + 1.5 * (map-1) / (ep_length-1),
    }

    -- fixup for secret levels
    if episode == 2 and map >= 10 then
      Level.name = string.format("MAP%02d", 21+map)
      Level.sky_info = DOOM.FACTORY.D2_SKY_INFO[3]
      Level.theme_probs = { WOLF=10 }
      Level.toughness_factor = 1.2
    end

---!!! Level.boss_kind   = DOOM.FACTORY.D2_LEVEL_BOSSES[Level.name]
    Level.secret_kind = DOOM.FACTORY.D2_SECRET_KINDS[Level.name]
    Level.secret_exit = DOOM.FACTORY.D2_SECRET_EXITS[Level.name]

    std_decide_quests(Level, DOOM.FACTORY.D2_QUESTS, DM_QUEST_LEN_PROBS)

    table.insert(level_list, Level)
  end

  return level_list
end


------------------------------------------------------------

GAME_FACTORIES["doom2"] = function()

  local T = doom_common_factory()

  T.episodes   = 3
  T.level_func = doom2_get_levels

  T.quests   = DOOM.FACTORY.D2_QUESTS
  T.sky_info = DOOM.FACTORY.D2_SKY_INFO

  T.themes   = copy_and_merge(T.themes,   DOOM.FACTORY.D2_THEMES)
  T.rooms    = copy_and_merge(T.rooms,    DOOM.FACTORY.D2_ROOMS)
  T.monsters = copy_and_merge(T.monsters, DOOM.FACTORY.D2_MONSTERS)

  T.combos   = copy_and_merge(T.combos,   DOOM.FACTORY.D2_COMBOS)
  T.hallways = copy_and_merge(T.hallways, DOOM.FACTORY.D2_HALLWAYS)
  T.exits    = copy_and_merge(T.exits,    DOOM.FACTORY.D2_EXITS)

  T.rails = DOOM.FACTORY.D2_RAILS

  T.hangs   = copy_and_merge(T.hangs,   DOOM.FACTORY.D2_OVERHANGS)
  T.crates  = copy_and_merge(T.crates,  DOOM.FACTORY.D2_CRATES)
  T.mats    = copy_and_merge(T.mats,    DOOM.FACTORY.D2_MATS)
  T.doors   = copy_and_merge(T.doors,   DOOM.FACTORY.D2_DOORS)
  T.lights  = copy_and_merge(T.lights,  DOOM.FACTORY.D2_LIGHTS)
  T.liquids = copy_and_merge(T.liquids, DOOM.FACTORY.D2_LIQUIDS)

  T.sc_fabs   = copy_and_merge(T.sc_fabs,   DOOM.FACTORY.D2_SCENERY_PREFABS)
  T.feat_fabs = copy_and_merge(T.feat_fabs, DOOM.FACTORY.D2_FEATURE_PREFABS)
  T.wall_fabs = copy_and_merge(T.wall_fabs, DOOM.FACTORY.D2_WALL_PREFABS)
  T.door_fabs = copy_and_merge(T.door_fabs, DOOM.FACTORY.D2_DOOR_PREFABS)
  T.misc_fabs = copy_and_merge(T.misc_fabs, DOOM.FACTORY.D2_MISC_PREFABS)

  return T
end