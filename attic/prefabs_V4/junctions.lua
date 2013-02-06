----------------------------------------------------------------
--  JUNCTION PREFABS
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2011-2012 Andrew Apted
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


PREFAB.JUNCTION_OCTO =
{
  fitted = "xy"

  -- these ranges allow the prefab to expand from 3 seeds to 4 seeds
  -- and still mesh up properly with the nearby hallway pieces.
  x_ranges = { {192,0}, {192,1}, {192,0} }
  y_ranges = { {192,0}, {192,1}, {192,0} }

  defaults =
  {
    light_ent = "light"

    north_wall_q = 0
     east_wall_q = 0
     west_wall_q = 0

    style = { [0]=90, [9]=5 }
  }

  brushes =
  {
    -- south west corner
    {
      { x =   0, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?wall", y_offset=0 }
      { x = 192, y =  64, mat = "?wall", y_offset=0 }
      { x =  64, y = 192, mat = "?wall", y_offset=0 }
      { x =   0, y = 192, mat = "?outer" }
    }

    -- south east corner
    {
      { x = 576, y =   0, mat = "?outer" }
      { x = 576, y = 192, mat = "?wall", y_offset=0 }
      { x = 512, y = 192, mat = "?wall", y_offset=0 }
      { x = 384, y =  64, mat = "?wall", y_offset=0 }
      { x = 384, y =   0, mat = "?outer" }
    }

    -- north west corner
    {
      { x =   0, y = 576, mat = "?outer" }
      { x =   0, y = 384, mat = "?wall", y_offset=0 }
      { x =  64, y = 384, mat = "?wall", y_offset=0 }
      { x = 192, y = 512, mat = "?wall", y_offset=0 }
      { x = 192, y = 576, mat = "?outer" }
    }

    -- north east corner
    {
      { x = 576, y = 576, mat = "?outer" }
      { x = 384, y = 576, mat = "?wall", y_offset=0 }
      { x = 384, y = 512, mat = "?wall", y_offset=0 }
      { x = 512, y = 384, mat = "?wall", y_offset=0 }
      { x = 576, y = 384, mat = "?outer" }
    }

    -- north wall (conditional)
    {
      { m = "solid", only_if = "?north_wall_q" }
      { x = 192, y = 544, mat = "?wall", y_offset=0 }
      { x = 384, y = 544, mat = "?wall", y_offset=0 }
      { x = 384, y = 576, mat = "?outer" }
      { x = 192, y = 576, mat = "?wall", y_offset=0 }
    }

    -- west wall (conditional)
    {
      { m = "solid", only_if = "?west_wall_q" }
      { x =   0, y = 192, mat = "?wall", y_offset=0 }
      { x =  32, y = 192, mat = "?wall", y_offset=0 }
      { x =  32, y = 384, mat = "?wall", y_offset=0 }
      { x =   0, y = 384, mat = "?outer" }
    }

    -- east wall (conditional)
    {
      { m = "solid", only_if = "?east_wall_q" }
      { x = 544, y = 192, mat = "?wall", y_offset=0 }
      { x = 576, y = 192, mat = "?outer" }
      { x = 576, y = 384, mat = "?wall", y_offset=0 }
      { x = 544, y = 384, mat = "?wall", y_offset=0 }
    }

    -- floor
    {
      { x =   0, y =   0, mat = "?wall" }
      { x = 576, y =   0, mat = "?wall" }
      { x = 576, y = 576, mat = "?wall" }
      { x =   0, y = 576, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }

    -- ceiling
    {
      { x =   0, y =   0, mat = "?ceil" }
      { x = 576, y =   0, mat = "?ceil" }
      { x = 576, y = 192, mat = "?ceil" }
      { x =   0, y = 192, mat = "?ceil" }
      { b = 256, mat = "?ceil" }
    }

    {
      { x =   0, y = 384, mat = "?ceil" }
      { x = 576, y = 384, mat = "?ceil" }
      { x = 576, y = 576, mat = "?ceil" }
      { x =   0, y = 576, mat = "?ceil" }
      { b = 256, mat = "?ceil" }
    }

    {
      { x =   0, y = 192, mat = "?ceil" }
      { x = 192, y = 192, mat = "?ceil" }
      { x = 192, y = 384, mat = "?ceil" }
      { x =   0, y = 384, mat = "?ceil" }
      { b = 256, mat = "?ceil" }
    }

    {
      { x = 384, y = 192, mat = "?ceil" }
      { x = 576, y = 192, mat = "?ceil" }
      { x = 576, y = 384, mat = "?ceil" }
      { x = 384, y = 384, mat = "?ceil" }
      { b = 256, mat = "?ceil" }
    }

    -- sky hole
    {
      { m = "solid" }
      { x = 192, y = 192, mat = "?hole" }
      { x = 384, y = 192, mat = "?hole" }
      { x = 384, y = 384, mat = "?hole" }
      { x = 192, y = 384, mat = "?hole" }
      { b = 304, mat = "?hole" }
    }

    -- monster spot
    {
      { m = "spot" }
      { x = 144, y = 144 }
      { x = 432, y = 144 }
      { x = 432, y = 432 }
      { x = 144, y = 432 }
      { b = 0 }
      { t = 200 }
    }
  }

  entities =
  {
    { ent = "?light_ent", x = 240, y = 240, z = 192, light = 120, _factor=2, style="?style" }
    { ent = "?light_ent", x = 336, y = 240, z = 192, light = 120, _factor=2, style="?style" }
    { ent = "?light_ent", x = 240, y = 336, z = 192, light = 120, _factor=2, style="?style" }
    { ent = "?light_ent", x = 336, y = 336, z = 192, light = 120, _factor=2, style="?style" }
  }
}


PREFAB.JUNCTION_NUKEY_C =
{
  fitted = "xy"

  -- these ranges allow the prefab to expand from 3 seeds to 4 seeds
  -- and still mesh up properly with the nearby hallway pieces.
  x_ranges = { {192,0}, {192,1}, {192,0} }
  y_ranges = { {192,0}, {192,1}, {192,0} }

  defaults =
  {
    support_ox = 0
  }

  brushes =
  {
    -- floor
    {
      { x =   0, y =   0, mat = "_LIQUID" }
      { x = 560, y =   0, mat = "_LIQUID" }
      { x = 560, y = 560, mat = "_LIQUID" }
      { x =   0, y = 560, mat = "_LIQUID" }
      { t = -16, mat = "_LIQUID" }
    }

    -- ceiling
    {
      { x =   0, y =   0, mat = "?wall" }
      { x = 560, y =   0, mat = "?wall" }
      { x = 560, y = 560, mat = "?wall" }
      { x =   0, y = 560, mat = "?wall" }
      { b = 176, mat = "?ceil" }
    }

    -- supports near exits
    {
      { x = 176, y =   0, mat = "?support", x_offset=24 }
      { x = 192, y =   0, mat = "?support", x_offset=24 }
      { x = 192, y =  16, mat = "?support", x_offset=24 }
      { x = 176, y =  16, mat = "?support", x_offset=24 }
    }

    {
      { x = 384, y =   0, mat = "?support", x_offset=24 }
      { x = 400, y =   0, mat = "?support", x_offset=24 }
      { x = 400, y =  16, mat = "?support", x_offset=24 }
      { x = 384, y =  16, mat = "?support", x_offset=24 }
    }

    {
      { x =   0, y = 176, mat = "?support", x_offset="?support_ox" }
      { x =  16, y = 176, mat = "?support", x_offset="?support_ox" }
      { x =  16, y = 192, mat = "?support", x_offset="?support_ox" }
      { x =   0, y = 192, mat = "?support", x_offset="?support_ox" }
    }

    {
      { x =   0, y = 384, mat = "?support", x_offset="?support_ox" }
      { x =  16, y = 384, mat = "?support", x_offset="?support_ox" }
      { x =  16, y = 400, mat = "?support", x_offset="?support_ox" }
      { x =   0, y = 400, mat = "?support", x_offset="?support_ox" }
    }

    -- south west corner
    {
      { x =   0, y =   0, mat = "?outer" }
      { x = 176, y =   0, mat = "?wall" }
      { x = 176, y =  16, mat = "?wall" }
      { x =  64, y =  64, mat = "?wall" }
    }

    {
      { x =   0, y =   0, mat = "?wall" }
      { x =  64, y =  64, mat = "?wall" }
      { x =  16, y = 176, mat = "?wall" }
      { x =   0, y = 176, mat = "?outer" }
    }

    -- north side
    {
      { x =   0, y = 400, mat = "?wall" }
      { x =  16, y = 400, mat = "?wall" }
      { x = 104, y = 520, mat = "?wall" }
      { x = 104, y = 576, mat = "?outer" }
      { x =   0, y = 576, mat = "?outer" }
    }

    {
      { x = 104, y = 520, mat = "?wall" }
      { x = 264, y = 560, mat = "?wall" }
      { x = 264, y = 576, mat = "?outer" }
      { x = 104, y = 576, mat = "?wall" }
    }

    {
      { x = 264, y = 560, mat = "?wall" }
      { x = 432, y = 512, mat = "?wall" }
      { x = 432, y = 576, mat = "?outer" }
      { x = 264, y = 576, mat = "?wall" }
    }

    {
      { x = 432, y = 512, mat = "?wall" }
      { x = 480, y = 560, mat = "?wall" }
      { x = 480, y = 576, mat = "?outer" }
      { x = 432, y = 576, mat = "?wall" }
    }

    {
      { x = 480, y = 560, mat = "?wall" }
      { x = 544, y = 544, mat = "?wall" }
      { x = 576, y = 576, mat = "?outer" }
      { x = 480, y = 576, mat = "?wall" }
    }

    -- east side
    {
      { x = 400, y =  16, mat = "?wall" }
      { x = 400, y =   0, mat = "?outer" }
      { x = 576, y =   0, mat = "?outer" }
      { x = 576, y =  96, mat = "?wall" }
      { x = 528, y =  96, mat = "?wall" }
    }

    {
      { x = 528, y =  96, mat = "?wall" }
      { x = 576, y =  96, mat = "?outer" }
      { x = 576, y = 280, mat = "?wall" }
      { x = 560, y = 280, mat = "?wall" }
    }

    {
      { x = 560, y = 280, mat = "?wall" }
      { x = 576, y = 280, mat = "?outer" }
      { x = 576, y = 432, mat = "?wall" }
      { x = 512, y = 432, mat = "?wall" }
    }

    {
      { x = 512, y = 432, mat = "?wall" }
      { x = 576, y = 432, mat = "?outer" }
      { x = 576, y = 480, mat = "?wall" }
      { x = 560, y = 480, mat = "?wall" }
    }

    {
      { x = 560, y = 480, mat = "?wall" }
      { x = 576, y = 480, mat = "?outer" }
      { x = 576, y = 576, mat = "?wall" }
      { x = 544, y = 544, mat = "?wall" }
    }

    -- islands #1
    {
      { x =  80, y = 280, mat = "?island" }
      { x = 160, y = 264, mat = "?island" }
      { x = 248, y = 312, mat = "?island" }
      { x = 248, y = 400, mat = "?island" }
      { x = 160, y = 456, mat = "?island" }
      { x =  80, y = 416, mat = "?island" }
      { x =  56, y = 360, mat = "?island" }
      { t = 0, mat = "?island" }
    }

    {
      { m = "light", add=48 }
      { x =  80, y = 280 }
      { x = 160, y = 264 }
      { x = 248, y = 312 }
      { x = 248, y = 400 }
      { x = 160, y = 456 }
      { x =  80, y = 416 }
      { x =  56, y = 360 }
    }

    -- islands #2
    {
      { x = 296, y =  88, mat = "?island" }
      { x = 384, y =  72, mat = "?island" }
      { x = 432, y = 128, mat = "?island" }
      { x = 432, y = 200, mat = "?island" }
      { x = 360, y = 248, mat = "?island" }
      { x = 280, y = 232, mat = "?island" }
      { x = 264, y = 160, mat = "?island" }
      { t = 0, mat = "?island" }
    }

    {
      { m = "light", add=48 }
      { x = 296, y =  88 }
      { x = 384, y =  72 }
      { x = 432, y = 128 }
      { x = 432, y = 200 }
      { x = 360, y = 248 }
      { x = 280, y = 232 }
      { x = 264, y = 160 }
    }

    -- lamps in ceiling
    {
      { x = 128, y = 320, mat = "?lamp" }
      { x = 192, y = 320, mat = "?lamp" }
      { x = 192, y = 384, mat = "?lamp" }
      { x = 128, y = 384, mat = "?lamp" }
      { b = 160, mat = "?lamp" }
    }

    {
      { x = 320, y = 128, mat = "?lamp" }
      { x = 384, y = 128, mat = "?lamp" }
      { x = 384, y = 192, mat = "?lamp" }
      { x = 320, y = 192, mat = "?lamp" }
      { b = 160, mat = "?lamp" }
    }

    -- nukage hole in wall
    {
      { x = 432, y = 512, mat = "_LIQUID" }
      { x = 512, y = 432, mat = "_LIQUID" }
      { x = 528, y = 448, mat = "_LIQUID" }
      { x = 448, y = 528, mat = "_LIQUID" }
      { t = 88, mat = "_LIQUID" }
    }
    {
      { x = 432, y = 512, mat = "?wall" }
      { x = 512, y = 432, mat = "?wall" }
      { x = 528, y = 448, mat = "?wall" }
      { x = 448, y = 528, mat = "?wall" }
      { b = 136, mat = "?ceil" }
    }
    {
      { m = "light", sub=16 }
      { x = 432, y = 512 }
      { x = 512, y = 432 }
      { x = 528, y = 448 }
      { x = 448, y = 528 }
    }

    {
      { x = 448, y = 528, mat = "_LIQUID" }
      { x = 528, y = 448, mat = "_LIQUID" }
      { x = 544, y = 464, mat = "_LIQUID" }
      { x = 464, y = 544, mat = "_LIQUID" }
      { t = 88, mat = "_LIQUID" }
    }
    {
      { x = 448, y = 528, mat = "?wall" }
      { x = 528, y = 448, mat = "?wall" }
      { x = 544, y = 464, mat = "?wall" }
      { x = 464, y = 544, mat = "?wall" }
      { b = 136, mat = "?ceil" }
    }
    {
      { m = "light", sub=32 }
      { x = 448, y = 528 }
      { x = 528, y = 448 }
      { x = 544, y = 464 }
      { x = 464, y = 544 }
    }
    
    {
      { x = 464, y = 544, mat = "_LIQUID" }
      { x = 544, y = 464, mat = "_LIQUID" }
      { x = 560, y = 480, mat = "_LIQUID" }
      { x = 480, y = 560, mat = "_LIQUID" }
      { t = 88, mat = "_LIQUID" }
    }
    {
      { x = 464, y = 544, mat = "?wall" }
      { x = 544, y = 464, mat = "?wall" }
      { x = 560, y = 480, mat = "?wall" }
      { x = 480, y = 560, mat = "?wall" }
      { b = 136, mat = "?ceil" }
    }
    {
      { m = "light", sub=48 }
      { x = 464, y = 544 }
      { x = 544, y = 464 }
      { x = 560, y = 480 }
      { x = 480, y = 560 }
    }

    {
      { x = 480, y = 560, mat = "_LIQUID" }
      { x = 560, y = 480, mat = "_LIQUID" }
      { x = 544, y = 544, mat = "_LIQUID" }
      { t = 88, mat = "_LIQUID" }
    }
    {
      { x = 480, y = 560, mat = "?wall" }
      { x = 560, y = 480, mat = "?wall" }
      { x = 544, y = 544, mat = "?wall" }
      { b = 136, mat = "?ceil" }
    }
    {
      { m = "light", sub=64 }
      { x = 480, y = 560 }
      { x = 560, y = 480 }
      { x = 544, y = 544 }
    }
  }
}


PREFAB.JUNCTION_CIRCLE =
{
  fitted = "xy"

  defaults =
  {
    step = "?circle"
    plinth_top = "?plinth"
    plinth_ent = "none"
    torch_ent = "none"

    bill_ox = 0
    bill_oy = 0

    north_h = 192
    south_h = 192
    east_h  = 192
    west_h  = 192
  }

  brushes =
  {
    {
      { x =   0, y = 576, mat = "?wall" }
      { x =  64, y = 512, mat = "?wall" }
      { x = 192, y = 512, mat = "?wall" }
      { x = 192, y = 576, mat = "?outer" }
    }

    {
      { x = 384, y =   0, mat = "?outer" }
      { x = 576, y =   0, mat = "?wall" }
      { x = 512, y =  64, mat = "?wall" }
      { x = 384, y =  64, mat = "?wall" }
    }

    {
      { x =   0, y =   0, mat = "?wall" }
      { x =  64, y =  64, mat = "?wall" }
      { x =  64, y = 192, mat = "?wall" }
      { x =   0, y = 192, mat = "?outer" }
    }

    {
      { x = 512, y = 384, mat = "?wall" }
      { x = 576, y = 384, mat = "?outer" }
      { x = 576, y = 576, mat = "?wall" }
      { x = 512, y = 512, mat = "?wall" }
    }

    {
      { x =   0, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y =  64, mat = "?wall" }
      { x =  64, y =  64, mat = "?wall" }
    }

    {
      { x = 192, y =   0, mat = "?outer" }
      { x = 384, y =   0, mat = "?wall" }
      { x = 384, y =  16, mat = "?wall" }
      { x = 192, y =  16, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x = 192, y =   0, mat = "?outer" }
      { x = 384, y =   0, mat = "?wall" }
      { x = 384, y =  16, mat = "?wall" }
      { x = 192, y =  16, mat = "?wall" }
      { b = "?south_h", mat = "?wall" }
    }

    {
      { x = 512, y =  64, mat = "?wall" }
      { x = 576, y =   0, mat = "?outer" }
      { x = 576, y = 192, mat = "?wall" }
      { x = 512, y = 192, mat = "?wall" }
    }

    {
      { x = 560, y = 192, mat = "?wall" }
      { x = 576, y = 192, mat = "?outer" }
      { x = 576, y = 384, mat = "?wall" }
      { x = 560, y = 384, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x = 560, y = 192, mat = "?wall" }
      { x = 576, y = 192, mat = "?outer" }
      { x = 576, y = 384, mat = "?wall" }
      { x = 560, y = 384, mat = "?wall" }
      { b = "?east_h", mat = "?wall" }
    }

    {
      { x = 384, y = 512, mat = "?wall" }
      { x = 512, y = 512, mat = "?wall" }
      { x = 576, y = 576, mat = "?outer" }
      { x = 384, y = 576, mat = "?wall" }
    }

    {
      { x = 192, y = 560, mat = "?wall" }
      { x = 384, y = 560, mat = "?wall" }
      { x = 384, y = 576, mat = "?outer" }
      { x = 192, y = 576, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x = 192, y = 560, mat = "?wall" }
      { x = 384, y = 560, mat = "?wall" }
      { x = 384, y = 576, mat = "?outer" }
      { x = 192, y = 576, mat = "?wall" }
      { b = "?north_h", mat = "?wall" }
    }

    {
      { x =   0, y = 384, mat = "?wall" }
      { x =  64, y = 384, mat = "?wall" }
      { x =  64, y = 512, mat = "?wall" }
      { x =   0, y = 576, mat = "?outer" }
    }

    {
      { x =   0, y = 192, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { x =  16, y = 384, mat = "?wall" }
      { x =   0, y = 384, mat = "?outer" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =   0, y = 192, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { x =  16, y = 384, mat = "?wall" }
      { x =   0, y = 384, mat = "?outer" }
      { b = "?west_h", mat = "?wall" }
    }

    {
      { x = 192, y =  16, mat = "?wall" }
      { x = 384, y =  16, mat = "?wall" }
      { x = 384, y =  64, mat = "?wall" }
      { x = 320, y = 128, mat = "?step" }
      { x = 256, y = 128, mat = "?wall" }
      { x = 192, y =  64, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x = 192, y =  16, mat = "?wall" }
      { x = 384, y =  16, mat = "?wall" }
      { x = 384, y =  64, mat = "?wall" }
      { x = 320, y = 128, mat = "?wall" }
      { x = 256, y = 128, mat = "?wall" }
      { x = 192, y =  64, mat = "?wall" }
      { b = 320, mat = "_SKY" }
    }

    {
      { x =  64, y =  64, mat = "?wall" }
      { x = 192, y =  64, mat = "?wall" }
      { x = 256, y = 128, mat = "?step" }
      { x = 176, y = 176, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  64, y =  64, mat = "?wall" }
      { x = 192, y =  64, mat = "?wall" }
      { x = 256, y = 128, mat = "?wall" }
      { x = 176, y = 176, mat = "?wall" }
      { b = 320, mat = "_SKY" }
    }

    {
      { x =  64, y =  64, mat = "?wall" }
      { x = 176, y = 176, mat = "?step" }
      { x = 128, y = 256, mat = "?wall" }
      { x =  64, y = 192, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  64, y =  64, mat = "?wall" }
      { x = 176, y = 176, mat = "?wall" }
      { x = 128, y = 256, mat = "?wall" }
      { x =  64, y = 192, mat = "?wall" }
      { b = 320, mat = "_SKY" }
    }

    {
      { x =  16, y = 192, mat = "?wall" }
      { x =  64, y = 192, mat = "?wall" }
      { x = 128, y = 256, mat = "?step" }
      { x = 128, y = 320, mat = "?wall" }
      { x =  64, y = 384, mat = "?wall" }
      { x =  16, y = 384, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  16, y = 192, mat = "?wall" }
      { x =  64, y = 192, mat = "?wall" }
      { x = 128, y = 256, mat = "?wall" }
      { x = 128, y = 320, mat = "?wall" }
      { x =  64, y = 384, mat = "?wall" }
      { x =  16, y = 384, mat = "?wall" }
      { b = 320, mat = "_SKY" }
    }

    {
      { x =  64, y = 384, mat = "?wall" }
      { x = 128, y = 320, mat = "?step" }
      { x = 176, y = 400, mat = "?wall" }
      { x =  64, y = 512, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  64, y = 384, mat = "?wall" }
      { x = 128, y = 320, mat = "?wall" }
      { x = 176, y = 400, mat = "?wall" }
      { x =  64, y = 512, mat = "?wall" }
      { b = 320, mat = "_SKY" }
    }

    {
      { x =  64, y = 512, mat = "?wall" }
      { x = 176, y = 400, mat = "?step" }
      { x = 256, y = 448, mat = "?wall" }
      { x = 192, y = 512, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  64, y = 512, mat = "?wall" }
      { x = 176, y = 400, mat = "?wall" }
      { x = 256, y = 448, mat = "?wall" }
      { x = 192, y = 512, mat = "?wall" }
      { b = 320, mat = "_SKY" }
    }

    {
      { x = 192, y = 512, mat = "?wall" }
      { x = 256, y = 448, mat = "?step" }
      { x = 320, y = 448, mat = "?wall" }
      { x = 384, y = 512, mat = "?wall" }
      { x = 384, y = 560, mat = "?wall" }
      { x = 192, y = 560, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x = 192, y = 512, mat = "?wall" }
      { x = 256, y = 448, mat = "?wall" }
      { x = 320, y = 448, mat = "?wall" }
      { x = 384, y = 512, mat = "?wall" }
      { x = 384, y = 560, mat = "?wall" }
      { x = 192, y = 560, mat = "?wall" }
      { b = 320, mat = "_SKY" }
    }

    {
      { x = 320, y = 448, mat = "?step" }
      { x = 400, y = 400, mat = "?wall" }
      { x = 512, y = 512, mat = "?wall" }
      { x = 384, y = 512, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x = 320, y = 448, mat = "?wall" }
      { x = 400, y = 400, mat = "?wall" }
      { x = 512, y = 512, mat = "?wall" }
      { x = 384, y = 512, mat = "?wall" }
      { b = 320, mat = "_SKY" }
    }

    {
      { x = 400, y = 400, mat = "?step" }
      { x = 448, y = 320, mat = "?wall" }
      { x = 512, y = 384, mat = "?wall" }
      { x = 512, y = 512, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x = 400, y = 400, mat = "?wall" }
      { x = 448, y = 320, mat = "?wall" }
      { x = 512, y = 384, mat = "?wall" }
      { x = 512, y = 512, mat = "?wall" }
      { b = 320, mat = "_SKY" }
    }

    {
      { x = 448, y = 256, mat = "?wall" }
      { x = 512, y = 192, mat = "?wall" }
      { x = 560, y = 192, mat = "?wall" }
      { x = 560, y = 384, mat = "?wall" }
      { x = 512, y = 384, mat = "?wall" }
      { x = 448, y = 320, mat = "?step" }
      { t = 0, mat = "?floor" }
    }
    {
      { x = 448, y = 256, mat = "?wall" }
      { x = 512, y = 192, mat = "?wall" }
      { x = 560, y = 192, mat = "?wall" }
      { x = 560, y = 384, mat = "?wall" }
      { x = 512, y = 384, mat = "?wall" }
      { x = 448, y = 320, mat = "?wall" }
      { b = 320, mat = "_SKY" }
    }

    {
      { x = 400, y = 176, mat = "?wall" }
      { x = 512, y =  64, mat = "?wall" }
      { x = 512, y = 192, mat = "?wall" }
      { x = 448, y = 256, mat = "?step" }
      { t = 0, mat = "?floor" }
    }
    {
      { x = 400, y = 176, mat = "?wall" }
      { x = 512, y =  64, mat = "?wall" }
      { x = 512, y = 192, mat = "?wall" }
      { x = 448, y = 256, mat = "?wall" }
      { b = 320, mat = "_SKY" }
    }

    {
      { x = 320, y = 128, mat = "?wall" }
      { x = 384, y =  64, mat = "?wall" }
      { x = 512, y =  64, mat = "?wall" }
      { x = 400, y = 176, mat = "?step" }
      { t = 0, mat = "?floor" }
    }
    {
      { x = 320, y = 128, mat = "?wall" }
      { x = 384, y =  64, mat = "?wall" }
      { x = 512, y =  64, mat = "?wall" }
      { x = 400, y = 176, mat = "?wall" }
      { b = 320, mat = "_SKY" }
    }

    {
      { x = 128, y = 256, mat = "?circle" }
      { x = 176, y = 176, mat = "?circle" }
      { x = 256, y = 128, mat = "?circle" }
      { x = 320, y = 128, mat = "?circle" }
      { x = 400, y = 176, mat = "?circle" }
      { x = 448, y = 256, mat = "?circle" }
      { x = 448, y = 320, mat = "?circle" }
      { x = 400, y = 400, mat = "?circle" }
      { x = 320, y = 448, mat = "?circle" }
      { x = 256, y = 448, mat = "?circle" }
      { x = 176, y = 400, mat = "?circle" }
      { x = 128, y = 320, mat = "?circle" }
      { t = -16, mat = "?circle" }
    }
    {
      { x = 128, y = 256, mat = "?wall" }
      { x = 176, y = 176, mat = "?wall" }
      { x = 256, y = 128, mat = "?wall" }
      { x = 320, y = 128, mat = "?wall" }
      { x = 400, y = 176, mat = "?wall" }
      { x = 448, y = 256, mat = "?wall" }
      { x = 448, y = 320, mat = "?wall" }
      { x = 400, y = 400, mat = "?wall" }
      { x = 320, y = 448, mat = "?wall" }
      { x = 256, y = 448, mat = "?wall" }
      { x = 176, y = 400, mat = "?wall" }
      { x = 128, y = 320, mat = "?wall" }
      { b = 320, mat = "_SKY" }
    }

    {
      { x = 240, y = 288, mat = "?plinth", y_offset=0, peg=1 }
      { x = 288, y = 240, mat = "?plinth", y_offset=0, peg=1  }
      { x = 336, y = 288, mat = "?plinth", y_offset=0, peg=1  }
      { x = 288, y = 336, mat = "?plinth", y_offset=0, peg=1  }
      { t = 56, mat = "?plinth_top" }
    }

    {
      { x = 544, y = 256, mat = "?bill_side" }
      { x = 560, y = 256, mat = "?bill_side" }
      { x = 560, y = 320, mat = "?bill_side" }
      { x = 544, y = 320, mat = "?billboard", x_offset="?bill_ox", y_offset="?bill_oy", peg=0 }
      { b = 256, mat = "?bill_side" }
    }

    {
      { x = 256, y = 544, mat = "?billboard", x_offset="?bill_ox", y_offset="?bill_oy", peg=0 }
      { x = 320, y = 544, mat = "?bill_side" }
      { x = 320, y = 560, mat = "?bill_side" }
      { x = 256, y = 560, mat = "?bill_side" }
      { b = 256, mat = "?bill_side" }
    }

    {
      { x =  16, y = 256, mat = "?bill_side" }
      { x =  32, y = 256, mat = "?billboard", x_offset="?bill_ox", y_offset="?bill_oy", peg=0 }
      { x =  32, y = 320, mat = "?bill_side" }
      { x =  16, y = 320, mat = "?bill_side" }
      { b = 256, mat = "?bill_side" }
    }

    {
      { x = 256, y =  16, mat = "?bill_side" }
      { x = 320, y =  16, mat = "?bill_side" }
      { x = 320, y =  32, mat = "?billboard", x_offset="?bill_ox", y_offset="?bill_oy", peg=0 }
      { x = 256, y =  32, mat = "?bill_side" }
      { b = 256, mat = "?bill_side" }
    }
  }

  entities =
  {
    { ent = "?torch_ent",  x = 480, y = 480, z = 0, angle = 225 }
    { ent = "?torch_ent",  x =  96, y = 480, z = 0, angle = 315 }
    { ent = "?torch_ent",  x =  96, y =  96, z = 0, angle =  45 }
    { ent = "?torch_ent",  x = 480, y =  96, z = 0, angle = 135 }

    { ent = "?plinth_ent", x = 288, y = 288, z = 56, angle = 90 }
  }
}


PREFAB.JUNCTION_SPOKEY =
{
  fitted = "xy"

  defaults =
  {
    hole = "_SKY"
    hole_light = ""

    north_h = 192
    south_h = 192
    east_h  = 192
    west_h  = 192
  }

  brushes =
  {
    {
      { x =  16, y = 192, mat = "?floor" }
      { x =  64, y =  96, mat = "?floor" }
      { x =  96, y =  64, mat = "?floor" }
      { x = 192, y =  16, mat = "?floor" }
      { x = 384, y =  16, mat = "?floor" }
      { x = 480, y =  64, mat = "?floor" }
      { x = 512, y =  96, mat = "?floor" }
      { x = 560, y = 192, mat = "?floor" }
      { x = 560, y = 384, mat = "?floor" }
      { x = 512, y = 480, mat = "?floor" }
      { x = 480, y = 512, mat = "?floor" }
      { x = 384, y = 560, mat = "?floor" }
      { x = 192, y = 560, mat = "?floor" }
      { x =  96, y = 512, mat = "?floor" }
      { x =  64, y = 480, mat = "?floor" }
      { x =  16, y = 384, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }

    {
      { x =  16, y = 192, mat = "?hole" }
      { x =  64, y =  96, mat = "?hole" }
      { x =  96, y =  64, mat = "?hole" }
      { x = 192, y =  16, mat = "?hole" }
      { x = 384, y =  16, mat = "?hole" }
      { x = 480, y =  64, mat = "?hole" }
      { x = 512, y =  96, mat = "?hole" }
      { x = 560, y = 192, mat = "?hole" }
      { x = 560, y = 384, mat = "?hole" }
      { x = 512, y = 480, mat = "?hole" }
      { x = 480, y = 512, mat = "?hole" }
      { x = 384, y = 560, mat = "?hole" }
      { x = 192, y = 560, mat = "?hole" }
      { x =  96, y = 512, mat = "?hole" }
      { x =  64, y = 480, mat = "?hole" }
      { x =  16, y = 384, mat = "?hole" }
      { b = 320, mat = "?hole", light = "?hole_light" }
    }

    {
      { x =   0, y = 480, mat = "?wall" }
      { x =  64, y = 480, mat = "?wall" }
      { x =  96, y = 512, mat = "?wall" }
      { x =  96, y = 576, mat = "?outer" }
      { x =   0, y = 576, mat = "?outer" }
    }

    {
      { x = 480, y =   0, mat = "?outer" }
      { x = 576, y =   0, mat = "?outer" }
      { x = 576, y =  96, mat = "?wall" }
      { x = 512, y =  96, mat = "?wall" }
      { x = 480, y =  64, mat = "?wall" }
    }

    {
      { x =   0, y =   0, mat = "?outer" }
      { x =  96, y =   0, mat = "?wall" }
      { x =  96, y =  64, mat = "?wall" }
      { x =  64, y =  96, mat = "?wall" }
      { x =   0, y =  96, mat = "?outer" }
    }

    {
      { x = 480, y = 512, mat = "?wall" }
      { x = 512, y = 480, mat = "?wall" }
      { x = 576, y = 480, mat = "?outer" }
      { x = 576, y = 576, mat = "?outer" }
      { x = 480, y = 576, mat = "?wall" }
    }

    {
      { x =  96, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y =  16, mat = "?wall" }
      { x =  96, y =  64, mat = "?wall" }
    }

    {
      { x = 192, y =   0, mat = "?outer" }
      { x = 384, y =   0, mat = "?wall" }
      { x = 384, y =  16, mat = "?wall" }
      { x = 192, y =  16, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x = 192, y =   0, mat = "?outer" }
      { x = 384, y =   0, mat = "?wall" }
      { x = 384, y =  16, mat = "?wall" }
      { x = 192, y =  16, mat = "?wall" }
      { b = "?south_h", mat = "?wall" }
    }

    {
      { x = 512, y =  96, mat = "?wall" }
      { x = 576, y =  96, mat = "?outer" }
      { x = 576, y = 192, mat = "?wall" }
      { x = 560, y = 192, mat = "?wall" }
    }

    {
      { x = 560, y = 192, mat = "?wall" }
      { x = 576, y = 192, mat = "?outer" }
      { x = 576, y = 384, mat = "?wall" }
      { x = 560, y = 384, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x = 560, y = 192, mat = "?wall" }
      { x = 576, y = 192, mat = "?outer" }
      { x = 576, y = 384, mat = "?wall" }
      { x = 560, y = 384, mat = "?wall" }
      { b = "?east_h", mat = "?wall" }
    }

    {
      { x = 384, y = 560, mat = "?wall" }
      { x = 480, y = 512, mat = "?wall" }
      { x = 480, y = 576, mat = "?outer" }
      { x = 384, y = 576, mat = "?wall" }
    }

    {
      { x = 192, y = 560, mat = "?wall" }
      { x = 384, y = 560, mat = "?wall" }
      { x = 384, y = 576, mat = "?outer" }
      { x = 192, y = 576, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x = 192, y = 560, mat = "?wall" }
      { x = 384, y = 560, mat = "?wall" }
      { x = 384, y = 576, mat = "?outer" }
      { x = 192, y = 576, mat = "?wall" }
      { b = "?north_h", mat = "?wall" }
    }

    {
      { x =   0, y = 384, mat = "?wall" }
      { x =  16, y = 384, mat = "?wall" }
      { x =  64, y = 480, mat = "?wall" }
      { x =   0, y = 480, mat = "?outer" }
    }

    {
      { x =   0, y = 192, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { x =  16, y = 384, mat = "?wall" }
      { x =   0, y = 384, mat = "?outer" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =   0, y = 192, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { x =  16, y = 384, mat = "?wall" }
      { x =   0, y = 384, mat = "?outer" }
      { b = "?west_h", mat = "?wall" }
    }

    {
      { x =  96, y =  64, mat = "?wall" }
      { x = 192, y =  16, mat = "?wall" }
      { x = 208, y =  48, mat = "?metal" }
      { x = 120, y =  88, mat = "?wall" }
      { b = 304, mat = "?metal" }
    }

    {
      { x =   0, y =  96, mat = "?wall" }
      { x =  64, y =  96, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { x =   0, y = 192, mat = "?outer" }
    }

    {
      { x =  16, y = 192, mat = "?wall" }
      { x =  64, y =  96, mat = "?wall" }
      { x =  88, y = 120, mat = "?metal" }
      { x =  48, y = 208, mat = "?wall" }
      { b = 304, mat = "?metal" }
    }

    {
      { x =  16, y = 384, mat = "?wall" }
      { x =  48, y = 368, mat = "?metal" }
      { x =  88, y = 456, mat = "?wall" }
      { x =  64, y = 480, mat = "?wall" }
      { b = 304, mat = "?metal" }
    }

    {
      { x =  96, y = 512, mat = "?wall" }
      { x = 192, y = 560, mat = "?wall" }
      { x = 192, y = 576, mat = "?outer" }
      { x =  96, y = 576, mat = "?wall" }
    }

    {
      { x =  96, y = 512, mat = "?wall" }
      { x = 120, y = 488, mat = "?metal" }
      { x = 208, y = 528, mat = "?wall" }
      { x = 192, y = 560, mat = "?wall" }
      { b = 304, mat = "?metal" }
    }

    {
      { x = 368, y = 528, mat = "?metal" }
      { x = 456, y = 488, mat = "?wall" }
      { x = 480, y = 512, mat = "?wall" }
      { x = 384, y = 560, mat = "?wall" }
      { b = 304, mat = "?metal" }
    }

    {
      { x = 512, y = 480, mat = "?wall" }
      { x = 560, y = 384, mat = "?wall" }
      { x = 576, y = 384, mat = "?outer" }
      { x = 576, y = 480, mat = "?wall" }
    }

    {
      { x = 488, y = 456, mat = "?metal" }
      { x = 528, y = 368, mat = "?wall" }
      { x = 560, y = 384, mat = "?wall" }
      { x = 512, y = 480, mat = "?wall" }
      { b = 304, mat = "?metal" }
    }

    {
      { x = 456, y =  88, mat = "?metal" }
      { x = 480, y =  64, mat = "?metal" }
      { x = 512, y =  96, mat = "?metal" }
      { x = 488, y = 120, mat = "?metal" }
    }

    {
      { x = 384, y =   0, mat = "?outer" }
      { x = 480, y =   0, mat = "?wall" }
      { x = 480, y =  64, mat = "?wall" }
      { x = 384, y =  16, mat = "?wall" }
    }

    {
      { x = 368, y =  48, mat = "?wall" }
      { x = 384, y =  16, mat = "?wall" }
      { x = 480, y =  64, mat = "?wall" }
      { x = 456, y =  88, mat = "?metal" }
      { b = 304, mat = "?metal" }
    }

    {
      { x = 256, y = 272, mat = "?metal" }
      { x = 272, y = 256, mat = "?metal" }
      { x = 304, y = 256, mat = "?metal" }
      { x = 320, y = 272, mat = "?metal" }
      { x = 320, y = 304, mat = "?metal" }
      { x = 304, y = 320, mat = "?metal" }
      { x = 272, y = 320, mat = "?metal" }
      { x = 256, y = 304, mat = "?metal" }
    }

    {
      { x = 240, y = 272, mat = "?metal" }
      { x = 272, y = 240, mat = "?metal" }
      { x = 304, y = 240, mat = "?metal" }
      { x = 336, y = 272, mat = "?metal" }
      { x = 336, y = 304, mat = "?metal" }
      { x = 304, y = 336, mat = "?metal" }
      { x = 272, y = 336, mat = "?metal" }
      { x = 240, y = 304, mat = "?metal" }
      { t = 64, mat = "?metal" }
    }
    {
      { x = 240, y = 272, mat = "?metal" }
      { x = 272, y = 240, mat = "?metal" }
      { x = 304, y = 240, mat = "?metal" }
      { x = 336, y = 272, mat = "?metal" }
      { x = 336, y = 304, mat = "?metal" }
      { x = 304, y = 336, mat = "?metal" }
      { x = 272, y = 336, mat = "?metal" }
      { x = 240, y = 304, mat = "?metal" }
      { b = 256, mat = "?metal" }
    }

    {
      { x = 456, y = 488, mat = "?metal" }
      { x = 488, y = 456, mat = "?metal" }
      { x = 512, y = 480, mat = "?metal" }
      { x = 480, y = 512, mat = "?metal" }
    }

    {
      { x =  64, y =  96, mat = "?metal" }
      { x =  96, y =  64, mat = "?metal" }
      { x = 120, y =  88, mat = "?metal" }
      { x =  88, y = 120, mat = "?metal" }
    }

    {
      { x = 488, y = 120, mat = "?wall" }
      { x = 512, y =  96, mat = "?wall" }
      { x = 560, y = 192, mat = "?wall" }
      { x = 528, y = 208, mat = "?metal" }
      { b = 304, mat = "?metal" }
    }

    {
      { x =  64, y = 480, mat = "?metal" }
      { x =  88, y = 456, mat = "?metal" }
      { x = 120, y = 488, mat = "?metal" }
      { x =  96, y = 512, mat = "?metal" }
    }

    {
      { x = 528, y = 208, mat = "?wall" }
      { x = 560, y = 192, mat = "?wall" }
      { x = 560, y = 384, mat = "?wall" }
      { x = 528, y = 368, mat = "?metal" }
      { x = 528, y = 304, mat = "?wall" }
      { x = 528, y = 272, mat = "?metal" }
      { b = 304, mat = "?metal" }
    }

    {
      { x = 192, y =  16, mat = "?wall" }
      { x = 384, y =  16, mat = "?wall" }
      { x = 368, y =  48, mat = "?metal" }
      { x = 304, y =  48, mat = "?wall" }
      { x = 272, y =  48, mat = "?metal" }
      { x = 208, y =  48, mat = "?wall" }
      { b = 304, mat = "?metal" }
    }

    {
      { x =  16, y = 192, mat = "?wall" }
      { x =  48, y = 208, mat = "?metal" }
      { x =  48, y = 272, mat = "?wall" }
      { x =  48, y = 304, mat = "?metal" }
      { x =  48, y = 368, mat = "?wall" }
      { x =  16, y = 384, mat = "?wall" }
      { b = 304, mat = "?metal" }
    }

    {
      { x = 192, y = 560, mat = "?wall" }
      { x = 208, y = 528, mat = "?metal" }
      { x = 272, y = 528, mat = "?wall" }
      { x = 304, y = 528, mat = "?metal" }
      { x = 368, y = 528, mat = "?wall" }
      { x = 384, y = 560, mat = "?wall" }
      { b = 304, mat = "?metal" }
    }

    {
      { x =  88, y = 456, mat = "?metal" }
      { x = 224, y = 320, mat = "?wall" }
      { x = 256, y = 352, mat = "?metal" }
      { x = 120, y = 488, mat = "?wall" }
      { b = 304, mat = "?metal" }
    }

    {
      { x = 320, y = 352, mat = "?wall" }
      { x = 352, y = 320, mat = "?metal" }
      { x = 488, y = 456, mat = "?wall" }
      { x = 456, y = 488, mat = "?metal" }
      { b = 304, mat = "?metal" }
    }

    {
      { x = 320, y = 224, mat = "?metal" }
      { x = 456, y =  88, mat = "?wall" }
      { x = 488, y = 120, mat = "?metal" }
      { x = 352, y = 256, mat = "?wall" }
      { b = 304, mat = "?metal" }
    }

    {
      { x =  88, y = 120, mat = "?wall" }
      { x = 120, y =  88, mat = "?metal" }
      { x = 256, y = 224, mat = "?wall" }
      { x = 224, y = 256, mat = "?metal" }
      { b = 304, mat = "?metal" }
    }

    {
      { x = 224, y = 256, mat = "?metal" }
      { x = 256, y = 224, mat = "?metal" }
      { x = 320, y = 224, mat = "?metal" }
      { x = 352, y = 256, mat = "?metal" }
      { x = 352, y = 320, mat = "?metal" }
      { x = 320, y = 352, mat = "?metal" }
      { x = 256, y = 352, mat = "?metal" }
      { x = 224, y = 320, mat = "?metal" }
      { b = 304, mat = "?metal" }
    }

    {
      { x =  48, y = 272, mat = "?metal" }
      { x = 224, y = 272, mat = "?wall" }
      { x = 224, y = 304, mat = "?metal" }
      { x =  48, y = 304, mat = "?wall" }
      { b = 304, mat = "?metal" }
    }

    {
      { x = 272, y = 352, mat = "?wall" }
      { x = 304, y = 352, mat = "?metal" }
      { x = 304, y = 528, mat = "?wall" }
      { x = 272, y = 528, mat = "?metal" }
      { b = 304, mat = "?metal" }
    }

    {
      { x = 352, y = 272, mat = "?metal" }
      { x = 528, y = 272, mat = "?wall" }
      { x = 528, y = 304, mat = "?metal" }
      { x = 352, y = 304, mat = "?wall" }
      { b = 304, mat = "?metal" }
    }

    {
      { x = 272, y =  48, mat = "?wall" }
      { x = 304, y =  48, mat = "?metal" }
      { x = 304, y = 224, mat = "?wall" }
      { x = 272, y = 224, mat = "?metal" }
      { b = 304, mat = "?metal" }
    }

    -- monster spots
    {
      { m = "spot" }
      { x = 224, y =  64 }
      { x = 352, y =  64 }
      { x = 352, y = 192 }
      { x = 224, y = 192 }
      { b = 0 }
      { t = 200 }
    }
    {
      { m = "spot" }
      { x = 224, y = 384 }
      { x = 352, y = 384 }
      { x = 352, y = 512 }
      { x = 224, y = 512 }
      { b = 0 }
      { t = 200 }
    }
    {
      { m = "spot" }
      { x =  64, y = 224 }
      { x = 192, y = 224 }
      { x = 192, y = 352 }
      { x =  64, y = 352 }
      { b = 0 }
      { t = 200 }
    }
    {
      { m = "spot" }
      { x = 384, y = 224 }
      { x = 512, y = 224 }
      { x = 512, y = 352 }
      { x = 384, y = 352 }
      { b = 0 }
      { t = 200 }
    }
  }
}


PREFAB.JUNCTION_NUKE_PIPES =
{
  fitted = "xy"

  -- these ranges allow the prefab to expand from 3 seeds to 4 seeds
  -- and still mesh up properly with the nearby hallway pieces.
  x_ranges = { {192,0}, {192,1}, {192,0} }
  y_ranges = { {192,0}, {192,1}, {192,0} }

  defaults =
  {
    east_h  = 128
    west_h  = 128
    north_h = 128
    south_h = 128
  }

  brushes =
  {
    {
      { x =   0, y =   0, mat = "_LIQUID" }
      { x = 576, y =   0, mat = "_LIQUID" }
      { x = 576, y = 576, mat = "_LIQUID" }
      { x =   0, y = 576, mat = "_LIQUID" }
      { t = -16, mat = "_LIQUID" }
    }

    {
      { x =   0, y =   0, mat = "?high_ceil" }
      { x = 576, y =   0, mat = "?high_ceil" }
      { x = 576, y = 576, mat = "?high_ceil" }
      { x =   0, y = 576, mat = "?high_ceil" }
      { b = 256, mat = "?high_ceil" }
    }

    {
      { x =   0, y = 520, mat = "?main_wall" }
      { x =  32, y = 520, mat = "?lite", x_offset=0, y_offset=0, peg=1 }
      { x =  56, y = 544, mat = "?main_wall" }
      { x =  56, y = 576, mat = "?outer" }
      { x =   0, y = 576, mat = "?outer" }
    }

    {
      { x =   0, y = 512, mat = "?main_wall" }
      { x =  32, y = 512, mat = "?main_wall" }
      { x =  32, y = 520, mat = "?main_wall" }
      { x =   0, y = 520, mat = "?outer" }
    }

    {
      { x =  64, y = 568, mat = "?main_wall" }
      { x = 192, y = 568, mat = "?main_wall" }
      { x = 192, y = 576, mat = "?outer" }
      { x =  64, y = 576, mat = "?main_wall" }
    }

    {
      { x =  56, y = 544, mat = "?main_wall" }
      { x =  64, y = 544, mat = "?main_wall" }
      { x =  64, y = 576, mat = "?outer" }
      { x =  56, y = 576, mat = "?main_wall" }
    }

    {
      { x =   0, y = 192, mat = "?main_wall" }
      { x =   8, y = 192, mat = "?main_wall" }
      { x =   8, y = 384, mat = "?main_wall" }
      { x =   0, y = 384, mat = "?outer" }
      { b = "?west_h", mat = "?main_wall" }
    }

    {
      { x =  32, y = 320, mat = "?low_ceil" }
      { x = 224, y = 320, mat = "?low_ceil" }
      { x = 256, y = 352, mat = "?low_ceil" }
      { x = 256, y = 544, mat = "?main_wall" }
      { x =  64, y = 544, mat = "?main_wall" }
      { x =  48, y = 528, mat = "?main_wall" }
      { x =  32, y = 512, mat = "?main_wall" }
      { b = 240, mat = "?low_ceil" }
    }

    {
      { x =   0, y = 256, mat = "?low_floor" }
      { x = 224, y = 256, mat = "?low_floor" }
      { x = 224, y = 320, mat = "?low_floor" }
      { x =   0, y = 320, mat = "?low_floor" }
      { t = 0, mat = "?low_floor" }
    }

    {
      { x = 192, y = 568, mat = "?main_wall" }
      { x = 384, y = 568, mat = "?main_wall" }
      { x = 384, y = 576, mat = "?outer" }
      { x = 192, y = 576, mat = "?main_wall" }
      { b = "?north_h", mat = "?main_wall" }
    }

    {
      { x = 224, y = 256, mat = "?low_floor" }
      { x = 256, y = 224, mat = "?low_floor" }
      { x = 320, y = 224, mat = "?low_floor" }
      { x = 352, y = 256, mat = "?low_floor" }
      { x = 352, y = 320, mat = "?low_floor" }
      { x = 320, y = 352, mat = "?low_floor" }
      { x = 256, y = 352, mat = "?low_floor" }
      { x = 224, y = 320, mat = "?low_floor" }
      { t = 0, mat = "?low_floor" }
    }

    {
      { x = 112, y = 432, mat = "?pipe" }
      { x = 120, y = 408, mat = "?pipe" }
      { x = 144, y = 400, mat = "?pipe" }
      { x = 168, y = 408, mat = "?pipe" }
      { x = 176, y = 432, mat = "?pipe" }
      { x = 168, y = 456, mat = "?pipe" }
      { x = 144, y = 464, mat = "?pipe" }
      { x = 120, y = 456, mat = "?pipe" }
      { b = 112, mat = "?pipe" }
    }

    {
      { x =  32, y = 512, mat = "?main_wall" }
      { x =  48, y = 528, mat = "?main_wall" }
      { x =  64, y = 544, mat = "?main_wall" }
      { x =  56, y = 544, mat = "?main_wall" }
      { x =  32, y = 520, mat = "?main_wall" }
      { t = 24, mat = "?main_wall" }
    }
    {
      { x =  32, y = 512, mat = "?main_wall" }
      { x =  48, y = 528, mat = "?main_wall" }
      { x =  64, y = 544, mat = "?main_wall" }
      { x =  56, y = 544, mat = "?main_wall" }
      { x =  32, y = 520, mat = "?main_wall" }
      { b = 152, mat = "?main_wall" }
    }

    {
      { x = 256, y = 352, mat = "?low_floor" }
      { x = 320, y = 352, mat = "?low_floor" }
      { x = 320, y = 576, mat = "?low_floor" }
      { x = 256, y = 576, mat = "?low_floor" }
      { t = 0, mat = "?low_floor" }
    }

    {
      { x =   0, y = 384, mat = "?main_wall" }
      { x =   8, y = 384, mat = "?main_wall" }
      { x =   8, y = 512, mat = "?main_wall" }
      { x =   0, y = 512, mat = "?outer" }
    }

    {
      { x = 520, y = 544, mat = "?lite", x_offset=0, y_offset=0, peg=1 }
      { x = 544, y = 520, mat = "?main_wall" }
      { x = 576, y = 520, mat = "?outer" }
      { x = 576, y = 576, mat = "?outer" }
      { x = 520, y = 576, mat = "?main_wall" }
    }

    {
      { x = 544, y = 512, mat = "?main_wall" }
      { x = 576, y = 512, mat = "?outer" }
      { x = 576, y = 520, mat = "?main_wall" }
      { x = 544, y = 520, mat = "?main_wall" }
    }

    {
      { x = 384, y = 568, mat = "?main_wall" }
      { x = 512, y = 568, mat = "?main_wall" }
      { x = 512, y = 576, mat = "?outer" }
      { x = 384, y = 576, mat = "?main_wall" }
    }

    {
      { x = 512, y = 544, mat = "?main_wall" }
      { x = 520, y = 544, mat = "?main_wall" }
      { x = 520, y = 576, mat = "?outer" }
      { x = 512, y = 576, mat = "?main_wall" }
    }

    {
      { x = 568, y = 192, mat = "?main_wall" }
      { x = 576, y = 192, mat = "?outer" }
      { x = 576, y = 384, mat = "?main_wall" }
      { x = 568, y = 384, mat = "?main_wall" }
      { b = "?east_h", mat = "?main_wall" }
    }

    {
      { x = 320, y = 352, mat = "?low_ceil" }
      { x = 352, y = 320, mat = "?low_ceil" }
      { x = 544, y = 320, mat = "?main_wall" }
      { x = 544, y = 512, mat = "?main_wall" }
      { x = 528, y = 528, mat = "?main_wall" }
      { x = 512, y = 544, mat = "?main_wall" }
      { x = 320, y = 544, mat = "?low_ceil" }
      { b = 240, mat = "?low_ceil" }
    }

    {
      { x = 352, y = 256, mat = "?low_floor" }
      { x = 576, y = 256, mat = "?low_floor" }
      { x = 576, y = 320, mat = "?low_floor" }
      { x = 352, y = 320, mat = "?low_floor" }
      { t = 0, mat = "?low_floor" }
    }

    {
      { x = 400, y = 432, mat = "?pipe" }
      { x = 408, y = 408, mat = "?pipe" }
      { x = 432, y = 400, mat = "?pipe" }
      { x = 456, y = 408, mat = "?pipe" }
      { x = 464, y = 432, mat = "?pipe" }
      { x = 456, y = 456, mat = "?pipe" }
      { x = 432, y = 464, mat = "?pipe" }
      { x = 408, y = 456, mat = "?pipe" }
      { b = 112, mat = "?pipe" }
    }

    {
      { x = 512, y = 544, mat = "?main_wall" }
      { x = 528, y = 528, mat = "?main_wall" }
      { x = 544, y = 512, mat = "?main_wall" }
      { x = 544, y = 520, mat = "?main_wall" }
      { x = 520, y = 544, mat = "?main_wall" }
      { t = 24, mat = "?main_wall" }
    }
    {
      { x = 512, y = 544, mat = "?main_wall" }
      { x = 528, y = 528, mat = "?main_wall" }
      { x = 544, y = 512, mat = "?main_wall" }
      { x = 544, y = 520, mat = "?main_wall" }
      { x = 520, y = 544, mat = "?main_wall" }
      { b = 152, mat = "?main_wall" }
    }

    {
      { x = 568, y = 384, mat = "?main_wall" }
      { x = 576, y = 384, mat = "?outer" }
      { x = 576, y = 512, mat = "?main_wall" }
      { x = 568, y = 512, mat = "?main_wall" }
    }

    {
      { x =   0, y =   0, mat = "?outer" }
      { x =  56, y =   0, mat = "?main_wall" }
      { x =  56, y =  32, mat = "?lite", x_offset=0, y_offset=0, peg=1 }
      { x =  32, y =  56, mat = "?main_wall" }
      { x =   0, y =  56, mat = "?outer" }
    }

    {
      { x =   0, y =  56, mat = "?main_wall" }
      { x =  32, y =  56, mat = "?main_wall" }
      { x =  32, y =  64, mat = "?main_wall" }
      { x =   0, y =  64, mat = "?outer" }
    }

    {
      { x =  64, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?main_wall" }
      { x = 192, y =   8, mat = "?main_wall" }
      { x =  64, y =   8, mat = "?main_wall" }
    }

    {
      { x =  56, y =   0, mat = "?outer" }
      { x =  64, y =   0, mat = "?main_wall" }
      { x =  64, y =  32, mat = "?main_wall" }
      { x =  56, y =  32, mat = "?main_wall" }
    }

    {
      { x =  32, y =  64, mat = "?main_wall" }
      { x =  48, y =  48, mat = "?main_wall" }
      { x =  64, y =  32, mat = "?main_wall" }
      { x = 256, y =  32, mat = "?low_ceil" }
      { x = 256, y = 224, mat = "?low_ceil" }
      { x = 224, y = 256, mat = "?low_ceil" }
      { x =  32, y = 256, mat = "?main_wall" }
      { b = 240, mat = "?low_ceil" }
    }

    {
      { x = 192, y =   0, mat = "?outer" }
      { x = 384, y =   0, mat = "?main_wall" }
      { x = 384, y =   8, mat = "?main_wall" }
      { x = 192, y =   8, mat = "?main_wall" }
      { b = "?south_h", mat = "?main_wall" }
    }

    {
      { x = 112, y = 144, mat = "?pipe" }
      { x = 120, y = 120, mat = "?pipe" }
      { x = 144, y = 112, mat = "?pipe" }
      { x = 168, y = 120, mat = "?pipe" }
      { x = 176, y = 144, mat = "?pipe" }
      { x = 168, y = 168, mat = "?pipe" }
      { x = 144, y = 176, mat = "?pipe" }
      { x = 120, y = 168, mat = "?pipe" }
      { b = 112, mat = "?pipe" }
    }

    {
      { x =  32, y =  56, mat = "?main_wall" }
      { x =  56, y =  32, mat = "?main_wall" }
      { x =  64, y =  32, mat = "?main_wall" }
      { x =  48, y =  48, mat = "?main_wall" }
      { x =  32, y =  64, mat = "?main_wall" }
      { t = 24, mat = "?main_wall" }
    }
    {
      { x =  32, y =  56, mat = "?main_wall" }
      { x =  56, y =  32, mat = "?main_wall" }
      { x =  64, y =  32, mat = "?main_wall" }
      { x =  48, y =  48, mat = "?main_wall" }
      { x =  32, y =  64, mat = "?main_wall" }
      { b = 152, mat = "?main_wall" }
    }

    {
      { x = 256, y =   0, mat = "?low_floor" }
      { x = 320, y =   0, mat = "?low_floor" }
      { x = 320, y = 224, mat = "?low_floor" }
      { x = 256, y = 224, mat = "?low_floor" }
      { t = 0, mat = "?low_floor" }
    }

    {
      { x =   0, y =  64, mat = "?main_wall" }
      { x =   8, y =  64, mat = "?main_wall" }
      { x =   8, y = 192, mat = "?main_wall" }
      { x =   0, y = 192, mat = "?outer" }
    }

    {
      { x = 520, y =   0, mat = "?outer" }
      { x = 576, y =   0, mat = "?outer" }
      { x = 576, y =  56, mat = "?main_wall" }
      { x = 544, y =  56, mat = "?lite", x_offset=0, y_offset=0, peg=1 }
      { x = 520, y =  32, mat = "?main_wall" }
    }

    {
      { x = 544, y =  56, mat = "?main_wall" }
      { x = 576, y =  56, mat = "?outer" }
      { x = 576, y =  64, mat = "?main_wall" }
      { x = 544, y =  64, mat = "?main_wall" }
    }

    {
      { x = 384, y =   0, mat = "?outer" }
      { x = 512, y =   0, mat = "?main_wall" }
      { x = 512, y =   8, mat = "?main_wall" }
      { x = 384, y =   8, mat = "?main_wall" }
    }

    {
      { x = 512, y =   0, mat = "?outer" }
      { x = 520, y =   0, mat = "?main_wall" }
      { x = 520, y =  32, mat = "?main_wall" }
      { x = 512, y =  32, mat = "?main_wall" }
    }

    {
      { x = 320, y =  32, mat = "?main_wall" }
      { x = 512, y =  32, mat = "?main_wall" }
      { x = 528, y =  48, mat = "?main_wall" }
      { x = 544, y =  64, mat = "?main_wall" }
      { x = 544, y = 256, mat = "?low_ceil" }
      { x = 352, y = 256, mat = "?low_ceil" }
      { x = 320, y = 224, mat = "?low_ceil" }
      { b = 240, mat = "?low_ceil" }
    }

    {
      { x = 400, y = 144, mat = "?pipe" }
      { x = 408, y = 120, mat = "?pipe" }
      { x = 432, y = 112, mat = "?pipe" }
      { x = 456, y = 120, mat = "?pipe" }
      { x = 464, y = 144, mat = "?pipe" }
      { x = 456, y = 168, mat = "?pipe" }
      { x = 432, y = 176, mat = "?pipe" }
      { x = 408, y = 168, mat = "?pipe" }
      { b = 112, mat = "?pipe" }
    }

    {
      { x = 512, y =  32, mat = "?main_wall" }
      { x = 520, y =  32, mat = "?main_wall" }
      { x = 544, y =  56, mat = "?main_wall" }
      { x = 544, y =  64, mat = "?main_wall" }
      { x = 528, y =  48, mat = "?main_wall" }
      { t = 24, mat = "?main_wall" }
    }
    {
      { x = 512, y =  32, mat = "?main_wall" }
      { x = 520, y =  32, mat = "?main_wall" }
      { x = 544, y =  56, mat = "?main_wall" }
      { x = 544, y =  64, mat = "?main_wall" }
      { x = 528, y =  48, mat = "?main_wall" }
      { b = 152, mat = "?main_wall" }
    }

    {
      { x = 568, y =  64, mat = "?main_wall" }
      { x = 576, y =  64, mat = "?outer" }
      { x = 576, y = 192, mat = "?main_wall" }
      { x = 568, y = 192, mat = "?main_wall" }
    }

    -- ceiling trim
    {
      { x =  64, y =   8, mat = "?trim" }
      { x = 512, y =   8, mat = "?trim" }
      { x = 512, y =  32, mat = "?trim" }
      { x =  64, y =  32, mat = "?trim" }
      { b = 176, mat = "?trim" }
    }

    {
      { x =   8, y =  64, mat = "?trim" }
      { x =  32, y =  64, mat = "?trim" }
      { x =  32, y = 512, mat = "?trim" }
      { x =   8, y = 512, mat = "?trim" }
      { b = 176, mat = "?trim" }
    }

    {
      { x = 544, y =  64, mat = "?trim" }
      { x = 568, y =  64, mat = "?trim" }
      { x = 568, y = 512, mat = "?trim" }
      { x = 544, y = 512, mat = "?trim" }
      { b = 176, mat = "?trim" }
    }

    {
      { x =  64, y = 544, mat = "?trim" }
      { x = 512, y = 544, mat = "?trim" }
      { x = 512, y = 568, mat = "?trim" }
      { x =  64, y = 568, mat = "?trim" }
      { b = 176, mat = "?trim" }
    }

    {
      { x =  32, y = 512, mat = "?trim" }
      { x =  32, y = 488, mat = "?trim" }
      { x =  88, y = 544, mat = "?trim" }
      { x =  64, y = 544, mat = "?trim" }
      { b = 176, mat = "?trim" }
    }

    {
      { x =  32, y =  88, mat = "?trim" }
      { x =  32, y =  64, mat = "?trim" }
      { x =  64, y =  32, mat = "?trim" }
      { x =  88, y =  32, mat = "?trim" }
      { b = 176, mat = "?trim" }
    }

    {
      { x = 488, y = 544, mat = "?trim" }
      { x = 544, y = 488, mat = "?trim" }
      { x = 544, y = 512, mat = "?trim" }
      { x = 512, y = 544, mat = "?trim" }
      { b = 176, mat = "?trim" }
    }

    {
      { x = 488, y =  32, mat = "?trim" }
      { x = 512, y =  32, mat = "?trim" }
      { x = 544, y =  64, mat = "?trim" }
      { x = 544, y =  88, mat = "?trim" }
      { b = 176, mat = "?trim" }
    }

    -- falling nukage
    {
      { m = "rail" }
      { x = 128, y = 144, mat = "_LIQUID" }
      { x = 132, y = 132, mat = "_LIQUID" }
      { x = 144, y = 128, mat = "_LIQUID" }
      { x = 156, y = 132, mat = "_LIQUID" }
      { x = 160, y = 144, mat = "_LIQUID" }
      { x = 156, y = 156, mat = "_LIQUID" }
      { x = 144, y = 160, mat = "_LIQUID" }
      { x = 132, y = 156, mat = "_LIQUID" }
      { t = 112 }
      { b = -16 }
    }

    {
      { m = "rail" }
      { x = 128, y = 432, mat = "_LIQUID" }
      { x = 132, y = 420, mat = "_LIQUID" }
      { x = 144, y = 416, mat = "_LIQUID" }
      { x = 156, y = 420, mat = "_LIQUID" }
      { x = 160, y = 432, mat = "_LIQUID" }
      { x = 156, y = 444, mat = "_LIQUID" }
      { x = 144, y = 448, mat = "_LIQUID" }
      { x = 132, y = 444, mat = "_LIQUID" }
      { t = 112 }
      { b = -16 }
    }

    {
      { m = "rail" }
      { x = 416, y = 144, mat = "_LIQUID" }
      { x = 420, y = 132, mat = "_LIQUID" }
      { x = 432, y = 128, mat = "_LIQUID" }
      { x = 444, y = 132, mat = "_LIQUID" }
      { x = 448, y = 144, mat = "_LIQUID" }
      { x = 444, y = 156, mat = "_LIQUID" }
      { x = 432, y = 160, mat = "_LIQUID" }
      { x = 420, y = 156, mat = "_LIQUID" }
      { t = 112 }
      { b = -16 }
    }

    {
      { m = "rail" }
      { x = 416, y = 432, mat = "_LIQUID" }
      { x = 420, y = 420, mat = "_LIQUID" }
      { x = 432, y = 416, mat = "_LIQUID" }
      { x = 444, y = 420, mat = "_LIQUID" }
      { x = 448, y = 432, mat = "_LIQUID" }
      { x = 444, y = 444, mat = "_LIQUID" }
      { x = 432, y = 448, mat = "_LIQUID" }
      { x = 420, y = 444, mat = "_LIQUID" }
      { t = 112 }
      { b = -16 }
    }


    -- lighting
    {
      { m = "light", add = 128 }
      { x =  32, y =  64 }
      { x =  32, y =  56 }
      { x =  56, y =  32 }
      { x =  64, y =  32 }
      { x = 224, y = 112 }
      { x = 224, y = 176 }
      { x = 176, y = 224 }
      { x = 112, y = 224 }
    }
    {
      { m = "light", add = 32 }
      { x =  32, y =  64 }
      { x =  64, y =  32 }
      { x = 256, y =  64 }
      { x = 256, y = 224 }
      { x = 224, y = 256 }
      { x =  64, y = 256 }
    }

    {
      { m = "light", add = 128 }
      { x =  32, y = 520 }
      { x =  32, y = 512 }
      { x = 112, y = 352 }
      { x = 176, y = 352 }
      { x = 224, y = 400 }
      { x = 224, y = 464 }
      { x =  64, y = 544 }
      { x =  56, y = 544 }
    }
    {
      { m = "light", add = 32 }
      { x =  32, y = 512 }
      { x =  64, y = 320 }
      { x = 224, y = 320 }
      { x = 256, y = 352 }
      { x = 256, y = 512 }
      { x =  64, y = 544 }
    }

    {
      { m = "light", add = 128 }
      { x = 352, y = 112 }
      { x = 512, y =  32 }
      { x = 520, y =  32 }
      { x = 544, y =  56 }
      { x = 544, y =  64 }
      { x = 464, y = 224 }
      { x = 400, y = 224 }
      { x = 352, y = 176 }
    }
    {
      { m = "light", add = 32 }
      { x = 512, y =  32 }
      { x = 544, y =  64 }
      { x = 512, y = 256 }
      { x = 352, y = 256 }
      { x = 320, y = 224 }
      { x = 320, y =  64 }
    }

    {
      { m = "light", add = 128 }
      { x = 352, y = 400 }
      { x = 400, y = 352 }
      { x = 464, y = 352 }
      { x = 544, y = 512 }
      { x = 544, y = 520 }
      { x = 520, y = 544 }
      { x = 512, y = 544 }
      { x = 352, y = 464 }
    }
    {
      { m = "light", add = 32 }
      { x = 544, y = 512 }
      { x = 512, y = 544 }
      { x = 320, y = 512 }
      { x = 320, y = 352 }
      { x = 352, y = 320 }
      { x = 512, y = 320 }
    }

    -- monster spots
    {
      { m = "spot" }
      { x =  64, y =  64 }
      { x = 224, y =  64 }
      { x = 224, y = 224 }
      { x =  64, y = 224 }
      { b = 0 }
      { t = 120 }
    }
    {
      { m = "spot" }
      { x = 352, y =  64 }
      { x = 512, y =  64 }
      { x = 512, y = 224 }
      { x = 352, y = 224 }
      { b = 0 }
      { t = 120 }
    }
    {
      { m = "spot" }
      { x =  64, y = 352 }
      { x = 224, y = 352 }
      { x = 224, y = 512 }
      { x =  64, y = 512 }
      { b = 0 }
      { t = 120 }
    }
    {
      { m = "spot" }
      { x = 352, y = 352 }
      { x = 512, y = 352 }
      { x = 512, y = 512 }
      { x = 352, y = 512 }
      { b = 0 }
      { t = 120 }
    }
  }
}


PREFAB.JUNCTION_LEDGE_1 =
{
  fitted = "xy"

  defaults =
  {
    wall2 = "?outer"
    ceil2 = "?outer"

    north_h  = 192

    lamp_ent = ""
  }

  brushes =
  {
    {
      { x =   0, y = 576, mat = "?wall2" }
      { x =  32, y = 544, mat = "?wall2" }
      { x = 192, y = 544, mat = "?wall2" }
      { x = 192, y = 576, mat = "?outer" }
    }

    {
      { x = 384, y =   0, mat = "?outer" }
      { x = 576, y =   0, mat = "?wall2" }
      { x = 544, y =  32, mat = "?wall2" }
      { x = 384, y =  32, mat = "?wall2" }
    }

    {
      { x =   0, y =   0, mat = "?wall2" }
      { x =  32, y =  32, mat = "?wall2" }
      { x =  32, y = 192, mat = "?wall2" }
      { x =   0, y = 192, mat = "?outer" }
    }

    {
      { x = 544, y = 384, mat = "?wall2" }
      { x = 576, y = 384, mat = "?outer" }
      { x = 576, y = 576, mat = "?wall2" }
      { x = 544, y = 544, mat = "?wall2" }
    }

    {
      { x =   0, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?wall2" }
      { x = 192, y =  32, mat = "?wall2" }
      { x =  32, y =  32, mat = "?wall2" }
    }

    {
      { x = 192, y =   0, mat = "?outer" }
      { x = 384, y =   0, mat = "?wall2" }
      { x = 384, y =  32, mat = "?wall2" }
      { x = 192, y =  32, mat = "?wall2" }
      { t = 0, mat = "?floor1" }
    }
    {
      { x = 192, y =   0, mat = "?outer" }
      { x = 384, y =   0, mat = "?wall2" }
      { x = 384, y =  32, mat = "?wall2" }
      { x = 192, y =  32, mat = "?wall2" }
      { b = 128, mat = "?wall2" }
    }

    {
      { x = 544, y =  32, mat = "?wall2" }
      { x = 576, y =   0, mat = "?outer" }
      { x = 576, y = 192, mat = "?wall2" }
      { x = 544, y = 192, mat = "?wall2" }
    }

    {
      { x = 544, y = 192, mat = "?wall2" }
      { x = 576, y = 192, mat = "?outer" }
      { x = 576, y = 384, mat = "?wall2" }
      { x = 544, y = 384, mat = "?wall2" }
      { t = 64, mat = "?floor2" }
    }
    {
      { x = 544, y = 192, mat = "?wall2" }
      { x = 576, y = 192, mat = "?outer" }
      { x = 576, y = 384, mat = "?wall2" }
      { x = 544, y = 384, mat = "?wall2" }
      { b = 192, mat = "?ceil2" }
    }

    {
      { x = 384, y = 544, mat = "?wall2" }
      { x = 544, y = 544, mat = "?wall2" }
      { x = 576, y = 576, mat = "?outer" }
      { x = 384, y = 576, mat = "?wall2" }
    }

    {
      { x = 192, y = 544, mat = "?wall2" }
      { x = 384, y = 544, mat = "?wall2" }
      { x = 384, y = 576, mat = "?outer" }
      { x = 192, y = 576, mat = "?wall2" }
      { t = "?north_h", mat = "?floor2" }
    }
    {
      { x = 192, y = 544, mat = "?wall2" }
      { x = 384, y = 544, mat = "?wall2" }
      { x = 384, y = 576, mat = "?outer" }
      { x = 192, y = 576, mat = "?wall2" }
      { b = 192, mat = "?ceil2" }
    }

    {
      { x =   0, y = 384, mat = "?wall2" }
      { x =  32, y = 384, mat = "?wall2" }
      { x =  32, y = 544, mat = "?wall2" }
      { x =   0, y = 576, mat = "?outer" }
    }

    {
      { x =   0, y = 192, mat = "?wall2" }
      { x =  32, y = 192, mat = "?wall2" }
      { x =  32, y = 384, mat = "?wall2" }
      { x =   0, y = 384, mat = "?outer" }
      { t = 64, mat = "?floor2" }
    }
    {
      { x =   0, y = 192, mat = "?wall2" }
      { x =  32, y = 192, mat = "?wall2" }
      { x =  32, y = 384, mat = "?wall2" }
      { x =   0, y = 384, mat = "?outer" }
      { b = 192, mat = "?ceil2" }
    }

    {
      { x =  32, y =  80, mat = "?wall2" }
      { x =  80, y =  80, mat = "?wall2" }
      { x = 176, y = 176, mat = "?wall2" }
      { x = 176, y = 272, mat = "?wall2" }
      { x =  32, y = 272, mat = "?wall2" }
      { t = 64, mat = "?floor2" }
    }
    {
      { x =  32, y =  80, mat = "?wall2" }
      { x =  80, y =  80, mat = "?wall2" }
      { x = 176, y = 176, mat = "?wall2" }
      { x = 176, y = 272, mat = "?wall2" }
      { x =  32, y = 272, mat = "?wall2" }
      { b = 192, mat = "?ceil2", light_add=32 }
    }

    {
      { x =  32, y =  32, mat = "?support" }
      { x =  64, y =  32, mat = "?support" }
      { x =  64, y =  64, mat = "?support" }
      { x =  32, y =  64, mat = "?support" }
    }

    {
      { x =  96, y =  32, mat = "?wall2" }
      { x = 480, y =  32, mat = "?wall2" }
      { x = 480, y =  64, mat = "?wall2" }
      { x = 384, y = 160, mat = "?wall2" }
      { x = 192, y = 160, mat = "?wall2" }
      { x =  96, y =  64, mat = "?wall2" }
      { t = 0, mat = "?floor1" }
    }
    {
      { x =  96, y =  32, mat = "?wall2" }
      { x = 480, y =  32, mat = "?wall2" }
      { x = 480, y =  64, mat = "?wall2" }
      { x = 384, y = 160, mat = "?wall2" }
      { x = 192, y = 160, mat = "?wall2" }
      { x =  96, y =  64, mat = "?wall2" }
      { b = 256, mat = "?ceil1" }
    }

    {
      { x = 512, y =  32, mat = "?support" }
      { x = 544, y =  32, mat = "?support" }
      { x = 544, y =  64, mat = "?support" }
      { x = 512, y =  64, mat = "?support" }
    }

    {
      { x = 512, y = 272, mat = "?wall2" }
      { x = 544, y = 272, mat = "?wall2" }
      { x = 544, y = 512, mat = "?wall2" }
      { x = 512, y = 512, mat = "?wall2" }
      { t = 64, mat = "?floor2" }
    }
    {
      { x = 512, y = 272, mat = "?wall2" }
      { x = 544, y = 272, mat = "?wall2" }
      { x = 544, y = 512, mat = "?wall2" }
      { x = 512, y = 512, mat = "?wall2" }
      { b = 192, mat = "?ceil2", light_add=32 }
    }

    {
      { x = 512, y = 512, mat = "?support" }
      { x = 544, y = 512, mat = "?support" }
      { x = 544, y = 544, mat = "?support" }
      { x = 512, y = 544, mat = "?support" }
    }

    {
      { x =  32, y = 512, mat = "?support" }
      { x =  64, y = 512, mat = "?support" }
      { x =  64, y = 544, mat = "?support" }
      { x =  32, y = 544, mat = "?support" }
    }

    {
      { x =  64, y = 272, mat = "?wall2" }
      { x = 176, y = 272, mat = "?wall2" }
      { x = 240, y = 400, mat = "?wall2" }
      { x = 192, y = 544, mat = "?wall2" }
      { x =  64, y = 544, mat = "?wall2" }
      { t = 64, mat = "?floor2" }
    }
    {
      { x =  64, y = 272, mat = "?wall2" }
      { x = 176, y = 272, mat = "?wall2" }
      { x = 240, y = 400, mat = "?wall2" }
      { x = 192, y = 544, mat = "?wall2" }
      { x =  64, y = 544, mat = "?wall2" }
      { b = 192, mat = "?ceil2", light_add=32 }
    }

    {
      { x = 192, y = 160, mat = "?wall2" }
      { x = 384, y = 160, mat = "?wall2" }
      { x = 384, y = 256, mat = "?wall2" }
      { x = 192, y = 256, mat = "?wall2" }
      { t = 0, mat = "?floor1" }
    }
    {
      { x = 192, y = 160, mat = "?wall2" }
      { x = 384, y = 160, mat = "?wall2" }
      { x = 384, y = 256, mat = "?wall2" }
      { x = 192, y = 256, mat = "?wall2" }
      { b = 256, mat = "?ceil1" }
    }

    {
      { x = 176, y = 176, mat = "?wall2" }
      { x = 192, y = 160, mat = "?wall2" }
      { x = 192, y = 256, mat = "?wall2" }
      { x = 176, y = 272, mat = "?low_trim" }
      { t = 72, mat = "?low_trim" }
    }
    {
      { x = 176, y = 176, mat = "?wall2" }
      { x = 192, y = 160, mat = "?wall2" }
      { x = 192, y = 256, mat = "?wall2" }
      { x = 176, y = 272, mat = "?high_trim" }
      { b = 184, mat = "?high_trim" }
    }

    {
      { x = 248, y = 368, mat = "?step", peg=1, y_offset=0 }
      { x = 328, y = 368, mat = "?wall2" }
      { x = 320, y = 384, mat = "?wall2" }
      { x = 256, y = 384, mat = "?wall2" }
      { t = 64, mat = "?top" }
    }
    {
      { x = 248, y = 368, mat = "?wall2" }
      { x = 328, y = 368, mat = "?wall2" }
      { x = 320, y = 384, mat = "?wall2" }
      { x = 256, y = 384, mat = "?wall2" }
      { b = 256, mat = "?ceil1" }
    }

    {
      { x = 240, y = 400, mat = "?wall2" }
      { x = 256, y = 384, mat = "?wall2" }
      { x = 320, y = 384, mat = "?wall2" }
      { x = 336, y = 400, mat = "?low_trim" }
      { t = 72, mat = "?low_trim" }
    }
    {
      { x = 240, y = 400, mat = "?wall2" }
      { x = 256, y = 384, mat = "?wall2" }
      { x = 320, y = 384, mat = "?wall2" }
      { x = 336, y = 400, mat = "?high_trim" }
      { b = 184, mat = "?high_trim" }
    }

    {
      { x = 320, y = 384, mat = "?wall2" }
      { x = 328, y = 368, mat = "?wall2" }
      { x = 336, y = 352, mat = "?wall2" }
      { x = 344, y = 336, mat = "?wall2" }
      { x = 352, y = 320, mat = "?wall2" }
      { x = 360, y = 304, mat = "?wall2" }
      { x = 368, y = 288, mat = "?wall2" }
      { x = 376, y = 272, mat = "?wall2" }
      { x = 384, y = 256, mat = "?wall2" }
      { x = 400, y = 272, mat = "?low_trim" }
      { x = 336, y = 400, mat = "?wall2" }
      { t = 72, mat = "?low_trim" }
    }
    {
      { x = 320, y = 384, mat = "?wall2" }
      { x = 328, y = 368, mat = "?wall2" }
      { x = 336, y = 352, mat = "?wall2" }
      { x = 344, y = 336, mat = "?wall2" }
      { x = 352, y = 320, mat = "?wall2" }
      { x = 360, y = 304, mat = "?wall2" }
      { x = 368, y = 288, mat = "?wall2" }
      { x = 376, y = 272, mat = "?wall2" }
      { x = 384, y = 256, mat = "?wall2" }
      { x = 400, y = 272, mat = "?high_trim" }
      { x = 336, y = 400, mat = "?wall2" }
      { b = 184, mat = "?high_trim" }
    }

    {
      { x = 384, y = 160, mat = "?wall2" }
      { x = 480, y =  64, mat = "?wall2" }
      { x = 496, y =  80, mat = "?low_trim" }
      { x = 400, y = 176, mat = "?wall2" }
      { t = 72, mat = "?low_trim" }
    }
    {
      { x = 384, y = 160, mat = "?wall2" }
      { x = 480, y =  64, mat = "?wall2" }
      { x = 496, y =  80, mat = "?high_trim" }
      { x = 400, y = 176, mat = "?wall2" }
      { b = 184, mat = "?high_trim" }
    }

    {
      { x = 176, y = 272, mat = "?wall2" }
      { x = 192, y = 256, mat = "?wall2" }
      { x = 200, y = 272, mat = "?wall2" }
      { x = 208, y = 288, mat = "?wall2" }
      { x = 216, y = 304, mat = "?wall2" }
      { x = 224, y = 320, mat = "?wall2" }
      { x = 232, y = 336, mat = "?wall2" }
      { x = 240, y = 352, mat = "?wall2" }
      { x = 248, y = 368, mat = "?wall2" }
      { x = 256, y = 384, mat = "?wall2" }
      { x = 240, y = 400, mat = "?low_trim" }
      { t = 72, mat = "?low_trim" }
    }
    {
      { x = 176, y = 272, mat = "?wall2" }
      { x = 192, y = 256, mat = "?wall2" }
      { x = 200, y = 272, mat = "?wall2" }
      { x = 208, y = 288, mat = "?wall2" }
      { x = 216, y = 304, mat = "?wall2" }
      { x = 224, y = 320, mat = "?wall2" }
      { x = 232, y = 336, mat = "?wall2" }
      { x = 240, y = 352, mat = "?wall2" }
      { x = 248, y = 368, mat = "?wall2" }
      { x = 256, y = 384, mat = "?wall2" }
      { x = 240, y = 400, mat = "?high_trim" }
      { b = 184, mat = "?high_trim" }
    }

    {
      { x = 240, y = 352, mat = "?step", peg=1, y_offset=0 }
      { x = 336, y = 352, mat = "?wall2" }
      { x = 328, y = 368, mat = "?wall2" }
      { x = 248, y = 368, mat = "?wall2" }
      { t = 56, mat = "?top" }
    }
    {
      { x = 240, y = 352, mat = "?wall2" }
      { x = 336, y = 352, mat = "?wall2" }
      { x = 328, y = 368, mat = "?wall2" }
      { x = 248, y = 368, mat = "?wall2" }
      { b = 256, mat = "?ceil1" }
    }

    {
      { x = 232, y = 336, mat = "?step", peg=1, y_offset=0 }
      { x = 344, y = 336, mat = "?wall2" }
      { x = 336, y = 352, mat = "?wall2" }
      { x = 240, y = 352, mat = "?wall2" }
      { t = 48, mat = "?top" }
    }
    {
      { x = 232, y = 336, mat = "?wall2" }
      { x = 344, y = 336, mat = "?wall2" }
      { x = 336, y = 352, mat = "?wall2" }
      { x = 240, y = 352, mat = "?wall2" }
      { b = 256, mat = "?ceil1" }
    }

    {
      { x = 224, y = 320, mat = "?step", peg=1, y_offset=0 }
      { x = 352, y = 320, mat = "?wall2" }
      { x = 344, y = 336, mat = "?wall2" }
      { x = 232, y = 336, mat = "?wall2" }
      { t = 40, mat = "?top" }
    }
    {
      { x = 224, y = 320, mat = "?wall2" }
      { x = 352, y = 320, mat = "?wall2" }
      { x = 344, y = 336, mat = "?wall2" }
      { x = 232, y = 336, mat = "?wall2" }
      { b = 256, mat = "?ceil1" }
    }

    {
      { x = 216, y = 304, mat = "?step", peg=1, y_offset=0 }
      { x = 360, y = 304, mat = "?wall2" }
      { x = 352, y = 320, mat = "?wall2" }
      { x = 224, y = 320, mat = "?wall2" }
      { t = 32, mat = "?top" }
    }
    {
      { x = 216, y = 304, mat = "?wall2" }
      { x = 360, y = 304, mat = "?wall2" }
      { x = 352, y = 320, mat = "?wall2" }
      { x = 224, y = 320, mat = "?wall2" }
      { b = 256, mat = "?ceil1" }
    }

    {
      { x = 208, y = 288, mat = "?step", peg=1, y_offset=0 }
      { x = 368, y = 288, mat = "?wall2" }
      { x = 360, y = 304, mat = "?wall2" }
      { x = 216, y = 304, mat = "?wall2" }
      { t = 24, mat = "?top" }
    }
    {
      { x = 208, y = 288, mat = "?wall2" }
      { x = 368, y = 288, mat = "?wall2" }
      { x = 360, y = 304, mat = "?wall2" }
      { x = 216, y = 304, mat = "?wall2" }
      { b = 256, mat = "?ceil1" }
    }

    {
      { x = 200, y = 272, mat = "?step", peg=1, y_offset=0 }
      { x = 376, y = 272, mat = "?wall2" }
      { x = 368, y = 288, mat = "?wall2" }
      { x = 208, y = 288, mat = "?wall2" }
      { t = 16, mat = "?top" }
    }
    {
      { x = 200, y = 272, mat = "?wall2" }
      { x = 376, y = 272, mat = "?wall2" }
      { x = 368, y = 288, mat = "?wall2" }
      { x = 208, y = 288, mat = "?wall2" }
      { b = 256, mat = "?ceil1" }
    }

    {
      { x = 192, y = 256, mat = "?step", peg=1, y_offset=0 }
      { x = 384, y = 256, mat = "?wall2" }
      { x = 376, y = 272, mat = "?wall2" }
      { x = 200, y = 272, mat = "?wall2" }
      { t = 8, mat = "?top" }
    }
    {
      { x = 192, y = 256, mat = "?wall2" }
      { x = 384, y = 256, mat = "?wall2" }
      { x = 376, y = 272, mat = "?wall2" }
      { x = 200, y = 272, mat = "?wall2" }
      { b = 256, mat = "?ceil1" }
    }

    {
      { x = 384, y = 160, mat = "?wall2" }
      { x = 400, y = 176, mat = "?low_trim" }
      { x = 400, y = 272, mat = "?wall2" }
      { x = 384, y = 256, mat = "?wall2" }
      { t = 72, mat = "?low_trim" }
    }
    {
      { x = 384, y = 160, mat = "?wall2" }
      { x = 400, y = 176, mat = "?high_trim" }
      { x = 400, y = 272, mat = "?wall2" }
      { x = 384, y = 256, mat = "?wall2" }
      { b = 184, mat = "?high_trim" }
    }

    {
      { x = 192, y = 544, mat = "?wall2" }
      { x = 240, y = 400, mat = "?wall2" }
      { x = 336, y = 400, mat = "?wall2" }
      { x = 384, y = 544, mat = "?wall2" }
      { t = 64, mat = "?floor2" }
    }
    {
      { x = 192, y = 544, mat = "?wall2" }
      { x = 240, y = 400, mat = "?wall2" }
      { x = 336, y = 400, mat = "?wall2" }
      { x = 384, y = 544, mat = "?wall2" }
      { b = 192, mat = "?ceil2", light_add=32 }
    }

    {
      { x = 400, y = 176, mat = "?wall2" }
      { x = 496, y =  80, mat = "?wall2" }
      { x = 544, y =  80, mat = "?wall2" }
      { x = 544, y = 272, mat = "?wall2" }
      { x = 400, y = 272, mat = "?wall2" }
      { t = 64, mat = "?floor2" }
    }
    {
      { x = 400, y = 176, mat = "?wall2" }
      { x = 496, y =  80, mat = "?wall2" }
      { x = 544, y =  80, mat = "?wall2" }
      { x = 544, y = 272, mat = "?wall2" }
      { x = 400, y = 272, mat = "?wall2" }
      { b = 192, mat = "?ceil2", light_add=32 }
    }

    {
      { x =  32, y = 272, mat = "?wall2" }
      { x =  64, y = 272, mat = "?wall2" }
      { x =  64, y = 512, mat = "?wall2" }
      { x =  32, y = 512, mat = "?wall2" }
      { t = 64, mat = "?floor2" }
    }
    {
      { x =  32, y = 272, mat = "?wall2" }
      { x =  64, y = 272, mat = "?wall2" }
      { x =  64, y = 512, mat = "?wall2" }
      { x =  32, y = 512, mat = "?wall2" }
      { b = 192, mat = "?ceil2", light_add=32 }
    }

    {
      { x =  80, y =  80, mat = "?wall2" }
      { x =  96, y =  64, mat = "?wall2" }
      { x = 192, y = 160, mat = "?wall2" }
      { x = 176, y = 176, mat = "?low_trim" }
      { t = 72, mat = "?low_trim" }
    }
    {
      { x =  80, y =  80, mat = "?wall2" }
      { x =  96, y =  64, mat = "?wall2" }
      { x = 192, y = 160, mat = "?wall2" }
      { x = 176, y = 176, mat = "?high_trim" }
      { b = 184, mat = "?high_trim" }
    }

    {
      { x = 336, y = 400, mat = "?wall2" }
      { x = 400, y = 272, mat = "?wall2" }
      { x = 512, y = 272, mat = "?wall2" }
      { x = 512, y = 544, mat = "?wall2" }
      { x = 384, y = 544, mat = "?wall2" }
      { t = 64, mat = "?floor2" }
    }
    {
      { x = 336, y = 400, mat = "?wall2" }
      { x = 400, y = 272, mat = "?wall2" }
      { x = 512, y = 272, mat = "?wall2" }
      { x = 512, y = 544, mat = "?wall2" }
      { x = 384, y = 544, mat = "?wall2" }
      { b = 192, mat = "?ceil2", light_add=32 }
    }

    {
      { x = 480, y =  64, mat = "?wall2" }
      { x = 544, y =  64, mat = "?wall2" }
      { x = 544, y =  80, mat = "?low_trim" }
      { x = 496, y =  80, mat = "?wall2" }
      { t = 72, mat = "?low_trim" }
    }
    {
      { x = 480, y =  64, mat = "?wall2" }
      { x = 544, y =  64, mat = "?wall2" }
      { x = 544, y =  80, mat = "?high_trim" }
      { x = 496, y =  80, mat = "?wall2" }
      { b = 184, mat = "?high_trim" }
    }

    {
      { x =  32, y =  64, mat = "?wall2" }
      { x =  96, y =  64, mat = "?wall2" }
      { x =  80, y =  80, mat = "?low_trim" }
      { x =  32, y =  80, mat = "?wall2" }
      { t = 72, mat = "?low_trim" }
    }
    {
      { x =  32, y =  64, mat = "?wall2" }
      { x =  96, y =  64, mat = "?wall2" }
      { x =  80, y =  80, mat = "?high_trim" }
      { x =  32, y =  80, mat = "?wall2" }
      { b = 184, mat = "?high_trim" }
    }

    {
      { x =  64, y =  32, mat = "?wall2" }
      { x =  96, y =  32, mat = "?wall2" }
      { x =  96, y =  64, mat = "?wall2" }
      { x =  64, y =  64, mat = "?wall2" }
      { t = 0, mat = "?floor1" }
    }
    {
      { x =  64, y =  32, mat = "?wall2" }
      { x =  96, y =  32, mat = "?wall2" }
      { x =  96, y =  64, mat = "?wall2" }
      { x =  64, y =  64, mat = "?wall2" }
      { b = 256, mat = "?ceil1" }
    }

    {
      { x = 480, y =  32, mat = "?wall2" }
      { x = 512, y =  32, mat = "?wall2" }
      { x = 512, y =  64, mat = "?wall2" }
      { x = 480, y =  64, mat = "?wall2" }
      { t = 0, mat = "?floor1" }
    }
    {
      { x = 480, y =  32, mat = "?wall2" }
      { x = 512, y =  32, mat = "?wall2" }
      { x = 512, y =  64, mat = "?wall2" }
      { x = 480, y =  64, mat = "?wall2" }
      { b = 256, mat = "?ceil1" }
    }

    -- monster spots
    {
      { m = "spot" }
      { x = 208, y =  48 }
      { x = 368, y =  48 }
      { x = 368, y = 240 }
      { x = 208, y = 240 }
      { b = 0 }
      { t = 200 }
    }
    {
      { m = "spot" }
      { x =  80, y = 352 }
      { x = 208, y = 352 }
      { x = 208, y = 496 }
      { x =  80, y = 496 }
      { b = 64 }
      { t = 192 }
    }
    {
      { m = "spot" }
      { x = 368, y = 352 }
      { x = 496, y = 352 }
      { x = 496, y = 496 }
      { x = 368, y = 496 }
      { b = 64 }
      { t = 192 }
    }
  }

  entities =
  {
    { ent = "?lamp_ent", x =  48, y = 400, z = 64, angle = 0 }
    { ent = "?lamp_ent", x =  48, y = 176, z = 64, angle = 0 }
    { ent = "?lamp_ent", x = 528, y = 176, z = 64, angle = 180 }
    { ent = "?lamp_ent", x = 528, y = 400, z = 64, angle = 180 }
    { ent = "?lamp_ent", x = 400, y = 528, z = 64, angle = 270 }
    { ent = "?lamp_ent", x = 176, y = 528, z = 64, angle = 270 }
  }
}


PREFAB.JUNCTION_WELL_1 =
{
  fitted = "xy"

  defaults =
  {
    gore_ent  = ""
    torch_ent = ""

    north_h = 168  -- vs 296
     east_h =  84  -- vs 212
     west_h = -84  -- vs  44
  }

  brushes =
  {
    {
      { x =   0, y = 552, mat = "?brick" }
      { x =   8, y = 552, mat = "_LIQUID" }
      { x =  24, y = 568, mat = "?brick" }
      { x =  24, y = 576, mat = "?outer" }
      { x =   0, y = 576, mat = "?outer" }
    }

    {
      { x = 472, y =   0, mat = "?outer" }
      { x = 576, y =   0, mat = "?outer" }
      { x = 576, y = 104, mat = "?brick" }
      { x = 520, y = 104, mat = "?brick" }
      { x = 496, y =  80, mat = "?brick" }
      { x = 472, y =  56, mat = "?brick" }
    }

    {
      { x =   0, y =   0, mat = "?outer" }
      { x = 104, y =   0, mat = "?brick" }
      { x = 104, y =  56, mat = "?brick" }
      { x =  80, y =  80, mat = "?brick" }
      { x =  56, y = 104, mat = "?brick" }
      { x =   0, y = 104, mat = "?outer" }
    }

    {
      { x = 472, y = 520, mat = "?brick" }
      { x = 496, y = 496, mat = "?brick" }
      { x = 520, y = 472, mat = "?brick" }
      { x = 576, y = 472, mat = "?outer" }
      { x = 576, y = 576, mat = "?outer" }
      { x = 472, y = 576, mat = "?brick" }
    }

    {
      { x =  16, y = 384, mat = "?step" }
      { x = 157, y = 320, mat = "?floor1" }
      { x = 171, y = 351, mat = "?floor1" }
      { x =  45, y = 455, mat = "?brick" }
      { t = -96, mat = "?floor1" }
    }
    {
      { x =  16, y = 384, mat = "?step" }
      { x = 157, y = 320, mat = "?top" }
      { x = 171, y = 351, mat = "?step" }
      { x =  45, y = 455, mat = "?brick" }
      { b = 384, mat = "?brick" }
    }

    {
      { x =   0, y = 384, mat = "?brick" }
      { x =  16, y = 384, mat = "?brick" }
      { x =  45, y = 455, mat = "?brick" }
      { x =  32, y = 480, mat = "?brick" }
      { x =  16, y = 496, mat = "?brick" }
      { x =   0, y = 496, mat = "?outer" }
    }

    {
      { x = 329, y = 418, mat = "?floor1" }
      { x = 354, y = 407, mat = "?step" }
      { x = 432, y = 544, mat = "?brick" }
      { x = 384, y = 560, mat = "?brick" }
      { t = 156, mat = "?floor1" }
    }
    {
      { x = 329, y = 418, mat = "?top" }
      { x = 354, y = 407, mat = "?step" }
      { x = 432, y = 544, mat = "?brick" }
      { x = 384, y = 560, mat = "?brick" }
      { b = 384, mat = "?brick", light_add=16 }
    }

    {
      { x = 384, y = 560, mat = "?brick" }
      { x = 432, y = 544, mat = "?brick" }
      { x = 432, y = 576, mat = "?outer" }
      { x = 384, y = 576, mat = "?brick" }
    }

    {
      { x = 418, y = 224, mat = "?step" }
      { x = 544, y = 144, mat = "?brick" }
      { x = 560, y = 192, mat = "?brick" }
      { x = 427, y = 246, mat = "?floor1" }
      { t = 72, mat = "?floor1" }
    }
    {
      { x = 418, y = 224, mat = "?step" }
      { x = 544, y = 144, mat = "?brick" }
      { x = 560, y = 192, mat = "?brick" }
      { x = 427, y = 246, mat = "?top" }
      { b = 384, mat = "?brick" }
    }

    {
      { x = 544, y = 144, mat = "?brick" }
      { x = 576, y = 144, mat = "?outer" }
      { x = 576, y = 192, mat = "?brick" }
      { x = 560, y = 192, mat = "?brick" }
    }

    {
      { x = 144, y =  32, mat = "?brick" }
      { x = 192, y =  16, mat = "?brick" }
      { x = 255, y = 148, mat = "?floor1" }
      { x = 233, y = 157, mat = "?step" }
      { t = -12, mat = "?floor1" }
    }
    {
      { x = 144, y =  32, mat = "?brick" }
      { x = 192, y =  16, mat = "?brick" }
      { x = 255, y = 148, mat = "?top" }
      { x = 233, y = 157, mat = "?step" }
      { b = 384, mat = "?brick" }
    }

    {
      { x = 144, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?brick" }
      { x = 192, y =  16, mat = "?brick" }
      { x = 144, y =  32, mat = "?brick" }
    }

    {
      { x =   0, y = 192, mat = "?brick" }
      { x =  16, y = 192, mat = "?brick" }
      { x =   8, y = 288, mat = "?brick" }
      { x =   0, y = 288, mat = "?outer" }
      { t = "?west_h", mat = "?floor1" }
    }
    {
      { x =   0, y = 192, mat = "?brick" }
      { x =  16, y = 192, mat = "?brick" }
      { x =   8, y = 288, mat = "?brick" }
      { x =   0, y = 288, mat = "?outer" }
      { b = 44, mat = "?brick" }
    }

    {
      { x = 560, y = 384, mat = "?brick" }
      { x = 568, y = 288, mat = "?brick" }
      { x = 576, y = 288, mat = "?outer" }
      { x = 576, y = 384, mat = "?brick" }
      { t = "?east_h", mat = "?floor1" }
    }
    {
      { x = 560, y = 384, mat = "?brick" }
      { x = 568, y = 288, mat = "?brick" }
      { x = 576, y = 288, mat = "?outer" }
      { x = 576, y = 384, mat = "?brick" }
      { b = 212, mat = "?brick" }
    }

    {
      { x = 427, y = 320, mat = "?floor1" }
      { x = 433, y = 288, mat = "?step" }
      { x = 568, y = 288, mat = "?brick" }
      { x = 560, y = 384, mat = "?step" }
      { t = 84, mat = "?floor1" }
    }
    {
      { x = 427, y = 320, mat = "?top" }
      { x = 433, y = 288, mat = "?brick" }
      { x = 568, y = 288, mat = "?brick" }
      { x = 560, y = 384, mat = "?step" }
      { b = 384, mat = "?brick" }
    }

    {
      { x = 560, y = 192, mat = "?brick" }
      { x = 576, y = 192, mat = "?outer" }
      { x = 576, y = 288, mat = "?brick" }
      { x = 568, y = 288, mat = "?brick" }
      { t = "?east_h", mat = "?floor1" }
    }
    {
      { x = 560, y = 192, mat = "?brick" }
      { x = 576, y = 192, mat = "?outer" }
      { x = 576, y = 288, mat = "?brick" }
      { x = 568, y = 288, mat = "?brick" }
      { b = 212, mat = "?brick" }
    }

    {
      { x = 391, y = 376, mat = "?floor1" }
      { x = 405, y = 361, mat = "?step" }
      { x = 520, y = 472, mat = "?brick" }
      { x = 496, y = 496, mat = "?brick" }
      { x = 443, y = 437, mat = "?brick" }
      { t = 120, mat = "?floor1", light_add=32 }
    }
    {
      { x = 391, y = 376, mat = "?top" }
      { x = 405, y = 361, mat = "?step" }
      { x = 520, y = 472, mat = "?brick" }
      { x = 496, y = 496, mat = "?brick" }
      { x = 443, y = 437, mat = "?brick" }
      { b = 384, mat = "?brick" }
    }

    {
      { x = 544, y = 432, mat = "?brick" }
      { x = 560, y = 384, mat = "?brick" }
      { x = 576, y = 384, mat = "?outer" }
      { x = 576, y = 432, mat = "?brick" }
    }

    {
      { x =   8, y = 288, mat = "?brick" }
      { x =  16, y = 192, mat = "?brick" }
      { x = 157, y = 246, mat = "?floor1" }
      { x = 151, y = 288, mat = "?step" }
      { t = -84, mat = "?floor1" }
    }
    {
      { x =   8, y = 288, mat = "?brick" }
      { x =  16, y = 192, mat = "?brick" }
      { x = 157, y = 246, mat = "?top" }
      { x = 151, y = 288, mat = "?brick" }
      { b = 384, mat = "?brick" }
    }

    {
      { x =   0, y = 288, mat = "?brick" }
      { x =   8, y = 288, mat = "?brick" }
      { x =  16, y = 384, mat = "?brick" }
      { x =   0, y = 384, mat = "?outer" }
      { t = "?west_h", mat = "?floor1" }
    }
    {
      { x =   0, y = 288, mat = "?brick" }
      { x =   8, y = 288, mat = "?brick" }
      { x =  16, y = 384, mat = "?brick" }
      { x =   0, y = 384, mat = "?outer" }
      { b = 44, mat = "?brick" }
    }

    {
      { x =  56, y = 104, mat = "?brick" }
      { x =  80, y =  80, mat = "?brick" }
      { x = 137, y = 133, mat = "?brick" }
      { x = 118, y = 155, mat = "?step" }
      { t = -48, mat = "?floor1" }
    }
    {
      { x =  56, y = 104, mat = "?brick" }
      { x =  80, y =  80, mat = "?brick" }
      { x = 137, y = 133, mat = "?brick" }
      { x = 118, y = 155, mat = "?step" }
      { b = 384, mat = "?brick", light_add=48 }
    }

    {
      { x =   0, y = 144, mat = "?brick" }
      { x =  32, y = 144, mat = "?brick" }
      { x =  16, y = 192, mat = "?brick" }
      { x =   0, y = 192, mat = "?outer" }
    }

    {
      { x = 288, y =   0, mat = "?outer" }
      { x = 384, y =   0, mat = "?brick" }
      { x = 384, y =  16, mat = "?brick" }
      { x = 288, y =   8, mat = "?brick" }
      { t = 0, mat = "?floor1" }
    }
    {
      { x = 288, y =   0, mat = "?outer" }
      { x = 384, y =   0, mat = "?brick" }
      { x = 384, y =  16, mat = "?brick" }
      { x = 288, y =   8, mat = "?brick" }
      { b = 128, mat = "?brick" }
    }

    {
      { x = 192, y = 560, mat = "?brick" }
      { x = 288, y = 568, mat = "?brick" }
      { x = 288, y = 576, mat = "?outer" }
      { x = 192, y = 576, mat = "?brick" }
      { t = "?north_h", mat = "?floor1" }
    }
    {
      { x = 192, y = 560, mat = "?brick" }
      { x = 288, y = 568, mat = "?brick" }
      { x = 288, y = 576, mat = "?outer" }
      { x = 192, y = 576, mat = "?brick" }
      { b = 296, mat = "?brick" }
    }

    {
      { x =  72, y = 560, mat = "?brick" }
      { x =  88, y = 545, mat = "?brick" }
      { x = 121, y = 527, mat = "?brick" }
      { x = 192, y = 560, mat = "?brick" }
      { x = 192, y = 576, mat = "?outer" }
      { x =  72, y = 576, mat = "?brick" }
    }

    {
      { x = 192, y = 560, mat = "?floor1" }
      { x = 255, y = 418, mat = "?floor1" }
      { x = 288, y = 425, mat = "?brick" }
      { x = 288, y = 568, mat = "?brick" }
      { t = 168, mat = "?floor1" }
    }
    {
      { x = 192, y = 560, mat = "?step" }
      { x = 255, y = 418, mat = "?top" }
      { x = 288, y = 425, mat = "?brick" }
      { x = 288, y = 568, mat = "?brick" }
      { b = 384, mat = "?brick" }
    }

    {
      { x = 288, y = 568, mat = "?brick" }
      { x = 384, y = 560, mat = "?brick" }
      { x = 384, y = 576, mat = "?outer" }
      { x = 288, y = 576, mat = "?brick" }
      { t = "?north_h", mat = "?floor1" }
    }
    {
      { x = 288, y = 568, mat = "?brick" }
      { x = 384, y = 560, mat = "?brick" }
      { x = 384, y = 576, mat = "?outer" }
      { x = 288, y = 576, mat = "?brick" }
      { b = 296, mat = "?brick" }
    }

    {
      { x = 288, y =   8, mat = "?brick" }
      { x = 384, y =  16, mat = "?brick" }
      { x = 329, y = 148, mat = "?floor1" }
      { x = 288, y = 142, mat = "?brick" }
      { t = 0, mat = "?floor1" }
    }
    {
      { x = 288, y =   8, mat = "?brick" }
      { x = 384, y =  16, mat = "?brick" }
      { x = 329, y = 148, mat = "?top" }
      { x = 288, y = 142, mat = "?brick" }
      { b = 384, mat = "?brick" }
    }

    {
      { x = 192, y =   0, mat = "?outer" }
      { x = 288, y =   0, mat = "?brick" }
      { x = 288, y =   8, mat = "?brick" }
      { x = 192, y =  16, mat = "?brick" }
      { t = 0, mat = "?floor1" }
    }
    {
      { x = 192, y =   0, mat = "?outer" }
      { x = 288, y =   0, mat = "?brick" }
      { x = 288, y =   8, mat = "?brick" }
      { x = 192, y =  16, mat = "?brick" }
      { b = 128, mat = "?brick" }
    }

    {
      { x = 372, y = 170, mat = "?step" }
      { x = 472, y =  56, mat = "?brick" }
      { x = 496, y =  80, mat = "?brick" }
      { x = 390, y = 185, mat = "?floor1" }
      { t = 36, mat = "?floor1" }
    }
    {
      { x = 372, y = 170, mat = "?step" }
      { x = 472, y =  56, mat = "?brick" }
      { x = 496, y =  80, mat = "?brick" }
      { x = 390, y = 185, mat = "?top" }
      { b = 384, mat = "?brick" }
    }

    {
      { x = 384, y =   0, mat = "?outer" }
      { x = 432, y =   0, mat = "?brick" }
      { x = 432, y =  32, mat = "?brick" }
      { x = 384, y =  16, mat = "?brick" }
    }

    {
      { x = 151, y = 288, mat = "?brick" }
      { x = 157, y = 246, mat = "?brick" }
      { x = 167, y = 224, mat = "?brick" }
      { x = 177, y = 205, mat = "?brick" }
      { x = 194, y = 185, mat = "?brick" }
      { x = 214, y = 169, mat = "?brick" }
      { x = 233, y = 157, mat = "?brick" }
      { x = 255, y = 148, mat = "?brick" }
      { x = 288, y = 142, mat = "?brick" }
      { x = 329, y = 148, mat = "?brick" }
      { x = 352, y = 158, mat = "?brick" }
      { x = 372, y = 170, mat = "?brick" }
      { x = 390, y = 185, mat = "?brick" }
      { x = 406, y = 204, mat = "?brick" }
      { x = 418, y = 224, mat = "?brick" }
      { x = 427, y = 246, mat = "?brick" }
      { x = 433, y = 288, mat = "?brick" }
      { x = 427, y = 320, mat = "?brick" }
      { x = 416, y = 343, mat = "?brick" }
      { x = 405, y = 361, mat = "?brick" }
      { x = 391, y = 376, mat = "?brick" }
      { x = 374, y = 393, mat = "?brick" }
      { x = 354, y = 407, mat = "?brick" }
      { x = 329, y = 418, mat = "?brick" }
      { x = 288, y = 425, mat = "?brick" }
      { x = 255, y = 418, mat = "?brick" }
      { x = 222, y = 402, mat = "?brick" }
      { x = 171, y = 351, mat = "?brick" }
      { x = 157, y = 320, mat = "?brick" }
      { t = -108, mat = "_LIQUID" }
    }
    {
      { x = 151, y = 288, mat = "?brick" }
      { x = 157, y = 246, mat = "?brick" }
      { x = 167, y = 224, mat = "?brick" }
      { x = 177, y = 205, mat = "?brick" }
      { x = 194, y = 185, mat = "?brick" }
      { x = 214, y = 169, mat = "?brick" }
      { x = 233, y = 157, mat = "?brick" }
      { x = 255, y = 148, mat = "?brick" }
      { x = 288, y = 142, mat = "?brick" }
      { x = 329, y = 148, mat = "?brick" }
      { x = 352, y = 158, mat = "?brick" }
      { x = 372, y = 170, mat = "?brick" }
      { x = 390, y = 185, mat = "?brick" }
      { x = 406, y = 204, mat = "?brick" }
      { x = 418, y = 224, mat = "?brick" }
      { x = 427, y = 246, mat = "?brick" }
      { x = 433, y = 288, mat = "?brick" }
      { x = 427, y = 320, mat = "?brick" }
      { x = 416, y = 343, mat = "?brick" }
      { x = 405, y = 361, mat = "?brick" }
      { x = 391, y = 376, mat = "?brick" }
      { x = 374, y = 393, mat = "?brick" }
      { x = 354, y = 407, mat = "?brick" }
      { x = 329, y = 418, mat = "?brick" }
      { x = 288, y = 425, mat = "?brick" }
      { x = 255, y = 418, mat = "?brick" }
      { x = 222, y = 402, mat = "?brick" }
      { x = 171, y = 351, mat = "?brick" }
      { x = 157, y = 320, mat = "?brick" }
      { b = 384, mat = "?brick" }
    }

    {
      { x = 118, y = 155, mat = "?brick" }
      { x = 137, y = 133, mat = "?brick" }
      { x = 194, y = 185, mat = "?floor1" }
      { x = 177, y = 205, mat = "?step" }
      { t = -48, mat = "?floor1", light_add=32 }
    }
    {
      { x = 118, y = 155, mat = "?brick" }
      { x = 137, y = 133, mat = "?brick" }
      { x = 194, y = 185, mat = "?top" }
      { x = 177, y = 205, mat = "?step" }
      { b = 384, mat = "?brick" }
    }

    {
      { x =  45, y = 455, mat = "?brick" }
      { x = 171, y = 351, mat = "?floor1" }
      { x = 222, y = 402, mat = "?brick" }
      { x = 121, y = 527, mat = "?brick" }
      { t = -108, mat = "_LIQUID" }
    }
    {
      { x =  45, y = 455, mat = "?brick" }
      { x = 171, y = 351, mat = "?top" }
      { x = 222, y = 402, mat = "?brick" }
      { x = 121, y = 527, mat = "?brick" }
      { b = 384, mat = "?brick" }
    }

    {
      { x = 192, y =  16, mat = "?brick" }
      { x = 288, y =   8, mat = "?brick" }
      { x = 288, y = 142, mat = "?floor1" }
      { x = 255, y = 148, mat = "?step" }
      { t = 0, mat = "?floor1" }
    }
    {
      { x = 192, y =  16, mat = "?brick" }
      { x = 288, y =   8, mat = "?brick" }
      { x = 288, y = 142, mat = "?top" }
      { x = 255, y = 148, mat = "?step" }
      { b = 384, mat = "?brick" }
    }

    {
      { x = 329, y = 148, mat = "?step" }
      { x = 384, y =  16, mat = "?brick" }
      { x = 432, y =  32, mat = "?brick" }
      { x = 352, y = 158, mat = "?floor1" }
      { t = 12, mat = "?floor1" }
    }
    {
      { x = 329, y = 148, mat = "?step" }
      { x = 384, y =  16, mat = "?brick" }
      { x = 432, y =  32, mat = "?brick" }
      { x = 352, y = 158, mat = "?top" }
      { b = 384, mat = "?brick" }
    }

    {
      { x = 390, y = 185, mat = "?step" }
      { x = 496, y =  80, mat = "?brick" }
      { x = 520, y = 104, mat = "?brick" }
      { x = 406, y = 204, mat = "?floor1" }
      { t = 48, mat = "?floor1" }
    }
    {
      { x = 390, y = 185, mat = "?step" }
      { x = 496, y =  80, mat = "?brick" }
      { x = 520, y = 104, mat = "?brick" }
      { x = 406, y = 204, mat = "?top" }
      { b = 384, mat = "?brick" }
    }

    {
      { x = 427, y = 246, mat = "?step" }
      { x = 560, y = 192, mat = "?brick" }
      { x = 568, y = 288, mat = "?brick" }
      { x = 433, y = 288, mat = "?floor1" }
      { t = 84, mat = "?floor1" }
    }
    {
      { x = 427, y = 246, mat = "?step" }
      { x = 560, y = 192, mat = "?brick" }
      { x = 568, y = 288, mat = "?brick" }
      { x = 433, y = 288, mat = "?top" }
      { b = 384, mat = "?brick" }
    }

    {
      { x = 416, y = 343, mat = "?floor1" }
      { x = 427, y = 320, mat = "?step" }
      { x = 560, y = 384, mat = "?brick" }
      { x = 544, y = 432, mat = "?brick" }
      { t = 96, mat = "?floor1" }
    }
    {
      { x = 416, y = 343, mat = "?top" }
      { x = 427, y = 320, mat = "?brick" }
      { x = 560, y = 384, mat = "?brick" }
      { x = 544, y = 432, mat = "?brick" }
      { b = 384, mat = "?brick" }
    }

    {
      { x = 374, y = 393, mat = "?floor1" }
      { x = 391, y = 376, mat = "?step" }
      { x = 443, y = 437, mat = "?brick" }
      { x = 423, y = 456, mat = "?brick" }
      { t = 132, mat = "?floor1", light_add=32 }
    }
    {
      { x = 374, y = 393, mat = "?top" }
      { x = 391, y = 376, mat = "?step" }
      { x = 443, y = 437, mat = "?brick" }
      { x = 423, y = 456, mat = "?brick" }
      { b = 384, mat = "?brick" }
    }

    {
      { x = 288, y = 425, mat = "?floor1" }
      { x = 329, y = 418, mat = "?step" }
      { x = 384, y = 560, mat = "?brick" }
      { x = 288, y = 568, mat = "?brick" }
      { t = 168, mat = "?floor1" }
    }
    {
      { x = 288, y = 425, mat = "?top" }
      { x = 329, y = 418, mat = "?step" }
      { x = 384, y = 560, mat = "?brick" }
      { x = 288, y = 568, mat = "?brick" }
      { b = 384, mat = "?brick" }
    }

    {
      { x = 121, y = 527, mat = "?floor1" }
      { x = 222, y = 402, mat = "?floor1" }
      { x = 255, y = 418, mat = "?brick" }
      { x = 192, y = 560, mat = "?brick" }
      { t = -80, mat = "?floor1" }
    }
    {
      { x = 121, y = 527, mat = "?brick" }
      { x = 222, y = 402, mat = "?top" }
      { x = 255, y = 418, mat = "?brick" }
      { x = 192, y = 560, mat = "?brick" }
      { b = 384, mat = "?brick" }
    }

    {
      { x =   8, y = 288, mat = "?brick" }
      { x = 151, y = 288, mat = "?floor1" }
      { x = 157, y = 320, mat = "?step" }
      { x =  16, y = 384, mat = "?brick" }
      { t = -84, mat = "?floor1" }
    }
    {
      { x =   8, y = 288, mat = "?brick" }
      { x = 151, y = 288, mat = "?top" }
      { x = 157, y = 320, mat = "?brick" }
      { x =  16, y = 384, mat = "?brick" }
      { b = 384, mat = "?brick" }
    }

    {
      { x =  16, y = 192, mat = "?brick" }
      { x =  32, y = 144, mat = "?brick" }
      { x = 167, y = 224, mat = "?floor1" }
      { x = 157, y = 246, mat = "?step" }
      { t = -72, mat = "?floor1" }
    }
    {
      { x =  16, y = 192, mat = "?brick" }
      { x =  32, y = 144, mat = "?brick" }
      { x = 167, y = 224, mat = "?top" }
      { x = 157, y = 246, mat = "?step" }
      { b = 384, mat = "?brick", light_add=16 }
    }

    {
      { x =  80, y =  80, mat = "?brick" }
      { x = 104, y =  56, mat = "?brick" }
      { x = 214, y = 169, mat = "?floor1" }
      { x = 194, y = 185, mat = "?step" }
      { x = 137, y = 133, mat = "?step" }
      { t = -36, mat = "?floor1" }
    }
    {
      { x =  80, y =  80, mat = "?brick" }
      { x = 104, y =  56, mat = "?brick" }
      { x = 214, y = 169, mat = "?top" }
      { x = 194, y = 185, mat = "?step" }
      { x = 137, y = 133, mat = "?step" }
      { b = 384, mat = "?brick", light_add=32 }
    }

    {
      { x = 354, y = 407, mat = "?floor1" }
      { x = 374, y = 393, mat = "?step" }
      { x = 423, y = 456, mat = "?step" }
      { x = 472, y = 520, mat = "?brick" }
      { x = 432, y = 544, mat = "?brick" }
      { t = 144, mat = "?floor1", light_add=32 }
    }
    {
      { x = 354, y = 407, mat = "?top" }
      { x = 374, y = 393, mat = "?step" }
      { x = 423, y = 456, mat = "?step" }
      { x = 472, y = 520, mat = "?brick" }
      { x = 432, y = 544, mat = "?brick" }
      { b = 384, mat = "?brick" }
    }

    {
      { x = 432, y = 544, mat = "?brick" }
      { x = 472, y = 520, mat = "?brick" }
      { x = 472, y = 576, mat = "?outer" }
      { x = 432, y = 576, mat = "?brick" }
    }

    {
      { x = 423, y = 456, mat = "?brick" }
      { x = 443, y = 437, mat = "?step" }
      { x = 496, y = 496, mat = "?brick" }
      { x = 472, y = 520, mat = "?brick" }
      { t = 132, mat = "?floor1", light_add=48 }
    }
    {
      { x = 423, y = 456, mat = "?brick" }
      { x = 443, y = 437, mat = "?step" }
      { x = 496, y = 496, mat = "?brick" }
      { x = 472, y = 520, mat = "?brick" }
      { b = 384, mat = "?brick" }
    }

    {
      { x = 405, y = 361, mat = "?floor1" }
      { x = 416, y = 343, mat = "?step" }
      { x = 544, y = 432, mat = "?brick" }
      { x = 520, y = 472, mat = "?brick" }
      { t = 108, mat = "?floor1" }
    }
    {
      { x = 405, y = 361, mat = "?top" }
      { x = 416, y = 343, mat = "?step" }
      { x = 544, y = 432, mat = "?brick" }
      { x = 520, y = 472, mat = "?brick" }
      { b = 384, mat = "?brick", light_add=16 }
    }

    {
      { x = 520, y = 472, mat = "?brick" }
      { x = 544, y = 432, mat = "?brick" }
      { x = 576, y = 432, mat = "?outer" }
      { x = 576, y = 472, mat = "?brick" }
    }

    {
      { x = 406, y = 204, mat = "?step" }
      { x = 520, y = 104, mat = "?brick" }
      { x = 544, y = 144, mat = "?brick" }
      { x = 418, y = 224, mat = "?floor1" }
      { t = 60, mat = "?floor1" }
    }
    {
      { x = 406, y = 204, mat = "?step" }
      { x = 520, y = 104, mat = "?brick" }
      { x = 544, y = 144, mat = "?brick" }
      { x = 418, y = 224, mat = "?top" }
      { b = 384, mat = "?brick" }
    }

    {
      { x = 520, y = 104, mat = "?brick" }
      { x = 576, y = 104, mat = "?outer" }
      { x = 576, y = 144, mat = "?brick" }
      { x = 544, y = 144, mat = "?brick" }
    }

    {
      { x = 352, y = 158, mat = "?step" }
      { x = 432, y =  32, mat = "?brick" }
      { x = 472, y =  56, mat = "?brick" }
      { x = 372, y = 170, mat = "?floor1" }
      { t = 24, mat = "?floor1" }
    }
    {
      { x = 352, y = 158, mat = "?step" }
      { x = 432, y =  32, mat = "?brick" }
      { x = 472, y =  56, mat = "?brick" }
      { x = 372, y = 170, mat = "?top" }
      { b = 384, mat = "?brick" }
    }

    {
      { x = 432, y =   0, mat = "?outer" }
      { x = 472, y =   0, mat = "?brick" }
      { x = 472, y =  56, mat = "?brick" }
      { x = 432, y =  32, mat = "?brick" }
    }

    {
      { x = 104, y =  56, mat = "?brick" }
      { x = 144, y =  32, mat = "?brick" }
      { x = 233, y = 157, mat = "?floor1" }
      { x = 214, y = 169, mat = "?step" }
      { t = -24, mat = "?floor1" }
    }
    {
      { x = 104, y =  56, mat = "?brick" }
      { x = 144, y =  32, mat = "?brick" }
      { x = 233, y = 157, mat = "?top" }
      { x = 214, y = 169, mat = "?step" }
      { b = 384, mat = "?brick", light_add=16 }
    }

    {
      { x = 104, y =   0, mat = "?outer" }
      { x = 144, y =   0, mat = "?brick" }
      { x = 144, y =  32, mat = "?brick" }
      { x = 104, y =  56, mat = "?brick" }
    }

    {
      { x =  32, y = 144, mat = "?brick" }
      { x =  56, y = 104, mat = "?brick" }
      { x = 118, y = 155, mat = "?brick" }
      { x = 177, y = 205, mat = "?floor1" }
      { x = 167, y = 224, mat = "?step" }
      { t = -60, mat = "?floor1" }
    }
    {
      { x =  32, y = 144, mat = "?brick" }
      { x =  56, y = 104, mat = "?brick" }
      { x = 118, y = 155, mat = "?brick" }
      { x = 177, y = 205, mat = "?top" }
      { x = 167, y = 224, mat = "?step" }
      { b = 384, mat = "?brick", light_add=32 }
    }

    {
      { x =   0, y = 104, mat = "?brick" }
      { x =  56, y = 104, mat = "?brick" }
      { x =  32, y = 144, mat = "?brick" }
      { x =   0, y = 144, mat = "?outer" }
    }

    {
      { x =  32, y = 480, mat = "?brick" }
      { x =  45, y = 455, mat = "?brick" }
      { x = 121, y = 527, mat = "?brick" }
      { x =  88, y = 545, mat = "?brick" }
      { t = -108, mat = "_LIQUID" }
    }
    {
      { x =  32, y = 480, mat = "?brick" }
      { x =  45, y = 455, mat = "?brick" }
      { x = 121, y = 527, mat = "?brick" }
      { x =  88, y = 545, mat = "?brick" }
      { b = 280, mat = "?brick" }
    }

    {
      { x =  16, y = 496, mat = "?brick" }
      { x =  32, y = 480, mat = "_LIQUID" }
      { x =  88, y = 545, mat = "?brick" }
      { x =  72, y = 560, mat = "?brick" }
      { t = 232, mat = "_LIQUID" }
    }
    {
      { x =  16, y = 496, mat = "?brick" }
      { x =  32, y = 480, mat = "?brick" }
      { x =  88, y = 545, mat = "?brick" }
      { x =  72, y = 560, mat = "?brick" }
      { b = 280, mat = "?brick", light_sub=16 }
    }

    {
      { x =   8, y = 552, mat = "?brick" }
      { x =  16, y = 496, mat = "?brick" }
      { x =  72, y = 560, mat = "?brick" }
      { x =  24, y = 568, mat = "?brick" }
      { t = 232, mat = "_LIQUID" }
    }
    {
      { x =   8, y = 552, mat = "?brick" }
      { x =  16, y = 496, mat = "?brick" }
      { x =  72, y = 560, mat = "?brick" }
      { x =  24, y = 568, mat = "?brick" }
      { b = 280, mat = "?brick", light_sub=40 }
    }

    {
      { x =   0, y = 496, mat = "?brick" }
      { x =  16, y = 496, mat = "?brick" }
      { x =   8, y = 552, mat = "?brick" }
      { x =   0, y = 552, mat = "?outer" }
    }

    {
      { x =  24, y = 568, mat = "?brick" }
      { x =  72, y = 560, mat = "?brick" }
      { x =  72, y = 576, mat = "?outer" }
      { x =  24, y = 576, mat = "?brick" }
    }
  }

  entities =
  {
    { ent = "?torch_ent", x =  89, y = 106, z = -48, angle = 45 }
    { ent = "?torch_ent", x = 474, y = 491, z = 132, angle = 225 }

    { ent = "?gore_ent", x = 176, y = 528, z = -80, angle = 270 }
    { ent = "?gore_ent", x = 192, y = 472, z = -80, angle = 270 }
    { ent = "?gore_ent", x = 224, y = 440, z = -80, angle = 270 }
  }
}

