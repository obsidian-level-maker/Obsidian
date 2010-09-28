----------------------------------------------------------------
--  FLOOR PREFABS
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
  brushes =
  {
    {
      { x = -32, y = -32, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  32, y = -32, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  32, y =  32, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = -32, y =  32, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t = 8, mat = "?top", light = "?light" },
    },
  },

  entities =
  {
    { x = 0, y = 0, z = 8, ent = "?item", angle = "?angle" },
  },
}


PREFAB.OCTO_PEDESTAL =
{
  brushes =
  {
    -- reachability
    {
      { m = "walk" },
      { x =  -48, y = -112 },
      { x =   48, y = -112 },
      { x =  112, y =  -48 },
      { x =  112, y =   48 },
      { x =   48, y =  112 },
      { x =  -48, y =  112 },
      { x = -112, y =   48 },
      { x = -112, y =  -48 },
    },

    -- pedestal
    {
      { x = -32, y = -32, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  32, y = -32, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  32, y =  32, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = -32, y =  32, mat = "?top", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t = 16, mat = "?top" },
    },

    -- octogon base
    {
      { x = -40, y = -56, mat = "?base" },
      { x =  40, y = -56, mat = "?base" },
      { x =  56, y = -40, mat = "?base" },
      { x =  56, y =  40, mat = "?base" },
      { x =  40, y =  56, mat = "?base" },
      { x = -40, y =  56, mat = "?base" },
      { x = -56, y =  40, mat = "?base" },
      { x = -56, y = -40, mat = "?base" },
      { t = 8, mat = "?base" },
    },

    -- lighting
    {
      { m = "light", add = 48 },
      { x = -32, y = -56 },
      { x =  32, y = -56 },
      { x =  56, y = -32 },
      { x =  56, y =  32 },
      { x =  32, y =  56 },
      { x = -32, y =  56 },
      { x = -56, y =  32 },
      { x = -56, y = -32 },
    },

    {
      { m = "light", add = 32 },
      { x = -40, y = -80 },
      { x =  40, y = -80 },
      { x =  80, y = -40 },
      { x =  80, y =  40 },
      { x =  40, y =  80 },
      { x = -40, y =  80 },
      { x = -80, y =  40 },
      { x = -80, y = -40 },
    },

    {
      { m = "light", add = 16 },
      { x =  -48, y = -112 },
      { x =   48, y = -112 },
      { x =  112, y =  -48 },
      { x =  112, y =   48 },
      { x =   48, y =  112 },
      { x =  -48, y =  112 },
      { x = -112, y =   48 },
      { x = -112, y =  -48 },
    },

  },

  entities =
  {
    { x = 0, y = 0, z = 16, ent = "?item", angle = "?angle" },
  },
}


PREFAB.LOWERING_PEDESTAL =
{
  brushes =
  {
    {
      { x = -32, y = -32, mat = "?side", special="?line_kind", tag="?tag", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  32, y = -32, mat = "?side", special="?line_kind", tag="?tag", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  32, y =  32, mat = "?side", special="?line_kind", tag="?tag", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = -32, y =  32, mat = "?side", special="?line_kind", tag="?tag", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t = 128, mat = "?top", light = "?light", special="?sec_kind", tag="?tag" },
    },
  },

  entities =
  {
    { x = 0, y = 0, z = 128, ent = "?item" },
  },
}


PREFAB.TELEPORT_PAD =
{
  brushes =
  {
    {
      { x = -32, y = -32, mat = "?side", special="?line_kind", tag="?out_tag", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  32, y = -32, mat = "?side", special="?line_kind", tag="?out_tag", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x =  32, y =  32, mat = "?side", special="?line_kind", tag="?out_tag", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { x = -32, y =  32, mat = "?side", special="?line_kind", tag="?out_tag", peg="?peg", x_offset="?x_offset", y_offset="?y_offset" },
      { t = 16, mat = "?top", light = "?light", special="?sec_kind", tag="?in_tag" },
    },
  },

  entities =
  {
    { x = 0, y = 0, z = 16, ent="?tele_obj", angle="?angle" },
  },
}


PREFAB.BRIDGE_TEST =
{
  placement = "fitted",

  brushes =
  {
    -- liquid area
    {
      { m = "solid", flavor = "floor:2" },
      { x =   0, y =   0, mat = "?liquid" },
      { x = 256, y =   0, mat = "?liquid" },
      { x = 256, y = 256, mat = "?liquid" },
      { x =   0, y = 256, mat = "?liquid" },
      { t = -72, mat = "?liquid" },
    },

    -- bridge
    {
      { m = "solid", flavor = "floor:3" },
      { x = 112, y =   0, mat = "?wall" },
      { x = 144, y =   0, mat = "?wall" },
      { x = 144, y = 256, mat = "?wall" },
      { x = 112, y = 256, mat = "?wall" },
      { t =   0, mat = "?wall" },
    },
  },
}

