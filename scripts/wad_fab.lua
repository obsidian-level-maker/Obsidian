----------------------------------------------------------------
--  WAD PREFAB SYSTEM
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2013-2014 Andrew Apted
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

  [  37] = { kind="goal", r=64 }  -- red pillar with skull

  -- lighting

  [  34] = { kind="light" }  -- candle
}


WADFAB_LIGHT_DELTAS =
{
  [1]  =  48  -- random off
  [2]  =  48  -- blink fast
  [12] =  48  -- blink fast, sync
  [3]  =  48  -- blink slow
  [13] =  48  -- blink slow, sync
  [17] =  48  -- flickers

  [8]  =  96  -- oscillates
}


WADFAB_REACHABLE = 992
WADFAB_MOVER     = 995
WADFAB_DOOR      = 996
WADFAB_DELTA_12  = 997



function Fab_expansion_groups(list, axis_name, fit_size, pf_size)
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


  -- compute total weight of expanding sections
  local total_weight = 0

  for i = 1, #list-1, 2 do
    local weight = list[i+1] - list[i]
    total_weight = total_weight + weight
  end

  assert(total_weight > 0)


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
      local weight = list[i+1] - list[i]
      G.size2 = G.size2 + extra * weight / total_weight
    end

    G.low2  = pos
    G.high2 = pos + G.size2

    pos = pos + G.size2

    table.insert(groups, G)
  end

  return groups
end


function is_subst(value)
  return type(value) == "string" and string.match(value, "^[!?]")
end


function Fab_substitute(SKIN, value)
  if not is_subst(value) then
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

  if value == nil or is_subst(value) then
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

    Trans.TRANSFORM.groups_x = Fab_expansion_groups(fab.x_fit, "x", T.fitted_x, bbox.x2)

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

    Trans.TRANSFORM.groups_y = Fab_expansion_groups(fab.y_fit, "y", T.fitted_y, bbox.y2)

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

    Trans.TRANSFORM.groups_z = Fab_expansion_groups(fab.z_fit, "z", T.fitted_z, bbox.z2)

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
      -- Brush_dump(B)

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

    if brushlib.is_quad(B) then
      x1,y1, x2,y2 = brushlib.bbox(B)

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
      rank  = B[1].rank

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


function Fab_parse_edges(skin)
  --| convert the 'north', 'east' (etc) fields of a skin into
  --| a list of portals in a 2D array.
  
  if skin._seed_map then return end

  -- create the seed map
  if not skin.seed_w then skin.seed_w = 1 end
  if not skin.seed_h then skin.seed_h = 1 end

  local W = skin.seed_w
  local H = skin.seed_h

  local map = table.array_2D(W, H)

  skin._seed_map = map


  -- initialize it
  for x = 1, W do
  for y = 1, H do
    map[x][y] = { edges={} }
  end
  end


  -- also determine the maximum floor_h (if absent from skin)
  local max_floor_h = 0


  local function lookup_edge(char)
    if char == '#' then return nil end

    if char == '.' then return { f_h=0 } end

    if not string.match(char, "[a-z]") then
      error("Illegal char in prefab edge string: " .. char)
    end

    local edge = skin.edges and skin.edges[char]

    if not edge then
      error("Unknown edge in prefab edge string: " .. char)
    end

    return edge
  end


  local function parse_edge(dir, str)
    -- check stuff
    if type(str) != "string" then
      error("bad edge string in prefab skin")
    elseif #str != geom.vert_sel(dir, W, H) then
      error("edge string does not match prefab size")
    end

    -- process each element of the edge string
    for n = 1, #str do
      local x, y

      if dir == 2 then x = n ; y = 1 end
      if dir == 8 then x = n ; y = H end
      if dir == 4 then x = 1 ; y = n end
      if dir == 6 then x = W ; y = n end

      local edge = lookup_edge(string.sub(str, n, n))

      map[x][y].edges[dir] = edge

      if type(edge) == "table" and edge.f_h then
        max_floor_h = math.max(max_floor_h, edge.f_h)
      end
    end
  end


  each k, edge in skin do
    if k == "north" then parse_edge(8, edge) end
    if k == "south" then parse_edge(2, edge) end
    if k == "east"  then parse_edge(6, edge) end
    if k == "west"  then parse_edge(4, edge) end
  end

  if not skin.max_floor_h then
    skin.max_floor_h = max_floor_h
  end
end


------------------------------------------------------------------------


DOOM_TWO_SIDED_FLAG = 0x04


function Fab_load_wad(name)

  local fab

  local function copy_coord(S, C, pass)

    local C2 = { x=C.x, y=C.y }

    local side
    local line

    if C.side then side = gui.wadfab_get_side(C.side) end
    if C.line then line = gui.wadfab_get_line(C.line) end

    local flags = (line and line.flags) or 0

    local two_sided = (bit.band(flags, DOOM_TWO_SIDED_FLAG) != 0)


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
    if line and not two_sided then
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

    if pass == 1 and two_sided and mid_tex then
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
      elseif S.special == WADFAB_MOVER then
        B[1].mover = 1
      elseif S.special == WADFAB_DOOR then
        -- not used on the floor
      elseif S.special == WADFAB_DELTA_12 then
        C.delta_z = -12
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

      if S.special == WADFAB_DOOR then
        B[1].mover = 1
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


  local function skill_to_rank(flags)
    if not flags then return 2 end

    if bit.band(flags, 2) != 0 then return 2 end
    if bit.band(flags, 4) != 0 then return 3 end

    return 1
  end


  local function angle_to_light(angle)
    if not angle then return 160 end

    if angle < 0 then angle = angle + 360 end

    angle = math.clamp(0, angle, 300)

    return 112 + int(angle * 16 / 45)
  end


  local function handle_entity(fab, E)
    local spot_info = WADFAB_ENTITIES[E.id]

    if not spot_info then
      table.insert(fab.entities, E)
      return
    end

    -- logic to add light entities:
    --   - angle controls level (0 = 112, 45 = 128, ..., 315 = 224)
    if spot_info.kind == "light" then
      E.id = "light"

      E.light = angle_to_light(E.angle)
      E.angle = nil

      E.factor = 1.0
      E.flags  = nil

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
    B[1].rank  = skill_to_rank(E.flags)

    -- the "ambush" (aka Deaf) flag means a caged monster
    local MTF_Ambush = 8

    if spot_info.kind == "monster" and bit.band(E.flags or 0, MTF_Ambush) != 0 then
      B[1].spot_kind = "cage"
    end

    local r = spot_info.r

    table.insert(B, { x = E.x - r, y = E.y - r })
    table.insert(B, { x = E.x + r, y = E.y - r })
    table.insert(B, { x = E.x + r, y = E.y + r })
    table.insert(B, { x = E.x - r, y = E.y + r })

    table.insert(B, { b = E.z })
    table.insert(B, { t = E.z + 128 })

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
    "tex_", "flat_", "thing_"
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

    while is_subst(value) do

      if seen[value] then
        -- failed !
        gui.debugf("\nSKIN =\n%s\n\n", table.tostr(SKIN))
        error("Fab_substitutions: recursive refs (" .. tostring(value) .. ")")
      end

      seen[value] = 1

      value = Fab_substitute(SKIN, value)
    end

    return value
  end


  local function subst_pass(keys)
    each name in keys do
      local value = SKIN[name]

      if is_subst(value) then
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

  local function sanitize_char(ch)
    if ch == "-" or ch == " " or ch == "_" then return "_" end

    if string.match(ch, "%w") then return ch end

    -- convert a weird character to a lowercase letter
    local num = string.byte(ch)
    if (num < 0) then num = -num end
    num = num % 26;

    return string.sub("abcdefghijklmnopqrstuvwxyz", num, num)
  end


  local function sanitize(name)
    name = string.upper(name)

    local s = ""

    for i = 1,#name do
      s = s .. sanitize_char(string.sub(name, i, i))
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
      C.factor = 1.0
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
                   GAME.PICKUPS[name] or
                   GAME.NICE_ITEMS[name]

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

      if C.tex and C.x     then C.tex = check_tex (sanitize(C.tex)) end
      if C.tex and not C.x then C.tex = check_flat(sanitize(C.tex), C) end

      if C.rail and C.x    then C.rail = check_tex(sanitize(C.rail)) end
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


function Fabricate_at(R, main_skin, T, skins)
  local fab = Fabricate(main_skin, T, skins)

  if R then
    Room_distribute_spots(R, Fab_read_spots(fab))
  end

  if main_skin.add_sky then
    if not R.sky_group then
      error("Prefab with add_sky used in indoor room : " .. tostring(main_skin.name))
    end

    if not T.bbox then
      error("Prefab with add_sky used in loose transform")
    end

    Trans.sky_quad(T.bbox.x1, T.bbox.y1, T.bbox.x2, T.bbox.y2, R.sky_group.h)
  end
end

