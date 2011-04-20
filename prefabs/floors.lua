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

PREFAB.H_STAIR_6 =
{
  placement = "fitted"

  x_size = 216,
  y_size = 144,

  brushes =
  {
    ---| south floor |---

    {
      { m = "floor", space = 1 }
      { x = -INF, y = -INF }
      { x =  INF, y = -INF }
      { x =  INF, y =    0 }
      { x = -INF, y =    0 }
    }

    {
      { m = "floor", space = 1 }
      { x =   0, y =   0 }
      { x = 216, y =   0 }
      { x = 216, y =  24 }
      { x =   0, y =  24 }
    }

    {
      { m = "zone", space = 1 }
      { x = -INF, y = -INF }
      { x =  INF, y = -INF }
      { x =  INF, y =  -96 }
      { x = -INF, y =  -96 }
    }

    {
      { m = "walk", space = 1 }
      { x =   0, y = -96 }
      { x = 216, y = -96 }
      { x = 216, y =   0 }
      { x =   0, y =   0 }
      { b = 0 }
      { t = 144 }
    }


    ---| north floor |---
    {
      { m = "floor", space = 2 }
      { x = -INF, y = 144 }
      { x =  INF, y = 144 }
      { x =  INF, y = INF }
      { x = -INF, y = INF }
    }

    {
      { m = "floor", space = 2 }
      { x = -INF, y =   0 }
      { x =    0, y =   0 }
      { x =    0, y = 144 }
      { x = -INF, y = 144 }
    }

    {
      { m = "floor", space = 2 }
      { x = 216, y =   0 }
      { x = INF, y =   0 }
      { x = INF, y = 144 }
      { x = 216, y = 144 }
    }

    {
      { m = "floor", space = 2 }
      { x =   0, y =   0 }
      { x =  72, y = 144 }
      { x =   0, y = 144 }
    }

    {
      { m = "floor", space = 2 }
      { x = 144, y = 144 }
      { x = 216, y =   0 }
      { x = 216, y = 144 }
    }

    {
      { m = "zone", space = 2 }
      { x = -INF, y = 192 }
      { x =  INF, y = 192 }
      { x =  INF, y = INF }
      { x = -INF, y = INF }
    }

    {
      { m = "walk", space = 2 }
      { x =   0, y =   0 }
      { x = 216, y =   0 }
      { x = 216, y = 192 }
      { x =   0, y = 192 }
      { b = 72 }
      { t = 144 }
    }

    -- steps
    {
      { x =   4, y =  24, mat = "?step", peg=1, y_offset=0 }
      { x = 212, y =  24, mat = "?step", peg=1, y_offset=0 }
      { x = 212, y =  48, mat = "?step", peg=1, y_offset=0 }
      { x =   4, y =  48, mat = "?step", peg=1, y_offset=0 }
      { t = 12, mat = "?step" }
    }

    {
      { x =   4, y =  48, mat = "?step", peg=1, y_offset=0 }
      { x = 212, y =  48, mat = "?step", peg=1, y_offset=0 }
      { x = 212, y =  72, mat = "?step", peg=1, y_offset=0 }
      { x =   4, y =  72, mat = "?step", peg=1, y_offset=0 }
      { t = 24, mat = "?step" }
    }

    {
      { x =   4, y =  72, mat = "?step", peg=1, y_offset=0 }
      { x = 212, y =  72, mat = "?step", peg=1, y_offset=0 }
      { x = 212, y =  96, mat = "?step", peg=1, y_offset=0 }
      { x =   4, y =  96, mat = "?step", peg=1, y_offset=0 }
      { t = 36, mat = "?step" }
    }

    {
      { x =   4, y =  96, mat = "?step", peg=1, y_offset=0 }
      { x = 212, y =  96, mat = "?step", peg=1, y_offset=0 }
      { x = 212, y = 120, mat = "?step", peg=1, y_offset=0 }
      { x =   4, y = 120, mat = "?step", peg=1, y_offset=0 }
      { t = 48, mat = "?step" }
    }

    {
      { x =   4, y = 120, mat = "?step", peg=1, y_offset=0 }
      { x = 212, y = 120, mat = "?step", peg=1, y_offset=0 }
      { x = 212, y = 144, mat = "?step", peg=1, y_offset=0 }
      { x =   4, y = 144, mat = "?step", peg=1, y_offset=0 }
      { t = 60, mat = "?step" }
    }

  }
}


PREFAB.TRIPLE_A =
{
  placement = "fitted"

  x_size = 512,
  y_size = 512,

  brushes =
  {
    ---| top left : lowest |---

    {
      { m = "floor", space = 1 }
      { x = -INF, y =   0 }
      { x =    0, y =   0 }
      { x =    0, y = INF }
      { x = -INF, y = INF }
    }

    {
      { m = "floor", space = 1 }
      { x = 0,  y = 0 }
      { x = 64, y = 64 }
      { x = 0,  y = 128 }
    }

    {
      { m = "floor", space = 1 }
      { x = 128, y = 256 }
      { x = 192, y = 192 }
      { x = 256, y = 256 }
      { x = 256, y = 384 }
      { x = 128, y = 384 }
    }

    {
      { m = "floor", space = 1 }
      { x =   0, y = 128 }
      { x = 128, y = 256 }
      { x = 128, y = 384 }
      { x =   0, y = 512 }
    }

    {
      { m = "zone", space = 1 }
      { x = -INF, y =  80 }
      { x =  -64, y =  80 }
      { x =  -64, y = INF }
      { x = -INF, y = INF }
    }

    {
      { m = "walk", space = 1 }
      { x = -64, y = 128 }
      { x =   0, y = 128 }
      { x = 128, y = 256 }
      { x = 128, y = 384 }
      { x = -64, y = 384 }
      { b = 0 }
      { t = 176 }
    }

    {
      { x =   0, y = 128, mat = "?step" }
      { x =  32, y =  96, mat = "?step" }
      { x = 160, y = 224, mat = "?step" }
      { x = 128, y = 256, mat = "?step" }
      { t = 16, mat = "?step" }
    }

    {
      { x =  32, y =  96, mat = "?step" }
      { x =  64, y =  64, mat = "?step" }
      { x = 192, y = 192, mat = "?step" }
      { x = 160, y = 224, mat = "?step" }
      { t = 32, mat = "?step" }
    }


    ---| south floor : middle |---

    {
      { m = "floor", space = 2 }
      { x = -INF, y = -INF }
      { x =  INF, y = -INF }
      { x =  INF, y =    0 }
      { x = -INF, y =    0 }
    }

    {
      { m = "floor", space = 2 }
      { x = 256, y =   0 }
      { x = INF, y =   0 }
      { x = INF, y = 256 }
      { x = 256, y = 256 }
    }

    {
      { m = "floor", space = 2 }
      { x =   0, y =   0 }
      { x = 256, y =   0 }
      { x = 256, y = 256 }
    }

    {
      { m = "floor", space = 2 }
      { x = 256, y = 256 }
      { x = 512, y = 256 }
      { x = 384, y = 384 }
      { x = 256, y = 384 }
    }

    {
      { m = "zone", space = 2 }
      { x = -INF, y = -INF }
      { x =  INF, y = -INF }
      { x =  INF, y =  -40 }
      { x = -INF, y =  -40 }
    }

    {
      { m = "walk", space = 2 }
      { x =   0, y =   0 }
      { x = 256, y =   0 }
      { x = 384, y = 256 }
      { x = 384, y = 384 }
      { x = 256, y = 384 }
      { b = 48 }
      { t = 176 }
    }


    ---| top right : highest |---

    {
      { m = "floor", space = 3 }
      { x =   0, y = 512 }
      { x = INF, y = 512 }
      { x = INF, y = INF }
      { x =   0, y = INF }
    }

    {
      { m = "floor", space = 3 }
      { x = 512, y = 256 }
      { x = INF, y = 256 }
      { x = INF, y = 512 }
      { x = 512, y = 512 }
    }

    {
      { m = "floor", space = 3 }
      { x =   0, y = 512 }
      { x = 128, y = 384 }
      { x = 256, y = 384 }
      { x = 256, y = 512 }
    }

    {
      { m = "floor", space = 3 }
      { x = 384, y = 384 }
      { x = 512, y = 256 }
      { x = 512, y = 512 }
      { x = 384, y = 512 }
    }

    {
      { m = "floor", space = 3 }
      { x = 256, y = 448 }
      { x = 384, y = 448 }
      { x = 384, y = 512 }
      { x = 256, y = 512 }
    }

    {
      { m = "zone", space = 3 }
      { x =  16, y = 528 }
      { x = INF, y = 528 }
      { x = INF, y = INF }
      { x =  16, y = INF }
    }

    {
      { m = "walk", space = 3 }
      { x = 256, y = 384 }
      { x = 384, y = 384 }
      { x = 384, y = 512 }
      { x = 256, y = 512 }
      { b = 96 }
      { t = 176 }
    }

    {
      { x = 256, y = 384, mat = "?step" }
      { x = 384, y = 384, mat = "?step" }
      { x = 384, y = 416, mat = "?step" }
      { x = 256, y = 416, mat = "?step" }
      { t = 64, mat = "?step" }
    }

    {
      { x = 256, y = 416, mat = "?step" }
      { x = 384, y = 416, mat = "?step" }
      { x = 384, y = 448, mat = "?step" }
      { x = 256, y = 448, mat = "?step" }
      { t = 80, mat = "?step" }
    }

  }
}


--- OLD --- OLD --- OLD --- OLD --- OLD --- OLD --- OLD --- > > >

PREFAB.H_DIAGONAL_A =
{
  placement = "fitted"

  x_size = 256,
  y_size = 192,

  neighborhood =
  {
    { space = 1, y2 = 0 }
    { space = 1, y1 = 0, y2 = 192, x1 = 256 }
    { space = 1, y1 = 0, y2 = 32,  x2 = 0 }

    { space = 2, y1 = 192 }
    { space = 2, y1 = 32, y2 = 192, x2 = 0 }

    -- new safe zones
    { m = "zone", space = 1, y2 = -64 }
    { m = "zone", space = 2, y1 = 256 }
  }

  brushes =
  {
    -- floor areas
    {
      { m = "floor", space = 1 }
      { x =   0, y =   0 }
      { x = 256, y =   0 }
      { x = 255, y = 160 }
    }

    {
      { m = "floor", space = 2 }
      { x =   0, y = 192 }
      { x =   0, y =  32 }
      { x = 256, y = 192 }
    }

    -- walk areas
    {
      { m = "walk", space = 1 }
      { x =   0, y =   0 }
      { x = 128, y =   0 }
      { x = 256, y =  96 }
      { x = 256, y = 160 }
    }

    {
      { m = "walk", space = 2, walk_dz = 16 }
      { x =   0, y =  96 }
      { x =   0, y =  32 }
      { x = 256, y = 192 }
      { x = 128, y = 192 }
    }

    -- step
    {
      { x =   0, y =  32, mat = "?top" }
      { x =   0, y =   0, mat = "?top" }
      { x = 256, y = 160, mat = "?top" }
      { x = 256, y = 192, mat = "?top" }
      { t =  8, mat = "?top" }
    }

    {
      { m = "solid", outlier=1 }
      { x = -96, y =   0, mat = "?top" }
      { x =   0, y =   0, mat = "?top" }
      { x =   0, y =  32, mat = "?top" }
      { x = -96, y =  32, mat = "?top" }
      { t =  8, mat = "?top" }
    }

    {
      { m = "solid", outlier=1 }
      { x = 256, y = 160, mat = "?top" }
      { x = 352, y = 160, mat = "?top" }
      { x = 352, y = 192, mat = "?top" }
      { x = 256, y = 192, mat = "?top" }
      { t =  8, mat = "?top" }
    }
  }
}


PREFAB.H1_DOWN_4 =
{
  placement = "fitted"

  x_size = 256,
  y_size = 192,

  neighborhood =
  {
    { space = 2, x2 = 0 }
    { space = 2, x1 = 0, x2 = 128, y2 = 0 }
    { space = 2, x1 = 0, x2 = 128, y1 = 192 }

    { space = 1, x1 = 256 }
    { space = 1, x1 = 128, x2 = 256, y2 = 0 }
    { space = 1, x1 = 128, x2 = 256, y1 = 192 }

    -- new safe zones
    { m = "zone", space = 1, x1 = 200 }
    { m = "zone", space = 2, x2 =  56 }
  }

  brushes =
  {
    -- new floor area : left side
    {
      { m = "floor", space = 2 }
      { x =   0, y =   0 }
      { x = 128, y =   0 }
      { x = 128, y = 192 }
      { x =   0, y = 192 }
    }

    -- old floor area : right side
    {
      { m = "floor", space = 1 }
      { x = 128, y =   0 }
      { x = 256, y =   0 }
      { x = 256, y = 192 }
      { x = 128, y = 192 }
    }

    -- steps
    {
      { m = "solid", flavor = "floor:3" }
      { x = 104, y =  48, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = 120, y =  48, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = 120, y = 144, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = 104, y = 144, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { t = -48, mat = "?top" }
    }

    {
      { m = "solid", flavor = "floor:3" }
      { x = 120, y =  48, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = 136, y =  48, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = 136, y = 144, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = 120, y = 144, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { t = -32, mat = "?top" }
    }

    {
      { m = "solid", flavor = "floor:3" }
      { x = 136, y =  48, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = 152, y =  48, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = 152, y = 144, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = 136, y = 144, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { t = -16, mat = "?top" }
    }

    -- walk areas
    {
      { m = "walk", space = 1 }
      { x = 152, y =  48 }
      { x = 200, y =  48 }
      { x = 200, y = 144 }
      { x = 152, y = 144 }
    }

    {
      { m = "walk", space = 2, walk_dz = -64 }
      { x =  56, y =  48 }
      { x = 104, y =  48 }
      { x = 104, y = 144 }
      { x =  56, y = 144 }
    }
  }
}



PREFAB.H_3DFLOOR_A =
{
  placement = "fitted"

  x_size = 192,
  y_size = 320,
  z_size = 256,

  neighborhood =
  {
    { space = 2, x1 =  96, z1 = 144 }
    { space = 1, z2 = 128 }

    -- new safe zones
    { m = "zone", space = 1, x1 = 192 }
    { m = "zone", space = 2, x1 = 192 }
  }

  brushes =
  {
--##    -- new floor area : left side
--##    {
--##      { m = "floor", space = 2 }
--##      { x =   0, y =   0 }
--##      { x = 320, y =   0 }
--##      { x = 320, y = 192 }
--##      { x =   0, y = 192 }
--##    }
--##
--##    -- old floor area : right side
--##    {
--##      { m = "floor", space = 1 }
--##      { x = 320, y =   0 }
--##      { x = 384, y =   0 }
--##      { x = 384, y = 192 }
--##      { x = 320, y = 192 }
--##    }

    -- walk areas
    {
      { m = "walk", space = 1, insider=1 }
      { x =   0, y =   0 }
      { x =  96, y =   0 }
      { x =  96, y =  64 }
      { x =   0, y =  64 }
    }

    {
      { m = "walk", space = 2, insider=1, walk_dz = 144 }
      { x =  96, y = 256 }
      { x = 192, y = 256 }
      { x = 192, y = 320 }
      { x =  96, y = 320 }
    }

    -- steps
    {
      { x =   0, y = 64, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  96, y = 64, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  96, y = 96, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =   0, y = 96, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { b =  0, mat = "?top" }
      { t = 16, mat = "?top" }
    }
 
    {
      { x =   0, y =  96, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  96, y =  96, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  96, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =   0, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { b = 16, mat = "?top" }
      { t = 32, mat = "?top" }
    }
 
    {
      { x =   0, y =  128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  96, y =  128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  96, y =  160, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =   0, y =  160, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { b = 32, mat = "?top" }
      { t = 48, mat = "?top" }
    }
 
    {
      { x =   0, y =  160, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  96, y =  160, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  96, y =  192, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =   0, y =  192, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { b = 48, mat = "?top" }
      { t = 64, mat = "?top" }
    }
 
    {
      { x =   0, y =  192, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  96, y =  192, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  96, y =  224, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =   0, y =  224, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { b = 64, mat = "?top" }
      { t = 80, mat = "?top" }
    }
 
    {
      { x =   0, y =  224, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  96, y =  224, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  96, y =  256, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =   0, y =  256, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { b = 80, mat = "?top" }
      { t = 96, mat = "?top" }
    }
 
    {
      { x =   0, y =  256, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  96, y =  256, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  96, y =  288, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =   0, y =  288, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { b =  96, mat = "?top" }
      { t = 112, mat = "?top" }
    }
 
    {
      { x =   0, y =  288, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  96, y =  288, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  96, y =  320, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =   0, y =  320, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { b = 112, mat = "?top" }
      { t = 128, mat = "?top" }
    }
  }
}



PREFAB.H_LIQ_BRIDGE_A =
{
  placement = "fitted"

  x_size = 512,
  y_size = 384,

  neighborhood =
  {
    { space = 1, x2 = 64 }
    { space = 2, x1 = 448 }

    -- new safe zones
    { m = "zone", space = 1, x2 = 0 }
    { m = "zone", space = 2, x1 = 512 }

    { m = "lava", x1 = 64, x2 = 448 }
  }

  brushes =
  {
    -- bridge
    {
      { m = "solid" }
      { x =  64, y = 160, mat = "?wall" }
      { x = 448, y = 160, mat = "?wall" }
      { x = 448, y = 224, mat = "?wall" }
      { x =  64, y = 224, mat = "?wall" }
      { b = -16, mat = "?wall" }
      { t =   0, mat = "?wall" }
    }

    -- walk areas
    {
      { m = "walk", space = 1 }
      { x =   0, y = 144 }
      { x =  64, y = 144 }
      { x =  64, y = 240 }
      { x =   0, y = 240 }
    }

    {
      { m = "walk", space = 2, walk_dz = 0 }
      { x = 448, y = 144 }
      { x = 512, y = 144 }
      { x = 512, y = 240 }
      { x = 448, y = 240 }
    }
  }
}



PREFAB.H_WALL_1 =
{
  placement = "fitted"

  x_size = 64,
  y_size = 512,

  neighborhood =
  {
    { space = 1, x2 = 0 }

    { space = 2, x1 = 64 }

    { m = "lava", tt = 512, x1 = 0, x2 = 64, y2 = 0 }
    { m = "lava", tt = 512, x1 = 0, x2 = 64, y1 = 512 }

    -- new safe zones
    { m = "zone", space = 1, x2 = -64 }
    { m = "zone", space = 2, x1 = 128 }
  }

  brushes =
  {
    -- floor
    {
      { x =  0, y =   0, mat = "?floor" }
      { x = 64, y =   0, mat = "?floor" }
      { x = 64, y = 512, mat = "?floor" }
      { x =  0, y = 512, mat = "?floor" }
      { t = 8, mat = "?floor" }
    }

    -- ceil
    {
      { x =  0, y =   0, mat = "?floor" }
      { x = 64, y =   0, mat = "?floor" }
      { x = 64, y = 512, mat = "?floor" }
      { x =  0, y = 512, mat = "?floor" }
      { b = 136, mat = "?floor" }
    }

    -- posts
    {
      { x = 16, y = 128, mat = "?wall" }
      { x = 48, y = 128, mat = "?wall" }
      { x = 48, y = 216, mat = "?wall" }
      { x = 16, y = 216, mat = "?wall" }
    }

    {
      { x = 16, y = 296, mat = "?wall" }
      { x = 48, y = 296, mat = "?wall" }
      { x = 48, y = 384, mat = "?wall" }
      { x = 16, y = 384, mat = "?wall" }
    }

    -- walk areas
    {
      { m = "walk", space = 1 }
      { x = -64, y = 216 }
      { x =  32, y = 216 }
      { x =  32, y = 296 }
      { x = -64, y = 296 }
    }

    {
      { m = "walk", space = 2, walk_dz = 0 }
      { x =  32, y = 216 }
      { x = 128, y = 216 }
      { x = 128, y = 296 }
      { x =  32, y = 296 }
    }
  }
}



PREFAB.L1_DOWN_4 =
{
  placement = "fitted"

  x_size = 192,
  y_size = 192,

  neighborhood =
  {
    { space = 2, x2 = 0, y2 = 192 }
    { space = 2, x1 = 0, x2 = 192, y2 = 0 }

    { space = 1, y1 = 192 }
    { space = 1, x1 = 192, y2 = 192 }

    -- new safe zones
    { m = "zone", space = 1, y1 = 256 }
    { m = "zone", space = 1, x1 = 256, y2 = 192 }

    { m = "zone", space = 2, x2 = 128, y2 = 0 }
  }

  brushes =
  {
    -- new floor area : bottom left corner
    {
      { m = "floor", space = 2 }
      { x =   0, y =   0 }
      { x = 192, y =   0 }
      { x = 192, y =  64 }
      { x =  64, y = 192 }
      { x =   0, y = 192 }
    }

    -- old floor area : top right corner
    {
      { m = "floor", space = 1 }
      { x =  64, y = 192 }
      { x = 192, y =  64 }
      { x = 192, y = 192 }
    }

    -- walk areas
    {
      { m = "walk", space = 1 }
      { x =  64, y = 192 }
      { x = 192, y =  64 }
      { x = 192, y = 192 }
    }

    {
      { m = "walk", space = 2, walk_dz = 48 }
      { x =  64, y = 128 }
      { x =  32, y =  96 }
      { x =  96, y =  32 }
      { x = 128, y =  64 }
    }

    -- steps
    {
      { m = "solid", flavor = "floor:3" }
      { x =  96, y = 160, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  80, y = 144, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = 144, y =  80, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = 160, y =  96, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { t =  16, mat = "?top" }
    }

    {
      { m = "solid", flavor = "floor:3" }
      { x =  80, y = 144, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  64, y = 128, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = 128, y =  64, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = 144, y =  80, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { t =  32, mat = "?top" }
    }
  }
}


PREFAB.L_LIQUID_1 =
{
  placement = "fitted"

  x_size = 384,
  y_size = 384,

  neighborhood =
  {
    { space = 1, y1 = 384 }
    { space = 1, y2 = 384, x1 = 384 }

    { space = 2, x2 = 0, y2 = 192 }
    { space = 2, x1 = 0, x2 = 192, y2 = 192 }  --!!!! y2 = 0

    { m = "lava", y1 = 192, y2 = 384, x2 = 384 }
    { m = "lava", x1 = 192, x2 = 384, y2 = 192 }

    -- new safe zones
    { m = "zone", space = 1, y1 = 464 }
    { m = "zone", space = 1, y2 = 384, x1 = 464 }

    { m = "zone", space = 2, x2 = 64, y2 = 64 }
  }

  brushes =
  {
    -- walk areas
    {
      { m = "walk", space = 1 }
      { x = 304, y = 384 }
      { x = 384, y = 464 }
      { x = 384, y = 464 }
      { x = 304, y = 384 }
    }

    {
      { m = "walk", space = 2, walk_dz = 0 }
      { x =  64, y = 64 }
      { x = 192, y = 64 }
      { x = 192, y = 192 }
      { x =  64, y = 192 }
    }

    -- steps
    {
      { m = "detail" }
      { x = 272, y = 368, mat = "?wall" }
      { x = 256, y = 352, mat = "?wall" }
      { x = 352, y = 256, mat = "?wall" }
      { x = 368, y = 272, mat = "?wall" }
      { t =  -4, mat = "?wall" }
      { b = -24, mat = "?wall" }
    }

    {
      { m = "detail" }
      { x = 232, y = 328, mat = "?wall" }
      { x = 216, y = 312, mat = "?wall" }
      { x = 312, y = 216, mat = "?wall" }
      { x = 328, y = 232, mat = "?wall" }
      { t =  -4, mat = "?wall" }
      { b = -24, mat = "?wall" }
    }

    {
      { m = "detail" }
      { x = 192, y = 288, mat = "?wall" }
      { x = 176, y = 272, mat = "?wall" }
      { x = 272, y = 176, mat = "?wall" }
      { x = 288, y = 192, mat = "?wall" }
      { t =  -4, mat = "?wall" }
      { b = -24, mat = "?wall" }
    }

    -- player clip
    {
      { m = "clip" }
      { x = 384, y = 384 }
      { x = 288, y = 384 }
      { x =  88, y = 184 }
      { x = 184, y =  88 }
      { x = 384, y = 288 }
      { t =   0 }
      { b = -28 }
    }

  }
}



PREFAB.U_LIQUID_A =
{
  placement = "fitted"

  x_size = 384,
  y_size = 256,

  neighborhood =
  {
    { space = 1, y1 = 256 }
    { space = 2, y2 = 0, x1 = 0, x2 = 384 }

    { m = "lava", x1 = 384, y2 = 256 }
    { m = "lava", x2 =   0, y2 = 256 }
    { m = "lava", x1 =   0, x2 = 384, y1 =   0, y2 = 256 }

    -- new safe zones
    { m = "zone", space = 1, y1 = 320 }
    { m = "zone", space = 2, y2 = 128 }
  }

  brushes =
  {
    -- new floor area : bottom middle
    {
      { m = "floor", space = 2 }
      { x =   0, y =   0 }
      { x = 384, y =   0 }
      { x = 384, y = 128 }
      { x = 320, y = 216 }
      { x = 256, y = 256 }
      { x = 128, y = 256 }
      { x =  64, y = 216 }
      { x =   0, y = 128 }
    }

    -- walk areas
    {
      { m = "walk", space = 1 }
      { x =   0, y = 256 }
      { x = 384, y = 256 }
      { x = 384, y = 320 }
      { x =   0, y = 320 }
    }

    {
      { m = "walk", space = 2, walk_dz = 80 }
      { x = 128, y = 128 }
      { x = 128, y = 128 }
      { x = 256, y = 256 }
      { x = 256, y = 256 }
    }

    -- steps
    {
      { m = "solid", flavor = "floor:3" }
      { x = 144, y = 236, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = 240, y = 236, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = 240, y = 256, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = 144, y = 256, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { t = 16, mat = "?top" }
    }
 
    {
      { m = "solid", flavor = "floor:3" }
      { x = 144, y = 216, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = 240, y = 216, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = 240, y = 236, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = 144, y = 236, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { t = 32, mat = "?top" }
    }
 
    {
      { m = "solid", flavor = "floor:3" }
      { x = 144, y = 196, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = 240, y = 196, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = 240, y = 216, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = 144, y = 216, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { t = 48, mat = "?top" }
    }
 
    {
      { m = "solid", flavor = "floor:3" }
      { x = 144, y = 176, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = 240, y = 176, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = 240, y = 196, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = 144, y = 196, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { t = 64, mat = "?top" }
    }
  }
}



PREFAB.ZZ_LAVA_HOLE =
{
  placement = "fitted"

-- legless = true,

  x_size = 256,
  y_size = 256,

  neighborhood =
  {
    { space = 1, x2 = 0 }
    { space = 2, x1 = 256 }
    { space = 1, x1 = 0, x2 = 256, y2 = 0 }
    { space = 1, x1 = 0, x2 = 256, y1 = 256 }

    { m = "lava", x1 = 0, x2 = 256, y1 = 0, y2 = 256 }

    -- new safe zones
    { m = "zone", space = 1, x2 = -16 }
    { m = "zone", space = 2, x1 = 272 }
    { m = "zone", space = 1, x1 = 16, x2 = 240, y2 = -16 }
    { m = "zone", space = 1, x1 = 16, x2 = 240, y1 = 272 }
  }

  brushes =
  {
    {
      { m = "solid" }
      { x =  0, y =  0, mat = "?floor" }
      { x = 64, y =  0, mat = "?floor" }
      { x =  0, y = 64, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }

    {
      { m = "solid" }
      { x = 192, y =  0, mat = "?floor" }
      { x = 256, y =  0, mat = "?floor" }
      { x = 256, y = 64, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }

    {
      { m = "solid" }
      { x = 64, y = 256, mat = "?floor" }
      { x =  0, y = 256, mat = "?floor" }
      { x =  0, y = 192, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }

    {
      { m = "solid" }
      { x = 256, y = 256, mat = "?floor" }
      { x = 192, y = 256, mat = "?floor" }
      { x = 256, y = 192, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }

    {
      { m = "nosplit" }
      { x = -32, y = -32 }
      { x = 288, y = -32 }
      { x = 288, y = 288 }
      { x = -32, y = 288 }
    }

    -- walk areas
    {
      { m = "walk", space = 1 }
      { x = -48, y =   0 }
      { x =   0, y =   0 }
      { x =   0, y = 256 }
      { x = -48, y = 256 }
    }

    {
      { m = "walk", space = 2, walk_dz = 0 }
      { x = 256, y =   0 }
      { x = 256, y =   0 }
      { x = 304, y = 256 }
      { x = 304, y = 256 }
    }
  }
}


PREFAB.ZZ_LAVA_HOLE_W_GRATE =
{
  placement = "fitted"

-- legless = true,

  x_size = 256
  y_size = 256

  defaults = { metal = "METAL1_1" }

  neighborhood =
  {
    { space = 1, x2 = 0 }
    { space = 2, x1 = 256 }
    { space = 1, x1 = 0, x2 = 256, y2 = 0 }
    { space = 1, x1 = 0, x2 = 256, y1 = 256 }

    { m = "lava", x1 = 0, x2 = 256, y1 = 0, y2 = 256 }

    -- new safe zones
    { m = "zone", space = 1, x2 = -16 }
    { m = "zone", space = 2, x1 = 272 }
    { m = "zone", space = 1, x1 = 16, x2 = 240, y2 = -16 }
    { m = "zone", space = 1, x1 = 16, x2 = 240, y1 = 272 }
  }

  brushes =
  {
    {
      { m = "solid" }
      { x =  0, y =  0, mat = "?floor" }
      { x = 64, y =  0, mat = "?floor" }
      { x =  0, y = 64, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }

    {
      { m = "solid" }
      { x = 192, y =  0, mat = "?floor" }
      { x = 256, y =  0, mat = "?floor" }
      { x = 256, y = 64, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }

    {
      { m = "solid" }
      { x = 64, y = 256, mat = "?floor" }
      { x =  0, y = 256, mat = "?floor" }
      { x =  0, y = 192, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }

    {
      { m = "solid" }
      { x = 256, y = 256, mat = "?floor" }
      { x = 192, y = 256, mat = "?floor" }
      { x = 256, y = 192, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }

    {
      { m = "nosplit" }
      { x = -32, y = -32 }
      { x = 288, y = -32 }
      { x = 288, y = 288 }
      { x = -32, y = 288 }
    }

    -- walk areas
    {
      { m = "walk", space = 1 }
      { x = -48, y =   0 }
      { x =   0, y =   0 }
      { x =   0, y = 256 }
      { x = -48, y = 256 }
    }

    {
      { m = "walk", space = 2, walk_dz = 0 }
      { x = 256, y =   0 }
      { x = 256, y =   0 }
      { x = 304, y = 256 }
      { x = 304, y = 256 }
    }

    -- grating X
    {
      { x =   0, y = 68, mat = "?metal" }
      { x = 256, y = 68, mat = "?metal" }
      { x = 256, y = 76, mat = "?metal" }
      { x =   0, y = 76, mat = "?metal" }
      { t =  -4, mat = "?metal" }
      { b = -16, mat = "?metal" }
    }

    {
      { x =   0, y = 180, mat = "?metal" }
      { x = 256, y = 180, mat = "?metal" }
      { x = 256, y = 188, mat = "?metal" }
      { x =   0, y = 188, mat = "?metal" }
      { t =  -4, mat = "?metal" }
      { b = -16, mat = "?metal" }
    }

    {
      { x =   0, y = 108, mat = "?metal" }
      { x = 256, y = 108, mat = "?metal" }
      { x = 256, y = 116, mat = "?metal" }
      { x =   0, y = 116, mat = "?metal" }
      { t =  -4, mat = "?metal" }
      { b = -16, mat = "?metal" }
    }

    {
      { x =   0, y = 140, mat = "?metal" }
      { x = 256, y = 140, mat = "?metal" }
      { x = 256, y = 148, mat = "?metal" }
      { x =   0, y = 148, mat = "?metal" }
      { t =  -4, mat = "?metal" }
      { b = -16, mat = "?metal" }
    }

    -- grating Y
    {
      { x = 68 , y =   0}
      { x = 76 , y =   0}
      { x = 76 , y = 256}
      { x = 68 , y = 256}
      { t =  -4, mat = "?metal" }
      { b = -16, mat = "?metal" }
    }

    {
      { x = 180, y =   0, mat = "?metal" }
      { x = 188, y =   0, mat = "?metal" }
      { x = 188, y = 256, mat = "?metal" }
      { x = 180, y = 256, mat = "?metal" }
      { t =  -4, mat = "?metal" }
      { b = -16, mat = "?metal" }
    }

    {
      { x = 108, y =   0, mat = "?metal" }
      { x = 116, y =   0, mat = "?metal" }
      { x = 116, y = 256, mat = "?metal" }
      { x = 108, y = 256, mat = "?metal" }
      { t =  -4, mat = "?metal" }
      { b = -16, mat = "?metal" }
    }

    {
      { x = 140, y =   0, mat = "?metal" }
      { x = 148, y =   0, mat = "?metal" }
      { x = 148, y = 256, mat = "?metal" }
      { x = 140, y = 256, mat = "?metal" }
      { t =  -4, mat = "?metal" }
      { b = -16, mat = "?metal" }
    }

    -- player clip
    {
      { m = "clip" }
      { x =   0, y =   0 }
      { x = 256, y =   0 }
      { x = 256, y = 256 }
      { x =   0, y = 256 }
      { t = 0 }
      { b = -32 }
    }
  }
}


PREFAB.BORKED__COPY_W_LIFT =
{
  placement = "fitted"

  three_d = true,

  x_size = 256,
  y_size = 256,

  brushes =
  {
    ---| low floor |---

    {
      { m = "floor", space = 1 }
      { x = -INF, y = -INF }
      { x =  INF, y = -INF }
      { x =  INF, y =  INF }
      { x = -INF, y =  INF }
    }

    {
      { m = "zone", space = 1 }
      { x = -INF, y = -INF }
      { x =    0, y = -INF }
      { x =    0, y =  INF }
      { x = -INF, y =  INF }
    }

    {
      { m = "zone", space = 1 }
      { x =  256, y = -INF }
      { x =  INF, y = -INF }
      { x =  INF, y =  INF }
      { x =  256, y =  INF }
    }

    {
      { m = "walk", space = 1, dz_high = 144 }
      { x =   0, y =   0 }
      { x = 256, y =   0 }
      { x = 256, y = 256 }
      { x =   0, y = 256 }
      { t = 0 }
    }


    ---| high floor |---

    -- FIXME: implement a "hole" brush
    {
      { m = "floor", space = 2 }
      { x = -INF, y = -INF }
      { x =  INF, y = -INF }
      { x =  INF, y =   64 }
      { x = -INF, y =   64 }
    }

    {
      { m = "floor", space = 2 }
      { x = -INF, y =  192 }
      { x =  INF, y =  192 }
      { x =  INF, y =  INF }
      { x = -INF, y =  INF }
    }

    {
      { m = "floor", space = 2 }
      { x = -INF, y =   64 }
      { x =   64, y =   64 }
      { x =   64, y =  192 }
      { x = -INF, y =  192 }
    }

    {
      { m = "floor", space = 2 }
      { x =  192, y =   64 }
      { x =  INF, y =   64 }
      { x =  INF, y =  192 }
      { x =  192, y =  192 }
    }

    {
      { m = "zone", space = 2 }
      { x = -INF, y = -INF }
      { x =  INF, y = -INF }
      { x =  INF, y =    0 }
      { x = -INF, y =    0 }
    }

    {
      { m = "zone", space = 2 }
      { x = -INF, y = 256 }
      { x =  INF, y = 256 }
      { x =  INF, y = INF }
      { x = -INF, y = INF }
    }

    {
      { m = "walk", space = 2, dz_low = -16 }
      { x =   0, y =   0 }
      { x = 256, y =   0 }
      { x = 256, y = 256 }
      { x =   0, y = 256 }
      { t = 160 }
    }


    ---| the lift |---

    {
      { x =  64, y =  64, mat = "?metal" }
      { x =  80, y =  64, mat = "?metal" }
      { x =  80, y =  80, mat = "?metal" }
      { x =  64, y =  80, mat = "?metal" }
      { t = 168, mat = "?metal" }
    }

    {
      { x = 176, y =  64, mat = "?metal" }
      { x = 192, y =  64, mat = "?metal" }
      { x = 192, y =  80, mat = "?metal" }
      { x = 176, y =  80, mat = "?metal" }
      { t = 168, mat = "?metal" }
    }

    {
      { x =  64, y = 176, mat = "?metal" }
      { x =  80, y = 176, mat = "?metal" }
      { x =  80, y = 192, mat = "?metal" }
      { x =  64, y = 192, mat = "?metal" }
      { t = 168, mat = "?metal" }
    }

    {
      { x = 176, y = 176, mat = "?metal" }
      { x = 192, y = 176, mat = "?metal" }
      { x = 192, y = 192, mat = "?metal" }
      { x = 176, y = 192, mat = "?metal" }
      { t = 168, mat = "?metal" }
    }
  }

  models =
  {
    {
      x1 = 128, x2 = 192, x_face = { mat="METAL1_2" }
      y1 =  96, y2 = 192, y_face = { mat="METAL1_2" }
      z1 = 160, z2 = 168, z_face = { mat="PLAT_TOP2" }

      entity =
      {
        ent = "lift", height = "160", -- sounds = 2,
      }
    }
  }
}

