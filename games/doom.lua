----------------------------------------------------------------
--  GAME DEFINITION : DOOM I and II
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2012 Andrew Apted
--  Copyright (C)      2011 Chris Pisarczyk
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
  --- Players ---

  player1 = { id=1, kind="other", r=16,h=56 }
  player2 = { id=2, kind="other", r=16,h=56 }
  player3 = { id=3, kind="other", r=16,h=56 }
  player4 = { id=4, kind="other", r=16,h=56 }

  dm_player     = { id=11, kind="other", r=16,h=56 }
  teleport_spot = { id=14, kind="other", r=16,h=56 }

  --- Monsters ---

  zombie    = { id=3004,kind="monster", r=20,h=56 }
  shooter   = { id=9,   kind="monster", r=20,h=56 }
  gunner    = { id=65,  kind="monster", r=20,h=56 }
  imp       = { id=3001,kind="monster", r=20,h=56 }

  caco      = { id=3005,kind="monster", r=31,h=56 }
  revenant  = { id=66,  kind="monster", r=20,h=64 }
  knight    = { id=69,  kind="monster", r=24,h=64 }
  baron     = { id=3003,kind="monster", r=24,h=64 }

  mancubus  = { id=67,  kind="monster", r=48,h=64 }
  arach     = { id=68,  kind="monster", r=66,h=64 }
  pain      = { id=71,  kind="monster", r=31,h=56 }
  vile      = { id=64,  kind="monster", r=20,h=56 }
  demon     = { id=3002,kind="monster", r=30,h=56 }
  spectre   = { id=58,  kind="monster", r=30,h=56 }
  skull     = { id=3006,kind="monster", r=16,h=56 }

  ss_dude   = { id=84, kind="monster", r=20, h=56 }
  keen      = { id=72, kind="monster", r=16, h=72, ceil=true }

  -- bosses --
  Mastermind = { id=7,  kind="monster", r=128,h=100 }
  Cyberdemon = { id=16, kind="monster", r=40, h=110 }

  --- Pickups ---

  kc_red     = { id=13, kind="pickup", r=20,h=16, pass=true }
  kc_yellow  = { id=6,  kind="pickup", r=20,h=16, pass=true }
  kc_blue    = { id=5,  kind="pickup", r=20,h=16, pass=true }

  ks_red     = { id=38, kind="pickup", r=20,h=16, pass=true }
  ks_yellow  = { id=39, kind="pickup", r=20,h=16, pass=true }
  ks_blue    = { id=40, kind="pickup", r=20,h=16, pass=true }

  shotty = { id=2001, kind="pickup", r=20,h=16, pass=true }
  super  = { id=  82, kind="pickup", r=20,h=16, pass=true }
  chain  = { id=2002, kind="pickup", r=20,h=16, pass=true }
  launch = { id=2003, kind="pickup", r=20,h=16, pass=true }
  plasma = { id=2004, kind="pickup", r=20,h=16, pass=true }
  saw    = { id=2005, kind="pickup", r=20,h=16, pass=true }
  bfg    = { id=2006, kind="pickup", r=20,h=16, pass=true }

  backpack = { id=   8, kind="pickup", r=20,h=16, pass=true }
  mega     = { id=  83, kind="pickup", r=20,h=16, pass=true }
  invul    = { id=2022, kind="pickup", r=20,h=16, pass=true }
  berserk  = { id=2023, kind="pickup", r=20,h=16, pass=true }
  invis    = { id=2024, kind="pickup", r=20,h=16, pass=true }
  suit     = { id=2025, kind="pickup", r=20,h=60, pass=true }
  map      = { id=2026, kind="pickup", r=20,h=16, pass=true }
  goggle   = { id=2045, kind="pickup", r=20,h=16, pass=true }

  potion   = { id=2014, kind="pickup", r=20,h=16, pass=true }
  stimpack = { id=2011, kind="pickup", r=20,h=16, pass=true }
  medikit  = { id=2012, kind="pickup", r=20,h=16, pass=true }
  soul     = { id=2013, kind="pickup", r=20,h=16, pass=true }

  helmet      = { id=2015, kind="pickup", r=20,h=16, pass=true }
  green_armor = { id=2018, kind="pickup", r=20,h=16, pass=true }
  blue_armor  = { id=2019, kind="pickup", r=20,h=16, pass=true }

  bullets    = { id=2007, kind="pickup", r=20,h=16, pass=true }
  bullet_box = { id=2048, kind="pickup", r=20,h=16, pass=true }
  shells     = { id=2008, kind="pickup", r=20,h=16, pass=true }
  shell_box  = { id=2049, kind="pickup", r=20,h=16, pass=true }
  rockets    = { id=2010, kind="pickup", r=20,h=16, pass=true }
  rocket_box = { id=2046, kind="pickup", r=20,h=16, pass=true }
  cells      = { id=2047, kind="pickup", r=20,h=16, pass=true }
  cell_pack  = { id=  17, kind="pickup", r=20,h=16, pass=true }


  --- Scenery ---

  -- lights --
  lamp         = { id=2028,kind="scenery", r=16,h=48, light=255 }
  mercury_lamp = { id=85,  kind="scenery", r=16,h=80, light=255 }
  short_lamp   = { id=86,  kind="scenery", r=16,h=60, light=255 }
  tech_column  = { id=48,  kind="scenery", r=16,h=128,light=255 }

  candle         = { id=34, kind="scenery", r=16,h=16, light=111, pass=true }
  candelabra     = { id=35, kind="scenery", r=16,h=56, light=255 }
  burning_barrel = { id=70, kind="scenery", r=16,h=44, light=255 }

  blue_torch     = { id=44, kind="scenery", r=16,h=96, light=255 }
  blue_torch_sm  = { id=55, kind="scenery", r=16,h=72, light=255 }
  green_torch    = { id=45, kind="scenery", r=16,h=96, light=255 }
  green_torch_sm = { id=56, kind="scenery", r=16,h=72, light=255 }
  red_torch      = { id=46, kind="scenery", r=16,h=96, light=255 }
  red_torch_sm   = { id=57, kind="scenery", r=16,h=72, light=255 }

  -- decoration --
  barrel = { id=2035, kind="scenery", r=12, h=44 }

  green_pillar     = { id=30, kind="scenery", r=16,h=56 }
  green_column     = { id=31, kind="scenery", r=16,h=40 }
  green_column_hrt = { id=36, kind="scenery", r=16,h=56, add_mode="island" }

  red_pillar     = { id=32, kind="scenery", r=16,h=52 }
  red_column     = { id=33, kind="scenery", r=16,h=56 }
  red_column_skl = { id=37, kind="scenery", r=16,h=56, add_mode="island" }

  burnt_tree = { id=43, kind="scenery", r=16,h=56, add_mode="island" }
  brown_stub = { id=47, kind="scenery", r=16,h=56, add_mode="island" }
  big_tree   = { id=54, kind="scenery", r=31,h=120,add_mode="island" }

  -- gore --
  evil_eye    = { id=41, kind="scenery", r=16,h=56, add_mode="island" }
  skull_rock  = { id=42, kind="scenery", r=16,h=48 }
  skull_pole  = { id=27, kind="scenery", r=16,h=52 }
  skull_kebab = { id=28, kind="scenery", r=20,h=64 }
  skull_cairn = { id=29, kind="scenery", r=20,h=40, add_mode="island" }

  impaled_human  = { id=25,kind="scenery", r=20,h=64 }
  impaled_twitch = { id=26,kind="scenery", r=16,h=64 }

  gutted_victim1 = { id=73, kind="scenery", r=16,h=88, ceil=true }
  gutted_victim2 = { id=74, kind="scenery", r=16,h=88, ceil=true }
  gutted_torso1  = { id=75, kind="scenery", r=16,h=64, ceil=true }
  gutted_torso2  = { id=76, kind="scenery", r=16,h=64, ceil=true }
  gutted_torso3  = { id=77, kind="scenery", r=16,h=64, ceil=true }
  gutted_torso4  = { id=78, kind="scenery", r=16,h=64, ceil=true }

  hang_arm_pair  = { id=59, kind="scenery", r=20,h=84, ceil=true, pass=true }
  hang_leg_pair  = { id=60, kind="scenery", r=20,h=68, ceil=true, pass=true }
  hang_leg_gone  = { id=61, kind="scenery", r=20,h=52, ceil=true, pass=true }
  hang_leg       = { id=62, kind="scenery", r=20,h=52, ceil=true, pass=true }
  hang_twitching = { id=63, kind="scenery", r=20,h=68, ceil=true, pass=true }

  gibs          = { id=24, kind="scenery", r=20,h=16, pass=true }
  gibbed_player = { id=10, kind="scenery", r=20,h=16, pass=true }
  pool_blood_1  = { id=79, kind="scenery", r=20,h=16, pass=true }
  pool_blood_2  = { id=80, kind="scenery", r=20,h=16, pass=true }
  pool_brains   = { id=81, kind="scenery", r=20,h=16, pass=true }

  -- Note: id=12 exists, but is exactly the same as id=10

  dead_player  = { id=15, kind="scenery", r=16,h=16, pass=true }
  dead_zombie  = { id=18, kind="scenery", r=16,h=16, pass=true }
  dead_shooter = { id=19, kind="scenery", r=16,h=16, pass=true }
  dead_imp     = { id=20, kind="scenery", r=16,h=16, pass=true }
  dead_demon   = { id=21, kind="scenery", r=16,h=16, pass=true }
  dead_caco    = { id=22, kind="scenery", r=16,h=16, pass=true }
  dead_skull   = { id=23, kind="scenery", r=16,h=16, pass=true }

  -- special stuff --
  dummy = { id=23, kind="other", r=16,h=16, pass=true }

  brain_boss    = { id=88, kind="other", r=16, h=16 }
  brain_shooter = { id=89, kind="other", r=20, h=32 }
  brain_target  = { id=87, kind="other", r=20, h=32, pass=true }

} -- end of DOOM.ENTITIES


DOOM.PARAMETERS =
{
  rails = true
  infighting = true
  raising_start = true
  light_brushes = true

  jump_height = 24

  map_limit = 12800

  -- this is roughly how many characters can fit on the
  -- intermission screens (the CWILVxx patches).  It does not
  -- reflect any buffer limits in the DOOM.EXE
  max_name_length = 28

  skip_monsters = { 15,25,35 }

  time_factor   = 1.0
  damage_factor = 1.0
  ammo_factor   = 1.0
  health_factor = 0.7
  monster_factor = 0.9
}

DOOM2.PARAMETERS =
{
  doom2_monsters = true
  doom2_weapons  = true
  doom2_skies    = true  -- RSKY# patches

  skip_monsters = { 20,30,45 }
}


----------------------------------------------------------------

DOOM.MATERIALS =
{
  -- special materials --

  _ERROR = { t="CRACKLE2", f="CEIL5_2" }
  _SKY   = { t="CEMENT3",  f="F_SKY1" }


  -- general purpose --

  METAL  = { t="METAL",    f="CEIL5_2", color=0x292418 }

  SUPPORT2 = { t="SUPPORT2", f="FLAT23",  color=0x5e5e5e }
  SUPPORT3 = { t="SUPPORT3", f="CEIL5_2", color=0x282418 }


  -- walls --

  BIGDOOR1 = { t="BIGDOOR1", f="FLAT23",   color=0x5e5850 }
  BIGDOOR2 = { t="BIGDOOR2", f="FLAT1",    color=0x595654 }
  BIGDOOR3 = { t="BIGDOOR3", f="FLOOR7_2", color=0x4f5236 }
  BIGDOOR4 = { t="BIGDOOR4", f="FLOOR3_3", color=0x58422d }
  BIGDOOR5 = { t="BIGDOOR5", f="FLAT5_2",  color=0x3b301e }
  BIGDOOR6 = { t="BIGDOOR6", f="CEIL5_2",  color=0x433522 }
  BIGDOOR7 = { t="BIGDOOR7", f="CEIL5_2",  color=0x41321f }

  BROWN1   = { t="BROWN1",   f="FLOOR0_1", color=0x695035 }
  BROWN144 = { t="BROWN144", f="FLOOR7_1", color=0x2d2719 }
  BROWN96  = { t="BROWN96",  f="FLOOR7_1", color=0x332a18 }
  BROWNGRN = { t="BROWNGRN", f="FLOOR7_1", color=0x1e2317 }
  BROWNHUG = { t="BROWNHUG", f="FLOOR7_1", color=0x3b2d14 }
  BROWNPIP = { t="BROWNPIP", f="FLOOR0_1", color=0x67523b }
  BROVINE2 = { t="BROVINE2", f="FLOOR7_1", color=0x3a301f }
  BRNPOIS  = { t="BRNPOIS",  f="FLOOR7_1", color=0x2a2b18 }

  COMPBLUE = { t="COMPBLUE", f="FLAT14",  color=0x000043 }
  COMPSPAN = { t="COMPSPAN", f="CEIL5_1", color=0x242424 }
  COMPSTA1 = { t="COMPSTA1", f="FLAT23",  color=0x4e4f4d }
  COMPSTA2 = { t="COMPSTA2", f="FLAT23",  color=0x4c514b }
  COMPTALL = { t="COMPTALL", f="CEIL5_1", color=0x242422 }
  COMPWERD = { t="COMPWERD", f="CEIL5_1", color=0x282926 }

  CRATE1   = { t="CRATE1",   f="CRATOP2", color=0x604e39  }
  CRATE2   = { t="CRATE2",   f="CRATOP1", color=0x51524e  }
  CRATELIT = { t="CRATELIT", f="CRATOP1", color=0x585044  }
  CRATINY  = { t="CRATINY",  f="CRATOP1", color=0x52534f  }
  CRATWIDE = { t="CRATWIDE", f="CRATOP1", color=0x5a5146  }

  -- keep locked doors recognisable
  DOORBLU  = { t="DOORBLU",  f="FLAT23",  sane=1 }
  DOORRED  = { t="DOORRED",  f="FLAT23",  sane=1 }
  DOORYEL  = { t="DOORYEL",  f="FLAT23",  sane=1 }
  DOORBLU2 = { t="DOORBLU2", f="CRATOP2", sane=1 }
  DOORRED2 = { t="DOORRED2", f="CRATOP2", sane=1 }
  DOORYEL2 = { t="DOORYEL2", f="CRATOP2", sane=1 }

  DOOR1    = { t="DOOR1",    f="FLAT23", color=0x817265 }
  DOOR3    = { t="DOOR3",    f="FLAT23", color=0x626262 }
  DOORSTOP = { t="DOORSTOP", f="FLAT23", color=0x545454 }
  DOORTRAK = { t="DOORTRAK", f="FLAT23", color=0x282828 }

  EXITDOOR = { t="EXITDOOR", f="FLAT5_5" }
  EXITSIGN = { t="EXITSIGN", f="CEIL5_1" }
  EXITSTON = { t="EXITSTON", f="MFLR8_1" }

  -- these three are animated
  FIREBLU1 = { t="FIREBLU1", f="FLOOR6_1" }
  FIRELAVA = { t="FIRELAVA", f="FLOOR6_1" }
  FIREWALL = { t="FIREWALL", f="FLAT5_3" }

  GRAY1    = { t="GRAY1",    f="FLAT18", color=0x6f6f6f }
  GRAY2    = { t="GRAY2",    f="FLAT18", color=0x737373 }
  GRAY4    = { t="GRAY4",    f="FLAT18", color=0x656565 }
  GRAY5    = { t="GRAY5",    f="FLAT18", color=0x6f6f6f }
  GRAY7    = { t="GRAY7",    f="FLAT18", color=0x696969 }
  GRAYBIG  = { t="GRAYBIG",  f="FLAT18", color=0x6f6f6f }
  GRAYPOIS = { t="GRAYPOIS", f="FLAT18", color=0x6c6659 }
  GRAYTALL = { t="GRAYTALL", f="FLAT18", color=0x6c6867 }
  GRAYVINE = { t="GRAYVINE", f="FLAT1",  color=0x574c3f }

  GSTFONT1 = { t="GSTFONT1", f="FLOOR7_2", color=0x49422f  }
  GSTGARG  = { t="GSTGARG",  f="FLOOR7_2", color=0x4b4e37  }
  GSTLION  = { t="GSTLION",  f="FLOOR7_2", color=0x4c4e38  }
  GSTONE1  = { t="GSTONE1",  f="FLOOR7_2", color=0x4b4e37  }
  GSTONE2  = { t="GSTONE2",  f="FLOOR7_2", color=0x4b4a34  }
  GSTSATYR = { t="GSTSATYR", f="FLOOR7_2", color=0x464631  }
  GSTVINE1 = { t="GSTVINE1", f="FLOOR7_2", color=0x4a3f2a  }
  GSTVINE2 = { t="GSTVINE2", f="FLOOR7_2", color=0x394825  }

  ICKWALL1 = { t="ICKWALL1", f="FLAT19", color=0x64655f  }
  ICKWALL2 = { t="ICKWALL2", f="FLAT19", color=0x62635d  }
  ICKWALL3 = { t="ICKWALL3", f="FLAT19", color=0x626558  }
  ICKWALL4 = { t="ICKWALL4", f="FLAT19", color=0x5c5d53  }
  ICKWALL5 = { t="ICKWALL5", f="FLAT19", color=0x63645e  }
  ICKWALL7 = { t="ICKWALL7", f="FLAT19", color=0x62645b  }

  LITE3    = { t="LITE3",    f="FLAT19" }
  LITE5    = { t="LITE5",    f="FLAT19" }
  LITEBLU1 = { t="LITEBLU1", f="FLAT23" }
  LITEBLU4 = { t="LITEBLU4", f="FLAT1"  }

  MARBLE1  = { t="MARBLE1",  f="FLOOR7_2", color=0x4c5137 }
  MARBLE2  = { t="MARBLE2",  f="FLOOR7_2", color=0x474c32 }
  MARBLE3  = { t="MARBLE3",  f="FLOOR7_2", color=0x474c32 }
  MARBFACE = { t="MARBFACE", f="FLOOR7_2", color=0x4e4832 }
  MARBFAC2 = { t="MARBFAC2", f="FLOOR7_2", color=0x4c5036 }
  MARBFAC3 = { t="MARBFAC3", f="FLOOR7_2", color=0x4c5136 }
  MARBLOD1 = { t="MARBLOD1", f="FLOOR7_2", color=0x4d4e35 }

  METAL1   = { t="METAL1",   f="FLOOR4_8", color=0x2a2a29 }
  NUKE24   = { t="NUKE24",   f="FLOOR7_1", color=0x37491e }
  NUKEDGE1 = { t="NUKEDGE1", f="FLOOR7_1", color=0x3b3316 }
  NUKEPOIS = { t="NUKEPOIS", f="FLOOR7_1" }

  PIPE1    = { t="PIPE1",    f="FLOOR4_5", color=0x614831 }
  PIPE2    = { t="PIPE2",    f="FLOOR4_5", color=0x5f4a32 }
  PIPE4    = { t="PIPE4",    f="FLOOR4_5", color=0x5c4730 }
  PIPE6    = { t="PIPE6",    f="FLOOR4_5", color=0x5c4a31 }
  PLAT1    = { t="PLAT1",    f="FLAT4",    color=0x42403e }
  REDWALL  = { t="REDWALL",  f="FLAT5_3",  color=0x6b0e0e }
  ROCKRED1 = { t="ROCKRED1", f="FLOOR6_1", color=0x4e0401 }

  SHAWN1   = { t="SHAWN1",   f="FLAT23", color=0x727272 }
  SHAWN2   = { t="SHAWN2",   f="FLAT23", color=0x686868 }
  SHAWN3   = { t="SHAWN3",   f="FLAT23", color=0x5d5d5d }

  SKIN2    = { t="SKIN2",    f="SFLR6_4", color=0x9f3939 }
  SKINCUT  = { t="SKINCUT",  f="CEIL5_2", color=0x5d382a }
  SKINEDGE = { t="SKINEDGE", f="SFLR6_4", color=0x9c3737 }
  SKINFACE = { t="SKINFACE", f="SFLR6_4", color=0x943636 }
  SKINLOW  = { t="SKINLOW",  f="FLAT5_2", color=0x825836 }
  SKINMET1 = { t="SKINMET1", f="CEIL5_2", color=0x5d4d3b }
  SKINMET2 = { t="SKINMET2", f="CEIL5_2", color=0x4f3f2e }
  SKINSCAB = { t="SKINSCAB", f="CEIL5_2", color=0x524433 }
  SKINSYMB = { t="SKINSYMB", f="CEIL5_2", color=0x5a4938 }
  SKSNAKE1 = { t="SKSNAKE1", f="SFLR6_1", color=0x97633b }
  SKSNAKE2 = { t="SKSNAKE2", f="SFLR6_4", color=0x832323 }
  SKSPINE1 = { t="SKSPINE1", f="FLAT5_6", color=0xa25a3c }
  SKSPINE2 = { t="SKSPINE2", f="FLAT5_6", color=0x85442b }

  SLADPOIS = { t="SLADPOIS", f="FLOOR7_1", color=0x343322 }
  SLADSKUL = { t="SLADSKUL", f="FLOOR7_1", color=0x2d2d22 }
  SLADWALL = { t="SLADWALL", f="FLOOR7_1", color=0x2a2c22 }

  SP_DUDE1 = { t="SP_DUDE1", f="DEM1_5",  color=0x484a35 }
  SP_DUDE2 = { t="SP_DUDE2", f="DEM1_5",  color=0x494b35 }
  SP_DUDE4 = { t="SP_DUDE4", f="DEM1_5",  color=0x40412d }
  SP_DUDE5 = { t="SP_DUDE5", f="DEM1_5",  color=0x4a4732 }
  SP_FACE1 = { t="SP_FACE1", f="CRATOP2", color=0x63503b }
  SP_HOT1  = { t="SP_HOT1",  f="FLAT5_3", color=0x520000 }
  SP_ROCK1 = { t="SP_ROCK1", f="MFLR8_3", color=0x4c4b42 }

  STARBR2  = { t="STARBR2",  f="FLOOR0_2", color=0x6c4828 }
  STARG1   = { t="STARG1",   f="FLAT23",   color=0x585c40 }
  STARG2   = { t="STARG2",   f="FLAT23",   color=0x585b40 }
  STARG3   = { t="STARG3",   f="FLAT23",   color=0x636557 }
  STARGR1  = { t="STARGR1",  f="FLAT3",    color=0x676767 }
  STARGR2  = { t="STARGR2",  f="FLAT3",    color=0x656464 }
  STARTAN2 = { t="STARTAN2", f="FLOOR4_1", color=0x68523d }
  STARTAN3 = { t="STARTAN3", f="FLOOR4_5", color=0x6b5e51 }

  STONE    = { t="STONE",  f="FLAT5_4", color=0x363636 }
  STONE2   = { t="STONE2", f="MFLR8_1", color=0x363730 }
  STONE3   = { t="STONE3", f="MFLR8_1", color=0x545454 }

  TEKWALL1 = { t="TEKWALL1",  f="CEIL5_1", color=0x2e2c26 }
  TEKWALL4 = { t="TEKWALL4",  f="CEIL5_1", color=0x392e1f }

  WOOD1    = { t="WOOD1",     f="FLAT5_2", color=0x4f3c26 }
  WOOD3    = { t="WOOD3",     f="FLAT5_1", color=0x543f27 }
  WOOD4    = { t="WOOD4",     f="FLAT5_2", color=0x5b4329 }
  WOOD5    = { t="WOOD5",     f="CEIL5_2", color=0x413320 }
  WOODGARG = { t="WOODGARG",  f="FLAT5_2", color=0x463824 }


  -- steps --

  -- keep these sane because they are short (won't tile vertically)
  STEP1    = { t="STEP1",    f="FLOOR7_1", sane=1 }
  STEP2    = { t="STEP2",    f="FLOOR4_6", sane=1 }
  STEP3    = { t="STEP3",    f="CEIL5_1",  sane=1 }
  STEP4    = { t="STEP4",    f="FLAT19",   sane=1 }
  STEP5    = { t="STEP5",    f="FLOOR7_1", sane=1 }
  STEP6    = { t="STEP6",    f="FLAT5",    sane=1 }
  STEPLAD1 = { t="STEPLAD1", f="FLOOR7_1", sane=1 }
  STEPTOP  = { t="STEPTOP",  f="FLOOR7_1", sane=1 }


  -- switches --

  SW1BLUE  = { t="SW1BLUE",  f="FLAT14" }
  SW1BRCOM = { t="SW1BRCOM", f="FLOOR7_1" }
  SW1BRN2  = { t="SW1BRN2",  f="FLOOR0_1" }
  SW1BRNGN = { t="SW1BRNGN", f="FLOOR7_1" }
  SW1BROWN = { t="SW1BROWN", f="FLOOR7_1" }
  SW1COMM  = { t="SW1COMM",  f="FLAT23" }
  SW1COMP  = { t="SW1COMP",  f="CEIL5_1" }
  SW1DIRT  = { t="SW1DIRT",  f="FLOOR7_1" }
  SW1EXIT  = { t="SW1EXIT",  f="FLAT19" }
  SW1GARG  = { t="SW1GARG",  f="CEIL5_2" }
  SW1GRAY  = { t="SW1GRAY",  f="FLAT19" }
  SW1GRAY1 = { t="SW1GRAY1", f="FLAT19" }

  SW1GSTON = { t="SW1GSTON", f="FLOOR7_2" }
  SW1HOT   = { t="SW1HOT",   f="FLOOR1_7" }
  SW1LION  = { t="SW1LION",  f="CEIL5_2" }
  SW1METAL = { t="SW1METAL", f="FLOOR4_8" }
  SW1PIPE  = { t="SW1PIPE",  f="FLOOR4_5" }
  SW1SATYR = { t="SW1SATYR", f="CEIL5_2" }
  SW1SKIN  = { t="SW1SKIN",  f="CRATOP2" }
  SW1SLAD  = { t="SW1SLAD",  f="FLOOR7_1" }
  SW1STON1 = { t="SW1STON1", f="MFLR8_1" }
  SW1STRTN = { t="SW1STRTN", f="FLOOR4_1" }
  SW1VINE  = { t="SW1VINE",  f="FLAT1" }
  SW1WOOD  = { t="SW1WOOD",  f="FLAT5_2" }
  

  -- floors --

  CEIL1_1  = { f="CEIL1_1", t="WOOD1",    color=0x5b442b }
  CEIL1_2  = { f="CEIL1_2", t="METAL",    color=0x433f36 }
  CEIL1_3  = { f="CEIL1_3", t="WOOD1",    color=0x594d3d }
  CEIL3_1  = { f="CEIL3_1", t="STARBR2",  color=0x5b3f20 }
  CEIL3_2  = { f="CEIL3_2", t="STARTAN2", color=0x5a462f }
  CEIL3_3  = { f="CEIL3_3", t="STARTAN2", color=0x58442d }
  CEIL3_4  = { f="CEIL3_4", t="STARTAN2", color=0x7a644e }
  CEIL3_5  = { f="CEIL3_5", t="STONE2",   color=0x323232 }
  CEIL3_6  = { f="CEIL3_6", t="STONE2",   color=0x424242 }

  CEIL4_1  = { f="CEIL4_1", t="COMPBLUE", color=0x00000e }
  CEIL4_2  = { f="CEIL4_2", t="COMPBLUE", color=0x00001f }
  CEIL4_3  = { f="CEIL4_3", t="COMPBLUE", color=0x000027 }
  CEIL5_1  = { f="CEIL5_1", t="COMPSPAN", color=0x151515 }
  CEIL5_2  = { f="CEIL5_2", t="METAL",    color=0x2e2713 }

  COMP01   = { f="COMP01",  t="GRAY1",    color=0x7f7f7f }
  CONS1_1  = { f="CONS1_1", t="COMPWERD", color=0x49494a }
  CONS1_5  = { f="CONS1_5", t="COMPWERD", color=0x49494a }
  CONS1_7  = { f="CONS1_7", t="COMPWERD", color=0x49494a }

  DEM1_1   = { f="DEM1_1", t="MARBLE1",  color=0x4f4e36 }
  DEM1_2   = { f="DEM1_2", t="MARBLE1",  color=0x4d4c35 }
  DEM1_3   = { f="DEM1_3", t="MARBLE1",  color=0x4c4932 }
  DEM1_4   = { f="DEM1_4", t="MARBLE1",  color=0x4b4831 }
  DEM1_5   = { f="DEM1_5", t="MARBLE1",  color=0x343b21 }
  DEM1_6   = { f="DEM1_6", t="MARBLE1",  color=0x41472d }

  FLAT1    = { f="FLAT1",   t="GRAY1",    color=0x3e3e3e }
  FLAT1_1  = { f="FLAT1_1", t="BROWN1",   color=0x533a1c }
  FLAT1_2  = { f="FLAT1_2", t="BROWN1",   color=0x51391c }
  FLAT1_3  = { f="FLAT1_3", t="BROWN1",   color=0x3a2b15 }
  FLAT2    = { f="FLAT2",   t="GRAY1",    color=0x7b7b7b }
  FLAT3    = { f="FLAT3",   t="GRAY4",    color=0x555555 }
  FLAT4    = { f="FLAT4",   t="COMPSPAN", color=0x343434 }

  FLAT5    = { f="FLAT5",   t="BROWNHUG", color=0x5a3f1f }
  FLAT5_1  = { f="FLAT5_1", t="WOOD1",    color=0x503b22 }
  FLAT5_2  = { f="FLAT5_2", t="WOOD1",    color=0x503c24 }
  FLAT5_3  = { f="FLAT5_3", t="REDWALL",  color=0x731212 }
  FLAT5_4  = { f="FLAT5_4", t="STONE",    color=0x565756 }
  FLAT5_5  = { f="FLAT5_5", t="BROWN1",   color=0x5e4934 }
  FLAT5_6  = { f="FLAT5_6", t="CRACKLE4", color=0x553c20 }

  FLAT8    = { f="FLAT8",  t="STARBR2",  color=0x714a27 }
  FLAT9    = { f="FLAT9",  t="GRAY4",    color=0x5a5a5a }
  FLAT10   = { f="FLAT10", t="BROWNHUG", color=0x251b0b } -- better in DOOM2
  FLAT14   = { f="FLAT14", t="COMPBLUE", color=0x00004a }
  FLAT17   = { f="FLAT17", t="GRAY1",    color=0x8c8c8c }
  FLAT18   = { f="FLAT18", t="GRAY1",    color=0x676767 }
  FLAT19   = { f="FLAT19", t="GRAY1",    color=0x666666 }
  FLAT20   = { f="FLAT20", t="SHAWN2",   color=0x676767 }
  FLAT22   = { f="FLAT22", t="SHAWN2",   color=0x202071 }
  FLAT23   = { f="FLAT23", t="SHAWN2",   color=0x666666 }

  FLOOR0_1 = { f="FLOOR0_1", t="STARTAN2", color=0x6b543f }
  FLOOR0_2 = { f="FLOOR0_2", t="STARBR2",  color=0x714a27 }
  FLOOR0_3 = { f="FLOOR0_3", t="GRAY1",    color=0x5b5b5b }
  FLOOR0_5 = { f="FLOOR0_5", t="GRAY1",    color=0x555555 }
  FLOOR0_6 = { f="FLOOR0_6", t="GRAY1",    color=0x555555 }
  FLOOR0_7 = { f="FLOOR0_7", t="GRAY1",    color=0x565656 }
  FLOOR1_1 = { f="FLOOR1_1", t="COMPBLUE", color=0x00005a }
  FLOOR1_6 = { f="FLOOR1_6", t="REDWALL",  color=0x750000 }
  FLOOR1_7 = { f="FLOOR1_7", t="REDWALL",  color=0x9e2828 }
  FLOOR3_3 = { f="FLOOR3_3", t="BROWN1",   color=0x71634c }

  FLOOR4_1 = { f="FLOOR4_1", t="STARTAN2", color=0x69523a }
  FLOOR4_5 = { f="FLOOR4_5", t="STARTAN2", color=0x695339 }
  FLOOR4_6 = { f="FLOOR4_6", t="STARTAN2", color=0x644f3a }
  FLOOR4_8 = { f="FLOOR4_8", t="METAL1",   color=0x30302f }
  FLOOR5_1 = { f="FLOOR5_1", t="METAL1",   color=0x343028 }
  FLOOR5_2 = { f="FLOOR5_2", t="BROWNHUG", color=0x573e1e }
  FLOOR5_3 = { f="FLOOR5_3", t="BROWNHUG", color=0x563e1e }
  FLOOR5_4 = { f="FLOOR5_4", t="BROWNHUG", color=0x583e1e }
  FLOOR6_1 = { f="FLOOR6_1", t="REDWALL",  color=0x610000 }
  FLOOR7_1 = { f="FLOOR7_1", t="BROWNHUG", color=0x3f2f16 }
  FLOOR7_2 = { f="FLOOR7_2", t="MARBLE1",  color=0x353b22 }

  GATE1    = { f="GATE1", t="METAL", color=0x5d0905 }
  GATE2    = { f="GATE2", t="METAL", color=0x620a06 }
  GATE3    = { f="GATE3", t="METAL", color=0x5e0905 }
  GATE4    = { f="GATE4", t="METAL", color=0x55534f }
  
  MFLR8_1  = { f="MFLR8_1", t="STONE2",   color=0x343434 }
  MFLR8_2  = { f="MFLR8_2", t="BROWNHUG", color=0x332b23 }
  MFLR8_3  = { f="MFLR8_3", t="SP_ROCK1", color=0x888786 }

  SFLR6_1  = { f="SFLR6_1", t="SKSNAKE1", color=0x96633b }
  SFLR6_4  = { f="SFLR6_4", t="SKSNAKE2", color=0x822323 }
  SFLR7_1  = { f="SFLR7_1", t="SKSNAKE1", color=0x965b3c }
  SFLR7_4  = { f="SFLR7_4", t="SKSNAKE1", color=0x965b3d }
  
  STEP_F1  = { f="STEP1", t="SHAWN2", color=0x363022 }
  STEP_F2  = { f="STEP2", t="SHAWN2", color=0x383224 }

  TLITE6_1 = { f="TLITE6_1", t="METAL", color=0x2d2825 }
  TLITE6_4 = { f="TLITE6_4", t="METAL", color=0x433824 }
  TLITE6_5 = { f="TLITE6_5", t="METAL", color=0x2e1313 }
  TLITE6_6 = { f="TLITE6_6", t="METAL", color=0x43341d }


  -- rails --

  BRNSMAL1 = { t="BRNSMAL1", rail_h=64,  line_flags=1 }
  BRNSMAL2 = { t="BRNSMAL2", rail_h=64,  line_flags=1 }
  BRNSMALC = { t="BRNSMALC", rail_h=64,  line_flags=1 }

  MIDBRN1  = { t="MIDBRN1",  rail_h=128, line_flags=1 }
  MIDGRATE = { t="MIDGRATE", rail_h=128, line_flags=1 }


  -- liquid stuff (using new patches)
  WFALL1   = { t="GSTFONT1", f="FWATER1", sane=1 }
  FWATER1  = { t="GSTFONT1", f="FWATER1", sane=1 }

  LFALL1   = { t="FIREMAG1", f="LAVA1", sane=1 }
  LAVA1    = { t="FIREMAG1", f="LAVA1", sane=1 }


  -- other --

  O_PILL   = { t="CEMENT1",  f="O_PILL",   sane=1 }
  O_BOLT   = { t="CEMENT2",  f="O_BOLT",   sane=1 }
  O_RELIEF = { t="CEMENT3",  f="O_RELIEF", sane=1 }
  O_CARVE  = { t="CEMENT4",  f="O_CARVE",  sane=1 }
  O_NEON   = { t="CEMENT6",  f="CEIL5_1",  sane=1 }
  O_MISC   = { t="CEMENT5",  f="CEIL5_1",  sane=1 }


  -- Missing stuff:
  --   CEMENT#  : used by OBLIGE for various logos
  --   SKY1/2/3 : not very useful
  --   ZZZFACE# : not generally useful
  --
  -- Note too that STEP1/2 are ambiguous, the flats are quite
  -- different to the textures, hence renamed the flats as
  -- STEP_F1 and STEP_F2.

} -- end of DOOM.MATERIALS



DOOM1.MATERIALS =
{
  -- walls --

  ASHWALL  = { t="ASHWALL",  f="FLOOR6_2", color=0x242424 }
  BROVINE  = { t="BROVINE",  f="FLOOR0_1", color=0x434824 }
  BRNPOIS2 = { t="BRNPOIS2", f="FLOOR7_1", color=0x3d3119 }
  BROWNWEL = { t="BROWNWEL", f="FLOOR7_1", color=0x3b2d15 }

  COMP2    = { t="COMP2",    f="CEIL5_1",  color=0x21201c }
  COMPOHSO = { t="COMPOHSO", f="FLOOR7_1", color=0x1e1821 }
  COMPTILE = { t="COMPTILE", f="CEIL5_1",  color=0x101034 }
  COMPUTE1 = { t="COMPUTE1", f="FLAT19",   color=0x605f60 }
  COMPUTE2 = { t="COMPUTE2", f="CEIL5_1",  color=0x20201c }
  COMPUTE3 = { t="COMPUTE3", f="CEIL5_1",  color=0x493521 }

  DOORHI   = { t="DOORHI",   f="FLAT19", color=0x7c7066 }
  GRAYDANG = { t="GRAYDANG", f="FLAT19", color=0x6f6666 }
  ICKDOOR1 = { t="ICKDOOR1", f="FLAT19", color=0x6d6f63 }
  ICKWALL6 = { t="ICKWALL6", f="FLAT18", color=0x60615b }

  LITE2    = { t="LITE2",    f="FLOOR0_1" }
  LITE4    = { t="LITE4",    f="FLAT19" }
  LITE96   = { t="LITE96",   f="FLOOR7_1" }
  LITEBLU2 = { t="LITEBLU2", f="FLAT23" }
  LITEBLU3 = { t="LITEBLU3", f="FLAT23" }
  LITEMET  = { t="LITEMET",  f="FLOOR4_8" }
  LITERED  = { t="LITERED",  f="FLOOR1_6" }
  LITESTON = { t="LITESTON", f="MFLR8_1" }

  NUKESLAD = { t="NUKESLAD", f="FLOOR7_1", color=0x2a2e22 }
  PLANET1  = { t="PLANET1",  f="FLAT23",   color=0x423b38 }
  REDWALL1 = { t="REDWALL1", f="FLOOR1_6", color=0xc50000 }
  SKINBORD = { t="SKINBORD", f="FLAT5_5",  color=0x8f5c4d }
  SKINTEK1 = { t="SKINTEK1", f="FLAT5_5",  color=0x604937 }
  SKINTEK2 = { t="SKINTEK2", f="FLAT5_5",  color=0x514130 }
  SKULWAL3 = { t="SKULWAL3", f="FLAT5_6",  color=0x4e311d }
  SKULWALL = { t="SKULWALL", f="FLAT5_6",  color=0x4e3d2b }
  SLADRIP1 = { t="SLADRIP1", f="FLOOR7_1" }

  SP_DUDE3 = { t="SP_DUDE3", f="DEM1_5",   color=0x464631 }
  SP_DUDE6 = { t="SP_DUDE6", f="DEM1_5",   color=0x4b4731 }
  SP_ROCK1 = { t="SP_ROCK1", f="MFLR8_3",  color=0x4c4b42 }
  STARTAN1 = { t="STARTAN1", f="FLOOR4_1", color=0x6a543f }
  STONGARG = { t="STONGARG", f="MFLR8_1",  color=0x33352d }
  STONPOIS = { t="STONPOIS", f="FLAT5_4",  color=0x59554d }
  TEKWALL2 = { t="TEKWALL2", f="CEIL5_1",  color=0x37342a }
  TEKWALL3 = { t="TEKWALL3", f="CEIL5_1",  color=0x323128 }
  TEKWALL5 = { t="TEKWALL5", f="CEIL5_1",  color=0x35322a }
  WOODSKUL = { t="WOODSKUL", f="FLAT5_2",  color=0x4f3b25 }


  -- switches --

  SW1BRN1  = { t="SW1BRN1",  f="FLOOR0_1" }
  SW1STARG = { t="SW1STARG", f="FLAT23" }
  SW1STONE = { t="SW1STONE", f="FLAT1" }
  SW1STON2 = { t="SW1STON2", f="MFLR8_1" }


  -- floors --

  FLAT5_6  = { f="FLAT5_6", t="SKULWALL", color=0x553c20 }
  FLAT5_7  = { f="FLAT5_7", t="ASHWALL",  color=0x353535 }
  FLAT5_8  = { f="FLAT5_8", t="ASHWALL",  color=0x2c2c2c }
  FLOOR6_2 = { f="FLOOR6_2", t="ASHWALL", color=0x292929 }
  MFLR8_4  = { f="MFLR8_4",  t="ASHWALL", color=0x292929 }


  -- rails --

  BRNBIGC  = { t="BRNBIGC",  rail_h=128, line_flags=1 }

  MIDVINE1 = { t="MIDVINE1", rail_h=128 }
  MIDVINE2 = { t="MIDVINE2", rail_h=128 }


  -- liquid stuff (using new patches)
  BFALL1   = { t="BLODGR1",  f="BLOOD1", sane=1 }
  BLOOD1   = { t="BLODGR1",  f="BLOOD1", sane=1 }

  SFALL1   = { t="SLADRIP1", f="NUKAGE1", sane=1 }
  NUKAGE1  = { t="SLADRIP1", f="NUKAGE1", sane=1 }


  -- FIXME: HACK HACK HACK
  BRICKLIT = { t="LITEMET",  f="CEIL5_1" }
  PIPEWAL1 = { t="COMPWERD", f="CEIL5_1" }
}


DOOM2.MATERIALS =
{
  -- walls --

  ASHWALL  = { t="ASHWALL2", f="MFLR8_4", color=0x1d1d1d }  -- compatibility name
  ASHWALL3 = { t="ASHWALL3", f="FLAT10",  color=0x1b1208 }
  ASHWALL4 = { t="ASHWALL4", f="FLAT10",  color=0x1b1208 }
  ASHWALL6 = { t="ASHWALL6", f="RROCK20", color=0x3d402d }
  ASHWALL7 = { t="ASHWALL7", f="RROCK18", color=0x433526 }
  BIGBRIK1 = { t="BIGBRIK1", f="RROCK14", color=0x302110 }
  BIGBRIK2 = { t="BIGBRIK2", f="MFLR8_1", color=0x313131 }
  BIGBRIK3 = { t="BIGBRIK3", f="RROCK14", color=0x362714 }
  BLAKWAL1 = { t="BLAKWAL1", f="CEIL5_1", color=0x020202 }
  BLAKWAL2 = { t="BLAKWAL2", f="CEIL5_1", color=0x040404 }

  BRICK1   = { t="BRICK1",   f="RROCK10",  color=0x503b21 }
  BRICK2   = { t="BRICK2",   f="RROCK10",  color=0x473322 }
  BRICK3   = { t="BRICK3",   f="FLAT5_5",  color=0x54412e }
  BRICK4   = { t="BRICK4",   f="FLAT5_5",  color=0x594533 }
  BRICK5   = { t="BRICK5",   f="RROCK10",  color=0x4c381f }
  BRICK6   = { t="BRICK6",   f="FLOOR5_4", color=0x584128 }
  BRICK7   = { t="BRICK7",   f="FLOOR5_4", color=0x553f26 }
  BRICK8   = { t="BRICK8",   f="FLOOR5_4", color=0x55402b }
  BRICK9   = { t="BRICK9",   f="FLOOR5_4", color=0x523e29 }
  BRICK10  = { t="BRICK10",  f="SLIME13",  color=0x423f28 }
  BRICK11  = { t="BRICK11",  f="FLAT5_3",  color=0x4f0c08 }
  BRICK12  = { t="BRICK12",  f="FLOOR0_1", color=0x69523f }
  BRICKLIT = { t="BRICKLIT", f="RROCK10",  color=0x594024 }

  BRONZE1  = { t="BRONZE1",  f="FLOOR7_1", color=0x3a2e1b }
  BRONZE2  = { t="BRONZE2",  f="FLOOR7_1", color=0x352b19 }
  BRONZE3  = { t="BRONZE3",  f="FLOOR7_1", color=0x362b19 }
  BRONZE4  = { t="BRONZE4",  f="FLOOR7_1", color=0x3f331e }
  BRWINDOW = { t="BRWINDOW", f="RROCK10",  color=0x47351f }
  BSTONE1  = { t="BSTONE1",  f="RROCK11",  color=0x533f28 }
  BSTONE2  = { t="BSTONE2",  f="RROCK12",  color=0x48351d }
  BSTONE3  = { t="BSTONE3",  f="RROCK12",  color=0x4d371f }

  CEMENT9  = { t="CEMENT9",  f="FLAT19",  color=0x746f59 }
  CRACKLE2 = { t="CRACKLE2", f="RROCK01", color=0x74240b }
  CRACKLE4 = { t="CRACKLE4", f="RROCK02", color=0x55472a }
  CRATE3   = { t="CRATE3",   f="CRATOP1", color=0x585044 }
  MARBFAC4 = { t="MARBFAC4", f="DEM1_5",  color=0x4f5147 }
  MARBGRAY = { t="MARBGRAY", f="DEM1_5",  color=0x51524e }

  METAL2   = { t="METAL2",   f="CEIL5_2", color=0x221f18 }
  METAL3   = { t="METAL3",   f="CEIL5_2", color=0x242017 }
  METAL4   = { t="METAL4",   f="CEIL5_2", color=0x1e1b14 }
  METAL5   = { t="METAL5",   f="CEIL5_2", color=0x232019 }
  METAL6   = { t="METAL6",   f="CEIL5_2", color=0x2f2c1e }
  METAL7   = { t="METAL7",   f="CEIL5_2", color=0x2f2c1e }

  MODWALL1 = { t="MODWALL1", f="MFLR8_4", color=0x261e13 }
  MODWALL2 = { t="MODWALL2", f="MFLR8_4", color=0x100e0c }
  MODWALL3 = { t="MODWALL3", f="FLAT19",  color=0x2d2d2d }
  MODWALL4 = { t="MODWALL4", f="FLAT18",  color=0x404040 }

  PANBLACK = { t="PANBLACK", f="RROCK09", color=0x46321a }
  PANBLUE  = { t="PANBLUE",  f="RROCK09", color=0x443127 }
  PANBOOK  = { t="PANBOOK",  f="RROCK09", color=0x3b2c1a }
  PANRED   = { t="PANRED",   f="RROCK09", color=0x543118 }
  PANBORD1 = { t="PANBORD1", f="RROCK09", color=0x493620 }
  PANBORD2 = { t="PANBORD2", f="RROCK09", color=0x49361f }
  PANCASE1 = { t="PANCASE1", f="RROCK09", color=0x513c22 }
  PANCASE2 = { t="PANCASE2", f="RROCK09", color=0x574026 }

  PANEL1   = { t="PANEL1",   f="RROCK09", color=0x42361e }
  PANEL2   = { t="PANEL2",   f="RROCK09", color=0x4d3822 }
  PANEL3   = { t="PANEL3",   f="RROCK09", color=0x433a21 }
  PANEL4   = { t="PANEL4",   f="RROCK09", color=0x533d23 }
  PANEL5   = { t="PANEL5",   f="RROCK09", color=0x493720 }
  PANEL6   = { t="PANEL6",   f="RROCK09", color=0x5c4631 }
  PANEL7   = { t="PANEL7",   f="RROCK09", color=0x5c4630 }
  PANEL8   = { t="PANEL8",   f="RROCK09", color=0x55402b }
  PANEL9   = { t="PANEL9",   f="RROCK09", color=0x513d28 }

  PIPES    = { t="PIPES",    f="FLOOR3_3", color=0x7e7359 }
  PIPEWAL1 = { t="PIPEWAL1", f="RROCK03",  color=0x3b2f1e }
  PIPEWAL2 = { t="PIPEWAL2", f="RROCK03",  color=0x362d1e }
  ROCK1    = { t="ROCK1",    f="RROCK13",  color=0x262822 }
  ROCK2    = { t="ROCK2",    f="GRNROCK",  color=0x26281e }
  ROCK3    = { t="ROCK3",    f="RROCK13",  color=0x252524 }
  ROCK4    = { t="ROCK4",    f="FLOOR0_2", color=0x855630 }
  ROCK5    = { t="ROCK5",    f="RROCK09",  color=0x644b31 }

  SILVER1  = { t="SILVER1",  f="FLAT23",  color=0x6e6e6e }
  SILVER2  = { t="SILVER2",  f="FLAT22",  color=0x4e4e65 }
  SILVER3  = { t="SILVER3",  f="FLAT23",  color=0x585754 }
  SK_LEFT  = { t="SK_LEFT",  f="FLAT5_6", color=0x69301f }
  SK_RIGHT = { t="SK_RIGHT", f="FLAT5_6", color=0x682f1e }
  SLOPPY1  = { t="SLOPPY1",  f="FLAT5_6", color=0x682e1d }
  SLOPPY2  = { t="SLOPPY2",  f="FLAT5_6", color=0x602e1c }
  SP_DUDE7 = { t="SP_DUDE7", f="FLOOR5_4", color=0x513322 }
  SP_FACE2 = { t="SP_FACE2", f="FLAT5_6", color=0x81271d }

  SPACEW2  = { t="SPACEW2",  f="CEIL3_3", color=0x58442e }
  SPACEW3  = { t="SPACEW3",  f="CEIL5_1", color=0x1b1b19 }
  SPACEW4  = { t="SPACEW4",  f="SLIME16", color=0x6d5b44 }

  SPCDOOR1 = { t="SPCDOOR1", f="FLOOR0_1" }
  SPCDOOR2 = { t="SPCDOOR2", f="FLAT19" }
  SPCDOOR3 = { t="SPCDOOR3", f="FLAT19" }
  SPCDOOR4 = { t="SPCDOOR4", f="FLOOR0_1" }

  STONE4   = { t="STONE4",   f="FLAT5_4", color=0x505050 }
  STONE5   = { t="STONE5",   f="FLAT5_4", color=0x4b4b4b }
  STONE6   = { t="STONE6",   f="RROCK11", color=0x4f3a24 }
  STONE7   = { t="STONE7",   f="RROCK11", color=0x4a3722 }
  STUCCO   = { t="STUCCO",   f="FLAT5_5", color=0x584430 }
  STUCCO1  = { t="STUCCO1",  f="FLAT5_5", color=0x54412f }
  STUCCO2  = { t="STUCCO2",  f="FLAT5_5", color=0x4b3a2a }
  STUCCO3  = { t="STUCCO3",  f="FLAT5_5", color=0x523f2d }

  TANROCK2 = { t="TANROCK2", f="FLOOR3_3", color=0x876f59 }
  TANROCK3 = { t="TANROCK3", f="RROCK11",  color=0x5a4227 }
  TANROCK4 = { t="TANROCK4", f="RROCK09",  color=0x513d28 }
  TANROCK5 = { t="TANROCK5", f="RROCK18",  color=0x3d2b16 }
  TANROCK7 = { t="TANROCK7", f="RROCK15",  color=0x543d26 }
  TANROCK8 = { t="TANROCK8", f="RROCK09",  color=0x6d4826 }

  TEKBRON1 = { t="TEKBRON1", f="FLOOR0_1", color=0x59442f }
  TEKBRON2 = { t="TEKBRON2", f="FLOOR0_1", color=0x5c4631 }
  TEKGREN1 = { t="TEKGREN1", f="RROCK20",  color=0x3b3b2c }
  TEKGREN2 = { t="TEKGREN2", f="RROCK20",  color=0x424636 }
  TEKGREN3 = { t="TEKGREN3", f="RROCK20",  color=0x3f4337 }
  TEKGREN4 = { t="TEKGREN4", f="RROCK20",  color=0x2e3123 }
  TEKGREN5 = { t="TEKGREN5", f="RROCK20",  color=0x4d513b }
  TEKLITE  = { t="TEKLITE",  f="FLOOR5_2", color=0x45341c }
  TEKLITE2 = { t="TEKLITE2", f="FLOOR5_2", color=0x44321b }
  TEKWALL6 = { t="TEKWALL6", f="CEIL5_1",  color=0x393228 }

  WOOD6    = { t="WOOD6",    f="FLAT5_2", color=0x3e2d1c }
  WOOD7    = { t="WOOD7",    f="FLAT5_2", color=0x3b2a1a }
  WOOD8    = { t="WOOD8",    f="FLAT5_2", color=0x3f2d1c }
  WOOD9    = { t="WOOD9",    f="FLAT5_2", color=0x3d2b1a }
  WOOD10   = { t="WOOD10",   f="FLAT5_1", color=0x3f2d1c }
  WOOD12   = { t="WOOD12",   f="FLAT5_2", color=0x513d24 }
  WOODVERT = { t="WOODVERT", f="FLAT5_2", color=0x3b2c14 }
  WOODMET1 = { t="WOODMET1", f="CEIL5_2", color=0x302518 }
  WOODMET2 = { t="WOODMET2", f="CEIL5_2", color=0x2f2518 }
  WOODMET3 = { t="WOODMET3", f="CEIL5_2", color=0x332215 }
  WOODMET4 = { t="WOODMET4", f="CEIL5_2", color=0x3c1d13 }

  ZIMMER1  = { t="ZIMMER1",  f="RROCK20", color=0x343922 }
  ZIMMER2  = { t="ZIMMER2",  f="RROCK20", color=0x343922 }
  ZIMMER3  = { t="ZIMMER3",  f="RROCK18", color=0x2f230e }
  ZIMMER4  = { t="ZIMMER4",  f="RROCK18", color=0x2f230e }
  ZIMMER5  = { t="ZIMMER5",  f="RROCK16", color=0x453420 }
  ZIMMER7  = { t="ZIMMER7",  f="RROCK20", color=0x3d4328 }
  ZIMMER8  = { t="ZIMMER8",  f="MFLR8_3", color=0x5d5a4f }
                          
  ZDOORB1  = { t="ZDOORB1",  f="FLAT23" }
  ZDOORF1  = { t="ZDOORF1",  f="FLAT23" }
  ZELDOOR  = { t="ZELDOOR",  f="FLAT23" }

  ZZWOLF1  = { t="ZZWOLF1",  f="FLAT18",  color=0x717171 }
  ZZWOLF2  = { t="ZZWOLF2",  f="FLAT18",  color=0x665c50 }
  ZZWOLF3  = { t="ZZWOLF3",  f="FLAT18",  color=0x89504b }
  ZZWOLF4  = { t="ZZWOLF4",  f="FLAT18",  color=0x7a6657 }
  ZZWOLF5  = { t="ZZWOLF5",  f="FLAT5_1", color=0x5d4020 }
  ZZWOLF6  = { t="ZZWOLF6",  f="FLAT5_1", color=0x875636 }
  ZZWOLF7  = { t="ZZWOLF7",  f="FLAT5_1", color=0x795e3f }
  ZZWOLF9  = { t="ZZWOLF9",  f="FLAT14",  color=0x00006a }
  ZZWOLF10 = { t="ZZWOLF10", f="FLAT23",  color=0x8c8c8c }
  ZZWOLF11 = { t="ZZWOLF11", f="FLAT5_3", color=0x4c1212 }
  ZZWOLF12 = { t="ZZWOLF12", f="FLAT5_3", color=0x6f4543 }
  ZZWOLF13 = { t="ZZWOLF13", f="FLAT5_3", color=0x673718 }


  -- switches --

  SW1BRIK  = { t="SW1BRIK",  f="MFLR8_1" }
  SW1MARB  = { t="SW1MARB",  f="DEM1_5" }
  SW1MET2  = { t="SW1MET2",  f="CEIL5_2" }
  SW1MOD1  = { t="SW1MOD1",  f="MFLR8_4" }
  SW1PANEL = { t="SW1PANEL", f="CEIL1_1" }
  SW1ROCK  = { t="SW1ROCK",  f="RROCK13" }
  SW1SKULL = { t="SW1SKULL", f="FLAT5_6" }
  SW1STON6 = { t="SW1STON6", f="RROCK11" }
  SW1TEK   = { t="SW1TEK",   f="RROCK20" }
  SW1WDMET = { t="SW1WDMET", f="CEIL5_2" }
  SW1ZIM   = { t="SW1ZIM",   f="RROCK20" }


  -- floors --

  CONS1_1  = { f="CONS1_1", t="GRAY5", color=0x49494a }
  CONS1_5  = { f="CONS1_5", t="GRAY5", color=0x49494a }
  CONS1_7  = { f="CONS1_7", t="GRAY5", color=0x49494a }

  FLAT1_1  = { f="FLAT1_1",  t="BSTONE2",  color=0x533a1c }
  FLAT1_2  = { f="FLAT1_2",  t="BSTONE2",  color=0x51391c }
  FLAT1_3  = { f="FLAT1_3",  t="BSTONE2",  color=0x3a2b15 }
  FLAT10   = { f="FLAT10",   t="ASHWALL4", color=0x251b0b }
  FLAT22   = { f="FLAT22",   t="SILVER2",  color=0x202071 }
  FLAT5_5  = { f="FLAT5_5",  t="STUCCO",   color=0x5e4934 }
  FLAT5_7  = { f="FLAT5_7",  t="ASHWALL2", color=0x353535 }
  FLAT5_8  = { f="FLAT5_8",  t="ASHWALL2", color=0x2c2c2c }
  FLOOR6_2 = { f="FLOOR6_2", t="ASHWALL2", color=0x292929 }

  GRASS1   = { f="GRASS1",   t="ZIMMER2",  color=0x2a3219 }
  GRASS2   = { f="GRASS2",   t="ZIMMER2",  color=0x2b3319 }
  GRNROCK  = { f="GRNROCK",  t="ROCK2",    color=0x26291e }
  GRNLITE1 = { f="GRNLITE1", t="TEKGREN2", color=0x6d725b }
  MFLR8_4  = { f="MFLR8_4",  t="ASHWALL2", color=0x292929 }

  RROCK01  = { f="RROCK01", t="CRACKLE2", color=0x740000 }
  RROCK02  = { f="RROCK02", t="CRACKLE4", color=0x765a2e }
  RROCK03  = { f="RROCK03", t="ASHWALL3", color=0x201c17 }
  RROCK04  = { f="RROCK04", t="ASHWALL3", color=0x282016 }
  RROCK05  = { f="RROCK05", t="ROCKRED1", color=0x4c2117 }  -- animated
  RROCK09  = { f="RROCK09", t="TANROCK4", color=0x533f2a }
  RROCK10  = { f="RROCK10", t="BRICK1",   color=0x503b21 }
  RROCK11  = { f="RROCK11", t="BSTONE1",  color=0x543f28 }
  RROCK12  = { f="RROCK12", t="BSTONE2",  color=0x48351d }

  RROCK13  = { f="RROCK13", t="ROCK3",    color=0x252524 }
  RROCK14  = { f="RROCK14", t="BIGBRIK1", color=0x302110 }
  RROCK15  = { f="RROCK15", t="TANROCK7", color=0x543d26 }
  RROCK16  = { f="RROCK16", t="ZIMMER5",  color=0x4a3723 }
  RROCK17  = { f="RROCK17", t="ZIMMER3",  color=0x322918 }
  RROCK18  = { f="RROCK18", t="ZIMMER3",  color=0x302818 }
  RROCK19  = { f="RROCK19", t="ZIMMER2",  color=0x2a2c19 }
  RROCK20  = { f="RROCK20", t="ZIMMER7",  color=0x42482d }

  SLIME09  = { f="SLIME09", t="ROCKRED1", color=0x4c2117 } -- animated
  SLIME13  = { f="SLIME13", t="BRICK10",  color=0x423f28 }
  SLIME14  = { f="SLIME14", t="METAL2",   color=0x413c36 }
  SLIME15  = { f="SLIME15", t="COMPSPAN", color=0x3e3a37 }
  SLIME16  = { f="SLIME16", t="SPACEW4",  color=0x6d5b44 }


  -- rails --

  DBRAIN1  = { t="DBRAIN1",  rail_h=32 }

  MIDBARS1 = { t="MIDBARS1", rail_h=128, line_flags=1 }
  MIDBARS3 = { t="MIDBARS3", rail_h=72,  line_flags=1 }
  MIDBRONZ = { t="MIDBRONZ", rail_h=128, line_flags=1 }
  MIDSPACE = { t="MIDSPACE", rail_h=128, line_flags=1 }

  -- scaled MIDVINE2 from FreeDoom
  FMIDVINE = { t="SP_DUDE8", rail_h=128 }


  -- liquid stuff (keep them recognisable)
  BFALL1   = { t="BFALL1",  f="BLOOD1", sane=1 }
  BLOOD1   = { t="BFALL1",  f="BLOOD1", sane=1 }

  SFALL1   = { t="SFALL1",  f="NUKAGE1", sane=1 }
  NUKAGE1  = { t="SFALL1",  f="NUKAGE1", sane=1 }

  KFALL1   = { t="BLODRIP1", f="SLIME01", sane=1 }  -- new patches
  KFALL5   = { t="BLODRIP1", f="SLIME05", sane=1 }
  SLIME01  = { t="BLODRIP1", f="SLIME01", sane=1 }
  SLIME05  = { t="BLODRIP1", f="SLIME05", sane=1 }
}



DOOM.LIQUIDS =
{
  water  = { mat="FWATER1", color=0x00002a, light=0.65, special=0 }
  blood  = { mat="BLOOD1",  color=0x580000, light=0.65, special=0 }
  nukage = { mat="NUKAGE1", color=0x152e0d, light=0.65, special=16, damage=20 }
  lava   = { mat="LAVA1",   color=0x641c05, light=0.75, special=16, damage=20 }

  -- Doom II only --
  slime  = { mat="SLIME01", color=0x2b1e0c, light=0.65, special=16, damage=20 }
}


DOOM.STEPS =  -- OLD ??
{
  step1 = { step="STEP1", side="BROWNHUG", top="FLOOR7_1" }
  step2 = { step="STEP2", side="BROWN1",   top="FLAT5" }
  step3 = { step="STEP3", side="COMPSPAN", top="CEIL5_1" }
  step4 = { step="STEP4", side="STONE",    top="FLAT5_4" }

  -- Doom II only --
  step4b = { step="STEP4", side="STONE4",   top="FLAT1" }
  step6  = { step="STEP6", side="STUCCO",   top="FLAT5" }
}


DOOM.LIFTS =  -- OLD CRUD
{
  shiny = 
  {
    lift="SUPPORT2", top="FLAT20",
    walk_kind=88, switch_kind=62,
  }

  rusty = 
  {
    lift="SUPPORT3", top="CEIL5_2",
    walk_kind=88, switch_kind=62,
  }

  platform = 
  {
    lift="PLAT1", top="FLAT23",
    walk_kind=88, switch_kind=62,
  }

  spine = 
  {
    lift="SKSPINE1", top="FLAT23",
    walk_kind=88, switch_kind=62,
  }
}

OLD_LIFT_JUNK =
{
  slow = { kind=62,  walk=88  }
  fast = { kind=123, walk=120 }
}


DOOM.PICTURES =  -- Note: UNUSED STUFF
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
  }

  compsta2 =
  {
    pic="COMPSTA2", width=128, height=52,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8,
  }

  compsta1_blink =
  {
    pic="COMPSTA1", width=128, height=52,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8, sec_kind=1,
  }

  compsta2_blink =
  {
    pic="COMPSTA2", width=128, height=52,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8, sec_kind=1,
  }

  lite5 =
  {
    count=3, gap=32,
    pic="LITE5", width=16, height=64,
    x_offset=0, y_offset=0,
    side="DOORSTOP", floor="SHAWN2", depth=8, 
    light=0.9, sec_kind=8,  -- oscillate
  }

  lite5_05blink =
  {
    count=3, gap=32,
    pic="LITE5", width=16, height=64,
    x_offset=0, y_offset=0,
    side="DOORSTOP", floor="SHAWN2", depth=8, 
    light=0.9, sec_kind=12,  -- 0.5 second sync
  }

  lite5_10blink =
  {
    count=4, gap=24,
    pic="LITE5", width=16, height=48,
    x_offset=0, y_offset=0,
    side="DOORSTOP", floor="SHAWN2", depth=8, 
    light=0.9, sec_kind=13,  -- 1.0 second sync
  }

  liteblu4 =
  {
    count=3, gap=32,
    pic="LITEBLU4", width=16, height=64,
    x_offset=0, y_offset=0,
    side="LITEBLU4", floor="FLAT14", depth=8, 
    light=0.9, sec_kind=8,
  }

  liteblu4_05sync =
  {
    count=3, gap=32,
    pic="LITEBLU4", width=16, height=64,
    x_offset=0, y_offset=0,
    side="LITEBLU4", floor="FLAT14", depth=8, 
    light=0.9, sec_kind=12,
  }

  liteblu4_10sync =
  {
    count=4, gap=32,
    pic="LITEBLU4", width=16, height=48,
    x_offset=0, y_offset=0,
    side="LITEBLU4", floor="FLAT14", depth=8, 
    light=0.9, sec_kind=13,
  }

  litered =
  {
    count=3, gap=32,
    pic="LITERED", width=16, height=64,
    x_offset=0, y_offset=0,
    side="DOORSTOP", floor="SHAWN2", depth=16, 
    light=0.9, sec_kind=8,  -- oscillate
  }

  redwall =
  {
    count=2, gap=48,
    pic="REDWALL", width=16, height=128, raise=20,
    x_offset=0, y_offset=0,
    side="REDWALL", floor="FLAT5_3", depth=8, 
    light=0.99, sec_kind=8,
  }

  silver3 =
  {
    count=1, gap=32,
    pic="SILVER3", width=64, height=96,
    x_offset=0, y_offset=16,
    side="DOORSTOP", floor="SHAWN2", depth=8, 
    light=0.8,
  }

  shawn1 =
  {
    count=1,
    pic="SHAWN1", width=128, height=72,
    x_offset=-4, y_offset=0,
    side="DOORSTOP", floor="SHAWN2", depth=8, 
  }

  pill =
  {
    count=1,
    pic="O_PILL", width=128, height=32, raise=16,
    x_offset=0, y_offset=0,
    side="METAL", floor="CEIL5_2", depth=8, 
    light=0.7,
  }

  carve =
  {
    count=1,
    pic="O_CARVE", width=64, height=64,
    x_offset=0, y_offset=0,
    side="METAL", floor="CEIL5_2", depth=8, 
    light=0.7,
  }

  neon =
  {
    count=1,
    pic="O_NEON", width=128, height=128,
    x_offset=0, y_offset=0,
    side="METAL", floor="CEIL5_2", depth=16, 
    light=0.99, sec_kind=8,
  }

  tekwall1 =
  {
    count=1,
    pic="TEKWALL1", width=160, height=80,
    x_offset=0, y_offset=24,
    side="METAL", floor="CEIL5_2", depth=8, 
    special=48, -- scroll left
    light=0.7,
  }

  tekwall4 =
  {
    count=1,
    pic="TEKWALL4", width=128, height=80,
    x_offset=0, y_offset=24,
    side="METAL", floor="CEIL5_2", depth=8, 
    special=48, -- scroll left
    light=0.7,
  }

  pois1 =
  {
    count=2, gap=32,
    pic="BRNPOIS", width=64, height=56,
    x_offset=0, y_offset=48,
    side="METAL", floor="CEIL5_2",
    depth=8, light=0.5,
  }

  pois2 =
  {
    count=1, gap=32,
    pic="GRAYPOIS", width=64, height=64,
    x_offset=0, y_offset=0,
    side="DOORSTOP", floor="SHAWN2",
    depth=8, light=0.5,
  }

  eagle1 =
  {
    count=1,
    pic="ZZWOLF6", width=128, height=128,
    x_offset=0, y_offset=0,
    side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.57,
  }

  hitler1 =
  {
    count=1,
    pic="ZZWOLF7", width=128, height=128,
    x_offset=0, y_offset=0,
    side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.57,
  }

  marbface =
  {
    count=1,
    pic="MARBFACE", width=128, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.57,
  }

  marbfac2 =
  {
    count=1,
    pic="MARBFAC2", width=128, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.57,
  }

  marbfac3 =
  {
    count=1,
    pic="MARBFAC3", width=128, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.57,
  }

  skinface =
  {
    count=1,
    pic="SKINFACE", width=160, height=80,
    x_offset=0, y_offset=24,
    -- side="METAL", floor="CEIL5_2",
    depth=8, 
    special=48, -- scroll left
    light=0.7,
  }

  spface1 =
  {
    count=1,
    pic="SP_FACE1", width=160, height=96,
    x_offset=0, y_offset=0,
    -- side="METAL", floor="CEIL5_2",
    depth=8, 
    special=48, -- scroll left
    light=0.7,
  }

  firewall =
  {
    count=1,
    pic="FIREWALL", width=128, height=112,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.9,
  }

  planet1 =
  {
    pic="PLANET1", width=192, height=128,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8,
  }

  planet1_blink =
  {
    pic="PLANET1", width=192, height=128,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8, sec_kind=1,
  }

  compute1 =
  {
    pic="COMPUTE1", width=128, height=128,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8,
  }

  compute1_blink =
  {
    pic="COMPUTE1", width=128, height=128,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8, sec_kind=1,
  }

  compute2 =
  {
    pic="COMPUTE2", width=192, height=56,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8,
  }

  compute2_blink =
  {
    pic="COMPUTE2", width=192, height=56,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8, sec_kind=1,
  }

  skulls1 =
  {
    count=1,
    pic="SKULWALL", width=128, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.67,
  }

  skulls2 =
  {
    count=1,
    pic="SKULWAL3", width=128, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.67,
  }

  spacewall =
  {
    pic="SPACEW3", width=64, height=128,
    x_offset=0, y_offset=0,
    side="DOORSTOP", depth=8, 
    floor="SHAWN2", light=0.8,
  }

  spdude1 =
  {
    count=1,
    pic="SP_DUDE1", width=128, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.67,
  }

  spdude2 =
  {
    count=1,
    pic="SP_DUDE2", width=128, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.67,
  }

  spdude3 =
  {
    count=1,
    pic="SP_DUDE3", width=64, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.67,
  }

  spdude4 =
  {
    count=1,
    pic="SP_DUDE4", width=64, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.67,
  }

  spdude5 =
  {
    count=1,
    pic="SP_DUDE5", width=64, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.67,
  }

  spdude6 =
  {
    count=1,
    pic="SP_DUDE6", width=64, height=128,
    x_offset=0, y_offset=0,
    -- side="WOODVERT", floor="FLAT5_2",
    depth=8, light=0.67,
  }

  spdude7 =
  {
    count=1,
    pic="SP_DUDE7", width=128, height=128,
    x_offset=0, y_offset=0,
    side="METAL", floor="RROCK03",
    depth=8, light=0.67,
  }

  spine =
  {
    count=1,
    pic="SKSPINE2", width=160, height=70,
    x_offset=0, y_offset=24,
    -- side="METAL", floor="CEIL5_2",
    depth=8, 
    special=48, -- scroll left
    light=0.7,
  }

}


DOOM.PILLARS =  -- Note: UNUSED STUFF
{
  teklite = { pillar="TEKLITE", trim1="GRAY7", trim2="METAL" }
  silver2 = { pillar="SILVER2", trim1="GRAY7", trim2="METAL" }
  shawn2  = { pillar="SHAWN2",  trim1="STARGR1", trim2="TEKWALL1" }

  big_red  = { pillar="REDWALL",  trim1="GRAY7", trim2="METAL" }
  big_blue = { pillar="LITEBLU4", trim1="GRAY7", trim2="METAL" }

  tekwall4 = { pillar="TEKWALL4", trim1="GRAY7", trim2="METAL1" }
  metal1   = { pillar="METAL1",   trim1="GRAY7", trim2="METAL" }
  blue1    = { pillar="COMPBLUE", trim1="SHAWN2", trim2="TEKWALL1" }

  marble1 = { pillar="MARBLE1",  trim1="GSTONE1", trim2="MARBLE2" }
  redwall = { pillar="REDWALL",  trim1="SP_HOT1", trim2="SP_HOT1" }
  sloppy  = { pillar="SLOPPY1",  trim1="MARBLE1", trim2="METAL" }
  sloppy2 = { pillar="SP_FACE2", trim1="MARBLE1", trim2="METAL" }
}


DOOM.CRATES =
{
  crate1 = { crate="CRATE1", x_offset=0, y_offset=0 }
  crate2 = { crate="CRATE2", x_offset=0, y_offset=0 }
  
  space = { crate="SPACEW3",  x_offset=0, y_offset=0 }
  comp  = { crate="COMPWERD", x_offset=0, y_offset=0 }
  mod   = { crate="MODWALL3", x_offset=0, y_offset=0 }
  lite5 = { crate="LITE5",    x_offset=0, y_offset=0 }

  wood = { crate="WOOD3",    x_offset=0, y_offset=0 }
  ick  = { crate="ICKWALL4", x_offset=0, y_offset=0 }
}


DOOM.DOORS =  -- Note: UNUSED STUFF
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
    special=1, tag=0,
  }

  silver_fast =
  {
    w=128, h=112, door_h=72,
    key="LITE3",
    door="BIGDOOR1", door_c="FLAT1",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    special=117, tag=0,
  }

  silver_once =
  {
    w=128, h=112, door_h=72,
    key="LITE3",
    door="BIGDOOR1", door_c="FLAT1",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    special=31, tag=0,
  }

  wooden =
  {
    w=128, h=112, door_h=112,
    door="BIGDOOR6", door_c="FLAT5_2",
    step="STEP1",
    frame="FLAT1",
    track="DOORTRAK",
    key="BRICKLIT", key_ox=20, key_oy=-16,
    special=1, tag=0,
  }

  wooden2 =
  {
    w=128, h=112, door_h=112,
    door="BIGDOOR5", door_c="FLAT5_2",
    step="STEP1",
    frame="FLAT1",
    track="DOORTRAK",
    key="BRICKLIT", key_ox=20, key_oy=-16,
    special=1, tag=0,
  }

  wooden_fast =
  {
    w=128, h=112, door_h=112,
    door="BIGDOOR6", door_c="FLAT5_2",
    step="STEP1",
    frame="FLAT1",
    track="DOORTRAK",
    key="BRICKLIT", key_ox=20, key_oy=-16,
    special=117, tag=0,
  }

  wooden2_fast =
  {
    w=128, h=112, door_h=112,
    door="BIGDOOR5", door_c="FLAT5_2",
    step="STEP1",
    frame="FLAT1",
    track="DOORTRAK",
    key="BRICKLIT", key_ox=20, key_oy=-16,
    special=117, tag=0,
  }

  wooden_once =
  {
    w=128, h=112, door_h=112,
    door="BIGDOOR6", door_c="FLAT5_2",
    step="STEP1",
    frame="FLAT1",
    track="DOORTRAK",
    key="BRICKLIT", key_ox=20, key_oy=-16,
    special=31, tag=0,
  }

  wooden2_once =
  {
    w=128, h=112, door_h=112,
    door="BIGDOOR5", door_c="FLAT5_2",
    step="STEP1",
    frame="FLAT1",
    track="DOORTRAK",
    key="BRICKLIT", key_ox=20, key_oy=-16,
    special=31, tag=0,
  }

  bigdoor2 =
  {
    w=128, h=112, door_h=112,
    key="LITE3",
    door="BIGDOOR2", door_c="FLAT23",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    special=1, tag=0,
  }

  bigdoor2_fast =
  {
    w=128, h=112, door_h=112,
    key="LITE3",
    door="BIGDOOR2", door_c="FLAT23",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    special=117, tag=0,
  }

  bigdoor2_once =
  {
    w=128, h=112, door_h=112,
    key="LITE3",
    door="BIGDOOR2", door_c="FLAT23",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    special=31, tag=0,
  }

  bigdoor4 =
  {
    w=128, h=112, door_h=112,
    key="LITEBLU1", key_oy=56,
    door="BIGDOOR4", door_c="FLOOR7_1",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    special=1, tag=0,
  }

  bigdoor4_fast =
  {
    w=128, h=112, door_h=112,
    key="LITEBLU1", key_oy=56,
    door="BIGDOOR4", door_c="FLOOR7_1",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    special=117, tag=0,
  }

  bigdoor4_once =
  {
    w=128, h=112, door_h=112,
    key="LITEBLU1", key_oy=56,
    door="BIGDOOR4", door_c="FLOOR7_1",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    special=31, tag=0,
  }

  bigdoor3 =
  {
    w=128, h=112, door_h=112,
    key="LITE3",
    door="BIGDOOR3", door_c="FLOOR7_2",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    special=1, tag=0,
  }

  wolf_door =
  {
    w=128, h=112, door_h=128,
    key="DOORSTOP",
    door="ZDOORB1", door_c="FLAT23",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    special=1, tag=0,
  }

  wolf_elev_door =
  {
    w=128, h=112, door_h=128,
    key="DOORSTOP",
    door="ZELDOOR", door_c="FLAT23",
    step="STEP4",
    frame="FLAT18",
    track="DOORTRAK",
    special=1, tag=0,
  }


  --- SWITCHED DOORS ---

  sw_wood =
  {
    w=128, h=112,

    key="WOOD1",
    door="BIGDOOR7", door_c="CEIL5_2",
    step="WOOD1",
    track="DOORTRAK",
    frame="FLAT5_2",
    door_h=112,
    special=0,
  }

  sw_marble =
  {
    w=128, h=112,

    key="GSTONE1",
    door="BIGDOOR2", door_c="FLAT1",
    step="GSTONE1",
    track="DOORTRAK",
    frame="FLOOR7_2",
    door_h=112,
    special=0,
  }

  bar_wood =
  {
    bar="WOOD9",
  }

  bar_silver =
  {
    bar="SUPPORT2",
  }

  bar_metal =
  {
    bar="SUPPORT3",
  }

  bar_gray =
  {
    bar="GRAY7",
  }
} -- end of DOOM.DOORS


DOOM.EXITS =
{
  skull_pillar =
  {
    h=128,
    switch="SW1SKULL",
    exit="EXITSIGN",
    exitside="COMPSPAN",
    special=11,
  }

  demon_pillar2 =
  {
    h=128,
    switch="SW1SATYR",
    exit="EXITSIGN",
    exitside="COMPSPAN",
    special=11,
  }

  demon_pillar3 =
  {
    h=128,
    switch="SW1LION",
    exit="EXITSIGN",
    exitside="COMPSPAN",
    special=11,
  }

  skin_pillar =
  {
    h=128,
    switch="SW1SKIN",
    exit="EXITSIGN",
    exitside="COMPSPAN",
    special=11,
  }

  stone_pillar =
  {
    h=128,
    switch="SW1STON1",
    exit="EXITSIGN",
    exitside="COMPSPAN",
    special=11,
  }

  tech_outdoor =
  {
    podium="CEIL5_1", base="SHAWN2",
    switch="SW1COMM", exit="EXITSIGN",
    special=11,
  }

  tech_outdoor2 =
  {
    podium="STARTAN2", base="SHAWN2",
    switch="SW2COMM", exit="EXITSIGN",
    special=11,
  }

  tech_small =
  {
    door = "EXITDOOR", track = "DOORTRAK",
    exit = "EXITSIGN", exitside = "SHAWN2",
    key = "LITE5",
    track = "DOORSTOP", trim = "DOORSTOP",
    items = { "medikit" }
    door_kind=1, special=11,

    switch = "SW1BRN2",
    floor = "FLOOR0_3", ceil="TLITE6_6",
  }

}


----------------------------------------------------------------

DOOM.SKIN_DEFAULTS =
{
}


DOOM.SKINS =
{
  ----| STARTS |----

  Start_basic =
  {
    _prefab = "START_SPOT"

    top = "O_BOLT"
  }

  Start_ledge =
  {
    _prefab = "START_LEDGE"
    _where  = "edge"
    _long   = 192
    _deep   =  64

    wall = "CRACKLE2"
  }

  Start_Closet =
  {
    _prefab = "START_CLOSET"
    _where  = "chunk"
    _size   = { 192,192, 384,384 }

    step = "FLAT1"

    door = "BIGDOOR1"
    track = "DOORTRAK"

    support = "SUPPORT2"
    support_ox = 24

    special = 31  -- open and stay open
    tag = 0

    item1 = "bullet_box"
    item2 = "stimpack"
  }


  ----| EXITS |----

  Exit_switch =
  {
    _prefab = "WALL_SWITCH"
    _where  = "edge"
    _long   = 192
    _deep   = 64

    wall = "EXITSTON"

    switch="SW1HOT"
    special=11
    x_offset=0
    y_offset=0
  }

  Exit_tech_pillar =
  {
    _prefab = "EXIT_PILLAR",

    switch = "SW1COMP"
    exit = "EXITSIGN"
    exitside = "COMPSPAN"
    q_sign = 1
    special = 11
    tag = 0
  }

  Exit_demon_pillar =
  {
    _prefab = "EXIT_PILLAR",

    switch = { SW1LION=60, SW1GARG=30 }
    exit = "EXITSIGN"
    exitside = "COMPSPAN"
    q_sign = 1
    special = 11
    tag = 0
  }

  Exit_urban_pillar =
  {
    _prefab = "EXIT_PILLAR",

    switch = "SW1WDMET"
    exit = "EXITSIGN"
    exitside = "COMPSPAN"
    q_sign = 1
    special = 11
    tag = 0
  }

  Exit_Closet_Tech =
  {
    _prefab = "EXIT_CLOSET"
    _size   = { 192,192, 384,384 }

    door  = "EXITDOOR"
    track = "DOORTRAK"
    key   = "EXITDOOR"
    key_ox = 112

    inner = { STARGR2=30, STARBR2=30, STARTAN2=30,
              METAL4=15,  PIPE2=15,  SLADWALL=15,
              TEKWALL4=50 }

    ceil  = { TLITE6_5=40, TLITE6_6=20, GRNLITE1=20,
              CEIL4_3=10, SLIME15=10 }

    floor2 = { FLAT4=20, FLOOR0_1=20, FLOOR0_3=20, FLOOR1_1=20 }

    exit = "EXITSIGN"
    exitside = "COMPSPAN"
    q_sign = 1
    switch  = "SW1COMM"
    sw_side = "SHAWN2"

    special = 11
    tag = 0

    item1 = "medikit"
    item2 = "shells"
  }

  Exit_Closet_Hell =
  {
    _prefab = "EXIT_CLOSET"
    _size   = { 192,192, 384,384 }

    door  = "EXITDOOR"
    track = "DOORTRAK"
    key   = "SUPPORT3"
    key_ox = 24

    inner = { MARBGRAY=40, SP_HOT1=20, REDWALL=10,
              SKINMET1=10, SLOPPY2=10 }

    ceil = { FLAT5_6=20, LAVA1=5, FLAT10=10, FLOOR6_1=10 }

    floor2  = { SLIME09=10, FLOOR7_2=20, FLAT5_2=10, FLAT5_8=10 }

    exit = "EXITSIGN"
    exitside = "COMPSPAN"
    q_sign = 1
    switch  = { SW1LION=10, SW1SATYR=30, SW1GARG=20 }
    sw_side = "METAL"
    sw_oy   = 56

    special = 11
    tag = 0

    item1 = "medikit"
    item2 = "shells"
  }

  Exit_Closet_Urban =
  {
    _prefab = "EXIT_CLOSET"
    _size   = { 192,192, 384,384 }

    door  = "EXITDOOR"
    track = "DOORTRAK"
    key   = "SUPPORT3"
    key_ox = 24

    inner = { BIGBRIK3=20, WOOD9=10, STONE=10, WOODMET1=35,
              CEMENT8=5, PANEL6=20 }
    
    ceil = { RROCK04=20, RROCK13=20, RROCK03=10, 
             FLAT10=20, FLOOR6_2=10, FLAT4=20 }

    floor2  = { FLAT5_2=30, CEIL5_1=15, CEIL4_2=15,
                MFLR8_1=15, RROCK18=25, RROCK12=20 }

    exit = "EXITSIGN"
    exitside = "COMPSPAN"
    q_sign = 1
    switch  = { SW1BRNGN=30, SW1ROCK=10, SW1SLAD=20, SW1TEK=20 }
    sw_side = "BROWNGRN"
    sw_oy   = 60

    special = 11
    tag = 0

    item1 = "medikit"
    item2 = "shells"
  }


Exit_Closet =  --  _Urban
{
  _prefab = "ITEM_CLOSET"
  _size   = { 192,192, 384,384 }

  item = "soul"
}


  ----| STAIRS |----

  Stair_Up1 =
  {
    _prefab = "STAIR_6"
    _where  = "chunk"
    _deltas = { 32,48,48,64,64,80 }
  }

  Stair_Down1 =
  {
    _prefab = "NICHE_STAIR_8"
    _where  = "chunk"
    _deltas = { -32,-48,-64,-64,-80,-96 }
  }


  Lift_Up1 =  -- Rusty
  {
    _prefab = "LIFT_UP"
    _where  = "chunk"
    _tags   = 1
    _deltas = { 96,128,160,192 }

    lift = "SUPPORT3"
    top  = { STEP_F1=50, STEP_F2=50 }

    walk_kind   = 88
    switch_kind = 62
  }

  Lift_Down1 =  -- Shiny
  {
    _prefab = "LIFT_DOWN"
    _where  = "chunk"
    _tags   = 1
    _deltas = { -96,-128,-160,-192 }

    lift = "SUPPORT2"
    top  = "FLAT20"

    walk_kind   = 88
    switch_kind = 62
  }


  ----| WALLS / CORNERS |----

  Fat_Outside_Corner1 =
  {
    _prefab = "FAT_CORNER_DIAG"
    _where  = "chunk"
  }


  ----| ARCHES |----

  Arch1 =
  {
    _prefab = "ARCH"
    _where  = "edge"
    _long   = 192
    _deep   = 64
  }

  Fat_Arch1 =
  {
    _prefab = "FAT_ARCH1"
    _where  = "chunk"

    pic = "SW1SATYR"    
  }


  ----| DOORS |----

  Door_silver =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _long   = 192
    _deep   = 64

    width=128
    height=72

    door="BIGDOOR1"
    track="DOORTRAK"
    key="LITE3"
    step="STEP4"

    x_offset=0
    y_offset=0
    special=1
    tag=0
  }


  ----| KEY |----

  Item_niche =
  {
    _prefab = "ITEM_NICHE"
    _where  = "edge"
    _long   = 192
    _deep   = 64
  }

  Pedestal_1 =
  {
    _prefab = "PEDESTAL"
    _where  = "chunk"

    top  = "CEIL1_2"
    side = "METAL"
  }

--[[
  OLD_sw_blue2 =
  {
    prefab = "SWITCH_FLOOR_BEAM",
    skin =
    {
      switch_h=64,
      switch_w="SW1BLUE", side_w="COMPBLUE",
      switch_f="FLAT14", switch_h=64,

      beam_w="WOOD1", beam_f="FLAT5_2",

      x_offset=0, y_offset=56,
      special=103,
    }
  }

  OLD_sw_hot =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch_h=64,
      switch="SW1HOT", side="SP_HOT1", base="FLAT5_3",
      x_offset=0, y_offset=52,
      special=103,
    }

  }

  OLD_sw_skin =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch_h=64,
      switch="SW1SKIN", side="SKSNAKE2", base="SFLR6_4",
      x_offset=0, y_offset=52,
      special=103,
    }
  }

  OLD_sw_vine =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch_h=64,
      switch="SW1VINE", side="GRAYVINE", base="FLAT1",
      x_offset=0, y_offset=64,
      special=103,
    }
  }

  OLD_sw_metl =  -- NOT USED
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
      special=23,
    }
  }

  OLD_sw_wood =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch_h=64,
      switch="SW1WOOD", side="WOOD1", base="FLAT5_2",
      x_offset=0, y_offset=56,
      special=103,
    }
  }

  OLD_sw_marble =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch="SW1GSTON", side="GSTONE1", base="FLOOR7_2",
      x_offset=0, y_offset=56,
      special=103,
    }
  }

  OLD_bar_wood =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch="SW1WOOD", side="WOOD9", base="FLAT5_2",
      x_offset=0, y_offset=56,
      special=23,
    }
  }

  OLD_bar_silver =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch="SW1COMM", side="SHAWN2", base="FLAT23",
      x_offset=0, y_offset=0,
      special=23,
    }
  }

  OLD_bar_metal =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch="SW1MET2", side="METAL2", base="CEIL5_2",
      x_offset=0, y_offset=0,
      special=23,
    }
  }

  OLD_bar_gray =
  {
    prefab = "SWITCH_PILLAR",
    skin =
    {
      switch="SW1GRAY1", side="GRAY1", base="FLAT1",
      x_offset=0, y_offset=64,
      special=23,
    }
  }
--]]


  ---| LOCKED DOORS |---

  Locked_kc_blue =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "kc_blue"
    _long   = 192
    _deep   = 32

    w = 128
    h = 112
    door_h = 112
    key = "DOORBLU"
    door = "BIGDOOR3"
    door_c = "FLOOR7_2"
    step = "STEP4"
    track = "DOORTRAK"
    frame = "FLAT18"
    special = 32
    tag = 0  -- kind_mult=26
  }

  Locked_kc_yellow =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "kc_yellow"
    _long   = 192
    _deep   = 32

    w = 128
    h = 112
    door_h = 112
    key = "DOORYEL"
    door = "BIGDOOR4"
    door_c = "FLOOR3_3"
    step = "STEP4"
    track = "DOORTRAK"
    frame = "FLAT4"
    special = 34
    tag = 0  -- kind_mult=27
  }

  Locked_kc_red =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "kc_red"
    _long   = 192
    _deep   = 32

    w = 128
    h = 112

    key = "DOORRED"
    door_h = 112
    door = "BIGDOOR2"
    door_c = "FLAT1"
    step = "STEP4"
    track = "DOORTRAK"
    frame = "FLAT18"
    special = 33
    tag = 0  -- kind_mult=28
  }

  Locked_ks_blue =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "ks_blue"
    _long   = 192
    _deep   = 32

    w = 128
    h = 112
    door_h = 112
    key = "DOORBLU2"
    key_ox = 4
    key_oy = -10
    door = "BIGDOOR7"
    door_c = "FLOOR7_2"
    step = "STEP4"
    track = "DOORTRAK"
    frame = "FLAT18"
    special = 32
    tag = 0  -- kind_mult=26
  }

  Locked_ks_yellow =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "ks_yellow"
    _long   = 192
    _deep   = 32

    w = 128
    h = 112
    door_h = 112
    key = "DOORYEL2"
    key_ox = 4
    key_oy = -10
    door = "BIGDOOR7"
    door_c = "FLOOR3_3"
    step = "STEP4"
    track = "DOORTRAK"
    frame = "FLAT4"
    special = 34
    tag = 0  -- kind_mult=27
  }

  Locked_ks_red =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "ks_red"
    _long   = 192
    _deep   = 32

    w = 128
    h = 112
    door_h = 112
    key = "DOORRED2"
    key_ox = 4
    key_oy = -10
    door = "BIGDOOR7"
    door_c = "FLAT1"
    step = "STEP4"
    track = "DOORTRAK"
    frame = "FLAT18"
    special = 33
    tag = 0  -- kind_mult=28
  }


  ---| SWITCHED DOORS |---

  Door_SW_blue =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _switch = "sw_blue"
    _long = 192
    _deep = 32

    w = 128
    h = 112

    key = "COMPBLUE"
    door = "BIGDOOR3"
    door_c = "FLOOR7_2"
    step = "COMPBLUE"
    track = "DOORTRAK"
    frame = "FLAT14"
    door_h = 112
    special = 0
  }

  Switch_blue1 =
  {
    _prefab = "SMALL_SWITCH"
    _where  = "chunk"
    _switch = "sw_blue"
    _long   = 192
    _deep   = 48

    switch_h = 64
    switch = "SW1BLUE"
    side = "COMPBLUE"
    base = "COMPBLUE"
    x_offset = 0
    y_offset = 50
    special = 103
  }


  Door_SW_red =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _switch = "sw_red"
    _long = 192
    _deep = 32

    w = 128
    h = 112

    key = "REDWALL"
    door = "BIGDOOR2"
    door_c = "FLAT1"
    step = "REDWALL"
    track = "DOORTRAK"
    frame = "FLAT5_3"
    door_h = 112
    special = 0
  }

  Switch_red1 =
  {
    _prefab = "SMALL_SWITCH"
    _where  = "chunk"
    _switch = "sw_red"
    _long   = 192
    _deep   = 48

    switch_h = 64
    switch = "SW1HOT"
    side = "SP_HOT1"
    base = "SP_HOT1"
    x_offset = 0
    y_offset = 50
    special = 103
  }


  Door_SW_pink =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _switch = "sw_pink"
    _long   = 192
    _deep   = 32

    w = 128
    h = 112

    key = "SKINFACE"
    door = "BIGDOOR4"
    door_c = "FLOOR7_2"
    step = "SKINFACE"
    track = "DOORTRAK"
    frame = "SKINFACE"
    door_h = 112
    special = 0
  }

  Switch_pink1 =
  {
    _prefab = "SMALL_SWITCH"
    _where  = "chunk"
    _switch = "sw_pink"
    _long   = 192
    _deep   = 48

    switch_h = 64
    switch = "SW1SKIN"
    side = "SKIN2"
    base = "SKIN2"
    x_offset = 0
    y_offset = 50
    special = 103
  }



  Door_SW_vine =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _switch = "sw_vine"
    _long   = 192
    _deep   = 32

    w = 128
    h = 112

    key = "GRAYVINE"
    door = "BIGDOOR4"
    door_c = "FLOOR7_2"
    step = "GRAYVINE"
    track = "DOORTRAK"
    frame = "FLAT1"
    door_h = 112
    special = 0
  }

  Switch_vine1 =
  {
    _prefab = "SMALL_SWITCH"
    _where  = "chunk"
    _switch = "sw_vine"
    _long   = 192
    _deep   = 48

    switch_h = 64
    switch = "SW1VINE"
    side = "GRAYVINE"
    base = "GRAYVINE"
    x_offset = 0
    y_offset = 62
    special = 103
  }


  ---| HALLWAY PIECES |---

  Hall_Basic_I =
  {
    _prefab = "HALL_BASIC_I"
    _shape  = "I"
  }

  Hall_Basic_C =
  {
    _prefab = "HALL_BASIC_C"
    _shape  = "C"
  }

  Hall_Basic_T =
  {
    _prefab = "HALL_BASIC_T"
    _shape  = "T"
  }

  Hall_Basic_P =
  {
    _prefab = "HALL_BASIC_P"
    _shape  = "P"
  }

  Hall_Basic_I_Stair =
  {
    _prefab = "HALL_BASIC_I_STAIR"
    _shape  = "IS"

    step = "STEP3"
  }

  Hall_Basic_I_Lift =
  {
    _prefab = "HALL_BASIC_I_LIFT"
    _shape  = "IL"
    _tags   = 1

    lift = "SUPPORT3"
    top  = { STEP_F1=50, STEP_F2=50 }

    raise_W1 = 130
    lower_WR = 88  -- 120
    lower_SR = 62  -- 123
  }


  Hall_Thin_I =
  {
    _prefab = "HALL_THIN_I"
    _shape  = "I"
  }

  Hall_Thin_C =
  {
    _prefab = "HALL_THIN_C"
    _shape  = "C"
  }

  Hall_Thin_T =
  {
    _prefab = "HALL_THIN_T"
    _shape  = "T"
  }

  -- TODO: Hall_Thin_P

  Hall_Thin_I_Stair =
  {
    _prefab = "HALL_THIN_I_STAIR"
    _shape  = "IS"

    step = "STEP1"
  }

  -- TODO: Hall_Thin_I_Lift


  Hall_Cavey_I =
  {
    _prefab = "HALL_CAVEY_I"
    _shape  = "I"
  }

  Hall_Cavey_C =
  {
    _prefab = "HALL_CAVEY_C"
    _shape  = "C"
  }

  Hall_Cavey_T =
  {
    _prefab = "HALL_CAVEY_T"
    _shape  = "T"
  }

  Hall_Cavey_P =
  {
    _prefab = "HALL_CAVEY_P"
    _shape  = "P"
  }

  Hall_Cavey_I_Stair =
  {
    _prefab = "HALL_CAVEY_I_STAIR"
    _shape  = "IS"
  }


  ---| BIG JUNCTIONS |---

  Junc_Octo_I =
  {
    _prefab = "JUNCTION_OCTO"
    _shape  = "I"

    hole = "_SKY"

    east_wall_q = 1
    west_wall_q = 1
  }

  Junc_Octo_C =
  {
    _prefab = "JUNCTION_OCTO"
    _shape  = "C"

    hole = "_SKY"

    north_wall_q = 1
     east_wall_q = 1
  }

  Junc_Octo_T =
  {
    _prefab = "JUNCTION_OCTO"
    _shape  = "T"

    hole = "_SKY"

    north_wall_q = 1
  }

  Junc_Octo_P =
  {
    _prefab = "JUNCTION_OCTO"
    _shape  = "P"

    hole = "_SKY"

    -- leave all walls open
  }


  Junc_Nukey_C =
  {
    _prefab = "JUNCTION_NUKEY_C"
    _liquid = 1
    _shape  = "C"

    support = "SUPPORT2"
    support_ox = 24

    lamp = { TLITE6_5=50, TLITE6_6=10, TLITE6_1=10, FLOOR1_7=5 }
  }


  ---| TELEPORTERS |---

  Teleporter1 =
  {
    _prefab = "TELEPORT_PAD"
    _where  = "chunk"

    top  = { GATE1=60, GATE2=60, GATE3=30 }
    side = "METAL"

    x_offset = 0
    y_offset = 0
    peg = 1

    special = 97
    top_special = 8
    light = 255
  }


  ---| WINDOWS |---

  Window1 =
  {
    _prefab = "WINDOW"
    _where  = "edge"
    _long   = 192
    _deep   = 32

    track = "SHAWN2"
  }


  ---| FENCES |---

  Fence1 =
  {
    _prefab = "FENCE_W_RAIL"
    _where  = "edge"
    _long   = 192
    _deep   = 32

    fence = "ICKWALL7"
    metal = "METAL"
    rail  = "MIDBARS3"
  }


  ---| CAGES |---

  Fat_Cage1 =
  {
    _prefab = "FAT_CAGE1"
    _where  = "chunk"

    rail = "MIDBARS3"    
  }

  Fat_Cage_W_Bars =
  {
    _prefab = "FAT_CAGE_W_BARS"
    _where  = "chunk"

    bar = "METAL"
  }



  ---| PICTURES |---

  Pic_Chrissy1 =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192
    _deep   = 32

    pic = "O_MISC"
    width  = 128
    height = 128
  }

  Pic_Chrissy2 =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192
    _deep   = 32

    pic = "O_NEON"
    width  = 128
    height = 128
  }

  Pic_Logo1 =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192
    _deep   = 32

    pic = "O_PILL"
    width  = 128
    height = 32
  }

  Pic_Logo2 =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192
    _deep   = 32

    pic = "O_CARVE"
    width  = 64
    height = 64
  }


  ---| DECORATION |---

  RoundPillar =
  {
    _prefab = "ROUND_PILLAR"
    _radius = 32

    pillar = "TEKLITE"
  }

  Crate1 =
  {
    _prefab = "CRATE"
    _radius = 32

    crate = "CRATE1"
  }

  Crate2 =
  {
    _prefab = "CRATE"
    _radius = 32

    crate = "CRATE2"
  }

  CrateWOOD =
  {
    _prefab = "CRATE"
    _radius = 32

    crate = "WOOD3"
  }

  CrateICK =
  {
    _prefab = "CRATE"
    _radius = 32

    crate = "ICKWALL4"
  }


} -- end of DOOM.SKINS



----------------------------------------------------------------

DOOM.THEME_DEFAULTS =
{
  starts = { Start_basic = 50 }

  exits = { Exit_tech_pillar = 50 }

  pedestals = { Pedestal_1 = 50 }

  stairs = { Stair_Up1 = 50, Stair_Down1 = 50,
             Lift_Up1 = 4, Lift_Down1 = 4 }

  keys = { kc_red=50, kc_blue=50, kc_yellow=50 }

  switches = { sw_blue=50, sw_red=50, sw_pink=20, sw_vine=20 }

  switch_fabs  = { Switch_blue1=50, Switch_red1=50,
                   Switch_pink1=50, Switch_vine1=50 }

  locked_doors = { Locked_kc_blue=50, Locked_kc_red=50, Locked_kc_yellow=50,
                   Locked_ks_blue=50, Locked_ks_red=50, Locked_ks_yellow=50,
                   Door_SW_blue = 50, Door_SW_red = 50,
                   Door_SW_pink = 50, Door_SW_vine = 50 }

  arches = { Arch1 = 50 }

  doors = { Door_silver = 50 }

  teleporters = { Teleporter1 = 50 }

  windows = { Window1 = 50 }

  fences = { Fence1 = 50 }

  hallway_groups = { basic = 50, thin = 20, cavey = 999 }

  big_junctions =
  {
    Junc_Octo_I = 50
    Junc_Octo_C = 50
    Junc_Octo_T = 50
    Junc_Octo_P = 50

    Junc_Nukey_C = 5
  }

  fat_cages = { Fat_Cage1 = 50, Fat_Cage_W_Bars = 8 }

  outdoor_decor = { big_tree=50, burnt_tree=10, brown_stub=10 }

  indoor_decor = { barrel=60, burning_barrel=20,
                   dead_player=10, gibbed_player=10,
                   tech_column=10,
                   impaled_twitch=10, evil_eye=5,
                   candelabra=10, red_torch=5,
                   green_torch=5, blue_torch=5 }

  indoor_fabs = { RoundPillar=70,
                  Crate1=10, Crate2=10, 
                  CrateICK=10, CrateWOOD=10 }

  piccies = { Pic_Chrissy1=40, Pic_Chrissy2=5,
              Pic_Logo1=20, Pic_Logo2=10 }

  --------- OLD CRUD --------> > >

  outer_fences = { BROWN144=50, STONE2=30, BROWNHUG=10,
                   BROVINE2=10, GRAYVINE=10, ICKWALL3=2,
                   GRAY1=10, STONE=20,
                 }

  logos = { carve=50, pill=50, neon=50 }

  pictures = { tekwall4=10 }

  -- FIXME: should not be separated (environment = "liquid" ??)
  liquid_pics = { pois1=70, pois2=30 }

  crates = { crate1=50, crate2=50, }

  -- FIXME: should not be separated, have 'environment' fields
  out_crates = { wood=50, ick=50 }

  bars = { bar_silver=50 }

  -- MISC STUFF : these don't quite fit in yet --  (FIXME)

  periph_pillar_mat = "SUPPORT3",
  beam_mat = "METAL",
  light_trim = "METAL",
  corner_supports = { SUPPORT2=50, SUPPORT3=10 }
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
    special=23,
  }

  lowering_pedestal_skin2 =
  {
    side="PIPEWAL1", top="CEIL1_2",
    x_offset=0, y_offset=0, peg=1,
    special=23,
  }
}


DOOM.NAME_THEMES =
{
  -- these tables provide *additional* words to those in naming.lua

  TECH =
  {
    lexicon =
    {
      a =
      {
        Deimos=30
        Phobos=30
        ["Tei Tenga"]=15
      }

      b =
      {
        UAC=30
      }

      s =
      {
        ["UAC Crisis"]=30
      }
    }
  }
}


DOOM.HALLWAY_GROUPS =
{
  basic =
  {
    pieces =
    {
      Hall_Basic_I = 50
      Hall_Basic_C = 50
      Hall_Basic_T = 50
      Hall_Basic_P = 50

      Hall_Basic_I_Stair = 20
      Hall_Basic_I_Lift  = 2
    }
  }

  thin =
  {
    pieces =
    {
      Hall_Thin_I = 50
      Hall_Thin_C = 50
      Hall_Thin_T = 50
      Hall_Basic_P = 50  -- TODO

      Hall_Thin_I_Stair = 20
      Hall_Basic_I_Lift  = 2  -- TODO
    }
  }

  cavey =
  {
    pieces =
    {
      Hall_Cavey_I = 50
      Hall_Cavey_C = 50
      Hall_Cavey_T = 50
      Hall_Cavey_P = 50

      Hall_Cavey_I_Stair = 20
      Hall_Basic_I_Lift  = 2   -- TODO
    }
  }

}


DOOM.ROOM_THEMES =
{
  ----- Tech Base ---------------------------

  Tech2_startan3 =
  {
    walls =
    {
      STARTAN3=60
      STARG3=40
      STARG3=10
    }

    floors =
    {
      FLOOR4_8=50
      FLOOR5_3=30
      FLOOR3_3=20
      FLOOR0_3=30
      SLIME15=10
      SLIME16=10
      FLAT4=15
    }

    ceilings =
    {
      CEIL3_5=20,
      CEIL3_1=20,
      FLAT4=20,
      CEIL4_3=10,
      CEIL5_2=10,
      FLAT9=30,
    }
  }

  Tech2_startan2 =
  {
    walls =
    {
      STARTAN2 = 50
      STARBR2  = 40
    }

    floors =
    {
      FLOOR4_8=50,
      FLOOR5_3=30,
      FLOOR3_3=20,
      FLOOR0_3=30,
      SLIME15=10,
      SLIME16=10,
      FLAT4=15,
    }

    ceilings =
    {
      CEIL3_5=20,
      CEIL3_1=20,
      FLAT4=20,
      CEIL4_3=10,
      CEIL5_2=10,
      FLAT9=30,
    }
  }

  Tech2_stargrey =
  {
    rarity = "minor"

    walls =
    {
      STARGR2=50,
    }

    floors =
    {
      FLOOR4_8=50,
      FLOOR5_3=30,
      FLOOR3_3=20,
      FLOOR0_3=30,
      SLIME15=10,
      SLIME16=10,
      FLAT4=15,
    }

    ceilings =
    {
      CEIL3_5=20,
      CEIL3_1=20,
      FLAT4=20,
      CEIL4_3=10,
      CEIL5_2=10,
      FLAT9=30,
    }
  }

  Tech2_tekgren =
  {
    walls =
    {
      TEKGREN2 = 50, 
    }

    floors =
    {
      FLAT14 = 50
    }

    ceilings =
    {
      -- FIXME
      GRNLITE1=5  
    }
  }

  Tech2_metal2 =
  {
    walls =
    {
      METAL2 = 50, 
    }

    floors =
    {
      FLAT3 = 50,
      FLOOR0_1 = 30,
      FLOOR4_5 = 20,
      FLOOR7_1 = 15,
      FLAT4 = 5
    }

    ceilings =
    {
      CEIL5_1 = 40
      CEIL5_2 = 40
      SLIME15 = 40
    }
  }

  Tech2_cave =
  {
    naturals =
    {
      ASHWALL=50,
      ASHWALL4=50,
      SP_ROCK1=50,
      GRAYVINE=50,
      TEKWALL4=3,
    }
  }

  Tech2_outdoors =
  {
    floors =
    {
      BROWN1=50,
      BRICK12=20,
      SLIME14=20,
      SLIME16=20,
      STONE3=40,
      FLOOR4_8=10,
      FLOOR5_4=20,
    }

    naturals =
    {
      ASHWALL=50,
      ASHWALL4=50,
      SP_ROCK1=50,
    }
  }

  Tech2_hallway =
  {
    walls =
    {
      TEKWALL6 = 50,
      TEKGREN1 = 50,
      BROWNPIP = 20,
      PIPEWAL2 = 50,
      STARGR1 = 10,
    }

    floors =
    {
      FLAT14 = 50,
      FLAT1 = 20,
      FLOOR0_2 = 20,
      FLOOR1_6 = 5,
    }

    ceilings =
    {
      CEIL3_5=50,
      CEIL3_6=20,
      CEIL3_1=50,
      RROCK03=50,
      TLITE6_5=10
    }
  }


  ----- Hell / Gothic -------------------------

  Hell2_hotbrick =
  {
    walls =
    {
      SP_HOT1 = 50
    }

    floors =
    {
      FLAT10   = 50
      FLOOR7_1 = 50
    }

    ceilings =
    {
      FLOOR6_1 = 20
      FLOOR6_2 = 20
    }
  }

  Hell2_marble =
  {
    walls =
    {
      MARBLE2 = 50
    }

    floors =
    {
      FLAT10   = 50
      FLOOR7_1 = 50
    }

    ceilings =
    {
      FLOOR6_1 = 20
      FLOOR6_2 = 20
    }
  }

  Hell2_hallway =
  {
    walls =
    {
      MARBGRAY = 80
      GSTVINE1 = 40
      GSTVINE2 = 40
    }

    floors =
    {
      FLAT1 = 50
    }

    ceilings =
    {
      FLAT1 = 50
    }
  }

  Hell2_cave =
  {
    naturals =
    {
      ROCKRED1 = 50
      SP_ROCK1 = 25
      GSTVINE2 = 25
    }
  }

  Hell2_outdoors =
  {
    floors =
    {
      BROWN1=50,
    }

    naturals =
    {
      ROCKRED1 = 50
      SP_ROCK1 = 30
      ASHWALL4 = 50
    }
  }


  ---- Urban / City / Earth ---------------------

  Urban_panel =
  {
    facades =
    {
      BIGBRIK1 = 30
      BLAKWAL2 = 10
      MODWALL3 = 10
      PANEL7   = 10
      CEMENT7  = 5
    }

    walls =
    {
      PANEL6 = 50
      PANEL8 = 50
      PANEL3 = 50
    }

    floors =
    {
      FLAT1 = 50
    }

    ceilings =
    {
      FLAT1 = 50
    }
  }

  Urban_bigbrik =
  {
    walls =
    {
      BIGBRIK1 = 50
      BIGBRIK2 = 50
    }

    floors =
    {
      FLAT1 = 50
    }

    ceilings =
    {
      FLAT1 = 50
    }
  }

  Urban_brick =
  {
    walls =
    {
      BRICK5  = 50
      BRICK7  = 30
      BRICK9  = 20
      BRICK12 = 30
      BRICK11 = 3
    }

    floors =
    {
      FLAT1 = 50
    }

    ceilings =
    {
      FLAT1 = 50
    }
  }

  Urban_stone =
  {
    walls =
    {
      STONE2 = 50
      STONE3 = 50
    }

    floors =
    {
      FLAT1 = 50
    }

    ceilings =
    {
      FLAT1 = 50
    }
  }

  Urban_hallway =
  {
    walls =
    {
      BIGBRIK1 = 50
      BIGBRIK2 = 50
      BRICK10  = 50
      BRICK11  = 10
      WOOD9    = 50
      PANEL1   = 50
      PANEL7   = 30
      STUCCO3  = 30
    }

    floors =
    {
      FLAT5_1 = 50
      FLAT8   = 50
      FLAT5_4 = 50
      MFLR8_1 = 50
    }

    ceilings =
    {
      CEIL1_1 = 30
      MFLR8_1 = 50
      FLAT1   = 30
    }
  }

  Urban_cave =
  {
    naturals =
    {
      ASHWALL  = 50
      ASHWALL4 = 50
      BSTONE1  = 15
      ZIMMER5  = 15
      ROCK3    = 70
    }
  }

  Urban_outdoors =
  {
    floors =
    {
      STONE = 50
      FLAT5_2 = 50
    }

    naturals =
    {
      ASHWALL  = 50
      ASHWALL4 = 50
      BSTONE1  = 15
      ZIMMER5  = 15
      ROCK3    = 70
    }
  }


  ---- Miscellaneous ---------------------

  Wolf_cells =
  {
    walls =
    {
      ZZWOLF9=50
    }

    floors =
    {
      FLAT1=50
    }

    ceilings =
    {
      FLAT1=50
    }
  }

  Wolf_stein =
  {
    walls =
    {
      ZZWOLF1=50,
    }

    floors =
    {
      FLAT1=50,
      MFLR8_1=50,
    }

    ceilings =
    {
      FLAT1=50
    }
  }

  Wolf_brick =
  {
    walls =
    {
      ZZWOLF11=50,
    }

    floors =
    {
      FLAT1=50
    }

    ceilings =
    {
      FLAT5_3=30,
    }
  }

  Wolf_hall =
  {
    walls =
    {
      ZZWOLF5=50,
    }

    floors =
    {
      CEIL5_1=50,
    }

    ceilings =
    {
      CEIL1_1=50,
      FLAT5_1=50,
    }
  }

  Wolf_cave =
  {
    square_caves = true

    naturals =
    {
      ROCK4=50,
      SP_ROCK1=10
    }
  }

  Wolf_outdoors =
  {
    floors =
    {
      MFLR8_1=20,
      FLAT1_1=10,
      RROCK13=20
    }

    naturals =
    {
      ROCK4=50,
      SP_ROCK1=10
    }
  }
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


DOOM1.LEVEL_THEMES =
{
  doom_tech1 =
  {
    prob = 60

    liquids = { nukage=90, water=15, lava=10 }

    buildings = { D1_Tech_room=50 }
    hallways  = { D1_Tech_hallway=50 }
    caves     = { D1_Tech_cave=50 }
    outdoors  = { D1_Tech_outdoors=50 }

    __logos = { carve=5, pill=50, neon=50 }

    __pictures =
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
    }

    OLD__exits = { stone_pillar=50 }

    OLD__switches = { sw_blue=50, sw_hot=50 }

    bars = { bar_silver=50, bar_gray=50 }

    __exit =  -- FIXME
    {
      walls =
      {
        STARTAN2=50, STARG1=50,
        TEKWALL4=50, STARBR2=50
      }
      floors =
      {
        FLOOR0_3=50, FLOOR5_2=50
      }
      ceilings =
      {
        TLITE6_6=50, TLITE6_5=50, FLAT17=50,
        FLOOR1_7=50, CEIL4_3=50
      }
      switches =
      {
        SW1METAL=50, SW1LION=50, SW1BRN2=50, SW1BRNGN=50,
        SW1GRAY=50,  SW1SLAD=50, SW1STRTN=50,
        SW1STON1=50
      }
    }

    OLD__doors =
    {
      silver=20, silver_fast=33, silver_once=2,
      bigdoor2=5, bigdoor2_fast=8, bigdoor2_once=5,
      bigdoor4=5, bigdoor4_fast=8, bigdoor4_once=5,
      bigdoor3=5,
    }

    ceil_lights =
    {
      TLITE6_5=50, TLITE6_6=30, TLITE6_1=30, FLOOR1_7=30,
      FLAT2=20,    CEIL3_4=10,  FLAT22=10,
    }

    big_lights = { TLITE6_5=30, TLITE6_6=30, FLAT17=30, CEIL3_4=30 }

    pillars = { metal1=70, tekwall4=20 }
    big_pillars = { big_red=50, big_blue=50 }

    crates = { crate1=50, crate2=50, comp=70, lite5=20 }

    style_list =
    {
      naturals = { none=30, few=70, some=30, heaps=2 }
    }
  }


  -- Deimos theme by Mr. Chris

  doom_deimos1 =
  {
    prob = 50

    liquids = { nukage=60, water=10, blood=20 }

    buildings = { Deimos_room=50 }
    caves     = { Deimos_cave=50 }
    outdoors  = { Deimos_outdoors=50 }
    hallways  = { Deimos_hallway=50 }

    -- Best facades would be STONE/2/3, BROVINE/2, BROWN1 and maybe a few others as I have not seen many
    -- other textures on the episode 2 exterior.
    facades =
    {
      STONE2=50, STONE3=50, BROVINE=30, BROVINE2=30,
      BROWN1=50,  -- etc...
    }

    __logos = { carve=5, pill=50, neon=50 }

    __pictures =
    {
      shawn1=10, tekwall1=4, tekwall4=2,
      lite5=20, lite5_05blink=10, lite5_10blink=10,
      liteblu4=30, liteblu4_05sync=10, liteblu4_10sync=10,
      compsta1=30, compsta1_blink=15,
      compsta2=30, compsta2_blink=15,

---!!!   planet1=20,  planet1_blink=8,
      compute1=20, compute1_blink=15,
---!!!   compute2=15, compute2_blink=2,
      litered=10,
    }

    OLD__exits = { stone_pillar=50 }

    OLD__switches = { sw_blue=50, sw_hot=50 }

    bars = { bar_silver=50, bar_gray=50 }

    __exit =  -- FIXME
    {
      walls =
      {
        STARTAN2=50, STARG1=50,
        TEKWALL4=50, STARBR2=50
      }
      floors =
      {
        FLOOR0_3=50, FLOOR5_2=50
      }
      ceilings =
      {
        TLITE6_6=50, TLITE6_5=50, FLAT17=50,
        FLOOR1_7=50, CEIL4_3=50
      }
      switches =
      {
        SW1METAL=50, SW1LION=50, SW1BRN2=50, SW1BRNGN=50,
        SW1GRAY=50,  SW1SLAD=50, SW1STRTN=50,
        SW1STON1=50
      }
    }

    OLD__doors =
    {
      silver=20, silver_fast=33, silver_once=2,
      bigdoor2=5, bigdoor2_fast=8, bigdoor2_once=5,
      bigdoor4=5, bigdoor4_fast=8, bigdoor4_once=5,
      bigdoor3=5,
    }

    ceil_lights =
    {
      TLITE6_5=50, TLITE6_6=30, TLITE6_1=30, FLOOR1_7=30, CEIL1_3=5,
      FLAT2=20, CEIL3_4=10, FLAT22=10, FLAT17=20, CEIL1_2=7,
    }

    big_lights = { TLITE6_5=30, TLITE6_6=30, FLAT17=30, CEIL3_4=30 }

    pillars = { metal1=70, tekwall4=20 }
    big_pillars = { big_red=50, big_blue=50 }

    crates = { crate1=50, crate2=50, comp=70, lite5=20 }

    style_list =
    {
      naturals = { none=40, few=70, some=20, heaps=2 }
    }
  }


  -- this is the greeny/browny/marbley Hell

  doom_hell1 =
  {
    prob = 40,

    liquids = { lava=30, blood=90, nukage=5 }

    keys = { ks_red=50, ks_blue=50, ks_yellow=50 }

    buildings = { D1_Marble_room=50 }
    outdoors  = { D1_Marble_outdoors=50 }
    caves     = { D1_Hell_cave=50 }


    FIXME_switch_doors = { Door_pink = 50, Door_vine = 50 }

    logos = { carve=90, pill=50, neon=5 }

    pictures =
    {
      marbface=10, skinface=10, firewall=20,
      spdude1=4, spdude2=4, spdude5=3, spine=2,

      skulls1=10, skulls2=10, spdude3=3, spdude6=3,
    }

    OLD__exits = { skin_pillar=40,
              demon_pillar2=10, demon_pillar3=10 }

    OLD__switches = { sw_marble=50, sw_vine=50, sw_wood=50 }

    bars = { bar_wood=50, bar_metal=50 }

    outer_fences = { ROCKRED1=25, SP_ROCK1=20, BROVINE2=10, GRAYVINE=10 }

    monster_prefs = { zombie=0.3, shooter=0.6, skull=2.0 }
  }


  -- this is the reddy/skinny/firey Hell

  doom_hell2 =
  {
    prob = 25,

    liquids = { lava=90, blood=40 }

    keys = { ks_red=50, ks_blue=50, ks_yellow=50 }

    buildings = { D1_Hot_room=50 }
    outdoors  = { D1_Hot_outdoors=50 }
    caves     = { D1_Hell_cave=50 }


    logos = { carve=90, pill=50, neon=5 }

    pictures =
    {
      marbfac2=10, marbfac3=10,
      spface1=2, firewall=20,
      spine=5,

      skulls1=20, skulls2=20,
    }

    OLD__exits = { skin_pillar=40,
              demon_pillar2=10, demon_pillar3=10 }

    OLD__switches = { sw_skin=50, sw_vine=50, sw_wood=50 }

    bars = { bar_wood=50, bar_metal=50 }

    outer_fences = { ROCKRED1=25, SP_ROCK1=20, BROVINE2=10, GRAYVINE=10 }

    monster_prefs = { zombie=0.3, shooter=0.6, skull=2.0 }
  }


  -- Thy Flesh Consumed by Mr. Chris
  -- Basically a modified version of doom_hell1 to match id's E4 better

  doom_flesh1 =
  {
    prob = 40,

    liquids = { lava=30, blood=50, nukage=10, water=20 }

    buildings = { Flesh_room=50 }
    caves     = { Flesh_cave=50 }
    outdoors  = { Flesh_outdoors=50 }

    __logos = { carve=90, pill=50, neon=5 }

    __pictures =
    {
      marbface=10, skinface=10, firewall=10,
      spdude1=5, spdude2=5, spdude5=5, spine=2,

      skulls1=8, skulls2=8, spdude3=3, spdude6=3,
    }

    keys = { ks_red=50, ks_blue=50, ks_yellow=50 }

    __exits = { skin_pillar=30, demon_pillar2=10 }

    __switches = { sw_marble=50, sw_vine=50, sw_wood=50 }

    __bars = { bar_wood=50, bar_metal=50 }

    outer_fences = { ROCKRED1=25, SP_ROCK1=20, BROVINE2=10, GRAYVINE=10, MARBLE3=10, BROWNHUG=20 }

    __crates = { crate1=0, crate2=0, comp=0, lite5=0, wood=50, ick=15, }

    monster_prefs =
    {
      zombie=0.6, shooter=0.8, skull=1.2,
      demon=2.0, spectre=1.2,
      imp=2.0, baron=1.5, caco=0.8
    }
  }
}


DOOM2.LEVEL_THEMES =
{
  doom_tech1 =
  {
    prob = 60

    liquids = { nukage=90, water=15, lava=10, slime=5 }

    buildings = { Tech2_startan3=60, Tech2_startan2=40,
                  Tech2_stargrey=10,
                  Tech2_tekgren=20, Tech2_metal2=10,
                }
    hallways  = { Tech2_hallway=50 }
    caves     = { Tech2_cave=50 }
    outdoors  = { Tech2_outdoors=50 }

    __exit = -- FIXME : move this stuff into a skin
    {
      walls =
      {
        METAL2=50, STARTAN2=50, STARG1=50,
        TEKWALL4=50, PIPEWAL2=50,
        TEKGREN1=50, SPACEW2=50, STARBR2=50,

        METAL2=50, PIPEWAL2=50, TEKGREN1=50, SPACEW2=50,
      }
      floors =
      {
        FLOOR0_3=50, FLOOR5_2=50
      }
      ceilings =
      {
        TLITE6_6=50, TLITE6_5=50, FLAT17=50,
        FLOOR1_7=50, CEIL4_3=50,

        GRNLITE1=20,
      }
      switches =
      {
        SW1METAL=50, SW1LION=50, SW1BRN2=50, SW1BRNGN=50,
        SW1GRAY=50, SW1MOD1=50, SW1SLAD=50, SW1STRTN=50,
        SW1TEK=50, SW1STON1=50
      }
    }

    OLD__doors =
    {
      silver=20, silver_fast=33, silver_once=2,
      bigdoor2=5, bigdoor2_fast=8, bigdoor2_once=5,
      bigdoor4=5, bigdoor4_fast=8, bigdoor4_once=5,
      bigdoor3=5,
    }

    ceil_lights =
    {
      TLITE6_5=50, TLITE6_6=30, TLITE6_1=30, FLOOR1_7=30,
      FLAT2=20,  CEIL3_4=10, FLAT22=10,

      GRNLITE1=10,
    }

    big_lights =
    {
      TLITE6_5=30, TLITE6_6=30, GRNLITE1=30, FLAT17=30, CEIL3_4=30,

      GRNLITE1=20
    }

    pillars =
    {
      metal1=70, tekwall4=20,
      teklite=50, silver2=10, shawn2=10, metal1=15
    }

    big_pillars = { big_red=50, big_blue=50 }

    logos = { carve=5, pill=50, neon=50 }

    pictures =
    {
      shawn1=10, tekwall1=4, tekwall4=2,
      lite5=30, lite5_05blink=10, lite5_10blink=10,
      liteblu4=30, liteblu4_05sync=10, liteblu4_10sync=10,
      compsta1=40, compsta1_blink=4,
      compsta2=40, compsta2_blink=4,
      redwall=5,

      silver3=20, spacewall=20,
    }

    crates = { crate1=50, crate2=50, comp=70, lite5=20,
      space=90, mod=15 }

    OLD__exits = { skull_pillar=50, stone_pillar=5 }

    monster_prefs = { arach=2.0 }

    style_list =
    {
      naturals = { none=30, few=70, some=30, heaps=2 }
    }
  }


  doom_hell1 =
  {
    prob = 50,

    liquids = { lava=90, blood=40, nukage=5 }

    keys = { ks_red=50, ks_blue=50, ks_yellow=50 }

    buildings = { Hell2_hotbrick=50, Hell2_marble=50 }
    hallways  = { Hell2_hallway=50 }
    outdoors  = { Hell2_outdoors=50 }
    caves     = { Hell2_cave=50 }

    FIXME_switch_doors = { Door_pink = 50, Door_vine = 50 }

    exits = { Exit_demon_pillar=50 }

    logos = { carve=90, pill=50, neon=5 }

    pictures =
    {
      marbface=10, skinface=10, firewall=20,
      spdude1=4, spdude2=4, spdude5=3, spine=2,
    }

    big_pillars = { big_red=50, sloppy=20, sloppy2=20, }

    OLD__switches = { sw_skin=50, sw_vine=50, sw_wood=50 }

    bars = { bar_wood=50, bar_metal=50 }

    outer_fences = { ROCKRED1=25, SP_ROCK1=20, BROVINE2=10, GRAYVINE=10 }

    monster_prefs = { zombie=0.3, shooter=0.6, skull=2.0, vile=2.0 }
  }


  -- AJA: not sure whether to keep this
  Hmmm_doom_hell2 =
  {
    prob = 25,

    liquids = { lava=40, blood=90, slime=10 }

    keys = { ks_red=50, ks_blue=50, ks_yellow=50 }

    buildings = { D2_Hot_room=50 }
    outdoors  = { D2_Hot_outdoors=50 }
    caves     = { D2_Hell_cave=50 }

    FIXME_switch_doors = { Door_pink = 50, Door_vine = 50 }

    OLD__exits = { skin_pillar=40, skull_pillar=20,
      demon_pillar2=10, demon_pillar3=10 }

    big_pillars = { big_red=50, sloppy=20, sloppy2=20, }

    logos = { carve=90, pill=50, neon=5 }

    pictures =
    {
      marbfac2=10, marbfac3=10,
      spface1=2, firewall=20,
      spine=5,

      spdude7=7,
    }

    OLD__switches = { sw_skin=50, sw_marble=50, sw_vine=50 }

    bars = { bar_wood=50, bar_metal=50 }

    outer_fences = { ROCKRED1=25, SP_ROCK1=20, BROVINE2=10, GRAYVINE=10 }

    monster_prefs = { zombie=0.3, shooter=0.6, skull=2.0, vile=2.0 }
  }


  doom_urban1 =
  {
    prob = 50,

    liquids = { water=90, slime=40, lava=20, blood=7, nukage=2 }

    buildings = { Urban_panel=20, Urban_brick=50, Urban_bigbrik=50,
                  Urban_stone=60 }
    hallways  = { Urban_hallway=50 }
    caves     = { Urban_cave=50 }
    outdoors  = { Urban_outdoors=50 }

    exits = { Exit_urban_pillar=50 }

    __logos = { carve=40, pill=25, neon=50 }

    __pictures =
    {
      eagle1=40, hitler1=10,
      marbfac2=3, marbfac3=3,
    }

    OLD__exits = { demon_pillar2=20, demon_pillar3=20, stone_pillar=30, }

    lifts = { shiny=20, platform=20, rusty=50 }

    OLD__switches = { sw_wood=50, sw_blue=50, sw_hot=50 }

    bars = { bar_wood=50, bar_metal=50 }

    room_types =
    {
      -- FIXME PRISON WAREHOUSE
    }

    monster_prefs =
    {
      caco=1.3, revenant=1.2, knight=1.5, demon=1.2, gunner=1.5,
    }
  }


  -- this theme is not normally used (only for secret levels)
  doom_wolf1 =
  {
    prob = 10,

    max_dominant_themes = 1

    buildings = { Wolf_cells=50, Wolf_brick=30, Wolf_stein=50 }

    caves = { Wolf_cave=50 }

    outdoors = { Wolf_outdoors=50 }

    hallways = { Wolf_hall=50 }

    __pictures = { eagle1=50, hitler1=10 }

    OLD__exits = { skull_pillar=50, stone_pillar=8 }

    OLD__switches = { sw_wood=50, sw_blue=50, sw_hot=50 }

    bars = { bar_wood=50, bar_gray=50, bar_silver=50 }

    OLD__doors = { wolf_door=90, wolf_elev_door=5 }

    force_mon_probs = { ss_dude=70, demon=20, shooter=20, zombie=20, _else=0 }

    ---??? weap_prefs = { chain=3, shotty=3, super=3 }

    style_list =
    {
      naturals = { none=40, few=60, some=10 }
    }
  }
}


DOOM.PREBUILT_LEVELS =
{
  E1M8 =
  {
    { prob=40, file="doom1_boss/anomaly1.wad", map="E1M8" }
    { prob=80, file="doom1_boss/anomaly2.wad", map="E1M8" }
  }

  E2M8 =
  {
    { prob=50, file="doom1_boss/tower1.wad", map="E2M8" }
  }

  E3M8 =
  {
    { prob=50, file="doom1_boss/dis1.wad", map="E3M8" }
  }


  MAP07 =
  {
    { prob=30, file="doom2_boss/simple1.wad", map="MAP07" }
    { prob=50, file="doom2_boss/simple2.wad", map="MAP07" }
    { prob=70, file="doom2_boss/simple3.wad", map="MAP07" }
  }

  MAP30 =
  {
    { prob=30, file="doom2_boss/icon1.wad", map="MAP30" }
    { prob=50, file="doom2_boss/icon2.wad", map="MAP30" }
  }

  
  GOTCHA =
  {
    { prob=50, file="doom2_boss/gotcha1.wad", map="MAP01" }
    { prob=50, file="doom2_boss/gotcha2.wad", map="MAP01" }
    { prob=40, file="doom2_boss/gotcha3.wad", map="MAP01" }
    { prob=10, file="doom2_boss/gotcha4.wad", map="MAP01" }
  }

  GALLOW =
  {
    { prob=50, file="doom2_boss/gallow1.wad", map="MAP01" }
    { prob=25, file="doom2_boss/gallow2.wad", map="MAP01" }
  }
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
    level = 1
    prob = 40
    health = 20
    damage = 4
    attack = "hitscan"
    give = { {ammo="bullet",count=5} }
    density = 1.5
    infights = true
  }

  shooter =
  {
    level = 2
    prob = 50
    health = 30
    damage = 10
    attack = "hitscan"
    give = { {weapon="shotty"}, {ammo="shell",count=4} }
    species = "zombie"
    infights = true
  }

  imp =
  {
    level = 1
    prob = 60
    health = 60
    damage = 20
    attack = "missile"
  }

  skull =
  {
    level = 3
    prob = 16
    health = 100
    damage = 7
    attack = "melee"
    density = 0.5
    float = true
    weap_prefs = { launch=0.2 }
    infights = true
  }

  demon =
  {
    level = 1
    prob = 35
    health = 150
    damage = 25
    attack = "melee"
    weap_prefs = { launch=0.5 }
  }

  spectre =
  {
    replaces = "demon"
    replace_prob = 25
    crazy_prob = 21
    health = 150
    damage = 25
    attack = "melee"
    invis = true
    outdoor_factor = 3.0
    weap_prefs = { launch=0.2 }
    species = "demon"
  }

  caco =
  {
    level = 3
    prob = 40
    health = 400
    damage = 35
    attack = "missile"
    density = 0.5
    float = true
  }

  baron =
  {
    level = 7
    prob = 20
    health = 1000
    damage = 45
    attack = "missile"
    density = 0.5
    weap_prefs = { bfg=3.0 }
  }


  ---| DOOM BOSSES |---

  Cyberdemon =
  {
    level = 9
    prob = 17
    crazy_prob = 12
    skip_prob = 150
    health = 4000
    damage = 150
    attack = "missile"
    density = 0.1
    weap_prefs = { bfg=5.0 }
  }

  Mastermind =
  {
    level = 9
    prob = 20
    crazy_prob = 18
    skip_prob = 150
    health = 3000
    damage = 70
    attack = "hitscan"
    density = 0.2
    weap_prefs = { bfg=5.0 }
  }
}


DOOM2.MONSTERS =
{
  gunner =
  {
    level = 3
    prob = 20
    health = 70
    damage = 50
    attack = "hitscan"
    give = { {weapon="chain"}, {ammo="bullet",count=10} }
    species = "zombie"
    infights = true
  }

  revenant =
  {
    level = 5
    prob = 40
    skip_prob = 90
    health = 300
    damage = 70
    attack = "missile"
    density = 0.6
  }

  knight =
  {
    level = 5
    prob = 60
    skip_prob = 90
    crazy_prob = 40
    health = 500
    damage = 45
    attack = "missile"
    density = 0.7
    species = "baron"
  }

  mancubus =
  {
    level = 6
    prob = 37
    health = 600
    damage = 70
    attack = "missile"
    density = 0.6
  }

  arach =
  {
    level = 6
    prob = 25
    health = 500
    damage = 70
    attack = "missile"
    density = 0.8
  }

  vile =
  {
    level = 7
    prob = 17
    skip_prob = 120
    health = 700
    damage = 40
    attack = "hitscan"
    density = 0.2
    never_promote = true
  }

  pain =
  {
    level = 6
    prob = 8
    crazy_prob = 15
    skip_prob = 180
    health = 700
    damage = 20
    attack = "missile"
    density = 0.2
    never_promote = true
    float = true
    weap_prefs = { launch=0.2 }
  }

  ss_dude =
  {
    -- NOTE: not generated in normal levels
    level = 1
    crazy_prob = 7
    skip_prob = 300
    health = 50
    damage = 15
    attack = "hitscan"
    give = { {ammo="bullet",count=5} }
    density = 2.0
  }
}


DOOM.INFIGHT_SHEET =
{
  -- default for same species : friends (no harm)
  same = "friend"

  -- default for different species : hurt and fight each other
  different = "infight"
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
    attack = "melee"
    rate = 1.5
    damage = 10
  }

  saw =
  {
    level = 1
    pref = 3
    add_prob = 2
    attack = "melee"
    rate = 8.7
    damage = 10
  }

  berserk =
  {
    level = 5
    pref = 10
    add_prob = 5
    attack = "melee"
    rate = 1.5
    damage = 90
    give = { {health=70} }
  }

  pistol =
  {
    pref = 5
    attack = "hitscan"
    rate = 1.8
    damage = 10
    ammo = "bullet"
    per = 1
  }

  chain =
  {
    level = 1
    pref = 70
    add_prob = 35
    attack = "hitscan"
    rate = 8.5
    damage = 10
    ammo = "bullet"
    per = 1
    give = { {ammo="bullet",count=20} }
  }

  shotty =
  {
    level = 1
    pref = 70
    add_prob = 10
    start_prob = 60
    attack = "hitscan"
    rate = 0.9
    damage = 70
    splash = { 0,10 }
    ammo = "shell"
    per = 1
    give = { {ammo="shell",count=8} }
  }

  launch =
  {
    level = 3
    pref = 50
    add_prob = 25
    attack = "missile"
    rate = 1.7
    damage = 80
    splash = { 50,20,5 }
    ammo = "rocket"
    per = 1
    give = { {ammo="rocket",count=2} }
  }

  plasma =
  {
    level = 5
    pref = 30
    add_prob = 13
    attack = "missile"
    rate = 11
    damage = 20
    ammo = "cell"
    per = 1
    give = { {ammo="cell",count=40} }
  }

  bfg =
  {
    level = 7
    pref = 15
    add_prob = 20
    attack = "missile"
    rate = 0.65  -- tweaked value, normally 0.8
    damage = 300
    splash = {70,70,70,70, 70,70,70,70, 70,70,70,70}
    ammo = "cell"
    per = 40
    give = { {ammo="cell",count=40} }
  }

  -- this is Doom II only --
  super =
  {
    level = 4
    pref = 50
    add_prob = 20
    start_prob = 60
    attack = "hitscan"
    rate = 0.6
    damage = 170
    splash = { 0,30 }
    ammo = "shell"
    per = 2
    give = { {ammo="shell",count=8} }
  }
}


DOOM.AMMOS =
{
  bullet = { start_bonus = 60 }
  shell  = { start_bonus = 12 }
  rocket = { start_bonus = 4  }
  cell   = { start_bonus = 40 }
}


-- Pickup List
-- ===========

DOOM.PICKUPS =
{
  -- HEALTH --

  potion =
  {
    prob = 20
    cluster = { 4,7 }
    give = { {health=1} }
  }

  stimpack =
  {
    prob = 60
    cluster = { 2,5 }
    give = { {health=10} }
  }

  medikit =
  {
    prob = 100
    give = { {health=25} }
  }

  soul =
  {
    prob = 3
    big_item = true
    start_prob = 5
    give = { {health=150} }
  }

  -- ARMOR --

  helmet =
  {
    prob = 10
    armor = true
    cluster = { 4,7 }
    give = { {health=1} }
  }

  green_armor =
  {
    prob = 5
    armor = true
    big_item = true
    start_prob = 80
    give = { {health=30} }
  }

  blue_armor =
  {
    prob = 2
    armor = true
    big_item = true
    start_prob = 30
    give = { {health=80} }
  }

  -- AMMO --

  bullets =
  {
    prob = 10
    cluster = { 2,5 }
    give = { {ammo="bullet",count=10} }
  }

  bullet_box =
  {
    prob = 40
    give = { {ammo="bullet",count=50} }
  }

  shells =
  {
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="shell",count=4} }
  }

  shell_box =
  {
    prob = 40
    give = { {ammo="shell",count=20} }
  }

  rockets =
  {
    prob = 10
    cluster = { 4,7 }
    give = { {ammo="rocket",count=1} }
  }

  rocket_box =
  {
    prob = 40
    give = { {ammo="rocket",count=5} }
  }

  cells =
  {
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="cell",count=20} }
  }

  cell_pack =
  {
    prob = 40
    give = { {ammo="cell",count=100} }
  }

  -- Doom II only --

  mega =
  {
    prob = 1
    armor = true
    big_item = true
    start_prob = 8
    give = { {health=200} }
  }


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
    stats   = { health=0 }
    weapons = { pistol=1, fist=1 }
  }
}


DOOM1.EPISODES =
{
  episode1 =
  {
    sky_light = 0.85
    secret_exits = { "E1M3" }
  }

  episode2 =
  {
    sky_light = 0.65
    secret_exits = { "E2M5" }
  }

  episode3 =
  {
    sky_light = 0.75
    secret_exits = { "E3M6" }
  }

  episode4 =
  {
    sky_light = 0.75
    secret_exits = { "E4M2" }
  }
}

DOOM2.EPISODES =
{
  episode1 =
  {
    sky_light = 0.75
  }

  episode2 =
  {
    sky_light = 0.50
    secret_exits = { "MAP16", "MAP31" }
  }

  episode3 =
  {
    sky_light = 0.75
  }
}


DOOM1.ORIGINAL_THEMES =
{
  "doom_tech"
  "doom_deimos"
  "doom_hell"
  "doom_flesh"
}

DOOM2.ORIGINAL_THEMES =
{
  "doom_tech"
  "doom_urban"
  "doom_hell"
}


------------------------------------------------------------


function DOOM1.setup()
  -- remove Doom II only stuff
  GAME.WEAPONS["super"] = nil
  GAME.PICKUPS["mega"]  = nil

  -- tweak monster probabilities
  GAME.MONSTERS["Cyberdemon"].crazy_prob = 8
  GAME.MONSTERS["Mastermind"].crazy_prob = 12
end


function DOOM2.setup()
  -- nothing needed
end


function DOOM1.get_levels()
  local EP_MAX  = (OB_CONFIG.game   == "ultdoom" ? 4 ; 3)
  local EP_NUM  = (OB_CONFIG.length == "full"    ? EP_MAX ; 1)
  local MAP_NUM = (OB_CONFIG.length == "single"  ? 1 ; 9)

  if OB_CONFIG.length == "few" then MAP_NUM = 4 end

  local few_episodes = { 1, 1, 2, 2 }

  -- this accounts for last two levels are BOSS and SECRET level
  local LEV_MAX = MAP_NUM
  if LEV_MAX == 9 then LEV_MAX = 7 end

  for ep_index = 1,EP_NUM do
    -- create episode info...
    local EPI =
    {
      levels = {}
    }

    table.insert(GAME.episodes, EPI)

    local ep_info = DOOM1.EPISODES["episode" .. ep_index]
    assert(ep_info)

    for map = 1,MAP_NUM do
      local ep_along = map / LEV_MAX

      if MAP_NUM == 1 then
        ep_along = rand.range(0.3, 0.7);
      elseif map == 9 then
        ep_along = 0.5
      end

      -- create level info...
      local LEV =
      {
        episode = EPI

        name  = string.format("E%dM%d",   ep_index,   map)
        patch = string.format("WILV%d%d", ep_index-1, map-1)

         ep_along = ep_along
        mon_along = ep_along + (ep_index-1) / 5

        sky_light   = ep_info.sky_light
        secret_kind = (map == 9) and "plain"
      }

      table.insert( EPI.levels, LEV)
      table.insert(GAME.levels, LEV)

      if OB_CONFIG.length == "few" then
---!!!  LEV.episode = few_episodes[map]
      end

      -- prebuilt levels
      local pb_name = LEV.name

      if LEV.name == "E4M6" then pb_name = "E2M8" end
      if LEV.name == "E4M8" then pb_name = "E3M8" end

      LEV.prebuilt = GAME.PREBUILT_LEVELS[pb_name]

      if LEV.prebuilt then
        LEV.name_theme = LEV.prebuilt.name_theme or "BOSS"
      end

      if MAP_NUM == 1 or map == 3 then
        LEV.demo_lump = string.format("DEMO%d", ep_index)
      end
    end -- for map

  end -- for episode
end


function DOOM2.get_levels()
  local MAP_NUM = 11

  if OB_CONFIG.length == "single" then MAP_NUM = 1  end
  if OB_CONFIG.length == "few"    then MAP_NUM = 4  end
  if OB_CONFIG.length == "full"   then MAP_NUM = 32 end

  gotcha_map = rand.pick{17,18,19}
  gallow_map = rand.pick{24,25,26}

  local few_episodes = { 1, rand.sel(70,1,2), rand.sel(70,2,3), 3 }

  local EP_NUM = 1
  if MAP_NUM > 11 then EP_NUM = 2 end
  if MAP_NUM > 30 then EP_NUM = 3 end

  -- create episode info...

  for ep_index = 1,EP_NUM do
    local EPI =
    {
      levels = {}
    }

    table.insert(GAME.episodes, EPI)
  end

  -- create level info...

  for map = 1,MAP_NUM do
    -- determine episode from map number
    local ep_index
    local ep_along

    if map >= 31 then
      ep_index = 2 ; ep_along = 0.35
    elseif map >= 21 then
      ep_index = 3 ; ep_along = (map - 20) / 10
    elseif map >= 12 then
      ep_index = 2 ; ep_along = (map - 11) / 9
    else
      ep_index = 1 ; ep_along = map / 11
    end

    if OB_CONFIG.length == "single" then
      ep_along = rand.pick{ 0.2, 0.3, 0.4, 0.6, 0.8 }
    elseif OB_CONFIG.length == "few" then
      ep_along = map / MAP_NUM
    end

    local EPI = GAME.episodes[ep_index]
    assert(EPI)

    local ep_info = DOOM2.EPISODES["episode" .. ep_index]
    assert(ep_info)
    assert(ep_along <= 1)

    local LEV =
    {
      episode = EPI

      name  = string.format("MAP%02d", map)
      patch = string.format("CWILV%02d", map-1)

      ep_along = ep_along

      sky_light = ep_info.sky_light
    }

    table.insert( EPI.levels, LEV)
    table.insert(GAME.levels, LEV)

    if map == 31 or map == 32 then
      -- secret levels are easy
      LEV.mon_along = 0.35
    elseif OB_CONFIG.length == "single" then
      LEV.mon_along = ep_along
    else
      -- difficulty ramps up over whole wad
      LEV.mon_along = math.quadratic(map / (MAP_NUM + 1))
    end

    if OB_CONFIG.length == "few" then
---!!!  LEV.episode = few_episodes[map]
    end

    -- secret levels
    if map == 31 or map == 32 then
      LEV.theme_name = "doom_wolf1"
      LEV.theme = GAME.LEVEL_THEMES[LEV.theme_name]

      LEV.name_theme = "URBAN"
    end

    if map == 23 then
      LEV.style_list = { barrels = { heaps=100 } }
    end

    -- prebuilt levels
    local pb_name = LEV.name

    if map == gotcha_map then pb_name = "GOTCHA" end
    if map == gallow_map then pb_name = "GALLOW" end
    
    LEV.prebuilt = GAME.PREBUILT_LEVELS[pb_name]

    if LEV.prebuilt then
      LEV.name_theme = LEV.prebuilt.name_theme or "BOSS"
    end

    if MAP_NUM == 1 or (map % 10) == 3 then
      LEV.demo_lump = string.format("DEMO%d", ep_index)
    end
  end
end


DOOM.LEVEL_GFX_COLORS =
{
  gold   = { 0,47,44, 167,166,165,164,163,162,161,160, 225 }
  silver = { 0,246,243,240, 205,202,200,198, 196,195,194,193,192, 4 }
  bronze = { 0,2, 191,188, 235,232, 221,218,215,213,211,209 }
  iron   = { 0,7,5, 111,109,107,104,101,98,94,90,86,81 }
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

UNFINISHED["doom1"] =
{
  label = "Doom"

  priority = 98  -- keep at second spot

  format = "doom"

  tables =
  {
    DOOM, DOOM1
  }

  hooks =
  {
    setup        = DOOM1.setup
    get_levels   = DOOM1.get_levels

    end_level    = DOOM.end_level
    all_done     = DOOM.all_done
  }
}


UNFINISHED["ultdoom"] =
{
  label = "Ultimate Doom"

  extends = "doom1"

  priority = 97  -- keep at third spot
  
  -- no additional tables

  -- no additional hooks
}


OB_GAMES["doom2"] =
{
  label = "Doom 2"

  priority = 99  -- keep at top

  format = "doom"

  tables =
  {
    DOOM, DOOM2
  }

  hooks =
  {
    setup        = DOOM2.setup
    get_levels   = DOOM2.get_levels

    end_level    = DOOM.end_level
    all_done     = DOOM.all_done
  }
}


------------------------------------------------------------

OB_THEMES["doom_tech"] =
{
  label = "Tech"
  priority = 8
  for_games = { doom1=1, doom2=1 }
  name_theme = "TECH"
  mixed_prob = 60
}

UNFINISHED["doom_deimos"] =
{
  label = "Deimos"
  priority = 6
  for_games = { doom1=1 }
  name_theme = "TECH"
  mixed_prob = 30
}

OB_THEMES["doom_hell"] =
{
  label = "Hell"
  priority = 4
  for_games = { doom1=1, doom2=1 }
  name_theme = "GOTHIC"
  mixed_prob = 50
}

UNFINISHED["doom_flesh"] =
{
  label = "Thy Flesh"
  priority = 2
  for_games = { ultdoom=1 }
  name_theme = "GOTHIC"
  mixed_prob = 20
}


OB_THEMES["doom_urban"] =
{
  label = "Urban"
  priority = 6
  for_games = { doom2=1 }
  name_theme = "URBAN"
  mixed_prob = 50
}

OB_THEMES["doom_wolf"] =
{
  label = "Wolfenstein",
  priority = 2
  for_games = { doom2=1 }
  name_theme = "URBAN"

  -- this theme is special, hence no mixed_prob
  psycho_prob = 5
}

