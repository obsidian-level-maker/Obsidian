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


ROOM_CONN_MODIFIERS =
{
  ["building/building"] = 0.7,
  ["ground/ground"]     = 4.0,
  ["liquid/liquid"]     = 3.0,

  ["cave/cave"]   = 2.5,
  ["cave/ground"] = 2.0,
  ["cave/liquid"] = 1.5,

  -- halls should mainly be between buildings
  ["hall/hall"]   = 0.1,
  ["hall/cave"]   = 0.1,
  ["hall/ground"] = 0.1,
  ["hall/liquid"] = 0.1,
}


----------------------------------------------------------------

ROOM_FABS =
{

BUILDING_TINY =
{
  prob = 10,

  structure =
  {
    "BB",
    "BB",
  },

  enter_x = 1,

  connections =
  {
    {
      prob = 50,
      exits =
      {
        { x=2, y=2, dir=8, optional=true },
      }
    },

    {
      prob = 50,
      exits =
      {
        { x=2, y=2, dir=6, optional=true },
      }
    },

    {
      prob = 5,
      exits =
      {
        { x=2, y=1, dir=6 },
        { x=1, y=2, dir=4 },
        { x=2, y=2, dir=8 },
      }
    },
  } -- connections
},


BUILDING_SMALL =
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
  },

  x_grow = { 2 },
  y_grow = { 2 },

  connections =
  {
    {
      prob = 50,
      exits =
      {
        { x=2, y=2, dir=8, optional=true },
      }
    },

    {
      prob = 35,
      exits =
      {
        { x=1, y=2, dir=8 },
        { x=3, y=2, dir=8 },
      }
    },

    {
      prob = 20,
      exits =
      {
        { x=1, y=2, dir=4 },
        { x=3, y=2, dir=6 },
        { x=2, y=2, dir=8, optional=true },
      }
    },

    {
      prob = 10,
      exits =
      {
        { x=1, y=1, dir=4 },
        { x=3, y=1, dir=6 },
        { x=2, y=2, dir=8, optional=true },
      }
    },
  } -- connections
},



BUILDING_MEDIUM =
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
  },

  y_grow = { 2 },

  connections =
  {
    {
      prob = 50,
      exits =
      {
        { x=2, y=2, dir=8, optional=true },
      }
    },

    {
      prob = 50,
      exits =
      {
        { x=1, y=2, dir=4 },
        { x=3, y=2, dir=6 },
      }
    },

    {
      prob = 10,
      exits =
      {
        { x=3, y=2, dir=6 },
      }
    },

    {
      prob = 35,
      exits =
      {
        { x=1, y=3, dir=4 },
        { x=3, y=3, dir=6 },
      }
    },

    {
      prob = 20,
      exits =
      {
        { x=1, y=3, dir=8 },
        { x=3, y=3, dir=8 },
      }
    },

    {
      prob = 10,
      exits =
      {
        { x=1, y=2, dir=4 },
        { x=3, y=2, dir=6 },
        { x=3, y=3, dir=8 },
      }
    },
  } -- connections
},


BUILDING_LARGE =
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
    { w=5, h=3, prob=150 },
    { w=5, h=4, prob=20 },
    { w=5, h=5, prob=60 },

    { w=7, h=3, prob=10 },
    { w=7, h=5, prob=40 },
    { w=7, h=7, prob=20 },

    { w=9, h=3, prob= 1 },
    { w=9, h=5, prob= 3 },
  },

  x_grow = { 2, 4 },
  y_grow = { 2 },

  connections =
  {
    {
      prob = 50,
      exits =
      {
        { x=2, y=3, dir=8 },
        { x=4, y=3, dir=8 },
      }
    },

    {
      prob = 50,
      exits =
      {
        { x=1, y=2, dir=4 },
        { x=5, y=2, dir=6 },
        { x=3, y=3, dir=8, optional=true },
      }
    },

    {
      prob = 50,
      exits =
      {
        { x=1, y=3, dir=4 },
        { x=5, y=3, dir=6 },
        { x=3, y=3, dir=8, optional=true },
      }
    },

    {
      prob = 50,
      exits =
      {
        { x=1, y=3, dir=8 },
        { x=3, y=3, dir=8 },
        { x=5, y=3, dir=8 },
      }
    },

    {
      prob = 20,
      exits =
      {
        { x=2, y=3, dir=8 },
        { x=4, y=3, dir=8 },
        { x=1, y=2, dir=4 },
        { x=5, y=2, dir=6 },
      }
    },

    {
      prob = 10,
      exits =
      {
        { x=1, y=3, dir=8 },
        { x=5, y=3, dir=8 },
        { x=1, y=1, dir=4 },
        { x=5, y=1, dir=6 },
      }
    },
  } -- connections
},


----------------------------------------------------------------

HALL_SHORT =
{
  prob = 150,

  structure = { "H" },

  connections =
  {
    {
      exits = {{ x=1, y=1, dir=8 }}
    }
  }
},


HALL_STRAIGHT =
{
  prob = 60,

  structure =
  {
    "H",
    "H",
  },

  sizes =
  {
    { w=1, h=2, prob=90 },
    { w=1, h=3, prob=66 },
    { w=1, h=4, prob=15 },
    { w=1, h=5, prob=3  },
  },

  y_grow = { 1 },

  connections =
  {
    {
      exits = {{ x=1, y=2, dir=8 }}
    }
  }
},


HALL_TURN =
{
  prob = 30,

  structure =
  {
    "H",
    "H",
  },

  sizes =
  {
    { w=1, h=2, prob=40 },
    { w=1, h=3, prob=90 },
    { w=1, h=4, prob=60 },
    { w=1, h=5, prob=5 },
  },

  y_grow = { 1 },

  connections =
  {
    {
      exits = {{ x=1, y=2, dir=6 }}
    }
  }
},


HALL_HUG =
{
  prob = 20,

  structure =
  {
    "HHH",
  },

  sizes =
  {
    { w=3, h=1, prob=30 },
    { w=4, h=1, prob=50 },
    { w=5, h=1, prob=20 },
    { w=6, h=1, prob=5  },
  },

  x_grow = { 2 },

  enter_x = 1,

  connections =
  {
    {
      exits = {{ x=3, y=1, dir=8 }}
    }
  }
},


HALL_L_SHAPE =
{
  prob = 40,

  structure =
  {
    "HH",
    "H.",
  },

  sizes =
  {
    { w=2, h=2, prob=90 },
    { w=2, h=3, prob=50 },
    { w=3, h=2, prob=50 },
    { w=3, h=3, prob=30 },

    { w=4, h=4, prob=15 },
    { w=5, h=5, prob=10 },
  },

  x_grow = { 2 },
  y_grow = { 1 },

  enter_x = 1,

  connections =
  {
    {
      exits = {{ x=2, y=2, dir=6 }}
    }
  }
},


HALL_T_SHAPE =
{
  prob = 60,

  structure =
  {
    "HHH",
    ".H.",
  },

  sizes =
  {
    { w=3, h=2, prob=20 },
    { w=3, h=3, prob=80 },
    { w=3, h=4, prob=40 },
    { w=3, h=5, prob=5  },

    { w=5, h=2, prob=5  },
    { w=5, h=3, prob=10 },
    { w=5, h=4, prob=40 },
    { w=5, h=5, prob=20 },

    { w=7, h=7, prob=1 },
  },

  x_grow = { 1, 3 },
  y_grow = { 1 },

  connections =
  {
    {
      exits =
      {
        { x=1, y=2, dir=4 },
        { x=3, y=2, dir=6 },
      }
    }
  }
},


HALL_CROSS =
{
  prob = 25,

  structure =
  {
    ".H.",
    "HHH",
    ".H.",
  },

  sizes =
  {
    { w=3, h=3, prob=10 },
    { w=3, h=4, prob=10 },
    { w=3, h=5, prob=80 },
    { w=3, h=7, prob=40 },

    { w=5, h=3, prob=2  },
    { w=5, h=4, prob=2  },
    { w=5, h=5, prob=10 },
    { w=5, h=7, prob=10 },

    { w=7, h=7, prob=5 },
    { w=9, h=9, prob=1 },
  },

  x_grow = { 1, 3 },
  y_grow = { 1, 3 },

  connections =
  {
    {
      exits =
      {
        { x=1, y=2, dir=4 },
        { x=3, y=2, dir=6 },
        { x=2, y=3, dir=8 },
      }
    }
  }
},


HALL_FANCY_T =
{
  prob = 11,

  structure =
  {
    "HHH.HHH",
    "..H.H..",
    "..HHH..",
  },

  x_grow = { 4 },
  y_grow = { 2 },

  sizes =
  {
    { w=7, h=3, prob=80 },
    { w=7, h=4, prob=80 },
    { w=7, h=5, prob=60 },
    { w=7, h=6, prob=40 },

    { w=9, h=3, prob=1  },
    { w=9, h=5, prob=4  },
    { w=9, h=7, prob=12 },
  },

  connections =
  {
    {
      exits =
      {
        { x=1, y=3, dir=8 },
        { x=7, y=3, dir=8 },
      }
    }
  }
},


----------------------------------------------------------------

--[[
GROUND_BRIDGE =
{
  prob = 51,

  structure =
  {
    "ggggg",
    "wwgww",
    "ggggg",
  },

  x_grow = { 1,5 },
  y_grow = { 1,3, 2,2 },

  enter_x = 2,

  sizes =
  {
    { w=5, h=3, prob=10 },
    { w=5, h=5, prob=20 },
    { w=5, h=7, prob=20 },
    { w=5, h=9, prob=10 },

    { w=7, h=3, prob=10 },
    { w=7, h=5, prob=20 },
    { w=7, h=7, prob=20 },
    { w=7, h=9, prob=10 },

    { w=9, h=5,  prob=10 },
    { w=9, h=7,  prob=30 },
    { w=9, h=9,  prob=30 },
    { w=9, h=11, prob=10 },

    { w=11, h=5,  prob=10 },
    { w=11, h=7,  prob=30 },
    { w=11, h=9,  prob=30 },
    { w=11, h=11, prob=10 },
  },

  connections =
  {
    {
      exits =
      {
        { x=5, y=3, dir=6 },
        { x=1, y=3, dir=4, optional=true },
      }
    }
  }
},


GROUND_SURROUND_FIXED =
{
  prob = 3,

  structure =
  {
    "ggggggggggggg",
    "gg.........gg",
    "gg.........gg",
    "gg.........gg",
    "gg.........gg",
    "gg.........gg",
    "gg.........gg",
    "gg.........gg",
    "ggggggggggggg",
  },

  connections =
  {
    {
      exits =
      {
        { x=2, y=5, dir=6 },
      }
    }
  }
},


GROUND_SURROUND =
{
  prob = 300,

  structure =
  {
    "ggg",
    "g.g",
    "ggg",
  },

  x_grow = { 2,2, 1,3, 2,2,2, 1,3, 2,2 },
  y_grow = { 2,2, 1,3, 2,2,2, 1,3, 2,2 },

  sizes =
  {
    { w=3, h=3, prob=0.01 },  -- FIXME: do not require sizes[1] to match 'structure' field

    { w=5, h=5, prob=10 },

    { w=7, h=5, prob=20 },
    { w=7, h=7, prob=20 },

    { w=9, h=5, prob=30 },
    { w=9, h=7, prob=30 },
    { w=9, h=9, prob=30 },

    { w=11, h=7,  prob=20 },
    { w=11, h=9,  prob=20 },
    { w=11, h=11, prob=20 },

    { w=13, h=7,  prob=10 },
    { w=13, h=9,  prob=10 },
    { w=13, h=11, prob=10 },
    { w=13, h=13, prob=10 },
  },

  connections =
  {
    {
      exits =
      {
        { x=1, y=1, dir=8 },
      }
    }
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

    F.long = #F.structure[1]
    F.deep = #F.structure

    if not F.sizes then
      F.sizes = {{ w = F.long, h = F.deep, prob = 100 }}
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

    if not F.enter_x then
      F.enter_x = 1 + int(F.long / 2)
    end
  end
end

