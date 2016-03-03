----------------------------------------------------------------
-- GAME DEF : Hexen
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2011 Andrew Apted
--  Copyright (C) 2011-2012 Jared Blackburn
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

HEXEN = { }

HEXEN.ENTITIES =
{
  --- players
  player1 = { id=1, r=16, h=64 }
  player2 = { id=2, r=16, h=64 }
  player3 = { id=3, r=16, h=64 }
  player4 = { id=4, r=16, h=64 }

  dm_player     = { id=11 }
  teleport_spot = { id=14 }
  
  --- PICKUPS ---

  -- keys
  k_steel   = { id=8030 }  -- KEY1 sprite
  k_cave    = { id=8031 }  -- KEY2
  k_axe     = { id=8032 }  -- KEY3
  k_fire    = { id=8033 }  -- KEY4
  k_emerald = { id=8034 }  -- KEY5
  k_dungeon = { id=8035 }  -- KEY6
  k_silver  = { id=8036 }  -- KEY7
  k_rusty   = { id=8037 }  -- KEY8
  k_horn    = { id=8038 }  -- KEY9
  k_swamp   = { id=8039 }  -- KEYA
  k_castle  = { id=8200 }  -- KEYB
 
  -- weapons
  c_staff   = { id=10,  r=20, h=16 }
  c_fire    = { id=8009,r=20, h=16 }
  c1_shaft  = { id=20,  r=20, h=16 }
  c2_cross  = { id=19,  r=20, h=16 }
  c3_arc    = { id=18,  r=20, h=16 }

  f_axe     = { id=8010,r=20, h=16 }
  f_hammer  = { id=123, r=20, h=16 }
  f1_hilt   = { id=16,  r=20, h=16 }
  f2_cross  = { id=13,  r=20, h=16 }
  f3_blade  = { id=12,  r=20, h=16 }

  m_cone    = { id=53,  r=20, h=16 }
  m_blitz   = { id=8040,r=20, h=16 }
  m1_stick  = { id=23,  r=20, h=16 }
  m2_stub   = { id=22,  r=20, h=16 }
  m3_skull  = { id=21,  r=20, h=16 }

  -- artifacts
  wings = { id=83 }
  chaos = { id=36 }
  torch = { id=33 }

  banish    = { id=10040 }
  boots     = { id=8002 }
  bracer    = { id=8041 }
  repulser  = { id=8000 }
  flechette = { id=10110 }
  servant   = { id=86 }
  porkies   = { id=30 }
  incant    = { id=10120 }
  defender  = { id=84 }
  krater    = { id=8003 }

  --- SCENERY ---

  -- lights
  candles       = { id=119,  r=20, h=20, light=255 }
  blue_candle   = { id=8066, r=20, h=20, light=255 }
  fire_skull    = { id=8060, r=12, h=12, light=255 }
  brass_brazier = { id=8061, r=12, h=40, light=255 }

  wall_torch      = { id=54,  r=20, h=48, light=255 }
  wall_torch_out  = { id=55,  r=20, h=48 }
  twine_torch     = { id=116, r=12, h=64, light=255 }
  twine_torch_out = { id=117, r=12, h=64 }
  chandelier      = { id=17,  r=20, h=60, light=255, ceil=true }
  chandelier_out  = { id=8063,r=20, h=60, light=255, ceil=true }

  cauldron        = { id=8069,r=16, h=32, light=255 }
  cauldron_out    = { id=8070,r=16, h=32 }
  fire_bull       = { id=8042,r=24, h=80, light=255 }
  fire_bull_out   = { id=8043,r=24, h=80 }

  -- urbane
  winged_statue1 = { id=5,   r=12, h=64 }
  winged_statue2 = { id=9011,r=12, h=64 }
  suit_of_armor  = { id=8064,r=16, h=72 }

  gargoyle_tall  = { id=72, r=16, h=108 }
  gargoyle_short = { id=74, r=16, h=64  }
  garg_ice_tall  = { id=73, r=16, h=108 }
  garg_ice_short = { id=76, r=16, h=64  }

  garg_corrode     = { id=8044, r=16, h=108 }
  garg_red_tall    = { id=8045, r=16, h=108 }
  garg_red_short   = { id=8049, r=16, h=64  }
  garg_lava_tall   = { id=8046, r=16, h=108 }
  garg_lava_short  = { id=8050, r=16, h=64  }

  garg_bronz_tall  = { id=8047, r=16, h=108 }
  garg_bronz_short = { id=8051, r=16, h=64  }
  garg_steel_tall  = { id=8048, r=16, h=108 }
  garg_steel_short = { id=8052, r=16, h=64  }

  bell   = { id=8065, r=56, h=120 }
  barrel = { id=8100, r=16, h=36 }
  bucket = { id=8103, r=12, h=72 }
  banner = { id=77,   r=12, h=120 }

  vase_pillar = { id=103, r=12, h=56 }

  -- nature
  tree1 = { id=25, r=16, h=128 }
  tree2 = { id=26, r=12, h=180 }
  tree3 = { id=27, r=12, h=160 }

  lean_tree1 = { id=78,  r=16, h=180 }
  lean_tree2 = { id=79,  r=16, h=180 }
  smash_tree = { id=8062,r=16, h=180 }
  xmas_tree  = { id=8068,r=12, h=132 }

  gnarled_tree1 = { id=80, r=24, h=96 }
  gnarled_tree2 = { id=87, r=24, h=96 }

  shrub1 = { id=8101, r=12, h=24 }
  shrub2 = { id=8102, r=16, h=40 }

  rock1  = { id=6,  r=20, h=16 }
  rock2  = { id=7,  r=20, h=16 }
  rock3  = { id=9,  r=20, h=16 }
  rock4  = { id=15, r=20, h=16 }

  stal_pillar   = { id=48, r=12, h=136 }
  stal_F_big    = { id=49, r=12, h=48 }
  stal_F_medium = { id=50, r=12, h=40 }
  stal_F_small  = { id=51, r=12, h=40 }

  stal_C_big    = { id=52, r=12, h=68 }
  stal_C_medium = { id=56, r=12, h=52 }
  stal_C_small  = { id=57, r=12, h=40 }

  ice_stal_F_big    = { id=93, r=12, h=68 }
  ice_stal_F_medium = { id=94, r=12, h=52 }
  ice_stal_F_small  = { id=95, r=12, h=36 }
  ice_stal_F_tiny   = { id=95, r=12, h=16 }

  ice_stal_C_big    = { id=89, r=12, h=68 }
  ice_stal_C_medium = { id=90, r=12, h=52 }
  ice_stal_C_small  = { id=91, r=12, h=36 }
  ice_stal_C_tiny   = { id=92, r=12, h=16 }

  -- gory
  impaled_corpse = { id=61,  r=12, h=96 }
  laying_corpse  = { id=62,  r=12, h=44 }
  hang_corpse_1  = { id=71,  r=12, h=75, ceil=true }
  hang_corpse_1  = { id=108, r=12, h=96, ceil=true }
  hang_corpse_1  = { id=109, r=12, h=100,ceil=true }
  smash_corpse   = { id=110, r=12, h=40 }

  iron_maiden    = { id=8067,r=16, h=60 }

  -- miscellaneous
  teleport_smoke = { id=140, r=20, h=80, pass=true }
  dummy = { id=55, r=16, h=20, pass=true }

  -- ambient sounds
  snd_stone  = { id=1400 }
  snd_heavy  = { id=1401 }
  snd_metal1 = { id=1402 }
  snd_creak  = { id=1403 }
  snd_silent = { id=1404 }
  snd_lava   = { id=1405 }
  snd_water  = { id=1406 }
  snd_ice    = { id=1407 }
  snd_earth  = { id=1408 }
  snd_metal2 = { id=1409 }
}


HEXEN.PARAMETERS =
{
  sub_format = "hexen"

  light_brushes = true

  rails = true
  switches = true
  infighting  =  true
  prefer_stairs = true

  -- special logic for Hexen weapon system
  hexen_weapons = true

  jump_height = 66

  max_name_length = 28

  skip_monsters = { 20,30 }

  time_factor   = 1.0
  damage_factor = 1.0
  ammo_factor   = 0.8
  health_factor = 0.7
}


----------------------------------------------------------------

HEXEN.MATERIALS =
{
  -- special materials --
  _ERROR = { t="STEEL01", f="F_075" }
  _SKY   = { t="STEEL01", f="F_SKY" }

  -- walls --

  BOOKS01  = { t="BOOKS01",  f="F_092" }
  BOOKS02  = { t="BOOKS02",  f="F_092" }
  BOOKS03  = { t="BOOKS03",  f="F_092" }
  BOOKS04  = { t="BOOKS04",  f="F_092" }
  BRASS1   = { t="BRASS1",   f="F_037" }
  BRASS3   = { t="BRASS3",   f="F_037" }
  BRASS4   = { t="BRASS5",   f="F_037" }
  CASTLE01 = { t="CASTLE01", f="F_012" }
  CASTLE02 = { t="CASTLE02", f="F_012" }
  CASTLE03 = { t="CASTLE03", f="F_012" }
  CASTLE04 = { t="CASTLE04", f="F_012" }
  CASTLE05 = { t="CASTLE05", f="F_012" }
  CASTLE06 = { t="CASTLE06", f="F_012" }
  CASTLE07 = { t="CASTLE07", f="F_057" }
  CASTLE08 = { t="CASTLE08", f="F_057" }
  CASTLE11 = { t="CASTLE11", f="F_073" }

  CAVE01   = { t="CAVE01",   f="F_073" }
  CAVE02   = { t="CAVE02",   f="F_076" }
  CAVE03   = { t="CAVE03",   f="F_039" }
  CAVE04   = { t="CAVE04",   f="F_039" }
  CAVE05   = { t="CAVE05",   f="F_007" }
  CAVE06   = { t="CAVE06",   f="F_039" }
  CAVE07   = { t="CAVE07",   f="F_008" }
  CAVE12   = { t="CAVE12",   f="F_076" }
  CHAP1    = { t="CHAP1",    f="F_082" }
  CHAP2    = { t="CHAP2",    f="F_082" }
  CHAP3    = { t="CHAP3",    f="F_082" }
  CLOCKA   = { t="CLOCKA",   f="F_082" }
  CRATE01  = { t="CRATE01",  f="F_049" }
  CRATE02  = { t="CRATE02",  f="F_051" }
  CRATE03  = { t="CRATE03",  f="F_050" }
  CRATE04  = { t="CRATE04",  f="F_052" }
  CRATE05  = { t="CRATE05",  f="F_053" }

  D_AXE    = { t="D_AXE",    f="F_092" }
  D_BRASS1 = { t="D_BRASS1", f="F_037" }
  D_BRASS2 = { t="D_BRASS2", f="F_037" }
  D_CAST   = { t="D_CAST",   f="F_073" }
  D_CAVE   = { t="D_CAVE",   f="F_073" }
  D_CAVE2  = { t="D_CAVE2",  f="F_007" }
  D_DUNGEO = { t="D_DUNGEO", f="F_092" }
  D_END1   = { t="D_END1",   f="F_073" }
  D_END2   = { t="D_END2",   f="F_073" }
  D_END3   = { t="D_END3",   f="F_092" }
  D_END4   = { t="D_END4",   f="F_092" }
  D_ENDBR  = { t="D_ENDBR",  f="F_037" }
  D_ENDSLV = { t="D_ENDSLV", f="F_082" }
  D_FIRE   = { t="D_FIRE",   f="F_013" }
  D_RUST   = { t="D_RUST",   f="F_073" }
  D_SILKEY = { t="D_SILKEY", f="F_092" }
  D_SILVER = { t="D_SILVER", f="F_073" }
  D_SLV1   = { t="D_SLV1",   f="F_066" }
  D_SLV2   = { t="D_SLV2",   f="F_066" }
  D_STEEL  = { t="D_STEEL",  f="F_065" }
  D_SWAMP  = { t="D_SWAMP",  f="F_018" }
  D_SWAMP2 = { t="D_SWAMP2", f="F_076" }
  D_WASTE  = { t="D_WASTE",  f="F_037" }
  D_WD01   = { t="D_WD01",   f="F_092" }
  D_WD02   = { t="D_WD02",   f="F_092" }
  D_WD03   = { t="D_WD03",   f="F_092" }
  D_WD04   = { t="D_WD04",   f="F_092" }
  D_WD05   = { t="D_WD05",   f="F_051" }
  D_WD06   = { t="D_WD06",   f="F_051" }
  D_WD07   = { t="D_WD07",   f="F_073" }
  D_WD08   = { t="D_WD08",   f="F_073" }
  D_WD09   = { t="D_WD09",   f="F_073" }
  D_WD10   = { t="D_WD10",   f="F_073" }
  D_WINNOW = { t="D_WINNOW", f="F_073" }
  DOOR51   = { t="DOOR51",   f="F_082" }

  FIRE01   = { t="FIRE01",   f="F_032" }
  FIRE02   = { t="FIRE02",   f="F_032" }
  FIRE03   = { t="FIRE03",   f="F_032" }
  FIRE04   = { t="FIRE04",   f="F_032" }
  FIRE05   = { t="FIRE05",   f="F_032" }
  FIRE06   = { t="FIRE06",   f="F_013" }
  FIRE07   = { t="FIRE07",   f="F_013" }
  FIRE08   = { t="FIRE08",   f="F_013" }
  FIRE09   = { t="FIRE09",   f="F_013" }
  FIRE10   = { t="FIRE10",   f="F_013" }
  FIRE11   = { t="FIRE11",   f="F_013" }
  FIRE12   = { t="FIRE12",   f="F_013" }
  FIRE14   = { t="FIRE14",   f="F_032" }
  FIRE15   = { t="FIRE15",   f="F_032" }
  FIRE17   = { t="FIRE17",   f="F_017" }

  FOREST01 = { t="FOREST01", f="F_014" }
  FOREST02 = { t="FOREST02", f="F_038" }
  FOREST03 = { t="FOREST03", f="F_038" }
  FOREST04 = { t="FOREST04", f="F_038" }
  FOREST05 = { t="FOREST05", f="F_048" }
  FOREST07 = { t="FOREST07", f="F_002" }
  FOREST10 = { t="FOREST10", f="F_047" }
  FOREST11 = { t="FOREST11", f="F_038" }
  FORPUZ1  = { t="FORPUZ1",  f="F_005" }
  FORPUZ2  = { t="FORPUZ2",  f="F_038" }
  FORPUZ3  = { t="FORPUZ3",  f="F_041" }

  GEARW    = { t="GEARW",    f="F_074" }
  GEARX    = { t="GEARX",    f="F_074" }
  GEARY    = { t="GEARY",    f="F_074" }
  GEARZ    = { t="GEARZ",    f="F_074" }
  GILO1    = { t="GILO1",    f="F_072" }
  GILO2    = { t="GILO2",    f="F_072" }

  GLASS01  = { t="GLASS01",  f="F_081" }
  GLASS02  = { t="GLASS02",  f="F_081" }
  GLASS03  = { t="GLASS03",  f="F_081" }
  GLASS04  = { t="GLASS04",  f="F_081" }
  GLASS05  = { t="GLASS05",  f="F_081" }
  GLASS06  = { t="GLASS06",  f="F_081" }
  GRAVE01  = { t="GRAVE01",  f="F_009" }
  GRAVE03  = { t="GRAVE03",  f="F_009" }
  GRAVE04  = { t="GRAVE04",  f="F_009" }
  GRAVE05  = { t="GRAVE05",  f="F_009" }
  GRAVE06  = { t="GRAVE06",  f="F_009" }
  GRAVE07  = { t="GRAVE07",  f="F_009" }
  GRAVE08  = { t="GRAVE08",  f="F_009" }

  ICE01    = { t="ICE01",    f="F_033" }
  ICE02    = { t="ICE02",    f="F_040" }
  ICE03    = { t="ICE03",    f="F_040" }
  ICE06    = { t="ICE06",    f="F_040" }
  MONK01   = { t="MONK01",   f="F_027" }
  MONK02   = { t="MONK02",   f="F_025" }
  MONK03   = { t="MONK03",   f="F_025" }
  MONK04   = { t="MONK04",   f="F_025" }
  MONK05   = { t="MONK05",   f="F_025" }
  MONK06   = { t="MONK06",   f="F_025" }
  MONK07   = { t="MONK07",   f="F_031" }
  MONK08   = { t="MONK08",   f="F_031" }
  MONK09   = { t="MONK09",   f="F_025" }
  MONK11   = { t="MONK11",   f="F_025" }
  MONK12   = { t="MONK12",   f="F_025" }
  MONK14   = { t="MONK14",   f="F_029" }
  MONK15   = { t="MONK15",   f="F_029" }
  MONK16   = { t="MONK16",   f="F_028" }
  MONK17   = { t="MONK17",   f="F_028" }
  MONK18   = { t="MONK18",   f="F_028" }
  MONK19   = { t="MONK19",   f="F_028" }
  MONK21   = { t="MONK21",   f="F_028" }
  MONK22   = { t="MONK22",   f="F_028" }
  MONK23   = { t="MONK23",   f="F_025" }

  PILLAR01 = { t="PILLAR01", f="F_037" }
  PILLAR02 = { t="PILLAR02", f="F_044" }
  PLANET1  = { t="PLANET1",  f="F_025" }
  PLANET2  = { t="PLANET2",  f="F_025" }
  PLAT01   = { t="PLAT01",   f="F_045" }
  PLAT02   = { t="PLAT02",   f="F_065" }  
  POOT     = { t="POOT",     f="F_048" }
  PRTL02   = { t="PRTL02",   f="F_057" }
  PRTL03   = { t="PRTL03",   f="F_019" }
  PRTL04   = { t="PRTL04",   f="F_044" }
  PRTL05   = { t="PRTL05",   f="F_044" }
  PRTL06   = { t="PRTL06",   f="F_057" }
  PUZZLE1  = { t="PUZZLE1",  f="F_082" }
  PUZZLE10 = { t="PUZZLE10", f="F_091" }
  PUZZLE11 = { t="PUZZLE11", f="F_091" }
  PUZZLE12 = { t="PUZZLE12", f="F_091" }
  PUZZLE2  = { t="PUZZLE2",  f="F_082" }
  PUZZLE3  = { t="PUZZLE3",  f="F_082" }
  PUZZLE4  = { t="PUZZLE4",  f="F_082" }
  PUZZLE5  = { t="PUZZLE5",  f="F_091" }
  PUZZLE6  = { t="PUZZLE6",  f="F_091" }
  PUZZLE7  = { t="PUZZLE7",  f="F_091" }
  PUZZLE8  = { t="PUZZLE8",  f="F_091" }
  PUZZLE9  = { t="PUZZLE9",  f="F_091" }

  SEWER01  = { t="SEWER01",  f="F_018" }
  SEWER02  = { t="SEWER02",  f="F_018" }
  SEWER05  = { t="SEWER05",  f="F_018" }
  SEWER06  = { t="SEWER06",  f="F_018" }
  SEWER07  = { t="SEWER07",  f="F_017" }
  SEWER08  = { t="SEWER08",  f="F_017" }
  SEWER09  = { t="SEWER09",  f="F_017" }
  SEWER10  = { t="SEWER10",  f="F_017" }
  SEWER11  = { t="SEWER11",  f="F_017" }
  SEWER12  = { t="SEWER12",  f="F_017" }
  SEWER13  = { t="SEWER13",  f="F_018" }

  SPAWN01  = { t="SPAWN01",  f="F_042" }
  SPAWN05  = { t="SPAWN05",  f="F_042" }
  SPAWN08  = { t="SPAWN08",  f="F_065" }
  SPAWN10  = { t="SPAWN10",  f="F_065" }
  SPAWN11  = { t="SPAWN11",  f="F_078" }
  SPAWN13  = { t="SPAWN13",  f="F_042" }
  STEEL01  = { t="STEEL01",  f="F_074" }
  STEEL02  = { t="STEEL02",  f="F_075" }
  STEEL05  = { t="STEEL05",  f="F_069" }
  STEEL06  = { t="STEEL06",  f="F_069" }
  STEEL07  = { t="STEEL07",  f="F_070" }
  STEEL08  = { t="STEEL08",  f="F_078" }
  SWAMP01  = { t="SWAMP01",  f="F_019" }
  SWAMP03  = { t="SWAMP03",  f="F_019" }
  SWAMP04  = { t="SWAMP04",  f="F_017" }
  SWAMP06  = { t="SWAMP06",  f="F_017" }

  TOMB01   = { t="TOMB01",   f="F_058" }
  TOMB02   = { t="TOMB02",   f="F_058" }
  TOMB03   = { t="TOMB03",   f="F_058" }
  TOMB04   = { t="TOMB04",   f="F_058" }
  TOMB05   = { t="TOMB05",   f="F_059" }
  TOMB06   = { t="TOMB06",   f="F_059" }
  TOMB07   = { t="TOMB07",   f="F_044" }
  TOMB08   = { t="TOMB08",   f="F_042" }
  TOMB09   = { t="TOMB09",   f="F_042" }
  TOMB10   = { t="TOMB10",   f="F_042" }
  TOMB11   = { t="TOMB11",   f="F_044" }
  TOMB12   = { t="TOMB12",   f="F_059" }
  VALVE1   = { t="VALVE1",   f="F_047" }
  VALVE2   = { t="VALVE2",   f="F_047" }
  VILL01   = { t="VILL01",   f="F_030" }
  VILL04   = { t="VILL04",   f="F_055" }
  VILL05   = { t="VILL05",   f="F_055" }

  WASTE01  = { t="WASTE01",  f="F_005" }
  WASTE02  = { t="WASTE02",  f="F_044" }
  WASTE03  = { t="WASTE03",  f="F_082" }
  WASTE04  = { t="WASTE04",  f="F_037" }
  WINN01   = { t="WINN01",   f="F_047" }
  WINNOW02 = { t="WINNOW02", f="F_022" }
  WOOD01   = { t="WOOD01",   f="F_054" }
  WOOD02   = { t="WOOD02",   f="F_092" }
  WOOD03   = { t="WOOD03",   f="F_092" }
  WOOD04   = { t="WOOD04",   f="F_054" }

  X_FAC01  = { t="X_FAC01",  f="X_001", sane=1 }
  X_FIRE01 = { t="X_FIRE01", f="X_001", sane=1 }
  X_SWMP1  = { t="X_SWMP1",  f="X_009", sane=1 }
  X_SWR1   = { t="X_SWR1",   f="F_018", sane=1 }
  X_WATER1 = { t="X_WATER1", f="X_005", sane=1 }


  -- steps --

  S_01     = { t="S_01",     f="F_047" }
  S_02     = { t="S_02",     f="F_009" }
  S_04     = { t="S_04",     f="F_030" }
  S_05     = { t="S_05",     f="F_057" }
  S_06     = { t="S_06",     f="F_009" }
  S_07     = { t="S_07",     f="F_009" }
  S_09     = { t="S_09",     f="F_047" }
  S_11     = { t="S_11",     f="F_034" }
  S_12     = { t="S_12",     f="F_053" }
  S_13     = { t="S_13",     f="F_057" }
  T2_STEP  = { t="T2_STEP",  f="F_057" }


  -- switches --

  BOSSK1   = { t="BOSSK1",   f="F_071", sane=1 }
  GEAR01   = { t="GEAR01",   f="F_091", sane=1 }
  SW51_OFF = { t="SW51_OFF", f="F_082", sane=1 }
  SW52_OFF = { t="SW52_OFF", f="F_082", sane=1 }
  SW53_UP  = { t="SW53_UP",  f="F_025", sane=1 }
  SW_1_UP  = { t="SW_1_UP",  f="F_048", sane=1 }
  SW_2_UP  = { t="SW_2_UP",  f="F_048", sane=1 }
  SW_EL1   = { t="SW_EL1",   f="F_082", sane=1 }
  SW_OL1   = { t="SW_OL1",   f="F_073", sane=1 }


  -- floors --

  F_001 = { t="WASTE01",  f="F_001" }
  F_002 = { t="WASTE01",  f="F_002" }
  F_003 = { t="WASTE01",  f="F_003" }
  F_004 = { t="WASTE01",  f="F_004" }
  F_005 = { t="WASTE01",  f="F_005" }
  F_006 = { t="WASTE01",  f="F_006" }
  F_007 = { t="CAVE05",   f="F_007" }
  F_008 = { t="CAVE07",   f="F_008" }
  F_009 = { t="PRTL02",   f="F_009" }
  F_010 = { t="PRTL04",   f="F_010" }
  F_011 = { t="FOREST01", f="F_011" }
  F_012 = { t="FIRE06",   f="F_012" }
  F_013 = { t="FIRE06",   f="F_013" }
  F_014 = { t="MONK16",   f="F_014" }
  F_015 = { t="CASTLE01", f="F_015" }
  F_017 = { t="SWAMP04",  f="F_017" }
  F_018 = { t="SEWER01",  f="F_018" }
  F_019 = { t="SWAMP01",  f="F_019" }
  F_020 = { t="SWAMP01",  f="F_020" }
  F_021 = { t="FIRE06",   f="F_021" }
  F_022 = { t="FIRE06",   f="F_022" }
  F_023 = { t="SEWER01",  f="F_023" }
  F_024 = { t="SEWER07",  f="F_024" }
  F_025 = { t="MONK02",   f="F_025" }
  F_027 = { t="MONK01",   f="F_027" }
  F_028 = { t="MONK16",   f="F_028" }
  F_029 = { t="MONK14",   f="F_029" }
  F_030 = { t="VILL01",   f="F_030" }
  F_031 = { t="MONK07",   f="F_031" }
  F_032 = { t="FIRE01",   f="F_032" }
  F_033 = { t="ICE01",    f="F_033" }
  F_034 = { t="FOREST02", f="F_034" }
  F_037 = { t="WASTE04",  f="F_037" }
  F_038 = { t="FOREST02", f="F_038" }
  F_039 = { t="CAVE04",   f="F_039" }
  F_040 = { t="CAVE04",   f="F_040" }
  F_041 = { t="FIRE06",   f="F_041" }
  F_042 = { t="FIRE06",   f="F_042" }
  F_043 = { t="WASTE02",  f="F_043" }
  F_044 = { t="PRTL04",   f="F_044" }
  F_045 = { t="WASTE03",  f="F_045" }
  F_046 = { t="WASTE03",  f="F_046" }
  F_047 = { t="TOMB07",   f="F_047" }
  F_048 = { t="FOREST05", f="F_048" }
  F_049 = { t="CRATE01",  f="F_049" }
  F_050 = { t="CRATE03",  f="F_050" }
  F_051 = { t="CRATE02",  f="F_051" }
  F_052 = { t="CRATE04",  f="F_052" }
  F_053 = { t="CRATE05",  f="F_053" }
  F_054 = { t="WOOD01",   f="F_054" }
  F_055 = { t="WOOD01",   f="F_055" }
  F_057 = { t="CASTLE07", f="F_057" }
  F_058 = { t="TOMB04",   f="F_058" }
  F_059 = { t="TOMB05",   f="F_059" }

  F_061 = { t="TOMB04",   f="F_061" }
  F_062 = { t="TOMB04",   f="F_062" }
  F_063 = { t="TOMB04",   f="F_063" }
  F_064 = { t="TOMB04",   f="F_064" }
  F_065 = { t="STEEL06",  f="F_065" }
  F_066 = { t="STEEL07",  f="F_066" }
  F_067 = { t="STEEL06",  f="F_067" }
  F_068 = { t="STEEL07",  f="F_068" }
  F_069 = { t="STEEL06",  f="F_069" }
  F_070 = { t="STEEL07",  f="F_070" }
  F_071 = { t="STEEL05",  f="F_071" }
  F_072 = { t="STEEL07",  f="F_072" }
  F_073 = { t="CASTLE11", f="F_073" }
  F_074 = { t="STEEL01",  f="F_074" }
  F_075 = { t="STEEL02",  f="F_075" }
  F_076 = { t="CAVE02",   f="F_076" }
  F_077 = { t="VILL01",   f="F_077" }
  F_078 = { t="STEEL06",  f="F_078" }
  F_081 = { t="GLASS05",  f="F_081" }
  F_082 = { t="CASTLE01", f="F_082" }
  F_083 = { t="CASTLE01", f="F_083" }
  F_084 = { t="CASTLE01", f="F_084" }
  F_089 = { t="CASTLE01", f="F_089" }
  F_091 = { t="CASTLE01", f="F_091" }
  F_092 = { t="WOOD01",   f="F_092" }


  -- liquids --

  X_001 = { t="X_FIRE01", f="X_001", sane=1  }
  X_005 = { t="X_WATER1", f="X_005", sane=1  }
  X_009 = { t="X_SWMP1",  f="X_009", sane=1  }
  X_012 = { t="CASTLE01", f="X_012", sane=1  }


  -- rails --

  GATE01  = { t="GATE01", rail_h=72,  line_flags=1 }
  GATE02  = { t="GATE02", rail_h=128, line_flags=1 }
  GATE03  = { t="GATE03", rail_h=64,  line_flags=1 }
  GATE04  = { t="GATE04", rail_h=32,  line_flags=1 }
  GATE51  = { t="GATE51", rail_h=128, line_flags=1 }
  GATE52  = { t="GATE52", rail_h=64,  line_flags=1 }
  GATE53  = { t="GATE53", rail_h=32,  line_flags=1 }

  BAMBOO_6 = { t="VILL06", rail_h=128, line_flags=1 }
  BAMBOO_7 = { t="VILL07", rail_h=64,  line_flags=1 }
  BAMBOO_8 = { t="VILL08", rail_h=96,  line_flags=1 }

  VINES     = { t="FOREST06", rail_h=128 }
  BRK_GLASS = { t="GLASS07",  rail_h=128 }
  BRK_TOMB  = { t="TOMB18",   rail_h=128 }

  H_CASTLE  = { t="CASTLE09", rail_h=128 }
  H_CAVE    = { t="CAVE11",   rail_h=128 }
  H_FIRE    = { t="FIRE16",   rail_h=128 }
  H_FORSET  = { t="FOREST12", rail_h=128 }
  H_MONK    = { t="MONK24",   rail_h=128 }
  H_PRTL    = { t="PRTL07",   rail_h=128 }
  H_SEWER   = { t="SEWER14",  rail_h=128 }
  H_SWAMP   = { t="SWAMP07",  rail_h=128 }
  H_TOMB    = { t="TOMB13",   rail_h=128 }

  R_TPORT1  = { t="TPORT1",  rail_h=128 }
  R_TPORTX  = { t="TPORTX",  rail_h=128 }
  R_VALVE01 = { t="VALVE01", rail_h=32 }
  R_VALVE02 = { t="VALVE02", rail_h=32 }

  SEWER_BAR3 = { t="SEWER03", rail_h=64, line_flags=1 }
  SEWER_BAR4 = { t="SEWER04", rail_h=32, line_flags=1 }

  WEB1_L   = { t="WEB1_L", rail_h=32 }
  WEB1_R   = { t="WEB1_R", rail_h=32 }
  WEB2_L   = { t="WEB2_L", rail_h=32 }
  WEB2_R   = { t="WEB2_R", rail_h=32 }
  WEB3     = { t="WEB3",   rail_h=32 }


  -- other --

  O_BOLT   = { t="SEWER08", f="O_BOLT",  sane=1 }
  O_PILL   = { t="BRASS3",  f="O_PILL",  sane=1 }
  O_CARVE  = { t="BRASS4",  f="O_CARVE", sane=1 }

  -- FIXME: TEMP HACK!!
  STNGLS1  = { t="GLASS01",  f="F_081" }
}


----------------------------------------------------------------

HEXEN.SKINS =
{
  ----| STARTS |----

  Start_basic =
  {
    _prefab = "START_SPOT"
    _where  = "middle"

    top = "O_BOLT"
  }

  Start_Closet =
  {
    _prefab = "START_CLOSET"
    _where  = "closet"
    _long   = { 192,384 }
    _deep   = { 192,384 }

    step = "F_082"

    door = "DOOR51"
    track = "STEEL08"
    door_h = 128

    special = 11  -- open and stay open
    act = "S1"
    tag = 0
  }


  ----| EXITS |----

  Exit_Pillar =
  {
    _prefab = "EXIT_PILLAR",
    _where  = "middle"

    switch = "SEWER06"
    exit = "PLAT01"
    exitside = "PLAT01"

    special = 74
    act = "S1"
    tag = 0
  }

--[[ TODO
  Exit_Closet_STEEL =
  {
    mat_pri = 9,

    wall = "STEEL01",
    void = "STEEL02",

    floor = "F_022",
    ceil  = "F_044",

    switch = { switch="SW_2_UP", wall="STEEL06", h=64 }

    door = { wall="FIRE14", w=64,  h=128 }
  }
--]]


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

  Lift_Up1 =
  {
    _prefab = "LIFT_UP"
    _where  = "chunk"
    _tags   = 1
    _deltas = { 96,128,160,192 }

    lift = "PLAT02"
     top = "PLAT02"

    walk_kind   = 62
    switch_kind = 62
  }

  Lift_Down1 =
  {
    _prefab = "LIFT_DOWN"
    _where  = "chunk"
    _tags   = 1
    _deltas = { -96,-128,-160,-192 }

    lift = "PLAT02"
     top = "PLAT02"

    walk_kind   = 62
    switch_kind = 62
  }


  ---| PICTURES |---

  Pic_Carve =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "O_CARVE"
    pic_w = 64
    pic_h = 64

    light = 64
  }

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

  Pic_Bolt =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "O_BOLT"
    pic_w = 64
    pic_h = 64

    light = 64
  }

  Pic_DemonCross =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "SPAWN10"
    pic_w = 128
    pic_h = 128

    light = 32
  }

  Pic_DemonFace =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "MONK23"
    pic_w = 128
    pic_h = 128

    light = 32
  }

  Pic_DemonFace2 =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "SPAWN13"
    pic_w = 64
    pic_h = 64

    light = 32
  }

  Pic_DemonFace3 =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "FIRE14"
    pic_w = 64
    pic_h = 56

    y_offset = 40

    light = 32
  }

  Pic_Dragon =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = { MONK09=50, MONK11=50 }
    pic_w = 128
    pic_h = 64

    y_offset = 48

    light = 32
  }

  Pic_Dogs =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "MONK08"
    pic_w = 88
    pic_h = 84

    x_offset = 20
    y_offset = 20

    light = 32
  }

  Pic_SwordGuy =
  {
    _copy = "Pic_Dogs"

    pic = "TOMB06"
  }
  
  Pic_GlassSmall =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = { GLASS01=25, GLASS03=25, GLASS05=25,
			  GLASS02=5,  GLASS04=5,  GLASS06=5 }
    pic_w = 64
    pic_h = 128

    light = 128
  }
  
  Pic_GlassBig = 
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "TOMB03"
    pic_w = 128
    pic_h = 128

    light = 128
  }
  
  Pic_BooksSmall = 
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "BOOKS01"
    pic_w = 64
    pic_h = 128

    light = 32
  }
  
  Pic_BooksBig = 
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "BOOKS02"
    pic_w = 128
    pic_h = 128

    light = 32
  }
  
  Pic_Planets = 
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "PLANET1"
    pic_w = 128
    pic_h = 128

    light = 32
  }
  
  Pic_Grave = 
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = { GRAVE05=25, GRAVE06=25, GRAVE07=25, GRAVE08=25 }
    pic_w = 64
    pic_h = 40

    light = 32
  }

  Pic_Saint =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "WINNOW02"
    pic_w = 96
    pic_h = 128

    x_offset = 16

    light = 32
  }


  ----| ITEMS / KEYS |----

  Pedestal_1 =
  {
    _prefab = "PEDESTAL"
    _where  = "middle"

    top  = "F_084"
    side = "CASTLE07"
  }


--[[ TODO
  pedestal_ITEM =
  {
    prefab = "PEDESTAL",
    skin = { wall="CASTLE07", floor="F_084", ped_h=12 }
  }

  pedestal_PLAYER =
  {
    wall = "T2_STEP", void = "FIRE06",
    floor = "F_062",  ceil = "F_062",  -- TODO: F_061..F_064
    h = 8,
  }

  pedestal_QUEST =
  {
    wall = "T2_STEP", void = "FIRE06",
    floor = "F_042",  ceil = "F_042",
    h = 8,
  }

  pedestal_WEAPON =
  {
    wall = "T2_STEP", void = "FIRE06",
    floor = "F_091",  ceil = "F_091",
    h = 8,
  }
--]]

  Weapon2_Set =
  {
    _prefab = "HEXEN_TRIPLE"
    _where  = "middle"

    side = "CRATE05"
    base = "F_082"

    f_item = "f_axe"
    c_item = "c_staff"
    m_item = "m_cone"
  }

  Weapon3_Set =
  {
    _prefab = "HEXEN_TRIPLE"
    _where  = "middle"

    side = "CRATE05"
    base = "F_082"

    f_item = "f_hammer"
    c_item = "c_fire"
    m_item = "m_blitz"
  }

  Piece1_Set =
  {
    _prefab = "HEXEN_TRIPLE"
    _where  = "middle"

    side = "CRATE05"
    base = "F_082"

    f_item = "f1_hilt"
    c_item = "c1_shaft"
    m_item = "m1_stick"
  }

  Piece2_Set =
  {
    _prefab = "HEXEN_TRIPLE"
    _where  = "middle"

    side = "CRATE05"
    base = "F_082"

    f_item = "f2_cross"
    c_item = "c2_cross"
    m_item = "m2_stub"
  }

  Piece3_Set =
  {
    _prefab = "HEXEN_TRIPLE"
    _where  = "middle"

    side = "CRATE05"
    base = "F_082"

    f_item = "f3_blade"
    c_item = "c3_arc"
    m_item = "m3_skull"
  }


  --- DOORS ---

--[[ TODO
  d_big2   = { prefab="DOOR", w=128, h=128,

               skin =
               {
                 door_w="DOOR51", door_c="F_009",
                 track_w="STEEL08",
                 door_h=128,
               }
             }

  d_big    = { wall="DOOR51",   w=128, h=128 }
  d_brass1 = { wall="BRASS1",   w=128, h=128 }
  d_brass2 = { wall="D_BRASS2", w=64,  h=128 }

  d_wood1  = { wall="D_WD07",   w=128, h=128 }
  d_wood2  = { wall="D_WD08",   w=64,  h=128 }
  d_wood3  = { wall="D_WD10",   w=64,  h=128 }
--]]


  --- LOCKED DOORS ---

  Locked_axe =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "k_axe"
    _tags = 1
    _long = 192
    _deep = 32

    w = 128
    h = 112
    door_h = 112
    door = "D_AXE"
    track = "STEEL08"
    special = 13
    act = "S1"
    keynum = 3
  }

  Locked_cave =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "k_cave"
    _tags = 1
    _long = 192
    _deep = 32

    w = 128
    h = 112
    door_h = 112
    door = "D_CAVE2"
    track = "STEEL08"
    special = 13
    act = "S1"
    keynum = 2
  }

  Locked_castle =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "k_castle"
    _tags = 1
    _long = 192
    _deep = 32

    w = 128
    h = 112
    door_h = 112
    door = "D_CAVE"
    track = "STEEL08"
    special = 13
    act = "S1"
    keynum = 11
  }

  Locked_dungeon =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "k_dungeon"
    _tags = 1
    _long = 192
    _deep = 32

    w = 128
    h = 112
    door_h = 112
    door = "D_DUNGEO"
    track = "STEEL08"
    special = 13
    act = "S1"
    keynum = 6
  }

  Locked_emerald =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "k_emerald"
    _tags = 1
    _long = 192
    _deep = 32

    w = 128
    h = 112
    door_h = 112
    door = "D_CAST"
    track = "STEEL08"
    special = 13
    act = "S1"
    keynum = 5
  }

  Locked_fire =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "k_fire"
    _tags = 1
    _long = 192
    _deep = 32

    w = 128
    h = 112
    door_h = 112
    door = "D_FIRE"
    track = "STEEL08"
    special = 13
    act = "S1"
    keynum = 4
  }

  Locked_horn =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "k_horn"
    _tags = 1
    _long = 192
    _deep = 32

    w = 128
    h = 112
    door_h = 112
    door = "D_WASTE"
    track = "STEEL08"
    special = 13
    act = "S1"
    keynum = 9
  }

  Locked_rusty =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "k_rusty"
    _tags = 1
    _long = 192
    _deep = 32

    w = 128
    h = 112
    door_h = 112
    door = "D_RUST"
    track = "STEEL08"
    special = 13
    act = "S1"
    keynum = 8
  }

  Locked_swamp =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "k_swamp"
    _tags = 1
    _long = 192
    _deep = 32

    w = 128
    h = 112
    door_h = 112
    door = "D_SWAMP2"
    track = "STEEL08"
    special = 13
    act = "S1"
    keynum = 10
  }

  Locked_silver =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "k_silver"
    _tags = 1
    _long = 192
    _deep = 32

    w = 128
    h = 112
    door_h = 112
    door = "D_SLV1"
    track = "STEEL08"
    special = 13
    act = "S1"
    keynum = 7
  }

  Locked_steel =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "k_steel"
    _tags = 1
    _long = 192
    _deep = 32

    w = 128
    h = 112
    door_h = 112
    door = "D_STEEL"
    track = "STEEL08"
    special = 13
    act = "S1"
    keynum = 1
  }


  ----| SWITCHED DOORS |---- 

  Door_SW_1 =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _switches = { sw_demon=1, sw_moon=1 }
    _long = 192
    _deep = 32

    door_w = 128
    door_h = 112

    door = "BRASS1"
    track = "STEEL08"
    special = 0
  }

  Switch_demon =
  {
    _prefab = "SWITCH_TINY"
    _where  = "middle"
    _switch = "sw_demon"

    switch = "SW51_OFF"
    switch_h = 32

    side = "PLAT01"
    base = "WINN01"

    special = 11
    act = "S1"
  }

  Switch_moon =
  {
    _prefab = "SWITCH_TINY"
    _where  = "middle"
    _switch = "sw_moon"

    switch = "SW52_OFF"
    switch_h = 32

    side = "PLAT01"
    base = "WOOD01"

    special = 11
    act = "S1"
  }

--[[ TODO (maybe)
  switch_cow =
  {
    prefab = "SWITCH_NICHE_TINY",
    add_mode = "island",
    skin =
    {
      switch_w="SW_1_UP", wall="STEEL02",
      floor="F_075", ceil="F_075",
      switch_h=48, x_offset=0, y_offset=0,

      kind = { id=11, act="S1", args={"tag", 2 } }
    }
  }

  switch_ball =
  {
    prefab = "SWITCH_NICHE_TINY",
    add_mode = "island",
    skin =
    {
      switch_w="SW53_UP", wall="MONK02",
      floor="F_025", ceil="F_025",
      switch_h=40, x_offset=0, y_offset=0,

      kind = { id=11, act="S1", args={"tag", 2 } }
    }
  }

  switch_sheep =
  {
    prefab = "SWITCH_NICHE_TINY",
    add_mode = "wall",
    skin =
    {
      switch_w="SW_2_UP",
      switch_h=48, x_offset=0, y_offset=0,

      kind = { id=11, act="S1", args={"tag", 2 } }
    }
  }

  switch_chain =
  {
    prefab = "SWITCH_NICHE_HEXEN",
    add_mode = "wall",
    skin =
    {
      switch_w="SW_OL5",
      switch_h=32, x_offset=0, y_offset=0,

      kind = { id=11, act="S1", args={"tag", 2 } }
    }
  }

--]]


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

--    step = "STEP3"
  }

  Hall_Basic_I_Lift =
  {
    _prefab = "HALL_BASIC_I_LIFT"
    _shape  = "IL"
    _tags   = 1

    -- FIXME: this is doom stuff, need Hexen stuff
    lift = "SUPPORT3"
    top  = { STEP_F1=50, STEP_F2=50 }

    raise_W1 = 130
    lower_WR = 88  -- 120
    lower_SR = 62  -- 123
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

    support = "PILLAR01"
    torch_ent = "brass_brazier"
  }

  Sky_Hall_I_Stair =
  {
    _prefab = "SKY_HALL_I_STAIR"
    _shape  = "IS"
    _need_sky = 1

--??    step = "STEP5"
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


  ---| TELEPORTERS |---

  Hub_Gate =
  {
    _prefab = "HEXEN_GATE"
    _where  = "middle"

    frame = "WOOD01"
  }

}


----------------------------------------------------------------


---- MISC STUFF ------------

HEXEN.LIQUIDS =
{
  -- Hexen gets damage from the flat (not a sector special)

  -- water and muck sometimes flow in a direction, but I'll leave that to 
  -- later code development (and a hopefully randomized special adds per sector).
  water  = { mat="X_005", light=168, special=0 },
  muck   = { mat="X_009", light=168, special=0 },
  lava   = { mat="X_001", light=192, special=0, damage=20 },
  
  -- Ice isn't really a liquid, but may be placed like one in some ice levels
  icefloor = { mat="F_033", special=0 },
}


HEXEN.IMAGES =
{
  { wall = "BRASS3", w=128, h=128, glow=true }
  { wall = "BRASS4", w=64,  h=64,  floor="F_016" }
}

HEXEN.LIGHTS =
{
  l1 = { floor="F_081", side="FIRE07" }
  l2 = { floor="F_084", side="FIRE07" }
  l3 = { floor="X_012", side="FIRE07" }
}

HEXEN.WALL_LIGHTS =
{
  fire = { wall="X_FIRE01", w=16 }
}

HEXEN.PICS =
{
  cave12 = { wall = "CAVE12",   w=128, h=128 }
  forest = { wall = "FOREST03", w=128, h=128 }

  mon1 = { wall = "SPAWN10",  w=128, h=128 }
  mon3 = { wall = "SPAWN13",  w=64,  h=64  }

  glass1 = { wall = "GLASS01",  w=64,  h=128 }
  glass3 = { wall = "GLASS03",  w=64,  h=128 }
  glass5 = { wall = "GLASS05",  w=64,  h=128 }
}


HEXEN.THEME_DEFAULTS =
{
  starts = { Start_basic = 20, Start_Closet = 90 }

  exits = { Exit_Pillar = 50 }

  pedestals = { Pedestal_1 = 50 }

  stairs = { Stair_Up1 = 50, Stair_Down1 = 50,
              -- Lift_Up1 = 1,   Lift_Down1 = 1 -- until lifts work in Hexen, BlackJar72
			}

---???  weapon2 = { Weapon2_Set = 50 }
---???  weapon3 = { Weapon3_Set = 50 }

  keys = { k_axe = 50, k_cave = 50, k_castle = 50,
           k_dungeon = 50, k_emerald = 50, k_fire = 20,
           k_horn = 50, k_rusty = 50, k_silver = 50,
           k_swamp = 50, k_steel = 50 }

  hub_keys = { k_axe = 50, k_cave = 50, k_castle = 50,
               k_dungeon = 50, k_emerald = 50, k_fire = 20,
               k_horn = 50, k_rusty = 50, k_silver = 50,
               k_swamp = 50, k_steel = 50 }

  hub_gates = { Hub_Gate = 50 }

  switches = { sw_demon = 50, sw_moon = 40 }

  switch_fabs = { Switch_demon = 50, Switch_moon = 50 }

  locked_doors = { Locked_axe = 50, Locked_cave = 50, Locked_castle = 50,
                   Locked_dungeon = 50, Locked_emerald = 50, Locked_fire = 50,
                   Locked_horn = 50, Locked_rusty = 50, Locked_silver = 50,
                   Locked_swamp = 50, Locked_steel = 50,
                   Door_SW_1 = 50 }

  logos = { Pic_Carve=50, Pic_Bolt=25, Pic_Pill=15 }

  pictures =
  {
    Pic_DemonCross = 40
    Pic_DemonFace = 15
    Pic_DemonFace2 = 10
    Pic_DemonFace3 = 5

    Pic_Dragon = 50
    Pic_Dogs = 20
    Pic_SwordGuy = 30
    Pic_Saint = 30
  }

  mini_halls = { Hall_Basic_I = 50 }

  hallway_groups = { basic = 50 }

  sky_halls = { skier = 50 }

  big_junctions =
  {
    Junc_Octo = 50
  }

  -- TODO everything else
}


HEXEN.NAME_THEMES =
{
  -- these tables provide *additional* words to those in naming.lua

  GOTHIC =
  {
    lexicon =
    {
      a =
      {
        Wooded=30
        Silent=20
        Mysterious=10
        Deathly=10
        Dark=20
        Bright=10
        Luminous=10
        Twilight=10
        Ruined=10
        Abandoned=20
        Guarded=15
        Lost=15
        Secret=10
        Barbarain=5
        Monstrous=15
        Dead=10
        Faerie=10
        Enchanted=5
        Inhuman=5
}

      n =
      {
        Wood=30
        Woods=20
        Forest=10
        Woodland=10
        Seminary=20
        Monestary=10
        Mountain=10
        Catacombs=20
        Keep=15
        Castle=20
        Fortress=15
        Fort=10
        Barbican=5
        Tower=10
        Outpost=15
        Manor=15
        Dungeon=15
        Necropolis=10
        Cavern=20
        Cave=10
        Tomb=25
        Crypt=15
        Barrow=15
        Mound=5
        ["Burial Mound"]=5
        Mere=10
        Mire=15
        Bog=10
        Swamp=10
        Marsh=15
        Desert=5
        Waste=15
        Wasteland=15
        Badlands=10
        Village=20
        Hamlet=15
        City=15
        Settlement=10
        Township=10
        Colony=5
        Town=5
        Encampment=5
        Citadel=10
        Plaza=5
        Square=5
        Kingdom=15
        Stronghold=5
        Palace=20
        Courtyard=10
        Court=10
        Halls=10
        Hollow=20
        Valley=15
        Plateau=10
        Mesa=5
        Sewer=5
        Effluvium=5
        Plane=10
        Dimension=15
        Realm=10
        Portal=10
        Portals=5
      }

      m = {
        -- Duplicated in 'h' since it doesn't seem to do anything yet
        -- Comon Hexen monster
        Ettins=20
        Afriti=20
        Wendigos=5
        ["Chaos Serpents"]=20
        Centaurs=20
        Slaughtars=10
        ["Dark Bishops"]=20
        Reivers=10
        -- Other creatures that work
        Demons=10
        Dragons=5
        Fairies=15
        Elves=5
        Trolls=10
        Nymphs=5
        Satyrs=5
        Ghosts=15
        Shadows=30
        Spirits=25
        ["Evil Spirits"]=10
        Beasts=20
        Animals=5
        Serpents=10
        Humans=2
        ["the People"]=3
        ["the Legion"]=8
        Legionaires=6
        Legions=6
        Magi=20
        Priests=6
        ["the Priesthood"]=10
        Clergy=4
        Barbarians=10
        ["the Wildmen"]=10
        ["the Untaimed"]=10
        Corpses=10
      }

      h = {
        Sorcery=25
        Magic=10
        Mystery=10
        Mysteries=15
        Theurgy=10
        Thaumaturgy=10
        Diablerie=10
        Necromancy=10
        Conjuring=5
        Illusion=10
        Alchemy=5
        Dreams=5
        Dreaming=5
        Nightmares=10
        Darkness=10
        Enchantment=10
        -- Comon Hexen monster
        ["the Ettins"]=20
        ["the Afriti"]=20
        ["the Wendigo"]=5
        ["Chaos Serpents"]=20
        ["the Centaurs"]=20
        ["the Slaughtars"]=10
        ["Dark Bishops"]=20
        ["the Reiver"]=5
        Wraiths=10
        ["the Stalkers"]=5
        -- Other creatures that work
        Demons=15
        Dragons=5
        Fairies=15
        ["the Elves"]=5
        Trolls=10
        ["the Nymphs"]=5
        ["the Satyrs"]=5
        Ghosts=15
        Shadows=30
        Spirits=25
        ["Evil Spirits"]=10
        Beasts=20
        ["the Animals"]=5
        Serpents=10
        ["the Humans"]=2
        ["the People"]=3
        ["the Legion"]=8
        Legionaires=6
        Legions=6
        ["the Magi"]=20
        Priests=6
        ["the Priesthood"]=10
        ["the Clergy"]=4
        Barbarians=10
        ["the Wildmen"]=10
        ["the Untaimed"]=10
        Corpses=10
      }

      e =
      {
        Korax=100
        ["D'Sparil"]=25
        Eidolon=10
        ["the Heresiarch"]=75
        Zedek=30
        Menalkir=30
        Traductus=30
        Circe=5
        Hades=5
		Persephone=5
        Hecate=5
        Medea=1
        Loki=5
        Hel=3
        ["Frau Hoelle"]=2
        ["Black Annis"]=5
        Cerridwen=4
        Morgaina=5
        Anubis=3
        Set=2
      }
    }
  }
  -- TODO more(?)
}


HEXEN.HALLWAY_GROUPS =
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

  skier =
  {
    pieces =
    {
      Sky_Hall_I = 50
      Sky_Hall_C = 50
      Sky_Hall_I_Stair = 50

      Hall_Basic_T = 50  -- use indoor versions for these
      Hall_Basic_P = 50  --

      Hall_Basic_I_Lift = 2   -- TODO: sky version
    }
  }
}


-- TODO / FIXME:  Split-off various special/novelty walls, further split many themes, and
-- remove many excessiv or poorly picked floor/cieling (and a few wall) textures, JB.
HEXEN.ROOM_THEMES =
{
  -- This is the monestary / palacial castle type dungeon

    Dungeon_monktan =
  {
    walls =
    {
      MONK02=40
      MONK03=15
      MONK16=15
    }

    floors =
    {
      F_011=20
      F_014=8
      F_025=15
      F_028=10
      F_029=10
      F_077=10
      F_089=12
    }

    ceilings =
    {
      F_011=20
      F_014=8
      F_025=15
      F_028=10
      F_029=10
      F_092=5
    }
    
    hallways  = { Dungeon_monktan=50 }
  }

    Dungeon_monktan_large =
  {
    walls =
    {
      MONK14=35
      MONK15=15
      MONK16=5
      MONK17=3
      MONK18=2
    }

    floors =
    {
      F_011=20
      F_014=8
      F_025=15
      F_028=10
      F_029=10
      F_077=10
      F_089=12
    }

    ceilings =
    {
      F_011=20
      F_014=8
      F_025=15
      F_028=10
      F_029=10
      F_092=5
    }

    hallways  = { Dungeon_monktan_large=50 }
  }

  Dungeon_monkgray =
  {
    walls =
    {
      MONK01=30
  }

    floors =
    {
      F_009=30
      F_012=40
      F_030=10
      F_031=15
      F_042=8
      F_043=4
      F_048=9
      F_057=5
      F_073=3
      F_089=12
    }

    ceilings =
    {
      F_009=30
      F_012=40
      F_031=25
      F_041=3
      F_042=8
      F_043=4
      F_048=9
      F_057=5
      F_089=12
      F_092=5
    }
    
    hallways  = { Dungeon_monkgray=25, Dungeon_monkrosette=50 }
  }

  Dungeon_monkrosette =
  {
        facades =
  {
      MONK01=35
      MONK07=15
        }

    walls =
    {
      MONK07=35
      MONK08=10
    }

    floors =
    {
      F_031=50
    }

    ceilings =
    {
      F_031=50
    }

    hallways  = { Dungeon_monkgray=25, Dungeon_monkrosette=50 }
  }

  Dungeon_portals1 =
  {
        facades =
        {
      PRTL02=30
      PRTL03=5
        }

    walls =
    {
      PRTL04=40
      PRTL05=25
    }

    floors =
    {
      F_010=25
      F_044=50
      F_089=10
    }

    ceilings =
    {
      F_010=25
      F_044=50
  }

    hallways  = { Dungeon_portals1=50 }
  }

  Dungeon_portals2 =
  {
    walls =
    {
      PRTL02=30
      PRTL03=5
        }

    floors =
    {
      F_010=25
      F_044=50
      F_089=10
    }

    ceilings =
    {
      F_010=25
      F_044=50
    }

    hallways  = { Dungeon_portals2=50 }
  }

  -- This is the dark, dank dungeon type of crumbling castles, cemetaries, 
  -- crypts, sewers, and of course, dungeons.

  Dungeon_tomb1 =
  {
    walls =
    {
      TOMB04=15
      TOMB02=15
      TOMB01=5
      TOMB02=5
      --GRAVE01=2
    }

    floors =
    {
      F_009=10
      F_012=25
      F_013=25
      F_031=5
      F_042=5
      F_043=5
      F_045=5
      F_077=10
      F_089=5
    }

    ceilings =
    {
      F_009=10
      F_012=25
      F_013=25
      F_031=5
      F_042=5
      F_043=5
      F_045=5
      F_077=10
      F_089=5
    }

    hallways  = { Dungeon_tomb1=50 }
    }

  Dungeon_tomb2 =
  {
    walls =
    {
      TOMB05=45
      TOMB06=5
  }

    floors =
  {
      F_046=5
      F_047=5
      F_059=70
      F_077=15
      F_089=5
    }

    ceilings =
    {        
      F_046=5
      F_047=5
      F_059=70
      F_077=15
      F_089=5
    }
    
    hallways  = { Dungeon_tomb2=50 }
  }

  Dungeon_tomb3 =
  {
    walls =
    {
      TOMB07=25
      TOMB11=10
      --GRAVE01=2
    }

    floors =
    {
      F_046=25
      F_047=15
      F_048=10
    }

    ceilings =
    { 
      F_046=25
      F_047=15
      F_048=10
    }
    
    hallways  = { Dungeon_tomb3=50 }
  }

  Dungeon_castle_gray =
  {  

    walls =
    {
      CASTLE07=35
      CAVE02=15
      PRTL03=5
    }

    floors =
    {
      F_009=10
      F_012=10
      F_013=10
      F_015=10
      F_022=10
      F_076=5
    }

    ceilings =
    {
      F_009=10
      F_012=10
      F_013=10
      F_015=10
      F_022=10
      F_076=5
    }

    hallways  = { Dungeon_castle_gray=50 }
  }

  Dungeon_castle_gray_small =
  {
    facades = 
  {
      CASTLE07=35
      CAVE02=15
      PRTL03=5
    }
    
    walls =
    {
      CASTLE01=20
      CAVE07=5
      -- Next, some novelty patterns that should be used rarely
      --CASTLE02=1
      --CASTLE03=1
      --CASTLE06=1
    }

    floors =
    {
      F_008=25
      F_009=10
      F_012=10
      F_013=10
      F_015=10
      F_022=10
      F_076=5
    }

    ceilings =
    {
      F_008=25
      F_009=10
      F_012=10
      F_013=10
      F_015=10
      F_022=10
      F_076=5
    }

    hallways  = { Dungeon_castle_gray_small=50 }
  }

  Dungeon_castle_gray_chains =
  { -- These patterns are pretyy much the same as castle01 (but with chains) -- should the be separate?  JB
        rarity="minor"

        facades =
        {
      CASTLE07=35
      CAVE02=10
      PRTL03=5
        }

    walls =
    {
      CASTLE02=1
      CASTLE03=1
      CASTLE06=1
    }

    floors =
    {
      F_008=25
      F_009=10
      F_012=10
      F_013=10
      F_015=10
      F_022=10
      F_076=5
    }

    ceilings =
    {
      F_008=25
      F_009=10
      F_012=10
      F_013=10
      F_015=10
      F_022=10
      F_076=5
    }
    
    hallways  = { Dungeon_castle_gray_small=50 }
  }

  Dungeon_castle_yellow =
  {    
    walls =
    {
      CASTLE11=25
      CAVE01=10
      WINN01=5
    }

    floors =
    {
      F_011=5
      F_014=35
      F_025=15
      F_028=10
      F_029=10
    }

    ceilings =
  {
      F_011=5
      F_014=35
      F_025=15
      F_028=10
      F_029=10
    }
    
    hallways  = { Dungeon_castle_yellow=50 }
  }

  Dungeon_library =
  {
    facades =
    {
      MONK01=10
      MONK02=10
      CASTLE11=10
        }

    rarity="episode"

    walls =
    { -- When/if prefab bookshelve are available, the walls should usuallty not be books, JB
      --MONK01=10
      --MONK02=10
      --CASTLE11=10
      --WOOD01=25
      --WOOD01=5
      BOOKS01=15
      BOOKS02=10
    }

    floors =
    {
      F_010=15
      F_024=15
      F_030=5
      F_054=15
      F_055=15
      F_089=5
      F_092=15
    }

    ceilings =
    {
      F_010=10
      F_024=10
      F_030=5
      F_054=20
      F_055=20
      F_089=5
      F_092=20
    }
    }

  Dungeon_sewer1 =
    {
    walls =
    {
      SEWER01=25
      SEWER05=5
      SEWER06=5
      SEWER02=1
  }

    floors =
  {
      F_017=10
      F_018=10
      F_021=12
      F_022=15
      F_023=3
    }

    ceilings =
    {
      F_017=10
      F_018=10
      F_021=10
      F_022=10
      F_023=10
    }
    
    hallways  = { Dungeon_sewer1=50 }
  }

  Dungeon_sewer2 =
  {
    walls =
    {
      SEWER07=15
      --SEWER08=15
      SEWER09=1
      SEWER10=1
      SEWER11=1
      SEWER12=1
    }

    floors =
    {
      F_017=10
      F_018=10
      F_021=12
      F_022=15
      F_023=3
    }

    ceilings =
    {
      F_017=10
      F_018=10
      F_021=10
      F_022=10
      F_023=10
    }
    
    hallways  = { Dungeon_sewer2=50 }
  }

  Dungeon_sewer_metal =
  {
    rarity="minor"

    walls =
    {
      STEEL01=25
      STEEL02=5
    }

    floors =
    {
      F_073=10 
      F_074=50
      F_075=25
      F_021=5
    }

    ceilings =
    {
      F_073=10 
      F_074=50
      F_075=25
      F_021=10 
      F_023=10
    }
    
    hallways  = { Dungeon_sewer1=40, Dungeon_sewer2=50 }
  }

  Dungeon_outdoors1 =
  {
    floors =
    {
      F_024=75
      F_034=50
      F_001=10
      F_002=10
      F_004=10
      F_005=10
      F_006=10
      F_007=10
      F_010=2
      F_011=4 
      F_025=3
      F_028=2
      F_029=2
      F_030=2
      F_031=2
      F_046=2
      F_047=2
      F_048=2
      F_057=1
      F_059=2
      F_077=2
      F_089=2
      F_012=2
      F_014=2
    }

    naturals =
    {
      WASTE02=50
      WASTE01=20
      CAVE05=40
    }
  }

  Dungeon_outdoors2 =
  {
    floors =
    {
      F_024=50
      F_034=75
      F_001=10
      F_002=10
      F_004=10
      F_005=10
      F_006=10
      F_007=10
      F_008=2
      F_009=2
      F_012=2
      F_013=2
      F_015=2
      F_017=2
      F_018=2
      F_021=1 
      F_022=2
      F_027=2
      F_030=2 
      F_031=1
      F_038=10
      F_042=1
      F_044=2 
      F_045=1
      F_057=2
      F_058=2
      F_059=2
      F_073=2
      F_076=2
    }

    naturals =
    { 
      WASTE02=30
      FOREST02=10 
    }
  }

  -- This is the element fire, as in "The Guardian or Fire" in Raven's original wad.
  Fire_room1 =
  {
    walls =
    {
      FIRE06=15
      FIRE07=15
      FIRE08=10
      FIRE09=10
      FIRE10=10
      FIRE11=10
      FIRE12=10
    }

    floors =
    {
      F_013=25
      F_032=5
      F_040=4
      F_044=1
      F_082=5
    }

    ceilings =
    {
      F_013=25
      F_032=5
      F_040=4
      F_044=1
      F_082=5
    }

    __corners =
    {
      FIRE01=30
      FIRE04=5
      FIRE05=10
      FIRE06=15 
      FIRE07=15
      FIRE08=10
      FIRE09=10
      FIRE10=10
      FIRE11=10
      FIRE12=10
      X_FIRE01=30
    }

        hallways  = { Fire_room1=50, Fire_room2=25 }
  }

  Fire_room2 =
  {
    walls =
    {
      FIRE01=30
      FIRE04=5
      FIRE05=10
    }

    floors =
    {
      F_032=25
      F_040=5
      F_082=5
    }

    ceilings =
    {
      F_032=25
      F_040=5
      F_082=5
    }

    naturals =
    {
      FIRE01=60
    }

        hallways  = { Fire_room1=15, Fire_room2=65 }
  }


  -- This is the element fire, as in "The Guardian or Fire" in Raven's original wad.
  Fire_lavawalls =
  { -- Fire could be split up, but these textures were pretty mixed up in the
    -- original wads, and it looks good as it is, JB
        rarity="zone"

    walls =
    {
      X_FIRE01=100
    }
    
    floors =
    {
      F_013=25
      F_032=25
      F_040=15
      F_044=5
      F_082=15
    }
    
    ceilings =
    {
      X_001=85
      F_013=25
      F_032=25
      F_040=15
      F_044=5
      F_082=15
    }

    __corners =
    {
      FIRE01=30
      FIRE04=5
      FIRE05=10
      FIRE06=15 
      FIRE07=15
      FIRE08=10
      FIRE09=10
      FIRE10=10
      FIRE11=10
      FIRE12=10
      X_FIRE01=30
    }
    
    hallways = { Fire_room1=50 }
  }

  Fire_outdoors =
  {
    floors =
    {
      F_013=5
      F_032=30
      F_040=25
      F_044=4
      F_082=20
    }

    naturals =
    {
      FIRE01=30
      FIRE04=5
      FIRE05=10
      FIRE06=15
      FIRE07=15
      FIRE08=10
      FIRE09=10
      FIRE10=10
      FIRE11=10
      FIRE12=10
    }
  }

  -- This is the "element" ice
  Ice_room1 =
  {
    walls =
    {
      ICE02=30
      ICE03=5
      ICE06=25
    }
    
    floors =
    {
      F_013=40
      F_040=30
    }

    ceilings =
    {
      F_013=40
      F_040=30
    }

    hallways  = { Ice_room1=50 }
  }

  Ice_room2 =
  { -- Not technically right, but works for what it does ;-) JB
    walls =
    {
      ICE01=15
      ICE02=30
      ICE03=5
      ICE06=25
    }

    floors =
    {
      F_013=20
      F_033=25
      F_040=15
    }

    ceilings =
    {
      F_013=40
      F_033=15
      F_040=30
    }

    hallways  = { Ice_room1=50, Ice_room2=50 }
  }

  Ice_cave =
  {
    naturals =
    {
      ICE01=75
      ICE06=25
    }
  }

  Ice_outdoors =
  {
    floors =
    {
      F_013=15
      F_033=75
      F_040=30
    }

    naturals =
    {
      ICE01=45
      ICE02=30
      ICE03=5
      ICE06=25
    }
  }


  -- This is the "element" steel, as in "The Guardian or Steel" in Raven's original wad.
  Steel_room_mix =
  { -- Not technically right, but works for what it does ;-) JB
        rarity="minor"

    walls =
    {
      STEEL01=40
      STEEL02=10
      STEEL05=1  -- This one should be rare, since also the door texture, JB
      STEEL06=15
      STEEL07=5
      STEEL08=5
    }

    floors =
    {
      F_065=10
      F_066=10
      F_067=10
      F_068=10
      F_069=15
      F_070=15
      F_074=40
      F_075=15
      F_078=10
    }

    ceilings =
    {
      F_065=10
      F_066=10
      F_067=10
      F_068=10
      F_069=15
      F_070=15
      F_074=40
      F_075=15
      F_078=10
  }

    naturals =
    {
      STEEL01=40
      STEEL02=10
      STEEL05=10
      STEEL06=15
      STEEL07=5
      STEEL08=5
    }

    __corners =
    {
      STEEL01=40
      STEEL02=10
      STEEL05=10
      STEEL06=15
      STEEL07=5
      STEEL08=5
    }
    }
    
  Steel_room_gray =
  {
    walls =
  {
      STEEL06=35
      STEEL07=15
      STEEL08=5
    }

    floors =
    {
      F_065=10
      F_066=10
      F_067=10
      F_068=10
      F_069=15
      F_070=15
      F_078=10
    }

    ceilings =
    {
      F_065=10
      F_066=10
      F_067=10
      F_068=10
      F_069=15
      F_070=15
      F_078=10
    }

    naturals =
    {
      STEEL06=35
      STEEL07=15
      STEEL08=5
    }
  }

  Steel_room_rust =
  {
    walls =
    {
      STEEL01=40
      STEEL02=10
    }

    floors =
    {
      F_074=40
      F_075=15
    }

    ceilings =
    {
      F_074=40
      F_075=15
    }

    naturals =
    {
      STEEL01=40
      STEEL02=10
    }
    }

  -- This is the barren, deserty wildness, based on "The Wasteland" in Raven's original wad.
  Desert_room_stone =
  {
        facades =
    {
      FOREST01=10
      MONK16=25
    }

    walls =
    {
      WASTE04=10
      FOREST01=10
      MONK16=25
    }
    
    floors =
    {
      F_002=10
      F_003=10
      F_004=5
      F_037=20
      F_029=20
      F_044=15
      F_082=10
  }

    ceilings =
  {
      F_037=20
      F_029=20
      F_044=15
      F_082=10
      D_END3=27
      D_END4=3
    }
  }

  Desert_outdoors =
  {
    floors =
    {
      F_002=25
      F_003=25
      F_004=10
      F_005=5
      F_037=20
    }

    naturals =
    {
      WASTE01=35
      WASTE02=15
      WASTE04=10
      WASTE03=5
    }
  }

  -- This is the cave type wildness; also, many caves used elsewhere;
  -- most caves have floor, ceiling, and walls so that they can double
  -- in other cave-ish roles. JB
  Cave_room =
  { -- These are built rooms for the cave level (the rest are naturals of some kind)
    walls =
    {
      CAVE01=30
      CAVE02=30
      CAVE07=25
    }

    floors =
    {
      F_039=75
      F_040=40
      F_073=10
      F_076=15
    }

    ceilings =
    {
      F_039=75
      F_040=40
      F_073=10
      F_076=15
  }

    __corners =
    { 
      PILLAR01=20
      WOOD01=15
      WOOD03=15
      D_END3=50
      D_END4=5
    }

    hallways  = { Cave_gray=50, Cave_room=50 }
  }

  Cave_gray =
  {
    facades =
    { 
      CAVE03=10
    }
    
    walls =
    { 
      CAVE03=10
      CAVE04=55
      WASTE02=15
    }

    floors =
    {
      F_039=75
      F_040=40
    }

    ceilings =
    {
      F_039=75
      F_040=40
    }

    naturals =
    { 
      CAVE03=10
      CAVE04=55
      WASTE02=15
    }
    
    hallways  = { Cave_gray=50 }
  }

  Cave_stalag =
  {
        facades =
        {
      CAVE03=10
        }

    walls =
    {
      CAVE06=60
    }

    floors =
    {
      F_039=75
      F_040=40
    }

    ceilings =
    {
      F_039=75
      F_040=40
    }

    naturals =
    {
      CAVE06=60
    }

        hallways  = { Cave_gray=50, Cave_stalag=50 }
  }

  Cave_brown =
  {
    walls =
    {        
      CAVE05=60
  }

    floors =
    {
      F_001=75
      F_002=40
    }

    ceilings =
    {        
      F_001=75
      F_002=40
  }

    naturals =
    { 
      CAVE03=20
      CAVE05=60
    }

    hallways  = { Cave_brown=50 }
  }

  Cave_green =
  {
    walls =
    {
      FOREST02=25
    }

    floors =
    {
      F_001=15
      F_002=10
      F_038=75
    }

    ceilings =
    {
      F_001=15
      F_002=10
      F_038=75
    }

    naturals =
    {
      FOREST02=25
    }
    
    hallways  = { Cave_green=50 }
  }

  Cave_swamp =
  {
    walls =
    {
      SWAMP01=20
      SWAMP03=20  
    }

    floors =
    {
      F_019=75
      F_020=40
      F_039=25
      F_040=20
  }

    ceilings =
  {
      F_019=75
      F_020=40
      F_039=25
      F_040=20
    }

    naturals =
    {
      SWAMP01=20
      SWAMP03=20  
    }
    
    hallways  = { Cave_swamp=50 }
  }

  Cave_desert_tan =
  {
    walls =
    {
      WASTE01=35
    }

    floors =
    {
      F_003=75
      F_002=40
      F_004=10
      F_037=25
    }

    ceilings =
    {
      F_003=75
      F_002=40
  }

    naturals =
    {
      WASTE01=35
      WASTE04=10
    }

    hallways  = { Cave_desert_tan=50 }
  }

  Cave_desert_gray =
  {
    walls =
    {
      WASTE02=30
    }

    floors =
    {
      F_039=75
      F_040=40
    }

    ceilings =
    {
      F_039=75
      F_040=40
    }

    naturals =
    {
      WASTE02=30
      WASTE03=5
    }
    
    hallways  = { Cave_desert_gray=50 }
  }

  Cave_outdoors =
  {
    floors =
  {
      F_007=10
      F_039=75
      F_040=40
      F_073=10
      F_076=10
    }

    naturals =
    {
      CAVE03=70
    }
  }


  -- This is the swamp-type wilderness
  Swamp1_castle =
  {
    walls =
  {
      SWAMP01=30
      SWAMP03=30
      SWAMP04=30
      -- This should probably be a separate theme, but seems to work best this way, JB
      FOREST07=10
    }

    floors =
    {
      F_017=10
      F_018=10
      F_019=20
      F_020=15
      F_054=5
      F_055=5
      F_092=5
    }

    ceilings =
    {
      F_017=10
      F_018=10
      F_019=20
      F_020=15
      F_054=5
      F_055=5
      F_092=5
    }
    
    hallways  = { Swamp1_castle=50 }
  }

  Swamp1_hut =
  {
    walls =
    {
      VILL01=5
      VILL04=25
      VILL05=25
      WOOD01=5
      WOOD02=5
      WOOD03=15
    }

    floors =
    {
      F_054=10
      F_055=10
      F_092=10
    }

    ceilings =
    {
      F_054=10
      F_055=10
      F_092=10
    }
    
    hallways  = { Swamp1_hut=50 }
  }

  Swamp1_outdoors =
  {
    floors =
    {
      F_017=5
      F_018=5
      F_019=10
      F_020=10
      F_054=1
      F_055=1
      F_092=1
      F_005=10
      F_006=10
      F_007=5
  }

    naturals =
    {
      SWAMP01=20
      SWAMP03=20
      SWAMP04=20
      FOREST07=10
      CAVE03=10
      CAVE04=10
      CAVE05=10
      CAVE06=10
      WASTE02=5
    }
  }


  -- This is the woodland wilderness found in The Shadow Wood and Winnowing Hall;
  Forest_room1 =
  {
    walls =
    {
      FOREST01=40
    }

    floors =
    {
      F_010=25
      F_011=25
      F_030=15
      F_077=10
      F_089=25
    }

    ceilings =
    {
      F_010=25
      F_011=25
      F_030=15
      F_089=10
    }

    __corners =
    {
      FOREST10=20
      WOOD01=15
      WOOD03=3
    }
    
    hallways  = { Forest_room1=50 }
  }

  Forest_room2 =
  {
    facades = 
    {
      FOREST01=40
      FOREST02=10    
  }

    walls =
  {
      FOREST02=40
      FOREST03=10
      FOREST04=10
    }

    floors =
    {
      F_038=25
      F_048=25
      F_089=25
    }

    ceilings =
    {
      F_038=25
    }

    __corners =
    {
      FOREST10=20
      WOOD01=15
      WOOD03=3
    }
    
    hallways  = { Forest_room2=50 }
  }

  Forest_room3 =
  {
    facades = 
  {
      FOREST01=10
      WINN01=40    
    }
    
    walls =
    {
      FOREST10=40
      WINN01=10
    }

    floors =
    {
      F_073=25
      F_077=20
      F_089=25
    }

    ceilings =
    {
      F_073=25
    }

    __corners =
    {
      FOREST10=20
      WOOD01=15
      WOOD03=3
  }
    
    hallways  = { Forest_room3=50 }
}

  Forest_outdoors =
  {
    floors =
    {
      F_005=15
      F_006=25
      F_007=60
    }

    naturals =
    {
      FOREST01=25
      FOREST02=25
      FOREST07=35
      CAVE05=40
      CAVE03=50
    }
  }

  Village_room =
  {
    walls =
    {
      WOOD01=5
      VILL04=10
      VILL05=10
    }

    floors =
    {
      F_002=10
      F_003=10
      F_004=5
      F_037=10
      F_028=20
      F_029=20
      F_054=20
      F_055=20
    }

    ceilings =
    {
      F_037=10
      F_028=20
      F_029=20
      F_054=20
      F_055=20
    }
  }

  Village_brick =
  {
    walls =
    {
      VILL01=5
    }

    floors =
    {
      F_002=10
      F_003=10
      F_004=5
      F_030=30
      F_028=10
      F_029=10
      F_054=10
      F_055=10
    }

    ceilings =
    {
      F_030=30
      F_028=20
      F_029=20
      F_054=20
      F_055=20
    }
  }
}  

HEXEN.LEVEL_THEMES =
{
  hexen_dungeon1 =
  {
    prob = 50

    buildings = { Dungeon_monktan=40, Dungeon_monktan_large=20,
                  Dungeon_monkgray=30, Dungeon_monkrosette=15,
                }
    caves     = { Cave_gray=50 }
    outdoors  = { Dungeon_outdoors1=50 }
    hallways  = { Dungeon_monktan=40, Dungeon_monktan_large=20,
                  Dungeon_monkgray=30, Dungeon_monkrosette=15 }

    pictures =
    {
      Pic_GlassSmall=65
	  Pic_GlassBig=10
	  Pic_BooksSmall=10
	  Pic_BooksBig=10
	  Pic_Planets=5
	  Pic_Saint=10
	  Pic_Dogs=15
	  Pic_Dragon=15 
      Pic_DemonFace2=10
      Pic_DemonFace=10
    }

    -- FIXME: other stuff

    style_list =
    {
      mon_variety = { none=1, few=65, some=30, heaps=4 }               
    }

    monster_prefs =
    {
      bishop=3.0, centaur1=2.0, centaur2=1.5
    }

  }


  -- Castle type dungeon
  hexen_dungeon2 =
  {
    prob = 50

    liquids = { water=25, muck=70, icefloor=5 }
  
    buildings = { Dungeon_castle_gray=30,  Dungeon_castle_gray_small= 15,
                  Dungeon_castle_gray_chains=5, Dungeon_castle_yellow=15,
                }
    caves     = { Cave_gray=30, Cave_swamp=5, Cave_green=15 }
    outdoors  = { Dungeon_outdoors2=50 }
    hallways  = { Dungeon_castle_gray=30,  Dungeon_castle_gray_small= 15,
                  Dungeon_castle_yellow=15 }

    facades =
    {
      CASTLE07=50, CASTLE11=10, CAVE01=10, 
      CAVE02=15, PRTL03=10
    }
	
    pictures =
    {
      Pic_GlassSmall=5
	  Pic_BooksSmall=5
	  Pic_BooksBig=5
	  Pic_Saint=10
	  Pic_Dogs=15
	  Pic_Dragon=15 
      Pic_DemonFace2=15
      Pic_SwordGuy=25
    }

    -- FIXME: other stuff

    monster_prefs =
    {
      centaur1=2.0, centaur2=3.0, demon1=3.0
    }

    style_list =
    {
      caves = { none=30, few=70, some=20,  heaps=0 }
      outdoors = { none=50, few=50, some=20,  heaps=0 }
      mon_variety = { none=1, few=65, some=30, heaps=4 }               
    }
  }
  

  -- Tombs / necropolis
  hexen_dungeon3 =
  {
    prob = 30

    liquids = { water=25, muck=25, icefloor=25, lava=25 }
  
    buildings = { Dungeon_tomb1=10, Dungeon_tomb2=10, Dungeon_tomb3=10 }
    caves     = { Cave_gray=50, Cave_swamp=10, Cave_green=5 }
    outdoors  = { Dungeon_outdoors2=50 }
    hallways  = { Dungeon_tomb1=10, Dungeon_tomb2=10, Dungeon_tomb3=10 }
  
    	
    pictures =
    {
      Pic_GlassSmall=25
      Pic_GlassBig=50
	  Pic_Saint=25
	  Pic_Dogs=15
      Pic_DemonFace2=25
      Pic_DemonCross=5
      Pic_Grave=60
	  
    }

    -- FIXME: other stuff

    monster_prefs =
    {
      bishop=3.0, centaur2=3.0, reiver=2.5
    }

    style_list =
    {
      caves = { none=30, few=70, some=20,  heaps=0 }
      outdoors = { none=50, few=50, some=20,  heaps=0 }
      mon_variety = { none=1, few=65, some=30, heaps=4 }               
    }
  }

  -- Sewers / effluvium
  hexen_dungeon4 =
  {
    prob = 20

    liquids = { muck=70 }
  
    buildings = { Dungeon_sewer1=30, Dungeon_sewer2=20, 
                  Dungeon_sewer_metal=5 }
    caves     = { Cave_gray=25, Cave_swamp=25 }
    outdoors  = { Dungeon_outdoors2=50 }
    hallways  = { Dungeon_sewer1=30, Dungeon_sewer2=20 }
	
    pictures =
    {
      Pic_DemonFace2=90
      Pic_DemonCross=5
      Pic_DemonFace3=5
    }

    facades =
    {
      CASTLE07=50, CASTLE11=10, CAVE01=10,
      CAVE02=15, PRTL03=10
    }
  
    monster_prefs =
    {
      -- need high values just to make them appear
      serpent1=5000, serpent2=3000
    }

    style_list =
    {
      liquids  = { none=0,  few=0,  some=0,   heaps=100 }
      caves    = { none=30, few=70, some=20,  heaps=0   }
      outdoors = { none=50, few=50, some=20,  heaps=0 }
    }
  }

  hexen_dungeon5 =
  {
    prob = 20

    buildings = { Dungeon_portals1=45, Dungeon_portals2=15 }
    caves     = { Cave_gray=50 }
    outdoors  = { Dungeon_outdoors1=50 }
    hallways  = { Dungeon_portals1=45, Dungeon_portals2=15 }
	
    pictures =
    {
      Pic_DemonFace2=20
      Pic_DemonCross=5
      Pic_DemonFace3=5
      Pic_Dogs=10
      Pic_Saint=10
    }

    -- FIXME: other stuff

    monster_prefs =
    {
      ettin=3.0, demon1=2.0, centaur1=1.5, iceguy=3.0
    }
  }

  -- Hypostyle
  hexen_dungeon6 =
  {
    prob = 10

    liquids = { lava=95, icefloor=5 }

    buildings = { Dungeon_castle_gray=5,  Fire_room1=5,
                  Forest_room3=45, Dungeon_tomb3=5 }
    caves     = { Cave_gray=55, Cave_stalag=25, Fire_room1=10 }
    outdoors  = { Dungeon_outdoors2=50 }
    hallways  = { Dungeon_castle_gray=5,  Fire_room1=5,
                  Forest_room3=45, Dungeon_tomb3=5 }
	
    pictures =
    {
      Pic_GlassSmall=5
	  Pic_BooksSmall=5
	  Pic_BooksBig=5
	  Pic_Saint=10
	  Pic_Dogs=15
	  Pic_Dragon=15 
      Pic_DemonFace2=25
      Pic_SwordGuy=5
    }

    facades =
    {
      CASTLE07=50, CASTLE11=10, CAVE01=10,
      CAVE02=15, PRTL03=10
    }

    -- FIXME: other stuff

    monster_prefs =
    {
      afrit=2.0, centaur1=3.0, demon1=3.0, afrit=3.0
    }

    style_list =
    {
      caves = { none=20, few=70, some=30,  heaps=0 }
      outdoors = { none=100, few=0, some=0,  heaps=0 }
    }
  }
  

  hexen_element1 =
  {
    prob = 20

    liquids = { lava=100 }

    buildings = { Fire_room1=65,  Fire_room2=35,  Fire_lavawalls=5}
    caves     = { Fire_room2=50 }
    outdoors  = { Fire_outdoors=50 }
    hallways  = { Fire_room1=50, Fire_room2=40 }
	
    pictures =
    {
	  Pic_DemonFace3=65
      Pic_DemonCross=40
	  Pic_Saint=5
	  Pic_Dogs=5
      Pic_DemonFace2=5
    }

    __big_pillars = { pillar02=10, fire06=25, xfire=15 }

    __outer_fences = 
    {
      FIRE01=30, FIRE04=5, FIRE05=10, FIRE06=15, 
      FIRE07=15, FIRE08=10, FIRE09=10, FIRE10=10, 
      FIRE11=10, FIRE12=10
    }

    monster_prefs =
    {
      afrit=3.5
    }

    style_list =
    {
      caves = { none=30, few=70,  some=30,  heaps=0  }
      outdoors = { none=70, few=5,   some=0,   heaps=0  }
      liquids  = { none=0,  few=10,  some=60,  heaps=40 }
      lakes    = { none=0,  few=10,  some=60,  heaps=40 }
      mon_variety = { none=1, few=65, some=30, heaps=4 }               
    }
  }
  

  hexen_element2 =
  {
    prob = 20

    liquids = { icefloor=100 } -- ice1 will use "liquids = { ice=70, water=30 }" instead, for variety.
  
    buildings = { Ice_room1=65, Ice_room2=35 }
    caves     = { Ice_cave=50 }
    outdoors  = { Ice_outdoors=50 }
    hallways  = { Ice_room1=65, Ice_room2=35 }
	
    pictures =
    {
	  Pic_DemonFace2=65
	  Pic_DemonFace3=5
	  Pic_Dogs=5
      Pic_Saint=25
    }

    __big_pillars = { ice01=5, ice02=20 }

    __outer_fences = 
    {
      ICE01=25, ICE06=75
    }

    style_list =
    {
      caves = { none=30, few=70,  some=30,  heaps=0  }
      outdoors = { none=70, few=5,   some=0,   heaps=0  }
      liquids  = { none=0,  few=10,  some=60,  heaps=40 }
      lakes    = { none=0,  few=0,   some=40,  heaps=60 }
      pictures = { none=50, few=10,  some=10,  heaps=0  }
      mon_variety = { none=1, few=65, some=30, heaps=4 }               
    }
  
    monster_prefs =
    {
      iceguy =500, afrit=0.2
    }
  }
  
    
  hexen_element3 =
  {
    prob = 20

    square_caves = true

    liquids = { lava=20, icefloor=10, water=5, muck=5 }

    buildings = { Steel_room_mix=10, Steel_room_gray=35, Steel_room_rust=25 }
    caves     = { Steel_room_mix=25, Steel_room_gray=25, Steel_room_rust=25 }
    outdoors  = { Steel_room_mix=25, Steel_room_gray=25, Steel_room_rust=25 }
    hallways  = { Steel_room_mix=10, Steel_room_gray=35, Steel_room_rust=25 }
	
    pictures =
    {
	  Pic_Dragon=5
      Pic_DemonCross=45
    }

    __big_pillars = { steel01=10, steel02=10, steel06=10, steel07=10 }

    __outer_fences = 
    {
      STEEL01=40, STEEL02=10, STEEL05=10, 
      STEEL06=15, STEEL07=5, STEEL08=5
    }

    style_list =
    {
      caves = { none=70, few=30,  some=5,  heaps=0 }
      outdoors = { none=70, few=5,   some=0,  heaps=0 }
      liquids  = { none=40, few=60,  some=10, heaps=0 }
      lakes    = { none=60, few=40,  some=0,  heaps=0 } -- I don't think this is need, but to be safe...
      pictures = { none=50, few=0,   some=0,  heaps=0 }
    }
  }
  
    
  hexen_wild1 =
  {
    prob = 30

    liquids = { water=30, muck=40, lava=20 }

    buildings = { Desert_room_stone=25, Cave_desert_tan=20,
                  Cave_desert_gray=15, Village_room=25 }
    caves     = { Cave_desert_tan=60, Cave_desert_gray=40,  
                  Cave_brown=25 }
    outdoors  = { Desert_outdoors=50 }
    hallways  = { Cave_desert_tan=55, Cave_desert_gray=40 }
	
    pictures =
    {
	  Pic_DemonFace=4
	  Pic_BooksSmall=1
      Pic_DemonFace2=10
	  Pic_Dogs=5
	  Pic_Saint=5
    }

    __pictures =
    {
      pic_forest11=5, pic_books01=1, pic_tomb06=15, 
      pic_monk06=2, pic_monk11=2, pic_spawn13=2
    }

    __big_pillars = { pillar01=5, monk14=25 }

    __outer_fences = 
    {
      WASTE01=35, WASTE02=15
    }

    style_list =
    {
      outdoors = { none=0,  few=0,  some=80,  heaps=20 }
      liquids  = { none=30, few=70, some=5,   heaps=0  }
      lakes    = { none=10, few=70, some=10,  heaps=0  }
  --  I have an idea for a natural-net dividing a large natural into small ones connected by tunnels, 
  --  but this doesn't exist and I can't create it now, so...
  --   This is the wrong type of hallway, but best I can do now.
  --  hallways = { none=0,  few=10, some=30, heaps=90 }    
    }
  }
  
  
  hexen_wild2 =
  {
    prob = 30

    liquids = { water=60, muck=10, lava=25 }

    --Not sure I like mixing the gray and brown cave themes too much, JB
    buildings = { Cave_room=50, Cave_gray=15, Cave_brown=5 }
    caves     = { Cave_gray=20, Cave_stalag=30, Cave_brown=10 }
    outdoors  = { Cave_outdoors=50 }
    hallways  = { Cave_gray=30, Cave_stalag=20, Cave_brown=10 }
	
    pictures =
    {
	  Pic_DemonFace=4
	  Pic_DemonCross=1
      Pic_DemonFace2=10
	  Pic_DemonFace3=5
	  Pic_Dogs=5
	  Pic_Saint=5
    }

    __big_pillars =
    { 
      monk14=10, castle07=5, prtl02=5, fire06=10
    }

    __outer_fences = { CAVE03=20, CAVE04=40, CAVE05=15, WASTE02=25 }

    style_list =
    {
      caves      = { none=0,  few=0,  some=0,  heaps=70 }      
      odd_shapes = { none=0,  few=0,  some=30, heaps=70 }
      outdoors = { none=30, few=70, some=5,  heaps=0  }
      crates   = { none=60, few=40, some=0,  heaps=0  }
    }
  
    monster_prefs =
    {
      demon1=3.0, demon2=3.0
    }

    door_probs   = { out_diff=10, combo_diff= 3, normal=1 }
    window_probs = { out_diff=30, combo_diff=30, normal=5 }
  }

  
  hexen_wild3 =
  {
    prob = 30

    liquids = { muck=100 }  -- for whole mulit-level swamp1 theme this will be "liquids = { muck=80, water 20 }"
  
    buildings = { Swamp1_castle=20, Dungeon_castle_gray=20, Swamp1_hut=60 }
    caves     = { Cave_swamp=20, Cave_gray=30 }
    outdoors  = { Swamp1_outdoors=50 }
    hallways  = { Swamp1_castle=20, Dungeon_castle_gray=20, Swamp1_hut=60 }
	
    pictures =
    {
	  Pic_DemonFace=2
	  Pic_BooksSmall=1
      Pic_DemonFace2=25
      Pic_DemonFace3=7
	  Pic_Dogs=5
	  Pic_Saint=5
    }

    __big_pillars =
    { 
      swamp01=20, swamp02=20, vill01=5, wood03=15
    }

    __outer_fences = 
    {
      SWAMP01=20, SWAMP03=20, SWAMP04=20, FOREST07=10,            
      CAVE03=10, CAVE04=10, CAVE05=10, CAVE06=10, 
      WASTE02=5
    }

    style_list =
    {
      caves = { none=0, few=5, some=80, heaps=10  }
      outdoors = { none=0, few=5, some=80, heaps=10  }
  --   I had considered including flat x_09 (muck) as a floor texture, and not using
  --  liquids, but realized this would likely produce diases of muck, ect.  We need 
  --  officially transversable liquids for this theme to really work.  
      liquids  = { none=0, few=0, some=0,  heaps=100 }
      lakes    = { none=0, few=0, some=0,  heaps=100 }
      mon_variety = { none=1, few=65, some=30, heaps=4 }               
    }
  
    monster_prefs =
    {
      -- need high values just to make them appear
      serpent1=5000, serpent2=3000
    }
  }

  
  hexen_wild4 =
  {
    prob = 30

    liquids = { water=60, muck=15, lava=10 }
  
    buildings = { Forest_room1=30, Forest_room2=20, Forest_room3=30 }
    caves     = { Cave_gray=30, Cave_green=25, Cave_brown=40 }
    outdoors  = { Forest_outdoors=50 }
    hallways  = { Forest_room3=30, Forest_room2=20, Forest_room3=30 }
	
    pictures =
    {
	  Pic_DemonFace=4
	  Pic_BooksSmall=1
      Pic_DemonFace2=10
	  Pic_GlassSmall=5
	  Pic_Dogs=5
	  Pic_Saint=5
    }

    __big_pillars =
    { 
      vill01=5, wood01=15, wood02=5, forest01=25,
      pillar01=10, pillar02=5, prtl02=20, monk15=10,
      castle07=5
    }
  
    style_list =
    {
      caves      = { none=0, few=5,  some=50, heaps=10 }
      outdoors   = { none=0, few=5,  some=50, heaps=10 }
      subrooms   = { none=0, few=15, some=50, heaps=50 }
      islands    = { none=0, few=15, some=50, heaps=50 }
    }
  
    monster_prefs =
    {
      afrit=3.0, etin=2.5, bishop=1.5
    }
  }
    
  
  hexen_cave1 =
  {
    prob = 20

    liquids = { water=60, muck=10, lava=25 }

    --Not sure I like mixing the gray and brown cave themes too much, JB
    buildings = { Cave_room=50, Cave_gray=15, Cave_brown=5 }
    caves     = { Cave_gray=20, Cave_stalag=30, Cave_brown=10 }
    outdoors  = { Cave_outdoors=50 }
    hallways  = { Cave_gray=30, Cave_stalag=20, Cave_brown=10 }
	
    pictures =
    {
	  Pic_DemonFace=4
	  Pic_DemonCross=1
      Pic_DemonFace2=10
	  Pic_DemonFace3=5
	  Pic_Dogs=5
	  Pic_Saint=5
    }

    __big_pillars =
    { 
      monk14=10, castle07=5, prtl02=5, fire06=10
    }

    __outer_fences = { CAVE03=20, CAVE04=40, CAVE05=15, WASTE02=25 }

    style_list =
    {
      caves      = { none=0,  few=0,  some=0,  heaps=70 }      
      odd_shapes = { none=0,  few=0,  some=30, heaps=70 }
      outdoors = { none=30, few=70, some=5,  heaps=0  }
      crates   = { none=60, few=40, some=0,  heaps=0  }
      mon_variety = { none=1, few=65, some=30, heaps=4 }               
    }
  
    monster_prefs =
    {
      demon1=3.0, demon2=3.0
    }

    door_probs   = { out_diff=10, combo_diff= 3, normal=1 }
    window_probs = { out_diff=30, combo_diff=30, normal=5 }
  }
  

  hexen_ice1 =
  {
    prob = 20

    liquids = { icefloor=70, water=30 }
  
    buildings = { Ice_room1=65, Ice_room2=35 }
    caves     = { Ice_cave=50 }
    outdoors  = { Ice_outdoors=50 }
    hallways  = { Ice_room1=65, Ice_room2=35 }
	
    pictures =
    {
	  Pic_Dragon=5
      Pic_DemonCross=15
    }

    __big_pillars = { ice01=5, ice02=20 }

    __outer_fences = 
    {
      ICE01=25, ICE06=75
    }

    style_list =
    {
      caves = { none=30, few=70,  some=30,  heaps=0  }
      outdoors = { none=70, few=5,   some=0,   heaps=0  }
      liquids  = { none=0,  few=10,  some=60,  heaps=40 }
      lakes    = { none=0,  few=0,   some=40,  heaps=60 }
      pictures = { none=50, few=10,  some=10,  heaps=0  }
      mon_variety = { none=1, few=65, some=30, heaps=4 }               
    }
  
    monster_prefs =
    {
      iceguy=500, afrit=0.2
    }
  }

  
  hexen_swamp1 =
  {
    prob = 20

    liquids = { muck=80, water=20 }
  
    buildings = { Swamp1_castle=20, Dungeon_castle_gray=20, Swamp1_hut=60  }
    caves     = { Cave_swamp=20, Cave_gray=30 }
    outdoors  = { Swamp1_outdoors=50 }
    hallways  = { Swamp1_castle=20, Dungeon_castle_gray=20, Swamp1_hut=60  }
	
    pictures =
    {
	  Pic_DemonFace=2
	  Pic_BooksSmall=1
      Pic_DemonFace2=25
      Pic_DemonFace3=7
	  Pic_Dogs=5
	  Pic_Saint=5
    }

    __big_pillars = { swamp01=20, swamp02=20, vill01=5, wood03=15 }

    __outer_fences = 
    {
      SWAMP01=20, SWAMP03=20, SWAMP04=20, FOREST07=10,            
      CAVE03=10, CAVE04=10, CAVE05=10, CAVE06=10, 
      WASTE02=5
    }

    style_list =
    {
      caves = { none=0, few=5, some=80, heaps=10  }
      outdoors = { none=0, few=5, some=80, heaps=10  }
  --   I had considered including flat x_09 (muck) as a floor texture, and not using
  --  liquids, but realized this would likely produce diases of muck, ect.  We need 
  --  officially transversable liquids for this theme to really work.  
      liquids  = { none=0, few=0, some=0,  heaps=100 }
      lakes    = { none=0, few=0, some=0,  heaps=100 }
      mon_variety = { none=1, few=65, some=30, heaps=4 }               
    }
  
    monster_prefs =
    {
      -- need high values just to make them appear
      serpent1=5000, serpent2=3000
    }
  }

  hexen_village1 =
  {
    prob = 30

    liquids = { water=60, muck=15, lava=10 }
  
    buildings = { Forest_room1=30, Forest_room2=20, Forest_room3=30,
                  Desert_room_stone=25, Village_room=45, Village_brick=25,
                  Dungeon_castle_gray=15 }
    caves     = { Cave_gray=30, Cave_green=25, Cave_brown=40 }
    outdoors  = { Forest_outdoors=50 }
    hallways  = { Forest_room3=30, Forest_room2=20, Forest_room3=30,
                  Desert_room_stone=25, Village_room=45,
                  Dungeon_castle_gray=15 }
	
    pictures =
    {
	  Pic_DemonFace=5
	  Pic_BooksSmall=10
	  Pic_BooksBig=10
      Pic_DemonFace2=10
      Pic_GlassSmall=15
	  Pic_GlassBig=10
	  Pic_Dogs=5
	  Pic_Saint=5
	  Pic_Dragon=5 
      Pic_SwordGuy=5
    }

    __big_pillars =
    {
      vill01=5, wood01=15, wood02=5, forest01=25,
      pillar01=10, pillar02=5, prtl02=20, monk15=10,
      castle07=5
    }

    style_list =
    {
      caves      = { none=0, few=5,  some=50, heaps=10 }
      outdoors   = { none=0, few=5,  some=50, heaps=10 }
      subrooms   = { none=0, few=15, some=50, heaps=50 }
      islands    = { none=0, few=15, some=50, heaps=50 }
    }

    monster_prefs =
    {
      afrit=3.0, etin=2.5, bishop=1.5
    }
  }
}


HEXEN.WALL_PREFABS =
{
  solid_SEWER02 =
  {
    prefab = "SOLID", skin = { wall="SEWER02" }
  }

  solid_SEWER10 =
  {
    prefab = "SOLID", skin = { wall="SEWER10" }
  }
}


HEXEN.MISC_PREFABS =
{
  -- Note: pedestal_PLAYER intentionally omitted

  image_1 =
  {
    prefab = "CRATE",
    add_mode = "island",
    skin = { crate_h=64, crate_w="BRASS4", crate_f="F_044" }
  }

  arch_arched =
  {
    prefab = "ARCH_ARCHED", skin = {}
  }

  arch_hole =
  {
    prefab = "ARCH_HOLE1", skin = {}
  }

  image_2 =
  {
    prefab = "WALL_PIC_SHALLOW",
    add_mode = "wall",
    min_height = 144,
    skin = { pic_w="BRASS3", pic_h=128 }
  }

  secret_DOOR =
  {
    w=128, h=128, prefab = "DOOR",

    skin =
    {
      door_h=128,
      door_kind = { id=11, act="S1", args={0, 16, 64} }
      tag=0,
    }
  }

  gate_FORWARD =
  {
    prefab = "HEXEN_V_TELEPORT",

    skin =
    {
      frame_w="WOOD01", frame_f="F_054", frame_c="F_054",
      telep_w="TPORT1", border_w="TPORTX",
      tag=0,
    }
  }

  gate_BACK =
  {
    prefab = "HEXEN_V_TELEPORT",

    skin =
    {
      frame_w="FOREST05", frame_f="F_048", frame_c="F_048",
      telep_w="TPORT1", border_w="TPORTX",
      tag=0,
    }
  }
}


HEXEN.SCENERY_PREFABS =
{
  pillar_rnd_PILLAR01 =
  {
    prefab = "PILLAR_ROUND_SMALL",
    add_mode = "island",
    environment = "indoor",

    skin = { wall="PILLAR01" }
  }

  pillar_rnd_PILLAR02 =
  {
    prefab = "PILLAR_ROUND_SMALL",
    add_mode = "island",
    environment = "indoor",

    skin = { wall="PILLAR02" }
  }

  pillar_wide_MONK03 =
  {
    prefab = "PILLAR_WIDE",
    add_mode = "island",
    environment = "indoor",

    skin = { wall="MONK03" }
  }
}


HEXEN.PLAYER_MODEL =
{
  fighter =
  {
    stats   = { health=0 }
    weapons = { f_gaunt=1 }
  }

  cleric =
  {
    stats   = { health=0 }
    weapons = { c_mace=1 }
  }

  mage =
  {
    stats   = { health=0 }
    weapons = { m_wand=1 }
  }
}


HEXEN.MONSTERS =
{
  ettin =
  {
    id = 10030
    r = 24
    h = 64
    level = 1
    prob = 60
    health = 170
    damage =  6
    attack = "melee"
  }

  afrit =
  {
    id = 10060
    r = 24
    h = 64
    level = 1
    prob = 40
    health = 80
    damage = 20
    attack = "missile"
    float = true
  }

  centaur1 =
  {
    id = 107
    r = 20
    h = 64
    level = 2
    prob = 40
    health = 200
    damage = 12
    attack = "melee"
  }

  centaur2 =
  {
    id = 115
    r = 20
    h = 64
    -- not using 'replaces' here, centaur2 is much tougher
    level = 4
    prob = 20
    health = 250
    damage = 20
    attack = "missile"
  }

  serpent1 =
  {
    id = 121
    r = 33
    h = 64
    level = 3
    health = 90
    damage = 10
    attack = "melee"
  }

  serpent2 =
  {
    id = 120
    r = 33
    h = 64
    replaces = "serpent1"
    replace_prob = 33
    health = 90
    damage = 16
    attack = "missile"
  }

  iceguy =
  {
    id = 8020
    r = 24
    h = 80
    level = 2
    prob = 3
    skip_prob = 300
    health = 120
    damage = 25
    attack = "missile"
  }

  demon1 =
  {
    id = 31
    r = 33
    h = 70
    level = 3
    prob = 30
    health = 250
    damage = 35
    attack = "missile"
  }

  demon2 =
  {
    id = 8080
    r = 33
    h = 70
    replaces = "demon1"
    replace_prob = 40
    health = 250
    damage = 35
    attack = "missile"
  }

  bishop =
  {
    id = 114
    r = 24
    h = 64
    level = 6
    prob = 20
    health = 130
    damage = 24
    attack = "missile"
    float = true
  }

  reiver =
  {
    id = 34
    r = 24
    h = 64
    level = 7
    prob = 5
    health = 150
    damage = 50
    attack = "missile"
    float = true
  }
  
  reiver_b  =
  {
    id = 10011
    r = 24
    h = 64
    replaces = "reiver"
    replace_prob = 65
    health = 150
    damage = 50
    attack = "missile"
    float = true
  }


  ---| HEXEN BOSSES |---

  -- FIXME: proper damage and attack fields

  Fighter_boss =
  {
    id = 10100
    r = 16
    h = 64 
    health = 5000
    damage = 90
  }

  Cleric_boss =
  {
    id = 10101
    r = 16
    h = 64 
    health = 5000
    damage = 90
  }

  Mage_boss =
  {
    id = 10102
    r = 16
    h = 64 
    health = 5000
    damage = 90
  }

  Wyvern =
  {
    id = 254
    r = 20
    h = 66 
    health = 640
    damage = 60
    float = true
  }

  Heresiarch =
  {
    id = 10080
    r = 40
    h = 120
    health = 5000
    damage = 70
  }

  Korax =
  {
    id = 10200
    r = 66
    h = 120
    health = 5000
    damage = 90
  }

}


HEXEN.WEAPONS =
{
  -- CLERIC --

  c_mace =
  {
    pref = 10
    attack = "melee"
    rate = 1.6
    damage = 32
    class = "cleric"
    slot = 1
  }

  c_staff =
  {
    pref = 30
    add_prob = 10
    rate = 3.5
    damage = 36
    attack = "missile"
    ammo = "blue_mana"
    per = 1
    give = { {ammo="blue_mana",count=25} }
    class = "cleric"
    slot = 2
  }

  c_fire =
  {
    pref = 60
    add_prob = 10
    attack = "missile"
    rate = 1.6
    damage = 64
    ammo = "green_mana"
    per = 4
    give = { {ammo="green_mana",count=25} }
    class = "cleric"
    slot = 3
  }

  c_wraith =
  {
    pref = 20
    attack = "missile"
    rate = 1.7
    damage = 200
    splash = { 50,35,20,1 }
    ammo = "dual_mana"
    per = 18
    class = "cleric"
    slot = 4
  }

  -- FIGHTER --

  f_gaunt =
  {
    pref = 10
    attack = "melee"
    rate = 2.0
    damage = 47
    class = "fighter"
    slot = 1
  }

  f_axe =
  {
    pref = 30
    add_prob = 10
    attack = "melee"
    rate = 1.6
    damage = 70
    ammo = "blue_mana"
    per = 2
    give = { {ammo="blue_mana",count=25} }
    class = "fighter"
    slot = 2
  }

  f_hammer =
  {
    pref = 60
    add_prob = 10
    attack = "missile"
    rate = 1.1
    damage = 100
    ammo = "green_mana"
    per = 3
    give = { {ammo="green_mana",count=25} }
    class = "fighter"
    slot = 3
  }

  f_quietus =
  {
    pref = 20
    attack = "missile"
    rate = 1.1
    damage = 200
    splash = { 50,35,20,1 }
    ammo = "dual_mana"
    per = 14
    class = "fighter"
    slot = 4
  }

  -- MAGE --

  m_wand =
  {
    pref = 10
    attack = "missile"
    rate = 2.3
    damage = 8
    splash = { 0, 6, 4, 2 }  -- model the penetrative nature
    class = "mage"
    slot = 1
  }

  m_cone =
  {
    pref = 30
    add_prob = 10
    attack = "missile"
    rate = 1.1
    damage = 30
    ammo = "blue_mana"
    per = 3
    give = { {ammo="blue_mana",count=25} }
    class = "mage"
    slot = 2
  }

  m_blitz =
  {
    pref = 60
    add_prob = 10
    attack = "missile"
    rate = 1.0
    damage = 80
    ammo = "green_mana"
    per = 5
    give = { {ammo="green_mana",count=25} }
    class = "mage"
    slot = 3
  }

  m_scourge =
  {
    pref = 20
    attack = "missile"
    rate = 1.7
    damage = 200
    splash = { 50,35,20,1 }
    ammo = "dual_mana"
    per = 15
    class = "mage"
    slot = 4
  }


  -- Notes:
  --
  -- Weapon change their behavior (and hence damage) based on which
  -- types of Mana the player has.  This is not handled yet.
  --
  -- Some weapons have both melee and projectile modes (e.g. the
  -- Fighter's hammer will throw a hammer when no monsters are in
  -- melee range).  The damage value is somewhere in-between.
  --
  -- The big weapons are not found lying around the level, rather
  -- the player must find three pieces to make them.  Hence they
  -- have no 'add_prob' value.
  --
  -- Exactly how much damage the BIG weapons can do depends a lot
  -- on how many monsters are in view.  The damage values above
  -- are just guesses.
}


---## HEXEN_WEAPON_NAMES =
---## {
---##   fighter = { "f_gaunt", "f_axe",   "f_hammer", "f_quietus" }
---##   cleric  = { "c_mace",  "c_staff", "c_fire",   "c_wraith"  }
---##   mage    = { "m_wand",  "m_cone",  "m_blitz",  "m_scourge" }
---## }

HEXEN.WEAPON_PIECES =
{
  fighter = { "f1_hilt",  "f2_cross", "f3_blade" }
  cleric  = { "c1_shaft", "c2_cross", "c3_arc"   }
  mage    = { "m1_stick", "m2_stub",  "m3_skull" }
}


HEXEN.PICKUPS =
{
  -- HEALTH --

  h_vial =
  {
    id = 81
    prob = 70
    rank = 1
    cluster = { 1,4 }
    give = { {health=10} }
  }

  h_flask =
  {
    id = 82
    rank = 2
    prob = 25
    give = { {health=25} }
  }

  h_urn =
  {
    id = 32
    prob = 5
    rank = 3
    give = { {health=100} }
  }

  -- ARMOR --

  ar_mesh =
  {
    id = 8005
    prob = 10
    rank = 2
    give = { {health=150} }
    best_class = "fighter"
  }

  ar_shield =
  {
    id = 8006
    prob = 10
    rank = 2
    give = { {health=150} }
    best_class = "cleric"
  }

  ar_amulet =
  {
    id = 8008
    prob = 10
    rank = 2
    give = { {health=150} }
    best_class = "mage"
  }

  ar_helmet =
  {
    id = 8007
    prob = 10
    rank = 1
    give = { {health=60} }  -- rough average
  }

  -- AMMO --

  blue_mana =
  {
    id = 122
    prob = 20
    rank = 0
    give = { {ammo="blue_mana",count=15} }
  }

  green_mana =
  {
    id = 124
    prob = 20
    rank = 0
    give = { {ammo="green_mana",count=15} }
  }

  dual_mana =
  {
    id = 8004
    prob = 10
    rank = 0
    give =
    {
      {ammo="blue_mana", count=20}
      {ammo="green_mana",count=20}
    }
  }

  -- NOTES:
  --
  -- Armor gives different amounts (and different decay rates)
  -- for each player class.  We cannot model that completely.
  -- Instead the 'best_class' gets the full amount and all
  -- other classes get half the amount.
}


HEXEN.ITEMS =
{
  p1 = { pickup="flechette", prob=9 }
  p2 = { pickup="bracer",    prob=5 }
  p3 = { pickup="torch",     prob=2 }
}



------------------------------------------------------------

HEXEN.EPISODES =
{
  episode1 =
  {
    theme = "ELEMENTAL"
    sky_light = 0.65
  }

  episode2 =
  {
    theme = "WILDERNESS"
    sky_light = 0.75
  }

  episode3 =
  {
    theme = "DUNGEON"
    sky_light = 0.65
  }

  episode4 =
  {
    theme = "DUNGEON"
    sky_light = 0.60
  }

  episode5 =
  {
    theme = "DUNGEON"
    sky_light = 0.50
  }
}

HEXEN.THEME_FOR_MAP =
{
  [1]  = "hexen_wild4"
  [2]  = "hexen_dungeon5"
  [3]  = "hexen_element2"
  [4]  = "hexen_element1"
  [5]  = "hexen_element3"
  [8]  = "hexen_wild4"
  [9]  = "hexen_wild3"
  [10] = "hexen_wild2"
  [11] = "hexen_wild1"
  [14] = "hexen_dungeon6"
  [15] = "hexen_dungeon1"
  [16] = "hexen_dungeon1"
  [17] = "hexen_wild4"
  [18] = "hexen_dungeon1"
  [19] = "hexen_dungeon1"
  [20] = "hexen_dungeon1"
  [21] = "hexen_dungeon1"
  [22] = "hexen_dungeon2"
  [23] = "hexen_dungeon2"
  [24] = "hexen_dungeon1"
  [25] = "hexen_dungeon4"
  [26] = "hexen_dungeon2"
  [27] = "hexen_dungeon2"
  [28] = "hexen_dungeon2"
  [29] = "hexen_dungeon3"
  [30] = "hexen_dungeon3"
  [31] = "hexen_dungeon3"
  [32] = "hexen_dungeon3"
  [35] = "hexen_dungeon2"
}


function HEXEN.setup()

end


function HEXEN.get_levels()
  local EP_NUM  = (OB_CONFIG.length == "game"   ? 5 ; 1)
  local MAP_NUM = (OB_CONFIG.length == "single" ? 1 ; 7)

--??  GAME.original_themes = {}

  for ep_index = 1,EP_NUM do
    local EPI =
    {
      levels = {}
    }

    table.insert(GAME.episodes, EPI)

    local ep_info = HEXEN.EPISODES["episode" .. ep_index]
    assert(ep_info)

--??    GAME.original_themes[episode] = ep_info.orig_theme

    for map = 1,MAP_NUM do
      local map_id = (ep_index - 1) * MAP_NUM + map

      local ep_along = map / MAP_NUM

      if MAP_NUM == 1 then
        ep_along = rand.range(0.3, 0.7)
      end

      local LEV =
      {
        episode = EPI

        name  = string.format("MAP%02d", map_id)
--??    patch = string.format("WILV%d%d", ep_index-1, map-1)

        map       = map_id
        next_map  = map_id + 1
        local_map = map

        cluster  = ep_index

         ep_along = ep_along
        mon_along = ep_along + (ep_index-1) / 3

        sky_light = ep_info.sky_light

        name_theme = "GOTHIC"
      }

      -- make certain levels match original
	  -- Was not working, so fixed above, BlackJar72
      if OB_CONFIG.theme == "original" then
        if ep_index == 3 then
          LEV.theme_name = "hexen_dungeon1"
        elseif ep_index == 4 then
          LEV.theme_name = "hexen_dungeon2"
        elseif ep_index == 5 then
          LEV.theme_name = "hexen_dungeon3"
        end -- Specific special levels

        LEV.theme_name = HEXEN.THEME_FOR_MAP[map_id]

        if LEV.theme_name then
           LEV.theme = assert(GAME.LEVEL_THEMES[LEV.theme_name])
        end

        if map_id == 29 then
          LEV.style_list =
          {
            outdoors = { heaps=100 }
            caves = { some=50, heaps=50 }
          }
        end
      end

      -- second last map in each episode is a secret level, and
      -- last map in each episode is the boss map.

      if map == 6 then
        LEV.kind = "SECRET"
      elseif map == 7 then
        LEV.kind = "BOSS"
      end

      -- very last map of the game?
      if ep_index == 5 and map == 7 then
        LEV.next_map = nil
      end

      table.insert( EPI.levels, LEV)
      table.insert(GAME.levels, LEV)
    end

    -- link hub together (unless only making a single level)

    if MAP_NUM > 1 then
      Hub_connect_levels(EPI, GAME.THEME_DEFAULTS.hub_keys)

      Hub_assign_keys(EPI, GAME.THEME_DEFAULTS.keys)
      Hub_assign_weapons(EPI)
      Hub_assign_pieces(EPI, { "piece1", "piece2", "piece3" })
    end

  end -- for episode

end


function HEXEN.make_mapinfo()
  local mapinfo = {}

  local function add(...)
    table.insert(mapinfo, string.format(...) .. "\n")
  end

  each L in GAME.levels do
    local desc = string.upper(L.description or L.name)

    add("map %d \"%s\"", L.map, desc)
    add("warptrans %d", L.map)
    add("next %d", L.next_map or 1)
    add("cluster %d", L.cluster)
    add("sky1 SKY2 0")
    add("sky2 SKY3 0")
    add("")
  end

  gui.wad_add_text_lump("MAPINFO", mapinfo)
end


function HEXEN.make_cool_gfx()
  local PURPLE =
  {
    0, 231, 232, 233, 234, 235, 236, 237, 238, 239
  }

  local GREEN =
  {
    0, 186, 188, 190, 192, 194, 196, 198, 200, 202
  }

  local BROWN =
  {
    0, 97, 99, 101, 103, 105, 107, 109, 111, 113, 115, 117, 119, 121
  }

  local RED =
  {
    0, 164, 166, 168, 170, 172, 174, 176, 178, 180, 183
  }

  local WHITE =
  {
    0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30
  }

  local BLUE =
  {
    0, 146, 148, 150, 152, 154, 156, 217, 219, 221, 223
  }


  local colmaps =
  {
    PURPLE, GREEN, BROWN, RED, BLUE
  }

  rand.shuffle(colmaps)

  gui.set_colormap(1, colmaps[1])
  gui.set_colormap(2, colmaps[2])
  gui.set_colormap(3, colmaps[3])
  gui.set_colormap(4, WHITE)

  local carve = "RELIEF"
  local c_map = 3

  if rand.odds(33) then
    carve = "CARVE"
    c_map = 4
  end

  -- patches : SEWER08, BRASS3, BRASS4
  gui.wad_logo_gfx("W_121", "p", "BOLT",  64,128, 1)
  gui.wad_logo_gfx("W_320", "p", "PILL", 128,128, 2)
  gui.wad_logo_gfx("W_321", "p", carve,  128,128, c_map)

  -- flats
  gui.wad_logo_gfx("O_BOLT",  "f", "BOLT",  64,64, 1)
  gui.wad_logo_gfx("O_PILL",  "f", "PILL",  64,64, 2)
  gui.wad_logo_gfx("O_CARVE", "f", carve,   64,64, c_map)
end


function HEXEN.all_done()
  HEXEN.make_mapinfo()
  HEXEN.make_cool_gfx()
end


------------------------------------------------------------

UNFINISHED["hexen"] =
{
  label = "Hexen"

  -- hexen format is a minor variation on the Doom format 
  -- which is enabled by the 'sub_format' PARAMETER.
  format = "doom"

  tables =
  {
    HEXEN
  }

  hooks =
  {
    setup        = HEXEN.setup
    get_levels   = HEXEN.get_levels
    all_done     = HEXEN.all_done
  }
}


OB_THEMES["hexen_dungeon"] =
{
  label = "Dungeon"
  name_theme = "GOTHIC"
  mixed_prob = 50
}

OB_THEMES["hexen_element"] =
{
  label = "Elemental"
  name_theme = "GOTHIC"
  mixed_prob = 50
}

OB_THEMES["hexen_wild"] =
{
  label = "Wilderness"
  name_theme = "GOTHIC"
  mixed_prob = 50
}

OB_THEMES["hexen_cave"] =
{
  label = "Cave"
  name_theme = "GOTHIC"
  mixed_prob = 20
}

OB_THEMES["hexen_ice"] =
{
  label = "Ice"
  name_theme = "GOTHIC"
  mixed_prob = 10
}

OB_THEMES["hexen_swamp"] =
{
  label = "Swamp"
  name_theme = "GOTHIC"
  mixed_prob = 20
}

OB_THEMES["hexen_village"] =
{
  label = "Village"
  name_theme = "URBAN"
  mixed_prob = 20
}

