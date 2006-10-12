----------------------------------------------------------------
-- THEMES : Doom 2
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

  wall = "TEKWALL6",
  void = "TEKWALL4",
  misc = "BROWN96",
  step = "STEP1",
  
  floor = "CEIL4_3",
  ceil = "TLITE6_5",

}

TH_BASE =
{
  mat_pri = 8,

  wall = "STARTAN3",
  void = "STARTAN2",
  step = "STEP1",
  lift = "PLAT1",
  pillar = "COMPWERD",

  pic_wd = "COMPSTA2",    -- "COMP2" for Doom 1 !!
  pic_wd_h = 64,

  floor = "FLOOR4_8",
  ceil = "CEIL3_6",
  step_flat = "STEP2",

  scenery = "lamp",
  good_liquid = "blood",
}

TH_BASE2 =
{
  mat_pri = 8,

  wall = "STARG3",
  void = "STARG2",
  step = "STEP1",
  lift = "PLAT1",
  pillar = "METAL4",
  pic_wd = "COMPBLUE",

  floor = "FLOOR5_1",
  ceil = "FLOOR4_5",
  step_flat = "STEP1",

  scenery = "tech_column",
}

TH_MARBLE =
{
  mat_pri = 6,

  wall = "MARBLE2",
  void = "MARBGRAY",
  step = "STEP1",
  pillar = "MARBFAC4",
  pic_wd  = "SP_DUDE1",

  floor = "GRNROCK",
  ceil = "RROCK04",

  scenery = "red_column_skl",

  bad_liquid = "nukage",
  good_liquid = "blood",
}

TH_WOOD =
{
  mat_pri = 7,

  wall = "WOOD1",
  void = "WOOD3",
  step = "STEP1",
  pillar = "WOODMET4",
  pic_wd = "MARBFACE",

  floor = "CEIL1_1",
  ceil = "FLAT5_1",
}

TH_BRICK =
{
  mat_pri = 6,

  wall = "BRICK7",
  void = "BRICK5",
  step = "STEP1",
  pillar = "BRICKLIT",
  pic_wd = "BRWINDOW",

  floor = "FLOOR0_7",
  ceil = "CEIL5_2",

  scenery = "red_torch",
  bad_liquid = "slime",
}

TH_BRICK2 =
{
  mat_pri = 6,

  wall = "BIGBRIK1",
  void = "BIGBRIK3",
  step = "STEP1",
  pillar = "BRICK12",

  floor = "RROCK12",
  ceil = "FLAT1",

  scenery = "green_torch",
}

TH_PANEL =
{
  mat_pri = 6,

  wall = "PANEL7",
  void = "PANBOOK",
  step = "STEP2",
  pillar = "PANBLUE",
  pic_wd = "SPACEW3",

  floor = "FLOOR5_4",
  ceil = "CEIL1_2",

  scenery = "candelabra",
}

TH_CEMENT =
{
  mat_pri = 1,

  wall = "CEMENT6",
  void = "CEMENT4",
  step = "STEP1",
  lift = "SUPPORT3",
  pillar = "CEMENT8",

  floor = "FLAT9",
  ceil = "SLIME14",
--  lift_flat = "FLOOR4_8",

}

TH_GRNTECH =
{
  mat_pri = 4,

  wall = "TEKGREN2",
  void = "TEKGREN1",
  step = "STEP1",
  pillar = "TEKLITE2",

  pic_wd = "COMPSTA1", pic_wd_h = 64,

  floor = "FLOOR1_1",
  ceil = "FLAT4",

  scenery = "mercury_lamp",

  bad_liquid = "water",
}

TH_SLAD =
{
  mat_pri = 4,

  wall = "SLADWALL",
  void = "SLADSKUL",
  step = "STEP1",
  pillar = "SLADPOIS",
  pic_wd = "BSTONE3",

  floor = "FLOOR0_5",
  ceil = "CEIL5_1",

  scenery = "burning_barrel",

  good_liquid = "nukage",
}

TH_GRAY =
{
  mat_pri = 3,

  wall = "GRAY7",
  void = "ICKWALL3",
  step = "STEP1",
  lift = "SUPPORT3",
  pillar = "CRATE1",
  pic_wd = "REDWALL",

  floor = "FLOOR0_5",
  ceil = "FLAT1",
--  lift_flat = "FLOOR4_8",

  scenery = "green_column_hrt",
}


---- OUTDOOR ------------

TH_GRASSY =
{
  outdoor = true,
  mat_pri = 2,

  wall = "ZIMMER7",
  void = "ZIMMER8",
  step = "STEP5",

  floor = "RROCK19",
  ceil = "F_SKY1",

  scenery = "brown_stub",

  bad_liquid = "nukage",
}

TH_MUDDY =
{
  outdoor = true,
  mat_pri = 2,

  wall = "ASHWALL4",
  void = "TANROCK5",
  step = "STEP5",

  floor = "FLAT10",
  ceil = "F_SKY1",

  scenery = "burnt_tree",

  bad_liquid = "slime",
}

TH_ASHY =
{
  outdoor = true,
  mat_pri = 6,

  wall = "ASHWALL2",
  void = "BLAKWAL2",
  step = "STEP4",
  piller = "STONE5",
  pic_wd = "MODWALL2", pic_wd_h = 64,  -- FIXME

  floor = "MFLR8_4",
  ceil = "F_SKY1",

  scenery = "skull_rock",
}

TH_STONY =
{
  outdoor = true,
  mat_pri = 5,

  wall = "STONE",
  void = "STONE3",
  step = "STEP4",
  piller = "STONE5",

  floor = "MFLR8_1",
  ceil = "F_SKY1",

  scenery = "blue_torch",
}

TH_ROCKY =
{
  outdoor = true,
  mat_pri = 3,

  wall = "TANROCK7",
  void = "ZIMMER4",
  step = "STEP6",
  lift = "SUPPORT3",
  piller = "ASHWALL7",

  floor = "RROCK04",
  ceil = "F_SKY1",
--  lift_flat = "FLOOR4_8",

  scenery = "burnt_tree", -- "big_tree",

  bad_liquid = "slime",
}

TH_ROCKY2 =
{
  outdoor = true,
  mat_pri = 3,

  wall = "TANROCK8",
  void = "ROCK4",
  step = "STEP6",
  lift = "SUPPORT3",

  floor = "RROCK17",
  ceil = "F_SKY1",
--  lift_flat = "FLOOR4_8",

  scenery = "brown_stub",

  bad_liquid = "slime",
}

TH_BROWN =
{
  outdoor = true,
  mat_pri = 3,

  wall = "BROWN1",
  void = "BROWNPIP",
  step = "STEP5",
  lift = "SUPPORT3",
  pillar = "BRONZE2",

  floor = "RROCK16",
  ceil = "F_SKY1",
--  lift_flat = "FLOOR4_8",

  scenery = "skull_pole",

  good_liquid = "blood",
}


ALL_THEMES =
{
  TH_BASE, TH_BASE2, TH_GRNTECH, TH_SLAD,
  TH_MARBLE, TH_WOOD, TH_BRICK, TH_BRICK2,
  TH_PANEL, TH_CEMENT, TH_GRAY,

  TH_GRASSY, TH_MUDDY, TH_ASHY, TH_STONY,
  TH_ROCKY,  TH_ROCKY2, TH_BROWN,
}


---- BASE MATERIALS ------------

TH_METAL =
{
  mat_pri = 5,

  wall = "METAL",
  void = "METAL1",

  floor = "CEIL5_2",
  ceil  = "CEIL5_2",
}

TH_SHINY =
{
  wall = "SHAWN2",
  void = "SHAWN1",

  floor = "FLAT23",
  ceil  = "FLAT23",
}

TH_LIFT =
{
  wall = "SUPPORT2", floor = "STEP2"
}

TH_CAGE =
{
  wall = "METAL",
  floor = "CEIL5_2",
  ceil = "TLITE6_4",
  rail = "r_1"  -- lookup in TH_RAILS
}


--- PEDESTALS --------------

PED_PLAYER =
{
  wall = "SHAWN2",  void = "SHAWN2",
  floor = "FLAT22", ceil = "FLAT22",
  h = 8,
}

PED_QUEST =
{
  wall  = "METAL", void = "METAL",
  floor = "GATE4", ceil = "GATE4",
  h = 24,
}

PED_WEAPON =
{
  wall  = "METAL",   void = "METAL",
  floor = "CEIL1_2", ceil = "CEIL1_2",
  h = 12,
}


---- OVERHANGS ------------

HANG_METAL =
{
  ceil = "CEIL5_1",
  upper = "METAL6",
  thin = "METAL",
}

HANG_PANEL =
{
  thin = "PANBORD2",
  thick = "PANBORD1",
  upper = "PANCASE2",
  ceil = "CEIL3_1",
}

HANG_MARBLE =
{
  thin = "MARBLE1",
  upper = "MARBLE3",
  ceil = "SLIME13",
}

HANG_STONE =
{
  thin = "STONE4",
  upper = "STONE4",
  ceil = "FLAT5_4",
}

HANG_STONE2 =
{
  thin = "STONE6",
  upper = "STONE6",
  ceil = "FLAT5_5",
}

HANG_WOOD =
{
  thin = "WOOD9",
  upper = "WOOD12",
  ceil = "FLAT5_1",
}

ALL_OVERHANGS =
{
  HANG_METAL, HANG_MARBLE, HANG_PANEL,
  HANG_STONE, HANG_STONE2, HANG_WOOD
}


---- MISC STUFF ------------

TH_LIQUIDS =
{
  { name="water",  floor="FWATER1" },
  { name="blood",  floor="BLOOD1"  }, -- no damage
  { name="slime",  floor="SLIME01", sec_kind=7 },  --  5% damage
  { name="nukage", floor="NUKAGE1", sec_kind=5 },  -- 10% damage
  { name="lava",   floor="LAVA1",   sec_kind=16, light=64 }, -- 20% damage
}

TH_SWITCHES =
{
  sw_blue = { wall="COMPBLUE", switch="SW1BLUE" },
  sw_hot  = { wall="SP_HOT1",  switch="SW1HOT" },
  sw_vine = { wall="SKINFACE", switch="SW1SKIN" },
  sw_skin = { wall="GRAYVINE", switch="SW1VINE" },

  sw_wood = { wall="WOODMET1", switch="SW1WDMET", floor="FLAT5_1", bars=true, stand_h=128 },
  sw_metl = { wall="SUPPORT3", switch="SW1GARG",  floor="CEIL5_2", bars=true },
  sw_gray = { wall="GRAY7",    switch="SW1GRAY1", floor="FLAT1",   bars=true },
  sw_rock = { wall="ROCK3",    switch="SW1ROCK",  floor="RROCK13", bars=true },

  sw_exit = { wall="COMPSPAN", switch="SW1COMP" },
}

TH_DOORS =
{
  -- Note: most of these with h=112 are really 128 pixels
  --       tall, but work fine when truncated/

  d_uac    = { tex="BIGDOOR1", w=128, h=72  },  -- actual height is 96
  d_big1   = { tex="BIGDOOR2", w=128, h=112 },
  d_big2   = { tex="BIGDOOR3", w=128, h=112 },
  d_big3   = { tex="BIGDOOR4", w=128, h=112 },

  d_wood1  = { tex="BIGDOOR5", bottom="CEIL5_2", w=128, h=112 },
  d_wood2  = { tex="BIGDOOR6", bottom="CEIL5_2", w=128, h=112 }, -- this is the real height!
  d_wood3  = { tex="BIGDOOR7", bottom="CEIL5_2", w=128, h=112 },

  d_thin1  = { tex="SPCDOOR1", w=64, h=112 },
  d_thin2  = { tex="SPCDOOR2", w=64, h=112 },
  d_thin3  = { tex="SPCDOOR3", w=64, h=112 },
  d_weird  = { tex="SPCDOOR4", w=64, h=112 },

  d_small1 = { tex="DOOR1",    w=64, h=72 },
  d_small2 = { tex="DOOR3",    w=64, h=72 },
  d_exit   = { tex="EXITDOOR", w=64, h=72 },
}

TH_RAILS =
{
  r_1 = { tex="MIDBARS3", w=128, h=72  },
  r_2 = { tex="MIDGRATE", w=128, h=128 },
}

TH_LIGHTS =
{
  { tex="LITE3",    w=32 },
  { tex="LITE5",    w=16 },
  { tex="LITEBLU4", w=32 },
--  { tex="REDWALL",  w=32 },

  { flat="CEIL1_2",  side="METAL" },
  { flat="CEIL1_3",  side="WOOD1" },
  { flat="CEIL3_4",  side="STARTAN2" },
  { flat="FLAT2",    side="GRAY5" },
  { flat="FLAT17",   side="GRAY5" },
  { flat="FLOOR1_7", side="SP_HOT1" },
  { flat="GRNLITE1", side="TEKGREN2" },

  { flat="TLITE6_1", side="METAL" },
  { flat="TLITE6_4", side="METAL" },
  { flat="TLITE6_5", side="METAL" },
  { flat="TLITE6_6", side="METAL" },
}

TH_PICS =
{
  { tex="LITE3",    w=128, h=16 },

  { tex="MARBFACE", w=128, h=128 },
  { tex="MARBFAC2", w=128, h=128 },
  { tex="MARBFAC3", w=128, h=128 },

  { tex="FIRELAVA", w=128, h=128 },
  { tex="FIREMAG1", w=128, h=128 },
  { tex="FIREWALL", w=128, h=112 },

  { tex="SHAWN1",   w=128, h=96  },
  { tex="SKINEDGE", w=128, h=128 },
  { tex="TEKBRON1", w=128, h=128 },
  { tex="WOOD10",   w=128, h=128 },
  { tex="WOOD3",    w=128, h=64  },

--  { tex="SKSPINE2", w=128, h=128, scroll=48 },
--  { tex="SPFACE1",  w=128, h=96,  scroll=48 },

  { tex="ZZWOLF6",  w=128, h=128 },
  { tex="ZZWOLF7",  w=128, h=128 },
}


---- MISC STUFF ------------

-- the numbers are the relative probability
KEY_LIST    = { k_blue=10, k_red=10, k_yellow=10 }
SWITCH_LIST = { sw_blue=50, sw_hot=30,  sw_vine=10, sw_skin=40,
                sw_wood=30, sw_metl=50, sw_gray=20, sw_rock=10 }
WEAPON_LIST = { saw=10, super=40, launch=80, plasma=60, bfg=4 }
ITEM_LIST   = { blue_armor=40, invis=40, mega=25, backpack=25, berserk=20, goggle=5, invul=2, map=3 }
EXIT_LIST   = { ex_tech=90, ex_stone=30, ex_hole=10 }


------------------------------------------------------------

DM_THING_NUMS =
{
  --- special stuff ---
  player1 = 1,
  player2 = 2,
  player3 = 3,
  player4 = 4,
  dm_player = 11,
  teleport_spot = 14,

  --- monsters ---
  zombie    = 3004,
  shooter   = 9,
  gunner    = 65,
  imp       = 3001,
  caco      = 3005,
  revenant  = 66,
  knight    = 69,
  baron     = 3003,

  mancubus  = 67,
  arach     = 68,
  pain      = 71,
  vile      = 64,
  demon     = 3002,
  spectre   = 58,
  skull     = 3006,

  cyber     = 16,
  spider    = 7,
  keen      = 72,
  wolf_ss   = 84,

  --- pickups ---
  k_red     = 38,
  k_yellow  = 39,
  k_blue    = 40,

  kc_blue   = 5,
  kc_yellow = 6,
  kc_red    = 13,

  shotty = 2001,
  super  =   82,
  chain  = 2002,
  launch = 2003,
  plasma = 2004,
  saw    = 2005,
  bfg    = 2006,

  backpack =  8,
  mega   =   83,
  invul  = 2022,
  berserk= 2023,
  invis  = 2024,
  suit   = 2025,
  map    = 2026,
  goggle = 2045,

  potion   = 2014,
  stimpack = 2011,
  medikit  = 2012,
  soul     = 2013,

  helmet      = 2015,
  green_armor = 2018,
  blue_armor  = 2019,

  bullets    = 2007,
  bullet_box = 2048,
  shells     = 2008,
  shell_box  = 2049,
  rockets    = 2010,
  rocket_box = 2046,
  cells      = 2047,
  cell_pack  =   17,

  --- scenery ---
  lamp = 2028,
  mercury_lamp = 85, 
  short_lamp = 86,
  tech_column = 48,

  barrel = 2035,
  candle = 34,  -- non-blocking
  candelabra = 35,
  burning_barrel = 70,

  blue_torch     = 44,
  blue_torch_sm  = 55,
  green_torch    = 45,
  green_torch_sm = 56,
  red_torch      = 46,
  red_torch_sm   = 57,

  green_pillar = 30,
  green_column = 31,
  green_column_hrt = 36,

  red_pillar = 32,
  red_column = 33,
  red_column_skl = 37,

  brown_stub = 47,
  burnt_tree = 43,
  big_tree = 54,  

  evil_eye    = 41,
  skull_rock  = 42,
  skull_pole  = 27,
  skull_kebab = 28,
  skull_cairn = 29,

  impaled_human  = 25,
  impaled_twitch = 26,

  gutted_victim1 = 73,
  gutted_victim2 = 74,
  gutted_torso1  = 75,
  gutted_torso2  = 76,
  gutted_torso3  = 77,
  gutted_torso4  = 78,

  -- all the rest are non-blocking
  hang_twitching = 63,
  hang_arm_pair  = 59,
  hang_leg_pair  = 60,
  hang_leg_gone  = 61,
  hang_leg       = 62,

  gibs = 24,
  gibbed_player = 10,
  pool_blood_1 = 79,
  pool_blood_2 = 80,
  pool_brains  = 81,

  dead_player  = 15,
  dead_zombie  = 18,
  dead_shooter = 19,
  dead_imp     = 20,
  dead_demon   = 21,
  dead_caco    = 23,
}


------------------------------------------------------------

-- Monster list
-- ============
--
-- r : radius
-- h : height
-- t : toughness (health)
-- dm : damage can inflict per second (rough approx)
-- fp : firepower needed by player

DM_MONSTERS =
{
  -- FIXME: probs for CLOSET/DEPOT
  zombie    = { prob=81, r=20,h=56, t=20,  dm=4,  fp=10, cage_prob=10, hitscan=true, },
  shooter   = { prob=41, r=20,h=56, t=30,  dm=10, fp=10, cage_prob= 5, hitscan=true, },
  gunner    = { prob=17, r=20,h=56, t=70,  dm=40, fp=40, cage_prob=70, hitscan=true, },

  imp       = { prob=90, r=20,h=56, t=60,  dm=20, fp=20, cage_prob=90, },
  caco      = { prob=90, r=31,h=56, t=400, dm=45, fp=30, cage_prob=14, float=true },
  revenant  = { prob=70, r=20,h=64, t=300, dm=55, fp=48, cage_prob=50, },
  knight    = { prob=70, r=24,h=64, t=500, dm=45, fp=60, cage_prob=50, },
  baron     = { prob=50, r=24,h=64, t=1000,dm=45, fp=110,cage_prob= 2, },

  mancubus  = { prob=70, r=48,h=64, t=600, dm=80, fp=110,cage_prob=70, },
  arach     = { prob=26, r=64,h=64, t=500, dm=70, fp=90, cage_prob=90, },
  pain      = { prob= 8, r=31,h=56, t=400, dm=88, fp=40, cage_prob= 0, float=true },
  vile      = { prob=10, r=20,h=56, t=700, dm=30, fp=120,cage_prob=14, hitscan=true },

  -- MELEE only monsters
  demon     = { prob=80, r=30,h=56, t=150, dm=25, fp=30, cage_prob=140,melee=true },
  spectre   = { prob=15, r=30,h=56, t=150, dm=25, fp=30, cage_prob=40, melee=true },
  skull     = { prob=20, r=16,h=56, t=100, dm=7,  fp=40, cage_prob= 2, melee=true, float=true },

  -- special monsters (only for boss levels)
  cyber     = { prob=0, r=40,  h=110,t=4000,dm=150, fp=150 },
  spider    = { prob=0, r=128, h=100,t=3000,dm=200, fp=240, hitscan=true },
  wolf_ss   = { prob=1, r=20,  h=56, t=50,  dm=15,  fp=120, hitscan=true },
}

DM_MONSTER_GIVE =
{
  zombie   = { { ammo="bullet", give=10 } },
  shooter  = { { weapon="shotty" } },
  gunner   = { { weapon="chain" } }
}

-- Weapon list
-- ===========
--
-- per  : ammo per shot
-- rate : firing rate (shots per second)
-- dm   : damage can inflict per shot
-- freq : usage frequency (in the ideal)
-- held : already held at level start

DM_WEAPONS =
{
  fist    = { melee=true, rate=1.5, dm=10, freq=0.1, held=true },
  berserk = { melee=true, rate=1.5, dm=50, freq=10 },
  saw     = { melee=true, rate=8.7, dm=10, freq=2 },

  pistol = { ammo="bullet",         per=1, rate=1.8, dm=10 , freq=10, held=true },
  shotty = { ammo="shell",  give=8, per=1, rate=0.9, dm=70 , freq=81 },
  super  = { ammo="shell",  give=8, per=2, rate=0.6, dm=200, freq=50 },
  chain  = { ammo="bullet", give=20,per=1, rate=8.5, dm=10 , freq=91 },

  launch = { ammo="rocket", give=2, per=1, rate=1.7, dm=90,  freq=50, dangerous=true },
  plasma = { ammo="cell",   give=40,per=1, rate=11,  dm=22 , freq=80 },
  bfg    = { ammo="cell",   give=40,per=40,rate=0.8, dm=450, freq=30 },

  -- Note: Berserk is not really an extra weapon, but a powerup
  -- which makes fist do much more damage.  The effect lasts till
  -- the end of the level, so a weapon is a pretty good fit.
}

-- sometimes a certain weapon is preferred against a certain monster.
-- These values are multiplied with the weapon's "freq" field.

DM_MONSTER_WEAPON_PREFS =
{
  zombie  = { shotty=6.0 },
  shooter = { shotty=6.0 },
  imp     = { shotty=6.0 },
  demon   = { super=3.0, launch=0.3 },
  spectre = { super=3.0, launch=0.3 },

  pain    = { launch=0.1 },
  skull   = { launch=0.1 },

  cyber   = { launch=3.0, bfg=6.0 },
  spider  = { launch=3.0, bfg=9.0 },
}

-- Pickup List
-- ===========

DM_PICKUPS =
{
  bullets    = { stat="bullet", give=10, prob=10 },
  bullet_box = { stat="bullet", give=50, prob=70 },
  shells     = { stat="shell",  give= 4, prob=30 },
  shell_box  = { stat="shell",  give=20, prob=70 },

  rockets    = { stat="rocket", give= 1, prob=20 },
  rocket_box = { stat="rocket", give= 5, prob=70 },
  cells      = { stat="cell",   give=20, prob=30 },
  cell_pack  = { stat="cell",   give=100,prob=70 },

  potion   = { stat="health", give=1,  prob=30 },
  stimpack = { stat="health", give=10, prob=40 },
  medikit  = { stat="health", give=25, prob=70 },
  soul     = { stat="health", give=100,prob=15, limit=200 },

  -- BERSERK and MEGA are quest items

  helmet      = { stat="armor", give=   1, limit=200 },
  green_armor = { stat="armor", give= 100, limit=100 },
  blue_armor  = { stat="armor", give= 200, limit=200 },

  -- BLUE ARMOR is a quest item

  -- Note: armor is handled with special code, since
  --       BLUE ARMOR is a quest item.

  -- Note 2: the BACKPACK is a quest item
}

-- DeathMatch stuff
-- ================

DM_DEATHMATCH =
{
  weapons =
  {
    shotty=60, super=40, chain=40, launch=40,
    plasma=20, saw=10, bfg=3
  },

  health =
  { 
    potion=10, stimpack=60, medikit=20
  },

  ammo =
  { 
    bullets=5,  bullet_box=30,
    shells=60,  shell_box=5,
    rockets=10, rocket_box=20,
    cells=40,   cell_pack=1,
  },

  items =
  {
    invis=40, goggle=10, berserk=50,
    soul=5, green_armor=40, blue_armor=5,
  },

  cluster =
  {
    potion = 8, helmet = 8, stimpack = 2,
    bullets = 3, shells = 2, rocket = 4,
  },
}


------------------------------------------------------------

function common_doom_theme(T)
  T.dm = {}

  T.ERROR_TEX  = "FIREBLU1"
  T.ERROR_FLAT = "SFLR6_4"
  T.SKY_TEX    = "F_SKY1"

  T.monsters = DM_MONSTERS
  T.weapons  = DM_WEAPONS

  T.thing_nums = DM_THING_NUMS
  T.mon_give = DM_MONSTER_GIVE
  T.mon_weap_prefs = DM_MONSTER_WEAPON_PREFS

  T.pickups = DM_PICKUPS
  T.pickup_stats = { "health", "bullet", "shell", "rocket", "cell" }

  T.dm = DM_DEATHMATCH
end

function create_doom1_theme()
  local T = {}

  common_doom_theme(T)

  -- remove the DOOM2-only monsters
  T.monsters = copy_table(T.monsters)

  T.monsters.gunner = nil
  T.monsters.revenant = nil
  T.monsters.knight = nil
  T.monsters.vile = nil
  T.monsters.pain = nil
  T.monsters.arach = nil
  T.monsters.mancubus = nil
  T.monsters.wolf_ss = nil

  -- remove the DOOM2-only weapons
  T.weapons = copy_table(T.weapons)
  T.weapons.super = nil

  T.dm = copy_table(T.dm)
  T.dm.weapons = copy_table(T.dm.weapons)
  T.dm.weapons.super = nil

  return T
end

function create_doom2_theme()
  local T = {}

  common_doom_theme(T)

  return T
end

