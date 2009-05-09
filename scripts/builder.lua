----------------------------------------------------------------
--  BUILDER
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2009 Andrew Apted
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

function transformed_coord(T, x, y)

  if not T then T = {} end

  -- handle mirroring first
  if T.mirror_x then
    x = T.mirror_x * 2 - x
  end

  if T.mirror_y then
    y = T.mirror_y * 2 - y
  end

  -- handle rotation
  if T.rotate and T.rotate ~= 0 then
    local cos_R = math.cos(T.rotate * math.pi / 180.0)
    local sin_R = math.sin(T.rotate * math.pi / 180.0)

    x, y = x * cos_R - y * sin_R, y * cos_R + x * sin_R
  end

  -- handle translation last
  if T.dx or T.dy then
    x = x + (T.dx or 0)
    y = y + (T.dy or 0)
  end

  return x, y
end


function transformed_brush(T, info, coords, z1, z2)

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


function psychedelic_mat(name)
  if GAME.sanity_map and GAME.sanity_map[name] then
    return GAME.sanity_map[name]
  end

  if not PLAN.psycho_map then
    -- build the psychedelic mapping --

    local m_before = {}
    local m_after  = {}

    for m,_ in pairs(GAME.materials) do
      if not (GAME.sanity_map and GAME.sanity_map[m]) and
         not (string.sub(m,1,3) == "SW1") and
         not (string.sub(m,1,3) == "BUT")
      then
        table.insert(m_before, m)
        table.insert(m_after,  m)
      end
    end

    rand_shuffle(m_after)

    PLAN.psycho_map = {}

    for i = 1,#m_before do
      PLAN.psycho_map[m_before[i]] = m_after[i]
    end
  end

  if PLAN.psycho_map[name] then
    return PLAN.psycho_map[name]
  end

  return name
end


function safe_get_mat(name)
  if OB_CONFIG.theme == "psycho" then
    name = psychedelic_mat(name)
  end

  local mat = GAME.materials[name]

  if not mat then
    gui.printf("\nLACKING MATERIAL : %s\n\n", name)
    mat = assert(GAME.materials[PARAMS.error_mat])

    -- prevent further messages
    GAME.materials[name] = mat
  end

  return mat
end

function get_mat(wall, floor, ceil)
  assert(wall)

  local w_mat = safe_get_mat(wall)

  local f_mat = w_mat
  if floor then
    f_mat = safe_get_mat(floor)
  end

  local c_mat = f_mat
  if ceil then
    c_mat = safe_get_mat(ceil)
  end

  return
  {
    w_face = { texture=w_mat[1] },
    t_face = { texture=f_mat[2] or f_mat[1] },
    b_face = { texture=c_mat[2] or c_mat[1] },
  }
end

function get_sky()
  return
  {
    kind = "sky",
    w_face = { texture=PARAMS.sky_tex },
    t_face = { texture=PARAMS.sky_flat or PARAMS.sky_tex },
    b_face = { texture=PARAMS.sky_flat or PARAMS.sky_tex, light=PLAN.sky_light or 0.75 },
  }
end

function add_pegging(info, x_offset, y_offset, peg)
  info.w_face.x_offset = x_offset or 0
  info.w_face.y_offset = y_offset or 0
  info.w_face.peg = sel(peg == nil, true, peg)

  return info
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

function diagonal_coords(side, x1,y1, x2,y2)
  if side == 9 then
    return
    {
      { x=x2, y=y1 },
      { x=x2, y=y2 },
      { x=x1, y=y2 },
    }
  elseif side == 7 then
    return
    {
      { x=x1, y=y2 },
      { x=x1, y=y1 },
      { x=x2, y=y2 },
    }
  elseif side == 3 then
    return
    {
      { x=x2, y=y1 },
      { x=x2, y=y2 },
      { x=x1, y=y1 },
    }
  elseif side == 1 then
    return
    {
      { x=x1, y=y2 },
      { x=x1, y=y1 },
      { x=x2, y=y1 },
    }
  else
    error("bad side for diagonal_coords: " .. tostring(side))
  end
end


function get_wall_coords(S, side, thick, pad)
  assert(side ~= 5)

  local x1, y1 = S.x1, S.y1
  local x2, y2 = S.x2, S.y2

  if side == 4 or side == 1 or side == 7 then
    x2 = x1 + (thick or S.thick[4])
    if pad then x1 = x1 + pad end
  end

  if side == 6 or side == 3 or side == 9 then
    x1 = x2 - (thick or S.thick[6])
    if pad then x2 = x2 - pad end
  end

  if side == 2 or side == 1 or side == 3 then
    y2 = y1 + (thick or S.thick[2])
    if pad then y1 = y1 + pad end
  end

  if side == 8 or side == 7 or side == 9 then
    y1 = y2 - (thick or S.thick[8])
    if pad then y2 = y2 - pad end
  end

  return rect_coords(x1,y1, x2,y2)
end


function Build_sky_fence(S, side, z, skin)
  
  local wall_info = get_mat(skin.fence_w, skin.fence_f)

  local sky_info = get_sky()

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

  transformed_brush(nil, wall_info,  w_coords, -EXTREME_H, z)
  transformed_brush(nil, wall2_info, s_coords, -EXTREME_H, PLAN.skyfence_h - 64)

  transformed_brush(nil, sky_info,  w_coords, SKY_H,   EXTREME_H)
  transformed_brush(nil, sky2_info, s_coords, SKY_H-2, EXTREME_H)
end


function Build_archway(S, side, z1, z2, skin)

  local N = S:neighbor(side)
  assert(N)


  local N_deep = N.thick[10-side]

  local T, long, deep = get_transform_for_seed_side(S, side)

  local mx = int(long / 2)

  local wall_info  = get_mat(skin.wall, skin.floor)
  local other_info = get_mat(skin.other or skin.wall)

  local frame_coords =
  {
    { x=long, y=-N_deep },
    { x=long, y=deep },
    { x=0,    y=deep },
    { x=0,    y=-N_deep, w_face = other_info.w_face },
  }

  transformed_brush(T, wall_info, frame_coords, z2, EXTREME_H)


  assert(deep > 17 or N_deep > 17)

  local break_info = wall_info
  if skin.other and skin.other ~= skin.wall then
    break_info = get_mat(skin.break_t)
  end

  for pass = 1,2 do
    if pass == 2 then T.mirror_x = mx end

    transformed_brush(T, wall_info,
    {
      { x=0,     y=-N_deep,    w_face = other_info.w_face },
      { x=24+16, y=-N_deep,    w_face = other_info.w_face },
      { x=36+16, y=-N_deep+16, w_face = break_info.w_face },
      { x=36+16, y=deep-16 },
      { x=24+16, y=deep },
      { x=0,     y=deep },
    },
    -EXTREME_H, EXTREME_H)
  end
end


function Build_door(S, side, z1, w_tex, o_tex, info, tag)

  local skin = assert(info.skin)

  tag2 = nil  -- FIXME !!!

  local N = S:neighbor(side)
  assert(N)


  local DY = 24

  local T, long, deep = get_transform_for_seed_side(S, side)

  local mx = int(long / 2)
  local my = 0

gui.debugf("INFO = %s\n", table_to_str(info,3))
  local door_h = info.skin.door_h or 112
  local door_info =
  {
    t_face = { texture=skin.door_c },
    b_face = { texture=assert(skin.door_c), light=0.7 },
    w_face = { texture=assert(skin.door_w), peg=true, x_offset=0, y_offset=0 },
--  w_face = { texture="PIPES", peg=true, x_offset=0, y_offset=0 },
    flag_door = true,
    sec_tag = tag,
  }

  local frame_info =
  {
    t_face = { texture=skin.frame_c or "FLAT18" },
    b_face = { texture=skin.frame_c or "FLAT18", light=0.7 },
    w_face = { texture=w_tex },
  }

  local step_info =
  {
    t_face = { texture=skin.step_f or "FLAT18" },
    b_face = { texture=skin.step_f or "FLAT18" },
    w_face = { texture=skin.step_w or "STEP4" },
  }

  local key_info =
  {
    t_face = { texture="FLAT18" },
    b_face = { texture="FLAT18" },
    w_face = { texture=assert(info.skin.key_w), x_offset=0, y_offset=0 },
  }

  transformed_brush(T, step_info,
  {
    { x=long, y=my-DY },
    { x=long, y=my+DY },
    { x=0,    y=my+DY },
    { x=0,    y=my-DY },
  },
  -EXTREME_H, z1+8)

  transformed_brush(T, frame_info,
  {
    { x=long, y=my-DY },
    { x=long, y=my+DY },
    { x=0,    y=my+DY },
    { x=0,    y=my-DY, w_face = {texture=o_tex} },
  },
  z1+8+door_h, EXTREME_H)

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

  gui.add_entity("func_door", 0, 0, 0,
                 { angle="180", sounds="2",
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

  gui.add_entity("func_door", 0, 0, 0,
                 { angle="0", sounds="2",
                   model=assert(m_ref)
                 })
else
  transformed_brush(T, door_info,
  {
    { x=mx+64, y=my-8, line_kind=KIND, line_tag=tag2 },
    { x=mx+64, y=my+8, line_kind=KIND, line_tag=tag2 },
    { x=mx-64, y=my+8, line_kind=KIND, line_tag=tag2 },
    { x=mx-64, y=my-8, line_kind=KIND, line_tag=tag2 },
  },
  z1+16, EXTREME_H)
end


  for pass = 1,2 do
    if pass == 2 then T.mirror_x = mx end

    transformed_brush(T, key_info,
    {
      { x=mx-64,    y=my-8, w_face={ texture="DOORTRAK", peg=true } },
      { x=mx-64,    y=my+8  },
      { x=mx-64-18, y=my+DY },
      { x=mx-64-18, y=my-DY },
    },
    -EXTREME_H, EXTREME_H)

    transformed_brush(T, frame_info,
    {
      { x=mx-64-18, y=my-DY },
      { x=mx-64-18, y=my+DY },
      { x=0,        y=my+DY },
      { x=0,        y=my-DY, w_face={ texture=o_tex } },
    },
    -EXTREME_H, EXTREME_H)
  end
end


function Build_lowering_bars(S, side, z1, skin, tag)

  local T, long, deep = get_transform_for_seed_side(S, side)

  local bar_w = 24
  local bar_tw = 6+bar_w+6

  local num_bars = int((long-16) / bar_tw)
  local side_gap = int((long-16 - num_bars * bar_tw) / 2)

  assert(num_bars >= 2)

  local bar_info = get_mat(skin.bar_w, skin.bar_f)

  add_pegging(bar_info, skin.x_offset, skin.y_offset)

  bar_info.sec_tag = tag

  local mx1 = 8 + side_gap + bar_w/2
  local mx2 = long - 8 - side_gap - bar_w/2

  local z_top = z1 + skin.bar_h
  if S.room.fence_h then
    z_top = math.max(z_top, S.room.fence_h + 16)
  end

  for i = 1,num_bars do
    local mx = mx1 + (mx2 - mx1) * (i-1) / (num_bars-1)
    local my = 0

    transformed_brush(T, bar_info,
    {
      { x=mx+bar_w/2, y=my-bar_w/2 },
      { x=mx+bar_w/2, y=my+bar_w/2 },
      { x=mx-bar_w/2, y=my+bar_w/2 },
      { x=mx-bar_w/2, y=my-bar_w/2 },
    },
    -EXTREME_H, z_top)
  end
end


function Build_ceil_light(S, z2, skin)
  assert(skin)
  
  local w = (skin.w or 64) / 2
  local h = (skin.h or 64) / 2

  local mx = int((S.x1 + S.x2)/2)
  local my = int((S.y1 + S.y2)/2)

  local light_info = get_mat(skin.lite_f)
  light_info.b_face.light = 0.90

  transformed_brush(nil, light_info,
  {
    { x = mx+w, y = my-h },
    { x = mx+w, y = my+h },
    { x = mx-w, y = my+h },
    { x = mx-w, y = my-h },
  },
  z2-12, EXTREME_H)


  local trim_info = get_mat(skin.trim)
  trim_info.b_face.light = 0.72

  transformed_brush(nil, trim_info,
  {
    { x = mx-w,     y = my-(h+8) },
    { x = mx-w,     y = my+(h+8) },
    { x = mx-(w+8), y = my+(h+8) },
    { x = mx-(w+8), y = my-(h+8) },
  },
  z2-16, EXTREME_H)

  transformed_brush(nil, trim_info,
  {
    { x = mx+(w+8), y = my-(h+8) },
    { x = mx+(w+8), y = my+(h+8) },
    { x = mx+w,     y = my+(h+8) },
    { x = mx+w,     y = my-(h+8) },
  },
  z2-16, EXTREME_H)

  transformed_brush(nil, trim_info,
  {
    { x = mx+(w+8), y = my-(h+8) },
    { x = mx+(w+8), y = my-h },
    { x = mx-(w+8), y = my-h },
    { x = mx-(w+8), y = my-(h+8) },
  },
  z2-16, EXTREME_H)

  transformed_brush(nil, trim_info,
  {
    { x = mx+(w+8), y = my+h },
    { x = mx+(w+8), y = my+(h+8) },
    { x = mx-(w+8), y = my+(h+8) },
    { x = mx-(w+8), y = my+h },
  },
  z2-16, EXTREME_H)
 

--[[ connecting spokes....

  transformed_brush(nil, trim_info,
  {
    { x = mx+4, y = my+40 },
    { x = mx+4, y = S.y2  },
    { x = mx-4, y = S.y2  },
    { x = mx-4, y = my+40 },
  },
  z2-10, EXTREME_H)

  transformed_brush(nil, trim_info,
  {
    { x = mx+4, y = S.y1  },
    { x = mx+4, y = my-40 },
    { x = mx-4, y = my-40 },
    { x = mx-4, y = S.y1  },
  },
  z2-10, EXTREME_H)

  transformed_brush(nil, trim_info,
  {
    { x = mx-40, y = my-4, },
    { x = mx-40, y = my+4, },
    { x = S.x1 , y = my+4, },
    { x = S.x1 , y = my-4, },
  },
  z2-10, EXTREME_H)

  transformed_brush(nil, trim_info,
  {
    { x = S.x2 , y = my-4, },
    { x = S.x2 , y = my+4, },
    { x = mx+40, y = my+4, },
    { x = mx+40, y = my-4, },
  },
  z2-10, EXTREME_H)
 
--]]
end


function Build_detailed_hall(S, side, z1, z2, skin)

  local function compat_neighbor(side)
    local N = S:neighbor(side)

    if not N or not N.room then return false end

    if N.room == S.room then return true end

    if N.room.kind == "hallway" then return true end

    return false
  end

  local function get_hall_coords(thickness, pad)

    ---### S.thick[side] = thickness

    local ox1, oy1, ox2, oy2 = S.x1,S.y1, S.x2,S.y2

    if (side == 4 or side == 6) then
      if compat_neighbor(2) then S.y1 = S.y1 - thickness end
      if compat_neighbor(8) then S.y2 = S.y2 + thickness end
    else
      if compat_neighbor(4) then S.x1 = S.x1 - thickness end
      if compat_neighbor(6) then S.x2 = S.x2 + thickness end
    end

    if compat_neighbor(side) then pad = 0 end

    local res = get_wall_coords(S, side, thickness, pad)

    S.x1,S.y1, S.x2,S.y2 = ox1, oy1, ox2, oy2
    
    return res
  end


  if PLAN.hall_trim then
    transformed_brush(nil, get_mat(skin.trim2),
        get_hall_coords(32, 8), -EXTREME_H, z1 + 32)

    transformed_brush(nil, get_mat(skin.trim2),
        get_hall_coords(32, 8), z2 - 32, EXTREME_H)
  end


  transformed_brush(nil, get_mat(skin.trim1),
      get_hall_coords(64, 8), -EXTREME_H, z1 + 6)

  transformed_brush(nil, get_mat(skin.trim1),
      get_hall_coords(64, 8), z2 - 6, EXTREME_H)


  transformed_brush(nil, get_mat(skin.wall),
      get_hall_coords(24, 0), -EXTREME_H, EXTREME_H)


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


  local info = get_mat("SHAWN2")

  transformed_brush(nil, info, get_hall_coords(24), -EXTREME_H, EXTREME_H)

  transformed_brush(nil, info, get_hall_coords(32), -EXTREME_H, z1 + 32)
  transformed_brush(nil, info, get_hall_coords(32), z2 - 32, EXTREME_H)

  transformed_brush(nil, info, get_hall_coords(48), -EXTREME_H, z1 + 18)
  transformed_brush(nil, info, get_hall_coords(48), z2 - 18, EXTREME_H)

  transformed_brush(nil, info, get_hall_coords(64), -EXTREME_H, z1 + 6)
  transformed_brush(nil, info, get_hall_coords(64), z2 - 6, EXTREME_H)

end


function Build_diagonal(S, side, info, floor_h, ceil_h)

  -- floor_h and ceil_h are usually absent, which makes a
  -- totally solid diagonal piece.  One of them can be given
  -- but not both to make a diagonal floor or ceiling piece.
  assert(not (floor_h and ceil_h))
  
  local function get_thick(wsd)
    if S.border[wsd].kind == "wall" then
      return S.thick[wsd]
    end

    return 0
  end

  local x1 = S.x1 + get_thick(4)
  local y1 = S.y1 + get_thick(2)

  local x2 = S.x2 - get_thick(6)
  local y2 = S.y2 - get_thick(8)


  transformed_brush(nil, info,
      diagonal_coords(side,x1,y1,x2,y2),
      ceil_h or -EXTREME_H, floor_h or EXTREME_H)
end


function Build_arrow(S, dir, f_h)
 
  local mx = int((S.x1 + S.x2)/2)
  local my = int((S.y1 + S.y2)/2)

  local dx, dy = dir_to_delta(dir)
  local ax, ay = dir_to_delta(rotate_cw90(dir))

  transformed_brush(nil, get_mat("FWATER1"),
  {
    { x = mx - ax*20,  y = my - ay * 20  },
    { x = mx + ax*20,  y = my + ay * 20  },
    { x = mx + dx*100, y = my + dy * 100 },
  },
  -EXTREME_H, f_h + 8)
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

    transformed_brush(nil, wall_info, arc_coords(p0,p1, dx0,dx1, dy0,dy1), -EXTREME_H,EXTREME_H)
    transformed_brush(nil, wall_info, arc_coords(p0,p1, dx2,dx3, dy2,dy3), -EXTREME_H,EXTREME_H)

    local coords = arc_coords(p0,p1, dx1,dx2, dy1,dy2)

    transformed_brush(nil, floor_info, coords, -EXTREME_H, f_h)
    transformed_brush(nil, ceil_info,  coords, c_h, EXTREME_H)
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

    transformed_brush(nil, skin,
    {
      { x=bx4, y=y1 },
      { x=tx4, y=y2 },
      { x=tx3, y=y2 },
      { x=bx3, y=y1 },
    },
    -EXTREME_H, z);
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

    transformed_brush(nil, skin,
    {
      { x=x2, y=ry3 },
      { x=x2, y=ry4 },
      { x=x1, y=ly4 },
      { x=x1, y=ly3 },
    },
    -EXTREME_H, z);
  end
end


function Build_niche_stair(S, skin, skin2)

  local step_info = get_mat(skin.side_w, skin.top_f)

  local front_info = get_mat(skin.step_w)
  add_pegging(front_info)

  for side = 2,8,2 do
    S.thick[side] = 64
  end

  local T, long = get_transform_for_seed_side(S, S.stair_dir)
  local deep = long

  local z1 = S.stair_z2
  local z2 = S.stair_z1

  local niche_info = get_mat(skin2.wall, skin2.floor)

  local W  = sel(z1 > z2, 48, 24)
  local HB = sel(z1 > z2, 96, 64)
  local HF = 40

  transformed_brush(T, niche_info,
    rect_coords(0, 0, W, deep), -EXTREME_H, z2)

  transformed_brush(T, niche_info,
    rect_coords(long-W,0, long,deep), -EXTREME_H, z2)

  transformed_brush(T, niche_info,
    rect_coords(long-W,deep-HB, long,deep), -EXTREME_H, z2)


  if S.stair_z1 > S.stair_z2 then
    local f_tex = S.f_tex or S.room.combo.floor
    local w_tex = S.w_tex or S.room.combo.wall

    local S2 = S:neighbor(S.stair_dir)
    if S2 and S2.room == S.room and S2.kind == "walk" and S2.f_tex then
      f_tex = S2.f_tex
    end

    transformed_brush(T, get_mat(w_tex, f_tex),
      rect_coords(W,0, long-W,HF), -EXTREME_H, z1)
  else
    HF = 0
  end


  local steps = int(math.abs(z2 - z1) / 15 + 0.9)

  if steps < 2 then steps = 2 end

  for i = 0,steps-1 do 
    local z = z1 + (z2 - z1) * (i+1) / (steps+1)

    local by = int(HF + (deep-HF-HB) * (i)   / steps)
    local ty = int(HF + (deep-HF-HB) * (i+1) / steps)

    transformed_brush(T, step_info,
    {
      { x=long-W, y=by },
      { x=long-W, y=ty, w_face = front_info.wface },
      { x=     W, y=ty },
      { x=     W, y=by, w_face = front_info.wface },
    },
    -EXTREME_H, int(z));
  end
end


function Build_tall_curved_stair(S, skin, x_side,y_side, x_h,y_h)
  assert(x_h and y_h)

  local step_info = get_mat(skin.step_w, skin.top_f)
  add_pegging(step_info)

  local diff_h = math.abs(y_h - x_h)
  local steps  = int(diff_h / 14 + 0.9)

  if steps < 4 then
    steps = 4
  end

  -- make sure there is a visible step at the bottom
  if x_h+24 < y_h then
    x_h = x_h + diff_h / (steps+2)
    y_h = y_h - diff_h / (steps+2)
  elseif y_h+24 < x_h then
    y_h = y_h + diff_h / (steps+2)
    x_h = x_h - diff_h / (steps+2)
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

  local info = get_mat(w_tex)

  Build_curved_hall(steps, corn_x, corn_y,
                    dx0, dx1, dx2, dx3,
                    dy0, dy1, dy2, dy3,
                    y_h, x_h, 256,
                    info, step_info, info)
end


function Build_low_curved_stair(S, skin, x_side,y_side, x_h,y_h)

  local step_info = get_mat(skin.step_w, skin.top_f)
  add_pegging(step_info)

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

  local steps = 2 * int(math.abs(y_h-x_h) / 30 + 0.9)

  if steps < 4 then
    steps = 4
  end


  for i = steps,1,-1 do
    local z = y_h + (x_h - y_h) * (i) / (steps+1)

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
    transformed_brush(T, step_info,
    {
      { x=fx1, y=fy1 },
      { x=fx2, y=fy2 },
      { x=cx2, y=cy2 },
      { x=cx1, y=cy1 },
    },
    -EXTREME_H, z)
  end


  local mat_info = get_mat("METAL")

  local h3 = math.max(x_h, y_h)

  transformed_brush(T, mat_info,
    rect_coords(0,0, 32,32), -EXTREME_H, h3)

  transformed_brush(T, mat_info,
    rect_coords(0,deep-bord_W, long,deep), -EXTREME_H, h3)

  transformed_brush(T, mat_info,
    rect_coords(long-bord_W,0, long,deep), -EXTREME_H, h3)
end


-- NOT ACTUALLY USED:
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

-- NOT ACTUALLY USED:
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

    transformed_brush(nil, info,
    {
      { x=nx2, y=ny1 },
      { x=nx2, y=ny2 },
      { x=nx1, y=ny2 },
      { x=nx1, y=ny1 },
    },
    -EXTREME_H, z)
  end 

  ST.done = true
end


function Build_lift(S, skin, tag)
  assert(skin.walk_kind)
  assert(skin.switch_kind)

  local lift_info = get_mat(skin.side_w, skin.top_f)

  local side = S.stair_dir

  local low_z  = S.stair_z1
  local high_z = S.stair_z2

  if low_z > high_z then
    low_z, high_z = high_z, low_z
    side = 10 - side
  end


  local switch_dirs = {}

  for dir = 2,8,2 do
    local N = S:neighbor(dir)

    if (dir == 10-side) or
       (is_perpendicular(dir, side) and N and N.room == S.room
        and N.floor_h and N.floor_h < high_z - 15)
    then
      switch_dirs[dir] = true
    end
  end


  local f_tex = S.f_tex or S.room.combo.floor
  local w_tex = S.w_tex or S.room.combo.wall

  local S2 = S:neighbor(10-side)
  if S2 and S2.room == S.room and S2.kind == "walk" and S2.f_tex then
    f_tex = S2.f_tex
  end


  local sw_face = { texture=skin.side_w, y_offset=0, peg=true }

  local coords = get_wall_coords(S, side, 128)

  -- FIXME: there must be a better way....
  coords[1].line_kind = sel(switch_dirs[6], skin.switch_kind, skin.walk_kind)
  coords[2].line_kind = sel(switch_dirs[8], skin.switch_kind, skin.walk_kind)
  coords[3].line_kind = sel(switch_dirs[4], skin.switch_kind, skin.walk_kind)
  coords[4].line_kind = sel(switch_dirs[2], skin.switch_kind, skin.walk_kind)

  if switch_dirs[6] then coords[1].w_face = sw_face end
  if switch_dirs[8] then coords[2].w_face = sw_face end
  if switch_dirs[4] then coords[3].w_face = sw_face end
  if switch_dirs[2] then coords[4].w_face = sw_face end

  coords[1].line_tag = tag
  coords[2].line_tag = tag
  coords[3].line_tag = tag
  coords[4].line_tag = tag

  lift_info.sec_tag = tag

  transformed_brush(nil, lift_info, coords, -EXTREME_H, high_z - 8)


  local front_coords = get_wall_coords(S, 10-side, 128)

  transformed_brush(nil, get_mat(w_tex, f_tex),
    front_coords, -EXTREME_H, low_z);
end


function mark_room_as_done(R)
  for sx = R.sx1,R.sx2 do for sy = R.sy1,R.sy2 do
    local S = SEEDS[sx][sy][1]
    
    if S.room == R then
      S.sides_only = true
    end
  end end
end


function Build_pillar(S, z1, z2, skin)
  
  local mx = int((S.x1 + S.x2)/2)
  local my = int((S.y1 + S.y2)/2)
  local mz = int((z1 + z2)/2)

  transformed_brush(nil, add_pegging(get_mat(skin.pillar)),
  {
    { x=mx+32, y=my-32 }, { x=mx+32, y=my+32 },
    { x=mx-32, y=my+32 }, { x=mx-32, y=my-32 },
  },
  -EXTREME_H, EXTREME_H)

  for pass = 1,2 do
    transformed_brush(nil, get_mat(skin.trim2),
    {
      { x=mx+40, y=my-40 }, { x=mx+40, y=my+40 },
      { x=mx-40, y=my+40 }, { x=mx-40, y=my-40 },
    },
    sel(pass == 1, -EXTREME_H, z2-32),
    sel(pass == 2,  EXTREME_H, z1+32)
    )

    transformed_brush(nil, get_mat(skin.trim1),
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
    sel(pass == 1, -EXTREME_H, z2-6),
    sel(pass == 2,  EXTREME_H, z1+6)
    )
  end
end


function Build_corner_beam(S, side, skin)
  -- FIXME: at this stage the thick[] values are not decided yet

  local x1 = S.x1 + 24 -- S.thick[4]
  local y1 = S.y1 + 24 -- S.thick[2]
  local x2 = S.x2 - 24 -- S.thick[6]
  local y2 = S.y2 - 24 -- S.thick[8]

  local w = assert(skin.w)

  if side == 1 or side == 7 then x2 = x1 + w else x1 = x2 - w end
  if side == 1 or side == 3 then y2 = y1 + w else y1 = y2 - w end
  
  local info = get_mat(skin.beam_w, skin.beam_f)

  add_pegging(info, skin.x_offset, skin.y_offset, false)

  transformed_brush(nil, info, rect_coords(x1,y1, x2,y2), -EXTREME_H, EXTREME_H)
end


function Build_cross_beam(S, dir, w, beam_z, mat)
  local x1, y1 = S.x1, S.y1
  local x2, y2 = S.x2, S.y2

  -- FIXME: at this stage the thick[] values are not decided yet
  if S.sx == S.room.sx1 then x1 = x1 + 24 elseif is_horiz(dir) then x1 = x1 - 24 end
  if S.sx == S.room.sx2 then x2 = x2 - 24 elseif is_horiz(dir) then x2 = x2 + 24 end
  if S.sy == S.room.sy1 then y1 = y1 + 24 elseif is_vert(dir)  then y1 = y1 - 24 end
  if S.sy == S.room.sy2 then y2 = y2 - 24 elseif is_vert(dir)  then y2 = y2 + 24 end

  local mx = int((x1 + x2) / 2)
  local my = int((y1 + y2) / 2)

  local coords
  if is_vert(dir) then
    coords = rect_coords(mx-w/2, y1, mx+w/2, y2)
  else
    coords = rect_coords(x1, my-w/2, x2, my+w/2)
  end

  transformed_brush(nil, get_mat(mat), coords, beam_z, EXTREME_H)
end


function Build_small_switch(S, dir, f_h, skin, tag)

  local DT, long = get_transform_for_seed_side(S, 10-dir)
  local deep = long

  local mx = int(long / 2)
  local my = int(deep / 2)


  local info = get_mat(skin.side_w)

  local switch_info = get_mat(skin.switch_w)
  add_pegging(switch_info, skin.x_offset, skin.y_offset)

  local base_h   = skin.base_h or 12
  local switch_h = skin.switch_h or 64

  transformed_brush(DT, info,
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
  -EXTREME_H, f_h+base_h)

  transformed_brush(DT, info,
  {
    { x=mx+32, y=my-8 },
    { x=mx+32, y=my+8, w_face = switch_info.w_face, line_kind=assert(skin.line_kind), line_tag=tag },
    { x=mx-32, y=my+8 },
    { x=mx-32, y=my-8 },
  },
  -EXTREME_H, f_h+base_h+switch_h)
end

                                      
function Build_exit_pillar(S, z1, skin)
  local DT, long = get_transform_for_seed_side(S, 8)

  local mx = int((S.x1 + S.x2)/2)
  local my = int((S.y1 + S.y2)/2)

  transformed_brush(nil, add_pegging(get_mat(skin.switch_w)),
  {
    { x=mx+32, y=my-32, line_kind=11 },
    { x=mx+32, y=my+32, line_kind=11 },
    { x=mx-32, y=my+32, line_kind=11 },
    { x=mx-32, y=my-32, line_kind=11 },
  },
  -EXTREME_H, z1 + skin.h)


  local info = get_mat(skin.exitside)

  local exit_info = get_mat(skin.exit_w)
  add_pegging(exit_info)
 
  for pass=1,4 do
    DT.mirror_x = sel((pass % 2)==1, nil, long/2)
    DT.mirror_y = sel(pass >= 3,     nil, long/2)

    transformed_brush(DT, info,
    {
      { x=60+8,  y=60+24 },
      { x=60+0,  y=60+16, w_face = exit_info.w_face },
      { x=60+28, y=60+0  },
      { x=60+36, y=60+8  },
    },
    -EXTREME_H, z1 + skin.exit_h)
  end
end


function Build_outdoor_exit_switch(S, dir, f_h, skin)

  local DT, long = get_transform_for_seed_side(S, 10-dir)
  local deep = long

  local mx = int(long / 2)
  local my = int(deep / 2)


  transformed_brush(DT, get_mat(skin.podium),
    rect_coords(32,32, long-32,deep-32), -EXTREME_H, f_h+12)


  local info = get_mat(skin.base)

  local switch_info = get_mat(skin.switch_w)
  add_pegging(switch_info, skin.x_offset, skin.y_offset)

  transformed_brush(DT, info,
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
  -EXTREME_H, f_h+16)

  transformed_brush(DT, info,
  {
    { x=mx+32, y=my-8 },
    { x=mx+32, y=my+8, w_face = switch_info.w_face, line_kind=11 },
    { x=mx-32, y=my+8 },
    { x=mx-32, y=my-8, w_face = switch_info.w_face, line_kind=11 },
  },
  -EXTREME_H, f_h+16+64)


  if skin.exitside then
    info = get_mat(skin.exitside)
  end

  local exit_info = get_mat(skin.exit_w)
  add_pegging(exit_info)
 
  for pass=1,4 do
    DT.mirror_x = sel((pass % 2)==1, nil, long/2)
    DT.mirror_y = sel(pass >= 3,     nil, deep/2)

    transformed_brush(DT, info,
    {
      { x=48+8,  y=48+24 },
      { x=48+0,  y=48+16, w_face = exit_info.w_face },
      { x=48+28, y=48+0  },
      { x=48+36, y=48+8  },
    },
    -EXTREME_H, f_h+12+16)
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

  local xt_info = assert(PLAN.theme.exit)
  local w_tex = rand_key_by_probs(xt_info.walls)
  local f_tex = rand_key_by_probs(xt_info.floors)
  local c_tex = rand_key_by_probs(xt_info.ceils)

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
    t_face = { texture=T.f_tex or C.conn_ftex or f_tex },
    b_face = { texture=out_combo.ceil },
  }


  local DT, long = get_transform_for_seed_side(S, side)
  local mx = int(long / 2)


  transformed_brush(DT, out_info, rect_coords(8,0, long-8,48),
                    -EXTREME_H, f_h)
  transformed_brush(DT, out_info, rect_coords(8,-24, long-8,48),
                    c_h, EXTREME_H)

  transformed_brush(DT, inner_info, rect_coords(8,48, long-8,long-8),
                    -EXTREME_H, f_h)
  transformed_brush(DT, inner_info, rect_coords(8,48, long-8,long-8),
                    c_h, EXTREME_H)


  S.thick[side] = 80


  transformed_brush(nil, inner_info, get_wall_coords(S, rotate_cw90(side),  32, 8),
                    -EXTREME_H, EXTREME_H)
  transformed_brush(nil, inner_info, get_wall_coords(S, rotate_ccw90(side), 32, 8),
                    -EXTREME_H, EXTREME_H)


  -- make door

  local door_info =
  {
    w_face = { texture="EXITDOOR", peg=true, x_offset=0, y_offset=0 },
    t_face = { texture="FLAT5_5" },
    b_face = { texture="FLAT5_5" },
    flag_door = true,
  }

  transformed_brush(DT, door_info,
  {
    { x=mx+32, y=48, line_kind=1 },
    { x=mx+32, y=64, line_kind=1 },
    { x=mx-32, y=64, line_kind=1 },
    { x=mx-32, y=48, line_kind=1 },
  },
  f_h+16, EXTREME_H)

  inner_info.b_face = { texture="FLAT1" }

  transformed_brush(DT, inner_info,
  {
    { x=mx+32, y=32 },
    { x=mx+32, y=80 },
    { x=mx-32, y=80 },
    { x=mx-32, y=32, w_face=out_face },
  },
  f_h+72, EXTREME_H)

  local exit_info =
  {
    w_face = { texture="SHAWN2" },
    t_face = { texture="FLAT23" },
    b_face = { texture="FLAT23" },
  }

  local exit_face = { texture="EXITSIGN", x_offset=0, y_offset=0 }

  local key_tex = "LITE5"

  assert(not C.lock)

  for pass = 1,2 do
    if pass == 2 then DT.mirror_x = mx end

    transformed_brush(DT, inner_info,
    {
      { x=0,     y=80,  w_face=out_face },
      { x=0,     y=-24, w_face=out_face },
      { x=mx-96, y=-24, w_face=out_face },
      { x=mx-32, y=32,  w_face={ texture=key_tex, x_offset=0, y_offset=0 } },
      { x=mx-32, y=48,  w_face={ texture="DOORTRAK", peg=true } },
      { x=mx-32, y=64,  w_face={ texture=key_tex, x_offset=0, y_offset=0 } },
      { x=mx-32, y=80  },
    },
    -EXTREME_H, EXTREME_H)

    transformed_brush(DT, exit_info,
    {
      { x=mx-68, y= -8 },
      { x=mx-60, y=-16, w_face=exit_face },
      { x=mx-32, y=  0 },
      { x=mx-40, y=  8 },
    },
    c_h-16, EXTREME_H)
  end


  -- make switch

  local sw_tex = rand_element { "SW1METAL", "SW1LION", "SW1BRN2", "SW1BRNGN",
                                "SW1GRAY",  "SW1MOD1", "SW1SLAD", "SW1STRTN",
                                "SW1TEK",   "SW1STON1" }

  local WT
  WT, long = get_transform_for_seed_side(S, 10-side)

  mx = int(long / 2)
  local swit_W = 64


  transformed_brush(WT, inner_info,
  {
    { x=long-8, y=8 },
    { x=long-8, y=32 },
    { x=mx+swit_W/2+8, y=32, w_face={ texture="DOORSTOP", x_offset=0 } },
    { x=mx+swit_W/2,   y=32, w_face={ texture=sw_tex,     x_offset=0, y_offset=0 }, line_kind=11 },
    { x=mx-swit_W/2,   y=32, w_face={ texture="DOORSTOP", x_offset=0 } },
    { x=mx-swit_W/2-8, y=32 },
    { x=8, y=32 },
    { x=8, y=8 },
  },
  -EXTREME_H, EXTREME_H)


  assert(not C.already_made_lock)
  C.already_made_lock = true

  mark_room_as_done(R)


  if item_name then
    local ex, ey = transformed_coord(WT, mx, 96)
    gui.add_entity(item_name, ex, ey, f_h+25)
  end
end


function Build_wall(S, side, mat)
  transformed_brush(nil, get_mat(mat),
      get_wall_coords(S, side),
      -EXTREME_H, EXTREME_H)
end


function Build_fence(S, side, fence_h, skin)
  transformed_brush(nil, get_mat(skin.wall, skin.floor),
    get_wall_coords(S, side), -EXTREME_H, fence_h)
end


function Build_window(S, side, width, mid_w, z1, z2, skin)
  local wall_info = get_mat(skin.wall, skin.floor)

  local side_info = get_mat(skin.side_t)


  local T, long, deep = get_transform_for_seed_side(S, side)

  local mx = int(long/2)


  -- top and bottom
  local coords = rect_coords(mx-width/2, 0, mx+width/2, deep)

  transformed_brush(T, wall_info, coords, -EXTREME_H, z1)
  transformed_brush(T, wall_info, coords, z2,  EXTREME_H)


  -- center piece
  if mid_w then
    transformed_brush(T, wall_info,
    {
      { x=mx+mid_w/2, y=0,    w_face = side_info.w_face },
      { x=mx+mid_w/2, y=deep },
      { x=mx-mid_w/2, y=deep, w_face = side_info.w_face },
      { x=mx-mid_w/2, y=0 },
    },
    -EXTREME_H, EXTREME_H)
  end


  -- sides pieces
  for pass = 1,2 do
    if pass == 2 then T.mirror_x = mx end

    transformed_brush(T, wall_info,
    {
      { x=mx-width/2, y=0, w_face = side_info.w_face },
      { x=mx-width/2, y=deep },
      { x=0, y=deep },
      { x=0, y=0 },
    },
    -EXTREME_H, EXTREME_H)
  end
end


function Build_picture(S, side, z1, z2, skin)

  local count = skin.count or 1

  local T, long, deep = get_transform_for_seed_side(S, side)

  local wall_info = get_mat(skin.wall, skin.floor)

  local side_info = wall_info
  if skin.side_t then side_info = get_mat(skin.side_t) end

  local pic_info = get_mat(skin.pic_w)
  add_pegging(pic_info, skin.x_offset, skin.y_offset, skin.peg or false)


  if not z2 then
    z2 = z1 + assert(skin.height)
  end

  local WD  = assert(skin.width)
  local HT  = assert(skin.depth)
  local gap = skin.gap or WD

  local total_w = count * WD + (count - 1) * gap
  assert(total_w < PARAMS.seed_size-28)

  local mx = int(long/2)
  local my = deep - HT


  -- wall around picture
  transformed_brush(T, wall_info, rect_coords(0,0, long,my-4),
                    -EXTREME_H, EXTREME_H)
  transformed_brush(T, wall_info, rect_coords(0,my-4, 8,deep),
                    -EXTREME_H, EXTREME_H)
  transformed_brush(T, wall_info, rect_coords(long-8,my-4, long,deep),
                    -EXTREME_H, EXTREME_H)


  for n = 0,count do
    local x = mx-total_w/2 + n * (WD+gap)

    -- picture itself
    if n < count then
      transformed_brush(T, pic_info,
      {
        { x=x+WD, y=my-4, line_kind=skin.line_kind },
        { x=x+WD, y=my,   line_kind=skin.line_kind },
        { x=x,    y=my,   line_kind=skin.line_kind },
        { x=x,    y=my-4, line_kind=skin.line_kind },
      },
      -EXTREME_H, EXTREME_H)
    end

    -- side wall
    local x1 = sel(n == 0, 8, x - gap)
    local x2 = sel(n == count, long-8, x)

gui.debugf("x1..x2 : %d,%d\n", x1,x2)
    transformed_brush(T, wall_info,
    {
      { x=x2, y=my-4, w_face = side_info.w_face },
      { x=x2, y=deep },
      { x=x1, y=deep, w_face = side_info.w_face },
      { x=x1, y=my-4 },
    },
    -EXTREME_H, EXTREME_H)
  end


  -- top and bottom
  local floor_info = get_mat(skin.wall, skin.floor)

  floor_info.b_face.light = skin.light
  floor_info.sec_kind = skin.sec_kind

  local coords = rect_coords(mx-total_w/2,my-4, mx+total_w/2,deep)

  transformed_brush(T, floor_info, coords, -EXTREME_H, z1)
  transformed_brush(T, floor_info, coords, z2,  EXTREME_H)
end


function Build_pedestal(S, z1, skin)
  local mx = int((S.x1+S.x2) / 2)
  local my = int((S.y1+S.y2) / 2)

  local info = get_mat(skin.wall or skin.floor, skin.floor)

  add_pegging(info, skin.x_offset, skin.y_offset, skin.peg)

  transformed_brush(nil, info,
      rect_coords(mx-32,my-32, mx+32,my+32),
      -EXTREME_H, z1+8)
end

function Build_lowering_pedestal(S, z1, skin)
  local mx = int((S.x1+S.x2) / 2)
  local my = int((S.y1+S.y2) / 2)

  local tag = PLAN:alloc_tag()

  local info = get_mat(skin.wall or skin.floor, skin.floor)

  add_pegging(info, skin.x_offset, skin.y_offset, skin.peg)
  info.sec_tag = tag

  transformed_brush(nil, info,
  {
    { x=mx+32, y=my-32, line_kind=skin.line_kind, line_tag=tag },
    { x=mx+32, y=my+32, line_kind=skin.line_kind, line_tag=tag },
    { x=mx-32, y=my+32, line_kind=skin.line_kind, line_tag=tag },
    { x=mx-32, y=my-32, line_kind=skin.line_kind, line_tag=tag },
  },
  -EXTREME_H, z1)
end


function Build_crate(x, y, z_top, skin)
  local info = add_pegging(get_mat(skin.side_w))

  transformed_brush(nil, info,
    rect_coords(x-32,y-32, x+32,y+32),
    -EXTREME_H, z_top)
end


function Build_raising_start(S, face_dir, z1, skin)

  local info = get_mat(skin.f_tex)

  local sw_face =
  {
    texture = assert(skin.switch_w),
    x_offset = 0,
    y_offset = 0,
    peg = true,
  }

  local tag = PLAN:alloc_tag()

  for side = 2,8,2 do
    local T, long, deep = get_transform_for_seed_side(S, side, 48)

    local mx = int(long / 2)

    if side == face_dir then
      transformed_brush(T, info,
      {
        { x=long,  y=0 },
        { x=long,  y=deep },
        { x=mx+32, y=deep, w_face=sw_face, line_kind=18, line_tag=tag },
        { x=mx-32, y=deep },
        { x=0,     y=deep },
        { x=0,     y=0 },
      },
      -EXTREME_H, z1)
    
    else
      transformed_brush(T, info,
      {
        { x=long, y=0 },
        { x=long, y=deep },
        { x=0,    y=deep },
        { x=0,    y=0 },
      },
      -EXTREME_H, z1)
    end
  end

  z1 = z1 - 128

  local T, long, deep = get_transform_for_seed_center(S)

  info.sec_tag = tag

  transformed_brush(T, info,
  {
    { x=long, y=0,   },
    { x=long, y=deep },
    { x=0,    y=deep },
    { x=0,    y=0,   },
  },
  -EXTREME_H, z1)
end


function Build_popup_trap(S, z1, skin, combo, monster)

  local info =
  {
    t_face = { texture=combo.floor },
    b_face = { texture=combo.floor },
    w_face = { texture=combo.wall  },
  }

  for side = 2,8,2 do
    S.thick[side] = S.thick[side] + 4

    local T, long, deep = get_transform_for_seed_side(S, side)

    transformed_brush(T, info,
    {
      { x=long, y=0 },
      { x=long, y=deep, w_face={ texture="-" } },
      { x=0,    y=deep },
      { x=0,    y=0 },
    },
    -EXTREME_H, z1)
  end

  z1 = z1 - 384

  local tag = PLAN:alloc_tag()

  local T, long, deep = get_transform_for_seed_center(S)

  info.sec_tag = tag

  transformed_brush(T, info,
  {
    { x=long, y=0,    line_kind=19, line_tag=tag },
    { x=long, y=deep, line_kind=19, line_tag=tag },
    { x=0,    y=deep, line_kind=19, line_tag=tag },
    { x=0,    y=0,    line_kind=19, line_tag=tag },
  },
  -EXTREME_H, z1)

  gui.add_entity(monster, T.dx + long/2, T.dy + deep/2, z1+25, { ambush=1 })
end


function Build_stairwell(R, skin)
  assert(skin.wall)

  local wall_info  = get_mat(skin.wall, skin.floor)
  local floor_info = get_mat(skin.floor or skin.wall)
  local ceil_info  = get_mat(skin.ceil or skin.floor or skin.wall)

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
                      wall_info, floor_info, ceil_info)
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
                        wall_info, floor_info, ceil_info)

      -- right side
      Build_curved_hall(steps, corn_x, corn_y,
                        dx0, dx1, dx2, dx3,
                        dy0, dy1, dy2, dy3,
                        h3, h2, 128,
                        wall_info, floor_info, ceil_info)
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
                        wall_info, floor_info, ceil_info)

      -- top section
      Build_curved_hall(steps, corn_x, corn_y,
                        dx0, dx1, dx2, dx3,
                        dy0, dy1, dy2, dy3,
                        h2, h3, 128,
                        wall_info, floor_info, ceil_info)
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
                        wall_info, floor_info, ceil_info)

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
                        wall_info, floor_info, ceil_info)

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
                        wall_info, floor_info, ceil_info)

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
                        wall_info, floor_info, ceil_info)
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

      transformed_brush(nil, wall_info, step_coords(p0,p1, 0/6, 1/6), -EXTREME_H,EXTREME_H)
      transformed_brush(nil, wall_info, step_coords(p0,p1, 5/6, 6/6), -EXTREME_H,EXTREME_H)

      local coords = step_coords(p0,p1, 1/6, 5/6)

      transformed_brush(nil, floor_info, coords, -EXTREME_H,f_h)
      transformed_brush(nil, ceil_info,  coords,  c_h,EXTREME_H)
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


function Build_sky_hole(sx1,sy1, sx2,sy2, kind, mw, mh,
                        outer_info, outer_z,
                        inner_info, inner_z,
                        trim, spokes)

  local ox1 = SEEDS[sx1][sy1][1].x1
  local oy1 = SEEDS[sx1][sy1][1].y1
  local ox2 = SEEDS[sx2][sy2][1].x2
  local oy2 = SEEDS[sx2][sy2][1].y2

  local mx = (ox1 + ox2) / 2
  local my = (oy1 + oy2) / 2

  local x1, y1 = mx-mw/2, my-mh/2
  local x2, y2 = mx+mw/2, my+mh/2

  assert(ox1 < x1 and x1 < mx and mx < x2 and x2 < ox2)
  assert(oy1 < y1 and y1 < my and my < y2 and y2 < oy2)

  local diag_w = int(mw / 4)
  local diag_h = int(mh / 4)


  if inner_info then
    transformed_brush(nil, inner_info, rect_coords(x1,y1,x2,y2), inner_z, EXTREME_H)
  end


  transformed_brush(nil, outer_info, rect_coords(ox1,oy1,  x1,oy2), outer_z, EXTREME_H)
  transformed_brush(nil, outer_info, rect_coords( x2,oy1, ox2,oy2), outer_z, EXTREME_H)
  transformed_brush(nil, outer_info, rect_coords( x1,oy1,  x2, y1), outer_z, EXTREME_H)
  transformed_brush(nil, outer_info, rect_coords( x1, y2,  x2,oy2), outer_z, EXTREME_H)

  if kind == "round" then
    transformed_brush(nil, outer_info,
                      diagonal_coords(1, x1, y1, x1+diag_w, y1+diag_h),
                      outer_z, EXTREME_H)

    transformed_brush(nil, outer_info,
                      diagonal_coords(3, x2-diag_w, y1, x2, y1+diag_h),
                      outer_z, EXTREME_H)

    transformed_brush(nil, outer_info,
                      diagonal_coords(7, x1, y2-diag_h, x1+diag_w, y2),
                      outer_z, EXTREME_H)

    transformed_brush(nil, outer_info,
                      diagonal_coords(9, x2-diag_w, y2-diag_h, x2, y2),
                      outer_z, EXTREME_H)
  end


  -- TRIM --

  if trim then trim = get_mat(trim) end

  local w = 8 * int(1 + math.max(mw,mh) / 120)

  local trim_h = 4 * int(1 + math.min(mw,mh) / 120)

  if trim and kind == "square" then
    transformed_brush(nil, trim, rect_coords(x1-w,y1-w, x1+4,y2+w), outer_z-trim_h, EXTREME_H)
    transformed_brush(nil, trim, rect_coords(x2-4,y1-w, x2+w,y2+w), outer_z-trim_h, EXTREME_H)

    transformed_brush(nil, trim, rect_coords(x1+4,y1-w, x2-4,y1+4), outer_z-trim_h, EXTREME_H)
    transformed_brush(nil, trim, rect_coords(x1+4,y2-4, x2-4,y2+w), outer_z-trim_h, EXTREME_H)
  end

  if trim and kind == "round" then
    transformed_brush(nil, trim, rect_coords(x1-w,y1+diag_h, x1+4,y2-diag_h), outer_z-trim_h, EXTREME_H)
    transformed_brush(nil, trim, rect_coords(x2-4,y1+diag_h, x2+w,y2-diag_h), outer_z-trim_h, EXTREME_H)

    transformed_brush(nil, trim, rect_coords(x1+diag_w,y1-w, x2-diag_w,y1+4), outer_z-trim_h, EXTREME_H)
    transformed_brush(nil, trim, rect_coords(x1+diag_w,y2-4, x2-diag_w,y2+w), outer_z-trim_h, EXTREME_H)

    transformed_brush(nil, trim,  -- top left
    {
      { x=x1-w, y=y2-diag_h },
      { x=x1+4, y=y2-diag_h },
      { x=x1+diag_w, y=y2-4 },
      { x=x1+diag_w, y=y2+w },
    },
    outer_z-trim_h, EXTREME_H)

    transformed_brush(nil, trim,  -- top right
    {
      { x=x2-diag_w, y=y2+w },
      { x=x2-diag_w, y=y2-4 },
      { x=x2-4, y=y2-diag_h },
      { x=x2+w, y=y2-diag_h },
    },
    outer_z-trim_h, EXTREME_H)

    transformed_brush(nil, trim,  -- bottom left
    {
      { x=x1+4, y=y1+diag_h },
      { x=x1-w, y=y1+diag_h },
      { x=x1+diag_w, y=y1-w },
      { x=x1+diag_w, y=y1+4 },
    },
    outer_z-trim_h, EXTREME_H)

    transformed_brush(nil, trim,  -- bottom right
    {
      { x=x2-diag_w, y=y1+4 },
      { x=x2-diag_w, y=y1-w },
      { x=x2+w, y=y1+diag_h },
      { x=x2-4, y=y1+diag_h },
    },
    outer_z-trim_h, EXTREME_H)
  end


  -- SPOKES --

  if spokes then spokes = get_mat(spokes) end

  w = 6 * int(1 + math.max(mw,mh) / 192)

  if spokes then
    local pw = w * 2
    local K = 16

    transformed_brush(nil, spokes, rect_coords(ox1+K,my-w, x1+pw,my+w), outer_z-trim_h*1.5, EXTREME_H)
    transformed_brush(nil, spokes, rect_coords(x2-pw,my-w, ox2-K,my+w), outer_z-trim_h*1.5, EXTREME_H)

    transformed_brush(nil, spokes, rect_coords(mx-w,oy1+K, mx+w,y1+pw), outer_z-trim_h*1.5, EXTREME_H)
    transformed_brush(nil, spokes, rect_coords(mx-w,y2-pw, mx+w,oy2-K), outer_z-trim_h*1.5, EXTREME_H)
  end


  -- mark seeds so we don't build normal ceiling there
  for x = sx1,sx2 do for y = sy1,sy2 do
    SEEDS[x][y][1].no_ceil = true
  end end -- for x,y
end


---==========================================================---


function Builder_quake2_test()

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
    -EXTREME_H, EXTREME_H)

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
    -EXTREME_H, EXTREME_H)
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

  gui.add_entity("info_player_start", 64, 256, 64)
end

