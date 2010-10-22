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


function Trans.set_override(func, data, no_ents)
  Trans.overrider = func
  Trans.override_data = data
  Trans.no_entities = no_ents
end

function Trans.clear_override()
  Trans.set_override(nil, nil, nil)
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


function Trans.brush(coords)

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

  -- the overrider can peek at the brush, or even steal it entirely
  if Trans.overrider then
    if not Trans.overrider(coords, Trans.override_data) then
      return
    end
  end

  -- ignore space management brushes here
  if mode == "walk" or mode == "air" or mode == "used" or 
     mode == "floor" or mode == "zone" or mode == "nosplit"
  then
    return
  end

  if Trans.dump_brushes then
    gui.debugf("gui.add_brush\n%s\n", table.tostr(coords, 2))
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
    -- handle three-part angle strings (Quake)
    local mlook, angle, roll = string.match(ent.angles, "(%d+) +(%d+) +(%d+)")

    mlook = Trans.apply_mlook(0 + mlook)
    angle = Trans.apply_angle(0 + angle)

    ent.angles = string.format("%d %d %d", mlook, angle, roll)
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
    if M.x1 > M.x2 then M.x1, M.x2 = M.x2, M.x1 end
    if M.y1 > M.y2 then M.y1, M.y2 = M.y2, M.y1 end
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


function Trans.OLD__centre_transform(S, z, dir)
  local T = {}

  local ANGS = { [2]=0, [8]=180,  [4]=270,  [6]=90 }

  T.add_x  = (S.x1 + S.x2) / 2
  T.add_y  = (S.y1 + S.y2) / 2
  T.add_z  = z

  if dir then T.rotate = ANGS[dir] end

  return T
end

function Trans.OLD__border_transform(S, z, side)
  local T = {}

  local x3, y3 = S:x3(), S:y3()
  local x4, y4 = S:x4(), S:y4()

  -- expand middle piece to include corners (when allowed)
  if side == 8 and S.wall_map[7] == 8 then x3 = S.x1 end
  if side == 8 and S.wall_map[9] == 8 then x4 = S.x2 end

  if side == 2 and S.wall_map[1] == 2 then x3 = S.x1 end
  if side == 2 and S.wall_map[3] == 2 then x4 = S.x2 end

  if side == 4 and S.wall_map[1] == 4 then y3 = S.y1 end
  if side == 4 and S.wall_map[7] == 4 then y4 = S.y2 end

  if side == 6 and S.wall_map[3] == 6 then y3 = S.y1 end
  if side == 6 and S.wall_map[9] == 6 then y4 = S.y2 end


  local ANGS = { [2]=0,    [8]=180,  [4]=270,  [6]=90   }
  local XS   = { [2]=  x3, [8]=  x4, [4]=S.x1, [6]=S.x2 }
  local YS   = { [2]=S.y1, [8]=S.y2, [4]=  y4, [6]=  y3 }

  T.add_x  = XS[side]
  T.add_y  = YS[side]
  T.rotate = ANGS[side]

  T.add_z = z

  if geom.is_vert(side) then
    T.fit_width = x4 - x3
  else
    T.fit_width = y4 - y3
  end

  T.fit_depth = S.border[side].thick

  do return T end
end

function Trans.OLD__straddle_transform(S, z, side)
  local T = {}

  local x3, y3 = S:x3(), S:y3()
  local x4, y4 = S:x4(), S:y4()

  local B = assert(S.border[side])

  local N  = assert(S:neighbor(side))
  local NB = assert(N.border[10-side])

  local D1 =  B.thick
  local D2 = NB.thick

  -- expand middle piece to include corners (when allowed)
  if side == 8 and S.wall_map[7] == 8 then x3 = S.x1 end
  if side == 8 and S.wall_map[9] == 8 then x4 = S.x2 end

  if side == 2 and S.wall_map[1] == 2 then x3 = S.x1 end
  if side == 2 and S.wall_map[3] == 2 then x4 = S.x2 end

  if side == 4 and S.wall_map[1] == 4 then y3 = S.y1 end
  if side == 4 and S.wall_map[7] == 4 then y4 = S.y2 end

  if side == 6 and S.wall_map[3] == 6 then y3 = S.y1 end
  if side == 6 and S.wall_map[9] == 6 then y4 = S.y2 end


  local ANGS = { [2]=0, [8]=180, [4]=270, [6]=90   }

  local XS = { [2]=  x3   , [8]=  x4,    [4]=S.x1-D2, [6]=S.x2+D2 }
  local YS = { [2]=S.y1-D2, [8]=S.y2+D2, [4]=  y4   , [6]=  y3 }

  T.add_x  = XS[side]
  T.add_y  = YS[side]
  T.rotate = ANGS[side]

  T.add_z = z

  if geom.is_vert(side) then
    T.fit_width = x4 - x3
  else
    T.fit_width = y4 - y3
  end

  T.fit_depth = D1 + D2

  do return T end
end


function Trans.OLD__doorway_transform(S, z, side)
  local T = {}

  local ANGS = { [2]=0,    [8]=180,  [4]=270,  [6]=90 }
  local XS   = { [2]=S.x1, [8]=S.x2, [4]=S.x1, [6]=S.x2 }
  local YS   = { [2]=S.y1, [8]=S.y2, [4]=S.y2, [6]=S.y1 }

  T.add_x = XS[side]
  T.add_y = YS[side]
  T.add_z = z

  if side then T.rotate = ANGS[side] end

  return T
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

  for i = 1,10 do
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


function Fab_size_stuff(fab, T, brushes)
  local x_info
  local y_info
  local z_info


  local function determine_bbox()
    local x1, y1, z1
    local x2, y2, z2

    -- Note: no need to handle slopes, they are defined to be "shrinky"
    --       (i.e. never higher that t, never lower than b).

    for _,B in ipairs(brushes) do
      if B[1].insider or not (B[1].m == "walk"  or B[1].m == "air" or
                              B[1].m == "zone"  or B[1].m == "nosplit" or
                              B[1].m == "light" or B[1].outlier)
      then
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
              z1 = math.min(z1 or z, z)
              z2 = math.max(z2 or z, z)
            end
          end

        end -- C
      end
    end -- B

    assert(x1 and y1 and x2 and y2)

    -- FIXME !!!!!!!!  this is for floor prefabs : needs deeper consideration
    if fab.x_size then x1 = 0 ; x2 = fab.x_size end
    if fab.y_size then y1 = 0 ; y2 = fab.y_size end

    -- Note: it is OK when z1 and z2 are not set (this happens with
    --       prefabs consisting entirely of infinitely tall solids).

    -- Note: It is possible to get dz == 0
 
    local dz
    if z1 then dz = z2 - z1 end

    return { x1=x1, x2=x2, dx=(x2 - x1),
             y1=y1, y2=y2, dy=(y2 - y1),
             z1=z1, z2=z2, dz=dz,
           }
  end


  local function process_groups(size_list, pf_min, pf_max)
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

      if G.weight == 0 then
        G.size2 = G.size
      elseif type(G.weight) == "string" then
        G.size2 = Trans.substitute(G.weight)
        G.weight = 0
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


  local function set_group_sizes(info, low, high)
    if not info.groups then
      return
    end

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


  ---| Fab_size_stuff |---

  local ranges = determine_bbox()

  -- XY stuff --

  x_info = process_groups(fab.x_sizes, ranges.x1, ranges.x2)
  y_info = process_groups(fab.y_sizes, ranges.y1, ranges.y2)

  local x_low, x_high
  local y_low, y_high

  if fab.placement == "fitted" then
    if not (T.fit_width and T.fit_depth) then
      error("Fitted prefab used without fitted transform")
    end

    if math.abs(ranges.x1) > 0.1 or math.abs(ranges.y1) > 0.1 then
      error("Fitted prefab should have left/bottom coord at (0, 0)")
    end

    x_low = 0 ; x_high = T.fit_width
    y_low = 0 ; y_high = T.fit_depth

  else  -- "loose" placement

    if not (T.add_x and T.add_y) then
      error("Loose prefab used without focal coord")
    end

    local scale_x = T.scale_x or 1
    local scale_y = T.scale_y or 1

    if x_info.skinned_size then scale_x = scale_x * x_info.skinned_size / ranges.dx end
    if y_info.skinned_size then scale_y = scale_y * y_info.skinned_size / ranges.dy end

    x_low  = ranges.x1 * scale_x
    x_high = ranges.x2 * scale_x

    y_low  = ranges.y1 * scale_y
    y_high = ranges.y2 * scale_y
  end

  set_group_sizes(x_info, x_low, x_high)
  set_group_sizes(y_info, y_low, y_high)

  -- Z stuff --

  if ranges.dz and ranges.dz > 1 then
    local z_low, z_high

    z_info = process_groups(fab.z_sizes, ranges.z1, ranges.z2)

    if T.fit_height then
      z_low  = 0
      z_high = T.fit_height
    else
      local scale_z = T.scale_z or 1

      if z_info.skinned_size then scale_z = scale_z * z_info.skinned_size / ranges.dz end

      z_low  = ranges.z1 * scale_z
      z_high = ranges.z2 * scale_z
    end

    set_group_sizes(z_info, z_low, z_high)
  else
    z_info = {}
  end

  -- DONE --

  return x_info, y_info, z_info
end


function Fab_render(fab, T, skin, skin2)
  local x_info
  local y_info
  local z_info

  assert(type(fab) == "table")


  local function copy_w_substitution(orig_brushes)
    -- perform substitutions (values beginning with '?')
    -- returns a copy of the brushes.

    local new_brushes = {}

    for _,B in ipairs(orig_brushes) do
      assert(#B >= 1)

      local b_copy = {}
      for _,C in ipairs(B) do

        local new_coord = {}
        for name,value in pairs(C) do
          value = Trans.substitute(value)

          if value == nil then
            if name == "required" then value = false end

            if name == "x" or name == "y" or name == "b" or name == "t" then
              error("Prefab: substitution of x/y/b/t field failed.")
            end
          end

          new_coord[name] = value
        end

        table.insert(b_copy, new_coord)
      end -- C

      -- skip certain brushes unless a skin field is present/true
      local req = b_copy[1].required

      if req == nil or (req ~= false and req ~= 0) then
        table.insert(new_brushes, b_copy)
      end
    end -- B

    return new_brushes
  end


  local function process_materials(brush)
    -- modifies a brush, converting 'mat' fields to 'tex' fields

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


  local function resize_coord(info, n)
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


  local function resize_brush(brush)
    for _,C in ipairs(brush) do
      if C.x then C.x = resize_coord(x_info, C.x) end
      if C.y then C.y = resize_coord(y_info, C.y) end

      if C.b then C.b = resize_coord(z_info, C.b) end
      if C.t then C.t = resize_coord(z_info, C.t) end

      if C.s then
        -- FIXME: slopes
      end
    end
  end 


  local function render_brushes(brushes)
    for _,B in ipairs(brushes) do
      process_materials(B)
      resize_brush(B)
      Trans.brush(B)
    end
  end


  local function entity_props(E, extra_props)
    local props = {}

    if extra_props then
      table.merge(props, extra_props)
    end

    for key,value in pairs(E) do
      if key ~= "ent" and key ~= "x" and key ~= "y" and key ~= "z" then
        props[key] = Trans.substitute(value)
      end
    end

    return props
  end


  local function render_one_ent(E, props)
    local name = Trans.substitute(E.ent)

    -- if substitution fails ignore the entity
    if not name then
      return
    end

    local ex = E.x and resize_coord(x_info, E.x)
    local ey = E.y and resize_coord(y_info, E.y)
    local ez = E.z and resize_coord(z_info, E.z)

    Trans.entity(name, ex, ey, ez, entity_props(E, props))
  end


  local function render_entities(list)
    if list then
      for _,E in ipairs(list) do
        render_one_ent(E, nil)
      end
    end
  end


  local function process_model_face(F, is_flat)
    assert(F)
    local new_face = table.copy(F)

    new_face.mat = nil

    if F.mat then
      local mat = Trans.substitute(F.mat)

      if mat then
        mat = Mat_lookup(mat)

        if is_flat and mat.f then
          new_face.tex = mat.f
        else
          new_face.tex = mat.t
        end
      end
    end

    return new_face
  end


  local function add_model(M, team)
    assert(M.entity)

    local model =
    {
      x1 = resize_coord(x_info, M.x1),
      x2 = resize_coord(x_info, M.x2),

      y1 = resize_coord(y_info, M.y1),
      y2 = resize_coord(y_info, M.y2),
    
      z1 = resize_coord(z_info, M.z1),
      z2 = resize_coord(z_info, M.z2),

      x_face = process_model_face(M.x_face, false),
      y_face = process_model_face(M.y_face, false),
      z_face = process_model_face(M.z_face, true),
    }

    -- handle 90 and 270 degree rotations : swap X and Y faces
    local rotate = Trans.TRANSFORM.rotate or 0
    if math.abs(rotate - 90) < 15 or math.abs(rotate - 270) < 15 then
      model.x_face, model.y_face = model.y_face, model.x_face
    end

    render_one_ent(M.entity, { model=model, team=team })
  end


  local function render_models(list)
    if not list or Trans.no_entities then
      return
    end

    local team

    if GAME.format == "quake2" and fab.team_models then
      team = Plan_alloc_id("team")
    end

    for _,M in ipairs(list) do
      add_model(M, team)
    end
  end


  local function render_spots(list)
    if not list or Trans.no_entities then
      return
    end

    for _,P in ipairs(list) do
      -- adjust size of spot

      local x1 = resize_coord(x_info, P.x - P.r)
      local x2 = resize_coord(x_info, P.x + P.r)

      local y1 = resize_coord(y_info, P.y - P.r)
      local y2 = resize_coord(y_info, P.y + P.r)

      local z1 = resize_coord(z_info, P.z)
      local z2 = resize_coord(z_info, P.z + P.h)

      local N = Trans.adjust_spot(x1,x2, y1,y2, z1,z2)

      if P.angle then
        N.angle = Trans.apply_angle(P.angle)
      end

      if P.kind == "cage" then
        table.insert(ROOM.cage_spots, N)
      elseif P.kind == "trap" then
        table.insert(ROOM.trap_spots, N)
      else
        error("Unknown spot kind in prefab: " .. tostring(P.kind))
      end
    end
  end


  ---| Fab_render |---

  local brushes = copy_w_substitution(fab.brushes)

  x_info, y_info, z_info = Fab_size_stuff(fab, T, brushes)


  Trans.set(
  {
    add_x  = T.add_x,
    add_y  = T.add_y,
    add_z  = T.add_z,
    rotate = T.rotate
  })

  render_brushes (brushes)
  render_models  (fab.models)
  render_entities(fab.entities)
  render_spots   (fab.spots)

  Trans.clear()
end


function Fabricate(fab, T, skin, skin2, skin3)
  if type(fab) == "string" then
    if not PREFAB[fab] then
      error("Unknown prefab: " .. fab)
    end

    fab = PREFAB[fab]
  end

  gui.debugf("Fabricating: %s\n", fab.name)

  Trans.process_skins(fab.defaults,
                      THEME and THEME.skin,
                      ROOM and  ROOM.skin,
                      skin, skin2, skin3)

  Fab_render(fab, T)
end


function Fab_check_fits(fab, skin, width, depth, height)

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
    if fab.x_min   and width < fab.x_min then return false end
    if fab.x_sizes and width < minimum_size(fab.x_sizes) then return false end
  end

  if depth then
    if fab.y_min   and depth < fab.y_min then return false end
    if fab.y_sizes and depth < minimum_size(fab.y_sizes) then return false end
  end

  if height then
    if fab.z_min   and height < fab.z_min then return false end
    if fab.z_sizes and height < minimum_size(fab.z_sizes) then return false end
  end

  return true
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

