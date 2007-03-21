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

------ Arches ------------------------------------

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
  copy="ARCH",

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


------ Windows ------------------------------------

WINDOW_NARROW =
{
  structure =
  {
    "#ww#",
    "#ww#",
    "#ww#",
    "#ww#",
  },

  elements =
  {
    w = { f_h=0, f_rel="window_floor", c_h=0, c_rel="window_ceil" },
  }
},

WINDOW_EDGE =
{
  structure =
  {
    "#www",
    "#www",
    "#www",
    "#www",
  },

  elements =
  {
    w = { f_h=0, f_rel="window_floor", c_h=0, c_rel="window_ceil" },
  }
},

WINDOW_EDGE_ARCHED =
{
  structure =
  {
    "#abw",
    "#abw",
    "#abw",
    "#abw",
  },

  elements =
  {
    w = { f_h=0, f_rel="window_floor", c_h=0, c_rel="window_ceil" },

    a = { copy="w", f_h=12, c_h=-12 },
    b = { copy="w", f_h=24, c_h=-24 },
  }
},

WINDOW_CROSS =
{
  structure =
  {
    "#aawwaa#",
    "#aawwaa#",
    "#aawwaa#",
    "#aawwaa#",
  },

  elements =
  {
    w = { f_h=0, f_rel="window_floor", c_h=0, c_rel="window_ceil" },

    a = { f_h=-16, f_rel="window_mid", c_h=16, c_rel="window_mid" },
  }
},

WINDOW_CROSS_BIG =
{
  copy="WINDOW_CROSS",

  structure =
  {
    "#aaaawwaaaa#",
    "#aaaawwaaaa#",
    "#aaaawwaaaa#",
    "#aaaawwaaaa#",
  },
},

WINDOW_BARRED =
{
  structure =
  {
    "#wwwwwwwww##",
    "#wBwwwBwww##",
    "#wwwBwwwBw##",
    "#wwwwwwwww##",
  },

  elements =
  {
    w = { f_h=0, f_rel="window_floor", c_h=0, c_rel="window_ceil" },

    B = { solid="bar_w" },
  }
},

WINDOW_RAIL =
{
  structure =
  {
    "#wwwwwwwwww#",
    "#wwwwwwwwww#",
    "#RRRRRRRRRR#",
    "#wwwwwwwwww#",
  },

  elements =
  {
    w = { f_h=0, f_rel="window_floor", c_h=0, c_rel="window_ceil" },

    R = { copy="w", [8] = { rail="rail" } },
  }
},



------ Doors ------------------------------------

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
    s = { f_h=8, c_rel="door_top", c_h=8,
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

DOOR_LOCKED =
{
  structure =
  {
    "KKssssssssKK",
    "KTddddddddTK",
    "KTddddddddTK",
    "KKssssssssKK",
  },

  elements =
  {
    -- steps
    s = { f_h=8, c_rel="door_top", c_h=8,
          f_tex="frame_floor", c_tex="frame_ceil", l_tex="step",
          l_peg="top", light=224
        },

    -- door
    d = { copy="s", c_rel="floor", c_h=8, u_tex="door", c_tex = "door_ceil",
          kind="door_kind", tag="tag", u_peg="bottom", l_peg="bottom"
        },

    -- track
    T = { solid="track", l_peg="bottom" },

    -- key
    K = { solid="key_w" },
  },
},

DOOR_EXIT =
{
  structure =
  {
    "##ssss##",
    "##sXXs##",
    "#MssssL#",
    "#TddddT#",
    "#LssssM#",
    "##ssss##",
    "##sXXs##",
    "##ssss##",
  },

  elements =
  {
    -- steps
    s = { f_h=8, c_rel="door_top", c_h=8,
          f_tex="frame_floor", c_tex="frame_ceil", l_tex="step",
          l_peg="top", light=224
        },

    -- door
    d = { copy="s", c_rel="floor", c_h=8, u_tex="door", c_tex = "door_ceil",
          kind="door_kind", tag="tag", u_peg="bottom", l_peg="bottom"
        },

    -- sign
    X = { copy="s", u_tex="exit_w", c_rel="door_top", c_h=-8,
          c_tex="exit_c", u_peg="top",
          [4] = { x_offset=32 }, [6] = { x_offset=32 },
        },

    -- track
    T = { solid="track", l_peg="bottom" },

    -- light
    L = { solid="door", l_peg="bottom",
          [4] = { x_offset=72 }, [6] = { x_offset=72 } },

    M = { solid="door", l_peg="bottom",
          [4] = { x_offset=88 }, [6] = { x_offset=88 } },

  },
},

EXIT_SIGN_CEIL =
{
  structure =
  {
    "....",
    "....",
    ".XX.",
    "....",
  },

  elements =
  {
    -- sign
    X = { c_h=-16, u_tex="exit_w", c_tex="exit_c", u_peg="top",
          [4] = { x_offset=32 }, [6] = { x_offset=32 },
        },
  },
},

EXIT_SIGN_FLOOR =
{
  structure =
  {
    "....",
    "....",
    ".XX.",
    "....",
  },

  elements =
  {
    -- sign
    X = { f_h=16, l_tex="exit_w", f_tex="exit_c", l_peg="top",
          [4] = { x_offset=32 }, [6] = { x_offset=32 },
        },
  },
},


BARS_1 =
{
  structure =
  {
    "##ssssssss##",
    "##sBBssBBs##",
    "##sBBssBBs##",
    "##ssssssss##",
  },

  elements =
  {
    -- step
    s = { c_rel="door_top", c_h=0, c_tex="frame_ceil" },

    -- bars
    B = { f_rel="door_top", f_h=0,
          c_rel="door_top", c_h=0,
          u_tex="bar_w", u_peg="bottom",
          l_tex="bar_w", l_peg="bottom",
          kind="door_kind", tag="tag",
        },
  },
},

BARS_2 =
{
  copy="BARS_1",

  structure =
  {
    "##sssssssss#",
    "##sssssssss#",
    "##sBsBsBsBs#",
    "##sssssssss#",
  },
},

BARS_NARROW =
{
  copy="BARS_1",

  structure =
  {
    "#ssssss#",
    "#ssBBss#",
    "#ssBBss#",
    "#ssssss#",
  },
},


------ Switches ------------------------------------

SWITCH_PILLAR =
{
  scale=64,

  structure =
  {
    "P"
  },

  elements =
  {
    P = { solid="side_w",
          [2] = { l_tex="switch", l_peg="bottom", kind="kind", tag="tag" }
        },
  },
},

SWITCH_FLOOR =
{
  structure =
  {
    "....",
    "ssss",
    "....",
    "....",
  },

  elements =
  {
    s = { f_rel="switch_h", f_h=0,
          l_tex="side_w", f_tex="switch_f", l_peg="top",

          [2] = { l_tex="switch", l_peg="top", kind="kind", tag="tag",
                  y_offset="y_offset" }
        },
  },
},

SWITCH_FLOOR_TINY =
{
  structure =
  {
    "....",
    ".ss.",
    "....",
    "....",
  },

  elements =
  {
    s = { f_rel="switch_h", f_h=0,
          l_tex="side_w", f_tex="switch_f", l_peg="top",

          [2] = { l_tex="switch", l_peg="top", kind="kind", tag="tag",
                  x_offset="x_offset", y_offset="y_offset" }
        },
  },
},


------ Decorative I ------------------------------------

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


STATUE_TECH_1 =
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

STATUE_CHAIR_DUDE =
{
  structure =
  {
    "........",
    ".b....b.",
    ".bbbbbb.",
    "SSSHHSSS",
    ".aBBBBa.",
    ".aLccLa.",
    "..L..L..",
    "..F..F..",
  },

  elements =
  {
    -- chair seat, back, armrest
    c = { f_h=24, f_tex="chair_f", l_tex="chair_w" },
    b = { copy="c", f_h=96 },
    a = { copy="c", f_h=48 },

    -- body, head, shoulders
    B = { f_h=56, f_tex="body_f", l_tex="body_w" },
    H = { copy="B", f_h=108 },
    S = { copy="B", f_h=72 },

    -- legs, feet
    L = { copy="B", f_h=32 },
    F = { copy="B", f_h=12 },
  },
},

DRINKS_BAR =
{
  structure =
  {
    "............",
    "bbbbbbbbbbbb",
    "bbbbbbbbbbbb",
    "............",
  },

  elements =
  {
    b = { f_h=32, f_tex="bar_f", l_tex="bar_w", l_peg="top" },
  },

  things =
  {
    { kind="drink", x= 16, y=32 },
    { kind="drink", x= 36, y=32 },
    { kind="drink", x= 56, y=32 },
    { kind="drink", x= 76, y=32 },
    { kind="drink", x= 96, y=32 },
    { kind="drink", x=116, y=32 },
    { kind="drink", x=136, y=32 },
    { kind="drink", x=156, y=32 },
    { kind="drink", x=176, y=32 },
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


------ Skylights ------------------------------------

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


------ Decorative II ------------------------------------

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


------ Corners ------------------------------------

CORNER_BEAM =
{
  structure =
  {
    "BB..",
    "BB..",
    "....",
    "....",
  },

  elements =
  {
    B = { solid="beam" }
  },
},

CORNER_LIGHT =
{
  structure =
  {
    "BBB.",
    "BLs.",
    "Bss.",
    "....",
  },

  elements =
  {
    B = { solid="beam"  },
    L = { solid="light" },

    s = { f_h=16, c_h=-16, l_tex="beam", u_tex="beam",
          f_tex="beam_f", c_tex="beam_f",
          light=192
        }
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

CORNER_CONCAVE_BIG =
{
  structure =
  {
    "####BB..",
    "####BB..",
    "####BB..",
    "####BB..",
    "AAAA....",
    "AAAA....",
    "........",
    "........",
  },

  elements =
  {
    A = { solid="wall", [3]={ dx=-54, dy=32 }, [9]={ dx=-32, dy=32 },
          [2] = { x_offset=0 }, [6] = { x_offset=34 },
        },

    B = { solid="wall", [3] = { dx=-32, dy=54 },
          [2] = { x_offset=72 }, [6] = { x_offset=110 },
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


------ Pillars ------------------------------------

PILLAR_LIGHT1 =
{
  structure =
  {
    "BsB.",
    "sLs.",
    "BsB.",
    "....",
  },

  elements =
  {
    B = { solid="beam"  },
    L = { solid="light" },

    s = { f_h=16, c_h=-16, l_tex="beam", u_tex="beam",
          f_tex="beam_f", c_tex="beam_f",
          light=192
        }
  },
},

PILLAR_LIGHT2 =
{
  copy="PILLAR_LIGHT1",

  structure =
  {
    "BssB",
    "sLLs",
    "sLLs",
    "BssB",
  },
},

PILLAR_LIGHT3 =
{
  structure =
  {
    "pppp",
    "pLLp",
    "pLLp",
    "pppp",
  },

  elements =
  {
    L = { solid="light" },

    p = { f_h=48, c_h=-48, light=192, }
  },
},

------ Pedestals ------------------------------------

PEDESTAL =
{
  scale=64,

  structure =
  {
    "p",
  },

  elements =
  {
    p = { f_h=0, f_rel="ped_h",
          f_tex = "ped_f", l_tex = "ped_side",
          l_peg = "top",
        }
  },
},

PEDESTAL_PLUT =
{
  structure =
  {
    "pppp",
    "pppp",
    "pTpp",
    "pppp",
  },

  elements =
  {
    p = { f_h=16, f_tex="ped_f",
          l_tex="ped_w", l_peg="top",
          light=80,
        },

    T = { f_h=28, f_tex="ped_f2",
          l_tex="ped_w2", l_peg="top",
          light=255, glow=true, -- FIXME: proper glow (parm option)

          [1] = { dx=16, dy=-6 },
          [3] = { dx=22, dy=16 },
          [7] = { dx=-6, dy= 0 },
          [9] = { dx= 0, dy=22 },
        },
  }
},

PEDESTAL_PLUT_DOUBLE =
{
  copy="PEDESTAL_PLUT",

  -- FIXME: elements =
},


------ Overhangs ------------------------------------

OVERHANG_1 =
{
  structure =
  {
    "PooooooooooP",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "PooooooooooP",
  },

  elements =
  {
    P = { solid = "hang_w" }, 

    o = { c_h = -24, c_tex = "hang_c", u_tex = "hang_u",
            light_add = -32,
          },
  },

  -- FIXME: double spot for monsters / objects
},

OVERHANG_2 =
{
  copy="OVERHANG_1",

  structure =
  {
    "PPooooooooPP",
    "PPooooooooPP",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "PPooooooooPP",
    "PPooooooooPP",
  },

  -- FIXME: double spot for monsters / objects
},

OVERHANG_3 =
{
  copy="OVERHANG_1",

  structure =
  {
    "oooooooooooo",
    "oPPooooooPPo",
    "oPPooooooPPo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oooooooooooo",
    "oPPooooooPPo",
    "oPPooooooPPo",
    "oooooooooooo",
  },

  -- FIXME: double spot for monsters / objects
},


------ Wolfenstein ------------------------------------

WOLF_ELEVATOR =
{
  scale=64,

  structure =
  {
    "#E#",
    "E.E",
    "FdF",
  },

  elements =
  {
    E = { solid="elevator" },
    F = { solid="front"    },

    d = { kind="door_kind" },
  },
},

WOLF_PACMAN_BASE =
{
  scale=64,

  structure = { "#" }, -- dummy

  elements =
  {
    G = { solid="ghost_w" },

    B = { thing="blinky", angle=90  },
    C = { thing="clyde",  angle=90  },
    I = { thing="inky",   angle=270 },
    P = { thing="pinky",  angle=270 },

    d = { thing="dot_t" },
    t = { thing="treasure1" },
    u = { thing="treasure2" },
    m = { thing="first_aid" },
  },
},

WOLF_PACMAN_MID_1 =
{
  copy="WOLF_PACMAN_BASE",

  structure =
  {
    "##B.####.######.####C.##",
    "##d.####.######.####d.##",
    "##..##..d.d.d.d.d.##..##",
    "##d.##............##d.##",
    "##..##.dGGG..GGGd.##..##",
    "##d.##.dGGG..GGGd.##d.##",
    "#...##.dGG.tt.GGd.##...#",
    "d.G....dG.tttt.Gd....G.d",
    "..G.d..dGttttttGd..d.G..",
    "#...##.dGGttttGGd.##...#",
    "##d.##.dGGGuuGGGd.##d.##",
    "##..##.dGGGGGGGGd.##..##",
    "##d.##............##d.##",
    "##..##.d.d.d.d.d..##..##",
    "##d.####.######.####d.##",
    "##I.####.######.####P.##",
  },
},

WOLF_PACMAN_MID_2 =
{
  copy="WOLF_PACMAN_BASE",

  structure =
  {
    "##B.#######..#######.C##",
    "##d.#######.d#######.d##",
    "##d.###..........###.d##",
    "##d.##...d..d..d..##.d##",
    "##d.##d.GGGGGGGG.d##.d##",
    "###d....GGtt.GGG....d###",
    "######d.GGttt.GG.d######",
    "######..GGtutt....######",
    "######d.GGtutt...d######",
    "######..GGttt.GG..######",
    "###d..d.GGtt.GGG.d..d###",
    "##d.##..GGGGGGGG..##.d##",
    "##d.##.d..d..d..d.##.d##",
    "##d.###..........###.d##",
    "##d.#######d.#######.d##",
    "##I.#######..#######.P##",
  },
},

WOLF_PACMAN_MID_3 =
{
  copy="WOLF_PACMAN_BASE",

  structure =
  {
    "##B.####.######.####C.##",
    "##d.####d######.####d.##",
    "##..d.d.........d.d...##",
    "######..d.d.d.d...######",
    "dddddd..GGGGGGGGd.dddddd",
    "d#####.dGGtuutGG..#####d",
    "d#####..GttttttGd.#####d",
    "d#####.dG.tttt.G..#####d",
    "dddddd..GGGttGGGd.dddddd",
    "######.dGGGttGGG..######",
    "##...d..G......Gd.d.d.##",
    "##.d##.dG.GGGG.G..##..##",
    "##..##...d.d.d.d..##.d##",
    "##.d##............##..##",
    "##..#######d.#######.d##",
    "##Id#######..#######P.##",
  },
},

WOLF_PACMAN_CORN_1 =
{
  copy="WOLF_PACMAN_BASE",

  structure =
  {
    "#########...........",
    "#########d.d.d.d.d..",
    "#########.########.#",
    "####.d...d########d#",
    "####...m....##......",
    ".d.d.d####d.##..d.d.",
    ".........#..d.d.####",
    "d.#####..#####..d.d.",
    "..###tttuttt##......",
    "d.###t.###.t###d####",
    ".......###..###.####",
    ".d.d.d.###d.d.d.d.d.",
  },
},

WOLF_PACMAN_CORN_2 =
{
  copy="WOLF_PACMAN_BASE",

  structure =
  {
    "##########..####....",
    "t.d.d...d.d.####.d..",
    "t.###.d#########..##",
    "..###..#####.d.d.d##",
    "u.###d.d.d.d..######",
    "u.######..#####.d.d.",
    "..######m.d.###d####",
    "t.#########.###.####",
    "t.d.d.d.###d.d.d..##",
    "######..###.####d.##",
    "######d.d.d.####.d..",
    "##########..####..d.",
  },
},

WOLF_PACMAN_CORN_3 =
{
  copy="WOLF_PACMAN_BASE",

  structure =
  {
    "##########..####.##.",
    "u.d##d.d.d.d.d..d##d",
    "...##.........d#.##.",
    "d.d##d.######..#.d.d",
    "##.##..#tttt#.d##.##",
    "##.d.d.d.##t#..d.m##",
    "##.......##t#.d#####",
    "##d##d.#tttt#...d.d.",
    "d..##..######.d####d",
    "..d##d...........##.",
    "u..##..d.d.d.d.d.##d",
    "##########..####....",
  },
},


} -- PREFABS

