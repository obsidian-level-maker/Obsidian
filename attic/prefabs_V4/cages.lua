----------------------------------------------------------------
--  CAGE and TRAP PREFABS
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2010-2012 Andrew Apted
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


PREFAB.FAT_CAGE1 =
{
  fitted = "xy"

  brushes =
  {
    -- wall behind it
    {
      { x =   0, y =  0, mat = "?wall" }
      { x = 192, y =  0, mat = "?wall" }
      { x = 192, y = 16, mat = "?wall" }
      { x =   0, y = 16, mat = "?wall" }
    }

    -- walls each side
    {
      { x =  0, y =   0, mat = "?wall" }
      { x = 16, y =   0, mat = "?wall" }
      { x = 16, y = 192, mat = "?wall" }
      { x =  0, y = 192, mat = "?wall" }
    }

    {
      { x = 176, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y = 192, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
    }

    -- floor
    {
      { x =  16, y =  16, mat = "?wall" }
      { x = 176, y =  16, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { t = 0, mat = "?wall" }
    }

    {
      { x =  16, y =  16, mat = "?wall" }
      { x = 176, y =  16, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { b = 192, mat = "?wall" }
    }

    -- railing
    {
      { m = "rail" }
      { x =  16, y =  16 }
      { x = 176, y =  16 }
      { x = 176, y = 192, mat = "?rail", blocked=1 }
      { x =  16, y = 192 }
      { b = 0  }
      { t = 128 }
    }

    -- monster spot
    {
      { m = "spot", spot_kind = "cage", angle = 90 }
      { x =  24, y =  32 }
      { x = 168, y =  32 }
      { x = 168, y = 176 }
      { x =  24, y = 176 }
      { b =   0 }
      { t = 192 }
    }
  }
}


PREFAB.FAT_CAGE_W_BARS =
{
  fitted = "xy"

  brushes =
  {
    -- wall behind it
    {
      { x =   0, y =  0, mat = "?wall" }
      { x = 192, y =  0, mat = "?wall" }
      { x = 192, y = 24, mat = "?wall" }
      { x =   0, y = 24, mat = "?wall" }
    }

    -- walls each side
    {
      { x =  0, y =   0, mat = "?wall" }
      { x = 16, y =   0, mat = "?wall" }
      { x = 16, y = 192, mat = "?wall" }
      { x =  0, y = 192, mat = "?wall" }
    }

    {
      { x = 176, y =   0, mat = "?wall" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y = 192, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
    }

    -- floor and ceiling
    {
      { x =  16, y =  16, mat = "?wall" }
      { x = 176, y =  16, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall", blocked=1 }
      { x =  16, y = 192, mat = "?wall" }
      { t = 0, mat = "?wall" }
    }

    {
      { x =  16, y =  16, mat = "?wall" }
      { x = 176, y =  16, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
      { x =  16, y = 192, mat = "?wall" }
      { b = 192, mat = "?wall" }
    }

    -- bars
    {
      { m = "detail" }
      { x =  92, y = 176, mat = "?bar" }
      { x = 100, y = 176, mat = "?bar" }
      { x = 100, y = 184, mat = "?bar" }
      { x =  92, y = 184, mat = "?bar" }
    }

    {
      { m = "detail" }
      { x =  52, y = 176, mat = "?bar" }
      { x =  60, y = 176, mat = "?bar" }
      { x =  60, y = 184, mat = "?bar" }
      { x =  52, y = 184, mat = "?bar" }
    }

    {
      { m = "detail" }
      { x = 132, y = 176, mat = "?bar" }
      { x = 140, y = 176, mat = "?bar" }
      { x = 140, y = 184, mat = "?bar" }
      { x = 132, y = 184, mat = "?bar" }
    }

    -- clipping
    {
      { m = "clip" }
      { x =  16, y = 168 }
      { x = 176, y = 168 }
      { x = 176, y = 192 }
      { x =  16, y = 192 }
    }

    -- monster spot
    {
      { m = "spot", spot_kind = "cage", angle = 90 }
      { x =  24, y =  32 }
      { x = 168, y =  32 }
      { x = 168, y = 164 }
      { x =  24, y = 164 }
      { b =   0 }
      { t = 192 }
    }
  }
}


PREFAB.WALL_CAGE_1 =
{
  fitted = "xy"

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
  fitted = "xy"

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
  fitted = "xy"

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



PREFAB.FAT_CAGE_PILLAR =
{
  fitted = "xyz"

  z_range = { {16,1}, {240,0}, {16,7} }

  defaults =
  {
    floor0 = "SLADWALL"
    ceil0  = "SLADWALL"

    support = "METAL"
    side = "WOOD5"

    floor2 = "CEIL4_2"
    ceil2 = "FLAT1"
    trim = "CEIL5_1"

    use_lamp = 1

    lamp = "TLITE6_4"
    lamp_side = "STEP5"
    light = 100
  }

  brushes =
  {
    {
      { x =   0, y =   0, mat = "?floor0" }
      { x = 192, y =   0, mat = "?floor0" }
      { x = 192, y = 192, mat = "?floor0" }
      { x =   0, y = 192, mat = "?floor0" }
      { t = 16, mat = "?floor0" }
    }
    {
      { x =   0, y =   0, mat = "?ceil0" }
      { x = 192, y =   0, mat = "?ceil0" }
      { x = 192, y = 192, mat = "?ceil0" }
      { x =   0, y = 192, mat = "?ceil0" }
      { b = 256, mat = "?ceil0" }
    }

    {
      { x =   8, y =   8, mat = "?side" }
      { x = 184, y =   8, mat = "?side" }
      { x = 184, y = 184, mat = "?side" }
      { x =   8, y = 184, mat = "?side" }
      { t = 80, mat = "?trim" }
    }
    {
      { x =   8, y =   8, mat = "?side" }
      { x = 184, y =   8, mat = "?side" }
      { x = 184, y = 184, mat = "?side" }
      { x =   8, y = 184, mat = "?side" }
      { b = 192, mat = "?trim", light_add=32 }
    }

    {
      { x =  16, y = 160, mat = "?support" }
      { x =  32, y = 160, mat = "?support" }
      { x =  32, y = 176, mat = "?support" }
      { x =  16, y = 176, mat = "?support" }
    }

    {
      { x =  16, y =  16, mat = "?support" }
      { x = 176, y =  16, mat = "?support" }
      { x = 176, y = 176, mat = "?support" }
      { x =  16, y = 176, mat = "?support" }
      { t = 80, mat = "?floor2" }
    }
    {
      { x =  16, y =  16, mat = "?support" }
      { x = 176, y =  16, mat = "?support" }
      { x = 176, y = 176, mat = "?support" }
      { x =  16, y = 176, mat = "?support" }
      { b = 192, mat = "?ceil2", light_add=32 }
    }

    {
      { m = "detail", only_if = "?use_lamp" }
      { x =  64, y =  64, mat = "?lamp_side" }
      { x = 128, y =  64, mat = "?lamp_side" }
      { x = 128, y = 128, mat = "?lamp_side" }
      { x =  64, y = 128, mat = "?lamp_side" }
      { b = 184, mat = "?lamp", light_add=64 }
    }

    {
      { x = 160, y = 160, mat = "?support" }
      { x = 176, y = 160, mat = "?support" }
      { x = 176, y = 176, mat = "?support" }
      { x = 160, y = 176, mat = "?support" }
    }

    {
      { x = 160, y =  16, mat = "?support" }
      { x = 176, y =  16, mat = "?support" }
      { x = 176, y =  32, mat = "?support" }
      { x = 160, y =  32, mat = "?support" }
    }

    {
      { x =  16, y =  16, mat = "?support" }
      { x =  32, y =  16, mat = "?support" }
      { x =  32, y =  32, mat = "?support" }
      { x =  16, y =  32, mat = "?support" }
    }

    -- Z bounding box
    {
      { m = "bbox" }
      { b = 0 }
      { t = 272 }
    }
  }

  entities =
  {
    { ent = "light", x = 96, y = 96, z = 168, light = "?light" }
  }
}


------------------------------------------------------------------------


PREFAB.TRAP_CLOSET_DOOM =
{
  fitted = "xy"

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


----------------------------------------------------------------


PREFAB.SECRET_NICHE_1 =
{
  fitted = "xy"

  defaults =
  {
    item2 = "none"
    item3 = "none"
    item4 = "none"

    secret_wall = "?wall"
    secret_kind = 9

    -- Hexen stuff
    act = ""
    speed = 32
  }

  brushes =
  {
    -- wall behind it
    {
      { x =   0, y =  0, mat = "?outer" }
      { x = 192, y =  0, mat = "?outer" }
      { x = 192, y = 16, mat = "?wall" }
      { x =   0, y = 16, mat = "?outer" }
    }

    -- left side wall
    {
      { x =  0, y =  16, mat = "?wall" }
      { x = 32, y =  16, mat = "?wall", peg=1 }
      { x = 32, y = 192, mat = "?wall" }
      { x =  0, y = 192, mat = "?outer" }
    }

    {
      { x = 32, y =  16, mat = "?wall" }
      { x = 64, y =  16, mat = "?wall" }
      { x = 32, y =  80, mat = "?wall" }
    }

    -- right side wall
    {
      { x = 160, y =  16, mat = "?wall" }
      { x = 192, y =  16, mat = "?outer" }
      { x = 192, y = 192, mat = "?wall" }
      { x = 160, y = 192, mat = "?wall", peg=1 }
    }

    {
      { x = 128, y =  16, mat = "?wall" }
      { x = 160, y =  16, mat = "?wall" }
      { x = 160, y =  80, mat = "?wall" }
    }

    -- floor
    {
      { x =  32, y =  16, mat = "?wall" }
      { x = 160, y =  16, mat = "?wall" }
      { x = 160, y = 192, mat = "?wall" }
      { x =  32, y = 192, mat = "?wall" }
      { t = 8, mat = "?floor" }
    }

    -- ceiling
    {
      { x =  32, y =  16, mat = "?wall" }
      { x = 160, y =  16, mat = "?wall" }
      { x = 160, y = 176, mat = "?wall" }
      { x =  32, y = 176, mat = "?wall" }
      { b = 136, mat = "?ceil" }
    }

    -- opening part
    {
      { x =  32, y = 176, mat = "?wall" }
      { x = 160, y = 176, mat = "?wall" }
      { x = 160, y = 192, mat = "?secret_wall", special="?special", tag="?tag", act="?act", arg1="?tag", arg2="?speed", peg=1, y_offset=19 }
      { x =  32, y = 192, mat = "?wall" }
      { b = 32, delta_z=-23, mat = "?wall", tag = "?tag" }
    }

    -- lighting
    {
      { m = "light", add = 48 }
      { x =  32, y = 176 }
      { x = 160, y = 176 }
      { x = 160, y = 192 }
      { x =  32, y = 192 }
    }

    -- secret (abusing a light brush for this)
    {
      { m = "light", add = 32, effect = "?secret_kind" }
      { x =  32, y =  16 }
      { x = 160, y =  16 }
      { x = 160, y = 176 }
      { x =  32, y = 176 }
    }
  }
  
  -- the juicy item

  entities =
  {
    { ent = "?item",  x =  96, y = 96, z = 8 }
    { ent = "?item2", x =  48, y = 64, z = 8 }
    { ent = "?item3", x = 144, y = 64, z = 8 }
    { ent = "?item4", x =  96, y = 64, z = 8 }
  }
}


PREFAB.QUAKE_SECRET_NICHE_1 =
{
  fitted = "xy"

  defaults =
  {
    item2 = "none"
    item3 = "none"
    item4 = "none"

    secret_wall = "?wall"

    style = 7
  }

  brushes =
  {
    -- wall behind it
    {
      { x =   0, y =  0, mat = "?outer" }
      { x = 192, y =  0, mat = "?outer" }
      { x = 192, y = 16, mat = "?wall" }
      { x =   0, y = 16, mat = "?outer" }
    }

    -- left side wall
    {
      { x =  0, y =  16, mat = "?wall" }
      { x = 32, y =  16, mat = "?wall" }
      { x = 32, y = 192, mat = "?wall" }
      { x =  0, y = 192, mat = "?outer" }
    }

    {
      { x = 32, y =  16, mat = "?wall" }
      { x = 64, y =  16, mat = "?wall" }
      { x = 32, y =  80, mat = "?wall" }
    }

    -- right side wall
    {
      { x = 160, y =  16, mat = "?wall" }
      { x = 192, y =  16, mat = "?outer" }
      { x = 192, y = 192, mat = "?wall" }
      { x = 160, y = 192, mat = "?wall" }
    }

    {
      { x = 128, y =  16, mat = "?wall" }
      { x = 160, y =  16, mat = "?wall" }
      { x = 160, y =  80, mat = "?wall" }
    }

    -- floor
    {
      { x =  32, y =  16, mat = "?wall" }
      { x = 160, y =  16, mat = "?wall" }
      { x = 160, y = 192, mat = "?wall" }
      { x =  32, y = 192, mat = "?wall" }
      { t = 8, mat = "?floor" }
    }

    -- ceiling
    {
      { x =  32, y =  16, mat = "?wall" }
      { x = 160, y =  16, mat = "?wall" }
      { x = 160, y = 192, mat = "?wall" }
      { x =  32, y = 192, mat = "?wall" }
      { b = 136, mat = "?ceil" }
    }
  }

  models =
  {
    -- opening part
    {
      x1 =  32, x2 = 160, x_face = { mat="METAL1_2" }
      y1 = 176, y2 = 192, y_face = { mat="?secret_wall" }
      z1 =  10, z2 = 138, z_face = { mat="METAL1_2" }

      entity =
      {
        ent = "secret_door"
        angles = "270 0 0"
        sounds = 1
        spawnflags = 0
      }
    }

    -- show the message and count as a secret
    {
      x1 =  32, x2 = 160, x_face = { mat="TRIGGER" }
      y1 =  32, y2 = 176, y_face = { mat="TRIGGER" }
      z1 =   8, z2 = 136, z_face = { mat="TRIGGER" }

      entity =
      {
        ent = "secret"
      }
    }
  }

  -- the juicy item

  entities =
  {
    { ent = "?item",  x =  96, y = 104, z = 12 }
    { ent = "?item2", x =  48, y =  72, z = 12 }
    { ent = "?item3", x = 144, y =  72, z = 12 }
    { ent = "?item4", x =  96, y =  72, z = 12 }

    { ent = "light", x = 96, y = 96, z = 3, light = 128, style = "?style" }
  }
}


PREFAB.SECRET_NICHE_W_JUMPS =
{
  fitted = "xy"

  brushes =
  {
    -- wall behind it
    {
      { x =   0, y =  0, mat = "?outer" }
      { x = 192, y =  0, mat = "?outer" }
      { x = 192, y = 64, mat = "?wall" }
      { x =   0, y = 64, mat = "?outer" }
    }

    -- left side wall
    {
      { x =   0, y =  64, mat = "?wall" }
      { x = 112, y =  64, mat = "?wall" }
      { x = 112, y = 192, mat = "?wall" }
      { x =   0, y = 192, mat = "?outer" }
    }

    -- right side wall
    {
      { x = 176, y =  64, mat = "?wall" }
      { x = 192, y =  64, mat = "?outer" }
      { x = 192, y = 192, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
    }

    -- floor
    {
      { x = 112, y =  64, mat = "?wall" }
      { x = 176, y =  64, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
      { x = 112, y = 192, mat = "?wall" }
      { t = 200, mat = "?floor" }
    }

    -- ceiling
    {
      { x = 112, y =  64, mat = "?wall" }
      { x = 176, y =  64, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
      { x = 112, y = 192, mat = "?wall" }
      { b = 296, mat = "?ceil" }
    }

    -- the jumps  [these poke outside the bbox]
    {
      { m = "solid", outlier = 1 }
      { x = 48, y = 192, mat = "?wall" }
      { x = 64, y = 192, mat = "?wall" }
      { x = 64, y = 200, mat = "?wall" }
      { x = 48, y = 200, mat = "?wall" }
      { t = 40, mat = "?wall" }
    }
    {
      { m = "solid", outlier = 1 }
      { x = 64, y = 192, mat = "?wall" }
      { x = 80, y = 192, mat = "?wall" }
      { x = 80, y = 200, mat = "?wall" }
      { x = 64, y = 200, mat = "?wall" }
      { t = 80, mat = "?wall" }
      { b = 48, mat = "?wall" }
    }
    {
      { m = "solid", outlier = 1 }
      { x = 80, y = 192, mat = "?wall" }
      { x = 96, y = 192, mat = "?wall" }
      { x = 96, y = 200, mat = "?wall" }
      { x = 80, y = 200, mat = "?wall" }
      { t = 120, mat = "?wall" }
      { b =  88, mat = "?wall" }
    }
    {
      { m = "solid", outlier = 1 }
      { x =  96, y = 192, mat = "?wall" }
      { x = 112, y = 192, mat = "?wall" }
      { x = 112, y = 200, mat = "?wall" }
      { x =  96, y = 200, mat = "?wall" }
      { t = 160, mat = "?wall" }
      { b = 128, mat = "?wall" }
    }
    {
      { m = "solid", outlier = 1 }
      { x = 112, y = 192, mat = "?wall" }
      { x = 128, y = 192, mat = "?wall" }
      { x = 128, y = 200, mat = "?wall" }
      { x = 112, y = 200, mat = "?wall" }
      { t = 200, mat = "?wall" }
      { b = 168, mat = "?wall" }
    }
  }

  -- show the message and count as a secret

  models =
  {
    {
      x1 = 112, x2 = 176, x_face = { mat="TRIGGER" }
      y1 =  64, y2 = 176, y_face = { mat="TRIGGER" }
      z1 = 200, z2 = 296, z_face = { mat="TRIGGER" }

      entity =
      {
        ent = "secret"
      }
    }
  }

  -- the well-earned item

  entities =
  {
    { ent = "?item", x = 144, y = 128, z = 212 }
  }
}

