------------------------------------------------------------------------
--  GRAMMAR TILES
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
    "X11X", "X11X"
  }
}


GROW_DIAGTEST_1 =
{
  prob = 50

  structure =
  {
    "X.", "X."
    "1.", "11"
    "1.", "1/"
    "X.", "X."
  }

  diagonals = { "1." }
}


GROW_DIAGTEST_2 =
{
  prob = 400

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


GROW_MIR_TEST =
{
  prob = 50

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
  prob = 150

  structure =
  {
    "....", ".AA."
    "X11X", "X11X"
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
    "X11X", "X11X"
    "X11X", "X11X"
  }

  new_room =
  {
    conn = { x=2, y=3, w=2, dir=2 }

    symmetry = { x=2, y=3, w=2, dir=8 }
  }
}


SPROUT_SYMMETRY_TEST =
{
  prob = 30

  structure =
  {
    ".....", ".RRR."
    ".....", ".RRR."
    "X111X", "X111X"
  }

  new_room =
  {
    conn = { x=2, y=3, w=3, dir=2 }

    symmetry = { x=3, y=3, dir=2 }
  }
}


SPROUT_DIAG_1 =
{
  prob = 100

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
  prob = 100

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
    "XX....", "XX..1."
    "XX....", "XX.RRR"
    "XX....", "XX.RRR"
  }

  new_room =
  {
    conn = { x=5, y=2, dir=8 }

    symmetry = { x=5, y=2, dir=8 }
  }
}


------------------------------------------


DECORATE_CLOSET_1 =
{
  prob = 0

  structure =
  {
    "....", ".CC."
    "X11X", "X11X"
  }
}


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



------------------------------------------------------------------------


OLD__TILES =
{
 
--------------------------------
--
--  Hallways
--
--------------------------------

HALL_I_1x1 =
{
  prob = 5

  structure =
  {
    "1"
  }

  conns =
  {
    a = { x=1, y=1, dir=2 }
    b = { x=1, y=1, dir=8 }
  }
}


HALL_1x2 =
{
  prob = 30

  structure =
  {
    "1"
    "1"
  }

  conns =
  {
    a = { x=1, y=1, dir=2 }
    b = { x=1, y=2, dir=8 }
  }
}


HALL_1x3 =
{
  prob = 10

  structure =
  {
    "1"
    "1"
    "1"
  }

  conns =
  {
    a = { x=1, y=1, dir=2 }
    b = { x=1, y=3, dir=8 }
  }
}


HALL_2x1 =
{
  prob = 50

  structure =
  {
    "11"
  }

  conns =
  {
    a = { x=2, y=1, w=2, dir=2 }
    b = { x=1, y=1, w=2, dir=8 }
  }
}


HALL_3x1 =
{
  prob = 1

  structure =
  {
    "111"
  }

  conns =
  {
    a = { x=3, y=1, w=3, dir=2 }
    b = { x=1, y=1, w=3, dir=8 }
  }
}


HALL_3x1_split =
{
  prob = 320

  -- NOTE : non-contiguous areas are normally not allowed, this is a special case
  structure =
  {
    "1.1"
  }

  symmetry = "x"

  conns =
  {
    a = { x=3, y=1, w=3, dir=2, split=1 }
    b = { x=1, y=1, w=3, dir=8, split=1 }
  }
}


HALL_2x2 =
{
  prob = 100

  structure =
  {
    "11"
    "11"
  }

  conns =
  {
    a = { x=2, y=1, w=2, dir=2 }
    b = { x=1, y=2, w=2, dir=8 }
    c = { x=1, y=1, w=2, dir=4 }

    e = { x=1, y=1, dir=2 }
    f = { x=2, y=2, dir=6 }
  }

  conn_sets =
  {
    "a:b"
    "a:c"
  }

  stairwells =
  {
    "e:f"
  }
}


HALL_DIAG_1 =
{
  prob = 200

  structure =
  {
    "/%"
    "%/"
  }

  diagonals =
  {
    ".1", "1."
    ".1", "1."
  }

  conns =
  {
    a = { x=1, y=1, dir=1 }
    b = { x=2, y=1, dir=3 }
    c = { x=1, y=2, dir=7 }
    d = { x=2, y=2, dir=9 }
  }

  conn_sets =
  {
    "a:b"
    "a:c"
    "a:d"
    "a:bc"
  }
}


HALL_DIAG_2 =
{
  prob = 100

  structure =
  {
    "./%"
    "/1/"
    "%/."
  }

  diagonals =
  {
    ".1", "1."
    ".1", "1."
    ".1", "1."
  }

  conns =
  {
    a = { x=1, y=1, dir=1 }
    b = { x=3, y=3, dir=9 }
  }
}


HALL_DIAG_STRAIGHT =
{
  prob = 200

  structure =
  {
    ".1"
    "/1"
    "%/"
  }

  diagonals =
  {
    ".1",
    ".1", "1."
  }

  conns =
  {
    a = { x=1, y=1, dir=1 }
    b = { x=2, y=3, dir=8 }
  }
}


HALL_DIAG_Y_4x4 =
{
  prob = 100

  structure =
  {
    ".1.."
    ".1.."
    "/111"
    "%/.."
  }

  diagonals =
  {
    ".1",
    ".1", "1."
  }

  conns =
  {
    a = { x=1, y=1, dir=1 }
    b = { x=2, y=4, dir=8 }
    c = { x=4, y=2, dir=6 }
  }

  conn_sets =
  {
    "abc"
  }
}


HALL_T_3x3 =
{
  prob = 300

  structure =
  {
    "111"
    ".1."
    ".1."
  }

  conns =
  {
    a = { x=2, y=1, dir=2 }
    b = { x=1, y=3, dir=4 }
    c = { x=3, y=3, dir=6 }
  }
}


HALL_T_5x2 =
{
  prob = 300

  structure =
  {
    "11111"
    "..1.."
  }

  conns =
  {
    a = { x=3, y=1, dir=2 }
    b = { x=1, y=2, dir=4 }
    c = { x=5, y=2, dir=6 }
    d = { x=1, y=2, dir=8 }
    e = { x=5, y=2, dir=8 }
  }

  conn_sets =
  {
    "abc"
    "ade"
  }
}


HALL_U_5x3_a =
{
  prob = 300

  structure =
  {
    "./1%."
    "//.%%"
    "1...1"
  }

  diagonals =
  {
    ".1", "1."
    ".1", "1.", ".1", "1."
  }

  conns =
  {
    a = { x=1, y=1, dir=2 }
    b = { x=5, y=1, dir=2 }
    c = { x=3, y=3, dir=8 }
  }

  conn_sets =
  {
--  "a:b"
    "a:bc"
  }
}


HALL_P_5x3 =
{
  prob = 300

  structure =
  {
    "..1.."
    "11111"
    "..1.."
  }

  conns =
  {
    a = { x=3, y=1, dir=2 }
    b = { x=3, y=3, dir=8 }
    c = { x=1, y=2, dir=4 }
    d = { x=5, y=2, dir=6 }
  }
}


HALL_ODD_5x4 =
{
  prob = 300

  structure =
  {
    "..1.."
    "..111"
    "111.."
    "..1.."
  }

  conns =
  {
    a = { x=3, y=1, dir=2 }
    b = { x=3, y=4, dir=8 }
    c = { x=1, y=2, dir=4 }
    d = { x=5, y=3, dir=6 }
  }
}


--------------------------------
--
--  Generic Caves
--
--------------------------------

CAVE_5x5 =
{
  prob = 100
  start_prob = 100

  structure =
  {
    "11111"
    "11111"
    "11111"
    "11111"
    "11111"
  }

  conns =
  {
    a = { x=3, y=1, dir=2 }
    b = { x=1, y=4, dir=4 }
    c = { x=4, y=5, dir=8 }
    d = { x=5, y=3, dir=6 }
  }
}


CAVE_9x5 =
{
  prob = 100

  structure =
  {
    "111111111"
    "111111111"
    "111111111"
    "111111111"
    "111111111"
  }

  conns =
  {
    a = { x=5, y=1, dir=2 }
    b = { x=1, y=2, dir=4 }
    c = { x=9, y=4, dir=6 }
    d = { x=3, y=5, dir=8 }
    e = { x=7, y=5, dir=8 }
  }
}


CAVE_L_9x9 =
{
  prob = 300
  start_prob = 200

  structure =
  {
    "111111111"
    "111111111"
    "111111111"
    "111111111"
    "111111111"
    "11111...."
    "11111...."
    "11111...."
    "11111...."
  }

  conns =
  {
    a = { x=3, y=1, dir=2 }
    b = { x=1, y=7, dir=4 }
    c = { x=7, y=9, dir=8 }
    d = { x=9, y=7, dir=6 }

    f = { x=1, y=3, dir=4 }
    g = { x=3, y=9, dir=8 }
  }

  conn_sets =
  {
    "abcdfg"
    "a:bd"
    "a:cd"
    "a:bcd"
  }
}


CAVE_9x9 =
{
  prob = 200
  start_prob = 100

  structure =
  {
    "111111111"
    "111111111"
    "111111111"
    "111111111"
    "111111111"
    "111111111"
    "111111111"
    "111111111"
    "111111111"
  }

  conns =
  {
    a = { x=3, y=1, dir=2 }
    b = { x=1, y=7, dir=4 }
    c = { x=7, y=9, dir=8 }
    d = { x=9, y=3, dir=6 }

    e = { x=7, y=1, dir=2 }
    f = { x=1, y=3, dir=4 }
    g = { x=3, y=9, dir=8 }
    h = { x=9, y=7, dir=6 }
  }

  conn_sets =
  {
    "a:bcd"
    "a:cgd"
    "a:cgh"
    "a:bdh"
  }
}


--------------------------------
--
--  Indoor Rooms
--
--------------------------------

ROOM_RECT_3x2 =
{
  prob = 40

  structure =
  {
    "111"
    "111"
  }

  conns =
  {
    a = { x=2, y=1, dir=2 }
    b = { x=1, y=2, dir=8 }
    c = { x=3, y=2, dir=8 }
    d = { x=1, y=2, dir=4 }
    e = { x=3, y=2, dir=6 }
    f = { x=2, y=2, dir=8 }

    -- FIXME : test crud
    g = { x=2, y=1, w=2, dir=2 }
    h = { x=2, y=2, w=2, dir=8 }
    k = { x=1, y=1, w=2, dir=4 }
    m = { x=3, y=2, w=2, dir=6 }
  }

  conn_sets =
  {
    "a:bc"
    "a:bcf"
    "a:de"
    "a:def"

    "g:h"
    "g:km"
    "g:hkm"
  }
}


ROOM_4x3_A =
{
  prob = 200

  structure =
  {
    "1221"
    "1221"
    "1111"
  }

  conns =
  {
    a = { x=1, y=1, dir=4 }
    b = { x=1, y=3, dir=4 }
    c = { x=3, y=1, dir=6 }
    d = { x=3, y=3, dir=6 }

    m = { x=1, y=2, dir=4 }
    n = { x=3, y=2, dir=6 }

    e = { x=3, y=1, w=2, dir=2 }
    f = { x=2, y=3, w=2, dir=8 }
    g = { x=1, y=2, w=2, dir=4 }
    h = { x=4, y=3, w=2, dir=6 }
  }

  conn_sets =
  {
    "bd"

    "e:f"
    "e:bd"
    "e:mnf"

    "f:ac"
    "f:mn"
  }
}


ROOM_U2_5x3 =
{
  prob = 320

  structure =
  {
    "12.21"
    "12221"
    "11111"
  }

  conns =
  {
    a = { x=3, y=1, dir=2 }
    b = { x=1, y=2, dir=4 }
    c = { x=5, y=2, dir=6 }
    d = { x=2, y=3, dir=8 }
    e = { x=4, y=3, dir=8 }
    z = { x=3, y=2, dir=8 }

    f = { x=2, y=3, w=3, dir=8, split=1 }
    g = { x=1, y=3, w=5, dir=8, split=1 }
    h = { x=4, y=1, w=3, dir=2, split=1 }

  }

  conn_sets =
  {
    "a:bc"
    "a:bcz"
    "a:de"

    "af"
    "afbc"
    "ag"
    "ah"

    "f:bc"
  }
}


ROOM_L_AA =
{
  prob = 120

  structure =
  {
    "11111"
    "12222"
    "12..."
    "12..."
  }

  conns =
  {
    a = { x=1, y=1, dir=2 }
    b = { x=2, y=1, dir=2 }

    c = { x=5, y=4, dir=6 }
    d = { x=5, y=3, dir=6 }

    e = { x=3, y=4, dir=8 }
    f = { x=1, y=2, w=2, dir=4 }
  }

  conn_sets =
  {
    "a:c"
    "a:d"
    "a:de"

    "b:c"
    "b:d"
    "b:de"

    "f:ed"
    "f:edb"
    "d:ef"
    "d:bef"
  }
}


ROOM_L_6x6 =
{
  prob = 60
  start_prob = 60

  structure =
  {
    "%22222"
    "1%2222"
    "11%222"
    "111..."
    "111..."
    "111..."
  }

  diagonals =
  {
    "12"
    "12"
    "12"
  }

  conns =
  {
    a = { x=2, y=1, dir=2 }
    b = { x=6, y=5, dir=6 }

    c = { x=3, y=1, w=3, dir=2, split=1 }  -- FIXME
    d = { x=6, y=6, w=3, dir=6, split=1 }

    e = { x=3, y=6, w=2, dir=8 }
    f = { x=1, y=3, w=2, dir=4 }
  }

  conn_sets =
  {
--!!!    "a:b"
    "a:d"
--!!!    "a:de"

--!!!    "b:c"
--!!!    "b:d"
--!!!    "b:de"

    "c:d"

    "e:c"
  }
}


ROOM_U_6x4 =
{
  prob = 110

  structure =
  {
    "11..11"
    "11..11"
    "111111"
    "%1111/"
  }

  diagonals =
  {
    ".1", "1."
  }

  conns =
  {
    a = { x=4, y=1, w=2, dir=4 }
    b = { x=3, y=2, w=2, dir=8 }
    c = { x=1, y=3, w=2, dir=4 }
    d = { x=6, y=4, w=2, dir=6 }

    e = { x=1, y=4, dir=4 }
    f = { x=6, y=4, dir=6 }

    g = { x=1, y=4, w=2, dir=8 }
    h = { x=5, y=4, w=2, dir=8 }
  }

  conn_sets =
  {
    "acd"
    "agh"
    "aef"

    "bcd"
    "bgh"
    "bef"
  }
}


--------------------------------
--
--  Party Starters
--
--------------------------------

START_O_3x3 =
{
  prob = 20
  start_prob = 100

  structure =
  {
    "/1%"
    "111"
    "%1/"
  }

  diagonals =
  {
    ".1", "1."
    ".1", "1."
  }

  conns =
  {
    a = { x=2, y=1, dir=2 }
    b = { x=1, y=2, dir=4 }
    c = { x=3, y=2, dir=6 }
    d = { x=2, y=3, dir=8 }

    e = { x=1, y=1, dir=1 }
    f = { x=3, y=1, dir=3 }
    g = { x=1, y=3, dir=7 }
    h = { x=3, y=3, dir=9 }
  }

  conn_sets =
  {
    "a:bcd"
    "a:gh"

    "e:fgh"
    "e:cd"
  }
}


START_O_4x4 =
{
  prob = 40
  start_prob = 500

  structure =
  {
    "/11%"
    "1111"
    "1111"
    "%11/"
  }

  diagonals =
  {
    ".1", "1."
    ".1", "1."
  }

  conns =
  {
    a = { x=3, y=1, w=2, dir=2 }
    b = { x=1, y=2, w=2, dir=4 }
    c = { x=4, y=3, w=2, dir=6 }
    d = { x=2, y=4, w=2, dir=8 }

    e = { x=1, y=1, dir=1 }
    f = { x=4, y=1, dir=3 }
    g = { x=1, y=4, dir=7 }
    h = { x=4, y=4, dir=9 }
  }

  conn_sets =
  {
    "a:bcd"
    "a:gh"

    "e:fgh"
    "e:cd"
  }
}


--[[
START_DONUT_1 =
{
  prob = 1000

  structure =
  {
    "/1111%"
    "1/22%1"
    "122221"
    "122221"
    "1%22/1"
    "%1111/"
  }

  diagonals =
  {
    ".1", "1."
    "1.", ".1"
    "1.", ".1"
    ".1", "1."
  }
}
--]]

-- end of TILES
}


------------------------------------------------------------------------
--  EXPERIMENT : produce levels like 0.85
------------------------------------------------------------------------

TILES_085 =
{

TEMPLATE_3x3 =
{
  prob = 100
  start_prob = 100

  structure =
  {
    "111"
    "111"
    "111"
  }

  conns =
  {
    a = { x=2, y=1, dir=2 }
    b = { x=1, y=2, dir=4 }
    c = { x=3, y=2, dir=6 }
    d = { x=2, y=3, dir=8 }

    e = { x=3, y=1, w=3, split=1, dir=2 }
    f = { x=3, y=1, w=3, dir=2 }
  }

  conn_sets =
  {
    "ab"
    "ac"
    "abc"
    "ad"
    "abcd"

    "ab"
    "ac"
    "abc"
    "ad"
    "abcd"

    "ed"
    "ebd"
    "ecd"
    "ebcd"

    "fd"
    "fbd"
    "fcd"
    "fbcd"

    "ef"
    "efb"
    "efc"
  }
}


ROOM_3x3_B =
{
  template = "TEMPLATE_3x3"

  structure =
  {
    "111"
    "1.1"
    "111"
  }
}

-- end of TILES
}

