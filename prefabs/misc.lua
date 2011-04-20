----------------------------------------------------------------
--  MISCELLANEOUS PREFABS
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

PREFAB.PILLAR =
{
  brushes =
  {
    -- main stem
    {
      { x =  32, y = -32, mat = "?pillar", peg=1, x_offset=0, y_offset=0 }
      { x =  32, y =  32, mat = "?pillar", peg=1, x_offset=0, y_offset=0 }
      { x = -32, y =  32, mat = "?pillar", peg=1, x_offset=0, y_offset=0 }
      { x = -32, y = -32, mat = "?pillar", peg=1, x_offset=0, y_offset=0 }
    }

    -- trim closest to stem
    {
      { x =  40, y = -40, mat = "?trim2", blocked=1 }
      { x =  40, y =  40, mat = "?trim2", blocked=1 }
      { x = -40, y =  40, mat = "?trim2", blocked=1 }
      { x = -40, y = -40, mat = "?trim2", blocked=1 }
      { t = 20, mat = "?trim2" }
    }

    {
      { x =  40, y = -40, mat = "?trim2", blocked=1 }
      { x =  40, y =  40, mat = "?trim2", blocked=1 }
      { x = -40, y =  40, mat = "?trim2", blocked=1 }
      { x = -40, y = -40, mat = "?trim2", blocked=1 }
      { b = 108, mat = "?trim2" }
    }

    -- roundish and lowest trim
    {
      { x = -40, y = -56, mat = "?trim1" }
      { x =  40, y = -56, mat = "?trim1" }
      { x =  56, y = -40, mat = "?trim1" }
      { x =  56, y =  40, mat = "?trim1" }
      { x =  40, y =  56, mat = "?trim1" }
      { x = -40, y =  56, mat = "?trim1" }
      { x = -56, y =  40, mat = "?trim1" }
      { x = -56, y = -40, mat = "?trim1" }
      { t = 6, mat = "?trim1" }
    }

    {
      { x = -40, y = -56, mat = "?trim1" }
      { x =  40, y = -56, mat = "?trim1" }
      { x =  56, y = -40, mat = "?trim1" }
      { x =  56, y =  40, mat = "?trim1" }
      { x =  40, y =  56, mat = "?trim1" }
      { x = -40, y =  56, mat = "?trim1" }
      { x = -56, y =  40, mat = "?trim1" }
      { x = -56, y = -40, mat = "?trim1" }
      { b = 122, mat = "?trim1" }
    }
  }
}


PREFAB.ROUND_PILLAR =
{
  brushes =
  {
    {
      { m = "detail" }
      { x = -32, y =   0, mat = "?pillar" }
      { x = -22, y = -22, mat = "?pillar" }
      { x =   0, y = -32, mat = "?pillar" }
      { x =  22, y = -22, mat = "?pillar" }
      { x =  32, y =   0, mat = "?pillar" }
      { x =  22, y =  22, mat = "?pillar" }
      { x =   0, y =  32, mat = "?pillar" }
      { x = -22, y =  22, mat = "?pillar" }
    }

    -- clipping (for Quake)
    {
      { m = "clip" }
      { x = -28, y = -28 }
      { x =  28, y = -28 }
      { x =  28, y =  28 }
      { x = -28, y =  28 }
    }
  }
}


PREFAB.CRATE =
{
  defaults =
  {
    x_offset = 0
    y_offset = 0
  }

  brushes =
  {
    {
      { x = -32, y = -32, mat = "?crate", peg=1, x_offset="?x_offset", y_offset="?y_offset" }
      { x =  32, y = -32, mat = "?crate", peg=1, x_offset="?x_offset", y_offset="?y_offset" }
      { x =  32, y =  32, mat = "?crate", peg=1, x_offset="?x_offset", y_offset="?y_offset" }
      { x = -32, y =  32, mat = "?crate", peg=1, x_offset="?x_offset", y_offset="?y_offset" }
      { t = 64, mat = "?crate" }
    }
  }
}


PREFAB.QUAKE_TECHLAMP =
{
  defaults =
  {
    side  = "TLIGHT11"
    top   = "METAL1_1"
    light = 128
    style = { [0]=50, [10]=10 }
  }

  brushes =
  {
    {
      { x = -8, y = -8, mat = "?side", peg=1, x_offset=0, y_offset=0 }
      { x =  8, y = -8, mat = "?side", peg=1, x_offset=0, y_offset=0 }
      { x =  8, y =  8, mat = "?side", peg=1, x_offset=0, y_offset=0 }
      { x = -8, y =  8, mat = "?side", peg=1, x_offset=0, y_offset=0 }
      { t = 64, mat = "?top" }
    }
  }

  entities =
  {
    { x = -16, y = 0, z = 56, ent="light", light = "?light", style = "?style" }
    { x =  16, y = 0, z = 56, ent="light", light = "?light", style = "?style" }
    { x = 0, y = -16, z = 56, ent="light", light = "?light", style = "?style" }
    { x = 0, y =  16, z = 56, ent="light", light = "?light", style = "?style" }
  }
}


PREFAB.TELEPORT_PAD =
{
  brushes =
  {
    {
      { x = -32, y = -32, mat = "?side", special="?line_kind", tag="?out_tag", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  32, y = -32, mat = "?side", special="?line_kind", tag="?out_tag", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  32, y =  32, mat = "?side", special="?line_kind", tag="?out_tag", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = -32, y =  32, mat = "?side", special="?line_kind", tag="?out_tag", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { t = 16, mat = "?top", light = "?light", special="?sec_kind", tag="?in_tag" }
    }
  }

  entities =
  {
    { x = 0, y = 0, z = 16, ent="?tele_obj", angle="?angle" }
  }
}


PREFAB.QUAKE_TELEPORTER =
{
  brushes =
  {
    -- frame bottom
    {
      { x = -32, y = -8, mat = "?frame" }
      { x =  32, y = -8, mat = "?frame" }
      { x =  32, y =  8, mat = "?frame" }
      { x = -32, y =  8, mat = "?frame" }
      { b =  8, mat = "?frame" }
      { t = 16, mat = "?frame" }
    }

    -- frame top
    {
      { x = -32, y = -8, mat = "?frame" }
      { x =  32, y = -8, mat = "?frame" }
      { x =  32, y =  8, mat = "?frame" }
      { x = -32, y =  8, mat = "?frame" }
      { b = 136, mat = "?frame" }
      { t = 144, mat = "?frame" }
    }

    -- frame left
    {
      { x = -48, y = -8, mat = "?frame" }
      { x = -32, y = -8, mat = "?frame" }
      { x = -32, y =  8, mat = "?frame" }
      { x = -48, y =  8, mat = "?frame" }
      { b =   8, mat = "?frame" }
      { t = 144, mat = "?frame" }
    }

    -- frame right
    {
      { x =  32, y = -8, mat = "?frame" }
      { x =  48, y = -8, mat = "?frame" }
      { x =  48, y =  8, mat = "?frame" }
      { x =  32, y =  8, mat = "?frame" }
      { b =   8, mat = "?frame" }
      { t = 144, mat = "?frame" }
    }
  }
  
  models =
  {
    -- swirly bit
    {
      x1 = -32, x2 =  32, x_face = { mat="TELEPORT" }
      y1 =  -2, y2 =   2, y_face = { mat="TELEPORT" }
      z1 =  16, z2 = 136, z_face = { mat="TELEPORT" }

      entity =
      {
        ent = "wall", light = 10,
      }
    }

    -- trigger
    {
      x1 = -32, x2=  32, x_face = { mat="TRIGGER" }
      y1 = -32, y2=  32, y_face = { mat="TRIGGER" }
      z1 =   0, z2= 144, z_face = { mat="TRIGGER" }

      entity =
      {
        ent = "teleport", target = "?target"
      }
    }
  }
}


PREFAB.TECH_DITTO_1 =
{
  brushes =
  {
    -- carpet floor
    {
      { m = "air" }
      { x =  -64, y = -160 }
      { x =   64, y = -160 }
      { x =  160, y =  -64 }
      { x =  160, y =   64 }
      { x =   64, y =  160 }
      { x =  -64, y =  160 }
      { x = -160, y =   64 }
      { x = -160, y =  -64 }
      { b = 0 }
      { t = 128 }
    }

    {
      { x =  -64, y = -128, mat = "?carpet" }
      { x =   64, y = -128, mat = "?carpet" }
      { x =  128, y =  -64, mat = "?carpet" }
      { x =  128, y =   64, mat = "?carpet" }
      { x =   64, y =  128, mat = "?carpet" }
      { x =  -64, y =  128, mat = "?carpet" }
      { x = -128, y =   64, mat = "?carpet" }
      { x = -128, y =  -64, mat = "?carpet" }
      { t = 2, mat = "?carpet", delta_z = -12 }
    }

    -- central computer pillar
    {
      { x = -32, y = -32, mat = "?computer", peg=1, x_offset=0, y_offset=0 }
      { x =  32, y = -32, mat = "?computer", peg=1, x_offset=0, y_offset=0 }
      { x =  32, y =  32, mat = "?computer", peg=1, x_offset=0, y_offset=0 }
      { x = -32, y =  32, mat = "?computer", peg=1, x_offset=0, y_offset=0 }
      { t = 104, mat = "?computer" }
    }

    -- side computer bits
    {
      { x =  32, y = -32, mat = "?compside", peg=1, x_offset=0, y_offset=0 }
      { x =  56, y = -32, mat = "?computer", peg=1, x_offset=0, y_offset=0 }
      { x =  56, y =  32, mat = "?compside", peg=1, x_offset=0, y_offset=0 }
      { x =  32, y =  32, mat = "?compside", peg=1, x_offset=0, y_offset=0 }
      { t = 56, mat = "?compside" }
    }

    {
      { x = -56, y = -32, mat = "?compside", peg=1, x_offset=0, y_offset=0 }
      { x = -32, y = -32, mat = "?compside", peg=1, x_offset=0, y_offset=0 }
      { x = -32, y =  32, mat = "?compside", peg=1, x_offset=0, y_offset=0 }
      { x = -56, y =  32, mat = "?computer", peg=1, x_offset=0, y_offset=0 }
      { t = 56, mat = "?compside" }
    }

    {
      { x = -32, y = -56, mat = "?computer", peg=1, x_offset=0, y_offset=0 }
      { x =  32, y = -56, mat = "?compside", peg=1, x_offset=0, y_offset=0 }
      { x =  32, y = -32, mat = "?compside", peg=1, x_offset=0, y_offset=0 }
      { x = -32, y = -32, mat = "?compside", peg=1, x_offset=0, y_offset=0 }
      { t = 56, mat = "?compside" }
    }

    {
      { x = -32, y =  32, mat = "?compside", peg=1, x_offset=0, y_offset=0 }
      { x =  32, y =  32, mat = "?compside", peg=1, x_offset=0, y_offset=0 }
      { x =  32, y =  56, mat = "?computer", peg=1, x_offset=0, y_offset=0 }
      { x = -32, y =  56, mat = "?compside", peg=1, x_offset=0, y_offset=0 }
      { t = 56, mat = "?compside" }
    }

    -- feet
    {
      { x = 56, y = -32, mat = "?feet" }
      { x = 72, y = -48, mat = "?feet" }
      { x = 88, y = -48, mat = "?feet" }
      { x = 88, y =  48, mat = "?feet" }
      { x = 72, y =  48, mat = "?feet" }
      { x = 56, y =  32, mat = "?feet" }
      { t = 8, mat = "?feet" }
    }

    {
      { x = -88, y = -48, mat = "?feet" }
      { x = -72, y = -48, mat = "?feet" }
      { x = -56, y = -32, mat = "?feet" }
      { x = -56, y =  32, mat = "?feet" }
      { x = -72, y =  48, mat = "?feet" }
      { x = -88, y =  48, mat = "?feet" }
      { t = 8, mat = "?feet" }
    }

    {
      { x = -48, y = -88, mat = "?feet" }
      { x =  48, y = -88, mat = "?feet" }
      { x =  48, y = -72, mat = "?feet" }
      { x =  32, y = -56, mat = "?feet" }
      { x = -32, y = -56, mat = "?feet" }
      { x = -48, y = -72, mat = "?feet" }
      { t = 8, mat = "?feet" }
    }

    {
      { x =  48, y = 88, mat = "?feet" }
      { x = -48, y = 88, mat = "?feet" }
      { x = -48, y = 72, mat = "?feet" }
      { x = -32, y = 56, mat = "?feet" }
      { x =  32, y = 56, mat = "?feet" }
      { x =  48, y = 72, mat = "?feet" }
      { t = 8, mat = "?feet" }
    }

    -- lighting
    {
      { m = "light", add = 32 }
      { x =  -64, y = -128 }
      { x =   64, y = -128 }
      { x =  128, y =  -64 }
      { x =  128, y =   64 }
      { x =   64, y =  128 }
      { x =  -64, y =  128 }
      { x = -128, y =   64 }
      { x = -128, y =  -64 }
    }
  }
}

