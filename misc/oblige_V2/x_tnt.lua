----------------------------------------------------------------
-- GAME DEF : TNT Evilution (Final DOOM)
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

TN_COMBOS =
{
  URBAN_EGYPT =
  {
    theme_probs = { URBAN=130 },
    mat_pri = 8,

    wall  = "BIGWALL",
    floor = "FLOOR0_2",
    ceil  = "FLOOR0_2", -- "FLAT1_2",
    step  = "BRICK2",

    scenery = "green_torch",

    sc_fabs = { pillar_rnd_DRSIDE1=50, pillar_rnd_DRSIDE2=50, other=3 },

    wall_fabs = { wall_pic_MURAL1=50, wall_pic_MURAL2=50, wall_pic_LONGWALL=10, other=5 },
  },

  URBAN_STONEW1 =
  {
    theme_probs = { URBAN=15 },
    mat_pri = 5,

    wall  = "STONEW1",
    floor = "RROCK11",
    ceil  = "FLAT10",
    step  = "STEP6",
  },
}

TN_SCENERY_PREFABS =
{
  pillar_rnd_DRSIDE1 =
  {
    prefab = "PILLAR_ROUND_SMALL",
    add_mode = "island",
    environment = "indoor",
    skin = { wall="DRSIDE1" },
  },

  pillar_rnd_DRSIDE2 =
  {
    prefab = "PILLAR_ROUND_SMALL",
    add_mode = "island",
    environment = "indoor",
    skin = { wall="DRSIDE2" },
  },

  crate_WOOD_L6 =
  {
    prefab = "CRATE",
    skin = { crate_h=64, crate_w="CRLWDL6", crate_f="FLOOR4_1" }
  },

  crate_big_WOOD_L12 =
  {
    prefab = "CRATE_BIG",
    min_height = 144,
    skin = { crate_h=128, crate_w="CRLWDL12", crate_f="FLOOR4_1" }
  },

  crate_rot_WOOD_L6C =
  {
    prefab = "CRATE_ROTATE",
    skin = { crate_w="CRLWDL6C", crate_h=64, crate_f="FLAT5_5" }
  },
  
  crate_WOOD_H =
  {
    prefab = "CRATE",
    min_height = 144,
    skin = { crate_w="CRWDH64", crate_h=128, crate_f="FLAT5_2" }
  },

  crate_rot_WOOD2_H =
  {
    prefab = "CRATE_ROTATE",
    min_height = 144,
    skin = { crate_w="CRWDH64B", crate_h=128, crate_f="FLOOR7_1" }
  },

  crate_WOOD_LA =
  {
    prefab = "CRATE",
    skin = { crate_w="CRWDL64A", crate_h=64, crate_f="FLOOR7_1" }
  },

  crate_rot_WOOD_BH =
  {
    prefab = "CRATE_ROTATE",
    min_height = 144,
    skin = { crate_w="CRBLWDH6", crate_h=128, crate_f="FLAT5_5" }
  },

}

TN_WALL_PREFABS =
{
  wall_pic_DISASTER =
  {
    prefab = "WALL_PIC",
    min_height = 160,
    skin = { pic_w="DISASTER", pic_h=128 },
    prob = 10,
  },

  wall_pic_TNTDOOR =
  {
    prefab = "WALL_PIC",
    min_height = 160,
    skin = { pic_w="TNTDOOR", pic_h=128 },
    theme_probs = { TECH=5, INDUSTRIAL=20 },
  },

  wall_pic_MURAL1 =
  {
    prefab = "WALL_PIC_SHALLOW",
    min_height = 144,
    skin = { pic_w="MURAL1", pic_h=128 },
    prob = 0.5,
    theme_probs = { URBAN=5, NATURE=3 },
  },

  wall_pic_MURAL2 =
  {
    prefab = "WALL_PIC_SHALLOW",
    min_height = 144,
    skin = { pic_w="MURAL2", pic_h=128 },
    theme_probs = { URBAN=5, NATURE=3 },
  },

  wall_pic_LONGWALL =
  {
    prefab = "WALL_PIC_SCROLLER",
    min_height = 160,
    skin = { pic_w="LONGWALL", pic_h=128, kind=48 },
  },

  lights_wide_LITEGRN1 =
  {
    prefab = "WALL_LIGHTS_WIDE",
    min_height = 128,
    theme_probs = { INDUSTRIAL=50 },
    skin =
    {
      lite_w="LITEGRN1", lite_side="LITEGRN1",
      frame_f="FLAT3",
      wall_lt=255, kind=8,
    },
  },

  lights_wide_LITERED1 =
  {
    prefab = "WALL_LIGHTS_WIDE",
    min_height = 128,
    theme_probs = { TECH=45 },
    skin =
    {
      lite_w="LITERED1", lite_side="LITERED1",
      frame_f="FLAT3",
      wall_lt=255, kind=8,
    },
  },

  lights_wide_LITEYEL1 =
  {
    prefab = "WALL_LIGHTS_WIDE",
    min_height = 128,
    theme_probs = { TECH=15 },
    skin =
    {
      lite_w="LITEYEL1", lite_side="LITEYEL1",
      frame_f="FLAT3",
      wall_lt=255, kind=8,
    },
  },
}

TN_RAILS =
{
  r_3 = { wall="TYIRONSM", w=64,  h=72  },
  r_4 = { wall="TYIRONLG", w=128, h=128 },
}

TN_DOORS =
{
--[[ !!!! FIXME
  d_metal = { wall="METALDR", w=128, h=128 },
--]]
}

TN_ROOMS =
{
  WAREHOUSE2 =
  {
    space_range = { 80, 99 },

    pf_count = { 4,10 },

    sc_fabs =
    {
      crate_WOOD_L6 = 50,
      crate_WOOD_H = 50,
      crate_WOOD_LA = 50,

      crate_big_WOOD_L12 = 70,

      crate_rot_WOOD_L6C = 30,
      crate_rot_WOOD2_H = 30,
      crate_rot_WOOD_BH = 30,

      other = 10
    },
  },
}

TN_SKY_INFO =
{
  { color="brown",  light=192 },
  { color="black",  light=160 },
  { color="red",    light=192 },
}

----------------------------------------------------------------

GAME_FACTORIES["tnt"] = function()

  local T = GAME_FACTORIES.doom2()

  T.rails   = copy_and_merge(T.rails,  TN_RAILS)

---##  T.doors   = copy_and_merge(T.doors,  TN_DOORS)

  T.combos = copy_and_merge(T.combos, TN_COMBOS)
  T.rooms  = copy_and_merge(T.rooms,  TN_ROOMS)

  T.sc_fabs   = copy_and_merge(T.sc_fabs,   TN_SCENERY_PREFABS)
  T.wall_fabs = copy_and_merge(T.wall_fabs, TN_WALL_PREFABS)

  T.sky_info = TN_SKY_INFO

  return T
end
