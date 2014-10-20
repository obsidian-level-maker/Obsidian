------------------------------------------------------------------------
--  Weird Shape Generation
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2014 Andrew Apted
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

ALLOW_CLOSED_SQUARES = true

-- lower this to make larger areas
T_BRANCH_PROB = 55


-- class POINT
--[[
    gx, gy   : grid coordinate

    neighbor : table[DIR] --> POINT

    edges : table[DIR] --> true if an edge to that neighbor

    num_edges : number

    dead : boolean  -- true if cannot make any more edges off here

    ghost : table[DIR] --> edges which were killed (dead ends)

    limit_edges : number  -- do not allow more than this
--]]

GRID = {}

GRID_W = 40
GRID_H = 40


function Weird_create_areas()
  local did_change

  local function create_points()
    GRID = table.array_2D(GRID_W, GRID_H)

    for gx = 1, GRID_W do
    for gy = 1, GRID_H do
      local P =
      {
        gx = gx,
        gy = gy,
        neighbor = {},
        edge = {},
        ghost = {},
        num_edges = 0
      }
      
      GRID[gx][gy] = P

      P.limit_edges = rand.sel(T_BRANCH_PROB, 3, 2)
    end
    end

    -- link neighbors

    for gx = 1, GRID_W do
    for gy = 1, GRID_H do
      local P = GRID[gx][gy]

      for dir = 1, 9 do
      if  dir ~= 5 then
        local nx, ny = geom.nudge(gx, gy, dir)

        if table.valid_pos(GRID, nx, ny) then
          local N = GRID[nx][ny]
          assert(N)

          P.neighbor[dir] = N
        end
      end
      end
    end
    end
  end


  local function add_edge(gx, gy, dir)
    local P = GRID[gx][gy]

    P.edge[dir] = true
    P.num_edges = P.num_edges + 1

    local N = P.neighbor[dir]
    assert(N)

    N.edge[10 - dir] = true
    N.num_edges = N.num_edges + 1
  end


  local function remove_edge(gx, gy, dir)
    local P = GRID[gx][gy]
    local N = P.neighbor[dir]
    assert(N)

    assert(P.edge[dir])
    assert(N.edge[10 - dir])

    P.edge[dir] = nil
    N.edge[10 - dir] = nil

    P.ghost[dir] = true
    N.ghost[10 - dir] = true

    P.num_edges = P.num_edges - 1
    N.num_edges = N.num_edges - 1
  end


  local function is_diagonal_blocked(P, dir)
    -- not a diagonal?
    if not (dir == 1 or dir == 3 or dir == 7 or dir == 9) then
      return false
    end

    local L_dir = geom.LEFT_45[dir]

    local N = P.neighbor[L_dir]
    if not N then return true end

    return N.edge[geom.RIGHT[dir]]
  end


  local function would_close_a_square(P, dir, N)
    if ALLOW_CLOSED_SQUARES then return false end

    for pass = 1, 2 do
      local dir2 = sel(pass == 1, geom.LEFT[dir], geom.RIGHT[dir])

      local P2 = P.neighbor[dir2]

      if P2 then
        if P.edge[dir2] and N.edge[dir2] and P2.edge[dir] then
          return true
        end
      end
    end

    return false
  end


  local function eval_edge_at_point(P, dir)
    -- returns < 0 if impossible, score > 0 if possible

    local N = P.neighbor[dir]

    if not N then return -1 end
    if N.dead then return -1 end

    -- already an edge there?
    if P.edge[dir] then return -1 end

    -- ensure it does not cross another diagonal
    if is_diagonal_blocked(P, dir) then return -1 end

    -- rule # 1 : no more than 3 edges at any point
    if P.num_edges >= P.limit_edges then return -1 end
    if N.num_edges >= N.limit_edges then return -1 end

    -- rule # 2 : never make sharp (45-degree) angles
    local L_dir = geom. LEFT_45[dir]
    local R_dir = geom.RIGHT_45[dir]

    if P.edge[L_dir] or P.edge[R_dir] then return -1 end
    
    if N.edge[10 - L_dir] or N.edge[10 - R_dir] then return -1 end

    if would_close_a_square(P, dir, N) then return -1 end

    if P.no_diagonals or N.no_diagonals then
      if dir == 1 or dir == 3 or dir == 7 or dir == 9 then return -1 end
    end

    if P.no_straights or N.no_straights then
      if dir == 2 or dir == 4 or dir == 6 or dir == 8 then return -1 end
    end

    -- OK --

    return 1
  end


  local function try_edge_at_point(P)
    assert(not P.dead)

    local tab = {}

    for dir = 1, 9 do
    if  dir ~= 5 then
      local score = eval_edge_at_point(P, dir)

      if score > 0 then
        tab[dir] = score
      end
    end
    end

    -- nothing was possible
    if table.empty(tab) then
      P.dead = true
      return nil
    end

    local dir = rand.key_by_probs(tab)

    add_edge(P.gx, P.gy, dir)

    -- indicate success by returning neighbor
    return P.neighbor[dir]
  end


  local function try_add_edge()
    local points = {}

    for gx = 1, GRID_W do
    for gy = 1, GRID_H do
      local P = GRID[gx][gy]

      if P.num_edges > 0 and P.num_edges < 3 and not P.dead then
        table.insert(points, P)
      end
    end
    end

  --- print("active_points", #points)

    if table.empty(points) then
      return
    end

    local P = rand.pick(points)

    -- keep going until hit dead end or shape joins back onto itself

    repeat
      P = try_edge_at_point(P)
    until not (P and P.num_edges == 0)
  end


  local function remove_dud_point(P)
    for dir = 1, 9 do
    if  dir ~= 5 then
      if P.edge[dir] then
        remove_edge(P.gx, P.gy, dir)
      end
    end
    end
  end


  local function remove_dead_ends()
    local found = false

    for gx = 1, GRID_W do
    for gy = 1, GRID_H do
      local P = GRID[gx][gy]

      if P.num_edges == 1 then
        found = true

        remove_dud_point(P)
      end
    end
    end

    return found
  end


  local function check_point_is_staircase(P)
    -- NOTE: only finds outie corners which can be diagonalized

    if P.num_edges ~= 2 then return false end

    if P.edge[1] or P.edge[3] or P.edge[7] or P.edge[9] then return false end

    if P.edge[4] and P.edge[6] then return false end
    if P.edge[2] and P.edge[8] then return false end

  --[[
    -- skip this point if a connected neighbor point is a staircase
    for dir = 1, 9 do
    if  dir ~= 5 then
      if P.edge[dir] and P.neighbor[dir].is_staircase then
        return false
      end
    end
    end
  --]]


    local x_dir = sel(P.edge[4], 4, 6)
    local y_dir = sel(P.edge[2], 2, 8)

    assert(P.edge[x_dir])
    assert(P.edge[y_dir])

    local NX = P.neighbor[x_dir]
    local NY = P.neighbor[y_dir]

    assert(NX and NY)

    -- diagonal direction from NX 
    local corner
    if x_dir == 4 then
      corner = sel(y_dir == 2, 3, 9)
    else
      corner = sel(y_dir == 2, 1, 7)
    end

    -- check for sharp angles (< 90) at these neighbor points

    if NX.edge[y_dir] or NY.edge[x_dir] then return false end

    return true
  end


  local function find_staircases()
    for gx = 1, GRID_W do
    for gy = 1, GRID_H do
      local P = GRID[gx][gy]

      P.is_staircase = check_point_is_staircase(P)
    end
    end
  end


  local function add_initial_edge()
    local ix = GRID_W / 2
    local iy = GRID_H / 2

    local P = GRID[ix][iy]
    local N = P.neighbor[6]

    -- disable edge limits (in case both end up as zero)
    P.limit_edges = 3
    N.limit_edges = 3

    add_edge(P.gx, P.gy, 6)
  end


  local function set_border(S, dir)
    S.border[dir] = { kind="area" }
  end


  local function convert_to_seeds()
    for gx = 1, GRID_W - 1 do
    for gy = 1, GRID_H - 1 do
      local S = SEEDS[gx][gy]

      local P1 = GRID[gx][gy]
      local P2 = GRID[gx][gy + 1]
      local P3 = GRID[gx + 1][gy]

      if P1.edge[9] or P2.edge[3] then
        S.diagonal = sel(P1.edge[9], 1, 3)

        local S2 = Seed_create(S.sx, S.sy)

        S2.diagonal = S.diagonal

        S2.x1 = S.x1 ; S2.y1 = S.y1
        S2.x2 = S.x2 ; S2.y2 = S.y2

        S2.edge_of_map = S.edge_of_map

        -- link fake seed with real one
        S.top = S2
        S2.bottom = S
      
        -- check borders

        if S.diagonal == 1 then
          set_border(S, 7)
          set_border(S2, 3)
        else
          set_border(S, 9)
          set_border(S2, 1)
        end

        local T2, T4, T6, T8

        T2 = S ; T8 = S2
        T4 = S ; T6 = S2

        if S.diagonal == 1 then
          T4, T6 = T6, T4
        end

        if P1.edge[8] then set_border(T4, 4) end
        if P3.edge[8] then set_border(T6, 6) end

        if P1.edge[6] then set_border(T2, 2) end
        if P2.edge[6] then set_border(T8, 8) end

      else
        -- normal square seed

        if P1.edge[8] then set_border(S, 4) end
        if P3.edge[8] then set_border(S, 6) end

        if P1.edge[6] then set_border(S, 2) end
        if P2.edge[6] then set_border(S, 8) end
      end

    end -- gx, gy
    end
  end


  -- FIXME : setup 'border' from edge info !!!!


  local function squarify_seed(S)
    S.diagonal = nil
    S.top = nil
  end


  local function assign_area_numbers()
    local area_num = 1

    for sx = 1, SEED_W do
    for sy = 1, SEED_H do
      local S = SEEDS[sx][sy]

      S.area_num = area_num

      if S.top then S.top = area_num + 1 end

      area_num = area_num + 2
    end -- sx, sy
    end
  end


  local function flood_check_pair(S, dir)
    if not S then return end

    -- blocked by an edge, cannot flood across it
    if S.border[dir] then return end

    local N = S:diag_neighbor(dir)

    if not N or N == "nodir" then return end

    -- already the same?
    if S.area_num == N.area_num then return end

    local new_num = math.min(S.area_num, N.area_num)

    S.area_num = new_num
    N.area_num = new_num
  end


  local function flood_fill_pass()
    for sx = 1, SEED_W do
    for sy = 1, SEED_H do
      local S  = SEEDS[sx][sy]
      local S2 = S.top

      for dir = 1, 9 do
        flood_check_pair(S,  dir)
        flood_check_pair(S2, dir)
      end

    end
    end
  end


  local function check_squarify_seeds()
    -- detects when a diagonal seed has same area on each half
  -- FIXME
      if S.diagonal and S.top.area_num == S.area_num then
        squarify_seed(S)
      end
  end


  local function area_for_number(num)
    local area = LEVEL.temp_area_map[num]

    if not area then
      area =
      {
        id = Plan_alloc_id("weird_area")
      }

      LEVEL.temp_area_map[num] = area
    end

    return area
  end


  local function create_the_areas()
    LEVEL.temp_area_map = {}

    for sx = 1, SEED_W do
    for sy = 1, SEED_H do
      local S  = SEEDS[sx][sy]
      local S2 = S.top

      S.area = area_for_number(S.area_num)

      if S2 then S2.area = area_for_number(S2.area_num) end
    end
    end

    LEVEL.temp_area_map = nil
  end


  local function flood_fill_areas()
    assign_area_numbers()

    repeat
      did_change = false
      flood_fill_pass()
    until not did_change

    create_the_areas()
  end


  ---| Weird_create_areas |---

  create_points()

  -- this gets the ball rolling
  add_initial_edge()

  for pass = 1, 2 do
    for loop = 1, GRID_W * GRID_H * 2 do
      try_add_edge()
    end

    while remove_dead_ends() do end
  end

  find_staircases()

  convert_to_seeds()

  flood_fill_areas()
end



function Weird_group_areas()
  --
  -- This actually creates the rooms by grouping a bunch of areas together.
  --


  ---| Weird_group_areas |---

  -- TODO
end



function Weird_create_rooms()

  gui.printf("\n--==| Planning WEIRD Rooms |==--\n\n")

  assert(LEVEL.ep_along)

  LEVEL.areas = {}
  LEVEL.rooms = {}
  LEVEL.conns = {}

  LEVEL.scenic_rooms = {}
  LEVEL.map_borders  = {}

  LEVEL.free_tag  = 1
  LEVEL.free_mark = 1
  LEVEL.ids = {}

  Plan_choose_liquid()
  Plan_choose_darkness()


--TODO  Weird_determine_size()

  Seed_init(GRID_W - 1, GRID_H - 1, 0, DEPOT_SEEDS)


  Weird_create_areas()

  Weird_group_areas()

--TODO  Weird_decide_outdoors()


  gui.printf("Seed Map:\n")
  Seed_dump_rooms()

  each R in LEVEL.rooms do
    gui.printf("Final %s   size: %dx%d\n", R:tostr(), R.sw, R.sh)
  end
end

