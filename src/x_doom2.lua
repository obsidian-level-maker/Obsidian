----------------------------------------------------------------
-- GAME DEF : Doom II
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

DM_THINGS =
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


-----==============######################==============-----


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

    scenery = { candelabra=6, evil_eye=3 },

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

    scenery = { mercury_lamp=5, short_lamp=5 },
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

    scenery = { red_pillar=5, red_column=5, red_column_skl=5 },

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

    scenery = { burnt_tree=5, big_tree=5 },
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

    scenery = { skull_rock=5, brown_stub=3, evil_eye=5 },

    theme_probs = { HELL=30 },
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

    scenery = { red_torch=5, red_torch_sm=3 },
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

    scenery = { green_torch=5, green_torch_sm=3 },

    theme_probs = { URBAN=20 },
  },


  ---- Wolf3D Emulation ----

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

    switch =
    {
      prefab="SWITCH_NICHE_TINY_DEEP",
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

    sign = "EXITSIGN",
    sign_ceil="CEIL5_2",

---###    flush = true,
---###    flush_left  = "SK_LEFT",
---###    flush_right = "SK_RIGHT",

    switch =
    {
      prefab="SWITCH_FLUSH",
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
    mat_pri = 0,

    wall = "BSTONE2",
    void = "BSTONE2",
    step = "METAL",
    pillar = "BSTONE3",

    floor = "FLAT5",
    ceil  = "FLAT1",

    theme_probs = { URBAN=50,NATURE=50,CAVE=30 },
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
    void = "TEKGREN2",
    step = "STEP2",
    pillar = "TEKGREN3",  -- was: "BRONZE2"

    floor = "FLOOR3_3",
    ceil  = "GRNLITE1",

    well_lit = true,

    theme_probs = { TECH=80,INDUSTRIAL=40 },
    trim_mode = "guillotine",
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

D2_SCENERY =
{
}

D2_SCENERY_PREFABS =
{
  --[[
  pedestal_PLAYER =
  {
    prefab = "PEDESTAL",
    skin = { wall="SHAWN2", floor="FLAT22", ped_h=8 },
  },

  pedestal_KEY =
  {
    prefab = "PEDESTAL",
    skin = { wall="METAL", floor="GATE4", ped_h=16 },
  },

  pedestal_WEAPON =
  {
    prefab = "PEDESTAL",
    skin = { wall="METAL", floor="CEIL1_2", ped_h=12 },
  },
  --]]

  billboard_NAZI =
  {
    prefab = "BILLBOARD",
    environment = "outdoor",
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

  drinks_bar_WOOD_POTION =
  {
    prefab = "DRINKS_BAR",
    min_height = 64,

    skin = { bar_w = "PANBORD1", bar_f = "FLAT5_2",
             drink_t = "potion",
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

  cage_small_METAL =
  {
    prefab = "CAGE_SMALL",
    add_mode = "island",
    min_height = 144,

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

    skin =
    {
      cage_w = "METAL",
      cage_f = "CEIL5_2",

      rail_w = "MIDBARS3",
    },

    force_dir = 2, -- optimisation
  },

}


D2_FEATURE_PREFABS =
{
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

    force_dir = 2, -- optimisation
  },

  machine_pump1 =
  {
    prefab = "MACHINE_PUMP",
    environment = "indoor",
    add_mode = "island",

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
  
  four_sided_pic_ADOLF =
  {
    prefab = "WALL_PIC_FOUR_SIDED",
    environment = "outdoor",
    add_mode = "island",
    min_height = 192,
    skin = { pic_w="ZZWOLF7" },
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
    }
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

    pickup_specialness = 60,
    force_dir = 2,
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

    skin =
    {
      cage_w = "METAL",
      cage_f = "CEIL5_2",

      rail_w = "MIDBARS3",
    },

    force_dir = 2, -- optimisation
  },

  cage_large_liq_NUKAGE =
  {
    prefab = "CAGE_LARGE_W_LIQUID",
    add_mode = "island",
    min_height = 256,

    skin =
    {
      liquid_f = "NUKAGE1",

      cage_w = "SLADWALL",
      cage_f = "CEIL5_2",
      cage_sign_w = "SLADPOIS",

      rail_w = "MIDBARS3",
    },

    force_dir = 2, -- optimisation
  },

  cage_medium_liq_BLOOD =
  {
    prefab = "CAGE_MEDIUM_W_LIQUID",
    add_mode = "island",
    min_height = 160,

    skin =
    {
      liquid_f = "BLOOD1",

      cage_w = "GSTFONT1",
      cage_f = "FLOOR7_2",

      rail_w = "MIDBARS3",
    },

    force_dir = 2, -- optimisation
  },

  cage_medium_liq_LAVA =
  {
    prefab = "CAGE_MEDIUM_W_LIQUID",
    add_mode = "island",

    skin =
    {
      liquid_f = "LAVA1",

      cage_w = "BRNPOIS",
      cage_f = "CEIL5_2",

      rail_w = "MIDBARS3",
    },

    force_dir = 2, -- optimisation
  },
}

D2_WALL_PREFABS =
{
  wall_pic_TV =
  {
    prefab = "WALL_PIC",
    min_height = 160,

    skin = { pic_w="SPACEW3", lite_w="SUPPORT2" },

    theme_probs = { TECH=90, INDUSTRIAL=30 },
  },

  wall_pic_2S_EAGLE =
  {
    prefab = "WALL_PIC_TWO_SIDED",
    min_height = 160,
    skin = { pic_w="ZZWOLF6", lite_w="LITE5" },

    theme_probs = { URBAN=20 }, 
  },

  cage_niche_MIDGRATE =
  {
    prefab = "CAGE_NICHE",
    add_mode = "wall",

    min_height = 160,

    skin =
    {
      rail_w = "MIDGRATE",
      rail_h = 128,
    },

  },
}

D2_DOOR_PREFABS =
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

D2_DEATHMATCH_EXITS =
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

D2_MISC_PREFABS =
{
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

D2_ROOMS =
{
  WAREHOUSE =
  {
    -- crate it up baby!

    sc_fabs =
    {
      crate_triple_A = 70,
      crate_triple_B = 70,
      crate_CRATE1 = 40,
      crate_CRATE2 = 40,
      crate_WIDE = 50,
      crate_rotate_CRATE1 = 20,
      crate_rotate_CRATE2 = 20,

      other = 50
    },
  },

  PLANT =
  {
    sc_fabs =
    {
---   machine_pump1 = 50,   [feature prefab]
      crate_TV = 10,
      comp_desk_EW8 = 10,
      comp_desk_EW2 = 10,
      comp_desk_NS6 = 10,
      other = 50
    },

    wall_fabs =
    {
      wall_pic_TV = 30, 
      other = 100
    },
  },

  COMPUTER =
  {
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
    scenery =
    {
      impaled_human  = 10, impaled_twitch = 10,
      gutted_victim1 = 10, gutted_victim2 = 10,
      gutted_torso1  = 10, gutted_torso2  = 10,
      gutted_torso3  = 10, gutted_torso4  = 10,

      hang_arm_pair  = 10, hang_leg_pair  = 10,
      hang_leg_gone  = 10, hang_leg       = 10,
      hang_twitching = 10,

      pool_blood_1  = 40,
      pool_blood_2  = 40, pool_brains   = 40,

      other = 100
    },

    wall_fabs =
    {
      cage_niche_MIDGRATE = 30,
      other = 100
    },
  },

  PRISON =
  {
  },

  -- TODO: check in-game level names for ideas
}

D2_THEMES =
{
}

------------------------------------------------------------

D2_QUESTS =
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

---##  exit = { exit=50 },
---##
---##  secret_exit = { secret_exit=50 },
}

D2_EPISODE_THEMES =
{
  { URBAN=4, INDUSTRIAL=3, TECH=3, NATURE=9, CAVE=2, HELL=2 },
  { URBAN=9, INDUSTRIAL=5, TECH=6, NATURE=4, CAVE=2, HELL=4 },
  { URBAN=5, INDUSTRIAL=2, TECH=5, NATURE=3, CAVE=2, HELL=8 },
}

D2_SECRET_KINDS =
{
  MAP31 = "wolfy",
  MAP32 = "wolfy",
}

D2_SECRET_EXITS =
{
  MAP15 = true,
  MAP31 = true,
}

D2_LEVEL_BOSSES =
{
  MAP07 = "mancubus",
  MAP20 = "spider_mastermind",
  MAP30 = "boss_brain",
  MAP32 = "commander_keen",
}

D2_SKY_INFO =
{
  { color="brown",  light=192 },
  { color="gray",   light=192 }, -- bright clouds + dark buildings
  { color="red",    light=192 },
}

D2_EPISODE_INFO =
{
  { start=1,  len=11 },
  { start=12, len=11 },  -- last two are MAP31, MAP32
  { start=21, len=10 },
}

function doom2_get_levels(episode)

  assert(GAME.sky_info)

  local level_list = {}

  local theme_probs = D2_EPISODE_THEMES[episode]
  if SETTINGS.length ~= "full" then
    theme_probs = D2_EPISODE_THEMES[rand_irange(1,3)]
  end
  assert(theme_probs)

  local ep_start  = D2_EPISODE_INFO[episode].start
  local ep_length = D2_EPISODE_INFO[episode].len

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
    }

    -- fixup for secret levels
    if episode == 2 and map >= 10 then
      Level.name = string.format("MAP%02d", 21+map)
      Level.sky_info = D2_SKY_INFO[3]
      Level.theme_probs = { WOLF=10 }
    end

    Level.boss_kind   = D2_LEVEL_BOSSES[Level.name]
    Level.secret_kind = D2_SECRET_KINDS[Level.name]
    Level.secret_exit = D2_SECRET_EXITS[Level.name]

    std_decide_quests(Level, D2_QUESTS, DM_QUEST_LEN_PROBS)

    table.insert(level_list, Level)
  end

  return level_list
end


------------------------------------------------------------

GAME_FACTORIES["doom2"] = function()

  local T = doom_common_factory()

  T.episodes   = 3
  T.level_func = doom2_get_levels

  T.quests   = D2_QUESTS
  T.sky_info = D2_SKY_INFO

  T.themes   = copy_and_merge(T.themes,   D2_THEMES)
  T.rooms    = copy_and_merge(T.rooms,    D2_ROOMS)
  T.monsters = copy_and_merge(T.monsters, D2_MONSTERS)

  T.combos   = copy_and_merge(T.combos,   D2_COMBOS)
  T.hallways = copy_and_merge(T.hallways, D2_HALLWAYS)
  T.exits    = copy_and_merge(T.exits,    D2_EXITS)

  T.rails = D2_RAILS

  T.hangs   = copy_and_merge(T.hangs,   D2_OVERHANGS)
  T.crates  = copy_and_merge(T.crates,  D2_CRATES)
  T.mats    = copy_and_merge(T.mats,    D2_MATS)
  T.doors   = copy_and_merge(T.doors,   D2_DOORS)
  T.lights  = copy_and_merge(T.lights,  D2_LIGHTS)
  T.pics    = copy_and_merge(T.pics,    D2_PICS)
  T.liquids = copy_and_merge(T.liquids, D2_LIQUIDS)

  T.sc_fabs   = copy_and_merge(T.sc_fabs,   D2_SCENERY_PREFABS)
  T.feat_fabs = copy_and_merge(T.feat_fabs, D2_FEATURE_PREFABS)
  T.wall_fabs = copy_and_merge(T.wall_fabs, D2_WALL_PREFABS)
  T.door_fabs = copy_and_merge(T.door_fabs, D2_DOOR_PREFABS)
  T.misc_fabs = copy_and_merge(T.misc_fabs, D2_MISC_PREFABS)

  T.dm_exits = D2_DEATHMATCH_EXITS  -- FIXME: doom1

  return T
end

