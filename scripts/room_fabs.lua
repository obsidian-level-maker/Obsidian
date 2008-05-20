----------------------------------------------------------------
--  ROOM FABS
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2008 Andrew Apted
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

ROOM_FABS =
{


BUILDING_BASIC =
{
  basic_kind = "room",

  width_range  = { 2, 5 },
  height_range = { 2, 5 },
  area_range   = { 4, 16 },

  structure = { "B" },

  grow_columns = { 1 },
  grow_rows    = { 1 },

  elements =
  {
    B = { kind="building" },
  },
},


SURROUND_GROUND =
{
  basic_kind = "ground",

  width_range  = { 4, 16 },
  height_range = { 4, 16 },

  structure =
  {
    "ggg",
    "gAg",
    "ggg",
  },

  grow_columns = { 2 },
  grow_rows    = { 2 },

  elements =
  {
    g = { kind="ground" },
    A = { kind="sub" },
  },
},

SURROUND_LIQUID =
{
  basic_kind = "liquid",

  width_range  = { 4, 16 },
  height_range = { 4, 16 },

  structure =
  {
    "lll",
    "lAl",
    "lll",
  },

  grow_columns = { 2 },
  grow_rows    = { 2 },

  elements =
  {
    l = { kind="liquid" },
    A = { kind="sub" },
  },
},


U_SHAPE_GROUND =
{
  basic_kind = "ground",

  width_range  = { 4, 16 },
  height_range = { 4, 16 },

  structure =
  {
    "ggg",
    "gAg",
  },

  grow_columns = { 2 },
  grow_rows    = { 2 },

  elements =
  {
    g = { kind="ground" },
    A = { kind="sub" },
  },
},

U_SHAPE_LIQUID =
{
  basic_kind = "liquid",

  width_range  = { 4, 16 },
  height_range = { 4, 16 },

  structure =
  {
    "lll",
    "lAl",
  },

  grow_columns = { 2 },
  grow_rows    = { 2 },

  elements =
  {
    l = { kind="liquid" },
    A = { kind="sub" },
  },
},


L_SHAPE_GROUND =
{
  basic_kind = "ground",

  width_range  = { 4, 16 },
  height_range = { 4, 16 },

  structure =
  {
    "gg",
    "gA",
  },

  grow_columns = { 2 },
  grow_rows    = { 2 },

  elements =
  {
    g = { kind="ground" },
    A = { kind="sub" },
  },
},

L_SHAPE_LIQUID =
{
  basic_kind = "liquid",

  width_range  = { 4, 16 },
  height_range = { 4, 16 },

  structure =
  {
    "ll",
    "lA",
  },

  grow_columns = { 2 },
  grow_rows    = { 2 },

  elements =
  {
    l = { kind="liquid" },
    A = { kind="sub" },
  },
},


CROSS_GROUND =
{
  basic_kind = "ground",

  width_range  = { 5, 19 },
  height_range = { 5, 19 },

  structure =
  {
    "AgB",
    "ggg",
    "CgD",
  },

  grow_columns = { 1, 3 },
  grow_rows    = { 1, 3 },

  elements =
  {
    g = { kind="ground" },

    A = { kind="sub" },
    B = { kind="sub" },
    C = { kind="sub" },
    D = { kind="sub" },
  },
},

CROSS_HALL =
{
  basic_kind = "hall",

  width_range  = { 5, 19 },
  height_range = { 5, 19 },

  structure =
  {
    "AhB",
    "hhh",
    "ChD",
  },

  grow_columns = { 1, 3 },
  grow_rows    = { 1, 3 },

  elements =
  {
    h = { kind="hall" },

    A = { kind="sub" },
    B = { kind="sub" },
    C = { kind="sub" },
    D = { kind="sub" },
  },
},



} -- end of ROOM_FABS 
