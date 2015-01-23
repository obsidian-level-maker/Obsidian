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

    mode : keyword  -- "normal", "hallway", "water",
                    -- "void", "scenic", "cage"

    kind : keyword  -- "building", "courtyard",
                    -- "cave", "landscape"

    is_outdoor : bool

    is_boundary   -- true for areas outside the boundary line

    room : ROOM


    --- geometry of area ---

    seeds : list(SEED)

    svolume : number   -- number of seeds (0.5 for diagonals)

    neighbors : list(AREA)

    -- an edge loop is a sequence of half-seed sides, going counter-clockwise.
    -- the first loop is always the outer boundary of the area.
    edge_loops : list(list(EDGE))


    --- connection stuff ---

    conns : list(CONN)  -- connections with neighbor rooms

    entry_conn : CONN

    
    --- other stuff ---

    inner_points : list(SEED)  -- points are stored as seeds
                               -- (refer to bottom-left coordinate)

    sky_group : table   -- outdoor areas which directly touch will belong
                        -- to the same sky_group (unless a solid wall is
                        -- enforced, e.g. between zones).

    stairwells : list(STAIRWELL)  -- possible stairwell usages (for a hallway)

    is_stairwell : STAIRWELL

    conn_group : number   -- connection group (used for Connect logic)
--]]


--class EDGE
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


AREA_CLASS = {}


function AREA_CLASS.new(mode)
  local A =
  {
    id   = alloc_id("area")
    mode = mode

    conns = {}
    seeds = {}
    neighbors  = {}
    inner_points = {}
  }

  A.name = "AREA_" .. A.id

  table.set_class(A, AREA_CLASS)

  table.insert(LEVEL.areas, A)

  return A
end


function AREA_CLASS.tostr(A)
  return string.format("AREA_%d", A.id)
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


function volume_of_area(A)
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


------------------------------------------------------------------------


-- class JUNCTION
--[[
    --
    -- A "junction" is information about how two touching areas interact.
    -- For example: could be solid wall, fence, or even nothing at all.
    -- Specifies default border kind (can be overridden in each seed).
    --

    A1 : AREA
    A2 : AREA

    kind : keyword   -- unset means it has not been decided yet.
                     -- can be: "nothing", "wall", "fence", "window",
                     --         "rail", "steps", "liquid_arch",
                     --         "lowering_wall", etc...

--]]


function Junction_lookup(A1, A2, create_it)
  -- returns NIL when areas do not touch, or A1 == A2

  if A1 == A2 then return nil end

  local low_id  = math.min(A1.id, A2.id)
  local high_id = math.max(A1.id, A2.id)

  local index = tostring(low_id) .. "_" .. tostring(high_id)

  if create_it then
    if not LEVEL.area_junctions[index] then
      LEVEL.area_junctions[index] = { A1=A1, A2=A2 }
    end
  end

  return LEVEL.area_junctions[index]
end



function Junction_init()
  LEVEL.area_junctions = {}

  each A in LEVEL.areas do
    each N in A.neighbors do
      Junction_lookup(A, N, "create_it")
    end
  end

  -- store junction in SEED.border[] for handy access

  each A in LEVEL.areas do
    each S in A.seeds do
      each dir in geom.ALL_DIRS do
        local N = S:neighbor(dir)

        if not (N and N.area) then continue end
        if N.area == S.area then continue end

        S.border[dir].junction = Junction_lookup(A, N.area)
      end
    end
  end
end


------------------------------------------------------------------------


-- class CORNER
--[[
    --
    -- Records all the areas and junctions which meet at the corner of
    -- every seed.  More specific information will be in the seed itself.
    --

    cx, cy  -- corner coordinate

    x, y   -- map coordinate

    areas : list(AREA)

    junctions : list(JUNCTION)

    kind : keyword   -- unset means it has not been decided yet.
                     -- can be: "post", "pillar"

--]]


function Corner_lookup(S, dir, create_it)
  local cx = S.sx
  local cy = S.sy

  if dir == 3 or dir == 9 then cx = cx + 1 end
  if dir == 7 or dir == 9 then cy = cy + 1 end

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
      cx = cx, cy = cy
      x = BASE_X + (cx-1) * SEED_SIZE
      y = BASE_Y + (cy-1) * SEED_SIZE
      areas={}, junctions={}
    }

    LEVEL.area_corners[cx][cy] = CORNER
  end
  end

  -- find touching areas

  each A in LEVEL.areas do
    each S in A.seeds do
      each dir in geom.CORNERS do
        if S.diagonal and S.diagonal == (10 - dir) then continue end

        local corner = Corner_lookup(S, dir)

        table.add_unique(corner.areas, A)
      end
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



------------------------------------------------------------------------


function Weird_create_areas()
  --
  -- Converts the point grid into areas and seeds.
  --

  local function try_set_border(S, dir, kind)
    if kind then
      S.border[dir].edge_kind = kind
    end
  end


  local function convert_to_seeds()
    for gx = 1, GRID_W - 1 do
    for gy = 1, GRID_H - 1 do
      local S = SEEDS[gx][gy]

      local P1 = GRID[gx][gy]
      local P2 = GRID[gx][gy + 1]
      local P3 = GRID[gx + 1][gy]

      local diag_edge = P1.edge[9] or P2.edge[3]

      if diag_edge then
        S:split(sel(P1.edge[9], 3, 1))

        local S2 = S.top

        -- check borders

        if S.diagonal == 3 then
          try_set_border(S,  7, diag_edge)
          try_set_border(S2, 3, diag_edge)
        else
          try_set_border(S,  9, diag_edge)
          try_set_border(S2, 1, diag_edge)
        end

        local T2, T4, T6, T8

        T2 = S ; T8 = S2
        T4 = S ; T6 = S2

        if S.diagonal == 3 then
          T4, T6 = T6, T4
        end

        try_set_border(T4, 4, P1.edge[8])
        try_set_border(T6, 6, P3.edge[8])
                                                 
        try_set_border(T2, 2, P1.edge[6])
        try_set_border(T8, 8, P2.edge[6])

      else
        -- normal square seed

        try_set_border(S, 4, P1.edge[8])
        try_set_border(S, 6, P3.edge[8])
                                                
        try_set_border(S, 2, P1.edge[6])
        try_set_border(S, 8, P2.edge[6])
      end

    end -- gx, gy
    end
  end


  local function assign_area_numbers()
    local area_num = 1

    for sx = 1, SEED_W do
    for sy = 1, SEED_H do
      local S = SEEDS[sx][sy]

      S.area_num = area_num

      if S.top then S.top.area_num = area_num + 1 end

      area_num = area_num + 2
    end -- sx, sy
    end
  end


  local function flood_check_pair(S, dir)
    if not S then return end

    -- blocked by an edge, cannot flood across it
    if S.border[dir].edge_kind then return end

    local N = S:neighbor(dir)

    if not N then return end

    -- already the same?
    if S.area_num == N.area_num then return end

    local new_num = math.min(S.area_num, N.area_num)

    S.area_num = new_num
    N.area_num = new_num

    did_change = true
  end


  local function flood_fill_pass()
    for sx = 1, SEED_W do
    for sy = 1, SEED_H do
      local S  = SEEDS[sx][sy]
      local S2 = S.top

      each dir in geom.ALL_DIRS do
        flood_check_pair(S,  dir)
        flood_check_pair(S2, dir)
      end
    end
    end
  end


  local function area_for_number(num)
    local area = LEVEL.temp_area_map[num]

    if not area then
      -- this mode can become "void" or "scenic" later
      area = AREA_CLASS.new("normal")

      LEVEL.temp_area_map[num] = area
    end

    return area
  end


  local function flood_fill_areas()
    gui.printf("flood_fill_areas....\n")

    assign_area_numbers()

    repeat
gui.printf("  loop %d\n", alloc_id("flood_loop"))
      did_change = false
      flood_fill_pass()
    until not did_change
  end


  local function check_squarify_seeds()
    -- detects when a diagonal seed has same area on each half

    for sx = 1, SEED_W do
    for sy = 1, SEED_H do
      local S  = SEEDS[sx][sy]

      if S.diagonal and S.top.area_num == S.area_num then
        S:join_halves()
      end
    end
    end
  end


  local function set_area(S)
    S.area = area_for_number(S.area_num)

    table.insert(S.area.seeds, S)
  end


  local function area_pair_str(A1, A2)
    if A1.id > A2.id then
      A1, A2 = A2, A1
    end

    return string.format("%d_%d", A1.id, A2.id)
  end


  local function try_add_neighbors(A1, A2, nb_map)
    local str = area_pair_str(A1, A2)

    -- already seen this pair?
    if nb_map[str] then return end

--    assert(not table.has_elem(A1.neighbors, A2))
--    assert(not table.has_elem(A2.neighbors, A1))

    table.insert(A1.neighbors, A2)
    table.insert(A2.neighbors, A1)

    nb_map[str] = 1
  end


  local function find_area_neighbors()
    local nb_map = {}

    each A in LEVEL.areas do
      each S in A.seeds do
        each dir in geom.ALL_DIRS do
          local N = S:neighbor(dir)

          if N and N.area and N.area != A then
            try_add_neighbors(A, N.area, nb_map)
          end
        end
      end
    end
  end


  local function create_the_areas()
    flood_fill_areas()

    check_squarify_seeds()

    LEVEL.temp_area_map = {}

    for sx = 1, SEED_W do
    for sy = 1, SEED_H do
      local S  = SEEDS[sx][sy]
      local S2 = S.top

      set_area(S)

      if S2 then set_area(S2) end
    end
    end

    LEVEL.temp_area_map = nil

    find_area_neighbors()
  end


  local function flood_inner_areas(A)
    A.is_inner = true

    each S in A.seeds do
    each dir in geom.ALL_DIRS do
      local N = S:neighbor(dir)

      if not (N and N.area) then continue end

      if N.area.is_inner then continue end

      if S.border[dir].edge_kind == "boundary" then continue end

      flood_inner_areas(N.area)
    end
    end
  end


  local function mark_boundary_areas()
    -- mark areas that lie outside of the boundary outline.
    
    -- middle seed will be normal (non-boundary)
    local mx = int(SEED_W / 2)
    local my = int(SEED_H / 2)

    local S1 = SEEDS[mx][my]

    flood_inner_areas(assert(S1.area))

    -- bottom left seed will be boundary
    local S2 = SEEDS[1][1]

    if S2.area.is_inner then
      error("mark_boundary_areas failed")
    end

    each area in LEVEL.areas do
      if not area.is_inner then
        area.mode = "scenic"
        area.is_boundary = true
      end
    end
  end


  ---| Weird_create_areas |---

  convert_to_seeds()

  create_the_areas()

  mark_boundary_areas()
end



function Weird_analyse_areas()
  --
  -- See how much open space is in each area, etc...
  --

  local function collect_inner_points(A)
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
      table.insert(A.inner_points, S)
    end
  end


  local function check_is_edge(A, S, dir)
    local N = S:neighbor(dir, "NODIR")

    if N == "NODIR" then return false end

    if N == nil then return true end

    return (N.area != A)
  end


  local function trace_to_next_edge(A, S, dir, mode)
    dir = geom.ROTATE[5][dir]

    for pass = 1, 8 do
      if check_is_edge(A, S, dir) then
        return S, dir
      end

      if geom.is_straight(dir) then
        S = S:neighbor(dir)
        assert(S and S.area and S.area == A)
      end

      dir = geom.RIGHT_45[dir]
    end

    error("Failed to trace next edge at seed corner")
  end


  local function trace_edge_loop(A, S, dir, mode)
    -- mode is either "outer" or "inner"

    local loop = {}

    local orig_S   = S
    local orig_dir = dir

    repeat
      table.insert(loop, { S=S, dir=dir })

      if #loop > 9999 then
        error("Excessive looping when tracing AREA_" .. tostring(A.id))
      end

      S, dir = trace_to_next_edge(A, S, dir, mode)

    until S == orig_S and dir == orig_dir

    -- all done
    table.insert(A.edge_loops, loop)
  end


  local function create_edge_loops(A)
    A.edge_loops = {}

    -- find a start seed : vertically lowest
    local low_S

    each S in A.seeds do
      if not low_S or S.sy < low_S.sy then
        low_S = S
      end
    end

    assert(low_S)

    -- must be an edge in directions 1, 2 or 3

    for dir = 1,3 do
      if check_is_edge(A, low_S, dir) then
        trace_edge_loop(A, low_S, dir, "outer")
        break;
      end
    end

    if not A.edge_loops[1] then
      error("Failed to trace outer loop of AREA_" .. tostring(A.id))
    end

    -- FIXME : inner loops
  end


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


  ---| Weird_analyse_areas |---

  each A in LEVEL.areas do
    collect_inner_points(A)

    create_edge_loops(A)

    A.svolume = volume_of_area(A)

    A.openness = #A.inner_points / A.svolume
  end

  if OB_CONFIG.mode == "ctf" then
    Seed_setup_CTF()

    find_CTF_peers()
  end
end




function Weird_group_into_rooms()
  --
  -- This actually creates the rooms by grouping a bunch of areas together.
  --
  -- In CTF mode, we ignore the mirrored half of the map until the rooms
  -- are actually created, at which point we create two peered rooms.
  --

  local usable_areas


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


  local function svol_is_tiny(svolume)
    return svolume < 8
  end


  local function new_temp_room(A)
    return { id=A.id, size=A.svolume }
  end


  local function rand_max_room_size()
    -- this value is mainly what controls whether two compatible areas can be
    -- merged into a single room.

-- do return 9999 end  --!!!!!!

    local SIZES =
    {
      [95]  =  5,
      [45]  = 20,
      [25]  = 70,
      [15]  = 10
    }

    return rand.key_by_probs(SIZES)
  end


  local function collect_usable_areas()
    usable_areas = {}

    each A in LEVEL.areas do
      -- hallways are handled later
      if A.mode != "normal" then continue end

      -- in CTF maps, handle the mirrored half of map later on
      if A.brother then continue end

      -- very small rooms are handled specially (later on)
      if svol_is_tiny(A.svolume) then A.is_tiny = true ; continue end

      table.insert(usable_areas, A)

      A.temp_room = new_temp_room(A)

      A.max_room_size = rand_max_room_size()
    end
  end


  local function merge_temp_rooms(T1, T2)
    assert(not T1.is_dead)
    assert(not T2.is_dead)

    if T1.id > T2.id then
      T1, T2 = T2, T1
    end

    T1.size = T1.size + T2.size
    T2.size = 0

    each A in LEVEL.areas do
      if A.temp_room == T2 then
        A.temp_room = T1
      end
    end

    T2.is_dead = true
  end


  local function try_merge_two_areas(A1, A2, allow_hallway)
    -- A1 is source area
    -- A2 is destination area

    assert(A1.temp_room)
    assert(A2.temp_room)

    assert(A1.temp_room != A2.temp_room)

    -- check size constraints

    local new_size = A1.temp_room.size + A2.temp_room.size

    if not A1.is_tiny then
      local max_size = math.min(A1.max_room_size, A2.max_room_size)

      if new_size > max_size then
        return false
      end
    end

    if A1.is_tiny and A2.is_tiny then
      -- only merge two tiny rooms if combined size is large enough
      if svol_is_tiny(new_size) then return false end
    end

    -- don't merge into hallways unless tiny_mode == "emergency"

    if A2.mode == "hallway" then
      -- FIXME
      if not allow_hallway then return false end

      A1.mode = "hallway" 
    end

    -- TODO : check for "robust" border (# of shared edges)

    -- OK --

    merge_temp_rooms(A1.temp_room, A2.temp_room)

    -- in CTF mode, ensure team is consistent in a room
    if A1.is_tiny then
      A1.team = A2.team
      if A1.sister then A1.sister.team = A2.sister.team end
    end

    -- forget tinyness
    A1.is_tiny = nil
    A2.is_tiny = nil

    return true
  end


  local function try_merge_a_neighbor(A, tiny_mode)
    local poss = {}

    each N in A.neighbors do
      -- CTF: never merge a peered room into a non-peered room
      if A.no_ctf_peer != N.no_ctf_peer then
        continue
      end

      -- CTF: avoid merging different teams [relaxed for tiny rooms]
      if not tiny_mode and A.team and A.team != N.team then
        continue
      end

      if N.temp_room and N.temp_room != A.temp_room then
        table.insert(poss, N)
      end
    end

    if table.empty(poss) then
      return false
    end

    rand.shuffle(poss)

    -- in tiny mode, try all possible neighbors

    for i = 1, sel(tiny_mode, #poss, 1) do
      local N2 = table.remove(poss, 1)

      if try_merge_two_areas(A, N2, tiny_mode == "emergency") then
        return true
      end
    end

    return false
  end


  local function iterate_merges()
    local num_loop = #usable_areas

    for loop = 1, num_loop do
      rand.shuffle(usable_areas)

      each A in usable_areas do
        if rand.odds(35) then
          try_merge_a_neighbor(A)
        end
      end
    end
  end

  
  local function can_kill_area(A)
    local nb_rooms = {}

    each N in A.neighbors do
      if N.temp_room then
        table.add_unique(nb_rooms, N.temp_room)
      end
    end

    return (#nb_rooms < 2)
  end


  local function kill_tiny_area(A)
    gui.debugf("Killing tiny AREA_%d\n", A.id)

    A.mode = "void"
    A.temp_room = nil
    A.is_tiny = nil

    if A.sister then A.sister.mode = "void" end
  end


  local function handle_tiny_areas()
    -- do this first, allowing two tiny areas to merge together
    each A in LEVEL.areas do
      if A.is_tiny then
        A.temp_room = new_temp_room(A)
      end
    end

    -- on first pass, try merge area into a normal room.
    -- on second pass, allow merge into a hallway _OR_ kill the area

    for pass = 1, 2 do
      each A in LEVEL.areas do
        if not A.is_tiny then continue end

        if pass == 1 and try_merge_a_neighbor(A, "normal") then
          -- Ok
        end

        if pass == 2 then
          if can_kill_area(A) then
            kill_tiny_area(A)
          elseif not try_merge_a_neighbor(A, "emergency") then
            error("Failed to merge a tiny area")
          end
        end

      end -- A
    end -- pass
  end


  local function handle_hallways()
    each A in LEVEL.areas do
      if A.mode == "hallway" and not A.brother then
        assert(not A.temp_room)
        A.temp_room = new_temp_room(A)
      end
    end
  end


  local function merge_touching_hallways()
    -- ensure any touching hallways always become a single room
    -- [ this is REQUIRED by the connection logic ]

    each A in LEVEL.areas do
      if not (A.mode == "hallway" and not A.brother) then continue end
      assert(A.temp_room)

      each N in A.neighbors do
        if (N.mode == "hallway" and not N.brother) and
          N.temp_room != A.temp_room
        then
          stderrf("Merging touching hallways...\n")
          merge_temp_rooms(A.temp_room, N.temp_room)
        end
      end
    end
  end


  local function room_from_area(A)
    local ROOM = ROOM_CLASS.new()

    if A.mode == "hallway" then
      ROOM.kind = "hallway"
      ROOM.is_hallway = true
    end

    return ROOM
  end


  local function create_rooms()
    -- all "roomish" areas should now have a 'temp_room' table

    each A in LEVEL.areas do
      local temp = A.temp_room

      if not temp then continue end
      assert(not temp.is_dead)

      if not temp.R1 then
        temp.R1 = room_from_area(A)

        -- CTF: create mirrored room now
        if A.sister then
          assert(not A.sister.room)
          temp.R2 = room_from_area(A.sister, temp)

          -- peer the rooms
          temp.R1.sister  = temp.R2
          temp.R2.brother = temp.R1

          stderrf("Peering rooms: brother %s <--> %s sister\n", temp.R1:tostr(), temp.R2:tostr())
        end
      end

      temp.R1:add_area(A)

      if A.sister then
        temp.R2:add_area(A.sister)
      end
    end
  end


  ---| Weird_group_into_rooms |---

  collect_usable_areas()

  for main_loop = 1, 30 do
    iterate_merges()
  end

  -- must do hallways before tiny areas
  handle_hallways()

  handle_tiny_areas()

  merge_touching_hallways()

  create_rooms()

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
    local along = LEVEL.game_along

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



function Weird_create_rooms()

  gui.printf("\n--==| Planning WEIRD Rooms |==--\n\n")

  local W, H = Area_determine_map_size()

  gui.printf("Map size: %dx%d grid points\n", W, H)


  Seed_init(W - 1, H - 1)

  Weird_generate(W, H)

  Weird_create_areas()
  Weird_analyse_areas()

  Junction_init()
    Corner_init()

  Room_void_some_areas()
  Room_assign_hallways()

  Weird_group_into_rooms()

  Room_choose_area_kinds()


  gui.printf("Seed Map:\n")
  Seed_dump_rooms()

  each R in LEVEL.rooms do
    gui.printf("Final %s   size: %dx%d\n", R:tostr(), R.sw, R.sh)
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

