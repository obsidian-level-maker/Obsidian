------------------------------------------------------------------------
--  BRUSHES and TRANSFORMS
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2015 Andrew Apted
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
------------------------------------------------------------------------


Trans = {}

brushlib = {}


function raw_add_brush(brush)
  each C in brush do
    -- compatibility cruft

    if C.face then
      table.merge(C, C.face)
      C.face = nil
    end

    if C.x_offset then C.u1 = C.x_offset ; C.x_offset = nil end
    if C.y_offset then C.v1 = C.y_offset ; C.y_offset = nil end
  end

  gui.add_brush(brush)

  if GAME.add_brush_func then
     GAME.add_brush_func(brush)
  end
end


function raw_add_entity(ent)
  -- skip unknown entities (from wad-fab loader)
  if not ent.id then return end

  if GAME.format == "quake" then
    ent.mangle = ent.angles ; ent.angles = nil
  end

  if GAME.format == "doom" then
    -- this is mainly for Legacy (spawning things on 3D floors)
    -- it is OK for this to be NIL
    ent.fs_name = FRAGGLESCRIPT_THINGS[ent.id]
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


------------------------------------------------------------------------
--  Transformative  Geometry
------------------------------------------------------------------------


Trans.TRANSFORM =
{
  -- mirror_x  : flip horizontally (about given X)
  -- mirror_y  : flip vertically (about given Y)

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

  -- fitted_x  : size which a "fitted" prefab needs to become
  -- fitted_y
  -- fitted_z
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



function Trans.brush(coords)

  -- FIXME: mirroring

  -- apply transform
  coords = table.copy(coords)

  each C in coords do
    if C.x then
      C.x, C.y = Trans.apply_xy(C.x, C.y)
    elseif C.b then
      C.b = Trans.apply_z(C.b)
    elseif C.t then
      C.t = Trans.apply_z(C.t)
    end

    if C.slope then
      C.slope = Trans.apply_slope(C.slope)
    end
  end

  brushlib.collect_flags(coords)

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
               GAME.PICKUPS[name] or
               GAME.NICE_ITEMS[name]

  if not info then
    gui.printf("\nLACKING ENTITY : %s\n\n", name)
    return
  end

  assert(info.id)

  x, y = Trans.apply_xy(x, y)
  z    = Trans.apply_z (z)

  if info.delta_z then
    z = z + info.delta_z
  elseif PARAM.entity_delta_z then
    z = z + PARAM.entity_delta_z
  end

  if info.spawnflags then
    props.spawnflags = (props.spawnflags or 0) + info.spawnflags
  end

  local ent = table.copy(props)

  ent.id = info.id
  ent.x  = x
  ent.y  = y
  ent.z  = z

  raw_add_entity(ent)
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


function Trans.spot_transform(x, y, z, dir)
  local ANGS = { [2]=0, [8]=180, [4]=270, [6]=90 }

  assert(x and y)

  return
  {
    add_x = x
    add_y = y
    add_z = z
    rotate = ANGS[dir or 2]
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


function Trans.edge_transform(x1,y1, x2,y2, z, side, long1, long2, deep, over)
  if side == 4 then x2 = x1 + deep ; x1 = x1 - over end
  if side == 6 then x1 = x2 - deep ; x2 = x2 + over end
  if side == 2 then y2 = y1 + deep ; y1 = y1 - over end
  if side == 8 then y1 = y2 - deep ; y2 = y2 + over end

  if side == 2 then x1 = x2 - long2 ; x2 = x2 - long1 end
  if side == 8 then x2 = x1 + long2 ; x1 = x1 + long1 end
  if side == 4 then y2 = y1 + long2 ; y1 = y1 + long1 end
  if side == 6 then y1 = y2 - long2 ; y2 = y2 - long1 end

  return Trans.box_transform(x1,y1, x2,y2, z, side)
end


function Trans.set_fitted_z(T, z1, z2)
  T.add_z    = z1
  T.fitted_z = z2 - z1
end



------------------------------------------------------------------------
--  Material  System
------------------------------------------------------------------------


function Mat_lookup(name)
  if not name then name = "_ERROR" end

  local mat = GAME.MATERIALS[name]

  -- special handling for DOOM switches
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


------------------------------------------------------------------------
--  Brush  Library
------------------------------------------------------------------------


DOOM_LINE_FLAGS =
{
  blocked     = 0x01
  block_mon   = 0x02
  sound_block = 0x40

  draw_secret = 0x20
  draw_never  = 0x80
  draw_always = 0x100

  pass_thru   = 0x200  -- Boom
}


HEXEN_ACTIONS =
{
  W1 = 0x0000, WR = 0x0200  -- walk
  S1 = 0x0400, SR = 0x0600  -- switch
  M1 = 0x0800, MR = 0x0A00  -- monster
  G1 = 0x0c00, GR = 0x0E00  -- gun / projectile
  B1 = 0x1000, BR = 0x1200  -- bump
}


function brushlib.quad(x1,y1, x2,y2, b,t)
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


function brushlib.triangle(x1,y1, x2,y2, x3,y3, b,t)
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


function brushlib.dump(brush, title)
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


function brushlib.copy(brush)
  local newb = {}

  each C in brush do
    table.insert(newb, table.copy(C))
  end

  return newb
end


function brushlib.mid_point(brush)
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


function brushlib.bbox(brush)
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


function brushlib.set_kind(brush, kind, props)
  -- remove any existing kind
  for i = 1, #brush do
    if brush[i].m then
      table.remove(brush, i)
      break;
    end
  end

  local C = { m=kind }

  if props then
    table.merge(C, props)
  end

  table.insert(brush, 1, C)
end


function brushlib.xy_coord(brush, x, y, props)
  local C = { x=x, y=y }

  if props then
    table.merge(C, props)
  end

  table.insert(brush, C)

  return C
end


function brushlib.add_top(brush, z, mat)
  -- Note: assumes brush has no top already!

  -- FIXME : stores 'mat' but should store 'tex'

  table.insert(brush, { t=z, mat=mat })
end


function brushlib.add_bottom(brush, z, mat)
  -- Note: assumes brush has no bottom already!

  table.insert(brush, { b=z, mat=mat })
end


function brushlib.get_bottom_h(brush)
  each C in brush do
    if C.b then return C.b end
  end

  return nil -- none
end


function brushlib.get_top_h(brush)
  each C in brush do
    if C.t then return C.t end
  end

  return nil -- none
end


function brushlib.set_tex(brush, wall, flat)
  each C in brush do
    if wall and C.x and not C.tex then
      C.tex = wall
    end
    if flat and (C.b or C.t) and not C.tex then
      C.tex = flat
    end
  end
end


function brushlib.set_mat(brush, wall, flat)
  if wall then
    wall = Mat_lookup(wall)
    wall = assert(wall.t)
  end

  if flat then
    -- handle the _LIQUID and _SKY materials

    if flat == "_LIQUID" and LEVEL.liquid then
      each C in brush do
        if C.b or C.t then
          C.special = C.special or LEVEL.liquid.special
          C.light   = C.light   or LEVEL.liquid.light
        end
      end
    end

    if flat == "_SKY" then
      brushlib.set_kind(brush, "sky")
    end

    flat = Mat_lookup(flat)
    flat = assert(flat.f or flat.t)
  end

  brushlib.set_tex(brush, wall, flat)
end


function brushlib.set_line_flag(brush, key, value)
  each C in brush do
    if C.x then
      C[key] = value
    end
  end
end


function brushlib.collect_flags(coords)
  each C in coords do
    -- these flags only apply to linedefs
    if not C.x then continue end

    if GAME.format == "doom" then
      local flags = C.flags or 0

      if C.act and GAME.sub_format == "hexen" then
        local spac = HEXEN_ACTIONS[C.act]
        if not spac then
          error("Unknown act value: " .. tostring(C.act))
        end
        flags = bit.bor(flags, spac)
      end

      each name,value in DOOM_LINE_FLAGS do
        if C[name] and C[name] != 0 then
          flags = bit.bor(flags, value)
          C[name] = nil
        end
      end

      if flags != 0 then
        C.flags = flags

        -- this makes sure the flags get applied
        if not C.special then C.special = 0 end
      end
    end
  end -- C
end


function brushlib.has_sky(brush)
  each C in brush do
    if C.mat == "_SKY" then return true end
  end

  return false
end


function brushlib.is_quad(brush)
  local x1,y1, x2,y2 = brushlib.bbox(brush)

  each C in brush do
    if C.x then
      if C.x > x1+0.1 and C.x < x2-0.1 then return false end
      if C.y > y1+0.1 and C.y < y2-0.1 then return false end
    end
  end

  return true
end


function brushlib.reverse(brush)
  -- need this when mirroring across a single axis (X or Y).
  -- the given brush is modified (by shifting XY coordinates around).

  -- Note: does not actually do the mirroring (we assume Trans.apply_xy already did it)

  local xy_coords = {}

  each C in brush do
    if C.x then
      table.insert(xy_coords, { idx=_index, x=C.x, y=C.y })
    end
  end

  if #xy_coords < 2 then return end

  -- first, shift actual coordinate values into next table

  for i = 1, #xy_coords do
    local k = i + 1
    if k > #xy_coords then k = 1 end

    local C = brush[xy_coords[i].idx]

    C.x = xy_coords[k].x
    C.y = xy_coords[k].y
  end

  -- second, actually reverse the coord tables

  for i = 1, int(#xy_coords / 2) do
    local k = #xy_coords + 1 - i

    local C1 = brush[xy_coords[i].idx]
    local C2 = brush[xy_coords[k].idx]

    brush[xy_coords[i].idx] = C2
    brush[xy_coords[k].idx] = C1
  end
end


function brushlib.line_passes_through(brush, px1, py1, px2, py2)
  -- Note: returns false if line merely touches an edge

  local front, back

  each C in brush do
    if C.x then
      local d = geom.perp_dist(C.x, C.y, px1,py1, px2,py2)

      if d >  0.9 then front = true end
      if d < -0.9 then  back = true end

      if front and back then return true end
    end
  end

  return false
end

