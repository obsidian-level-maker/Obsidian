----------------------------------------------------------------
-- GAME DEF : Doom 1
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006,2007 Andrew Apted
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

DM_LINE_TYPES =
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

DM_SECTOR_TYPES =
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

DM_COMBOS =
{
---- INDOOR ------------

  BASE =
  {
    mat_pri = 8,

    wall = "STARTAN3",
    void = "STARTAN2",
    step = "STEP1",
    lift = "PLAT1",
    pillar = "COMPWERD",

    pic_wd = "COMPSTA2",    -- "COMP2" for Doom 1 !!
    pic_wd_h = 64,

    floor = "FLOOR4_8",
    ceil = "CEIL3_6",
    step_floor = "STEP2",

    scenery = "lamp",
    good_liquid = "blood",

    theme_probs = { TECH=80 },
  },

  BASE2 =
  {
    mat_pri = 8,

    wall = "STARG3",
    void = "STARG2",
    step = "STEP1",
    lift = "PLAT1",
    pillar = "METAL",  -- was "METAL4", not in doom 1
    pic_wd = "COMPBLUE",

    floor = "FLOOR5_1",
    ceil = "FLOOR4_5",
    step_floor = "STEP1",

    scenery = "tech_column",

    theme_probs = { TECH=40, INDUSTRIAL=5 }, 
  },

  MARBLE =
  {
    mat_pri = 6,

    wall = "MARBLE2",
    void = "SP_DUDE5",
    step = "STEP1",
    pillar = "GSTLION",
    pic_wd  = "SP_DUDE1",

    floor = "FLOOR7_2",
    ceil = "FLOOR7_1",

    scenery = { "red_pillar", "red_column", "red_column_skl" },

    bad_liquid = "nukage",
    good_liquid = "blood",

    theme_probs = { HELL=70 },
  },

  HOT =
  {
    mat_pri = 6,

    wall = "SP_HOT1",
    void = "SP_HOT1",
    step = "STONE2",  -- STEP4

    floor = "FLAT5_7",
    ceil  = "FLOOR6_1",

    bad_liquid = "blood",
    good_liquid = "lava",

    theme_probs = { HELL=50 },
  },

  WOOD =
  {
    mat_pri = 7,

    wall = "WOOD1",
    void = "WOOD3",
    step = "STEP1",
    pillar = "WOODGARG", -- "WOODMET4" not in doom 1
    pic_wd = "MARBFACE",

    ceil = "CEIL1_1",
    floor = "FLAT5_1",

    scenery = { "impaled_human", "hang_twitching" },

    theme_probs = { URBAN=30 },
  },

  CEMENT =
  {
    mat_pri = 1,

    wall = "CEMENT6",
    void = "CEMENT4",
    step = "STEP1",
    lift = "SUPPORT3",
    pillar = "BROWNGRN",  -- "CEMENT8" not in doom 1

    floor = "FLAT9",
    ceil = "CEIL3_5",  -- "SLIME14" not in doom 1
  --  lift_floor = "FLOOR4_8",

    theme_probs = { URBAN=50, INDUSTRIAL=10 },
  },

  SLAD =
  {
    mat_pri = 4,

    wall = "SLADWALL",
    void = "SLADSKUL",
    step = "STEP1",
    pillar = "SLADPOIS",
--FIXME: (not in doom1)   pic_wd = "BSTONE3",

    vista_support = "DOORSTOP",

    floor = "FLOOR0_5",
    ceil = "CEIL5_1",

    scenery = "burning_barrel",
    good_liquid = "nukage",

    theme_probs = { INDUSTRIAL=50, TECH=15 },
  },

  GRAY =
  {
    mat_pri = 3,

    wall = "GRAY7",
    void = "ICKWALL3",
    lift = "SUPPORT3",
    pillar = "CRATE1",
    pic_wd = "REDWALL",

    floor = "FLOOR0_5",
    ceil = "FLAT1",
  --  lift_floor = "FLOOR4_8",

    scenery = { "green_pillar", "green_column", "green_column_hrt" },

    theme_probs = { INDUSTRIAL=66, URBAN=10 },
  },

  CAVEY =
  {
    mat_pri = 3,

    wall = "BROWNHUG",
    void = "BROWNHUG",
    floor = "FLAT10",
    ceil  = "FLAT10",

    theme_probs = { CAVE=50 },
  },


  ---- OUTDOOR ------------

  STONY =
  {
    outdoor = true,
    mat_pri = 5,

    wall = "STONE",
    void = "STONE3",
    step = "STEP4",
    piller = "STONE5",

    floor = "MFLR8_1",
    ceil = "MFLR8_1",

    scenery = { "blue_torch", "blue_torch_sm" },

    theme_probs = { URBAN=70, INDUSTRIAL=5 },
    door_probs = { out_diff=75, combo_diff=10, normal=5 }
  },

  BROWN =
  {
    outdoor = true,
    mat_pri = 3,

    wall = "BROWN1",
    void = "BROWNPIP",
    step = "STEP5",
    lift = "SUPPORT3",
    pillar = "BROWN96",  -- was "BRONZE2" (not in doom 1)

    floor = "MFLR8_2",  -- "RROCK16" (not in doom 1)
    ceil = "MFLR8_2",
  --  lift_floor = "FLOOR4_8",

    scenery = { "skull_pole", "skull_kebab" },
    good_liquid = "blood",

    theme_probs = { URBAN=50 },
    door_probs = { out_diff=75, combo_diff=10, normal=5 }
  },
}

DM_EXITS =
{
  TECH =
  {
    mat_pri = 9,

    wall = "TEKWALL1",
    void = "TEKWALL4",

    floor = "CEIL4_3",
    ceil  = "TLITE6_5",

    sign = "EXITSIGN",
    sign_ceil="CEIL5_2",

    switch =
    {
      prefab="SWITCH_NICHE",
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
      prefab="SWITCH_FLUSH",
      skin =
      {
        switch_w="SW1BRN2", wall="BROWN1",
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
    void = "COMPBLUE",

    floor = "FLAT14",
    ceil  = "FLAT22",

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

    wall = "STARBR2",
    void = "STARTAN2",

    floor = "FLOOR5_2",
    ceil  = "TLITE6_4",

    sign = "EXITSIGN",
    sign_ceil="CEIL5_2",

    switch =
    {
      prefab="SWITCH_FLUSH",
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

    wall = "GSTVINE1",
    step = "GSTVINE1",
    void = "GSTONE2",

    floor = "BLOOD1",
    ceil  = "FLOOR7_2",

    sign = "EXITSIGN",
    sign_ceil="CEIL5_2",

    flush = true,
    flush_left  = "GSTFONT1",
    flush_right = "GSTFONT2",

    switch =
    {
      prefab="SWITCH_FLUSH",
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

DM_HALLWAYS =
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

DM_MATS =
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

DM_PEDESTALS =
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

DM_OVERHANGS =
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

DM_CRATES =
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

DM_LIQUIDS =
{
  water = { floor="FWATER1" },
  blood = { floor="BLOOD1",  wall="BFALL1" }, -- no damage
  nukage= { floor="NUKAGE1", wall="SFALL1", sec_kind=5 },  -- 10% damage
  lava  = { floor="LAVA1", sec_kind=16, light=64 }, -- 20% damage
}

DM_SWITCHES =
{
  sw_blue =
  {
    switch =
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
        door_w="BIGDOOR3", door_c="FLAT1",
        step_w="STEP1",  track_w="DOORTRAK",
        frame_f="FLAT1", frame_c="FLAT1",
        door_h=112,
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
        door_w="BIGDOOR3", door_c="FLAT1",
        step_w="STEP1",  track_w="DOORTRAK",
        frame_f="FLAT1", frame_c="FLAT1",
        door_h=112,
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
        door_w="BIGDOOR3", door_c="FLAT1",
        step_w="STEP1",  track_w="DOORTRAK",
        frame_f="FLAT1", frame_c="FLAT1",
        door_h=112,
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
        door_w="BIGDOOR3", door_c="FLAT1",
        step_w="STEP1",  track_w="DOORTRAK",
        frame_f="FLAT1", frame_c="FLAT1",
        door_h=112,
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
      skin = { bar_w="SUPPORT3", bar_f="CEIL5_2" },
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
      skin = { bar_w="GRAY7", bar_f="FLAT19" },
    },

  },

--FIXME: (not in doom1)  sw_rock = { wall="ROCK3",    switch="SW1ROCK",  floor="RROCK13", bars=true },
--FIXME:  sw_wood = { wall="WOODMET1", switch="SW1WDMET", floor="FLAT5_1", bars=true, stand_h=128 },

}

DM_DOORS =
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

--[[ !!!!! DM_DOORS
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

DM_KEY_DOORS =
{
  k_blue =
  {
    w=128, h=112, kind_rep=26, kind_once=32,

    prefab = "DOOR_LIT_LOCKED",
    
    skin =
    {
      key_w="DOORBLU2",
      door_w="BIGDOOR4", door_c="FLAT1",
      step_w="STEP1",  track_w="DOORTRAK",
      frame_f="FLAT1", frame_c="FLAT1",
      door_h=112,
    }
  },

  k_yellow =
  {
    w=128, h=112, kind_rep=27, kind_once=34,

    prefab = "DOOR_LIT_LOCKED",

    skin =
    {
      key_w="DOORYEL2",
      door_w="BIGDOOR4", door_c="FLAT1",
      step_w="STEP1",  track_w="DOORTRAK",
      frame_f="FLAT1", frame_c="FLAT1",
      door_h=112,
    }
  },

  k_red =
  {
    w=128, h=112, kind_rep=28, kind_once=33,

    prefab = "DOOR_LIT_LOCKED",

    skin =
    {
      key_w="DOORRED2",
      door_w="BIGDOOR4", door_c="FLAT1",
      step_w="STEP1",  track_w="DOORTRAK",
      frame_f="FLAT1", frame_c="FLAT1",
      door_h=112,
    }
  },

}

DM_IMAGES =
{
  { wall = "CEMENT1", w=128, h=128, glow=true },
  { wall = "CEMENT2", w=64,  h=64,  floor="MFLR8_3" }
}

DM_LIGHTS =
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

DM_WALL_LIGHTS =
{
  white2 = { wall="LITE3",    w=32 },
  white5 = { wall="LITE5",    w=16 },
  blue4  = { wall="LITEBLU4", w=32 },
--  { wall="REDWALL",  w=32 },
}

DM_PICS =
{
  lite3 = { wall="LITE3", w=128, h=16 },

  m1 = { wall="MARBFACE", w=128, h=128 },
  m2 = { wall="MARBFAC2", w=128, h=128 },
  m3 = { wall="MARBFAC3", w=128, h=128 },

  f1 = { wall="FIRELAVA", w=128, h=128 },
  f2 = { wall="FIREMAG1", w=128, h=128 },
  f3 = { wall="FIREWALL", w=128, h=112 },

  shawn1 = { wall="SHAWN1",   w=128, h=96  },
  skin1  = { wall="SKINEDGE", w=128, h=128 },
  wood1  = { wall="WOOD3",    w=128, h=64  },

--  { wall="SKSPINE2", w=128, h=128, scroll=48 },
--  { wall="SPFACE1",  w=128, h=96,  scroll=48 },

--FIXME  { wall="WOOD10",   w=128, h=128 },
--FIXME  { wall="TEKBRON1", w=128, h=128 },
}


DM_SCENERY_PREFABS =
{
}

DM_WALL_PREFABS =
{
}

DM_ARCH_PREFABS =
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

DM_DOOR_PREFABS =
{
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
      frame_f="FLAT1", frame_c="TLITE6_6",
      track_w="DOORTRAK",
      door_h=112,
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
      frame_f="FLAT1", frame_c="TLITE6_6",
      track_w="DOORTRAK",
      door_h=112,
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
      frame_f="FLAT1", frame_c="TLITE6_6",
      track_w="DOORTRAK",
      door_h=112,
    },

    theme_probs = { HELL=90,CAVE=5 },
  },

}

DM_WINDOW_PREFABS =
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

DM_MISC_PREFABS =
{
  fence_MIDBARS3 =
  {
    prefab = "FENCE_RAIL",
    skin = { rail_w="MIDBARS3" },
  },
  
  fence_beam_BLUETORCH =
  {
    prefab = "FENCE_BEAM_W_LAMP",

    skin = { lamp_t="blue_torch", beam_h=72,
             beam_w="METAL", beam_f="CEIL5_2",
           },
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
    }
  },

  secret_DOOR =
  {
    w=128, h=128, prefab = "DOOR",

    skin = { track_w="DOORSTOP", door_h=128 }
  },
}


DM_ROOMS =
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
    -- crate it up baby!
  },

  PLANT =
  {
  },

  COMPUTER =
  {
  },

  TORTURE =
  {
  },

  PRISON =
  {
  },

  -- TODO: check in-game level names for ideas
}

DM_THEMES =
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
      PLAIN=50, WAREHOUSE=1, COMPUTER=1,
    },

    exit_probs=
    {
      STONE=70, BROWN=50,
    },

    monster_prefs =
    {
      zombie=2.0, shooter=2.0, gunner=2.0,
      barrel=2.0,
    },
  },


  INDUSTRIAL =
  {
    room_probs=
    {
      WAREHOUSE=50, COMPUTER=10,
    },

    exit_probs=
    {
      BROWN=50, TECH=20, STONE=10, BLUE=5,
    },

    monster_prefs =
    {
      caco=2.0, barrel=5.0,
    },
  },


  TECH =
  {
    room_probs=
    {
      COMPUTER=50, WAREHOUSE=5,
    },

    exit_probs=
    {
      TECH=50, BLUE=50, STARTAN=50, BROWN=5,
    },

    monster_prefs =
    {
      zombie=2.0, shooter=2.0, gunner=2.0,
      barrel=3.7,
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
      PLAIN=50, WAREHOUSE=3, COMPUTER=1,
    },

    exit_probs=
    {
      BROWN=50, STONE=10,
    },

    room_heights = { [96]=50, [128]=50 },

    monster_prefs =
    {
      imp=3.0, skull=2.0, revenant=2.0,
      barrel=0.1,
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
      TORTURE=20,
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

DM_QUEST_LEN_PROBS =
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

DM_MONSTERS =
{
  -- FIXME: probs for CLOSET/DEPOT
  zombie    = { prob=60, hp=20,  dm=4,  fp=1.0, cage_fallback=14, hitscan=true, },
  shooter   = { prob=40, hp=30,  dm=10, fp=1.3, cage_prob= 8, hitscan=true, },

  imp       = { prob=80, hp=60,  dm=20, fp=1.6, cage_prob=50, },
  caco      = { prob=80, hp=400, dm=45, fp=2.0, cage_prob=14, float=true },
  baron     = { prob=50, hp=1000,dm=45, fp=3.8, cage_prob= 3, },

  -- MELEE only monsters
  demon     = { prob=60, hp=150, dm=25, fp=2.3, cage_prob=66,melee=true },
  spectre   = { prob=20, hp=150, dm=25, fp=2.3, cage_prob=40,melee=true },
  skull     = { prob=16, hp=100, dm=7,  fp=2.6, cage_prob= 2, melee=true, float=true },
 
--!!!!!  barrel    = { prob=20, hp=10,  dm=2,  fp=5, melee=true, passive=true },
}

DM_BOSSES =
{
  -- special monsters (only for boss levels)
  cyber     = { hp=4000,dm=150, fp=4.0 },
  spider    = { hp=3000,dm=200, fp=4.0, hitscan=true },
}

D2_MONSTERS =
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

DM_MONSTER_GIVE =
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

DM_WEAPONS =
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

DM_MONSTER_WEAPON_PREFS =
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

DM_PICKUPS =
{
  bullets    = { stat="bullet", give=10, prob=10 },
  bullet_box = { stat="bullet", give=50, prob=70, clu_max=2 },
  shells     = { stat="shell",  give= 4, prob=30 },
  shell_box  = { stat="shell",  give=20, prob=70, clu_max=4 },

  rockets    = { stat="rocket", give= 1, prob=20 },
  rocket_box = { stat="rocket", give= 5, prob=70, clu_max=4 },
  cells      = { stat="cell",   give=20, prob=30 },
  cell_pack  = { stat="cell",   give=100,prob=70, clu_max=1 },

  potion   = { stat="health", give=1,  prob=30 },
  stimpack = { stat="health", give=10, prob=40 },
  medikit  = { stat="health", give=25, prob=70, clu_max=4 },
  soul     = { stat="health", give=100,prob=15, limit=200, clu_max=1 },

  -- BERSERK and MEGA are quest items

  helmet      = { stat="armor", give=   1, limit=200 },
  green_armor = { stat="armor", give= 100, limit=100, clu_max=1 },
  blue_armor  = { stat="armor", give= 200, limit=200, clu_max=1 },

  -- Note: armor is handled with special code, since
  --       BLUE ARMOR is a quest item.

  -- Note 2: the BACKPACK is a quest item
}

DM_NICENESS =
{
  w1 = { weapon="shotty", quest=1, prob=70, always=true  },
  w2 = { weapon="chain",  quest=3, prob=20, always=false },
  w3 = { weapon="plasma", quest=5, prob=35, always=true  },

  p1 = { pickup="green_armor", prob=2.0 },
}


-- DeathMatch stuff
-- ================

DM_DEATHMATCH =
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

DM_INITIAL_MODEL =
{
  -- Note: bullet numbers are understated (should be 50)
  -- so that the player isn't forced to empty the pistol.

  health=100, armor=0,
  bullet=20, shell=0, rocket=0, cell=0,
  fist=true, pistol=true,
}


-----==============######################==============-----


---- QUEST STUFF ----------------

D1_QUESTS =
{
  key =
  {
    k_blue=50, k_red=50, k_yellow=50
  },

  switch =
  {
    sw_blue=50, sw_hot=30,
    sw_vine=10, sw_skin=40,
    sw_metl=50, sw_gray=20,
  },

  weapon =
  {
    saw=10, launch=80, plasma=60, bfg=5
  },

  item =
  {
    blue_armor=40, invis=40, backpack=25,
    berserk=20, goggle=5, invul=2, map=3
  },

---##  exit = { exit=50 },
---##
---##  secret_exit = { secret_exit=50 },
}

D1_COMBOS =
{
}

D1_EXITS =
{
}

D1_HALLWAYS =
{
}

D1_CRATES =
{
  COMPUTER =
  {
    wall = "COMPUTE1", h=128, floor = "FLAT23",
    side_x_offset=67
  },

  PLANET1 =
  {
    wall = "PLANET1", h=128, floor = "FLAT23",
    side_x_offset=64
  },
 
  PLANET2 =
  {
    wall = "PLANET1", h=64, floor = "FLAT23",
    x_offset=128, side_y_offset=64
  },
 
  SKIN =
  {
    wall = "SKINBORD", h=64, floor = "CEIL3_3", can_rotate=true
  },
}

D1_RAILS =
{
  r_1 = { wall="BRNSMALC", w=128, h=64  },
  r_2 = { wall="MIDGRATE", w=128, h=128 },
}

D1_WALL_LIGHTS =
{
  reddy  = { wall="LITERED",  w=16 },
  stoned = { wall="LITESTON", w=32 },
}

------------------------------------------------------------

D1_EPISODE_THEMES =
{
  { URBAN=5, INDUSTRIAL=5, TECH=9, CAVE=2, HELL=2 },
  { URBAN=9, INDUSTRIAL=5, TECH=4, CAVE=2, HELL=4 },
  { URBAN=1, INDUSTRIAL=1, TECH=1, CAVE=2, HELL=9 },
  { URBAN=4, INDUSTRIAL=2, TECH=2, CAVE=4, HELL=7 },
}

D1_SECRET_EXITS =
{
  E1M3 = true,
  E2M5 = true,
  E3M6 = true,
  E4M2 = true,
}

D1_EPISODE_BOSSES =
{
  "baron", -- the Bruiser Brothers
  "cyberdemon",
  "spider_mastermind",
  "spider_mastermind",
}

D1_SKY_INFO =
{
  { color="white",  light=192 },
  { color="red",    light=176 },
  { color="red",    light=192 },
  { color="orange", light=192 },
}

function doom1_get_levels(episode)

  local level_list = {}

  local theme_probs = D1_EPISODE_THEMES[episode]
  if SETTINGS.length ~= "full" then
    theme_probs = D1_EPISODE_THEMES[rand_irange(1,4)]
  end

  for map = 1,9 do
    local Level =
    {
      name = string.format("E%dM%d", episode, map),

      episode   = episode,
      ep_along  = map,
      ep_length = 9,

      theme_probs = theme_probs,
      sky_info = D1_SKY_INFO[episode],

      boss_kind   = (map == 8) and D1_EPISODE_BOSSES[episode],
      secret_kind = (map == 9) and "plain",
    }

    if D1_SECRET_EXITS[Level.name] then
      Level.secret_exit = true
    end

    std_decide_quests(Level, D1_QUESTS, DM_QUEST_LEN_PROBS)

    table.insert(level_list, Level)
  end

  return level_list
end


------------------------------------------------------------

GAME_FACTORIES["doom_common"] = function()

  return
  {
    doom_format = true,

    plan_size = 10,
    cell_size = 9,
    cell_min_size = 6,

    caps = { heights=true, sky=true, 
             fragments=true, move_frag=true, rails=true,
             closets=true,   depots=true,
             switches=true,  liquids=true,
             teleporters=true,
           },

    SKY_TEX    = "F_SKY1",
    ERROR_TEX  = "FIREBLU1",
    ERROR_FLAT = "SFLR6_4",

    monsters = DM_MONSTERS,
    bosses   = DM_BOSSES,
    weapons  = DM_WEAPONS,

    things = DM_THINGS,

    mon_give       = DM_MONSTER_GIVE,
    mon_weap_prefs = DM_MONSTER_WEAPON_PREFS,
    initial_model  = DM_INITIAL_MODEL,

    pickups = DM_PICKUPS,
    pickup_stats = { "health", "bullet", "shell", "rocket", "cell" },
    niceness = DM_NICENESS,

    dm = DM_DEATHMATCH,

    combos    = DM_COMBOS,
    exits     = DM_EXITS,
    hallways  = DM_HALLWAYS,

    hangs     = DM_OVERHANGS,
    pedestals = DM_PEDESTALS,
    mats      = DM_MATS,
    crates    = DM_CRATES,

    liquids   = DM_LIQUIDS,
    switches  = DM_SWITCHES,
    doors     = DM_DOORS,
    key_doors = DM_KEY_DOORS,

    pics      = DM_PICS,
    images    = DM_IMAGES,
    lights    = DM_LIGHTS,
    wall_lights = DM_WALL_LIGHTS,

    rooms     = DM_ROOMS,
    themes    = DM_THEMES,

--  sc_fabs   = DM_SCENERY_PREFABS,
--  wall_fabs = DM_WALL_PREFABS,
    door_fabs = DM_DOOR_PREFABS,
    arch_fabs = DM_ARCH_PREFABS,
    win_fabs  = DM_WINDOW_PREFABS,
    misc_fabs = DM_MISC_PREFABS,

    room_heights = { [96]=5, [128]=25, [192]=70, [256]=70, [320]=12 },
    space_range  = { 20, 90 },

    diff_probs = { [0]=20, [16]=20, [32]=80, [64]=60, [96]=20 },
    bump_probs = { [0]=40, [16]=20, [32]=20, [64]=10 },

    door_probs   = { out_diff=75, combo_diff=50, normal=15 },
    window_probs = { out_diff=75, combo_diff=60, normal=35 },

    hallway_probs = { 20, 30, 41, 53, 66 },
    shack_prob    = 25,
  }
end


GAME_FACTORIES["doom1"] = function()

  local T = GAME_FACTORIES.doom_common()

  T.episodes   = 4
  T.level_func = doom1_get_levels

  T.quests   = D1_QUESTS

  T.combos   = copy_and_merge(T.combos,   D1_COMBOS)
  T.exits    = copy_and_merge(T.exits,    D1_EXITS)
  T.hallways = copy_and_merge(T.hallways, D1_HALLWAYS)
  T.crates   = copy_and_merge(T.crates,   D1_CRATES)

  T.wall_lights = copy_and_merge(T.wall_lights, D1_WALL_LIGHTS)

  T.rails = D1_RAILS

  -- remove DOOM2-only weapons and items --

  T.weapons = copy_table(T.weapons)
  T.weapons["super"] = nil

  T.dm = copy_table(T.dm)
  T.dm.weapons = copy_table(T.dm.weapons)
  T.dm.weapons["super"] = nil

  return T
end

