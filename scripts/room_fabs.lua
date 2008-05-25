----------------------------------------------------------------
--  ROOM FABS II
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2008 Andrew Apted
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

ROOM_FABS =
{


BUILDING_TINY =
{
  kind = "building",
  prob = 20,

  structure =
  {
    "BB",
    "BB",
  },

  elements =
  {
    B = { kind="building" },
  },

  connections =
  {
    { x=1, y=1, dir=2 },
    { x=2, y=2, dir=8, prob=50 },
  }
},

BUILDING_TINY_B =
{
  copy = "BUILDING_TINY",

  connections =
  {
    { x=1, y=1, dir=2 },
    { x=2, y=2, dir=6 },
  }
},

BUILDING_TINY_4_WAY =
{
  copy = "BUILDING_TINY",
  prob = 1,

  connections =
  {
    { x=1, y=1, dir=2 },
    { x=2, y=1, dir=6 },
    { x=1, y=2, dir=4 },
    { x=2, y=2, dir=8 },
  }
},


BUILDING_SMALL =
{
  kind = "building",
  prob = 50,

  structure =
  {
    "BBB",
    "BBB",
  },

  x_size = { 3, 5 },
  y_size = { 2, 3 },

  x_grow = { 2 },
  y_grow = { 2 },

  elements =
  {
    B = { kind="building" },
  },

  connections =
  {
    { x=2, y=1, dir=2 },
    { x=2, y=2, dir=8, prob=50 },
  }
},

BUILDING_SMALL_B =
{
  copy = "BUILDING_SMALL",

  connections =
  {
    { x=2, y=1, dir=2 },
    { x=1, y=2, dir=8 },
    { x=3, y=2, dir=8 },
  }
},

BUILDING_SMALL_C =
{
  copy = "BUILDING_SMALL",
  prob = 20,

  connections =
  {
    { x=2, y=1, dir=2 },
    { x=1, y=1, dir=4 },
    { x=3, y=1, dir=6 },
    { x=2, y=2, dir=8, prob=50 },
  }
},

BUILDING_SMALL_D =
{
  copy = "BUILDING_SMALL",
  prob = 20,

  connections =
  {
    { x=2, y=1, dir=2 },
    { x=1, y=2, dir=4 },
    { x=3, y=2, dir=6 },
    { x=2, y=2, dir=8, prob=50 },
  }
},


BUILDING_LARGE =
{
  kind = "building",
  prob = 33,

  structure =
  {
    "BBBBB",
    "BBBBB",
    "BBBBB",
  },

  x_size = { 5, 7, 9 },
  y_size = { 3, 5 },

  x_grow = { 2, 4 },
  y_grow = { 2 },

  elements =
  {
    B = { kind="building" },
  },

  connections =
  {
    { x=3, y=1, dir=2 },
    { x=3, y=3, dir=8 },
    { x=1, y=2, dir=4 },
    { x=5, y=2, dir=6 },
  }
},

BUILDING_LARGE_B =
{
  copy = "BUILDING_LARGE",

  connections =
  {
    { x=3, y=1, dir=2 },
    { x=1, y=3, dir=8 },
    { x=5, y=3, dir=8 },
  }
},

BUILDING_LARGE_C =
{
  copy = "BUILDING_LARGE",

  connections =
  {
    { x=3, y=1, dir=2 },
    { x=1, y=3, dir=8 },
    { x=3, y=3, dir=8 },
    { x=5, y=3, dir=8 },
  }
},

BUILDING_LARGE_D =
{
  copy = "BUILDING_LARGE",

  connections =
  {
    { x=3, y=1, dir=2 },
    { x=2, y=3, dir=8 },
    { x=4, y=3, dir=8 },
    { x=1, y=2, dir=4 },
    { x=5, y=2, dir=6 },
  }
},

BUILDING_LARGE_E =
{
  copy = "BUILDING_LARGE",

  connections =
  {
    { x=3, y=1, dir=2 },
    { x=3, y=3, dir=8, prob=50 },
    { x=1, y=3, dir=4 },
    { x=5, y=3, dir=6 },
  }
},


----------------------------------------------------------------

HALL_TINY =
{
  kind = "hall",
  prob = 2,

  structure =
  {
    "H",
  },

  elements =
  {
    H = { kind="hall" },
  },

  connections =
  {
    { x=1, y=1, dir=2 },
    { x=1, y=1, dir=8 },
  }
},


HALL_SHORT =
{
  kind = "hall",
  prob = 40,

  structure =
  {
    "H",
    "H",
  },

  y_size = { 2, 4 },
  y_grow = { 1, 2 },

  elements =
  {
    H = { kind="hall" },
  },

  connections =
  {
    { x=1, y=1, dir=2 },
    { x=1, y=2, dir=8 },
  }
},

HALL_SHORT_B =
{
  copy = "HALL_SHORT",

  connections =
  {
    { x=1, y=1, dir=2 },
    { x=1, y=2, dir=6 },
  }
},

HALL_HUG =
{
  kind = "hall",
  prob = 40,

  structure =
  {
    "HHH",
  },

  x_size = { 3, 6 },
  x_grow = { 2 },

  elements =
  {
    H = { kind="hall" },
  },

  connections =
  {
    { x=1, y=1, dir=2 },
    { x=3, y=1, dir=8 },
  }
},

HALL_T_SHAPE =
{
  kind = "hall",
  prob = 60,

  structure =
  {
    "HHH",
    ".H.",
  },

  x_size = { 3, 5 },
  y_size = { 2, 3, 4 },

  x_grow = { 1, 3 },
  y_grow = { 1 },

  elements =
  {
    H = { kind="hall" },
  },

  connections =
  {
    { x=2, y=1, dir=2 },
    { x=1, y=2, dir=4 },
    { x=3, y=2, dir=6 },
  }
},

HALL_CROSS =
{
  kind = "hall",
  prob = 60,

  structure =
  {
    ".H.",
    "HHH",
    ".H.",
  },

  x_size = { 3, 5, 7 },
  y_size = { 3, 5, 7 },

  x_grow = { 1, 3 },
  y_grow = { 1, 3 },

  elements =
  {
    H = { kind="hall" },
  },

  connections =
  {
    { x=2, y=1, dir=2 },
    { x=1, y=2, dir=4 },
    { x=3, y=2, dir=6 },
    { x=2, y=3, dir=8 },
  }
},


----------------------------------------------------------------

--[[

SURROUND_GROUND =
{
  kind = "ground",
  prob = 15,

  structure =
  {
    "ggg",
    "gAg",
    "ggg",
  },

  x_size = { 6, 16 },
  y_size = { 6, 16 },

  x_grow = { 1,3, 2,2,2,2 },
  y_grow = { 1,3, 2,2,2,2 },

  elements =
  {
    g = { kind="ground" },
    A = { kind="sub" },
  },

  connections =
  {
    { x=2, y=1, dir=2 }, 
    { x=2, y=1, dir=8 }, 
  }
},

SURROUND_LIQUID =
{
  basic_kind = "liquid",
  prob = 10,

  structure =
  {
    "lll",
    "lAl",
    "lgl",
  },

  x_size = { 6, 16 },
  y_size = { 6, 16 },

  x_grow = { 3,1, 2,2,2,2 },
  y_grow = { 3,1, 2,2,2,2 },

  elements =
  {
    l = { kind="liquid" },
    g = { kind="ground" },
    A = { kind="sub" },
  },

  connections =
  {
    { x=2, y=1, dir=2 }, 
    { x=2, y=1, dir=8 }, 
  }
},

--]]

} -- end of ROOM_FABS 


----------------------------------------------------------------

function expand_room_fabs()

  name_it_up(ROOM_FABS)

  expand_copies(ROOM_FABS)

  name_it_up(ROOM_FABS)

  for _,F in pairs(ROOM_FABS) do
    expand_copies(F.elements)
  
    if not F.x_size then F.x_size = { #F.structure[1] } end
    if not F.y_size then F.y_size = { #F.structure }    end
  end
end

