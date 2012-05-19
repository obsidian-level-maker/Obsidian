----------------------------------------------------------------
--  ARCH and DOOR PREFABS
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

PREFAB.ARCH =
{
  fitted = "xy"

  defaults =
  {
    track = "?wall"
    step  = "?floor"
  }

  brushes =
  {
    -- step
    {
      { x =  40, y =  0, mat = "?step" }
      { x = 152, y =  0, mat = "?step" }
      { x = 152, y = 48, mat = "?step" }
      { x =  40, y = 48, mat = "?step" }
      { t = 0, mat = "?step" }
    }

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

  }
}


PREFAB.ARCH2 =  -- BORKED : NEED WALK BRUSHES
{
  fitted = "xy"

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


PREFAB.FAT_ARCH1 =
{
  fitted = "xy"

  defaults =
  {
  }

  brushes =
  {
    -- floor
    {
      { x =  24, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y = 192, mat = "?outer" }
      { x =  24, y = 192, mat = "?outer" }
      { t = 0, mat = "?floor" }
    }

    -- left side
    {
      { x =  0, y =   0, mat = "?outer" }
      { x = 24, y =   0, mat = "?wall" }
      { x = 24, y = 192, mat = "?outer" }
      { x =  0, y = 192, mat = "?outer" }
    }

    -- right side
    {
      { x = 168, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y = 192, mat = "?outer" }
      { x = 168, y = 192, mat = "?wall"  }
    }

    -- curved ceiling
    {
      { x = 24, y =   0, mat = "?outer" }
      { x = 44, y =   0, mat = "?wall" }
      { x = 44, y = 192, mat = "?outer" }
      { x = 24, y = 192, mat = "?outer" }
      { b = 96, mat = "?wall" }
    }

    {
      { x = 44, y =   0, mat = "?outer" }
      { x = 64, y =   0, mat = "?wall" }
      { x = 64, y = 192, mat = "?outer" }
      { x = 44, y = 192, mat = "?wall" }
      { b = 128, mat = "?wall" }
    }

    {
      { x = 64, y =   0, mat = "?outer" }
      { x = 84, y =   0, mat = "?wall" }
      { x = 84, y = 192, mat = "?outer" }
      { x = 64, y = 192, mat = "?wall" }
      { b = 156, mat = "?wall" }
    }

    {
      { x =  84, y =   0, mat = "?outer" }
      { x = 108, y =   0, mat = "?wall" }
      { x = 108, y = 192, mat = "?outer" }
      { x =  84, y = 192, mat = "?wall" }
      { b = 164, mat = "?wall" }
    }

    {
      { x = 108, y =   0, mat = "?outer" }
      { x = 128, y =   0, mat = "?wall" }
      { x = 128, y = 192, mat = "?outer" }
      { x = 108, y = 192, mat = "?wall" }
      { b = 156, mat = "?wall" }
    }

    {
      { x = 128, y =   0, mat = "?outer" }
      { x = 148, y =   0, mat = "?wall" }
      { x = 148, y = 192, mat = "?outer" }
      { x = 128, y = 192, mat = "?wall" }
      { b = 128, mat = "?wall" }
    }

    {
      { x = 148, y =   0, mat = "?outer" }
      { x = 168, y =   0, mat = "?wall" }
      { x = 168, y = 192, mat = "?outer" }
      { x = 148, y = 192, mat = "?wall" }
      { b = 96, mat = "?wall" }
    }
  }
}


PREFAB.QUAKE_ARCH =  -- BORKED : NEED WALK BRUSHES
{
  fitted = "xy"

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
  fitted = "xy"

  room_dz = 80

  defaults =
  {
    top = "?step"
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
  fitted = "xy"

  x_ranges = { {8,1}, {24,0}, {128,0,"?door_w"}, {24,0}, {8,1} }
  y_ranges = { {16,1}, {16,0}, {16,1} }
  z_ranges = { {8,0}, {128,0,"?door_h"} }

  defaults =
  {
    door_w = 128
    door_h = 128

    frame = "?wall"
    key   = "?wall"
    step  = "?wall"

    -- Heretic stuff
    statue_ent = "none"

    -- Hexen stuff
    act = ""
    speed = 32
    keynum = ""

    -- Doom64 TC stuff
    color = ""
  }

  brushes =
  {
    -- step
    {
      { x =  32, y =  0, mat = "?step" }
      { x = 160, y =  0, mat = "?step" }
      { x = 160, y = 48, mat = "?step" }
      { x =  32, y = 48, mat = "?step" }
      { t = 8, mat = "?step", light_add = 32, special = "?color" }
    }

    -- frame
    {
      { x =  32, y =  0, mat = "?outer" }
      { x = 160, y =  0, mat = "?outer" }
      { x = 160, y = 48, mat = "?wall" }
      { x =  32, y = 48, mat = "?outer" }
      { b = 136, mat = "?frame" }
    }

    -- door itself
    {
      { x =  32, y = 16, mat = "?door", special="?special", act="?act", arg1="?tag", arg2="?speed", arg4="?keynum", peg=1, x_offset=0, y_offset=0 }
      { x = 160, y = 16, mat = "?door", special="?special", act="?act", arg1="?tag", arg2="?speed", arg4="?keynum", peg=1, x_offset=0, y_offset=0 }
      { x = 160, y = 32, mat = "?door", special="?special", act="?act", arg1="?tag", arg2="?speed", arg4="?keynum", peg=1, x_offset=0, y_offset=0 }
      { x =  32, y = 32, mat = "?door", special="?special", act="?act", arg1="?tag", arg2="?speed", arg4="?keynum", peg=1, x_offset=0, y_offset=0 }
      { b = 24, delta_z=-16, mat = "?door", tag = "?tag" }
    }

    -- left side
    {
      { x =  0, y =  0, mat = "?outer" }
      { x =  8, y =  0, mat = "?wall" }
      { x =  8, y = 24, mat = "?wall" }
      { x =  0, y = 24, mat = "?wall" }
    }

    {
      { x =  8, y =  0, mat = "?outer" }
      { x = 32, y =  0, mat = "?key",   peg=1, x_offset=0, y_offset=0 }
      { x = 32, y = 16, mat = "?track", peg=1, x_offset=0, y_offset=0 }
      { x = 32, y = 32, mat = "?key",   peg=1, x_offset=0, y_offset=0 }
      { x = 32, y = 48, mat = "?wall" }
      { x =  8, y = 24, mat = "?wall" }
    }

    -- right side
    {
      { x = 184, y =  0, mat = "?outer" }
      { x = 192, y =  0, mat = "?wall" }
      { x = 192, y = 24, mat = "?wall" }
      { x = 184, y = 24, mat = "?wall" }
    }

    {
      { x = 160, y = 48, mat = "?key",   peg=1, x_offset=0, y_offset=0 }
      { x = 160, y = 32, mat = "?track", peg=1, x_offset=0, y_offset=0 }
      { x = 160, y = 16, mat = "?key",   peg=1, x_offset=0, y_offset=0 }
      { x = 160, y =  0, mat = "?outer" }
      { x = 184, y =  0, mat = "?outer" }
      { x = 184, y = 24, mat = "?wall" }
    }

--[[
    {
      { m = "light", add = 16 }
      { x =  32, y =   0 }
      { x =  88, y = -56 }
      { x = 104, y = -56 }
      { x = 160, y =   0 }
    }
    {
      { m = "light", add = 16 }
      { x =  32, y = 48 }
      { x = 160, y = 48 }
      { x = 104, y = 104 }
      { x =  88, y = 104 }
    }
--]]

    -- bounding box
    {
      { m = "bbox" }
      { b = 0 }
      { t = 136 }
    }
  }

  entities =
  {
    { ent = "?statue_ent", x =  24, y = 56, z = 0 }
    { ent = "?statue_ent", x = 168, y = -8, z = 0 }
  }
}


PREFAB.QUAKE_DOOR =
{
  fitted = "xy"

  team_models = true

  x_ranges = { {8,1}, {128,0}, {8,1} }

  defaults =
  {
    door = "DR05_2"
    step = "?wall"

    door_flags = 0
    metal = "METAL1_2"
  }

  brushes =
  {
    -- step
    {
      { x =   8, y =  0, mat = "?step" }
      { x = 136, y =  0, mat = "?step" }
      { x = 136, y = 48, mat = "?step" }
      { x =   8, y = 48, mat = "?step" }
      { t = 8, mat = "?step" }
    }

    -- door frame
    {
      { x =  0, y =  0, mat = "?outer" }
      { x =  8, y =  0, mat = "?outer" }
      { x =  8, y = 24, mat = "?wall" }
      { x =  8, y = 48, mat = "?wall" }
      { x =  0, y = 48, mat = "?wall" }
    }

    {
      { x =   8, y =  0, mat = "?outer" }
      { x = 136, y =  0, mat = "?wall" }
      { x = 136, y = 48, mat = "?wall" }
      { x =   8, y = 48, mat = "?wall" }
      { b = 136, mat = "?wall" }
    }

    {
      { x = 136, y =  0, mat = "?outer" }
      { x = 144, y =  0, mat = "?wall" }
      { x = 144, y = 48, mat = "?wall" }
      { x = 136, y = 48, mat = "?wall" }
      { x = 136, y = 24, mat = "?outer" }
    }
  }

  models =
  {
    -- left door
    {
      x1 =  8, x2 = 72,  x_face = { mat="?metal" }
      y1 = 16, y2 = 32,  y_face = { mat="?door", u1=0, u2=64, v1=2, v2=150 }
      z1 =  8, z2 = 136, z_face = { mat="?metal" }

      entity =
      {
        ent = "door", angle = 180, sounds = 2,
        targetname = "?targetname", wait ="?wait",
        spawnflags = "?door_flags", message = "?message",
        team = "?team"
      }
    }

    -- right door
    {
      x1 = 72, x2 = 136, x_face = { mat="?metal" }
      y1 = 16, y2 =  32, y_face = { mat="?door", u1=64, u2=128, v1=2, v2=150 }
      z1 =  8, z2 = 136, z_face = { mat="?metal" }

      entity =
      {
        ent = "door", angle = 0, spawnflags = "?door_flags",
        wait ="?wait", team = "?team"
      }
    }
  }
}


PREFAB.QUAKE_DOOR_W_KEY_PIC =
{
  fitted = "xy"

  team_models = true

  -- this keeps the door 128 units wide and the pics 32 units wide
  x_ranges = { {24,1},{32,0},{24,1}, {144,0}, {24,1},{32,0},{24,1} }

  brushes =
  {
    -- left
    {
      { m = "prefab", skin = "?key_sub", dir = 8 }
      { x =  0, y =  0 }
      { x = 80, y =  0 }
      { x = 80, y = 24 }
      { x =  0, y = 24 }
      { b = 0 }
      { t = 128 }
    }

    {
      { m = "prefab", skin = "?key_sub", dir = 2 }
      { x =  0, y = 24 }
      { x = 80, y = 24 }
      { x = 80, y = 48 }
      { x =  0, y = 48 }
      { b = 0 }
      { t = 128 }
    }

    -- door
    {
      { m = "prefab", skin = "?door_sub" }
      { x =  80, y =  0 }
      { x = 224, y =  0 }
      { x = 224, y = 48 }
      { x =  80, y = 48 }
      { b = 0 }
    }

    -- right
    {
      { m = "prefab", skin = "?key_sub", dir = 8 }
      { x = 224, y =  0 }
      { x = 304, y =  0 }
      { x = 304, y = 24 }
      { x = 224, y = 24 }
      { b = 0 }
      { t = 128 }
    }

    {
      { m = "prefab", skin = "?key_sub", dir = 2 }
      { x = 224, y = 24 }
      { x = 304, y = 24 }
      { x = 304, y = 48 }
      { x = 224, y = 48 }
      { b = 0 }
      { t = 128 }
    }

  }
}


PREFAB.QUAKE_V_DOOR =  -- BORKED : NEED WALK BRUSHES
{
  fitted = "xy"

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
  fitted = "xy"

  defaults =
  {
    step  = "?wall"
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
  fitted = "xy"
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
  fitted = "xy"
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
  fitted = "xy"

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


PREFAB.MINI_DOOR1 =
{
  fitted = "xy"

  x_ranges = { {8,1}, {176,0}, {8,1} }
  y_ranges = { {184,0}, {8,1} }

  defaults =
  {
    wall2 = "?outer"

    special = 1
    tag = ""
  }

  brushes =
  {
    {
      { x =   0, y = 168, mat = "?wall2" }
      { x =   8, y = 168, mat = "?metal" }
      { x =  16, y = 168, mat = "?wall2" }
      { x =  16, y = 192, mat = "?outer" }
      { x =   0, y = 192, mat = "?outer" }
    }

    {
      { x = 176, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y =  64, mat = "?wall2" }
      { x = 176, y =  64, mat = "?wall2" }
    }

    {
      { x =   0, y =   0, mat = "?outer" }
      { x =  16, y =   0, mat = "?wall2" }
      { x =  16, y =  64, mat = "?wall2" }
      { x =   0, y =  64, mat = "?outer" }
    }

    {
      { x = 176, y = 168, mat = "?metal" }
      { x = 184, y = 168, mat = "?wall2" }
      { x = 192, y = 168, mat = "?outer" }
      { x = 192, y = 192, mat = "?outer" }
      { x = 176, y = 192, mat = "?wall2" }
    }

    {
      { x =  16, y = 168, mat = "?wall2" }
      { x =  48, y = 136, mat = "?wall2" }
      { x = 144, y = 136, mat = "?wall2" }
      { x = 176, y = 168, mat = "?wall2" }
      { x = 176, y = 192, mat = "?outer" }
      { x =  16, y = 192, mat = "?wall2" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  16, y = 168, mat = "?wall2" }
      { x =  48, y = 136, mat = "?wall2" }
      { x = 144, y = 136, mat = "?wall2" }
      { x = 176, y = 168, mat = "?wall2" }
      { x = 176, y = 192, mat = "?outer" }
      { x =  16, y = 192, mat = "?wall2" }
      { b = 168, mat = "?ceil", light_add=16 }
    }

    {
      { x =  16, y =   0, mat = "?outer" }
      { x = 176, y =   0, mat = "?wall2" }
      { x = 176, y =  32, mat = "?wall2" }
      { x = 144, y =  64, mat = "?wall2" }
      { x =  48, y =  64, mat = "?wall2" }
      { x =  16, y =  32, mat = "?wall2" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  16, y =   0, mat = "?outer" }
      { x = 176, y =   0, mat = "?wall2" }
      { x = 176, y =  32, mat = "?wall2" }
      { x = 144, y =  64, mat = "?wall2" }
      { x =  48, y =  64, mat = "?wall2" }
      { x =  16, y =  32, mat = "?wall2" }
      { b = 152, mat = "?ceil", light_add=32 }
    }

    {
      { x =  16, y = 128, mat = "?wall2" }
      { x =  32, y = 104, mat = "?wall2" }
      { x =  48, y = 136, mat = "?step" }
      { x =  16, y = 168, mat = "?wall2" }
      { t = 8, mat = "?step" }
    }
    {
      { x =  16, y = 128, mat = "?wall2" }
      { x =  32, y = 104, mat = "?wall2" }
      { x =  48, y = 136, mat = "?wall2" }
      { x =  16, y = 168, mat = "?wall2" }
      { b = 120, mat = "?wall2", light_add=48 }
    }

    {
      { x =   0, y =  64, mat = "?wall2" }
      { x =  16, y =  64, mat = "?wall2" }
      { x =  32, y =  88, mat = "?track", peg=1, y_offset=0 }
      { x =  32, y = 104, mat = "?wall2" }
      { x =  16, y = 128, mat = "?wall2" }
      { x =   0, y = 128, mat = "?outer" }
    }

    {
      { x =  32, y =  88, mat = "?door", special="?special", tag="?tag", peg=1, x_offset=0, y_offset=0 }
      { x = 160, y =  88, mat = "?door" }
      { x = 160, y = 104, mat = "?door", special="?special", tag="?tag", peg=1, x_offset=0, y_offset=0  }
      { x =  32, y = 104, mat = "?door" }
      { b = 24, delta_z=-16, mat = "?door", light_add=32, tag = "?tag" }
    }

    {
      { x = 144, y = 136, mat = "?wall2" }
      { x = 160, y = 104, mat = "?wall2" }
      { x = 176, y = 128, mat = "?wall2" }
      { x = 176, y = 168, mat = "?step" }
      { t = 8, mat = "?step" }
    }
    {
      { x = 144, y = 136, mat = "?wall2" }
      { x = 160, y = 104, mat = "?wall2" }
      { x = 176, y = 128, mat = "?wall2" }
      { x = 176, y = 168, mat = "?wall2" }
      { b = 120, mat = "?wall2", light_add=48 }
    }

    {
      { x = 160, y =  88, mat = "?wall2" }
      { x = 176, y =  64, mat = "?wall2" }
      { x = 192, y =  64, mat = "?outer" }
      { x = 192, y = 128, mat = "?wall2" }
      { x = 176, y = 128, mat = "?wall2" }
      { x = 160, y = 104, mat = "?track", peg=1, y_offset=0 }
    }

    {
      { x =  16, y =  32, mat = "?step" }
      { x =  48, y =  64, mat = "?wall2" }
      { x =  32, y =  88, mat = "?wall2" }
      { x =  16, y =  64, mat = "?wall2" }
      { t = 8, mat = "?step" }
    }
    {
      { x =  16, y =  32, mat = "?wall2" }
      { x =  48, y =  64, mat = "?wall2" }
      { x =  32, y =  88, mat = "?wall2" }
      { x =  16, y =  64, mat = "?wall2" }
      { b = 120, mat = "?wall2", light_add=32 }
    }

    {
      { x = 144, y =  64, mat = "?step" }
      { x = 176, y =  32, mat = "?wall2" }
      { x = 176, y =  64, mat = "?wall2" }
      { x = 160, y =  88, mat = "?wall2" }
      { t = 8, mat = "?step" }
    }
    {
      { x = 144, y =  64, mat = "?wall2" }
      { x = 176, y =  32, mat = "?wall2" }
      { x = 176, y =  64, mat = "?wall2" }
      { x = 160, y =  88, mat = "?wall2" }
      { b = 120, mat = "?wall2", light_add=32 }
    }

    {
      { x =   0, y = 128, mat = "?wall2" }
      { x =  16, y = 128, mat = "?wall2" }
      { x =  16, y = 136, mat = "?metal" }
      { x =   8, y = 136, mat = "?wall2" }
      { x =   0, y = 136, mat = "?outer" }
    }

    {
      { x = 176, y = 128, mat = "?wall2" }
      { x = 192, y = 128, mat = "?outer" }
      { x = 192, y = 136, mat = "?wall2" }
      { x = 184, y = 136, mat = "?metal" }
      { x = 176, y = 136, mat = "?wall2" }
    }

    {
      { x =   8, y = 136, mat = "?wall2" }
      { x =  16, y = 136, mat = "?wall2" }
      { x =  16, y = 168, mat = "?wall2" }
      { x =   8, y = 168, mat = "?wall2" }
      { t = 40, mat = "?metal" }
    }
    {
      { x =   8, y = 136, mat = "?wall2" }
      { x =  16, y = 136, mat = "?wall2" }
      { x =  16, y = 168, mat = "?wall2" }
      { x =   8, y = 168, mat = "?wall2" }
      { b = 96, mat = "?metal", light_add=64 }
    }

    {
      { x =  32, y =  88, mat = "?wall2" }
      { x =  48, y =  64, mat = "?step" }
      { x = 144, y =  64, mat = "?wall2" }
      { x = 160, y =  88, mat = "?wall2" }
      { x = 160, y = 104, mat = "?wall2" }
      { x = 144, y = 136, mat = "?step" }
      { x =  48, y = 136, mat = "?wall2" }
      { x =  32, y = 104, mat = "?wall2" }
      { t = 8, mat = "?step" }
    }
    {
      { x =  32, y =  88, mat = "?wall2" }
      { x =  48, y =  64, mat = "?wall2" }
      { x = 144, y =  64, mat = "?wall2" }
      { x = 160, y =  88, mat = "?wall2" }
      { x = 160, y = 104, mat = "?wall2" }
      { x = 144, y = 136, mat = "?wall2" }
      { x =  48, y = 136, mat = "?wall2" }
      { x =  32, y = 104, mat = "?wall2" }
      { b = 120, mat = "?wall2", light_add=32 }
    }

    {
      { x = 176, y = 136, mat = "?wall2" }
      { x = 184, y = 136, mat = "?wall2" }
      { x = 184, y = 168, mat = "?wall2" }
      { x = 176, y = 168, mat = "?wall2" }
      { t = 40, mat = "?metal" }
    }
    {
      { x = 176, y = 136, mat = "?wall2" }
      { x = 184, y = 136, mat = "?wall2" }
      { x = 184, y = 168, mat = "?wall2" }
      { x = 176, y = 168, mat = "?wall2" }
      { b = 96, mat = "?metal", light_add=64 }
    }

--[[
    {
      { x =  56, y =  32, mat = "?wall2" }
      { x =  80, y =   8, mat = "?wall2" }
      { x = 112, y =   8, mat = "?wall2" }
      { x = 136, y =  32, mat = "?wall2" }
      { x = 112, y =  56, mat = "?wall2" }
      { x =  80, y =  56, mat = "?wall2" }
      { b = 160, mat = "?c_lite", light_add=48 }
    }
--]]

    {
      { x =   0, y = 136, mat = "?wall2" }
      { x =   8, y = 136, mat = "?lite", x_offset=0, y_offset=0 }
      { x =   8, y = 168, mat = "?wall2" }
      { x =   0, y = 168, mat = "?outer" }
    }

    {
      { x = 184, y = 136, mat = "?wall2" }
      { x = 192, y = 136, mat = "?outer" }
      { x = 192, y = 168, mat = "?wall2" }
      { x = 184, y = 168, mat = "?lite", x_offset=0, y_offset=0 }
    }
  }
}

