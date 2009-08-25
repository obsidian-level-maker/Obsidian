----------------------------------------------------------------
-- GAME DEF : DOOM I and II
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

COMMON_THINGS =
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

COMMON_MATERIALS =
{
  -- special materials --
  _ERROR = { t="METAL",   f="CEIL5_2" },
  _SKY   = { t="CEMENT3", f="F_SKY1" },

  -- textures with best-matching flat

  BIGDOOR1 = { t="BIGDOOR1", f="FLAT23" },
  BIGDOOR2 = { t="BIGDOOR2", f="FLAT1" },
  BIGDOOR3 = { t="BIGDOOR3", f="FLOOR7_2" },
  BIGDOOR4 = { t="BIGDOOR4", f="FLOOR3_3" },
  BIGDOOR5 = { t="BIGDOOR5", f="FLAT5_2" },
  BIGDOOR6 = { t="BIGDOOR6", f="CEIL5_2" },
  BIGDOOR7 = { t="BIGDOOR7", f="CEIL5_2" },

  BLODRIP1 = { t="BLODRIP1", f="FLOOR0_1" },
  BROWN1   = { t="BROWN1",   f="FLOOR0_1" },
  BROWN144 = { t="BROWN144", f="FLOOR7_1" },
  BROWN96  = { t="BROWN96",  f="FLOOR7_1" },
  BROWNHUG = { t="BROWNHUG", f="FLOOR7_1" },
  BROWNPIP = { t="BROWNPIP", f="FLOOR0_1" },
  BROWNGRN = { t="BROWNGRN", f="FLAT1" },  -- poor match
  BROVINE2 = { t="BROVINE2", f="FLAT1" },  -- poor match
  BRNPOIS  = { t="BRNPOIS",  f="FLAT1" },  -- poor match

  COMPBLUE = { t="COMPBLUE", f="FLAT14" },
  COMPSPAN = { t="COMPSPAN", f="CEIL5_1" },
  COMPSTA1 = { t="COMPSTA1", f="FLAT23" },
  COMPSTA2 = { t="COMPSTA2", f="FLAT23" },
  COMPTALL = { t="COMPTALL", f="CEIL5_1" },
  COMPWERD = { t="COMPWERD", f="CEIL5_1" },
  CRATE1   = { t="CRATE1",   f="CRATOP2" },
  CRATE2   = { t="CRATE2",   f="CRATOP1" },
  CRATELIT = { t="CRATELIT", f="CRATOP1" },
  CRATINY  = { t="CRATINY",  f="CRATOP1" },
  CRATWIDE = { t="CRATWIDE", f="CRATOP1" },

  DOOR1    = { t="DOOR1",    f="FLAT23" },
  DOOR3    = { t="DOOR3",    f="FLAT23" },
  DOORBLU  = { t="DOORBLU",  f="FLAT23" },
  DOORRED  = { t="DOORRED",  f="FLAT23" },
  DOORYEL  = { t="DOORYEL",  f="FLAT23" },
  DOORBLU2 = { t="DOORBLU2", f="CRATOP2" },
  DOORRED2 = { t="DOORRED2", f="CRATOP2" },
  DOORYEL2 = { t="DOORYEL2", f="CRATOP2" },
  DOORSTOP = { t="DOORSTOP", f="FLAT23" },
  DOORTRAK = { t="DOORTRAK", f="FLAT23" },
  EXITDOOR = { t="EXITDOOR", f="FLAT5_5" },
  EXITSIGN = { t="EXITSIGN", f="CEIL5_1" },
  EXITSTON = { t="EXITSTON", f="MFLR8_1" },

  FIREWALL = { t="FIREWALL", f="LAVA1" },
  GRAY1    = { t="GRAY1",    f="FLAT18" },
  GRAY2    = { t="GRAY2",    f="FLAT18" },
  GRAY4    = { t="GRAY4",    f="FLAT18" },
  GRAY5    = { t="GRAY5",    f="FLAT18" },
  GRAY7    = { t="GRAY7",    f="FLAT18"   },  
  GRAYBIG  = { t="GRAYBIG",  f="FLAT18" },
  GRAYPOIS = { t="GRAYPOIS", f="FLAT18" },
  GRAYTALL = { t="GRAYTALL", f="FLAT18" },
  GRAYVINE = { t="GRAYVINE", f="FLAT18" },

  GSTFONT1 = { t="GSTFONT1", f="DEM1_5" },
  GSTGARG  = { t="GSTGARG",  f="DEM1_5" },
  GSTLION  = { t="GSTLION",  f="DEM1_5" },
  GSTONE1  = { t="GSTONE1",  f="DEM1_5" },
  GSTONE2  = { t="GSTONE2",  f="DEM1_5" },
  GSTSATYR = { t="GSTSATYR", f="DEM1_5" },
  GSTVINE1 = { t="GSTVINE1", f="DEM1_5" },
  GSTVINE2 = { t="GSTVINE2", f="DEM1_5" },

  ICKWALL1 = { t="ICKWALL1", f="FLAT19" },
  ICKWALL2 = { t="ICKWALL2", f="FLAT19" },
  ICKWALL3 = { t="ICKWALL3", f="FLAT19" },
  ICKWALL4 = { t="ICKWALL4", f="FLAT19" },
  ICKWALL5 = { t="ICKWALL5", f="FLAT19" },
  ICKWALL7 = { t="ICKWALL7", f="FLAT19" },

  LITE3    = { t="LITE3",    f="FLAT19" },
  LITE5    = { t="LITE5",    f="FLAT19" },
  LITEBLU1 = { t="LITEBLU1", f="FLAT23" },
  LITEBLU4 = { t="LITEBLU4", f="FLAT1" },

  MARBLE1  = { t="MARBLE1",  f="FLOOR7_2" },
  MARBLE2  = { t="MARBLE2",  f="FLOOR7_2" },
  MARBLE3  = { t="MARBLE3",  f="FLOOR7_2" },
  MARBFAC2 = { t="MARBFAC2", f="FLOOR7_2" },
  MARBFAC3 = { t="MARBFAC3", f="FLOOR7_2" },
  MARBFACE = { t="MARBFACE", f="FLOOR7_2" },
  MARBLOD1 = { t="MARBLOD1", f="FLOOR7_2" },

  METAL    = { t="METAL",    f="CEIL5_2"  },
  METAL1   = { t="METAL1",   f="FLOOR4_8" },
  NUKE24   = { t="NUKE24",   f="FLOOR7_1" },
  NUKEDGE1 = { t="NUKEDGE1", f="FLOOR7_1" },
  NUKEPOIS = { t="NUKEPOIS", f="FLOOR7_1" },
  PIPE1    = { t="PIPE1",    f="FLOOR4_5" },
  PIPE2    = { t="PIPE2",    f="FLOOR4_5" },
  PIPE4    = { t="PIPE4",    f="FLOOR4_5" },
  PIPE6    = { t="PIPE6",    f="FLOOR4_5" },
  PLAT1    = { t="PLAT1",    f="FLAT4" },
  ROCKRED1 = { t="ROCKRED1", f="FLOOR6_1" },  -- better in DOOM2
  REDWALL  = { t="REDWALL",  f="FLAT5_3" },

  SHAWN1   = { t="SHAWN1",   f="FLAT23" },
  SHAWN2   = { t="SHAWN2",   f="FLAT23" },
  SHAWN3   = { t="SHAWN3",   f="FLAT23" },
  SKIN2    = { t="SKIN2",    f="SFLR6_4" },
  SKINEDGE = { t="SKINEDGE", f="SFLR6_4" },
  SKINFACE = { t="SKINFACE", f="SFLR6_4" },
  SKINCUT  = { t="SKINCUT",  f="CEIL5_2" },
  SKINLOW  = { t="SKINLOW",  f="FLAT5_2" },
  SKINMET1 = { t="SKINMET1", f="CEIL5_2" },
  SKINMET2 = { t="SKINMET2", f="CEIL5_2" },
  SKINSCAB = { t="SKINSCAB", f="CEIL5_2" },
  SKINSYMB = { t="SKINSYMB", f="CEIL5_2" },
  SKSNAKE1 = { t="SKSNAKE1", f="SFLR6_1" },
  SKSNAKE2 = { t="SKSNAKE2", f="SFLR6_4" },
  SKSPINE1 = { t="SKSPINE1", f="FLAT5_6" },
  SKSPINE2 = { t="SKSPINE2", f="FLAT5_6" },
  SLADPOIS = { t="SLADPOIS", f="FLAT4" },  -- poor match
  SLADSKUL = { t="SLADSKUL", f="FLAT4" },  -- poor match
  SLADWALL = { t="SLADWALL", f="FLAT4" },  -- poor match
  SP_DUDE1 = { t="SP_DUDE1", f="DEM1_5" },
  SP_DUDE2 = { t="SP_DUDE2", f="DEM1_5" },
  SP_DUDE4 = { t="SP_DUDE4", f="DEM1_5" },
  SP_DUDE5 = { t="SP_DUDE5", f="DEM1_5" },
  SP_FACE1 = { t="SP_FACE1", f="CRATOP2" },
  SP_HOT1  = { t="SP_HOT1",  f="FLAT5_3" },
  SP_ROCK1 = { t="SP_ROCK1", f="MFLR8_3" },  -- poor match

  STARG1   = { t="STARG1",   f="FLAT1" },  -- poor match
  STARG2   = { t="STARG2",   f="FLAT1" },  -- poor match
  STARG3   = { t="STARG3",   f="FLAT1" },  -- poor match
  STARGR1  = { t="STARGR1",  f="FLAT3" },
  STARGR2  = { t="STARGR2",  f="FLAT3" },
  STARBR2  = { t="STARBR2",  f="FLOOR0_2" },
  STARTAN2 = { t="STARTAN2", f="FLOOR4_1" },
  STARTAN3 = { t="STARTAN3", f="FLOOR4_5" },  -- poor match

  STEP1    = { t="STEP1",    f="FLOOR7_1" },
  STEP2    = { t="STEP2",    f="FLOOR4_6" },
  STEP3    = { t="STEP3",    f="CEIL5_1" },
  STEP4    = { t="STEP4",    f="FLAT19" },
  STEP5    = { t="STEP5",    f="FLOOR7_1" },
  STEP6    = { t="STEP6",    f="FLAT5" },
  STEPLAD1 = { t="STEPLAD1", f="FLOOR7_1" },
  STEPTOP  = { t="STEPTOP",  f="FLOOR7_1" },

  STONE    = { t="STONE",    f="FLAT1" },
  STONE2   = { t="STONE2",   f="MFLR8_1" },
  STONE3   = { t="STONE3",   f="MFLR8_1" },
  SUPPORT2 = { t="SUPPORT2", f="FLAT23" },
  SUPPORT3 = { t="SUPPORT3", f="CEIL5_2" },

  TEKWALL1 = { t="TEKWALL1",  f="CEIL5_1" },  -- poor match
  TEKWALL4 = { t="TEKWALL4",  f="CEIL5_1" },  -- poor match
  WOOD1    = { t="WOOD1",     f="FLAT5_2" },
  WOOD3    = { t="WOOD3",     f="FLAT5_1" },
  WOOD4    = { t="WOOD4",     f="FLAT5_2" },
  WOOD5    = { t="WOOD5",     f="CEIL5_2" },
  WOODGARG = { t="WOODGARG",  f="FLAT5_2" },

  SW1BLUE  = { t="SW1BLUE",  f="FLAT14" },
  SW1BRCOM = { t="SW1BRCOM", f="FLOOR7_1" },
  SW1BRN2  = { t="SW1BRN2",  f="FLOOR0_1" },
  SW1BRNGN = { t="SW1BRNGN", f="FLOOR3_3" }, -- poor match
  SW1BROWN = { t="SW1BROWN", f="FLOOR7_1" },
  SW1COMM  = { t="SW1COMM",  f="FLAT23" },
  SW1COMP  = { t="SW1COMP",  f="CEIL5_1" },
  SW1DIRT  = { t="SW1DIRT",  f="FLOOR7_1" },
  SW1EXIT  = { t="SW1EXIT",  f="FLAT19" },
  SW1GARG  = { t="SW1GARG",  f="CEIL5_2" },
  SW1GRAY  = { t="SW1GRAY",  f="FLAT19" },
  SW1GRAY1 = { t="SW1GRAY1", f="FLAT19" },

  SW1GSTON = { t="SW1GSTON", f="FLOOR7_2" },
  SW1HOT   = { t="SW1HOT",   f="FLOOR1_7" },
  SW1LION  = { t="SW1LION",  f="CEIL5_2" },
  SW1METAL = { t="SW1METAL", f="FLOOR4_8" },
  SW1PIPE  = { t="SW1PIPE",  f="FLOOR4_5" },
  SW1SATYR = { t="SW1SATYR", f="CEIL5_2" },
  SW1SKIN  = { t="SW1SKIN",  f="CRATOP2" },
  SW1SLAD  = { t="SW1SLAD",  f="FLAT4" },  -- poor match
  SW1STON1 = { t="SW1STON1", f="MFLR8_1" },
  SW1STRTN = { t="SW1STRTN", f="FLOOR4_1" },
  SW1VINE  = { t="SW1VINE",  f="FLAT1" },
  SW1WOOD  = { t="SW1WOOD",  f="FLAT5_2" },
  

---??? possible special use (e.g. WATER/NUKAGE/LAVA falls)
--FIREBLU1
--FIRELAVA
--FIREMAG1


  -- flats with closest texture

  BLOOD1   = { t="ROCKRED1", f="BLOOD1" },  -- better in DOOM2

  CEIL1_1  = { t="WOOD1",    f="CEIL1_1" },
  CEIL1_3  = { t="WOOD1",    f="CEIL1_3" },
  CEIL1_2  = { t="METAL",    f="CEIL1_2" },
  CEIL3_1  = { t="STARBR2",  f="CEIL3_1" },
  CEIL3_2  = { t="STARTAN2", f="CEIL3_2" },
  CEIL3_3  = { t="STARTAN2", f="CEIL3_3" },
  CEIL3_4  = { t="STARTAN2", f="CEIL3_4" },
  CEIL3_5  = { t="STONE2",   f="CEIL3_5" },
  CEIL3_6  = { t="STONE2",   f="CEIL3_6" },
  CEIL4_1  = { t="COMPBLUE", f="CEIL4_1" },
  CEIL4_2  = { t="COMPBLUE", f="CEIL4_2" },
  CEIL4_3  = { t="COMPBLUE", f="CEIL4_3" },
  CEIL5_1  = { t="COMPSPAN", f="CEIL5_1" },
  CEIL5_2  = { t="METAL",    f="CEIL5_2" },
  COMP01   = { t="GRAY1",    f="COMP01" },
  CONS1_1  = { t="COMPWERD", f="CONS1_1" },  -- poor match
  CONS1_5  = { t="COMPWERD", f="CONS1_5" },  -- poor match
  CONS1_7  = { t="COMPWERD", f="CONS1_7" },  -- poor match

  DEM1_1   = { t="MARBLE1",  f="DEM1_1" },
  DEM1_2   = { t="MARBLE1",  f="DEM1_2" },
  DEM1_3   = { t="MARBLE1",  f="DEM1_3" },
  DEM1_4   = { t="MARBLE1",  f="DEM1_4" },
  DEM1_5   = { t="MARBLE1",  f="DEM1_5" },
  DEM1_6   = { t="MARBLE1",  f="DEM1_6" },

  FLAT1    = { t="GRAY1",    f="FLAT1" },
  FLAT1_1  = { t="BROWN1",   f="FLAT1_1" },  -- poor match
  FLAT1_2  = { t="BROWN1",   f="FLAT1_2" },  -- poor match
  FLAT1_3  = { t="BROWN1",   f="FLAT1_3" },  -- poor match
  FLAT2    = { t="GRAY1",    f="FLAT2" },
  FLAT3    = { t="GRAY4",    f="FLAT3" },
  FLAT4    = { t="COMPSPAN", f="FLAT4" },  -- poor match
  FLAT5    = { t="BROWNHUG", f="FLAT5" },
  FLAT5_1  = { t="WOOD1",    f="FLAT5_1" },
  FLAT5_2  = { t="WOOD1",    f="FLAT5_2" },
  FLAT5_3  = { t="REDWALL",  f="FLAT5_3" },
  FLAT5_4  = { t="STONE",    f="FLAT5_4" },
  FLAT5_5  = { t="BROWN1",   f="FLAT5_5" },
  FLAT5_6  = { t="SP_FACE1", f="FLAT5_6" },  -- better in DOOM1
  FLAT8    = { t="STARBR2",  f="FLAT8" },
  FLAT9    = { t="GRAY4",    f="FLAT9" },
  FLAT10   = { t="BROWNHUG", f="FLAT10" },  -- better in DOOM2
  FLAT14   = { t="COMPBLUE", f="FLAT14" },
  FLAT17   = { t="GRAY1",    f="FLAT17" },
  FLAT18   = { t="GRAY1",    f="FLAT18" },
  FLAT19   = { t="GRAY1",    f="FLAT19" },
  FLAT20   = { t="SHAWN2",   f="FLAT20" },
  FLAT22   = { t="SHAWN2",   f="FLAT22" },
  FLAT23   = { t="SHAWN2",   f="FLAT23" },

  FLOOR0_1 = { t="STARTAN2", f="FLOOR0_1" },
  FLOOR0_2 = { t="STARBR2",  f="FLOOR0_2" },
  FLOOR0_3 = { t="GRAY1",    f="FLOOR0_3" },
  FLOOR0_5 = { t="GRAY1",    f="FLOOR0_5" },
  FLOOR0_6 = { t="GRAY1",    f="FLOOR0_6" },
  FLOOR0_7 = { t="GRAY1",    f="FLOOR0_7" },
  FLOOR1_1 = { t="COMPBLUE", f="FLOOR1_1" },
  FLOOR1_6 = { t="REDWALL",  f="FLOOR1_6" },
  FLOOR1_7 = { t="REDWALL",  f="FLOOR1_7" },
  FLOOR3_3 = { t="BROWN1",   f="FLOOR3_3" },  -- poor match
  FLOOR4_1 = { t="STARTAN2", f="FLOOR4_1" },
  FLOOR4_5 = { t="STARTAN2", f="FLOOR4_5" },
  FLOOR4_6 = { t="STARTAN2", f="FLOOR4_6" },
  FLOOR4_8 = { t="METAL1",   f="FLOOR4_8" },
  FLOOR5_1 = { t="METAL1",   f="FLOOR5_1" },
  FLOOR5_2 = { t="BROWNHUG", f="FLOOR5_2" },
  FLOOR5_3 = { t="BROWNHUG", f="FLOOR5_3" },
  FLOOR5_4 = { t="BROWNHUG", f="FLOOR5_4" },
  FLOOR6_1 = { t="REDWALL",  f="FLOOR6_1" },  -- poor match
  FLOOR7_1 = { t="BROWNHUG", f="FLOOR7_1" },
  FLOOR7_2 = { t="MARBLE1",  f="FLOOR7_2" },
  FWATER1  = { t="COMPBLUE", f="FWATER1" },

  GATE1    = { t="METAL",    f="GATE1" },
  GATE2    = { t="METAL",    f="GATE2" },
  GATE3    = { t="METAL",    f="GATE3" },
  GATE4    = { t="METAL",    f="GATE4" },
  LAVA1    = { t="ROCKRED1", f="LAVA1" },
  MFLR8_1  = { t="STONE2",   f="MFLR8_1" },
  MFLR8_2  = { t="BROWNHUG", f="MFLR8_2" },
  MFLR8_3  = { t="SP_ROCK1", f="MFLR8_3" },  -- poor match
  NUKAGE1  = { t="GSTVINE2", f="NUKAGE1" },  -- better in DOOM2
  SFLR6_1  = { t="SKSNAKE1", f="SFLR6_1" },
  SFLR6_4  = { t="SKSNAKE2", f="SFLR6_4" },
  SFLR7_1  = { t="SKSNAKE1", f="SFLR7_1" },
  SFLR7_4  = { t="SKSNAKE1", f="SFLR7_4" },
  STEP_I   = { t="SHAWN2",   f="STEP1" },
  STEP_H   = { t="SHAWN2",   f="STEP2" },
  TLITE6_1 = { t="METAL",    f="TLITE6_1" },
  TLITE6_4 = { t="METAL",    f="TLITE6_4" },
  TLITE6_5 = { t="METAL",    f="TLITE6_5" },
  TLITE6_6 = { t="METAL",    f="TLITE6_6" },


  -- Oblige stuff
  O_PILL   = { t="CEMENT1",  f="O_PILL" },
  O_BOLT   = { t="CEMENT2",  f="O_BOLT" },
  O_RELIEF = { t="CEMENT3",  f="O_RELIEF" },
  O_CARVE  = { t="CEMENT4",  f="O_CARVE" },


  -- Missing stuff:
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

  ASHWALL  = { t="ASHWALL",  f="FLOOR6_2" },
  BLODGR1  = { t="BLODGR1",  f="FLOOR0_1" },
  BROVINE  = { t="BROVINE",  f="FLOOR0_1" },
  BRNPOIS2 = { t="BRNPOIS2", f="FLOOR7_1" },
  BROWNWEL = { t="BROWNWEL", f="FLOOR7_1" },

  COMP2    = { t="COMP2",    f="CEIL5_1" },
  COMPOHSO = { t="COMPOHSO", f="FLOOR7_1" },
  COMPTILE = { t="COMPTILE", f="CEIL5_1" },
  COMPUTE1 = { t="COMPUTE1", f="FLAT19" },
  COMPUTE2 = { t="COMPUTE2", f="CEIL5_1" },
  COMPUTE3 = { t="COMPUTE3", f="CEIL5_1" },
  DOORHI   = { t="DOORHI",   f="FLAT19" },
  GRAYDANG = { t="GRAYDANG", f="FLAT19" },
  ICKDOOR1 = { t="ICKDOOR1", f="FLAT19" },
  ICKWALL6 = { t="ICKWALL6", f="FLAT18" },

  LITE2    = { t="LITE2",    f="FLOOR0_1" },
  LITE4    = { t="LITE4",    f="FLAT19" },
  LITE96   = { t="LITE96",   f="FLOOR7_1" },
  LITEBLU2 = { t="LITEBLU2", f="FLAT23" },
  LITEBLU3 = { t="LITEBLU3", f="FLAT23" },
  LITEMET  = { t="LITEMET",  f="FLOOR4_8" },
  LITERED  = { t="LITERED",  f="FLOOR1_6" },
  LITESTON = { t="LITESTON", f="MFLR8_1" },

  NUKESLAD = { t="NUKESLAD", f="FLAT4" },  -- poor match
  PLANET1  = { t="PLANET1",  f="FLAT23" },
  REDWALL1 = { t="REDWALL1", f="FLOOR1_6" },
  ROCKRED1 = { t="ROCKRED1", f="RROCK01" },
  SKINBORD = { t="SKINBORD", f="FLAT5_5" },
  SKINTEK1 = { t="SKINTEK1", f="FLAT5_5" },  -- poor match
  SKINTEK2 = { t="SKINTEK2", f="FLAT5_5" },  -- poor match
  SKULWAL3 = { t="SKULWAL3", f="FLAT5_6" },
  SKULWALL = { t="SKULWALL", f="FLAT5_6" },
  SLADRIP1 = { t="SLADRIP1", f="FLAT4" },  -- poor match
  SP_DUDE3 = { t="SP_DUDE3", f="DEM1_5" },
  SP_DUDE6 = { t="SP_DUDE6", f="DEM1_5" },
  SP_ROCK1 = { t="SP_ROCK1", f="MFLR8_3" },  -- poor match
  STARTAN1 = { t="STARTAN1", f="FLOOR4_1" },
  STONGARG = { t="STONGARG", f="MFLR8_1" },
  STONPOIS = { t="STONPOIS", f="FLAT5_4" },
  TEKWALL2 = { t="TEKWALL2", f="CEIL5_1" },  -- poor match
  TEKWALL3 = { t="TEKWALL3", f="CEIL5_1" },  -- poor match
  TEKWALL5 = { t="TEKWALL5", f="CEIL5_1" },  -- poor match
  WOODSKUL = { t="WOODSKUL", f="FLAT5_2" },


  -- flats with closest texture

  FLAT5_6  = { t="SKULWALL", f="FLAT5_6" },
  FLAT5_7  = { t="ASHWALL",  f="FLAT5_7" },
  FLAT5_8  = { t="ASHWALL",  f="FLAT5_8" },
  FLOOR6_2 = { t="ASHWALL",  f="FLOOR6_2" },
  MFLR8_4  = { t="ASHWALL",  f="MFLR8_4" },
}



DOOM2_MATERIALS =
{
  -- textures with best-matching flat

  ASHWALL  = { t="ASHWALL2", f="MFLR8_4" },  -- compatibility name
  ASHWALL3 = { t="ASHWALL3", f="FLAT10" },
  ASHWALL4 = { t="ASHWALL4", f="FLAT10" },
  ASHWALL6 = { t="ASHWALL6", f="RROCK20" },
  ASHWALL7 = { t="ASHWALL7", f="RROCK18" },
  BFALL1   = { t="BFALL1",   f="BLOOD1" },
  BIGBRIK1 = { t="BIGBRIK1", f="RROCK14" },
  BIGBRIK3 = { t="BIGBRIK3", f="RROCK14" },
  BIGBRIK2 = { t="BIGBRIK2", f="MFLR8_1" },
  BLAKWAL1 = { t="BLAKWAL1", f="CEIL5_1" },
  BLAKWAL2 = { t="BLAKWAL2", f="CEIL5_1" },

  BRICK1   = { t="BRICK1",   f="RROCK10" },
  BRICK2   = { t="BRICK2",   f="RROCK10" },
  BRICK3   = { t="BRICK3",   f="FLAT5_5" },
  BRICK4   = { t="BRICK4",   f="FLAT5_5" },
  BRICK5   = { t="BRICK5",   f="RROCK10" },
  BRICK6   = { t="BRICK6",   f="FLOOR5_4" },
  BRICK7   = { t="BRICK7",   f="FLOOR5_4" },
  BRICK8   = { t="BRICK8",   f="FLOOR5_4" },
  BRICK9   = { t="BRICK9",   f="FLOOR5_4" },
  BRICK10  = { t="BRICK10",  f="SLIME13" },
  BRICK11  = { t="BRICK11",  f="FLAT5_3" },
  BRICK12  = { t="BRICK12",  f="FLAT5_5" },  -- poor match
  BRONZE1  = { t="BRONZE1",  f="FLOOR7_1" },
  BRONZE2  = { t="BRONZE2",  f="FLOOR7_1" },
  BRONZE3  = { t="BRONZE3",  f="FLOOR7_1" },
  BRONZE4  = { t="BRONZE4",  f="FLOOR7_1" },
  BRICKLIT = { t="BRICKLIT", f="RROCK10" },
  BRWINDOW = { t="BRWINDOW", f="RROCK10" },
  BSTONE1  = { t="BSTONE1",  f="RROCK11" },
  BSTONE2  = { t="BSTONE2",  f="RROCK12" },
  BSTONE3  = { t="BSTONE3",  f="RROCK12" },

  CRACKLE2 = { t="CRACKLE2", f="RROCK01" },
  CRACKLE4 = { t="CRACKLE4", f="RROCK02" },
  CRATE3   = { t="CRATE3",   f="CRATOP1" },
  DBRAIN1  = { t="DBRAIN1",  f="LAVA1" },
  MARBFAC4 = { t="MARBFAC4", f="DEM1_5" },
  MARBGRAY = { t="MARBGRAY", f="DEM1_5" },
  METAL2   = { t="METAL2",   f="CEIL5_2" },
  METAL3   = { t="METAL3",   f="CEIL5_2" },
  METAL4   = { t="METAL4",   f="CEIL5_2" },
  METAL5   = { t="METAL5",   f="CEIL5_2" },
  METAL6   = { t="METAL6",   f="CEIL5_2" },
  METAL7   = { t="METAL7",   f="CEIL5_2" },

  MODWALL1 = { t="MODWALL1", f="MFLR8_4" },
  MODWALL2 = { t="MODWALL2", f="MFLR8_4" },
  MODWALL3 = { t="MODWALL3", f="FLAT19" },
  MODWALL4 = { t="MODWALL4", f="FLAT18" },

  PANBLACK = { t="PANBLACK", f="RROCK09" },
  PANBLUE  = { t="PANBLUE",  f="RROCK09" },
  PANBOOK  = { t="PANBOOK",  f="RROCK09" },
  PANRED   = { t="PANRED",   f="RROCK09" },
  PANBORD1 = { t="PANBORD1", f="RROCK09" },
  PANBORD2 = { t="PANBORD2", f="RROCK09" },
  PANCASE1 = { t="PANCASE1", f="RROCK09" },
  PANCASE2 = { t="PANCASE2", f="RROCK09" },
  PANEL1   = { t="PANEL1",   f="RROCK09" },
  PANEL2   = { t="PANEL2",   f="RROCK09" },
  PANEL3   = { t="PANEL3",   f="RROCK09" },
  PANEL4   = { t="PANEL4",   f="RROCK09" },
  PANEL5   = { t="PANEL5",   f="RROCK09" },
  PANEL6   = { t="PANEL6",   f="RROCK09" },
  PANEL7   = { t="PANEL7",   f="RROCK09" },
  PANEL8   = { t="PANEL8",   f="RROCK09" },
  PANEL9   = { t="PANEL9",   f="RROCK09" },
  PIPES    = { t="PIPES",    f="FLOOR3_3" },
  PIPEWAL1 = { t="PIPEWAL1", f="RROCK03" },  -- poor match
  PIPEWAL2 = { t="PIPEWAL2", f="RROCK03" },  -- poor match
  ROCK1    = { t="ROCK1",    f="RROCK13" },
  ROCK2    = { t="ROCK2",    f="GRNROCK" },
  ROCK3    = { t="ROCK3",    f="RROCK13" },
  ROCK4    = { t="ROCK4",    f="RROCK11" },
  ROCK5    = { t="ROCK5",    f="RROCK11" },

  SFALL1   = { t="SFALL1",   f="NUKAGE1" },
  SILVER1  = { t="SILVER1",  f="FLAT23" },
  SILVER2  = { t="SILVER2",  f="FLAT22" },
  SILVER3  = { t="SILVER3",  f="FLAT23" },
  SK_LEFT  = { t="SK_LEFT",  f="FLAT5_6" },  -- poor match
  SK_RIGHT = { t="SK_RIGHT", f="FLAT5_6" },  -- poor match
  SLOPPY1  = { t="SLOPPY1",  f="FLAT5_6" },  -- poor match
  SLOPPY2  = { t="SLOPPY2",  f="FLAT5_6" },  -- poor match
  SP_DUDE7 = { t="SP_DUDE7", f="FLOOR5_4" },
  SP_DUDE8 = { t="SP_DUDE8", f="FLOOR5_4" },
  SP_FACE2 = { t="SP_FACE2", f="FLAT5_6" },

  SPACEW2  = { t="SPACEW2",  f="CEIL3_3" },
  SPACEW3  = { t="SPACEW3",  f="CEIL5_1" },
  SPACEW4  = { t="SPACEW4",  f="SLIME16" },
  SPCDOOR1 = { t="SPCDOOR1", f="FLOOR0_1" },
  SPCDOOR2 = { t="SPCDOOR2", f="FLAT19" },
  SPCDOOR3 = { t="SPCDOOR3", f="FLAT19" },
  SPCDOOR4 = { t="SPCDOOR4", f="FLOOR0_1" },
  STONE4   = { t="STONE4",   f="FLAT5_4" },
  STONE5   = { t="STONE5",   f="FLAT5_4" },
  STONE6   = { t="STONE6",   f="RROCK11" },
  STONE7   = { t="STONE7",   f="RROCK11" },
  STUCCO   = { t="STUCCO",   f="FLAT5_5" },
  STUCCO1  = { t="STUCCO1",  f="FLAT5_5" },
  STUCCO2  = { t="STUCCO2",  f="FLAT5_5" },
  STUCCO3  = { t="STUCCO3",  f="FLAT5_5" },

  TANROCK2 = { t="TANROCK2", f="FLOOR3_3" },
  TANROCK3 = { t="TANROCK3", f="RROCK11" },
  TANROCK4 = { t="TANROCK4", f="RROCK09" },
  TANROCK5 = { t="TANROCK5", f="RROCK18" },
  TANROCK7 = { t="TANROCK7", f="RROCK15" },
  TANROCK8 = { t="TANROCK8", f="RROCK09" },
  TEKBRON1 = { t="TEKBRON1", f="FLOOR0_1" },
  TEKBRON2 = { t="TEKBRON2", f="FLOOR0_1" },
  TEKLITE  = { t="TEKLITE",  f="FLOOR5_2" },
  TEKLITE2 = { t="TEKLITE2", f="FLOOR5_2" },
  TEKWALL6 = { t="TEKWALL6", f="CEIL5_1" },  -- poor match

  TEKGREN1 = { t="TEKGREN1", f="RROCK20" },  -- poor match
  TEKGREN2 = { t="TEKGREN2", f="RROCK20" },  -- poor match
  TEKGREN3 = { t="TEKGREN3", f="RROCK20" },  -- poor match
  TEKGREN4 = { t="TEKGREN4", f="RROCK20" },  -- poor match
  TEKGREN5 = { t="TEKGREN5", f="RROCK20" },  -- poor match

  WOOD6    = { t="WOOD6",    f="FLAT5_2" },
  WOOD7    = { t="WOOD7",    f="FLAT5_2" },
  WOOD8    = { t="WOOD8",    f="FLAT5_2" },
  WOOD9    = { t="WOOD9",    f="FLAT5_2" },
  WOOD10   = { t="WOOD10",   f="FLAT5_1" },
  WOOD12   = { t="WOOD12",   f="FLAT5_2" },
  WOODVERT = { t="WOODVERT", f="FLAT5_2" },
  WOODMET1 = { t="WOODMET1", f="CEIL5_2" },
  WOODMET2 = { t="WOODMET2", f="CEIL5_2" },
  WOODMET3 = { t="WOODMET3", f="CEIL5_2" },
  WOODMET4 = { t="WOODMET4", f="CEIL5_2" },

  ZIMMER1  = { t="ZIMMER1",  f="RROCK20" },
  ZIMMER2  = { t="ZIMMER2",  f="RROCK20" },
  ZIMMER3  = { t="ZIMMER3",  f="RROCK18" },
  ZIMMER4  = { t="ZIMMER4",  f="RROCK18" },
  ZIMMER5  = { t="ZIMMER5",  f="RROCK16" },
  ZIMMER7  = { t="ZIMMER7",  f="RROCK20" },
  ZIMMER8  = { t="ZIMMER8",  f="MFLR8_3" },
                          
  ZDOORB1  = { t="ZDOORB1",  f="FLAT23" },
  ZDOORF1  = { t="ZDOORF1",  f="FLAT23" },
  ZELDOOR  = { t="ZELDOOR",  f="FLAT23" },
  ZZWOLF1  = { t="ZZWOLF1",  f="FLAT18" },
  ZZWOLF2  = { t="ZZWOLF2",  f="FLAT18" },
  ZZWOLF3  = { t="ZZWOLF3",  f="FLAT18" },
  ZZWOLF4  = { t="ZZWOLF4",  f="FLAT18" },
  ZZWOLF5  = { t="ZZWOLF5",  f="FLAT5_1" },
  ZZWOLF6  = { t="ZZWOLF6",  f="FLAT5_1" },
  ZZWOLF7  = { t="ZZWOLF7",  f="FLAT5_1" },
  ZZWOLF9  = { t="ZZWOLF9",  f="FLAT14" },
  ZZWOLF10 = { t="ZZWOLF10", f="FLAT23" },
  ZZWOLF11 = { t="ZZWOLF11", f="FLAT5_3" },
  ZZWOLF12 = { t="ZZWOLF12", f="FLAT5_3" },
  ZZWOLF13 = { t="ZZWOLF13", f="FLAT5_3" },

  SW1BRIK  = { t="SW1BRIK",  f="MFLR8_1" },
  SW1MARB  = { t="SW1MARB",  f="DEM1_5" },
  SW1MET2  = { t="SW1MET2",  f="CEIL5_2" },
  SW1MOD1  = { t="SW1MOD1",  f="MFLR8_4" },
  SW1PANEL = { t="SW1PANEL", f="CEIL1_1" },
  SW1ROCK  = { t="SW1ROCK",  f="RROCK13" },
  SW1SKULL = { t="SW1SKULL", f="FLAT5_6" },
  SW1STON6 = { t="SW1STON6", f="RROCK11" },
  SW1TEK   = { t="SW1TEK",   f="RROCK20" },
  SW1WDMET = { t="SW1WDMET", f="CEIL5_2" },
  SW1ZIM   = { t="SW1ZIM",   f="RROCK20" },


  -- flats with closest texture

  BLOOD1   = { t="BFALL1",   f="BLOOD1" },
  CONS1_1  = { t="GRAY5",    f="CONS1_1" },
  CONS1_5  = { t="GRAY5",    f="CONS1_5" },
  CONS1_7  = { t="GRAY5",    f="CONS1_7" },

  FLAT1_1  = { t="BSTONE2",  f="FLAT1_1" },
  FLAT1_2  = { t="BSTONE2",  f="FLAT1_2" },
  FLAT1_3  = { t="BSTONE2",  f="FLAT1_3" },
  FLAT10   = { t="ASHWALL4", f="FLAT10" },
  FLAT22   = { t="SILVER2",  f="FLAT22" },
  FLAT5_5  = { t="STUCCO",   f="FLAT5_5"  },
  FLAT5_7  = { t="ASHWALL2", f="FLAT5_7" },
  FLAT5_8  = { t="ASHWALL2", f="FLAT5_8" },
  FLOOR6_2 = { t="ASHWALL2", f="FLOOR6_2" },
  GRASS1   = { t="ZIMMER2",  f="GRASS1"   },
  GRASS2   = { t="ZIMMER2",  f="GRASS2"   },
  GRNROCK  = { t="ROCK2",    f="GRNROCK" },
  GRNLITE1 = { t="TEKGREN2", f="GRNLITE1" },
  MFLR8_4  = { t="ASHWALL2", f="MFLR8_4" },
  NUKAGE1  = { t="SFALL1",   f="NUKAGE1" },

  RROCK01  = { t="CRACKLE2", f="RROCK01" },
  RROCK02  = { t="CRACKLE4", f="RROCK02" },
  RROCK03  = { t="ASHWALL3", f="RROCK03" },  -- poor match
  RROCK04  = { t="ASHWALL3", f="RROCK04" },
  RROCK05  = { t="ROCKRED1", f="RROCK05" },  -- poor match
  RROCK09  = { t="TANROCK4", f="RROCK09" },
  RROCK10  = { t="BRICK1",   f="RROCK10" },
  RROCK11  = { t="BSTONE1",  f="RROCK11" },
  RROCK12  = { t="BSTONE2",  f="RROCK12" },
  RROCK13  = { t="ROCK3",    f="RROCK13" },
  RROCK14  = { t="BIGBRIK1", f="RROCK14" },
  RROCK15  = { t="TANROCK7", f="RROCK15" },
  RROCK16  = { t="ZIMMER5",  f="RROCK16" },
  RROCK17  = { t="ZIMMER3",  f="RROCK17" },
  RROCK18  = { t="ZIMMER3",  f="RROCK18" },
  RROCK19  = { t="ZIMMER2",  f="RROCK19" },
  RROCK20  = { t="ZIMMER7",  f="RROCK20" },

  SLIME01  = { t="ZIMMER3",  f="SLIME01" },  -- poor match
  SLIME05  = { t="ZIMMER3",  f="SLIME05" },  -- poor match
  SLIME09  = { t="ROCKRED1", f="SLIME09" },  -- poor match
  SLIME13  = { t="BRICK10",  f="SLIME13" },
  SLIME14  = { t="METAL2",   f="SLIME14" },  -- poor match
  SLIME15  = { t="COMPSPAN", f="SLIME15" },  -- poor match
  SLIME16  = { t="SPACEW4",  f="SLIME16" },
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


COMMON_SANITY_MAP =
{
  -- liquids kill the player, so keep them recognisable
  LAVA1   = "FWATER1",
  FWATER1 = "BLOOD1",
  BLOOD1  = "NUKAGE1",
  NUKAGE1 = "LAVA1",
  LFALL1  = "WFALL1",
  WFALL1  = "BFALL1",
  BFALL1  = "SFALL1",
  SFALL1  = "LFALL1",
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

    stairwell =
    {
      walls =
      {
        BROWN1=50, GRAY1=50, STARGR1=50, METAL4=50
      },

      floors =
      {
        FLAT1=50, FLOOR7_1=50,
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

    door_probs   = { out_diff=10, combo_diff= 3, normal=1 },
    window_probs = { out_diff=20, combo_diff=30, normal=5 },

    prefer_stairs = true,
  },
}


------------------------------------------------------------

-- Monster list
-- ============
--
-- prob       : general probability
-- crazy_prob : probability for "Crazy" strength setting
--
-- health : hit points of monster
-- damage : damage can inflict per second (rough approx)
-- attack : kind of attack (hitscan | missile | melee)
--
-- float  : true if monster floats (flys)
-- invis  : true if invisible (or partially)
--
-- weap_prefs : weapon preferences table
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
    prob=40,
    health=20, damage=4, attack="hitscan",
    give={ {ammo="bullet",count=5} },
  },

  shooter =
  {
    prob=50,
    health=30, damage=10, attack="hitscan",
    give={ {weapon="shotty"}, {ammo="shell",count=4} },
  },

  imp =
  {
    prob=60,
    health=60, damage=20, attack="missile",
  },

  skull =
  {
    prob=20,
    health=100, damage=7, attack="melee",
    density=0.7, float=true,
    weap_prefs={ launch=0.2 },
  },

  demon =
  {
    prob=35,
    health=150, damage=25, attack="melee",
    weap_prefs={ launch=0.5 },
  },

  spectre =
  {
    replaces="demon", replace_prob=25, crazy_prob=21,
    health=150, damage=25, attack="melee",
    invis=true, outdoor_factor=3.0;
    weap_prefs={ launch=0.2 },
  },

  caco =
  {
    prob=40,
    health=400, damage=35, attack="missile",
    density=0.6, float=true,
  },

  baron =
  {
    prob=20,
    health=1000, damage=45, attack="missile",
    density=0.3,
    weap_prefs={ bfg=3.0 },
  },


  ---| DOOM BOSSES |---

  Cyberdemon =
  {
    -- not generated in normal levels
    crazy_prob=12,
    health=4000, damage=150, attack="missile",
    density=0.1,
    weap_prefs={ bfg=5.0 },
  },

  Mastermind =
  {
    crazy_prob=18,
    health=3000, damage=100, attack="hitscan",
    density=0.2,
    weap_prefs={ bfg=5.0 },
  },
}


DOOM2_MONSTERS =
{
  gunner =
  {
    prob=18,
    health=70, damage=50, attack="hitscan",
    give={ {weapon="chain"}, {ammo="bullet",count=10} },
  },

  revenant =
  {
    prob=44,
    health=300, damage=70, attack="missile",
    density=0.6,
  },

  knight =
  {
    prob=60, crazy_prob=40,
    health=500, damage=45, attack="missile",
    density=0.4,
  },

  mancubus =
  {
    prob=33,
    health=600, damage=70, attack="missile",
    density=0.4,
  },

  arach =
  {
    prob=25,
    health=500, damage=70, attack="missile",
    density=0.5,
  },

  vile =
  {
    prob=12,
    health=700, damage=40, attack="hitscan",  ---??? no_dist=true,
    density=0.2, never_promote=true,
  },

  pain =
  {
    prob=6, crazy_prob=15,
    health=700, damage=20, attack="missile",
    density=0.2,never_promote=true, float=true, 
    weap_prefs={ launch=0.2 },
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
    pref=30, add_prob=30, start_prob=0.2, rarity=4,
    rate=0.8, damage=300, attack="missile", splash={60,45,30,30,20,10},
    ammo="cell", per=40,
    give={ {ammo="cell",count=40} },
  },
}

DOOM2_WEAPONS =
{
  super =
  {
    pref=70, add_prob=20, start_prob=10,
    rate=0.6, damage=170, attack="hitscan", splash={ 0,30 },
    ammo="shell", per=2,
    give={ {ammo="shell",count=8} },
  },
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
  -- The backpack is handled as a POWERUP.
  --
  -- Armor (all types) is modelled as health, because it merely
  -- saves the player's health when you are hit with damage.
  -- The BLUE jacket saves 50% of damage, hence it is roughly
  -- equivalent to 100 units of health.
}

DOOM2_PICKUPS =
{
  mega =
  {
    prob=1, big_item=true,
    give={ {health=200} },
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


------------------------------------------------------------

DOOM1_EPISODES =
{
  episode1 =
  {
    theme = "TECH",
    sky_light = 0.85,
    secret_exits = { "E1M3" },
  },

  episode2 =
  {
    theme = "TECH",
    sky_light = 0.65,
    secret_exits = { "E2M5" },
  },

  episode3 =
  {
    theme = "HELL",
    sky_light = 0.75,
    secret_exits = { "E3M6" },
  },

  episode4 =
  {
    theme = "HELL",
    sky_light = 0.75,
    secret_exits = { "E4M2" },
  },
}

DOOM2_EPISODES =
{
  episode1 =
  {
    theme = "TECH",
    sky_light = 0.75,
  },

  episode2 =
  {
    theme = "URBAN",
    sky_light = 0.50,
    secret_exits = { "MAP16", "MAP31" },
  },

  episode3 =
  {
    theme = "HELL",
    sky_light = 0.75,
  },
}


function Doom1_setup()
  -- tweak monster probabilities

  GAME.monsters["Cyberdemon"].crazy_prob = 8
  GAME.monsters["Mastermind"].crazy_prob = 12
end


function Doom2_setup()
  -- nothing needed
end


function Doom1_get_levels()
  local EP_NUM  = sel(OB_CONFIG.length == "full", 4, 1)
  local MAP_NUM = sel(OB_CONFIG.length == "single", 1, 9)

  if OB_CONFIG.length == "few" then MAP_NUM = 4 end

  for episode = 1,EP_NUM do
    local ep_info = DOOM1_EPISODES["episode" .. episode]
    assert(ep_info)

    for map = 1,MAP_NUM do
      local ep_along = map / MAP_NUM

      if MAP_NUM == 1 then
        ep_along = rand_range(0.3, 0.7);
      elseif map == 9 then
        ep_along = 0.5
      end

      local LEV =
      {
        name  = string.format("E%dM%d", episode, map),
        patch = string.format("WILV%d%d", episode-1, map-1),

        episode  = episode,
        ep_along = ep_along,
        ep_info  = ep_info,

        theme_ref = "TECH",
        name_theme = "TECH",

        key_list = { "kc_red", "kc_blue", "kc_yellow" },
        switch_list = { "sw_blue", "sw_hot", "sw_marble", "sw_wood" },
        bar_list = { "bar_wood", "bar_silver", "bar_metal" },

        secret_kind = (map == 9) and "plain",

        style = {},
      }

      if LEV.name == "E1M8" then
        LEV.build_func = Arena_Doom_E1M8
      elseif LEV.name == "E2M8" or LEV.name == "E4M6" then
        LEV.build_func = Arena_Doom_E2M8
      elseif LEV.name == "E3M8" or LEV.name == "E4M8" then
        -- FIXME
      end

      if LEV.build_func then
        LEV.name_theme = "BOSS"
      end

      table.insert(GAME.all_levels, LEV)
    end -- for map

  end -- for episode
end


function Doom2_get_levels()
  local MAP_NUM = 11

  if OB_CONFIG.length == "single" then MAP_NUM = 1  end
  if OB_CONFIG.length == "few"    then MAP_NUM = 4  end
  if OB_CONFIG.length == "full"   then MAP_NUM = 32 end

--!!   assert(GAME.sky_info)

  for map = 1,MAP_NUM do
    -- determine episode from map number
    local episode
    local ep_along

    if map >= 31 then
      episode = 2 ; ep_along = 0.35
    elseif map >= 21 then
      episode = 3 ; ep_along = (map - 20) / 10
    elseif map >= 12 then
      episode = 2 ; ep_along = (map - 11) / 9
    else
      episode = 1 ; ep_along = map / 11
    end

    if MAP_NUM == 1 then
      ep_along = rand_range(0.3, 0.7)
    end

    if OB_CONFIG.length == "single" then
      ep_along = 0.5
    elseif OB_CONFIG.length == "few" then
      ep_along = map / MAP_NUM
    end

    local ep_info = DOOM2_EPISODES["episode" .. episode]
    assert(ep_info)
    assert(ep_along <= 1)

    local LEV =
    {
      name  = string.format("MAP%02d", map),
      patch = string.format("CWILV%02d", map-1),

      episode  = episode,
      ep_along = ep_along,
      ep_info  = ep_info,

      theme_ref = "TECH",
      name_theme = "TECH",

      key_list = { "kc_red", "kc_blue", "kc_yellow" },
      switch_list = { "sw_blue", "sw_hot", "sw_marble", "sw_wood" },
      bar_list = { "bar_wood", "bar_silver", "bar_metal" },

      style = {},
    }

    -- secret levels
    if map == 31 or map == 32 then
      LEV.theme_ref = "WOLF"
    end

    if map == 23 then
      LEV.style.barrels = "heaps"
    end

    if map == 7 then
      LEV.build_func = Arena_Doom_MAP07
    elseif map == 17 then  -- 16..18
      -- FIXME
    elseif map == 24 then  -- or 25
      -- FIXME
    elseif map == 30 then
      LEV.build_func = Arena_Doom_MAP30
    end

    if LEV.build_func then
      LEV.name_theme = "BOSS"
    end

    table.insert(GAME.all_levels, LEV)
  end
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

  -- patches (CEMENT1 .. CEMENT4)
  gui.wad_logo_gfx("WALL52_1", "p", "PILL",   128,128, 1)
  gui.wad_logo_gfx("WALL53_1", "p", "BOLT",   128,128, 2)
  gui.wad_logo_gfx("WALL55_1", "p", "RELIEF", 128,128, 3)
  gui.wad_logo_gfx("WALL54_1", "p", "CARVE",  128,128, 4)

  -- flats
  gui.wad_logo_gfx("O_PILL",   "f", "PILL",   64,64, 1)
  gui.wad_logo_gfx("O_BOLT",   "f", "BOLT",   64,64, 2)
  gui.wad_logo_gfx("O_RELIEF", "f", "RELIEF", 64,64, 3)
  gui.wad_logo_gfx("O_CARVE",  "f", "CARVE",  64,64, 4)
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

function Doom_begin_level()
  -- set the description here
  if not LEVEL.description and LEVEL.name_theme then
    LEVEL.description = Naming_grab_one(LEVEL.name_theme)
  end
end

function Doom_end_level()
gui.printf("Doom_end_level: desc=%s patch=%s\n",
           tostring(LEVEL.description),
           tostring(LEVEL.patch))
  if LEVEL.description and LEVEL.patch then
    Doom_make_level_gfx()
  end
end

function Doom_all_done()
  Doom_make_cool_gfx()
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

  priority = 98, -- keep at second spot

  setup_func        = Doom1_setup,
  levels_start_func = Doom1_get_levels,

  begin_level_func  = Doom_begin_level,
  end_level_func    = Doom_end_level,
  all_done_func     = Doom_all_done,

  param =
  {
    format = "doom",

    rails = true,
    switches = true,
    liquids = true,
    teleporters = true,
    infighting = true,

    pack_sidedefs = true,
    custom_flats = true,

    seed_size = 256,

    max_name_length = 28,

    skip_monsters = { 26,40 },

    mon_time_max = 12,

    mon_damage_max  = 200,
    mon_damage_high = 100,
    mon_damage_low  =   1,

    ammo_factor   = 0.8,
    health_factor = 0.7,
  },

  tables =
  {
    ---- common stuff ----

    "player_model", COMMON_PLAYER_MODEL,

    "things",   COMMON_THINGS,
    "monsters", COMMON_MONSTERS,
    "weapons",  COMMON_WEAPONS,
    "pickups",  COMMON_PICKUPS,

    "materials",  COMMON_MATERIALS,
    "rails",      COMMON_RAILS,
    "sanity_map", COMMON_SANITY_MAP,

    "combos", COMMON_COMBOS,
    "exits", COMMON_EXITS,
    "hallways",  COMMON_HALLWAYS,

    "hangs", COMMON_OVERHANGS,
    "pedestals", COMMON_PEDESTALS,
    "crates", COMMON_CRATES,

    "liquids", COMMON_LIQUIDS,
    "doors", COMMON_DOORS,
    "lifts", COMMON_LIFTS,

    "switch_infos", COMMON_SWITCH_INFOS,
    "switch_doors", COMMON_SWITCH_DOORS,
    "key_doors", COMMON_KEY_DOORS,

    "images", COMMON_IMAGES,
    "lights", COMMON_LIGHTS,
    "rooms",  COMMON_ROOMS,
    "themes", COMMON_THEMES,

    "sc_fabs",   COMMON_SCENERY_PREFABS,
    "feat_fabs", COMMON_FEATURE_PREFABS,
    "wall_fabs", COMMON_WALL_PREFABS,

    "door_fabs", COMMON_DOOR_PREFABS,
    "arch_fabs", COMMON_ARCH_PREFABS,
    "win_fabs",  COMMON_WINDOW_PREFABS,
    "misc_fabs", COMMON_MISC_PREFABS,

    ---- DOOM I stuff ----

    "episodes",  DOOM1_EPISODES,
    "rooms",     DOOM1_ROOMS,

    "materials", DOOM1_MATERIALS,
    "rails",     DOOM1_RAILS,
    "combos",    DOOM1_COMBOS,
    "exits",     DOOM1_EXITS,
    "hallways",  DOOM1_HALLWAYS,
    "crates",    DOOM1_CRATES,
    "wall_fabs", DOOM1_WALL_PREFABS,
  },
}

------------------------------------------------------------

OB_GAMES["doom2"] =
{
  label = "Doom 2",

  priority = 99, -- keep at top

  setup_func        = Doom2_setup,
  levels_start_func = Doom2_get_levels,

  begin_level_func  = Doom_begin_level,
  end_level_func    = Doom_end_level,
  all_done_func     = Doom_all_done,

  param =
  {
    format = "doom",

    rails = true,
    switches = true,
    liquids = true,
    teleporters = true,
    infighting = true,

    pack_sidedefs = true,
    custom_flats = true,

    seed_size = 256,

    -- this is roughly how many characters can fit on the
    -- intermission screens (the CWILVxx patches).  It does
    -- not reflect any buffer limits in Doom ports.
    max_name_length = 28,

    skip_monsters = { 30,44 },

    mon_time_max = 12,

    mon_damage_max  = 200,
    mon_damage_high = 100,
    mon_damage_low  =   1,

    ammo_factor   = 0.8,
    health_factor = 0.7,
  },

  tables =
  {
    ---- common stuff ----

    "player_model", COMMON_PLAYER_MODEL,

    "things",   COMMON_THINGS,
    "monsters", COMMON_MONSTERS,
    "weapons",  COMMON_WEAPONS,
    "pickups",  COMMON_PICKUPS,

    "materials",  COMMON_MATERIALS,
    "rails",      COMMON_RAILS,
    "sanity_map", COMMON_SANITY_MAP,

    "combos", COMMON_COMBOS,
    "exits", COMMON_EXITS,
    "hallways",  COMMON_HALLWAYS,

    "hangs", COMMON_OVERHANGS,
    "pedestals", COMMON_PEDESTALS,
    "crates", COMMON_CRATES,

    "liquids", COMMON_LIQUIDS,
    "doors", COMMON_DOORS,
    "lifts", COMMON_LIFTS,

    "switch_infos", COMMON_SWITCH_INFOS,
    "switch_doors", COMMON_SWITCH_DOORS,
    "key_doors", COMMON_KEY_DOORS,

    "images", COMMON_IMAGES,
    "lights", COMMON_LIGHTS,
    "rooms",  COMMON_ROOMS,
    "themes", COMMON_THEMES,

    "sc_fabs",   COMMON_SCENERY_PREFABS,
    "feat_fabs", COMMON_FEATURE_PREFABS,
    "wall_fabs", COMMON_WALL_PREFABS,

    "door_fabs", COMMON_DOOR_PREFABS,
    "arch_fabs", COMMON_ARCH_PREFABS,
    "win_fabs",  COMMON_WINDOW_PREFABS,
    "misc_fabs", COMMON_MISC_PREFABS,

    ---- DOOM II stuff ----

    "episodes", DOOM2_EPISODES,

    "monsters", DOOM2_MONSTERS,
    "weapons",  DOOM2_WEAPONS,
    "pickups",  DOOM2_PICKUPS,

    "themes",   DOOM2_THEMES,
    "rooms",    DOOM2_ROOMS,

    "materials",DOOM2_MATERIALS,
    "rails",    DOOM2_RAILS,
    "combos",   DOOM2_COMBOS,
    "hallways", DOOM2_HALLWAYS,
    "exits",    DOOM2_EXITS,

    "hangs",    DOOM2_OVERHANGS,
    "crates",   DOOM2_CRATES,
    "doors",    DOOM2_DOORS,
    "lights",   DOOM2_LIGHTS,
    "liquids",  DOOM2_LIQUIDS,

    "sc_fabs",   DOOM2_SCENERY_PREFABS,
    "feat_fabs", DOOM2_FEATURE_PREFABS,
    "wall_fabs", DOOM2_WALL_PREFABS,
    "door_fabs", DOOM2_DOOR_PREFABS,
    "misc_fabs", DOOM2_MISC_PREFABS,
  },
}

