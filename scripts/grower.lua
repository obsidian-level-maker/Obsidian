------------------------------------------------------------------------
--  SHAPE GROWING SYSTEM
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2015-2016 Andrew Apted
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


--class TEMP_AREA
--[[
    id, name  :  use for debugging

    mode : keyword   -- the eventual mode of the AREA (q.v.)

    room : ROOM

    seeds : list(SEED)

    FIXME : other fields??
--]]


------------------------------------------------------------------------


function Grower_preprocess_grammar()

  local def
  local diag_list


  local function name_to_pass(name)
    if string.match(name, "ROOT_")      then return "root" end
    if string.match(name, "GROW_")      then return "grow" end
    if string.match(name, "SPROUT_")    then return "sprout" end
    if string.match(name, "DECORATE_")  then return "decorate" end
    if string.match(name, "TERMINATE_") then return "terminate" end

    error("Unknown pass for grammar " .. tostring(name))
  end


  local function parse_element(ch, what)
    if ch == '.' then return { kind="free" } end
    if ch == '!' then return { kind="free", utterly=1 } end

    if ch == '~' then return { kind="liquid" } end
    if ch == '#' then return { kind="disable" } end
    if ch == '@' then return { kind="link" } end

    if ch == '1' then return { kind="area", area=1 } end
    if ch == '2' then return { kind="area", area=2 } end
    if ch == '3' then return { kind="area", area=3 } end

    -- straight stairs
    if ch == '<' then return { kind="stair", dir=4 } end
    if ch == '>' then return { kind="stair", dir=6 } end
    if ch == '^' then return { kind="stair", dir=8 } end
    if ch == 'v' then return { kind="stair", dir=2 } end

    -- generic stairs (need an info table to set shape, dirs)
    if ch == 'S' then return { kind="stair"  } end

    -- match-only elements
    if ch == 'x' then return { kind="magic", what="all"  } end
    if ch == 'r' then return { kind="magic", what="room" } end
    if ch == 'f' then return { kind="magic", what="floor" } end
    if ch == 'o' then return { kind="magic", what="open" } end
    if ch == 'c' then return { kind="magic", what="closed" } end

    -- other stuff
    if ch == 'A' then return { kind="new_area" } end
    if ch == 'R' then return { kind="new_room" } end

    if ch == 'H' then return { kind="hallway" } end
    if ch == 'P' then return { kind="hall2"   } end

    if ch == 'C' then return { kind="cage"   } end
    if ch == 'J' then return { kind="joiner" } end
    if ch == 'T' then return { kind="closet" } end

    error("Grower_parse_char: unknown symbol: " .. tostring(ch))
  end


  local function parse_char(ch, what)
    -- handle diagonal seeds
    if ch == '/' or ch == '%' then
      if not diag_list then
        error("Grower_parse_char: missing diagonals in: " .. def.name)
      end

      local D = table.remove(diag_list, 1)
      if not D then
        error("Grower_parse_char: not enough diagonals in: " .. def.name)
      end

      local L = parse_element(string.sub(D, 1, 1), what)
      local R = parse_element(string.sub(D, 2, 2), what)

      local diagonal = sel(ch == '/', 3, 1)

      if ch == '%' then
        L, R = R, L
      end

      return { kind="diagonal", diagonal=diagonal, bottom=R, top=L }
    end

    return parse_element(ch, what)
  end


  local function convert_element(what, grid, x, y)
    local line

    if what == "input" then
      line = def.structure[y*2 - 1]
    else
      line = def.structure[y*2]
    end

    if #line != grid.w then
      error("Malformed structure in grammar: " .. def.name)
    end

    local ch = string.sub(line, x, x)

    local elem = parse_char(ch, diag_list, def)

    -- textural representation must be inverted
    local gy = grid.h + 1 - y

    grid[x][gy] = elem
  end


  local function split_element(E, new_diagonal)
    assert(not E.diagonal)

    local top = table.copy(E)

    return { kind="diagonal", diagonal=new_diagonal, bottom=E, top=top }
  end


  local function check_compatible_elements(E1, E2)
    if E1.kind == "new_area" or E1.kind == "new_room" then
      error("bad element in " .. def.name .. ": cannot use 'A' or 'R' in match")
    end

    -- changing an area is OK
    if E1.kind == "area" and E2.kind == "area" then
      if E1.area != E2.area then
        E2.assignment = true

        def.area_growths[E2.area] = (def.area_growths[E2.area] or 0) + 1
        return
      end
    end

    -- same kind of thing is always acceptable
    if E1.kind == E2.kind then
      return
    end

    if E2.kind == "disable" and E1.kind != "free" then
      error("bad element in " .. def.name .. ": disable cannot remove stuff")
    end

    -- from here on, output element is an ASSIGNMENT
    -- i.e. setting something new or different into the seed(s)

    E2.assignment = true

    -- compute the growth of areas (how many seeds they add)
    if E2.kind == "area" then
      def.area_growths[E2.area] = (def.area_growths[E2.area] or 0) + 1
    end

    if E1.kind == "stair" or E1.kind == "joiner" or E1.kind == "closet" or
       E1.kind == "disable" or E1.kind == "magic"
    then
      error("bad element in " .. def.name .. ": cannot overwrite a " .. E1.kind)
    end

    if E2.kind == "magic" then
      error("bad element in " .. def.name .. ": cannot assign to a " .. E2.kind)
    end

    -- we cannot assign into a '.' (which means "not part of current room")
    if E1.kind == "free" then
      E1.utterly = 1
    end
  end


  local function add_style(name)
    if not def.styles then def.styles = {} end

    table.add_unique(def.styles, name)
  end


  local function check_added_stuff(E)
    if E.kind == "new_room" and not def.new_room then
      def.new_room = {}
    end

    if E.kind == "new_area" and not def.new_area then
      def.new_area = {}
    end

    if E.kind == "stair" then
      def.has_stair = true
    end

    if E.kind == "cage"    then add_style("cages")    end
    if E.kind == "closet"  then add_style("closets")  end
    if E.kind == "liquid"  then add_style("liquids")  end
    if E.kind == "hallway" then add_style("hallways") end
    if E.kind == "hall2"   then add_style("hallways") end
    if E.kind == "stair"   then add_style("steepness") end
  end


  local function finalize_element(x, y)
    local E1 = def.input [x][y]
    local E2 = def.output[x][y]

    if E1.diagonal and E2.diagonal and E1.diagonal != E2.diagonal then
      error("mismatched diagonals in " .. def.name)
    end

    -- if only one side is diagonal, split the other side
    if not E1.diagonal and E2.diagonal then
      def.input [x][y] = split_element(E1, E2.diagonal)
    elseif not E2.diagonal and E1.diagonal then
      def.output[x][y] = split_element(E2, E1.diagonal)
    end

    E1 = def.input [x][y]
    E2 = def.output[x][y]

    -- check assignment
    if E1.diagonal then
      check_compatible_elements(E1.top,    E2.top)
      check_compatible_elements(E1.bottom, E2.bottom)
    else
      check_compatible_elements(E1, E2)
    end

    -- check added stuff
    if E2.diagonal then
      check_added_stuff(E2.top)
      check_added_stuff(E2.bottom)
    else
      check_added_stuff(E2)
    end
  end


  local function convert_structure()
    local W = #def.structure[1]
    local H = #def.structure

    if (H % 2) != 0 then
      error("Malformed structure in grammar: " .. def.name)
    end

    H = H / 2

    diag_list = nil

    if def.diagonals then
      diag_list = table.copy(def.diagonals)
    end

    def.input  = table.array_2D(W, H)
    def.output = table.array_2D(W, H)

    -- must iterate line by line, then across each line
    for y = 1, H do
    for x = 1, W do
      convert_element("input",  def.input,  x, y)
      convert_element("output", def.output, x, y)
    end
    end
  end


  local function finalize_structure()
    def.area_growths = {}

    for x = 1, def.input.w do
    for y = 1, def.input.h do
      finalize_element(x, y)
    end
    end
  end


  local function test_mirror_elem(E1, E2, dir_map)
    -- check stair directions
    if dir_map and E1.dir and E2.dir then
      if E1.dir != dir_map[E2.dir] then return false end
    end

    return E1.kind == E2.kind and E1.area == E2.area
  end


  local function test_horiz_symmetry(grid, x, y)
    local x2 = grid.w - x + 1

    local E = grid[x ][y]
    local N = grid[x2][y]

    -- special check for seeds sitting on the axis
    if x == x2 then
      if E.kind == "stair" then return E.dir and geom.is_vert(E.dir) end

      if E.kind == "diagonal" then return false end

      return true
    end

    -- if one seed is a diagonal, the other must be too
    if not (E.diagonal and N.diagonal) then
      return test_mirror_elem(E, N, geom.MIRROR_X)
    end

    if N.diagonal == E.diagonal then
      return false
    end

    -- the nice thing about X mirroring of diagonals is that the
    -- bottom and top do not change places.

    return test_mirror_elem(E.bottom, N.bottom) and
           test_mirror_elem(E.top,    N.top)
  end


  local function is_horiz_symmetrical(grid)
    for x = 1, grid.w do
    for y = 1, grid.h do
      if not test_horiz_symmetry(grid, x, y) then
        return false
      end
    end
    end

    return true
  end


  local function test_vert_symmetry(grid, x, y)
    local y2 = grid.h - y + 1

    local E = grid[x][y]
    local N = grid[x][y2]

    -- special check for seeds sitting on the axis
    if y == y2 then
      if E.kind == "stair" then return E.dir and geom.is_horiz(E.dir) end

      if E.kind == "diagonal" then return false end

      return true
    end

    -- if one seed is a diagonal, the other must be too
    if not (E.diagonal and N.diagonal) then
      return test_mirror_elem(E, N, geom.MIRROR_Y)
    end

    if N.diagonal == E.diagonal then
      return false
    end

    -- Y mirroring will swap the bottom and top

    return test_mirror_elem(E.bottom, N.top) and
           test_mirror_elem(E.top,    N.bottom)
  end


  local function is_vert_symmetrical(grid)
    for x = 1, grid.w do
    for y = 1, grid.h do
      if not test_vert_symmetry(grid, x, y) then
        return false
      end
    end
    end

    return true
  end


  local function test_transpose_symmetry(grid, x, y)
    local E = grid[x][y]
    local N = grid[y][x]

    -- special check for seeds sitting on the axis
    if x == y then
      if E.kind == "stair" then return false end

      if E.kind != "diagonal" then return true end

      if E.diagonal == 1 then return true end

      return test_mirror_elem(E.bottom, E.top)
    end

    -- if one seed is a diagonal, the other must be too
    if not (E.diagonal and N.diagonal) then
      return test_mirror_elem(E, N, geom.TRANSPOSE)
    end

    if N.diagonal != E.diagonal then
      return false
    end

    -- a diagonal at right angles to the axis of mirroring?
    if E.diagonal == 1 then
      return test_mirror_elem(E.bottom, N.bottom) and
             test_mirror_elem(E.top,    N.top)
    end

    -- a diagonal in same direction as axis of mirroring: the sides
    -- will be swapped when mirrored.

    return test_mirror_elem(E.bottom, N.top) and
           test_mirror_elem(E.top,    N.bottom)
  end


  local function is_transpose_symmetrical(grid)
    if grid.w != grid.h then
      return false
    end

    for x = 1, grid.w do
    for y = 1, grid.h do
      if not test_transpose_symmetry(grid, x, y) then
        return false
      end
    end
    end

    return true
  end


  local function check_symmetries()
    if is_horiz_symmetrical(def.input) and
       is_horiz_symmetrical(def.output)
    then
      def.x_symmetry = true
    end

    if is_vert_symmetrical(def.input) and
       is_vert_symmetrical(def.output)
    then
      def.y_symmetry = true
    end

    if is_transpose_symmetrical(def.input) and
       is_transpose_symmetrical(def.output)
    then
      def.t_symmetry = true
    end
  end


  local function find_connections()
    -- TODO
  end


  -- NOTE: this code not used at the moment
  local function visit_contiguous_elem(x, y, kind, locs, seen)
    table.insert(locs, { x=x, y=y })

    seen[def.input[x][y]] = true

    for dir = 2,8,2 do
      local nx, ny = geom.nudge(x, y, dir)

      if nx < 1 or nx > def.input.w then continue end
      if ny < 1 or ny > def.input.h then continue end

      local E = def.output[nx][ny]

      if seen[E] then continue end

      -- TODO support diagonals here
      if E.kind == "diagonal" then
        if E.top.kind == kind or E.bottom.kind == kind then
          error("diagonal not supported for element: " .. tostring(kind))
        end
      end

      if E.kind == kind then
        visit_contiguous_elem(nx, ny, kind, locs, seen)
      end
    end
  end


  local function is_contig_part(kind, x, y, seen)
    local E2 = def.output[x][y]

    if E2.kind != kind then return false end

    if not E2.assignment then return false end

    return not seen[E2]
  end


  local function is_valid(x, y)
    if x < 1 or x > def.input.w then return false end
    if y < 1 or y > def.input.h then return false end

    return true
  end


  local function try_neighbor_part(kind, x, y, seen)
    if not is_valid(x, y) then return false end

    return is_contig_part(kind, x, y, seen)
  end


  local function mark_part_as_seen(kind, x, y, w, h, seen)
    for ex = x, x+w-1 do
    for ey = y, y+h-1 do
      if not is_contig_part(kind, ex, ey, seen) then
        error("bad structure: " .. kind .. " is not a pure rectangle")
      end

      local E2 = def.output[ex][ey]
      seen[E2] = true
    end
    end
  end


  local function determine_from_area(kind, x, y, dir)
    local E

    repeat
      x, y = geom.nudge(x, y, dir)
      if not is_valid(x, y) then return nil end

      E = def.output[x][y]
    until E.kind != kind

    -- FIXME : handle "diagonal"

    if E.kind != "area" then return nil end

    return E.area
  end


  local function find_info_for_part(kind, lx, ly)
    -- lx, ly is the lowest left corner of the part
    -- look for coordinate specific entry, e.g. "stair3_2"
    -- if that fails, look for generic entry e.g. "stair"

    local full_name = kind .. lx .. "_" .. ly

    return def[full_name] or def[kind]
  end


  local function get_contiguous_part(kind, x, y, seen)
    local w = 1
    local h = 1

    while try_neighbor_part(kind, x+w, y, seen) do w = w + 1 end
    while try_neighbor_part(kind, x, y+h, seen) do h = h + 1 end

    -- this also verifies the rectangle is all the same
    mark_part_as_seen(kind, x, y, w, h, seen)

    local rect = { kind=kind, x1=x, y1=y, x2=x+w-1, y2=y+h-1 }

    local E = def.output[x][y]

    -- grab "dir" from corresponding table, if present
    local info = find_info_for_part(kind, x, y)
    if info then
      table.merge_missing(rect, info)
    end

    if E.dir then
      rect.from_dir = 10 - E.dir
    else
      if not info then
        error("Missing " .. kind .. " info in grammar rule: " .. tostring(def.name))
      end

      assert(rect.from_dir)
    end

    rect.from_area = determine_from_area(kind, x, y, rect.from_dir)

    if not rect.shape then
      if rect.dest_dir then
        rect.shape = "L"
      elseif kind == "closet" then
        rect.shape = "U"
      else
        rect.shape = "I"
      end
    end

    if not def.rects then def.rects = {} end

    table.insert(def.rects, rect)
  end


  local function locate_all_contiguous_parts(kind)
    local seen = {}

    for x = 1, def.output.w do
    for y = 1, def.output.h do
      if is_contig_part(kind, x, y, seen) then
        get_contiguous_part(kind, x, y, seen)
      end
    end
    end
  end


  ---| Grower_preprocess_grammar |---

  gui.debugf("Grower_preprocess_grammar...\n")

  local grammar = SHAPE_GRAMMAR

  table.name_up(grammar)

  table.expand_templates(grammar)

  each name,cur_def in grammar do
    if cur_def.is_processed then continue end
    cur_def.is_processed = true

    gui.debugf("processing: %s\n", name)

    def = cur_def

    convert_structure()
    finalize_structure()
    check_symmetries()

    find_connections()

    locate_all_contiguous_parts("stair")
    locate_all_contiguous_parts("joiner")
    locate_all_contiguous_parts("closet")

    locate_all_contiguous_parts("link")
    locate_all_contiguous_parts("hallway")
    locate_all_contiguous_parts("hall2")

    if cur_def.pass == nil then
       cur_def.pass = name_to_pass(name)
    end

    if cur_def.is_hallway == nil then
       cur_def.is_hallway = string.match(name, "HALL_") and true
    end
  end
end



function Grower_calc_rule_probs()
  --
  -- Modify the probability of all rules, based on current game and
  -- theme, the chosen styles for the level, and a random factor.
  -- This gives each level a distinctive feel.
  --

  local function game_factor(rule)
    -- TODO : game_factor
    return 1
  end


  local function theme_factor(rule)
    -- TODO : theme_factor
    return 1
  end


  local function random_factor(rule)
    local default_skew = 2.0
    if string.match(rule.name, "AUX_") then default_skew = 1.2 end

    local prob_skew = rule.prob_skew or default_skew
    local half_skew = (1.0 + prob_skew) / 2.0

    local factor = rand.pick({ 1 / prob_skew, 1 / half_skew, 1.0, half_skew, prob_skew })

    return factor
  end


  local function style_factor(rule)
    if not rule.styles then return 1 end

    local factor = 1.0

    each name in rule.styles do
      if STYLE[name] == nil then
        error("Unknown style in grammar rule: " .. tostring(name))
      end

      factor = factor * style_sel(name, 0, 0.3, 1.0, 4.0)
    end

    return factor
  end


  local function calc_prob(rule)
    if rule.skip_prob then
      if rand.odds(rule.skip_prob) then return 0 end
    end

    local prob = rule.prob or 0

    prob = prob *   game_factor(rule)
    prob = prob *  theme_factor(rule)
    prob = prob *  style_factor(rule)
    prob = prob * random_factor(rule)

    return prob
  end


  ---| Grower_calc_rule_probs |---

  each name,rule in SHAPE_GRAMMAR do
    rule.use_prob = calc_prob(rule)
  end
end



function Grower_decide_boundary()
  --
  -- decide boundary rectangle
  --

  local map_size = (SEED_W + SEED_H) / 2

  if map_size < 20 then
    LEVEL.boundary_margin = 4
  elseif map_size < 30 then
    LEVEL.boundary_margin = 5
  else
    LEVEL.boundary_margin = 6
  end

  LEVEL.boundary_sx1 = LEVEL.boundary_margin
  LEVEL.boundary_sy1 = LEVEL.boundary_margin

  LEVEL.boundary_sx2 = SEED_W + 1 - LEVEL.boundary_margin
  LEVEL.boundary_sy2 = SEED_H + 1 - LEVEL.boundary_margin

  -- map edge calculation

  LEVEL.edge_margin = sel(map_size < 35, 2, 3)

  LEVEL.edge_sx1 = LEVEL.edge_margin
  LEVEL.edge_sy1 = LEVEL.edge_margin

  LEVEL.edge_sx2 = SEED_W + 1 - LEVEL.edge_margin
  LEVEL.edge_sy2 = SEED_H + 1 - LEVEL.edge_margin
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



function Grower_split_liquids()
  --
  -- Ensures the liquid areas in a room are contiguous, splitting them
  -- if they are consist of separate pieces.
  --
  -- Handles large cages too.
  --

  local good_areas = {}


  local function grow_contiguous_area(S, list)
    S.mark_contiguous = true

    table.insert(list, S)

    each dir in geom.ALL_DIRS do
      local N = S:neighbor(dir)

      if N and N.area == S.area and not N.mark_contiguous then
        grow_contiguous_area(N, list)
      end
    end
  end


  local function check_at_seed(S, mode)
    local A = S.area

    if not A then return end
    if not A.room then return end

    if A.mode != mode then return end

    -- already known to be contiguous?
    if good_areas[A] then return end

    local list = {}

    grow_contiguous_area(S, list)

    -- clear the marking flag
    each S in list do
      S.mark_contiguous = false
    end

    -- all seeds in the area are contiguous?
    if #list >= #A.seeds then
      good_areas[A] = true
      return
    end

    -- current area is not contiguous, need to split it

    local A2 = AREA_CLASS.new(mode)
    A2.room = A.room
    A2.room:add_area(A2)

    A2.seeds = list

    each S in A2.seeds do
      S.area = A2

      table.kill_elem(A.seeds, S)
    end

    good_areas[A2] = true
  end


  local function check_all_seeds(mode)
    for sx = 1, SEED_W do
    for sy = 1, SEED_H do
      local S = SEEDS[sx][sy]

      check_at_seed(S, mode)

      if S.top then
        check_at_seed(S.top, mode)
      end
    end  -- sx, sy
    end
  end


  local function handle_symmetry(R)
    each A in R.areas do
      if A.peer then continue end

      if A.mode == "liquid" or A.mode == "cage" then
        local S = A.seeds[1]

        assert(S)
        assert(S.area == A)

        local T = R.symmetry:transform(S)

        if T and T.area and T.area.room == R and T.area.mode == A.mode then
          A.peer = T.area
          T.area.peer = A
        end
      end
    end
  end


  ---| Grower_split_liquids |---

  check_all_seeds("liquid")
  check_all_seeds("cage")

  -- in symmetrical rooms, peer up the mirrored parts
  each R in LEVEL.rooms do
    if R.symmetry then
      handle_symmetry(R)
    end
  end
end



function Grower_new_prelim_conn(R1, R2, kind)
  local PC =
  {
    R1 = R1
    R2 = R2
  }

  if kind then
    PC.kind = kind
  end

  PC.R1.prelim_conn_num = PC.R1.prelim_conn_num + 1
  PC.R2.prelim_conn_num = PC.R2.prelim_conn_num + 1

  table.insert(LEVEL.prelim_conns, PC)

  return PC
end



function Grower_add_room(parent_R, force_env, trunk)
  local ROOM = ROOM_CLASS.new()

  ROOM.grow_parent = parent_R

  if trunk == nil then
    assert(parent_R)
    trunk = assert(parent_R.trunk)
  end

  ROOM.trunk = trunk
  table.insert(trunk.rooms, ROOM)

  local kind = "normal"

  if force_env == "hallway" then
    kind = "hallway"
  end

  -- pick room environment (outdoor / cave)
  local is_outdoor = false
  local is_cave = false

  if force_env == "outdoor" then
    is_outdoor = true
  elseif force_env == "building" then
    is_outdoor = false
  else
    is_outdoor, is_cave = Room_choose_kind(ROOM, parent_R)
  end

  Room_set_kind(ROOM, kind, is_outdoor, is_cave)

  -- FIXME : this 'grow_parent' is not used, keep it??
  if parent_R and parent_R.kind == "hallway" then
    parent_R = parent_R.grow_parent
  end

  -- always need at least one floor area
  local A = AREA_CLASS.new("floor")
  ROOM:add_area(A)

  -- max size of new area
  A.max_size = rand.pick({ 16, 24, 32 })

  -- create a preliminary connection (last room to this one)
  local PC

  if parent_R then
    PC = Grower_new_prelim_conn(ROOM, parent_R)
  end

  return ROOM, PC
end



function Grower_grammatical_room(R, pass)
  --
  -- Creates rooms using Shape Grammars.
  --

  local grammar = SHAPE_GRAMMAR

  local cur_rule
  local cur_symmetry

  -- this maps area numbers (1/2/3) in the current rule to temp-areas of
  -- the current room
  local area_map = {}

  local new_room
  local old_room

  local new_conn
  local new_area
  local new_intconn

  -- this is used to mark seeds for one side of a mirrored rule
  -- (in symmetrical rooms).
  local sym_token

  -- list of transformed rectangles (copied from cur_rule.rects)
  local new_chunks
  local old_chunks


  local function what_in_there(S)
    local A = S.area
    if not A then return "-" end
    if not A.room then return "?" end
    return A.name
  end


  local function unset_seed(S)
    local A = assert(S.area)
    assert(A.room)

    S.area = nil

    table.kill_elem(A.seeds, S)
  end


  local function set_seed(S, A)
    assert(A.room)

    if S.area == A then return end

    if S.area then
      assert(S.area.room == R)
      unset_seed(S)
    end

    S.area = A

    table.insert(A.seeds, S)

    -- update the room's growth bbox
    if A.room then
      local AR = A.room

      if not AR.gx1 or S.sx < AR.gx1 then AR.gx1 = S.sx end
      if not AR.gy1 or S.sy < AR.gy1 then AR.gy1 = S.sy end

      if not AR.gx2 or S.sx > AR.gx2 then AR.gx2 = S.sx end
      if not AR.gy2 or S.sy > AR.gy2 then AR.gy2 = S.sy end
    end
  end


  local function set_liquid(S)
    if not R.dummy_liquid then
       R.dummy_liquid = AREA_CLASS.new("liquid")
       R:add_area(R.dummy_liquid)
    end

    set_seed(S, R.dummy_liquid)
  end


  local function set_cage(S)
    if not R.dummy_cage then
       R.dummy_cage = AREA_CLASS.new("cage")
       R:add_area(R.dummy_cage)
    end

    set_seed(S, R.dummy_cage)
  end


  local function raw_blocked(S)
    if S.area then return true end
    if S.disabled_R == R then return true end

    -- never use a seed at edge of map
    if Seed_over_map_edge(S) then return true end

    return false
  end


  local function prob_for_rule(rule)
    -- the 'use_prob' field is computed earler, and already takes styles
    -- into account.

    local prob = rule.use_prob or 0

    if prob <= 0 then return 0 end

    -- environment check
    if rule.env != nil and rule.env != "any" then
      if rule.env != R:get_env() then return 0 end
    end

    return prob
  end


  local function prob_for_symmetry(R)
    if R.is_cave then return 0 end

    if R.is_outdoor then return 15 end

    return 40
  end


  local function collect_matching_rules(want_pass)
    local tab = {}

    each name,rule in grammar do
      if rule.pass != want_pass then continue end

      local prob = prob_for_rule(rule)

      if prob > 0 then
        tab[name] = prob
      end
    end

    return tab
  end


  local function calc_transform(transpose, flip_x, flip_y)
    local T =
    {
      flip_x = (flip_x > 0)
      flip_y = (flip_y > 0)

      transpose = (transpose > 0)
    }

    return T
  end


  local function transform_coord(T, px, py)
    px = px - 1
    py = py - 1

    if T.flip_x then px = -px end
    if T.flip_y then py = -py end

    if T.transpose then px, py = py, px end

    return T.x + px, T.y + py
  end


  local function transform_dir(T, dir)
    if T.flip_x then dir = geom.MIRROR_X[dir] end
    if T.flip_y then dir = geom.MIRROR_Y[dir] end

    if T.transpose then dir = geom.TRANSPOSE[dir] end

    return dir
  end


  local function transform_is_flippy(T)
    local res = false

    if T.flip_x then res = not res end
    if T.flip_y then res = not res end

    if T.transpose then res = not res end

    return res
  end


  local function transform_diagonal(T, dir, bottom, top)
    if T.flip_x then
      dir = geom.MIRROR_X[dir]
    end

    if T.flip_y then
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


  local function transform_rect(T, rect)
    local x1, y1 = transform_coord(T, rect.x1, rect.y1)
    local x2, y2 = transform_coord(T, rect.x2, rect.y2)

    if x1 > x2 then x1,x2 = x2,x1 end
    if y1 > y2 then y1,y2 = y2,y1 end

    return x1,y1, x2,y2
  end


  local function transform_symmetry(T)
    if not cur_rule.new_room then return nil end

    local info = cur_rule.new_room.symmetry
    if not info then return nil end

    if info.list then
      info = rand.pick(info.list)
    end

--FIXME
--if pass != "root" then return nil end

    local sym = Symmetry_new(info.kind or "mirror")

    sym.x, sym.y = transform_coord(T, info.x, info.y)

    if info.x2 then
      sym.x2, sym.y2 = transform_coord(T, info.x2, info.y2)

      if sym.x > sym.x2 then sym.x, sym.x2 = sym.x2, sym.x end
      if sym.y > sym.y2 then sym.y, sym.y2 = sym.y2, sym.y end
    end

    if info.dir then
      sym.dir = transform_dir(T, info.dir)
    end

    sym.wide = (info.w == 2)

    -- wide mode requires X and Y coord to be the lowest of the pair
    if sym.wide then
      local x2, y2 = geom.nudge(info.x, info.y, geom.RIGHT[info.dir])

      x2, y2 = transform_coord(T, x2, y2)

      sym.x = math.min(sym.x, x2)
      sym.y = math.min(sym.y, y2)
    end

    return sym
  end


  local function transform_connection(T, info, c_out)
    local sx, sy = transform_coord(T, info.x, info.y)
    assert(Seed_valid(sx, sy))

    local S = SEEDS[sx][sy]

    local dir2 = transform_dir(T, info.dir)

    if dir2 == 1 or dir2 == 3 then
      S = assert(S.top)
    end

    local long = info.w or 1

    if long > 1 and geom.is_straight(info.dir) and transform_is_flippy(T) then
      local across_dir = transform_dir(T, geom.RIGHT[info.dir])
      S = S:raw_neighbor(across_dir, long - 1)
    end

    c_out.S = S
    c_out.dir = dir2
    c_out.long = long
--[[
stderrf("transform_connection: (%d %d) dir %d --> (%d %d) S=%s dir=%d\n",
info.x, info.y, info.dir, sx, sy, S.name, dir2)
--]]
  end


  local function mark_connection_used(conn)
    local S = conn.S

    for i = 1, conn.long do
      local N = S:neighbor(conn.dir)
      assert(N)

      S.no_assignment = true
      N.no_assignment = true

      if geom.is_straight(conn.dir) then
        S = S:raw_neighbor(geom.RIGHT[conn.dir])
        assert(S)
      end
    end
  end


  local function get_iteration_range(T)
    if pass == "root" then
      local dx = math.min(10, int(SEED_W / 4))
      local dy = math.min(10, int(SEED_H / 4))

      local mx = int(SEED_W / 2)
      local my = int(SEED_H / 2)

      return mx-dx, my-dy, mx+dx, my+dy
    end


    -- firstly compute the bounding box that a pattern will occupy
    -- [ relative to any T.x, T.y coordinate being tried ]

    T.x = 0
    T.y = 0

    local W = cur_rule.input.w
    local H = cur_rule.input.h

    local dx1, dy1 = transform_coord(T, 1, 1)
    local dx2, dy2 = transform_coord(T, W, H)

    if dx1 > dx2 then dx1, dx2 = dx2, dx1 end
    if dy1 > dy2 then dy1, dy2 = dy2, dy1 end

--stderrf("\n\n Rule %s : %dx%d\n", cur_rule.name, W, H)
--stderrf("delta size: (%d %d) .. (%d %d)\n", dx1, dy1, dx2, dy2)

    -- secondly, compute the bounding box we *want* to cover
    -- [ namely the current room size expanded by size of pattern,
    --   then limited to the map itself ]

    if T.transpose then W, H = H, W end

    local x1 = R.gx1 - W
    local y1 = R.gy1 - H

    local x2 = R.gx2 + W
    local y2 = R.gy2 + H

--stderrf("raw want area : (%d %d) .. (%d %d)\n", x1,y1, x2,y2)

    x1 = math.max(x1, 1)
    y1 = math.max(y1, 1)

    x2 = math.min(x2, SEED_W)
    y2 = math.min(y2, SEED_H)

--stderrf("clipped want area : (%d %d) .. (%d %d)\n", x1,y1, x2,y2)

    -- finally, combine them

    x1 = x1 - dx1 ; y1 = y1 - dy1
    x2 = x2 - dx2 ; y2 = y2 - dy2

--stderrf("RESULT : (%d %d) .. (%d %d)\n\n", x1,y1, x2,y2)

    assert(x2 >= x1)
    assert(y2 >= y1)

    return x1, y1, x2, y2
  end


  local function convert_symmetrical_transform(sym, T)
    local T2 = table.copy(T)

    if sym.kind == "rotate" then
      T2.x = sym.x * 2 + (sym.x2 - sym.x) - T.x
      T2.y = sym.y * 2 + (sym.y2 - sym.y) - T.y

      T2.flip_x = not T2.flip_x
      T2.flip_y = not T2.flip_y

      return T2
    end

    if sym.dir == 2 or sym.dir == 8 then
      T2.x = sym.x * 2 + sel(sym.wide, 1, 0) - T.x

      if T.transpose then
        T2.flip_y = not T.flip_y
      else
        T2.flip_x = not T.flip_x
      end

      return T2
    end

    if sym.dir == 4 or sym.dir == 6 then
      T2.y = sym.y * 2 + sel(sym.wide, 1, 0) - T.y

      if T.transpose then
        T2.flip_x = not T.flip_x
      else
        T2.flip_y = not T.flip_y
      end

      return T2
    end

    if sym.dir == 1 or sym.dir == 9 then
      T2.x = sym.x + (T.y - sym.y)
      T2.y = sym.y + (T.x - sym.x)

      T2.transpose = not T.transpose

      return T2
    end

    if sym.dir == 3 or sym.dir == 7 then
      T2.x = sym.x - (T.y - sym.y)
      T2.y = sym.y - (T.x - sym.x)

      T2.transpose = not T.transpose
      T2.flip_x    = not T.flip_x
      T2.flip_y    = not T.flip_y

      return T2
    end

    error("convert_mirrored_transform: weird sym.dir")
  end


  local function is_element_a_chunk(E)
    return E.kind == "closet" or E.kind == "joiner" or
           E.kind == "stair"  or E.kind == "hallway"
  end


  local function find_chunk(sx, sy)
    if new_chunks then
      each K in new_chunks do
        if K.sx1 <= sx and sx <= K.sx2 and
           K.sy1 <= sy and sy <= K.sy2
        then
          return K
        end
      end
    end

    return nil
  end


  local function match_area(E1, A)
    if A.mode != "floor" then return false end

    if area_map[1] == A then return (E1.area == 1) end
    if area_map[2] == A then return (E1.area == 2) end
    if area_map[3] == A then return (E1.area == 3) end

    if area_map[E1.area] == nil then
      -- check if the area would grow too big
      local growth = cur_rule.area_growths[E1.area] or 0
      if growth > 0 and #A.seeds + growth > A.max_size then
        return false
      end

      -- don't create a brand new area when existing area is tiny
      if cur_rule.new_area then
        A:calc_volume()
        local area_min_size = sel(R.symmetry, 8, 4)
        if A.svolume < area_min_size then return false end
      end

      area_map[E1.area] = A
      return true
    end

    return false
  end


  local function match_a_magic_element(S, E1)
    local A = S.area

    if E1.what == "all" then return true end

    -- this one allows other rooms, and the '#' disable element
    -- FIXME : "closed" elements may not be useful, review this
    if E1.what == "closed" then
      if not A then return true end
      if A.room != R then return true end
      if S.disabled_R == R then return true end

      if A.chunk and A.chunk.kind == "closet" then return true end
      if A.chunk and A.chunk.kind == "joiner" then return true end

      return false
    end

    -- all other magic elements require an area and same room
    if not A then return false end
    if A.room != R then return false end
    if S.disabled_R == R then return false end

    if E1.what == "room" then
      return A and A.room == R
    end

    if E1.what == "floor" then
      return A.mode == "floor"
    end

    -- FIXME : this "open" element may not be useful, review this
    if E1.what == "open" then
      if A.chunk and A.chunk.kind == "closet" then return false end
      if A.chunk and A.chunk.kind == "joiner" then return false end

      return true
    end

    error("Unknown element kind: magic/" .. tostring(E1.what))
  end


  local function match_an_element(S, E1, E2, T)

    if E1.kind == "magic" then
      return match_a_magic_element(S, E1)
    end

    -- new rooms must not be placed in boundary spaces
    if (E2.kind == "new_room" or E2.kind == "hallway") and Seed_over_boundary(S) then
      return false
    end


    -- symmetry handling
    -- [ we prevent a pattern from overlapping its mirror ]
    -- [[ but we allow setting whole seeds *on* the axis of symmetry ]]
    -- [[[ except for new rooms and chunks, as they must remain distinct ]]]
    if T.is_first and E2.assignment then
      if E2.kind == "new_room" or
         is_element_a_chunk(E2) or
         not R.symmetry:on_axis(S.sx, S.sy)
      then
        S.sym_token = sym_token
      end
    end

    if T.is_second and E2.assignment then
      if S.sym_token == sym_token then
        return false
      end
    end

    -- for "!", require nothing there at all
    if E1.kind == "free" and E1.utterly then
      return not raw_blocked(S)
    end

    if E1.kind == "disable" then
      return (S.disabled_R == R)
    end

    -- prevent assigning an '#' onto one from a different room
    if E2.kind == "disable" then
      return not (S.disabled_R and S.disabled_R != R)
    end

    -- seed is locked out of further changes?
    if E2.assignment and (S.no_assignment or S.disabled_R == R) then
      return false
    end


    -- do we have an area in current room?
    local A = S.area
    if A and A.room != R then A = nil end

    if E1.kind == "free" then
      return not A
    end

    -- otherwise we require an area of this room
    if not (A and A.room == R) then return false end

    if E1.kind == "area" then
      return match_area(E1, A)
    end

    if E1.kind == "liquid" or
       E1.kind == "cage"
    then
      return (A.mode == E1.kind)
    end

    local chunk = S.chunk

    if E1.kind == "stair" then
      -- note: we do not check direction of stair
      return chunk and chunk.kind == "stair"
    end

    if E1.kind == "closet" then
      return chunk and chunk.kind == "closet"
    end

    error("Element kind not testable: " .. tostring(E1.kind))
  end


  local function install_an_element(S, E1, E2, T)
    if not E2.assignment then return end

    if E2.kind == "free" then
      if S.area then
        unset_seed(S)
      end

      return
    end

    if E2.kind == "disable" then
      if S.area then
        unset_seed(S)
      end

      -- prevent the seed being used by THIS room ever again
      -- [ however, OTHER rooms are allowed to use it ]
      S.disabled_R = R
      return
    end

    -- handle special rectangles (stairs, cages, traps)
    local chunk = find_chunk(S.sx, S.sy)
    if chunk then
      assert(chunk.area)
      set_seed(S, chunk.area)
      S.chunk = chunk
      return
    end

    if E2.kind == "area" then
      -- an assertion here usually means the grammar rule uses e.g. '2'
      -- in the output side but not in the input side.
      local A = assert(area_map[E2.area])
      set_seed(S, A)
      return
    end

    if E2.kind == "new_area" then
      assert(pass != "root")
      assert(new_area)

      set_seed(S, new_area)
      return
    end

    if E2.kind == "new_room" then
      assert(new_room)
      set_seed(S, new_room.areas[1])
      return
    end

    if E2.kind == "liquid" then
      set_liquid(S)
      return
    end

    -- this is for LARGE (free-range) cages
    -- [ prefab cages are done via "closet" elements ]
    if E2.kind == "cage" then
      set_cage(S)
      return
    end

    error("INSTALL : unsupported kind: " .. E2.kind)
  end


  local function match_or_install_B(what, S, E1, E2, T)
    if what == "TEST" then
      return match_an_element(S, E1, E2, T)
    end

    if E2.assignment then
      return install_an_element(S, E1, E2, T)
    end

    return true
  end


  local function match_or_install_element(what, E1, E2, T, px, py)

    local sx, sy = transform_coord(T, px, py)

    -- never allow patterns to touch edge of map
    -- [ TODO : relax this a bit? ]
    if sx <= 1 or sx >= SEED_W or
       sy <= 1 or sy >= SEED_H
    then
      return false
    end

    local S = SEEDS[sx][sy]

    local S2 = S.top or S


    -- simplest case : square on square

    if not E1.diagonal and not S.diagonal then
      return match_or_install_B(what, S, E1, E2, T)
    end


    -- fairly simple : square on diagonal

    if not E1.diagonal then
      assert(S.diagonal)

      if what == "TEST" then
        return match_an_element(S,  E1, E2, T) and
               match_an_element(S2, E1, E2, T)
      end

      if E2.assignment then
        if S .area then unset_seed(S)  end
        if S2.area then unset_seed(S2) end

        S:join_halves()

        install_an_element(S, E1, E2, T)
      end

      return true
    end


    assert(E1.diagonal)
    assert(E2.diagonal)


    -- in symmetrical rooms, forbid diagonals on axis of symmetry
    if (T.is_first or T.is_second) and R.symmetry:on_axis(sx, sy) then
      return false
    end


    local  dir, E1B, E1T = transform_diagonal(T, E1.diagonal, E1.bottom, E1.top)
    local zdir, E2B, E2T = transform_diagonal(T, E2.diagonal, E2.bottom, E2.top)


    -- diagonal on square

    if not S.diagonal then
      -- for the test, no need to remap anything
      if what == "TEST" then
        return match_an_element(S, E1B, E2B, T) and
               match_an_element(S, E1T, E2T, T)
      end

      if E2B.assignment or E2T.assignment then

        -- split the seed
        -- FIXME: this area shuffling logic is unnecessarily complex...
        local A = S.area
        if A then unset_seed(S) end

        S:split(math.min(dir, 10 - dir))
        S2 = S.top

        if A then
          set_seed(S,  A)
          set_seed(S2, A)
        end

        install_an_element(S,  E1B, E2B, T)
        install_an_element(S2, E1T, E2T, T)
      end

      return true
    end


    -- final case : diagonal on diagonal

    assert( S.diagonal)

    if not geom.is_parallel(S.diagonal, dir) then
          -- incompatible diagonals
      return false
    end

    local res1 = match_or_install_B(what, S , E1B, E2B, T)
    local res2 = match_or_install_B(what, S2, E1T, E2T, T)

    return res1 and res2
  end


  local function add_internal_conn(A1, A2, kind)
    local C =
    {
      kind = kind or "direct"

      A1 = A1
      A2 = A2
    }

    if cur_rule.has_stair then
      assert(not cur_rule.joiner)
      C.kind = "stair"
    end

    table.insert(R.internal_conns, C)

    return C
  end


  local function mark_chunk_nb_side(r, dir)
    assert(geom.is_straight(dir))

    local x1, y1 = r.sx1, r.sy1
    local x2, y2 = r.sx2, r.sy2

    if dir == 2 then y2 = y1 end
    if dir == 8 then y1 = y2 end
    if dir == 4 then x2 = x1 end
    if dir == 6 then x1 = x2 end

    for sx = x1, x2 do
    for sy = y1, y2 do
      local S = SEEDS[sx][sy]

      local N = S:neighbor(dir)
      assert(N)

      N.no_assignment = true
    end
    end
  end


  local function mark_chunk_neighbors(r)  -- UNUSED ????
    local shape = assert(r.shape)

    -- the "dir" generally faces its source
    -- [ but it won't matter when shape is "I" or "P" ]
    assert(r.dir)

    mark_chunk_nb_side(r, r.dir)

    -- this handles "L" shape
    if r.dir2 then
      mark_chunk_nb_side(r, r.dir2)
    end

    if shape == "I" or shape == "P" then
      mark_chunk_nb_side(r, 10 - r.dir)
    end

    if shape == "T" or shape == "P" then
      mark_chunk_nb_side(r, geom.LEFT [r.dir])
      mark_chunk_nb_side(r, geom.RIGHT[r.dir])
    end
  end


  local function install_create_chunks(T)
    new_chunks = {}

    local new_stairs = {}

    each r in cur_rule.rects do
      local x1,y1, x2,y2 = transform_rect(T, r)

      assert(r.kind)
      local chunk = Chunk_new(r.kind, x1,y1, x2,y2)

      if r.from_dir then chunk.from_dir = transform_dir(T, r.from_dir) end
      if r.dest_dir then chunk.dest_dir = transform_dir(T, r.dest_dir) end

      if r.kind == "stair" then
        chunk.place = "floor"
      else
        chunk.place = "whole"
      end

      chunk.shape = r.shape

      if r.from_area then
        chunk.from_area = assert(area_map[r.from_area])
      end

      table.insert(new_chunks, chunk)


      local A = AREA_CLASS.new("chunk")
      R:add_area(A)

      chunk.area = A
      A.chunk = chunk


      -- symmetry handling : peer up mirrored chunks and their areas
      if T.is_second then
        assert(old_chunks)

        local old_chunk = old_chunks[#new_chunks]
        assert(old_chunk)
        assert(old_chunk.kind == chunk.kind)

        chunk.peer = old_chunk
        old_chunk.peer = chunk

        A.peer = old_chunk.area
        old_chunk.area.peer = A
      end


      if r.kind == "stair" then
        chunk.dest_area = assert(new_area)
        assert(new_intconn)
        new_intconn.stair_chunk = chunk

        table.insert(new_stairs, chunk)

      elseif r.dest_area then
        chunk.dest_area = assert(area_map[r.dest_area])
      end

      if r.kind == "joiner" then
        assert(new_room)
        chunk.dest_area = new_room.areas[1]

        new_conn.kind = "joiner"
        new_conn.chunk = chunk

        -- connection goes from NEW ROOM --> CURRENT ROOM
        new_conn.A1  = assert(new_room.areas[1])
        new_conn.A2  = assert(chunk.from_area)
---stderrf("JOINER : %s / %s (%s) --> %s / %s (%s)\n",
---  R.name, new_conn.TA1.name, new_conn.TA1.room.name,
---  new_room.name, new_conn.TA2.name, new_conn.TA2.room.name)

--???        assert(chunk.dir)
--???        chunk.dir = transform_dir(T, chunk.dir)
      end

      if r.kind == "closet" then table.insert(R.closets, chunk) end
      if r.kind == "stair"  then table.insert(R.stairs,  chunk) end
      if r.kind == "joiner" then table.insert(R.joiners, chunk) end
    end

    -- if a rule adds multiple stairs, link them so we can use
    -- the same prefab for them all.

    if #new_stairs >= 2 then
      local stair_group = { chunks=new_stairs }
      each chunk in new_stairs do
        chunk.stair_group = stair_group
      end
    end
  end


  local function pre_install(T)
    old_room = new_room
    new_room = nil

    new_conn = nil

    old_chunks = new_chunks
    new_chunks = nil

    -- for initial shapes, 'R' is the current room
    if pass == "root" then
      new_room = R
    else
      if cur_rule.new_room then
        new_room, new_conn = Grower_add_room(R, cur_rule.new_room.env)
      end
    end

    if cur_rule.new_area and not new_area then
      new_area = AREA_CLASS.new("floor")

      -- max size of new area
      new_area.max_size = rand.pick({ 16, 24, 32 })

      R:add_area(new_area)

      local from_area_idx = cur_rule.new_area.from_area or 1
      local from_area = assert(area_map[from_area_idx])

      new_intconn = add_internal_conn(from_area, new_area)
    end

    if cur_rule.rects then
      install_create_chunks(T)
    end
  end


  local function post_install(T)
    Seed_squarify()

    if new_room then
      local sym_prob = prob_for_symmetry(new_room)

      if rand.odds(sym_prob) then
        -- assumes best.T has set X/Y to best.x and best.y
        new_room.symmetry = transform_symmetry(T)

--##    stderrf("new_room.symmetry :\n%s\n", table.tostr(new_room.symmetry))
      end

      if pass == "sprout" then
        transform_connection(T, cur_rule.new_room.conn, new_conn)

        mark_connection_used(new_conn)
      end
    end
  end


  local function match_or_install_pat_raw(what, T)
    if what == "INSTALL" then pre_install(T) end

    for px = 1, cur_rule.input.w do
    for py = 1, cur_rule.input.h do
      local E1 = cur_rule.input [px][py]
      local E2 = cur_rule.output[px][py]

      local res = match_or_install_element(what, E1, E2, T, px, py)

      if what == "TEST" and not res then
        -- cannot place this shape here (something in the way)
        return false
      end
    end -- px, py
    end

--[[ DEBUG
if what == "INSTALL" then
stderrf("=== install_pattern %s @ (%d %d) ===\n", cur_rule.name, T.x, T.y)
stderrf("T =\n%s\n", table.tostr(T))
end
--]]

    if what == "INSTALL" then post_install(T) end

    return true
  end


  local function try_straddling_pattern(what, T)
    -- this handles a pattern which is symmetrical and which is sitting
    -- exactly at the right spot to be usable ONCE in a symmetrical room
    -- (i.e. perfectly straddling the axis of symmetry).

    if pass == "root" then return false end

    if R.symmetry.kind != "mirror" then return false end

    if geom.is_vert(R.symmetry.dir) then
      if T.transpose then return false end
    elseif geom.is_horiz(R.symmetry.dir) then
      if not T.transpose then return false end
    else
      -- never for diagonal axis of symmetry
      return false
    end

    if not cur_rule.x_symmetry then return false end

    local W = cur_rule.input.w
    local H = cur_rule.input.h

    -- width must be odd/even to match R.symmetry mode
    if (W % 2) != sel(R.symmetry.wide, 0, 1) then return false end

    -- get transformed bbox of pattern
    local bx1, by1 = transform_coord(T, 1, 1)
    local bx2, by2 = transform_coord(T, W, H)

    if bx1 > bx2 then bx1, bx2 = bx2, bx1 end
    if by1 > by2 then by1, by2 = by2, by1 end

    -- check that it straddles at right spot
    if T.transpose then
      if by1 != R.symmetry.y - int((W-1) / 2) then return false end
    else
      if bx1 != R.symmetry.x - int((W-1) / 2) then return false end
    end

    if match_or_install_pat_raw(what, T) then
      return true
    end

    return false
  end


  local function match_or_install_pattern(what, T, x, y)
    T.x = x
    T.y = y

    if what == "TEST" then
      area_map[1] = nil
      area_map[2] = nil
      area_map[3] = nil
    else
      new_area = nil
      new_intconn = nil
    end

--stderrf("=== match_or_install_pattern %s @ (%d %d) ===\n", cur_rule.name, x, y)
    T.is_first  = nil
    T.is_second = nil

    if R.symmetry and try_straddling_pattern(what, T) then

--[[ DEBUG
if what == "INSTALL" then
stderrf("[ straddler ]\n")
stderrf("T =\n%s\n", table.tostr(T))
end
--]]
      return true
    end

    if R.symmetry then
      local T2 = convert_symmetrical_transform(R.symmetry, T)

      T2.is_first  = true
      T .is_second = true

--stderrf("SYMMETRICAL ROOM : match_or_install_pattern\n")
--stderrf("T = \n%s\n", table.tostr(T))
--stderrf("T2 = \n%s\n", table.tostr(T2))

      sym_token = alloc_id("sym_token")

      if not match_or_install_pat_raw(what, T2) then
        return false
      end
    end

    return match_or_install_pat_raw(what, T)
  end


  local function try_apply_a_rule()
    --
    -- Test all eight possible transforms (four rotations + mirroring)
    -- in all possible locations in the room.  If at least one is
    -- successful, pick it and apply the substitution.
    --

--stderrf("Trying rule '%s'...\n", cur_rname)

    local best = { score=-1 }

    -- no need to mirror a symmetrical pattern
    local transp_max = sel(cur_rule.t_symmetry, 0, 1)
    local flip_x_max = sel(cur_rule.x_symmetry, 0, 1)
    local flip_y_max = sel(cur_rule.y_symmetry, 0, 1)

    for transpose = 0, transp_max do
    for flip_x = 0, flip_x_max do
    for flip_y = 0, flip_y_max do
      local T = calc_transform(transpose, flip_x, flip_y)

      local x1,y1, x2,y2 = get_iteration_range(T)

      for x = x1, x2 do
      for y = y1, y2 do
        local score = gui.random() * 100

        if score < best.score then continue end

        if match_or_install_pattern("TEST", T, x, y) then
          best.T = T
          best.x = x
          best.y = y
          best.score = score

          -- this is less memory hungry than copying the whole table
          best.area_1 = area_map[1]
          best.area_2 = area_map[2]
          best.area_3 = area_map[3]
        end
      end -- x, y
      end
    end -- transp, flip_x, flip_y
    end
    end

    if best.score < 0 then
      return false
    end

    -- ok --

    area_map[1] = best.area_1
    area_map[2] = best.area_2
    area_map[3] = best.area_3

    match_or_install_pattern("INSTALL", best.T, best.x, best.y)

    return true
  end


  local function auxiliary_name(index)
    local name = "auxiliary"

    if index >= 2 then
      name = name .. index
    end

    return name
  end


  local function apply_a_rule(rule_tab, doing_aux)
    local rules = table.copy(rule_tab)

    local loop = 0
    local max_loop = 20

    repeat
      -- tried too many?
      loop = loop + 1

      if loop > max_loop then return end

      -- nothing left to try?
      if table.empty(rules) then return end

      local name = rand.key_by_probs(rules)

      if name == "STOP" then return end

      cur_rule = assert(grammar[name])

      -- don't try this rule again
      rules[name] = nil

    until try_apply_a_rule()

    -- SUCCESS --

    gui.debugf("Applied grammar rule %s\n", cur_rule.name)

    -- apply any auxiliary rules
    -- TODO : support multiple sets

    -- for performance reasons, only support one layer of recursion
    if doing_aux then return end

    if not cur_rule.auxiliary then return end

    -- we modify 'cur_rule', so need to remember it here
    local parent_rule = cur_rule

    for aux = 1,9 do
      local aux_name = auxiliary_name(aux)

      local aux = parent_rule[aux_name]
      if aux == nil then continue end

      assert(aux.pass)
      local aux_rules = collect_matching_rules(aux.pass)

      -- 'count' can be a number or a range of values: { low,high }
      local num = aux.count

      if type(num) == "table" then
        num = rand.irange(num[1], num[2])
      end

      for i = 1, num do
        apply_a_rule(aux_rules, "doing_aux")
      end
    end
  end


  ---| Grower_grammatical_room |---

-- stderrf("\n Grow room %s : %s pass\n", R.name, pass)

  if pass != "root" then
    assert(R.gx1) ; assert(R.gy2)
  end

  local apply_num = rand.pick({ 10,20,30 })

  -- TODO: often no sprouts when room is near edge of map

  if pass == "root" then apply_num = 1 end
  if pass == "sprout" then apply_num = rand.pick({ 1,1,2,2,2,3 }) end
  if pass == "decorate" then apply_num = 7 end --- TODO

  local rule_tab = collect_matching_rules(pass)

  if pass == "grow"     then rule_tab["STOP"] =  5 end
  if pass == "decorate" then rule_tab["STOP"] = 10 end

  for loop = 1, apply_num do
    -- stderrf("LOOP %d\n", loop)
    apply_a_rule(rule_tab)
  end
end



function Grower_create_trunks()
  --
  -- Multiple trunks require teleporters to connect them
  -- (at the moment, anyway).
  --
  -- There are three basic configurations:
  --    1. a single trunk, can spawn anywhere
  --    2. two trunks, at two opposite corners of the map
  --    3. three or four trunks, at each corner of the map
  --

  local trunk_num = 1

  LEVEL.trunks = {}


  if PARAM.teleporters then
    local prob1 = style_sel("teleporters", 0, 30, 60, 99)
    local prob2 = style_sel("teleporters", 0, 20, 40, 60)

    if rand.odds(prob1) then
      trunk_num = trunk_num + 1

      if rand.odds(prob2) then trunk_num = trunk_num + 1 end
      if rand.odds(prob2) then trunk_num = trunk_num + 1 end
    end
  end


  for i = 1, trunk_num do
    local trunk =
    {
      id = alloc_id("trunk")
      rooms = {}
    }

    trunk.name = string.format("TRUNK_%d", trunk.id)

    table.insert(LEVEL.trunks, trunk)

    local R = Grower_add_room(nil, nil, trunk)  -- no parent

    Grower_grammatical_room(R, "root")
  end
end



function Grower_grow_rooms()

  local function grow_some(no_new)
    local room_list = table.copy(LEVEL.rooms)

    rand.shuffle(room_list)

    each R in room_list do
      if not R.is_grown then
        R.is_grown = true

        Grower_grammatical_room(R, "grow")

        if not no_new then
          Grower_grammatical_room(R, "sprout")
        end
      end
    end
  end


  ---| Grower_grow_rooms |---

  for loop = 1, 50 do
    grow_some()
  end

  grow_some("no_new")
end



function Grower_decorate_rooms()
  local room_list = table.copy(LEVEL.rooms)

  -- TODO : do buildings before outdoor/cave
  --        __OR__  do certain "phases" in different orders
  --                e.g. adding cages/traps BEFORE expanding outdoors/caves

  rand.shuffle(room_list)

  each R in room_list do
    Grower_grammatical_room(R, "decorate")
  end
end



function Grower_prune_small_rooms()

  local function is_leaf(R)
    local conns = 0

    each PC in LEVEL.prelim_conns do
      if PC.R1 == R or PC.R2 == R then
        conns = conns + 1
      end
    end

    return conns < 2
  end


  local function is_too_small(R)
    return R:calc_walk_vol() < 8
  end


  local function kill_joiner(N, chunk)
    gui.debugf("  killing joiner in %s\n", N.name)

    -- the chunk becomes a closet

    chunk.kind = "closet"

    chunk.dest_dir  = nil
    chunk.dest_area = nil
    chunk.shape = "U"

    table.kill_elem(N.joiners, chunk)
    table.insert(N.closets, chunk)

    -- remove peering too
    if chunk.peer then
      chunk.peer.peer = nil
      chunk.peer = nil
    end
  end


  local function kill_prelim_conn(PC)
    PC.kind  = "DEAD"
    PC.R1    = nil
    PC.R2    = nil
    PC.chunk = nil

    table.kill_elem(LEVEL.prelim_conns, PC)
  end


  local function prune_room(R)
    -- TODO : possibly give areas to a connected neighbor room

    gui.debugf("Prune small room %s\n", R.name)

    -- remove any prelim conns
    for idx = #LEVEL.prelim_conns, 1, -1 do
      local PC = LEVEL.prelim_conns[idx]

      -- get neighbor room
      local N
      if PC.R1 == R then N = PC.R2 end
      if PC.R2 == R then N = PC.R1 end

      if not N then continue end

      gui.debugf("  killing prelim conn to %s\n", N.name)

      if PC.kind == "joiner" and PC.chunk.area.room == N then
        kill_joiner(N, PC.chunk)
      end

      kill_prelim_conn(PC)
    end

    R:kill_it()
  end


  local function become_hallway(R)
    gui.debugf("Hallwaying small room %s\n", R.name)

    R.kind = "hallway"
  end


  local function kill_trunk(TR)
    TR.name = "DEAD_" .. TR.name

    table.kill_elem(LEVEL.trunks, TR)

    -- sanity check
    each R in LEVEL.rooms do
      assert(R.trunk != TR)
    end
  end


  local function prune_trunks()
    for idx = #LEVEL.trunks, 1, -1 do
      local trunk = LEVEL.trunks[idx]

      if table.empty(trunk.rooms) then
        kill_trunk(trunk)
      end
    end
  end


  ---| Grower_prune_small_rooms |---

  -- killing a room may cause another room to become a leaf, hence
  -- we need multiple passes.

  repeat
    local changes = false

    for idx = #LEVEL.rooms, 1, -1 do
      local R = LEVEL.rooms[idx]

      if is_leaf(R) and is_too_small(R) then
        prune_room(R)
        changes = true
      end
    end
  until not changes

  -- turn any other small rooms into hallways
  -- [ cannot remove them since they are not leafs ]

  each R in LEVEL.rooms do
    if is_too_small(R) then
      become_hallway(R)
    end
  end

  -- a trunk may have become empty, prune these too
  prune_trunks()

  -- sanity check
  if table.empty(LEVEL.rooms) then
    error("All rooms were pruned")
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

    local is_outdoor = false
    local is_cave    = false

    if (R1.is_cave and R2.is_cave  and rand.odds(90)) or
       ((R1.is_cave or R2.is_cave) and rand.odds(60))
    then
      is_cave = true
    end

    if (R1.is_outdoor and R2.is_outdoor and rand.odds(50)) or
       ((R1.is_outdoor or R2.is_outdoor) and rand.odds(25)) or
       ((H.svolume or 0) >= 3 and rand.odds(5))
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

      if not S.diagonal and not S.area and not S.temp_area then
        -- a whole unused seed : split into two
        S:split(rand.sel(50, 1, 3))
      end

      S2 = S.top

      if S  and not S .area and not S .temp_area then S .temp_area = new_temp_area(S)  end
      if S2 and not S2.area and not S2.temp_area then S2.temp_area = new_temp_area(S2) end
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
    assert(A1.room == nil)

    local best_A2
    local best_score = 0

    each S in A1.seeds do
    each dir in geom.ALL_DIRS do
      local N = S:neighbor(dir)

      if not (N and N.temp_area) then continue end

      local A2 = N.temp_area

      if A2 == A1 then continue end

      if A2.room then continue end

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
    if T1.room or T2.room then return false end


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


  local function make_real_areas()
    each temp in temp_areas do
      local A = AREA_CLASS.new("scenic")

      A.seeds = temp.seeds
      A.touches_edge = temp.touches_edge

      -- install into seeds
      each S in A.seeds do
        S.area = A
        S.temp_area = nil
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



function Grower_create_rooms()
  LEVEL.sprouts = {}

  -- we don't make real connections until later (Connect_stuff)
  LEVEL.prelim_conns = {}

  Grower_calc_rule_probs()
  Grower_decide_boundary()

  Grower_create_trunks()
  Grower_grow_rooms()

  Grower_prune_small_rooms()

  Grower_decorate_rooms()
  Grower_split_liquids()

  Grower_fill_gaps()

  Seed_squarify()

--DEBUG
  if OB_CONFIG.svg then
    Seed_save_svg_image("grow_" .. OB_CONFIG.seed .. "_" .. LEVEL.name .. ".svg")
  end
end

