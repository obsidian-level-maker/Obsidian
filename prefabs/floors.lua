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



PREFAB.H_3DFLOOR_A =
{
  placement = "fitted",

  x_size = 192,
  y_size = 320,
  z_size = 256,

  neighborhood =
  {
    { space = 2, x1 =  96, z1 = 144 },
    { space = 1, z2 = 128 },

    -- new safe zones
    { m = "zone", space = 1, x1 = 192 },
    { m = "zone", space = 2, x1 = 192 },
  },

  brushes =
  {
--##    -- new floor area : left side
--##    {
--##      { m = "floor", space = 2 },
--##      { x =   0, y =   0 },
--##      { x = 320, y =   0 },
--##      { x = 320, y = 192 },
--##      { x =   0, y = 192 },
--##    },
--##
--##    -- old floor area : right side
--##    {
--##      { m = "floor", space = 1 },
--##      { x = 320, y =   0 },
--##      { x = 384, y =   0 },
--##      { x = 384, y = 192 },
--##      { x = 320, y = 192 },
--##    },

    -- walk areas
    {
      { m = "walk", space = 1, insider=1 },
      { x =   0, y =   0 },
      { x =  96, y =   0 },
      { x =  96, y =  64 },
      { x =   0, y =  64 },
    },

    {
      { m = "walk", space = 2, insider=1, walk_dz = 144 },
      { x =  96, y = 256 },
      { x = 192, y = 256 },
      { x = 192, y = 320 },
      { x =  96, y = 320 },
    },

    -- steps
    {
      { x =   0, y = 64, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  96, y = 64, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  96, y = 96, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =   0, y = 96, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { b =  0, mat = "?top" },
      { t = 16, mat = "?top" },
    },
 
    {
      { x =   0, y =  96, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  96, y =  96, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  96, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =   0, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { b = 16, mat = "?top" },
      { t = 32, mat = "?top" },
    },
 
    {
      { x =   0, y =  128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  96, y =  128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  96, y =  160, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =   0, y =  160, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { b = 32, mat = "?top" },
      { t = 48, mat = "?top" },
    },
 
    {
      { x =   0, y =  160, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  96, y =  160, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  96, y =  192, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =   0, y =  192, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { b = 48, mat = "?top" },
      { t = 64, mat = "?top" },
    },
 
    {
      { x =   0, y =  192, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  96, y =  192, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  96, y =  224, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =   0, y =  224, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { b = 64, mat = "?top" },
      { t = 80, mat = "?top" },
    },
 
    {
      { x =   0, y =  224, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  96, y =  224, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  96, y =  256, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =   0, y =  256, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { b = 80, mat = "?top" },
      { t = 96, mat = "?top" },
    },
 
    {
      { x =   0, y =  256, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  96, y =  256, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  96, y =  288, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =   0, y =  288, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { b =  96, mat = "?top" },
      { t = 112, mat = "?top" },
    },
 
    {
      { x =   0, y =  288, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  96, y =  288, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  96, y =  320, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =   0, y =  320, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { b = 112, mat = "?top" },
      { t = 128, mat = "?top" },
    },
  },
}



PREFAB.H_LIQ_BRIDGE_A =
{
  placement = "fitted",

  x_size = 512,
  y_size = 384,

  neighborhood =
  {
    { space = 1, x2 = 64 },
    { space = 2, x1 = 448 },

    -- new safe zones
    { m = "zone", space = 1, x2 = 0 },
    { m = "zone", space = 2, x1 = 512 },

    { m = "lava", x1 = 64, x2 = 448 },
  },

  brushes =
  {
    -- bridge
    {
      { m = "solid" },
      { x =  64, y = 160, mat = "?wall" },
      { x = 448, y = 160, mat = "?wall" },
      { x = 448, y = 224, mat = "?wall" },
      { x =  64, y = 224, mat = "?wall" },
      { b = -16, mat = "?wall" },
      { t =   0, mat = "?wall" },
    },

    -- walk areas
    {
      { m = "walk", space = 1 },
      { x =   0, y = 144 },
      { x =  64, y = 144 },
      { x =  64, y = 240 },
      { x =   0, y = 240 },
    },

    {
      { m = "walk", space = 2, walk_dz = 0 },
      { x = 448, y = 144 },
      { x = 512, y = 144 },
      { x = 512, y = 240 },
      { x = 448, y = 240 },
    },
  },
}



PREFAB.H_WALL_1 =
{
  placement = "fitted",

  x_size = 64,
  y_size = 512,

  neighborhood =
  {
    { space = 1, x2 = 0 },

    { space = 2, x1 = 64 },

    { m = "lava", tt = 512, x1 = 0, x2 = 64, y2 = 0 },
    { m = "lava", tt = 512, x1 = 0, x2 = 64, y1 = 512 },

    -- new safe zones
    { m = "zone", space = 1, x2 = -64 },
    { m = "zone", space = 2, x1 = 128 },
  },

  brushes =
  {
    -- floor
    {
      { x =  0, y =   0, mat = "?floor" },
      { x = 64, y =   0, mat = "?floor" },
      { x = 64, y = 512, mat = "?floor" },
      { x =  0, y = 512, mat = "?floor" },
      { t = 8, mat = "?floor" },
    },

    -- ceil
    {
      { x =  0, y =   0, mat = "?floor" },
      { x = 64, y =   0, mat = "?floor" },
      { x = 64, y = 512, mat = "?floor" },
      { x =  0, y = 512, mat = "?floor" },
      { b = 136, mat = "?floor" },
    },

    -- posts
    {
      { x = 16, y = 128, mat = "?wall" },
      { x = 48, y = 128, mat = "?wall" },
      { x = 48, y = 216, mat = "?wall" },
      { x = 16, y = 216, mat = "?wall" },
    },

    {
      { x = 16, y = 296, mat = "?wall" },
      { x = 48, y = 296, mat = "?wall" },
      { x = 48, y = 384, mat = "?wall" },
      { x = 16, y = 384, mat = "?wall" },
    },

    -- walk areas
    {
      { m = "walk", space = 1 },
      { x = -64, y = 216 },
      { x =  32, y = 216 },
      { x =  32, y = 296 },
      { x = -64, y = 296 },
    },

    {
      { m = "walk", space = 2, walk_dz = 0 },
      { x =  32, y = 216 },
      { x = 128, y = 216 },
      { x = 128, y = 296 },
      { x =  32, y = 296 },
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
    { m = "zone", space = 1, y1 = 256 },
    { m = "zone", space = 1, x1 = 256, y2 = 192 },

    { m = "zone", space = 2, x2 = 128, y2 = 0 },
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
      { m = "walk", space = 2, walk_dz = 48 },
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
      { t =  16, mat = "?top" },
    },

    {
      { m = "solid", flavor = "floor:3" },
      { x =  80, y = 144, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  64, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 128, y =  64, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 144, y =  80, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t =  32, mat = "?top" },
    },
  },
}


PREFAB.L_LIQUID_1 =
{
  placement = "fitted",

  x_size = 384,
  y_size = 384,

  neighborhood =
  {
    { space = 1, y1 = 384 },
    { space = 1, y2 = 384, x1 = 384 },

    { space = 2, x2 = 0, y2 = 192 },
    { space = 2, x1 = 0, x2 = 192, y2 = 192 }, --!!!! y2 = 0

    { m = "lava", y1 = 192, y2 = 384, x2 = 384 },
    { m = "lava", x1 = 192, x2 = 384, y2 = 192 },

    -- new safe zones
    { m = "zone", space = 1, y1 = 464 },
    { m = "zone", space = 1, y2 = 384, x1 = 464 },

    { m = "zone", space = 2, x2 = 64, y2 = 64 },
  },

  brushes =
  {
    -- walk areas
    {
      { m = "walk", space = 1 },
      { x = 304, y = 384 },
      { x = 384, y = 464 },
      { x = 384, y = 464 },
      { x = 304, y = 384 },
    },

    {
      { m = "walk", space = 2, walk_dz = 0 },
      { x =  64, y = 64 },
      { x = 192, y = 64 },
      { x = 192, y = 192 },
      { x =  64, y = 192 },
    },

    -- steps
    {
      { m = "detail" },
      { x = 272, y = 368, mat = "?wall" },
      { x = 256, y = 352, mat = "?wall" },
      { x = 352, y = 256, mat = "?wall" },
      { x = 368, y = 272, mat = "?wall" },
      { t =  -4, mat = "?wall" },
      { b = -24, mat = "?wall" },
    },

    {
      { m = "detail" },
      { x = 232, y = 328, mat = "?wall" },
      { x = 216, y = 312, mat = "?wall" },
      { x = 312, y = 216, mat = "?wall" },
      { x = 328, y = 232, mat = "?wall" },
      { t =  -4, mat = "?wall" },
      { b = -24, mat = "?wall" },
    },

    {
      { m = "detail" },
      { x = 192, y = 288, mat = "?wall" },
      { x = 176, y = 272, mat = "?wall" },
      { x = 272, y = 176, mat = "?wall" },
      { x = 288, y = 192, mat = "?wall" },
      { t =  -4, mat = "?wall" },
      { b = -24, mat = "?wall" },
    },

    -- player clip
    {
      { m = "clip" },
      { x = 384, y = 384 },
      { x = 288, y = 384 },
      { x =  88, y = 184 },
      { x = 184, y =  88 },
      { x = 384, y = 288 },
      { t =   0 },
      { b = -28 },
    },

  },
}



PREFAB.U_LIQUID_A =
{
  placement = "fitted",

  x_size = 384,
  y_size = 256,

  neighborhood =
  {
    { space = 1, y1 = 256 },
    { space = 2, y2 = 0, x1 = 0, x2 = 384 },

    { m = "lava", x1 = 384, y2 = 256 },
    { m = "lava", x2 =   0, y2 = 256 },
    { m = "lava", x1 =   0, x2 = 384, y1 =   0, y2 = 256 },

    -- new safe zones
    { m = "zone", space = 1, y1 = 320 },
    { m = "zone", space = 2, y2 = 128 },
  },

  brushes =
  {
    -- new floor area : bottom middle
    {
      { m = "floor", space = 2 },
      { x =   0, y =   0 },
      { x = 384, y =   0 },
      { x = 384, y = 128 },
      { x = 320, y = 216 },
      { x = 256, y = 256 },
      { x = 128, y = 256 },
      { x =  64, y = 216 },
      { x =   0, y = 128 },
    },

    -- walk areas
    {
      { m = "walk", space = 1 },
      { x =   0, y = 256 },
      { x = 384, y = 256 },
      { x = 384, y = 320 },
      { x =   0, y = 320 },
    },

    {
      { m = "walk", space = 2, walk_dz = 80 },
      { x = 128, y = 128 },
      { x = 128, y = 128 },
      { x = 256, y = 256 },
      { x = 256, y = 256 },
    },

    -- steps
    {
      { m = "solid", flavor = "floor:3" },
      { x = 144, y = 236, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 240, y = 236, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 240, y = 256, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 144, y = 256, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t = 16, mat = "?top" },
    },
 
    {
      { m = "solid", flavor = "floor:3" },
      { x = 144, y = 216, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 240, y = 216, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 240, y = 236, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 144, y = 236, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t = 32, mat = "?top" },
    },
 
    {
      { m = "solid", flavor = "floor:3" },
      { x = 144, y = 196, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 240, y = 196, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 240, y = 216, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 144, y = 216, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t = 48, mat = "?top" },
    },
 
    {
      { m = "solid", flavor = "floor:3" },
      { x = 144, y = 176, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 240, y = 176, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 240, y = 196, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = 144, y = 196, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t = 64, mat = "?top" },
    },
  },
}



PREFAB.ZZ_LAVA_HOLE =
{
  placement = "fitted",

-- legless = true,

  x_size = 256,
  y_size = 256,

  neighborhood =
  {
    { space = 1, x2 = 0 },
    { space = 2, x1 = 256 },
    { space = 1, x1 = 0, x2 = 256, y2 = 0 },
    { space = 1, x1 = 0, x2 = 256, y1 = 256 },

    { m = "lava", x1 = 0, x2 = 256, y1 = 0, y2 = 256 },

    -- new safe zones
    { m = "zone", space = 1, x2 = -16 },
    { m = "zone", space = 2, x1 = 272 },
    { m = "zone", space = 1, x1 = 16, x2 = 240, y2 = -16 },
    { m = "zone", space = 1, x1 = 16, x2 = 240, y1 = 272 },
  },

  brushes =
  {
    {
      { m = "solid" },
      { x =  0, y =  0, mat = "?floor" },
      { x = 64, y =  0, mat = "?floor" },
      { x =  0, y = 64, mat = "?floor" },
      { t = 0, mat = "?floor" },
    },

    {
      { m = "solid" },
      { x = 192, y =  0, mat = "?floor" },
      { x = 256, y =  0, mat = "?floor" },
      { x = 256, y = 64, mat = "?floor" },
      { t = 0, mat = "?floor" },
    },

    {
      { m = "solid" },
      { x = 64, y = 256, mat = "?floor" },
      { x =  0, y = 256, mat = "?floor" },
      { x =  0, y = 192, mat = "?floor" },
      { t = 0, mat = "?floor" },
    },

    {
      { m = "solid" },
      { x = 256, y = 256, mat = "?floor" },
      { x = 192, y = 256, mat = "?floor" },
      { x = 256, y = 192, mat = "?floor" },
      { t = 0, mat = "?floor" },
    },

    {
      { m = "nosplit" },
      { x = -32, y = -32 },
      { x = 288, y = -32 },
      { x = 288, y = 288 },
      { x = -32, y = 288 },
    },

    -- walk areas
    {
      { m = "walk", space = 1 },
      { x = -48, y =   0 },
      { x =   0, y =   0 },
      { x =   0, y = 256 },
      { x = -48, y = 256 },
    },

    {
      { m = "walk", space = 2, walk_dz = 0 },
      { x = 256, y =   0 },
      { x = 256, y =   0 },
      { x = 304, y = 256 },
      { x = 304, y = 256 },
    },
  },
}

