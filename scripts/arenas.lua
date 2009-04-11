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

  gui.add_entity(tostring(GAME.things["player1"].id),
                 x, y, z, { angle=angle })

  if GAME.things["player2"] then
    gui.add_entity(tostring(GAME.things["player2"].id),
                   x - dist, y, z, { angle=angle })

    gui.add_entity(tostring(GAME.things["player3"].id),
                   x + dist, y, z, { angle=angle })

    gui.add_entity(tostring(GAME.things["player4"].id),
                   x - dist, y + dist, z, { angle=angle })
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

      local info =
      {
        t_face = { texture="CEIL5_1" },
        b_face = { texture="CEIL5_1", light=0.75 },
        w_face = { texture=FACE_TEX[fy][fx] },  --!! x_offset=0, y_offset=0, peg=true }
      }

      if (fx == 2 and fy == 3) then
        transformed_brush(nil, info, rect_coords(x1,y1, face_x-32,y2), z1,z2)
        
        -- info.w_face.x_offset=(face_x+32-x1)
        transformed_brush(nil, info, rect_coords(face_x+32,y1, x2,y2), z1,z2)

        -- info.w_face.x_offset=(face_x-32-x1)
        -- info.w_face.y_offset=32
        transformed_brush(nil, info, rect_coords(face_x-32,y1, face_x+32,y2), 256+32,z2)
      else
        transformed_brush(nil, info, rect_coords(x1,y1, x2,y2), z1, z2)
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

    local info =
    {
      t_face = { texture="BLOOD1" },
      b_face = { texture="BLOOD1", light=0.99 },
      w_face = { texture="BFALL1", x_offset=0, y_offset=0, peg=true },
    }

    transformed_brush(nil, info, rect_coords(x1-32,y1, x1,y2), z1-32, z2+32)
    transformed_brush(nil, info, rect_coords(x2,y1, x2+32,y2), z1-32, z2+32)

    transformed_brush(nil, info, rect_coords(x1,y1, x2,y2), z1-32, z1)
    transformed_brush(nil, info, rect_coords(x1,y1, x2,y2), z2, z2+32)

    gui.add_entity(tostring(GAME.things["brain_shooter"].id),
                   face_x, y1+24, z1, { angle=270 })

    z1 = z1 - 96

    y1 = y2
    y2 = y1 + 128

    transformed_brush(nil, info, rect_coords(x1-32,y1, x1,y2), z1-32, z2+32)
    transformed_brush(nil, info, rect_coords(x2,y1, x2+32,y2), z1-32, z2+32)

    transformed_brush(nil, info, rect_coords(x1,y2, x2,y2+32), z1-32, z2+32)

    transformed_brush(nil, info, rect_coords(x1,y1, x2,y2), z1-32, z1)
    transformed_brush(nil, info, rect_coords(x1,y1, x2,y2), z2, z2+32)

    gui.add_entity(tostring(GAME.things["brain_boss"].id),
                   face_x, y2-48, z1, { angle=270 })

  end

  local function make_room()
    local x1 = room_x1
    local x2 = room_x2

    local y1 = room_y
    local y2 = face_y

    local z1 = 0
    local z2 = 512-96

    local info =
    {
      t_face = { texture="RROCK08" },
      b_face = { texture="RROCK08" },
      w_face = { texture="SP_HOT1" },
    }

    transformed_brush(nil, info, rect_coords(x1-32,y1, x1,y2),
                      -EXTREME_H, EXTREME_H)

    transformed_brush(nil, info, rect_coords(x2,y1, x2+32,y2),
                      -EXTREME_H, EXTREME_H)

    transformed_brush(nil, info, rect_coords(x1,y1-32, x2,y1),
                      -EXTREME_H, EXTREME_H)

    transformed_brush(nil, info, rect_coords(x1,y2-24, face_x-384,y2+32),
                      -EXTREME_H, EXTREME_H)

    transformed_brush(nil, info, rect_coords(face_x+384,y2-24, x2,y2+32),
                      -EXTREME_H, EXTREME_H)

    transformed_brush(nil, info, rect_coords(x1,y1, x2,y2), -EXTREME_H, z1)
    transformed_brush(nil, info, rect_coords(x1,y1, x2,y2), z2, EXTREME_H)

    transformed_brush(nil, info, rect_coords(x1,y1, x2,ledge_y), -EXTREME_H, 128)

    for i=-1,1 do
      local hx = face_x + i * 192
      local hy = face_y - 96
      local item = "mega" -- sel(i == 0, "soul", "mega")

      gui.add_entity(tostring(GAME.things[item].id), hx, hy, 0)

      --[[
      hx = face_x + i * 128
      hy = face_y - 240
      item = sel(i == 0, "plasma", "cell_pack")

      gui.add_entity(tostring(GAME.things[item].id), hx, hy, 0)
      --]]

      if i ~= 0 then
        local tx = face_x + i * 240
        local ty = room_y + 250

        gui.add_entity(tostring(GAME.things["brain_target"].id), tx, ty, 0)

        tx = face_x + i * 400
        ty = ledge_y + 400

        gui.add_entity(tostring(GAME.things["brain_target"].id), tx, ty, 0)

        hx = face_x + i * 128
        hy = room_y + 64

        gui.add_entity(tostring(GAME.things["medikit"].id), hx, hy, 0)
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

      local info =
      {
        t_face = { texture="FLOOR4_8" },
        b_face = { texture="FLOOR4_8" },
        w_face = { texture="METAL1" },
      }

      local step =
      {
        t_face = { texture="FLOOR5_2" },
        b_face = { texture="FLOOR5_2" },
        w_face = { texture="BROWN1", y_offset=0, peg=true },
      }
      
      transformed_brush(nil, info, rect_coords(x1,y1, x2,y2), -EXTREME_H, z + 32)

      transformed_brush(nil, step, rect_coords(x1,y3-32, x2,y3+32), -EXTREME_H, z + 16)

      gui.add_entity(tostring(GAME.things["Cyberdemon"].id),
                     mx, my, z, { angle=angle })

      if i <= 2 then
        gui.add_entity(tostring(GAME.things["launch"].id),
                       mx, my, z, { angle=angle })
      end

      for side = 1,9 do if side ~= 5 then
        local dist = sel((side % 2) == 0, 1.4, 1) * 36
        local rx, ry = nudge_coord(mx, my, side, dist)
        gui.add_entity(tostring(GAME.things["rockets"].id),
                       rx, ry, z, { angle=angle })
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

      local lift =
      {
        t_face = { texture="FLAT5_6" },
        b_face = { texture="FLAT5_6" },
        w_face = { texture="SKSPINE1", x_offset=0, y_offset=0, peg=true },
        sec_tag = 1,
      }

      transformed_brush(nil, lift,
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

    local info =
    {
      t_face = { texture="FLAT5_2" },
      b_face = { texture="FLAT5_2" },
      w_face = { texture="WOOD1", y_offset=0, peg=true },
    }

    transformed_brush(nil, info,
        rect_coords(x1, ledge_y-108, x2, ledge_y+360),
        -EXTREME_H, 240)


    local y1 = ledge_y - 200
    local y2 = y1 + 64

    local lift =
    {
      t_face = { texture="FLAT5_2" },
      b_face = { texture="FLAT5_2" },
      w_face = { texture="WOODMET2", x_offset=0, y_offset=0, peg=true },
      sec_tag = 2,
    }

    transformed_brush(nil, lift,
    {
      { x=x2, y=y1, line_kind=123, line_tag=2 },
      { x=x2, y=y2, line_kind=123, line_tag=2 },
      { x=x1, y=y2, line_kind=123, line_tag=2 },
      { x=x1, y=y1, line_kind=123, line_tag=2 },
    },
    -EXTREME_H, 240)


    local tx = face_x
    local ty = ledge_y + 160

    gui.add_entity(tostring(GAME.things["brain_target"].id), tx, ty, 0)
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
    local info =
    {
      t_face = { texture="MFLR8_3" },
      b_face = { texture="F_SKY1"  },
      w_face = { texture="ROCK4"  },
    }

    transformed_brush(nil, info, rect_coords(x1-32,y1, x1,y2),
                      -EXTREME_H, EXTREME_H)
    transformed_brush(nil, info, rect_coords(x2,y1, x2+32,y2),
                      -EXTREME_H, EXTREME_H)

    transformed_brush(nil, info, rect_coords(x1,y1-32, x2,y1),
                      -EXTREME_H, EXTREME_H)
    transformed_brush(nil, info, rect_coords(x1,y2, x2,y2+32),
                      -EXTREME_H, EXTREME_H)

    transformed_brush(nil, info, rect_coords(x1,y1, x2,y2),
                      -EXTREME_H, 0)
    transformed_brush(nil, info, rect_coords(x1,y1, x2,y2),
                      z, EXTREME_H)
  end

  local function make_beam(x1,y1, x2,y2, z)
    local info =
    {
      t_face = { texture="FLOOR4_8" },
      b_face = { texture="FLOOR4_8"  },
      w_face = { texture="METAL1"  },
    }

    transformed_brush(nil, info, rect_coords(x1,y1, x2,y2),
                      z, EXTREME_H)
  end

  local function make_pillar(x, y, w, z, entity)
    local info =
    {
      t_face = { texture="CEIL5_2" },
      b_face = { texture="CEIL5_2"  },
      w_face = { texture="METAL6", x_offset=0, y_offset=0, peg=true },
    }

    transformed_brush(nil, info, rect_coords(x-w,y-w, x+w,y+w),
                      -EXTREME_H, z)

    if entity then
      gui.add_entity(tostring(GAME.things[entity].id),
                     x, y, z, { angle=rand_irange(0,3)*90 })
    end 
  end


  ---| Arena_Doom_MAP07 |---

  local sky_h = 512
  local manc_h = 64

  make_room(0,0, 2560,2560, sky_h)

  make_beam(256*0.5,256*2.0, 256*9.5,256*3.0, sky_h-64)
  make_beam(256*0.5,256*7.0, 256*9.5,256*8.0, sky_h-64)
  make_beam(256*2.0,256*0.5, 256*3.0,256*9.5, sky_h-64)
  make_beam(256*7.0,256*0.5, 256*8.0,256*9.5, sky_h-64)

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

