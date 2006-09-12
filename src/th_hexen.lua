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

ERROR_TEX  = "ABADONE"
ERROR_FLAT = "F_033"

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

  scenery = "burner",
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


ALL_THEMES =
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

TH_PEDESTAL =
{
  wall = "CTYSTUCI4",
  void = "CTYSTUCI4",

  floor = "FLOOR11",
  ceil  = "FLOOR11",
}


---- OVERHANGS ------------

HANG_WOOD =
{
  ceil = "F_054",
  upper = "D_WD07",
  thin = "WOOD01",
}

ALL_OVERHANGS =
{
  HANG_WOOD
}


---- MISC STUFF ------------

TH_LIQUIDS =
{
  water  = { floor="X_005" },
  lava   = { floor="X_001" },
  slime  = { floor="X_009" },
}

TH_SWITCHES =
{
  sw_rock = { wall="STEEL01", switch="SW_1_UP" },

  sw_exit = { wall="STEEL01", switch="SW_2_UP" },
}

TH_DOORS =
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

TH_RAILS =
{
  r_1 = { tex="GATE03", w=64, h=64  },
  r_2 = { tex="GATE02", w=64, h=128 },
}

TH_LIGHTS =
{
  { tex="X_FIRE01", w=16 },

  { flat="F_081", side="FIRE07" },
  { flat="F_084", side="FIRE07" },
  { flat="X_012", side="FIRE07" },
}


---- MISC STUFF ------------

-- the numbers are the relative probability
KEY_LIST    = { k_yellow=10 }
SWITCH_LIST = { sw_rock=50 }
WEAPON_LIST = { saw=10, super=40, launch=80, plasma=60, bfg=4 }
ITEM_LIST   = { armor=40, invis=40, mega=25, backpack=25, berserk=20, goggle=5, invul=2 }
EXIT_LIST   = { ex_tech=90, ex_stone=30, ex_hole=10 }


------------------------------------------------------------

SCENERY_NUMS =
{
  tree_left = 79,
  burner = 8061
}

