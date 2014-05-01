----------------------------------------------------------------
--  CSG STRESS TEST
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
  local PLAYER_E  = "1"
  local MONSTER_E = "3001"
  local ITEM_E    = "2003"

  local START_F  = "FLAT22"
  local START_W  = "COMPBLUE"

  local ROOM_F   = "FLOOR7_1"
  local ROOM_W   = "BROWN1"

  local PILLAR_F = "CEIL5_2"
  local PILLAR_W = "SW1GARG"

  local NICHE_F  = "GRNLITE1"
  local NICHE_W  = "TEKGREN5"

  local STAIR_F  = "FLAT18"
  local STAIR_W  = "STEP4"

  local BEAM_F   = "FLAT23"
  local BEAM_W   = "SUPPORT2"
--]]

-- [[ QUAKE 1
  local PLAYER_E  = "info_player_start"
  local MONSTER_E = "monster_zombie"
  local ITEM_E    = "weapon_grenadelauncher"

  local START_F  = "tech01_1"
  local START_W  = "tech01_1"

  local ROOM_F  = "ground1_1"
  local ROOM_W  = "ground1_1"

  local PILLAR_F = "metal1_1"
  local PILLAR_W = "metal1_1"

  local NICHE_F  = "city1_4"
  local NICHE_W  = "city1_4"

  local STAIR_F  = "rock1_2"
  local STAIR_W  = "rock1_2"

  local BEAM_F   = "wood1_1"
  local BEAM_W   = "wood1_1"
--]]

--[[ OPEN ARENA
  local PLAYER_E  = "info_player_deathmatch"
  local MONSTER_E = "item_armor_combat"
  local ITEM_E    = "weapon_lightning"

  local START_F  = "e7/e7sbrickfloor"
  local START_W  = "e7/e7sbrickfloor"

  local ROOM_F   = "e7/e7panelwood"
  local ROOM_W   = "e7/e7panelwood"

  local PILLAR_F = "e7/e7bricks01"
  local PILLAR_W = "e7/e7bricks01"

  local NICHE_F  = "e7/e7brnmetal"
  local NICHE_W  = "e7/e7brnmetal"

  local STAIR_F  = "evil6_floors/e6c_floor"
  local STAIR_W  = "evil6_floors/e6c_floor"

  local BEAM_F   = "e7/e7beam01"
  local BEAM_W   = "e7/e7beam01"
--]]


  local MIN_Z = -2048
  local MAX_Z =  2048


  ---===| Entities |===---

  csg2.add_entity(PLAYER_E, 0, 0, 64+25)

  csg2.add_entity(MONSTER_E, -130, 400, 64+25)
  csg2.add_entity(MONSTER_E,  130, 400, 64+25)

  csg2.add_entity(ITEM_E, 0, 600, 64+25)


  ---===| Starting Area |===---

  -- floor
  csg2.add_brush(
  {
    t_face = { texture=START_F },
    b_face = { texture=START_F },
    w_face = { texture=START_W },
  },
  {
    { x=-136, y=-72 },
    { x=-136, y= 64 },
    { x=   0, y= 64 },
    { x= 136, y= 64 },
    { x= 136, y=-72 },
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
    { x=-136, y=-72 },
    { x=-136, y= 64 },
    { x= 136, y= 64 },
    { x= 136, y=-72 },
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
    { x=-144, y=-80 },
    { x=-144, y= 56 },
    { x=-128, y= 56 },
    { x=-128, y=-80 },
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
    { x= 128, y=-80 },
    { x= 128, y= 56 },
    { x= 144, y= 56 },
    { x= 144, y=-80 },
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
    { x=-384, y=-128 },
    { x=-384, y= 520 },
    { x= 384, y= 520 },
    { x= 384, y=-128 },
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
    { x=-384, y=-128 },
    { x=-384, y= 520 },
    { x= 384, y= 520 },
    { x= 384, y=-128 },
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
    { x=-128, y= 64 },
    { x=-128, y= 56 },
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
    { x= 128, y= 56 },
    { x= 128, y= 64 },
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
    { x=-320, y=  64 }, --?
    { x=-320, y= 512 },
    { x=-192, y= 512 },
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
    { x= 192, y= 512 },
    { x= 320, y= 512 },
    { x= 320, y=  64 }, --?
  },
  MIN_Z, MAX_Z)



  ---===| Pillar Pair |===---

  csg2.add_brush(
  {
    t_face = { texture=PILLAR_F },
    b_face = { texture=PILLAR_F },
    w_face = { texture=PILLAR_W },
  },
  {
    { x=-192, y=192 },
    { x=-192, y=256 },
    { x=-128, y=256 },
    { x=-128, y=192 },
  },
  MIN_Z, MAX_Z)

  csg2.add_brush(
  {
    t_face = { texture=PILLAR_F },
    b_face = { texture=PILLAR_F },
    w_face = { texture=PILLAR_W },
  },
  {
    { x=128, y=192 },
    { x=128, y=256 },
    { x=192, y=256 },
    { x=192, y=192 },
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
    { x= -80, y=700 },
    { x=  80, y=700 },
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
    { x= -80, y=700 },
    { x=  80, y=700 },
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
    { x= -80, y=664 },
    { x= -80, y=680 },
    { x=  80, y=680 },
    { x=  80, y=664 },
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
    { x= -80, y=720 },
    { x= -64, y=720 },
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
    { x= 64, y=720 },
    { x= 80, y=720 },
    { x= 80, y=512 },
  },
  MIN_Z, MAX_Z)



  ---===| Support Beams |===---

  csg2.add_brush(
  {
    t_face = { texture=BEAM_F },
    b_face = { texture=BEAM_F },
    w_face = { texture=BEAM_W },
  },
  {
    { x=-148, y= 44 },
    { x=-148, y= 68 },
    { x=-124, y= 68 },
    { x=-124, y= 44 },
  },
  MIN_Z, MAX_Z)

  csg2.add_brush(
  {
    t_face = { texture=BEAM_F },
    b_face = { texture=BEAM_F },
    w_face = { texture=BEAM_W },
  },
  {
    { x= 124, y= 44 },
    { x= 124, y= 68 },
    { x= 148, y= 68 },
    { x= 148, y= 44 },
  },
  MIN_Z, MAX_Z)

  csg2.add_brush(
  {
    t_face = { texture=BEAM_F },
    b_face = { texture=BEAM_F },
    w_face = { texture=BEAM_W },
  },
  {
    { x=-88, y=512 },
    { x=-64, y=536 },
    { x=-64, y=512 },
  },
  MIN_Z, MAX_Z)

  csg2.add_brush(
  {
    t_face = { texture=BEAM_F },
    b_face = { texture=BEAM_F },
    w_face = { texture=BEAM_W },
  },
  {
    { x= 64, y=512 },
    { x= 64, y=536 },
    { x= 88, y=512 },
  },
  MIN_Z, MAX_Z)



  ---===| Stairs |===---

  -- largest and lowest
  csg2.add_brush(
  {
    t_face = { texture=STAIR_F },
    b_face = { texture=STAIR_F },
    w_face = { texture=STAIR_W },
  },
  {
    { x=-240, y=584 },
    { x= 240, y=584 },
    { x=   0, y=224 },
  },
  MIN_Z, 16)

  -- middle
  csg2.add_brush(
  {
    t_face = { texture=STAIR_F },
    b_face = { texture=STAIR_F },
    w_face = { texture=STAIR_W },
  },
  {
    { x=-176, y=584 },
    { x= 176, y=584 },
    { x=   0, y=320 },
  },
  MIN_Z, 32)

  -- smallest and highest
  csg2.add_brush(
  {
    t_face = { texture=STAIR_F },
    b_face = { texture=STAIR_F },
    w_face = { texture=STAIR_W },
  },
  {
    { x=-112, y=584 },
    { x= 112, y=584 },
    { x=   0, y=416 },
  },
  MIN_Z, 48)

end
