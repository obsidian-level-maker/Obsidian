----------------------------------------------------------------
-- SIMPLE CSG TEST
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


function test_csg()

--[[ DOOM
  local ENTITY   = "1"

  local START_F  = "FLAT22"
  local START_W  = "COMPBLUE"

  local ROOM_F   = "FLOOR7_1"
  local ROOM_W   = "BROWN1"

  local NICHE_F  = "GRNLITE1"
  local NICHE_W  = "TEKGREN2"
--]]

-- [[ QUAKE 1
  local ENTITY   = "info_player_start"

  local START_F  = "tech01_1"
  local START_W  = "tech01_1"

  local ROOM_F   = "city1_4"
  local ROOM_W   = "city1_4"

  local NICHE_F  = "ground1_1"
  local NICHE_W  = "ground1_1"
--]]

--[[ OPEN ARENA
  local ENTITY   = "info_player_deathmatch"

  local START_F  = "e7/e7sbrickfloor"
  local START_W  = "e7/e7sbrickfloor"

  local ROOM_F   = "e7/e7panelwood"
  local ROOM_W   = "e7/e7panelwood"

  local NICHE_F  = "e7/e7brnmetal"
  local NICHE_W  = "e7/e7brnmetal"
--]]


  local MIN_Z = -2048
  local MAX_Z =  2048


  ---===| Entities |===---

  csg2.add_entity(ENTITY, 0, 0, 90)
  csg2.add_entity("light", -200, 128, 128)
  csg2.add_entity("light",  100, 256, 208)
  csg2.add_entity("light",  20,  640, 96)


  ---===| Starting Area |===---

  -- floor
  csg2.add_brush(
  {
    t_face = { texture=START_F },
    b_face = { texture=START_F },
    w_face = { texture=START_W },
  },
  {
    { x=-144, y=-72 },
    { x=-144, y= 64 },
    { x= 144, y= 64 },
    { x= 144, y=-72 },
  },
  MIN_Z, 64)

  -- ceiling
  csg2.add_brush(
  {
    t_face = { texture=START_F },
    b_face = { texture=START_F },
    w_face = { texture=START_W },
  },
  {
    { x=-144, y=-72 },
    { x=-144, y= 64 },
    { x= 144, y= 64 },
    { x= 144, y=-72 },
  },
  192, MAX_Z)

  -- back wall
  csg2.add_brush(
  {
    t_face = { texture=START_F },
    b_face = { texture=START_F },
    w_face = { texture=START_W },
  },
  {
    { x=-144, y=-72 },
    { x=-144, y=-64 },
    { x= 144, y=-64 },
    { x= 144, y=-72 },
  },
  MIN_Z, MAX_Z)

  -- left wall
  csg2.add_brush(
  {
    t_face = { texture=START_F },
    b_face = { texture=START_F },
    w_face = { texture=START_W },
  },
  {
    { x=-144, y=-72 },
    { x=-144, y= 64 },
    { x=-128, y= 64 },
    { x=-128, y=-72 },
  },
  MIN_Z, MAX_Z)

  -- right wall
  csg2.add_brush(
  {
    t_face = { texture=START_F },
    b_face = { texture=START_F },
    w_face = { texture=START_W },
  },
  {
    { x= 128, y=-72 },
    { x= 128, y= 64 },
    { x= 144, y= 64 },
    { x= 144, y=-72 },
  },
  MIN_Z, MAX_Z)



  ---===| Main Room |===---

  -- floor
  csg2.add_brush(
  {
    t_face = { texture=ROOM_F },
    b_face = { texture=ROOM_F },
    w_face = { texture=ROOM_W },
  },
  {
    { x=-320, y=  64 },
    { x=-320, y= 512 },
    { x= 320, y= 512 },
    { x= 320, y=  64 },
  },
  MIN_Z, 0)

  -- ceiling
  csg2.add_brush(
  {
    t_face = { texture=ROOM_F },
    b_face = { texture=ROOM_F },
    w_face = { texture=ROOM_W },
  },
  {
    { x=-320, y=  64 },
    { x=-320, y= 512 },
    { x= 320, y= 512 },
    { x= 320, y=  64 },
  },
  256, MAX_Z)

  -- south wall, left
  csg2.add_brush(
  {
    t_face = { texture=ROOM_F },
    b_face = { texture=ROOM_F },
    w_face = { texture=ROOM_W },
  },
  {
    { x=-336, y= 56 },
    { x=-336, y= 64 },
    { x=-144, y= 64 },
    { x=-144, y= 56 },
  },
  MIN_Z, MAX_Z)

  -- south wall, right
  csg2.add_brush(
  {
    t_face = { texture=ROOM_F },
    b_face = { texture=ROOM_F },
    w_face = { texture=ROOM_W },
  },
  {
    { x= 144, y= 56 },
    { x= 144, y= 64 },
    { x= 336, y= 64 },
    { x= 336, y= 56 },
  },
  MIN_Z, MAX_Z)

  -- north wall, left
  csg2.add_brush(
  {
    t_face = { texture=ROOM_F },
    b_face = { texture=ROOM_F },
    w_face = { texture=ROOM_W },
  },
  {
    { x=-336, y= 512 },
    { x=-336, y= 700 },
    { x= -80, y= 700 },
    { x= -80, y= 512 },
  },
  MIN_Z, MAX_Z)

  -- north wall, right
  csg2.add_brush(
  {
    t_face = { texture=ROOM_F },
    b_face = { texture=ROOM_F },
    w_face = { texture=ROOM_W },
  },
  {
    { x=  80, y= 512 },
    { x=  80, y= 700 },
    { x= 336, y= 700 },
    { x= 336, y= 512 },
  },
  MIN_Z, MAX_Z)

  -- west wall
  csg2.add_brush(
  {
    t_face = { texture=ROOM_F },
    b_face = { texture=ROOM_F },
    w_face = { texture=ROOM_W },
  },
  {
    { x=-300, y=  64 },
    { x=-320, y=  64 },
    { x=-320, y= 512 },
    { x=-300, y= 512 },
  },
  MIN_Z, MAX_Z)

  -- east wall
  csg2.add_brush(
  {
    t_face = { texture=ROOM_F },
    b_face = { texture=ROOM_F },
    w_face = { texture=ROOM_W },
  },
  {
    { x= 320, y=  64 },
    { x= 300, y=  64 },
    { x= 300, y= 512 },
    { x= 320, y= 512 },
  },
  MIN_Z, MAX_Z)



  ---===| Niche |===---

  -- floor
  csg2.add_brush(
  {
    t_face = { texture=NICHE_F },
    b_face = { texture=NICHE_F },
    w_face = { texture=NICHE_W },
  },
  {
    { x= -80, y=512 },
    { x= -80, y=704 },
    { x=  80, y=704 },
    { x=  80, y=512 },
  },
  MIN_Z, 64)

  -- ceiling
  csg2.add_brush(
  {
    t_face = { texture=NICHE_F },
    b_face = { texture=NICHE_F },
    w_face = { texture=NICHE_W },
  },
  {
    { x= -80, y=512 },
    { x= -80, y=704 },
    { x=  80, y=704 },
    { x=  80, y=512 },
  },
  144, MAX_Z)

  -- north wall
  csg2.add_brush(
  {
    t_face = { texture=NICHE_F },
    b_face = { texture=NICHE_F },
    w_face = { texture=NICHE_W },
  },
  {
    { x= -80, y=684 },
    { x= -80, y=704 },
    { x=  80, y=704 },
    { x=  80, y=684 },
  },
  MIN_Z, MAX_Z)

  -- west wall
  csg2.add_brush(
  {
    t_face = { texture=NICHE_F },
    b_face = { texture=NICHE_F },
    w_face = { texture=NICHE_W },
  },
  {
    { x= -80, y=512 },
    { x= -80, y=704 },
    { x= -64, y=704 },
    { x= -64, y=512 },
  },
  MIN_Z, MAX_Z)

  -- east wall
  csg2.add_brush(
  {
    t_face = { texture=NICHE_F },
    b_face = { texture=NICHE_F },
    w_face = { texture=NICHE_W },
  },
  {
    { x= 64, y=512 },
    { x= 64, y=704 },
    { x= 80, y=704 },
    { x= 80, y=512 },
  },
  MIN_Z, MAX_Z)

end
