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
    S    : SEED     -- where to join onto
    dir  : DIR      --

    long  : number  -- width of connection (in seeds)

    split : number  -- when not NIL, there are two gaps at each side
                    -- of connection and 'split' is width of the gaps
                    -- (require split * 2 + 1 <= long)

    mode : keyword  -- usually "normal".
                    -- can be "extend" to make existing room bigger
                    -- (instead of create a new room)

    room : ROOM  -- the room to join onto

    initial_hub  -- if set, this is a fake sprout to grow a hub onto
--]]


function Sprout_new(S, dir, conn, room)
  assert(room)

  local P =
  {
    S = S
    dir = dir
    long = conn.long
    mode = conn.mode or "normal"
    split = conn.split
    room = room
  }

  table.insert(LEVEL.sprouts, P)

  return P
end


function Sprout_emergency_new(S, dir, room)
-- stderrf("emergency sprout @ %s dir:%d\n", S.name, dir)
  local P =
  {
    S = S
    dir = dir
    long = 1
    mode = "normal"
    room = room
    is_emergency = true
  }

  table.insert(LEVEL.sprouts, P)

  return P
end


function Sprout_pick_next()
  if table.empty(LEVEL.sprouts) then
    return nil
  end

  local best
  local best_score = 9e9

  each P in LEVEL.sprouts do
    local score = 0

    if P.is_emergency then
      score = 1000
    elseif P.room then
      score = P.room.grow_rank or 3 --FIXME
    end

    score = score + gui.random()

    if score < best_score then
      best = P
      best_score = score
    end
  end

  assert(best)

  -- remove it from global list
  table.kill_elem(LEVEL.sprouts, best)

  return best
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

    local color = "#777"
    local lin_w = 2

    if not A2 then
      -- no change
--  elseif (A1.is_boundary != A2.is_boundary) then
--    color = "#f0f"
    elseif A1 == A2 then
      color = "#faf"
      lin_w = 1
    elseif (A1.room == A2.room) and (A1.room or A2.room) then
      color = "#0f0"
    elseif A1.room == A2.room then
      -- no change
    elseif (A1.room and A1.room.initial_hub) or (A2.room and A2.room.initial_hub) then
      color = "#f00"
    elseif (A1.room and A1.room.hallway) or (A2.room and A2.room.hallway) then
      color = "#fb0"
    else
      color = "#00f"
      lin_w = 3
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
                (sx2 - 1) * SIZE, (sy2 - 1) * SIZE, color, lin_w)
  end


  ---| Grower_save_svg |---

  local filename = "grow_" .. OB_CONFIG.seed .. "_" .. LEVEL.name .. ".svg"

  fp = io.open(filename, "w")

  if not fp then error("Cannot create file") end

  -- header
  fp:write('<?xml version="1.0" encoding="UTF-8" standalone="no"?>')
  fp:write('<svg xmlns="http://www.w3.org/2000/svg" version="1.1">\n')

  -- grid
  local min_x = 0
  local min_y = 0

  local max_x = SEED_W * SIZE
  local max_y = SEED_H * SIZE

  for x = 0, SEED_W do
    wr_line(fp, x * SIZE, min_y, x * SIZE, max_y, "#bbb")
  end

  for y = 0, SEED_H do
    wr_line(fp, min_x, y * SIZE, max_x, y * SIZE, "#bbb")
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


  local function parse_char(ch, diag_list, def)
    -- handle diagonal seeds
    if ch == '/' or ch == '%' then
      if not diag_list then
        error("Grower_parse_char: missing diagonals in: " .. def.name)
      end

      local D = table.remove(diag_list, 1)
      if not D then
        error("Grower_parse_char: not enough diagonals in: " .. def.name)
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

      grid[x][gy] = parse_char(ch, diag_list, def)
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
      conn.long = conn.w or 1

      default_set = default_set .. letter

      local is_diag = geom.is_corner(conn.dir)

      if is_diag and conn.long >= 2 then
        error("Long diagonals not supported, tile: " .. def.name)
      end

      local x = conn.x
      local y = conn.y

      if not (x and x >= 1 and x <= grid.w) or
         not (y and y >= 1 and y <= grid.h)
      then
        error("Bad connection coord in tile: " .. def.name)
      end

      if grid[x][y].kind == "diagonal" then
        if not is_diag then
          error("Straight conn on a diagonal seed, tile: " .. def.name)
        elseif not geom.is_parallel(conn.dir, grid[x][y].diagonal) then
          error("Diagonal conn mismatches seed, tile: " .. def.name)
        end

      else -- full seed
        if is_diag then
          error("Diagonal conn not on a diagonal seed, tile: " .. def.name)
        end
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

    if string.match(name, "HALL_")   then def.mode = "hallway" end
    if string.match(name, "EXTEND_") then def.mode = "extend" end

    if string.match(name, "BUILDING_") then def.environment = "building" end
    if string.match(name, "OUTDOOR_")  then def.environment = "outdoor" end
    if string.match(name, "CAVE_")     then def.environment = "cave" end

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



function Grower_determine_coverage()
  local count = 0
  local total = 0

gui.debugf("Grower_determine_coverage...\n")
  for sx = LEVEL.boundary_sx1 + 1, LEVEL.boundary_sx2 - 1 do
  for sy = LEVEL.boundary_sy1 + 1, LEVEL.boundary_sy2 - 1 do
    total = total + 1

    local S = SEEDS[sx][sy]

    if S.room or (S.top and S.top.room) then
local RR = S.room or (S.top and S.top.room)
local AA = S.area or (S.top and S.top.area)
gui.debugf("  %s : %s / %s\n", S.name, RR.name, (AA and AA.name) or "-noarea-")
      count = count + 1
    end
  end
  end

gui.debugf("coverage: %1.2f (%d seeds / %d)\n", count / total, count, total)
  return count / total
end



function Grower_emergency_sprouts()

  local function eval_spot(A, S, dir)
    -- tried this spot before?
    if S.emergency_sprout then return -1 end

    local N = S:neighbor(dir)

    if not N then return -2 end

    if N.area then return -3 end

    -- TODO : CHECK MORE STUFF

    local score = 1

--stderrf("eval_spot : potential @ %s dir:%d\n", S.name, dir)
    return score + gui.random()
  end


  local function scan_area(A)
    local best_S
    local best_dir
    local best_score = 0

    each S in A.seeds do
    each dir in geom.ALL_DIRS do
      local score = eval_spot(A, S, dir)

      if score > best_score then
        best_S = S
        best_dir = dir
        best_score = score
      end
    end
    end

    if not best_S then return end

    -- create a sprout
    Sprout_emergency_new(best_S, best_dir, A.room)

    -- do not try this seed again
    best_S.emergency_sprout = true
  end


  --| Grower_emergency_sprouts |--

  -- pick a spot from every normal area of every room
  each A in LEVEL.areas do
    if A.room and A.mode == "room" then
      scan_area(A)
    end
  end
end



function Grower_make_areas(temp_areas)
  each T in temp_areas do
    local area = AREA_CLASS.new("void")

    area.seeds = T.seeds

    if T.room then
      area.mode = "room"

      area.svolume = T.svolume or 0  -- FIXME: can be used too early

      T.room:add_area(area)
    end

    -- install into seeds
    each S in area.seeds do
      S.area = area
      S.room = T.room

      S.temp_area = nil
    end
  end

  
  -- sanity check [ no seeds should have a 'temp_area' now... ]
  for sx = 1, SEED_W do
  for sy = 1, SEED_H do
  for pass = 1, 2 do
    local S = SEEDS[sx][sy]
    if pass == 2 then S = S.top end
    if S then assert(not S.temp_area) end
  end
  end
  end
end



function Grower_add_room(P, is_hallway)
  local ROOM = ROOM_CLASS.new()

  ROOM.grow_parent = P.room
  ROOM.initial_hub = P.initial_hub

  local kind = sel(is_hallway, "hallway", "normal")
  
  Room_set_kind(ROOM, kind, P.is_outdoor, P.is_cave)

  local prev_room = P.room

  if not prev_room then
    ROOM.grow_rank = 1
  elseif is_hallway then
    ROOM.grow_rank = prev_room.grow_rank
  else
    ROOM.grow_rank = prev_room.grow_rank + 1
  end

  -- create a preliminary connection (last room to this one)
  -- [ we just modify the current sprout ]

  if P.room then
    assert(not P.initial_hub)

    P.R1 = P.room
    P.R2 = ROOM

    P.R1.prelim_conn_num = P.R1.prelim_conn_num + 1
    P.R2.prelim_conn_num = P.R2.prelim_conn_num + 1

    table.insert(LEVEL.prelim_conns, P)
  end

  return ROOM
end



function Grower_organic_room(P)
  --
  -- Creates a few areas "organically", growing them seed-by-seed
  -- (using rules similar to the old "weird" shape generator).
  --
  local cur_room
  local cur_area

  local temp_areas = {}

  local DIAG_PROB = 40


  local function set_seed(S, A)
    S.temp_area = A
    table.insert(A.seeds, S)

    local vol = sel(S.diagonal, 0.5, 1.0)
    A.svolume = A.svolume + vol
    cur_room.svolume = cur_room.svolume + vol
  end


  local function raw_blocked(S)
    if S.area then return true end
    if S.temp_area then return true end

    if S.sx <= 1 or S.sx >= SEED_W then return true end
    if S.sy <= 1 or S.sy >= SEED_H then return true end

    return false
  end


  local function check_enough_room()
    cur_area = nil

    local sx1 = P.S.sx
    local sy1 = P.S.sy
    local sx2 = sx1
    local sy2 = sy1

    local dx, dy = geom.delta(P.dir)

    if geom.is_corner(P.dir) then
      -- diagonal : check 3x3 seeds, the sprout is one corner

      if dx > 0 then sx2 = sx2 + 2 else sx1 = sx1 - 2 end
      if dy > 0 then sy2 = sy2 + 2 else sy1 = sy1 - 2 end

    else
      -- straight : check 3x3 seed just beyond the sprout

      sx1 = sx1 - 1 + 2 * dx
      sy1 = sy1 - 1 + 2 * dy

      sx2 = sx1 + 2
      sy2 = sy1 + 2

      if P.long >= 2 then
        local extra = int(P.long / 2)

        if geom.is_vert(P.dir) then
          sx1 = sx1 - extra
          sx2 = sx2 + extra
        else
          sy1 = sy1 - extra
          sy2 = sy2 + extra
        end
      end
    end

    for x = sx1, sx2 do
    for y = sy1, sy2 do
      if not Seed_valid(x, y) then return false end

      local S = SEEDS[x][y]

      if Seed_over_boundary(S) then return false end

      -- ignore the sprout (for diagonals)
      if S == P.S then continue end

      if raw_blocked(S) or S.diagonal then return false end
    end
    end

    return true -- OK
  end


  local function is_sharp_poker(S)
    local block_count = 0

    each dir in geom.ALL_DIRS do
      local N = S:neighbor(dir)
      if N and raw_blocked(N) then
        block_count = block_count + 1
      end
    end

    return block_count >= 2
  end


  local function seed_usable(S, prevs)
    assert(cur_area)

    if raw_blocked(S) then return false end

    if not prevs then prevs = {} end
    table.insert(prevs, S)

    if S.diagonal then
      -- require seeds on each straight side to be usable
      each dir in geom.SIDES do
        local N = S:neighbor(dir)
        if not N then continue end

        -- allow neighbor to have current area, but DO NOT recurse
        if N.temp_area == cur_area then continue end

        if table.has_elem(prevs, N) then continue end

        -- recursive call
        if not seed_usable(N, prevs) then return false end
      end

      if is_sharp_poker(S) then return false end
    end

    return true
  end


  local function can_make_diagonal(S, corner)
    assert(not raw_blocked(S))

    if S.diagonal then return false end

    local x_dir = sel(corner == 1 or corner == 7, 4, 6)
    local y_dir = sel(corner == 1 or corner == 3, 2, 8)

    local NX = S:neighbor(x_dir)
    local NY = S:neighbor(y_dir)

    if not NX or not NY then return false end

    if not (NX.temp_area == cur_area or seed_usable(NX)) then return false end
    if not (NY.temp_area == cur_area or seed_usable(NY)) then return false end

    return true
  end


  local function add_to_list(S, corner, list)
    -- already there?
    each loc in list do
      if loc.S == S and loc.corner == corner then
        return "seen"
      end

      -- upgrade a diagonal to full seed
      if loc.S == S then
        loc.corner = nil
        return "upgrade"
      end
    end

    table.insert(list, { S=S, corner=corner })
  end


  local function get_group(S, corner, list, from_dir)
    -- Note: 'corner' parameter is only set when we are going to split
    -- a full seed and use just that corner.  When just using an existing
    -- diagonal seed, 'corner' must be NIL.
    -- 'from_dir' only set when called recursively.

--- stderrf("get_group @ %s corner:%s\n", S.name, tostring(corner))

    if corner then
      assert(not S.diagonal)
    end

    assert(seed_usable(S))

    if from_dir then assert(list) end

    local is_first = (not list)

    if is_first and corner then
      assert(can_make_diagonal(S, corner))
    end


    if not list then list = {} end

    -- if already there, or upgraded, then nothing more to do
    if add_to_list(S, corner, list) then
      return list
    end


    -- determine which directions to check
    local x_dir
    local y_dir

    if corner then
      x_dir = sel(corner == 1 or corner == 7, 4, 6)
      y_dir = sel(corner == 1 or corner == 3, 2, 8)

    elseif S.diagonal then
      x_dir = sel(S:neighbor(6, "NODIR") == "NODIR", 4, 6)
      y_dir = sel(S:neighbor(8, "NODIR") == "NODIR", 2, 8)

    else
      -- a full seed, nothing more to do
      return list
    end

    if rand.odds(50) then --!!!!
      x_dir, y_dir = y_dir, x_dir
    end

    for pass = 1, 2 do
      local dir = sel(pass >= 2, y_dir, x_dir)

      local N = S:neighbor(dir)
      assert(N)

      -- allow same area as current one, but DO NOT recurse
      if N.temp_area == cur_area then continue end

      -- no need to recursive if going back to where we just were
      if from_dir and (10 - dir) == from_dir then continue end

      assert(seed_usable(N))

      -- pick a new corner which shares an edge with previous one
      local corn_A = 3
      local corn_B = 9

      if dir == 6 or dir == 2 then corn_A = 7 end
      if dir == 6 or dir == 8 then corn_B = 1 end

      if not can_make_diagonal(N, corn_A) then corn_A = nil end
      if not can_make_diagonal(N, corn_B) then corn_B = nil end

      -- pick new type of corner [ often none ]
      local new_corn = nil

      if (corn_A or corn_B) and rand.odds(DIAG_PROB) then
        if corn_A and corn_B then
          new_corn = rand.sel(50, corn_A, corn_B)
        else
          new_corn = corn_A or corn_B
        end
      end

      -- recursively flow into next seed
      get_group(N, new_corn, list, dir)
    end

    return list
  end


  local function apply_group(list)
    each loc in list do
      local S = loc.S

      if loc.corner then
        local diagonal = math.min(loc.corner, 10 - loc.corner)
        S:split(diagonal)

        if loc.corner > 5 then S = S.top end
      end

      set_seed(S, cur_area)
    end
  end


  local function spot_from_sprout(A)
    local S = P.S:neighbor(P.dir)

    for i = 1, P.long do
      assert(not S.temp_area)

      assert(seed_usable(S))

      apply_group(get_group(S))

      if not S.diagonal then
        S = S:raw_neighbor(geom.RIGHT[P.dir])
      end
    end
  end


  local function try_spot_off_area(S, dir)
    local N = S:neighbor(dir)

    if Seed_over_boundary(N) then return false end

    if not seed_usable(N) then
      return false
    end

    -- when coming off same area, try to make a diagonal
    local corner

    if not N.diagonal and S.temp_area == cur_area and rand.odds(DIAG_PROB) then
      local corn_A = 3
      local corn_B = 9

      if dir == 6 or dir == 2 then corn_A = 7 end
      if dir == 6 or dir == 8 then corn_B = 1 end

      if not can_make_diagonal(N, corn_A) then corn_A = nil end
      if not can_make_diagonal(N, corn_B) then corn_B = nil end

      if corn_A and corn_B then
        corner = rand.sel(50, corn_A, corn_B)
      else
        corner = corn_A or corn_B
      end
    end

--stderrf("try_spot_off_area at %s / %s\n", N.name, tostring(corner))
    apply_group(get_group(N, corner))

    return true
  end


  local function spot_off_existing_area(visit_list)
    -- collect potentially usable spots
    local try_list = {}

    each T in visit_list do
    each S in T.seeds do
    each dir in geom.ALL_DIRS do
      local N = S:neighbor(dir)

      if N and not raw_blocked(N) then
        assert(S.temp_area == T)
        table.insert(try_list, { S=S, dir=dir })
      end
    end
    end
    end

    rand.shuffle(try_list)

    each loc in try_list do
      if try_spot_off_area(loc.S, loc.dir) then
--stderrf("SUCCESS with spot: %s dir:%d\n", loc.S.name, loc.dir)
        return true -- OK
      end
    end

    -- nothing worked, that is OK too
    return false
  end


  local function grow_an_area(from_sprout)
    -- create a new temporary area
    cur_area =
    {
      id = alloc_id("organic_area")
      room = cur_room
      seeds = {}
      svolume = 0
      min_vol  = rand.index_by_probs({ 0, 3, 7, 5, 1 })
      want_vol = rand.index_by_probs({ 0, 1, 9, 7, 4, 2, 1, 1, 1 })
    }

    cur_area.name = string.format("ORGANIC_%d", cur_area.id)

    if from_sprout then
      spot_from_sprout(cur_area)
    else
      if not spot_off_existing_area(temp_areas) then
        -- nothing was possible, so ignore this temp area
        return
      end
    end

    table.insert(temp_areas, cur_area)

    local cur_area_as_list = { cur_area }

    for loop = 1,100 do
      if cur_area.svolume >= cur_area.want_vol then break; end

      if not spot_off_existing_area(cur_area_as_list) then
        break;  -- nothing was possible
      end
    end
  end


  ---| Grower_organic_room |---

  if rand.odds(0) then  -- FIXME
    return false
  end

  if not check_enough_room() then return false end

  -- create room --

  cur_room = Grower_add_room(P, false)

  cur_room.want_vol = rand.pick({ 12, 18, 24, 48 })

  grow_an_area("from_sprout")

  for loop = 1, 50 do
    if cur_room.svolume >= cur_room.want_vol then break; end
    grow_an_area()
  end

  -- FIXME : merge undersized areas

  -- FIXME : create sprouts too
  -- [ for time being we can rely on emergency sprouts... ]

  Grower_make_areas(temp_areas)

  return true
end



function Grower_grow_trunk(is_first)
  --
  --  This builds a whole "trunk", a group of connected rooms.
  --  The map will consist of one or more of these trunks.
  --  [ Note: each new trunk is connected to a previous one ]
  --
  --  ALGORITHM:  (pretty standard)
  --
  --    1. start by adding a "Hub" room near center of map
  --    2. create N "sprouts" from its connections
  --    3. now add a room to a previous sprout
  --    4. each new room also adds its sprouts
  --    5. repeat from step 3 until all sprouts are used or blocked
  --    6. remove dud hallways (ones with only a single conn)
  --
  --  When picking a sprout to add onto, preference is given to ones
  --  created earlier, so the trunk grows slowly outward and has quite
  --  a few 3+ branches, rather than having "stalks" or rooms with only
  --  two connections (in and out).
  --

  local area_map

  local cur_def
  local cur_grid
  local cur_room


  local function create_areas_for_tile(def, R)
    area_map = {}

    for i = 1, #def.area_list do
      local A = AREA_CLASS.new("room")

      if def.mode == "hallway" then
        A.mode = def.mode
      end

      area_map[i] = A

      R:add_area(A)
    end
  end


  local function transform_coord(T, px, py)
    px = px - 1
    py = py - 1

    if T.mirror == "x" then px = cur_grid.w - px end
    if T.mirror == "y" then py = cur_grid.h - py end

    if T.rotate == 4 then
      px, py = -px, -py
    elseif T.rotate == 2 then
      px, py = py, -px
    elseif T.rotate == 6 then
      px, py = -py, px
    end

    return T.x + px, T.y + py
  end


  local function transform_dir(T, dir)
    if T.mirror == "x" then dir = geom.MIRROR_X[dir]  end
    if T.mirror == "y" then dir = geom.MIRROR_Y[dir]  end

    return geom.ROTATE[T.rotate][dir]
  end


  local function transform_diagonal(T, dir, bottom, top)
    if T.mirror == "x" then
      dir = geom.MIRROR_X[dir]
    end

    if T.mirror == "y" then
      dir = geom.MIRROR_Y[dir]
      top, bottom = bottom, top
    end

    if (T.rotate == 4) or
       (T.rotate == 2 and (dir == 1 or dir == 9)) or
       (T.rotate == 6 and (dir == 3 or dir == 7))
    then
      top, bottom = bottom, top
    end

    dir = geom.ROTATE[T.rotate][dir]

    return dir, bottom, top
  end


  local function calc_transform(P, def, entry_conn, do_mirror)
    -- create a transform which positions the tile so that entry_conn
    -- mates up with the sprout 'P'.

    local T = { rotate=0 }

    -- support mirroring
    if do_mirror and geom.is_straight(entry_conn.dir) then
      T.mirror = geom.vert_sel(entry_conn.dir, "x", "y")
    end

    local entry_dir = transform_dir(T, entry_conn.dir)

    if geom.is_parallel(P.dir, entry_dir) then
      if P.dir == entry_dir then
        T.rotate = 4
      else
        T.rotate = 0
      end

    else  -- perpendicular
      if P.dir == geom.RIGHT[entry_dir] then
        T.rotate = 6
      else
        T.rotate = 2
      end
    end

--[[ DEBUG
stderrf("  calc transform for %s...\n", def.name)
stderrf("    rotate:%d  mirror:%s  \n", tostring(T.rotate), tostring(T.mirror))
stderrf("    entry_conn.dir:%d  transformed --> %d  sprout.dir:%d\n",
entry_conn.dir, transform_dir(T, entry_conn.dir), P.dir)
--]]

    assert(transform_dir(T, entry_conn.dir) == 10 - P.dir)

    -- now transpose and mirroring is setup, compute the position

    local PN = P.S

    if not geom.is_corner(P.dir) then
      PN = PN:neighbor(P.dir)
      assert(PN)
    end

    T.x = 0
    T.y = 0

    local conn_x = entry_conn.x
    local conn_y = entry_conn.y

    -- to make the entry conn match up, choose the "right" most seed
    -- [ except when actually mirrored ]
    if entry_conn.long >= 2 and not T.mirror then
      conn_x, conn_y = geom.nudge(conn_x, conn_y, geom.RIGHT[entry_conn.dir], entry_conn.long - 1)
    end

--stderrf("    adjusted entry_conn: (%d %d)\n", conn_x, conn_y)

    local dx, dy = transform_coord(T, conn_x, conn_y)

    T.x = PN.sx - dx
    T.y = PN.sy - dy

--stderrf("    delta: (%d %d) ----> add pos (%d %d)\n", dx, dy, T.x, T.y)

    return T
  end


  local function install_half_seed(T, S, elem)
    if elem.kind != "area" then
      error("Unknown element kind in shape")
    end

    local A = area_map[elem.area]
    assert(A)

    assert(S.area == nil)

gui.debugf("  %s\n", S.name)

    S.area = A
    S.room = A.room
    table.insert(A.seeds, S)

---## if elem.good_conn then
---##   S.good_conn_dir = transform_dir(T, elem.good_conn.dir)
---## end

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
      if (not S.diagonal) and (S.area) then return false end

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


  local function add_new_sprouts(T, conn_set, R, initial_hub)
    R.grow_exits = 0

    for i = 1, #conn_set do
      local letter = string.sub(conn_set, i, i)

      if letter == ':' then continue end
      if letter == T.input then continue end

      local conn = cur_def.conns[letter]
      if not conn then error("Bad letter in conn_set in " .. cur_def.name) end

      local sx, sy = transform_coord(T, conn.x, conn.y)
      local dir    = transform_dir  (T, conn.dir)

      -- fix position for mirrored tiles
      if T.mirror then
        sx, sy = geom.nudge(sx, sy, geom.LEFT[dir], conn.long - 1)
      end

--stderrf("  adding sprout at (%d %d) dir:%d\n", sx, sy, dir)

      assert(Seed_valid(sx, sy))
      local S = SEEDS[sx][sy]

      -- handle diagonals [ pick 'bottom' or 'top' part ]
      if dir == 1 or dir == 3 then
        assert(S.diagonal)
        S = assert(S.top)
      end

      Sprout_new(S, dir, conn, R)

      R.grow_exits = R.grow_exits + 1
    end
  end


  local function check_sprout_blocked(P)
    local along_dir = geom.RIGHT[P.dir]

    local S = P.S

    -- this *justs* works for diagonal conns, but not LONG ones

    for i = 1, P.long do
      local N = S:neighbor(P.dir)

      if not N  then return true end
      if N.area then return true end

      if Seed_over_boundary(N) then return true end

      S = S:neighbor(along_dir)

      if geom.is_straight(along_dir) and not S then return true end
    end

    return false  -- not blocked
  end


  local function test_or_install_tile(P, T, ROOM)
    -- when 'ROOM' is not nil, we are installing the tile

--[[ DEBUG
if ROOM then
  stderrf("Installing tile '%s' @ (%d %d) dir:%d\n", cur_def.name, P.sx, P.sy, P.dir)
end
--]]

    local W = cur_grid.w
    local H = cur_grid.h

if ROOM then
gui.debugf("test_or_install_element... %s\n", ROOM.name)
end

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


  local function match_a_conn(P, def, conn)
    if conn.long != P.long then return false end

    -- cannot connect axis-aligned edges with diagonal edges
    if geom.is_corner(P.dir) != geom.is_corner(conn.dir) then return false end

    if conn.split != P.split then return false end

    if P.mode == "extend" and def.mode != "extend" then return false end

    return true
  end


  local function pick_matching_conn_set(P, def)
    local poss = {}

    each cs in def.conn_sets do
      -- try all the inputs, i.e. all letters before a ':'
      -- [ if no colon, ALL letters can be inputs ]
      for i = 1, #cs do
        local letter = string.sub(cs, i, i)

        if letter == ':' then break; end

        local conn = assert(def.conns[letter])

        if not conn then error("Bad letter in conn_set in " .. def.name) end

        if match_a_conn(P, def, conn) then
          table.insert(poss, { input=letter, cs=cs })
        end
      end
    end

    -- nothing possible?
    if table.empty(poss) then return nil end

    poss = rand.pick(poss)

    return poss.input, poss.cs
  end


  local function check_environment(P, def)
    -- very strict check for caves
    if P.is_cave then
      return (def.environment == "cave")
    end

    if def.environment then
      local env = sel(P.is_outdoor, "outdoor", "building")

      return (def.environment == env)
    end

    return true
  end


  local function try_add_tile(P, def, conn_set)
--stderrf("try_add_tile '%s'  @ %s dir:%d\n", def.name, P.S.name, P.dir)

    if not check_environment(P, def) then
      return false
    end

    local input, conn_set = pick_matching_conn_set(P, def)

    -- no possible connections?
    if not input then
--stderrf("  No matching entry conn (long=%d)\n", P.long)
      return false
    end

    cur_def  = def
    cur_grid = def.processed[1].grid

    local entry_conn = def.conns[input]

    local T = calc_transform(P, def, entry_conn, rand.odds(50))

    -- on initial hub, allow sprout input to be an exit
    if not P.initial_hub then
      T.input = input
    end

    if not test_or_install_tile(P, T, nil) then
--stderrf("Failed\n")
      return false
    end

    -- tile can be added, so create the room

--[[ DEBUG
local ax,ay = transform_coord(T, 1, 1)
local bx,by = transform_coord(T, cur_grid.w, cur_grid.h)
stderrf("  installing tile over (%d %d) .. (%d %d)\n",
math.min(ax,bx), math.min(ay,by),
math.max(ax,bx), math.max(ay,by))
--]]

    local ROOM = Grower_add_room(P, def.mode == "hallway")
    assert(ROOM)
    
    cur_room = ROOM

    create_areas_for_tile(def, ROOM)

    -- install into seeds
    test_or_install_tile(P, T, ROOM)

    add_new_sprouts(T, conn_set, ROOM, P.initial_hub)

--stderrf("SUCCESS !!\n")

    return true  -- OK
  end


  local function try_add_new_room(P, tab)
    -- pick room kind (outdoor / cave)
    local is_outdoor, is_cave = Room_choose_kind(P, P.room)

    P.is_outdoor = is_outdoor
    P.is_cave    = is_cave

    if not P.initial_hub then
      if Grower_organic_room(P) then
        return true
      end
    end

    while not table.empty(tab) do
      local name = rand.key_by_probs(tab)
      local def  = assert(TILES[name])

      tab[name] = nil

      if try_add_tile(P, def) then
        return true
      end

      -- try another one...
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

      local prob = def.start_prob or def.prob or 0
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
      long = rand.sel(50, 2, 1)
      mode = "normal"
      initial_hub = true
    }

    if try_add_new_room(P, tab) then
      return true
    end

    if is_first then
      error("Failed to add very first hub.")
    end

    return false
  end


  local function add_normal_room(P)
    -- P is a sprout

    local tab = {}

    each name, def in TILES do
      -- don't connect two hallway tiles
      if P.room.kind == "hallway" and def.mode == "hallway" then continue end

      local prob = def.prob or 0

      if prob > 0 then
        tab[name] = prob
      end
    end

    if try_add_new_room(P, tab) then
      return true
    end

    -- was not possible, that's OK
    return false
  end


  local function collect_full_branches(R)
    -- find all rooms that branch off the given room, including that room
    -- and future branches but not including the parent of 'R'.

    local list = { R }

    for i = 1, 999 do
      if i > #list then break; end

      each R2 in LEVEL.rooms do
        if R2.grow_parent == list[i] and not table.has_elem(list, R2) then
          table.insert(list, R2)
        end
      end
    end

    return list
  end


  local function kill_room(R)
    -- kill any preliminary connections too
    for i = #LEVEL.prelim_conns, 1, -1 do
      local PC = LEVEL.prelim_conns[i]

      if PC.R1 == R or PC.R2 == R then
        table.remove(LEVEL.prelim_conns, i)
      end
    end

    R:kill_it()
  end


  local function check_network_is_dud(R)
    local branches = collect_full_branches(R)

    if R.prelim_conn_num >= (R.grow_exits + 1) then
      return false
    end

    -- kill the whole network
    each N in branches do
      kill_room(N)
    end

    return true
  end


  local function remove_dud_hallways()
    local changed

    repeat
      changed = false

      for i = #LEVEL.rooms, 1, -1 do
        local R = LEVEL.rooms[i]

        -- TODO : allow room tiles too (if specified in tile def)
        if R.kind != "hallway" then continue end

        if check_network_is_dud(R) then
          changed = true
        end
      end

    until not changed
  end


  local function connect_to_previous_hub()
    -- FIXME
  end


  local function visit_all_sprouts()
    while true do
      local P = Sprout_pick_next()

      -- no more sprouts?
      if not P then return end

  --  if #LEVEL.rooms >= 10 then break; end

      if check_sprout_blocked(P) then
      --stderrf("Sprout BLOCKED @ %s dir:%d\n", P.S.name, P.dir)
        continue
      end

      add_normal_room(P)
    end
  end


  ---| Grower_grow_trunk |---

  if not add_initial_hub() then
    return
  end

  local MIN_COVERAGE = 0.5

  for loop = 1, 10 do
    visit_all_sprouts()

    remove_dud_hallways()

    Area_squarify_seeds()

    if Grower_determine_coverage() >= MIN_COVERAGE then
      break;
    end

    Grower_emergency_sprouts()
  end


  -- ensure a second (etc) hub-growth is connected to a previous one
  -- [ this is mainly so we can mark the level boundary, and we need
  --   a fully connected room set for that ]
  if not is_first then
    connect_to_previous_hub()
  end

end



function Grower_hallway_kinds()
  --
  -- Determines kind (building, outdoor, etc) of hallways.
  -- Actually called by quest code after room visit order has been
  -- established.
  --
  -- Result is based on two connecting rooms.  For example:
  --    cave + cave --> cave (usually)
  --    building + building -> building
  --

  local function get_room_pair(H)
    local R1, R2

    -- always use room at the entrance
    assert(H.entry_conn)
    R1 = H.entry_conn:other_room(H)

    -- if more than one exit, randomly pick it
    local conns2 = table.copy(H.conns)
    rand.shuffle(conns2)

    if conns2[1] == H.entry_conn then
      table.remove(conns2, 1)
    end

    assert(conns2[1])

    R2 = conns2[1]:other_room(H)

    return R1, R2
  end


  local function visit_hall(H)
    local R1, R2 = get_room_pair(H)

    local is_outdoor
    local is_cave

    if (R1.is_cave and R2.is_cave  and rand.odds(90)) or
       ((R1.is_cave or R2.is_cave) and rand.odds(60))
    then
      is_cave = true
    end

    if (R1.is_outdoor and R2.is_outdoor and rand.odds(50)) or
       ((R1.is_outdoor or R2.is_outdoor) and rand.odds(25)) or
       (H.svolume >= 3 and rand.odds(5))
    then
      is_outdoor = true
    end

-- stderrf("Hallway kind @ %s --> %s %s\n", H.name, sel(is_outdoor, "OUT", "-"), sel(is_cave, "CAVE", "-"))

    Room_set_kind(H, "hallway", is_outdoor, is_cave)
  end


  ---| Grower_hallway_kinds |---

  each H in LEVEL.rooms do
    if H.kind == "hallway" then
      visit_hall(H)
    end
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


  local function new_temp_area(S)
    local TEMP =
    {
      id = alloc_id("temp_area")
      svolume = 0
      seeds = { S }
    }

    if S.diagonal then
      TEMP.svolume = 0.5
    else
      TEMP.svolume = 1.0
    end

    -- check if touches very edge of map
    -- [ it might only touch at a corner, that is OK ]
    if S.sx <= 1 or S.sx >= SEED_W or
       S.sy <= 1 or S.sy >= SEED_H
    then
      TEMP.touches_edge = true
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

    if A2.touches_edge then
       A1.touches_edge = true
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
stderrf("a/b/a @ %s : %d %d / %d %d %d\n", S.name,
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


  ---| Grower_fill_gaps |---

  create_temp_areas()

  for loop = 1,20 do
    merge_temp_areas()
  end

  smoothen_out_pokers()

  Grower_make_areas(temp_areas)
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
    local prob = 20

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


  ---| Grower_assign_boundary |---

  mark_room_inners()

  mark_other_inners()

  floodfill_outers()
end



function Grower_create_rooms()
  LEVEL.sprouts = {}

  -- we don't make real connections until later (Connect_stuff)
  LEVEL.prelim_conns = {}

  Grower_prepare()

  Grower_grow_trunk("is_first")

  Grower_fill_gaps()

  Area_squarify_seeds()

  Area_calc_volumes()
  Area_find_neighbors()

  Grower_assign_boundary()

  Grower_save_svg()
end

