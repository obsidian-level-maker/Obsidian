----------------------------------------------------------------
--  PEDESTAL PREFABS
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

PREFAB.PEDESTAL =
{
  defaults =
  {
    side = "?top"

    height = 8

    x_offset = ""
    y_offset = ""
    peg = ""

    light  = 64
    effect = 0
    fx_delta = ""
    style  = ""

    angle  = 0
  }

  brushes =
  {
    {
      { x = -32, y = -32, mat = "?side", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  32, y = -32, mat = "?side", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  32, y =  32, mat = "?side", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = -32, y =  32, mat = "?side", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { t = "?height", mat = "?top", light_add="?light", light_effect="?effect", light_delta="?fx_delta" }
    }
  }

  entities =
  {
    -- the item itself
    { ent = "?item", x = 0, y = 0, z = "?height", angle = "?angle" }

    -- light source (Quake etc)
    { ent = "light", x = 0, y = 0, z = 32, light = "?light", style = "?style" }
  }
}


PREFAB.OCTO_PEDESTAL =
{
  defaults =
  {
    light  = 60
    style  = ""
    angle  = 0
    x_offset = ""
    y_offset = ""
    peg = ""
  }

  brushes =
  {
    -- pedestal
    {
      { x = -32, y = -32, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  32, y = -32, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  32, y =  32, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = -32, y =  32, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { t = 16, mat = "?top" }
    }

    -- octogon base
    {
      { x = -40, y = -56, mat = "?base" }
      { x =  40, y = -56, mat = "?base" }
      { x =  56, y = -40, mat = "?base" }
      { x =  56, y =  40, mat = "?base" }
      { x =  40, y =  56, mat = "?base" }
      { x = -40, y =  56, mat = "?base" }
      { x = -56, y =  40, mat = "?base" }
      { x = -56, y = -40, mat = "?base" }
      { t = 8, mat = "?base" }
    }

    -- lighting
    {
      { m = "light", add = 48 }
      { x = -32, y = -56 }
      { x =  32, y = -56 }
      { x =  56, y = -32 }
      { x =  56, y =  32 }
      { x =  32, y =  56 }
      { x = -32, y =  56 }
      { x = -56, y =  32 }
      { x = -56, y = -32 }
    }

    {
      { m = "light", add = 32 }
      { x = -40, y = -80 }
      { x =  40, y = -80 }
      { x =  80, y = -40 }
      { x =  80, y =  40 }
      { x =  40, y =  80 }
      { x = -40, y =  80 }
      { x = -80, y =  40 }
      { x = -80, y = -40 }
    }

    {
      { m = "light", add = 16 }
      { x =  -48, y = -112 }
      { x =   48, y = -112 }
      { x =  112, y =  -48 }
      { x =  112, y =   48 }
      { x =   48, y =  112 }
      { x =  -48, y =  112 }
      { x = -112, y =   48 }
      { x = -112, y =  -48 }
    }

  }

  entities =
  {
    -- the item itself
    { ent = "?item", x = 0, y = 0, z = 16, angle = "?angle" }

    -- light source
    { ent = "light", x = 0, y = 0, z = 40, light = "?light", style = "?style" }
  }
}


PREFAB.LOWERING_PEDESTAL =
{
  brushes =
  {
    {
      { x = -32, y = -32, mat = "?side", special="?special", tag="?tag", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  32, y = -32, mat = "?side", special="?special", tag="?tag", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  32, y =  32, mat = "?side", special="?special", tag="?tag", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = -32, y =  32, mat = "?side", special="?special", tag="?tag", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { t = 128, mat = "?top", light = "?light", special="?sec_kind", tag="?tag" }
    }
  }

  entities =
  {
    { ent = "?item", x = 0, y = 0, z = 128 }
  }
}


-- Note: this must be used in a large chunk (2x2 seeds), otherwise it can
-- block player movement.  For a single seed, use a lowering pedestal.
PREFAB.GUARDED_PEDESTAL =
{
  defaults =
  {
    height = 8
    light  = 60
    angle  = 0

    x_offset = ""
    y_offset = ""
    peg = ""

    bar_xo = 0
    bar_delta = 256
  }

  brushes =
  {
    -- the pedestal
    {
      { x = -32, y = -32, mat = "?side", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  32, y = -32, mat = "?side", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  32, y =  32, mat = "?side", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = -32, y =  32, mat = "?side", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { t = "?height", mat = "?top", light = "?light" }
    }

    -- lowering bars : bottom and top
    {
      { x =  16, y = -64, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { x =  32, y = -64, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { x =  32, y = -48, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { x =  16, y = -48, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { t = 80, delta_z = "?bar_delta", mat = "?bar", tag = "?tag" }
    }

    {
      { x = -32, y = -64, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { x = -16, y = -64, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { x = -16, y = -48, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { x = -32, y = -48, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { t = 80, delta_z = "?bar_delta", mat = "?bar", tag = "?tag" }
    }

    {
      { x =  16, y =  48, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { x =  32, y =  48, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { x =  32, y =  64, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { x =  16, y =  64, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { t = 80, delta_z = "?bar_delta", mat = "?bar", tag = "?tag" }
    }

    {
      { x = -32, y =  48, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { x = -16, y =  48, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { x = -16, y =  64, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { x = -32, y =  64, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { t = 80, delta_z = "?bar_delta", mat = "?bar", tag = "?tag" }
    }

    -- lowering bars : left and right
    {
      { x = -64, y =  16, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { x = -48, y =  16, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { x = -48, y =  32, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { x = -64, y =  32, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { t = 80, delta_z = "?bar_delta", mat = "?bar", tag = "?tag" }
    }

    {
      { x = -64, y = -32, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { x = -48, y = -32, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { x = -48, y = -16, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { x = -64, y = -16, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { t = 80, delta_z = "?bar_delta", mat = "?bar", tag = "?tag" }
    }

    {
      { x =  48, y =  16, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { x =  64, y =  16, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { x =  64, y =  32, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { x =  48, y =  32, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { t = 80, delta_z = "?bar_delta", mat = "?bar", tag = "?tag" }
    }

    {
      { x =  48, y = -32, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { x =  64, y = -32, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { x =  64, y = -16, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { x =  48, y = -16, mat = "?bar", peg=1, x_offset="?bar_xo", y_offset=0 },
      { t = 80, delta_z = "?bar_delta", mat = "?bar", tag = "?tag" }
    }
  }

  entities =
  {
    -- the item itself
    { ent = "?item", x = 0, y = 0, z = "?height", angle = "?angle" }
  }
}


PREFAB.ITEM_NICHE =
{
  fitted = "xy"

  defaults =
  {
    key = "?wall"
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

    -- right side

    {
      { x =  0, y =  4, mat = "?wall" }
      { x = 64, y =  4, mat = "?key" }
      { x = 32, y = 64, mat = "?wall" }
      { x =  0, y = 64, mat = "?wall" }
    }

    -- left side
    {
      { x = 128, y =  4, mat = "?wall" }
      { x = 192, y =  4, mat = "?wall" }
      { x = 192, y = 64, mat = "?wall" }
      { x = 160, y = 64, mat = "?key" }
    }

    -- frame bottom
    {
      { x =  64, y =  4, mat = "?wall" }
      { x = 128, y =  4, mat = "?wall" }
      { x = 160, y = 64, mat = "?wall", blocked=1 }
      { x =  32, y = 64, mat = "?wall" }
      { t = 32, mat = "?floor" }
    }

    -- frame top
    {
      { x =  64, y =  4, mat = "?wall" }
      { x = 128, y =  4, mat = "?wall" }
      { x = 160, y = 64, mat = "?wall", blocked=1 }
      { x =  32, y = 64, mat = "?wall" }
      { b = 128, mat = "?wall", light = "?light", special = "?special"  }
    }

  }

  entities =
  {
    { x = 96, y = 48, z = 32, ent = "?item", angle = 90 }

    { x = 96, y = 48, z = 32, ent = "light",
      light = "?light", style = "?style",
    }
  }
}


PREFAB.HEXEN_TRIPLE =
{
  defaults =
  {
    top = "?side"
    angle = 0
  }

  brushes =
  {
    -- three crates
    {
      { x = -32, y = -32, mat = "?side", peg=1, y_offset=0 }
      { x =   0, y = -32, mat = "?side", peg=1, y_offset=0 }
      { x =   0, y =   0, mat = "?side", peg=1, y_offset=0 }
      { x = -32, y =   0, mat = "?side", peg=1, y_offset=0 }
      { t = 38, mat = "?top" }
    }

    {
      { x =  32, y = -32, mat = "?side", peg=1, y_offset=0 }
      { x =  64, y = -32, mat = "?side", peg=1, y_offset=0 }
      { x =  64, y =   0, mat = "?side", peg=1, y_offset=0 }
      { x =  32, y =   0, mat = "?side", peg=1, y_offset=0 }
      { t = 38, mat = "?top" }
    }

    {
      { x = -32, y = 32, mat = "?side", peg=1, y_offset=0 }
      { x =   0, y = 32, mat = "?side", peg=1, y_offset=0 }
      { x =   0, y = 64, mat = "?side", peg=1, y_offset=0 }
      { x = -32, y = 64, mat = "?side", peg=1, y_offset=0 }
      { t = 38, mat = "?top" }
    }

    -- base
    {
      { x = -48, y =  80, mat = "?base" }
      { x = -48, y = -48, mat = "?base" }
      { x =  80, y = -48, mat = "?base" }
      { x =  80, y =  16, mat = "?base" }
      { x =  16, y =  80, mat = "?base" }
      { t = 6, mat = "?base" }
    }
  }

  entities =
  {
    -- the three items (Fighter, Cleric, Mage)
    { x = -16, y = -16, z = 32, ent = "?f_item", angle = "?angle" } -- flags = 32
    { x =  48, y = -16, z = 32, ent = "?c_item", angle = "?angle" } -- flags = 64
    { x = -16, y =  48, z = 32, ent = "?m_item", angle = "?angle" } -- flags = 128
  }
}


PREFAB.ITEM_CLOSET =
{
  fitted = "xy"

  defaults =
  {
  }

  brushes =
  {
    {
      { x =   0, y =  80, mat = "STARTAN3" }
      { x =  16, y =  80, mat = "TEKLITE" }
      { x =  16, y = 184, mat = "DOORSTOP" }
      { x =  16, y = 192, mat = "SP_HOT1" }
      { x =   0, y = 192, mat = "BLAKWAL1" }
    }

    {
      { x = 128, y =   0, mat = "BLAKWAL1" }
      { x = 192, y =   0, mat = "BLAKWAL1" }
      { x = 192, y =  80, mat = "STARTAN3" }
      { x = 176, y =  80, mat = "TEKLITE" }
      { x = 128, y =  32, mat = "STARTAN3" }
    }

    {
      { x =   0, y =   0, mat = "BLAKWAL1" }
      { x =  64, y =   0, mat = "STARTAN3" }
      { x =  64, y =  32, mat = "TEKLITE" }
      { x =  16, y =  80, mat = "STARTAN3" }
      { x =   0, y =  80, mat = "BLAKWAL1" }
    }

    {
      { x = 176, y =  80, mat = "STARTAN3" }
      { x = 192, y =  80, mat = "BLAKWAL1" }
      { x = 192, y = 192, mat = "SP_HOT1" }
      { x = 176, y = 192, mat = "DOORSTOP" }
      { x = 176, y = 184, mat = "TEKLITE" }
    }

    {
      { x =  16, y = 184, mat = "STARTAN3" }
      { x =  48, y = 184, mat = "SP_HOT1" }
      { x =  48, y = 192, mat = "BLAKWAL1" }
      { x =  16, y = 192, mat = "SP_HOT1" }
      { t = 56, mat = "FLAT5_7" }
    }
    {
      { x =  16, y = 184, mat = "STARTAN3" }
      { x =  48, y = 184, mat = "SP_HOT1" }
      { x =  48, y = 192, mat = "BLAKWAL1" }
      { x =  16, y = 192, mat = "SP_HOT1" }
      { b = 192, mat = "CEIL1_2" }
    }

    {
      { x =  16, y =  80, mat = "SP_HOT1" }
      { x =  64, y =  32, mat = "SP_HOT1" }
      { x = 128, y =  32, mat = "SP_HOT1" }
      { x = 176, y =  80, mat = "SP_HOT1" }
      { x = 176, y = 112, mat = "STARTAN3" }
      { x = 144, y = 144, mat = "STARTAN3" }
      { x = 104, y = 144, mat = "SP_HOT1" }
      { x =  88, y = 144, mat = "STARTAN3" }
      { x =  48, y = 144, mat = "STARTAN3" }
      { x =  16, y = 112, mat = "SP_HOT1" }
      { t = 56, mat = "FLAT5_7" }
    }
    {
      { x =  16, y =  80, mat = "SP_HOT1" }
      { x =  64, y =  32, mat = "SP_HOT1" }
      { x = 128, y =  32, mat = "SP_HOT1" }
      { x = 176, y =  80, mat = "SP_HOT1" }
      { x = 176, y = 112, mat = "STARTAN3" }
      { x = 144, y = 144, mat = "STARTAN3" }
      { x =  48, y = 144, mat = "STARTAN3" }
      { x =  16, y = 112, mat = "SP_HOT1" }
      { b = 192, mat = "CEIL1_2" }
    }

    {
      { x =  64, y =   0, mat = "BLAKWAL1" }
      { x = 128, y =   0, mat = "STARTAN3" }
      { x = 128, y =  32, mat = "TEKLITE" }
      { x =  64, y =  32, mat = "STARTAN3" }
    }

    {
      { x = 144, y = 184, mat = "STARTAN3" }
      { x = 176, y = 184, mat = "SP_HOT1" }
      { x = 176, y = 192, mat = "BLAKWAL1" }
      { x = 144, y = 192, mat = "SP_HOT1" }
      { t = 56, mat = "FLAT5_7" }
    }
    {
      { x = 144, y = 184, mat = "STARTAN3" }
      { x = 176, y = 184, mat = "SP_HOT1" }
      { x = 176, y = 192, mat = "BLAKWAL1" }
      { x = 144, y = 192, mat = "SP_HOT1" }
      { b = 192, mat = "CEIL1_2" }
    }

    {
      { x =  48, y = 184, mat = "STEP1" }
      { x = 144, y = 184, mat = "STARTAN3" }
      { x = 144, y = 192, mat = "BLAKWAL1" }
      { x =  48, y = 192, mat = "STARTAN3" }
      { t = 8, mat = "CEIL5_1" }
    }
    {
      { x =  48, y = 184, mat = "STARTAN3" }
      { x = 144, y = 184, mat = "STARTAN3" }
      { x = 144, y = 192, mat = "BLAKWAL1" }
      { x =  48, y = 192, mat = "STARTAN3" }
      { b = 192, mat = "CEIL1_2" }
    }

    {
      { x =  48, y = 184, mat = "STARTAN3" }
      { x =  56, y = 176, mat = "STEP1" }
      { x = 136, y = 176, mat = "STARTAN3" }
      { x = 144, y = 184, mat = "STEPTOP" }
      { t = 16, mat = "CEIL5_1" }
    }
    {
      { x =  48, y = 184, mat = "STARTAN3" }
      { x =  56, y = 176, mat = "STARTAN3" }
      { x = 136, y = 176, mat = "STARTAN3" }
      { x = 144, y = 184, mat = "STARTAN3" }
      { b = 192, mat = "CEIL1_2" }
    }

    {
      { x =  16, y = 168, mat = "STARTAN3" }
      { x =  56, y = 168, mat = "SP_HOT1" }
      { x =  56, y = 176, mat = "SP_HOT1" }
      { x =  48, y = 184, mat = "STARTAN3" }
      { x =  16, y = 184, mat = "SP_HOT1" }
      { t = 56, mat = "FLAT5_7" }
    }
    {
      { x =  16, y = 168, mat = "STARTAN3" }
      { x =  56, y = 168, mat = "SP_HOT1" }
      { x =  56, y = 176, mat = "SP_HOT1" }
      { x =  48, y = 184, mat = "STARTAN3" }
      { x =  16, y = 184, mat = "SP_HOT1" }
      { b = 192, mat = "CEIL1_2" }
    }

    {
      { x =  56, y = 168, mat = "STEP1" }
      { x = 136, y = 168, mat = "STARTAN3" }
      { x = 136, y = 176, mat = "STEPTOP" }
      { x =  56, y = 176, mat = "STARTAN3" }
      { t = 24, mat = "CEIL5_1" }
    }
    {
      { x =  56, y = 168, mat = "STARTAN3" }
      { x = 136, y = 168, mat = "STARTAN3" }
      { x = 136, y = 176, mat = "STARTAN3" }
      { x =  56, y = 176, mat = "STARTAN3" }
      { b = 192, mat = "CEIL1_2" }
    }

    {
      { x = 136, y = 168, mat = "STARTAN3" }
      { x = 176, y = 168, mat = "SP_HOT1" }
      { x = 176, y = 184, mat = "STARTAN3" }
      { x = 144, y = 184, mat = "SP_HOT1" }
      { x = 136, y = 176, mat = "SP_HOT1" }
      { t = 56, mat = "FLAT5_7" }
    }
    {
      { x = 136, y = 168, mat = "STARTAN3" }
      { x = 176, y = 168, mat = "SP_HOT1" }
      { x = 176, y = 184, mat = "STARTAN3" }
      { x = 144, y = 184, mat = "SP_HOT1" }
      { x = 136, y = 176, mat = "SP_HOT1" }
      { b = 192, mat = "CEIL1_2" }
    }

    {
      { x =  56, y = 168, mat = "STARTAN3" }
      { x =  64, y = 160, mat = "STEP1" }
      { x = 128, y = 160, mat = "STARTAN3" }
      { x = 136, y = 168, mat = "STEPTOP" }
      { t = 32, mat = "CEIL5_1" }
    }
    {
      { x =  56, y = 168, mat = "STARTAN3" }
      { x =  64, y = 160, mat = "STARTAN3" }
      { x = 128, y = 160, mat = "STARTAN3" }
      { x = 136, y = 168, mat = "STARTAN3" }
      { b = 192, mat = "CEIL1_2" }
    }

    {
      { x =  16, y = 112, mat = "STARTAN3" }
      { x =  48, y = 144, mat = "STARTAN3" }
      { x =  56, y = 152, mat = "STARTAN3" }
      { x =  64, y = 160, mat = "SP_HOT1" }
      { x =  56, y = 168, mat = "STARTAN3" }
      { x =  16, y = 168, mat = "SP_HOT1" }
      { t = 56, mat = "FLAT5_7" }
    }
    {
      { x =  16, y = 112, mat = "STARTAN3" }
      { x =  48, y = 144, mat = "STARTAN3" }
      { x =  56, y = 152, mat = "STARTAN3" }
      { x =  64, y = 160, mat = "SP_HOT1" }
      { x =  56, y = 168, mat = "STARTAN3" }
      { x =  16, y = 168, mat = "SP_HOT1" }
      { b = 192, mat = "CEIL1_2" }
    }

    {
      { x =  64, y = 160, mat = "STARTAN3" }
      { x =  72, y = 152, mat = "STEP1" }
      { x = 120, y = 152, mat = "STARTAN3" }
      { x = 128, y = 160, mat = "STEPTOP" }
      { t = 40, mat = "CEIL5_1" }
    }
    {
      { x =  64, y = 160, mat = "STARTAN3" }
      { x =  72, y = 152, mat = "STARTAN3" }
      { x = 120, y = 152, mat = "STARTAN3" }
      { x = 128, y = 160, mat = "STARTAN3" }
      { b = 192, mat = "CEIL1_2" }
    }

    {
      { x = 128, y = 160, mat = "STARTAN3" }
      { x = 136, y = 152, mat = "STARTAN3" }
      { x = 144, y = 144, mat = "STARTAN3" }
      { x = 176, y = 112, mat = "SP_HOT1" }
      { x = 176, y = 168, mat = "STARTAN3" }
      { x = 136, y = 168, mat = "SP_HOT1" }
      { t = 56, mat = "FLAT5_7" }
    }
    {
      { x = 128, y = 160, mat = "STARTAN3" }
      { x = 136, y = 152, mat = "STARTAN3" }
      { x = 144, y = 144, mat = "STARTAN3" }
      { x = 176, y = 112, mat = "SP_HOT1" }
      { x = 176, y = 168, mat = "STARTAN3" }
      { x = 136, y = 168, mat = "SP_HOT1" }
      { b = 192, mat = "CEIL1_2" }
    }

    {
      { x =  56, y = 152, mat = "STARTAN3" }
      { x =  72, y = 152, mat = "SP_HOT1" }
      { x =  64, y = 160, mat = "STARTAN3" }
      { t = 56, mat = "FLAT5_7" }
    }
    {
      { x =  56, y = 152, mat = "STARTAN3" }
      { x =  72, y = 152, mat = "SP_HOT1" }
      { x =  64, y = 160, mat = "STARTAN3" }
      { b = 192, mat = "CEIL1_2" }
    }

    {
      { x =  72, y = 152, mat = "STARTAN3" }
      { x =  88, y = 144, mat = "STEP1" }
      { x = 104, y = 144, mat = "STARTAN3" }
      { x = 120, y = 152, mat = "STEPTOP" }
      { t = 48, mat = "CEIL5_1" }
    }
    {
      { x =  72, y = 152, mat = "STARTAN3" }
      { x =  88, y = 144, mat = "STARTAN3" }
      { x = 104, y = 144, mat = "STARTAN3" }
      { x = 120, y = 152, mat = "STARTAN3" }
      { b = 192, mat = "CEIL1_2" }
    }

    {
      { x = 120, y = 152, mat = "STARTAN3" }
      { x = 136, y = 152, mat = "STARTAN3" }
      { x = 128, y = 160, mat = "SP_HOT1" }
      { t = 56, mat = "FLAT5_7" }
    }
    {
      { x = 120, y = 152, mat = "STARTAN3" }
      { x = 136, y = 152, mat = "STARTAN3" }
      { x = 128, y = 160, mat = "SP_HOT1" }
      { b = 192, mat = "CEIL1_2" }
    }

    {
      { x =  48, y = 144, mat = "STARTAN3" }
      { x =  88, y = 144, mat = "SP_HOT1" }
      { x =  72, y = 152, mat = "STARTAN3" }
      { x =  56, y = 152, mat = "STARTAN3" }
      { t = 56, mat = "FLAT5_7" }
    }
    {
      { x =  48, y = 144, mat = "STARTAN3" }
      { x =  88, y = 144, mat = "SP_HOT1" }
      { x =  72, y = 152, mat = "STARTAN3" }
      { x =  56, y = 152, mat = "STARTAN3" }
      { b = 192, mat = "CEIL1_2" }
    }

    {
      { x = 104, y = 144, mat = "STARTAN3" }
      { x = 144, y = 144, mat = "STARTAN3" }
      { x = 136, y = 152, mat = "STARTAN3" }
      { x = 120, y = 152, mat = "SP_HOT1" }
      { t = 56, mat = "FLAT5_7" }
    }
    {
      { x = 104, y = 144, mat = "STARTAN3" }
      { x = 144, y = 144, mat = "STARTAN3" }
      { x = 136, y = 152, mat = "STARTAN3" }
      { x = 120, y = 152, mat = "SP_HOT1" }
      { b = 192, mat = "CEIL1_2" }
    }

    -- the pedestal
    {
      { x =  64, y =  80, mat = "GRAY1" }
      { x =  80, y =  64, mat = "GRAY1" }
      { x = 112, y =  64, mat = "GRAY1" }
      { x = 128, y =  80, mat = "GRAY1" }
      { x = 128, y = 112, mat = "GRAY1" }
      { x = 112, y = 128, mat = "GRAY1" }
      { x =  80, y = 128, mat = "GRAY1" }
      { x =  64, y = 112, mat = "GRAY1" }
      { t = 72, mat = "FLAT22" }
    }
  }

  entities =
  {
    { ent = "?item", x = 96, y = 96, z = 72, angle = 90 }
  }
}

