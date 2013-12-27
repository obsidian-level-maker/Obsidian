----------------------------------------------------------------
--  BUILDER
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2014 Andrew Apted
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


Build = {}
Trans = {}


function raw_add_brush(brush)
  each C in brush do
    if C.face then
      table.merge(C, C.face)
      C.face = nil

      -- compatibility cruft

      if C.x_offset then C.u1 = C.x_offset ; C.x_offset = nil end
      if C.y_offset then C.v1 = C.y_offset ; C.y_offset = nil end

      if C.line_kind then C.special = C.line_kind ; C.line_kind = nil end
      if C.line_tag  then C.tag     = C.line_tag  ; C.line_tag  = nil end
    end
  end

  gui.add_brush(brush)

  if GAME.add_brush_func then
     GAME.add_brush_func(brush)
  end
end


function raw_add_entity(ent)
  if GAME.format == "quake" then
    ent.mangle = ent.angles ; ent.angles = nil
  end

  gui.add_entity(ent)

  if GAME.add_entity_func then
     GAME.add_entity_func(ent)
  end
end


function raw_add_model(model)
  assert(model.entity)

  model.entity.model = gui.q1_add_mapmodel(model)

  gui.add_entity(model.entity)

  if GAME.add_model_func then
     GAME.add_model_func(model)
  end
end


Trans.TRANSFORM =
{
  -- mirror_x  : flip horizontally (about given X)
  -- mirror_y  : flip vertically (about given Y)
  -- mirror_z

  -- scale_x   : scaling factor
  -- scale_y
  -- scale_z

  -- rotate    : angle in degrees, counter-clockwise,
  --             rotates about the origin

  -- add_x     : translation, i.e. new origin coords
  -- add_y
  -- add_z
}


function Trans.clear()
  Trans.TRANSFORM = {}
end

function Trans.set(T)
  Trans.TRANSFORM = T
end

function Trans.modify(what, value)
  Trans.TRANSFORM[what] = value
end


function Trans.apply(x, y)
  local T = Trans.TRANSFORM

  -- apply mirroring first
  if T.mirror_x then x = T.mirror_x * 2 - x end
  if T.mirror_y then y = T.mirror_y * 2 - y end

  -- apply scaling
  x = x * (T.scale_x or 1)
  y = y * (T.scale_y or 1)

  -- apply rotation
  if T.rotate then
    x, y = geom.rotate_vec(x, y, T.rotate)
  end

  -- apply translation last
  x = x + (T.add_x or 0)
  y = y + (T.add_y or 0)

  return x, y
end


function Trans.apply_z(z, slope)
  local T = Trans.TRANSFORM

  if slope then
    slope = table.copy(slope)

    slope.x1, slope.y1 = Trans.apply(slope.x1, slope.y1)
    slope.x2, slope.y2 = Trans.apply(slope.x2, slope.y2)

    if T.mirror_z then slope.dz = - slope.dz end
  end

  -- apply mirroring first
  if T.mirror_z then z = T.mirror_z * 2 - z end

  -- apply scaling
  z = z * (T.scale_z or 1)

  -- apply translation last
  z = z + (T.add_z or 0)

  return z, slope
end


function Trans.brush(kind, coords)
  if not coords then
    kind, coords = "solid", kind
  end

  -- FIXME: mirroring

  -- apply transform
  coords = table.copy(coords)

  each C in coords do
    if C.x then
      C.x, C.y = Trans.apply(C.x, C.y)
    elseif C.b then
      C.b, C.slope = Trans.apply_z(C.b, C.slope)
    else assert(C.t)
      C.t, C.slope = Trans.apply_z(C.t, C.slope)
    end
  end

  table.insert(coords, 1, { m=kind })

  raw_add_brush(coords)
end


function Trans.old_brush(info, coords, z1, z2)
---???  if type(info) != "table" then
---???    info = get_mat(info)
---???  end

  -- check mirroring
  local reverse_it = false

  if Trans.TRANSFORM.mirror_x then reverse_it = not reverse_it end
  if Trans.TRANSFORM.mirror_y then reverse_it = not reverse_it end

  -- apply transform
  coords = table.deep_copy(coords)

  each C in coords do
    C.x, C.y = Trans.apply(C.x, C.y)

    if C.w_face then
      C.face = C.w_face ; C.w_face = nil
    elseif info.w_face then
      C.face = info.w_face
    end
  end

  if reverse_it then
    -- make sure side properties (w_face, line_kind, etc)
    -- are associated with the correct vertex....
    local x1 = coords[1].x
    local y1 = coords[1].y

    for i = 1, #coords-1 do
      coords[i].x = coords[i+1].x
      coords[i].y = coords[i+1].y
    end

    coords[#coords].x = x1
    coords[#coords].y = y1

    table.reverse(coords)
  end

  if z2 < EXTREME_H - 1 then
    table.insert(coords, { t=z2, face=info.t_face })

    coords[#coords].special = info.sec_kind
    coords[#coords].tag     = info.sec_tag
  end

  if z1 > -EXTREME_H + 1 then
    table.insert(coords, { b=z1, face=info.b_face })

    if info.delta_z then
      coords[#coords].delta_z = info.delta_z
    end

    coords[#coords].special = info.sec_kind
    coords[#coords].tag     = info.sec_tag
  end


  -- TODO !!!  transform slope coords (z1 or z2 == table)

-- gui.printf("coords=\n%s\n", table.tostr(coords,4))

  table.insert(coords, 1, { m="solid", peg=info.peg })

  raw_add_brush(coords)
end


function Trans.entity(name, x, y, z, props)
  assert(name)

  if not props then
    props = {}
  end

  local info = GAME.ENTITIES[name] or
               GAME.MONSTERS[name] or
               GAME.WEAPONS[name] or
               GAME.PICKUPS[name]

  if not info then
    gui.printf("\nLACKING ENTITY : %s\n\n", name)
    return
  end
  assert(info.id)

  if info.delta_z then
    z = z + info.delta_z
  elseif PARAM.entity_delta_z then
    z = z + PARAM.entity_delta_z
  end

  x, y = Trans.apply(x, y)

  if info.spawnflags then
    props.spawnflags = (props.spawnflags or 0) + info.spawnflags
  end

  ent = table.copy(props)

  ent.id = info.id
  ent.x  = x
  ent.y  = y
  ent.z  = z

  raw_add_entity(ent)
end


-- COMPAT
function entity_helper(...) return Trans.entity(...) end


function Trans.quad(x1,y1, x2,y2, z1,z2, kind, w_face, p_face)
  if not w_face then
    -- convenient form: only a material name was given
    kind, w_face, p_face = Mat_normal(kind)
  end

  local coords =
  {
    { x=x1, y=y1, face=w_face },
    { x=x2, y=y1, face=w_face },
    { x=x2, y=y2, face=w_face },
    { x=x1, y=y2, face=w_face },
  }

  if z1 then table.insert(coords, { b=z1, face=p_face }) end
  if z2 then table.insert(coords, { t=z2, face=p_face }) end

  Trans.brush(kind, coords)
end


function Trans.tri_coords(x1,y1, x2,y2, x3,y3)
  return
  {
    { x=x1, y=y1 },
    { x=x2, y=y2 },
    { x=x3, y=y3 },
  }
end

function Trans.rect_coords(x1, y1, x2, y2)
  return
  {
    { x=x2, y=y1 },
    { x=x2, y=y2 },
    { x=x1, y=y2 },
    { x=x1, y=y1 },
  }
end

function Trans.box_coords(x, y, w, h)
  return
  {
    { x=x+w, y=y },
    { x=x+w, y=y+h },
    { x=x,   y=y+h },
    { x=x,   y=y },
  }
end


function Trans.old_quad(info, x1,y1, x2,y2, z1,z2)
  Trans.old_brush(info, Trans.rect_coords(x1,y1, x2,y2), z1,z2)
end

function Trans.triangle(info, x1,y1, x2,y2, x3,y3, z1,z2)
  Trans.old_brush(info, Trans.tri_coords(x1,y1, x2,y2, x3,y3), z1,z2)
end

function Trans.strip(info, strip, z1, z2)
  for i = 1, #strip - 1 do
    local a = strip[i]
    local b = strip[i+1]

    Trans.old_brush(info,
    {
      { x = a[1], y = a[2] },
      { x = a[3], y = a[4] },
      { x = b[3], y = b[4] },
      { x = b[1], y = b[2] },
    },
    z1, z2)
  end
end


------------------------------------------------------------------------


function Build.prepare_trip()

  -- build the psychedelic mapping
  local m_before = {}
  local m_after  = {}

  for m,def in pairs(GAME.MATERIALS) do
    if not def.sane and
       not (string.sub(m,1,1) == "_") and
       not (string.sub(m,1,2) == "SW") and
       not (string.sub(m,1,3) == "BUT")
    then
      table.insert(m_before, m)
      table.insert(m_after,  m)
    end
  end

  rand.shuffle(m_after)

  LEVEL.psycho_map = {}

  for i = 1,#m_before do
    LEVEL.psycho_map[m_before[i]] = m_after[i]
  end
end


function safe_get_mat(name)
  if OB_CONFIG.theme == "psycho" and LEVEL.psycho_map[name] then
    name = LEVEL.psycho_map[name]
  end

  local mat = GAME.MATERIALS[name]

  -- special handling for DOOM switches
  if not mat and string.sub(name,1,3) == "SW2" then
    mat = GAME.MATERIALS["SW1" .. string.sub(name,4)]
    if mat then
      mat = { t=name, f=mat.f }  -- create new SW2XXX material
      GAME.MATERIALS[name] = mat
    end
  end

  if not mat then
    gui.printf("\nLACKING MATERIAL : %s\n\n", name)
    mat = assert(GAME.MATERIALS["_ERROR"])

    -- prevent further messages
    GAME.MATERIALS[name] = mat
  end

  return mat
end

function get_mat(wall, floor, ceil)
  if not wall then wall = "_ERROR" end

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
    w_face = { tex=w_mat.t },
    t_face = { tex=f_mat.f or f_mat.t },
    b_face = { tex=c_mat.f or c_mat.t },
  }
end

function Mat_normal(wall, floor)
  if not wall then wall = "_ERROR" end

  local w_mat = safe_get_mat(wall)

  local f_mat = w_mat
  if floor then
    f_mat = safe_get_mat(floor)
  end

  return "solid", { tex=w_mat.t }, { tex=f_mat.f or f_mat.t }
end

function get_sky()
  local mat = assert(GAME.MATERIALS["_SKY"])

  local light = LEVEL.sky_light or 0.75

  return
  {
    kind = "sky",
    w_face = { tex=mat.t },
    t_face = { tex=mat.f or mat.t },
    b_face = { tex=mat.f or mat.t, light=light },
  }
end

function get_liquid()
  assert(LEVEL.liquid)
  local mat = get_mat(LEVEL.liquid.mat)

  mat.t_face.light = LEVEL.liquid.light
  mat.b_face.light = LEVEL.liquid.light

  mat.t_face.special = LEVEL.liquid.special
  mat.b_face.special = LEVEL.liquid.special

  return mat
end

function get_light(intensity)
  return
  {
    kind = "light",
    w_face = { tex="-" },
    t_face = { tex="-" },
    b_face = { tex="-", light=intensity },
  }
end

function get_rail()
  return
  {
    kind = "rail",
    w_face = { tex="-" },
    t_face = { tex="-" },
    b_face = { tex="-" },
  }
end

function rail_coord(x, y, name)
  local rail = GAME.RAILS[name]

  if not rail then
    gui.printf("LACKING RAIL %s\n", name)
    return { x=x, y=y }
  end

  return { x=x, y=y, w_face={ tex=rail.t }, line_flags=rail.line_flags }
end


function add_pegging(info, x_offset, y_offset, peg)
  info.w_face.x_offset = x_offset or 0
  info.w_face.y_offset = y_offset or 0
  info.peg = peg or 1

  return info
end


function get_transform_for_seed_side(S, side, thick)
  
  if not thick then thick = S.thick[side] end

  local T = { }

  if side == 8 then T.rotate = 180 end
  if side == 4 then T.rotate = 270 end
  if side == 6 then T.rotate =  90 end

  if side == 2 then T.add_x, T.add_y = S.x1, S.y1 end
  if side == 4 then T.add_x, T.add_y = S.x1, S.y2 end
  if side == 6 then T.add_x, T.add_y = S.x2, S.y1 end
  if side == 8 then T.add_x, T.add_y = S.x2, S.y2 end

  return T, SEED_SIZE, thick
end

function get_transform_for_seed_center(S)
  local T = { }

  T.add_x = S.x1 + S.thick[4]
  T.add_y = S.y1 + S.thick[2]

  local long = S.x2 - S.thick[6] - T.add_x
  local deep = S.y2 - S.thick[8] - T.add_y

  return T, long, deep
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
  assert(side != 5)

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

  return Trans.rect_coords(x1,y1, x2,y2)
end


function shadowify_brush(coords, dist)
  --
  -- ALGORITHM
  --
  -- Each side of the brush can be in one of three states:
  --    "light"  (not facing the shadow)
  --    "dark"
  --    "edge"   (parallel to shadow extrusion)
  --
  -- For each vertex we can do one of three operations:
  --    KEEP : when both lines are light or edge
  --    MOVE : when both lines are dark or edge
  --    DUPLICATE : one line is dark, one is light

  for i = 1,#coords do
    local v1 = coords[i]
    local v2 = coords[sel(i == #coords, 1, i+1)]

    local dx = v2.x - v1.x
    local dy = v2.y - v1.y

    -- simplify detection : map extrusion to X axis
    dy = dy + dx

    if dy < -0.01 then
      coords[i].light = true
    elseif dy > 0.01 then
      coords[i].dark = true
    else
      -- it is an edge : implied
    end
  end

  local new_coords = {}

  for i = 1,#coords do
    local P = coords[sel(i == 1, #coords, i-1)]
    local N = coords[i]

    if not (P.dark or N.dark) then
      -- KEEP
      table.insert(new_coords, N)
    else
      local NEW = { x=N.x+dist, y=N.y-dist}

      if not (P.light or N.light) then
        -- MOVE
        table.insert(new_coords, NEW)
      else
        -- DUPLICATE
        assert(P.light or P.dark)
        assert(N.light or N.dark)

        if P.light and N.dark then
          table.insert(new_coords, N)
          table.insert(new_coords, NEW)
        else
          table.insert(new_coords, NEW)
          table.insert(new_coords, N)
        end
      end
    end
  end

  return new_coords
end


function Build.wall(S, side, mat)
  local coords = get_wall_coords(S, side)

  Trans.old_brush(get_mat(mat), coords, -EXTREME_H, EXTREME_H)
end


function Build.facade(S, side, mat)
  local x1, y1 = S.x1, S.y1
  local x2, y2 = S.x2, S.y2

  local coords

  if side == 2 then
    coords = { {x=x1,y=y1}, {x=x2,y=y1}, {x=x2-8,y=y1+8}, {x=x1+8,y=y1+8} }
  elseif side == 8 then
    coords = { {x=x2,y=y2}, {x=x1,y=y2}, {x=x1+8,y=y2-8}, {x=x2-8,y=y2-8} }
  elseif side == 4 then
    coords = { {x=x1,y=y2}, {x=x1,y=y1}, {x=x1+8,y=y1+8}, {x=x1+8,y=y2-8} }
  else
    coords = { {x=x2,y=y1}, {x=x2,y=y2}, {x=x2-8,y=y2-8}, {x=x2-8,y=y1+8} }
  end

  Trans.old_brush(get_mat(mat), coords, -EXTREME_H, EXTREME_H)
end


function Build.fence(S, side, fence_h, skin)
  local coords = get_wall_coords(S, side)

  Trans.old_brush(get_mat(skin.wall, skin.floor), coords, -EXTREME_H, fence_h)
end


function Build.sky_fence(S, side, z_top, z_low, skin)
  local wall_info = get_mat(skin.fence_w, skin.fence_f)

  local sky_info = get_sky()
  local sky_back = get_sky()


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

  -- give back part the "never draw" linedef flag
  s_coords[sel(geom.is_vert(side), 2,1)].line_flags = 128
  s_coords[sel(geom.is_vert(side), 4,3)].line_flags = 128

  Trans.old_brush(wall_info, w_coords, -EXTREME_H, z_top)
  Trans.old_brush(wall_info, s_coords, -EXTREME_H, z_low)

  Trans.old_brush(sky_info, w_coords, SKY_H, EXTREME_H)

  if GAME.format == "quake" then
    Trans.old_brush(sky_back, s_coords, z_low+4, EXTREME_H)
  else
    sky_back.delta_z = (z_low+4) - (SKY_H-2)
    Trans.old_brush(sky_back, s_coords, SKY_H-2, EXTREME_H)
  end
end




function Build.archway(S, side, z1, z2, skin)

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
    { x=long, y=deep, w_face = wall_info.w_face },
    { x=0,    y=deep },
    { x=0,    y=-N_deep },
  }

  Trans.set(T)

  Trans.old_brush(other_info, frame_coords, z2, EXTREME_H)


  assert(deep > 17 or N_deep > 17)

  local break_info = wall_info
  if skin.other and skin.other != skin.wall then
    break_info = get_mat(skin.break_t)
  end

  for pass = 1,2 do
    if pass == 2 then Trans.modify("mirror_x", mx) end

    Trans.old_brush(wall_info,
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

  Trans.clear()
end


function Build.door(S, side, z1, skin, skin2, tag, reversed)

  tag2 = nil  -- FIXME !!!

  local N = S:neighbor(side)
  assert(N)


  local DY = 24

  local T, long, deep = get_transform_for_seed_side(S, side)

  local mx = int(long / 2)
  local my = 0

  local door_h = skin.door_h or 112
  local door_info = add_pegging(get_mat(skin.door_w))

  door_info.b_face.light = 0.7
  door_info.sec_tag = tag
  door_info.delta_z = -8

  local out_info = get_mat(skin2.outer, skin.frame_c)

  local frame_info = get_mat(skin2.inner, skin.frame_c)

  local step_info = get_mat(skin.step_w)
  step_info.t_face.light = 0.7

  local key_info = add_pegging(get_mat(skin.key_w or skin2.inner), skin.key_ox, skin.key_oy)


  Trans.set(T)

  Trans.old_quad(step_info, 0,my-DY, long,my+DY, -EXTREME_H, z1+8)

  Trans.old_brush(out_info,
  {
    { x=long, y=my-DY },
    { x=long, y=my+DY, w_face = frame_info.w_face },
    { x=0,    y=my+DY },
    { x=0,    y=my-DY },
  },
  z1+8+door_h, EXTREME_H)

  local KIND = assert(skin.line_kind)

  Trans.old_brush(door_info,
  {
    { x=mx+64, y=my-8, line_kind=KIND, line_tag=tag2 },
    { x=mx+64, y=my+8, line_kind=KIND, line_tag=tag2 },
    { x=mx-64, y=my+8, line_kind=KIND, line_tag=tag2 },
    { x=mx-64, y=my-8, line_kind=KIND, line_tag=tag2 },
  },
  z1+16, EXTREME_H)

  local track_i = add_pegging(get_mat(skin.track))


  -- Heretic statues
  if skin.statue then
    local ey = sel(reversed, -40, 40)
    Trans.entity(skin.statue, 16,     ey, z1)
    Trans.entity(skin.statue, long-16, ey, z1)
  end


  for pass = 1,2 do
    if pass == 2 then Trans.modify("mirror_x", mx) end

    Trans.old_brush(key_info,
    {
      { x=mx-64,    y=my-8, w_face = track_i.w_face },
      { x=mx-64,    y=my+8  },
      { x=mx-64-18, y=my+DY },
      { x=mx-64-18, y=my-DY },
    },
    -EXTREME_H, EXTREME_H)

    Trans.old_brush(out_info,
    {
      { x=mx-64-18, y=my-DY },
      { x=mx-64-18, y=my+DY, w_face = frame_info.w_face },
      { x=0,        y=my+DY },
      { x=0,        y=my-DY },
    },
    -EXTREME_H, EXTREME_H)
  end

  Trans.clear()
end

function Build.quake_door(S, side)
  
  -- FIXME : way incomplete

  local m_ref = gui.q1_add_mapmodel(
  {
    y_face={ tex="edoor01_1" },
    x_face={ tex="met5_1" },
    z_face={ tex="met5_1" },
  },
  -1664+64,  -328-12, 0,
  -1664+128, -328+12, 128)

  gui.add_entity("func_door", 0, 0, 0,
                 { angle="180", sounds="2",
                   model=assert(m_ref)
                 })


  m_ref = gui.q1_add_mapmodel(
  {
    y_face={ tex="edoor01_1" },
    x_face={ tex="met5_1" },
    z_face={ tex="met5_1" },
  },
  -1664+128, -328-12, 0,
  -1664+192, -328+12, 128)

  gui.add_entity("func_door", 0, 0, 0,
                 { angle="0", sounds="2",
                   model=assert(m_ref)
                 })
end


function Build.quake_exit_pad(S, z_top, skin, next_map)
  local x1 = S.x1 + 64
  local y1 = S.y1 + 64

  local x2 = x1 + 64
  local y2 = y1 + 64

  -- trigger is a bit smaller than the pad
  local m_ref = gui.q1_add_mapmodel(
  {
    y_face={ tex="trigger" },
    x_face={ tex="trigger" },
    z_face={ tex="trigger" },
  },
  x1+12,y1+12, z_top, x2-12,y2-12, z_top+256)

  gui.add_entity("trigger_changelevel", 0, 0, 0,
                 { map=next_map, model=assert(m_ref) })

  -- the pad itself

  local info = get_mat(skin.wall or skin.floor, skin.floor)
  info.t_face.light = 0.8

  Trans.old_quad(info, x1,y1, x2,y2, -EXTREME_H, z_top)
end



function Build.lowering_bars(S, side, z_top, skin, tag)

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

  Trans.set(T)

  for i = 1,num_bars do
    local mx = mx1 + (mx2 - mx1) * (i-1) / (num_bars-1)
    local my = 0

    Trans.old_quad(bar_info, mx-bar_w/2, my-bar_w/2, mx+bar_w/2, my+bar_w/2,
        -EXTREME_H, z_top)
  end

  Trans.clear()
end


function Build.ceil_light(S, z2, skin)
  assert(skin)
  
  local w = (skin.w or 64) / 2
  local h = (skin.h or 64) / 2

  local mx = int((S.x1 + S.x2)/2)
  local my = int((S.y1 + S.y2)/2)

  local light_info = get_mat(skin.lite_f)
  light_info.b_face.light = 0.90

  Trans.old_brush(light_info,
  {
    { x = mx+w, y = my-h },
    { x = mx+w, y = my+h },
    { x = mx-w, y = my+h },
    { x = mx-w, y = my-h },
  },
  z2-12, EXTREME_H)


  local trim_info = get_mat(skin.trim)
  trim_info.b_face.light = 0.72

  Trans.old_brush(trim_info,
  {
    { x = mx-w,     y = my-(h+8) },
    { x = mx-w,     y = my+(h+8) },
    { x = mx-(w+8), y = my+(h+8) },
    { x = mx-(w+8), y = my-(h+8) },
  },
  z2-16, EXTREME_H)

  Trans.old_brush(trim_info,
  {
    { x = mx+(w+8), y = my-(h+8) },
    { x = mx+(w+8), y = my+(h+8) },
    { x = mx+w,     y = my+(h+8) },
    { x = mx+w,     y = my-(h+8) },
  },
  z2-16, EXTREME_H)

  Trans.old_brush(trim_info,
  {
    { x = mx+(w+8), y = my-(h+8) },
    { x = mx+(w+8), y = my-h },
    { x = mx-(w+8), y = my-h },
    { x = mx-(w+8), y = my-(h+8) },
  },
  z2-16, EXTREME_H)

  Trans.old_brush(trim_info,
  {
    { x = mx+(w+8), y = my+h },
    { x = mx+(w+8), y = my+(h+8) },
    { x = mx-(w+8), y = my+(h+8) },
    { x = mx-(w+8), y = my+h },
  },
  z2-16, EXTREME_H)
 

--[[ connecting spokes....

  Trans.old_brush(trim_info,
  {
    { x = mx+4, y = my+40 },
    { x = mx+4, y = S.y2  },
    { x = mx-4, y = S.y2  },
    { x = mx-4, y = my+40 },
  },
  z2-10, EXTREME_H)

  Trans.old_brush(trim_info,
  {
    { x = mx+4, y = S.y1  },
    { x = mx+4, y = my-40 },
    { x = mx-4, y = my-40 },
    { x = mx-4, y = S.y1  },
  },
  z2-10, EXTREME_H)

  Trans.old_brush(trim_info,
  {
    { x = mx-40, y = my-4, },
    { x = mx-40, y = my+4, },
    { x = S.x1 , y = my+4, },
    { x = S.x1 , y = my-4, },
  },
  z2-10, EXTREME_H)

  Trans.old_brush(trim_info,
  {
    { x = S.x2 , y = my-4, },
    { x = S.x2 , y = my+4, },
    { x = mx+40, y = my+4, },
    { x = mx+40, y = my-4, },
  },
  z2-10, EXTREME_H)
 
--]]
end


function Build.detailed_hall(S, side, z1, z2, skin)

  local function compat_neighbor(side)
    local N = S:neighbor(side)

    if not N or not N.room then return false end

    if N.room == S.room then return true end

    if N.room.hallway then return true end

    return false
  end

  local function get_hall_coords(thickness, pad, impassible)

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

    if impassible then
      each c in res do c.line_flags = 1 end
    end

    return res
  end


  if LEVEL.hall_trim then
    Trans.old_brush(get_mat(skin.trim2),
        get_hall_coords(32, 8, true), -EXTREME_H, z1 + 32)

    Trans.old_brush(get_mat(skin.trim2),
        get_hall_coords(32, 8, true), z2 - 32, EXTREME_H)
  end


  Trans.old_brush(get_mat(skin.trim1),
      get_hall_coords(64, 8), -EXTREME_H, z1 + 6)

  Trans.old_brush(get_mat(skin.trim1),
      get_hall_coords(64, 8), z2 - 6, EXTREME_H)


  Trans.old_brush(get_mat(skin.wall),
      get_hall_coords(24, 0), -EXTREME_H, EXTREME_H)


  -- TODO : corners
end


-- NOT ACTUALLY USED:
function Build.weird_hall(S, side, skin, z1, z2)

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


  local info = get_mat(skin.wall)  -- e.g. SHAWN2

  Trans.old_brush(info, get_hall_coords(24), -EXTREME_H, EXTREME_H)

  Trans.old_brush(info, get_hall_coords(32), -EXTREME_H, z1 + 32)
  Trans.old_brush(info, get_hall_coords(32), z2 - 32, EXTREME_H)

  Trans.old_brush(info, get_hall_coords(48), -EXTREME_H, z1 + 18)
  Trans.old_brush(info, get_hall_coords(48), z2 - 18, EXTREME_H)

  Trans.old_brush(info, get_hall_coords(64), -EXTREME_H, z1 + 6)
  Trans.old_brush(info, get_hall_coords(64), z2 - 6, EXTREME_H)

end


function Build.diagonal(S, side, info, floor_h, ceil_h)

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


  Trans.old_brush(info,
      diagonal_coords(side,x1,y1,x2,y2),
      ceil_h or -EXTREME_H, floor_h or EXTREME_H)
end


function Build.debug_arrow(S, dir, f_h)
 
  local mx = int((S.x1 + S.x2)/2)
  local my = int((S.y1 + S.y2)/2)

  local dx, dy = geom.delta(dir)
  local ax, ay = geom.delta(geom.RIGHT[dir])

  Trans.old_brush(get_mat("FWATER1"),
  {
    { x = mx - ax*20,  y = my - ay * 20  },
    { x = mx + ax*20,  y = my + ay * 20  },
    { x = mx + dx*100, y = my + dy * 100 },
  },
  -EXTREME_H, f_h + 8)
end


function Build.curved_hall(steps, corn_x, corn_y,
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

  --| Build.curved_hall |--

  assert(steps >= 2)

  for i = 1,steps do
    local p0 = (i-1)/steps
    local p1 = (i  )/steps

    local f_h = x_h + (y_h - x_h) * (i-1) / (steps-1)
    local c_h = f_h + gap_h

    Trans.old_brush(wall_info, arc_coords(p0,p1, dx0,dx1, dy0,dy1), -EXTREME_H,EXTREME_H)
    Trans.old_brush(wall_info, arc_coords(p0,p1, dx2,dx3, dy2,dy3), -EXTREME_H,EXTREME_H)

    local coords = arc_coords(p0,p1, dx1,dx2, dy1,dy2)

    Trans.old_brush(floor_info, coords, -EXTREME_H, f_h)
    Trans.old_brush(ceil_info,  coords, c_h, EXTREME_H)
  end
end


function Build.ramp_x(skin, bx1,bx2,y1, tx1,tx2,y2, az,bz, exact)
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

    Trans.old_brush(skin,
    {
      { x=bx4, y=y1 },
      { x=tx4, y=y2 },
      { x=tx3, y=y2 },
      { x=bx3, y=y1 },
    },
    -EXTREME_H, z);
  end
end


function Build.ramp_y(skin, x1,ly1,ly2, x2,ry1,ry2, az,bz, exact)
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

    Trans.old_brush(skin,
    {
      { x=x2, y=ry3 },
      { x=x2, y=ry4 },
      { x=x1, y=ly4 },
      { x=x1, y=ly3 },
    },
    -EXTREME_H, z);
  end
end


function Build.niche_stair(S, skin, skin2)
  local step_info = get_mat(skin.side_w or skin.step_w, skin.top_f)

  local front_info = add_pegging(get_mat(skin.step_w))

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

  Trans.set(T)

  Trans.old_quad(niche_info, 0,0, W,deep, -EXTREME_H, z2)
  Trans.old_quad(niche_info, long-W,0, long,deep, -EXTREME_H, z2)
  Trans.old_quad(niche_info, W,deep-HB, long-W,deep, -EXTREME_H, z2)


  if S.stair_z1 > S.stair_z2 then
    local f_tex = S.f_tex or S.room.main_tex
    local w_tex = S.w_tex or S.room.main_tex

    local S2 = S:neighbor(S.stair_dir)
    if S2 and S2.room == S.room and S2.kind == "walk" and S2.f_tex then
      f_tex = S2.f_tex
    end

    Trans.old_quad(get_mat(w_tex, f_tex), W,0, long-W,HF, -EXTREME_H, z1)
  else
    HF = 0
  end


  local steps = int(math.abs(z2 - z1) / 15 + 0.9)

  if steps < 2 then steps = 2 end

  for i = 0,steps-1 do 
    local z = z1 + (z2 - z1) * (i+1) / (steps+1)

    local by = int(HF + (deep-HF-HB) * (i)   / steps)
    local ty = int(HF + (deep-HF-HB) * (i+1) / steps)

    Trans.old_brush(step_info,
    {
      { x=long-W, y=by },
      { x=long-W, y=ty, w_face = front_info.w_face },
      { x=     W, y=ty },
      { x=     W, y=by, w_face = front_info.w_face },
    },
    -EXTREME_H, int(z));
  end

  Trans.clear()
end


function Build.tall_curved_stair(S, skin, x_side,y_side, x_h,y_h)
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

  local w_tex = S.w_tex or S.room.main_tex

  local info = get_mat(w_tex)

  Build.curved_hall(steps, corn_x, corn_y,
                    dx0, dx1, dx2, dx3,
                    dy0, dy1, dy2, dy3,
                    y_h, x_h, 256,
                    info, step_info, info)

  -- fill in the 16x16 gap
  local gx1 = corn_x
  local gy1 = corn_y
  local gx2 = corn_x
  local gy2 = corn_y

  if x_side == 6 then gx1 = gx1 - 20 else gx2 = gx2 + 20 end
  if y_side == 8 then gy1 = gy1 - 20 else gy2 = gy2 + 20 end
 
  Trans.old_quad(info, gx1,gy1,gx2,gy2, -EXTREME_H, EXTREME_H)
end


function Build.low_curved_stair(S, skin, x_side,y_side, x_h,y_h)
  local step_info = get_mat(skin.step_w, skin.top_f)
  add_pegging(step_info)

  -- create transform
  local T =
  {
    add_x = S.x1,
    add_y = S.y1,
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


  Trans.set(T)


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
    Trans.old_brush(step_info,
    {
      { x=fx1, y=fy1 },
      { x=fx2, y=fy2 },
      { x=cx2, y=cy2 },
      { x=cx1, y=cy1 },
    },
    -EXTREME_H, z)
  end


  local mat_info = get_mat("METAL")

  local z3 = math.max(x_h, y_h)

  Trans.old_quad(mat_info, 0,0, 32,32, -EXTREME_H, z3)

  Trans.old_quad(mat_info, 0,deep-bord_W, long,deep, -EXTREME_H, z3)
  Trans.old_quad(mat_info, long-bord_W,0, long,deep, -EXTREME_H, z3)

  Trans.clear()
end


-- NOT ACTUALLY USED:
function Build.outdoor_ramp_down(ST, f_tex, w_tex)
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

  local info = get_mat(w_tex, f_tex)

gui.debugf("Build.outdoor_ramp_down: S:(%d,%d) conn_dir:%d\n", ST.S.sx, ST.S.sy, conn_dir)

  if conn_dir == 6 then
    ix1 = ix2-96
    Build.ramp_x(info, ox1,ix1,oy1, ox1,ix1,oy2, oh, ih, "exact")

  elseif conn_dir == 4 then
    ix2 = ix1 + 96
    Build.ramp_x(info, ix2,ox2,oy1, ix2,ox2,oy2, ih, oh, "exact")

  elseif conn_dir == 8 then
    iy1 = iy2-96
    Build.ramp_y(info, ox1,oy1,iy1, ox2,oy1,iy1, oh, ih, "exact")

  elseif conn_dir == 2 then
    iy2 = iy1 + 96
    Build.ramp_y(info, ox1,iy2,oy2, ox2,iy2,oy2, ih, oh, "exact")
  end


  if geom.is_horiz(conn_dir) then
    if iy2+64 < oy2 then
      Build.ramp_y(info, ox1,iy2,oy2, ox2,iy2,oy2, ih, oh, "exact")
    end
    if iy1-64 > oy1 then
      Build.ramp_y(info, ox1,oy1,iy1, ox2,oy1,iy1, oh, ih, "exact")
    end
  else -- is_vert
    if ix2+64 < ox2 then
      Build.ramp_x(info, ix2,ox2,oy1, ix2,ox2,oy2, ih, oh, "exact")
    end
    if ix1-64 > ox1 then
      Build.ramp_x(info, ox1,ix1,oy1, ox1,ix1,oy2, oh, ih, "exact")
    end
  end

  ST.done = true
end

-- NOT ACTUALLY USED:
function Build.outdoor_ramp_up(ST, f_tex, w_tex)
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

  local info = get_mat(w_tex, f_tex)

gui.debugf("Build.outdoor_ramp_up: S:(%d,%d) conn_dir:%d\n", ST.S.sx, ST.S.sy, conn_dir)

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

    Trans.old_brush(info,
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


function Build.lift(S, skin, skin2, tag)
  assert(skin.walk_kind)
  assert(skin.switch_kind)

  local lift_info = add_pegging(get_mat(skin.side_w, skin.top_f))

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
       (geom.is_perpendic(dir, side) and N and N.room == S.room
        and N.floor_h and N.floor_h < high_z - 15)
    then
      switch_dirs[dir] = true
    end
  end


  local f_tex = skin2.floor
  local w_tex = skin2.wall

  local S2 = S:neighbor(10-side)
  if S2 and S2.room == S.room and S2.kind == "walk" and S2.f_tex then
    f_tex = S2.f_tex
  end


  local sw_info = get_mat(skin.side_w)

  local coords = get_wall_coords(S, side, 128)

  -- FIXME: there must be a better way....
  coords[1].line_kind = sel(switch_dirs[6], skin.switch_kind, skin.walk_kind)
  coords[2].line_kind = sel(switch_dirs[8], skin.switch_kind, skin.walk_kind)
  coords[3].line_kind = sel(switch_dirs[4], skin.switch_kind, skin.walk_kind)
  coords[4].line_kind = sel(switch_dirs[2], skin.switch_kind, skin.walk_kind)

  if switch_dirs[6] then coords[1].w_face = sw_info.w_face end
  if switch_dirs[8] then coords[2].w_face = sw_info.w_face end
  if switch_dirs[4] then coords[3].w_face = sw_info.w_face end
  if switch_dirs[2] then coords[4].w_face = sw_info.w_face end

  coords[1].line_tag = tag
  coords[2].line_tag = tag
  coords[3].line_tag = tag
  coords[4].line_tag = tag

  lift_info.sec_tag = tag

  Trans.old_brush(lift_info, coords, -EXTREME_H, high_z - 8)


  local front_coords = get_wall_coords(S, 10-side, 64)
  local front_info   = get_mat(w_tex, f_tex)

  Trans.old_brush(front_info, front_coords, -EXTREME_H, low_z);
end


function Build.pillar(S, z1, z2, skin)
  
  local mx = int((S.x1 + S.x2)/2)
  local my = int((S.y1 + S.y2)/2)
  local mz = int((z1 + z2)/2)

  Trans.old_brush(add_pegging(get_mat(skin.pillar)),
  {
    { x=mx+32, y=my-32 }, { x=mx+32, y=my+32 },
    { x=mx-32, y=my+32 }, { x=mx-32, y=my-32 },
  },
  -EXTREME_H, EXTREME_H)

  for pass = 1,2 do
--[[
    Trans.old_brush(get_mat(skin.trim2),
    {
      { x=mx+40, y=my-40 }, { x=mx+40, y=my+40 },
      { x=mx-40, y=my+40 }, { x=mx-40, y=my-40 },
    },
    sel(pass == 1, -EXTREME_H, z2-32),
    sel(pass == 2,  EXTREME_H, z1+32)
    )
--]]
    Trans.old_brush(get_mat(skin.trim1),
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


function Build.corner_beam(S, side, skin)
  -- FIXME: at this stage the thick[] values are not decided yet

  local x1 = S.x1 + 24 -- S.thick[4]
  local y1 = S.y1 + 24 -- S.thick[2]
  local x2 = S.x2 - 24 -- S.thick[6]
  local y2 = S.y2 - 24 -- S.thick[8]

  local w = assert(skin.w)

  if side == 1 or side == 7 then x2 = x1 + w else x1 = x2 - w end
  if side == 1 or side == 3 then y2 = y1 + w else y1 = y2 - w end
  
  local info = get_mat(skin.beam_w, skin.beam_f)

  add_pegging(info, skin.x_offset, skin.y_offset, 0)

  Trans.old_quad(info, x1,y1, x2,y2, -EXTREME_H, EXTREME_H)
end


function Build.cross_beam(S, dir, w, beam_z, mat)
  local x1, y1 = S.x1, S.y1
  local x2, y2 = S.x2, S.y2

  -- FIXME: at this stage the thick[] values are not decided yet
  if S.sx == S.room.sx1 then x1 = x1 + 24 elseif geom.is_horiz(dir) then x1 = x1 - 24 end
  if S.sx == S.room.sx2 then x2 = x2 - 24 elseif geom.is_horiz(dir) then x2 = x2 + 24 end
  if S.sy == S.room.sy1 then y1 = y1 + 24 elseif geom.is_vert(dir)  then y1 = y1 - 24 end
  if S.sy == S.room.sy2 then y2 = y2 - 24 elseif geom.is_vert(dir)  then y2 = y2 + 24 end

  local mx = int((x1 + x2) / 2)
  local my = int((y1 + y2) / 2)

  local coords
  if geom.is_vert(dir) then
    coords = Trans.rect_coords(mx-w/2, y1, mx+w/2, y2)
  else
    coords = Trans.rect_coords(x1, my-w/2, x2, my+w/2)
  end

  Trans.old_brush(get_mat(mat), coords, beam_z, EXTREME_H)
end


function Build.small_switch(S, dir, f_h, skin, tag)

  local DT, long = get_transform_for_seed_side(S, 10-dir)
  local deep = long

  local mx = int(long / 2)
  local my = int(deep / 2)


  local info = get_mat(skin.side_w)
  info.t_face.light = 0.66

  local switch_info = get_mat(skin.switch_w)
  add_pegging(switch_info, skin.x_offset, skin.y_offset)

  local base_h   = skin.base_h or 12
  local switch_h = skin.switch_h or 64

  Trans.set(DT)

  Trans.old_brush(info,
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

  Trans.old_brush(info,
  {
    { x=mx+32, y=my-8 },
    { x=mx+32, y=my+8, w_face = switch_info.w_face, line_kind=assert(skin.line_kind), line_tag=tag },
    { x=mx-32, y=my+8 },
    { x=mx-32, y=my-8 },
  },
  -EXTREME_H, f_h+base_h+switch_h)

  Trans.clear()
end

                                      
function Build.exit_pillar(S, z1, skin)
  local DT, long = get_transform_for_seed_side(S, 8)

  local mx = int((S.x1 + S.x2)/2)
  local my = int((S.y1 + S.y2)/2)

  Trans.old_brush(add_pegging(get_mat(skin.switch_w)),
  {
    { x=mx+32, y=my-32, line_kind=skin.line_kind or 11 },
    { x=mx+32, y=my+32, line_kind=skin.line_kind or 11 },
    { x=mx-32, y=my+32, line_kind=skin.line_kind or 11 },
    { x=mx-32, y=my-32, line_kind=skin.line_kind or 11 },
  },
  -EXTREME_H, z1 + skin.h)

--- NUKEM:  gui.add_entity("142", mx, my, z1+96, { lo_tag=-1 });


  if skin.exitside then
    local info = get_mat(skin.exitside)

    local exit_info = get_mat(skin.exit_w)
    add_pegging(exit_info)

    info.t_face.light = 0.82
   
    Trans.set(DT)

    local pos = long/2 - 68

    for pass=1,4 do
      Trans.modify("mirror_x", sel((pass % 2)==1, nil, long/2))
      Trans.modify("mirror_y", sel(pass >= 3,     nil, long/2))

      Trans.old_brush(info,
      {
        { x=pos+8,  y=pos+24 },
        { x=pos+0,  y=pos+16, w_face = exit_info.w_face },
        { x=pos+28, y=pos+0  },
        { x=pos+36, y=pos+8  },
      },
      -EXTREME_H, z1 + skin.exit_h)
    end

    Trans.clear()
  end
end


function Build.outdoor_exit_switch(S, dir, f_h, skin)

  local DT, long = get_transform_for_seed_side(S, 10-dir)
  local deep = long

  local mx = int(long / 2)
  local my = int(deep / 2)

  
  Trans.set(DT)


  Trans.old_quad(get_mat(skin.podium), 32,32, long-32,deep-32,
      -EXTREME_H, f_h+12)


  local info = get_mat(skin.base)

  local switch_info = get_mat(skin.switch_w)
  add_pegging(switch_info, skin.x_offset, skin.y_offset)

  Trans.old_brush(info,
  {
    { x=mx-36, y=my-24 },
    { x=mx+36, y=my-24 },
    { x=mx+44, y=my-16 },
    { x=mx+44, y=my+16 },
    { x=mx+36, y=my+24 },
    { x=mx-36, y=my+24 },
    { x=mx-44, y=my+16 },
    { x=mx-44, y=my-16 },
  },
  -EXTREME_H, f_h+16)

  Trans.old_brush(info,
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
    Trans.modify("mirror_x", sel((pass % 2)==1, nil, long/2))
    Trans.modify("mirror_y", sel(pass >= 3,     nil, deep/2))

    Trans.old_brush(info,
    {
      { x=48+8,  y=40+24 },
      { x=48+0,  y=40+16, w_face = exit_info.w_face },
      { x=48+28, y=40+0  },
      { x=48+36, y=40+8  },
    },
    -EXTREME_H, f_h+12+16)
  end

  Trans.clear()
end


function Build.small_exit(R, xt_info, skin, skin2)
  assert(xt_info)
  assert(#R.conns == 1)

  local C = R.conns[1]
  local S = C:seed(R)
  local T = C:seed(C:neighbor(R))

  gui.debugf("Building small exit @ %s\n", S:tostr())

  local side = S.conn_dir

  local f_h = C.conn_h or T.floor_h or T.room.floor_h or 0
  local c_h = f_h + 128

  local w_tex = rand.key_by_probs(xt_info.walls)
  local f_tex = rand.key_by_probs(xt_info.floors)
  local c_tex = rand.key_by_probs(xt_info.ceilings)

  local inner_info = get_mat(w_tex, f_tex, c_tex)

  local out_info = get_mat(skin2.wall, skin2.floor, skin2.ceil)


  local DT, long = get_transform_for_seed_side(S, side)
  local mx = int(long / 2)

  Trans.set(DT)

  Trans.old_quad(out_info, 8,0,   long-8,48, -EXTREME_H, f_h)
  Trans.old_quad(out_info, 8,-24, long-8,48, c_h, EXTREME_H)

  Trans.old_quad(inner_info, 8,48, long-8,long-8, -EXTREME_H, f_h)
  Trans.old_quad(inner_info, 8,48, long-8,long-8, c_h, EXTREME_H)

  Trans.clear()


  S.thick[side] = 80

  Trans.old_brush(inner_info, get_wall_coords(S, geom.RIGHT[side], 32, 8),
                    -EXTREME_H, EXTREME_H)
  Trans.old_brush(inner_info, get_wall_coords(S, geom.LEFT[side], 32, 8),
                    -EXTREME_H, EXTREME_H)


  -- make door

  local door_info = add_pegging(get_mat(skin.door))
  door_info.delta_z = -8

  Trans.set(DT)

  Trans.old_brush(door_info,
  {
    { x=mx+32, y=48, line_kind=1 },
    { x=mx+32, y=64, line_kind=1 },
    { x=mx-32, y=64, line_kind=1 },
    { x=mx-32, y=48, line_kind=1 },
  },
  f_h+8, EXTREME_H)

  local frame_i = get_mat(skin.frame_c)
  inner_info.b_face = frame_i.b_face

  Trans.old_brush(inner_info,
  {
    { x=mx+32, y=32 },
    { x=mx+32, y=80 },
    { x=mx-32, y=80 },
    { x=mx-32, y=32, w_face = out_info.w_face },
  },
  f_h+72, EXTREME_H)

  local exit_side = get_mat(skin.exitside)
  local exit_info = add_pegging(get_mat(skin.exit))

  local key_i   = add_pegging(get_mat(skin.key_w))
  local track_i = add_pegging(get_mat(skin.track))

  assert(not C.lock)

  for pass = 1,2 do
    if pass == 2 then Trans.modify("mirror_x", mx) end

    Trans.old_brush(out_info,
    {
      { x=0,     y=80  },
      { x=0,     y=-24 },
      { x=mx-96, y=-24 },
      { x=mx-32, y=32,  w_face = key_i.w_face },
      { x=mx-32, y=48,  w_face = track_i.w_face },
      { x=mx-32, y=64,  w_face = key_i.w_face },
      { x=mx-32, y=80,  w_face = inner_info.w_face },
    },
    -EXTREME_H, EXTREME_H)

    Trans.old_brush(exit_side,
    {
      { x=mx-68, y= -8 },
      { x=mx-60, y=-16, w_face = exit_info.w_face },
      { x=mx-32, y=  0 },
      { x=mx-40, y=  8 },
    },
    c_h-16, EXTREME_H)
  end

  Trans.clear()


  -- make switch

  local WT
  WT, long = get_transform_for_seed_side(S, 10-side)

  mx = int(long / 2)
  local swit_W = 64

  local switch_i = add_pegging(get_mat(skin.switch), 0, 0, 0)
  local break_i  = add_pegging(get_mat(skin.break_w))

  Trans.set(WT)

  Trans.old_brush(inner_info,
  {
    { x=long-8, y=8 },
    { x=long-8, y=32 },
    { x=mx+swit_W/2+8, y=32, w_face = break_i.w_face },
    { x=mx+swit_W/2,   y=32, w_face = switch_i.w_face, line_kind=11 },
    { x=mx-swit_W/2,   y=32, w_face = break_i.w_face },
    { x=mx-swit_W/2-8, y=32 },
    { x=8, y=32 },
    { x=8, y=8 },
  },
  -EXTREME_H, EXTREME_H)


  assert(not C.already_made_lock)
  C.already_made_lock = true


  if skin.items then
    Trans.entity(rand.pick(skin.items), mx, 96, f_h)
  end

  Trans.clear()
end


function Build.window(S, side, width, mid_w, z1, z2, skin)
  local inner_info = get_mat(skin.wall, skin.floor)

  local side_info = get_mat(skin.side_t)

  local wall_info = inner_info
  if skin.facade then
    wall_info = get_mat(skin.facade)
  end

  local T, long, deep = get_transform_for_seed_side(S, side)

  local mx = int(long/2)

  Trans.set(T)

  -- top and bottom
  local coords =
  {
    { x=mx-width/2, y=0 },
    { x=mx+width/2, y=0 },
    { x=mx+width/2, y=deep, w_face=inner_info.w_face },
    { x=mx-width/2, y=deep },
  }

  Trans.old_brush(wall_info, coords, -EXTREME_H, z1)
  Trans.old_brush(wall_info, coords, z2,  EXTREME_H)


  -- center piece
  if mid_w then
    Trans.old_brush(wall_info,
    {
      { x=mx+mid_w/2, y=0,    w_face = side_info.w_face },
      { x=mx+mid_w/2, y=deep, w_face = inner_info.w_face },
      { x=mx-mid_w/2, y=deep, w_face = side_info.w_face },
      { x=mx-mid_w/2, y=0 },
    },
    -EXTREME_H, EXTREME_H)
  end


  -- sides pieces
  Trans.old_brush(wall_info,
  {
    { x=mx-width/2, y=0,    w_face = side_info.w_face },
    { x=mx-width/2, y=deep, w_face = inner_info.w_face },
    { x=0, y=deep },
    { x=0, y=0 },
  },
  -EXTREME_H, EXTREME_H)

  Trans.old_brush(wall_info,
  {
    { x=long, y=0 },
    { x=long, y=deep, w_face = inner_info.w_face },
    { x=mx+width/2, y=deep, w_face = side_info.w_face },
    { x=mx+width/2, y=0 },
  },
  -EXTREME_H, EXTREME_H)

  Trans.clear()
end


function Build.picture(S, side, z1, z2, skin)

  local count = skin.count or 1

  local T, long, deep = get_transform_for_seed_side(S, side)

  local wall_info = get_mat(skin.wall, skin.floor)

  local side_info = wall_info
  if skin.side_t then side_info = get_mat(skin.side_t) end

  local pic_info = get_mat(skin.pic_w)
  add_pegging(pic_info, skin.x_offset, skin.y_offset, skin.peg or 0)


  if not z2 then
    z2 = z1 + assert(skin.height)
  end

  local WD  = assert(skin.width)
  local HT  = assert(skin.depth)
  local gap = skin.gap or WD

  local total_w = count * WD + (count - 1) * gap
  if total_w > SEED_SIZE-16 then
    error("Picture is too wide: " .. tostring(skin.pic_w))
  end

  local mx = int(long/2)
  local my = deep - HT


  Trans.set(T)

  -- wall around picture
  Trans.old_quad(wall_info, 0,0, long,my-4, -EXTREME_H, EXTREME_H)
  Trans.old_quad(wall_info, 0,my-4, 8,deep, -EXTREME_H, EXTREME_H)
  Trans.old_quad(wall_info, long-8,my-4, long,deep, -EXTREME_H, EXTREME_H)


  for n = 0,count do
    local x = mx-total_w/2 + n * (WD+gap)

    -- picture itself
    if n < count then
      Trans.old_brush(pic_info,
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
    Trans.old_brush(wall_info,
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

  local coords = Trans.rect_coords(mx-total_w/2,my-4, mx+total_w/2,deep)

  each c in coords do c.line_flags = 1 end

  Trans.old_brush(floor_info, coords, -EXTREME_H, z1)
  Trans.old_brush(floor_info, coords, z2,  EXTREME_H)

  Trans.clear()
end


function Build.pedestal(S, z1, skin)
  local mx = int((S.x1+S.x2) / 2)
  local my = int((S.y1+S.y2) / 2)

  local info = get_mat(skin.wall or skin.floor, skin.floor)
  info.t_face.light = 0.7

  add_pegging(info, skin.x_offset, skin.y_offset, skin.peg)

  Trans.old_quad(info, mx-32,my-32, mx+32,my+32, -EXTREME_H, z1+8)
end

function Build.lowering_pedestal(S, z1, skin)
  local mx = int((S.x1+S.x2) / 2)
  local my = int((S.y1+S.y2) / 2)

  local tag = Plan_alloc_id("tag")

  local info = get_mat(skin.wall or skin.floor, skin.floor)

  add_pegging(info, skin.x_offset, skin.y_offset, skin.peg)
  info.sec_tag = tag

  Trans.old_brush(info,
  {
    { x=mx+32, y=my-32, line_kind=skin.line_kind, line_tag=tag },
    { x=mx+32, y=my+32, line_kind=skin.line_kind, line_tag=tag },
    { x=mx-32, y=my+32, line_kind=skin.line_kind, line_tag=tag },
    { x=mx-32, y=my-32, line_kind=skin.line_kind, line_tag=tag },
  },
  -EXTREME_H, z1)
end


function Build.crate(x, y, z_top, skin, is_outdoor)
  local info = add_pegging(get_mat(skin.side_w))

  local coords = Trans.rect_coords(x-32,y-32, x+32,y+32)

  Trans.old_brush(info, coords, -EXTREME_H, z_top)

  if PARAM.outdoor_shadows and is_outdoor then
    Trans.old_brush(get_light(-1), shadowify_brush(coords, 20), -EXTREME_H, z_top-4)
  end
end


function Build.raising_start(S, face_dir, z1, skin)
  local info = get_mat(skin.f_tex)

  local sw_info = add_pegging(get_mat(skin.switch_w))

  local tag = Plan_alloc_id("tag")

  for side = 2,8,2 do
    local T, long, deep = get_transform_for_seed_side(S, side, 48)

    local mx = int(long / 2)

    Trans.set(T)

    if side == face_dir then
      Trans.old_brush(info,
      {
        { x=long,  y=0 },
        { x=long,  y=deep },
        { x=mx+32, y=deep, w_face=sw_info.w_face, line_kind=18, line_tag=tag },
        { x=mx-32, y=deep },
        { x=0,     y=deep },
        { x=0,     y=0 },
      },
      -EXTREME_H, z1)
    
    else
      Trans.old_quad(info, 0,0, long,deep, -EXTREME_H, z1)
    end

    Trans.clear()
  end


  info.sec_tag = tag

  local T, long, deep = get_transform_for_seed_center(S)

  Trans.set(T)

  Trans.old_quad(info, 0,0, long,deep, -EXTREME_H, z1 - 128)

  Trans.clear()
end


function Build.popup_trap(S, z, skin, monster)
  local info = get_mat(skin.wall, skin.floor)

  for side = 2,8,2 do
    S.thick[side] = S.thick[side] + 4

    local T, long, deep = get_transform_for_seed_side(S, side)

    Trans.set(T)

    Trans.old_brush(info,
    {
      { x=long, y=0 },
      { x=long, y=deep, w_face={ tex="-" } },
      { x=0,    y=deep },
      { x=0,    y=0 },
    },
    -EXTREME_H, z)

    Trans.clear()
  end

  info.sec_tag = Plan_alloc_id("tag")

  local T, long, deep = get_transform_for_seed_center(S)

  Trans.set(T)

  Trans.old_brush(info,
  {
    { x=long, y=0,    line_kind=19, line_tag=info.sec_tag },
    { x=long, y=deep, line_kind=19, line_tag=info.sec_tag },
    { x=0,    y=deep, line_kind=19, line_tag=info.sec_tag },
    { x=0,    y=0,    line_kind=19, line_tag=info.sec_tag },
  },
  -EXTREME_H, z - 256)

  Trans.entity(monster, long/2, deep/2, z1, { ambush=1 })

  Trans.clear()
end


function Build.stairwell(R, skin)
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

    Build.curved_hall(steps, ax, by,
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
      Build.curved_hall(steps, corn_x, corn_y,
                        -dx0, -dx1, -dx2, -dx3,
                        dy0, dy1, dy2, dy3,
                        h1, h2, 128,
                        wall_info, floor_info, ceil_info)

      -- right side
      Build.curved_hall(steps, corn_x, corn_y,
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
      Build.curved_hall(steps, corn_x, corn_y,
                        dx0, dx1, dx2, dx3,
                        -dy0, -dy1, -dy2, -dy3,
                        h2, h1, 128,
                        wall_info, floor_info, ceil_info)

      -- top section
      Build.curved_hall(steps, corn_x, corn_y,
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
      Build.curved_hall(steps, corn_x, corn_y,
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

      Build.curved_hall(steps, corn_x, corn_y,
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
      Build.curved_hall(steps, corn_x, corn_y,
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

      Build.curved_hall(steps, corn_x, corn_y,
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

      Trans.old_brush(wall_info, step_coords(p0,p1, 0/6, 1/6), -EXTREME_H,EXTREME_H)
      Trans.old_brush(wall_info, step_coords(p0,p1, 5/6, 6/6), -EXTREME_H,EXTREME_H)

      local coords = step_coords(p0,p1, 1/6, 5/6)

      Trans.old_brush(floor_info, coords, -EXTREME_H,f_h)
      Trans.old_brush(ceil_info,  coords,  c_h,EXTREME_H)
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

  if geom.is_perpendic(AS.conn_dir, BS.conn_dir) then
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
end


function Build.sky_hole(sx1,sy1, sx2,sy2, kind, mw, mh,
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

  -- ensure ceiling brushes don't interfere with facades
  if sx1 == SEEDS[sx1][sy1][1].room.sx1 then ox1 = ox1 + 4 end
  if sy1 == SEEDS[sx1][sy1][1].room.sy1 then oy1 = oy1 + 4 end
  if sx2 == SEEDS[sx2][sy2][1].room.sx2 then ox2 = ox2 - 4 end
  if sy2 == SEEDS[sx2][sy2][1].room.sy2 then oy2 = oy2 - 4 end


  if inner_info then
    Trans.old_quad(inner_info, x1,y1,x2,y2, inner_z, EXTREME_H)
  end


  Trans.old_quad(outer_info, ox1,oy1,  x1,oy2, outer_z, EXTREME_H)
  Trans.old_quad(outer_info,  x2,oy1, ox2,oy2, outer_z, EXTREME_H)
  Trans.old_quad(outer_info,  x1,oy1,  x2, y1, outer_z, EXTREME_H)
  Trans.old_quad(outer_info,  x1, y2,  x2,oy2, outer_z, EXTREME_H)

  if kind == "round" then
    Trans.old_brush(outer_info,
                      diagonal_coords(1, x1, y1, x1+diag_w, y1+diag_h),
                      outer_z, EXTREME_H)

    Trans.old_brush(outer_info,
                      diagonal_coords(3, x2-diag_w, y1, x2, y1+diag_h),
                      outer_z, EXTREME_H)

    Trans.old_brush(outer_info,
                      diagonal_coords(7, x1, y2-diag_h, x1+diag_w, y2),
                      outer_z, EXTREME_H)

    Trans.old_brush(outer_info,
                      diagonal_coords(9, x2-diag_w, y2-diag_h, x2, y2),
                      outer_z, EXTREME_H)
  end


  -- TRIM --

  if trim then trim = get_mat(trim) end

  local w = 8 * int(1 + math.max(mw,mh) / 120)

  local trim_h = 4 * int(1 + math.min(mw,mh) / 120)

  if trim and kind == "square" then
    Trans.old_quad(trim, x1-w,y1-w, x1+4,y2+w, outer_z-trim_h, EXTREME_H)
    Trans.old_quad(trim, x2-4,y1-w, x2+w,y2+w, outer_z-trim_h, EXTREME_H)

    Trans.old_quad(trim, x1+4,y1-w, x2-4,y1+4, outer_z-trim_h, EXTREME_H)
    Trans.old_quad(trim, x1+4,y2-4, x2-4,y2+w, outer_z-trim_h, EXTREME_H)
  end

  if trim and kind == "round" then
    Trans.old_quad(trim, x1-w,y1+diag_h, x1+4,y2-diag_h, outer_z-trim_h, EXTREME_H)
    Trans.old_quad(trim, x2-4,y1+diag_h, x2+w,y2-diag_h, outer_z-trim_h, EXTREME_H)

    Trans.old_quad(trim, x1+diag_w,y1-w, x2-diag_w,y1+4, outer_z-trim_h, EXTREME_H)
    Trans.old_quad(trim, x1+diag_w,y2-4, x2-diag_w,y2+w, outer_z-trim_h, EXTREME_H)

    Trans.old_brush(trim,  -- top left
    {
      { x=x1-w, y=y2-diag_h },
      { x=x1+4, y=y2-diag_h },
      { x=x1+diag_w, y=y2-4 },
      { x=x1+diag_w, y=y2+w },
    },
    outer_z-trim_h, EXTREME_H)

    Trans.old_brush(trim,  -- top right
    {
      { x=x2-diag_w, y=y2+w },
      { x=x2-diag_w, y=y2-4 },
      { x=x2-4, y=y2-diag_h },
      { x=x2+w, y=y2-diag_h },
    },
    outer_z-trim_h, EXTREME_H)

    Trans.old_brush(trim,  -- bottom left
    {
      { x=x1+4, y=y1+diag_h },
      { x=x1-w, y=y1+diag_h },
      { x=x1+diag_w, y=y1-w },
      { x=x1+diag_w, y=y1+4 },
    },
    outer_z-trim_h, EXTREME_H)

    Trans.old_brush(trim,  -- bottom right
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

    Trans.old_quad(spokes, ox1+K,my-w, x1+pw,my+w, outer_z-trim_h*1.5, EXTREME_H)
    Trans.old_quad(spokes, x2-pw,my-w, ox2-K,my+w, outer_z-trim_h*1.5, EXTREME_H)

    Trans.old_quad(spokes, mx-w,oy1+K, mx+w,y1+pw, outer_z-trim_h*1.5, EXTREME_H)
    Trans.old_quad(spokes, mx-w,y2-pw, mx+w,oy2-K, outer_z-trim_h*1.5, EXTREME_H)
  end


  -- mark seeds so we don't build normal ceiling there
  for x = sx1,sx2 do for y = sy1,sy2 do
    SEEDS[x][y][1].no_ceil = true
  end end -- for x,y
end


---==========================================================---


function Builder_quake_test()

  Trans.old_quad(get_mat("METAL1_2"), 0, 128, 256, 384,  -24, 0)
  Trans.old_quad(get_mat("CEIL1_1"),  0, 128, 256, 384,  192, 208)

  if true then
    Trans.old_quad(get_mat("METAL2_4"), 112, 192, 144, 208, 20, 30);
  end

  local wall_i = get_mat("COMP1_1")

  Trans.old_quad(wall_i, 0,   128,  32, 384,  0, 192)
  Trans.old_quad(wall_i, 224, 128, 256, 384,  0, 192)
  Trans.old_quad(wall_i, 0,   128, 256, 144,  0, 192)
  Trans.old_quad(wall_i, 0,   370, 256, 384,  0, 192)

  Trans.entity("player1", 64, 256, 64)
end

