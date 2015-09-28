------------------------------------------------------------------------
--  ROOM TILES
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2015 Andrew Apted
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


TILES =
{
 
--------------------------------
--
--  Hallways
--
--------------------------------

--[[
HALL_I_1x1 =
{
  prob = 40

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
--]]


HALL_I_1x3 =
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


HALL_I_2x1 =
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
    "a:b"
--  "a:bc"
  }
}


HALL_DIAG_I3 =
{
  prob = 200

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


HALL_DIAG_Y_4x4 =
{
  prob = 200

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
    "a:bc"
  }
}



--------------------------------
--
--  Generic Caves
--
--------------------------------


--------------------------------
--
--  Generic Outdoors
--
--------------------------------

--[[
OUTDOOR_GENERIC_6x6 =
{
  prob = 100

  structure =
  {
    "..??.."
    "..??.."
    "??????"
    "??????"
    "..??.."
    "..??.."
  }

  conns =
  {
    a = { x=4, y=1, w=2, dir=2 }
    b = { x=1, y=3, w=2, dir=4 }
    c = { x=6, y=4, w=2, dir=6 }
    d = { x=3, y=6, w=2, dir=8 }
  }

  conn_sets =
  {
    "a:bc"
    "a:bd"
    "a:bcd"
  }
}
--]]


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
--[[
    "a:bc"
    "a:bcf"
    "a:de"
    "a:def"
--]]
    "g:h"
    "g:km"
    "g:hkm"
  }
}


--------------------------------
--
--  Party Starters
--
--------------------------------

START_O_3x3 =
{
  start_prob = 100
  prob = 400

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
  start_prob = 500
  prob = 50

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

