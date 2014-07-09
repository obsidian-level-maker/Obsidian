------------------------------------------------------------------------
--  ROOM PATTERNS
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2008-2014 Andrew Apted
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
------------------------------------------------------------------------


-- 
-- Symbols used here:
--
--    .         main floor (the lowest one)
--    1 2 3 4   other floors (higher numbers are higher floors)
--
--    #         solid block
--
--    ~         liquid
-- 
--    a b c d   sub-areas (for recursive patterns)
--
--    ?         filler (in recursive patterns)
--
--    / % N Z   diagonal pieces
--
--    < > v ^   stairs (straight)
--
--    F T L J   stairs which turn 90 degrees
--
--    { } V A   stairs to a higher layer (3D floor)
--


ROOM_PATTERNS =
{


---------------------------
--  SOLID and DIAGONALS  --
---------------------------

SOLID_P1 =
{
  prob = 130
  shape = "P"

  solid_feature = true
  symmetry = "xy"

  structure =
  {
    "..."
    ".#."
    "..."
  }

  x_sizes = { "212", "313" }
  y_sizes = { "111", "212" }
}


SOLID_P2 =
{
  prob = 70
  shape = "P"

  environment = "indoor"
  solid_feature = true
  symmetry = "xy"

  structure =
  {
    "....."
    ".#.#."
    "....."
  }

  x_sizes = { "11211", "21112", "21212" }
  y_sizes = { "111", "212" }

}


SOLID_P3 =
{
  prob = 50
  shape = "P"

  environment = "indoor"
  solid_feature = true
  symmetry = "xy"

  structure =
  {
    "....."
    ".#.#."
    "....."
    ".#.#."
    "....."
  }

  x_sizes = { "11111", "11211" }
  y_sizes = { "11111", "11211" }
}


--[[ FIXME !!!!!!
SOLID_P5 =
{
  prob = 9999

  environment = "indoor"
  symmetry = "xy"

  structure =
  {
    "/...%"
    ".Z#N."
    ".###."
    ".%#/."
    "N...Z"
  }

  x_sizes = { "11111", "11211" }
  y_sizes = { "11111", "11211" }
}
--]]


SOLID_C1 =
{
  prob = 100

  solid_feature = true
  symmetry = "xy"

  structure =
  {
    "#.#"
    "..."
    "#.#"
  }

  x_sizes = { "121", "131", "141", "151", "222", }
  y_sizes = { "111", "121", "131" }
}


DIAG_C2 =
{
  prob = 600

  environment = "indoor"
  symmetry = "xy"

  structure =
  {
    "#/.%#"
    "....."
    "#N.Z#"
  }

  x_sizes = { "01110", "01210", "01310", "01410"
              "11111", "11211", "11311",  }

  y_sizes = { "111", "121", "131" }
}


SOLID_C3 =
{
  prob = 200

  environment = "indoor"
  solid_feature = true
  symmetry = "xy"

  structure =
  {
    "#.#.#"
    "....."
    "#.#.#"
  }

  x_sizes = { "11111", "11211", "12121" }
  y_sizes = { "111", "121", "131" }
}


SOLID_T1 =
{
  prob = 50
  shape = "T"

  environment = "indoor"
  solid_feature = true
  symmetry = "x"

  structure =
  {
    "#.#"
    "..."
  }

  x_sizes = { "121", "131", "141" }
  y_sizes = { "21", "31", "41" }
}


DIAG_T1 =
{
  prob = 80
  shape = "T"

  environment = "indoor"
  symmetry = "x"

  structure =
  {
    "/.%"
    "..."
  }

  x_sizes = { "111", "121", "131", "141" }
  y_sizes = { "11", "21", "31", "41" }
}


SOLID_OPP1 =
{
  prob = 100

--  environment = "indoor"
  solid_feature = true

  structure =
  {
    "..#"
    "..."
    "#.."
  }

  x_sizes = { "111", "121", "131" }
  y_sizes = { "101", "111", "121", "131" }
}


DIAG_OPP1 =
{
  prob = 300

  environment = "indoor"

  structure =
  {
    "..%"
    "..."
    "N.."
  }

  x_sizes = { "111", "121", "131" }
  y_sizes = { "101", "111", "121", "131" }
}


SOLID_L1 =
{
  prob = 200
  shape = "L"

  structure =
  {
    ".#"
    ".."
  }

  x_sizes = { "21", "22", "32" }
  y_sizes = { "21", "22", "32" }
}


DIAG_L1 =
{
  prob = 600
  shape = "L"

  environment = "indoor"

  structure =
  {
    "..##"
    "..%#"
    "...."
    "%..."
  }

  x_sizes = { "1111", "1211", "1311" }
  y_sizes = { "1111", "1211" }
}


DIAG_L2 =
{
  prob = 300
  shape = "L"

  environment = "indoor"

  structure =
  {
    "..%#"
    "...%"
    "...."
    "%..."
  }

  x_sizes = { "1011", "1111", "1211" }
  y_sizes = { "1011", "1111", "1211" }
}


--[[ FIXME !!!!!!
DIAG_X_HMMM =
{
  prob = 300
  shape = "X"

  environment = "indoor"
  symmetry = "xy"

  structure =
  {
    ".%#/."
    "N...Z"
    "#...#"
    "/...%"
    ".Z#N."
  }

  x_sizes = { "11011", "11111", "11211" }
  y_sizes = { "11011", "11111", "11211" }
}
--]]


DIAG_HT_BIG =
{
  prob = 5

  environment = "indoor"
  symmetry = "x"

  structure =
  {
    "/111%"
    "11111"
    "..^.."
    "....."
    "%.../"
  }

  x_sizes = { "10101", "11111", "12121", "13131" }

  y_sizes = { "10101", "10111", "11111"
              "10121", "11121", "12121"
              "12131", "13131" }
}


-----------------
--   LIQUIDS   --
-----------------

LIQUID_I =
{
  prob = 50

  symmetry = "xy"

  structure =
  {
    "~.~"
  }

  x_sizes = { "111", "212", "313", "323" }

  y_sizes = { "1", "2", "3", "4", "5", "6", "7" }
}


LIQUID_L1 =
{
  prob = 20
  shape = "L"

  structure =
  {
    ".~"
    ".."
  }

  x_sizes = { "12", "13", "14", "15", "25", "26", "27", "28" }
  y_sizes = { "12", "13", "14", "15", "25", "26", "27", "28" }
}


LIQUID_L2 =
{
  prob = 190
  shape = "L"

  structure =
  {
    "~."
    "~~"
  }

  x_sizes = { "22", "23", "24", "34", "35", "36", "37", "38" }
  y_sizes = { "22", "23", "24", "34", "35", "36", "37", "38" }
}


LIQUID_L3 =
{
  prob = 555
  shape = "L"

  environment = "indoor"

  structure =
  {
    "1~%"
    "1~~"
    "L.."
  }

  x_sizes = { "111", "121", "131" }
  y_sizes = { "111", "121", "131" }
}


LIQUID_L3_OUT =
{
  copy = "LIQUID_L3"

  environment = "outdoor"

  structure =
  {
    "1~~"
    "1~~"
    "L.."
  }
}


LIQUID_O1 =
{
  prob = 90
  shape = "O"

  symmetry = "xy"

  structure =
  {
    "..."
    ".~."
    "..."
  }

  x_sizes = { "121", "131", "222", "141" }
  y_sizes = { "131", "141" }
}


--[[ FIXME !!!!!
LIQUID_O2 =
{
  prob = 300
  shape = "O"

  environment = "indoor"
  symmetry = "xy"

  structure =
  {
    "/...%"
    "./~%."
    ".~~~."
    ".N~Z."
    "N...Z"
  }

  x_sizes = { "11111", "11211", "11311" }
  y_sizes = { "11011", "11111", "11211", "11311" }
}


LIQUID_O2_OUT =
{
  copy = "LIQUID_O2"

  environment = "outdoor"

  structure =
  {
    "....."
    "./~%."
    ".~~~."
    ".N~Z."
    "....."
  }

  x_sizes = { "11111", "11211", "11311", "21212" }
}
--]]


--[[ FIXME !!!!
LIQUID_O4 =
{
  prob = 500
  shape = "O"

  symmetry = "xy"

  structure =
  {
    "~~~~.~~~~"
    "~/.....%~"
    "~./~~~%.~"
    "~.~~~~~.~"
    "..~~~~~.."
    "~.~~~~~.~"
    "~.N~~~Z.~"
    "~N.....Z~"
    "~~~~.~~~~"
  }

  x_sizes = { "111010111", "111020111"
              "111111111", "111121111"
              "111212111", "111222111", "111313111"
              "211010112", "211111112", "211212112" }

  y_sizes = { "111000111"
              "111010111", "111020111"
              "111111111", "111121111"
              "111212111", "111222111", "111313111"
              "211010112", "211111112", "211212112" }
}
--]]


LIQUID_U1 =
{
  prob = 30
  shape = "U"

  symmetry = "x"

  structure =
  {
    ".~."
    "..."
  }

  x_sizes = { "121", "131", "141" }
  y_sizes = { "12", "13", "14" }
}


LIQUID_U2 =
{
  prob = 300
  shape = "U"

  symmetry = "x"

  structure =
  {
    "1~1"
    "L.J"
  }

  x_sizes = { "111", "121", "131", "141" }
  y_sizes = { "12",  "13", "14" }
}


LIQUID_U3 =
{
  prob = 300
  shape = "U"

  structure =
  {
    ".~2"
    "L1J"
  }

  x_sizes = { "121", "131", "141" }
  y_sizes = { "11", "12",  "13", "14" }
}


--[[ FIXME !!!!
LIQUID_U4 =
{
  prob = 200
  shape = "U"
  environment = "indoor"

  symmetry = "x"

  structure =
  {
    "./~%."
    ".~~~."
    ".N~Z."
    "N...Z"
  }

  x_sizes = { "11111", "11211", "11311" }
  y_sizes = { "1101", "1111", "1121", "1131" }
}

LIQUID_U4_OUT =
{
  copy = "LIQUID_U4"

  environment = "outdoor"

  structure =
  {
    "./~%."
    ".~~~."
    ".N~Z."
    "....."
  }
}
--]]


LIQUID_E =
{
  prob = 110
  shape = "E"

  symmetry = "y"

  structure =
  {
    ".."
    ".~"
    ".."
    ".~"
    ".."
  }

  x_sizes = { "12", "13", "14", "23" }
  y_sizes = { "12121", "12221", "13131" }
}


LIQUID_E2 =
{
  shape = "E"
  prob = 200

  symmetry = "y"

  structure =
  {
    ".."
    "v~"
    "1~"
    "11"
    "1~"
    "^~"
    ".."
  }

  x_sizes = { "12", "13", "14", "23", "24" }
  y_sizes = { "1111111", "1112111", "1121211", "1122211" }
}


LIQUID_E3 =
{
  prob = 999
  shape = "E"

  structure =
  {
    ".."
    "v~"
    "1~"
    "11"
    "1~"
    "v~"
    "22"
  }

  x_sizes = { "12", "13", "14", "23", "24" }
  y_sizes = { "1111111", "1112111", "1121211", "1122211" }
}


LIQUID_E4 =
{
  prob = 999
  shape = "E"

  structure =
  {
    "111"
    "1~~"
    "1<."
    "1~~"
    "111"
  }

  x_sizes = { "111", "112", "113", "213" }
  y_sizes = { "11111", "12111", "12121", "12221"  }
}


LIQUID_S1 =
{
  prob = 120
  shape = "S"

  structure =
  {
    "~.."
    "~.~"
    "..~"
  }

  x_sizes = { "112", "212", "213", "222", "313" }
  y_sizes = { "111", "121", "131", "141", "222" }
}


LIQUID_S2 =
{
  prob = 200
  shape = "S"

  structure =
  {
    "~11"
    "~1~"
    "~v~"
    "~.~"
    "..~"
  }

  x_sizes = { "112", "212", "213", "313" }

  y_sizes = { "10101", "11101", "10111"
              "11111", "12111", "11121", "12121" }
}


LIQUID_BIG_S1 =
{
  prob = 50
  shape = "S"

  structure =
  {
    ".~..."
    ".~.~."
    "...~."
  }

  x_sizes = { "11111", "12111", "12121", "12221", "13121", "13131" }

  y_sizes = { "111", "121", "131", "141", "222" }
}


LIQUID_BIG_S3 =
{
  prob = 999
  shape = "S"

  structure =
  {
    ".~~~11>22"
    ".~~~1~~~2"
    "..>11~~~2"
  }

  x_sizes =
  {
    "101010101", "101010111", "101011101"
    "101111101", "111010111", "111011111"
    "111111111"
  }

  y_sizes = { "111", "121", "131", "141" }
}


LIQUID_BIG_S4 =
{
  prob = 699
  shape = "S"

  structure =
  {
    ".~11T"
    ".~1~2"
    "L11~2"
  }

  x_sizes = { "11111", "12111", "11121"
              "12121", "13121", "12131", "13131" }

  y_sizes = { "111", "121", "131", "141" }
}


LIQUID_CROSS_1 =
{
  prob = 300
  shape = "X"

  symmetry = "xy"

  structure =
  {
    "~.~"
    "..."
    "~.~"
  }

  x_sizes = { "111", "212", "313", "323", "414" }
  y_sizes = { "212", "222", "313" }
}


LIQUID_CROSS_2 =
{
  prob = 300
  shape = "X"

  environment = "indoor"
  symmetry = "xy"

  structure =
  {
    "/~~.~~%"
    "~~~.~~~"
    "~~/.%~~"
    "......."
    "~~N.Z~~"
    "~~~.~~~"
    "N~~.~~Z"
  }

  x_sizes =
  {
--!!!!    "1011101"
    "1111111", "1112111"
    "1211121", "1212121"
    "1311131"
  }

  y_sizes =
  {
--!!!!    "1011101"
    "1111111", "1112111"
    "1211121", "1212121"
    "1311131"
  }
}


LIQUID_CROSS_2_OUT =
{
  copy = "LIQUID_CROSS_2"

  environment = "outdoor"

  structure =
  {
    "~~~.~~~"
    "~~~.~~~"
    "~~/.%~~"
    "......."
    "~~N.Z~~"
    "~~~.~~~"
    "~~~.~~~"
  }
}


LIQUID_T1 =
{
  prob = 250
  shape = "T"

  symmetry = "x"

  structure =
  {
    "..."
    "~.~"
  }

  x_sizes = { "212", "222", "313" }
  y_sizes = { "21", "31", "32", "41", "42" }
}


LIQUID_T_NICE =
{
  prob = 591
  shape = "T"

  symmetry = "x"

  structure =
  {
    "....."
    "~%./~"
    "~~.~~"
  }

  x_sizes = { "11111", "11211", "21112", "21212"  }
  y_sizes = { "211", "311", "312", "411", "412" }
}


LIQUID_H1 =
{
  prob = 221

  symmetry = "xy"

  structure =
  {
    ".~."
    "..."
    ".~."
  }

  x_sizes = { "121", "131", "141", "222" }
  y_sizes = { "111", "212", "313" }
}


LIQUID_H4 =
{
  prob = 500

  symmetry = "x"

  structure =
  {
    "....."
    "~.~.~"
    "..~.."
  }

  x_sizes = { "11111", "11211", "21112", "21212" }

  y_sizes = { "121", "131", "141", "151", "222", "242" }
}


LIQUID_X1 =
{
  prob = 200

  symmetry = "xy"

  structure =
  {
    "..~.."
    "~...~"
    "..~.."
  }

  x_sizes = { "11111", "11211", "21112", "21212" }

  y_sizes = { "111" }
}


-----------------------
--  HEIGHT CHANGERS  --
-----------------------

HEIGHT_I1 =
{
  prob = 600

  structure =
  {
    "111"
    ".^."
    "..."
  }

  x_sizes = { "011", "111", "112" }
  y_sizes = { "012", "111", "112" }
}


HEIGHT_I2 =
{
  prob = 200

  symmetry = "x"

  structure =
  {
    "111"
    "^.^"
    "..."
  }

  x_sizes = { "101", "111", "121", }
  y_sizes = { "012", "111", "112", "212" }
}


HEIGHT_I3 =
{
  prob = 500

  environment = "indoor"
  symmetry = "x"

  structure =
  {
    "/111%"
    "11111"
    "Z.^.N"
    "....."
  }

  x_sizes = { "10101", "11111", "12121" }
  y_sizes = { "1111", "1121" }
}


HEIGHT_I3_OUT =
{
  copy = "HEIGHT_I3"

  environment = "outdoor"

  structure =
  {
    "11111"
    "11111"
    "Z.^.N"
    "....."
  }
}


HEIGHT_LIQ_I1 =
{
  prob = 200

  symmetry = "x"

  structure =
  {
    "111"
    "~^~"
    "..."
  }

  x_sizes = { "111", "212", "222", "313", "323" }

  y_sizes = { "111", "112", "212", "213", "213" }
}


HEIGHT_LIQ_I3 =
{
  prob = 400

  symmetry = "x"

  structure =
  {
    "11111"
    "~^~^~"
    "....."
  }

  x_sizes = { "11111", "11211", "11311", "21212", "21312" }

  y_sizes = { "111", "112", "212", "213", "213" }
}


HEIGHT_LIQ_O1 =
{
  prob = 1000

  structure =
  {
    "11111"
    "^Z~N1"
    ".~~~1"
    ".N~Zv"
    "....."
  }

  x_sizes = { "11011", "11111", "11211", "21112" }

  y_sizes = { "11011", "11111", "11211", "21211" }
}


HEIGHT_LIQ_O2 =
{
  prob = 500

  symmetry = "x"

  structure =
  {
    "111"
    "1~1"
    "^~^"
    ".~."
    "..."
  }

  x_sizes = { "111", "121", "131", "141" }

  y_sizes = { "10101", "11101", "10111", "11111", "12121", "11112" }
}


HEIGHT_LIQ_U2 =
{
  prob = 2000

  symmetry = "x"

  structure =
  {
    "11~~~11"
    "1v~~~v1"
    "..N~Z.."
    "......."
  }

  x_sizes = { "0110110", "0111110", "0112110", "1111111", "1112111" }

  y_sizes = { "1111", "1112", "1113", "2112", "2113", "2114" }
}


HEIGHT_SOLID_I2 =
{
  prob = 1000
  environment = "indoor"

  solid_feature = true

  structure =
  {
    "11111"
    "Z^#^N"
    "....."
  }

  x_sizes = { "01110", "01111", "11110", "11111", "11211" }
  y_sizes = { "111", "112", "211", "212" }
}


HEIGHT_SOLID_I4 =
{
  prob = 2000

  environment = "indoor"
  symmetry = "x"

  structure =
  {
    "##1##"
    "#Z1N#"
    "#111#"
    "Z.^.N"
    "....."
  }

  x_sizes = { "11111", "11211", "11311" }
  y_sizes = { "11110", "11111", "11210", "11211" }
}


HEIGHT_SOLID_I5 =
{
  prob = 5000

  environment = "indoor"
  symmetry = "x"

  structure =
  {
    "##222##"
    "#Z1^1N#"
    "#11111#"
    "Z..^..N"
    "......."
  }

  x_sizes = { "1101011", "1111111", "1112111", "1121211" }
  y_sizes = { "11111", "11112", "11211", "11212" }
}


HEIGHT_C5 =
{
  prob = 3000

  structure =
  {
    "111111"
    "1111/."
    "1111.."
    "1v1/.."
    "......"
  }

  x_sizes = { "010111", "110111", "011111", "111111"
              "111112", "211111", "211112" }

  y_sizes = { "11011", "11111", "11211", "21111", "21112", "21212" }
}


HEIGHT_C6 =
{
  prob = 8000

  structure =
  {
    "2>11."
    "2/11."
    "1111."
    "1v1/."
    "....."
  }

--!!!!  x_sizes = { "11011", "11111", "21011", "21111", "31111" }
  x_sizes = { "11111", "21111", "31111" }

  y_sizes = { "11011", "11111", "11112", "21112", "21211" }
}


HEIGHT_L1 =
{
  prob = 300

  structure =
  {
    ".11"
    ".>1"
    "..."
  }

  x_sizes = { "012", "013", "112" }
  y_sizes = { "110", "210", "111" }
}


HEIGHT_L2 =
{
  prob = 600

  structure =
  {
    "11"
    "F1"
    ".."
  }

  x_sizes = { "12", "13" }
  y_sizes = { "110", "210", "111" }
}


HEIGHT_CURV_1 =
{
  prob = 999
  shape = "O"

  structure =
  {
    "F.T"
    "111"
    "L.J"
  }

  x_sizes = { "121", "131", "141" }
  y_sizes = { "121", "131", "141" }
}


HEIGHT_CURV_2 =
{
  prob = 5000   -- very rarely occurs
  shape = "O"
  level = "top"

  structure =
  {
    "F2T"
    "121"
    "1.1"
    "L.J"
  }

  x_sizes = { "121", "131", "141", "151", }
  y_sizes = { "1201", "1211", "1301", "1311" }
}


-----------------
--  3D FLOORS  --
-----------------

MULTI_I1 =
{
  prob = 4000

  symmetry = "y"

  structure =
  {
    "..."
    "2<."
    "..."
  }

  overlay =
  {
    "2  "
    "   "
    "2  "
  }

  x_sizes = { "111", "211", "311", "312" }
  y_sizes = { "111", "212", "313" }
}


MULTI_I2 =
{
  prob = 10

  symmetry = "y"

  structure =
  {
    ".{."
    "..."
    ".{."
  }

  overlay =
  {
    "2  "
    "2  "
    "2  "
  }

  x_sizes = { "999" }
  y_sizes = { "999" }
}


MULTI_U1 =
{
  prob = 10

  symmetry = "y"

  structure =
  {
    "..."
    ".{."
    "..."
  }

  overlay =
  {
    "222"
    "2  "
    "222"
  }

  x_sizes = { "999" }
  y_sizes = { "999" }
}


MULTI_T1 =
{
  prob = 10

  symmetry = "y"

  structure =
  {
    ".{."
    "..."
    ".{."
  }

  overlay =
  {
    "2  "
    "222"
    "2  "
  }

  x_sizes = { "999" }
  y_sizes = { "999" }
}


MULTI_LIQUID_H1 =
{
  prob = 7000

  symmetry = "xy"

  structure =
  {
    ".~."
    ".~."
    ".~."
  }

  overlay =
  {
    "   "
    " . "
    "   "
  }

  x_sizes = { "121", "131", "222" }
  y_sizes = { "111", "212" }
}


MULTI_LIQUID_T1 =
{
  prob = 8000

  symmetry = "y"

  structure =
  {
    "~.~"
    "~~~"
    "~.~"
    "~~~"
    "~.~"
  }

  overlay =
  {
    "   "
    " . "
    ".  "
    " . "
    "   "
  }

  x_sizes = { "211", "311", "312", "313" }
  y_sizes = { "11111", "12121", "22122"  }
}


MULTI_LIQUID_S1 =
{
  prob = 1500

  structure =
  {
    ".~~"
    "~~~"
    "~~."
  }

  overlay =
  {
    "   "
    "..."
    "   "
  }

  x_sizes = { "111", "121", "131", "222" }
  y_sizes = { "111", "212", "222" }
}


MULTI_SPIRAL =
{
  prob = 4000

  structure =
  {
    "..v"
    "..2"
    "4.."
    "^2."
  }

  overlay =
  {
    "444"
    "4  "
    "  2"
    "  2"
  }

  x_sizes = { "121", "131", "141" }
  y_sizes = { "1111", "1211", "1121", "1221", "1321" }
}


--------------------------
--  RECURSIVE PATTERNS  --
--------------------------

RECURSE_PURE_I1 =
{
  prob = 500

  recurse = "pure"

  structure =
  {
    "a"
    "b"
  }

  x_sizes = { "2", "3", "4", "5", "6", "7",
              "8", "9", "A", "B", "C" }

  y_sizes = { "23", "33", "34", "44",
              "45", "55", "56", "66" }
}


RECURSE_PURE_I3 =
{
  prob = 1000

  recurse = "pure"

  structure =
  {
    "a"
    "b"
    "c"
  }

  x_sizes = { "2", "3", "4", "5", "6", "7",
              "8", "9", "A", "B", "C" }

  y_sizes = { "232", "323", "333", "234", "343", "434",
              "444", "345", "353", "535", "454", "545" }
}


RECURSE_PURE_T1 =
{
  prob = 1000

  recurse = "pure"

  structure =
  {
    "ac"
    "bb"
  }

  x_sizes = { "33", "34", "44", "35", "45", "55",
              "36", "46", "56", "66", "47", "57", "67", "77",
              "48", "68", "88" }

  y_sizes = { "33", "43", "44", "53", "54", "55",
              "63", "64", "65", "66", "73", "74", "75",
              "84", "86", "88" }
}


RECURSE_PURE_P1 =
{
  prob = 500

  recurse = "pure"

  structure =
  {
    "ac"
    "bd"
  }

  x_sizes = { "33", "34", "44", "35", "45", "55",
              "36", "46", "56", "66", "47", "57", "67", "77",
              "48", "68", "88" }

  y_sizes = { "33", "34", "44", "35", "45", "55",
              "36", "46", "56", "66", "47", "57", "67", "77",
              "48", "68", "88" }
}


RECURSE_PURE_P2 =
{
  prob = 1000

  recurse = "pure"

  structure =
  {
    "abb"
    "ccd"
  }

  x_sizes = { "313", "314", "414", "315", "415", "515",
              "316", "416", "515", "616",
              "417", "517", "717", "818", "919",
              "323", "424", "525", "626", "727", "828" }

  y_sizes = { "33", "43", "44", "53", "54", "55",
              "63", "64", "65", "66", "73", "74", "75",
              "84", "86", "88" }
}


RECURSE_PURE_P3 =
{
  prob = 1200

  recurse = "pure"

  structure =
  {
    "aab"
    "d#b"
    "dcc"
  }

  x_sizes = { "313", "314", "414", "315", "415", "515",
              "316", "416", "515", "616",
              "417", "517", "717", "818", "919",
              "323", "424", "525", "626", "727", "828" }

  y_sizes = { "313", "314", "414", "315", "415", "515",
              "316", "416", "515", "616",
              "417", "517", "717", "818", "919",
              "323", "424", "525", "626", "727", "828" }
}


--[[  IDEA...
RECURSE_SOLID_C4 =
{
  prob = 1200

  recurse = "pure"

  structure =
  {
    "#?#"
    "?a?"
    "#?#"
  }

  x_sizes = { "1 3+ 1", "2 6+ 2" }

  y_sizes = { "1 2+ 1", "2 6+ 2" }
}
--]]


SOLID_CSUB =
{
  prob = 200

  recurse = "diff"
  environment = "indoor"
  solid_feature = true

  structure =
  {
    "#..v..#"
    "..aaa.."
    "#..^..#"
  }

  x_sizes =
  {
    "1111111", "1121111"
    "1121211", "1131211"
    "1131311", "1132311"
  }

  y_sizes = { "121", "131", "141", "151", "161", "171"
              "181", "191", "1A1", "1B1" }
}


SOLID_CSUB4 =
{
  prob = 300

  recurse = "diff"
  environment = "indoor"
  solid_feature = true
  symmetry = "xy"

  structure =
  {
    "#.v.#"
    ".aaa."
    ">aaa<"
    ".aaa."
    "#.^.#"
  }

  y_sizes = { "11111", "12121", "12221"
              "13131", "13231", "14141", "14241" }

  x_sizes = { "11111", "12121", "12221"
              "13131", "13231", "14141", "14241" }
}


REC_SOLID_C1 =
{
  prob = 500

  recurse = "same"
  environment = "indoor"
  solid_feature = true
  symmetry = "xy"

  structure =
  {
    "#a#"
    ".a."
    ">a<"
    ".a."
    "#a#"
  }

  x_sizes = { "121", "131", "141", "151", "161"
              "171", "181", "191", "1A1", "1B1" }

  y_sizes = { "11111", "11211", "12121", "12221"
              "13131", "13231", "14141", "14241"
              "24142" }
}


REC_SOLID_C2 =
{
  prob = 900

  recurse = "same"
  environment = "indoor"
  solid_feature = true

  structure =
  {
    "#a#"
    ".a<"
    ".a."
    ">a."
    "#a#"
  }

  x_sizes = { "121", "131", "141", "151", "161"
              "171", "181", "191", "1A1", "1B1" }

  y_sizes = { "11011", "11111", "11211", "11311"
              "11411", "11511", "11611", "11711"
              "21512", "21612", "21712" }
}


REC_SOLID_C3 =
{
  prob = 900

  recurse = "same"
  environment = "indoor"
  solid_feature = true
  symmetry = "xy"

  structure =
  {
    "#a#"
    ">a<"
    ".a."
    ">a<"
    "#a#"
  }

  x_sizes = { "121", "131", "141", "151", "161"
              "171", "181", "191", "1A1", "1B1" }

  y_sizes = { "11111", "11211", "11311", "11411", "11511"
              "11611", "11711", "11811", "11911" }
}


REC_SOLID_C4 =
{
  prob = 900

  recurse = "same"
  environment = "indoor"
  solid_feature = true

  structure =
  {
    "#a#"
    ".a<"
    ".a."
    ">a."
    "#a#"
  }

  x_sizes = { "121", "131", "141", "151", "161"
              "171", "181", "191", "1A1", "1B1" }

  y_sizes = { "11011", "11111", "11211", "11311"
              "11411", "11511", "11611", "11711"
              "21512", "21612", "21712" }
}


REC_SOLID_HT_C1 =
{
  copy = "REC_SOLID_C1"

  prob = 950

  recurse = "diff"
}


REC_SOLID_HT_C2 =
{
  copy = "REC_SOLID_C2"

  prob = 950

  recurse = "diff"
}


REC_SOLID_HT_C3 =
{
  copy = "REC_SOLID_C3"

  prob = 950

  recurse = "diff"
}


REC_SOLID_HT_C4 =
{
  copy = "REC_SOLID_C4"

  prob = 950

  recurse = "diff"
}


REC_DIAG_C1 =
{
  prob = 900

  recurse = "same"
  environment = "indoor"
  symmetry = "xy"

  structure =
  {
    "/a%"
    ".a."
    ">a<"
    ".a."
    "NaZ"
  }

  x_sizes = { "121", "131", "141", "151", "161"
              "171", "181", "191", "1A1", "1B1" }

  y_sizes = { "11111", "12121", "13131", "14141", "15151"
              "13231", "14241" }
}


REC_DIAG_C3 =
{
  prob = 900

  recurse = "same"
  environment = "indoor"
  symmetry = "xy"

  structure =
  {
    "/a%"
    ">a<"
    ".a."
    ">a<"
    "NaZ"
  }

  x_sizes = { "121", "131", "141", "151", "161"
              "171", "181", "191", "1A1", "1B1" }

  y_sizes = { "11111", "11211", "11311", "11411", "11511"
              "11611", "11711", "11811", "11911" }
}


REC_DIAG_C4 =
{
  prob = 900

  recurse = "same"
  environment = "indoor"

  structure =
  {
    "/a%"
    ".a<"
    ".a."
    ">a."
    "NaZ"
  }

  x_sizes = { "121", "131", "141", "151", "161"
              "171", "181", "191", "1A1", "1B1" }

  y_sizes = { "11011", "11111", "11211", "11311"
              "11411", "11511", "11611", "11711" }
}


REC_DIAG_HT_C1 =
{
  copy = "REC_DIAG_C1"

  prob = 950

  recurse = "diff"
}


REC_DIAG_HT_C3 =
{
  copy = "REC_DIAG_C3"

  prob = 950

  recurse = "diff"
}


REC_DIAG_HT_C4 =
{
  copy = "REC_DIAG_C4"

  prob = 950

  recurse = "diff"
}


RECURSE_I1 =
{
  prob = 400

  recurse = "diff"
  symmetry = "x"

  structure =
  {
    "aaa"
    ".^."
    "..."
  }

  x_sizes = { "111", "212", "313", "414", "515", "616" }

  y_sizes =
  {
    "013", "014"
    "113", "114", "115", "116", "117"
    "118", "119", "11A", "11B", "11C"
  }
}


RECURSE_I2 =
{
  prob = 300

  recurse = "diff"

  structure =
  {
    "aaa"
    ".^."
    "..."
  }

  x_sizes =
  {
    "111", "210", "211", "212"
    "310", "311", "312", "313"
    "410", "412", "414"
    "511", "513", "515"
    "610", "612", "614", "616"
    "812", "814"
  }

  y_sizes =
  {
    "013", "014"
    "113", "114", "115", "116", "117"
    "118", "119", "11A", "11B", "11C"
  }
}


RECURSE_I3 =
{
  prob = 300

  recurse = "diff"
  environment = "indoor"
  symmetry = "x"

  structure =
  {
    "aaaaaaa"
    "..^.^.."
    "%...../"
  }

  x_sizes =
  {
    "1011101", "1012101", "1013101", "1014101"
    "1111111", "1112111", "1113111", "1114111"
    "1212121", "1312131", "1313131"
  }

  y_sizes =
  {
    "013", "014"
    "113", "114", "115", "116", "117"
    "118", "119", "11A", "11B", "11C"
  }
}


RECURSE_I3_OUT =
{
  copy = "RECURSE_I3"

  environment = "outdoor"

  structure =
  {
    "aaaaaaa"
    "..^.^.."
    "......."
  }
}


RECURSE_T_SOLID =
{
  prob = 999
  shape = "T"

  recurse = "diff"
  environment = "indoor"
  symmetry = "x"

  structure =
  {
    "#..v..#"
    ".aaaaa."
    ">aaaaa<"
    ".aaaaa."
    ".Z###N."
  }

  x_sizes = { "1101011", "1111111", "1112111"
              "1121211", "1122211", "1131311"
              "1132311", "1141411" }

  y_sizes = { "10111", "11101", "11111"
              "12101", "10121", "11121", "12111", "12121"
              "13111", "11131", "12131", "13131", "13231"
              "14111", "11141", "14141", "14241" }
}


RECURSE_L1 =
{
  prob = 500
  shape = "L"

  recurse = "diff"

  structure =
  {
    ".aaa"
    "..^."
    "...."
  }

  x_sizes =
  {
    "1012", "1013", "1014", "1015", "1016", "1017"
    "1018", "1019", "101A", "101B"

    "1210", "1310", "1410", "1510", "1610", "1710"
    "1810", "1910", "1A10", "1B10"

    "1111", "1112", "1212", "1213", "1313", "1314"
    "1414", "1415", "1515", "1516"

    "2015", "2016", "2017", "2018", "2019", "201A"
    "2510", "2610", "2710", "2810", "2910", "2A10"
    "2212", "2312", "2313", "2413", "2414", "2514", "2515"
  }

  y_sizes =
  {
    "012"
    "013", "014", "015", "016", "017"
    "113", "114", "115", "116", "117"
    "118", "119", "11A", "11B"
  }
}


RECURSE_L2 =
{
  prob = 95
  shape = "L"

  recurse = "diff"

  structure =
  {
    ".>aa"
    "..aa"
    "...^"
    "...."
  }

  x_sizes =
  {
    "0121", "0131", "0141", "0151"
    "1141", "1141", "1151", "1161"
    "1171", "1181", "1191", "11A1"
    "2171", "2181", "2191"
  }

  y_sizes =
  {
    "0121", "0131", "0141", "0151"
    "1141", "1141", "1151", "1161"
    "1171", "1181", "1191", "11A1"
    "2171", "2181", "2191"
  }
}


RECURSE_L2_DIAG =
{
  prob = 800,  -- rarely occurs
  shape = "L"

  recurse = "diff"
  environment = "indoor"

  structure =
  {
    ".>aa"
    "..aa"
    "%..^"
    "#%.."
  }

  x_sizes =
  {
    "1131", "1141", "1141", "1151", "1161"
    "1171", "1181", "1191", "11A1"
  }

  y_sizes =
  {
    "1131", "1141", "1141", "1151", "1161"
    "1171", "1181", "1191", "11A1"
  }
}


RECURSE_L3_DIAG =
{
  prob = 999
  shape = "L"

  recurse = "diff"
  environment = "indoor"

  structure =
  {
    "/...%"
    ".v..."
    "aaa.."
    "aaa<."
    "aaa./"
  }

  x_sizes = { "11011", "11111", "11211", "11311", "11411"
              "11511", "11611", "11711", "11811", "11911" }

  y_sizes = { "11011", "11111", "11211", "11311", "11411"
              "11511", "11611", "11711", "11811", "11911" }
}


RECURSE_U1 =
{
  prob = 85
  shape = "U"

  recurse = "diff"

  structure =
  {
    ".aaa."
    "..^.."
    "....."
  }

  x_sizes =
  {
    "11111", "12111", "12121", "13121"
    "13131", "14131", "14141", "23132"
    "24142", "25152"
  }

  y_sizes =
  {
    "013", "014", "015", "016"
    "115", "116", "117", "118", "119", "11A", "11B"
  }
}


RECURSE_U2 =
{
  prob = 85
  shape = "U"

  recurse = "diff"
  symmetry = "x"

  structure =
  {
    "..a.."
    ".>a<."
    "..a.."
    "....."
  }

  x_sizes =
  {
    "01310", "01410", "01510", "01610"
    "11511", "11611", "11711", "11811", "11911"
  }

  y_sizes =
  {
    "1111", "1212", "1313", "1414", "1515"
    "1013", "1014", "1015", "1016", "1017", "1019", "101B"
    "1310", "1410", "1510", "1610", "1810", "1A10"
  }
}


RECURSE_O1_DIAG =
{
  prob = 30
  shape = "O"

  recurse = "diff"
  environment = "indoor"
  symmetry = "x"

  structure =
  {
    "/...%"
    "....."
    ".aaa."
    "..^.."
    "%.../"
  }

  x_sizes =
  {
    "11111", "12121", "13131", "14141", "15151"
  }

  y_sizes =
  {
    "11211", "11311", "11411", "11511", "11611"
    "11711", "11811", "11911"
  }
}


RECURSE_O3_DIAG =
{
  prob = 20
  shape = "O"

  recurse = "diff"
  environment = "indoor"

  structure =
  {
    "/...%"
    "...v."
    ".aaa."
    ".^..."
    "%.../"
  }

  x_sizes =
  {
    "11111", "11211", "11311", "11411", "11511"
    "11611", "11711", "11811", "11911"
  }

  y_sizes =
  {
    "11211", "11311", "11411", "11511", "11611"
    "11711", "11811", "11911"
  }
}


RECURSE_T1 =
{
  prob = 950
  shape = "T"

  recurse = "diff"
  symmetry = "x"

  structure =
  {
    "aaa.bbb"
    ".^...^."
    "......."
  }

  x_sizes =
  {
    "0111110", "1101011", "1111111"
    "0121210", "2101012", "2111112", "2112112", "2121212"
    "0131310", "3101013", "3111113", "3112113", "3121213"
  }

  y_sizes =
  {
    "012", "013", "014", "015"
    "114", "115", "116", "117"
    "118", "119", "11A", "11B"
  }
}


RECURSE_T1_DIAG =
{
  prob = 650
  shape = "T"

  recurse = "diff"
  symmetry = "x"

  structure =
  {
    "aaa.bbb"
    ".^...^."
    "%...../"
  }

  x_sizes =
  {
    "1101011", "1111111", "1112111"
    "1121211", "1122211", "1131311"
    "1132311", "1141411"
  }

  y_sizes =
  {
    "113", "114", "115", "116", "117"
    "118", "119", "11A", "11B"
  }
}


RECURSE_T1_NOSYM =
{
  prob = 350
  shape = "T"

  recurse = "diff"

  structure =
  {
    "aaa.bbb"
    ".^...^."
    "......."
  }

  x_sizes =
  {
    "0111011", "0121012", "0131013", "0132013"
    "0141014", "0151015"
    "1121112", "1131113", "1132113", "1141114"
  }

  y_sizes =
  {
    "012", "013", "014", "015"
    "114", "115", "116", "117"
    "118", "119", "11A", "11B"
  }
}


RECURSE_T3 =
{
  prob = 500
  shape = "T"

  recurse = "diff"
  solid_feature = true
  symmetry = "x"

  structure =
  {
    "a...b"
    "a<.>b"
    "a...b"
    "..#.."
  }

  x_sizes =
  {
    "21012", "31013", "41014", "51015"
    "31113", "41114", "51115"
  }

  y_sizes =
  {
    "1111", "1112", "1113", "1114", "1115", "2115", "2116"
    "1210", "1310", "1410", "1510", "1610", "2610", "2710"
    "2313"
  }
}


RECURSE_T3_NOSYM =
{
  prob = 1000
  shape = "T"

  recurse = "diff"
  solid_feature = true

  structure =
  {
    "a<..b"
    "a...b"
    "a..>b"
    "..#.."
  }

  x_sizes =
  {
    "21012", "31013", "41014", "51015"
    "31113", "41114", "51115"
  }

  y_sizes =
  {
    "1111", "1121", "1131", "1141", "1151"
    "2151", "2161", "2171", "2181", "2191"
  }
}


RECURSE_H1 =
{
  prob = 200
  shape = "H"

  recurse = "diff"

  structure =
  {
    "....."
    "...v."
    "aa.bb"
    ".^..."
    "....."
  }

  x_sizes =
  {
    "11111", "11112", "21112", "21113"
    "31113", "31213", "41114", "41214"
    "51115"
  }

  y_sizes =
  {
    "01310", "01410", "01510", "01610"
    "11511", "11611", "11711", "11811", "11911"
  }
}


RECURSE_H2 =
{
  prob = 900
  shape = "H"

  recurse = "diff"
  symmetry = "x"

  structure =
  {
    "......."
    "......."
    "aaa.bbb"
    ".^...^."
    "......."
  }

  x_sizes =
  {
    "0121210", "1111111", "2101012"
    "0131310", "1121211", "3101013"
    "0132310", "1122211", "3102013"
    "0141410", "2121212", "4101014"
    "0142410", "2122212", "4102014"
  }

  y_sizes =
  {
    "01310", "01410", "01510", "01610"
    "11511", "11611", "11711", "11811", "11911"
  }
}


RECURSE_H3 =
{
  prob = 1500,  -- rarely usable
  shape = "H"

  recurse = "diff"

  structure =
  {
    "....."
    "a...b"
    "a<.>b"
    "a...b"
    "....."
  }

  x_sizes =
  {
    "21012", "31013", "41014", "51015"
    "31113", "41114", "51115"
  }

  y_sizes =
  {
    "11111", "12121", "13131", "23132", "24142"
    "11101", "12101", "13101", "14101", "15101"
    "24102", "25102", "26102", "27102", "28102"
  }
}


RECURSE_S1 =
{
  prob = 300
  shape = "S"

  recurse = "diff"

  structure =
  {
    "aaa...."
    "aaa..v."
    "aaa.bbb"
    ".^..bbb"
    "....bbb"
  }

  x_sizes =
  {
    "0111110", "0111210", "0121210"
    "0121310", "0131310", "0132310"
    "0141410", "0142410", "0151510"

    "1101011", "1101012", "2101012"
    "2101013", "3101013", "3102013"
    "4101014", "4102014", "5101015"

    "1111111", "1112111", "1121211", "2121212"
  }

  y_sizes =
  {
    "01210", "01310", "01410", "01510"
    "11311", "11411", "11511", "11611"
    "11711", "11811", "11911"
  }
}


RECURSE_S2 =
{
  prob = 930
  shape = "S"

  recurse = "diff"

  structure =
  {
    "a.."
    "a<."
    "a.."
    "a.b"
    "..b"
    ".>b"
    "..b"
  }

  x_sizes =
  {
    "213", "313", "314", "414", "415", "515", "516", "616"
  }

  y_sizes =
  {
    "0102010", "0103010", "0104010", "0105010"
    "0113110", "0114110", "0115110", "0116110"
    "0117110", "0118110", "0119110"

    "1111111", "1112111", "2111112", "2112112"
    "3111113", "3112113", "4111114"
  }
}


RECURSE_WOW_LIQUID_O2 =
{
  prob = 900
  shape = "O"

  recurse = "diff"
  symmetry = "xy"

  structure =
  {
    "~~~.~~~"
    "~..v..~"
    "~.aaa.~"
    "~.aaa.~"
    "~.aaa.~"
    "~..^..~"
    "~~~.~~~"
  }

  x_sizes = { "1111111", "1121211", "1131311", "1141411"
              "2111112", "2121212", "2131312" }

  y_sizes = { "1110111", "1111111", "1121211", "1131311", "1141411"
              "2111112", "2121212", "2131312" }
}


RECURSE_WOW_LIQUID_O4 =
{
  prob = 600
  shape = "O"

  recurse = "diff"
  symmetry = "xy"

  structure =
  {
    "~~~.~~~"
    "~..v..~"
    "~.aaa.~"
    ".>aaa<."
    "~.aaa.~"
    "~..^..~"
    "~~~.~~~"
  }

  x_sizes = { "1111111", "1121211", "1131311", "1141411"
              "2111112", "2121212", "2131312" }

  y_sizes = { "1111111", "1121211", "1131311", "1141411"
              "2111112", "2121212", "2131312" }
}


} -- end of ROOM_PATTERNS

