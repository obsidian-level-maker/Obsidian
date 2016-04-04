------------------------------------------------------------------------
--  GRAMMAR RULES
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2015-2016 Andrew Apted
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
------------------------------------------------------------------------


SHAPE_GRAMMAR =
{

ROOT_1 =
{
  prob = 50

  structure =
  {
    "!!!!", "...."
    "!!!!", ".RR."
    "!!!!", ".RR."
    "!!!!", "...."
  }

  new_room =
  {
    symmetry =
    {
      list =
      {
        { dir=4, x=2, y=2, w=2 }
--    { dir=9, x=2, y=2 }
--    { kind="rotate", x=2, y=2, x2=3, y2=3 }
      }
    }
  }
}


------------------------------------------


GROW_1 =
{
  prob = 250

  structure =
  {
    "....", ".11."
    "x11x", "x11x"
  }
}


GROW_3 =
{
  prob = 20

  structure =
  {
    "....", "1111"
    "....", "1111"
    "x11x", "x11x"
  }
}


GROW_DIAGTEST_1 =
{
  prob = 10

  structure =
  {
    "x.", "x."
    "1.", "1%"
    "1.", "1/"
    "x.", "x."
  }

  diagonals = { "1.", "1." }

  __auxiliary =
  {
    pass = "diag_test"

    count = { 1,6 }
  }
}


AUX_DIAGTEST_1 =
{
  pass = "diag_test"

  prob = 40

  structure =
  {
    "/.", "1%"
    "..", "%/"
  }

  diagonals =
  {
    "1.", "1."
    ".1", "1."
  }
}



GROW_MIR_TEST =  -- REMOVE
{
  prob = 0

  structure =
  {
    "....", "1111"
    "....", "~~~~"
    "....", "1~~1"
    "1111", "1111"
  }
}



GROW_NEWAREA_1 =
{
  prob = 5

  structure =
  {
    "....", ".AA."
    "x11x", "x11x"
  }
}


GROW_STAIRS_2 =
{
  prob = 25

  structure =
  {
    "....", ".AA."
    "x..x", "x^^x"
    "x11x", "x11x"
  }
}


------------------------------------------


SPROUT_1 =
{
  prob = 50

  structure =
  {
    "....", ".RR."
    "....", ".RR."
    "x11x", "x11x"
    "x11x", "x11x"
  }

  new_room =
  {
    conn = { x=3, y=3, w=2, dir=2 }

    symmetry = { x=2, y=3, w=2, dir=8 }
  }
}


SPROUT_JOINER_2x1 =
{
  prob = 300

  structure =
  {
    "....", ".RR."
    "....", ".RR."
    "....", ".JJ."
    "x11x", "x11x"
  }

  new_room =
  {
    conn = { x=3, y=3, w=2, dir=2 }

    symmetry = { x=2, y=3, w=2, dir=8 }
  }

  joiner =
  {
    dir = 8  -- must be opposite to conn.dir
  }
}


SPROUT_SYMMETRY_TEST =
{
  prob = 30

  structure =
  {
    ".....", ".RRR."
    ".....", ".RRR."
    "x111x", "x111x"
  }

  new_room =
  {
    conn = { x=4, y=2, w=3, dir=2 }

    symmetry = { x=3, y=2, dir=8 }
  }
}


SPROUT_DIAG_1 =
{
  prob = 0

  structure =
  {
    "....", "...."
    "....", ".RR."
    "11..", "1%R."
    "11..", "11.."
  }

  diagonals =
  {
    "1R"
  }

  new_room =
  {
    conn = { x=2, y=2, dir=1 }

    symmetry = { x=2, y=2, dir=1 }
  }
}


SPROUT_DIAG_2 =
{
  prob = 0

  structure =
  {
    "...", "..."
    "...", "RR."
    "%..", "%R."
  }

  diagonals =
  {
    "1.", "1R"
  }

  new_room =
  {
    conn = { x=1, y=1, dir=1 }

    symmetry = { x=1, y=1, dir=1 }
  }
}


SPROUT_HALL_1 =
{
  prob = 10

  structure =
  {
    "11....", "11...."
    "11....", "11111."
    "11....", "11..1."
    "xx....", "xx..1."
    "xx....", "xx.RRR"
    "xx....", "xx.RRR"
  }

  new_room =
  {
    conn = { x=5, y=2, dir=8 }

    symmetry = { x=5, y=2, dir=8 }
  }
}


------------------------------------------


DECORATE_CAGE_1 =
{
  prob = 5  -- FIXME

  structure =
  {
    "...", "..."
    "...", ".C."
    "x1x", "x1x"
  }

  auxiliary =
  {
    pass = "cage_grow"

    count = { 1,4 }
  }
}


AUX_CAGE_GROW1 =
{
  pass = "cage_grow"

  prob = 50

  structure =
  {
    "C.", "CC"
    "11", "11"
  }
}


AUX_CAGE_GROW2 =
{
  pass = "cage_grow"

  prob = 50

  structure =
  {
    "C.", "CC"
    "1.", "1C"
  }
}


AUX_CAGE_GROW3 =
{
  pass = "cage_grow"

  prob = 50

  structure =
  {
    "...", "C%."
    "C..", "CC."
    "11x", "11x"
  }

  diagonals =
  {
    "C."
  }
}


DECORATE_CLOSET_2x1 =
{
  prob = 40

  structure =
  {
    "..", "TT"
    "11", "11"
  }

  closet = { from_dir=2, from_area=1 }
}


DECORATE_CLOSET_2x2 =
{
  prob = 100

  structure =
  {
    "..", "TT"
    "..", "TT"
    "11", "11"
  }

  closet = { from_dir=2, from_area=1 }
}


DECORATE_LIQUID_1 =
{
  prob = 10

  structure =
  {
    ".", "."
    ".", "~"
    "1", "1"
  }

  auxiliary =
  {
    pass = "liquid_grow"

    count = { 3,8 }
  }
}


AUX_LIQUID_GROW1 =
{
  pass = "liquid_grow"

  prob = 25

  structure =
  {
    ".", "."
    ".", "~"
    "~", "~"
  }
}


AUX_LIQUID_GROW2 =
{
  pass = "liquid_grow"

  prob = 50

  structure =
  {
    "~.", "~~"
    "1.", "1~"
  }
}


AUX_LIQUID_GROW3 =
{
  pass = "liquid_grow"

  prob = 50

  structure =
  {
    "~~", "~~"
    "1.", "1~"
  }
}


--[[
DECORATE_LIQUID_1 =
{
  prob = 250

  structure =
  {
    ".", "~"
    "1", "1"
  }
}

DECORATE_LIQUID_2 =
{
  prob = 500

  structure =
  {
    ".", "~"
    "~", "~"
  }
}
--]]

--- Hallway testing crud ---
--[[

HALL_A_FORWARD =
{
  prob = 0

  structure =
  {
    "...", "..."
    "...", ".1."
    ".1.", ".1."
  }
}


HALL_A_BRANCH =
{
  prob = 0

  structure =
  {
    ".....", "....."
    ".....", "..1.."
    "11111", "11111"
  }
}



HALL_A_TURN =
{
  prob = 0

  structure =
  {
    "...", ".11"
    ".1.", ".1."
  }
}


HALL_A_CROSS =
{
  prob = 0

  structure =
  {
    "...", ".1."
    "...", "111"
    ".1.", ".1."
  }
}


HALL_A_RECONNECT =
{
  prob = 0

  structure =
  {
    "11111", "11111"
    ".....", "..1.."
    "11111", "11111"
  }
}
--]]


-- end of SHAPE_GRAMMAR
}

