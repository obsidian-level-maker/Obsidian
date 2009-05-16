----------------------------------------------------------------
--  BOSS ARENAS
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2009 Andrew Apted
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

require 'defs'
require 'util'


function Arena_add_players(x, y, z, angle)
  local dist = 40

  Trans_entity("player1", x, y, z, { angle=angle })

  if GAME.things["player2"] then
    Trans_entity("player2", x - dist, y, z, { angle=angle })
    Trans_entity("player3", x + dist, y, z, { angle=angle })
    Trans_entity("player4", x - dist, y + dist, z, { angle=angle })
  end
end


function Arena_Doom_MAP30()

  local face_x = 1024 + 128
  local face_y = 4096

  local room_y  = face_y - 1600
  local room_x1 = face_x - 768
  local room_x2 = face_x + 768

  local ledge_y = room_y + 600

  local function make_face()

    local FACE_TEX =
    {
      { "ZZZFACE9", "ZZZFACE5", "ZZZFACE7" },
      { "ZZZFACE8", "ZZZFACE4", "ZZZFACE6" },
      { "ZZZFACE1", "ZZZFACE3", "ZZZFACE2" },
      { "ZZZFACE9", "ZZZFACE9", "ZZZFACE9" },
    }

    for fx = 1,3 do for fy = 1,4 do

      local x1 = face_x - 384 + (fx-1) * 256
      local x2 = x1 + 256

      local y1 = face_y - sel(fy==4, 12, (3-fy)*4)
      local y2 = y1 + 32

      local z1 = sel(fy <= 3, -EXTREME_H, 3*128)
      local z2 = fy * 128

      local info = get_mat("CEIL5_1")
      info.b_face.light = 0.75
      info.w_face.texture = FACE_TEX[fy][fx]

      if (fx == 2 and fy == 3) then
        Trans_quad(info, x1,y1, face_x-32,y2, z1,z2)
        Trans_quad(info, face_x+32,y1, x2,y2, z1,z2)
        Trans_quad(info, face_x-32,y1, face_x+32,y2, 256+32,z2)
      else
        Trans_quad(info, x1,y1, x2,y2, z1, z2)
      end
    end end -- for fx, fy
  end

  local function make_hole()
    local x1 = face_x - 30
    local x2 = face_x + 30

    local y1 = face_y + 2
    local y2 = y1 + 128

    local z1 = 256 + 1
    local z2 = 256 + 31

    local info = add_pegging(get_mat("BFALL1"))
    info.b_face.light = 0.99

    Trans_quad(info, x1-32,y1, x1,y2, z1-32, z2+32)
    Trans_quad(info, x2,y1, x2+32,y2, z1-32, z2+32)

    Trans_quad(info, x1,y1, x2,y2, z1-32, z1)
    Trans_quad(info, x1,y1, x2,y2, z2, z2+32)

    Trans_entity("brain_shooter", face_x, y1+24, z1, { angle=270 })

    z1 = z1 - 96

    y1 = y2
    y2 = y1 + 128

    Trans_quad(info, x1-32,y1, x1,y2, z1-32, z2+32)
    Trans_quad(info, x2,y1, x2+32,y2, z1-32, z2+32)

    Trans_quad(info, x1,y2, x2,y2+32, z1-32, z2+32)

    Trans_quad(info, x1,y1, x2,y2, z1-32, z1)
    Trans_quad(info, x1,y1, x2,y2, z2, z2+32)

    Trans_entity("brain_boss", face_x, y2-48, z1, { angle=270 })

  end

  local function make_room()
    local x1 = room_x1
    local x2 = room_x2

    local y1 = room_y
    local y2 = face_y

    local z1 = 0
    local z2 = 512-96

    local info = get_mat("SP_HOT1", "RROCK05")

    Trans_quad(info, x1-32,y1, x1,y2, -EXTREME_H, EXTREME_H)
    Trans_quad(info, x2,y1, x2+32,y2, -EXTREME_H, EXTREME_H)
    Trans_quad(info, x1,y1-32, x2,y1, -EXTREME_H, EXTREME_H)

    Trans_quad(info, x1,y2-24, face_x-384,y2+32, -EXTREME_H, EXTREME_H)

    Trans_quad(info, face_x+384,y2-24, x2,y2+32, -EXTREME_H, EXTREME_H)

    Trans_quad(info, x1,y1, x2,y2, -EXTREME_H, z1)
    Trans_quad(info, x1,y1, x2,y2, z2, EXTREME_H)

    Trans_quad(info, x1,y1, x2,ledge_y, -EXTREME_H, 128)

    for i=-1,1 do
      local hx = face_x + i * 192
      local hy = face_y - 96
      local item = "mega" -- sel(i == 0, "soul", "mega")

      Trans_entity(item, hx, hy, 0)

      --[[
      hx = face_x + i * 128
      hy = face_y - 240
      item = sel(i == 0, "plasma", "cell_pack")

      Trans_entity(item, hx, hy, 0)
      --]]

      if i ~= 0 then
        local tx = face_x + i * 240
        local ty = room_y + 250

        Trans_entity("brain_target", tx, ty, 0)

        tx = face_x + i * 400
        ty = ledge_y + 400

        Trans_entity("brain_target", tx, ty, 0)

        hx = face_x + i * 128
        hy = room_y + 64

        Trans_entity("medikit", hx, hy, 0)
      end
    end
  end

  local function make_cybers()
    for i = 1,4 do
      local x1 = sel((i % 2) == 1, room_x1, room_x2-352)
      local x2 = sel((i % 2) == 1, room_x1+352, room_x2)

      local y1 = sel(i <= 2, face_y-200, room_y)
      local y2 = sel(i <= 2, face_y, room_y+200)
      local y3 = sel(i <= 2, y1 - 64, y2 + 64)

      local z = sel(i <= 2, 0, 128)

      local mx = sel((i % 2) == 1, x1+96, x2-96)
      local my = (y1 + y2) / 2

      local angle = sel((i % 2) == 1, 180, 0)

      local info = get_mat("FLOOR4_8")
      local step = add_pegging(get_mat("FLOOR5_2"))

      Trans_quad(info, x1,y1, x2,y2, -EXTREME_H, z + 32)

      Trans_quad(step, x1,y3-32, x2,y3+32, -EXTREME_H, z + 16)

      Trans_entity("Cyberdemon", mx, my, z, { angle=angle })

      if i <= 2 then
        Trans_entity("launch", mx, my, z, { angle=angle })
      end

      for side = 1,9 do if side ~= 5 then
        local dist = sel((side % 2) == 0, 1.4, 1) * 36
        local rx, ry = nudge_coord(mx, my, side, dist)
        Trans_entity("rockets", rx, ry, z, { angle=angle })
      end end -- for side
    end
  end

  local function make_lifts()
    for i = 1,2 do
      local x1 = sel(i == 1, room_x1+64,     room_x2-64-128)
      local x2 = sel(i == 1, room_x1+64+128, room_x2-64)

      local y1 = ledge_y + 32
      local y2 = y1 + 128

      local z = 128

      local lift = add_pegging(get_mat("SKSPINE1"))
      lift.sec_tag = 1

      Trans_brush(lift,
      {
        { x=x2, y=y1, line_kind=62, line_tag=1 },
        { x=x2, y=y2, line_kind=62, line_tag=1 },
        { x=x1, y=y2, line_kind=62, line_tag=1 },
        { x=x1, y=y1, line_kind=62, line_tag=1 },
      },
      -EXTREME_H, z)
    end
  end

  local function make_platform()
    local x1 = face_x-32
    local x2 = face_x+32

    local info = add_pegging(get_mat("WOOD1"))

    Trans_quad(info, x1, ledge_y-108, x2, ledge_y+360,
        -EXTREME_H, 240)


    local y1 = ledge_y - 200
    local y2 = y1 + 64

    local lift = add_pegging(get_mat("WOODMET2", "FLAT5_2"))
    lift.sec_tag = 2

    Trans_brush(lift,
    {
      { x=x2, y=y1, line_kind=123, line_tag=2 },
      { x=x2, y=y2, line_kind=123, line_tag=2 },
      { x=x1, y=y2, line_kind=123, line_tag=2 },
      { x=x1, y=y1, line_kind=123, line_tag=2 },
    },
    -EXTREME_H, 240)


    local tx = face_x
    local ty = ledge_y + 160

    Trans_entity("brain_target", tx, ty, 0)
  end


  ---| Arena_Doom_MAP30 |---

  make_face()
  make_hole()
  make_room()

  make_cybers()
  make_lifts()
  make_platform()

  Arena_add_players(face_x, face_y - 512, 0, 90)
end


function Arena_Doom_MAP07()
  
  local function make_room(x1,y1, x2,y2, z)
    local wall = get_mat("ROCK4", "MFLR8_3")
    local sky  = get_sky()

    Trans_quad(wall, x1-64,y1, x1,y2, -EXTREME_H, EXTREME_H)
    Trans_quad(wall, x2,y1, x2+64,y2, -EXTREME_H, EXTREME_H)

    Trans_quad(wall, x1,y1-64, x2,y1, -EXTREME_H, EXTREME_H)
    Trans_quad(wall, x1,y2, x2,y2+64, -EXTREME_H, EXTREME_H)

    Trans_quad(wall, x1,y1, x2,y2, -EXTREME_H, 0)
    Trans_quad(sky,  x1,y1, x2,y2, z, EXTREME_H)

    -- lower skies at edges
    local z2 = 256

    Trans_quad(sky, x1,y1, x1+16,y2, z2, EXTREME_H)
    Trans_quad(sky, x2-16,y1, x2,y2, z2, EXTREME_H)

    Trans_quad(sky, x1,y1, x2,y1+16, z2, EXTREME_H)
    Trans_quad(sky, x1,y2-16, x2,y2, z2, EXTREME_H)

    -- ITEMS --

    Trans_entity("medikit", x1+96, y1+96, 0)
    Trans_entity("medikit", x2-96, y1+96, 0)
    Trans_entity("medikit", x1+96, y2-96, 0)
    Trans_entity("medikit", x2-96, y2-96, 0)

    local step = add_pegging(get_mat("FLOOR5_2"))

    Trans_quad(step, 256*4,256*4, 256*6,256*6, -16, 16)

    -- lower right corner
    local ITEM_MAP =
    {
      { "soul",         "mercury_lamp", "cell_pack" },
      { "mercury_lamp", "cell_pack",    "barrel"    },
      { "cell_pack",    "barrel",       "plasma"    },
    }

    for ix = -2,2 do for iy = -2,2 do
      local mx = 256*5 + ix * 160
      local my = 256*5 + iy * 160
      local item = ITEM_MAP[1 + math.abs(iy)][1 + math.abs(ix)]

      Trans_entity(item, mx, my, 0)
    end end -- for ix, iy
  end

  local function make_beam(x1,y1, x2,y2, z)
    Trans_quad(get_mat("FLOOR4_8"), x1,y1, x2,y2, z, EXTREME_H)
  end

  local function make_pillar(x, y, w, z, entity)
    Trans_quad(add_pegging(get_mat("METAL6")),
        x-w,y-w, x+w,y+w, -EXTREME_H, z)

    if entity then
      Trans_entity(entity, x, y, z, { angle=rand_irange(0,3)*90 })
    end 
  end

  local function make_exit_switch(mx, my)
    local info = get_mat("SW1SKIN")
    add_pegging(info, 0, 48)

    Trans_brush(info,
    {
      { x=mx+32, y=my-32, line_kind=11 },
      { x=mx+32, y=my+32, line_kind=11 },
      { x=mx-32, y=my+32, line_kind=11 },
      { x=mx-32, y=my-32, line_kind=11 },
    },
    -EXTREME_H, 8+72)

    local step = add_pegging(get_mat("FLOOR5_2"))

    local x1 = mx-160
    local x2 = mx+160

    local y1 = my-96
    local y2 = my+96

    Trans_quad(step, x1,y1, x2,y2, -16, 8)


    local wall = get_mat("ROCK2")
    wall.w_face.peg = true
    wall.sec_tag = 666

    local wall_h = 36

    Trans_quad(wall, x1-16,y1-16, x1,y2+16, -EXTREME_H, wall_h)
    Trans_quad(wall, x2,y1-16, x2+16,y2+16, -EXTREME_H, wall_h)

    Trans_quad(wall, x1,y1-16, x2,y1, -EXTREME_H, wall_h)
    Trans_quad(wall, x1,y2, x2,y2+16, -EXTREME_H, wall_h)
  end


  ---| Arena_Doom_MAP07 |---

  local sky_h = 512
  local manc_h = 64

  make_room(0,0, 2560,2560, sky_h)

  make_exit_switch(256*5, 2560-256)

  make_beam(256*0.5,256*2.0, 256*9.5,256*3.0, sky_h-128)
  make_beam(256*0.5,256*7.0, 256*9.5,256*8.0, sky_h-128)
  make_beam(256*2.0,256*0.5, 256*3.0,256*9.5, sky_h-128)
  make_beam(256*7.0,256*0.5, 256*8.0,256*9.5, sky_h-128)

  make_pillar(256*2.5, 256*2.5, 96, sky_h)
  make_pillar(256*7.5, 256*2.5, 96, sky_h)
  make_pillar(256*2.5, 256*7.5, 96, sky_h)
  make_pillar(256*7.5, 256*7.5, 96, sky_h)

  make_pillar(256*4.0, 256*2.5, 64, manc_h, "mancubus")
  make_pillar(256*5.0, 256*2.5, 64, manc_h, "mancubus")
  make_pillar(256*6.0, 256*2.5, 64, manc_h, "mancubus")

  make_pillar(256*4.0, 256*7.5, 64, manc_h, "mancubus")
  make_pillar(256*5.0, 256*7.5, 64, manc_h, "mancubus")
  make_pillar(256*6.0, 256*7.5, 64, manc_h, "mancubus")

  make_pillar(256*2.5, 256*4.0, 64, manc_h, "mancubus")
  make_pillar(256*2.5, 256*5.0, 64, manc_h, "mancubus")
  make_pillar(256*2.5, 256*6.0, 64, manc_h, "mancubus")

  make_pillar(256*7.5, 256*4.0, 64, manc_h, "mancubus")
  make_pillar(256*7.5, 256*5.0, 64, manc_h, "mancubus")
  make_pillar(256*7.5, 256*6.0, 64, manc_h, "mancubus")

  Arena_add_players(1200, 100, 0, 90)
end


function Arena_Doom_E2M8()
  -- this arena was designed by Chris Pisarcyk

  local total_w = 3088
  local total_h = 2768

  local mid_w = total_w / 2
  local mid_h = total_h / 2

  local mid_x = 0
  local mid_y = mid_h

  local sky_i = get_sky()


  local function make_room()
    local floor_i = get_mat("FLOOR7_1")
    local wall_i  = get_mat("BROWNHUG")

    local x1, y1 = -mid_w, 0
    local x2, y2 =  mid_w, total_h
    local z1 = -18
    
    Trans_quad(floor_i, x1, y1, x2, y2, -EXTREME_H, z1)
    Trans_quad(sky_i,   x1, y1, x2, y2, z1+768, EXTREME_H)

    Trans_quad(wall_i, x1-32, y1-32, x1, y2+32, -EXTREME_H, EXTREME_H)
    Trans_quad(wall_i, x2, y1-32, x2+32, y2+32, -EXTREME_H, EXTREME_H)
    Trans_quad(wall_i, x1, y1-32, x2, y1, -EXTREME_H, EXTREME_H)
    Trans_quad(wall_i, x1, y2, x2, y2+32, -EXTREME_H, EXTREME_H)

    Trans_quad(sky_i, x1, y1, x1+32, y2, z1+320, EXTREME_H)
    Trans_quad(sky_i, x2-32, y1, x2, y2, z1+320, EXTREME_H)
    Trans_quad(sky_i, x1+32, y1, x2-32, y1+32, z1+320, EXTREME_H)
    Trans_quad(sky_i, x1+32, y2-32, x2-32, y2, z1+320, EXTREME_H)
  end

  local function make_buns()
    local floor_i = get_mat("FLOOR7_2")
    local wall_i  = get_mat("GSTONE1")
    local outer_i = get_mat("BROVINE2")
    local brown_i = get_mat("BROWNGRN")
    local supp_i  = add_pegging(get_mat("SUPPORT3"))

    local gun, ammo

    if rand_sel(50) then
      gun = "chain"  ; ammo = "bullet_box"
    else
      gun = "shotty" ; ammo = "shell_box"
    end

    for i = 1,2 do
      TRANSFORM.mirror_y = sel(i==1, mid_y, nil)
      
      -- curved niche --

      Trans_quad(floor_i, mid_x-160, mid_y+144, mid_x+160, mid_y+288, -EXTREME_H, 16)
      Trans_quad(floor_i, mid_x-160, mid_y+144, mid_x+160, mid_y+288, 232, EXTREME_H)

      Trans_brush(wall_i,
      {
        { x=mid_x-160, y=mid_y+144 },
        { x=mid_x- 80, y=mid_y+216 },
        { x=mid_x- 80, y=mid_y+368 },
        { x=mid_x-160, y=mid_y+368 },
      },
      -EXTREME_H, EXTREME_H)

      Trans_brush(wall_i,
      {
        { x=mid_x-80, y=mid_y+216 },
        { x=mid_x   , y=mid_y+248 },
        { x=mid_x   , y=mid_y+368 },
        { x=mid_x-80, y=mid_y+368 },
      },
      -EXTREME_H, EXTREME_H)

      Trans_brush(wall_i,
      {
        { x=mid_x+80, y=mid_y+368 },
        { x=mid_x   , y=mid_y+368 },
        { x=mid_x   , y=mid_y+248 },
        { x=mid_x+80, y=mid_y+216 },
      },
      -EXTREME_H, EXTREME_H)

      Trans_brush(wall_i,
      {
        { x=mid_x+160, y=mid_y+368 },
        { x=mid_x+ 80, y=mid_y+368 },
        { x=mid_x+ 80, y=mid_y+216 },
        { x=mid_x+160, y=mid_y+144 },
      },
      -EXTREME_H, EXTREME_H)

      Trans_entity(gun, mid_x, mid_y+224, 16)

      Trans_entity(ammo, mid_x-96, mid_y+184, 16)
      Trans_entity(ammo, mid_x-48, mid_y+184, 16)
      Trans_entity(ammo, mid_x   , mid_y+184, 16)
      Trans_entity(ammo, mid_x+48, mid_y+184, 16)
      Trans_entity(ammo, mid_x+96, mid_y+184, 16)

      -- outer walls --

      Trans_brush(outer_i,
      {
        { x=mid_x+600, y=mid_y+368 },
        { x=mid_x+560, y=mid_y+440 },
        { x=mid_x+450, y=mid_y+508 },
        { x=mid_x+320, y=mid_y+556 },
        { x=mid_x+108, y=mid_y+584 },

        { x=mid_x-108, y=mid_y+584 },
        { x=mid_x-320, y=mid_y+556 },
        { x=mid_x-450, y=mid_y+508 },
        { x=mid_x-560, y=mid_y+440 },
        { x=mid_x-600, y=mid_y+368 },
      },
      -EXTREME_H, EXTREME_H)
    end
  end

  local function make_meat()
    local floor_i = get_mat("MARBLE2", "FLOOR7_2")
    local wall_i  = get_mat("GSTONE1")
    local outer_i = get_mat("BROVINE2")
    local brown_i = get_mat("BROWNGRN", "FLOOR7_1")
    local supp_i  = add_pegging(get_mat("SUPPORT3"))
    local door_i  = add_pegging(get_mat("MARBFACE"))
    local track_i = add_pegging(get_mat("DOORSTOP"))

    door_i.delta_z = -8

    for i = 1,2 do
      TRANSFORM.mirror_x = sel(i==1, mid_x, nil)

      -- floor and ceiling --

      Trans_quad(floor_i, mid_x-440, mid_y-144, mid_x, mid_y+144, -EXTREME_H, 0)

      Trans_quad(brown_i, mid_x-416, mid_y-144, mid_x-224, mid_y+144, 192, EXTREME_H)

      Trans_entity("launch", mid_x-320, mid_y, 0)

      -- walls --

      for j = 1,2 do
        TRANSFORM.mirror_y = sel(j==1, mid_y, nil)

        Trans_quad(outer_i, mid_x-600, mid_y+144, mid_x-440, mid_y+368, -EXTREME_H, EXTREME_H)

        Trans_quad(brown_i, mid_x-416, mid_y+144, mid_x-224, mid_y+160, -EXTREME_H, EXTREME_H)
      end

      -- doorways --

      Trans_brush(outer_i,
      {
        { x=mid_x-416, y=mid_y-64, w_face=brown_i.w_face },
        { x=mid_x-416, y=mid_y+64 },
        { x=mid_x-440, y=mid_y+64 },
        { x=mid_x-440, y=mid_y-64 },
      },
      128, EXTREME_H)

      Trans_brush(brown_i,
      {
        { x=mid_x-160, y=mid_y-64, w_face=wall_i.w_face },
        { x=mid_x-160, y=mid_y+64 },
        { x=mid_x-224, y=mid_y+64 },
        { x=mid_x-224, y=mid_y-64 },
      },
      128, EXTREME_H)

      Trans_brush(door_i,
      {
        { x=mid_x-184, y=mid_y-64, line_kind=1 },
        { x=mid_x-184, y=mid_y+64, line_kind=1 },
        { x=mid_x-200, y=mid_y+64, line_kind=1 },
        { x=mid_x-200, y=mid_y-64, line_kind=1 },
      },
      0+8, EXTREME_H)

      for j = 1,2 do
        TRANSFORM.mirror_y = sel(j==1, mid_y, nil)

        Trans_brush(brown_i,
        {
          { x=mid_x-440, y=mid_y+160, w_face=outer_i.w_face },
          { x=mid_x-440, y=mid_y+64,  w_face=supp_i.w_face  },
          { x=mid_x-416, y=mid_y+64  },
          { x=mid_x-416, y=mid_y+160 },
        },
        -EXTREME_H, EXTREME_H)

        Trans_brush(wall_i,
        {
          { x=mid_x-224, y=mid_y+160, w_face=brown_i.w_face },
          { x=mid_x-224, y=mid_y+64,  w_face=brown_i.w_face },
          { x=mid_x-200, y=mid_y+64,  w_face=track_i.w_face },
          { x=mid_x-184, y=mid_y+64  },
          { x=mid_x-160, y=mid_y+64  },
          { x=mid_x-160, y=mid_y+160 },
        },
        -EXTREME_H, EXTREME_H)
      
        -- rockets --

        Trans_entity("rocket_box", mid_x-384, mid_y+128, 0)
        Trans_entity("rocket_box", mid_x-352, mid_y+112, 0)
        Trans_entity("rocket_box", mid_x-320, mid_y+100, 0)
        Trans_entity("rocket_box", mid_x-288, mid_y+112, 0)
        Trans_entity("rocket_box", mid_x-256, mid_y+128, 0)
      end
    end

    -- central ceiling --

    local beam_i = get_mat("METAL")

    Trans_quad(sky_i, mid_x-160, mid_y-144, mid_x+160, mid_y+144, 384, EXTREME_H)

    Trans_brush(beam_i,
    {
      { x=mid_x-160, y=mid_y-144 },
      { x=mid_x+160, y=mid_y+128 },
      { x=mid_x+160, y=mid_y+144 },
      { x=mid_x-160, y=mid_y-128 },
    },
    320, EXTREME_H)

    Trans_brush(beam_i,
    {
      { x=mid_x-160, y=mid_y+128 },
      { x=mid_x+160, y=mid_y-144 },
      { x=mid_x+160, y=mid_y-128 },
      { x=mid_x-160, y=mid_y+144 },
    },
    320, EXTREME_H)
  end

  local function add_players()
    for i = 1,4 do
      local x = mid_x + sel(i >= 3,   120, -120)
      local y = mid_y + sel((i%2)==1, 104, -104)

      local angle = sel(i >= 3, 180, 0)

      Trans_entity("player" .. tostring(i), x, y, 0, { angle=angle })
      Trans_entity("backpack", x, y, 0)
    end

    Trans_entity("soul", mid_x, mid_y, 0)
  end

  local function add_cybies()
    local y = 300

    if rand_odds(50) then y = total_h - y end

    Trans_entity("Cyberdemon", 0, y, 0)
  end

  
  ---| Arena_Doom_E2M8 |---

  make_room()
  make_buns()
  make_meat()

  add_players()
  add_cybies()
end  


