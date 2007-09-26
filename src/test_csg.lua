----------------------------------------------------------------
-- SIMPLE CSG TEST
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006,2007 Andrew Apted
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


function test_csg()

  local START_F  = "FLAT22"
  local START_W  = "COMPBLUE"

  local ROOM_F   = "FLOOR7_1"
  local ROOM_W   = "BROWN1"

  local PILLAR_F = "FLAT1"
  local PILLAR_W = "SW1GSTON"

  local NICHE_F  = "GRNLITE1"
  local NICHE_W  = "TEKGREN5"

  local STAIR_F  = "STEP4"
  local STAIR_W  = "FLAT18"

  local BEAM_F   = "FLAT1"
  local BEAM_W   = "SUPPORT2"


  ---- Starting Area ----

  -- floor
  csg2.add_solid(
  {
    t_tex=START_F, b_tex=START_F, w_tex=START_W,
  },
  {
    { x=-136, y=-72 },
    { x=-136, y= 64 },
    { x= 136, y= 64 },
    { x= 136, y=-72 },
  },
  -2048, 64)

  -- ceiling
  csg2.add_solid(
  {
    t_tex=START_F, b_tex=START_F, w_tex=START_W,
  },
  {
    { x=-136, y=-72 },
    { x=-136, y= 64 },
    { x= 136, y= 64 },
    { x= 136, y=-72 },
  },
  144, 2048)

  -- back wall
  csg2.add_solid(
  {
    t_tex=START_F, b_tex=START_F, w_tex=START_W,
  },
  {
    { x=-144, y=-72 },
    { x=-144, y=-64 },
    { x= 144, y=-64 },
    { x= 144, y=-72 },
  },
  -2048, 2048)

  -- left wall
  csg2.add_solid(
  {
    t_tex=START_F, b_tex=START_F, w_tex=START_W,
  },
  {
    { x=-144, y=-80 },
    { x=-144, y= 56 },
    { x=-128, y= 56 },
    { x=-128, y=-80 },
  },
  -2048, 2048)

  -- right wall
  csg2.add_solid(
  {
    t_tex=START_F, b_tex=START_F, w_tex=START_W,
  },
  {
    { x= 128, y=-80 },
    { x= 128, y= 56 },
    { x= 144, y= 56 },
    { x= 144, y=-80 },
  },
  -2048, 2048)


  ---- Main Room ----

  -- floor
  csg2.add_solid(
  {
    t_tex=ROOM_F, b_tex=ROOM_F, w_tex=ROOM_W,
  },
  {
    { x=-384, y=-128 },
    { x=-384, y= 520 },
    { x= 384, y= 520 },
    { x= 384, y=-128 },
  },
  -2048, 0)

  -- ceiling
  csg2.add_solid(
  {
    t_tex=ROOM_F, b_tex=ROOM_F, w_tex=ROOM_W,
  },
  {
    { x=-384, y=-128 },
    { x=-384, y= 520 },
    { x= 384, y= 520 },
    { x= 384, y=-128 },
  },
  192, 2048)

  -- south wall, left
  csg2.add_solid(
  {
    t_tex=ROOM_F, b_tex=ROOM_F, w_tex=ROOM_W,
  },
  {
    { x=-336, y= 56 },
    { x=-336, y= 64 },
    { x=-128, y= 64 },
    { x=-128, y= 56 },
  },
  -2048, 2048)

  -- south wall, right
  csg2.add_solid(
  {
    t_tex=ROOM_F, b_tex=ROOM_F, w_tex=ROOM_W,
  },
  {
    { x= 128, y= 56 },
    { x= 128, y= 64 },
    { x= 336, y= 64 },
    { x= 336, y= 56 },
  },
  -2048, 2048)

  -- north wall, left
  csg2.add_solid(
  {
    t_tex=ROOM_F, b_tex=ROOM_F, w_tex=ROOM_W,
  },
  {
    { x=-336, y= 512 },
    { x=-336, y= 700 },
    { x= -64*0, y= 700 }, --!!!
    { x= -64*0, y= 512 },
  },
  -2048, 2048)

  -- north wall, right
  csg2.add_solid(
  {
    t_tex=ROOM_F, b_tex=ROOM_F, w_tex=ROOM_W,
  },
  {
    { x=  64*0, y= 512 }, --!!!
    { x=  64*0, y= 700 },
    { x= 336, y= 700 },
    { x= 336, y= 512 },
  },
  -2048, 2048)

  -- west wall
  csg2.add_solid(
  {
    t_tex=ROOM_F, b_tex=ROOM_F, w_tex=ROOM_W,
  },
  {
    { x=-320, y=  64 },
    { x=-320, y= 512 },
    { x=-192, y= 512 },
  },
  -2048, 2048)

  -- east wall
  csg2.add_solid(
  {
    t_tex=ROOM_F, b_tex=ROOM_F, w_tex=ROOM_W,
  },
  {
    { x= 192, y= 512 },
    { x= 320, y= 512 },
    { x= 320, y=  64 },
  },
  -2048, 2048)


  ---- Pillar Pair ----

  csg2.add_solid(
  {
    t_tex=PILLAR_F, b_tex=PILLAR_F, w_tex=PILLAR_W,
  },
  {
    { x=-192, y=192 },
    { x=-192, y=256 },
    { x=-128, y=256 },
    { x=-128, y=192 },
  },
  -2048, 2048)

  csg2.add_solid(
  {
    t_tex=PILLAR_F, b_tex=PILLAR_F, w_tex=PILLAR_W,
  },
  {
    { x=128, y=192 },
    { x=128, y=256 },
    { x=192, y=256 },
    { x=192, y=192 },
  },
  -2048, 2048)


  ---- Niche ----

  -- FIXME


  ---- Stairs ----

  -- FIXME


  ---- Support Beams ----

  -- FIXME

end
