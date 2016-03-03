----------------------------------------------------------------
--  CEILING PREFABS
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

PREFAB.CEIL_LIGHT =
{
  ceiling_relative = true,

  brushes =
  {
    -- trim around light
    {
      { x = -40, y = -40, mat = "?trim" }
      { x =  40, y = -40, mat = "?trim" }
      { x =  40, y =  40, mat = "?trim" }
      { x = -40, y =  40, mat = "?trim" }
      { b = -16, mat = "?trim" }
    }

    -- light itself
    {
      { x = -32, y = -32, mat = "?glow" }
      { x =  32, y = -32, mat = "?glow" }
      { x =  32, y =  32, mat = "?glow" }
      { x = -32, y =  32, mat = "?glow" }
      { b = -18, delta_z = 10, light = 0.9, mat = "?glow" }
    }
  }
}


PREFAB.SKYLITE_1 =
{
  ceiling_relative = true,

  brushes =
  {
    -- sky part
    {
      { m = "sky", flavor = "ceil:3" }
      { x = -128, y = -128, mat = "_SKY" }
      { x =  128, y = -128, mat = "_SKY" }
      { x =  128, y =  128, mat = "_SKY" }
      { x = -128, y =  128, mat = "_SKY" }
      { b = 16, mat = "_SKY" }
    }

    -- trim around sky
    {
      { m = "solid", flavor = "ceil:2" }
      { x = -160, y = -160, mat = "?trim" }
      { x =  160, y = -160, mat = "?trim" }
      { x =  160, y =  160, mat = "?trim" }
      { x = -160, y =  160, mat = "?trim" }
      { b = -16, mat = "?trim" }
    }

    -- spokes
    {
      { x = -192, y = -12, mat = "?metal" }
      { x = -112, y = -12, mat = "?metal" }
      { x = -112, y =  12, mat = "?metal" }
      { x = -192, y =  12, mat = "?metal" }
      { b = -32, mat = "?metal" }
    }

    {
      { x =  112, y = -12, mat = "?metal" }
      { x =  192, y = -12, mat = "?metal" }
      { x =  192, y =  12, mat = "?metal" }
      { x =  112, y =  12, mat = "?metal" }
      { b = -32, mat = "?metal" }
    }
  }
}

