----------------------------------------------------------------
--  GAME DEFINITION : DOOM I and II
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2010 Andrew Apted
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

DOOM  = { }  -- common stuff

DOOM1 = { }  -- stuff specific to each game
DOOM2 = { }  --


DOOM.ENTITIES =
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

} -- end of DOOM.ENTITIES


DOOM.PARAMETERS =
{
  rails = true,
  switches = true,
  liquids = true,
  teleporters = true,
  infighting = true,
  raising_start = true,

  custom_flats = true,

  -- this is roughly how many characters can fit on the
  -- intermission screens (the CWILVxx patches).  It does
  -- not reflect any buffer limits in Doom ports.
  max_name_length = 28,

  skip_monsters = { 26,40 },

  time_factor   = 1.0,
  damage_factor = 1.0,
  ammo_factor   = 0.8,
  health_factor = 0.7,
}

DOOM2.PARAMETERS =
{
  doom2_monsters = true,
  doom2_weapons  = true,
  doom2_skies    = true,  -- RSKY# patches

  skip_monsters = { 30,44 },
}


----------------------------------------------------------------


DOOM.MATERIALS =
{
  -- special materials --
  _ERROR = { t="METAL",    f="CEIL5_2" },
  _SKY   = { t="CEMENT3",  f="F_SKY1" },

  -- textures with best-matching flat

  BIGDOOR1 = { t="BIGDOOR1", f="FLAT23" },
  BIGDOOR2 = { t="BIGDOOR2", f="FLAT1" },
  BIGDOOR3 = { t="BIGDOOR3", f="FLOOR7_2" },
  BIGDOOR4 = { t="BIGDOOR4", f="FLOOR3_3" },
  BIGDOOR5 = { t="BIGDOOR5", f="FLAT5_2" },
  BIGDOOR6 = { t="BIGDOOR6", f="CEIL5_2" },
  BIGDOOR7 = { t="BIGDOOR7", f="CEIL5_2" },

  BROWN1   = { t="BROWN1",   f="FLOOR0_1" },
  BROWN144 = { t="BROWN144", f="FLOOR7_1" },
  BROWN96  = { t="BROWN96",  f="FLOOR7_1" },
  BROWNHUG = { t="BROWNHUG", f="FLOOR7_1" },
  BROWNPIP = { t="BROWNPIP", f="FLOOR0_1" },
  BROWNGRN = { t="BROWNGRN", f="FLOOR7_1" },  -- poor match
  BROVINE2 = { t="BROVINE2", f="FLOOR7_1" },  -- poor match
  BRNPOIS  = { t="BRNPOIS",  f="FLOOR7_1" },  -- poor match

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

  FIREBLU1 = { t="FIREBLU1", f="FLOOR6_1" }, -- poor match
  FIRELAVA = { t="FIRELAVA", f="FLOOR6_1" }, -- poor match
  FIREWALL = { t="FIREWALL", f="FLAT5_3" },
  GRAY1    = { t="GRAY1",    f="FLAT18" },
  GRAY2    = { t="GRAY2",    f="FLAT18" },
  GRAY4    = { t="GRAY4",    f="FLAT18" },
  GRAY5    = { t="GRAY5",    f="FLAT18" },
  GRAY7    = { t="GRAY7",    f="FLAT18" },  
  GRAYBIG  = { t="GRAYBIG",  f="FLAT18" },
  GRAYPOIS = { t="GRAYPOIS", f="FLAT18" },
  GRAYTALL = { t="GRAYTALL", f="FLAT18" },
  GRAYVINE = { t="GRAYVINE", f="FLAT1"  },

  GSTFONT1 = { t="GSTFONT1", f="FLOOR7_2" },
  GSTGARG  = { t="GSTGARG",  f="FLOOR7_2" },
  GSTLION  = { t="GSTLION",  f="FLOOR7_2" },
  GSTONE1  = { t="GSTONE1",  f="FLOOR7_2" },
  GSTONE2  = { t="GSTONE2",  f="FLOOR7_2" },
  GSTSATYR = { t="GSTSATYR", f="FLOOR7_2" },
  GSTVINE1 = { t="GSTVINE1", f="FLOOR7_2" },
  GSTVINE2 = { t="GSTVINE2", f="FLOOR7_2" },

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
  ROCKRED1 = { t="ROCKRED1", f="FLOOR6_1" },
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
  SLADPOIS = { t="SLADPOIS", f="FLOOR7_1" },  -- poor match
  SLADSKUL = { t="SLADSKUL", f="FLOOR7_1" },  -- poor match
  SLADWALL = { t="SLADWALL", f="FLOOR7_1" },  -- poor match
  SP_DUDE1 = { t="SP_DUDE1", f="DEM1_5" },
  SP_DUDE2 = { t="SP_DUDE2", f="DEM1_5" },
  SP_DUDE4 = { t="SP_DUDE4", f="DEM1_5" },
  SP_DUDE5 = { t="SP_DUDE5", f="DEM1_5" },
  SP_FACE1 = { t="SP_FACE1", f="CRATOP2" },
  SP_HOT1  = { t="SP_HOT1",  f="FLAT5_3" },
  SP_ROCK1 = { t="SP_ROCK1", f="MFLR8_3" },  -- poor match

  STARG1   = { t="STARG1",   f="FLAT23" },  -- poor match
  STARG2   = { t="STARG2",   f="FLAT23" },  -- poor match
  STARG3   = { t="STARG3",   f="FLAT23" },  -- poor match
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

  STONE    = { t="STONE",    f="FLAT5_4" },
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
  SW1BRNGN = { t="SW1BRNGN", f="FLOOR7_1" }, -- poor match
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
  SW1SLAD  = { t="SW1SLAD",  f="FLOOR7_1" },  -- poor match
  SW1STON1 = { t="SW1STON1", f="MFLR8_1" },
  SW1STRTN = { t="SW1STRTN", f="FLOOR4_1" },
  SW1VINE  = { t="SW1VINE",  f="FLAT1" },
  SW1WOOD  = { t="SW1WOOD",  f="FLAT5_2" },
  

  -- flats with closest texture

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
  FLAT5_6  = { t="CRACKLE4", f="FLAT5_6" },
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

  GATE1    = { t="METAL",    f="GATE1" },
  GATE2    = { t="METAL",    f="GATE2" },
  GATE3    = { t="METAL",    f="GATE3" },
  GATE4    = { t="METAL",    f="GATE4" },
  MFLR8_1  = { t="STONE2",   f="MFLR8_1" },
  MFLR8_2  = { t="BROWNHUG", f="MFLR8_2" },
  MFLR8_3  = { t="SP_ROCK1", f="MFLR8_3" },  -- poor match
  SFLR6_1  = { t="SKSNAKE1", f="SFLR6_1" },
  SFLR6_4  = { t="SKSNAKE2", f="SFLR6_4" },
  SFLR7_1  = { t="SKSNAKE1", f="SFLR7_1" },
  SFLR7_4  = { t="SKSNAKE1", f="SFLR7_4" },
  STEP_F1  = { t="SHAWN2",   f="STEP1" },
  STEP_F2  = { t="SHAWN2",   f="STEP2" },
  TLITE6_1 = { t="METAL",    f="TLITE6_1" },
  TLITE6_4 = { t="METAL",    f="TLITE6_4" },
  TLITE6_5 = { t="METAL",    f="TLITE6_5" },
  TLITE6_6 = { t="METAL",    f="TLITE6_6" },


  -- liquid stuff (using new patches)
  WFALL1   = { t="GSTFONT1", f="FWATER1" },
  FWATER1  = { t="GSTFONT1", f="FWATER1" },

  LFALL1   = { t="FIREMAG1", f="LAVA1" },
  LAVA1    = { t="FIREMAG1", f="LAVA1" },


  -- Oblige stuff
  O_PILL   = { t="CEMENT1",  f="O_PILL" },
  O_BOLT   = { t="CEMENT2",  f="O_BOLT" },
  O_RELIEF = { t="CEMENT3",  f="O_RELIEF" },
  O_CARVE  = { t="CEMENT4",  f="O_CARVE" },
  O_NEON   = { t="CEMENT6",  f="CEIL5_1" },


  -- Missing stuff:
  --   CEMENT#  : used by OBLIGE for various logos
  --   SKY1/2/3 : not very useful
  --   ZZZFACE# : not generally useful
  --
  -- Mid-masked (railing) textures are in separate tables.
  --
  -- Note too that STEP1/2 are ambiguous, the flats are quite
  -- different to the textures, hence renamed the flats as
  -- STEP_F1 and STEP_F2.

} -- end of DOOM.MATERIALS



DOOM1.MATERIALS =
{
  -- textures with best-matching flat

  ASHWALL  = { t="ASHWALL",  f="FLOOR6_2" },
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

  NUKESLAD = { t="NUKESLAD", f="FLOOR7_1" },  -- poor match
  PLANET1  = { t="PLANET1",  f="FLAT23" },
  REDWALL1 = { t="REDWALL1", f="FLOOR1_6" },
  SKINBORD = { t="SKINBORD", f="FLAT5_5" },
  SKINTEK1 = { t="SKINTEK1", f="FLAT5_5" },  -- poor match
  SKINTEK2 = { t="SKINTEK2", f="FLAT5_5" },  -- poor match
  SKULWAL3 = { t="SKULWAL3", f="FLAT5_6" },
  SKULWALL = { t="SKULWALL", f="FLAT5_6" },
  SLADRIP1 = { t="SLADRIP1", f="FLOOR7_1" },  -- poor match
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

  SW1BRN1  = { t="SW1BRN1",  f="FLOOR0_1" },
  SW1STARG = { t="SW1STARG", f="FLAT23" },
  SW1STONE = { t="SW1STONE", f="FLAT1" },
  SW1STON2 = { t="SW1STON2", f="MFLR8_1" },

  -- flats with closest texture

  FLAT5_6  = { t="SKULWALL", f="FLAT5_6" },
  FLAT5_7  = { t="ASHWALL",  f="FLAT5_7" },
  FLAT5_8  = { t="ASHWALL",  f="FLAT5_8" },
  FLOOR6_2 = { t="ASHWALL",  f="FLOOR6_2" },
  MFLR8_4  = { t="ASHWALL",  f="MFLR8_4" },


  -- FIXME: HACK HACK HACK
  BRICKLIT = { t="LITEMET",  f="CEIL5_1" },
  PIPEWAL1 = { t="COMPWERD", f="CEIL5_1" },


  -- liquid stuff (using new patches)
  BFALL1   = { t="BLODGR1",  f="BLOOD1" },
  BLOOD1   = { t="BLODGR1",  f="BLOOD1" },

  SFALL1   = { t="SLADRIP1", f="NUKAGE1" },
  NUKAGE1  = { t="SLADRIP1", f="NUKAGE1" },

}



DOOM2.MATERIALS =
{
  -- textures with best-matching flat

  ASHWALL  = { t="ASHWALL2", f="MFLR8_4" },  -- compatibility name
  ASHWALL3 = { t="ASHWALL3", f="FLAT10" },
  ASHWALL4 = { t="ASHWALL4", f="FLAT10" },
  ASHWALL6 = { t="ASHWALL6", f="RROCK20" },
  ASHWALL7 = { t="ASHWALL7", f="RROCK18" },
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
  BRICK12  = { t="BRICK12",  f="FLOOR0_1" },  -- poor match
  BRONZE1  = { t="BRONZE1",  f="FLOOR7_1" },
  BRONZE2  = { t="BRONZE2",  f="FLOOR7_1" },
  BRONZE3  = { t="BRONZE3",  f="FLOOR7_1" },
  BRONZE4  = { t="BRONZE4",  f="FLOOR7_1" },
  BRICKLIT = { t="BRICKLIT", f="RROCK10" },
  BRWINDOW = { t="BRWINDOW", f="RROCK10" },
  BSTONE1  = { t="BSTONE1",  f="RROCK11" },
  BSTONE2  = { t="BSTONE2",  f="RROCK12" },
  BSTONE3  = { t="BSTONE3",  f="RROCK12" },

  CEMENT9  = { t="CEMENT9",  f="FLAT19" },  -- poor match
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
  ROCK4    = { t="ROCK4",    f="FLOOR0_2" }, -- poor match
  ROCK5    = { t="ROCK5",    f="RROCK09" },

  SILVER1  = { t="SILVER1",  f="FLAT23" },
  SILVER2  = { t="SILVER2",  f="FLAT22" },
  SILVER3  = { t="SILVER3",  f="FLAT23" },
  SK_LEFT  = { t="SK_LEFT",  f="FLAT5_6" },  -- poor match
  SK_RIGHT = { t="SK_RIGHT", f="FLAT5_6" },  -- poor match
  SLOPPY1  = { t="SLOPPY1",  f="FLAT5_6" },  -- poor match
  SLOPPY2  = { t="SLOPPY2",  f="FLAT5_6" },  -- poor match
  SP_DUDE7 = { t="SP_DUDE7", f="FLOOR5_4" },
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

  SLIME09  = { t="ROCKRED1", f="SLIME09" },  -- poor match
  SLIME13  = { t="BRICK10",  f="SLIME13" },
  SLIME14  = { t="METAL2",   f="SLIME14" },  -- poor match
  SLIME15  = { t="COMPSPAN", f="SLIME15" },  -- poor match
  SLIME16  = { t="SPACEW4",  f="SLIME16" },


  -- liquid stuff
  BFALL1   = { t="BFALL1",  f="BLOOD1" },
  BLOOD1   = { t="BFALL1",  f="BLOOD1" },

  SFALL1   = { t="SFALL1",  f="NUKAGE1" },
  NUKAGE1  = { t="SFALL1",  f="NUKAGE1" },

  KFALL1   = { t="BLODRIP1", f="SLIME01" },  -- new patches
  KFALL5   = { t="BLODRIP1", f="SLIME05" },
  SLIME01  = { t="BLODRIP1", f="SLIME01" },
  SLIME05  = { t="BLODRIP1", f="SLIME05" },
}


DOOM.SANITY_MAP =
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


DOOM.RAILS =
{
  -- common --

  BRNSMAL1 = { t="BRNSMAL1", h=64,  line_flags=1 },
  BRNSMAL2 = { t="BRNSMAL2", h=64,  line_flags=1 },
  BRNSMALC = { t="BRNSMALC", h=64,  line_flags=1 },

  MIDBRN1  = { t="MIDBRN1",  h=128, line_flags=1 },
  MIDGRATE = { t="MIDGRATE", h=128, line_flags=1 },

  -- Doom I only --

  BRNBIGC  = { t="BRNBIGC",  h=128, line_flags=1 },

  MIDVINE1 = { t="MIDVINE1", h=128 },
  MIDVINE2 = { t="MIDVINE2", h=128 },

  -- Doom II only --

  MIDBARS1 = { t="MIDBARS1", h=128, line_flags=1 },
  MIDBARS3 = { t="MIDBARS3", h=72,  line_flags=1 },
  MIDBRONZ = { t="MIDBRONZ", h=128, line_flags=1 },
  MIDSPACE = { t="MIDSPACE", h=128, line_flags=1 },

  -- scaled MIDVINE2 from FreeDoom
  FMIDVINE = { t="SP_DUDE8", h=128 },
}


DOOM.STEPS =
{
  step1 = { step="STEP1", side="BROWNHUG", top="FLOOR7_1" },
  step2 = { step="STEP2", side="BROWN1",   top="FLAT5" },
  step3 = { step="STEP3", side="COMPSPAN", top="CEIL5_1" },
  step4 = { step="STEP4", side="STONE",    top="FLAT5_4" },

  -- Doom II only --
  step4b = { step="STEP4", side="STONE4",   top="FLAT1" },
  step6  = { step="STEP6", side="STUCCO",   top="FLAT5" },
}


DOOM.LIFTS =
{
  shiny = 
  {
    lift="SUPPORT2", top="FLAT20",
    walk_kind=88, switch_kind=62,
  },

  rusty = 
  {
    lift="SUPPORT3", top="CEIL5_2",
    walk_kind=88, switch_kind=62,
  },

  platform = 
  {
    lift="PLAT1", top="FLAT23",
    walk_kind=88, switch_kind=62,
  },

  spine = 
  {
    lift="SKSPINE1", top="FLAT23",
    walk_kind=88, switch_kind=62,
  },
}

OLD_LIFT_JUNK =
{
  slow = { kind=62,  walk=88  },
  fast = { kind=123, walk=120 },
}


DOOM.PICTURES =
{
  -- Note: this includes pictures that only work on DOOM1 or DOOM2.
  -- It is not a problem, because the game-specific sub-themes will
  -- only reference the appropriate entries.

  compsta1 =
  {
    pic="COMPSTA1", width=128, height=52,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8,
  },

  compsta2 =
  {
    pic="COMPSTA2", width=128, height=52,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8,
  },

  compsta1_blink =
  {
    pic="COMPSTA1", width=128, height=52,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8, sec_kind=1,
  },

  compsta2_blink =
  {
    pic="COMPSTA2", width=128, height=52,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8, sec_kind=1,
  },

  lite5 =
  {
    count=3, gap=32,
    pic="LITE5", width=16, height=64,
    x_offset=0, y_offset=0,
    side="DOORSTOP", floor="SHAWN2", depth=8, 
    light=0.9, sec_kind=8,  -- oscillate
  },

  lite5_05blink =
  {
    count=3, gap=32,
    pic="LITE5", width=16, height=64,
    x_offset=0, y_offset=0,
    side="DOORSTOP", floor="SHAWN2", depth=8, 
    light=0.9, sec_kind=12,  -- 0.5 second sync
  },

  lite5_10blink =
  {
    count=4, gap=24,
    pic="LITE5", width=16, height=48,
    x_offset=0, y_offset=0,
    side="DOORSTOP", floor="SHAWN2", depth=8, 
    light=0.9, sec_kind=13,  -- 1.0 second sync
  },

  liteblu4 =
  {
    count=3, gap=32,
    pic="LITEBLU4", width=16, height=64,
    x_offset=0, y_offset=0,
    side="LITEBLU4", floor="FLAT14", depth=8, 
    light=0.9, sec_kind=8,
  },

  liteblu4_05sync =
  {
    count=3, gap=32,
    pic="LITEBLU4", width=16, height=64,
    x_offset=0, y_offset=0,
    side="LITEBLU4", floor="FLAT14", depth=8, 
    light=0.9, sec_kind=12,
  },

  liteblu4_10sync =
  {
    count=4, gap=32,
    pic="LITEBLU4", width=16, height=48,
    x_offset=0, y_offset=0,
    side="LITEBLU4", floor="FLAT14", depth=8, 
    light=0.9, sec_kind=13,
  },

  litered =
  {
    count=3, gap=32,
    pic="LITERED", width=16, height=64,
    x_offset=0, y_offset=0,
    side="DOORSTOP", floor="SHAWN2", depth=16, 
    light=0.9, sec_kind=8,  -- oscillate
  },

  redwall =
  {
    count=2, gap=48,
    pic="REDWALL", width=16, height=128, raise=20,
    x_offset=0, y_offset=0,
    side="REDWALL", floor="FLAT5_3", depth=8, 
    light=0.99, sec_kind=8,
  },

  silver3 =
  {
    count=1, gap=32,
    pic="SILVER3", width=64, height=96,
    x_offset=0, y_offset=16,
    side="DOORSTOP", floor="SHAWN2", depth=8, 
    light=0.8,
  },

  shawn1 =
  {
    count=1,
    pic="SHAWN1", width=128, height=72,
    x_offset=-4, y_offset=0,
    side="DOORSTOP", floor="SHAWN2", depth=8, 
  },

  pill =
  {
    count=1,
    pic="O_PILL", width=128, height=32, raise=16,
    x_offset=0, y_offset=0,
    side="METAL", floor="CEIL5_2", depth=8, 
    light=0.7,
  },

  carve =
  {
    count=1,
    pic="O_CARVE", width=64, height=64,
    x_offset=0, y_offset=0,
    side="METAL", floor="CEIL5_2", depth=8, 
    light=0.7,
  },

  neon =
  {
    count=1,
    pic="O_NEON", width=128, height=128,
    x_offset=0, y_offset=0,
    side="METAL", floor="CEIL5_2", depth=16, 
    light=0.99, sec_kind=8,
  },

  tekwall1 =
  {
    count=1,
    pic="TEKWALL1", width=160, height=80,
    x_offset=0, y_offset=24,
    side="METAL", floor="CEIL5_2", depth=8, 
    line_kind=48, -- scroll left
    light=0.7,
  },

  tekwall4 =
  {
    count=1,
    pic="TEKWALL4", width=128, height=80,
    x_offset=0, y_offset=24,
    side="METAL", floor="CEIL5_2", depth=8, 
    line_kind=48, -- scroll left
    light=0.7,
  },

  pois1 =
  {
    count=2, gap=32,
    pic="BRNPOIS", width=64, height=56,
    x_offset=0, y_offset=48,
    side="METAL", floor="CEIL5_2",
    depth=8, light=0.5,
  },

  pois2 =
  {
    count=1, gap=32,
    pic="GRAYPOIS", width=64, height=64,
    x_offset=0, y_offset=0,
    side="DOORSTOP", floor="SHAWN2",
    depth=8, light=0.5,
  },

  eagle1 =
  {
    count=1,
    pic="ZZWOLF6", width=128, height=128,
    x_offset=0, y_offset=0,
    side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.57,
  },

  hitler1 =
  {
    count=1,
    pic="ZZWOLF7", width=128, height=128,
    x_offset=0, y_offset=0,
    side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.57,
  },

  marbface =
  {
    count=1,
    pic="MARBFACE", width=128, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.57,
  },

  marbfac2 =
  {
    count=1,
    pic="MARBFAC2", width=128, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.57,
  },

  marbfac3 =
  {
    count=1,
    pic="MARBFAC3", width=128, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.57,
  },

  skinface =
  {
    count=1,
    pic="SKINFACE", width=160, height=80,
    x_offset=0, y_offset=24,
    -- side="METAL", floor="CEIL5_2",
    depth=8, 
    line_kind=48, -- scroll left
    light=0.7,
  },

  spface1 =
  {
    count=1,
    pic="SP_FACE1", width=160, height=96,
    x_offset=0, y_offset=0,
    -- side="METAL", floor="CEIL5_2",
    depth=8, 
    line_kind=48, -- scroll left
    light=0.7,
  },

  firewall =
  {
    count=1,
    pic="FIREWALL", width=128, height=112,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.9,
  },

  planet1 =
  {
    pic="PLANET1", width=192, height=128,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8,
  },

  planet1_blink =
  {
    pic="PLANET1", width=192, height=128,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8, sec_kind=1,
  },

  compute1 =
  {
    pic="COMPUTE1", width=128, height=128,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8,
  },

  compute1_blink =
  {
    pic="COMPUTE1", width=128, height=128,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8, sec_kind=1,
  },

  compute2 =
  {
    pic="COMPUTE2", width=192, height=56,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8,
  },

  compute2_blink =
  {
    pic="COMPUTE2", width=192, height=56,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8, sec_kind=1,
  },

  skulls1 =
  {
    count=1,
    pic="SKULWALL", width=128, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.67,
  },

  skulls2 =
  {
    count=1,
    pic="SKULWAL3", width=128, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.67,
  },

  spacewall =
  {
    pic="SPACEW3", width=64, height=128,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8,
  },

  spdude1 =
  {
    count=1,
    pic="SP_DUDE1", width=128, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.67,
  },

  spdude2 =
  {
    count=1,
    pic="SP_DUDE2", width=128, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.67,
  },

  spdude3 =
  {
    count=1,
    pic="SP_DUDE3", width=64, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.67,
  },

  spdude4 =
  {
    count=1,
    pic="SP_DUDE4", width=64, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.67,
  },

  spdude5 =
  {
    count=1,
    pic="SP_DUDE5", width=64, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.67,
  },

  spdude6 =
  {
    count=1,
    pic="SP_DUDE6", width=64, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.67,
  },

  spdude7 =
  {
    count=1,
    pic="SP_DUDE7", width=128, height=128,
    x_offset=0, y_offset=0,
    side="METAL", floor="RROCK03",
    depth=8, light=0.67,
  },

  spine =
  {
    count=1,
    pic="SKSPINE2", width=160, height=70,
    x_offset=0, y_offset=24,
    -- side="METAL", floor="CEIL5_2",
    depth=8, 
    line_kind=48, -- scroll left
    light=0.7,
  },

}


DOOM.PILLARS =
{
  teklite = { pillar="TEKLITE", trim1="GRAY7", trim2="METAL" },
  silver2 = { pillar="SILVER2", trim1="GRAY7", trim2="METAL" },
  shawn2  = { pillar="SHAWN2",  trim1="STARGR1", trim2="TEKWALL1" },

  big_red  = { pillar="REDWALL",  trim1="GRAY7", trim2="METAL" },
  big_blue = { pillar="LITEBLU4", trim1="GRAY7", trim2="METAL" },

  tekwall4 = { pillar="TEKWALL4", trim1="GRAY7", trim2="METAL1" },
  metal1   = { pillar="METAL1",   trim1="GRAY7", trim2="METAL" },
  blue1    = { pillar="COMPBLUE", trim1="SHAWN2", trim2="TEKWALL1" },

  marble1 = { pillar="MARBLE1",  trim1="GSTONE1", trim2="MARBLE2" },
  redwall = { pillar="REDWALL",  trim1="SP_HOT1", trim2="SP_HOT1" },
  sloppy  = { pillar="SLOPPY1",  trim1="MARBLE1", trim2="METAL" },
  sloppy2 = { pillar="SP_FACE2", trim1="MARBLE1", trim2="METAL" },
}


DOOM.CRATES =
{
  crate1 = { crate="CRATE1", x_offset=0, y_offset=0 },
  crate2 = { crate="CRATE2", x_offset=0, y_offset=0 },
  
  space = { crate="SPACEW3",  x_offset=0, y_offset=0 },
  comp  = { crate="COMPWERD", x_offset=0, y_offset=0 },
  mod   = { crate="MODWALL3", x_offset=0, y_offset=0 },
  lite5 = { crate="LITE5",    x_offset=0, y_offset=0 },

  wood = { crate="WOOD3",    x_offset=0, y_offset=0 },
  ick  = { crate="ICKWALL4", x_offset=0, y_offset=0 },
}


DOOM.DOORS =
{
  --- NORMAL DOORS ---

  silver =
  {
    w=128, h=112, door_h=72,
    key="LITE3",
    door="BIGDOOR1", door_c="FLAT1",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    line_kind=1, tag=0,
  },

  silver_fast =
  {
    w=128, h=112, door_h=72,
    key="LITE3",
    door="BIGDOOR1", door_c="FLAT1",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    line_kind=117, tag=0,
  },

  silver_once =
  {
    w=128, h=112, door_h=72,
    key="LITE3",
    door="BIGDOOR1", door_c="FLAT1",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    line_kind=31, tag=0,
  },

  wooden =
  {
    w=128, h=112, door_h=112,
    door="BIGDOOR6", door_c="FLAT5_2",
    step="STEP1",
    frame="FLAT1",
    track="DOORTRAK",
    key="BRICKLIT", key_ox=20, key_oy=-16,
    line_kind=1, tag=0,
  },

  wooden2 =
  {
    w=128, h=112, door_h=112,
    door="BIGDOOR5", door_c="FLAT5_2",
    step="STEP1",
    frame="FLAT1",
    track="DOORTRAK",
    key="BRICKLIT", key_ox=20, key_oy=-16,
    line_kind=1, tag=0,
  },

  wooden_fast =
  {
    w=128, h=112, door_h=112,
    door="BIGDOOR6", door_c="FLAT5_2",
    step="STEP1",
    frame="FLAT1",
    track="DOORTRAK",
    key="BRICKLIT", key_ox=20, key_oy=-16,
    line_kind=117, tag=0,
  },

  wooden2_fast =
  {
    w=128, h=112, door_h=112,
    door="BIGDOOR5", door_c="FLAT5_2",
    step="STEP1",
    frame="FLAT1",
    track="DOORTRAK",
    key="BRICKLIT", key_ox=20, key_oy=-16,
    line_kind=117, tag=0,
  },

  wooden_once =
  {
    w=128, h=112, door_h=112,
    door="BIGDOOR6", door_c="FLAT5_2",
    step="STEP1",
    frame="FLAT1",
    track="DOORTRAK",
    key="BRICKLIT", key_ox=20, key_oy=-16,
    line_kind=31, tag=0,
  },

  wooden2_once =
  {
    w=128, h=112, door_h=112,
    door="BIGDOOR5", door_c="FLAT5_2",
    step="STEP1",
    frame="FLAT1",
    track="DOORTRAK",
    key="BRICKLIT", key_ox=20, key_oy=-16,
    line_kind=31, tag=0,
  },

  bigdoor2 =
  {
    w=128, h=112, door_h=112,
    key="LITE3",
    door="BIGDOOR2", door_c="FLAT23",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    line_kind=1, tag=0,
  },

  bigdoor2_fast =
  {
    w=128, h=112, door_h=112,
    key="LITE3",
    door="BIGDOOR2", door_c="FLAT23",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    line_kind=117, tag=0,
  },

  bigdoor2_once =
  {
    w=128, h=112, door_h=112,
    key="LITE3",
    door="BIGDOOR2", door_c="FLAT23",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    line_kind=31, tag=0,
  },

  bigdoor4 =
  {
    w=128, h=112, door_h=112,
    key="LITEBLU1", key_oy=56,
    door="BIGDOOR4", door_c="FLOOR7_1",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    line_kind=1, tag=0,
  },

  bigdoor4_fast =
  {
    w=128, h=112, door_h=112,
    key="LITEBLU1", key_oy=56,
    door="BIGDOOR4", door_c="FLOOR7_1",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    line_kind=117, tag=0,
  },

  bigdoor4_once =
  {
    w=128, h=112, door_h=112,
    key="LITEBLU1", key_oy=56,
    door="BIGDOOR4", door_c="FLOOR7_1",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    line_kind=31, tag=0,
  },

  bigdoor3 =
  {
    w=128, h=112, door_h=112,
    key="LITE3",
    door="BIGDOOR3", door_c="FLOOR7_2",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    line_kind=1, tag=0,
  },

  wolf_door =
  {
    w=128, h=112, door_h=128,
    key="DOORSTOP",
    door="ZDOORB1", door_c="FLAT23",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    line_kind=1, tag=0,
  },

  wolf_elev_door =
  {
    w=128, h=112, door_h=128,
    key="DOORSTOP",
    door="ZELDOOR", door_c="FLAT23",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    line_kind=1, tag=0,
  },


  --- LOCKED DOORS ---

  kc_blue =
  {
    w=128, h=112, door_h=112,
    key="DOORBLU",
    door="BIGDOOR3", door_c="FLOOR7_2",
    step="STEP4",
    track="DOORTRAK",
    frame="FLAT18",
    line_kind=32, tag=0,  -- kind_mult=26
  },

  kc_yellow =
  {
    w=128, h=112, door_h=112,
    key="DOORYEL",
    door="BIGDOOR4",  door_c="FLOOR3_3",
    step="STEP4",
    track="DOORTRAK",
    frame="FLAT4",
    line_kind=34, tag=0, -- kind_mult=27
  },

  kc_red =
  {
    w=128, h=112,

    key="DOORRED", door_h=112,
    door="BIGDOOR2", door_c="FLAT1",
    step="STEP4",
    track="DOORTRAK",
    frame="FLAT18",
    line_kind=33, tag=0, -- kind_mult=28
  },

  ks_blue =
  {
    w=128, h=112, door_h=112,
    key="DOORBLU2", key_ox=4, key_oy=-10,
    door="BIGDOOR7", door_c="FLOOR7_2",
    step="STEP4",
    track="DOORTRAK",
    frame="FLAT18",
    line_kind=32, tag=0,  -- kind_mult=26
  },

  ks_yellow =
  {
    w=128, h=112, door_h=112,
    key="DOORYEL2", key_ox=4, key_oy=-10,
    door="BIGDOOR7", door_c="FLOOR3_3",
    step="STEP4",
    track="DOORTRAK",
    frame="FLAT4",
    line_kind=34, tag=0, -- kind_mult=27
  },

  ks_red =
  {
    w=128, h=112, door_h=112,
    key="DOORRED2", key_ox=4, key_oy=-10,
    door="BIGDOOR7", door_c="FLAT1",
    step="STEP4",
    track="DOORTRAK",
    frame="FLAT18",
    line_kind=33, tag=0, -- kind_mult=28
  },


  --- SWITCHED DOORS ---

  sw_blue =
  {
    w=128, h=112,

    key="COMPBLUE",
    door="BIGDOOR3", door_c="FLOOR7_2",
    step="COMPBLUE",
    track="DOORTRAK",
    frame="FLAT14",
    door_h=112,
    line_kind=0,
  },

  sw_hot =
  {
    w=128, h=112,

    key="REDWALL",
    door="BIGDOOR2", door_c="FLAT1",
    step="REDWALL",
    track="DOORTRAK",
    frame="FLAT5_3",
    door_h=112,
    line_kind=0,
  },

  sw_skin =
  {
    w=128, h=112,

    key="SKINFACE",
    door="BIGDOOR4", door_c="FLOOR7_2",
    step="SKINFACE",
    track="DOORTRAK",
    frame="SKINFACE",
    door_h=112,
    line_kind=0,
  },

  sw_vine =
  {
    w=128, h=112,

    key="GRAYVINE",
    door="BIGDOOR4", door_c="FLOOR7_2",
    step="GRAYVINE",
    track="DOORTRAK",
    frame="FLAT1",
    door_h=112,
    line_kind=0,
  },

  sw_wood =
  {
    w=128, h=112,

    key="WOOD1",
    door="BIGDOOR7", door_c="CEIL5_2",
    step="WOOD1",
    track="DOORTRAK",
    frame="FLAT5_2",
    door_h=112,
    line_kind=0,
  },

  sw_marble =
  {
    w=128, h=112,

    key="GSTONE1",
    door="BIGDOOR2", door_c="FLAT1",
    step="GSTONE1",
    track="DOORTRAK",
    frame="FLOOR7_2",
    door_h=112,
    line_kind=0,
  },

  bar_wood =
  {
    bar_w="WOOD9",
    bar_f="FLAT5_2",
    bar_h=64,
    line_kind=0,
  },

  bar_silver =
  {
    bar_w="SUPPORT2",
    bar_h=64,
    line_kind=0,
  },

  bar_metal =
  {
    bar_w="SUPPORT3",
    bar_h=64,
    line_kind=0,
  },

  bar_gray =
  {
    bar_w="GRAY7", bar_f="FLAT19",
    bar_h=64,
    line_kind=0
  },
} -- end of DOOM.DOORS


DOOM.EXITS =
{
  skull_pillar =
  {
    h=128,
    switch="SW1SKULL",
    exit="EXITSIGN",
    exitside="COMPSPAN",
    line_kind=11,
  },

  demon_pillar2 =
  {
    h=128,
    switch="SW1SATYR",
    exit="EXITSIGN",
    exitside="COMPSPAN",
    line_kind=11,
  },

  demon_pillar3 =
  {
    h=128,
    switch="SW1LION",
    exit="EXITSIGN",
    exitside="COMPSPAN",
    line_kind=11,
  },

  skin_pillar =
  {
    h=128,
    switch="SW1SKIN",
    exit="EXITSIGN",
    exitside="COMPSPAN",
    line_kind=11,
  },

  stone_pillar =
  {
    h=128,
    switch="SW1STON1",
    exit="EXITSIGN",
    exitside="COMPSPAN",
    line_kind=11,
  },

  tech_outdoor =
  {
    podium="CEIL5_1", base="SHAWN2",
    switch="SW1COMM", exit="EXITSIGN",
    line_kind=11,
  },

  tech_outdoor2 =
  {
    podium="STARTAN2", base="SHAWN2",
    switch="SW2COMM", exit="EXITSIGN",
    line_kind=11,
  },

  tech_small =
  {
    door = "EXITDOOR", track = "DOORTRAK",
    exit = "EXITSIGN", exitside = "SHAWN2",
    key = "LITE5",
    track = "DOORSTOP", trim = "DOORSTOP",
    items = { "medikit" },
    door_kind=1, line_kind=11,

    switch = "SW1BRN2",
    floor = "FLOOR0_3", ceil="TLITE6_6",
  },

}


DOOM.SWITCHES =
{
  sw_blue =
  {
    prefab = "SWITCH_FLOOR",
    skin =
    {
      switch_h=64,
      switch="SW1BLUE", side="COMPBLUE", base="COMPBLUE",
      x_offset=0, y_offset=56,
      line_kind=103,
    }
  },

  sw_blue2 =  -- NOT USED
  {
    prefab = "SWITCH_FLOOR_BEAM",
    skin =
    {
      switch_h=64,
      switch_w="SW1BLUE", side_w="COMPBLUE",
      switch_f="FLAT14", switch_h=64,

      beam_w="WOOD1", beam_f="FLAT5_2",

      x_offset=0, y_offset=56,
      line_kind=103,
    }
  },

  sw_hot =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch_h=64,
      switch="SW1HOT", side="SP_HOT1", base="FLAT5_3",
      x_offset=0, y_offset=52,
      line_kind=103,
    }

  },

  sw_skin =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch_h=64,
      switch="SW1SKIN", side="SKSNAKE2", base="SFLR6_4",
      x_offset=0, y_offset=52,
      line_kind=103,
    }
  },

  sw_vine =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch_h=64,
      switch="SW1VINE", side="GRAYVINE", base="FLAT1",
      x_offset=0, y_offset=64,
      line_kind=103,
    }
  },

  sw_metl =  -- NOT USED
  {
    prefab = "SWITCH_CEILING",
    environment = "indoor",
    skin =
    {
      switch_h=56,
      switch_w="SW1GARG", side_w="METAL",
      switch_c="CEIL5_2",

      beam_w="SUPPORT3", beam_c="CEIL5_2",

      x_offset=0, y_offset=64,
      line_kind=23,
    }
  },

  sw_wood =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch_h=64,
      switch="SW1WOOD", side="WOOD1", base="FLAT5_2",
      x_offset=0, y_offset=56,
      line_kind=103,
    }
  },

  sw_marble =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch="SW1GSTON", side="GSTONE1", base="FLOOR7_2",
      x_offset=0, y_offset=56,
      line_kind=103,
    }
  },

  bar_wood =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch="SW1WOOD", side="WOOD9", base="FLAT5_2",
      x_offset=0, y_offset=56,
      line_kind=23,
    }
  },

  bar_silver =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch="SW1COMM", side="SHAWN2", base="FLAT23",
      x_offset=0, y_offset=0,
      line_kind=23,
    }
  },

  bar_metal =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch="SW1MET2", side="METAL2", base="CEIL5_2",
      x_offset=0, y_offset=0,
      line_kind=23,
    }
  },

  bar_gray =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch="SW1GRAY1", side="GRAY1", base="FLAT1",
      x_offset=0, y_offset=64,
      line_kind=23,
    }
  },

} -- end of DOOM.SWITCHES



DOOM.LIQUIDS =
{
  water  = { mat="FWATER1", light=0.65, sec_kind=16 },
  blood  = { mat="BLOOD1",  light=0.65, sec_kind=16 }, --  5% damage
  nukage = { mat="NUKAGE1", light=0.65, sec_kind=16 }, -- 10% damage
  lava   = { mat="LAVA1",   light=0.75, sec_kind=16 }, -- 20% damage

  -- Doom II only --
  slime = { mat="SLIME01", light=0.65, sec_kind=16 },
}


DOOM.ROOMS =
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

DOOM1.ROOMS =
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

DOOM2.ROOMS =
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
      wall_pic_SPDUDE7 = 30,

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


DOOM.SUB_THEME_DEFAULTS =
{
  doors = { wooden=30, wooden_fast=20,
            wooden2=20, wooden2_fast=10 },

  steps = { step1=50 },

  lifts = { shiny=20, platform=10, rusty=30 },

  outer_fences = { BROWN144=50, STONE2=30, BROWNHUG=10,
                   BROVINE2=10, GRAYVINE=10, ICKWALL3=2,
                   GRAY1=10, STONE=20,
                 },

  logos = { carve=50, pill=50, neon=50 },

  pictures = { tekwall4=10 },

  -- FIXME: should not be separated (environment = "liquid" ??)
  liquid_pics = { pois1=70, pois2=30 },

  crates = { crate1=50, crate2=50, },

  -- FIXME: should not be separated, have 'environment' fields
  out_crates = { wood=50, ick=50 },

  -- FIXME: next three should not be separated
  exits = { demon_pillar2=50 },
  small_exits = { tech_small=50 },
  out_exits = { tech_outdoor=50 },

  keys = { kc_red=50, kc_blue=50, kc_yellow=50 },
  switches = { sw_blue=50, sw_hot=50, sw_marble=50, sw_wood=50 },
  bars = { bar_silver=50 },

  -- MISC STUFF : these don't quite fit in yet --  (FIXME)

  periph_pillar_mat = "SUPPORT3",
  beam_mat = "METAL",
  light_trim = "METAL",
  corner_supports = { SUPPORT2=50, SUPPORT3=10 },
  ceiling_trim = "METAL",
  ceiling_spoke = "SHAWN2",
  teleporter_mat = "GATE3",
  raising_start_switch = "SW1COMP",
  pedestal_mat = "CEIL1_2",
  hall_trim1 = "GRAY7",
  hall_trim2 = "METAL",
  window_side_mat = "DOORSTOP",
  track_mat = "DOORTRAK",

  lowering_pedestal_skin =
  {
    side="WOOD3", top="CEIL1_3",
    x_offset=0, y_offset=0, peg=1,
    line_kind=23,
  },

  lowering_pedestal_skin2 =
  {
    side="PIPEWAL1", top="CEIL1_2",
    x_offset=0, y_offset=0, peg=1,
    line_kind=23,
  },

}


--[[  
   THEME IDEAS

   (a) nature  (outdoor, grassy/rocky/muddy, water)
   (b) urban   (outdoor, bricks/concrete,  slime)

   (c) gothic     (indoor, gstone, blood, castles) 
   (d) tech       (indoor, computers, lights, lifts) 
   (e) cave       (indoor, rocky/ashy, darkness, lava)
   (f) industrial (indoor, machines, lifts, crates, nukage)

   (h) hell    (indoor+outdoor, fire/lava, bodies, blood)
--]]


DOOM1.SUB_THEMES =
{
  doom_tech1 =
  {
    prob=60,

    liquids = { nukage=90, water=15, lava=10 },

    building_walls =
      {
        STARTAN3=25, STARG2=20, STARTAN2=18, STARG3=11,
        STARBR2=5, STARGR2=10, STARG1=5, STARG2=5,
        SLADWALL=18, GRAY7=10, BROWN1=5,
        BROWNGRN=10, BROWN96=8, METAL1=1, GRAY5=3,

        COMPOHSO=10, STARTAN1=5, COMPTILE=5,
      },
    building_floors =
      {
        FLOOR0_1=50, FLOOR0_2=20, FLOOR0_3=50,
        FLOOR0_7=50, FLOOR3_3=50, FLOOR7_1=10,
        FLOOR4_5=50, FLOOR4_6=50, FLOOR4_8=50, FLOOR5_2=50,
        FLAT1=20, FLAT5=20, FLAT9=50, FLAT14=50,
        CEIL3_2=50,
      },
    building_ceilings =
      {
        CEIL5_1=50, CEIL5_2=50, CEIL3_3=50, CEIL3_5=50,
        FLAT1=50, FLAT4=50, FLAT18=50,
        FLOOR0_2=50, FLOOR4_1=50, FLOOR5_1=50, FLOOR5_4=20,
        TLITE6_5=2, TLITE6_6=2, CEIL1_2=2,
      },
    building_corners =
      {
        STARGR1=40, METAL1=20, ICKWALL3=6,
        TEKWALL4=6, COMPTALL=3, COMPBLUE=3,

        COMPTILE=10,
      },

    courtyard_floors =
      {
        BROWN144=30, BROWN1=20, STONE=20,
        ASHWALL=5, FLAT10=5,
      },

    cave_walls =
      {
        ASHWALL=50,
        SP_ROCK1=50,
        GRAYVINE=50,
        TEKWALL4=3,
      },

    landscape_walls =
      {
        ASHWALL=50,
        SP_ROCK1=50,
        GRAYVINE=50,
        STONE=50,
     },

    hallway_walls =
      {
        BROWN1=33, BROWNGRN=50, GRAY1=50, STARBR2=33
      },
    hallway_floors =
      {
        FLAT4=50, CEIL5_1=50, FLOOR1_1=50, FLOOR3_3=50
      },
    hallway_ceilings =
      {
        FLAT4=50, CEIL5_1=50, CEIL3_5=50, CEIL3_3=50
      },

    stairwell_walls =
      {
        BROWN1=50, GRAY1=50, STARGR1=50, METAL1=20
      },
    stairwell_floors =
      {
        FLAT1=50, FLOOR7_1=50,
      },

    logos = { carve=5, pill=50, neon=50 },

    pictures =
    {
      shawn1=10, tekwall1=4, tekwall4=2,
      lite5=30, lite5_05blink=10, lite5_10blink=10,
      liteblu4=30, liteblu4_05sync=10, liteblu4_10sync=10,
      compsta1=40, compsta1_blink=4,
      compsta2=40, compsta2_blink=4,
      redwall=5,

---!!!   planet1=20,  planet1_blink=8,
      compute1=20, compute1_blink=3,
---!!!   compute2=15, compute2_blink=2,
      litered=10,
    },

    exits = { stone_pillar=50 },

    switches = { sw_blue=50, sw_hot=50 },

    bars = { bar_silver=50, bar_gray=50 },

    __exit =  -- FIXME
    {
      walls =
      {
        STARTAN2=50, STARG1=50,
        TEKWALL4=50, STARBR2=50
      },
      floors =
      {
        FLOOR0_3=50, FLOOR5_2=50
      },
      ceilings =
      {
        TLITE6_6=50, TLITE6_5=50, FLAT17=50,
        FLOOR1_7=50, CEIL4_3=50
      },
      switches =
      {
        SW1METAL=50, SW1LION=50, SW1BRN2=50, SW1BRNGN=50,
        SW1GRAY=50,  SW1SLAD=50, SW1STRTN=50,
        SW1STON1=50
      },
    },

    doors =
    {
      silver=20, silver_fast=33, silver_once=2,
      bigdoor2=5, bigdoor2_fast=8, bigdoor2_once=5,
      bigdoor4=5, bigdoor4_fast=8, bigdoor4_once=5,
      bigdoor3=5,
    },

    steps = { step1=50, step3=50, step4=50 },
    lifts = { shiny=20, platform=40, rusty=10 },

    ceil_lights =
    {
      TLITE6_5=50, TLITE6_6=30, TLITE6_1=30, FLOOR1_7=30,
      FLAT2=20,    CEIL3_4=10,  FLAT22=10,
    },

    big_lights = { TLITE6_5=30, TLITE6_6=30, FLAT17=30, CEIL3_4=30 },

    pillars = { metal1=70, tekwall4=20 },
    big_pillars = { big_red=50, big_blue=50 },

    crates = { crate1=50, crate2=50, comp=70, lite5=20 },

    style_list =
    {
      naturals = { none=30, few=70, some=30, heaps=2 },
    },
  },


  -- this is the greeny/browny/marbley Hell

  doom_hell1 =
  {
    prob = 40,

    liquids = { lava=30, blood=90, nukage=5 },

    building_walls =
      {
        MARBLE1=25, MARBLE2=10, MARBLE3=20,
        GSTVINE2=20, SLADWALL=10,
        SKINMET1=3, SKINMET2=3,

        SKINTEK1=15, SKINTEK2=15,
      },
    building_floors =
      {
        DEM1_5=15, DEM1_6=15, FLAT5_7=10, FLAT10=10,
        FLOOR7_1=10, FLAT1=10, FLOOR5_2=10,
      },
    building_ceilings =
      {
        FLAT1=10, FLAT10=10, FLAT5_5=10, FLOOR7_2=10,
      },
    building_corners =
      {
        SKULWALL=8, SKULWAL3=7,
      },

    courtyard_floors =
      {
        ASHWALL=20,
        FLAT5_6=10, FLAT10=20,
        SFLR6_1=10, MFLR8_2=20,
      },

    cave_walls =
      {
        ROCKRED1=90,
        SKIN2=50, SKINFACE=50, SKSNAKE1=35, SKSNAKE2=35,
        FIREBLU1=50, FIRELAVA=50, 
      },

    landscape_walls =
      {
        ASHWALL=50, GRAYVINE=50,
        SP_ROCK1=50, ROCKRED1=90,
        SKSNAKE1=10, SKSNAKE2=10,
      },

    logos = { carve=90, pill=50, neon=5 },

    pictures =
    {
      marbface=10, skinface=10, firewall=20,
      spdude1=4, spdude2=4, spdude5=3, spine=2,

      skulls1=10, skulls2=10, spdude3=3, spdude6=3,
    },

    steps = { step1=50, step3=50, step4=50 },
    lifts = { platform=10, rusty=50, spine=30 },

    keys = { ks_red=50, ks_blue=50, ks_yellow=50 },

    exits = { skin_pillar=40,
              demon_pillar2=10, demon_pillar3=10 },

    switches = { sw_marble=50, sw_vine=50, sw_wood=50 },

    bars = { bar_wood=50, bar_metal=50 },

    outer_fences = { ROCKRED1=25, SP_ROCK1=20, BROVINE2=10, GRAYVINE=10 },

    monster_prefs = { zombie=0.3, shooter=0.6, skull=2.0 },
  },


  -- this is the reddy/skinny/firey Hell

  doom_hell2 =
  {
    prob = 25,

    liquids = { lava=90, blood=40 },

    building_walls =
      {
        SP_HOT1=25, GSTVINE1=17, STONE=10, SKINMET2=5, BROWN1=2,
        SKINCUT=2,

        SKINTEK1=10, SKINTEK2=10,
      },
    building_floors =
      {
        FLAT5_7=10, FLAT10=10, FLAT5_3=10,
        FLOOR7_1=10, FLAT1=10, FLOOR5_2=10,
      },
    building_ceilings =
      {
        FLAT1=10, FLOOR6_1=10, FLAT10=10, FLAT8=10,
      },
    building_corners =
      {
        SKULWALL=10, SKULWAL3=10, REDWALL1=15,
      },

    courtyard_floors =
      {
        FLAT5_6=10, ASHWALL=5, FLAT10=5,
        SFLR6_4=10, MFLR8_2=10,
      },

    cave_walls =
      {
        ROCKRED1=90,
        SKIN2=50, SKINFACE=50, SKSNAKE1=35, SKSNAKE2=35,
        FIREBLU1=50, FIRELAVA=50, 
      },

    landscape_walls =
      {
        ASHWALL=50, GRAYVINE=50,
        SP_ROCK1=50, ROCKRED1=90,
        SKSNAKE1=10, SKSNAKE2=10,
      },

    logos = { carve=90, pill=50, neon=5 },

    pictures =
    {
      marbfac2=10, marbfac3=10,
      spface1=2, firewall=20,
      spine=5,

      skulls1=20, skulls2=20,
    },

    steps = { step1=50, step3=50, step4=50 },
    lifts = { platform=10, rusty=50, spine=30 },

    keys = { ks_red=50, ks_blue=50, ks_yellow=50 },

    exits = { skin_pillar=40,
              demon_pillar2=10, demon_pillar3=10 },

    switches = { sw_skin=50, sw_vine=50, sw_wood=50 },

    bars = { bar_wood=50, bar_metal=50 },

    outer_fences = { ROCKRED1=25, SP_ROCK1=20, BROVINE2=10, GRAYVINE=10 },

    monster_prefs = { zombie=0.3, shooter=0.6, skull=2.0 },
  },
}


DOOM2.SUB_THEMES =
{
  doom_tech1 =
  {
    prob=60,

    liquids = { nukage=90, water=15, lava=10, slime=5 },

    building_facades =
    {
---###  LAVA1=50, FWATER1=50, NUKAGE1=50, BLOOD1=50

      STARTAN3=25, STARG2=20, STARTAN2=18, STARG3=11,
      STARBR2=5, STARGR2=10, STARG1=5, STARG2=5,
      BROWN1=5,
      BROWNGRN=10, BROWN96=8, GRAY5=1,

      BRONZE1=5, BRONZE3=10,
      METAL2=25,
    },

    building_walls =
      {
        STARTAN3=25, STARG2=20, STARTAN2=18, STARG3=11,
        STARBR2=5, STARGR2=10, STARG1=5, STARG2=5,
        SLADWALL=20, GRAY7=12, BROWN1=5,
        BROWNGRN=10, BROWN96=8, METAL1=2, GRAY5=3,

        BRONZE1=5, BRONZE3=10, TEKGREN2=20,
        METAL2=5, PIPE2=10, PIPE4=5,
      },
    building_floors =
      {
        FLOOR0_1=50, FLOOR0_2=20, FLOOR0_3=50,
        FLOOR0_7=50, FLOOR3_3=50, FLOOR7_1=10,
        FLOOR4_5=50, FLOOR4_6=50, FLOOR4_8=50, FLOOR5_2=50,
        FLAT1=20, FLAT5=20, FLAT9=50, FLAT14=50,
        CEIL3_2=50,

        SLIME14=25, SLIME15=30, SLIME16=50,
      },
    building_ceilings =
      {
        CEIL5_1=50, CEIL5_2=50, CEIL3_3=50, CEIL3_5=50,
        FLAT1=50, FLAT4=50, FLAT18=50,
        FLOOR0_2=50, FLOOR4_1=50, FLOOR5_1=50, FLOOR5_4=20,
        TLITE6_5=2, TLITE6_6=2, CEIL1_2=2,

        GRNLITE1=2,
      },
    building_corners =
      {
        STARGR1=40, METAL1=20, ICKWALL3=6,
        TEKWALL4=6, COMPTALL=3, COMPBLUE=3,

        METAL7=40, METAL2=10, METAL4=10,
        TEKWALL6=10, TEKBRON1=3,
      },

    courtyard_floors =
      {
        BROWN144=30, BROWN1=20, STONE=20,
        ASHWALL=5, FLAT10=5,

        TANROCK5=10, GRASS2=5, GRASS1=3,
        BRICK10=5,
        RROCK14=5, RROCK19=5, RROCK20=5,
        STONE4=5, STONE6=5,
        ZIMMER5=3, ZIMMER8=1,
      },

    cave_walls =
      {
        ASHWALL=50,
        SP_ROCK1=50,
        GRAYVINE=50,
        TEKWALL4=3,

        ASHWALL4=50, ASHWALL7=50,
        BSTONE1=50, MODWALL1=50,
        ROCK5=50, RROCK03=50,
        STONE4=50, STONE7=60,

        TANROCK4=50, TANROCK5=50,
        TANROCK7=50, TANROCK8=50,
        ZIMMER3=50, ZIMMER5=50, ZIMMER8=50,
      },

    landscape_walls =
      {
        ASHWALL=50,
        SP_ROCK1=50,
        GRAYVINE=50,
        STONE=50,

        ASHWALL4=50, ASHWALL7=50,
        BSTONE1=50, ROCK5=50,
        MODWALL1=50, STONE4=50, STONE7=60,

        TANROCK4=50, TANROCK5=50,
        TANROCK7=50, TANROCK8=50,

        ZIMMER2=50, ZIMMER3=50,
        ZIMMER5=50, ZIMMER7=50, ZIMMER8=10,
      },

    hallway_walls =
      {
        BROWN1=33, BROWNGRN=50, GRAY1=50, STARBR2=33
      },
    hallway_floors =
      {
        FLAT4=50, CEIL5_1=50, FLOOR1_1=50, FLOOR3_3=50
      },
    hallway_ceilings =
      {
        FLAT4=50, CEIL5_1=50, CEIL3_5=50, CEIL3_3=50
      },

    stairwell_walls =
      {
        BROWN1=50, GRAY1=50, STARGR1=50, METAL4=50
      },
    stairwell_floors =
      {
        FLAT1=50, FLOOR7_1=50,
      },

    __exit =  -- FIXME
    {
      walls =
      {
        METAL2=50,   STARTAN2=50, STARG1=50,
        TEKWALL4=50, PIPEWAL2=50,
        TEKGREN1=50, SPACEW2=50,  STARBR2=50,

        METAL2=50, PIPEWAL2=50, TEKGREN1=50, SPACEW2=50,
      },
      floors =
      {
        FLOOR0_3=50, FLOOR5_2=50
      },
      ceilings =
      {
        TLITE6_6=50, TLITE6_5=50, FLAT17=50,
        FLOOR1_7=50, CEIL4_3=50,

        GRNLITE1=20,
      },
      switches =
      {
        SW1METAL=50, SW1LION=50, SW1BRN2=50, SW1BRNGN=50,
        SW1GRAY=50,  SW1MOD1=50, SW1SLAD=50, SW1STRTN=50,
        SW1TEK=50,   SW1STON1=50
      },
    },

    doors =
    {
      silver=20, silver_fast=33, silver_once=2,
      bigdoor2=5, bigdoor2_fast=8, bigdoor2_once=5,
      bigdoor4=5, bigdoor4_fast=8, bigdoor4_once=5,
      bigdoor3=5,
    },

    steps = { step6=50, },
    steps = { step1=50, step3=50, step4b=50 },

    lifts = { shiny=20, platform=40, rusty=10 },

    ceil_lights =
    {
      TLITE6_5=50, TLITE6_6=30, TLITE6_1=30, FLOOR1_7=30,
      FLAT2=20,    CEIL3_4=10,  FLAT22=10,
      
      GRNLITE1=10,
    },

    big_lights =
    {
      TLITE6_5=30, TLITE6_6=30, GRNLITE1=30, FLAT17=30, CEIL3_4=30,

      GRNLITE1=20
    },

    pillars = { metal1=70, tekwall4=20,
                teklite=50, silver2=10, shawn2=10, metal1=15 },

    big_pillars = { big_red=50, big_blue=50 },

    logos = { carve=5, pill=50, neon=50 },

    pictures =
    {
      shawn1=10, tekwall1=4, tekwall4=2,
      lite5=30, lite5_05blink=10, lite5_10blink=10,
      liteblu4=30, liteblu4_05sync=10, liteblu4_10sync=10,
      compsta1=40, compsta1_blink=4,
      compsta2=40, compsta2_blink=4,
      redwall=5,
    
      silver3=20, spacewall=20,
    },

    crates = { crate1=50, crate2=50, comp=70, lite5=20,
               space=90, mod=15 },

    exits = { skull_pillar=50, stone_pillar=5 },

    switches = { sw_blue=50, sw_hot=50 },

    bars = { bar_silver=50, bar_gray=50 },

    monster_prefs = { arach=2.0 },

    style_list =
    {
      naturals = { none=30, few=70, some=30, heaps=2 },
    },
  },


  doom_hell1 =
  {
    prob = 50,

    liquids = { lava=30, blood=90, nukage=5 },

    building_walls =
      {
        MARBLE1=25, MARBLE2=10, MARBLE3=20,
        GSTVINE2=20, SLADWALL=10,
        SKINMET1=3, SKINMET2=3,

        MARBGRAY=35,
      },
    building_floors =
      {
        DEM1_5=15, DEM1_6=15, FLAT5_7=10, FLAT10=10,
        FLOOR7_1=10, FLAT1=10, FLOOR5_2=10,
      },
    building_ceilings =
      {
        FLAT1=10, FLAT10=10, FLAT5_5=10, FLOOR7_2=10,
      },

    courtyard_floors =
      {
        ASHWALL=20,
        FLAT5_6=10, FLAT10=20,
        SFLR6_1=10, MFLR8_2=20,
      },

    cave_walls =
      {
        ROCKRED1=90,
        SKIN2=50, SKINFACE=50, SKSNAKE1=35, SKSNAKE2=35,
        FIREBLU1=50, FIRELAVA=50, 

        RROCK04=70,
        CRACKLE2=7, CRACKLE4=7,
        SP_FACE2=15,
      },

    landscape_walls =
      {
        ASHWALL=50, GRAYVINE=50,
        SP_ROCK1=50, ROCKRED1=90,
        SKSNAKE1=10, SKSNAKE2=10,

        RROCK04=70,
      },

    exits = { skin_pillar=40, skull_pillar=20,
             demon_pillar2=10, demon_pillar3=10 },

    logos = { carve=90, pill=50, neon=5 },

    pictures =
    {
      marbface=10, skinface=10, firewall=20,
      spdude1=4, spdude2=4, spdude5=3, spine=2,
    },

    steps = { step1=50, step3=50, step4=50 },
    lifts = { platform=10, rusty=50, spine=30 },

    keys = { ks_red=50, ks_blue=50, ks_yellow=50 },

    big_pillars = { big_red=50, sloppy=20, sloppy2=20, },

    switches = { sw_skin=50, sw_vine=50, sw_wood=50 },

    bars = { bar_wood=50, bar_metal=50 },

    outer_fences = { ROCKRED1=25, SP_ROCK1=20, BROVINE2=10, GRAYVINE=10 },

    monster_prefs = { zombie=0.3, shooter=0.6, skull=2.0, vile=2.0 },
  },


  doom_hell2 =
  {
    prob = 25,

    liquids = { lava=90, blood=40, slime=10 },

    building_walls =
      {
        SP_HOT1=25, GSTVINE1=17, STONE=10, SKINMET2=5, BROWN1=2,
        SKINCUT=2,
      },
    building_floors =
      {
        FLAT5_7=10, FLAT10=10, FLAT5_3=10,
        FLOOR7_1=10, FLAT1=10, FLOOR5_2=10,
      },
    building_ceilings =
      {
        FLAT1=10, FLOOR6_1=10, FLAT10=10, FLAT8=10,
      },

    courtyard_floors =
      {
        FLAT5_6=10, ASHWALL=5, FLAT10=5,
        SFLR6_4=10, MFLR8_2=10,

        CRACKLE2=15, CRACKLE4=20,
      },

    cave_walls =
      {
        ROCKRED1=90,
        SKIN2=50, SKINFACE=50, SKSNAKE1=35, SKSNAKE2=35,
        FIREBLU1=50, FIRELAVA=50, 

        RROCK04=70,
        CRACKLE2=7, CRACKLE4=7,
        SP_FACE2=15,
      },

    landscape_walls =
      {
        ASHWALL=50, GRAYVINE=50,
        SP_ROCK1=50, ROCKRED1=90,
        SKSNAKE1=10, SKSNAKE2=10,

        RROCK04=70,
      },

    exits = { skin_pillar=40, skull_pillar=20,
             demon_pillar2=10, demon_pillar3=10 },

    big_pillars = { big_red=50, sloppy=20, sloppy2=20, },
    
    logos = { carve=90, pill=50, neon=5 },

    pictures =
    {
      marbfac2=10, marbfac3=10,
      spface1=2, firewall=20,
      spine=5,

      spdude7=7,
    },

    steps = { step1=50, step3=50, step4=50 },
    lifts = { platform=10, rusty=50, spine=30 },

    keys = { ks_red=50, ks_blue=50, ks_yellow=50 },

    switches = { sw_skin=50, sw_marble=50, sw_vine=50 },

    bars = { bar_wood=50, bar_metal=50 },

    outer_fences = { ROCKRED1=25, SP_ROCK1=20, BROVINE2=10, GRAYVINE=10 },

    monster_prefs = { zombie=0.3, shooter=0.6, skull=2.0, vile=2.0 },
  },


  doom_urban1 =
  {
    prob = 50,

    liquids = { water=90, slime=40, lava=20, blood=7, nukage=2 },

    building_facades =
    {
      BIGBRIK1=20, BIGBRIK2=10,
      BLAKWAL1=10, BRWINDOW=15,
      BRICK5=10, BRICK7=35, BRICK8=5,
      BRICK10=3, BRICK11=8, BRICK12=8,
      STONE3=10, STONE2=6,
    },

    building_walls =
      {
        WOOD1=15,
        BIGBRIK1=20, BIGBRIK2=10,
        BRICK5=10, BRICK7=35, BRICK8=5,
        BRICK10=3, BRICK11=8, BRICK12=8,
        PANEL7=15, PANCASE2=25, STUCCO3=15,
        STONE3=10, STONE2=6,
      },
    building_floors =
      {
        FLAT1=20, FLAT1_1=20, FLOOR4_6=10, FLOOR5_4=20,
        FLOOR7_1=10, FLOOR0_2=15,
      },
    building_ceilings =
      {
        CEIL1_1=20, FLAT1=10, FLOOR7_1=5, RROCK14=10,
        FLAT5_1=5,
      },

    courtyard_floors =
      {
        STONE=40, BROWN1=20, ASHWALL6=5,
        RROCK19=10, ROCK2=15, STONE7=8,
        ASHWALL=5, ASHWALL4=5, ASHWALL7=5,
        BSTONE1=5, BSTONE2=5,
        ROCK3=10, ROCK5=10,
        GRASS1=15, GRASS2=10,
      },

    cave_walls =
      {
        ASHWALL=50,
        ASHWALL4=50, ASHWALL7=50,
        ROCK5=50, RROCK03=50,
        BSTONE1=50, SP_ROCK1=50,

        GRAYVINE=50, MODWALL1=50,
        STONE4=50, STONE7=60,
        TANROCK4=50, TANROCK5=50,
        TANROCK7=50, TANROCK8=50,

        ZIMMER3=50, ZIMMER5=50, ZIMMER8=50,
      },

    landscape_walls =
      {
        ASHWALL=50, ASHWALL4=50, ASHWALL7=50,
        BSTONE1=50, ROCK5=50,

        GRAYVINE=50, MODWALL1=50,
        STONE4=50, STONE7=60,
        TANROCK4=50, TANROCK5=50,
        TANROCK7=50, TANROCK8=50,

        ZIMMER2=50, ZIMMER3=50,
        ZIMMER5=50, ZIMMER7=50, ZIMMER8=10,

        WOOD9=90,
      },

    outer_fences =
    {
      STONE2=20, CEMENT9=30, WOOD9=30,
      STONE3=30, WOOD8=20, GRAY1=20, ICKWALL3=10,
      STONE4=30, STONE6=30, STUCCO=10,
      WOODMET1=10,
    },

    logos = { carve=40, pill=25, neon=50 },

    pictures =
    {
      eagle1=40, hitler1=10,
      marbfac2=3, marbfac3=3,
    },

    exits = { demon_pillar2=20, demon_pillar3=20, stone_pillar=30, },

    steps = { step6=50, },

    lifts = { shiny=20, platform=20, rusty=50 },

    switches = { sw_wood=50, sw_blue=50, sw_hot=50 },

    bars = { bar_wood=50, bar_metal=50 },

    room_types =
    {
      -- FIXME  PRISON  WAREHOUSE
    },

    monster_prefs =
    {
      caco=2.0, revenant=1.5, knight=1.5, demon=1.2,
    },

    -- FIXME: hallway = ...
  },


  -- this theme is not normally used (only for secret levels)
  doom_wolf1 =
  {
    prob = 10,

    square_caves = true,

    building_facades =
      {
        ZZWOLF1=50, ZZWOLF11=40, ZZWOLF9=20,
      },

    building_walls =
      {
        ZZWOLF1=40, ZZWOLF11=20, ZZWOLF9=40,
        ZZWOLF5=30,
      },

    building_floors =
      {
        FLAT5_1=50, FLAT1=50, FLAT3=50, FLAT18=30,
        FLAT1_2=15,
      },

    building_ceilings =
      {
        CEIL5_1=30, CEIL5_2=30, CEIL3_5=30,
        FLAT5_3=10, FLAT5_5=20,
      },

    courtyard_floors = { MFLR8_1=20, FLAT1_1=10, RROCK04=20 },

    cave_walls = { ROCK4=50, SP_ROCK1=10 },

    steps = { step1=50 },

    pictures = { eagle1=50, hitler1=10 },

    exits = { skull_pillar=50, stone_pillar=8 },

    switches = { sw_wood=50, sw_blue=50, sw_hot=50 },

    bars = { bar_wood=50, bar_gray=50, bar_silver=50 },

    doors = { wolf_door=90, wolf_elev_door=5 },

    force_mon_probs = { ss_dude=70, demon=20, shooter=20, zombie=20, _else=0 },

---???  weap_prefs = { chain=3, shotty=3, super=3 },

    style_list =
    {
      naturals = { none=40, few=60, some=10 },
    },
  },
}


OLD_COMMON_THEMES =
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


DOOM.PREBUILT_LEVELS =
{
  dead_simple =
  {
    file = "dead_simples.wad",
    maps = { MAP01=30, MAP02=50, MAP03=70 },
    name_theme = "BOSS",
  },

  icon_of_sin =
  {
    file = "icon_maps.wad",
    maps = { MAP01=30, MAP02=50 },
    name_theme = "BOSS",
  },

  gallow_arena =
  {
    file = "gallow_arenas.wad",
    maps = { MAP01=50, MAP02=25 },
    name_theme = "BOSS",
  },

  gotcha =
  {
    file = "gotcha_maps.wad",
    maps = { MAP01=50, MAP02=50, MAP03=40, MAP04=10 },
    name_theme = "BOSS",
  },

  phobos_anomaly =
  {
    file = "anomaly_towers.wad",
    maps = { E1M1=40, E1M2=80 },
    name_theme = "BOSS",
  },

  tower_of_babel =
  {
    file = "anomaly_towers.wad",
    maps = { E2M1=50 },
    name_theme = "BOSS",
  },

  dis =
  {
    file = "anomaly_towers.wad",
    maps = { E3M1=50 },
    name_theme = "BOSS",
  },

  against_thee =
  {
    file = "anomaly_towers.wad",
    maps = { E2M1=50 },
    name_theme = "BOSS",
  },

  unto_the_cruel =
  {
    file = "anomaly_towers.wad",
    maps = { E3M1=50 },
    name_theme = "BOSS",
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

DOOM.MONSTERS =
{
  zombie =
  {
    prob=40,
    health=20, damage=4, attack="hitscan",
    give={ {ammo="bullet",count=5} },
    density=1.5,
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
    density=0.5, float=true,
  },

  baron =
  {
    prob=20,
    health=1000, damage=45, attack="missile",
    density=0.5,
    weap_prefs={ bfg=3.0 },
  },


  ---| DOOM BOSSES |---

  Cyberdemon =
  {
    prob=10, crazy_prob=12, skip_prob=150,
    health=4000, damage=150, attack="missile",
    density=0.1,
    weap_prefs={ bfg=5.0 },
  },

  Mastermind =
  {
    prob=5, crazy_prob=18, skip_prob=150,
    health=3000, damage=100, attack="hitscan",
    density=0.2,
    weap_prefs={ bfg=5.0 },
  },
}


DOOM2.MONSTERS =
{
  gunner =
  {
    prob=20,
    health=70, damage=50, attack="hitscan",
    give={ {weapon="chain"}, {ammo="bullet",count=10} },
  },

  revenant =
  {
    prob=40, skip_prob=90,
    health=300, damage=70, attack="missile",
    density=0.6,
  },

  knight =
  {
    prob=60, skip_prob=75, crazy_prob=40,
    health=500, damage=45, attack="missile",
    density=0.7,
  },

  mancubus =
  {
    prob=33,
    health=600, damage=70, attack="missile",
    density=0.6,
  },

  arach =
  {
    prob=25,
    health=500, damage=70, attack="missile",
    density=0.8,
  },

  vile =
  {
    prob=16, skip_prob=100,
    health=700, damage=40, attack="hitscan",
    density=0.2, never_promote=true,
  },

  pain =
  {
    prob=7, crazy_prob=15, skip_prob=150,
    health=700, damage=20, attack="missile",
    density=0.2, never_promote=true, float=true, 
    weap_prefs={ launch=0.2 },
  },

  ss_dude =
  {
    -- not generated in normal levels
    crazy_prob=7, skip_prob=100,
    health=50, damage=15, attack="hitscan",
    give={ {ammo="bullet",count=5} },
    density=2.0,
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

DOOM.WEAPONS =
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
    pref=50, add_prob=25, start_prob=15,
    rate=1.7, damage=80, attack="missile", splash={ 50,20,5 },
    ammo="rocket", per=1,
    give={ {ammo="rocket",count=2} },
  },

  plasma =
  {
    pref=90, add_prob=13, start_prob=7,
    rate=11, damage=20, attack="missile",
    ammo="cell", per=1,
    give={ {ammo="cell",count=40} },
  },

  bfg =
  {
    pref=30, add_prob=20, start_prob=1, rarity=4,
    rate=0.8, damage=300, attack="missile", splash={60,45,30,30,20,10},
    ammo="cell", per=40,
    give={ {ammo="cell",count=40} },
  },

  -- this is Doom II only --
  super =
  {
    pref=70, add_prob=20, start_prob=15,
    rate=0.6, damage=170, attack="hitscan", splash={ 0,30 },
    ammo="shell", per=2,
    give={ {ammo="shell",count=8} },
  },
}


DOOM.AMMOS =
{
  bullet = { start_bonus = 60 },
  shell  = { start_bonus = 12 },
  rocket = { start_bonus = 4  },
  cell   = { start_bonus = 40 },
}


-- Pickup List
-- ===========

DOOM.PICKUPS =
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
    prob=3, big_item=true, start_prob=5,
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
    prob=5, armor=true, big_item=true, start_prob=80,
    give={ {health=30} },
  },

  blue_armor =
  {
    prob=2, armor=true, big_item=true, start_prob=30,
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

  -- Doom II only --

  mega =
  {
    prob=1, armor=true, big_item=true, start_prob=8,
    give={ {health=200} },
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


DOOM.PLAYER_MODEL =
{
  doomguy =
  {
    stats   = { health=0, bullet=0, shell=0, rocket=0, cell=0 },
    weapons = { pistol=1, fist=1 },
  }
}


DOOM1.EPISODES =
{
  episode1 =
  {
    orig_theme = "doom_tech",
    sky_light = 0.85,
    secret_exits = { "E1M3" },
  },

  episode2 =
  {
    orig_theme = "doom_tech",
    sky_light = 0.65,
    secret_exits = { "E2M5" },
  },

  episode3 =
  {
    orig_theme = "doom_hell",
    sky_light = 0.75,
    secret_exits = { "E3M6" },
  },

  episode4 =
  {
    orig_theme = "doom_hell",
    sky_light = 0.75,
    secret_exits = { "E4M2" },
  },
}

DOOM2.EPISODES =
{
  episode1 =
  {
    orig_theme = "doom_tech",
    sky_light = 0.75,
  },

  episode2 =
  {
    orig_theme = "doom_urban",
    sky_light = 0.50,
    secret_exits = { "MAP16", "MAP31" },
  },

  episode3 =
  {
    orig_theme = "doom_hell",
    sky_light = 0.75,
  },
}



------------------------------------------------------------


function DOOM.d1_setup()
  -- remove Doom II only stuff
  GAME.WEAPONS["super"] = nil
  GAME.PICKUPS["mega"]  = nil

  -- tweak monster probabilities
  GAME.MONSTERS["Cyberdemon"].crazy_prob = 8
  GAME.MONSTERS["Mastermind"].crazy_prob = 12
end


function DOOM.d2_setup()
  -- nothing needed
end


function DOOM.d1_get_levels()
  local EP_MAX  = sel(OB_CONFIG.game   == "ultdoom", 4, 3)
  local EP_NUM  = sel(OB_CONFIG.length == "full", EP_MAX, 1)
  local MAP_NUM = sel(OB_CONFIG.length == "single", 1, 9)

  if OB_CONFIG.length == "few" then MAP_NUM = 4 end

  GAME.original_themes = {}

  local few_episodes = { 1, 1, 2, 2 }

  for episode = 1,EP_NUM do
    local ep_info = DOOM1.EPISODES["episode" .. episode]
    assert(ep_info)

    GAME.original_themes[episode] = ep_info.orig_theme

    for map = 1,MAP_NUM do
      local ep_along = map / MAP_NUM

      if MAP_NUM == 1 then
        ep_along = rand.range(0.3, 0.7);
      elseif map == 9 then
        ep_along = 0.5
      end

      local LEV =
      {
        name  = string.format("E%dM%d", episode, map),
        patch = string.format("WILV%d%d", episode-1, map-1),

        map      = map,
        episode  = episode,
        ep_along = ep_along,

        sky_light   = ep_info.sky_light,
        secret_kind = (map == 9) and "plain",
      }

      if OB_CONFIG.length == "few" then
        LEV.episode = few_episodes[map]
      end

      if LEV.name == "E1M8" then
        LEV.prebuilt = GAME.PREBUILT_LEVELS.phobos_anomaly
      elseif LEV.name == "E2M8" then
        LEV.prebuilt = GAME.PREBUILT_LEVELS.tower_of_babel
      elseif LEV.name == "E3M8" then
        LEV.prebuilt = GAME.PREBUILT_LEVELS.dis
      elseif LEV.name == "E4M6" then
        LEV.prebuilt = GAME.PREBUILT_LEVELS.against_thee
      elseif LEV.name == "E4M8" then
        LEV.prebuilt = GAME.PREBUILT_LEVELS.unto_the_cruel
      end

      if LEV.prebuilt then
        LEV.name_theme = LEV.prebuilt.name_theme
      end

      if MAP_NUM == 1 or map == 3 then
        LEV.demo_lump = string.format("DEMO%d", episode)
      end

      table.insert(GAME.all_levels, LEV)
    end -- for map

  end -- for episode
end


function DOOM.d2_get_levels()
  local MAP_NUM = 11

  if OB_CONFIG.length == "single" then MAP_NUM = 1  end
  if OB_CONFIG.length == "few"    then MAP_NUM = 4  end
  if OB_CONFIG.length == "full"   then MAP_NUM = 32 end

  gotcha_map = rand.pick{17,18,19}
  gallow_map = rand.pick{24,25,26}

  GAME.original_themes = {}

  local few_episodes = { 1, rand.sel(70,1,2), rand.sel(70,2,3), 3 }

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
      ep_along = rand.range(0.3, 0.7)
    end

    if OB_CONFIG.length == "single" then
      ep_along = 0.5
    elseif OB_CONFIG.length == "few" then
      ep_along = map / MAP_NUM
    end

    local ep_info = DOOM2.EPISODES["episode" .. episode]
    assert(ep_info)
    assert(ep_along <= 1)

    if not GAME.original_themes[episode] then
      GAME.original_themes[episode] = ep_info.orig_theme
    end

    local LEV =
    {
      name  = string.format("MAP%02d", map),
      patch = string.format("CWILV%02d", map-1),

      map      = map,
      episode  = episode,
      ep_along = ep_along,

      sky_light = ep_info.sky_light,
    }

    if OB_CONFIG.length == "few" then
      LEV.episode = few_episodes[map]
    end

    -- secret levels
    if map == 31 or map == 32 then
      LEV.sub_theme = GAME.SUB_THEMES["doom_wolf1"]
      LEV.name_theme = "URBAN"
    end

    if map == 23 then
      LEV.style_list = { barrels = { heaps=100 } }
    end

    if map == 7 then
      LEV.prebuilt = GAME.PREBUILT_LEVELS.dead_simple
    elseif map == gotcha_map then
      LEV.prebuilt = GAME.PREBUILT_LEVELS.gotcha
    elseif map == gallow_map then
      LEV.prebuilt = GAME.PREBUILT_LEVELS.gallow_arena
    elseif map == 30 then
      LEV.prebuilt = GAME.PREBUILT_LEVELS.icon_of_sin
    end

    if LEV.prebuilt then
      LEV.name_theme = LEV.prebuilt.name_theme
    end

    if MAP_NUM == 1 or (map % 10) == 3 then
      LEV.demo_lump = string.format("DEMO%d", episode)
    end

    table.insert(GAME.all_levels, LEV)
  end
end


DOOM.LEVEL_GFX_COLORS =
{
  gold   = { 0,47,44, 167,166,165,164,163,162,161,160, 225 },
  silver = { 0,246,243,240, 205,202,200,198, 196,195,194,193,192, 4 },
  bronze = { 0,2, 191,188, 235,232, 221,218,215,213,211,209 },
  iron   = { 0,7,5, 111,109,107,104,101,98,94,90,86,81 },
}

function DOOM.make_cool_gfx()
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

    DOOM.LEVEL_GFX_COLORS.gold,
    DOOM.LEVEL_GFX_COLORS.silver,
    DOOM.LEVEL_GFX_COLORS.iron,
  }

  rand.shuffle(colmaps)

  gui.set_colormap(1, colmaps[1])
  gui.set_colormap(2, colmaps[2])
  gui.set_colormap(3, colmaps[3])
  gui.set_colormap(4, DOOM.LEVEL_GFX_COLORS.iron)

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

function DOOM.make_level_gfx()
  assert(LEVEL.description)
  assert(LEVEL.patch)

  -- decide color set
  if not GAME.level_gfx_colors then
    local kind = rand.key_by_probs(
    {
      gold=12, silver=3, bronze=8, iron=10
    })

    GAME.level_gfx_colors = assert(DOOM.LEVEL_GFX_COLORS[kind])
  end

  gui.set_colormap(1, GAME.level_gfx_colors)

  gui.wad_name_gfx(LEVEL.patch, LEVEL.description, 1)
end

function DOOM.begin_level()
  -- set the description
  if not LEVEL.description and LEVEL.name_theme then
    LEVEL.description = Naming_grab_one(LEVEL.name_theme)
  end

  -- determine stuff for prebuilt levels
  if LEVEL.prebuilt then
    local info = LEVEL.prebuilt

    LEVEL.prebuilt_wad = info.file
    LEVEL.prebuilt_map = rand.key_by_probs(info.maps)
  end
end

function DOOM.end_level()
gui.printf("DOOM.end_level: desc='%s' patch='%s'\n",
           tostring(LEVEL.description),
           tostring(LEVEL.patch))
  if LEVEL.description and LEVEL.patch then
    DOOM.make_level_gfx()
  end
end

function DOOM.all_done()
  DOOM.make_cool_gfx()

  gui.wad_merge_sections("doom_falls.wad");
  gui.wad_merge_sections("vine_dude.wad");

  if OB_CONFIG.length == "full" then
    gui.wad_merge_sections("freedoom_face.wad");
  end
end



------------------------------------------------------------

OB_GAMES["doom1"] =
{
  label = "Doom 1",

  priority = 98, -- keep at second spot

  format = "doom",

  tables =
  {
    DOOM, DOOM1
  },

  hooks =
  {
    setup        = DOOM.d1_setup,
    get_levels   = DOOM.d1_get_levels,

    begin_level  = DOOM.begin_level,
    end_level    = DOOM.end_level,
    all_done     = DOOM.all_done,
  },
}


OB_GAMES["ultdoom"] =
{
  label = "Ultimate Doom",

  extends = "doom1",

  priority = 97, -- keep at third spot
  
  -- no additional tables

  -- no additional hooks

  -- no additional parameters
}


OB_GAMES["doom2"] =
{
  label = "Doom 2",

  priority = 99, -- keep at top

  format = "doom",

  tables =
  {
    DOOM, DOOM2
  },

  hooks =
  {
    setup        = DOOM.d2_setup,
    get_levels   = DOOM.d2_get_levels,

    begin_level  = DOOM.begin_level,
    end_level    = DOOM.end_level,
    all_done     = DOOM.all_done,
  },
}


------------------------------------------------------------

OB_THEMES["doom_tech"] =
{
  label = "Tech",

  for_games = { doom1=1, doom2=1 },

  name_theme = "TECH",
  mixed_prob = 50,
}

OB_THEMES["doom_urban"] =
{
  label = "Urban",

  for_games = { doom2=1 },

  name_theme = "URBAN",
  mixed_prob = 50,
}

OB_THEMES["doom_hell"] =
{
  label = "Hell",
  for_games = { doom1=1, doom2=1 },

  name_theme = "GOTHIC",
  mixed_prob = 50,
}

OB_THEMES["doom_wolf"] =
{
  label = "Wolfenstein",
  for_games = { doom2=1 },

  name_theme = "URBAN",

  -- this theme is special, hence no mixed_prob
  psycho_prob = 5,
}

