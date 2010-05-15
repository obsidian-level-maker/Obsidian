----------------------------------------------------------------
--  SWITCH PREFABS
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

PREFAB.SMALL_SWITCH =
{
  brushes=
  {
    -- the base
    {
      { x = -40, y = -40, mat = "base" },
      { x =  40, y = -40, mat = "base" },
      { x =  56, y = -24, mat = "base" },
      { x =  56, y =  24, mat = "base" },
      { x =  40, y =  40, mat = "base" },
      { x = -40, y =  40, mat = "base" },
      { x = -56, y =  24, mat = "base" },
      { x = -56, y = -24, mat = "base" },
      { t = 12, light = 0.66, mat = "base" },
    },

    -- switch itself
    {
      { x = -32, y = -8, mat = "switch", kind="?line_kind", tag="?tag", peg=1, x_offset="?x_offset", y_offset="?y_offset" },
      { x =  32, y = -8, mat = "side" },
      { x =  32, y =  8, mat = "side" },
      { x = -32, y =  8, mat = "side" },
      { t = 76, light = 0.66, mat = "side" },
    },
  },
}

