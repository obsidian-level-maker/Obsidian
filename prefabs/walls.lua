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
      { x =   0, y =  0, mat = "?wall" },
      { x = 192, y =  0, mat = "?wall" },
      { x = 192, y = 16, mat = "?wall" },
      { x =   0, y = 16, mat = "?wall" },
    },
  },
}


PREFAB.FENCE =
{
  placement = "fitted",

  brushes =
  {
    {
      { x =   0, y =  0, mat = "?fence" },
      { x = 192, y =  0, mat = "?fence" },
      { x = 192, y = 16, mat = "?fence" },
      { x =   0, y = 16, mat = "?fence" },
      { t =  50,         mat = "?fence" },
    },
  },
}


PREFAB.CORNER =
{
  placement = "fitted",

  brushes =
  {
    {
      { x =  0, y =  0, mat = "?wall" },
      { x = 16, y =  0, mat = "?wall" },
      { x = 16, y = 16, mat = "?wall" },
      { x =  0, y = 16, mat = "?wall" },
    },
  },
}


PREFAB.PICTURE =
{
  placement = "fitted",

---!!!!!!  x_sizes = { {64,1}, {64,"?width"}, {64,1} },
  y_sizes = { {8,1}, {8,0} },
  z_sizes = { {64,"?height"} },

  brushes =
  {
    -- wall behind picture
    {
      { x =   0, y =  0, mat = "?wall" },
      { x = 192, y =  0, mat = "?wall" },
      { x = 192, y =  4, mat = "?wall" },
      { x =   0, y =  4, mat = "?wall" },
    },

    -- picture itself
    {
      { x =  64, y =  4 },
      { x = 128, y =  4 },
      { x = 128, y =  8, mat = "?pic", peg="?peg", x_offset="?x_offset", y_offset="?y_offset", special="?line_kind" },
      { x =  64, y =  8 },
    },

    -- right side wall
    {
      { x = 0, y =  4, mat = "?wall" },
      { x = 8, y =  4, mat = "?wall" },
      { x = 8, y = 16, mat = "?wall" },
      { x = 0, y = 16, mat = "?wall" },
    },

    {
      { x =  8, y =  4, mat = "?wall" },
      { x = 64, y =  4, mat = "?side" },
      { x = 64, y = 16, mat = "?wall" },
      { x =  8, y = 16, mat = "?side" },
    },

    -- left side wall
    {
      { x = 184, y =  4, mat = "?wall" },
      { x = 192, y =  4, mat = "?wall" },
      { x = 192, y = 16, mat = "?wall" },
      { x = 184, y = 16, mat = "?wall" },
    },

    {
      { x = 128, y =  4, mat = "?wall" },
      { x = 184, y =  4, mat = "?side" },
      { x = 184, y = 16, mat = "?wall" },
      { x = 128, y = 16, mat = "?side" },
    },

    -- frame bottom
    {
      { x =  64, y =  4, mat = "?wall" },
      { x = 128, y =  4, mat = "?wall" },
      { x = 128, y = 16, mat = "?wall", blocked=1 },
      { x =  64, y = 16, mat = "?wall" },
      { t = 0, mat = "?floor" },
    },

    -- frame top
    {
      { x =  64, y =  4, mat = "?wall" },
      { x = 128, y =  4, mat = "?wall" },
      { x = 128, y = 16, mat = "?wall", blocked=1 },
      { x =  64, y = 16, mat = "?wall" },
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
      { x = 64, y = 16, mat = "?wall" },
      { x =  0, y = 16, mat = "?wall" },
    },

    -- left side
    {
      { x = 128, y =  0, mat = "?outer" },
      { x = 192, y =  0, mat = "?wall" },
      { x = 192, y = 16, mat = "?wall" },
      { x = 128, y = 16, mat = "?track" },
    },

    -- frame bottom
    {
      { x =  64, y =  0, mat = "?outer" },
      { x = 128, y =  0, mat = "?wall" },
      { x = 128, y = 16, mat = "?wall" },
      { x =  64, y = 16, mat = "?wall" },
      { t = 0, mat = "?outer" },
    },

    -- frame top
    {
      { x =  64, y =  0, mat = "?outer" },
      { x = 128, y =  0, mat = "?wall" },
      { x = 128, y = 16, mat = "?wall" },
      { x =  64, y = 16, mat = "?wall" },
      { b = 64, mat = "?outer" },
    },
  },
}


PREFAB.ITEM_NICHE =
{
  placement = "fitted",

  brushes =
  {
    -- wall behind it
    {
      { x =   0, y =  0, mat = "?wall" },
      { x = 192, y =  0, mat = "?wall" },
      { x = 192, y =  4, mat = "?wall" },
      { x =   0, y =  4, mat = "?wall" },
    },

    -- right side

    {
      { x =  0, y =  4, mat = "?wall" },
      { x = 64, y =  4, mat = "?wall" },
      { x = 32, y = 64, mat = "?wall" },
      { x =  0, y = 64, mat = "?wall" },
    },

    -- left side
    {
      { x = 128, y =  4, mat = "?wall" },
      { x = 192, y =  4, mat = "?wall" },
      { x = 192, y = 64, mat = "?wall" },
      { x = 160, y = 64, mat = "?wall" },
    },

    -- frame bottom
    {
      { x =  64, y =  4, mat = "?wall" },
      { x = 128, y =  4, mat = "?wall" },
      { x = 128, y = 64, mat = "?wall", blocked=1 },
      { x =  64, y = 64, mat = "?wall" },
      { t = 0, mat = "?floor" },
    },

    -- frame top
    {
      { x =  64, y =  4, mat = "?wall" },
      { x = 128, y =  4, mat = "?wall" },
      { x = 128, y = 64, mat = "?wall", blocked=1 },
      { x =  64, y = 64, mat = "?wall" },
      { b = 64, mat = "?wall", light = "?light", special = "?special"  },
    },
  },

  entities =
  {
    { x = 96, y = 48, z = 0, ent = "?item", angle = 90 },
  },
}


PREFAB.CORNER_NICHE =
{
  placement = "fitted",

  brushes =
  {
    -- walls
    {
      { x =  0, y =  0, mat = "?wall" },
      { x = 64, y =  0, mat = "?wall" },
      { x = 64, y =  4, mat = "?wall" },
      { x =  0, y =  4, mat = "?wall" },
    },

    {
      { x =   0, y =  4, mat = "?wall" },
      { x =   4, y =  4, mat = "?wall" },
      { x =   4, y = 64, mat = "?wall" },
      { x =   0, y = 64, mat = "?wall" },
    },

    -- bottom
    {
      { x =   4, y =  4, mat = "?wall" },
      { x =  64, y =  4, mat = "?wall" },
      { x =   4, y = 64, mat = "?wall" },
      { t = 0, mat = "?wall" },
    },

    -- top
    {
      { x =   4, y =  4, mat = "?wall" },
      { x =  64, y =  4, mat = "?wall" },
      { x =   4, y = 64, mat = "?wall" },
      { x =  64, y =  4, mat = "?wall" },
      { b = 64, mat = "?wall", light = "?light", special = "?special" },
    },
  },

  entities =
  {
    { x = 32, y = 32, z = 0, ent = "?item", angle = 45 },
  },
}

