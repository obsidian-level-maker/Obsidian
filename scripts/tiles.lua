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


HALL_I_1x3 =
{
  prob = 20

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


--[[
HALL_I_2x1 =
{
  prob = 10

  structure =
  {
    "11"
  }

  conns =
  {
    a = { x=1, y=1, dir=2, w=2 }
    b = { x=1, y=1, dir=8, w=2 }
  }
}
--]]


--[[
HALL_U_5x3_rounded =
{
  prob = 25

  structure =
  {
    "1...1"
    "%%.//"
    ".%1/."
  }

  diagonals =
  {
    ".1", "1.", ".1", "1."
    ".1", "1."
  }

  conns =
  {
    a = { x=1, y=3, dir=8 }
    b = { x=5, y=3, dir=8 }
    c = { x=5, y=3, dir=8 }
  }

  conn_
}
--]]


--------------------------------
--
--  Rooms
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
  }

  conn_sets =
  {
    "a:bc"
    "a:bcd"
    "a:de"
    "a:def"
--  "bc:a"
  }
}


--------------------------------
--
--  Party Starters
--
--------------------------------

START_O_3x3 =
{
  start_prob = 1000

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

