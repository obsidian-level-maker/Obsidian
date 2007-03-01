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
    "WMaaaaaaaaMW", --!!!
    "WTddddddddTW",
    "WTddddddddTW",
    "WLbbbbbbbbMW",
  },

  elements =
  {
    -- wall
    W = { solid="wall" },

    -- steps
    a = { f_h=8, c_rel="door_top", c_h=8, f_tex="frame_floor", l_tex="step" },
    b = { copy="a" },

    -- door
    d = { copy="a", c_rel="f_h", c_h=8, u_tex="door", c_tex = "door_ceil" },

    -- track
    T = { solid="track" },

    -- lights
    L = { solid="lite", [6]={ l_tex="light" } },
    M = { solid="wall", [4]={ l_tex="light" } },
  },
},

DOOR_NARROW =
{
  copy="DOOR",

  structure =
  {
    "##aaaa##",
    "#tddddt#",
    "#tddddt#",
    "##bbbb##",
  },
},



} -- PREFABS

