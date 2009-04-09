----------------------------------------------------------------
-- GAME DEF : Doom II
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2009 Andrew Apted
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

DOOM2_COMBOS =
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

  TECH_TEKGREN =
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

  NAT_TANROCK5 =
  {
    theme_probs = { NATURE=30 },
    outdoor = true,
    mat_pri = 3,

    wall = "TANROCK5",
    floor = "RROCK04",
    ceil  = "RROCK04",

    void = "ZIMMER4",
    step = "STEP6",
    lift = "SUPPORT3",
    piller = "ASHWALL7",

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

DOOM2_MATERIALS =
{
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

DOOM2_RAILS =
{
  r_1 = { wall="MIDBARS3", w=128, h=72  },
  r_2 = { wall="MIDGRATE", w=128, h=128 },
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

DOOM2_ROOMS =
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

DOOM2_THEMES =
{
}

------------------------------------------------------------

---## DOOM2_QUESTS =
---## {
---##   key =
---##   {
---##     k_blue=50, k_red=50, k_yellow=50
---##   },
---## 
---##   switch =
---##   {
---##     sw_blue=50, sw_hot=30,
---##     sw_vine=10, -- sw_skin=40,
---##     sw_metl=50, sw_gray=20,
---##     -- FIXME: sw_rock=10,
---##     -- FIXME: sw_wood=30, 
---##   },
---## 
---##   weapon =
---##   {
---##     saw=10, super=40, launch=80, plasma=60, bfg=5
---##   },
---## 
---##   item =
---##   {
---##     blue_armor=40, invis=40, mega=25, backpack=25,
---##     berserk=20, goggle=5, invul=2, map=3
---##   },
---## }

DOOM2_EPISODE_THEMES =
{
  { URBAN=4, INDUSTRIAL=3, TECH=3, NATURE=9, CAVE=2, HELL=2 },
  { URBAN=9, INDUSTRIAL=5, TECH=7, NATURE=4, CAVE=2, HELL=4 },
  { URBAN=3, INDUSTRIAL=2, TECH=5, NATURE=3, CAVE=6, HELL=8 },

  -- this entry used for a single episode or level
  { URBAN=5, INDUSTRIAL=4, TECH=6, NATURE=5, CAVE=4, HELL=6 },
}

DOOM2_SECRET_KINDS =
{
  MAP31 = "wolfy",
  MAP32 = "wolfy",
}

DOOM2_SECRET_EXITS =
{
  MAP15 = true,
  MAP31 = true,
}

DOOM2_LEVEL_BOSSES =
{
  MAP07 = "mancubus",
  MAP20 = "Mastermind",
  MAP30 = "boss_brain",
  MAP32 = "keen",
}

DOOM2_SKY_INFO =
{
  { color="brown",  light=192 },
  { color="gray",   light=192 }, -- bright clouds + dark buildings
  { color="red",    light=192 },
}


function Doom2_get_levels()
  local list = {}

  local MAP_NUM = 11

  if OB_CONFIG.length == "single" then MAP_NUM = 1  end
  if OB_CONFIG.length == "few"    then MAP_NUM = 4  end
  if OB_CONFIG.length == "full"   then MAP_NUM = 32 end

  assert(GAME.sky_info)

  for map = 1,MAP_NUM do
    local episode = 1

    if map >= 12 then episode = 2 end
    if map >= 21 then episode = 3 end
    if map >= 31 then episode = 2 end

    local theme_probs = DOOM2_EPISODE_THEMES[episode]
    if OB_CONFIG.length ~= "full" then
      theme_probs = DOOM2_EPISODE_THEMES[4]
    end
    assert(theme_probs)

    local LEV =
    {
      name  = string.format("MAP%02d", map),
      patch = string.format("CWILV%02d", map-1),

      ep_along = ((map - 1) % 11) / 10.0,

      theme = "TECH",

      key_list = { "kc_red", "kc_blue", "kc_yellow" },
      switch_list = { "sw_blue", "sw_hot", "sw_marble", "sw_wood" },
      bar_list = { "bar_wood", "bar_silver", "bar_metal" },

      -- allow TNT and Plutonia to override the sky stuff
      sky_info = GAME.sky_info[episode],

      style = {},
    }

    if OB_CONFIG.length == "few" then
      LEV.ep_along = (map-1) / (MAP_NUM - 1)
    end

    assert(LEV.ep_along <= 1)

    LEV.toughness_factor = 1 + 1.5 * LEV.ep_along

    if LEV.ep_along > 0.44 and rand_odds(sel(MAP_NUM > 7, 50, 90)) then
      LEV.allow_bfg = true
    end

    -- secret levels
    if map == 31 or map == 32 then
      LEV.theme = "WOLF"
      LEV.allow_bfg = true
    end

    if map == 23 then
      LEV.style.barrels = "heaps"
    end

---!!! LEV.boss_kind   = DOOM2_LEVEL_BOSSES[LEV.name]
    LEV.secret_kind = DOOM2_SECRET_KINDS[LEV.name]
    LEV.secret_exit = DOOM2_SECRET_EXITS[LEV.name]

    table.insert(list, LEV)
  end

  return list
end


------------------------------------------------------------

function Doom2_setup(game)

  Doom_common_setup()

---  T.episodes   = 3

  GAME.quests   = DOOM2_QUESTS
  GAME.sky_info = DOOM2_SKY_INFO
  GAME.rails    = DOOM2_RAILS

  Game_merge_tab("themes",   DOOM2_THEMES)
  Game_merge_tab("rooms",    DOOM2_ROOMS)
  Game_merge_tab("monsters", DOOM2_MONSTERS)

  Game_merge_tab("combos",   DOOM2_COMBOS)
  Game_merge_tab("hallways", DOOM2_HALLWAYS)
  Game_merge_tab("exits",    DOOM2_EXITS)
  Game_merge_tab("materials",DOOM2_MATERIALS)

  Game_merge_tab("hangs",    DOOM2_OVERHANGS)
  Game_merge_tab("crates",   DOOM2_CRATES)
  Game_merge_tab("doors",    DOOM2_DOORS)
  Game_merge_tab("lights",   DOOM2_LIGHTS)
  Game_merge_tab("liquids",  DOOM2_LIQUIDS)

  Game_merge_tab("sc_fabs",   DOOM2_SCENERY_PREFABS)
  Game_merge_tab("feat_fabs", DOOM2_FEATURE_PREFABS)
  Game_merge_tab("wall_fabs", DOOM2_WALL_PREFABS)
  Game_merge_tab("door_fabs", DOOM2_DOOR_PREFABS)
  Game_merge_tab("misc_fabs", DOOM2_MISC_PREFABS)
end


------------------------------------------------------------

OB_GAMES["doom2"] =
{
  label = "Doom 2",

  format = "doom",

  priority = 99, -- keep at top

  setup_func = Doom2_setup,

  caps =
  {
    rails = true,
    switches = true,
    liquids = true,
    teleporters = true,
    infighting = true,

    pack_sidedefs = true,
    custom_flats = true,
  },

  params =
  {
    seed_size = 256,

    sky_tex    = "-",
    sky_flat   = "F_SKY1",

    error_tex  = "METAL"   or "FIREBLU1",
    error_flat = "CEIL5_1" or "SFLR6_4",

    -- this is roughly how many characters can fit on the
    -- intermission screens (the CWILVxx patches).  It does
    -- not reflect any buffer limits in Doom ports.
    max_level_desc = 28,

    skip_monsters = { 3,5 },

    mon_time_max = 12,
    mon_hard_health = 200,

    mon_damage_max  = 200,
    mon_damage_high = 100,
    mon_damage_low  =   1,
  },

  hooks =
  {
    get_levels = Doom2_get_levels,

    describe_levels = Doom_describe_levels,
    make_level_gfx  = Doom_make_level_gfx,
  },
}


UNFINISHED["d2_urban"] =
{
  ref = "URBAN",
  label = "City",
  for_games = { doom2=1, freedoom=1 },
}

UNFINISHED["d2_wolf"] =
{
  ref = "WOLF",
  label = "Wolfenstein",
  for_games = { doom2=1, freedoom=1 },
}

