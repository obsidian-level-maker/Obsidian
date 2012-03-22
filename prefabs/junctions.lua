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
  }
}


PREFAB.JUNCTION_NUKE_PIPES =
{
  fitted = "xy"

  defaults =
  {
    w5 = "BROWNHUG"
    w4 = "COMPSPAN"
    w2 = "LITE3"
    w3 = "METAL"
    w7 = "METAL4"
    w6 = "_LIQUID"
    w1 = "BLAKWAL1"

    ff2 = "CEIL3_3"
    ff1 = "CEIL5_1"
    ccc5 = "CEIL3_3"
    ccc3 = "CEIL5_1"
    ccc1 = "CEIL5_2"
    ccc4 = "FLOOR0_1"
    ccc2 = "FLOOR7_1"

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
      { x =   0, y = 520, mat = "?w1" }
      { x =  32, y = 520, mat = "?w2" }
      { x =  56, y = 544, mat = "?w1" }
      { x =  56, y = 576, mat = "?outer" }
      { x =   0, y = 576, mat = "?outer" }
    }

    {
      { x =   0, y = 512, mat = "?w1" }
      { x =  32, y = 512, mat = "?w1" }
      { x =  32, y = 520, mat = "?w1" }
      { x =   0, y = 520, mat = "?outer" }
    }

    {
      { x =   8, y = 320, mat = "?w3" }
      { x =  32, y = 320, mat = "?w3" }
      { x =  32, y = 512, mat = "?w1" }
      { x =   8, y = 512, mat = "?w1" }
      { b = 176, mat = "?ccc1" }
    }

    {
      { x =  64, y = 568, mat = "?w1" }
      { x = 192, y = 568, mat = "?w1" }
      { x = 192, y = 576, mat = "?outer" }
      { x =  64, y = 576, mat = "?w1" }
    }

    {
      { x =  56, y = 544, mat = "?w1" }
      { x =  64, y = 544, mat = "?w1" }
      { x =  64, y = 576, mat = "?outer" }
      { x =  56, y = 576, mat = "?w1" }
    }

    {
      { x =   0, y = 192, mat = "?w1" }
      { x =   8, y = 192, mat = "?w1" }
      { x =   8, y = 384, mat = "?w1" }
      { x =   0, y = 384, mat = "?outer" }
      { b = "?west_h", mat = "?ccc2" }
    }

    {
      { x =  32, y = 320, mat = "?w4" }
      { x = 224, y = 320, mat = "?w4" }
      { x = 256, y = 352, mat = "?w4" }
      { x = 256, y = 544, mat = "?w1" }
      { x =  64, y = 544, mat = "?w1" }
      { x =  48, y = 528, mat = "?w1" }
      { x =  32, y = 512, mat = "?w1" }
      { b = 240, mat = "?ccc3" }
    }

    {
      { x =   8, y = 256, mat = "?w4" }
      { x = 224, y = 256, mat = "?w1" }
      { x = 224, y = 320, mat = "?w4" }
      { x =   8, y = 320, mat = "?w1" }
      { t = 0, mat = "?ff1" }
    }
    {
      { x =   8, y = 256, mat = "?w5" }
      { x = 224, y = 256, mat = "?w1" }
      { x = 224, y = 320, mat = "?w5" }
      { x =   8, y = 320, mat = "?w1" }
      { b = 256, mat = "?ccc4" }
    }

    {
      { x = 192, y = 568, mat = "?w1" }
      { x = 384, y = 568, mat = "?w1" }
      { x = 384, y = 576, mat = "?outer" }
      { x = 192, y = 576, mat = "?w1" }
      { b = "?north_h", mat = "?ccc2" }
    }

    {
      { x = 224, y = 256, mat = "?w4" }
      { x = 256, y = 224, mat = "?w5" }
      { x = 320, y = 224, mat = "?w4" }
      { x = 352, y = 256, mat = "?w5" }
      { x = 352, y = 320, mat = "?w4" }
      { x = 320, y = 352, mat = "?w5" }
      { x = 256, y = 352, mat = "?w4" }
      { x = 224, y = 320, mat = "?w5" }
      { t = 0, mat = "?ff1" }
    }
    {
      { x = 224, y = 256, mat = "?w5" }
      { x = 256, y = 224, mat = "?w5" }
      { x = 320, y = 224, mat = "?w5" }
      { x = 352, y = 256, mat = "?w5" }
      { x = 352, y = 320, mat = "?w5" }
      { x = 320, y = 352, mat = "?w5" }
      { x = 256, y = 352, mat = "?w5" }
      { x = 224, y = 320, mat = "?w5" }
      { b = 256, mat = "?ccc4" }
    }

    {
      { x = 112, y = 432, mat = "?w7" }
      { x = 120, y = 408, mat = "?w7" }
      { x = 144, y = 400, mat = "?w7" }
      { x = 168, y = 408, mat = "?w7" }
      { x = 176, y = 432, mat = "?w7" }
      { x = 168, y = 456, mat = "?w7" }
      { x = 144, y = 464, mat = "?w7" }
      { x = 120, y = 456, mat = "?w7" }
      { b = 112, mat = "?ccc3" }
    }

    {
      { x =  32, y = 512, mat = "?w1" }
      { x =  48, y = 528, mat = "?w1" }
      { x =  64, y = 544, mat = "?w1" }
      { x =  56, y = 544, mat = "?w1" }
      { x =  32, y = 520, mat = "?w1" }
      { t = 32, mat = "?ff2" }
    }
    {
      { x =  32, y = 512, mat = "?w1" }
      { x =  48, y = 528, mat = "?w1" }
      { x =  64, y = 544, mat = "?w1" }
      { x =  56, y = 544, mat = "?w1" }
      { x =  32, y = 520, mat = "?w1" }
      { b = 160, mat = "?ccc5" }
    }

    {
      { x =  64, y = 544, mat = "?w3" }
      { x = 256, y = 544, mat = "?w3" }
      { x = 256, y = 568, mat = "?w1" }
      { x =  64, y = 568, mat = "?w1" }
      { b = 176, mat = "?ccc1" }
    }

    {
      { x = 256, y = 352, mat = "?w1" }
      { x = 320, y = 352, mat = "?w4" }
      { x = 320, y = 568, mat = "?w1" }
      { x = 256, y = 568, mat = "?w4" }
      { t = 0, mat = "?ff1" }
    }
    {
      { x = 256, y = 352, mat = "?w1" }
      { x = 320, y = 352, mat = "?w5" }
      { x = 320, y = 568, mat = "?w1" }
      { x = 256, y = 568, mat = "?w5" }
      { b = 256, mat = "?ccc4" }
    }

    {
      { x =   0, y = 384, mat = "?w1" }
      { x =   8, y = 384, mat = "?w1" }
      { x =   8, y = 512, mat = "?w1" }
      { x =   0, y = 512, mat = "?outer" }
    }

    {
      { x = 520, y = 544, mat = "?w2" }
      { x = 544, y = 520, mat = "?w1" }
      { x = 576, y = 520, mat = "?outer" }
      { x = 576, y = 576, mat = "?outer" }
      { x = 520, y = 576, mat = "?w1" }
    }

    {
      { x = 544, y = 512, mat = "?w1" }
      { x = 576, y = 512, mat = "?outer" }
      { x = 576, y = 520, mat = "?w1" }
      { x = 544, y = 520, mat = "?w1" }
    }

    {
      { x = 544, y = 320, mat = "?w3" }
      { x = 568, y = 320, mat = "?w1" }
      { x = 568, y = 512, mat = "?w1" }
      { x = 544, y = 512, mat = "?w3" }
      { b = 176, mat = "?ccc1" }
    }

    {
      { x = 384, y = 568, mat = "?w1" }
      { x = 512, y = 568, mat = "?w1" }
      { x = 512, y = 576, mat = "?outer" }
      { x = 384, y = 576, mat = "?w1" }
    }

    {
      { x = 512, y = 544, mat = "?w1" }
      { x = 520, y = 544, mat = "?w1" }
      { x = 520, y = 576, mat = "?outer" }
      { x = 512, y = 576, mat = "?w1" }
    }

    {
      { x = 568, y = 192, mat = "?w1" }
      { x = 576, y = 192, mat = "?outer" }
      { x = 576, y = 384, mat = "?w1" }
      { x = 568, y = 384, mat = "?w1" }
      { b = "?east_h", mat = "?ccc2" }
    }

    {
      { x = 320, y = 352, mat = "?w4" }
      { x = 352, y = 320, mat = "?w4" }
      { x = 544, y = 320, mat = "?w1" }
      { x = 544, y = 512, mat = "?w1" }
      { x = 528, y = 528, mat = "?w1" }
      { x = 512, y = 544, mat = "?w1" }
      { x = 320, y = 544, mat = "?w4" }
      { b = 240, mat = "?ccc3" }
    }

    {
      { x = 352, y = 256, mat = "?w4" }
      { x = 568, y = 256, mat = "?w1" }
      { x = 568, y = 320, mat = "?w4" }
      { x = 352, y = 320, mat = "?w1" }
      { t = 0, mat = "?ff1" }
    }
    {
      { x = 352, y = 256, mat = "?w5" }
      { x = 568, y = 256, mat = "?w1" }
      { x = 568, y = 320, mat = "?w5" }
      { x = 352, y = 320, mat = "?w1" }
      { b = 256, mat = "?ccc4" }
    }

    {
      { x = 400, y = 432, mat = "?w7" }
      { x = 408, y = 408, mat = "?w7" }
      { x = 432, y = 400, mat = "?w7" }
      { x = 456, y = 408, mat = "?w7" }
      { x = 464, y = 432, mat = "?w7" }
      { x = 456, y = 456, mat = "?w7" }
      { x = 432, y = 464, mat = "?w7" }
      { x = 408, y = 456, mat = "?w7" }
      { b = 112, mat = "?ccc3" }
    }

    {
      { x = 512, y = 544, mat = "?w1" }
      { x = 528, y = 528, mat = "?w1" }
      { x = 544, y = 512, mat = "?w1" }
      { x = 544, y = 520, mat = "?w1" }
      { x = 520, y = 544, mat = "?w1" }
      { t = 32, mat = "?ff2" }
    }
    {
      { x = 512, y = 544, mat = "?w1" }
      { x = 528, y = 528, mat = "?w1" }
      { x = 544, y = 512, mat = "?w1" }
      { x = 544, y = 520, mat = "?w1" }
      { x = 520, y = 544, mat = "?w1" }
      { b = 160, mat = "?ccc5" }
    }

    {
      { x = 320, y = 544, mat = "?w3" }
      { x = 512, y = 544, mat = "?w1" }
      { x = 512, y = 568, mat = "?w1" }
      { x = 320, y = 568, mat = "?w3" }
      { b = 176, mat = "?ccc1" }
    }

    {
      { x = 568, y = 384, mat = "?w1" }
      { x = 576, y = 384, mat = "?outer" }
      { x = 576, y = 512, mat = "?w1" }
      { x = 568, y = 512, mat = "?w1" }
    }

    {
      { x =   0, y =   0, mat = "?outer" }
      { x =  56, y =   0, mat = "?w1" }
      { x =  56, y =  32, mat = "?w2" }
      { x =  32, y =  56, mat = "?w1" }
      { x =   0, y =  56, mat = "?outer" }
    }

    {
      { x =   0, y =  56, mat = "?w1" }
      { x =  32, y =  56, mat = "?w1" }
      { x =  32, y =  64, mat = "?w1" }
      { x =   0, y =  64, mat = "?outer" }
    }

    {
      { x =   8, y =  64, mat = "?w1" }
      { x =  32, y =  64, mat = "?w3" }
      { x =  32, y = 256, mat = "?w3" }
      { x =   8, y = 256, mat = "?w1" }
      { b = 176, mat = "?ccc1" }
    }

    {
      { x =  64, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?w1" }
      { x = 192, y =   8, mat = "?w1" }
      { x =  64, y =   8, mat = "?w1" }
    }

    {
      { x =  56, y =   0, mat = "?outer" }
      { x =  64, y =   0, mat = "?w1" }
      { x =  64, y =  32, mat = "?w1" }
      { x =  56, y =  32, mat = "?w1" }
    }

    {
      { x =  32, y =  64, mat = "?w1" }
      { x =  48, y =  48, mat = "?w1" }
      { x =  64, y =  32, mat = "?w1" }
      { x = 256, y =  32, mat = "?w4" }
      { x = 256, y = 224, mat = "?w4" }
      { x = 224, y = 256, mat = "?w4" }
      { x =  32, y = 256, mat = "?w1" }
      { b = 240, mat = "?ccc3" }
    }

    {
      { x = 192, y =   0, mat = "?outer" }
      { x = 384, y =   0, mat = "?w1" }
      { x = 384, y =   8, mat = "?w1" }
      { x = 192, y =   8, mat = "?w1" }
      { b = "?south_h", mat = "?ccc2" }
    }

    {
      { x = 112, y = 144, mat = "?w7" }
      { x = 120, y = 120, mat = "?w7" }
      { x = 144, y = 112, mat = "?w7" }
      { x = 168, y = 120, mat = "?w7" }
      { x = 176, y = 144, mat = "?w7" }
      { x = 168, y = 168, mat = "?w7" }
      { x = 144, y = 176, mat = "?w7" }
      { x = 120, y = 168, mat = "?w7" }
      { b = 112, mat = "?ccc3" }
    }

    {
      { x =  32, y =  56, mat = "?w1" }
      { x =  56, y =  32, mat = "?w1" }
      { x =  64, y =  32, mat = "?w1" }
      { x =  48, y =  48, mat = "?w1" }
      { x =  32, y =  64, mat = "?w1" }
      { t = 32, mat = "?ff2" }
    }
    {
      { x =  32, y =  56, mat = "?w1" }
      { x =  56, y =  32, mat = "?w1" }
      { x =  64, y =  32, mat = "?w1" }
      { x =  48, y =  48, mat = "?w1" }
      { x =  32, y =  64, mat = "?w1" }
      { b = 160, mat = "?ccc5" }
    }

    {
      { x =  64, y =   8, mat = "?w1" }
      { x = 256, y =   8, mat = "?w3" }
      { x = 256, y =  32, mat = "?w3" }
      { x =  64, y =  32, mat = "?w1" }
      { b = 176, mat = "?ccc1" }
    }

    {
      { x = 256, y =   8, mat = "?w1" }
      { x = 320, y =   8, mat = "?w4" }
      { x = 320, y = 224, mat = "?w1" }
      { x = 256, y = 224, mat = "?w4" }
      { t = 0, mat = "?ff1" }
    }
    {
      { x = 256, y =   8, mat = "?w1" }
      { x = 320, y =   8, mat = "?w5" }
      { x = 320, y = 224, mat = "?w1" }
      { x = 256, y = 224, mat = "?w5" }
      { b = 256, mat = "?ccc4" }
    }

    {
      { x =   0, y =  64, mat = "?w1" }
      { x =   8, y =  64, mat = "?w1" }
      { x =   8, y = 192, mat = "?w1" }
      { x =   0, y = 192, mat = "?outer" }
    }

    {
      { x = 520, y =   0, mat = "?outer" }
      { x = 576, y =   0, mat = "?outer" }
      { x = 576, y =  56, mat = "?w1" }
      { x = 544, y =  56, mat = "?w2" }
      { x = 520, y =  32, mat = "?w1" }
    }

    {
      { x = 544, y =  56, mat = "?w1" }
      { x = 576, y =  56, mat = "?outer" }
      { x = 576, y =  64, mat = "?w1" }
      { x = 544, y =  64, mat = "?w1" }
    }

    {
      { x = 544, y =  64, mat = "?w1" }
      { x = 568, y =  64, mat = "?w1" }
      { x = 568, y = 256, mat = "?w3" }
      { x = 544, y = 256, mat = "?w3" }
      { b = 176, mat = "?ccc1" }
    }

    {
      { x = 384, y =   0, mat = "?outer" }
      { x = 512, y =   0, mat = "?w1" }
      { x = 512, y =   8, mat = "?w1" }
      { x = 384, y =   8, mat = "?w1" }
    }

    {
      { x = 512, y =   0, mat = "?outer" }
      { x = 520, y =   0, mat = "?w1" }
      { x = 520, y =  32, mat = "?w1" }
      { x = 512, y =  32, mat = "?w1" }
    }

    {
      { x = 320, y =  32, mat = "?w1" }
      { x = 512, y =  32, mat = "?w1" }
      { x = 528, y =  48, mat = "?w1" }
      { x = 544, y =  64, mat = "?w1" }
      { x = 544, y = 256, mat = "?w4" }
      { x = 352, y = 256, mat = "?w4" }
      { x = 320, y = 224, mat = "?w4" }
      { b = 240, mat = "?ccc3" }
    }

    {
      { x = 400, y = 144, mat = "?w7" }
      { x = 408, y = 120, mat = "?w7" }
      { x = 432, y = 112, mat = "?w7" }
      { x = 456, y = 120, mat = "?w7" }
      { x = 464, y = 144, mat = "?w7" }
      { x = 456, y = 168, mat = "?w7" }
      { x = 432, y = 176, mat = "?w7" }
      { x = 408, y = 168, mat = "?w7" }
      { b = 112, mat = "?ccc3" }
    }

    {
      { x = 512, y =  32, mat = "?w1" }
      { x = 520, y =  32, mat = "?w1" }
      { x = 544, y =  56, mat = "?w1" }
      { x = 544, y =  64, mat = "?w1" }
      { x = 528, y =  48, mat = "?w1" }
      { t = 32, mat = "?ff2" }
    }
    {
      { x = 512, y =  32, mat = "?w1" }
      { x = 520, y =  32, mat = "?w1" }
      { x = 544, y =  56, mat = "?w1" }
      { x = 544, y =  64, mat = "?w1" }
      { x = 528, y =  48, mat = "?w1" }
      { b = 160, mat = "?ccc5" }
    }

    {
      { x = 320, y =   8, mat = "?w1" }
      { x = 512, y =   8, mat = "?w1" }
      { x = 512, y =  32, mat = "?w3" }
      { x = 320, y =  32, mat = "?w3" }
      { b = 176, mat = "?ccc1" }
    }

    {
      { x = 568, y =  64, mat = "?w1" }
      { x = 576, y =  64, mat = "?outer" }
      { x = 576, y = 192, mat = "?w1" }
      { x = 568, y = 192, mat = "?w1" }
    }

    -- falling nukage
    {
      { m = "rail" }
      { x = 128, y = 144, mat = "?w6" }
      { x = 132, y = 132, mat = "?w6" }
      { x = 144, y = 128, mat = "?w6" }
      { x = 156, y = 132, mat = "?w6" }
      { x = 160, y = 144, mat = "?w6" }
      { x = 156, y = 156, mat = "?w6" }
      { x = 144, y = 160, mat = "?w6" }
      { x = 132, y = 156, mat = "?w6" }
    }

    {
      { m = "rail" }
      { x = 128, y = 432, mat = "?w6" }
      { x = 132, y = 420, mat = "?w6" }
      { x = 144, y = 416, mat = "?w6" }
      { x = 156, y = 420, mat = "?w6" }
      { x = 160, y = 432, mat = "?w6" }
      { x = 156, y = 444, mat = "?w6" }
      { x = 144, y = 448, mat = "?w6" }
      { x = 132, y = 444, mat = "?w6" }
      { t = 112 }
      { b = -16 }
    }

    {
      { m = "rail" }
      { x = 416, y = 144, mat = "?w6" }
      { x = 420, y = 132, mat = "?w6" }
      { x = 432, y = 128, mat = "?w6" }
      { x = 444, y = 132, mat = "?w6" }
      { x = 448, y = 144, mat = "?w6" }
      { x = 444, y = 156, mat = "?w6" }
      { x = 432, y = 160, mat = "?w6" }
      { x = 420, y = 156, mat = "?w6" }
      { t = 112 }
      { b = -16 }
    }

    {
      { m = "rail" }
      { x = 416, y = 432, mat = "?w6" }
      { x = 420, y = 420, mat = "?w6" }
      { x = 432, y = 416, mat = "?w6" }
      { x = 444, y = 420, mat = "?w6" }
      { x = 448, y = 432, mat = "?w6" }
      { x = 444, y = 444, mat = "?w6" }
      { x = 432, y = 448, mat = "?w6" }
      { x = 420, y = 444, mat = "?w6" }
      { t = 112 }
      { b = -16 }
    }


    -- lighting
    {
      { m = "light", add = 128 }
      { x =  40, y =  64 }
      { x =  64, y =  40 }
      { x = 224, y = 112 }
      { x = 224, y = 176 }
      { x = 176, y = 224 }
      { x = 112, y = 224 }
    }

    {
      { m = "light", add = 128 }
      { x =  40, y = 512 }
      { x = 112, y = 352 }
      { x = 176, y = 352 }
      { x = 224, y = 400 }
      { x = 224, y = 464 }
      { x =  64, y = 536 }
    }

    {
      { m = "light", add = 128 }
      { x = 352, y = 112 }
      { x = 512, y =  40 }
      { x = 536, y =  64 }
      { x = 464, y = 224 }
      { x = 400, y = 224 }
      { x = 352, y = 176 }
    }

    {
      { m = "light", add = 128 }
      { x = 352, y = 400 }
      { x = 400, y = 352 }
      { x = 464, y = 352 }
      { x = 536, y = 512 }
      { x = 512, y = 536 }
      { x = 352, y = 464 }
    }

  }
}

