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
--     C : corner, travel S and W, walls on N and E sides
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
      { x =   0, y =   0, mat = "?outer" }
      { x =  16, y =   0, mat = "?wall", y_offset=0 }
      { x =  16, y = 192, mat = "?outer" }
      { x =   0, y = 192, mat = "?outer" }
    }

    -- right wall
    {
      { x = 176, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y = 192, mat = "?outer" }
      { x = 176, y = 192, mat = "?wall", y_offset=0 }
    }

    -- floor
    {
      { x =  16, y =   0, mat = "?outer" }
      { x = 176, y =   0, mat = "?outer" }
      { x = 176, y = 192, mat = "?outer" }
      { x =  16, y = 192, mat = "?outer" }
      { t = 0, mat = "?floor" }
    }

    -- ceiling
    {
      { x =  16, y =   0, mat = "?outer" }
      { x = 176, y =   0, mat = "?outer" }
      { x = 176, y = 192, mat = "?outer" }
      { x =  16, y = 192, mat = "?outer" }
      { b = 128, mat = "?ceil" }
    }

    -- da monsters
    {
      { m = "spot" }
      { x =  24, y =  24 }
      { x = 168, y =  24 }
      { x = 168, y = 168 }
      { x =  24, y = 168 }
      { b = 0 }
      { t = 124 }
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
    -- east wall
    {
      { x = 176, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y = 192, mat = "?outer" }
      { x = 176, y = 176, mat = "?wall", y_offset=0 }
    }

    -- north wall
    {
      { x =   0, y = 176, mat = "?wall", y_offset=0 }
      { x = 176, y = 176, mat = "?outer" }
      { x = 192, y = 192, mat = "?outer" }
      { x =   0, y = 192, mat = "?outer" }
    }

    -- little SW corner piece
    {
      { x =  0, y =   0, mat = "?outer" }
      { x = 16, y =   0, mat = "?wall", y_offset=0 }
      { x = 16, y =  16, mat = "?wall", y_offset=0 }
      { x =  0, y =  16, mat = "?outer" }
    }

    -- floor
    {
      { x =   0, y =   0, mat = "?outer" }
      { x = 176, y =   0, mat = "?outer" }
      { x = 176, y = 176, mat = "?outer" }
      { x =   0, y = 176, mat = "?outer" }
      { t = 0, mat = "?floor" }
    }

    -- ceiling
    {
      { x =   0, y =   0, mat = "?outer" }
      { x = 176, y =   0, mat = "?outer" }
      { x = 176, y = 176, mat = "?outer" }
      { x =   0, y = 176, mat = "?outer" }
      { b = 128, mat = "?ceil" }
    }

    -- monster spot
    {
      { m = "spot" }
      { x =   8, y =   8 }
      { x = 168, y =   8 }
      { x = 168, y = 168 }
      { x =   8, y = 168 }
      { b = 0 }
      { t = 124 }
    }
  }

  entities =
  {
    { ent = "?torch_ent", x = 168, y = 168, z = 48 }

    { ent = "light", x = 144, y = 144, z = 64,
      light = 150, style = "?style"
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
      { x =   0, y = 176, mat = "?wall", y_offset=0 }
      { x = 192, y = 176, mat = "?outer" }
      { x = 192, y = 192, mat = "?outer" }
      { x =   0, y = 192, mat = "?outer" }
    }

    -- corner pieces
    {
      { x =   0, y =   0, mat = "?outer" }
      { x =  16, y =   0, mat = "?wall", y_offset=0 }
      { x =  16, y =  16, mat = "?wall", y_offset=0 }
      { x =   0, y =  16, mat = "?outer" }
    }

    {
      { x = 176, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y =  16, mat = "?wall", y_offset=0 }
      { x = 176, y =  16, mat = "?wall", y_offset=0 }
    }

    -- floor
    {
      { x =   0, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y = 176, mat = "?outer" }
      { x =   0, y = 176, mat = "?outer" }
      { t = 0, mat = "?floor" }
    }

    -- ceiling
    {
      { x =   0, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y = 176, mat = "?outer" }
      { x =   0, y = 176, mat = "?outer" }
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
      { x =   0, y =   0, mat = "?wall", y_offset=0 }
      { x =  16, y =   0, mat = "?wall", y_offset=0 }
      { x =  16, y =  16, mat = "?wall", y_offset=0 }
      { x =   0, y =  16, mat = "?wall", y_offset=0 }
    }

    {
      { x = 176, y =   0, mat = "?wall", y_offset=0 }
      { x = 192, y =   0, mat = "?wall", y_offset=0 }
      { x = 192, y =  16, mat = "?wall", y_offset=0 }
      { x = 176, y =  16, mat = "?wall", y_offset=0 }
    }

    -- top corner pieces
    {
      { x =   0, y = 176, mat = "?wall", y_offset=0 }
      { x =  16, y = 176, mat = "?wall", y_offset=0 }
      { x =  16, y = 192, mat = "?wall", y_offset=0 }
      { x =   0, y = 192, mat = "?wall", y_offset=0 }
    }

    {
      { x = 176, y = 176, mat = "?wall", y_offset=0 }
      { x = 192, y = 176, mat = "?wall", y_offset=0 }
      { x = 192, y = 192, mat = "?wall", y_offset=0 }
      { x = 176, y = 192, mat = "?wall", y_offset=0 }
    }

    -- floor
    {
      { x =   0, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y = 192, mat = "?outer" }
      { x =   0, y = 192, mat = "?outer" }
      { t = 0, mat = "?floor" }
    }

    -- ceiling
    {
      { x =   0, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y = 192, mat = "?outer" }
      { x =   0, y = 192, mat = "?outer" }
      { b = 128, mat = "?ceil" }
    }
  }
}


PREFAB.HALL_BASIC_I_STAIR =
{
  fitted = "xy"

  z_ranges = { {60,0,"?stair_h"}, {128,0} }
  y_ranges = { {16,0}, {160,1}, {16,0} }

  defaults =
  {
    step = "?floor"
    support = "?wall"
    support_ox = 0
  }

  brushes =
  {
    -- left wall
    {
      { x =   0, y =  16, mat = "?wall" }
      { x =  16, y =  16, mat = "?wall" }
      { x =  16, y = 176, mat = "?wall" }
      { x =   0, y = 176, mat = "?outer" }
    }

    {
      { x =   0, y =   0, mat = "?outer" }
      { x =  16, y =   0, mat = "?support", x_offset="?support_ox", y_offset=0 }
      { x =  16, y =  16, mat = "?outer" }
      { x =   0, y =  16, mat = "?outer" }
    }
    {
      { x =   0, y = 176, mat = "?outer" }
      { x =  16, y = 176, mat = "?support", x_offset="?support_ox", y_offset=0 }
      { x =  16, y = 192, mat = "?outer" }
      { x =   0, y = 192, mat = "?outer" }
    }

    -- right wall
    {
      { x = 176, y =  16, mat = "?outer" }
      { x = 192, y =  16, mat = "?outer" }
      { x = 192, y = 176, mat = "?outer" }
      { x = 176, y = 176, mat = "?wall" }
    }

    {
      { x = 176, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y =  16, mat = "?outer" }
      { x = 176, y =  16, mat = "?support", x_offset="?support_ox", y_offset=0 }
    }
    {
      { x = 176, y = 176, mat = "?outer" }
      { x = 192, y = 176, mat = "?outer" }
      { x = 192, y = 192, mat = "?outer" }
      { x = 176, y = 192, mat = "?support", x_offset="?support_ox", y_offset=0 }
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
      { x =  16, y =   0, mat = "?outer" }
      { x = 176, y =   0, mat = "?ceil" }
      { x = 176, y =  32, mat = "?ceil" }
      { x =  16, y =  32, mat = "?ceil" }
      { b = 128, mat = "?ceil" }
    }

    -- step 2
    {
      { x =  16, y =  32, mat = "?step", y_offset=0, peg=1 }
      { x = 176, y =  32, mat = "?wall" }
      { x = 176, y =  64, mat = "?wall" }
      { x =  16, y =  64, mat = "?wall" }
      { t = 12, mat = "?floor" }
    }

    {
      { x =  16, y =  32, mat = "?ceil" }
      { x = 176, y =  32, mat = "?ceil" }
      { x = 176, y =  64, mat = "?ceil" }
      { x =  16, y =  64, mat = "?ceil" }
      { b = 140, mat = "?ceil" }
    }

    -- step 3
    {
      { x =  16, y =  64, mat = "?step", y_offset=0, peg=1 }
      { x = 176, y =  64, mat = "?wall" }
      { x = 176, y =  96, mat = "?wall" }
      { x =  16, y =  96, mat = "?wall" }
      { t = 24, mat = "?floor" }
    }

    {
      { x =  16, y =  64, mat = "?ceil" }
      { x = 176, y =  64, mat = "?ceil" }
      { x = 176, y =  96, mat = "?ceil" }
      { x =  16, y =  96, mat = "?ceil" }
      { b = 152, mat = "?ceil" }
    }

    -- step 4
    {
      { x =  16, y =  96, mat = "?step", y_offset=0, peg=1 }
      { x = 176, y =  96, mat = "?wall" }
      { x = 176, y = 128, mat = "?wall" }
      { x =  16, y = 128, mat = "?wall" }
      { t = 36, mat = "?floor" }
    }

    {
      { x =  16, y =  96, mat = "?ceil" }
      { x = 176, y =  96, mat = "?ceil" }
      { x = 176, y = 128, mat = "?ceil" }
      { x =  16, y = 128, mat = "?ceil" }
      { b = 164, mat = "?ceil" }
    }

    -- step 5
    {
      { x =  16, y = 128, mat = "?step", y_offset=0, peg=1 }
      { x = 176, y = 128, mat = "?wall" }
      { x = 176, y = 160, mat = "?wall" }
      { x =  16, y = 160, mat = "?wall" }
      { t = 48, mat = "?floor" }
    }

    {
      { x =  16, y = 128, mat = "?ceil" }
      { x = 176, y = 128, mat = "?ceil" }
      { x = 176, y = 160, mat = "?ceil" }
      { x =  16, y = 160, mat = "?ceil" }
      { b = 176, mat = "?ceil" }
    }

    -- step 6
    {
      { x =  16, y = 160, mat = "?step", y_offset=0, peg=1 }
      { x = 176, y = 160, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { t = 60, mat = "?floor" }
    }

    {
      { x =  16, y = 160, mat = "?ceil" }
      { x = 176, y = 160, mat = "?ceil" }
      { x = 176, y = 192, mat = "?outer" }
      { x =  16, y = 192, mat = "?ceil" }
      { b = 188, mat = "?ceil" }
    }
  }
}


PREFAB.HALL_BASIC_I_LIFT =
{
  fitted = "xy"

  z_ranges = { {128,0,"?stair_h"}, {128,0} }

  defaults =
  {
    lift_h = 0
    lift_delta = 8
    q_trigger = 1

    speed = 32
    delay = 105
  }

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

    -- ceiling
    {
      { x =  16, y =   0, mat = "?wall" }
      { x = 176, y =   0, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { b = 256, mat = "?ceil" }
    }

    -- low floor
    {
      { x =  16, y =  0, mat = "?wall" }
      { x = 176, y =  0, mat = "?wall" }
      { x = 176, y = 32, mat = "?wall" }
      { x =  16, y = 32, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }

    -- high floor
    {
      { x =  16, y =   0, mat = "?floor" }
      { x =  32, y =  32, mat = "?floor" }
      { x =  32, y = 160, mat = "?floor" }
      { x =  16, y = 160, mat = "?floor" }
      { t = 128, mat = "?floor" }
    }

    {
      { x = 160, y =  32, mat = "?floor" }
      { x = 176, y =   0, mat = "?floor" }
      { x = 176, y = 160, mat = "?floor" }
      { x = 160, y = 160, mat = "?floor" }
      { t = 128, mat = "?floor" }
    }

    {
      { x =  16, y = 160, mat = "?floor" }
      { x = 176, y = 160, mat = "?floor" }
      { x = 176, y = 192, mat = "?floor" }
      { x =  16, y = 192, mat = "?floor" }
      { t = 128, mat = "?floor" }
    }

    -- lift itself
    {
      { x =  32, y =  32, mat = "?lift", special="?lower_SR", act="SR", tag="?tag", arg1="?tag", arg2="?speed", arg3="?delay", peg=1, x_offset=0, y_offset=0 }
      { x = 160, y =  32, mat = "?lift", special="?lower_WR", act="WR", tag="?tag", arg1="?tag", arg2="?speed", arg3="?delay", peg=1, x_offset=0, y_offset=0 }
      { x = 160, y = 160, mat = "?lift", special="?lower_WR", act="WR", tag="?tag", arg1="?tag", arg2="?speed", arg3="?delay", peg=1, x_offset=0, y_offset=0 }
      { x =  32, y = 160, mat = "?lift", special="?lower_WR", act="WR", tag="?tag", arg1="?tag", arg2="?speed", arg3="?delay", peg=1, x_offset=0, y_offset=0 }
      { t = "?lift_h", delta_z = "?lift_delta", mat = "?top", tag = "?tag" }
    }

    -- trigger to go up
    {
      { m = "rail", only_if="?q_trigger" }
      { x =  40, y =  80, special="?raise_W1", act="W1", tag="?tag", arg1="?tag", arg2="?speed", arg3="?delay" }
      { x = 152, y =  80 }
      { x = 152, y = 112 }
      { x =  40, y = 112 }
    }
  }
}


PREFAB.HALL_BASIC_I_LIFT_QUAKE =
{
  fitted = "xy"

  -- the ranges ensure the lift mapmodel stays 128x128
  -- (otherwise could exceed the limit of 240 for extents)
  x_ranges = { {32,1}, {128,0}, {32,1} }
  y_ranges = { {32,1}, {128,0}, {32,1} }

  z_ranges = { {128,0,"?stair_h" }, {128,0} }

  defaults =
  {
    lift_flags = ""
  }

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

    -- ceiling
    {
      { x =  16, y =   0, mat = "?wall" }
      { x = 176, y =   0, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { b = 256, mat = "?ceil" }
    }

    -- low floor
    {
      { x =  16, y =   0, mat = "?wall" }
      { x = 176, y =   0, mat = "?wall" }
      { x = 176, y = 160, mat = "?wall" }
      { x =  16, y = 160, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }

    -- high floor
    {
      { x =  16, y = 160, mat = "?floor" }
      { x = 176, y = 160, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { t = 128, mat = "?floor" }
    }
  }

  models =
  {
    -- lift itself
    {
      x1 =  32, x2 = 160, x_face = { mat="?lift" }
      y1 =  32, y2 = 160, y_face = { mat="?lift" }
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


PREFAB.HALL_OUTDOORSY_I =
{
  fitted = "xy"

  defaults =
  {
    fence = "?wall"

    sky_ofs = 256
    fence_h = 32
  }

  brushes =
  {
    -- ceiling
    {
      { x =   0, y =   0, mat = "_SKY" }
      { x = 192, y =   0, mat = "_SKY" }
      { x = 192, y = 192, mat = "_SKY" }
      { x =   0, y = 192, mat = "_SKY" }
      { b = "?sky_ofs", mat = "_SKY" }
    }

    -- floor
    {
      { x =   0, y =   0, mat = "?floor" }
      { x = 192, y =   0, mat = "?floor" }
      { x = 192, y = 192, mat = "?floor" }
      { x =   0, y = 192, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }

    -- left side
    {
      { x =   0, y =  16, mat = "?fence" }
      { x =  16, y =  16, mat = "?fence" }
      { x =  16, y = 176, mat = "?fence" }
      { x =   0, y = 176, mat = "?fence" }
      { t = "?fence_h", mat = "?fence" }
    }

    -- right side
    {
      { x = 176, y =  16, mat = "?fence" }
      { x = 192, y =  16, mat = "?fence" }
      { x = 192, y = 176, mat = "?fence" }
      { x = 176, y = 176, mat = "?fence" }
      { t = "?fence_h", mat = "?fence" }
    }

    -- da monsters
    {
      { m = "spot" }
      { x =  24, y =  24 }
      { x = 168, y =  24 }
      { x = 168, y = 168 }
      { x =  24, y = 168 }
      { b = 0 }
      { t = "?sky_ofs" }
    }
  }
}


----------------------------------------------------------------


PREFAB.HALL_THIN_I =
{
  fitted = "xy"

  x_ranges = { {64,1}, {64,0}, {64,1} }

  brushes =
  {
    {
      { x =  64, y =   0, mat = "?outer" }
      { x = 128, y =   0, mat = "?outer" }
      { x = 128, y = 192, mat = "?outer" }
      { x =  64, y = 192, mat = "?outer" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  64, y =   0, mat = "?outer" }
      { x = 128, y =   0, mat = "?outer" }
      { x = 128, y = 192, mat = "?outer" }
      { x =  64, y = 192, mat = "?outer" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x = 128, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y = 192, mat = "?outer" }
      { x = 128, y = 192, mat = "?wall" }
    }

    {
      { x =   0, y =   0, mat = "?outer" }
      { x =  64, y =   0, mat = "?wall" }
      { x =  64, y = 192, mat = "?outer" }
      { x =   0, y = 192, mat = "?outer" }
    }
  }
}


PREFAB.HALL_THIN_C =
{
  fitted = "xy"

  x_ranges = { {64,1}, {64,0}, {64,1} }
  y_ranges = { {64,1}, {64,0}, {64,1} }

  brushes =
  {
    {
      { x =   0, y = 128, mat = "?wall" }
      { x =  64, y = 128, mat = "?wall" }
      { x =  64, y = 192, mat = "?outer" }
      { x =   0, y = 192, mat = "?outer" }
    }

    {
      { x =  50, y =  50, mat = "?wall" }
      { x =  64, y =  24, mat = "?wall" }
      { x = 128, y =  64, mat = "?wall" }
      { x = 108, y = 108, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  50, y =  50, mat = "?wall" }
      { x =  64, y =  24, mat = "?wall" }
      { x = 128, y =  64, mat = "?wall" }
      { x = 108, y = 108, mat = "?wall" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x = 108, y = 108, mat = "?wall" }
      { x = 128, y =  64, mat = "?wall" }
      { x = 192, y =  64, mat = "?outer" }
      { x = 192, y = 192, mat = "?wall" }
    }

    {
      { x =  64, y =   0, mat = "?outer" }
      { x = 128, y =   0, mat = "?wall" }
      { x = 128, y =  64, mat = "?wall" }
      { x =  64, y =  24, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  64, y =   0, mat = "?outer" }
      { x = 128, y =   0, mat = "?wall" }
      { x = 128, y =  64, mat = "?wall" }
      { x =  64, y =  24, mat = "?wall" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x =   0, y =   0, mat = "?outer" }
      { x =  64, y =   0, mat = "?wall" }
      { x =  64, y =  24, mat = "?wall" }
      { x =  50, y =  50, mat = "?wall" }
      { x =  24, y =  64, mat = "?wall" }
      { x =   0, y =  64, mat = "?outer" }
    }

    {
      { x =   0, y =  64, mat = "?outer" }
      { x =  24, y =  64, mat = "?outer" }
      { x =  64, y = 128, mat = "?outer" }
      { x =   0, y = 128, mat = "?outer" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =   0, y =  64, mat = "?outer" }
      { x =  24, y =  64, mat = "?outer" }
      { x =  64, y = 128, mat = "?outer" }
      { x =   0, y = 128, mat = "?outer" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x = 128, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y =  64, mat = "?wall" }
      { x = 128, y =  64, mat = "?wall" }
    }

    {
      { x =  64, y = 128, mat = "?wall" }
      { x = 108, y = 108, mat = "?wall" }
      { x = 192, y = 192, mat = "?outer" }
      { x =  64, y = 192, mat = "?wall" }
    }

    {
      { x =  24, y =  64, mat = "?wall" }
      { x =  50, y =  50, mat = "?wall" }
      { x = 108, y = 108, mat = "?wall" }
      { x =  64, y = 128, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  24, y =  64, mat = "?wall" }
      { x =  50, y =  50, mat = "?wall" }
      { x = 108, y = 108, mat = "?wall" }
      { x =  64, y = 128, mat = "?wall" }
      { b = 72, mat = "?ceil" }
    }
  }
}


PREFAB.HALL_THIN_T =
{
  fitted = "xy"

  x_ranges = { {64,1}, {64,0}, {64,1} }
  y_ranges = { {64,1}, {64,0}, {64,1} }

  defaults =
  {
    lamp_ent = "none"
  }

  brushes =
  {
    {
      { x =   0, y = 128, mat = "?wall" }
      { x =  50, y = 128, mat = "?wall" }
      { x =  50, y = 192, mat = "?outer" }
      { x =   0, y = 192, mat = "?outer" }
    }

    {
      { x =  64, y =   0, mat = "?outer" }
      { x = 128, y =   0, mat = "?outer" }
      { x = 128, y =  24, mat = "?outer" }
      { x =  64, y =  24, mat = "?outer" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  64, y =   0, mat = "?outer" }
      { x = 128, y =   0, mat = "?outer" }
      { x = 128, y =  24, mat = "?outer" }
      { x =  64, y =  24, mat = "?outer" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x =   0, y =   0, mat = "?outer" }
      { x =  64, y =   0, mat = "?wall" }
      { x =  64, y =  24, mat = "?wall" }
      { x =  50, y =  50, mat = "?wall" }
      { x =  24, y =  64, mat = "?wall" }
      { x =   0, y =  64, mat = "?outer" }
    }

    {
      { x =   0, y =  64, mat = "?outer" }
      { x =  24, y =  64, mat = "?outer" }
      { x =  50, y = 128, mat = "?outer" }
      { x =   0, y = 128, mat = "?outer" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =   0, y =  64, mat = "?outer" }
      { x =  24, y =  64, mat = "?outer" }
      { x =  50, y = 128, mat = "?outer" }
      { x =   0, y = 128, mat = "?outer" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x = 128, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y =  64, mat = "?wall" }
      { x = 168, y =  64, mat = "?wall" }
      { x = 142, y =  50, mat = "?wall" }
      { x = 128, y =  24, mat = "?wall" }
    }

    {
      { x = 142, y = 128, mat = "?wall" }
      { x = 192, y = 128, mat = "?outer" }
      { x = 192, y = 192, mat = "?outer" }
      { x = 142, y = 192, mat = "?wall" }
    }

    {
      { x =  50, y =  88, mat = "?outer" }
      { x =  96, y =  72, mat = "?outer" }
      { x = 142, y =  86, mat = "?outer" }
      { x = 142, y = 128, mat = "?outer" }
      { x = 112, y = 152, mat = "?outer" }
      { x =  80, y = 152, mat = "?outer" }
      { x =  50, y = 128, mat = "?outer" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  50, y =  88, mat = "?outer" }
      { x =  96, y =  72, mat = "?outer" }
      { x = 142, y =  86, mat = "?outer" }
      { x = 142, y = 128, mat = "?outer" }
      { x = 112, y = 152, mat = "?outer" }
      { x =  80, y = 152, mat = "?outer" }
      { x =  50, y = 128, mat = "?outer" }
      { b = 72, mat = "?ceil" }
    }
    {
      { m = "light", add = 48 }
      { x =  50, y =  88 }
      { x =  96, y =  72 }
      { x = 142, y =  86 }
      { x = 142, y = 128 }
      { x = 112, y = 152 }
      { x =  80, y = 152 }
      { x =  50, y = 128 }
    }

    {
      { x =  50, y = 128, mat = "?wall" }
      { x =  80, y = 152, mat = "?wall" }
      { x =  80, y = 192, mat = "?outer" }
      { x =  50, y = 192, mat = "?wall" }
    }

    {
      { x =  96, y =  24, mat = "?wall" }
      { x = 128, y =  24, mat = "?wall" }
      { x = 142, y =  50, mat = "?wall" }
      { x = 142, y =  86, mat = "?wall" }
      { x =  96, y =  72, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  96, y =  24, mat = "?wall" }
      { x = 128, y =  24, mat = "?wall" }
      { x = 142, y =  50, mat = "?wall" }
      { x = 142, y =  86, mat = "?wall" }
      { x =  96, y =  72, mat = "?wall" }
      { b = 72, mat = "?ceil" }
    }
    {
      { m = "light", add = 32 }
      { x =  96, y =  24 }
      { x = 128, y =  24 }
      { x = 142, y =  50 }
      { x = 142, y =  86 }
      { x =  96, y =  72 }
    }

    {
      { x =  24, y =  64, mat = "?wall" }
      { x =  50, y =  50, mat = "?wall" }
      { x =  50, y = 128, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  24, y =  64, mat = "?wall" }
      { x =  50, y =  50, mat = "?wall" }
      { x =  50, y = 128, mat = "?wall" }
      { b = 72, mat = "?ceil" }
    }
    {
      { m = "light", add = 32 }
      { x =  24, y =  64 }
      { x =  50, y =  50 }
      { x =  50, y = 128 }
    }

    {
      { x =  50, y =  50, mat = "?wall" }
      { x =  64, y =  24, mat = "?wall" }
      { x =  96, y =  24, mat = "?wall" }
      { x =  96, y =  72, mat = "?wall" }
      { x =  50, y =  88, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  50, y =  50, mat = "?wall" }
      { x =  64, y =  24, mat = "?wall" }
      { x =  96, y =  24, mat = "?wall" }
      { x =  96, y =  72, mat = "?wall" }
      { x =  50, y =  88, mat = "?wall" }
      { b = 72, mat = "?ceil" }
    }
    {
      { m = "light", add = 32 }
      { x =  50, y =  50 }
      { x =  64, y =  24 }
      { x =  96, y =  24 }
      { x =  96, y =  72 }
      { x =  50, y =  88 }
    }

    {
      { x = 142, y =  50, mat = "?wall" }
      { x = 168, y =  64, mat = "?wall" }
      { x = 142, y = 128, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x = 142, y =  50, mat = "?wall" }
      { x = 168, y =  64, mat = "?wall" }
      { x = 142, y = 128, mat = "?wall" }
      { b = 72, mat = "?ceil" }
    }
    {
      { m = "light", add = 32 }
      { x = 142, y =  50 }
      { x = 168, y =  64 }
      { x = 142, y = 128 }
    }

    {
      { x = 142, y = 128, mat = "?wall" }
      { x = 168, y =  64, mat = "?wall" }
      { x = 192, y =  64, mat = "?outer" }
      { x = 192, y = 128, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x = 142, y = 128, mat = "?wall" }
      { x = 168, y =  64, mat = "?wall" }
      { x = 192, y =  64, mat = "?outer" }
      { x = 192, y = 128, mat = "?wall" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x = 112, y = 152, mat = "?wall" }
      { x = 142, y = 128, mat = "?wall" }
      { x = 142, y = 192, mat = "?outer" }
      { x = 112, y = 192, mat = "?wall" }
    }

    {
      { x =  80, y = 152, mat = "?wall" }
      { x = 112, y = 152, mat = "?wall" }
      { x = 112, y = 192, mat = "?outer" }
      { x =  80, y = 192, mat = "?wall" }
    }
  }

  entities =
  {
    { ent = "?lamp_ent", x = 96, y = 140, z = 0, angle = 270 }
  }
}


PREFAB.HALL_THIN_I_STAIR =
{
  fitted = "xy"

  z_ranges = { {60,0,"?stair_h"}, {116,0} }
  x_ranges = { {64,1}, {64,0}, {64,1} }

  brushes =
  {
    {
      { x =  64, y = 160, mat = "?step" }
      { x = 128, y = 160, mat = "?wall" }
      { x = 128, y = 192, mat = "?outer" }
      { x =  64, y = 192, mat = "?wall" }
      { t = 60, mat = "?floor" }
    }
    {
      { x =  64, y = 160, mat = "?wall" }
      { x = 128, y = 160, mat = "?wall" }
      { x = 128, y = 192, mat = "?outer" }
      { x =  64, y = 192, mat = "?wall" }
      { b = 176, mat = "?ceil" }
    }

    {
      { x = 128, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y = 192, mat = "?outer" }
      { x = 128, y = 192, mat = "?wall" }
    }

    {
      { x =   0, y =   0, mat = "?outer" }
      { x =  64, y =   0, mat = "?wall" }
      { x =  64, y = 192, mat = "?outer" }
      { x =   0, y = 192, mat = "?outer" }
    }

    {
      { x =  64, y = 128, mat = "?step" }
      { x = 128, y = 128, mat = "?wall" }
      { x = 128, y = 160, mat = "?wall" }
      { x =  64, y = 160, mat = "?wall" }
      { t = 48, mat = "?floor" }
    }
    {
      { x =  64, y = 128, mat = "?wall" }
      { x = 128, y = 128, mat = "?wall" }
      { x = 128, y = 160, mat = "?wall" }
      { x =  64, y = 160, mat = "?wall" }
      { b = 176, mat = "?ceil" }
    }

    {
      { x =  64, y =   0, mat = "?outer" }
      { x = 128, y =   0, mat = "?wall" }
      { x = 128, y =  32, mat = "?wall" }
      { x =  64, y =  32, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  64, y =   0, mat = "?outer" }
      { x = 128, y =   0, mat = "?wall" }
      { x = 128, y =  32, mat = "?wall" }
      { x =  64, y =  32, mat = "?wall" }
      { b = 176, mat = "?ceil" }
    }

    {
      { x =  64, y =  32, mat = "?step" }
      { x = 128, y =  32, mat = "?wall" }
      { x = 128, y =  64, mat = "?wall" }
      { x =  64, y =  64, mat = "?wall" }
      { t = 12, mat = "?floor" }
    }
    {
      { x =  64, y =  32, mat = "?wall" }
      { x = 128, y =  32, mat = "?wall" }
      { x = 128, y =  64, mat = "?wall" }
      { x =  64, y =  64, mat = "?wall" }
      { b = 176, mat = "?ceil" }
    }

    {
      { x =  64, y =  96, mat = "?step" }
      { x = 128, y =  96, mat = "?wall" }
      { x = 128, y = 128, mat = "?wall" }
      { x =  64, y = 128, mat = "?wall" }
      { t = 36, mat = "?floor" }
    }
    {
      { x =  64, y =  96, mat = "?wall" }
      { x = 128, y =  96, mat = "?wall" }
      { x = 128, y = 128, mat = "?wall" }
      { x =  64, y = 128, mat = "?wall" }
      { b = 176, mat = "?ceil" }
    }

    {
      { x =  64, y =  64, mat = "?step" }
      { x = 128, y =  64, mat = "?wall" }
      { x = 128, y =  96, mat = "?wall" }
      { x =  64, y =  96, mat = "?wall" }
      { t = 24, mat = "?floor" }
    }
    {
      { x =  64, y =  64, mat = "?wall" }
      { x = 128, y =  64, mat = "?wall" }
      { x = 128, y =  96, mat = "?wall" }
      { x =  64, y =  96, mat = "?wall" }
      { b = 176, mat = "?ceil" }
    }
  }
}


PREFAB.HALL_THIN_I_BULGE =
{
  fitted = "xy"

  brushes =
  {
    {
      { x =   0, y = 192, mat = "?wall" }
      { x =  20, y = 172, mat = "?wall" }
      { x =  48, y = 184, mat = "?wall" }
      { x =  48, y = 192, mat = "?outer" }
    }

    {
      { x =  64, y = 184, mat = "?floor" }
      { x = 128, y = 184, mat = "?floor" }
      { x = 128, y = 192, mat = "?outer" }
      { x =  64, y = 192, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  64, y = 184, mat = "?ceil" }
      { x = 128, y = 184, mat = "?ceil" }
      { x = 128, y = 192, mat = "?outer" }
      { x =  64, y = 192, mat = "?ceil" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x = 128, y = 184, mat = "?wall" }
      { x = 144, y = 184, mat = "?wall" }
      { x = 144, y = 192, mat = "?outer" }
      { x = 128, y = 192, mat = "?wall" }
    }

    {
      { x =  64, y =   0, mat = "?outer" }
      { x = 128, y =   0, mat = "?floor" }
      { x = 128, y =   8, mat = "?floor" }
      { x =  64, y =   8, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  64, y =   0, mat = "?outer" }
      { x = 128, y =   0, mat = "?ceil" }
      { x = 128, y =   8, mat = "?ceil" }
      { x =  64, y =   8, mat = "?ceil" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x =  48, y =   0, mat = "?outer" }
      { x =  64, y =   0, mat = "?wall" }
      { x =  64, y =   8, mat = "?wall" }
      { x =  48, y =   8, mat = "?wall" }
    }

    {
      { x =   0, y =   0, mat = "?wall" }
      { x =  20, y =  20, mat = "?wall" }
      { x =   8, y =  48, mat = "?wall" }
      { x =   0, y =  48, mat = "?outer" }
    }

    {
      { x = 144, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 172, y =  20, mat = "?wall" }
      { x = 144, y =   8, mat = "?wall" }
    }

    {
      { x = 172, y = 172, mat = "?wall" }
      { x = 184, y = 144, mat = "?wall" }
      { x = 192, y = 144, mat = "?outer" }
      { x = 192, y = 192, mat = "?wall" }
    }

    {
      { x =   8, y =  48, mat = "?floor" }
      { x =  20, y =  20, mat = "?floor" }
      { x =  48, y =   8, mat = "?floor" }
      { x =  64, y =   8, mat = "?floor" }
      { x =  64, y = 184, mat = "?floor" }
      { x =  48, y = 184, mat = "?floor" }
      { x =  20, y = 172, mat = "?floor" }
      { x =   8, y = 144, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =   8, y =  48, mat = "?ceil" }
      { x =  20, y =  20, mat = "?ceil" }
      { x =  48, y =   8, mat = "?ceil" }
      { x =  64, y =   8, mat = "?ceil" }
      { x =  64, y = 184, mat = "?ceil" }
      { x =  48, y = 184, mat = "?ceil" }
      { x =  20, y = 172, mat = "?ceil" }
      { x =   8, y = 144, mat = "?ceil" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x = 128, y =   8, mat = "?floor" }
      { x = 144, y =   8, mat = "?floor" }
      { x = 172, y =  20, mat = "?floor" }
      { x = 184, y =  48, mat = "?floor" }
      { x = 184, y = 144, mat = "?floor" }
      { x = 172, y = 172, mat = "?floor" }
      { x = 144, y = 184, mat = "?floor" }
      { x = 128, y = 184, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }
    {
      { x = 128, y =   8, mat = "?ceil" }
      { x = 144, y =   8, mat = "?ceil" }
      { x = 172, y =  20, mat = "?ceil" }
      { x = 184, y =  48, mat = "?ceil" }
      { x = 184, y = 144, mat = "?ceil" }
      { x = 172, y = 172, mat = "?ceil" }
      { x = 144, y = 184, mat = "?ceil" }
      { x = 128, y = 184, mat = "?ceil" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x =  48, y = 184, mat = "?wall" }
      { x =  64, y = 184, mat = "?wall" }
      { x =  64, y = 192, mat = "?outer" }
      { x =  48, y = 192, mat = "?wall" }
    }

    {
      { x = 128, y =   0, mat = "?outer" }
      { x = 144, y =   0, mat = "?wall" }
      { x = 144, y =   8, mat = "?wall" }
      { x = 128, y =   8, mat = "?wall" }
    }

    {
      { x =  64, y =   8, mat = "?floor" }
      { x = 128, y =   8, mat = "?floor" }
      { x = 128, y =  64, mat = "?floor" }
      { x =  64, y =  64, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  64, y =   8, mat = "?ceil" }
      { x = 128, y =   8, mat = "?ceil" }
      { x = 128, y =  64, mat = "?ceil" }
      { x =  64, y =  64, mat = "?ceil" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x =  64, y = 128, mat = "?floor" }
      { x = 128, y = 128, mat = "?floor" }
      { x = 128, y = 184, mat = "?floor" }
      { x =  64, y = 184, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  64, y = 128, mat = "?ceil" }
      { x = 128, y = 128, mat = "?ceil" }
      { x = 128, y = 184, mat = "?ceil" }
      { x =  64, y = 184, mat = "?ceil" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x =   0, y = 144, mat = "?wall" }
      { x =   8, y = 144, mat = "?wall" }
      { x =  20, y = 172, mat = "?wall" }
      { x =   0, y = 192, mat = "?outer" }
    }

    {
      { x =   0, y =  48, mat = "?wall" }
      { x =   8, y =  48, mat = "?wall" }
      { x =   8, y = 144, mat = "?wall" }
      { x =   0, y = 144, mat = "?outer" }
    }

    {
      { x =   0, y =   0, mat = "?outer" }
      { x =  48, y =   0, mat = "?wall" }
      { x =  48, y =   8, mat = "?wall" }
      { x =  20, y =  20, mat = "?wall" }
    }

    {
      { x = 172, y =  20, mat = "?wall" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y =  48, mat = "?wall" }
      { x = 184, y =  48, mat = "?wall" }
    }

    {
      { x = 184, y =  48, mat = "?wall" }
      { x = 192, y =  48, mat = "?outer" }
      { x = 192, y = 144, mat = "?wall" }
      { x = 184, y = 144, mat = "?wall" }
    }

    {
      { x = 144, y = 184, mat = "?wall" }
      { x = 172, y = 172, mat = "?wall" }
      { x = 192, y = 192, mat = "?outer" }
      { x = 144, y = 192, mat = "?wall" }
    }

    {
      { x =  64, y =  64, mat = "?floor" }
      { x = 128, y =  64, mat = "?floor" }
      { x = 128, y = 128, mat = "?floor" }
      { x =  64, y = 128, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  64, y =  64, mat = "?ceil" }
      { x = 128, y =  64, mat = "?ceil" }
      { x = 128, y = 128, mat = "?ceil" }
      { x =  64, y = 128, mat = "?ceil" }
      { b = 80, mat = "?lamp" }
    }

    -- lighting
    {
      { m = "light", add = 16 }
      { x =   8, y =   8 }
      { x = 184, y =   8 }
      { x = 184, y = 184 }
      { x =   8, y = 184 }
    }

    {
      { m = "light", add = 32 }
      { x =  64, y =  64 }
      { x = 128, y =  64 }
      { x = 128, y = 128 }
      { x =  64, y = 128 }
    }
  }
}


PREFAB.HALL_THIN_I_BEND =
{
  fitted = "xy"

  x_ranges = { {64,1}, {64,0}, {64,1} }

  brushes =
  {
    {
      { x =   0, y = 136, mat = "?wall" }
      { x =   8, y = 136, mat = "?wall" }
      { x =  32, y = 160, mat = "?wall" }
      { x =  32, y = 192, mat = "?outer" }
      { x =   0, y = 192, mat = "?outer" }
    }

    {
      { x =  64, y = 176, mat = "?wall" }
      { x = 128, y = 176, mat = "?wall" }
      { x = 128, y = 192, mat = "?outer" }
      { x =  64, y = 192, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  64, y = 176, mat = "?wall" }
      { x = 128, y = 176, mat = "?wall" }
      { x = 128, y = 192, mat = "?outer" }
      { x =  64, y = 192, mat = "?wall" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x = 128, y = 136, mat = "?wall" }
      { x = 192, y = 136, mat = "?outer" }
      { x = 192, y = 192, mat = "?outer" }
      { x = 128, y = 192, mat = "?wall" }
    }

    {
      { x =  64, y =   0, mat = "?outer" }
      { x = 128, y =   0, mat = "?wall" }
      { x = 128, y =  16, mat = "?wall" }
      { x =  64, y =  16, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  64, y =   0, mat = "?outer" }
      { x = 128, y =   0, mat = "?wall" }
      { x = 128, y =  16, mat = "?wall" }
      { x =  64, y =  16, mat = "?wall" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x =  32, y =   0, mat = "?outer" }
      { x =  64, y =   0, mat = "?wall" }
      { x =  64, y =  16, mat = "?wall" }
      { x =  48, y =  32, mat = "?wall" }
      { x =  32, y =  32, mat = "?wall" }
    }

    {
      { x =   0, y =   0, mat = "?outer" }
      { x =  32, y =   0, mat = "?wall" }
      { x =  32, y =  32, mat = "?wall" }
      { x =   8, y =  56, mat = "?wall" }
      { x =   0, y =  56, mat = "?outer" }
    }

    {
      { x = 128, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y =  56, mat = "?wall" }
      { x = 128, y =  56, mat = "?wall" }
    }

    {
      { x =   8, y = 104, mat = "?wall" }
      { x =  72, y = 104, mat = "?wall" }
      { x =  88, y = 120, mat = "?wall" }
      { x =  48, y = 160, mat = "?wall" }
      { x =  32, y = 160, mat = "?wall" }
      { x =   8, y = 136, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =   8, y = 104, mat = "?wall" }
      { x =  72, y = 104, mat = "?wall" }
      { x =  88, y = 120, mat = "?wall" }
      { x =  48, y = 160, mat = "?wall" }
      { x =  32, y = 160, mat = "?wall" }
      { x =   8, y = 136, mat = "?wall" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x =  32, y = 160, mat = "?wall" }
      { x =  48, y = 160, mat = "?wall" }
      { x =  64, y = 176, mat = "?wall" }
      { x =  64, y = 192, mat = "?outer" }
      { x =  32, y = 192, mat = "?wall" }
    }

    {
      { x =   8, y =  56, mat = "?wall" }
      { x =  32, y =  32, mat = "?wall" }
      { x =  48, y =  32, mat = "?wall" }
      { x =  88, y =  72, mat = "?wall" }
      { x =  72, y =  88, mat = "?wall" }
      { x =   8, y =  88, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =   8, y =  56, mat = "?wall" }
      { x =  32, y =  32, mat = "?wall" }
      { x =  48, y =  32, mat = "?wall" }
      { x =  88, y =  72, mat = "?wall" }
      { x =  72, y =  88, mat = "?wall" }
      { x =   8, y =  88, mat = "?wall" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x =  72, y =  88, mat = "?wall" }
      { x =  88, y =  72, mat = "?wall" }
      { x = 112, y =  72, mat = "?wall" }
      { x = 112, y = 120, mat = "?wall" }
      { x =  88, y = 120, mat = "?wall" }
      { x =  72, y = 104, mat = "?wall" }
    }

    {
      { x =  48, y =  32, mat = "?wall" }
      { x =  64, y =  16, mat = "?wall" }
      { x = 128, y =  16, mat = "?wall" }
      { x = 128, y =  56, mat = "?wall" }
      { x = 112, y =  72, mat = "?wall" }
      { x =  88, y =  72, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  48, y =  32, mat = "?wall" }
      { x =  64, y =  16, mat = "?wall" }
      { x = 128, y =  16, mat = "?wall" }
      { x = 128, y =  56, mat = "?wall" }
      { x = 112, y =  72, mat = "?wall" }
      { x =  88, y =  72, mat = "?wall" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x = 112, y =  72, mat = "?wall" }
      { x = 128, y =  56, mat = "?wall" }
      { x = 192, y =  56, mat = "?outer" }
      { x = 192, y = 136, mat = "?wall" }
      { x = 128, y = 136, mat = "?wall" }
      { x = 112, y = 120, mat = "?wall" }
    }

    {
      { x =  48, y = 160, mat = "?wall" }
      { x =  88, y = 120, mat = "?wall" }
      { x = 112, y = 120, mat = "?wall" }
      { x = 128, y = 136, mat = "?wall" }
      { x = 128, y = 176, mat = "?wall" }
      { x =  64, y = 176, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  48, y = 160, mat = "?wall" }
      { x =  88, y = 120, mat = "?wall" }
      { x = 112, y = 120, mat = "?wall" }
      { x = 128, y = 136, mat = "?wall" }
      { x = 128, y = 176, mat = "?wall" }
      { x =  64, y = 176, mat = "?wall" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x =   0, y =  56, mat = "?wall" }
      { x =   8, y =  56, mat = "?wall" }
      { x =   8, y = 136, mat = "?wall" }
      { x =   0, y = 136, mat = "?outer" }
    }

    {
      { x =   8, y =  88, mat = "?wall" }
      { x =  72, y =  88, mat = "?wall" }
      { x =  72, y = 104, mat = "?wall" }
      { x =   8, y = 104, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =   8, y =  88, mat = "?wall" }
      { x =  72, y =  88, mat = "?wall" }
      { x =  72, y = 104, mat = "?wall" }
      { x =   8, y = 104, mat = "?wall" }
      { b = 72, mat = "?ceil" }
    }
  }
}


PREFAB.HALL_THIN_OH =
{
  fitted = "xy"

  defaults =
  {
    torch_ent = ""

    north_h = 0
     east_h = 0
     west_h = 0
  }

  brushes =
  {
    {
      { x = 160, y = 352, mat = "?wall" }
      { x = 224, y = 352, mat = "?wall" }
      { x = 224, y = 384, mat = "?outer" }
      { x = 160, y = 384, mat = "?wall" }
      { t = "?north_h", mat = "?floor" }
    }
    {
      { x = 160, y = 352, mat = "?wall" }
      { x = 224, y = 352, mat = "?wall" }
      { x = 224, y = 384, mat = "?outer" }
      { x = 160, y = 384, mat = "?wall" }
      { b = 128, mat = "?ceil" }
    }

    {
      { x = 224, y = 352, mat = "?wall" }
      { x = 240, y = 304, mat = "?wall" }
      { x = 272, y = 280, mat = "?niche" }
      { x = 304, y = 320, mat = "?wall" }
      { x = 304, y = 384, mat = "?outer" }
      { x = 224, y = 384, mat = "?wall" }
    }

    {
      { x = 160, y =   0, mat = "?outer" }
      { x = 224, y =   0, mat = "?wall" }
      { x = 224, y =  32, mat = "?wall" }
      { x = 160, y =  32, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x = 160, y =   0, mat = "?outer" }
      { x = 224, y =   0, mat = "?wall" }
      { x = 224, y =  32, mat = "?wall" }
      { x = 160, y =  32, mat = "?wall" }
      { b = 128, mat = "?ceil" }
    }

    {
      { x =  80, y =   0, mat = "?outer" }
      { x = 160, y =   0, mat = "?wall" }
      { x = 160, y =  32, mat = "?wall" }
      { x = 144, y =  80, mat = "?wall" }
      { x = 112, y = 104, mat = "?niche" }
      { x =  80, y =  64, mat = "?wall" }
    }

    {
      { x =   0, y =   0, mat = "?outer" }
      { x =  80, y =   0, mat = "?wall" }
      { x =  80, y =  64, mat = "?niche" }
      { x =  48, y =  88, mat = "?wall" }
      { x =   0, y =  88, mat = "?outer" }
    }

    {
      { x = 304, y =   0, mat = "?outer" }
      { x = 384, y =   0, mat = "?outer" }
      { x = 384, y =  88, mat = "?wall" }
      { x = 336, y =  88, mat = "?niche" }
      { x = 304, y =  64, mat = "?wall" }
    }

    {
      { x = 304, y = 320, mat = "?niche" }
      { x = 336, y = 296, mat = "?wall" }
      { x = 384, y = 296, mat = "?outer" }
      { x = 384, y = 384, mat = "?outer" }
      { x = 304, y = 384, mat = "?wall" }
    }

    {
      { x =   0, y = 296, mat = "?wall" }
      { x =  48, y = 296, mat = "?niche" }
      { x =  80, y = 320, mat = "?wall" }
      { x =  80, y = 384, mat = "?outer" }
      { x =   0, y = 384, mat = "?outer" }
    }

    {
      { x =  80, y = 320, mat = "?niche" }
      { x = 112, y = 280, mat = "?wall" }
      { x = 144, y = 304, mat = "?wall" }
      { x = 160, y = 352, mat = "?wall" }
      { x = 160, y = 384, mat = "?outer" }
      { x =  80, y = 384, mat = "?wall" }
    }

    {
      { x =  32, y = 192, mat = "?wall" }
      { x =  48, y = 152, mat = "?wall" }
      { x =  80, y = 128, mat = "?wall" }
      { x = 112, y = 104, mat = "?wall" }
      { x = 144, y =  80, mat = "?wall" }
      { x = 240, y =  80, mat = "?wall" }
      { x = 272, y = 104, mat = "?wall" }
      { x = 304, y = 128, mat = "?wall" }
      { x = 336, y = 152, mat = "?wall" }
      { x = 352, y = 192, mat = "?wall" }
      { x = 336, y = 232, mat = "?wall" }
      { x = 304, y = 256, mat = "?wall" }
      { x = 272, y = 280, mat = "?wall" }
      { x = 240, y = 304, mat = "?wall" }
      { x = 144, y = 304, mat = "?wall" }
      { x = 112, y = 280, mat = "?wall" }
      { x =  80, y = 256, mat = "?wall" }
      { x =  48, y = 232, mat = "?wall" }
      { t = 0, mat = "?floor", light_add=48 }
    }
    {
      { x =  32, y = 192, mat = "?wall" }
      { x =  48, y = 152, mat = "?wall" }
      { x =  80, y = 128, mat = "?wall" }
      { x = 112, y = 104, mat = "?wall" }
      { x = 144, y =  80, mat = "?wall" }
      { x = 240, y =  80, mat = "?wall" }
      { x = 272, y = 104, mat = "?wall" }
      { x = 304, y = 128, mat = "?wall" }
      { x = 336, y = 152, mat = "?wall" }
      { x = 352, y = 192, mat = "?wall" }
      { x = 336, y = 232, mat = "?wall" }
      { x = 304, y = 256, mat = "?wall" }
      { x = 272, y = 280, mat = "?wall" }
      { x = 240, y = 304, mat = "?wall" }
      { x = 144, y = 304, mat = "?wall" }
      { x = 112, y = 280, mat = "?wall" }
      { x =  80, y = 256, mat = "?wall" }
      { x =  48, y = 232, mat = "?wall" }
      { b = 128, mat = "?ceil" }
    }

    {
      { x =   0, y = 224, mat = "?wall" }
      { x =  48, y = 232, mat = "?wall" }
      { x =  80, y = 256, mat = "?niche" }
      { x =  48, y = 296, mat = "?wall" }
      { x =   0, y = 296, mat = "?outer" }
    }

    {
      { x =   0, y = 192, mat = "?wall" }
      { x =  32, y = 192, mat = "?wall" }
      { x =  48, y = 232, mat = "?wall" }
      { x =   0, y = 224, mat = "?outer" }
      { t = "?west_h", mat = "?floor" }
    }
    {
      { x =   0, y = 192, mat = "?wall" }
      { x =  32, y = 192, mat = "?wall" }
      { x =  48, y = 232, mat = "?wall" }
      { x =   0, y = 224, mat = "?outer" }
      { b = 128, mat = "?ceil" }
    }

    {
      { x =   0, y = 160, mat = "?wall" }
      { x =  48, y = 152, mat = "?wall" }
      { x =  32, y = 192, mat = "?wall" }
      { x =   0, y = 192, mat = "?outer" }
      { t = "?west_h", mat = "?floor" }
    }
    {
      { x =   0, y = 160, mat = "?wall" }
      { x =  48, y = 152, mat = "?wall" }
      { x =  32, y = 192, mat = "?wall" }
      { x =   0, y = 192, mat = "?outer" }
      { b = 128, mat = "?ceil" }
    }

    {
      { x = 144, y =  80, mat = "?wall" }
      { x = 160, y =  32, mat = "?wall" }
      { x = 224, y =  32, mat = "?wall" }
      { x = 240, y =  80, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x = 144, y =  80, mat = "?wall" }
      { x = 160, y =  32, mat = "?wall" }
      { x = 224, y =  32, mat = "?wall" }
      { x = 240, y =  80, mat = "?wall" }
      { b = 128, mat = "?ceil", light_add=24 }
    }

    {
      { x = 144, y = 304, mat = "?wall" }
      { x = 240, y = 304, mat = "?wall" }
      { x = 224, y = 352, mat = "?wall" }
      { x = 160, y = 352, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x = 144, y = 304, mat = "?wall" }
      { x = 240, y = 304, mat = "?wall" }
      { x = 224, y = 352, mat = "?wall" }
      { x = 160, y = 352, mat = "?wall" }
      { b = 128, mat = "?ceil", light_add=24 }
    }

    {
      { x = 336, y = 232, mat = "?wall" }
      { x = 352, y = 192, mat = "?wall" }
      { x = 384, y = 192, mat = "?outer" }
      { x = 384, y = 224, mat = "?wall" }
      { t = "?east_h", mat = "?floor" }
    }
    {
      { x = 336, y = 232, mat = "?wall" }
      { x = 352, y = 192, mat = "?wall" }
      { x = 384, y = 192, mat = "?outer" }
      { x = 384, y = 224, mat = "?wall" }
      { b = 128, mat = "?ceil" }
    }

    {
      { x = 336, y = 152, mat = "?wall" }
      { x = 384, y = 160, mat = "?outer" }
      { x = 384, y = 192, mat = "?wall" }
      { x = 352, y = 192, mat = "?wall" }
      { t = "?east_h", mat = "?floor" }
    }
    {
      { x = 336, y = 152, mat = "?wall" }
      { x = 384, y = 160, mat = "?outer" }
      { x = 384, y = 192, mat = "?wall" }
      { x = 352, y = 192, mat = "?wall" }
      { b = 128, mat = "?ceil" }
    }

    {
      { x = 304, y = 128, mat = "?niche" }
      { x = 336, y =  88, mat = "?wall" }
      { x = 384, y =  88, mat = "?outer" }
      { x = 384, y = 160, mat = "?wall" }
      { x = 336, y = 152, mat = "?wall" }
    }

    {
      { x = 224, y =   0, mat = "?outer" }
      { x = 304, y =   0, mat = "?wall" }
      { x = 304, y =  64, mat = "?niche" }
      { x = 272, y = 104, mat = "?wall" }
      { x = 240, y =  80, mat = "?wall" }
      { x = 224, y =  32, mat = "?wall" }
    }

    {
      { x = 153, y = 192, mat = "?pillar" }
      { x = 166, y = 166, mat = "?pillar" }
      { x = 192, y = 153, mat = "?pillar" }
      { x = 218, y = 166, mat = "?pillar" }
      { x = 231, y = 192, mat = "?pillar" }
      { x = 218, y = 218, mat = "?pillar" }
      { x = 192, y = 231, mat = "?pillar" }
      { x = 166, y = 218, mat = "?pillar" }
    }

    {
      { x =  48, y = 296, mat = "?wall" }
      { x =  80, y = 256, mat = "?wall" }
      { x = 112, y = 280, mat = "?wall" }
      { x =  80, y = 320, mat = "?wall" }
      { t = 32, mat = "?niche" }
    }
    {
      { x =  48, y = 296, mat = "?wall" }
      { x =  80, y = 256, mat = "?wall" }
      { x = 112, y = 280, mat = "?wall" }
      { x =  80, y = 320, mat = "?wall" }
      { b = 112, mat = "?niche", light_add=64, light_effect="?effect" }
    }

    {
      { x = 272, y = 280, mat = "?wall" }
      { x = 304, y = 256, mat = "?wall" }
      { x = 336, y = 296, mat = "?wall" }
      { x = 304, y = 320, mat = "?wall" }
      { t = 32, mat = "?niche" }
    }
    {
      { x = 272, y = 280, mat = "?wall" }
      { x = 304, y = 256, mat = "?wall" }
      { x = 336, y = 296, mat = "?wall" }
      { x = 304, y = 320, mat = "?wall" }
      { b = 112, mat = "?niche", light_add=64, light_effect="?effect" }
    }

    {
      { x = 304, y = 256, mat = "?wall" }
      { x = 336, y = 232, mat = "?wall" }
      { x = 384, y = 224, mat = "?outer" }
      { x = 384, y = 296, mat = "?wall" }
      { x = 336, y = 296, mat = "?niche" }
    }

    {
      { x = 272, y = 104, mat = "?wall" }
      { x = 304, y =  64, mat = "?wall" }
      { x = 336, y =  88, mat = "?wall" }
      { x = 304, y = 128, mat = "?wall" }
      { t = 32, mat = "?niche" }
    }
    {
      { x = 272, y = 104, mat = "?wall" }
      { x = 304, y =  64, mat = "?wall" }
      { x = 336, y =  88, mat = "?wall" }
      { x = 304, y = 128, mat = "?wall" }
      { b = 112, mat = "?niche", light_add=64, light_effect="?effect" }
    }

    {
      { x =   0, y =  88, mat = "?wall" }
      { x =  48, y =  88, mat = "?niche" }
      { x =  80, y = 128, mat = "?wall" }
      { x =  48, y = 152, mat = "?wall" }
      { x =   0, y = 160, mat = "?outer" }
    }

    {
      { x =  48, y =  88, mat = "?wall" }
      { x =  80, y =  64, mat = "?wall" }
      { x = 112, y = 104, mat = "?wall" }
      { x =  80, y = 128, mat = "?wall" }
      { t = 32, mat = "?niche" }
    }
    {
      { x =  48, y =  88, mat = "?wall" }
      { x =  80, y =  64, mat = "?wall" }
      { x = 112, y = 104, mat = "?wall" }
      { x =  80, y = 128, mat = "?wall" }
      { b = 112, mat = "?niche", light_add=64, light_effect="?effect" }
    }
  }

  entities =
  {
    { ent = "?torch_ent", x =  80, y = 288, z = 32, angle = 315 }
    { ent = "?torch_ent", x = 304, y = 288, z = 32, angle = 225 }
    { ent = "?torch_ent", x = 304, y =  96, z = 32, angle = 135 }
    { ent = "?torch_ent", x =  80, y =  96, z = 32, angle = 45 }
  }
}


----------------------------------------------------------------


PREFAB.HALL_CAVEY_I =
{
  fitted = "xy"

  brushes =
  {
    {
      { x =   0, y =  32, mat = "ASHWALL4" }
      { x =  16, y =  48, mat = "ASHWALL4" }
      { x =  40, y = 160, mat = "ASHWALL4" }
      { x =  32, y = 192, mat = "BLAKWAL1" }
      { x =   0, y = 192, mat = "BLAKWAL1" }
    }

    {
      { x =  16, y =  48, mat = "ASHWALL4" }
      { x = 144, y =  32, mat = "ASHWALL4" }
      { x = 160, y =  48, mat = "ASHWALL4" }
      { x = 128, y = 128, mat = "ASHWALL4" }
      { x =  40, y = 160, mat = "ASHWALL4" }
      { t = 0, mat = "RROCK04" }
    }
    {
      { x =  16, y =  48, mat = "ASHWALL4" }
      { x = 144, y =  32, mat = "ASHWALL4" }
      { x = 160, y =  48, mat = "ASHWALL4" }
      { x = 128, y = 128, mat = "ASHWALL4" }
      { x =  40, y = 160, mat = "ASHWALL4" }
      { b = 112, mat = "FLAT5_8" }
    }

    {
      { x =  16, y =  48, mat = "ASHWALL4" }
      { x =  32, y =   0, mat = "BLAKWAL1" }
      { x = 160, y =   0, mat = "ASHWALL4" }
      { x = 144, y =  32, mat = "ASHWALL4" }
      { t = 0, mat = "RROCK04" }
    }
    {
      { x =  16, y =  48, mat = "ASHWALL4" }
      { x =  32, y =   0, mat = "BLAKWAL1" }
      { x = 160, y =   0, mat = "ASHWALL4" }
      { x = 144, y =  32, mat = "ASHWALL4" }
      { b = 112, mat = "FLAT5_8" }
    }

    {
      { x = 144, y =  32, mat = "ASHWALL4" }
      { x = 160, y =   0, mat = "BLAKWAL1" }
      { x = 192, y =   0, mat = "BLAKWAL1" }
      { x = 192, y =  32, mat = "ASHWALL4" }
      { x = 160, y =  48, mat = "ASHWALL4" }
    }

    {
      { x = 128, y = 128, mat = "ASHWALL4" }
      { x = 160, y =  48, mat = "ASHWALL4" }
      { x = 192, y =  32, mat = "BLAKWAL1" }
      { x = 192, y = 192, mat = "BLAKWAL1" }
      { x = 160, y = 192, mat = "ASHWALL4" }
    }

    {
      { x =   0, y =   0, mat = "BLAKWAL1" }
      { x =  32, y =   0, mat = "ASHWALL4" }
      { x =  16, y =  48, mat = "ASHWALL4" }
      { x =   0, y =  32, mat = "BLAKWAL1" }
    }

    {
      { x =  32, y = 192, mat = "ASHWALL4" }
      { x =  40, y = 160, mat = "ASHWALL4" }
      { x = 128, y = 128, mat = "ASHWALL4" }
      { x = 160, y = 192, mat = "BLAKWAL1" }
      { t = 0, mat = "RROCK04" }
    }
    {
      { x =  32, y = 192, mat = "ASHWALL4" }
      { x =  40, y = 160, mat = "ASHWALL4" }
      { x = 128, y = 128, mat = "ASHWALL4" }
      { x = 160, y = 192, mat = "BLAKWAL1" }
      { b = 112, mat = "FLAT5_8" }
    }
  }
}


PREFAB.HALL_CAVEY_C =
{
  fitted = "xy"

  brushes =
  {
    {
      { x =   0, y = 160, mat = "ASHWALL4" }
      { x =  64, y = 128, mat = "ASHWALL4" }
      { x =  96, y = 160, mat = "STARTAN3" }
      { x =  96, y = 192, mat = "BLAKWAL1" }
      { x =   0, y = 192, mat = "BLAKWAL1" }
    }

    {
      { x =  64, y = 128, mat = "STARTAN3" }
      { x = 160, y = 112, mat = "ASHWALL4" }
      { x = 160, y = 144, mat = "ASHWALL4" }
      { x =  96, y = 160, mat = "ASHWALL4" }
      { t = 0, mat = "RROCK04" }
    }
    {
      { x =  64, y = 128, mat = "STARTAN3" }
      { x = 160, y = 112, mat = "ASHWALL4" }
      { x = 160, y = 144, mat = "ASHWALL4" }
      { x =  96, y = 160, mat = "ASHWALL4" }
      { b = 112, mat = "FLAT5_8" }
    }

    {
      { x = 160, y = 112, mat = "ASHWALL4" }
      { x = 184, y =  64, mat = "ASHWALL4" }
      { x = 192, y =  64, mat = "BLAKWAL1" }
      { x = 192, y = 192, mat = "ASHWALL4" }
      { x = 160, y = 144, mat = "ASHWALL4" }
    }

    {
      { x =  32, y =   0, mat = "BLAKWAL1" }
      { x = 160, y =   0, mat = "ASHWALL4" }
      { x = 184, y =  64, mat = "ASHWALL4" }
      { x =  48, y =  32, mat = "ASHWALL4" }
      { t = 0, mat = "RROCK04" }
    }
    {
      { x =  32, y =   0, mat = "BLAKWAL1" }
      { x = 160, y =   0, mat = "ASHWALL4" }
      { x = 184, y =  64, mat = "ASHWALL4" }
      { x =  48, y =  32, mat = "ASHWALL4" }
      { b = 112, mat = "FLAT5_8" }
    }

    {
      { x =   0, y =   0, mat = "BLAKWAL1" }
      { x =  32, y =   0, mat = "ASHWALL4" }
      { x =  48, y =  32, mat = "ASHWALL4" }
      { x =  32, y =  48, mat = "ASHWALL4" }
      { x =   0, y =  32, mat = "BLAKWAL1" }
    }

    {
      { x =   0, y =  32, mat = "ASHWALL4" }
      { x =  32, y =  48, mat = "ASHWALL4" }
      { x =  64, y = 128, mat = "ASHWALL4" }
      { x =   0, y = 160, mat = "BLAKWAL1" }
      { t = 0, mat = "RROCK04" }
    }
    {
      { x =   0, y =  32, mat = "ASHWALL4" }
      { x =  32, y =  48, mat = "ASHWALL4" }
      { x =  64, y = 128, mat = "ASHWALL4" }
      { x =   0, y = 160, mat = "BLAKWAL1" }
      { b = 112, mat = "FLAT5_8" }
    }

    {
      { x = 160, y =   0, mat = "BLAKWAL1" }
      { x = 192, y =   0, mat = "BLAKWAL1" }
      { x = 192, y =  64, mat = "ASHWALL4" }
      { x = 184, y =  64, mat = "ASHWALL4" }
    }

    {
      { x =  96, y = 160, mat = "ASHWALL4" }
      { x = 160, y = 144, mat = "ASHWALL4" }
      { x = 192, y = 192, mat = "BLAKWAL1" }
      { x =  96, y = 192, mat = "STARTAN3" }
    }

    {
      { x =  32, y =  48, mat = "ASHWALL4" }
      { x =  48, y =  32, mat = "ASHWALL4" }
      { x = 184, y =  64, mat = "ASHWALL4" }
      { x = 160, y = 112, mat = "STARTAN3" }
      { x =  64, y = 128, mat = "ASHWALL4" }
      { t = 0, mat = "RROCK04" }
    }
    {
      { x =  32, y =  48, mat = "ASHWALL4" }
      { x =  48, y =  32, mat = "ASHWALL4" }
      { x = 184, y =  64, mat = "ASHWALL4" }
      { x = 160, y = 112, mat = "STARTAN3" }
      { x =  64, y = 128, mat = "ASHWALL4" }
      { b = 112, mat = "FLAT5_8" }
    }
  }
}


PREFAB.HALL_CAVEY_T =
{
  fitted = "xy"

  brushes =
  {
    {
      { x =   0, y = 160, mat = "ASHWALL4" }
      { x =  48, y = 184, mat = "ASHWALL4" }
      { x =  48, y = 192, mat = "BLAKWAL1" }
      { x =   0, y = 192, mat = "BLAKWAL1" }
    }

    {
      { x =   0, y =  32, mat = "ASHWALL4" }
      { x =  32, y =   0, mat = "BLAKWAL1" }
      { x = 160, y =   0, mat = "ASHWALL4" }
      { x = 144, y =  32, mat = "STARTAN3" }
      { t = 0, mat = "RROCK04" }
    }
    {
      { x =   0, y =  32, mat = "ASHWALL4" }
      { x =  32, y =   0, mat = "BLAKWAL1" }
      { x = 160, y =   0, mat = "ASHWALL4" }
      { x = 144, y =  32, mat = "STARTAN3" }
      { b = 112, mat = "FLAT5_8" }
    }

    {
      { x = 144, y =  32, mat = "ASHWALL4" }
      { x = 160, y =   0, mat = "BLAKWAL1" }
      { x = 192, y =   0, mat = "BLAKWAL1" }
      { x = 192, y =  32, mat = "ASHWALL4" }
      { x = 160, y =  48, mat = "ASHWALL4" }
    }

    {
      { x = 160, y =  48, mat = "ASHWALL4" }
      { x = 192, y =  32, mat = "BLAKWAL1" }
      { x = 192, y = 160, mat = "ASHWALL4" }
      { x = 160, y = 144, mat = "ASHWALL4" }
      { t = 0, mat = "RROCK04" }
    }
    {
      { x = 160, y =  48, mat = "ASHWALL4" }
      { x = 192, y =  32, mat = "BLAKWAL1" }
      { x = 192, y = 160, mat = "ASHWALL4" }
      { x = 160, y = 144, mat = "ASHWALL4" }
      { b = 112, mat = "FLAT5_8" }
    }

    {
      { x =   0, y =   0, mat = "BLAKWAL1" }
      { x =  32, y =   0, mat = "ASHWALL4" }
      { x =   0, y =  32, mat = "BLAKWAL1" }
    }

    {
      { x =   0, y =  32, mat = "STARTAN3" }
      { x = 144, y =  32, mat = "ASHWALL4" }
      { x = 160, y =  48, mat = "ASHWALL4" }
      { x = 160, y = 144, mat = "ASHWALL4" }
      { x =  48, y = 184, mat = "ASHWALL4" }
      { x =   0, y = 160, mat = "BLAKWAL1" }
      { t = 0, mat = "RROCK04" }
    }
    {
      { x =   0, y =  32, mat = "STARTAN3" }
      { x = 144, y =  32, mat = "ASHWALL4" }
      { x = 160, y =  48, mat = "ASHWALL4" }
      { x = 160, y = 144, mat = "ASHWALL4" }
      { x =  48, y = 184, mat = "ASHWALL4" }
      { x =   0, y = 160, mat = "BLAKWAL1" }
      { b = 112, mat = "FLAT5_8" }
    }

    {
      { x = 160, y = 144, mat = "ASHWALL4" }
      { x = 192, y = 160, mat = "BLAKWAL1" }
      { x = 192, y = 192, mat = "BLAKWAL1" }
      { x = 160, y = 192, mat = "ASHWALL4" }
    }

    {
      { x =  48, y = 184, mat = "ASHWALL4" }
      { x = 160, y = 144, mat = "ASHWALL4" }
      { x = 160, y = 192, mat = "BLAKWAL1" }
      { x =  48, y = 192, mat = "ASHWALL4" }
    }
  }
}


PREFAB.HALL_CAVEY_P =
{
  fitted = "xy"

  brushes =
  {
    {
      { x =   0, y =   0, mat = "BLAKWAL1" }
      { x =  32, y =   0, mat = "ASHWALL4" }
      { x =  48, y =  32, mat = "ASHWALL4" }
      { x =   0, y =  48, mat = "BLAKWAL1" }
    }

    {
      { x = 160, y =   0, mat = "ASHWALL4" }
      { x = 192, y =  32, mat = "BLAKWAL1" }
      { x = 192, y = 160, mat = "ASHWALL4" }
      { x = 160, y = 128, mat = "STARTAN3" }
      { t = 0, mat = "RROCK04" }
    }
    {
      { x = 160, y =   0, mat = "ASHWALL4" }
      { x = 192, y =  32, mat = "BLAKWAL1" }
      { x = 192, y = 160, mat = "ASHWALL4" }
      { x = 160, y = 128, mat = "STARTAN3" }
      { b = 112, mat = "FLAT5_8" }
    }

    {
      { x = 136, y = 136, mat = "ASHWALL4" }
      { x = 160, y = 128, mat = "ASHWALL4" }
      { x = 192, y = 160, mat = "BLAKWAL1" }
      { x = 192, y = 192, mat = "BLAKWAL1" }
      { x = 160, y = 192, mat = "ASHWALL4" }
      { x = 136, y = 168, mat = "ASHWALL4" }
    }

    {
      { x =  24, y = 168, mat = "ASHWALL4" }
      { x =  48, y =  32, mat = "STARTAN3" }
      { x = 136, y =  32, mat = "STARTAN3" }
      { x = 136, y = 136, mat = "ASHWALL4" }
      { x = 136, y = 168, mat = "ASHWALL4" }
      { t = 0, mat = "RROCK04" }
    }
    {
      { x =  24, y = 168, mat = "ASHWALL4" }
      { x =  48, y =  32, mat = "STARTAN3" }
      { x = 136, y =  32, mat = "STARTAN3" }
      { x = 136, y = 136, mat = "ASHWALL4" }
      { x = 136, y = 168, mat = "ASHWALL4" }
      { b = 112, mat = "FLAT5_8" }
    }

    {
      { x = 160, y =   0, mat = "BLAKWAL1" }
      { x = 192, y =   0, mat = "BLAKWAL1" }
      { x = 192, y =  32, mat = "ASHWALL4" }
    }

    {
      { x =  32, y =   0, mat = "BLAKWAL1" }
      { x = 160, y =   0, mat = "STARTAN3" }
      { x = 160, y =  32, mat = "STARTAN3" }
      { x =  48, y =  32, mat = "ASHWALL4" }
      { t = 0, mat = "RROCK04" }
    }
    {
      { x =  32, y =   0, mat = "BLAKWAL1" }
      { x = 160, y =   0, mat = "STARTAN3" }
      { x = 160, y =  32, mat = "STARTAN3" }
      { x =  48, y =  32, mat = "ASHWALL4" }
      { b = 112, mat = "FLAT5_8" }
    }

    {
      { x =   0, y = 160, mat = "ASHWALL4" }
      { x =  24, y = 168, mat = "ASHWALL4" }
      { x =  32, y = 192, mat = "BLAKWAL1" }
      { x =   0, y = 192, mat = "BLAKWAL1" }
    }

    {
      { x =   0, y =  48, mat = "ASHWALL4" }
      { x =  48, y =  32, mat = "ASHWALL4" }
      { x =  24, y = 168, mat = "ASHWALL4" }
      { x =   0, y = 160, mat = "BLAKWAL1" }
      { t = 0, mat = "RROCK04" }
    }
    {
      { x =   0, y =  48, mat = "ASHWALL4" }
      { x =  48, y =  32, mat = "ASHWALL4" }
      { x =  24, y = 168, mat = "ASHWALL4" }
      { x =   0, y = 160, mat = "BLAKWAL1" }
      { b = 112, mat = "FLAT5_8" }
    }

    {
      { x = 136, y =  32, mat = "STARTAN3" }
      { x = 160, y =  32, mat = "STARTAN3" }
      { x = 160, y = 128, mat = "ASHWALL4" }
      { x = 136, y = 136, mat = "STARTAN3" }
      { t = 0, mat = "RROCK04" }
    }
    {
      { x = 136, y =  32, mat = "STARTAN3" }
      { x = 160, y =  32, mat = "STARTAN3" }
      { x = 160, y = 128, mat = "ASHWALL4" }
      { x = 136, y = 136, mat = "STARTAN3" }
      { b = 112, mat = "FLAT5_8" }
    }

    {
      { x =  24, y = 168, mat = "ASHWALL4" }
      { x = 136, y = 168, mat = "ASHWALL4" }
      { x = 160, y = 192, mat = "BLAKWAL1" }
      { x =  32, y = 192, mat = "ASHWALL4" }
      { t = 0, mat = "RROCK04" }
    }
    {
      { x =  24, y = 168, mat = "ASHWALL4" }
      { x = 136, y = 168, mat = "ASHWALL4" }
      { x = 160, y = 192, mat = "BLAKWAL1" }
      { x =  32, y = 192, mat = "ASHWALL4" }
      { b = 112, mat = "FLAT5_8" }
    }
  }
}


PREFAB.HALL_CAVEY_I_STAIR =
{
  fitted = "xy"

  z_ranges = { {60,0,"?stair_h"}, {96,0} }

  brushes =
  {
    {
      { x =   0, y = 128, mat = "STARTAN3" }
      { x =  16, y = 128, mat = "ASHWALL4" }
      { x =  32, y = 152, mat = "ASHWALL4" }
      { x =  32, y = 192, mat = "BLAKWAL1" }
      { x =   0, y = 192, mat = "BLAKWAL1" }
    }

    {
      { x =  24, y =  16, mat = "ZIMMER3" }
      { x =  72, y =  32, mat = "STARTAN3" }
      { x =  88, y =  48, mat = "ASHWALL7" }
      { x =  40, y =  64, mat = "ASHWALL4" }
      { t = 12, mat = "RROCK04" }
    }
    {
      { x =  24, y =  16, mat = "ASHWALL" }
      { x =  72, y =  32, mat = "ASHWALL" }
      { x =  88, y =  48, mat = "ASHWALL" }
      { x =  40, y =  64, mat = "ASHWALL" }
      { b = 124, mat = "FLAT5_8" }
    }

    {
      { x =   0, y =  32, mat = "ASHWALL4" }
      { x =  24, y =  16, mat = "ASHWALL4" }
      { x =  40, y =  64, mat = "ASHWALL4" }
      { x =  32, y =  96, mat = "ASHWALL4" }
      { x =  16, y = 128, mat = "STARTAN3" }
      { x =   0, y = 128, mat = "BLAKWAL1" }
    }

    {
      { x = 120, y =   0, mat = "BLAKWAL1" }
      { x = 160, y =   0, mat = "ASHWALL4" }
      { x = 168, y =  32, mat = "ASHWALL7" }
      { x = 120, y =  16, mat = "STARTAN3" }
      { t = 0, mat = "RROCK04" }
    }
    {
      { x = 120, y =   0, mat = "BLAKWAL1" }
      { x = 160, y =   0, mat = "ASHWALL4" }
      { x = 168, y =  32, mat = "ASHWALL" }
      { x = 120, y =  16, mat = "STARTAN3" }
      { b = 112, mat = "FLAT5_8" }
    }

    {
      { x = 160, y =   0, mat = "BLAKWAL1" }
      { x = 192, y =   0, mat = "BLAKWAL1" }
      { x = 192, y =  32, mat = "ASHWALL4" }
      { x = 168, y =  32, mat = "ASHWALL4" }
    }

    {
      { x = 144, y =  56, mat = "ASHWALL4" }
      { x = 168, y =  32, mat = "ASHWALL4" }
      { x = 192, y =  32, mat = "BLAKWAL1" }
      { x = 192, y = 128, mat = "STARTAN3" }
      { x = 176, y = 128, mat = "ASHWALL4" }
      { x = 152, y = 104, mat = "ASHWALL4" }
    }

    {
      { x =   0, y =   0, mat = "BLAKWAL1" }
      { x =  32, y =   0, mat = "ASHWALL4" }
      { x =  24, y =  16, mat = "ASHWALL4" }
      { x =   0, y =  32, mat = "BLAKWAL1" }
    }

    {
      { x = 144, y = 160, mat = "ASHWALL4" }
      { x = 176, y = 128, mat = "STARTAN3" }
      { x = 192, y = 128, mat = "BLAKWAL1" }
      { x = 192, y = 192, mat = "BLAKWAL1" }
      { x = 160, y = 192, mat = "ASHWALL4" }
    }

    {
      { x =  64, y = 176, mat = "ZIMMER3" }
      { x = 112, y = 152, mat = "ZIMMER3" }
      { x = 144, y = 160, mat = "ASHWALL4" }
      { x = 160, y = 192, mat = "BLAKWAL1" }
      { x =  64, y = 192, mat = "STARTAN3" }
      { t = 60, mat = "RROCK04" }
    }
    {
      { x =  64, y = 176, mat = "ASHWALL" }
      { x = 112, y = 152, mat = "ASHWALL" }
      { x = 144, y = 160, mat = "ASHWALL4" }
      { x = 160, y = 192, mat = "BLAKWAL1" }
      { x =  64, y = 192, mat = "STARTAN3" }
      { b = 172, mat = "FLAT5_8" }
    }

    {
      { x =  24, y =  16, mat = "ASHWALL4" }
      { x =  32, y =   0, mat = "BLAKWAL1" }
      { x = 120, y =   0, mat = "STARTAN3" }
      { x = 120, y =  16, mat = "ASHWALL7" }
      { x =  72, y =  32, mat = "ASHWALL7" }
      { t = 0, mat = "RROCK04" }
    }
    {
      { x =  24, y =  16, mat = "ASHWALL4" }
      { x =  32, y =   0, mat = "BLAKWAL1" }
      { x = 120, y =   0, mat = "STARTAN3" }
      { x = 120, y =  16, mat = "ASHWALL" }
      { x =  72, y =  32, mat = "ASHWALL" }
      { b = 112, mat = "FLAT5_8" }
    }

    {
      { x =  80, y = 112, mat = "ZIMMER3" }
      { x = 176, y = 128, mat = "ASHWALL4" }
      { x = 144, y = 160, mat = "ASHWALL7" }
      { x = 112, y = 152, mat = "STARTAN3" }
      { t = 48, mat = "RROCK04" }
    }
    {
      { x =  80, y = 112, mat = "ASHWALL" }
      { x = 176, y = 128, mat = "ASHWALL" }
      { x = 144, y = 160, mat = "ASHWALL" }
      { x = 112, y = 152, mat = "ASHWALL" }
      { b = 160, mat = "FLAT5_8" }
    }

    {
      { x =  32, y = 152, mat = "ZIMMER3" }
      { x =  64, y = 176, mat = "STARTAN3" }
      { x =  64, y = 192, mat = "BLAKWAL1" }
      { x =  32, y = 192, mat = "ASHWALL4" }
      { t = 60, mat = "RROCK04" }
    }
    {
      { x =  32, y = 152, mat = "ASHWALL" }
      { x =  64, y = 176, mat = "STARTAN3" }
      { x =  64, y = 192, mat = "BLAKWAL1" }
      { x =  32, y = 192, mat = "ASHWALL4" }
      { b = 172, mat = "FLAT5_8" }
    }

    {
      { x =  16, y = 128, mat = "ZIMMER3" }
      { x =  80, y = 112, mat = "STARTAN3" }
      { x = 112, y = 152, mat = "ASHWALL7" }
      { x =  64, y = 176, mat = "ASHWALL7" }
      { x =  32, y = 152, mat = "ASHWALL4" }
      { t = 48, mat = "RROCK04" }
    }
    {
      { x =  16, y = 128, mat = "ASHWALL" }
      { x =  80, y = 112, mat = "ASHWALL" }
      { x = 112, y = 152, mat = "ASHWALL" }
      { x =  64, y = 176, mat = "ASHWALL" }
      { x =  32, y = 152, mat = "ASHWALL" }
      { b = 156, mat = "FLAT5_8" }
    }

    {
      { x =  80, y = 112, mat = "STARTAN3" }
      { x = 104, y =  80, mat = "ZIMMER3" }
      { x = 152, y = 104, mat = "ASHWALL4" }
      { x = 176, y = 128, mat = "ASHWALL7" }
      { t = 36, mat = "RROCK04" }
    }
    {
      { x =  80, y = 112, mat = "ASHWALL" }
      { x = 104, y =  80, mat = "ASHWALL" }
      { x = 152, y = 104, mat = "ASHWALL" }
      { x = 176, y = 128, mat = "ASHWALL" }
      { b = 148, mat = "FLAT5_8" }
    }

    {
      { x =  16, y = 128, mat = "ASHWALL4" }
      { x =  32, y =  96, mat = "ZIMMER3" }
      { x = 104, y =  80, mat = "STARTAN3" }
      { x =  80, y = 112, mat = "ASHWALL7" }
      { t = 36, mat = "RROCK04" }
    }
    {
      { x =  16, y = 128, mat = "ASHWALL" }
      { x =  32, y =  96, mat = "ASHWALL" }
      { x = 104, y =  80, mat = "ASHWALL" }
      { x =  80, y = 112, mat = "ASHWALL" }
      { b = 156, mat = "FLAT5_8" }
    }

    {
      { x =  88, y =  48, mat = "ZIMMER3" }
      { x = 144, y =  56, mat = "ASHWALL4" }
      { x = 152, y = 104, mat = "ASHWALL7" }
      { x = 104, y =  80, mat = "STARTAN3" }
      { t = 24, mat = "RROCK04" }
    }
    {
      { x =  88, y =  48, mat = "ASHWALL" }
      { x = 144, y =  56, mat = "ASHWALL" }
      { x = 152, y = 104, mat = "ASHWALL" }
      { x = 104, y =  80, mat = "ASHWALL" }
      { b = 124, mat = "FLAT5_8" }
    }

    {
      { x =  32, y =  96, mat = "ASHWALL4" }
      { x =  40, y =  64, mat = "ZIMMER3" }
      { x =  88, y =  48, mat = "STARTAN3" }
      { x = 104, y =  80, mat = "ASHWALL7" }
      { t = 24, mat = "RROCK04" }
    }
    {
      { x =  32, y =  96, mat = "ASHWALL" }
      { x =  40, y =  64, mat = "ASHWALL" }
      { x =  88, y =  48, mat = "ASHWALL" }
      { x = 104, y =  80, mat = "ASHWALL" }
      { b = 136, mat = "FLAT5_8" }
    }

    {
      { x =  72, y =  32, mat = "ZIMMER3" }
      { x = 120, y =  16, mat = "ZIMMER3" }
      { x = 168, y =  32, mat = "ASHWALL4" }
      { x = 144, y =  56, mat = "ASHWALL7" }
      { x =  88, y =  48, mat = "STARTAN3" }
      { t = 12, mat = "RROCK04" }
    }
    {
      { x =  72, y =  32, mat = "ASHWALL" }
      { x = 120, y =  16, mat = "ASHWALL" }
      { x = 168, y =  32, mat = "ASHWALL" }
      { x = 144, y =  56, mat = "ASHWALL" }
      { x =  88, y =  48, mat = "ASHWALL" }
      { b = 124, mat = "FLAT5_8" }
    }
  }
}


----------------------------------------------------------------


PREFAB.SKY_HALL_I =
{
  fitted = "xy"

  x_ranges = { {16,0}, {160,1}, {16,0} }

  brushes =
  {
    {
      { x =   0, y =   0, mat = "?outer" }
      { x =  16, y =   0, mat = "?floor" }
      { x =  16, y = 192, mat = "?outer" }
      { x =   0, y = 192, mat = "?outer" }
      { t = 40, mat = "?floor" }
    }

    {
      { x = 176, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y = 192, mat = "?outer" }
      { x = 176, y = 192, mat = "?floor" }
      { t = 40, mat = "?floor" }
    }

    {
      { x =  16, y =   0, mat = "?outer" }
      { x = 176, y =   0, mat = "?floor" }
      { x = 176, y = 192, mat = "?outer" }
      { x =  16, y = 192, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }
  }
}


PREFAB.SKY_HALL_C =
{
  fitted = "xy"

  x_ranges = { {32,0}, {128,1}, {32,0} }
  y_ranges = { {32,0}, {128,1}, {32,0} }

  brushes =
  {
    {
      { x =   0, y = 176, mat = "?floor" }
      { x = 160, y = 176, mat = "?floor" }
      { x = 160, y = 192, mat = "?outer" }
      { x =   0, y = 192, mat = "?outer" }
      { t = 40, mat = "?floor" }
    }

    {
      { x = 176, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y = 160, mat = "?floor" }
      { x = 176, y = 160, mat = "?floor" }
      { t = 40, mat = "?floor" }
    }

    {
      { x =   0, y =   0, mat = "?outer" }
      { x =  16, y =   0, mat = "?floor" }
      { x =  16, y =  16, mat = "?floor" }
      { x =   0, y =  16, mat = "?outer" }
      { t = 40, mat = "?floor" }
    }

    {
      { x = 160, y = 176, mat = "?support" }
      { x = 176, y = 160, mat = "?support" }
      { x = 192, y = 160, mat = "?outer" }
      { x = 192, y = 192, mat = "?outer" }
      { x = 160, y = 192, mat = "?support" }
      { t = 80, mat = "?support" }
    }

    {
      { x =  16, y =   0, mat = "?outer" }
      { x = 176, y =   0, mat = "?floor" }
      { x = 176, y = 160, mat = "?floor" }
      { x = 160, y = 176, mat = "?floor" }
      { x =  16, y = 176, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }

    {
      { x =   0, y =  16, mat = "?floor" }
      { x =  16, y =  16, mat = "?floor" }
      { x =  16, y = 176, mat = "?floor" }
      { x =   0, y = 176, mat = "?outer" }
      { t = 0, mat = "?floor" }
    }
  }

  entities =
  {
    { ent = "?torch_ent", x = 180, y = 180, z = 80, angle = 0 }
  }
}


PREFAB.SKY_HALL_I_STAIR =
{
  fitted = "xy"

  z_ranges = { {60,0,"?stair_h"}, {40,0} }
  x_ranges = { {16,0}, {160,1}, {16,0} }

  defaults =
  {
    step = "?floor"
  }

  brushes =
  {
    {
      { x =   0, y = 112, mat = "?floor" }
      { x =  16, y = 112, mat = "?floor" }
      { x =  16, y = 192, mat = "?outer" }
      { x =   0, y = 192, mat = "?outer" }
      { t = 100, mat = "?floor" }
    }

    {
      { x = 176, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y =  48, mat = "?floor" }
      { x = 176, y =  48, mat = "?floor" }
      { t = 40, mat = "?floor" }
    }

    {
      { x =   0, y =   0, mat = "?outer" }
      { x =  16, y =   0, mat = "?floor" }
      { x =  16, y =  48, mat = "?floor" }
      { x =   0, y =  48, mat = "?outer" }
      { t = 40, mat = "?floor" }
    }

    {
      { x = 176, y = 112, mat = "?floor" }
      { x = 192, y = 112, mat = "?outer" }
      { x = 192, y = 192, mat = "?outer" }
      { x = 176, y = 192, mat = "?floor" }
      { t = 100, mat = "?floor" }
    }

    {
      { x =  16, y = 128, mat = "?step" }
      { x = 176, y = 128, mat = "?floor" }
      { x = 176, y = 192, mat = "?outer" }
      { x =  16, y = 192, mat = "?floor" }
      { t = 60, mat = "?floor" }
    }

    {
      { x =  16, y =   0, mat = "?outer" }
      { x = 176, y =   0, mat = "?floor" }
      { x = 176, y =  64, mat = "?floor" }
      { x =  16, y =  64, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }

    {
      { x =  16, y =  64, mat = "?step" }
      { x = 176, y =  64, mat = "?floor" }
      { x = 176, y =  80, mat = "?floor" }
      { x =  16, y =  80, mat = "?floor" }
      { t = 12, mat = "?floor" }
    }

    {
      { x =   0, y =  64, mat = "?floor" }
      { x =  16, y =  64, mat = "?floor" }
      { x =  16, y =  80, mat = "?floor" }
      { x =   0, y =  80, mat = "?outer" }
      { t = 64, mat = "?floor" }
    }

    {
      { x = 176, y =  64, mat = "?floor" }
      { x = 192, y =  64, mat = "?outer" }
      { x = 192, y =  80, mat = "?floor" }
      { x = 176, y =  80, mat = "?floor" }
      { t = 64, mat = "?floor" }
    }

    {
      { x =  16, y =  80, mat = "?step" }
      { x = 176, y =  80, mat = "?floor" }
      { x = 176, y =  96, mat = "?floor" }
      { x =  16, y =  96, mat = "?floor" }
      { t = 24, mat = "?floor" }
    }

    {
      { x =   0, y =  80, mat = "?floor" }
      { x =  16, y =  80, mat = "?floor" }
      { x =  16, y =  96, mat = "?floor" }
      { x =   0, y =  96, mat = "?outer" }
      { t = 76, mat = "?floor" }
    }

    {
      { x = 176, y =  80, mat = "?floor" }
      { x = 192, y =  80, mat = "?outer" }
      { x = 192, y =  96, mat = "?floor" }
      { x = 176, y =  96, mat = "?floor" }
      { t = 76, mat = "?floor" }
    }

    {
      { x =  16, y =  96, mat = "?step" }
      { x = 176, y =  96, mat = "?floor" }
      { x = 176, y = 112, mat = "?floor" }
      { x =  16, y = 112, mat = "?floor" }
      { t = 36, mat = "?floor" }
    }

    {
      { x =   0, y =  96, mat = "?floor" }
      { x =  16, y =  96, mat = "?floor" }
      { x =  16, y = 112, mat = "?floor" }
      { x =   0, y = 112, mat = "?outer" }
      { t = 88, mat = "?floor" }
    }

    {
      { x = 176, y =  96, mat = "?floor" }
      { x = 192, y =  96, mat = "?outer" }
      { x = 192, y = 112, mat = "?floor" }
      { x = 176, y = 112, mat = "?floor" }
      { t = 88, mat = "?floor" }
    }

    {
      { x =  16, y = 112, mat = "?step" }
      { x = 176, y = 112, mat = "?floor" }
      { x = 176, y = 128, mat = "?floor" }
      { x =  16, y = 128, mat = "?floor" }
      { t = 48, mat = "?floor" }
    }

    {
      { x = 176, y =  48, mat = "?floor" }
      { x = 192, y =  48, mat = "?outer" }
      { x = 192, y =  64, mat = "?floor" }
      { x = 176, y =  64, mat = "?floor" }
      { t = 52, mat = "?floor" }
    }

    {
      { x =   0, y =  48, mat = "?floor" }
      { x =  16, y =  48, mat = "?floor" }
      { x =  16, y =  64, mat = "?floor" }
      { x =   0, y =  64, mat = "?outer" }
      { t = 52, mat = "?floor" }
    }
  }
}


----------------------------------------------------------------


PREFAB.SECRET_MINI =
{
  fitted = "xy"

  x_ranges = { {16,1}, {160,0}, {16,1} }
  y_ranges = { {64,0}, {64,1},  {64,0} }

  defaults =
  {
    special = 23
  }

  brushes =
  {
    {
      { x =   0, y = 176, mat = "?wall" }
      { x =  16, y = 176, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { x =   0, y = 192, mat = "?wall" }
    }

    {
      { x = 176, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y =  16, mat = "?wall" }
      { x = 176, y =  16, mat = "?wall" }
    }

    {
      { x =   0, y =   0, mat = "?wall" }
      { x =  16, y =   0, mat = "?wall" }
      { x =  16, y =  16, mat = "?wall" }
      { x =   0, y =  16, mat = "?wall" }
    }

    {
      { x = 176, y = 176, mat = "?wall" }
      { x = 192, y = 176, mat = "?wall" }
      { x = 192, y = 192, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
    }

    {
      { x =  16, y = 176, mat = "?wall" }
      { x = 176, y = 176, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { t = 16, mat = "?wall" }
    }
    {
      { x =  16, y = 176, mat = "?wall" }
      { x = 176, y = 176, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { b = 176, mat = "?wall", light_add=16 }
    }

    {
      { x =  16, y =   0, mat = "?wall" }
      { x = 176, y =   0, mat = "?wall" }
      { x = 176, y =  16, mat = "?wall" }
      { x =  16, y =  16, mat = "?wall" }
      { t = 16, mat = "?wall" }
    }
    {
      { x =  16, y =   0, mat = "?wall" }
      { x = 176, y =   0, mat = "?wall" }
      { x = 176, y =  16, mat = "?wall" }
      { x =  16, y =  16, mat = "?wall" }
      { b = 176, mat = "?wall", light_add=16 }
    }

    {
      { x =   0, y =  16, mat = "?wall" }
      { x =  16, y =  16, mat = "?metal" }
      { x =  32, y =  16, mat = "?metal" }
      { x =  32, y =  32, mat = "?inner" }
      { x =  32, y = 160, mat = "?metal" }
      { x =  32, y = 176, mat = "?metal" }
      { x =  16, y = 176, mat = "?wall" }
      { x =   0, y = 176, mat = "?wall" }
    }

    {
      { x =  32, y =  16, mat = "?metal" }
      { x = 160, y =  16, mat = "?wall" }
      { x = 160, y =  32, mat = "?wall" }
      { x =  32, y =  32, mat = "?wall" }
      { t = 32, mat = "?metal", light_add=32 }
    }
    {
      { x =  32, y =  16, mat = "?metal" }
      { x = 160, y =  16, mat = "?wall" }
      { x = 160, y =  32, mat = "?wall" }
      { x =  32, y =  32, mat = "?wall" }
      { b = 160, mat = "?metal" }
    }

    {
      { x =  32, y =  32, mat = "?pic", special="?special", tag="?tag", x_offset=0, y_offset=0, peg=1 }
      { x = 160, y =  32, mat = "?pic" }
      { x = 160, y = 160, mat = "?pic", special="?special", tag="?tag", x_offset=0, y_offset=0, peg=1 }
      { x =  32, y = 160, mat = "?pic" }
      { t = 152, delta_z = 8, mat = "?inner", tag="?tag", special=9 }
    }
    {
      { x =  32, y =  32, mat = "?wall" }
      { x = 160, y =  32, mat = "?wall" }
      { x = 160, y = 160, mat = "?wall" }
      { x =  32, y = 160, mat = "?wall" }
      { b = 160, mat = "?inner" }
    }

    {
      { x = 160, y =  16, mat = "?metal" }
      { x = 176, y =  16, mat = "?wall" }
      { x = 192, y =  16, mat = "?wall" }
      { x = 192, y = 176, mat = "?wall" }
      { x = 176, y = 176, mat = "?metal" }
      { x = 160, y = 176, mat = "?metal" }
      { x = 160, y = 160, mat = "?inner" }
      { x = 160, y =  32, mat = "?metal" }
    }

    {
      { x =  32, y = 160, mat = "?wall" }
      { x = 160, y = 160, mat = "?wall" }
      { x = 160, y = 176, mat = "?metal" }
      { x =  32, y = 176, mat = "?wall" }
      { t = 32, mat = "?metal" }
    }
    {
      { x =  32, y = 160, mat = "?wall" }
      { x = 160, y = 160, mat = "?wall" }
      { x = 160, y = 176, mat = "?metal" }
      { x =  32, y = 176, mat = "?wall" }
      { b = 160, mat = "?metal", light_add=32 }
    }
  }
}

