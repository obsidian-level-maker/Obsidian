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

    mode : keyword  -- "normal", "hallway",
                    -- "void", "scenic",
                    -- "cage", "trap"

    kind : keyword  -- "building", "courtyard",
                    -- "cave", "landscape"
                    --
                    -- For scenic: "water", "mountain"

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

    inner_points : list(CORNER)

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


--class JUNCTION
--[[
    --
    -- A "junction" is information about how two touching areas interact.
    -- For example: could be solid wall, fence, or even nothing at all.
    --
    -- Specifies the default border kind, but it can be overridden in each
    -- seed via the border[] field.
    --

    A1 : AREA
    A2 : AREA

    kind : keyword   -- unset means it has not been decided yet.
                     -- can be: "nothing", "wall", "fence", "window",
                     --         "rail", "steps", "liquid_arch",
                     --         "lowering_wall", etc...

    perimeter    -- a measure of length of the border between the areas
                 -- (in units of seed-edges)
--]]


--class CORNER
--[[
    --
    -- Records all the areas and junctions which meet at the corner of
    -- every seed.  More specific information will be in the seed itself.
    --

    cx, cy  -- corner coordinate [1..SEED_W+1 / 1..SEED_H+1]

    x, y   -- map coordinate

    areas : list(AREA)

    junctions : list(JUNCTION)

    kind : keyword   -- unset means it has not been decided yet.
                     -- can be: "post", "pillar"

    inner_point : AREA  -- usually NIL

    delta_x, delta_y    -- usually NIL, used for mountains
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


function AREA_CLASS.make_hallway(A)
  A.mode = "hallway"
  A.stairwells = {}

  if A.sister then
    A.sister.mode = "hallway"
    A.sister.stairwells = {}
  end
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
  -- returns NIL when areas do not touch, or A1 == A2

  if A1 == A2 then return nil end

  local low_id  = math.min(A1.id, A2.id)
  local high_id = math.max(A1.id, A2.id)

  local index = tostring(low_id) .. "_" .. tostring(high_id)

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

  -- store junction in SEED.border[] for handy access.
  -- also compute the perimeter of each junction.

  each A in LEVEL.areas do
  each S in A.seeds do
  each dir in geom.ALL_DIRS do
    local N = S:neighbor(dir)

    if not (N and N.area) then continue end
    if N.area == S.area then continue end

    local junc = Junction_lookup(A, N.area)

    S.border[dir].junction = junc

    if dir < 5 then
      junc.perimeter = junc.perimeter + 1
    end
  end
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

    local corner = S:get_corner(dir)

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


function Area_squarify_seeds()
  Seed_squarify()

  -- update areas for merged seeds

  each A in LEVEL.areas do
    for i = #A.seeds, 1, -1 do
      if A.seeds[i].kind == "dead" then
        table.remove(A.seeds, i)
      end
    end
  end
end



function Area_calc_volumes()
  each A in LEVEL.areas do
    A.svolume = A:calc_volume()
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


  ---| Area_analyse_areas |---

  Area_calc_volumes()

  each A in LEVEL.areas do
    create_edge_loops(A)
  end

  if OB_CONFIG.mode == "ctf" then
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




function Area_group_into_rooms()
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


  local function try_merge_two_areas(A1, A2)
    -- A1 is source area
    -- A2 is destination area

    assert(A1.temp_room)
    assert(A2.temp_room)

    assert(A1.temp_room != A2.temp_room)

    assert(A1.zone == A2.zone)

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

    -- never merge into hallways
    if A2.mode == "hallway" then
      return false
    end

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
      if A.zone != N.zone then continue end

      if not N.temp_room then continue end


      if N.temp_room == A.temp_room then continue end

      -- CTF: never merge a peered room into a non-peered room
      if A.no_ctf_peer != N.no_ctf_peer then
        continue
      end

      -- CTF: avoid merging different teams [relaxed for tiny rooms]
      if not tiny_mode and A.team and A.team != N.team then
        continue
      end

      table.insert(poss, N)
    end

    if table.empty(poss) then
      return false
    end

    rand.shuffle(poss)

    -- in tiny mode, try all possible neighbors

    for i = 1, sel(tiny_mode, #poss, 1) do
      local N2 = table.remove(poss, 1)

      if try_merge_two_areas(A, N2) then
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

  
  local function try_kill_tiny_area(A)
    if A.has_zone_conn then return false end

    -- not possible when area has more than two roomy neighbors
    -- (since this area may be a bridge between two halves of the map/zone)
    local nb_rooms = {}

    each N in A.neighbors do
      if N.zone != A.zone then continue end

      if N.temp_room then
        table.add_unique(nb_rooms, N.temp_room)
      end
    end

    if #nb_rooms >= 2 then
      return false
    end

    gui.debugf("Killing tiny AREA_%d\n", A.id)

    A.mode = "void"

    if A.sister then A.sister.mode = "void" end

    A.temp_room.is_dead = true

    A.is_tiny = nil
    A.temp_room = nil

    return true
  end


  local function tiny_into_hallway(A)
    if A.has_zone_conn then return false end

    A:make_hallway()

    if A.sister then
      A.sister:make_hallway()
    end

    -- we keep the 'temp_room'

    A.is_tiny = nil
  end

  
  local function handle_tiny_areas()
    -- do this first, allowing two tiny areas to merge together
    each A in LEVEL.areas do
      if A.is_tiny then
        A.temp_room = new_temp_room(A)
      end
    end

    -- first pass : try merge area into a normal room.

    each A in LEVEL.areas do
      if A.is_tiny then
        try_merge_a_neighbor(A, "tiny_mode") 
      end
    end

    -- second pass : try to kill it

    each A in LEVEL.areas do
      if A.is_tiny then
        try_kill_tiny_area(A)
      end
    end

    -- final pass : turn it into a hallway

    each A in LEVEL.areas do
      if A.is_tiny then
        tiny_into_hallway(A)
      end
    end
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
        if N.zone != A.zone then continue end

        if (N.mode == "hallway" and not N.brother) and
          N.temp_room != A.temp_room
        then
          gui.debugf("Merging touching hallways...\n")
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


  local function make_the_rooms()
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


  ---| Area_group_into_rooms |---

  collect_usable_areas()

  for main_loop = 1, 30 do
    iterate_merges()
  end

  -- must do hallways before tiny areas
  handle_hallways()

  handle_tiny_areas()

  merge_touching_hallways()

  make_the_rooms()

  each R in LEVEL.rooms do
    collect_seeds(R)
  end
end



function Area_create_zones()

  local LOCS =
  {
    [1] = 50, [3] = 50, [7] = 50, [9] = 50,
    [2] = 50, [4] = 50, [6] = 50, [8] = 50,

    -- try to often use the middle area
    [5] = 250
  }

  local RATES = { 90, 70, 50, 30, 15 }

  local MIN_AREAS = 5

  local zone_list
  local area_list


  local function calc_quota()
    -- quota is based on number of usable areas

    if OB_CONFIG.mode == "ctf" or OB_CONFIG.mode == "dm" then
      return 1
    end

    local count = #area_list

    local low  = 1.2 + count / 80
    local high = 2.2 + count / 50

    quota = int(rand.range(low, high))

    quota = math.clamp(1, quota, 5)

    gui.printf("Zone quota: %d (for %d areas)\n", quota, count)

    return quota
  end


  local function set_zone(A, Z)
    A.zone = Z

    Z.num_areas = Z.num_areas + 1
    Z.svolume   = Z.svolume + A.svolume
  end


  local function pick_initial_area(loc)
    for loop = 1, 20 do
      local sx, sy = Seed_from_loc(loc)

      local A = SEEDS[sx][sy].area

      if not A.zone and not A.is_boundary then
        return A
      end
    end

    -- that failed, pick a random area

-- stderrf("Could not find free area @ loc=%d\n", loc)

    for loop = 1, 999 do
      local A = rand.pick(area_list)

      if not A.zone then
        return A
      end
    end

    error("Failed to pick initial area of zone")
  end


  local function add_zone()
    local Z = Zone_new()

    -- pick a growth rate
    Z.grow_rate = table.remove(RATES, 1)

    -- set an initial area to the zone
    local loc = rand.key_by_probs(LOCS)
    LOCS[loc] = nil

    local A = pick_initial_area(loc)

    set_zone(A, Z)
  end


  local function check_finished()
    each A in area_list do
      if not A.zone then return false end
    end

    return true
  end


  local function touches_zone(A, Z)
    each N in A.neighbors do
      if N.zone == Z then
        return true
      end
    end
    
    return false
  end


  local function grow_a_zone(Z)
    each A in area_list do
      if not A.zone and touches_zone(A, Z) then
        set_zone(A, Z)
        return
      end
    end
  end


  local function grow_pass()
    rand.shuffle(zone_list)
    rand.shuffle(area_list)

    each Z in zone_list do
      -- grow at full speed upto minimum size, then grow at slower rates
      if Z.num_areas < MIN_AREAS or rand.odds(Z.grow_rate) then
        grow_a_zone(Z)
      end
    end
  end


  local function grow_all_zones()
    for loop = 1,9999 do
      grow_pass()
      grow_pass()
      grow_pass()

      if check_finished() then
        return
      end
    end

    error("Failed to grow zones")
  end


  local function merge_zones(old_Z, Z)

stderrf("** Merging too-small zone %s --> %s\n", old_Z.name, Z.name)

    Z.svolume = Z.svolume + old_Z.svolume

    each A in area_list do
      if A.zone == old_Z then
         A.zone = Z
         Z.num_areas = Z.num_areas + 1
      end
    end

    old_Z.id = "DEAD"
    old_Z.name = "DEAD"
    old_Z.num_areas = -1
    old_Z.rooms = nil
    old_Z.svolume = nil
  end


  local function merge_the_runts()
    -- handle zones that end up too small

    table.sort(LEVEL.zones,
        function(Z1, Z2)
          if Z1.num_areas != Z2.num_areas then
            return Z1.num_areas > Z2.num_areas
          else
            return Z1.id < Z2.id  -- tie breaker
          end
        end)

    -- FIXME : if first zone is undersize, merge ALL zones

    assert(LEVEL.zones[1].num_areas >= MIN_AREAS)

    for idx = #LEVEL.zones, 2, -1 do
      local Z = LEVEL.zones[idx]

      if Z.num_areas < MIN_AREAS then
        merge_zones(Z, LEVEL.zones[idx - 1])
        table.remove(LEVEL.zones, idx)
      end
    end
  end


  local function border_pass()
    rand.shuffle(area_list)

    local changes = false

    each B in area_list do
      if B.zone then continue end

      each N in B.neighbors do
        if N.zone then
          B.zone = N.zone
          changes = true
        end
      end
    end
  end


  local function process_borders()
    -- collect the border areas
    -- NOTE : svolume of zone does not include border areas
    area_list = {}

    each A in LEVEL.areas do
      if not A.zone then
        assert(A.is_boundary)

        table.insert(area_list, A)
      end
    end

    for loop = 1,100 do
      border_pass()
    end

    -- handle anything else
    each A in LEVEL.areas do
      if not A.zone then
stderrf("%s slipped through the cracks\n", A.name)
        A.zone = LEVEL.zones[1]
      end
    end
  end


  ---| Area_create_zones |---

  LEVEL.zones = {}

  rand.shuffle(RATES)

  -- collect normal areas
  area_list = {}

  each A in LEVEL.areas do
    if A.mode == "normal" then
      table.insert(area_list, A)
    end
  end

  local quota = calc_quota()

  for i = 1, quota do
    add_zone()  
  end

  zone_list = table.copy(LEVEL.zones)

  assert(#zone_list > 0)

  grow_all_zones()

  merge_the_runts()

  process_borders()
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

  if OB_CONFIG.mode == "ctf" then
    Weird_generate(W, H)
    Weird_create_areas()
  else
    Shape_create_areas()
  end

  Area_analyse_areas()

  Junction_init()
    Corner_init()

  Area_find_inner_points()

  Area_create_zones()

  -- it is essential to pick areas where zones connect
  Connect_zones_prelim()

  Room_assign_voids()
  Room_assign_hallways()

  Area_group_into_rooms()

  Room_choose_area_kinds()


  gui.printf("Seed Map:\n")
  Seed_dump_rooms()

  each R in LEVEL.rooms do
    gui.debugf("Final %s   size: %dx%d\n", R:tostr(), R.sw, R.sh)
  end
end



function Area_spread_zones()  -- OBSOLETE
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
    assert(H.ext_conns)

    -- hallways always have at least two connections
    assert(#H.ext_conns >= 2)

    each S in H.seeds do
      S.not_path = true
    end

    -- find a path between each pair of connections
    -- [ we don't need to try every possible pair ]

    for i = 1, #H.ext_conns - 1 do
      local C1 = H.ext_conns[i]
      local C2 = H.ext_conns[i + 1]

      local S1 = sel(C1.A1.room == H, C1.S1, C1.S2)
      local S2 = sel(C2.A1.room == H, C2.S1, C2.S2)

      assert(S1 and S1.room == H)
      assert(S2 and S2.room == H)

      local path = dijkstra_search(H, S1, S2)

      each S in path do
        S.not_path = nil
      end
    end

    fixup_diagonals(H)
  end


  ---| Area_prune_hallways |---

  each R in LEVEL.rooms do
    if R.is_hallway and R.kind != "stairwell" then
      prune_hallway(R)
    end
  end
end

