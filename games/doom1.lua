----------------------------------------------------------------
-- GAME DEF : Doom I
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

DOOM_THINGS =
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

  ss_dude   = { id=84, kind="monster", r=20, h=56 },
  keen      = { id=72, kind="monster", r=16, h=72, ceil=true },

  -- bosses --
  Mastermind = { id=7,  kind="monster", r=128,h=100 },
  Cyberdemon = { id=16, kind="monster", r=40, h=110 },

  --- PICKUPS ---

  kc_red     = { id=13, kind="pickup", r=20,h=16, pass=true },
  kc_yellow  = { id=6,  kind="pickup", r=20,h=16, pass=true },
  kc_blue    = { id=5,  kind="pickup", r=20,h=16, pass=true },

  ks_red     = { id=38, kind="pickup", r=20,h=16, pass=true },
  ks_yellow  = { id=39, kind="pickup", r=20,h=16, pass=true },
  ks_blue    = { id=40, kind="pickup", r=20,h=16, pass=true },

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


DOOM_LINE_TYPES =
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

DOOM_SECTOR_TYPES =
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

DOOM_PALETTE =
{
    0,  0,  0,  31, 23, 11,  23, 15,  7,  75, 75, 75, 255,255,255,
   27, 27, 27,  19, 19, 19,  11, 11, 11,   7,  7,  7,  47, 55, 31,
   35, 43, 15,  23, 31,  7,  15, 23,  0,  79, 59, 43,  71, 51, 35,
   63, 43, 27, 255,183,183, 247,171,171, 243,163,163, 235,151,151,
  231,143,143, 223,135,135, 219,123,123, 211,115,115, 203,107,107,
  199, 99, 99, 191, 91, 91, 187, 87, 87, 179, 79, 79, 175, 71, 71,
  167, 63, 63, 163, 59, 59, 155, 51, 51, 151, 47, 47, 143, 43, 43,
  139, 35, 35, 131, 31, 31, 127, 27, 27, 119, 23, 23, 115, 19, 19,
  107, 15, 15, 103, 11, 11,  95,  7,  7,  91,  7,  7,  83,  7,  7,
   79,  0,  0,  71,  0,  0,  67,  0,  0, 255,235,223, 255,227,211,
  255,219,199, 255,211,187, 255,207,179, 255,199,167, 255,191,155,
  255,187,147, 255,179,131, 247,171,123, 239,163,115, 231,155,107,
  223,147, 99, 215,139, 91, 207,131, 83, 203,127, 79, 191,123, 75,
  179,115, 71, 171,111, 67, 163,107, 63, 155, 99, 59, 143, 95, 55,
  135, 87, 51, 127, 83, 47, 119, 79, 43, 107, 71, 39,  95, 67, 35,
   83, 63, 31,  75, 55, 27,  63, 47, 23,  51, 43, 19,  43, 35, 15,
  239,239,239, 231,231,231, 223,223,223, 219,219,219, 211,211,211,
  203,203,203, 199,199,199, 191,191,191, 183,183,183, 179,179,179,
  171,171,171, 167,167,167, 159,159,159, 151,151,151, 147,147,147,
  139,139,139, 131,131,131, 127,127,127, 119,119,119, 111,111,111,
  107,107,107,  99, 99, 99,  91, 91, 91,  87, 87, 87,  79, 79, 79,
   71, 71, 71,  67, 67, 67,  59, 59, 59,  55, 55, 55,  47, 47, 47,
   39, 39, 39,  35, 35, 35, 119,255,111, 111,239,103, 103,223, 95,
   95,207, 87,  91,191, 79,  83,175, 71,  75,159, 63,  67,147, 55,
   63,131, 47,  55,115, 43,  47, 99, 35,  39, 83, 27,  31, 67, 23,
   23, 51, 15,  19, 35, 11,  11, 23,  7, 191,167,143, 183,159,135,
  175,151,127, 167,143,119, 159,135,111, 155,127,107, 147,123, 99,
  139,115, 91, 131,107, 87, 123, 99, 79, 119, 95, 75, 111, 87, 67,
  103, 83, 63,  95, 75, 55,  87, 67, 51,  83, 63, 47, 159,131, 99,
  143,119, 83, 131,107, 75, 119, 95, 63, 103, 83, 51,  91, 71, 43,
   79, 59, 35,  67, 51, 27, 123,127, 99, 111,115, 87, 103,107, 79,
   91, 99, 71,  83, 87, 59,  71, 79, 51,  63, 71, 43,  55, 63, 39,
  255,255,115, 235,219, 87, 215,187, 67, 195,155, 47, 175,123, 31,
  155, 91, 19, 135, 67,  7, 115, 43,  0, 255,255,255, 255,219,219,
  255,187,187, 255,155,155, 255,123,123, 255, 95, 95, 255, 63, 63,
  255, 31, 31, 255,  0,  0, 239,  0,  0, 227,  0,  0, 215,  0,  0,
  203,  0,  0, 191,  0,  0, 179,  0,  0, 167,  0,  0, 155,  0,  0,
  139,  0,  0, 127,  0,  0, 115,  0,  0, 103,  0,  0,  91,  0,  0,
   79,  0,  0,  67,  0,  0, 231,231,255, 199,199,255, 171,171,255,
  143,143,255, 115,115,255,  83, 83,255,  55, 55,255,  27, 27,255,
    0,  0,255,   0,  0,227,   0,  0,203,   0,  0,179,   0,  0,155,
    0,  0,131,   0,  0,107,   0,  0, 83, 255,255,255, 255,235,219,
  255,215,187, 255,199,155, 255,179,123, 255,163, 91, 255,143, 59,
  255,127, 27, 243,115, 23, 235,111, 15, 223,103, 15, 215, 95, 11,
  203, 87,  7, 195, 79,  0, 183, 71,  0, 175, 67,  0, 255,255,255,
  255,255,215, 255,255,179, 255,255,143, 255,255,107, 255,255, 71,
  255,255, 35, 255,255,  0, 167, 63,  0, 159, 55,  0, 147, 47,  0,
  135, 35,  0,  79, 59, 39,  67, 47, 27,  55, 35, 19,  47, 27, 11,
    0,  0, 83,   0,  0, 71,   0,  0, 59,   0,  0, 47,   0,  0, 35,
    0,  0, 23,   0,  0, 11,   0, 47, 47, 255,159, 67, 255,231, 75,
  255,123,255, 255,  0,255, 207,  0,207, 159,  0,155, 111,  0,107,
    0,255,255
};


----------------------------------------------------------------

COMMON_COMBOS =
{
  ---- TECH ------------

  TECH_BASE =
  {
    wall  = "STARTAN3",
    floor = "FLOOR4_8",
    ceil  = "CEIL3_5",

    floors = { "FLAT14",  "CEIL3_2", "FLAT9",
               "FLOOR0_1", "FLOOR0_3", "FLOOR0_7", "FLOOR3_3",
               "FLOOR4_5", "FLOOR4_6", "FLOOR4_8", "FLOOR5_2",
               "SLIME15",  "SLIME16"
             },

    ceilings = { "CEIL5_1",  "CEIL5_2",
                 "CEIL3_3",  "CEIL3_5",
                 "FLAT1",    "FLAT4",    "FLAT18",
                 "FLOOR0_2", "FLOOR4_1", "FLOOR5_1",
                 "GRNLITE1", "TLITE6_5"
               },

    pic_wd = "COMPSTA2",    -- "COMP2" for Doom 1 !!
    pic_wd_h = 64,

    lift = "PLAT1",
    step = "STEP1",
    step_floor = "STEP2",

    scenery = "lamp",
    good_liquid = "blood",

    sc_fabs = { pillar_COMPWERD=50, other=30 },
  },

  TECH_GREEN =
  {
    wall  = "STARG2",
    floor = "FLOOR5_1",
    ceil  = "FLOOR4_5",

    floors = { "FLAT14",  "CEIL3_2", "FLAT9",
               "FLOOR0_1", "FLOOR0_3", "FLOOR0_7", "FLOOR3_3",
               "FLOOR4_5", "FLOOR4_6", "FLOOR4_8", "FLOOR5_2",
               "SLIME15",  "SLIME16"
             },

    ceilings = { "CEIL5_1",  "CEIL5_2",
                 "CEIL3_3",  "CEIL3_5",
                 "FLAT1",    "FLAT4",    "FLAT18",
                 "FLOOR0_2", "FLOOR4_1", "FLOOR5_1",
                 "GRNLITE1", "TLITE6_5"
               },


    lift = "PLAT1",
    step = "STEP1",
    step_floor = "STEP1",

    scenery = "tech_column",

    sc_fabs = { pillar_COMPWERD=50, other=30 },
  },

  TECH_GROUND =
  {
    outdoor = true,

    wall  = "BROWN144",
    floor = "FLOOR7_1",
    ceil  = "FLOOR7_1",
  },

  TECH_SILVER =
  {
    wall  = "STARGR2",
    floor = "FLOOR0_1",
    ceil  = "FLAT3",

    floors = { "FLAT14",  "CEIL3_2", "FLAT9",
               "FLOOR0_1", "FLOOR0_3", "FLOOR0_7", "FLOOR3_3",
               "FLOOR4_5", "FLOOR4_6", "FLOOR4_8", "FLOOR5_2",
               "SLIME15",  "SLIME16"
             },

    ceilings = { "CEIL5_1",  "CEIL5_2",
                 "CEIL3_3",  "CEIL3_5",
                 "FLAT1",    "FLAT4",    "FLAT18",
                 "FLOOR0_2", "FLOOR4_1", "FLOOR5_1",
                 "GRNLITE1", "TLITE6_5"
               },

    lift = "PLAT1",
    step = "STEP1",
    step_floor = "STEP1",

    scenery = "tech_column",
  },

  TECH_BROWN =
  {
    wall  = "STARTAN2",  -- STARBR
    floor = "CEIL4_3",
    ceil  = "FLOOR5_1",

    floors = { "FLAT14",  "CEIL3_2", "FLAT9",
               "FLOOR0_1", "FLOOR0_3", "FLOOR0_7", "FLOOR3_3",
               "FLOOR4_5", "FLOOR4_6", "FLOOR4_8", "FLOOR5_2",
               "SLIME15",  "SLIME16"
             },

    ceilings = { "CEIL5_1",  "CEIL5_2",
                 "CEIL3_3",  "CEIL3_5",
                 "FLAT1",    "FLAT4",    "FLAT18",
                 "FLOOR0_2", "FLOOR4_1", "FLOOR5_1",
                 "GRNLITE1", "TLITE6_5"
               },

    lift = "PLAT1",
    step = "STEP1",
    step_floor = "STEP1",

    scenery = "tech_column",
  },

  TECH_GRAY =
  {
    wall  = "GRAY7",
    floor = "FLOOR0_5",
    ceil  = "FLAT1",

    floors = { "FLAT14",  "CEIL3_2", "FLAT9",
               "FLOOR0_1", "FLOOR0_3", "FLOOR0_7", "FLOOR3_3",
               "FLOOR4_5", "FLOOR4_6", "FLOOR4_8", "FLOOR5_2",
               "SLIME15",  "SLIME16"
             },

    ceilings = { "CEIL5_1",  "CEIL5_2",
                 "CEIL3_3",  "CEIL3_5",
                 "FLAT1",    "FLAT4",    "FLAT18",
                 "FLOOR0_2", "FLOOR4_1", "FLOOR5_1",
                 "GRNLITE1", "TLITE6_5"
               },

    lift = "SUPPORT3",
    pic_wd = "REDWALL",

--  lift_floor = "FLOOR4_8",

    scenery = { green_pillar=5, green_column=5, green_column_hrt=5 },

    sc_fabs = { crate_rotnar_GRAY2=30, other=50 },
  },

  TECH_METAL =
  {
    wall  = "METAL2",
    floor = "CEIL5_1",
    ceil  = "CEIL5_2",

    floors = { "FLAT14",  "CEIL3_2", "FLAT9",
               "FLOOR0_1", "FLOOR0_3", "FLOOR0_7", "FLOOR3_3",
               "FLOOR4_5", "FLOOR4_6", "FLOOR4_8", "FLOOR5_2",
               "SLIME15",  "SLIME16"
             },

    ceilings = { "CEIL5_1",  "CEIL5_2",
                 "CEIL3_3",  "CEIL3_5",
                 "FLAT1",    "FLAT4",    "FLAT18",
                 "FLOOR0_2", "FLOOR4_1", "FLOOR5_1",
                 "GRNLITE1", "TLITE6_5"
               },

    lift = "SUPPORT3",
    pic_wd = "REDWALL",

--  lift_floor = "FLOOR4_8",

    scenery = { green_pillar=5, green_column=5, green_column_hrt=5 },

    sc_fabs = { crate_rotnar_GRAY2=30, other=50 },
  },

  INDY_PIPES =  -- UNUSED (looks bad)
  {
    wall  = "PIPE2",
    floor = "FLAT1_1",
    ceil  = "FLAT1_1",

    floors = { "FLAT14",  "CEIL3_2", "FLAT9",
               "FLOOR0_1", "FLOOR0_3", "FLOOR0_7", "FLOOR3_3",
               "FLOOR4_5", "FLOOR4_6", "FLOOR4_8", "FLOOR5_2",
               "SLIME15",  "SLIME16"
             },

    ceilings = { "CEIL5_1",  "CEIL5_2",
                 "CEIL3_3",  "CEIL3_5",
                 "FLAT1",    "FLAT4",    "FLAT18",
                 "FLOOR0_2", "FLOOR4_1", "FLOOR5_1",
                 "GRNLITE1", "TLITE6_5"
               },

    step = "STEP1",
    lift = "SUPPORT3",
    pic_wd = "REDWALL",

--  lift_floor = "FLOOR4_8",

    scenery = { green_pillar=5, green_column=5, green_column_hrt=5 },

    wall_fabs = { solid_PIPE4=20, other=30 },
  },

  TECH_SLAD =
  {
    wall  = "SLADWALL",
    floor = "FLOOR0_5",
    ceil  = "CEIL5_1",

    floors = { "FLAT14",  "CEIL3_2", "FLAT9",
               "FLOOR0_1", "FLOOR0_3", "FLOOR0_7", "FLOOR3_3",
               "FLOOR4_5", "FLOOR4_6", "FLOOR4_8", "FLOOR5_2",
               "SLIME15",  "SLIME16"
             },

    ceilings = { "CEIL5_1",  "CEIL5_2",
                 "CEIL3_3",  "CEIL3_5",
                 "FLAT1",    "FLAT4",    "FLAT18",
                 "FLOOR0_2", "FLOOR4_1", "FLOOR5_1",
                 "GRNLITE1", "TLITE6_5"
               },

--  void = "SLADSKUL",
    step = "STEP1",

    vista_support = "DOORSTOP",

    scenery = "burning_barrel",
    good_liquid = "nukage",

    sc_fabs = { pillar_rnd_sm_POIS=50, other=30 },

    wall_fabs = { solid_SLADSKUL=30, other=50 },
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
    outdoor = true,

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
    outdoor = true,

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


  ---- SPECIAL --------
 
  WATER_SKY =
  {
    outdoor = true,
    mat_pri = 0,

    wall  = "STONE",
    floor = "FWATER1",
    ceil  = "FLAT1",
  },
}

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


COMMON_MATERIALS =  -- FIXME: SOME ARE DOOM2 only!
{
  metal   = { "METAL",    "CEIL5_2"  },
  hexmet  = { "METAL1",   "FLOOR4_8" },
  dark    = { "COMPSPAN", "CEIL5_1"  },
  shiny   = { "SHAWN2",   "FLAT23"   },

  stone   = { "STONE2",   "MFLR8_1"  },
  bigbrik = { "BIGBRIK1", "RROCK14"  },
  rock    = { "ROCK3",    "RROCK13"  },

  sand    = { "ASHWALL2", "MFLR8_4"  },
  grass   = { "ZIMMER2",  "GRASS2"   },
  dirt    = { "ASHWALL4", "FLAT10"   },
  stucco  = { "STUCCO",   "FLAT5_5"  },

  wood    = { "WOOD12",   "FLAT5_2"  },
  marble  = { "MARBLE1",  "FLOOR7_2" },
  gray    = { "GRAY7",    "FLAT1"    },  
  brown   = { "BROWNHUG", "FLOOR7_1" },

  black   = { "BLAKWAL1", "O_BLACK"  },
  blue    = { "COMPBLUE", "FLAT14"   },
  red     = { "REDWALL",  "FLAT5_3"  },
}

--- PEDESTALS --------------

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


---- ARCH STUFF ------------

COMMON_LIQUIDS =
{
  water = { floor="FWATER1", wall="FIREMAG1" },
  blood = { floor="BLOOD1",  wall="BFALL1",   sec_kind=7 }, --  5% damage
  nukage= { floor="NUKAGE1", wall="SFALL1",   sec_kind=5 }, -- 10% damage
  lava  = { floor="LAVA1",   wall="ROCKRED1", sec_kind=16, add_light=64 }, -- 20% damage
}

COMMON_DOORS =
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

--[[ !!! COMMON_DOORS
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


COMMON_SWITCH_INFOS =
{
  sw_blue =
  {
      prefab = "SWITCH_FLOOR",
      skin =
      {
        switch_w="SW1BLUE", side_w="COMPBLUE",
        switch_f="FLAT14", switch_h=64,

        beam_w="WOOD1", beam_f="FLAT5_2",

        x_offset=0, y_offset=56, line_kind=103,
      }
  },

  sw_blue2 =
    {
      prefab = "SWITCH_FLOOR_BEAM",
      skin =
      {
        switch_w="SW1BLUE", side_w="COMPBLUE",
        switch_f="FLAT14", switch_h=64,

        beam_w="WOOD1", beam_f="FLAT5_2",

        x_offset=0, y_offset=56, line_kind=103,
      }
    },


  sw_hot =
  {
      prefab = "SWITCH_PILLAR",
      skin =
      {
        switch_w="SW1HOT", side_w="SP_HOT1",
        switch_f="FLAT5_3",
        x_offset=0, y_offset=52,
        line_kind=103,
      }

  },

  sw_skin =
  {
      prefab = "SWITCH_PILLAR",
      skin =
      {
        switch_w="SW1SKIN", side_w="SKSNAKE2",
        switch_f="SFLR6_4",
        x_offset=0, y_offset=52,
        line_kind=103,
      }
  },

  sw_vine =
  {
      prefab = "SWITCH_PILLAR",
      skin =
      {
        switch_w="SW1VINE", side_w="GRAYVINE",
        switch_f="FLAT1",
        x_offset=0, y_offset=64,
        line_kind=103,
      }
  },

  sw_metl =
  {
      prefab = "SWITCH_CEILING",
      environment = "indoor",
      skin =
      {
        switch_w="SW1GARG", side_w="METAL",
        switch_c="CEIL5_2", switch_h=56,

        beam_w="SUPPORT3", beam_c="CEIL5_2",

        x_offset=0, y_offset=64, line_kind=23,
      }
  },

  bar_wood =
  {
      prefab = "SWITCH_PILLAR",
      skin =
      {
        switch_w="SW1WOOD", side_w="WOOD9",
        switch_f="FLAT5_2",
        x_offset=0, y_offset=56,
        line_kind=23,
      }
  },

  bar_silver =
  {
      prefab = "SWITCH_PILLAR",
      skin =
      {
        switch_w="SW1COMM", side_w="SHAWN2",
        switch_f="FLAT23",
        x_offset=0, y_offset=0,
        line_kind=23,
      }
  },

  bar_metal =
  {
      prefab = "SWITCH_PILLAR",
      skin =
      {
        switch_w="SW1MET2", side_w="METAL2",
        switch_f="CEIL5_2",
        x_offset=0, y_offset=0,
        line_kind=23,
      }
  },

  bar_gray =
  {
      prefab = "SWITCH_PILLAR",
      skin =
      {
        switch_w="SW1GRAY1", side_w="GRAY1", line_kind=23,
        switch_f="FLAT1",
      }

  },

--FIXME: (not in doom1)  sw_rock = { wall="ROCK3",    switch="SW1ROCK",  floor="RROCK13", bars=true },
--FIXME:  sw_wood = { wall="WOODMET1", switch="SW1WDMET", floor="FLAT5_1", bars=true, stand_h=128 },

}

COMMON_SWITCH_DOORS =
{
  sw_blue =
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
        line_kind=0,
      }
  },

  sw_hot =
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
        line_kind=0,
      }

  },

  sw_skin =
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
        line_kind=0,
      }
  },

  sw_vine =
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
        line_kind=0,
      }
  },

  sw_metl =
  {
      w=128, h=128,
      prefab = "BARS_1",
      skin =
      {
        bar_w="SUPPORT3", bar_f="CEIL5_2",
        line_kind=0,
      }
  },

  bar_wood =
  {
      skin =
      {
        bar_w="WOOD9",
        bar_f="FLAT5_2",
        bar_h=64,
        line_kind=0,
      }
  },

  bar_silver =
  {
      skin =
      {
        bar_w="SUPPORT2",
        bar_f="FLAT23",
        bar_h=64,
        line_kind=0,
      }
  },

  bar_metal =
  {
      skin =
      {
        bar_w="SUPPORT3",
        bar_f="CEIL5_2",
        bar_h=64,
        line_kind=0,
      }
  },

  bar_gray =
  {
      w=128, h=128,
      prefab = "BARS_2",
      skin =
      {
        bar_w="GRAY7", bar_f="FLAT19",
        line_kind=0
      },
  },

--FIXME: (not in doom1)  sw_rock = { wall="ROCK3",    switch="SW1ROCK",  floor="RROCK13", bars=true },
--FIXME:  sw_wood = { wall="WOODMET1", switch="SW1WDMET", floor="FLAT5_1", bars=true, stand_h=128 },

}

COMMON_KEY_DOORS =
{
  kc_blue =
  {
    w=128, h=112,

    prefab = "DOOR_LIT_LOCKED",
    
    skin =
    {
      key_w="DOORBLU",
      door_w="BIGDOOR4", door_c="FLOOR3_3",
      step_w="STEP1",  track_w="DOORTRAK",
      frame_f="FLAT1", frame_c="FLAT1",
      door_h=112,
      line_kind=32, tag=0,  -- kind_mult=26
    }
  },

  kc_yellow =
  {
    w=128, h=112,

    prefab = "DOOR_LIT_LOCKED",

    skin =
    {
      key_w="DOORYEL",
      door_w="BIGDOOR4", door_c="FLOOR3_3",
      step_w="STEP1",  track_w="DOORTRAK",
      frame_f="FLAT1", frame_c="FLAT1",
      door_h=112,
      line_kind=34, tag=0, -- kind_mult=27
    }
  },

  kc_red =
  {
    w=128, h=112,

    prefab = "DOOR_LIT_LOCKED",

    skin =
    {
      key_w="DOORRED",
      door_w="BIGDOOR4", door_c="FLOOR3_3",
      step_w="STEP1",  track_w="DOORTRAK",
      frame_f="FLAT1", frame_c="FLAT1",
      door_h=112,
      line_kind=33, tag=0, -- kind_mult=28
    }
  },

  -- TODO: ks_*
}

COMMON_LIFTS =
{
  slow = { kind=62,  walk=88  },
  fast = { kind=123, walk=120 },
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
      door_w="BIGDOOR1", door_c="FLAT1",
      lite_w="LITE3", step_w="STEP1",
      key_w="LITE3",
      frame_f="FLAT1", frame_c="TLITE6_6",
      track_w="DOORTRAK",
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

COMMON_DEATHMATCH_EXITS =
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



COMMON_ROOMS =
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

COMMON_THEMES =
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

  TECH =
  {
    building =
    {
      TECH_BASE=35,
      TECH_GREEN=20,
      TECH_BROWN=20,
      TECH_SLAD=20,
      TECH_SILVER=10,
      TECH_GRAY=10,
      TECH_METAL=15,
      TECH_TEKGREN=10,  -- FIXME: DOOM II ONLY !!!!!
    },

    ground =
    {
      TECH_GROUND=50,
      URBAN_STONE=40,
      URBAN_BROWN=20,
    },

    hallway =
    {
      -- FIXME
    },

    exit =
    {
      -- FIXME
    },

    room_types =
    {
      -- FIXME  COMPUTER  WAREHOUSE  PUMP
    },

    scenery =
    {
      -- FIXME
    },

    monster_prefs =
    {
--!!!!      zombie=2.0, shooter=3.0, arach=2.0,
    },
  }, -- TECH

  HELL =
  {
    -- TODO: HELL THEME

    room_types =
    {
      -- FIXME  TORTURE  PRISON
    },

    monster_prefs =
    {
      zombie=0.1, shooter=0.3, arach=0.5,
      skull=3.0,  vile=2.0, mancubus=2.0,
    },
  },

  URBAN =
  {
    -- TODO: URBAN THEME

    room_types =
    {
      -- FIXME  PRISON  WAREHOUSE
    },

    monster_prefs =
    {
      caco=2.0, revenant=1.5, baron=3.0, knight=2.0,
    },
  },

}

COMMON_THEMES_OLD =
{
  NATURE =
  {
    door_probs   = { out_diff=75, combo_diff=10, normal=5 },
    window_probs = { out_diff=75, combo_diff=40, normal=40 },

    prefer_stairs = true,
  },

  CAVE =
  {
    cave_heights = { [96]=50, [128]=50 },

    diff_probs = { [0]=10, [16]=40, [32]=80, [64]=60, [96]=20 },
    bump_probs = { [0]=5, [16]=30, [32]=30, [64]=20 },
    door_probs   = { out_diff=10, combo_diff= 3, normal=1 },
    window_probs = { out_diff=20, combo_diff=30, normal=5 },

    prefer_stairs = true,
  },
}


------------------------------------------------------------

-- Monster list
-- ============
--
-- prob       : free-range probability
-- guard_prob : probability when guarding an item
-- cage_prob  : cage probability [absent = never]
-- trap_prob  : trap/surprise probability
--
-- health : hit points of monster
-- damage : damage can inflict per second (rough approx)
-- attack : kind of attack (hitscan | missile | melee)
--
-- float  : true if monster floats (flys)
-- invis  : true if invisible (or partially)
--
-- NOTES:
--
-- Some monsters (e.g. IMP) have both a close-range melee
-- attack and a longer range missile attack.  This is not
-- modelled, we just pick the one with the most damage.
--
-- Archvile attack is not a real hitscan, but for modelling
-- purposes that is a reasonable approximation.
--
-- Similarly the Pain Elemental attack is not a real missile
-- but actually a Lost Soul.  Also the numbers of lost souls
-- is limited on the level (to 20 or so).  Hence the damage
-- value is a rough guess / completely bogus.

COMMON_MONSTERS =
{
  zombie =
  {
    prob=40, cage_prob=11,
    health=20, damage=4, attack="hitscan",
    give={ {ammo="bullet",count=5} },
  },

  shooter =
  {
    prob=50, guard_prob=11, trap_prob=11, cage_prob=11,
    health=30, damage=10, attack="hitscan",
    give={ {weapon="shotty"}, {ammo="shell",count=4} },
  },

  imp =
  {
    prob=60, guard_prob=11, trap_prob=20, cage_prob=50,
    health=60, damage=20, attack="missile",
  },

  skull =
  {
    prob=20, trap_prob=11, cage_prob=11,
    health=100, damage=7, attack="melee",
    float=true,
  },

  demon =
  {
    prob=35, guard_prob=31, trap_prob=61,
    health=150, damage=25, attack="melee",
  },

  spectre =
  {
    prob=4, guard_prob=11, trap_prob=61,
    health=150, damage=25, attack="melee",
    invis=true,
  },

  caco =
  {
    prob=40, guard_prob=61, trap_prob=21, cage_prob=21,
    health=400, damage=35, attack="missile",
    float=true,
  },

  baron =
  {
    prob=20, guard_prob=11, trap_prob=11, cage_prob=3,
    health=1000, damage=45, attack="missile",
  },
}


DOOM2_MONSTERS =
{
  gunner =
  {
    prob=18, guard_prob=21, trap_prob=41, cage_prob=71,
    health=70, damage=50, attack="hitscan",
    give={ {weapon="chain"}, {ammo="bullet",count=10} },
  },

  revenant =
  {
    prob=50, guard_prob=41, trap_prob=41, cage_prob=51,
    health=300, damage=70, attack="missile",
  },

  knight =
  {
    prob=60, guard_prob=41, trap_prob=41, cage_prob=11,
    health=500, damage=45, attack="missile",
  },

  mancubus =
  {
    prob=33, guard_prob=41, trap_prob=41, cage_prob=11,
    health=600, damage=70, attack="missile",
  },

  arach =
  {
    prob=25, guard_prob=21, trap_prob=21, cage_prob=11,
    health=500, damage=70, attack="missile",
  },

  vile =
  {
    prob=12, guard_prob=11, trap_prob=31, cage_prob=21,
    health=700, damage=40, attack="hitscan", no_dist=true,
  },

  pain =
  {
    prob=6, trap_prob=11,
    health=400, damage=50, attack="missile",
    float=true,
  },

  ss_dude =
  {
    -- not generated in normal levels
    health=50, damage=15, attack="hitscan",
    give={ {ammo="bullet",count=5} },
  },


  ---| DOOM BOSSES |---

  Cyberdemon =
  {
    health=4000, damage=150, attack="missile",
  },

  Mastermind =
  {
    health=3000, damage=200, attack="hitscan",
  },
}



-- Weapon list
-- ===========
--
-- pref       : usage preference [absent = never]
-- add_prob   : probabiliiy of adding into level [absent = never]
-- start_prob : chance of appearing in start room
--
-- rate   : firing rate (shots per second)
-- damage : damage can inflict per shot
-- attack : kind of attack (hitscan | missile | melee)
-- splash : splash damage done to monsters (1st, 2nd, etc)
--
-- ammo  : ammo type [absent for no ammo weapons]
-- per   : ammo per shot
-- give  : ammo given when weapon is picked up
--
-- NOTES:
--
-- Berserk is not really an extra weapon, but a powerup which
-- makes fist do much more damage.  The effect lasts until the
-- end of the level, so a weapon is a pretty good fit.
--
-- Shotgun has a fairly low add_prob, since it is likely the
-- player will have encountered a shotgun zombie and already
-- have that weapon.
--
-- Supershotgun is not present in DOOM 1.  It is removed from
-- the weapon table in the Doom1_setup() function.

COMMON_WEAPONS =
{
  fist =
  {
    rate=1.5, damage=10, attack="melee",
  },

  saw =
  {
    pref=4, add_prob=2, start_prob=10,
    rate=8.7, damage=10, attack="melee",
  },

  berserk =
  {
    pref=10, add_prob=6, start_prob=20,
    rate=1.5, damage=90, attack="melee",
    give={ {health=70} },
  },

  pistol =
  {
    pref=10,
    rate=1.8, damage=10, attack="hitscan",
    ammo="bullet", per=1,
  },

  chain =
  {
    pref=70, add_prob=35, start_prob=30,
    rate=8.5, damage=10, attack="hitscan",
    ammo="bullet", per=1,
    give={ {ammo="bullet",count=20} },
  },

  shotty =
  {
    pref=70, add_prob=10, start_prob=80,
    rate=0.9, damage=70, attack="hitscan", splash={ 0,10 },
    ammo="shell", per=1,
    give={ {ammo="shell",count=8} },
  },

  super =
  {
    pref=70, add_prob=20, start_prob=3,
    rate=0.6, damage=170, attack="hitscan", splash={ 0,30 },
    ammo="shell", per=2,
    give={ {ammo="shell",count=8} },
  },

  launch =
  {
    pref=50, add_prob=25, start_prob=3,
    rate=1.7, damage=80, attack="missile", splash={ 50,20,5 },
    ammo="rocket", per=1,
    give={ {ammo="rocket",count=2} },
  },

  plasma =
  {
    pref=90, add_prob=13, start_prob=3,
    rate=11, damage=20, attack="missile",
    ammo="cell", per=1,
    give={ {ammo="cell",count=40} },
  },

  bfg =
  {
    pref=30, add_prob=25,
    rate=0.8, damage=300, attack="missile", splash={60,45,30,30,20,10},
    ammo="cell", per=40,
    give={ {ammo="cell",count=40} },
  },
}


-- sometimes a certain weapon is preferred against a certain monster.
-- These values are multiplied with the weapon's "pref" field.

COMMON_MONSTER_WEAPON_PREFS =
{
  zombie  = { shotty=6.0 },
  shooter = { shotty=6.0 },
  imp     = { shotty=6.0 },
  demon   = { super=3.0, launch=0.3 },
  spectre = { super=3.0, launch=0.3 },

  pain    = { launch=0.1 },
  skull   = { launch=0.1 },

  Cyberdemon = { launch=3.0, bfg=6.0 },
  Mastermind = { launch=3.0, bfg=9.0 },
}


-- Pickup List
-- ===========

COMMON_PICKUPS =
{
  -- HEALTH --

  potion =
  {
    prob=1, cluster={ 4,9 },
    give={ {health=1} },
  },

  stimpack =
  {
    prob=10, cluster={ 1,4 },
    give={ {health=10} },
  },

  medikit =
  {
    prob=40,
    give={ {health=25} },
  },

  soul =
  {
    prob=10,
    give={ {health=150} },
  },

  mega =
  {
    prob=2,
    give={ {health=200} },
  },

  -- ARMOR --

  helmet =
  {
    prob=5, cluster={ 4,9 },
    give={ {health=1} },
  },

  green_armor =
  {
    prob=5,
    give={ {health=30} },
  },

  blue_armor =
  {
    prob=5,
    give={ {health=90} },
  },

  -- AMMO --

  bullets =
  {
    prob=10, cluster={ 2,4 },
    give={ {ammo="bullet",count=10} },
  },

  bullet_box =
  {
    prob=70,
    give={ {ammo="bullet", count=50} },
  },

  shells =
  {
    prob=30, cluster={ 2,4 },
    give={ {ammo="shell",count=4} },
  },

  shell_box =
  {
    prob=50,
    give={ {ammo="shell",count=20} },
  },

  rockets =
  {
    prob=10, cluster={ 4,9 },
    give={ {ammo="rocket",count=1} },
  },

  rocket_box =
  {
    prob=50,
    give={ {ammo="rocket",count=5} },
  },

  cells =
  {
    prob=20, cluster={ 2,4 },
    give={ {ammo="cell",count=20} },
  },

  cell_pack =
  {
    prob=40,
    give={ {ammo="cell",count=100} },
  },


  -- NOTES:
  --
  -- Berserk is handled as a WEAPON instead of a pickup.
  --
  -- Backpack is handled as a POWERUP.
  --
  -- Armor (all types) is modelled as health, because it merely
  -- saves the player's health when you are hit with damage.
  -- The BLUE jacket saves 50% of damage, hence it is roughly
  -- equivalent to 100 units of health.
}



-- DeathMatch stuff
-- ================

COMMON_DEATHMATCH =
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


COMMON_INITIAL_MODEL =
{
  doomguy =
  {
    -- Note: bullet numbers are understated (should be 50)
    -- so that the player isn't forced to empty the pistol.

    health = 100,
    weapons = { fist=1, pistol=1 },
    ammo = { bullet=20, shell=0, rocket=0, cell=0 },
  }
}

---## COMMON_KEY_CARDS =
---## {
---##   red_cd    = { pickup="kc_red",    tex="DOORRED", door_kind=33 },
---##   blue_cd   = { pickup="kc_blue",   tex="DOORBLU", door_kind=32 },
---##   yellow_cd = { pickup="kc_yellow", tex="DOORYEL", door_kind=34 },
---## }
---## 
---## COMMON_SKULL_KEYS =
---## {
---##   red_sk    = { pickup="k_red",    tex="DOORRED2", door_kind=33 },
---##   blue_sk   = { pickup="k_blue",   tex="DOORBLU2", door_kind=32 },
---##   yellow_sk = { pickup="k_yellow", tex="DOORYEL2", door_kind=34 },
---## }


-----==============######################==============-----


---- QUEST STUFF ----------------

---## DOOM1_QUESTS =
---## {
---##   key =
---##   {
---##     k_blue=50, k_red=50, k_yellow=50
---##   },
---## 
---##   switch =
---##   {
---##     sw_blue=50, sw_hot=30,
---##     sw_vine=10, sw_skin=40,
---##     sw_metl=50, sw_gray=20,
---##   },
---## 
---##   weapon =
---##   {
---##     saw=10, launch=80, plasma=60, bfg=5
---##   },
---## 
---##   item =
---##   {
---##     blue_armor=40, invis=40, backpack=25,
---##     berserk=20, goggle=5, invul=2, map=3
---##   },
---## }

DOOM1_COMBOS =
{
  ---- TECH ------------

  TECH_TRON =
  {
    theme_probs = { TECH=20 },
    mat_pri = 12,

    wall  = "COMPOHSO",
    floor = "CEIL3_2",
    ceil  = "CEIL5_2",

    lift = "PLAT1",
    step = "STEP1",
    step_floor = "STEP1",
  },

  ---- CAVE ---------------

  CAVE_ASH =
  {
    theme_probs = { CAVE=30 },
    mat_pri = 2,

    wall  = "ASHWALL",
    floor = "FLAT5_8", -- FLOOR6_2
    ceil  = "FLAT5_8",

    arch  = "arch_russian_WOOD",

    sc_fabs = { stalagmite_MED=40, other=10 },
  },

}

DOOM1_EXITS =
{
}

DOOM1_HALLWAYS =
{
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

DOOM1_RAILS =
{
  r_1 = { wall="BRNSMALC", w=128, h=64  },
  r_2 = { wall="MIDGRATE", w=128, h=128 },
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

DOOM1_ROOMS =
{
  PLANT =
  {
    wall_fabs =
    {
      wall_pic_COMP2 = 30, 
      other = 100
    },
  },

  COMPUTER =
  {
    wall_fabs =
    {
      wall_pic_COMP2 = 30, 
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

      hang_arm_pair  = 40, hang_leg_pair  = 40,
      hang_leg_gone  = 40, hang_leg       = 40,
      hang_twitching = 40,

      other = 50
    },

    sc_fabs =
    {
      pillar_SPDUDE5=30, other=50
    },

    wall_fabs =
    {
      wall_pic_SPDUDE1 = 20, wall_pic_SPDUDE2 = 20,

      other = 50
    },
  },

  PRISON =
  {
  },
}

------------------------------------------------------------

DOOM1_EPISODE_THEMES =
{
  { URBAN=5, INDUSTRIAL=5, TECH=9, CAVE=2, HELL=2 },
  { URBAN=9, INDUSTRIAL=5, TECH=4, CAVE=2, HELL=4 },
  { URBAN=1, INDUSTRIAL=1, TECH=1, CAVE=5, HELL=9 },
  { URBAN=4, INDUSTRIAL=2, TECH=2, CAVE=4, HELL=7 },

  -- this entry used for a single episode or level
  { URBAN=5, INDUSTRIAL=4, TECH=6, CAVE=4, HELL=6 },
}

DOOM1_SECRET_EXITS =
{
  E1M3 = true,
  E2M5 = true,
  E3M6 = true,
  E4M2 = true,
}

DOOM1_EPISODE_BOSSES =
{
  "baron", -- the Bruiser Brothers
  "Cyberdemon",
  "Mastermind",
  "Mastermind",
}

DOOM1_SKY_INFO =
{
  { color="white",  light=192 },
  { color="red",    light=176 },
  { color="red",    light=192 },
  { color="orange", light=192 },
}

function Doom1_get_levels()
  local list = {}

  local EP_NUM  = sel(OB_CONFIG.length == "full", 4, 1)
  local MAP_NUM = sel(OB_CONFIG.length == "single", 1, 9)

  if OB_CONFIG.length == "few" then MAP_NUM = 4 end

  for episode = 1,EP_NUM do

    local theme_probs = DOOM1_EPISODE_THEMES[episode]
    if OB_CONFIG.length ~= "full" then
      theme_probs = DOOM1_EPISODE_THEMES[5]
    end

    for map = 1,MAP_NUM do
      local LEV =
      {
        name  = string.format("E%dM%d", episode, map),
        patch = string.format("WILV%d%d", episode-1, map-1),

        ep_along = map / MAP_NUM,

        theme = "TECH",

        key_list = { "kc_red", "kc_blue", "kc_yellow" },
        switch_list = { "sw_blue", "sw_vine", "sw_hot", "sw_skin" },
        bar_list = { "bar_wood", "bar_silver", "bar_metal" },

        sky_info = DOOM1_SKY_INFO[episode],

        boss_kind   = (map == 8) and DOOM1_EPISODE_BOSSES[episode],
        secret_kind = (map == 9) and "plain",

        toughness_factor = sel(map==9, 1.2, 1 + (map-1) / 5),
      }

      if LEV.ep_along > 0.44 and rand_odds(sel(MAP_NUM > 7, 50, 90)) then
        LEV.allow_bfg = true
      end

      if DOOM1_SECRET_EXITS[LEV.name] then
        LEV.secret_exit = true
        LEV.ep_along = 0.5
        LEV.allow_bfg = true
      end

      table.insert(list, LEV)
    end -- for map

  end -- for episode

  return list
end


COMMON_LEVEL_GFX_COLORS =
{
  gold   = { 0,47,44, 167,166,165,164,163,162,161,160, 225 },
  silver = { 0,246,243,240, 205,202,200,198, 196,195,194,193,192, 4 },
  bronze = { 0,2, 191,188, 235,232, 221,218,215,213,211,209 },
  iron   = { 0,7,5, 111,109,107,104,101,98,94,90,86,81 },
}

function Doom_make_cool_gfx()
  local GREEN =
  {
    0, 7, 127, 126, 125, 124, 123,
    122, 120, 118, 116, 113
  }

  local BRONZE_2 =
  {
    0, 2, 191, 189, 187, 235, 233,
    223, 221, 219, 216, 213, 210
  }

  local RED =
  {
    0, 2, 188,185,184,183,182,181,
    180,179,178,177,176,175,174,173
  }


  local colmaps =
  {
    BRONZE_2, GREEN, RED,

    COMMON_LEVEL_GFX_COLORS.gold,
    COMMON_LEVEL_GFX_COLORS.silver,
    COMMON_LEVEL_GFX_COLORS.iron,
  }

  rand_shuffle(colmaps)

  gui.set_colormap(1, colmaps[1])
  gui.set_colormap(2, colmaps[2])
  gui.set_colormap(3, colmaps[3])
  gui.set_colormap(4, COMMON_LEVEL_GFX_COLORS.iron)
  gui.set_colormap(5, { 0,0 })

  -- patches (CEMENT1 .. CEMENT4)
  gui.wad_logo_gfx("WALL52_1", "p", "PILL",   128,128, 1)
  gui.wad_logo_gfx("WALL53_1", "p", "BOLT",   128,128, 2)
  gui.wad_logo_gfx("WALL55_1", "p", "RELIEF", 128,128, 3)
  gui.wad_logo_gfx("WALL54_1", "p", "CARVE",  128,128, 4)

  -- flats
  gui.wad_logo_gfx("O_BOLT",   "f", "BOLT",   64,64, 2)
  gui.wad_logo_gfx("O_RELIEF", "f", "RELIEF", 64,64, 3)
  gui.wad_logo_gfx("O_CARVE",  "f", "CARVE",  64,64, 4)

  -- blackness (BLAKWAL1)
  gui.wad_logo_gfx("RW34_1",   "p", "BOLT", 64,128, 5)
  gui.wad_logo_gfx("O_BLACK",  "f", "BOLT", 64,64,  5)
end

function Doom_make_level_gfx()
  assert(LEVEL.description)
  assert(LEVEL.patch)

  -- decide color set
  if not GAME.level_gfx_colors then
    local kind = rand_key_by_probs(
    {
      gold=12, silver=3, bronze=8, iron=10
    })

    GAME.level_gfx_colors = assert(COMMON_LEVEL_GFX_COLORS[kind])
  end

  gui.set_colormap(1, GAME.level_gfx_colors)

  gui.wad_name_gfx(LEVEL.patch, LEVEL.description, 1)
end

function Doom_describe_levels()
  -- FIXME handle themes properly !!!

  local desc_list = Naming_generate("TECH", #GAME.all_levels, PARAMS.max_level_desc)

  for index,LEV in ipairs(GAME.all_levels) do
    LEV.description = desc_list[index]
  end


  Doom_make_cool_gfx()
end


------------------------------------------------------------

function Doom_common_setup()

  GAME.classes = { "doomguy" }

  GAME.initial_model = COMMON_INITIAL_MODEL

--???  GAME.pickup_stats = { "health", "bullet", "shell", "rocket", "cell" }

  Game_merge_tab("things", DOOM_THINGS)

  Game_merge_tab("monsters", COMMON_MONSTERS)
  Game_merge_tab("weapons",  COMMON_WEAPONS)
  Game_merge_tab("pickups",  COMMON_PICKUPS)

  Game_merge_tab("dm", COMMON_DEATHMATCH)
  Game_merge_tab("dm_exits", COMMON_DEATHMATCH_EXITS)

  Game_merge_tab("combos", COMMON_COMBOS)
  Game_merge_tab("exits", COMMON_EXITS)
  Game_merge_tab("hallways",  COMMON_HALLWAYS)
  Game_merge_tab("materials", COMMON_MATERIALS)

  Game_merge_tab("hangs", COMMON_OVERHANGS)
  Game_merge_tab("pedestals", COMMON_PEDESTALS)
  Game_merge_tab("crates", COMMON_CRATES)

  Game_merge_tab("liquids", COMMON_LIQUIDS)
  Game_merge_tab("doors", COMMON_DOORS)
  Game_merge_tab("lifts", COMMON_LIFTS)

  Game_merge_tab("switch_infos", COMMON_SWITCH_INFOS)
  Game_merge_tab("switch_doors", COMMON_SWITCH_DOORS)
  Game_merge_tab("key_doors", COMMON_KEY_DOORS)

  Game_merge_tab("images", COMMON_IMAGES)
  Game_merge_tab("lights", COMMON_LIGHTS)
  Game_merge_tab("rooms",  COMMON_ROOMS)
  Game_merge_tab("themes", COMMON_THEMES)

  Game_merge_tab("sc_fabs",   COMMON_SCENERY_PREFABS)
  Game_merge_tab("feat_fabs", COMMON_FEATURE_PREFABS)
  Game_merge_tab("wall_fabs", COMMON_WALL_PREFABS)

  Game_merge_tab("door_fabs", COMMON_DOOR_PREFABS)
  Game_merge_tab("arch_fabs", COMMON_ARCH_PREFABS)
  Game_merge_tab("win_fabs",  COMMON_WINDOW_PREFABS)
  Game_merge_tab("misc_fabs", COMMON_MISC_PREFABS)


  GAME.toughness_factor = 1.00  -- FIXME PARAMS

  GAME.depot_info = { teleport_kind=97 }

  GAME.room_heights = { [96]=5, [128]=25, [192]=70, [256]=70, [320]=12 }
  GAME.space_range  = { 20, 90 }

  GAME.diff_probs = { [0]=20, [16]=20, [32]=80, [64]=60, [96]=20 }
  GAME.bump_probs = { [0]=40, [16]=20, [32]=20, [64]=10 }

---  GAME.door_probs   = { out_diff=77, combo_diff=33, normal=11 }
---  GAME.window_probs = { out_diff=75, combo_diff=60, normal=35 }

  GAME.hallway_probs = { 20, 30, 41, 53, 66 }
  GAME.shack_prob    = 25
end


function Doom1_setup()

  Doom_common_setup()

---  T.episodes   = 4

  GAME.quests = DOOM1_QUESTS

  Game_merge_tab("rooms",     DOOM1_ROOMS)
  Game_merge_tab("combos",    DOOM1_COMBOS)
  Game_merge_tab("exits",     DOOM1_EXITS)
  Game_merge_tab("hallways",  DOOM1_HALLWAYS)
  Game_merge_tab("crates",    DOOM1_CRATES)
  Game_merge_tab("wall_fabs", DOOM1_WALL_PREFABS)

  GAME.rails = DOOM1_RAILS

  -- remove DOOM2-only weapons and items --

  GAME.weapons["super"] = nil 

  GAME.dm.weapons["super"] = nil
end


------------------------------------------------------------

UNFINISHED["doom1"] =
{
  label = "Doom 1",

  format = "doom",

  priority = 98, -- keep at second spot

  setup_func = Doom1_setup,

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

    max_level_desc = 28,

    palette_mons = 3,
  },

  hooks =
  {
    get_levels = Doom1_get_levels,

    describe_levels = Doom_describe_levels,
    make_level_gfx  = Doom_make_level_gfx,
  },
}


OB_THEMES["dm_tech"] =
{
  ref = "TECH",
  label = "Tech",
  for_games = { doom1=1, doom2=1, freedoom=1 },
}

UNFINISHED["dm_hell"] =
{
  ref = "HELL",
  label = "Hell",
  for_games = { doom1=1, doom2=1, freedoom=1 },
}

