----------------------------------------------------------------
-- GAME DEF : Hexen
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2008 Andrew Apted
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

HEXEN_LINE_TYPES =
{
  -- FIXME: speeds (16) and delays (64) are just guesses!!

  --- general ---

  A1_scroll_left  = { kind=100, args={ 16 } },
  A1_scroll_right = { kind=101, args={ 16 } },
  A1_scroll_up    = { kind=102, args={ 16 } },
  A1_scroll_down  = { kind=103, args={ 16 } },

  -- FIXME: exit types not right
  S1_exit = { kind=75 },
  W1_exit = { kind=75 },
  S1_secret_exit = { kind=75 },
  W1_secret_exit = { kind=75 },

  WR_teleport = { kind=70 },
  MR_teleport = { kind=70 },  -- monster only

  S1_bars = { kind=21, args={ "tag", 16 } },

  --- doors ---

  PR_door       = { kind=12, args={ 0,16 } },
  PR_blaze_door = { kind=12, args={ 0,32 } },

  W1_door       = { kind=11, args={ "tag", 16 } },
  S1_door       = { kind=11, args={ "tag", 16 } },

  SR_door       = { kind=12, args={ "tag", 16, 64 } },
  SR_blaze_door = { kind=12, args={ "tag", 16, 64 } },

  P1_fire_door   = { kind=13, args={ 0, 16, 64, 4 }  },
  PR_fire_door   = { kind=13, args={ 0, 16, 64, 4 }  },
  P1_castle_door = { kind=13, args={ 0, 16, 64, 11 } },
  PR_castle_door = { kind=13, args={ 0, 16, 64, 11 } },
  P1_silver_door = { kind=13, args={ 0, 16, 64, 7 }  },
  PR_silver_door = { kind=13, args={ 0, 16, 64, 7 }  },

  --- lifts ---

  SR_lift = { kind=62, args={ "tag", 16, 64 } },
  WR_lift = { kind=62, args={ "tag", 16, 64 } },

  SR_blaze_lift = { kind=62, args={ "tag", 32, 64 } },
  WR_blaze_lift = { kind=62, args={ "tag", 32, 64 } },
}

HEXEN_SECTOR_TYPES =
{
  -- FIXME
}


----------------------------------------------------------------

HEXEN_PALETTE =
{
    2,  2,  2,   4,  4,  4,  15, 15, 15,  19, 19, 19,  27, 27, 27,
   28, 28, 28,  33, 33, 33,  39, 39, 39,  45, 45, 45,  51, 51, 51,
   57, 57, 57,  63, 63, 63,  69, 69, 69,  75, 75, 75,  81, 81, 81,
   86, 86, 86,  92, 92, 92,  98, 98, 98, 104,104,104, 112,112,112,
  121,121,121, 130,130,130, 139,139,139, 147,147,147, 157,157,157,
  166,166,166, 176,176,176, 185,185,185, 194,194,194, 203,203,203,
  212,212,212, 221,221,221, 230,230,230,  29, 32, 29,  38, 40, 37,
   50, 50, 50,  59, 60, 59,  69, 72, 68,  78, 80, 77,  88, 93, 86,
   97,100, 95, 109,112,104, 116,123,112, 125,131,121, 134,141,130,
  144,151,139, 153,161,148, 163,171,157, 172,181,166, 181,189,176,
  189,196,185,  22, 29, 22,  27, 36, 27,  31, 43, 31,  35, 51, 35,
   43, 55, 43,  47, 63, 47,  51, 71, 51,  59, 75, 55,  63, 83, 59,
   67, 91, 67,  75, 95, 71,  79,103, 75,  87,111, 79,  91,115, 83,
   95,123, 87, 103,131, 95,  20, 16, 36,  30, 26, 46,  40, 36, 57,
   50, 46, 67,  59, 57, 78,  69, 67, 88,  79, 77, 99,  89, 87,109,
   99, 97,120, 109,107,130, 118,118,141, 128,128,151, 138,138,162,
  148,148,172,  62, 40, 11,  75, 50, 16,  84, 59, 23,  95, 67, 30,
  103, 75, 38, 110, 83, 47, 123, 95, 55, 137,107, 62, 150,118, 75,
  163,129, 84, 171,137, 92, 180,146,101, 188,154,109, 196,162,117,
  204,170,125, 208,176,133,  27, 15,  8,  38, 20, 11,  49, 27, 14,
   61, 31, 14,  65, 35, 18,  74, 37, 19,  83, 43, 19,  87, 47, 23,
   95, 51, 27, 103, 59, 31, 115, 67, 35, 123, 75, 39, 131, 83, 47,
  143, 91, 51, 151, 99, 59, 160,108, 64, 175,116, 74, 180,126, 81,
  192,135, 91, 204,143, 93, 213,151,103, 216,159,115, 220,167,126,
  223,175,138, 227,183,149,  37, 20,  4,  47, 24,  4,  57, 28,  6,
   68, 33,  4,  76, 36,  3,  84, 40,  0,  97, 47,  2, 114, 54,  0,
  125, 63,  6, 141, 75,  9, 155, 83, 17, 162, 95, 21, 169,103, 26,
  180,113, 32, 188,124, 20, 204,136, 24, 220,148, 28, 236,160, 23,
  244,172, 47, 252,187, 57, 252,194, 70, 251,201, 83, 251,208, 97,
  251,221,123,   2,  4, 41,   2,  5, 49,   6,  8, 57,   2,  5, 65,
    2,  5, 79,   0,  4, 88,   0,  4, 96,   0,  4,104,   4,  6,121,
    2,  5,137,  20, 23,152,  38, 41,167,  56, 59,181,  74, 77,196,
   91, 94,211, 109,112,226, 127,130,240, 145,148,255,  31,  4,  4,
   39,  0,  0,  47,  0,  0,  55,  0,  0,  67,  0,  0,  79,  0,  0,
   91,  0,  0, 103,  0,  0, 115,  0,  0, 127,  0,  0, 139,  0,  0,
  155,  0,  0, 167,  0,  0, 185,  0,  0, 202,  0,  0, 220,  0,  0,
  237,  0,  0, 255,  0,  0, 255, 46, 46, 255, 91, 91, 255,137,137,
  255,171,171,  20, 16,  4,  13, 24,  9,  17, 33, 12,  21, 41, 14,
   24, 50, 17,  28, 57, 20,  32, 65, 24,  35, 73, 28,  39, 80, 31,
   44, 86, 37,  46, 95, 38,  51,104, 43,  60,122, 51,  68,139, 58,
   77,157, 66,  85,174, 73,  94,192, 81, 157, 51,  4, 170, 65,  2,
  185, 86,  4, 213,119,  6, 234,147,  5, 255,178,  6, 255,195, 26,
  255,216, 45,   4,133,  4,   8,175,  8,   2,215,  2,   3,234,  3,
   42,252, 42, 121,255,121,   3,  3,184,  15, 41,220,  28, 80,226,
   41,119,233,  54,158,239,  67,197,246,  80,236,252, 244, 14,  3,
  255, 63,  0, 255, 95,  0, 255,127,  0, 255,159,  0, 255,195, 26,
  255,223,  0,  43, 13, 64,  61, 14, 89,  90, 15,122, 120, 16,156,
  149, 16,189, 178, 17,222, 197, 74,232, 215,129,243, 234,169,253,
   61, 16, 16,  90, 36, 33, 118, 56, 49, 147, 77, 66, 176, 97, 83,
  204,117, 99,  71, 53,  2,  81, 63,  6,  96, 72,  0, 108, 80,  0,
  120, 88,  0, 128, 96,  0, 149,112,  1, 181,136,  3, 212,160,  4,
  255,255,255,
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

    trim_mode = "rough_hew",
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


---- BASE MATERIALS ------------

HEXEN_MATS =
{
  METAL =
  {
    mat_pri = 5,

    wall  = "PLAT01", void = "PLAT01",
    floor = "F_065",  ceil = "F_065",
  },

  STEP =
  {
    wall  = "S_09",
    floor = "F_014",
  },

  LIFT =
  {
    wall  = "PLAT02",
    floor = "F_065"
  },

  TRACK =
  {
    wall  = "STEEL08",
    floor = "F_008",
  },

  DOOR_FRAME =
  {
    wall  = nil,  -- this means: use plain wall
    floor = "F_009",
    ceil  = "F_009",
  },
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

HEXEN_RAILS =
{
  r_1 = { wall="GATE03", w=64, h=64  },
  r_2 = { wall="GATE02", w=64, h=128 },
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


---- QUEST STUFF ----------------

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

HEXEN_THEMES =
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

    diff_probs = { [0]=10, [16]=40, [32]=80, [64]=60, [96]=20 },
    bump_probs = { [0]=5, [16]=30, [32]=30, [64]=20 },
    door_probs   = { out_diff=10, combo_diff= 3, normal=1 },
    window_probs = { out_diff=30, combo_diff=30, normal=5 },
    space_range  = { 1, 50 },

    trim_mode = "rough_hew",
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


HEXEN_DOOR_PREFABS =
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

-- HEXEN_DEATHMATCH_EXITS =
-- {
--   exit_dm_GREEN =
--   {
--     prefab = "EXIT_DEATHMATCH",
-- 
--     skin = { wall="FOREST05", front_w="FOREST05",
--              floor="F_009", ceil="F_009",
--              switch_w="SW51_OFF", side_w="FIRE07", switch_f="F_013",
--              frame_f="F_048", frame_c="F_048",
--              door_w="D_BRASS1", door_c="F_075",
-- 
--              inside_h=160, door_h=128,
--              switch_yo=0,  tag=0,
-- 
--              door_kind  ={ id=12, act="S1", args={0, 16, 64} },
--              switch_kind={ id=
--            },
--   },
-- }


HEXEN_INITIAL_MODEL =
{
  fighter =
  {
    health = 100,
    weapons = { f_gaunt=1 },
    ammo = { blue_mana=0, green_mana=0 },
  },

  cleric =
  {
    health = 100,
    weapons = { c_mace=1 },
    ammo = { blue_mana=0, green_mana=0 },
  },

  mage =
  {
    health = 100,
    weapons = { m_wand=1 },
    ammo = { blue_mana=0, green_mana=0 },
  },
}


HEXEN_MONSTERS =
{
  ettin =
  {
    prob=60, guard_prob=11, trap_prob=11,
    health=170, damage= 6, attack="melee",
  },

  afrit =
  {
    prob=40, guard_prob=11, cage_prob=11, trap_prob=11,
    health=80,  damage=20, attack="missile",
    float=true,
  },

  centaur1 =
  {
    prob=40, guard_prob=11, trap_prob=11,
    health=200, damage=12, attack="melee",
  },

  centaur2 =
  {
    prob=20, guard_prob=11, cage_prob=11, trap_prob=11,
    health=250, damage=20, attack="missile"
  },

  serpent1 =
  {
    health=90,  damage=10, attack="melee"
  },

  serpent2 =
  {
    health=90,  damage=16, attack="missile",
  },

  iceguy =
  {
    prob=3, guard_prob=11, trap_prob=11,
    health=120, damage=16, attack="missile",
  },

  demon1 =
  {
    prob=30, guard_prob=11, cage_prob=11, trap_prob=11,
    health=250, damage=35, attack="missile",
  },

  demon2 =
  {
    prob=20, guard_prob=11, cage_prob=11, trap_prob=11,
    health=250, damage=35, attack="missile",
  },

  bishop =
  {
    prob=20, guard_prob=11, cage_prob=11, trap_prob=11,
    health=130, damage=24, attack="missile",
    float=true,
  },

  reiver =
  {
    prob=5, guard_prob=11, cage_prob=11, trap_prob=11,
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
    class = "cleric",
  },

  c_staff =
  {
    pref=30, add_prob=10,
    rate=3.5, damage=36, attack="missile",
    ammo="blue_mana",  per=1,
    class = "cleric",
  },

  c_fire =
  {
    pref=60, add_prob=10,
    rate=1.6, damage=64, attack="missile",
    ammo="green_mana", per=4,
    class = "cleric",
  },

  c_wraith =
  {
    pref=20,
    rate=1.7, damage=200, attack="missile", splash={ 50,35,20,1 },
    ammo="dual_mana",  per=18,
    class = "cleric",
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
    class="fighter",
  },

  f_hammer =
  {
    pref=60, add_prob=10,
    rate=1.1, damage=100, attack="missile",
    ammo="green_mana", per=3,
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
    class="mage",
  },

  m_blitz =
  {
    pref=60, add_prob=10,
    rate=1.0, damage=80, attack="missile",
    ammo="green_mana", per=5,
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
  -- melee range).  The damage value then is somewhere in between
  -- the projectile damage and melee damage.
  --
  -- Exactly how much damage the BIG weapons can do depends a lot
  -- on how many monsters are in view.  The damage values above are
  -- nothing but guesses.
}


HEXEN_WEAPON_NAMES =
{
  fighter = { "f_gaunt", "f_axe",   "f_hammer", "f_quietus" },
  cleric  = { "c_mace",  "c_staff", "c_fire",   "c_wraith"  },
  mage    = { "m_wand",  "m_cone",  "m_blitz",  "m_scourge" },
}

HEXEN_WEAPON_PIECES =
{
  fighter = { "f1_hilt",  "f2_cross", "f3_blade" },
  cleric  = { "c1_shaft", "c2_cross", "c3_arc"   },
  mage    = { "m1_stick", "m2_stub",  "m3_skull" },
}

HEXEN_PICKUPS =
{
  h_vial  = { stat="health", give=10,  prob=70 },
  h_flask = { stat="health", give=25,  prob=25 },
  h_urn   = { stat="health", give=100, prob=5, max_clu=1 },

  -- FIXME: these give values are CRAP!
  ar_mesh   = { stat="armor", give=100, prob=50 },
  ar_shield = { stat="armor", give=100, prob=70 },
  ar_helmet = { stat="armor", give=100, prob=90 },
  ar_amulet = { stat="armor", give=100, prob=50 },

  blue_mana  = { stat="blue_mana",  give=10 },
  green_mana = { stat="green_mana", give=10 },
  dual_mana  = { stat="dual_mana",  give=20 },
}

HEXEN_NICENESS =
{
  a1 = { pickup="ar_mesh",   prob=3 },
  a2 = { pickup="ar_shield", prob=3 },
  a3 = { pickup="ar_helmet", prob=3 },
  a4 = { pickup="ar_amulet", prob=3 },

  p1 = { pickup="flechette", prob=9 },
  p2 = { pickup="bracer",    prob=5 },
  p3 = { pickup="torch",     prob=2 },
}

HEXEN_DEATHMATCH =
{
  weapons =
  {
    c_staff=40, c_fire  =40,
    f_axe  =40, f_hammer=40,
    m_cone =40, m_blitz =40,
  },

  health =
  { 
    h_vial=50, h_flask=50, h_urn=5
  },

  ammo =
  { 
    blue_mana=50, green_mana=50, dual_mana=80, krater=1
  },

  items =
  {
    ar_mesh=100, ar_shield=100, ar_helmet=100, ar_amulet=100,

    flechette=30, bracer=20, incant=3, boots=8,
    wings=3, chaos=10, banish=10, repulser=10,
    torch=10, porkies=20, defender=1,
  },

  cluster = {}
}


------------------------------------------------------------

HEXEN_THEME_LIST =
{
  "CAVE", "DUNGEON", "ICE", "SWAMP", "VILLAGE"
}

HEXEN_SKY_INFO =
{
  { color="orange", light=176 },
  { color="blue",   light=144 },
  { color="blue",   light=192, lightning=true },
  { color="red",    light=192 },
  { color="gray",   light=176, foggy=true },
}

HEXEN_KEY_PAIRS =
{
  { key_A="k_emerald", key_B="k_cave" },
  { key_A="k_silver",  key_B="k_swamp" },
  { key_A="k_steel",   key_B="k_rusty" },
  { key_A="k_fire",    key_B="k_dungeon" },
  { key_A="k_horn",    key_B="k_castle" },
}

HEXEN_LEVELS =
{
  --- Cluster 1 ---
  {
    { map=1, sky_info=HEXEN_SKY_INFO[3] },
    { map=2, sky_info=HEXEN_SKY_INFO[4] },
    { map=3, sky_info=HEXEN_SKY_INFO[4] },
    { map=4, sky_info=HEXEN_SKY_INFO[4] },
    { map=5, sky_info=HEXEN_SKY_INFO[4] },
    { map=6, sky_info=HEXEN_SKY_INFO[4], boss_kind="centaur2" },
  },

  --- Cluster 2 ---
  {
    { map=13, sky_info=HEXEN_SKY_INFO[1] },
    { map= 8, sky_info=HEXEN_SKY_INFO[5] },
    { map= 9, sky_info=HEXEN_SKY_INFO[1] },
    { map=10, sky_info=HEXEN_SKY_INFO[1] },
    { map=11, sky_info=HEXEN_SKY_INFO[5] },
    { map=12, sky_info=HEXEN_SKY_INFO[1], boss_kind="Wyvern" },
  },

  --- Cluster 3 ---
  {
    -- Note: MAP30 is never used (FIXME: super-secret level)

    { map=27, sky_info=HEXEN_SKY_INFO[4] },
    { map=28, sky_info=HEXEN_SKY_INFO[4] },
    { map=31, sky_info=HEXEN_SKY_INFO[4] },
    { map=32, sky_info=HEXEN_SKY_INFO[5] },
    { map=33, sky_info=HEXEN_SKY_INFO[4] },
    { map=34, sky_info=HEXEN_SKY_INFO[4], boss_kind="Heresiarch" },
  },

  --- Cluster 4 ---
  {
    { map=21, sky_info=HEXEN_SKY_INFO[3] }, 
    { map=22, sky_info=HEXEN_SKY_INFO[3] }, 
    { map=23, sky_info=HEXEN_SKY_INFO[3] }, 
    { map=24, sky_info=HEXEN_SKY_INFO[3] }, 
    { map=25, sky_info=HEXEN_SKY_INFO[3] }, 
    { map=26, sky_info=HEXEN_SKY_INFO[3], boss_kind="Heresiarch" },
  },

  --- Cluster 5 ---
  {
    { map=35, sky_info=HEXEN_SKY_INFO[3] },
    { map=36, sky_info=HEXEN_SKY_INFO[3] },
    { map=37, sky_info=HEXEN_SKY_INFO[4] },
    { map=38, sky_info=HEXEN_SKY_INFO[3] },
    { map=39, sky_info=HEXEN_SKY_INFO[3] },
    { map=40, sky_info=HEXEN_SKY_INFO[4], boss_kind="Korax" },
  },
}

HEXEN_QUEST_LEN_PROBS =
{
  ----------  2   3   4   5   6   7   8   9  10  -------

  switch = {  0, 40, 90, 90, 25, 2 },
  gate   = {  1, 50, 90, 50, 20, 5 },
  back   = {  0, 10, 40, 90, 50, 25, 3 },

  key    = {  0,  0, 30, 70, 90, 70, 30, 15, 2 },
  item   = { 15, 90, 70, 25, 3 },
  weapon = { 30, 60, 10,  2 },

  boss   = {  0,  5, 40, 90, 60, 30, 10, 1 },
}

function hexen_get_levels(episode)

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

      toughness_factor = 1 + (episode-1) / 3,
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


function Hexen1_setup()

  gui.property("hexen_format", "true")

  rand_shuffle(HEXEN_KEY_PAIRS)

  return
  {
    hexen_format = true,

    plan_size = 9,
    cell_size = 9,
    cell_min_size = 6,

    SKY_TEX    = "F_SKY",
    ERROR_TEX  = "ABADONE",
    ERROR_FLAT = "F_033",

    episodes   = 5,
    level_func = hexen_get_levels,

    classes  = { "fighter", "cleric", "mage" },

    things   = HEXEN_THINGS,
    monsters = HEXEN_MONSTERS,
    weapons  = HEXEN_WEAPONS,

    dm = HEXEN_DEATHMATCH,

    pickups = HEXEN_PICKUPS,
    pickup_stats = { "health", "blue_mana", "green_mana" },
    niceness = HEXEN_NICENESS,

    initial_model = HEXEN_INITIAL_MODEL,

    combos    = HEXEN_COMBOS,
    exits     = HEXEN_EXITS,
    hallways  = HEXEN_HALLWAYS,

    rooms     = HEXEN_ROOMS,
    themes    = HEXEN_THEMES,

    hangs     = HEXEN_OVERHANGS,
    pedestals = HEXEN_PEDESTALS,
    mats      = HEXEN_MATS,
    rails     = HEXEN_RAILS,

    liquids   = HEXEN_LIQUIDS,
    switches  = HEXEN_SWITCHES,
    doors     = HEXEN_DOORS,
    key_doors = HEXEN_KEY_DOORS,
    lifts     = HEXEN_LIFTS,

    pics      = HEXEN_PICS,
    images    = HEXEN_IMAGES,
    lights    = HEXEN_LIGHTS,
    wall_lights = HEXEN_WALL_LIGHTS,

    door_fabs = HEXEN_DOOR_PREFABS,
    wall_fabs = HEXEN_WALL_PREFABS,
    sc_fabs   = HEXEN_SCENERY_PREFABS,
    misc_fabs = HEXEN_MISC_PREFABS,

    toughness_factor = 0.66,

    room_heights = { [96]=5, [128]=25, [192]=70, [256]=70, [320]=12 },
    space_range  = { 20, 90 },
    
    diff_probs = { [0]=20, [16]=40, [32]=80, [64]=30, [96]=5 },
    bump_probs = { [0]=30, [16]=30, [32]=20, [64]=5 },
    
    door_probs   = { out_diff=75, combo_diff=50, normal=15 },
    window_probs = { out_diff=80, combo_diff=50, normal=30 },
  }
end


------------------------------------------------------------

UNFINISHED["hexen"] =
{
  label = "Hexen",

  format = "doom",

  setup_func = Hexen1_setup,

  caps =
  {
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
  },

  params =
  {
    seed_size = 256,

    max_level_desc = 28,

    palette_mons = 3,
  },

  hooks =
  {
  },
}


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

