----------------------------------------------------------------
--  STAIR and LIFT PREFABS
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
--
--  Stairs travel NORTH to SOUTH, north side (dir = 8) is lowest
--  and south side (dir = 2) is highest side in the unrotated
--  prefab.
--
--  There are four main kinds:
--     "short"    32 unit stair  (down to 24, up to 40)
--     "medium"   64 unit stair  (down to 48, up to 80)
--     "tall"    128 unit stair  (down to 88, up to 160)
--
--     "lift"    can be any size >= 40
--
----------------------------------------------------------------


PREFAB.MINI_STAIR_1A =
{
  -- a single step, meant to sit where a hallway meets a room

  fitted = "xy"

  defaults =
  {
    step_h = 8
  }

  brushes =
  {
    {
      { x =   0, y =  0, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x = 192, y =  0, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x = 160, y = 32, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x =  32, y = 32, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { t = "?step_h", mat = "?floor" }
    }
  }
}



PREFAB.STAIR_6 =
{
  fitted = "xy"

  z_ranges = { {128,0,"?stair_h"} }

  brushes =
  {
    {
      { m = "solid" }
      { x =  48, y =  0, mat = "?side" }
      { x = 144, y =  0, mat = "?side" }
      { x = 144, y = 12, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x =  48, y = 12, mat = "?side" }
      { t = 109, mat = "?top" }
    }

    {
      { m = "solid" }
      { x =  48, y = 12, mat = "?side" }
      { x = 144, y = 12, mat = "?side" }
      { x = 144, y = 24, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x =  48, y = 24, mat = "?side" }
      { t = 91, mat = "?top" }
    }

    {
      { m = "solid" }
      { x =  48, y = 24, mat = "?side" }
      { x = 144, y = 24, mat = "?side" }
      { x = 144, y = 36, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x =  48, y = 36, mat = "?side" }
      { t = 73, mat = "?top" }
    }

    {
      { m = "solid" }
      { x =  48, y = 36, mat = "?side" }
      { x = 144, y = 36, mat = "?side" }
      { x = 144, y = 48, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x =  48, y = 48, mat = "?side" }
      { t = 54, mat = "?top" }
    }

    {
      { m = "solid" }
      { x =  48, y = 48, mat = "?side" }
      { x = 144, y = 48, mat = "?side" }
      { x = 144, y = 60, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x =  48, y = 60, mat = "?side" }
      { t = 36, mat = "?top" }
    }

    {
      { m = "solid" }
      { x =  48, y = 60, mat = "?side" }
      { x = 144, y = 60, mat = "?side" }
      { x = 144, y = 72, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x =  48, y = 72, mat = "?side" }
      { t = 18, mat = "?top" }
    }

    -- bounding box on Z axis
    {
      { m = "bbox" }
      { b = 0 }
      { t = 128 }
    }

-- [[    -- surrounding floor  FIXME: keep???
    {
      { x =   0, y=   0, mat = "?floor" }
      { x = 192, y=   0, mat = "?floor" }
      { x = 192, y= 192, mat = "?floor" }
      { x =   0, y= 192, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }
--]]
  }
}


PREFAB.NICHE_STAIR_8 =
{
  fitted = "xy"

  brushes =
  {
    -- niche
    {
      { x =  0, y =   0, mat = "?wall" }
      { x = 24, y =   0, mat = "?wall" }
      { x = 24, y = 192, mat = "?wall" }
      { x =  0, y = 192, mat = "?wall" }
      { t = 128, mat = "?floor" }
    }

    {
      { x = 168, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y = 192, mat = "?wall" }
      { x = 168, y = 192, mat = "?wall" }
      { t = 128, mat = "?floor" }
    }

    {
      { x =  24, y =  0, mat = "?wall" }
      { x = 168, y =  0, mat = "?wall" }
      { x = 168, y = 32, mat = "?wall" }
      { x =  24, y = 32, mat = "?wall" }
      { t = 128, mat = "?floor" }
    }

    -- [[
    -- porch   FIXME: keep this?
    {
      { x =  24, y = 160, mat = "?wall" }
      { x = 168, y = 160, mat = "?wall" }
      { x = 168, y = 192, mat = "?wall" }
      { x =  24, y = 192, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    --]]

    -- steps
    {
      { x =  24, y = 32, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x = 168, y = 32, mat = "?side" }
      { x = 168, y = 48, mat = "?step" }
      { x =  24, y = 48, mat = "?side" }
      { t = 113, mat = "?top" }
    }

    {
      { x =  24, y = 48, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x = 168, y = 48, mat = "?side" }
      { x = 168, y = 64, mat = "?step" }
      { x =  24, y = 64, mat = "?side" }
      { t = 99, mat = "?top" }
    }

    {
      { x =  24, y = 64, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x = 168, y = 64, mat = "?side" }
      { x = 168, y = 80, mat = "?step" }
      { x =  24, y = 80, mat = "?side" }
      { t = 85, mat = "?top" }
    }

    {
      { x =  24, y = 80, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x = 168, y = 80, mat = "?side" }
      { x = 168, y = 96, mat = "?step" }
      { x =  24, y = 96, mat = "?side" }
      { t = 71, mat = "?top" }
    }

    {
      { x =  24, y = 96, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x = 168, y = 96, mat = "?side" }
      { x = 168, y = 112, mat = "?step" }
      { x =  24, y = 112, mat = "?side" }
      { t = 56, mat = "?top" }
    }

    {
      { x =  24, y = 112, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x = 168, y = 112, mat = "?side" }
      { x = 168, y = 128, mat = "?step" }
      { x =  24, y = 128, mat = "?side" }
      { t = 42, mat = "?top" }
    }

    {
      { x =  24, y = 128, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x = 168, y = 128, mat = "?side" }
      { x = 168, y = 144, mat = "?step" }
      { x =  24, y = 144, mat = "?side" }
      { t = 28, mat = "?top" }
    }

    {
      { x =  24, y = 144, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x = 168, y = 144, mat = "?side" }
      { x = 168, y = 160, mat = "?step" }
      { x =  24, y = 160, mat = "?side" }
      { t = 14, mat = "?top" }
    }
  }
}


PREFAB.STAIR_W_SIDES =
{
  fitted = "xy"

  brushes =
  {
    {
      { x =  48, y =   0, mat = "?wall" }
      { x = 144, y =   0, mat = "?wall" }
      { x = 144, y =  16, mat = "?step", y_offset=0, peg=1 }
      { x =  48, y =  16, mat = "?wall" }
      { t = 56, mat = "?top" }
    }

    {
      { x =  48, y =  76, mat = "?wall" }
      { x = 144, y =  76, mat = "?wall" }
      { x = 144, y =  88, mat = "?step", y_offset=0, peg=1 }
      { x =  48, y =  88, mat = "?wall" }
      { t = 8, mat = "?top" }
    }

    {
      { x =  32, y =  76, mat = "?metal" }
      { x =  48, y =  76, mat = "?metal" }
      { x =  48, y =  88, mat = "?metal" }
      { x =  32, y =  88, mat = "?metal" }
      { t = 40, mat = "?metal" }
    }

    {
      { x = 144, y =   0, mat = "?metal" }
      { x = 160, y =   0, mat = "?metal" }
      { x = 160, y =  28, mat = "?metal" }
      { x = 144, y =  28, mat = "?metal" }
      { t = 80, mat = "?metal" }
    }

    {
      { x =  32, y =  88, mat = "?metal" }
      { x =  48, y =  88, mat = "?metal" }
      { x =  48, y = 104, mat = "?metal" }
      { x =  32, y = 104, mat = "?metal" }
      { t = 32, mat = "?metal" }
    }

    {
      { x =  32, y =   0, mat = "?metal" }
      { x =  48, y =   0, mat = "?metal" }
      { x =  48, y =  28, mat = "?metal" }
      { x =  32, y =  28, mat = "?metal" }
      { t = 80, mat = "?metal" }
    }

    {
      { x = 144, y =  76, mat = "?metal" }
      { x = 160, y =  76, mat = "?metal" }
      { x = 160, y =  88, mat = "?metal" }
      { x = 144, y =  88, mat = "?metal" }
      { t = 40, mat = "?metal" }
    }

    {
      { x = 144, y =  88, mat = "?metal" }
      { x = 160, y =  88, mat = "?metal" }
      { x = 160, y = 104, mat = "?metal" }
      { x = 144, y = 104, mat = "?metal" }
      { t = 32, mat = "?metal" }
    }

    {
      { x =  48, y =  64, mat = "?wall" }
      { x = 144, y =  64, mat = "?wall" }
      { x = 144, y =  76, mat = "?step", y_offset=0, peg=1 }
      { x =  48, y =  76, mat = "?wall" }
      { t = 16, mat = "?top" }
    }

    {
      { x =  32, y =  64, mat = "?metal" }
      { x =  48, y =  64, mat = "?metal" }
      { x =  48, y =  76, mat = "?metal" }
      { x =  32, y =  76, mat = "?metal" }
      { t = 48, mat = "?metal" }
    }

    {
      { x =  48, y =  52, mat = "?wall" }
      { x = 144, y =  52, mat = "?wall" }
      { x = 144, y =  64, mat = "?step", y_offset=0, peg=1 }
      { x =  48, y =  64, mat = "?wall" }
      { t = 24, mat = "?top" }
    }

    {
      { x =  32, y =  52, mat = "?metal" }
      { x =  48, y =  52, mat = "?metal" }
      { x =  48, y =  64, mat = "?metal" }
      { x =  32, y =  64, mat = "?metal" }
      { t = 56, mat = "?metal" }
    }

    {
      { x = 144, y =  64, mat = "?metal" }
      { x = 160, y =  64, mat = "?metal" }
      { x = 160, y =  76, mat = "?metal" }
      { x = 144, y =  76, mat = "?metal" }
      { t = 48, mat = "?metal" }
    }

    {
      { x =  48, y =  40, mat = "?wall" }
      { x = 144, y =  40, mat = "?wall" }
      { x = 144, y =  52, mat = "?step", y_offset=0, peg=1 }
      { x =  48, y =  52, mat = "?wall" }
      { t = 32, mat = "?top" }
    }

    {
      { x =  32, y =  40, mat = "?metal" }
      { x =  48, y =  40, mat = "?metal" }
      { x =  48, y =  52, mat = "?metal" }
      { x =  32, y =  52, mat = "?metal" }
      { t = 64, mat = "?metal" }
    }

    {
      { x = 144, y =  52, mat = "?metal" }
      { x = 160, y =  52, mat = "?metal" }
      { x = 160, y =  64, mat = "?metal" }
      { x = 144, y =  64, mat = "?metal" }
      { t = 56, mat = "?metal" }
    }

    {
      { x =  48, y =  28, mat = "?wall" }
      { x = 144, y =  28, mat = "?wall" }
      { x = 144, y =  40, mat = "?step", y_offset=0, peg=1 }
      { x =  48, y =  40, mat = "?wall" }
      { t = 40, mat = "?top" }
    }

    {
      { x =  32, y =  28, mat = "?metal" }
      { x =  48, y =  28, mat = "?metal" }
      { x =  48, y =  40, mat = "?metal" }
      { x =  32, y =  40, mat = "?metal" }
      { t = 72, mat = "?metal" }
    }

    {
      { x = 144, y =  40, mat = "?wall" }
      { x = 160, y =  40, mat = "?metal" }
      { x = 160, y =  52, mat = "?metal" }
      { x = 144, y =  52, mat = "?metal" }
      { t = 64, mat = "?metal" }
    }

    {
      { x =  48, y =  16, mat = "?wall" }
      { x = 144, y =  16, mat = "?wall" }
      { x = 144, y =  28, mat = "?step", y_offset=0, peg=1 }
      { x =  48, y =  28, mat = "?wall" }
      { t = 48, mat = "?top" }
    }

    {
      { x = 144, y =  28, mat = "?metal" }
      { x = 160, y =  28, mat = "?metal" }
      { x = 160, y =  40, mat = "?metal" }
      { x = 144, y =  40, mat = "?metal" }
      { t = 72, mat = "?metal" }
    }

-- [[    -- surrounding floor  FIXME: keep???
    {
      { x =   0, y=   0, mat = "?floor" }
      { x = 192, y=   0, mat = "?floor" }
      { x = 192, y= 192, mat = "?floor" }
      { x =   0, y= 192, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }
--]]
  }
}



PREFAB.STAIR_TRIANGLE =
{
  fitted = "xy"

  brushes =
  {
    {
      { x =  16, y =   0, mat = "?top" }
      { x = 176, y =   0, mat = "?step", peg=1, y_offset=0 }
      { x =  96, y = 160, mat = "?step", peg=1, y_offset=0 }
      { t = 12, mat = "?top" }
    }

    {
      { x =  32, y =   0, mat = "?top" }
      { x = 160, y =   0, mat = "?step", peg=1, y_offset=0 }
      { x =  96, y = 128, mat = "?step", peg=1, y_offset=0 }
      { t = 24, mat = "?top" }
    }

    {
      { x =  48, y =   0, mat = "?top" }
      { x = 144, y =   0, mat = "?step", peg=1, y_offset=0 }
      { x =  96, y =  96, mat = "?step", peg=1, y_offset=0 }
      { t = 36, mat = "?top" }
    }

    {
      { x =  64, y =   0, mat = "?top" }
      { x = 128, y =   0, mat = "?step", peg=1, y_offset=0 }
      { x =  96, y =  64, mat = "?step", peg=1, y_offset=0 }
      { t = 48, mat = "?top" }
    }

    {
      { x =  80, y =   0, mat = "?top" }
      { x = 112, y =   0, mat = "?step", peg=1, y_offset=0 }
      { x =  96, y =  32, mat = "?step", peg=1, y_offset=0 }
      { t = 60, mat = "?top" }
    }

-- [[    -- surrounding floor  FIXME: keep???
    {
      { x =   0, y=   0, mat = "?floor" }
      { x = 192, y=   0, mat = "?floor" }
      { x = 192, y= 192, mat = "?floor" }
      { x =   0, y= 192, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }
--]]
  }
}


PREFAB.STAIR_CIRCLE =
{
  fitted = "xy"

  brushes =
  {
    {
      { x =  12, y =   0, mat = "?top" }
      { x = 180, y =   0, mat = "?step", y_offset=0, peg=1 }
      { x = 172, y =  48, mat = "?step", y_offset=0, peg=1 }
      { x = 144, y =  80, mat = "?step", y_offset=0, peg=1 }
      { x = 112, y =  96, mat = "?step", y_offset=0, peg=1 }
      { x =  80, y =  96, mat = "?step", y_offset=0, peg=1 }
      { x =  48, y =  80, mat = "?step", y_offset=0, peg=1 }
      { x =  20, y =  48, mat = "?step", y_offset=0, peg=1 }
      { t = 13, mat = "?top" }
    }

    {
      { x =  32, y =   0, mat = "?top" }
      { x = 160, y =   0, mat = "?step", peg=1, y_offset=0 }
      { x = 152, y =  36, mat = "?step", peg=1, y_offset=0 }
      { x = 128, y =  60, mat = "?step", peg=1, y_offset=0 }
      { x =  96, y =  68, mat = "?step", peg=1, y_offset=0 }
      { x =  64, y =  60, mat = "?step", peg=1, y_offset=0 }
      { x =  40, y =  36, mat = "?step", peg=1, y_offset=0 }
      { t = 26, mat = "?top" }
    }

    {
      { x =  52, y =   0, mat = "?top" }
      { x = 140, y =   0, mat = "?step", peg=1, y_offset=0 }
      { x = 128, y =  32, mat = "?step", peg=1, y_offset=0 }
      { x =  96, y =  44, mat = "?step", peg=1, y_offset=0 }
      { x =  64, y =  32, mat = "?step", peg=1, y_offset=0 }
      { t = 39, mat = "?top" }
    }

    {
      { x =  72, y =   0, mat = "?top" }
      { x = 120, y =   0, mat = "?step", peg=1, y_offset=0 }
      { x = 112, y =  16, mat = "?step", peg=1, y_offset=0 }
      { x =  96, y =  24, mat = "?step", peg=1, y_offset=0 }
      { x =  80, y =  16, mat = "?step", peg=1, y_offset=0 }
      { t = 52, mat = "?top" }
    }

-- [[    -- surrounding floor  FIXME: keep???
    {
      { x =   0, y=   0, mat = "?floor" }
      { x = 192, y=   0, mat = "?floor" }
      { x = 192, y= 192, mat = "?floor" }
      { x =   0, y= 192, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }
--]]
  }
}



PREFAB.LOW_CURVE_STAIR =
{
  brushes =
  {
    -- post
    {
      { x =  0, y =  0, mat = "?wall" }
      { x = 24, y =  0, mat = "?wall" }
      { x = 24, y = 24, mat = "?wall" }
      { x =  0, y = 24, mat = "?wall" }
      { t = 128, mat = "?floor" }
    }

    -- surrounding bit (L shape)
    {
      { x =   0, y = 176, mat = "?wall" }
      { x = 192, y = 176, mat = "?wall" }
      { x = 192, y = 192, mat = "?wall" }
      { x =   0, y = 192, mat = "?wall" }
      { t = 128, mat = "?floor" }
    }

    {
      { x = 176, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y = 192, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
      { t = 128, mat = "?floor" }
    }

    -- steps
    {
      { x =  24, y =  0, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x = 176, y =  0, mat = "?wall" }
      { x = 176, y = 64, mat = "?wall" }
      { x =  24, y = 12, mat = "?wall" }
      { t = 21, mat = "?top" }
    }

    {
      { x =  24, y =  12, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x = 176, y =  64, mat = "?wall" }
      { x = 176, y = 128, mat = "?wall" }
      { x =  24, y =  24, mat = "?wall" }
      { t = 42, mat = "?top" }
    }

    {
      { x =  24, y =  24, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x = 176, y = 128, mat = "?wall" }
      { x = 176, y = 176, mat = "?wall" }
      { x = 128, y = 176, mat = "?wall" }
      { t = 64, mat = "?top" }
    }

    {
      { x =  24, y =  24, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x = 128, y = 176, mat = "?wall" }
      { x =  64, y = 176, mat = "?wall" }
      { x =  12, y =  24, mat = "?wall" }
      { t = 85, mat = "?top" }
    }

    {
      { x =  12, y =  24, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x =  64, y = 176, mat = "?wall" }
      { x =   0, y = 176, mat = "?wall" }
      { x =   0, y =  24, mat = "?wall" }
      { t = 106, mat = "?top" }
    }
  }
}


PREFAB.QUAKE_3D_STAIR =
{
  brushes =
  {
    {
      { x =  48, y =  8, mat = "?wall" }
      { x = 144, y =  8, mat = "?wall" }
      { x = 144, y = 20, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x =  48, y = 20, mat = "?wall" }
      { b =  98, mat = "?top" }
      { t = 110, mat = "?top" }
    }

    {
      { x =  48, y = 28, mat = "?wall" }
      { x = 144, y = 28, mat = "?wall" }
      { x = 144, y = 40, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x =  48, y = 40, mat = "?wall" }
      { b = 80, mat = "?top" }
      { t = 92, mat = "?top" }
    }

    {
      { x =  48, y = 48, mat = "?wall" }
      { x = 144, y = 48, mat = "?wall" }
      { x = 144, y = 60, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x =  48, y = 60, mat = "?wall" }
      { b = 62, mat = "?top" }
      { t = 74, mat = "?top" }
    }

    {
      { x =  48, y = 68, mat = "?wall" }
      { x = 144, y = 68, mat = "?wall" }
      { x = 144, y = 80, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x =  48, y = 80, mat = "?wall" }
      { b = 44, mat = "?top" }
      { t = 56, mat = "?top" }
    }

    {
      { x =  48, y =  88, mat = "?wall" }
      { x = 144, y =  88, mat = "?wall" }
      { x = 144, y = 100, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x =  48, y = 100, mat = "?wall" }
      { b = 26, mat = "?top" }
      { t = 38, mat = "?top" }
    }

    {
      { x =  48, y = 108, mat = "?wall" }
      { x = 144, y = 108, mat = "?wall" }
      { x = 144, y = 120, mat = "?step", peg=1, x_offset=0, y_offset=0 }
      { x =  48, y = 120, mat = "?wall" }
      { b =  8, mat = "?top" }
      { t = 20, mat = "?top" }
    }

    -- surrounding floor  FIXME: keep???
    {
      { x =   0, y=   0, mat = "?floor" }
      { x = 192, y=   0, mat = "?floor" }
      { x = 192, y= 192, mat = "?floor" }
      { x =   0, y= 192, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }
  }
}


--------------------------------------------------------------------


PREFAB.LIFT_UP =
{
  fitted = "xy"

  defaults =
  {
    speed = 32
    delay = 105
  }

  brushes =
  {
    -- lift itself
    {
      { x =  32, y =  0, mat = "?lift", special="?walk_kind",   act="WR", tag="?tag", arg1="?tag", arg2="?speed", arg3="?delay", peg=1, x_offset=0, y_offset=0 }
      { x = 160, y =  0, mat = "?lift", special="?switch_kind", act="SR", tag="?tag", arg1="?tag", arg2="?speed", arg3="?delay", peg=1, x_offset=0, y_offset=0 }
      { x = 160, y = 64, mat = "?lift", special="?switch_kind", act="SR", tag="?tag", arg1="?tag", arg2="?speed", arg3="?delay", peg=1, x_offset=0, y_offset=0 }
      { x =  32, y = 64, mat = "?lift", special="?switch_kind", act="SR", tag="?tag", arg1="?tag", arg2="?speed", arg3="?delay", peg=1, x_offset=0, y_offset=0 }
      { t = 130, mat = "?top", tag = "?tag" }
    }

    -- surrounding floor
    {
      { x =   0, y=   0, mat = "?floor" }
      { x = 192, y=   0, mat = "?floor" }
      { x = 192, y= 192, mat = "?floor" }
      { x =   0, y= 192, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }
  }
}


PREFAB.LIFT_DOWN =
{
  fitted = "xy"

  defaults =
  {
    speed = 32
    delay = 105
  }

  brushes =
  {
    -- lift itself
    {
      { x =  32, y = 128, mat = "?lift", special="?walk_kind",   act="WR", tag="?tag", arg1="?tag", arg2="?speed", arg3="?delay", peg=1, x_offset=0, y_offset=0 }
      { x = 160, y = 128, mat = "?lift", special="?walk_kind",   act="WR", tag="?tag", arg1="?tag", arg2="?speed", arg3="?delay", peg=1, x_offset=0, y_offset=0 }
      { x = 160, y = 192, mat = "?lift", special="?switch_kind", act="SR", tag="?tag", arg1="?tag", arg2="?speed", arg3="?delay", peg=1, x_offset=0, y_offset=0 }
      { x =  32, y = 192, mat = "?lift", special="?walk_kind",   act="WR", tag="?tag", arg1="?tag", arg2="?speed", arg3="?delay", peg=1, x_offset=0, y_offset=0 }
      { t = 130, mat = "?top", tag = "?tag" }
    }

    -- surrounding floor
    {
      { x =  0, y=   0, mat = "?floor" }
      { x = 32, y=   0, mat = "?floor" }
      { x = 32, y= 192, mat = "?floor" }
      { x =  0, y= 192, mat = "?floor" }
      { t = 128, mat = "?floor" }
    }

    {
      { x = 160, y=   0, mat = "?floor" }
      { x = 192, y=   0, mat = "?floor" }
      { x = 192, y= 192, mat = "?floor" }
      { x = 160, y= 192, mat = "?floor" }
      { t = 128, mat = "?floor" }
    }

    {
      { x =   0, y=   0, mat = "?floor" }
      { x = 192, y=   0, mat = "?floor" }
      { x = 192, y= 128, mat = "?floor" }
      { x =   0, y= 128, mat = "?floor" }
      { t = 128, mat = "?floor" }
    }
  }
}


PREFAB.QUAKE_LIFT_UP =
{
  fitted = "xy"

  x_ranges = { {32,1}, {128,0}, {32,1} }
  y_ranges = { {128,0}, {64,1} }
  z_ranges = { {128,1} }

  defaults =
  {
    lift_flags = ""
  }

  brushes =
  {
    -- surrounding floor
    {
      { x =   0, y=   0, mat = "?floor" }
      { x = 192, y=   0, mat = "?floor" }
      { x = 192, y= 192, mat = "?floor" }
      { x =   0, y= 192, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }

    -- set top of bounding box
    {
      { m="bbox" }
      { t = 128 }
    }
  }

  models =
  {
    -- lift itself
    {
      x1 =  32, x2 = 160, x_face = { mat="?lift" }
      y1 =   0, y2 = 128, y_face = { mat="?lift" }
      z1 = 128, z2 = 144, z_face = { mat="?lift" }

      delta_z = -8 

      entity =
      {
        ent = "lift", sounds = 2, height = 128,
        spawnflags = "?lift_flags"
      }
    }
  }
}


PREFAB.QUAKE_LIFT_DOWN =
{
  fitted = "xy"

  x_ranges = { {32,1}, {128,0}, {32,1} }
  y_ranges = { {64,1},  {64,0}, {64,1} }
  z_ranges = { {128,1} }

  defaults =
  {
    low_floor = "?floor"
    lift_flags = ""
  }

  brushes =
  {
    -- low floor
    {
      { x =  32, y=  64, mat = "?low_floor" }
      { x = 160, y=  64, mat = "?low_floor" }
      { x = 160, y= 192, mat = "?low_floor" }
      { x =  32, y= 192, mat = "?low_floor" }
      { t = 0, mat = "?low_floor" }
    }

    -- surrounding floor
    {
      { x =  0, y=   0, mat = "?floor" }
      { x = 32, y=   0, mat = "?floor" }
      { x = 32, y= 192, mat = "?floor" }
      { x =  0, y= 192, mat = "?floor" }
      { t = 128, mat = "?floor" }
    }

    {
      { x = 160, y=   0, mat = "?floor" }
      { x = 192, y=   0, mat = "?floor" }
      { x = 192, y= 192, mat = "?floor" }
      { x = 160, y= 192, mat = "?floor" }
      { t = 128, mat = "?floor" }
    }

    {
      { x =  32, y=  0, mat = "?floor" }
      { x = 160, y=  0, mat = "?floor" }
      { x = 160, y= 64, mat = "?floor" }
      { x =  32, y= 64, mat = "?floor" }
      { t = 128, mat = "?floor" }
    }

    -- set top of bounding box
    {
      { m="bbox" }
      { t = 128 }
    }
  }

  models =
  {
    -- lift itself
    {
      x1 =  32, x2 = 160, x_face = { mat="?lift" }
      y1 =  64, y2 = 128, y_face = { mat="?lift" }
      z1 = 128, z2 = 144, z_face = { mat="?lift" }

      delta_z = -8 

      entity =
      {
        ent = "lift", sounds = 2, height = 128,
        spawnflags = "?lift_flags"
      }
    }
  }
}


PREFAB.STAIR_180 =
{
  fitted = "xy"

  defaults =
  {
    step = "?wall"
  }

  brushes =
  {
    {
      { x =   0, y =   0, mat = "?outer" }
      { x =  16, y =   0, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { x =   0, y = 192, mat = "?outer" }
    }

    {
      { x = 176, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y = 192, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
    }

    {
      { x =  16, y = 176, mat = "?wall" }
      { x =  88, y = 176, mat = "?wall" }
      { x =  88, y = 192, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }

    {
      { x =  16, y =  16, mat = "?wall" }
      { x = 176, y =  16, mat = "?wall" }
      { x = 176, y =  80, mat = "?wall" }
      { x =  88, y =  80, mat = "?step" }
      { x =  16, y =  80, mat = "?wall" }
      { t = 56, mat = "?floor" }
    }
    {
      { x =  16, y =  16, mat = "?wall" }
      { x = 176, y =  16, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { b = 224, mat = "?wall" }
    }

    {
      { x =  16, y =   0, mat = "?outer" }
      { x = 176, y =   0, mat = "?wall" }
      { x = 176, y =  16, mat = "?wall" }
      { x =  16, y =  16, mat = "?wall" }
    }

    {
      { x = 104, y = 176, mat = "?step" }
      { x = 176, y = 176, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
      { x = 104, y = 192, mat = "?wall" }
      { t = 112, mat = "?floor" }
    }

    {
      { x =  88, y =  80, mat = "?wall" }
      { x = 104, y =  80, mat = "?wall" }
      { x = 104, y = 192, mat = "?wall" }
      { x =  88, y = 192, mat = "?wall" }
      { t = 128, mat = "?floor" }
    }

    {
      { x =  16, y =  80, mat = "?wall" }
      { x =  88, y =  80, mat = "?wall" }
      { x =  88, y =  96, mat = "?step" }
      { x =  16, y =  96, mat = "?wall" }
      { t = 48, mat = "?floor" }
    }

    {
      { x = 104, y =  80, mat = "?step" }
      { x = 176, y =  80, mat = "?wall" }
      { x = 176, y =  96, mat = "?wall" }
      { x = 104, y =  96, mat = "?wall" }
      { t = 64, mat = "?floor" }
    }

    {
      { x =  16, y = 160, mat = "?wall" }
      { x =  88, y = 160, mat = "?wall" }
      { x =  88, y = 176, mat = "?step" }
      { x =  16, y = 176, mat = "?wall" }
      { t = 8, mat = "?floor" }
    }

    {
      { x =  16, y = 144, mat = "?wall" }
      { x =  88, y = 144, mat = "?wall" }
      { x =  88, y = 160, mat = "?step" }
      { x =  16, y = 160, mat = "?wall" }
      { t = 16, mat = "?floor" }
    }

    {
      { x =  16, y = 128, mat = "?wall" }
      { x =  88, y = 128, mat = "?wall" }
      { x =  88, y = 144, mat = "?step" }
      { x =  16, y = 144, mat = "?wall" }
      { t = 24, mat = "?floor" }
    }

    {
      { x =  16, y = 112, mat = "?wall" }
      { x =  88, y = 112, mat = "?wall" }
      { x =  88, y = 128, mat = "?step" }
      { x =  16, y = 128, mat = "?wall" }
      { t = 32, mat = "?floor" }
    }

    {
      { x =  16, y =  96, mat = "?wall" }
      { x =  88, y =  96, mat = "?wall" }
      { x =  88, y = 112, mat = "?step" }
      { x =  16, y = 112, mat = "?wall" }
      { t = 40, mat = "?floor" }
    }

    {
      { x = 104, y =  96, mat = "?step" }
      { x = 176, y =  96, mat = "?wall" }
      { x = 176, y = 112, mat = "?wall" }
      { x = 104, y = 112, mat = "?wall" }
      { t = 72, mat = "?floor" }
    }

    {
      { x = 104, y = 112, mat = "?step" }
      { x = 176, y = 112, mat = "?wall" }
      { x = 176, y = 128, mat = "?wall" }
      { x = 104, y = 128, mat = "?wall" }
      { t = 80, mat = "?floor" }
    }

    {
      { x = 104, y = 128, mat = "?step" }
      { x = 176, y = 128, mat = "?wall" }
      { x = 176, y = 144, mat = "?wall" }
      { x = 104, y = 144, mat = "?wall" }
      { t = 88, mat = "?floor" }
    }

    {
      { x = 104, y = 144, mat = "?step" }
      { x = 176, y = 144, mat = "?wall" }
      { x = 176, y = 160, mat = "?wall" }
      { x = 104, y = 160, mat = "?wall" }
      { t = 96, mat = "?floor" }
    }

    {
      { x = 104, y = 160, mat = "?step" }
      { x = 176, y = 160, mat = "?wall" }
      { x = 176, y = 176, mat = "?wall" }
      { x = 104, y = 176, mat = "?wall" }
      { t = 104, mat = "?floor" }
    }
  }
}

