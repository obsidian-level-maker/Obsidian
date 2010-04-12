----------------------------------------------------------------
-- GAME DEF : Hexen
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

HEXEN_THINGS =
{
  --- players
  player1 = { id=1, kind="other", r=16,h=64 },
  player2 = { id=2, kind="other", r=16,h=64 },
  player3 = { id=3, kind="other", r=16,h=64 },
  player4 = { id=4, kind="other", r=16,h=64 },

  dm_player     = { id=11, kind="other", r=16,h=64 },
  teleport_spot = { id=14, kind="other", r=16,h=64 },
  
  --- monsters
  ettin    = { id=10030,kind="monster", r=24,h=64 },
  afrit    = { id=10060,kind="monster", r=24,h=64 },
  demon1   = { id=31,   kind="monster", r=33,h=70 },
  demon2   = { id=8080, kind="monster", r=33,h=70 },

  iceguy   = { id=8020, kind="monster", r=24,h=80 },
  centaur1 = { id=107,  kind="monster", r=20,h=64 },
  centaur2 = { id=115,  kind="monster", r=20,h=64 },

  serpent1  = { id=121,  kind="monster", r=33,h=64 },
  serpent2  = { id=120,  kind="monster", r=33,h=64 },
  bishop    = { id=114,  kind="monster", r=24,h=64 },
  reiver    = { id=34,   kind="monster", r=24,h=64 },
  reiver_b  = { id=10011,kind="monster", r=24,h=64 },

  -- bosses
  Fighter_boss = { id=10100, kind="monster", r=16,h=64  },
  Cleric_boss  = { id=10101, kind="monster", r=16,h=64  },
  Mage_boss    = { id=10102, kind="monster", r=16,h=64  },
  Wyvern       = { id=254,   kind="monster", r=20,h=66  },
  Heresiarch   = { id=10080, kind="monster", r=40,h=120 },
  Korax        = { id=10200, kind="monster", r=66,h=120 },

  --- PICKUPS ---

  -- keys
  k_steel   = { id=8030, kind="pickup", r=8,h=16 },
  k_cave    = { id=8031, kind="pickup", r=8,h=16 },
  k_axe     = { id=8032, kind="pickup", r=8,h=16 },
  k_fire    = { id=8033, kind="pickup", r=8,h=16 },
  k_emerald = { id=8034, kind="pickup", r=8,h=16 },
  k_dungeon = { id=8035, kind="pickup", r=8,h=16 },
  k_silver  = { id=8036, kind="pickup", r=8,h=16 },
  k_rusty   = { id=8037, kind="pickup", r=8,h=16 },
  k_horn    = { id=8038, kind="pickup", r=8,h=16 },
  k_swamp   = { id=8039, kind="pickup", r=8,h=16 },
  k_castle  = { id=8200, kind="pickup", r=8,h=16 },
 
  -- weapons
  c_staff   = { id=10,  kind="pickup", r=20,h=16 },
  c_fire    = { id=8009,kind="pickup", r=20,h=16 },
  c1_shaft  = { id=20,  kind="pickup", r=20,h=16 },
  c2_cross  = { id=19,  kind="pickup", r=20,h=16 },
  c3_arc    = { id=18,  kind="pickup", r=20,h=16 },

  f_axe     = { id=8010,kind="pickup", r=20,h=16 },
  f_hammer  = { id=123, kind="pickup", r=20,h=16 },
  f1_hilt   = { id=16,  kind="pickup", r=20,h=16 },
  f2_cross  = { id=13,  kind="pickup", r=20,h=16 },
  f3_blade  = { id=12,  kind="pickup", r=20,h=16 },

  m_cone    = { id=53,  kind="pickup", r=20,h=16 },
  m_blitz   = { id=8040,kind="pickup", r=20,h=16 },
  m1_stick  = { id=23,  kind="pickup", r=20,h=16 },
  m2_stub   = { id=22,  kind="pickup", r=20,h=16 },
  m3_skull  = { id=21,  kind="pickup", r=20,h=16 },

  -- health/ammo/armor
  blue_mana  = { id=122, kind="pickup", r=20,h=16 },
  green_mana = { id=124, kind="pickup", r=20,h=16 },
  dual_mana  = { id=8004,kind="pickup", r=20,h=16 },

  ar_mesh   = { id=8005, kind="pickup", r=20,h=16 },
  ar_shield = { id=8006, kind="pickup", r=20,h=16 },
  ar_helmet = { id=8007, kind="pickup", r=20,h=16 },
  ar_amulet = { id=8008, kind="pickup", r=20,h=16 },

  h_vial  = { id=81, kind="pickup", r=20,h=16 },
  h_flask = { id=82, kind="pickup", r=20,h=16 },
  h_urn   = { id=32, kind="pickup", r=20,h=16 },

  -- artifacts
  wings = { id=83, kind="pickup", r=20,h=16 },
  chaos = { id=36, kind="pickup", r=20,h=16 },
  torch = { id=33, kind="pickup", r=20,h=16 },

  banish    = { id=10040,kind="pickup", r=20,h=16 },
  boots     = { id=8002, kind="pickup", r=20,h=16 },
  bracer    = { id=8041, kind="pickup", r=20,h=16 },
  repulser  = { id=8000, kind="pickup", r=20,h=16 },
  flechette = { id=10110,kind="pickup", r=20,h=16 },
  servant   = { id=86,   kind="pickup", r=20,h=16 },
  porkies   = { id=30,   kind="pickup", r=20,h=16 },
  incant    = { id=10120,kind="pickup", r=20,h=16 },
  defender  = { id=84,   kind="pickup", r=20,h=16 },
  krater    = { id=8003, kind="pickup", r=20,h=16 },

  --- SCENERY ---

  -- lights
  candles       = { id=119,  kind="scenery", r=20,h=20, light=255 },
  blue_candle   = { id=8066, kind="scenery", r=20,h=20, light=255 },
  fire_skull    = { id=8060, kind="scenery", r=12,h=12, light=255 },
  brass_brazier = { id=8061, kind="scenery", r=12,h=40, light=255 },

  wall_torch      = { id=54,  kind="scenery", r=20,h=48, light=255 },
  wall_torch_out  = { id=55,  kind="scenery", r=20,h=48 },
  twine_torch     = { id=116, kind="scenery", r=12,h=64, light=255 },
  twine_torch_out = { id=117, kind="scenery", r=12,h=64 },
  chandelier      = { id=17,  kind="scenery", r=20,h=60, light=255, ceil=true },
  chandelier_out  = { id=8063,kind="scenery", r=20,h=60, light=255, ceil=true },

  cauldron        = { id=8069,kind="scenery", r=16,h=32, light=255 },
  cauldron_out    = { id=8070,kind="scenery", r=16,h=32 },
  fire_bull       = { id=8042,kind="scenery", r=24,h=80, light=255 },
  fire_bull_out   = { id=8043,kind="scenery", r=24,h=80 },

  -- urbane
  winged_statue1 = { id=5,   kind="scenery", r=12,h=64 },
  winged_statue2 = { id=9011,kind="scenery", r=12,h=64 },
  suit_of_armor  = { id=8064,kind="scenery", r=16,h=72 },

  gargoyle_tall  = { id=72, kind="scenery", r=16,h=108 },
  gargoyle_short = { id=74, kind="scenery", r=16,h=64  },
  garg_ice_tall  = { id=73, kind="scenery", r=16,h=108 },
  garg_ice_short = { id=76, kind="scenery", r=16,h=64  },

  garg_corrode     = { id=8044, kind="scenery", r=16,h=108 },
  garg_red_tall    = { id=8045, kind="scenery", r=16,h=108 },
  garg_red_short   = { id=8049, kind="scenery", r=16,h=64  },
  garg_lava_tall   = { id=8046, kind="scenery", r=16,h=108 },
  garg_lava_short  = { id=8050, kind="scenery", r=16,h=64  },

  garg_bronz_tall  = { id=8047, kind="scenery", r=16,h=108 },
  garg_bronz_short = { id=8051, kind="scenery", r=16,h=64  },
  garg_steel_tall  = { id=8048, kind="scenery", r=16,h=108 },
  garg_steel_short = { id=8052, kind="scenery", r=16,h=64  },

  bell   = { id=8065, kind="scenery", r=56,h=120 },
  barrel = { id=8100, kind="scenery", r=16,h=36 },
  bucket = { id=8103, kind="scenery", r=12,h=72 },
  banner = { id=77,   kind="scenery", r=12,h=120 },

  vase_pillar = { id=103, kind="scenery", r=12,h=56 },

  -- nature
  tree1 = { id=25, kind="scenery", r=16,h=128 },
  tree2 = { id=26, kind="scenery", r=12,h=180 },
  tree3 = { id=27, kind="scenery", r=12,h=160 },

  lean_tree1 = { id=78,  kind="scenery", r=16,h=180 },
  lean_tree2 = { id=79,  kind="scenery", r=16,h=180 },
  smash_tree = { id=8062,kind="scenery", r=16,h=180 },
  xmas_tree  = { id=8068,kind="scenery", r=12,h=132 },

  gnarled_tree1 = { id=80, kind="scenery", r=24,h=96 },
  gnarled_tree2 = { id=87, kind="scenery", r=24,h=96 },

  shrub1 = { id=8101, kind="scenery", r=12,h=24 },
  shrub2 = { id=8102, kind="scenery", r=16,h=40 },

  rock1  = { id=6,  kind="scenery", r=20,h=16 },
  rock2  = { id=7,  kind="scenery", r=20,h=16 },
  rock3  = { id=9,  kind="scenery", r=20,h=16 },
  rock4  = { id=15, kind="scenery", r=20,h=16 },

  stal_pillar   = { id=48, kind="scenery", r=12,h=136 },
  stal_F_big    = { id=49, kind="scenery", r=12,h=48 },
  stal_F_medium = { id=50, kind="scenery", r=12,h=40 },
  stal_F_small  = { id=51, kind="scenery", r=12,h=40 },

  stal_C_big    = { id=52, kind="scenery", r=12,h=68 },
  stal_C_medium = { id=56, kind="scenery", r=12,h=52 },
  stal_C_small  = { id=57, kind="scenery", r=12,h=40 },

  ice_stal_F_big    = { id=93, kind="scenery", r=12,h=68 },
  ice_stal_F_medium = { id=94, kind="scenery", r=12,h=52 },
  ice_stal_F_small  = { id=95, kind="scenery", r=12,h=36 },
  ice_stal_F_tiny   = { id=95, kind="scenery", r=12,h=16 },

  ice_stal_C_big    = { id=89, kind="scenery", r=12,h=68 },
  ice_stal_C_medium = { id=90, kind="scenery", r=12,h=52 },
  ice_stal_C_small  = { id=91, kind="scenery", r=12,h=36 },
  ice_stal_C_tiny   = { id=92, kind="scenery", r=12,h=16 },

  -- gory
  impaled_corpse = { id=61,  kind="scenery", r=12, h=96 },
  laying_corpse  = { id=62,  kind="scenery", r=12, h=44 },
  hang_corpse_1  = { id=71,  kind="scenery", r=12, h=75, ceil=true },
  hang_corpse_1  = { id=108, kind="scenery", r=12, h=96, ceil=true },
  hang_corpse_1  = { id=109, kind="scenery", r=12, h=100,ceil=true },
  smash_corpse   = { id=110, kind="scenery", r=12, h=40 },

  iron_maiden    = { id=8067,kind="scenery", r=16,h=60 },

  -- miscellaneous
  teleport_smoke = { id=140, kind="scenery", r=20,h=80, pass=true },

  -- ambient sounds
  snd_stone  = { id=1400, kind="other", r=16,h=16, pass=true },
  snd_heavy  = { id=1401, kind="other", r=16,h=16, pass=true },
  snd_metal1 = { id=1402, kind="other", r=16,h=16, pass=true },
  snd_creak  = { id=1403, kind="other", r=16,h=16, pass=true },
  snd_silent = { id=1404, kind="other", r=16,h=16, pass=true },
  snd_lava   = { id=1405, kind="other", r=16,h=16, pass=true },
  snd_water  = { id=1406, kind="other", r=16,h=16, pass=true },
  snd_ice    = { id=1407, kind="other", r=16,h=16, pass=true },
  snd_earth  = { id=1408, kind="other", r=16,h=16, pass=true },
  snd_metal2 = { id=1409, kind="other", r=16,h=16, pass=true },
}


----------------------------------------------------------------

HEXEN_MATERIALS =
{
  -- special materials --
  _ERROR = { t="WASTE01", f="F_033" },
  _SKY   = { t="WASTE01", f="F_SKY" },

  -- textures --

  BOOKS01  = { t="BOOKS01",  f="F_092" },
  BOOKS02  = { t="BOOKS02",  f="F_092" },
  BOOKS03  = { t="BOOKS03",  f="F_092" },
  BOOKS04  = { t="BOOKS04",  f="F_092" },
  BRASS1   = { t="BRASS1",   f="F_037" },  -- poor match
  BRASS3   = { t="BRASS3",   f="F_037" },  -- poor match
  BRASS4   = { t="BRASS4",   f="F_037" },  -- poor match
  CASTLE01 = { t="CASTLE01", f="F_012" },
  CASTLE02 = { t="CASTLE02", f="F_012" },
  CASTLE03 = { t="CASTLE03", f="F_012" },
  CASTLE04 = { t="CASTLE04", f="F_012" },
  CASTLE05 = { t="CASTLE05", f="F_012" },
  CASTLE06 = { t="CASTLE06", f="F_012" },
  CASTLE07 = { t="CASTLE07", f="F_057" },
  CASTLE08 = { t="CASTLE08", f="F_057" },
  CASTLE11 = { t="CASTLE11", f="F_073" },

  CAVE01   = { t="CAVE01",   f="F_073" },  -- poor match
  CAVE02   = { t="CAVE02",   f="F_076" },
  CAVE03   = { t="CAVE03",   f="F_039" },  -- poor match
  CAVE04   = { t="CAVE04",   f="F_039" },
  CAVE05   = { t="CAVE05",   f="F_007" },  -- poor match
  CAVE06   = { t="CAVE06",   f="F_039" },
  CAVE07   = { t="CAVE07",   f="F_008" },
  CAVE12   = { t="CAVE12",   f="F_076" },
  CHAP1    = { t="CHAP1",    f="F_082" },
  CHAP2    = { t="CHAP2",    f="F_082" },
  CHAP3    = { t="CHAP3",    f="F_082" },
  CLOCKA   = { t="CLOCKA",   f="F_082" },
  CRATE01  = { t="CRATE01",  f="F_049" },
  CRATE02  = { t="CRATE02",  f="F_051" },
  CRATE03  = { t="CRATE03",  f="F_050" },
  CRATE04  = { t="CRATE04",  f="F_052" },
  CRATE05  = { t="CRATE05",  f="F_053" },

  D_AXE    = { t="D_AXE",    f="F_092" },
  D_BRASS1 = { t="D_BRASS1", f="F_037" },  -- poor match
  D_BRASS2 = { t="D_BRASS2", f="F_037" },  -- poor match
  D_CAST   = { t="D_CAST",   f="F_073" },
  D_CAVE   = { t="D_CAVE",   f="F_073" },
  D_CAVE2  = { t="D_CAVE2",  f="F_007" },
  D_DUNGEO = { t="D_DUNGEO", f="F_092" },
  D_END1   = { t="D_END1",   f="F_073" },
  D_END2   = { t="D_END2",   f="F_073" },
  D_END3   = { t="D_END3",   f="F_092" },
  D_END4   = { t="D_END4",   f="F_092" },
  D_ENDBR  = { t="D_ENDBR",  f="F_037" },  -- poor match
  D_ENDSLV = { t="D_ENDSLV", f="F_082" },
  D_FIRE   = { t="D_FIRE",   f="F_013" },
  D_RUST   = { t="D_RUST",   f="F_073" },
  D_SILKEY = { t="D_SILKEY", f="F_092" },
  D_SILVER = { t="D_SILVER", f="F_073" },
  D_SLV1   = { t="D_SLV1",   f="F_066" },
  D_SLV2   = { t="D_SLV2",   f="F_066" },
  D_STEEL  = { t="D_STEEL",  f="F_065" },
  D_SWAMP  = { t="D_SWAMP",  f="F_018" },
  D_SWAMP2 = { t="D_SWAMP2", f="F_076" },
  D_WASTE  = { t="D_WASTE",  f="F_037" },
  D_WD01   = { t="D_WD01",   f="F_092" },
  D_WD02   = { t="D_WD02",   f="F_092" },
  D_WD03   = { t="D_WD03",   f="F_092" },
  D_WD04   = { t="D_WD04",   f="F_092" },
  D_WD05   = { t="D_WD05",   f="F_051" },
  D_WD06   = { t="D_WD06",   f="F_051" },
  D_WD07   = { t="D_WD07",   f="F_073" },
  D_WD08   = { t="D_WD08",   f="F_073" },
  D_WD09   = { t="D_WD09",   f="F_073" },
  D_WD10   = { t="D_WD10",   f="F_073" },
  D_WINNOW = { t="D_WINNOW", f="F_073" },
  DOOR51   = { t="DOOR51",   f="F_082" },

  FIRE01   = { t="FIRE01",   f="F_032" },
  FIRE02   = { t="FIRE02",   f="F_032" },
  FIRE03   = { t="FIRE03",   f="F_032" },
  FIRE04   = { t="FIRE04",   f="F_032" },
  FIRE05   = { t="FIRE05",   f="F_032" },
  FIRE06   = { t="FIRE06",   f="F_013" },
  FIRE07   = { t="FIRE07",   f="F_013" },
  FIRE08   = { t="FIRE08",   f="F_013" },
  FIRE09   = { t="FIRE09",   f="F_013" },
  FIRE10   = { t="FIRE10",   f="F_013" },
  FIRE11   = { t="FIRE11",   f="F_013" },
  FIRE12   = { t="FIRE12",   f="F_013" },
  FIRE14   = { t="FIRE14",   f="F_032" },
  FIRE15   = { t="FIRE15",   f="F_032" },
  FIRE17   = { t="FIRE17",   f="F_017" },  -- poor match

  FOREST01 = { t="FOREST01", f="F_014" },
  FOREST02 = { t="FOREST02", f="F_038" },
  FOREST03 = { t="FOREST03", f="F_038" },
  FOREST04 = { t="FOREST04", f="F_038" },
  FOREST05 = { t="FOREST05", f="F_048" },
  FOREST07 = { t="FOREST07", f="F_002" },  -- poor match
  FOREST10 = { t="FOREST10", f="F_047" },
  FOREST11 = { t="FOREST11", f="F_038" },
  FORPUZ1  = { t="FORPUZ1",  f="F_005" },
  FORPUZ2  = { t="FORPUZ2",  f="F_038" },
  FORPUZ3  = { t="FORPUZ3",  f="F_041" },

  GEARW    = { t="GEARW",    f="F_074" },
  GEARX    = { t="GEARX",    f="F_074" },
  GEARY    = { t="GEARY",    f="F_074" },
  GEARZ    = { t="GEARZ",    f="F_074" },
  GILO1    = { t="GILO1",    f="F_072" },
  GILO2    = { t="GILO2",    f="F_072" },

  GLASS01  = { t="GLASS01",  f="F_081" },
  GLASS02  = { t="GLASS02",  f="F_081" },
  GLASS03  = { t="GLASS03",  f="F_081" },
  GLASS04  = { t="GLASS04",  f="F_081" },
  GLASS05  = { t="GLASS05",  f="F_081" },
  GLASS06  = { t="GLASS06",  f="F_081" },
  GRAVE01  = { t="GRAVE01",  f="F_009" },
  GRAVE03  = { t="GRAVE03",  f="F_009" },
  GRAVE04  = { t="GRAVE04",  f="F_009" },
  GRAVE05  = { t="GRAVE05",  f="F_009" },
  GRAVE06  = { t="GRAVE06",  f="F_009" },
  GRAVE07  = { t="GRAVE07",  f="F_009" },
  GRAVE08  = { t="GRAVE08",  f="F_009" },

  ICE01    = { t="ICE01",    f="F_033" },
  ICE02    = { t="ICE02",    f="F_040" },  -- poor match
  ICE03    = { t="ICE03",    f="F_040" },  -- poor match
  ICE06    = { t="ICE06",    f="F_040" },  -- poor match
  MONK01   = { t="MONK01",   f="F_027" },
  MONK02   = { t="MONK02",   f="F_025" },
  MONK03   = { t="MONK03",   f="F_025" },
  MONK04   = { t="MONK04",   f="F_025" },
  MONK05   = { t="MONK05",   f="F_025" },
  MONK06   = { t="MONK06",   f="F_025" },
  MONK07   = { t="MONK07",   f="F_031" },
  MONK08   = { t="MONK08",   f="F_031" },
  MONK09   = { t="MONK09",   f="F_025" },
  MONK11   = { t="MONK11",   f="F_025" },
  MONK12   = { t="MONK12",   f="F_025" },
  MONK14   = { t="MONK14",   f="F_029" },
  MONK15   = { t="MONK15",   f="F_029" },
  MONK16   = { t="MONK16",   f="F_028" },
  MONK17   = { t="MONK17",   f="F_028" },
  MONK18   = { t="MONK18",   f="F_028" },
  MONK19   = { t="MONK19",   f="F_028" },
  MONK21   = { t="MONK21",   f="F_028" },
  MONK22   = { t="MONK22",   f="F_028" },
  MONK23   = { t="MONK23",   f="F_025" },

  PILLAR01 = { t="PILLAR01", f="F_037" },  -- poor match
  PILLAR02 = { t="PILLAR02", f="F_044" },
  PLANET1  = { t="PLANET1",  f="F_025" },
  PLANET2  = { t="PLANET2",  f="F_025" },
  PLAT01   = { t="PLAT01",   f="F_045" },
  PLAT02   = { t="PLAT02",   f="F_045" },
  PRTL02   = { t="PRTL02",   f="F_057" },
  PRTL03   = { t="PRTL03",   f="F_019" },  -- poor match
  PRTL04   = { t="PRTL04",   f="F_044" },
  PRTL05   = { t="PRTL05",   f="F_044" },
  PRTL06   = { t="PRTL06",   f="F_057" },
  PUZZLE1  = { t="PUZZLE1",  f="F_082" },
  PUZZLE10 = { t="PUZZLE10", f="F_091" },
  PUZZLE11 = { t="PUZZLE11", f="F_091" },
  PUZZLE12 = { t="PUZZLE12", f="F_091" },
  PUZZLE2  = { t="PUZZLE2",  f="F_082" },
  PUZZLE3  = { t="PUZZLE3",  f="F_082" },
  PUZZLE4  = { t="PUZZLE4",  f="F_082" },
  PUZZLE5  = { t="PUZZLE5",  f="F_091" },
  PUZZLE6  = { t="PUZZLE6",  f="F_091" },
  PUZZLE7  = { t="PUZZLE7",  f="F_091" },
  PUZZLE8  = { t="PUZZLE8",  f="F_091" },
  PUZZLE9  = { t="PUZZLE9",  f="F_091" },

  -- steps
  S_01     = { t="S_01",     f="F_047" },
  S_02     = { t="S_02",     f="F_009" },
  S_04     = { t="S_04",     f="F_030" },
  S_05     = { t="S_05",     f="F_057" },
  S_06     = { t="S_06",     f="F_009" },
  S_07     = { t="S_07",     f="F_009" },
  S_09     = { t="S_09",     f="F_047" },
  S_11     = { t="S_11",     f="F_034" },
  S_12     = { t="S_12",     f="F_053" },
  S_13     = { t="S_13",     f="F_057" },
  T2_STEP  = { t="T2_STEP",  f="F_057" },

  SEWER01  = { t="SEWER01",  f="F_018" },
  SEWER02  = { t="SEWER02",  f="F_018" },
  SEWER05  = { t="SEWER05",  f="F_018" },
  SEWER06  = { t="SEWER06",  f="F_018" },
  SEWER07  = { t="SEWER07",  f="F_017" },  -- poor match
  SEWER08  = { t="SEWER08",  f="F_017" },  -- poor match
  SEWER09  = { t="SEWER09",  f="F_017" },  -- poor match
  SEWER10  = { t="SEWER10",  f="F_017" },  -- poor match
  SEWER11  = { t="SEWER11",  f="F_017" },  -- poor match
  SEWER12  = { t="SEWER12",  f="F_017" },  -- poor match
  SEWER13  = { t="SEWER13",  f="F_018" },

  SPAWN01  = { t="SPAWN01",  f="F_042" },
  SPAWN05  = { t="SPAWN05",  f="F_042" },
  SPAWN08  = { t="SPAWN08",  f="F_065" },
  SPAWN11  = { t="SPAWN11",  f="F_078" },
  SPAWN13  = { t="SPAWN13",  f="F_042" },
  STEEL01  = { t="STEEL01",  f="F_074" },
  STEEL02  = { t="STEEL02",  f="F_075" },
  STEEL05  = { t="STEEL05",  f="F_069" },
  STEEL06  = { t="STEEL06",  f="F_069" },
  STEEL07  = { t="STEEL07",  f="F_070" },
  STEEL08  = { t="STEEL08",  f="F_078" },
  SWAMP01  = { t="SWAMP01",  f="F_019" },
  SWAMP03  = { t="SWAMP03",  f="F_019" },
  SWAMP04  = { t="SWAMP04",  f="F_017" },
  SWAMP06  = { t="SWAMP06",  f="F_017" },

  TOMB01   = { t="TOMB01",   f="F_058" },
  TOMB02   = { t="TOMB02",   f="F_058" },
  TOMB03   = { t="TOMB03",   f="F_058" },
  TOMB04   = { t="TOMB04",   f="F_058" },
  TOMB05   = { t="TOMB05",   f="F_059" },
  TOMB06   = { t="TOMB06",   f="F_059" },
  TOMB07   = { t="TOMB07",   f="F_044" },
  TOMB08   = { t="TOMB08",   f="F_042" },
  TOMB09   = { t="TOMB09",   f="F_042" },
  TOMB10   = { t="TOMB10",   f="F_042" },
  TOMB11   = { t="TOMB11",   f="F_044" },
  TOMB12   = { t="TOMB12",   f="F_059" },
  VALVE1   = { t="VALVE1",   f="F_047" },
  VALVE2   = { t="VALVE2",   f="F_047" },
  VILL01   = { t="VILL01",   f="F_030" },
  VILL04   = { t="VILL04",   f="F_055" },  -- poor match
  VILL05   = { t="VILL05",   f="F_055" },  -- poor match

  WASTE01  = { t="WASTE01",  f="F_005" },
  WASTE02  = { t="WASTE02",  f="F_044" },
  WASTE03  = { t="WASTE03",  f="F_082" },  -- poor match
  WASTE04  = { t="WASTE04",  f="F_037" },
  WINN01   = { t="WINN01",   f="F_047" },
  WINNOW02 = { t="WINNOW02", f="F_022" },
  WOOD01   = { t="WOOD01",   f="F_054" },
  WOOD02   = { t="WOOD02",   f="F_092" },
  WOOD03   = { t="WOOD03",   f="F_092" },
  WOOD04   = { t="WOOD04",   f="F_054" },

  X_FAC01  = { t="X_FAC01",  f="X_001" },
  X_FIRE01 = { t="X_FIRE01", f="X_001" },
  X_SWMP1  = { t="X_SWMP1",  f="X_009" },
  X_SWR1   = { t="X_SWR1",   f="F_018" },
  X_WATER1 = { t="X_WATER1", f="X_005" },

  -- switches
  BOSSK1   = { t="BOSSK1",   f="F_071" },
  GEAR01   = { t="GEAR01",   f="F_091" },
  SW51_OFF = { t="SW51_OFF", f="F_082" },
  SW52_OFF = { t="SW52_OFF", f="F_082" },
  SW53_UP  = { t="SW53_UP",  f="F_025" },
  SW_1_UP  = { t="SW_1_UP",  f="F_048" },  -- poor match
  SW_2_UP  = { t="SW_2_UP",  f="F_048" },  -- poor match
  SW_EL1   = { t="SW_EL1",   f="F_082" },
  SW_OL1   = { t="SW_OL1",   f="F_073" },


  -- flats --

  F_001 = { t="WASTE01",  f="F_001" },  -- poor match
  F_002 = { t="WASTE01",  f="F_002" },
  F_003 = { t="WASTE01",  f="F_003" },
  F_004 = { t="WASTE01",  f="F_004" },
  F_005 = { t="WASTE01",  f="F_005" },
  F_006 = { t="WASTE01",  f="F_006" },
  F_007 = { t="CAVE05",   f="F_007" },  -- poor match
  F_008 = { t="CAVE07",   f="F_008" },
  F_009 = { t="PRTL02",   f="F_009" },  -- poor match
  F_010 = { t="PRTL04",   f="F_010" },  -- poor match
  F_011 = { t="FOREST01", f="F_011" },  -- poor match
  F_012 = { t="FIRE06",   f="F_012" },  -- poor match
  F_013 = { t="FIRE06",   f="F_013" },
  F_014 = { t="MONK16",   f="F_014" },
  F_015 = { t="CASTLE01", f="F_015" },
  F_017 = { t="SWAMP04",  f="F_017" },
  F_018 = { t="SEWER01",  f="F_018" },
  F_019 = { t="SWAMP01",  f="F_019" },
  F_020 = { t="SWAMP01",  f="F_020" },
  F_021 = { t="FIRE06",   f="F_021" },
  F_022 = { t="FIRE06",   f="F_022" },
  F_023 = { t="SEWER01",  f="F_023" },
  F_024 = { t="SEWER08",  f="F_024" },  -- poor match
  F_025 = { t="MONK02",   f="F_025" },
  F_027 = { t="MONK01",   f="F_027" },
  F_028 = { t="MONK16",   f="F_028" },
  F_029 = { t="MONK14",   f="F_029" },
  F_030 = { t="VILL01",   f="F_030" },
  F_031 = { t="MONK07",   f="F_031" },
  F_032 = { t="FIRE01",   f="F_032" },
  F_033 = { t="ICE01",    f="F_033" },
  F_034 = { t="FOREST02", f="F_034" },  -- poor match
  F_037 = { t="WASTE04",  f="F_037" },
  F_038 = { t="FOREST02", f="F_038" },
  F_039 = { t="CAVE04",   f="F_039" },
  F_040 = { t="CAVE04",   f="F_040" },  -- poor match
  F_041 = { t="FIRE06",   f="F_041" },
  F_042 = { t="FIRE06",   f="F_042" },
  F_043 = { t="WASTE02",  f="F_043" },
  F_044 = { t="PRTL04",   f="F_044" },
  F_045 = { t="WASTE03",  f="F_045" },  -- poor match
  F_046 = { t="WASTE03",  f="F_046" },  -- poor match
  F_047 = { t="STEEL01",  f="F_047" },  -- poor match
  F_048 = { t="FOREST05", f="F_048" },
  F_049 = { t="CRATE01",  f="F_049" },
  F_050 = { t="CRATE03",  f="F_050" },
  F_051 = { t="CRATE02",  f="F_051" },
  F_052 = { t="CRATE04",  f="F_052" },
  F_053 = { t="CRATE05",  f="F_053" },
  F_054 = { t="WOOD01",   f="F_054" },
  F_055 = { t="WOOD01",   f="F_055" },
  F_057 = { t="CASTLE07", f="F_057" },
  F_058 = { t="TOMB04",   f="F_058" },
  F_059 = { t="TOMB05",   f="F_059" },

  F_061 = { t="TOMB04",   f="F_061" },
  F_062 = { t="TOMB04",   f="F_062" },
  F_063 = { t="TOMB04",   f="F_063" },
  F_064 = { t="TOMB04",   f="F_064" },
  F_065 = { t="STEEL06",  f="F_065" },
  F_066 = { t="STEEL07",  f="F_066" },
  F_067 = { t="STEEL06",  f="F_067" },
  F_068 = { t="STEEL07",  f="F_068" },
  F_069 = { t="STEEL06",  f="F_069" },
  F_070 = { t="STEEL07",  f="F_070" },
  F_071 = { t="STEEL05",  f="F_071" },
  F_072 = { t="STEEL07",  f="F_072" },
  F_073 = { t="CASTLE11", f="F_073" },
  F_074 = { t="STEEL01",  f="F_074" },
  F_075 = { t="STEEL02",  f="F_075" },
  F_076 = { t="CAVE02",   f="F_076" },
  F_077 = { t="VILL01",   f="F_077" },
  F_078 = { t="STEEL06",  f="F_078" },
  F_081 = { t="GLASS05",  f="F_081" },
  F_082 = { t="CASTLE01", f="F_082" },
  F_083 = { t="CASTLE01", f="F_083" },
  F_089 = { t="CASTLE01", f="F_089" },
  F_091 = { t="CASTLE01", f="F_091" },
  F_092 = { t="WOOD01",   f="F_092" },

  F_084 = { t="CASTLE01", f="F_084" },
  X_001 = { t="X_FIRE01", f="X_001" },
  X_005 = { t="X_WATER1", f="X_005" },
  X_009 = { t="X_SWMP1",  f="X_009" },
  X_012 = { t="CASTLE01", f="X_012" },
}

HEXEN_RAILS =
{
-- GATE01
-- GATE02
-- GATE03
-- GATE04
-- GATE51
-- GATE52
-- GATE53

-- VILL06
-- VILL07
-- VILL08

-- CASTLE09
-- CAVE11
-- FIRE16
-- FOREST06
-- FOREST12
-- GLASS07
-- MONK24
-- PRTL07

-- SEWER03
-- SEWER04
-- SEWER14
-- SWAMP07

-- TOMB13
-- TOMB18
-- TPORT1
-- TPORTX
-- VALVE01
-- VALVE02

-- WEB1_L
-- WEB1_R
-- WEB2_L
-- WEB2_R
-- WEB3
}


----------------------------------------------------------------

HEXEN_COMBOS =
{
  ---- CAVE ------------

  CAVE1 =
  {
    theme_probs = { CAVE=50 },
    mat_pri = 2,

    wall  = "CAVE06",
    floor = "F_040",
    ceil  = "F_040",

    arch  = "arch_arched",

    scenery = "stal_pillar",
  },

  CAVE2 =
  {
    theme_probs = { CAVE=50 },
    mat_pri = 2,

    wall  = "CAVE05",
    floor = "F_001",
    ceil  = "F_001",

    arch  = "arch_hole",
  },

  CAVE3 =
  {
    theme_probs = { CAVE=70 },
    mat_pri = 2,
    outdoor = true,

    wall  = "CAVE03",
    floor = "F_039",
    ceil  = "F_039",

    scenery = "lean_tree2",

    space_range = { 40,80 },
  },

  CAVE4 =
  {
    theme_probs = { CAVE=50 },
    mat_pri = 3,
    outdoor = true,

    wall  = "CAVE01",
    floor = "F_007",
    ceil  = "F_007",

    scenery = "lean_tree1",

    space_range = { 40,80 },
  },

  ---- DUNGEON ------------

  DUNGEON1 =
  {
    theme_probs = { DUNGEON=50 },
    mat_pri = 5,

    wall  = "FIRE01",
    floor = "F_012",
    ceil  = "F_082",

    pillar = "FIRE15",
    good_liquid = "lava",

  },

  DUNGEON2 =
  {
    theme_probs = { DUNGEON=50 },
    mat_pri = 5,

    wall  = "FIRE06",
    floor = "F_012",
    ceil  = "F_032",

    pillar = "FIRE15",
    good_liquid = "lava",

  },

  DUNGEON3 =
  {
    theme_probs = { DUNGEON=50 },
    mat_pri = 5,

    wall  = "CASTLE11",
    floor = "F_011", -- F_014
    ceil  = "F_045",

    pillar = "FIRE15",
    good_liquid = "lava",

  },

  DUNGEON4 =
  {
    theme_probs = { DUNGEON=50 },
    mat_pri = 5,
    outdoor = true,

    wall  = "PRTL03",
    floor = "F_018",
    ceil  = "F_018",

    pillar = "FIRE15",
    good_liquid = "lava",

  },

  ---- ICE ------------

  ICE1 =
  {
    theme_probs = { ICE=30 },
    mat_pri = 1,

    wall = "ICE01",
    floor = "F_033",
    ceil  = "F_033",

    pillar = "ICE02",
    bad_liquid = "lava",

    sc_count = { 3,7 },
    scenery =
    {
      ice_stal_F_big    = 10, ice_stal_C_big    = 10,
      ice_stal_F_medium = 20, ice_stal_C_medium = 20,
      ice_stal_F_small  = 30, ice_stal_C_small  = 30,
      ice_stal_F_tiny   = 20, ice_stal_C_tiny   = 20,
    },
  },

  ICE2 =
  {
    theme_probs = { ICE=80 },
    mat_pri = 2,

    wall  = "ICE06",
    floor = "F_013",
    ceil  = "F_009",

    pillar = "ICE02",
    bad_liquid = "lava",
  },

  ICE3 =
  {
    theme_probs = { ICE=60 },
    mat_pri = 2,

    wall  = "CAVE02",
    floor = "F_034",
    ceil  = "F_008",

    bad_liquid = "lava",
  },

  ICE4 =
  {
    theme_probs = { ICE=60 },
    mat_pri = 2,
    outdoor = true,

    wall  = "CAVE07",
    floor = "F_008",
    ceil  = "F_008",

    bad_liquid = "lava",
  },

  ---- SWAMP ------------

  SWAMP1 =
  {
    theme_probs = { SWAMP=50 },
    mat_pri = 2,

    wall = "SEWER01",
    floor = "X_009",
    ceil  = "F_013",

    liquid_prob = 0,

    wall_fabs = { solid_SEWER02=30, other=30 },

    -- FIXME !!!! X_SWR1 pillar
  },

  SWAMP2 =
  {
    theme_probs = { SWAMP=50 },
    mat_pri = 2,

    wall = "SEWER08",
    floor = "X_009",
    ceil  = "F_013",

    liquid_prob = 0,

    wall_fabs = { solid_SEWER10=60, other=30 },
  },

  SWAMP3 =
  {
    theme_probs = { SWAMP=50 },
    mat_pri = 2,
    outdoor = true,

    wall = "WASTE01",
    floor = "X_009",
    ceil  = "F_013",

    liquid_prob = 0,
  },

  SWAMP4 =
  {
    theme_probs = { SWAMP=50 },
    mat_pri = 2,
    outdoor = true,

    wall  = "SWAMP03",
    floor = "X_009",
    ceil  = "F_013",

    liquid_prob = 0,
  },

  ---- VILLAGE ------------

  VILLAGE1 =
  {
    theme_probs = { VILLAGE=50 },
    mat_pri = 6,

    wall  = "FOREST01",
    floor = "F_089",
    ceil  = "F_010",

    scenery = "brass_brazier",
    sc_fabs = { pillar_rnd_PILLAR01=50, other=30 },
  },

  VILLAGE2 =
  {
    theme_probs = { VILLAGE=50 },
    mat_pri = 4,

    wall  = "WOOD03",
    floor = "F_055",
    ceil  = "F_014",

    pillar = "PILLAR01",
    scenery = "brass_brazier",
  },

  VILLAGE3 =
  {
    theme_probs = { VILLAGE=60 },
    mat_pri = 6,

    wall  = "MONK02",
    floor = "F_059",  -- F_011
    ceil  = "F_037",

    scenery = "brass_brazier",
    sc_fabs = { pillar_rnd_PILLAR02=50, pillar_wide_MONK03=40, other=30 },
  },

  VILLAGE4 =
  {
    theme_probs = { VILLAGE=50 },
    mat_pri = 6,
    outdoor = true,

    wall  = "MONK15",
    floor = "F_029",
    ceil  = "F_029",

    pillar = "PILLAR01",
    scenery = "brass_brazier",
  },

  VILLAGE5 =
  {
    theme_probs = { VILLAGE=50 },
    mat_pri = 6,
    outdoor = true,

    wall  = "CASTLE07",
    floor = "F_057",
    ceil  = "F_057",

    scenery = "banner",
  },

  VILLAGE6 =
  {
    theme_probs = { VILLAGE=50 },
    mat_pri = 4,
    outdoor = true,

    wall  = "PRTL02",
    floor = "F_044",
    ceil  = "F_044",

    scenery = "gargoyle_short",
  },
  
}

HEXEN_EXITS =
{
  STEEL =
  {
    mat_pri = 9,

    wall = "STEEL01",
    void = "STEEL02",

    floor = "F_022",
    ceil  = "F_044",

    switch = { switch="SW_2_UP", wall="STEEL06", h=64 },

    door = { wall="FIRE14", w=64,  h=128 },
  },

}

HEXEN_HALLWAYS =
{
  -- FIXME !!! hallway themes
}


---- PEDESTALS ------------

HEXEN_PEDESTALS =
{
  PLAYER =
  {
    wall = "T2_STEP", void = "FIRE06",
    floor = "F_062",  ceil = "F_062",  -- TODO: F_061..F_064
    h = 8,
  },

  QUEST =
  {
    wall = "T2_STEP", void = "FIRE06",
    floor = "F_042",  ceil = "F_042",
    h = 8,
  },

  WEAPON =
  {
    wall = "T2_STEP", void = "FIRE06",
    floor = "F_091",  ceil = "F_091",
    h = 8,
  },

}

---- OVERHANGS ------------

HEXEN_OVERHANGS =
{
  WOOD =
  {
    ceil = "F_054",
    upper = "D_WD07",
    thin = "WOOD01",
  },
}


---- MISC STUFF ------------

HEXEN_LIQUIDS =
{
  water = { floor="X_005", wall="X_WATER1" },
  lava  = { floor="X_001", wall="X_FIRE01" },

--- slime = { floor="X_009", wall="X_SWMP1" },
}

HEXEN_SWITCHES =
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

        kind = { id=11, act="S1", args={"tag", 2 } },
      }
    },

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
    },
  },

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

        kind = { id=11, act="S1", args={"tag", 2 } },
      }
    },

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
    },
  },

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

        kind = { id=11, act="S1", args={"tag", 2 } },
      }
    },

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
    },
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
---#    },
  },

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

        kind = { id=11, act="S1", args={"tag", 2 } },
      }
    },

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
    },
  },

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
---#        kind = { id=11, act="S1", args={"tag", 2 } },
---#      }
---#    },
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
---#    },
---#  },

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

        kind = { id=11, act="S1", args={"tag", 2 } },
      }
    },

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
    },
  },
}

HEXEN_DOORS =
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
             },

--[[ !!!
  d_big    = { wall="DOOR51",   w=128, h=128 },
  d_brass1 = { wall="BRASS1",   w=128, h=128 },
  d_brass2 = { wall="D_BRASS2", w=64,  h=128 },

  d_wood1  = { wall="D_WD07",   w=128, h=128 },
  d_wood2  = { wall="D_WD08",   w=64,  h=128 },
--]]

  d_wood3  = { wall="D_WD10",   w=64,  h=128 },
}

HEXEN_KEY_DOORS =
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
      door_kind = { id=13, act="SR", args={0, 16, 128, 5} },
      tag=0,
    }
  },

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
      door_kind = { id=13, act="SR", args={0, 16, 128, 4} },
      tag=0,
    }
  },

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
      door_kind = { id=13, act="SR", args={0, 16, 128, 11} },
      tag=0,
    }
  },

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
      door_kind = { id=13, act="SR", args={0, 16, 128, 7} },
      tag=0,
    }
  },

  k_cave =
  {
    w=128, h=128,
    prefab = "DOOR", -- DOOR_LOCKED
    skin =
    {
      door_w="D_CAVE2", door_c="F_009",
      track_w="STEEL08", frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 2} },
      tag=0,
    }
  },

  k_swamp =
  {
    w=128, h=128,
    prefab = "DOOR", -- DOOR_LOCKED
    skin =
    {
      door_w="D_SWAMP2", door_c="F_009",
      track_w="STEEL08", frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 10} },
      tag=0,
    }
  },

  k_steel =
  {
    w=128, h=128,
    prefab = "DOOR", -- DOOR_LOCKED
    skin =
    {
      door_w="D_STEEL", door_c="F_009",
      track_w="STEEL08", frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 1} },
      tag=0,
    }
  },

  k_rusty =
  {
    w=128, h=128,
    prefab = "DOOR", -- DOOR_LOCKED
    skin =
    {
      door_w="D_RUST", door_c="F_009",
      track_w="STEEL08", frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 8} },
      tag=0,
    }
  },

  k_dungeon =
  {
    w=128, h=128,
    prefab = "DOOR", -- DOOR_LOCKED
    skin =
    {
      door_w="D_DUNGEO", door_c="F_009",
      track_w="STEEL08", frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 6} },
      tag=0,
    }
  },

  k_horn =
  {
    w=128, h=128,
    prefab = "DOOR", -- DOOR_LOCKED
    skin =
    {
      door_w="D_WASTE", door_c="F_009",
      track_w="STEEL08", frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 9} },
      tag=0,
    }
  },

  k_axe =
  {
    w=128, h=128,
    prefab = "DOOR", -- DOOR_LOCKED
    skin =
    {
      door_w="D_AXE", door_c="F_009",
      track_w="STEEL08", frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 3} },
      tag=0,
    }
  },

}

HEXEN_IMAGES =
{
  { wall = "BRASS3", w=128, h=128, glow=true },
  { wall = "BRASS4", w=64,  h=64,  floor="F_016" }
}

HEXEN_LIGHTS =
{
  l1 = { floor="F_081", side="FIRE07" },
  l2 = { floor="F_084", side="FIRE07" },
  l3 = { floor="X_012", side="FIRE07" },
}

HEXEN_WALL_LIGHTS =
{
  fire = { wall="X_FIRE01", w=16 },
}

HEXEN_PICS =
{
  cave12 = { wall = "CAVE12",   w=128, h=128 },
  forest = { wall = "FOREST03", w=128, h=128 },

  mon1 = { wall = "SPAWN10",  w=128, h=128 },
  mon3 = { wall = "SPAWN13",  w=64,  h=64  },

  glass1 = { wall = "GLASS01",  w=64,  h=128 },
  glass3 = { wall = "GLASS03",  w=64,  h=128 },
  glass5 = { wall = "GLASS05",  w=64,  h=128 },
}


HEXEN_ROOMS =
{
  PLAIN =
  {
  },

  HALLWAY =
  {
    room_heights = { [96]=50, [128]=50 },
    door_probs   = { out_diff=75, combo_diff=50, normal=5 },
    window_probs = { out_diff=1, combo_diff=1, normal=1 },
    space_range  = { 20, 65 },
  },
 
  SCENIC =
  {
  },

  -- TODO: check in-game level names for ideas
}

HEXEN_SUB_THEMES =
{
  CAVE =
  {
    room_probs=
    {
      PLAIN=50,
    },

    monster_prefs =
    {
      demon1=3.0, demon2=3.0
    },

    door_probs   = { out_diff=10, combo_diff= 3, normal=1 },
    window_probs = { out_diff=30, combo_diff=30, normal=5 },
  },

  DUNGEON =
  {
    room_probs=
    {
      PLAIN=50,
    },

    monster_prefs =
    {
      centaur1=3.0, centaur2=3.0, reiver=2.5
    },
  },

  ICE =
  {
    room_probs=
    {
      PLAIN=50,
    },

    monster_prefs =
    {
      iceguy =500, afrit=0.2
    },
  },

  SWAMP =
  {
    room_probs=
    {
      PLAIN=50,
    },

    monster_prefs =
    {
      -- need high values just to make them appear
      serpent1=5000, serpent2=3000
    },
  },

  VILLAGE =
  {
    room_probs=
    {
      PLAIN=50,
    },

    monster_prefs =
    {
      afrit=3.0, bishop=2.5
    },
  },
}


HEXEN_LIFTS =
{
  slow =
  {
    kind = { id=62, act="SR", args={"tag", 16, 64} },
    walk = { id=62, act="SR", args={"tag", 16, 64} },
  },

  fast =
  {
    kind = { id=62, act="SR", args={"tag", 32, 64} },
    walk = { id=62, act="SR", args={"tag", 32, 64} },
  },
}


HEXEN_DOOR_PREFABS =  -- NB: OBSOLETE
{
  winnow =
  {
    w=128, h=128, prefab="DOOR",

    skin =
    {
      door_w="D_WINNOW", door_c="F_009",
      track_w="STEEL08",
      door_h=128,
      door_kind = { id=12, act="SR", args={0, 16, 128} },
      tag=0,
    },

--    theme_probs = { CITY=60,ICE=10,CAVE=20 },
  },

  door51 =
  {
    w=128, h=128, prefab="DOOR",

    skin =
    {
      door_w="DOOR51", door_c="F_009",
      track_w="STEEL08",
      door_h=128,
      door_kind = { id=12, act="SR", args={0, 16, 128} },
      tag=0,
    },

--    theme_probs = { CITY=60,ICE=10,CAVE=20 },
  },
}


HEXEN_WALL_PREFABS =
{
  solid_SEWER02 =
  {
    prefab = "SOLID", skin = { wall="SEWER02" },
  },

  solid_SEWER10 =
  {
    prefab = "SOLID", skin = { wall="SEWER10" },
  },
}

HEXEN_MISC_PREFABS =
{
  -- Note: pedestal_PLAYER intentionally omitted

  pedestal_ITEM =
  {
    prefab = "PEDESTAL",
    skin = { wall="CASTLE07", floor="F_084", ped_h=12 },
  },

  image_1 =
  {
    prefab = "CRATE",
    add_mode = "island",
    skin = { crate_h=64, crate_w="BRASS4", crate_f="F_044" },
  },

  arch_arched =
  {
    prefab = "ARCH_ARCHED", skin = {},
  },

  arch_hole =
  {
    prefab = "ARCH_HOLE1", skin = {},
  },

  image_2 =
  {
    prefab = "WALL_PIC_SHALLOW",
    add_mode = "wall",
    min_height = 144,
    skin = { pic_w="BRASS3", pic_h=128 },
  },

  secret_DOOR =
  {
    w=128, h=128, prefab = "DOOR",

    skin =
    {
      door_h=128,
      door_kind = { id=11, act="S1", args={0, 16, 64} },
      tag=0,
    }
  },

  gate_FORWARD =
  {
    prefab = "HEXEN_V_TELEPORT",

    skin =
    {
      frame_w="WOOD01", frame_f="F_054", frame_c="F_054",
      telep_w="TPORT1", border_w="TPORTX",
      tag=0,
    },
  },

  gate_BACK =
  {
    prefab = "HEXEN_V_TELEPORT",

    skin =
    {
      frame_w="FOREST05", frame_f="F_048", frame_c="F_048",
      telep_w="TPORT1", border_w="TPORTX",
      tag=0,
    },
  },
}

HEXEN_SCENERY_PREFABS =
{
  pillar_rnd_PILLAR01 =
  {
    prefab = "PILLAR_ROUND_SMALL",
    add_mode = "island",
    environment = "indoor",

    skin = { wall="PILLAR01" },
  },

  pillar_rnd_PILLAR02 =
  {
    prefab = "PILLAR_ROUND_SMALL",
    add_mode = "island",
    environment = "indoor",

    skin = { wall="PILLAR02" },
  },

  pillar_wide_MONK03 =
  {
    prefab = "PILLAR_WIDE",
    add_mode = "island",
    environment = "indoor",

    skin = { wall="MONK03" },
  },
}


HEXEN_PLAYER_MODEL =
{
  fighter =
  {
    stats   = { health=0, blue_mana=0, green_mana=0 },
    weapons = { f_gaunt=1 },
  },

  cleric =
  {
    stats   = { health=0, blue_mana=0, green_mana=0 },
    weapons = { c_mace=1 },
  },

  mage =
  {
    stats   = { health=0, blue_mana=0, green_mana=0 },
    weapons = { m_wand=1 },
  },
}


HEXEN_MONSTERS =
{
  ettin =
  {
    prob=60,
    health=170, damage= 6, attack="melee",
  },

  afrit =
  {
    prob=40,
    health=80,  damage=20, attack="missile",
    float=true,
  },

  centaur1 =
  {
    prob=40,
    health=200, damage=12, attack="melee",
  },

  centaur2 =
  {
    -- not using 'replaces' here, centaur2 is much tougher
    prob=20,
    health=250, damage=20, attack="missile"
  },

  serpent1 =
  {
    health=90,  damage=10, attack="melee"
  },

  serpent2 =
  {
    replaces="serpent1", replace_prob=33,
    health=90,  damage=16, attack="missile",
  },

  iceguy =
  {
    prob=3,
    health=120, damage=16, attack="missile",
  },

  demon1 =
  {
    prob=30,
    health=250, damage=35, attack="missile",
  },

  demon2 =
  {
    replaces="demon1", replace_prob=40,
    health=250, damage=35, attack="missile",
  },

  bishop =
  {
    prob=20,
    health=130, damage=24, attack="missile",
    float=true,
  },

  reiver =
  {
    prob=5,
    health=150, damage=50, attack="missile",
    float=true,
  },


  ---| HEXEN_BOSSES |---

  -- FIXME: proper damage and attack fields

  Wyvern =
  {
    health=640, damage=60,
    float=true,
  },

  Heresiarch =
  {
    health=5000, damage=70,
  },

  Korax =
  {
    health=5000, damage=90,
  },
}


HEXEN_WEAPONS =
{
  c_mace =
  {
    pref=10,
    rate=1.6, damage=32, attack="melee",
    class="cleric",
  },

  c_staff =
  {
    pref=30, add_prob=10,
    rate=3.5, damage=36, attack="missile",
    ammo="blue_mana", per=1,
    give={ {ammo="blue_mana",count=25} },
    class="cleric",
  },

  c_fire =
  {
    pref=60, add_prob=10,
    rate=1.6, damage=64, attack="missile",
    ammo="green_mana", per=4,
    give={ {ammo="green_mana",count=25} },
    class="cleric",
  },

  c_wraith =
  {
    pref=20,
    rate=1.7, damage=200, attack="missile", splash={ 50,35,20,1 },
    ammo="dual_mana", per=18,
    class="cleric",
  },


  f_gaunt =
  {
    pref=10,
    rate=2.0, damage=47, attack="melee",
    class="fighter",
  },

  f_axe =
  {
    pref=30, add_prob=10,
    rate=1.6, damage=70, attack="melee",
    ammo="blue_mana", per=2, 
    give={ {ammo="blue_mana",count=25} },
    class="fighter",
  },

  f_hammer =
  {
    pref=60, add_prob=10,
    rate=1.1, damage=100, attack="missile",
    ammo="green_mana", per=3,
    give={ {ammo="green_mana",count=25} },
    class="fighter",
  },

  f_quietus =
  {
    pref=20,
    rate=1.1, damage=200, attack="missile", splash={ 50,35,20,1 },
    ammo="dual_mana", per=14,
    class="fighter",
  },


  m_wand =
  {
    pref=10,
    rate=2.3, damage=8, attack="missile", penetrates=true,
    class="mage",
  },

  m_cone =
  {
    pref=30, add_prob=10,
    rate=1.1, damage=30, attack="missile",
    ammo="blue_mana", per=3,
    give={ {ammo="blue_mana",count=25} },
    class="mage",
  },

  m_blitz =
  {
    pref=60, add_prob=10,
    rate=1.0, damage=80, attack="missile",
    ammo="green_mana", per=5,
    give={ {ammo="green_mana",count=25} },
    class="mage",
  },

  m_scourge =
  {
    pref=20,
    rate=1.7, damage=200, attack="missile", splash={ 50,35,20,1 },
    ammo="dual_mana",  per=15,
    class="mage",
  },


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
---##   fighter = { "f_gaunt", "f_axe",   "f_hammer", "f_quietus" },
---##   cleric  = { "c_mace",  "c_staff", "c_fire",   "c_wraith"  },
---##   mage    = { "m_wand",  "m_cone",  "m_blitz",  "m_scourge" },
---## }

HEXEN_WEAPON_PIECES =
{
  fighter = { "f1_hilt",  "f2_cross", "f3_blade" },
  cleric  = { "c1_shaft", "c2_cross", "c3_arc"   },
  mage    = { "m1_stick", "m2_stub",  "m3_skull" },
}


HEXEN_PICKUPS =
{
  -- HEALTH --

  h_vial =
  {
    prob=70, cluster={ 1,4 },
    give={ {health=10} },
  },

  h_flask =
  {
    prob=25,
    give={ {health=25} }, 
  },

  h_urn =
  {
    prob=5,
    give={ {health=100} }, 
  },

  -- ARMOR --

  ar_mesh =
  {
    prob=10,
    give={ {health=150} },
    best_class="fighter",
  },

  ar_shield =
  {
    prob=10,
    give={ {health=150} },
    best_class="cleric",
  },

  ar_amulet =
  {
    prob=10,
    give={ {health=150} },
    best_class="mage",
  },

  ar_helmet =
  {
    prob=10,
    give={ {health=60} },  -- rough average
  },

  -- AMMO --

  blue_mana =
  {
    prob=20,
    give={ {ammo="blue_mana",count=15} },
  },

  green_mana =
  {
    prob=20,
    give={ {ammo="green_mana",count=15} },
  },

  dual_mana =
  {
    prob=10,
    give={ {ammo="blue_mana", count=20},
           {ammo="green_mana",count=20} },
  },

  -- NOTES:
  --
  -- Armor gives different amounts (and different decay rates)
  -- for each player class.  We cannot model that completely.
  -- Instead the 'best_class' gets the full amount and all
  -- other classes get half the amount.
}


HEXEN_ITEMS =
{
  p1 = { pickup="flechette", prob=9 },
  p2 = { pickup="bracer",    prob=5 },
  p3 = { pickup="torch",     prob=2 },
}


------------------------------------------------------------

HEXEN_EPISODES =
{
  episode1 =
  {
    theme = "DUNGEON",
    sky_light = 0.65,
    maps = { 1, 2, 3, 4, 5, 6 },
  },

  episode2 =
  {
    theme = "DUNGEON",
    sky_light = 0.75,
    maps = { 13, 8, 9, 10, 11, 12 },
  },

  episode3 =
  {
    theme = "DUNGEON",
    sky_light = 0.50,
    -- Note: map 30 is never used
    maps = { 27, 28, 31, 32, 33, 34 },
  },

  episode4 =
  {
    theme = "DUNGEON",
    sky_light = 0.75,
    maps = { 21, 22, 23, 24, 25, 26 },
  },

  episode5 =
  {
    theme = "DUNGEON",
    sky_light = 0.65,
    maps={ 35, 36, 37, 38, 39, 40 },
  },
}

HEXEN_THEME_LIST =
{
  "CAVE", "DUNGEON", "ICE", "SWAMP", "VILLAGE"
}

HEXEN_KEY_PAIRS =
{
  { key_A="k_emerald", key_B="k_cave" },
  { key_A="k_silver",  key_B="k_swamp" },
  { key_A="k_steel",   key_B="k_rusty" },
  { key_A="k_fire",    key_B="k_dungeon" },
  { key_A="k_horn",    key_B="k_castle" },
}


function hexen_do_get_levels(episode)

  -- NOTE: see doc/Quests.txt for structure of Hexen episodes

  local level_list = {}

  local source_levels = HEXEN_LEVELS[episode]
  assert(#source_levels == 6)

  local theme_mapping = { 1,2,3,4,5 }
  rand_shuffle(theme_mapping)

  local key_A = HEXEN_KEY_PAIRS[episode].key_A
  local key_B = HEXEN_KEY_PAIRS[episode].key_B
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

      quests = {}, gates = {},
    }

    if map == 5 or OB_CONFIG.length == "single" then
      -- secret level is a mixture
      Level.theme_probs = { ICE=3,SWAMP=4,DUNGEON=5,CAVE=6,VILLAGE=7 }
    else
      local th_name = HEXEN_THEME_LIST[theme_mapping[sel(map==6, 5, map)]]
      Level.theme_probs = { [th_name] = 5 }
    end

    table.insert(level_list, Level)
  end


  level_list[5].secret_kind = "plain"

  local b_src = rand_sel(50, 1, 3)
  local w_src = rand_sel(50, 1, 2)

  local gate_idx = 2


  local function add_assumed_weaps(quest, wp)
    if not quest.assumed_stuff then
      quest.assumed_stuff = {}
    end
    for xxx,CL in ipairs(GAME.classes) do
      table.insert(quest.assumed_stuff,
      {
        weapon = HEXEN_WEAPON_NAMES[CL][wp]
      })
    end
  end

  local function add_quest(map, kind, item, mode, force_key)
    assert(map)

    local L = level_list[map]

    local len_probs = assert(HEXEN_QUEST_LEN_PROBS[kind])

    local Quest =
    {
      kind = kind,
      item = item,
      mode = mode,
      force_key = force_key,
      want_len = 1 + rand_index_by_probs(len_probs)
    }

    if mode ~= "sub" then
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

  local r = rand_irange(1,5)

  join_map(sel(r==2, 2, 1), 3)
  join_map(sel(r==3, 3, 1), 2)

  add_quest(2, "key", key_A, "main")
  add_quest(3, "key", key_B, "main")

  for xxx,CL in ipairs(GAME.classes) do
    for piece = 1,3 do
      local name = assert(HEXEN_WEAPON_PIECES[CL][piece])
      add_quest(4, "weapon", name, "sub")
    end
  end

  join_map(rand_index_by_probs { 0,6,6, 4,0,2 }, 5)

  if episode == 5 then
    add_quest(6, "key", "k_axe", "main")
  end

  add_quest(6, "boss", level_list[6].boss_kind, "end")

  -- weapon quests

  for xxx,CL in ipairs(GAME.classes) do
    local weap_2 = assert(HEXEN_WEAPON_NAMES[CL][2])
    local weap_3 = assert(HEXEN_WEAPON_NAMES[CL][3])

    add_quest(rand_index_by_probs { 7, 1, 1 }, "weapon", weap_2, "sub")
    add_quest(rand_index_by_probs { 2, 7, 7 }, "weapon", weap_3, "sub")
  end

  -- item quests

  local item_list = { 
    "boots", "porkies", "repulser", "krater", -- these given twice
    "wings", "chaos", "banish",
    "servant", "incant", "defender" }

  local item_where = { 1,2,3,4,4,5,5,5,6,6 }

  assert(#item_list == #item_where)

  rand_shuffle(item_where)

  for i = 1,#item_list do
    local item  = item_list[i]
    local where = item_where[i]

    local Q = add_quest(where, "item", item, "sub")

    if rand_odds(25) then
      Q.is_secret = true
    end

    if i <= 4 and OB_CONFIG.size ~= "small" then
      local where2
      repeat
        where2 = rand_element(item_where)
      until where2 ~= where

      add_quest(where2, "item", item, "sub")
    end
  end

  -- switch quests

  local switch_list = { "sw_demon", "sw_ball", "sw_cow",
                        "sw_sheep", "sw_moon" }

  rand_shuffle(switch_list)

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

    local map = rand_index_by_probs(lev_probs)

    add_quest(map, "switch", switch_list[sw], "main")
  end

  dump_levels()

  return level_list
end


function Hexen_setup()

  gui.property("hexen_format", "true")

  rand_shuffle(HEXEN_KEY_PAIRS)

--  classes  = { "fighter", "cleric", "mage" },
end

function Hexen_begin_level()
  -- set the description here
  if not LEVEL.description and LEVEL.name_theme then
    LEVEL.description = Naming_grab_one(LEVEL.name_theme)
  end
end


------------------------------------------------------------

OB_THEMES["xn_cave"] =
{
  ref = "CAVE",
  label = "Cave",
  for_games = { hexen=1 },
}

OB_THEMES["xn_dungeon"] =
{
  ref = "DUNGEON",
  label = "Dungeon",
  for_games = { hexen=1 },
}

OB_THEMES["xn_ice"] =
{
  ref = "ICE",
  label = "Ice",
  for_games = { hexen=1 },
}

OB_THEMES["xn_swamp"] =
{
  ref = "SWAMP",
  label = "Swamp",
  for_games = { hexen=1 },
}

OB_THEMES["xn_village"] =
{
  ref = "VILLAGE",
  label = "Village",
  for_games = { hexen=1 },
}


UNFINISHED["hexen"] =
{
  label = "Hexen",

  hooks =
  {
    setup = Hexen_setup,
    levels_start = Hexen_get_levels,
    begin_level = Hexen_begin_level,
  },

  param =
  {
    -- hexen format is a variation on the Doom format,
    -- and is enabled by the setup function.
    format = "doom",

    rails = true,
    switches = true,
    liquids = true,
    teleporters = true,
    infighting  =  true,
    prefer_stairs = true,
     
    hubs = true,
    polyobjs = true,
    three_part_weapons = true,
    ACS_script = true,

    seed_size = 256,

    max_name_length = 28,

    skip_monsters = { 20,30 },

    mon_time_max = 12,

    mon_damage_max  = 200,
    mon_damage_high = 100,
    mon_damage_low  =   1,

    ammo_factor   = 0.8,
    health_factor = 0.7,
  },

  tables =
  {
    "player_model", HEXEN_PLAYER_MODEL,

    "things",     HEXEN_THINGS,
    "monsters",   HEXEN_MONSTERS,
    "weapons",    HEXEN_WEAPONS,
    "pickups",    HEXEN_PICKUPS,

    "materials",  HEXEN_MATERIALS,
    "combos",     HEXEN_COMBOS,
    "exits",      HEXEN_EXITS,
    "hallways",   HEXEN_HALLWAYS,

    "episodes",   HEXEN_EPISODES,
    "themes",     HEXEN_SUB_THEMES,
    "rooms",      HEXEN_ROOMS,

    "hangs",      HEXEN_OVERHANGS,
    "pedestals",  HEXEN_PEDESTALS,
    "rails",      HEXEN_RAILS,

    "liquids",    HEXEN_LIQUIDS,
    "switches",   HEXEN_SWITCHES,
    "doors",      HEXEN_DOORS,
    "key_doors",  HEXEN_KEY_DOORS,
    "lifts",      HEXEN_LIFTS,

    "pics",       HEXEN_PICS,
    "images",     HEXEN_IMAGES,
    "lights",     HEXEN_LIGHTS,
    "wall_lights", HEXEN_WALL_LIGHTS,
  },
}

