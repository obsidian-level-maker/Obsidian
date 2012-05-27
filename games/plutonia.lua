----------------------------------------------------------------
--  GAME DEF : Plutonia Experiment (Final DOOM)
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2012 Andrew Apted
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

PLUTONIA = { }



-----> old stuff ---->


PL_COMBOS =
{
  ---- CAVE -------------

  D_ROCK =
  {
    theme_probs = { CAVE=100 }
    mat_pri = 7,

    wall = "A-DROCK2",
    void = "A-DROCK1",
    step = "STEP5",
    pillar = "A-MARBLE",

    floor = "RROCK17",
    ceil  = "FLAT10",

    bad_liquid = "slime",
  }

  ---- URBAN -----------

  B_ROCK =
  {
    theme_probs = { URBAN=120 }
    outdoor = true,
    mat_pri = 4,

    wall  = "A-BROCK2",
    floor = "RROCK14",  -- "FLOOR7_1",
    ceil  = "RROCK14",

    step = "STEP5",
    pillar = "A-MOSBRI",

    bad_liquid = "slime",
  }

  A_ROCK =
  {
    theme_probs = { URBAN=50 }
    outdoor = true,
    mat_pri = 3,

    wall  = "AROCK2",  -- NOTE: animated!
    floor = "RROCK13",
    ceil  = "RROCK13",

    step = "ROCK2",
--  void = "A-MOSROK",
    pillar = "A-MOSRK2",

    good_liquid = "water",
  }

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
  }
}

PL_RAILS =
{
  r_4 = { wall="MIDSPACE", w=128, h=128 }
  r_5 = { wall="A-GRATE",  w=128, h=128 }
  r_6 = { wall="A-RAIL1",  w=64,  h=32  }
}

PL_DOORS =
{

--[[ !!!! FIXME
  d_metal  = { wall="A-BROWN4", w=128, h=128 }
  d_poison = { wall="SLIME3",   w=128, h=128 }
--]]
}

PL_WALL_PREFABS =
{
}

PL_LIQUIDS =
{
  water = { floor="FWATER1", wall="WFALL1" }
}

PL_SKY_INFO =
{
  { color="white",  light=208 }
  { color="red",    light=192 }
  { color="red",    light=192 }
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
  }
}

-----< end of old stuff <-----


----------------------------------------------------------------

PLUTONIA.MATERIALS =
{
  -- Note the hyphens in the actual texture names, which have been
  -- converted to an underscore for the OBLIGE material names.
  
  A_BRBRK  = { t="A-BRBRK",  f="xxx" }
  A_BRBRK2 = { t="A-BRBRK2", f="xxx" }
  A_BRICK1 = { t="A-BRICK1", f="xxx" }
  A_BRICK2 = { t="A-BRICK2", f="xxx" }
  A_BRICK3 = { t="A-BRICK3", f="xxx" }
  A_BROCK2 = { t="A-BROCK2", f="xxx" }
  A_BROWN1 = { t="A-BROWN1", f="xxx" }
  A_BROWN2 = { t="A-BROWN2", f="xxx" }
  A_BROWN3 = { t="A-BROWN3", f="xxx" }
  A_BROWN5 = { t="A-BROWN5", f="xxx" }

  A_CAMO1 =  { t="A-CAMO1",  f="xxx" }
  A_CAMO2 =  { t="A-CAMO2",  f="xxx" }
  A_CAMO3 =  { t="A-CAMO3",  f="xxx" }
  A_CAMO4 =  { t="A-CAMO4",  f="xxx" }

  A_CONCTE = { t="A-CONCTE", f="xxx" }
  A_DBRI1 =  { t="A-DBRI1",  f="xxx" }
  A_DBRI2 =  { t="A-DBRI2",  f="xxx" }
  A_DROCK1 = { t="A-DROCK1", f="xxx" }
  A_DROCK2 = { t="A-DROCK2", f="xxx" }

  A_MARBLE = { t="A-MARBLE", f="xxx" }
  A_MOSBRI = { t="A-MOSBRI", f="xxx" }
  A_MOSROK = { t="A-MOSROK", f="xxx" }
  A_MOSRK2 = { t="A-MOSRK2", f="xxx" }
  A_MOULD =  { t="A-MOULD",  f="xxx" }
  A_MUD =    { t="A-MUD",    f="xxx" }

  A_MYWOOD = { t="A-MYWOOD", f="xxx" }
  A_POIS =   { t="A-POIS",   f="xxx" }
  A_REDROK = { t="A-REDROK", f="xxx" }
  A_ROCK =   { t="A-ROCK",   f="xxx" }
  A_TILE =   { t="A-TILE",   f="xxx" }  
  A_VINE3 =  { t="A-VINE3",  f="xxx" }
  A_VINE4 =  { t="A-VINE4",  f="xxx" }
  A_VINE5 =  { t="A-VINE5",  f="xxx" }

  A_YELLOW = { t="A-YELLOW", f="FLAT23" }

  -- TODO: A-SKINxxx

  -- this is animated
  AROCK1   = { t="AROCK1", f="GRNROCK" }

  JUNGLE1  = { t="MC10", f="RROCK19" }
  JUNGLE2  = { t="MC2",  f="RROCK19" }

  -- use the TNT name for this
  METALDR  = { t="A-BROWN4", f="CEIL5_2" }

  -- replacement materials
  WOOD1    = { t="A-WOOD1", f="FLAT5_2" }
  CEIL1_1  = { f="CEIL1_1", t="A-WOOD1", color=0x5b442b }
  CEIL1_3  = { f="CEIL1_3", t="A-WOOD1", color=0x594d3d }
  FLAT5_1  = { f="FLAT5_1", t="A-WOOD1", color=0x503b22 }
  FLAT5_2  = { f="FLAT5_2", t="A-WOOD1", color=0x503c24 }

  -- use Plutonia's waterfall texture instead of our own
  WFALL1   = { t="WFALL1", f="FWATER1", sane=1 }
  FWATER1  = { t="WFALL1", f="FWATER1", sane=1 }


  -- TODO: Rails
  --   A_GRATE = { t="A-GRATE", h=129 }
  --   A_GRATE = { t="A-GRATE", h=129 }
  --   A_RAIL1 = { t="A-RAIL1", h=32 }
  --   A_VINE1 = { t="A-VINE1", h=128 }
  --   A_VINE2 = { t="A-VINE2", h=128 }
}


----------------------------------------------------------------

OB_GAMES["plutonia"] =
{
  label = "Plutonia Exp."

  extends = "doom2"

  tables =
  {
    PLUTONIA
  }
}

