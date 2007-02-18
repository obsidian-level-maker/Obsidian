----------------------------------------------------------------
-- THEMES : TNT Evilution (Final DOOM)
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

TN_RAILS =
{
  r_3 = { tex="TYIRONSM", w=64,  h=72  },
  r_4 = { tex="TYIRONLG", w=128, h=128 },
}

TN_CRATES =
{
  WOOD_L6 =
  {
    wall = "CRLWDL6", h=64, floor = "FLOOR4_1",
  },
  
  WOOD_L6C =
  {
    wall = "CRLWDL6C", h=64, floor = "FLAT5_5",
  },
  
  WOOD_H =
  {
    wall = "CRWDH64", h=128, floor = "FLAT5_2",
  },

  WOOD_LA =
  {
    wall = "CRWDL64A", h=128, floor = "FLOOR7_1",
  },

  WOOD_BH =
  {
    wall = "CRBLWDH6", h=128, floor = "FLAT5_5",
  },

}

TN_LIGHTS =
{
  br_grn = { tex="LITEGRN1", w=32 },
  br_red = { tex="LITERED1", w=32 },
  br_yel = { tex="LITEYEL1", w=32 },
}

TN_DOORS =
{
  d_metal = { tex="METALDR", w=128, h=128 },
}

TN_PICS =
{
  egypt1 = { tex="BIGWALL",  w=128, h=128 },
  egypt2 = { tex="LONGWALL", w=128, h=128 },
  egypt3 = { tex="MURAL1",   w=128, h=128 },
  egypt4 = { tex="MURAL2",   w=128, h=128 },

  tnt1   = { tex="TNTDOOR",  w=128, h=128 },
  disast = { tex="DISASTER", w=128, h=128 },
  gr_men = { tex="GRNMEN",   w=128, h=128 },
  lt_yel = { tex="LITEYEL3", w=128, h=128, glow=true },
}

----------------------------------------------------------------

THEME_FACTORIES["tnt"] = function()

  local T = THEME_FACTORIES.doom2()

  T.rails   = copy_and_merge(T.rails,  TN_RAILS)
  T.crates  = copy_and_merge(T.crates, TN_CRATES)
  T.lights  = copy_and_merge(T.lights, TN_LIGHTS)
  T.doors   = copy_and_merge(T.doors,  TN_DOORS)
  T.pics    = copy_and_merge(T.pics,   TN_PICS)

  return T
end
