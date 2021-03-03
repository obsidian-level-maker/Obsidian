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
--  as published by the Free Software Foundation; either version 2
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
  prob = 50

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
    symmetry  = { kind="mirror", x=3, y=2, dir=8 }
    symmetry2 = { kind="rotate", x=2, y=2, x2=4, y2=4 }
  }

  auxiliary =
  {
    pass = "start_closet3"
  }
}


ROOT_3 =
{
  prob = 40

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
    symmetry  = { kind="mirror", x=3, y=2, w=2, dir=8 }
    symmetry2 = { kind="rotate", x=2, y=2, x2=5, y2=5 }
  }

  auxiliary =
  {
    pass = "start_closet4"
  }
}


ROOT_4 =
{
  prob = 20

  structure =
  {
    "!!!!!!", "......"
    "!!!!!!", "./RR%."
    "!!!!!!", ".RRRR."
    "!!!!!!", ".RRRR."
    "!!!!!!", ".%RR/."
    "!!!!!!", "......"
  }

  diagonals =
  {
    ".R", "R."
    ".R", "R."
  }

  new_room =
  {
    symmetry  = { kind="mirror", x=3, y=2, w=2, dir=8 }
    symmetry2 = { kind="rotate", x=2, y=2, x2=5, y2=5 }
  }

  auxiliary =
  {
    pass = "start_closet2"
  }
}


ROOT_L1 =
{
  prob = 1

  structure =
  {
    "!!!!!", ".RR#."
    "!!!!!", ".RR##"
    "!!!!!", "#RRRR"
    "!!!!!", "#RRRR"
    "!!!!!", "###.."
  }
}


ROOT_T2 =
{
  prob = 25 --5

  structure =
  {
    "!!!!!!", "......"
    "!!!!!!", "RRRRRR"
    "!!!!!!", "RRRRRR"
    "!!!!!!", "#%RR/#"
    "!!!!!!", "##RR##"
  }

  diagonals = { ".R", "R." }

  new_room =
  {
    symmetry = { kind="mirror", x=3, y=1, w=2, dir=8 }
  }

  auxiliary =
  {
    pass = "start_closet2"
  }
}


ROOT_LIQUID_1A =
{
  prob = 4 --7 --5

  structure =
  {
    "!!!!!", "/RRR%"
    "!!!!!", "R/~%R"
    "!!!!!", "R~~~R"
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
    symmetry  = { kind="mirror", x=3, y=1, dir=8 }
    symmetry2 = { kind="rotate", x=2, y=2, x2=4, y2=4 }
  }

  auxiliary =
  {
    pass = "start_closet3"
  }
}


ROOT_LIQUID_1B =
{
  template = "ROOT_LIQUID_1A"

  prob = 1

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


START_CLOSET_2x2 =
{
  pass = "start_closet2"
  prob = 50

  structure =
  {
    "..", "TT"
    "..", "TT"
    "11", "11"
  }

  closet = { from_dir=2, usage="start" }
}


START_CLOSET_3x2 =
{
  pass = "start_closet3"
  prob = 50

  structure =
  {
    "...", "TTT"
    "...", "TTT"
    "111", "111"
  }

  closet = { from_dir=2, usage="start" }
}


START_CLOSET_4x2 =
{
  pass = "start_closet4"
  prob = 50

  structure =
  {
    "....", "TTTT"
    "....", "TTTT"
    "1111", "1111"
  }

  closet = { from_dir=2, usage="start" }
}


------------------------------------------


EXIT_1 =
{
  prob = 75 --60

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
    usage = "boss"
    symmetry = { x=3, y=2, dir=8 }
  }

  auxiliary =
  {
    pass = "exit1_closet"
  }

  auxiliary2 =
  {
    pass = "exit1_area"
  }
}


EXIT1_CLOSET =
{
  pass = "exit1_closet"
  prob = 66 --50

  structure =
  {
    "...", "TTT"
    "...", "TTT"
    "111", "111"
  }

  closet = { from_dir=2, usage="exit" }
}


EXIT1_AREA_A =
{
  pass = "exit1_area"
  prob = 95 --50

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

}

EXIT1_AREA_B =
{
  pass = "exit1_area"
  prob = 80 --50

  structure =
  {
    ".111.", "A111A"
    ".111.", "A111A"
    ".111.", "A111A"
    ".....", "AvvvA"
    ".....", "AAAAA"
  }

}


EXIT1_AREA_C =
{
  pass = "exit1_area"
  prob = 65 --50

  structure =
  {
    "...111...", "AA<111>AA"
    "...111...", "AA<111>AA"
    "...111...", "AA<111>AA"
    "xxx...xxx", "xxx###xxx"
  }

}


EXIT_2 =
{
  prob = 30

  structure =
  {
    "!!!!!", ".###."
    "!!!!!", ".RRR."
    "!!!!!", ".RRR."
    "!!!!!", ".RRR."
    "!!!!!", "....."
  }

  new_room =
  {
    usage = "boss"
  }

  auxiliary =
  {
    pass = "exit2_closet"
  }

  auxiliary2 =
  {
    pass = "exit2_decor"
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

  closet = { from_dir=4, usage="exit" }
}


EXIT2_DECOR =
{
  pass = "exit2_decor"
  prob = 70 --50

  structure =
  {
    "..1", "TT1"
    "..1", "TT1"
    "..1", "TT1"
  }

  closet = { from_dir=6 }
}


EXIT_3 =
{
  env  = "building"
  prob = 30 --20

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

  new_room =
  {
    usage = "boss"
    symmetry = { x=3, y=2, dir=8 }
  }

  auxiliary =
  {
    pass = "exit3_area"
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

  auxiliary =
  {
    pass = "exit3_closet"
  }

  auxiliary2 =
  {
    pass = "exit3_decor"
  }
}


EXIT3_AREA_B =
{
  pass = "exit3_area"
  prob = 70 --50

  structure =
  {
    ".......", "#/AAA%#"
    ".......", "#A/#%A#"
    "..111..", "#A111A#"
  }

  diagonals =
  {
    "#A", "A#"
    "A#", "#A"
  }

  auxiliary =
  {
    pass = "exit1_closet"
  }
}


EXIT3_CLOSET =
{
  pass = "exit3_closet"
  prob = 70 --50

  structure =
  {
    "11111", "11111"
    "1...1", "1TTT1"
  }

  closet = { from_dir=8, usage="exit" }
}


EXIT3_DECOR =
{
  pass = "exit3_decor"
  prob = 70 --50

  structure =
  {
    ".....", "#TTT#"
    "11111", "11111"
  }

  closet = { from_dir=2 }
}


------------------------------------------


GROW_2 =
{
  prob = 400 --Non-MSSP default: 100
  prob_skew = 2

  structure =
  {
    "....", ".11."
    "x11x", "x11x"
  }
}


GROW_3 =
{
  prob = 250 --Non-MSSP default: 50
  prob_skew = 2

  structure =
  {
    ".....", ".111."
    "x111x", "x111x"
  }
}


GROW_4 =
{
  prob = 250 --Non-MSSP default: 50
  prob_skew = 2
  skip_prob = 25 --50

  structure =
  {
    "....", "1111"
    ".11.", "1111"
  }
}


GROW_BLOB_1 =
{
  prob = 200 --Non-MSSP default: 25

  structure =
  {
    "....", "1111"
    "....", "1111"
    "x11x", "x11x"
  }
}

 --7.50 stuff

GROW_DIAG_BLOB1 =
{
  prob = 45

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
  prob = 65 --45

  structure =
  {
    "...", "AA%"
    "%..", "%AA"
    "x%.", "x%A"
    "x1x", "x1x"
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

-- End 7.50 stuff

GROW_FUNNEL_2 =
{
  prob = 25 --5
  skip_prob = 15 --50

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
  prob = 75 --50
  prob_skew = 3
  skip_prob = 5 --25

  structure =
  {
    "1.", "1%"
    "1.", "11"
    "1.", "11"
    "1.", "1/"
  }

  diagonals = { "1.", "1." }
}


GROW_AREA_1 =
{
  prob = 200 --40

  structure =
  {
    "....", ".AA."
    "x11x", "x11x"
  }
}


GROW_AREA_2 =
{
  prob = 50 --6
  skip_prob = 30 --50

  structure =
  {
    "...", "AAA"
    "11.", "11A"
    "11.", "11A"
  }
}


GROW_DIAG_WING =
{
  prob = 70 --40
  prob_skew = 2
  skip_prob = 5 --35

  env = "building"

  structure =
  {
    "x...", "x#AA"
    "x...", "x/AA"
    "1%..", "1%/#"
    "11xx", "11xx"
  }

  diagonals =
  {
    "#A"
    "1.", "1A", "A#"
  }
}


GROW_BIG_CAGE =
{
  prob = 8
  skip_prob = 30
  aversion = 10

  structure =
  {
    "....", "1111"
    "....", "1CC1"
    "....", "1CC1"
    "....", "1111"
    "x11x", "x11x"
  }

  cage_mode = "fancy"
}


GROW_CAGEPAIR_1 =
{
  prob = 8
  skip_prob = 30

  structure =
  {
    "....", "AAAA"
    "....", "CAAC"
    "....", "AAAA"
    "x11x", "x11x"
  }

  cage_mode = "fancy"
}


GROW_CAGEPAIR_2 =
{
  prob = 8
  skip_prob = 75 --30
  aversion = 5

  structure =
  {
    "....", "AAAA"
    "....", "CAAC"
    "....", "AAAA"
    "....", "CAAC"
    "....", "AAAA"
    "x11x", "x11x"
  }

  cage_mode = "fancy"
}


GROW_LIQUID_CAGE3 =
{
  prob = 10
  skip_prob = 20 --33

  structure =
  {
    "....", "/C~1"
    "....", "C/~1"
    "....", "~~/1"
    "....", "1111"
    "1111", "1111"
  }

  diagonals =
  {
    ".C"
    "C~"
    "~1"
  }

  cage_mode = "fancy"
}


GROW_STAIR_2 =
{
  prob = 10 --12
  prob_skew = 3
  skip_prob = 45 --35

  structure =
  {
    "..", "AA"
    "..", "^^"
    "11", "11"
  }
}


GROW_STAIR_3 =
{
  prob = 5 --5
  prob_skew = 3
  skip_prob = 45 --35

  structure =
  {
    "...", "AAA"
    "...", "^^^"
    "111", "111"
  }
}


GROW_NARROWSTAIR_1 =
{
  prob = 25 --10
  prob_skew = 3
  skip_prob = 7 --25

  structure =
  {
    "...", "AAA"
    "...", "1^1"
    "111", "111"
  }
}


GROW_NARROWSTAIR_2 =
{
  prob = 20 --10
  prob_skew = 3
  skip_prob = 15 --70

  z_dir = "up"

  structure =
  {
    "...", "AAA"
    "...", "1^1"
    "...", "1^1"
    "111", "111"
  }
}


GROW_CAGESTAIR_1 =
{
  prob = 8
  skip_prob = 50
  aversion = 5

  structure =
  {
    "...", "AAA"
    "...", "^C^"
    "111", "111"
  }

  cage_mode = "fancy"
}


GROW_CAGESTAIR_2 =
{
  prob = 8
  skip_prob = 70
  aversion = 5

  structure =
  {
    "....", "AAAA"
    "....", "^CC^"
    "1111", "1111"
  }

  cage_mode = "fancy"
}


GROW_CAGESTAIR_3 =
{
  prob = 8
  skip_prob = 70
  aversion = 5

  structure =
  {
    "....", "AAAA"
    "....", "^CC^"
    "....", "^CC^"
    "1111", "1111"
  }

  cage_mode = "fancy"
}


GROW_STAIRPAIR_4 =
{
  prob = 80 --200
  skip_prob = 40 --60
  aversion = 3

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
  prob = 85 --120
  skip_prob = 40 --60
  aversion = 3

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
  prob = 40 --50
  skip_prob = 40 --60

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
  prob = 20 --20
  skip_prob = 45 --50
  aversion = 5

  z_dir = "up"

  structure =
  {
    ".....", "AAAAA"
    ".....", "^111A"
    ".....", "^111A"
    "11...", "1111A"
    "11...", "11>>A"
  }
}


-- FIXME : rename, as these are really L-shape new-floor rules
GROW_STAIRPAIR_5E =
{
  prob = 60 --80
  skip_prob = 33
  aversion = 4

  z_dir = "up"

  structure =
  {
    "....", "AAAA"
    "....", "^11A"
    "....", "^11A"
    "11..", "111A"
    "11..", "111A"
  }
}


GROW_STAIRPAIR_5F =
{
  prob = 25 --30
  skip_prob = 50
  aversion = 4

  z_dir = "up"

  structure =
  {
    "....", "AAAA"
    "....", "11^A"
    "....", "11^A"
    "11..", "111A"
    "11..", "111A"
  }
}


GROW_STAIRPAIR_5G =
{
  prob = 10
  skip_prob = 50
  aversion = 4

  z_dir = "up"

  structure =
  {
    "....", "AAAA"
    "....", "11^A"
    "....", "11^A"
    "11..", "11^A"
    "11..", "111A"
  }
}


GROW_STAIRPAIR_5D =
{
  prob = 20
  skip_prob = 50
  aversion = 4

  z_dir = "down"

  structure =
  {
    "...xx", "AAAxx"
    "...xx", "^AAxx"
    ".....", "^AAAA"
    "11...", "11AAA"
    "11...", "11>>A"
  }
}


GROW_STAIR_POOL2 =
{
  -- this one is higher than STAIR_POOL1

  prob = 5 --7
  skip_prob = 85 --75
  aversion = 15

  structure =
  {
    "x....", "xAAA%"
    "1....", "1/~%A"
    "1....", "1~~~A"
    "1....", "1~~/A"
    "1....", "1>>A/"
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
  prob = 80
  prob_skew = 3
  skip_prob = 30 --30

  z_dir = "up"

  structure =
  {
    "...","AAA"
    "...","AAA"
    ".1x","^1x"
    ".1x","^1x"
    ".1x","11x"
  }
}


GROW_STAIR_SIDE3 =
{
  prob = 50
  prob_skew = 3
  skip_prob = 70 --50
  aversion  = 7

  structure =
  {
    "..","AA"
    "..","AA"
    ".1","^1"
    ".1","^1"
    ".1","^1"
    ".1","11"
  }
}


GROW_STAIR_HUGE =
{
  prob = 8 --8
  skip_prob = 65 --80
  aversion  = 15 --20

  structure =
  {
    "x....x", "xAAAAx"
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
  prob = 30 --50

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
  prob = 30 --50

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
  prob = 3 --3

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
  prob = 500

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


--[[SPROUT_DIRECT_THIN_EMERGENCY =
{
  emergency = true

  prob = 250

  aversion = 65

  env = "!cave"

  structure =
  {
    "..","RR"
    "..","RR"
    "..","11"
    "x1","x1"
  }

  new_room =
  {
    conn = { x=1, y=2, w=2, dir=8 }
  }
}]]


SPROUT_DIRECT_THROUGH_2X_LIQUID =
{
  emergency = true

  prob = 400

  structure =
  {
    "..","RR"
    "..","RR"
    "~~","11"
    "~~","11"
    "11","11"
  }

  new_room =
  {
    conn = { x=1, y=3, w=2, dir=8 }

    symmetry = { x=1, y=5, w=2, dir=8 }
  }
}


SPROUT_DIRECT_THROUGH_1X_LIQUID =
{
  emergency = true

  prob = 400

  structure =
  {
    "..","RR"
    "..","RR"
    "~~","11"
    "11","11"
  }

  new_room =
  {
    conn = { x=1, y=2, w=2, dir=8 }

    symmetry = { x=1, y=3, w=2, dir=8 }
  }
}


SPROUT_DIRECT_FROM_DIAGONAL =
{
  emergency = true

  prob = 250

  structure =
  {
    "xx..","xxRR"
    "xx..","xxRR"
    "xx..","xx11"
    "x...","x/11"
    "1%.x","11/x"
    "11xx","11xx"
  }

  diagonals =
  {
    ".1","1."
    "1.","1."
  }

  new_room =
  {
    conn = { x=3, y=4, w=2, dir=8 }
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
  theme = "!urban"
  env = "outdoor"
  prob = 350 --200

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


--[[SPROUT_DOUBLE_TEST =
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
}]]


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


SPROUT_JOINER_2x1 =
{
  prob = 350 --360

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
  prob = 2000 --100

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


SPROUT_JOINER_4x2 =
{
  prob = 2500

  structure =
  {
    "......", ".RRRR."
    "......", ".RRRR."
    "x....x", "xJJJJx"
    "x....x", "xJJJJx"
    "x1111x", "x1111x"
  }

  new_room =
  {
    symmetry = { x=4, y=4, dir=8 }
  }

  joiner =
  {
    from_dir = 2
  }
}


SPROUT_JOINER_2x3 =
{
  prob = 800

  structure =
  {
    "....", ".RR."
    "....", ".RR."
    "x..x", "xJJx"
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


SPROUT_JOINER_L =
{
  prob = 60 --40 --30

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
  prob = 4
  skip_prob = 75
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


DECORATE_CAGE_2 =
{
  prob = 10
  env  = "!cave"

  structure =
  {
    "....", "...."
    "....", ".CC."
    "x11x", "x11x"
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

  prob = 50 --50

  structure =
  {
    "..", "/C"
    "C.", "CC"
    "11", "11"
  }

  diagonals =
  {
    ".C"
  }
}


AUX_CAGE_GROW4 =
{
  pass = "cage_grow"

  prob = 35

  structure =
  {
    "C.","CC"
    "C.","CC"
    "11","11"
  }
}


AUX_CAGE_GROW5 =
{
  pass = "cage_grow"

  prob = 35

  structure =
  {
    "C.","C%"
    "C.","CC"
    "11","11"
  }

  diagonals =
  {
    "C."
  }
}


DECORATE_CLOSET_2x1 =
{
  prob = 60 --40
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
  prob = 120 --80
  prob_skew = 2

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
  prob = 80 --60
--prob_skew = 4

  structure =
  {
    "...", "TTT"
    "...", "TTT"
    "111", "111"
  }

  closet = { from_dir=2 }
}


DECORATE_CLOSET_4x2 =
{
  prob = 60

  structure =
  {
    "....", "TTTT"
    "....", "TTTT"
    "1111", "1111"
  }

  closet = { from_dir=2 }
}


------------------------------------------
--   Landscape stuff
------------------------------------------


PARK_ROOT_3x3 =
{
  prob = 90 --50

  structure =
  {
    "!!!", "RRR"
    "!!!", "RRR"
    "!!!", "RRR"
  }
}


PARK_GROW_1 =
{
  prob = 200 --100

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
  prob = 80 --30

  structure =
  {
    "....", ".11."
    "....", ".11."
    "x11x", "x11x"
  }
}


PARK_GROW_3 =
{
  prob = 600 --500

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
  prob = 40 --30

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
  prob = 75 --60

  structure =
  {
    "1.1", "111"
    "x1x", "x1x"
  }
}


FILLER_3 =
{
  pass = "filler"
  prob = 45 --30

  structure =
  {
    "1..1", "1111"
    "1111", "1111"
  }
}


SMOOTHER_1 =
{
  pass = "smoother"
  prob = 75 --50

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
  prob = 20 --10

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
  prob = 75 --50

  structure =
  {
    "...", "111"
    "111", "111"
  }
}


CAVE_GROW_3x2 =
{
  prob = 80 --50

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
  prob = 200 --150

  structure =
  {
    ".....", "11111"
    ".....", "11111"
    "11111", "11111"
  }
}


------------------------------------------
--   Hallway stuff
------------------------------------------

SPROUT_narrow_hallway =
{
  prob = 2500 -- 1100 --900
  skip_prob = 10

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

    hall_type = "narrow"

    grow_pass = "hall_1"
  }
}


HALL_1_GROW_I1 =
{
  pass = "hall_1"
  prob = 90 --50

  structure =
  {
    "!", "@"
    "@", "H"
    "1", "1"
  }
}


HALL_1_GROW_L1 =
{
  pass = "hall_1"
  prob = 90 --50

  structure =
  {
    ".#.", ".#."
    "!@#", "@H#"
    ".1.", ".1."
  }

  link1_2 = { dest_dir=4 }
}


HALL_1_GROW_T1 =
{
  pass = "hall_1"
  prob = 90 --50

  structure =
  {
    ".#.", ".#."
    "!@!", "@H@"
    ".1.", ".1."
  }

  hallway = { keep_shape_prob=90 }

  link1_2 = { dest_dir=4 }
  link3_2 = { dest_dir=6 }
}


HALL_1_GROW_P1 =
{
  pass = "hall_1"
  prob = 30 --5

  structure =
  {
    ".!.", ".@."
    "!@!", "@H@"
    ".1.", ".1."
  }

  hallway = { keep_shape_prob=50 }

  link1_2 = { dest_dir=4 }
  link3_2 = { dest_dir=6 }
  link2_3 = { dest_dir=8 }
}


HALL_1_SPROUT_A =
{
  pass = "hall_1_sprout"
  prob = 120 --100

  structure =
  {
    "....", "RRRR"
    "....", "RRRR"
    "x@xx", "xHxx"
    "x1xx", "x1xx"
  }

  new_room =
  {
    conn = { x=2, y=2, dir=8 }

    symmetry = { kind="mirror", x=2, y=3, w=2, dir=8 }
  }
}


SPROUT_wide_hallway =
{
  prob = 3200 --1800 --1500
  skip_prob = 20

  structure =
  {
    "..", ".."
    "..", "@@"
    "..", "HH"
    "11", "11"
  }

  new_room =
  {
    env = "hallway"

    conn = { x=1, y=1, w=2, dir=8 }

    hall_type = "wide"

    grow_pass = "hall_2"
  }
}


HALL_2_GROW_I1 =
{
  pass = "hall_2"
  prob = 55 --40

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
  prob = 35 --50

  structure =
  {
    "....", ".@HH"
    "..@@", ".@HH"
    "xx11", "xx11"
  }

  link2_2 = { dest_dir=4 }
}


HALL_2_GROW_T1 =
{
  pass = "hall_2"
  prob = 30 --25

  structure =
  {
    "......", ".@HH@."
    "..@@..", ".@HH@."
    "xx11xx", "xx11xx"
  }

  hallway = { keep_shape_prob=50 }

  link2_2 = { dest_dir=4 }
  link5_2 = { dest_dir=6 }
}


HALL_2_GROW_P1 =
{
  pass = "hall_2"
  prob = 10 --5

  structure =
  {
    "xx..xx", "xx..xx"
    "xx..xx", "xx@@xx"
    "......", ".@HH@."
    "..@@..", ".@HH@."
    "xx11xx", "xx11xx"
  }

  link2_2 = { dest_dir=4 }
  link5_2 = { dest_dir=6 }
  link3_4 = { dest_dir=8 }
}


HALL_2_SPROUT_A =
{
  pass = "hall_2_sprout"
  prob = 100

  structure =
  {
    "....", "RRRR"
    "....", "RRRR"
    "x@@x", "xHHx"
    "x11x", "x11x"
  }

  new_room =
  {
    conn = { x=2, y=2, w=2, dir=8 }

    symmetry = { kind="mirror", x=2, y=3, w=2, dir=8 }
  }
}


HALL_2_SPROUT_B =
{
  pass = "hall_2_sprout"
  prob = 15 --10

  structure =
  {
    "....", "RRRR"
    "....", "RRRR"
    "@@xx", "HHxx"
    "11xx", "11xx"
  }

  new_room =
  {
    conn = { x=1, y=2, w=2, dir=8 }

    -- deliberately no symmetry info
  }
}

-- MsrSgtShooterPerson's kool x-perimental shapes of definite kool

-- MSSP's Greek collonade sort of things. [MSSPCOLLONADE]

GROW_COLONNADE_1 =
{
  prob = 10
  prob_skew = 5
  skip_prob = 80

  structure =
  {
    ".....", "11111"
    ".....", "1#1#1"
    ".....", "11111"
    ".....", "1#1#1"
    ".....", "11111"
    "x111x", "x111x"
  }
}

GROW_COLONNADE_2 =
{
  prob = 10
  prob_skew = 5
  skip_prob = 60

  structure =
  {
    "......", "111111"
    "......", "1#11.1"
    "......", "111111"
    "......", "1#11.1"
    "......", "111111"
    "......", "1#11.1"
    "......", "111111"
    "xx11xx", "xx11xx"
  }
}

GROW_COLONNADE_TINY =
{
  prob = 10
  skip_prob = 60

  structure =
  {
    "...","111"
    "...","1#1"
    "...","111"
    "...","1.1"
    "111","111"
  }
}

GROW_COLONNADE_PARTHENON =
{
  prob = 10
  prob_skew = 3
  skip_prob = 50

  structure =
  {
    "x....","x1>AA"
    "x....","x1#AA"
    "1....","11>AA"
    "1....","11>AA"
    "x....","x1#AA"
    "x....","x1>AA"
  }
}

GROW_COLONNADE_PARTHENON_3P =
{
  prob = 10
  prob_skew = 3
  skip_prob = 50

  structure =
  {
    "x....","x1>AA"
    "x....","x1.AA"
    "1....","11>AA"
    "1....","11.AA"
    "1....","11>AA"
    "x....","x1.AA"
    "x....","x1>AA"
  }
}

GROW_COLONNADE_PARTHENON_LAKE =
{
  prob = 15
  prob_skew = 3
  aversion = 5
  skip_prob = 75

  structure =
  {
    "x.......","x111>>AA"
    "1.......","1111>>AA"
    "1.......","11/~#~%A"
    "x.......","x1~~~~~A"
    "xx.....x","xx%~~~/x"
  }

  diagonals =
  {
    "1~","~A"
    ".~","~."
  }
}

GROW_COLONNADE_MOAT_1X =
{
  prob = 15
  skip_prob = 80

  structure =
  {
    "x......","x11>>AA"
    "1......","111~~AA"
    "1......","111~#AA"
    "1......","111~~AA"
    "x......","x11>>AA"
  }
}

GROW_COLONNADE_MOAT_2X =
{
  prob = 10
  skip_prob = 80

  structure =
  {
    "x......","x11>>AA"
    "x......","x11~~AA"
    "x......","x11~#AA"
    "1......","111~~AA"
    "1......","111>>AA"
    "1......","111~~AA"
    "x......","x11~#AA"
    "x......","x11~~AA"
    "x......","x11>>AA"
  }
}

GROW_COLLONADE_CORNER =
{
  prob = 15
  skip_prob = 75

  structure =
  {
    "11.....","111>>A%"
    "11.....","111>>AA"
    ".......","11/~~AA"
    ".......","vv~~~#A"
    ".......","vv~~/AA"
    ".......","AAA#AAA"
    ".......","%AAAAAA"
  }

  diagonals =
  {
    "A."
    "1~"
    "~A"
    ".A"
  }
}

GROW_COLLONADE_510_STAIRS_STRAIGHT =
{
  prob = 25
  skip_prob = 75

  structure =
  {
    ".........","AAAAAAAAA"
    ".........","AAAAAAAAA"
    ".........","AA#^^^#AA"
    ".........","AAA111AAA"
    ".........","AAA111AAA"
    "xxx111xxx","xxx111xxx"
  }
}

GROW_COLLONADE_510_STAIRS_TRI =
{
  prob = 25
  skip_prob = 75

  structure =
  {
    "..........","AAAAAAAAAA"
    "..........","AAAAAAAAAA"
    "..........","AA#^^^^#AA"
    "..........","AA<1111>AA"
    "..........","AA<1111>AA"
    "..........","AA<1111>AA"
    "..........","AA<1111>AA"
    "xxx1111xxx","xxx1111xxx"
  }
}

-- MSSP's liquid tiles. [MSSPLIQUID]

GROW_LIQUID_GUTTER_SIDE =
{
  prob = 30
  skip_prob = 40

  structure =
  {
    ".11","~11"
    ".11","~11"
    ".11","111"
    ".1x","11x"
  }
}

GROW_LIQUID_GUTTER_CORNER =
{
  prob = 30
  skip_prob = 40

  structure =
  {
    "....","~~11"
    "....","~/11"
    "x11x","x11x"
  }

  diagonals =
  {
    "~1"
  }
}

GROW_LIQUID_POOL_1X1 =
{
  prob = 5
  prob_skew = 2
  skip_prob = 35

  structure =
  {
    "...","111"
    "...","111"
    "...","1~1"
    "...","111"
    "x1x","x1x"
  }
}

GROW_LIQUID_POOL_2X2 =
{
  prob = 15
  prob_skew = 5
  skip_prob = 35

  structure =
  {
    "....","1111"
    "....","1111"
    "....","1~~1"
    "....","1~~1"
    "....","1111"
    "x11x","x11x"
  }
}

GROW_LIQUID_POOL_3X1 =
{
  prob = 15
  prob_skew = 5
  skip_prob = 35

  structure =
  {
    "...","111"
    "...","111"
    "...","1~1"
    "...","1~1"
    "...","1~1"
    "...","111"
    "x1x","x1x"
  }
}

GROW_LIQUID_PILLAR_CENTER =
{
  prob = 10
  skip_prob = 50

  structure =
  {
    ".....","11111"
    ".....","11111"
    ".....","1/~%1"
    ".....","1~.~1"
    ".....","1%~/1"
    ".....","11111"
    "x111x","x111x"
  }

  diagonals =
  {
    "1~","~1"
    "1~","~1"
  }
}

GROW_LIQUID_PILLAR_CENTER_LONG =
{
  prob = 10
  skip_prob = 50

  structure =
  {
    ".....","11111"
    ".....","11111"
    ".....","1/~%1"
    ".....","1~.~1"
    ".....","1~.~1"
    ".....","1~.~1"
    ".....","1%~/1"
    ".....","11111"
    "x111x","x111x"
  }

    diagonals =
  {
    "1~","~1"
    "1~","~1"
  }
}

GROW_LIQUID_SIDE_POOL_THICC =
{
  prob = 15
  skip_prob = 65

  structure =
  {
    "x....","x/~~%"
    "x....","x%~~/"
    "1....","11111"
    "1....","11111"
  }

  diagonals =
  {
    ".~","~."
    "1~","~1"
  }
}

GROW_LIQUID_SIDE_POOL_THIN =
{
  prob = 15
  skip_prob = 65

  structure =
  {
    "x....","x/~~%"
    "1....","11111"
    "1....","11111"
  }

  diagonals =
  {
    ".~","~."
  }
}

GROW_LIQUID_FIGURE_CORRIDOR =
{
  prob = 25
  skip_prob = 80

  structure =
  {
    "....","1111"
    "....","1111"
    "....","~11~"
    "....","1111"
    "....","~11~"
    "....","1111"
    "x11x","x11x"
  }
}

GROW_LIQUID_BRIDGE_CORRIDOR =
{
  prob = 20
  skip_prob = 60

  structure =
  {
    "...","111"
    "...","111"
    "...","%1/"
    "...","~1~"
    "...","/1%"
    "x1x","x1x"
  }

  diagonals =
  {
    "~1","1~"
    "~1","1~"
  }
}

GROW_LIQUID_BRIDGE_CORRIDOR_CROSSING =
{
  prob = 20
  skip_prob = 60

  structure =
  {
    "...","111"
    "...","111"
    "...","%1/"
    "...","~~~"
    "...","/1%"
    "...","111"
    "x1x","x1x"
  }

  diagonals =
  {
    "~1","1~"
    "~1","1~"
  }
}

GROW_LIQUID_PLATFORM_FUNNEL =
{
  prob = 20
  skip_prob = 70

  structure =
  {
    "......","/~11~%"
    "......","~/11%~"
    "x1111x","x1111x"
  }

  diagonals =
  {

    ".~","~."
    "~1","1~"
  }
}

GROW_LIQUID_WATERFALL_SIDES =
{
  prob = 20
  skip_prob = 50

  structure =
  {
    "...","AAA"
    "...","AAA"
    "...","~^~"
    "111","111"
  }
}

GROW_LIQUID_LEAP_SINGLE =
{
  prob = 15
  skip_prob = 75

  structure =
  {
    "...","111"
    "...","111"
    "...","vvv"
    "...","AAA"
    "...","%A/"
    "...","~~~"
    "...","/A%"
    "...","AAA"
    "...","^^^"
    "111","111"
  }

  diagonals =
  {
    "~A","A~"
    "~A","A~"
  }
}

GROW_LIQUID_U =
{
  prob = 15
  skip_prob = 75

  structure =
  {
    ".......","11~~~11"
    ".......","11~~~11"
    ".......","11~~~11"
    ".......","11%~/11"
    ".......","1111111"
    ".......","1111111"
    "xxxxx11","xxxxx11"
  }

  diagonals =
  {
    "1~","~1"
  }
}

GROW_LIQUID_U_ALT =
{
  prob = 15
  skip_prob = 75

  structure =
  {
    "1.......","111~~~11"
    "1.......","111~~~11"
    "x.......","x11~~~11"
    "x.......","x11%~/11"
    "x.......","x1111111"
  }

  diagonals =
  {
    "1~","~1"
  }
}

GROW_LIQUID_INTERSECTION =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "xxx...xxx","xxx111xxx"
    "x.......x","x~%111/~x"
    "x........","x%~111~/."
    ".........","111111111"
    ".........","111111111"
    ".........","111111111"
    "x.......x","x/~111~%x"
    "x.......x","x~/111%~x"
    "xxx111xxx","xxx111xxx"
  }

  diagonals =
  {
    "~1","1~"
    "1~","~1"
    "1~","~1"
    "~1","1~"
  }
}

GROW_LIQUID_OVAL_SPLIT =
{
  prob = 15
  skip_prob = 80

  structure =
  {
    "xxx11xxx","xxx11xxx"
    "........","~~~11~~~"
    "........","~~/11%~~"
    "........","~/1/%1%~"
    "........","~11~~11~"
    "........","~11~~11~"
    "........","~%1%/1/~"
    "........","~~%11/~~"
    "........","~~~11~~~"
    "xxx..xxx","xxx11xxx"
    "xxx..xxx","xxx11xxx"
  }

  diagonals =
  {
    "~1","1~"
    "~1","1~","~1","1~"
    "~1","1~","~1","1~"
    "~1","1~"
  }
}

-- MSSP's ramps and all sorts of stuff. [RAMPS]

GROW_RAMP_THIN_SINK =
{
  prob = 20
  aversion = 5
  skip_prob = 75

  structure =
  {
    ".....","AAAAA"
    ".....","AAAAA"
    ".....","1%A/1"
    ".....","11^11"
    "x...x","x1^1x"
    "x111x","x111x"
  }

  diagonals =
  {
    "1A","A1"
  }
}

GROW_RAMP_THIN_RISE =
{
  prob = 20
  aversion = 5
  skip_prob = 75

  structure =
  {
    "x...x","xAAAx"
    "x...x","xAAAx"
    "x...x","xA^Ax"
    "x...x","xA^Ax"
    ".....","AA1AA"
    ".....","A/1%A"
    ".....","11111"
    "x111x","x111x"
  }

  diagonals =
  {
    "A1","1A"
  }
}

GROW_RAMP_THIN_HALF_SINK =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "...","AAA"
    "...","AAA"
    "...","AA^"
    "...","AA^"
    "...","AA1"
    "...","AA1"
    "...","A/1"
    "x11","x11"
    "x11","x11"
  }

  diagonals =
  {
    "A1"
  }
}

GROW_RAMP_THIN_HALF_RISE =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "...","AAA"
    "...","AAA"
    "...","1%A"
    "...","11^"
    "...","11^"
    "...","111"
    "...","111"
    "...","111"
    "x11","x11"
    "x11","x11"
  }

  diagonals =
  {
    "1A"
  }
}

GROW_REVERSE_FUNNEL =
{
  prob = 20
  aversion = 3
  skip_prob = 60

  structure =
  {
    "x.....","x11AAA"
    "1.....","111%AA"
    "1.....","1111AA"
    "x.....","x11>AA"
    "x.....","x111AA"
    "x.....","x11/AA"
    "x.....","x11AAA"
  }

  diagonals =
  {
    "1A"
    "1A"
  }
}

GROW_SIDE_ON_RAMP =
{
  prob = 25
  skip_prob = 10

  structure =
  {
    "x..","xAA"
    "x..","xAA"
    "x..","x^^"
    "1..","111"
    "1..","11/"
  }

  diagonals =
  {
    "1."
  }
}

GROW_SIDE_ON_RAMP_TALL =
{
  prob = 25
  skip_prob = 10

  structure =
  {
    "x..","xAA"
    "x..","xAA"
    "x..","x^^"
    "x..","x^^"
    "1..","111"
    "1..","11/"
  }

  diagonals =
  {
    "1."
  }
}

GROW_CAUSEWAY =
{
  prob = 15
  skip_prob = 75

  structure =
  {
    "xxxx..xxx","xxxxAAxxx"
    "1........","1111AA111"
    "1........","111>AA<11"
    "x........","x111AA111"
    "x........","x111AA111"
    "x........","x11>AA<11"
    "x........","x111AA111"
    "xxxx..xxx","xxxxAAxxx"
  }
}

GROW_CAUSEWAY_WATERBOUND =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "x..........","x11~~AA~~11"
    "x..........","x11~~AA~~11"
    "x..........","x11>>AA<<11"
    "x..........","x11~~AA~~11"
    "x..........","x11~~AA~~11"
    "x..........","x11>>AA<<11"
    "1..........","111~~AA~~11"
    "1..........","111~~AA~~11"
  }
}

GROW_CAUSEWAY_SINGLE =
{
  prob = 10
  skip_prob = 75

  structure =
  {
    "1.....","1111AA"
    "1.....","111>AA"
    "x.....","x111AA"
    "x.....","x111AA"
    "x.....","x11>AA"
    "x.....","x111AA"
  }
}

GROW_CAUSEWAY_SINGLE_WATERBOUND =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "1......","111~~AA"
    "1......","111>>AA"
    "x......","x11~~AA"
    "x......","x11~~AA"
    "x......","x11>>AA"
    "x......","x11~~AA"
  }
}

GROW_CAUSEWAY_CORNER =
{
  prob = 10
  skip_prob = 70

  structure =
  {
    "x........","x11111111"
    "x........","x11111v11"
    "x........","x11/AAAAA"
    "x........","x11AAAAAA"
    "x........","x11AA11^1"
    "x........","x1>AA1111"
    "1........","111AA<111"
    "1.......x","111AA111x"
  }

  diagonals =
  {
    "1A"
  }
}

GROW_CAUSEWAY_CORNER_SINGLE =
{
  prob = 20
  skip_prob = 60

  structure =
  {
    "x.......","x1111111"
    "x.......","x1111v11"
    "x.......","x11/AAAA"
    "x.......","x11AAAAA"
    "x....xxx","x1>AAxxx"
    "1....xxx","111AAxxx"
    "1....xxx","111AAxxx"
  }

  diagonals =
  {
    "1A"
  }
}

GROW_CAUSEWAY_TIP =
{
  prob = 25
  skip_prob = 70

  structure =
  {
    "1........","111111111"
    "1........","111111111"
    "x........","x11AAAA11"
    "x........","x11AAAA11"
    "x........","x11>AA<11"
    "x........","x11>AA<11"
    "xxx....xx","xxxAAAAxx"
    "xxx....xx","xxxAAAAxx"
  }
}

GROW_GATED_RAMP =
{
  prob = 20
  skip_prob = 50

  structure =
  {
    "......","AAAAAA"
    "......","AAAAAA"
    "......","A#^^#A"
    "xx11xx","xx11xx"
  }
}

GROW_GATED_SIDE_RAMP =
{
  prob = 20
  skip_prob = 50

  structure =
  {
    "........","AAAAAAAA"
    "........","AAAAAAAA"
    "........","^^#AA#^^"
    "........","11111111"
    "xxx11xxx","xxx11xxx"
  }
}

--MSSP's simple bends. [BEND]

GROW_BEND =
{
  prob = 20

  structure =
  {
    "..","1%"
    "..","11"
    "11","11"
  }

  diagonals =
  {
    "1."
  }
}

GROW_SQUIGGLE =
{
  prob = 15
  skip_prob = 60

  structure =
  {
    "..xx","11xx"
    "..xx","11xx"
    "...x","%1%x"
    "x...","x%1%"
    "xx11","xx11"
  }

  diagonals =
  {
    ".1","1."
    ".1","1."
  }
}

GROW_TINY_U =
{
  prob = 13
  skip_prob = 60

  structure =
  {
    "......","/1111%"
    "......","111111"
    "..xx..","11xx11"
    "..xx..","11xx11"
    "11xxxx","11xxxx"
  }

  diagonals =
  {
    ".1","1."
  }
}

-- Thicker on-ramps [BIGRAMPS]

GROW_STAIRED_HORSESHOE =
{
  prob = 20
  skip_prob = 80

  aversion = 10

  structure =
  {
    "..........","/AAAAAAAA%"
    "..........","AAAAAAAAAA"
    "..........","AA/1111%AA"
    "..........","AA111111AA"
    "....xx....","^^11xx11^^"
    "....xx....","1111xx1111"
    "....xx....","1111xx1111"
    "xxxxxxxx11","xxxxxxxx11"
  }

  diagonals =
  {
    ".A","A."
    "A1","1A"
  }
}

GROW_STAIRED_HORSESHOE_TIGHTER =
{
  prob = 20
  skip_prob = 80

  aversion = 10

  structure =
  {
    "..........","./AAAAAA%."
    "..........","/AAAAAAAA%"
    "..........","AA/1^^1%AA"
    "..........","AA111111AA"
    "..........","AA111111AA"
    "xxxx11xxxx","xxxx11xxxx"
  }

  diagonals =
  {
    ".A","A."
    ".A","A."
    "A1","1A"
  }
}

GROW_STAIRED_T =
{
  prob = 25
  skip_prob = 50

  aversion = 10

  structure =
  {
    "........","AAAAAAAA"
    "........","AAAAAAAA"
    "........","11%AA/11"
    "........","111AA111"
    "........","111^^111"
    "........","11111111"
    "xxxxxx11","xxxxxx11"
  }

  diagonals =
  {
    "1A","A1"
  }
}

GROW_STAIRED_L =
{
  prob = 40
  skip_prob = 50

  aversion = 5

  structure =
  {
    ".....","AAAAA"
    ".....","AAAAA"
    ".....","11%AA"
    ".....","111AA"
    "x....","x11^^"
    "x....","x11^^"
    ".....","11111"
    ".....","11111"
    "11xxx","11xxx"
  }

  diagonals =
  {
    "1A"
  }
}

-- MSSP's squeezed corridors. [SQUEEZE]


GROW_SQUEEZE_STRAIGHT_NEW_AREA =
{
  prob = 15
  skip_prob = 70

  structure =
  {
    "...","AAA"
    "...","AAA"
    "x.x","x1x"
    "x.x","x1x"
    "x.x","x1x"
    "x1x","x1x"
  }
}

GROW_SQUEEZE_CURVE_NEW_AREA =
{
  prob = 10
  skip_prob = 70

  structure =
  {
    "xxx..","xxxAA"
    ".....","111AA"
    ".xx..","1xxAA"
    ".xxxx","1xxxx"
    "1xxxx","1xxxx"
  }
}

GROW_SQUEEZE_STAIRCASE =
{
  prob = 7
  skip_prob = 70

  structure =
  {
    "..","AA"
    "..","AA"
    "x.","x^"
    "x1","x1"
  }
}

GROW_SQUEEZE_EVEN_MORE_STAIRCASE =
{
  prob = 7
  skip_prob = 76

  structure =
  {
    "..","AA"
    "..","AA"
    "x.","x^"
    "x.","x^"
    "x.","x^"
    "x1","x1"
  }
}

GROW_SQUEEZE_LIQUID_ONE_SIDE =
{
  prob = 6
  skip_prob = 70

  structure =
  {
    "..x","AAx"
    "..x","AAx"
    "...","^~~"
    "...","^~~"
    "1xx","1xx"
  }
}

GROW_SQUEEZE_LIQUID_BOTH_SIDES =
{
  prob = 6
  skip_prob = 65

  structure =
  {
    "x...x","xAAAx"
    "x...x","xAAAx"
    ".....","~~^~~"
    ".....","~~^~~"
    "xx1xx","xx1xx"
  }
}

GROW_SQUEEZE_CURVE_LIQUID_SIDE =
{
  prob = 5
  skip_prob = 60

  structure =
  {
    "x...","x/AA"
    "....","/AAA"
    "....","A/~~"
    "....","^~~~"
    "1xxx","1xxx"
  }

  diagonals =
  {
    ".A"
    ".A"
    "A~"
  }
}

GROW_SQUEEZE_DRAIN =
{
  prob = 8
  skip_prob = 60

  structure =
  {
    "...","111"
    "...","111"
    "...","~1~"
    "...","~1~"
    "...","~1~"
    "x1x","x1x"
  }
}

GROW_SQUEEZE_DRAIN_CURVE =
{
  prob = 8
  skip_prob = 60

  structure =
  {
    ".......","/~~~~11"
    ".......","~/11111"
    ".......","~1/~~11"
    "....xxx","~1~/xxx"
    "...xxxx","~1~xxxx"
    "x1xxxxx","x1xxxxx"
  }

  diagonals =
  {
    ".~"
    "~1"
    "1~"
    "~."
  }
}

-- some more other cages

GROW_CAGE_BETWEEN_PILLAR =
{
  prob = 10
  skip_prob = 70

  aversion = 10

  structure =
  {
    ".....","11111"
    ".....","11111"
    ".....","1#C#1"
    ".....","11111"
    "x111x","x111x"
  }

  cage_mode = "fancy"
}

GROW_CAGE_AROUND_PILLAR =
{
  prob = 25
  skip_prob = 65

  structure =
  {
    ".....","11111"
    ".....","11111"
    ".....","1CCC1"
    ".....","1C#C1"
    ".....","1CCC1"
    "11111","11111"
    "x111x","x111x"
  }

  cage_mode = "fancy"
}

GROW_CAGE_Z =
{
  prob = 10
  skip_prob = 70

  aversion = 5

  structure =
  {
    "....","1111"
    "....","1111"
    "....","11CC"
    "....","1111"
    "....","CC11"
    "....","1111"
    "x11x","x11x"
  }

  cage_mode = "fancy"
}

GROW_CAGE_SIMPLE_CORNER =
{
  prob = 6
  skip_prob = 70

  aversion = 10

  structure =
  {
    "....","/C11"
    ".111","C111"
  }

  diagonals =
  {
    ".C"
  }

  cage_mode = "fancy"
}

GROW_CAGE_DOOM_MAP01 =
{
  prob = 15
  skip_prob = 75

  structure =
  {
    "......","111111"
    "......","111111"
    "......","1C11C1"
    "......","111111"
    "......","111111"
    "......","1C11C1"
    "......","111111"
    "xx11xx","xx11xx"
  }
}

GROW_CAGE_DOOM_MAP01_PILLARED =
{
  prob = 15
  skip_prob = 75

  structure =
  {
    "......","111111"
    "......","111111"
    "......","1C11C1"
    "......","1#11#1"
    "......","111111"
    "......","1#11#1"
    "......","1C11C1"
    "......","111111"
    "xx11xx","xx11xx"
  }
}

DECORATE_CAGE_ON_LIQUID_CANAL_SIDE =
{
  prob = 10

  structure =
  {
    "~~~~","~CC~"
    "1111","1111"
    "1111","1111"
    "~~~~","~CC~"
  }
}

GROW_CAGE_ROUND_ARENA =
{
  prob = 15
  skip_prob = 80

  aversion = 4

  structure =
  {
    ".....","11111"
    ".....","11111"
    ".....","1/C%1"
    ".....","1CCC1"
    ".....","1%C/1"
    ".....","11111"
    "x111x","x111x"
  }

  diagonals =
  {
    "1C","C1"
    "1C","C1"
  }
}

GROW_CAGE_SIDEWAYS =
{
  prob = 15
  skip_prob = 80

  structure =
  {
    "11xxxx","11xxxx"
    "......","111111"
    "......","111111"
    "......","CCC#11"
    "......","111111"
    "......","111111"
  }
}

GROW_CAGE_SIDEWAYS_STAIR =
{
  prob = 15
  skip_prob = 80

  structure =
  {
    "11xxxx","11xxxx"
    "......","111111"
    "......","111111"
    "......","CCC#vv"
    "......","AAAAAA"
    "......","AAAAAA"
  }
}

GROW_CAGE_SIDEWAYS_BOTH_SIDES =
{
  prob = 10
  skip_prob = 80

  structure =
  {
    "xxx11xxx","xxx11xxx"
    "........","11111111"
    "........","11#11#11"
    "........","11C11C11"
    "........","11C11C11"
    "........","11C11C11"
  }
}


GROW_CAGE_ROUND_RAFTERS_ONE_SIDE =
{
  prob = 15
  skip_prob = 75

  structure =
  {
    "xx11","xx11"
    "....","/C11"
    "....","C/11"
    "....","1111"
    "....","1111"
  }

  diagonals =
  {
    ".C"
    "C1"
  }
}

-- MSSP's elevated catwalks. [CATWALK]

GROW_CATWALK_BIFUNNEL_SINK =
{
  prob = 15
  skip_prob = 80

  structure =
  {
    "xx...xx","xx111xx"
    "xx...xx","xx111xx"
    ".......","AA%1/AA"
    ".......","AA<1>AA"
    ".......","AA/1%AA"
    "x.....x","x11111x"
    "xx111xx","xx111xx"
  }

  diagonals =
  {
    "A1","1A"
    "A1","1A"
  }
}

GROW_CATWALK_BIFUNNEL_RISE =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "xx...xx","xx111xx"
    "xx...xx","xx111xx"
    ".......","AA%v/AA"
    ".......","AAAAAAA"
    ".......","AA/^%AA"
    "x.....x","x11111x"
    "xx111xx","xx111xx"
  }

  diagonals =
  {
    "A1","1A"
    "A1","1A"
  }
}

GROW_CATWALK_BIFUNNEL_SINK_TALL =
{
  prob = 15
  skip_prob = 80

  structure =
  {
    "xx...xx","xx111xx"
    "xx...xx","xx111xx"
    ".......","AA%1/AA"
    ".......","A<<1>>A"
    ".......","AA/1%AA"
    "xx...xx","xx111xx"
    "xx111xx","xx111xx"
  }

  diagonals =
  {
    "A1","1A"
    "A1","1A"
  }
}

GROW_CATWALK_BIFUNNEL_RISE_TALL =
{
  prob = 15
  skip_prob = 80

  structure =
  {
    "xx.....xx","xx11111xx"
    "xx.....xx","xx11v11xx"
    ".........","AA%1v1/AA"
    ".........","AAAAAAAAA"
    ".........","AA/1^1%AA"
    "xx.....xx","xx11^11xx"
    "xx.....xx","xx11111xx"
    "xxx111xxx","xxx111xxx"
  }

  diagonals =
  {
    "A1","1A"
    "A1","1A"
  }
}

GROW_CATWALK_SIDESTAIRS =
{
  prob = 10
  skip_prob = 80

  structure =
  {
    "x.....xx","x11111xx"
    "x.....xx","x11111xx"
    "........","AA<<1/AA"
    "........","AAAAAAAA"
    "........","AA<<1%AA"
    "xxxx11xx","xxxx11xx"
  }

  diagonals =
  {
    "1A","1A"
  }
}

GROW_CATWALK_U =
{
  prob = 15
  skip_prob = 75

  structure =
  {
    "xx.....xx","xx/111%xx"
    "x.......x","x/11111%x"
    ".........","/11/A%11%"
    ".........","11/AAA%11"
    ".........","11AA#AA11"
    "xxxx.....","xxxx#^^11"
    "xxxx.....","xxxx#^^11"
    "xxxxx111x","xxxxx111x"
  }

  diagonals =
  {
         ".1","1."
         ".1","1."
    ".1","1A","A1","1."
         "1A","A1"
  }
}

-- MSSP's wide diagonals. [DIAGONALS]

GROW_DIAGONAL_L =
{
  prob = 20
  skip_prob = 50

  structure =
  {
    "xx....","xx/111"
    "x.....","x/1111"
    "......","/11111"
    "....xx","111/xx"
    "...xxx","111xxx"
    "111xxx","111xxx"
  }

  diagonals =
  {
    ".1"
    ".1"
    ".1"
    "1."
  }
}

GROW_DIAGONAL_L_CATWALK =
{
  prob = 20
  skip_prob = 50

  structure =
  {
    "xx.....","xx/A<11"
    "x......","x/AA<11"
    ".......","/AA/111"
    ".......","AA/1111"
    ".....xx","^^11/xx"
    "....xxx","1111xxx"
    "....xxx","1111xxx"
    "xx11xxx","xx11xxx"
  }

  diagonals =
  {
        ".A"
      ".A"
    ".A","A1"
       "A1"
    "1."
  }
}

GROW_DIAGONAL_L_CATWALK_CONTINUE =
{
  prob = 20
  skip_prob = 50

  structure =
  {
    "xx.....","xx/AAAA"
    "x......","x/AAAAA"
    ".......","/AA/111"
    ".......","AA/1111"
    ".....xx","^^11/xx"
    "....xxx","1111xxx"
    "....xxx","1111xxx"
    "xx11xxx","xx11xxx"
  }

  diagonals =
  {
        ".A"
      ".A"
    ".A","A1"
      "A1"
    "1."
  }
}

GROW_DIAGONAL_S =
{
  prob = 15
  skip_prob = 65

  structure =
  {
    "xxx...","xxx111"
    "xxx...","xxx111"
    "xx....","xx/111"
    "x.....","x/111/"
    ".....x","/111/x"
    "....xx","111/xx"
    "...xxx","111xxx"
    "...xxx","111xxx"
    "x11xxx","x11xxx"
  }

  diagonals =
  {
    ".1"
    ".1","1."
    ".1","1."
         "1."
  }
}

GROW_DIAGONAL_SIDE_BLOB =
{
  prob = 15
  skip_prob = 75

  structure =
  {
    "....x","AAAAx"
    "....x","AAAAx"
    ".....","%AA/1"
    "x....","x%/11"
    "xx11x","xx11x"
  }

  diagonals =
  {
    ".A","A1"
    ".A","A1"
  }
}

GROW_DIAGONAL_SIDE_BLOB_ALT =
{
  prob = 15
  skip_prob = 75

  structure =
  {
    "..xxx","AAxxx"
    "..xxx","AAxxx"
    "...xx","AA%xx"
    "....x","AAA%x"
    ".....","%AA/1"
    "x....","x%/11"
    "xx11x","xx11x"
  }

  diagonals =
  {
    "A."
    "A."
    ".A","A1"
    ".A","A1"
  }
}

GROW_DIAGONAL_SIDE_BLOB_ALT =
{
  prob = 15
  skip_prob = 75

  structure =
  {
    "x..xxx","x11xxx"
    "...xxx","111xxx"
    "....xx","11/%xx"
    "x....x","x/AA%x"
    "x.....","x%AA/1"
    "xx....","xx%/11"
    "xxx11x","xxx11x"
  }

  diagonals =
  {
    "1A","A."
    "1A","A."
    ".A","A1"
    ".A","A1"
  }
}

-- MSSP's water canals. [CANALS]

GROW_LIQUID_CANAL_STRAIGHT =
{
  prob = 60

  group = "canal"

  structure =
  {
    "~.","~~"
    "~.","~~"
    "1.","11"
    "1.","11"
    "~.","~~"
    "~.","~~"
  }
}

GROW_LIQUID_CANAL_CROSSING =
{
  prob = 40

  group = "canal"

  engine = "zdoom"

  structure =
  {
    "~...","~~~~"
    "~...","~~~~"
    "1...","1A11"
    "1...","1A11"
    "~...","~~~~"
    "~...","~~~~"
  }
}


GROW_LIQUID_CANAL_STRAIGHT_AREA_TRANSITION =
{
  prob = 30

  group = "canal"

  structure =
  {
    "~..","~~~"
    "~..","~~~"
    "1..","1AA"
    "1..","1AA"
    "~..","~~~"
    "~..","~~~"
  }
}

GROW_LIQUID_CANAL_STRAIGHT_STAIRCASE =
{
  prob = 40

  group = "canal"

  structure =
  {
    "~...","~~~~"
    "~...","~~~~"
    "1...","1>AA"
    "1...","1>AA"
    "~...","~~~~"
    "~...","~~~~"
  }
}

GROW_LIQUID_CANAL_STRAIGHT_BULGE =
{
  prob = 40

  group = "canal"

  structure =
  {
    "~.....","~~11~~"
    "~.....","~/11%~"
    "1.....","11111A"
    "1.....","11111A"
    "~.....","~%11/~"
    "~.....","~~11~~"
  }

  diagonals =
  {
    "~1","1~"
    "~1","1~"
  }
}

GROW_LIQUID_CANAL_CURVE =
{
  prob = 60

  group = "canal"

  structure =
  {
    "~.....","~~~~~%"
    "~.....","~~~~~~"
    "1.....","111%~~"
    "1.....","1111~~"
    "~.....","~%11~~"
    "~.....","~~11~~"
  }

  diagonals =
  {
    "~."
    "1~"
    "~1"
  }
}

GROW_LIQUID_CANAL_ENTRY_B =
{
  prob = 50

  group = "canal"

  group_pos = "entry"

  structure =
  {
    "x..","x~~"
    "x..","x~~"
    "1..","111"
    "1..","111"
    "x..","x~~"
    "x..","x~~"
  }

  diagonals =
  {
    ".~"
    ".~"
  }
}

GROW_LIQUID_CANAL_OUT_ALT =
{
  prob = 10

  structure =
  {
    "~..","~AA"
    "1..","1AA"
    "1..","1AA"
    "~..","~AA"
  }
}

-- [SINGLE_CANAL : SCANAL]

GROW_LIQUID_SCANAL_ENTRY =
{
  prob = 20

  group = "single_canal"

  structure =
  {
    "1..","111"
    "1..","111"
    "x..","x~~"
    "x..","x~~"
  }
}

GROW_LIQUID_SCANAL_ENTRY_FORWARD =
{
  prob = 20

  group = "single_canal"

  structure =
  {
    "1....","111~~"
    "1....","111~~"
  }
}

GROW_LIQUID_SCANAL_STRAIGHT =
{

  prob = 60

  group = "single_canal"

  structure =
  {
    "1.","11"
    "1.","11"
    "~.","~~"
    "~.","~~"
  }
}

GROW_LIQUID_SCANAL_STRAIGHT_CROSSING =
{
  prob = 30

  engine = "zdoom"

  group = "single_canal"

  structure =
  {
    "1.....","11~111"
    "1.....","1/~%11"
    "~.....","~~~~~~"
    "~.....","~~~~~~"
  }

  diagonals =
  {
    "1~","~1"
  }
}

GROW_LIQUID_SCANAL_STAIR =
{
  prob = 40

  group = "single_canal"

  structure =
  {
    "1...","1>AA"
    "1...","1>AA"
    "~...","~~~~"
    "~...","~~~~"
  }
}

GROW_LIQUID_SCANAL_OUTER_BEND =
{
  prob = 30

  group = "single_canal"

  structure =
  {
    "1...","111%"
    "1...","1111"
    "~...","~~11"
    "~...","~~11"
  }

  diagonals =
  {
    "1."
  }

}

GROW_LIQUID_SCANAL_INNER_BEND =
{
  prob = 30

  group = "single_canal"

  structure =
  {
    "1...","11~~"
    "1...","11~~"
    "~...","~~~~"
    "~...","~~~/"
  }

  diagonals =
  {
    "~."
  }
}

GROW_LIQUID_SCANAL_T_JUNCTION =
{
  prob = 20

  group = "single_canal"

  structure =
  {
    "1.....","111111"
    "1.....","111111"
    "~.....","~%11/~"
    "~.....","~~11~~"
  }

  diagonals =
  {
    "~1","1~"
  }
}

-- [UNGROUPED CANALS]

GROW_CANAL_DOUBLE_UNG =
{
  prob = 25

  structure =
  {
    "11..","1111"
    "11..","1111"
    "..xx","~~xx"
    "..xx","~~xx"
  }
}

GROW_CANAL_DOUBLE_CORNER_UNG =
{
  prob = 15

  structure =
  {
    "11....","1111~~"
    "11....","1111~~"
    "......","~~~~~~"
    "......","~~~~~/"
  }

  diagonals =
  {
    "~."
  }
}

GROW_CANAL_SINGLE_UNG =
{
  prob = 25

  structure =
  {
    "11..","1111"
    "11..","1111"
    "..xx","~~xx"
  }
}

GROW_CANAL_SINGLE_CORNER_UNG =
{
  prob = 25

  structure =
  {
    "11..","1111"
    "11..","1111"
    "....","~~~~"
  }

  diagonals =
  {
    "~."
  }
}

-- [NARROW CANALS : NCANALS]

GROW_NARROW_CANAL_ENTRY =
{
  prob = 5

  structure =
  {
    "1..","111"
    "1..","111"
    "x..","x~~"
  }
}

GROW_NARROW_CANAL_ENTRY_FROMSIDE =
{
  prob = 5

  structure =
  {
    "1...","111~"
    "1...","111~"
  }
}

GROW_NARROW_CANAL_STRAIGHT =
{
  prob = 10

  structure =
  {
    "1.","11"
    "1.","11"
    "~.","~~"
  }
}

GROW_NARROW_CANAL_STRAIGHT_CROSSING =
{
  prob = 5

  structure =
  {
    "1......","111A111"
    "1......","11/~%11"
    ".......","~~~~~~~"
  }

  diagonals =
  {
    "1~","~1"
  }
}

GROW_NARROW_CANAL_STAIRS =
{
  prob = 10

  structure =
  {
    "1...","1>AA"
    "1...","1>AA"
    "~...","~~~~"
  }
}

GROW_NARROW_CANAL_INNER_CURVE =
{
  prob = 5

  structure =
  {
    "1...","111%"
    "1...","1111"
    "~...","~%11"
    "x...","x~11"
  }

  diagonals =
  {
    "1."
    "~1"
  }
}

GROW_NARROW_CANAL_OUTER_CURVE =
{
  prob = 5

  structure =
  {
    "1..","11~"
    "1..","1/~"
    "~..","~~/"
  }

  diagonals =
  {
    "1~"
    "~."
  }
}

-- MSSP's liquid slabs. [LIQUID_SLABS]

GROW_LIQUID_SLAB_ENTRY =
{
  prob = 20
  skip_prob = 55

  structure =
  {
    "....","1111"
    "....","1111"
    "....","~~~~"
    "....","1111"
    "11..","1111"
  }
}

GROW_LIQUID_SLAB_DIAGONAL =
{
  prob = 15
  skip_prob = 65

  structure =
  {
    "...x","11~x"
    "....","1//1"
    "..11","~/11"
    "xx11","xx11"
  }

  diagonals =
  {
    "1~","~1"
    "~1"
  }
}

GROW_LIQUID_SLAB_DIAGONAL_REVERSE =
{
  prob = 15
  skip_prob = 65

  structure =
  {
    "....x","1111x"
    ".....","111/~"
    ".....","11//1"
    "...11","1//11"
    "x..11","x~111"
  }

  diagonals =
  {
    "1~"
    "1~","~1"
    "1~","~1"
  }
}

-- Lake shapes - very large bodies of water. [LAKE]

GROW_LAKE_BIG_O_NEW_AREA =
{
  prob = 25
  skip_prob = 75

  structure =
  {
    "xxxxx11xxxxx","xxxxx11xxxxx"
    "............","/1111111111%"
    "............","111111111111"
    "............","111111111111"
    "............","111/~~~~%111"
    "............","111~~~~~~111"
    "............","111~~~~~~111"
    "............","111~~~~~~111"
    "............","vvv~~~~~~vvv"
    "............","vvv~~~~~~vvv"
    "............","AAA~~~~~~AAA"
    "............","AAA~~~~~~AAA"
    "............","AAA~~~~~~AAA"
    "............","AAA%~~~~/AAA"
    "............","AAAAAAAAAAAA"
    "............","AAAAAAAAAAAA"
    "............","%AAAAAAAAAA/"
  }

  diagonals =
  {
    ".1","1."
    "1~","~1"
    "A~","~A"
    ".A","A."
  }
}

GROW_LAKE_BIG_O_WIDE_NEW_AREA =
{
  prob = 25
  skip_prob = 80

  structure =
  {
    "xxxxxxx11xxxxxxx","xxxxxxx11xxxxxxx"
    "................","AAAAAA<11>AAAAAA"
    "................","AAAAAA<11>AAAAAA"
    "................","AAAAAA<11>AAAAAA"
    "................","AAA/~~~~~~~~%AAA"
    "................","AAA~~~~~~~~~~AAA"
    "................","AAA~~~~~~~~~~AAA"
    "................","AAA~~~~~~~~~~AAA"
    "................","AAA~~~~~~~~~~AAA"
    "................","AAA~~~~~~~~~~AAA"
    "................","AAA~~~~~~~~~~AAA"
    "................","AAA~~~~~~~~~~AAA"
    "................","AAA~~~~~~~~~~AAA"
    "................","AAA%~~~~~~~~/AAA"
    "................","AAAAAAAAAAAAAAAA"
    "................","AAAAAAAAAAAAAAAA"
    "................","AAAAAAAAAAAAAAAA"
  }

  diagonals =
  {
    "A~","~A"
    "A~","~A"
  }
}

GROW_LAKE_BIG_L_NEW_AREA =
{
  prob = 25
  skip_prob = 75

  structure =
  {
    "xxxxx11xxxxxxxxxxxxx","xxxxx11xxxxxxxxxxxxx"
    "............xxxxxxxx","/1111111111%xxxxxxxx"
    "............xxxxxxxx","111111111111xxxxxxxx"
    "............xxxxxxxx","111111111111xxxxxxxx"
    "............xxxxxxxx","111/~~~~%111xxxxxxxx"
    "............xxxxxxxx","111~~~~~~111xxxxxxxx"
    "............xxxxxxxx","111~~~~~~111xxxxxxxx"
    "............xxxxxxxx","vvv~~~~~~vvvxxxxxxxx"
    "............xxxxxxxx","AAA~~~~~~AAAxxxxxxxx"
    "....................","AAA~~~~~~AAAAAAAAAA%"
    "....................","AAA~~~~~~AAAAAAAAAAA"
    "....................","AAA~~~~~~%AAAAAAAAAA"
    "....................","AAA~~~~~~~~~~~~~%AAA"
    "....................","AAA~~~~~~~~~~~~~~AAA"
    "....................","AAA~~~~~~~~~~~~~~AAA"
    "....................","AAA%~~~~~~~~~~~~/AAA"
    "....................","AAAAAAAAAAAAAAAAAAAA"
    "....................","AAAAAAAAAAAAAAAAAAAA"
    "....................","%AAAAAAAAAAAAAAAAAA/"
  }

  diagonals =
  {
    ".1","1."
    "1~","~1"
         "A."
    "~A"
         "~A"
    "A~","~A"
    ".A","A."
  }
}

GROW_LAKE_BIG_J_NEW_AREA =
{
  prob = 25
  skip_prob = 75

  structure =
  {
    "x11xxxxxxxxx","x11xxxxxxxxx"
    ".........xxx","111~~~~~~xxx"
    ".........xxx","111~~~~~~xxx"
    ".........xxx","111~~~~~~xxx"
    ".........xxx","111~~~~~~xxx"
    ".........xxx","111~~~~~~xxx"
    ".........xxx","111~~~~~~xxx"
    ".........xxx","111~~~~~~xxx"
    ".........xxx","vvv~~~~~~xxx"
    ".........xxx","vvv~~~~~~xxx"
    "............","AAA~~~~~~AAA"
    "............","AAA~~~~~~AAA"
    "............","AAA~~~~~~AAA"
    "............","AAA%~~~~/AAA"
    "............","AAAAAAAAAAAA"
    "............","AAAAAAAAAAAA"
    "............","%AAAAAAAAAA/"
  }

  diagonals =
  {
    "A~","~A"
    ".A","A."
  }
}

GROW_LAKE_CROSS_NEW_AREA =
{
  prob = 25
  skip_prob = 75

  structure =
  {
    "xxxxxxx11xxxxxxx","xxxxxxx11xxxxxxx"
    "x..............x","x/~~~~1111~~~~%x"
    "................","/~~~~~1111~~~~~%"
    "................","~~~~~~vvvv~~~~~~"
    "................","~~~~~~vvvv~~~~~~"
    "................","~~~~~~AAAA~~~~~~"
    "................","~~~~~/AAAA%~~~~~"
    "xxx..........xxx","xxxAAAAAAAAAAxxx"
    "xxx..........xxx","xxxAAAAAAAAAAxxx"
    "xxx..........xxx","xxxAAAAAAAAAAxxx"
    "xxx..........xxx","xxxAAAAAAAAAAxxx"
    "................","~~~~~%AAAA/~~~~~"
    "................","~~~~~~AAAA~~~~~~"
    "................","~~~~~~AAAA~~~~~~"
    "......xxxx......","~~~~~~xxxx~~~~~~"
    "......xxxx......","%~~~~~xxxx~~~~~/"
    "x.....xxxx.....x","x%~~~~xxxx~~~~/x"
  }

  diagonals =
  {
    ".~","~."
    ".~","~."
    "~A","A~"
    "~A","A~"
    ".~","~."
    ".~","~."
  }
}

GROW_LAKE_CROSS_NEW_AREA_STRAIGHT =
{
  prob = 25
  skip_prob = 75

  structure =
  {
    "xxxxxxx11xxxxxxx","xxxxxxx11xxxxxxx"
    "x..............x","x/~~~~1111~~~~%x"
    "................","/~~~~~1111~~~~~%"
    "................","~~~~~~vvvv~~~~~~"
    "................","~~~~~~vvvv~~~~~~"
    "................","~~~~~~AAAA~~~~~~"
    "................","~~~~~/AAAA%~~~~~"
    "................","~~~~/AAAAAA%~~~~"
    "................","~~~~AAAAAAAA~~~~"
    "................","~~~~AAAAAAAA~~~~"
    "................","~~~~%AAAAAA/~~~~"
    "................","~~~~~%AAAA/~~~~~"
    "................","~~~~~~AAAA~~~~~~"
    "................","~~~~~~^^^^~~~~~~"
    "................","~~~~~~^^^^~~~~~~"
    "................","%~~~~~1111~~~~~/"
    "x..............x","x%~~~~1111~~~~/x"
  }

  diagonals =
  {
    ".~","~."
    ".~","~."
    "~A","A~"
    "~A","A~"
    "~A","A~"
    "~A","A~"
    ".~","~."
    ".~","~."
  }
}

GROW_LAKE_BIG_X_NEW_AREA =
{
  prob = 35
  skip_prob = 60

  structure =
  {
    "xxxxx........xxxxx","xxxxx~~~~~~~~xxxxx"
    "11...............x","11111%~~~~~~/1111x"
    "11...............x","111111%~~~~/11111x"
    "x................x","x111111%~~/111111x"
    "..................","~%111111%/111111/~"
    "..................","~~%111111111111/~~"
    "..................","~~~%1111111111/~~~"
    "..................","~~~/1111111111%~~~"
    "..................","~~/111111111111%~~"
    "..................","~/111111/%111111%~"
    "x................x","x111111/~~%111111x"
    "x................x","x11111/~~~~%11111x"
    "x................x","x1111/~~~~~~%1111x"
    "xxxxx........xxxxx","xxxxx~~~~~~~~xxxxx"
  }

  diagonals =
  {
         "1~","~1"
         "1~","~1"
         "1~","~1"
    "~1","1~","~1","1~"
    "~1"     ,     "1~"
    "~1"     ,     "1~"
    "~1"     ,     "1~"
    "~1"     ,     "1~"
    "~1","1~","~1","1~"
         "1~","~1"
         "1~","~1"
         "1~","~1"
  }
}

GROW_BIG_REACTOR_ARENA =
{
  prob = 25
  skip_prob = 75

  structure =
  {
    "xxxxx1111xxxxx","xxxxx1111xxxxx"
    "x............x","x/1111111111%x"
    "..............","/111111111111%"
    "..............","11111111111111"
    "..............","111/%1111/%111"
    "..............","111%/AAAA%/111"
    "..............","1111AAAAAA1111"
    "..............","AAAAAAAAAAAAAA"
    "..............","AAAAAAAAAAAAAA"
    "..............","1111AAAAAA1111"
    "..............","111/%1111/%111"
    "..............","111%/AAAA%/111"
    "..............","111111AA111111"
    "..............","%11111AA11111/"
    "x............x","x%1111AA1111/x"
  }

  diagonals =
  {
    ".1","1."
    ".1","1."
    "1#","#1","1#","#1"
    "1#","#1","1#","#1"
    "1#","#1","1#","#1"
    "1#","#1","1#","#1"
    ".1","1."
    ".1","1."
  }
}

-- MSSP's shape primitives [PRIMITIVES]

GROW_PRIMITIVE_CIRCLE_3X =
{
  prob = 35
  skip_prob = 25

  structure =
  {
    "xx.....xx","xx/111%xx"
    "x.......x","x/11111%x"
    ".........","111111111"
    ".........","111111111"
    ".........","111111111"
    "x.......x","x%11111/x"
    "xx.....xx","xx%111/xx"
    "xxx111xxx","xxx111xxx"
  }

  diagonals =
  {
    ".1","1."
    ".1","1."
    ".1","1."
    ".1","1."
  }
}

GROW_PRIMITIVE_CIRCLE_2X =
{
  prob = 20
  skip_prob = 25

  structure =
  {
    "x....x","x/11%x"
    "......","/1111%"
    "......","111111"
    "......","111111"
    "......","%1111/"
    "x....x","x%11/x"
    "xx11xx","xx11xx"
  }

  diagonals =
  {
    ".1","1."
    ".1","1."
    ".1","1."
    ".1","1."
  }
}

-- MSSP's shape tamers. Tries to get rid of strange architectural decisions such as pointy walls. [TAMERS]

SERRATED_EDGE_SMOOTHER =
{
  pass = "smoother"
  prob = 35

  structure =
  {
    "1","1"
    "/","1"
  }

  diagonals =
  {
    ".1"
  }
}

SERRATED_LIQUID_SMOOTHER3 =
{
  pass = "smoother"

  prob = 15

  structure =
  {
    "~~1","~~1"
    "/~1","~~1"
  }

  diagonals =
  {
    ".~"
  }
}

--MSSP's square-out. Makes rooms less... wormy or spaghetti-ish.

SQUARE_OUT_FROM_CORNER_2X =
{
  pass = "square_out"

  prob = 100

  structure =
  {
    "1..","111"
    "x11","x11"
  }
}

SQUARE_OUT_FROM_CORNER =
{
  pass = "square_out"

  prob = 50

  structure =
  {
    "1.","11"
    "x1","x1"
  }
}

SQUARE_OUT_THICKEN_CLIFF_BOTH_SIDES =
{
  pass = "square_out"

  prob = 150

  structure =
  {
    "..","11"
    "11","11"
    "22","22"
    "..","22"
  }
}

SQUARE_OUT_THICKEN_CLIFF_ONE_SIDE =
{
  pass = "square_out"

  prob = 125

  structure =
  {
    "..","11"
    "11","11"
    "22","22"
  }
}

SQUARE_OUT_EXTEND_AREA_BORDER =
{
  pass = "square_out"

  prob = 80

  structure =
  {
    "x1","x1"
    "2.","22"
  }
}

SQUARE_OUT_SMOOTH_EDGE =
{
  pass = "square_out"

  prob = 35

  structure =
  {
    "x1","x1"
    "1.","1/"
  }

  diagonals =
  {
    "1."
  }
}

SQUARE_OUT_SMOOTH_PLATFORM =
{
  pass = "square_out"

  prob = 50

  structure =
  {
    "x1x","x1x"
    "122","1/2"
    "x2x","x2x"
  }

  diagonals =
  {
    "12"
  }
}

SQUARE_OUT_REMOVE_TRIANGLE =
{
  pass = "square_out"

  prob = 15

  structure =
  {
    "1%","11"
    "x1","x1"
  }

  diagonals =
  {
    "1."
  }
}

--[LIQUEFY] - the liquid pool shapes is a pass that attempts to create more dynamic
--and organic liquid areas for non-park, non-cave rooms

LIQUEFY_SQ_CREATE =
{
  pass = "liquefy"

  prob = 5

  structure =
  {
    "1111","1111"
    "1111","1~~1"
    "1111","1~~1"
    "1111","1111"
  }
}

LIQUEFY_EG_CREATE =
{
  pass = "liquefy"

  prob = 3

  structure =
  {
    "1111","1111"
    "1111","1~%1"
    "1111","1~~1"
    "1111","1111"
  }

  diagonals =
  {
    "~1"
  }
}

LIQUEFY_MULTIAREA_CREATE =
{
  pass = "liquefy"

  prob = 2

  structure =
  {
    "1122","1122"
    "1122","1~~2"
    "1122","1~~2"
    "1122","1122"
  }
}

LIQUEFY_WALL_CREATE =
{
  pass = "liquefy"

  prob = 5

  structure =
  {
    "111#","111#"
    "111#","1~~#"
    "111#","1~~#"
    "111#","111#"
  }
}

LIQUEFY_FL_CREATE =
{
  pass = "liquefy"

  prob = 10

  structure =
  {
    "1111","1111"
    "1111","1~~1"
    "1111","1111"
  }
}

LIQUEFY_FLW_CREATE =
{
  pass = "liquefy"

  prob = 10

  structure =
  {
    "1111","1111"
    "1111","1~~1"
    "####","####"
  }
}

LIQUEFY_SQ_EXTEND =
{
  pass = "liquefy"

  prob = 25

  structure =
  {
    "x11","x11"
    "~11","~~1"
    "~11","~~1"
    "x11","x11"
  }
}

LIQUEFY_SQ_CORNER =
{
  pass = "liquefy"

  prob = 15

  structure =
  {
    "~~~x","~~~x"
    "~111","~~~1"
    "~111","~~~1"
    "1111","1111"
  }
}

LIQEUFY_SHAVE =
{
  pass = "liquefy"

  prob = 20

  structure =
  {
    "111","111"
    "1~~","1/~"
    "~~~","~~~"
  }

  diagonals =
  {
    "1~"
  }
}

--MSSP's random negative features [FEATURES] - 'negative' because they attempt to modify an existing room if it has too much clean space.

GROW_FEATURES_CENTER =
{
  prob = 25
  skip_prob = 30

  structure =
  {
    "1......","1111111"
    "1......","11/A%11"
    "x......","x1AAA11"
    "x......","x1%A/11"
    "x......","x111111"
  }

  diagonals =
  {
    "1.",".1"
    "1.",".1"
  }
}

GROW_FEATURES_CENTER_RAISED =
{
  prob = 10
  skip_prob = 50

  structure =
  {
    "1......","1111111"
    "1......","11/v%11"
    "x......","x1>A<11"
    "x......","x1%^/11"
    "x......","x111111"
  }

  diagonals =
  {
    "1.",".1"
    "1.",".1"
  }
}

GROW_FEATURES_OCT_MOATED_PLATFORM =
{
  prob = 20
  skip_prob = 50

  structure =
  {
    "......","111111"
    "......","111111"
    "......","~~~~~~"
    "......","~/AA%~"
    "......","~AAAA~"
    "......","~AAAA~"
    "......","~%AA/~"
    "......","~~~~~~"
    "....11","111111"
    "....11","111111"
  }

  diagonals =
  {
    "~.",".~"
    "~.",".~"
  }
}

GROW_FEATURES_RECT_MOATED_PLATFORM =
{
  prob = 20
  skip_prob = 50

  structure =
  {
    ".......","1111111"
    ".......","1111111"
    ".......","~~~~~~~"
    ".......","~#111#~"
    ".......","~~~~~~~"
    ".....11","1111111"
    ".....11","1111111"
  }
}

GROW_ELEVATED_PILLAR_ROUND =
{
  prob = 75
  skip_prob = 40

  env = "!cave"

  structure =
  {
    "x.......","x1111111"
    "1.......","1/AAA%11"
    "1.......","1AAAAA11"
    "1.......","1>A.AA11"
    "1.......","1AAAAA11"
    "1.......","1%AAA/11"
    "x.......","x1111111"
  }

  diagonals =
  {
    "1A","A1"
    "1A","A1"
  }
}

GROW_ELEVATED_PILLAR_U =
{
  prob = 50
  skip_prob = 50

  env = "!cave"

  structure =
  {
    "11xxx","11xxx"
    "1....","1>AAA"
    "1....","1>AAA"
    "xx...","xx.AA"
    "xx...","xxAAA"
    "xx...","xxAAA"
  }
}

GROW_ELEVATED_PILLAR_U_FULL =
{
  prob = 50
  skip_prob = 50

  env = "!cave"

  structure =
  {
    "111xxx","111xxx"
    "1.....","1>>AAA"
    "1.....","1>>AAA"
    "x.....","xAA.AA"
    "x.....","xAAAAA"
    "x.....","xAAAAA"
  }
}

GROW_WIDE_SPACE_DEPRESSION =
{
  prob = 38
  skip_prob = 70

  aversion = 5

  env = "!cave"

  structure =
  {
    "...","111"
    "...","111"
    "...","vvv"
    "...","AAA"
    "...","AAA"
    "...","^^^"
    "...","111"
    "11x","11x"
  }
}

GROW_WIDE_SPACE_CATWALK_PLAIN =
{
  prob = 50
  skip_prob = 35

  env = "!cave"

  structure =
  {
    "......","11AA11"
    "......","11AA11"
    "......","11^^11"
    "......","111111"
    "xx11xx","xx11xx"
  }
}

GROW_WIDE_SPACE_CATWALK_TALL_PLAIN =
{
  prob = 50
  skip_prob = 35

  env = "!cave"

  structure =
  {
    "......","11AA11"
    "......","11AA11"
    "......","11^^11"
    "......","11^^11"
    "......","111111"
    "xx11xx","xx11xx"
  }
}

GROW_WIDE_SPACE_PLATFORM_TINY =
{
  prob = 50
  skip_prob = 35

  env = "!cave"

  structure =
  {
    "......","11AA11"
    "......","11AA11"
    "......","11>A11"
    "......","111111"
    "xx11xx","xx11xx"
  }
}

GROW_HALF_SKILLET =
{
  prob = 25
  skip_prob = 25

  structure =
  {
    "x.......","x1111111"
    "1.......","11111111"
    "1.......","11>AAAAA"
    "1.......","11>AAAAA"
  }
}

GROW_HALF_SKILLET_SPIRAL =
{
  prob = 25
  skip_prob = 25

  structure =
  {
    "11.......","111111111"
    "11.......","111111111"
    "xx.......","xxAAAA<11"
    "xx.......","xxAAAA<11"
  }
}

GROW_WIDE_LOW_CEILING_SIDE =
{
  prob = 20
  skip_prob = 60

  structure =
  {
    "....","1111"
    "....","1111"
    "....","1.AA"
    "....","1AAA"
    "....","1AAA"
    "....","1.AA"
    "11..","1111"
    "11xx","11xx"
  }
}

GROW_WIDE_LOW_CEILING_CENTER =
{
  prob = 20
  skip_prob = 60

  structure =
  {
    "......","111111"
    "......","111111"
    "......","1.AA.1"
    "......","1AAAA1"
    "......","1AAAA1"
    "......","1.AA.1"
    "......","111111"
    "xx11xx","xx11xx"
  }
}

GROW_WIDE_LOW_CEILING_CORNER =
{
  prob = 20
  skip_prob = 65

  structure =
  {
    ".....","AAAA1"
    ".....","AAA#1"
    ".....","AAA/1"
    ".....","A#/11"
    "1111x","1111x"
  }

  diagonals =
  {
    "A1"
    "A1"
  }
}

GROW_COLLONADE_3_PILLARS =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "11.......","111111111"
    "11.......","11#A#A#11"
    "x........","x1AAAAA11"
    "x........","x1AAAAA11"
  }
}

GROW_TRIANGULAR_LOW_CEILING =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "xxx111xxx","xxx111xxx"
    ".........","111111111"
    ".........","111/.%111"
    ".........","11/AAA%11"
    ".........","1/AAAAA%1"
    "x!xxxxx!x","x!xxxxx!x"
  }

  diagonals =
  {
    "1A","A1"
    "1A","A1"
    "1A","A1"
  }
}

GROW_PILLAR_2X2 =
{
  prob = 10

  structure =
  {
    "1.....","111111"
    "1.....","11..11"
    "x.....","x1..11"
    "x.....","x11111"
  }
}

GROW_PILLAR_3X3 =
{
  prob = 10

  structure =
  {
    "1......","1111111"
    "1......","11/#%11"
    "x......","x1###11"
    "x......","x1%#/11"
    "x......","x111111"
  }

  diagonals =
  {
    "1.",".1"
    "1.",".1"
  }
}

GROW_PILLAR_3x3_TOP_SLOPE =
{
  prob = 10

  structure =
  {
    "......","111111"
    "......","1/A%11"
    "......","1A#A11"
    "......","1%A/11"
    "......","111111"
    "x111xx","x111xx"
  }

  diagonals =
  {
    "1A","A1"
    "1A","A1"
  }
}

GROW_PILLAR_TORII =
{
  prob = 10

  structure =
  {
    "........","11111111"
    "........","1#A1A#11"
    "........","11111111"
    "xx111xxx","xx111xxx"
  }
}

GROW_PILLAR_BEAN =
{
  prob = 10

  structure =
  {
    ".....","11111"
    ".....","1/#11"
    ".....","1#/11"
    ".....","11111"
    "x11xx","x11xx"
  }

  diagonals =
  {
    "1."
    ".1"
  }
}

GROW_PILLAR_GATE =
{
  prob = 20
  skip_prob = 25

  structure =
  {
    "......","111111"
    "......","111111"
    "......","1#AA#1"
    "11....","111111"
    "11xxxx","11xxxx"
  }
}

DECORATE_CATWALK_SUPPORT_PILLAR_OUTER =
{
  prob = 8
  skip_prob = 80

  structure =
  {
    "....","1122"
    "....","1.22"
    "1122","1122"
  }
}

DECORATE_CATWALK_SUPPORT_PILLAR_INNER_DOUBLE =
{
  prob = 15
  skip_prob = 80

  structure =
  {
    "....","1122"
    "....","11.2"
    "....","1122"
    "....","11.2"
    "1122","1122"
  }
}

DECORATE_CATWALK_LUMP =
{
  prob = 15

  structure =
  {
    "111111","111111"
    "111111","1/22%1"
    "222222","222222"
  }

  diagonals =
  {
    "12","21"
  }
}

GROW_CHAMFER_WIDE_ROOM_CORNER =
{
  prob = 25
  skip_prob = 75

  structure =
  {
    "xxx...","xxx/11"
    "xx....","xx/111"
    "x.....","x/1111"
    "1.....","111111"
    "1.....","111111"
  }


  diagonals =
  {
    ".1"
    ".1"
    ".1"
  }
}

GROW_CHAMFER_WIDE_ROOM_CORNER_OUTLET =
{
  prob = 25
  skip_prob = 75

  structure =
  {
    "xxxx..","xxxx11"
    "xxxx..","xxxx11"
    "xxx...","xxx/11"
    "1.....","111111"
    "1.....","111111"
  }

  diagonals =
  {
    ".1"
  }
}

-- MSSP's 3.x/6.x-style rooms [6.x]
-- supposedly more or less trying to replicate the strange ceiling
-- layouts found in 3.x/6.x

GROW_36_DOUBLE_AREA =
{
  prob = 35
  skip_prob = 80

  structure =
  {
    "......","AAAA11"
    "......","AAAA11"
    "xx....","xx1111"
    "xx....","xx1111"
    "xx....","xx1111"
    "xx....","xx1111"
    "....11","AAAA11"
    "....11","AAAA11"
  }
}

GROW_36_SINGLE_AREA =
{
  prob = 30
  skip_prob = 80

  structure =
  {
    "x....","x1111"
    "x....","x1111"
    ".....","AAA11"
    ".....","AAA11"
    ".....","AAA11"
    ".....","AAA11"
    "x..11","x1111"
    "x..11","x1111"
  }
}

GROW_36_TRIPLE_AREA =
{
  prob = 20
  skip_prob = 80

  structure =
  {
    "....","AA11"
    "....","AA11"
    "x...","x111"
    "x...","x111"
    "....","AA11"
    "....","AA11"
    "x...","x111"
    "x...","x111"
    "..11","AA11"
    "..11","AA11"
  }
}

GROW_36_DOUBLE_FORWARD_AREA =
{
  prob = 25
  skip_prob = 75

  structure =
  {
    "..xxxx..","AAxxxxAA"
    "........","AA1111AA"
    "x......x","x111111x"
    "x......x","x111111x"
    "x......x","x111111x"
    "xxx11xxx","xxx11xxx"
  }
}

GROW_36_QUAD_FORWARD_AREA =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "..xxxx..","AAxxxxAA"
    "........","AA1111AA"
    "x......x","x111111x"
    "x......x","x111111x"
    "x......x","x111111x"
    "x......x","x111111x"
    "........","AA1111AA"
    "........","AA1111AA"
    "xxx11xxx","xxx11xxx"
  }
}

GROW_36_SINGLE_FORWARD_AREA =
{
  prob = 35
  skip_prob = 75

  structure =
  {
    "x....x","xAAAAx"
    "......","1AAAA1"
    "......","111111"
    "......","111111"
    "......","111111"
    "xx11xx","xx11xx"
  }
}

GROW_36_ROUND_NEW_AREA =
{
  prob = 25
  skip_prob = 75

  structure =
  {
    "xx....xx","xx1111xx"
    "x......x","x/1111%x"
    "........","11/AA%11"
    "........","11AAAA11"
    "........","11AAAA11"
    "........","11%AA/11"
    "x......x","x%1111/x"
    "xxx11xxx","xxx11xxx"
  }

  diagonals =
  {
    ".1","1."
    "1A","A1"
    "1A","A1"
    ".1","1."
  }
}

GROW_36_CROSS_NEW_AREA =
{
  prob = 25
  skip_prob = 75

  structure =
  {
    "xx....xx","xx1111xx"
    "xx....xx","xx1111xx"
    "........","11AAAA11"
    "........","11AAAA11"
    "........","11AAAA11"
    "........","11AAAA11"
    "xx....xx","xx1111xx"
    "xxx11xxx","xxx11xxx"
  }
}

GROW_36_TEE_NEW_AREA =
{
  prob = 25
  skip_prob = 75

  structure =
  {
    "........","11AAAA11"
    "........","11AAAA11"
    "........","11AAAA11"
    "........","11AAAA11"
    "xx....xx","xx1111xx"
    "xxx11xxx","xxx11xxx"
  }
}

GROW_36_CROSS_NEW_AREA_SMALL =
{
  prob = 25
  skip_prob = 75

  structure =
  {
    "xx..xx","xx11xx"
    "xx..xx","xx11xx"
    "......","11AA11"
    "......","11AA11"
    "xx..xx","xx11xx"
    "xx11xx","xx11xx"
  }
}

GROW_36_TEE_NEW_AREA_SMALL =
{
  prob = 25
  skip_prob = 75

  structure =
  {
    "......","11AA11"
    "......","11AA11"
    "xx..xx","xx11xx"
    "xx11xx","xx11xx"
  }
}

GROW_36_ATARI_LOGO_NEW_AREA =
{
  prob = 25
  skip_prob = 75

  structure =
  {
    "......","AA11AA"
    "......","AA11AA"
    "......","AA11AA"
    "......","AA11AA"
    "......","A/11%A"
    "......","111111"
    "......","111111"
    "xx11xx","xx11xx"
  }

  diagonals =
  {
    "A1","1A"
  }
}

GROW_36_INVERSE_ATARI_LOGO_NEW_AREA =
{
  prob = 25
  skip_prob = 75

  structure =
  {
    "........","11AAAA11"
    "........","11AAAA11"
    "........","11AAAA11"
    "........","11AAAA11"
    "........","11%AA/11"
    "........","11111111"
    "........","11111111"
    "xxx11xxx","xxx11xxx"
  }

  diagonals =
  {
    "1A","A1"
  }
}

GROW_36_RIBBED_WALLS_NEW_AREA_DOUBLE =
{
  prob = 15
  skip_prob = 80

  structure =
  {
    "xx....","xxAAAA"
    "xx....","xxAAAA"
    "......","11AAAA"
    "......","11AAAA"
    "xx....","xxAAAA"
    "xx....","xxAAAA"
    "......","11AAAA"
    "......","11AAAA"
    "xx....","xxAAAA"
    "xx....","xxAAAA"
    "xxx11x","xxx11x"
  }
}

GROW_36_RIBBED_WALLS_NEW_AREA_SINGLE =
{
  prob = 15
  skip_prob = 80

  structure =
  {
    "x....","xAAAA"
    ".....","1AAAA"
    "x....","xAAAA"
    ".....","1AAAA"
    "x....","xAAAA"
    ".....","1AAAA"
    "x....","xAAAA"
    "xx11x","xx11x"
  }
}

GROW_36_PEANUT_NEW_AREA =
{
  prob = 15
  skip_prob = 80

  structure =
  {
    "xxx....xx","xxxAAAAxx"
    "x........","x11AAAA11"
    "x........","x11AAAA11"
    "x........","x11%AA/11"
    "1........","1111AA111"
    "1........","1111AA111"
    "x........","x11/AA%11"
    "x........","x11AAAA11"
    "x........","x11AAAA11"
    "xxx....xx","xxxAAAAxx"
  }

  diagonals =
  {
    "1A","A1"
    "1A","A1"
  }
}

GROW_36_4PILLAR_ARCHS_NEW_AREA =
{
  prob = 15
  skip_prob = 75

  structure =
  {
    "x......x","x111111x"
    "x......x","x111111x"
    "........","AA#AA#AA"
    "........","AAAAAAAA"
    "........","AAAAAAAA"
    "........","AA#AA#AA"
    "x......x","x111111x"
    "x......x","x111111x"
    "xxx11xxx","xxx11xxx"
  }
}


GROW_36_4PILLAR_OPEN_ROOF_GAZEBO_NEW_AREA =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "........","11111111"
    "........","11111111"
    "........","11#AA#11"
    "........","11A11A11"
    "........","11A11A11"
    "........","11#AA#11"
    "........","11111111"
    "........","11111111"
    "xxx11xxx","xxx11xxx"
  }
}

GROW_36_CANDY =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "........","11111111"
    "........","11111111"
    "........","11/AA%11"
    "........","AAAAAAAA"
    "........","AAA##AAA"
    "........","AAA##AAA"
    "........","AAAAAAAA"
    "........","11%AA/11"
    "........","11111111"
    "........","11111111"
    "xxx11xxx","xxx11xxx"
  }

  diagonals =
  {
    "1A","A1"
    "1A","A1"
  }
}

GROW_36_CENTER_PILLAR_CROSSED =
{
  prob = 20

  skip_prob = 80

  structure =
  {
    "........","/11AA11%"
    "........","111AA111"
    "........","111AA111"
    "........","AAAAAAAA"
    "........","AAAAAAAA"
    "........","111AA111"
    "........","111AA111"
    "........","%11AA11/"
    "xxx11xxx","xxx11xxx"
  }

  diagonals =
  {
    ".1","1."
    ".1","1."
  }
}

GROW_36_TRIPLE_DIAMONDS =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "...x","111x"
    "....","11/%"
    "....","11%/"
    "...x","111x"
    "....","11/%"
    "....","11%/"
    "...x","111x"
    "....","11/%"
    "....","11%/"
    ".11x","111x"
    ".11x","111x"
  }

  diagonals =
  {
    "1A","A."
    "1A","A."
    "1A","A."
    "1A","A."
    "1A","A."
    "1A","A."
  }
}

GROW_36_DOUBLE_LONG_DIAMONDS =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "...x","111x"
    "....","11/%"
    "....","11AA"
    "....","11%/"
    "...x","111x"
    "....","11/%"
    "....","11AA"
    "....","11%/"
    ".11x","111x"
    ".11x","111x"
  }

  diagonals =
  {
    "1A","A."
    "1A","A."
    "1A","A."
    "1A","A."
  }
}

GROW_36_LONG_DIAMOND =
{
  prob = 25
  skip_prob = 60

  structure =
  {
    "xx....xx","xx/AA%xx"
    "........","11%AA/11"
    "........","11111111"
    "...11...","11111111"
    "xxx11xxx","xxx11xxx"
  }

  diagonals =
  {
    ".A","A."
    "1A","A1"
  }
}

GROW_36_LONG_DIMAOND_STAIRS =
{
  prob = 25
  skip_prob = 75

  structure =
  {
    "xx......xx","xx/AAAA%xx"
    "..........","11%AAAA/11"
    "..........","1111^^1111"
    "....11....","1111111111"
    "xxxx11xxxx","xxxx11xxxx"
  }

  diagonals =
  {
    ".A","A."
    "1A","A1"
  }
}

GROW_36_CORNER_DIAMOND =
{
  prob = 25
  skip_prob = 70

  structure =
  {
    "x..xx","x/Axx"
    ".....","/A/11"
    ".....","A/111"
    "x..11","x1111"
    "x..11","x1111"
  }

  diagonals =
  {
         ".A"
    ".A","A1"
    "A1"
  }
}

-- [4x3_ALPHABET]

GROW_3x_A =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "xx11xx","xx11xx"
    "x....x","x/11%x"
    "......","/1111%"
    "..xx..","11xx11"
    "..xx..","11xx11"
    "......","111111"
    "......","111111"
    "..xx..","11xx11"
    "..xx..","11xx11"
  }

  diagonals =
  {
    ".1","1."
    ".1","1."
  }
}

GROW_3x_A_STAIRS =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "xx11xx","xx11xx"
    "x....x","x/11%x"
    "......","/1111%"
    "..xx..","11xx11"
    "..xx..","vvxxvv"
    "......","AAAAAA"
    "......","AAAAAA"
    "..xx..","AAxxAA"
    "..xx..","AAxxAA"
  }

  diagonals =
  {
    ".1","1."
    ".1","1."
  }
}

GROW_3x_A_LIQUID =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "xx11xx","xx11xx"
    "x....x","x/11%x"
    "......","/1111%"
    "......","11~~11"
    "......","11~~11"
    "......","111111"
    "......","111111"
    "......","11~~11"
    "......","11~~11"
  }

  diagonals =
  {
    ".1","1."
    ".1","1."
  }
}

GROW_3x_B =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "11xxxx","11xxxx"
    "......","11111%"
    "..x...","11x111"
    "..x...","11x11/"
    ".....x","11111x"
    ".....x","11111x"
    "..x...","11x11%"
    "..x...","11x111"
    "......","11111/"
  }

  diagonals =
  {
    "1."
    "1."
    "1."
    "1."
  }
}

GROW_3x_B_STAIRS =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "11xxxx","11xxxx"
    "......","11>AA%"
    "..x...","11xAAA"
    "..x...","11xAA/"
    ".....x","11>AAx"
    ".....x","11>AAx"
    "..x...","11xAA%"
    "..x...","11xAAA"
    "......","11>AA/"
  }

  diagonals =
  {
    "A."
    "A."
    "A."
    "A."
  }
}

GROW_3x_B_LIQUID =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "11xxxx","11xxxx"
    "......","11111%"
    "......","11~111"
    "......","11~11/"
    "......","11111~"
    "......","11111~"
    "......","11~11%"
    "......","11~111"
    "......","11111/"
  }

  diagonals =
  {
    "1."
    "1~"
    "1~"
    "1."
  }
}

GROW_3x_C =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "xxx11x","xxx11x"
    "......","/1111%"
    "......","111111"
    "..xx..","11xx11"
    "..xxxx","11xxxx"
    "..xxxx","11xxxx"
    "..xx..","11xx11"
    "......","111111"
    "......","%1111/"
  }

  diagonals =
  {
    ".1","1."
    ".1","1."
  }
}

GROW_3x_C_STAIRS =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "xxx11x","xxx11x"
    "......","/A<11%"
    "......","AA<111"
    "..xx..","AAxx11"
    "..xxxx","AAxxxx"
    "..xxxx","AAxxxx"
    "..xx..","AAxx11"
    "......","AA<111"
    "......","%A<11/"
  }

  diagonals =
  {
    ".A","1."
    ".A","1."
  }
}

GROW_3x_C_LIQUID =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "xxx11x","xxx11x"
    "......","/1111%"
    "......","111111"
    "......","11~~11"
    "......","11~~~~"
    "......","11~~~~"
    "......","11~~11"
    "......","111111"
    "......","%1111/"
  }

  diagonals =
  {
    ".1","1."
    ".1","1."
  }
}

GROW_3x_D =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "x......","x11111%"
    "x......","x111111"
    "x..xx..","x11xx11"
    "x..xx..","x11xx11"
    "x..xx..","x11xx11"
    "x..xx..","x11xx11"
    "1......","1111111"
    "1......","111111/"
  }

  diagonals =
  {
    "1."
    "1."
  }
}

GROW_3x_D_STAIRS =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "x......","xAAAAA%"
    "x......","xAAAAAA"
    "x..xx..","x11xxAA"
    "x..xx..","x11xxAA"
    "x..xx..","x11xx^^"
    "x..xx..","x11xx11"
    "1......","1111111"
    "1......","111111/"
  }

  diagonals =
  {
    "A."
    "1."
  }
}

GROW_3x_D_LIQUID_STAIRS =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "x......","x11>AA%"
    "x......","x11>AAA"
    "x......","x11~~AA"
    "x......","x11~~AA"
    "x......","x11~~AA"
    "x......","x11~~AA"
    "1......","111>AAA"
    "1......","111>AA/"
  }

  diagonals =
  {
    "A."
    "A."
  }
}

GROW_3x_E =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "......1","1111111"
    "......1","1111111"
    "..xxxxx","11xxxxx"
    "....xxx","1111xxx"
    "....xxx","1111xxx"
    "..xxxxx","11xxxxx"
    "......x","111111x"
    "......x","111111x"
  }
}

GROW_3x_E_STAIRS =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "......1","1111111"
    "......1","1111111"
    "..xxxxx","vvxxxxx"
    "....xxx","AAAAxxx"
    "....xxx","AAAAxxx"
    "..xxxxx","^^xxxxx"
    "......x","111111x"
    "......x","111111x"
  }
}

GROW_3x_E_LIQUID =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "......1","1111111"
    "......1","1111111"
    "......x","11~~~~x"
    "......x","1111~~x"
    "......x","1111~~x"
    "......x","11~~~~x"
    "......x","111111x"
    "......x","111111x"
  }
}

GROW_3x_E_LIQUID_STAIRS =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "......1","AAA<111"
    "......1","AAA<111"
    "......x","AA~~~~x"
    "......x","AAAA~~x"
    "......x","AAAA~~x"
    "......x","AA~~~~x"
    "......x","AAA<11x"
    "......x","AAA<11x"
  }
}

GROW_3x_F =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "......","111111"
    "......","111111"
    "..xxxx","11xxxx"
    "....xx","1111xx"
    "....xx","1111xx"
    "..xxxx","11xxxx"
    "..xxxx","11xxxx"
    "..xxxx","11xxxx"
    "11xxxx","11xxxx"
  }
}

GROW_3x_F_STAIRS =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "......","111111"
    "......","111111"
    "..xxxx","vvxxxx"
    "....xx","AAAAxx"
    "....xx","AAAAxx"
    "..xxxx","^^xxxx"
    "..xxxx","11xxxx"
    "..xxxx","11xxxx"
    "11xxxx","11xxxx"
  }
}

GROW_3x_F_LIQUID =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "......","111111"
    "......","111111"
    "......","11~~~~"
    "......","1111~~"
    "......","1111~~"
    "......","11~~~~"
    "....xx","11~~xx"
    "....xx","11~~xx"
    "11xxxx","11xxxx"
  }
}

GROW_3x_G =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "......1","/111111"
    "......1","1111111"
    "..xxxxx","11xxxxx"
    "..x...x","11x111x"
    "..x...x","11x111x"
    "..xx..x","11xx11x"
    "......x","111111x"
    "......x","%1111/x"
  }

  diagonals =
  {
    ".1"
    ".1","1."
  }
}

GROW_3x_G_STAIRS =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "......1","/111111"
    "......1","1111111"
    "..xxxxx","vvxxxxx"
    "..x...x","AAxAAAx"
    "..x...x","AAxAAAx"
    "..xx..x","^^xx^^x"
    "......x","111111x"
    "......x","%1111/x"
  }

  diagonals =
  {
    ".1"
    ".1","1."
  }
}

GROW_3x_G_LIQUID =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "......1","/111111"
    "......1","1111111"
    "......x","11~~~~x"
    "......x","11~111x"
    "......x","11~111x"
    "......x","11~~11x"
    "......x","111111x"
    "......x","%1111/x"
  }

  diagonals =
  {
    ".1"
    ".1","1."
  }
}

GROW_3x_H =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "11xxxx","11xxxx"
    "..xx..","11xx11"
    "..xx..","11xx11"
    "..xx..","11xx11"
    "......","111111"
    "......","111111"
    "..xx..","11xx11"
    "..xx..","11xx11"
    "..xx..","11xx11"
  }
}

GROW_3x_H_STAIRS =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "11xxxx","11xxxx"
    "..xx..","11xxAA"
    "..xx..","11xxAA"
    "..xx..","vvxxAA"
    "......","AAAAAA"
    "......","AAAAAA"
    "..xx..","AAxx^^"
    "..xx..","AAxx11"
    "..xx..","AAxx11"
  }
}

GROW_3x_H_LIQUID =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "11xxxx","11xxxx"
    "......","11~~11"
    "......","11~~11"
    "......","11~~11"
    "......","111111"
    "......","111111"
    "......","11~~11"
    "......","11~~11"
    "......","11~~11"
  }
}

GROW_3x_LIQUID_STAIRS =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "11xxxx","11xxxx"
    "......","11~~11"
    "......","11~~11"
    "......","vv~~vv"
    "......","AAAAAA"
    "......","AAAAAA"
    "......","^^~~^^"
    "......","11~~11"
    "......","11~~11"
  }
}

GROW_3x_I =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "x....x","x1111x"
    "x....x","x1111x"
    "xx..xx","xx11xx"
    "xx..xx","xx11xx"
    "xx..xx","xx11xx"
    "xx..xx","xx11xx"
    "x....x","x1111x"
    "x....x","x1111x"
    "xx11xx","xx11xx"
  }
}

GROW_3x_I_STAIRS =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "x....x","xAAAAx"
    "x....x","xAAAAx"
    "xx..xx","xxAAxx"
    "xx..xx","xx^^xx"
    "xx..xx","xx^^xx"
    "xx..xx","xx11xx"
    "x....x","x1111x"
    "x....x","x1111x"
    "xx11xx","xx11xx"
  }
}

GROW_3x_I_STAIRS_UP_DOWN =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "x....x","x1111x"
    "x....x","x1111x"
    "xx..xx","xxvvxx"
    "xx..xx","xxAAxx"
    "xx..xx","xxAAxx"
    "xx..xx","xx^^xx"
    "x....x","x1111x"
    "x....x","x1111x"
    "xx11xx","xx11xx"
  }
}

GROW_3x_I_LIQUID =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "x....x","x1111x"
    "x....x","x1111x"
    "......","~~11~~"
    "......","~~11~~"
    "......","~~11~~"
    "......","~~11~~"
    "x....x","x1111x"
    "x....x","x1111x"
    "xx11xx","xx11xx"
  }
}

GROW_3x_J =
{
  prob = 20
  skip_prob = 80

  structure =
  {
    "11xxxx","11xxxx"
    "..xxxx","11xxxx"
    "..xxxx","11xxxx"
    "..xxxx","11xxxx"
    "..xxxx","11xxxx"
    "..xx..","11xx11"
    "..xx..","11xx11"
    "......","111111"
    "......","%1111/"
  }

  diagonals =
  {
    ".1","1."
  }
}

GROW_3x_J_LIQUID =
{
  prob = 20
  skip_prob = 80

  structure =
  {
    "11xxxx","11xxxx"
    "....xx","11~~xx"
    "....xx","11~~xx"
    "......","11~~~~"
    "......","11~~~~"
    "......","11~~11"
    "......","11~~11"
    "......","111111"
    "......","%1111/"
  }

  diagonals =
  {
    ".1","1."
  }
}

GROW_3x_K =
{
  prob = 10
  skip_prob = 82

  structure =
  {
    "..xx..","11xx11"
    "..x...","11x/11"
    "......","11/11/"
    ".....x","1111/x"
    ".....x","1111%x"
    "......","11%11%"
    "..x...","11x%11"
    "..xx..","11xx11"
    "11xxxx","11xxxx"
  }

  diagonals =
  {
    ".1"
    ".1","1."
         "1."
         "1."
    ".1","1."
    ".1"
  }
}

GROW_3x_K_STAIRS =
{
  prob = 10
  skip_prob = 82

  structure =
  {
    "..xx..","11xxAA"
    "..x...","11x/AA"
    "......","11/AA/"
    ".....x","11>A/x"
    ".....x","11>A%x"
    "......","11%AA%"
    "..x...","11x%AA"
    "..xx..","11xxAA"
    "11xxxx","11xxxx"
  }

  diagonals =
  {
    ".A"
    ".A","A."
         "A."
         "A."
    ".A","A."
    ".A"
  }
}

GROW_3x_K_LIQUID =
{
  prob = 10
  skip_prob = 75

  structure =
  {
    "......","11~~11"
    "......","11~/11"
    "......","11/11/"
    "......","1111/~"
    "......","1111%~"
    "......","11%11%"
    "......","11~%11"
    "......","11~~11"
    "11xxxx","11xxxx"
  }

  diagonals =
  {
    "~1"
    "~1","1~"
         "1~"
         "1~"
    "~1","1~"
    "~1"
  }
}

GROW_3x_L =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "11xxxx","11xxxx"
    "..xxxx","11xxxx"
    "..xxxx","11xxxx"
    "..xxxx","11xxxx"
    "..xxxx","11xxxx"
    "..xxxx","11xxxx"
    "..xxxx","11xxxx"
    "......","111111"
    "......","111111"
  }
}

GROW_3x_L_LIQUID =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "11xxxx","11xxxx"
    "..xxxx","11xxxx"
    "..xxxx","11xxxx"
    "......","11~~~%"
    "......","11~~~~"
    "......","11~~~~"
    "......","11~~~~"
    "......","111111"
    "......","111111"
  }

  diagonals =
  {
    "~."
  }
}

GROW_3x_L_UP_DOWN =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "11xxxx","11xxxx"
    "..xxxx","11xxxx"
    "..xxxx","vvxxxx"
    "..xxxx","AAxxxx"
    "..xxxx","AAxxxx"
    "..xxxx","AAxxxx"
    "..xxxx","AAxxxx"
    "......","AAA<11"
    "......","AAA<11"
  }

  diagonals =
  {
    "~."
  }
}

GROW_3x_M =
{
  prob = 10
  skip_prob = 75

  structure =
  {
    "...xx...","11%xx/11"
    "........","111%/111"
    "........","11111111"
    "........","11%11/11"
    "..x..x..","11x11x11"
    "..x..x..","11x11x11"
    "..x..x..","11x11x11"
    "..x..x..","11x11x11"
    "xxx11xxx","xxx11xxx"
  }

  diagonals =
  {
    "1.",".1"
    "1.",".1"
    ".1","1."
  }
}

GROW_3x_N =
{
  prob = 10
  skip_prob = 75

  structure =
  {
    "...x..","11%x11"
    "......","111%11"
    "......","111111"
    "......","111111"
    "......","11%111"
    "..x...","11x%11"
    "..xx..","11xx11"
    "..xx..","11xx11"
    "11xxxx","11xxxx"
  }

  diagonals =
  {
    "1."
      "1."
    ".1"
      ".1"
  }
}

GROW_3x_N_LIQUID =
{
  prob = 10
  skip_prob = 75

  structure =
  {
    "..~~..","11~~11"
    "...~..","11%~11"
    "......","111%11"
    "......","111111"
    "......","111111"
    "......","11%111"
    "..~...","11~%11"
    "..~~..","11~~11"
    "11xxxx","11xxxx"
  }

  diagonals =
  {
    "1~"
      "1~"
    "~1"
      "~1"
  }
}

GROW_3x_O =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "xx11xx","xx11xx"
    "......","/1111%"
    "......","111111"
    "..xx..","11xx11"
    "..xx..","11xx11"
    "..xx..","11xx11"
    "..xx..","11xx11"
    "......","111111"
    "......","%1111/"
  }

  diagonals =
  {
    ".1","1."
    ".1","1."
  }
}

GROW_3x_O_LIQUID =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "xx11xx","xx11xx"
    "......","/1111%"
    "......","111111"
    "......","11~~11"
    "......","11~~11"
    "......","11~~11"
    "......","11~~11"
    "......","111111"
    "......","%1111/"
  }

  diagonals =
  {
    ".1","1."
    ".1","1."
  }
}

GROW_3x_O_UP_DOWN =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "xx11xx","xx11xx"
    "......","/1111%"
    "......","111111"
    "......","vv..vv"
    "......","AA..AA"
    "......","AA..AA"
    "......","^^..^^"
    "......","111111"
    "......","%1111/"
  }

  diagonals =
  {
    ".1","1."
    ".1","1."
  }
}

GROW_3x_P =
{
  prob = 15
  skip_prob = 75

  structure =
  {
    "......","11111%"
    "......","111111"
    "..xx..","11xx11"
    "..xx..","11xx11"
    "......","111111"
    "......","11111/"
    "..xxxx","11xxxx"
    "..xxxx","11xxxx"
    "11xxxx","11xxxx"
  }

  diagonals =
  {
    "1."
    "1."
  }
}

GROW_3x_P_STAIRS =
{
  prob = 15
  skip_prob = 75

  structure =
  {
    "......","11>>A%"
    "......","11>>AA"
    "..xx..","11xxAA"
    "..xx..","11xxAA"
    "......","11>>AA"
    "......","11>>A/"
    "..xxxx","11xxxx"
    "..xxxx","11xxxx"
    "11xxxx","11xxxx"
  }

  diagonals =
  {
    "A."
    "A."
  }
}

GROW_3x_P_LIQUID =
{
  prob = 15
  skip_prob = 75

  structure =
  {
    "......","11111%"
    "......","111111"
    "......","11~~11"
    "......","11~~11"
    "......","111111"
    "......","11111/"
    "....xx","11~~xx"
    "....xx","11~~xx"
    "11xxxx","11xxxx"
  }

  diagonals =
  {
    "1."
    "1."
  }
}

GROW_3x_P_LIQUID_STAIRS =
{
  prob = 15
  skip_prob = 75

  structure =
  {
    "......","11>>A%"
    "......","11>>AA"
    "......","11~~AA"
    "......","11~~AA"
    "......","11>>AA"
    "......","11>>A/"
    "....xx","11~~xx"
    "....xx","11~~xx"
    "11xxxx","11xxxx"
  }

  diagonals =
  {
    "A."
    "A."
  }
}

-- Q

GROW_3x_R =
{
  prob = 15
  skip_prob = 75

  structure =
  {
    "......","11111%"
    "......","111111"
    "..xx..","11xx11"
    "..xx..","11xx11"
    "......","11111/"
    "......","11111%"
    "..xx..","11xx11"
    "..xx..","11xx11"
    "11xxxx","11xxxx"
  }

  diagonals =
  {
    "1."
    "1."
    "1."
  }
}

GROW_3x_R_LIQUID =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "......","11111%"
    "......","111111"
    "......","11~~11"
    "......","11~~11"
    "......","11111/"
    "......","11111%"
    "......","11~~11"
    "......","11~~11"
    "11xxxx","11xxxx"
  }

  diagonals =
  {
    "1."
    "1."
    "1."
  }
}

GROW_3x_S =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "x......","x/11111"
    "x......","x111111"
    "x..xxxx","x11xxxx"
    "x......","x11111%"
    "x......","x%11111"
    "xxxxx..","xxxxx11"
    "1......","1111111"
    "1......","111111/"
  }

  diagonals =
  {
    ".1"
    "1."
    ".1"
    "1."
  }
}

GROW_3x_S_LIQUID =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "x......","x/11111"
    "x......","x111111"
    "x......","x11~~~~"
    "x......","x11111%"
    "x......","x%11111"
    "x......","x~~~~11"
    "1......","1111111"
    "1......","111111/"
  }

  diagonals =
  {
    ".1"
    "1."
    ".1"
    "1."
  }
}

GROW_3x_S_STAIRS =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "x......","x/AAAAA"
    "x......","xAAAAAA"
    "x..xxxx","xAAxxxx"
    "x......","xAA<<1%"
    "x......","x%A<<11"
    "xxxxx..","xxxxx11"
    "1......","1111111"
    "1......","111111/"
  }

  diagonals =
  {
    ".A"
    "1."
    ".A"
    "1."
  }
}

GROW_3x_S_STAIRS_LIQUID =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "x......","x/AAAAA"
    "x......","xAAAAAA"
    "x......","xAA~~~~"
    "x......","xAA<<1%"
    "x......","x%A<<11"
    "x......","x~~~~11"
    "1......","1111111"
    "1......","111111/"
  }

  diagonals =
  {
    ".A"
    "1."
    ".A"
    "1."
  }
}

GROW_3x_T =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "......","111111"
    "......","111111"
    "xx..xx","xx11xx"
    "xx..xx","xx11xx"
    "xx..xx","xx11xx"
    "xx..xx","xx11xx"
    "xx..xx","xx11xx"
    "xx..xx","xx11xx"
    "xx11xx","xx11xx"
  }
}

GROW_3x_T_LIQUID =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "......","111111"
    "......","111111"
    "......","~~11~~"
    "......","~~11~~"
    "......","~~11~~"
    "......","~~11~~"
    "......","~~11~~"
    "......","~~11~~"
    "xx11xx","xx11xx"
  }
}

GROW_3x_U =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "11xxxx","11xxxx"
    "..xx..","11xx11"
    "..xx..","11xx11"
    "..xx..","11xx11"
    "..xx..","11xx11"
    "..xx..","11xx11"
    "..xx..","11xx11"
    "......","111111"
    "......","%1111/"
  }

  diagonals =
  {
    ".1","1."
  }
}

GROW_3x_U_LIQUID =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "11xxxx","11xxxx"
    "......","11~~11"
    "......","11~~11"
    "......","11~~11"
    "......","11~~11"
    "......","11~~11"
    "......","11~~11"
    "......","111111"
    "......","%1111/"
  }

  diagonals =
  {
    ".1","1."
  }
}

-- V (mostly the same as 'Y' or 'U'?)

-- W (just the upside-down of 'M')

GROW_3x_X =
{
  prob = 10
  skip_prob = 80

  structure =
  {
    "..xx..","11xx11"
    "..xx..","11xx11"
    "......","11%/11"
    "......","%1111/"
    "......","/1111%"
    "......","11/%11"
    "..xx..","11xx11"
    "..xx..","11xx11"
    "11xxxx","11xxxx"
  }

  diagonals =
  {
    "1.",".1"
    ".1","1."
    ".1","1."
    "1.",".1"
  }
}

GROW_3x_Y =
{
  prob = 10
  skip_prob = 75

  structure =
  {
    "..xx..","11xx11"
    "..xx..","11xx11"
    "......","11%/11"
    "......","%1111/"
    "x....x","x%11/x"
    "xx..xx","xx11xx"
    "xx..xx","xx11xx"
    "xx..xx","xx11xx"
    "xx11xx","xx11xx"
  }

  diagonals =
  {
    "1.",".1"
    ".1","1."
    ".1","1."
  }
}

GROW_3x_Y_STAIRS =
{
  prob = 10
  skip_prob = 75

  structure =
  {
    "..xx..","AAxxAA"
    "..xx..","AAxxAA"
    "..xx..","^^xx^^"
    "......","11%/11"
    "......","%1111/"
    "x....x","x%11/x"
    "xx..xx","xx11xx"
    "xx..xx","xx11xx"
    "xx..xx","xx11xx"
    "xx11xx","xx11xx"
  }

  diagonals =
  {
    "1.",".1"
    ".1","1."
    ".1","1."
  }
}

GROW_3x_Y_LIQUID =
{
  prob = 10
  skip_prob = 75

  structure =
  {
    "......","11~~11"
    "......","11~~11"
    "......","11%/11"
    "......","%1111/"
    "......","~%11/~"
    "......","~~11~~"
    "......","~~11~~"
    "......","~~11~~"
    "xx11xx","xx11xx"
  }

  diagonals =
  {
    ".~","~."
    "~.",".~"
    "~.",".~"
  }
}

-- Z (skipped because it would be the same as 'N'?)

-- MSSP's rooms shaped like English alphabet letters. [LETTERS]

GROW_DIAGONAL_STALK =
{
  prob = 75
  skip_prob = 50

  structure =
  {
    "xxx.....","xxx11111"
    "xxx.....","xxx1111/"
    "xx.....x","xx/111/x"
    "x.....xx","x/111/xx"
    ".....xxx","/1111xxx"
    "11111xxx","11111xxx"
  }

  diagonals =
  {
    "1."
    ".1","1."
    ".1","1."
    ".1"
  }
}


GROW_DIAGONAL_STALK_LIQUID =
{
  prob = 50
  skip_prob = 50

  structure =
  {
    "xxx.....","xxx11111"
    "xx......","xx/1111/"
    "x.......","x//111//"
    ".......x","//111//x"
    "......xx","/1111/xx"
    "11111xxx","11111xxx"
  }

  diagonals =
  {
         ".~","1~"
    ".~","~1","1~","~."
    ".~","~1","1~","~."
         "~1","~."
  }
}


GROW_O =
{
  prob = 40
  skip_prob = 75

  structure =
  {
    "x......x","x/1111%x"
    "........","/111111%"
    "........","11111111"
    "...xx...","111xx111"
    "...xx...","111xx111"
    "........","11111111"
    "........","%111111/"
    "x......x","x%1111/x"
    "xxx11xxx","xxx11xxx"
  }

  diagonals =
  {
    ".1","1."
    ".1","1."
    ".1","1."
    ".1","1."
  }
}

GROW_O_STAIR =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "x......x","x/AAAA%x"
    "........","/AAAAAA%"
    "........","AAAAAAAA"
    "...xx...","AAAxxAAA"
    "...xx...","^^^xx^^^"
    "........","11111111"
    "........","%111111/"
    "x......x","x%1111/x"
    "xxx11xxx","xxx11xxx"
  }

  diagonals =
  {
    ".A","A."
    ".A","A."
    ".1","1."
    ".1","1."
  }
}

GROW_HALF_C =
{
  prob = 75
  skip_prob = 25

  structure =
  {
    "x.......x","x/111111x"
    "........1","/11111111"
    "........1","111111111"
    "........x","11111111x"
    ".....xxxx","1111/xxxx"
    "....xxxxx","1111xxxxx"
  }

  diagonals =
  {
    ".1"
    ".1"
    "1."
  }
}

GROW_HALF_C_STAIR =
{
  prob = 50
  skip_prob = 25

  structure =
  {
    "x.......x","x/111111x"
    "........1","/11111111"
    "........1","111111111"
    "........x","11111111x"
    ".....xxxx","1111/xxxx"
    "....xxxxx","vvvvxxxxx"
    "....xxxxx","AAAAxxxxx"
    "....xxxxx","AAAAxxxxx"
  }

  diagonals =
  {
    ".1"
    ".1"
    "1."
  }
}

GROW_L =
{
  prob = 75
  skip_prob = 25

  structure =
  {
    "x11xxxxx","x11xxxxx"
    "....xxxx","1111xxxx"
    "....xxxx","1111xxxx"
    "....xxxx","1111xxxx"
    "....xxxx","1111xxxx"
    "........","11111111"
    "........","11111111"
    "........","11111111"
    "........","11111111"
  }
}

GROW_L_STAIR =
{
  prob = 35
  skip_prob = 50

  structure =
  {
    "x11xxxxx","x11xxxxx"
    "....xxxx","1111xxxx"
    "....xxxx","1111xxxx"
    "....xxxx","1111xxxx"
    "....xxxx","1111xxxx"
    "........","1111>>AA"
    "........","1111>>AA"
    "........","1111>>AA"
    "........","1111>>AA"
  }
}

GROW_L_STAIR_ALT =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "x11xxxxx","x11xxxxx"
    "....xxxx","1111xxxx"
    "....xxxx","1111xxxx"
    "....xxxx","vvvvxxxx"
    "....xxxx","vvvvxxxx"
    "........","AAAA<<11"
    "........","AAAA<<11"
    "........","AAAA<<11"
    "........","AAAA<<11"
  }
}

GROW_T_STAIR =
{
  prob = 20
  skip_prob = 75

  structure =
  {
    "xxxxx11xxxxx","xxxxx11xxxxx"
    "xxxx....xxxx","xxxx1111xxxx"
    "xxxx....xxxx","xxxx1111xxxx"
    "xxxx....xxxx","xxxxvvvvxxxx"
    "xxxx....xxxx","xxxxvvvvxxxx"
    "............","11>>AAAA<<11"
    "............","11>>AAAA<<11"
    "............","11>>AAAA<<11"
    "............","11>>AAAA<<11"
  }
}

-- Elevated letters.

GROW_ELEVATED_T_STALK_ENTRY =
{
  prob = 15
  skip_prob = 20

  aversion = 5

  structure =
  {
    "1........","11111AAAA"
    "1........","11111AAAA"
    "x........","x11>AAAAA"
    "x........","x11>AAAAA"
    "x........","x11>AAAAA"
    "x........","x11>AAAAA"
    "x........","x1111AAAA"
    "x........","x1111AAAA"
  }
}

GROW_ELEVATED_O_QUARTER =
{
  prob = 15
  skip_prob = 20

  aversion = 5

  structure =
  {
    "x11xx","x11xx"
    ".....","11111"
    ".....","11111"
    ".....","11/AA"
    ".....","11AAA"
    ".....","11AAA"
    ".....","11>AA"
    ".....","11>AA"
  }

  diagonals =
  {
    "1A"
  }
}

-- MSSP's huge-arse rooms. [HUGE]

GROW_EXTRUSION_CORNER_4x4 =
{
  prob = 40
  skip_prob = 10

  structure =
  {
    "x....","x1111"
    "x....","x1111"
    "1....","11111"
    "1....","11111"
    "x11xx","x11xx"
  }
}

GROW_EXTRUSION_CORNER_4x4_NEW_AREA =
{
  prob = 40
  skip_prob = 10

  structure =
  {
    "x....","xAAAA"
    "x....","xAAAA"
    "1....","1AAAA"
    "1....","1AAAA"
    "x11xx","x11xx"
  }
}

GROW_EXTRUSION_4X6 =
{
  prob = 50
  skip_prob = 10

  structure =
  {
    "x11x","x11x"
    "....","1111"
    "....","1111"
    "....","1111"
    "....","1111"
    "....","1111"
    "....","1111"
  }
}

GROW_EXTRUSION_4X4 =
{
  prob = 65
  skip_prob = 10

  structure =
  {
    "x11x","x11x"
    "....","1111"
    "....","1111"
    "....","1111"
    "....","1111"
  }
}

GROW_EXTRUSION_NEW_AREA_4x2 =
{
  prob = 80
  skip_prob = 10

  structure =
  {
    "1111","1111"
    "....","AAAA"
    "....","AAAA"
  }
}

GROW_EXTRUSION_STAIRCASE_4x2 =
{
  prob = 80
  skip_prob = 25

  structure =
  {
    "1111","1111"
    "....","AAvv"
    "....","AAvv"
    "....","AAAA"
    "....","AAAA"
  }
}

GROW_EXTRUSION_STAIRCASE_4x2_SIDEWAYS =
{
  prob = 80
  skip_prob = 25

  structure =
  {
    "1111","1111"
    "....","A<<1"
    "....","A<<1"
    "....","AAAA"
    "....","AAAA"
  }
}

GROW_EXTRUSION_STAIRCASE_4x2_SMALL =
{
  prob = 80
  skip_prob = 25

  structure =
  {
    "1111","1111"
    "....","AAAv"
    "....","AAAA"
    "....","AAAA"
    "....","AAAA"
  }
}

GROW_EXTRUSION_STAIRCASE_4x2_SMALL_SIDEWAYS =
{
  prob = 80
  skip_prob = 25

  structure =
  {
    "1111","1111"
    "....","AA<1"
    "....","AAAA"
    "....","AAAA"
    "....","AAAA"
  }
}

GROW_EXTRUSION_SINK =
{
  prob = 25
  skip_prob = 25

  aversion = 8

  structure =
  {
    "11.xx","111xx"
    "11.xx","111xx"
    ".....","11vAA"
    ".....","11AAA"
    ".....","11^AA"
    "...xx","111xx"
    "...xx","111xx"
  }
}

DECORATE_CAGE_CANALS_STRAIGHT_3X =
{
  prob = 8

  structure =
  {
    "...","CCC"
    "~~~","~~~"
    "111","111"
  }

  cage_mode = "fancy"
}

DECORATE_CAGE_CANALS_STRAIGHT_2X =
{
  prob = 8

  structure =
  {
    "..","CC"
    "~~","~~"
    "11","11"
  }

  cage_mode = "fancy"
}

DECORATE_CAGE_CANALSWIDE_STRAIGHT_3X =
{
  prob = 10

  structure =
  {
    "...","CCC"
    "~~~","~~~"
    "~~~","~~~"
    "111","111"
  }

  cage_mode = "fancy"
}

DECORATE_CAGE_CANALSWIDE_STRAIGHT_2X =
{
  prob = 5

  structure =
  {
    "..","CC"
    "~~","~~"
    "~~","~~"
    "11","11"
  }
}

DECORATE_CAGE_CANALSWIDE_STRAIGHT_3X =
{
  prob = 7

  structure =
  {
    "...","CCC"
    "~~~","~~~"
    "~~~","~~~"
    "111","111"
  }

  cage_mode = "fancy"
}

GROW_WIDE_SPACE_2X12 =
{
  prob = 2
  prob_skew = 1
  skip_prob = 40

  structure =
  {
    "1............","1111111111111"
    "1............","1111111111111"
  }
}

GROW_WIDE_SPACE_2X12_SIDEWAYS =
{
  prob = 2
  prob_skew = 1
  skip_prob = 40


  structure =
  {
    ".............","1111111111111"
    ".............","1111111111111"
    "11xxxxxxxxxxx","11xxxxxxxxxxx"
  }
}

GROW_WIDE_SPACE_2X8 =
{
  prob = 2
  prob_skew = 1
  skip_prob = 25

  structure =
  {
    "1........","111111111"
    "1........","111111111"
  }
}

GROW_WIDE_SPACE_2X8_SIDEWAYS =
{
  prob = 2
  prob_skew = 1
  skip_prob = 25

  structure =
  {
    ".........","111111111"
    ".........","111111111"
    "11xxxxxxx","11xxxxxxx"
  }
}

GROW_ROUNDED_CAP =
{
  prob = 20
  prob_skew = 10
  skip_prob = 15

  structure =
  {
    "1...","111%"
    "1...","1111"
    "1...","1111"
    "1...","111/"
  }

  diagonals =
  {
    "1."
    "1."
  }
}

GROW_BLADED_CAP =
{
  prob = 20
  prob_skew = 10
  skip_prob = 25

  structure =
  {
    "1..","111"
    "1..","111"
    "1..","11/"
    "1..","1/."
  }

  diagonals =
  {
    "1."
    "1."
  }
}

--MSSP's cliff extensions [CLIFF] [LEDGES]

GROW_INTO_CLIFF =
{
  prob = 20
  skip_prob = 25

  structure =
  {
    "....","11AA"
    "....","11AA"
    "....","11AA"
    "....","11AA"
    "....","11^^"
    "....","1111"
    "11xx","11xx"
  }
}


GROW_INTO_CLIFF_INVERSE =
{
  prob = 20
  skip_prob = 25

  structure =
  {
    "....","1111"
    "....","1111"
    "....","11vv"
    "....","11AA"
    "....","11AA"
    "....","11AA"
    "11xx","11xx"
  }
}

GROW_INTO_CLIFF_LONG =
{
  prob = 20
  skip_prob = 25

  structure =
  {
    "....","11AA"
    "....","11AA"
    "....","11AA"
    "....","11AA"
    "....","11AA"
    "....","11AA"
    "....","11AA"
    "....","11AA"
    "....","11^^"
    "....","1111"
    "11xx","11xx"
  }
}

GROW_INTO_CLIFF_LONG_INVERSE =
{
  prob = 20
  skip_prob = 25

  structure =
  {
    "....","1111"
    "....","1111"
    "....","11vv"
    "....","11AA"
    "....","11AA"
    "....","11AA"
    "....","11AA"
    "....","11AA"
    "....","11AA"
    "....","11AA"
    "11xx","11xx"
  }
}

GROW_INTO_CLIFF_CURVE =
{
  prob = 35
  skip_prob = 15

  structure =
  {
    "......","/11111"
    "......","111111"
    "......","11/AAA"
    "......","11AAAA"
    "......","11AAxx"
    "......","11AAxx"
    "......","11^^xx"
    "......","1111xx"
    "11xxxx","11xxxx"
  }

  diagonals =
  {
    ".1","1A"
  }
}

GROW_INTO_CLIFF_CURVE =
{
  prob = 35
  skip_prob = 15

  structure =
  {
    "......","AAAAA%"
    "......","AAAAAA"
    "......","111%AA"
    "......","1111AA"
    "......","1111^^"
    "......","111111"
    "xxxx11","xxxx11"
  }

  diagonals =
  {
    "A.","1A"
  }
}

-- x4

GROW_CLIFF_ENTRY_X4 =
{
  prob = 50
  skip_prob = 25

  structure =
  {
    "........","1111AAAA"
    "........","1111AAAA"
    "........","11111^^1"
    "11......","11111111"
    "11......","11111111"
  }
}

GROW_CLIFF_STRAIGHT_X4 =
{
  prob = 50
  skip_prob = 25

  structure =
  {
    "....","AAAA"
    "....","AAAA"
    "....","^^^^"
    "1111","1111"
  }
}

--[[GROW_CLIFF_ENTRY_X4_LONG =
{
  prob = 50
  skip_prob = 25

  structure =
  {
    "........","1111AAAA"
    "........","1111AAAA"
    "........","1111AAAA"
    "........","1111AAAA"
    "........","1111AAAA"
    "........","1111AAAA"
    "........","1111AAAA"
    "........","1111AAAA"
    "........","11111^^1"
    "11......","11111111"
    "11......","11111111"
  }
}

GROW_CLIFF_ENTRY_X4_CURVE =
{
  prob = 50
  skip_prob = 15

  structure =
  {
    "..........","/111111111"
    "..........","1111111111"
    "..........","1111111111"
    "..........","1111111111"
    "..........","1111/AAAAA"
    "..........","1111AAAAAA"
    "..........","1111AAAAAA"
    "..........","1111AAAAAA"
    "........xx","1111AAAAxx"
    "........xx","1111AAAAxx"
    "........xx","11111^^1xx"
    "11......xx","11111111xx"
    "11......xx","11111111xx"
  }

  diagonals =
  {
    ".1","1A"
  }
}

GROW_CLIFF_ENTRY_X4_CURVE_REVERSE =
{
  prob = 50
  skip_prob = 15

  structure =
  {
    "........","AAAAAAA%"
    "........","AAAAAAAA"
    "........","AAAAAAAA"
    "........","AAAAAAAA"
    "........","111%AAAA"
    "........","1111AAAA"
    "........","11111^^1"
    "......11","11111111"
    "......11","11111111"
  }

  diagonals =
  {
    "A.","1A"
  }
}]]

-- cliff-side/area-to-area cages

DECORATE_CLIFF_CAGE =
{
  prob = 8

  structure =
  {
    "x1x","x1x"
    "111","111"
    "111","1C1"
    "222","222"
  }

  cage_mode = "fancy"
}

DECORATE_CLIFF_CAGE_3X_ROW =
{
  prob = 8

  structure =
  {
    "x111x","x111x"
    "11111","11111"
    "11111","1CCC1"
    "22222","22222"
  }

  cage_mode = "fancy"
}

DECORATE_CLIFF_CAGE_3X_STAGGERED =
{
  prob = 3

  structure =
  {
    "x11111x","x11111x"
    "1111111","1111111"
    "1111111","1C1C1C1"
    "2222222","2222222"
  }

  cage_mode = "fancy"
}

-- MSSP's liquid placer [LIQUID-CLIFF]


GROW_LIQUID_POOL_PLACE_3x3 =
{
  prob = 15
  skip_prob = 25

  structure =
  {
    "x......","x111111"
    "1......","11/~%11"
    "1......","11~~~11"
    "x......","x1%~/11"
    "x......","x111111"
  }

  diagonals =
  {
    "1~","~1"
    "1~","~1"
  }
}

GROW_LIQUID_POOL_PLACE_3x6 =
{
  prob = 15
  skip_prob = 25

  structure =
  {
    "x........","x11111111"
    "1........","11/~~~%11"
    "1........","11~~~~~11"
    "x........","x1%~~~/11"
    "x........","x11111111"
  }

  diagonals =
  {
    "1~","~1"
    "1~","~1"
  }
}

GROW_LIQUID_POOL_PLACE =
{
  prob = 25
  skip_prob = 30

  group_pos = "entry"
  group = "liquid_pool"

  structure =
  {
    "....","1111"
    "....","1~~1"
    "....","1~~1"
    "....","1111"
    "x11x","x11x"
  }
}

GROW_LIQUID_POOL_EXTEND_STRAIGHT =
{
  prob = 25
  skip_prob = 30

  group = "liquid_pool"

  structure =
  {
    "1...","1111"
    "~...","~~~~"
    "~...","~~~~"
    "1...","1111"
  }
}

GROW_LIQUID_POOL_SWERVE =
{
  prob = 20
  skip_prob = 30

  group = "liquid_pool"

  structure =
  {
    "x....","x1~~1"
    ".....","/1~~1"
    ".....","1/~/1"
    ".....","1~~1/"
    "1~~1x","1~~1x"
  }

  diagonals =
  {
    ".1","1~"
    "~1","1."
  }
}

GROW_LIQUID_POOL_END =
{
  prob = 15
  skip_prob = 30

  group = "liquid_pool"

  structure =
  {
    "....","1111"
    "....","1111"
    "....","1~~1"
    "....","1~~1"
    "1~~1","1~~1"
  }
}

GROW_LIQUID_POOL_EXTEND_CURVED =
{
  prob = 15
  skip_prob = 30

  group = "liquid_pool"

  structure =
  {
    "1...","1111"
    "~...","~~%1"
    "~...","~~~1"
    "1...","1~~1"
  }

  diagonals =
  {
    "~1"
  }
}

GROW_LIQUID_PILLAR =
{
  prob = 25
  skip_prob = 50

  structure =
  {
    "....","11~~"
    "....","11~~"
    "....","11#~"
    "....","11~~"
    "11xx","11xx"
  }
}

GROW_LIQUID_PILLAR_INWARD =
{
  prob = 25
  skip_prob = 50

  structure =
  {
    "....","11~~"
    "....","11~~"
    "....","AA#~"
    "....","11~~"
    "11xx","11xx"
  }
}

GROW_LIQUID_PILLAR_INWARD =
{
  prob = 20
  skip_prob = 50

  structure =
  {
    "....","11~~"
    "....","11~~"
    "....","AA.~"
    "....","11~~"
    "....","AA.~"
    "....","11~~"
    "11xx","11xx"
  }
}

--[[DECORATE_LIQUID_MOAT_ROW =
{
  prob = 10
  skip_prob = 25

  group = "moat"

  structure =
  {
    "11111","11111"
    "22222","2~~~2"
    "22222","22222"
  }
}

DECORATE_LIQUID_MOAT_CORNER =
{
  prob = 15
  skip_prob = 25

  group_pos = "entry"
  group = "moat"

  structure =
  {
    "x122","x122"
    "x122","x1~2"
    "1/22","1/~2"
    "2222","2~/2"
    "2222","2222"
  }

  diagonals =
  {
    "12","1~"
         "~2"
  }
}

DECORATE_LIQUID_MOAT_EXTEND =
{
  prob = 10

  group = "moat"

  structure =
  {
    "111","111"
    "~22","~~2"
    "222","222"
  }
}

DECORATE_LIQUID_MOAT_EXTEND_FROM_CORNER =
{
  prob = 15

  group = "moat"

  structure =
  {
    "111","111"
    "~22","~~2"
    "/22","/22"
  }

  diagonals =
  {
    "~2","~2"
  }
}]]

-- MSSP's single-seed trenches. [TRENCHES]

GROW_TRENCH_STRAIGHT =
{
  prob = 50
  skip_prob = 40

  structure =
  {
    "1......","11111AA"
    "1......","11>>AAA"
    "1......","11111AA"
  }
}

GROW_TRENCH_STRAIGHT_LONG =
{
  prob = 30
  skip_prob = 40

  structure =
  {
    "1.........","11111111AA"
    "1.........","11>>AAAAAA"
    "1.........","11111111AA"
  }
}

GROW_TRENCH_CURVE =
{
  prob = 15
  skip_prob = 70

  aversion = 10

  structure =
  {
    "xxx...","xxxAAA"
    "xxx...","xxxAAA"
    "xx....","xx11A1"
    "1.....","111/A1"
    "1.....","1>AA/1"
    "1.....","111111"
  }

  diagonals =
  {
    "1A"
    "A1"
  }
}

GROW_TRENCH_CURVE_INNER_SOLID =
{
  prob = 15
  skip_prob = 70

  aversion = 6

  structure =
  {
    "xxxx..","xxxxAA"
    "xxxx..","xxxxAA"
    "xxxx..","xxxxA1"
    "xxx...","xxx/A1"
    "1.....","1>AA/1"
    "1.....","111111"
  }

  diagonals =
  {
    ".A"
    "A1"
  }
}

GROW_TRENCH_CURVE_OUTER_SOLID =
{
  prob = 15
  skip_prob = 70

  aversion = 6

  structure =
  {
    "xxx..","xxxAA"
    "xxx..","xxxAA"
    "xx...","xx11A"
    "1....","111/A"
    "1....","1>AA/"
  }

  diagonals =
  {
    "1A"
    "A."
  }
}

-- MSSP's sewers [SEWER]

GROW_SEWER_ENTRY =
{
  prob = 25
  skip_prob = 25

  group = "sewer"

  structure =
  {
    "......","111111"
    "......","111111"
    "......","~~~~~1"
    "1.....","111111"
    "1.....","111111"
  }
}

GROW_SEWER_STAIRS =
{
  prob = 30
  skip_prob = 25

  group = "sewer"

  structure =
  {
    "......","111>AA"
    "......","111>AA"
    "......","~~~~~A"
    "1.....","111>AA"
    "1.....","111>AA"
  }
}

GROW_SEWER_SWERVE =
{
  prob = 35
  skip_prob = 10

  group = "sewer"

  structure =
  {
    "1....x","1111%x"
    "1.....","111111"
    "......","~~~%11"
    "......","11%~~1"
    "......","111111"
    "x.....","x%1111"
  }

  diagonals =
  {
    "1."
    "~1"
    "1~"
    ".1"
  }
}

GROW_SEWER_CURVED =
{
  prob = 20
  skip_prob = 10

  group = "sewer"

  structure =
  {
    "1.....","11111%"
    "1.....","111111"
    "......","~~~%11"
    "......","11%~11"
    "......","111~11"
    "x.....","x11111"
  }

  diagonals =
  {
    "1."
    "~1"
    "1~"
  }
}

GROW_SEWER_CROSSING =
{
  prob = 25
  skip_prob = 75

  group = "sewer"

  structure =
  {
    ".....","11~11"
    ".....","11~11"
    ".....","~~~~~"
    "1....","11~11"
    "1....","11~11"
  }
}

GROW_SEWER_STAIRS_SIDE_EXIT_NEW_AREA =
{
  prob = 35
  skip_prob = 20

  structure =
  {
    "xxxx..x","xxxxAAx"
    "1......","11>>AA1"
    "1......","11>>AA1"
    ".......","1~~~~~1"
    ".......","1111111"
    ".......","1111111"
  }
}

-- FORGET IT LMAO IT DOESN'T WORK
-- It works now. Cheer up, buddy. -- March, 2019
-- MSSP's city streets. ExperiMENTAL. [STREETS]

STREETS_ENTRY_RSVOL_4 =
{
  prob = 5

  pass = "streets_entry_4"

  structure =
  {
    "....","1111"
    "11..","1111"
    "11..","1111"
    "....","1111"
  }
}

STREETS_ENTRY_RSVOL_6 =
{
  prob = 5

  pass = "streets_entry_6"

  structure =
  {
    "....","1111"
    "11..","1111"
    "11..","1111"
    "11..","1111"
    "....","1111"
  }
}

STREETS_ENTRY_RSVOL_8 =
{
  prob = 5

  pass = "streets_entry_8"

  structure =
  {
    "....","1111"
    "11..","1111"
    "11..","1111"
    "11..","1111"
    "11..","1111"
    "....","1111"
  }
}

STREETS_STRAIGHT =
{
  prob = 100

  pass = "streets"

  structure =
  {
    ".1111.",".1111."
    "......",".1111."
    "......",".1111."
    "......",".1111."
    "......",".1111."
    "......",".1111."
    "......",".1111."
    "......",".1111."
    "......",".1111."
  }
}

STREETS_STRAIGHT_LONG =
{
  prob = 50

  pass = "streets"

  structure =
  {
    ".1111.",".1111."
    "......",".1111."
    "......",".1111."
    "......",".1111."
    "......",".1111."
    "......",".1111."
    "......",".1111."
    "......",".1111."
    "......",".1111."
    "......",".1111."
    "......",".1111."
    "......",".1111."
    "......",".1111."
    "......",".1111."
    "......",".1111."
    "......",".1111."
    "......",".1111."
  }

}

STREETS_BLOCK =
{
  prob = 25

  pass = "streets"

  structure =
  {
    "..........................",".1111................1111."
    "1.........................","11111111111111111111111111"
    "1.........................","11111111111111111111111111"
    "1.........................","11111111111111111111111111"
    "1.........................","11111111111111111111111111"
    "..........................",".1111................1111."
    "..........................",".1111................1111."
    "..........................",".1111................1111."
    "..........................",".1111................1111."
    "..........................",".1111................1111."
    "..........................",".1111................1111."
    "..........................",".1111................1111."
    "..........................",".1111................1111."
    "..........................",".1111................1111."
    "..........................",".1111................1111."
    "..........................",".1111................1111."
    "..........................",".1111................1111."
    "..........................",".1111................1111."
    "..........................",".1111................1111."
    "..........................",".1111................1111."
    "..........................",".1111................1111."
    "..........................","11111111111111111111111111"
    "..........................","11111111111111111111111111"
    "..........................","11111111111111111111111111"
    "..........................","11111111111111111111111111"
    "..........................",".1111................1111."
  }
}

STREETS_INTERSECTION =
{
  prob = 15

  pass = "streets"

  structure =
  {
    ".1111.",".1111."
    "......","111111"
    "......","111111"
    "......","111111"
    "......","111111"
    "......",".1111."
  }
}

STREETS_T_JUNCTION =
{
  prob = 25

  pass = "streets"

  structure =
  {
    ".1111.",".1111."
    "......","111111"
    "......","111111"
    "......","111111"
    "......","111111"
  }
}

STREETS_CURVE =
{
  prob = 15

  pass = "streets"

  structure =
  {
    ".1111..",".1111.."
    ".......",".1111%."
    ".......",".111111"
    ".......",".111111"
    ".......",".111111"
    ".......",".%11111"
  }

  diagonals =
  {
    "1."
    ".1"
  }
}

-- MSSP's sidewalks

SIDEWALK_STRAIGHT =
{
  prob = 100

  pass = "sidewalk"

  structure =
  {
    "....","AAAA"
    "....","AAAA"
    "1111","1111"
  }
}

SIDEWALK_STRAIGHT_INWARD =
{
  prob = 35

  pass = "sidewalk"

  structure =
  {
    "1........","1AAAAAAAA"
    "1........","1AAAAAAAA"
  }
}

SIDEWALK_4X4 =
{
  prob = 25

  pass = "sidewalk"

  structure =
  {
    "11..","11AA"
    "11..","11AA"
    "....","AAAA"
    "....","AAAA"
  }
}

SIDEWALK_STRAIGHT_INWARD_ANGLED =
{
  prob = 25

  pass = "sidewalk"

  structure =
  {
    "1......","1AAAAAA"
    "1......","1AAAAAA"
    "1xxxx..","1xxxxAA"
    "1xxxx..","1xxxxAA"
    "1xxxx..","1xxxxAA"
    "1xxxx..","1xxxxAA"
  }
}

SIDEWALK_STRAIGHT_LARGE =
{
  prob = 50

  pass = "sidewalk"

  structure =
  {
    "........","AAAAAAAA"
    "........","AAAAAAAA"
    "11111111","11111111"
  }
}

SIDEWALK_STRAIGHT_LARGE_CHAMFERED =
{
  prob = 15

  pass = "sidewalk"

  structure =
  {
    "........","/AAAAAA%"
    "........","AAAAAAAA"
    "11111111","11111111"
  }

  diagonals =
  {
    ".A","A."
  }
}

SIDEWALK_INTERSECTION_SIDE =
{
  prob = 100

  pass = "sidewalk"

  structure =
  {
    "1....","1AAA%"
    "1....","1AAAA"
    "1....","1AAAA"
    "1%...","1%AAA"
    "11111","11111"
  }

  diagonals =
  {
    "A."
    "1.","1A"
  }
}

SIDEWALK_OUTER_CORNER =
{
  prob = 100

  pass = "sidewalk"

  structure =
  {
    "xx....","xxAAAA"
    "xx....","xxAAAA"
    "x11%..","x11%AA"
    "1111xx","1111xx"
    "111xxx","111xxx"
  }

  diagonals =
  {
    "1.","1A"
  }
}

SIDEWALK_EXTEND_SIDEWAYS =
{
  prob = 250

  pass = "sidewalk"

  structure =
  {
    "2..","222"
    "2..","222"
    "111","111"
    "111","111"
  }
}

SIDEWALK_FILL_2X =
{
  prob = 25

  pass = "sidewalk"

  structure =
  {
    "2..2","2222"
    "2..2","2222"
    "x11x","x11x"
    "1111","1111"
  }
}

SIDEWALK_SLOPE_SIDE_SMOL =
{
  prob = 15
  skip_prob = 40

  pass = "sidewalk"

  structure =
  {
    "11..","11AA"
    "11..","11AA"
    "11..","11AA"
    "11..","11>A"
  }
}

SIDEWALK_SLOPE_SIDE_NEAR =
{
  prob = 15
  skip_prob = 40

  pass = "sidewalk"

  structure =
  {
    "11....","11AAAA"
    "11....","11>>AA"
    "11....","11>>AA"
    "11....","11AAAA"
  }
}

SIDEWALK_SLOPE_SIDE_FAR =
{
  prob = 10
  skip_prob = 40

  pass = "sidewalk"

  structure =
  {
    "11xx..","11xxAA"
    "11....","11>>AA"
    "11....","11>>AA"
    "11xx..","11xxAA"
  }
}

SIDEWALK_SLOPE_ON_RAMP =
{
  prob = 10

  pass = "sidewalk"

  structure =
  {
    "11x..","11xAA"
    "11...","11>AA"
    "11...","11>AA"
    "11...","11>AA"
    "11...","11>AA"
    "11x..","11xAA"
  }
}

SIDEWALK_SLOPE_ON_RAMP_DOUBLE =
{
  prob = 10

  pass = "sidewalk"

  structure =
  {
    "11x..","11xAA"
    "11...","11>AA"
    "11...","11>AA"
    "111..","111AA"
    "111..","111AA"
    "11...","11>AA"
    "11...","11>AA"
    "11x..","11xAA"
  }
}

SIDEWALK_PLAIN_STAIR =
{
  prob = 10

  pass = "sidewalk"

  structure =
  {
    "..","AA"
    "..","AA"
    "..","^^"
    "11","11"
    "11","11"
  }
}

SIDEWALK_STAIR_Y_IN =
{
  prob = 10

  pass = "sidewalk"

  structure =
  {
    ".....","..AAA"
    ".....","1>AAA"
    ".....","11%AA"
    "11...","111^."
    "11...","1111."
  }

  diagonals =
  {
    "1A"
  }
}

SIDEWALK_STAIR_Y_OUT =
{
  prob = 15

  pass = "sidewalk"

  structure =
  {
    "......","AAAAAA"
    "......","AAAAAA"
    "......","11>>AA"
    "......","1111AA"
    "11....","1111AA"
    "11....","1111AA"
  }
}

SIDEWALK_BUILDING_4x4 =
{
  prob = 15

  pass = "sidewalk"

  structure =
  {
    "11......","11AAAAAA"
    "11......","11AAAAAA"
    "........","AA....AA"
    "........","AA....AA"
    "........","AA....AA"
    "........","AA....AA"
    "........","AAAAAAAA"
    "........","AAAAAAAA"
  }
}

SIDEWALK_BUILDING_L =
{
  prob = 15

  pass = "sidewalk"

  structure =
  {
    "11........","11AAAAAAAA"
    "11........","11AAAAAAAA"
    "..........","AAAA....AA"
    "..........","AAAA....AA"
    "..........","AA......AA"
    "..........","AA......AA"
    "..........","AA......AA"
    "..........","AA......AA"
    "..........","AAAAAAAAAA"
    "..........","AAAAAAAAAA"
  }
}

SIDEWALK_OVERHANG =
{
  prob = 20

  pass = "sidewalk"

  structure =
  {
    "11....","11AAAA"
    "11....","11AAAA"
    "xx....","xx#AA#"
  }
}

SIDEWALK_OVERHANG_CORNER =
{
  prob = 20

  pass = "sidewalk"

  structure =
  {
    "xx...","xxAAA"
    "11...","11AAA"
    "11...","11#AA"
  }
}

SIDEWALK_CURVE =
{
  prob = 20

  pass = "sidewalk"

  structure =
  {
    "1...x","1AA%x"
    "1....","1AAA%"
    "xx...","xx%AA"
    "xxx..","xxxAA"
  }

  diagonals =
  {
    "A."
      "A."
    ".A"
  }
}

SIDEWALK_ZIGZAG =
{
  prob = 20

  pass = "sidewalk"

  structure =
  {
    "1...xx","1AA%xx"
    "1....x","1AAA%x"
    "xx....","xx%AAA"
    "xxx...","xxx%AA"
  }

  diagonals =
  {
    "A."
      "A."
    ".A"
      ".A"
  }
}

SIDEWALK_LIQUID =
{
  prob = 50

  pass = "sidewalk"

  structure =
  {
    "........","AA~~~~AA"
    "11111111","11111111"
  }
}

SIDEWALK_LIQUID_POOL_LONG =
{
  prob = 50

  pass = "sidewalk"

  structure =
  {
    "......","AA~~~~"
    "......","AA~~~~"
    "11xxxx","11xxxx"
  }
}

SIDEWALK_LIQUID_POOL =
{
  prob = 50

  pass = "sidewalk"

  structure =
  {
    "....","AA~~"
    "....","AA~~"
    "11xx","11xx"
  }
}

SIDEWALK_CAGE =
{
  prob = 50

  pass = "sidewalk"

  structure =
  {
    "x..","xCC"
    "1..","1AA"
    "1..","1AA"
  }

  cage_mode = "fancy"
}

SIDEWALK_CAGE_4X =
{
  prob = 40

  pass = "sidewalk"

  structure =
  {
    "x....","xCCCC"
    "1....","1AAAA"
    "1....","1AAAA"
  }

  cage_mode = "fancy"
}

SIDEWALK_CAGE_4X4 =
{
  prob = 35

  pass = "sidewalk"

  structure =
  {
    "x..","xCC"
    "x..","xCC"
    "1..","1AA"
    "1..","1AA"
  }

  cage_mode = "fancy"
}

SIDEWALK_CLOSET_2X2 =
{
  prob = 100

  pass = "sidewalk"

  structure =
  {
    "1!!","1TT"
    "1!!","1TT"
  }

  closet = { from_dir=4 }
}

SIDEWALK_CLOSET_2X1 =
{
  prob = 100

  pass = "sidewalk"

  structure =
  {
    "1!","1T"
    "1!","1T"
  }

  closet = { from_dir=4 }
}

SIDEWALK_CLOSET_3X1 =
{
  prob = 100

  pass = "sidewalk"

  structure =
  {
    "1!","1T"
    "1!","1T"
    "1!","1T"
  }

  closet = { from_dir=4 }
}

SIDEWALK_CLOSET_3X2 =
{
  prob = 100

  pass = "sidewalk"

  structure =
  {
    "1!!","1TT"
    "1!!","1TT"
    "1!!","1TT"
  }

  closet = { from_dir=4 }
}

SIDEWALK_CLOSET_4X1 =
{
  prob = 25

  pass = "sidewalk"

  structure =
  {
    "1!","1T"
    "1!","1T"
    "1!","1T"
    "1!","1T"
  }

  closet = { from_dir=4 }
}

SIDEWALK_CLOSET_6X1 =
{
  prob = 25

  pass = "sidewalk"

  structure =
  {
    "1!","1T"
    "1!","1T"
    "1!","1T"
    "1!","1T"
    "1!","1T"
    "1!","1T"
  }

  closet = { from_dir=4 }
}

SIDEWALK_CLOSET_8X1 =
{
  prob = 25

  pass = "sidewalk"

  structure =
  {
    "1!","1T"
    "1!","1T"
    "1!","1T"
    "1!","1T"
    "1!","1T"
    "1!","1T"
    "1!","1T"
    "1!","1T"
  }

  closet = { from_dir=4 }
}
-- MSSP's street 'smoothers'

STREET_CORNER_FIXER =
{
  prob = 100

  pass = "street_fixer"

  structure =
  {
    "x1111xx","x1111xx"
    "111111.","11111.."
    "111111.","11111.."
    "111111.","11111.."
    "111111.","1111/.."
    "x1111..","x......"
    "x......","x......"
  }

  diagonals =
  {
    "1."
  }
}

STREET_T_JUNCTION_FIXER =
{
  prob = 100

  pass = "street_fixer"

  structure =
  {
    "11111.","11111."
    "11111!","1111/!"
    "!1111!","!....!"
    "!!!!!!","!!!!!!"
  }

  diagonals =
  {
    "1."
  }
}

STREET_WEIRD_DEAD_BRANCH_FIXER =
{
  prob = 100

  pass = "street_fixer"

  structure =
  {
    "111111","111111"
    ".1111.","......"
    "......","......"
  }
}

STREET_DEAD_END_FIXER =
{
  prob = 100

  pass = "street_fixer"

  structure =
  {
    ".1111.",".1111."
    ".1111.",".%11/."
    "!!!!!!","!!!!!!"
  }

  diagonals =
  {
    ".1","1."
  }
}

-- MSSP's building entrances... okay, just joiners and some such really

STREET_BUILDING_ENTRANCE =
{
  prob = 300

  pass = "building_entrance"

  structure =
  {
    "..","RR"
    "..","RR"
    "11","11"
  }

  new_room =
  {
    env = "building"

    conn = { x=1, y=1, w=2, dir=8 }

    symmetry = { x=2, y=1, w=2, dir=8 }
  }
}

STREET_BUILDING_ENTRANCE_WITH_JOINER_2X1 =
{
  prob = 100

  pass = "building_entrance"

  structure =
  {
    "....",".RR."
    "....",".RR."
    "x..x","xJJx"
    "x11x","x11x"
  }

  new_room =
  {
    symmetry = { x=3, y=2, w=2, dir=8 }
  }

  joiner =
  {
    from_dir = 2
  }
}

STREET_BUILDING_ENTRANCE_WITH_JOINER_2X2 =
{
  prob = 100

  pass = "building_entrance"

  structure =
  {
    "....",".RR."
    "....",".RR."
    "x..x","xJJx"
    "x..x","xJJx"
    "x11x","x11x"
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

STREET_BUILDING_ENTRANCE_WITH_JOINER_3X2 =
{
  prob = 100

  pass = "building_entrance"

  structure =
  {
    ".....",".RRR."
    ".....",".RRR."
    "x...x","xJJJx"
    "x...x","xJJJx"
    "x111x","x111x"
  }

  new_room =
  {
    symmetry = { x=3, y=3, w=2, dir=8 }
  }

  joiner =
  {
    from_dir = 2
  }
}

-- end of SHAPE_GRAMMAR

}
