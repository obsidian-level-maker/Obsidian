------------------------------------------------------------------------
--  AREA MANAGEMENT
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


-- class AREA
--[[
    --- kind of area ---

    id, name  -- debugging info

    mode : keyword  -- "floor"  (traversible part of a normal room)
                    -- "hallway" (used for stairwells too)
                    -- "void"
                    -- "scenic"
                    -- "cage", "trap"
                    -- "pool"

    scenic_kind : keyword  -- "water", "mountain"

    is_outdoor    -- true if outdoors (sky ceiling)

    is_boundary   -- true for areas outside the boundary line


    room : ROOM

    zone : ZONE


    --- geometry of area ---

    seeds : list(SEED)

    svolume : number   -- number of seeds (0.5 for diagonals)

    neighbors : list(AREA)

    edges : list(EDGE)


    --- connection stuff ---

---##    conns : list(CONN)  -- connections with neighbor rooms

---##    entry_conn : CONN


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


--class STAIRWELL
--[[
    edge1  -- index into outer edge loop
    edge2

    room1 : ROOM   -- rooms which connect at edge1 and edge2
    room2 : ROOM   --

    wide1 : bool   -- when true, next edge is used as well
    wide2 : bool

    info : STAIRWELL_SHAPE
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
    neighbors  = {}
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


function AREA_CLASS.calc_volume(A)
  local volume = 0

  each S in A.seeds do
    if S.diagonal then
      volume = volume + 0.5
    else
      volume = volume + 1
    end
  end

  return volume
end


function AREA_CLASS.touches(A, N)
  return table.has_elem(A.neighbors, N)
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
  -- compute room volume too!
  each R in LEVEL.rooms do
    R.svolume = 0
  end

  each A in LEVEL.areas do
    A.svolume = A:calc_volume()

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
  end
  end
  end
end



function Area_largest_area(zone)
  -- Note : zone can be omitted to give largest area of map

  local best

  each A in LEVEL.areas do
    if zone and A.zone != zone then continue end

    if A.mode == "normal" then
      if not best or (A.svolume > best.svolume) then
        best = A
      end
    end
  end

  return assert(best)
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

  if OB_CONFIG.mode == "ctf" then
    error("CTF mode is broken!")

    Seed_setup_CTF()

    find_CTF_peers()
  end
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



function Area_collect_seeds()
  -- FIXME : room method instead??


  local function collect_seeds(R)
    local sx1, sx2 = 999, -999
    local sy1, sy2 = 999, -999

    local function update(x, y)
      sx1 = math.min(sx1, x)
      sy1 = math.min(sy1, y)
      sx2 = math.max(sx2, x)
      sy2 = math.max(sy2, y)
    end

    for sx = 1, SEED_W do
    for sy = 1, SEED_H do
      local S  = SEEDS[sx][sy]
      local S2 = S.top

      if S.area and S.area.room == R then
        S.room = R
        table.insert(R.seeds, S)
        update(sx, sy)
      end

      if S2 and S2.area and S2.area.room == R then
        S2.room = R
        table.insert(R.seeds, S2)
        update(sx, sy)
      end
    end
    end

    if sx1 > sx2 then
      error("Room with no seeds!")
    end

    R.sx1 = sx1 ; R.sx2 = sx2
    R.sy1 = sy1 ; R.sy2 = sy2

    R.sw = R.sx2 - R.sx1 + 1
    R.sh = R.sy2 - R.sy1 + 1
  end


  each R in LEVEL.rooms do
    collect_seeds(R)
  end
end



function Area_determine_map_size()
  --
  -- Determines size of map (Width x Height) in grid points, based on the
  -- user's settings and how far along in the episode or game we are.
  --

  local ob_size = OB_CONFIG.size

  -- there is no real "progression" when making a single level.
  -- hence use mixed mode instead.
  if OB_CONFIG.length == "single" then
    if ob_size == "prog" or ob_size == "epi" then
      ob_size = "mixed"
    end
  end

  -- Mix It Up --

  if ob_size == "mixed" then
    local SIZES = { 21,23,25, 29,33,37, 41,43,49 }

    if OB_CONFIG.mode == "dm" then
      SIZES = { 21,23,25, 29,33,39 }
    end

    local W = rand.pick(SIZES)
    local H = rand.pick(SIZES)

    -- prefer the map to be wider than it is tall
    if W < H then W, H = H, W end

    return W, H
  end

  -- Progressive --

  if ob_size == "prog" or ob_size == "epi" then
    local along = LEVEL.game_along ^ 0.66

    if ob_size == "epi" then along = LEVEL.ep_along end

    local n = int(1 + along * 8.9)

    if n < 1 then n = 1 end
    if n > 9 then n = 9 end

    local SIZES = { 25,27,29, 31,33,35, 37,39,41 }

    local W = SIZES[n]
    local H = W - 4

    -- not so big in Deathmatch mode
    if OB_CONFIG.mode == "dm" then return H, H - 2 end

    return W, H
  end

  -- Named sizes --

  -- smaller maps for Deathmatch mode
  if OB_CONFIG.mode == "dm" then
    local SIZES = { small=21, regular=27, large=35, extreme=51 }

    local W = SIZES[ob_size]

    return W, W
  end

  local SIZES = { small=27, regular=35, large=45, extreme=61 }

  local W = SIZES[ob_size]

  if not W then
    error("Unknown size keyword: " .. tostring(ob_size))
  end

  return W, W - 4
end



function Area_create_rooms()

  gui.printf("\n--==| Creating Rooms |==--\n\n")

  local W, H = Area_determine_map_size()

  gui.printf("Map size: %dx%d grid points\n", W, H)


  Seed_init(W - 1, H - 1)

  Room_create_cave_grid()

  Grower_create_rooms()

---???  Area_split_map_edges()

  Area_analyse_areas()

  Junction_init()
    Corner_init()

  Area_find_inner_points()

  Area_collect_seeds()

---###  Connect_areas_in_rooms()


  gui.printf("Seed Map:\n")
  Seed_dump_rooms()

  each R in LEVEL.rooms do
    gui.debugf("Final %s   size: %dx%d\n", R.name, R.sw, R.sh)
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



function Area_prune_hallways()
  --
  -- In each hallway area (except stairwells), find the shortest path
  -- between the two (or more) connections and mark them as "on_path".
  --
  -- Other parts of the hallway will be rendered solid (for indoor halls)
  -- abd could potentially be used for closets (etc).
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

