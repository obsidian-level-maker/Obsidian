----------------------------------------------------------------
--  ARCH and DOOR PREFABS
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

PREFAB.ARCH =
{
  placement = "fitted"

  defaults =
  {
    outer = "?wall"
    track = "?wall"
  }

  brushes =
  {
    -- left side
    {
      { x = 0,  y =  0, mat = "?outer" }
      { x = 40, y =  0, mat = "?outer" }
      { x = 40, y = 16, mat = "?track" }
      { x = 40, y = 32, mat = "?wall"  }
      { x = 40, y = 48, mat = "?wall"  }
      { x = 0,  y = 48, mat = "?wall"  }
      { x = 0,  y = 24, mat = "?outer" }
    }

    -- right side
    {
      { x = 152, y =  0, mat = "?outer" }
      { x = 192, y =  0, mat = "?outer" }
      { x = 192, y = 24, mat = "?wall"  }
      { x = 192, y = 48, mat = "?wall"  }
      { x = 152, y = 48, mat = "?wall"  }
      { x = 152, y = 32, mat = "?track" }
      { x = 152, y = 16, mat = "?outer" }
    }

    -- top back
    {
      { x =  40, y =  0, mat = "?outer" }
      { x = 152, y =  0, mat = "?outer" }
      { x = 152, y = 16, mat = "?outer" }
      { x =  40, y = 16, mat = "?outer" }
      { b = 128, mat = "?outer" }
    }

    -- top back
    {
      { x =  40, y = 32, mat = "?wall" }
      { x = 152, y = 32, mat = "?wall" }
      { x = 152, y = 48, mat = "?wall" }
      { x =  40, y = 48, mat = "?wall" }
      { b = 128, mat = "?wall" }
    }

    -- track
    {
      { x =  40, y = 16, mat = "?track" }
      { x = 152, y = 16, mat = "?track" }
      { x = 152, y = 32, mat = "?track" }
      { x =  40, y = 32, mat = "?track" }
      { b = 128, mat = "?track" }
    }

    -- walk areas
    {
      { m = "walk", room = 1 }
      { x =  40, y =  24 }
      { x = 152, y =  24 }
      { x = 152, y = 112 }
      { x =  40, y = 112 }
      { b = 0 }
      { t = 144 }
    }

    {
      { m = "walk", room = 2 }
      { x =  40, y = -64 }
      { x = 152, y = -64 }
      { x = 152, y =  24 }
      { x =  40, y =  24 }
      { b = 0 }
      { t = 144 }
    }
  }
}


PREFAB.ARCH2 =  -- BORKED : NEED WALK BRUSHES
{
  placement = "fitted"

  brushes =
  {
    -- frame
    {
      { x = 0,   y =  0, mat = "?outer" }
      { x = 192, y =  0, mat = "?outer" }
      { x = 192, y = 48, mat = "?wall" }
      { x = 0,   y = 48, mat = "?outer" }
      { b = 128, mat = "?outer" }
    }

    -- left side
    {
      { x = 0,  y =  0, mat = "?outer" }
      { x = 40, y =  0, mat = "?outer" }
      { x = 52, y = 16, mat = "?track" }
      { x = 52, y = 32, mat = "?wall" }
      { x = 40, y = 48, mat = "?wall" }
      { x = 0,  y = 48, mat = "?wall" }
    }

    -- right side
    {
      { x = 192, y = 48, mat = "?wall" }
      { x = 152, y = 48, mat = "?wall" }
      { x = 140, y = 32, mat = "?track" }
      { x = 140, y = 16, mat = "?outer" }
      { x = 152, y =  0, mat = "?outer" }
      { x = 192, y =  0, mat = "?wall" }
    }
  }
}


PREFAB.QUAKE_ARCH =  -- BORKED : NEED WALK BRUSHES
{
  placement = "fitted"

  brushes =
  {
    -- frame
    {
      { x = 0,   y = 12, mat = "?outer" }
      { x = 192, y = 12, mat = "?outer" }
      { x = 192, y = 36, mat = "?wall" }
      { x = 0,   y = 36, mat = "?outer" }
      { b = 136, mat = "?outer" }
    }

    -- left side
    {
      { x = 0,  y = 12, mat = "?outer" }
      { x = 40, y = 12, mat = "?wall" }
      { x = 40, y = 36, mat = "?wall" }
      { x = 0,  y = 36, mat = "?wall" }
    }

    -- right side
    {
      { x = 152, y = 12, mat = "?outer" }
      { x = 192, y = 12, mat = "?wall" }
      { x = 192, y = 36, mat = "?wall" }
      { x = 152, y = 36, mat = "?wall" }
    }

    ---- 3D FRAME ----

    -- top
    {
      { x = 48,  y =  0, mat = "?frame" }
      { x = 144, y =  0, mat = "?frame" }
      { x = 144, y = 48, mat = "?frame" }
      { x = 48,  y = 48, mat = "?frame" }
      { b = 128, mat = "?frame" }
      { t = 136, mat = "?frame" }
    }

    -- left
    {
      { x = 40, y =  0, mat = "?frame" }
      { x = 48, y =  0, mat = "?frame" }
      { x = 48, y = 48, mat = "?frame" }
      { x = 40, y = 48, mat = "?frame" }
      { t = 136, mat = "?frame" }
    }

    -- right
    {
      { x = 144, y =  0, mat = "?frame" }
      { x = 152, y =  0, mat = "?frame" }
      { x = 152, y = 48, mat = "?frame" }
      { x = 144, y = 48, mat = "?frame" }
      { t = 136, mat = "?frame" }
    }
  }
}



PREFAB.ARCH_W_STAIR =  --  BORKED : Replace flavored brushes with "hole" brush,
                       --           And needs "walk" brushes.
{
  placement = "fitted"

  room_dz = 80

  defaults =
  {
    top = "?step"
    outer = "?wall"
  }

  brushes =
  {
    -- frame
    {
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y = 128, mat = "?wall" }
      { x = 0,   y = 128, mat = "?wall" }
      { x = 0,   y =   0, mat = "?wall" }
      { b = 192, mat = "?wall" }
    }

    -- left side
    {
      { x = 0,  y =   0, mat = "?outer" }
      { x = 16, y =   0, mat = "?wall" }
      { x = 16, y = 128, mat = "?wall" }
      { x = 0,  y = 128, mat = "?wall" }
    }

    -- right side
    {
      { x = 176, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?wall" }
      { x = 192, y = 128, mat = "?wall" }
      { x = 176, y = 128, mat = "?wall" }
    }

    -- steps
    {
      { m = "solid", flavor = "floor:2" }
      { x =  16, y =  0, mat = "?step" }
      { x = 176, y =  0, mat = "?step" }
      { x = 176, y = 32, mat = "?step" }
      { x =  16, y = 32, mat = "?step" }
      { t = 64, mat = "?top" }
    }

    {
      { m = "solid", flavor = "floor:2" }
      { x =  16, y = 32, mat = "?step" }
      { x = 176, y = 32, mat = "?step" }
      { x = 176, y = 64, mat = "?step" }
      { x =  16, y = 64, mat = "?step" }
      { t = 48, mat = "?top" }
    }

    {
      { m = "solid", flavor = "floor:2" }
      { x =  16, y = 64, mat = "?step" }
      { x = 176, y = 64, mat = "?step" }
      { x = 176, y = 96, mat = "?step" }
      { x =  16, y = 96, mat = "?step" }
      { t = 32, mat = "?top" }
    }

    {
      { m = "solid", flavor = "floor:2" }
      { x =  16, y =  96, mat = "?step" }
      { x = 176, y =  96, mat = "?step" }
      { x = 176, y = 128, mat = "?step" }
      { x =  16, y = 128, mat = "?step" }
      { t = 16, mat = "?top" }
    }
  }
}


----------------------------------------------------------------


PREFAB.DOOR =
{
  placement = "fitted"

  x_ranges = { {32}, {128,0,"?width"}, {32} }

  z_ranges = { {128,0,"?height"} }

  defaults =
  {
    width  = 128
    height = 128

    outer = "?wall"

    key  = "?wall"
    step = "?wall"
  }

  brushes =
  {
    -- frame
    {
      { x =   4, y =  0, mat = "?outer" }
      { x = 188, y =  0, mat = "?outer" }
      { x = 188, y = 48, mat = "?wall" }
      { x =   4, y = 48, mat = "?outer" }
      { b = 136, mat = "?frame" }
    }

    -- step
    {
      { x =   4, y =  0, mat = "?step" }
      { x = 188, y =  0, mat = "?step" }
      { x = 188, y = 48, mat = "?step" }
      { x =   4, y = 48, mat = "?step" }
      { t = 8, mat = "?step", light = 0.7 }
    }

    -- door itself
    {
      { x =  32, y = 16, mat = "?door", special="?line_kind", peg=1, x_offset=0, y_offset=0 }
      { x = 160, y = 16, mat = "?door", special="?line_kind", peg=1, x_offset=0, y_offset=0 }
      { x = 160, y = 32, mat = "?door", special="?line_kind", peg=1, x_offset=0, y_offset=0 }
      { x =  32, y = 32, mat = "?door", special="?line_kind", peg=1, x_offset=0, y_offset=0 }
      { b = 24, delta_z=-16, mat = "?door", light = 0.7, tag = "?tag" }
    }

    -- left side
    {
      { x =  0, y =  0, mat = "?outer" }
      { x = 14, y =  0, mat = "?outer" }
      { x = 14, y = 48, mat = "?wall" }
      { x =  0, y = 48, mat = "?wall" }
      { x =  0, y = 24, mat = "?outer" }
    }

    {
      { x = 14, y =  0, mat = "?key",   peg=1, x_offset=0, y_offset=0 }
      { x = 32, y = 16, mat = "?track", peg=1, x_offset=0, y_offset=0 }
      { x = 32, y = 32, mat = "?key",   peg=1, x_offset=0, y_offset=0 }
      { x = 14, y = 48, mat = "?key",   peg=1, x_offset=0, y_offset=0 }
    }

    -- right side
    {
      { x = 178, y =  0, mat = "?outer" }
      { x = 192, y =  0, mat = "?outer" }
      { x = 192, y = 24, mat = "?wall" }
      { x = 192, y = 48, mat = "?wall" }
      { x = 178, y = 48, mat = "?outer" }
    }

    {
      { x = 160, y = 16, mat = "?key",   peg=1, x_offset=0, y_offset=0 }
      { x = 178, y =  0, mat = "?key",   peg=1, x_offset=0, y_offset=0 }
      { x = 178, y = 48, mat = "?key",   peg=1, x_offset=0, y_offset=0 }
      { x = 160, y = 32, mat = "?track", peg=1, x_offset=0, y_offset=0 }
    }

    -- walk areas
    {
      { m = "walk", room = 1 }
      { x =  40, y =  24 }
      { x = 152, y =  24 }
      { x = 152, y = 112 }
      { x =  40, y = 112 }
      { b = 0 }
      { t = 160 }
    }

    {
      { m = "walk", room = 2 }
      { x =  40, y = -64 }
      { x = 152, y = -64 }
      { x = 152, y =  24 }
      { x =  40, y =  24 }
      { b = 0 }
      { t = 160 }
    }
  }
}


PREFAB.QUAKE_DOOR =
{
  placement = "fitted"

  team_models = true

  defaults =
  {
    outer = "?wall"

    door = "DR05_2"
    step = "?wall"

    door_flags = 0
  }

  brushes =
  {
    -- step
    {
      { x =  32, y =  0, mat = "?step" }
      { x = 160, y =  0, mat = "?step" }
      { x = 160, y = 48, mat = "?step" }
      { x =  32, y = 48, mat = "?step" }
      { t = 8, mat = "?step" }
    }

    -- door frame
    {
      { x = 0,  y =  0, mat = "?outer" }
      { x = 32, y =  0, mat = "?outer" }
      { x = 32, y = 24, mat = "?wall" }
      { x = 32, y = 48, mat = "?wall" }
      { x = 0,  y = 48, mat = "?wall" }
    }

    {
      { x = 32,  y =  0, mat = "?outer" }
      { x = 160, y =  0, mat = "?wall" }
      { x = 160, y = 48, mat = "?wall" }
      { x = 32,  y = 48, mat = "?wall" }
      { b = 136, mat = "?wall" }
    }

    {
      { x = 160, y =  0, mat = "?outer" }
      { x = 192, y =  0, mat = "?wall" }
      { x = 192, y = 48, mat = "?wall" }
      { x = 160, y = 48, mat = "?wall" }
      { x = 160, y = 24, mat = "?outer" }
    }

    -- walk areas
    {
      { m = "walk", room = 1 }
      { x =  40, y =  24 }
      { x = 152, y =  24 }
      { x = 152, y = 112 }
      { x =  40, y = 112 }
      { b = 0 }
      { t = 160 }
    }

    {
      { m = "walk", room = 2 }
      { x =  40, y = -64 }
      { x = 152, y = -64 }
      { x = 152, y =  24 }
      { x =  40, y =  24 }
      { b = 0 }
      { t = 160 }
    }
  }

  models =
  {
    -- left side
    {
      x1 = 32, x2 = 96,  x_face = { mat="METAL1_2" }
      y1 = 16, y2 = 32,  y_face = { mat="?door", u1=0, u2=64, v1=2, v2=150 }
      z1 =  8, z2 = 136, z_face = { mat="METAL1_2" }

      entity =
      {
        ent = "door", angle = 180, sounds = 2,
        targetname = "?targetname", wait ="?wait",
        spawnflags = "?door_flags", message = "?message",
        team = "?team"
      }
    }

    -- right side
    {
      x1 = 96, x2 = 160, x_face = { mat="METAL1_2" }
      y1 = 16, y2 =  32, y_face = { mat="?door", u1=64, u2=128, v1=2, v2=150 }
      z1 =  8, z2 = 136, z_face = { mat="METAL1_2" }

      entity =
      {
        ent = "door", angle = 0, spawnflags = "?door_flags",
        wait ="?wait", team = "?team"
      }
    }
  }
}


PREFAB.QUAKE_DOOR_W_KEY_PIC =  -- Experiment of prefab composition
{
  placement = "fitted"
  team_models = true,

  brushes =
  {
    -- left
    {
      { m = "prefab", skin = "?key_sub" }
      { x =  0, y =  0 }
      { x = 64, y =  0 }
      { x = 64, y = 48 }
      { x =  0, y = 48 }
      { b = 32 }
    }

    -- door
    {
      { m = "prefab", skin = "?door_sub" }
      { x =  64, y =  0 }
      { x = 256, y =  0 }
      { x = 256, y = 48 }
      { x =  64, y = 48 }
      { b = 0 }
    }

    -- right
    {
      { m = "prefab", skin = "?key_sub" }
      { x = 256, y =  0 }
      { x = 320, y =  0 }
      { x = 320, y = 48 }
      { x = 256, y = 48 }
      { b = 32 }
    }
  }
}


PREFAB.QUAKE_V_DOOR =  -- BORKED : NEED WALK BRUSHES
{
  placement = "fitted"

  team_models = true

  defaults =
  {
    door = "DR05_2"
  }

  brushes =
  {
    -- step
    {
      { x = 192, y =  0, mat = "?step" }
      { x = 192, y = 48, mat = "?step" }
      { x =   0, y = 48, mat = "?step" }
      { x =   0, y =  0, mat = "?step" }
      { t = 8, mat = "?step" }
    }

    -- door frame
    {
      { x = 192, y =  0, mat = "?outer" }
      { x = 192, y = 48, mat = "?wall" }
      { x = 0,   y = 48, mat = "?outer" }
      { x = 0,   y =  0, mat = "?outer" }
      { b = 136, mat = "?outer" }
    }

    {
      { x = 0,  y =  0, mat = "?outer" }
      { x = 32, y =  0, mat = "?outer" }
      { x = 32, y = 16, mat = "?track" }
      { x = 32, y = 32, mat = "?wall" }
      { x = 32, y = 48, mat = "?wall" }
      { x = 0,  y = 48, mat = "?wall" }
    }

    {
      { x = 192, y = 48, mat = "?wall" }
      { x = 160, y = 48, mat = "?wall" }
      { x = 160, y = 32, mat = "?track" }
      { x = 160, y = 16, mat = "?outer" }
      { x = 160, y =  0, mat = "?outer" }
      { x = 192, y =  0, mat = "?wall" }
    }
  }

  models =
  {
    -- low part
    {
      x1 = 32, x2 = 160, x_face = { mat="METAL1_2" }
      y1 = 16, y2 =  32, y_face = { mat="?door" }
      z1 =  8, z2 =  72, z_face = { mat="METAL1_2" }

      entity =
      {
        ent = "door", angles = "90 0 0", sounds = 2,
        targetname = "?targetname", wait ="?wait",
        spawnflags = "?door_flags", message = "?message",
        team = "?team"
      }
    }

    -- high part
    {
      x1 = 32, x2 = 160, x_face = { mat="METAL1_2" }
      y1 = 16, y2 =  32, y_face = { mat="?door" }
      z1 = 72, z2 = 136, z_face = { mat="METAL1_2" }

      entity =
      {
        ent = "door", angles = "270 0 0", spawnflags = "?door_flags",
        wait ="?wait", team = "?team"
      }
    }
  }
}


PREFAB.QUAKE2_KEY_DOOR =
{
  placement = "fitted"

  defaults =
  {
    step  = "?wall"
    outer = "?wall"
    track = "?wall"
    metal = "METAL1_2"

    door_flags = 16  -- NO_MONSTER
    trig_flags = 0
    wait = -1
  }

  brushes =
  {
    -- step
    {
      { x = 192, y =  0, mat = "?step" }
      { x = 192, y = 48, mat = "?step" }
      { x =   0, y = 48, mat = "?step" }
      { x =   0, y =  0, mat = "?step" }
      { t = 8, mat = "?step" }
    }

    -- door frame
    {
      { x = 192, y =  0, mat = "?outer" }
      { x = 192, y = 48, mat = "?wall" }
      { x = 0,   y = 48, mat = "?outer" }
      { x = 0,   y =  0, mat = "?outer" }
      { b = 136, mat = "?outer" }
    }

    {
      { x = 0,  y =  0, mat = "?outer" }
      { x = 32, y =  0, mat = "?outer" }
      { x = 32, y = 16, mat = "?track" }
      { x = 32, y = 32, mat = "?wall" }
      { x = 32, y = 48, mat = "?wall" }
      { x = 0,  y = 48, mat = "?wall" }
    }

    {
      { x = 192, y = 48, mat = "?wall" }
      { x = 160, y = 48, mat = "?wall" }
      { x = 160, y = 32, mat = "?track" }
      { x = 160, y = 16, mat = "?outer" }
      { x = 160, y =  0, mat = "?outer" }
      { x = 192, y =  0, mat = "?wall" }
    }
  }

  models =
  {
    -- door itself
    {
      x1 = 32, x2 = 160, x_face = { mat="?metal" }
      y1 = 16, y2 =  32, y_face = { mat="?door" }
      z1 =  8, z2 = 136, z_face = { mat="?metal" }

      entity =
      {
        ent = "door", angles = "270 0 0", sounds = 2,
        targetname = "?targetname", wait ="?wait",
        spawnflags = "?door_flags"
      }
    }

    -- trigger
    {
      x1 =  32, x2 = 160, x_face = { mat="TRIGGER" }
      y1 = -16, y2 =  64, y_face = { mat="TRIGGER" }
      z1 =   8, z2 = 136, z_face = { mat="TRIGGER" }

      entity =
      {
        ent = "trigger",
        target = "?keyname",
        spawnflags = "?trig_flags"
      }
    }
  }

  entities =
  {
    -- key target
    { x = 128, y = 16, z = 32, ent = "trig_key", item = "?item",
      targetname = "?keyname", target = "?targetname",
      spawnflags = 16
    }
  }
}



PREFAB.QUAKE_4_WAY =  -- FIXME: step, WALK BRUSHES
{
  placement = "fitted"
  team_models = true

  defaults =
  {
    door = "DR05_2"
  }

  brushes =
  {
    -- door frame
    {
      { x = 192, y =  0, mat = "?outer" }
      { x = 192, y = 48, mat = "?wall" }
      { x = 0,   y = 48, mat = "?outer" }
      { x = 0,   y =  0, mat = "?outer" }
      { b = 128, mat = "?outer" }
    }

    {
      { x = 0,  y =  0, mat = "?outer" }
      { x = 32, y =  0, mat = "?outer" }
      { x = 32, y = 16, mat = "?track" }
      { x = 32, y = 32, mat = "?wall" }
      { x = 32, y = 48, mat = "?wall" }
      { x = 0,  y = 48, mat = "?wall" }
    }

    {
      { x = 192, y = 48, mat = "?wall" }
      { x = 160, y = 48, mat = "?wall" }
      { x = 160, y = 32, mat = "?track" }
      { x = 160, y = 16, mat = "?outer" }
      { x = 160, y =  0, mat = "?outer" }
      { x = 192, y =  0, mat = "?wall" }
    }
  }

  models =
  {
    -- bottom left
    {
      x1 = 32, x2 = 96, x_face = { mat="METAL1_2" }
      y1 = 16, y2 = 32, y_face = { mat="?door" }
      z1 =  0, z2 = 64, z_face = { mat="METAL1_2" }

      entity =
      {
        ent = "door", angles = "90 0 0", sounds = 2,
        spawnflags = "?door_flags", message = "?message",
        targetname = "?targetname", wait ="?wait",
      }
    }

    -- bottom right
    {
      x1 = 96, x2 = 160, x_face = { mat="METAL1_2" }
      y1 = 16, y2 =  32, y_face = { mat="?door" }
      z1 =  0, z2 =  64, z_face = { mat="METAL1_2" }

      entity =
      {
        ent = "door", angle = 0, spawnflags = "?door_flags",
        wait ="?wait",
      }
    }

    -- top left
    {
      x1 = 32, x2 =  96, x_face = { mat="METAL1_2" }
      y1 = 16, y2 =  32, y_face = { mat="?door" }
      z1 = 64, z2 = 128, z_face = { mat="METAL1_2" }

      entity =
      {
        ent = "door", angle = 180, spawnflags = "?door_flags",
        wait ="?wait",
      }
    }

    -- top right
    {
      x1 = 96, x2 = 160, x_face = { mat="METAL1_2" }
      y1 = 16, y2 =  32, y_face = { mat="?door" }
      z1 = 64, z2 = 128, z_face = { mat="METAL1_2" }

      entity =
      {
        ent = "door", angles = "270 0 0", spawnflags = "?door_flags",
        wait ="?wait",
      }
    }
  }
}


PREFAB.QUAKE2_DIAG_4_WAY =  -- FIXME: step, WALK BRUSHES
{
  placement = "fitted"
  team_models = true

  brushes =
  {
    -- door frame
    {
      { x = 192, y =  0, mat = "?outer" }
      { x = 192, y = 48, mat = "?wall" }
      { x = 0,   y = 48, mat = "?outer" }
      { x = 0,   y =  0, mat = "?outer" }
      { b = 128, mat = "?outer" }
    }

    {
      { x = 0,  y =  0, mat = "?outer" }
      { x = 32, y =  0, mat = "?outer" }
      { x = 32, y = 16, mat = "?track" }
      { x = 32, y = 32, mat = "?wall" }
      { x = 32, y = 48, mat = "?wall" }
      { x = 0,  y = 48, mat = "?wall" }
    }

    {
      { x = 192, y = 48, mat = "?wall" }
      { x = 160, y = 48, mat = "?wall" }
      { x = 160, y = 32, mat = "?track" }
      { x = 160, y = 16, mat = "?outer" }
      { x = 160, y =  0, mat = "?outer" }
      { x = 192, y =  0, mat = "?wall" }
    }
  }

  models =
  {
    -- bottom left
    {
      x1 = 32, x2 = 96, x_face = { mat="METAL1_2" }
      y1 = 16, y2 = 32, y_face = { mat="DR05_2" }
      z1 =  0, z2 = 64, z_face = { mat="METAL1_2" }

      entity =
      {
        ent = "door", angles = "45 180 0", lip=24, sounds=2,
      }
    }

    -- bottom right
    {
      x1 = 96, x2 = 160, x_face = { mat="METAL1_2" }
      y1 = 16, y2 =  32, y_face = { mat="DR05_2" }
      z1 =  0, z2 =  64, z_face = { mat="METAL1_2" }

      entity =
      {
        ent = "door", angles = "45 0 0", lip=24,
      }
    }

    -- top left
    {
      x1 = 32, x2 =  96, x_face = { mat="METAL1_2" }
      y1 = 16, y2 =  32, y_face = { mat="DR05_2" }
      z1 = 64, z2 = 128, z_face = { mat="METAL1_2" }

      entity =
      {
        ent = "door", angles = "315 180 0", lip=24,
      }
    }

    -- top right
    {
      x1 = 96, x2 = 160, x_face = { mat="METAL1_2" }
      y1 = 16, y2 =  32, y_face = { mat="DR05_2" }
      z1 = 64, z2 = 128, z_face = { mat="METAL1_2" }

      entity =
      {
        ent = "door", angles = "315 0 0", lip=24,
      }
    }
  }
}


PREFAB.BARS =  -- BORKED : NEED WALK BRUSHES
{
  placement = "fitted"

  brushes =
  {
    -- step
    {
      { x =   0, y =  0, mat = "?step" }
      { x = 192, y =  0, mat = "?step" }
      { x = 192, y = 48, mat = "?step" }
      { x =   0, y = 48, mat = "?step" }
      { t =   4,         mat = "?step" }
    }

    -- the actual bars
    {
      { x = 18, y = 12, mat = "?bar", peg=1, x_offset=0, y_offset=0 }
      { x = 42, y = 12, mat = "?bar", peg=1, x_offset=0, y_offset=0 }
      { x = 42, y = 36, mat = "?bar", peg=1, x_offset=0, y_offset=0 }
      { x = 18, y = 36, mat = "?bar", peg=1, x_offset=0, y_offset=0 }
      { t = "?height", mat = "?bar", tag="?tag" }
    }
    {
      { x = 62, y = 12, mat = "?bar", peg=1, x_offset=0, y_offset=0 }
      { x = 86, y = 12, mat = "?bar", peg=1, x_offset=0, y_offset=0 }
      { x = 86, y = 36, mat = "?bar", peg=1, x_offset=0, y_offset=0 }
      { x = 62, y = 36, mat = "?bar", peg=1, x_offset=0, y_offset=0 }
      { t = "?height", mat = "?bar", tag="?tag" }
    }
    {
      { x = 106, y = 12, mat = "?bar", peg=1, x_offset=0, y_offset=0 }
      { x = 130, y = 12, mat = "?bar", peg=1, x_offset=0, y_offset=0 }
      { x = 130, y = 36, mat = "?bar", peg=1, x_offset=0, y_offset=0 }
      { x = 106, y = 36, mat = "?bar", peg=1, x_offset=0, y_offset=0 }
      { t = "?height", mat = "?bar", tag="?tag" }
    }
    {
      { x = 150, y = 12, mat = "?bar", peg=1, x_offset=0, y_offset=0 }
      { x = 174, y = 12, mat = "?bar", peg=1, x_offset=0, y_offset=0 }
      { x = 174, y = 36, mat = "?bar", peg=1, x_offset=0, y_offset=0 }
      { x = 150, y = 36, mat = "?bar", peg=1, x_offset=0, y_offset=0 }
      { t = "?height", mat = "?bar", tag="?tag" }
    }
  }
}


