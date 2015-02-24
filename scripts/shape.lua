------------------------------------------------------------------------
--  SHAPE SYSTEM
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2015 Andrew Apted
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


SHAPES =
{
 
--
-- Generic ones, mainly for stairwells
--

GENERIC_1x2 =
{
  prob = 30

  structure =
  {
    "11"
  }
}


GENERIC_1x3 =
{
  prob = 10

  structure =
  {
    "111"
  }
}


GENERIC_2x2 =
{
  prob = 100

  initial_prob = 10

  structure =
  {
    "11"
    "11"
  }
}


GENERIC_2x2_diamond =
{
  prob = 100

  initial_prob = 10

  structure =
  {
    "/%"
    "%/"
  }

  diagonals =
  {
    ".1", "1."
    ".1", "1."
  }
}


--
-- Rooms
--

ROOM_O_3x3 =
{
  prob = 100

  initial_prob = 100

  structure =
  {
    "/1%"
    "111"
    "%1/"
  }

  diagonals =
  {
    ".1", "1."
    ".1", "1."
  }
}

ROOM_O_4x3 =
{
  prob = 80

  initial_prob = 80

  structure =
  {
    "/11%"
    "1111"
    "%11/"
  }

  diagonals =
  {
    ".1", "1."
    ".1", "1."
  }
}


--
-- Hallways
--

HALL_L_3x3_rounded =
{
  mode = "hallway"

  prob = 25

  structure =
  {
    "1.."
    "1%."
    "%11"
  }

  diagonals =
  {
    "1.", ".1"
  }
}


-- end of SHAPES
}



function Shape_save_svg()

  -- grid size
  local SIZE = 14

  local fp


  local function wr_line(fp, x1, y1, x2, y2, color, width)
    fp:write(string.format('<line x1="%d" y1="%d" x2="%d" y2="%d" stroke="%s" stroke-width="%d" />\n',
             x1, y1, x2, y2, color, width or 1))
  end

  local function visit_seed(A1, S1, dir)
    local S2 = S1:neighbor(dir)

    if not (S2 and S2.area) then return end

    local A2 = S2.area

    if A2 == A1 then return end

    local color = "#00f"
    if A1.is_boundary != A2.is_boundary then color = "#0f0" end

    local sx1, sy1 = S1.sx, S1.sy
    local sx2, sy2 = sx1 + 1, sy1 + 1

    if dir == 3 or dir == 7 then
      -- no change

    elseif dir == 1 or dir == 9 then
      sy1, sy2 = sy2, sy1

    elseif dir == 2 then sy2 = sy1
    elseif dir == 8 then sy1 = sy2
    elseif dir == 4 then sx2 = sx1
    elseif dir == 6 then sx1 = sx2
    else
      error("uhhh what")
    end

    wr_line(fp, (sx1 - 1) * SIZE, (sy1 - 1) * SIZE,
                (sx2 - 1) * SIZE, (sy2 - 1) * SIZE, color, 2)
  end


  ---| Shape_save_svg |---

  local filename = "shape_" .. LEVEL.name .. ".svg"

  fp = io.open(filename, "w")

  if not fp then error("Cannot create file") end

  -- header
  fp:write('<?xml version="1.0" encoding="UTF-8" standalone="no"?>')
  fp:write('<svg xmlns="http://www.w3.org/2000/svg" version="1.1">\n')

  -- grid
  local min_x = 1 * SIZE
  local min_y = 1 * SIZE

  local max_x = SEED_W * SIZE
  local max_y = SEED_H * SIZE

  for x = 1, SEED_W do
    wr_line(fp, x * SIZE, SIZE, x * SIZE, max_y, "#bbb")
  end

  for y = 1, SEED_H do
    wr_line(fp, SIZE, y * SIZE, max_x, y * SIZE, "#bbb")
  end

  -- edges
  each A in LEVEL.areas do
  each S in A.seeds do
  each dir in geom.ALL_DIRS do
    visit_seed(A, S, dir)
  end
  end
  end
  
  -- end
  fp:write('</svg>\n')

  fp:close()
end



function Shape_preprocess_patterns()


  local function parse_element(ch)
    if ch == '.' then return { kind="empty" } end

    if ch == '1' then return { kind="area", area=1 } end
    if ch == '2' then return { kind="area", area=2 } end
    if ch == '3' then return { kind="area", area=3 } end
    if ch == '4' then return { kind="area", area=4 } end
    if ch == '5' then return { kind="area", area=5 } end
    if ch == '6' then return { kind="area", area=6 } end
    if ch == '7' then return { kind="area", area=7 } end
    if ch == '8' then return { kind="area", area=8 } end
    if ch == '9' then return { kind="area", area=9 } end

    error("Shape_parse_char: unknown symbol: " .. tostring(ch))
  end


  local function parse_char(ch, diag_list)
    -- handle diagonal seeds
    if ch == '/' or ch == '%' then
      local D = table.remove(diag_list, 1)
      if not D then
        error("Shape_parse_char: not enough diagonals")
      end

      local L = parse_element(string.sub(D, 1, 1))
      local R = parse_element(string.sub(D, 2, 2))

      local diagonal = sel(ch == '/', 3, 1)

      if ch == '/' then L,R = R,L end

      return { kind="diagonal", diagonal=diagonal, bottom=L, top=R }
    end

    return parse_element(ch)
  end


  local function convert_structure(def, structure)
    local W = #structure[1]
    local H = #structure

    local diag_list
    
    if def.diagonals then
      diag_list = table.copy(def.diagonals)
    end

    local grid = table.array_2D(W, H)

    for x = 1, W do
    for y = 1, H do
      local line = structure[y]

      if #line != W then
        error("Malformed structure in shape: " .. def.name)
      end

      local ch = string.sub(line, x, x)

      -- textural representation must be inverted
      local gy = H + 1 - y

      grid[x][gy] = parse_char(ch, diag_list)
    end -- x, y
    end

    local INFO =
    {
      grid = grid
    }

    return INFO
  end


  ---| Shape_preprocess_patterns |---

  table.name_up(SHAPES)

  table.expand_copies(SHAPES)

  each name,def in SHAPES do
    def.elements = {}
    def.processed = {}

    def.processed[1] = convert_structure(def, def.structure)
  end
end



function Shape_prepare()
  --
  -- decide boundary rectangle, etc...
  --

  local map_size = (SEED_W + SEED_H) / 2

  if map_size < 26 then
    LEVEL.boundary_margin = 4
  elseif map_size < 36 then
    LEVEL.boundary_margin = 5
  else
    LEVEL.boundary_margin = 6
  end

  LEVEL.boundary_sx1 = LEVEL.boundary_margin
  LEVEL.boundary_sx2 = SEED_W + 1 - LEVEL.boundary_margin

  LEVEL.boundary_sy1 = LEVEL.boundary_margin
  LEVEL.boundary_sy2 = SEED_H + 1 - LEVEL.boundary_margin

  Shape_preprocess_patterns()
end



function Shape_add_shapes()
  --
  -- Picks shapes from the SHAPES table and tries to place them on
  -- the map.
  --
  -- Firstly we place a few "initial" shapes in fairly fixed locations,
  -- then subsequent shapes will extend onto the existing ones.
  --

  
  local function try_add_shape_RAW(def, sx, sy, rot)
    -- TODO
  end


  local function try_add_shape(def, sx, sy)
    for dist = 0, 9 do
      local x1 = math.clamp(3, sx - dist, SEED_W - 4)
      local x2 = math.clamp(3, sx + dist, SEED_W - 4)

      local y1 = math.clamp(3, sy - dist, SEED_H - 4)
      local y2 = math.clamp(3, sy + dist, SEED_H - 4)

      for x = x1, x2 do
      for y = y1, y2 do
        -- only edges of the box
        if not (x == x1 or x == x2 or y == y1 or y == y2) then
          continue
        end

        for rot = 0, 7 do
          if try_add_shape_RAW(def, x, y, rot) then
            return true  -- OK
          end
        end
      end  -- x, y
      end
    end -- dist

    -- failed
    return false
  end


  local function add_shape_from_list(tab, sx, sy, required)
    for loop = 1, sel(required, 2000, 5) do
      local name = rand.key_by_probs(tab)
      local def  = assert(SHAPES[name])

      if try_add_shape(def, sx, sy) then
        return true
      end
    end

    if required then
      error("Failed to add an required shape")
    end

    return false
  end


  local function collect_usable_shapes(reqs)
    local tab = {}
  end


  local function loc_to_seed(loc)
    -- loc is 1 .. 9 (like number on the numeric keypad)

    local dx, dy = geom.delta(loc)

    dx = 0.5 + dx * 0.3
    dy = 0.5 + dy * 0.3

    local sx = rand.int(SEED_W * dx - 1.5)
    local sy = rand.int(SEED_H * dy - 1.5)

    return sx, sy
  end


  local function add_initial_shapes()
    local initial_tab = collect_usable_shapes({ initial=1 })

    local LOCS = { 1,2,3, 4,5,6, 7,8,9 }

    -- on small maps, have less initial locations
    if SEED_W < 32 then
      LOCS = { 1,3,5,7,9 }
    end

    each loc in rand.shuffle(LOCS) do
      local sx, sy = loc_to_seed(loc)

      add_shape_from_list(initial_tab, sx, sy, "required")  
    end
  end


  local function add_hallways()
    local hallway_tab = collect_usable_shapes({ hallway=1 })

    local LOCS = { 1,2,3, 4,5,6, 7,8,9 }

    if SEED_W < 32 then
      LOCS = { 2,4,5,6,8 }
    end

    local prob = 50

    each loc in rand.shuffle(LOCS) do
      if rand.odds(prob) then
        local sx, sy = loc_to_seed(loc)
        add_shape_from_list(hallway_tab, sx, sy)
      end
    end
  end


  local function add_rooms()
    local room_tab = collect_usable_shapes({ room=1 })

    local count = int(SEED_W * SEED_H / 30)

    for i = 1, count do
      local sx = rand.irange(LEVEL.boundary_sx1, LEVEL.boundary_sx2)
      local sy = rand.irange(LEVEL.boundary_sy1, LEVEL.boundary_sy2)

      add_shape_from_list(room_tab, sx, sy)
    end
  end


  ---| Shape_add_shapes |---

  add_initial_shapes()

  add_hallways()

  add_rooms()
end



function Shape_fill_gaps()
  --
  -- Creates areas from all currently unused seeds (ones which have not
  -- received a shape yet).
  --
  -- Algorithm is very simple : assign a new "temp_area" to each half-seed
  -- and randomly merge them until size of all temp_areas has reached a
  -- certain threshhold.
  --

  local temp_areas = {}

  local MIN_SIZE = 4
  local MAX_SIZE = MIN_SIZE * 4


  local function new_temp_area(first_S)
    local TEMP =
    {
      svolume = 0
      seeds = { first_S }
    }

    if first_S.diagonal then
      TEMP.svolume = 0.5
    else
      TEMP.svolume = 1.0
    end

    table.insert(temp_areas, TEMP)

    return TEMP
  end


  local function create_temp_areas()
    for sx = 1, SEED_W do
    for sy = 1, SEED_H do
      local S = SEEDS[sx][sy]

      if not S.diagonal and not S.area then
        -- a whole unused seed : split into two
        S:split(rand.sel(50, 1, 3))
      end

      S2 = S.top

      if S  and not S.area  then S .temp_area = new_temp_area(S)  end
      if S2 and not S2.area then S2.temp_area = new_temp_area(S2) end
    end
    end
  end


  local function perform_merge(A1, A2)
    -- merges A2 into A1 (killing A1)

    if A2.svolume > A1.svolume then
      A1, A2 = A2, A1
    end

    A1.svolume = A1.svolume + A2.svolume

    table.append(A1.seeds, A2.seeds)

    -- fix all seeds
    for sx = 1, SEED_W do
    for sy = 1, SEED_H do
      local S = SEEDS[sx][sy]
      local S2 = S.top

      if S .temp_area == A2 then S .temp_area = A1 end
      if S2.temp_area == A2 then S2.temp_area = A1 end
    end
    end

    -- mark A2 as dead
    A2.is_dead = true
    A2.svolume = nil
    A2.seeds = nil
  end


  local function eval_merge(A1, A2, dir)
    local score = 1

---###if rand.odds(88) then return 9 + gui.random() end

    if A2.svolume < MIN_SIZE then
      score = 3
    elseif A1.svolume + A2.svolume <= MAX_SIZE then
      score = 2
    end

    -- a preference to merging across diagonals
    local power = sel(geom.is_corner(dir), 1, 2)

    return score + gui.random() ^ power
  end


  local function try_merge_an_area(A1)
    local best_A2
    local best_score = 0

    each S in A1.seeds do
    each dir in geom.ALL_DIRS do
      local N = S:neighbor(dir)

      if not (N and N.temp_area) then continue end

      local A2 = N.temp_area

      if A2 == A1 then continue end

      assert(not A2.is_dead)

      local score = eval_merge(A1, A2, dir)

      if score > best_score then
        best_A2 = A2
        best_score = score
      end
    end
    end

    if best_A2 then
      perform_merge(A1, best_A2)
    end
  end


  local function prune_dead_areas()
    for i = #temp_areas, 1, -1 do
      if temp_areas[i].is_dead then
        table.remove(temp_areas, i)
      end
    end
  end


  local function merge_temp_areas()
    rand.shuffle(temp_areas)

    each A1 in temp_areas do
      if A1.is_dead then continue end

      if A1.svolume < MIN_SIZE then
        try_merge_an_area(A1)
      end
    end

    prune_dead_areas()
  end


  local function make_real_areas()
    each T in temp_areas do
      local area = AREA_CLASS.new("normal")

      area.prefer_mode = "void"

      area.seeds = T.seeds

      -- install into seeds
      each S in area.seeds do
        S.area = area
      end
    end
  end


  ---| Shape_fill_gaps |---

  create_temp_areas()

  for loop = 1,30 do
    merge_temp_areas()
  end

  make_real_areas()

  Area_squarify_seeds()
end



function Shape_assign_boundary()

  local function area_touches_edge(A)
    each S in A.seeds do
      if S.sx == 1 or S.sx == SEED_W then return true end
      if S.sy == 1 or S.sy == SEED_H then return true end
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


  local function surr_grow_pass(seen)
    local old_seen = table.copy(seen)

    each A,_ in old_seen do
      each N in A.neighbors do
        if N.is_inner then
          seen[N] = true
        end
      end
    end
  end


  local function check_for_surrounded_areas()
    -- look for areas which have become surrounded by boundary areas
    -- (this is probably very rare, but nonetheless we should handle it).

    local largest = Area_largest_area()

    local seen = {} ; seen[largest] = true

    for loop = 1,100 do
      surr_grow_pass(seen)
    end

    each A in LEVEL.areas do
      if A.is_inner and not seen[A] then
        gui.printf("HERE IS ONE DUDE! : %s", A.name)

        A.is_inner = false
        A.is_boundary = true
        A.mode = "scenic"
      end
    end
  end


  ---| Shape_assign_boundary |---

  each A in LEVEL.areas do
    if not area_touches_edge(A) and area_is_inside_box(A) then
      A.is_inner = true
    else
      A.mode = "scenic"
      A.is_boundary = true
    end
  end

  check_for_surrounded_areas()
end



function Shape_create_areas()

  Shape_prepare()

  Shape_add_shapes()

  Shape_fill_gaps()

  Area_calc_volumes()
  Area_find_neighbors()

  Shape_assign_boundary()

  Shape_save_svg()
end

