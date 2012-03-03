----------------------------------------------------------------
--  START PREFABS
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2010-2012 Andrew Apted
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

PREFAB.START_SPOT =
{
  defaults =
  {
    x_offset = 0
    y_offset = 0
    peg = 0
  }

  brushes =
  {
    {
      { x = -32, y = -32, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  32, y = -32, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  32, y =  32, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = -32, y =  32, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { t = 8, mat = "?top" }
    }
  }

  entities =
  {
    { x =   0, y =   0, z = 8, ent = "player1", angle = 270 }
    { x =  36, y =   0, z = 8, ent = "player2", angle = 270 }
    { x = -36, y =   0, z = 8, ent = "player3", angle = 270 }
    { x =   0, y = -36, z = 8, ent = "player4", angle = 270 }
  }
}


PREFAB.START_LEDGE =
{
  fitted = "xy"

  brushes =
  {
    -- wall behind ledge
    {
      { x =   0, y =  0, mat = "?wall" }
      { x = 192, y =  0, mat = "?wall" }
      { x = 192, y = 16, mat = "?wall" }
      { x =   0, y = 16, mat = "?wall" }
    }

    -- ledge
    {
      { x =   0, y = 16, mat = "?wall" }
      { x = 192, y = 16, mat = "?wall" }
      { x = 192, y = 80, mat = "?wall" }
      { x =   0, y = 80, mat = "?wall" }
      { t = 128, y = 80, mat = "?wall" }
    }
  }

  entities =
  {
    { x =  80, y = 48, z = 128, ent = "player1", angle = 90 }
    { x =  40, y = 48, z = 128, ent = "player2", angle = 90 }
    { x = 120, y = 48, z = 128, ent = "player3", angle = 90 }
    { x = 160, y = 48, z = 128, ent = "player4", angle = 90 }
  }
}

