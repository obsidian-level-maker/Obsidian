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
  brushes =
  {
    {
      { x =   0, y =  0, mat = "outer" },
      { x = 192, y =  0, mat = "inner" },
      { x = 192, y = 16, mat = "inner" },
      { x =   0, y = 16, mat = "inner" },
    },
  },
}


PREFAB.CORNER =
{
  brushes =
  {
    {
      { x =  0, y =  0, mat = "outer" },
      { x = 16, y =  0, mat = "inner" },
      { x = 16, y = 16, mat = "inner" },
      { x =  0, y = 16, mat = "outer" },
    },
  },
}


PREFAB.PICTURE =
{
  brushes =
  {
    -- wall behind picture
    {
      { x =   0, y =  0, mat = "outer" },
      { x = 192, y =  0, mat = "inner" },
      { x = 192, y = 12, mat = "inner" },
      { x =   0, y = 12, mat = "inner" },
    },

    -- picture itself
    {
      { x =  64, y = 12 },
      { x = 128, y = 12 },
      { x = 128, y = 16, mat = "pic", peg="?peg", x_offset="?x_offset", y_offset="?y_offset", kind="?line_kind" },
      { x =  64, y = 16 },
    },

    -- right side wall
    {
      { x = 0, y = 12, mat = "inner" },
      { x = 8, y = 12, mat = "inner" },
      { x = 8, y = 24, mat = "inner" },
      { x = 0, y = 24, mat = "inner" },
    },

    {
      { x =  8, y = 12, mat = "inner" },
      { x = 64, y = 12, mat = "side" },
      { x = 64, y = 24, mat = "inner" },
      { x =  8, y = 24, mat = "side" },
    },

    -- left side wall
    {
      { x = 184, y = 12, mat = "inner" },
      { x = 192, y = 12, mat = "inner" },
      { x = 192, y = 24, mat = "inner" },
      { x = 184, y = 24, mat = "inner" },
    },

    {
      { x = 128, y = 12, mat = "inner" },
      { x = 184, y = 12, mat = "side" },
      { x = 184, y = 24, mat = "inner" },
      { x = 128, y = 24, mat = "side" },
    },

    -- frame bottom
    {
      { x = 128, y = 12, mat = "inner" },
      { x = 128, y = 24, mat = "inner" },
      { x =  64, y = 24, mat = "inner", blocked=1 },
      { x =  64, y = 12, mat = "inner" },
      { t = 32, mat = "floor" },
    },

    -- frame top
    {
      { x = 128, y = 12, mat = "inner" },
      { x = 128, y = 24, mat = "inner" },
      { x =  64, y = 24, mat = "inner", blocked=1 },
      { x =  64, y = 12, mat = "inner" },
      { b = 96, light = "?light", mat = "floor" },
    },
  },
}

