----------------------------------------------------------------
--  BUILDING TOOLS
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2013 Andrew Apted
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


GLOBAL_SKIN_DEFAULTS =
{
  outer = "?wall"
  fence = "?wall"
  floor = "?wall"
  ceil  = "?floor"

  tag = ""
  special = ""
  light = ""
  style = ""
  message = ""
  wait = ""
  targetname = ""
}


CSG_BRUSHES =
{
  solid  = 1
  detail = 1
  clip   = 1

  sky     = 1
  liquid  = 1
  trigger = 1
  light   = 1
}


DOOM_LINE_FLAGS =
{
  blocked     = 0x01
  block_mon   = 0x02
  two_sided   = 0x04
  sound_block = 0x40

  draw_secret = 0x20
  draw_never  = 0x80
  draw_always = 0x100

-- BOOM:  pass_thru = 0x200
}


HEXEN_ACTIONS =
{
  W1 = 0x0000, WR = 0x0200,  -- walk
  S1 = 0x0400, SR = 0x0600,  -- switch
  M1 = 0x0800, MR = 0x0A00,  -- monster
  G1 = 0x0c00, GR = 0x0E00,  -- gun / projectile
  B1 = 0x1000, BR = 0x1200,  -- bump
}


function raw_add_brush(brush)
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


function Brush_collect_flags(C)
  if GAME.format == "doom" then
    local flags = C.flags or 0

    if C.act and PARAM.sub_format == "hexen" then
      local spac = HEXEN_ACTIONS[C.act]
      if not spac then
        error("Unknown act value: " .. tostring(C.act))
      end
      flags = bit.bor(flags, spac)
    end

    each name,value in DOOM_LINE_FLAGS do
      if C[name] and C[name] != 0 then
        flags = bit.bor(flags, value)
      end
    end

    if flags != 0 then
      C.flags = flags

      -- this makes sure the flags get applied
      if not C.special then C.special = 0 end
    end
  end
end


function brush_helper(brush)
  local mode = brush[1].m

  each C in brush do
    Brush_collect_flags(C)
  end

  raw_add_brush(brush)
end


function entity_helper(name, x, y, z, props)
  assert(name)

  local ent

  if props then
    ent = table.copy(props)
  else
    ent = {}
  end

  local info = GAME.ENTITIES[name] or
               GAME.MONSTERS[name] or
               GAME.WEAPONS[name] or
               GAME.PICKUPS[name]

  if not info then
    gui.printf("\nLACKING ENTITY : %s\n\n", name)
    return
  end

  local delta_z = info.delta_z or PARAM.entity_delta_z

  ent.id = assert(info.id)

  ent.x = x
  ent.y = y
  ent.z = z + (delta_z or 0)

  if info.spawnflags then
    ent.spawnflags = ((props and props.spawnflags) or 0) + info.spawnflags
  end

  if info.fields then
    each name,value in info.fields do ent[name] = value end
  end

  raw_add_entity(ent)
end


function Brush_new_quad(x1,y1, x2,y2, b,t)
  local coords =
  {
    { x=x1, y=y1 }
    { x=x2, y=y1 }
    { x=x2, y=y2 }
    { x=x1, y=y2 }
  }

  if b then table.insert(coords, { b=b }) end
  if t then table.insert(coords, { t=t }) end

  return coords
end


function Brush_new_triangle(x1,y1, x2,y2, x3,y3, b,t)
  local coords =
  {
    { x=x1, y=y1 }
    { x=x2, y=y2 }
    { x=x3, y=y3 }
  }

  if b then table.insert(coords, { b=b }) end
  if t then table.insert(coords, { t=t }) end

  return coords
end



function Brush_dump(brush, title)
  gui.debugf("%s:\n{\n", title or "Brush")

  each C in brush do
    local field_list = {}

    each name,val in C do
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

    each name in field_list do
      local val = C[name]
      
      if _index > 1 then line = line .. ", " end

      line = line .. string.format("%s=%s", name, tostring(val))
    end

    gui.debugf("  { %s }\n", line)
  end

  gui.debugf("}\n")
end


function Brush_copy(brush)
  local newb = {}

  each C in brush do
    table.insert(newb, table.copy(C))
  end

  return newb
end


function Brush_middle(brush)
  local sum_x = 0
  local sum_y = 0
  local total = 0

  each C in brush do
    if C.x then
      sum_x = sum_x + C.x
      sum_y = sum_y + C.y
      total = total + 1
    end
  end

  if total == 0 then
    return 0, 0
  end
    
  return sum_x / total, sum_y / total
end


function Brush_bbox(brush)
  local x1, x2 = 9e9, -9e9
  local y1, y2 = 9e9, -9e9

  each C in brush do
    if C.x then
      x1 = math.min(x1, C.x) ; x2 = math.max(x2, C.x)
      y1 = math.min(y1, C.y) ; y2 = math.max(y2, C.y)
    end
  end

  assert(x1 < x2)
  assert(y1 < y2)

  return x1,y1, x2,y2
end


function Brush_add_top(brush, z, mat)
  table.insert(brush, { t=z, mat=mat })
end


function Brush_add_bottom(brush, z, mat)
  table.insert(brush, { b=z, mat=mat })
end


function Brush_get_b(brush)
  each C in brush do
    if C.b then return C.b end
  end
end


function Brush_get_t(brush)
  each C in brush do
    if C.t then return C.t end
  end
end


function Brush_mark_sky(brush)
  Brush_set_mat(brush, "_SKY", "_SKY")

  table.insert(brush, 1, { m="sky" })
end


function Brush_mark_liquid(brush)
  assert(LEVEL.liquid)

  Brush_set_mat(brush, "_LIQUID", "_LIQUID")

  each C in brush do
    if C.b or C.t then
      C.special = LEVEL.liquid.special
      C.light   = LEVEL.liquid.light
    end
  end
end


function Brush_is_quad(brush)
  local x1,y1, x2,y2 = Brush_bbox(brush)

  each C in brush do
    if C.x then
      if C.x > x1+0.1 and C.x < x2-0.1 then return false end
      if C.y > y1+0.1 and C.y < y2-0.1 then return false end
    end
  end

  return true
end


function Brush_line_cuts_brush(brush, px1, py1, px2, py2)
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


function Brush_cut(brush, px1, py1, px2, py2)
  -- returns the cut-off piece (on back of given line)
  -- NOTE: assumes the line actually cuts the brush!

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

    if a_side != 0 and b_side != 0 and a_side != b_side then
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


function Brush_clip_list_to_rects(brushes, rects)
  local process_list = {}

  -- transfer brushes to a separate list for processing, new brushes
  -- will be added back into the 'brushes' lists (if any).
  for index = 1,#brushes do
    table.insert(process_list, table.remove(brushes))
  end
  
  local function clip_to_line(B, x1, y1, x2, y2)
    if Brush_line_cuts_brush(B, x1, y1, x2, y2) then
       Brush_cut(B, x1, y1, x2, y2)
    end
  end

  local function clip_brush(B, R)
    B = Brush_copy(B)

    clip_to_line(B, R.x1, R.y1, R.x1, R.y2)  -- left
    clip_to_line(B, R.x2, R.y2, R.x2, R.y1)  -- right
    clip_to_line(B, R.x1, R.y2, R.x2, R.y2)  -- top
    clip_to_line(B, R.x2, R.y1, R.x1, R.y1)  -- bottom

    local bx1,by1, bx2,by2 = Brush_bbox(B)

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


------------------------------------------------------------------------

function Mat_prepare_trip()

  -- build the psychedelic mapping
  local m_before = {}
  local m_after  = {}

  each m,def in GAME.MATERIALS do
    if not def.sane and
       not def.rail_h and
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

  -- special handling for DOOM / HERETIC switches
  if not mat and string.sub(name,1,3) == "SW2" then
    local sw1_name = "SW1" .. string.sub(name,4)
    mat = GAME.MATERIALS[sw1_name]
    if mat and mat.t == sw1_name then
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


function Mat_similar(A, B)
  A = GAME.MATERIALS[A]
  B = GAME.MATERIALS[B]

  if A and B then
    if A.t == B.t then return true end
    if A.f and A.f == B.f then return true end
  end

  return false
end


function Brush_set_tex(brush, wall, flat)
  each C in brush do
    if wall and C.x and not C.tex then
      C.tex = wall
    end
    if flat and (C.b or C.t) and not C.tex then
      C.tex = flat
    end
  end
end


function Brush_set_mat(brush, wall, flat)
  if wall then
    wall = Mat_lookup(wall)
    wall = assert(wall.t)
  end

  if flat then
    flat = Mat_lookup(flat)
    flat = flat.f or assert(flat.t)
  end

  Brush_set_tex(brush, wall, flat)
end


function Brush_has_sky(brush)
  each C in brush do
    if C.mat == "_SKY" then return true end
  end

  return false
end


------------------------------------------------------------------------


Trans = {}


Trans.TRANSFORM =
{
  -- mirror_x  : flip horizontally (about given X)
  -- mirror_y  : flip vertically (about given Y)
  -- mirror_z

  -- groups_x  : coordinate remapping groups
  -- groups_y
  -- groups_z

  -- scale_x   : scaling factor
  -- scale_y
  -- scale_z

  -- rotate    : angle in degrees, counter-clockwise,
  --             rotates about the origin

  -- add_x     : translation, i.e. new origin coords
  -- add_y
  -- add_z

  -- fitted_x  : sizes which a "fitted" prefab needs to become
  -- fitted_y
  -- fitted_z
}


--[[
struct GROUP
{
  low,  high,  size   : the original coordinate range
  low2, high2, size2  : the new coordinate range
}
--]]


function Trans.clear()
  Trans.TRANSFORM = { }
end

function Trans.set(T)
  Trans.TRANSFORM = table.copy(T)
end

function Trans.set_pos(x, y, z)
  Trans.TRANSFORM = { add_x=x, add_y=y, add_z=z }
end

function Trans.modify(what, value)
  Trans.TRANSFORM[what] = value
end


function Trans.set_cap(z1, z2)
  -- either z1 or z2 can be nil
  Trans.z1_cap = z1
  Trans.z2_cap = z2
end

function Trans.clear_cap()
  Trans.z1_cap = nil
  Trans.z2_cap = nil
end


function Trans.dump_groups(name, groups)
  gui.debugf("  %s =\n", name)
  gui.debugf("  {\n")

  each G in groups do
    gui.debugf("    (%1.0f %1.0f %1.0f) --> (%1.0f %1.0f %1.0f)\n",
               G.low  or -1, G.high  or -1, G.size  or -1,
               G.low2 or -1, G.high2 or -1, G.size2 or -1)
  end

  gui.debugf("  }\n")
end


function Trans.dump(T, title)
  -- debugging aid : show current transform

  gui.debugf("%s:\n", title or "Transform")

  if not T then
    T = Trans.TRANSFORM
    assert(T)
  end

  if T.mirror_x then gui.debugf("  mirror_x = %1.0f\n", T.mirror_x) end
  if T.mirror_y then gui.debugf("  mirror_y = %1.0f\n", T.mirror_y) end
  if T.mirror_z then gui.debugf("  mirror_z = %1.0f\n", T.mirror_z) end

  if T.scale_x then gui.debugf("  scale_x = %1.0f\n", T.scale_x) end
  if T.scale_y then gui.debugf("  scale_y = %1.0f\n", T.scale_y) end
  if T.scale_z then gui.debugf("  scale_z = %1.0f\n", T.scale_z) end

  if T.rotate then gui.debugf("  ROTATE = %1.1f\n", T.rotate) end

  if T.add_x then gui.debugf("  add_x = %1.0f\n", T.add_x) end
  if T.add_y then gui.debugf("  add_y = %1.0f\n", T.add_y) end
  if T.add_z then gui.debugf("  add_z = %1.0f\n", T.add_z) end

  if T.fitted_x then gui.debugf("  fitted_x = %1.0f\n", T.fitted_x) end
  if T.fitted_y then gui.debugf("  fitted_y = %1.0f\n", T.fitted_y) end
  if T.fitted_z then gui.debugf("  fitted_z = %1.0f\n", T.fitted_z) end

  if T.groups_x then Trans.dump_groups("groups_x", T.groups_x) end
  if T.groups_y then Trans.dump_groups("groups_y", T.groups_y) end
  if T.groups_z then Trans.dump_groups("groups_z", T.groups_z) end
end


function Trans.remap_coord(groups, n)
  if not groups then return n end

  local T = #groups
  assert(T >= 1)

  if n <= groups[1].low  then return n + (groups[1].low2 -  groups[1].low)  end
  if n >= groups[T].high then return n + (groups[T].high2 - groups[T].high) end

  local idx = 1

  while (idx < T) and (n > groups[idx].high) do
    idx = idx + 1
  end

  local G = groups[idx]

  return G.low2 + (n - G.low) * G.size2 / G.size;
end


function Trans.apply_xy(x, y)
  local T = Trans.TRANSFORM

  -- apply mirroring first
  if T.mirror_x then x = T.mirror_x * 2 - x end
  if T.mirror_y then y = T.mirror_y * 2 - y end

  -- apply groups
  if T.groups_x then x = Trans.remap_coord(T.groups_x, x) end
  if T.groups_y then y = Trans.remap_coord(T.groups_y, y) end

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


function Trans.apply_z(z)
  local T = Trans.TRANSFORM

  -- apply mirroring first
  if T.mirror_z then z = T.mirror_z * 2 - z end

  -- apply groups
  if T.groups_z then z = Trans.remap_coord(T.groups_z, z) end

  -- apply scaling
  z = z * (T.scale_z or 1)

  -- apply translation last
  z = z + (T.add_z or 0)

  return z
end


function Trans.apply_slope(slope)
  if not slope then return nil end

  local T = Trans.TRANSFORM

  slope = table.copy(slope)

  slope.x1, slope.y1 = Trans.apply_xy(slope.x1, slope.y1)
  slope.x2, slope.y2 = Trans.apply_xy(slope.x2, slope.y2)

  if T.mirror_z then slope.dz = - slope.dz end

  slope.dz = slope.dz * (T.scale_z or 1)

  return slope
end


function Trans.apply_angle(ang)
  local T = Trans.TRANSFORM

  if not (T.rotate or T.mirror_x or T.mirror_y) then
    return ang
  end

  if T.mirror_x or T.mirror_y then
    local dx = math.cos(ang * math.pi / 180)
    local dy = math.sin(ang * math.pi / 180)

    if T.mirror_x then dx = -dx end
    if T.mirror_y then dy = -dy end

    ang = math.round(geom.calc_angle(dx, dy))
  end

  if T.rotate then ang = ang + T.rotate end

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
function Trans.apply_angles_xy(ang_str)
  local mlook, angle, roll = string.match(ang_str, "(%d+) +(%d+) +(%d+)")
  angle = Trans.apply_angle(0 + angle)
  return string.format("%d %d %d", mlook, angle, roll)
end


function Trans.apply_angles_z(ang_str)
  local mlook, angle, roll = string.match(ang_str, "(%d+) +(%d+) +(%d+)")
  mlook = Trans.apply_mlook(0 + mlook)
  return string.format("%d %d %d", mlook, angle, roll)
end



function Trans.adjust_spot(x1,y1, x2,y2, z1,z2)  -- not used atm
  local T = Trans.TRANSFORM

  local x_size = (x2 - x1) * (T.scale_x or 1)
  local y_size = (y2 - y1) * (T.scale_y or 1)
  local z_size = (z2 - z1) * (T.scale_z or 1)

  local spot = {}

  spot.x, spot.y = Trans.apply_xy((x1+x2) / 2, (y1+y2) / 2)

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


function Trans.spot_transform(x, y, z, dir)
  local ANGS = { [2]=0, [8]=180, [4]=270, [6]=90 }

  return
  {
    add_x = x
    add_y = y
    add_z = z
    rotate = ANGS[dir]
  }
end


function Trans.box_transform(x1, y1, x2, y2, z, dir)
  if not dir then dir = 2 end

  local XS   = { [2]=x1, [8]= x2, [4]= x1, [6]=x2 }
  local YS   = { [2]=y1, [8]= y2, [4]= y2, [6]=y1 }
  local ANGS = { [2]=0,  [8]=180, [4]=270, [6]=90 }

  local T = {}

  T.add_x = XS[dir]
  T.add_y = YS[dir]
  T.add_z = z

  T.rotate = ANGS[dir]

  if geom.is_vert(dir) then
    T.fitted_x = x2 - x1
    T.fitted_y = y2 - y1
  else
    T.fitted_x = y2 - y1
    T.fitted_y = x2 - x1
  end

  T.bbox = { x1=x1, y1=y1, x2=x2, y2=y2 }

  return T
end


function Trans.section_transform(K, dir)
  local x1, y1, x2, y2 = K:get_coords()

  return Trans.box_transform(x1, y1, x2, y2, K.floor_h or 0, dir)
end


function Trans.edge_transform(x1,y1, x2,y2, z, side, long1, long2, out, back)
  if side == 4 then x2 = x1 + out ; x1 = x1 - back end
  if side == 6 then x1 = x2 - out ; x2 = x2 + back end
  if side == 2 then y2 = y1 + out ; y1 = y1 - back end
  if side == 8 then y1 = y2 - out ; y2 = y2 + back end

  if side == 2 then x1 = x2 - long2 ; x2 = x2 - long1 end
  if side == 8 then x2 = x1 + long2 ; x1 = x1 + long1 end
  if side == 4 then y2 = y1 + long2 ; y1 = y1 + long1 end
  if side == 6 then y1 = y2 - long2 ; y2 = y2 - long1 end

  return Trans.box_transform(x1,y1, x2,y2, z, 10 - side)
end


function Trans.set_fitted_z(T, z1, z2)
  T.add_z    = z1
  T.fitted_z = z2 - z1
end


function Trans.categorize_linkage(dir2, dir4, dir6, dir8)
  local link_str = ""

  if dir2 then link_str = link_str .. '2' end
  if dir4 then link_str = link_str .. '4' end
  if dir6 then link_str = link_str .. '6' end
  if dir8 then link_str = link_str .. '8' end

  -- nothing?
  if link_str == "" then
    return 'N', 2

  -- facing one direction
  elseif link_str == "2" then
    return 'F', 2

  elseif link_str == "4" then
    return 'F', 4

  elseif link_str == "6" then
    return 'F', 6

  elseif link_str == "8" then
    return 'F', 8

  -- straight through
  elseif link_str == "28" then
    return 'I', 2

  elseif link_str == "46" then
    return 'I', 4
  
  -- corner
  elseif link_str == "26" then
    return 'C', 6

  elseif link_str == "24" then
    return 'C', 2

  elseif link_str == "48" then
    return 'C', 4

  elseif link_str == "68" then
    return 'C', 8
  
  -- T junction
  elseif link_str == "246" then
    return 'T', 2

  elseif link_str == "248" then
    return 'T', 4

  elseif link_str == "268" then
    return 'T', 6

  elseif link_str == "468" then
    return 'T', 8

  -- plus shape, all four directions
  elseif link_str == "2468" then
    return 'P', rand.pick { 2,4,6,8 }

  else
    error("categorize_linkage failed on: " .. link_str)
  end
end



function Trans.expansion_groups(list, axis_name, fit_size, pf_size)
  local extra = fit_size - pf_size

  -- nothing needed if the size is the same
  if math.abs(extra) < 1 then return nil end

  if extra < 0 then
    error("Prefab does not fit! (on " .. axis_name .. " axis)")
  end

  assert(extra > 0)

  -- check some special keywords.
  -- missing 'x_fit' field (etc) defaults to "stretch"

  if not list or list == "stretch" then
    local G =
    {
      low   = 0
      high  = pf_size
      low2  = 0
      high2 = fit_size
    }

    G.size  = G.high  - G.low
    G.size2 = G.high2 - G.low2

    return { G }
  
  elseif list == "left" or list == "bottom" then
    list = { 0, 1 }

  elseif list == "right" or list == "top" then
    list = { pf_size - 1, pf_size }

  elseif list == "frame" then
    list = { 0, 1, pf_size - 1, pf_size }
  end


  if type(list) != "table" then
    error("Bad " .. axis_name .. "_fit field in prefab: " .. tostring(list))
  end


  -- validate list
  for i = 1, #list-1 do
    local A = list[i]
    local B = list[i + 1]

    if A >= B then
      error("Bad ordering in " .. axis_name .. "_fit field in prefab")
    end
  end


  -- construct the mapping groups
  local groups = { }
  local pos = list[1]

  for i = 1,#list-1 do
    local G =
    {
      low  = list[i]
      high = list[i+1]
    }

    G.size = G.high - G.low

    G.size2 = G.size

    if (i % 2) == 1 then
      G.size2 = G.size2 + extra / (#list / 2)
    end

    G.low2  = pos
    G.high2 = pos + G.size2

    pos = pos + G.size2

    table.insert(groups, G)
  end

  return groups
end


------------------------------------------------------------------------


function Trans.is_subst(value)
  return type(value) == "string" and string.match(value, "^[!?]")
end


function Trans.substitute(SKIN, value)
  if not Trans.is_subst(value) then
    return value
  end

  -- a simple substitution is just: "?varname"
  -- a more complex one has an operator: "?varname+3",  "?foo==1"

  local neg, var_name, op, number = string.match(value, "(.)([%w_]*)(%p*)(%-?[%d.]*)");

  if var_name == "" then var_name = nil end
  if op       == "" then op       = nil end
  if number   == "" then number   = nil end

  if not var_name or (op and not number) or (op and neg == '!') then
    error("bad substitution: " .. tostring(value));
  end

  -- first lookup variable name, abort if not present
  value = SKIN[var_name]

  if value == nil or Trans.is_subst(value) then
    return value
  end

  -- apply the boolean negation
  if neg == '!' then
    return 1 - convert_bool(value)

  -- apply the operator
  elseif op then
    value  = 0 + value
    number = 0 + number

    if op == "+" then return value + number end
    if op == "-" then return value - number end

    if op == "==" then return sel(value == number, 1, 0) end
    if op == "!=" then return sel(value != number, 1, 0) end

    error("bad subst operator: " .. tostring(op))
  end

  return value
end


function Fab_determine_bbox(fab)
  local x1, y1, z1
  local x2, y2, z2

  -- Note: no need to handle slopes, they are defined to be "shrinky"
  --       (i.e. never higher that t, never lower than b).

  each B in fab.brushes do
    if B[1].outlier then continue end
    if B[1].m == "spot" then continue end

    each C in B do

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
  end -- B

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

  gui.debugf("bbox =\n%s\n", table.tostr(fab.bbox))
end


function Fab_transform_XY(fab, T)

  local function brush_xy(brush)
    each C in brush do
      if C.x then C.x, C.y = Trans.apply_xy(C.x, C.y) end

      -- Note: this does Z too (fixme?)
      if C.s then C.s = Trans.apply_slope(C.s) end

      if C.angle then C.angle = Trans.apply_angle(C.angle) end
    end
  end

  
  local function entity_xy(E)
    if E.x then
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

  assert(fab.state == "skinned")

  fab.state = "transform_xy"

  Trans.set(T)

  local bbox = fab.bbox

  --- X ---

  if fab.x_fit or T.fitted_x then
    if not T.fitted_x then
      error("Fitted prefab used without fitted X transform")

    elseif T.scale_x then
      error("Fitted transform used with scale_x")

    elseif math.abs(bbox.x1) > 0.1 then
      error("Fitted prefab must have lowest X coord at 0")
    end

    Trans.TRANSFORM.groups_x = Trans.expansion_groups(fab.x_fit, "x", T.fitted_x, bbox.x2)

  else
    -- "loose" placement
  end


  --- Y ---

  if fab.y_fit or T.fitted_y then
    if not T.fitted_y then
      error("Fitted prefab used without fitted Y transform")

    elseif T.scale_y then
      error("Fitted transform used with scale_y")

    elseif math.abs(bbox.y1) > 0.1 then
      error("Fitted prefab must have lowest Y coord at 0")
    end

    Trans.TRANSFORM.groups_y = Trans.expansion_groups(fab.y_fit, "y", T.fitted_y, bbox.y2)

  else
    -- "loose" placement
  end

  -- apply the coordinate transform to all parts of the prefab

  each B in fab.brushes do
    brush_xy(B)
  end

  each E in fab.entities do
    entity_xy(E)
  end

  each M in fab.models do
    model_xy(M)
    entity_xy(M.entity)
  end

  Trans.clear()
end



function Fab_transform_Z(fab, T)

  local function brush_z(brush)
    local b, t

    each C in brush do
      if C.b  then C.b  = Trans.apply_z(C.b)  ; b = C.b end
      if C.t  then C.t  = Trans.apply_z(C.t)  ; t = C.t end
      if C.zv then C.zv = Trans.apply_z(C.zv) end

      if Trans.mirror_z then
        C.b, C.t = C.t, C.b
      end
    end

    -- apply capping
    if Trans.z1_cap and not b and (not t or t.t > Trans.z1_cap) then
      table.insert(brush, { b = Trans.z1_cap })
    end

    if Trans.z2_cap and not t and (not b or b.b < Trans.z2_cap) then
      table.insert(brush, { t = Trans.z2_cap })
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
    M.z1 = Trans.apply_z(M.z1)
    M.z2 = Trans.apply_z(M.z2)

    if M.delta_z then
      M.z1 = M.z1 + M.delta_z
      M.z2 = M.z2 + M.delta_z
    end

    if Trans.mirror_z then
      M.z1, M.z2 = M.z2, M.z1
    end

    -- handle QUAKE I / II platforms
    if M.entity.height and T.scale_z then
      M.entity.height = M.entity.height * T.scale_z
    end
  end

  
  ---| Fab_transform_Z |---

  assert(fab.state == "transform_xy")

  fab.state = "transform_z"

  Trans.set(T)

  local bbox = fab.bbox

  --- Z ---

  if fab.z_fit or T.fitted_z then
    if not T.fitted_z then
      error("Fitted prefab used without fitted Z transform")

    elseif T.scale_z then
      error("Fitted transform used with scale_z")

    elseif not (bbox.dz and bbox.dz >= 1) then
      error("Fitted prefab has no vertical range!")

    elseif math.abs(bbox.z1) > 0.1 then
      error("Fitted prefab must have lowest Z coord at 0")
    end

    Trans.TRANSFORM.groups_z = Trans.expansion_groups(fab.z_fit, "z", T.fitted_z, bbox.z2)

  else
    -- "loose" mode
  end

  -- apply the coordinate transform to all parts of the prefab

  each B in fab.brushes do
    brush_z(B)
  end

  each E in fab.entities do
    entity_z(E)
  end

  each M in fab.models do
    model_z(M)
  end

  Trans.clear()
end



function Fab_composition(parent, parent_skin)
  -- FIXME : rework for WAD-fabs !!

  -- handles "prefab" brushes, replacing them with the brushes of
  -- the child prefab (transformed to fit into the "prefab" brush),
  -- and adding all the child's entities and models too.
  --
  -- This function is called by Fab_apply_skins() and never needs
  -- to be called by other code.

  local function transform_child(brush, skin, dir)
    local child = Fab_create(skin._prefab)

    Fab_apply_skins(child, { parent_skin, skin })

    -- TODO: support arbitrary rectangles (rotation etc)

    local bx1, by1, bx2, by2 = Brush_bbox(brush)

    local low_z  = Brush_get_b(brush)
    local high_z = Brush_get_t(brush)

    local T = Trans.box_transform(bx1, by1, bx2, by2, low_z, dir)
     
    if child.fitted and string.find(child.fitted, "z") then
      Trans.set_fitted_z(T, low_z, high_z)
    end

    Fab_transform_XY(child, T)
    Fab_transform_Z (child, T)

    each B in child.brushes do
      table.insert(parent.brushes, B)
    end

    each E in child.entities do
      table.insert(parent.entities, E)
    end

    each M in child.models do
      table.insert(parent.models, M)
    end

    child = nil
  end


  ---| Fab_composition |---

  for index = #parent.brushes,1,-1 do
    local B = parent.brushes[index]

    if B[1].m == "prefab" then
      table.remove(parent.brushes, index)

      local child_name = assert(B[1].skin)
      local child_skin = GAME.SKINS[child_name]
      local child_dir  = B[1].dir or 2

      if not child_skin then
        error("prefab compostion: no such skin: " .. tostring(child_name))
      end

      transform_child(B, child_skin, child_dir)
    end
  end
end



function Fab_repetition_X__OLD(fab, T)

  local orig_brushes  = #fab.brushes
  local orig_models   = #fab.models
  local orig_entities = #fab.entities

  local function copy_brush(B, x_offset, y_offset)
    local B2 = {}

    each C in B do
      C2 = table.copy(C)

      if C.x then C2.x = C.x + x_offset end
      if C.y then C2.y = C.y + y_offset end

      -- FIXME: slopes

      table.insert(B2, C2)
    end

    table.insert(fab.brushes, B2)
  end


  local function copy_model(M, x_offset, y_offset)
    local M2 = table.copy(M)

    M2.entity = table.copy(M.entity)

    M2.x1 = M.x1 + x_offset
    M2.x2 = M.x2 + x_offset

    M2.y1 = M.y1 + y_offset
    M2.y2 = M.y2 + y_offset

    table.insert(fab.models, M2)
  end


  local function copy_entity(E, x_offset, y_offset)
    local E2 = table.copy(E)

    if E.x then E2.x = E.x + x_offset end
    if E.y then E2.y = E.y + x_offset end

    table.insert(fab.entities, E2)
  end


  local function replicate_w_offsets(x_offset, y_offset)
    -- cannot use 'each B in' since we are changing the list (adding new ones)
    for index = 1, orig_brushes do
      local B = fab.brushes[index]
      copy_brush(B, x_offset, y_offset)
    end

    for index = 1, orig_models do
      local M = fab.models[index]
      copy_model(M, x_offset, y_offset)
    end

    for index = 1, orig_entities do
      local E = fab.entities[index]
      copy_entity(E, x_offset, y_offset)
    end
  end


  ---| Fab_repetition_X |---

  if not fab.x_repeat then return end

  if not T.fitted_x then
    error("x_repeat used in loose prefab")
  end

  local count = math.floor(T.fitted_x / fab.x_repeat)

  if count <= 1 then return end

  for pass = 1,count-1 do
    local x_offset = pass * fab.bbox.x2
    local y_offset = 0

    replicate_w_offsets(x_offset, y_offset)
  end

  -- update bbox
  fab.bbox.x2 = fab.bbox.x2 * count

  -- update ranges
  if fab.x_ranges then
    local new_x_ranges = {}

    for pass = 1,count do
      table.append(new_x_ranges, fab.x_ranges)
    end

    fab.x_ranges = new_x_ranges
  end
end



function Fab_bound_brushes_Z(fab, z1, z2)
  if not (z1 or z2) then return end

  each B in fab.brushes do
    if CSG_BRUSHES[B[1].m] then
      local b = Brush_get_b(B)
      local t = Brush_get_t(B)

      if z1 and not b then table.insert(B, { b = z1 }) end
      if z2 and not t then table.insert(B, { t = z2 }) end
    end
  end
end



function Fab_render(fab)

  assert(fab.state == "transform_z")

  fab.state = "rendered"

  each B in fab.brushes do
    if CSG_BRUSHES[B[1].m] then
      --- DEBUG AID:
      --- stderrf("brush %d/%d\n", _index, #fab.brushes)
      Brush_dump(B)

      raw_add_brush(B)
    end
  end

  each M in fab.models do
    raw_add_model(M)
  end

  each E in fab.entities do
    raw_add_entity(E)
  end

end


function Fab_read_spots(fab)
  -- prefab must be rendered (or ready to render)

  local function add_spot(list, B)
    local x1,y1, x2,y2
    local z1,z2

    if Brush_is_quad(B) then
      x1,y1, x2,y2 = Brush_bbox(B)

      each C in B do
        if C.b then z1 = C.b end
        if C.t then z2 = C.t end
      end
    else
      -- FIXME: use original brushes (assume quads), break into squares,
      --        apply the rotated square formula from Trans.apply_spot. 
      error("Unimplemented: cage spots on rotated prefabs")
    end

    if not z1 or not z2 then
      error("monster spot brush is missing t/b coord")
    end

    local SPOT =
    {
      kind  = B[1].spot_kind
      angle = B[1].angle

      x1 = x1, y1 = y1, z1 = z1
      x2 = x2, y2 = y2, z2 = z2
    }

    table.insert(list, SPOT)
  end

  ---| Fab_read_spots |---

  local list = {}

  each B in fab.brushes do
    if B[1].m == "spot" then
      add_spot(list, B)
    end
  end

  return list
end



function Fab_size_check(skin, long, deep)
  -- the 'long' and 'deep' parameters can be nil : means anything is OK

  if long and skin.long then
    if type(skin.long) == "number" then
      if long < skin.long then return false end
    else
      if long < skin.long[1] then return false end
      if long > skin.long[2] then return false end
    end
  end

  if deep and skin.deep then
    if type(skin.deep) == "number" then
      if deep < skin.deep then return false end
    else
      if deep < skin.deep[1] then return false end
      if deep > skin.deep[2] then return false end
    end
  end

  if skin._aspect then
    -- we don't know the target size, so cannot guarantee any aspect ratio
    if not (long and deep) then return false end

    local aspect = long / deep

    if type(skin._aspect) == "number" then
      aspect = aspect / skin._aspect
      -- fair bit of lee-way here
      if aspect < 0.9 or aspect > 1.1 then return false end
    else
      if aspect < skin._aspect[1] * 0.95 then return false end
      if aspect > skin._aspect[2] * 1.05 then return false end
    end
  end

  return true  -- OK --
end


------------------------------------------------------------------------


function Build_solid_quad(x1, y1, x2, y2, mat)
  local brush = Brush_new_quad(x1, y1, x2, y2)
  Brush_set_mat(brush, mat, mat)
  brush_helper(brush)
end


function Build_sky_quad(x1, y1, x2, y2, sky_h)
  local brush = Brush_new_quad(x1, y1, x2, y2, sky_h)
  Brush_set_mat(brush, "_SKY", "_SKY")
  table.insert(brush, 1, { m="sky" })
  brush_helper(brush)
end


------------------------------------------------------------------------


WADFAB_ENTITIES =
{
  -- monster spots
  
  [3004] = { kind="monster",  r=20  }  -- zombieman
  [3002] = { kind="monster",  r=32  }  -- demon
  [3005] = { kind="flyer",    r=32  }  -- cacodemon
  [  68] = { kind="monster",  r=64  }  -- arachnotron
  [   7] = { kind="monster",  r=128 }  -- spider mastermind

  -- item spots

  [2015] = { kind="pickup",   r=16 }  -- armor helmet
  [2018] = { kind="big_item", r=16 }  -- green armor vest

  -- goal / purpose spot

  [  36] = { kind="goal", r=64 }  -- column with heart

  -- lighting

  [  34] = { kind="light" }  -- candle
}


WADFAB_SKILL_TO_LIGHT =
{
  [1] = 0.5   -- EASY
  [2] = 0.8   -- MEDIUM
  [4] = 1.3   -- HARD
}

WADFAB_LIGHT_DELTAS =
{
  [1]  =  48  -- random off
  [2]  =  48  -- blink fast
  [12] =  48  -- blink fast, sync
  [3]  =  48  -- blink slow
  [13] =  48  -- blink slow, sync
  [8]  =  96  -- oscillates
  [17] =  48  -- flickers
}

WADFAB_REACHABLE = 992


function Fab_load_wad(name)

  local fab

  local function copy_coord(S, C, pass)

    local C2 = { x=C.x, y=C.y }

    local side
    local line

    if C.side then side = gui.wadfab_get_side(C.side) end
    if C.line then line = gui.wadfab_get_line(C.line) end

    local flags = (line and line.flags) or 0

    --- determine texture to use ---

    local upper_tex
    local lower_tex
    local   mid_tex

    upper_tex = side and side.upper_tex
    if upper_tex == "-" then upper_tex = nil end

    lower_tex = side and side.lower_tex
    if lower_tex == "-" then lower_tex = nil end

    mid_tex = side and side.mid_tex
    if mid_tex == "-" then mid_tex = nil end


    local tex

    -- if line is one-sided, use the middle texture
    if line and bit.band(flags, DOOM_LINE_FLAGS.two_sided) == 0 then
      tex = mid_tex

    elseif pass == 1 then
      tex = lower_tex or upper_tex

    else
      tex = upper_tex or lower_tex
    end

    if tex then
      C2.tex = tex
    end

    -- offsets --

    if side and side.x_offset and side.x_offset != 0 then
      C2.u1 = side.x_offset
      if C2.u1 == 1 then C2.u1 = 0 end
    end

    if side and side.y_offset and side.y_offset != 0 then
      C2.v1 = side.y_offset
      if C2.v1 == 1 then C2.v1 = 0 end
    end

    -- line type --

    if line and line.special and line.special > 0 then
      C2.special = line.special
    end

    if line and line.tag and line.tag > 0 then
      C2.tag = line.tag
    end

    -- line flags --

    local MLF_UpperUnpegged = 0x0008
    local MLF_LowerUnpegged = 0x0010

    if not line then
      -- nothing

    else
      if (bit.band(flags, MLF_LowerUnpegged) != 0 and pass == 1) or
         (bit.band(flags, MLF_UpperUnpegged) != 0 and pass == 2) then
        C2.unpeg = 1
      end

      -- keep these flags: block-all, block-mon, secret, no-draw,
      --                   always-draw, block-sound, pass-thru
      flags = bit.band(flags, 0x2E3)

      if flags != 0 then
        C2.flags = flags

        -- this makes sure the flags get applied
        if not C2.special then C2.special = 0 end
      end
    end

    -- railings --

    if pass == 1 and line and mid_tex and tex != mid_tex then
      C2.rail = mid_tex
    end

    return C2
  end


  local function create_void_brush(coords)
    local B =
    {
      { m="solid" }
    }

    each C in coords do
      table.insert(B, copy_coord(S, C, 1))
    end

    -- add this new brush to the prefab
    table.insert(fab.brushes, B)
  end


  local function create_brush(S, coords, pass)
    
    -- pass: 1 = create a floor brush (or solid wall)
    --       2 = create a ceiling brush
    
    -- skip making a brush when the flat is FWATER4
    if pass == 1 and S.floor_tex == "FWATER4" then return end
    if pass == 2 and S. ceil_tex == "FWATER4" then return end

    local B =
    {
      { m="solid" }
    }

    local is_door = (S.floor_h >= S.ceil_h)

    if pass == 1 then
      local C = { t=S.floor_h, tex=S.floor_tex }

      if S.special == WADFAB_REACHABLE then
        C.reachable = true
      elseif S.special and S.special > 0 then
        C.special = S.special
      end

      if S.tag and S.tag > 0 then
        C.tag = S.tag
      end

      -- lighting specials need a 'light_delta' field (for best results)
      local delta = WADFAB_LIGHT_DELTAS[S.special or 0]
      if delta then
        C.light_delta = delta
      end

      table.insert(B, C)

    else
      local C = { b=S.ceil_h, tex=S.ceil_tex }
      table.insert(B, C)

      -- to make closed doors we need to force a gap, otherwise the CSG
      -- code will create void space.
      if is_door then
        C.b = S.floor_h + 1
        C.delta_z = -1
      end

      -- automatically convert to a sky brush
      if string.match(S.ceil_tex, "^F_SKY") then
        B[1].m = "sky"
      end
    end

    each C in coords do
      table.insert(B, copy_coord(S, C, pass))
    end

    -- add this new brush to the prefab
    table.insert(fab.brushes, B)
  end


  local function handle_entity(fab, E)
    local spot_info = WADFAB_ENTITIES[E.id]

    if not spot_info then
      table.insert(fab.entities, E)
      return
    end

    -- logic to add light entities:
    --   + angle controls level (0 = 128, 45 = 144, ..., 315 = 240)
    --   + skill bits determine the _factor
    if spot_info.kind == "light" then
      E.id = "light"

      local skill = bit.band(E.flags or 7, 7)
      E.flags = bit.bor(E.flags or 7, 7)

      E._factor = WADFAB_SKILL_TO_LIGHT[skill]

      local angle = E.angle or 180
      if angle < 0 then angle = angle + 360 end
      angle = math.clamp(0, angle, 315)

      E.light = 136 + int(angle * 16 / 45)

      table.insert(fab.entities, E)
      return
    end

    -- create a fake brush for the spot
    -- (this brush is never sent to the CSG code -- it is simply a
    --  handy way to get the spot translated and rotated)

    local B =
    {
      { m = "spot" }
    }

    B[1].spot_kind = spot_info.kind
    B[1].angle = E.angle

    -- the "ambush" (aka Deaf) flag means a caged monster
    local MTF_Ambush = 8
    if spot_info.kind == "monster" and bit.band(E.flags or 0, MTF_Ambush) != 0 then
      B[1].spot_kind = "cage"
    end

    local r = spot_info.r

    table.insert(B, { x=E.x - r, y = E.y - r })
    table.insert(B, { x=E.x + r, y = E.y - r })
    table.insert(B, { x=E.x + r, y = E.y + r })
    table.insert(B, { x=E.x - r, y = E.y + r })

    -- TODO: determine Z range properly (at least the bottom)
    table.insert(B, { b=0 })
    table.insert(B, { t=128 })

    table.insert(fab.brushes, B)
  end


  function load_it(name)
    -- load the map structures into memory
    gui.wadfab_load(name)

    fab =
    {
      name  = name
      state = "raw"

      brushes  = {}
      models   = {}
      entities = {}
    }

    for thing_idx = 0,999 do
      local E = gui.wadfab_get_thing(thing_idx)

      -- nil result marks the end
      if not E then break; end

      handle_entity(fab, E)
    end

    for poly_idx = 0,999 do
      local sec_idx, coords = gui.wadfab_get_polygon(poly_idx)

      -- nil result marks the end
      if not sec_idx then break; end

      -- negative value means "void" space
      if sec_idx < 0 then
        create_void_brush(coords)
        continue
      end

      local S = gui.wadfab_get_sector(sec_idx)
      assert(S)

      create_brush(S, coords, 1)  -- floor
      create_brush(S, coords, 2)  -- ceil
    end

    gui.wadfab_free()

    Fab_determine_bbox(fab)

    return fab
  end


  ---| Fab_load_wad |---

  -- see if already loaded
  if not EPISODE.cached_wads then
    EPISODE.cached_wads = {}
  end

  if not EPISODE.cached_wads[name] then
    EPISODE.cached_wads[name] = load_it(name)
  end
  
  local orig = EPISODE.cached_wads[name]
  assert(orig)

  return table.deep_copy(orig)
end



function Fab_bound_Z(fab, skin)
  if skin.bound_z1 then
    fab.bbox.z1 = math.min(fab.bbox.z1 or 9999, skin.bound_z1)
  end

  if skin.bound_z2 then
    fab.bbox.z2 = math.max(fab.bbox.z2 or -9999, skin.bound_z2)
  end

  -- for lifts, we pretend the bbox only extends vertically to the
  -- high floor height.  In combination with a reduced T.fitted_z
  -- (only target_h - source_h), this will expand the lift correctly.
  --
  -- TODO: perhaps a cleaner (more general) solution

  if skin.shape == "lift" then
    fab.bbox.z2 = LIFT_H
    assert(skin.z_fit == "top")
  end

  if fab.bbox.z1 and fab.bbox.z2 then
    fab.bbox.dz = fab.bbox.z2 - fab.bbox.z1
  end
end



function Fab_merge_skins(fab, main_skin, list)
  --
  -- merges the skin list into the main skin (from GAMES.SKIN table)
  -- and also includes various default values.
  --

  local result = table.copy(GLOBAL_SKIN_DEFAULTS)

  result.wall = GAME.MATERIALS["_ERROR"].t

  if  GAME.SKIN_DEFAULTS then table.merge(result,  GAME.SKIN_DEFAULTS) end
  if THEME.skin_defaults then table.merge(result, THEME.skin_defaults) end

  table.merge(result, main_skin)

  each skin in list do
    table.merge(result, skin)
  end

  return result
end



function Fab_substitutions(fab, SKIN)
  --
  -- handle all subs (the "?xxx" syntax) and random tables.
  -- the SKIN table is modified here.
  --

  local PREFIXES =
  {
    "tex_", "flat_", "thing_",
    "tag_", "line_", "sector_"
  }

  local function match_prefix(name)
    each prefix in PREFIXES do
      if string.match(name, "^" .. prefix) then
        return true
      end
    end

    return false
  end


  local function matching_keys()
    local list = { }

    each k,v in SKIN do
      if match_prefix(k) then
        table.insert(list, k)
      end
    end

    return list
  end


  local function random_pass(keys)
    -- most fields with a table value are considered to be random
    -- replacement, e.g. tex_FOO = { COMPSTA1=50, COMPSTA2=50 }.

    each name in keys do
      local value = SKIN[name]

      if type(value) == "table" then
        if table.size(value) == 0 then
          error("Fab_substitutions: random table is empty: " .. tostring(name))
        end

        SKIN[name] = rand.key_by_probs(value)
      end
    end
  end


  local function do_substitution(value)
    local seen = { }

    while Trans.is_subst(value) do

      if seen[value] then
        -- failed !
        gui.debugf("\nSKIN =\n%s\n\n", table.tostr(SKIN))
        error("Fab_substitutions: recursive refs (" .. tostring(value) .. ")")
      end

      seen[value] = 1

      value = Trans.substitute(SKIN, value)
    end

    return value
  end


  local function subst_pass(keys)
    each name in keys do
      local value = SKIN[name]

      if Trans.is_subst(value) then
        SKIN[name] = do_substitution(value)
      end
    end
  end


  ---| Fab_substitutions |---

  -- Note: iterate over a copy of the key names, since we cannot
  --       safely modify a table while iterating through it.
  --
  -- Also we only process the replacement keywords, which have the
  -- special prefixes listed above ("tex_" etc).
  --
  local keys = matching_keys()

  random_pass(keys)

  subst_pass(keys)
end



function Fab_replacements(fab, skin)

  -- replaces textures (etc) in the brushes of the prefab with
  -- stuff from the skin.

  local function santize_char(ch)
    if ch == "-" or ch == " " or ch == "_" then return "_" end

    if string.match(ch, "%w") then return ch end

    -- convert a weird character to a lowercase letter
    local num = string.byte(ch)
    if (num < 0) then num = -num end
    num = num % 26;

    return string.sub("abcdefghijklmnopqrstuvwxyz", num, num)
  end


  local function santize(name)
    name = string.upper(name)

    local s = ""

    for i = 1,#name do
      s = s .. santize_char(string.sub(name, i, i))
    end

    if s == "" then return "XXX" end

    return s
  end


  local function check(prefix, val)
    local k = prefix .. "_" .. val

    if skin[k] then return skin[k] end

    return val
  end


  local function check_tex(val)
    local k = "tex_" .. val

    if skin[k] then
      local mat = Mat_lookup(skin[k])

      return assert(mat.t)
    end

    return val
  end


  local function check_flat(val, C)
    local k = "flat_" .. val

    -- give liquid brushes lighting and/or special type
    if skin[k] == "_LIQUID" and LEVEL.liquid then
      C.special = C.special or LEVEL.liquid.special
      C.light   = LEVEL.liquid.light
      C._factor = 0.7
    end

    if skin[k] then
      local mat = Mat_lookup(skin[k])

      return assert(mat.f or mat.t)
    end

    return val
  end


  local function check_tag(val)
    local k = "tag_" .. val

    -- if it is not already specified, allocate a new tag

    if not skin[k] then
      skin[k] = Plan_alloc_id("tag")
    end

    return skin[k]
  end


  local function check_thing(val)
    local k = "thing_" .. val

    if skin[k] then
      local name = skin[k]

      -- allow specifying a raw ID number
      if type(name) == "number" then return name end

      local info = GAME.ENTITIES[name] or
                   GAME.MONSTERS[name] or
                   GAME.WEAPONS[name]  or
                   GAME.PICKUPS[name]

      if not info then
        gui.printf("\nLACKING ENTITY : %s\n\n", name)
        return name
      end

      return assert(info.id)
    end

    return val
  end


  local function check_props(E)
    local k = "props_" .. E.id

    local tab = skin[k]

    if not tab then return end

    table.merge(E, tab)
  end


  ---| Fab_replacements |---

  each B in fab.brushes do
    each C in B do
      if C.special and C.x     then C.special = check("line",   C.special) end
      if C.special and not C.x then C.special = check("sector", C.special) end

      if C.tag then C.tag = check_tag(C.tag) end

      if C.tex and C.x     then C.tex = check_tex (santize(C.tex)) end
      if C.tex and not C.x then C.tex = check_flat(santize(C.tex), C) end
    end
  end

  each E in fab.entities do
    check_props(E)

    E.id = check_thing(E.id)
  end
end



function Fabricate(main_skin, T, skins)
  if not main_skin.file then
    error("Old-style prefab skin used")
  end

  gui.debugf("=========  FABRICATE %s\n", main_skin.file)

  local fab = Fab_load_wad(main_skin.file)

  Fab_bound_Z(fab, main_skin)

  local skin = Fab_merge_skins(fab, main_skin, skins)

  Fab_substitutions(fab, skin)
  Fab_replacements(fab, skin)

  fab.state  = "skinned"

  fab.x_fit = main_skin.x_fit
  fab.y_fit = main_skin.y_fit
  fab.z_fit = main_skin.z_fit

  Fab_transform_XY(fab, T)
  Fab_transform_Z (fab, T)

  Fab_render(fab)

  return fab
end



function Fabricate_at(L, main_skin, T, skins)
  -- L can be a room or a hallway

  local fab = Fabricate(main_skin, T, skins)

  if L then
    Room_distribute_spots(L, Fab_read_spots(fab))
  end

  if main_skin.add_sky then
    if not L.sky_group then
      error("Prefab with add_sky used in indoor room : " .. tostring(main_skin.name))
    end

    if not T.bbox then
      error("Prefab with add_sky used in loose transform")
    end

    Build_sky_quad(T.bbox.x1, T.bbox.y1, T.bbox.x2, T.bbox.y2, L.sky_group.h)
  end
end

