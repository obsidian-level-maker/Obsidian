----------------------------------------------------------------
-- GAME DEF : Hexen
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

HEXEN.FACTORY = {}

HEXEN.FACTORY.PREFABS =
{

-- Note: texture names (like STARTAN3) are never used here.
-- Instead the names here (like "beam_w") are looked-up in a
-- SKIN table.  This allows the same prefab to be used with
-- different textures (which are game-dependent).

PLAIN =
{
  scale=64,

  structure = { "." },

  elements = { },
},

PLAIN_BIG =
{
  scale=64,

  structure =
  {
    "..",
    "..",
  },
  
  elements = { },
},

SOLID =
{
  scale=64,

  structure = { "#" },

  elements = { },
},

SOLID_WIDE =
{
  scale=64,

  structure = { "##" },

  elements = { },
},

SOLID_BIG =
{
  scale=64,

  structure =
  {
    "##",
    "##",
  },

  elements = { },
},


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
    a = { f_h=0, c_rel="door_top", c_h=0, },
  },
},

ARCH_EDGE =
{
  copy="ARCH",

  mirror=true,

  structure =
  {
    "#aaa",
    "#aaa",
    "#aaa",
    "#aaa",
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
    a = { f_h=0, c_rel="door_top", c_h=0, },

    b = { copy="a", c_h=-16 },
    c = { copy="a", c_h=-32 },
  },
},

ARCH_HOLE1 =
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
    a = { f_h=0, c_rel="door_top", c_h=0, },

    b = { copy="a", f_h=12, c_h=-12 },
    c = { copy="a", f_h=24, c_h=-24 },
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
    a = { f_h=0, c_rel="door_top", c_h=0, },

    B = { f_rel="door_top", f_h=0, c_rel="door_top", c_h=0,
          l_tex="beam_w",  f_tex="beam_c",
        },

    C = { f_h=0, c_rel="door_top", c_h=-8,
          u_tex="beam_w",  c_tex="beam_c", u_peg="top",
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
    a = { f_h=0, c_rel="door_top", c_h=16, },

    s = { f_h=0, c_rel="door_top", c_h=0,
          u_tex="beam_w", c_tex="beam_c", u_peg="top"
        },

    B = { solid="beam_w" },
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
    a = { f_h=0, c_rel="door_top", c_h=0, },

    R = { solid="wall", [9]={ dx= 16,dy=0 }, [3]={ dx= 20,dy=0 } },
    S = { solid="wall", [7]={ dx=-16,dy=0 }, [1]={ dx=-20,dy=0 } },

    T = { solid="wall", [3]={ dx= 16,dy=0 } },
    U = { solid="wall", [1]={ dx=-16,dy=0 } },
  },
},


ARCH_FENCE =
{
  structure =
  {
    "fed......def",
    "fed......def",
    "fed......def",
    "fed......def",
  },

  elements =
  {
    c = { f_h= 8, f_rel="floor_h" },
    d = { f_h=16, f_rel="floor_h" },

    e = { f_h=32, f_rel="floor_h",
          [4] = { impassible=true },
          [6] = { impassible=true },
        },

    f = { f_h=0, f_rel="low_h", },

    B = { f_h=16, f_rel="low_h", f_add="beam_h",
          l_tex="beam_w", f_tex="beam_f", l_peg="top"
        },
  },
},

ARCH_FENCE_NARROW =
{
  copy="ARCH_FENCE",

  structure =
  {
    "fe....ef",
    "fe....ef",
    "fe....ef",
    "fe....ef",
  },
},

ARCH_FENCE_WIDE =
{
  copy="ARCH_FENCE",

  structure =
  {
    "feddcc........ccddef",
    "feddcc........ccddef",
    "feddcc........ccddef",
    "feddcc........ccddef",
  },
},

ARCH_WIRE_FENCE =
{
  copy="ARCH_FENCE",

  structure =
  {
    "f..........f",
    "BB........BB",
    "BB........BB",
    "f..........f",
  },
},

ARCH_WIRE_FENCE_NARROW =
{
  copy="ARCH_FENCE",

  structure =
  {
    "f......f",
    "BB....BB",
    "BB....BB",
    "f......f",
  },
},

ARCH_WIRE_FENCE_WIDE =
{
  copy="ARCH_FENCE",

  structure =
  {
    "f..................f",
    "BB................BB",
    "BB................BB",
    "f..................f",
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
    w = { f_h=0, f_rel="low_h", c_h=0, c_rel="high_h" },
  }
},

WINDOW_EDGE =
{
  mirror=true,

  structure =
  {
    "#www",
    "#www",
    "#www",
    "#www",
  },

  elements =
  {
    w = { f_h=0, f_rel="low_h", c_h=0, c_rel="high_h" },
  }
},

WINDOW_ARCHED =
{
  structure =
  {
    "#abwwba#",
    "#abwwba#",
    "#abwwba#",
    "#abwwba#",
  },

  elements =
  {
    w = { f_h=0, f_rel="low_h", c_h=0, c_rel="high_h" },

    a = { copy="w", f_h=12, c_h=-12 },
    b = { copy="w", f_h=24, c_h=-24 },
  }
},

WINDOW_ARCHED_BIG =
{
  copy="WINDOW_ARCHED",

  structure =
  {
    "#abbwwwwbba#",
    "#abbwwwwbba#",
    "#abbwwwwbba#",
    "#abbwwwwbba#",
  },
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
    w = { f_h=0, f_rel="low_h", c_h=0, c_rel="high_h" },

    a = { f_h=-32, f_rel="mid_h", c_h=32, c_rel="mid_h" },
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
    w = { f_h=0, f_rel="low_h", c_h=0, c_rel="high_h" },

    B = { solid="bar_w" },
  }
},

WINDOW_RAIL =
{
  structure =
  {
    "#wwwwwwwwww#",
    "#RRRRRRRRRR#",
    "#wwwwwwwwww#",
    "#wwwwwwwwww#",
  },

  elements =
  {
    w = { f_h=0, f_rel="low_h", c_h=0, c_rel="high_h" },

    R = { copy="w", mark=1,
          [2] = { rail="rail_w", l_peg="bottom", impassible=true } },
  }
},

WINDOW_RAIL_NARROW =
{
  copy="WINDOW_RAIL",

  structure =
  {
    "#wwwwww#",
    "#RRRRRR#",
    "#wwwwww#",
    "#wwwwww#",
  },
},

------ Doors ------------------------------------

DOOR =
{
  structure =
  {
    "##ssssssss##",
    "#TddddddddT#",
    "#TddddddddT#",
    "##ssssssss##",
  },

  elements =
  {
    -- steps
    s = { f_h=8, c_rel="floor_h", c_add="door_h", c_h=8,
          f_tex="frame_f", c_tex="frame_c", l_tex="step_w",
          l_peg="top",
        },

    -- door
    d = { f_h=8, c_rel="floor_h", c_h=8,
          f_tex="frame_f", c_tex="door_c",
          u_tex="door_w", u_peg="bottom", l_peg="bottom",
          kind="door_kind", tag="tag",
        },

    -- track
    T = { solid="track_w", l_peg="bottom" },
  },
},

DOOR_NARROW =
{
  copy="DOOR",

  structure =
  {
    "##ssss##",
    "#TddddT#",
    "#TddddT#",
    "##ssss##",
  },
},

DOOR_SUPER_NARROW =
{
  copy="DOOR",

  structure =
  {
    "#ss#",
    "TddT",
    "TddT",
    "#ss#",
  },

  elements =
  {
    -- steps
    s = { f_h=8, c_rel="floor_h", c_add="door_h", c_h=8,
          f_tex="frame_f", c_tex="frame_c", l_tex="step_w",
          l_peg="top",

          [1] = { dx=-12,dy=0 }, [3] = { dx=12,dy=0 },
          [7] = { dx=-12,dy=0 }, [9] = { dx=12,dy=0 },
        },

    -- door
    d = { f_h=8, c_rel="floor_h", c_h=8,
          f_tex="frame_f", c_tex="door_c",
          u_tex="door_w", u_peg="bottom", l_peg="bottom",
          kind="door_kind", tag="tag",
          [2] = { x_offset=4 }, [8] = { x_offset=4 },
        },

    -- track
    T = { solid="track_w", l_peg="bottom" },
  }
},

DOOR_LIT =
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
    s = { f_h=8, c_rel="floor_h", c_add="door_h", c_h=8,
          f_tex="frame_f", c_tex="frame_c", l_tex="step_w",
          l_peg="top",
          light=224
        },

    -- door
    d = { f_h=8, c_rel="floor_h", c_h=8,
          f_tex="frame_f", c_tex="door_c", u_tex="door_w",
          u_peg="bottom", l_peg="bottom",
          kind="door_kind", tag="tag",
          light=224
        },

    -- track
    T = { solid="track_w", l_peg="bottom" },

    -- lights
    L = { solid="wall", [6]={ l_tex="lite_w", l_peg="bottom" }},
    M = { solid="wall", [4]={ l_tex="lite_w", l_peg="bottom" }},
  },
},

DOOR_LIT_NARROW =
{
  copy="DOOR_LIT",

  structure =
  {
    "#LssssM#",
    "#TddddT#",
    "#TddddT#",
    "#LssssM#",
  },
},

DOOR_LIT_LOCKED =
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
    s = { f_h=8, c_rel="floor_h", c_add="door_h", c_h=8,
          f_tex="frame_f", c_tex="frame_c", l_tex="step_w",
          l_peg="top",
          light=224
        },

    -- door
    d = { f_h=8, c_rel="floor_h", c_h=8,
          f_tex="frame_f", c_tex="door_c", u_tex="door_w",
          u_peg="bottom", l_peg="bottom",
          kind="door_kind", tag="tag",
          light=224
        },

    -- track
    T = { solid="track_w", l_peg="bottom" },

    -- key
    K = { solid="key_w" },
  },
},

DOOR_WOLFY =
{
  structure =
  {
    "#TssssssssT#",
    "#TssssssssT#",
    "#TddddddddT#",
    "#TssssssssT#",
  },

  elements =
  {
    -- step
    s = { f_h=0, c_rel="floor_h", c_add="door_h", c_h=0,
          f_tex="frame_f", c_tex="frame_c", l_tex="step_w",
          l_peg="top",
        },

    -- door
    d = { f_h=0, c_rel="floor_h", c_h=0,
          f_tex="frame_f", c_tex="door_c",
          u_tex="door_w", u_peg="bottom", l_peg="bottom",
          kind="door_kind", tag="tag",

          [8] = { u_tex="back_w", u_peg="bottom" },

          [1] = { dx=0, dy=12 }, [7] = { dx=0, dy=4 },
          [3] = { dx=0, dy=12 }, [9] = { dx=0, dy=4 },
        },

    -- track
    T = { solid="track_w", l_peg="bottom" },
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
    s = { c_rel="door_top", c_h=0 },

    -- bars
    B = { f_rel="door_top", f_h=0, f_tex="bar_f",
          c_rel="door_top", c_h=0, c_tex="bar_f",
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

BARS_FENCE =
{
  structure =
  {
    "f..........f",
    "f.BB.BB.BB.f",
    "f.BB.BB.BB.f",
    "f..........f",
  },

  elements =
  {
    f = { f_h=0, f_rel="low_h", },

    B = { f_h=128, f_rel="floor_h",
          l_tex="beam_w", f_tex="beam_f", l_peg="top",
          kind="door_kind", tag="tag",
        },
  },
},

BARS_FENCE_DOOR =
{
  structure =
  {
    "f..........f",
    "f.DDDDDDDD.f",
    "f..........f",
    "f..........f",
  },

  elements =
  {
    f = { f_h=0, f_rel="low_h", },

    D = { f_h=128, f_rel="floor_h",
          l_tex="side_w", f_tex="door_f", l_peg="top",
          kind="door_kind", tag="tag",

          [2] = { l_tex="door_w" },
          [8] = { l_tex="door_w" },
        },
  },
},


------ Exit Stuff ------------------------------------

EXIT_DOOR =
{
  structure =
  {
    "#MssssL#",
    "#TddddT#",
    "#LssssM#",
    "##ssss##",
  },

  elements =
  {
    -- steps
    s = { f_h=8, c_rel="door_top", c_h=8,
          f_tex="frame_f", c_tex="frame_c", l_tex="step_w",
          l_peg="top", light=224
        },

    -- door
    d = { copy="s", c_rel="floor_h", c_h=8, u_tex="door_w", c_tex = "door_c",
          kind="door_kind", tag="tag", u_peg="bottom", l_peg="bottom"
        },

    -- sign
    X = { copy="s", u_tex="exit_w", c_rel="door_top", c_h=-8,
          c_tex="exit_c", u_peg="top",
          [4] = { x_offset=32 }, [6] = { x_offset=32 },
        },

    -- front sign
    F = { solid="front_w", l_peg="bottom" },

    -- track
    T = { solid="track_w", l_peg="bottom" },

    -- light
    L = { solid="wall", l_peg="bottom",
          [4] = { l_tex="door_w", x_offset=72 },
          [6] = { l_tex="door_w", x_offset=72 }
        },

    M = { solid="wall", l_peg="bottom",
          [4] = { l_tex="door_w", x_offset=88 },
          [6] = { l_tex="door_w", x_offset=88 }
        },
  },
},

EXIT_DOOR_WIDE =
{
  copy="EXIT_DOOR",

  structure =
  {
    "###MssssL###",
    "###TddddT###",
    "###LssssM###",
    "FFFFssssFFFF",
  },
},

EXIT_DOOR_W_SIGN =
{
  copy="EXIT_DOOR",

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
},

EXIT_SIGN_CEIL =
{
  region="ceil",
--  environment="indoor",
--  height_range={ 80,160 },

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
  region="floor",

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

EXIT_HOLE_ROUND =
{
  structure =
  {
    "............",
    "............",
    "............",
    "............",
    "....jihg....",
    "....kzzf....",
    "....mzze....",
    "....abcd....",
    "............",
    "............",
    "............",
    "............",
  },

  elements =
  {
    z = { f_tex="hole_f", f_h=-16, },

    a = { copy="z",
          [1] = { dx=-12, dy=-12 }, [7] = { dx=-24, dy=-8 },
          [2] = { x_offset=336 }, [4] = { x_offset=313 },
        },
    b = { copy="z",
          [1] = { dx=-8, dy=-24 },
          [2] = { x_offset=359 },
        },
    c = { copy="z",
          [1] = { dx=  0, dy=-29 },
          [2] = { x_offset=  0 },
        },

    d = { copy="z",
          [3] = { dx=12, dy=-12 }, [1] = { dx=8, dy=-24 },
          [6] = { x_offset= 48 }, [2] = { x_offset= 25 },
        },
    e = { copy="z",
          [3] = { dx=24, dy=-8 },
          [6] = { x_offset= 71 },
        },
    f = { copy="z",
          [3] = { dx=29, dy= 0 },
          [6] = { x_offset= 96 },
        },

    g = { copy="z",
          [9] = { dx=12, dy=12 }, [3] = { dx=24, dy=8 },
          [8] = { x_offset=144 }, [6] = { x_offset=121 },
        },
    h = { copy="z",
          [9] = { dx=8, dy=24 },
          [8] = { x_offset=167 },
        },
    i = { copy="z",
          [9] = { dx= 0, dy=29 },
          [8] = { x_offset=192 },
        },

    j = { copy="z",
          [7] = { dx=-12, dy=12 }, [9] = { dx=-8, dy=24 },
          [4] = { x_offset=240 }, [8] = { x_offset=217 },
        },
    k = { copy="z",
          [7] = { dx=-24, dy=8 },
          [4] = { x_offset=263 },
        },
    m = { copy="z",
          [7] = { dx=-29, dy= 0 },
          [4] = { x_offset=288 },
        },
  },
},

EXIT_DEATHMATCH =
{
  structure =
  {
    "############",
    "##iiWWWWii##",
    "##iiiiiiii##",
    "##iiiiiiii##",
    "##iiiiiiii##",
    "##iiiiiiii##",
    "##iiiiiiii##",
    "##iiiiiiii##",
    "##iiiiiiii##",
    "####ssss####",
    "###TddddT###",
    "FFFFssssFFFF",
  },

  elements =
  {
    -- inside area
    i = { f_h=0, c_rel="floor_h", c_add="inside_h", c_h=0, },

    -- step
    s = { f_h=8, c_rel="floor_h", c_add="door_h", c_h=8,
          f_tex="frame_f", c_tex="frame_c", l_tex="step_w",
          l_peg="top", light=224
        },

    -- front sign
    F = { solid="front_w", l_peg="bottom" },

    -- door
    d = { f_h=8, c_rel="floor_h", c_h=8,
          f_tex="frame_f", l_tex="step_w", l_peg="bottom",
          c_tex="door_c", u_tex="door_w",  u_peg="bottom",
          light=224, kind="door_kind", tag="tag",
        },

    -- track
    T = { solid="track_w", l_peg="bottom" },

    -- switch
    W = { copy="i", f_h=72, f_tex="switch_f",
          l_tex="side_w", l_peg="top",

          [2] = { l_tex="switch_w", l_peg="top", y_offset="switch_yo",
                  kind="switch_kind", tag="tag" },
        },
  },
},


------ Switches ------------------------------------

SWITCH_PILLAR =
{
  scale=64,
  add_mode="island",
--FIXME  height_range={ 128,384 },

  structure =
  {
    "P"
  },

  elements =
  {
    P = { solid="side_w",

          [2] = { l_tex="switch_w", l_peg="bottom", kind="kind", tag="tag" }
        },
  },
},

SWITCH_WIDE =
{
  scale=64,

  structure =
  {
    "ss"
  },

  elements =
  {
    s = { solid="wall",
          [2] = { l_tex="switch_w", l_peg="bottom", kind="kind", tag="tag" }
        },
  },
},

SWITCH_FLUSH =
{
  scale=64,

  structure =
  {
    "LsR"
  },

  elements =
  {
    s = { solid="wall",
          [2] = { l_tex="switch_w", l_peg="bottom", kind="kind", tag="tag" }
        },

    L = { solid="wall", [2] = { l_tex="left_w",  l_peg="bottom" }},
    R = { solid="wall", [2] = { l_tex="right_w", l_peg="bottom" }},
  },
},

SWITCH_FLOOR =
{
  region="floor",
--FIXME  height_range={ 96,999 },

  structure =
  {
    "....",
    "ssss",
    "....",
    "....",
  },

  elements =
  {
    s = { f_add="switch_h", f_h=0,
          l_tex="side_w", f_tex="switch_f", l_peg="top",

          [2] = { l_tex="switch_w", l_peg="top", kind="kind", tag="tag",
                  x_offset="x_offset", y_offset="y_offset"
                }
        },

    -- beam
    B = { f_add="switch_h", f_h=12,
          l_tex="beam_w", f_tex="beam_f", l_peg="top"
        },
  },
},

SWITCH_FLOOR_BEAM =
{
  copy="SWITCH_FLOOR",

  structure =
  {
    "........",
    ".BssssB.",
    "........",
    "........",
  },
},

SWITCH_FLOOR_TINY =
{
  region="floor",
--FIXME  height_range={ 64,512 },

  structure =
  {
    "....",
    ".ss.",
    "....",
    "....",
  },

  elements =
  {
    s = { f_add="switch_h", f_h=0,
          l_tex="side_w", f_tex="switch_f", l_peg="top",

          [2] = { l_tex="switch_w", l_peg="top", kind="kind", tag="tag",
                  x_offset="x_offset", y_offset="y_offset"
                }
        },
  },
},

SWITCH_FLOOR_TINY_PED =
{
  region="floor",
--FIXME  height_range={ 64,512 },

  structure =
  {
    "pppp",
    "pssp",
    "pppp",
    "....",
  },

  elements =
  {
    s = { f_h=20, f_add="switch_h",
          l_tex="side_w", f_tex="switch_f", l_peg="top",

          [2] = { l_tex="switch_w", l_peg="top", kind="kind", tag="tag",
                  x_offset="x_offset", y_offset="y_offset"
                },

        },

    p = { f_h=20,
          l_tex="ped_w", f_tex="ped_f", l_peg="top",
        }
  },
},

SWITCH_CEILING =
{
  add_mode="island",
--FIXME  height_range={ 96,256 },

  structure =
  {
    "bbbb",
    "ssss",
    "bbbb",
    "....",
  },

  elements =
  {
    s = { c_rel="floor_h", c_h=24, f_h=0,
          u_tex="side_w", c_tex="switch_c", u_peg="top",

          [2] = { u_tex="switch_w", u_peg="top", kind="kind", tag="tag",
                  x_offset="x_offset", y_offset="y_offset"
                }
        },

    -- beam coming down from ceiling
    b = { c_rel="floor_h", c_add="switch_h", c_h=24, f_h=0,
          c_tex="beam_c", u_tex="beam_w", u_peg="bottom",
        }
  },
},

SWITCH_NICHE =
{
  structure =
  {
    "########",
    "########",
    "##ssss##",
    "#LnnnnL#",
  },

  elements =
  {
    -- niche
    n = { f_h=0, c_rel="floor_h", c_add="switch_h", c_h=0,
          f_tex="frame_f", c_tex="frame_c",
          light=192
        },

    -- switch
    s = { solid="switch_w", l_peg="top",
          [2] = { kind="kind", tag="tag",
                  x_offset="x_offset", y_offset="y_offset"
                }
        },

    -- light
    L = { solid="wall", light=192,
          [4] = { l_tex="lite_w" },
          [6] = { l_tex="lite_w" },
        },
  },
},

SWITCH_NICHE_TINY =
{
  structure =
  {
    "####",
    "####",
    "#ss#",
    "LnnM",
  },

  elements =
  {
    -- niche
    n = { f_h=32, c_rel="floor_h", c_add="switch_h", c_h=32,
          f_tex="frame_f", c_tex="frame_c",
          [2] = { x_offset=16, l_peg="bottom", u_peg="top" },
        },

    -- switch
    s = { solid="switch_w", l_peg="top",
          [2] = { kind="kind", tag="tag",
                  x_offset="x_offset", y_offset="y_offset" }
        },

    -- sides
    L = { solid="wall", [6] = { l_tex="frame_w" },
          [2] = { x_offset=0, l_peg="top" }
        },
    M = { solid="wall", [4] = { l_tex="frame_w" },
          [2] = { x_offset=48, l_peg="top" }
        },
  },
},

SWITCH_NICHE_TINY_DEEP =
{
  copy="SWITCH_NICHE_TINY",

  structure =
  {
    "####",
    "#ss#",
    "LnnM",
    "LnnM",
  },
},

SWITCH_NICHE_HEXEN =
{
  structure =
  {
    "###ss###",
    "###nn###",
    "LLL..RRR",
    "........",
  },

  elements =
  {
    -- niche
    n = { f_h=32, c_rel="floor_h", c_add="switch_h", c_h=32,
          f_tex="frame_f", c_tex="frame_c",
        },

    -- switch
    s = { solid="wall",
          [2] = { kind="kind", tag="tag", l_tex="switch_w",
                  x_offset="x_offset", y_offset="y_offset" },

          [1] = { dx=0, dy=-8 },
          [3] = { dx=0, dy=-8 },
        },

    -- diagonals
    L = { solid="wall", mark=7, [3] = { VDEL=true }},
    R = { solid="wall", mark=8, [1] = { VDEL=true }},
  },
},


------ Wall Stuff ------------------------------------

WALL_LAMP_NARROW =
{
  structure =
  {
    "####",
    "#ii#",
    "#ii#",
    "#ii#",
  },

  elements =
  {
    i = { f_rel="low_h", f_h=0, c_rel="high_h", c_h=0,
          light=224
        },
  },

  things =
  {
    { kind="lamp_t", x = 32, y = 24 },
  },
},

WALL_LAMP =
{
  structure =
  {
    "########",
    "##iiii##",
    "##iiii##",
    "##iiii##",
  },

  elements =
  {
    i = { f_rel="low_h", f_h=0, c_rel="high_h", c_h=0,
          light=224
        },
  },

  things =
  {
    { kind="lamp_t", x = 64, y = 24 },
  },
},

WALL_PIC =
{
  structure =
  {
    "############",
    "##pppppppp##",
    "#LiiiiiiiiL#",
    "#LiiiiiiiiL#",
  },

  elements =
  {
    i = { f_rel="low_h", f_h=0, c_rel="low_h", c_h=0, c_add="pic_h",
          light=192,
        },

    p = { solid="pic_w" },

    L = { solid="wall",
          [4] = { l_tex="lite_w" }, 
          [6] = { l_tex="lite_w" }, 
        },
  },
},

WALL_PIC_SHALLOW =
{
  copy="WALL_PIC",

  structure =
  {
    "############",
    "############",
    "##pppppppp##",
    "#LiiiiiiiiL#",
  },
},

WALL_PIC_SCROLLER =
{
  structure =
  {
    "############",
    "############",
    "##pppppppp##",
    "##iiiiiiii##",
  },

  elements =
  {
    i = { f_rel="low_h", f_h=0, c_rel="low_h", c_h=0, c_add="pic_h",
          light=182,
        },

    p = { solid="pic_w", [2] = { kind="kind" } },
  },
},

WALL_PIC_NARROW =
{
  copy="WALL_PIC",

  structure =
  {
    "########",
    "########",
    "##pppp##",
    "#LiiiiL#",
  },
},

WALL_PIC_TWO_SIDED =
{
  copy="WALL_PIC",

  structure =
  {
    "#LiiiiiiiiL#",
    "##pppppppp##",
    "##pppppppp##",
    "#LiiiiiiiiL#",
  },
},

WALL_PIC_FOUR_SIDED =
{
  structure =
  {
    "#LiiiiiiiiL#",
    "MppppppppppM",
    "ippppppppppi",
    "ippppppppppi",
    "ippppppppppi",
    "ippppppppppi",
    "ippppppppppi",
    "ippppppppppi",
    "ippppppppppi",
    "ippppppppppi",
    "MppppppppppM",
    "#LiiiiiiiiL#",
  },

  elements =
  {
    i = { f_rel="high_h", f_h=-128, c_rel="high_h", c_h=0,
          light=192,
        },

    p = { solid="pic_w" },

    L = { solid="wall", [4] = { l_tex="lite_w" }, [6] = { l_tex="lite_w" }}, 
    M = { solid="wall", [2] = { l_tex="lite_w" }, [8] = { l_tex="lite_w" }}, 
  },
},

WALL_CROSS =
{
  structure =
  {
    "############",
    "############",
    "##BBBBBBBB##",
    "#LaaawwaaaL#",
  },

  elements =
  {
    B = { solid="back_w" },

    L = { solid="wall",
          [4]={ l_tex="cross_w" },
          [6]={ l_tex="cross_w" },
        },

    a = { f_h=-24, f_rel="mid_h", c_h=0, c_rel="mid_h",
          f_tex="cross_f", c_tex="cross_f",
          light="cross_lt", kind="kind",
          [4]={ l_tex="cross_w", u_tex="cross_w" },
          [6]={ l_tex="cross_w", u_tex="cross_w" },
        },

    w = { copy="a", f_h=-78, c_h=78 },
  }
},

WALL_LIGHTS_THIN =
{
  structure =
  {
    "########",
    "########",
    "##B##B##",
    "#LsRLsR#",
  },

  elements =
  {
    s = { f_h=0, f_rel="low_h", c_h=0, c_rel="high_h",
          f_tex="frame_f", c_tex="frame_f",
          light="wall_lt", kind="kind",
        },

    B = { solid="lite_w" },

    L = { solid="wall", [6] = { l_tex="lite_side" }},
    R = { solid="wall", [4] = { l_tex="lite_side" }},
  },
},

WALL_LIGHTS_WIDE =
{
  copy="WALL_LIGHTS_THIN",

  structure =
  {
    "############",
    "#BB##BB##BB#",
    "LssRLssRLssR",
    "LssRLssRLssR",
  },
},


FENCE_RAIL =
{
  structure =
  {
    "ffff",
    "RRRR",
    "ffff",
    "ffff",
  },

  elements =
  {
    f = { f_h=0, f_rel="low_h" },

    R = { copy="f", mark=2,
          [2] = { rail="rail_w", l_peg="bottom", impassible=true } },
  }
},

FENCE_BEAM_W_LAMP =
{
  structure =
  {
    "ffff",
    "BffB",
    "BffB",
    "ffff",
  },

  elements =
  {
    f = { f_h=0, f_rel="low_h" },

    B = { copy="f", f_h=0, f_add="beam_h",
          l_tex="beam_w", f_tex="beam_f", l_peg="top" },
  },

  things =
  {
    { kind="lamp_t", x=32, y=32 },
  },
},


------ Pickup & Players ------------------------------------

TECH_PICKUP_SMALL =
{
--  height_range={ 160,256 },

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
    a = { l_tex="step_w", light=128, c_h=-48, l_peg="top" },

    b = { copy="a", f_h= -8, c_h=-56 },
    c = { copy="a", f_h=-16, c_h=-64, light=192 },
    d = { copy="a", f_h=-24, c_h=-56 },

    e = { copy="a", f_h=-32, c_h=0, light=160, f_tex="carpet_f", c_tex="sky_c" },

    -- light
    L = { solid="lite_w" },
  },

  things =
  {
    { kind="pickup_spot", x=128, y=128 },
  },
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

  things =
  {
    { kind="pickup_spot", x=160, y=160 },
  },
},

LAUNCH_PAD_LARGE =
{
  region="floor",

  structure =
  {
    "........................",
    "........dddddddd........",
    "........bbbbbbbb........",
    "...OOOOOOOOOOOOOOOOOO...",
    "...OssssssssssssssssO...",
    "...OssssssssssssssssO...",
    "...OssssssssssssssssO...",
    "...OssssTssssssTssssO...",
    ".caOssssTssssssTssssOac.",
    ".caOssssTssssssTssssOac.",
    ".caOssssTssssssTssssOac.",
    ".caOssssTTTTTTTTssssOac.",
    ".caOssssTssssssTssssOac.",
    ".caOssssTssssssTssssOac.",
    ".caOssssTssssssTssssOac.",
    ".caOssssTssssssTssssOac.",
    "...OssssssssssssssssO...",
    "...OssssssssssssssssO...",
    "...OssssssssssssssssO...",
    "...OssssssssssssssssO...",
    "...OOOOOOOOOOOOOOOOOO...",
    "........bbbbbbbb........",
    "........dddddddd........",
    "........................",
  },

  elements =
  {
    s = { f_h=16, f_tex="pad_f" },
    T = { f_h=16, f_tex="letter_f" },

    O = { f_h=24, f_tex="outer_f", l_tex="outer_w", l_peg="top" },

    a = { f_h=16, f_tex="step_f", l_tex="side_w", l_peg="top",
          [4] = { l_tex="step_w" }, [6] = { l_tex="step_w" },
        },

    b = { f_h=16, f_tex="step_f", l_tex="side_w", l_peg="top",
          [2] = { l_tex="step_w" }, [8] = { l_tex="step_w" },
        },

    c = { copy="a", f_h=8 },
    d = { copy="b", f_h=8 },
  },

  things =
  {
    { kind="pickup_spot", x=192, y=192 },
  },
},

LAUNCH_PAD_MEDIUM =
{
  copy="LAUNCH_PAD_LARGE",

  structure =
  {
    "....................",
    ".......dddddd.......",
    ".......bbbbbb.......",
    "...OOOOOOOOOOOOOO...",
    "...OssssssssssssO...",
    "...OssssssssssssO...",
    ".caOssTTTTTTTTssOac.",
    ".caOssTsssssssssOac.",
    ".caOssTsssssssssOac.",
    ".caOssTsssssssssOac.",
    ".caOssTTTTTTTTssOac.",
    ".caOssTsssssssssOac.",
    ".caOssTsssssssssOac.",
    ".caOssTsssssssssOac.",
    "...OssssssssssssO...",
    "...OssssssssssssO...",
    "...OOOOOOOOOOOOOO...",
    ".......bbbbbb.......",
    ".......dddddd.......",
    "....................",
  },

  things =
  {
    { kind="pickup_spot", x=160, y=160 },
  },
},

LAUNCH_PAD_SMALL =
{
  copy="LAUNCH_PAD_LARGE",

  structure =
  {
    ".....dddddd.....",
    ".....bbbbbb.....",
    "..OOOOOOOOOOOO..",
    "..OssssssssssO..",
    "..OssTTTTTTssO..",
    "caOssTsssssssOac",
    "caOssTsssssssOac",
    "caOssTTTTTTssOac",
    "caOsssssssTssOac",
    "caOsssssssTssOac",
    "caOssTTTTTTssOac",
    "..OssssssssssO..",
    "..OssssssssssO..",
    "..OOOOOOOOOOOO..",
    ".....bbbbbb.....",
    ".....dddddd.....",
  },

  things =
  {
    { kind="pickup_spot", x=128, y=128 },
  },
},

LIQUID_PICKUP =
{
  structure =
  {
    "##ssssssssssss##",
    "##ssssssssssss##",
    "ssbLLLLccLLLLbss",
    "ssbbbbbccbbbbbss",
    "ssbLLLLccLLLLbss",
    "ssbbbbbccbbbbbss",
    "ssbLLLLccLLLLbss",
    "ssccccccccccccss",
    "ssccccccccccccss",
    "ssbLLLLccLLLLbss",
    "ssbbbbbccbbbbbss",
    "ssbLLLLccLLLLbss",
    "ssbbbbbccbbbbbss",
    "ssbLLLLccLLLLbss",
    "##ssssssssssss##",
    "##ssssssssssss##",
  },

  elements =
  {
    s = { f_h=16, c_h=-12 },

    c = { copy="s" },

    b = { copy="s", f_h=8 },

    L = { f_h= 0, f_tex="liquid_f", c_h=12, c_tex="sky_c",
          light=208,

          [1] = { dx=-4,dy=-4 }, [3] = { dx= 4,dy=-4 },
          [7] = { dx=-4,dy= 4 }, [9] = { dx= 4,dy= 4 },
        },
  },

  things =
  {
    { kind="pickup_spot", x=128, y=128 },
  },
},

PEDESTAL =
{
  scale=64,
  region="floor",

  structure =
  {
    "p",
  },

  elements =
  {
    p = { f_h=0, f_add="ped_h",
          f_tex = "ped_f", l_tex = "ped_side",
          l_peg = "top",
        }
  },
},

PEDESTAL_PLUT =
{
--  environment="outdoor",

  structure =
  {
    "pppp",
    "pppp",
    "pTpp",
    "pppp",
  },

  elements =
  {
    p = { f_h=16, f_tex="ped_f", l_tex="ped_w", l_peg="top",
          light=80,
        },

    T = { f_h=28, f_tex="ped_f2", l_tex="ped_w2", l_peg="top",

          light=255, kind="kind",

          [1] = { dx=16, dy=-6 },
          [3] = { dx=22, dy=16 },
          [7] = { dx=-6, dy= 0 },
          [9] = { dx= 0, dy=22 },
        },
  },
},

PEDESTAL_PLUT_DOUBLE =
{
  copy="PEDESTAL_PLUT",

--  environment="indoor",
--  height_range={ 112,999 },

  elements =
  {
    p = { f_h= 16, f_tex="ped_f", l_tex="ped_w", l_peg="top",
          c_h=-16, c_tex="ped_f", u_tex="ped_w", u_peg="bottom",
          light=80,
        },

    T = { f_h= 28, f_tex="ped_f2", l_tex="ped_w2", l_peg="top",
          c_h=-28, c_tex="ped_f2", u_tex="ped_w2", u_peg="bottom",

          light=255, kind="kind",

          [1] = { dx=16, dy=-6 },
          [3] = { dx=22, dy=16 },
          [7] = { dx=-6, dy= 0 },
          [9] = { dx= 0, dy=22 },
        },
  },

},


------ Decorative I ------------------------------------

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
    a = { f_h=8, c_rel="floor_h", c_h=256,
          l_tex="step_w", l_peg="top"
        },

    b = { f_h=16, c_rel="floor_h", c_h=192,
          l_tex="step_w", f_tex="carpet_f",
          u_tex="span_w", c_tex="lite_c",
          light=192
        },

    c = { f_h=64, c_rel="floor_h", c_h=256,
          f_tex="comp_f", l_tex="comp_w",
        },

    f = { copy="c", f_h=128, l_tex="comp2_w", x_offset=128 },

    g = { copy="c", f_h=192, l_tex="wall" },
  },

  things =
  {
    { kind="lamp_t", x = 96, y = 96 },
    { kind="lamp_t", x =224, y = 96 },
    { kind="lamp_t", x = 96, y =224 },
    { kind="lamp_t", x =224, y =224 },
  },
},

STATUE_TECH_2 =
{
  structure =
  {
    "................",
    ".OOOOOOOOOOOOOO.",
    ".OccccccccccccO.",
    ".OcccsssssscccO.",
    ".OcccsddddscccO.",
    ".OcsscaaaacsscO.",
    ".OcsdbMMMMbdscO.",
    ".OcsdbMMMMbdscO.",
    ".OcsdbMMMMbdscO.",
    ".OcsdbMMMMbdscO.",
    ".OcsscaaaacsscO.",
    ".OcccsddddscccO.",
    ".OcccsssssscccO.",
    ".OccccccccccccO.",
    ".OOOOOOOOOOOOOO.",
    "................",
  },

  elements =
  {
    O = { l_tex="outer_w", l_peg="top",
          u_tex="outer_w", u_peg="bottom",
        },

    c = { f_h=-8, c_h=8, f_tex="carpet_f", c_tex="lite_c",
          l_peg="top", light=208,
        },

    M = { copy="c", f_h=112, f_tex="tv_f", l_tex="tv_w",    
        },

    a = { copy="M", f_h=64, l_tex="span_w",
          [2]={ l_tex="tv_w", y_offset=23 },
          [8]={ l_tex="tv_w", y_offset=23 }
        },
    b = { copy="M", f_h=64, l_tex="span_w",
          [4]={ l_tex="tv_w", y_offset=23 },
          [6]={ l_tex="tv_w", y_offset=23 }
        },

    d = { copy="M", f_h=16, l_tex="span_w", f_tex="span_f" },
    s = { copy="M", f_h=8,  l_tex="span_w" },
  },
},

STATUE_TECH_JR =
{
  structure =
  {
    "............",
    "....dddd....",
    "..BjjjjjkB..",
    "..kmmmmmms..",
    ".csmLmmLmsc.",
    ".csmmTTmmsc.",
    ".csmmTTmmsc.",
    ".csmLmmLmsc.",
    "..smmmmmmk..",
    "..BkjjjjjB..",
    "....dddd....",
    "............",
  },

  elements =
  {
    -- inside
    m = { f_h=32, f_tex="tech_f", 
          c_h=0,  c_tex="tech_c",
          light="tech_lt", kind="kind"
        },
    
    T = { solid="tech_w" },
    
    L = { f_h=12, f_rel="mid_h", f_tex="lite_f",
          l_tex="lite_w", c_tex="tech_c",
          light="tech_lt"
        },

    -- outside
    B = { solid="beam_w" },

    k = { f_h= 64, f_tex="outer_f", l_tex="outer_w",
          c_h=-64, c_tex="outer_f", u_tex="outer_w",
          light="outer_lt",
        },

    j = { copy="k", [2] = { x_offset=16 }, [8] = { x_offset=16 }},
    s = { copy="k", [4] = { x_offset=16 }, [6] = { x_offset=16 }},

    -- shiny decoration
    c = { f_h= 16, f_tex="shine_f", l_tex="shine_w", l_peg="top",
          c_h=-16, c_tex="shine_f", u_tex="shine_w", u_peg="top",
          light="shine_lt",
          [2] = { l_tex="shine_side", u_tex="shine_side" },
          [8] = { l_tex="shine_side", u_tex="shine_side" },
        },
    d = { f_h= 16, f_tex="shine_f", l_tex="shine_w", l_peg="top",
          c_h=-16, c_tex="shine_f", u_tex="shine_w", u_peg="top",
          light="shine_lt",
          [4] = { l_tex="shine_side", u_tex="shine_side" },
          [6] = { l_tex="shine_side", u_tex="shine_side" },
        },
  },
},

STATUE_CHAIR_DUDE =
{
  region="floor",
--  height_range={ 136,999 },

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

MACHINE_PUMP =
{
  structure =
  {
    "ZZZZZZZZZZZZZZZZ",
    "ZZZZZZZZZZZZZZZZ",
    "ZZZZZZZZZZZZZZZZ",
    "ZbbbbbbccccddddZ",
    "ZbaaaabccccdLddZ",
    "ZbaPQabccccddddZ",
    "ZbaRSabccccddddZ",
    "ZbaaaabccccdLddZ",
    "ZbbbbbbccccddddZ",
    "ZZZZZZZZZZZZZZZZ",
    "ZZZZZZZZZZZZZZZZ",
    "ZZZZZZZZZZZZZZZZ",
  },

  elements =
  {
    -- outside
    Z = { f_h=0, c_rel="floor_h", c_h=216 },
    
    c = { f_h=112, c_rel="floor_h", c_h=176,
          f_tex="metal_f", l_tex="metal4_w", l_peg="top",
          c_tex="metal_c", u_tex="metal5_w", u_peg="bottom",
        },

    d = { copy="c", l_tex="metal3_w" },

    b = { copy="c", f_h=48, l_tex="metal4_w" },

    a = { copy="b", f_h=80, l_tex="metal5_w",
          c_rel="floor_h", c_h=144
        },

    -- supports
    L = { solid="beam_w" },

    -- pump
--- P = { f_h=56, c_h=-64,
---       f_tex="metal_f", l_tex="metal5_w", l_peg="top",
---       c_tex="pump_c",  u_tex="pump_w",   u_peg="bottom",
---       kind="tag",
---     },

    P = { solid="pump_w", [7] = { dx= 2, dy=-2 }, [9] = { dx= 0, dy= 4 },
          [8] = { x_offset= 64, kind="kind" },
          [4] = { x_offset= 80, kind="kind" },
        },
    Q = { solid="pump_w", [9] = { dx=-2, dy=-2 }, [3] = { dx= 4, dy= 0 },
          [6] = { x_offset= 32, kind="kind" },
          [8] = { x_offset= 48, kind="kind" },
        },
    R = { solid="pump_w", [7] = { dx=-4, dy= 0 }, [1] = { dx= 2, dy= 2 },
          [4] = { x_offset= 96, kind="kind" },
          [2] = { x_offset=112, kind="kind" },
        },
    S = { solid="pump_w", [1] = { dx= 0, dy=-4 }, [3] = { dx=-2, dy= 2 },
          [2] = { x_offset=  0, kind="kind" },
          [6] = { x_offset= 16, kind="kind" },
        },
  },
},


DRINKS_BAR =
{
  region="floor",

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
    { kind="drink_t", x= 16, y=32 },
    { kind="drink_t", x= 36, y=32 },
    { kind="drink_t", x= 56, y=32 },
    { kind="drink_t", x= 76, y=32 },
    { kind="drink_t", x= 96, y=32 },
    { kind="drink_t", x=116, y=32 },
    { kind="drink_t", x=136, y=32 },
    { kind="drink_t", x=156, y=32 },
    { kind="drink_t", x=176, y=32 },
  },
},

GROUND_LIGHT =
{
  region="floor",

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
    a = { f_h=0 },

    b = { f_h=8, l_tex="shawn_w", f_tex="shawn_f", l_peg="top", },

    c = { copy="b", f_h=40, light=192 },

    d = { f_h=64, l_tex="lite_w", f_tex="lite_f", light=200 },
  },
},

STREET_LAMP_TWO_SIDED =
{
  structure =
  {
    "........................",
    "........................",
    "........ttffffuu........",
    "...oggggffffffffggggp...",
    "..ogLLLLdddffcccLLLLgp..",
    "..ggLLLLeeeMMeeeLLLLgg..",
    "..ggLLLLeeeMMeeeLLLLgg..",
    "..mgLLLLbbbffaaaLLLLgn..",
    "...mggggffffffffggggn...",
    "........rrffffss........",
    "........................",
    "........................",
  },

  elements =
  {
    -- central pillar and arms
    M = { solid="beam_w" },

    f = { f_h =12, f_tex="arm_f", l_tex="arm_w",
          light=208,
        },

    r = { copy="f", mark=1, [1] = { VDEL=true }},
    s = { copy="f", mark=2, [3] = { VDEL=true }},
    t = { copy="f", mark=3, [7] = { VDEL=true }},
    u = { copy="f", mark=4, [9] = { VDEL=true }},

    e = { copy="f",
          c_h=-16, c_tex="arm_c", u_tex="arm_u", u_peg="bottom",
        },

    a = { copy="e", [1] = { VDEL=true }},
    b = { copy="e", [3] = { VDEL=true }},
    c = { copy="e", [7] = { VDEL=true }},
    d = { copy="e", [9] = { VDEL=true }},

    -- lights and glow
    L = { c_h=-40, c_tex="lite_c", u_tex="lite_w",
          light=255,
        },

    g = { light=255 },

    m = { copy="g", mark=1, [1]={ VDEL=true }},
    n = { copy="g", mark=2, [3]={ VDEL=true }},
    o = { copy="g", mark=3, [7]={ VDEL=true }},
    p = { copy="g", mark=4, [9]={ VDEL=true }},
  },
},


BOOKCASE_WIDE =
{
  scale=64,
  region="floor",

  structure =
  {
    "cc",
  },

  elements =
  {
    c = { f_h=128, f_tex="book_f", l_tex="side_w", l_peg="top",
          [2] = { l_tex="book_w" },
          [8] = { l_tex="book_w" },
        }
  },
},

FOUNTAIN_SQUARE =
{
  region="floor",

  structure =
  {
    "................",
    ".eeeeeeeeeeeeee.",
    ".eLLLLLLLLLLLLe.",
    ".eLLLLLLLLLLLLe.",
    ".eLLLLLLLLLLLLe.",
    ".eLLLLLLLLLLLLe.",
    ".eLLLLsFFsLLLLe.",
    ".eLLLLFppFLLLLe.",
    ".eLLLLFppFLLLLe.",
    ".eLLLLsFFsLLLLe.",
    ".eLLLLLLLLLLLLe.",
    ".eLLLLLLLLLLLLe.",
    ".eLLLLLLLLLLLLe.",
    ".eLLLLLLLLLLLLe.",
    ".eeeeeeeeeeeeee.",
    "................",
  },

  elements =
  {
    e = { f_h=28, f_tex="edge_f", l_tex="edge_w", l_peg="top" },
    p = { f_h=76, f_tex="beam_f", l_tex="beam_w", l_peg="top" },
    s = { copy="p", f_h=64 },

    L = { f_h=20, f_tex="liquid_f", l_tex="liquid_w" },
    F = { copy="L", f_h=56 },
  },
},


------ Ceiling Lights --------------------------------

SKYLIGHT_MEGA_1 =
{
  region="ceil",

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
    s = { c_h=12, c_tex="sky_c", light=192 },

    f = { c_h=-20, c_tex="frame_c", u_tex="frame_w" },

    B = { c_h=-4, c_tex="beam_c", u_tex="beam_w" },

    C = { copy="B", c_h=4 },
  },
},

SKYLIGHT_MEGA_2 =
{
  copy="SKYLIGHT_MEGA_1",

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

SKYLIGHT_MEGA_3 =
{
  copy="SKYLIGHT_MEGA_1",

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

SKYLIGHT_CROSS_SMALL =
{
  region="ceil",

  structure =
  {
    "fffffff.",
    "fffSfff.",
    "fffffff.",
    "fTfffUf.",
    "fffffff.",
    "fffXfff.",
    "fffffff.",
    "........",
  },

  elements =
  {
    f = { c_h=-8, c_tex="frame_c", u_tex="frame_w" },

--  B = { c_h=-4, c_tex="beam_c", u_tex="beam_w" },

    S = { c_h=8, c_tex="sky_c", light=208,
          [1] = { dx= 8, dy=-16 },
          [3] = { dx=24, dy=16 },
          [7] = { dx=-24,dy= 0 },
        },
    T = { c_h=8, c_tex="sky_c", light=208,
          [9] = { dx=16, dy=-8 },
          [3] = { dx=-16,dy=-24 },
          [7] = { dx= 0, dy=24 },
        },
    U = { c_h=8, c_tex="sky_c", light=208,
          [1] = { dx=-16,dy= 8 },
          [7] = { dx=16, dy=24 },
          [3] = { dx= 0, dy=-24 },
        },
    X = { c_h=8, c_tex="sky_c", light=208,
          [9] = { dx=-8, dy=16 },
          [7] = { dx=-24,dy=-16 },
          [3] = { dx=24, dy= 0 },
        },
  },
},

LIGHT_GROOVY =
{
  structure =
  {
    "..bmmmmmma..",
    "..mmtLLumm..",
    "..mmLLLLmm..",
    "..mtLLLLum..",
    "..mrLLLLsm..",
    "..mmLLLLmm..",
    "..mmLLLLmm..",
    "..mtLLLLum..",
    "..mrLLLLsm..",
    "..mmLLLLmm..",
    "..mmLLLLmm..",
    "..mtLLLLum..",
    "..mrLLLLsm..",
    "..mmLLLLmm..",
    "..mmrLLsmm..",
    "..dmmmmmmc..",
  },

  elements =
  {
    -- light area
    L = { c_h=0, c_tex="lite_c",
          light="lite_lt", kind="kind",
        },

    -- frame
    m = { c_h=-8, c_tex="frame_c", u_tex="frame_w", u_peg="top",
          light="frame_lt",
        },
 
    r = { copy="L", mark=1, [1] = { VDEL=true }},
    s = { copy="L", mark=2, [3] = { VDEL=true }},
    t = { copy="L", mark=3, [7] = { VDEL=true }},
    u = { copy="L", mark=4, [9] = { VDEL=true }},

    -- outside
    a = { [1] = { VDEL=true }},
    b = { [3] = { VDEL=true }},
    c = { [7] = { VDEL=true }},
    d = { [9] = { VDEL=true }},
  },
},


------ Decorative II ------------------------------------

BILLBOARD =
{
  structure =
  {
    "................",
    ".DCCssssssssCCE.",
    ".CCrpppppppprCC.",
    ".CCCssssssssCCC.",
  },

  elements =
  {
    -- corner
    C = { f_h=0, f_add="corn_h",
          l_tex="corn_w", f_tex="corn_f", l_peg="top", },

    D = { copy="C", mark=1, [7] = { VDEL=true }},
    E = { copy="C", mark=2, [9] = { VDEL=true }},

    -- pic
    r = { f_h=8, f_add="pic_h",
          l_tex="pic_back", f_tex="pic_f", l_peg="top",
        },

    p = { copy="r", [2] = { l_tex="pic_w" }},

    -- step
    s = { f_h=8, l_tex="step_w", f_tex="step_f", l_peg="top" },
  }
},

BILLBOARD_LIT =
{
  region="floor",

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
    E = { f_h=0, f_add="corn_h",
          l_tex="corn2_w", f_tex="corn_f", l_peg="top", },

    C = { copy="E",
          [4] = { l_tex="corn_w" },
          [8] = { l_tex="corn_w" },
        },

    D = { copy="E",
          [6] = { l_tex="corn_w" },
          [8] = { l_tex="corn_w" },
        },

    -- light
    L = { copy="E", [2] = { l_tex="lite_w" }, },

    -- pic
    p = { f_h=8, f_add="pic_h",
          l_tex="pic_back", [2] = { l_tex="pic_w" },
          f_tex="pic_f", l_peg="top",
        },

    -- step
    s = { f_h=8, l_tex="step_w", f_tex="step_f", l_peg="top" },

    t = { copy="s", f_h=16, light=208 },
  },
},

BILLBOARD_ON_STILTS =
{
  structure =
  {
    "............",
    ".CrrrrrrrrC.",
    ".BppppppppB.",
    "............",
  },

  elements =
  {
    -- picture
    p = { mark = 1,
          [8] = { rail="pic_w", l_peg="bottom",
                  x_offset=8, y_offset="pic_offset_h" },
        },

    r = { mark = 2, [2] = { x_offset=8 }},

    -- beams
    B = { f_add="pic_offset_h", f_h=140,
          l_tex="beam_w", f_tex="beam_f", l_peg="top",
        },

    C = { copy="B",
          [1] = { dx=-8, dy=0 },
          [3] = { dx= 8, dy=0 },
        },
  },
},

BILLBOARD_STILTS_HUGE =
{
  structure =
  {
    ".CrrrrrrrrC.",
    ".BppppppppB.",
    ".s.......s..",
    ".s.......s..",
    ".s.......s..",
    ".s.......s..",
    ".s.......s..",
    ".s.......s..",
    ".s.......s..",
    ".s.......s..",
    ".BqqqqqqqqB.",
    ".DrrrrrrrrD.",
  },

  elements =
  {
    -- picture
    p = { mark = 1,
          [8] = { rail="pic_w", l_peg="bottom",
                  x_offset=8, y_offset="pic_offset_h" },
        },

    q = { mark = 1,
          [2] = { rail="pic_w", l_peg="bottom",
                  x_offset=8, y_offset="pic_offset_h" },
        },

    r = { mark = 2,
          [2] = { x_offset=8 }, [8] = { x_offset=8 } },

    s = { mark = 3,
          [6] = { rail="pic_w", l_peg="bottom",
                  y_offset="pic_offset_h" },
        },

    -- beams
    B = { f_add="pic_offset_h", f_h=140,
          l_tex="beam_w", f_tex="beam_f", l_peg="top",
        },

    C = { copy="B",
          [1] = { dx=-8, dy=0 },
          [3] = { dx= 8, dy=0 },
        },

    D = { copy="B",
          [7] = { dx=-8, dy=0 },
          [9] = { dx= 8, dy=0 },
        },
  },

  things =
  {
    { kind="pickup_spot", x=96, y=96 },
  },
},

COMPUTER_TALL =
{
  scale=64,
  region="floor",

  structure =
  {
    "cc",
  },

  elements =
  {
    c = { f_h=80, f_tex="comp_f", l_tex="side_w", l_peg="top",
          [2] = { l_tex="comp_w" },
          [8] = { l_tex="comp_w" },
        }
  },
},

COMPUTER_TALL_THIN =
{
  copy="COMPUTER_TALL",

  scale=16,

  structure =
  {
    "cccccccc",
    "cccccccc",
    "........",
    "........",
  },
},

COMPUTER_DESK =
{
  scale=64,
  region="floor",

  structure =
  {
    "cc",
  },

  elements =
  {
    c = { f_h=28, f_tex="comp_f", l_tex="side_w", l_peg="top", }
  },
},

COMPUTER_DESK_U_SHAPE =
{
  scale=64,
  region="floor",

  structure =
  {
    "aa",
    ".b",
    "dd",
  },

  elements =
  {
    a = { f_h=28, f_tex="comp_Sf", l_tex="side_w", l_peg="top", },
    b = { f_h=28, f_tex="comp_Wf", l_tex="side_w", l_peg="top", },
    d = { f_h=28, f_tex="comp_Nf", l_tex="side_w", l_peg="top", },

    -- corner
    c = { f_h=28, f_tex="comp_cf", l_tex="side_w", l_peg="top", },
  },

  things =
  {
    { kind="pickup_spot", x=36, y=96 },
  },
},

COMPUTER_DESK_HUGE =
{
  copy="COMPUTER_DESK_U_SHAPE",

  structure =
  {
    "aac",
    "..b",
    "..b",
    "ddc",
  },

  things =
  {
    { kind="pickup_spot", x=80, y=128 },
  },
},

PENTAGRAM =
{
  region="floor",

  structure =
  {
    "............",
    "............",
    "............",
    "............",
    "....ttt.....",
    "....ttt.....",
    "..llppprr...",
    "....b.c.....",
    "....b.c.....",
    "............",
    "............",
    "............",
  },

  elements =
  {
    -- pentagram
    p = { f_add="gram_h", f_h=0,
          f_tex="gram_f", l_tex="gram_w", l_peg="top",
          light="gram_lt", kind="kind",
        },
 
    t = { copy="p",
          [7] = { dx= 22, dy= 32 },
          [9] = { dx=-22, dy= 32 },
          [1] = { dx= 12, dy= 12 },
          [3] = { dx=-12, dy= 12 },
        },

    l = { copy="p",
          [7] = { dx=-20, dy= 18 },
          [1] = { dx=-20, dy= 30 },
          [3] = { dx=  0, dy=  0 },
          [9] = { dx=  0, dy=  0 },
        },
 
    r = { copy="p",
          [9] = { dx= 20, dy= 18 },
          [3] = { dx= 20, dy= 30 },
          [1] = { dx=  0, dy=  0 },
          [7] = { dx=  0, dy=  0 },
        },
 
    b = { copy="p",
          [1] = { dx=-26, dy=-24 },
          [3] = { dx=-38, dy=-24 },
          [7] = { dx=  0, dy= -4 },
          [9] = { dx=  6, dy=-16 },
        },
 
    c = { copy="p",
          [3] = { dx= 26, dy=-24 },
          [1] = { dx= 38, dy=-24 },
          [9] = { dx=  0, dy= -4 },
          [7] = { dx= -6, dy=-16 },
        },
 
    -- outside
    x = { l_tex="outer_w" },
  },

  things =
  {
    { kind="gram_t", x=88,    y=88+54 },
    { kind="gram_t", x=88-54, y=88+18 },
    { kind="gram_t", x=88+54, y=88+18 },
    { kind="gram_t", x=88-32, y=88-40 },
    { kind="gram_t", x=88+32, y=88-40 },
  },
},


------ Nature Stuff ----------------------------------

POND_LARGE =
{
  region="floor",

  structure =
  {
    "xxxxxxxxxxxxxxxxxxxxxxxx",
    "xxxxxxxxxxxxxxxxxxxxxxxx",
    "xxxxxxxxxxxcccddxxxxxxxx",
    "xxxxxcccppppppppdxxxxxxx",
    "xxxxcbbwwwwwwwwwapddxxxx",
    "xxxcbwwwwwwwwwwwwwwadxxx",
    "xxcbwwwccppwwwwwwwwwadxx",
    "xcpwwwwpppbwwwwwwwwwwadx",
    "xcpwwwwwwwwwwwwwwwwwwwdx",
    "xapwwwwwwwwwwwwwwwwwwwpx",
    "xxawwwwwwccddwwwwwwwwwcx",
    "xxadwwwcppppppdwwwwwcpcx",
    "xxxapppbbxxxxxaaapppbbxx",
    "xxxxabcxxxxxxxxxxxxxxxxx",
    "xxxxxxxxxxxxxxxxxxxxxxxx",
    "xxxxxxxxxxxxxxxxxxxxxxxx",
  },
 
  elements =
  {
    -- pool boundary
    p = { f_h=-14, f_tex="pond_f", l_tex="pond_w", l_peg="top" },

    a = { copy="p", mark=1, [1] = { VDEL=true }},
    b = { copy="p", mark=2, [3] = { VDEL=true }},
    c = { copy="p", mark=3, [7] = { VDEL=true }},
    d = { copy="p", mark=4, [9] = { VDEL=true }},

    -- water
    w = { f_h=-24, f_tex="liquid_f", light=192, kind="kind" },

    -- outside area
    x = { l_tex="outer_w", l_peg="top" },
  },

  --FIXME: pickup spot (on island)
},

POND_SMALL =
{
  region="floor",

  structure =
  {
    "xxxxxxxxxxxx",
    "xxccppddxxxx",
    "xcbwwwwappdx",
    "xpwwwwwwwwpx",
    "xpwwwwwwwwpx",
    "xppdwccddwbx",
    "xaxaapppppbx",
    "xxxxxxxxxxxx",
  },

  elements =
  {
    -- water
    w = { f_h=-16, f_tex="liquid_f", light=192, kind="kind" },

    -- pool boundary
    p = { f_h=-9, f_tex="pond_f", l_tex="pond_w", l_peg="top" },

    a = { copy="p", mark=1, [1] = { VDEL=true }},
    b = { copy="p", mark=2, [3] = { VDEL=true }},
    c = { copy="p", mark=3, [7] = { VDEL=true }},
    d = { copy="p", mark=4, [9] = { VDEL=true }},

    -- outside area
    x = { l_tex="outer_w", l_peg="top" },
  },
},

POND_MEDIUM =
{
  region="floor",

  structure =
  {
    "xxxxxxxxxxxxxxxx",
    "xxxxxgssssshhxxx",
    "xxxggsppppppshxx",
    "xsssspbwwwwasshx",
    "xessspwwwwwapphx",
    "xxesspwwwwwwwpsx",
    "xxxespwwwwwwwpsx",
    "xxxespddwwwccpsx",
    "xxxxeespppppsffx",
    "xxxxxxeessssfxxx",
    "xxxxxxxxxxxxxxxx",
    "xxxxxxxxxxxxxxxx",
  },

  elements =
  {
    -- water
    w = { f_h=-22, f_tex="liquid_f", light=192, kind="kind" },

    -- pool inner
    p = { f_h=-16, f_tex="pond_f", l_tex="pond_w", l_peg="top" },

    a = { copy="p", mark=1, [1] = { VDEL=true }},
    b = { copy="p", mark=2, [3] = { VDEL=true }},
    c = { copy="p", mark=3, [7] = { VDEL=true }},
    d = { copy="p", mark=4, [9] = { VDEL=true }},

    -- pool outer
    s = { f_h=-8, f_tex="pond_f2", l_tex="pond_w2", l_peg="top" },

    e = { copy="s", mark=5, [1] = { VDEL=true }},
    f = { copy="s", mark=6, [3] = { VDEL=true }},
    g = { copy="s", mark=7, [7] = { VDEL=true }},
    h = { copy="s", mark=8, [9] = { VDEL=true }},

    -- outside area
    x = { l_tex="outer_w", l_peg="top" },
  },
},

ROCK_PIECES =
{
  structure =
  {
    "xxxxxxxxxxxx",
    "xxxxxxxxxxxx",
    "xxxxxxxxxxxx",
    "xxxxxxxmxnxx",
    "xxxxxxxmxnxx",
    "xxxxhhxjepxx",
    "xccceexjepxx",
    "xccceexjekkx",
    "xxxxbbxjekkx",
    "xxxxbbxxxxxx",
    "xxxxxxxxxxxx",
    "xxxxxxxxxxxx",
  },

  elements =
  {
    x = { l_tex="outer_w" },
    
    e = { f_h=0, f_add="rock_h", f_tex="rock_f", l_tex="rock_w" },

    b = { copy="e",
          [1] = { dx=-40, dy= 44 }, [3] = { dx=-56, dy=  8 },
          [7] = { dx= -8, dy= 26 }, [9] = { dx=-24, dy=-16 },
        },

    c = { copy="e",
          [1] = { dx= 24, dy= 72 }, [7] = { dx= 56, dy= 86 },
        },

    h = { copy="e",
          [1] = { dx= 24, dy= 22 }, [3] = { dx=-20, dy=-18 },
          [7] = { dx= 40, dy=  6 }, [9] = { dx= 00, dy=-10 },
        },

    j = { copy="e",
          [1] = { dx= -4, dy= 24 }, [7] = { dx= 24, dy=  8 },
          [3] = { dx=-20, dy=  4 },
        },

    k = { copy="e",
          [1] = { dx= -8, dy=  0 }, [3] = { dx=-26, dy=-10 },
          [7] = { dx= -4, dy=  8 }, [9] = { dx= -6, dy=-24 },
        },

    m = { copy="e",
          [1] = { dx= 00, dy= 00 }, [3] = { dx= 26, dy= -6 },
          [7] = { dx= 56, dy= -8 }, [9] = { dx= 40, dy=-24 },
        },

    n = { copy="e",
          [1] = { dx= 14, dy=-12 }, [3] = { dx= 00, dy= 00 },
          [7] = { dx= 44, dy=-24 }, [9] = { dx= 24, dy=-38 },
        },

    p = { copy="e",
          [3] = { dx= 00, dy= 00 }, [9] = { dx= 00, dy=-30 },
        },
  },
},

--[[
ROCK_VOLCANO =
{
  structure =
  {
    "..wwhzppzz..",
    ".wwwhzzzzzz.",
    "wwffkwwwwizz",
    "wkkkeyyyywwz",
    "wkkkeyyyywwz",
    "gwkyyxccydwz",
    "gwwyaxxxxdwz",
    ".jjeaxxxyyh.",
    ".jjeyybbywh.",
    ".njjjooyyw..",
    ".zzzzzzzzz..",
    "...zzzzmm...",
  },

  elements =
  {
    x = { f_h=248, f_tex="rock_f", l_tex="rock_w" },

    y = { copy="x", f_h=192, f_tex="liquid_f" },

    w = { copy="y", f_h=120 },
    k = { copy="y", f_h=160 },
    j = { copy="y", f_h=96  },
    z = { copy="y", f_h=64  },

    a = { copy="x", l_tex="liquid_w" },
    b = { copy="x", l_tex="liquid_w", [3] = { VDEL=true }},
    c = { copy="x", l_tex="liquid_w", [9] = { VDEL=true }},

    d = { copy="y", l_tex="liquid_w" },
    e = { copy="y", l_tex="liquid_w" },
    o = { copy="y", l_tex="liquid_w" },
    f = { copy="k", l_tex="liquid_w", [7] = { VDEL=true }},

    g = { copy="w", l_tex="liquid_w", [1] = { dx=0, dy=12 }},
    i = { copy="w", l_tex="liquid_w", [9] = { VDEL=true }},
    h = { copy="w", [6] = { l_tex="liquid_w" }},

    m = { copy="z", [2] = { l_tex="liquid_w" }, [3] = { dx=-8, dy=0 }},
    p = { copy="z", l_tex="liquid_w" },

    n = { copy="j", l_tex="liquid_w", [1] = { VDEL=true }},
  },

---    a = { copy="x", [4] = { l_tex="liquid_w" }},
---    b = { copy="x", [2] = { l_tex="liquid_w" }},
---    c = { copy="x", [8] = { l_tex="liquid_w" }},
---
---    d = { copy="y", [6] = { l_tex="liquid_w" }},
---    e = { copy="y", [4] = { l_tex="liquid_w" }},
---    o = { copy="y", [2] = { l_tex="liquid_w" }},
---    f = { copy="k", [8] = { l_tex="liquid_w" }},
---
---    g = { copy="w", [4] = { l_tex="liquid_w" }},
---    i = { copy="w", [8] = { l_tex="liquid_w" }, [6] = { l_tex="liquid_w" }},
},
--]]

STALAGMITE =
{
  structure =
  {
    "........",
    ".jjjjjk.",
    ".mdbbbk.",
    ".md##ck.",
    ".meeeck.",
    ".mnnnnn.",
    "........",
    "........",
  },

  elements =
  {
    -- inside column (# = WALL)

    -- middle column
    b = { f_h=36, c_h=-56, l_peg="top", c_peg="bottom",
          [1] = { dx = -2, dy =  0 },
          [7] = { dx =  8, dy =  0 },
          [9] = { dx = -6, dy = -6 },
          [3] = { dx = 00, dy = 00 },
        },
    c = { f_h=36, c_h=-56, l_peg="top", c_peg="bottom",
          [1] = { dx = 00, dy = 00 },
          [7] = { dx =  2, dy = -6 },
          [9] = { dx =  0, dy = -8 },
          [3] = { dx = -8, dy =  4 },
        },
    d = { f_h=36, c_h=-56, l_peg="top", c_peg="bottom",
          [1] = { dx =  0, dy =  8 },
          [7] = { dx =  2, dy = -6 },
          [9] = { dx = 00, dy = 00 },
          [3] = { dx =  0, dy =  6 },
        },
    e = { f_h=36, c_h=-56, l_peg="top", c_peg="bottom",
          [1] = { dx = 10, dy =  4 },
          [7] = { dx = 00, dy = 00 },
          [9] = { dx = -4, dy =  0 },
          [3] = { dx = -8, dy =  0 },
        },
    
    -- outer column
    j = { f_h=16, c_h=-24, l_peg="top", c_peg="bottom",
          [1] = { dx = 00, dy = 00 },
          [7] = { dx =  8, dy = -8 },
          [9] = { dx =-24, dy =  0 },
          [3] = { dx = 00, dy = 00 },
        },
    k = { f_h=16, c_h=-24, l_peg="top", c_peg="bottom",
          [1] = { dx = 00, dy = 00 },
          [7] = { dx = 00, dy = 00 },
          [9] = { dx =-12, dy =-10 },
          [3] = { dx =  0, dy = 24 },
        },
    m = { f_h=16, c_h=-24, l_peg="top", c_peg="bottom",
          [1] = { dx =  6, dy = 12 },
          [7] = { dx =  0, dy =-24 },
          [9] = { dx = 00, dy = 00 },
          [3] = { dx = 00, dy = 00 },
        },
    n = { f_h=16, c_h=-24, l_peg="top", c_peg="bottom",
          [1] = { dx = 24, dy =  0 },
          [7] = { dx = 00, dy = 00 },
          [9] = { dx = 00, dy = 00 },
          [3] = { dx = -6, dy = 12 },
        },
  },
},

STALAGMITE_HUGE =
{
  structure =
  {
    "................",
    ".jjjjjjkkkkkkkk.",
    ".jjooooooooookk.",
    ".jjoddddffffokk.",
    ".jjoddeeeeffokk.",
    ".hhocce##effokk.",
    ".hhocceeeebbogg.",
    ".hhoccccbbbbogg.",
    ".hhoooooooooogg.",
    ".hhhhhhhhgggggg.",
    "................",
    "................",
  },

  elements =
  {
    e = { f_rel="mid_h", c_rel="mid_h", f_h=-16, c_h=16 },

    b = { f_rel="mid_h", c_rel="mid_h", f_h=-32, c_h=32,
          [1] = { dx=1* -2, dy=1* -8 },
          [7] = { dx=1*  8, dy=1* -4 },
          [9] = { dx=1*  6, dy=1* 10 },
          [3] = { dx=1* -4, dy=1*  6 },
        },
    c = { f_rel="mid_h", c_rel="mid_h", f_h=-32, c_h=32,
          [1] = { dx=0*  8, dy=0*  6 },
          [7] = { dx=0*  6, dy=0*  4 },
          [9] = { dx=0*  4, dy=0* -8 },
          [3] = { dx=0* -8, dy=0* -4 },
        },
    d = { f_rel="mid_h", c_rel="mid_h", f_h=-32, c_h=32,
          [1] = { dx=1* -2, dy=1* -2 },
          [7] = { dx=1* -4, dy=1*-10 },
          [9] = { dx=1*  0, dy=1* -6 },
          [3] = { dx=1*  8, dy=1*  4 },
        },
    f = { f_rel="mid_h", c_rel="mid_h", f_h=-32, c_h=32,
          [1] = { dx=0* -6, dy=0*  8 },
          [7] = { dx=0*  4, dy=0*  2 },
          [9] = { dx=0*  8, dy=0* -4 },
          [3] = { dx=0* -8, dy=0*  6 },
        },

    o = { f_rel="mid_h", c_rel="mid_h", f_h=-48, c_h=48 },

    g = { f_rel="mid_h", c_rel="mid_h", f_h=-64, c_h=64,
          [1] = { dx=0*  2, dy=0*-10 },
          [7] = { dx=0* -6, dy=0*  8 },
          [9] = { dx=0*  6, dy=0* -8 },
          [3] = { dx=0*  4, dy=0*  6 },
        },
    h = { f_rel="mid_h", c_rel="mid_h", f_h=-64, c_h=64,
          [1] = { dx=1*  2, dy=1* -8 },
          [7] = { dx=1* -8, dy=1*  6 },
          [9] = { dx=1* -2, dy=1*  0 },
          [3] = { dx=1*  6, dy=1*-20 },
        },
    j = { f_rel="mid_h", c_rel="mid_h", f_h=-64, c_h=64,
          [1] = { dx=0* -4, dy=0* -6 },
          [7] = { dx=1*  0, dy=1*-10 },
          [9] = { dx=0* -8, dy=0*  8 },
          [3] = { dx=0* 10, dy=0*  2 },
        },
    k = { f_rel="mid_h", c_rel="mid_h", f_h=-64, c_h=64,
          [1] = { dx=1* -6, dy=1* -8 },
          [7] = { dx=1*  6, dy=1*  2 },
          [9] = { dx=1*-10, dy=1*-10 },
          [3] = { dx=1*  4, dy=1* -4 },
        },
  },
},

CAVE_IN_SMALL =
{
  structure =
  {
    ".qq...rrr...",
    ".qq.ctrrr...",
    "qqq.sttttd..",
    "....sttttsss",
    "..cssttccsss",
    ".csssssssuuu",
    "ssssuuuusuuc",
    "sttadduusuuc",
    "stttssssssss",
    "sttcsbttssb.",
    "aasssttx.ab.",
    "..mmmdtx....",
  },

  elements =
  {
    -- sky
    s = { c_h=16, c_tex="sky_c", light=192 },

    a = { copy="s", [1] = { VDEL=true }},
    b = { copy="s", [3] = { VDEL=true }},
    c = { copy="s", [7] = { VDEL=true }},
    d = { copy="s", [9] = { VDEL=true }},

    m = { copy="s", [1] = { dx=20, dy=8 }},

    -- rocks
    r = { f_h=10, f_tex="rock_f", l_tex="rock_w" },
    q = { copy="r", f_h=8, [1]={ dx=0, dy=8 } },

    t = { copy="r", c_h=16, c_tex="sky_c", light=192 },
    u = { copy="t", f_h=6 },

    x = { copy="r", [7] = { VDEL=true }},
  },
},

LEAKAGE_POOL =
{
  structure =
  {
    "................",
    "................",
    "................",
    "......twwu......",
    ".....twwwwu.....",
    ".....twwwwwu....",
    "....twohhpwwuu..",
    ".twwwwhcdhwwww..",
    ".wwwwwhabhwws...",
    "....rwmhhnws....",
    ".....wwwwws.....",
    ".....rrwww......",
    ".......wwww.....",
    ".......rwws.....",
    "........rw......",
    "................",
  },

  elements =
  {
    -- pool
    w = { f_h=-12, f_tex="liquid_f", l_tex="liquid_w",
          light=192, kind="kind",
        },

    r = { copy="w", mark=1, [1]={ VDEL=true }},
    s = { copy="w", mark=2, [3]={ VDEL=true }},
    t = { copy="w", mark=3, [7]={ VDEL=true }},
    u = { copy="w", mark=4, [9]={ VDEL=true }},

    -- pipe
    h = { copy="w", c_rel="floor_h", c_h=116 },

    m = { copy="h", mark=1, [1]={ VDEL=true }},
    n = { copy="h", mark=2, [3]={ VDEL=true }},
    o = { copy="h", mark=3, [7]={ VDEL=true }},
    p = { copy="h", mark=4, [9]={ VDEL=true }},

    -- failing liquid
    a = { copy="h", mark=5,
          [2] = { rail="liquid_w", x_offset=84 },
          [4] = { rail="liquid_w", x_offset=72 },
          [1]={ dx=4,dy=4 },
        },
    b = { copy="h", mark=6,
          [2] = { rail="liquid_w", x_offset=0 },
          [6] = { rail="liquid_w", x_offset=12 },
          [3]={ dx=-4,dy=4 },
        },
    c = { copy="h", mark=7,
          [8] = { rail="liquid_w", x_offset=48 },
          [4] = { rail="liquid_w", x_offset=60 },
          [7]={ dx=4,dy=-4 },
        },
    d = { copy="h", mark=8,
          [8] = { rail="liquid_w", x_offset=36 },
          [6] = { rail="liquid_w", x_offset=24 },
          [9]={ dx=-4,dy=-4 },
        },
  },
},

PUMP_INTO_VAT =
{
  structure =
  {
    "............",
    "..CCZZZZDD..",
    ".CBwwwwwwAD.",
    ".CwwwwwwwwD.",
    ".ZwwohhpwwZ.",
    ".ZwwhcdhwwZ.",
    ".ZwwhabhwwZ.",
    ".ZwwmhhnwwZ.",
    ".AwwwwwwwwB.",
    ".ADwwwwwwCB.",
    "..AAZZZZBB..",
    "............",
  },

  elements =
  {
    -- vat
    Z = { f_h=26, f_tex="vat_f", l_tex="vat_w", l_peg="top" },

    A = { copy="Z", mark=1, [1]={ VDEL=true }},
    B = { copy="Z", mark=2, [3]={ VDEL=true }},
    C = { copy="Z", mark=3, [7]={ VDEL=true }},
    D = { copy="Z", mark=4, [9]={ VDEL=true }},

    -- pool
    w = { f_h=16, f_tex="liquid_f", l_tex="liquid_w", kind="kind" },

    r = { copy="w", mark=1, [1]={ VDEL=true }},
    s = { copy="w", mark=2, [3]={ VDEL=true }},
    t = { copy="w", mark=3, [7]={ VDEL=true }},
    u = { copy="w", mark=4, [9]={ VDEL=true }},

    -- hose
    h = { copy="w", c_rel="floor_h", c_h=136,
          c_tex="hose_c", u_tex="hose_w", u_peg="bottom",
        },

    m = { copy="h", mark=1, [1]={ VDEL=true }},
    n = { copy="h", mark=2, [3]={ VDEL=true }},
    o = { copy="h", mark=3, [7]={ VDEL=true }},
    p = { copy="h", mark=4, [9]={ VDEL=true }},

    -- failing liquid
    a = { copy="h", mark=5,
          [2] = { rail="liquid_w", x_offset=84 },
          [4] = { rail="liquid_w", x_offset=72 },
          [1]={ dx=4,dy=4 },
        },
    b = { copy="h", mark=6,
          [2] = { rail="liquid_w", x_offset=0 },
          [6] = { rail="liquid_w", x_offset=12 },
          [3]={ dx=-4,dy=4 },
        },
    c = { copy="h", mark=7,
          [8] = { rail="liquid_w", x_offset=48 },
          [4] = { rail="liquid_w", x_offset=60 },
          [7]={ dx=4,dy=-4 },
        },
    d = { copy="h", mark=8,
          [8] = { rail="liquid_w", x_offset=36 },
          [6] = { rail="liquid_w", x_offset=24 },
          [9]={ dx=-4,dy=-4 },
        },
  },
},


------ Crates ------------------------------------

CRATE =
{
  scale=64,
  region="floor",

  structure =
  {
    "c"
  },

  elements =
  {
    c = { f_add="crate_h", f_h=0,
          f_tex="crate_f", l_tex="crate_w", l_peg="top" },
  },
},

CRATE_LONG =
{
  copy="CRATE",

  structure =
  {
    "cc",
  },
},

CRATE_BIG =
{
  copy="CRATE",

  structure =
  {
    "cc",
    "cc",
  },
},

CRATE_TWO_SIDED =
{
  copy="CRATE",

  elements =
  {
    c = { f_add="crate_h", f_h=0,
          f_tex="crate_f", l_tex="crate_w", l_peg="top",
          [4] = { l_tex="crate_w2", x_offset="x_offset" },
          [6] = { l_tex="crate_w2", x_offset="x_offset" },
        },
  },
},

CRATE_ROTATE_NARROW =
{
  structure =
  {
    "....",
    "....",
    ".c..",
    "....",
  },

  elements =
  {
    c = { f_add="crate_h", f_h=0,
          f_tex="crate_f", l_tex="crate_w", l_peg="top",

          [1] = { dx=-14, dy= 16 },
          [3] = { dx=  0, dy=-14 },
          [9] = { dx= 30, dy=  0 },
          [7] = { dx= 16, dy= 30 },

          [2] = { x_offset=10 }, [4] = { x_offset=10 },
          [6] = { x_offset=10 }, [8] = { x_offset=10 },
        },
  },
},

CRATE_ROTATE =
{
  structure =
  {
    "........",
    "........",
    "........",
    "........",
    "...c....",
    "........",
    "........",
    "........",
  },

  elements =
  {
    c = { f_add="crate_h", f_h=0,
          f_tex="crate_f", l_tex="crate_w", l_peg="top",

          [1] = { dx=-29, dy= 16 },
          [3] = { dx=  0, dy=-29 },
          [9] = { dx= 45, dy=  0 },
          [7] = { dx= 16, dy= 45 },
        },
  },
},

CRATE_ROTATE_22DEG =
{
  structure =
  {
    "........",
    "........",
    "........",
    "........",
    "...c....",
    "........",
    "........",
    "........",
  },

  elements =
  {
    c = { f_add="crate_h", f_h=0,
          f_tex="crate_f", l_tex="crate_w", l_peg="top",

          [1] = { dx=-24, dy=  0 },
          [3] = { dx= 19, dy=-24 },
          [9] = { dx= 43, dy= 19 },
          [7] = { dx=  0, dy= 43 },
        },
  },
},

CRATE_TRIPLE =
{
  structure =
  {
    "aaaacccc",
    "aaaacccc",
    "aaaacccc",
    "aaaaccdd",
    "bbbfee..",
    "bbbfee..",
    "bbbb....",
    "bbbb....",
  },

  elements =
  {
    a = { f_h=128, f_tex="crate_f1", l_tex="crate_w1", l_peg="top" },
    b = { f_h=64,  f_tex="crate_f2", l_tex="crate_w2", l_peg="top" },
    c = { f_h=64,  f_tex="crate_f3", l_tex="crate_w3", l_peg="top" },

    e = { f_h=32,  f_tex="small_f",  l_tex="small_w",  l_peg="top" },

    d = { copy="c", [2] = { x_offset=32 }},
    f = { copy="b", [6] = { x_offset=32 }},
  },
},

CRATE_JUMBLE =
{
  scale=64,

  structure =
  {
    ".Cd..",
    "BCTWX",
    "BTB.d",
    "eWe..",
    ".X...",
  },

  elements =
  {
    T = { f_h=192, f_tex="tall_f", l_tex="tall_w", l_peg="top" },
    W = { f_h=128, f_tex="wide_f", l_tex="wide_w", l_peg="top", [6] = { x_offset=64 } },
    X = { copy="W", [2] = { x_offset=64 }, [4] = { x_offset=64 }, [6] = {} },

    B = { f_h=128, f_tex="crate_f1", l_tex="crate_w1", l_peg="top" },
    C = { f_h=128, f_tex="crate_f2", l_tex="crate_w2", l_peg="top" },

    d = { f_h=64,  f_tex="crate_f1", l_tex="crate_w1", l_peg="top" },
    e = { f_h=64,  f_tex="crate_f2", l_tex="crate_w2", l_peg="top" },
  },
},


------ Cages ------------------------------------

CAGE_PILLAR =
{
  scale=64,

  structure = { "c" },

  elements =
  {
    c = { f_rel="cage_base_h", f_h=0, f_tex="cage_f", l_tex="cage_w",
          c_rel="cage_base_h", c_h=0, c_add="rail_h",
          c_tex="cage_c", u_tex="cage_w",
          u_peg="bottom", l_peg="bottom",

          [2] = { rail="rail_w", impassible=true },
          [4] = { rail="rail_w", impassible=true },
          [6] = { rail="rail_w", impassible=true },
          [8] = { rail="rail_w", impassible=true },
        },
  },

  things =
  {
    { kind="cage_spot", x=32, y=32 },
  },
},

CAGE_SMALL =
{
  scale=64,

  structure = { "c" },

  elements =
  {
    c = { f_rel="cage_base_h", f_h=0,
          f_tex="cage_f", l_tex="cage_w", l_peg="bottom",

          [2] = { rail="rail_w", impassible=true },
          [4] = { rail="rail_w", impassible=true },
          [6] = { rail="rail_w", impassible=true },
          [8] = { rail="rail_w", impassible=true },
        },
  },

  things =
  {
    { kind="cage_spot", x=32, y=32 },
  },
},

CAGE_MEDIUM =
{
  copy="CAGE_SMALL",

  structure =
  {
    "cc",
    "cc",
  },

  things =
  {
    { kind="cage_spot", x=32, y=32, double=true, },
  },
},

CAGE_LARGE =
{
  copy="CAGE_SMALL",

  structure =
  {
    "ccc",
    "ccc",
    "ccc",
  },

  things =
  {
    { kind="cage_spot", x=64, y=64, double=true },
  },
},

CAGE_OPEN_W_POSTS =
{
  region="floor",

  structure =
  {
    "OOccccccccPP",
    "OBddddddddBP",
    "cfccccccccgc",
    "cfccccccccgc",
    "cfccccccccgc",
    "cfccccccccgc",
    "cfccccccccgc",
    "cfccccccccgc",
    "cfccccccccgc",
    "cfccccccccgc",
    "MBeeeeeeeeBN",
    "MMccccccccNN",
  },

  elements =
  {
    -- posts
    B = { f_add="rail_h", f_h=56,
          l_tex="beam_w", f_tex="beam_f",
        },

    M = { copy="B",
          [1] = { dx= 8, dy= 8 },
          [7] = { dx= 8, dy= 0 },
          [3] = { dx= 0, dy= 8 },
        },
    N = { copy="B",
          [3] = { dx=-8, dy= 8 },
          [9] = { dx=-8, dy= 0 },
          [1] = { dx= 0, dy= 8 },
        },
    O = { copy="B",
          [7] = { dx= 8, dy=-8 },
          [1] = { dx= 8, dy= 0 },
          [9] = { dx= 0, dy=-8 },
        },
    P = { copy="B",
          [9] = { dx=-8, dy=-8 },
          [3] = { dx=-8, dy= 0 },
          [7] = { dx= 0, dy=-8 },
        },

    -- cage area
    c = { f_h=48, l_tex="cage_w", f_tex="cage_f",
        },
    
    -- grating
    d = { copy="c", mark=1,
          [8] = { rail="rail_w", l_peg="bottom", impassible=true },
          [7] = { dx=0, dy=-4 }, [9] = { dx=0, dy=-4 },
        },
    e = { copy="c", mark=1,
          [2] = { rail="rail_w", l_peg="bottom", impassible=true },
          [1] = { dx=0, dy=4 }, [3] = { dx=0, dy=4 },
        },
    f = { copy="c", mark=1,
          [4] = { rail="rail_w", l_peg="bottom", impassible=true },
          [1] = { dx=4, dy=0 }, [7] = { dx=4, dy=0 },
        },
    g = { copy="c", mark=1,
          [6] = { rail="rail_w", l_peg="bottom", impassible=true },
          [3] = { dx=-4, dy=0 }, [9] = { dx=-4, dy=0 },
        },
  },

  things =
  {
    { kind="cage_spot", x=64, y=64, double=true },
  },
},

CAGE_LARGE_W_LIQUID =
{
  scale=64,

  structure =
  {
    "MNNNO",
    "PLaLQ",
    "PcedQ",
    "PLbLQ",
    "STTTU",
  },

  elements =
  {
    -- liquid
    L = { f_h=-56, f_tex="liquid_f" },

    N = { copy="L", [8] = { rail="rail_w", impassible=true } },
    P = { copy="L", [4] = { rail="rail_w", impassible=true } },
    Q = { copy="L", [6] = { rail="rail_w", impassible=true } },
    T = { copy="L", [2] = { rail="rail_w", impassible=true } },

    M = { [2] = { rail="rail_w", impassible=true },
          [6] = { rail="rail_w", impassible=true },
          [3] = { VDEL=true }
        },
    O = { [2] = { rail="rail_w", impassible=true },
          [4] = { rail="rail_w", impassible=true },
          [1] = { VDEL=true }
        },
    S = { [8] = { rail="rail_w", impassible=true },
          [6] = { rail="rail_w", impassible=true },
          [9] = { VDEL=true }
        },
    U = { [8] = { rail="rail_w", impassible=true },
          [4] = { rail="rail_w", impassible=true },
          [7] = { VDEL=true }
        },

    -- pillar
    e = { f_h=168, f_tex="cage_f", l_tex="cage_w", l_peg="top" },

    a = { copy="e", f_h=104, [8] = { l_tex="cage_sign_w" },
          [7] = { dx=0,dy=-32 }, [9] = { dx=0,dy=-32 } },

    b = { copy="e", f_h=104, [2] = { l_tex="cage_sign_w" },
          [1] = { dx=0,dy= 32 }, [3] = { dx=0,dy= 32 } },

    c = { copy="e", f_h=104, [4] = { l_tex="cage_sign_w" },
          [1] = { dx= 32,dy=0 }, [7] = { dx= 32,dy=0 } },

    d = { copy="e", f_h=104, [6] = { l_tex="cage_sign_w" },
          [3] = { dx=-32,dy=0 }, [9] = { dx=-32,dy=0 } },
  },

  things =
  {
    { kind="cage_spot", x=160, y=160 },
  },
},

CAGE_MEDIUM_W_LIQUID =
{
  scale=64,

  structure =
  {
    "MNNO",
    "PeeQ",
    "PeeQ",
    "STTU",
  },

  elements =
  {
    -- liquid
    L = { f_h=-32, f_tex="liquid_f" },

    N = { copy="L", [8] = { rail="rail_w", impassible=true } },
    P = { copy="L", [4] = { rail="rail_w", impassible=true } },
    Q = { copy="L", [6] = { rail="rail_w", impassible=true } },
    T = { copy="L", [2] = { rail="rail_w", impassible=true } },

    M = { copy="P", [8] = { rail="rail_w", impassible=true } },
    O = { copy="Q", [8] = { rail="rail_w", impassible=true } },
    S = { copy="P", [2] = { rail="rail_w", impassible=true } },
    U = { copy="Q", [2] = { rail="rail_w", impassible=true } },

    -- central pillar
    e = { f_h=96, f_tex="cage_f", l_tex="cage_w", l_peg="top" },
  },

  things =
  {
    { kind="cage_spot", x=96, y=96, double=true },
  },
},

CAGE_NICHE =
{
  structure =
  {
    "########",
    "#cccccc#",
    "#cccccc#",
    "#cccccc#",
    "#cccccc#",
    "#cccccc#",
    "#cccccc#",
    "#cccccc#",
  },

  elements =
  {
    c = { f_rel="low_h", f_h=0,
          c_rel="low_h", c_h=0, c_add="rail_h",
          l_peg="bottom", u_peg="bottom",

          [2] = { rail="rail_w", impassible=true },
        },
  },

  things =
  {
    { kind="cage_spot", x=64, y=64 },
  },
},


------ Corners ------------------------------------

CORNER_BEAM =
{
  add_mode="corner",

  structure =
  {
    "BB..",
    "BB..",
    "....",
    "....",
  },

  elements =
  {
    B = { solid="beam_w" }
  },
},

CORNER_LIGHT =
{
  add_mode="corner",
  environment="indoor",

  structure =
  {
    "BBB.",
    "BLs.",
    "Bss.",
    "....",
  },

  elements =
  {
    B = { solid="beam_w"  },
    L = { solid="lite_w" },

    s = { f_h=16, c_h=-16, l_tex="beam_w", u_tex="beam_w",
          f_tex="beam_f", c_tex="beam_f",
          light=192
        }
  },
},

CORNER_DIAGONAL =
{
  add_mode="corner",

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
  add_mode="corner",

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
  add_mode="corner",

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
  add_mode="corner",

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

PILLAR =
{
  scale=64,

  structure = { "P" },

  elements =
  {
    P = { solid="wall", l_peg="bottom" }
  },
},

PILLAR_WIDE =
{
  copy="PILLAR",

  structure =
  {
    "PP",
    "PP",
  },
},

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
    B = { solid="beam_w"  },
    L = { solid="lite_w" },

    s = { f_h=16, c_h=-16, l_tex="beam_w", u_tex="beam_w",
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
    L = { solid="lite_w" },

    p = { f_h=48, c_h=-48, light=192, }
  },
},

PILLAR_ROUND_SMALL =
{
  structure =
  {
    "....",
    ".ab.",
    ".cd.",
    "....",
  },

  elements =
  {
    a = { solid="wall", [7] = { dx=-6, dy= 6 }, [9] = { dx= 0, dy=14 },
          [8] = { x_offset= 96 }, [4] = { x_offset=120 },
        },
    b = { solid="wall", [9] = { dx= 6, dy= 6 }, [3] = { dx=14, dy= 0 },
          [6] = { x_offset= 48 }, [8] = { x_offset= 72 },
        },
    c = { solid="wall", [7] = { dx=-14,dy= 0 }, [1] = { dx=-6, dy=-6 },
          [4] = { x_offset=144 }, [2] = { x_offset=168 },
        },
    d = { solid="wall", [1] = { dx= 0, dy=-14}, [3] = { dx= 6, dy=-6 },
          [2] = { x_offset=  0 }, [6] = { x_offset= 24 },
        },
  },
},

PILLAR_ROUND_MEDIUM =
{
  structure =
  {
    "........",
    "........",
    "..jihg..",
    "..k##f..",
    "..m##e..",
    "..abcd..",
    "........",
    "........",
  },

  elements =
  {
    a = { solid="wall",
          [1] = { dx=-12, dy=-12 }, [7] = { dx=-24, dy=-8 },
          [2] = { x_offset=336 }, [4] = { x_offset=313 },
        },
    b = { solid="wall",
          [1] = { dx=-8, dy=-24 },
          [2] = { x_offset=359 },
        },
    c = { solid="wall",
          [1] = { dx=  0, dy=-29 },
          [2] = { x_offset=  0 },
        },

    d = { solid="wall",
          [3] = { dx=12, dy=-12 }, [1] = { dx=8, dy=-24 },
          [6] = { x_offset= 48 }, [2] = { x_offset= 25 },
        },
    e = { solid="wall",
          [3] = { dx=24, dy=-8 },
          [6] = { x_offset= 71 },
        },
    f = { solid="wall",
          [3] = { dx=29, dy= 0 },
          [6] = { x_offset= 96 },
        },

    g = { solid="wall",
          [9] = { dx=12, dy=12 }, [3] = { dx=24, dy=8 },
          [8] = { x_offset=144 }, [6] = { x_offset=121 },
        },
    h = { solid="wall",
          [9] = { dx=8, dy=24 },
          [8] = { x_offset=167 },
        },
    i = { solid="wall",
          [9] = { dx= 0, dy=29 },
          [8] = { x_offset=192 },
        },

    j = { solid="wall",
          [7] = { dx=-12, dy=12 }, [9] = { dx=-8, dy=24 },
          [4] = { x_offset=240 }, [8] = { x_offset=217 },
        },
    k = { solid="wall",
          [7] = { dx=-24, dy=8 },
          [4] = { x_offset=263 },
        },
    m = { solid="wall",
          [7] = { dx=-29, dy= 0 },
          [4] = { x_offset=288 },
        },
  },
},

PILLAR_ROUND_LARGE =
{
  structure =
  {
    "............",
    "............",
    "............",
    "............",
    "....jihg....",
    "....k##f....",
    "....m##e....",
    "....abcd....",
    "............",
    "............",
    "............",
    "............",
  },

  elements =
  {
    a = { solid="wall",
          [1] = { dx=-26, dy=-26 }, [7] = { dx=-42, dy=-16 },
          [2] = { x_offset=448 }, [4] = { x_offset=417 },
        },
    b = { solid="wall",
          [1] = { dx=-16, dy=-42 },
          [2] = { x_offset=479 },
        },
    c = { solid="wall",
          [1] = { dx=  0, dy=-49 },
          [2] = { x_offset=  0 },
        },

    d = { solid="wall",
          [3] = { dx=26, dy=-26 }, [1] = { dx=16, dy=-42 },
          [6] = { x_offset= 64 }, [2] = { x_offset= 33 },
        },
    e = { solid="wall",
          [3] = { dx=42, dy=-16 },
          [6] = { x_offset= 95 },
        },
    f = { solid="wall",
          [3] = { dx=49, dy= 0 },
          [6] = { x_offset=128 },
        },

    g = { solid="wall",
          [9] = { dx=26, dy=26 }, [3] = { dx=42, dy=16 },
          [8] = { x_offset=192 }, [6] = { x_offset=161 },
        },
    h = { solid="wall",
          [9] = { dx=16, dy=42 },
          [8] = { x_offset=223 },
        },
    i = { solid="wall",
          [9] = { dx= 0, dy=49 },
          [8] = { x_offset=256 },
        },

    j = { solid="wall",
          [7] = { dx=-26, dy=26 }, [9] = { dx=-16, dy=42 },
          [4] = { x_offset=320 }, [8] = { x_offset=289 },
        },
    k = { solid="wall",
          [7] = { dx=-42, dy=16 },
          [4] = { x_offset=351 },
        },
    m = { solid="wall",
          [7] = { dx=-49, dy= 0 },
          [4] = { x_offset=384 },
        },
  },
},

PILLAR_DOUBLE_TECH_LARGE =
{
  structure =
  {
    "........................",
    ".oaaaaaaaap..oaaaaaaaap.",
    ".aatbbbbuaa..aatbbbbuaa.",
    ".atbddddbuaaaatbddddbua.",
    ".abceffecbbbbbbceffecba.",
    ".abcfLLfcbbbbbbcfLLfcba.",
    ".abcfLLfcbbbbbbcfLLfcba.",
    ".abceffecbbbbbbceffecba.",
    ".arbddddbsaaaarbddddbsa.",
    ".aarbbbbsaa..aarbbbbsaa.",
    ".maaaaaaaan..maaaaaaaan.",
    "........................",
  },

  elements =
  {
    -- outer base
    a = { f_h= 8, f_tex="outer_f", l_tex="outer_w",
          c_h=-8, c_tex="outer_f", u_tex="outer_w",
          light="outer_lt",
        },

    m = { copy="a", mark=1, [1] = { VDEL=true }},
    n = { copy="a", mark=2, [3] = { VDEL=true }},
    o = { copy="a", mark=3, [7] = { VDEL=true }},
    p = { copy="a", mark=4, [9] = { VDEL=true }},

    -- inner base
    b = { f_h= 16, f_tex="inner_f", l_tex="inner_w",
          c_h=-16, c_tex="inner_f", u_tex="inner_w",
          light="inner_lt",
        },

    r = { copy="b", mark=1, [1] = { VDEL=true }},
    s = { copy="b", mark=2, [3] = { VDEL=true }},
    t = { copy="b", mark=3, [7] = { VDEL=true }},
    u = { copy="b", mark=4, [9] = { VDEL=true }},

    -- shiny decoration
    c = { f_h= 32, f_tex="shine_f", l_tex="shine_w", l_peg="top",
          c_h=-32, c_tex="shine_f", u_tex="shine_w", u_peg="top",
          light="shine_lt",
          [2] = { l_tex="shine_side", u_tex="shine_side" },
          [8] = { l_tex="shine_side", u_tex="shine_side" },
        },
    d = { f_h= 32, f_tex="shine_f", l_tex="shine_w", l_peg="top",
          c_h=-32, c_tex="shine_f", u_tex="shine_w", u_peg="top",
          light="shine_lt",
          [4] = { l_tex="shine_side", u_tex="shine_side" },
          [6] = { l_tex="shine_side", u_tex="shine_side" },
        },

    -- pillars
    e = { solid="pillar_w" },
    L = { solid="light_w"  },

    f = { f_h= 48, f_tex="pillar_f", l_tex="pillar_w", l_peg="bottom",
          c_h=-48, c_tex="pillar_f", u_tex="pillar_w", u_peg="top",
          light="pillar_lt", kind="kind",
        },
  },

  -- FIXME: spot for thing
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
    P = { solid="beam_w" }, 

    o = { c_h=-24, c_tex="hang_c", u_tex="hang_u",
          u_peg="top", light_add = -32,
        },
  },
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
},


------ Doom and Doom II -------------------------------

DOOM2_667_END_SWITCH =
{
  region="floor",

  structure =
  {
    "................",
    ".RRRRRRRRRRRRRR.",
    ".RnnnnnnnnnnnnR.",
    ".RnnnnnnnnnnnnR.",
    ".RnnnnnnnnnnnnR.",
    ".RnnnnnnnnnnnnR.",
    ".RnnnnSSSSnnnnR.",
    ".RnnnnSSSSnnnnR.",
    ".RnnnnSSSSnnnnR.",
    ".RnnnnSSSSnnnnR.",
    ".RnnnnnnnnnnnnR.",
    ".RnnnnnnnnnnnnR.",
    ".RnnnnnnnnnnnnR.",
    ".RnnnnnnnnnnnnR.",
    ".RRRRRRRRRRRRRR.",
    "................",
  },

  elements =
  {
    n = { f_h=32 },

    -- Raising part
    R = { f_h=-6, kind="kind", tag="tag" },

    -- Switch
    S = { f_h=96, f_tex="switch_f", l_tex="switch_w",
          l_peg="top", y_offset="y_offset",
        }
  },
},


------ Heretic and Hexen -------------------------------

HEXEN_V_TELEPORT =
{
  structure =
  {
    "............",
    "..WWWWZZZZ..",
    "..WWWWZZZZ..",
    "..WWWWZZZZ..",
    "..WWWWZZZZ..",
    "..WWxxxxZZ..",
    "..WWxxxxZZ..",
    "..WWttttZZ..",
    "..WWssssZZ..",
    "............",
    "............",
    "............",
  },

  elements =
  {
    s = { f_h=16, c_rel="floor_h", c_h=144, light=200,
          f_tex="frame_f", c_tex="frame_c",
          l_tex="frame_w", u_tex="frame_w",
          l_peg="bottom", u_peg="top",
        },

    t = { copy="s", mark=1,
          [7] = { dx=0, dy=-12 },
          [9] = { dx=0, dy=-12 },
          [2] = { rail="border_w", l_peg="bottom", },
          [8] = { rail="telep_w",  l_peg="bottom", },
        },

    x = { copy="s", light=0,
          [2] = { kind="kind", tag="tag" },
        },

    W = { solid="frame_w", [7] = { dx= 48, dy=0 }},
    Z = { solid="frame_w", [9] = { dx=-48, dy=0 }},
  },
},

HEXEN_TRIPLE_PED =
{
  scale=64,
  region="floor",

  structure =
  {
    "p.p",
    "...",
    ".p.",
  },

  elements =
  {
    p = { f_h=0, f_add="ped_h",
          f_tex="ped_f", l_tex="ped_w", l_peg="top",
        }
  },

  things =
  {
    { kind="item_F_t", x=96,  y=96  },
    { kind="item_C_t", x=32,  y=160 },
    { kind="item_M_t", x=160, y=160 },
  },
},


------ Wolfenstein ------------------------------------

WOLF_ELEVATOR =
{
  scale=64,

  structure =
  {
    "#####",
    "##E##",
    "#E.E#",
    "#FdF#",
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
    "###ddd..GGtt.GGG..ddd###",
    "######d.GGttt.GG.d######",
    "######..GGtutt....######",
    "######d.GGtutt...d######",
    "######..GGttt.GG..######",
    "###dddd.GGtt.GGG.dddd###",
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
    "####...d....##m.....",
    ".d.d.d####d.##..d.d.",
    ".........#..d.d.####",
    "d.#####..#####..d.d.",
    "..###..d..d.##......",
    "m.###d.###..###d####",
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
    "..d.d...d.d.####.d..",
    "..###.d#########..##",
    "d.###..#####.d.d.d##",
    "..###d.d.d.d..######",
    "m.######..#####md.d.",
    "..######..d.###d####",
    "d.#########.###.####",
    "..d.d.d.###d.d.d..##",
    "######..###.####..##",
    "######d.d.d.####.d..",
    "##########..####....",
  },
},

WOLF_PACMAN_CORN_3 =
{
  copy="WOLF_PACMAN_BASE",

  structure =
  {
    "##########..####.##.",
    "#####..d.d.d.d..d##d",
    "#####.........d#.##.",
    "#####.d######..#.d.d",
    "#d.##....d.m#.d#..##",
    "...d...####.#....d##",
    ".....d.####.#.d#####",
    "#d.##....d.m#...d.d.",
    "#####.d######.d####d",
    "#####............##.",
    "#####..d.d.d.d.d.##d",
    "##########..####....",
  },
},


} -- HEXEN.FACTORY.PREFABS

HEXEN.FACTORY.XN_THINGS =
{
  --- PLAYERS ---

  player1 = { id=1, kind="other", r=16,h=64 },
  player2 = { id=2, kind="other", r=16,h=64 },
  player3 = { id=3, kind="other", r=16,h=64 },
  player4 = { id=4, kind="other", r=16,h=64 },

  dm_player     = { id=11, kind="other", r=16,h=64 },
  teleport_spot = { id=14, kind="other", r=16,h=64 },
  
  --- MONSTERS ---

  ettin    = { id=10030,kind="monster", r=24,h=64 },
  afrit    = { id=10060,kind="monster", r=24,h=64 },
  demon1   = { id=31,   kind="monster", r=33,h=70 },
  demon2   = { id=8080, kind="monster", r=33,h=70 },

  wendigo  = { id=8020, kind="monster", r=24,h=80 },
  centaur1 = { id=107,  kind="monster", r=20,h=64 },
  centaur2 = { id=115,  kind="monster", r=20,h=64 },

  stalker1  = { id=121,  kind="monster", r=33,h=64 },
  stalker2  = { id=120,  kind="monster", r=33,h=64 },
  bishop    = { id=114,  kind="monster", r=24,h=64 },
  reiver    = { id=34,   kind="monster", r=24,h=64 },
  reiver_bd = { id=10011,kind="monster", r=24,h=64 },
  wyvern    = { id=254,  kind="monster", r=20,h=66 },

  heresiarch   = { id=10080, kind="monster", r=40,h=120 },
  fighter_boss = { id=10100, kind="monster", r=16,h=64  },
  cleric_boss  = { id=10101, kind="monster", r=16,h=64  },
  mage_boss    = { id=10102, kind="monster", r=16,h=64  },
  korax        = { id=10200, kind="monster", r=66,h=120 },

  --- PICKUPS ---

  -- keys --
  k_steel   = { id=8030, kind="pickup", r=8,h=16 },
  k_cave    = { id=8031, kind="pickup", r=8,h=16 },
  k_axe     = { id=8032, kind="pickup", r=8,h=16 },
  k_fire    = { id=8033, kind="pickup", r=8,h=16 },
  k_emerald = { id=8034, kind="pickup", r=8,h=16 },
  k_dungeon = { id=8035, kind="pickup", r=8,h=16 },
  k_silver  = { id=8036, kind="pickup", r=8,h=16 },
  k_rusty   = { id=8037, kind="pickup", r=8,h=16 },
  k_horn    = { id=8038, kind="pickup", r=8,h=16 },
  k_swamp   = { id=8039, kind="pickup", r=8,h=16 },
  k_castle  = { id=8200, kind="pickup", r=8,h=16 },
 
  -- weapons --
  c_staff   = { id=10,  kind="pickup", r=20,h=16 },
  c_fire    = { id=8009,kind="pickup", r=20,h=16 },
  c1_shaft  = { id=20,  kind="pickup", r=20,h=16 },
  c2_cross  = { id=19,  kind="pickup", r=20,h=16 },
  c3_arc    = { id=18,  kind="pickup", r=20,h=16 },

  f_axe     = { id=8010,kind="pickup", r=20,h=16 },
  f_hammer  = { id=123, kind="pickup", r=20,h=16 },
  f1_hilt   = { id=16,  kind="pickup", r=20,h=16 },
  f2_cross  = { id=13,  kind="pickup", r=20,h=16 },
  f3_blade  = { id=12,  kind="pickup", r=20,h=16 },

  m_cone    = { id=53,  kind="pickup", r=20,h=16 },
  m_blitz   = { id=8040,kind="pickup", r=20,h=16 },
  m1_stick  = { id=23,  kind="pickup", r=20,h=16 },
  m2_stub   = { id=22,  kind="pickup", r=20,h=16 },
  m3_skull  = { id=21,  kind="pickup", r=20,h=16 },

  -- health/ammo/armor --
  blue_mana  = { id=122, kind="pickup", r=20,h=16 },
  green_mana = { id=124, kind="pickup", r=20,h=16 },
  dual_mana  = { id=8004,kind="pickup", r=20,h=16 },

  ar_mesh   = { id=8005, kind="pickup", r=20,h=16 },
  ar_shield = { id=8006, kind="pickup", r=20,h=16 },
  ar_helmet = { id=8007, kind="pickup", r=20,h=16 },
  ar_amulet = { id=8008, kind="pickup", r=20,h=16 },

  h_vial  = { id=81, kind="pickup", r=20,h=16 },
  h_flask = { id=82, kind="pickup", r=20,h=16 },
  h_urn   = { id=32, kind="pickup", r=20,h=16 },

  -- artifacts --
  wings = { id=83, kind="pickup", r=20,h=16 },
  chaos = { id=36, kind="pickup", r=20,h=16 },
  torch = { id=33, kind="pickup", r=20,h=16 },

  banish    = { id=10040,kind="pickup", r=20,h=16 },
  boots     = { id=8002, kind="pickup", r=20,h=16 },
  bracer    = { id=8041, kind="pickup", r=20,h=16 },
  repulser  = { id=8000, kind="pickup", r=20,h=16 },
  flechette = { id=10110,kind="pickup", r=20,h=16 },
  servant   = { id=86,   kind="pickup", r=20,h=16 },
  porkies   = { id=30,   kind="pickup", r=20,h=16 },
  incant    = { id=10120,kind="pickup", r=20,h=16 },
  defender  = { id=84,   kind="pickup", r=20,h=16 },
  krater    = { id=8003, kind="pickup", r=20,h=16 },

  --- SCENERY ---

  -- lights --
  candles       = { id=119,  kind="scenery", r=20,h=20, light=255 },
  blue_candle   = { id=8066, kind="scenery", r=20,h=20, light=255 },
  fire_skull    = { id=8060, kind="scenery", r=12,h=12, light=255 },
  brass_brazier = { id=8061, kind="scenery", r=12,h=40, light=255 },

  wall_torch      = { id=54,  kind="scenery", r=20,h=48, light=255 },
  wall_torch_out  = { id=55,  kind="scenery", r=20,h=48 },
  twine_torch     = { id=116, kind="scenery", r=12,h=64, light=255 },
  twine_torch_out = { id=117, kind="scenery", r=12,h=64 },
  chandelier      = { id=17,  kind="scenery", r=20,h=60, light=255, ceil=true },
  chandelier_out  = { id=8063,kind="scenery", r=20,h=60, light=255, ceil=true },

  cauldron        = { id=8069,kind="scenery", r=16,h=32, light=255 },
  cauldron_out    = { id=8070,kind="scenery", r=16,h=32 },
  fire_bull       = { id=8042,kind="scenery", r=24,h=80, light=255 },
  fire_bull_out   = { id=8043,kind="scenery", r=24,h=80 },

  -- urbane --
  winged_statue1 = { id=5,   kind="scenery", r=12,h=64 },
  winged_statue2 = { id=9011,kind="scenery", r=12,h=64 },
  suit_of_armor  = { id=8064,kind="scenery", r=16,h=72 },

  gargoyle_tall  = { id=72, kind="scenery", r=16,h=108 },
  gargoyle_short = { id=74, kind="scenery", r=16,h=64  },
  garg_ice_tall  = { id=73, kind="scenery", r=16,h=108 },
  garg_ice_short = { id=76, kind="scenery", r=16,h=64  },

  garg_corrode     = { id=8044, kind="scenery", r=16,h=108 },
  garg_red_tall    = { id=8045, kind="scenery", r=16,h=108 },
  garg_red_short   = { id=8049, kind="scenery", r=16,h=64  },
  garg_lava_tall   = { id=8046, kind="scenery", r=16,h=108 },
  garg_lava_short  = { id=8050, kind="scenery", r=16,h=64  },

  garg_bronz_tall  = { id=8047, kind="scenery", r=16,h=108 },
  garg_bronz_short = { id=8051, kind="scenery", r=16,h=64  },
  garg_steel_tall  = { id=8048, kind="scenery", r=16,h=108 },
  garg_steel_short = { id=8052, kind="scenery", r=16,h=64  },

  bell   = { id=8065, kind="scenery", r=56,h=120 },
  barrel = { id=8100, kind="scenery", r=16,h=36 },
  bucket = { id=8103, kind="scenery", r=12,h=72 },
  banner = { id=77,   kind="scenery", r=12,h=120 },

  vase_pillar = { id=103, kind="scenery", r=12,h=56 },

  -- natural --
  tree1 = { id=25, kind="scenery", r=16,h=128 },
  tree2 = { id=26, kind="scenery", r=12,h=180 },
  tree3 = { id=27, kind="scenery", r=12,h=160 },

  lean_tree1 = { id=78,  kind="scenery", r=16,h=180 },
  lean_tree2 = { id=79,  kind="scenery", r=16,h=180 },
  smash_tree = { id=8062,kind="scenery", r=16,h=180 },
  xmas_tree  = { id=8068,kind="scenery", r=12,h=132 },

  gnarled_tree1 = { id=80, kind="scenery", r=24,h=96 },
  gnarled_tree2 = { id=87, kind="scenery", r=24,h=96 },

  shrub1 = { id=8101, kind="scenery", r=12,h=24 },
  shrub2 = { id=8102, kind="scenery", r=16,h=40 },

  rock1  = { id=6,  kind="scenery", r=20,h=16 },
  rock2  = { id=7,  kind="scenery", r=20,h=16 },
  rock3  = { id=9,  kind="scenery", r=20,h=16 },
  rock4  = { id=15, kind="scenery", r=20,h=16 },

  stal_pillar   = { id=48, kind="scenery", r=12,h=136 },
  stal_F_big    = { id=49, kind="scenery", r=12,h=48 },
  stal_F_medium = { id=50, kind="scenery", r=12,h=40 },
  stal_F_small  = { id=51, kind="scenery", r=12,h=40 },

  stal_C_big    = { id=52, kind="scenery", r=12,h=68 },
  stal_C_medium = { id=56, kind="scenery", r=12,h=52 },
  stal_C_small  = { id=57, kind="scenery", r=12,h=40 },

  ice_stal_F_big    = { id=93, kind="scenery", r=12,h=68 },
  ice_stal_F_medium = { id=94, kind="scenery", r=12,h=52 },
  ice_stal_F_small  = { id=95, kind="scenery", r=12,h=36 },
  ice_stal_F_tiny   = { id=95, kind="scenery", r=12,h=16 },

  ice_stal_C_big    = { id=89, kind="scenery", r=12,h=68 },
  ice_stal_C_medium = { id=90, kind="scenery", r=12,h=52 },
  ice_stal_C_small  = { id=91, kind="scenery", r=12,h=36 },
  ice_stal_C_tiny   = { id=92, kind="scenery", r=12,h=16 },

  -- gory --
  impaled_corpse = { id=61,  kind="scenery", r=12, h=96 },
  laying_corpse  = { id=62,  kind="scenery", r=12, h=44 },
  hang_corpse_1  = { id=71,  kind="scenery", r=12, h=75, ceil=true },
  hang_corpse_1  = { id=108, kind="scenery", r=12, h=96, ceil=true },
  hang_corpse_1  = { id=109, kind="scenery", r=12, h=100,ceil=true },
  smash_corpse   = { id=110, kind="scenery", r=12, h=40 },

  iron_maiden    = { id=8067,kind="scenery", r=16,h=60 },

  -- misc --
  teleport_smoke = { id=140, kind="scenery", r=20,h=80, pass=true },

  --- SOUNDS ---

  snd_stone  = { id=1400, kind="other", r=16,h=16, pass=true },
  snd_heavy  = { id=1401, kind="other", r=16,h=16, pass=true },
  snd_metal1 = { id=1402, kind="other", r=16,h=16, pass=true },
  snd_creak  = { id=1403, kind="other", r=16,h=16, pass=true },
  snd_silent = { id=1404, kind="other", r=16,h=16, pass=true },
  snd_lava   = { id=1405, kind="other", r=16,h=16, pass=true },
  snd_water  = { id=1406, kind="other", r=16,h=16, pass=true },
  snd_ice    = { id=1407, kind="other", r=16,h=16, pass=true },
  snd_earth  = { id=1408, kind="other", r=16,h=16, pass=true },
  snd_metal2 = { id=1409, kind="other", r=16,h=16, pass=true },
}

HEXEN.FACTORY.XN_LINE_TYPES =
{
  -- FIXME: speeds (16) and delays (64) are just guesses!!

  --- general ---

  A1_scroll_left  = { kind=100, args={ 16 } },
  A1_scroll_right = { kind=101, args={ 16 } },
  A1_scroll_up    = { kind=102, args={ 16 } },
  A1_scroll_down  = { kind=103, args={ 16 } },

  -- FIXME: exit types not right
  S1_exit = { kind=75 },
  W1_exit = { kind=75 },
  S1_secret_exit = { kind=75 },
  W1_secret_exit = { kind=75 },

  WR_teleport = { kind=70 },
  MR_teleport = { kind=70 },  -- monster only

  S1_bars = { kind=21, args={ "tag", 16 } },

  --- doors ---

  PR_door       = { kind=12, args={ 0,16 } },
  PR_blaze_door = { kind=12, args={ 0,32 } },

  W1_door       = { kind=11, args={ "tag", 16 } },
  S1_door       = { kind=11, args={ "tag", 16 } },

  SR_door       = { kind=12, args={ "tag", 16, 64 } },
  SR_blaze_door = { kind=12, args={ "tag", 16, 64 } },

  P1_fire_door   = { kind=13, args={ 0, 16, 64, 4 }  },
  PR_fire_door   = { kind=13, args={ 0, 16, 64, 4 }  },
  P1_castle_door = { kind=13, args={ 0, 16, 64, 11 } },
  PR_castle_door = { kind=13, args={ 0, 16, 64, 11 } },
  P1_silver_door = { kind=13, args={ 0, 16, 64, 7 }  },
  PR_silver_door = { kind=13, args={ 0, 16, 64, 7 }  },

  --- lifts ---

  SR_lift = { kind=62, args={ "tag", 16, 64 } },
  WR_lift = { kind=62, args={ "tag", 16, 64 } },

  SR_blaze_lift = { kind=62, args={ "tag", 32, 64 } },
  WR_blaze_lift = { kind=62, args={ "tag", 32, 64 } },
}

HEXEN.FACTORY.XN_SECTOR_TYPES =
{
  -- FIXME
}


----------------------------------------------------------------

HEXEN.FACTORY.XN_COMBOS =
{
  ---- CAVE ------------

  CAVE1 =
  {
    theme_probs = { CAVE=50 },
    mat_pri = 2,

    wall  = "CAVE06",
    floor = "F_040",
    ceil  = "F_040",

    arch  = "arch_arched",

    scenery = "stal_pillar",
  },

  CAVE2 =
  {
    theme_probs = { CAVE=50 },
    mat_pri = 2,

    wall  = "CAVE05",
    floor = "F_001",
    ceil  = "F_001",

    arch  = "arch_hole",
  },

  CAVE3 =
  {
    theme_probs = { CAVE=70 },
    mat_pri = 2,
    outdoor = true,

    wall  = "CAVE03",
    floor = "F_039",
    ceil  = "F_039",

    scenery = "lean_tree2",

    space_range = { 40,80 },
  },

  CAVE4 =
  {
    theme_probs = { CAVE=50 },
    mat_pri = 3,
    outdoor = true,

    wall  = "CAVE01",
    floor = "F_007",
    ceil  = "F_007",

    scenery = "lean_tree1",

    space_range = { 40,80 },
  },

  ---- DUNGEON ------------

  DUNGEON1 =
  {
    theme_probs = { DUNGEON=50 },
    mat_pri = 5,

    wall  = "FIRE01",
    floor = "F_012",
    ceil  = "F_082",

    pillar = "FIRE15",
    good_liquid = "lava",

  },

  DUNGEON2 =
  {
    theme_probs = { DUNGEON=50 },
    mat_pri = 5,

    wall  = "FIRE06",
    floor = "F_012",
    ceil  = "F_032",

    pillar = "FIRE15",
    good_liquid = "lava",

  },

  DUNGEON3 =
  {
    theme_probs = { DUNGEON=50 },
    mat_pri = 5,

    wall  = "CASTLE11",
    floor = "F_011", -- F_014
    ceil  = "F_045",

    pillar = "FIRE15",
    good_liquid = "lava",

  },

  DUNGEON4 =
  {
    theme_probs = { DUNGEON=50 },
    mat_pri = 5,
    outdoor = true,

    wall  = "PRTL03",
    floor = "F_018",
    ceil  = "F_018",

    pillar = "FIRE15",
    good_liquid = "lava",

  },

  ---- ICE ------------

  ICE1 =
  {
    theme_probs = { ICE=30 },
    mat_pri = 1,

    wall = "ICE01",
    floor = "F_033",
    ceil  = "F_033",

    pillar = "ICE02",
    bad_liquid = "lava",

    sc_count = { 3,7 },
    scenery =
    {
      ice_stal_F_big    = 10, ice_stal_C_big    = 10,
      ice_stal_F_medium = 20, ice_stal_C_medium = 20,
      ice_stal_F_small  = 30, ice_stal_C_small  = 30,
      ice_stal_F_tiny   = 20, ice_stal_C_tiny   = 20,
    },

    trim_mode = "rough_hew",
  },

  ICE2 =
  {
    theme_probs = { ICE=80 },
    mat_pri = 2,

    wall  = "ICE06",
    floor = "F_013",
    ceil  = "F_009",

    pillar = "ICE02",
    bad_liquid = "lava",
  },

  ICE3 =
  {
    theme_probs = { ICE=60 },
    mat_pri = 2,

    wall  = "CAVE02",
    floor = "F_034",
    ceil  = "F_008",

    bad_liquid = "lava",
  },

  ICE4 =
  {
    theme_probs = { ICE=60 },
    mat_pri = 2,
    outdoor = true,

    wall  = "CAVE07",
    floor = "F_008",
    ceil  = "F_008",

    bad_liquid = "lava",
  },

  ---- SWAMP ------------

  SWAMP1 =
  {
    theme_probs = { SWAMP=50 },
    mat_pri = 2,

    wall = "SEWER01",
    floor = "X_009",
    ceil  = "F_013",

    liquid_prob = 0,

    wall_fabs = { solid_SEWER02=30, other=30 },

    -- FIXME !!!! X_SWR1 pillar
  },

  SWAMP2 =
  {
    theme_probs = { SWAMP=50 },
    mat_pri = 2,

    wall = "SEWER08",
    floor = "X_009",
    ceil  = "F_013",

    liquid_prob = 0,

    wall_fabs = { solid_SEWER10=60, other=30 },
  },

  SWAMP3 =
  {
    theme_probs = { SWAMP=50 },
    mat_pri = 2,
    outdoor = true,

    wall = "WASTE01",
    floor = "X_009",
    ceil  = "F_013",

    liquid_prob = 0,
  },

  SWAMP4 =
  {
    theme_probs = { SWAMP=50 },
    mat_pri = 2,
    outdoor = true,

    wall  = "SWAMP03",
    floor = "X_009",
    ceil  = "F_013",

    liquid_prob = 0,
  },

  ---- VILLAGE ------------

  VILLAGE1 =
  {
    theme_probs = { VILLAGE=50 },
    mat_pri = 6,

    wall  = "FOREST01",
    floor = "F_089",
    ceil  = "F_010",

    scenery = "brass_brazier",
    sc_fabs = { pillar_rnd_PILLAR01=50, other=30 },
  },

  VILLAGE2 =
  {
    theme_probs = { VILLAGE=50 },
    mat_pri = 4,

    wall  = "WOOD03",
    floor = "F_055",
    ceil  = "F_014",

    pillar = "PILLAR01",
    scenery = "brass_brazier",
  },

  VILLAGE3 =
  {
    theme_probs = { VILLAGE=60 },
    mat_pri = 6,

    wall  = "MONK02",
    floor = "F_059",  -- F_011
    ceil  = "F_037",

    scenery = "brass_brazier",
    sc_fabs = { pillar_rnd_PILLAR02=50, pillar_wide_MONK03=40, other=30 },
  },

  VILLAGE4 =
  {
    theme_probs = { VILLAGE=50 },
    mat_pri = 6,
    outdoor = true,

    wall  = "MONK15",
    floor = "F_029",
    ceil  = "F_029",

    pillar = "PILLAR01",
    scenery = "brass_brazier",
  },

  VILLAGE5 =
  {
    theme_probs = { VILLAGE=50 },
    mat_pri = 6,
    outdoor = true,

    wall  = "CASTLE07",
    floor = "F_057",
    ceil  = "F_057",

    scenery = "banner",
  },

  VILLAGE6 =
  {
    theme_probs = { VILLAGE=50 },
    mat_pri = 4,
    outdoor = true,

    wall  = "PRTL02",
    floor = "F_044",
    ceil  = "F_044",

    scenery = "gargoyle_short",
  },
  
}

HEXEN.FACTORY.XN_EXITS =
{
  STEEL =
  {
    mat_pri = 9,

    wall = "STEEL01",
    void = "STEEL02",

    floor = "F_022",
    ceil  = "F_044",

    switch = { switch="SW_2_UP", wall="STEEL06", h=64 },

    door = { wall="FIRE14", w=64,  h=128 },
  },

}

HEXEN.FACTORY.XN_HALLWAYS =
{
  -- FIXME !!! hallway themes
}


---- BASE MATERIALS ------------

HEXEN.FACTORY.XN_MATS =
{
  METAL =
  {
    mat_pri = 5,

    wall  = "PLAT01", void = "PLAT01",
    floor = "F_065",  ceil = "F_065",
  },

  STEP =
  {
    wall  = "S_09",
    floor = "F_014",
  },

  LIFT =
  {
    wall  = "PLAT02",
    floor = "F_065"
  },

  TRACK =
  {
    wall  = "STEEL08",
    floor = "F_008",
  },

  DOOR_FRAME =
  {
    wall  = nil,  -- this means: use plain wall
    floor = "F_009",
    ceil  = "F_009",
  },
}

---- PEDESTALS ------------

HEXEN.FACTORY.XN_PEDESTALS =
{
  PLAYER =
  {
    wall = "T2_STEP", void = "FIRE06",
    floor = "F_062",  ceil = "F_062",  -- TODO: F_061..F_064
    h = 8,
  },

  QUEST =
  {
    wall = "T2_STEP", void = "FIRE06",
    floor = "F_042",  ceil = "F_042",
    h = 8,
  },

  WEAPON =
  {
    wall = "T2_STEP", void = "FIRE06",
    floor = "F_091",  ceil = "F_091",
    h = 8,
  },

}

---- OVERHANGS ------------

HEXEN.FACTORY.XN_OVERHANGS =
{
  WOOD =
  {
    ceil = "F_054",
    upper = "D_WD07",
    thin = "WOOD01",
  },
}


---- MISC STUFF ------------

HEXEN.FACTORY.XN_LIQUIDS =
{
  water = { floor="X_005", wall="X_WATER1" },
  lava  = { floor="X_001", wall="X_FIRE01" },

--- slime = { floor="X_009", wall="X_SWMP1" },
}

HEXEN.FACTORY.XN_SWITCHES =
{
  sw_cow =
  {
    switch =
    {
      prefab = "SWITCH_NICHE_TINY",
      add_mode = "island",
      skin =
      {
        switch_w="SW_1_UP", wall="STEEL02",
        floor="F_075", ceil="F_075",
        switch_h=48, x_offset=0, y_offset=0,

        kind = { id=11, act="S1", args={"tag", 2 } },
      }
    },

    door =
    {
      w=128, h=128,
      prefab = "DOOR", -- DOOR_LOCKED
      skin =
      {
        door_w="STEEL01", door_c="F_074",
--      key_w="STEEL06",
        door_h=128,
        door_kind=0, tag=0,

---     step_w="STEP1",  track_w="DOORTRAK",
---     frame_f="FLAT1", frame_c="FLAT1",
      }
    },
  },

  sw_ball =
  {
    switch =
    {
      prefab = "SWITCH_NICHE_TINY",
      add_mode = "island",
      skin =
      {
        switch_w="SW53_UP", wall="MONK02",
        floor="F_025", ceil="F_025",
        switch_h=40, x_offset=0, y_offset=0,

        kind = { id=11, act="S1", args={"tag", 2 } },
      }
    },

    door =
    {
      w=128, h=128,
      prefab = "DOOR", -- DOOR_LOCKED
      skin =
      {
        door_w="MONK17", door_c="F_014",
        door_h=128,
        door_kind=0, tag=0,
      }
    },
  },

  sw_sheep =
  {
    switch =
    {
      prefab = "SWITCH_NICHE_TINY",
      add_mode = "wall",
      skin =
      {
        switch_w="SW_2_UP",
        switch_h=48, x_offset=0, y_offset=0,

        kind = { id=11, act="S1", args={"tag", 2 } },
      }
    },

    door =
    {
      w=128, h=128,
      prefab = "DOOR", -- DOOR_LOCKED
      skin =
      {
        door_w="FOREST03", door_c="F_017",
        door_h=128,
        door_kind=0, tag=0,
      }
    },
---#    door =
---#    {
---#      w=128, h=128,
---#      prefab = "DOOR", -- DOOR_LOCKED
---#      skin =
---#      {
---#        door_w="MONK08", door_c="F_027",
---#        door_h=128,
---#        door_kind=0, tag=0,
---#      }
---#    },
  },

  sw_demon =
  {
    switch =
    {
      prefab = "SWITCH_NICHE_TINY",
      add_mode = "wall",
      skin =
      {
        switch_w="SW51_OFF",
        switch_h=32, x_offset=0, y_offset=0,

        kind = { id=11, act="S1", args={"tag", 2 } },
      }
    },

    door =
    {
      w=128, h=128,
      prefab = "DOOR", -- DOOR_LOCKED
      skin =
      {
        door_w="PRTL06", door_c="F_013",
        door_h=128,
        door_kind=0, tag=0,
      }
    },
  },

---#  sw_chain =
---#  {
---#    switch =
---#    {
---#      prefab = "SWITCH_NICHE_HEXEN",
---#      add_mode = "wall",
---#      skin =
---#      {
---#        switch_w="SW_OL5",
---#        switch_h=32, x_offset=0, y_offset=0,
---#
---#        kind = { id=11, act="S1", args={"tag", 2 } },
---#      }
---#    },
---#
---#    door =
---#    {
---#      w=128, h=128,
---#      prefab = "DOOR", -- DOOR_LOCKED
---#      skin =
---#      {
---#        door_w="STEEL07", door_c="F_066",
---#        door_h=128,
---#        door_kind=0, tag=0,
---#      }
---#    },
---#  },

  sw_moon =
  {
    switch =
    {
      prefab = "SWITCH_FLOOR_TINY_PED",
      add_mode = "island",
      skin =
      {
        switch_w="SW52_OFF", side_w="FIRE06", ped_w="FIRE06",
        switch_f="F_012", ped_f="F_012",
        switch_h=32, x_offset=0, y_offset=0,

        kind = { id=11, act="S1", args={"tag", 2 } },
      }
    },

    door =
    {
      w=128, h=128,
      prefab = "DOOR", -- DOOR_LOCKED
      skin =
      {
        door_w="CLOCKA", door_c="F_010",
        door_h=128,
        door_kind=0, tag=0,
      }
    },
  },
}

HEXEN.FACTORY.XN_DOORS =
{
  d_big2   = { prefab="DOOR", w=128, h=128,

               skin =
               {
                 door_w="DOOR51", door_c="F_009",
                 track_w="STEEL08",
                 door_h=128,

---              lite_w="LITE5", step_w="STEP1",
---              frame_f="FLAT1", frame_c="TLITE6_6",
               }
             },

--[[ !!!
  d_big    = { wall="DOOR51",   w=128, h=128 },
  d_brass1 = { wall="BRASS1",   w=128, h=128 },
  d_brass2 = { wall="D_BRASS2", w=64,  h=128 },

  d_wood1  = { wall="D_WD07",   w=128, h=128 },
  d_wood2  = { wall="D_WD08",   w=64,  h=128 },
--]]

  d_wood3  = { wall="D_WD10",   w=64,  h=128 },
}

HEXEN.FACTORY.XN_KEY_DOORS =
{
  k_emerald =
  {
    w=128, h=128,
    prefab = "DOOR", -- DOOR_LOCKED
    skin =
    {
      door_w="D_CAST", door_c="F_009",
      track_w="STEEL08", frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 5} },
      tag=0,
    }
  },

  k_fire =
  {
    w=128, h=128,

    prefab = "DOOR", -- DOOR_LOCKED

    skin =
    {
      door_w="D_FIRE", door_c="F_009",
      track_w="STEEL08",
      frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 4} },
      tag=0,
    }
  },

  k_castle =
  {
    w=128, h=128,

    prefab = "DOOR", -- DOOR_LOCKED

    skin =
    {
      door_w="CASTLE06", door_c="F_009",  --FIXME !!!!  castle door
      track_w="STEEL08",
      frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 11} },
      tag=0,
    }
  },

  k_silver =
  {
    w=128, h=128,

    prefab = "DOOR", -- DOOR_LOCKED

    skin =
    {
      door_w="D_SILVER", door_c="F_009",
      track_w="STEEL08",
      frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 7} },
      tag=0,
    }
  },

  k_cave =
  {
    w=128, h=128,
    prefab = "DOOR", -- DOOR_LOCKED
    skin =
    {
      door_w="D_CAVE2", door_c="F_009",
      track_w="STEEL08", frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 2} },
      tag=0,
    }
  },

  k_swamp =
  {
    w=128, h=128,
    prefab = "DOOR", -- DOOR_LOCKED
    skin =
    {
      door_w="D_SWAMP2", door_c="F_009",
      track_w="STEEL08", frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 10} },
      tag=0,
    }
  },

  k_steel =
  {
    w=128, h=128,
    prefab = "DOOR", -- DOOR_LOCKED
    skin =
    {
      door_w="D_STEEL", door_c="F_009",
      track_w="STEEL08", frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 1} },
      tag=0,
    }
  },

  k_rusty =
  {
    w=128, h=128,
    prefab = "DOOR", -- DOOR_LOCKED
    skin =
    {
      door_w="D_RUST", door_c="F_009",
      track_w="STEEL08", frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 8} },
      tag=0,
    }
  },

  k_dungeon =
  {
    w=128, h=128,
    prefab = "DOOR", -- DOOR_LOCKED
    skin =
    {
      door_w="D_DUNGEO", door_c="F_009",
      track_w="STEEL08", frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 6} },
      tag=0,
    }
  },

  k_horn =
  {
    w=128, h=128,
    prefab = "DOOR", -- DOOR_LOCKED
    skin =
    {
      door_w="D_WASTE", door_c="F_009",
      track_w="STEEL08", frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 9} },
      tag=0,
    }
  },

  k_axe =
  {
    w=128, h=128,
    prefab = "DOOR", -- DOOR_LOCKED
    skin =
    {
      door_w="D_AXE", door_c="F_009",
      track_w="STEEL08", frame_f="F_009",
      door_h=128,
      door_kind = { id=13, act="SR", args={0, 16, 128, 3} },
      tag=0,
    }
  },

}

HEXEN.FACTORY.XN_RAILS =
{
  r_1 = { wall="GATE03", w=64, h=64  },
  r_2 = { wall="GATE02", w=64, h=128 },
}

HEXEN.FACTORY.XN_IMAGES =
{
  { wall = "BRASS3", w=128, h=128, glow=true },
  { wall = "BRASS4", w=64,  h=64,  floor="F_016" }
}

HEXEN.FACTORY.XN_LIGHTS =
{
  l1 = { floor="F_081", side="FIRE07" },
  l2 = { floor="F_084", side="FIRE07" },
  l3 = { floor="X_012", side="FIRE07" },
}

HEXEN.FACTORY.XN_WALL_LIGHTS =
{
  fire = { wall="X_FIRE01", w=16 },
}

HEXEN.FACTORY.XN_PICS =
{
  cave12 = { wall = "CAVE12",   w=128, h=128 },
  forest = { wall = "FOREST03", w=128, h=128 },

  mon1 = { wall = "SPAWN10",  w=128, h=128 },
  mon3 = { wall = "SPAWN13",  w=64,  h=64  },

  glass1 = { wall = "GLASS01",  w=64,  h=128 },
  glass3 = { wall = "GLASS03",  w=64,  h=128 },
  glass5 = { wall = "GLASS05",  w=64,  h=128 },
}


---- QUEST STUFF ----------------

HEXEN.FACTORY.XN_ROOMS =
{
  PLAIN =
  {
  },

  HALLWAY =
  {
    room_heights = { [96]=50, [128]=50 },
    door_probs   = { out_diff=75, combo_diff=50, normal=5 },
    window_probs = { out_diff=1, combo_diff=1, normal=1 },
    space_range  = { 20, 65 },
  },
 
  SCENIC =
  {
  },

  -- TODO: check in-game level names for ideas
}

HEXEN.FACTORY.XN_THEMES =
{
  CAVE =
  {
    room_probs=
    {
      PLAIN=50,
    },

    monster_prefs =
    {
      demon1=3.0, demon2=3.0
    },

    diff_probs = { [0]=10, [16]=40, [32]=80, [64]=60, [96]=20 },
    bump_probs = { [0]=5, [16]=30, [32]=30, [64]=20 },
    door_probs   = { out_diff=10, combo_diff= 3, normal=1 },
    window_probs = { out_diff=30, combo_diff=30, normal=5 },
    space_range  = { 1, 50 },

    trim_mode = "rough_hew",
  },

  DUNGEON =
  {
    room_probs=
    {
      PLAIN=50,
    },

    monster_prefs =
    {
      centaur1=3.0, centaur2=3.0, reiver=2.5
    },
  },

  ICE =
  {
    room_probs=
    {
      PLAIN=50,
    },

    monster_prefs =
    {
      wendigo=500, afrit=0.2
    },
  },

  SWAMP =
  {
    room_probs=
    {
      PLAIN=50,
    },

    monster_prefs =
    {
      -- need high values just to make them appear
      stalker1=5000, stalker2=3000
    },
  },

  VILLAGE =
  {
    room_probs=
    {
      PLAIN=50,
    },

    monster_prefs =
    {
      afrit=3.0, bishop=2.5
    },
  },
}


HEXEN.FACTORY.XN_LIFTS =
{
  slow =
  {
    kind = { id=62, act="SR", args={"tag", 16, 64} },
    walk = { id=62, act="SR", args={"tag", 16, 64} },
  },

  fast =
  {
    kind = { id=62, act="SR", args={"tag", 32, 64} },
    walk = { id=62, act="SR", args={"tag", 32, 64} },
  },
}


HEXEN.FACTORY.XN_DOOR_PREFABS =
{
  winnow =
  {
    w=128, h=128, prefab="DOOR",

    skin =
    {
      door_w="D_WINNOW", door_c="F_009",
      track_w="STEEL08",
      door_h=128,
      door_kind = { id=12, act="SR", args={0, 16, 128} },
      tag=0,
    },

--    theme_probs = { CITY=60,ICE=10,CAVE=20 },
  },

  door51 =
  {
    w=128, h=128, prefab="DOOR",

    skin =
    {
      door_w="DOOR51", door_c="F_009",
      track_w="STEEL08",
      door_h=128,
      door_kind = { id=12, act="SR", args={0, 16, 128} },
      tag=0,
    },

--    theme_probs = { CITY=60,ICE=10,CAVE=20 },
  },
}

---#HEXEN.FACTORY.XN_ITEM_PREFABS =
---#{
---#  weap_2 =
---#  {
---#    prefab = "HEXEN_TRIPLE_PED",
---#
---#    skin =
---#    {
---#      ped_f="F_084", ped_w="CASTLE07",
---#      ped_h=8,
---#
---#      item_F_t="f_axe",  -- FIXME: flag as Fighter-only
---#      item_C_t="c_staff",
---#      item_M_t="m_cone",
---#    }
---#  },
---#
---#  weap_3 =
---#  {
---#    prefab = "HEXEN_TRIPLE_PED",
---#
---#    skin =
---#    {
---#      ped_f="F_084", ped_w="CASTLE07",
---#      ped_h=8,
---#
---#      item_F_t="f_hammer",
---#      item_C_t="c_fire",
---#      item_M_t="m_blitz",
---#    }
---#  },
---#
---#  piece_1 =
---#  {
---#    prefab = "HEXEN_TRIPLE_PED",
---#
---#    skin =
---#    {
---#      ped_f="F_084", ped_w="CASTLE07",
---#      ped_h=8,
---#
---#      item_F_t="f1_hilt",
---#      item_C_t="c1_shaft",
---#      item_M_t="m1_stick",
---#    }
---#  },
---#
---#  piece_2 =
---#  {
---#    prefab = "HEXEN_TRIPLE_PED",
---#
---#    skin =
---#    {
---#      ped_f="F_084", ped_w="CASTLE07",
---#      ped_h=8,
---#
---#      item_F_t="f2_cross",
---#      item_C_t="c2_cross",
---#      item_M_t="m2_stub",
---#    }
---#  },
---#
---#  piece_3 =
---#  {
---#    prefab = "HEXEN_TRIPLE_PED",
---#
---#    skin =
---#    {
---#      ped_f="F_084", ped_w="CASTLE07",
---#      ped_h=8,
---#
---#      item_F_t="f3_blade",
---#      item_C_t="c3_arc",
---#      item_M_t="m3_skull",
---#    }
---#  },
---#}

HEXEN.FACTORY.XN_WALL_PREFABS =
{
  solid_SEWER02 =
  {
    prefab = "SOLID", skin = { wall="SEWER02" },
  },

  solid_SEWER10 =
  {
    prefab = "SOLID", skin = { wall="SEWER10" },
  },
}

HEXEN.FACTORY.XN_MISC_PREFABS =
{
  -- Note: pedestal_PLAYER intentionally omitted

  pedestal_ITEM =
  {
    prefab = "PEDESTAL",
    skin = { wall="CASTLE07", floor="F_084", ped_h=12 },
  },

  image_1 =
  {
    prefab = "CRATE",
    add_mode = "island",
    skin = { crate_h=64, crate_w="BRASS4", crate_f="F_044" },
  },

  arch_arched =
  {
    prefab = "ARCH_ARCHED", skin = {},
  },

  arch_hole =
  {
    prefab = "ARCH_HOLE1", skin = {},
  },

  image_2 =
  {
    prefab = "WALL_PIC_SHALLOW",
    add_mode = "wall",
    min_height = 144,
    skin = { pic_w="BRASS3", pic_h=128 },
  },

  secret_DOOR =
  {
    w=128, h=128, prefab = "DOOR",

    skin =
    {
      door_h=128,
      door_kind = { id=12, act="S1", args={0, 16, 64} },
      tag=0,
    }
  },

  gate_FORWARD =
  {
    prefab = "HEXEN_V_TELEPORT",

    skin =
    {
      frame_w="WOOD01", frame_f="F_054", frame_c="F_054",
      telep_w="TPORT1", border_w="TPORTX",
      tag=0,
    },
  },

  gate_BACK =
  {
    prefab = "HEXEN_V_TELEPORT",

    skin =
    {
      frame_w="FOREST05", frame_f="F_048", frame_c="F_048",
      telep_w="TPORT1", border_w="TPORTX",
      tag=0,
    },
  },
}

HEXEN.FACTORY.XN_SCENERY_PREFABS =
{
  pillar_rnd_PILLAR01 =
  {
    prefab = "PILLAR_ROUND_SMALL",
    add_mode = "island",
    environment = "indoor",

    skin = { wall="PILLAR01" },
  },

  pillar_rnd_PILLAR02 =
  {
    prefab = "PILLAR_ROUND_SMALL",
    add_mode = "island",
    environment = "indoor",

    skin = { wall="PILLAR02" },
  },

  pillar_wide_MONK03 =
  {
    prefab = "PILLAR_WIDE",
    add_mode = "island",
    environment = "indoor",

    skin = { wall="MONK03" },
  },
}

-- HEXEN.FACTORY.XN_DEATHMATCH_EXITS =
-- {
--   exit_dm_GREEN =
--   {
--     prefab = "EXIT_DEATHMATCH",
-- 
--     skin = { wall="FOREST05", front_w="FOREST05",
--              floor="F_009", ceil="F_009",
--              switch_w="SW51_OFF", side_w="FIRE07", switch_f="F_013",
--              frame_f="F_048", frame_c="F_048",
--              door_w="D_BRASS1", door_c="F_075",
-- 
--              inside_h=160, door_h=128,
--              switch_yo=0,  tag=0,
-- 
--              door_kind  ={ id=12, act="S1", args={0, 16, 64} },
--              switch_kind={ id=
--            },
--   },
-- }

HEXEN.FACTORY.XN_INITIAL_MODEL =
{
  fighter =
  {
    health=100, armor=0,
    blue_mana=0, green_mana=0,
    f_gaunt=true
  },

  cleric =
  {
    health=100, armor=0,
    blue_mana=0, green_mana=0,
    c_mace=true
  },

  mage =
  {
    health=100, armor=0,
    blue_mana=0, green_mana=0,
    m_wand=true
  },
}

HEXEN.FACTORY.XN_MONSTERS =
{
  -- FIXME: dm stats are CRAP!
  ettin      = { prob=60, hp=170, dm= 5, fp=1.0, melee=true },

  afrit      = { prob=30, hp=80,  dm=15, fp=1.2, float=true },
  demon1     = { prob=20, hp=90,  dm=12, fp=1.0, cage_fallback=2 },
  demon2     = { prob=15, hp=90,  dm=20, fp=1.4, },

  wendigo    = { prob= 1, hp=120, dm=25, fp=1.2, },
  centaur1   = { prob=30, hp=200, dm=10, fp=1.6, melee=true },
  centaur2   = { prob=15, hp=250, dm=20, fp=2.1, },

  stalker1   = { prob=0.1,hp=250, dm=40, fp=1.3, melee=true },
  stalker2   = { prob=0.1,hp=250, dm=40, fp=2.3, },
  bishop     = { prob= 9, hp=130, dm=50, fp=2.5, float=true },
  reiver     = { prob= 4, hp=150, dm=60, fp=2.8, float=true },
}

HEXEN.FACTORY.XN_BOSSES =
{
  wyvern     = { hp=640, dm=60, fp=3.0, float=true },
  heresiarch = { hp=5000,dm=70, fp=3.0 },
  korax      = { hp=5000,dm=90, fp=3.0 },
}

HEXEN.FACTORY.XN_WEAPONS =
{
  -- FIXME: rate and dm values are CRAP!
  c_mace    = { fp=1, held=true, melee=true,     rate=1.1, dm=12, freq=10, held=true, },
  c_staff   = { fp=2, ammo="blue_mana",  per=1,  rate=1.1, dm= 6, freq=21, },
  c_fire    = { fp=3, ammo="green_mana", per=4,  rate=1.1, dm=27, freq=42, },
  c_wraith  = { fp=4, ammo="dual_mana",  per=18, rate=2.2, dm=200,freq=94, },

  f_gaunt   = { fp=1, held=true, melee=true,     rate=1.1, dm=20, freq=10, held=true, },
  f_axe     = { fp=2, ammo="blue_mana",  per=2,  rate=1.1, dm=60, freq=21, melee=true },
  f_hammer  = { fp=3, ammo="green_mana", per=3,  rate=1.1, dm=27, freq=42, },
  f_quietus = { fp=4, ammo="dual_mana",  per=14, rate=2.2, dm=200,freq=94, },

  m_wand    = { fp=1, held=true,                 rate=1.1, dm= 8, freq=10, penetrates=true },
  m_cone    = { fp=2, ammo="blue_mana",  per=3,  rate=1.1, dm=27, freq=21, },
  m_blitz   = { fp=3, ammo="green_mana", per=5,  rate=1.1, dm=60, freq=42, },
  m_scourge = { fp=4, ammo="dual_mana",  per=15, rate=2.2, dm=200,freq=94, },
}

HEXEN.FACTORY.XN_WEAPON_NAMES =
{
  fighter = { "f_gaunt", "f_axe",   "f_hammer", "f_quietus" },
  cleric  = { "c_mace",  "c_staff", "c_fire",   "c_wraith"  },
  mage    = { "m_wand",  "m_cone",  "m_blitz",  "m_scourge" },
}

HEXEN.FACTORY.XN_WEAPON_PIECES =
{
  fighter = { "f1_hilt",  "f2_cross", "f3_blade" },
  cleric  = { "c1_shaft", "c2_cross", "c3_arc"   },
  mage    = { "m1_stick", "m2_stub",  "m3_skull" },
}

HEXEN.FACTORY.XN_PICKUPS =
{
  h_vial  = { stat="health", give=10,  prob=70 },
  h_flask = { stat="health", give=25,  prob=25 },
  h_urn   = { stat="health", give=100, prob=5, max_clu=1 },

  -- FIXME: these give values are CRAP!
  ar_mesh   = { stat="armor", give=100, prob=50 },
  ar_shield = { stat="armor", give=100, prob=70 },
  ar_helmet = { stat="armor", give=100, prob=90 },
  ar_amulet = { stat="armor", give=100, prob=50 },

  blue_mana  = { stat="blue_mana",  give=10 },
  green_mana = { stat="green_mana", give=10 },
  dual_mana  = { stat="dual_mana",  give=20 },
}

HEXEN.FACTORY.XN_NICENESS =
{
  a1 = { pickup="ar_mesh",   prob=3 },
  a2 = { pickup="ar_shield", prob=3 },
  a3 = { pickup="ar_helmet", prob=3 },
  a4 = { pickup="ar_amulet", prob=3 },

  p1 = { pickup="flechette", prob=9 },
  p2 = { pickup="bracer",    prob=5 },
  p3 = { pickup="torch",     prob=2 },
}

HEXEN.FACTORY.XN_DEATHMATCH =
{
  weapons =
  {
    c_staff=40, c_fire  =40,
    f_axe  =40, f_hammer=40,
    m_cone =40, m_blitz =40,
  },

  health =
  { 
    h_vial=50, h_flask=50, h_urn=5
  },

  ammo =
  { 
    blue_mana=50, green_mana=50, dual_mana=80, krater=1
  },

  items =
  {
    ar_mesh=100, ar_shield=100, ar_helmet=100, ar_amulet=100,

    flechette=30, bracer=20, incant=3, boots=8,
    wings=3, chaos=10, banish=10, repulser=10,
    torch=10, porkies=20, defender=1,
  },

  cluster = {}
}




------------------------------------------------------------

HEXEN.FACTORY.XN_THEME_LIST =
{
  "CAVE", "DUNGEON", "ICE", "SWAMP", "VILLAGE"
}

HEXEN.FACTORY.XN_SKY_INFO =
{
  { color="orange", light=176 },
  { color="blue",   light=144 },
  { color="blue",   light=192, lightning=true },
  { color="red",    light=192 },
  { color="gray",   light=176, foggy=true },
}

HEXEN.FACTORY.XN_KEY_PAIRS =
{
  { key_A="k_emerald", key_B="k_cave" },
  { key_A="k_silver",  key_B="k_swamp" },
  { key_A="k_steel",   key_B="k_rusty" },
  { key_A="k_fire",    key_B="k_dungeon" },
  { key_A="k_horn",    key_B="k_castle" },
}

HEXEN.FACTORY.XN_LEVELS =
{
  --- Cluster 1 ---
  {
    { map=1, sky_info=HEXEN.FACTORY.XN_SKY_INFO[3] },
    { map=2, sky_info=HEXEN.FACTORY.XN_SKY_INFO[4] },
    { map=3, sky_info=HEXEN.FACTORY.XN_SKY_INFO[4] },
    { map=4, sky_info=HEXEN.FACTORY.XN_SKY_INFO[4] },
    { map=5, sky_info=HEXEN.FACTORY.XN_SKY_INFO[4] },
    { map=6, sky_info=HEXEN.FACTORY.XN_SKY_INFO[4], boss_kind="centaur2" },
  },

  --- Cluster 2 ---
  {
    { map=13, sky_info=HEXEN.FACTORY.XN_SKY_INFO[1] },
    { map= 8, sky_info=HEXEN.FACTORY.XN_SKY_INFO[5] },
    { map= 9, sky_info=HEXEN.FACTORY.XN_SKY_INFO[1] },
    { map=10, sky_info=HEXEN.FACTORY.XN_SKY_INFO[1] },
    { map=11, sky_info=HEXEN.FACTORY.XN_SKY_INFO[5] },
    { map=12, sky_info=HEXEN.FACTORY.XN_SKY_INFO[1], boss_kind="wyvern" },
  },

  --- Cluster 3 ---
  {
    -- Note: MAP30 is never used (FIXME: super-secret level)

    { map=27, sky_info=HEXEN.FACTORY.XN_SKY_INFO[4] },
    { map=28, sky_info=HEXEN.FACTORY.XN_SKY_INFO[4] },
    { map=31, sky_info=HEXEN.FACTORY.XN_SKY_INFO[4] },
    { map=32, sky_info=HEXEN.FACTORY.XN_SKY_INFO[5] },
    { map=33, sky_info=HEXEN.FACTORY.XN_SKY_INFO[4] },
    { map=34, sky_info=HEXEN.FACTORY.XN_SKY_INFO[4], boss_kind="heresiarch" },
  },

  --- Cluster 4 ---
  {
    { map=21, sky_info=HEXEN.FACTORY.XN_SKY_INFO[3] }, 
    { map=22, sky_info=HEXEN.FACTORY.XN_SKY_INFO[3] }, 
    { map=23, sky_info=HEXEN.FACTORY.XN_SKY_INFO[3] }, 
    { map=24, sky_info=HEXEN.FACTORY.XN_SKY_INFO[3] }, 
    { map=25, sky_info=HEXEN.FACTORY.XN_SKY_INFO[3] }, 
    { map=26, sky_info=HEXEN.FACTORY.XN_SKY_INFO[3], boss_kind="heresiarch" },
  },

  --- Cluster 5 ---
  {
    { map=35, sky_info=HEXEN.FACTORY.XN_SKY_INFO[3] },
    { map=36, sky_info=HEXEN.FACTORY.XN_SKY_INFO[3] },
    { map=37, sky_info=HEXEN.FACTORY.XN_SKY_INFO[4] },
    { map=38, sky_info=HEXEN.FACTORY.XN_SKY_INFO[3] },
    { map=39, sky_info=HEXEN.FACTORY.XN_SKY_INFO[3] },
    { map=40, sky_info=HEXEN.FACTORY.XN_SKY_INFO[4], boss_kind="korax" },
  },
}

HEXEN.FACTORY.XN_QUEST_LEN_PROBS =
{
  ----------  2   3   4   5   6   7   8   9  10  -------

  switch = {  0, 40, 90, 90, 25, 2 },
  gate   = {  1, 50, 90, 50, 20, 5 },
  back   = {  0, 10, 40, 90, 50, 25, 3 },

  key    = {  0,  0, 30, 70, 90, 70, 30, 15, 2 },
  item   = { 15, 90, 70, 25, 3 },
  weapon = { 30, 60, 10,  2 },

  boss   = {  0,  5, 40, 90, 60, 30, 10, 1 },
}

function HEXEN.get_factory_levels(episode)

  -- NOTE: see doc/Quests.txt for structure of Hexen episodes

  local level_list = {}

  local source_levels = HEXEN.FACTORY.XN_LEVELS[episode]
  assert(#source_levels == 6)

  local theme_mapping = { 1,2,3,4,5 }
  rand.shuffle(theme_mapping)

  local key_A = HEXEN.FACTORY.XN_KEY_PAIRS[episode].key_A
  local key_B = HEXEN.FACTORY.XN_KEY_PAIRS[episode].key_B
  assert(key_A and key_B)

  for map = 1,6 do
    local Src = source_levels[map]

    local Level =
    {
      map  = Src.map,
      name = string.format("MAP%02d", Src.map),

      episode   = episode,
      ep_along  = map,
      ep_length = 6,

      sky_info  = Src.sky_info,
      boss_kind = Src.boss_kind,

      quests = {}, gates = {},

      toughness_factor = 1 + (episode-1) / 3,
    }

    if map == 5 or OB_CONFIG.length == "single" then
      -- secret level is a mixture
      Level.theme_probs = { ICE=3,SWAMP=4,DUNGEON=5,CAVE=6,VILLAGE=7 }
    else
      local th_name = HEXEN.FACTORY.XN_THEME_LIST[theme_mapping[sel(map==6, 5, map)]]
      Level.theme_probs = { [th_name] = 5 }
    end

    table.insert(level_list, Level)
  end


  level_list[5].secret_kind = "plain"

  local b_src = rand.sel(50, 1, 3)
  local w_src = rand.sel(50, 1, 2)

  local gate_idx = 2


  local function add_assumed_weaps(quest, wp)
    if not quest.assumed_stuff then
      quest.assumed_stuff = {}
    end
    for xxx,CL in ipairs(GAME.FACTORY.classes) do
      table.insert(quest.assumed_stuff,
      {
        weapon = HEXEN.FACTORY.XN_WEAPON_NAMES[CL][wp]
      })
    end
  end

  local function add_quest(map, kind, item, mode, force_key)
    assert(map)

    local L = level_list[map]

    local len_probs = non_nil(HEXEN.FACTORY.XN_QUEST_LEN_PROBS[kind])

    local Quest =
    {
      kind = kind,
      item = item,
      mode = mode,
      force_key = force_key,
      want_len = 1 + rand.index_by_probs(len_probs)
    }

    if mode ~= "sub" then
      if map >= 3 then add_assumed_weaps(Quest, 2) end
      if map == 4 then add_assumed_weaps(Quest, 3) end
      if map == 6 then add_assumed_weaps(Quest, 3) end
      if map == 6 then add_assumed_weaps(Quest, 4) end
    end

    table.insert(L.quests, Quest)

    return Quest
  end

  local function join_map(src, dest, force_key)
    assert(src and dest)

    local Gate =
    {
      src  = level_list[src],
      dest = level_list[dest],

      src_idx  = gate_idx,
      dest_idx = gate_idx + 1,
    }

    table.insert(Gate.src.gates,  Gate)
    table.insert(Gate.dest.gates, Gate)

    gate_idx = gate_idx + 2

    local fwd_mode  = "sub"
    local back_mode = "end"
    
    if src == 1 and not Gate.src.has_main then
      fwd_mode = "end"
      Gate.src.has_main = true
    end

    if dest == 6 then
      back_mode = "sub"
    end

    local F = add_quest(src,  "gate", dest, fwd_mode, force_key)
    local B = add_quest(dest, "back", src,  back_mode)

    F.gate_kind = { id=74, act="WR", args={ Gate.dest.map, 0 }}
    B.gate_kind = { id=74, act="WR", args={ Gate.src.map, Gate.src_idx }}

    F.return_args = { Gate.src_idx }

    if dest == 5 then
      F.is_secret = true
    end
  end

  local function dump_levels()
    for idx,L in ipairs(level_list) do
      gui.printf("Hexen episode [%d] map [%d] : %s\n", episode, idx, L.name)
      show_quests(L.quests)
    end
  end

  -- connections

  join_map(b_src, 6, key_A)
  join_map(w_src, 4, key_B)

  local r = rand.irange(1,5)

  join_map(sel(r==2, 2, 1), 3)
  join_map(sel(r==3, 3, 1), 2)

  add_quest(2, "key", key_A, "main")
  add_quest(3, "key", key_B, "main")

  for xxx,CL in ipairs(GAME.FACTORY.classes) do
    for piece = 1,3 do
      local name = non_nil(HEXEN.FACTORY.XN_WEAPON_PIECES[CL][piece])
      add_quest(4, "weapon", name, "sub")
    end
  end

  join_map(rand.index_by_probs { 0,6,6, 4,0,2 }, 5)

  if episode == 5 then
    add_quest(6, "key", "k_axe", "main")
  end

  add_quest(6, "boss", level_list[6].boss_kind, "end")

  -- weapon quests

  for xxx,CL in ipairs(GAME.FACTORY.classes) do
    local weap_2 = non_nil(HEXEN.FACTORY.XN_WEAPON_NAMES[CL][2])
    local weap_3 = non_nil(HEXEN.FACTORY.XN_WEAPON_NAMES[CL][3])

    add_quest(rand.index_by_probs { 7, 1, 1 }, "weapon", weap_2, "sub")
    add_quest(rand.index_by_probs { 2, 7, 7 }, "weapon", weap_3, "sub")
  end

  -- item quests

  local item_list = { 
    "boots", "porkies", "repulser", "krater", -- these given twice
    "wings", "chaos", "banish",
    "servant", "incant", "defender" }

  local item_where = { 1,2,3,4,4,5,5,5,6,6 }

  assert(#item_list == #item_where)

  rand.shuffle(item_where)

  for i = 1,#item_list do
    local item  = item_list[i]
    local where = item_where[i]

    local Q = add_quest(where, "item", item, "sub")

    if rand.odds(25) then
      Q.is_secret = true
    end

    if i <= 4 and OB_CONFIG.size ~= "small" then
      local where2
      repeat
        where2 = rand.pick(item_where)
      until where2 ~= where

      add_quest(where2, "item", item, "sub")
    end
  end

  -- switch quests

  local switch_list = { "sw_demon", "sw_ball", "sw_cow",
                        "sw_sheep", "sw_moon" }

  rand.shuffle(switch_list)

  local QN_SWITCH_PROBS = { 700, 200, 40, 15, 5, 1 }
  
  for sw = 1,#switch_list do

    -- randomly select a level, preferring ones with fewest quests
    local lev_probs = {}
    for map = 1,6 do
      local qn = # level_list[map].quests
      if qn < 1 then qn = 1 end
      if qn > 6 then qn = 6 end

      lev_probs[map] = QN_SWITCH_PROBS[qn]
    end

    local map = rand.index_by_probs(lev_probs)

    add_quest(map, "switch", switch_list[sw], "main")
  end

  dump_levels()

  return level_list
end

------------------------------------------------------------

function HEXEN.factory_setup()

  rand.shuffle(HEXEN.FACTORY.XN_KEY_PAIRS)

  GAME.FACTORY = 
  {
    hexen_format = true,

    plan_size = 9,
    cell_size = 9,
    cell_min_size = 6,

    caps = { heights=true,   sky=true, 
             fragments=true, move_frag=true, rails=true,
             closets=true,   depots=true,
             switches=true,  liquids=true,
             teleporters=true,
             
             -- Hexen unique stuff
             polyobjs=true,  three_part_weapons=true,
             hubs=true,      action_script=true,
                             prefer_stairs=true,
           },

    SKY_TEX    = "F_SKY",
    ERROR_TEX  = "ABADONE",
    ERROR_FLAT = "F_033",

    episodes   = 5,
    level_func = HEXEN.get_factory_levels,

    classes  = { "fighter", "cleric", "mage" },

    things   = HEXEN.FACTORY.XN_THINGS,
    monsters = HEXEN.FACTORY.XN_MONSTERS,
    bosses   = HEXEN.FACTORY.XN_BOSSES,
    weapons  = HEXEN.FACTORY.XN_WEAPONS,

    dm = HEXEN.FACTORY.XN_DEATHMATCH,

    pickups = HEXEN.FACTORY.XN_PICKUPS,
    pickup_stats = { "health", "blue_mana", "green_mana" },
    niceness = HEXEN.FACTORY.XN_NICENESS,

    initial_model = HEXEN.FACTORY.XN_INITIAL_MODEL,

    combos    = HEXEN.FACTORY.XN_COMBOS,
    exits     = HEXEN.FACTORY.XN_EXITS,
    hallways  = HEXEN.FACTORY.XN_HALLWAYS,

    rooms     = HEXEN.FACTORY.XN_ROOMS,
    themes    = HEXEN.FACTORY.XN_THEMES,

    hangs     = HEXEN.FACTORY.XN_OVERHANGS,
    pedestals = HEXEN.FACTORY.XN_PEDESTALS,
    mats      = HEXEN.FACTORY.XN_MATS,
    rails     = HEXEN.FACTORY.XN_RAILS,

    liquids   = HEXEN.FACTORY.XN_LIQUIDS,
    switches  = HEXEN.FACTORY.XN_SWITCHES,
    doors     = HEXEN.FACTORY.XN_DOORS,
    key_doors = HEXEN.FACTORY.XN_KEY_DOORS,
    lifts     = HEXEN.FACTORY.XN_LIFTS,

    pics      = HEXEN.FACTORY.XN_PICS,
    images    = HEXEN.FACTORY.XN_IMAGES,
    lights    = HEXEN.FACTORY.XN_LIGHTS,
    wall_lights = HEXEN.FACTORY.XN_WALL_LIGHTS,

    door_fabs = HEXEN.FACTORY.XN_DOOR_PREFABS,
    wall_fabs = HEXEN.FACTORY.XN_WALL_PREFABS,
    sc_fabs   = HEXEN.FACTORY.XN_SCENERY_PREFABS,
    misc_fabs = HEXEN.FACTORY.XN_MISC_PREFABS,

    toughness_factor = 0.66,

    room_heights = { [96]=5, [128]=25, [192]=70, [256]=70, [320]=12 },
    space_range  = { 20, 90 },
    
    diff_probs = { [0]=20, [16]=40, [32]=80, [64]=30, [96]=5 },
    bump_probs = { [0]=30, [16]=30, [32]=20, [64]=5 },
    
    door_probs   = { out_diff=75, combo_diff=50, normal=15 },
    window_probs = { out_diff=80, combo_diff=50, normal=30 },
  }

  local SUB_LISTS =
  {
    "things",
    "monsters", "bosses", "weapons", "pickups",
    "combos",   "exits",  "hallways",
    "hangs",    "crates", "doors",    "mats",
    "lights",   "pics",   "liquids",  "rails",
    "scenery",  "rooms",   "themes",
    "sc_fabs",  "misc_fabs", "feat_fabs",
  }

  for zzz,sub in ipairs(SUB_LISTS) do
    if GAME.FACTORY[sub] then
      table.name_up(GAME.FACTORY[sub])
    end
  end

  GAME.FACTORY.PREFABS = HEXEN.FACTORY.PREFABS

  table.name_up(GAME.FACTORY.PREFABS)

  table.expand_copies(GAME.FACTORY.PREFABS)

  for name,P in pairs(GAME.FACTORY.PREFABS) do
    table.expand_copies(P.elements)
  
    -- set size values
    local f_deep = #P.structure
    local f_long = #P.structure[1]

    if not P.scale then
      P.scale = 16
    end

    if P.scale == 64 then
      P.long, P.deep = f_long, f_deep

    elseif P.scale == 16 then
      if (f_long % 4) ~= 0 or (f_deep % 4) ~= 0 then
        error("Prefab not a multiple of four: " .. tostring(P.name))
      end

      P.long = int(f_long / 4)
      P.deep = int(f_deep / 4)
    else
      error("Unsupported scale " .. tostring(P.scale) .. " in prefab: " .. tostring(P.name))
    end
  end

  table.name_up(GAME.FACTORY.PREFABS)

  local function pow_factor(info)
    return 5 + 19 * info.hp ^ 0.5 * (info.dm / sel(info.melee,80,50)) ^ 1.2
  end

  for name,info in pairs(GAME.FACTORY.monsters) do
    info.pow = pow_factor(info)

    gui.debugf("Monster %s : power %d\n", name, info.pow)

    local def = GAME.FACTORY.things[name]
    if not def then
      error("Monster has no definition?? : " .. tostring(name))
    end

    info.r = non_nil(def.r)
    info.h = non_nil(def.h)
  end

  local episode_num

  if OB_CONFIG.length == "single" then
    episode_num = 1
  elseif OB_CONFIG.length == "episode" then
    episode_num = GAME.FACTORY.min_episodes or 1
  else
    episode_num = GAME.FACTORY.episodes
  end

  -- build episode/level lists...should I be using the top-level map_num stuff? - Dasho
  GAME.FACTORY.all_levels = {}

  for epi = 1,episode_num do
    local levels = GAME.FACTORY.level_func(epi)
    for zzz, L in ipairs(levels) do
      table.insert(GAME.FACTORY.all_levels, L)
    end
  end

end

