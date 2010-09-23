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

