----------------------------------------------------------------
-- THEMES : Heretic
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

ERROR_TEX  = "DRIPWALL"
ERROR_FLAT = "FLOOR09"

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

  wall = "SANDSQ2",
  void = "SNDBLCKS",
  pillar = "SNDCHNKS",

  floor = "FLOOR06",
  ceil = "FLOOR11",

  scenery = "wall_torch",
}


---- OUTDOOR ------------

TH_STONY =
{
  outdoor = true,
  mat_pri = 3,

  wall = "GRSTNPB",
  void = "GRSTNPBV",

  floor = "FLOOR00",
  ceil = "F_SKY1",

  scenery = "serpent_torch",
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
  wall = "DOORSTON", floor = "FLOOR08"
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
  ceil = "FLOOR10",
  upper = "CTYSTUC3",
  thin = "WOODWL",
}

ALL_OVERHANGS =
{
  HANG_WOOD
}


---- MISC STUFF ------------

TH_LIQUIDS =
{
  { name="water", floor="FLTFLWW1" },
  -- FIXME
}

TH_SWITCHES =
{
  sw_rock = { wall="RCKSNMUD", switch="SW1OFF" },

  sw_exit = { wall="METL2", switch="SW2OFF" },
}

TH_DOORS =
{
  d_demon  = { tex="DMNMSK",   w=128, h=128 },
  d_wood   = { tex="DOORWOOD", bottom="FLOOR10", w=64, h=128 },
--  d_stone  = { tex="DOORSTON", w=64,  h=128 },

  d_exit   = { tex="DOOREXIT", w=64, h=96 },
}

TH_RAILS =
{
  r_1 = { tex="WDGAT64", w=128, h=64  },
  r_2 = { tex="STNGLS1", w=128, h=128 },
}

TH_LIGHTS =
{
  { tex="REDWALL", w=32 },

  { flat="FLOOR26",  side="ORNGRAY" },
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
  wall_torch = 50,
  serpent_torch = 27,
  fire_brazier = 76,
  chandelier = 28,

  barrel = 44,
  small_pillar = 29,
  brown_pillar = 47,

  blue_statue = 94,
  green_statue = 95,
  yellow_statue = 96,

  moss1 = 48,
  moss2 = 49,
  small_stal_F = 37,
  small_stal_C = 39,
  big_stal_F = 38,
  big_stal_C = 40,

  hang_corpse = 51,
  hang_skull_1 = 17,
  hang_skull_2 = 24,
  hang_skull_3 = 25,
  hang_skull_4 = 26
}

