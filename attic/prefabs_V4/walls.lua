----------------------------------------------------------------
--  WALL PREFABS
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

PREFAB.WALL =
{
  fitted = "xy"

  brushes =
  {
    {
      { x =   0, y =  0, mat = "?outer" }
      { x = 192, y =  0, mat = "?wall" }
      { x = 192, y = 24, mat = "?wall" }
      { x =   0, y = 24, mat = "?wall" }
    }

    -- bounds on Z axis
    {
      { m = "bbox" }
      { b = 0 }
      { t = 128 }
    }
  }
}


PREFAB.SKY_FENCE =
{
  fitted = "xy"

  brushes =
  {
    {
      { x =   0, y =  0, mat = "_SKY", draw_never=1 }
      { x = 192, y =  0, mat = "_SKY", draw_never=1 }
      { x = 192, y = 16, mat = "_SKY" }
      { x =   0, y = 16, mat = "_SKY", draw_never=1 }
      { b = 80, delta_z=-16, mat = "_SKY" }
    }

    {
      { x =   0, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y = 192, mat = "?wall", blocked=1 }
      { x =   0, y = 192, mat = "?wall" }
      { t = 64, mat = "?wall" }
    }

    {
      { x =   0, y =   0, mat = "_SKY" }
      { x = 192, y =   0, mat = "_SKY" }
      { x = 192, y = 192, mat = "_SKY" }
      { x =   0, y = 192, mat = "_SKY" }
      { b = "?sky_h", mat = "_SKY" }
    }
  }
}


PREFAB.SKY_CORNER =
{
  fitted = "xy"

  brushes =
  {

    {
      { x = 176, y =   0, mat = "_SKY", draw_never=1 }
      { x = 192, y =   0, mat = "_SKY", draw_never=1 }
      { x = 192, y = 192, mat = "_SKY", draw_never=1 }
      { x =   0, y = 192, mat = "_SKY", draw_never=1 }
      { x =   0, y = 176, mat = "_SKY" }
      { b = 80, delta_z=-16, mat = "_SKY" }
    }

    {
      { x =   0, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y = 192, mat = "?wall" }
      { x =   0, y = 192, mat = "?wall" }
      { t = 64, mat = "?wall" }
    }

    {
      { x =   0, y =   0, mat = "_SKY" }
      { x = 192, y =   0, mat = "_SKY" }
      { x = 192, y = 192, mat = "_SKY" }
      { x =   0, y = 192, mat = "_SKY" }
      { b = "?sky_h", mat = "_SKY" }
    }
  }
}



PREFAB.PICTURE =
{
  fitted = "xyz"

  x_ranges = { {8,1}, {16,0,"?pic_w"}, {8,1} }
  y_ranges = { {8,1}, {8,0} }
  z_ranges = { {32,1}, {64,0,"?pic_h"}, {32,7} }

  defaults =
  {
    pic_w = 64
    pic_h = 64

    frame = "?wall"

    light  = ""
    effect = ""
    fx_delta = ""
    scroll = ""

    x_offset = 0
    y_offset = 0
    peg = 0
  }

  brushes =
  {
    -- wall behind picture
    {
      { x =  0, y =  0, mat = "?outer" }
      { x = 32, y =  0, mat = "?wall" }
      { x = 32, y =  4, mat = "?wall" }
      { x =  0, y =  4, mat = "?wall" }
    }

    -- picture itself
    {
      { x =  8, y =  4, mat = "?wall" }
      { x = 24, y =  4, mat = "?wall"  }
      { x = 24, y =  8, mat = "?pic", peg="?peg", x_offset="?x_offset", y_offset="?y_offset", special="?scroll", hack_align=1 }
      { x =  8, y =  8, mat = "?wall"  }
      { b = 32 }
      { t = 96 }
    }

    -- right side wall
    {
      { x =  0, y =  4, mat = "?wall" }
      { x =  8, y =  4, mat = "?frame" }
      { x =  8, y = 16, mat = "?wall" }
      { x =  0, y = 16, mat = "?wall" }
    }

    -- left side wall
    {
      { x = 24, y =  4, mat = "?wall" }
      { x = 32, y =  4, mat = "?wall" }
      { x = 32, y = 16, mat = "?wall" }
      { x = 24, y = 16, mat = "?frame" }
    }

    -- frame bottom
    {
      { x =  8, y =  8, mat = "?wall" }
      { x = 24, y =  8, mat = "?wall" }
      { x = 24, y = 16, mat = "?wall", blocked=1 }
      { x =  8, y = 16, mat = "?wall" }
      { t = 32, mat = "?frame" }
    }

    -- frame top
    {
      { x =  8, y =  8, mat = "?wall" }
      { x = 24, y =  8, mat = "?wall" }
      { x = 24, y = 16, mat = "?wall", blocked=1 }
      { x =  8, y = 16, mat = "?wall" }
      { b = 96, mat = "?frame", light_add="?light", light_effect="?effect", light_delta="?fx_delta" }
    }

    -- bounds on Z axis
    {
      { m = "bbox" }
      { b = 0 }
      { t = 128 }
    }
  }

  entities =
  {
    -- lighting in Quake engines
    { ent = "light", x = 16, y = 20, z = 64,
      light = "?light", style = "?effect"
    }
  }
}



PREFAB.WALL_SPIKE_SHOOTER =
{
  fitted = "xy"

  x_ranges = { {16,1}, {96,0}, {16,1} }
  y_ranges = { {16,1}, {24,0} }

  repeat_width = 128

  defaults =
  {
    spike_group = "spikey"
  }

  brushes =
  {
    -- wall behind it
    {
      { x =   0, y =  0, mat = "?wall" }
      { x = 128, y =  0, mat = "?wall" }
      { x = 128, y = 16, mat = "?wall" }
      { x =   0, y = 16, mat = "?wall" }
    }

    -- space in front of it
    {
      -- FIXME: bbox brush
      { x =   0, y =  16, mat = "?floor" }
      { x = 128, y =  16, mat = "?floor" }
      { x = 128, y = 112, mat = "?floor" }
      { x =   0, y = 112, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }

    -- the shooter
    {
      { x =  40, y = 16, mat = "?metal" }
      { x =  60, y = 16, mat = "?metal" }
      { x =  60, y = 40, mat = "?metal" }
      { b = 32, mat = "?metal" }
      { t = 56, mat = "?metal" }
    }

    {
      { x =  68, y = 16, mat = "?metal" }
      { x =  88, y = 16, mat = "?metal" }
      { x =  68, y = 40, mat = "?metal" }
      { b = 32, mat = "?metal" }
      { t = 56, mat = "?metal" }
    }

    {
      { x =  60, y = 16, mat = "?metal" }
      { x =  68, y = 16, mat = "?metal" }
      { x =  68, y = 40, mat = "?metal" }
      { x =  60, y = 40, mat = "?metal" }
      { b = 32, mat = "?metal" }
      { t = 36, mat = "?metal" }
    }

    {
      { x =  60, y = 16, mat = "?metal" }
      { x =  68, y = 16, mat = "?metal" }
      { x =  68, y = 40, mat = "?metal" }
      { x =  60, y = 40, mat = "?metal" }
      { b = 52, mat = "?metal" }
      { t = 56, mat = "?metal" }
    }
  }

  models =
  {
    -- the trigger
    {
      x1 =  16, x2 = 112, x_face = { mat="TRIGGER" }
      y1 =  16, y2 = 480, y_face = { mat="TRIGGER" }
      z1 =   0, z2 =  80, z_face = { mat="TRIGGER" }

      entity =
      {
        ent = "trigger", target = "?spike_group",
      }
    }
  }

  entities =
  {
    { x = 64, y = 20, z = 20, ent = "spiker", angle = 90, targetname="?spike_group" }
  }
}


