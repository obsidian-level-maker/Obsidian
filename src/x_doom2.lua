----------------------------------------------------------------
-- GAME DEF : Doom 2
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

DM_THING_NUMS =
{
  --- special stuff ---
  player1 = 1,
  player2 = 2,
  player3 = 3,
  player4 = 4,
  dm_player = 11,
  teleport_spot = 14,

  --- monsters ---
  zombie    = 3004,
  shooter   = 9,
  gunner    = 65,
  imp       = 3001,
  caco      = 3005,
  revenant  = 66,
  knight    = 69,
  baron     = 3003,

  mancubus  = 67,
  arach     = 68,
  pain      = 71,
  vile      = 64,
  demon     = 3002,
  spectre   = 58,
  skull     = 3006,

  cyber     = 16,
  spider    = 7,
  keen      = 72,
  wolf_ss   = 84,

  --- pickups ---
  k_red     = 38,
  k_yellow  = 39,
  k_blue    = 40,

  kc_blue   = 5,
  kc_yellow = 6,
  kc_red    = 13,

  shotty = 2001,
  super  =   82,
  chain  = 2002,
  launch = 2003,
  plasma = 2004,
  saw    = 2005,
  bfg    = 2006,

  backpack =  8,
  mega   =   83,
  invul  = 2022,
  berserk= 2023,
  invis  = 2024,
  suit   = 2025,
  map    = 2026,
  goggle = 2045,

  potion   = 2014,
  stimpack = 2011,
  medikit  = 2012,
  soul     = 2013,

  helmet      = 2015,
  green_armor = 2018,
  blue_armor  = 2019,

  bullets    = 2007,
  bullet_box = 2048,
  shells     = 2008,
  shell_box  = 2049,
  rockets    = 2010,
  rocket_box = 2046,
  cells      = 2047,
  cell_pack  =   17,

  --- scenery ---
  lamp = 2028,
  mercury_lamp = 85, 
  short_lamp = 86,
  tech_column = 48,

  barrel = 2035,
  candle = 34,  -- non-blocking
  candelabra = 35,
  burning_barrel = 70,

  blue_torch     = 44,
  blue_torch_sm  = 55,
  green_torch    = 45,
  green_torch_sm = 56,
  red_torch      = 46,
  red_torch_sm   = 57,

  green_pillar = 30,
  green_column = 31,
  green_column_hrt = 36,

  red_pillar = 32,
  red_column = 33,
  red_column_skl = 37,

  brown_stub = 47,
  burnt_tree = 43,
  big_tree = 54,  

  evil_eye    = 41,
  skull_rock  = 42,
  skull_pole  = 27,
  skull_kebab = 28,
  skull_cairn = 29,

  impaled_human  = 25,
  impaled_twitch = 26,

  gutted_victim1 = 73,
  gutted_victim2 = 74,
  gutted_torso1  = 75,
  gutted_torso2  = 76,
  gutted_torso3  = 77,
  gutted_torso4  = 78,

  -- all the rest are non-blocking
  hang_twitching = 63,
  hang_arm_pair  = 59,
  hang_leg_pair  = 60,
  hang_leg_gone  = 61,
  hang_leg       = 62,

  gibs = 24,
  gibbed_player = 10,
  pool_blood_1 = 79,
  pool_blood_2 = 80,
  pool_brains  = 81,

  dead_player  = 15,
  dead_zombie  = 18,
  dead_shooter = 19,
  dead_imp     = 20,
  dead_demon   = 21,
  dead_caco    = 23,
}


------------------------------------------------------------

D2_COMBOS =
{
  PANEL =
  {
    mat_pri = 6,

    wall = "PANEL7",
    void = "PANBOOK",
    step = "STEP2",
    pillar = "PANBLUE",
    pic_wd = "SPACEW3",

    floor = "FLOOR5_4",
    ceil = "CEIL1_2",

    scenery = { "candelabra", "evil_eye" },

    theme_probs = { URBAN=50 },
  },

  GRNTECH =
  {
    mat_pri = 4,

    wall = "TEKGREN2",
    void = "TEKGREN1",
    step = "STEP1",
    pillar = "TEKLITE2",  -- TODO: doom 1: "COMPUTE1"

    pic_wd = "COMPSTA1", pic_wd_h = 64,

    floor = "FLOOR1_1",
    ceil = "FLAT4",

    scenery = { "mercury_lamp", "short_lamp" },
    bad_liquid = "water",

    theme_probs = { TECH=20 },
  },

  MARBLE =
  {
    mat_pri = 6,

    wall = "MARBLE2",
    void = "MARBGRAY",
    step = "STEP1",
    pillar = "MARBFAC4",
    pic_wd  = "SP_DUDE1",

    floor = "GRNROCK",
    ceil = "RROCK04",

    scenery = { "red_pillar", "red_column", "red_column_skl" },

    bad_liquid = "nukage",
    good_liquid = "blood",

    theme_probs = { HELL=70 },
  },

  -------->

  GRASSY =
  {
    outdoor = true,
    mat_pri = 2,

    wall = "ZIMMER7",
    void = "ZIMMER8",
    step = "STEP5",

    floor = "RROCK19",
    ceil  = "RROCK19",

    scenery = "brown_stub",

    bad_liquid = "nukage",

    theme_probs = { NATURE=50 },
  },

  ROCKY =
  {
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

    scenery = { "burnt_tree", "big_tree" },
    bad_liquid = "slime",

    theme_probs = { NATURE=50 },
  },

  ROCKY2 =
  {
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

    theme_probs = { NATURE=50 },
  },

  ASHY =
  {
    outdoor = true,
    mat_pri = 6,

    wall = "ASHWALL2",
    void = "BLAKWAL2",
    step = "STEP4",
    piller = "STONE5",
    pic_wd = "MODWALL2", pic_wd_h = 64,  -- FIXME

    floor = "MFLR8_4",
    ceil  = "MFLR8_4",

    scenery = { "skull_rock", "brown_stub", "evil_eye" },

    theme_probs = { NATURE=50 },
  },

  MUDDY =
  {
    outdoor = true,
    mat_pri = 2,

    wall = "ASHWALL4",
    void = "TANROCK5",
    step = "STEP5",

    floor = "FLAT10",
    ceil  = "FLAT10",

    scenery = "burnt_tree",

    bad_liquid = "slime",

    theme_probs = { NATURE=50 },
  },

  BRICK =
  {
    mat_pri = 6,

    wall = "BRICK7",
    void = "BRICK5",
    step = "STEP1",
    pillar = "BRICKLIT",
    pic_wd = "BRWINDOW",

    floor = "FLOOR0_7",
    ceil = "CEIL5_2",

    scenery = { "red_torch", "red_torch_sm" },
    bad_liquid = "slime",

    theme_probs = { URBAN=30 },
  },

  BRICK2 =
  {
    mat_pri = 6,

    wall = "BIGBRIK1",
    void = "BIGBRIK3",
    step = "STEP1",
    pillar = "BRICK12",

    floor = "RROCK12",
    ceil = "FLAT1",

    scenery = { "green_torch", "green_torch_sm" },

    theme_probs = { URBAN=20 },
  },
}

D2_EXITS =
{
  METAL =
  {
    mat_pri = 8,

    wall = "METAL1",
    void = "METAL5",

    floor = "FLOOR5_1",
    ceil  = "TLITE6_4",

    hole_tex = "LITE3",

    sign = "EXITSIGN",    -- FIXME !!! make the sign into a MATERIAL
    sign_ceil="CEIL5_2",

    switch = { switch="SW1BLUE", wall="COMPBLUE", h=64, kind_once=11 },

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

    switch = { switch="SW1WOOD", wall="WOOD1", h=64, kind_once=11 },

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

    sign = "EXITSIGN",
    sign_ceil="CEIL5_2",

    flush = true,
    flush_left  = "SK_LEFT",
    flush_right = "SK_RIGHT",

    switch = { switch="SW1SKULL", wall="SKINCUT", h=128, kind_once=11 },

    door = { wall="EXITDOOR", w=64, h=72,
             frame_ceil="FLAT5_5", frame_floor="CEIL5_2" },
  },
}

D2_HALLWAYS =
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
  },

  BSTONE =
  {
    mat_pri = 0,

    wall = "BSTONE2",
    void = "BSTONE2",
    step = "METAL",
    pillar = "BSTONE3",

    floor = "FLAT5",
    ceil  = "FLAT1",
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
  },

  TEKGREN =
  {
    mat_pri = 0,

    wall = "TEKGREN4",
    void = "TEKGREN2",
    step = "STEP2",
    pillar = "TEKGREN3",  -- was: "BRONZE2"

    floor = "FLOOR3_3",
    ceil  = "GRNLITE1",

    well_lit = true,
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
  },
}

D2_MATS =
{
  ARCH =
  {
    wall  = "METAL",
    void  = "METAL1",
    floor = "SLIME14",
    ceil  = "SLIME14",
  },
}

D2_OVERHANGS =
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

D2_DOORS =
{
  d_thin1  = { wall="SPCDOOR1", w=64, h=112 },
  d_thin2  = { wall="SPCDOOR2", w=64, h=112 },
  d_thin3  = { wall="SPCDOOR3", w=64, h=112 },

  d_weird  = { wall="SPCDOOR4", w=64, h=112 },
}

D2_CRATES =
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

D2_RAILS =
{
  r_1 = { wall="MIDBARS3", w=128, h=72  },
  r_2 = { wall="MIDGRATE", w=128, h=128 },
}

D2_LIGHTS =
{
  green1 = { floor="GRNLITE1", side="TEKGREN2" },
}

D2_PICS =
{
  wolf6 = { wall="ZZWOLF6", w=128, h=128 },
  wolf7 = { wall="ZZWOLF7", w=128, h=128 },
}

D2_LIQUIDS =
{
  slime = { floor="SLIME01", sec_kind=7 }  --  5% damage
}

D2_SECRET_LEVELS =
{
  { leave="MAP15", enter="MAP31", kind="wolfy" },
  { leave="MAP31", enter="MAP32", kind="wolfy" },
}

D2_SCENERY =
{
}

D2_PREFAB_SCENERY =
{
  pedestal_PLAYER =
  {
    prefab = "PEDESTAL",

    skin =
    {
      wall="SHAWN2", floor="FLAT22", ped_h=8,
    },
  },

  pedestal_KEY =
  {
    prefab = "PEDESTAL",

    skin =
    {
      wall="METAL", floor="GATE4", ped_h=24,
    },
  },

  pedestal_WEAPON =
  {
    prefab = "PEDESTAL",

    skin =
    {
      wall="METAL", floor="CEIL1_2", ped_h=12,
    },
  },

  wall_lamp_RED_TORCH =
  {
    prefab = "WALL_LAMP",
    skin = { lamp_t="red_torch_sm" },
  },

  wall_lamp_GREEN_TORCH =
  {
    prefab = "WALL_LAMP",
    skin = { lamp_t="green_torch_sm" },
  },

  wall_lamp_BLUE_TORCH =
  {
    prefab = "WALL_LAMP",
    skin = { lamp_t="blue_torch_sm" },
  },

  wall_pic_TV =
  {
    prefab = "WALL_PIC",
    skin = { pic_w="SPACEW3", lite_w="SUPPORT2" },
  },

  wall_pic_2S_EAGLE =
  {
    prefab = "WALL_PIC_TWO_SIDED",
    skin = { pic_w="ZZWOLF6", lite_w="LITE5" },
  },

  wall_pic_4S_ADOLF =
  {
    prefab = "WALL_PIC_FOUR_SIDED",
    skin = { pic_w="ZZWOLF7" },
  },

  pillar_light1_METAL =
  {
    prefab = "PILLAR_LIGHT1",

    skin = { beam_w="METAL", beam_f="CEIL5_2",
             lite_w="LITE5" },
  },

  pillar_rnd_sm_POIS =
  {
    prefab = "PILLAR_ROUND_SMALL",

    skin = { wall="BRNPOIS" },
  },

  pillar_rnd_med_COMPSTA =
  {
    prefab = "PILLAR_ROUND_MEDIUM",

    skin = { wall="COMPSTA1" },
  },

  pillar_rnd_bg_COMPSTA =
  {
    prefab = "PILLAR_ROUND_LARGE",

    skin = { wall="COMPSTA2" },
  },

  billboard_NAZI =
  {
    prefab = "BILLBOARD",

    skin =
    {
      pic_w = "ZZWOLF2", pic_back = "ZZWOLF1",
      pic_f = "FLAT5_4",  pic_h = 128,

      corn_w = "ZZWOLF5", corn_f = "FLAT5_1",
      corn_h = 112,

      step_w = "ZZWOLF5", step_f = "FLAT5_1",
    },
  },

  billboard_lit_SHAWN =
  {
    prefab = "BILLBOARD_LIT",

    skin =
    {
      pic_w  = "SHAWN1", pic_back = "SHAWN2",
      pic_f = "CEIL3_5", pic_h = 88,

      corn_w = "SHAWN2", corn2_w = "DOORSTOP",
      corn_f = "FLAT19", corn_h  = 112,

      step_w = "STEP4", step_f = "CEIL3_5",
      lite_w = "LITE5",
    },
  },

  billboard_stilts_FLAGGY =
  {
    prefab = "BILLBOARD_ON_STILTS",

    skin =
    {
      pic_w  = "ZZWOLF12", pic_offset_h = 64,
      beam_w = "WOOD1", beam_f = "FLAT5_2",
    },
  },

  billboard_stilts4_WREATH =
  {
    prefab = "BILLBOARD_STILTS_HUGE",

    skin =
    {
      pic_w  = "ZZWOLF13", pic_offset_h = 128,
      beam_w = "WOOD1", beam_f = "FLAT5_2",
    },
  },

  statue_tech1 =
  {
    prefab = "STATUE_TECH_1",

    skin =
    {
      wall="COMPWERD", floor="FLAT14", ceil="FLOOR4_8",
      step_w="STEP1", carpet_f="FLOOR1_1",
      
      comp_w="SPACEW3", comp2_w="COMPTALL", span_w="COMPSPAN",
      comp_f="CEIL5_1", lite_c="TLITE6_5",

      lamp_t="lamp"
    }
  },

  statue_tech2 =
  {
    prefab = "STATUE_TECH_2",

    skin =
    {
      wall="METAL", floor="FLAT23", ceil="FLAT23",
      outer_w="STEP4",

      carpet_f="FLAT14", lite_c="TLITE6_5",

      tv_w="SPACEW3", tv_f="CEIL5_1",
      span_w="COMPSPAN", span_f="FLAT4",
    },
  },

  machine_pump1 =
  {
    prefab = "MACHINE_PUMP",

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
  
  ground_light_SILVER =
  {
    prefab = "GROUND_LIGHT",

    skin =
    { 
      shawn_w = "SHAWN3", shawn_f = "FLAT1",
      lite_w  = "LITE5",  lite_f  = "CEIL5_1",
    }
  },

  launch_pad_big_H =
  {
    prefab = "LAUNCH_PAD_LARGE",

    skin =
    {
      pad_f="FLAT1", letter_f="CRATOP1",
      outer_w="METAL1", outer_f="FLOOR4_8",
      step_w="STEP1", side_w="METAL1", step_f="FLOOR4_8",
    },
  },
  
  launch_pad_med_F =
  {
    prefab = "LAUNCH_PAD_MEDIUM",

    skin =
    {
      pad_f="FLAT1", letter_f="CRATOP1",
      outer_w="METAL1", outer_f="FLOOR4_8",
      step_w="STEP1", side_w="METAL1", step_f="FLOOR4_8",
    },
  },
  
  launch_pad_sml_S =
  {
    prefab = "LAUNCH_PAD_SMALL",

    skin =
    {
      pad_f="FLAT1", letter_f="CRATOP1",
      outer_w="METAL1", outer_f="FLOOR4_8",
      step_w="STEP1", side_w="METAL1", step_f="FLOOR4_8",
    },
  },
 
  tech_pickup_STONE =
  {
    prefab = "TECH_PICKUP_LARGE",

    skin =
    {
      wall="STONE2", floor="CEIL5_2", ceil="CEIL3_5",
      lite_w="LITE5", sky_c="F_SKY1",
      step_w="STEP1", carpet_f="FLOOR1_1",
    },
  },

  liquid_pickup_NUKAGE =
  {
    prefab = "LIQUID_PICKUP",
    
    skin =
    {
      wall="METAL", floor="CEIL5_2", ceil="CEIL5_2",

      liquid_f="NUKAGE1", sky_c="F_SKY1",
    },
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
    skin   = { comp_f="CONS1_5", side_w="SILVER1" },
    force_dir = 8,
  },

  comp_desk_EW2 =
  {
    prefab = "COMPUTER_DESK",
    skin   = { comp_f="CONS1_1", side_w="SILVER1" },
    force_dir = 2,
  },

  comp_desk_NS6 =
  {
    prefab = "COMPUTER_DESK",
    skin   = { comp_f="CONS1_7", side_w="SILVER1" },
    force_dir = 6,
  },

  comp_desk_USHAPE1 =
  {
    prefab = "COMPUTER_DESK_U_SHAPE",
    skin   =
    {
      comp_Nf="CONS1_1", comp_Wf="CONS1_7",
      comp_Sf="CONS1_5",
      comp_cf="COMP01", side_w ="SILVER1"
    },
    force_dir = 8,
  },

  comp_desk_USHAPE2 =
  {
    prefab = "COMPUTER_DESK_HUGE",
    skin   =
    {
      comp_Nf="CONS1_1", comp_Wf="CONS1_7",
      comp_Sf="CONS1_5",
      comp_cf="COMP01", side_w ="SILVER1"
    },
    force_dir = 8,
  },

  skylight_mega_METAL =
  {
    prefab = "SKYLIGHT_MEGA_1",

    skin =
    { 
      sky_c = "F_SKY1",
      frame_w = "METAL", frame_c = "CEIL5_2",
      beam_w = "METAL", beam_c = "CEIL5_2",
    }
  },

  skylight_mega_METALWOOD =
  {
    prefab = "SKYLIGHT_MEGA_2",

    skin =
    { 
      sky_c = "F_SKY1",
      frame_w = "METAL", frame_c = "CEIL5_2",
      beam_w = "WOOD12", beam_c = "FLAT5_2",
    }
  },

  skylight_cross_sm_METAL =
  {
    prefab = "SKYLIGHT_CROSS_SMALL",

    skin =
    { 
      sky_c = "F_SKY1",
      frame_w = "METAL", frame_c = "CEIL5_2",
    }
  },

  drinks_bar_WOOD_POTION =
  {
    prefab = "DRINKS_BAR",

    skin = { bar_w = "PANBORD1", bar_f = "FLAT5_2",
             drink_t = "potion",
           }
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
    }
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

  crate_rotnar_SILVER =
  {
    prefab = "CRATE_ROTATE_NARROW",

    skin =
    {
      crate_h = 64,
      crate_w = "SILVER2",
      crate_f = "FLAT23"
    }
  },

  crate_triple_A =
  {
    prefab = "CRATE_TRIPLE",

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

    skin =
    {
      crate_w1 = "CRATE2", crate_f1 = "CRATOP1",
      crate_w2 = "CRATE1", crate_f2 = "CRATOP2",
      crate_w3 = "CRATE1", crate_f3 = "CRATOP2",
      small_w  = "CRATELIT", small_f = "CRATOP1",
    },
  },

  crate_jumble =
  {
    prefab = "CRATE_JUMBLE",

    skin =
    {
      tall_w   = "CRATE1",   tall_f = "CRATOP2",
      wide_w   = "CRATWIDE", wide_f = "CRATOP1",

      crate_w1 = "CRATE1", crate_f1 = "CRATOP2",
      crate_w2 = "CRATE2", crate_f2 = "CRATOP1",
    },
  },

  cage_pillar_METAL =
  {
    prefab = "CAGE_PILLAR",

    skin =
    {
      cage_w = "METAL",
      cage_f = "CEIL5_2", cage_c = "TLITE6_4",
      rail_w = "MIDGRATE", rail_h = 72,
    }
  },

  cage_small_METAL =
  {
    prefab = "CAGE_SMALL",

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

    skin =
    {
      cage_w = "METAL",
      cage_f = "CEIL5_2",

      rail_w = "MIDBARS3",
    }
  },

  cage_large_METAL =
  {
    prefab = "CAGE_LARGE",

    skin =
    {
      cage_w = "METAL",
      cage_f = "CEIL5_2",

      rail_w = "MIDBARS3",
    }
  },

  cage_large_liq_NUKAGE =
  {
    prefab = "CAGE_LARGE_W_LIQUID",

    skin =
    {
      liquid_f = "NUKAGE1",

      cage_w = "SLADWALL",
      cage_f = "CEIL5_2",
      cage_sign_w = "SLADPOIS",

      rail_w = "MIDBARS3",
    }
  },

  cage_medium_liq_BLOOD =
  {
    prefab = "CAGE_MEDIUM_W_LIQUID",

    skin =
    {
      liquid_f = "BLOOD1",

      cage_w = "GSTFONT1",
      cage_f = "FLOOR7_2",

      rail_w = "MIDBARS3",
    }
  },

  cage_medium_liq_LAVA =
  {
    prefab = "CAGE_MEDIUM_W_LIQUID",

    skin =
    {
      liquid_f = "LAVA1",

      cage_w = "BRNPOIS",
      cage_f = "CEIL5_2",

      rail_w = "MIDBARS3",
    }
  },

  exit_hole_SKY =
  {
    prefab = "EXIT_HOLE_ROUND",

    skin = { hole_f="F_SKY1" },
--FIXME  HOLE.walk_kind = 52 -- "exit_W1"
--FIXME  HOLE.is_cage = true  -- don't place items/monsters here
  },

  exit_deathmatch_TECH =
  {
    prefab = "EXIT_DEATHMATCH",

    skin = { wall="TEKWALL4", front_w="TEKWALL4",
             floor="CEIL4_3", ceil="TLITE6_5",
             switch_w="SW1COMM", side_w="SHAWN2", switch_f="FLAT23",
             frame_f="FLAT1", frame_c="FLAT1", step_w="STEP1",
             door_w="EXITDOOR", door_c="FLAT1", track_w="DOORTRAK",
             switch_yo=0,
             door_kind=1, tag=0, switch_kind=11
           },
  },

  exit_deathmatch_METAL =
  {
    prefab = "EXIT_DEATHMATCH",

    skin = { wall="METAL1", front_w="METAL1",
             floor="FLOOR5_1", ceil="TLITE6_4",
             switch_w="SW1BLUE", side_w="COMPBLUE", switch_f="FLAT14",
             frame_f="FLOOR5_1", frame_c="TLITE6_6", step_w="STEP1",
             door_w="EXITDOOR", door_c="FLAT1", track_w="DOORTRAK",
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
             switch_yo=56,
             door_kind=1, tag=0, switch_kind=11
           },
  },
}

D2_ROOMS =
{
}

D2_THEMES =
{
}

------------------------------------------------------------

GAME_FACTORIES["doom2"] = function()

  local T = GAME_FACTORIES.doom_common()

  T.combos   = copy_and_merge(T.combos,   D2_COMBOS)
  T.exits    = copy_and_merge(T.exits,    D2_EXITS)
  T.hallways = copy_and_merge(T.hallways, D2_HALLWAYS)

  T.rails = D2_RAILS

  T.secrets = D2_SECRET_LEVELS

  T.hangs   = copy_and_merge(T.hangs,   D2_OVERHANGS)
  T.crates  = copy_and_merge(T.crates,  D2_CRATES)
  T.mats    = copy_and_merge(T.mats,    D2_MATS)
  T.doors   = copy_and_merge(T.doors,   D2_DOORS)
  T.lights  = copy_and_merge(T.lights,  D2_LIGHTS)
  T.pics    = copy_and_merge(T.pics,    D2_PICS)
  T.liquids = copy_and_merge(T.liquids, D2_LIQUIDS)

  T.monsters = copy_and_merge(T.monsters, D2_MONSTERS)

  T.scenery = copy_and_merge(T.scenery, D2_SCENERY)
  T.sc_fabs = copy_and_merge(T.sc_fabs, D2_PREFAB_SCENERY)
  T.rooms   = copy_and_merge(T.rooms,   D2_ROOMS)
  T.themes  = copy_and_merge(T.themes,  D2_THEMES)

  return T
end

