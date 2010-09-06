----------------------------------------------------------------
--  DOOR PREFABS
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

PREFAB.ARCH =
{
  placement = "fitted",

  brushes =
  {
    -- frame
    {
      { x = 192, y =  0, mat = "?outer" },
      { x = 192, y = 48, mat = "?inner" },
      { x = 0,   y = 48, mat = "?outer" },
      { x = 0,   y =  0, mat = "?outer" },
      { b = 128, mat = "?outer" },
    },

    -- left side
    {
      { x = 0,  y =  0, mat = "?outer" },
      { x = 40, y =  0, mat = "?outer" },
      { x = 40, y = 16, mat = "?track" },
      { x = 40, y = 32, mat = "?inner" },
      { x = 40, y = 48, mat = "?inner" },
      { x = 0,  y = 48, mat = "?inner" },
    },

    -- right side
    {
      { x = 192, y = 48, mat = "?inner" },
      { x = 152, y = 48, mat = "?inner" },
      { x = 152, y = 32, mat = "?track" },
      { x = 152, y = 16, mat = "?outer" },
      { x = 152, y =  0, mat = "?outer" },
      { x = 192, y =  0, mat = "?inner" },
    },
  },
}


PREFAB.ARCH2 =
{
  placement = "fitted",

  brushes =
  {
    -- frame
    {
      { x = 192, y =  0, mat = "?outer" },
      { x = 192, y = 48, mat = "?inner" },
      { x = 0,   y = 48, mat = "?outer" },
      { x = 0,   y =  0, mat = "?outer" },
      { b = 128, mat = "?outer" },
    },

    -- left side
    {
      { x = 0,  y =  0, mat = "?outer" },
      { x = 40, y =  0, mat = "?outer" },
      { x = 52, y = 16, mat = "?track" },
      { x = 52, y = 32, mat = "?inner" },
      { x = 40, y = 48, mat = "?inner" },
      { x = 0,  y = 48, mat = "?inner" },
    },

    -- right side
    {
      { x = 192, y = 48, mat = "?inner" },
      { x = 152, y = 48, mat = "?inner" },
      { x = 140, y = 32, mat = "?track" },
      { x = 140, y = 16, mat = "?outer" },
      { x = 152, y =  0, mat = "?outer" },
      { x = 192, y =  0, mat = "?inner" },
    },
  },
}


PREFAB.DOOR =
{
  placement = "fitted",

  brushes =
  {
    -- frame
    {
      { x = 192, y =  0, mat = "?outer" },
      { x = 192, y = 48, mat = "?inner" },
      { x =   0, y = 48, mat = "?outer" },
      { x =   0, y =  0, mat = "?outer" },
      { b = 136, mat = "?frame" },
    },

    -- step
    {
      { x = 192, y =  0, mat = "?step" },
      { x = 192, y = 48, mat = "?step" },
      { x =   0, y = 48, mat = "?step" },
      { x =   0, y =  0, mat = "?step" },
      { t = 8, mat = "?step", light = 0.7 },
    },

    -- door itself
    {
      { x = 160, y = 16, mat = "?door", special="?line_kind", peg=1, x_offset=0, y_offset=0 },
      { x = 160, y = 32, mat = "?door", special="?line_kind", peg=1, x_offset=0, y_offset=0 },
      { x =  32, y = 32, mat = "?door", special="?line_kind", peg=1, x_offset=0, y_offset=0 },
      { x =  32, y = 16, mat = "?door", special="?line_kind", peg=1, x_offset=0, y_offset=0 },
      { b = 24, delta_z=-16, mat = "?door", light = 0.7, tag = "?tag" },
    },

    -- left side
    {
      { x = 32, y = 16, mat = "?track", peg=1, x_offset=0, y_offset=0 },
      { x = 32, y = 32, mat = "?key",   peg=1, x_offset=0, y_offset=0 },
      { x = 14, y = 48, mat = "?key",   peg=1, x_offset=0, y_offset=0 },
      { x = 14, y =  0, mat = "?key",   peg=1, x_offset=0, y_offset=0 },
    },

    {
      { x = 14, y =  0, mat = "?outer" },
      { x = 14, y = 48, mat = "?inner" },
      { x =  0, y = 48, mat = "?outer" },
      { x =  0, y =  0, mat = "?outer" },
    },

    -- right side
    {
      { x = 160, y = 16, mat = "?key",   peg=1, x_offset=0, y_offset=0 },
      { x = 178, y =  0, mat = "?key",   peg=1, x_offset=0, y_offset=0 },
      { x = 178, y = 48, mat = "?key",   peg=1, x_offset=0, y_offset=0 },
      { x = 160, y = 32, mat = "?track", peg=1, x_offset=0, y_offset=0 },
    },

    {
      { x = 178, y =  0, mat = "?outer" },
      { x = 192, y =  0, mat = "?outer" },
      { x = 192, y = 48, mat = "?inner" },
      { x = 178, y = 48, mat = "?outer" },
    },
  },
}


PREFAB.BARS =
{
  placement = "fitted",

  brushes =
  {
    -- step
    {
      { x =   0, y =  0, mat = "?step" },
      { x = 192, y =  0, mat = "?step" },
      { x = 192, y = 48, mat = "?step" },
      { x =   0, y = 48, mat = "?step" },
      { t =   4,         mat = "?step" },
    },

    -- the actual bars
    {
      { x = 18, y = 12, mat = "?bar", peg=1, x_offset=0, y_offset=0 },
      { x = 42, y = 12, mat = "?bar", peg=1, x_offset=0, y_offset=0 },
      { x = 42, y = 36, mat = "?bar", peg=1, x_offset=0, y_offset=0 },
      { x = 18, y = 36, mat = "?bar", peg=1, x_offset=0, y_offset=0 },
      { t = "?height", mat = "?bar", tag="?tag" },
    },
    {
      { x = 62, y = 12, mat = "?bar", peg=1, x_offset=0, y_offset=0 },
      { x = 86, y = 12, mat = "?bar", peg=1, x_offset=0, y_offset=0 },
      { x = 86, y = 36, mat = "?bar", peg=1, x_offset=0, y_offset=0 },
      { x = 62, y = 36, mat = "?bar", peg=1, x_offset=0, y_offset=0 },
      { t = "?height", mat = "?bar", tag="?tag" },
    },
    {
      { x = 106, y = 12, mat = "?bar", peg=1, x_offset=0, y_offset=0 },
      { x = 130, y = 12, mat = "?bar", peg=1, x_offset=0, y_offset=0 },
      { x = 130, y = 36, mat = "?bar", peg=1, x_offset=0, y_offset=0 },
      { x = 106, y = 36, mat = "?bar", peg=1, x_offset=0, y_offset=0 },
      { t = "?height", mat = "?bar", tag="?tag" },
    },
    {
      { x = 150, y = 12, mat = "?bar", peg=1, x_offset=0, y_offset=0 },
      { x = 174, y = 12, mat = "?bar", peg=1, x_offset=0, y_offset=0 },
      { x = 174, y = 36, mat = "?bar", peg=1, x_offset=0, y_offset=0 },
      { x = 150, y = 36, mat = "?bar", peg=1, x_offset=0, y_offset=0 },
      { t = "?height", mat = "?bar", tag="?tag" },
    },
  },
}

