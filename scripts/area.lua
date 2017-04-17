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

    mode : keyword  -- "floor"  (traversible part of a normal room)
                    -- "liquid"
                    -- "cage"
                    -- "hallway"
                    -- "scenic"
                    -- "void"
                    -- "chunk" (whole area is a single chunk)

    scenic_kind : keyword  -- "water", "mountain"

    is_outdoor    -- true if outdoors (sky ceiling)
    is_boundary   -- true for areas outside the boundary line

    lighting      -- ambient lighting for the area


    room : ROOM

    zone : ZONE

    chunk : CHUNK   -- only set when mode == "chunk"


    --- geometry of area ---

    seeds : list(SEED)

    svolume : number   -- number of seeds (0.5 for diagonals)

    neighbors : list(AREA)
    corner_neighbors : list(AREA)

    edges : list(EDGE)

    floor_h     -- floor height
    ceil_h      -- ceiling height

    floor_mat   -- floor material
    ceil_mat    -- ceiling material  [ "_SKY" for outdoor areas ]

    floor_side  -- floor side material (optional)
    ceil_side   -- ceiling side material (optional)


    --- other stuff ---

    inner_points : list(CORNER)

    facade_group : FACADE_GROUP   -- used by facade logic (temporarily)

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
    -- For example: could be solid wall, fence, or even nothing at all.
    --
    -- The junction kind can be overridden by a specific EDGE object.
    --

    A1 : AREA
    A2 : AREA   -- can be special value "map_edge"

    --
    -- These are "pseudo edges" which will be used to render the
    -- junction.  They do not contain position info (S and dir).
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

    inner_point : AREA  -- usually NIL

    delta_x, delta_y    -- usually NIL, used for mountains
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


function AREA_CLASS.kill_it(A)
  --
  -- NOTE : this can only be called fairly early, e.g. before all the
  --        neighbor lists and junctions are created.
  --

  table.kill_elem(LEVEL.areas, A)

  A.id   = -1
  A.name = "DEAD_" .. A.name

  A.mode = "DEAD"
  A.kind = "DEAD"
  A.room = nil

  each S in A.seeds do
    S.room = nil
    S.area = nil
  end

  A.conns = nil
end


function AREA_CLASS.tostr(A)
  return assert(A.name)
end


function area_get_seed_bbox(A)
  local first_S = A.seeds[1]

  local BB_X1, BB_Y1 = first_S, first_S
  local BB_X2, BB_Y2 = first_S, first_S

  each S in A.seeds do
    if S.sx < BB_X1.sx then BB_X1 = S end
    if S.sy < BB_Y1.sy then BB_Y1 = S end

    if S.sx > BB_X2.sx then BB_X2 = S end
    if S.sy > BB_Y2.sy then BB_Y2 = S end
  end

  return BB_X1, BB_Y1, BB_X2, BB_Y2
end


function AREA_CLASS.get_ctf_peer(A)
  local S = A.seeds[1]
  local N = S.ctf_peer

  if not N then return nil end
  assert(N.area)

  if N.area == A then return nil end

  return N.area
end


function area_get_bbox(A)
  local BB_X1, BB_Y1, BB_X2, BB_Y2 = area_get_seed_bbox(A)

  return BB_X1.x1, BB_Y1.y1, BB_X2.x2, BB_Y2.y2
end


function AREA_CLASS.remove_dead_seeds(A)
  for i = #A.seeds, 1, -1 do
    if A.seeds[i].kind == "dead" then
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

  each N in A.neighbors do
    if N.room == A.room and N.mode == "floor" and N.floor_h then
      if not best or N.floor_h > best.floor_h or
         -- use ceiling heights to break ties
         (N.floor_h == best.floor_h and (N.ceil_h or 9999) < (best.ceil_h or 9999))
      then
        best = N
      end
    end
  end

  return best
end


function AREA_CLASS.lowest_neighbor(A)
  local best

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
    if not LEVEL.area_junctions[index] then
      LEVEL.area_junctions[index] = { A1=A1, A2=A2, perimeter=0 }
    end
  end

  return LEVEL.area_junctions[index]
end



function Junction_init()
  -- this is a dictionary, looked up via a string formed from the IDs of
  -- the two areas.
  LEVEL.area_junctions = {}

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
  each name,J in LEVEL.area_junctions do
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

  if not A.room then
    Junction_make_empty(junc)
    return
  end

  if A.room and not A.is_outdoor then
    mat = A.room.main_tex
  else
    mat = A.zone.facade_mat
  end

  assert(mat)

  junc.E1 = { kind="wall", area=A, wall_mat=mat }
  junc.E2 = { kind="nothing" }
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


function Junction_make_fence(junc)
  local z1 = junc.A1.floor_h
  local z2 = junc.A2.floor_h

  if junc.A1.pool_id then z1 = junc.A1.face_room.max_floor_h end
  if junc.A2.pool_id then z2 = junc.A2.face_room.max_floor_h end

  if junc.A1.room then z1 = math.max(z1, junc.A1.room.max_floor_h) end
  if junc.A2.room then z2 = math.max(z2, junc.A2.room.max_floor_h) end

  local top_z = math.max(z1, z2)

  top_z = top_z + PARAM.jump_height + 8

  junc.E1 =
  {
    kind = "fence"
    fence_mat = assert(junc.A1.zone.fence_mat)
    fence_top_z = top_z
    area = junc.A1
  }

  junc.E2 = { kind="nothing" }

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
  assert(table.valid_pos(LEVEL.area_corners, cx, cy))

  local corner = LEVEL.area_corners[cx][cy]

  return assert(corner)
end



function Corner_init()
  LEVEL.area_corners = table.array_2D(SEED_W + 1, SEED_H + 1)

  for cx = 1, LEVEL.area_corners.w do
  for cy = 1, LEVEL.area_corners.h do
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
    }

    LEVEL.area_corners[cx][cy] = CORNER
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

  for cx = 1, LEVEL.area_corners.w do
  for cy = 1, LEVEL.area_corners.h do
    local corner = LEVEL.area_corners[cx][cy]

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

  for cx = 1, LEVEL.area_corners.w do
  for cy = 1, LEVEL.area_corners.h do
    local corner = LEVEL.area_corners[cx][cy]

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

    local wall_dir = sel(pass == 1, along_dir, 10 - along_dir)

    if not corner.walls[wall_dir] then
      corner.walls[wall_dir] = {}
    end

    if pass == 1 then
      corner.walls[wall_dir].R = wall_mat
    else
      corner.walls[wall_dir].L = wall_mat
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


  local function make_chunk(kind, place, A, sx1,sy1, sx2,sy2)
    local CHUNK = Chunk_new(kind, sx1,sy1, sx2,sy2)

    CHUNK.area  = A
    CHUNK.place = place

    if CHUNK.sw < 2 or CHUNK.sh < 2 then
      CHUNK.is_small = true
    elseif CHUNK.sw > 2 and CHUNK.sh > 2 then
      CHUNK.is_large = true
    end

    CHUNK.touches_wall = check_touches_wall(sx1,sy1, sx2,sy2)

    return CHUNK
  end


  local function create_chunk(A, sx1,sy1, sx2,sy2)
    local R = assert(A.room)

    local kind = "area"
    if A.mode == "liquid" then kind = "liquid" end

    local CHUNK = make_chunk(kind, "floor", A, sx1,sy1, sx2,sy2)

    -- TODO : improve this [ take nearby walls, conns, closets into account ]
    CHUNK.space = 24
    if math.min(CHUNK.sw, CHUNK.sh) >= 2 then CHUNK.space = 104 end
    if math.min(CHUNK.sw, CHUNK.sh) >= 3 then CHUNK.space = 224 end
    if math.min(CHUNK.sw, CHUNK.sh) >= 4 then CHUNK.space = 344 end

    if kind == "liquid" then
      table.insert(R.liquid_chunks, CHUNK)
    else
-- stderrf("adding CHUNK %dx%d in %s of %s\n", CHUNK.sw, CHUNK.sh, A.name, R.name)
      table.insert(R.floor_chunks, CHUNK)

      if not A.is_outdoor then
        local CEIL = make_chunk(kind, "ceil", A, sx1,sy1, sx2,sy2)
        table.insert(R.ceil_chunks, CEIL)

        -- link the floor and ceiling chunks
         CEIL.floor_below = CHUNK
        CHUNK. ceil_above = CEIL
      end
    end

    return CHUNK
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

      if N:has_connection() then return false end
    end -- x, y
    end

    return true
  end


  local function install_chunk_at_seed(A, sx1,sy1, sx2,sy2)
    local CHUNK = create_chunk(A, sx1,sy1, sx2,sy2)

    for x = sx1, sx2 do
    for y = sy1, sy2 do
      SEEDS[x][y].chunk = CHUNK
    end
    end

    return CHUNK
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
      if A.mode == "floor" or A.mode == "liquid" then
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
      -- TODO : REVIEW THIS
      max_vol = 4  -- math.min(9, max_vol * 0.1)
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

  local function find_CTF_peers()
    --
    -- FIXME : REWRITE to be SEED based !
    --         [ because areas are shared on each side of map ]
    --
    -- i.e. give each non-neutral seed a 'team' value
    --

    -- Do a flood fill through the level.
    -- This spreading logic tries to keep teamed areas contiguous
    -- (i.e. PREVENT pockets of one color surrounded by the other color).

    -- TODO : add/grow the central neutral area [ upto a quota ]
  end


  ---| Area_analyse_areas |---

  Area_calc_volumes()

  each R in LEVEL.rooms do
    R:collect_seeds()
  end

  Area_find_neighbors()

  if OB_CONFIG.playmode == "ctf" then
    error("CTF mode is broken!")

    find_CTF_peers()
  end

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

    local E = Seed_create_chunk_edge(chunk, chunk.from_dir, "nothing")

    E.is_wallish = true

    chunk.edges = { E }

    -- killed joiners need the edge to be ignored
    if chunk.content_kind == "void" then
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
  -- Associates every area with a zone (including scenic and VOID areas)
  --

  local function are_we_done()
    each A in LEVEL.areas do
      if not A.zone then return false end
    end

    return true
  end


  local function prepare_pass()
    each A in LEVEL.areas do
      if A.room then
        A.zone = assert(A.room.zone)
      end
    end
  end


  local function grow_pass(loop)
    local list = table.copy(LEVEL.areas)

    rand.shuffle(list)

    each A in list do
      if not A.zone then
        for loop = 1, 10 do
          local N = rand.pick(A.neighbors)
          assert(N)

          -- on first loop, require neighbor to be a real room
          -- [ to prevent run-ons ]
          if loop == 1 and not N.room then continue end

          if N.zone then A.zone = N.zone ; break; end
        end
      end
    end
  end


  ---| Area_spread_zones |---

  prepare_pass()

  for loop = 1, 99 do
    grow_pass()

    if are_we_done(loop) then
      return
    end
  end

  error("Area_spread_zones failed.")
end



function Area_divvy_up_borders()
  --
  -- Subdivides the boundary area(s) of the map into pieces
  -- belonging to each room, so that zone walls can be placed
  -- and to allow each zone to do different bordery stuff.
  --

  --
  -- ALGORITHM:
  --   (a) mark boundary seeds which touch a single room.
  --
  --   (b) repeat (a) continuously, filling most of the map.
  --
  --   (c) there will be gaps now, choose what to fill each seed:
  --       (1) empty on sides 4/6, filled on sides 2/8 -> pick side 2
  --       (2) empty on sides 2/8, filled on sides 4/6 -> pick side 4
  --       (3) if filled on all sides, with two different zones and
  --           forming a diagonal -> make a diagonal seed
  --       (4) if have a majority in the neighbors -> pick that one
  --       (5) lastly, pick any neighbor (preference for side 2, then 4)
  --
  --   (d) create areas by flood-filling contiguous border areas.
  --

  local seed_list

  local SX1 = math.max(LEVEL.boundary_x1 - 1, 1)
  local SY1 = math.max(LEVEL.boundary_y1 - 1, 1)
  local SX2 = math.min(LEVEL.boundary_x2 + 1, SEED_W)
  local SY2 = math.min(LEVEL.boundary_y2 + 1, SEED_H)

  local temp_areas


  local function get_zborder(S)
    if S.zborder then return S.zborder end
    return S.area and S.area.room
  end


  local function set_seed(S, zborder)
    S.zborder = zborder
  end


  local function collect_seeds()
    local list = {}

    for sy = SY1, SY2 do
    for sx = SX1, SX2 do
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
        set_seed(tab.S, tab.zborder)
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

---###  S.top.area  = S.area
---###  table.insert(S.area.seeds, S.top)

    set_seed(S.top, T)

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

      if z and z != "VOID" then return z end
    end

stderrf("BORDER ZONE FAILURE @ %s\n", S.name)

    return "VOID"
  end


  --------------------------------------------


  local function add_seed(temp, S)
    S.temp_area = temp

    table.insert(temp.seeds, S)

    -- check if sits along edge of map
    -- [ does not matter if only a corner touches edge of map ]
    if S.sx <= SX1 or S.sx >= SX2 or
       S.sy <= SY1 or S.sy >= SY2
    then
      temp.touches_edge = true
    end
  end


  local function new_temp_area(S)
    local TEMP =
    {
      name = "TEMP_" .. alloc_id("temp_area")
      zborder = S.zborder
      seeds = {}
    }

---??    if S.park_border or (S.top and S.top.park_border) or (S.bottom and S.bottom.park_border) then
---??      TEMP.park_border = true
---??    end

    table.insert(temp_areas, TEMP)

    add_seed(TEMP, S)
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


  local function perform_merge(T1, T2)
    -- merges T2 into T1 (killing T2)

    if #T2.seeds > #T1.seeds then
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

    -- mark T2 as dead
    T2.name = "DEAD_TEMP_AREA"
    T2.is_dead = true
    T2.zborder = nil
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

      if T1.zborder != T2.zborder then continue end

---??    -- never merge park borders with non-park-borders
---??    if (not T1.park_border) != (not T2.park_border) then
---??      return -1
---??    end

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
    repeat
      local changed = false

      each A1 in temp_areas do
        if A1.is_dead then continue end

        if try_merge_an_area(A1) then
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


  local function assign_outers()
    -- mark all temp areas which can trace a path to the edge
    -- of the map.

    determine_neighbors()

    each T in temp_areas do
      T.is_outer = T.touches_edge
    end

    for loop = 1,9 do
      each T in temp_areas do
      each N in T.neighbors do
        T.is_outer = T.is_outer or N.is_outer
      end
      end
    end
  end



  local function make_real_areas()
    each T in temp_areas do
      local A = AREA_CLASS.new("scenic")

      A.seeds        = T.seeds
      A.touches_edge = T.touches_edge

---??   A.park_border  = temp.park_border

      if T.zborder == "VOID" then
        A.mode = "void"
        A.is_outdoor = nil
      else
        A.is_boundary = true
        A.zborder = T.zborder
A.is_outer = T.is_outer  -- TEMP CRUD
      end

      -- install into seeds
      each S in A.seeds do
        S.area = A
        S.temp_area = nil
      end
    end
  end


  local function flood_fill_areas()
    create_temp_areas()
    merge_temp_areas()
    assign_outers()
    make_real_areas()
  end


  ---| Area_divvy_up_borders |---

  seed_list = collect_seeds()

  process(marking_func)

  process(horizontal_func, "no_diags")
  process(vertical_func,   "no_diags")
  process(diagonal_func,   "no_diags")

  process(majority_func)
  process(emergency_func)

  flood_fill_areas()
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



function Area_prune_hallways__OLD()
  --
  -- In each hallway area (except stairwells), find the shortest path
  -- between the two (or more) connections and mark them as "on_path".
  --
  -- Other parts of the hallway will be rendered solid (for indoor halls)
  -- and could potentially be used for closets (etc).
  --

  local INFINITY = 9e9


  local function calc_dist(S, N)
    local sx, sy = S:mid_point()
    local nx, ny = N:mid_point()

    return geom.dist(sx, sy, nx, ny)
  end


  local function get_min_dist_node(list)
    -- Note : we add a tiny bit of randomness to break ties in a consistent way

    local best
    local best_dist = INFINITY / 2.0

    each S in list do
      local dist = S.dij_dist + gui.random() / 256.0

      if dist < best_dist then
        best = S
        best_dist = dist
      end
    end

    if not best then
      error("dijkstra_search: no nodes with a finite distance")
    end

    return best
  end


  local function dijkstra_search(H, S1, S2)
    -- using the Dijkstra pathing algorithm here, we don't need A* since
    -- our hallways are fairly small.

    if S1 == S2 then return { S1 } end

    local unvisited = table.copy(H.seeds)

    assert(table.has_elem(unvisited, S1))
    assert(table.has_elem(unvisited, S2))

    -- initialize : source has dist of 0, everything else has infinity
    S1.dij_dist = 0

    each S in unvisited do
      if S != S1 then
        S.dij_dist = INFINITY
      end
    end

    while not table.empty(unvisited) do
      -- current node := unvisited node with smallest dist
      local S = get_min_dist_node(unvisited)

      -- reached the target?
      if S == S2 then break; end

      -- current node will never be processed again
      table.kill_elem(unvisited, S)

      -- visit each neighbor of S which has not been visited yet
      each dir in geom.ALL_DIRS do
        local N = S:neighbor(dir)

        if not (N and N.room == H) then continue end

        if not table.has_elem(unvisited, N) then continue end

        local new_dist = S.dij_dist + calc_dist(S, N)

        if new_dist < N.dij_dist then
          N.dij_dist = new_dist
          N.dij_prev = S
        end
      end
    end

    if not S2.dij_prev then
      error("dijkstra_search : failed to reach target")
    end

    -- reconstruct path
    local path = {}

    repeat
      assert(not table.has_elem(path, S2))
      table.insert(path, 1, S2)

      S2 = S2.dij_prev
    until S2 == nil

    assert(table.has_elem(path, S1))

    -- tidy up for future runs...
    each S in H.seeds do
      S.dij_dist = nil
      S.dij_prev = nil
    end

    return path
  end


  local function try_fix_diagonal(H, S)
    local L_dir = geom.LEFT_45 [S.diagonal]
    local R_dir = geom.RIGHT_45[S.diagonal]

    local NL = S:neighbor(L_dir)
    local NR = S:neighbor(R_dir)

    if not (NL and NL.room == H and not NL.not_path) then return end
    if not (NR and NR.room == H and not NR.not_path) then return end

    local T_dir = geom.RIGHT[L_dir]
    local U_dir = geom.LEFT [R_dir]

    local T = NL:neighbor(T_dir)
    local U = NR:neighbor(U_dir)

    if T != U then return end

    if not (T and T.room == H and not T.not_path) then return end

    -- OK --
    S.not_path = nil
    S.kind = nil
    S.fixed_diagonal = true
  end


  local function fixup_diagonals(H)
    -- Often there is a two diagonals opposite each other (meeting at a
    -- vertex) and only of them is becomes "on the path", the other becomes
    -- solid and it ruins some predefined shapes.  So fix them here.

    each S in H.seeds do
      if S.not_path and S.diagonal then
        try_fix_diagonal(H, S)
      end
    end
  end


  local function prune_hallway(H)
    assert(H.conns)

    -- hallways always have at least two connections
    assert(#H.conns >= 2)

    each S in H.seeds do
      S.not_path = true
      S.kind = "void"
    end

    -- find a path between each pair of connections
    -- [ we don't need to try every possible pair ]

    for i = 1, #H.conns - 1 do
      local C1 = H.conns[i]
      local C2 = H.conns[i + 1]

      local S1 = sel(C1.A1.room == H, C1.S1, C1.S2)
      local S2 = sel(C2.A1.room == H, C2.S1, C2.S2)

      assert(S1 and S1.room == H)
      assert(S2 and S2.room == H)

      local path = dijkstra_search(H, S1, S2)

      each S in path do
        S.not_path = nil
        S.kind = nil
      end
    end

    fixup_diagonals(H)
  end


  ---| Area_prune_hallways |---

-- currently not needed (hallways are never random shaped)
do return end

  each R in LEVEL.rooms do
    if R.kind == "hallway" then
      prune_hallway(R)
    end
  end
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


  each P in LEVEL.prelim_conns do
    Connect_directly(P)
  end

  Connect_teleporters()

  Area_locate_chunks()

end

