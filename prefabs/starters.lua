----------------------------------------------------------------
--  START PREFABS
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

PREFAB.START_SPOT =
{
  defaults =
  {
    x_offset = 0
    y_offset = 0
    peg = 0
  }

  brushes =
  {
    {
      { x = -32, y = -32, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  32, y = -32, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x =  32, y =  32, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { x = -32, y =  32, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" }
      { t = 8, mat = "?top" }
    }
  }

  entities =
  {
    { x =   0, y =   0, z = 8, ent = "player1", angle = 270 }
    { x =  36, y =   0, z = 8, ent = "player2", angle = 270 }
    { x = -36, y =   0, z = 8, ent = "player3", angle = 270 }
    { x =   0, y = -36, z = 8, ent = "player4", angle = 270 }
  }
}


PREFAB.START_LEDGE =
{
  fitted = "xy"

  brushes =
  {
    -- wall behind ledge
    {
      { x =   0, y =  0, mat = "?wall" }
      { x = 192, y =  0, mat = "?wall" }
      { x = 192, y = 16, mat = "?wall" }
      { x =   0, y = 16, mat = "?wall" }
    }

    -- ledge
    {
      { x =   0, y = 16, mat = "?wall" }
      { x = 192, y = 16, mat = "?wall" }
      { x = 192, y = 80, mat = "?wall" }
      { x =   0, y = 80, mat = "?wall" }
      { t = 128, y = 80, mat = "?wall" }
    }
  }

  entities =
  {
    { x =  80, y = 48, z = 128, ent = "player1", angle = 90 }
    { x =  40, y = 48, z = 128, ent = "player2", angle = 90 }
    { x = 120, y = 48, z = 128, ent = "player3", angle = 90 }
    { x = 160, y = 48, z = 128, ent = "player4", angle = 90 }
  }
}


PREFAB.START_CLOSET =
{
  y_ranges = { {144,1}, {48,0} }

  defaults =
  {
    door_h = 112

    pic = "?wall"
    pic_ox = 0
    pic_oy = 0

    support = "?wall"
    support_ox = 0

    track = "?wall"
    track_ox = 0

    step_c = "?ceil"

    item1 = "none"
    item2 = "none"
    item3 = "?item2"

    -- Hexen stuff
    act = ""
    speed = 32
  }

  brushes =
  {
    -- wall behind it
    {
      { x =   0, y = 0, mat = "?outer" }
      { x = 192, y = 0, mat = "?outer" }
      { x = 192, y = 8, mat = "?outer" }
      { x = 128, y = 8, mat = "?pic", x_offset="?pic_ox", y_offset="?pic_oy" }
      { x =  64, y = 8, mat = "?outer" }
      { x =   0, y = 8, mat = "?outer" }
    }

    -- floor
    {
      { x =  16, y =   8, mat = "?wall" }
      { x = 176, y =   8, mat = "?wall" }
      { x = 176, y = 144, mat = "?wall" }
      { x =  16, y = 144, mat = "?wall" }
      { t = 0, mat = "?floor" }
    }

    -- ceiling
    {
      { x =  16, y =   8, mat = "?wall" }
      { x = 176, y =   8, mat = "?wall" }
      { x = 176, y = 144, mat = "?wall" }
      { x =  16, y = 144, mat = "?wall" }
      { b = 128, mat = "?ceil" }
    }

    -- left side wall
    {
      { x =  0, y =   8, mat = "?wall" }
      { x = 64, y =   8, mat = "?wall" }
      { x = 16, y = 104, mat = "?wall" }
      { x =  0, y = 104, mat = "?outer" }
    }

    {
      { x =  0, y = 104, mat = "?wall" }
      { x = 16, y = 104, mat = "?wall" }
      { x = 32, y = 144, mat = "?wall" }
      { x =  0, y = 144, mat = "?outer" }
    }

    -- right side wall
    {
      { x = 128, y =   8, mat = "?wall" }
      { x = 192, y =   8, mat = "?outer" }
      { x = 192, y = 104, mat = "?wall" }
      { x = 176, y = 104, mat = "?wall" }
    }

    {
      { x = 176, y = 104, mat = "?wall" }
      { x = 192, y = 104, mat = "?outer" }
      { x = 192, y = 144, mat = "?wall" }
      { x = 160, y = 144, mat = "?wall" }
    }

    -- left side of door
    {
      { x =  0, y = 144, mat = "?wall" }
      { x = 32, y = 144, mat = "?support", x_offset="?support_ox", y_offset=0 }
      { x = 32, y = 160, mat = "?wall" }
      { x =  0, y = 160, mat = "?outer" }
    }

    {
      { x =  0, y = 160, mat = "?wall" }
      { x = 32, y = 160, mat = "?track", x_offset="?track_ox", y_offset=0 }
      { x = 32, y = 176, mat = "?wall" }
      { x =  0, y = 176, mat = "?outer" }
    }

    {
      { x =  0, y = 176, mat = "?wall" }
      { x = 32, y = 176, mat = "?support", x_offset="?support_ox", y_offset=0 }
      { x = 32, y = 192, mat = "?wall" }
      { x =  0, y = 192, mat = "?outer" }
    }

    -- right side of door
    {
      { x = 160, y = 144, mat = "?wall" }
      { x = 192, y = 144, mat = "?outer" }
      { x = 192, y = 160, mat = "?wall" }
      { x = 160, y = 160, mat = "?support", x_offset="?support_ox", y_offset=0 }
    }

    {
      { x = 160, y = 160, mat = "?wall" }
      { x = 192, y = 160, mat = "?outer" }
      { x = 192, y = 176, mat = "?wall" }
      { x = 160, y = 176, mat = "?track", x_offset="?track_ox", y_offset=0 }
    }

    {
      { x = 160, y = 176, mat = "?wall" }
      { x = 192, y = 176, mat = "?outer" }
      { x = 192, y = 192, mat = "?wall" }
      { x = 160, y = 192, mat = "?support", x_offset="?support_ox", y_offset=0 }
    }

    -- step
    {
      { x =  32, y = 144, mat = "?wall" }
      { x = 160, y = 144, mat = "?wall" }
      { x = 160, y = 192, mat = "?wall" }
      { x =  32, y = 192, mat = "?wall" }
      { t = 8, mat = "?step" }
    }

    {
      { x =  32, y = 144, mat = "?wall" }
      { x = 160, y = 144, mat = "?wall" }
      { x = 160, y = 192, mat = "?wall" }
      { x =  32, y = 192, mat = "?wall" }
      { b = "?door_h+8", mat = "?step_c" }
    }

    -- door itself
    {
      { x =  32, y = 160, mat = "?door", special="?special", act="?act", arg1="?tag", arg2="?speed", peg=1, x_offset=0, y_offset=0 }
      { x = 160, y = 160, mat = "?door", special="?special", act="?act", arg1="?tag", arg2="?speed", peg=1, x_offset=0, y_offset=0 }
      { x = 160, y = 176, mat = "?door", special="?special", act="?act", arg1="?tag", arg2="?speed", peg=1, x_offset=0, y_offset=0 }
      { x =  32, y = 176, mat = "?door", special="?special", act="?act", arg1="?tag", arg2="?speed", peg=1, x_offset=0, y_offset=0 }
      { b = 24, delta_z=-16, mat = "?door", tag = "?tag" }
    }
  }

  entities =
  {
    { ent = "player1", x =  96, y = 40, z = 8, angle = 90 }
    { ent = "player2", x =  56, y = 80, z = 8, angle = 90 }
    { ent = "player3", x = 136, y = 80, z = 8, angle = 90 }
    { ent = "player4", x =  96, y = 80, z = 8, angle = 90 }

    { ent = "?item1", x =  96, y = 120, z = 8, angle = 90 }
    { ent = "?item2", x =  56, y = 120, z = 8, angle = 90 }
    { ent = "?item3", x = 136, y = 120, z = 8, angle = 90 }
  }
}

