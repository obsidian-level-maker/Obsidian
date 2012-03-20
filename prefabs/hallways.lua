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
      { x =   0, y =   0, mat = "?wall" }
      { x =  16, y =   0, mat = "?wall", y_offset=0 }
      { x =  16, y = 192, mat = "?wall" }
      { x =   0, y = 192, mat = "?outer" }
    }

    -- right wall
    {
      { x = 176, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y = 192, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall", y_offset=0 }
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
      { x = 176, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y = 192, mat = "?wall" }
      { x = 176, y = 176, mat = "?wall", y_offset=0 }
    }

    -- north wall
    {
      { x =   0, y = 176, mat = "?wall", y_offset=0 }
      { x = 176, y = 176, mat = "?wall" }
      { x = 192, y = 192, mat = "?outer" }
      { x =   0, y = 192, mat = "?wall" }
    }

    -- little SW corner piece
    {
      { x =  0, y =   0, mat = "?wall", y_offset=0 }
      { x = 16, y =   0, mat = "?wall", y_offset=0 }
      { x = 16, y =  16, mat = "?wall", y_offset=0 }
      { x =  0, y =  16, mat = "?wall", y_offset=0 }
    }

    -- floor
    {
      { x =   0, y =   0, mat = "?wall" }
      { x = 176, y =   0, mat = "?wall" }
      { x = 176, y = 176, mat = "?wall" }
      { x =   0, y = 176, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }

    -- ceiling
    {
      { x =   0, y =   0, mat = "?wall" }
      { x = 176, y =   0, mat = "?wall" }
      { x = 176, y = 176, mat = "?wall" }
      { x =   0, y = 176, mat = "?wall" }
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
      { x = 192, y = 176, mat = "?wall" }
      { x = 192, y = 192, mat = "?outer" }
      { x =   0, y = 192, mat = "?wall" }
    }

    -- corner pieces
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

  defaults =
  {
    step = "?floor"
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
      { x = 176, y = 192, mat = "?wall" }
      { x =  16, y = 192, mat = "?ceil" }
      { b = 188, mat = "?ceil" }
    }
  }
}


PREFAB.HALL_BASIC_I_LIFT =
{
  fitted = "xy"

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
  z_ranges = { {256,1} }

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
      { b = 288, mat = "?hole" }
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
      { x =  80, y = 280, mat = "?floor" }
      { x = 160, y = 264, mat = "?floor" }
      { x = 248, y = 312, mat = "?floor" }
      { x = 248, y = 400, mat = "?floor" }
      { x = 160, y = 456, mat = "?floor" }
      { x =  80, y = 416, mat = "?floor" }
      { x =  56, y = 360, mat = "?floor" }
      { t = 0, mat = "?floor" }
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
      { x = 296, y =  88, mat = "?floor" }
      { x = 384, y =  72, mat = "?floor" }
      { x = 432, y = 128, mat = "?floor" }
      { x = 432, y = 200, mat = "?floor" }
      { x = 360, y = 248, mat = "?floor" }
      { x = 280, y = 232, mat = "?floor" }
      { x = 264, y = 160, mat = "?floor" }
      { t = 0, mat = "?floor" }
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


----------------------------------------------------------------


PREFAB.HALL_THIN_I =
{
  fitted = "xy"

  x_ranges = { {64,1}, {64,0}, {64,1} }

  brushes =
  {
    {
      { x =  64, y =   0, mat = "?wall" }
      { x = 128, y =   0, mat = "?wall" }
      { x = 128, y = 192, mat = "?wall" }
      { x =  64, y = 192, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  64, y =   0, mat = "?wall" }
      { x = 128, y =   0, mat = "?wall" }
      { x = 128, y = 192, mat = "?wall" }
      { x =  64, y = 192, mat = "?wall" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x = 128, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y = 192, mat = "?wall" }
      { x = 128, y = 192, mat = "?wall" }
    }

    {
      { x =   0, y =   0, mat = "?wall" }
      { x =  64, y =   0, mat = "?wall" }
      { x =  64, y = 192, mat = "?wall" }
      { x =   0, y = 192, mat = "?wall" }
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
      { x =  64, y = 192, mat = "?wall" }
      { x =   0, y = 192, mat = "?wall" }
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
      { x = 192, y =  64, mat = "?wall" }
      { x = 192, y = 192, mat = "?wall" }
    }

    {
      { x =  64, y =   0, mat = "?wall" }
      { x = 128, y =   0, mat = "?wall" }
      { x = 128, y =  64, mat = "?wall" }
      { x =  64, y =  24, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  64, y =   0, mat = "?wall" }
      { x = 128, y =   0, mat = "?wall" }
      { x = 128, y =  64, mat = "?wall" }
      { x =  64, y =  24, mat = "?wall" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x =   0, y =   0, mat = "?wall" }
      { x =  64, y =   0, mat = "?wall" }
      { x =  64, y =  24, mat = "?wall" }
      { x =  50, y =  50, mat = "?wall" }
      { x =  24, y =  64, mat = "?wall" }
      { x =   0, y =  64, mat = "?wall" }
    }

    {
      { x =   0, y =  64, mat = "?wall" }
      { x =  24, y =  64, mat = "?wall" }
      { x =  64, y = 128, mat = "?wall" }
      { x =   0, y = 128, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =   0, y =  64, mat = "?wall" }
      { x =  24, y =  64, mat = "?wall" }
      { x =  64, y = 128, mat = "?wall" }
      { x =   0, y = 128, mat = "?wall" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x = 128, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y =  64, mat = "?wall" }
      { x = 128, y =  64, mat = "?wall" }
    }

    {
      { x =  64, y = 128, mat = "?wall" }
      { x = 108, y = 108, mat = "?wall" }
      { x = 192, y = 192, mat = "?wall" }
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

  brushes =
  {
    {
      { x =   0, y = 128, mat = "?wall" }
      { x =  50, y = 128, mat = "?wall" }
      { x =  50, y = 192, mat = "?wall" }
      { x =   0, y = 192, mat = "?wall" }
    }

    {
      { x =  64, y =   0, mat = "?wall" }
      { x = 128, y =   0, mat = "?wall" }
      { x = 128, y =  24, mat = "?wall" }
      { x =  64, y =  24, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  64, y =   0, mat = "?wall" }
      { x = 128, y =   0, mat = "?wall" }
      { x = 128, y =  24, mat = "?wall" }
      { x =  64, y =  24, mat = "?wall" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x =   0, y =   0, mat = "?wall" }
      { x =  64, y =   0, mat = "?wall" }
      { x =  64, y =  24, mat = "?wall" }
      { x =  50, y =  50, mat = "?wall" }
      { x =  24, y =  64, mat = "?wall" }
      { x =   0, y =  64, mat = "?wall" }
    }

    {
      { x =   0, y =  64, mat = "?wall" }
      { x =  24, y =  64, mat = "?wall" }
      { x =  50, y = 128, mat = "?wall" }
      { x =   0, y = 128, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =   0, y =  64, mat = "?wall" }
      { x =  24, y =  64, mat = "?wall" }
      { x =  50, y = 128, mat = "?wall" }
      { x =   0, y = 128, mat = "?wall" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x = 128, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y =  64, mat = "?wall" }
      { x = 168, y =  64, mat = "?wall" }
      { x = 142, y =  50, mat = "?wall" }
      { x = 128, y =  24, mat = "?wall" }
    }

    {
      { x = 142, y = 128, mat = "?wall" }
      { x = 192, y = 128, mat = "?wall" }
      { x = 192, y = 192, mat = "?wall" }
      { x = 142, y = 192, mat = "?wall" }
    }

    {
      { x =  50, y =  88, mat = "?wall" }
      { x =  96, y =  72, mat = "?wall" }
      { x = 142, y =  86, mat = "?wall" }
      { x = 142, y = 128, mat = "?wall" }
      { x = 112, y = 152, mat = "?wall" }
      { x =  80, y = 152, mat = "?wall" }
      { x =  50, y = 128, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  50, y =  88, mat = "?wall" }
      { x =  96, y =  72, mat = "?wall" }
      { x = 142, y =  86, mat = "?wall" }
      { x = 142, y = 128, mat = "?wall" }
      { x = 112, y = 152, mat = "?wall" }
      { x =  80, y = 152, mat = "?wall" }
      { x =  50, y = 128, mat = "?wall" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x =  50, y = 128, mat = "?wall" }
      { x =  80, y = 152, mat = "?wall" }
      { x =  80, y = 192, mat = "?wall" }
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
      { x = 142, y = 128, mat = "?wall" }
      { x = 168, y =  64, mat = "?wall" }
      { x = 192, y =  64, mat = "?wall" }
      { x = 192, y = 128, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x = 142, y = 128, mat = "?wall" }
      { x = 168, y =  64, mat = "?wall" }
      { x = 192, y =  64, mat = "?wall" }
      { x = 192, y = 128, mat = "?wall" }
      { b = 72, mat = "?ceil" }
    }

    {
      { x = 112, y = 152, mat = "?wall" }
      { x = 142, y = 128, mat = "?wall" }
      { x = 142, y = 192, mat = "?wall" }
      { x = 112, y = 192, mat = "?wall" }
    }

    {
      { x =  80, y = 152, mat = "?wall" }
      { x = 112, y = 152, mat = "?wall" }
      { x = 112, y = 192, mat = "?wall" }
      { x =  80, y = 192, mat = "?wall" }
    }
  }

  entities =
  {
    { ent = "lamp", x = 96, y = 140, z = 0, angle = 270 }
  }
}


PREFAB.HALL_THIN_I_STAIR =
{
  fitted = "xy"

  x_ranges = { {64,1}, {64,0}, {64,1} }

  brushes =
  {
    {
      { x =  64, y = 160, mat = "?step" }
      { x = 128, y = 160, mat = "?wall" }
      { x = 128, y = 192, mat = "?wall" }
      { x =  64, y = 192, mat = "?wall" }
      { t = 60, mat = "?floor" }
    }
    {
      { x =  64, y = 160, mat = "?wall" }
      { x = 128, y = 160, mat = "?wall" }
      { x = 128, y = 192, mat = "?wall" }
      { x =  64, y = 192, mat = "?wall" }
      { b = 176, mat = "?ceil" }
    }

    {
      { x = 128, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y = 192, mat = "?wall" }
      { x = 128, y = 192, mat = "?wall" }
    }

    {
      { x =   0, y =   0, mat = "?wall" }
      { x =  64, y =   0, mat = "?wall" }
      { x =  64, y = 192, mat = "?wall" }
      { x =   0, y = 192, mat = "?wall" }
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
      { x =  64, y =   0, mat = "?wall" }
      { x = 128, y =   0, mat = "?wall" }
      { x = 128, y =  32, mat = "?wall" }
      { x =  64, y =  32, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  64, y =   0, mat = "?wall" }
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

