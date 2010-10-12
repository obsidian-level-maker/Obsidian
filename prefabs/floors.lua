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

  x_size = 256,
  y_size = 256,

  brushes =
  {
    -- new floor area : left side
    {
      { m = "floor", space = 2 },
      { x =   0, y =   0 },
      { x = 128, y =   0 },
      { x = 128, y = 256 },
      { x =   0, y = 256 },
    },

    -- old floor area : right side
    {
      { m = "floor", space = 1 },
      { x = 128, y =   0 },
      { x = 256, y =   0 },
      { x = 256, y = 256 },
      { x = 128, y = 256 },
    },

    -- walk areas
    {
      { m = "walk", space = 1 },
      { x = 128, y =   0 },
      { x = 176, y =   0 },
      { x = 176, y =  64 },
      { x = 128, y =  64 },
    },

    {
      { m = "walk", space = 2, walk_dz = -16 },
      { x =  80, y =   0 },
      { x = 128, y =   0 },
      { x = 128, y =  64 },
      { x =  80, y =  64 },
    },
  },

  neighborhood =
  {
    { space = 2, x2 = 0 },
    { space = 2, x1 = 0, x2 = 128, y2 = 0 },
    { space = 2, x1 = 0, x2 = 128, y1 = 256 },

    { space = 1, x1 = 256 },
    { space = 1, x1 = 128, x2 = 256, y2 = 0 },
    { space = 1, x1 = 128, x2 = 256, y1 = 256 },

    -- new safe zones
    { m = "zone", space = 1, x1 = 152 },
    { m = "zone", space = 2, x2 = 104 },
  },
}


PREFAB.H1_DOWN_4 =
{
  placement = "fitted",

  x_size = 256,
  y_size = 256,

  brushes =
  {
    -- new floor area : left side
    {
      { m = "floor", space = 2 },
      { x =   0, y =   0 },
      { x = 128, y =   0 },
      { x = 128, y = 256 },
      { x =   0, y = 256 },
    },

    -- old floor area : right side
    {
      { m = "floor", space = 1 },
      { x = 128, y =   0 },
      { x = 256, y =   0 },
      { x = 256, y = 256 },
      { x = 128, y = 256 },
    },

    -- steps
    {
      { m = "solid", flavor = "floor:3" },
      { x = 104, y =  64, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 120, y =  64, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 120, y = 192, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 104, y = 192, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t = -48, mat = "?top", light = "?light" },
    },

    {
      { m = "solid", flavor = "floor:3" },
      { x = 120, y =  64, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 136, y =  64, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 136, y = 192, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 120, y = 192, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t = -32, mat = "?top", light = "?light" },
    },

    {
      { m = "solid", flavor = "floor:3" },
      { x = 136, y =  64, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 152, y =  64, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 152, y = 192, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 136, y = 192, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t = -16, mat = "?top", light = "?light" },
    },

    -- walk areas
    {
      { m = "walk", space = 1 },
      { x = 152, y =  64 },
      { x = 200, y =  64 },
      { x = 200, y = 192 },
      { x = 152, y = 192 },
    },

    {
      { m = "walk", space = 2, walk_dz = -64 },
      { x =  56, y =  64 },
      { x = 104, y =  64 },
      { x = 104, y = 192 },
      { x =  56, y = 192 },
    },
  },

  neighborhood =
  {
    { space = 2, x2 = 0 },
    { space = 2, x1 = 0, x2 = 128, y2 = 0 },
    { space = 2, x1 = 0, x2 = 128, y1 = 256 },

    { space = 1, x1 = 256 },
    { space = 1, x1 = 128, x2 = 256, y2 = 0 },
    { space = 1, x1 = 128, x2 = 256, y1 = 256 },

    -- new safe zones
    { m = "zone", space = 1, x1 = 200 },
    { m = "zone", space = 2, x2 =  56 },
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

