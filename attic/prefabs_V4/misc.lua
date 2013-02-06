----------------------------------------------------------------
--  MISCELLANEOUS PREFABS
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2010-2011 Andrew Apted
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


PREFAB.PILLAR_2 =
{
  fitted = "z"

  z_ranges = { {24,1}, {80,6}, {24,1} }

  brushes =
  {
    {
      { m = "solid" }
      { x = -32, y = -16, mat = "?pillar" }
      { x = -16, y = -32, mat = "?pillar" }
      { x =  16, y = -32, mat = "?pillar" }
      { x =  32, y = -16, mat = "?pillar" }
      { x =  32, y =  16, mat = "?pillar" }
      { x =  16, y =  32, mat = "?pillar" }
      { x = -16, y =  32, mat = "?pillar" }
      { x = -32, y =  16, mat = "?pillar" }
    }

    {
      { m = "detail" }
      { x = -48, y = -16, mat = "?base", blocked=1 }
      { x = -16, y = -48, mat = "?base", blocked=1 }
      { x =  16, y = -48, mat = "?base", blocked=1 }
      { x =  48, y = -16, mat = "?base", blocked=1 }
      { x =  48, y =  16, mat = "?base", blocked=1 }
      { x =  16, y =  48, mat = "?base", blocked=1 }
      { x = -16, y =  48, mat = "?base", blocked=1 }
      { x = -48, y =  16, mat = "?base", blocked=1 }
      { t = 24, mat = "?base" }
    }

    {
      { m = "detail" }
      { x = -48, y = -16, mat = "?base" }
      { x = -16, y = -48, mat = "?base" }
      { x =  16, y = -48, mat = "?base" }
      { x =  48, y = -16, mat = "?base" }
      { x =  48, y =  16, mat = "?base" }
      { x =  16, y =  48, mat = "?base" }
      { x = -16, y =  48, mat = "?base" }
      { x = -48, y =  16, mat = "?base" }
      { b = 104, mat = "?base" }
    }

    -- bounds in Z axis
    {
      { b = 0 }
      { t = 128 }
    }

    -- clipping (for Quake)
    {
      { m = "clip" }
      { x = -32, y = -32 }
      { x =  32, y = -32 }
      { x =  32, y =  32 }
      { x = -32, y =  32 }
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
  defaults =
  {
    side = "?tele"
    effect_ent = "none"
  }

  brushes =
  {
    -- pad itself
    {
      { x = -32, y = -32, mat = "?side", special="?special", tag="?out_tag", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  32, y = -32, mat = "?side", special="?special", tag="?out_tag", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  32, y =  32, mat = "?side", special="?special", tag="?out_tag", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = -32, y =  32, mat = "?side", special="?special", tag="?out_tag", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { t = 16, mat = "?tele", tag="?in_tag" }
    }

    -- lighting
    {
      { m = "light", add = 128, effect = "?effect" }
      { x = -32, y = -32 }
      { x =  32, y = -32 }
      { x =  32, y =  32 }
      { x = -32, y =  32 }
    }
  }

  entities =
  {
    { ent="teleport_spot", x = 0, y = 0, z = 16, angle=90 }
    { ent="?effect_ent",   x = 0, y = 0, z = 24 }
  }
}


PREFAB.TELEPORT_CLOSET =
{
  fitted = "xy"

  x_ranges = { {16,0}, {160,0}, {16,1} }
  y_ranges = { {16,1}, {176,0} }

  defaults =
  {
    effect = 8
  }

  brushes =
  {
    {
      { x = 128, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y =  64, mat = "?wall" }
      { x = 176, y =  64, mat = "?inner" }
      { x = 128, y =  16, mat = "?wall" }
    }

    {
      { x =   0, y = 112, mat = "?wall" }
      { x =  16, y = 112, mat = "?inner" }
      { x =  40, y = 144, mat = "?inner" }
      { x =  32, y = 160, mat = "?inner" }
      { x =  24, y = 176, mat = "?inner" }
      { x =  16, y = 192, mat = "?wall" }
      { x =   0, y = 192, mat = "?outer" }
    }

    {
      { x = 152, y = 144, mat = "?inner" }
      { x = 176, y = 112, mat = "?wall" }
      { x = 192, y = 112, mat = "?outer" }
      { x = 192, y = 192, mat = "?wall" }
      { x = 176, y = 192, mat = "?inner" }
      { x = 168, y = 176, mat = "?inner" }
      { x = 160, y = 160, mat = "?inner" }
    }

    {
      { x =   0, y =   0, mat = "?outer" }
      { x =  64, y =   0, mat = "?wall" }
      { x =  64, y =  16, mat = "?inner" }
      { x =  16, y =  64, mat = "?wall" }
      { x =   0, y =  64, mat = "?outer" }
    }

    {
      { x =  16, y = 192, mat = "?wall" }
      { x =  24, y = 176, mat = "?wall" }
      { x = 168, y = 176, mat = "?wall" }
      { x = 176, y = 192, mat = "?step", peg=1, y_offset=0  }
      { t = 8, mat = "?floor" }
    }
    {
      { x =  16, y = 192, mat = "?wall" }
      { x =  24, y = 176, mat = "?wall" }
      { x = 168, y = 176, mat = "?wall" }
      { x = 176, y = 192, mat = "?wall" }
      { b = 168, mat = "?ceil" }
    }

    {
      { x =  24, y = 176, mat = "?wall" }
      { x =  32, y = 160, mat = "?wall" }
      { x = 160, y = 160, mat = "?wall" }
      { x = 168, y = 176, mat = "?step", peg=1, y_offset=0 }
      { t = 16, mat = "?floor" }
    }
    {
      { x =  24, y = 176, mat = "?ceil" }
      { x =  32, y = 160, mat = "?ceil" }
      { x = 160, y = 160, mat = "?ceil" }
      { x = 168, y = 176, mat = "?ceil" } --- "?step", peg=0, y_offset=0 }
      { b = 160, mat = "?ceil" }
    }

    {
      { x =  32, y = 160, mat = "?wall" }
      { x =  40, y = 144, mat = "?wall" }
      { x = 152, y = 144, mat = "?wall" }
      { x = 160, y = 160, mat = "?step", peg=1, y_offset=0 }
      { t = 24, mat = "?floor" }
    }
    {
      { x =  32, y = 160, mat = "?ceil" }
      { x =  40, y = 144, mat = "?ceil" }
      { x = 152, y = 144, mat = "?ceil" }
      { x = 160, y = 160, mat = "?ceil" } --- "?step", peg=0, y_offset=0 }
      { b = 152, mat = "?ceil" }
    }

    {
      { x =  16, y =  64, mat = "?wall" }
      { x =  64, y =  16, mat = "?wall" }
      { x = 128, y =  16, mat = "?wall" }
      { x = 176, y =  64, mat = "?wall" }
      { x = 176, y = 112, mat = "?wall" }
      { x = 152, y = 144, mat = "?wall" }
      { x =  40, y = 144, mat = "?wall" }
      { x =  16, y = 112, mat = "?wall" }
      { t = 24, mat = "?floor" }
    }
    {
      { x =  16, y =  64, mat = "?wall" }
      { x =  64, y =  16, mat = "?wall" }
      { x = 128, y =  16, mat = "?wall" }
      { x = 176, y =  64, mat = "?wall" }
      { x = 176, y = 112, mat = "?wall" }
      { x = 152, y = 144, mat = "?wall" }
      { x =  40, y = 144, mat = "?wall" }
      { x =  16, y = 112, mat = "?wall" }
      { b = 152, mat = "?ceil" }
    }
    {
      { m = "light", add = 255, effect = "?effect" }
      { x =  16, y =  64 }
      { x =  64, y =  16 }
      { x = 128, y =  16 }
      { x = 176, y =  64 }
      { x = 176, y = 112 }
      { x = 152, y = 144 }
      { x =  40, y = 144 }
      { x =  16, y = 112 }
    }

    {
      { x =  64, y =  64, mat = "?tele_side", special="?special", tag="?out_tag", peg=1, y_offset=0 }
      { x = 128, y =  64, mat = "?tele_side", special="?special", tag="?out_tag", peg=1, y_offset=0  }
      { x = 128, y = 128, mat = "?tele_side", special="?special", tag="?out_tag", peg=1, y_offset=0  }
      { x =  64, y = 128, mat = "?tele_side", special="?special", tag="?out_tag", peg=1, y_offset=0  }
      { t = 32, mat = "?tele" }
    }
    {
      { x =  64, y =  64, mat = "?tele_side" }
      { x = 128, y =  64, mat = "?tele_side" }
      { x = 128, y = 128, mat = "?tele_side" }
      { x =  64, y = 128, mat = "?tele_side" }
      { b = 144, mat = "?tele", tag = "?in_tag" }
    }

    {
      { x =  64, y =   0, mat = "?outer" }
      { x = 128, y =   0, mat = "?wall" }
      { x = 128, y =  16, mat = "?inner" }
      { x =  64, y =  16, mat = "?wall" }
    }

    {
      { x =   0, y =  64, mat = "?wall" }
      { x =  16, y =  64, mat = "?inner" }
      { x =  16, y = 112, mat = "?wall" }
      { x =   0, y = 112, mat = "?outer" }
    }

    {
      { x = 176, y =  64, mat = "?wall" }
      { x = 192, y =  64, mat = "?outer" }
      { x = 192, y = 112, mat = "?wall" }
      { x = 176, y = 112, mat = "?inner" }
    }
  }

  entities =
  {
    { ent = "teleport_spot", x = 96, y = 96, z = 40, angle = 90 }
  }
}


PREFAB.HEXEN_GATE =
{
  brushes =
  {
    -- left side
    {
      { x = -48, y = -64, mat = "?frame" }
      { x = -32, y = -64, mat = "?frame" }
      { x = -32, y =   0, mat = "?frame" }
      { x = -80, y =   0, mat = "?frame" }
    }

    -- right side
    {
      { x =  32, y = -64, mat = "?frame" }
      { x =  48, y = -64, mat = "?frame" }
      { x =  80, y =   0, mat = "?frame" }
      { x =  32, y =   0, mat = "?frame" }
    }

    -- back side
    {
      { x = -32, y = -80, mat = "?frame" }
      { x =  32, y = -80, mat = "?frame" }
      { x =  48, y = -64, mat = "?frame" }
      { x = -48, y = -64, mat = "?frame" }
    }

    -- bottom
    {
      { x = -32, y = -64, mat = "?frame" }
      { x =  32, y = -64, mat = "?frame" }
      { x =  32, y =   0, mat = "?frame" }
      { x = -32, y =   0, mat = "?frame" }
      { t = 16, mat = "?frame" }
    }

    -- top
    {
      { x = -32, y = -64, mat = "?frame" }
      { x =  32, y = -64, mat = "?frame" }
      { x =  32, y =   0, mat = "?frame" }
      { x = -32, y =   0, mat = "?frame" }
      { b = 144, mat = "?frame" }
    }

    -- frame texture
    {
      { m = "rail" }
      { x = -32, y = -64 }
      { x =  32, y = -64 }
      { x =  32, y = -16, mat = "R_TPORTX", special=74, act="WR", arg1="?dest_map", arg2="?dest_id" }
      { x = -32, y = -16 }
      { b =  16 }
      { t = 144 }
    }

    -- teleport texture
    {
      { m = "rail" }
      { x = -32, y = -64 }
      { x =  32, y = -64 }
      { x =  32, y = -20, mat = "R_TPORT1" }
      { x = -32, y = -20 }
      { b =  16 }
      { t = 144 }
    }

    -- make the inside area dark
    {
      { m = "light", sub = 256 }
      { x = -32, y = -64 }
      { x =  32, y = -64 }
      { x =  32, y = -20 }
      { x = -32, y = -20 }
    }
  }

  entities =
  {
    -- return spot
    { x =   0, y = 24, z = 16, ent="player1", angle=90, arg1="?source_id" }
    { x = -48, y = 24, z = 16, ent="player2", angle=90, arg1="?source_id" }
    { x =  48, y = 24, z = 16, ent="player3", angle=90, arg1="?source_id" }
    { x =   0, y = 72, z = 16, ent="player4", angle=90, arg1="?source_id" }
  }
}


PREFAB.QUAKE_TELEPORTER =
{
  brushes =
  {
    -- frame bottom
    {
      { x = -32, y = -64, mat = "?frame" }
      { x =  32, y = -64, mat = "?frame" }
      { x =  32, y = -48, mat = "?frame" }
      { x = -32, y = -48, mat = "?frame" }
      { b =  8, mat = "?frame" }
      { t = 16, mat = "?frame" }
    }

    -- frame top
    {
      { x = -32, y = -64, mat = "?frame" }
      { x =  32, y = -64, mat = "?frame" }
      { x =  32, y = -48, mat = "?frame" }
      { x = -32, y = -48, mat = "?frame" }
      { b = 136, mat = "?frame" }
      { t = 144, mat = "?frame" }
    }

    -- frame left
    {
      { x = -48, y = -64, mat = "?frame" }
      { x = -32, y = -64, mat = "?frame" }
      { x = -32, y = -48, mat = "?frame" }
      { x = -48, y = -48, mat = "?frame" }
      { b =   8, mat = "?frame" }
      { t = 144, mat = "?frame" }
    }

    -- frame right
    {
      { x =  32, y = -64, mat = "?frame" }
      { x =  48, y = -64, mat = "?frame" }
      { x =  48, y = -48, mat = "?frame" }
      { x =  32, y = -48, mat = "?frame" }
      { b =   8, mat = "?frame" }
      { t = 144, mat = "?frame" }
    }
  }
  
  models =
  {
    -- swirly bit
    {
      x1 = -32, x2 =  32, x_face = { mat="TELEPORT" }
      y1 = -58, y2 = -54, y_face = { mat="TELEPORT" }
      z1 =  16, z2 = 136, z_face = { mat="TELEPORT" }

      entity =
      {
        ent = "wall", light = 10
      }
    }

    -- trigger
    {
      x1 = -32, x2=  32, x_face = { mat="TRIGGER" }
      y1 = -80, y2= -32, y_face = { mat="TRIGGER" }
      z1 =   0, z2= 144, z_face = { mat="TRIGGER" }

      entity =
      {
        ent = "teleport", target = "?out_target"
      }
    }
  }

  entities =
  {
    -- return spot
    { x = 0, y = 16, z = 8, ent="teleport_spot", angle=90,
      targetname = "?in_target"
    }
  }
}


PREFAB.QUAKE2_TELEPORTER =
{
  brushes =
  {
    -- dummy brush to set the size
    {
      { m = "bbox" }
      { x =  -64, y = -64 }
      { x =   64, y = -64 }
      { x =   64, y =  64 }
      { x =  -64, y =  64 }
    }
  }

  entities =
  {
    -- teleporter itself
    { x = 0, y = -32, z = 8, ent="teleporter", angle=90,
      target = "?out_target"
    }

    -- return spot
    { x = 0, y = 32, z = 8, ent="teleport_spot", angle=90,
      targetname = "?in_target"
    }
  }
}


PREFAB.TECH_DITTO_1 =
{
  brushes =
  {
    -- carpet floor
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


