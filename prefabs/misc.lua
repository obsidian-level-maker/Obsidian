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
  brushes=
  {
    -- main stem
    {
      { x =  32, y = -32, mat = "?pillar", peg=1, x_offset=0, y_offset=0 },
      { x =  32, y =  32, mat = "?pillar", peg=1, x_offset=0, y_offset=0 },
      { x = -32, y =  32, mat = "?pillar", peg=1, x_offset=0, y_offset=0 },
      { x = -32, y = -32, mat = "?pillar", peg=1, x_offset=0, y_offset=0 },
    },

    -- trim closest to stem
    {
      { x =  40, y = -40, mat = "?trim2", blocked=1 },
      { x =  40, y =  40, mat = "?trim2", blocked=1 },
      { x = -40, y =  40, mat = "?trim2", blocked=1 },
      { x = -40, y = -40, mat = "?trim2", blocked=1 },
      { t = 20, mat = "?trim2" },
    },

    {
      { x =  40, y = -40, mat = "?trim2", blocked=1 },
      { x =  40, y =  40, mat = "?trim2", blocked=1 },
      { x = -40, y =  40, mat = "?trim2", blocked=1 },
      { x = -40, y = -40, mat = "?trim2", blocked=1 },
      { b = 108, mat = "?trim2" },
    },

    -- roundish and lowest trim
    {
      { x = -40, y = -56, mat = "?trim1" },
      { x =  40, y = -56, mat = "?trim1" },
      { x =  56, y = -40, mat = "?trim1" },
      { x =  56, y =  40, mat = "?trim1" },
      { x =  40, y =  56, mat = "?trim1" },
      { x = -40, y =  56, mat = "?trim1" },
      { x = -56, y =  40, mat = "?trim1" },
      { x = -56, y = -40, mat = "?trim1" },
      { t = 6, mat = "?trim1" },
    },

    {
      { x = -40, y = -56, mat = "?trim1" },
      { x =  40, y = -56, mat = "?trim1" },
      { x =  56, y = -40, mat = "?trim1" },
      { x =  56, y =  40, mat = "?trim1" },
      { x =  40, y =  56, mat = "?trim1" },
      { x = -40, y =  56, mat = "?trim1" },
      { x = -56, y =  40, mat = "?trim1" },
      { x = -56, y = -40, mat = "?trim1" },
      { b = 122, mat = "?trim1" },
    },
  },
}


PREFAB.CRATE =
{
  brushes =
  {
    {
      { x = -32, y = -32, mat = "?crate", peg=1, x_offset="?x_offset", y_offset="?y_offset" },
      { x =  32, y = -32, mat = "?crate", peg=1, x_offset="?x_offset", y_offset="?y_offset" },
      { x =  32, y =  32, mat = "?crate", peg=1, x_offset="?x_offset", y_offset="?y_offset" },
      { x = -32, y =  32, mat = "?crate", peg=1, x_offset="?x_offset", y_offset="?y_offset" },
      { t = 64, mat = "?crate", light = "?light" },
    },
  },
}


PREFAB.QUAKE_TELEPORTER =
{
  brushes =
  {
    -- frame bottom
    {
      { x = -32, y = -8, mat = "?frame" },
      { x =  32, y = -8, mat = "?frame" },
      { x =  32, y =  8, mat = "?frame" },
      { x = -32, y =  8, mat = "?frame" },
      { b =  8, mat = "?frame" },
      { t = 16, mat = "?frame" },
    },

    -- frame top
    {
      { x = -32, y = -8, mat = "?frame" },
      { x =  32, y = -8, mat = "?frame" },
      { x =  32, y =  8, mat = "?frame" },
      { x = -32, y =  8, mat = "?frame" },
      { b = 136, mat = "?frame" },
      { t = 144, mat = "?frame" },
    },

    -- frame left
    {
      { x = -48, y = -8, mat = "?frame" },
      { x = -32, y = -8, mat = "?frame" },
      { x = -32, y =  8, mat = "?frame" },
      { x = -48, y =  8, mat = "?frame" },
      { b =   8, mat = "?frame" },
      { t = 144, mat = "?frame" },
    },

    -- frame right
    {
      { x =  32, y = -8, mat = "?frame" },
      { x =  48, y = -8, mat = "?frame" },
      { x =  48, y =  8, mat = "?frame" },
      { x =  32, y =  8, mat = "?frame" },
      { b =   8, mat = "?frame" },
      { t = 144, mat = "?frame" },
    },
  },
  
  models =
  {
    -- swirly bit
    {
      x1 = -32, x2 =  32, x_face = { mat="TELEPORT" },
      y1 =  -2, y2 =   2, y_face = { mat="TELEPORT" },
      z1 =  16, z2 = 136, z_face = { mat="TELEPORT" },

      entity =
      {
        ent = "wall", light = 10,
      },
    },

    -- trigger
    {
      x1 = -32, x2=  32, x_face = { mat="TRIGGER" },
      y1 = -32, y2=  32, y_face = { mat="TRIGGER" },
      z1 =   0, z2= 144, z_face = { mat="TRIGGER" },

      entity =
      {
        ent = "teleport", target = "?target"
      },
    },
  },

}

