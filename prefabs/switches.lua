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
  defaults =
  {
    x_offset = 0
    y_offset = 0

    act = ""
    speed = 16
  }

  brushes =
  {
    -- the base
    {
      { x = -40, y = -40, mat = "?base" }
      { x =  40, y = -40, mat = "?base" }
      { x =  56, y = -24, mat = "?base" }
      { x =  56, y =  24, mat = "?base" }
      { x =  40, y =  40, mat = "?base" }
      { x = -40, y =  40, mat = "?base" }
      { x = -56, y =  24, mat = "?base" }
      { x = -56, y = -24, mat = "?base" }
      { t = 12, light = 0.66, mat = "?base" }
    }

    -- switch itself
    {
      { x = -32, y = -8, mat = "?switch", special="?special", act="?act", tag="?tag", arg1="?tag", arg2="?speed", peg=1, x_offset="?x_offset", y_offset="?y_offset" }
      { x =  32, y = -8, mat = "?side" }
      { x =  32, y =  8, mat = "?side" }
      { x = -32, y =  8, mat = "?side" }
      { t = 76, mat = "?side" }
    }
  }
}


PREFAB.SWITCH_TINY =
{
  defaults =
  {
    base = "?wall"
    pillar = "?base"

    switch_h = 32

    x_offset = 0
    y_offset = 0

    act = ""
    speed = 16

    light1 = 32
    light2 = 48
  }

  brushes =
  {
    {
      { x = -44, y = -16, mat = "?base" }
      { x = -28, y = -32, mat = "?base" }
      { x =  28, y = -32, mat = "?base" }
      { x =  44, y = -16, mat = "?base" }
      { x =  44, y =  16, mat = "?base" }
      { x =  28, y =  32, mat = "?base" }
      { x = -28, y =  32, mat = "?base" }
      { x = -44, y =  16, mat = "?base" }
      { t = 8, mat = "?base", light_add="?light1" }
    }

    {
      { x = -32, y =   0, mat = "?pillar" }
      { x = -20, y = -20, mat = "?pillar" }
      { x =  20, y = -20, mat = "?pillar" }
      { x =  32, y =   0, mat = "?pillar" }
      { x =  20, y =  20, mat = "?pillar" }
      { x = -20, y =  20, mat = "?pillar" }
      { t = 34, mat = "?pillar", light_add="?light2"  }
    }

    {
      { x = -16, y =  -8, mat = "?switch", special="?special", act="?act", tag="?tag", arg1="?tag", arg2="?speed", x_offset="x_offset", peg=1, y_offset="?y_offset" }
      { x =  16, y =  -8, mat = "?side" }
      { x =  16, y =   8, mat = "?side" }
      { x = -16, y =   8, mat = "?side" }
      { t = "?switch_h+34", mat = "?side" }
    }
  }
}



PREFAB.QUAKE_FLOOR_SWITCH =
{
  defaults =
  {
    wait = -1
  }

  brushes =
  {
    -- dummy brush  [FIXME]
    {
      { x = -32, y = -32, mat="?side" }
      { x =  32, y = -32, mat="?side" }
      { x =  32, y =  32, mat="?side" }
      { x = -32, y =  32, mat="?side" }
      { t = 0, mat="?switch" }
    }
  }

  models =
  {
    -- button itself
    {
      x1 = -32, x2 = 32, x_face = { mat="?side" }
      y1 = -32, y2 = 32, y_face = { mat="?side" }
      z1 =   0, z2 = 16, z_face = { mat="?switch", u1=0, u2=64, v1=0, v2=64 }

      entity =
      {
        ent = "button", angles = "90 0 0", sounds = 2,
        target = "?target", wait ="?wait", lip = 8,
      }
    }
  }
}



PREFAB.WALL_SWITCH =
{
  fitted = "xy"

  defaults =
  {
    side = "?wall"
  }

  brushes =
  {
    -- wall behind it
    {
      { x =   0, y =  0, mat = "?wall" }
      { x = 192, y =  0, mat = "?wall" }
      { x = 192, y =  4, mat = "?wall" }
      { x =   0, y =  4, mat = "?wall" }
    }

    -- switch itself
    {
      { x =  64, y =  4 }
      { x = 128, y =  4 }
      { x = 128, y =  8, mat = "?switch", special="?special", tag="?tag", peg=1, x_offset="?x_offset", y_offset="?y_offset" }
      { x =  64, y =  8 }
    }

    -- right side wall
    {
      { x = 0, y =  4, mat = "?wall" }
      { x = 8, y =  4, mat = "?wall" }
      { x = 8, y = 16, mat = "?wall" }
      { x = 0, y = 16, mat = "?wall" }
    }

    {
      { x =  8, y =  4, mat = "?wall" }
      { x = 64, y =  4, mat = "?side" }
      { x = 64, y = 16, mat = "?wall" }
      { x =  8, y = 16, mat = "?side" }
    }

    -- left side wall
    {
      { x = 184, y =  4, mat = "?wall" }
      { x = 192, y =  4, mat = "?wall" }
      { x = 192, y = 16, mat = "?wall" }
      { x = 184, y = 16, mat = "?wall" }
    }

    {
      { x = 128, y =  4, mat = "?wall" }
      { x = 184, y =  4, mat = "?side" }
      { x = 184, y = 16, mat = "?wall" }
      { x = 128, y = 16, mat = "?side" }
    }

    -- frame top
    {
      { x =  64, y =  4, mat = "?wall" }
      { x = 128, y =  4, mat = "?wall" }
      { x = 128, y = 16, mat = "?wall", blocked=1 }
      { x =  64, y = 16, mat = "?wall" }
      { b = 64, mat = "?ceil", light = "?light", special = "?special" }
    }

    -- frame bottom
    --[[
    {
      { x =  64, y =  4, mat = "?wall" }
      { x = 128, y =  4, mat = "?wall" }
      { x = 128, y = 16, mat = "?wall", blocked=1 }
      { x =  64, y = 16, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    --]]
  }
}


PREFAB.QUAKE_WALL_SWITCH =
{
  fitted = "xy"

  defaults =
  {
    wait = -1
  }

  brushes =
  {
    -- wall behind it
    {
      { x =   0, y =  0, mat = "?wall" }
      { x = 192, y =  0, mat = "?wall" }
      { x = 192, y = 16, mat = "?wall" }
      { x =   0, y = 16, mat = "?wall" }
    }

    -- area in front of it [FIXME: bbox brush]
    {
      { x =   0, y = 16, mat = "?floor" }
      { x = 192, y = 16, mat = "?floor" }
      { x = 192, y = 80, mat = "?floor" }
      { x =   0, y = 80, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }
  }

  models =
  {
    -- button
    {
      x1 = 64, x2 = 128, x_face = { mat="METAL1_2" }
      y1 = 16, y2 = 32,  y_face = { mat="BUTTON", u1=0, u2=48, v1=0, v2=48 }
      z1 = 24, z2 = 88,  z_face = { mat="METAL1_2" }

      entity =
      {
        ent = "button", angle = 270, sounds = 2,
        target = "?target", wait ="?wait", lip = 8,
      }
    }
  }
}


