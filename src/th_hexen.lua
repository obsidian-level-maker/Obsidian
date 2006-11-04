----------------------------------------------------------------
-- THEMES : Hexen
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006 Andrew Apted
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

XN_THEMES =
{
  ---- INDOOR ------------

  EXITROOM =
  {
    mat_pri = 9,

    wall = "STEEL01",
    void = "STEEL02",
    dm_switch = "SW_1_UP",
    
    floor = "F_022",
    ceil = "F_044",

    is_special = true,
  },

  GOLD =
  {
    mat_pri = 6,

    wall = "FOREST01",
    void = "WINNOW02",
    pillar = "PILLAR01",

    floor = "F_089",
    ceil = "F_014",

    scenery = "brass_brazier",
  },

  ICY =
  {
    mat_pri = 1,

    wall = "ICE06",
    void = "ICE02",
    pillar = "ICE01",

    floor = "F_033",  -- F_013
    ceil  = "F_009",

    bad_liquid = "lava",
  },

  FIREY =
  {
    mat_pri = 5,

    wall = "FIRE01",
    void = "FIRE09",
    pillar = "FIRE15",

    floor = "F_012",
    ceil  = "F_032",

    good_liquid = "lava",
  },

  CAVE =
  {
    mat_pri = 2,

    wall = "CAVE06",
    void = "CAVE03",
    
    floor = "F_040",
    ceil  = "F_040",

    scenery = "stal_pillar",
  },

  ---- OUTDOOR ------------

  GRAY =
  {
    outdoor = true,
    mat_pri = 4,

    wall = "PRTL02",
    void = "PRTL03",

    floor = "F_019",
    ceil  = "F_SKY",

    scenery = "short_statue",
  },
  
  STONY =
  {
    outdoor = true,
    mat_pri = 3,

    wall = "CAVE01",
    void = "CAVE02",

    floor = "F_007",
    ceil = "F_SKY",

    scenery = "lean_tree_L",
  },
}


---- BASE MATERIALS ------------

XN_MATS =
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

XN_PEDESTALS =
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

XN_OVERHANGS =
{
  WOOD =
  {
    ceil = "F_054",
    upper = "D_WD07",
    thin = "WOOD01",
  },
}


---- MISC STUFF ------------

XN_LIQUIDS =
{
  { name="water", floor="X_005" },
  { name="lava",  floor="X_001" },
  { name="slime", floor="X_009" },
}

XN_SWITCHES =
{
  sw_rock = { wall="STEEL06", switch="SW_1_UP" },

  sw_exit = { wall="STEEL06", switch="SW_2_UP" },
}

XN_DOORS =
{
  d_big    = { tex="DOOR51",   w=128, h=128 },
  d_brass1 = { tex="BRASS3",   w=128, h=128 },
  d_brass2 = { tex="D_BRASS2", w=64,  h=128 },

  d_wood1  = { tex="D_WD07",   w=128, h=128 },
  d_wood2  = { tex="D_WD08",   w=64,  h=128 },
  d_wood3  = { tex="D_WD10",   w=64,  h=128 },

  -- lockable doors -- FIXME: the rest??
  d_silver = { tex="D_SILVER", w=64,  h=128, is_special=true },
  d_castle = { tex="D_CAST",   w=64,  h=128, is_special=true },
  d_fire   = { tex="D_FIRE",   w=64,  h=128, is_special=true },

  d_exit   = { tex="FIRE14",   w=64,  h=128, is_special=true },
}

XN_RAILS =
{
  r_1 = { tex="GATE03", w=64, h=64  },
  r_2 = { tex="GATE02", w=64, h=128 },
}

XN_LIGHTS =
{
  { tex="X_FIRE01", w=16 },

  { flat="F_081", side="FIRE07" },
  { flat="F_084", side="FIRE07" },
  { flat="X_012", side="FIRE07" },
}

XN_PICS =
{
}

XN_KEY_BITS =
{
  k_fire   = { door="d_fire",   kind_rep=13, kind_once=13 },
  k_castle = { door="d_castle", kind_rep=13, kind_once=13 },
  k_silver = { door="d_silver", kind_rep=13, kind_once=13 },
}


---- QUEST STUFF ----------------

XN_QUESTS = --FIXME
{
  key =
  {
    k_fire = 50, k_castle = 50, k_silver = 50,

--    k_steel   = 80, k_cave    = 80,
--    k_axe     = 80, k_dungeon = 80,
--    k_waste   = 80, k_swamp   = 80,
--    k_rusty   = 80, k_gold    = 80,
  },
  switch =
  {
    sw_rock=50
  },
  weapon =
  {
    c_staff = 40, c_fire   = 40,
    f_axe   = 40, f_hammer = 40,
    m_cone  = 40, m_blitz  = 40,
  },
  item =
  {
    -- torch=10,
    wings=50,
    chaos=30,
  },
  exit =
  {
    ex_stone=50
  }
}


------------------------------------------------------------

XN_THING_NUMS =
{
  --- special stuff ---
  player1 = 1,
  player2 = 2,
  player3 = 3,
  player4 = 4,
  dm_player = 11,
  teleport_spot = 14,
  
  --- monsters ---
  ettin    = 10030,
  afrit    = 10060,
  serpent1 = 121,
  serpent2 = 120,
  wendigo  = 8020,
  centaur1 = 107,
  centaur2 = 115,

  stalker1   = 31,
  stalker2   = 8080,
  bishop     = 114,
  reiver     = 34,
  reiver_bd  = 10011,
  wyvern     = 254,

  heresiarch   = 10080,
  fighter_boss = 10100,
  cleric_boss  = 10101, 
  mage_boss    = 10102,
  korax        = 10200,

  --- pickups ---
  k_steel   = 8030,
  k_cave    = 8031,
  k_axe     = 8032,
  k_fire    = 8033,
  k_castle  = 8034,
  k_dungeon = 8035,
  k_silver  = 8036,
  k_rusty   = 8037,
  k_waste   = 8038,
  k_swamp   = 8039,
  k_gold    = 8200,
 
  c_staff   = 10,
  c_fire    = 8009,
  c1_shaft  = 20,
  c2_cross  = 19,
  c3_arc    = 18,

  f_axe     = 8010,
  f_hammer  = 123,
  f1_hilt   = 16,
  f2_cross  = 13,
  f3_blade  = 12,

  m_cone    = 53,
  m_blitz   = 8040,
  m1_stick  = 23,
  m2_stub   = 22,
  m3_skull  = 21,

  blue_mana  = 122,
  green_mana = 124,
  combo_mana = 8004,

  ar_mesh   = 8005,
  ar_shield = 8006,
  ar_helmet = 8007,
  ar_amulet = 8008,

  h_vial  = 81,
  h_flask = 82,
  h_urn   = 32,

  wings = 83,
  chaos = 36,
  torch = 33,

  banish    = 10040,
  boots     = 8002,
  bracer    = 8041,
  repulser  = 8000,
  flechette = 10110,
  servant   = 86, 
  porkies   = 30,
  incant    = 10120,
  defender  = 84,
  krater    = 8003,

  --- scenery ---
  candle = 119,
  blue_candle = 8066,
  brass_brazier = 8061,
  wall_torch = 54,
  wall_torch_out = 55,
  twine_torch = 116,
  twine_torch_out = 117,

  tree1 = 25,
  tree2 = 8062,
  lean_tree_R = 78,
  lean_tree_L = 79,
  gnarled_tree_R = 80,
  gnarled_tree_L = 87,
  dead_tree = 24,

  hedge = 8068,
  shrub1 = 8101,
  shrub2 = 8102,
  rock1 = 6,
  rock2 = 7,
  rock3 = 9,
  rock4 = 15,

  winged_statue = 5,
  garg_statue = 72,
  short_statue = 74,
  iron_maiden = 8067,
  vase_pillar = 103,

  bell = 8065,  -- we are saved!!
  bucket = 8103,
  banner = 77,

  stal_pillar = 48,
  big_stal_F = 49,
  big_stal_C = 52,
  medium_stal_F = 50,
  medium_stal_C = 56,
  small_stal_F = 51,
  small_stal_C = 57,

  -- FIXME: lots more...

  --- sounds ---
  snd_stone  = 1400,
  snd_heavy  = 1401,
  snd_metal1 = 1402,
  snd_creak  = 1403,
  snd_silent = 1404,
  snd_lava   = 1405,
  snd_water  = 1406,
  snd_ice    = 1407,
  snd_earth  = 1408,
  snd_metal2 = 1409,
}

XN_INITIAL_MODEL =
{
  health=100, armor=0,
  blue_mana=0, green_mana=0,
  f_gaunt=true -- FIXME: classes
}

XN_MONSTERS =
{
  -- FIXME: these stats are CRAP!
  ettin      = { prob=70, r=24,h=64, hp=170, dm= 5, fp= 1, melee=true },
  serpent1   = { prob=30, r=33,h=70, hp=90,  dm= 9, fp=10, },
  afrit      = { prob=70, r=24,h=64, hp=80,  dm=10, fp= 1, float=true, cage_fallback=2 },
  serpent2   = { prob=20, r=33,h=70, hp=90,  dm=15, fp=10, },
  wendigo    = { prob=20, r=24,h=80, hp=120, dm=25, fp=10, environ="ice" },
  centaur1   = { prob=30, r=20,h=64, hp=200, dm=10, fp=10, melee=true},
  centaur2   = { prob=15, r=20,h=64, hp=250, dm=20, fp=10, },

  stalker1   = { prob=30, r=33,h=64, hp=250, dm=60, fp=10, environ="swamp", melee=true },
  stalker2   = { prob=10, r=33,h=64, hp=250, dm=30, fp=10, environ="swamp" },
  bishop     = { prob=10, r=24,h=64, hp=130, dm=40, fp=70, float=true },
  reiver     = { prob= 5, r=24,h=64, hp=150, dm=50, fp=70, float=true },
  wyvern     = { prob= 5, r=20,h=64, hp=640, dm=60, fp=70, float=true },

  heresiarch = { prob= 0, r=40,h=120,hp=5000,dm=70, fp=70 },
  korax      = { prob= 0, r=66,h=120,hp=5000,dm=90, fp=70 },
}

XN_WEAPONS =
{
  -- FIXME: all these stats are CRAP!
  c_mace    = { melee=true,                rate=1.1, dm=12, freq=10, held=true, },
  c_staff   = { ammo="blue_mana",  per=1,  rate=1.1, dm= 6, freq=62, },
  c_fire    = { ammo="green_mana", per=4,  rate=1.1, dm=27, freq=62, },
  c_wraith  = { ammo="combo_mana", per=18, rate=2.2, dm=85, freq=30, pieces={c1_shaft, c2_cross, c3_arc} },

  f_gaunt   = { melee=true,                rate=1.1, dm=20, freq=10, held=true, },
  f_axe     = { ammo="blue_mana",  per=2,  rate=1.1, dm=60, freq=62, melee=true },
  f_hammer  = { ammo="green_mana", per=3,  rate=1.1, dm=27, freq=62, },
  f_quietus = { ammo="combo_mana", per=14, rate=2.2, dm=50, freq=30, pieces={f1_hilt, f2_cross, f3_blade} },

  m_wand    = { held=true,                 rate=1.1, dm= 8, freq=10, continues=true },
  m_cone    = { ammo="blue_mana",  per=3,  rate=1.1, dm=27, freq=62, },
  m_blitz   = { ammo="green_mana", per=5,  rate=1.1, dm=60, freq=62, },
  m_scourge = { ammo="combo_mana", per=15, rate=2.2, dm=50, freq=30, pieces={m1_stick, m2_stub, m3_skull} },
}

XN_PICKUPS =
{
  h_vial  = { stat="health", give=10,  prob=70 },
  h_flask = { stat="health", give=25,  prob=25 },
  h_urn   = { stat="health", give=100, prob=5  },

  -- FIXME: these give values are CRAP!
  ar_mesh   = { stat="armor", give=100, prob=50 },
  ar_shield = { stat="armor", give=100, prob=70 },
  ar_helmet = { stat="armor", give=100, prob=90 },
  ar_amulet = { stat="armor", give=100, prob=50 },

  blue_mana  = { stat="blue_mana",  give=10 },
  green_mana = { stat="green_mana", give=10 },
  combo_mana = { stat="combo_mana", give=20 },
}

XN_DEATHMATCH =
{
  weapons =
  {
    c_staff=40, c_fire  =40, c1_shaft=20, c2_cross=20, c3_arc  =20,
    f_axe  =40, f_hammer=40, f1_hilt =20, f2_cross=20, f3_blade=20,
    m_cone =40, m_blitz =40, m1_stick=20, m2_stub =20, m3_skull=20,
  },

  health =
  { 
    h_vial=70, h_flask=25, h_urn=5
  },

  ammo =
  { 
    blue_mana=40, green_mana=40, combo_mana=15
  },

  items =
  {
    ar_mesh=50, ar_shield=70, ar_helmet=90, ar_amulet=50,

    --FIXME: artifacts!
  },

  cluster = {}
}


------------------------------------------------------------

function create_hexen_theme()
  local T = {}

  T.ERROR_TEX  = "ABADONE"
  T.ERROR_FLAT = "F_033"
  T.SKY_TEX    = "F_SKY"

  T.monsters = XN_MONSTERS
  T.weapons  = XN_WEAPONS

  T.thing_nums = XN_THING_NUMS;

  T.quests = XN_QUESTS
  T.dm = XN_DEATHMATCH

  T.pickups = XN_PICKUPS
  T.pickup_stats = { "health", "blue_mana", "green_mana" }
  T.initial_model = XN_INITIAL_MODEL

  T.arch =
  {
    themes    = XN_THEMES,
    hangs     = XN_OVERHANGS,
    pedestals = XN_PEDESTALS,
    mats      = XN_MATS,

    liquids   = XN_LIQUIDS,
    switches  = XN_SWITCHES,
    doors     = XN_DOORS,
    lights    = XN_LIGHTS,
    rails     = XN_RAILS,
--  pics      = XN_PICS,
    key_bits  = XN_KEY_BITS,
  }
  return T
end

