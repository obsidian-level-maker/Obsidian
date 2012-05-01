----------------------------------------------------------------
--  EXIT PREFABS
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


PREFAB.EXIT_PILLAR =
{
  defaults =
  {
    pillar_h = 128

    act = ""
    next_map = ""

    use_sign = 0

    exit = "?wall"
    exitside = "?wall"
  }

  brushes =
  {
    -- pillar itself
    {
      { x = -32, y = -32, mat = "?switch", special="?special", act="?act", tag="?tag", arg1="?next_map", peg=1, x_offset=0, y_offset=0 }
      { x =  32, y = -32, mat = "?switch", special="?special", act="?act", tag="?tag", arg1="?next_map", peg=1, x_offset=0, y_offset=0 }
      { x =  32, y =  32, mat = "?switch", special="?special", act="?act", tag="?tag", arg1="?next_map", peg=1, x_offset=0, y_offset=0 }
      { x = -32, y =  32, mat = "?switch", special="?special", act="?act", tag="?tag", arg1="?next_map", peg=1, x_offset=0, y_offset=0 }
      { t = "?pillar_h", mat = "?switch" }
    }

    -- exit signs
    {
      { m = "solid", only_if = "?use_sign" }
      { x = -60, y = 44, mat = "?exitside" }
      { x = -32, y = 60, mat = "?exitside" }
      { x = -40, y = 68, mat = "?exit", peg=1, x_offset=0, y_offset=0 }
      { x = -68, y = 52, mat = "?exitside" }
      { t = 16, mat = "?exitside" }
    }

    {
      { m = "solid", only_if = "?use_sign" }
      { x = 60, y = 44, mat = "?exitside" }
      { x = 68, y = 52, mat = "?exit", peg=1, x_offset=0, y_offset=0 }
      { x = 40, y = 68, mat = "?exitside" }
      { x = 32, y = 60, mat = "?exitside" }
      { t = 16, mat = "?exitside" }
    }

    {
      { m = "solid", only_if = "?use_sign" }
      { x = -60, y = -44, mat = "?exitside" }
      { x = -68, y = -52, mat = "?exit", peg=1, x_offset=0, y_offset=0 }
      { x = -40, y = -68, mat = "?exitside" }
      { x = -32, y = -60, mat = "?exitside" }
      { t = 16, mat = "?exitside" }
    }

    {
      { m = "solid", only_if = "?use_sign" }
      { x = 60, y = -44, mat = "?exitside" }
      { x = 32, y = -60, mat = "?exitside" }
      { x = 40, y = -68, mat = "?exit", peg=1, x_offset=0, y_offset=0 }
      { x = 68, y = -52, mat = "?exitside" }
      { t = 16, mat = "?exitside" }
    }
  }
}


PREFAB.OUTDOOR_EXIT_SWITCH =  -- BORKED : NEEDS WALK BRUSHES
{
  brushes =
  {

    -- podium
    {
      { x =  64, y = -64, mat = "?podium" }
      { x =  64, y =  64, mat = "?podium" }
      { x = -64, y =  64, mat = "?podium" }
      { x = -64, y = -64, mat = "?podium" }
      { t = 12, mat = "?podium" }
    }

    -- base of switch
    {
      { x = -36, y = -24, mat = "?base" }
      { x =  36, y = -24, mat = "?base" }
      { x =  44, y = -16, mat = "?base" }
      { x =  44, y =  16, mat = "?base" }
      { x =  36, y =  24, mat = "?base" }
      { x = -36, y =  24, mat = "?base" }
      { x = -44, y =  16, mat = "?base" }
      { x = -44, y = -16, mat = "?base" }
      { t = 22, mat = "?base" }
    }

    -- switch itself
    {
      { x =  32, y = -8, mat = "?base" }
      { x =  32, y =  8, mat = "?switch", special="?special", tag="?tag", peg=1, x_offset=0, y_offset=0 }
      { x = -32, y =  8, mat = "?base" }
      { x = -32, y = -8, mat = "?switch", special="?special", tag="?tag", peg=1, x_offset=0, y_offset=0 }
      { t = 86, mat = "?base" }
    }

    {
      { x = -40, y = 32, mat = "?base" }
      { x = -12, y = 48, mat = "?base" }
      { x = -20, y = 56, mat = "?exit", peg=1, x_offset=0, y_offset=0 }
      { x = -48, y = 40, mat = "?base" }
      { t = 28, mat = "?base" }
    }

    {
      { x = 40, y = 32, mat = "?base" }
      { x = 48, y = 40, mat = "?exit", peg=1, x_offset=0, y_offset=0 }
      { x = 20, y = 56, mat = "?base" }
      { x = 12, y = 48, mat = "?base" }
      { t = 28, mat = "?base" }
    }

    {
      { x = -40, y = -32, mat = "?base" }
      { x = -48, y = -40, mat = "?exit", peg=1, x_offset=0, y_offset=0 }
      { x = -20, y = -56, mat = "?base" }
      { x = -12, y = -48, mat = "?base" }
      { t = 28, mat = "?base" }
    }

    {
      { x = 40, y = -32, mat = "?base" }
      { x = 12, y = -48, mat = "?base" }
      { x = 20, y = -56, mat = "?exit", peg=1, x_offset=0, y_offset=0 }
      { x = 48, y = -40, mat = "?base" }
      { t = 28, mat = "?base" }
    }
  }
}


PREFAB.EXIT_CLOSET =
{
  fitted = "xy"

  x_ranges = { {16,1}, {160,0}, {16,1} }
  y_ranges = { {32,0}, {48,1},  {112,0} }

  defaults =
  {
    key   = "?wall"
    inner = "?wall"
    exit  = "?wall"
    exitside = "?wall"

    door_special = 1
    door_tag = 0
    door_h = 72

    key_ox = 0

    sw_ox = 0
    sw_oy = 0

    item1 = "none"
    item2 = "none"
    item3 = "?item2"

    act = ""

    use_sign = 0
  }

  brushes =
  {
    {
      { x =  32, y = 192, mat = "?wall" }
      { x =  64, y = 160, mat = "?wall" }
      { x = 128, y = 160, mat = "?wall" }
      { x = 160, y = 192, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  32, y = 192, mat = "?wall" }
      { x =  64, y = 160, mat = "?wall" }
      { x = 128, y = 160, mat = "?wall" }
      { x = 160, y = 192, mat = "?wall" }
      { b = 112, mat = "?floor" }
    }
    {
      { m = "light", add = 32 }
      { x =  32, y = 192 }
      { x =  64, y = 160 }
      { x = 128, y = 160 }
      { x = 160, y = 192 }
    }

    {
      { x =  64, y = 128, mat = "?inner", y_offset=0 }
      { x = 128, y = 128, mat = "?wall" }
      { x = 128, y = 160, mat = "?wall" }
      { x =  64, y = 160, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }
    {
      { x =  64, y = 128, mat = "?wall" }
      { x = 128, y = 128, mat = "?wall" }
      { x = 128, y = 160, mat = "?wall" }
      { x =  64, y = 160, mat = "?wall" }
      { b = "?door_h", mat = "?wall" }
    }

    {
      { x =  64, y = 112, mat = "?inner", y_offset=0 }
      { x = 128, y = 112, mat = "?wall" }
      { x = 128, y = 128, mat = "?wall" }
      { x =  64, y = 128, mat = "?wall" }
      { t = 0, mat = "?floor2" }
    }
    {
      { x =  64, y = 112, mat = "?inner", y_offset=0 }
      { x = 128, y = 112, mat = "?inner", y_offset=0 }
      { x = 128, y = 128, mat = "?inner", y_offset=0 }
      { x =  64, y = 128, mat = "?inner", y_offset=0 }
      { b = "?door_h", mat = "?inner", y_offset=0 }
    }

    {
      { m = "light", add = 48 }
      { x =  64, y = 112 }
      { x = 128, y = 112 }
      { x = 128, y = 160 }
      { x =  64, y = 160 }
    }

    -- sides of door
    {
      { x = 128, y = 112, mat = "?inner", y_offset=0 }
      { x = 192, y = 112, mat = "?outer" }
      { x = 192, y = 192, mat = "?wall" }
      { x = 160, y = 192, mat = "?wall" }
      { x = 128, y = 160, mat = "?key", x_offset="?key_ox", y_offset=0, peg=1 }
      { x = 128, y = 144, mat = "?track", x_offset=0, y_offset=0, peg=1 }
      { x = 128, y = 128, mat = "?key", x_offset="?key_ox", y_offset=0, peg=1 }
    }

    {
      { x =   0, y = 112, mat = "?inner", y_offset=0 }
      { x =  64, y = 112, mat = "?key", x_offset="?key_ox", y_offset=0, peg=1 }
      { x =  64, y = 128, mat = "?track", x_offset=0, y_offset=0, peg=1 }
      { x =  64, y = 144, mat = "?key", x_offset="?key_ox", y_offset=0, peg=1 }
      { x =  64, y = 160, mat = "?wall" }
      { x =  32, y = 192, mat = "?wall" }
      { x =   0, y = 192, mat = "?outer" }
    }

    {
      { x =  24, y =  24, mat = "?inner", y_offset=0 }
      { x =  40, y =   8, mat = "?inner", y_offset=0 }
      { x = 152, y =   8, mat = "?inner", y_offset=0 }
      { x = 168, y =  24, mat = "?inner", y_offset=0 }
      { x = 168, y =  96, mat = "?inner", y_offset=0 }
      { x = 152, y = 112, mat = "?inner", y_offset=0 }
      { x =  40, y = 112, mat = "?inner", y_offset=0 }
      { x =  24, y =  96, mat = "?inner", y_offset=0 }
      { t = 0, mat = "?floor2" }
    }
    {
      { x =  24, y =  24, mat = "?inner", y_offset=0 }
      { x =  40, y =   8, mat = "?inner", y_offset=0 }
      { x = 152, y =   8, mat = "?inner", y_offset=0 }
      { x = 168, y =  24, mat = "?inner", y_offset=0 }
      { x = 168, y =  96, mat = "?inner", y_offset=0 }
      { x = 152, y = 112, mat = "?inner", y_offset=0 }
      { x =  40, y = 112, mat = "?inner", y_offset=0 }
      { x =  24, y =  96, mat = "?inner", y_offset=0 }
      { b = 128, mat = "?ceil" }
    }

    {
      { x = 152, y = 112, mat = "?inner", y_offset=0 }
      { x = 168, y =  96, mat = "?inner", y_offset=0 }
      { x = 192, y =  96, mat = "?outer" }
      { x = 192, y = 112, mat = "?inner", y_offset=0 }
    }

    {
      { x = 152, y =   0, mat = "?outer" }
      { x = 192, y =   0, mat = "?outer" }
      { x = 192, y =  24, mat = "?inner", y_offset=0 }
      { x = 168, y =  24, mat = "?inner", y_offset=0 }
      { x = 152, y =   8, mat = "?inner", y_offset=0 }
    }

    {
      { x =   0, y =  24, mat = "?inner", y_offset=0 }
      { x =  24, y =  24, mat = "?inner", y_offset=0 }
      { x =  24, y =  96, mat = "?inner", y_offset=0 }
      { x =   0, y =  96, mat = "?outer" }
    }

    {
      { x =   0, y =  96, mat = "?inner", y_offset=0 }
      { x =  24, y =  96, mat = "?inner", y_offset=0 }
      { x =  40, y = 112, mat = "?inner", y_offset=0 }
      { x =   0, y = 112, mat = "?outer" }
    }

    {
      { x =   0, y =   0, mat = "?outer" }
      { x =  40, y =   0, mat = "?inner", y_offset=0 }
      { x =  40, y =   8, mat = "?inner", y_offset=0 }
      { x =  24, y =  24, mat = "?inner", y_offset=0 }
      { x =   0, y =  24, mat = "?outer" }
    }

    {
      { x =  40, y =   0, mat = "?outer" }
      { x = 152, y =   0, mat = "?inner", y_offset=0 }
      { x = 152, y =   8, mat = "?inner", y_offset=0 }
      { x =  40, y =   8, mat = "?inner", y_offset=0 }
    }

    {
      { x = 168, y =  24, mat = "?inner", y_offset=0 }
      { x = 192, y =  24, mat = "?outer" }
      { x = 192, y =  96, mat = "?inner", y_offset=0 }
      { x = 168, y =  96, mat = "?inner", y_offset=0 }
    }

    -- the door itself
    {
      { x =  64, y = 128, mat = "?door", special="?door_special", tag="?door_tag", x_offset=0, y_offset=0, peg=1 }
      { x = 128, y = 128, mat = "?door" }
      { x = 128, y = 144, mat = "?door", special="?door_special", tag="?door_tag", x_offset=0, y_offset=0, peg=1  }
      { x =  64, y = 144, mat = "?door" }
      { b = 16, delta_z=-16, mat = "?door" }
    }

    -- exit sign
    {
      { m = "solid", only_if = "?use_sign" }
      { x =  80, y = 172, mat = "?exitside" }
      { x = 112, y = 172, mat = "?exitside" }
      { x = 112, y = 180, mat = "?exit", x_offset=0, y_offset=0, peg=1 }
      { x =  80, y = 180, mat = "?exitside" }
      { b = 96, mat = "?exitside" }
    }

    -- the switch
    {
      { x =  64, y =  16, mat = "?sw_side" }
      { x = 128, y =  16, mat = "?sw_side" }
      { x = 128, y =  24, mat = "?switch", special="?special", act="?act", tag="?tag", x_offset="?sw_ox", y_offset="?sw_oy", peg=1 }
      { x =  64, y =  24, mat = "?sw_side" }
      { t = 64, mat = "?sw_side" }
    }
  }

  entities =
  {
    { ent = "?item1", x =  96, y = 64, z = 0, angle = 90 }
    { ent = "?item2", x =  48, y = 48, z = 0, angle = 90 }
    { ent = "?item3", x = 144, y = 48, z = 0, angle = 90 }
  }
}


PREFAB.QUAKE_EXIT_PAD =
{
  brushes =
  {
    -- the pad itself
    {
      { x = -32, y = -32, mat = "?side", x_offset=0, y_offset=0 }
      { x =  32, y = -32, mat = "?side", x_offset=0, y_offset=0 }
      { x =  32, y =  32, mat = "?side", x_offset=0, y_offset=0 }
      { x = -32, y =  32, mat = "?side", x_offset=0, y_offset=0 }
      { t = 16, mat = "?pad" }
    }
  }

  models =
  {
    -- the trigger
    {
      x1 = -20, x2 = 20,  x_face = { mat="TRIGGER" }
      y1 = -20, y2 = 20,  y_face = { mat="TRIGGER" }
      z1 =  16, z2 = 240, z_face = { mat="TRIGGER" }

      entity =
      {
        ent = "change_lev", map = "?next_map",      
      }
    }
  }

  entities =
  {
    { x = 0, y = 0, z = 20, ent = "light", light = 128, style = 10 }
  }
}


PREFAB.QUAKE2_EXIT_PAD =
{
  brushes =
  {
    -- the pad itself
    {
      { x = -32, y = -32, mat = "?side", x_offset=0, y_offset=0 }
      { x =  32, y = -32, mat = "?side", x_offset=0, y_offset=0 }
      { x =  32, y =  32, mat = "?side", x_offset=0, y_offset=0 }
      { x = -32, y =  32, mat = "?side", x_offset=0, y_offset=0 }
      { t = 16, mat = "?pad" }
    }
  }

  models =
  {
    -- the trigger
    {
      x1 = -20, x2 = 20,  x_face = { mat="TRIGGER" }
      y1 = -20, y2 = 20,  y_face = { mat="TRIGGER" }
      z1 =  16, z2 = 240, z_face = { mat="TRIGGER" }

      entity =
      {
        ent = "trigger", target = "?targetname"
      }
    }
  }

  entities =
  {
    { x = 0, y = 0, z = 20, ent = "change_lev", map = "?next_map", targetname = "?targetname" }

    { x = 0, y = 0, z = 20, ent = "light", light = 128, style = 10 }
  }
}


PREFAB.QUAKE_WALL_EXIT =
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

    -- the pad itself
    {
      { x =  64, y = 32, mat = "?pad", x_offset=0, y_offset=0 }
      { x = 128, y = 32, mat = "?pad", x_offset=0, y_offset=0 }
      { x = 128, y = 96, mat = "?pad", x_offset=0, y_offset=0 }
      { x =  64, y = 96, mat = "?pad", x_offset=0, y_offset=0 }
      { t = 16, mat = "?pad" }
    }
  }

  models =
  {
    -- the trigger
    {
      x1 =  76, x2 = 116, x_face = { mat="TRIGGER" }
      y1 =  44, y2 = 84,  y_face = { mat="TRIGGER" }
      z1 =  16, z2 = 240, z_face = { mat="TRIGGER" }

      entity =
      {
        ent = "change_lev", map = "?next_map",      
      }
    }
  }

  entities =
  {
    { x = 96, y = 80, z = 20, ent = "light", light = 128, style = 10 }
  }
}

