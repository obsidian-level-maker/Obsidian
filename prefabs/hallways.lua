----------------------------------------------------------------
--  HALLWAY PREFABS
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
--
--  Hallway pieces use the following letters:
--
--     I : straight through, travel N/S, walls on E/W sides
--     C : corner, travel S and E, walls on N and W sides
--     T : T junction: travel S/E/W, wall on N side
--     P : plus shape: travel in all four directions
--
--  They have one thing in common : can always travel south.
--
----------------------------------------------------------------


PREFAB.HALLWAY_S_BEND =
{
  fitted = "xy"

  defaults =
  {
    upper = "?ceil"

    torch_ent = "none"
    style = 1
  }

  brushes =
  {
    -- left/top walls
    {
      { x =   0, y =   0, mat = "?wall" }
      { x =  32, y =   0, mat = "?wall" }
      { x =  32, y =  64, mat = "?wall" }
      { x =   0, y =  64, mat = "?outer" }
    }

    {
      { x =   0, y =  64, mat = "?wall" }
      { x =  32, y =  64, mat = "?wall" }
      { x =  64, y = 128, mat = "?wall" }
      { x =   0, y = 128, mat = "?outer" }
    }

    {
      { x =   0, y = 128, mat = "?wall" }
      { x =  64, y = 128, mat = "?wall" }
      { x = 128, y = 160, mat = "?wall" }
      { x = 128, y = 192, mat = "?outer" }
      { x =   0, y = 192, mat = "?outer" }
    }

    {
      { x = 128, y = 160, mat = "?wall" }
      { x = 384, y = 160, mat = "?wall" }
      { x = 384, y = 192, mat = "?outer" }
      { x = 128, y = 192, mat = "?wall" }
    }

    {
      { x = 384, y = 160, mat = "?wall" }
      { x = 408, y = 168, mat = "?wall" }
      { x = 416, y = 192, mat = "?outer" }
      { x = 384, y = 192, mat = "?wall" }
    }

    -- right/bottom walls
    {
      { x = 160, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y =  32, mat = "?wall" }
      { x = 168, y =  24, mat = "?wall" }
    }

    {
      { x = 192, y =   0, mat = "?wall" }
      { x = 448, y =   0, mat = "?wall" }
      { x = 448, y =  32, mat = "?wall" }
      { x = 192, y =  32, mat = "?wall" }
    }

    {
      { x = 448, y =   0, mat = "?wall" }
      { x = 576, y =   0, mat = "?outer" }
      { x = 576, y =  64, mat = "?wall" }
      { x = 512, y =  64, mat = "?wall" }
      { x = 448, y =  32, mat = "?wall" }
    }

    {
      { x = 512, y =  64, mat = "?wall" }
      { x = 576, y =  64, mat = "?outer" }
      { x = 576, y = 128, mat = "?wall" }
      { x = 544, y = 128, mat = "?wall" }
    }

    {
      { x = 544, y = 128, mat = "?wall" }
      { x = 576, y = 128, mat = "?outer" }
      { x = 576, y = 192, mat = "?outer" }
      { x = 544, y = 192, mat = "?wall" }
    }

    -- steps
    {
      { x =  32, y =   0, mat = "?step", y_offset=0, peg=1 }
      { x = 160, y =   0, mat = "?floor" }
      { x =  32, y =  64, mat = "?floor" }
      { t =  8, mat = "?floor" }
    }
    {
      { x =  32, y =   0, mat = "?ceil" }
      { x = 160, y =   0, mat = "?upper", y_offset=0, peg=1 }
      { x =  32, y =  64, mat = "?ceil" }
      { b =  104, mat = "?ceil" }
    }

    {
      { x =  32, y =  64, mat = "?step", y_offset=0, peg=1 }
      { x = 160, y =   0, mat = "?floor" }
      { x = 168, y =  24, mat = "?floor" }
      { x =  64, y = 128, mat = "?floor" }
      { t = 16, mat = "?floor" }
    }
    {
      { x =  32, y =  64, mat = "?ceil" }
      { x = 160, y =   0, mat = "?ceil" }
      { x = 168, y =  24, mat = "?upper", y_offset=0, peg=1 }
      { x =  64, y = 128, mat = "?ceil" }
      { b = 112, mat = "?ceil" }
    }

    {
      { x =  64, y = 128, mat = "?step", y_offset=0, peg=1 }
      { x = 168, y =  24, mat = "?floor" }
      { x = 192, y =  32, mat = "?floor" }
      { x = 128, y = 160, mat = "?floor" }
      { t = 24, mat = "?floor" }
    }
    {
      { x =  64, y = 128, mat = "?ceil" }
      { x = 168, y =  24, mat = "?ceil" }
      { x = 192, y =  32, mat = "?upper", y_offset=0, peg=1 }
      { x = 128, y = 160, mat = "?ceil" }
      { b = 120, mat = "?ceil" }
    }

    {
      { x = 128, y = 160, mat = "?step", y_offset=0, peg=1 }
      { x = 192, y =  32, mat = "?floor" }
      { x = 224, y =  32, mat = "?floor" }
      { x = 224, y = 160, mat = "?floor" }
      { t = 32, mat = "?floor" }
    }
    {
      { x = 128, y = 160, mat = "?ceil" }
      { x = 192, y =  32, mat = "?ceil" }
      { x = 224, y =  32, mat = "?upper", y_offset=0, peg=1 }
      { x = 224, y = 160, mat = "?ceil" }
      { b = 128, mat = "?ceil" }
    }

    {
      { x = 224, y = 160, mat = "?step", y_offset=0, peg=1 }
      { x = 224, y =  32, mat = "?floor" }
      { x = 288, y =  32, mat = "?floor" }
      { x = 288, y = 160, mat = "?floor" }
      { t = 40, mat = "?floor" }
    }
    {
      { x = 224, y = 160, mat = "?ceil" }
      { x = 224, y =  32, mat = "?ceil" }
      { x = 288, y =  32, mat = "?upper", y_offset=0, peg=1 }
      { x = 288, y = 160, mat = "?ceil" }
      { b = 136, mat = "?ceil" }
    }

    {
      { x = 288, y = 160, mat = "?step", y_offset=0, peg=1 }
      { x = 288, y =  32, mat = "?floor" }
      { x = 352, y =  32, mat = "?floor" }
      { x = 352, y = 160, mat = "?floor" }
      { t = 48, mat = "?floor" }
    }
    {
      { x = 288, y = 160, mat = "?ceil" }
      { x = 288, y =  32, mat = "?ceil" }
      { x = 352, y =  32, mat = "?upper", y_offset=0, peg=1 }
      { x = 352, y = 160, mat = "?ceil" }
      { b = 144, mat = "?ceil" }
    }

    {
      { x = 352, y = 160, mat = "?step", y_offset=0, peg=1 }
      { x = 352, y =  32, mat = "?floor" }
      { x = 448, y =  32, mat = "?floor" }
      { x = 384, y = 160, mat = "?floor" }
      { t = 56, mat = "?floor" }
    }
    {
      { x = 352, y = 160, mat = "?ceil" }
      { x = 352, y =  32, mat = "?ceil" }
      { x = 448, y =  32, mat = "?upper", y_offset=0, peg=1 }
      { x = 384, y = 160, mat = "?ceil" }
      { b = 152, mat = "?ceil" }
    }

    {
      { x = 384, y = 160, mat = "?step", y_offset=0, peg=1 }
      { x = 448, y =  32, mat = "?floor" }
      { x = 512, y =  64, mat = "?floor" }
      { x = 408, y = 168, mat = "?floor" }
      { t = 64, mat = "?floor" }
    }
    {
      { x = 384, y = 160, mat = "?ceil" }
      { x = 448, y =  32, mat = "?ceil" }
      { x = 512, y =  64, mat = "?upper", y_offset=0, peg=1 }
      { x = 408, y = 168, mat = "?ceil" }
      { b = 160, mat = "?ceil" }
    }

    {
      { x = 408, y = 168, mat = "?step", y_offset=0, peg=1 }
      { x = 512, y =  64, mat = "?floor" }
      { x = 544, y = 128, mat = "?floor" }
      { x = 416, y = 192, mat = "?floor" }
      { t = 72, mat = "?floor" }
    }
    {
      { x = 408, y = 168, mat = "?ceil" }
      { x = 512, y =  64, mat = "?ceil" }
      { x = 544, y = 128, mat = "?upper", y_offset=0, peg=1 }
      { x = 416, y = 192, mat = "?ceil" }
      { b = 168, mat = "?ceil" }
    }

    {
      { x = 416, y = 192, mat = "?step", y_offset=0, peg=1 }
      { x = 544, y = 128, mat = "?floor" }
      { x = 544, y = 192, mat = "?outer" }
      { t = 80, mat = "?floor" }
    }
    {
      { x = 416, y = 192, mat = "?ceil" }
      { x = 544, y = 128, mat = "?ceil" }
      { x = 544, y = 192, mat = "?outer" }
      { b = 176, mat = "?ceil" }
    }
  }

  entities =
  {
    { ent = "?torch_ent", x = 288, y = 152, z = 64 }

    { ent = "light", x = 288, y = 152, z = 96,
      light = 144, style = "?style"
    }
  }
}


PREFAB.HALLWAY_3D_STAIRCASE =
{
  fitted = "xy"

  -- x_ranges = { {24,1}, {144,0}, {24,1} }

  defaults =
  {
    upper  = "?ceil"
    pillar = "?ceil"

    torch_ent = "none"
    style = 1
  }

  brushes =
  {
    -- middle pillar
    {
      { x = 168, y = 200, mat = "?pillar" }
      { x = 168, y = 184, mat = "?pillar" }
      { x = 184, y = 168, mat = "?pillar" }
      { x = 200, y = 168, mat = "?pillar" }
      { x = 216, y = 184, mat = "?pillar" }
      { x = 216, y = 200, mat = "?pillar" }
      { x = 200, y = 216, mat = "?pillar" }
      { x = 184, y = 216, mat = "?pillar" }
    }

    -- left wall
    {
      { x =   0, y =   0, mat = "?wall" }
      { x =  24, y =   0, mat = "?wall" }
      { x =  24, y = 384, mat = "?outer" }
      { x =   0, y = 384, mat = "?outer" }
    }

    -- entrance
    {
      { x =  24, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y = 192, mat = "?wall" }
      { x =  24, y = 192, mat = "?wall" }
      { t =  8, mat = "?floor" }
    }

    {
      { x =  24, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y =  24, mat = "?wall" }
      { x =  24, y =  24, mat = "?wall" }
      { b = 132, mat = "?ceil" }
    }

    -- exit
    {
      { x =  24, y = 192, mat = "?wall" }
      { x = 192, y = 192, mat = "?wall" }
      { x = 192, y = 360, mat = "?outer" }
      { x =  24, y = 360, mat = "?wall" }
      { b = 172, mat = "?ceil" }
      { t = 204, mat = "?floor" }
    }

    {
      { x =  24, y = 360, mat = "?wall" }
      { x = 192, y = 360, mat = "?wall" }
      { x = 192, y = 384, mat = "?outer" }
      { x =  24, y = 384, mat = "?wall" }
      { t = 204, mat = "?floor" }
    }

    {
      { x =  24, y = 192, mat = "?wall" }
      { x = 192, y = 192, mat = "?wall" }
      { x = 192, y = 384, mat = "?outer" }
      { x =  24, y = 384, mat = "?wall" }
      { b = 328, mat = "?ceil" }
    }

    -- top left quadrant

    {
      { x =  24, y = 192, mat = "?wall" }
      { x =  32, y = 256, mat = "?wall" }
      { x =  24, y = 256, mat = "?wall" }
      { t = 176 }
    }

    {
      { x =  24, y = 256, mat = "?wall" }
      { x =  32, y = 256, mat = "?wall" }
      { x =  72, y = 312, mat = "?wall" }
      { x =  24, y = 360, mat = "?wall" }
      { t = 176 }
    }

    {
      { x =  24, y = 360, mat = "?wall" }
      { x =  72, y = 312, mat = "?wall" }
      { x = 128, y = 352, mat = "?wall" }
      { x = 128, y = 360, mat = "?wall" }
      { t = 176 }
    }

    {
      { x = 128, y = 360, mat = "?wall" }
      { x = 128, y = 352, mat = "?wall" }
      { x = 192, y = 360, mat = "?wall" }
      { t = 176 }
    }

    {
      { x =  24, y = 192, mat = "?wall" }
      { x = 168, y = 192, mat = "?wall" }
      { x = 168, y = 200, mat = "?wall" }
      { x =  32, y = 256, mat = "?wall" }
      { t = 12, mat = "?floor" }
    }

    {
      { x =  32, y = 256, mat = "?wall" }
      { x = 168, y = 200, mat = "?wall" }
      { x = 176, y = 208, mat = "?wall" }
      { x =  72, y = 312, mat = "?wall" }
      { t = 24, mat = "?floor" }
    }

    {
      { x =  72, y = 312, mat = "?wall" }
      { x = 176, y = 208, mat = "?wall" }
      { x = 184, y = 216, mat = "?wall" }
      { x = 128, y = 352, mat = "?wall" }
      { t = 36, mat = "?floor" }
    }

    {
      { x = 128, y = 352, mat = "?wall" }
      { x = 184, y = 216, mat = "?wall" }
      { x = 192, y = 216, mat = "?wall" }
      { x = 192, y = 360, mat = "?wall" }
      { t = 48, mat = "?floor" }
    }

    -- bottom left quadrant

    {
      { x = 128, y =  32, mat = "?wall" }
      { x = 128, y =  24, mat = "?wall" }
      { x = 192, y =  24, mat = "?wall" }
      { b = 124, mat = "?ceil" }
    }

    {
      { x =  24, y =  24, mat = "?wall" }
      { x = 128, y =  24, mat = "?wall" }
      { x = 128, y =  32, mat = "?wall" }
      { x =  72, y =  72, mat = "?wall" }
      { b = 136, mat = "?ceil" }
    }

    {
      { x =  24, y = 128, mat = "?wall" }
      { x =  24, y =  24, mat = "?wall" }
      { x =  72, y =  72, mat = "?wall" }
      { x =  32, y = 128, mat = "?wall" }
      { b = 148, mat = "?ceil" }
    }

    {
      { x =  24, y = 192, mat = "?wall" }
      { x =  24, y = 128, mat = "?wall" }
      { x =  32, y = 128, mat = "?wall" }
      { b = 160, mat = "?ceil" }
    }

    {
      { x = 128, y =  32, mat = "?wall" }
      { x = 192, y =  24, mat = "?wall" }
      { x = 192, y = 168, mat = "?wall" }
      { x = 184, y = 168, mat = "?wall" }
      { b = 124, mat = "?ceil"  }
      { t = 156, mat = "?floor" }
    }
    {
      { x = 128, y =  32, mat = "?wall" }
      { x = 192, y =  24, mat = "?wall" }
      { x = 192, y = 168, mat = "?wall" }
      { x = 184, y = 168, mat = "?wall" }
      { b = 284, mat = "?ceil" }
    }

    {
      { x =  72, y =  72, mat = "?wall" }
      { x = 128, y =  32, mat = "?wall" }
      { x = 184, y = 168, mat = "?wall" }
      { x = 176, y = 176, mat = "?wall" }
      { b = 136, mat = "?ceil"  }
      { t = 168, mat = "?floor" }
    }
    {
      { x =  72, y =  72, mat = "?wall" }
      { x = 128, y =  32, mat = "?wall" }
      { x = 184, y = 168, mat = "?wall" }
      { x = 176, y = 176, mat = "?wall" }
      { b = 296, mat = "?ceil"  }
    }

    {
      { x =  32, y = 128, mat = "?wall" }
      { x =  72, y =  72, mat = "?wall" }
      { x = 176, y = 176, mat = "?wall" }
      { x = 168, y = 184, mat = "?wall" }
      { b = 148, mat = "?ceil"  }
      { t = 180, mat = "?floor" }
    }
    {
      { x =  32, y = 128, mat = "?wall" }
      { x =  72, y =  72, mat = "?wall" }
      { x = 176, y = 176, mat = "?wall" }
      { x = 168, y = 184, mat = "?wall" }
      { b = 308, mat = "?ceil"  }
    }

    {
      { x =  24, y = 192, mat = "?wall" }
      { x =  32, y = 128, mat = "?wall" }
      { x = 168, y = 184, mat = "?wall" }
      { x = 168, y = 192, mat = "?wall" }
      { b = 160, mat = "?ceil"  }
      { t = 192, mat = "?floor" }
    }
    {
      { x =  24, y = 192, mat = "?wall" }
      { x =  32, y = 128, mat = "?wall" }
      { x = 168, y = 184, mat = "?wall" }
      { x = 168, y = 192, mat = "?wall" }
      { b = 320, mat = "?ceil"  }
    }

    -- top right quadrant

    {
      { x = 192, y = 360, mat = "?wall" }
      { x = 256, y = 352, mat = "?wall" }
      { x = 256, y = 384, mat = "?outer" }
      { x = 192, y = 384, mat = "?wall" }
    }

    {
      { x = 256, y = 352, mat = "?wall" }
      { x = 312, y = 312, mat = "?wall" }
      { x = 384, y = 384, mat = "?outer" }
      { x = 256, y = 384, mat = "?wall" }
    }

    {
      { x = 312, y = 312, mat = "?wall" }
      { x = 352, y = 256, mat = "?wall" }
      { x = 384, y = 256, mat = "?outer" }
      { x = 384, y = 384, mat = "?wall" }
    }

    {
      { x = 352, y = 256, mat = "?wall" }
      { x = 360, y = 192, mat = "?wall" }
      { x = 384, y = 192, mat = "?outer" }
      { x = 384, y = 256, mat = "?wall" }
    }

    {
      { x = 192, y = 360, mat = "?wall" }
      { x = 192, y = 216, mat = "?wall" }
      { x = 200, y = 216, mat = "?wall" }
      { x = 256, y = 352, mat = "?wall" }
      { t = 60, mat = "?floor" }
    }
    {
      { x = 192, y = 360, mat = "?wall" }
      { x = 192, y = 216, mat = "?wall" }
      { x = 200, y = 216, mat = "?wall" }
      { x = 256, y = 352, mat = "?wall" }
      { b = 188, mat = "?ceil" }
    }

    {
      { x = 256, y = 352, mat = "?wall" }
      { x = 200, y = 216, mat = "?wall" }
      { x = 208, y = 208, mat = "?wall" }
      { x = 312, y = 312, mat = "?wall" }
      { t = 72, mat = "?floor" }
    }
    {
      { x = 256, y = 352, mat = "?wall" }
      { x = 200, y = 216, mat = "?wall" }
      { x = 208, y = 208, mat = "?wall" }
      { x = 312, y = 312, mat = "?wall" }
      { b = 200, mat = "?ceil" }
    }

    {
      { x = 312, y = 312, mat = "?wall" }
      { x = 208, y = 208, mat = "?wall" }
      { x = 216, y = 200, mat = "?wall" }
      { x = 352, y = 256, mat = "?wall" }
      { t = 84, mat = "?floor" }
    }
    {
      { x = 312, y = 312, mat = "?wall" }
      { x = 208, y = 208, mat = "?wall" }
      { x = 216, y = 200, mat = "?wall" }
      { x = 352, y = 256, mat = "?wall" }
      { b = 212, mat = "?ceil" }
    }

    {
      { x = 352, y = 256, mat = "?wall" }
      { x = 216, y = 200, mat = "?wall" }
      { x = 216, y = 192, mat = "?wall" }
      { x = 360, y = 192, mat = "?wall" }
      { t = 96, mat = "?floor" }
    }
    {
      { x = 352, y = 256, mat = "?wall" }
      { x = 216, y = 200, mat = "?wall" }
      { x = 216, y = 192, mat = "?wall" }
      { x = 360, y = 192, mat = "?wall" }
      { b = 224, mat = "?ceil" }
    }

    -- bottom right quadrant

    {
      { x = 360, y = 192, mat = "?wall" }
      { x = 352, y = 128, mat = "?wall" }
      { x = 384, y = 128, mat = "?outer" }
      { x = 384, y = 192, mat = "?wall" }
    }

    {
      { x = 352, y = 128, mat = "?wall" }
      { x = 312, y =  72, mat = "?wall" }
      { x = 384, y =   0, mat = "?outer" }
      { x = 384, y = 128, mat = "?wall" }
    }

    {
      { x = 312, y =  72, mat = "?wall" }
      { x = 256, y =  32, mat = "?wall" }
      { x = 256, y =   0, mat = "?wall" }
      { x = 384, y =   0, mat = "?wall" }
    }

    {
      { x = 256, y =  32, mat = "?wall" }
      { x = 192, y =  24, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 256, y =   0, mat = "?wall" }
    }

    {
      { x = 216, y = 192, mat = "?wall" }
      { x = 216, y = 184, mat = "?wall" }
      { x = 352, y = 128, mat = "?wall" }
      { x = 360, y = 192, mat = "?wall" }
      { t = 108, mat = "?floor" }
    }
    {
      { x = 216, y = 192, mat = "?wall" }
      { x = 216, y = 184, mat = "?wall" }
      { x = 352, y = 128, mat = "?wall" }
      { x = 360, y = 192, mat = "?wall" }
      { b = 236, mat = "?ceil" }
    }
    
    {
      { x = 216, y = 184, mat = "?wall" }
      { x = 208, y = 176, mat = "?wall" }
      { x = 312, y =  72, mat = "?wall" }
      { x = 352, y = 128, mat = "?wall" }
      { t = 120, mat = "?floor" }
    }
    {
      { x = 216, y = 184, mat = "?wall" }
      { x = 208, y = 176, mat = "?wall" }
      { x = 312, y =  72, mat = "?wall" }
      { x = 352, y = 128, mat = "?wall" }
      { b = 248, mat = "?ceil" }
    }
    
    {
      { x = 208, y = 176, mat = "?wall" }
      { x = 200, y = 168, mat = "?wall" }
      { x = 256, y =  32, mat = "?wall" }
      { x = 312, y =  72, mat = "?wall" }
      { t = 132, mat = "?floor" }
    }
    {
      { x = 208, y = 176, mat = "?wall" }
      { x = 200, y = 168, mat = "?wall" }
      { x = 256, y =  32, mat = "?wall" }
      { x = 312, y =  72, mat = "?wall" }
      { b = 260, mat = "?ceil" }
    }
    
    {
      { x = 200, y = 168, mat = "?wall" }
      { x = 192, y = 168, mat = "?wall" }
      { x = 192, y =  24, mat = "?wall" }
      { x = 256, y =  32, mat = "?wall" }
      { t = 144, mat = "?floor" }
    }
    {
      { x = 200, y = 168, mat = "?wall" }
      { x = 192, y = 168, mat = "?wall" }
      { x = 192, y =  24, mat = "?wall" }
      { x = 256, y =  32, mat = "?wall" }
      { b = 272, mat = "?ceil" }
    }
  }

  entities =
  {
    { ent = "?torch_ent", x = 40, y = 192, z = 48 }

    { ent = "light", x = 56, y = 192, z = 80,
      light = 160, style = "?style"
    }

    { ent = "?torch_ent", x = 344, y = 192, z = 144 }

    { ent = "light", x = 328, y = 192, z = 172,
      light = 160, style = "?style"
    }

    { ent = "?torch_ent", x = 40, y = 192, z = 236 }

    { ent = "light", x = 56, y = 192, z = 268,
      light = 160, style = "?style"
    }
  }
}


PREFAB.HALLWAY_FORK =
{
  fitted = "xy"

  defaults =
  {
    upper = "?ceil"
  }

  brushes =
  {
    -- top V-shaped wall
    {
      { x = 176, y = 192, mat = "?wall" }
      { x = 176, y = 176, mat = "?wall" }
      { x = 288, y = 120, mat = "?wall" }
      { x = 400, y = 176, mat = "?wall" }
      { x = 400, y = 192, mat = "?outer" }
    }

    -- left wall
    {
      { x =   0, y =   0, mat = "?wall" }
      { x =  32, y =   0, mat = "?wall" }
      { x =  32, y = 192, mat = "?outer" }
      { x =   0, y = 192, mat = "?outer" }
    }

    {
      { x =  32, y =   0, mat = "?wall" }
      { x = 208, y =   0, mat = "?wall" }
      { x = 208, y =  16, mat = "?wall" }
      { x =  32, y = 104, mat = "?wall" }
    }

    -- right wall
    {
      { x = 544, y =   0, mat = "?wall" }
      { x = 576, y =   0, mat = "?outer" }
      { x = 576, y = 192, mat = "?outer" }
      { x = 544, y = 192, mat = "?wall" }
    }

    {
      { x = 368, y =   0, mat = "?wall" }
      { x = 544, y =   0, mat = "?wall" }
      { x = 544, y = 104, mat = "?wall" }
      { x = 368, y =  16, mat = "?wall" }
    }

    -- entrance
    {
      { x = 208, y =  16, mat = "?wall" }
      { x = 208, y =   0, mat = "?step", y_offset=0, peg=1 }
      { x = 368, y =   0, mat = "?wall" }
      { x = 368, y =  16, mat = "?wall" }
      { x = 288, y = 120, mat = "?wall" }
      { t = 12, mat = "?floor" }
    }
    {
      { x = 208, y =  16, mat = "?wall" }
      { x = 208, y =   0, mat = "?wall" }
      { x = 368, y =   0, mat = "?wall" }
      { x = 368, y =  16, mat = "?upper", y_offset=0, peg=1 }
      { x = 288, y = 120, mat = "?upper", y_offset=0, peg=1 }
      { b = 140, mat = "?ceil" }
    }

    -- first step
    {
      { x = 180, y =  30, mat = "?wall" }
      { x = 208, y =  16, mat = "?step", y_offset=0, peg=1 }
      { x = 288, y = 120, mat = "?wall" }
      { x = 260, y = 134, mat = "?wall" }
      { t = 24, mat = "?floor" }
    }
    {
      { x = 180, y =  30, mat = "?wall" }
      { x = 208, y =  16, mat = "?wall" }
      { x = 288, y = 120, mat = "?wall" }
      { x = 260, y = 134, mat = "?upper", y_offset=0, peg=1 }
      { b = 152, mat = "?ceil" }
    }

    {
      { x = 288, y = 120, mat = "?step", y_offset=0, peg=1 }
      { x = 368, y =  16, mat = "?wall" }
      { x = 396, y =  30, mat = "?wall" }
      { x = 316, y = 134, mat = "?wall" }
      { t = 24, mat = "?floor" }
    }
    {
      { x = 288, y = 120, mat = "?wall" }
      { x = 368, y =  16, mat = "?wall" }
      { x = 396, y =  30, mat = "?upper", y_offset=0, peg=1 }
      { x = 316, y = 134, mat = "?wall" }
      { b = 152, mat = "?ceil" }
    }

    -- second step
    {
      { x = 152, y =  44, mat = "?wall" }
      { x = 180, y =  30, mat = "?step", y_offset=0, peg=1 }
      { x = 260, y = 134, mat = "?wall" }
      { x = 232, y = 148, mat = "?wall" }
      { t = 36, mat = "?floor" }
    }
    {
      { x = 152, y =  44, mat = "?wall" }
      { x = 180, y =  30, mat = "?wall" }
      { x = 260, y = 134, mat = "?wall" }
      { x = 232, y = 148, mat = "?upper", y_offset=0, peg=1 }
      { b = 164, mat = "?ceil" }
    }

    {
      { x = 316, y = 134, mat = "?step", y_offset=0, peg=1 }
      { x = 396, y =  30, mat = "?wall" }
      { x = 424, y =  44, mat = "?wall" }
      { x = 344, y = 148, mat = "?wall" }
      { t = 36, mat = "?floor" }
    }
    {
      { x = 316, y = 134, mat = "?wall" }
      { x = 396, y =  30, mat = "?wall" }
      { x = 424, y =  44, mat = "?upper", y_offset=0, peg=1 }
      { x = 344, y = 148, mat = "?wall" }
      { b = 164, mat = "?ceil" }
    }

    -- third step
    {
      { x = 124, y =  58, mat = "?wall" }
      { x = 152, y =  44, mat = "?step", y_offset=0, peg=1 }
      { x = 232, y = 148, mat = "?wall" }
      { x = 204, y = 162, mat = "?wall" }
      { t = 48, mat = "?floor" }
    }
    {
      { x = 124, y =  58, mat = "?wall" }
      { x = 152, y =  44, mat = "?wall" }
      { x = 232, y = 148, mat = "?wall" }
      { x = 204, y = 162, mat = "?upper", y_offset=0, peg=1 }
      { b = 176, mat = "?ceil" }
    }

    {
      { x = 344, y = 148, mat = "?step", y_offset=0, peg=1 }
      { x = 424, y =  44, mat = "?wall" }
      { x = 452, y =  58, mat = "?wall" }
      { x = 372, y = 162, mat = "?wall" }
      { t = 48, mat = "?floor" }
    }
    {
      { x = 344, y = 148, mat = "?wall" }
      { x = 424, y =  44, mat = "?wall" }
      { x = 452, y =  58, mat = "?upper", y_offset=0, peg=1 }
      { x = 372, y = 162, mat = "?wall" }
      { b = 176, mat = "?ceil" }
    }

    -- fourth step
    {
      { x =  96, y =  72, mat = "?wall" }
      { x = 124, y =  58, mat = "?step", y_offset=0, peg=1 }
      { x = 204, y = 162, mat = "?wall" }
      { x = 176, y = 176, mat = "?wall" }
      { t = 60, mat = "?floor" }
    }
    {
      { x =  96, y =  72, mat = "?wall" }
      { x = 124, y =  58, mat = "?wall" }
      { x = 204, y = 162, mat = "?wall" }
      { x = 176, y = 176, mat = "?upper", y_offset=0, peg=1 }
      { b = 188, mat = "?ceil" }
    }

    {
      { x = 372, y = 162, mat = "?step", y_offset=0, peg=1 }
      { x = 452, y =  58, mat = "?wall" }
      { x = 480, y =  72, mat = "?wall" }
      { x = 400, y = 176, mat = "?wall" }
      { t = 60, mat = "?floor" }
    }
    {
      { x = 372, y = 162, mat = "?wall" }
      { x = 452, y =  58, mat = "?wall" }
      { x = 480, y =  72, mat = "?upper", y_offset=0, peg=1 }
      { x = 400, y = 176, mat = "?wall" }
      { b = 188, mat = "?ceil" }
    }

    -- exit areas
    {
      { x =  32, y = 192, mat = "?wall" }
      { x =  32, y = 104, mat = "?wall" }
      { x =  96, y =  72, mat = "?step", y_offset=0, peg=1 }
      { x = 176, y = 176, mat = "?wall" }
      { x = 176, y = 192, mat = "?outer" }
      { t = 72, mat = "?floor" }
    }
    {
      { x =  32, y = 192, mat = "?wall" }
      { x =  32, y = 104, mat = "?wall" }
      { x =  96, y =  72, mat = "?wall" }
      { x = 176, y = 176, mat = "?wall" }
      { x = 176, y = 192, mat = "?outer" }
      { b = 200, mat = "?ceil" }
    }

    {
      { x = 400, y = 192, mat = "?wall" }
      { x = 400, y = 176, mat = "?step", y_offset=0, peg=1 }
      { x = 480, y =  72, mat = "?wall" }
      { x = 544, y = 104, mat = "?wall" }
      { x = 544, y = 192, mat = "?outer" }
      { t = 72, mat = "?floor" }
    }
    {
      { x = 400, y = 192, mat = "?wall" }
      { x = 400, y = 176, mat = "?wall" }
      { x = 480, y =  72, mat = "?wall" }
      { x = 544, y = 104, mat = "?wall" }
      { x = 544, y = 192, mat = "?outer" }
      { b = 200, mat = "?ceil" }
    }
  }
}


----------------------------------------------------------------


PREFAB.HALL_BASIC_I =
{
  fitted = "xy"

  brushes =
  {
    -- left wall
    {
      { x =   0, y =   0, mat = "?wall" }
      { x =  16, y =   0, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { x =   0, y = 192, mat = "?outer" }
    }

    -- right wall
    {
      { x = 176, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y = 192, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
    }

    -- floor
    {
      { x =  16, y =   0, mat = "?wall" }
      { x = 176, y =   0, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }

    -- ceiling
    {
      { x =  16, y =   0, mat = "?wall" }
      { x = 176, y =   0, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { b = 128, mat = "?ceil" }
    }
  }
}


PREFAB.HALL_BASIC_C =
{
  fitted = "xy"

  defaults =
  {
    torch_ent = "none"
    style = 1
  }

  brushes =
  {
    -- west wall
    {
      { x =   0, y =   0, mat = "?wall" }
      { x =  16, y =   0, mat = "?wall" }
      { x =  16, y = 176, mat = "?wall" }
      { x =   0, y = 192, mat = "?outer" }
    }

    -- north wall
    {
      { x =   0, y = 192, mat = "?wall" }
      { x =  16, y = 176, mat = "?wall" }
      { x = 192, y = 176, mat = "?wall" }
      { x = 192, y = 192, mat = "?outer" }
    }

    -- little SE corner piece
    {
      { x = 176, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y =  16, mat = "?wall" }
      { x = 176, y =  16, mat = "?wall" }
    }

    -- floor
    {
      { x =  16, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y = 176, mat = "?wall" }
      { x =  16, y = 176, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }

    -- ceiling
    {
      { x =  16, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y = 176, mat = "?wall" }
      { x =  16, y = 176, mat = "?wall" }
      { b = 128, mat = "?ceil" }
    }
  }

  entities =
  {
    { ent = "?torch_ent", x = 24, y = 168, z = 48 }

    { ent = "light", x = 48, y = 144, z = 64,
      light = 200, style = "?style"
    }
  }
}


PREFAB.HALL_BASIC_T =
{
  fitted = "xy"

  brushes =
  {
    -- north wall
    {
      { x =   0, y = 176, mat = "?wall" }
      { x = 192, y = 176, mat = "?wall" }
      { x = 192, y = 192, mat = "?outer" }
      { x =   0, y = 192, mat = "?wall" }
    }

    -- corner pieces
    {
      { x =   0, y =   0, mat = "?wall" }
      { x =  16, y =   0, mat = "?wall" }
      { x =  16, y =  16, mat = "?wall" }
      { x =   0, y =  16, mat = "?wall" }
    }

    {
      { x = 176, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y =  16, mat = "?wall" }
      { x = 176, y =  16, mat = "?wall" }
    }

    -- floor
    {
      { x =   0, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y = 176, mat = "?wall" }
      { x =   0, y = 176, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }

    -- ceiling
    {
      { x =   0, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y = 176, mat = "?wall" }
      { x =   0, y = 176, mat = "?wall" }
      { b = 128, mat = "?ceil" }
    }
  }
}


PREFAB.HALL_BASIC_P =
{
  fitted = "xy"

  brushes =
  {
    -- bottom corner pieces
    {
      { x =   0, y =   0, mat = "?wall" }
      { x =  16, y =   0, mat = "?wall" }
      { x =  16, y =  16, mat = "?wall" }
      { x =   0, y =  16, mat = "?wall" }
    }

    {
      { x = 176, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y =  16, mat = "?wall" }
      { x = 176, y =  16, mat = "?wall" }
    }

    -- top corner pieces
    {
      { x =   0, y = 176, mat = "?wall" }
      { x =  16, y = 176, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { x =   0, y = 192, mat = "?wall" }
    }

    {
      { x = 176, y = 176, mat = "?wall" }
      { x = 192, y = 176, mat = "?wall" }
      { x = 192, y = 192, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
    }

    -- floor
    {
      { x =   0, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y = 192, mat = "?wall" }
      { x =   0, y = 192, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }

    -- ceiling
    {
      { x =   0, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y = 192, mat = "?wall" }
      { x =   0, y = 192, mat = "?wall" }
      { b = 128, mat = "?ceil" }
    }
  }
}


PREFAB.HALL_BASIC_I_STAIR =
{
  fitted = "xy"

  brushes =
  {
    -- left wall
    {
      { x =   0, y =   0, mat = "?wall" }
      { x =  16, y =   0, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { x =   0, y = 192, mat = "?outer" }
    }

    -- right wall
    {
      { x = 176, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y = 192, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
    }

    -- step 1
    {
      { x =  16, y =   0, mat = "?wall" }
      { x = 176, y =   0, mat = "?wall" }
      { x = 176, y =  32, mat = "?wall" }
      { x =  16, y =  32, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }

    {
      { x =  16, y =   0, mat = "?wall" }
      { x = 176, y =   0, mat = "?wall" }
      { x = 176, y =  32, mat = "?wall" }
      { x =  16, y =  32, mat = "?wall" }
      { b = 128, mat = "?ceil" }
    }

    -- step 2
    {
      { x =  16, y =  32, mat = "?wall" }
      { x = 176, y =  32, mat = "?wall" }
      { x = 176, y =  64, mat = "?wall" }
      { x =  16, y =  64, mat = "?wall" }
      { t = 12, mat = "?floor" }
    }

    {
      { x =  16, y =  32, mat = "?wall" }
      { x = 176, y =  32, mat = "?wall" }
      { x = 176, y =  64, mat = "?wall" }
      { x =  16, y =  64, mat = "?wall" }
      { b = 140, mat = "?ceil" }
    }

    -- step 3
    {
      { x =  16, y =  64, mat = "?wall" }
      { x = 176, y =  64, mat = "?wall" }
      { x = 176, y =  96, mat = "?wall" }
      { x =  16, y =  96, mat = "?wall" }
      { t = 24, mat = "?floor" }
    }

    {
      { x =  16, y =  64, mat = "?wall" }
      { x = 176, y =  64, mat = "?wall" }
      { x = 176, y =  96, mat = "?wall" }
      { x =  16, y =  96, mat = "?wall" }
      { b = 152, mat = "?ceil" }
    }

    -- step 4
    {
      { x =  16, y =  96, mat = "?wall" }
      { x = 176, y =  96, mat = "?wall" }
      { x = 176, y = 128, mat = "?wall" }
      { x =  16, y = 128, mat = "?wall" }
      { t = 36, mat = "?floor" }
    }

    {
      { x =  16, y =  96, mat = "?wall" }
      { x = 176, y =  96, mat = "?wall" }
      { x = 176, y = 128, mat = "?wall" }
      { x =  16, y = 128, mat = "?wall" }
      { b = 164, mat = "?ceil" }
    }

    -- step 5
    {
      { x =  16, y = 128, mat = "?wall" }
      { x = 176, y = 128, mat = "?wall" }
      { x = 176, y = 160, mat = "?wall" }
      { x =  16, y = 160, mat = "?wall" }
      { t = 48, mat = "?floor" }
    }

    {
      { x =  16, y = 128, mat = "?wall" }
      { x = 176, y = 128, mat = "?wall" }
      { x = 176, y = 160, mat = "?wall" }
      { x =  16, y = 160, mat = "?wall" }
      { b = 176, mat = "?ceil" }
    }

    -- step 6
    {
      { x =  16, y = 160, mat = "?wall" }
      { x = 176, y = 160, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { t = 60, mat = "?floor" }
    }

    {
      { x =  16, y = 160, mat = "?wall" }
      { x = 176, y = 160, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { b = 188, mat = "?ceil" }
    }
  }
}


PREFAB.HALL_BASIC_I_WINDOW =
{
  fitted = "xy"

  brushes =
  {
    -- left side window
    {
      { x =   0, y =   0, mat = "?wall" }
      { x =  16, y =   0, mat = "?wall" }
      { x =  16, y =  32, mat = "?wall" }
      { x =   0, y =  32, mat = "?outer" }
    }

    {
      { x =   0, y =  32, mat = "?wall" }
      { x =  16, y =  32, mat = "?wall" }
      { x =  16, y = 160, mat = "?wall" }
      { x =   0, y = 160, mat = "?outer" }
      { t = 32 }
    }

    {
      { x =   0, y =  32, mat = "?wall" }
      { x =  16, y =  32, mat = "?wall" }
      { x =  16, y = 160, mat = "?wall" }
      { x =   0, y = 160, mat = "?outer" }
      { b = 96 }
    }

    {
      { x =   0, y = 160, mat = "?wall" }
      { x =  16, y = 160, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { x =   0, y = 192, mat = "?outer" }
    }

    -- player clip (cannot go through the gap)
    {
      { m = "clip" }
      { x =   0, y =  32 }
      { x =  16, y =  32 }
      { x =  16, y = 160 }
      { x =   0, y = 160 }
    }

    -- right wall
    {
      { x = 176, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y = 192, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
    }

    -- floor
    {
      { x =  16, y =   0, mat = "?wall" }
      { x = 176, y =   0, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }

    -- ceiling
    {
      { x =  16, y =   0, mat = "?wall" }
      { x = 176, y =   0, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { b = 128, mat = "?ceil" }
    }
  }
}


----------------------------------------------------------------


PREFAB.JUNCTION_TEST =
{
  fitted = "xy"

  -- these ranges allow the prefab to expand from 3 seeds to 4 seeds
  -- and still mesh up properly with the nearby hallway pieces.
  x_ranges = { {192,0}, {192,1}, {192,0} }
  y_ranges = { {192,0}, {192,1}, {192,0} }

  brushes =
  {
    -- south west corner
    {
      { x =   0, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y =  64, mat = "?wall" }
      { x =  64, y = 192, mat = "?wall" }
      { x =   0, y = 192, mat = "?wall" }
    }

    -- south east corner
    {
      { x = 576, y =   0, mat = "?wall" }
      { x = 576, y = 192, mat = "?wall" }
      { x = 502, y = 192, mat = "?wall" }
      { x = 384, y =  64, mat = "?wall" }
      { x = 384, y =   0, mat = "?wall" }
    }

    -- north west corner
    {
      { x =   0, y = 576, mat = "?wall" }
      { x =   0, y = 384, mat = "?wall" }
      { x =  64, y = 384, mat = "?wall" }
      { x = 192, y = 502, mat = "?wall" }
      { x = 192, y = 576, mat = "?wall" }
    }

    -- north east corner
    {
      { x = 576, y = 576, mat = "?wall" }
      { x = 384, y = 576, mat = "?wall" }
      { x = 384, y = 502, mat = "?wall" }
      { x = 502, y = 384, mat = "?wall" }
      { x = 576, y = 384, mat = "?wall" }
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
      { x =   0, y =   0, mat = "?wall" }
      { x = 576, y =   0, mat = "?wall" }
      { x = 576, y = 576, mat = "?wall" }
      { x =   0, y = 576, mat = "?wall" }
      { b = 256, mat = "?ceil" }
    }
  }
}

