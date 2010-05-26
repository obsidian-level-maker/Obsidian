----------------------------------------------------------------
--  WALL PREFABS
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

PREFAB.WALL =
{
  placement = "fitted",

  brushes =
  {
    {
      { x =   0, y =  0, mat = "?outer" },
      { x = 192, y =  0, mat = "?inner" },
      { x = 192, y = 16, mat = "?inner" },
      { x =   0, y = 16, mat = "?inner" },
    },
  },
}


PREFAB.CORNER =
{
  placement = "fitted",

  brushes =
  {
    {
      { x =  0, y =  0, mat = "?outer" },
      { x = 16, y =  0, mat = "?inner" },
      { x = 16, y = 16, mat = "?inner" },
      { x =  0, y = 16, mat = "?outer" },
    },
  },
}


PREFAB.PICTURE =
{
  placement = "fitted",

  x_sizes = { {64,1}, {64,"?width"}, {64,1} },
  y_sizes = { {8,1}, {8,0} },
  z_sizes = { {64,"?height"} },

  brushes =
  {
    -- wall behind picture
    {
      { x =   0, y =  0, mat = "?outer" },
      { x = 192, y =  0, mat = "?inner" },
      { x = 192, y =  4, mat = "?inner" },
      { x =   0, y =  4, mat = "?inner" },
    },

    -- picture itself
    {
      { x =  64, y =  4 },
      { x = 128, y =  4 },
      { x = 128, y =  8, mat = "?pic", peg="?peg", x_offset="?x_offset", y_offset="?y_offset", kind="?line_kind" },
      { x =  64, y =  8 },
    },

    -- right side wall
    {
      { x = 0, y =  4, mat = "?inner" },
      { x = 8, y =  4, mat = "?inner" },
      { x = 8, y = 16, mat = "?inner" },
      { x = 0, y = 16, mat = "?inner" },
    },

    {
      { x =  8, y =  4, mat = "?inner" },
      { x = 64, y =  4, mat = "?side" },
      { x = 64, y = 16, mat = "?inner" },
      { x =  8, y = 16, mat = "?side" },
    },

    -- left side wall
    {
      { x = 184, y =  4, mat = "?inner" },
      { x = 192, y =  4, mat = "?inner" },
      { x = 192, y = 16, mat = "?inner" },
      { x = 184, y = 16, mat = "?inner" },
    },

    {
      { x = 128, y =  4, mat = "?inner" },
      { x = 184, y =  4, mat = "?side" },
      { x = 184, y = 16, mat = "?inner" },
      { x = 128, y = 16, mat = "?side" },
    },

    -- frame bottom
    {
      { x =  64, y =  4, mat = "?inner" },
      { x = 128, y =  4, mat = "?inner" },
      { x = 128, y = 16, mat = "?inner", blocked=1 },
      { x =  64, y = 16, mat = "?inner" },
      { t = 0, mat = "?floor" },
    },

    -- frame top
    {
      { x =  64, y =  4, mat = "?inner" },
      { x = 128, y =  4, mat = "?inner" },
      { x = 128, y = 16, mat = "?inner", blocked=1 },
      { x =  64, y = 16, mat = "?inner" },
      { b = 64, mat = "?floor", light = "?light"  },
    },
  },
}


PREFAB.WINDOW =
{
  placement = "fitted",

  brushes =
  {
    -- right side
    {
      { x =  0, y =  0, mat = "?outer" },
      { x = 64, y =  0, mat = "?track" },
      { x = 64, y = 16, mat = "?inner" },
      { x =  0, y = 16, mat = "?inner" },
    },

    -- left side
    {
      { x = 128, y =  0, mat = "?outer" },
      { x = 192, y =  0, mat = "?inner" },
      { x = 192, y = 16, mat = "?inner" },
      { x = 128, y = 16, mat = "?track" },
    },

    -- frame bottom
    {
      { x =  64, y =  0, mat = "?outer" },
      { x = 128, y =  0, mat = "?inner" },
      { x = 128, y = 16, mat = "?inner" },
      { x =  64, y = 16, mat = "?inner" },
      { t = 0, mat = "?outer" },
    },

    -- frame top
    {
      { x =  64, y =  0, mat = "?outer" },
      { x = 128, y =  0, mat = "?inner" },
      { x = 128, y = 16, mat = "?inner" },
      { x =  64, y = 16, mat = "?inner" },
      { b = 64, mat = "?outer" },
    },
  },
}

