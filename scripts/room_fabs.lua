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

ROOM_ELEMENTS =
{
  B = { kind="building" },
  H = { kind="hall" },
  C = { kind="cave" },

  S = { kind="sub" },

  g = { kind="ground" },
  w = { kind="liquid" },
}


----------------------------------------------------------------

ROOM_FABS =
{

BUILDING_TINY_A1 =
{
  prob = 10,

  structure =
  {
    "BB",
    "BB",
  },

  entry_x = 1,

  connections =
  {
    { x=2, y=2, dir=8, optional=true },
  }
},

BUILDING_TINY_A2 =
{
  copy = "BUILDING_TINY_A1",

  entry_x = 2,

  connections =
  {
    { x=1, y=2, dir=8, optional=true },
  }
},

BUILDING_TINY_B1 =
{
  prob = 15,

  structure =
  {
    "BB",
    "BB",
  },

  entry_x = 1,

  connections =
  {
    { x=2, y=2, dir=6 },
  }
},

BUILDING_TINY_B2 =
{
  copy = "BUILDING_TINY_B1",

  entry_x = 2,

  connections =
  {
    { x=2, y=2, dir=6 },
  }
},

BUILDING_TINY_C1 =
{
  prob = 2,

  structure =
  {
    "BB",
    "BB",
  },

  entry_x = 1,

  connections =
  {
    { x=2, y=1, dir=6 },
    { x=1, y=2, dir=4 },
    { x=2, y=2, dir=8 },
  }
},

BUILDING_TINY_C2 =
{
  copy = "BUILDING_TINY_C1",

  entry_x = 2,

  connections =
  {
    { x=1, y=1, dir=4 },
    { x=2, y=2, dir=6 },
    { x=1, y=2, dir=8 },
  }
},


--->

BUILDING_SMALL_A =
{
  prob = 60,

  structure =
  {
    "BBB",
    "BBB",
  },

  sizes =
  {
    { w=3, h=2, prob=90 },
    { w=5, h=2, prob=20 },
  }

  x_grow = { 2 },
  y_grow = { 2 },

  connections =
  {
    { x=2, y=2, dir=8, optional=true },
  }
},

BUILDING_SMALL_B =
{
  copy = "BUILDING_SMALL_A",

  connections =
  {
    { x=1, y=2, dir=8 },
    { x=3, y=2, dir=8 },
  }
},

BUILDING_SMALL_C =
{
  copy = "BUILDING_SMALL_A",
  prob = 20,

  connections =
  {
    { x=1, y=2, dir=4 },
    { x=3, y=2, dir=6 },
    { x=2, y=2, dir=8, optional=true },
  }
},

BUILDING_SMALL_D =
{
  copy = "BUILDING_SMALL_A",
  prob = 10,

  connections =
  {
    { x=1, y=1, dir=4 },
    { x=3, y=1, dir=6 },
    { x=2, y=2, dir=8, optional=true },
  }
},


--->

BUILDING_MEDIUM_A =
{
  prob = 60,

  structure =
  {
    "BBB",
    "BBB",
    "BBB",
  },

  sizes =
  {
    { w=3, h=3, prob=90 },
    { w=3, h=4, prob=10 },
  }

  y_grow = { 2 },

  connections =
  {
    { x=2, y=2, dir=8, optional=true },
  }
},

BUILDING_MEDIUM_B =
{
  copy = "BUILDING_MEDIUM_A",
  prob = 20,

  connections =
  {
    { x=1, y=3, dir=8 },
    { x=3, y=3, dir=8 },
  }
},

BUILDING_MEDIUM_C =
{
  copy = "BUILDING_MEDIUM_A",

  connections =
  {
    { x=1, y=2, dir=4 },
    { x=3, y=2, dir=6 },
  }
},

BUILDING_MEDIUM_D =
{
  copy = "BUILDING_MEDIUM_A",
  prob = 10,

  connections =
  {
    { x=1, y=2, dir=4 },
    { x=3, y=2, dir=6 },
    { x=3, y=3, dir=8 },
  }
},

BUILDING_MEDIUM_E =
{
  copy = "BUILDING_MEDIUM_A",

  connections =
  {
    { x=1, y=3, dir=4 },
    { x=3, y=3, dir=6 },
  }
},



--->

BUILDING_LARGE_A =
{
  prob = 40,

  structure =
  {
    "BBBBB",
    "BBBBB",
    "BBBBB",
  },

  sizes =
  {
    { w=5, h=3, prob=90 },
    { w=5, h=4, prob=10 },
    { w=5, h=5, prob=40 },

    { w=7, h=3, prob=10 },
    { w=7, h=5, prob=40 },
    { w=7, h=7, prob=10 },

    { w=9, h=3, prob= 1 },
    { w=9, h=5, prob= 3 },
  },

  x_grow = { 2, 4 },
  y_grow = { 2 },

  connections =
  {
    { x=3, y=3, dir=8 },
    { x=1, y=2, dir=4 },
    { x=5, y=2, dir=6 },
  }
},

BUILDING_LARGE_B =
{
  copy = "BUILDING_LARGE_A",

  connections =
  {
    { x=1, y=3, dir=8 },
    { x=5, y=3, dir=8 },
  }
},

BUILDING_LARGE_C =
{
  copy = "BUILDING_LARGE_A",

  connections =
  {
    { x=1, y=3, dir=8 },
    { x=3, y=3, dir=8 },
    { x=5, y=3, dir=8 },
  }
},

BUILDING_LARGE_D =
{
  copy = "BUILDING_LARGE_A",
  prob = 20,

  connections =
  {
    { x=2, y=3, dir=8 },
    { x=4, y=3, dir=8 },
    { x=1, y=2, dir=4 },
    { x=5, y=2, dir=6 },
  }
},

BUILDING_LARGE_E =
{
  copy = "BUILDING_LARGE_A",

  connections =
  {
    { x=1, y=3, dir=4 },
    { x=5, y=3, dir=6 },
    { x=3, y=3, dir=8, optional=true },
  }
},


----------------------------------------------------------------

HALL_TINY =
{
  prob = 10,

  structure = { "H" },

  connections =
  {
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

GROUND_SURROUND =
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

LIQUID_SURROUND =
{
  basic_kind = "liquid",
  prob = 10,

  structure =
  {
    "www",
    "wSw",
    "wgw",
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

function expand_room_fabs(list)

  name_it_up(list)

  expand_copies(list)

  name_it_up(list)

  for _,F in pairs(list) do
    if F.elements then
      expand_copies(F.elements)
    else
      F.elements = ROOM_ELEMENTS
    end

    if not F.sizes then
      F.sizes =
      {
        { w = #F.structure[1], h = #F.structure, prob = 50 }
      }
    end

    if not F.kind then
      if string.match(F.name, "^BUILDING") then
        F.kind = "building"
      elseif string.match(F.name, "^HALL") then
        F.kind = "hall"
      elseif string.match(F.name, "^GROUND") then
        F.kind = "ground"
      elseif string.match(F.name, "^LIQUID") then
        F.kind = "liquid"
      elseif string.match(F.name, "^CAVE") then
        F.kind = "cave"
      else
        F.kind = "mixed"
      end
    end

    if not F.entry_x then
      F.entry_x = 1 + int(F.sizes[1].w / 2)
    end
  end
end

