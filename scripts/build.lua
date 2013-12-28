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

