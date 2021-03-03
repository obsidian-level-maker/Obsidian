------------------------------------------------------------------------
--  GRAMMAR RULES
------------------------------------------------------------------------
--
--  Oblige Level Maker // ObAddon
--
--  Copyright (C) 2015-2017 Andrew Apted
--  Copyright (C) 2018-2019 MsrSgtShooterPerson
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
------------------------------------------------------------------------

HEXEN.SHAPE_GRAMMAR =
{

ROOT_1 =
{
  prob = 50,

  structure =
  {
    "!!!", "...",
    "!!!", ".R.",
    "!!!", "...",
  },

--[[  new_room =
  {
    symmetry  = { kind="mirror", x=3, y=2, dir=8 },
    symmetry2 = { kind="rotate", x=2, y=2, x2=4, y2=4 },
  }]]

},


-----------------------------------------

GROW_1 =
{
  prob = 400, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    "...", ".1.",
    "x1x", "x1x",
  },
},

GROW_2 =
{
  prob = 400, --Non-MSSP default: 100,
  prob_skew = 2,

  structure =
  {
    "....", ".11.",
    "x11x", "x11x",
  },
},


------------------------------------------


SPROUT_DIRECT_1 =
{
  prob = 3, --3,

  structure =
  {
    "....", "....",
    "....", ".RR.",
    "x11x", "x11x",
  },

  new_room =
  {
    conn = { x=2, y=1, w=2, dir=8 },

    symmetry = { x=2, y=3, w=2, dir=8 },
  },
},


SPROUT_DIRECT_2_EMERGENCY =
{
  emergency = true,

  -- high prob to force this rule to be tried fairly early
  prob = 500,

  structure =
  {
    "..", "RR",
    "..", "RR",
    "11", "11",
  },

  new_room =
  {
    conn = { x=1, y=1, w=2, dir=8 },

    symmetry = { x=1, y=2, w=2, dir=8 },
  },
},


SPROUT_TELEPORTER_2x2 =
{
  prob = 700,

  structure =
  {
    "..", "TT",
    "..", "TT",
    "11", "11",
    "11", "11",
  },

  teleporter = true,

  closet =
  {
    from_dir = 2,
  },
},

SQUARE_OUT_FROM_CORNER_2X =
{
  pass = "square_out",

  prob = 100,

  structure =
  {
    "1.","11",
    "x1","x1",
  },
},

DECORATE_CLOSET_2x1 =
{
  prob = 60, --40,
  prob_skew = 2,

  structure =
  {
    "..", "TT",
    "11", "11",
  },

  closet = { from_dir=2 },
},

FILLER_1 =
{
  pass = "filler",
  prob = 40, --30,

  structure =
  {
    "1.", "1.",
    "1.", "11",
    "11", "11",
  },
},

SMOOTHER_1 =
{
  pass = "smoother",
  prob = 75, --50,

  structure =
  {
    "x.", "x.",
    "1.", "1%",
    "11", "11",
  },

  diagonals = { "1." },
},

}
