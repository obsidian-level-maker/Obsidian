----------------------------------------------------------------
-- GAME DEF : DOOM textures / skins
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2009 Andrew Apted
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

COMMON_EXITS =
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

DOOM1_EXITS =
{
}

DOOM2_EXITS =
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


COMMON_HALLWAYS =
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
  },
}

DOOM1_HALLWAYS =
{
}

DOOM2_HALLWAYS =
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
  },
}


COMMON_PEDESTALS =
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

COMMON_OVERHANGS =
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

COMMON_CRATES =
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



DOOM1_CRATES =
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


DOOM2_OVERHANGS =
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

DOOM2_DOORS =
{
  d_thin1  = { wall="SPCDOOR1", w=64, h=112 },
  d_thin2  = { wall="SPCDOOR2", w=64, h=112 },
  d_thin3  = { wall="SPCDOOR3", w=64, h=112 },

  d_weird  = { wall="SPCDOOR4", w=64, h=112 },
}

DOOM2_CRATES =
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

DOOM2_LIGHTS =
{
  green1 = { floor="GRNLITE1", side="TEKGREN2" },
}

DOOM2_LIQUIDS =
{
--###  slime = { floor="SLIME01", wall="BLODRIP1", sec_kind=7 }  -- 5% damage
}

DOOM2_SCENERY =
{
}


COMMON_IMAGES =
{
  { wall = "CEMENT1", w=128, h=128, glow=true },
  { wall = "CEMENT2", w=64,  h=64,  floor="MFLR8_3" }
}

COMMON_LIGHTS =
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



COMMON_WALL_PREFABS =
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

DOOM1_WALL_PREFABS =
{
  wall_pic_COMP2 =
  {
    prefab = "WALL_PIC",
    min_height = 160,
    theme_probs = { TECH=90, INDUSTRIAL=30 },
    skin = { pic_w="COMP2", lite_w="SUPPORT2", pic_h=128 },
  },

  wall_pic_TEKWALL2 =
  {
    prefab = "WALL_PIC_SHALLOW",
    min_height = 144,
    skin = { pic_w="TEKWALL2", lite_w="METAL", pic_h=128 },
    theme_probs = { TECH=10 },
  },

  wall_pic_TEKWALL3 =
  {
    prefab = "WALL_PIC_SHALLOW",
    min_height = 144,
    skin = { pic_w="TEKWALL3", lite_w="METAL", pic_h=128 },
    theme_probs = { TECH=10 },
  },

  wall_pic_TEKWALL5 =
  {
    prefab = "WALL_PIC_SHALLOW",
    min_height = 144,
    skin = { pic_w="TEKWALL5", lite_w="METAL", pic_h=128 },
    theme_probs = { TECH=10 },
  },

  lights_thin_LITERED =
  {
    prefab = "WALL_LIGHTS_THIN",
    min_height = 128,
    theme_probs = { TECH=90, HELL=2 },
    skin =
    {
      lite_w="LITERED", lite_side="LITERED",
      frame_f="FLOOR1_6",
      wall_lt=255, kind=8,
    },
  },
}

DOOM2_WALL_PREFABS =
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



COMMON_ARCH_PREFABS =
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


COMMON_DOOR_PREFABS =
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
      key_w="LITE3",
      door_w="BIGDOOR1", door_c="FLAT1",
      step_w="STEP4", step_f="FLAT18",
      frame_c="FLAT18", -- frame_c="TLITE6_6",
      track="DOORTRAK",
      door_h=72,
      line_kind=1, tag=0,
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

DOOM2_DOOR_PREFABS =
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


COMMON_WINDOW_PREFABS =
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



COMMON_SCENERY_PREFABS =
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

DOOM2_SCENERY_PREFABS =
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


COMMON_FEATURE_PREFABS =
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

DOOM2_FEATURE_PREFABS =
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


COMMON_MISC_PREFABS =
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

DOOM2_MISC_PREFABS =
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


