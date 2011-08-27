----------------------------------------------------------------
--  PEDESTAL PREFABS
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

PREFAB.PEDESTAL =
{
  defaults =
  {
    height = 8
    light  = 60
    style  = ""
    angle  = 0
    x_offset = ""
    y_offset = ""
    peg = ""
  }

  brushes =
  {
    {
      { x = -32, y = -32, mat = "?side", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  32, y = -32, mat = "?side", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  32, y =  32, mat = "?side", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = -32, y =  32, mat = "?side", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { t = "?height", mat = "?top", light = "?light" }
    }
  }

  entities =
  {
    -- the item itself
    { x = 0, y = 0, z = "?height", ent = "?item", angle = "?angle" }

    -- light source
    { x= 0, y = 0, z = 32, ent = "light", light = "?light", style = "?style" }
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
    { x = 0, y = 0, z = 16, ent = "?item", angle = "?angle" }

    -- light source
    { x= 0, y = 0, z = 40, ent = "light", light = "?light", style = "?style" }
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
    { x = 0, y = 0, z = 128, ent = "?item" }
  }
}


PREFAB.ITEM_NICHE =
{
  placement = "fitted"

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


