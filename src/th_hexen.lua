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

---- INDOOR ------------

TH_EXITROOM =
{
  mat_pri = 9,

  wall = "METL2",
  void = "SKULLSB1",
  
  floor = "FLOOR03",
  ceil = "FLOOR03",
}

TH_GOLD =
{
  mat_pri = 6,

  wall = "FOREST01",
  void = "WINNOW02",
  pillar = "PILLAR01",

  floor = "F_089",
  ceil = "F_014",

  scenery = "brass_brazier",
}


---- OUTDOOR ------------

TH_STONY =
{
  outdoor = true,
  mat_pri = 3,

  wall = "CAVE03",
  void = "CAVE02",

  floor = "F_007",
  ceil = "F_SKY",

  scenery = "tree_left",
}


XN_THEMES =
{
  TH_GOLD,

  TH_STONY,
}


---- BASE MATERIALS ------------

TH_METAL =
{
  mat_pri = 5,

  wall = "METL2",
  void = "METL1",

  floor = "FLOOR28",
  ceil  = "FLOOR28",
}

TH_LIFT =
{
  wall = "PLAT02", floor = "F_065"
}


---- PEDESTALS ------------

PED_PLAYER =
{
  wall = "CTYSTUCI4", void = "CTYSTUCI4",
  floor = "FLOOR11",  ceil = "FLOOR11",
  h = 8,
}

PED_QUEST = PED_PLAYER  -- FIXME

PED_WEAPON = PED_PLAYER  -- FIXME


---- OVERHANGS ------------

HANG_WOOD =
{
  ceil = "F_054",
  upper = "D_WD07",
  thin = "WOOD01",
}

XN_OVERHANGS =
{
  HANG_WOOD
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
  sw_rock = { wall="STEEL01", switch="SW_1_UP" },

  sw_exit = { wall="STEEL01", switch="SW_2_UP" },
}

XN_DOORS =
{
  d_big    = { tex="DOOR51",   w=128, h=128 },
  d_brass1 = { tex="BRASS3",   w=128, h=128 },
  d_brass2 = { tex="D_BRASS2", w=64,  h=128 },

  d_wood1  = { tex="D_WD07",   w=128, h=128 },
  d_wood2  = { tex="D_WD08",   w=64,  h=128 },
  d_wood3  = { tex="D_WD10",   w=64,  h=128 },

  d_silver = { tex="D_SILVER", w=64,  h=128 },
  d_exit   = { tex="D_CAST",   w=64,  h=128 },
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


---- MISC STUFF ------------

-- the numbers are the relative probability
KEY_LIST    = { k_yellow=10 }
SWITCH_LIST = { sw_rock=50 }
WEAPON_LIST = { saw=10, super=40, launch=80, plasma=60, bfg=4 }
ITEM_LIST   = { armor=40, invis=40, mega=25, backpack=25, berserk=20, goggle=5, invul=2 }
EXIT_LIST   = { ex_tech=90, ex_stone=30, ex_hole=10 }


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
  wendigo  = 8020,   -- FIXME: correct?
  centaur1 = 107,
  centaur2 = 115,

  stalker1   = 31,   -- FIXME: correct???
  stalker2   = 8080,
  bishop     = 114,
  reiver     = 112,  -- FIXME: correct???
  wyvern     = 254,
  heresiarch = 10080,
  korax      = 10200,

  fighter_boss = 10100,
  cleric_boss  = 10101, 
  mage_boss    = 10102,

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


------------------------------------------------------------

function create_hexen_theme()
  local T = {}

  T.ERROR_TEX  = "ABADONE"
  T.ERROR_FLAT = "F_033"
  T.SKY_TEX    = "F_SKY"

  T.thing_nums = XN_THING_NUMS;

  T.arch =
  {
    themes   = XN_THEMES,
    hangs    = XN_OVERHANGS,

    liquids  = XN_LIQUIDS,
    switches = XN_SWITCHES,
    doors    = XN_DOORS,
    lights   = XN_LIGHTS,
    rails    = XN_RAILS,
    pics     = XN_PICS,
  }
  return T
end

