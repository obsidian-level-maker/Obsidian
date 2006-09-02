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

  floor = "FLOOR4_8",
  ceil = "CEIL3_6",
  step_flat = "STEP2",

  scenery = "lamp",
}

TH_BASE2 =
{
  mat_pri = 8,

  wall = "STARG3",
  void = "STARG2",
  step = "STEP1",
  lift = "PLAT1",
  pillar = "METAL4",

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

  floor = "GRNROCK",
  ceil = "RROCK04",

  scenery = "red_column",

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

  floor = "FLOOR0_7",
  ceil = "CEIL5_2",

  scenery = "red_torch",
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

  floor = "FLOOR0_5",
  ceil = "FLAT1",
--  lift_flat = "FLOOR4_8",

  scenery = "green_column",
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
  water  = { floor="FWATER1" },
  blood  = { floor="BLOOD1"  }, -- no damage
  slime  = { floor="SLIME01", sec_kind=7 },  --  5% damage
  nukage = { floor="NUKAGE1", sec_kind=5 },  -- 10% damage
  lava   = { floor="LAVA1",   sec_kind=16, light=64 }, -- 20% damage
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

TH_LIGHTS =
{
  { tex="LITE3",    w=32 },
  { tex="LITE5",    w=16 },
  { tex="LITEBLU4", w=32 },
  { tex="REDWALL",  w=32 },

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

