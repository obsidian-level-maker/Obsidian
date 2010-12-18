----------------------------------------------------------------
--  CORNER PREFABS
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
--  Corner prefabs are built where (0,0) is the corner point
--  of the room, and positive coordinates go into the room
--  (i.e. as if sitting in the S/W corner and facing N/E).
--
----------------------------------------------------------------

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


PREFAB.CORNER_DIAGONAL =
{
  placement = "fitted",

  brushes =
  {
    {
      { x =  0, y =  0, mat = "?wall" },
      { x = 64, y =  0, mat = "?wall" },
      { x = 64, y = 16, mat = "?wall" },
      { x = 16, y = 64, mat = "?wall" },
      { x =  0, y = 64, mat = "?wall" },
    },
  },
}


PREFAB.CORNER_DIAG_W_TORCH =
{
  placement = "fitted",

  defaults =
  {
    light = 128,
    radius = 320,
    style = 0,
  },

  brushes =
  {
    {
      { x =  0, y =  0, mat = "?wall" },
      { x = 64, y =  0, mat = "?wall" },
      { x = 64, y = 16, mat = "?wall" },
      { x = 16, y = 64, mat = "?wall" },
      { x =  0, y = 64, mat = "?wall" },
    },
  },

  entities =
  {
    { x = 40.5, y = 40.5, z = 40, ent = "torch", light = 0, },

    { x = 48, y = 48, z = 48, ent = "light",
      light = "?light", _radius = "?radius", style = "?style",
    },
  },
}


PREFAB.CORNER_CURVED =
{
  placement = "fitted",

  brushes =
  {
    {
      { x =  0, y =  0, mat = "?wall" },
      { x = 48, y =  0, mat = "?wall" },
      { x = 48, y = 16, mat = "?wall" },
      { x = 32, y = 20, mat = "?wall" },
    },

    {
      { x =  0, y =  0, mat = "?wall" },
      { x = 32, y = 20, mat = "?wall" },
      { x = 20, y = 32, mat = "?wall" },
    },

    {
      { x =  0, y =  0, mat = "?wall" },
      { x = 20, y = 32, mat = "?wall" },
      { x = 16, y = 48, mat = "?wall" },
      { x =  0, y = 48, mat = "?wall" },
    },
  },
}


PREFAB.CORNER_CONCAVE_TRI =
{
  placement = "fitted",

  brushes =
  {
    {
      { x =  0, y =  0, mat = "?wall" },
      { x = 16, y =  0, mat = "?wall" },
      { x =  0, y = 16, mat = "?wall" },
    },
  },
}


PREFAB.CORNER_CONCAVE_CURVED =
{
  placement = "fitted",

  brushes =
  {
    {
      { x =  0, y =  0, mat = "?wall" },
      { x = 32, y =  0, mat = "?wall" },
      { x = 28, y = 16, mat = "?wall" },
      { x = 16, y = 28, mat = "?wall" },
      { x =  0, y = 32, mat = "?wall" },
    },
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


PREFAB.CORNER_JUTTING_TORCH =
{
  placement = "fitted",

  brushes =
  {
    -- corner piece
    {
      { x =  0, y =  0, mat = "?wall" },
      { x = 64, y =  0, mat = "?wall" },
      { x = 64, y = 16, mat = "?wall" },
      { x = 16, y = 64, mat = "?wall" },
      { x =  0, y = 64, mat = "?wall" },
    },

    -- air space around jutty bit
    {
      { m = "air" },
      { x =  64, y =  16 },
      { x = 128, y =  80 },
      { x =  80, y = 128 },
      { x =  16, y =  64 },
      { b = 0 },
      { t = 96 },
    },

    -- jutty bit
    {
      { x = 48, y = 32, mat = "?wall" },
      { x = 64, y = 48, mat = "?wall" },
      { x = 48, y = 64, mat = "?wall" },
      { x = 32, y = 48, mat = "?wall" },
      { t = 32, mat = "?wall" },
    },

    {
      { x = 48, y = 64, mat = "?wall" },
      { x = 64, y = 48, mat = "?wall" },
      { x = 80, y = 48, mat = "?wall" },
      { x = 96, y = 64, mat = "?wall" },

      { x = 96, y = 80, mat = "?wall" },
      { x = 80, y = 96, mat = "?wall" },
      { x = 64, y = 96, mat = "?wall" },
      { x = 48, y = 80, mat = "?wall" },
      { t = 32, mat = "?wall" },
    },
  },

  entities =
  {
    { x = 72, y = 72, z = 32, ent = "?torch", angle = 45 },
  },
}

