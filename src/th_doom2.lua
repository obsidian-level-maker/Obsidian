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

D2_THEMES =
{
  PANEL =
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
  },

  GRNTECH =
  {
    mat_pri = 4,

    wall = "TEKGREN2",
    void = "TEKGREN1",
    step = "STEP1",
    pillar = "TEKLITE2",  -- TODO: doom 1: "COMPUTE1"

    pic_wd = "COMPSTA1", pic_wd_h = 64,

    floor = "FLOOR1_1",
    ceil = "FLAT4",

    scenery = "mercury_lamp",

    bad_liquid = "water",
  },

  MARBLE =
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
  },

  -------->

  GRASSY =
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
  },

  ROCKY =
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
  },

  ROCKY2 =
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
  },

  ASHY =
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
  },

  MUDDY =
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
  },

  BRICK =
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
  },

  BRICK2 =
  {
    mat_pri = 6,

    wall = "BIGBRIK1",
    void = "BIGBRIK3",
    step = "STEP1",
    pillar = "BRICK12",

    floor = "RROCK12",
    ceil = "FLAT1",

    scenery = "green_torch",
  },

}

D2_OVERHANGS =
{
  METAL =
  {
    ceil = "CEIL5_1",
    upper = "METAL6",
    thin = "METAL",
  },

  MARBLE =
  {
    thin = "MARBLE1",
    upper = "MARBLE3",
    ceil = "SLIME13",
  },

  PANEL =
  {
    thin = "PANBORD2",
    thick = "PANBORD1",
    upper = "PANCASE2",
    ceil = "CEIL3_1",
  },

  STONE =
  {
    thin = "STONE4",
    upper = "STONE4",
    ceil = "FLAT5_4",
  },

  STONE2 =
  {
    thin = "STONE6",
    upper = "STONE6",
    ceil = "FLAT5_5",
  },

}

D2_RAILS =
{
  r_1 = { tex="MIDBARS3", w=128, h=72  },
  r_2 = { tex="MIDGRATE", w=128, h=128 },
}

D2_LIQUID = { name="slime", floor="SLIME01", sec_kind=7 }  --  5% damage


------------------------------------------------------------

function create_doom2_theme()
  local T = {}

  common_doom_theme(T)

  T.arch.themes = copy_table(T.arch.themes)
  merge_table(T.arch.themes, D2_THEMES)

  T.arch.rails = D2_RAILS

  T.arch.hangs = copy_table(T.arch.hangs)
  merge_table(T.arch.hangs, D2_OVERHANGS)

  T.arch.liquids = copy_table(T.arch.liquids)
  table.insert(T.arch.liquids, D2_LIQUID)

  T.monsters = copy_table(T.monsters)
  merge_table(T.monsters, D2_MONSTERS)

  return T
end

