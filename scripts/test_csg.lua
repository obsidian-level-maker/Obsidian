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

-- [[ DOOM
  local ENTITY   = "1"

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

--[[ QUAKE 1
  local ENTITY   = "info_player_start"

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
  local ENTITY   = "info_player_deathmatch"

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

  -- TODO  csg2.z_range(MIN_Z, MAX_Z)


  ---===| Entities |===---

  csg2.add_entity(ENTITY, 0, 0, 65)


  ---===| Starting Area |===---

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
  { z1=MIN_Z, z2=64 })

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
  { z1=192, z2=MAX_Z })

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
  { z1=MIN_Z, z2=MAX_Z })

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
  { z1=MIN_Z, z2=MAX_Z })

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
  { z1=MIN_Z, z2=MAX_Z })



  ---===| Main Room |===---

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
  { z1=MIN_Z, z2=0 })

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
  { z1=256, z2=MAX_Z })

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
  { z1=MIN_Z, z2=MAX_Z })

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
  { z1=MIN_Z, z2=MAX_Z })

  -- north wall, left
  csg2.add_solid(
  {
    t_tex=ROOM_F, b_tex=ROOM_F, w_tex=ROOM_W,
  },
  {
    { x=-336, y= 512 },
    { x=-336, y= 700 },
    { x= -80, y= 700 },
    { x= -80, y= 512 },
  },
  { z1=MIN_Z, z2=MAX_Z })

  -- north wall, right
  csg2.add_solid(
  {
    t_tex=ROOM_F, b_tex=ROOM_F, w_tex=ROOM_W,
  },
  {
    { x=  80, y= 512 },
    { x=  80, y= 700 },
    { x= 336, y= 700 },
    { x= 336, y= 512 },
  },
  { z1=MIN_Z, z2=MAX_Z })

  -- west wall
  csg2.add_solid(
  {
    t_tex=ROOM_F, b_tex=ROOM_F, w_tex=ROOM_W,
  },
  {
    { x=-320, y=  64-4 }, --!!!!
    { x=-320, y= 512 },
    { x=-192, y= 512 },
  },
  { z1=MIN_Z, z2=MAX_Z })

  -- east wall
  csg2.add_solid(
  {
    t_tex=ROOM_F, b_tex=ROOM_F, w_tex=ROOM_W,
  },
  {
    { x= 192, y= 512 },
    { x= 320, y= 512 },
    { x= 320, y=  64-4 }, --!!!!
  },
  { z1=MIN_Z, z2=MAX_Z })



  ---===| Pillar Pair |===---

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
  { z1=MIN_Z, z2=MAX_Z })

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
  { z1=MIN_Z, z2=MAX_Z })



  ---===| Niche |===---

  -- floor
  csg2.add_solid(
  {
    t_tex=NICHE_F, b_tex=NICHE_F, w_tex=NICHE_W,
  },
  {
    { x= -80, y=512 },
    { x= -80, y=700 },
    { x=  80, y=700 },
    { x=  80, y=512 },
  },
  { z1=MIN_Z, z2=64 })

  -- ceiling
  csg2.add_solid(
  {
    t_tex=NICHE_F, b_tex=NICHE_F, w_tex=NICHE_W,
  },
  {
    { x= -80, y=512 },
    { x= -80, y=700 },
    { x=  80, y=700 },
    { x=  80, y=512 },
  },
  { z1=144, z2=MAX_Z })

  -- north wall
  csg2.add_solid(
  {
    t_tex=NICHE_F, b_tex=NICHE_F, w_tex=NICHE_W,
  },
  {
    { x= -80, y=664 },
    { x= -80, y=680 },
    { x=  80, y=680 },
    { x=  80, y=664 },
  },
  { z1=MIN_Z, z2=MAX_Z })

  -- west wall
  csg2.add_solid(
  {
    t_tex=NICHE_F, b_tex=NICHE_F, w_tex=NICHE_W,
  },
  {
    { x= -80, y=512 },
    { x= -80, y=720 },
    { x= -64, y=720 },
    { x= -64, y=512 },
  },
  { z1=MIN_Z, z2=MAX_Z })

  -- east wall
  csg2.add_solid(
  {
    t_tex=NICHE_F, b_tex=NICHE_F, w_tex=NICHE_W,
  },
  {
    { x= 64, y=512 },
    { x= 64, y=720 },
    { x= 80, y=720 },
    { x= 80, y=512 },
  },
  { z1=MIN_Z, z2=MAX_Z })



  ---===| Support Beams |===---

  csg2.add_solid(
  {
    t_tex=BEAM_F, b_tex=BEAM_F, w_tex=BEAM_W,
  },
  {
    { x=-148, y= 44 },
    { x=-148, y= 68 },
    { x=-124, y= 68 },
    { x=-124, y= 44 },
  },
  { z1=MIN_Z, z2=MAX_Z })

  csg2.add_solid(
  {
    t_tex=BEAM_F, b_tex=BEAM_F, w_tex=BEAM_W,
  },
  {
    { x= 124, y= 44 },
    { x= 124, y= 68 },
    { x= 148, y= 68 },
    { x= 148, y= 44 },
  },
  { z1=MIN_Z, z2=MAX_Z })

  csg2.add_solid(
  {
    t_tex=BEAM_F, b_tex=BEAM_F, w_tex=BEAM_W,
  },
  {
    { x=-88, y=512 },
    { x=-64, y=536 },
    { x=-64, y=512 },
  },
  { z1=MIN_Z, z2=MAX_Z })

  csg2.add_solid(
  {
    t_tex=BEAM_F, b_tex=BEAM_F, w_tex=BEAM_W,
  },
  {
    { x= 64, y=512 },
    { x= 64, y=536 },
    { x= 88, y=512 },
  },
  { z1=MIN_Z, z2=MAX_Z })



  ---===| Stairs |===---

  -- largest and lowest
  csg2.add_solid(
  {
    t_tex=STAIR_F, b_tex=STAIR_F, w_tex=STAIR_W,
  },
  {
    { x=-240, y=584 },
    { x= 240, y=584 },
    { x=   0, y=224 },
  },
  { z1=MIN_Z, z2=16 })

  -- middle
  csg2.add_solid(
  {
    t_tex=STAIR_F, b_tex=STAIR_F, w_tex=STAIR_W,
  },
  {
    { x=-176, y=584 },
    { x= 176, y=584 },
    { x=   0, y=320 },
  },
  { z1=MIN_Z, z2=32 })

  -- smallest and highest
  csg2.add_solid(
  {
    t_tex=STAIR_F, b_tex=STAIR_F, w_tex=STAIR_W,
  },
  {
    { x=-112, y=584 },
    { x= 112, y=584 },
    { x=   0, y=416 },
  },
  { z1=MIN_Z, z2=48 })


end
