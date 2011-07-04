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
  placement = "fitted"

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

