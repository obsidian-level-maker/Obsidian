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
  ---- CAVE -------------

  D_ROCK =
  {
    theme_probs = { CAVE=100 },
    mat_pri = 7,

    wall = "A-DROCK2",
    void = "A-DROCK1",
    step = "STEP5",
    pillar = "A-MARBLE",

    floor = "RROCK17",
    ceil  = "FLAT10",

    bad_liquid = "slime",
  },

  ---- URBAN -----------

  B_ROCK =
  {
    theme_probs = { URBAN=120 },
    outdoor = true,
    mat_pri = 4,

    wall  = "A-BROCK2",
    floor = "RROCK14",  -- "FLOOR7_1",
    ceil  = "RROCK14",

    step = "STEP5",
    pillar = "A-MOSBRI",

    bad_liquid = "slime",
  },

  A_ROCK =
  {
    theme_probs = { URBAN=50 },
    outdoor = true,
    mat_pri = 3,

    wall  = "AROCK2",  -- NOTE: animated!
    floor = "RROCK13",
    ceil  = "RROCK13",

    step = "ROCK2",
--  void = "A-MOSROK",
    pillar = "A-MOSRK2",

    good_liquid = "water",
  },

}

PL_HALLWAYS =
{
  BR_BRICK =
  {
    mat_pri = 3,

    wall  = "A-BRBRK",
    floor = "FLOOR7_1",
    ceil  = "RROCK03",

    step = "STEP1",
--  void = "A-BRBRK2",
    pillar = "A-BROWN5",

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

PL_WALL_PREFABS =
{
}

PL_LIQUIDS =
{
  water = { floor="FWATER1", wall="WFALL1" },
}

PL_SKY_INFO =
{
  { color="white",  light=208 },
  { color="red",    light=192 },
  { color="red",    light=192 },
}

PL_MISC_PREFABS =
{
  pedestal_PLAYER =
  {
    prefab = "PEDESTAL_PLUT",

    skin =
    {
      ped_w ="COMPSPAN", ped_f ="CEIL5_1",
      ped_w2="COMPSPAN", ped_f2="TLITE6_1",

      ped_h  = 16, ped_h2 = 28,
      light  = 80, light2 = 255,
      kind   = 8, -- glowing
    }
  },
}

----------------------------------------------------------------

GAME_FACTORIES["plutonia"] = function()

  local T = GAME_FACTORIES.doom2()

  T.ERROR_TEX = "SLOPPY1"

  T.combos   = copy_and_merge(T.combos,   PL_COMBOS)
  T.hallways = copy_and_merge(T.hallways, PL_HALLWAYS)

  T.rails   = copy_and_merge(T.rails,   PL_RAILS)
  T.doors   = copy_and_merge(T.doors,   PL_DOORS)
  T.liquids = copy_and_merge(T.liquids, PL_LIQUIDS)

  T.misc_fabs = copy_and_merge(T.misc_fabs, PL_MISC_PREFABS)

  T.sky_info    = PL_SKY_INFO
  T.special_ped = PL_SPECIAL_PEDESTAL

  T.monster_prefs = { gunner=2.0 }

  return T
end

