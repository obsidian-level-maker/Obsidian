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
}


PREFAB.H1_DOWN_4 =
{
  placement = "fitted",

  x_size = 256,
  y_size = 192,

  neighborhood =
  {
    { space = 2, x2 = 0 },
    { space = 2, x1 = 0, x2 = 128, y2 = 0 },
    { space = 2, x1 = 0, x2 = 128, y1 = 192 },

    { space = 1, x1 = 256 },
    { space = 1, x1 = 128, x2 = 256, y2 = 0 },
    { space = 1, x1 = 128, x2 = 256, y1 = 192 },

    -- new safe zones
    { m = "zone", space = 1, x1 = 200 },
    { m = "zone", space = 2, x2 =  56 },
  },

  brushes =
  {
    -- new floor area : left side
    {
      { m = "floor", space = 2 },
      { x =   0, y =   0 },
      { x = 128, y =   0 },
      { x = 128, y = 192 },
      { x =   0, y = 192 },
    },

    -- old floor area : right side
    {
      { m = "floor", space = 1 },
      { x = 128, y =   0 },
      { x = 256, y =   0 },
      { x = 256, y = 192 },
      { x = 128, y = 192 },
    },

    -- steps
    {
      { m = "solid", flavor = "floor:3" },
      { x = 104, y =  48, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 120, y =  48, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 120, y = 144, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 104, y = 144, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t = -48, mat = "?top" },
    },

    {
      { m = "solid", flavor = "floor:3" },
      { x = 120, y =  48, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 136, y =  48, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 136, y = 144, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 120, y = 144, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t = -32, mat = "?top" },
    },

    {
      { m = "solid", flavor = "floor:3" },
      { x = 136, y =  48, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 152, y =  48, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 152, y = 144, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 136, y = 144, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t = -16, mat = "?top" },
    },

    -- walk areas
    {
      { m = "walk", space = 1 },
      { x = 152, y =  48 },
      { x = 200, y =  48 },
      { x = 200, y = 144 },
      { x = 152, y = 144 },
    },

    {
      { m = "walk", space = 2, walk_dz = -64 },
      { x =  56, y =  48 },
      { x = 104, y =  48 },
      { x = 104, y = 144 },
      { x =  56, y = 144 },
    },
  },
}



PREFAB.H1_SIDE_STAIR =
{
  placement = "fitted",

  x_size = 384,
  y_size = 192,

  neighborhood =
  {
    { space = 2, x2 = 320 },
    { space = 1, x1 = 320 },

    -- new safe zones
    { m = "zone", space = 1, x1 = 384 },
    { m = "zone", space = 2, x2 = 0   },
  },

  brushes =
  {
    -- new floor area : left side
    {
      { m = "floor", space = 2 },
      { x =   0, y =   0 },
      { x = 320, y =   0 },
      { x = 320, y = 192 },
      { x =   0, y = 192 },
    },

    -- old floor area : right side
    {
      { m = "floor", space = 1 },
      { x = 320, y =   0 },
      { x = 384, y =   0 },
      { x = 384, y = 192 },
      { x = 320, y = 192 },
    },

    -- walk areas
    {
      { m = "walk", space = 1 },
      { x = 320, y = 128 },
      { x = 384, y = 128 },
      { x = 384, y = 192 },
      { x = 320, y = 192 },
    },

    {
      { m = "walk", space = 2, walk_dz = -128 },
      { x =   0, y = 128 },
      { x =  96, y = 128 },
      { x =  06, y = 192 },
      { x =   0, y = 192 },
    },

    -- steps
    {
      { m = "solid", flavor = "floor:3", outlier=1 },
      { x = 288, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 320, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 320, y = 384, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 288, y = 384, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t = -16, mat = "?top" },
    },
    
    {
      { m = "solid", flavor = "floor:3", outlier=1 },
      { x = 256, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 288, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 288, y = 384, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 256, y = 384, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t = -32, mat = "?top" },
    },
    
    {
      { m = "solid", flavor = "floor:3", outlier=1 },
      { x = 224, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 256, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 256, y = 384, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 224, y = 384, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t = -48, mat = "?top" },
    },
    
    {
      { m = "solid", flavor = "floor:3", outlier=1 },
      { x = 192, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 224, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 224, y = 384, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 192, y = 384, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t = -64, mat = "?top" },
    },
    
    {
      { m = "solid", flavor = "floor:3", outlier=1 },
      { x = 160, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 192, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 192, y = 384, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 160, y = 384, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t = -80, mat = "?top" },
    },
    
    {
      { m = "solid", flavor = "floor:3", outlier=1 },
      { x = 128, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 160, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 160, y = 384, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 128, y = 384, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t = -96, mat = "?top" },
    },
    
    {
      { m = "solid", flavor = "floor:3", outlier=1 },
      { x =  96, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 128, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 128, y = 384, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  96, y = 384, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t = -112, mat = "?top" },
    },
  },
}



PREFAB.L1_DOWN_4 =
{
  placement = "fitted",

  x_size = 192,
  y_size = 192,

  neighborhood =
  {
    { space = 2, x2 = 0, y2 = 192 },
    { space = 2, x1 = 0, x2 = 192, y2 = 0 },

    { space = 1, y1 = 192 },
    { space = 1, x1 = 192, y2 = 192 },

    -- new safe zones
    { m = "zone", space = 1, x1 = 256, y1 = 256 },
    { m = "zone", space = 2, x2 = 64, y2 = 64 },

    -- TODO { m = "zone", space = 1, x1 = 256, y2 = 192 },
  },

  brushes =
  {
    -- new floor area : bottom left corner
    {
      { m = "floor", space = 2 },
      { x =   0, y =   0 },
      { x = 192, y =   0 },
      { x = 192, y =  64 },
      { x =  64, y = 192 },
      { x =   0, y = 192 },
    },

    -- old floor area : top right corner
    {
      { m = "floor", space = 1 },
      { x =  64, y = 192 },
      { x = 192, y =  64 },
      { x = 192, y = 192 },
    },

    -- walk areas
    {
      { m = "walk", space = 1 },
      { x =  64, y = 192 },
      { x = 192, y =  64 },
      { x = 192, y = 192 },
    },

    {
      { m = "walk", space = 2, walk_dz = 36 },
      { x =  64, y = 128 },
      { x =  32, y =  96 },
      { x =  96, y =  32 },
      { x = 128, y =  64 },
    },

    -- steps
    {
      { m = "solid", flavor = "floor:3" },
      { x =  96, y = 160, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  80, y = 144, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 144, y =  80, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 160, y =  96, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t =  12, mat = "?top" },
    },

    {
      { m = "solid", flavor = "floor:3" },
      { x =  80, y = 144, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  64, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 128, y =  64, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 144, y =  80, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t =  24, mat = "?top" },
    },
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

