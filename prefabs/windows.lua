----------------------------------------------------------------
--  WINDOW PREFABS
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


