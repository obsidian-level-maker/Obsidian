----------------------------------------------------------------
--  3D BRIDGE PREFABS
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2011 Andrew Apted
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

PREFAB.BRIDGE_BASIC =
{
  fitted = "xy"

  defaults =
  {
    bridge = "?floor"
  }

  brushes =
  {
    {
      { x =  32, y =   0, mat = "?bridge" }
      { x = 160, y =   0, mat = "?bridge" }
      { x = 160, y = 192, mat = "?bridge" }
      { x =  32, y = 192, mat = "?bridge" }
      { t =   0, mat = "?bridge" }
      { b = -16, mat = "?bridge" }
    }
  }
}


PREFAB.CHANNEL_BASIC =
{
  fitted = "xy"

  repeat_height = 192

  defaults =
  {
    bridge  = "?floor"
    support = "?floor"
    x_offset = 0
  }

  brushes =
  {
    -- left side
    {
      { x =   0, y =   0, mat = "?bridge" }
      { x =  32, y =   0, mat = "?bridge" }
      { x =  32, y = 192, mat = "?bridge" }
      { x =   0, y = 192, mat = "?bridge" }
      { t =   0, mat = "?bridge" }
      { b = -16, mat = "?bridge" }
    }

    -- right side
    {
      { x = 160, y =   0, mat = "?bridge" }
      { x = 192, y =   0, mat = "?bridge" }
      { x = 192, y = 192, mat = "?bridge" }
      { x = 160, y = 192, mat = "?bridge" }
      { t =   0, mat = "?bridge" }
      { b = -16, mat = "?bridge" }
    }

    -- walk on piece
    {
      { x =  32, y =  48, mat = "?bridge" }
      { x = 160, y =  48, mat = "?bridge" }
      { x = 160, y = 144, mat = "?bridge" }
      { x =  32, y = 144, mat = "?bridge" }
      { t =   0, mat = "?bridge" }
      { b = -16, mat = "?bridge" }
    }

    -- supporting pillar
    {
      { x =  88, y =  88, mat = "?support", x_offset="?x_offset" }
      { x = 104, y =  88, mat = "?support", x_offset="?x_offset" }
      { x = 104, y = 104, mat = "?support", x_offset="?x_offset" }
      { x =  88, y = 104, mat = "?support", x_offset="?x_offset" }
      { t =  -8, mat = "?support" }
    }
  }
}

