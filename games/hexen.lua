----------------------------------------------------------------
-- GAME DEF : Hexen
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2011 Andrew Apted
--  Copyright (C)      2011 Jared Blackburn
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
  player1 = { id=1, kind="other", r=16,h=64 }
  player2 = { id=2, kind="other", r=16,h=64 }
  player3 = { id=3, kind="other", r=16,h=64 }
  player4 = { id=4, kind="other", r=16,h=64 }

  dm_player     = { id=11, kind="other", r=16,h=64 }
  teleport_spot = { id=14, kind="other", r=16,h=64 }
  
  --- monsters
  ettin    = { id=10030,kind="monster", r=24,h=64 }
  afrit    = { id=10060,kind="monster", r=24,h=64 }
  demon1   = { id=31,   kind="monster", r=33,h=70 }
  demon2   = { id=8080, kind="monster", r=33,h=70 }

  iceguy   = { id=8020, kind="monster", r=24,h=80 }
  centaur1 = { id=107,  kind="monster", r=20,h=64 }
  centaur2 = { id=115,  kind="monster", r=20,h=64 }

  serpent1  = { id=121,  kind="monster", r=33,h=64 }
  serpent2  = { id=120,  kind="monster", r=33,h=64 }
  bishop    = { id=114,  kind="monster", r=24,h=64 }
  reiver    = { id=34,   kind="monster", r=24,h=64 }
  reiver_b  = { id=10011,kind="monster", r=24,h=64 }

  -- bosses
  Fighter_boss = { id=10100, kind="monster", r=16,h=64  }
  Cleric_boss  = { id=10101, kind="monster", r=16,h=64  }
  Mage_boss    = { id=10102, kind="monster", r=16,h=64  }
  Wyvern       = { id=254,   kind="monster", r=20,h=66  }
  Heresiarch   = { id=10080, kind="monster", r=40,h=120 }
  Korax        = { id=10200, kind="monster", r=66,h=120 }

  --- PICKUPS ---

  -- keys
  k_steel   = { id=8030, kind="pickup", r=8,h=16 }  -- KEY1 sprite
  k_cave    = { id=8031, kind="pickup", r=8,h=16 }  -- KEY2
  k_axe     = { id=8032, kind="pickup", r=8,h=16 }  -- KEY3
  k_fire    = { id=8033, kind="pickup", r=8,h=16 }  -- KEY4
  k_emerald = { id=8034, kind="pickup", r=8,h=16 }  -- KEY5
  k_dungeon = { id=8035, kind="pickup", r=8,h=16 }  -- KEY6
  k_silver  = { id=8036, kind="pickup", r=8,h=16 }  -- KEY7
  k_rusty   = { id=8037, kind="pickup", r=8,h=16 }  -- KEY8
  k_horn    = { id=8038, kind="pickup", r=8,h=16 }  -- KEY9
  k_swamp   = { id=8039, kind="pickup", r=8,h=16 }  -- KEYA
  k_castle  = { id=8200, kind="pickup", r=8,h=16 }  -- KEYB
 
  -- weapons
  c_staff   = { id=10,  kind="pickup", r=20,h=16 }
  c_fire    = { id=8009,kind="pickup", r=20,h=16 }
  c1_shaft  = { id=20,  kind="pickup", r=20,h=16 }
  c2_cross  = { id=19,  kind="pickup", r=20,h=16 }
  c3_arc    = { id=18,  kind="pickup", r=20,h=16 }

  f_axe     = { id=8010,kind="pickup", r=20,h=16 }
  f_hammer  = { id=123, kind="pickup", r=20,h=16 }
  f1_hilt   = { id=16,  kind="pickup", r=20,h=16 }
  f2_cross  = { id=13,  kind="pickup", r=20,h=16 }
  f3_blade  = { id=12,  kind="pickup", r=20,h=16 }

  m_cone    = { id=53,  kind="pickup", r=20,h=16 }
  m_blitz   = { id=8040,kind="pickup", r=20,h=16 }
  m1_stick  = { id=23,  kind="pickup", r=20,h=16 }
  m2_stub   = { id=22,  kind="pickup", r=20,h=16 }
  m3_skull  = { id=21,  kind="pickup", r=20,h=16 }

  -- health/ammo/armor
  blue_mana  = { id=122, kind="pickup", r=20,h=16 }
  green_mana = { id=124, kind="pickup", r=20,h=16 }
  dual_mana  = { id=8004,kind="pickup", r=20,h=16 }

  ar_mesh   = { id=8005, kind="pickup", r=20,h=16 }
  ar_shield = { id=8006, kind="pickup", r=20,h=16 }
  ar_helmet = { id=8007, kind="pickup", r=20,h=16 }
  ar_amulet = { id=8008, kind="pickup", r=20,h=16 }

  h_vial  = { id=81, kind="pickup", r=20,h=16 }
  h_flask = { id=82, kind="pickup", r=20,h=16 }
  h_urn   = { id=32, kind="pickup", r=20,h=16 }

  -- artifacts
  wings = { id=83, kind="pickup", r=20,h=16 }
  chaos = { id=36, kind="pickup", r=20,h=16 }
  torch = { id=33, kind="pickup", r=20,h=16 }

  banish    = { id=10040,kind="pickup", r=20,h=16 }
  boots     = { id=8002, kind="pickup", r=20,h=16 }
  bracer    = { id=8041, kind="pickup", r=20,h=16 }
  repulser  = { id=8000, kind="pickup", r=20,h=16 }
  flechette = { id=10110,kind="pickup", r=20,h=16 }
  servant   = { id=86,   kind="pickup", r=20,h=16 }
  porkies   = { id=30,   kind="pickup", r=20,h=16 }
  incant    = { id=10120,kind="pickup", r=20,h=16 }
  defender  = { id=84,   kind="pickup", r=20,h=16 }
  krater    = { id=8003, kind="pickup", r=20,h=16 }

  --- SCENERY ---

  -- lights
  candles       = { id=119,  kind="scenery", r=20,h=20, light=255 }
  blue_candle   = { id=8066, kind="scenery", r=20,h=20, light=255 }
  fire_skull    = { id=8060, kind="scenery", r=12,h=12, light=255 }
  brass_brazier = { id=8061, kind="scenery", r=12,h=40, light=255 }

  wall_torch      = { id=54,  kind="scenery", r=20,h=48, light=255 }
  wall_torch_out  = { id=55,  kind="scenery", r=20,h=48 }
  twine_torch     = { id=116, kind="scenery", r=12,h=64, light=255 }
  twine_torch_out = { id=117, kind="scenery", r=12,h=64 }
  chandelier      = { id=17,  kind="scenery", r=20,h=60, light=255, ceil=true }
  chandelier_out  = { id=8063,kind="scenery", r=20,h=60, light=255, ceil=true }

  cauldron        = { id=8069,kind="scenery", r=16,h=32, light=255 }
  cauldron_out    = { id=8070,kind="scenery", r=16,h=32 }
  fire_bull       = { id=8042,kind="scenery", r=24,h=80, light=255 }
  fire_bull_out   = { id=8043,kind="scenery", r=24,h=80 }

  -- urbane
  winged_statue1 = { id=5,   kind="scenery", r=12,h=64 }
  winged_statue2 = { id=9011,kind="scenery", r=12,h=64 }
  suit_of_armor  = { id=8064,kind="scenery", r=16,h=72 }

  gargoyle_tall  = { id=72, kind="scenery", r=16,h=108 }
  gargoyle_short = { id=74, kind="scenery", r=16,h=64  }
  garg_ice_tall  = { id=73, kind="scenery", r=16,h=108 }
  garg_ice_short = { id=76, kind="scenery", r=16,h=64  }

  garg_corrode     = { id=8044, kind="scenery", r=16,h=108 }
  garg_red_tall    = { id=8045, kind="scenery", r=16,h=108 }
  garg_red_short   = { id=8049, kind="scenery", r=16,h=64  }
  garg_lava_tall   = { id=8046, kind="scenery", r=16,h=108 }
  garg_lava_short  = { id=8050, kind="scenery", r=16,h=64  }

  garg_bronz_tall  = { id=8047, kind="scenery", r=16,h=108 }
  garg_bronz_short = { id=8051, kind="scenery", r=16,h=64  }
  garg_steel_tall  = { id=8048, kind="scenery", r=16,h=108 }
  garg_steel_short = { id=8052, kind="scenery", r=16,h=64  }

  bell   = { id=8065, kind="scenery", r=56,h=120 }
  barrel = { id=8100, kind="scenery", r=16,h=36 }
  bucket = { id=8103, kind="scenery", r=12,h=72 }
  banner = { id=77,   kind="scenery", r=12,h=120 }

  vase_pillar = { id=103, kind="scenery", r=12,h=56 }

  -- nature
  tree1 = { id=25, kind="scenery", r=16,h=128 }
  tree2 = { id=26, kind="scenery", r=12,h=180 }
  tree3 = { id=27, kind="scenery", r=12,h=160 }

  lean_tree1 = { id=78,  kind="scenery", r=16,h=180 }
  lean_tree2 = { id=79,  kind="scenery", r=16,h=180 }
  smash_tree = { id=8062,kind="scenery", r=16,h=180 }
  xmas_tree  = { id=8068,kind="scenery", r=12,h=132 }

  gnarled_tree1 = { id=80, kind="scenery", r=24,h=96 }
  gnarled_tree2 = { id=87, kind="scenery", r=24,h=96 }

  shrub1 = { id=8101, kind="scenery", r=12,h=24 }
  shrub2 = { id=8102, kind="scenery", r=16,h=40 }

  rock1  = { id=6,  kind="scenery", r=20,h=16 }
  rock2  = { id=7,  kind="scenery", r=20,h=16 }
  rock3  = { id=9,  kind="scenery", r=20,h=16 }
  rock4  = { id=15, kind="scenery", r=20,h=16 }

  stal_pillar   = { id=48, kind="scenery", r=12,h=136 }
  stal_F_big    = { id=49, kind="scenery", r=12,h=48 }
  stal_F_medium = { id=50, kind="scenery", r=12,h=40 }
  stal_F_small  = { id=51, kind="scenery", r=12,h=40 }

  stal_C_big    = { id=52, kind="scenery", r=12,h=68 }
  stal_C_medium = { id=56, kind="scenery", r=12,h=52 }
  stal_C_small  = { id=57, kind="scenery", r=12,h=40 }

  ice_stal_F_big    = { id=93, kind="scenery", r=12,h=68 }
  ice_stal_F_medium = { id=94, kind="scenery", r=12,h=52 }
  ice_stal_F_small  = { id=95, kind="scenery", r=12,h=36 }
  ice_stal_F_tiny   = { id=95, kind="scenery", r=12,h=16 }

  ice_stal_C_big    = { id=89, kind="scenery", r=12,h=68 }
  ice_stal_C_medium = { id=90, kind="scenery", r=12,h=52 }
  ice_stal_C_small  = { id=91, kind="scenery", r=12,h=36 }
  ice_stal_C_tiny   = { id=92, kind="scenery", r=12,h=16 }

  -- gory
  impaled_corpse = { id=61,  kind="scenery", r=12, h=96 }
  laying_corpse  = { id=62,  kind="scenery", r=12, h=44 }
  hang_corpse_1  = { id=71,  kind="scenery", r=12, h=75, ceil=true }
  hang_corpse_1  = { id=108, kind="scenery", r=12, h=96, ceil=true }
  hang_corpse_1  = { id=109, kind="scenery", r=12, h=100,ceil=true }
  smash_corpse   = { id=110, kind="scenery", r=12, h=40 }

  iron_maiden    = { id=8067,kind="scenery", r=16,h=60 }

  -- miscellaneous
  teleport_smoke = { id=140, kind="scenery", r=20,h=80, pass=true }
  dummy = { id=55, kind="other", r=16,h=20, pass=true }

  -- ambient sounds
  snd_stone  = { id=1400, kind="other", r=16,h=16, pass=true }
  snd_heavy  = { id=1401, kind="other", r=16,h=16, pass=true }
  snd_metal1 = { id=1402, kind="other", r=16,h=16, pass=true }
  snd_creak  = { id=1403, kind="other", r=16,h=16, pass=true }
  snd_silent = { id=1404, kind="other", r=16,h=16, pass=true }
  snd_lava   = { id=1405, kind="other", r=16,h=16, pass=true }
  snd_water  = { id=1406, kind="other", r=16,h=16, pass=true }
  snd_ice    = { id=1407, kind="other", r=16,h=16, pass=true }
  snd_earth  = { id=1408, kind="other", r=16,h=16, pass=true }
  snd_metal2 = { id=1409, kind="other", r=16,h=16, pass=true }
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
  SEWER09  = { t="SEWER09",  f="F_017" }
  SEWER10  = { t="SEWER10",  f="F_017" }
  SEWER11  = { t="SEWER11",  f="F_017" }
  SEWER12  = { t="SEWER12",  f="F_017" }
  SEWER13  = { t="SEWER13",  f="F_018" }

  SPAWN01  = { t="SPAWN01",  f="F_042" }
  SPAWN05  = { t="SPAWN05",  f="F_042" }
  SPAWN08  = { t="SPAWN08",  f="F_065" }
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
  F_047 = { t="STEEL01",  f="F_047" }
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

  GATE01  = { t="GATE01", rail_h=72 }
  GATE02  = { t="GATE02", rail_h=128 }
  GATE03  = { t="GATE03", rail_h=64 }
  GATE04  = { t="GATE04", rail_h=32 }
  GATE51  = { t="GATE51", rail_h=128 }
  GATE52  = { t="GATE52", rail_h=64 }
  GATE53  = { t="GATE53", rail_h=32 }

  BAMBOO_6 = { t="VILL06", rail_h=128 }
  BAMBOO_7 = { t="VILL07", rail_h=64 }
  BAMBOO_8 = { t="VILL08", rail_h=96 }

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

  SEWER_BAR3 = { t="SEWER03", rail_h=64 }
  SEWER_BAR4 = { t="SEWER04", rail_h=32 }

  WEB1_L   = { t="WEB1_L", rail_h=32 }
  WEB1_R   = { t="WEB1_R", rail_h=32 }
  WEB2_L   = { t="WEB2_L", rail_h=32 }
  WEB2_R   = { t="WEB2_R", rail_h=32 }
  WEB3     = { t="WEB3",   rail_h=32 }


  -- other --

  O_BOLT   = { t="SEWER08", f="O_BOLT",  sane=1 }
  O_PILL   = { t="BRASS3",  f="O_PILL",  sane=1 }
  O_CARVE  = { t="BRASS4",  f="O_CARVE", sane=1 }
}


--[[ FIXME: incorporate these color values
BLANK , color=0x040404
BOOKS01 , color=0x2c1b11
BOOKS02 , color=0x2d1b0f
BOOKS03 , color=0x2d1b0f
BOOKS04 , color=0x2e1b0f
BOSSK1 , color=0x272727
BOSSK2 , color=0x2e2d29
BRASS1 , color=0x5b2c02
BRASS3 , color=0x532802
BRASS4 , color=0x542802
CASTLE01 , color=0x252525
CASTLE02 , color=0x262625
CASTLE03 , color=0x262525
CASTLE04 , color=0x262625
CASTLE05 , color=0x262525
CASTLE06 , color=0x262525
CASTLE07 , color=0x2a2a2a
CASTLE08 , color=0x373736
CASTLE09 , color=0x3b3b3b
CASTLE11 , color=0x3e3426
CAVE01 , color=0x393023
CAVE02 , color=0x2e2f2d
CAVE03 , color=0x2f2d20
CAVE04 , color=0x292b24
CAVE05 , color=0x21160e
CAVE06 , color=0x262621
CAVE07 , color=0x1d1c1a
CAVE11 , color=0x3e3f3d
CAVE12 , color=0x383938
CHAP1 , color=0x4f3317
CHAP2 , color=0x381b03
CHAP3 , color=0x232622
CLOCK01 , color=0x6e4e21
CLOCK02 , color=0x705121
CLOCK03 , color=0x73521f
CLOCK04 , color=0x705121
CLOCK05 , color=0x6e4e21
CLOCK06 , color=0x705121
CLOCK07 , color=0x73521f
CLOCK08 , color=0x705121
CLOCK11 , color=0x73511f
CLOCK12 , color=0x765520
CLOCK13 , color=0x7a551e
CLOCK14 , color=0x765520
CLOCK15 , color=0x73511f
CLOCK16 , color=0x765520
CLOCK17 , color=0x7a551e
CLOCK18 , color=0x765520
CLOCKA , color=0x413d32
CLOCKB , color=0x6e4e21
CLOCKC , color=0x73511f
CRATE01 , color=0x3a1c0d
CRATE02 , color=0x31180b
CRATE03 , color=0x2e170b
CRATE04 , color=0x31180b
CRATE05 , color=0x32190c
DOOR51 , color=0x323432
D_AXE , color=0x26170d
D_BRASS1 , color=0x572901
D_BRASS2 , color=0x572901
D_CAST , color=0x292117
D_CAVE , color=0x291f17
D_CAVE2 , color=0x22170d
D_DUNGEO , color=0x27180f
D_END1 , color=0x302a21
D_END2 , color=0x322c23
D_END3 , color=0x271409
D_END4 , color=0x26160d
D_ENDBR , color=0x502602
D_ENDSLV , color=0x333333
D_FIRE , color=0x2d2421
D_RUST , color=0x2b1e15
D_SILKEY , color=0x27150b
D_SILVER , color=0x2b2018
D_SLV1 , color=0x383938
D_SLV2 , color=0x383938
D_STEEL , color=0x302f2d
D_SWAMP , color=0x242520
D_SWAMP2 , color=0x2e2f2b
D_WASTE , color=0x553b19
D_WD01 , color=0x27150b
D_WD02 , color=0x27150b
D_WD03 , color=0x26160c
D_WD04 , color=0x26160c
D_WD05 , color=0x2d170b
D_WD06 , color=0x2d170b
D_WD07 , color=0x2b1d14
D_WD08 , color=0x2a1d14
D_WD09 , color=0x2a1d14
D_WD10 , color=0x2a1e15
D_WINNOW , color=0x2b1b12
FIRE01 , color=0x171817
FIRE02 , color=0x1e1e1e
FIRE03 , color=0x1e1e1e
FIRE04 , color=0x1e1f1e
FIRE05 , color=0x191919
FIRE06 , color=0x292725
FIRE07 , color=0x292725
FIRE08 , color=0x2b2927
FIRE09 , color=0x2b2927
FIRE10 , color=0x2b2a27
FIRE11 , color=0x2d2b29
FIRE12 , color=0x2d2b29
FIRE14 , color=0x1d1e1d
FIRE15 , color=0x1b1c1b
FIRE16 , color=0x3b3a39
FIRE17 , color=0x2a231d
FOREST01 , color=0x553217
FOREST02 , color=0x151712
FOREST03 , color=0x1d1c15
FOREST04 , color=0x1a1d19
FOREST05 , color=0x334531
FOREST06 , color=0x412e14
FOREST07 , color=0x3c2b14
FOREST10 , color=0x2f271e
FOREST11 , color=0x2f302e
FOREST12 , color=0x30312e
FORPUZ1 , color=0x5d3517
FORPUZ2 , color=0x291f14
FORPUZ3 , color=0x2a211a
GATE01 , color=0x191b19
GATE02 , color=0x2f2921
GATE03 , color=0x2e2a23
GATE04 , color=0x30291f
GATE51 , color=0x252019
GATE52 , color=0x252019
GATE53 , color=0x27231c
GEAR01 , color=0x483d2c
GEAR02 , color=0x39332a
GEAR03 , color=0x39332a
GEAR04 , color=0x38332a
GEAR05 , color=0x39332a
GEAR0A , color=0x392f24
GEAR0B , color=0x382f24
GEARW , color=0x523514
GEARX , color=0x4a4237
GEARY , color=0x4c3e2d
GEARZ , color=0x4f381e
GILO1 , color=0x5e5f5e
GILO2 , color=0x5e5f5e
GLASS01 , color=0x402f3a
GLASS02 , color=0x2c2e39
GLASS03 , color=0x3e2b38
GLASS04 , color=0x2f2a36
GLASS05 , color=0x3e2633
GLASS06 , color=0x2d2c39
GLASS07 , color=0x2c2231
GRAVE01 , color=0x3b3e3a
GRAVE03 , color=0x383d38
GRAVE04 , color=0x3d413d
GRAVE05 , color=0x3d413d
GRAVE06 , color=0x3b3f3a
GRAVE07 , color=0x3a3e3a
GRAVE08 , color=0x3b3f3a
ICE01 , color=0x545269
ICE02 , color=0x302e31
ICE03 , color=0x28282a
ICE06 , color=0x343235
MONK01 , color=0x292d29
MONK02 , color=0x462d12
MONK03 , color=0x473624
MONK04 , color=0x463018
MONK05 , color=0x402d19
MONK06 , color=0x43260a
MONK07 , color=0x2f312f
MONK08 , color=0x292c29
MONK09 , color=0x442a10
MONK11 , color=0x43260a
MONK12 , color=0x442a10
MONK14 , color=0x4b3113
MONK15 , color=0x4a3013
MONK16 , color=0x492f12
MONK17 , color=0x482e12
MONK18 , color=0x482e13
MONK19 , color=0x3e260d
MONK21 , color=0x3e260d
MONK22 , color=0x3e260d
MONK23 , color=0x41372d
MONK24 , color=0x4a3c2e
PILLAR01 , color=0x4b2f13
PILLAR02 , color=0x373837
PLANET1 , color=0x2e251d
PLANET2 , color=0x2d251c
PLAT01 , color=0x1f201f
PLAT02 , color=0x1f1f1d
POOT , color=0x334531
PRTL02 , color=0x373736
PRTL03 , color=0x222b22
PRTL04 , color=0x464644
PRTL05 , color=0x3b3a37
PRTL06 , color=0x3c3c3c
PRTL07 , color=0x434343
PUZZLE1 , color=0x242220
PUZZLE10 , color=0x292929
PUZZLE11 , color=0x282928
PUZZLE12 , color=0x282928
PUZZLE2 , color=0x24211f
PUZZLE3 , color=0x252220
PUZZLE4 , color=0x242220
PUZZLE5 , color=0x2c2c2c
PUZZLE6 , color=0x2c2c2c
PUZZLE7 , color=0x2c2d2c
PUZZLE8 , color=0x2c2d2c
PUZZLE9 , color=0x292929
SEWER01 , color=0x222522
SEWER02 , color=0x202220
SEWER03 , color=0x242421
SEWER04 , color=0x252724
SEWER05 , color=0x232521
SEWER06 , color=0x222421
SEWER07 , color=0x291d16
SEWER08 , color=0x291f17
SEWER09 , color=0x291e16
SEWER10 , color=0x292017
SEWER11 , color=0x291e16
SEWER12 , color=0x292017
SEWER13 , color=0x333533
SEWER14 , color=0x373837
SKY1 , color=0x422305
SKY2 , color=0x000326
SKY3 , color=0x010452
SKY4 , color=0x560600
SKYFOG , color=0x797979
SKYFOG2 , color=0x2f2f2f
SKYWALL , color=0x170d05
SKYWALL2 , color=0x050505
SPAWN01 , color=0x2f302f
SPAWN02 , color=0x2f302f
SPAWN03 , color=0x33312d
SPAWN04 , color=0x303030
SPAWN05 , color=0x30302f
SPAWN06 , color=0x30302f
SPAWN07 , color=0x30302e
SPAWN08 , color=0x201c17
SPAWN09 , color=0x211c17
SPAWN10 , color=0x241a15
SPAWN11 , color=0x202920
SPAWN12 , color=0x2e2f1f
SPAWN13 , color=0x3e3f3d
STEEL01 , color=0x372417
STEEL02 , color=0x332214
STEEL05 , color=0x312f2e
STEEL06 , color=0x2d2c2b
STEEL07 , color=0x484848
STEEL08 , color=0x333231
SW51_OFF , color=0x23201e
SW51_ON , color=0x332a20
SW52_OFF , color=0x282928
SW52_ON , color=0x342f28
SW53_DN , color=0x402811
SW53_MD , color=0x402911
SW53_UP , color=0x412a12
SWAMP01 , color=0x283226
SWAMP03 , color=0x292f29
SWAMP04 , color=0x23231d
SWAMP06 , color=0x343432
SWAMP07 , color=0x383734
SW_1_DN , color=0x282114
SW_1_MD , color=0x282113
SW_1_UP , color=0x272113
SW_2_DN , color=0x222720
SW_2_MD , color=0x212721
SW_2_UP , color=0x21261f
SW_EL1 , color=0x2d2e2d
SW_EL2 , color=0x232323
SW_EL3 , color=0x1c1d1c
SW_EL4 , color=0x271718
SW_EL5 , color=0x3d1514
SW_OL1 , color=0x2d261e
SW_OL2 , color=0x2c261d
SW_OL3 , color=0x2c261e
SW_OL4 , color=0x2c251d
SW_OL5 , color=0x2d261e
S_01 , color=0x2c2217
S_02 , color=0x464846
S_04 , color=0x3b2003
S_05 , color=0x262622
S_06 , color=0x5e615c
S_07 , color=0x4e4f4d
S_09 , color=0x363430
S_11 , color=0x172614
S_12 , color=0x361a0c
S_13 , color=0x313131
T2_STEP , color=0x323332
TOMB01 , color=0x2a2a29
TOMB02 , color=0x292929
TOMB03 , color=0x373134
TOMB04 , color=0x1e1f1e
TOMB05 , color=0x683506
TOMB06 , color=0x66370f
TOMB07 , color=0x342f28
TOMB08 , color=0x3d3f3d
TOMB09 , color=0x48280c
TOMB10 , color=0x4c2708
TOMB11 , color=0x332e27
TOMB12 , color=0x4c3b2b
TOMB13 , color=0x5b422a
TOMB18 , color=0x333030
TPORT1 , color=0x6f0000
TPORT2 , color=0x640000
TPORT3 , color=0x650000
TPORT4 , color=0x6b0000
TPORT5 , color=0x640000
TPORT6 , color=0x630000
TPORT7 , color=0x690000
TPORT8 , color=0x660000
TPORT9 , color=0x680000
TPORTX , color=0x53514f
VALVE01 , color=0x1c1711
VALVE02 , color=0x1d1711
VALVE1 , color=0x3b2916
VALVE2 , color=0x3b2915
VILL01 , color=0x3b220d
VILL04 , color=0x3a220c
VILL05 , color=0x39200c
VILL06 , color=0x2e180a
VILL07 , color=0x2e180a
VILL08 , color=0x2c1809
WASTE01 , color=0x693b18
WASTE02 , color=0x3d3f3c
WASTE03 , color=0x525551
WASTE04 , color=0x573c19
WEB1_L , color=0x505150
WEB1_R , color=0x525252
WEB2_L , color=0x505150
WEB2_R , color=0x575757
WEB3 , color=0x525252
WINN01 , color=0x2e2318
WINNOW02 , color=0x2b2c2b
WOOD01 , color=0x351a0c
WOOD02 , color=0x32190b
WOOD03 , color=0x2d1a0d
WOOD04 , color=0x2b1a0d
X_FAC01 , color=0x760101
X_FAC02 , color=0x740101
X_FAC03 , color=0x770101
X_FAC04 , color=0x740101
X_FAC05 , color=0x6d0201
X_FAC06 , color=0x6a0301
X_FAC07 , color=0x6a0601
X_FAC08 , color=0x650602
X_FAC09 , color=0x650602
X_FAC10 , color=0x620602
X_FAC11 , color=0x630702
X_FAC12 , color=0x630602
X_FIRE01 , color=0x901b00
X_FIRE02 , color=0x8e2000
X_FIRE03 , color=0x911c00
X_FIRE04 , color=0x8e2000
X_SWMP1 , color=0x121d0e
X_SWMP2 , color=0x121d0d
X_SWMP3 , color=0x111d0d
X_SWR1 , color=0x1e211e
X_SWR2 , color=0x1e221e
X_SWR3 , color=0x1e221e
X_WATER1 , color=0x010438
X_WATER2 , color=0x010439
X_WATER3 , color=0x010439
X_WATER4 , color=0x010438

F_001 , color=0x351b0c
F_002 , color=0x492f11
F_003 , color=0x572e13
F_004 , color=0x3f2911
F_005 , color=0x5c3314
F_006 , color=0x4b2c12
F_007 , color=0x2f1f0f
F_008 , color=0x1d1c1a
F_009 , color=0x383a38
F_010 , color=0x505150
F_011 , color=0x7c4b28
F_012 , color=0x262726
F_013 , color=0x292724
F_014 , color=0x41280f
F_015 , color=0x2d2e2d
F_017 , color=0x23221d
F_018 , color=0x222522
F_019 , color=0x2c372b
F_020 , color=0x2d362d
F_021 , color=0x201e1d
F_022 , color=0x202020
F_023 , color=0x1e1f1e
F_024 , color=0x222411
F_025 , color=0x472e12
F_027 , color=0x292d29
F_028 , color=0x4b3113
F_029 , color=0x513515
F_030 , color=0x40210e
F_031 , color=0x313331
F_032 , color=0x171817
F_033 , color=0x727188
F_034 , color=0x141c13
F_037 , color=0x644623
F_038 , color=0x151712
F_039 , color=0x222420
F_040 , color=0x1a1c1a
F_041 , color=0x2a221c
F_042 , color=0x3b3b3b
F_043 , color=0x303230
F_044 , color=0x4f504e
F_045 , color=0x2e2d2b
F_046 , color=0x413b2f
F_047 , color=0x4c4130
F_048 , color=0x334531
F_049 , color=0x3a1c0d
F_050 , color=0x2e170b
F_051 , color=0x31180b
F_052 , color=0x31180b
F_053 , color=0x32190c
F_054 , color=0x341a0c
F_055 , color=0x341a0c
F_057 , color=0x282828
F_058 , color=0x1e1f1e
F_059 , color=0x723804
F_061 , color=0x3e3f3d
F_062 , color=0x3e403e
F_063 , color=0x3e403e
F_064 , color=0x3b3d3b
F_065 , color=0x313131
F_066 , color=0x52514f
F_067 , color=0x313130
F_068 , color=0x52504e
F_069 , color=0x2a2928
F_070 , color=0x4a4846
F_071 , color=0x323232
F_072 , color=0x535352
F_073 , color=0x302b21
F_074 , color=0x352215
F_075 , color=0x392312
F_076 , color=0x2e302d
F_077 , color=0x351f0d
F_078 , color=0x373635
F_081 , color=0x342a3b
F_082 , color=0x262626
F_083 , color=0x30302e
F_084 , color=0x323454
F_085 , color=0x313352
F_086 , color=0x313350
F_087 , color=0x313352
F_088 , color=0x313351
F_089 , color=0x302517
F_091 , color=0x272420
F_092 , color=0x341a0c
F_A501 , color=0x313331
X_001 , color=0x901b00
X_002 , color=0x8e2000
X_003 , color=0x911c00
X_004 , color=0x8e2000
X_005 , color=0x010438
X_006 , color=0x010439
X_007 , color=0x010439
X_008 , color=0x010438
X_009 , color=0x121d0e
X_010 , color=0x121d0d
X_011 , color=0x111d0d
X_012 , color=0x553130
X_013 , color=0x533130
X_014 , color=0x513130
X_015 , color=0x533130
X_016 , color=0x523130
--]]


----------------------------------------------------------------

HEXEN.SKINS =
{
  ----| STARTS |----

  Start_basic =
  {
    _prefab = "START_SPOT"

    top = "O_BOLT"
  }


  ----| EXITS |----

  Exit_switch =
  {
    _prefab = "EXIT_PILLAR",

    switch = "SEWER06"
    exit = "PLAT01"
    exitside = "PLAT01"

    special = 74
    act = "S1"
    tag = 0
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


  ----| KEYS and ITEMS |----

  Weapon2_Set =
  {
    _prefab = "HEXEN_TRIPLE"
    _where  = "chunk"

    side = "CRATE05"
    base = "F_082"

    f_item = "f_axe"
    c_item = "c_staff"
    m_item = "m_cone"
  }

  Weapon3_Set =
  {
    _prefab = "HEXEN_TRIPLE"
    _where  = "chunk"

    side = "CRATE05"
    base = "F_082"

    f_item = "f_hammer"
    c_item = "c_fire"
    m_item = "m_blitz"
  }

  Piece1_Set =
  {
    _prefab = "HEXEN_TRIPLE"
    _where  = "chunk"

    side = "CRATE05"
    base = "F_082"

    f_item = "f1_hilt"
    c_item = "c1_shaft"
    m_item = "m1_stick"
  }

  Piece2_Set =
  {
    _prefab = "HEXEN_TRIPLE"
    _where  = "chunk"

    side = "CRATE05"
    base = "F_082"

    f_item = "f2_cross"
    c_item = "c2_cross"
    m_item = "m2_stub"
  }

  Piece3_Set =
  {
    _prefab = "HEXEN_TRIPLE"
    _where  = "chunk"

    side = "CRATE05"
    base = "F_082"

    f_item = "f3_blade"
    c_item = "c3_arc"
    m_item = "m3_skull"
  }


  --- LOCKED DOORS ---

  Locked_axe =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _keys = { k_axe=1 }
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
    _keys = { k_cave=1 }
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
    keynum = 2
  }

  Locked_castle =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _keys = { k_castle=1 }
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
    keynum = 11
  }

  Locked_dungeon =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _keys = { k_dungeon=1 }
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
    _keys = { k_emerald=1 }
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
    _keys = { k_fire=1 }
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
    _keys = { k_horn=1 }
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
    _keys = { k_rusty=1 }
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
    _keys = { k_swamp=1 }
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
    _keys = { k_silver=1 }
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
    _keys = { k_steel=1 }
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
    _switches = { sw_steel=1 }
    _long = 192
    _deep = 32

    w = 128
    h = 112
    door_h = 112
    door = "BRASS1"
    track = "STEEL08"
    special = 0
  }

  Switch_1 =
  {
    _prefab = "SMALL_SWITCH"
    _where  = "chunk"
    _switches = { sw_steel=1 }

    switch_h = 32
    switch = "SW51_OFF"
    side = "STEEL07"
    base = "STEEL07"
    x_offset = 0
    y_offset = 0

    special = 11
    act = "S1"
  }


  ---| TELEPORTERS |---

  Hub_Gate =
  {
    _prefab = "HEXEN_GATE"
    _where  = "chunk"

    frame = "WOOD01"
  }

}


----------------------------------------------------------------

HEXEN.COMBOS =  -- NOTE: THIS IS OLD STUFF, TO BE REMOVED...
{
  ---- CAVE ------------

  CAVE1 =
  {
    theme_probs = { CAVE=50 }
    mat_pri = 2,

    wall  = "CAVE06",
    floor = "F_040",
    ceil  = "F_040",

    arch  = "arch_arched",

    scenery = "stal_pillar",
  }

  CAVE2 =
  {
    theme_probs = { CAVE=50 }
    mat_pri = 2,

    wall  = "CAVE05",
    floor = "F_001",
    ceil  = "F_001",

    arch  = "arch_hole",
  }

  CAVE3 =
  {
    theme_probs = { CAVE=70 }
    mat_pri = 2,
    outdoor = true,

    wall  = "CAVE03",
    floor = "F_039",
    ceil  = "F_039",

    scenery = "lean_tree2",

    space_range = { 40,80 }
  }

  CAVE4 =
  {
    theme_probs = { CAVE=50 }
    mat_pri = 3,
    outdoor = true,

    wall  = "CAVE01",
    floor = "F_007",
    ceil  = "F_007",

    scenery = "lean_tree1",

    space_range = { 40,80 }
  }

  ---- DUNGEON ------------

  DUNGEON1 =
  {
    theme_probs = { DUNGEON=50 }
    mat_pri = 5,

    wall  = "FIRE01",
    floor = "F_012",
    ceil  = "F_082",

    pillar = "FIRE15",
    good_liquid = "lava",

  }

  DUNGEON2 =
  {
    theme_probs = { DUNGEON=50 }
    mat_pri = 5,

    wall  = "FIRE06",
    floor = "F_012",
    ceil  = "F_032",

    pillar = "FIRE15",
    good_liquid = "lava",

  }

  DUNGEON3 =
  {
    theme_probs = { DUNGEON=50 }
    mat_pri = 5,

    wall  = "CASTLE11",
    floor = "F_011", -- F_014
    ceil  = "F_045",

    pillar = "FIRE15",
    good_liquid = "lava",

  }

  DUNGEON4 =
  {
    theme_probs = { DUNGEON=50 }
    mat_pri = 5,
    outdoor = true,

    wall  = "PRTL03",
    floor = "F_018",
    ceil  = "F_018",

    pillar = "FIRE15",
    good_liquid = "lava",

  }

  ---- ICE ------------

  ICE1 =
  {
    theme_probs = { ICE=30 }
    mat_pri = 1,

    wall = "ICE01",
    floor = "F_033",
    ceil  = "F_033",

    pillar = "ICE02",
    bad_liquid = "lava",

    sc_count = { 3,7 }
    scenery =
    {
      ice_stal_F_big    = 10, ice_stal_C_big    = 10,
      ice_stal_F_medium = 20, ice_stal_C_medium = 20,
      ice_stal_F_small  = 30, ice_stal_C_small  = 30,
      ice_stal_F_tiny   = 20, ice_stal_C_tiny   = 20,
    }
  }

  ICE2 =
  {
    theme_probs = { ICE=80 }
    mat_pri = 2,

    wall  = "ICE06",
    floor = "F_013",
    ceil  = "F_009",

    pillar = "ICE02",
    bad_liquid = "lava",
  }

  ICE3 =
  {
    theme_probs = { ICE=60 }
    mat_pri = 2,

    wall  = "CAVE02",
    floor = "F_034",
    ceil  = "F_008",

    bad_liquid = "lava",
  }

  ICE4 =
  {
    theme_probs = { ICE=60 }
    mat_pri = 2,
    outdoor = true,

    wall  = "CAVE07",
    floor = "F_008",
    ceil  = "F_008",

    bad_liquid = "lava",
  }

  ---- SWAMP ------------

  SWAMP1 =
  {
    theme_probs = { SWAMP=50 }
    mat_pri = 2,

    wall = "SEWER01",
    floor = "X_009",
    ceil  = "F_013",

    liquid_prob = 0,

    wall_fabs = { solid_SEWER02=30, other=30 }

    -- FIXME !!!! X_SWR1 pillar
  }

  SWAMP2 =
  {
    theme_probs = { SWAMP=50 }
    mat_pri = 2,

    wall = "SEWER07",
    floor = "X_009",
    ceil  = "F_013",

    liquid_prob = 0,

    wall_fabs = { solid_SEWER10=60, other=30 }
  }

  SWAMP3 =
  {
    theme_probs = { SWAMP=50 }
    mat_pri = 2,
    outdoor = true,

    wall = "WASTE01",
    floor = "X_009",
    ceil  = "F_013",

    liquid_prob = 0,
  }

  SWAMP4 =
  {
    theme_probs = { SWAMP=50 }
    mat_pri = 2,
    outdoor = true,

    wall  = "SWAMP03",
    floor = "X_009",
    ceil  = "F_013",

    liquid_prob = 0,
  }

  ---- VILLAGE ------------

  VILLAGE1 =
  {
    theme_probs = { VILLAGE=50 }
    mat_pri = 6,

    wall  = "FOREST01",
    floor = "F_089",
    ceil  = "F_010",

    scenery = "brass_brazier",
    sc_fabs = { pillar_rnd_PILLAR01=50, other=30 }
  }

  VILLAGE2 =
  {
    theme_probs = { VILLAGE=50 }
    mat_pri = 4,

    wall  = "WOOD03",
    floor = "F_055",
    ceil  = "F_014",

    pillar = "PILLAR01",
    scenery = "brass_brazier",
  }

  VILLAGE3 =
  {
    theme_probs = { VILLAGE=60 }
    mat_pri = 6,

    wall  = "MONK02",
    floor = "F_059",  -- F_011
    ceil  = "F_037",

    scenery = "brass_brazier",
    sc_fabs = { pillar_rnd_PILLAR02=50, pillar_wide_MONK03=40, other=30 }
  }

  VILLAGE4 =
  {
    theme_probs = { VILLAGE=50 }
    mat_pri = 6,
    outdoor = true,

    wall  = "MONK15",
    floor = "F_029",
    ceil  = "F_029",

    pillar = "PILLAR01",
    scenery = "brass_brazier",
  }

  VILLAGE5 =
  {
    theme_probs = { VILLAGE=50 }
    mat_pri = 6,
    outdoor = true,

    wall  = "CASTLE07",
    floor = "F_057",
    ceil  = "F_057",

    scenery = "banner",
  }

  VILLAGE6 =
  {
    theme_probs = { VILLAGE=50 }
    mat_pri = 4,
    outdoor = true,

    wall  = "PRTL02",
    floor = "F_044",
    ceil  = "F_044",

    scenery = "gargoyle_short",
  }
  
}

HEXEN.EXITS =
{
  STEEL =
  {
    mat_pri = 9,

    wall = "STEEL01",
    void = "STEEL02",

    floor = "F_022",
    ceil  = "F_044",

    switch = { switch="SW_2_UP", wall="STEEL06", h=64 }

    door = { wall="FIRE14", w=64,  h=128 }
  }

}

HEXEN.HALLWAYS =
{
  -- FIXME !!! hallway themes
}


---- PEDESTALS ------------

HEXEN.PEDESTALS =  -- NOTE: THIS IS OLD STUFF, TO BE REMOVED...
{
  PLAYER =
  {
    wall = "T2_STEP", void = "FIRE06",
    floor = "F_062",  ceil = "F_062",  -- TODO: F_061..F_064
    h = 8,
  }

  QUEST =
  {
    wall = "T2_STEP", void = "FIRE06",
    floor = "F_042",  ceil = "F_042",
    h = 8,
  }

  WEAPON =
  {
    wall = "T2_STEP", void = "FIRE06",
    floor = "F_091",  ceil = "F_091",
    h = 8,
  }

}

---- OVERHANGS ------------

HEXEN.OVERHANGS =
{
  WOOD =
  {
    ceil = "F_054",
    upper = "D_WD07",
    thin = "WOOD01",
  }
}


---- MISC STUFF ------------

HEXEN.LIQUIDS =
{
  -- water and muck sometimes flow in a direction, but I'll leave that to 
  -- later code development (and a hopefully randomized special adds per sector).
  water  = { mat="X_005", light=0.00, sec_kind=0 },
  muck   = { mat="X_009", light=0.00, sec_kind=0 },
  lava   = { mat="X_001", light=0.75, sec_kind=0 }, -- 20% damage (Hexen uses image, not sec_knid for this)
  
  -- Ice isn't really a liquid, but may be placed like one in some ice levels
  icefloor = { mat="F_033", light=0.00, sec_kind=0 },
}


HEXEN.SWITCHES =  -- NOTE: THIS IS OLD STUFF, TO BE REMOVED...
{
  sw_cow =
  {
    switch =
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

    door =
    {
      w=128, h=128,
      prefab = "DOOR", -- DOOR_LOCKED
      skin =
      {
        door_w="STEEL01", door_c="F_074",
--      key_w="STEEL06",
        door_h=128,
        door_kind=0, tag=0,

---     step_w="STEP1",  track_w="DOORTRAK",
---     frame_f="FLAT1", frame_c="FLAT1",
      }
    }
  }

  sw_ball =
  {
    switch =
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

    door =
    {
      w=128, h=128,
      prefab = "DOOR", -- DOOR_LOCKED
      skin =
      {
        door_w="MONK17", door_c="F_014",
        door_h=128,
        door_kind=0, tag=0,
      }
    }
  }

  sw_sheep =
  {
    switch =
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

    door =
    {
      w=128, h=128,
      prefab = "DOOR", -- DOOR_LOCKED
      skin =
      {
        door_w="FOREST03", door_c="F_017",
        door_h=128,
        door_kind=0, tag=0,
      }
    }
---#    door =
---#    {
---#      w=128, h=128,
---#      prefab = "DOOR", -- DOOR_LOCKED
---#      skin =
---#      {
---#        door_w="MONK08", door_c="F_027",
---#        door_h=128,
---#        door_kind=0, tag=0,
---#      }
---#    }
  }

  sw_demon =
  {
    switch =
    {
      prefab = "SWITCH_NICHE_TINY",
      add_mode = "wall",
      skin =
      {
        switch_w="SW51_OFF",
        switch_h=32, x_offset=0, y_offset=0,

        kind = { id=11, act="S1", args={"tag", 2 } }
      }
    }

    door =
    {
      w=128, h=128,
      prefab = "DOOR", -- DOOR_LOCKED
      skin =
      {
        door_w="PRTL06", door_c="F_013",
        door_h=128,
        door_kind=0, tag=0,
      }
    }
  }

---#  sw_chain =
---#  {
---#    switch =
---#    {
---#      prefab = "SWITCH_NICHE_HEXEN",
---#      add_mode = "wall",
---#      skin =
---#      {
---#        switch_w="SW_OL5",
---#        switch_h=32, x_offset=0, y_offset=0,
---#
---#        kind = { id=11, act="S1", args={"tag", 2 } }
---#      }
---#    }
---#
---#    door =
---#    {
---#      w=128, h=128,
---#      prefab = "DOOR", -- DOOR_LOCKED
---#      skin =
---#      {
---#        door_w="STEEL07", door_c="F_066",
---#        door_h=128,
---#        door_kind=0, tag=0,
---#      }
---#    }
---#  }

  sw_moon =
  {
    switch =
    {
      prefab = "SWITCH_FLOOR_TINY_PED",
      add_mode = "island",
      skin =
      {
        switch_w="SW52_OFF", side_w="FIRE06", ped_w="FIRE06",
        switch_f="F_012", ped_f="F_012",
        switch_h=32, x_offset=0, y_offset=0,

        kind = { id=11, act="S1", args={"tag", 2 } }
      }
    }

    door =
    {
      w=128, h=128,
      prefab = "DOOR", -- DOOR_LOCKED
      skin =
      {
        door_w="CLOCKA", door_c="F_010",
        door_h=128,
        door_kind=0, tag=0,
      }
    }
  }
}

HEXEN.DOORS =
{
  d_big2   = { prefab="DOOR", w=128, h=128,

               skin =
               {
                 door_w="DOOR51", door_c="F_009",
                 track_w="STEEL08",
                 door_h=128,

---              lite_w="LITE5", step_w="STEP1",
---              frame_f="FLAT1", frame_c="TLITE6_6",
               }
             }

--[[ !!!
  d_big    = { wall="DOOR51",   w=128, h=128 }
  d_brass1 = { wall="BRASS1",   w=128, h=128 }
  d_brass2 = { wall="D_BRASS2", w=64,  h=128 }

  d_wood1  = { wall="D_WD07",   w=128, h=128 }
  d_wood2  = { wall="D_WD08",   w=64,  h=128 }
--]]

  d_wood3  = { wall="D_WD10",   w=64,  h=128 }
}

HEXEN.KEY_DOORS =  -- NOTE: THIS IS OLD STUFF, TO BE REMOVED...
{
  k_emerald =
  {
    w=128, h=128,
    prefab = "DOOR", -- DOOR_LOCKED
    skin =
    {
      door_w="D_CAST", door_c="F_009",
      track_w="STEEL08", frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 5} }
      tag=0,
    }
  }

  k_fire =
  {
    w=128, h=128,

    prefab = "DOOR", -- DOOR_LOCKED

    skin =
    {
      door_w="D_FIRE", door_c="F_009",
      track_w="STEEL08",
      frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 4} }
      tag=0,
    }
  }

  k_castle =
  {
    w=128, h=128,

    prefab = "DOOR", -- DOOR_LOCKED

    skin =
    {
      door_w="CASTLE06", door_c="F_009",  --FIXME !!!!  castle door
      track_w="STEEL08",
      frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 11} }
      tag=0,
    }
  }

  k_silver =
  {
    w=128, h=128,

    prefab = "DOOR", -- DOOR_LOCKED

    skin =
    {
      door_w="D_SILVER", door_c="F_009",
      track_w="STEEL08",
      frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 7} }
      tag=0,
    }
  }

  k_cave =
  {
    w=128, h=128,
    prefab = "DOOR", -- DOOR_LOCKED
    skin =
    {
      door_w="D_CAVE2", door_c="F_009",
      track_w="STEEL08", frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 2} }
      tag=0,
    }
  }

  k_swamp =
  {
    w=128, h=128,
    prefab = "DOOR", -- DOOR_LOCKED
    skin =
    {
      door_w="D_SWAMP2", door_c="F_009",
      track_w="STEEL08", frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 10} }
      tag=0,
    }
  }

  k_steel =
  {
    w=128, h=128,
    prefab = "DOOR", -- DOOR_LOCKED
    skin =
    {
      door_w="D_STEEL", door_c="F_009",
      track_w="STEEL08", frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 1} }
      tag=0,
    }
  }

  k_rusty =
  {
    w=128, h=128,
    prefab = "DOOR", -- DOOR_LOCKED
    skin =
    {
      door_w="D_RUST", door_c="F_009",
      track_w="STEEL08", frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 8} }
      tag=0,
    }
  }

  k_dungeon =
  {
    w=128, h=128,
    prefab = "DOOR", -- DOOR_LOCKED
    skin =
    {
      door_w="D_DUNGEO", door_c="F_009",
      track_w="STEEL08", frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 6} }
      tag=0,
    }
  }

  k_horn =
  {
    w=128, h=128,
    prefab = "DOOR", -- DOOR_LOCKED
    skin =
    {
      door_w="D_WASTE", door_c="F_009",
      track_w="STEEL08", frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 9} }
      tag=0,
    }
  }

  k_axe =
  {
    w=128, h=128,
    prefab = "DOOR", -- DOOR_LOCKED
    skin =
    {
      door_w="D_AXE", door_c="F_009",
      track_w="STEEL08", frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 3} }
      tag=0,
    }
  }

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


HEXEN.ROOMS =
{
  PLAIN =
  {
  }

  HALLWAY =
  {
    room_heights = { [96]=50, [128]=50 }
    door_probs   = { out_diff=75, combo_diff=50, normal=5 }
    window_probs = { out_diff=1, combo_diff=1, normal=1 }
    space_range  = { 20, 65 }
  }
 
  SCENIC =
  {
  }

  -- TODO: check in-game level names for ideas
}


HEXEN.THEME_DEFAULTS =
{
  starts = { Start_basic = 50 }

  exits = { Exit_switch = 50 }

  stairs = { Stair_Up1 = 50, Stair_Down1 = 50,
              Lift_Up1 = 1,   Lift_Down1 = 1 }

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

  switches = { sw_steel = 50 }

  switch_fabs = { Switch_1 = 50 }

  locked_doors = { Locked_axe = 50, Locked_cave = 50, Locked_castle = 50,
                   Locked_dungeon = 50, Locked_emerald = 50, Locked_fire = 50,
                   Locked_horn = 50, Locked_rusty = 50, Locked_silver = 50,
                   Locked_swamp = 50, Locked_steel = 50,
                   Door_SW_1 = 50 }

  -- TODO everything else
}


HEXEN.NAME_THEMES =
{
  -- TODO
}


HEXEN.ROOM_THEMES =
{
  -- This is the monestary / palacial castle type dungeon

  Dungeon1_room =
  {
    walls =
    {
      MONK01=30, MONK02=40, MONK03=15, MONK07=15, 
      MONK14=15, MONK15=15, MONK16=15, TOMB05=15, 
      MONK17=2, MONK18=2, MONK19=2, MONK21=1, 
      MONK22=1, WASTE04=5, FOREST01=12, FOREST05=8, 
      WINN01=12, PRTL02=12, PRTL04=12, PRTL05=10, 
      VILL01=7,
    }

    floors =
    {
      F_010=10, F_011=20, F_012=8, F_014=8, 
      F_025=15, F_028=10, F_029=10, F_030=10, F_033=10,
      F_031=12, F_041=3, F_042=8, F_043=4, F_044=5,   
      F_046=12, F_047=9, F_048=9, F_057=5, F_059=10,  
      F_073=3, F_077=10, F_089=12, F_092=2,
    }

    ceilings =
    {
      F_010=10, F_011=20, F_012=8, F_014=8, 
      F_025=15, F_028=10, F_029=10, F_030=10, F_033=10,
      F_031=12, F_041=3, F_042=8, F_043=4, F_044=5,   
      F_046=12, F_047=9, F_048=9, F_057=5, F_059=10,  
      F_073=3, F_077=2, F_089=2, F_081=4, F_092=2,
    }
  }

  Dungeon1_cave =
  {
    naturals =
    {
      CAVE03=20, CAVE04=25, CAVE06=15, 
      CAVE05=30, WASTE02=15
    }
  }

  Dungeon1_outdoors =
  {
    floors =
    {
      F_024=25, F_034=50, F_001=10, F_002=10,
      F_004=15, F_005=15, F_010=2, F_011=4, 
      F_025=3, F_028=2, F_029=2, F_030=2, F_031=2,
      F_046=2, F_047=2, F_048=2, F_057=1, F_059=2,    
      F_077=2, F_089=2, F_012=2, F_014=2
    }

    naturals =
    {
      WASTE02=50, WASTE01=20, CAVE05=40
    }
  }

  Dungeon1_hallway =
  {
    walls =
    {
      -- Hexen hallways are not really done differently from rooms
      MONK01=30, MONK02=40, MONK03=15, MONK07=15, 
      MONK14=15, MONK15=15, MONK16=15,
      FOREST01=12, TOMB05=4, WINN01=12,
      PRTL02=12,
    }

    floors =
    {
      F_010=10, F_011=20, F_012=8, F_014=8, 
      F_025=15, F_028=10, F_029=10, F_030=10, F_033=10,
      F_031=12, F_041=3, F_042=8, F_043=4, F_044=5,  
      F_046=12, F_047=9, F_048=9, F_057=5, F_059=10,  
      F_073=3, F_077=10, F_089=12, F_092=2,
    }

    ceilings =
    {
      F_010=10, F_011=20, F_012=8, F_014=8, 
      F_025=15, F_028=10, F_029=10, F_030=10, F_033=10,
      F_031=12, F_041=3, F_042=8, F_043=4, F_044=5,  
      F_046=12, F_047=9, F_048=9, F_057=5, F_059=10,  
      F_073=3, F_077=2, F_089=2, F_092=2,
    }
  }


  -- This is the dark, dank dungeon type of crumbling castles, cemetaries, 
  -- crypts, sewers, and of course, dungeons.

  Dungeon2_room =
  {
    walls =
    {
      -- First, common castle / sewer (hub 4) patterns that should be used a lot
      CASTLE01=20, CASTLE07=35, CASTLE11=10, CAVE01=8, 
      CAVE02=10, CAVE07=5, FOREST02=5, PRTL03=12, MONK07=10,
      SEWER01=15, SEWER07=15, SEWER08=15, WINN01=5,
    
      -- Next, some novelty patterns that should be used rarely
      CASTLE02=1, CASTLE06=1, SEWER12=1, X_SWR1=1,
      CASTLE08=1, CASTLE09=1, SEWER02=3, SEWER05=1, 
      SEWER06=1, SEWER09=1, SEWER10=1, SEWER11=1, 
    
      -- Finally, tomb / grave patterns (hub 5) both common and rare
      TOMB04=15, TOMB07=15, TOMB08=3, 
      TOMB11=10, GRAVE01=2, TOMB05=15, 
    }

    floors =
    {
      F_008=10, F_009=10, F_012=10, F_013=10, 
      F_015=10, F_017=10, F_018=10, F_021=5, 
      F_022=10, F_023=2, F_027=10, F_030=10, 
      F_031=5, F_038=2, F_042=5, F_044=10, 
      F_045=5, F_057=10, F_058=10, F_059=10, 
      F_073=10, F_076=10, F_033=10
    }

    ceilings =
    {
      F_008=10, F_009=10, F_012=10, F_013=10, 
      F_015=10, F_017=10, F_018=10, F_021=5, 
      F_022=10, F_023=2, F_027=10, F_030=10, 
      F_031=5, F_038=2, F_042=5, F_044=10, 
      F_045=5, F_057=10, F_058=10, F_059=10, 
      F_073=10, F_076=10, F_033=10
    }

    __corners =
    {
      CASTLE01=20, CASTLE07=35, CASTLE11=10, CAVE01=8, 
      CAVE02=10, CAVE07=5, FOREST02=5, PRTL03=12, 
      SEWER01=15, SEWER07=15, SEWER08=15, TOMB04=15, 
      TOMB05=15, TOMB07=15, TOMB11=10, GRAVE01=10, D_END3=10,
      D_END4=15, D_END2=5
    }

  }

  Dungeon2_cave =
  {
    naturals =
    {        
      CAVE03=20, CAVE04=20, CAVE05=15, CAVE06=20, 
      WASTE02=15, FOREST02=30
    }
  }

  Dungeon2_outdoors =
  {
    floors =
    {
      F_024=25, F_034=50, F_001=10, F_002=10,
      F_004=15, F_005=15, 

      F_008=2, F_009=2, F_012=2, F_013=2, 
      F_015=2, F_017=2, F_018=2, F_021=1, 
      F_022=2, F_027=2, F_030=2, 
      F_031=1, F_038=10, F_042=1, F_044=2, 
      F_045=1, F_057=2, F_058=2, F_059=2, 
      F_073=2, F_076=2
    }

    naturals =
    { 
      WASTE02=30, FOREST02=10 
    }
  }

  Dungeon2_hallway =
  {
    walls =
    {
      CASTLE01=20, CASTLE07=35, CASTLE11=10, CAVE01=8, 
      CAVE02=10, CAVE07=5, FOREST02=5, PRTL03=12, 
      SEWER01=15, SEWER07=15, SEWER08=15, TOMB04=15, 
      TOMB05=15, TOMB07=15, TOMB11=10, GRAVE01=10, MONK07=10     
    }

    floors =
    {
      F_008=10, F_009=10, F_012=10, F_013=10, 
      F_015=10, F_017=10, F_018=10, F_021=5, 
      F_022=10, F_023=2, F_027=10, F_030=10, 
      F_031=5, F_038=2, F_042=5, F_044=10, 
      F_045=5, F_057=10, F_058=10, F_059=10, 
      F_073=10, F_076=10, F_033=10
    }

    ceilings =
    {
      F_008=10, F_009=10, F_012=10, F_013=10, 
      F_015=10, F_017=10, F_018=10, F_021=5, 
      F_022=10, F_023=2, F_027=10, F_030=10, 
      F_031=5, F_038=2, F_042=5, F_044=10, 
      F_045=5, F_057=10, F_058=10, F_059=10, 
      F_073=10, F_076=10, F_033=10
    }
  }


  -- This is the element fire, as in "The Guardian or Fire" in Raven's original wad.

  Fire_room =
  {
    walls =
    {
      FIRE01=30, FIRE04=4, FIRE05=10, FIRE06=15, 
      FIRE07=15, FIRE08=10, FIRE09=10, FIRE10=10, 
      FIRE11=10, FIRE12=10, X_FIRE01=1
    }

    floors =
    {
      F_013=25, F_032=25, F_040=15, F_044=4, F_082=15
    }

    ceilings =
    {
      F_013=25, F_032=25, F_040=15, F_044=4, F_082=15
    }

    __corners =
    {
      FIRE01=30, FIRE04=5, FIRE05=10, FIRE06=15, 
      FIRE07=15, FIRE08=10, FIRE09=10, FIRE10=10, 
      FIRE11=10, FIRE12=10, X_FIRE01=30
    }
  }

  Fire_cave =
  {
    naturals =
    {
      FIRE01=60, CAVE03=10, CAVE04=10, CAVE05=10, CAVE06=10, 
    }
  }

  Fire_outdoors =
  {
    floors =
    {
      F_013=5, F_032=30, F_040=25, F_044=4, F_082=20
    }

    naturals =
    {
      FIRE01=30, FIRE04=5, FIRE05=10, FIRE06=15, 
      FIRE07=15, FIRE08=10, FIRE09=10, FIRE10=10, 
      FIRE11=10, FIRE12=10
    }
  }

  Fire_hallway =
  {
    walls =
    {
      FIRE01=30, FIRE04=5, FIRE05=10, FIRE06=15, 
      FIRE07=15, FIRE08=10, FIRE09=10, FIRE10=10, 
      FIRE11=10, FIRE12=10
    }

    floors =
    {
      F_013=25, F_032=25, F_040=15, F_044=4, F_082=15
    }

    ceilings =
    {
      F_013=25, F_032=25, F_040=15, F_044=4, F_082=15
    }
  }


  -- This is the "element" ice

  Ice_room =
  {
    walls =
    {
      ICE01=15, ICE02=30, ICE03=5, ICE06=25
    }
    
    floors =
    {
      F_013=40, F_033=15, F_040=30
    }
    
    ceilings =
    {
      F_013=40, F_033=15, F_040=30
    }

    __corners =
    {
      ICE01=15, ICE02=30, ICE03=5, ICE06=25
    }
  }

  Ice_cave =
  {
    naturals =
    {
      ICE01=75, ICE06=25
    }
  }

  Ice_outdoors =
  {
    floors =
    {
      F_013=15, F_033=40, F_040=30
    }

    naturals =
    {
      ICE01=45, ICE02=30, ICE03=5, ICE06=25
    }
  }

  Ice_hallway =
  {
    walls =
    {
      ICE01=15, ICE02=30, ICE03=5, ICE06=25
    }
    
    floors =
    {
      F_013=40, F_033=15, F_040=30
    }

    ceilings =
    {
      F_013=40, F_033=15, F_040=30
    }
  }


  -- This is the "element" steel, as in "The Guardian or Steel" in Raven's original wad.

  Steel_room =
  {
    walls =
    {
      STEEL01=40, STEEL02=10, STEEL05=10, 
      STEEL06=15, STEEL07=5, STEEL08=5
    }

    floors =
    {
      F_065=10, F_066=10, F_067=10, F_068=10, 
      F_069=15, F_070=15, F_073, F_074=40, 
      F_075=15, F_078=10
    }

    ceilings =
    {
      F_065=10, F_066=10, F_067=10, F_068=10, 
      F_069=15, F_070=15, F_073, F_074=40, 
      F_075=15, F_078=10
    }

    __corners =
    {
      STEEL01=40, STEEL02=10, STEEL05=10, 
      STEEL06=15, STEEL07=5, STEEL08=5
    }
  }

  Steel_cave =
  {
    naturals =
    {
      STEEL01=40, STEEL02=10, STEEL05=10, 
      STEEL06=15, STEEL07=5, STEEL08=5
    }
  }

  Steel_outdoors =
  {
    floors =
    {
      F_065=10, F_066=10, F_067=10, F_068=10, 
      F_069=15, F_070=15, F_073, F_074=40, 
      F_075=15, F_078=10
    }

    naturals =
    {
      STEEL01=40, STEEL02=10, STEEL05=10, 
      STEEL06=15, STEEL07=5, STEEL08=5
    }
  }

  Steel_hallway =
  {
    walls =
    {
      STEEL01=40, STEEL02=10, STEEL05=10, 
      STEEL06=15, STEEL07=5, STEEL08=5
    }

    floors =
    {
      F_065=10, F_066=10, F_067=10, F_068=10, 
      F_069=15, F_070=15, F_073, F_074=40, 
      F_075=15, F_078=10
    }

    ceilings =
    {
      F_065=10, F_066=10, F_067=10, F_068=10, 
      F_069=15, F_070=15, F_073, F_074=40, 
      F_075=15, F_078=10
    }
  }


  -- This is the barren, deserty wildness, based on "The Wasteland" in Raven's original wad.

  Wild1_room =
  {
    walls =
    {
      WASTE01=15, WASTE02=10, WASTE04=10, WASTE03=5,
      FOREST01=25, MONK16=15, WOOD01=5, VILL01=5, 
      VILL04=10, VILL05=10,
    }
    
    floors =
    {
      F_002=10, F_003=10, F_004=5, F_037=20,
      F_029=20, F_044=15, F_082=10
    }

    ceilings =
    {
      F_037=20, F_029=20, F_044=15, F_082=10,
      D_END3=27, D_END4=3
    }

    __corners =
    {
      WOOD01=50, WASTE04=10, WASTE03=10
    }
  }

  Wild1_cave =
  {
    naturals =
    {
      WASTE01=35, WASTE02=15, WASTE04=10, WASTE03=5
    }
  }

  Wild1_outdoors =
  {
    floors =
    {
      F_002=25, F_003=25, F_004=10, F_005=5, F_037=20
    }

    naturals =
    {
      WASTE01=35, WASTE02=15, WASTE04=10, WASTE03=5
    }
  }

  Wild1_hallway =
  {
    walls =
    {
      WASTE01=35, WASTE02=15, WASTE04=10, WASTE03=5
    }

    floors =
    {
      F_002=25, F_003=25, F_004=10, F_005=5, F_037=20
    }

    ceilings =
    {
      F_002=5, F_003=5, F_004=5, F_005=0, F_037=50
    }
  }


  -- This is the cave type wildness

  Cave1_room =
  {
    walls =
    { -- In the caves, even rooms may have cave ways, being carved from solid rock
      CAVE01=20, CAVE02=20, CAVE03=20, 
      CAVE05=15, CAVE07=15, WASTE02=10
    }

    floors =
    {
      F_007=20, F_008=5, F_039=75, F_040=40, 
      F_073=10, F_076=15
    }

    ceilings =
    {
      F_039=75, F_040=40, 
      F_073=10, F_076=15
    }

    __corners =
    { 
      PILLAR01=20, WOOD01=15, WOOD03=15,
      D_END3=50, D_END4=5
    }
  }

  Cave1_cave =
  {
    naturals =
    {        
      CAVE03=20, CAVE04=40, CAVE05=15, CAVE06=60, 
      WASTE02=15
    }
  }

  Cave1_outdoors =
  {
    floors =
    {
      F_007=10, F_039=75, F_040=40, 
      F_073=10, F_076=10
    }

    naturals =
    {        
      CAVE03=20, CAVE04=40, CAVE05=15, WASTE02=25
    }
  }


  -- This is the swamp-type wilderness

  Swamp1_room =
  {
    walls =
    {
      SWAMP01=20, SWAMP03=20, SWAMP04=20, VILL01=10, VILL02=10,
      WOOD01=5, WOOD02=5, WOOD03=15, FOREST07=10
    }

    floors =
    {  -- Had considered using flat x_09 (muck) as a floor; see note in style_list below.
      F_017=10, F_018=10, F_019=20, F_020=15,
      F_054=10, F_055=10, F_092=5
    }

    ceilings =
    {
      F_017=10, F_018=10, F_019=20, F_020=15,
      F_054=10, F_055=10, F_092=5
    }

    __corners =
    {
      SWAMP01=20, SWAMP03=20, SWAMP04=20, VILL01=10, VILL02=10,
      WOOD01=25, WOOD02=25, WOOD03=35
    }
  }

  Swamp1_cave =
  {
    naturals =
    {
      SWAMP01=20, SWAMP03=20, SWAMP04=20, FOREST07=10,            
      CAVE03=10, CAVE04=10, CAVE05=10, CAVE06=10, 
      WASTE02=5      
    }
  }

  Swamp1_outdoors =
  {
    floors =
    {  -- Had considered using flat x_09 (muck) as a floor; see note in style_list below.
      F_017=5, F_018=5, F_019=10, F_020=10,
      F_054=1, F_055=1, F_092=1,
      F_005=10, F_006=10, F_007=5, 
    }

    naturals =
    {
      SWAMP01=20, SWAMP03=20, SWAMP04=20, FOREST07=10,            
      CAVE03=10, CAVE04=10, CAVE05=10, CAVE06=10, 
      WASTE02=5
    }
  }

  Swamp1_hallway =
  {
    walls =
    {
      SWAMP01=20, SWAMP03=20, SWAMP04=20, VILL01=10, VILL02=10,
      WOOD01=5, WOOD02=5, WOOD03=15, FOREST07=10
    }

    floors =
    {  -- Leaving x_09 (muck) here; works for hallways (flat floors); generic "liquids" don't (i.e., lava).
      F_017=10, F_018=10, F_019=20, F_020=15,
      F_054=10, F_055=10, F_092=5, X_009=20
    }

    ceilings =
    {
      F_017=10, F_018=10, F_019=20, F_020=15,
      F_054=10, F_055=10, F_092=5
    }
  }


  -- This is the woodland wilderness found in The Shadow Wood and Winnowing Hall;
  -- village1, bellow duplicates this fairly closely for those who like wooded villages.

  Wild4_room =
  {
    walls =
    {
      CASTLE07=15, CAVE01=15, CAVE02=15, FIRE06=5,
      FIRE07=5, FOREST01=40, FOREST02=5, FOREST03=5,
      FOREST04=5, FOREST05=5, FOREST07=5, FOREST10=15,
      PRTL03=15, VILL01=5, VILL04=10, VILL05=10, 
      WOOD01=10, WOOD02=10, WOOD03=2, 
    }

    floors =
    {
      F_014=15, F_030=15, F_047=10, F_048=10, F_038=5,
      F_054=5, F_055=5, F_076=20, F_089=20, F_092=5,
      F_005=5, F_006=5, F_007=5, F_077=10
    }

    ceilings =
    {
      F_014=15, F_030=15, F_047=10, F_048=10, F_038=2,
      F_054=5, F_055=5, F_076=20, F_089=20, F_092=5,
      F_077=10, F_081=5
    }

    __corners =
    {
      FOREST10=20, WOOD01=15, WOOD03=3
    }
  }

  Wild4_cave =
  {
    naturals =
    {
      CAVE05=30, FOREST02=25, CAVE03=20, CAVE04=15, 
      CAVE05=15, CAVE06=10, 
    }
  }

  Wild4_outdoors =
  {
    floors =
    {
      F_014=7, F_030=7, F_047=5, F_048=5, F_038=3,
      F_076=3, F_089=10,  F_005=35, F_006=45, F_007=25, 
      F_077=2
    }

    naturals =
    {
      CASTLE07=15, CAVE01=15, CAVE02=15, FIRE06=5,
      FIRE07=5, FOREST01=40, FOREST02=25, FOREST03=5,
      FOREST04=5, FOREST05=5, FOREST07=5, FOREST10=15,
      PRTL03=15, CAVE05=30, CAVE03=20, 
      CAVE04=15, CAVE05=15, CAVE06=10,
    }
  }

  Wild4_hallway =
  {
    walls =
    {
      CASTLE07=15, CAVE01=15, CAVE02=15, FIRE06=5,
      FIRE07=5, FOREST01=40, FOREST02=5, FOREST03=5,
      FOREST04=5, FOREST05=5, FOREST07=5, FOREST10=15,
      PRTL03=15, VILL01=5, VILL04=10, VILL05=10, 
      WOOD01=10, WOOD02=10, WOOD03=2, 
    }
    floors =
    {
      F_014=15, F_030=15, F_047=10, F_048=10, F_038=5,
      F_054=5, F_055=5, F_076=20, F_089=20, F_092=5,
      F_005=5, F_006=5, F_007=5, F_077=10
    }
    ceilings =
    {
      F_014=15, F_030=15, F_047=10, F_048=10, F_038=2,
      F_054=5, F_055=5, F_076=20, F_089=20, F_092=5,
      F_077=10, F_081=5
    }
  }


  -- village1

  Village1_room =
  {
    walls =
    {
      CASTLE07=15, CAVE01=15, CAVE02=15, FIRE06=5,
      FIRE07=5, FOREST01=40, FOREST02=5, FOREST03=5,
      FOREST04=5, FOREST05=10, FOREST07=5, FOREST10=15,
      PRTL03=15, VILL01=5, VILL04=10, VILL05=10, 
      WOOD01=10, WOOD02=10, WOOD03=2, 

      MONK01=30, MONK02=40, MONK03=15, MONK07=15, 
      MONK14=15, MONK15=15, MONK16=15, MONK04=10,
      MONK06=10, MONK09=10, MONK11=10, MONK12=10, 
      MONK17=8, MONK18=2, MONK19=5, MONK21=4, 
      MONK22=1, WASTE04=5, WINN01=12, 
      PRTL02=12, PRTL04=12, PRTL05=10, VILL01=7, 
      TOMB05=15,
    }

    floors =
    {
      F_014=15, F_030=15, F_047=10, F_048=10, F_038=5,
      F_054=5, F_055=5, F_076=20, F_089=20, F_092=5,
      F_005=5, F_006=5, F_007=5, F_077=10,

      F_010=10, F_011=20, F_012=8, F_014=8, 
      F_025=15, F_028=10, F_029=10, F_030=10, F_033=10,
      F_031=12, F_041=3, F_042=8, F_043=4, F_044=5,  
      F_046=12, F_047=9, F_048=9, F_057=5, F_059=10,  
      F_073=3, F_077=10, F_089=12, F_092=2,      
    }

    ceilings =
    {
      F_014=15, F_030=15, F_047=10, F_048=10, F_038=2,
      F_054=5, F_055=5, F_076=20, F_089=20, F_092=5,
      F_077=10, F_081=5
    }

    __corners =
    {
      FOREST10=20, WOOD01=15, WOOD03=5,
      PILLAR01=10, MONK01=15, MONK02=20, MONK04=10,
      MONK06=10, MONK09=10, MONK11=10, MONK12=10,
      FOREST05=10, WASTE04=5, WASTE04=3, D_END3=5,
      D_END4=5, PILLAR02=15
    }
  }

  Village1_cave =
  {
    naturals =
    {
      CAVE05=30, FOREST02=25, CAVE03=20, CAVE04=15, 
      CAVE05=15, CAVE06=15, WASTE02=15
    }
  }

  Village1_outdoors =
  {
    floors =
    {
      F_024=25, F_034=50, F_001=10, F_002=10,
      F_004=15, F_005=15, F_089=10, F_005=35, 
      F_006=45, F_007=25, 

      F_010=2, F_011=4, F_025=3, F_028=2, F_029=2, 
      F_030=2, F_031=2, F_046=2, F_047=2, F_048=2, 
      F_057=1, F_059=2, F_077=2, F_089=2, F_012=2, 
      F_014=2, F_014=7, F_030=7, F_047=5, F_048=5, 
      F_038=3, F_076=3, F_077=2
    }

    naturals =
    {
      CASTLE07=15, CAVE01=15, CAVE02=15, FIRE06=5,
      FIRE07=5, FOREST01=40, FOREST02=25, FOREST03=5,
      FOREST04=5, FOREST05=5, FOREST07=5, FOREST10=15,
      PRTL03=15, CAVE05=30, CAVE03=20, CAVE04=15, 
      CAVE05=40, CAVE06=10, WASTE02=35, WASTE01=35
    }
  }

  Village1_hallway =
  {
    walls =
    {
      CASTLE07=15, CAVE01=15, CAVE02=15, FIRE06=5,
      FIRE07=5, FOREST01=40, FOREST02=5, FOREST03=5,
      FOREST04=5, FOREST05=5, FOREST07=5, FOREST10=15,
      PRTL03=15, VILL01=5, VILL04=10, VILL05=10, 
      WOOD01=10, WOOD02=10, WOOD03=2, PRTL02=12,
      MONK01=30, MONK02=40, MONK03=15, MONK07=15, 
      MONK14=15, MONK15=15, MONK16=15,
      FOREST01=12, TOMB05=4, WINN01=12,
    }

    floors =
    {
      F_014=15, F_030=15, F_047=10, F_048=10, F_038=5,
      F_054=5, F_055=5, F_076=20, F_089=20, F_092=5,
      F_005=5, F_006=5, F_007=5, F_077=10
    }

    ceilings =
    {
      F_014=15, F_030=15, F_047=10, F_048=10, F_038=2,
      F_054=5, F_055=5, F_076=20, F_089=20, F_092=5,
      F_077=10, F_081=5
    }
  }
}


HEXEN.LEVEL_THEMES =
{
  hexen_dungeon1 =
  {
    prob = 50

    buildings = { Dungeon1_room=50 }
    caves     = { Dungeon1_cave=50 }
    outdoors  = { Dungeon1_outdoors=50 }
    hallways  = { Dungeon1_hallway=50 }

    __pictures =
    {
      pic_glass01=20, pic_glass02=2, pic_glass03=20, pic_glass04=2, 
    pic_glass05=20, pic_glass06=2, pic_tomb03=5, pic_books01=15,
    pic_books02=15, pic_brass1=10, pic_tomb06=10, pic_forest11=5,
    pic_monk08=5, pic_planet1=5, pic_monk06=5, pic_monk11=5, 
    pic_spawn13=2, 
    }

    -- FIXME: other stuff

    monster_prefs =
    {
      bishop=3.0, centaur1=2.0, centaur2=1.5
    }
  }


  hexen_dungeon2 =
  {
    prob = 50

    liquids = { water=25, muck=70, icefloor=5 }
  
    buildings = { Dungeon2_room=50 }
    caves     = { Dungeon2_cave=50 }
    outdoors  = { Dungeon2_outdoors=50 }
    hallways  = { Dungeon2_hallway=50 }

    facades =
    {
      CASTLE01=10, CASTLE07=35, CASTLE11=10, CAVE01=10, 
      CAVE02=15, PRTL03=15, SEWER01=10, SEWER07=10, 
      SEWER08=10, WINN01=7, TOMB05=5, TOMB04=3, MONK07=10
    }
  
    __pictures =
    {
      Pic_forest11=10, Pic_monk08=10, Pic_winnow02=10, 
      Pic_spawn13=5, Pic_fire14=5, Pic_books01=1,
      Pic_glass01=1, Pic_glass03=1, Pic_glass05=1
    }

    -- FIXME: other stuff

    monster_prefs =
    {
      centaur1=3.0, centaur2=3.0, reiver=2.5
    }

    style_list =
    {
      naturals = { none=30, few=70, some=20,  heaps=0 }
      outdoors = { none=50, few=50, some=20,  heaps=0 }
    }
  }
  

  hexen_element1 =
  {
    prob = 20

    liquids = { lava=100 }

    buildings = { Fire_room=50 }
    caves     = { Fire_cave=50 }
    outdoors  = { Fire_outdoors=50 }
    hallways  = { Fire_hallway=50 }

    __pictures =
    {
      pic_forest11=5, pic_fire14=20, pic_spawn13=3,
      pic_winnow02=5, pic_brass1=2, pic_monk06=2, pic_monk11=21,
      pic_glass01=1, pic_glass03=1, pic_glass05=1
    }

    __big_pillars = { pillar02=10, fire06=25, xfire=15 }

    __outer_fences = 
    {
      FIRE01=30, FIRE04=5, FIRE05=10, FIRE06=15, 
      FIRE07=15, FIRE08=10, FIRE09=10, FIRE10=10, 
      FIRE11=10, FIRE12=10
    }

    style_list =
    {
      naturals = { none=30, few=70,  some=30,  heaps=0  }
      outdoors = { none=70, few=5,   some=0,   heaps=0  }
      liquids  = { none=0,  few=10,  some=60,  heaps=40 }
      lakes    = { none=0,  few=10,  some=60,  heaps=40 }
    }
  }
  

  hexen_element2 =
  {
    prob = 20

    liquids = { icefloor=100 } -- ice1 will use "liquids = { ice=70, water=30 }" instead, for variety.
  
    buildings = { Ice_room=50 }
    caves     = { Ice_cave=50 }
    outdoors  = { Ice_outdoors=50 }
    hallways  = { Ice_hallway=50 }

    __pictures =
    {
      pic_forest11=10, pic_spawn13=10, 
    }

    __big_pillars = { ice01=5, ice02=20 }

    __outer_fences = 
    {
      ICE01=25, ICE06=75
    }

    style_list =
    {
      naturals = { none=30, few=70,  some=30,  heaps=0  }
      outdoors = { none=70, few=5,   some=0,   heaps=0  }
      liquids  = { none=0,  few=10,  some=60,  heaps=40 }
      lakes    = { none=0,  few=0,   some=40,  heaps=60 }
      pictures = { none=50, few=10,  some=10,  heaps=0  }
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

    buildings = { Steel_room=50 }
    caves     = { Steel_cave=50 }
    outdoors  = { Steel_outdoors=50 }
    hallways  = { Steel_hallway=50 }

    __big_pillars = { steel01=10, steel02=10, steel06=10, steel07=10 }

    __outer_fences = 
    {
      STEEL01=40, STEEL02=10, STEEL05=10, 
      STEEL06=15, STEEL07=5, STEEL08=5
    }

    style_list =
    {
      naturals = { none=70, few=30,  some=5,  heaps=0 }
      outdoors = { none=70, few=5,   some=0,  heaps=0 }
      liquids  = { none=40, few=60,  some=10, heaps=0 }
      lakes    = { none=60, few=40,  some=0,  heaps=0 } -- I don't think this is need, but to be safe...
      pictures = { none=50, few=0,   some=0,  heaps=0 }
    }
  }
  
    
  hexen_wild1 =
  {
    prob = 20

    liquids = { water=30, muck=40, lava=20 }

    buildings = { Wild1_room=50 }
    caves     = { Wild1_cave=50 }
    outdoors  = { Wild1_outdoors=50 }
    hallways  = { Wild1_hallway=50 }

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
      naturals = { none=0,  few=0,  some=30,  heaps=70 }
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
    prob = 20

    liquids = { water=60, muck=10, lava=25 }

    buildings = { Cave1_room=50 }
    caves     = { Cave1_cave=50 }
    outdoors  = { Cave1_outdoors=50 }

    __pictures =
    {
      pic_forest11=10, pic_monk08=10, pic_winnow02=10, 
      pic_spawn13=4, pic_fire14=5, 
    }

    __big_pillars =
    { 
      monk14=10, castle07=5, prtl02=5, fire06=10
    }

    __outer_fences = { CAVE03=20, CAVE04=40, CAVE05=15, WASTE02=25 }

    style_list =
    {
      naturals = { none=0,  few=0,  some=30, heaps=70 }
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
    prob = 20

    liquids = { muck=100 }  -- for whole mulit-level swamp1 theme this will be "liquids = { muck=80, water 20 }"
  
    buildings = { Swamp1_room=50 }
    caves     = { Swamp1_cave=50 }
    outdoors  = { Swamp1_outdoors=50 }
    hallways  = { Swamp1_hallway=50 }

    __pictures =
    {
      pic_forest11=10, pic_monk08=2, pic_winnow02=3, pic_spawn13=5,
      pic_books01=3, pic_books02=2
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
      naturals = { none=0, few=5, some=80, heaps=10  }
      outdoors = { none=0, few=5, some=80, heaps=10  }
  --   I had considered including flat x_09 (muck) as a floor texture, and not using
  --  liquids, but realized this would likely produce diases of muck, ect.  We need 
  --  officially transversable liquids for this theme to really work.  
      liquids  = { none=0, few=0, some=0,  heaps=100 }
      lakes    = { none=0, few=0, some=0,  heaps=100 }
    }
  
    monster_prefs =
    {
      -- need high values just to make them appear
      serpent1=5000, serpent2=3000
    }
  }

  
  hexen_wild4 =
  {
    prob = 40

    liquids = { water=60, muck=15, lava=10 }
  
    buildings = { Wild4_room=50 }
    caves     = { Wild4_cave=50 }
    outdoors  = { Wild4_outdoors=50 }
    hallways  = { Wild4_hallway=50 }

    __pictures =
    {
      pic_glass01=10, pic_glass02=10, pic_glass03=10, pic_forest11=10,
      pic_monk08=5, pic_winnow02=10, pic_spawn13=3,
      pic_books01=2, pic_books02=1
    }

    __big_pillars =
    { 
      vill01=5, wood01=15, wood02=5, forest01=25,
      pillar01=10, pillar02=5, prtl02=20, monk15=10,
      castle07=5
    }
  
    style_list =
    {
      naturals   = { none=0, few=5,  some=50, heaps=10 }
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

    buildings = { Cave1_room=50 }
    caves     = { Cave1_cave=50 }
    outdoors  = { Cave1_outdoors=50 }
    hallways  = { Cave1_hallway=50 }

    __pictures =
    {
      pic_forest11=10, pic_monk08=10, pic_winnow02=10, 
      pic_spawn13=4, pic_fire14=5, 
    }

    __big_pillars =
    { 
      monk14=10, castle07=5, prtl02=5, fire06=10
    }

    __outer_fences = { CAVE03=20, CAVE04=40, CAVE05=15, WASTE02=25 }

    style_list =
    {
      naturals = { none=0,  few=0,  some=30, heaps=70 }
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
  

  hexen_ice1 =
  {
    prob = 20

    liquids = { icefloor=70, water=30 }
  
    buildings = { Ice_room=50 }
    caves     = { Ice_cave=50 }
    outdoors  = { Ice_outdoors=50 }
    hallways  = { Ice_hallway=50 }

    __pictures =
    {
      pic_forest11=10, pic_spawn13=10, 
    }

    __big_pillars = { ice01=5, ice02=20 }

    __outer_fences = 
    {
      ICE01=25, ICE06=75
    }

    style_list =
    {
      naturals = { none=30, few=70,  some=30,  heaps=0  }
      outdoors = { none=70, few=5,   some=0,   heaps=0  }
      liquids  = { none=0,  few=10,  some=60,  heaps=40 }
      lakes    = { none=0,  few=0,   some=40,  heaps=60 }
      pictures = { none=50, few=10,  some=10,  heaps=0  }
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
  
    buildings = { Swamp1_room=50 }
    caves     = { Swamp1_cave=50 }
    outdoors  = { Swamp1_outdoors=50 }
    hallways  = { Swamp1_hallway=50 }

    __pictures =
    {
      pic_forest11=10, pic_monk08=2, pic_winnow02=3, pic_spawn13=5,
      pic_books01=3, pic_books02=2
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
      naturals = { none=0, few=5, some=80, heaps=10  }
      outdoors = { none=0, few=5, some=80, heaps=10  }
  --   I had considered including flat x_09 (muck) as a floor texture, and not using
  --  liquids, but realized this would likely produce diases of muck, ect.  We need 
  --  officially transversable liquids for this theme to really work.  
      liquids  = { none=0, few=0, some=0,  heaps=100 }
      lakes    = { none=0, few=0, some=0,  heaps=100 }
    }
  
    monster_prefs =
    {
      -- need high values just to make them appear
      serpent1=5000, serpent2=3000
    }
  }

  
  hexen_village1 =
  {
    prob = 40

    liquids = { water=60, muck=15, lava=10 }
  
    buildings = { Village1_room=50 }
    caves     = { Village1_cave=50 }
    outdoors  = { Village1_outdoors=50 }
    hallways  = { Village1_hallway=50 }

    facades =
    {
      CASTLE07=15, CAVE01=15, CAVE02=15, FIRE06=5,
      FIRE07=5, FOREST01=40, FOREST02=5, FOREST03=5,
      FOREST04=5, FOREST05=10, FOREST07=5, FOREST10=15,
      PRTL03=15, VILL01=5, VILL04=10, VILL05=10, 
      WOOD01=10, WOOD02=10, WOOD03=2,  PRTL02=12,    
      MONK01=30, MONK02=40, MONK03=15, MONK07=15, 
      MONK14=15, MONK15=15, MONK16=15, TOMB05=4
    }

    __pictures =
    {
      pic_glass01=20, pic_glass02=2, pic_glass03=20, pic_glass04=2, 
      pic_glass05=20, pic_glass06=2, pic_tomb03=5, pic_books01=15,
      pic_books02=10, pic_brass1=10, pic_tomb06=10, pic_forest11=15,
      pic_monk08=10, pic_planet1=5, pic_monk06=5, pic_monk11=5, 
      pic_winnow02=10, pic_spawn13=5, 
    }

    __big_pillars =
    {
      pillar01=20, pillar02=15, monk01=15, monk02=10,
      monk07=5, monk14=10, tomb05=5, vill01=5, 
      wood01=15, wood02=5, forest01=25, prtl02=20, 
      monk15=10, castle07=5
    }

    style_list =
    {
      naturals   = { none=0, few=5,  some=50, heaps=5 }
      outdoors   = { none=0, few=10, some=50, heaps=0 }
      subrooms   = { none=0, few=15, some=50, heaps=50 }
      islands    = { none=0, few=15, some=50, heaps=50 }
    }
  
    monster_prefs =
    {
      bishop=2.0, centaur1=1.25, afrit=2.0, etin=1.75
    }
  }
}


HEXEN.LIFTS =  -- NB: OBSOLETE
{
  slow =
  {
    kind = { id=62, act="SR", args={"tag", 16, 64} }
    walk = { id=62, act="SR", args={"tag", 16, 64} }
  }

  fast =
  {
    kind = { id=62, act="SR", args={"tag", 32, 64} }
    walk = { id=62, act="SR", args={"tag", 32, 64} }
  }
}


HEXEN.DOOR_PREFABS =  -- NB: OBSOLETE
{
  winnow =
  {
    w=128, h=128, prefab="DOOR",

    skin =
    {
      door_w="D_WINNOW", door_c="F_009",
      track_w="STEEL08",
      door_h=128,
      door_kind = { id=12, act="SR", args={0, 16, 128} }
      tag=0,
    }

--    theme_probs = { CITY=60,ICE=10,CAVE=20 }
  }

  door51 =
  {
    w=128, h=128, prefab="DOOR",

    skin =
    {
      door_w="DOOR51", door_c="F_009",
      track_w="STEEL08",
      door_h=128,
      door_kind = { id=12, act="SR", args={0, 16, 128} }
      tag=0,
    }

--    theme_probs = { CITY=60,ICE=10,CAVE=20 }
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

  pedestal_ITEM =
  {
    prefab = "PEDESTAL",
    skin = { wall="CASTLE07", floor="F_084", ped_h=12 }
  }

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
    level = 1
    prob = 60
    health = 170
    damage =  6
    attack = "melee"
  }

  afrit =
  {
    level = 1
    prob = 40
    health = 80
    damage = 20
    attack = "missile"
    float = true
  }

  centaur1 =
  {
    level = 2
    prob = 40
    health = 200
    damage = 12
    attack = "melee"
  }

  centaur2 =
  {
    -- not using 'replaces' here, centaur2 is much tougher
    level = 4
    prob = 20
    health = 250
    damage = 20
    attack = "missile"
  }

  serpent1 =
  {
    level = 3
    health = 90
    damage = 10
    attack = "melee"
  }

  serpent2 =
  {
    replaces = "serpent1"
    replace_prob = 33
    health = 90
    damage = 16
    attack = "missile"
  }

  iceguy =
  {
    level = 1
    prob = 3
    health = 120
    damage = 16
    attack = "missile"
  }

  demon1 =
  {
    level = 3
    prob = 30
    health = 250
    damage = 35
    attack = "missile"
  }

  demon2 =
  {
    replaces = "demon1"
    replace_prob = 40
    health = 250
    damage = 35
    attack = "missile"
  }

  bishop =
  {
    level = 6
    prob = 20
    health = 130
    damage = 24
    attack = "missile"
    float = true
  }

  reiver =
  {
    level = 7
    prob = 5
    health = 150
    damage = 50
    attack = "missile"
    float = true
  }


  ---| HEXEN BOSSES |---

  -- FIXME: proper damage and attack fields

  Wyvern =
  {
    health = 640
    damage = 60
    float = true
  }

  Heresiarch =
  {
    health = 5000
    damage = 70
  }

  Korax =
  {
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
    prob = 70
    cluster = { 1,4 }
    give = { {health=10} }
  }

  h_flask =
  {
    prob = 25
    give = { {health=25} }
  }

  h_urn =
  {
    prob = 5
    give = { {health=100} }
  }

  -- ARMOR --

  ar_mesh =
  {
    prob = 10
    give = { {health=150} }
    best_class = "fighter"
  }

  ar_shield =
  {
    prob = 10
    give = { {health=150} }
    best_class = "cleric"
  }

  ar_amulet =
  {
    prob = 10
    give = { {health=150} }
    best_class = "mage"
  }

  ar_helmet =
  {
    prob = 10
    give = { {health=60} }  -- rough average
  }

  -- AMMO --

  blue_mana =
  {
    prob = 20
    give = { {ammo="blue_mana",count=15} }
  }

  green_mana =
  {
    prob = 20
    give = { {ammo="green_mana",count=15} }
  }

  dual_mana =
  {
    prob = 10
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
    theme = "DUNGEON"
    sky_light = 0.65
    maps = { 1, 2, 3, 4, 5, 6 }
  }

  episode2 =
  {
    theme = "DUNGEON"
    sky_light = 0.75
    maps = { 13, 8, 9, 10, 11, 12 }
  }

  episode3 =
  {
    theme = "DUNGEON"
    sky_light = 0.50
    -- Note: map 30 is never used
    maps = { 27, 28, 31, 32, 33, 34 }
  }

  episode4 =
  {
    theme = "DUNGEON"
    sky_light = 0.75
    maps = { 21, 22, 23, 24, 25, 26 }
  }

  episode5 =
  {
    theme = "DUNGEON"
    sky_light = 0.65
    maps={ 35, 36, 37, 38, 39, 40 }
  }
}

HEXEN.THEME_LIST =
{
  "CAVE", "DUNGEON", "ICE", "SWAMP", "VILLAGE"
}

HEXEN.KEY_PAIRS =
{
  { key_A="k_emerald", key_B="k_cave" }
  { key_A="k_silver",  key_B="k_swamp" }
  { key_A="k_steel",   key_B="k_rusty" }
  { key_A="k_fire",    key_B="k_dungeon" }
  { key_A="k_horn",    key_B="k_castle" }
}


function hexen_do_get_levels(episode)

  -- NOTE: see doc/Quests.txt for structure of Hexen episodes

  local level_list = {}

  local source_levels = HEXEN.LEVELS[episode]
  assert(#source_levels == 6)

  local theme_mapping = { 1,2,3,4,5 }
  rand.shuffle(theme_mapping)

  local key_A = HEXEN.KEY_PAIRS[episode].key_A
  local key_B = HEXEN.KEY_PAIRS[episode].key_B
  assert(key_A and key_B)

  for map = 1,6 do
    local Src = source_levels[map]

    local Level =
    {
      map  = Src.map,
      name = string.format("MAP%02d", Src.map),

      episode   = episode,
      ep_along  = map,
      ep_length = 6,

      sky_info  = Src.sky_info,
      boss_kind = Src.boss_kind,

      quests = {}, gates = {}
    }

    if map == 5 or OB_CONFIG.length == "single" then
      -- secret level is a mixture
      Level.theme_probs = { ICE=3,SWAMP=4,DUNGEON=5,CAVE=6,VILLAGE=7 }
    else
      local th_name = HEXEN.THEME_LIST[theme_mapping[sel(map==6, 5, map)]]
      Level.theme_probs = { [th_name] = 5 }
    end

    table.insert(level_list, Level)
  end


  level_list[5].secret_kind = "plain"

  local b_src = rand.sel(50, 1, 3)
  local w_src = rand.sel(50, 1, 2)

  local gate_idx = 2


  local function add_assumed_weaps(quest, wp)
    if not quest.assumed_stuff then
      quest.assumed_stuff = {}
    end
    for xxx,CL in ipairs(GAME.classes) do
      table.insert(quest.assumed_stuff,
      {
        weapon = HEXEN.WEAPON_NAMES[CL][wp]
      })
    end
  end

  local function add_quest(map, kind, item, mode, force_key)
    assert(map)

    local L = level_list[map]

    local len_probs = assert(HEXEN.QUEST_LEN_PROBS[kind])

    local Quest =
    {
      kind = kind,
      item = item,
      mode = mode,
      force_key = force_key,
      want_len = 1 + rand.index_by_probs(len_probs)
    }

    if mode != "sub" then
      if map >= 3 then add_assumed_weaps(Quest, 2) end
      if map == 4 then add_assumed_weaps(Quest, 3) end
      if map == 6 then add_assumed_weaps(Quest, 3) end
      if map == 6 then add_assumed_weaps(Quest, 4) end
    end

    table.insert(L.quests, Quest)

    return Quest
  end

  local function join_map(src, dest, force_key)
    assert(src and dest)

    local Gate =
    {
      src  = level_list[src],
      dest = level_list[dest],

      src_idx  = gate_idx,
      dest_idx = gate_idx + 1,
    }

    table.insert(Gate.src.gates,  Gate)
    table.insert(Gate.dest.gates, Gate)

    gate_idx = gate_idx + 2

--  gui.debugf("Connect %d -> %d\n", src, dest)

    local fwd_mode  = "sub"
    local back_mode = "end"
    
    if src == 1 and not Gate.src.has_main then
      fwd_mode = "end"
      Gate.src.has_main = true
    end

    if dest == 6 then
      back_mode = "sub"
    end

    local F = add_quest(src,  "gate", dest, fwd_mode, force_key)
    local B = add_quest(dest, "back", src,  back_mode)

    F.gate_kind = { id=74, act="WR", args={ Gate.dest.map, 0 }}
    B.gate_kind = { id=74, act="WR", args={ Gate.src.map, Gate.src_idx }}

    F.return_args = { Gate.src_idx }

    if dest == 5 then
      F.is_secret = true
    end
  end

  local function dump_levels()
    for idx,L in ipairs(level_list) do
      gui.printf("Hexen episode [%d] map [%d] : %s\n", episode, idx, L.name)
      show_quests(L.quests)
    end
  end

  -- connections

  join_map(b_src, 6, key_A)
  join_map(w_src, 4, key_B)

  local r = rand.irange(1,5)

  join_map(sel(r==2, 2, 1), 3)
  join_map(sel(r==3, 3, 1), 2)

  add_quest(2, "key", key_A, "main")
  add_quest(3, "key", key_B, "main")

  for xxx,CL in ipairs(GAME.classes) do
    for piece = 1,3 do
      local name = assert(HEXEN.WEAPON_PIECES[CL][piece])
      add_quest(4, "weapon", name, "sub")
    end
  end

  join_map(rand.index_by_probs { 0,6,6, 4,0,2 }, 5)

  if episode == 5 then
    add_quest(6, "key", "k_axe", "main")
  end

  add_quest(6, "boss", level_list[6].boss_kind, "end")

  -- weapon quests

  for xxx,CL in ipairs(GAME.classes) do
    local weap_2 = assert(HEXEN.WEAPON_NAMES[CL][2])
    local weap_3 = assert(HEXEN.WEAPON_NAMES[CL][3])

    add_quest(rand.index_by_probs { 7, 1, 1 }, "weapon", weap_2, "sub")
    add_quest(rand.index_by_probs { 2, 7, 7 }, "weapon", weap_3, "sub")
  end

  -- item quests

  local item_list = { 
    "boots", "porkies", "repulser", "krater", -- these given twice
    "wings", "chaos", "banish",
    "servant", "incant", "defender" }

  local item_where = { 1,2,3,4,4,5,5,5,6,6 }

  assert(#item_list == #item_where)

  rand.shuffle(item_where)

  for i = 1,#item_list do
    local item  = item_list[i]
    local where = item_where[i]

    local Q = add_quest(where, "item", item, "sub")

    if rand.odds(25) then
      Q.is_secret = true
    end

    if i <= 4 and OB_CONFIG.size != "small" then
      local where2
      repeat
        where2 = rand.pick(item_where)
      until where2 != where

      add_quest(where2, "item", item, "sub")
    end
  end

  -- switch quests

  local switch_list = { "sw_demon", "sw_ball", "sw_cow",
                        "sw_sheep", "sw_moon" }

  rand.shuffle(switch_list)

  local QN_SWITCH_PROBS = { 700, 200, 40, 15, 5, 1 }
  
  for sw = 1,#switch_list do

    -- randomly select a level, preferring ones with fewest quests
    local lev_probs = {}
    for map = 1,6 do
      local qn = # level_list[map].quests
      if qn < 1 then qn = 1 end
      if qn > 6 then qn = 6 end

      lev_probs[map] = QN_SWITCH_PROBS[qn]
    end

    local map = rand.index_by_probs(lev_probs)

    add_quest(map, "switch", switch_list[sw], "main")
  end

  dump_levels()

  return level_list
end


function HEXEN.setup()

  rand.shuffle(HEXEN.KEY_PAIRS)

--  classes  = { "fighter", "cleric", "mage" }
end


function HEXEN.get_levels()

  -- FIXME: temporary stuff (linear levels)

  local EP_NUM  = (OB_CONFIG.length == "full"   ? 5 ; 1)
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

OB_GAMES["hexen"] =
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
  for_games = { hexen=1 }
  name_theme = "GOTHIC"
  mixed_prob = 50
}

OB_THEMES["hexen_element"] =
{
  label = "Elemental"
  for_games = { hexen=1 }
  name_theme = "GOTHIC"
  mixed_prob = 50
}

OB_THEMES["hexen_wild"] =
{
  label = "Wilderness"
  for_games = { hexen=1 }
  name_theme = "GOTHIC"
  mixed_prob = 50
}

OB_THEMES["hexen_cave"] =
{
  label = "Cave"
  for_games = { hexen=1 }
  name_theme = "GOTHIC"
  mixed_prob = 20
}

OB_THEMES["hexen_ice"] =
{
  label = "Ice"
  for_games = { hexen=1 }
  name_theme = "GOTHIC"
  mixed_prob = 20
}

OB_THEMES["hexen_swamp"] =
{
  label = "Swamp"
  for_games = { hexen=1 }
  name_theme = "GOTHIC"
  mixed_prob = 20
}

OB_THEMES["hexen_village"] =
{
  label = "Village"
  for_games = { hexen=1 }
  name_theme = "URBAN",
  mixed_prob = 20,
}

