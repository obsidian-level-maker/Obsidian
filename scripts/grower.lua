------------------------------------------------------------------------
--  SHAPE GROWING SYSTEM
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


--class SPROUT
--[[
    S    : SEED  -- where to join onto
    dir  : DIR   --

    room : ROOM  -- the room to join onto

    rank         -- rank number
--]]


function Sprout_new(S, dir, room, rank)
  local P =
  {
    S = S
    dir = dir
    room = room
    rank = rank
  }

  table.insert(LEVEL.sprouts, P)

  return P
end


function Sprout_pick_next()
  if table.empty(LEVEL.sprouts) then
    return nil
  end

  local best
  local best_score = 0

  each P in LEVEL.sprouts do
    local score = P.rank * 10
    if P.room.kind == "hallway" then
      score = score - 5
    end

    score = score + gui.random()

    if score > best_score then
      best = P
      best_score = score
    end
  end

  assert(best)

  -- remove it from global list
  table.kill_elem(LEVEL.sprouts, P)

  return P
end


function Sprout_kill_room(R)
  for i = #LEVEL.sprouts, 1, -1 do
    local P = LEVEL.sprouts[i]

    if P.room == R then
      table.remove(LEVEL.sprouts, i)
      P.S = nil ; P.dir = nil
    end
  end
end


------------------------------------------------------------------------

old__SHAPES__old =
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
  prob = 100

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
  prob = 100
  initial_prob = 100

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

ROOM_U_5x3_B =
{
  initial_prob = 30

  structure =
  {
    ".222."
    "12221"
    "11111"
  }
}

ROOM_OU_4x5 =
{
  prob = 10
  initial_prob = 50

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
    ".1", "12"
    ".1", "12"
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

  good_conns =
  {
    { x=2, y=1, dir=2 }
    { x=1, y=2, dir=4 }
    { x=3, y=2, dir=6 }
    { x=2, y=3, dir=8 }
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
  prob = 20

  structure =
  {
    "1111"
  }

  stair_spots =
  {
    { x=2, y=1, dir=6 }
    { x=3, y=1, dir=6 }
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

  good_conns =
  {
    { x=1, y=3, dir=8 }
    { x=3, y=1, dir=6 }
  }

  stair_spots =
  {
    { x=1, y=2, dir=2 }
    { x=2, y=1, dir=6 }
  }
}

HALL_L_4x4 =
{
  prob = 10

  structure =
  {
    "1..."
    "1..."
    "1..."
    "1111"
  }

  good_conns =
  {
    { x=1, y=4, dir=8 }
    { x=4, y=1, dir=6 }
  }

  stair_spots =
  {
    { x=1, y=3, dir=2 }
    { x=2, y=1, dir=6 }
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

  good_conns =
  {
    { x=1, y=3, dir=8 }
    { x=3, y=1, dir=6 }
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

  good_conns =
  {
    { x=1, y=3, dir=4 }
    { x=3, y=3, dir=4 }
    { x=2, y=1, dir=2 }
  }

  stair_spots =
  {
    { x=2, y=2, dir=2 }
  }
}

HALL_Z_5x3 =
{
  prob = 25

  structure =
  {
    "111.."
    "..1.."
    "..111"
  }

  good_conns =
  {
    { x=1, y=3, dir=4 }
    { x=5, y=1, dir=6 }
  }

  stair_spots =
  {
    { x=2, y=3, dir=6 }
    { x=3, y=2, dir=2 }
    { x=4, y=1, dir=6 }
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

  good_conns =
  {
    { x=1, y=1, dir=4 }
    { x=6, y=1, dir=6 }
  }

  stair_spots =
  {
    { x=2, y=1, dir=6 }
    { x=5, y=3, dir=6 }
  }
}

HALL_U_5x3_rounded =
{
  prob = 25

  structure =
  {
    "1...1"
    "%%.//"
    ".%1/."
  }

  diagonals =
  {
    ".1", "1.", ".1", "1."
    ".1", "1."
  }

  good_conns =
  {
    { x=1, y=3, dir=8 }
    { x=5, y=3, dir=8 }
  }

  stair_spots =
  {
    { x=3, y=1, dir=6 }
  }
}


-- end of SHAPES
}



function Grower_save_svg()

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

    local color = "#666"

    if not A2 then
      -- no change
    elseif (A1.room and A1.room.initial_hub) or (A2.room and A2.room.initial_hub) then
      color = "#f00"
    elseif A1.is_boundary != A2.is_boundary then
      color = "#0a0"
    elseif (A1.room and A1.room.hallway) or (A2.room and A2.room.hallway) then
      color = "#c74"
    elseif A1.room or A2.room then
      color = "#00f"
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


  ---| Grower_save_svg |---

  local filename = "grow_s" .. OB_CONFIG.seed .. "_" .. LEVEL.name .. ".svg"

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



function Grower_preprocess_tiles()

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
    if ch == '9' then return { kind="area", area=9 } end

    error("Grower_parse_char: unknown symbol: " .. tostring(ch))
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
        error("Grower_parse_char: not enough diagonals")
      end

      local L = parse_element(string.sub(D, 1, 1))
      local R = parse_element(string.sub(D, 2, 2))

      local diagonal = sel(ch == '/', 3, 1)

      if ch == '%' then
        L, R = R, L
      end

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

    -- must iterate line by line, then across each line
    for y = 1, H do
    for x = 1, W do
      local line = structure[y]

      if #line != W then
        error("Malformed structure in tile: " .. def.name)
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


  local function check_connections(def)
    local grid = def.processed[1].grid

    if not def.conns or table.size(def.conns) < 2 then
      error("Missing connections in tile: " .. def.name)
    end

    local default_set = ""

    each letter,conn in def.conns do
      local x = conn.x
      local y = conn.y

      if not (x and x >= 1 and x <= grid.w) or
         not (y and y >= 1 and y <= grid.h)
      then
        error("Bad connection coord in tile: " .. def.name)
      end

      if grid[x][y].kind == "diagonal" then
        error("Ambiguous conn coord (on a diagonal) in tile: " .. def.name)
      end

      if default_set == "" then
        default_set = letter .. ":"
      else
        default_set = default_set .. letter
      end
    end

    if not def.conn_sets then
      def.conn_sets = { default_set }
    end
  end


  local function add_stairs(def)
    local grid = def.processed[1].grid

    each spot in def.stair_spots do
      local x = spot.x
      local y = spot.y

      if not (x and x >= 1 and x <= grid.w) or
         not (y and y >= 1 and y <= grid.h)
      then
        error("Bad stair coord in tile: " .. def.name)
      end

      if grid[x][y].kind == "diagonal" then
        error("Ambiguous stair coord (on a diagonal) in tile: " .. def.name)
      end

      grid[x][y].good_stair = { dir=spot.dir }
    end
  end


  ---| Grower_preprocess_tiles |---

  table.name_up(TILES)

  table.expand_templates(TILES)

  each name,def in TILES do
    cur_def = def

    def.area_list = {}
    def.processed = {}

    def.processed[1] = convert_structure(def, def.structure)

    check_connections(def)

    if def.stair_spots then add_stairs(def) end

    if string.match(name, "HALL_") then def.mode = "hallway" end
    if string.match(name, "HUB_")  then def.mode = "hub" end

    if not def.mode then def.mode = "room" end
  end
end



function Grower_prepare()
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

  Grower_preprocess_tiles()
end



function Grower_grow_hub(is_first)
  --
  --  FIXME DESCRIPTION | ALGORITHM
  --

  local area_map

  local cur_def
  local cur_grid


  local function create_areas_for_tile(def, R)
    area_map = {}

    for i = 1, #def.area_list do
      local A = AREA_CLASS.new("normal")

      if def.mode == "hallway" then
        A.mode = def.mode
      end

      area_map[i] = A

      A.svolume = A:calc_volume()

      R:add_area(A)
    end
  end


  local function transform_coord(T, px, py)
    if T.mirror_x then px = cur_grid.w + 1 - px end
    if T.mirror_y then py = cur_grid.h + 1 - py end

    if T.transpose then px, py = py, px end

    local sx = T.x + (px - 1)
    local sy = T.y + (py - 1)

    return sx, sy
  end


  local function transform_dir(T, dir)
    if T.mirror_x  then dir = geom.MIRROR_X[dir]  end
    if T.mirror_y  then dir = geom.MIRROR_Y[dir]  end
    if T.transpose then dir = geom.TRANSPOSE[dir] end

    return dir
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


  local function calc_transform(P, def, entry_conn, do_mirror)
    -- create a transform which positions the tile so that entry_conn
    -- mates up with the sprout 'P'.

    local T = {}

    if not geom.is_parallel(P.dir, entry_conn.dir) then
      T.transpose = true
    end

    if P.dir == transform_dir(T, entry_conn.dir) then
      if geom.is_vert(entry_conn.dir) then
        T.mirror_y = true
      else
        T.mirror_x = true
      end
    end

    if do_mirror then
      if geom.is_vert(entry_conn.dir) then
        T.mirror_x = true
      else
        T.mirror_y = true
      end
    end

    -- now transpose and mirroring is setup, compute the position

    local PN = P.S:neighbor(P.dir)
    assert(PN)

    T.x = 0
    T.y = 0

    local dx, dy = transform_coord(T, entry_conn.x, entry_conn.y)

    T.x = PN.sx - dx
    T.y = PN.sy - dy

    return T
  end


  local function install_half_seed(T, S, elem)
    if elem.kind != "area" then
      error("Unknown element kind in shape")
    end

    local A = area_map[elem.area]
    assert(A)

    assert(S.area == nil)

    S.area = A
    S.room = A.room
    table.insert(A.seeds, S)

    if elem.good_conn then
      S.good_conn_dir = transform_dir(T, elem.good_conn.dir)
    end

    if elem.good_stair then
      S.good_stair_dir = transform_dir(T, elem.good_stair.dir)
    end
  end


  local function test_or_install_element(elem, T, px, py, ROOM)
    if elem.kind == "empty" then return true end

    local sx, sy = transform_coord(T, px, py)

    -- never allow tiles to touch edge of map
    if sx <= 1 or sx >= (SEED_W - 1) then return false end
    if sy <= 1 or sy >= (SEED_H - 1) then return false end

    local S = SEEDS[sx][sy]

    -- hallway test : prevent them touching
    if cur_def.mode == "hallway" and S.no_hall then
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

        if not ROOM then return true end

        -- need to split the seed to install this element
        S:split(math.min(dir, 10 - dir))
      end

      local S1 = S
      local S2 = S.top

      for pass = 1, 2 do
        if E1.kind != "empty" then

          -- used?
          if S1.area then return false end

          if ROOM then
            install_half_seed(T, S1, E1)
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

      if ROOM then
        install_half_seed(T, S, elem)
      end

      return true
    end
  end


  local function add_new_sprouts(T, conn_set, room, initial_hub)
    -- only keep entry conn for an initial hub
    if not initial_hub then
      conn_set = string.match(conn_set, ":(%w*)")
      assert(conn_set and conn_set != "")
    end

    for i = 1, #conn_set do
      local letter = string.sub(conn_set, i, i)
      if letter == ':' then continue end

      local conn = cur_def.conns[letter]
      if not conn then error("Bad letter in conn_set in " .. cur_def.name) end

      local sx, sy = transform_coord(T, conn.x, conn.y)
      local dir    = transform_dir  (T, conn.dir)

      assert(Seed_valid(sx, sy))
      local S = SEEDS[sx][sy]

      -- FIXME rank
      Sprout_new(S, dir, room, rand.irange(2,6))
    end
  end


  local function create_room(def)
    local ROOM = ROOM_CLASS.new()

    if def.mode == "hallway" then
      ROOM.kind = "hallway"
      ROOM.hallway = { }
    end

    create_areas_for_tile(def, ROOM)

    return ROOM
  end


  local function check_sprout_blocked(P)
    local N = P.S:neighbor(P.dir)

    if not N then return true end

    if N.area then return true end

    if N.sx <= LEVEL.boundary_sx1 or N.sx >= LEVEL.boundary_sx2 then return true end
    if N.sy <= LEVEL.boundary_sy1 or N.sy >= LEVEL.boundary_sy2 then return true end

    return false  -- not blocked
  end


  local function try_add_tile_RAW(P, T, ROOM)
    -- when 'ROOM' is not nil, we are installing the tile

--[[ DEBUG
if ROOM then
  stderrf("Installing tile '%s' @ (%d %d) dir:%d\n", cur_def.name, P.sx, P.sy, P.dir)
end
--]]

    local W = cur_grid.w
    local H = cur_grid.h

    for px = 1, W do
    for py = 1, H do
      local elem = cur_grid[px][py]
      assert(elem)

      local res = test_or_install_element(elem, T, px, py, ROOM)

      if not ROOM and not res then
        -- cannot place this shape here (something in the way)
        return false
      end

      assert(res)
    end -- px, py
    end

    return true
  end


  local function try_add_tile(P, def, conn_set)
    cur_def  = def
    cur_grid = def.processed[1]

    local entry_letter = string.sub(conn_set, 1, 1)
    local entry_conn   = def.conns[entry_letter]
    if not entry_conn then error("Bad letter in conn_set in " .. def.name) end

    local T = calc_transform(P, def, entry_conn, false)

    if try_add_tile_RAW(P, T, nil) then

      local ROOM = create_room(def)
      ROOM.initial_hub = P.initial_hub

      try_add_tile_RAW(P, T, ROOM)
      add_new_sprouts(T, conn_set, ROOM, P.initial_hub)

      return true  -- OK
    end

    return false
  end


  local function biggest_free_rectangle()
    if is_first then
      return LEVEL.boundary_sx1 + 1, LEVEL.boundary_sy1 + 1,
             LEVEL.boundary_sx2 - 1, LEVEL.boundary_sy2 - 1
    end

    error("biggest_free_rectangle: not implemented!")
  end


  local function add_initial_hub()
    local tab = {}

    each name, def in TILES do
      if def.mode == "hallway" then continue end

      local prob = def.prob or 0
      if prob > 0 then
        tab[name] = prob
      end
    end

    assert(not table.empty(tab))

    local sx1, sy1, sx2, sy2 = biggest_free_rectangle()

    local sx  = math.i_mid(sx1, sx2) - 1
    local sy  = math.i_mid(sy1, sy2) - 2

    -- create a fake sprout
    local P =
    {
      S = SEEDS[sx][sy]
      dir = 8
      initial_hub = true
    }

    while not table.empty(tab) do
      local name = rand.key_by_probs(tab)
      local def  = assert(TILES[name])

      tab[name] = nil

      local conn_set = rand.pick(def.conn_sets)

      if try_add_tile(P, def) then
        return true
      end

      -- try another one...
    end

    if is_first then
      error("Failed to add very first hub.")
    end

    return false
  end


  local function add_room(P)
    -- P is a sprout

    local tab = {}

    each name, def in TILES do
      if def.mode == "hub" then continue end

      -- don't connect two hallway tiles
      if P.room.kind == "hallway" and def.mode == "hallway" then continue end

      local prob = def.prob or 0

      if prob > 0 then
        tab[name] = prob
      end
    end

    while not table.empty(tab) do
      local name = rand.key_by_probs(tab)
      local def  = assert(TILES[name])

      tab[name] = nil

      local conn_set = rand.pick(def.conn_sets)

      if try_add_tile(P, def, conn_set) then
        return
      end

      -- try another one...
    end

    -- was not possible, that's OK
  end


  local function remove_dud_hallways()
    -- FIXME
  end


  local function connect_to_previous_hub()
    -- FIXME
  end


  ---| Grower_grow_hub |---

  if not add_initial_hub() then
    return
  end

  while true do
    local sprout = Sprout_pick_next()

    -- no more sprouts?
    if not sprout then break; end

    if not check_sprout_blocked(sprout) then
      add_room(sprout)
    end
  end

  remove_dud_hallways()

  -- ensure a second (etc) hub-growth is connected to a previous one
  -- [ this is mainly so we can mark the level boundary, and we need
  --   a fully connected room set for that ]
  if not is_first then
    connect_to_previous_hub()
  end
end



function Grower_fill_gaps()
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

    if A2.svolume < MIN_SIZE then
      score = 3
    elseif A1.svolume + A2.svolume <= MAX_SIZE then
      score = 2
    end

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
      local area = AREA_CLASS.new("void")

      area.seeds = T.seeds

      -- install into seeds
      each S in area.seeds do
        S.area = area
      end
    end
  end


  ---| Grower_fill_gaps |---

  create_temp_areas()

  for loop = 1,20 do
    merge_temp_areas()
  end

  smoothen_out_pokers()

  make_real_areas()
end



function Grower_assign_boundary()
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
    local prob = 30

    each A in LEVEL.areas do
      if not A.room and
         rand.odds(prob) and
         touches_a_room(A) and
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
    each N in A.neighbors() do
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


  ---| Grower_assign_boundary |---

  mark_room_inners()

  mark_other_inners()

  floodfill_outers()
end



function Grower_create_rooms()
  LEVEL.sprouts = {}

  Grower_prepare()

  Grower_grow_hub("is_first")

  -- FIXME : for i = 1, 5 do Grower_grow_hub() end

  Grower_fill_gaps()

  Area_squarify_seeds()

  Area_calc_volumes()
  Area_find_neighbors()

  Grower_assign_boundary()

  Grower_save_svg()
end

