------------------------------------------------------------------------
--  ROAD UTILITIES
------------------------------------------------------------------------
--
--  RandTrack : track generator for NFS1 (SE)
--
--  Copyright (C) 2014-2015 Andrew Apted
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 3
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this software.  If not, please visit the following
--  web page: http://www.gnu.org/licenses/gpl.html
--
------------------------------------------------------------------------


function match_side(name, side)
  if name == "left"  then return (side == LF) end
  if name == "right" then return (side == RT) end

  if TRACK.outer_side != nil then
    if name == "outer" then return (side == TRACK.outer_side) end
    if name == "inner" then return (side == (3 - TRACK.outer_side)) end
  end

  return false
end


function lookup_node(index)
  --
  -- On closed tracks, all index values return a valid node,
  -- wrapping around the beginning or end of the track.
  --
  -- On open tracks, returns NIL for out-of-bound indices.
  --
  if TRACK.closed then
    local num_nodes = TRACK.num_nodes

    while index < 1 do index = index + num_nodes end
    while index > num_nodes do index = index - num_nodes end
  end

  return TRACK.road[index]
end


function lookup_seg(index)
  if TRACK.closed then
    local num_segs = TRACK.num_segments

    while index < 1 do index = index + num_segs end
    while index > num_segs do index = index - num_segs end
  end

  return TRACK.segments[index]
end


function lookup_obj(name, required)
  local def = TRACK.info.objects[name]

  if not def then def = TRACK.info.groups[name] end

  if not def and required then
    error("Unknown object: " .. tostring(name))
  end

  return def
end


function lookup_tex(name)
  local def = TRACK.info.textures[name]

  if not def then
    error("Unknown texture: " .. tostring(name))
  end

  return def
end


function lookup_skin(name, none_ok)
  --
  -- This also handles alternate skins, e.g. 'plains2', 'plains3' when
  -- the requested skin name is "plains".
  --

  local function process_tex_list(list)
    if not list then
      return nil
    end

    local new_list = {}

    for i = 1,#list do
      table.insert(new_list, lookup_tex(list[i]))
    end

    return new_list
  end


  local function process_obj_list(list)
    if not list then
      return nil
    end

    local new_list = {}

    for i = 1,#list do
      local child = table.copy(list[i])

      if child.obj == "NONE" then continue end

      child.def = lookup_obj(child.obj, "required")

      table.insert(new_list, child)
    end

    return new_list
  end


  local function pick_from_alternates()
    local tab = {}
    
    for suffix = 1, 9 do
      local alt_name = name .. suffix

      -- no suffix for '1' (get normal skin)
      if suffix == 1 then alt_name = name end

      local skin = TRACK.info.skins[alt_name]

      if skin then
        tab[alt_name] = skin.prob or 50
      end
    end

    if table.empty(tab) then
      return nil
    end

    local alt_name = rand.key_by_probs(tab)

    return assert(TRACK.info.skins[alt_name])
  end


  ---| lookup_skin |---

  local def = pick_from_alternates()

  if not def then
    if none_ok then return nil end

    error("Unknown skin: " .. tostring(name))
  end

  local skin = table.copy(def)

  skin.edge_tex = process_tex_list(def.edge_tex)
  skin.road_tex = process_tex_list(def.road_tex)

  if skin.fence_tex then skin.fence_tex = lookup_tex(def.fence_tex) end

  skin.decoration = process_obj_list(def.decoration)

  if skin.entrance_obj then
     skin.entrance_def = lookup_obj(skin.entrance_obj, "required")
  end

  return skin
end


function prob_for_feature(name)
  local val = TRACK.info.features[name]

  if val == nil then return nil end

  if type(val) != "table" then return val end

  -- entry is a table like { 100, 20, 5 }
  -- use first value if never used feature before, second value if used once, etc...
  local list = val

  if #list == 0 then
    error("Bad probability list in info.features[]")
  end

  local index = (TRACK.used_features[name] or 0) + 1

  if index > #list then
     index = #list
  end

  return list[index]
end


------------------------------------------------------------------------


function r_get_coord(node, bit, side)
  if side == LF then
    bit = bit * -1
  end

  return node.coords[bit]
end


function r_set_coord(node, bit, side, dx, dy, dz)
  -- dx is perpendicular to the track
  -- dy is parallel to the track
  -- dz is vertical

  local mul = sel(side == LF, -1, 1)

  bit = bit * mul
  dx  =  dx * mul

  local x = node.x + dx * node.norm_x + dy * node.tan_x
  local y = node.y + dx * node.norm_y + dy * node.tan_y
  local z = node.z + dz

  node.coords[bit] = { x=x, y=y, z=z }
end


function r_delta_coord(node, bit, side,  ref, dx, dy, dz)
  -- dx is perpendicular to the track
  -- dy is parallel to the track
  -- dz is vertical

  local mul = sel(side == LF, -1, 1)

  bit = bit * mul
  ref = ref * mul
  dx  =  dx * mul

  local C = assert(node.coords[ref])

  local x = C.x + dx * node.norm_x + dy * node.tan_x
  local y = C.y + dx * node.norm_y + dy * node.tan_y
  local z = C.z + dz

  node.coords[bit] = { x=x, y=y, z=z }
end


function r_delta_coord_abs_z(node, bit, side,  ref, dx, dy, z)
  local mul = sel(side == LF, -1, 1)

  bit = bit * mul
  ref = ref * mul
  dx  =  dx * mul

  local C = assert(node.coords[ref])

  local x = C.x + dx * node.norm_x + dy * node.tan_x
  local y = C.y + dx * node.norm_y + dy * node.tan_y

  node.coords[bit] = { x=x, y=y, z=z }
end


function r_make_raw_object(def)
  if type(def) == "table" then

    if type(def[1]) == "table" then
      error("Cannot use group objects in a group!")
    end

    return table.copy(def)
  end

  return { id=def }
end


function r_make_object(def, priority)
  assert(def)

  -- randomize priority
  priority = priority + gui.random() * 0.5

  -- handle groups
  if type(def) == "table" and type(def[1]) == "table" then
    local OBJ = { group={} }

    each sub in def do
      local child_def = lookup_obj(sub.obj, "required")

      local child = r_make_raw_object(child_def)

      child.dx = (child.dx or 0) + (sub.dx or 0)
      child.dy = (child.dy or 0) + (sub.dy or 0)
      child.dz = (child.dz or 0) + (sub.dz or 0)

      child.rel_dx = (child.rel_dx or 0) + (sub.rel_dx or 0)

      child.flip     = sub.flip     or child.flip
      child.flip_LF  = sub.flip_LF  or child.flip_LF
      child.flip_RT  = sub.flip_RT  or child.flip_RT
      child.node_ofs = sub.node_ofs or child.node_ofs

      -- all children have same priority, this ensures proper prune
      -- behavior (i.e. either they all get pruned, or none).
      child.priority = priority

      table.insert(OBJ.group, child)
    end

    return OBJ
  end


  local OBJ = r_make_raw_object(def)

  OBJ.priority = priority

  return OBJ
end


function r_add_raw_object(OBJ, node, ref, side, dx, dy, dz)
  local mul = sel(side == LF, -1, 1)

  if OBJ.rel_dx then dx = dx + OBJ.rel_dx end

  if OBJ.kind == "fake" and OBJ.fake_size then
    dy = dy - OBJ.fake_size / 2
    if side == RT then dx = dx - OBJ.fake_size / 2 end
  end

  ref = ref * mul
  dx  =  dx * mul

  if OBJ.dx then dx = dx + OBJ.dx end
  if OBJ.dy then dy = dy + OBJ.dy end
  if OBJ.dz then dz = dz + OBJ.dz end


  local C = assert(node.coords[ref])

  assert(OBJ.id)

  OBJ.x = C.x + dx * node.norm_x + dy * node.tan_x
  OBJ.y = C.y + dx * node.norm_y + dy * node.tan_y
  OBJ.z = C.z + dz

  if OBJ.kind == "fake" then
    OBJ.flip = sel(side == LF, 0, 64)
  elseif not OBJ.flip then
    if OBJ.flip_LF and side == LF then
      OBJ.flip = OBJ.flip_LF
    elseif OBJ.flip_RT and side == RT then
      OBJ.flip = OBJ.flip_RT
    end
  end


  local node_ofs = OBJ.node_ofs

  -- the 3D objects (real or fake) seem to work best in the previous node
  if not node_ofs and (OBJ.kind == "fake" or OBJ.kind == "3d") then
    node_ofs = -1
  end

  if node_ofs then
    node = lookup_node(node.index + node_ofs)
    if not node then return end
  end

  table.insert(node.objects, OBJ)
end


function r_add_object(OBJ, node, ref, side, dx, dy, dz)
  if OBJ.group then
    each child in OBJ.group do
      r_add_raw_object(child, node, ref, side, dx, dy, dz)
    end
  else
    r_add_raw_object(OBJ, node, ref, side, dx, dy, dz)
  end
end


------------------------------------------------------------------------


function bezier_coord(S, C, E, t)
  -- t ranges from 0.0 to 1.0

  local ks = (1 - t) * (1 - t)
  local kc = 2 * (1 - t) * t
  local ke = t * t

  local x = S.x * ks + C.x * kc + E.x * ke
  local y = S.y * ks + C.y * kc + E.y * ke

  return x, y
end



function bezier_tangent(S, C, E, t)
  -- these are just the derivatives of equations above (bezier_coord)
  local ks = -1 + t
  local kc = 1 - 2 * t
  local ke = t

  local tan_x = S.x * ks + C.x * kc + E.x * ke
  local tan_y = S.y * ks + C.y * kc + E.y * ke

  return geom.unit_vector(tan_x, tan_y)
end


------------------------------------------------------------------------


function break_into_pieces(p1, p2, want_len)
  if p2 - p1 < 6 then
    return { {p1=p1, p2=p2} }
  end

  local total = p2 - p1 + 1

  local num = total / want_len

  num = int(num)

  if total > 100 then num = num - 1 end
  if total >  50 then num = num - 1 end

  if rand.odds(30) then num = num - 1 end

  if num < 2 then
    return { {p1=p1, p2=p2} }
  end

  local lens = {}

  for i = 1, num do
    lens[i] = int(total / num)
  end

  for i = 1, total % num do
    local k = rand.irange(1, num)
    lens[k] = lens[k] + 1
  end

  rand.shuffle(lens)

  -- randomize the lengths
  for loop = 1, num * 8 do
    local a = rand.irange(1, num)
    local b = rand.irange(1, num)

    if lens[a] >= 4 and lens[b] >= 4 then
      lens[a] = lens[a] + 1
      lens[b] = lens[b] - 1
    end
  end

  local list = {}

  for i = 1, num do
    table.insert(list, { p1=p1, p2=p1+lens[i]-1, frac=i/num })
    p1 = p1 + lens[i]
  end

  return list
end



function fractal_curve(list, len, h1, h2, delta)
  --
  -- Generate a one dimensional height map of given length.
  -- will be used for cave ceilings and hill heights.
  --
  -- Elements are added to end of 'list' parameter.
  --
  local curve = {}


  local function recurse_add(p1, p2, h1, h2, var)
    local width = p2 - p1

    assert(width > 0)

    -- termination condition
    if width < 2 then
      curve[p1] = h1
      return
    end

    local p3 = int((p1 + p2 + rand.sel(50, 1, 0)) / 2)
    local h3 = (h1 + h2) / 2 + rand.range(-var, var)

    recurse_add(p1, p3, h1, h3, var / 2)
    recurse_add(p3, p2, h3, h2, var / 2)
  end


  local function calc_smooth_value(idx)
    local sum = 0

    for ofs = -1, 1 do
      local use_ofs = math.clamp(1, idx + ofs, len)

      sum = sum + curve[use_ofs]
    end

    return sum / 3
  end


  ---| fractal_curve |---

  recurse_add(1, len, h1, h2, delta)

  curve[len] = h2

  for idx = 1, len do
    table.insert(list, calc_smooth_value(idx))
  end
end



function TEST_CURVES()
  local list = {}

  for n = 1, 9 do
    list[n] = {}
    fractal_curve(list[n], 100, 0, 5, 3.0)
  end

  for i = 1, 100 do
    for n = 1, 9 do
      stderrf("%1.3f ", list[n][i])
    end
    stderrf("\n")
  end
end

