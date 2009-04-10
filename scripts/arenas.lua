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
                 x, y, z+35, { angle=angle })

  if GAME.things["player2"] then
    gui.add_entity(tostring(GAME.things["player2"].id),
                   x - dist, y, z + 35, { angle=angle })

    gui.add_entity(tostring(GAME.things["player3"].id),
                   x + dist, y, z + 35, { angle=angle })

    gui.add_entity(tostring(GAME.things["player4"].id),
                   x, y - dist, z + 35, { angle=angle })
  end
end


function Arena_Doom_MAP30()

  local face_x = 1024
  local face_y = 4096

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

      if (fx == 2 and fy == 3) and false then
        -- 
      else
        transformed_brush(nil,
        {
          t_face = { texture="MFLR8_2" },
          b_face = { texture="MFLR8_2", light=0.75 },
          w_face = { texture=FACE_TEX[fy][fx], x_offset=0, y_offset=0, peg=true },
        },
        rect_coords(x1,y1, x2,y2), z1, z2)
      end
    end end -- for fx, fy
  end

  local function make_room()
    local x1 = face_x - 384 * 2
    local x2 = face_x + 384 * 2

    local y1 = face_y - 1024
    local y2 = face_y

    local z1 = 0
    local z2 = 512-64

    local wall_info =
    {
      t_face = { texture="MFLR8_3" },
      b_face = { texture="MFLR8_3" },
      w_face = { texture="ASHWALL4" },
    }

    transformed_brush(nil, wall_info, rect_coords(x1-32,y1, x1,y2),
                      -EXTREME_H, EXTREME_H)

    transformed_brush(nil, wall_info, rect_coords(x2,y1, x2+32,y2),
                      -EXTREME_H, EXTREME_H)

    transformed_brush(nil, wall_info, rect_coords(x1,y1-32, x2,y1),
                      -EXTREME_H, EXTREME_H)

    transformed_brush(nil, wall_info, rect_coords(x1,y2-16, face_x-384,y2+32),
                      -EXTREME_H, EXTREME_H)

    transformed_brush(nil, wall_info, rect_coords(face_x+384,y2-16, x2,y2+32),
                      -EXTREME_H, EXTREME_H)

    transformed_brush(nil, wall_info, rect_coords(x1,y1, x2,y2),
                      -EXTREME_H, z1)

    transformed_brush(nil, wall_info, rect_coords(x1,y1, x2,y2),
                      z2, EXTREME_H)

    Arena_add_players(face_x, y1 + 100, z1, 90)
  end


  ---| Arena_Doom_MAP30 |---

  make_room()
  make_face()
end

