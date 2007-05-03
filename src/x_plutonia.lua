----------------------------------------------------------------
-- GAME DEF : Plutonia Experiment (Final DOOM)
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006,2007 Andrew Apted
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

PL_COMBOS =
{
  --- Indoor ---

  D_ROCK =
  {
    mat_pri = 7,

    wall = "A-DROCK2",
    void = "A-DROCK1",
    step = "STEP5",
    pillar = "A-MARBLE",

    floor = "RROCK17",
    ceil  = "FLAT10",

    bad_liquid = "slime",

    theme_probs = { CAVE=100 },
  },

  --- Outdoor ---

  B_ROCK =
  {
    outdoor = true,
    mat_pri = 4,

    wall = "A-BROCK2",
    void = "A-BROCK2",
    step = "STEP5",
    pillar = "A-MOSBRI",

    floor = "RROCK14",  -- "FLOOR7_1",
    ceil  = "RROCK14",

    bad_liquid = "slime",

    theme_probs = { URBAN=120 },
  },

  A_ROCK =
  {
    outdoor = true,
    mat_pri = 3,

    wall = "AROCK2",  -- NOTE: animated!
    void = "A-MOSROK",
    step = "ROCK2",
    pillar = "A-MOSRK2",

    floor = "RROCK13",
    ceil  = "RROCK13",

    good_liquid = "water",

    theme_probs = { URBAN=50 },
  },

}

PL_HALLWAYS =
{
  BR_BRICK =
  {
    mat_pri = 3,

    wall = "A-BRBRK",
    void = "A-BRBRK2",
    step = "STEP1",
    pillar = "A-BROWN5",

    floor = "FLOOR7_1",
    ceil  = "RROCK03",

    bad_liquid = "slime",
  },
}

PL_RAILS =
{
  r_4 = { wall="MIDSPACE", w=128, h=128 },
  r_5 = { wall="A-GRATE",  w=128, h=128 },
  r_6 = { wall="A-RAIL1",  w=64,  h=32  },
}

PL_DOORS =
{

--[[ !!!! FIXME
  d_metal  = { wall="A-BROWN4", w=128, h=128 },
  d_poison = { wall="SLIME3",   w=128, h=128 },
--]]
}

PL_PICS =
{
  redrok = { wall="A-REDROK", w=128, h=128 },
  askin3 = { wall="A-ASKIN3", w=128, h=128 },
  askin4 = { wall="A-ASKIN4", w=128, h=128 },
}

PL_LIQUIDS =
{
  water = { floor="FWATER1", wall="WFALL1" },
}

PL_SPECIAL_PEDESTAL =
{
  wall   ="COMPSPAN",
  floor  ="CEIL5_1",
  h      = 16,
  light  = 80,

  wall2  ="COMPSPAN",
  floor2 ="TLITE6_1",
  h2     = 28,
  light2 = 255,

  glow2  = true,
  rotate2 = true,

  coop_light = 112,
}

----------------------------------------------------------------

GAME_FACTORIES["plutonia"] = function()

  local T = GAME_FACTORIES.doom2()

  T.ERROR_TEX = "SLOPPY1"

  T.combos   = copy_and_merge(T.combos,   PL_COMBOS)
  T.hallways = copy_and_merge(T.hallways, PL_HALLWAYS)

  T.rails   = copy_and_merge(T.rails,   PL_RAILS)
  T.doors   = copy_and_merge(T.doors,   PL_DOORS)
  T.pics    = copy_and_merge(T.pics,    PL_PICS)
  T.liquids = copy_and_merge(T.liquids, PL_LIQUIDS)

  T.special_ped = PL_SPECIAL_PEDESTAL

  T.monster_prefs = { gunner=2.0 }

  return T
end

