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
  prob = 100

  structure =
  {
    "!!!!!", "....."
    "!!!!!", ".RRR."
    "!!!!!", ".RRR."
    "!!!!!", ".RRR."
    "!!!!!", "....."
  }

  new_room =
  {
  }
}


ROOT_2 =
{
  prob = 60

  structure =
  {
    "!!!!!", "....."
    "!!!!!", "./R%."
    "!!!!!", ".RRR."
    "!!!!!", ".RRR."
    "!!!!!", ".%R/."
    "!!!!!", "....."
  }

  diagonals =
  {
    ".R", "R."
    ".R", "R."
  }

  new_room =
  {
  }
}


ROOT_3 =
{
  prob = 20

  structure =
  {
    "!!!!!!", "......"
    "!!!!!!", ".RRRR."
    "!!!!!!", ".RRRR."
    "!!!!!!", ".RRRR."
    "!!!!!!", ".RRRR."
    "!!!!!!", "......"
  }

  new_room =
  {
  }
}


ROOT_L1 =
{
  prob = 40

  structure =
  {
    "!!!!!!", "......"
    "!!!!!!", ".RR##."
    "!!!!!!", ".RR%#."
    "!!!!!!", "#RRRR."
    "!!!!!!", ".%RRR."
    "!!!!!!", "..#..."
  }

  diagonals = { "R.", ".R" }

  new_room =
  {
  }
}


ROOT_T1 =
{
  prob = 40

  structure =
  {
    "!!!!!!", "..##.."
    "!!!!!!", "RRRRRR"
    "!!!!!!", "RRRRRR"
    "!!!!!!", "#%RR/#"
    "!!!!!!", "##RR##"
    "!!!!!!", "......"
  }

  diagonals = { ".R", "R." }

  new_room =
  {
  }
}


ROOT_CAGES4 =
{
  prob = 30

  structure =
  {
    "!!!!!", ".#.#."
    "!!!!!", "RCRCR"
    "!!!!!", "RRRRR"
    "!!!!!", "RRRRR"
    "!!!!!", "RCRCR"
    "!!!!!", ".#.#."
  }

  new_room =
  {
    symmetry = { dir=4, x=2, y=3, w=2 }
  }
}


ROOT_LIQUID_1A =
{
  prob = 30

  structure =
  {
    "!!!!!", "/RRR%"
    "!!!!!", "R/~%R"
    "!!!!!", "R~#~R"
    "!!!!!", "R%~/R"
    "!!!!!", "%RRR/"
  }

  diagonals =
  {
    ".R", "R."
    "R~", "~R"
    "R~", "~R"
    ".R", "R."
  }

  new_room =
  {
    symmetry = { kind="rotate", x=2, y=2, x2=4, y2=4 }
  }
}


ROOT_LIQUID_1B =
{
  template = "ROOT_LIQUID_1A"

  prob = 40

  structure =
  {
    "!!!!!", "/RRR%"
    "!!!!!", "R/~%R"
    "!!!!!", "R~C~R"
    "!!!!!", "R%~/R"
    "!!!!!", "%RRR/"
  }
}


ROOT_LIQUID_CAGE2 =
{
  prob = 20

  structure =
  {
    "!!!!!", "!RRR%"
    "!!!!!", "#~~%R"
    "!!!!!", "#C%~R"
    "!!!!!", "#C/~R"
    "!!!!!", "#~~/R"
    "!!!!!", "!RRR/"
  }

  diagonals =
  {
    "R."
    "~R"
    "C~"
    "C~"
    "~R"
    "R."
  }

  new_room =
  {
  }
}


ROOT_LIQUID_CAGE3 =
{
  prob = 70

  structure =
  {
    "!!!!!", "#####"
    "!!!!!", "#/C~R"
    "!!!!!", "#C/~R"
    "!!!!!", "#~~/R"
    "!!!!!", "!RRRR"
    "!!!!!", "!RRR/"
  }

  diagonals =
  {
    "#C"
    "C~"
    "~R"
    "R!"
  }

  new_room =
  {
  }
}


------------------------------------------


GROW_2 =
{
  prob = 100
  prob_skew = 2

  structure =
  {
    "....", ".11."
    "x11x", "x11x"
  }
}


GROW_3 =
{
  prob = 20
  prob_skew = 2

  structure =
  {
    ".....", ".111."
    "x111x", "x111x"
  }
}


GROW_BLOB_1 =
{
  prob = 15

  structure =
  {
    "....", "1111"
    "....", "1111"
    "x11x", "x11x"
  }
}


GROW_FUNNEL_1 =
{
  prob = 25

  structure =
  {
    "....", "1111"
    "....", "%11/"
    ".11.", ".11."
  }

  diagonals = { ".1", "1." }
}


GROW_FUNNEL_2 =
{
  prob = 25

  structure =
  {
    "....", "#11#"
    "....", "/11%"
    "1111", "1111"
  }

  diagonals = { "#1", "1#" }
}


GROW_CURVE_1 =
{
  prob = 100

  structure =
  {
    "1.", "1%"
    "1.", "11"
    "1.", "1/"
  }

  diagonals = { "1.", "1." }
}


GROW_CURVE_2 =
{
  prob = 70

  structure =
  {
    "..", "A%"
    "%.", "%A"
    "1.", "1A"
    "/.", "/A"
    "..", "A/"
  }

  diagonals =
  {
          "A."
    "1.", "1A"
    "1.", "1A"
          "A."
  }
}


GROW_DIAG_BLOB1 =
{
  prob = 10

  structure =
  {
    "...", "AA%"
    "%..", "%AA"
    "x%.", "x%A"
    "x1.", "x1."
  }

  diagonals =
  {
          "A."
    "1.", "1A"
    "1.", "1A"
  }
}


GROW_DIAG_BLOB2 =
{
  prob = 20

  structure =
  {
    "...", "AA%"
    "%..", "%AA"
    "x%.", "x%A"
    "x1.", "x1."
    "x/.", "x/A"
    "/..", "/AA"
    "...", "AA/"
  }

  diagonals =
  {
          "A."
    "1.", "1A"
    "1.", "1A"
    "1.", "1A"
    "1.", "1A"
          "A."
  }
}


GROW_NEWAREA_1 =
{
  prob = 40

  structure =
  {
    "....", ".AA."
    "x11x", "x11x"
  }
}


GROW_STAIRS_2 =
{
  prob = 20
  prob_skew = 3

  structure =
  {
    "....", ".AA."
    "x..x", "x^^x"
    "x11x", "x11x"
  }
}


GROW_STAIRS_3 =
{
  prob = 15
  prob_skew = 3

  structure =
  {
    "...", "AAA"
    "...", "^^^"
    "111", "111"
  }
}


GROW_STAIRPAIR_2 =
{
  prob = 10
  prob_skew = 3

  structure =
  {
    "...", "AAA"
    "...", "^C^"
    "111", "111"
  }
}


GROW_STAIRPAIR_3 =
{
  prob = 2

  structure =
  {
    "..x..", "AAxAA"
    ".....", "A^#^A"
    "x111x", "x111x"
  }
}


GROW_STAIR_CURVE =
{
  prob = 200

  structure =
  {
    "x..x", "xA%x"
    "1%..", "1%A%"
    "11..", "11>A"
    "1/..", "1/A/"
    "x..x", "xA/x"
  }

  diagonals =
  {
          "A."
    "1.", "1A", "A."
    "1.", "1A", "A."
          "A."
  }
}


GROW_DBLSTAIR_CURVE =
{
  prob = 200

  structure =
  {
    "...", "SA%"
    "1%.", "1%A"
    "11.", "11A"
    "1/.", "1/A"
    "...", "SA/"
  }

  diagonals =
  {
          "A."
    "1.", "1A"
    "1.", "1A"
          "A."
  }

  stair1_5 = { from_dir=2, dest_dir=6 }
  stair1_1 = { from_dir=8, dest_dir=6 }
}


GROW_STAIR_POOL1 =
{
  prob = 10

  structure =
  {
    "x.....", "xAAA%."
    "1.....", "1/~%A."
    "1.....", "1~~~A."
    "1.....", "1%~/A#"
    "1.....", "1>AA/."
    "x....x", "x##..x"
  }

  diagonals =
  {
    "A."
    "1~", "~A"
    "1~", "~A"
    "A."
  }
}


GROW_STAIR_POOL2 =
{
  -- this one is higher than STAIR_POOL1

  prob = 35

  structure =
  {
    "x.....", "xAAA%."
    "1.....", "1/~%A."
    "1.....", "1~~~A."
    "1.....", "1%~/A#"
    "1.....", "1>>A/."
    "x....x", "x##..x"
  }

  diagonals =
  {
    "A."
    "1~", "~A"
    "1~", "~A"
    "A."
  }
}


GROW_STAIR_HUGE =
{
  prob = 20

  structure =
  {
    "x....x", "xAAAAx"
    "......", "~%^^/~"
    "......", "~~^^~~"
    "......", "~/^^%~"
    "x1111x", "x1111x"
  }

  diagonals =
  {
    "~A", "A~"
    "~1", "1~"
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


SPROUT_CASTLE_1 =
{
  prob = 4000
  env = "outdoor"

  structure =
  {
    "!!xxxx!!", "11xxxx11"
    "!!!!!!!!", "11RRRR11"
    "!!!!!!!!", "11RRRR11"
    "!!!!!!!!", "11111111"
    "xxx11xxx", "xxx11xxx"
  }

  new_room =
  {
    env = "building"

    conn = { x=5, y=3, w=2, dir=2 }

--  symmetry = { x=4, y=3, w=2, dir=8 }
  }
}


SPROUT_CASTLE_2 =
{
  prob = 8000
  env = "outdoor"

  structure =
  {
    "!!!!!!!!", "11RRRR11"
    "!!!!!!!!", "11RRRR11"
    "!!!!!!!!", "11%RR/11"
    "!!!!!!!!", "11111111"
    "xxx11xxx", "xxx11xxx"
  }

  diagonals = { ".R", "R." }

  new_room =
  {
    env = "building"

    conn = { x=5, y=3, w=2, dir=2 }

    symmetry = { x=4, y=3, w=2, dir=8 }
  }
}


SPROUT_JOINER_2x1 =
{
  prob = 1000

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
    from_dir = 2
  }
}


SPROUT_DOUBLE_TEST =
{
  prob = 0  -- not supported yet

  structure =
  {
    "....", "RR%."
    "....", "RRR%"
    "11..", "11RR"
    "11..", "11RR"
  }

  diagonals =
  {
    "R.", "R."
  }

  new_room =
  {
    conn  = { x=2, y=3, w=2, dir=2 }
    conn2 = { x=3, y=1, w=2, dir=4 }

    symmetry = { x=3, y=3, dir=9 }
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


-- this one is experimental crud
DECORATE_SMOOTHER =
{
  prob = 0

  structure =
  {
    ".", "."
  }

  auxiliary =
  {
    pass = "smoothing"

    count = 20
  }
}

AUX_SMOOTHER_1 =
{
  pass = "smoothing"

  prob = 50

  structure =
  {
    "xxx", "xxx"
    "1..", "1%."
    "11x", "11x"
  }

  diagonals =
  {
    "1."
  }
}


DECORATE_CAGE_1 =
{
  prob = 10

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

  closet = { from_dir=2 }
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

  closet = { from_dir=2 }
}


DECORATE_LIQUID_1 =
{
  prob = 0

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

