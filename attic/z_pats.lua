----------------------------------------------------------------
-- AREA FABS
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2012 Andrew Apted
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

AREA_PATTERNS =
{


--[[
EXTEND_1 =
{
  prob = 50

  extender = true

  area1 =
  {
    "###"
    "###"
    "#v#"
  }

  x_sizes = { "111", "121" }
  y_sizes = { "110", "111", "121" }

  symmetry = "x"
}
--]]


RECT_1 =
{
  prob = 50

  area1 =
  {
    "###"
    "#v#"
    "   "
  }

  area2 =
  {
    "   "
    "   "
    "###"
  }

  x_sizes = { "111", "121", "212" }
  y_sizes = { "211", "212", "312" }

  symmetry = "x"
}


RECT_2 =
{
  prob = 20

  area1 =
  {
    "###"
    "v#v"
    "   "
  }

  area2 =
  {
    "   "
    "   "
    "###"
  }

  x_sizes = { "121", "131", "141" }
  y_sizes = { "211", "212", "312", "313" }

  symmetry = "x"
}


--[[
DIAG_1 =
{
  prob = 50

  area1 =
  {
    "####"
    "##/ "
    "#>  "
    "#/  "
    "    "
  }

  area2 =
  {
    "    "
    "  /#"
    "  ##"
    " /##"
    "####"
  }

  x_sizes = { "1111", "2111", "1112", "2112", "3112", "2113", "3113" }
  y_sizes = { "01111", "11111", "11211", "21112", "21212" }
}
--]]


L1 =
{
  prob = 70

  area1 =
  {
    " ##"
    " v#"
    "   "
  }

  area2 =
  {
    "#  "
    "#  "
    "###"
  }

  anchors = { 2,4 }

  x_sizes = { "111", "112", "212", "221", "213" }
  y_sizes = { "111", "121", "212", "221", "222" }
}


--[[
L_MULTI =
{
  prob = 50

  overlap = true

  area1 =
  {
    "r###"
    " ###"
    "    "
    "    "
  }

  area2 =
  {
    "    "
    "#   "
    "#   "
    "###J"
  }

  area3 =
  {
    "  ##"
    "  ##"
    "  ##"
    "    "
  }

  anchors = { 2,4 }

  x_sizes = { "1011", "1021", "1121", "1131" }
  y_sizes = { "1011", "1021", "1121", "1131" }
}
--]]


T1 =
{
  prob = 50

  area1 =
  {
    "   "
    "# #"
    "#^#"
    "###"
  }

  area2 =
  {
    "###"
    " # "
    "   "
    "   "
  }

  x_sizes = { "111", "121", "212", "222" }
  y_sizes = { "1101", "1102", "1201", "1202", "1111", "1212" }

  symmetry = "x"
}


T2 =
{
  prob = 50

  area1 =
  {
    "   "
    "^ ^"
    "# #"
    "###"
  }

  area2 =
  {
    "###"
    " # "
    " # "
    "   "
  }

  x_sizes = { "121", "131", "222" }
  y_sizes = { "2011", "1111", "2111", "1211", "2121", "1212" }

  symmetry = "x"
}


-- end of AREA_PATTERNS
}

