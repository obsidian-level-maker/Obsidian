----------------------------------------------------------------
--  BUILDING TOOLS
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2010 Andrew Apted
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


GLOBAL_SKIN_DEFAULTS =
{
  tag = "", special = "",
  light = "", style = "",
  message = "", wait = "",
  targetname = "",
}


CSG_BRUSHES =
{
  solid = 1, detail = 1, clip = 1,
  sky = 1, liquid = 1,
  rail = 1, light = 1,
}


Trans = {}


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


function Trans.set(T)
  Trans.TRANSFORM = assert(T)
end

function Trans.set_pos(x, y, z)
  Trans.set { add_x=x, add_y=y, add_z=z }
end

function Trans.clear()
  Trans.set {}
end

function Trans.modify(what, value)
  Trans.TRANSFORM[what] = value
end


function Trans.apply_xy(x, y)
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


Trans.apply = Trans.apply_xy  -- TODO: fix names


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


function Trans.apply_angle(ang)
  local T = Trans.TRANSFORM

  if not (T.rotate or T.mirror_x or T.mirror_y) then
    return ang
  end

  if not (T.mirror_x or T.mirror_y) then
    ang = ang + T.rotate
  else
    local dx = math.cos(ang * math.pi / 180)
    local dy = math.sin(ang * math.pi / 180)

    if T.mirror_x then dx = -dx end
    if T.mirror_y then dy = -dy end

    ang = math.round(geom.calc_angle(dx, dy))

    if T.rotate then ang = ang + T.rotate end
  end

  if ang >= 360 then ang = ang - 360 end
  if ang <    0 then ang = ang + 360 end

  return ang
end


function Trans.apply_mlook(ang)
  local T = Trans.TRANSFORM

  if T.mirror_z then
    if ang == 0 then return 0 end
    return 360 - ang
  else
    return ang
  end
end


-- handle three-part angle strings (Quake)
function Trans.apply_angles_xy(ang)
  local mlook, angle, roll = string.match(ent.angles, "(%d+) +(%d+) +(%d+)")
  angle = Trans.apply_angle(0 + angle)
  return string.format("%d %d %d", mlook, angle, roll)
end


function Trans.apply_angles_z(ang)
  local mlook, angle, roll = string.match(ent.angles, "(%d+) +(%d+) +(%d+)")
  mlook = Trans.apply_mlook(0 + mlook)
  return string.format("%d %d %d", mlook, angle, roll)
end



Trans.DOOM_LINE_FLAGS =
{
  blocked     = 0x01,
  block_mon   = 0x02,
  sound_block = 0x40,

  draw_secret = 0x20,
  draw_never  = 0x80,
  draw_always = 0x100,

  pass_thru   = 0x200,  -- Boom flag
}

function Trans.collect_flags(C)  -- FIXME: use game-specific code
  local flags = C.flags or 0

  for name,value in pairs(Trans.DOOM_LINE_FLAGS) do
    if C[name] and C[name] ~= 0 then
      flags = bit.bor(flags, value)
    end
  end

  if flags ~= 0 then
    C.flags = flags

    -- this makes sure the flags get applied
    if not C.special then C.special = 0 end
  end
end


function Trans.brush(coords, clip_rects)

  -- FIXME: mirroring
  -- (when mirroring, ensure first XY coord stays the first)

  -- apply transform
  coords = table.deep_copy(coords)

  local mode = coords[1].m

  if mode == "nothing" then return end

  -- light and rail brushes only make sense for 2.5D games
  if mode == "light" and not PARAM.light_brushes then return end
  if mode == "rail"  and not PARAM.rails then return end

  for _,C in ipairs(coords) do
    if C.m then
      -- brush info : skip
    elseif C.x then
      C.x, C.y = Trans.apply(C.x, C.y)
    elseif C.b then
      C.b, C.s = Trans.apply_z(C.b, C.s)
    elseif C.t then
      C.t, C.s = Trans.apply_z(C.t, C.s)
    else
      error("weird coords in brush")
    end

    Trans.collect_flags(C)
  end

  -- ignore space management brushes here
  if mode == "walk" or mode == "air" or mode == "used" or 
     mode == "floor" or mode == "zone" or mode == "nosplit" or
     mode == "spot"
  then
    return
  end

  if Trans.debug_brushes then
    Trans.dump_brush(coords)
  end

  if clip_rects then
    local list = { coords }
    Trans.clip_brushes_to_rects(list, clip_rects)
    for _,B in ipairs(list) do
      gui.add_brush(B)
    end
    return
  end

  gui.add_brush(coords)
end


function Trans.entity(name, x, y, z, props)
  -- prevent the addition of entities
  if Trans.no_entities then return end

  -- don't add light entities for DOOM / Duke3D
  if PARAM.light_brushes and (name == "light" or name == "sun") then
    return
  end

  local ent

  if props then
    ent = table.copy(props)
  else
    ent = {}
  end

  assert(name)

  local info = GAME.ENTITIES[name]
  if not info then
    gui.printf("\nLACKING ENTITY : %s\n\n", name)
    return
  end

  ent.id = assert(info.id)

  if x then
    x, y = Trans.apply(x, y)

    ent.x = x
    ent.y = y
  end

  if z then
    z = Trans.apply_z(z)

    if info.delta_z then
      z = z + info.delta_z
    elseif PARAM.entity_delta_z then
      z = z + PARAM.entity_delta_z
    end

    ent.z = z
  end

  if ent.angle then
    ent.angle = Trans.apply_angle(ent.angle)
  end

  if ent.angles then
    ent.angles = Trans.apply_angles_xy(ent.angles)
    ent.angles = Trans.apply_angles_z (ent.angles)
  end

  if info.spawnflags then
    ent.spawnflags = ((props and props.spawnflags) or 0) + info.spawnflags
  end

  -- handle map-models for Quake etc...
  if ent.model then
    local M = table.copy(ent.model)

    M.x1, M.y1 = Trans.apply(M.x1, M.y1)
    M.x2, M.y2 = Trans.apply(M.x2, M.y2)

    M.z1 = Trans.apply_z(M.z1)
    M.z2 = Trans.apply_z(M.z2)

    -- this is for rotation, but we only support 0/90/180/270
    if M.x1 > M.x2 then M.x1, M.x2 = M.x2, M.x1 ; M.y_face.u1, M.y_face.u2 = M.y_face.u2, M.y_face.u1 end
    if M.y1 > M.y2 then M.y1, M.y2 = M.y2, M.y1 ; M.x_face.u1, M.x_face.u2 = M.x_face.u2, M.x_face.u1  end
    if M.z1 > M.z2 then M.z1, M.z2 = M.z2, M.z1 end

    ent.model = gui.q1_add_mapmodel(M)
  end

  gui.add_entity(ent)
end


function Trans.quad(x1,y1, x2,y2, z1,z2, props, w_face, p_face)
  assert(x1)

  if not w_face then
    -- convenient form: only a material name was given
    props, w_face, p_face = Mat_normal(props)
  end

  if type(props) == "string" then
    props = { m=props }
  end

  local coords =
  {
    { x=x1, y=y1 },
    { x=x2, y=y1 },
    { x=x2, y=y2 },
    { x=x1, y=y2 },
  }

  for _,C in ipairs(coords) do
    table.merge(C, w_face)
  end

  if props and props.m then
    table.insert(coords, 1, props)
  end

  if z1 then
    local face = table.copy(p_face)
    face.b = z1
    table.insert(coords, face)
  end

  if z2 then
    local face = table.copy(p_face)
    face.t = z2
    table.insert(coords, face)
  end

--stderrf("coords = \n%s\n\n", table.tostr(coords, 3))
  Trans.brush(coords)
end


function Trans.bare_quad(x1,y1, x2,y2, b,t)
  local coords =
  {
    { x=x1, y=y1 },
    { x=x2, y=y1 },
    { x=x2, y=y2 },
    { x=x1, y=y2 },
  }

  if b then table.insert(coords, { b=b }) end
  if t then table.insert(coords, { t=t }) end

  return coords
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
    { x=x1, y=y1 },
    { x=x2, y=y1 },
    { x=x2, y=y2 },
    { x=x1, y=y2 },
  }
end

function Trans.box_coords(x, y, w, h)
  return
  {
    { x=x,   y=y },
    { x=x+w, y=y },
    { x=x+w, y=y+h },
    { x=x,   y=y+h },
  }
end


function Trans.set_tex(coords, wall, flat)
  for _,C in ipairs(coords) do
    if wall and C.x and not C.tex then
      C.tex = wall
    end
    if flat and (C.b or C.t) and not C.tex then
      C.tex = flat
    end
  end

  return coords
end


--[[ FIXME : reimplement
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
--]]


function Trans.adjust_spot(x1,y1, x2,y2, z1,z2)
  local T = Trans.TRANSFORM

  local x_size = (x2 - x1) * (T.scale_x or 1)
  local y_size = (y2 - y1) * (T.scale_y or 1)
  local z_size = (z2 - z1) * (T.scale_z or 1)

  local spot = {}

  spot.x, spot.y = Trans.apply((x1+x2) / 2, (y1+y2) / 2)

  spot.z = Trans.apply_z(z1)

  spot.r = math.min(x_size, y_size)
  spot.h = z_size

  -- when rotated, find largest square that will fit inside it
  if T.rotate then
    local k = T.rotate % 90
    if k > 45 then k = 90 - k end

    local t = math.tan((45 - k) * math.pi / 180.0)
    local s = math.sqrt(0.5 * (1 + t*t))

    spot.r = spot.r * s
  end

  return spot
end


function Trans.spot_transform(x, y, z, angle)
  return
  {
    add_x = x,
    add_y = y,
    add_z = z,
    rotate = angle,
  }
end


function Trans.box_transform(x1, y1, x2, y2, z, dir)
  local XS   = { [2]=x1, [8]= x2, [4]= x1, [6]=x2 }
  local YS   = { [2]=y1, [8]= y2, [4]= y2, [6]=y1 }
  local ANGS = { [2]=0,  [8]=180, [4]=270, [6]=90 }

  local T = {}

  T.add_x = XS[dir]
  T.add_y = YS[dir]
  T.add_z = z

  T.rotate = ANGS[dir]

  if geom.is_vert(dir) then
    T.fit_width = x2 - x1
    T.fit_depth = y2 - y1
  else
    T.fit_width = y2 - y1
    T.fit_depth = x2 - x1
  end

  return T
end


function Trans.corner_transform(x1,y1, x2,y2, z, side, horiz, vert)
  local XS   = { [1]=x1, [9]= x2, [7]= x1, [3]=x2 }
  local YS   = { [1]=y1, [9]= y2, [7]= y2, [3]=y1 }
  local ANGS = { [1]=0,  [9]=180, [7]=270, [3]=90 }

  local T = {}

  T.add_x = XS[side]
  T.add_y = YS[side]
  T.add_z = z

  T.rotate = ANGS[side]

  if side == 1 or side == 9 then
    T.fit_width = horiz
    T.fit_depth = vert
  else
    T.fit_width = vert
    T.fit_depth = horiz
  end

  return T
end


function Trans.edge_transform(x1,y1, x2,y2, z, side, long1, long2, out1, out2)
  if side == 4 then x2 = x1 + out2 ; x1 = x1 + out1 end
  if side == 6 then x1 = x2 - out2 ; x2 = x2 - out1 end
  if side == 2 then y2 = y1 + out2 ; y1 = y1 + out1 end
  if side == 8 then y1 = y2 - out2 ; y2 = y2 - out1 end

  if side == 2 then x1 = x2 - long2 ; x2 = x2 - long1 end
  if side == 8 then x2 = x1 + long2 ; x1 = x1 + long1 end
  if side == 4 then y2 = y1 + long2 ; y1 = y1 + long1 end
  if side == 6 then y1 = y2 - long2 ; y2 = y2 - long1 end

  return Trans.box_transform(x1,y1, x2,y2, z, side)
end



function Trans.dump_brush(brush, title)
  gui.debugf("%s:\n{\n", title or "Brush")

  for _,C in ipairs(brush) do
    local field_list = {}

    for name,val in pairs(C) do
      local pos
      if name == "m" or name == "x" or name == "b" or name == "t" then
        pos = 1
      elseif name == "y" then
        pos = 2
      end

      if pos then
        table.insert(field_list, pos, name) 
      else
        table.insert(field_list, name)
      end
    end

    local line = ""

    for idx,name in ipairs(field_list) do
      local val = C[name]
      
      if idx > 1 then line = line .. ", " end

      line = line .. string.format("%s=%s", name, tostring(val))
    end

    gui.debugf("  { %s }\n", line)
  end

  gui.debugf("|\n")
end


function Trans.copy_brush(brush)
  local newb = {}

  for _,C in ipairs(brush) do
    table.insert(newb, table.copy(C))
  end

  return newb
end


function Trans.brush_bbox(brush)
  local x1, x2 = 9e9, -9e9
  local y1, y2 = 9e9, -9e9

  for _,C in ipairs(brush) do
    if C.x then
      x1 = math.min(x1, C.x) ; x2 = math.max(x2, C.x)
      y1 = math.min(y1, C.y) ; y2 = math.max(y2, C.y)
    end
  end

  assert(x1 < x2)
  assert(y1 < y2)

  return x1,y1, x2,y2
end


function Trans.brush_get_b(brush)
  for _,C in ipairs(brush) do
    if C.b then return C.b end
  end
end


function Trans.brush_get_t(brush)
  for _,C in ipairs(brush) do
    if C.t then return C.t end
  end
end


function Trans.brush_is_quad(brush)
  local x1,y1, x2,y2 = Trans.brush_bbox(brush)

  for _,C in ipairs(brush) do
    if C.x then
      if C.x > x1+0.1 and C.x < x2-0.1 then return false end
      if C.y > y1+0.1 and C.y < y2-0.1 then return false end
    end
  end

  return true
end


function Trans.line_cuts_brush(brush, px1, py1, px2, py2)
  local front, back

  for _,C in ipairs(brush) do
    if C.x then
      local d = geom.perp_dist(C.x, C.y, px1,py1, px2,py2)
      if d >  0.5 then front = true end
      if d < -0.5 then  back = true end

      if front and back then return true end
    end
  end

  return false
end


function Trans.cut_brush(brush, px1, py1, px2, py2)
  -- returns the cut-off piece (on back of given line)
  -- NOTE: assumes the line actually cuts the brush

  local newb = {}

  -- transfer XY coords to a separate list for processing
  local coords = {}

  for index = #brush,1,-1 do
    local C = brush[index]
    
    if C.x then
      table.insert(coords, 1, table.remove(brush, index))
    else
      -- copy non-XY-coordinates into new brush
      table.insert(newb, table.copy(C))
    end
  end

  for idx,C in ipairs(coords) do
    local k = 1 + (idx % #coords)

    local cx2 = coords[k].x
    local cy2 = coords[k].y

    local a = geom.perp_dist(C.x, C.y, px1,py1, px2,py2)
    local b = geom.perp_dist(cx2, cy2, px1,py1, px2,py2)

    local a_side = 0
    local b_side = 0
    
    if a < -0.5 then a_side = -1 end
    if a >  0.5 then a_side =  1 end

    if b < -0.5 then b_side = -1 end
    if b >  0.5 then b_side =  1 end

    if a_side >= 0 then table.insert(brush, C) end
    if a_side <= 0 then table.insert(newb,  table.copy(C)) end

    if a_side ~= 0 and b_side ~= 0 and a_side ~= b_side then
      -- this edge crosses the cutting line --

      -- calc the intersection point
      local along = a / (a - b)

      local ix = C.x + along * (cx2 - C.x)
      local iy = C.y + along * (cy2 - C.y)

      local C1 = table.copy(C) ; C1.x = ix ; C1.y = iy
      local C2 = table.copy(C) ; C2.x = ix ; C2.y = iy

      table.insert(brush, C1)
      table.insert(newb,  C2)
    end
  end

  return newb
end


function Trans.clip_brushes_to_rects(brushes, rects)
  local process_list = {}

  -- transfer brushes to a separate list for processing, new brushes
  -- will be added back into the 'brushes' lists (if any).
  for index = 1,#brushes do
    table.insert(process_list, table.remove(brushes))
  end
  
  local function clip_to_line(B, x1, y1, x2, y2)
    if Trans.line_cuts_brush(B, x1, y1, x2, y2) then
       Trans.cut_brush(B, x1, y1, x2, y2)
    end
  end

  local function clip_brush(B, R)
    B = Trans.copy_brush(B)

    clip_to_line(B, R.x1, R.y1, R.x1, R.y2)  -- left
    clip_to_line(B, R.x2, R.y2, R.x2, R.y1)  -- right
    clip_to_line(B, R.x1, R.y2, R.x2, R.y2)  -- top
    clip_to_line(B, R.x2, R.y1, R.x1, R.y1)  -- bottom

    local bx1,by1, bx2,by2 = Trans.brush_bbox(B)

    -- it lies completely outside the rectangle?
    if bx2 <= R.x1 + 1 or bx1 >= R.x2 - 1 then return end
    if by2 <= R.y1 + 1 or by1 >= R.y2 - 1 then return end

    table.insert(brushes, B)
  end

  for _,B in ipairs(process_list) do
    for _,R in ipairs(rects) do
      clip_brush(B, R)
    end
  end
end


function Trans.brush_contains_brush(B, W)
  -- FIXME !!!!!!
  if not Trans.brush_is_quad(B) then
gui.debugf("first NOT quad\n")
  return false
  end

  local x1, y1, x2, y2 = Trans.brush_bbox(W)
  local x3, y3, x4, y4 = Trans.brush_bbox(B)

  return geom.box_inside_box(x1,y1,x2,y2, x3,y3,x4,y4)
end



------------------------------------------------------------------------

function Mat_prepare_trip()

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


function Mat_lookup(name)
  if not name then name = "_ERROR" end

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


function Mat_normal(wall, floor)
  if not wall then wall = "_ERROR" end

  local w_mat = Mat_lookup(wall)

  local f_mat = w_mat
  if floor then
    f_mat = Mat_lookup(floor)
  end

  if wall == "_SKY" then
    return "sky", { tex=w_mat.t }, { tex=f_mat.f or f_mat.t }
  end

  return "solid", { tex=w_mat.t }, { tex=f_mat.f or f_mat.t }
end


function Mat_sky()
  local mat = assert(GAME.MATERIALS["_SKY"])

  local light = LEVEL.sky_light or 0.75

  return "sky", { tex=mat.t }, { tex=mat.f or mat.t, light=light }
end


function Mat_liquid()
  assert(LEVEL.liquid)

  local mat = Mat_lookup(LEVEL.liquid.mat)

  local light   = LEVEL.liquid.light
  local special = LEVEL.liquid.special

  return "solid", { tex=mat.t }, { tex=mat.f or mat.t, light=light, speial=special }
end


function Mat_similar(A, B)
  A = GAME.MATERIALS[A]
  B = GAME.MATERIALS[B]

  if A and B then
    if A.t == B.t then return true end
    if A.f and A.f == B.f then return true end
  end

  return false
end


function Trans.set_mat(coords, wall, flat)
  if wall then
    wall = Mat_lookup(wall)
    wall = assert(wall.t)
  end

  if flat then
    flat = Mat_lookup(flat)
    flat = flat.f or assert(flat.t)
  end

  Trans.set_tex(coords, wall, flat)
end


------------------------------------------------------------------------


function is_subst(value)
  return type(value) == "string" and string.match(value, "^[?]")
end


function Trans.substitute(value)
  if not is_subst(value) then
    return value
  end

  return Trans.SKIN[string.sub(value, 2)]
end


function Trans.process_skins(...)

  local function misc_stuff()
    -- standard defaults
    Trans.SKIN["floor"] = "?wall"
    Trans.SKIN["ceil"]  = "?floor"
    Trans.SKIN["outer"] = "?wall"

    -- these are useful for conditional brushes/ents
    if GAME.format == "doom" or GAME.format == "nukem" then
      Trans.SKIN["doomy"] = 1
    else
      Trans.SKIN["quakey"] = 1
    end
  end


  local function random_pass(keys)
    -- most fields with a table value are considered to be random
    -- replacement, e.g. pic = { COMPSTA1=50, COMPWERD=50 }.
    --
    -- fields starting with an underscore are ignored, to allow for
    -- special fields in the skin.

    for _,name in ipairs(keys) do
      local value = Trans.SKIN[name]

      if type(value) == "table" and not string.match(name, "^_") then
        if table.size(value) == 0 then
          error("process_skins: random table is empty: " .. tostring(name))
        end

        Trans.SKIN[name] = rand.key_by_probs(value)
      end
    end
  end


  local function function_pass(keys)
    for _,name in ipairs(keys) do
      local value = Trans.SKIN[name]

      if type(value) == "function" then
        Trans.SKIN = value(Trans.SKIN)
      end
    end
  end


  local function subst_pass(keys)
    local changes = 0

    -- look for unresolved substitutions first
    for _,name in ipairs(keys) do
      local value = Trans.SKIN[name]

      if is_subst(value) then
        local ref = Trans.substitute(value)

        if ref and type(ref) == "function" then
          error("Substitution references a function: " .. value)
        end

        if ref and is_subst(ref) then
          -- need to resolve the other one first
        else
          Trans.SKIN[name] = ref
          changes = changes + 1
        end
      end
    end

    return changes
  end


  ---| Trans.process_skins |---

  Trans.SKIN = {}

  misc_stuff()

  for i = 1,20 do
    local skin = select(i, ...)

    if skin then
      table.merge(Trans.SKIN, skin)
    end
  end

  -- Note: iterate over a copy of the key names, since we cannot
  --       safely modify a table while iterating through it.
  local keys = table.keys(Trans.SKIN)

  random_pass(keys)

  for loop = 1,20 do
    if subst_pass(keys) == 0 then
      function_pass(keys)
      return;
    end
  end

  error("process_skins: cannot resolve refs")
end



function Fab_create(name)

  local function mark_outliers(fab)
    for _,B in ipairs(fab.brushes) do
      if B[1].m and not B[1].insider and
         (B[1].m == "walk"  or B[1].m == "air" or
          B[1].m == "zone"  or B[1].m == "nosplit" or
          B[1].m == "light" or B[1].m == "spot" or
          B[1].m == "floor")
      then
        B[1].outlier = true
      end

      if B[1].m == "spot" then
        fab.has_spots = true
      end

      -- mark infinite brushes
      for _,C in ipairs(B) do
        if C.x and math.abs(C.x) > (INF * 0.9) then B[1].infinite = true end
        if C.y and math.abs(C.y) > (INF * 0.9) then B[1].infinite = true end
      end
    end
  end


  ---| Fab_create |---

  local info = PREFAB[name]

  if not info then
    error("Unknown prefab: " .. name)
  end

  local fab = table.deep_copy(info)

  fab.name = name

  if not fab.brushes  then fab.brushes  = {} end
  if not fab.models   then fab.models   = {} end
  if not fab.entities then fab.entities = {} end

  mark_outliers(fab)

  return fab
end



function Fab_apply_skins(fab, list)

  local function do_substitutions(t)
    for _,k in ipairs(table.keys(t)) do
      local v = t[k]

      if type(v) == "string" then
        v = Trans.substitute(v)

        if v == nil then
          if name == "required" then v = false end
        end

        if v == nil then
          error(string.format("Prefab: missing value for %s = \"%s\"",
                              tostring(k), t[k]))
        end

        -- empty strings are the way to specify NIL
        if v == "" then v = nil end

        t[k] = v
      end

      -- recursively handle sub-tables
      if type(v) == "table" then
        do_substitutions(v)
      end
    end
  end


  local function process_materials(brush)
    for _,C in ipairs(brush) do
      if C.mat then
        local mat = Mat_lookup(C.mat)
        assert(mat and mat.t)

        if C.b then
          C.tex = mat.c or mat.f or mat.t
        elseif C.t then
          C.tex = mat.f or mat.t
        else
          C.tex = mat.t
        end

        C.mat = nil
      end
    end
  end


  local function process_model_face(face, is_flat)
    if face.mat then
      local mat = Mat_lookup(face.mat)
      assert(mat and mat.t)

      if is_flat and mat.f then
        face.tex = mat.f
      else
        face.tex = mat.t
      end

      face.mat = nil
    end
  end


  local function do_materials(fab)
    for _,B in ipairs(fab.brushes) do
      process_materials(B)
    end

    for _,M in ipairs(fab.models) do
      process_model_face(M.x_face, false)
      process_model_face(M.y_face, false)
      process_model_face(M.z_face, true)
    end
  end
  

  local function process_entity(E)
    local name = E.ent
    assert(name)

    local info = GAME.ENTITIES[name]

    if name == "none" then
      return false
    end

    if PARAM.light_brushes and (name == "light" or name == "sun") then
      return false
    end

    if not info then
      error("No such entity: " .. tostring(name))
    end

    E.id = assert(info.id)
    E.ent = nil

    if E.z then
      E.delta_z = info.delta_z or PARAM.entity_delta_z
    end

    if info.spawnflags then
      E.spawnflags = bit.bor((E.spawnflags or 0), info.spawnflags)
    end

    return true -- OK --
  end


  local function do_entities(fab)
    for index = #fab.entities,1,-1 do
      local E = fab.entities[index]

      -- we allow entities to be unknown, removing them from the list
      if not process_entity(E) then
        table.remove(fab.entities, index)
      end
    end

    for _,M in ipairs(fab.models) do
      if not process_entity(M.entity) then
        error("Prefab model has 'none' entity")
      end
    end
  end


  local function determine_bbox(fab)
    local x1, y1, z1
    local x2, y2, z2

    -- Note: no need to handle slopes, they are defined to be "shrinky"
    --       (i.e. never higher that t, never lower than b).

    for _,B in ipairs(fab.brushes) do
      if not B[1].outlier then
        for _,C in ipairs(B) do

          if C.x then 
            if not x1 then
              x1, y1 = C.x, C.y
              x2, y2 = C.x, C.y
            else
              x1 = math.min(x1, C.x)
              y1 = math.min(y1, C.y)
              x2 = math.max(x2, C.x)
              y2 = math.max(y2, C.y)
            end

          elseif C.b or C.t then
            local z = C.b or C.t
            if not z1 then
              z1, z2 = z, z
            else
              z1 = math.min(z1, z)
              z2 = math.max(z2, z)
            end
          end

        end -- C
      end
    end -- B

    -- FIXME !!!!!!!!  this is for floor prefabs : needs deeper consideration
    if fab.x_size then x1 = 0 ; x2 = fab.x_size end
    if fab.y_size then y1 = 0 ; y2 = fab.y_size end

    assert(x1 and y1 and x2 and y2)

    -- Note: it is OK when z1 and z2 are not set (this happens with
    --       prefabs consisting entirely of infinitely tall solids).

    -- Note: It is possible to get dz == 0
 
    local dz
    if z1 then dz = z2 - z1 end

    fab.bbox = { x1=x1, x2=x2, dx=(x2 - x1),
                 y1=y1, y2=y2, dy=(y2 - y1),
                 z1=z1, z2=z2, dz=dz,
               }
  end


  local function brush_stuff()
    for _,B in ipairs(fab.brushes) do
      if not B[1].m then
        table.insert(B, 1, { m="solid" })
      end

      B[1].fab = fab
    end
  end

  
  ---| Fab_apply_skins |---

  assert(not fab.skinned)
  fab.skinned = true

  -- FIXME: move the code here
  Trans.process_skins(GLOBAL_SKIN_DEFAULTS,
                      GAME.SKIN_DEFAULTS,
                      fab.defaults,
                      THEME.defaults,
                      list[1], list[2], list[3],
                      list[4], list[5], list[6],
                      list[7], list[8], list[9])

  -- defaults are applied, don't need it anymore
  fab.defaults = nil

  if fab.team_models then
    Trans.SKIN.team = Plan_alloc_id("team")
  end

  -- perform substitutions (values beginning with '?' are skin refs)
  do_substitutions(fab)

  -- convert 'mat' fields to 'tex' fields
  do_materials(fab)

  -- lookup entity names
  do_entities(fab)

  Trans.SKIN = nil

  -- find bounding box (in prefab space)
  determine_bbox(fab)

  brush_stuff()
end



function Trans.process_groups(size_list, pf_min, pf_max)

  -- pf_min and pf_max are in the 'prefab' space (i.e. before any
  -- stretching or shrinkin is done).

  if not pf_min then
    return { }
  end

  local info = { groups={} }

  if not size_list then
    info.groups = {}

    local G = {}

    G.low  = pf_min
    G.high = pf_max

    G.size = G.high - G.low
    G.weight = 1 * G.size

    table.insert(info.groups, G)

    info.skinned_size = G.size
    info.weight_total = G.weight

    return info
  end


  -- create groups

  assert(#size_list >= 1)

  local pf_pos = pf_min

  info.weight_total = 0
  info.skinned_size = 0

  for _,S in ipairs(size_list) do
    local G = { }

    G.size = S[1]

    G.low  = pf_pos ; pf_pos = pf_pos + G.size
    G.high = pf_pos

    G.weight = S[2] or 1

    if S[3] then
      G.size2 = S[3]
    elseif G.weight == 0 then
      G.size2 = G.size
    end

    G.weight = G.weight * G.size

    table.insert(info.groups, G)

    info.skinned_size = info.skinned_size + (G.size2 or G.size)
    info.weight_total = info.weight_total + G.weight
  end

  -- verify that group sizes match the coordinate bbox
  if math.abs(pf_pos - pf_max) > 0.1 then
    error(string.format("Prefab: groups mismatch with coords (%d != %d)", pf_pos, pf_max))
  end

  return info
end



function Trans.set_group_sizes(info, low, high)
  if info.groups then
    local extra = high - low

    for _,G in ipairs(info.groups) do
      if G.size2 then
        extra = extra - G.size2
      end
    end

    local n_pos = low

    for _,G in ipairs(info.groups) do
      if not G.size2 then
        G.size2 = extra * G.weight / info.weight_total

        if (G.size2 <= 1) then
          error("Prefab does not fit!")
        end
      end

      G.low2  = n_pos ; n_pos = n_pos + G.size2
      G.high2 = n_pos
    end

    assert(math.abs(n_pos - high) < 0.1)
  end
end



function Trans.resize_coord(info, n)
  local groups = info.groups

  if not groups then return n end

  local T = #groups
  assert(T >= 1)

  if n < groups[1].low  then return n + (groups[1].low2 -  groups[1].low)  end
  if n > groups[T].high then return n + (groups[T].high2 - groups[T].high) end

  local idx = 1

  while (idx < T) and (n > groups[idx].high) do
    idx = idx + 1
  end

  local G = groups[idx]

  return G.low2 + (G.high2 - G.low2) * (n - G.low) / (G.high - G.low);
end



function Fab_transform_XY(fab, T)

  local function brush_xy(brush)
    for _,C in ipairs(brush) do
      if C.x then
        C.x = Trans.resize_coord(fab.x_info, C.x)
        C.y = Trans.resize_coord(fab.y_info, C.y)

        C.x, C.y = Trans.apply_xy(C.x, C.y)
      end

      if C.s then
        -- FIXME: slopes
      end

      if C.angle then
        C.angle = Trans.apply_angle(C.angle)
      end
    end
  end

  
  local function entity_xy(E)
    if E.x then
      E.x = Trans.resize_coord(fab.x_info, E.x)
      E.y = Trans.resize_coord(fab.y_info, E.y)

      E.x, E.y = Trans.apply_xy(E.x, E.y)
    end

    if E.angle then
      E.angle = Trans.apply_angle(E.angle)
    end

    if E.angles then
      E.angles = Trans.apply_angles_xy(E.angles)
    end

  end


  local function model_xy(M)
    M.x1 = Trans.resize_coord(fab.x_info, M.x1)
    M.x2 = Trans.resize_coord(fab.x_info, M.x2)

    M.y1 = Trans.resize_coord(fab.y_info, M.y1)
    M.y2 = Trans.resize_coord(fab.y_info, M.y2)

    M.x1, M.y1 = Trans.apply_xy(M.x1, M.y1)
    M.x2, M.y2 = Trans.apply_xy(M.x2, M.y2)

    -- handle rotation / mirroring
    -- NOTE: we only support 0/90/180/270 rotations

    if M.x1 > M.x2 then M.x1, M.x2 = M.x2, M.x1 ; M.y_face.u1, M.y_face.u2 = M.y_face.u2, M.y_face.u1 end
    if M.y1 > M.y2 then M.y1, M.y2 = M.y2, M.y1 ; M.x_face.u1, M.x_face.u2 = M.x_face.u2, M.x_face.u1 end

    -- handle 90 and 270 degree rotations : swap X and Y faces
    local rotate = T.rotate or 0

    if math.abs(T.rotate - 90) < 15 or math.abs(T.rotate - 270) < 15 then
      M.x_face, M.y_face = M.y_face, M.x_face
    end
  end

  
  ---| Fab_transform_XY |---

  assert(fab.skinned)
  assert(not fab.moved)

  fab.moved = true

  local bbox = fab.bbox

  fab.x_info = Trans.process_groups(fab.x_ranges, bbox.x1, bbox.x2)
  fab.y_info = Trans.process_groups(fab.y_ranges, bbox.y1, bbox.y2)

  local x_low, x_high
  local y_low, y_high

  if fab.placement == "fitted" then
    if not (T.fit_width and T.fit_depth) then
      error("Fitted prefab used without fitted transform")
    end

    if math.abs(bbox.x1) > 0.1 or math.abs(bbox.y1) > 0.1 then
      error("Fitted prefab should have left/bottom coord at (0, 0)")
    end

    x_low = 0 ; x_high = T.fit_width
    y_low = 0 ; y_high = T.fit_depth

  else  -- "loose" placement

    if not (T.add_x and T.add_y) then
      error("Loose prefab used without focal coord")
    end

    -- !!!!!! FIXME: scale will be applied TWICE
    local scale_x = T.scale_x or 1
    local scale_y = T.scale_y or 1

    if fab.x_info.skinned_size then scale_x = scale_x * fab.x_info.skinned_size / bbox.dx end
    if fab.y_info.skinned_size then scale_y = scale_y * fab.y_info.skinned_size / bbox.dy end

    x_low  = bbox.x1 * scale_x
    x_high = bbox.x2 * scale_x

    y_low  = bbox.y1 * scale_y
    y_high = bbox.y2 * scale_y
  end

--[[
stderrf("T.fit_width = %s\n", tostring(T.fit_width))
stderrf("x_low = %s | x_high = %s\n", tostring(x_low), tostring(x_high))
stderrf("bbox =\n%s\n", table.tostr(bbox))
stderrf("x_info =\n%s\n", table.tostr(x_info, 3))
--]]

  Trans.set_group_sizes(fab.x_info, x_low, x_high)
  Trans.set_group_sizes(fab.y_info, y_low, y_high)

  Trans.set(T)

  for _,B in ipairs(fab.brushes) do
    brush_xy(B)
  end

  for _,E in ipairs(fab.entities) do
    entity_xy(E)
  end

  for _,M in ipairs(fab.models) do
    model_xy(M)
    entity_xy(M.entity)
  end

  Trans.clear()
end



function Fab_transform_Z(fab, T)

  local function brush_z(brush)
    for _,C in ipairs(brush) do
      if C.b then C.b = Trans.resize_coord(fab.z_info, C.b) end
      if C.t then C.t = Trans.resize_coord(fab.z_info, C.t) end

      if Trans.mirror_z then
        C.b, C.t = C.t, C.b
      end

      if C.b then C.b = Trans.apply_z(C.b) end
      if C.t then C.t = Trans.apply_z(C.t) end

      if C.s then
        -- FIXME: slopes
      end
    end
  end

  
  local function entity_z(E)
    if E.z then
      E.z = Trans.apply_z(E.z)

      if E.delta_z then
        E.z = E.z + E.delta_z
        E.delta_z = nil
      end

      if E.angles then
        E.angles = Trans.apply_angles_z(E.angles)
      end
    end
  end


  local function model_z(M)
    M.z1 = Trans.resize_coord(fab.z_info, M.z1)
    M.z2 = Trans.resize_coord(fab.z_info, M.z2)

    M.z1 = Trans.apply_z(M.z1)
    M.z2 = Trans.apply_z(M.z2)

    -- handle mirroring
    if M.z1 > M.z2 then M.z1, M.z2 = M.z2, M.z1 end
  end

  
  ---| Fab_transform_Z |---

  assert(fab.skinned)
  assert(not fab.bumped)

  fab.bumped = true

  local bbox = fab.bbox

  if bbox.dz and bbox.dz > 1 then
    local z_low, z_high

    fab.z_info = Trans.process_groups(fab.z_ranges, bbox.z1, bbox.z2)

    if T.fit_height then
      z_low  = 0
      z_high = T.fit_height
    else
      -- !!!!!! FIXME: scale_z will be applied TWICE
      local scale_z = T.scale_z or 1

      if fab.z_info.skinned_size then scale_z = scale_z * fab.z_info.skinned_size / bbox.dz end

      z_low  = bbox.z1 * scale_z
      z_high = bbox.z2 * scale_z
    end

    Trans.set_group_sizes(fab.z_info, z_low, z_high)
  else
    fab.z_info = {}
  end

  Trans.set(T)

  for _,B in ipairs(fab.brushes) do
    brush_z(B)
  end

  for _,E in ipairs(fab.entities) do
    entity_z(E)
  end

  for _,M in ipairs(fab.models) do
    model_z(M)
  end

  Trans.clear()
end



function Fab_render(fab)

  local function render_model(M)
    assert(M.entity)

    M.entity.model = gui.q1_add_mapmodel(M)

    gui.add_entity(M.entity)
  end


  ---| Fab_render |---

  assert(fab.moved and fab.bumped)
  assert(not fab.rendered)

  fab.rendered = true

  for _,B in ipairs(fab.brushes) do
    if CSG_BRUSHES[B[1].m] then
      gui.add_brush(B)
    end
  end

  for _,M in ipairs(fab.models) do
    render_model(M)
  end

  for _,E in ipairs(fab.entities) do
    gui.add_entity(E)
  end
end



function Fab_read_spots(fab)
  -- prefab must be rendered (or ready to render)

  local function add_spot(list, B)
    local x1,y1, x2,y2
    local z1,z2

    if Trans.brush_is_quad(B) then
      x1,y1, x2,y2 = Trans.brush_bbox(B)
      for _,C in ipairs(B) do
        if C.b then z1 = C.b end
        if C.t then z2 = C.t end
      end
    else
      -- FIXME: use original brushes (assume quads), break into squares,
      --        apply the rotated square formula from Trans.apply_spot. 
      error("Unimplemented: cage spots on rotated prefabs")
    end

    local SPOT =
    {
      kind  = B[1].spot_kind,
      angle = B[1].angle,

      x1 = assert(x1), x2 = assert(x2),
      y1 = assert(y1), y2 = assert(y2),
      z1 = assert(z1), z2 = assert(z2),
    }

    table.insert(list, SPOT)
  end

  ---| Fab_read_spots |---

  local list = {}

  for _,B in ipairs(fab.brushes) do
    if B[1].m == "spot" then
      add_spot(list, B)
    end
  end

  return list
end



function OLD__Fab_check_fits(fab, skin, width, depth, height)

  -- NOTE: width is in the prefab coordinate system (X)
  --       depth too (Y) and height as well (Z).
  --
  -- Any of those parameters can be nil to skip checking that part.

  local DEFAULT_MIN = 16

  local function minimum_size(size_list)
    local total = 0

    for _,S in ipairs(size_list) do
      local m
      if type(S[2]) == "string" then
        m = Trans.substitute(S[2])
        assert(m)
      elseif S[2] == 0 then
        m = S[1]
      else
        m = S[3] or DEFAULT_MIN
      end
      total = total + m
    end

    return total
  end

  if width then
    if fab.x_min    and width < fab.x_min then return false end
    if fab.x_ranges and width < minimum_size(fab.x_ranges) then return false end
  end

  if depth then
    if fab.y_min    and depth < fab.y_min then return false end
    if fab.y_ranges and depth < minimum_size(fab.y_ranges) then return false end
  end

  if height then
    if fab.z_min    and height < fab.z_min then return false end
    if fab.z_ranges and height < minimum_size(fab.z_ranges) then return false end
  end

  return true
end



function Fabricate(name, T, skins)
  
stderrf("=========  FABRICATE %s\n", name)

  local fab = Fab_create(name)

  -- FIXME: not here
  if  ROOM and  ROOM.skin then table.insert(skins, 1, ROOM.skin) end
  if THEME and THEME.skin then table.insert(skins, 1, THEME.skin) end

  Fab_apply_skins(fab, skins)

  Fab_transform_XY(fab, T)
  Fab_transform_Z (fab, T)

  Fab_render(fab)
end



------------------------------------------------------------------------


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


function Build_shadow(S, side, dist, z2)
  assert(dist)

  if not PARAM.outdoor_shadows then return end

  if not S then return end

  if side < 0 then
    S = S:neighbor(-side)
    if not (S and S.room and S.room.outdoor) then return end
    side = 10 + side
  end

  local x1, y1 = S.x1, S.y1
  local x2, y2 = S.x2, S.y2

  if side == 8 then
    local N = S:neighbor(6)
    local clip = not (N and N.room and N.room.outdoor)

    -- FIXME: update for new brush system
    Trans.old_brush(get_light(-1),
    {
      { x=x2, y=y2 },
      { x=x1, y=y2 },
      { x=x1+dist, y=y2-dist },
      { x=x2+sel(clip,0,dist), y=y2-dist },
    },
    -EXTREME_H, z2 or EXTREME_H)
  end

  if side == 4 then
    local N = S:neighbor(2)
    local clip = not (N and N.room and N.room.outdoor)

    Trans.old_brush(get_light(-1),
    {
      { x=x1, y=y2 },
      { x=x1, y=y1 },
      { x=x1+dist, y=y1-sel(clip,0,dist) },
      { x=x1+dist, y=y2-dist },
    },
    -EXTREME_H, z2 or EXTREME_H)
  end
end


---==========================================================---


function Quake_test()

  -- FIXME: update for new brush system

  Trans.old_quad(get_mat("METAL1_2"), 0, 128, 256, 384,  -24, 0)
  Trans.old_quad(get_mat("CEIL1_1"),  0, 128, 256, 384,  192, 208)

  -- 3D floor test
  if false then
    Trans.old_quad(get_mat("METAL2_4"), 112, 192, 144, 208, 20, 30);
  end

  -- liquid test
  if false then
    gui.add_brush(
    {
      { m="liquid", medium="water" },
      { t=119, tex="e1u1/water4" },
      { x=0,   y=0,   tex="e1u1/water4" },
      { x=100, y=0,   tex="e1u1/water4" },
      { x=100, y=600, tex="e1u1/water4" },
      { x=0,   y=600, tex="e1u1/water4" },
    })
  end

  local wall_i = get_mat("COMP1_1")

  Trans.old_quad(wall_i, 0,   128,  32, 384,  0, 192)
  Trans.old_quad(wall_i, 224, 128, 256, 384,  0, 192)
  Trans.old_quad(wall_i, 0,   128, 256, 144,  0, 192)
  Trans.old_quad(wall_i, 0,   370, 256, 384,  0, 192)

  Trans.entity("player1", 80, 256, 64)
  Trans.entity("light",   80, 256, 160, { light=200 })
end

