----------------------------------------------------------------
--  BUILDER
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

require 'defs'
require 'util'
require 'seeds'


--[[
class TRANSFORM
{
  mirror_x : number  -- flip horizontally (about given X)
  mirror_y : number  -- flip vertically (about given Y)

  rotate   : number   -- angle in degrees, counter-clockwise

  dx : number   -- translation, i.e. new origin coords
  dy : number   --
}
--]]

function transformed_brush2(T, info, coords, z1, z2)

  if not T then T = {} end

  coords = deep_copy(coords)

  -- TODO !!!  apply transforms to slopes (z1 or z2 == table)

  -- handle mirroring first
  local reverse_it = false

  if T.mirror_x then
    for _,C in ipairs(coords) do
      C.x = T.mirror_x * 2 - C.x
    end
    reverse_it = not reverse_it
  end

  if T.mirror_y then
    for _,C in ipairs(coords) do
      C.y = T.mirror_y * 2 - C.y
    end
    reverse_it = not reverse_it
  end

  if reverse_it then
    -- make sure side properties (w_face, line_kind, etc)
    -- are associated with the correct vertex
    local x1 = coords[1].x
    local y1 = coords[1].y

    for i = 1, #coords-1 do
      coords[i].x = coords[i+1].x
      coords[i].y = coords[i+1].y
    end

    coords[#coords].x = x1
    coords[#coords].y = y1

    table_reverse(coords)
  end

  -- handle rotation
  if T.rotate and T.rotate ~= 0 then
    local cos_R = math.cos(T.rotate * math.pi / 180.0)
    local sin_R = math.sin(T.rotate * math.pi / 180.0)

    for _,C in ipairs(coords) do
      C.x, C.y = C.x * cos_R - C.y * sin_R, C.y * cos_R + C.x * sin_R
    end
  end

  -- handle translation last
  if T.dx or T.dy then
    for _,C in ipairs(coords) do
      C.x = C.x + (T.dx or 0)
      C.y = C.y + (T.dy or 0)
    end
  end

  --[[
  gui.debugf("{\n")
  for _,C in ipairs(coords) do
    gui.debugf("  (%1.3f %1.3f)\n", C.x, C.y)
  end
  gui.debugf("}\n")
  --]]

  gui.add_brush(info, coords, z1, z2)
end


function get_transform_for_seed_side(S, side, thick)
  
  if not thick then thick = S.thick[side] end

  local T = { }

  if side == 8 then T.rotate = 180 end
  if side == 4 then T.rotate = 270 end
  if side == 6 then T.rotate =  90 end

  if side == 2 then T.dx, T.dy = S.x1, S.y1 end
  if side == 4 then T.dx, T.dy = S.x1, S.y2 end
  if side == 6 then T.dx, T.dy = S.x2, S.y1 end
  if side == 8 then T.dx, T.dy = S.x2, S.y2 end

  return T, PARAMS.seed_size, thick
end

function get_transform_for_seed_center(S)
  
  local T = { }

  T.dx = S.x1 + S.thick[4]
  T.dy = S.y1 + S.thick[2]

  local long = S.x2 - S.thick[6] - T.dx
  local deep = S.y2 - S.thick[8] - T.dy

  return T, long, deep
end


function rect_coords(x1, y1, x2, y2)
  return
  {
    { x=x2, y=y1 },
    { x=x2, y=y2 },
    { x=x1, y=y2 },
    { x=x1, y=y1 },
  }
end

function boxwh_coords(x, y, w, h)
  return
  {
    { x=x+w, y=y },
    { x=x+w, y=y+h },
    { x=x,   y=y+h },
    { x=x,   y=y },
  }
end



function get_wall_coords(S, side, thick)
  assert(side ~= 5)

  local x1, y1 = S.x1, S.y1
  local x2, y2 = S.x2, S.y2

  if side == 4 or side == 1 or side == 7 then
    x2 = x1 + (thick or S.thick[4])
  end

  if side == 6 or side == 3 or side == 9 then
    x1 = x2 - (thick or S.thick[6])
  end

  if side == 2 or side == 1 or side == 3 then
    y2 = y1 + (thick or S.thick[2])
  end

  if side == 8 or side == 7 or side == 9 then
    y1 = y2 - (thick or S.thick[8])
  end

  return rect_coords(x1,y1, x2,y2)
end


function Build_sky_fence(S, side)
  
  local wall_info =
  {
    t_face = { texture="FLOOR7_1" },
    b_face = { texture="FLOOR7_1" },
    w_face = { texture="BROWN144" },
  }

  local sky_info =
  {
    t_face = { texture="F_SKY1" },
    b_face = { texture="F_SKY1" },
    w_face = { texture="-" },
  }

  local wall2_info = shallow_copy(wall_info)
  local  sky2_info = shallow_copy(sky_info)

  wall2_info.flag_skyclose = true
   sky2_info.flag_skyclose = true


  local wx1, wy1 = S.x1, S.y1
  local wx2, wy2 = S.x2, S.y2

  local sx1, sy1 = S.x1, S.y1
  local sx2, sy2 = S.x2, S.y2

  if S.thick[side] < 17 then
    error("Sky fence not setup properly (thick <= 16)")
  end

  if side == 4 then
    wx2 = wx1 + S.thick[4]
    sx2 = wx1 + 16
    wx1 = sx2

  elseif side == 6 then
    wx1 = wx2 - S.thick[6]
    sx1 = wx2 - 16
    wx2 = sx1

  elseif side == 2 then
    wy2 = wy1 + S.thick[2]
    sy2 = wy1 + 16
    wy1 = sy2

  elseif side == 8 then
    wy1 = wy2 - S.thick[8]
    sy1 = wy2 - 16
    wy2 = sy1
  end

  local w_coords =
  {
    { x=wx2, y=wy1 }, { x=wx2, y=wy2 },
    { x=wx1, y=wy2 }, { x=wx1, y=wy1 },
  }

  local s_coords =
  {
    { x=sx2, y=sy1 }, { x=sx2, y=sy2 },
    { x=sx1, y=sy2 }, { x=sx1, y=sy1 },
  }

  local z = math.max(PLAN.skyfence_h, (S.room.floor_h or 0) + 64)

  transformed_brush2(nil, wall_info,  w_coords, -4000, z)
  transformed_brush2(nil, wall2_info, s_coords, -4000, PLAN.skyfence_h - 64)

  transformed_brush2(nil, sky_info,  w_coords, 512, 4096)
  transformed_brush2(nil, sky2_info, s_coords, 510, 4096)
end


function Build_archway(S, side, z1, z2, f_tex, w_tex, o_tex)

  local N = S:neighbor(side)
  assert(N)


  local N_deep = N.thick[10-side]

  local T, long, deep = get_transform_for_seed_side(S, side)

  local mx = int(long / 2)

  local arch_info =
  {
    t_face = { texture=f_tex },
    b_face = { texture=f_tex },
    w_face = { texture=w_tex },
  }

  local frame_coords =
  {
    { x=long, y=-N_deep },
    { x=long, y=deep },
    { x=0,    y=deep },
    { x=0,    y=-N_deep, w_face={ texture=o_tex } },
  }

  transformed_brush2(T, arch_info, frame_coords, z2, 2000)


  assert(deep > 17 or N_deep > 17)

  local break_tex = w_tex
  if o_tex ~= w_tex then break_tex = "LITE5" end

  for pass = 1,2 do
    if pass == 2 then T.mirror_x = mx end

    transformed_brush2(T, arch_info,
    {
      { x=0,     y=-N_deep,    w_face= {texture=o_tex} },
      { x=24+16, y=-N_deep,    w_face= {texture=o_tex} },
      { x=36+16, y=-N_deep+16, w_face= {texture=break_tex} },
      { x=36+16, y=deep-16 },
      { x=24+16, y=deep },
      { x=0,     y=deep },
    },
    -2000, 2000)
  end
end


function Build_locked_door(S, side, z1, w_tex, info, tag)

  tag2 = nil  -- FIXME !!!

  local N = S:neighbor(side)
  assert(N)

  local o_tex = w_tex

  if (S.room.outdoor and not N.room.outdoor) or
     (S.room.kind == "hallway" and N.room.kind ~= "hallway" and not N.room.outdoor) then
    o_tex = N.room.combo.wall
    w_tex = o_tex
  end


  local DY = 24

  local T, long, deep = get_transform_for_seed_side(S, side)

  local mx = int(long / 2)
  local my = 0

gui.debugf("INFO = %s\n", table_to_str(info,3))
  local door_h = info.skin.door_h or 112
  local door_info =
  {
    t_face = { texture="FLAT1" },
    b_face = { texture="FLAT1" },
    w_face = { texture=assert(info.skin.door_w), peg=true, x_offset=0, y_offset=0 },
--  w_face = { texture="PIPES", peg=true, x_offset=0, y_offset=0 },
    flag_door = true,
    sec_tag = tag,
  }

  local frame_info =
  {
    t_face = { texture="FLAT18" },
    b_face = { texture="FLAT18" },
    w_face = { texture=w_tex },
  }

  local step_info =
  {
    t_face = { texture="FLAT18" },
    b_face = { texture="FLAT18" },
    w_face = { texture="STEP4" },
  }

  local key_info =
  {
    t_face = { texture="FLAT18" },
    b_face = { texture="FLAT18" },
    w_face = { texture=assert(info.skin.key_w), x_offset=0, y_offset=0 },
  }

  transformed_brush2(T, step_info,
  {
    { x=long, y=my-DY },
    { x=long, y=my+DY },
    { x=0,    y=my+DY },
    { x=0,    y=my-DY },
  },
  -2000, z1+8)

  transformed_brush2(T, frame_info,
  {
    { x=long, y=my-DY },
    { x=long, y=my+DY },
    { x=0,    y=my+DY },
    { x=0,    y=my-DY, w_face = {texture=o_tex} },
  },
  z1+8+door_h, 2000)

  local KIND = assert(info.skin.line_kind)

if TESTING_QUAKE1_DOORS then
  local m_ref = gui.q1_add_mapmodel(
  {
    y_face={ texture="edoor01_1" },
    x_face={ texture="met5_1" },
    z_face={ texture="met5_1" },
  },
  -1664+64,  -328-12, 0,
  -1664+128, -328+12, 128)

  gui.add_entity(0, 0, 0,
                 { name="func_door", angle="180", sounds="2",
                   model=assert(m_ref)
                 })


  m_ref = gui.q1_add_mapmodel(
  {
    y_face={ texture="edoor01_1" },
    x_face={ texture="met5_1" },
    z_face={ texture="met5_1" },
  },
  -1664+128, -328-12, 0,
  -1664+192, -328+12, 128)

  gui.add_entity(0, 0, 0,
                 { name="func_door", angle="0", sounds="2",
                   model=assert(m_ref)
                 })
else
  transformed_brush2(T, door_info,
  {
    { x=mx+64, y=my-8, line_kind=KIND, line_tag=tag2 },
    { x=mx+64, y=my+8, line_kind=KIND, line_tag=tag2 },
    { x=mx-64, y=my+8, line_kind=KIND, line_tag=tag2 },
    { x=mx-64, y=my-8, line_kind=KIND, line_tag=tag2 },
  },
  z1+64, 2000)
end


  for pass = 1,2 do
    if pass == 2 then T.mirror_x = mx end

    transformed_brush2(T, key_info,
    {
      { x=mx-64,    y=my-8, w_face={ texture="DOORTRAK", peg=true } },
      { x=mx-64,    y=my+8  },
      { x=mx-64-18, y=my+DY },
      { x=mx-64-18, y=my-DY },
    },
    -2000, 2000)

    transformed_brush2(T, frame_info,
    {
      { x=mx-64-18, y=my-DY },
      { x=mx-64-18, y=my+DY },
      { x=0,        y=my+DY },
      { x=0,        y=my-DY, w_face={ texture=o_tex } },
    },
    -2000, 2000)
  end
end


function Build_lowering_bars(S, side, z1, skin, tag)

  local T, long, deep = get_transform_for_seed_side(S, side)

  local bar_w = 24
  local bar_tw = 6+bar_w+6

  local num_bars = int((long-16) / bar_tw)
  local side_gap = int((long-16 - num_bars * bar_tw) / 2)

  assert(num_bars >= 2)

  local bar_info =
  {
    t_face = { texture=skin.bar_f },
    b_face = { texture=skin.bar_f },
    w_face = { texture=skin.bar_w, peg=true,
               x_offset=skin.x_offset or 0,
               y_offset=skin.y_offset or 0 },
    sec_tag = tag,
  }

  local mx1 = 8 + side_gap + bar_w/2
  local mx2 = long - 8 - side_gap - bar_w/2

  local z_top = z1 + skin.bar_h
  if S.room.fence_h then
    z_top = math.max(z_top, S.room.fence_h + 16)
  end

  for i = 1,num_bars do
    local mx = mx1 + (mx2 - mx1) * (i-1) / (num_bars-1)
    local my = 0

    transformed_brush2(T, bar_info,
    {
      { x=mx+bar_w/2, y=my-bar_w/2 },
      { x=mx+bar_w/2, y=my+bar_w/2 },
      { x=mx-bar_w/2, y=my+bar_w/2 },
      { x=mx-bar_w/2, y=my-bar_w/2 },
    },
    -2000, z_top)
  end
end


function Build_hall_light(S, z2)

  local mx = int((S.x1 + S.x2)/2)
  local my = int((S.y1 + S.y2)/2)

  transformed_brush2(nil,
  {
    t_face = { texture="CEIL5_2" },
    b_face = { texture="TLITE6_5" },
    w_face = { texture="METAL" },
  },
  {
    { x = mx+32, y = my-32 },
    { x = mx+32, y = my+32 },
    { x = mx-32, y = my+32 },
    { x = mx-32, y = my-32 },
  },
  z2-12, 2000)


  local metal_info =
  {
    t_face = { texture="CEIL5_2" },
    b_face = { texture="CEIL5_2" },
    w_face = { texture="METAL" },
  }

  transformed_brush2(nil, metal_info,
  {
    { x = mx-32, y = my-40 },
    { x = mx-32, y = my+40 },
    { x = mx-40, y = my+40 },
    { x = mx-40, y = my-40 },
  },
  z2-16, 2000)

  transformed_brush2(nil, metal_info,
  {
    { x = mx+40, y = my-40 },
    { x = mx+40, y = my+40 },
    { x = mx+32, y = my+40 },
    { x = mx+32, y = my-40 },
  },
  z2-16, 2000)

  transformed_brush2(nil, metal_info,
  {
    { x = mx+40, y = my-40 },
    { x = mx+40, y = my-32 },
    { x = mx-40, y = my-32 },
    { x = mx-40, y = my-40 },
  },
  z2-16, 2000)

  transformed_brush2(nil, metal_info,
  {
    { x = mx+40, y = my+32 },
    { x = mx+40, y = my+40 },
    { x = mx-40, y = my+40 },
    { x = mx-40, y = my+32 },
  },
  z2-16, 2000)
 

--[[ connecting spokes....

  transformed_brush2(nil, metal_info,
  {
    { x = mx+4, y = my+40 },
    { x = mx+4, y = S.y2  },
    { x = mx-4, y = S.y2  },
    { x = mx-4, y = my+40 },
  },
  z2-10, 2000)

  transformed_brush2(nil, metal_info,
  {
    { x = mx+4, y = S.y1  },
    { x = mx+4, y = my-40 },
    { x = mx-4, y = my-40 },
    { x = mx-4, y = S.y1  },
  },
  z2-10, 2000)

  transformed_brush2(nil, metal_info,
  {
    { x = mx-40, y = my-4, },
    { x = mx-40, y = my+4, },
    { x = S.x1 , y = my+4, },
    { x = S.x1 , y = my-4, },
  },
  z2-10, 2000)

  transformed_brush2(nil, metal_info,
  {
    { x = S.x2 , y = my-4, },
    { x = S.x2 , y = my+4, },
    { x = mx+40, y = my+4, },
    { x = mx+40, y = my-4, },
  },
  z2-10, 2000)
 
--]]
end


function Build_detailed_hall(S, side, z1, z2)

  local function get_hall_coords(thickness)

    ---### S.thick[side] = thickness

    local ox1, oy1, ox2, oy2 = S.x1,S.y1, S.x2,S.y2

    if (side == 4 or side == 6) then

      if S:neighbor(2) and S:neighbor(2).room == S.room then
        S.y1 = S.y1 - thickness
      end

      if S:neighbor(8) and S:neighbor(8).room == S.room then
        S.y2 = S.y2 + thickness
      end

    else
      if S:neighbor(4) and S:neighbor(4).room == S.room then
        S.x1 = S.x1 - thickness
      end

      if S:neighbor(6) and S:neighbor(6).room == S.room then
        S.x2 = S.x2 + thickness
      end

    end

    local res = get_wall_coords(S, side, thickness)

    S.x1,S.y1, S.x2,S.y2 = ox1, oy1, ox2, oy2
    
    return res
  end


  if PLAN.hall_trim then
    transformed_brush2(nil,
    {
      t_face = { texture="CEIL5_2" },
      b_face = { texture="CEIL5_2" },
      w_face = { texture="METAL" },
    },
    get_hall_coords(32), -2000, z1 + 32)

    transformed_brush2(nil,
    {
      t_face = { texture="CEIL5_2" },
      b_face = { texture="CEIL5_2" },
      w_face = { texture="METAL" },
    },
    get_hall_coords(32), z2 - 32, 2000)
  end


  transformed_brush2(nil,
  {
    t_face = { texture="FLAT1" },
    b_face = { texture="FLAT1" },
    w_face = { texture="GRAY7" },
  },
  get_hall_coords(64), -2000, z1 + 6)

  transformed_brush2(nil,
  {
    t_face = { texture="FLAT1" },
    b_face = { texture="FLAT1" },
    w_face = { texture="GRAY7" },
  },
  get_hall_coords(64), z2 - 6, 2000)


  transformed_brush2(nil,
  {
    t_face = { texture="FLAT1" },
    b_face = { texture="FLAT1" },
    w_face = { texture=PLAN.hall_tex or "GRAY7" },
  },
  get_hall_coords(24), -2000, 2000)


  -- TODO : corners
end


function Build_weird_hall(S, side, z1, z2)

  local function get_hall_coords(thickness)

    S.thick[side] = thickness

    local ox1, oy1, ox2, oy2 = S.x1,S.y1, S.x2,S.y2

    if (side == 4 or side == 6) then

      if S:neighbor(2) and S:neighbor(2).room == S.room then
        S.y1 = S.y1 - thickness
      end

      if S:neighbor(8) and S:neighbor(8).room == S.room then
        S.y2 = S.y2 + thickness
      end

    else
      if S:neighbor(4) and S:neighbor(4).room == S.room then
        S.x1 = S.x1 - thickness
      end

      if S:neighbor(6) and S:neighbor(6).room == S.room then
        S.x2 = S.x2 + thickness
      end

    end

    local res = get_wall_coords(S, side)

    S.x1,S.y1, S.x2,S.y2 = ox1, oy1, ox2, oy2
    
    return res
  end


  local metal = 
  {
    t_face = { texture="FLAT23" },
    b_face = { texture="FLAT23" },
    w_face = { texture="SHAWN2" },
  }

  transformed_brush2(nil, metal, get_hall_coords(24), -2000, 2000)

  transformed_brush2(nil, metal, get_hall_coords(32), -2000, z1 + 32)
  transformed_brush2(nil, metal, get_hall_coords(32), z2 - 32, 2000)

  transformed_brush2(nil, metal, get_hall_coords(48), -2000, z1 + 18)
  transformed_brush2(nil, metal, get_hall_coords(48), z2 - 18, 2000)

  transformed_brush2(nil, metal, get_hall_coords(64), -2000, z1 + 6)
  transformed_brush2(nil, metal, get_hall_coords(64), z2 - 6, 2000)

end


function Build_diagonal(S, dir, info, z1)

  local x1 = S.x1 + S.thick[4]
  local y1 = S.y1 + S.thick[2]

  local x2 = S.x2 - S.thick[6]
  local y2 = S.y2 - S.thick[8]

  local coords

  if dir == 9 then
    coords =
    {
      { x=x1, y=y2 },
      { x=x2, y=y1 },
      { x=x2, y=y2 },
    }
  elseif dir == 7 then
    coords =
    {
      { x=x1, y=y1 },
      { x=x2, y=y2 },
      { x=x1, y=y2 },
    }
  elseif dir == 3 then
    coords =
    {
      { x=x2, y=y2 },
      { x=x1, y=y1 },
      { x=x2, y=y1 },
    }
  elseif dir == 1 then
    coords =
    {
      { x=x2, y=y1 },
      { x=x1, y=y2 },
      { x=x1, y=y1 },
    }
  else
    error("WTF dir")
  end

  transformed_brush2(nil, info, coords, z1 or -4000, 4000)
end


function Build_arrow(S, dir, f_h)
 
  local mx = int((S.x1 + S.x2)/2)
  local my = int((S.y1 + S.y2)/2)

  local dx, dy = dir_to_delta(dir)
  local ax, ay = dir_to_delta(rotate_cw90(dir))

  transformed_brush2(nil,
  {
    t_face = { texture="FWATER1" },
    b_face = { texture="FWATER1" },
    w_face = { texture="COMPBLUE" },
  },
  {
    { x = mx - ax*20,  y = my - ay * 20  },
    { x = mx + ax*20,  y = my + ay * 20  },
    { x = mx + dx*100, y = my + dy * 100 },
  },
  -2000, f_h + 8)
end


function Build_curved_hall(steps, corn_x, corn_y,
                           dx0, dx1, dx2, dx3,
                           dy0, dy1, dy2, dy3,
                           x_h, y_h, gap_h,
                           wall_info, floor_info, ceil_info)

gui.printf("corner (%d,%d)  DX %d,%d,%d,%d  DY %d,%d,%d,%d\n",
           corn_x,corn_y, dx0,dx1,dx2,dx3, dy0,dy1,dy2,dy3);

  assert((0 < dx0 and dx0 < dx1 and dx1 < dx2 and dx2 < dx3) or
         (0 > dx0 and dx0 > dx1 and dx1 > dx2 and dx2 > dx3))

  assert((0 < dy0 and dy0 < dy1 and dy1 < dy2 and dy2 < dy3) or
         (0 > dy0 and dy0 > dy1 and dy1 > dy2 and dy2 > dy3))

  local flipped = false
  if sel(dx3 < 0, 1, 0) == sel(dy3 < 0, 1, 0) then
    flipped = true
  end

  local function quantize(x)
    return int(x * 8.0 + 0.5) / 8.0
  end

  local function arc_coords(p0, p1, dx0,dx1, dy0,dy1)
    local px0 = math.cos(math.pi * p0 / 2.0)
    local py0 = math.sin(math.pi * p0 / 2.0)

    local px1 = math.cos(math.pi * p1 / 2.0)
    local py1 = math.sin(math.pi * p1 / 2.0)

    local cx0 = quantize(corn_x + dx0 * px0)
    local cy0 = quantize(corn_y + dy0 * py0)
    local fx0 = quantize(corn_x + dx1 * px0)
    local fy0 = quantize(corn_y + dy1 * py0)

    local cx1 = quantize(corn_x + dx0 * px1)
    local cy1 = quantize(corn_y + dy0 * py1)
    local fx1 = quantize(corn_x + dx1 * px1)
    local fy1 = quantize(corn_y + dy1 * py1)

    if flipped then
      return
      {
        { x = cx0, y = cy0 },
        { x = fx0, y = fy0 },
        { x = fx1, y = fy1 },
        { x = cx1, y = cy1 },
      }
    else
      return
      {
        { x = cx1, y = cy1 },
        { x = fx1, y = fy1 },
        { x = fx0, y = fy0 },
        { x = cx0, y = cy0 },
      }
    end
  end

  --| Build_curved_hall |--

  assert(steps >= 2)

  for i = 1,steps do
    local p0 = (i-1)/steps
    local p1 = (i  )/steps

    local f_h = x_h + (y_h - x_h) * (i-1) / (steps-1)
    local c_h = f_h + gap_h

    transformed_brush2(nil, wall_info, arc_coords(p0,p1, dx0,dx1, dy0,dy1), -2000,2000)
    transformed_brush2(nil, wall_info, arc_coords(p0,p1, dx2,dx3, dy2,dy3), -2000,2000)

    local coords = arc_coords(p0,p1, dx1,dx2, dy1,dy2)

    transformed_brush2(nil, floor_info, coords, -2000, f_h)
    transformed_brush2(nil, ceil_info,  coords, c_h, 2000)
  end
end


function Build_ramp_x(skin, bx1,bx2,y1, tx1,tx2,y2, az,bz, exact)
  assert(az and bz)

  local steps = int(math.abs(az-bz) / 14 + 0.9)
  local z

  if steps < 2 then steps = 2 end

  if exact then steps = steps + 1 end

  for i = 0,steps-1 do 
    if exact then
      z = az + (bz - az) * (i  ) / (steps-1)
    else
      z = az + (bz - az) * (i+1) / (steps+1)
    end

    local bx3 = bx1 + (bx2 - bx1) * i / steps
    local bx4 = bx1 + (bx2 - bx1) * (i+1) / steps

    local tx3 = tx1 + (tx2 - tx1) * i / steps
    local tx4 = tx1 + (tx2 - tx1) * (i+1) / steps

    bx3 = int(bx3) ; tx3 = int(tx3)
    bx4 = int(bx4) ; tx4 = int(tx4)

    transformed_brush2(nil, skin,
    {
      { x=bx4, y=y1 },
      { x=tx4, y=y2 },
      { x=tx3, y=y2 },
      { x=bx3, y=y1 },
    },
    -2000, z);
  end
end


function Build_ramp_y(skin, x1,ly1,ly2, x2,ry1,ry2, az,bz, exact)
  assert(az and bz)

  local steps = int(math.abs(az-bz) / 14 + 0.9)
  local z

  if steps < 2 then steps = 2 end

  if exact then steps = steps + 1 end

  for i = 0,steps-1 do 
    if exact then
      z = az + (bz - az) * (i  ) / (steps-1)
    else
      z = az + (bz - az) * (i+1) / (steps+1)
    end

    local ly3 = ly1 + (ly2 - ly1) * i / steps
    local ly4 = ly1 + (ly2 - ly1) * (i+1) / steps

    local ry3 = ry1 + (ry2 - ry1) * i / steps
    local ry4 = ry1 + (ry2 - ry1) * (i+1) / steps

    ly3 = int(ly3) ; ry3 = int(ry3)
    ly4 = int(ly4) ; ry4 = int(ry4)

    transformed_brush2(nil, skin,
    {
      { x=x2, y=ry3 },
      { x=x2, y=ry4 },
      { x=x1, y=ly4 },
      { x=x1, y=ly3 },
    },
    -2000, z);
  end
end


function Build_niche_stair(S, stair_info)

  for side = 2,8,2 do
    S.thick[side] = 64
  end

  local T, long = get_transform_for_seed_side(S, S.stair_dir)
  local deep = long

  local z1 = S.stair_z2
  local z2 = S.stair_z1

  local niche_info =
  {
    t_face = { texture=S.f_tex or S.room.combo.floor },
    b_face = { texture=S.f_tex or S.room.combo.floor },
    w_face = { texture=S.room.combo.wall },
  }

  local W  = sel(z1 > z2, 48, 24)
  local HB = sel(z1 > z2, 96, 64)
  local HF = 40

  transformed_brush2(T, niche_info,
  {
    { x = W, y = 0,    },
    { x = W, y = deep, },
    { x = 0, y = deep, },
    { x = 0, y = 0,    },
  },
  -2000, z2)

  transformed_brush2(T, niche_info,
  {
    { x = long,   y = 0,    },
    { x = long,   y = deep, },
    { x = long-W, y = deep, },
    { x = long-W, y = 0,    },
  },
  -2000, z2)

  transformed_brush2(T, niche_info,
  {
    { x = long-W, y = deep-HB, },
    { x = long-W, y = deep,   },
    { x =      W, y = deep,   },
    { x =      W, y = deep-HB, },
  },
  -2000, z2)

  transformed_brush2(T, stair_info,
  {
    { x = long-W, y = 0,  },
    { x = long-W, y = HF, },
    { x =      W, y = HF, },
    { x =      W, y = 0,  },
  },
  -2000, z1)


  local steps = int(math.abs(z2 - z1) / 14 + 0.9)

  if steps < 2 then steps = 2 end

  for i = 0,steps-1 do 
    local z = z1 + (z2 - z1) * (i+1) / (steps+1)

    local by = int(HF + (deep-HF-HB) * (i)   / steps)
    local ty = int(HF + (deep-HF-HB) * (i+1) / steps)

    transformed_brush2(T, stair_info,
    {
      { x=long-W, y=by },
      { x=long-W, y=ty },
      { x=     W, y=ty },
      { x=     W, y=by },
    },
    -2000, int(z));
  end
end


function Build_tall_curved_stair(S, step_info, x_side,y_side, x_h,y_h)
  assert(x_h and y_h)

  local steps = int(math.abs(x_h-y_h) / 14 + 0.9)

  if steps < 4 then
    steps = 4
  end

  local x1, y1 = S.x1, S.y1
  local x2, y2 = S.x2, S.y2

  local w = x2 - x1 + 1
  local h = y2 - y1 + 1

  local corn_x = x1
  local corn_y = y1

  local dx0, dx1, dx2, dx3 = 16, 40, w-32, w
  local dy0, dy1, dy2, dy3 = 16, 40, h-32, h

  if x_side == 6 then
    corn_x = x2
    dx0 = -dx0 ; dx1 = -dx1
    dx2 = -dx2 ; dx3 = -dx3
  end

  if y_side == 8 then
    corn_y = y2
    dy0 = -dy0 ; dy1 = -dy1
    dy2 = -dy2 ; dy3 = -dy3
  end

  local w_tex = S.w_tex or S.room.combo.wall

  local info =
  {
    t_face = { texture="FLAT1" },
    b_face = { texture="FLAT1" },
    w_face = { texture=w_tex },
  }

  Build_curved_hall(steps, corn_x, corn_y,
                    dx0, dx1, dx2, dx3,
                    dy0, dy1, dy2, dy3,
                    x_h, y_h, 256,
                    info, step_info, info)
end


--[[ NOT USED
function Build_corner_ramp_JAGGY(S, x1,y1, x2,y2, x_h,y_h)
  assert(x_h and y_h)

  local d_h = sel(x_h < y_h, 1, -1)
  local m_h = int((x_h + y_h) / 2)

  local pw = (x2 - x1) / 4
  local ph = (y2 - y1) / 4
  local pz = math.max(x_h, y_h)

  local info =
  {
    t_face = { texture="FLAT1" },
    b_face = { texture="FLAT1" },
    w_face = { texture="SLADWALL" },
  }

  if S.layout and S.layout.char == "L" then

    Build_ramp_y(info, x1,y1,y2, x2-pw,y2-ph,y2, m_h-d_h*4, x_h, "exact")
    Build_ramp_x(info, x1,x2,y1, x2-pw,x2,y2-ph, m_h+d_h*4, y_h, "exact")

    transformed_brush2(nil, info,
    {
      { x=x2,    y=y2-ph },
      { x=x2,    y=y2 },
      { x=x2-pw, y=y2 },
      { x=x2-pw, y=y2-ph },
    }, -2000, pz)

  elseif S.layout and S.layout.char == "J" then

    Build_ramp_y(info, x1+pw,y2-ph,y2, x2,y1,y2, m_h-d_h*4, x_h, "exact")
    Build_ramp_x(info, x1,x2,y1, x1,x1+pw,y2-ph, y_h, m_h+d_h*4, "exact")

    transformed_brush2(nil, info,
    {
      { x=x1+pw, y=y2-ph },
      { x=x1+pw, y=y2 },
      { x=x1,    y=y2 },
      { x=x1,    y=y2-ph },
    }, -2000, pz)

  elseif S.layout and S.layout.char == "F" then

    Build_ramp_y(info, x1,y1,y2, x2-pw,y1,y1+ph, x_h, m_h-d_h*4, "exact")
    Build_ramp_x(info, x2-pw,x2,y1+ph, x1,x2,y2, m_h+d_h*4, y_h, "exact")

    transformed_brush2(nil, info,
    {
      { x=x2,    y=y1 },
      { x=x2,    y=y1+ph },
      { x=x2-pw, y=y1+ph },
      { x=x2-pw, y=y1 },
    }, -2000, pz)

  elseif S.layout and S.layout.char == "T" then

    Build_ramp_y(info, x1+pw,y1,y1+ph, x2,y1,y2, x_h, m_h-d_h*4, "exact")
    Build_ramp_x(info, x1,x1+pw,y1+ph, x1,x2,y2, y_h, m_h+d_h*4, "exact")

    transformed_brush2(nil, info,
    {
      { x=x1+pw, y=y1 },
      { x=x1+pw, y=y1+ph },
      { x=x1,    y=y1+ph },
      { x=x1,    y=y1 },
    }, -2000, pz)
  end
end
--]]


--[[ NOT USED
function Build_corner_ramp_STRAIGHT(S, x1,y1, x2,y2, x_h,y_h)
  assert(x_h and y_h)

  local d_h = sel(x_h < y_h, 1, -1)
  local m_h = int((x_h + y_h) / 2)

  local pw = int((x2 - x1) * 0.35)
  local ph = int((y2 - y1) * 0.35)
  local pz = math.max(x_h, y_h)

  local info =
  {
    t_face = { texture="FLAT10" },
    b_face = { texture="FLAT10" },
    w_face = { texture="ASHWALL4" },
  }

  local pilla, mezza

  if S.layout and S.layout.char == "L" then

    Build_ramp_y(info, x1,y2-ph,y2, x2-pw,y2-ph,y2, m_h-d_h*4, x_h, "exact")
    Build_ramp_x(info, x2-pw,x2,y1, x2-pw,x2,y2-ph, m_h+d_h*4, y_h, "exact")

    pilla =
    {
      { x=x2,    y=y2-ph },
      { x=x2,    y=y2 },
      { x=x2-pw, y=y2 },
      { x=x2-pw, y=y2-ph },
    }

    mezza =
    {
      { x=x2-pw, y=y1 },
      { x=x2-pw, y=y2-ph },
      { x=x1,    y=y2-ph },
      { x=x1,    y=y1 },
    }

  elseif S.layout and S.layout.char == "J" then

    Build_ramp_y(info, x1+pw,y2-ph,y2, x2,y2-ph,y2, m_h-d_h*4, x_h, "exact")
    Build_ramp_x(info, x1,x1+pw,y1, x1,x1+pw,y2-ph, y_h, m_h+d_h*4, "exact")

    pilla =
    {
      { x=x1+pw, y=y2-ph },
      { x=x1+pw, y=y2 },
      { x=x1,    y=y2 },
      { x=x1,    y=y2-ph },
    }

    mezza =
    {
      { x=x2   , y=y1 },
      { x=x2   , y=y2-ph },
      { x=x1+pw, y=y2-ph },
      { x=x1+pw, y=y1 },
    }

  elseif S.layout and S.layout.char == "F" then

    Build_ramp_y(info, x1,y1,y1+ph, x2-pw,y1,y1+ph, x_h, m_h-d_h*4, "exact")
    Build_ramp_x(info, x2-pw,x2,y1+ph, x2-pw,x2,y2, m_h+d_h*4, y_h, "exact")

    pilla =
    {
      { x=x2,    y=y1 },
      { x=x2,    y=y1+ph },
      { x=x2-pw, y=y1+ph },
      { x=x2-pw, y=y1 },
    }

    mezza =
    {
      { x=x2-pw, y=y1+ph },
      { x=x2-pw, y=y2 },
      { x=x1,    y=y2 },
      { x=x1,    y=y1+ph },
    }

  elseif S.layout and S.layout.char == "T" then

    Build_ramp_y(info, x1+pw,y1,y1+ph, x2,y1,y1+ph, x_h, m_h-d_h*4, "exact")
    Build_ramp_x(info, x1,x1+pw,y1+ph, x1,x1+pw,y2, y_h, m_h+d_h*4, "exact")

    pilla =
    {
      { x=x1+pw, y=y1 },
      { x=x1+pw, y=y1+ph },
      { x=x1,    y=y1+ph },
      { x=x1,    y=y1 },
    }

    mezza =
    {
      { x=x2   , y=y1+ph },
      { x=x2   , y=y2 },
      { x=x1+pw, y=y2    },
      { x=x1+pw, y=y1+ph },
    }
  end

  transformed_brush2(nil, info, pilla, -2000, pz)
  transformed_brush2(nil, info, mezza, -2000, m_h)
end
--]]


function Build_low_curved_stair(S, step_info, x_side,y_side, x_h,y_h)

  -- create transform
  local T =
  {
    dx = S.x1, dy = S.y1,
  }

  local long = S.x2 - S.x1
  local deep = S.y2 - S.y1

  if x_side == 6 then
    T.mirror_x = long / 2
  end

  if y_side == 8 then
    T.mirror_y = deep / 2
  end

  local bord_W = 16

  local steps = 2 * int(math.abs(x_h-y_h) / 28 + 0.9)

  if steps < 4 then
    steps = 4
  end

  local corn_coords =
  {
    { x=32, y=32 },
    { x=0,  y=32 },
    { x=0,  y=0 },
    { x=32, y=0 },
  }


  for i = steps,1,-1 do
    
    local z = x_h + (y_h - x_h) * (i-1) / (steps-1)

    local ang1 = (math.pi / 2.0) * (i-1) / steps
    local ang2 = (math.pi / 2.0) * (i  ) / steps

    local dx1, dy1 = math.cos(ang1), math.sin(ang1)
    local dx2, dy2 = math.cos(ang2), math.sin(ang2)

gui.debugf("DEL (%1.3f %1.3f)  (%1.3f %1.3f)\n", dx1, dy1, dx2,dy2)

    local cx1 = 32 * dx1
    local cy1 = 32 * dy1

    local cx2 = 32 * dx2
    local cy2 = 32 * dy2

    local fx1 = (long - bord_W) * 1.42 * dx1
    local fy1 = (deep - bord_W) * 1.42 * dy1

    local fx2 = (long - bord_W) * 1.42 * dx2
    local fy2 = (deep - bord_W) * 1.42 * dy2

    fx1 = math.min(fx1, long - bord_W)
    fy1 = math.min(fy1, deep - bord_W)

    fx2 = math.min(fx2, long - bord_W)
    fy2 = math.min(fy2, deep - bord_W)

gui.debugf("(%d,%d) .. (%d,%d) .. (%d,%d) .. (%d,%d)\n",
cx1,cy1, cx2,cy2, fx2,fy2, fx1,fy1)
    transformed_brush2(T, step_info,
    {
      { x=fx1, y=fy1 },
      { x=fx2, y=fy2 },
      { x=cx2, y=cy2 },
      { x=cx1, y=cy1 },
    },
    -2000, z)
  end


  local mat_info =
  {
    b_face = { texture="CEIL5_2" },
    t_face = { texture="CEIL5_2" },
    w_face = { texture="METAL" },
  }

  local h3 = math.max(x_h, y_h)

  transformed_brush2(T, mat_info, corn_coords, -2000, h3)

  transformed_brush2(T, mat_info,
  {
    { x=long, y=deep-bord_W },
    { x=long, y=deep },
    { x=0, y=deep    },
    { x=0, y=deep-bord_W },
  },
  -2000, h3)

  transformed_brush2(T, mat_info,
  {
    { x=long, y=0 },
    { x=long, y=deep },
    { x=long-bord_W, y=deep },
    { x=long-bord_W, y=0 },
  },
  -2000, h3)
end


function Build_outdoor_ramp_down(ST, f_tex, w_tex)
  local conn_dir = assert(ST.S.conn_dir)

  local oh  = ST.outer_h
  local ih  = ST.inner_h

  -- outer rectangle
  local ox1 = SEEDS[ST.x1][ST.y1][1].x1
  local oy1 = SEEDS[ST.x1][ST.y1][1].y1
  local ox2 = SEEDS[ST.x2][ST.y2][1].x2
  local oy2 = SEEDS[ST.x2][ST.y2][1].y2

  -- inner rectangle
  local ix1 = ST.S.x1
  local iy1 = ST.S.y1
  local ix2 = ST.S.x2
  local iy2 = ST.S.y2

  local info =
  {
    b_face = { texture=f_tex },
    t_face = { texture=f_tex },
    w_face = { texture=w_tex },
  }

gui.debugf("Build_outdoor_ramp_down: S:(%d,%d) conn_dir:%d\n", ST.S.sx, ST.S.sy, conn_dir)

  if conn_dir == 6 then
    ix1 = ix2-96
    Build_ramp_x(info, ox1,ix1,oy1, ox1,ix1,oy2, oh, ih, "exact")

  elseif conn_dir == 4 then
    ix2 = ix1 + 96
    Build_ramp_x(info, ix2,ox2,oy1, ix2,ox2,oy2, ih, oh, "exact")

  elseif conn_dir == 8 then
    iy1 = iy2-96
    Build_ramp_y(info, ox1,oy1,iy1, ox2,oy1,iy1, oh, ih, "exact")

  elseif conn_dir == 2 then
    iy2 = iy1 + 96
    Build_ramp_y(info, ox1,iy2,oy2, ox2,iy2,oy2, ih, oh, "exact")
  end


  if is_horiz(conn_dir) then
    if iy2+64 < oy2 then
      Build_ramp_y(info, ox1,iy2,oy2, ox2,iy2,oy2, ih, oh, "exact")
    end
    if iy1-64 > oy1 then
      Build_ramp_y(info, ox1,oy1,iy1, ox2,oy1,iy1, oh, ih, "exact")
    end
  else -- is_vert
    if ix2+64 < ox2 then
      Build_ramp_x(info, ix2,ox2,oy1, ix2,ox2,oy2, ih, oh, "exact")
    end
    if ix1-64 > ox1 then
      Build_ramp_x(info, ox1,ix1,oy1, ox1,ix1,oy2, oh, ih, "exact")
    end
  end

  ST.done = true
end

function Build_outdoor_ramp_up(ST, f_tex, w_tex)
  local conn_dir = assert(ST.S.conn_dir)

  local oh  = ST.outer_h
  local ih  = ST.inner_h

  -- outer rectangle
  local ox1 = SEEDS[ST.x1][ST.y1][1].x1
  local oy1 = SEEDS[ST.x1][ST.y1][1].y1
  local ox2 = SEEDS[ST.x2][ST.y2][1].x2
  local oy2 = SEEDS[ST.x2][ST.y2][1].y2

  -- inner rectangle
  local ix1 = ST.S.x1
  local iy1 = ST.S.y1
  local ix2 = ST.S.x2
  local iy2 = ST.S.y2

  local info =
  {
    b_face = { texture=f_tex },
    t_face = { texture=f_tex },
    w_face = { texture=w_tex },
  }

gui.debugf("Build_outdoor_ramp_up: S:(%d,%d) conn_dir:%d\n", ST.S.sx, ST.S.sy, conn_dir)

  if conn_dir == 6 then
    ix1 = ix2 - 64
    ox1 = ox1 + 32

  elseif conn_dir == 4 then
    ix2 = ix1 + 64
    ox2 = ox2 - 32

  elseif conn_dir == 8 then
    iy1 = iy2 - 64
    oy1 = oy1 + 32

  elseif conn_dir == 2 then
    iy2 = iy1 + 64
    oy2 = oy2 - 32
  end


  assert(ih > oh)

  local steps = int((ih - oh) / 12 + 0.9)
  if steps < 4 then steps = 4 end

  for i = 0,steps do

    local z = ih + (oh - ih) * i / (steps+1)

    local nx1 = ix1 + (ox1 - ix1) * i / (steps+0)
    local ny1 = iy1 + (oy1 - iy1) * i / (steps+0)

    local nx2 = ix2 + (ox2 - ix2) * i / (steps+0)
    local ny2 = iy2 + (oy2 - iy2) * i / (steps+0)

    if nx1 > nx2 then nx1,nx2 = nx2,nx1 end
    if ny1 > ny2 then ny1,ny2 = ny2,ny1 end

    nx1 = int(nx1) ; ny1 = int(ny1)
    nx2 = int(nx2) ; ny2 = int(ny2)
    z   = int(z)

    transformed_brush2(nil, info,
    {
      { x=nx2, y=ny1 },
      { x=nx2, y=ny2 },
      { x=nx1, y=ny2 },
      { x=nx1, y=ny1 },
    },
    -2000, z)
  end 

  ST.done = true
end


function Build_lift(S, side, lift_h)

  local tag = PLAN:alloc_tag()

  local kinds = {}

  for dir = 2,8,2 do
    local N = S:neighbor(dir)
    if N then
      local nz = N.floor_h or N.room.floor_h or lift_h
      if dir == 10-side then nz = S.conn.conn_h end

      if nz < lift_h-15 then
        kinds[dir] = 62
      else
        kinds[dir] = 88
      end
    end
  end

  local lift_coords = get_wall_coords(S, side, 128)

  lift_coords[1].line_kind = kinds[6]
  lift_coords[2].line_kind = kinds[8]
  lift_coords[3].line_kind = kinds[4]
  lift_coords[4].line_kind = kinds[2]

  lift_coords[1].line_tag = tag
  lift_coords[2].line_tag = tag
  lift_coords[3].line_tag = tag
  lift_coords[4].line_tag = tag

  transformed_brush2(nil,
  {
    t_face = { texture="STEP2" },
    b_face = { texture="STEP2" },
    w_face = { texture="SUPPORT2", peg=true },
    sec_tag = tag,
  },
  lift_coords, -2000, lift_h)

  local step_coords = get_wall_coords(S, 10-side, 128)

  transformed_brush2(nil,
  {
    t_face = { texture=S.room.combo.floor },
    b_face = { texture=S.room.combo.floor },
    w_face = { texture=S.room.combo.wall },
  },
  step_coords, -2000, S.conn.conn_h);
end


function mark_room_as_done(R)
  for sx = R.sx1,R.sx2 do for sy = R.sy1,R.sy2 do
    local S = SEEDS[sx][sy][1]
    
    if S.room == R then
      S.sides_only = true

---???      for dir = 2,8,2 do
---???        S.thick[dir] = 16
---???      end
    end
  end end
end


function Build_pillar(S, z1, z2, p_tex)
  
  local mx = int((S.x1 + S.x2)/2)
  local my = int((S.y1 + S.y2)/2)
  local mz = int((z1 + z2)/2)

  transformed_brush2(nil,
  {
    t_face = { texture="CEIL5_2" },
    b_face = { texture="CEIL5_2" },
    w_face = { texture=p_tex, x_offset=0, y_offset=0 },
  },
  {
    { x=mx+32, y=my-32 }, { x=mx+32, y=my+32 },
    { x=mx-32, y=my+32 }, { x=mx-32, y=my-32 },
  },
  -2000, 2000)

  for pass = 1,2 do
    transformed_brush2(nil,
    {
      t_face = { texture="CEIL5_2" },
      b_face = { texture="CEIL5_2" },
      w_face = { texture="METAL" },
    },
    {
      { x=mx+40, y=my-40 }, { x=mx+40, y=my+40 },
      { x=mx-40, y=my+40 }, { x=mx-40, y=my-40 },
    },
    sel(pass == 1, -2000, z2-32),
    sel(pass == 2,  2000, z1+32)
    )

    transformed_brush2(nil,
    {
      t_face = { texture="FLAT1" },
      b_face = { texture="FLAT1" },
      w_face = { texture="GRAY7" },
    },
    {
      { x=mx-40, y=my-56 },
      { x=mx+40, y=my-56 },
      { x=mx+56, y=my-40 },
      { x=mx+56, y=my+40 },
      { x=mx+40, y=my+56 },
      { x=mx-40, y=my+56 },
      { x=mx-56, y=my+40 },
      { x=mx-56, y=my-40 },
    },
    sel(pass == 1, -2000, z2-6),
    sel(pass == 2,  2000, z1+6)
    )
  end
end


function Build_exit_pillar(S, z1)

  local dir = 2  -- FIXME

  local DT, long = get_transform_for_seed_side(S, 10-dir)

  local mx = int((S.x1 + S.x2)/2)
  local my = int((S.y1 + S.y2)/2)

  transformed_brush2(nil,
  {
    t_face = { texture="FLAT14" },
    b_face = { texture="FLAT14" },
    w_face = { texture="SW1SKULL", peg=true, x_offset=0, y_offset=0 },
  },
  {
    { x=mx+32, y=my-32, line_kind=11 },
    { x=mx+32, y=my+32, line_kind=11 },
    { x=mx-32, y=my+32, line_kind=11 },
    { x=mx-32, y=my-32, line_kind=11 },
  },
  -2000, z1+128)


  local exit_info =
  {
    w_face = { texture="COMPSPAN" },
    t_face = { texture="CEIL5_1" },
    b_face = { texture="CEIL5_1" },
  }

  local exit_face = { texture="EXITSIGN", peg=true, x_offset=0, y_offset=0 }
 
  for pass=1,4 do
    DT.mirror_x = sel((pass % 2)==1, nil, long/2)
    DT.mirror_y = sel(pass >= 3,     nil, long/2)

    transformed_brush2(DT, exit_info,
    {
      { x=60+8,  y=60+24 },
      { x=60+0,  y=60+16, w_face=exit_face },
      { x=60+28, y=60+0  },
      { x=60+36, y=60+8  },
    },
    -2000, z1+16)
  end
end


function Build_small_switch(S, dir, f_h, info, tag)

  local DT, long = get_transform_for_seed_side(S, 10-dir)
  local deep = long

  local mx = int(long / 2)
  local my = int(deep / 2)


  local switch_info =
  {
    w_face = { texture=assert(info.skin.side_w) },
    t_face = { texture=assert(info.skin.switch_f) },
    b_face = { texture=assert(info.skin.switch_f) },
  }

  local switch_face = { texture=assert(info.skin.switch_w), peg=true, x_offset=info.skin.x_offset or 0, y_offset=info.skin.y_offset or 0 }

  transformed_brush2(DT, switch_info,
  {
    { x=mx-40, y=my-40 },
    { x=mx+40, y=my-40 },
    { x=mx+56, y=my-24 },
    { x=mx+56, y=my+24 },
    { x=mx+40, y=my+40 },
    { x=mx-40, y=my+40 },
    { x=mx-56, y=my+24 },
    { x=mx-56, y=my-24 },
  },
  -2000, f_h+16)

  transformed_brush2(DT, switch_info,
  {
    { x=mx+32, y=my-8 },
    { x=mx+32, y=my+8, w_face = switch_face, line_kind=assert(info.skin.line_kind), line_tag=tag },
    { x=mx-32, y=my+8 },
    { x=mx-32, y=my-8, w_face = switch_face, line_kind=assert(info.skin.line_kind), line_tag=tag },
  },
  -2000, f_h+16+64)

end


function Build_outdoor_exit_switch(S, dir, f_h)

  local DT, long = get_transform_for_seed_side(S, 10-dir)
  local deep = long

  local mx = int(long / 2)
  local my = int(deep / 2)


  local podium =
  {
    w_face = { texture="COMPSPAN" },
    t_face = { texture="CEIL5_1" },
    b_face = { texture="CEIL5_1" },
  }

  transformed_brush2(DT, podium,
  {
    { x=long-32, y=32 },
    { x=long-32, y=deep-32 },
    { x=32, y=deep-32 },
    { x=32, y=32 },
  },
  -2000, f_h+12)


  local switch_info =
  {
    w_face = { texture="SHAWN2" },
    t_face = { texture="FLAT23" },
    b_face = { texture="FLAT23" },
  }

  local switch_face = { texture="SW1COMM", peg=true, x_offset=0, y_offset=0 }

  transformed_brush2(DT, switch_info,
  {
    { x=mx-40, y=my-40 },
    { x=mx+40, y=my-40 },
    { x=mx+56, y=my-24 },
    { x=mx+56, y=my+24 },
    { x=mx+40, y=my+40 },
    { x=mx-40, y=my+40 },
    { x=mx-56, y=my+24 },
    { x=mx-56, y=my-24 },
  },
  -2000, f_h+16)

  transformed_brush2(DT, switch_info,
  {
    { x=mx+32, y=my-8 },
    { x=mx+32, y=my+8, w_face = switch_face, line_kind=11 },
    { x=mx-32, y=my+8 },
    { x=mx-32, y=my-8, w_face = switch_face, line_kind=11 },
  },
  -2000, f_h+16+64)


  local exit_info =
  {
    w_face = { texture="SHAWN2" },
    t_face = { texture="FLAT23" },
    b_face = { texture="FLAT23" },
  }

  local exit_face = { texture="EXITSIGN", peg=true, x_offset=0, y_offset=0 }
 
  for pass=1,4 do
    DT.mirror_x = sel((pass % 2)==1, nil, long/2)
    DT.mirror_y = sel(pass >= 3,     nil, deep/2)

    transformed_brush2(DT, exit_info,
    {
      { x=48+8,  y=48+24 },
      { x=48+0,  y=48+16, w_face=exit_face },
      { x=48+28, y=48+0  },
      { x=48+36, y=48+8  },
    },
    -2000, f_h+12+16)
  end
end


function Build_small_exit(R, item_name)

  assert(#R.conns == 1)

  local C = R.conns[1]
  local S = C:seed(R)
  local T = C:seed(C:neighbor(R))

  gui.debugf("Building small exit @ %s\n", S:tostr())

  local side = S.conn_dir

  local f_h = C.conn_h or T.floor_h or T.room.floor_h or 0
  local c_h = f_h + 128

  local w_tex = rand_element { "METAL2",  "STARTAN2", "STARG1",
                               "TEKWALL4","PIPEWAL2",
                               "TEKGREN1", "SPACEW2",  "STARBR2" }

  local c_tex = rand_element { "TLITE6_6", "TLITE6_5", "FLAT17",
                               "FLOOR1_7", "GRNLITE1", "CEIL4_3" }

  local f_tex = rand_element { "FLOOR0_3", "FLOOR5_2" }

  local inner_info =
  {
    w_face = { texture=w_tex },
    t_face = { texture=f_tex },
    b_face = { texture=c_tex },
  }

  local out_combo = T.room.combo

  if T.room.outdoor then
    out_combo = R.combo
  end

  local out_face = { texture=out_combo.wall }

  local out_info =
  {
    w_face = out_face,
    t_face = { texture=C.conn_ftex or f_tex },
    b_face = { texture=out_combo.ceil },
  }


  local DT, long, deep = get_transform_for_seed_side(S, side)
  local mx = int(long / 2)


  transformed_brush2(DT, out_info,
  {
    { x=long, y=0 },
    { x=long, y=48 },
    { x=0, y=48 },
    { x=0, y=0 },
  },
  -2000, f_h)

  transformed_brush2(DT, out_info,
  {
    { x=long, y=-24 },
    { x=long, y=48 },
    { x=0, y=48 },
    { x=0, y=-24 },
  },
  c_h, 2000)

  transformed_brush2(DT, inner_info,
  {
    { x=long, y=48 },
    { x=long, y=long },
    { x=0, y=long },
    { x=0, y=48 },
  },
  -2000, f_h)

  transformed_brush2(DT, inner_info,
  {
    { x=long, y=48 },
    { x=long, y=long },
    { x=0, y=long },
    { x=0, y=48 },
  },
  c_h, 2000)


  S.thick[side] = 80
  S.thick[10 - side] = 32

  S.thick[rotate_cw90(side)] = 16
  S.thick[rotate_ccw90(side)] = 16


  transformed_brush2(nil, inner_info, get_wall_coords(S, rotate_cw90(side)),  -2000, 2000)
  transformed_brush2(nil, inner_info, get_wall_coords(S, rotate_ccw90(side)), -2000, 2000)


  -- make door

  local door_info =
  {
    w_face = { texture="EXITDOOR", peg=true, x_offset=0, y_offset=0 },
    t_face = { texture="FLAT5_5" },
    b_face = { texture="FLAT5_5" },
    flag_door = true,
  }

  transformed_brush2(DT, door_info,
  {
    { x=mx+32, y=48, line_kind=1 },
    { x=mx+32, y=64, line_kind=1 },
    { x=mx-32, y=64, line_kind=1 },
    { x=mx-32, y=48, line_kind=1 },
  },
  f_h+36, 2000)

  inner_info.b_face = { texture="FLAT1" }

  transformed_brush2(DT, inner_info,
  {
    { x=mx+32, y=32 },
    { x=mx+32, y=80 },
    { x=mx-32, y=80 },
    { x=mx-32, y=32, w_face=out_face },
  },
  f_h+72, 2000)

  local exit_info =
  {
    w_face = { texture="SHAWN2" },
    t_face = { texture="FLAT23" },
    b_face = { texture="FLAT23" },
  }

  local exit_face = { texture="EXITSIGN", x_offset=0, y_offset=0 }

  local key_tex = "LITE5"

  if C.lock then
    key_tex = "DOORBLU" -- !!!!!! FIXME
  end

  for pass = 1,2 do
    if pass == 2 then DT.mirror_x = mx end

    transformed_brush2(DT, inner_info,
    {
      { x=0,     y=-24, w_face=out_face },
      { x=mx-96, y=-24, w_face=out_face },
      { x=mx-32, y=32,  w_face={ texture=key_tex, x_offset=0, y_offset=0 } },
      { x=mx-32, y=48,  w_face={ texture="DOORTRAK", peg=true } },
      { x=mx-32, y=64,  w_face={ texture=key_tex, x_offset=0, y_offset=0 } },
      { x=mx-32, y=80  },
      { x=0,     y=80  },
    },
    -2000, 2000)

-- [[
    transformed_brush2(DT, exit_info,
    {
      { x=mx-68, y= -8 },
      { x=mx-60, y=-16, w_face=exit_face },
      { x=mx-32, y=  0 },
      { x=mx-40, y=  8 },
    },
    c_h-16, 2000)
--]]
  end


  -- make switch

  local sw_tex = rand_element { "SW1METAL", "SW1LION", "SW1BRN2", "SW1BRNGN",
                                "SW1GRAY",  "SW1MOD1", "SW1SLAD", "SW1STRTN",
                                "SW1TEK",   "SW1STON1" }

  local WT
  WT, long, deep = get_transform_for_seed_side(S, 10-side)

  mx = int(long / 2)
  local swit_W = 64


  transformed_brush2(WT, inner_info,
  {
    { x=long, y=0 },
    { x=long, y=16 },
    { x=mx+swit_W/2+8, y=16, w_face={ texture="DOORSTOP", x_offset=0 } },
    { x=mx+swit_W/2,   y=16, w_face={ texture=sw_tex,     x_offset=0, y_offset=0 }, line_kind=11 },
    { x=mx-swit_W/2,   y=16, w_face={ texture="DOORSTOP", x_offset=0 } },
    { x=mx-swit_W/2-8, y=16 },
    { x=0, y=16 },
    { x=0, y=0 },
  },
  -2000, 2000)


  C.already_made_lock = true

  mark_room_as_done(R)


  if item_name then
    gui.add_entity(DT.dx + long/2, DT.dy + long/2, f_h+25, { name=item_name })
  end
end


function Build_wall(S, side, f_tex, w_tex)
  transformed_brush2(nil,
  {
    t_face = { texture=f_tex },
    b_face = { texture=f_tex },
    w_face = { texture=w_tex },
  },
  get_wall_coords(S, side),
  -2000, 4000)
end


function Build_fence(S, side, fence_h, f_tex, w_tex)
  transformed_brush2(nil,
  {
    t_face = { texture=f_tex },
    b_face = { texture=f_tex },
    w_face = { texture=w_tex },
  },
  get_wall_coords(S, side),
  -2000, fence_h)
end


function Build_window(S, side, width, z1, z2, f_tex, w_tex)

  local wall_info =
  {
    t_face = { texture=f_tex },
    b_face = { texture=f_tex },
    w_face = { texture=w_tex },
  }

  local side_face = { texture="DOORSTOP" }


  local T, long, deep = get_transform_for_seed_side(S, side)

  local mx = int(long/2)

  transformed_brush2(T, wall_info,
  {
    { x=mx+width/2, y=0 },
    { x=mx+width/2, y=deep },
    { x=mx-width/2, y=deep },
    { x=mx-width/2, y=0 },
  },
  -2000, z1)

  transformed_brush2(T, wall_info,
  {
    { x=mx+width/2, y=0 },
    { x=mx+width/2, y=deep },
    { x=mx-width/2, y=deep },
    { x=mx-width/2, y=0 },
  },
  z2, 2000)


  for pass = 1,2 do
    if pass == 2 then T.mirror_x = mx end

    transformed_brush2(T, wall_info,
    {
      { x=mx-width/2, y=0, w_face = side_face },
      { x=mx-width/2, y=deep },
      { x=0, y=deep },
      { x=0, y=0 },
    },
    -2000, 2000)
  end
end


function Build_picture(S, side, width, z1, z2, f_tex, w_tex, pic)

  local T, long, deep = get_transform_for_seed_side(S, side)

  local wall_info =
  {
    t_face = { texture=f_tex },
    b_face = { texture=f_tex },
    w_face = { texture=w_tex },
  }

  local pic_info =
  {
    t_face = { texture=f_tex },
    b_face = { texture=f_tex },
    w_face = { texture=pic, x_offset=0, y_offset=0 },
  }


  local mx = int(long/2)
  local my = int(deep/2)

  local y2 = my+4

  transformed_brush2(T, wall_info,
  {
    { x=long, y=0 },
    { x=long, y=my-4 },
    { x=0, y=my-4 },
    { x=0, y=0 },
  },
  -2000, 2000)

  transformed_brush2(T, pic_info,
  {
    { x=long-4, y=my-4 },
    { x=long-4, y=my+4 },
    { x=4, y=my+4 },
    { x=4, y=my-4 },
  },
  -2000, 2000)

  transformed_brush2(T, wall_info,
  {
    { x=mx-width/2, y=y2 },
    { x=mx-width/2, y=deep },
    { x=0, y=deep },
    { x=0, y=y2 },
  },
  -2000, 2000)

  transformed_brush2(T, wall_info,
  {
    { x=long, y=y2 },
    { x=long, y=deep },
    { x=mx+width/2, y=deep },
    { x=mx+width/2, y=y2 },
  },
  -2000, 2000)


  transformed_brush2(T, wall_info,
  {
    { x=mx+width/2, y=y2 },
    { x=mx+width/2, y=deep },
    { x=mx-width/2, y=deep },
    { x=mx-width/2, y=y2 },
  },
  -2000, z1)

  transformed_brush2(T, wall_info,
  {
    { x=mx+width/2, y=y2 },
    { x=mx+width/2, y=deep },
    { x=mx-width/2, y=deep },
    { x=mx-width/2, y=y2 },
  },
  z2, 2000)
end


function Build_pedestal(S, z1, top_tex)
  local mx = int((S.x1+S.x2) / 2)
  local my = int((S.y1+S.y2) / 2)

  transformed_brush2(nil,
  {
    t_face = { texture=top_tex },
    b_face = { texture=top_tex },
    w_face = { texture="BLAKWAL2", peg=true, y_offset=0 },
  },
  {
    { x=mx+32, y=my-32 }, { x=mx+32, y=my+32 },
    { x=mx-32, y=my+32 }, { x=mx-32, y=my-32 },
  },
  -2000, z1+8)
end

function Build_raising_start(S, face_dir, z1, combo)

  local info =
  {
    t_face = { texture=combo.floor },
    b_face = { texture=combo.floor },
    w_face = { texture=combo.wall  },
  }

  local sw_tex = "SW1COMP"
  local sw_face =
  {
    texture=sw_tex,
    peg=true,
    x_offset=0,
    y_offset=0,
  }

  local tag = PLAN:alloc_tag()

  for side = 2,8,2 do
    local T, long, deep = get_transform_for_seed_side(S, side, 48)

    local mx = int(long / 2)

    if side == face_dir then
      transformed_brush2(T, info,
      {
        { x=long,  y=0 },
        { x=long,  y=deep },
        { x=mx+32, y=deep, w_face=sw_face, line_kind=18, line_tag=tag },
        { x=mx-32, y=deep },
        { x=0,     y=deep },
        { x=0,     y=0 },
      },
      -2000, z1)
    
    else
      transformed_brush2(T, info,
      {
        { x=long, y=0 },
        { x=long, y=deep },
        { x=0,    y=deep },
        { x=0,    y=0 },
      },
      -2000, z1)
    end
  end

  z1 = z1 - 128

  local T, long, deep = get_transform_for_seed_center(S)

  info.sec_tag = tag

  transformed_brush2(T, info,
  {
    { x=long, y=0,   },
    { x=long, y=deep },
    { x=0,    y=deep },
    { x=0,    y=0,   },
  },
  -2000, z1)
end


function Build_popup_trap(S, z1, skin, combo)

  local info =
  {
    t_face = { texture=combo.floor },
    b_face = { texture=combo.floor },
    w_face = { texture=combo.wall  },
  }

  for side = 2,8,2 do
    S.thick[side] = S.thick[side] + 4

    local T, long, deep = get_transform_for_seed_side(S, side)

    transformed_brush2(T, info,
    {
      { x=long, y=0 },
      { x=long, y=deep, w_face={ texture="-" } },
      { x=0,    y=deep },
      { x=0,    y=0 },
    },
    -2000, z1)
  end

  z1 = z1 - 384

  local tag = PLAN:alloc_tag()

  local T, long, deep = get_transform_for_seed_center(S)

  info.sec_tag = tag

  transformed_brush2(T, info,
  {
    { x=long, y=0,    line_kind=19, line_tag=tag },
    { x=long, y=deep, line_kind=19, line_tag=tag },
    { x=0,    y=deep, line_kind=19, line_tag=tag },
    { x=0,    y=0,    line_kind=19, line_tag=tag },
  },
  -2000, z1)

  gui.add_entity(T.dx + long/2, T.dy + deep/2, z1+25, { name="66" })
end


function Build_stairwell(R, wall_info, flat_info)

  local function build_stairwell_90(R)
    assert(R.conns)

    local A = R.conns[1]
    local B = R.conns[2]

    assert(A and B)

    if A.dir == 2 or A.dir == 8 then
      B, A = A, B
    end

    assert(A.dir == 4 or A.dir == 6)
    assert(B.dir == 2 or B.dir == 8)

    local AS = A:seed(R)
    local BS = B:seed(R)

    -- room size
    local BL = SEEDS[R.sx1][R.sy1][1]
    local TR = SEEDS[R.sx2][R.sy2][1]

    local rx1, ry1 = BL.x1, BL.y1
    local rx2, ry2 = TR.x2, TR.y2
    local rw, rh   = rx2 - rx1, ry2 - ry1

    local ax  = sel(AS.conn_dir == 4, rx1, rx2)
    local ay1 = AS.y1
    local ay2 = AS.y2

    local by  = sel(BS.conn_dir == 2, ry1, ry2)
    local bx1 = BS.x1
    local bx2 = BS.x2

    local dx1, dx2
    local dy1, dy2

    if AS.conn_dir == 4 then
      dx1, dx2 = bx1 - ax, bx2 - ax
---## if dx1 < MARG then dx1 = MARG end
    else
      dx1, dx2 = bx2 - ax, bx1 - ax
    end

    if BS.conn_dir == 2 then
      dy1, dy2 = ay1 - by, ay2 - by
    else
      dy1, dy2 = ay2 - by, ay1 - by
    end

gui.printf("A @ (%d,%d/%d)  B @ (%d/%d,%d)\n", ax,ay1,ay2, bx1,bx2,by)
gui.printf("DX %d,%d  DY %d,%d\n", dx1,dx2, dy1,dy2)


    -- when space is tight, need to narrow the hallway
    -- (so there is space for the wall brushes)
    local MARG = 64

    if math.abs(dx1) < MARG then dx1 = sel(dx2 < 0, -MARG, MARG) end
    if math.abs(dy1) < MARG then dy1 = sel(dy2 < 0, -MARG, MARG) end

    if math.abs(dx2) > rw-MARG then dx2 = sel(dx2 < 0, -(rw-MARG), rw-MARG) end
    if math.abs(dy2) > rh-MARG then dy2 = sel(dy2 < 0, -(rh-MARG), rh-MARG) end

    assert(math.abs(dx1) < math.abs(dx2))
    assert(math.abs(dy1) < math.abs(dy2))

    local dx0 = sel(dx2 < 0, -32, 32)
    local dy0 = sel(dy2 < 0, -32, 32)

    local dx3 = dx2 + sel(dx2 < 0, -32, 32)
    local dy3 = dy2 + sel(dy2 < 0, -32, 32)


    -- FIXME: need brushes to fill space at sides of each doorway

    local x_h = B.conn_h or 0  -- FIXME: if steep, offset both by 16
    local y_h = A.conn_h or 0

    local steps = int(math.abs(x_h - y_h) / 16)
    if steps < 5 then steps = 5 end

    Build_curved_hall(steps, ax, by,
                      dx0, dx1, dx2, dx3,
                      dy0, dy1, dy2, dy3,
                      x_h, y_h, 128,
                      wall_info, flat_info, flat_info)
  end

  local function build_stairwell_180(R)
    local A = R.conns[1]
    local B = R.conns[2]

    -- require 180 degrees
    local AS = A:seed(R)
    local BS = B:seed(R)

    -- swap so that A has lowest coords
    if ((AS.conn_dir == 2 or AS.conn_dir == 8) and BS.x1 < AS.x1) or
       ((AS.conn_dir == 4 or AS.conn_dir == 6) and BS.y1 < AS.y1)
    then
      A,  B  = B,  A
      AS, BS = BS, AS
    end

    -- room size
    local BL = SEEDS[R.sx1][R.sy1][1]
    local TR = SEEDS[R.sx2][R.sy2][1]

    local rx1, ry1 = BL.x1, BL.y1
    local rx2, ry2 = TR.x2, TR.y2
    local rw, rh   = rx2 - rx1, ry2 - ry1

    local corn_x = (AS.x2 + BS.x1) / 2
    local corn_y = (AS.y2 + BS.y1) / 2

        if AS.conn_dir == 2 then corn_y = ry1
    elseif AS.conn_dir == 8 then corn_y = ry2
    elseif AS.conn_dir == 4 then corn_x = rx1
    elseif AS.conn_dir == 6 then corn_x = rx2
    else
      error("Bad/missing conn_dir for stairwell!")
    end

    local info =
    {
      t_face = { texture="FLOOR0_1" },
      b_face = { texture="FLOOR0_1" },
      w_face = { texture="STARGR1" },
    }

    local h1 = A.conn_h or 0
    local h3 = B.conn_h or 0
    local h2 = (h1 + h3) / 2

    local steps = int(math.abs(h2 - h1) / 16)
    if steps < 6 then steps = 6 end

    if AS.conn_dir == 2 or AS.conn_dir == 8 then

      local dx0 = corn_x - AS.x2 + 16
      local dx3 = corn_x - AS.x1 - 16
      local dx1 = dx0 + 32
      local dx2 = dx3 - 32

      local dy0 = 24
      local dy3 = ry2 - ry1 - 24
      local dy2 = dy3 - 24
      local dy1 = dy2 - 136

      if AS.conn_dir == 8 then
        dy0 = -dy0
        dy1 = -dy1
        dy2 = -dy2
        dy3 = -dy3
      end

      -- left side
      Build_curved_hall(steps, corn_x, corn_y,
                        -dx0, -dx1, -dx2, -dx3,
                        dy0, dy1, dy2, dy3,
                        h1, h2, 128,
                        wall_info, flat_info, flat_info)

      -- right side
      Build_curved_hall(steps, corn_x, corn_y,
                        dx0, dx1, dx2, dx3,
                        dy0, dy1, dy2, dy3,
                        h3, h2, 128,
                        wall_info, flat_info, flat_info)
    else
      local dy0 = corn_y - AS.y2 + 16
      local dy3 = corn_y - AS.y1 - 16
      local dy1 = dy0 + 32
      local dy2 = dy3 - 32

      local dx0 = 24
      local dx3 = rx2 - rx1 - 24
      local dx2 = dx3 - 24
      local dx1 = dx2 - 136

      if AS.conn_dir == 6 then
        dx0 = -dx0
        dx1 = -dx1
        dx2 = -dx2
        dx3 = -dx3
      end

      -- bottom section
      Build_curved_hall(steps, corn_x, corn_y,
                        dx0, dx1, dx2, dx3,
                        -dy0, -dy1, -dy2, -dy3,
                        h2, h1, 128,
                        wall_info, flat_info, flat_info)

      -- top section
      Build_curved_hall(steps, corn_x, corn_y,
                        dx0, dx1, dx2, dx3,
                        dy0, dy1, dy2, dy3,
                        h2, h3, 128,
                        wall_info, flat_info, flat_info)
    end
  end

  local function build_stairwell_0(R)
    local A = R.conns[1]
    local B = R.conns[2]

    local AS = A:seed(R)
    local BS = B:seed(R)

    -- swap so that A has lowest coords
    if ((AS.conn_dir == 2 or AS.conn_dir == 8) and BS.sx < AS.sx) or
       ((AS.conn_dir == 4 or AS.conn_dir == 6) and BS.sy < AS.sy)
    then
      A,  B  = B,  A
      AS, BS = BS, AS
    end

    -- room size
    local BL = SEEDS[R.sx1][R.sy1][1]
    local TR = SEEDS[R.sx2][R.sy2][1]

    local rx1, ry1 = BL.x1, BL.y1
    local rx2, ry2 = TR.x2, TR.y2
    local rw, rh   = rx2 - rx1, ry2 - ry1


    local h1 = A.conn_h or 0
    local h3 = B.conn_h or 0
    local h2 = (h1 + h3) / 2

    local steps = int(math.abs(h2 - h1) / 16)
    if steps < 5 then steps = 5 end


    if AS.conn_dir == 2 or AS.conn_dir == 8 then

      local corn_x = (AS.x2 + BS.x1) / 2
      local corn_y = sel(AS.conn_dir == 2, ry1, ry2)

      local dy1 = (ry2 - ry1) / 2 - 80
      local dy2 = (ry2 - ry1) / 2 + 80
      local dy0 = dy1 - 24
      local dy3 = dy2 + 24

      local dx0 = corn_x - AS.x2 + 16
      local dx3 = corn_x - AS.x1 - 16
      local dx1 = dx0 + 32
      local dx2 = dx3 - 32

      if AS.conn_dir == 8 then
        dy0 = -dy0
        dy1 = -dy1
        dy2 = -dy2
        dy3 = -dy3
      end

      -- left side
      Build_curved_hall(steps, corn_x, corn_y,
                        -dx0, -dx1, -dx2, -dx3,
                        dy0, dy1, dy2, dy3,
                        h1, h2, 128,
                        wall_info, flat_info, flat_info)

      -- right side
      corn_y = (ry1 + ry2) - corn_y

      local dx0 = BS.x1 - corn_x + 16
      local dx3 = BS.x2 - corn_x - 16
      local dx1 = dx0 + 32
      local dx2 = dx3 - 32

      Build_curved_hall(steps, corn_x, corn_y,
                        dx0, dx1, dx2, dx3,
                        -dy0, -dy1, -dy2, -dy3,
                        h3, h2, 128,
                        wall_info, flat_info, flat_info)

    else
      local corn_y = (AS.y2 + BS.y1) / 2
      local corn_x = sel(AS.conn_dir == 4, rx1, rx2)

      local dx1 = (rx2 - rx1) / 2 - 80
      local dx2 = (rx2 - rx1) / 2 + 80
      local dx0 = dx1 - 24
      local dx3 = dx2 + 24

      local dy0 = corn_y - AS.y2 + 16
      local dy3 = corn_y - AS.y1 - 16
      local dy1 = dy0 + 32
      local dy2 = dy3 - 32

      if AS.conn_dir == 6 then
        dx0 = -dx0
        dx1 = -dx1
        dx2 = -dx2
        dx3 = -dx3
      end

      -- bottom section
      Build_curved_hall(steps, corn_x, corn_y,
                        dx0, dx1, dx2, dx3,
                        -dy0, -dy1, -dy2, -dy3,
                        h2, h1, 128,
                        wall_info, flat_info, flat_info)

      -- top section
      corn_x = (rx1 + rx2) - corn_x

      local dy0 = BS.y1 - corn_y + 16
      local dy3 = BS.y2 - corn_y - 16
      local dy1 = dy0 + 32
      local dy2 = dy3 - 32

      Build_curved_hall(steps, corn_x, corn_y,
                        -dx0, -dx1, -dx2, -dx3,
                        dy0, dy1, dy2, dy3,
                        h2, h3, 128,
                        wall_info, flat_info, flat_info)
    end
  end

  local function build_stairwell_straight(R)
    local A = R.conns[1]
    local B = R.conns[2]

    local AS = A:seed(R)
    local BS = B:seed(R)

    -- swap so that A has lowest coords
    if ((AS.conn_dir == 2 or AS.conn_dir == 8) and BS.sy < AS.sy) or
       ((AS.conn_dir == 4 or AS.conn_dir == 6) and BS.sx < AS.sx)
    then
      A,  B  = B,  A
      AS, BS = BS, AS
    end

    local x1 = math.min(AS.x1, BS.x1)
    local x2 = math.max(AS.x2, BS.x2)

    local y1 = math.min(AS.y1, BS.y1)
    local y2 = math.max(AS.y2, BS.y2)

    local x_diff = x2 - x1
    local y_diff = y2 - y1

    local function step_coords(p0, p1, side0, side1)
      local cx, cy, fx, fy

      if AS.conn_dir == 2 or AS.conn_dir == 8 then
        cx = int(x1 + x_diff * side0)
        fx = int(x1 + x_diff * side1)
        cy = int(y1 + y_diff * p0)
        fy = int(y1 + y_diff * p1)
      else
        cx = int(x1 + x_diff * p0)
        fx = int(x1 + x_diff * p1)
        cy = int(y1 + y_diff * side0)
        fy = int(y1 + y_diff * side1)
      end

      return
      {
        { x=fx, y=cy },
        { x=fx, y=fy },
        { x=cx, y=fy },
        { x=cx, y=cy },
      }
    end

    local h1 = A.conn_h or 0
    local h2 = B.conn_h or 0

    local gap_h = 128

    local steps = int(math.abs(h2 - h1) / 16)
    if steps < 5 then steps = 5 end

    for i = 1,steps do
      local p0 = (i-1)/steps
      local p1 = (i  )/steps

      local f_h = h1 + (h2 - h1) * (i-1) / (steps-1)
      local c_h = f_h + gap_h

      transformed_brush2(nil, wall_info, step_coords(p0,p1, 0/6, 1/6), -2000,2000)
      transformed_brush2(nil, wall_info, step_coords(p0,p1, 5/6, 6/6), -2000,2000)

      local coords = step_coords(p0,p1, 1/6, 5/6)

      transformed_brush2(nil, flat_info, coords, -2000,f_h)
      transformed_brush2(nil, flat_info, coords,  c_h,2000)
    end
  end


  ---| build_stairwell |--

  assert(R.conns)

  local A = R.conns[1]
  local B = R.conns[2]
  assert(A and B)

  local AS = A:seed(R)
  local BS = B:seed(R)
  assert(AS and BS)

  if is_perpendicular(AS.conn_dir, BS.conn_dir) then
    build_stairwell_90(R)

  elseif AS.conn_dir == BS.conn_dir then
    build_stairwell_180(R)

  else
    assert(AS.conn_dir == 10-BS.conn_dir)

    -- check for misalignment
    local aligned = false
    if AS.conn_dir == 2 or AS.conn_dir == 8 then
      if AS.sx == BS.sx then aligned = true end
    else
      if AS.sy == BS.sy then aligned = true end
    end

    if aligned then
      build_stairwell_straight(R)
    else
      build_stairwell_0(R)
    end
  end


  mark_room_as_done(R)
end


---==========================================================---


function Builder_dummy()

  gui.add_brush(
  {
    t_face = { texture="e1u1/floor3_3" },
    b_face = { texture="e1u1/floor3_3" },
    w_face = { texture="e1u1/floor3_3" },
  },
  {
    { x=256, y=128 },
    { x=256, y=384 },
    { x=0, y=384 },
    { x=0, y=128 },
  },
  -24, 0)

  gui.add_brush(
  {
    t_face = { texture="e1u1/grnx2_3" },
    b_face = { texture="e1u1/grnx2_3" },
    w_face = { texture="e1u1/grnx2_3" },
  },
  {
    { x=256, y=128 },
    { x=256, y=384 },
    { x=0, y=384 },
    { x=0, y=128 },
  },
  192, 208)

  if false then
    gui.add_brush(
    {
      t_face = { texture="e1u1/grnx2_5" },
      b_face = { texture="e1u1/grnx2_5" },
      w_face = { texture="e1u1/grnx2_5" },
    },
    {
      { x=136, y=160 },
      { x=136, y=200 },
      { x=120, y=200 },
      { x=120, y=160 },
    },
    -2000, 4000)

    gui.add_brush(
    {
      t_face = { texture="e1u1/grnx2_3" },
      b_face = { texture="e1u1/grnx2_3" },
      w_face = { texture="e1u1/grnx2_3" },
    },
    {
      { x=136, y=128 },
      { x=136, y=160 },
      { x=120, y=160 },
      { x=120, y=128 },
    },
    -2000, 4000)
  end

  gui.add_brush(
  {
    t_face = { texture="e1u1/wslt1_1" },
    b_face = { texture="e1u1/wslt1_1" },
    w_face = { texture="e1u1/wslt1_1" },
  },
  {
    { x=32, y=128 },
    { x=32, y=384 },
    { x=0, y=384 },
    { x=0, y=128 },
  },
  0, 192)

  gui.add_brush(
  {
    t_face = { texture="e1u1/wslt1_2" },
    b_face = { texture="e1u1/wslt1_2" },
    w_face = { texture="e1u1/wslt1_2" },
  },
  {
    { x=256, y=128 },
    { x=256, y=384 },
    { x=224, y=384 },
    { x=224, y=128 },
  },
  0, 192)

  gui.add_brush(
  {
    t_face = { texture="e1u1/wslt1_3" },
    b_face = { texture="e1u1/wslt1_3" },
    w_face = { texture="e1u1/wslt1_3" },
  },
  {
    { x=256, y=128 },
    { x=256, y=144 },
    { x=0,   y=144 },
    { x=0,   y=128 },
  },
  0, 192)

  gui.add_brush(
  {
    t_face = { texture="e1u1/wslt1_4" },
    b_face = { texture="e1u1/wslt1_4" },
    w_face = { texture="e1u1/wslt1_4" },
  },
  {
    { x=256, y=370 },
    { x=256, y=384 },
    { x=0,   y=384 },
    { x=0,   y=370 },
  },
  0, 192)

  gui.add_entity(64, 256, 64, { name="info_player_start" })
end

