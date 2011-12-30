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
  defaults =
  {
    glitter_obj = "none"
  }

  brushes =
  {
    -- pad itself
    {
      { x = -32, y = -32, mat = "?side", special="?special", tag="?out_tag", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  32, y = -32, mat = "?side", special="?special", tag="?out_tag", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  32, y =  32, mat = "?side", special="?special", tag="?out_tag", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = -32, y =  32, mat = "?side", special="?special", tag="?out_tag", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { t = 16, mat = "?top", special="?top_special", tag="?in_tag" }
    }

    -- lighting
    {
      { m = "light", add = 128 }
      { x = -32, y = -32 }
      { x =  32, y = -32 }
      { x =  32, y =  32 }
      { x = -32, y =  32 }
    }
  }

  entities =
  {
    { x = 0, y = 0, z = 16, ent="teleport_spot", angle=90 }
    { x = 0, y = 0, z = 24, ent="?glitter_obj" }
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


PREFAB.HALLWAY_S_BEND =
{
  fitted = "xy"

  defaults =
  {
    upper = "?ceil"

    torch_ent = "none"
    style = 6  -- or 7 or 8
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
    { ent = "?torch_ent", x = 288, y = 40, z = 64 }

    { ent = "light", x = 288, y = 40, z = 96, light = 128, style = "?style" }
  }
}

