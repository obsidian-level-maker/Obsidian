----------------------------------------------------------------
--  CAGE PREFABS
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

PREFAB.CAGE_1 =
{
  brushes =
  {
    {
      { x = -48, y = -48, mat = "?base" },
      { x =  48, y = -48, mat = "?base" },
      { x =  48, y =  48, mat = "?base" },
      { x = -48, y =  48, mat = "?base" },
      { t = 48, mat = "?base" },
    },

--[[
    {
      { x = -48, y = -48, mat = "?pillar" },
      { x =  48, y = -48, mat = "?pillar" },
      { x =  48, y =  48, mat = "?pillar" },
      { x = -48, y =  48, mat = "?pillar" },
      { b = 176, mat = "?pillar" },
    },
--]]

    {
      { m = "rail" },
      { x = -48, y = -48, mat = "?rail", blocked=1 },
      { x =  48, y = -48, mat = "?rail", blocked=1 },
      { x =  48, y =  48, mat = "?rail", blocked=1 },
      { x = -48, y =  48, mat = "?rail", blocked=1 },
      { b = 48 },
      { t = 176 },
    },
  },

  spots =
  {
    { kind = "cage", x = 0, y = 0, z = 48, r = 80, h = 128, angle = 90 },
  },
}


PREFAB.WALL_CAGE =
{
  placement = "fitted",

  brushes =
  {
    -- wall behind it
    {
      { x =   0, y =  0, mat = "?wall" },
      { x = 192, y =  0, mat = "?wall" },
      { x = 192, y = 16, mat = "?wall" },
      { x =   0, y = 16, mat = "?wall" },
    },

    -- space around it
    {
      { m = "air" },
      { x =   0, y =  16 },
      { x = 192, y =  16 },
      { x = 192, y = 144 },
      { x =   0, y = 144 },
    },

    -- platform
    {
      { x =   0, y =  16, mat = "?wall" },
      { x = 192, y =  16, mat = "?wall" },
      { x = 192, y = 144, mat = "?wall" },
      { x =   0, y = 144, mat = "?wall" },
      { t = 64, mat = "?wall" },
    },

    -- railing
    {
      { m = "rail" },
      { x =  16, y =  16,                blocked=1 },
      { x = 176, y =  16, mat = "?rail", blocked=1 },
      { x = 176, y = 128, mat = "?rail", blocked=1 },
      { x =  16, y = 128, mat = "?rail", blocked=1 },
      { b = 64 },
      { t = 192 },
    },
  },

  spots =
  {
    { kind = "cage", x = 96, y = 72, z = 80, r = 72, h = 128, angle = 90 },
  },
}

