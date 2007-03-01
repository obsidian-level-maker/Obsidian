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

DOOR =
{
  structure =
  {
    "#LaaaaaaaaM#",
    "#TddddddddT#",
    "#TddddddddT#",
    "#LbbbbbbbbM#",
  },

  elements =
  {
    -- steps
    a = { f_h=8, c_rel="door_top", c_h=-8,
          f_tex="frame_floor", c_tex="frame_ceil", l_tex="step" },
    b = { copy="a" },

    -- door
    d = { copy="a", c_rel="floor", c_h=8, u_tex="door", c_tex = "door_ceil",
          kind="door_kind", tag="tag",
        },

    -- track
    T = { solid="track" },

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
    "#LaaaaM#",
    "#tddddt#",
    "#tddddt#",
    "#LbbbbM#",
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
    a = { l_tex="step", light=128, c_h=-48, },

    b = { copy="a", f_h= -8, c_h=-56 },
    c = { copy="a", f_h=-16, c_h=-64, light=192 },
    d = { copy="a", f_h=-24, c_h=-64 },

    e = { copy="a", f_h=-32, c_h=0, light=160, f_tex="carpet", c_tex="sky" },

    -- light
    L = { solid="light" },
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
},


} -- PREFABS

