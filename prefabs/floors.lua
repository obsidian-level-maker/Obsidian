----------------------------------------------------------------
--  FLOOR PREFABS
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2010 Andrew Apted
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
--
--  NOTES:
--
--  Floor prefabs are a bit special, they sub-divide a rectangular
--  space in a room into two parts (which may be further divided)
--  and provide the means (usually stairs) to go from one half to
--  the other.  The stairs determine what the height difference is.
--
--  There are three main classes of floor prefabs:
--
--     H  :  short for "halver", divides the area into a left
--           half and a right half.
--
--     L  :  L-shape, makes a new rectangle around the bottom
--           left corner (it's the rest of the room which will
--           become L-shaped).
--
--     U  :  U-shape, makes a new rectangle along the bottom
--           edge, the rest of the room becomes an up-side-down
--           U shape.
--
----------------------------------------------------------------


PREFAB.H1_DOWN_1 =
{
  placement = "fitted",

  shape = "H",

  brushes =
  {
    -- new floor area : left side
    {
      { m = "floor", space = "new" },
      { x =   0, y =   0 },
      { x = 256, y =   0 },
      { x = 256, y = 512 },
      { x =   0, y = 512 },
    },

    -- old floor area : right side
    {
      { m = "floor", space = "old" },
      { x = 256, y =   0 },
      { x = 512, y =   0 },
      { x = 512, y = 512 },
      { x = 256, y = 512 },
    },

    -- walk areas
    {
      { m = "walk", space = "old" },
      { x = 256, y =   0 },
      { x = 304, y =   0 },
      { x = 304, y =  64 },
      { x = 256, y =  64 },
    },

    {
      { m = "walk", space = "new", walk_dz = -16 },
      { x = 208, y =   0 },
      { x = 256, y =   0 },
      { x = 256, y =  64 },
      { x = 208, y =  64 },
    },

    -- new safe zones
    {
      { m = "zone", space = "new" },
      { x =   0, y =   0 },
      { x = 208, y =   0 },
      { x = 208, y = 512 },
      { x =   0, y = 512 },
    },

    {
      { m = "zone", space = "old" },
      { x = 304, y =   0 },
      { x = 512, y =   0 },
      { x = 512, y = 512 },
      { x = 304, y = 512 },
    },
  },
}


PREFAB.H1_DOWN_4 =
{
  placement = "fitted",

  shape = "H",

  brushes =
  {
    -- new floor area : left side
    {
      { m = "floor", space = "new" },
      { x =   0, y =   0 },
      { x = 256, y =   0 },
      { x = 256, y = 512 },
      { x =   0, y = 512 },
    },

    -- old floor area : right side
    {
      { m = "floor", space = "old" },
      { x = 256, y =   0 },
      { x = 512, y =   0 },
      { x = 512, y = 512 },
      { x = 256, y = 512 },
    },

    -- steps
    {
      { m = "solid", flavor = "floor:3" },
      { x = 208, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 240, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 240, y = 384, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 208, y = 384, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t = -48, mat = "?top", light = "?light" },
    },

    {
      { m = "solid", flavor = "floor:3" },
      { x = 240, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 272, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 272, y = 384, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 240, y = 384, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t = -32, mat = "?top", light = "?light" },
    },

    {
      { m = "solid", flavor = "floor:3" },
      { x = 272, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 304, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 304, y = 384, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 272, y = 384, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t = -16, mat = "?top", light = "?light" },
    },

    -- walk areas
    {
      { m = "walk", space = "old" },
      { x = 304, y = 128 },
      { x = 400, y = 128 },
      { x = 400, y = 384 },
      { x = 304, y = 384 },
    },

    {
      { m = "walk", space = "new", walk_dz = -64 },
      { x = 112, y = 128 },
      { x = 208, y = 128 },
      { x = 208, y = 384 },
      { x = 112, y = 384 },
    },

    -- new safe zones
    {
      { m = "zone", space = "new" },
      { x =   0, y =   0 },
      { x = 112, y =   0 },
      { x = 112, y = 512 },
      { x =   0, y = 512 },
    },

    {
      { m = "zone", space = "old" },
      { x = 400, y =   0 },
      { x = 512, y =   0 },
      { x = 512, y = 512 },
      { x = 400, y = 512 },
    },

--[[ FENCE TEST
    {
      { m = "solid", outlier = 1 },
      { x = 248, y = -128, mat = "?wall" },
      { x = 264, y = -128, mat = "?wall" },
      { x = 264, y =  128, mat = "?wall" },
      { x = 248, y =  128, mat = "?wall" },
      { t = 32, mat = "?wall" },
    },

    {
      { m = "solid", outlier = 1 },
      { x = 248, y = 384, mat = "?wall" },
      { x = 264, y = 384, mat = "?wall" },
      { x = 264, y = 640, mat = "?wall" },
      { x = 248, y = 640, mat = "?wall" },
      { t = 32, mat = "?wall" },
    },
--]]
  },
}



PREFAB.BRIDGE_TEST =
{
  placement = "fitted",

  brushes =
  {
    -- liquid area
    {
      { m = "solid", flavor = "floor:2" },
      { x =   0, y =   0, mat = "?liquid" },
      { x = 256, y =   0, mat = "?liquid" },
      { x = 256, y = 256, mat = "?liquid" },
      { x =   0, y = 256, mat = "?liquid" },
      { t = -72, mat = "?liquid" },
    },

    -- bridge
    {
      { m = "solid" },
      { x = 112, y =   0, mat = "?wall" },
      { x = 144, y =   0, mat = "?wall" },
      { x = 144, y = 256, mat = "?wall" },
      { x = 112, y = 256, mat = "?wall" },
      { t =   0, mat = "?wall" },
    },
  },
}

