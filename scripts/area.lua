------------------------------------------------------------------------
--  AREA MANAGEMENT
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2017 Andrew Apted
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


--class AREA
--[[
    --- kind of area ---

    id, name  -- debugging info

    mode : keyword  -- "floor"  (a flat traversible part of a normal room)
                    -- "nature" (a non-flat traversible part of a cave or park)
                    -- "liquid"
                    -- "cage"

                    -- "chunk" (whole area is a single chunk)
                    -- "scenic"
                    -- "void"

    is_outdoor    -- true if outdoors (sky ceiling)
    is_boundary   -- true for areas outside the boundary line


    room : ROOM

    zone : ZONE

    chunk : CHUNK   -- only used when mode == "chunk"

    border_type : keyword  -- "simple_fence"
                           -- "watery_drop"

    facade_group : FACADE_GROUP   -- used by facade logic (temporarily)


    --- geometry of area ---

    seeds : list(SEED)

    svolume : number   -- number of seeds (0.5 for diagonals)

    neighbors : list(AREA)
    corner_neighbors : list(AREA)

    edges : list(EDGE)

    inner_points : list(CORNER)

    floor_h     -- floor height
    ceil_h      -- ceiling height

    floor_mat   -- floor material
    ceil_mat    -- ceiling material  [ "_SKY" for outdoor areas ]

    floor_side  -- floor side material (optional)
    ceil_side   -- ceiling side material (optional)

    lighting    -- ambient lighting for the area


    --- nature stuff ---

    cw, ch   -- total size of the cell grid

    base_sx, base_sy  -- the bottom-left seed coordinate
    base_x,  base_y   -- real coordinate for bottom-left cell

    external_sky    -- true when sky is built by area (NOT the cells)

    walk_map : GRID  -- marks which parts are usable:
                     --    nil : never touched (e.g. other rooms)
                     --    -1  : forced off [ floor ]
                     --    +1  : forced on  [ wall ]
                     --     0  : normal processing

    walk_rects : list(RECT)  -- all places the player MUST be able
                             -- walk to (conns, goals, etc...)

    diagonals : array   -- marks which cells are on a diagonal seed
                        -- (using the numbers 1/3/7/9)

    blobs : array(BLOB)  -- info for each 64x64 block
                         -- [ used for the final rendering of cells ]

    delta_x_map : array
    delta_y_map : array

    walk_floors : list(BLOB)  -- floors where player can travel and
                              -- monsters/items can be placed


    --- Cave specific fields ---

    cave_map : GRID   -- the raw generated cave

    step_mode   : keyword  -- "walkway", "up", "down", "mixed"

    liquid_mode : keyword  -- "none", "some", "lake"

    sky_mode    : keyword  -- "none"
                           -- "some" (indoor rooms only)
                           -- "low_wall", "high_wall"  (outdoor rooms)

    torch_mode  : keyword  -- "none", "few", "some"

    cave_lights : list     -- position of lamps and other point-lights
--]]


--class AREA_EDGE
--[[
    S : seed
    dir : dir
--]]


--class FACADE_GROUP
--[[
    zone_diff  -- true if this group touches a zone difference
--]]


--class SYMMETRY
--[[
    -- contains info about the symmetry in a room

    kind    -- "mirror" or "rotate"

    x, y    -- seed coordinate for focal point

    x2, y2  -- for "rotate" kind, defines the central bbox (with x+y)

    dir     -- for "mirror" kind, direction of axis of symmetry

    transform : function   -- find mirrored peer of a seed
    conv_dir  : function   -- convert 'dir' for the other side
    on_axis   : function   -- check if a seed coord is on axis of symmetry
--]]


--class JUNCTION
--[[
    --
    -- A "junction" is information about how two touching areas interact.
    -- It could be a solid wall, fence, or even nothing at all.
    --
    -- The junction kind can be overridden by a specific EDGE object.
    -- For example, solid walls are inhibited where two rooms connect
    -- to each other.
    --

    A1 : AREA
    A2 : AREA   -- can be special value "map_edge"

    --
    -- These are "pseudo edges" which will be used to render the
    -- junction.  They do not contain position info (S and dir).
    --
    -- By default these are absent, which means "do nothing".
    -- For straddlers (like fences) one side should be "nothing".
    -- For map edges, E2 is not used.
    --

    E1 : EDGE
    E2 : EDGE

    perimeter    -- a measure of length of the border between the areas
                 -- (in units of seed-edges)
--]]


--class CORNER
--[[
    --
    -- Records all the areas and junctions which meet at the corner of
    -- every seed.
    --

    kind : keyword   -- NIL for nothing, otherwise can be:
                     -- "post" (thin), "pillar" (fat)

    cx, cy  -- corner coordinate [1..SEED_W+1 / 1..SEED_H+1]

    x, y    -- map coordinate

    areas : list(AREA)

    junctions : list(JUNCTION)

    edges : list(EDGE)

     walls[DIR]  -- used for filling corner gaps
    fences[DIR]  --

    inner_point : AREA  -- usually NIL
--]]


AREA_CLASS = {}


function AREA_CLASS.new(mode)
  local A =
  {
    id   = alloc_id("area")
    mode = mode
    svolume = 0

    conns = {}
    seeds = {}
    neighbors = {}
    corner_neighbors = {}
    edges = {}

    inner_points = {}
    floor_brushes = {}
    side_edges = {}
  }

  A.name = "AREA_" .. A.id

  table.set_class(A, AREA_CLASS)

  table.insert(LEVEL.areas, A)

  return A
end


function AREA_CLASS.kill_it(A, remove_from_room)
  --
  -- NOTE : this can only be called fairly early, e.g. before all the
  --        neighbor lists and junctions are created.
  --

  assert(not A.is_dead)

  if A.mode == "chunk" then
    A.chunk:kill_it()
  end

  table.kill_elem(LEVEL.areas, A)

  if A.room and remove_from_room then
    table.kill_elem(A.room.areas, A)
  end

  A.id   = -1
  A.name = "DEAD_" .. A.name
  A.is_dead = true

  A.mode = "DEAD"
  A.kind = "DEAD"

  A.room  = nil
  A.zone  = nil
  A.conns = nil
  A.chunk = nil

  each S in A.seeds do
    S.area = nil
    S.room = nil
  end
end


function AREA_CLASS.calc_seed_bbox(A)
  local first_S = A.seeds[1]

  local sx1, sy1 = first_S.sx, first_S.sy
  local sx2, sy2 = first_S.sx, first_S.sy

  each S in A.seeds do
    sx1 = math.min(sx1, S.sx)
    sy1 = math.min(sy1, S.sy)

    sx2 = math.max(sx2, S.sx)
    sy2 = math.max(sy2, S.sy)
  end

  return sx1, sy1, sx2, sy2
end


function AREA_CLASS.calc_real_bbox(A)
  local sx1, sy1, sx2, sy2 = A:calc_seed_bbox()

  local S1 = SEEDS[sx1][sy1]
  local S2 = SEEDS[sx2][sy2]

  return S1.x1, S1.y1, S2.x2, S2.y2
end


function AREA_CLASS.remove_dead_seeds(A)
  for i = #A.seeds, 1, -1 do
    if A.seeds[i].is_dead then
      table.remove(A.seeds, i)
    end
  end
end


function AREA_CLASS.calc_volume(A)
  local vol = 0

  each S in A.seeds do
    if S.diagonal then
      vol = vol + 0.5
    else
      vol = vol + 1
    end
  end

  A.svolume = vol
end


function AREA_CLASS.touches(A, N)
  return table.has_elem(A.neighbors, N)
end


function AREA_CLASS.has_conn(A)
  each C in LEVEL.conns do
    if C.kind != "teleporter" and (C.A1 == A or C.A2 == A) then
      return true
    end
  end

  return false
end


function AREA_CLASS.is_indoor(A)
  if A.mode == "scenic" then return false end

  if not A.is_outdoor then return true end
  if A.mode == "void" then return true end

  if A.chunk and A.chunk.kind == "closet" then return true end
  if A.chunk and A.chunk.kind == "joiner" then return true end

  return false
end


function AREA_CLASS.get_height(A)
  if not A.floor_h then return nil end
  if not A.ceil_h  then return nil end

  return A.ceil_h - A.floor_h
end


function AREA_CLASS.highest_neighbor(A)
  local best
  local best_h

  -- FIXME : handle "nature" areas better (checks cells along the junction)

  each N in A.neighbors do
    if N.room == A.room and N.mode == "floor" and N.floor_h then
      local f_h = N.max_floor_h or N.floor_h

      if not best or f_h > best_h or
         -- use ceiling heights to break ties
         (f_h == best_h and (N.ceil_h or 9999) < (best.ceil_h or 9999))
      then
        best   = N
        best_h = f_h
      end
    end
  end

  return best
end


function AREA_CLASS.lowest_neighbor(A)
  local best

  -- FIXME : handle "nature" areas better (checks cells along the junction)

  each N in A.neighbors do
    if N.room == A.room and N.mode == "floor" and N.floor_h then
      if not best or N.floor_h < best.floor_h or
         -- use ceiling heights to break ties
         (N.floor_h == best.floor_h and (N.ceil_h or 9999) > (best.ceil_h or 9999))
      then
        best = N
      end
    end
  end

  return best
end


------------------------------------------------------------------------


function Symmetry_transform(sym, S)
  local x, y = S.sx, S.sy

  if sym.kind == "rotate" then
    x = sym.x2 - (x - sym.x)
    y = sym.y2 - (y - sym.y)

    if not Seed_valid(x, y) then return nil end
    local N = SEEDS[x][y]

    -- for diagonal seeds, always swap bottom and top
    if S.top then N = N.top or N end
    return N
  end

  -- mirror cases --

  if sym.dir == 2 or sym.dir == 8 then
    x = sym.x * 2 + sel(sym.wide, 1, 0) - x
  end

  if sym.dir == 4 or sym.dir == 6 then
    y = sym.y * 2 + sel(sym.wide, 1, 0) - y
  end

  if sym.dir == 1 or sym.dir == 9 then
    x = sym.x + (y - sym.y)
    y = sym.y + (x - sym.x)
  end

  if sym.dir == 3 or sym.dir == 7 then
    x = sym.x - (y - sym.y)
    y = sym.y - (x - sym.x)
  end

  if not Seed_valid(x, y) then return nil end
  local N = SEEDS[x][y]

  if sym.dir == 2 or sym.dir == 8 then
    return N
  end

  if sym.dir == 4 or sym.dir == 6 then
    if S.top then N = N.top or N end
    return N
  end

  if sym.dir == 1 or sym.dir == 9 then
    -- only swap top and bottom when diagonal matches axis of symmetry
    if S.diagonal == 1 or S.diagonal == 9 then
      if S.top then N = N.top or N end
      return N
    else
      if S.bottom then N = N.top or N end
      return N
    end
  end

  if sym.dir == 3 or sym.dir == 7 then
    if S.diagonal == 3 or S.diagonal == 7 then
      if S.top then N = N.top or N end
      return N
    else
      if S.bottom then N = N.top or N end
      return N
    end
  end

  error("Symmetry_conv_dir: weird dir")
end


function Symmetry_conv_dir(sym, dir)
  if sym.kind == "rotate" then return 10 - dir end

  if sym.dir == 2 or sym.dir == 8 then return geom.MIRROR_X[dir] end
  if sym.dir == 4 or sym.dir == 6 then return geom.MIRROR_Y[dir] end

  if sym.dir == 1 or sym.dir == 9 then return geom.TRANSPOSE[dir] end
  if sym.dir == 3 or sym.dir == 7 then return geom.TRANS_37[dir] end

  error("Symmetry_conv_dir: weird dir")
end


function Symmetry_on_axis(sym, x, y)
  -- no axis for 180-degree rotational symmetry
  if sym.kind == "rotate" then return false end

  -- on the "wide" version, axis is the line between two seeds
  if sym.wide then return false end

  if sym.dir == 2 or sym.dir == 8 then
    return x == sym.x
  end

  if sym.dir == 4 or sym.dir == 6 then
    return y == sym.y
  end

  local dx = sym.x - x
  local dy = sym.y - y

  if sym.dir == 3 or sym.dir == 7 then
    dx = -dx
  end

  return dx == dy
end


function Symmetry_new(kind)
  local SYM =
  {
    kind = kind

    transform = Symmetry_transform
    conv_dir  = Symmetry_conv_dir
    on_axis   = Symmetry_on_axis
  }

  return SYM
end


------------------------------------------------------------------------


function Junction_lookup(A1, A2, create_it)
  -- one area can be the special keyword "map_edge"

  -- returns NIL when areas do not touch, or A1 == A2

  if A1 == A2 then return nil end

  if A1 == "map_edge" then A1, A2 = A2, A1 end

  local index

  if A2 == "map_edge" then
    index = tostring(A1.id) .. "_map_edge"
  else
    local low_id  = math.min(A1.id, A2.id)
    local high_id = math.max(A1.id, A2.id)

    index = tostring(low_id) .. "_" .. tostring(high_id)
  end

  if create_it then
    if not LEVEL.junctions[index] then
      LEVEL.junctions[index] = { A1=A1, A2=A2, perimeter=0 }
    end
  end

  return LEVEL.junctions[index]
end



function Junction_init()
  -- this is a dictionary, looked up via a string formed from the IDs of
  -- the two areas.
  LEVEL.junctions = {}

  each A in LEVEL.areas do
  each N in A.neighbors do
    Junction_lookup(A, N, "create_it")
  end
  end

  -- compute the perimeter of each junction.

  each A in LEVEL.areas do
  each S in A.seeds do
  each dir in geom.ALL_DIRS do

    local N = S:neighbor(dir, "NODIR")

    if N == "NODIR" then continue end

    -- edge of map?
    if not (N and N.area) then
      local junc = Junction_lookup(A, "map_edge", "create_it")

      junc.perimeter = junc.perimeter + 1
      continue
    end

    if N.area == S.area then continue end

    local junc = Junction_lookup(A, N.area)

    if dir < 5 then
      junc.perimeter = junc.perimeter + 1
    end

  end -- A, S, dir
  end
  end

--[[ DEBUG
  each name,J in LEVEL.junctions do
    gui.printf("Junc %s : perimeter %d\n", name, J.perimeter)
  end
--]]
end


function Junction_make_empty(junc)
  junc.E1 = { kind="nothing" }
  junc.E2 = { kind="nothing" }
end


function Junction_make_map_edge(junc)
  local A = junc.A1
  local mat

  if A.room and not A.is_outdoor then
    mat = A.room.main_tex
  elseif A.zone then
    mat = A.zone.facade_mat
  else
    mat = "_DEFAULT"
  end

  assert(mat)

  junc.E1 = { kind="wall", area=A, wall_mat=mat }
  junc.E2 = { kind="nothing" }

  if A.is_outdoor and A.floor_h then
    junc.E1.kind = "sky_edge"
  end
end


function Junction_calc_wall_tex(A1, A2)

  if A1.zone != A2.zone then
    if A1.room and not A1.is_outdoor then
      return assert(A1.room.main_tex)
    end

    if A1.is_boundary and A1.touches_edge and A2.is_boundary then
      return LEVEL.cliff_mat
    end

    return assert(A1.zone.facade_mat)
  end

  if A1.is_outdoor and A2:is_indoor() then
    if A2.facade_crap then
      return A2.facade_crap
    end

    return assert(A1.zone.facade_mat)
  end

  if A1.room then
    return assert(A1.room.main_tex)
  else
    return assert(A1.zone.fence_mat)
  end
end


function Junction_make_wall(junc)
  for pass = 1, 2 do
    local A1 = sel(pass == 1, junc.A1, junc.A2)
    local A2 = sel(pass == 1, junc.A2, junc.A1)

    assert(A2 != "map_edge")

    -- do not need walls inside a void area
    if A1.mode == "void" then continue end

    local E = { kind="wall", area=A1 }

    E.wall_mat = Junction_calc_wall_tex(A1, A2)

    if pass == 1 then
      junc.E1 = E
    else
      junc.E2 = E
    end
  end
end


function Junction_calc_fence_z(A1, A2)
  local z1 = A1.floor_h
  local z2 = A2.floor_h

  if A1.podium_h then z1 = z1 + A1.podium_h end
  if A2.podium_h then z2 = z2 + A2.podium_h end

  if A1.room then z1 = math.max(z1, A1.room.max_floor_h) end
  if A2.room then z2 = math.max(z2, A2.room.max_floor_h) end

  local top_z = math.max(z1, z2)

  return top_z + PARAM.jump_height + 8
end


function Junction_make_fence(junc)
  junc.E1 =
  {
    kind = "fence"
    fence_mat = assert(junc.A1.zone.fence_mat)
    fence_top_z = Junction_calc_fence_z(junc.A1, junc.A2)
    area = junc.A1
  }

  junc.E2 = { kind="nothing", area=junc.A2 }

  junc.E1.peer = junc.E2
  junc.E2.peer = junc.E1
end


function Junction_make_railing(junc, rail_mat, block)
  junc.E1 =
  {
    kind = "railing"
    rail_mat = assert(rail_mat)
    rail_block = block and 1
    area = junc.A1
  }

  -- calculate base Z
  -- TODO : handle "nature" areas better (checks cells along the junction)
  local z1 = junc.A1.max_floor_h or junc.A1.floor_h
  local z2 = junc.A2.max_floor_h or junc.A2.floor_h

  if junc.A1.mode == "scenic" then z1 = z2 end
  if junc.A2.mode == "scenic" then z2 = z1 end

  junc.E1.rail_z = math.max(z1, z2)

  junc.E2 = { kind="nothing", area=junc.A2 }

  junc.E1.peer = junc.E2
  junc.E2.peer = junc.E1
end


function Junction_make_steps(junc)
  assert(not junc.E1)
  assert(not junc.E2)

  junc.E1 =
  {
    kind = "steps"
    steps_mat = assert(A.zone.steps_mat)
    steps_z1 = math.min(A.floor_h, A2.floor_h)
    steps_z2 = math.max(A.floor_h, A2.floor_h)
  }

  junc.E2 = { kind="nothing" }

  -- ensure edge is on the correct side (the lowest one)
  if junc.A1.floor_h > junc.A2.floor_h then
    junc.E1, junc.E2 = junc.E2, junc.E1
  end

  junc.E1.area = junc.A1
  junc.E2.area = junc.A2
end


------------------------------------------------------------------------


function Corner_lookup(cx, cy)
  assert(table.valid_pos(LEVEL.corners, cx, cy))

  local corner = LEVEL.corners[cx][cy]

  return assert(corner)
end



function Corner_init()
  LEVEL.corners = table.array_2D(SEED_W + 1, SEED_H + 1)

  for cx = 1, LEVEL.corners.w do
  for cy = 1, LEVEL.corners.h do
    local CORNER =
    {
      cx = cx
      cy = cy
      x = BASE_X + (cx-1) * SEED_SIZE
      y = BASE_Y + (cy-1) * SEED_SIZE
      areas = {}
      junctions = {}
      edges = {}
      walls = {}
      fences = {}
    }

    LEVEL.corners[cx][cy] = CORNER
  end
  end

  -- find touching areas

  each A in LEVEL.areas do
  each S in A.seeds do
  each dir in geom.CORNERS do

    if S.diagonal and S.diagonal == (10 - dir) then continue end

    local corner = S:get_corner(dir)

    table.add_unique(corner.areas, A)

  end  -- A, S, dir
  end
  end

  -- collect the junctions

  for cx = 1, LEVEL.corners.w do
  for cy = 1, LEVEL.corners.h do
    local corner = LEVEL.corners[cx][cy]

    for i = 1, #corner.areas do
    for k = i + 1, #corner.areas do
      local A1 = corner.areas[i]
      local A2 = corner.areas[k]

      local junc = Junction_lookup(A1, A2)

      if junc then
        table.add_unique(corner.junctions, junc)
      end

      table.add_unique(A1.corner_neighbors, A2)
      table.add_unique(A2.corner_neighbors, A1)
    end
    end
  end -- cx, cy
  end
end



function Corner_detect_zone_diffs()

  local function has_zone_diff(corner)
    local has_diff    = false
    local has_outdoor = false

    for i = 1, #corner.areas do
    for k = i + 1, #corner.areas do
      local A1 = corner.areas[i]
      local A2 = corner.areas[k]

      if A1.zone != A2.zone then
        has_diff = true
      end

      if A1.is_outdoor or A2.is_outdoor then
        has_outdoor = true
      end
    end
    end

    return has_diff and has_outdoor
  end


  local function update_groups(corner)
    each A in corner.areas do
      if A.facade_group then
         A.facade_group.zone_diff = true
      end
    end
  end


  ---| Corner_detect_zone_diffs |---

  for cx = 1, LEVEL.corners.w do
  for cy = 1, LEVEL.corners.h do
    local corner = LEVEL.corners[cx][cy]

    if has_zone_diff(corner) then
       update_groups(corner)
    end

  end -- cx, cy
  end
end



function Corner_add_edge(E)
  -- compute the "left most" corner coord
  local cx = E.S.sx
  local cy = E.S.sy

  if E.dir == 2 or E.dir == 6 or E.dir == 1 or E.dir == 3 then cx = cx + 1 end
  if E.dir == 8 or E.dir == 6 or E.dir == 9 or E.dir == 3 then cy = cy + 1 end

  -- compute delta and # of corners to visit
  local dx, dy = geom.delta(geom.RIGHT[E.dir])

  for i = 1, E.long + 1 do
    local corner = Corner_lookup(cx, cy)

    table.insert(corner.edges, E)

    cx = cx + dx
    cy = cy + dy
  end
end



function Corner_mark_walls(E)
  -- compute the "left most" corner coord
  local cx = E.S.sx
  local cy = E.S.sy

  local wall_mat = Edge_wallish_tex(E)

  if E.dir == 2 or E.dir == 6 or E.dir == 1 or E.dir == 3 then cx = cx + 1 end
  if E.dir == 8 or E.dir == 6 or E.dir == 9 or E.dir == 3 then cy = cy + 1 end

  -- compute delta and # of corners to visit
  local along_dir = geom.RIGHT[E.dir]
  local dx, dy = geom.delta(along_dir)

  -- iterate over both corners of edge (left side then right side)
  for pass = 1, 2 do
    local corner = Corner_lookup(cx, cy)

--  stderrf("Corner_mark_walls @ (%d %d)  E=%s dir:%d\n", cx, cy, E.kind, E.dir)

    local dir = sel(pass == 1, along_dir, 10 - along_dir)

    if not corner.walls[dir] then
      corner.walls[dir] = {}
    end

    if pass == 1 then
      corner.walls[dir].R = wall_mat
    else
      corner.walls[dir].L = wall_mat
    end

    cx = cx + dx * E.long
    cy = cy + dy * E.long
  end
end



function Corner_mark_fences(E)
  -- compute the "left most" corner coord
  local cx = E.S.sx
  local cy = E.S.sy

  local E2 = E
  if E2.kind == "nothing" then E2 = assert(E2.peer) end
  assert(E2.kind == "fence")

  local fence_mat = assert(E2.fence_mat)
  local fence_z   = assert(E2.fence_top_z)

  if E.dir == 2 or E.dir == 6 or E.dir == 1 or E.dir == 3 then cx = cx + 1 end
  if E.dir == 8 or E.dir == 6 or E.dir == 9 or E.dir == 3 then cy = cy + 1 end

  -- compute delta and # of corners to visit
  local along_dir = geom.RIGHT[E.dir]
  local dx, dy = geom.delta(along_dir)

  -- iterate over both corners of edge (left side then right side)
  for pass = 1, 2 do
    local corner = Corner_lookup(cx, cy)

--  stderrf("Corner_mark_fences @ (%d %d)  E=%s dir:%d\n", cx, cy, E.kind, E.dir)

    local dir = sel(pass == 1, along_dir, 10 - along_dir)

    if not corner.fences[dir] then
      corner.fences[dir] = {}
    end

    if pass == 1 then
      corner.fences[dir].R   = fence_mat
      corner.fences[dir].R_z = fence_z
    else
      corner.fences[dir].L   = fence_mat
      corner.fences[dir].L_z = fence_z
    end

    cx = cx + dx * E.long
    cy = cy + dy * E.long
  end
end



function Corner_touches_wall(corner)
  each E in corner.edges do
    if Edge_is_wallish(E) then return true end
  end

  each junc in corner.junctions do
    if junc.E1 and Edge_is_wallish(junc.E1) then return true end
    if junc.E2 and Edge_is_wallish(junc.E2) then return true end
  end

  return false
end


------------------------------------------------------------------------


function Area_calc_volumes()
  -- Note: computes room volumes too!

  each R in LEVEL.rooms do
    R.svolume = 0
  end

  each A in LEVEL.areas do
    A:calc_volume()

    if A.room then
      A.room.svolume = A.room.svolume + A.svolume
    end
  end
end



function Area_find_neighbors()

  local function try_pair_up(A1, A2, nb_map)
    if A1.id > A2.id then
      A1, A2 = A2, A1
    end

    local str = string.format("%d_%d", A1.id, A2.id)

    -- already seen this pair?
    if nb_map[str] then return end

--    assert(not table.has_elem(A1.neighbors, A2))
--    assert(not table.has_elem(A2.neighbors, A1))

    table.insert(A1.neighbors, A2)
    table.insert(A2.neighbors, A1)

    nb_map[str] = 1
  end


  ---| Area_find_neighbors |---

  local nb_map = {}

  -- clear previous stuff
  each A in LEVEL.areas do
    if not table.empty(A.neighbors) then
      A.neighbors = {}
    end
  end

  each A in LEVEL.areas do
  each S in A.seeds do
  each dir in geom.ALL_DIRS do
    local N = S:neighbor(dir)

    if N and N.area and N.area != A then
      try_pair_up(A, N.area, nb_map)
    end
  end -- A, S, dir
  end
  end
end



function Area_locate_chunks()
  --
  -- Locate seed rectangles in areas of rooms, these will be used
  -- for placing importants (goals, teleporters, etc) and also
  -- decorative prefabs.
  --

  local sym_pass
  local max_vol


  local PASSES = { 44, 33, 42,24,32,23, 22, 21,12,  11 }

  -- the large sizes often hog too much space in a room, so we
  -- don't always keep them
  local USE_PROBS =
  {
    [44] = 60
    [33] = 90

    [42] = 15
    [24] = 15

    [32] = 15
    [23] = 15
  }


  local function check_touches_wall(sx1,sy1, sx2,sy2)
    -- this is mainly for caves

    each dir in geom.SIDES do
      local tx1, ty1 = sx1, sy1
      local tx2, ty2 = sx2, sy2

      if dir == 2 then ty2 = ty1 end
      if dir == 8 then ty1 = ty2 end
      if dir == 4 then tx2 = tx1 end
      if dir == 6 then tx1 = tx2 end

      for x = tx1,tx2 do
      for y = ty1,ty2 do
        local S = SEEDS[x][y]

        -- NOTE: we assume S is never a diagonal

        local N = S:neighbor(dir)

        if not N then return true end
        if N.room != S.room then return true end

        if N.chunk and not (N.chunk == "floor" or N.chunk == "liquid") then
          return true
        end
      end  -- x, y
      end
    end  -- dir

    return false
  end


  local function make_chunk(kind, A, sx1,sy1, sx2,sy2)
    local CK = CHUNK_CLASS.new(kind, sx1,sy1, sx2,sy2)

    CK.area = A

    if CK.sw < 2 or CK.sh < 2 then
      CK.is_small = true
    elseif CK.sw > 2 and CK.sh > 2 then
      CK.is_large = true
    end

    CK.touches_wall = check_touches_wall(sx1,sy1, sx2,sy2)

    return CK
  end


  local function create_chunk(A, sx1,sy1, sx2,sy2)
    local R = assert(A.room)

    local kind = "floor"
    if A.mode == "liquid" then kind = "liquid" end

    local CK = make_chunk(kind, A, sx1,sy1, sx2,sy2)

    -- TODO : improve this [ take nearby walls, conns, closets into account ]
    CK.space = 24
    if math.min(CK.sw, CK.sh) >= 2 then CK.space = 104 end
    if math.min(CK.sw, CK.sh) >= 3 then CK.space = 224 end
    if math.min(CK.sw, CK.sh) >= 4 then CK.space = 344 end

    if kind == "liquid" then
      table.insert(R.liquid_chunks, CK)

    else
-- stderrf("adding CHUNK %dx%d in %s of %s\n", CK.sw, CK.sh, A.name, R.name)
      table.insert(R.floor_chunks, CK)
    end

    -- TODO : review the liquid check here
    if not A.is_outdoor and A.mode != "liquid" then
      local CEIL = make_chunk("ceil", A, sx1,sy1, sx2,sy2)
      table.insert(R.ceil_chunks, CEIL)

      -- link the floor and ceiling chunks
       CEIL.floor_below = CK
         CK. ceil_above = CEIL
    end

    return CK
  end


  local function raw_test_chunk(A, sx1,sy1, sx2,sy2)
    -- size check, disallow occupying the whole room
    local sw = (sx2 - sx1 + 1)
    local sh = (sy2 - sy1 + 1)

    if sw * sh > max_vol then return false end

    for x = sx1, sx2 do
    for y = sy1, sy2 do
      if not Seed_valid(x, y) then return false end

      local N = SEEDS[x][y]

      if not N then return false end
      if N.area != A then return false end
      if N.diagonal or N.chunk then return false end
    end -- x, y
    end

    return true
  end


  local function install_chunk_at_seed(A, sx1,sy1, sx2,sy2)
    local CK = create_chunk(A, sx1,sy1, sx2,sy2)

    for x = sx1, sx2 do
    for y = sy1, sy2 do
      SEEDS[x][y].chunk = CK
    end
    end

    -- this marks the exit room boss area
    if A.is_bossy and sx2 > sx1 and sy2 > sy1 then
      CK.is_bossy = A.is_bossy
       A.is_bossy = nil
    end

    return CK
  end


  local function try_chunk_at_seed(A, sx1,sy1, sx2,sy2)
    if not raw_test_chunk(A, sx1,sy1, sx2,sy2) then
      return false
    end

    if not (A.room and A.room.symmetry) then
      install_chunk_at_seed(A, sx1,sy1, sx2,sy2)
      return true
    end

    -- handle symmetrical rooms --

    local N1 = A.room.symmetry:transform(SEEDS[sx1][sy1])
    local N2 = A.room.symmetry:transform(SEEDS[sx2][sy2])

    if not (N1 and N2) then
      return false
    end

    -- it *should* be the same area, but sanity check
    if N1.area != A then return false end
    if N2.area != A then return false end

    local nx1 = math.min(N1.sx, N2.sx)
    local ny1 = math.min(N1.sy, N2.sy)
    local nx2 = math.max(N1.sx, N2.sx)
    local ny2 = math.max(N1.sy, N2.sy)

    -- check for chunks straddling the axis of symmetry
    local is_straddler = (nx1 == sx1 and ny1 == sy1 and nx2 == sx2 and ny2 == sy2)

    if sym_pass == 1 and not is_straddler then return false end
    if sym_pass != 1 and     is_straddler then return false end

    if is_straddler then
      local CHUNK = install_chunk_at_seed(A, sx1,sy1, sx2,sy2)
      CHUNK.is_straddler = true
      return true
    end

    -- check for overlap
    if not (nx2 < sx1 or ny2 < sy1 or
            nx1 > sx2 or ny1 > sy2)
    then
      return false
    end

    if not raw_test_chunk(A, nx1,ny1, nx2,ny2) then
      return false
    end

    local CHUNK1 = install_chunk_at_seed(A, sx1,sy1, sx2,sy2)
    local CHUNK2 = install_chunk_at_seed(A, nx1,ny1, nx2,ny2)

    CHUNK1.peer = CHUNK2
    CHUNK2.peer = CHUNK1

    if CHUNK1.is_bossy then
      CHUNK2.is_bossy = true
    end

    -- peer up ceiling chunks too
    local CEIL1 = CHUNK1.ceil_above
    local CEIL2 = CHUNK2.ceil_above

    if CEIL1 and CEIL2 then
      CEIL1.peer = CEIL2
      CEIL2.peer = CEIL1
    end

    return true
  end


  local function can_skip_for_symmetry(R, S)
    if not R then return false end
    if not R.symmetry then return false end

    if R.symmetry.kind != "mirror" then return false end

    if geom.is_vert (R.symmetry.dir) then return S.sx > R.symmetry.x end
    if geom.is_horiz(R.symmetry.dir) then return S.sy > R.symmetry.y end

    -- it is not critical that we don't check diagonal symmetry cases

    return false
  end


  local function find_sized_chunks(A, seed_list, pass)
    local dx = int(pass / 10) - 1
    local dy = (pass % 10) - 1

    local use_prob = USE_PROBS[pass] or 99

    each S in seed_list do
      local sx1 = S.sx
      local sy1 = S.sy
      local sx2 = sx1 + dx
      local sy2 = sy1 + dy

      -- we can do less checks in symmetrical rooms
      if can_skip_for_symmetry(A.room, S) then continue end

      -- save time by checking the usage prob *first*
      if pass != 11 and not rand.odds(use_prob) then continue end

      try_chunk_at_seed(A, sx1,sy1, sx2,sy2)
    end
  end


  local function find_chunks_in_area(A)
    local seed_list = table.copy(A.seeds)

    each pass in PASSES do
      rand.shuffle(seed_list)

      find_sized_chunks(A, seed_list, pass)
    end
  end


  local function visit_room(R)
    each A in R.areas do
      if A.mode == "floor" or A.mode == "nature" or A.mode == "liquid" then
        find_chunks_in_area(A)
      end
    end
  end


  ---| Area_locate_chunks |---

  -- in symmetrical rooms, perform two passes, where the first
  -- pass ONLY checks for straddling chunks

  each R in LEVEL.rooms do
    max_vol = R:calc_walk_vol()

    -- smaller max_vol for caves
    -- [ to get more chunks which do not touch the room edge ]
    if R.is_cave then
      max_vol = 4
    else
      max_vol = max_vol * 0.35
    end

    for pass = sel(R.symmetry, 1, 2), 2 do
      sym_pass = pass
      visit_room(R)
    end
  end
end



function Area_analyse_areas()

  ---| Area_analyse_areas |---

  Area_calc_volumes()

  each R in LEVEL.rooms do
    R:collect_seeds()
  end

  Area_find_neighbors()

--[[
  local total_seeds = 0

  each R in LEVEL.rooms do
    total_seeds = total_seeds + R.svolume
  end

  stderrf("TOTAL ROOMS: %d  [ average %1.1f seeds ]\n", #LEVEL.rooms, total_seeds / #LEVEL.rooms)
  stderrf("TOTAL SEEDS: %d  [ target %d ]\n", total_seeds, LEVEL.map_W * LEVEL.map_H)
--]]
end



function Area_find_inner_points()

  local function collect_inner_points(A)
    -- check bottom-left corner of each seed

    each S in A.seeds do
      -- point is outside of area
      if S.diagonal == 9 then continue end

      -- point is part of boundary, skip it
      if S.diagonal == 3 or S.diagonal == 7 then continue end

      local NA = S:neighbor(4)
      local NB = S:neighbor(2)

      if not (NA and NA.area == A) then continue end
      if not (NB and NB.area == A) then continue end

      local NC = NA:neighbor(2)
      local ND = NB:neighbor(4)

      if not (NC and NC.area == A) then continue end

      -- we should reach the same seed going both ways
      if ND != NC then continue end

      -- OK --

      local corner = Corner_lookup(S.sx, S.sy)
      assert(corner)

      corner.inner_point = A

      table.insert(A.inner_points, corner)
    end
  end


  ---| Area_find_inner_points |---

  each A in LEVEL.areas do
    collect_inner_points(A)

    A.openness = #A.inner_points / A.svolume
  end
end



function Area_inner_points_for_group(R, group, where)
  --
  -- this uses same logic as Area_find_inner_points()
  -- [ probably not worth trying to merge the code though ]
  --
  -- the 'where' parameter is either "floor" or "ceil".
  --

  local   area_field = where .. "_group"
  local corner_field = where .. "_inner"

  local seeds = {}

  local num_inner = 0


  local function same_group(S)
    if not S      then return false end
    if not S.area then return false end

    return S.area[area_field] == group
  end


  -- collect seeds

  each A in R.areas do
    if A[area_field] == group then
      table.append(seeds, A.seeds)
    end
  end


  -- check bottom-left corner of each seed

  each S in seeds do
    -- point is outside of area
    if S.diagonal == 9 then continue end

    -- point is part of boundary, skip it
    if S.diagonal == 3 or S.diagonal == 7 then continue end

    local NA = S:neighbor(4)
    local NB = S:neighbor(2)

    if not same_group(NA) then continue end
    if not same_group(NB) then continue end

    local NC = NA:neighbor(2)
    local ND = NB:neighbor(4)

    if not same_group(NC) then continue end

    -- we should reach the same seed going both ways
    if ND != NC then continue end

    -- OK --

    local corner = Corner_lookup(S.sx, S.sy)
    assert(corner)

    corner[corner_field] = group

    num_inner = num_inner + 1
  end

  -- compute openness

  group.openness = num_inner / #seeds
end



function Area_closet_edges()

  local function visit_closet(chunk, R)
    -- TODO : different shapes (L/T/P) need more edges

    local E = chunk:create_edge("nothing", chunk.from_dir)

    E.is_wallish = true

    chunk.edges = { E }

    -- killed joiners need the edge to be ignored
    if chunk.content == "void" then
      E.kind = "ignore"
    end
  end

  ---| Area_closet_edges |---

  each R in LEVEL.rooms do
    each CL in R.closets do
      visit_closet(CL, R)
    end
  end
end



function Area_spread_zones()
  --
  -- Associates every area with a zone, including VOID areas
  -- but not SCENIC areas (which are done later).
  --

  local function setup_room_areas()
    each A in LEVEL.areas do
      if A.room then
        A.zone = assert(A.room.zone)
      end
    end
  end


  local function try_set_area(A)
    rand.shuffle(A.neighbors)

    for pass = 1, 2 do
      each N in A.neighbors do
        if not N.zone then continue end

        -- on first pass, require neighbor to be a real room
        -- [ to prevent run-ons ]
        if pass == 1 and not N.room then continue end

        -- OK --
        A.zone = N.zone
        return
      end
    end
  end


  local function grow_pass()
    -- returns true when all areas are done
    local all_done = true

    local list = table.copy(LEVEL.areas)

    rand.shuffle(list)

    each A in list do
      if A.zone then continue end
      if A.mode == "scenic" then continue end

      all_done = false

      try_set_area(A)

    end -- A

    return all_done
  end


  ---| Area_spread_zones |---

  setup_room_areas()

  for loop = 1, 99 do
    if grow_pass() then
      return
    end
  end

  error("Area_spread_zones failed.")
end



function Area_pick_facing_rooms()
  -- also assigns a zone to scenic areas, plus ceil_h

  local scenics = {}

  local facings  --  [ROOM + SCENIC] --> count


  local function face_id(R, T)
    return R.name .. "/" .. T.name
  end


  local function build_facing_database(want_outdoor)
    facings = {}

    each A in LEVEL.areas do
      if not A.room then continue end

      if not (A.mode == "floor" or A.mode == "nature") then continue end

      if sel(A.is_outdoor, 1, 0) != sel(want_outdoor, 1, 0) then continue end

      each S in A.seeds do
      each dir in geom.ALL_DIRS do
        local N = S:neighbor(dir)
        local T = N and N.area

        if T and T.mode == "scenic" then
          local id = face_id(A.room, T)

          facings[id] = (facings[id] or gui.random() / 10) + 1
        end
      end -- S, dir
      end
    end -- A

--  stderrf("facing DB:\n%s\n", table.tostr(facings))
  end


  local function best_facing_pair(want_outdoor)
    local best_R
    local best_T
    local best_score = -1

    each R in LEVEL.rooms do
      if R.border then continue end

      if sel(R.is_outdoor, 1, 0) != sel(want_outdoor, 1, 0) then continue end

      each T in scenics do
        if T.zone then continue end

        local score = facings[face_id(R, T)]

        if score != nil and score > best_score then
          best_R = R
          best_T = T
          best_score = score
        end
      end -- T
    end -- R

    return best_R, best_T
  end


  local function assign_borders(mode)
    -- mode can be "outdoor", "cave" or "building"
    local want_outdoor = (mode == "outdoor")

    build_facing_database(want_outdoor)

    while true do
      local R, T = best_facing_pair(want_outdoor)

      -- nothing else is possible?
      if R == nil then break; end

--  stderrf("flobbing %s with %s\n", R.name, T.name)

      R.border = T

      T.face_room = R
      T.zone = R.zone
    end
  end


  local function emergency_zone(A)
    rand.shuffle(A.neighbors)

    each N in A.neighbors do
      if N.room then
        return N.room.zone
      end
    end

    each N in A.neighbors do
      if N.zone then
        return N.zone
      end
    end

    -- the ultimate fallback
    return LEVEL.zones[1]
  end


  ---| Area_pick_facing_rooms |---

  each A in LEVEL.areas do
    if A.mode == "scenic" then
      table.insert(scenics, A)
    end
  end

  assign_borders("outdoor")

--TODO : support making windows from building --> scenic
--  assign_borders("building")

  each A in scenics do
    if A.zone then
      A.ceil_h = A.zone.sky_h
      A.ceil_mat = "_SKY"
    end

    -- void up unset areas
    if not A.zone then
      A.mode = "void"
      A.zone = emergency_zone(A)
    end
  end

  -- sanity check
  each A in LEVEL.areas do
    assert(A.zone)
  end
end



function Area_divvy_up_borders()
  --
  -- Subdivides the boundary area(s) of the map into pieces
  -- belonging to each room, so that zone walls can be placed
  -- and to allow each zone to do different bordery stuff.
  --
  -- As a by-product, this also ensures every seed inside the
  -- absolute boundary rectangle of the map gets an "area" value.
  -- Such areas which lie inside the map become the VOID type.
  --
  -- NOTE: in here, quests and zones do not exist yet.
  --

  --
  -- ALGORITHM:
  --   (a) mark boundary seeds which only touch a single room.
  --
  --   (b) spread these continuously, filling most of the map.
  --
  --   (c) there will be gaps now, choose how to fill each seed:
  --       (1) empty on sides 4/6, filled on sides 2/8 -> pick side 2
  --       (2) empty on sides 2/8, filled on sides 4/6 -> pick side 4
  --       (3) if filled on all sides, with only two choices and
  --           forming a diagonal -> make a diagonal seed
  --       (4) if have a majority in the neighbors -> pick that one
  --       (5) lastly, pick any neighbor (preference for side 2, then 4)
  --
  --   (d) create temp areas by flood-filling contiguous groups
  --       of these marked seeds.
  --
  --   (e) process the temp areas, such as merging small ones
  --       and making "inner" ones be VOID.  Then convert the
  --       remaining ones to *real* areas.
  --

  local seed_list

  local temp_areas

  local VOID = { name="<VOID>", id=9999 }

  local MIN_SIZE = 60


  local function get_zborder(S)
    if S.zborder then return S.zborder end
    return S.area and S.area.room
  end


  local function set_zborder(S, zborder)
    S.zborder = zborder
  end


  local function collect_seeds()
    local list = {}

    for sy = LEVEL.absolute_y1, LEVEL.absolute_y2 do
    for sx = LEVEL.absolute_x1, LEVEL.absolute_x2 do
      local S = SEEDS[sx][sy]

      if not S.area then
        table.insert(list, S)
      end

      if S.top and not S.top.area then
        table.insert(list, S.top)
      end
    end  -- sx, sy
    end

    return list
  end


  local function process(func, no_diags)
    repeat
      local changes = {}

      each S in seed_list do
        assert(S.zborder == nil)

        if no_diags and S.diagonal then continue end

        local zborder = func(S)

        if zborder then
          table.insert(changes, { S=S, zborder=zborder })
        end
      end

      -- apply the changes
      each tab in changes do
        set_zborder(tab.S, tab.zborder)
        table.kill_elem(seed_list, tab.S)
      end

    until table.empty(changes)
  end


  local function marking_func(S)
    local zb

    each dir in geom.ALL_DIRS do
      local N = S:neighbor(dir)
      if not N then continue end

      local nz = get_zborder(N)
      if not nz then continue end

      -- fail if we have two neighbors with differing rooms
      if zb and zb != nz then return nil end

      zb = nz
    end

    return zb
  end


  local function horizontal_func(S)
    local T = S:neighbor(8)
    local B = S:neighbor(2)
    local L = S:neighbor(4)
    local R = S:neighbor(6)

    if not (T and B and L and R) then return nil end

    T = get_zborder(T)
    B = get_zborder(B)
    L = get_zborder(L)
    R = get_zborder(R)

    if T == nil and B == nil and L and R then return L end

    return nil
  end


  local function vertical_func(S)
    local T = S:neighbor(8)
    local B = S:neighbor(2)
    local L = S:neighbor(4)
    local R = S:neighbor(6)

    if not (T and B and L and R) then return nil end

    T = get_zborder(T)
    B = get_zborder(B)
    L = get_zborder(L)
    R = get_zborder(R)

    if L == nil and R == nil and B and T then return B end

    return nil
  end


  local function diagonal_func(S)
    local T = S:neighbor(8)
    local B = S:neighbor(2)
    local L = S:neighbor(4)
    local R = S:neighbor(6)

    if not (T and B and L and R) then return nil end

    T = get_zborder(T)
    B = get_zborder(B)
    L = get_zborder(L)
    R = get_zborder(R)

    if not (T and B and L and R) then return nil end

    if (T == L) and (B == R) then
      S:split(3)
    elseif (T == R) and (B == L) then
      S:split(1)
    else
      return nil
    end

    -- common stuff for splitting the seed

    set_zborder(S.top, T)

    return B
  end


  local function majority_func(S)
    local counts = {}

    each dir in geom.ALL_DIRS do
      local N = S:neighbor(dir)
      if not N then continue end

      local z = get_zborder(N)
      if not z then continue end

      counts[z] = (counts[z] or 0) + 1
    end

    each z, num in counts do
      if num >= 3 then return z end
    end

    local double_z

    each z, num in counts do
      if num == 2 then
        if double_z then return nil end
        double_z = z
      end
    end

    return double_z
  end


  local function emergency_func(S)
    local counts = {}

    each dir in geom.ALL_DIRS do
      local N = S:neighbor(dir)
      if not N then continue end

      local z = get_zborder(N)

      if z and z != VOID then return z end
    end

    return VOID
  end


  local function mark_all_seeds()
    process(marking_func)

    process(horizontal_func, "no_diags")
    process(vertical_func,   "no_diags")
    process(diagonal_func,   "no_diags")

    process(majority_func)

    -- this handles all remaining unmarked seeds
    process(emergency_func)
  end


  ------------------------------------------------


  local function add_seed(temp, S)
    S.temp_area = temp

    table.insert(temp.seeds, S)

    -- check if sits along edge of map
    -- [ does not matter if only a corner touches edge of map ]
    if S.sx <= LEVEL.absolute_x1 or
       S.sy <= LEVEL.absolute_y1 or
       S.sx >= LEVEL.absolute_x2 or
       S.sy >= LEVEL.absolute_y2
    then
      temp.touches_edge = true
    end
  end


  local function new_temp_area(S)
    local TEMP =
    {
      name = "TEMP_" .. alloc_id("temp_area")
      seeds = {}
    }

    if S.zborder == VOID then
      TEMP.is_void = true
    else
      TEMP.zroom = S.zborder
    end

    table.insert(temp_areas, TEMP)

    add_seed(TEMP, S)
  end


  local function void_up_temp(T)
    T.is_void  = true
    T.is_inner = nil
    T.zroom    = nil
  end


  local function fill_at_seed(S)
    assert(S.zborder)

    -- optimise by checking earlier neighbors
    -- [ this optimisation assumes a certain ordering of the seed list ]
    for dir = 1,4 do
      local N = S:neighbor(dir)

      if N and N.temp_area and N.zborder == S.zborder then
        add_seed(N.temp_area, S)
        return
      end
    end

    new_temp_area(S)
  end


  local function create_temp_areas()
    temp_areas = {}

    each S in collect_seeds() do
      fill_at_seed(S)
    end
  end


  local function perform_merge(T1, T2, no_swap)
    -- merges T2 into T1 (killing T2)

    if not no_swap and #T2.seeds > #T1.seeds then
      T1, T2 = T2, T1
    end

    if T2.touches_edge then
       T1.touches_edge = true
    end

    -- update seed references (replace T2 with T1)
    each S in T2.seeds do
      S.temp_area = T1
    end

    table.append(T1.seeds, T2.seeds)

    if T1.viewables and T2.viewables then
      T1.viewables = T1.viewables + T2.viewables
    end

    -- mark T2 as dead
    T2.name = "DEAD_TEMP_AREA"
    T2.is_dead = true
    T2.seeds = nil
  end


  local function try_merge_an_area(T1)
    each S in T1.seeds do
    each dir in geom.ALL_DIRS do
      local N = S:neighbor(dir)

      local T2 = (N and N.temp_area)

      if not T2 then continue end
      if T2 == T1 then continue end

      assert(not T2.is_dead)

      if S.zborder != N.zborder then continue end

      perform_merge(T1, T2)
      return true

    end  -- S, dir
    end

    return false
  end


  local function prune_dead_areas()
    for i = #temp_areas, 1, -1 do
      if temp_areas[i].is_dead then
        table.remove(temp_areas, i)
      end
    end
  end


  local function merge_temp_areas()
    -- find temp_areas with same zroom and merge them

    repeat
      local changed = false

      each T1 in temp_areas do
        if T1.is_dead then continue end

        if try_merge_an_area(T1) then
          changed = true
        end
      end

      prune_dead_areas()

    until not changed
  end


  local function test_neighbor_at_seed(T1, S, dir)
    local N = S:neighbor(dir)
    if not N then return end

    local T2 = N.temp_area
    if not T2 then return end

    if T2 == T1 then return end

    table.add_unique(T1.neighbors, T2)
    table.add_unique(T2.neighbors, T1)
  end


  local function determine_neighbors()
    each T in temp_areas do
      T.neighbors = {}
    end

    each T in temp_areas do
      each S in T.seeds do
        each dir in geom.ALL_DIRS do
          test_neighbor_at_seed(T, S, dir)
        end
      end
    end
  end


  local function assign_inners()
    -- mark all temp areas which can trace a path to the edge
    -- of the map.

    determine_neighbors()

    each T in temp_areas do
      if not T.touches_edge then
        T.is_inner = true
      end
    end

    for loop = 1,9 do
      each T in temp_areas do
        each N in T.neighbors do
          if T.is_inner and not N.is_inner then
            T.is_inner = nil
            break;
          end
        end -- N
      end -- T
    end -- loop
  end


  local function handle_inners()
    -- merge contiguous inner areas

    each T in temp_areas do
    each N in T.neighbors do
      if T.is_inner and not T.is_dead and
         N.is_inner and not N.is_dead
      then
        perform_merge(T, N)
      end
    end
    end

    prune_dead_areas()
    determine_neighbors()

    -- decide whether to void them up
    -- TODO: keep an inner area when its size and views are large enough
    each T in temp_areas do
      if T.is_void then continue end

      if T.is_inner then
        void_up_temp(T)
      end
    end
  end


  local function handle_voids()
    each T in temp_areas do
    each N in T.neighbors do
      if T.is_void and not T.is_dead and
         N.is_void and not N.is_dead
      then
        perform_merge(T, N)
      end
    end
    end

    prune_dead_areas()
    determine_neighbors()
  end


  local function area_too_small(T)
    return #T.seeds < MIN_SIZE
  end


  local function handle_runts()
    rand.shuffle(temp_areas)

    for pass = 1, 6 do
    each T in temp_areas do
      if T.is_dead or T.is_inner or T.is_void then continue end

      if not area_too_small(T) then continue end

      rand.shuffle(T.neighbors)

      each N in T.neighbors do
        if N.is_dead or N.is_inner or N.is_void then continue end

        -- only merge small areas with other small areas in the
        -- in first few passes (hoping they become large enough)
        if area_too_small(N) or pass >= 5 then
          perform_merge(T, N)

          if T.is_dead then break; end
        end
      end
    end  -- pass, T
    end

    each T in temp_areas do
      if T.is_dead or T.is_inner or T.is_void then continue end

      if area_too_small(T) then
        void_up_temp(T)
      end
    end

    prune_dead_areas()
    determine_neighbors()
  end


  local function make_real_areas()
    each T in temp_areas do
      local A = AREA_CLASS.new("scenic")

      A.is_boundary  = true

      A.seeds        = T.seeds
      A.touches_edge = T.touches_edge

      if T.is_void then
        A.mode = "void"
      else
        A.is_outdoor = true
      end

      -- install into seeds
      each S in A.seeds do
        S.area = A
        S.temp_area = nil
      end
    end
  end


  local function flood_fill_temp_areas()
    create_temp_areas()
    merge_temp_areas()

    assign_inners()
    handle_inners()

    handle_runts()
    handle_voids()

    -- we don't need "zroom" after here....
    each T in temp_areas do
      T.zroom = nil
    end
  end


  ---| Area_divvy_up_borders |---

  seed_list = collect_seeds()

  mark_all_seeds()

  flood_fill_temp_areas()

  make_real_areas()

  Seed_squarify()
end



function Area_building_facades()

  local all_groups = {}


--[[
local test_textures =
{
  "FWATER1",  "NUKAGE1", "LAVA1",
  "BLOOD1",   "ASHWALL2", "SHAWN2",
  "TEKWALL4", "ASHWALL4", "ASHWALL7",
  "BRICK10",  "CEMENT9",
  "DOORBLU2", "DOORRED2", "DOORYEL2"
}
--]]


  local function new_group()
    local GROUP = {}

    GROUP.name = "FCGROUP_" .. alloc_id("facade_group")

--[[ DEBUG STUFF
    GROUP.mat = table.remove(test_textures, 1)
    table.insert(test_textures, GROUP.mat)
--]]
    return GROUP
  end


  local function is_straddling_joiner(A)
    if A.chunk and A.chunk.kind == "joiner" then
      return (A.chunk.from_area.zone == Z) or
             (A.chunk.dest_area.zone == Z)
    end

    return false
  end


  local function kinda_in_zone(A, Z)
    if A.zone == Z then return true end

    -- allow joiners which straddle two zones
    if is_straddling_joiner(A) then return true end

    return false
  end


  local function spread_facade(Z, A)
    if is_straddling_joiner(A) then
      A.facade_group.zone_diff = true
    end

    each N in A.corner_neighbors do
      if not N.facade_group and kinda_in_zone(N, Z) and N:is_indoor() then
        N.facade_group = A.facade_group

        spread_facade(Z, N)
      end
    end
  end


  local function visit_zone(Z)
    each A in LEVEL.areas do
      if not A.facade_group and kinda_in_zone(A, Z) and A:is_indoor() then
        A.facade_group = new_group(A)

        spread_facade(Z, A)
      end
    end

    Corner_detect_zone_diffs()

    -- assign a facade to groups which don't touch a zone difference
    each A in LEVEL.areas do
      if A.facade_group and not A.facade_group.zone_diff then
        A.facade_crap = A.zone.other_facade
      end
    end

    -- clear the groups (for the sake of straddling joiners)
    each A in LEVEL.areas do
      A.facade_group = nil
    end
  end


  local function dump_facades()
    gui.debugf("Building Facades:\n")

    each Z in LEVEL.zones do
      gui.debugf("%s:\n", Z.name)

      each A in Z.areas do
        gui.debugf("  %s (%s / %s) ---> '%s'\n", A.name,
          A.mode, sel(A.is_outdoor, "outdoor", " indoor"),
          A.facade_crap or "(nil)")
      end
    end

    gui.debugf("\n")
  end


  ---| Area_building_facades |---

  each Z in LEVEL.zones do
    visit_zone(Z)
  end

--  dump_facades()
end



function Area_create_rooms()

  gui.printf("\n--==| Creating Rooms |==--\n\n")

  gui.printf("Map size target: %dx%d seeds\n", LEVEL.map_W, LEVEL.map_H)

  Grower_create_rooms()

  Area_divvy_up_borders()

  Area_analyse_areas()

  Junction_init()
    Corner_init()

  Area_find_inner_points()
  Area_closet_edges()


  gui.printf("Seed Map:\n")
  Seed_dump_rooms()

  each R in LEVEL.rooms do
    gui.debugf("Final %s   size: %dx%d\n", R.name, R.sw, R.sh)
  end


  Connect_finalize()

  Area_locate_chunks()
end

