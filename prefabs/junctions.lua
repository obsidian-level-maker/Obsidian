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
      { b = 192, mat = "?wall" }
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
      { b = 192, mat = "?wall" }
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
      { b = 192, mat = "?wall" }
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
      { b = 192, mat = "?wall" }
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

