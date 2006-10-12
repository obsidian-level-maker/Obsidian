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


--- PEDESTALS --------------

PED_PLAYER =
{
  wall  = "CTYSTUCI4", void = "CTYSTUCI4",
  floor = "FLOOR11",   ceil = "FLOOR11",
  h = 8,
}

PED_QUEST = PED_PLAYER  -- FIXME

PED_WEAPON = PED_PLAYER  -- FIXME


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

HC_THING_NUMS =
{
  --- special stuff ---
  player1 = 1,
  player2 = 2,
  player3 = 3,
  player4 = 4,
  dm_player = 11,
  teleport_spot = 14,

  --- monsters ---
  gargoyle    = 66,
  fire_garg   = 5,
  golem       = 68,
  golem_inv   = 69,
  nitro       = 45,
  nitro_inv   = 46,
  warrior     = 64,
  warrior_inv = 65,

  disciple   = 15,
  sabreclaw  = 90,
  weredragon = 70,
  ophidian   = 92,
  ironlich   = 6,
  maulotaur  = 9,
  d_sparil   = 7,

  --- pickups ---
  k_yellow   = 80,
  k_green    = 73,
  k_blue     = 79,

  gauntlets  = 2005,
  crossbow   = 2001,
  claw       = 53,
  hellstaff  = 2004,
  phoenix    = 2003,
  mace       = 2002,

  crystal    = 10,
  geode      = 12,
  arrows     = 18,
  quiver     = 19,
  claw_orb1  = 54,
  claw_orb2  = 55,
  runes1     = 20,
  runes2     = 21,
  flame_orb1 = 22,
  flame_orb2 = 23,
  mace_orbs  = 13,
  mace_pile  = 16,

  h_vial  = 81,
  h_flask = 82,
  h_urn   = 32,
  shield1 = 85,
  shield2 = 31,

  bag     = 8,
  wings   = 23,
  ovum    = 30,
  torch   = 33
  bomb    = 34,
  map     = 35,
  chaos   = 36,
  shadow  = 75,
  ring    = 84,
  tome    = 86,

  --- scenery ---
  wall_torch = 50,
  serpent_torch = 27,
  fire_brazier = 76,
  chandelier = 28,

  barrel = 44,
  small_pillar = 29,
  brown_pillar = 47,
  pod = 2035,
  glitter = 74,

  blue_statue = 94,
  green_statue = 95,
  yellow_statue = 96,

  moss1 = 48,
  moss2 = 49,
  stal_small_F = 37,
  stal_small_C = 39,
  stal_big_F = 38,
  stal_big_C = 40,
  volcano = 87,

  hang_corpse = 51,
  hang_skull_1 = 17,
  hang_skull_2 = 24,
  hang_skull_3 = 25,
  hang_skull_4 = 26

  --- ambient sounds ---
  amb_scream = 1200,
  amb_squish = 1201,
  amb_drip   = 1202,
  amb_feet   = 1203,
  amb_heart  = 1204,
  amb_bells  = 1205,
  amb_growl  = 1206,
  amb_magic  = 1207,
  amb_laugh  = 1208,
  amb_run    = 1209,

  env_water  = 41,
  env_wind   = 42,
}

HC_MONSTERS =
{
  -- FIXME: dm and fp values are CRAP
  gargoyle    = { prob=30, r=16,h=36, hp=20,  dm= 7, fp=10, melee=true },
  fire_garg   = { prob=20, r=16,h=36, hp=80,  dm=21, fp=30, },
  golem       = { prob=90, r=22,h=64, hp=80,  dm= 7, fp=10, melee=true },
  golem_inv   = { prob=20, r=22,h=64, hp=80,  dm= 7, fp=10, melee=true },

  nitro       = { prob=70, r=22,h=64, hp=100, dm=21, fp=30, },
  nitro_inv   = { prob=10, r=22,h=64, hp=100, dm=21, fp=30, },
  warrior     = { prob=70, r=24,h=80, hp=200, dm=15, fp=50, },
  warrior_inv = { prob=20, r=24,h=80, hp=200, dm=15, fp=50, },

  disciple    = { prob=25, r=16,h=72, hp=180, dm=30, fp=90, },
  sabreclaw   = { prob=25, r=20,h=64, hp=150, dm=30, fp=90, melee=true },
  weredragon  = { prob=20, r=34,h=80, hp=220, dm=50, fp=90, },
  ophidian    = { prob=20, r=22,h=72, hp=280, dm=50, fp=90, },

  ironlich    = { prob= 4, r=40,h=72, hp=700, dm=99, fp=200, },
  maulotaur   = { prob= 0, r=28,h=104,hp=3000,dm=99, fp=200, },
  d_sparil    = { prob= 0, r=28,h=104,hp=2000,dm=99, fp=200, },
}

