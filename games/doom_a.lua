----------------------------------------------------------------
-- GAME DEF : DOOM I and II
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

  -- SPECIAL STUFF --

  brain_boss    = { id=88, kind="other", r=16, h=16 },
  brain_shooter = { id=89, kind="other", r=20, h=32 },
  brain_target  = { id=87, kind="other", r=20, h=32, pass=true },
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


COMMON_MATERIALS =
{
  -- textures with best-matching flat

  BIGDOOR1 = { "BIGDOOR1", "FLAT23" },
  BIGDOOR2 = { "BIGDOOR2", "FLAT1" },
  BIGDOOR3 = { "BIGDOOR3", "FLOOR7_2" },
  BIGDOOR4 = { "BIGDOOR4", "FLOOR3_3" },
  BIGDOOR5 = { "BIGDOOR5", "FLAT5_2" },
  BIGDOOR6 = { "BIGDOOR6", "CEIL5_2" },
  BIGDOOR7 = { "BIGDOOR7", "CEIL5_2" },

  BLODRIP1 = { "BLODRIP1", "FLOOR0_1" },
  BROWN1   = { "BROWN1",   "FLOOR0_1" },
  BROWN144 = { "BROWN144", "FLOOR7_1" },
  BROWN96  = { "BROWN96",  "FLOOR7_1" },
  BROWNHUG = { "BROWNHUG", "FLOOR7_1" },
  BROWNPIP = { "BROWNPIP", "FLOOR0_1" },
  BROWNGRN = { "BROWNGRN", "FLAT1" },  -- poor match
  BROVINE2 = { "BROVINE2", "FLAT1" },  -- poor match
  BRNPOIS  = { "BRNPOIS",  "FLAT1" },  -- poor match

  COMPBLUE = { "COMPBLUE", "FLAT14" },
  COMPSPAN = { "COMPSPAN", "CEIL5_1" },
  COMPSTA1 = { "COMPSTA1", "FLAT23" },
  COMPSTA2 = { "COMPSTA2", "FLAT23" },
  COMPTALL = { "COMPTALL", "CEIL5_1" },
  COMPWERD = { "COMPWERD", "CEIL5_1" },
  CRATE1   = { "CRATE1",   "CRATOP2" },
  CRATE2   = { "CRATE2",   "CRATOP1" },
  CRATELIT = { "CRATELIT", "CRATOP1" },
  CRATINY  = { "CRATINY",  "CRATOP1" },
  CRATWIDE = { "CRATWIDE", "CRATOP1" },

  DOOR1    = { "DOOR1",    "FLAT23" },
  DOOR3    = { "DOOR3",    "FLAT23" },
  DOORBLU  = { "DOORBLU",  "FLAT23" },
  DOORRED  = { "DOORRED",  "FLAT23" },
  DOORYEL  = { "DOORYEL",  "FLAT23" },
  DOORBLU2 = { "DOORBLU2", "CRATOP2" },
  DOORRED2 = { "DOORRED2", "CRATOP2" },
  DOORYEL2 = { "DOORYEL2", "CRATOP2" },
  DOORSTOP = { "DOORSTOP", "FLAT23" },
  DOORTRAK = { "DOORTRAK", "FLAT23" },
  EXITDOOR = { "EXITDOOR", "FLAT5_5" },
  EXITSIGN = { "EXITSIGN", "CEIL5_1" },
  EXITSTON = { "EXITSTON", "MFLR8_1" },

  FIREWALL = { "FIREWALL", "LAVA1" },
  GRAY1    = { "GRAY1",    "FLAT18" },
  GRAY2    = { "GRAY2",    "FLAT18" },
  GRAY4    = { "GRAY4",    "FLAT18" },
  GRAY5    = { "GRAY5",    "FLAT18" },
  GRAY7    = { "GRAY7",    "FLAT18"   },  
  GRAYBIG  = { "GRAYBIG",  "FLAT18" },
  GRAYPOIS = { "GRAYPOIS", "FLAT18" },
  GRAYTALL = { "GRAYTALL", "FLAT18" },
  GRAYVINE = { "GRAYVINE", "FLAT18" },

  GSTFONT1 = { "GSTFONT1", "DEM1_5" },
  GSTGARG  = { "GSTGARG",  "DEM1_5" },
  GSTLION  = { "GSTLION",  "DEM1_5" },
  GSTONE1  = { "GSTONE1",  "DEM1_5" },
  GSTONE2  = { "GSTONE2",  "DEM1_5" },
  GSTSATYR = { "GSTSATYR", "DEM1_5" },
  GSTVINE1 = { "GSTVINE1", "DEM1_5" },
  GSTVINE2 = { "GSTVINE2", "DEM1_5" },

  ICKWALL1 = { "ICKWALL1", "FLAT19" },
  ICKWALL2 = { "ICKWALL2", "FLAT19" },
  ICKWALL3 = { "ICKWALL3", "FLAT19" },
  ICKWALL4 = { "ICKWALL4", "FLAT19" },
  ICKWALL5 = { "ICKWALL5", "FLAT19" },
  ICKWALL7 = { "ICKWALL7", "FLAT19" },

  LITE3    = { "LITE3",    "FLAT19" },
  LITE5    = { "LITE5",    "FLAT19" },
  LITEBLU1 = { "LITEBLU1", "FLAT23" },
  LITEBLU4 = { "LITEBLU4", "FLAT1" },

  MARBLE1  = { "MARBLE1",  "FLOOR7_2" },
  MARBLE2  = { "MARBLE2",  "FLOOR7_2" },
  MARBLE3  = { "MARBLE3",  "FLOOR7_2" },
  MARBFAC2 = { "MARBFAC2", "FLOOR7_2" },
  MARBFAC3 = { "MARBFAC3", "FLOOR7_2" },
  MARBFACE = { "MARBFACE", "FLOOR7_2" },
  MARBLOD1 = { "MARBLOD1", "FLOOR7_2" },

  METAL    = { "METAL",    "CEIL5_2"  },
  METAL1   = { "METAL1",   "FLOOR4_8" },
  NUKE24   = { "NUKE24",   "FLOOR7_1" },
  NUKEDGE1 = { "NUKEDGE1", "FLOOR7_1" },
  NUKEPOIS = { "NUKEPOIS", "FLOOR7_1" },
  PIPE1    = { "PIPE1",    "FLOOR4_5" },
  PIPE2    = { "PIPE2",    "FLOOR4_5" },
  PIPE4    = { "PIPE4",    "FLOOR4_5" },
  PIPE6    = { "PIPE6",    "FLOOR4_5" },
  PLAT1    = { "PLAT1",    "FLAT4" },
  ROCKRED1 = { "ROCKRED1", "FLOOR6_1" },  -- better in DOOM2
  REDWALL  = { "REDWALL",  "FLAT5_3" },

  SHAWN1   = { "SHAWN1",   "FLAT23" },
  SHAWN2   = { "SHAWN2",   "FLAT23" },
  SHAWN3   = { "SHAWN3",   "FLAT23" },
  SKIN2    = { "SKIN2",    "SFLR6_4" },
  SKINEDGE = { "SKINEDGE", "SFLR6_4" },
  SKINFACE = { "SKINFACE", "SFLR6_4" },
  SKINCUT  = { "SKINCUT",  "CEIL5_2" },
  SKINLOW  = { "SKINLOW",  "FLAT5_2" },
  SKINMET1 = { "SKINMET1", "CEIL5_2" },
  SKINMET2 = { "SKINMET2", "CEIL5_2" },
  SKINSCAB = { "SKINSCAB", "CEIL5_2" },
  SKINSYMB = { "SKINSYMB", "CEIL5_2" },
  SKSNAKE1 = { "SKSNAKE1", "SFLR6_1" },
  SKSNAKE2 = { "SKSNAKE2", "SFLR6_4" },
  SKSPINE1 = { "SKSPINE1", "FLAT5_6" },
  SKSPINE2 = { "SKSPINE2", "FLAT5_6" },
  SLADPOIS = { "SLADPOIS", "FLAT4" },  -- poor match
  SLADSKUL = { "SLADSKUL", "FLAT4" },  -- poor match
  SLADWALL = { "SLADWALL", "FLAT4" },  -- poor match
  SP_DUDE1 = { "SP_DUDE1", "DEM1_5" },
  SP_DUDE2 = { "SP_DUDE2", "DEM1_5" },
  SP_DUDE4 = { "SP_DUDE4", "DEM1_5" },
  SP_DUDE5 = { "SP_DUDE5", "DEM1_5" },
  SP_FACE1 = { "SP_FACE1", "CRATOP2" },
  SP_HOT1  = { "SP_HOT1",  "FLAT5_3" },
  SP_ROCK1 = { "SP_ROCK1", "MFLR8_3" },  -- poor match

  STARG1   = { "STARG1",   "FLAT1" },  -- poor match
  STARG2   = { "STARG2",   "FLAT1" },  -- poor match
  STARG3   = { "STARG3",   "FLAT1" },  -- poor match
  STARGR1  = { "STARGR1",  "FLAT3" },
  STARGR2  = { "STARGR2",  "FLAT3" },
  STARBR2  = { "STARBR2",  "FLOOR0_2" },
  STARTAN2 = { "STARTAN2", "FLOOR4_1" },
  STARTAN3 = { "STARTAN3", "FLOOR4_5" },  -- poor match

  STEP1    = { "STEP1",    "FLOOR7_1" },
  STEP2    = { "STEP2",    "FLOOR4_6" },
  STEP3    = { "STEP3",    "CEIL5_1" },
  STEP4    = { "STEP4",    "FLAT19" },
  STEP5    = { "STEP5",    "FLOOR7_1" },
  STEP6    = { "STEP6",    "FLAT5" },
  STEPLAD1 = { "STEPLAD1", "FLOOR7_1" },
  STEPTOP  = { "STEPTOP",  "FLOOR7_1" },

  STONE    = { "STONE",    "FLAT1" },
  STONE2   = { "STONE2",   "MFLR8_1" },
  STONE3   = { "STONE3",   "MFLR8_1" },
  SUPPORT2 = { "SUPPORT2", "FLAT23" },
  SUPPORT3 = { "SUPPORT3", "CEIL5_2" },

  TEKWALL1 = { "TEKWALL1",  "CEIL5_1" },  -- poor match
  TEKWALL4 = { "TEKWALL4",  "CEIL5_1" },  -- poor match
  WOOD1    = { "WOOD1",     "FLAT5_2" },
  WOOD3    = { "WOOD3",     "FLAT5_1" },
  WOOD4    = { "WOOD4",     "FLAT5_2" },
  WOOD5    = { "WOOD5",     "CEIL5_2" },
  WOODGARG = { "WOODGARG",  "FLAT5_2" },

  SW1BLUE  = { "SW1BLUE",  "FLAT14" },
  SW1BRCOM = { "SW1BRCOM", "FLOOR7_1" },
  SW1BRN2  = { "SW1BRN2",  "FLOOR0_1" },
  SW1BRNGN = { "SW1BRNGN", "FLOOR3_3" }, -- poor match
  SW1BROWN = { "SW1BROWN", "FLOOR7_1" },
  SW1COMM  = { "SW1COMM",  "FLAT23" },
  SW1COMP  = { "SW1COMP",  "CEIL5_1" },
  SW1DIRT  = { "SW1DIRT",  "FLOOR7_1" },
  SW1EXIT  = { "SW1EXIT",  "FLAT19" },
  SW1GARG  = { "SW1GARG",  "CEIL5_2" },
  SW1GRAY  = { "SW1GRAY",  "FLAT19" },
  SW1GRAY1 = { "SW1GRAY1", "FLAT19" },

  SW1GSTON = { "SW1GSTON", "FLOOR7_2" },
  SW1HOT   = { "SW1HOT",   "FLOOR1_7" },
  SW1LION  = { "SW1LION",  "CEIL5_2" },
  SW1METAL = { "SW1METAL", "FLOOR4_8" },
  SW1PIPE  = { "SW1PIPE",  "FLOOR4_5" },
  SW1SATYR = { "SW1SATYR", "CEIL5_2" },
  SW1SKIN  = { "SW1SKIN",  "CRATOP2" },
  SW1SLAD  = { "SW1SLAD",  "FLAT4" },  -- poor match
  SW1STON1 = { "SW1STON1", "MFLR8_1" },
  SW1STRTN = { "SW1STRTN", "FLOOR4_1" },
  SW1VINE  = { "SW1VINE",  "FLAT1" },
  SW1WOOD  = { "SW1WOOD",  "FLAT5_2" },
  

---??? possible special use (e.g. WATER/NUKAGE/LAVA falls)
--FIREBLU1
--FIRELAVA
--FIREMAG1


  -- flats with closest texture

  BLOOD1   = { "ROCKRED1", "BLOOD1" },  -- better in DOOM2

  CEIL1_1  = { "WOOD1",    "CEIL1_1" },
  CEIL1_3  = { "WOOD1",    "CEIL1_3" },
  CEIL1_2  = { "METAL",    "CEIL1_2" },
  CEIL3_1  = { "STARBR2",  "CEIL3_1" },
  CEIL3_2  = { "STARTAN2", "CEIL3_2" },
  CEIL3_3  = { "STARTAN2", "CEIL3_3" },
  CEIL3_4  = { "STARTAN2", "CEIL3_4" },
  CEIL3_5  = { "STONE2",   "CEIL3_5" },
  CEIL3_6  = { "STONE2",   "CEIL3_6" },
  CEIL4_1  = { "COMPBLUE", "CEIL4_1" },
  CEIL4_2  = { "COMPBLUE", "CEIL4_2" },
  CEIL4_3  = { "COMPBLUE", "CEIL4_3" },
  CEIL5_1  = { "COMPSPAN", "CEIL5_1" },
  CEIL5_2  = { "METAL",    "CEIL5_2" },
  COMP01   = { "GRAY1",    "COMP01" },
  CONS1_1  = { "COMPWERD", "CONS1_1" },  -- poor match
  CONS1_5  = { "COMPWERD", "CONS1_5" },  -- poor match
  CONS1_7  = { "COMPWERD", "CONS1_7" },  -- poor match

  DEM1_1   = { "MARBLE1",  "DEM1_1" },
  DEM1_2   = { "MARBLE1",  "DEM1_2" },
  DEM1_3   = { "MARBLE1",  "DEM1_3" },
  DEM1_4   = { "MARBLE1",  "DEM1_4" },
  DEM1_5   = { "MARBLE1",  "DEM1_5" },
  DEM1_6   = { "MARBLE1",  "DEM1_6" },

  FLAT1    = { "GRAY1",    "FLAT1" },
  FLAT1_1  = { "BROWN1",   "FLAT1_1" },  -- poor match
  FLAT1_2  = { "BROWN1",   "FLAT1_2" },  -- poor match
  FLAT1_3  = { "BROWN1",   "FLAT1_3" },  -- poor match
  FLAT2    = { "GRAY1",    "FLAT2" },
  FLAT3    = { "GRAY4",    "FLAT3" },
  FLAT4    = { "COMPSPAN", "FLAT4" },  -- poor match
  FLAT5    = { "BROWNHUG", "FLAT5" },
  FLAT5_1  = { "WOOD1",    "FLAT5_1" },
  FLAT5_2  = { "WOOD1",    "FLAT5_2" },
  FLAT5_3  = { "REDWALL",  "FLAT5_3" },
  FLAT5_4  = { "STONE",    "FLAT5_4" },
  FLAT5_5  = { "BROWN1",   "FLAT5_5" },
  FLAT5_6  = { "SP_FACE1", "FLAT5_6" },  -- better in DOOM1
  FLAT8    = { "STARBR2",  "FLAT8" },
  FLAT9    = { "GRAY4",    "FLAT9" },
  FLAT10   = { "BROWNHUG", "FLAT10" },  -- better in DOOM2
  FLAT14   = { "COMPBLUE", "FLAT14" },
  FLAT17   = { "GRAY1",    "FLAT17" },
  FLAT18   = { "GRAY1",    "FLAT18" },
  FLAT19   = { "GRAY1",    "FLAT19" },
  FLAT20   = { "SHAWN2",   "FLAT20" },
  FLAT22   = { "SHAWN2",   "FLAT22" },
  FLAT23   = { "SHAWN2",   "FLAT23" },

  FLOOR0_1 = { "STARTAN2", "FLOOR0_1" },
  FLOOR0_2 = { "STARBR2",  "FLOOR0_2" },
  FLOOR0_3 = { "GRAY1",    "FLOOR0_3" },
  FLOOR0_5 = { "GRAY1",    "FLOOR0_5" },
  FLOOR0_6 = { "GRAY1",    "FLOOR0_6" },
  FLOOR0_7 = { "GRAY1",    "FLOOR0_7" },
  FLOOR1_1 = { "COMPBLUE", "FLOOR1_1" },
  FLOOR1_6 = { "REDWALL",  "FLOOR1_6" },
  FLOOR1_7 = { "REDWALL",  "FLOOR1_7" },
  FLOOR3_3 = { "BROWN1",   "FLOOR3_3" },  -- poor match
  FLOOR4_1 = { "STARTAN2", "FLOOR4_1" },
  FLOOR4_5 = { "STARTAN2", "FLOOR4_5" },
  FLOOR4_6 = { "STARTAN2", "FLOOR4_6" },
  FLOOR4_8 = { "METAL1",   "FLOOR4_8" },
  FLOOR5_1 = { "METAL1",   "FLOOR5_1" },
  FLOOR5_2 = { "BROWNHUG", "FLOOR5_2" },
  FLOOR5_3 = { "BROWNHUG", "FLOOR5_3" },
  FLOOR5_4 = { "BROWNHUG", "FLOOR5_4" },
  FLOOR6_1 = { "REDWALL",  "FLOOR6_1" },  -- poor match
  FLOOR7_1 = { "BROWNHUG", "FLOOR7_1" },
  FLOOR7_2 = { "MARBLE1",  "FLOOR7_2" },
  FWATER1  = { "COMPBLUE", "FWATER1" },

  GATE1    = { "METAL",    "GATE1" },
  GATE2    = { "METAL",    "GATE2" },
  GATE3    = { "METAL",    "GATE3" },
  GATE4    = { "METAL",    "GATE4" },
  LAVA1    = { "ROCKRED1", "LAVA1" },
  MFLR8_1  = { "STONE2",   "MFLR8_1" },
  MFLR8_2  = { "BROWNHUG", "MFLR8_2" },
  MFLR8_3  = { "SP_ROCK1", "MFLR8_3" },  -- poor match
  NUKAGE1  = { "GSTVINE2", "NUKAGE1" },  -- better in DOOM2
  SFLR6_1  = { "SKSNAKE1", "SFLR6_1" },
  SFLR6_4  = { "SKSNAKE2", "SFLR6_4" },
  SFLR7_1  = { "SKSNAKE1", "SFLR7_1" },
  SFLR7_4  = { "SKSNAKE1", "SFLR7_4" },
  STEP_I   = { "SHAWN2",   "STEP1" },
  STEP_H   = { "SHAWN2",   "STEP2" },
  TLITE6_1 = { "METAL",    "TLITE6_1" },
  TLITE6_4 = { "METAL",    "TLITE6_4" },
  TLITE6_5 = { "METAL",    "TLITE6_5" },
  TLITE6_6 = { "METAL",    "TLITE6_6" },


  -- Oblige stuff
  O_PILL   = { "CEMENT1",  "O_PILL" },
  O_BOLT   = { "CEMENT2",  "O_BOLT" },
  O_RELIEF = { "CEMENT3",  "O_RELIEF" },
  O_CARVE  = { "CEMENT4",  "O_CARVE" },


  -- Missing stuff:
  --   F_SKY    : handled using PARAM.sky_flat
  --   CEMENT#  : used by OBLIGE for various logos
  --   SKY1/2/3 : not very useful
  --   ZZZFACE# : not generally useful (OK to hard-code)
  --
  -- Mid-masked (railing) textures are in separate tables.
  --
  -- Note too that STEP1/2 are ambiguous, the flats are quite
  -- different to the textures, hence renamed flats: STEP_I/H.
}



DOOM1_MATERIALS =
{
  -- textures with best-matching flat

  ASHWALL  = { "ASHWALL",  "FLOOR6_2" },
  BLODGR1  = { "BLODGR1",  "FLOOR0_1" },
  BROVINE  = { "BROVINE",  "FLOOR0_1" },
  BRNPOIS2 = { "BRNPOIS2", "FLOOR7_1" },
  BROWNWEL = { "BROWNWEL", "FLOOR7_1" },

  COMP2    = { "COMP2",    "CEIL5_1" },
  COMPOHSO = { "COMPOHSO", "FLOOR7_1" },
  COMPTILE = { "COMPTILE", "CEIL5_1" },
  COMPUTE1 = { "COMPUTE1", "FLAT19" },
  COMPUTE2 = { "COMPUTE2", "CEIL5_1" },
  COMPUTE3 = { "COMPUTE3", "CEIL5_1" },
  DOORHI   = { "DOORHI",   "FLAT19" },
  GRAYDANG = { "GRAYDANG", "FLAT19" },
  ICKDOOR1 = { "ICKDOOR1", "FLAT19" },
  ICKWALL6 = { "ICKWALL6", "FLAT18" },

  LITE2    = { "LITE2",    "FLOOR0_1" },
  LITE4    = { "LITE4",    "FLAT19" },
  LITE96   = { "LITE96",   "FLOOR7_1" },
  LITEBLU2 = { "LITEBLU2", "FLAT23" },
  LITEBLU3 = { "LITEBLU3", "FLAT23" },
  LITEMET  = { "LITEMET",  "FLOOR4_8" },
  LITERED  = { "LITERED",  "FLOOR1_6" },
  LITESTON = { "LITESTON", "MFLR8_1" },

  NUKESLAD = { "NUKESLAD", "FLAT4" },  -- poor match
  PLANET1  = { "PLANET1",  "FLAT23" },
  REDWALL1 = { "REDWALL1", "FLOOR1_6" },
  ROCKRED1 = { "ROCKRED1", "RROCK01" },
  SKINBORD = { "SKINBORD", "FLAT5_5" },
  SKINTEK1 = { "SKINTEK1", "FLAT5_5" },  -- poor match
  SKINTEK2 = { "SKINTEK2", "FLAT5_5" },  -- poor match
  SKULWAL3 = { "SKULWAL3", "FLAT5_6" },
  SKULWALL = { "SKULWALL", "FLAT5_6" },
  SLADRIP1 = { "SLADRIP1", "FLAT4" },  -- poor match
  SP_DUDE3 = { "SP_DUDE3", "DEM1_5" },
  SP_DUDE6 = { "SP_DUDE6", "DEM1_5" },
  SP_ROCK1 = { "SP_ROCK1", "MFLR8_3" },  -- poor match
  STARTAN1 = { "STARTAN1", "FLOOR4_1" },
  STONGARG = { "STONGARG", "MFLR8_1" },
  STONPOIS = { "STONPOIS", "FLAT5_4" },
  TEKWALL2 = { "TEKWALL2", "CEIL5_1" },  -- poor match
  TEKWALL3 = { "TEKWALL3", "CEIL5_1" },  -- poor match
  TEKWALL5 = { "TEKWALL5", "CEIL5_1" },  -- poor match
  WOODSKUL = { "WOODSKUL", "FLAT5_2" },


  -- flats with closest texture

  FLAT5_6  = { "SKULWALL", "FLAT5_6" },
  FLAT5_7  = { "ASHWALL",  "FLAT5_7" },
  FLAT5_8  = { "ASHWALL",  "FLAT5_8" },
  FLOOR6_2 = { "ASHWALL",  "FLOOR6_2" },
  MFLR8_4  = { "ASHWALL",  "MFLR8_4" },
}



DOOM2_MATERIALS =
{
  -- textures with best-matching flat

  ASHWALL  = { "ASHWALL2", "MFLR8_4" },  -- compatibility name
  ASHWALL3 = { "ASHWALL3", "FLAT10" },
  ASHWALL4 = { "ASHWALL4", "FLAT10" },
  ASHWALL6 = { "ASHWALL6", "RROCK20" },
  ASHWALL7 = { "ASHWALL7", "RROCK18" },
  BFALL1   = { "BFALL1",   "BLOOD1" },
  BIGBRIK1 = { "BIGBRIK1", "RROCK14" },
  BIGBRIK3 = { "BIGBRIK3", "RROCK14" },
  BIGBRIK2 = { "BIGBRIK2", "MFLR8_1" },
  BLAKWAL1 = { "BLAKWAL1", "CEIL5_1" },
  BLAKWAL2 = { "BLAKWAL2", "CEIL5_1" },

  BRICK1   = { "BRICK1",   "RROCK10" },
  BRICK2   = { "BRICK2",   "RROCK10" },
  BRICK3   = { "BRICK3",   "FLAT5_5" },
  BRICK4   = { "BRICK4",   "FLAT5_5" },
  BRICK5   = { "BRICK5",   "RROCK10" },
  BRICK6   = { "BRICK6",   "FLOOR5_4" },
  BRICK7   = { "BRICK7",   "FLOOR5_4" },
  BRICK8   = { "BRICK8",   "FLOOR5_4" },
  BRICK9   = { "BRICK9",   "FLOOR5_4" },
  BRICK10  = { "BRICK10",  "SLIME13" },
  BRICK11  = { "BRICK11",  "FLAT5_3" },
  BRICK12  = { "BRICK12",  "FLAT5_5" },  -- poor match
  BRONZE1  = { "BRONZE1",  "FLOOR7_1" },
  BRONZE2  = { "BRONZE2",  "FLOOR7_1" },
  BRONZE3  = { "BRONZE3",  "FLOOR7_1" },
  BRONZE4  = { "BRONZE4",  "FLOOR7_1" },
  BRICKLIT = { "BRICKLIT", "RROCK10" },
  BRWINDOW = { "BRWINDOW", "RROCK10" },
  BSTONE1  = { "BSTONE1",  "RROCK11" },
  BSTONE2  = { "BSTONE2",  "RROCK12" },
  BSTONE3  = { "BSTONE3",  "RROCK12" },

  CRACKLE2 = { "CRACKLE2", "RROCK01" },
  CRACKLE4 = { "CRACKLE4", "RROCK02" },
  CRATE3   = { "CRATE3",   "CRATOP1" },
  DBRAIN1  = { "DBRAIN1",  "LAVA1" },
  MARBFAC4 = { "MARBFAC4", "DEM1_5" },
  MARBGRAY = { "MARBGRAY", "DEM1_5" },
  METAL2   = { "METAL2",   "CEIL5_2" },
  METAL3   = { "METAL3",   "CEIL5_2" },
  METAL4   = { "METAL4",   "CEIL5_2" },
  METAL5   = { "METAL5",   "CEIL5_2" },
  METAL6   = { "METAL6",   "CEIL5_2" },
  METAL7   = { "METAL7",   "CEIL5_2" },

  MODWALL1 = { "MODWALL1", "MFLR8_4" },
  MODWALL2 = { "MODWALL2", "MFLR8_4" },
  MODWALL3 = { "MODWALL3", "FLAT19" },
  MODWALL4 = { "MODWALL4", "FLAT18" },

  PANBLACK = { "PANBLACK", "RROCK09" },
  PANBLUE  = { "PANBLUE",  "RROCK09" },
  PANBOOK  = { "PANBOOK",  "RROCK09" },
  PANRED   = { "PANRED",   "RROCK09" },
  PANBORD1 = { "PANBORD1", "RROCK09" },
  PANBORD2 = { "PANBORD2", "RROCK09" },
  PANCASE1 = { "PANCASE1", "RROCK09" },
  PANCASE2 = { "PANCASE2", "RROCK09" },
  PANEL1   = { "PANEL1",   "RROCK09" },
  PANEL2   = { "PANEL2",   "RROCK09" },
  PANEL3   = { "PANEL3",   "RROCK09" },
  PANEL4   = { "PANEL4",   "RROCK09" },
  PANEL5   = { "PANEL5",   "RROCK09" },
  PANEL6   = { "PANEL6",   "RROCK09" },
  PANEL7   = { "PANEL7",   "RROCK09" },
  PANEL8   = { "PANEL8",   "RROCK09" },
  PANEL9   = { "PANEL9",   "RROCK09" },
  PIPES    = { "PIPES",    "FLOOR3_3" },
  PIPEWAL1 = { "PIPEWAL1", "RROCK03" },  -- poor match
  PIPEWAL2 = { "PIPEWAL2", "RROCK03" },  -- poor match
  ROCK1    = { "ROCK1",    "RROCK13" },
  ROCK2    = { "ROCK2",    "GRNROCK" },
  ROCK3    = { "ROCK3",    "RROCK13" },
  ROCK4    = { "ROCK4",    "RROCK11" },
  ROCK5    = { "ROCK5",    "RROCK11" },

  SFALL1   = { "SFALL1",   "NUKAGE1" },
  SILVER1  = { "SILVER1",  "FLAT23" },
  SILVER2  = { "SILVER2",  "FLAT22" },
  SILVER3  = { "SILVER3",  "FLAT23" },
  SK_LEFT  = { "SK_LEFT",  "FLAT5_6" },  -- poor match
  SK_RIGHT = { "SK_RIGHT", "FLAT5_6" },  -- poor match
  SLOPPY1  = { "SLOPPY1",  "FLAT5_6" },  -- poor match
  SLOPPY2  = { "SLOPPY2",  "FLAT5_6" },  -- poor match
  SP_DUDE7 = { "SP_DUDE7", "FLOOR5_4" },
  SP_DUDE8 = { "SP_DUDE8", "FLOOR5_4" },
  SP_FACE2 = { "SP_FACE2", "FLAT5_6" },

  SPACEW2  = { "SPACEW2",  "CEIL3_3" },
  SPACEW3  = { "SPACEW3",  "CEIL5_1" },
  SPACEW4  = { "SPACEW4",  "SLIME16" },
  SPCDOOR1 = { "SPCDOOR1", "FLOOR0_1" },
  SPCDOOR2 = { "SPCDOOR2", "FLAT19" },
  SPCDOOR3 = { "SPCDOOR3", "FLAT19" },
  SPCDOOR4 = { "SPCDOOR4", "FLOOR0_1" },
  STONE4   = { "STONE4",   "FLAT5_4" },
  STONE5   = { "STONE5",   "FLAT5_4" },
  STONE6   = { "STONE6",   "RROCK11" },
  STONE7   = { "STONE7",   "RROCK11" },
  STUCCO   = { "STUCCO",   "FLAT5_5" },
  STUCCO1  = { "STUCCO1",  "FLAT5_5" },
  STUCCO2  = { "STUCCO2",  "FLAT5_5" },
  STUCCO3  = { "STUCCO3",  "FLAT5_5" },

  TANROCK2 = { "TANROCK2", "FLOOR3_3" },
  TANROCK3 = { "TANROCK3", "RROCK11" },
  TANROCK4 = { "TANROCK4", "RROCK09" },
  TANROCK5 = { "TANROCK5", "RROCK18" },
  TANROCK7 = { "TANROCK7", "RROCK15" },
  TANROCK8 = { "TANROCK8", "RROCK09" },
  TEKBRON1 = { "TEKBRON1", "FLOOR0_1" },
  TEKBRON2 = { "TEKBRON2", "FLOOR0_1" },
  TEKLITE  = { "TEKLITE",  "FLOOR5_2" },
  TEKLITE2 = { "TEKLITE2", "FLOOR5_2" },
  TEKWALL6 = { "TEKWALL6", "CEIL5_1" },  -- poor match

  TEKGREN1 = { "TEKGREN1", "RROCK20" },  -- poor match
  TEKGREN2 = { "TEKGREN2", "RROCK20" },  -- poor match
  TEKGREN3 = { "TEKGREN3", "RROCK20" },  -- poor match
  TEKGREN4 = { "TEKGREN4", "RROCK20" },  -- poor match
  TEKGREN5 = { "TEKGREN5", "RROCK20" },  -- poor match

  WOOD6    = { "WOOD6",    "FLAT5_2" },
  WOOD7    = { "WOOD7",    "FLAT5_2" },
  WOOD8    = { "WOOD8",    "FLAT5_2" },
  WOOD9    = { "WOOD9",    "FLAT5_2" },
  WOOD10   = { "WOOD10",   "FLAT5_1" },
  WOOD12   = { "WOOD12",   "FLAT5_2" },
  WOODVERT = { "WOODVERT", "FLAT5_2" },
  WOODMET1 = { "WOODMET1", "CEIL5_2" },
  WOODMET2 = { "WOODMET2", "CEIL5_2" },
  WOODMET3 = { "WOODMET3", "CEIL5_2" },
  WOODMET4 = { "WOODMET4", "CEIL5_2" },

  ZIMMER1  = { "ZIMMER1",  "RROCK20" },
  ZIMMER2  = { "ZIMMER2",  "RROCK20" },
  ZIMMER3  = { "ZIMMER3",  "RROCK18" },
  ZIMMER4  = { "ZIMMER4",  "RROCK18" },
  ZIMMER5  = { "ZIMMER5",  "RROCK16" },
  ZIMMER7  = { "ZIMMER7",  "RROCK20" },
  ZIMMER8  = { "ZIMMER8",  "MFLR8_3" },
                          
  ZDOORB1  = { "ZDOORB1",  "FLAT23" },
  ZDOORF1  = { "ZDOORF1",  "FLAT23" },
  ZELDOOR  = { "ZELDOOR",  "FLAT23" },
  ZZWOLF1  = { "ZZWOLF1",  "FLAT18" },
  ZZWOLF2  = { "ZZWOLF2",  "FLAT18" },
  ZZWOLF3  = { "ZZWOLF3",  "FLAT18" },
  ZZWOLF4  = { "ZZWOLF4",  "FLAT18" },
  ZZWOLF5  = { "ZZWOLF5",  "FLAT5_1" },
  ZZWOLF6  = { "ZZWOLF6",  "FLAT5_1" },
  ZZWOLF7  = { "ZZWOLF7",  "FLAT5_1" },
  ZZWOLF9  = { "ZZWOLF9",  "FLAT14" },
  ZZWOLF10 = { "ZZWOLF10", "FLAT23" },
  ZZWOLF11 = { "ZZWOLF11", "FLAT5_3" },
  ZZWOLF12 = { "ZZWOLF12", "FLAT5_3" },
  ZZWOLF13 = { "ZZWOLF13", "FLAT5_3" },

  SW1BRIK  = { "SW1BRIK",  "MFLR8_1" },
  SW1MARB  = { "SW1MARB",  "DEM1_5" },
  SW1MET2  = { "SW1MET2",  "CEIL5_2" },
  SW1MOD1  = { "SW1MOD1",  "MFLR8_4" },
  SW1PANEL = { "SW1PANEL", "CEIL1_1" },
  SW1ROCK  = { "SW1ROCK",  "RROCK13" },
  SW1SKULL = { "SW1SKULL", "FLAT5_6" },
  SW1STON6 = { "SW1STON6", "RROCK11" },
  SW1TEK   = { "SW1TEK",   "RROCK20" },
  SW1WDMET = { "SW1WDMET", "CEIL5_2" },
  SW1ZIM   = { "SW1ZIM",   "RROCK20" },


  -- flats with closest texture

  BLOOD1   = { "BFALL1",   "BLOOD1" },
  CONS1_1  = { "COMPUTE1", "CONS1_1" },
  CONS1_5  = { "COMPUTE1", "CONS1_5" },
  CONS1_7  = { "COMPUTE1", "CONS1_7" },

  FLAT1_1  = { "BSTONE2",  "FLAT1_1" },
  FLAT1_2  = { "BSTONE2",  "FLAT1_2" },
  FLAT1_3  = { "BSTONE2",  "FLAT1_3" },
  FLAT10   = { "ASHWALL4", "FLAT10" },
  FLAT22   = { "SILVER2",  "FLAT22" },
  FLAT5_5  = { "STUCCO",   "FLAT5_5"  },
  FLAT5_7  = { "ASHWALL2", "FLAT5_7" },
  FLAT5_8  = { "ASHWALL2", "FLAT5_8" },
  FLOOR6_2 = { "ASHWALL2", "FLOOR6_2" },
  GRASS2   = { "ZIMMER2",  "GRASS2"   },
  GRNROCK  = { "ROCK2",    "GRNROCK" },
  GRNLITE1 = { "TEKGREN2", "GRNLITE1" },
  MFLR8_4  = { "ASHWALL2", "MFLR8_4" },
  NUKAGE1  = { "SFALL1",   "NUKAGE1" },

  RROCK01  = { "CRACKLE2", "RROCK01" },
  RROCK02  = { "CRACKLE4", "RROCK02" },
  RROCK03  = { "ASHWALL3", "RROCK03" },  -- poor match
  RROCK04  = { "ASHWALL3", "RROCK04" },
  RROCK05  = { "ROCKRED1", "RROCK05" },  -- poor match
  RROCK09  = { "TANROCK4", "RROCK09" },
  RROCK10  = { "BRICK1",   "RROCK10" },
  RROCK11  = { "BSTONE1",  "RROCK11" },
  RROCK12  = { "BSTONE2",  "RROCK12" },
  RROCK13  = { "ROCK3",    "RROCK13" },
  RROCK14  = { "BIGBRIK1", "RROCK14" },
  RROCK15  = { "TANROCK7", "RROCK15" },
  RROCK16  = { "ZIMMER5",  "RROCK16" },
  RROCK17  = { "ZIMMER3",  "RROCK17" },
  RROCK18  = { "ZIMMER3",  "RROCK18" },
  RROCK19  = { "ZIMMER2",  "RROCK19" },
  RROCK20  = { "ZIMMER7",  "RROCK20" },

  SLIME01  = { "ZIMMER3",  "SLIME01" },  -- poor match
  SLIME05  = { "ZIMMER3",  "SLIME05" },  -- poor match
  SLIME09  = { "ROCKRED1", "SLIME09" },  -- poor match
  SLIME13  = { "BRICK10",  "SLIME13" },
  SLIME14  = { "METAL2",   "SLIME14" },  -- poor match
  SLIME15  = { "COMPSPAN", "SLIME15" },  -- poor match
  SLIME16  = { "SPACEW4",  "SLIME16" },
}


COMMON_RAILS =
{
--BRNSMAL1
--BRNSMAL2
--BRNSMALC
--BRNSMALL
--BRNSMALR
--MIDBRN1
--MIDGRATE
}

DOOM1_RAILS =
{
--BRNBIGC
--BRNBIGL
--BRNBIGR
--MIDVINE1
--MIDVINE2
}

DOOM2_RAILS =
{
--MIDBARS1
--MIDBARS3
--MIDBRONZ
--MIDSPACE
}

--[[ FIXME
DOOM1_RAILS =
{
  r_1 = { wall="BRNSMALC", w=128, h=64  },
  r_2 = { wall="MIDGRATE", w=128, h=128 },
}

DOOM2_RAILS =
{
  r_1 = { wall="MIDBARS3", w=128, h=72  },
  r_2 = { wall="MIDGRATE", w=128, h=128 },
}
--]]


DOOM_SANITY_MAP =
{
  -- liquids kill the player, so keep them recognisable
  LAVA1   = "FWATER1",
  FWATER1 = "NUKAGE1",
  NUKAGE1 = "LAVA1",
  SFALL1  = "BFALL1",
  BFALL1  = "SFALL1",
  WFALL1  = "LFALL1",
  LFALL1  = "WFALL1",
  SLIME01 = "SLIME09",
  SLIME05 = "SLIME09",
  SLIME09 = "SLIME01",

  -- keep keyed doors recognisable
  DOORBLU  = "DOORBLU2",
  DOORBLU2 = "DOORBLU",
  DOORRED  = "DOORRED2",
  DOORRED2 = "DOORRED",
  DOORYEL  = "DOORYEL2",
  DOORYEL2 = "DOORYEL",
  EXITSIGN = "EXITSIGN",

  -- these textures may not tile well vertically
  STEP1 = "STEP4", STEP2 = "STEP5", STEP3 = "STEP6",
  STEP4 = "STEP3", STEP5 = "STEP2", STEP6 = "STEP1",

  STEPLAD1 = "STEPLAD1",
  STEPTOP  = "STEPTOP",
}


COMMON_LIFTS =
{
  slow = { kind=62,  walk=88  },
  fast = { kind=123, walk=120 },
}

---- ARCH STUFF ------------

COMMON_LIQUIDS =
{
  water = { floor="FWATER1", wall="FIREMAG1" },
  blood = { floor="BLOOD1",  wall="BFALL1",   sec_kind=7 }, --  5% damage
  nukage= { floor="NUKAGE1", wall="SFALL1",   sec_kind=5 }, -- 10% damage
  lava  = { floor="LAVA1",   wall="ROCKRED1", sec_kind=16, add_light=64 }, -- 20% damage
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
      TECH_BASE=25,
      TECH_GREEN=20,
      TECH_BROWN=18,
      TECH_SLAD=18,

      TECH_METAL=13,
      TECH_SILVER=10,
      TECH_GRAY=10,
      TECH_LITEBROWN=5,
      TECH_BROWNER=5,

      TECH_DARKGREEN=10,
      TECH_DARKBROWN=8,
      TECH_METAL1=1,
    },

    floors =
    {
      FLOOR0_1=50,
      FLOOR0_3=50,
      FLOOR0_7=50,
      FLOOR3_3=50,
      
      FLOOR4_5=50,
      FLOOR4_6=50,
      FLOOR4_8=50,
      FLOOR5_2=50,
      
      CEIL3_2=50,
      FLAT9=50,
      FLAT14=50,
    },

    ceilings =
    {
      CEIL5_1=50,
      CEIL5_2=50,
      CEIL3_3=50,
      CEIL3_5=50,
      
      FLAT1=50,
      FLAT4=50,
      FLAT18=50,
      FLOOR0_2=50,
      FLOOR4_1=50,
      FLOOR5_1=50,
      
      GRNLITE1=1,
      TLITE6_5=1,
    },

    corners =
    {
      TEKWALL6=60, STARGR1=40,
      METAL7=40,   METAL1=20,
      TEKWALL4=5,  COMPTALL=2,
      TEKBRON1=2,  COMPBLUE=1,
    },

    ceil_lights =
    {
      TLITE6_5=50, TLITE6_6=30,
      TLITE6_1=30, FLOOR1_7=30,
      FLAT2=20,    CEIL3_4=10,
      FLAT22=10,   GRNLITE1=10,
    },

    ground =
    {
      TECH_GROUND=30,
      URBAN_STONE=20,
      URBAN_BROWN=20,

      CAVE_ASH=5,
    },

    hallway =
    {
      walls =
      {
        BROWN1=33, BROWNGRN=50, GRAY1=50, STARBR2=33
      },

      floors =
      {
        FLAT4=50, CEIL5_1=50, FLOOR1_1=50, FLOOR3_3=50
      },

      ceils =
      {
        FLAT4=50, CEIL5_1=50, CEIL3_5=50, CEIL3_3=50
      },
    },

    exit =
    {
      walls =
      {
        METAL2=50,   STARTAN2=50, STARG1=50,
        TEKWALL4=50, PIPEWAL2=50,
        TEKGREN1=50, SPACEW2=50,  STARBR2=50
      },

      floors =
      {
        FLOOR0_3=50, FLOOR5_2=50
      },

      ceils =
      {
        TLITE6_6=50, TLITE6_5=50, FLAT17=50,
        FLOOR1_7=50, GRNLITE1=50, CEIL4_3=50
      },
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

DOOM2_THEMES =
{
  TECH =
  {
    building =
    {
      TECH_TEKGREN=10,
    },

    ground =
    {
      NAT_TANROCK5=10,
      NAT_MUDDY=5,
      NAT_SWAMP=5,
      URBAN_GREENBRK=5,
    },

    floors =
    {
      SLIME15=50,
      SLIME16=50,
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
-- but actually a Lost Soul.  It spawns at least three (when
-- killed), hence the health is set to 700 instead of 400.
-- Damage value is a rough guess / completely bogus.
--
-- Spider Mastermind damage has been lowered (from 200),
-- since it was creating way too much health in levels.
--

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
    density=0.7, float=true,
  },

  demon =
  {
    prob=35, guard_prob=31, trap_prob=61,
    health=150, damage=25, attack="melee",
  },

  spectre =
  {
    prob=4, guard_prob=11, trap_prob=61, crazy_prob=20,
    health=150, damage=25, attack="melee",
    invis=true,
  },

  caco =
  {
    prob=40, guard_prob=61, trap_prob=21, cage_prob=21,
    health=400, damage=35, attack="missile",
    density=0.6, float=true,
  },

  baron =
  {
    prob=20, guard_prob=11, trap_prob=11, cage_prob=3,
    health=1000, damage=45, attack="missile",
    density=0.3,
  },


  ---| DOOM BOSSES |---

  Cyberdemon =
  {
    crazy_prob=12,
    health=4000, damage=150, attack="missile",
    density=0.1,
  },

  Mastermind =
  {
    crazy_prob=18,
    health=3000, damage=100, attack="hitscan",
    density=0.2,
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
    prob=44, guard_prob=41, trap_prob=41, cage_prob=51,
    health=300, damage=70, attack="missile",
    density=0.6,
  },

  knight =
  {
    prob=60, guard_prob=41, trap_prob=41, cage_prob=11, crazy_prob=40,
    health=500, damage=45, attack="missile",
    density=0.4,
  },

  mancubus =
  {
    prob=33, guard_prob=41, trap_prob=41, cage_prob=11,
    health=600, damage=70, attack="missile",
    density=0.4,
  },

  arach =
  {
    prob=25, guard_prob=21, trap_prob=21, cage_prob=11,
    health=500, damage=70, attack="missile",
    density=0.5,
  },

  vile =
  {
    prob=12, guard_prob=11, trap_prob=31, cage_prob=21,
    health=700, damage=40, attack="hitscan",  ---??? no_dist=true,
    density=0.2, never_promote=true,
  },

  pain =
  {
    prob=6, trap_prob=11, crazy_prob=15,
    health=700, damage=20, attack="missile",
    density=0.2,never_promote=true, float=true, 
  },

  ss_dude =
  {
    -- not generated in normal levels
    crazy_prob=7,
    health=50, damage=15, attack="hitscan",
    give={ {ammo="bullet",count=5} },
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
    pref=3, add_prob=2,  start_prob=1,
    rate=8.7, damage=10, attack="melee",
  },

  berserk =
  {
    pref=10, add_prob=6, start_prob=10,
    rate=1.5, damage=90, attack="melee",
    give={ {health=70} },
  },

  pistol =
  {
    pref=5,
    rate=1.8, damage=10, attack="hitscan",
    ammo="bullet", per=1,
  },

  chain =
  {
    pref=70, add_prob=35, start_prob=40,
    rate=8.5, damage=10, attack="hitscan",
    ammo="bullet", per=1,
    give={ {ammo="bullet",count=20} },
  },

  shotty =
  {
    pref=70, add_prob=10, start_prob=60,
    rate=0.9, damage=70, attack="hitscan", splash={ 0,10 },
    ammo="shell", per=1,
    give={ {ammo="shell",count=8} },
  },

  super =
  {
    pref=70, add_prob=20, start_prob=10,
    rate=0.6, damage=170, attack="hitscan", splash={ 0,30 },
    ammo="shell", per=2,
    give={ {ammo="shell",count=8} },
  },

  launch =
  {
    pref=50, add_prob=25, start_prob=10,
    rate=1.7, damage=80, attack="missile", splash={ 50,20,5 },
    ammo="rocket", per=1,
    give={ {ammo="rocket",count=2} },
  },

  plasma =
  {
    pref=90, add_prob=13, start_prob=5,
    rate=11, damage=20, attack="missile",
    ammo="cell", per=1,
    give={ {ammo="cell",count=40} },
  },

  bfg =
  {
    pref=30, add_prob=25, start_prob=0.1,
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
    prob=20, cluster={ 4,7 },
    give={ {health=1} },
  },

  stimpack =
  {
    prob=60, cluster={ 2,5 },
    give={ {health=10} },
  },

  medikit =
  {
    prob=100, cluster={ 1,3 },
    give={ {health=25} },
  },

  soul =
  {
    prob=3, big_item=true,
    give={ {health=150} },
  },

  mega =
  {
    prob=1, big_item=true,
    give={ {health=200} },
  },

  -- ARMOR --

  helmet =
  {
    prob=10, armor=true, cluster={ 4,7 },
    give={ {health=1} },
  },

  green_armor =
  {
    prob=5, armor=true, big_item=true,
    give={ {health=30} },
  },

  blue_armor =
  {
    prob=2, armor=true, big_item=true,
    give={ {health=90} },
  },

  -- AMMO --

  bullets =
  {
    prob=10, cluster={ 2,5 },
    give={ {ammo="bullet",count=10} },
  },

  bullet_box =
  {
    prob=40, cluster={ 1,3 },
    give={ {ammo="bullet", count=50} },
  },

  shells =
  {
    prob=20, cluster={ 2,5 },
    give={ {ammo="shell",count=4} },
  },

  shell_box =
  {
    prob=40, cluster={ 1,3 },
    give={ {ammo="shell",count=20} },
  },

  rockets =
  {
    prob=10, cluster={ 4,7 },
    give={ {ammo="rocket",count=1} },
  },

  rocket_box =
  {
    prob=40, cluster={ 1,3 },
    give={ {ammo="rocket",count=5} },
  },

  cells =
  {
    prob=20, cluster={ 2,5 },
    give={ {ammo="cell",count=20} },
  },

  cell_pack =
  {
    prob=40, cluster={ 1,2 },
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


COMMON_PLAYER_MODEL =
{
  doomguy =
  {
    stats   = { health=0, bullet=0, shell=0, rocket=0, cell=0 },
    weapons = { pistol=1, fist=1 },
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

DOOM2_EPISODE_THEMES =
{
  { URBAN=4, INDUSTRIAL=3, TECH=3, NATURE=9, CAVE=2, HELL=2 },
  { URBAN=9, INDUSTRIAL=5, TECH=7, NATURE=4, CAVE=2, HELL=4 },
  { URBAN=3, INDUSTRIAL=2, TECH=5, NATURE=3, CAVE=6, HELL=8 },

  -- this entry used for a single episode or level
  { URBAN=5, INDUSTRIAL=4, TECH=6, NATURE=5, CAVE=4, HELL=6 },
}


DOOM1_SECRET_EXITS =
{
  E1M3 = true,
  E2M5 = true,
  E3M6 = true,
  E4M2 = true,
}

DOOM2_SECRET_EXITS =
{
  MAP15 = true,
  MAP31 = true,
}

DOOM2_SECRET_KINDS =
{
  MAP31 = "wolfy",
  MAP32 = "wolfy",
}



DOOM1_EPISODE_BOSSES =
{
  "baron", -- the Bruiser Brothers
  "Cyberdemon",
  "Mastermind",
  "Mastermind",
}

DOOM2_LEVEL_BOSSES =
{
  MAP07 = "mancubus",
  MAP20 = "Mastermind",
  MAP30 = "boss_brain",
  MAP32 = "keen",
}


DOOM1_SKY_INFO =
{
  { color="white",  light=192 },
  { color="red",    light=176 },
  { color="red",    light=192 },
  { color="orange", light=192 },
}

DOOM2_SKY_INFO =
{
  { color="brown",  light=192 },
  { color="gray",   light=192 }, -- bright clouds + dark buildings
  { color="red",    light=192 },
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
      local ep_along = map / MAP_NUM
      local map_id = episode * 10 + map

      if MAP_NUM == 1 or map == 9 then
        ep_along = 0.5
      end

      local LEV =
      {
        name  = string.format("E%dM%d", episode, map),
        patch = string.format("WILV%d%d", episode-1, map-1),

        ep_along = ep_along,

        theme_ref = "TECH",

        key_list = { "kc_red", "kc_blue", "kc_yellow" },
        switch_list = { "sw_blue", "sw_hot", "sw_marble", "sw_wood" },
        bar_list = { "bar_wood", "bar_silver", "bar_metal" },

        sky_info = DOOM1_SKY_INFO[episode],

        boss_kind   = (map == 8) and DOOM1_EPISODE_BOSSES[episode],
        secret_kind = (map == 9) and "plain",

        style = {},
      }

      if LEV.ep_along > 0.44 and rand_odds(sel(MAP_NUM > 7, 50, 90)) then
        LEV.allow_bfg = true
      end

      if DOOM1_SECRET_EXITS[LEV.name] then
        LEV.secret_exit = true
        LEV.ep_along = 0.5
        LEV.allow_bfg = true
      end

      if map_id == 18 then
        LEV.arena_func = Arena_Doom_E1M8
      elseif map_id == 28 or map_id == 46 then
        LEV.arena_func = Arena_Doom_E2M8
      elseif map_id == 38 or map_id == 48 then
        -- FIXME
      end

      if LEV.arena_func then
        LEV.name_theme = "BOSS"
      end

      table.insert(list, LEV)
    end -- for map

  end -- for episode

  return list
end


function Doom2_get_levels()
  local list = {}

  local MAP_NUM = 11

  if OB_CONFIG.length == "single" then MAP_NUM = 1  end
  if OB_CONFIG.length == "few"    then MAP_NUM = 4  end
  if OB_CONFIG.length == "full"   then MAP_NUM = 32 end

  assert(GAME.sky_info)

  for map = 1,MAP_NUM do
    local episode
    local ep_along

    if map >= 31 then
      episode = 2 ; ep_along = 0.5
    elseif map >= 21 then
      episode = 3 ; ep_along = (map - 20) / 10
    elseif map >= 12 then
      episode = 2 ; ep_along = (map - 11) / 9
    else
      episode = 1 ; ep_along = map / 11
    end

    if OB_CONFIG.length == "single" then
      ep_along = 0.5
    elseif OB_CONFIG.length == "few" then
      ep_along = map / MAP_NUM
    end

    assert(ep_along <= 1)


    local theme_probs = DOOM2_EPISODE_THEMES[episode]
    if OB_CONFIG.length ~= "full" then
      theme_probs = DOOM2_EPISODE_THEMES[4]
    end
    assert(theme_probs)

    local LEV =
    {
      name  = string.format("MAP%02d", map),
      patch = string.format("CWILV%02d", map-1),

      ep_along = ep_along,

      theme_ref = "TECH",

      key_list = { "kc_red", "kc_blue", "kc_yellow" },
      switch_list = { "sw_blue", "sw_hot", "sw_marble", "sw_wood" },
      bar_list = { "bar_wood", "bar_silver", "bar_metal" },

      -- allow TNT and Plutonia to override the sky stuff
      sky_info = GAME.sky_info[episode],

      style = {},
    }

    if LEV.ep_along > 0.44 and rand_odds(sel(MAP_NUM > 7, 50, 90)) then
      LEV.allow_bfg = true
    end

    -- secret levels
    if map == 31 or map == 32 then
      LEV.theme_ref = "WOLF"
      LEV.allow_bfg = true
    end

    if map == 23 then
      LEV.style.barrels = "heaps"
    end

    if map == 7 then
      LEV.arena_func = Arena_Doom_MAP07
    elseif map == 17 then  -- 16..18
      -- FIXME
    elseif map == 24 then  -- or 25
      -- FIXME
    elseif map == 30 then
      LEV.arena_func = Arena_Doom_MAP30
    end

    if LEV.arena_func then
      LEV.name_theme = "BOSS"
    end

---!!! LEV.boss_kind   = DOOM2_LEVEL_BOSSES[LEV.name]
    LEV.secret_kind = DOOM2_SECRET_KINDS[LEV.name]
    LEV.secret_exit = DOOM2_SECRET_EXITS[LEV.name]

    table.insert(list, LEV)
  end

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

---##  -- blackness (BLAKWAL1)
---##  gui.wad_logo_gfx("RW34_1",   "p", "BOLT", 64,128, 5)
---##  gui.wad_logo_gfx("O_BLACK",  "f", "BOLT", 64,64,  5)
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

  local desc_list = Naming_generate("TECH", #GAME.all_levels, PARAM.max_level_desc)

  for index,LEV in ipairs(GAME.all_levels) do
    if not LEV.description then
      LEV.description = desc_list[index]
    end
  end


  Doom_make_cool_gfx()
end


------------------------------------------------------------

function Doom_common_setup()

  GAME.player_model = COMMON_PLAYER_MODEL

  GAME.sanity_map = DOOM_SANITY_MAP

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

  Game_merge_tab("materials", DOOM1_MATERIALS)
  Game_merge_tab("combos",    DOOM1_COMBOS)
  Game_merge_tab("exits",     DOOM1_EXITS)
  Game_merge_tab("hallways",  DOOM1_HALLWAYS)
  Game_merge_tab("crates",    DOOM1_CRATES)
  Game_merge_tab("wall_fabs", DOOM1_WALL_PREFABS)

  GAME.rails = DOOM1_RAILS

  -- remove DOOM2-only weapons and items --

  GAME.weapons["super"] = nil 
  GAME.pickups["mega"]  = nil

  GAME.dm.weapons["super"] = nil

  GAME.monsters["Cyberdemon"].crazy_prob = 8
  GAME.monsters["Mastermind"].crazy_prob = 12
end


function Doom2_setup(game)

  Doom_common_setup()

---  T.episodes   = 3

  GAME.quests   = DOOM2_QUESTS
  GAME.sky_info = DOOM2_SKY_INFO
  GAME.rails    = DOOM2_RAILS

  Game_merge_tab("themes",   DOOM2_THEMES)
  Game_merge_tab("rooms",    DOOM2_ROOMS)
  Game_merge_tab("monsters", DOOM2_MONSTERS)

  Game_merge_tab("materials",DOOM2_MATERIALS)
  Game_merge_tab("combos",   DOOM2_COMBOS)
  Game_merge_tab("hallways", DOOM2_HALLWAYS)
  Game_merge_tab("exits",    DOOM2_EXITS)

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


------------------------------------------------------------

OB_GAMES["doom1"] =
{
  label = "Doom 1",
  format = "doom",

  priority = 98, -- keep at second spot

  setup_func = Doom1_setup,

  param =
  {
    rails = true,
    switches = true,
    liquids = true,
    teleporters = true,
    infighting = true,

    pack_sidedefs = true,
    custom_flats = true,

    seed_size = 256,

    sky_flat   = "F_SKY1",
    sky_tex    = "CEMENT3",

    error_tex  = "METAL"   or "FIREBLU1",
    error_flat = "CEIL5_1" or "SFLR6_4",
    error_mat  = "METAL",

    max_level_desc = 28,

    skip_monsters = { 2,3 },

    mon_time_max = 12,

    mon_damage_max  = 200,
    mon_damage_high = 100,
    mon_damage_low  =   1,

    ammo_factor   = 0.8,
    health_factor = 0.7,
  },

  hooks =
  {
    get_levels = Doom1_get_levels,

    describe_levels = Doom_describe_levels,
    make_level_gfx  = Doom_make_level_gfx,
  },
}


OB_GAMES["doom2"] =
{
  label = "Doom 2",
  format = "doom",

  priority = 99, -- keep at top

  setup_func = Doom2_setup,

  param =
  {
    rails = true,
    switches = true,
    liquids = true,
    teleporters = true,
    infighting = true,

    pack_sidedefs = true,
    custom_flats = true,

    seed_size = 256,

    sky_flat   = "F_SKY1",
    sky_tex    = "CEMENT3",

    error_tex  = "METAL"   or "FIREBLU1",
    error_flat = "CEIL5_1" or "SFLR6_4",
    error_mat  = "METAL",

    -- this is roughly how many characters can fit on the
    -- intermission screens (the CWILVxx patches).  It does
    -- not reflect any buffer limits in Doom ports.
    max_level_desc = 28,

    skip_monsters = { 4,5 },

    mon_time_max = 12,
    mon_hard_health = 200,

    mon_damage_max  = 200,
    mon_damage_high = 100,
    mon_damage_low  =   1,

    ammo_factor   = 0.8,
    health_factor = 0.7,
  },

  hooks =
  {
    get_levels = Doom2_get_levels,

    describe_levels = Doom_describe_levels,
    make_level_gfx  = Doom_make_level_gfx,
  },
}

