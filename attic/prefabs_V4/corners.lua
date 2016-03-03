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
  fitted = "xy"

  brushes =
  {
    {
      { x =  0, y =  0, mat = "?wall" }
      { x = 16, y =  0, mat = "?wall" }
      { x = 16, y = 16, mat = "?wall" }
      { x =  0, y = 16, mat = "?wall" }
    }
  }
}


PREFAB.FAT_CORNER_DIAG =
{
  fitted = "xy"

  defaults =
  {
    ground = "?wall"
  }

  brushes =
  {
    -- solid part
    {
      { x =   0, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y =  64, mat = "?wall" }
      { x =  64, y = 192, mat = "?wall" }
      { x =   0, y = 192, mat = "?wall" }
    }

    -- ground bit
    {
      { x = 192, y =  64, mat = "?ground", blocked=1 }
      { x = 192, y = 192, mat = "?ground", blocked=1 }
      { x =  64, y = 192, mat = "?ground", blocked=1 }
      { t = 0, mat = "?ground" }
    }

    -- sky
    {
      { x = 192, y =  64, mat = "_SKY", blocked=1 }
      { x = 192, y = 192, mat = "_SKY", blocked=1 }
      { x =  64, y = 192, mat = "_SKY", blocked=1 }
      { b = "?sky_h", mat = "_SKY" }
    }

    -- player clip (for Quake)
    {
      { m = "clip" }
      { x = 192, y =  64 }
      { x = 192, y = 192 }
      { x =  64, y = 192 }
    }
  }
}


PREFAB.CORNER_DIAGONAL =
{
  fitted = "xy"

  brushes =
  {
    {
      { x =  0, y =  0, mat = "?wall" }
      { x = 64, y =  0, mat = "?wall" }
      { x = 64, y = 16, mat = "?wall" }
      { x = 16, y = 64, mat = "?wall" }
      { x =  0, y = 64, mat = "?wall" }
    }
  }
}


PREFAB.CORNER_DIAG_W_TORCH =
{
  fitted = "xy"

  defaults =
  {
    light = 128
    style = 0
  }

  brushes =
  {
    {
      { x =  0, y =  0, mat = "?wall" }
      { x = 64, y =  0, mat = "?wall" }
      { x = 64, y = 16, mat = "?wall" }
      { x = 16, y = 64, mat = "?wall" }
      { x =  0, y = 64, mat = "?wall" }
    }

  }

  entities =
  {
    { x = 40.5, y = 40.5, z = 40, ent = "torch", light = 0, }

    { x = 48, y = 48, z = 48, ent = "light",
      light = "?light", style = "?style",
    }
  }
}


PREFAB.CORNER_CURVED =
{
  fitted = "xy"

  brushes =
  {
    {
      { x =  0, y =  0, mat = "?wall" }
      { x = 48, y =  0, mat = "?wall" }
      { x = 48, y = 16, mat = "?wall" }
      { x = 32, y = 20, mat = "?wall" }
    }

    {
      { x =  0, y =  0, mat = "?wall" }
      { x = 32, y = 20, mat = "?wall" }
      { x = 20, y = 32, mat = "?wall" }
    }

    {
      { x =  0, y =  0, mat = "?wall" }
      { x = 20, y = 32, mat = "?wall" }
      { x = 16, y = 48, mat = "?wall" }
      { x =  0, y = 48, mat = "?wall" }
    }
  }
}


PREFAB.CORNER_CONCAVE_TRI =
{
  fitted = "xy"

  brushes =
  {
    {
      { x =  0, y =  0, mat = "?wall" }
      { x = 16, y =  0, mat = "?wall" }
      { x =  0, y = 16, mat = "?wall" }
    }
  }
}


PREFAB.CORNER_CONCAVE_CURVED =
{
  fitted = "xy"

  brushes =
  {
    {
      { x =  0, y =  0, mat = "?wall" }
      { x = 32, y =  0, mat = "?wall" }
      { x = 28, y = 16, mat = "?wall" }
      { x = 16, y = 28, mat = "?wall" }
      { x =  0, y = 32, mat = "?wall" }
    }
  }
}


PREFAB.CORNER_NICHE =
{
  fitted = "xy"

  brushes =
  {
    -- walls
    {
      { x =  0, y =  0, mat = "?wall" }
      { x = 64, y =  0, mat = "?wall" }
      { x = 64, y =  4, mat = "?wall" }
      { x =  0, y =  4, mat = "?wall" }
    }

    {
      { x =   0, y =  4, mat = "?wall" }
      { x =   4, y =  4, mat = "?wall" }
      { x =   4, y = 64, mat = "?wall" }
      { x =   0, y = 64, mat = "?wall" }
    }

    -- bottom
    {
      { x =   4, y =  4, mat = "?wall" }
      { x =  64, y =  4, mat = "?wall" }
      { x =   4, y = 64, mat = "?wall" }
      { t = 0, mat = "?wall" }
    }

    -- top
    {
      { x =   4, y =  4, mat = "?wall" }
      { x =  64, y =  4, mat = "?wall" }
      { x =   4, y = 64, mat = "?wall" }
      { x =  64, y =  4, mat = "?wall" }
      { b = 64, mat = "?wall", light = "?light", special = "?special" }
    }
  }

  entities =
  {
    { x = 32, y = 32, z = 0, ent = "?item", angle = 45 }
  }
}


PREFAB.CORNER_JUTTING_TORCH =
{
  fitted = "xy"

  brushes =
  {
    -- corner piece
    {
      { x =  0, y =  0, mat = "?wall" }
      { x = 64, y =  0, mat = "?wall" }
      { x = 64, y = 16, mat = "?wall" }
      { x = 16, y = 64, mat = "?wall" }
      { x =  0, y = 64, mat = "?wall" }
    }

    -- jutty bit
    {
      { x = 48, y = 32, mat = "?wall" }
      { x = 64, y = 48, mat = "?wall" }
      { x = 48, y = 64, mat = "?wall" }
      { x = 32, y = 48, mat = "?wall" }
      { t = 32, mat = "?wall" }
    }

    {
      { x = 48, y = 64, mat = "?wall" }
      { x = 64, y = 48, mat = "?wall" }
      { x = 80, y = 48, mat = "?wall" }
      { x = 96, y = 64, mat = "?wall" }

      { x = 96, y = 80, mat = "?wall" }
      { x = 80, y = 96, mat = "?wall" }
      { x = 64, y = 96, mat = "?wall" }
      { x = 48, y = 80, mat = "?wall" }
      { t = 32, mat = "?wall" }
    }
  }

  entities =
  {
    { x = 72, y = 72, z = 32, ent = "?torch", angle = 45 }
  }
}

