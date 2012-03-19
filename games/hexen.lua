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

  BOOKS01  = { t="BOOKS01",  f="F_092", color=0x2c1b11 }
  BOOKS02  = { t="BOOKS02",  f="F_092", color=0x2d1b0f }
  BOOKS03  = { t="BOOKS03",  f="F_092", color=0x2d1b0f }
  BOOKS04  = { t="BOOKS04",  f="F_092", color=0x2e1b0f }
  BRASS1   = { t="BRASS1",   f="F_037", color=0x5b2c02 }
  BRASS3   = { t="BRASS3",   f="F_037", color=0x532802 }
  BRASS4   = { t="BRASS5",   f="F_037", color=0x542802 }
  CASTLE01 = { t="CASTLE01", f="F_012", color=0x252525 }
  CASTLE02 = { t="CASTLE02", f="F_012", color=0x262625 }
  CASTLE03 = { t="CASTLE03", f="F_012", color=0x262525 }
  CASTLE04 = { t="CASTLE04", f="F_012", color=0x262625 }
  CASTLE05 = { t="CASTLE05", f="F_012", color=0x262525 }
  CASTLE06 = { t="CASTLE06", f="F_012", color=0x262525 }
  CASTLE07 = { t="CASTLE07", f="F_057", color=0x2a2a2a }
  CASTLE08 = { t="CASTLE08", f="F_057", color=0x373736 }
  CASTLE11 = { t="CASTLE11", f="F_073", color=0x3e3426 }

  CAVE01   = { t="CAVE01",   f="F_073", color=0x393023 }
  CAVE02   = { t="CAVE02",   f="F_076", color=0x2e2f2d }
  CAVE03   = { t="CAVE03",   f="F_039", color=0x2f2d20 }
  CAVE04   = { t="CAVE04",   f="F_039", color=0x292b24 }
  CAVE05   = { t="CAVE05",   f="F_007", color=0x21160e }
  CAVE06   = { t="CAVE06",   f="F_039", color=0x262621 }
  CAVE07   = { t="CAVE07",   f="F_008", color=0x1d1c1a }
  CAVE12   = { t="CAVE12",   f="F_076", color=0x383938 }
  CHAP1    = { t="CHAP1",    f="F_082", color=0x4f3317 }
  CHAP2    = { t="CHAP2",    f="F_082", color=0x381b03 }
  CHAP3    = { t="CHAP3",    f="F_082", color=0x232622 }
  CLOCKA   = { t="CLOCKA",   f="F_082", color=0x413d32 }
  CRATE01  = { t="CRATE01",  f="F_049", color=0x3a1c0d }
  CRATE02  = { t="CRATE02",  f="F_051", color=0x31180b }
  CRATE03  = { t="CRATE03",  f="F_050", color=0x2e170b }
  CRATE04  = { t="CRATE04",  f="F_052", color=0x31180b }
  CRATE05  = { t="CRATE05",  f="F_053", color=0x32190c }

  D_AXE    = { t="D_AXE",    f="F_092", color=0x26170d }
  D_BRASS1 = { t="D_BRASS1", f="F_037", color=0x572901 }
  D_BRASS2 = { t="D_BRASS2", f="F_037", color=0x572901 }
  D_CAST   = { t="D_CAST",   f="F_073", color=0x292117 }
  D_CAVE   = { t="D_CAVE",   f="F_073", color=0x291f17 }
  D_CAVE2  = { t="D_CAVE2",  f="F_007", color=0x22170d }
  D_DUNGEO = { t="D_DUNGEO", f="F_092", color=0x27180f }
  D_END1   = { t="D_END1",   f="F_073", color=0x302a21 }
  D_END2   = { t="D_END2",   f="F_073", color=0x322c23 }
  D_END3   = { t="D_END3",   f="F_092", color=0x271409 }
  D_END4   = { t="D_END4",   f="F_092", color=0x26160d }
  D_ENDBR  = { t="D_ENDBR",  f="F_037", color=0x502602 }
  D_ENDSLV = { t="D_ENDSLV", f="F_082", color=0x333333 }
  D_FIRE   = { t="D_FIRE",   f="F_013", color=0x2d2421 }
  D_RUST   = { t="D_RUST",   f="F_073", color=0x2b1e15 }
  D_SILKEY = { t="D_SILKEY", f="F_092", color=0x27150b }
  D_SILVER = { t="D_SILVER", f="F_073", color=0x2b2018 }
  D_SLV1   = { t="D_SLV1",   f="F_066", color=0x383938 }
  D_SLV2   = { t="D_SLV2",   f="F_066", color=0x383938 }
  D_STEEL  = { t="D_STEEL",  f="F_065", color=0x302f2d }
  D_SWAMP  = { t="D_SWAMP",  f="F_018", color=0x242520 }
  D_SWAMP2 = { t="D_SWAMP2", f="F_076", color=0x2e2f2b }
  D_WASTE  = { t="D_WASTE",  f="F_037", color=0x553b19 }
  D_WD01   = { t="D_WD01",   f="F_092", color=0x27150b }
  D_WD02   = { t="D_WD02",   f="F_092", color=0x27150b }
  D_WD03   = { t="D_WD03",   f="F_092", color=0x26160c }
  D_WD04   = { t="D_WD04",   f="F_092", color=0x26160c }
  D_WD05   = { t="D_WD05",   f="F_051", color=0x2d170b }
  D_WD06   = { t="D_WD06",   f="F_051", color=0x2d170b }
  D_WD07   = { t="D_WD07",   f="F_073", color=0x2b1d14 }
  D_WD08   = { t="D_WD08",   f="F_073", color=0x2a1d14 }
  D_WD09   = { t="D_WD09",   f="F_073", color=0x2a1d14 }
  D_WD10   = { t="D_WD10",   f="F_073", color=0x2a1e15 }
  D_WINNOW = { t="D_WINNOW", f="F_073", color=0x2b1b12 }
  DOOR51   = { t="DOOR51",   f="F_082", color=0x323432 }

  FIRE01   = { t="FIRE01",   f="F_032", color=0x171817 }
  FIRE02   = { t="FIRE02",   f="F_032", color=0x1e1e1e }
  FIRE03   = { t="FIRE03",   f="F_032", color=0x1e1e1e }
  FIRE04   = { t="FIRE04",   f="F_032", color=0x1e1f1e }
  FIRE05   = { t="FIRE05",   f="F_032", color=0x191919 }
  FIRE06   = { t="FIRE06",   f="F_013", color=0x292725 }
  FIRE07   = { t="FIRE07",   f="F_013", color=0x292725 }
  FIRE08   = { t="FIRE08",   f="F_013", color=0x2b2927 }
  FIRE09   = { t="FIRE09",   f="F_013", color=0x2b2927 }
  FIRE10   = { t="FIRE10",   f="F_013", color=0x2b2a27 }
  FIRE11   = { t="FIRE11",   f="F_013", color=0x2d2b29 }
  FIRE12   = { t="FIRE12",   f="F_013", color=0x2d2b29 }
  FIRE14   = { t="FIRE14",   f="F_032", color=0x1d1e1d }
  FIRE15   = { t="FIRE15",   f="F_032", color=0x1b1c1b }
  FIRE17   = { t="FIRE17",   f="F_017", color=0x2a231d }

  FOREST01 = { t="FOREST01", f="F_014", color=0x553217 }
  FOREST02 = { t="FOREST02", f="F_038", color=0x151712 }
  FOREST03 = { t="FOREST03", f="F_038", color=0x1d1c15 }
  FOREST04 = { t="FOREST04", f="F_038", color=0x1a1d19 }
  FOREST05 = { t="FOREST05", f="F_048", color=0x334531 }
  FOREST07 = { t="FOREST07", f="F_002", color=0x3c2b14 }
  FOREST10 = { t="FOREST10", f="F_047", color=0x2f271e }
  FOREST11 = { t="FOREST11", f="F_038", color=0x2f302e }
  FORPUZ1  = { t="FORPUZ1",  f="F_005", color=0x5d3517 }
  FORPUZ2  = { t="FORPUZ2",  f="F_038", color=0x291f14 }
  FORPUZ3  = { t="FORPUZ3",  f="F_041", color=0x2a211a }

  GEARW    = { t="GEARW",    f="F_074", color=0x523514 }
  GEARX    = { t="GEARX",    f="F_074", color=0x4a4237 }
  GEARY    = { t="GEARY",    f="F_074", color=0x4c3e2d }
  GEARZ    = { t="GEARZ",    f="F_074", color=0x4f381e }
  GILO1    = { t="GILO1",    f="F_072", color=0x5e5f5e }
  GILO2    = { t="GILO2",    f="F_072", color=0x5e5f5e }

  GLASS01  = { t="GLASS01",  f="F_081", color=0x402f3a }
  GLASS02  = { t="GLASS02",  f="F_081", color=0x2c2e39 }
  GLASS03  = { t="GLASS03",  f="F_081", color=0x3e2b38 }
  GLASS04  = { t="GLASS04",  f="F_081", color=0x2f2a36 }
  GLASS05  = { t="GLASS05",  f="F_081", color=0x3e2633 }
  GLASS06  = { t="GLASS06",  f="F_081", color=0x2d2c39 }
  GRAVE01  = { t="GRAVE01",  f="F_009", color=0x3b3e3a }
  GRAVE03  = { t="GRAVE03",  f="F_009", color=0x383d38 }
  GRAVE04  = { t="GRAVE04",  f="F_009", color=0x3d413d }
  GRAVE05  = { t="GRAVE05",  f="F_009", color=0x3d413d }
  GRAVE06  = { t="GRAVE06",  f="F_009", color=0x3b3f3a }
  GRAVE07  = { t="GRAVE07",  f="F_009", color=0x3a3e3a }
  GRAVE08  = { t="GRAVE08",  f="F_009", color=0x3b3f3a }

  ICE01    = { t="ICE01",    f="F_033", color=0x545269 }
  ICE02    = { t="ICE02",    f="F_040", color=0x302e31 }
  ICE03    = { t="ICE03",    f="F_040", color=0x28282a }
  ICE06    = { t="ICE06",    f="F_040", color=0x343235 }
  MONK01   = { t="MONK01",   f="F_027", color=0x292d29 }
  MONK02   = { t="MONK02",   f="F_025", color=0x462d12 }
  MONK03   = { t="MONK03",   f="F_025", color=0x473624 }
  MONK04   = { t="MONK04",   f="F_025", color=0x463018 }
  MONK05   = { t="MONK05",   f="F_025", color=0x402d19 }
  MONK06   = { t="MONK06",   f="F_025", color=0x43260a }
  MONK07   = { t="MONK07",   f="F_031", color=0x2f312f }
  MONK08   = { t="MONK08",   f="F_031", color=0x292c29 }
  MONK09   = { t="MONK09",   f="F_025", color=0x442a10 }
  MONK11   = { t="MONK11",   f="F_025", color=0x43260a }
  MONK12   = { t="MONK12",   f="F_025", color=0x442a10 }
  MONK14   = { t="MONK14",   f="F_029", color=0x4b3113 }
  MONK15   = { t="MONK15",   f="F_029", color=0x4a3013 }
  MONK16   = { t="MONK16",   f="F_028", color=0x492f12 }
  MONK17   = { t="MONK17",   f="F_028", color=0x482e12 }
  MONK18   = { t="MONK18",   f="F_028", color=0x482e13 }
  MONK19   = { t="MONK19",   f="F_028", color=0x3e260d }
  MONK21   = { t="MONK21",   f="F_028", color=0x3e260d }
  MONK22   = { t="MONK22",   f="F_028", color=0x3e260d }
  MONK23   = { t="MONK23",   f="F_025", color=0x41372d }

  PILLAR01 = { t="PILLAR01", f="F_037", color=0x4b2f13 }
  PILLAR02 = { t="PILLAR02", f="F_044", color=0x373837 }
  PLANET1  = { t="PLANET1",  f="F_025", color=0x2e251d }
  PLANET2  = { t="PLANET2",  f="F_025", color=0x2d251c }
  PLAT01   = { t="PLAT01",   f="F_045", color=0x1f201f }
  PLAT02   = { t="PLAT02",   f="F_065", color=0x1f1f1d }  
  POOT     = { t="POOT",     f="F_048", color=0x334531 }
  PRTL02   = { t="PRTL02",   f="F_057", color=0x373736 }
  PRTL03   = { t="PRTL03",   f="F_019", color=0x222b22 }
  PRTL04   = { t="PRTL04",   f="F_044", color=0x464644 }
  PRTL05   = { t="PRTL05",   f="F_044", color=0x3b3a37 }
  PRTL06   = { t="PRTL06",   f="F_057", color=0x3c3c3c }
  PUZZLE1  = { t="PUZZLE1",  f="F_082", color=0x242220 }
  PUZZLE10 = { t="PUZZLE10", f="F_091", color=0x292929 }
  PUZZLE11 = { t="PUZZLE11", f="F_091", color=0x282928 }
  PUZZLE12 = { t="PUZZLE12", f="F_091", color=0x282928 }
  PUZZLE2  = { t="PUZZLE2",  f="F_082", color=0x24211f }
  PUZZLE3  = { t="PUZZLE3",  f="F_082", color=0x252220 }
  PUZZLE4  = { t="PUZZLE4",  f="F_082", color=0x242220 }
  PUZZLE5  = { t="PUZZLE5",  f="F_091", color=0x2c2c2c }
  PUZZLE6  = { t="PUZZLE6",  f="F_091", color=0x2c2c2c }
  PUZZLE7  = { t="PUZZLE7",  f="F_091", color=0x2c2d2c }
  PUZZLE8  = { t="PUZZLE8",  f="F_091", color=0x2c2d2c }
  PUZZLE9  = { t="PUZZLE9",  f="F_091", color=0x292929 }

  SEWER01  = { t="SEWER01",  f="F_018", color=0x222522 }
  SEWER02  = { t="SEWER02",  f="F_018", color=0x202220 }
  SEWER05  = { t="SEWER05",  f="F_018", color=0x232521 }
  SEWER06  = { t="SEWER06",  f="F_018", color=0x222421 }
  SEWER07  = { t="SEWER07",  f="F_017", color=0x291d16 }
  SEWER08  = { t="SEWER08",  f="F_017", color=0x291f17 }
  SEWER09  = { t="SEWER09",  f="F_017", color=0x291e16 }
  SEWER10  = { t="SEWER10",  f="F_017", color=0x292017 }
  SEWER11  = { t="SEWER11",  f="F_017", color=0x291e16 }
  SEWER12  = { t="SEWER12",  f="F_017", color=0x292017 }
  SEWER13  = { t="SEWER13",  f="F_018", color=0x333533 }

  SPAWN01  = { t="SPAWN01",  f="F_042", color=0x2f302f }
  SPAWN05  = { t="SPAWN05",  f="F_042", color=0x30302f }
  SPAWN08  = { t="SPAWN08",  f="F_065", color=0x201c17 }
  SPAWN11  = { t="SPAWN11",  f="F_078", color=0x202920 }
  SPAWN13  = { t="SPAWN13",  f="F_042", color=0x3e3f3d }
  STEEL01  = { t="STEEL01",  f="F_074", color=0x372417 }
  STEEL02  = { t="STEEL02",  f="F_075", color=0x332214 }
  STEEL05  = { t="STEEL05",  f="F_069", color=0x312f2e }
  STEEL06  = { t="STEEL06",  f="F_069", color=0x2d2c2b }
  STEEL07  = { t="STEEL07",  f="F_070", color=0x484848 }
  STEEL08  = { t="STEEL08",  f="F_078", color=0x333231 }
  SWAMP01  = { t="SWAMP01",  f="F_019", color=0x283226 }
  SWAMP03  = { t="SWAMP03",  f="F_019", color=0x292f29 }
  SWAMP04  = { t="SWAMP04",  f="F_017", color=0x23231d }
  SWAMP06  = { t="SWAMP06",  f="F_017", color=0x343432 }

  TOMB01   = { t="TOMB01",   f="F_058", color=0x2a2a29 }
  TOMB02   = { t="TOMB02",   f="F_058", color=0x292929 }
  TOMB03   = { t="TOMB03",   f="F_058", color=0x373134 }
  TOMB04   = { t="TOMB04",   f="F_058", color=0x1e1f1e }
  TOMB05   = { t="TOMB05",   f="F_059", color=0x683506 }
  TOMB06   = { t="TOMB06",   f="F_059", color=0x66370f }
  TOMB07   = { t="TOMB07",   f="F_044", color=0x342f28 }
  TOMB08   = { t="TOMB08",   f="F_042", color=0x3d3f3d }
  TOMB09   = { t="TOMB09",   f="F_042", color=0x48280c }
  TOMB10   = { t="TOMB10",   f="F_042", color=0x4c2708 }
  TOMB11   = { t="TOMB11",   f="F_044", color=0x332e27 }
  TOMB12   = { t="TOMB12",   f="F_059", color=0x4c3b2b }
  VALVE1   = { t="VALVE1",   f="F_047", color=0x3b2916 }
  VALVE2   = { t="VALVE2",   f="F_047", color=0x3b2915 }
  VILL01   = { t="VILL01",   f="F_030", color=0x3b220d }
  VILL04   = { t="VILL04",   f="F_055", color=0x3a220c }
  VILL05   = { t="VILL05",   f="F_055", color=0x39200c }

  WASTE01  = { t="WASTE01",  f="F_005", color=0x693b18 }
  WASTE02  = { t="WASTE02",  f="F_044", color=0x3d3f3c }
  WASTE03  = { t="WASTE03",  f="F_082", color=0x525551 }
  WASTE04  = { t="WASTE04",  f="F_037", color=0x573c19 }
  WINN01   = { t="WINN01",   f="F_047", color=0x2e2318 }
  WINNOW02 = { t="WINNOW02", f="F_022", color=0x2b2c2b }
  WOOD01   = { t="WOOD01",   f="F_054", color=0x351a0c }
  WOOD02   = { t="WOOD02",   f="F_092", color=0x32190b }
  WOOD03   = { t="WOOD03",   f="F_092", color=0x2d1a0d }
  WOOD04   = { t="WOOD04",   f="F_054", color=0x2b1a0d }

  X_FAC01  = { t="X_FAC01",  f="X_001", sane=1 }
  X_FIRE01 = { t="X_FIRE01", f="X_001", sane=1 }
  X_SWMP1  = { t="X_SWMP1",  f="X_009", sane=1 }
  X_SWR1   = { t="X_SWR1",   f="F_018", sane=1 }
  X_WATER1 = { t="X_WATER1", f="X_005", sane=1 }


  -- steps --

  S_01     = { t="S_01",     f="F_047", color=0x2c2217 }
  S_02     = { t="S_02",     f="F_009", color=0x464846 }
  S_04     = { t="S_04",     f="F_030", color=0x3b2003 }
  S_05     = { t="S_05",     f="F_057", color=0x262622 }
  S_06     = { t="S_06",     f="F_009", color=0x5e615c }
  S_07     = { t="S_07",     f="F_009", color=0x4e4f4d }
  S_09     = { t="S_09",     f="F_047", color=0x363430 }
  S_11     = { t="S_11",     f="F_034", color=0x172614 }
  S_12     = { t="S_12",     f="F_053", color=0x361a0c }
  S_13     = { t="S_13",     f="F_057", color=0x313131 }
  T2_STEP  = { t="T2_STEP",  f="F_057", color=0x323332 }


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

  F_001 = { t="WASTE01",  f="F_001", color=0x351b0c }
  F_002 = { t="WASTE01",  f="F_002", color=0x492f11 }
  F_003 = { t="WASTE01",  f="F_003", color=0x572e13 }
  F_004 = { t="WASTE01",  f="F_004", color=0x3f2911 }
  F_005 = { t="WASTE01",  f="F_005", color=0x5c3314 }
  F_006 = { t="WASTE01",  f="F_006", color=0x4b2c12 }
  F_007 = { t="CAVE05",   f="F_007", color=0x2f1f0f }
  F_008 = { t="CAVE07",   f="F_008", color=0x1d1c1a }
  F_009 = { t="PRTL02",   f="F_009", color=0x383a38 }
  F_010 = { t="PRTL04",   f="F_010", color=0x505150 }
  F_011 = { t="FOREST01", f="F_011", color=0x7c4b28 }
  F_012 = { t="FIRE06",   f="F_012", color=0x262726 }
  F_013 = { t="FIRE06",   f="F_013", color=0x292724 }
  F_014 = { t="MONK16",   f="F_014", color=0x41280f }
  F_015 = { t="CASTLE01", f="F_015", color=0x2d2e2d }
  F_017 = { t="SWAMP04",  f="F_017", color=0x23221d }
  F_018 = { t="SEWER01",  f="F_018", color=0x222522 }
  F_019 = { t="SWAMP01",  f="F_019", color=0x2c372b }
  F_020 = { t="SWAMP01",  f="F_020", color=0x2d362d }
  F_021 = { t="FIRE06",   f="F_021", color=0x201e1d }
  F_022 = { t="FIRE06",   f="F_022", color=0x202020 }
  F_023 = { t="SEWER01",  f="F_023", color=0x1e1f1e }
  F_024 = { t="SEWER07",  f="F_024", color=0x222411 }
  F_025 = { t="MONK02",   f="F_025", color=0x472e12 }
  F_027 = { t="MONK01",   f="F_027", color=0x292d29 }
  F_028 = { t="MONK16",   f="F_028", color=0x4b3113 }
  F_029 = { t="MONK14",   f="F_029", color=0x513515 }
  F_030 = { t="VILL01",   f="F_030", color=0x40210e }
  F_031 = { t="MONK07",   f="F_031", color=0x313331 }
  F_032 = { t="FIRE01",   f="F_032", color=0x171817 }
  F_033 = { t="ICE01",    f="F_033", color=0x727188 }
  F_034 = { t="FOREST02", f="F_034", color=0x141c13 }
  F_037 = { t="WASTE04",  f="F_037", color=0x644623 }
  F_038 = { t="FOREST02", f="F_038", color=0x151712 }
  F_039 = { t="CAVE04",   f="F_039", color=0x222420 }
  F_040 = { t="CAVE04",   f="F_040", color=0x1a1c1a }
  F_041 = { t="FIRE06",   f="F_041", color=0x2a221c }
  F_042 = { t="FIRE06",   f="F_042", color=0x3b3b3b }
  F_043 = { t="WASTE02",  f="F_043", color=0x303230 }
  F_044 = { t="PRTL04",   f="F_044", color=0x4f504e }
  F_045 = { t="WASTE03",  f="F_045", color=0x2e2d2b }
  F_046 = { t="WASTE03",  f="F_046", color=0x413b2f }
  F_047 = { t="TOMB07",   f="F_047", color=0x4c4130 }
  F_048 = { t="FOREST05", f="F_048", color=0x334531 }
  F_049 = { t="CRATE01",  f="F_049", color=0x3a1c0d }
  F_050 = { t="CRATE03",  f="F_050", color=0x2e170b }
  F_051 = { t="CRATE02",  f="F_051", color=0x31180b }
  F_052 = { t="CRATE04",  f="F_052", color=0x31180b }
  F_053 = { t="CRATE05",  f="F_053", color=0x32190c }
  F_054 = { t="WOOD01",   f="F_054", color=0x341a0c }
  F_055 = { t="WOOD01",   f="F_055", color=0x341a0c }
  F_057 = { t="CASTLE07", f="F_057", color=0x282828 }
  F_058 = { t="TOMB04",   f="F_058", color=0x1e1f1e }
  F_059 = { t="TOMB05",   f="F_059", color=0x723804 }

  F_061 = { t="TOMB04",   f="F_061", color=0x3e3f3d }
  F_062 = { t="TOMB04",   f="F_062", color=0x3e403e }
  F_063 = { t="TOMB04",   f="F_063", color=0x3e403e }
  F_064 = { t="TOMB04",   f="F_064", color=0x3b3d3b }
  F_065 = { t="STEEL06",  f="F_065", color=0x313131 }
  F_066 = { t="STEEL07",  f="F_066", color=0x52514f }
  F_067 = { t="STEEL06",  f="F_067", color=0x313130 }
  F_068 = { t="STEEL07",  f="F_068", color=0x52504e }
  F_069 = { t="STEEL06",  f="F_069", color=0x2a2928 }
  F_070 = { t="STEEL07",  f="F_070", color=0x4a4846 }
  F_071 = { t="STEEL05",  f="F_071", color=0x323232 }
  F_072 = { t="STEEL07",  f="F_072", color=0x535352 }
  F_073 = { t="CASTLE11", f="F_073", color=0x302b21 }
  F_074 = { t="STEEL01",  f="F_074", color=0x352215 }
  F_075 = { t="STEEL02",  f="F_075", color=0x392312 }
  F_076 = { t="CAVE02",   f="F_076", color=0x2e302d }
  F_077 = { t="VILL01",   f="F_077", color=0x351f0d }
  F_078 = { t="STEEL06",  f="F_078", color=0x373635 }
  F_081 = { t="GLASS05",  f="F_081", color=0x342a3b }
  F_082 = { t="CASTLE01", f="F_082", color=0x262626 }
  F_083 = { t="CASTLE01", f="F_083", color=0x30302e }
  F_084 = { t="CASTLE01", f="F_084", color=0x323454 }
  F_089 = { t="CASTLE01", f="F_089", color=0x302517 }
  F_091 = { t="CASTLE01", f="F_091", color=0x272420 }
  F_092 = { t="WOOD01",   f="F_092", color=0x341a0c }


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
}


--[[ FIXME: incorporate these color values

-------------
-- Missing --
-------------

F_A501 , color=0x313331 -- This is really F_031 (duplicate)


-------------------------------------------
-- Special / Pics (and/but also Missing) --
-------------------------------------------

BLANK , color=0x040404

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

SPAWN02 , color=0x2f302f
SPAWN03 , color=0x33312d
SPAWN04 , color=0x303030
SPAWN06 , color=0x30302f
SPAWN07 , color=0x30302e
SPAWN09 , color=0x211c17
SPAWN10 , color=0x241a15
SPAWN12 , color=0x2e2f1f

--The following are likely all repressented by F_084
F_085 , color=0x313352
F_086 , color=0x313350
F_087 , color=0x313352
F_088 , color=0x313351


-----------
-- Rails --
-----------

CASTLE09 , color=0x3b3b3b
CAVE11 , color=0x3e3f3d
FIRE16 , color=0x3b3a39
FOREST06 , color=0x412e14
FOREST12 , color=0x30312e
GATE01 , color=0x191b19
GATE02 , color=0x2f2921
GATE03 , color=0x2e2a23
GATE04 , color=0x30291f
GATE51 , color=0x252019
GATE52 , color=0x252019
GATE53 , color=0x27231c
GLASS07 , color=0x2c2231
PRTL07 , color=0x434343
MONK24 , color=0x4a3c2e
SEWER03 , color=0x242421
SEWER04 , color=0x252724
SEWER14 , color=0x373837
SWAMP07 , color=0x383734
TOMB13 , color=0x5b422a
TOMB18 , color=0x333030
VALVE01 , color=0x1c1711
VALVE02 , color=0x1d1711
VILL06 , color=0x2e180a
VILL07 , color=0x2e180a
VILL08 , color=0x2c1809


----------
-- Sane --
----------

BOSSK1 , color=0x272727
BOSSK2 , color=0x2e2d29

GEAR01 , color=0x483d2c
GEAR02 , color=0x39332a
GEAR03 , color=0x39332a
GEAR04 , color=0x38332a
GEAR05 , color=0x39332a
GEAR0A , color=0x392f24
GEAR0B , color=0x382f24

SW51_OFF , color=0x23201e
SW51_ON , color=0x332a20
SW52_OFF , color=0x282928
SW52_ON , color=0x342f28
SW53_DN , color=0x402811
SW53_MD , color=0x402911
SW53_UP , color=0x412a12

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

  Start_Closet =
  {
    _prefab = "START_CLOSET"
    _where  = "chunk"
    _long   = { 192,384 }
    _deep   = { 192,384 }

    step = "F_082"

    door = "D_STEEL"
    track = "STEEL08"
    door_h = 128

    special = 31  -- open and stay open
    tag = 0
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


  ----| ITEMS / KEYS |----

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
    _key    = "k_castle"
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
    _switch = "sw_steel"
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
    _switch = "sw_steel"

    switch_h = 32
    switch = "SW51_OFF"
    side = "STEEL07"
    base = "STEEL07"
    x_offset = 0
    y_offset = 0

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

  switch_demon =
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

  switch_moon =
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
--]]


  ---| HALLWAY PIECES |---

  Hall_Basic_I =
  {
    _prefab = "HALL_BASIC_I"
    _where  = "hallway"
  }

  Hall_Basic_C =
  {
    _prefab = "HALL_BASIC_C"
    _where  = "hallway"
  }

  Hall_Basic_T =
  {
    _prefab = "HALL_BASIC_T"
    _where  = "hallway"
  }

  Hall_Basic_P =
  {
    _prefab = "HALL_BASIC_P"
    _where  = "hallway"
  }

  Hall_Basic_I_Stair =
  {
    _prefab = "HALL_BASIC_I_STAIR"
    _where  = "hallway"

    step = "STEP3"
  }

  Hall_Basic_I_Lift =
  {
    _prefab = "HALL_BASIC_I_LIFT"
    _where  = "hallway"
    _tags   = 1

    -- FIXME: this is doom stuff, need Hexen stuff
    lift = "SUPPORT3"
    top  = { STEP_F1=50, STEP_F2=50 }

    raise_W1 = 130
    lower_WR = 88  -- 120
    lower_SR = 62  -- 123
  }


  ---| BIG JUNCTIONS |---

  Junc_Test_I =
  {
    _prefab = "JUNCTION_OCTO"
    _where  = "big_junc"

    hole = "_SKY"

    east_wall_q = 1
    west_wall_q = 1
  }

  Junc_Test_C =
  {
    _prefab = "JUNCTION_OCTO"
    _where  = "big_junc"

    hole = "_SKY"

    north_wall_q = 1
     east_wall_q = 1
  }

  Junc_Test_T =
  {
    _prefab = "JUNCTION_OCTO"
    _where  = "big_junc"

    hole = "_SKY"

    north_wall_q = 1
  }

  Junc_Test_P =
  {
    _prefab = "JUNCTION_OCTO"
    _where  = "big_junc"

    hole = "_SKY"

    -- leave all walls open
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
    
    hallways  = { Fire_room=50 }
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
                  Dungeon_library=5 }
    caves     = { Cave_gray=50 }
    outdoors  = { Dungeon_outdoors1=50 }
    hallways  = { Dungeon_monktan=40, Dungeon_monktan_large=20,
                  Dungeon_monkgray=30, Dungeon_monkrosette=15 }

    __pictures =
    {
      pic_glass01=20, pic_glass02=2, pic_glass03=20, pic_glass04=2, 
    pic_glass05=20, pic_glass06=2, pic_tomb03=5, pic_books01=15,
    pic_books02=15, pic_brass1=10, pic_tomb06=10, pic_forest11=5,
    pic_monk08=5, pic_planet1=5, pic_monk06=5, pic_monk11=5, 
    pic_spawn13=2, 
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
                  Dungeon_library=5 }
    caves     = { Cave_gray=30, Cave_swamp=5, Cave_green=15 }
    outdoors  = { Dungeon_outdoors2=50 }
    hallways  = { Dungeon_castle_gray=30,  Dungeon_castle_gray_small= 15,
                  Dungeon_castle_yellow=15 }

    facades =
    {
      CASTLE07=50, CASTLE11=10, CAVE01=10, 
      CAVE02=15, PRTL03=10
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
  
    __pictures =
    {
      pic_glass01=20, pic_glass02=2, pic_glass03=20, pic_glass04=2, 
      pic_glass05=20, pic_glass06=2, pic_tomb03=50, pic_books01=15,
      pic_books02=15, pic_brass1=10, pic_tomb06=10, pic_forest11=5,
      pic_monk08=5, pic_planet1=5, pic_monk06=5, pic_monk11=5, 
      pic_spawn13=2, 
      
      Pic_forest11=10, Pic_monk08=10, Pic_winnow02=10, 
      Pic_spawn13=5, Pic_fire14=5, Pic_books01=1,
      Pic_glass01=1, Pic_glass03=1, Pic_glass05=1
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
      ettin=3.0, demon1=2.0, centaur1=1.5, iceguy=3.0
    }
  }

  -- Hypostyle
  hexen_dungeon6 =
  {
    prob = 10

    liquids = { lava=95, icefloor=5 }

    buildings = { Dungeon_castle_gray=30,  Fire_room1= 15,
                  Forest_room3=15, Dungeon_tomb3=10 }
    caves     = { Cave_gray=55, Cave_stalag=25, Fire_room1=10 }
    outdoors  = { Dungeon_outdoors2=50 }
    hallways  = { Dungeon_castle_gray=30,  Fire_room1= 15,
                  Forest_room3=15, Dungeon_tomb3=10 }

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
    hallways  = { Swamp1_castle=20, Dungeon_castle_gray=20, Swamp1_hut=60  }

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
                  Dungeon_castle_gray=15, Dungeon_library=5 }
    caves     = { Cave_gray=30, Cave_green=25, Cave_brown=40 }
    outdoors  = { Forest_outdoors=50 }
    hallways  = { Forest_room3=30, Forest_room2=20, Forest_room3=30,
                  Desert_room_stone=25, Village_room=45,
                  Dungeon_castle_gray=15 }

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

  ---------------------------------------------------------------------------
  -- Ultramix themes                                                       --
  ---------------------------------------------------------------------------

  hexen_ultramix01 =
  {
    prob = 50

    buildings = { Dungeon_monktan=40, Dungeon_monktan_large=20,
                  Dungeon_monkgray=30, Dungeon_monkrosette=15,
                  Dungeon_library=5 }
    caves     = { Cave_gray=50 }
    outdoors  = { Dungeon_outdoors1=50 }
    hallways  = { Dungeon_monktan=40, Dungeon_monktan_large=20,
                  Dungeon_monkgray=30, Dungeon_monkrosette=15 }

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
      bishop=30.0, centaur1=2.0, centaur2=1.5
    }
  }


  -- Castle type dungeon
  hexen_ultramix02 =
  {
    prob = 50

    liquids = { water=25, muck=70, icefloor=5 }

    buildings = { Dungeon_castle_gray=30,  Dungeon_castle_gray_small= 15,
                  Dungeon_castle_gray_chains=5, Dungeon_castle_yellow=15,
                  Dungeon_library=5 }
    caves     = { Cave_gray=30, Cave_swamp=5, Cave_green=15 }
    outdoors  = { Dungeon_outdoors2=50 }
    hallways  = { Dungeon_castle_gray=30,  Dungeon_castle_gray_small= 15,
                  Dungeon_castle_yellow=15 }

    facades =
    {
      CASTLE07=50, CASTLE11=10, CAVE01=10,
      CAVE02=15, PRTL03=10
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
      centaur1=2.0, centaur2=3.0, demon1=3.0
    }

    style_list =
    {
      caves = { none=30, few=70, some=20,  heaps=0 }
      outdoors = { none=50, few=50, some=20,  heaps=0 }
    }
  }


  -- Tombs / necropolis
  hexen_ultramix03 =
  {
    prob = 30

    liquids = { water=25, muck=25, icefloor=25, lava=25 }

    buildings = { Dungeon_tomb1=10, Dungeon_tomb2=10, Dungeon_tomb3=10 }
    caves     = { Cave_gray=50, Cave_swamp=10, Cave_green=5 }
    outdoors  = { Dungeon_outdoors2=50 }
    hallways  = { Dungeon_tomb1=10, Dungeon_tomb2=10, Dungeon_tomb3=10 }

    __pictures =
    {
      pic_glass01=20, pic_glass02=2, pic_glass03=20, pic_glass04=2,
      pic_glass05=20, pic_glass06=2, pic_tomb03=50, pic_books01=15,
      pic_books02=15, pic_brass1=10, pic_tomb06=10, pic_forest11=5,
      pic_monk08=5, pic_planet1=5, pic_monk06=5, pic_monk11=5,
      pic_spawn13=2,

      Pic_forest11=10, Pic_monk08=10, Pic_winnow02=10,
      Pic_spawn13=5, Pic_fire14=5, Pic_books01=1,
      Pic_glass01=1, Pic_glass03=1, Pic_glass05=1
    }

    -- FIXME: other stuff

    monster_prefs =
    {
      bishop=3.0, centaur2=3.0, reiver=15.0
    }

    style_list =
    {
      caves = { none=30, few=70, some=20,  heaps=0 }
      outdoors = { none=50, few=50, some=20,  heaps=0 }
    }
  }

  -- Sewers / effluvium
  hexen_ultramix04 =
  {
    prob = 20

    liquids = { muck=70 }

    buildings = { Dungeon_sewer1=30, Dungeon_sewer2=20,
                  Dungeon_sewer_metal=5 }
    caves     = { Cave_gray=25, Cave_swamp=25 }
    outdoors  = { Dungeon_outdoors2=50 }
    hallways  = { Dungeon_sewer1=30, Dungeon_sewer2=20 }

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
      outdoors = { none=50, few=50, some=20,  heaps=0   }
    }
  }

  hexen_ultramix05 =
  {
    prob = 20

    buildings = { Dungeon_portals1=45, Dungeon_portals2=15 }
    caves     = { Cave_gray=50 }
    outdoors  = { Dungeon_outdoors1=50 }
    hallways  = { Dungeon_portals1=45, Dungeon_portals2=15 }

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
      ettin=3.0, demon1=2.0, centaur1=1.5, iceguy=3.0
    }
  }


  hexen_ultramix06 =
  {
    prob = 20

    liquids = { lava=100 }

    buildings = { Fire_room1=65,  Fire_room2=35,  Fire_lavawalls=5}
    caves     = { Fire_room2=50 }
    outdoors  = { Fire_outdoors=50 }
    hallways  = { Fire_room1=50, Fire_room2=40 }

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
    }
  }


  hexen_ultramix07 =
  {
    prob = 20

    liquids = { icefloor=100 } -- ice1 will use "liquids = { ice=70, water=30 }" instead, for variety.

    buildings = { Ice_room1=65, Ice_room2=35 }
    caves     = { Ice_cave=50 }
    outdoors  = { Ice_outdoors=50 }
    hallways  = { Ice_room1=65, Ice_room2=35 }

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
      caves = { none=30, few=70,  some=30,  heaps=0  }
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


  hexen_ultramix08 =
  {
    prob = 20

    square_caves = true

    liquids = { lava=20, icefloor=10, water=5, muck=5 }

    buildings = { Steel_room_mix=10, Steel_room_gray=35, Steel_room_rust=25 }
    caves     = { Steel_room_mix=10, Steel_room_gray=35, Steel_room_rust=25 }
    outdoors  = { Steel_room_mix=10, Steel_room_gray=35, Steel_room_rust=25 }
    hallways  = { Steel_room_mix=10, Steel_room_gray=35, Steel_room_rust=25 }

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


  hexen_ultramix10 =
  {
    prob = 30

    liquids = { water=30, muck=40, lava=20 }

    buildings = { Desert_room_stone=25, Cave_desert_tan=20,
                  Cave_desert_gray=15, Village_room=25 }
    caves     = { Cave_desert_tan=60, Cave_desert_gray=40,
                  Cave_brown=25 }
    outdoors  = { Desert_outdoors=50 }
    hallways  = { Cave_desert_tan=55, Cave_desert_gray=40 }

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


  hexen_ultramix11 =
  {
    prob = 30

    liquids = { water=60, muck=10, lava=25 }

        --Not sure I like mixing the gray and brown cave themes too much, JB
    buildings = { Cave_room=50, Cave_gray=15, Cave_brown=5 }
    caves     = { Cave_gray=20, Cave_stalag=30, Cave_brown=10 }
    outdoors  = { Cave_outdoors=50 }
    hallways  = { Cave_gray=30, Cave_stalag=20, Cave_brown=10 }

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
      caves      = { none=0,  few=0,  some=0,  heaps=70 }
      odd_shapes = { none=0,  few=0,  some=30, heaps=70 }
      outdoors   = { none=30, few=70, some=5,  heaps=0  }
      crates     = { none=60, few=40, some=0,  heaps=0  }
    }

    monster_prefs =
    {
      demon1=3.0, demon2=3.0
    }

    door_probs   = { out_diff=10, combo_diff= 3, normal=1 }
    window_probs = { out_diff=30, combo_diff=30, normal=5 }
  }


  hexen_ultramix12 =
  {
    prob = 30

    liquids = { muck=100 }  -- for whole mulit-level swamp1 theme this will be "liquids = { muck=80, water 20 }"

    buildings = { Swamp1_castle=20, Dungeon_castle_gray=20, Swamp1_hut=60 }
    caves     = { Cave_swamp=20, Cave_gray=30 }
    outdoors  = { Swamp1_outdoors=50 }
    hallways  = { Swamp1_castle=20, Dungeon_castle_gray=20, Swamp1_hut=60  }

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
      caves = { none=0, few=5, some=80, heaps=10  }
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


  hexen_ultramix13 =
  {
    prob = 30

    liquids = { water=60, muck=15, lava=10 }

    buildings = { Forest_room1=30, Forest_room2=20, Forest_room3=30 }
    caves     = { Cave_gray=30, Cave_green=25, Cave_brown=40 }
    outdoors  = { Forest_outdoors=50 }
    hallways  = { Forest_room3=30, Forest_room2=20, Forest_room3=30 }

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
      caves      = { none=0, few=5,  some=50, heaps=10 }
      outdoors   = { none=0, few=5,  some=50, heaps=10 }
      subrooms   = { none=0, few=15, some=50, heaps=50 }
      islands    = { none=0, few=15, some=50, heaps=50 }
    }
  }

  hexen_ultramix09 =
  {
    prob = 30

    liquids = { water=60, muck=15, lava=10 }

    buildings = { Forest_room1=30, Forest_room2=20, Forest_room3=30,
                  Desert_room_stone=25, Village_room=45, Village_brick=25,
                  Dungeon_castle_gray=15, Dungeon_library=5 }
    caves     = { Cave_gray=30, Cave_green=25, Cave_brown=40 }
    outdoors  = { Forest_outdoors=50 }
    hallways  = { Forest_room3=30, Forest_room2=20, Forest_room3=30,
                  Desert_room_stone=25, Village_room=45,
                  Dungeon_castle_gray=15 }

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
    level = 2
    prob = 3
    skip_prob = 300
    health = 120
    damage = 25 -- not sure the basis of 16, but this guys does a lot of damage!
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
    theme = "ULTRAMIX"
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
  [17] = "hexen_wild4"
  [24] = "hexen_dungeon1"
  [25] = "hexen_dungeon4"
  [35] = "hexen_dungeon2"
}


function HEXEN.setup()

end


function HEXEN.get_levels()
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

      -- make certain levels match original
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
  name_theme = "URBAN"
  mixed_prob = 20
}

OB_THEMES["hexen_ultramix"] =
{
  label = "Ultramix"
  for_games = { hexen=1 }
  name_theme = "GOTHIC"
  mixed_prob = 20
}

