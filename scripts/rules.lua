------------------------------------------------------------------------
--  GRAMMAR RULES
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2015-2017 Andrew Apted
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
}


ROOT_2 =
{
  prob = 60*0

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
}


ROOT_L1 =
{
  prob = 40

  structure =
  {
    "!!!!!", ".RR##"
    "!!!!!", ".RR##"
    "!!!!!", "#RRRR"
    "!!!!!", "#RRRR"
    "!!!!!", "###.."
  }
}


ROOT_L2 =
{
  prob = 40*0

  structure =
  {
    "!!!!!", ".RR##"
    "!!!!!", ".RR%#"
    "!!!!!", "#RRRR"
    "!!!!!", ".%RRR"
    "!!!!!", "..#.."
  }

  diagonals = { "R.", ".R" }
}


ROOT_T1 =
{
  prob = 40

  structure =
  {
    "!!!!!!", "..##.."
    "!!!!!!", "RRRRRR"
    "!!!!!!", "RRRRRR"
    "!!!!!!", "##RR##"
    "!!!!!!", "##RR##"
  }
}


ROOT_T2 =
{
  prob = 40*0

  structure =
  {
    "!!!!!!", "..##.."
    "!!!!!!", "RRRRRR"
    "!!!!!!", "RRRRRR"
    "!!!!!!", "#%RR/#"
    "!!!!!!", "##RR##"
  }

  diagonals = { ".R", "R." }
}


ROOT_CAGES4 =
{
  prob = 35

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

  cage_mode = "fancy"
}


ROOT_LIQUID_1A =
{
  prob = 25*0

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

  prob = 30*0

  structure =
  {
    "!!!!!", "/RRR%"
    "!!!!!", "R/~%R"
    "!!!!!", "R~C~R"
    "!!!!!", "R%~/R"
    "!!!!!", "%RRR/"
  }

  cage_mode = "fancy"
}


ROOT_LIQUID_CAGE2 =
{
  prob = 20*0

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

  cage_mode = "fancy"
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
    "!!!!!", "!RRRR"
  }

  diagonals =
  {
    "#C"
    "C~"
    "~R"
  }

  cage_mode = "fancy"
}


------------------------------------------


EXIT_1 =
{
  pass = "exit_root"
  prob = 60

  structure =
  {
    "!!!!!", "....."
    "!!!!!", ".RRR."
    "!!!!!", ".RRR."
    "!!!!!", ".RRR."
    "!!!!!", "....."
  }

  absolute_pos = "top"
  no_rotate = true

  new_room =
  {
    usage = "boss"
    symmetry = { x=3, y=2, dir=8 }
  }

  auxiliary =
  {
    pass = "exit1_closet"
    count = 1
  }

  auxiliary2 =
  {
    pass = "exit1_area"
    count = 1
  }
}


EXIT1_CLOSET =
{
  pass = "exit1_closet"
  prob = 50

  structure =
  {
    "...", "TTT"
    "...", "TTT"
    "111", "111"
  }

  no_rotate = true

  closet = { from_dir=2, usage="goal" }
}


EXIT1_AREA_A =
{
  pass = "exit1_area"
  prob = 50

  structure =
  {
    ".111.", "#111#"
    ".111.", "#111#"
    ".111.", "#111#"
    "x...x", "xvvvx"
    "x...x", "xAAAx"
    "x...x", "xAAAx"
    "x...x", "xAAAx"
  }

  no_rotate = true
}


EXIT1_AREA_B =
{
  pass = "exit1_area"
  prob = 50

  structure =
  {
    ".111.", "A111A"
    ".111.", "A111A"
    ".111.", "A111A"
    ".....", "AvvvA"
    ".....", "AAAAA"
  }

  no_rotate = true
}


EXIT1_AREA_C =
{
  pass = "exit1_area"
  prob = 50

  structure =
  {
    "...111...", "AA<111>AA"
    "...111...", "AA<111>AA"
    "...111...", "AA<111>AA"
    "xxx...xxx", "xxx###xxx"
  }

  no_rotate = true
}


EXIT_2 =
{
  pass = "exit_root"
  prob = 30

  structure =
  {
    "!!!!!", ".###."
    "!!!!!", ".RRR."
    "!!!!!", ".RRR."
    "!!!!!", ".RRR."
    "!!!!!", "....."
  }

  absolute_pos = "corner"
  no_rotate = true

  new_room =
  {
    usage = "boss"
  }

  auxiliary =
  {
    pass = "exit2_closet"
    count = 1
  }

  auxiliary2 =
  {
    pass = "exit2_decor"
    count = 1
  }
}


EXIT2_CLOSET =
{
  pass = "exit2_closet"
  prob = 50

  structure =
  {
    "1..", "1TT"
    "1..", "1TT"
    "1..", "1TT"
  }

  no_rotate = true

  closet = { from_dir=4, usage="goal" }
}


EXIT2_DECOR =
{
  pass = "exit2_decor"
  prob = 50

  structure =
  {
    "..1", "TT1"
    "..1", "TT1"
    "..1", "TT1"
  }

  no_rotate = true

  closet = { from_dir=6 }
}


EXIT_3 =
{
  pass = "exit_root"
  prob = 30

  structure =
  {
    "!!!!!", "....."
    "!!!!!", "....."
    "!!!!!", "....."
    "!!!!!", "....."
    "!!!!!", "....."
    "!!!!!", ".RRR."
    "!!!!!", "#RRR#"
    "!!!!!", ".RRR."
    "!!!!!", "....."
  }

  absolute_pos = "top"
  no_rotate = true

  new_room =
  {
    usage = "boss"
    symmetry = { x=3, y=2, dir=8 }
  }

  auxiliary =
  {
    pass = "exit3_area"
    count = 1
  }
}


EXIT3_AREA_A =
{
  pass = "exit3_area"
  prob = 50

  structure =
  {
    ".......", "#AAAAA#"
    ".......", "#A...A#"
    "..111..", "#A111A#"
  }

  no_rotate = true

  auxiliary =
  {
    pass = "exit3_closet"
    count = 1
  }

  auxiliary2 =
  {
    pass = "exit3_decor"
    count = 1
  }
}


EXIT3_AREA_B =
{
  pass = "exit3_area"
  prob = 50

  structure =
  {
    ".......", "#/AAA%#"
    ".......", "#A/#%A#"
    "..111..", "#A111A#"
  }

  no_rotate = true

  diagonals =
  {
    "#A", "A#"
    "A#", "#A"
  }

  auxiliary =
  {
    pass = "exit1_closet"
    count = 1
  }
}


EXIT3_CLOSET =
{
  pass = "exit3_closet"
  prob = 50

  structure =
  {
    "11111", "11111"
    "1...1", "1TTT1"
  }

  no_rotate = true

  closet = { from_dir=8, usage="goal" }
}


EXIT1_DECOR =
{
  pass = "exit3_decor"
  prob = 50

  structure =
  {
    ".....", "#TTT#"
    "11111", "11111"
  }

  no_rotate = true

  closet = { from_dir=2 }
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


GROW_2_EMERGENCY =
{
  emergency = true

  prob = 200

  structure =
  {
    "..", "11"
    "11", "11"
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


GROW_4 =
{
  prob = 30
  prob_skew = 2
  skip_prob = 50

  structure =
  {
    "....", "1111"
    ".11.", "1111"
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
  prob = 25*0

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
  prob = 25*0

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
  prob = 80*0
  skip_prob = 25

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
  prob = 45*0
  skip_prob = 50

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


GROW_CURVE_TUNNEL =
{
  prob = 1*0

  structure =
  {
    "%...", "%#/1"
    "1...", "1111"
    "/...", "/#%1"
  }

  diagonals =
  {
    "1.", "1#", "#1"
    "1.", "1#", "#1"
  }
}


GROW_CURVE_TUNNEL_EMERGENCY =
{
  template = "GROW_CURVE_TUNNEL"

  emergency = true

  prob = 100
}


GROW_DIAG_BLOB1 =
{
  prob = 10*0

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
  prob = 20*0

  structure =
  {
    "...", "AA%"
    "%..", "%AA"
    "x%.", "x%A"
    "x1.", "x1#"
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


GROW_AREA_1 =
{
  prob = 40

  structure =
  {
    "....", ".AA."
    "x11x", "x11x"
  }
}


GROW_AREA_2 =
{
  prob = 6
  skip_prob = 50

  structure =
  {
    "...", "AAA"
    "11.", "11A"
    "11.", "11A"
  }
}


GROW_STAIR_2 =
{
  prob = 12
  prob_skew = 3

  structure =
  {
    "....", ".AA."
    "x..x", "x^^x"
    "x11x", "x11x"
  }
}


GROW_STAIR_3 =
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

  cage_mode = "fancy"
}


GROW_STAIRPAIR_4 =
{
  prob = 300
  skip_prob = 60

  structure =
  {
    ".......", "AAAAAAA"
    ".......", "^^111^^"
    ".......", "^^111^^"
    "..111..", "1111111"
  }
}

GROW_STAIRPAIR_4B =
{
  prob = 200
  skip_prob = 60

  structure =
  {
    ".......", "AAAAAAA"
    ".......", "^^111^^"
    ".......", "^^111^^"
    ".11111.", "1111111"
  }
}


GROW_STAIRPAIR_4C =
{
  prob = 50
  skip_prob = 60

  structure =
  {
    ".......", "AAAAAAA"
    ".......", "^^~~~^^"
    ".......", "^^~~~^^"
    ".11111.", "1111111"
  }
}


GROW_STAIRPAIR_5 =
{
  prob = 120
  skip_prob = 50

  structure =
  {
    ".....", "AAAAA"
    ".....", "^111A"
    ".....", "^111A"
    "11...", "1111A"
    "11...", "11>>A"
  }

---!!!  diagonals = { "1A" }
}


GROW_STAIR_CURVE =
{
  prob = 250*0
  skip_prob = 50

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
  prob = 200*0
  skip_prob = 50

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

  stair1_5 = { shape="L", from_dir=2, dest_dir=6 }
  stair1_1 = { shape="L", from_dir=8, dest_dir=6 }
}


GROW_STAIR_POOL1 =
{
  prob = 25*0
  skip_prob = 80

  structure =
  {
    "x.....", "xAAA%."
    "1.....", "1/~%A."
    "1.....", "1~~~A."
    "1.....", "1~~/A#"
    "1.....", "1>AA/."
    "x....x", "x##..x"
  }

  diagonals =
  {
    "A."
    "1~", "~A"
    "~A"
    "A."
  }
}


GROW_STAIR_POOL2 =
{
  -- this one is higher than STAIR_POOL1

  prob = 30*0
  skip_prob = 80

  structure =
  {
    "x.....", "xAAA%."
    "1.....", "1/~%A."
    "1.....", "1~~~A."
    "1.....", "1~~/A#"
    "1.....", "1>>A/."
    "x....x", "x##..x"
  }

  diagonals =
  {
    "A."
    "1~", "~A"
    "~A"
    "A."
  }
}


GROW_STAIR_SIDE2 =
{
  prob = 70
  prob_skew = 3
  skip_prob = 40

  structure =
  {
    "....", "#AAA"
    "..1x", "#^1x"
    "..1x", "#^1x"
    "..1x", "#11x"
  }
}


GROW_STAIR_SIDE3 =
{
  prob = 70
  prob_skew = 3
  skip_prob = 40

  structure =
  {
    "...", ".AA"
    "...", ".AA"
    "..1", "#^1"
    "..1", "#^1"
    "..1", "#^1"
    "..1", "#11"
  }
}


GROW_STAIR_HUGE =
{
  prob = 30*0
  skip_prob = 60

  structure =
  {
    "x....x", "xAAAAx"
    "......", "/~^^~%"
    "......", "~~^^~~"
    "......", "%~^^~/"
    "x1111x", "x1111x"
  }

  diagonals =
  {
    ".~", "~."
    ".~", "~."
  }
}


GROW_XXX_BRIDGE1 =
{
  prob = 0

  structure =
  {
    "x..x", "x~~x"
    "x...", "x~~A"
    "1...", "1==A"
    "x...", "x~~A"
    "x..x", "x~~x"
  }
}


--[[ test crud......

GROW_LIQUID_1 =
{
  prob = 200

  structure =
  {
    "....", ".11."
    "....", ".~~."
    "x11x", "x11x"
    "x11x", "x11x"
  }

  auxiliary =
  {
    pass = "liquid_grow"

    count = { 4,8 }
  }

  xx_auxiliary2 =
  {
    pass = "liquid_newarea"

    count = { 1,3 }
  }
}


AUX_LIQUID_1 =
{
  pass = "liquid_grow"
  prob = 50

  structure =
  {
    "1.", "11"
    "~.", "~~"
    "1.", "11"
  }
}


AUX_LIQUID_2 =
{
  pass = "liquid_grow"
  prob = 50

  structure =
  {
    "...", ".11"
    "1..", "1/~"
    "~..", "~/1"
    "1..", "11."
  }

  diagonals =
  {
    "1~", "~1"
  }
}


AUX_LIQUID_3 =
{
  pass = "liquid_grow"
  prob = 0

  structure =
  {
    "...", "..."
    "~.~", "~~~"
  }

  diagonals =
  {
    ".~", "~."
  }
}
--]]


------------------------------------------


SPROUT_DIRECT_1 =
{
  prob = 2

  structure =
  {
    "....", ".RR."
    "....", ".RR."
    "x11x", "x11x"
  }

  new_room =
  {
    conn = { x=2, y=1, w=2, dir=8 }

    symmetry = { x=2, y=3, w=2, dir=8 }
  }
}


SPROUT_DIRECT_2 =
{
  prob = 100

  structure =
  {
    "....", ".RR."
    "....", ".RR."
    "x11x", "x11x"
    "x11x", "x11x"
  }

  new_room =
  {
    conn = { x=2, y=2, w=2, dir=8 }

    symmetry = { x=2, y=3, w=2, dir=8 }
  }
}


SPROUT_DIRECT_2_EMERGENCY =
{
  emergency = true

  -- high prob to force this rule to be tried fairly early
  prob = 1000

  structure =
  {
    "..", "RR"
    "..", "RR"
    "11", "11"
  }

  new_room =
  {
    conn = { x=1, y=1, w=2, dir=8 }

    symmetry = { x=1, y=2, w=2, dir=8 }
  }
}


SPROUT_DIRECT_3 =
{
  prob = 400

  structure =
  {
    ".....", ".RRR."
    ".....", ".RRR."
    "x111x", "x111x"
  }

  new_room =
  {
    conn = { x=2, y=1, w=3, dir=8 }

    symmetry = { x=3, y=2, dir=8 }
  }
}


SPROUT_DIRECT_4 =
{
  prob = 4000

  structure =
  {
    "....", "RRRR"
    "....", "RRRR"
    "1111", "1111"
  }

  new_room =
  {
    conn = { x=1, y=1, w=4, dir=8 }

    symmetry = { x=2, y=3, w=2, dir=8 }
  }
}


SPROUT_CASTLE_2 =
{
  env = "outdoor"
  prob = 200

  structure =
  {
    "!!!!!!!!", "11RRRR11"
    "!!!!!!!!", "11%RR/11"
    "!!!!!!!!", "11111111"
    "xxx11xxx", "xxx11xxx"
  }

  diagonals = { "1R", "R1" }

  new_room =
  {
    env = "building"

    conn = { x=4, y=2, w=2, dir=8 }
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
    conn  = { x=1, y=2, w=2, dir=8 }
    conn2 = { x=2, y=2, w=2, dir=6 }

    symmetry = { x=3, y=3, dir=9 }
  }
}


SPROUT_SYMMETRY_3 =
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
    conn = { x=2, y=1, w=3, dir=8 }

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
    conn = { x=2, y=2, dir=9 }

    symmetry = { x=2, y=2, dir=1 }
  }
}


SPROUT_JOINER_2x1 =
{
  prob = 360

  structure =
  {
    "....", ".RR."
    "....", ".RR."
    "x..x", "xJJx"
    "x11x", "x11x"
  }

  new_room =
  {
    symmetry = { x=2, y=3, w=2, dir=8 }
  }

  joiner =
  {
    from_dir = 2
  }
}


SPROUT_JOINER_3x1 =
{
  prob = 1500

  structure =
  {
    ".....", ".RRR."
    ".....", ".RRR."
    "x...x", "xJJJx"
    "x111x", "x111x"
  }

  new_room =
  {
    symmetry = { x=3, y=3, dir=8 }
  }

  joiner =
  {
    from_dir = 2
  }
}


SPROUT_JOINER_4x1 =
{
  prob = 3000

  structure =
  {
    "....", "RRRR"
    "....", "RRRR"
    "....", "JJJJ"
    "1111", "1111"
  }

  new_room =
  {
    symmetry = { x=2, y=3, w=2, dir=8 }
  }

  joiner =
  {
    from_dir = 2
  }
}


SPROUT_JOINER_2x2 =
{
  prob = 100

  structure =
  {
    "....", ".RR."
    "....", ".RR."
    "x..x", "xJJx"
    "x..x", "xJJx"
    "x11x", "x11x"
  }

  new_room =
  {
    symmetry = { x=2, y=4, dir=8 }
  }

  joiner =
  {
    from_dir = 2
  }
}


SPROUT_JOINER_3x2 =
{
  prob = 3000

  structure =
  {
    ".....", ".RRR."
    ".....", ".RRR."
    "x...x", "xJJJx"
    "x...x", "xJJJx"
    "x111x", "x111x"
  }

  new_room =
  {
    symmetry = { x=3, y=4, dir=8 }
  }

  joiner =
  {
    from_dir = 2
  }
}


SPROUT_JOINER_L =
{
  prob = 100

  structure =
  {
    "....", "####"
    "....", "RRJJ"
    "....", "RRJJ"
    "xx11", "xx11"
  }

  new_room =
  {
  }

  joiner =
  {
    shape = "L"
    from_dir = 2
    dest_dir = 4
  }
}


SPROUT_TELEPORTER_2x2 =
{
  prob = 700

  structure =
  {
    "..", "TT"
    "..", "TT"
    "11", "11"
    "11", "11"
  }

  teleporter = true

  closet =
  {
    from_dir = 2
  }
}


------------------------------------------


DECORATE_CAGE_1 =
{
  prob = 10
  env  = "!cave"

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
  prob_skew = 2

  structure =
  {
    "..", "TT"
    "11", "11"
  }

  closet = { from_dir=2 }
}


DECORATE_CLOSET_2x2 =
{
  prob = 60
  prob_skew = 3

  structure =
  {
    "..", "TT"
    "..", "TT"
    "11", "11"
  }

  closet = { from_dir=2 }
}


DECORATE_CLOSET_3x1 =
{
  prob = 60
  prob_skew = 2

  structure =
  {
    "...", "TTT"
    "111", "111"
  }

  closet = { from_dir=2 }
}


DECORATE_CLOSET_3x2 =
{
  prob = 60
--prob_skew = 4

  structure =
  {
    "...", "TTT"
    "...", "TTT"
    "111", "111"
  }

  closet = { from_dir=2 }
}



------------------------------------------
--   Landscape stuff
------------------------------------------


PARK_ROOT_3x3 =
{
  prob = 50

  structure =
  {
    "!!!", "RRR"
    "!!!", "RRR"
    "!!!", "RRR"
  }
}


PARK_GROW_1 =
{
  prob = 100

  structure =
  {
    "....", ".11."
    "....", ".11."
    "....", ".11."
    "x11x", "x11x"
  }
}

PARK_GROW_2 =
{
  prob = 30

  structure =
  {
    "....", ".11."
    "....", ".11."
    "x11x", "x11x"
  }
}


PARK_GROW_3 =
{
  prob = 500

  structure =
  {
    ".....", ".111."
    ".....", ".111."
    "x111x", "x111x"
  }
}


FILLER_1 =
{
  pass = "filler"
  prob = 30

  structure =
  {
    "1..", "1.."
    "1..", "11."
    "111", "111"
  }
}


FILLER_2 =
{
  pass = "filler"
  prob = 60

  structure =
  {
    "1.1", "111"
    "x1x", "x1x"
  }
}


FILLER_3 =
{
  pass = "filler"
  prob = 30

  structure =
  {
    "1..1", "1111"
    "1111", "1111"
  }
}


SMOOTHER_1 =
{
  pass = "smoother"
  prob = 50

  structure =
  {
    "x.", "x."
    "1.", "1%"
    "11", "11"
  }

  diagonals = { "1." }
}


------------------------------------------
--   Cave stuff
------------------------------------------

CAVE_ROOT_5x5 =
{
  prob = 10

  structure =
  {
    "!!!!!", "RRRRR"
    "!!!!!", "RRRRR"
    "!!!!!", "RRRRR"
    "!!!!!", "RRRRR"
    "!!!!!", "RRRRR"
  }
}


CAVE_ROOT_6x6 =
{
  prob = 100

  structure =
  {
    "!!!!!!", "RRRRRR"
    "!!!!!!", "RRRRRR"
    "!!!!!!", "RRRRRR"
    "!!!!!!", "RRRRRR"
    "!!!!!!", "RRRRRR"
    "!!!!!!", "RRRRRR"
  }
}


SPROUT_DIRECT_2_cave =
{
  prob = 100

  structure =
  {
    ".....", "RRRRR"
    ".....", "RRRRR"
    ".....", "RRRRR"
    ".....", "RRRRR"
    ".....", "RRRRR"
    "xx11x", "xx11x"
  }

  new_room =
  {
    env = "cave"

    conn = { x=3, y=1, w=2, dir=8 }
  }
}


SPROUT_DIRECT_3_cave =
{
  prob = 300

  structure =
  {
    ".....", "RRRRR"
    ".....", "RRRRR"
    ".....", "RRRRR"
    ".....", "RRRRR"
    ".....", "RRRRR"
    "x111x", "x111x"
  }

  new_room =
  {
    env = "cave"

    conn = { x=2, y=1, w=3, dir=8 }
  }
}


SPROUT_JOINER_2x1_cave =
{
  prob = 500

  structure =
  {
    ".....", "RRRRR"
    ".....", "RRRRR"
    ".....", "RRRRR"
    ".....", "RRRRR"
    ".....", "RRRRR"
    "xx..x", "xxJJx"
    "xx11x", "xx11x"
  }

  new_room =
  {
    env = "cave"
  }

  joiner =
  {
    from_dir = 2
  }
}


SPROUT_JOINER_3x1_cave =
{
  prob = 2000

  structure =
  {
    ".....", "RRRRR"
    ".....", "RRRRR"
    ".....", "RRRRR"
    ".....", "RRRRR"
    ".....", "RRRRR"
    "x...x", "xJJJx"
    "x111x", "x111x"
  }

  new_room =
  {
    env = "cave"
  }

  joiner =
  {
    from_dir = 2
  }
}


--[[ disabled for now....

SPROUT_JOINER_3x2_cave =
{
  prob = 4000

  structure =
  {
    ".....", "RRRRR"
    ".....", "RRRRR"
    ".....", "RRRRR"
    ".....", "RRRRR"
    ".....", "RRRRR"
    "x...x", "xJJJx"
    "x...x", "xJJJx"
    "x111x", "x111x"
  }

  new_room =
  {
    env = "cave"
  }

  joiner =
  {
    from_dir = 2
  }
}
--]]


CAVE_GROW_3x1 =
{
  prob = 50

  structure =
  {
    "...", "111"
    "111", "111"
  }
}


CAVE_GROW_3x2 =
{
  prob = 50

  structure =
  {
    "...", "111"
    "...", "111"
    "111", "111"
  }
}


CAVE_GROW_4x1 =
{
  prob = 100

  structure =
  {
    "....", "1111"
    "1111", "1111"
  }
}


CAVE_GROW_4x2 =
{
  prob = 100

  structure =
  {
    "....", "1111"
    "....", "1111"
    "1111", "1111"
  }
}


CAVE_GROW_5x1 =
{
  prob = 150

  structure =
  {
    ".....", "11111"
    "11111", "11111"
  }
}


CAVE_GROW_5x2 =
{
  prob = 150

  structure =
  {
    ".....", "11111"
    ".....", "11111"
    "11111", "11111"
  }
}


CAVE_GROW_FILL_A =
{
  prob = 0

  structure =
  {
    "1.", "11"
    "11", "11"
  }
}


CAVE_GROW_FILL_B =
{
  prob = 0

  structure =
  {
    "1xx", "1xx"
    "1.x", "11x"
    "111", "111"
  }
}


------------------------------------------
--   Hallway stuff
------------------------------------------

SPROUT_hallway1 =
{
  prob = 0

  structure =
  {
    "...", ".@."
    "...", ".H."
    "111", "111"
  }

  new_room =
  {
    env = "hallway"

    conn = { x=2, y=1, dir=8 }

    grow_pass = "hall_1"
  }
}


HALL_1_GROW_I1 =
{
  pass = "hall_1"
  prob = 50

  structure =
  {
    ".", "@"
    "@", "H"
    "1", "1"
  }
}


HALL_1_GROW_L1 =
{
  pass = "hall_1"
  prob = 50

  structure =
  {
    "....", "...."
    "..@.", ".@H."
    "..1.", "..1."
  }
}


HALL_1_GROW_T1 =
{
  pass = "hall_1"
  prob = 50

  structure =
  {
    ".....", "....."
    "..@..", ".@H@."
    "..1..", "..1.."
  }
}


HALL_1_GROW_P1 =
{
  pass = "hall_1"
  prob = 5

  structure =
  {
    ".....", "....."
    ".....", "....."
    ".....", "..@.."
    "..@..", ".@H@."
    "..1..", "..1.."
  }
}


HALL_1_SPROUT_A =
{
  pass = "hall_1_sprout"
  prob = 100

  structure =
  {
    "...", "RRR"
    "...", "RRR"
    "x@x", "xHx"
    "x1x", "x1x"
  }

  new_room =
  {
    conn = { x=2, y=2, dir=8 }
  }
}


SPROUT_hallway2 =
{
  prob = 0

  structure =
  {
    "..", ".."
    "..", "@@"
    "..", "HH"
    "..", "HH"
    "11", "11"
  }

  new_room =
  {
    env = "hallway"

    conn = { x=1, y=1, w=2, dir=8 }

    grow_pass = "hall_2"
  }
}


HALL_2_GROW_I1 =
{
  pass = "hall_2"
  prob = 50

  structure =
  {
    "..", ".."
    "..", "@@"
    "..", "HH"
    "@@", "HH"
    "11", "11"
  }
}


HALL_2_GROW_L1 =
{
  pass = "hall_2"
  prob = 50

  structure =
  {
    "....", ".@HH"
    "..@@", ".@HH"
    "xx11", "xx11"
  }
}


HALL_2_GROW_T1 =
{
  pass = "hall_2"
  prob = 25

  structure =
  {
    "......", ".@HH@."
    "..@@..", ".@HH@."
    "xx11xx", "xx11xx"
  }
}


HALL_2_GROW_P1 =
{
  pass = "hall_2"
  prob = 5

  structure =
  {
    "xx..xx", "xx..xx"
    "xx..xx", "xx@@xx"
    "......", ".@HH@."
    "..@@..", ".@HH@."
    "xx11xx", "xx11xx"
  }
}


HALL_2_SPROUT_A =
{
  pass = "hall_2_sprout"
  prob = 100

  structure =
  {
    "....", "RRRR"
    "....", "RRRR"
    "x..x", "xHHx"
    "x@@x", "xHHx"
    "x11x", "x11x"
  }

  new_room =
  {
    conn = { x=2, y=3, w=2, dir=8 }
  }
}


HALL_2_SPROUT_B =
{
  pass = "hall_2_sprout"
  prob = 10

  structure =
  {
    "....", "RRRR"
    "....", "RRRR"
    "..xx", "HHxx"
    "@@xx", "HHxx"
    "11xx", "11xx"
  }

  new_room =
  {
    conn = { x=1, y=3, w=2, dir=8 }
  }
}


-- end of SHAPE_GRAMMAR
}

