----------------------------------------------------------------
--  WINDOW and FENCE PREFABS
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
--  Window and Fence prefabs are relative (in Z coord) to
--  the highest floor on either side.
--
----------------------------------------------------------------

PREFAB.WINDOW =
{
  fitted = "xyz"

  x_ranges = { {32,1}, {64,1}, {32,1} }
  z_ranges = { {32,1}, {64,1}, {32,2} }

  defaults =
  {
    frame = "?wall"
  }

  brushes =
  {
    -- right side
    {
      { x =  0, y =  0, mat = "?outer" }
      { x = 32, y =  0, mat = "?frame" }
      { x = 32, y = 24, mat = "?wall" }
      { x =  0, y = 24, mat = "?wall" }
    }

    -- left side
    {
      { x =  96, y =  0, mat = "?outer" }
      { x = 128, y =  0, mat = "?wall" }
      { x = 128, y = 24, mat = "?wall" }
      { x =  96, y = 24, mat = "?frame" }
    }

    -- bottom
    {
      { x = 32, y =  0, mat = "?outer" }
      { x = 96, y =  0, mat = "?wall" }
      { x = 96, y = 24, mat = "?wall" }
      { x = 32, y = 24, mat = "?wall" }
      { t = 32, mat = "?frame" }
    }

    -- top
    {
      { x = 32, y =  0, mat = "?outer" }
      { x = 96, y =  0, mat = "?wall" }
      { x = 96, y = 24, mat = "?wall" }
      { x = 32, y = 24, mat = "?wall" }
      { b = 96, mat = "?frame", light_add=32 }
    }

    -- bounding on Z axis
    {
      { m = "bbox" }
      { b = 0 }
      { t = 128 }
    }
  }
}


PREFAB.PICTURE_WINDOW =
{
  fitted = "xyz"

  x_ranges = { {32,1}, {64,0,"?pic_w"}, {32,1} }
  z_ranges = { {32,1}, {64,0,"?pic_h"}, {32,3} }

  defaults =
  {
    frame = "?wall"

    pic_w = 64
    pic_h = 64
  }

  brushes =
  {
    -- right side
    {
      { x =  0, y =  0, mat = "?outer" }
      { x = 32, y =  0, mat = "?frame" }
      { x = 32, y = 24, mat = "?wall" }
      { x =  0, y = 24, mat = "?wall" }
    }

    -- left side
    {
      { x =  96, y =  0, mat = "?outer" }
      { x = 128, y =  0, mat = "?wall" }
      { x = 128, y = 24, mat = "?wall" }
      { x =  96, y = 24, mat = "?frame" }
    }

    -- bottom
    {
      { x = 32, y =  0, mat = "?outer" }
      { x = 96, y =  0, mat = "?wall" }
      { x = 96, y = 24, mat = "?wall" }
      { x = 32, y = 24, mat = "?wall" }
      { t = 32, mat = "?frame" }
    }

    -- top
    {
      { x = 32, y =  0, mat = "?outer" }
      { x = 96, y =  0, mat = "?wall" }
      { x = 96, y = 24, mat = "?wall" }
      { x = 32, y = 24, mat = "?wall" }
      { b = 96, mat = "?frame", light_add=32 }
    }

    -- fake bit (picture)
    {
      { x = 32, y = 12, mat = "?pic", x_offset=0, y_offset=0 }
      { x = 96, y = 12, mat = "?pic", x_offset=0, y_offset=0 }
      { x = 96, y = 16, mat = "?pic", x_offset=0, y_offset=0 }
      { x = 32, y = 16, mat = "?pic", x_offset=0, y_offset=0 }
      { t = 96, mat = "?pic" }
      { b = 32, mat = "?pic" }
    }

    -- bounding on Z axis
    {
      { m = "bbox" }
      { b = 0 }
      { t = 128 }
    }
  }
}


PREFAB.WINDOW_W_BARS =
{
  fitted = "xy"

  x_ranges = { {64,1}, {64,2}, {64,1} }

  repeat_width = 256

  defaults =
  {
    track = "?wall"
  }

  brushes =
  {
    -- right side
    {
      { x =  0, y =  0, mat = "?outer" }
      { x = 64, y =  0, mat = "?track" }
      { x = 64, y = 32, mat = "?wall" }
      { x =  0, y = 32, mat = "?wall" }
    }

    -- left side
    {
      { x = 128, y =  0, mat = "?outer" }
      { x = 192, y =  0, mat = "?wall" }
      { x = 192, y = 32, mat = "?wall" }
      { x = 128, y = 32, mat = "?track" }
    }

    -- bottom
    {
      { x =  64, y =  0, mat = "?outer" }
      { x = 128, y =  0, mat = "?wall" }
      { x = 128, y = 32, mat = "?wall" }
      { x =  64, y = 32, mat = "?wall" }
      { t = 32, mat = "?outer" }
    }

    -- top
    {
      { x =  64, y =  0, mat = "?outer" }
      { x = 128, y =  0, mat = "?wall" }
      { x = 128, y = 32, mat = "?wall" }
      { x =  64, y = 32, mat = "?wall" }
      { b = 128, mat = "?outer" }
    }

    -- bars
    {
      { x =  94, y = 12, mat = "?frame" }
      { x =  98, y = 12, mat = "?frame" }
      { x =  98, y = 20, mat = "?frame" }
      { x =  94, y = 20, mat = "?frame" }
    }
    {
      { x =  76, y = 12, mat = "?frame" }
      { x =  80, y = 12, mat = "?frame" }
      { x =  80, y = 20, mat = "?frame" }
      { x =  76, y = 20, mat = "?frame" }
    }
    {
      { x = 112, y = 12, mat = "?frame" }
      { x = 116, y = 12, mat = "?frame" }
      { x = 116, y = 20, mat = "?frame" }
      { x = 112, y = 20, mat = "?frame" }
    }

  }
}


PREFAB.WINDOW_W_CROSS =
{
  fitted = "xy"

  x_ranges = { {64,1}, {64,1}, {64,1} }

  repeat_width = 256

  defaults =
  {
    track = "?wall"
  }

  brushes =
  {
    -- right side
    {
      { x =  0, y =  0, mat = "?outer" }
      { x = 64, y =  0, mat = "?track" }
      { x = 64, y = 32, mat = "?wall" }
      { x =  0, y = 32, mat = "?wall" }
    }

    -- left side
    {
      { x = 128, y =  0, mat = "?outer" }
      { x = 192, y =  0, mat = "?wall" }
      { x = 192, y = 32, mat = "?wall" }
      { x = 128, y = 32, mat = "?track" }
    }

    -- bottom
    {
      { x =  64, y =  0, mat = "?outer" }
      { x = 128, y =  0, mat = "?wall" }
      { x = 128, y = 32, mat = "?wall" }
      { x =  64, y = 32, mat = "?wall" }
      { t = 32, mat = "?outer" }
    }

    -- top
    {
      { x =  64, y =  0, mat = "?outer" }
      { x = 128, y =  0, mat = "?wall" }
      { x = 128, y = 32, mat = "?wall" }
      { x =  64, y = 32, mat = "?wall" }
      { b = 160, mat = "?outer" }
    }

    -- cross
    {
      { x =  92, y = 12, mat = "?frame" }
      { x = 100, y = 12, mat = "?frame" }
      { x = 100, y = 20, mat = "?frame" }
      { x =  92, y = 20, mat = "?frame" }
    }
    {
      { x =  64, y = 12, mat = "?frame" }
      { x = 128, y = 12, mat = "?frame" }
      { x = 128, y = 20, mat = "?frame" }
      { x =  64, y = 20, mat = "?frame" }
      { b =  92, mat = "?frame" }
      { t =  100, mat = "?frame" }
    }

  }
}


PREFAB.WINDOW_GOTHIC =
{
  fitted = "xy"

  x_ranges = { {32,1}, {128,0}, {32,1} }

  repeat_width = 192

  brushes =
  {
    -- right side
    {
      { x =  0, y =  0, mat = "?outer" }
      { x = 32, y =  0, mat = "?wall" }
      { x = 32, y = 32, mat = "?wall" }
      { x =  0, y = 32, mat = "?wall" }
    }

    -- left side
    {
      { x = 160, y =  0, mat = "?outer" }
      { x = 192, y =  0, mat = "?wall" }
      { x = 192, y = 32, mat = "?wall" }
      { x = 160, y = 32, mat = "?wall" }
    }

    -- bottom
    {
      { x =  32, y =  0, mat = "?outer" }
      { x = 160, y =  0, mat = "?wall" }
      { x = 160, y = 32, mat = "?wall" }
      { x =  32, y = 32, mat = "?wall" }
      { t = 48, mat = "?wall" }
    }

    -- arch pieces
    {
      { x =  32, y =  0, mat = "?outer" }
      { x =  56, y =  0, mat = "?wall" }
      { x =  56, y = 32, mat = "?wall" }
      { x =  32, y = 32, mat = "?wall" }
      { b = 168, mat = "?wall" }
    }

    {
      { x =  56, y =  0, mat = "?outer" }
      { x =  80, y =  0, mat = "?wall" }
      { x =  80, y = 32, mat = "?wall" }
      { x =  56, y = 32, mat = "?wall" }
      { b = 216, mat = "?wall" }
    }

    {
      { x =  80, y =  0, mat = "?outer" }
      { x = 112, y =  0, mat = "?wall" }
      { x = 112, y = 32, mat = "?wall" }
      { x =  80, y = 32, mat = "?wall" }
      { b = 240, mat = "?wall" }
    }

    {
      { x = 112, y =  0, mat = "?outer" }
      { x = 136, y =  0, mat = "?wall" }
      { x = 136, y = 32, mat = "?wall" }
      { x = 112, y = 32, mat = "?wall" }
      { b = 216, mat = "?wall" }
    }

    {
      { x = 136, y =  0, mat = "?outer" }
      { x = 160, y =  0, mat = "?wall" }
      { x = 160, y = 32, mat = "?wall" }
      { x = 136, y = 32, mat = "?wall" }
      { b = 168, mat = "?wall" }
    }

  }
}



PREFAB.QUAKE_WINDOW =
{
  fitted = "xy"

  x_ranges = { {64,1}, {64,1}, {64,1} }

  repeat_width = 192

  brushes =
  {
    -- right side
    {
      { x =  0, y =  8, mat = "?outer" }
      { x = 56, y =  8, mat = "?wall" }
      { x = 56, y = 24, mat = "?wall" }
      { x =  0, y = 24, mat = "?wall" }
    }

    -- left side
    {
      { x = 136, y =  8, mat = "?outer" }
      { x = 192, y =  8, mat = "?wall" }
      { x = 192, y = 24, mat = "?wall" }
      { x = 132, y = 24, mat = "?wall" }
    }

    -- bottom
    {
      { x =  56, y =  8, mat = "?outer" }
      { x = 136, y =  8, mat = "?wall" }
      { x = 136, y = 24, mat = "?wall" }
      { x =  56, y = 24, mat = "?wall" }
      { t = 32, mat = "?outer" }
    }

    -- top
    {
      { x =  56, y =  8, mat = "?outer" }
      { x = 136, y =  8, mat = "?wall" }
      { x = 136, y = 24, mat = "?wall" }
      { x =  56, y = 24, mat = "?wall" }
      { b = 160, mat = "?outer" }
    }

    ---- 3D frame ----

    -- left
    {
      { x =  56, y =  0, mat = "?frame" }
      { x =  64, y =  0, mat = "?frame" }
      { x =  64, y = 32, mat = "?frame" }
      { x =  56, y = 32, mat = "?frame" }
      { b =  32, mat = "?frame" }
      { t = 160, mat = "?frame" }
    }

    -- right
    {
      { x = 128, y =  0, mat = "?frame" }
      { x = 136, y =  0, mat = "?frame" }
      { x = 136, y = 32, mat = "?frame" }
      { x = 128, y = 32, mat = "?frame" }
      { b =  32, mat = "?frame" }
      { t = 160, mat = "?frame" }
    }

    -- top
    {
      { x =  64, y =  0, mat = "?frame" }
      { x = 128, y =  0, mat = "?frame" }
      { x = 128, y = 32, mat = "?frame" }
      { x =  64, y = 32, mat = "?frame" }
      { b = 152, mat = "?frame" }
      { t = 160, mat = "?frame" }
    }

    -- bottom
    {
      { x =  64, y =  0, mat = "?frame" }
      { x = 128, y =  0, mat = "?frame" }
      { x = 128, y = 32, mat = "?frame" }
      { x =  64, y = 32, mat = "?frame" }
      { b = 32, mat = "?frame" }
      { t = 40, mat = "?frame" }
    }

  }
}


--------------------------------------------------------------------


PREFAB.FENCE =
{
  fitted = "xy"

  brushes =
  {
    {
      { x =   0, y =  0, mat = "?fence" }
      { x = 192, y =  0, mat = "?fence" }
      { x = 192, y = 16, mat = "?fence" }
      { x =   0, y = 16, mat = "?fence" }
      { t = 32, mat = "?fence" }
    }

  }
}


PREFAB.FENCE_W_GAP =
{
  fitted = "xy"

  x_ranges = { {80,1}, {32,0}, {80,1} }

  repeat_width = 192

  brushes =
  {
    {
      { x =   0, y =  0, mat = "?fence" }
      { x =  80, y =  0, mat = "?fence" }
      { x =  80, y = 32, mat = "?fence" }
      { x =   0, y = 32, mat = "?fence" }
      { t = 32, mat = "?fence" }
    }

    {
      { x =  80, y =  8, mat = "?metal", blocked=1 }
      { x = 112, y =  8, mat = "?metal", blocked=1 }
      { x = 112, y = 24, mat = "?metal", blocked=1 }
      { x =  80, y = 24, mat = "?metal", blocked=1 }
      { t = 16, mat = "?metal" }
    }

    {
      { x = 112, y =  0, mat = "?fence" }
      { x = 192, y =  0, mat = "?fence" }
      { x = 192, y = 32, mat = "?fence" }
      { x = 112, y = 32, mat = "?fence" }
      { t = 32, mat = "?fence" }
    }

  }
}


PREFAB.FENCE_W_BOLLARD =
{
  fitted = "xy"

  x_ranges = { {56,1}, {16,0}, {56,1} }
  y_ranges = { {8,0},  {16,1}, {8,0}  }

  repeat_width = 128

  brushes =
  {
    {
      { x =   0, y =  8, mat = "?fence" }
      { x =  56, y =  8, mat = "?fence" }
      { x =  56, y = 24, mat = "?fence" }
      { x =   0, y = 24, mat = "?fence" }
      { t = 32, mat = "?fence" }
    }

    {
      { x =  56, y =  0, mat = "?metal" }
      { x =  72, y =  0, mat = "?metal" }
      { x =  72, y = 32, mat = "?metal" }
      { x =  56, y = 32, mat = "?metal" }
      { t = 48, mat = "?metal" }
    }

    {
      { x =  72, y =  8, mat = "?fence" }
      { x = 128, y =  8, mat = "?fence" }
      { x = 128, y = 24, mat = "?fence" }
      { x =  72, y = 24, mat = "?fence" }
      { t = 32, mat = "?fence" }
    }

  }
}



PREFAB.FENCE_W_INSET =
{
  fitted = "xy"

  x_ranges = { {16,0}, {96,1}, {16,0} }
  y_ranges = { {12,1}, { 8,0}, {12,1} }

  repeat_width = 128

  brushes =
  {
    {
      { x =   0, y =  0, mat = "?fence" }
      { x =  16, y =  0, mat = "?fence" }
      { x =  16, y = 32, mat = "?fence" }
      { x =   0, y = 32, mat = "?fence" }
      { t = 72, mat = "?fence" }
    }

    {
      { x =  16, y =  0, mat = "?fence" }
      { x = 112, y =  0, mat = "?fence" }
      { x = 112, y = 32, mat = "?fence" }
      { x =  16, y = 32, mat = "?fence" }
      { t = 8, mat = "?fence" }
    }

    {
      { x =  16, y = 12, mat = "?inset" }
      { x = 112, y = 12, mat = "?inset" }
      { x = 112, y = 20, mat = "?inset" }
      { x =  16, y = 20, mat = "?inset" }
      { t = 48, mat = "?inset" }
    }

    {
      { x = 112, y =  0, mat = "?fence" }
      { x = 128, y =  0, mat = "?fence" }
      { x = 128, y = 32, mat = "?fence" }
      { x = 112, y = 32, mat = "?fence" }
      { t = 72, mat = "?fence" }
    }

  }
}


PREFAB.FENCE_W_RAIL =
{
  fitted = "xy"

  x_ranges = { {12,0}, {104,1}, {12,0} }

  repeat_width = 192

  brushes =
  {
    -- base
    {
      { x =   0, y =  0, mat = "?fence" }
      { x = 128, y =  0, mat = "?fence" }
      { x = 128, y = 32, mat = "?fence" }
      { x =   0, y = 32, mat = "?fence" }
      { t = 16, mat = "?fence" }
    }

    -- post(s)
    {
      { x =  0, y =  8, mat = "?metal" }
      { x = 12, y =  8, mat = "?metal" }
      { x = 12, y = 24, mat = "?metal" }
      { x =  0, y = 24, mat = "?metal" }
      { t = 160, mat = "?metal" }
    }

    {
      { x = 116, y =  8, mat = "?metal" }
      { x = 128, y =  8, mat = "?metal" }
      { x = 128, y = 24, mat = "?metal" }
      { x = 116, y = 24, mat = "?metal" }
      { t = 160, mat = "?metal" }
    }

    -- railing
    {
      { m = "rail" }
      { x =  12, y = 16, mat = "?rail", blocked=1 }
      { x = 116, y = 16 }
      { x = 116, y = 32 }
      { x =  12, y = 32 }
      { b = 16 }
      { t = 144 }
    }

  }
}


PREFAB.FENCE_W_RAIL_INSET =
{
  fitted = "xy"

  x_ranges = { {16,0}, {96,1}, {16,0} }

  repeat_width = 96

  brushes =
  {
    {
      { x =   0, y =  0, mat = "?fence" }
      { x =  16, y =  0, mat = "?fence" }
      { x =  16, y = 32, mat = "?fence" }
      { x =   0, y = 32, mat = "?fence" }
      { t = 96, mat = "?fence" }
    }

    {
      { x =  16, y =  0, mat = "?fence" }
      { x = 112, y =  0, mat = "?fence" }
      { x = 112, y = 32, mat = "?fence" }
      { x =  16, y = 32, mat = "?fence" }
      { t = 16, mat = "?fence" }
    }

    {
      { m = "rail" }
      { x =  16, y = 16, mat = "?rail", blocked=1 }
      { x = 112, y = 16 }
      { x = 112, y = 32 }
      { x =  16, y = 32 }
      { b = 16 }
      { t = 80 }
    }

    {
      { x = 112, y =  0, mat = "?fence" }
      { x = 128, y =  0, mat = "?fence" }
      { x = 128, y = 32, mat = "?fence" }
      { x = 112, y = 32, mat = "?fence" }
      { t = 96, mat = "?fence" }
    }

  }
}


PREFAB.FENCE_W_TORCHES =
{
  fitted = "xy"

  x_ranges = { {16,0}, {96,1}, {16,0} }

  repeat_width = 128

  brushes =
  {
    {
      { x =   0, y =  0, mat = "?fence" }
      { x =  16, y =  0, mat = "?fence" }
      { x =  16, y = 32, mat = "?fence" }
      { x =   0, y = 32, mat = "?fence" }
      { t = 72, mat = "?fence" }
    }

    {
      { x =  16, y =  0, mat = "?fence" }
      { x = 112, y =  0, mat = "?fence" }
      { x = 112, y = 32, mat = "?fence" }
      { x =  16, y = 32, mat = "?fence" }
      { t = 32, mat = "?fence" }
    }

    {
      { x = 112, y =  0, mat = "?fence" }
      { x = 128, y =  0, mat = "?fence" }
      { x = 128, y = 32, mat = "?fence" }
      { x = 112, y = 32, mat = "?fence" }
      { t = 72, mat = "?fence" }
    }
  }

  entities =
  {
    { x = 46, y = 16, z = 32, ent = "?torch", angle = 90 }
    { x = 82, y = 16, z = 32, ent = "?torch", angle = 90 }
  }
}


PREFAB.FENCE_W_HIGH_TORCH =
{
  fitted = "xy"

  x_ranges = { {32,1}, {64,0}, {32,1} }

  repeat_width = 160

  brushes =
  {
    {
      { x =   0, y = 24, mat = "?fence" }
      { x =  32, y = 24, mat = "?fence" }
      { x =  32, y = 40, mat = "?fence" }
      { x =   0, y = 40, mat = "?fence" }
      { t = 32, mat = "?fence" }
    }

    {
      { x =  52, y =  0, mat = "?metal" }
      { x =  76, y =  0, mat = "?metal" }
      { x =  96, y = 24, mat = "?metal" }
      { x =  96, y = 40, mat = "?metal" }
      { x =  76, y = 64, mat = "?metal" }
      { x =  52, y = 64, mat = "?metal" }
      { x =  32, y = 40, mat = "?metal" }
      { x =  32, y = 24, mat = "?metal" }
      { t = 72, mat = "?metal" }
    }

    {
      { x =  96, y = 24, mat = "?fence" }
      { x = 128, y = 24, mat = "?fence" }
      { x = 128, y = 40, mat = "?fence" }
      { x =  96, y = 40, mat = "?fence" }
      { t = 32, mat = "?fence" }
    }
  }

  entities =
  {
    { x = 64, y = 32, z = 72, ent = "?torch", angle = 90 }
  }
}


PREFAB.FENCE_W_WEIRD_BLOB =
{
  fitted = "xy"

  x_ranges = { {64,1}, {64,0}, {64,1} }

  repeat_width = 192

  brushes =
  {
    {
      { x =   0, y = 24, mat = "?fence" }
      { x =  88, y = 24, mat = "?fence" }
      { x =  88, y = 40, mat = "?fence" }
      { x =   0, y = 40, mat = "?fence" }
      { t = 32, mat = "?fence" }
    }

    {
      { x =  88, y = 16, mat = "?metal" }
      { x = 104, y = 16, mat = "?metal" }
      { x = 104, y = 48, mat = "?metal" }
      { x =  88, y = 48, mat = "?metal" }
      { t = 128, mat = "?metal" }
    }

    {
      { x =  64, y =  0, mat = "?blob", x_offset=0, y_offset=0 }
      { x = 128, y =  0, mat = "?blob", x_offset=0, y_offset=0 }
      { x = 128, y = 64, mat = "?blob", x_offset=0, y_offset=0 }
      { x =  64, y = 64, mat = "?blob", x_offset=0, y_offset=0 }
      { b = 128, mat = "?blob" }
    }

    {
      { m = "sky", outlier=1 }
      { x =  60, y = -4, mat = "_SKY" }
      { x = 132, y = -4, mat = "_SKY" }
      { x = 132, y = 68, mat = "_SKY" }
      { x =  60, y = 68, mat = "_SKY" }
      { b = 192, mat = "_SKY" }
    }

    {
      { x = 104, y = 24, mat = "?fence" }
      { x = 192, y = 24, mat = "?fence" }
      { x = 192, y = 40, mat = "?fence" }
      { x = 104, y = 40, mat = "?fence" }
      { t = 32, mat = "?fence" }
    }
  }
}


PREFAB.FENCE_BULGY =
{
  fitted = "xy"

--##  x_ranges = { {48,1}, {96,0}, {48,1} }

  repeat_width = 192

  brushes =
  {
    {
      { x =   0, y =  0, mat = "?fence" }
      { x =  48, y =  0, mat = "?fence" }
      { x =  48, y = 64, mat = "?fence" }
      { x =   0, y = 64, mat = "?fence" }
      { t = 48, mat = "?fence" }
    }

    {
      { x =  48, y =  0, mat = "?fence" }
      { x =  80, y = 24, mat = "?fence" }
      { x =  80, y = 40, mat = "?fence" }
      { x =  48, y = 64, mat = "?fence" }
      { t = 40, mat = "?fence" }
    }

    {
      { x =  80, y = 24, mat = "?fence" }
      { x = 112, y = 24, mat = "?fence" }
      { x = 112, y = 40, mat = "?fence" }
      { x =  80, y = 40, mat = "?fence" }
      { t = 32, mat = "?fence" }
    }

    {
      { x = 112, y = 24, mat = "?fence" }
      { x = 144, y =  0, mat = "?fence" }
      { x = 144, y = 64, mat = "?fence" }
      { x = 112, y = 40, mat = "?fence" }
      { t = 40, mat = "?fence" }
    }

    {
      { x = 144, y =  0, mat = "?fence" }
      { x = 192, y =  0, mat = "?fence" }
      { x = 192, y = 64, mat = "?fence" }
      { x = 144, y = 64, mat = "?fence" }
      { t = 48, mat = "?fence" }
    }
  }
}


PREFAB.FENCE_STICKS_DOOM =
{
  fitted = "xy"

  x_ranges = { {6,0}, {20,1}, {6,0} }

  repeat_width = 64

  brushes =
  {
    -- base
    {
      { x =   0, y =  0, mat = "?fence" }
      { x =  32, y =  0, mat = "?fence" }
      { x =  32, y = 32, mat = "?fence" }
      { x =   0, y = 32, mat = "?fence" }
      { t = 12, mat = "?fence" }
    }

    -- post(s)
    {
      { x =  0, y = 12, mat = "?metal" }
      { x =  6, y = 12, mat = "?metal" }
      { x =  6, y = 20, mat = "?metal" }
      { x =  0, y = 20, mat = "?metal" }
      { t = 72, mat = "?metal" }
    }

    {
      { x = 26, y = 12, mat = "?metal" }
      { x = 32, y = 12, mat = "?metal" }
      { x = 32, y = 20, mat = "?metal" }
      { x = 26, y = 20, mat = "?metal" }
      { t = 72, mat = "?metal" }
    }

    -- railing
    {
      { m = "rail" }
      { x =  6, y = 16, mat = "?rail", blocked=1 }
      { x = 26, y = 16 }
      { x = 26, y = 32 }
      { x =  6, y = 32 }
      { b = 56 }
      { t = 72 }
    }

  }
}


PREFAB.FENCE_STICKS_QUAKE =
{
  fitted = "xy"

  x_ranges = { {6,0}, {20,1}, {6,0} }

  repeat_width = 48

  brushes =
  {
    -- base
    {
      { x =   0, y =  0, mat = "?fence" }
      { x =  32, y =  0, mat = "?fence" }
      { x =  32, y = 32, mat = "?fence" }
      { x =   0, y = 32, mat = "?fence" }
      { t = 12, mat = "?fence" }
    }

    -- post(s)
    {
      { x =  0, y = 12, mat = "?metal" }
      { x =  4, y = 12, mat = "?metal" }
      { x =  4, y = 20, mat = "?metal" }
      { x =  0, y = 20, mat = "?metal" }
      { t = 72, mat = "?metal" }
    }

    {
      { x = 28, y = 12, mat = "?metal" }
      { x = 32, y = 12, mat = "?metal" }
      { x = 32, y = 20, mat = "?metal" }
      { x = 28, y = 20, mat = "?metal" }
      { t = 72, mat = "?metal" }
    }

    { -- FIXME : REMOVE WHEN repeat_width WORKS AGAIN
      { x = 15, y = 12, mat = "?metal" }
      { x = 17, y = 12, mat = "?metal" }
      { x = 17, y = 20, mat = "?metal" }
      { x = 15, y = 20, mat = "?metal" }
      { t = 72, mat = "?metal" }
    }

    -- railing
    {
      { x =  6, y = 12, mat = "?metal" }
      { x = 26, y = 12, mat = "?metal" }
      { x = 26, y = 20, mat = "?metal" }
      { x =  6, y = 20, mat = "?metal" }
      { b = 64, mat = "?metal" }
      { t = 72, mat = "?metal" }
    }

    -- player clip
    {
      { m = "clip" }
      { x =  0, y = 12 }
      { x = 32, y = 12 }
      { x = 32, y = 20 }
      { x =  0, y = 20 }
      { t = 112 }
    }
  }
}


