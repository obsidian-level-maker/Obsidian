----------------------------------------------------------------
-- THEMES : Plutonia Experiment (Final DOOM)
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

PL_RAILS =
{
  r_4 = { tex="MIDSPACE", w=128, h=128 },
  r_5 = { tex="A-GRATE",  w=128, h=128 },
  r_6 = { tex="A-RAIL1",  w=64,  h=32  },
}

PL_DOORS =
{
  d_metal  = { tex="A-BROWN4", w=128, h=128 },
  d_poison = { tex="SLIME3",   w=128, h=128 },
}

PL_PICS =
{
  { tex="A-REDROK", w=128, h=128 },
  { tex="A-ASKIN3", w=128, h=128 },
  { tex="A-ASKIN4", w=128, h=128 },
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

THEME_FACTORIES["plutonia"] = function()

  local T = THEME_FACTORIES.doom2()

  T.rails   = copy_and_merge(T.rails,  PL_RAILS)
  T.doors   = copy_and_merge(T.doors,  PL_DOORS)
  T.pics    = copy_and_merge(T.pics,   PL_PICS)

  T.special_ped = PL_SPECIAL_PEDESTAL

  return T
end

