------------------------------------------------------------------------
--  AREA MANAGEMENT
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2016 Andrew Apted
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


-- class AREA
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


    room : ROOM

    zone : ZONE

    chunk : CHUNK   -- only set when mode == "chunk"


    --- geometry of area ---

    seeds : list(SEED)

    svolume : number   -- number of seeds (0.5 for diagonals)

    neighbors : list(AREA)

    edges : list(EDGE)


    --- other stuff ---

    inner_points : list(CORNER)

    stairwells : list(STAIRWELL)  -- possible stairwell usages (for a hallway)

    is_stairwell : STAIRWELL

--]]


--class AREA_EDGE
--[[
    S : seed
    dir : dir
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

    -- these are "pseudo edges" which will be used to render the junction.
    -- they do not contain position info (S and dir).
    -- by default these are absent, which means "do nothing".
    -- E2 is not used (NIL) for map edges.
    E1 : EDGE
    E2 : EDGE

    keep_empty   -- true if junction should stay as "nothing"

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
  A.name = "DEAD_AREA"

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


function Chunk_new(kind, sx1,sy1, sx2,sy2)
  local CHUNK =
  {
    kind = kind
    
    sx1 = sx1, sy1 = sy1
    sx2 = sx2, sy2 = sy2

    sw = (sx2 - sx1 + 1)
    sh = (sy2 - sy1 + 1)

    encroach = {}
  }

  local S1 = SEEDS[sx1][sy1]
  local S2 = SEEDS[sx2][sy2]

  CHUNK.mx = math.mid(S1.x1, S2.x2)
  CHUNK.my = math.mid(S1.y1, S2.y2)

  return CHUNK
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
    if x == sym.x then return S end
    x = sym.x * 2 + sel(sym.wide, 1, 0) - x
  end

  if sym.dir == 4 or sym.dir == 6 then
    if y == sym.y then return S end
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
      local junc = Junction_lookup(corner.areas[i], corner.areas[k])

      if junc then
        table.add_unique(corner.junctions, junc)
      end
    end
    end
  end
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
      corner.walls[wall_dir].R = "METAL";
    else
      corner.walls[wall_dir].L = "METAL";
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
  -- locate seed rectangles in areas of rooms, these will be used
  -- for placing importants (goals, teleporters, etc) and also
  -- decorative prefabs.
  --

  -- TODO : handle symmetrical rooms:
  --    1. peer up chunks either side of the line of symmetry
  --    2. handle chunks ON the line of symmetry


  local PASSES = { 44, 42,24, 33, 32,23,  22, 21,12,  11 }

  -- the large sizes often hog too much space in a room, so we
  -- don't always keep them
  local USE_PROBS =
  {
    [44] = 67
    [42] = 22
    [24] = 22

    [33] = 67
    [32] = 22
    [23] = 22
  }


  local function create_chunk(A, sx1,sy1, sx2,sy2)
    local R = assert(A.room)

    local kind = "area"
    if A.mode == "liquid" then kind = "liquid" end

    local CHUNK = Chunk_new(kind, sx1,sy1, sx2,sy2)

    CHUNK.area = A
    CHUNK.place = "floor"

    if CHUNK.sw < 2 or CHUNK.sh < 2 then
      CHUNK.is_small = true
    end

    if kind == "liquid" then
      table.insert(R.liquid_chunks, CHUNK)
    else
-- stderrf("adding CHUNK %dx%d in %s of %s\n", CHUNK.sw, CHUNK.sh, A.name, R.name)
      table.insert(R.chunks, CHUNK)
    end

    return CHUNK
  end


  local function test_chunk_at_seed(A, sx1,sy1, sx2,sy2)
    for x = sx1, sx2 do
    for y = sy1, sy2 do
      if not Seed_valid(x, y) then return false end

      local N = SEEDS[x][y]

      if not N then return false end
      if N.area != A then return false end
      if N.diagonal or N.chunk then return false end
    end
    end

    return true
  end


  local function install_chunk_at_seed(A, sx1,sy1, sx2,sy2, chunk)
    for x = sx1, sx2 do
    for y = sy1, sy2 do
      SEEDS[x][y].chunk = chunk
    end
    end
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

      -- save time by checking the usage prob *first*
      if not rand.odds(use_prob) then continue end

      if test_chunk_at_seed(A, sx1,sy1, sx2,sy2) then
        local CHUNK = create_chunk(A, sx1,sy1, sx2,sy2)

        install_chunk_at_seed(A, sx1,sy1, sx2,sy2, CHUNK)
      end
    end
  end


  local function find_chunks_in_area(A)
    local seed_list = table.copy(A.seeds)

    each pass in PASSES do
      rand.shuffle(seed_list)

      find_sized_chunks(A, seed_list, pass)
    end
  end


  ---| Area_locate_chunks |---

  each R in LEVEL.rooms do
  each A in R.areas do
    if A.mode == "floor" or A.mode == "liquid" then
      find_chunks_in_area(A)
    end
  end -- R, A
  end
end



function Area_analyse_areas()

  local function spread_CTF_team(A1, visit_list)
    if not A1.team then
      local A2 = A1:get_ctf_peer()

      if not A2 then
        A1.team = "neutral"
        A1.no_ctf_peer = true
      else
        assert(not A2.team)

        A1.team = "blue"
        A2.team = "red"

        A1.sister  = A2
        A2.brother = A1

        stderrf("peering CTF: brother %s <--> %s sister\n", A1.name, A2.name)
      end
    end

    each N in A1.neighbors do
      if not N.team then
        table.insert(visit_list, N)
      end
    end
  end


  local function find_CTF_peers()
    --
    -- Setup 'brother' and 'sister' relationship between mirrored areas
    --

    -- Do a flood fill through the level.
    -- This spreading logic tries to keep teamed areas contiguous
    -- (i.e. PREVENT pockets of one color surrounded by the other color).

    -- begin at first area (usually at bottom left, but it doesn't matter)

    local visit_list = { LEVEL.areas[1] }

    while not table.empty(visit_list) do
      local A1 = table.remove(visit_list, 1)

      spread_CTF_team(A1, visit_list)
    end

    -- sanity check
    each A in LEVEL.areas do
      assert(A.team)
    end

    -- TODO : add/grow the central neutral area [ upto a quota ]
  end


  ---| Area_analyse_areas |---

  Area_calc_volumes()

  each R in LEVEL.rooms do
    R:collect_seeds()
  end

  Area_find_neighbors()

  Area_locate_chunks()

  if OB_CONFIG.mode == "ctf" then
    error("CTF mode is broken!")

    Seed_setup_CTF()

    find_CTF_peers()
  end
end



function Area_assign_boundary()
  --
  -- ALGORITHM:
  --   1. all the existing room areas are marked as "inner"
  --
  --   2. mark some non-room areas which touch a room as "inner"
  --
  --   3. visit each non-inner area:
  --      (a) flood-fill to find all joined non-inner areas
  --      (b) if this group touches edge of map, mark as boundary,
  --          otherwise mark as "inner"
  --

  local function area_touches_a_room(A)
    each N in A.neighbors do
      if N.room then return true end
    end

    return false
  end


  local function area_touches_edge(A)
    -- this also prevents a single seed gap between area and edge of map

    each S in A.seeds do
      if S.sx <= 2 or S.sx >= SEED_W-1 then return true end
      if S.sy <= 2 or S.sy >= SEED_H-1 then return true end
    end

    return false
  end


  local function area_is_inside_box(A)
    each S in A.seeds do
      if LEVEL.boundary_sx1 < S.sx and S.sx < LEVEL.boundary_sx2 and
         LEVEL.boundary_sy1 < S.sy and S.sy < LEVEL.boundary_sy2
      then
        return true
      end
    end

    return false
  end


  local function mark_room_inners()
    each A in LEVEL.areas do
      if A.room then
        A.is_inner = true
      end
    end
  end


  local function mark_other_inners()
    local prob = 20*0

    each A in LEVEL.areas do
      if not A.room and
         rand.odds(prob) and
         area_touches_a_room(A) and
         area_is_inside_box(A) and
         not area_touches_edge(A)
      then
        A.is_inner = true
      end
    end
  end


  local function mark_outer_recursive(A)
    assert(not A.room)

    A.is_boundary = true
    A.mode = "scenic"

    -- recursively handle neighbors
    each N in A.neighbors do
      if not (N.is_inner or N.is_boundary) then
        mark_outer_recursive(N)
      end
    end
  end


  local function floodfill_outers()
    each A in LEVEL.areas do
      if not (A.is_inner or A.is_boundary) and area_touches_edge(A) then
        mark_outer_recursive(A)
      end
    end
  end


  ---| Area_assign_boundary |---

  mark_room_inners()

  mark_other_inners()

  floodfill_outers()
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



function Area_closet_edges()

  local function visit_closet(chunk)
    local E = Seed_create_chunk_edge(chunk, chunk.from_dir, "nothing")
  end

  ---| Area_closet_edges |---

  each R in LEVEL.rooms do
    each CL in R.closets do
      visit_closet(CL)
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

  Grower_create_rooms()

  Area_analyse_areas()
  Area_assign_boundary()

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
end

