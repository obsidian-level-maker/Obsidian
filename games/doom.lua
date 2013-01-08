----------------------------------------------------------------
--  GAME DEFINITION : DOOM II : HELL ON EARTH
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2013 Andrew Apted
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

DOOM2 = { }  -- stuff specific to DOOM II


DOOM.ENTITIES =
{
  --- PLAYERS ---

  player1 = { id=1, r=16, h=56 }
  player2 = { id=2, r=16, h=56 }
  player3 = { id=3, r=16, h=56 }
  player4 = { id=4, r=16, h=56 }

  dm_player     = { id=11 }
  teleport_spot = { id=14 }

  --- KEYS ---

  kc_red     = { id=13 }
  kc_yellow  = { id=6  }
  kc_blue    = { id=5  }

  ks_red     = { id=38 }
  ks_yellow  = { id=39 }
  ks_blue    = { id=40 }

  --- POWERUPS ---

  backpack = { id=8 }
  invul    = { id=2022 }
  invis    = { id=2024 }
  suit     = { id=2025 }
  map      = { id=2026 }
  goggles  = { id=2045 }


  --- SCENERY ---

  -- lights --
  lamp         = { id=2028,r=16, h=48, light=255 }
  mercury_lamp = { id=85,  r=16, h=80, light=255 }
  short_lamp   = { id=86,  r=16, h=60, light=255 }
  tech_column  = { id=48,  r=16, h=128,light=255 }

  candle         = { id=34, r=16, h=16, light=111, pass=true }
  candelabra     = { id=35, r=16, h=56, light=255 }
  burning_barrel = { id=70, r=16, h=44, light=255 }

  blue_torch     = { id=44, r=16, h=96, light=255 }
  blue_torch_sm  = { id=55, r=16, h=72, light=255 }
  green_torch    = { id=45, r=16, h=96, light=255 }
  green_torch_sm = { id=56, r=16, h=72, light=255 }
  red_torch      = { id=46, r=16, h=96, light=255 }
  red_torch_sm   = { id=57, r=16, h=72, light=255 }

  -- decoration --
  barrel = { id=2035, r=12, h=44 }

  green_pillar     = { id=30, r=16, h=56 }
  green_column     = { id=31, r=16, h=40 }
  green_column_hrt = { id=36, r=16, h=56, add_mode="island" }

  red_pillar     = { id=32, r=16, h=52 }
  red_column     = { id=33, r=16, h=56 }
  red_column_skl = { id=37, r=16, h=56, add_mode="island" }

  burnt_tree = { id=43, r=16, h=56, add_mode="island" }
  brown_stub = { id=47, r=16, h=56, add_mode="island" }
  big_tree   = { id=54, r=31, h=120,add_mode="island" }

  -- gore --
  evil_eye    = { id=41, r=16, h=56, add_mode="island" }
  skull_rock  = { id=42, r=16, h=48 }
  skull_pole  = { id=27, r=16, h=52 }
  skull_kebab = { id=28, r=20, h=64 }
  skull_cairn = { id=29, r=20, h=40, add_mode="island" }

  impaled_human  = { id=25,r=20, h=64 }
  impaled_twitch = { id=26,r=16, h=64 }

  gutted_victim1 = { id=73, r=16, h=88, ceil=true }
  gutted_victim2 = { id=74, r=16, h=88, ceil=true }
  gutted_torso1  = { id=75, r=16, h=64, ceil=true }
  gutted_torso2  = { id=76, r=16, h=64, ceil=true }
  gutted_torso3  = { id=77, r=16, h=64, ceil=true }
  gutted_torso4  = { id=78, r=16, h=64, ceil=true }

  hang_arm_pair  = { id=59, r=20, h=84, ceil=true, pass=true }
  hang_leg_pair  = { id=60, r=20, h=68, ceil=true, pass=true }
  hang_leg_gone  = { id=61, r=20, h=52, ceil=true, pass=true }
  hang_leg       = { id=62, r=20, h=52, ceil=true, pass=true }
  hang_twitching = { id=63, r=20, h=68, ceil=true, pass=true }

  gibs          = { id=24, r=20, h=16, pass=true }
  gibbed_player = { id=10, r=20, h=16, pass=true }
  pool_blood_1  = { id=79, r=20, h=16, pass=true }
  pool_blood_2  = { id=80, r=20, h=16, pass=true }
  pool_brains   = { id=81, r=20, h=16, pass=true }

  -- Note: id=12 exists, but is exactly the same as id=10

  dead_player  = { id=15, r=16, h=16, pass=true }
  dead_zombie  = { id=18, r=16, h=16, pass=true }
  dead_shooter = { id=19, r=16, h=16, pass=true }
  dead_imp     = { id=20, r=16, h=16, pass=true }
  dead_demon   = { id=21, r=16, h=16, pass=true }
  dead_caco    = { id=22, r=16, h=16, pass=true }
  dead_skull   = { id=23, r=16, h=16, pass=true }

  -- special stuff --
  dummy = { id=23, r=16, h=16, pass=true }

  keen  = { id=72, r=16, h=72, ceil=true }

  brain_boss    = { id=88, r=16, h=16 }
  brain_shooter = { id=89, r=20, h=32 }
  brain_target  = { id=87, r=20, h=32, pass=true }

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

  _ERROR = { t="METAL",   f="CEIL5_2" }
  _SKY   = { t="CEMENT3", f="F_SKY1" }


  -- general purpose --

  METAL  = { t="METAL",    f="CEIL5_2" }

  SUPPORT2 = { t="SUPPORT2", f="FLAT23" }
  SUPPORT3 = { t="SUPPORT3", f="CEIL5_2" }


  -- walls --

  BIGDOOR1 = { t="BIGDOOR1", f="FLAT23" }
  BIGDOOR2 = { t="BIGDOOR2", f="FLAT1" }
  BIGDOOR3 = { t="BIGDOOR3", f="FLOOR7_2" }
  BIGDOOR4 = { t="BIGDOOR4", f="FLOOR3_3" }
  BIGDOOR5 = { t="BIGDOOR5", f="FLAT5_2" }
  BIGDOOR6 = { t="BIGDOOR6", f="CEIL5_2" }
  BIGDOOR7 = { t="BIGDOOR7", f="CEIL5_2" }

  BROWN1   = { t="BROWN1",   f="FLOOR0_1" }
  BROWN144 = { t="BROWN144", f="FLOOR7_1" }
  BROWN96  = { t="BROWN96",  f="FLOOR7_1" }
  BROWNGRN = { t="BROWNGRN", f="FLOOR7_1" }
  BROWNHUG = { t="BROWNHUG", f="FLOOR7_1" }
  BROWNPIP = { t="BROWNPIP", f="FLOOR0_1" }
  BROVINE2 = { t="BROVINE2", f="FLOOR7_1" }
  BRNPOIS  = { t="BRNPOIS",  f="FLOOR7_1" }

  COMPBLUE = { t="COMPBLUE", f="FLAT14" }
  COMPSPAN = { t="COMPSPAN", f="CEIL5_1" }
  COMPSTA1 = { t="COMPSTA1", f="FLAT23" }
  COMPSTA2 = { t="COMPSTA2", f="FLAT23" }
  COMPTALL = { t="COMPTALL", f="CEIL5_1" }
  COMPWERD = { t="COMPWERD", f="CEIL5_1" }

  CRATE1   = { t="CRATE1",   f="CRATOP2"  }
  CRATE2   = { t="CRATE2",   f="CRATOP1"  }
  CRATELIT = { t="CRATELIT", f="CRATOP1"  }
  CRATINY  = { t="CRATINY",  f="CRATOP1"  }
  CRATWIDE = { t="CRATWIDE", f="CRATOP1"  }

  -- keep locked doors recognisable
  DOORBLU  = { t="DOORBLU",  f="FLAT23",  sane=1 }
  DOORRED  = { t="DOORRED",  f="FLAT23",  sane=1 }
  DOORYEL  = { t="DOORYEL",  f="FLAT23",  sane=1 }
  DOORBLU2 = { t="DOORBLU2", f="CRATOP2", sane=1 }
  DOORRED2 = { t="DOORRED2", f="CRATOP2", sane=1 }
  DOORYEL2 = { t="DOORYEL2", f="CRATOP2", sane=1 }

  DOOR1    = { t="DOOR1",    f="FLAT23" }
  DOOR3    = { t="DOOR3",    f="FLAT23" }
  DOORSTOP = { t="DOORSTOP", f="FLAT23" }
  DOORTRAK = { t="DOORTRAK", f="FLAT23" }

  EXITDOOR = { t="EXITDOOR", f="FLAT5_5" }
  EXITSIGN = { t="EXITSIGN", f="CEIL5_1" }
  EXITSTON = { t="EXITSTON", f="MFLR8_1" }

  -- these three are animated
  FIREBLU1 = { t="FIREBLU1", f="FLOOR6_1" }
  FIRELAVA = { t="FIRELAVA", f="FLOOR6_1" }
  FIREWALL = { t="FIREWALL", f="FLAT5_3" }

  GRAY1    = { t="GRAY1",    f="FLAT18" }
  GRAY2    = { t="GRAY2",    f="FLAT18" }
  GRAY4    = { t="GRAY4",    f="FLAT18" }
  GRAY5    = { t="GRAY5",    f="FLAT18" }
  GRAY7    = { t="GRAY7",    f="FLAT18" }
  GRAYBIG  = { t="GRAYBIG",  f="FLAT18" }
  GRAYPOIS = { t="GRAYPOIS", f="FLAT18" }
  GRAYTALL = { t="GRAYTALL", f="FLAT18" }
  GRAYVINE = { t="GRAYVINE", f="FLAT1" }

  GSTFONT1 = { t="GSTFONT1", f="FLOOR7_2"  }
  GSTGARG  = { t="GSTGARG",  f="FLOOR7_2"  }
  GSTLION  = { t="GSTLION",  f="FLOOR7_2"  }
  GSTONE1  = { t="GSTONE1",  f="FLOOR7_2"  }
  GSTONE2  = { t="GSTONE2",  f="FLOOR7_2"  }
  GSTSATYR = { t="GSTSATYR", f="FLOOR7_2"  }
  GSTVINE1 = { t="GSTVINE1", f="FLOOR7_2"  }
  GSTVINE2 = { t="GSTVINE2", f="FLOOR7_2"  }

  ICKWALL1 = { t="ICKWALL1", f="FLAT19"  }
  ICKWALL2 = { t="ICKWALL2", f="FLAT19"  }
  ICKWALL3 = { t="ICKWALL3", f="FLAT19"  }
  ICKWALL4 = { t="ICKWALL4", f="FLAT19"  }
  ICKWALL5 = { t="ICKWALL5", f="FLAT19"  }
  ICKWALL7 = { t="ICKWALL7", f="FLAT19"  }

  LITE3    = { t="LITE3",    f="FLAT19" }
  LITE5    = { t="LITE5",    f="FLAT19" }
  LITEBLU1 = { t="LITEBLU1", f="FLAT23" }
  LITEBLU4 = { t="LITEBLU4", f="FLAT1"  }

  MARBLE1  = { t="MARBLE1",  f="FLOOR7_2" }
  MARBLE2  = { t="MARBLE2",  f="FLOOR7_2" }
  MARBLE3  = { t="MARBLE3",  f="FLOOR7_2" }
  MARBFACE = { t="MARBFACE", f="FLOOR7_2" }
  MARBFAC2 = { t="MARBFAC2", f="FLOOR7_2" }
  MARBFAC3 = { t="MARBFAC3", f="FLOOR7_2" }
  MARBLOD1 = { t="MARBLOD1", f="FLOOR7_2" }

  METAL1   = { t="METAL1",   f="FLOOR4_8" }
  NUKE24   = { t="NUKE24",   f="FLOOR7_1" }
  NUKEDGE1 = { t="NUKEDGE1", f="FLOOR7_1" }
  NUKEPOIS = { t="NUKEPOIS", f="FLOOR7_1" }

  PIPE1    = { t="PIPE1",    f="FLOOR4_5" }
  PIPE2    = { t="PIPE2",    f="FLOOR4_5" }
  PIPE4    = { t="PIPE4",    f="FLOOR4_5" }
  PIPE6    = { t="PIPE6",    f="FLOOR4_5" }
  PLAT1    = { t="PLAT1",    f="FLAT4" }
  REDWALL  = { t="REDWALL",  f="FLAT5_3" }
  ROCKRED1 = { t="ROCKRED1", f="FLOOR6_1" }

  SHAWN1   = { t="SHAWN1",   f="FLAT23" }
  SHAWN2   = { t="SHAWN2",   f="FLAT23" }
  SHAWN3   = { t="SHAWN3",   f="FLAT23" }

  SKIN2    = { t="SKIN2",    f="SFLR6_4" }
  SKINCUT  = { t="SKINCUT",  f="CEIL5_2" }
  SKINEDGE = { t="SKINEDGE", f="SFLR6_4" }
  SKINFACE = { t="SKINFACE", f="SFLR6_4" }
  SKINLOW  = { t="SKINLOW",  f="FLAT5_2" }
  SKINMET1 = { t="SKINMET1", f="CEIL5_2" }
  SKINMET2 = { t="SKINMET2", f="CEIL5_2" }
  SKINSCAB = { t="SKINSCAB", f="CEIL5_2" }
  SKINSYMB = { t="SKINSYMB", f="CEIL5_2" }
  SKSNAKE1 = { t="SKSNAKE1", f="SFLR6_1" }
  SKSNAKE2 = { t="SKSNAKE2", f="SFLR6_4" }
  SKSPINE1 = { t="SKSPINE1", f="FLAT5_6" }
  SKSPINE2 = { t="SKSPINE2", f="FLAT5_6" }

  SLADPOIS = { t="SLADPOIS", f="FLOOR7_1" }
  SLADSKUL = { t="SLADSKUL", f="FLOOR7_1" }
  SLADWALL = { t="SLADWALL", f="FLOOR7_1" }

  SP_DUDE1 = { t="SP_DUDE1", f="DEM1_5" }
  SP_DUDE2 = { t="SP_DUDE2", f="DEM1_5" }
  SP_DUDE4 = { t="SP_DUDE4", f="DEM1_5" }
  SP_DUDE5 = { t="SP_DUDE5", f="DEM1_5" }
  SP_FACE1 = { t="SP_FACE1", f="CRATOP2" }
  SP_HOT1  = { t="SP_HOT1",  f="FLAT5_3" }
  SP_ROCK1 = { t="SP_ROCK1", f="MFLR8_3" }

  STARBR2  = { t="STARBR2",  f="FLOOR0_2" }
  STARG1   = { t="STARG1",   f="FLAT23" }
  STARG2   = { t="STARG2",   f="FLAT23" }
  STARG3   = { t="STARG3",   f="FLAT23" }
  STARGR1  = { t="STARGR1",  f="FLAT3" }
  STARGR2  = { t="STARGR2",  f="FLAT3" }
  STARTAN2 = { t="STARTAN2", f="FLOOR4_1" }
  STARTAN3 = { t="STARTAN3", f="FLOOR4_5" }

  STONE    = { t="STONE",  f="FLAT5_4" }
  STONE2   = { t="STONE2", f="MFLR8_1" }
  STONE3   = { t="STONE3", f="MFLR8_1" }

  TEKWALL1 = { t="TEKWALL1",  f="CEIL5_1" }
  TEKWALL4 = { t="TEKWALL4",  f="CEIL5_1" }

  WOOD1    = { t="WOOD1",     f="FLAT5_2" }
  WOOD3    = { t="WOOD3",     f="FLAT5_1" }
  WOOD4    = { t="WOOD4",     f="FLAT5_2" }
  WOOD5    = { t="WOOD5",     f="CEIL5_2" }
  WOODGARG = { t="WOODGARG",  f="FLAT5_2" }


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

  CEIL1_1  = { f="CEIL1_1", t="WOOD1" }
  CEIL1_2  = { f="CEIL1_2", t="METAL" }
  CEIL1_3  = { f="CEIL1_3", t="WOOD1" }
  CEIL3_1  = { f="CEIL3_1", t="STARBR2" }
  CEIL3_2  = { f="CEIL3_2", t="STARTAN2" }
  CEIL3_3  = { f="CEIL3_3", t="STARTAN2" }
  CEIL3_4  = { f="CEIL3_4", t="STARTAN2" }
  CEIL3_5  = { f="CEIL3_5", t="STONE2" }
  CEIL3_6  = { f="CEIL3_6", t="STONE2" }

  CEIL4_1  = { f="CEIL4_1", t="COMPBLUE" }
  CEIL4_2  = { f="CEIL4_2", t="COMPBLUE" }
  CEIL4_3  = { f="CEIL4_3", t="COMPBLUE" }
  CEIL5_1  = { f="CEIL5_1", t="COMPSPAN" }
  CEIL5_2  = { f="CEIL5_2", t="METAL" }

  COMP01   = { f="COMP01",  t="GRAY1" }
  CONS1_1  = { f="CONS1_1", t="COMPWERD" }
  CONS1_5  = { f="CONS1_5", t="COMPWERD" }
  CONS1_7  = { f="CONS1_7", t="COMPWERD" }

  DEM1_1   = { f="DEM1_1", t="MARBLE1" }
  DEM1_2   = { f="DEM1_2", t="MARBLE1" }
  DEM1_3   = { f="DEM1_3", t="MARBLE1" }
  DEM1_4   = { f="DEM1_4", t="MARBLE1" }
  DEM1_5   = { f="DEM1_5", t="MARBLE1" }
  DEM1_6   = { f="DEM1_6", t="MARBLE1" }

  FLAT1    = { f="FLAT1",   t="GRAY1" }
  FLAT1_1  = { f="FLAT1_1", t="BROWN1" }
  FLAT1_2  = { f="FLAT1_2", t="BROWN1" }
  FLAT1_3  = { f="FLAT1_3", t="BROWN1" }
  FLAT2    = { f="FLAT2",   t="GRAY1" }
  FLAT3    = { f="FLAT3",   t="GRAY4" }
  FLAT4    = { f="FLAT4",   t="COMPSPAN" }

  FLAT5    = { f="FLAT5",   t="BROWNHUG" }
  FLAT5_1  = { f="FLAT5_1", t="WOOD1" }
  FLAT5_2  = { f="FLAT5_2", t="WOOD1" }
  FLAT5_3  = { f="FLAT5_3", t="REDWALL" }
  FLAT5_4  = { f="FLAT5_4", t="STONE" }
  FLAT5_5  = { f="FLAT5_5", t="BROWN1" }
  FLAT5_6  = { f="FLAT5_6", t="CRACKLE4" }

  FLAT8    = { f="FLAT8",  t="STARBR2" }
  FLAT9    = { f="FLAT9",  t="GRAY4" }
  FLAT10   = { f="FLAT10", t="BROWNHUG" } -- better in DOOM2
  FLAT14   = { f="FLAT14", t="COMPBLUE" }
  FLAT17   = { f="FLAT17", t="GRAY1" }
  FLAT18   = { f="FLAT18", t="GRAY1" }
  FLAT19   = { f="FLAT19", t="GRAY1" }
  FLAT20   = { f="FLAT20", t="SHAWN2" }
  FLAT22   = { f="FLAT22", t="SHAWN2" }
  FLAT23   = { f="FLAT23", t="SHAWN2" }

  FLOOR0_1 = { f="FLOOR0_1", t="STARTAN2" }
  FLOOR0_2 = { f="FLOOR0_2", t="STARBR2" }
  FLOOR0_3 = { f="FLOOR0_3", t="GRAY1" }
  FLOOR0_5 = { f="FLOOR0_5", t="GRAY1" }
  FLOOR0_6 = { f="FLOOR0_6", t="GRAY1" }
  FLOOR0_7 = { f="FLOOR0_7", t="GRAY1" }
  FLOOR1_1 = { f="FLOOR1_1", t="COMPBLUE" }
  FLOOR1_6 = { f="FLOOR1_6", t="REDWALL" }
  FLOOR1_7 = { f="FLOOR1_7", t="REDWALL" }
  FLOOR3_3 = { f="FLOOR3_3", t="BROWN1" }

  FLOOR4_1 = { f="FLOOR4_1", t="STARTAN2" }
  FLOOR4_5 = { f="FLOOR4_5", t="STARTAN2" }
  FLOOR4_6 = { f="FLOOR4_6", t="STARTAN2" }
  FLOOR4_8 = { f="FLOOR4_8", t="METAL1" }
  FLOOR5_1 = { f="FLOOR5_1", t="METAL1" }
  FLOOR5_2 = { f="FLOOR5_2", t="BROWNHUG" }
  FLOOR5_3 = { f="FLOOR5_3", t="BROWNHUG" }
  FLOOR5_4 = { f="FLOOR5_4", t="BROWNHUG" }
  FLOOR6_1 = { f="FLOOR6_1", t="REDWALL" }
  FLOOR7_1 = { f="FLOOR7_1", t="BROWNHUG" }
  FLOOR7_2 = { f="FLOOR7_2", t="MARBLE1" }

  GATE1    = { f="GATE1", t="METAL" }
  GATE2    = { f="GATE2", t="METAL" }
  GATE3    = { f="GATE3", t="METAL" }
  GATE4    = { f="GATE4", t="METAL" }
  
  MFLR8_1  = { f="MFLR8_1", t="STONE2" }
  MFLR8_2  = { f="MFLR8_2", t="BROWNHUG" }
  MFLR8_3  = { f="MFLR8_3", t="SP_ROCK1" }

  SFLR6_1  = { f="SFLR6_1", t="SKSNAKE1" }
  SFLR6_4  = { f="SFLR6_4", t="SKSNAKE2" }
  SFLR7_1  = { f="SFLR7_1", t="SKSNAKE1" }
  SFLR7_4  = { f="SFLR7_4", t="SKSNAKE1" }
  
  STEP_F1  = { f="STEP1", t="SHAWN2" }
  STEP_F2  = { f="STEP2", t="SHAWN2" }

  TLITE6_1 = { f="TLITE6_1", t="METAL" }
  TLITE6_4 = { f="TLITE6_4", t="METAL" }
  TLITE6_5 = { f="TLITE6_5", t="METAL" }
  TLITE6_6 = { f="TLITE6_6", t="METAL" }


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


DOOM2.MATERIALS =
{
  -- walls --

  ASHWALL  = { t="ASHWALL2", f="MFLR8_4" }  -- compatibility name
  ASHWALL3 = { t="ASHWALL3", f="FLAT10" }
  ASHWALL4 = { t="ASHWALL4", f="FLAT10" }
  ASHWALL6 = { t="ASHWALL6", f="RROCK20" }
  ASHWALL7 = { t="ASHWALL7", f="RROCK18" }
  BIGBRIK1 = { t="BIGBRIK1", f="RROCK14" }
  BIGBRIK2 = { t="BIGBRIK2", f="MFLR8_1" }
  BIGBRIK3 = { t="BIGBRIK3", f="RROCK14" }
  BLAKWAL1 = { t="BLAKWAL1", f="CEIL5_1" }
  BLAKWAL2 = { t="BLAKWAL2", f="CEIL5_1" }

  BRICK1   = { t="BRICK1",   f="RROCK10" }
  BRICK2   = { t="BRICK2",   f="RROCK10" }
  BRICK3   = { t="BRICK3",   f="FLAT5_5" }
  BRICK4   = { t="BRICK4",   f="FLAT5_5" }
  BRICK5   = { t="BRICK5",   f="RROCK10" }
  BRICK6   = { t="BRICK6",   f="FLOOR5_4" }
  BRICK7   = { t="BRICK7",   f="FLOOR5_4" }
  BRICK8   = { t="BRICK8",   f="FLOOR5_4" }
  BRICK9   = { t="BRICK9",   f="FLOOR5_4" }
  BRICK10  = { t="BRICK10",  f="SLIME13" }
  BRICK11  = { t="BRICK11",  f="FLAT5_3" }
  BRICK12  = { t="BRICK12",  f="FLOOR0_1" }
  BRICKLIT = { t="BRICKLIT", f="RROCK10" }

  BRONZE1  = { t="BRONZE1",  f="FLOOR7_1" }
  BRONZE2  = { t="BRONZE2",  f="FLOOR7_1" }
  BRONZE3  = { t="BRONZE3",  f="FLOOR7_1" }
  BRONZE4  = { t="BRONZE4",  f="FLOOR7_1" }
  BRWINDOW = { t="BRWINDOW", f="RROCK10" }
  BSTONE1  = { t="BSTONE1",  f="RROCK11" }
  BSTONE2  = { t="BSTONE2",  f="RROCK12" }
  BSTONE3  = { t="BSTONE3",  f="RROCK12" }

  CEMENT7  = { t="CEMENT7",  f="FLAT19" }
  CEMENT9  = { t="CEMENT9",  f="FLAT19" }
  CRACKLE2 = { t="CRACKLE2", f="RROCK01" }
  CRACKLE4 = { t="CRACKLE4", f="RROCK02" }
  CRATE3   = { t="CRATE3",   f="CRATOP1" }
  MARBFAC4 = { t="MARBFAC4", f="DEM1_5" }
  MARBGRAY = { t="MARBGRAY", f="DEM1_5" }

  METAL2   = { t="METAL2",   f="CEIL5_2" }
  METAL3   = { t="METAL3",   f="CEIL5_2" }
  METAL4   = { t="METAL4",   f="CEIL5_2" }
  METAL5   = { t="METAL5",   f="CEIL5_2" }
  METAL6   = { t="METAL6",   f="CEIL5_2" }
  METAL7   = { t="METAL7",   f="CEIL5_2" }

  MODWALL1 = { t="MODWALL1", f="MFLR8_4" }
  MODWALL2 = { t="MODWALL2", f="MFLR8_4" }
  MODWALL3 = { t="MODWALL3", f="FLAT19" }
  MODWALL4 = { t="MODWALL4", f="FLAT18" }

  PANBLACK = { t="PANBLACK", f="RROCK09" }
  PANBLUE  = { t="PANBLUE",  f="RROCK09" }
  PANBOOK  = { t="PANBOOK",  f="RROCK09" }
  PANRED   = { t="PANRED",   f="RROCK09" }
  PANBORD1 = { t="PANBORD1", f="RROCK09" }
  PANBORD2 = { t="PANBORD2", f="RROCK09" }
  PANCASE1 = { t="PANCASE1", f="RROCK09" }
  PANCASE2 = { t="PANCASE2", f="RROCK09" }

  PANEL1   = { t="PANEL1",   f="RROCK09" }
  PANEL2   = { t="PANEL2",   f="RROCK09" }
  PANEL3   = { t="PANEL3",   f="RROCK09" }
  PANEL4   = { t="PANEL4",   f="RROCK09" }
  PANEL5   = { t="PANEL5",   f="RROCK09" }
  PANEL6   = { t="PANEL6",   f="RROCK09" }
  PANEL7   = { t="PANEL7",   f="RROCK09" }
  PANEL8   = { t="PANEL8",   f="RROCK09" }
  PANEL9   = { t="PANEL9",   f="RROCK09" }

  PIPES    = { t="PIPES",    f="FLOOR3_3" }
  PIPEWAL1 = { t="PIPEWAL1", f="RROCK03" }
  PIPEWAL2 = { t="PIPEWAL2", f="RROCK03" }
  ROCK1    = { t="ROCK1",    f="RROCK13" }
  ROCK2    = { t="ROCK2",    f="GRNROCK" }
  ROCK3    = { t="ROCK3",    f="RROCK13" }
  ROCK4    = { t="ROCK4",    f="FLOOR0_2" }
  ROCK5    = { t="ROCK5",    f="RROCK09" }

  SILVER1  = { t="SILVER1",  f="FLAT23" }
  SILVER2  = { t="SILVER2",  f="FLAT22" }
  SILVER3  = { t="SILVER3",  f="FLAT23" }
  SK_LEFT  = { t="SK_LEFT",  f="FLAT5_6" }
  SK_RIGHT = { t="SK_RIGHT", f="FLAT5_6" }
  SLOPPY1  = { t="SLOPPY1",  f="FLAT5_6" }
  SLOPPY2  = { t="SLOPPY2",  f="FLAT5_6" }
  SP_DUDE7 = { t="SP_DUDE7", f="FLOOR5_4" }
  SP_FACE2 = { t="SP_FACE2", f="FLAT5_6" }

  SPACEW2  = { t="SPACEW2",  f="CEIL3_3" }
  SPACEW3  = { t="SPACEW3",  f="CEIL5_1" }
  SPACEW4  = { t="SPACEW4",  f="SLIME16" }

  SPCDOOR1 = { t="SPCDOOR1", f="FLOOR0_1" }
  SPCDOOR2 = { t="SPCDOOR2", f="FLAT19" }
  SPCDOOR3 = { t="SPCDOOR3", f="FLAT19" }
  SPCDOOR4 = { t="SPCDOOR4", f="FLOOR0_1" }

  STONE4   = { t="STONE4",   f="FLAT5_4" }
  STONE5   = { t="STONE5",   f="FLAT5_4" }
  STONE6   = { t="STONE6",   f="RROCK11" }
  STONE7   = { t="STONE7",   f="RROCK11" }
  STUCCO   = { t="STUCCO",   f="FLAT5_5" }
  STUCCO1  = { t="STUCCO1",  f="FLAT5_5" }
  STUCCO2  = { t="STUCCO2",  f="FLAT5_5" }
  STUCCO3  = { t="STUCCO3",  f="FLAT5_5" }

  TANROCK2 = { t="TANROCK2", f="FLOOR3_3" }
  TANROCK3 = { t="TANROCK3", f="RROCK11" }
  TANROCK4 = { t="TANROCK4", f="RROCK09" }
  TANROCK5 = { t="TANROCK5", f="RROCK18" }
  TANROCK7 = { t="TANROCK7", f="RROCK15" }
  TANROCK8 = { t="TANROCK8", f="RROCK09" }

  TEKBRON1 = { t="TEKBRON1", f="FLOOR0_1" }
  TEKBRON2 = { t="TEKBRON2", f="FLOOR0_1" }
  TEKGREN1 = { t="TEKGREN1", f="RROCK20" }
  TEKGREN2 = { t="TEKGREN2", f="RROCK20" }
  TEKGREN3 = { t="TEKGREN3", f="RROCK20" }
  TEKGREN4 = { t="TEKGREN4", f="RROCK20" }
  TEKGREN5 = { t="TEKGREN5", f="RROCK20" }
  TEKLITE  = { t="TEKLITE",  f="FLOOR5_2" }
  TEKLITE2 = { t="TEKLITE2", f="FLOOR5_2" }
  TEKWALL6 = { t="TEKWALL6", f="CEIL5_1" }

  WOOD6    = { t="WOOD6",    f="FLAT5_2" }
  WOOD7    = { t="WOOD7",    f="FLAT5_2" }
  WOOD8    = { t="WOOD8",    f="FLAT5_2" }
  WOOD9    = { t="WOOD9",    f="FLAT5_2" }
  WOOD10   = { t="WOOD10",   f="FLAT5_1" }
  WOOD12   = { t="WOOD12",   f="FLAT5_2" }
  WOODVERT = { t="WOODVERT", f="FLAT5_2" }
  WOODMET1 = { t="WOODMET1", f="CEIL5_2" }
  WOODMET2 = { t="WOODMET2", f="CEIL5_2" }
  WOODMET3 = { t="WOODMET3", f="CEIL5_2" }
  WOODMET4 = { t="WOODMET4", f="CEIL5_2" }

  ZIMMER1  = { t="ZIMMER1",  f="RROCK20" }
  ZIMMER2  = { t="ZIMMER2",  f="RROCK20" }
  ZIMMER3  = { t="ZIMMER3",  f="RROCK18" }
  ZIMMER4  = { t="ZIMMER4",  f="RROCK18" }
  ZIMMER5  = { t="ZIMMER5",  f="RROCK16" }
  ZIMMER7  = { t="ZIMMER7",  f="RROCK20" }
  ZIMMER8  = { t="ZIMMER8",  f="MFLR8_3" }
                          
  ZDOORB1  = { t="ZDOORB1",  f="FLAT23" }
  ZDOORF1  = { t="ZDOORF1",  f="FLAT23" }
  ZELDOOR  = { t="ZELDOOR",  f="FLAT23" }

  ZZWOLF1  = { t="ZZWOLF1",  f="FLAT18" }
  ZZWOLF2  = { t="ZZWOLF2",  f="FLAT18" }
  ZZWOLF3  = { t="ZZWOLF3",  f="FLAT18" }
  ZZWOLF4  = { t="ZZWOLF4",  f="FLAT18" }
  ZZWOLF5  = { t="ZZWOLF5",  f="FLAT5_1" }
  ZZWOLF6  = { t="ZZWOLF6",  f="FLAT5_1" }
  ZZWOLF7  = { t="ZZWOLF7",  f="FLAT5_1" }
  ZZWOLF9  = { t="ZZWOLF9",  f="FLAT14" }
  ZZWOLF10 = { t="ZZWOLF10", f="FLAT23" }
  ZZWOLF11 = { t="ZZWOLF11", f="FLAT5_3" }
  ZZWOLF12 = { t="ZZWOLF12", f="FLAT5_3" }
  ZZWOLF13 = { t="ZZWOLF13", f="FLAT5_3" }


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

  CONS1_1  = { f="CONS1_1", t="GRAY5" }
  CONS1_5  = { f="CONS1_5", t="GRAY5" }
  CONS1_7  = { f="CONS1_7", t="GRAY5" }

  FLAT1_1  = { f="FLAT1_1",  t="BSTONE2" }
  FLAT1_2  = { f="FLAT1_2",  t="BSTONE2" }
  FLAT1_3  = { f="FLAT1_3",  t="BSTONE2" }
  FLAT10   = { f="FLAT10",   t="ASHWALL4" }
  FLAT22   = { f="FLAT22",   t="SILVER2" }
  FLAT5_5  = { f="FLAT5_5",  t="STUCCO" }
  FLAT5_7  = { f="FLAT5_7",  t="ASHWALL2" }
  FLAT5_8  = { f="FLAT5_8",  t="ASHWALL2" }
  FLOOR6_2 = { f="FLOOR6_2", t="ASHWALL2" }

  GRASS1   = { f="GRASS1",   t="ZIMMER2" }
  GRASS2   = { f="GRASS2",   t="ZIMMER2" }
  GRNROCK  = { f="GRNROCK",  t="ROCK2" }
  GRNLITE1 = { f="GRNLITE1", t="TEKGREN2" }
  MFLR8_4  = { f="MFLR8_4",  t="ASHWALL2" }

  RROCK01  = { f="RROCK01", t="CRACKLE2" }
  RROCK02  = { f="RROCK02", t="CRACKLE4" }
  RROCK03  = { f="RROCK03", t="ASHWALL3" }
  RROCK04  = { f="RROCK04", t="ASHWALL3" }
  RROCK05  = { f="RROCK05", t="ROCKRED1" }  -- animated
  RROCK09  = { f="RROCK09", t="TANROCK4" }
  RROCK10  = { f="RROCK10", t="BRICK1" }
  RROCK11  = { f="RROCK11", t="BSTONE1" }
  RROCK12  = { f="RROCK12", t="BSTONE2" }

  RROCK13  = { f="RROCK13", t="ROCK3" }
  RROCK14  = { f="RROCK14", t="BIGBRIK1" }
  RROCK15  = { f="RROCK15", t="TANROCK7" }
  RROCK16  = { f="RROCK16", t="ZIMMER5" }
  RROCK17  = { f="RROCK17", t="ZIMMER3" }
  RROCK18  = { f="RROCK18", t="ZIMMER3" }
  RROCK19  = { f="RROCK19", t="ZIMMER2" }
  RROCK20  = { f="RROCK20", t="ZIMMER7" }

  SLIME09  = { f="SLIME09", t="ROCKRED1" } -- animated
  SLIME13  = { f="SLIME13", t="BRICK10" }
  SLIME14  = { f="SLIME14", t="METAL2" }
  SLIME15  = { f="SLIME15", t="COMPSPAN" }
  SLIME16  = { f="SLIME16", t="SPACEW4" }


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
  water  = { mat="FWATER1", light=0.65, special=0 }
  blood  = { mat="BLOOD1",  light=0.65, special=0 }
  nukage = { mat="NUKAGE1", light=0.65, special=16, damage=20 }
  lava   = { mat="LAVA1",   light=0.75, special=16, damage=20 }

  -- Doom II only --
  slime  = { mat="SLIME01", light=0.65, special=16, damage=20 }
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


DOOM.CRATES =  -- Note: UNUSED STUFF
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


DOOM.EXITS =  -- Note: UNUSED STUFF
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
    _file   = "start/basic.wad"
    _where  = "middle"

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
    _file   = "start/closet1.wad"
    _where  = "closet"
    _fitted = "xy"

--[[
    step = "FLAT1"

    door = "BIGDOOR1"
    track = "DOORTRAK"

    support = "SUPPORT2"
    support_ox = 24

    special = 31  -- open and stay open
    tag = 0

    item1 = "bullet_box"
    item2 = "stimpack"
--]]
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

  Exit_pillar =
  {
    _file  = "exit/pillar1.wad",
    _where = "middle"
  }

  Exit_Pillar_tech =
  {
    _prefab = "EXIT_PILLAR",
    _where  = "middle"

    switch = "SW1COMP"
    exit = "EXITSIGN"
    exitside = "COMPSPAN"
    use_sign = 1
    special = 11
    tag = 0
  }

  Exit_Pillar_gothic =
  {
    _prefab = "EXIT_PILLAR",
    _where  = "middle"

    switch = { SW1LION=60, SW1GARG=30 }
    exit = "EXITSIGN"
    exitside = "COMPSPAN"
    use_sign = 1
    special = 11
    tag = 0
  }

  Exit_Pillar_urban =
  {
    _prefab = "EXIT_PILLAR",
    _where  = "middle"

    switch = "SW1WDMET"
    exit = "EXITSIGN"
    exitside = "COMPSPAN"
    use_sign = 1
    special = 11
    tag = 0
  }

  Exit_Closet_tech =
  {
    _file   = "exit/closet1.wad"
    _where  = "closet"
    _fitted = "xy"

--[[ FIXME
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

    use_sign = 1
    exit = "EXITSIGN"
    exitside = "COMPSPAN"

    switch  = "SW1COMM"
    sw_side = "SHAWN2"

    special = 11
    tag = 0

    item1 = { stimpack=50, medikit=20, soul=1, none=30 }
    item2 = { shells=50, bullets=40, rocket=30, potion=20 }
--]]
  }

  Exit_Closet_hell =
  {
    _file   = "exit/closet1.wad"
    _where  = "closet"
    _fitted = "xy"

--[[ FIXME
    door  = "EXITDOOR"
    track = "DOORTRAK"
    key   = "SUPPORT3"
    key_ox = 24

    inner = { MARBGRAY=40, SP_HOT1=20, REDWALL=10,
              SKINMET1=10, SLOPPY2=10 }

    ceil = { FLAT5_6=20, LAVA1=5, FLAT10=10, FLOOR6_1=10 }

    floor2  = { SLIME09=10, FLOOR7_2=20, FLAT5_2=10, FLAT5_8=10 }

    use_sign = 1
    exit = "EXITSIGN"
    exitside = "COMPSPAN"

    switch  = { SW1LION=10, SW1SATYR=30, SW1GARG=20 }
    sw_side = "METAL"
    sw_oy   = 56

    special = 11
    tag = 0

    item1 = { stimpack=50, medikit=20, soul=1, none=30 }
    item2 = { shells=50, bullets=40, rocket=30, potion=20 }
--]]
  }

  Exit_Closet_urban =
  {
    _prefab = "EXIT_CLOSET"
    _where  = "closet"
    _fitted = "xy"

--[[ FIXME
    door  = "EXITDOOR"
    track = "DOORTRAK"
    key   = "SUPPORT3"
    key_ox = 24

    inner = { BIGBRIK3=20, WOOD9=10, STONE=10, WOODMET1=35,
              CEMENT9=5, PANEL6=20 }
    
    ceil = { RROCK04=20, RROCK13=20, RROCK03=10, 
             FLAT10=20, FLOOR6_2=10, FLAT4=20 }

    floor2  = { FLAT5_2=30, CEIL5_1=15, CEIL4_2=15,
                MFLR8_1=15, RROCK18=25, RROCK12=20 }

    use_sign = 1
    exit = "EXITSIGN"
    exitside = "COMPSPAN"

    switch  = { SW1BRNGN=30, SW1ROCK=10, SW1SLAD=20, SW1TEK=20 }
    sw_side = "BROWNGRN"
    sw_oy   = 60

    special = 11
    tag = 0

    item1 = { stimpack=50, medikit=20, soul=1, none=30 }
    item2 = { shells=50, bullets=40, rocket=30, potion=20 }
--]]
  }


  ----| STAIRS |----

  Stair_Up1 =
  {
    _prefab = "STAIR_6"
    _where  = "floor"
    _deltas = { 32,48,48,64,64,80 }
  }

  Stair_Up2 =
  {
    _prefab = "STAIR_W_SIDES"
    _where  = "floor"

    metal = "METAL"
    step  = "STEP1"
    top   = "FLOOR0_1"
  }

  Stair_Up3 =
  {
    _prefab = "STAIR_TRIANGLE"
    _where  = "floor"

    step = "STEP1"
    top = "FLOOR0_1"
  }

  Stair_Up4 =
  {
    _prefab = "STAIR_CIRCLE"
    _where  = "floor"

    step = "STEP5"
    top  = "FLOOR0_2"
  }

  Stair_Down1 =
  {
    _prefab = "NICHE_STAIR_8"
    _where  = "floor"
    _deltas = { -32,-48,-64,-64,-80,-96 }
  }


  Lift_Up1 =  -- Rusty
  {
    _prefab = "LIFT_UP"
    _where  = "floor"
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
    _where  = "floor"
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


  ----| ITEM / KEY |----

  Item_niche =
  {
    _prefab = "ITEM_NICHE"
    _where  = "edge"
    _long   = 192
    _deep   = 64
  }

  Pedestal_1 =
  {
    _file  = "pedestal/ped.wad"
    _where = "middle"

    top  = "CEIL1_2"
    side = "METAL"
  }

  Item_Closet =
  {
    _prefab = "ITEM_CLOSET"
    _where  = "closet"
    _long   = { 192,384 }
    _deep   = { 192,384 }

    item = "soul"
  }

  Secret_Closet =
  {
    _prefab = "SECRET_NICHE_1"
    _where  = "closet"
    _tags   = 1
    _long   = { 192,384 }
    _deep   = { 192,384 }

    item = { backpack=50, blue_armor=50, soul=30, berserk=30,
             invul=10, invis=10, map=10, goggles=5 }

    special = 103  -- open and stay open
  }


  ----| ARCHES |----

  Arch1 =
  {
    _prefab = "ARCH"
    _where  = "edge"
    _long   = 192
    _deep   = 64
  }

  MiniHall_Arch1 =
  {
    _prefab = "FAT_ARCH1"
    _shape  = "I"
    _delta  = 0

    pic = "SW1SATYR"    
  }


  ----| DOORS |----

  Door_silver =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _long   = 192
    _deep   = 48

    door_w = 128
    door_h = 72

    door  = "BIGDOOR1"
    track = "DOORTRAK"
    key   = "LITE3"
    step  = "STEP4"

    x_offset = 0
    y_offset = 0
    special = 1
    tag = 0
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
    _file   = "door/key_door.wad"
    _where  = "edge"
    _fitted = "xy"
    _key    = "kc_blue"
    _long   = 192
    _deep   = 48

    tex_DOORRED = "DOORBLU";
    line_33 = 32

    door_w = 128
    door_h = 112

    key = "DOORBLU"
    door = "BIGDOOR3"
    door_c = "FLOOR7_2"
    step = "STEP4"
    track = "DOORTRAK"

    special = 32
    tag = 0  -- kind_mult=26
  }

  Locked_kc_yellow =
  {
    _file   = "door/key_door.wad"
    _where  = "edge"
    _fitted = "xy"
    _key    = "kc_yellow"
    _long   = 192
    _deep   = 48

    tex_DOORRED = "DOORYEL";
    line_33 = 34

    door_w = 128
    door_h = 112

    key = "DOORYEL"
    door = "BIGDOOR4"
    door_c = "FLOOR3_3"
    step = "STEP4"
    track = "DOORTRAK"

    special = 34
    tag = 0  -- kind_mult=27
  }

  Locked_kc_red =
  {
    _file   = "door/key_door.wad"
    _where  = "edge"
    _fitted = "xy"
    _key    = "kc_red"
    _long   = 192
    _deep   = 48

    door_w = 128
    door_h = 112

    key = "DOORRED"
    door = "BIGDOOR2"
    door_c = "FLAT1"
    step = "STEP4"
    track = "DOORTRAK"

    special = 33
    tag = 0  -- kind_mult=28
  }


  Locked_ks_blue =
  {
    _file   = "door/key_door.wad"
    _where  = "edge"
    _fitted = "xy"
    _key    = "ks_blue"
    _long   = 192
    _deep   = 48

    tex_DOORRED = "DOORBLU2";
    line_33 = 32

    door_w = 128
    door_h = 112

    key = "DOORBLU2"
    key_ox = 4
    key_oy = -10
    door = "BIGDOOR7"
    door_c = "FLOOR7_2"
    step = "STEP4"
    track = "DOORTRAK"

    special = 32
    tag = 0  -- kind_mult=26
  }

  Locked_ks_yellow =
  {
    _file   = "door/key_door.wad"
    _where  = "edge"
    _fitted = "xy"
    _key    = "ks_yellow"
    _long   = 192
    _deep   = 48

    tex_DOORRED = "DOORYEL2";
    line_33 = 34

    door_w = 128
    door_h = 112

    key = "DOORYEL2"
    key_ox = 4
    key_oy = -10
    door = "BIGDOOR7"
    door_c = "FLOOR3_3"
    step = "STEP4"
    track = "DOORTRAK"

    special = 34
    tag = 0  -- kind_mult=27
  }

  Locked_ks_red =
  {
    _file   = "door/key_door.wad"
    _where  = "edge"
    _fitted = "xy"
    _key    = "ks_red"
    _long   = 192
    _deep   = 48

    tex_DOORRED = "DOORRED2";

    door_w = 128
    door_h = 112

    key = "DOORRED2"
    key_ox = 4
    key_oy = -10
    door = "BIGDOOR7"
    door_c = "FLAT1"
    step = "STEP4"
    track = "DOORTRAK"

    special = 33
    tag = 0  -- kind_mult=28
  }

  -- narrow versions of above doors

  Locked_kc_blue_NAR =
  {
    _copy = "Locked_kc_blue"
    _narrow = 1

    door_w = 64
    door_h = 72
    door   = "DOOR3"
    door_c = "FLAT1"
  }

  Locked_kc_yellow_NAR =
  {
    _copy = "Locked_kc_yellow"
    _narrow = 1

    door_w = 64
    door_h = 72
    door   = "DOOR3"
    door_c = "FLAT1"
  }

  Locked_kc_red_NAR =
  {
    _copy = "Locked_kc_red"
    _narrow = 1

    door_w = 64
    door_h = 72
    door   = "DOOR3"
    door_c = "FLAT1"
  }

  Locked_ks_blue_NAR =
  {
    _copy = "Locked_ks_blue"
    _narrow = 1

    door_w = 64
    door_h = 72
    door   = "DOOR3"
    door_c = "FLAT1"
  }

  Locked_ks_yellow_NAR =
  {
    _copy = "Locked_ks_yellow"
    _narrow = 1

    door_w = 64
    door_h = 72
    door   = "DOOR3"
    door_c = "FLAT1"
  }

  Locked_ks_red_NAR =
  {
    _copy = "Locked_ks_red"
    _narrow = 1

    door_w = 64
    door_h = 72
    door   = "DOOR3"
    door_c = "FLAT1"
  }


  MiniHall_Door_tech =
  {
    _prefab = "MINI_DOOR1"
    _shape  = "I"
    _delta  = 0
    _door   = 1

    door   = { BIGDOOR3=50, BIGDOOR4=40, BIGDOOR2=15 }
    track  = "DOORTRAK"
    step   = "STEP4"
    metal  = "DOORSTOP"
    lite   = "LITE5"
    c_lite = "TLITE6_1"
  }

  MiniHall_Door_hell =
  {
    _prefab = "MINI_DOOR1"
    _shape  = "I"
    _delta  = 0
    _door   = 1

    door   = { BIGDOOR6=50 }
    track  = "DOORTRAK"
    step   = "STEP4"
    metal  = "METAL"
    lite   = "FIREWALL"
  }


  ---| SWITCHED DOORS |---

  Door_SW_blue =
  {
    _file   = "door/sw_door1.wad"
    _where  = "edge"
    _fitted = "xy"
    _switch = "sw_blue"
    _long = 192
    _deep = 48

    door_w = 128
    door_h = 112

    key = "COMPBLUE"
    door = "BIGDOOR3"
    door_c = "FLOOR7_2"
    step = "COMPBLUE"
    track = "DOORTRAK"
    frame = "FLAT14"
    door_h = 112
    special = 0
  }

  Door_SW_blue_NAR =
  {
    _copy = "Door_SW_blue"
    _narrow = 1

    door_w = 64
    door_h = 72
    door   = "DOOR1"
    door_c = "FLAT23"
  }

  Switch_blue1 =
  {
    _file   = "switch/small2.wad"
    _where  = "middle"
    _switch = "sw_blue"

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
    _deep = 48

    door_w = 128
    door_h = 112

    key = "REDWALL"
    door = "BIGDOOR2"
    door_c = "FLAT1"
    step = "REDWALL"
    track = "DOORTRAK"
    frame = "FLAT5_3"
    door_h = 112
    special = 0
  }

  Door_SW_red_NAR =
  {
    _copy = "Door_SW_red"
    _narrow = 1

    door_w = 64
    door_h = 72
    door   = "DOOR1"
    door_c = "FLAT23"
  }

  Switch_red1 =
  {
    _prefab = "SMALL_SWITCH"
    _where  = "middle"
    _switch = "sw_red"

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
    _deep   = 48

    door_w = 128
    door_h = 112

    key = "SKINFACE"
    door = "BIGDOOR4"
    door_c = "FLOOR7_2"
    step = "SKINFACE"
    track = "DOORTRAK"
    frame = "SKINFACE"
    door_h = 112
    special = 0
  }

  Door_SW_pink_NAR =
  {
    _copy = "Door_SW_pink"
    _narrow = 1

    door_w = 64
    door_h = 72
    door   = "DOOR1"
    door_c = "FLAT23"
  }

  Switch_pink1 =
  {
    _prefab = "SMALL_SWITCH"
    _where  = "middle"
    _switch = "sw_pink"

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
    _deep   = 48

    door_w = 128
    door_h = 112

    key = "GRAYVINE"
    door = "BIGDOOR4"
    door_c = "FLOOR7_2"
    step = "GRAYVINE"
    track = "DOORTRAK"
    frame = "FLAT1"
    door_h = 112
    special = 0
  }

  Door_SW_vine_NAR =
  {
    _copy = "Door_SW_vine"
    _narrow = 1

    door_w = 64
    door_h = 72
    door   = "DOOR1"
    door_c = "FLAT23"
  }

  Switch_vine1 =
  {
    _prefab = "SMALL_SWITCH"
    _where  = "middle"
    _switch = "sw_vine"

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
    _file   = "hall/trim1_i.wad"
    _shape  = "I"
    _fitted = "xy"
  }

  Hall_Basic_C =
  {
    _file   = "hall/trim1_c.wad"
    _shape  = "C"
    _fitted = "xy"
  }

  Hall_Basic_T =
  {
    _file   = "hall/trim1_t.wad"
    _shape  = "T"
    _fitted = "xy"
  }

  Hall_Basic_P =
  {
    _file   = "hall/trim1_p.wad"
    _shape  = "P"
    _fitted = "xy"
  }

  Hall_Basic_I_Stair =
  {
    _file   = "hall/trim1_st.wad"
    _shape  = "IS"
    _fitted = "xy"

    step = "STEP3"
    support = "SUPPORT2"
    support_ox = 24
  }

  Hall_Basic_I_Lift =
  {
    _file   = "hall/trim1_lf.wad"
    _shape  = "IL"
    _fitted = "xy"
    _z_ranges = { {64,0}, {64,0,"?stair_h-64"}, {128,0} }
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

    lamp_ent = "lamp"
  }

  -- TODO: Hall_Thin_P

  Hall_Thin_I_Bend =
  {
    _prefab = "HALL_THIN_I_BEND"
    _shape  = "I"
  }

  Hall_Thin_I_Bulge =
  {
    _prefab = "HALL_THIN_I_BULGE"
    _shape  = "I"
    _long   = 192
    _deep   = { 192,384 }
    _in_between = 1

    lamp = "TLITE6_1"
  }

  Hall_Thin_P_Oh =
  {
    _prefab = "HALL_THIN_OH"
    _shape  = "P"
    _long   = 384
    _deep   = 384
    _in_between = 1

    pillar = { WOODMET1=70, TEKLITE=20, SLADWALL=20 }
    niche  = "DOORSTOP"

    torch_ent = { red_torch_sm=50, green_torch_sm=10 }

    effect = 17
  }

  Hall_Thin_I_Oh =
  {
    _copy  = "Hall_Thin_P_Oh"
    _shape = "I"

    east_h = 128
    west_h = 128
  }

  Hall_Thin_C_Oh =
  {
    _copy  = "Hall_Thin_P_Oh"
    _shape = "C"

    east_h  = 128
    north_h = 128
  }

  Hall_Thin_T_Oh =
  {
    _copy  = "Hall_Thin_P_Oh"
    _shape = "T"

    north_h = 128
  }

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


  Sky_Hall_I =
  {
    _prefab = "SKY_HALL_I"
    _shape  = "I"
    _need_sky = 1
  }

  Sky_Hall_C =
  {
    _prefab = "SKY_HALL_C"
    _shape  = "C"
    _need_sky = 1

    support = "SUPPORT3"
    torch_ent = "green_torch_sm"
  }

  Sky_Hall_I_Stair =
  {
    _prefab = "SKY_HALL_I_STAIR"
    _shape  = "IS"
    _need_sky = 1

    step = "STEP5"
  }


  Secret_Mini =
  {
    _prefab = "SECRET_MINI"
    _shape  = "I"
    _tags   = 1

    pic   = "O_NEON"
    inner = "COMPSPAN"
    metal = "METAL"
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


  Junc_Nuke_Islands =
  {
    _prefab = "JUNCTION_NUKEY_C"
    _shape  = "C"
    _liquid = 1
    _long   = { 576,576 }
    _deep   = { 576,576 }

    island = { FLOOR3_3=50, FLOOR0_3=50, MFLR8_2=10 }
    ceil   = { CEIL5_1=30, FLAT10=10, CEIL3_5=40, CEIL4_2=30 }

    support = "SUPPORT3"
    support_ox = 24

    lamp = { TLITE6_5=50, TLITE6_6=10, TLITE6_1=10, FLOOR1_7=5 }
  }


  Junc_Circle_gothic_P =
  {
    _file   = "junction/circle_p.wad"
    _fitted = "xy"
    _shape  = "P"

    floor  = "CEIL3_5"
    circle = "CEIL3_3"
    step   = "STEP6"

    plinth = "MARBGRAY"
    plinth_top = "FLOOR7_2"
    plinth_ent = "evil_eye"

    billboard = "SW2SATYR"
    bill_side = "METAL"
    bill_oy   = 52

    torch_ent = "red_torch"
  }

  Junc_Circle_gothic_I =
  {
    _copy  = "Junc_Circle_gothic_P"
    _shape = "I"

    east_h = 0
    west_h = 0
  }

  Junc_Circle_gothic_C =
  {
    _copy  = "Junc_Circle_gothic_P"
    _shape = "C"

    east_h = 0
    north_h = 0
  }

  Junc_Circle_gothic_T =
  {
    _copy  = "Junc_Circle_gothic_P"
    _shape = "T"

    north_h = 0
  }


  Junc_Circle_tech_P =
  {
    _prefab = "JUNCTION_CIRCLE"
    _shape  = "P"

    floor  = "CEIL3_5"
    circle = "CEIL3_3"
    step   = "STEP6"

    plinth = "TEKWALL4"
    plinth_top = "CEIL5_2"
    plinth_ent = "evil_eye"

    billboard = { COMPSTA2=50, COMPSTA1=10 }
    bill_side = "FLAT23"
    bill_oy   = 0

    torch_ent = "mercury_lamp"
  }

  Junc_Circle_tech_I =
  {
    _copy  = "Junc_Circle_tech_P"
    _shape = "I"

    east_h = 0
    west_h = 0
  }

  Junc_Circle_tech_C =
  {
    _copy  = "Junc_Circle_tech_P"
    _shape = "C"

    east_h = 0
    north_h = 0
  }

  Junc_Circle_tech_T =
  {
    _copy  = "Junc_Circle_tech_P"
    _shape = "T"

    north_h = 0
  }


  Junc_Spokey_P =
  {
    _prefab = "JUNCTION_SPOKEY"
    _shape  = "P"

    metal = "METAL"
    floor = "FLOOR0_3"
  }

  Junc_Spokey_I =
  {
    _copy  = "Junc_Spokey_P"
    _shape = "I"

    east_h = 0
    west_h = 0
  }

  Junc_Spokey_C =
  {
    _copy  = "Junc_Spokey_P"
    _shape = "C"

    east_h = 0
    north_h = 0
  }

  Junc_Spokey_T =
  {
    _copy  = "Junc_Spokey_P"
    _shape = "T"

    north_h = 0
  }


  Junc_Nuke_Pipes_P =
  {
    _prefab = "JUNCTION_NUKE_PIPES"
    _shape  = "P"

    main_wall = "BLAKWAL1"
    high_ceil = "CEIL4_1"
    low_ceil = "COMPSPAN"
    low_floor = "FLOOR7_1"  -- CEIL5_1

    trim = "METAL"
    lite = "LITE3"
    pipe = "METAL4"
  }

  Junc_Nuke_Pipes_I =
  {
    _copy  = "Junc_Nuke_Pipes_P"
    _shape = "I"

    east_h = -24
    west_h = -24
  }

  Junc_Nuke_Pipes_C =
  {
    _copy  = "Junc_Nuke_Pipes_P"
    _shape = "C"

    east_h  = -24
    north_h = -24
  }

  Junc_Nuke_Pipes_T =
  {
    _copy  = "Junc_Nuke_Pipes_P"
    _shape = "T"

    north_h = -24
  }


  Junc_Ledge_T =
  {
    _prefab = "JUNCTION_LEDGE_1"
    _shape  = "T"
    _heights = { 0,64,64,64 }
    _floors  = { "floor1", "floor2", "floor2", "floor2" }

    floor1 = "FLOOR0_1"
    ceil1  = "CEIL3_5"

    floor2 = "FLAT4"
    -- ceil2  = "FLAT5_3"
    low_trim = "GRAY7"
    high_trim = "GRAY7"

    support = "METAL2"
    step = "STEP1"
    top = "CEIL5_1"

    lamp_ent = "lamp"
  }

  Junc_Ledge_P =
  {
    _copy = "Junc_Ledge_T"
    _shape  = "P"

    north_h = 64
  }


  Junc_Well_P =
  {
    _prefab = "JUNCTION_WELL_1"
    _shape  = "P"
    _liquid = 1
    _heights = { 0,-84,84,168 }

    brick  = "BIGBRIK2"
    top    = "MFLR8_1"
    floor1 = "BIGBRIK1"
    step   = "ROCK3"

    gore_ent  = "skull_pole"

    torch_ent = { blue_torch_sm=50, blue_torch=50,
                  red_torch_sm=10,  red_torch=10 }
  }

  Junc_Well_T =
  {
    _copy = "Junc_Well_P"
    _shape  = "T"

    north_h = 296  -- closed
  }

  Junc_Well_I =
  {
    _copy = "Junc_Well_P"
    _shape  = "I"

    east_h = 212  -- closed
    west_h =  44  --
  }


  ---| TELEPORTERS |---

  Teleporter1 =
  {
    _file   = "misc/tele_pad.wad"
    _where  = "middle"

    tele = { GATE1=60, GATE2=60, GATE3=30 }
    side = "METAL"

    x_offset = 0
    y_offset = 0
    peg = 1

    special = 97
    effect = 8
    light = 255
  }

  Teleporter_Closet =
  {
    _file  = "closet/teleport1.wad"
    _where = "closet"
    _fitted = "xy"
--!!!!  _long   = 192

    tele = "GATE4"
    tele_side = "METAL"

    inner = "REDWALL"
    floor = "CEIL3_3"
    ceil  = "CEIL3_3"
    step  = "STEP1"

    special = 97
  }


  ---| WALLS |---

  Wall_plain =
  {
    _file   = "wall/plain.wad"
    _where  = "edge"
    _fitted = "xyz"

    _bound_z1 = 0
    _bound_z2 = 128
  }


  ---| WINDOWS |---

  Window1 =
  {
    _file   = "window/window1.wad"
    _where  = "edge"
    _fitted = "xy"
    _long   = 192
    _deep   = 24

    track = "SHAWN2"
  }


  ---| FENCES |---

  Fence1 =
  {
    _file   = "fence/fence1.wad"
    _where  = "edge"
    _fitted = "xy"
    _long   = 192
    _deep   = 32

    fence = "ICKWALL7"
    metal = "METAL"
    rail  = "MIDBARS3"
  }


  Sky_fence =
  {
    _file   = "fence/sky_fence.wad"
    _where  = "chunk"
    _fitted = "xy"
  }

  Sky_corner =
  {
    _file   = "fence/sky_corner.wad"
    _where  = "chunk"
    _fitted = "xy"
  }


  ---| PICTURES |---

  Pic_Pill =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "O_PILL"
    pic_w = 128
    pic_h = 32

    light = 64
  }

  Pic_Carve =
  {
    _file   = "wall/pic_64x64.wad"
    _where  = "edge"
    _fitted = "xy"
    _bound_z1 = 0
    _bound_z2 = 128
    _long   = 192

    pic   = "O_CARVE"
    pic_w = 64
    pic_h = 64

    light = 64
  }

  Pic_Neon =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "O_NEON"
    pic_w = 128
    pic_h = 128

    light = 64
    effect = 8
    fx_delta = -64
  }


  -- techy --

  Pic_Computer =
  {
    _file   = "wall/pic_128x48.wad"
    _where  = "edge"
    _fitted = "xy"
    _bound_z1 = 0
    _bound_z2 = 112
    _long   = 192

    pic   = { COMPSTA1=50, COMPSTA2=50 }
    pic_w = 128
    pic_h = 48

    light = 48
    effect = { [0]=90, [1]=5 }  -- sometimes blink
    fx_delta = -47
  }

  Pic_Silver3 =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "SILVER3"
    pic_w = 64
    pic_h = 96
    y_offset = 16

    light = 48
    effect = { [0]=90, [1]=5 }  -- sometimes blink
    fx_delta = -47
  }

  Pic_TekWall =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = { TEKWALL1=50, TEKWALL4=50 }
    pic_w = 144
    pic_h = 128
    y_offset = 24

    light = 32
    scroll = 48
  }

  Pic_LiteGlow =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 64
    _repeat = 96

    pic   = "LITE3"
    pic_w = 32
    pic_h = 128

    light = 64
    effect = { [8]=90, [17]=5 }  -- sometimes flicker
    fx_delta = -63
  }

  Pic_LiteGlowBlue =
  {
    _copy = "Pic_LiteGlow"

    pic = "LITEBLU4"
  }

  Pic_LiteFlash =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 64

    pic   = "LITE3"
    pic_w = 32
    pic_h = 128

    light = 64
    effect = { [1]=90, [2]=20 }
    fx_delta = -63
  }

  -- hellish --

  Pic_FireWall =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "FIREWALL"
    pic_w = 128
    pic_h = 112

    light = 64
--  effect = 17
--  fx_delta = -16
  }

  Pic_MarbFace =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = { MARBFAC2=50, MARBFAC3=50 }
    pic_w = 128
    pic_h = 128

    light = 16
  }

  Pic_DemonicFace =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "MARBFACE"
    pic_w = 128
    pic_h = 128

    light = 32
  }

  Pic_SkinScroll =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "SKINFACE"
    pic_w = 144
    pic_h = 80
    
    y_offset = 24

    light = 32
    scroll = 48
  }

  Pic_FaceScroll =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "SP_FACE1"
    pic_w = 144
    pic_h = 96

    light = 32
    scroll = 48
  }

  -- urban --

  Pic_Adolf =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "ZZWOLF7"
    pic_w = 128
    pic_h = 128

    light = 16
  }

  Pic_Eagle =
  {
    _copy = "Pic_Adolf"

    pic = "ZZWOLF6"
  }

  Pic_Wreath =
  {
    _copy = "Pic_Adolf"

    pic = "ZZWOLF13"
  }

  Pic_MetalFace =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = { SW1SATYR=50, SW1GARG=50, SW1LION=50 }
    pic_w = 64
    pic_h = 72
    y_offset = 56

    light = 16
  }

  Pic_MetalFaceLit =
  {
    _copy = "Pic_MetalFace"

    pic = { SW2SATYR=50, SW2GARG=50, SW2LION=50 }

    light = 32
  }


  ---| CAGES |---

  Fat_Cage1 =
  {
    _file   = "cage/fat_edge.wad"
    _where  = "chunk"
    _fitted = "xy"

    rail = "MIDBARS3"    
  }

  Fat_Cage_W_Bars =
  {
    _prefab = "FAT_CAGE_W_BARS"
    _where  = "chunk"

    bar = "METAL"
  }


  ---| DECORATION |---

  Pillar_2 =
  {
    _prefab = "PILLAR_2"
    _where  = "middle"
    _radius = 40
---!!    _long   = 384
---!!    _deep   = 384

    base   = "GRAY1"
    pillar = "METAL"
  }

  RoundPillar =
  {
    _prefab = "ROUND_PILLAR"
    _where  = "middle"
    _radius = 32

    pillar = "TEKLITE"
  }

  Crate1 =
  {
    _prefab = "CRATE"
    _where  = "middle"
    _radius = 32

    crate = "CRATE1"
  }

  Crate2 =
  {
    _prefab = "CRATE"
    _where  = "middle"
    _radius = 32

    crate = "CRATE2"
  }

  CrateWOOD =
  {
    _prefab = "CRATE"
    _where  = "middle"
    _radius = 32

    crate = "WOOD3"
  }

  CrateICK =
  {
    _prefab = "CRATE"
    _where  = "middle"
    _radius = 32

    crate = "ICKWALL4"
  }

} -- end of DOOM.SKINS



----------------------------------------------------------------

DOOM.THEME_DEFAULTS =
{
  starts = { Start_basic = 10, Start_Closet = 70 }

  exits = { Exit_pillar = 10, Exit_Closet_tech = 70 }

  pedestals = { Pedestal_1 = 50 }

  stairs = { Stair_Up1 = 50, Stair_Down1 = 50,
             Lift_Up1 = 4, Lift_Down1 = 4 }

  keys = { kc_red=50, kc_blue=50, kc_yellow=50 }

  -- TODO: sw_wood  sw_marble
  switches = { sw_blue=50 }  --!!!! , sw_red=50, sw_pink=20, sw_vine=20 }

  switch_fabs  = { Switch_blue1=50 }
                 --!!!! Switch_red1=50, Switch_pink1=50, Switch_vine1=50 }

  locked_doors = { Locked_kc_blue = 50,   Locked_ks_blue = 50,
                   Locked_kc_red = 50,    Locked_ks_red = 50,
                   Locked_kc_yellow = 50, Locked_ks_yellow = 50,

                   Door_SW_blue = 50,
                   --!!!! Door_SW_red = 50, Door_SW_pink = 50, Door_SW_vine = 50,

--[[ !!!
                   Locked_kc_blue_NAR = 3,   Locked_ks_blue_NAR = 3,
                   Locked_kc_red_NAR = 3,    Locked_ks_red_NAR = 3,
                   Locked_kc_yellow_NAR = 3, Locked_ks_yellow_NAR = 3,
                     
                   Door_SW_blue_NAR = 3, Door_SW_red_NAR = 3,
                   Door_SW_pink_NAR = 3, Door_SW_vine_NAR = 3
--]]
                 }

  secrets = { Secret_Closet = 50 }

  arches = { Arch1 = 50 }

  doors = { Door_silver = 50 }

  teleporters = { Teleporter1 = 10, Teleporter_Closet = 80 }

  logos = { Pic_Carve=50 } --!!!! , Pic_Pill=50, Pic_Neon=20 }

  windows = { Window1 = 50 }

  fences = { Fence1 = 50 }

  hallway_groups = { hall_basic = 50 } --!!!! , hall_thin = 15 }  -- TODO: cavey

  mini_halls = { Hall_Basic_I = 50 } --!!!! , MiniHall_Door_tech = 20 }

  sky_halls = { sky_hall = 50 }

  big_junctions =
  {
--!!!     junc_ledge = 80
--!!!     junc_octo = 50
--!!!     junc_nuke_pipes = 14
--!!!  -- junc_Nuke_Islands = 70  -- size restriction means this is fairly rare
--!!!     junc_spokey = 10

    junc_circle_gothic = 40
  }

  fat_cages = { Fat_Cage1 = 50 } --- , Fat_Cage_W_Bars = 8 }

  outdoor_decor = { big_tree=50, burnt_tree=10, brown_stub=10 }

  indoor_decor = { barrel=60, burning_barrel=20,
                   dead_player=10, gibbed_player=10,
                   tech_column=10,
                   impaled_twitch=10, evil_eye=5,
                   candelabra=10, red_torch=5,
                   green_torch=5, blue_torch=5 }

  indoor_fabs = { Pillar_2=70,
                  Crate1=10, Crate2=10, 
                  CrateICK=10, CrateWOOD=10 }

  --------- OLD CRUD --------> > >

  outer_fences = { BROWN144=50, STONE2=30, BROWNHUG=10,
                   BROVINE2=10, GRAYVINE=10, ICKWALL3=2,
                   GRAY1=10, STONE=20,
                 }

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


DOOM.GROUPS =
{
  ---| HALLWAYS |---

  hall_basic =
  {
    kind = "hallway"

    parts =
    {
      Hall_Basic_I = 50
      Hall_Basic_C = 50
      Hall_Basic_T = 50
      Hall_Basic_P = 50

      Hall_Basic_I_Stair = 20
      Hall_Basic_I_Lift  = 2
    }
  }


  hall_thin =
  {
    kind = "hallway"

    narrow = 1

    parts =
    {
      Hall_Thin_I = 50
      Hall_Thin_C = 50
      Hall_Thin_T = 50

      Hall_Thin_I_Stair = 20
      Hall_Basic_I_Lift  = 2  -- TODO

      Hall_Thin_I_Bulge = 70
      Hall_Thin_I_Bend  = 20

      Hall_Thin_I_Oh = 5
      Hall_Thin_C_Oh = 5
      Hall_Thin_T_Oh = 20
      Hall_Thin_P_Oh = 50

      Hall_Basic_P = 1  -- TODO (needed since Hall_Thin_P_Oh is large)
    }
  }


  hall_cavey =
  {
    kind = "hallway"

    parts =
    {
      Hall_Cavey_I = 50
      Hall_Cavey_C = 50
      Hall_Cavey_T = 50
      Hall_Cavey_P = 50

      Hall_Cavey_I_Stair = 20
      Hall_Basic_I_Lift  = 2   -- TODO
    }
  }


  sky_hall =
  {
    kind = "skyhall"

    parts =
    {
      Sky_Hall_I = 50
      Sky_Hall_C = 50
      Sky_Hall_I_Stair = 50

      Hall_Basic_T = 50  -- use indoor versions for these
      Hall_Basic_P = 50  --

      Hall_Basic_I_Lift = 2   -- TODO: sky version
    }
  }


  ---| BIG JUNCTIONS |---

  junc_ledge =
  {
    parts =
    {
      Junc_Ledge_P = 50
      Junc_Ledge_T = 50
    }
  }

  junc_octo =
  {
    parts =
    {
      Junc_Octo_I = 50
      Junc_Octo_C = 50
      Junc_Octo_T = 50
      Junc_Octo_P = 50
    }
  }

  junc_nuke_pipes =
  {
    parts =
    {
      Junc_Nuke_Pipes_I = 50
      Junc_Nuke_Pipes_C = 50
      Junc_Nuke_Pipes_T = 50
      Junc_Nuke_Pipes_P = 50
    }
  }

  junc_nuke_islands =
  {
    parts =
    {
      Junc_Nuke_Islands_C = 50
    }
  }

  junc_spokey =
  {
    parts =
    {
      Junc_Spokey_I = 50
      Junc_Spokey_C = 50
      Junc_Spokey_T = 50
      Junc_Spokey_P = 50
    }
  }

  junc_circle_tech =
  {
    parts =
    {
      Junc_Circle_tech_I = 50
      Junc_Circle_tech_C = 50
      Junc_Circle_tech_T = 50
      Junc_Circle_tech_P = 50
    }
  }

  junc_circle_gothic =
  {
    parts =
    {
      Junc_Circle_gothic_I = 50
      Junc_Circle_gothic_C = 50
      Junc_Circle_gothic_T = 50
      Junc_Circle_gothic_P = 50
    }
  }

  junc_well =
  {
    parts =
    {
      Junc_Well_I = 50
      Junc_Well_T = 50
      Junc_Well_P = 50
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
      STARG1=10
    }

    floors =
    {
      FLOOR4_8=50
      FLOOR5_1 = 20
      FLOOR5_3=30
      FLOOR3_3=20
      FLOOR0_1 = 20
      FLOOR0_2 = 20
      FLOOR0_3=30
      SLIME15=10
      SLIME16=10
      FLAT4 = 15
      FLOOR1_1 = 8
    }

    ceilings =
    {
      CEIL3_3 = 15
      CEIL3_5=20,
      CEIL3_1=20,
      FLAT4=20,
      CEIL4_2 = 10,
      CEIL4_3=10,
      CEIL5_1=10,
      FLAT9=15,
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
      FLOOR5_1 = 25,
      FLOOR5_3=30,
      FLOOR3_3=20,
      FLOOR0_1 = 20,
      FLOOR0_2 = 15,
      FLOOR0_3=30,
      SLIME15=10,
      SLIME16=10,
      FLAT4=15,
    }

    ceilings =
    {
      CEIL3_1 = 20,
      CEIL3_2 = 20,
      CEIL3_5=20,
      CEIL3_1=20,
      FLAT4=20,
      CEIL4_3=10,
      CEIL5_1 = 15,
      CEIL5_2=10,
      FLAT9=30,
      FLAT19 = 20,
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
      FLOOR5_1 = 20,
      FLOOR5_3=30,
      FLOOR3_3=20,
      FLOOR0_3=30,
      FLOOR0_5 = 15,
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
      SLIME14 = 10,
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
      FLAT14 = 60
      FLOOR0_3 = 20
      FLOOR3_3 = 40
      FLOOR5_1 = 20
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
      FLOOR4_6 = 20,
      FLOOR7_1 = 15,
      FLAT4 = 5
      SLIME15 = 20,
      SLIME14 = 20,
    }

    ceilings =
    {
      CEIL5_1 = 40
      CEIL5_2 = 40
      SLIME15 = 40
      CEIL4_1 = 20
      SLIME14 = 40
    }
  }

  Tech2_cave =
  {
    naturals =
    {
      SP_ROCK1=50,
      GRAYVINE=50,
      TEKWALL4=3,
      ASHWALL  = 50
      ASHWALL4 = 50
      ASHWALL6  = 10
      TANROCK7  = 10
      ZIMMER1  = 15
      ZIMMER3  = 20
      ZIMMER7  = 15
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
      GRASS1=40,   -- MOVE TO naturals
      FLOOR5_4=20,
    }

    naturals =
    {
      ASHWALL=50,
      ASHWALL4=50,
      SP_ROCK1=50,
      ASHWALL6  = 20
      TANROCK4  = 15
      ZIMMER2  = 15
      ZIMMER4  = 15
      ZIMMER8  = 5
      ROCK5  = 20
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
      STARBR2 = 10
      PIPE2 = 15
      PIPE4 = 15
      TEKWALL4 = 10
    }

    floors =
    {
      FLAT14 = 50,
      FLOOR4_8 = 15
      FLAT1 = 20,
      FLOOR0_2 = 20,
      FLOOR1_6 = 5,
      CEIL4_1 = 20
    }

    ceilings =
    {
      CEIL3_5=50,
      CEIL3_6=20,
      CEIL3_1=50,
      RROCK03=50,
      TLITE6_5=10
      CEIL4_2 = 20
      GRNLITE1 = 20
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
      FLAT5_3 = 30
      FLAT10   = 50
      FLAT1  = 20
      FLOOR7_1 = 50
      FLAT5_7 = 10
      FLAT5_8 = 10
    }

    ceilings =
    {
      FLOOR6_1 = 20
      FLOOR6_2 = 20
      FLAT10 = 15
      FLAT5_3 = 10
    }
  }

  Hell2_marble =
  {
    walls =
    {
      MARBLE1  = 20
      MARBLE2 = 50
      MARBLE3  = 50
    }

    floors =
    {
      FLAT10   = 25
      FLOOR7_1 = 30
      DEM1_5  = 50
      DEM1_6  = 30
      FLOOR7_2  = 30
    }

    ceilings =
    {
      FLOOR7_2  = 50
      DEM1_5  = 20
      FLOOR6_1 = 20
      FLOOR6_2 = 20
      MFLR8_4  = 15
    }
  }

  Hell2_hallway =
  {
    walls =
    {
      MARBGRAY = 80
      GSTVINE1 = 40
      GSTVINE2 = 40
      GSTONE1  = 20
      SKINMET1 = 10
      SKINMET2 = 10
    }

    floors =
    {
      FLAT1 = 50
      DEM1_6  = 30
      FLOOR7_1  = 20
      FLOOR7_2  = 25
      FLAT10  = 20
    }

    ceilings =
    {
      FLAT1 = 50
      SFLR6_1 = 20
      SFLR6_4 = 20
      FLAT5_2 = 10
      FLOOR7_2 = 20
    }
  }

  Hell2_cave =
  {
    naturals =
    {
      ROCKRED1 = 50
      SP_ROCK1 = 25
      GSTVINE2 = 25
      ZIMMER1  = 15
      SKIN2 = 10
      FIREBLU1 = 12
    }
  }

  Hell2_outdoors =
  {
    floors =
    {
      FLOOR6_2 = 10
      FLAT5_7 = 20
      FLAT5_8 = 10
      RROCK03 = 30  -- REMOVE
      RROCK04 = 30  -- REMOVE
      RROCK09 = 15  -- REMOVE
    }

    naturals =
    {
      ROCKRED1 = 50
      SP_ROCK1 = 30
      ASHWALL  = 30
      ASHWALL3  = 25
      ASHWALL6  = 20
      ASHWALL7  = 15
      ASHWALL4 = 30
      SKIN2 = 10
      SKSNAKE1 = 30
      SKSNAKE2 = 30
    }
  }


  ---- Urban / City / Earth ---------------------

--PANEL7 looks silly as a facade --Chris

  Urban_panel =
  {
    facades =
    {
      BIGBRIK1 = 30
      BIGBRIK2 = 15
      BLAKWAL2 = 10
      MODWALL1 = 20
      MODWALL3 = 10
      CEMENT7 = 5
      CEMENT9 = 5
      METAL2 = 3
    }

    walls =
    {
      PANEL6 = 50
      PANEL8 = 50
      PANEL9 = 30
      PANEL7 = 20
      PANEL3 = 50
      PANEL2 = 50
      PANCASE2 = 30
    }

    floors =
    {
      FLOOR0_2 = 15
      FLOOR5_3 = 20
      FLOOR5_4 = 15
      FLAT1_1 = 50
      FLAT4 = 50
      FLAT1 = 30
      FLAT8 = 10
      FLAT5_5 = 30
      FLAT5 = 20
    }

    ceilings =
    {
      FLAT1 = 50
      CEIL1_1 = 20
      FLAT5_2 = 20
      CEIL3_3 = 10
      RROCK10 = 20
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
      FLOOR0_1 = 20
      FLAT1_1 = 50
      FLOOR0_3 = 20
      FLAT5_1 = 50
      FLAT5_2 = 20
      FLAT1 = 30
      FLAT5 = 15
      FLOOR5_4 = 10
    }

    ceilings =
    {
      FLAT1 = 50
      RROCK10 = 20
      RROCK14 = 20
      MFLR8_1 = 10
      CEIL1_1 = 15
      FLAT5_2 = 10
    }
  }

  Urban_brick =
  {
    walls =
    {
      BRICK1 = 10
      BRICK2  = 15
      BRICK5  = 50
      BRICK6  = 20
      BRICK7  = 30
      BRICK8  = 15
      BRICK9  = 20
      BRICK12 = 30
      BRICK11 = 3
      BRICK10  = 5
    }

    floors =
    {
      FLOOR0_1 = 20
      FLOOR0_2 = 20
      FLOOR0_3 = 20
      FLOOR4_6 = 20
      FLOOR5_3 = 25
      FLAT8 = 50
      FLAT5_1 = 50
      FLAT5_2 = 30
      FLAT5_4 = 20
      FLAT5_5 = 30
      FLAT1 = 30
    }

    ceilings =
    {
      FLAT1 = 50
      FLAT5_4 = 20
      FLAT8 = 15
      RROCK10 = 20
      RROCK14 = 20
      SLIME13 = 5
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
      FLAT1_2 = 50
      FLAT5_2 = 50
      FLAT1 = 50
      FLAT8 = 20
      FLAT5_4 = 35
      FLAT5_5 = 20
      FLAT5_1 = 50
      SLIME15 = 15
    }

    ceilings =
    {
      FLAT1 = 50
      CEIL1_1 = 20
      CEIL3_5 = 25
      MFLR8_1 = 30
      FLAT5_4 = 20
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
      WOOD1    = 50
      WOOD12   = 50
      WOOD9    = 50
      WOODVERT = 50
      PANEL1   = 50
      PANEL7   = 30
      STUCCO  = 30
      STUCCO1  = 30
      STUCCO3  = 30
    }

    floors =
    {
      FLAT5_1 = 50
      FLAT5_2 = 20
      FLAT8   = 50
      FLAT5_4 = 50
      MFLR8_1 = 50
      FLOOR5_3 = 20
      FLAT5 = 20
    }

    ceilings =
    {
      CEIL1_1 = 30
      FLAT5_2 = 25
      CEIL3_5 = 20
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
}


DOOM2.ROOM_THEMES =
{
  ---- Wolfenstein 3D -------------

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

--!!!!    logos = { Pic_Carve=10, Pic_Pill=90, Pic_Neon=50 }

    pictures =
    {
      Pic_Computer = 70
--!!!      Pic_TekWall = 10
--!!!      Pic_Silver3 = 25
--!!!
--!!!      Pic_LiteGlow = 20
--!!!      Pic_LiteGlowBlue = 10
--!!!      Pic_LiteFlash = 20
    }

    crates = { crate1=50, crate2=50, comp=70, lite5=20,
      space=90, mod=15 }

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

    __mini_halls = { MiniHall_Arch1 = 50, MiniHall_Door_hell = 20 }

    __big_junctions =
    {
      junc_octo = 50
      junc_nuke_pipes = 5
      junc_spokey = 10
      junc_circle_gothic = 40
    }

--!!    exits = { Exit_Closet_hell = 50, Exit_Pillar_gothic = 10 }

--!!!!    logos = { Pic_Carve=90, Pic_Pill=50, Pic_Neon=5 }

--[[
    pictures =
    {
      Pic_MarbFace = 40
      Pic_DemonicFace = 20
      Pic_FireWall = 30
      Pic_SkinScroll = 10
      Pic_FaceScroll = 10
    }
--]]

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

--!!!!    logos = { carve=90, pill=50, neon=5 }

--[[
    pictures =
    {
      marbfac2=10, marbfac3=10,
      spface1=2, firewall=20,
      spine=5,

      spdude7=7,
    }
--]]

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

--!!    exits = { Exit_Closet_urban=50, Exit_Pillar_urban=10,
--!!              Exit_Pillar_gothic=3 }

    __mini_halls = { MiniHall_Arch1 = 50 }

    __big_junctions =
    {
      junc_well = 99

      junc_octo = 50
      junc_nuke_pipes = 5
      junc_spokey = 10
      junc_circle_gothic = 40
    }

--!!!!    logos = { Pic_Carve=30, Pic_Pill=30, Pic_Neon=70 }

--[[
    pictures =
    {
      Pic_MetalFace = 50
      Pic_MetalFaceLit = 50
      Pic_MarbFace = 25

      Pic_Eagle = 20
      Pic_Wreath = 20
      Pic_Adolf = 2
    }
--]]

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


DOOM2.PREBUILT_LEVELS =
{
  MAP07 =
  {
    { prob=50, file="doom2_boss/simple1.wad", map="MAP07" }
    { prob=50, file="doom2_boss/simple2.wad", map="MAP07" }
    { prob=50, file="doom2_boss/simple3.wad", map="MAP07" }
    { prob=50, file="doom2_boss/simple4.wad", map="MAP07" }
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
    { prob=20, file="doom2_boss/gotcha4.wad", map="MAP01" }
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
    id = 3004
    r = 20
    h = 56 
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
    id = 9
    r = 20
    h = 56 
    level = 2
    prob = 50
    health = 30
    damage = 15
    attack = "hitscan"
    give = { {weapon="shotty"}, {ammo="shell",count=4} }
    species = "zombie"
    infights = true
  }

  imp =
  {
    id = 3001
    r = 20
    h = 56 
    level = 1
    prob = 60
    health = 60
    damage = 20
    attack = "missile"
  }

  skull =
  {
    id = 3006
    r = 16
    h = 56 
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
    id = 3002
    r = 30
    h = 56 
    level = 1
    prob = 35
    health = 150
    damage = 25
    attack = "melee"
    weap_prefs = { launch=0.5 }
  }

  spectre =
  {
    id = 58
    r = 30
    h = 56 
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
    id = 3005
    r = 31
    h = 56 
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
    id = 3003
    r = 24
    h = 64 
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
    id = 16
    r = 40
    h = 110
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
    id = 7
    r = 128
    h = 100
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
    id = 65
    r = 20
    h = 56 
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
    id = 66
    r = 20
    h = 64 
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
    id = 69
    r = 24
    h = 64 
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
    id = 67
    r = 48
    h = 64 
    level = 6
    prob = 37
    health = 600
    damage = 70
    attack = "missile"
    density = 0.6
  }

  arach =
  {
    id = 68
    r = 66
    h = 64 
    level = 6
    prob = 25
    health = 500
    damage = 70
    attack = "missile"
    density = 0.8
  }

  vile =
  {
    id = 64
    r = 20
    h = 56 
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
    id = 71
    r = 31
    h = 56 
    level = 6
    prob = 8
    crazy_prob = 15
    skip_prob = 180
    health = 800  -- 400 + skulls
    damage = 20
    attack = "missile"
    density = 0.2
    never_promote = true
    float = true
    weap_prefs = { launch=0.2 }
  }

  -- NOTE: not generated in normal levels
  ss_dude =
  {
    id = 84
    r = 20
    h = 56 
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
    id = 2005
    level = 1
    pref = 3
    add_prob = 2
    attack = "melee"
    rate = 8.7
    damage = 10
  }

  berserk =
  {
    id = 2023
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
    id = 2002
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
    id = 2001
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
    id = 2003
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
    id = 2004
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
    id = 2006
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
    id = 82
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
    id = 2014
    prob = 20
    cluster = { 4,7 }
    give = { {health=1} }
  }

  stimpack =
  {
    id = 2011
    prob = 60
    cluster = { 2,5 }
    give = { {health=10} }
  }

  medikit =
  {
    id = 2012
    prob = 100
    give = { {health=25} }
  }

  soul =
  {
    id = 2013
    prob = 3
    big_item = true
    start_prob = 5
    give = { {health=150} }
  }

  -- ARMOR --

  helmet =
  {
    id = 2015
    prob = 10
    armor = true
    cluster = { 4,7 }
    give = { {health=1} }
  }

  green_armor =
  {
    id = 2018
    prob = 5
    armor = true
    big_item = true
    start_prob = 80
    give = { {health=30} }
  }

  blue_armor =
  {
    id = 2019
    prob = 2
    armor = true
    big_item = true
    start_prob = 30
    give = { {health=80} }
  }

  -- AMMO --

  bullets =
  {
    id = 2007
    prob = 10
    cluster = { 2,5 }
    give = { {ammo="bullet",count=10} }
  }

  bullet_box =
  {
    id = 2048
    prob = 40
    give = { {ammo="bullet",count=50} }
  }

  shells =
  {
    id = 2008
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="shell",count=4} }
  }

  shell_box =
  {
    id = 2049
    prob = 40
    give = { {ammo="shell",count=20} }
  }

  rocket =
  {
    id = 2010
    prob = 10
    cluster = { 4,7 }
    give = { {ammo="rocket",count=1} }
  }

  rocket_box =
  {
    id = 2046
    prob = 40
    give = { {ammo="rocket",count=5} }
  }

  cells =
  {
    id = 2047
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="cell",count=20} }
  }

  cell_pack =
  {
    id = 17
    prob = 40
    give = { {ammo="cell",count=100} }
  }

  -- Doom II only --

  mega =
  {
    id = 83
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


DOOM2.SECRET_EXITS =
{
  MAP15 = true
  MAP31 = true
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
  }

  episode3 =
  {
    sky_light = 0.75
  }
}


DOOM2.ORIGINAL_THEMES =
{
  "doom_tech"
  "doom_urban"
  "doom_hell"
}


------------------------------------------------------------


function DOOM2.setup()
  -- nothing needed
end


function DOOM2.get_levels()
  local MAP_NUM = 11

  if OB_CONFIG.length == "single" then MAP_NUM = 1  end
  if OB_CONFIG.length == "few"    then MAP_NUM = 4  end
  if OB_CONFIG.length == "full"   then MAP_NUM = 32 end

  gotcha_map = rand.pick{17,18,19}
  gallow_map = rand.pick{24,25,26}

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

    if map > 30 then
      ep_index = 3 ; ep_along = 0.35
    elseif map > 20 then
      ep_index = 3 ; ep_along = (map - 20) / 10
    elseif map > 11 then
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

    LEV.secret_exit = GAME.SECRET_EXITS[LEV.name]

    if map == 31 or map == 32 then
      -- secret levels are easy
      LEV.mon_along = 0.35
    elseif OB_CONFIG.length == "single" then
      LEV.mon_along = ep_along
    else
      -- difficulty ramps up over whole wad
      LEV.mon_along = map * 1.4 / math.min(MAP_NUM, 20)
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


function DOOM2.end_level()
  if LEVEL.description and LEVEL.patch then
    DOOM.make_level_gfx()
  end
end


function DOOM2.all_done()
  DOOM.make_cool_gfx()

  gui.wad_merge_sections("doom_falls.wad");
  gui.wad_merge_sections("vine_dude.wad");

  if OB_CONFIG.length == "full" then
    gui.wad_merge_sections("freedoom_face.wad");
  end
end



------------------------------------------------------------


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
    end_level    = DOOM2.end_level
    all_done     = DOOM2.all_done
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

OB_THEMES["doom_hell"] =
{
  label = "Hell"
  priority = 4
  for_games = { doom1=1, doom2=1 }
  name_theme = "GOTHIC"
  mixed_prob = 50
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

