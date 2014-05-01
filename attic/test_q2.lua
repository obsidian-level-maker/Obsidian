----------------------------------------------------------------
-- SIMPLE QUAKE-II CSG TEST
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2008 Andrew Apted
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


function test_quake2()

  local ENTITY   = "info_player_start"

  local ROOM_F   = "e1u1/floor3_3"
  local ROOM_C   = "e1u1/grnx2_3"
  local ROOM_W   = "e1u1/exitdr01_2"


  ---===| Entities |===---

  csg2.add_entity(ENTITY, 80, 80, 80)


  ---===| Room |===---

  -- floor
  csg2.add_brush(
  {
    t_face = { texture=ROOM_F },
    b_face = { texture=ROOM_F },
    w_face = { texture=ROOM_F },
  },
  {
    { x=0, y=0 },
    { x=0, y=160 },
    { x=160, y=160 },
    { x=160, y=0 },
  },
  0, 16)

  -- ceiling
  csg2.add_brush(
  {
    t_face = { texture=ROOM_C },
    b_face = { texture=ROOM_C },
    w_face = { texture=ROOM_C },
  },
  {
    { x=0, y=0 },
    { x=0, y=160 },
    { x=160, y=160 },
    { x=160, y=0 },
  },
  144, 160)

  -- walls
  csg2.add_brush(
  {
    t_face = { texture=ROOM_W },
    b_face = { texture=ROOM_W },
    w_face = { texture=ROOM_W },
  },
  {
    { x=0, y=0 },
    { x=0, y=160 },
    { x=16, y=160 },
    { x=16, y=0 },
  },
  16, 144)

  csg2.add_brush(
  {
    t_face = { texture=ROOM_W },
    b_face = { texture=ROOM_W },
    w_face = { texture=ROOM_W },
  },
  {
    { x=144, y=0 },
    { x=144, y=160 },
    { x=160, y=160 },
    { x=160, y=0 },
  },
  16, 144)

  csg2.add_brush(
  {
    t_face = { texture=ROOM_W },
    b_face = { texture=ROOM_W },
    w_face = { texture=ROOM_W },
  },
  {
    { x=16, y=0 },
    { x=16, y=16 },
    { x=144, y=16 },
    { x=144, y=0 },
  },
  16, 144)

  csg2.add_brush(
  {
    t_face = { texture=ROOM_W },
    b_face = { texture=ROOM_W },
    w_face = { texture=ROOM_W },
  },
  {
    { x=16, y=144 },
    { x=16, y=160 },
    { x=144, y=160 },
    { x=144, y=144 },
  },
  16, 144)

end
