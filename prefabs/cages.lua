----------------------------------------------------------------
--  CAGE and TRAP PREFABS
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

PREFAB.CAGE_1 =
{
  brushes =
  {
    {
      { x = -48, y = -48, mat = "?base" }
      { x =  48, y = -48, mat = "?base" }
      { x =  48, y =  48, mat = "?base" }
      { x = -48, y =  48, mat = "?base" }
      { t = 48, mat = "?base" }
    }

--[[
    {
      { x = -48, y = -48, mat = "?pillar" }
      { x =  48, y = -48, mat = "?pillar" }
      { x =  48, y =  48, mat = "?pillar" }
      { x = -48, y =  48, mat = "?pillar" }
      { b = 176, mat = "?pillar" }
    }
--]]

    {
      { m = "rail" }
      { x = -48, y = -48, mat = "?rail", blocked=1 }
      { x =  48, y = -48, mat = "?rail", blocked=1 }
      { x =  48, y =  48, mat = "?rail", blocked=1 }
      { x = -48, y =  48, mat = "?rail", blocked=1 }
      { b = 48 }
      { t = 176 }
    }

    {
      { m = "spot", spot_kind = "cage", angle = 90 }
      { x = -40, y = -40 }
      { x =  40, y = -40 }
      { x =  40, y =  40 }
      { x = -40, y =  40 }
      { b =  48 }
      { t = 176 }
    }
  }
}


PREFAB.CAGE_LARGE =
{
  brushes =
  {
    -- main trunk
    {
      { x = -96, y = -96, mat = "?wall" }
      { x =  96, y = -96, mat = "?wall" }
      { x =  96, y =  96, mat = "?wall" }
      { x = -96, y =  96, mat = "?wall" }
      { t = 80, mat = "?wall" }
    }

    -- railing
    {
      { m = "rail" }
      { x = -96, y = -96, mat = "?rail", blocked=1 }
      { x =  96, y = -96, mat = "?rail", blocked=1 }
      { x =  96, y =  96, mat = "?rail", blocked=1 }
      { x = -96, y =  96, mat = "?rail", blocked=1 }
      { b = 80 }
      { t = 208 }
    }

    -- trim at bottom
    {
      { x =  -96, y = -144, mat = "?trim" }
      { x =   96, y = -144, mat = "?trim" }
      { x =  144, y =  -96, mat = "?trim" }
      { x =  144, y =   96, mat = "?trim" }
      { x =   96, y =  144, mat = "?trim" }
      { x =  -96, y =  144, mat = "?trim" }
      { x = -144, y =   96, mat = "?trim" }
      { x = -144, y =  -96, mat = "?trim" }
      { t =  8, mat = "?trim" }
    }

    -- posts on each corner
    {
      { x = -108, y = -108, mat = "?support", x_offset=0 }
      { x =  -84, y = -108, mat = "?support", x_offset=0 }
      { x =  -84, y =  -84, mat = "?support", x_offset=0 }
      { x = -108, y =  -84, mat = "?support", x_offset=0 }
      { t = 224, mat = "?support" }
    }

    {
      { x =  84, y = -108, mat = "?support", x_offset=0 }
      { x = 108, y = -108, mat = "?support", x_offset=0 }
      { x = 108, y =  -84, mat = "?support", x_offset=0 }
      { x =  84, y =  -84, mat = "?support", x_offset=0 }
      { t = 224, mat = "?support" }
    }

    {
      { x = -108, y =  84, mat = "?support", x_offset=0 }
      { x =  -84, y =  84, mat = "?support", x_offset=0 }
      { x =  -84, y = 108, mat = "?support", x_offset=0 }
      { x = -108, y = 108, mat = "?support", x_offset=0 }
      { t = 224, mat = "?support" }
    }

    {
      { x =  84, y =  84, mat = "?support", x_offset=0 }
      { x = 108, y =  84, mat = "?support", x_offset=0 }
      { x = 108, y = 108, mat = "?support", x_offset=0 }
      { x =  84, y = 108, mat = "?support", x_offset=0 }
      { t = 224, mat = "?support" }
    }

    -- monster spot
    {
      { m = "spot", spot_kind = "cage", angle = 90 }
      { x = -80, y = -80 }
      { x =  80, y = -80 }
      { x =  80, y =  80 }
      { x = -80, y =  80 }
      { b =  80 }
      { t = 240 }
    }
  }
}



PREFAB.WALL_CAGE_1 =
{
  placement = "fitted"

  flush = 144

  brushes =
  {
    -- wall behind it
    {
      { x =   0, y =  0, mat = "?wall" }
      { x = 192, y =  0, mat = "?wall" }
      { x = 192, y = 16, mat = "?wall" }
      { x =   0, y = 16, mat = "?wall" }
    }

    -- platform
    {
      { x =   0, y =  16, mat = "?wall" }
      { x = 192, y =  16, mat = "?wall" }
      { x = 192, y = 144, mat = "?wall" }
      { x =   0, y = 144, mat = "?wall" }
      { t = 64, mat = "?wall" }
    }

    -- railing
    {
      { m = "rail" }
      { x =   0, y =  16 }
      { x = 192, y =  16, mat = "?rail", blocked=1 }
      { x = 192, y = 144, mat = "?rail", blocked=1 }
      { x =   0, y = 144, mat = "?rail", blocked=1 }
      { b = 64 }
      { t = 192 }
    }

    -- monster spot
    {
      { m = "spot", spot_kind = "cage", angle = 90 }
      { x =  32, y =  16 }
      { x = 160, y =  16 }
      { x = 160, y = 144 }
      { x =  32, y = 144 }
      { b =  64 }
      { t = 192 }
    }
  }
}


PREFAB.WALL_CAGE_2 =
{
  placement = "fitted"

  flush = 144

  brushes =
  {
    -- wall behind it
    {
      { x =   0, y =  0, mat = "?wall" }
      { x = 256, y =  0, mat = "?wall" }
      { x = 256, y = 16, mat = "?wall" }
      { x =   0, y = 16, mat = "?wall" }
    }

    -- platform
    {
      { x =  40, y =  16, mat = "?wall" }
      { x = 216, y =  16, mat = "?wall" }
      { x = 216, y = 120, mat = "?wall" }
      { x = 192, y = 144, mat = "?wall" }
      { x =  64, y = 144, mat = "?wall" }
      { x =  40, y = 120, mat = "?wall" }
      { t = 64, mat = "?wall" }
    }

    -- railing
    {
      { m = "rail" }
      { x =  40, y =  16 }
      { x = 216, y =  16, mat = "?rail", blocked=1 }
      { x = 216, y = 120, mat = "?rail", blocked=1 }
      { x = 192, y = 144, mat = "?rail", blocked=1 }
      { x =  64, y = 144, mat = "?rail", blocked=1 }
      { x =  40, y = 120, mat = "?rail", blocked=1 }
      { b = 64 }
      { t = 192 }
    }

    -- monster spot
    {
      { m = "spot", spot_kind = "cage", angle = 90 }
      { x =  32, y =  16 }
      { x = 160, y =  16 }
      { x = 160, y = 144 }
      { x =  32, y = 144 }
      { b =  64 }
      { t = 192 }
    }
  }
}


PREFAB.CAGE_3D_WALL_1 =
{
  placement = "fitted"

  brushes =
  {
    -- wall behind it
    {
      { x =   0, y =  0, mat = "?wall" }
      { x = 256, y =  0, mat = "?wall" }
      { x = 256, y = 16, mat = "?wall" }
      { x =   0, y = 16, mat = "?wall" }
    }

    -- platform
    {
      { x =  40, y =  16, mat = "?cage" }
      { x = 216, y =  16, mat = "?cage" }
      { x = 216, y = 136, mat = "?cage" }
      { x = 192, y = 160, mat = "?cage" }
      { x =  64, y = 160, mat = "?cage" }
      { x =  40, y = 136, mat = "?cage" }
      { b = 128, mat = "?cage" }
      { t = 144, mat = "?cage" }
    }

    -- posts
    {
      { x =  64, y = 112, mat = "support" }
      { x =  80, y = 112, mat = "support" }
      { x =  80, y = 128, mat = "support" }
      { x =  64, y = 128, mat = "support" }
      { t = 132 }
    }

    {
      { x = 176, y = 112, mat = "support" }
      { x = 192, y = 112, mat = "support" }
      { x = 192, y = 128, mat = "support" }
      { x = 176, y = 128, mat = "support" }
      { t = 132 }
    }

    -- monster spot
    {
      { m = "spot", spot_kind = "cage", angle = 90 }
      { x =  64, y =  24 }
      { x = 192, y =  24 }
      { x = 192, y = 152 }
      { x =  64, y = 152 }
      { b = 144 }
      { t = 256 }
    }
  }
}


------------------------------------------------------------------------


PREFAB.TRAP_CLOSET_DOOM =
{
  placement = "fitted"

  brushes =
  {
    -- wall behind it
    {
      { x =   0, y =  0, mat = "?wall" }
      { x = 192, y =  0, mat = "?wall" }
      { x = 192, y =  8, mat = "?wall" }
      { x =   0, y =  8, mat = "?wall" }
    }

    -- left side wall
    {
      { x =  0, y =  8, mat = "?wall" }
      { x = 16, y =  8, mat = "?wall" }
      { x = 16, y = 104, mat = "?wall" }
      { x =  0, y = 104, mat = "?wall" }
    }

    -- right side wall
    {
      { x = 176, y =  8, mat = "?wall" }
      { x = 192, y =  8, mat = "?wall" }
      { x = 192, y = 104, mat = "?wall" }
      { x = 176, y = 104, mat = "?wall" }
    }

    -- floor
    {
      { x =  16, y =  8, mat = "?floor" }
      { x = 176, y =  8, mat = "?floor" }
      { x = 176, y = 104, mat = "?floor" }
      { x =  16, y = 104, mat = "?floor" }
      { t = 0, mat = "?floor" }
    }

    -- ceiling
    {
      { x =  16, y =  8, mat = "?ceil" }
      { x = 176, y =  8, mat = "?ceil" }
      { x = 176, y = 96, mat = "?ceil" }
      { x =  16, y = 96, mat = "?ceil" }
      { b = 128, mat = "?ceil" }
    }

    -- opening part
    {
      { x = 160, y =  96, mat = "?wall" }
      { x = 160, y =  96, mat = "?wall" }
      { x =  32, y = 104, mat = "?wall" }
      { x =  32, y = 104, mat = "?wall" }
      { b = 24, delta_z=-24, mat = "?wall", tag = "?tag" }
    }

    -- monster spot
    {
      { m = "spot", spot_kind = "trap", angle = 90 }
      { x =  24, y = 20 }
      { x = 168, y = 20 }
      { x = 168, y = 92 }
      { x =  24, y = 92 }
      { b =   0 }
      { t = 120 }
    }
  }
}

