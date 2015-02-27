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
  prob = 10

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
  prob = 50

  structure =
  {
    "11"
    "11"
  }
}


GENERIC_2x2_diamond =
{
  prob = 30

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

ROOM_RECT_3x2 =
{
  prob = 50
  initial_prob = 50

  structure =
  {
    "111"
    "111"
  }
}

ROOM_RECT_3x3 =
{
  prob = 50
  initial_prob = 50

  structure =
  {
    "111"
    "111"
    "111"
  }
}

ROOM_RECT_4x2 =
{
  prob = 50
  initial_prob = 50

  structure =
  {
    "1111"
    "1111"
  }
}

ROOM_O_3x3 =
{
  prob = 50
  initial_prob = 50

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

ROOM_L_4x4 =
{
  prob = 50
  initial_prob = 50

  structure =
  {
    "11.."
    "11.."
    "1111"
    "1111"
  }
}

ROOM_O_4x3 =
{
  prob = 50
  initial_prob = 50

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

ROOM_OL_4x4 =
{
  prob = 10
  initial_prob = 100

  structure =
  {
    "/1%2"
    "1112"
    "%1/2"
    "222/"
  }

  diagonals =
  {
    ".1", "1."
    ".1", "12"
    "2."
  }
}

ROOM_U_5x3 =
{
  initial_prob = 20

  structure =
  {
    "12.21"
    "12221"
    "11111"
  }
}

ROOM_OU_4x5 =
{
  prob = 10
  initial_prob = 100

  structure =
  {
    "222%"
    "/1%2"
    "1112"
    "%1/2"
    "222/"
  }

  diagonals =
  {
    "2.",
    "21", "12"
    "21", "12"
    "2."
  }
}

ROOM_PLUS_3x3 =
{
  prob = 25

  structure =
  {
    ".1."
    "111"
    ".1."
  }
}

ROOM_DONUT_6x6 =
{
  initial_prob = 4

  structure =
  {
    "/1111%"
    "1/..%1"
    "1....1"
    "1....1"
    "1%../1"
    "%1111/"
  }

  diagonals =
  {
    ".1", "1."
    "1.", ".1"
    "1.", ".1"
    ".1", "1."
  }
}


--
-- Hallways
--

HALL_I_4x1 =
{
  prob = 25

  structure =
  {
    "1111"
  }
}

HALL_L_3x3 =
{
  prob = 25

  structure =
  {
    "1.."
    "1.."
    "111"
  }
}

HALL_L_3x3_rounded =
{
  prob = 25

  structure =
  {
    "1.."
    "1%."
    "%11"
  }

  diagonals =
  {
    "1."
    ".1"
  }
}

HALL_T_3x3 =
{
  prob = 25

  structure =
  {
    "111"
    ".1."
    ".1."
  }
}

HALL_L_5x3 =
{
  prob = 25

  structure =
  {
    "111.."
    "..1.."
    "..111"
  }
}

HALL_S_6x3 =
{
  prob = 25

  structure =
  {
    ".../11"
    "..//.."
    "11/..."
  }

  diagonals =
  {
    ".1"
    ".1", "1."
    "1."
  }
}


-- end of SHAPES
}



function Shape_save_svg()

  -- grid size
  local SIZE = 14

  local TOP  = (SEED_H + 1) * SIZE

  local fp


  local function wr_line(fp, x1, y1, x2, y2, color, width)
    fp:write(string.format('<line x1="%d" y1="%d" x2="%d" y2="%d" stroke="%s" stroke-width="%d" />\n',
             10 + x1, TOP - y1, 10 + x2, TOP - y2, color, width or 1))
  end

  local function visit_seed(A1, S1, dir)
    local S2 = S1:neighbor(dir, "NODIR")

    if S2 == "NODIR" then return end

    local A2 = S2 and S2.area

    if A1 == A2 then return end

    -- only draw the edge once
    if A2 and A2.id < A1.id then return end

    local color = "#00f"

    if A1.prefer_mode == "hallway" or (A2 and A2.prefer_mode == "hallway") then
      color = "#f00"
    elseif A2 and A1.is_boundary != A2.is_boundary then
      color = "#0f0"
    elseif A1.prefer_mode == "void" and (A2 and A2.prefer_mode == "void") then
      color = "#666"
    elseif not A2 then
      color = "#666"
    end

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

  local cur_def


  local function add_element(E)
    if E.kind != "area" then return end

    if cur_def.area_list[E.area] then return end

    cur_def.area_list[E.area] = { area=E.area }
  end


  local function do_parse_element(ch)
    if ch == '.' then return { kind="empty" } end

    if ch == '1' then return { kind="area", area=1 } end
    if ch == '2' then return { kind="area", area=2 } end
    if ch == '3' then return { kind="area", area=3 } end
    if ch == '4' then return { kind="area", area=4 } end

    if ch == '5' then return { kind="area", area=5 } end
    if ch == '6' then return { kind="area", area=6 } end
    if ch == '7' then return { kind="area", area=7 } end
    if ch == '8' then return { kind="area", area=8 } end

    error("Shape_parse_char: unknown symbol: " .. tostring(ch))
  end


  local function parse_element(ch)
    local E = do_parse_element(ch)

    add_element(E)

    return E
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

      return { kind="diagonal", diagonal=diagonal, bottom=R, top=L }
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
      def  = def
      grid = grid
    }

    return INFO
  end


  ---| Shape_preprocess_patterns |---

  table.name_up(SHAPES)

  table.expand_copies(SHAPES)

  each name,def in SHAPES do
    cur_def = def

    def.area_list = {}
    def.processed = {}

    def.processed[1] = convert_structure(def, def.structure)

    if string.match(name, "HALL") then
      def.mode = "hallway"
    end
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
  -- Builds the bulk of the traversible map by placing predefined
  -- shapes onto it.
  --

  local area_map

  
  local function create_areas_for_shape(def)
    area_map = {}

    for i = 1, #def.area_list do
      local area = AREA_CLASS.new("normal")

      if def.mode == "hallway" then
        area.prefer_mode = "hallway"
      else
        area.prefer_mode = "room"
      end

      area_map[i] = area
    end
  end


  local function transform_coord(info, T, px, py)
    if T.mirror_x then px = info.grid.w + 1 - px end
    if T.mirror_y then py = info.grid.h + 1 - py end

    if T.transpose then px, py = py, px end

    local sx = T.x + (px - 1)
    local sy = T.y + (py - 1)

    return sx, sy
  end


  local function transform_diagonal(T, dir, bottom, top)
    if T.mirror_x then
      dir = geom.MIRROR_X[dir]
    end

    if T.mirror_y then
      dir = geom.MIRROR_Y[dir]
      top, bottom = bottom, top
    end

    if T.transpose then
      if dir == 3 or dir == 7 then
        dir = 10 - dir
        top, bottom = bottom, top
      end
    end

    return dir, bottom, top
  end


  local function install_half_seed(S, elem)
    if elem.kind != "area" then
      error("Unknown element kind in shape")
    end

    local A = area_map[elem.area]
    assert(A)

    assert(S.area == nil)

    S.area = A
    table.insert(A.seeds, S)
  end


  local function test_or_install_element(info, elem, T, px, py, mode)
    if elem.kind == "empty" then return true end

    local sx, sy = transform_coord(info, T, px, py)

    -- never allow shapes to touch edge of map
    if sx <= 1 or sx >= (SEED_W - 1) then return false end
    if sy <= 1 or sy >= (SEED_H - 1) then return false end

    local S = SEEDS[sx][sy]

    -- hallway test : prevent them touching
    if info.def.mode == "hallway" and S.no_hall then
      return false
    end

    if elem.kind == "diagonal" then

      -- whole seed is used?
      if (not S.diagonal) and S.area then return false end

      local dir, E1, E2 = transform_diagonal(T, elem.diagonal, elem.bottom, elem.top)

      -- mismatched diagonal?
      if S.diagonal and not (S.diagonal == dir or S.diagonal == (10-dir)) then
        return false
      end

      -- seed on map is a full square?
      if not S.diagonal then
        if S.area then return false end

        if mode == "test" then return true end

        -- need to split the seed to install this element
        S:split(math.min(dir, 10 - dir))
      end

      local S1 = S
      local S2 = S.top

      for pass = 1, 2 do
        if E1.kind != "empty" then

          -- used?
          if S1.area then return false end

          if mode == "install" then
        install_half_seed(S1, E1)
          end

        end

        -- swap for other side
        dir = 10 - dir
        E1, E2 = E2, E1
        S1, S2 = S2, S1
      end

      return true

    else  --- full square seed ---

      -- used?
      if S.area     then return false end
      if S.diagonal then return false end

      if mode == "install" then
        install_half_seed(S, elem)
      end

      return true
    end
  end


  local function mark_hallway(info, T)
    local W = info.grid.w
    local H = info.grid.h

    -- mark two extra seeds around bbox of shape
    -- [ allow space for making a room in-between ]

    for px = -1, W + 2 do
    for py = -1, H + 2 do
      local sx, sy = transform_coord(info, T, px, py)

      if Seed_valid(sx, sy) then
        SEEDS[sx][sy].no_hall = true
      end
    end -- px, py
    end
  end


  local function try_add_shape_RAW(info, T, mode)
    assert(mode)

-- DEBUG
if mode == "install" then
--stderrf("Installing shape '%s' @ (%d %d)\n", info.def.name, T.x, T.y)
end

    local W = info.grid.w
    local H = info.grid.h

    if mode == "install" then
      create_areas_for_shape(info.def)
    end

    for px = 1, W do
    for py = 1, H do
      local elem = info.grid[px][py]
      assert(elem)

      local res = test_or_install_element(info, elem, T, px, py, mode)

      if mode == "test" and not res then
        -- cannot place this shape here (something in the way)
        return false
      end
    end -- px, py
    end

    -- hallways : mark seeds to prevent touching another hallway
    if mode == "install" and info.def.mode == "hallway" then
      mark_hallway(info, T)
    end

    return true
  end


  local function try_add_shape(def, sx, sy, DIST)
    local info = def.processed[1]

    for dist = 0, DIST do
      local x1 = math.clamp(3, sx - dist, SEED_W - 4)
      local x2 = math.clamp(3, sx + dist, SEED_W - 4)

      local y1 = math.clamp(3, sy - dist, SEED_H - 4)
      local y2 = math.clamp(3, sy + dist, SEED_H - 4)

      for x = x1, x2 do
      for y = y1, y2 do
        -- only need to visit the sides of the bbox
        if not (x == x1 or x == x2 or y == y1 or y == y2) then
          continue
        end

        local best_T

        for transpose = 0, 0 do
        for mirror_x  = 0, 0 do
        for mirror_y  = 0, 0 do
          local score = gui.random()

          -- early out
          if best_T and score < best_T.score then continue end

          local T =
          {
            x = x
            y = y
            transpose = (transpose > 0)
            mirror_x  = (mirror_x > 0)
            mirror_y  = (mirror_y > 0)
            score     = score
          }

          if try_add_shape_RAW(info, T, "test") then
            best_T = T
          end
        end -- transpose, mirror_x, mirror_y
        end
        end

        if best_T then
          try_add_shape_RAW(info, best_T, "install")
          return true  -- OK
        end

      end  -- x, y
      end
    end -- dist

    -- failed
    return false
  end


  local function add_shape_from_list(tab, sx, sy, attempts, DIST)
    DIST = DIST or 5

    for loop = 1, attempts do
      local name = rand.key_by_probs(tab)
      local def  = assert(SHAPES[name])

      if try_add_shape(def, sx, sy, DIST) then
        return true
      end
    end

    return false
  end


  local function collect_usable_shapes(mode)
    -- mode can be "initial", "hallway" or "normal"

    local tab = {}

    each name, def in SHAPES do
      local prob = def.prob or 0

      if (mode == "hallway") != (def.mode == "hallway") then
        continue
      end

      if mode == "initial" then
        prob = def.initial_prob or 0
      end

      if prob > 0 then
        tab[name] = prob
      end
    end

    return tab
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
    local initial_tab = collect_usable_shapes("initial")

    local LOCS = { 1,2,3, 4,5,6, 7,8,9 }

    -- on small maps, have less initial locations
    if SEED_W < 32 then
      LOCS = { 1,3,5,7,9 }
    end

    each loc in rand.shuffle(LOCS) do
      local sx, sy = loc_to_seed(loc)

      add_shape_from_list(initial_tab, sx, sy, 10)
    end
  end


  local function add_hallways()
    local hallway_tab = collect_usable_shapes("hallway")

    local LOCS = { 1,2,3, 4,5,6, 7,8,9 }

    if SEED_W < 32 then
      LOCS = { 2,4,5,6,8 }
    end

    local prob = 99

    each loc in rand.shuffle(LOCS) do
      if rand.odds(prob) then
        local sx, sy = loc_to_seed(loc)
        add_shape_from_list(hallway_tab, sx, sy, 3, 10)
      end
    end
  end


  local function add_rooms()
    local room_tab = collect_usable_shapes("normal")

    local count = int(SEED_W * SEED_H / 40)

    for i = 1, count do
      local sx = rand.irange(LEVEL.boundary_sx1, LEVEL.boundary_sx2)
      local sy = rand.irange(LEVEL.boundary_sy1, LEVEL.boundary_sy2)

      add_shape_from_list(room_tab, sx, sy, 1)
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
      id = alloc_id("temp_area")
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
    -- merges A2 into A1 (killing A2)

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

      if S  and S .temp_area == A2 then S .temp_area = A1 end
      if S2 and S2.temp_area == A2 then S2.temp_area = A1 end
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

--???    -- a preference to merging across diagonals
--???    local power = 1 sel(geom.is_corner(dir), 1, 2)

    return score + gui.random()
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


  local function detect_sharp_poker(S, dir)
    -- returns true or false.
    -- when true, also returns 'a', 'b', 'c', 'd' areas

    if not S.diagonal then return false end

    local S2 = assert(S.top)

    local T1 = S .temp_area
    local T2 = S2.temp_area

    local a, b, c, d, e, a2
    local Na, Nc, Nd, Ne

    if not (T1 and T2) then return false end
    if T1 == T2 then return false end


    if dir == 2 then
      a = T2
      b = T1

      Na = S :neighbor(2)
      Nc = S2:neighbor(8)
      Nd = S :neighbor(sel(S.diagonal == 1, 4, 6))
      Ne = S2:neighbor(sel(S.diagonal == 1, 6, 4))
    
    elseif dir == 8 then

      a = T1
      b = T2

      Na = S2:neighbor(8)
      Nc = S :neighbor(2)
      Nd = S2:neighbor(sel(S.diagonal == 1, 6, 4))
      Ne = S :neighbor(sel(S.diagonal == 1, 4, 6))

    elseif dir == 4 then

      a = sel(S.diagonal == 1, T2, T1)
      b = sel(S.diagonal == 1, T1, T2)

      Na = sel(S.diagonal == 1, S:neighbor(4), S2:neighbor(4))
      Nc = sel(S.diagonal == 1, S2:neighbor(6), S:neighbor(6))
      Nd = sel(S.diagonal == 1, S:neighbor(2), S2:neighbor(6))
      Ne = sel(S.diagonal == 1, S2:neighbor(8), S:neighbor(2))

    elseif dir == 6 then

      a = sel(S.diagonal == 1, T1, T2)
      b = sel(S.diagonal == 1, T2, T1)

      Na = sel(S.diagonal == 1, S2:neighbor(6), S:neighbor(6))
      Nc = sel(S.diagonal == 1, S:neighbor(4), S2:neighbor(4))
      Nd = sel(S.diagonal == 1, S2:neighbor(8), S:neighbor(2))
      Ne = sel(S.diagonal == 1, S:neighbor(2), S2:neighbor(6))

    else

      error("Unknown dir in detect_sharp_poker")
    end


    a2 = Na and Na.temp_area
    c  = Nc and Nc.temp_area
    d  = Nd and Nd.temp_area
    e  = Ne and Ne.temp_area

--[[ DEBUG
stderrf("a/b/a @ %s : %d %d / %d %d %d\n", S:tostr(),
(a and a.id) or -1, (b and b.id) or -1,
(c and c.id) or -1, (d and d.id) or -1, (e and e.id) or -1)
--]]

    if a2 != a then return false end

    return true, a, b, c, d, e
  end


  local function flip_at_seed(S1, dir)
    local S2 = S1.top

    S1.diagonal = geom.MIRROR_X[S1.diagonal]
    S2.diagonal = geom.MIRROR_X[S2.diagonal]

    if geom.is_vert(dir) then
      local T1 = S1.temp_area
      local T2 = S2.temp_area

      S1.temp_area = T2
      S2.temp_area = T1

      table.kill_elem(T1.seeds, S1)
      table.kill_elem(T2.seeds, S2)

      table.insert(T1.seeds, S2)
      table.insert(T2.seeds, S1)
    end

stderrf("\n********  FLIPPED @ %s\n", S1:tostr())
  end


  local function try_flip_at_seed(S)
    for dir = 2,8,2 do
      local res, a, b, c, d, e = detect_sharp_poker(S, dir)

      if res and b == d and a == e and c != a then
        flip_at_seed(S, dir)
        return true
      end
    end

    return false
  end


  local function smooth_at_seed(S1, a, b)
    -- need to merge areas if close to minimum size
    if math.min(a.svolume, b.svolume) < MIN_SIZE + 2 then
      perform_merge(a, b)
      return
    end

    local S2 = S1.top

    if S1.temp_area != b then
      S1, S2 = S2, S1
    end

    assert(S1.temp_area == b)
    assert(S2.temp_area == a)

    -- we remove 'b' from the seed (give ownership to 'a')
    S1.temp_area = a

    table.kill_elem(b.seeds, S1)
    table.insert(a.seeds, S1)
  end


  local function try_smooth_at_seed(S)
    for dir = 2,8,2 do
      local res, a, b, c, d, e = detect_sharp_poker(S, dir)

      if res then
        smooth_at_seed(S, a, b)
        return true
      end
    end

    return false
  end


  local function smoothen_out_pokers()
    -- first pass : detect diagonals we can flip --
    
    for sx = 1, SEED_W do
    for sy = 1, SEED_H do
      try_flip_at_seed(SEEDS[sx][sy])
    end
    end

    -- second pass : handle the rest --

    for pass = 1, 3 do
      for sx = 1, SEED_W do
      for sy = 1, SEED_H do
        try_smooth_at_seed(SEEDS[sx][sy])
      end
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

  for loop = 1,20 do
    merge_temp_areas()
  end

  smoothen_out_pokers()

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

