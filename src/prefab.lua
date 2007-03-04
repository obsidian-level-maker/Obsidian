----------------------------------------------------------------
-- PREFAB definitions
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
--
--  Thanks to Derek "Dittohead" Braun who originally made
--  many of these Prefabs.
--
----------------------------------------------------------------


--[[

ELEMENTS:

Applied using a param[] table.

if field doesn't exist, look in param[] table.

Certain fields (textures/flats/c_rel) lookup their value in param[].


E.g.

param = copy_block_with_new(c.rmodel,
{
  f_tex = "FLAT1",
  c_tex = "FLAT1",

  wall = theme.wall,

  door = "BIGDOOR1",
  track = "DOORTRAK",
  step = "STEP1",
  bottom = door_info.ceil,

  door_top = c.rmodel.f_h + door_info.h,
 

})

make_prefab(PREFABS.DOOR, param, coords...)

--]]

----------------------------------------------------------------

PREFABS =
{

-- Note: texture names (like STARTAN3) are never used here.
-- Instead the names here (like "frame") are looked-up in a
-- SKIN table.  This allows the same prefab to be used with
-- different textures (which are game-dependent).

ARCH =
{
  structure =
  {
    "##aaaaaaaa##",
    "##aaaaaaaa##",
    "##aaaaaaaa##",
    "##aaaaaaaa##",
  },

  elements =
  {
    a = { f_h=0, c_rel="door_top", c_h=0,
          l_tex="frame", f_tex="frame_f", c_tex="frame_c",
        },
  },
},

ARCH_NARROW =
{
  copy="DOOR",

  structure =
  {
    "#aaaaaa#",
    "#aaaaaa#",
    "#aaaaaa#",
    "#aaaaaa#",
  },
},

ARCH_ARCHED =
{
  structure =
  {
    "##cbaaaabc##",
    "##cbaaaabc##",
    "##cbaaaabc##",
    "##cbaaaabc##",
  },

  elements =
  {
    a = { f_h=0, c_rel="door_top", c_h=0,
          l_tex="frame", f_tex="frame_f", c_tex="frame_c",
        },

    b = { copy="a", c_h=-16 },
    c = { copy="a", c_h=-32 },
  },
},

ARCH_TRUSS =
{
  structure =
  {
    "##BaaaaaaB##",
    "##CaaaaaaC##",
    "##CaaaaaaC##",
    "##BaaaaaaB##",
  },

  elements =
  {
    a = { f_h=0, c_rel="door_top", c_h=0,
          l_tex="frame", f_tex="frame_f", c_tex="frame_c",
        },

    B = { f_rel="door_top", f_h=0, c_rel="door_top", c_h=0,
          l_tex="beam",  f_tex="beam_c",
          u_tex="frame", c_tex="frame_c"
        },

    C = { f_h=0, c_rel="door_top", c_h=-8,
          l_tex="frame", f_tex="frame_f",
          u_tex="beam",  c_tex="beam_c", u_peg="top",
        }
  },
},

ARCH_RUSSIAN =
{
  structure =
  {
    "##aaaaaaaa##",
    "##BssssssB##",
    "##BssssssB##",
    "##aaaaaaaa##",
  },

  elements =
  {
    a = { f_h=0, c_rel="door_top", c_h=16,
          l_tex="frame", f_tex="frame_f", c_tex="frame_c",
        },

    s = { f_h=0, c_rel="door_top", c_h=0,
          l_tex="support", u_tex="support", c_tex="supp_c",
          f_tex="frame_f", u_peg="top"
        },

    B = { solid="support" },
  },
},

ARCH_BEAMS =
{
  copy="ARCH_RUSSIAN",

  structure =
  {
    "#aaaaaaaaaa#",
    "#aaaaaaaaaa#",
    "#aBaaaaaaBa#",
    "#aaaaaaaaaa#",
  },
},

ARCH_BEAM_WIDE =
{
  copy="ARCH_BEAMS",

  structure =
  {
    "##aaaaaaaaaaaa##",
    "##aBBaaaaaaBBa##",
    "##aBBaaaaaaBBa##",
    "##aaaaaaaaaaaa##",
  },
},

ARCH_CURVY =
{
  structure =
  {
    "##aaaaaaaa##",
    "#RaaaaaaaaS#",
    "#TaaaaaaaaU#",
    "##aaaaaaaa##",
  },

  elements =
  {
    a = { f_h=0, c_rel="door_top", c_h=0,
          l_tex="frame", f_tex="frame_f", c_tex="frame_c",
        },

    R = { solid="wall", [9]={ dx= 16,dy=0 }, [3]={ dx= 20,dy=0 } },
    S = { solid="wall", [7]={ dx=-16,dy=0 }, [1]={ dx=-20,dy=0 } },

    T = { solid="wall", [3]={ dx= 16,dy=0 } },
    U = { solid="wall", [1]={ dx=-16,dy=0 } },
  },
},


DOOR =
{
  structure =
  {
    "#LssssssssM#",
    "#TddddddddT#",
    "#TddddddddT#",
    "#LssssssssM#",
  },

  elements =
  {
    -- steps
    s = { f_h=8, c_rel="door_top", c_h=-8,
          f_tex="frame_floor", c_tex="frame_ceil", l_tex="step",
          l_peg="top", light=224
        },

    -- door
    d = { copy="s", c_rel="floor", c_h=8, u_tex="door", c_tex = "door_ceil",
          kind="door_kind", tag="tag", u_peg="bottom", l_peg="bottom"
        },

    -- track
    T = { solid="track", l_peg="bottom" },

    -- lights
    L = { solid="wall", [6]={ l_tex="light" } },
    M = { solid="wall", [4]={ l_tex="light" } },
  },
},

DOOR_NARROW =
{
  copy="DOOR",

  structure =
  {
    "#LssssM#",
    "#tddddt#",
    "#tddddt#",
    "#LssssM#",
  },
},


TECH_PICKUP_SMALL =
{
  structure =
  {
    "####aaaaaaaa####",
    "####bbbbbbbb####",
    "##LLccccccccLL##",
    "##L#dddddddd#L##",
    "abcdeeeeeeeedcba",
    "abcdeeeeeeeedcba",
    "abcdeeeeeeeedcba",
    "abcdeeeeeeeedcba",
    "abcdeeeeeeeedcba",
    "abcdeeeeeeeedcba",
    "abcdeeeeeeeedcba",
    "abcdeeeeeeeedcba",
    "##L#dddddddd#L##",
    "##LLccccccccLL##",
    "####bbbbbbbb####",
    "####aaaaaaaa####",
  },

  elements =
  {
    -- steps
    a = { l_tex="step", light=128, c_h=-48, l_peg="top" },

    b = { copy="a", f_h= -8, c_h=-56 },
    c = { copy="a", f_h=-16, c_h=-64, light=192 },
    d = { copy="a", f_h=-24, c_h=-64 },

    e = { copy="a", f_h=-32, c_h=0, light=160, f_tex="carpet", c_tex="sky" },

    -- light
    L = { solid="light" },
  },

  pickup_pos = { x=128, y=128 }
},

TECH_PICKUP_LARGE =
{
  copy="TECH_PICKUP_SMALL",

  structure =
  {
    "####aaaaaaaaaaaa####",
    "####bbbbbbbbbbbb####",
    "##LLccccccccccccLL##",
    "##L#dddddddddddd#L##",
    "abcdeeeeeeeeeeeedcba",
    "abcdeeeeeeeeeeeedcba",
    "abcdeeeeeeeeeeeedcba",
    "abcdeeeeeeeeeeeedcba",
    "abcdeeeeeeeeeeeedcba",
    "abcdeeeeeeeeeeeedcba",
    "abcdeeeeeeeeeeeedcba",
    "abcdeeeeeeeeeeeedcba",
    "abcdeeeeeeeeeeeedcba",
    "abcdeeeeeeeeeeeedcba",
    "abcdeeeeeeeeeeeedcba",
    "abcdeeeeeeeeeeeedcba",
    "##L#dddddddddddd#L##",
    "##LLccccccccccccLL##",
    "####bbbbbbbbbbbb####",
    "####aaaaaaaaaaaa####",
  },

  pickup_pos = { x=192, y=192 }
},


TECH_STATUE_1 =
{
  structure =
  {
    "....................",
    "....................",
    "..aaaaaaaaaaaaaaaa..",
    "..aaaaaaaaaaaaaaaa..",
    "..aabbbbccccbbbbaa..",
    "..aabbbbccccbbbbaa..",
    "..aabbbbccccbbbbaa..",
    "..aabbbbccccbbbbaa..",
    "..aaffffggggffffaa..",
    "..aaffffggggffffaa..",
    "..aaffffggggffffaa..",
    "..aaffffggggffffaa..",
    "..aabbbbccccbbbbaa..",
    "..aabbbbccccbbbbaa..",
    "..aabbbbccccbbbbaa..",
    "..aabbbbccccbbbbaa..",
    "..aaaaaaaaaaaaaaaa..",
    "..aaaaaaaaaaaaaaaa..",
    "....................",
    "....................",
  },

  elements =
  {
    a = { f_h=8, c_rel="floor", c_h=256,
          l_tex="step", l_peg="top"
        },

    b = { f_h=16, c_rel="floor", c_h=192,
          l_tex="step",   u_tex="u_span",
          f_tex="carpet", c_tex="c_lite",
          light=192
        },

    c = { f_h=64, c_rel="floor", c_h=256,
          f_tex="comp_top", l_tex="comp1",
        },

    f = { copy="c", f_h=128, l_tex="comp2", x_offset=128 },

    g = { copy="c", f_h=192, l_tex="wall" },

  },

  things =
  {
    { kind="thing1", x = 96, y = 96 },
    { kind="thing1", x =224, y = 96 },
    { kind="thing1", x = 96, y =224 },
    { kind="thing1", x =224, y =224 },
  },
},

GROUND_LIGHT =
{
  structure =
  {
    "aaaaaaa.",
    "abbbbba.",
    "abcccba.",
    "abcdcba.",
    "abcccba.",
    "abbbbba.",
    "aaaaaaa.",
    "........",
  },

  elements =
  {
    a = { f_h = 0 },

    b = { f_h = 8, l_tex = "shawn", f_tex="shawn_top", l_peg="top", },

    c = { copy="b", f_h=40, light=192 },

    d = { f_h = 64, l_tex = "light", f_tex = "lite_top" },
  },
},


MEGA_SKYLIGHT_1 =
{
  -- frame, frame_ceil
  -- beam,  beam_ceil
  -- sky

  structure =
  {
    "ffffffffffffffffffff",
    "ffffffffffffffffffff",
    "ffssBBBBBBBBBBBBssff",
    "ffssBBBBBBBBBBBBssff",
    "ffssssCCssssCCssssff",
    "ffssssCCssssCCssssff",
    "ffssssCCssssCCssssff",
    "ffssssCCssssCCssssff",
    "ffssssCCssssCCssssff",
    "ffssssCCssssCCssssff",
    "ffssssCCssssCCssssff",
    "ffssssCCssssCCssssff",
    "ffssBBBBBBBBBBBBssff",
    "ffssBBBBBBBBBBBBssff",
    "ffffffffffffffffffff",
    "ffffffffffffffffffff",
  },

  elements =
  {
    s = { c_tex="sky", light=192 },

    f = { c_h=-32, c_tex="frame_ceil", u_tex="frame" },

    B = { c_h=-16, c_tex="beam_ceil", u_tex="beam" },

    C = { copy="B", c_h=-8 },
  },
},

MEGA_SKYLIGHT_2 =
{
  copy="MEGA_SKYLIGHT_1",

  structure =
  {
    "ffffffffffffffff",
    "ffffffffffffffff",
    "ffsBssBssBssBsff",
    "ffsBssBssBssBsff",
    "ffsBssBssBssBsff",
    "ffBBBBBBBBBBBBff",
    "ffsBssBssBssBsff",
    "ffsBssBssBssBsff",
    "ffsBssBssBssBsff",
    "ffsBssBssBssBsff",
    "ffBBBBBBBBBBBBff",
    "ffsBssBssBssBsff",
    "ffsBssBssBssBsff",
    "ffsBssBssBssBsff",
    "ffffffffffffffff",
    "ffffffffffffffff",
  },
},

MEGA_SKYLIGHT_3 =
{
  copy="MEGA_SKYLIGHT_1",

  structure =
  {
    "ffffffffffffffff",
    "ffffffffffffffff",
    "ffssBssBBssBssff",
    "ffssBssBBssBssff",
    "ffBBBBBBBBBBBBff",
    "ffssBssBBssBssff",
    "ffssBssssssBssff",
    "ffBBBBssssBBBBff",
    "ffBBBBssssBBBBff",
    "ffssBssssssBssff",
    "ffssBssBBssBssff",
    "ffBBBBBBBBBBBBff",
    "ffssBssBBssBssff",
    "ffssBssBBssBssff",
    "ffffffffffffffff",
    "ffffffffffffffff",
  },
},


BILLBOARD =
{
  structure =
  {
    "................",
    ".DCCssssssssCCE.",
    ".CCppppppppppCC.",
    ".CCCssssssssCCC.",
  },

  elements =
  {
    -- corner
    C = { f_h=0, f_rel="corn_h",
          l_tex="corner", f_tex="corn_f", l_peg="top", },

    D = { copy="C", [7] = { dx= 8, dy=-8 } },
    E = { copy="C", [9] = { dx=-8, dy=-8 } },

    -- pic
    p = { f_h=8, f_rel="pic_h",
          l_tex="pic_back", [2] = { l_tex="pic" },
          f_tex="pic_f", l_peg="top",
        },

    -- step
    s = { f_h=8, l_tex="step", f_tex="step_f", l_peg="top" },
  }
},

BILLBOARD_LIT =
{
  structure =
  {
    "................",
    ".CCC........DDD.",
    ".CLEppppppppELD.",
    ".CtEssssssssEtD.",
  },

  elements =
  {
    -- corner
    E = { f_h=0, f_rel="corn_h",
          l_tex="corn2", f_tex="corn_f", l_peg="top", },

    C = { copy="E",
          [4] = { l_tex="corner" },
          [8] = { l_tex="corner" },
        },

    D = { copy="E",
          [6] = { l_tex="corner" },
          [8] = { l_tex="corner" },
        },

    -- light
    L = { copy="E", [2] = { l_tex="light" }, },

    -- pic
    p = { f_h=8, f_rel="pic_h",
          l_tex="pic_back", [2] = { l_tex="pic" },
          f_tex="pic_f", l_peg="top",
        },

    -- step
    s = { f_h=8, l_tex="step", f_tex="step_f", l_peg="top" },

    t = { copy="s", f_h=16, light=208 },
  },
},


CORNER_DIAGONAL =
{
  structure =
  {
    "AAA.",
    "AAA.",
    "AAA.",
    "....",
  },

  elements =
  {
--# A = { solid="wall", [3] = {VDEL=true}, [9] = {VDEL=true} },
    A = { solid="wall", [3] = {VDEL=true} },
  },
},

CORNER_DIAG_BIG =
{
  copy="CORNER_DIAGONAL",

  structure =
  {
    "AAAAAAA.",
    "AAAAAAA.",
    "AAAAAAA.",
    "AAAAAAA.",
    "AAAAAAA.",
    "AAAAAAA.",
    "AAAAAAA.",
    "........",
  },
},

CORNER_DIAG_30DEG =
{
  copy="CORNER_DIAGONAL",

  structure =
  {
    "AAAAAAA.",
    "AAAAAAA.",
    "AAAAAAA.",
    "........",
  },
},

CORNER_CONCAVE =
{
  structure =
  {
    "##B.",
    "##B.",
    "AA..",
    "....",
  },

  elements =
  {
    A = { solid="wall", [3]={ dx=-27, dy=16 }, [9]={ dx=-16, dy=16 },
          [2] = { x_offset=0 }, [6] = { x_offset=17 },
        },

    B = { solid="wall", [3] = { dx=-16, dy=27 },
          [2] = { x_offset=36 }, [6] = { x_offset=55 },
        },
  },
},

CORNER_CONVEX =
{
  structure =
  {
    "##B.",
    "##B.",
    "AA..",
    "....",
  },

  elements =
  {
    A = { solid="wall", [3] = { dx=-16, dy=5 },
          [2] = { x_offset=0 }, [6] = { x_offset=17 },
        },

    B = { solid="wall", [3] = { dx=-5, dy=16 },
          [2] = { x_offset=36 }, [6] = { x_offset=55 },
        },
  },
},


} -- PREFABS

