----------------------------------------------------------------
--  Height/Liquid Fabs
----------------------------------------------------------------
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
----------------------------------------------------------------


ROOM_PATTERNS =
{


PLAIN =
{
  prob = 10

  structure =
  {
    "."
  }

  x_sizes = { "1", "2", "3", "4" }
  y_sizes = { "1", "2", "3" }

  symmetry = "xy"
}


---------------------------
--  SOLID and DIAGONALS  --
---------------------------

SOLID_P1 =
{
  kind = "solid"
  shape = "P"
  environment = "indoor"
  prob = 130
  
  structure =
  {
    "..."
    ".#."
    "..."
  }

  x_sizes = { "212", "313" }
  y_sizes = { "111", "212" }

  symmetry = "xy"

  solid_feature = true
}

SOLID_P2 =
{
  kind = "solid"
  shape = "P"
  environment = "indoor"
  prob = 70
  
  structure =
  {
    "....."
    ".#.#."
    "....."
  }

  x_sizes = { "11211", "21112", "21212" }
  y_sizes = { "111", "212" }

  symmetry = "xy"

  solid_feature = true
}

SOLID_P3 =
{
  kind = "solid"
  shape = "P"
  environment = "indoor"
  prob = 50
 
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

  symmetry = "xy"

  solid_feature = true
}

SOLID_C1 =
{
  kind = "solid"
  environment = "indoor"
  prob = 100
  
  structure =
  {
    "#.#"
    "..."
    "#.#"
  }

  x_sizes = { "121", "131", "141", "151", "222", }
  y_sizes = { "111", "121", "131" }

  symmetry = "xy"

  solid_feature = true
}

DIAG_C1 =
{
  kind = "solid"
  shape = "O"
  environment = "indoor"
  prob = 500
  
  structure =
  {
    "/#.#%"
    "....."
    "%#.#/"
  }

  x_sizes = { "11101", "11201", "11301", "11401"
              "12201", "12301", "12111" }

  y_sizes = { "111", "121", "131" }

  symmetry = "y"
}

DIAG_C2 =
{
  kind = "solid"
  environment = "indoor"
  prob = 600
  
  structure =
  {
    "#/.%#"
    "....."
    "#%./#"
  }

  x_sizes = { "01110", "01210", "01310", "01410"
              "11111", "11211", "11311",  }

  y_sizes = { "111", "121", "131" }

  symmetry = "xy"
}

DIAG_C3 =
{
  kind = "solid"
  environment = "indoor"
  prob = 500
  
  structure =
  {
    "/#.#%"
    "....."
    "%#..."
  }

  x_sizes = { "10101", "10201"
              "11101", "11201", "11301", "11401"
              "12201", "12301", "12111" }

  y_sizes = { "111", "121", "131" }
}

SOLID_C3 =
{
  kind = "solid"
  environment = "indoor"
  prob = 200
  
  structure =
  {
    "#.#.#"
    "....."
    "#.#.#"
  }

  x_sizes = { "11111", "11211", "12121" }
  y_sizes = { "111", "121", "131" }

  symmetry = "xy"

  solid_feature = true
}


SOLID_T1 =
{
  kind = "solid"
  shape = "T"
  environment = "indoor"
  prob = 50
  
  structure =
  {
    "#.#"
    "..."
  }

  x_sizes = { "121", "131", "141" }
  y_sizes = { "21", "31", "41" }

  symmetry = "x"

  solid_feature = true
}

DIAG_T1 =
{
  kind = "solid"
  shape = "T"
  environment = "indoor"
  prob = 80
 
  structure =
  {
    "/.%"
    "..."
  }

  x_sizes = { "111", "121", "131", "141" }
  y_sizes = { "11", "21", "31", "41" }

  symmetry = "x"
}

SOLID_OPP1 =
{
  kind = "solid"
  environment = "indoor"
  prob = 100
  
  structure =
  {
    "..#"
    "..."
    "#.."
  }

  x_sizes = { "111", "121", "131" }
  y_sizes = { "101", "111", "121", "131" }

  solid_feature = true
}

DIAG_OPP1 =
{
  kind = "solid"
  environment = "indoor"
  prob = 300
 
  structure =
  {
    "..%"
    "..."
    "%.."
  }

  x_sizes = { "111", "121", "131" }
  y_sizes = { "101", "111", "121", "131" }
}

SOLID_L1 =
{
  kind = "solid"
  shape = "L"
  environment = "indoor"
  prob = 2000
  
  structure =
  {
    ".#"
    ".."
  }

  x_sizes = { "22", "32" }
  y_sizes = { "22", "32" }
}

DIAG_L1 =
{
  kind = "solid"
  shape = "L"
  environment = "indoor"
  prob = 600
  
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
  kind = "solid"
  shape = "L"
  environment = "indoor"
  prob = 300
  
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

DIAG_X_HMMM =
{
  kind = "solid"
  shape = "X"
  environment = "indoor"
  prob = 300

  structure =
  {
    ".%#/."
    "%.../"
    "#...#"
    "/...%"
    "./#%."
  }

  x_sizes = { "11011", "11111", "11211" }
  y_sizes = { "11011", "11111", "11211" }

  symmetry = "xy"
}


DIAG_HT_BIG =
{
  environment = "indoor"
  prob = 5
 
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

  subs =
  {
    { height=1, match="one" }
  }

  symmetry = "x"
}



-----------------
--   LIQUIDS   --
-----------------

LIQUID_I =
{
  kind = "liquid"
  prob = 50

  structure =
  {
    "~.~"
  }

  x_sizes = { "111", "212", "313", "323" }

  y_sizes = { "1", "2", "3", "4", "5", "6", "7"
              "8", "9", "A" }

  symmetry = "xy"
}

LIQUID_L1 =
{
  kind = "liquid"
  shape = "L"
  prob = 20

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
  kind = "liquid"
  shape = "L"
  prob = 190

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
  kind = "liquid"
  shape = "L"
  environment = "indoor"
  prob = 555

  structure =
  {
    "1~%"
    "1~~"
    "L.."
  }

  x_sizes = { "111", "121", "131" }
  y_sizes = { "111", "121", "131" }

  subs =
  {
    { height=1, match="any" }
  }
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
  kind = "liquid"
  shape = "O"
  prob = 90

  structure =
  {
    "..."
    ".~."
    "..."
  }

  x_sizes = { "121", "131", "222", "141" }
  y_sizes = { "131", "141" }

  symmetry = "xy"
}

LIQUID_O2 =
{
  kind = "liquid"
  shape = "O"
  environment = "indoor"
  prob = 300

  structure =
  {
    "/...%"
    "./~%."
    ".~~~."
    ".%~/."
    "%.../"
  }

  x_sizes = { "11111", "11211", "11311" }
  y_sizes = { "11011", "11111", "11211", "11311" }

  symmetry = "xy"
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
    ".%~/."
    "....."
  }

  x_sizes = { "11111", "11211", "11311", "21212" }
}

LIQUID_O4 =
{
  kind = "liquid"
  shape = "O"
  prob = 500

  structure =
  {
    "~~~~.~~~~"
    "~/.....%~"
    "~./~~~%.~"
    "~.~~~~~.~"
    "..~~~~~.."
    "~.~~~~~.~"
    "~.%~~~/.~"
    "~%...../~"
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

  symmetry = "xy"
}


LIQUID_U1 =
{
  kind = "liquid"
  shape = "U"
  prob = 30

  structure =
  {
    ".~."
    "..."
  }

  x_sizes = { "121", "131", "141" }
  y_sizes = { "12", "13", "14" }

  symmetry = "x"
}

LIQUID_U2 =
{
  kind = "liquid"
  shape = "U"
  prob = 300

  structure =
  {
    "1~1"
    "L.J"
  }

  x_sizes = { "111", "121", "131", "141" }
  y_sizes = { "12",  "13", "14" }

  symmetry = "x"

  subs =
  {
    { height=1, match="one" }
  }
}

LIQUID_U3 =
{
  kind = "liquid"
  shape = "U"
  prob = 300

  structure =
  {
    ".~2"
    "L1J"
  }

  x_sizes = { "121", "131", "141" }
  y_sizes = { "11", "12",  "13", "14" }

  subs =
  {
    { height=1, match="any" }
    { height=2, match="one" }
  }
}

LIQUID_U4 =
{
  kind = "liquid"
  shape = "U"
  environment = "indoor"
  prob = 200

  structure =
  {
    "./~%."
    ".~~~."
    ".%~/."
    "%.../"
  }

  x_sizes = { "11111", "11211", "11311" }
  y_sizes = { "1101", "1111", "1121", "1131" }

  symmetry = "x"
}

LIQUID_U4_OUT =
{
  copy = "LIQUID_U4"

  environment = "outdoor"

  structure =
  {
    "./~%."
    ".~~~."
    ".%~/."
    "....."
  }
}

LIQUID_E =
{
  kind = "liquid"
  shape = "E"
  prob = 110

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

  symmetry = "y"
}

LIQUID_E2 =
{
  kind = "liquid"
  shape = "E"
  prob = 200

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

  symmetry = "y"

  subs =
  {
    { height=1, match="any" }
  }
}

LIQUID_E3 =
{
  kind = "liquid"
  shape = "E"
  prob = 999

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

  subs =
  {
    { height=1, match="any" }
    { height=2, match="one" }
  }
}

LIQUID_E4 =
{
  kind = "liquid"
  shape = "E"
  prob = 999

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

  subs =
  {
    { height=1, match="any" }
  }
}

LIQUID_S1 =
{
  kind = "liquid"
  shape = "S"
  prob = 120

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
  kind = "liquid"
  shape = "S"
  prob = 200

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

  subs =
  {
    { height=1, match="any" }
  }
}

LIQUID_BIG_S1 =
{
  kind = "liquid"
  shape = "S"
  prob = 50

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
  kind = "liquid"
  shape = "S"
  prob = 999

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

  subs =
  {
    { height=1, match="any" }
    { height=2, match="one" }
  }
}

LIQUID_BIG_S4 =
{
  kind = "liquid"
  shape = "S"
  prob = 699

  structure =
  {
    ".~11T"
    ".~1~2"
    "L11~2"
  }

  x_sizes = { "11111", "12111", "11121"
              "12121", "13121", "12131", "13131" }

  y_sizes = { "111", "121", "131", "141" }

  subs =
  {
    { height=1, match="any" }
    { height=2, match="one" }
  }
}

LIQUID_CROSS_1 =
{
  kind = "liquid"
  shape = "X"
  prob = 300

  structure =
  {
    "~.~"
    "..."
    "~.~"
  }

  x_sizes = { "111", "212", "313", "323", "414" }
  y_sizes = { "212", "222", "313" }

  symmetry = "xy"
}

LIQUID_CROSS_2 =
{
  kind = "liquid"
  shape = "X"
  environment = "indoor"
  prob = 300

  structure =
  {
    "/~~.~~%"
    "~~~.~~~"
    "~~/.%~~"
    "......."
    "~~%./~~"
    "~~~.~~~"
    "%~~.~~/"
  }

  x_sizes =
  {
    "1011101"
    "1111111", "1112111"
    "1211121", "1212121"
    "1311131"
  }

  y_sizes =
  {
    "1011101"
    "1111111", "1112111"
    "1211121", "1212121"
    "1311131"
  }

  symmetry = "xy"
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
    "~~%./~~"
    "~~~.~~~"
    "~~~.~~~"
  }
}


LIQUID_T1 =
{
  kind = "liquid"
  shape = "T"
  prob = 250

  structure =
  {
    "..."
    "~.~"
  }

  x_sizes = { "212", "222", "313" }
  y_sizes = { "21", "31", "32", "41", "42" }

  symmetry = "x"
}

LIQUID_T_NICE =
{
  kind = "liquid"
  shape = "T"
  prob = 591

  structure =
  {
    "....."
    "~%./~"
    "~~.~~"
  }

  x_sizes = { "11111", "11211", "21112", "21212"  }
  y_sizes = { "211", "311", "312", "411", "412" }

  symmetry = "x"
}


LIQUID_H1 =
{
  kind = "liquid"
  prob = 221

  structure =
  {
    ".~."
    "..."
    ".~."
  }

  x_sizes = { "121", "131", "141", "222" }
  y_sizes = { "111", "212", "313" }

  symmetry = "xy"
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

  subs =
  {
    { height=1, match="any" }
  }
}

HEIGHT_I2 =
{
  prob = 200

  structure =
  {
    "111"
    "^.^"
    "..."
  }

  x_sizes = { "101", "111", "121", }
  y_sizes = { "012", "111", "112", "212" }

  subs =
  {
    { height=1, match="any" }
  }

  symmetry = "x"
}

HEIGHT_I3 =
{
  environment = "indoor"
  prob = 500

  structure =
  {
    "/111%"
    "11111"
    "Z.^.N"
    "....."
  }

  x_sizes = { "10101", "11111", "12121" }
  y_sizes = { "1111", "1121" }

  subs =
  {
    { height=1, match="any" }
  }

  symmetry = "x"
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

HEIGHT_SOLID_I4 =
{
  environment = "indoor"
  prob = 2000

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

  subs =
  {
    { height=1, match="any" }
  }

  symmetry = "x"
}

HEIGHT_SOLID_I5 =
{
  environment = "indoor"
  prob = 5000

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

  subs =
  {
    { height=1, match="any" }
    { height=2, match="any" }
  }

  symmetry = "x"
}

HEIGHT_C5 =
{
  prob = 10000

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

  subs =
  {
    { height=1, match="any" }
  }
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

  subs =
  {
    { height=1, match="any" }
  }
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

  subs =
  {
    { height=1, match="any" }
  }
}

HEIGHT_CURV_1 =
{
  kind = "solid"
  shape = "O"
  prob = 999

  structure =
  {
    "F.T"
    "111"
    "L.J"
  }

  x_sizes = { "121", "131", "141" }
  y_sizes = { "121", "131", "141" }

  subs =
  {
    { height=1, match="any" }
  }
}

HEIGHT_CURV_2 =
{
  kind = "solid"
  shape = "O"
  level = "top"
  prob = 3000,  -- very rarely occurs

  structure =
  {
    "F2T"
    "121"
    "1.1"
    "L.J"
  }

  x_sizes = { "121", "131", "141", "151", }
  y_sizes = { "1201", "1211", "1301", "1311" }

  subs =
  {
    { height=1, match="any" }
    { height=2, match="one" }
  }
}


--------------------------
--  RECURSIVE PATTERNS  --
--------------------------

SOLID_CSUB =
{
  kind = "solid"
  environment = "indoor"
  prob = 200
  
  structure =
  {
    "#..v..#"
    "..111.."
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

  solid_feature = true

  subs =
  {
    { height=1, match="any", recurse=1 }
  }
}

SOLID_CSUB4 =
{
  kind = "solid"
  environment = "indoor"
  prob = 300
  
  structure =
  {
    "#.v.#"
    ".111."
    ">111<"
    ".111."
    "#.^.#"
  }

  y_sizes = { "11111", "12121", "12221"
              "13131", "13231", "14141", "14241" }

  x_sizes = { "11111", "12121", "12221"
              "13131", "13231", "14141", "14241" }

  symmetry = "xy"

  solid_feature = true

  subs =
  {
    { height=1, match="any", recurse=1 }
  }
}

SOLID_REC_C1 =
{
  kind = "solid"
  environment = "indoor"
  prob = 500
  
  structure =
  {
    "#1#"
    ".1."
    ">1<"
    ".1."
    "#1#"
  }

  x_sizes = { "121", "131", "141", "151", "161"
              "171", "181", "191", "1A1", "1B1" }

  y_sizes = { "11111", "11211", "12121", "12221"
              "13131", "13231", "14141", "14241"
              "24142" }

  symmetry = "xy"

  solid_feature = true

  subs =
  {
    { height=0, match="any", recurse=1 }
  }
}

SOLID_REC_C2 =
{
  kind = "solid"
  environment = "indoor"
  prob = 900
  
  structure =
  {
    "#1#"
    ".1<"
    ".1."
    ">1."
    "#1#"
  }

  x_sizes = { "121", "131", "141", "151", "161"
              "171", "181", "191", "1A1", "1B1" }

  y_sizes = { "11011", "11111", "11211", "11311"
              "11411", "11511", "11611", "11711"
              "21512", "21612", "21712" }

  solid_feature = true

  subs =
  {
    { height=0, match="any", recurse=1 }
  }
}

SOLID_REC_C3 =
{
  kind = "solid"
  environment = "indoor"
  prob = 900
  
  structure =
  {
    "#1#"
    ">1<"
    ".1."
    ">1<"
    "#1#"
  }

  x_sizes = { "121", "131", "141", "151", "161"
              "171", "181", "191", "1A1", "1B1" }

  y_sizes = { "11111", "11211", "11311", "11411", "11511"
              "11611", "11711", "11811", "11911" }

  symmetry = "xy"

  solid_feature = true

  subs =
  {
    { height=0, match="any", recurse=1 }
  }
}

SOLID_REC_C4 =
{
  kind = "solid"
  environment = "indoor"
  prob = 900
  
  structure =
  {
    "#1#"
    ".1<"
    ".1."
    ">1."
    "#1#"
  }

  x_sizes = { "121", "131", "141", "151", "161"
              "171", "181", "191", "1A1", "1B1" }

  y_sizes = { "11011", "11111", "11211", "11311"
              "11411", "11511", "11611", "11711"
              "21512", "21612", "21712" }

  solid_feature = true

  subs =
  {
    { height=0, match="any", recurse=1 }
  }
}

SOLID_REC_HT_C1 =
{
  copy = "SOLID_REC_C1"
  prob = 950
  
  subs =
  {
    { height=1, match="any", recurse=1 }
  }
}

SOLID_REC_HT_C2 =
{
  copy = "SOLID_REC_C2"
  prob = 950
  
  subs =
  {
    { height=1, match="any", recurse=1 }
  }
}

SOLID_REC_HT_C3 =
{
  copy = "SOLID_REC_C3"
  prob = 950
  
  subs =
  {
    { height=1, match="any", recurse=1 }
  }
}

SOLID_REC_HT_C4 =
{
  copy = "SOLID_REC_C4"
  prob = 950
  
  subs =
  {
    { height=1, match="any", recurse=1 }
  }
}

DIAG_REC_C1 =
{
  kind = "solid"
  environment = "indoor"
  prob = 900
  
  structure =
  {
    "/1%"
    ".1."
    ">1<"
    ".1."
    "%1/"
  }

  x_sizes = { "121", "131", "141", "151", "161"
              "171", "181", "191", "1A1", "1B1" }

  y_sizes = { "11111", "12121", "13131", "14141", "15151"
              "13231", "14241" }

  symmetry = "xy"

  subs =
  {
    { height=0, match="any", recurse=1 }
  }
}

DIAG_REC_C3 =
{
  kind = "solid"
  environment = "indoor"
  prob = 900
  
  structure =
  {
    "/1%"
    ">1<"
    ".1."
    ">1<"
    "%1/"
  }

  x_sizes = { "121", "131", "141", "151", "161"
              "171", "181", "191", "1A1", "1B1" }

  y_sizes = { "11111", "11211", "11311", "11411", "11511"
              "11611", "11711", "11811", "11911" }

  symmetry = "xy"

  subs =
  {
    { height=0, match="any", recurse=1 }
  }
}

DIAG_REC_C4 =
{
  kind = "solid"
  environment = "indoor"
  prob = 900
  
  structure =
  {
    "/1%"
    ".1<"
    ".1."
    ">1."
    "%1/"
  }

  x_sizes = { "121", "131", "141", "151", "161"
              "171", "181", "191", "1A1", "1B1" }

  y_sizes = { "11011", "11111", "11211", "11311"
              "11411", "11511", "11611", "11711" }

  subs =
  {
    { height=0, match="any", recurse=1 }
  }
}

DIAG_REC_HT_C1 =
{
  copy = "DIAG_REC_C1"
  prob = 950
  
  subs =
  {
    { height=1, match="any", recurse=1 }
  }
}

DIAG_REC_HT_C3 =
{
  copy = "DIAG_REC_C3"
  prob = 950
  
  subs =
  {
    { height=1, match="any", recurse=1 }
  }
}

DIAG_REC_HT_C4 =
{
  copy = "DIAG_REC_C4"
  prob = 950
  
  subs =
  {
    { height=1, match="any", recurse=1 }
  }
}


RECURSE_I1 =
{
  prob = 400

  structure =
  {
    "111"
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

  subs =
  {
    { height=1, match="one", recurse=1 }
  }

  symmetry = "x"
}

RECURSE_I2 =
{
  prob = 300

  structure =
  {
    "111"
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

  subs =
  {
    { height=1, match="one", recurse=1 }
  }
}

RECURSE_I3 =
{
  environment = "indoor"
  prob = 300

  structure =
  {
    "1111111"
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

  symmetry = "x"

  subs =
  {
    { height=1, match="one", recurse=1 }
  }
}

RECURSE_I3_OUT =
{
  copy = "RECURSE_I3"

  environment = "outdoor"

  structure =
  {
    "1111111"
    "..^.^.."
    "......."
  }
}


RECURSE_T_SOLID =
{
  kind = "solid"
  shape = "T"
  environment = "indoor"
  prob = 999
  
  structure =
  {
    "#..v..#"
    ".11111."
    ">11111<"
    ".11111."
    ".Z###N."
  }

  x_sizes = { "1101011", "1111111", "1112111"
              "1121211", "1122211", "1131311"
              "1132311", "1141411" }

  y_sizes = { "10111", "11101", "11111"
              "12101", "10121", "11121", "12111", "12121"
              "13111", "11131", "12131", "13131", "13231"
              "14111", "11141", "14141", "14241" }

  symmetry = "x"

  subs =
  {
    { height=1, match="any", recurse=1 }
  }
}


RECURSE_L1 =
{
  shape = "L"
  prob = 500

  structure =
  {
    ".111"
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

  subs =
  {
    { height=1, match="one", recurse=1 }
  }
}

RECURSE_L2 =
{
  shape = "L"
  prob = 95

  structure =
  {
    ".>11"
    "..11"
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

  subs =
  {
    { height=1, match="one", recurse=1 }
  }
}

RECURSE_L2_DIAG =
{
  shape = "L"
  environment = "indoor"
  prob = 800,  -- rarely occurs

  structure =
  {
    ".>11"
    "..11"
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

  subs =
  {
    { height=1, match="any", recurse=1 }
  }
}

RECURSE_L3_DIAG =
{
  shape = "L"
  environment = "indoor"
  prob = 999

  structure =
  {
    "/...%"
    ".v..."
    "111.."
    "111<."
    "111./"
  }

  x_sizes = { "11011", "11111", "11211", "11311", "11411"
              "11511", "11611", "11711", "11811", "11911" }

  y_sizes = { "11011", "11111", "11211", "11311", "11411"
              "11511", "11611", "11711", "11811", "11911" }

  subs =
  {
    { height=1, match="any", recurse=1 }
  }
}



RECURSE_U1 =
{
  shape = "U"
  prob = 85

  structure =
  {
    ".111."
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

  subs =
  {
    { height=1, match="one", recurse=1 }
  }
}

RECURSE_U2 =
{
  shape = "U"
  prob = 85

  structure =
  {
    "..1.."
    ".>1<."
    "..1.."
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

  symmetry = "x"

  subs =
  {
    { height=1, match="one", recurse=1 }
  }
}


RECURSE_O1_DIAG =
{
  shape = "O"
  environment = "indoor"
  prob = 30

  structure =
  {
    "/...%"
    "....."
    ".111."
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

  subs =
  {
    { height=1, match="any", recurse=1 }
  }

  symmetry = "x"
}


RECURSE_O3_DIAG =
{
  shape = "O"
  environment = "indoor"
  prob = 20

  structure =
  {
    "/...%"
    "...v."
    ".111."
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

  subs =
  {
    { height=1, match="any", recurse=1 }
  }
}


RECURSE_T1 =
{
  shape = "T"
  prob = 950

  structure =
  {
    "111.222"
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

  subs =
  {
    { height=1, match="one", recurse=1 }
    { height=1, match="any", sym_fill=1 }
  }

  symmetry = "x"
}

RECURSE_T1_DIAG =
{
  shape = "T"
  prob = 650

  structure =
  {
    "111.222"
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

  subs =
  {
    { height=1, match="one", recurse=1 }
    { height=1, match="any", sym_fill=1 }
  }

  symmetry = "x"
}

RECURSE_T1_NOSYM =
{
  shape = "T"
  prob = 350

  structure =
  {
    "111.222"
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

  subs =
  {
    { height=1, match="one", recurse=1 }
    { height=1, match="one", recurse=1 }
  }
}

RECURSE_T3 =
{
  shape = "T"
  prob = 599

  structure =
  {
    "1...2"
    "1<.>2"
    "1...2"
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

  symmetry = "x"

  solid_feature = true

  subs =
  {
    { height=1, match="one", recurse=1 }
    { height=1, match="any", sym_fill=1 }
  }
}

RECURSE_T3_NOSYM =
{
  shape = "T"
  prob = 1000

  structure =
  {
    "1<..2"
    "1...2"
    "1..>2"
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

  solid_feature = true

  subs =
  {
    { height=1, match="one", recurse=1 }
    { height=1, match="one", recurse=1 }
  }
}


RECURSE_H1 =
{
  shape = "H"
  prob = 200

  structure =
  {
    "....."
    "...v."
    "11.22"
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

  subs =
  {
    { height=1, match="one", recurse=1 }
    { height=1, match="any", recurse=1 }
  }
}

RECURSE_H2 =
{
  shape = "H"
  prob = 900

  structure =
  {
    "......."
    "......."
    "111.222"
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

  symmetry = "x"

  subs =
  {
    { height=1, match="one", recurse=1 }
    { height=1, match="any", sym_fill=1 }
  }
}

RECURSE_H3 =
{
  shape = "H"
  prob = 1500,  -- rarely usable

  structure =
  {
    "....."
    "1...2"
    "1<.>2"
    "1...2"
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

  subs =
  {
    { height=1, match="one", recurse=1 }
    { height=1, match="any", recurse=1 }
  }
}


RECURSE_S1 =
{
  shape = "S"
  prob = 300

  structure =
  {
    "111...."
    "111..v."
    "111.222"
    ".^..222"
    "....222"
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

  subs =
  {
    { height=1, match="any", recurse=1 }
    { height=1, match="any", recurse=1 }
  }
}

RECURSE_S2 =
{
  shape = "S"
  prob = 930

  structure =
  {
    "1.."
    "1<."
    "1.."
    "1.2"
    "..2"
    ".>2"
    "..2"
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

  subs =
  {
    { height=1, match="any", recurse=1 }
    { height=1, match="any", recurse=1 }
  }
}


RECURSE_WOW_LIQUID_O2 =
{
  kind = "liquid"
  shape = "O"
  prob = 900

  structure =
  {
    "~~~.~~~"
    "~..v..~"
    "~.111.~"
    "~.111.~"
    "~.111.~"
    "~..^..~"
    "~~~.~~~"
  }

  x_sizes = { "1111111", "1121211", "1131311", "1141411"
              "2111112", "2121212", "2131312" }

  y_sizes = { "1110111", "1111111", "1121211", "1131311", "1141411"
              "2111112", "2121212", "2131312" }

  symmetry = "xy"

  subs =
  {
    { height=1, match="any", recurse=1 }
  }
}

RECURSE_WOW_LIQUID_O4 =
{
  kind = "liquid"
  shape = "O"
  prob = 600

  structure =
  {
    "~~~.~~~"
    "~..v..~"
    "~.111.~"
    ".>111<."
    "~.111.~"
    "~..^..~"
    "~~~.~~~"
  }

  x_sizes = { "1111111", "1121211", "1131311", "1141411"
              "2111112", "2121212", "2131312" }

  y_sizes = { "1111111", "1121211", "1131311", "1141411"
              "2111112", "2121212", "2131312" }

  symmetry = "xy"

  subs =
  {
    { height=1, match="any", recurse=1 }
  }
}


} -- end of ROOM_PATTERNS

