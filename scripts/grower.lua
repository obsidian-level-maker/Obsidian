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



function Grower_preprocess_grammar(grammar)
  
  local def
  local diag_list


  local function name_to_pass(name)
    if string.match(name, "ROOT_")     then return "root" end
    if string.match(name, "GROW_")     then return "grow" end
    if string.match(name, "SPROUT_")   then return "sprout" end
    if string.match(name, "DECORATE_") then return "decorate" end

    error("Unknown pass for grammar " .. tostring(name))
  end


  local function parse_element(ch, what)
    if ch == '.' then return { kind="free" } end
    if ch == '!' then return { kind="free", utterly=1 } end

    if ch == 'x' then return { kind="dont_care" } end
    if ch == 'X' then return { kind="dont_care" } end

    if ch == '~' then return { kind="liquid" } end
    if ch == '#' then return { kind="solid" } end

    if ch == '1' then return { kind="area", area=1 } end
    if ch == '2' then return { kind="area", area=2 } end
    if ch == '3' then return { kind="area", area=3 } end

    -- straight stairs
    if ch == '<' then return { kind="stair", dir=4 } end
    if ch == '>' then return { kind="stair", dir=6 } end
    if ch == '^' then return { kind="stair", dir=8 } end
    if ch == 'v' then return { kind="stair", dir=2 } end

    -- other stuff
    if ch == 'A' then return { kind="new_area" } end
    if ch == 'R' then return { kind="new_room" } end
    if ch == 'H' then return { kind="hallway"  } end

    if ch == 'C' then return { kind="cage"   } end
    if ch == 'T' then return { kind="closet" } end
    if ch == 'J' then return { kind="junction" } end

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

    if E1.kind == "stair" then
      if E2.kind != "stair" or E2.dir != E1.dir then
        error("bad element in " .. def.name .. ": cannot modify a stair")
      end
    end

    -- changing an area is OK
    if E1.kind == "area" and E2.kind == "area" then
      if E1.area != E2.area then
        E2.assignment = true
        return
      end
    end

    -- same kind of thing is always acceptable
    if E1.kind == E2.kind then
      return
    end

    -- from here on, output element is an ASSIGNMENT
    -- i.e. setting something new or different into the seed(s)

    E2.assignment = true

    if E1.kind == "dont_care" then
      error("bad element in " .. def.name .. ": cannot overwrite an 'X'")
    end

    if E2.kind == "dont_care" then
      error("bad element in " .. def.name .. ": 'X' used in assignment")
    end

    -- we cannot assign into a '.' (which means "not part of current room")
    if E1.kind == "free" then
      E1.utterly = 1
    end
  end


  local function check_added_stuff(E)
    if E.kind == "new_room" and not def.new_room then
      def.new_room = { }
    end

    if E.kind == "new_area" and not def.new_area then
      def.new_area = { }
    end
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
      if E.kind == "stair" then return geom.is_vert(E.dir) end

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
      if E.kind == "stair" then return geom.is_horiz(E.dir) end

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


  local function try_neighbor_part(kind, x, y, seen)
    if x < 1 or x > def.input.w then return false end
    if y < 1 or y > def.input.h then return false end

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


  local function get_contiguous_part(kind, x, y, seen)
    local w = 1
    local h = 1

    while try_neighbor_part(kind, x+w, y, seen) do w = w + 1 end
    while try_neighbor_part(kind, x, y+h, seen) do h = h + 1 end

    -- this also verifies the rectangle is all the same
    mark_part_as_seen(kind, x, y, w, h, seen)

    local info = { x1=x1, y1=y1, x2=x+w-1, y2=y+h-1, kind=kind }

    local tab_name = kind .. "_list"

    -- create list if not already there
    if not def[tab_name] then def[tab_name] = { } end

    table.insert(def[tab_name], info)
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

  table.name_up(grammar)

  table.expand_templates(grammar)

  each name,cur_def in grammar do
    def = cur_def

-- stderrf("Grower_preprocess_grammar... %s\n", name)
    convert_structure()
    finalize_structure()
    check_symmetries()

    find_connections()

    locate_all_contiguous_parts("stair")
    locate_all_contiguous_parts("cage")
    locate_all_contiguous_parts("closet")
    locate_all_contiguous_parts("junction")

    if not cur_def.pass then
      cur_def.pass = name_to_pass(name)
    end
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

  Grower_preprocess_grammar(SHAPE_GRAMMAR)
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



function Grower_make_areas(temp_areas)
  each idx,temp in temp_areas do
    local area = AREA_CLASS.new("void")

    area.seeds = temp.seeds

    if temp.room then
      area.mode = temp.mode

      area.svolume = temp.svolume or 0  -- FIXME: can be used too early

      temp.room:add_area(area)
    end

    -- install into seeds
    each S in area.seeds do
      S.area = area
      S.room = temp.room

      S.temp_area = nil
    end
  end
end


function Grower_make_all_areas()
  each R in LEVEL.rooms do
    Grower_make_areas(R.temp_areas)
  end

  if LEVEL.gap_areas then
    Grower_make_areas(LEVEL.gap_areas)
  end

  -- sanity check [ no seeds should have a 'temp_area' now... ]

  for sx = 1, SEED_W do
  for sy = 1, SEED_H do
  for pass = 1, 2 do
    local S = SEEDS[sx][sy]
    if pass == 2 then S = S.top end
if S and S.temp_area then
stderrf("FUCKING SHITE : %s\n", tostring(S.temp_area.mode))
end
    if S then assert(not S.temp_area) end
  end
  end
  end
end


function Grower_temp_area(R, mode)
  local A =
  {
    id = alloc_id("gram_area")
    mode = mode
    room = R
    seeds = {}
    svolume = 0
  }

  A.name = string.format("TEMP_AREA_%d", A.id)

  return A
end



function Grower_add_room(parent_R, is_hallway)
  local ROOM = ROOM_CLASS.new()

  ROOM.grow_parent = parent_R

  local kind = sel(is_hallway, "hallway", "normal")

  -- pick room environment (outdoor / cave)
  local is_outdoor, is_cave = Room_choose_kind(ROOM, parent_R)

  Room_set_kind(ROOM, kind, is_outdoor, is_cave)

  -- always need at least one temp-area
  ROOM.temp_areas = {}
  ROOM.temp_areas[1] = Grower_temp_area(ROOM, "floor")

  -- create a preliminary connection (last room to this one)

  local PC

  if parent_R then
    PC =
    {
      R1 = ROOM
      R2 = parent_R
    }

    PC.R1.prelim_conn_num = PC.R1.prelim_conn_num + 1
    PC.R2.prelim_conn_num = PC.R2.prelim_conn_num + 1

    table.insert(LEVEL.prelim_conns, PC)
  end

  return ROOM, PC
end



function Grower_grammatical_room(R, pass)
  --
  -- Creates rooms using Shape Grammars.
  --

  local grammar = SHAPE_GRAMMAR

  local rule_tab
  local cur_rule
  local cur_symmetry

  -- this maps area numbers (1/2/3) in the current rule to temp-areas of
  -- the current room
  local area_map = {}

  local new_room
  local new_conn
  local new_area
  local new_cage

  -- this is used to mark seeds for one side of a mirrored rule
  -- (in symmetrical rooms).
  local sym_token


  local function what_in_there(S)
    if not S.temp_area then return "-" end
    if not S.temp_area.room then return "?" end
    return S.temp_area.name
  end


  local function unset_seed(S)
    local A = assert(S.temp_area)
    assert(A.room)

    S.temp_area = nil

    table.kill_elem(A.seeds, S)

    -- FIXME: uggghhhh, do this elsewhere!!!
    local vol = sel(S.diagonal, 0.5, 1.0)
    A.svolume = A.svolume - vol
    A.room.svolume = A.room.svolume - vol
  end


  local function set_seed(S, A)
    assert(A.room)

    if S.temp_area == A then return end

    if S.temp_area then
stderrf("overwrite seed @ %s\n", S.name)
      assert(S.temp_area.room == R)
      unset_seed(S)
    end

    S.temp_area = A

    table.insert(A.seeds, S)

    -- update the room's growth bbox
    if A.room then
      local AR = A.room

      if not AR.gx1 or S.sx < AR.gx1 then AR.gx1 = S.sx end
      if not AR.gy1 or S.sy < AR.gy1 then AR.gy1 = S.sy end

      if not AR.gx2 or S.sx > AR.gx2 then AR.gx2 = S.sx end
      if not AR.gy2 or S.sy > AR.gy2 then AR.gy2 = S.sy end
    end

    -- FIXME: uggghhhh, do this elsewhere!!!
    local vol = sel(S.diagonal, 0.5, 1.0)
    A.svolume = A.svolume + vol
    A.room.svolume = A.room.svolume + vol
  end


  local function raw_blocked(S)
    if S.area then return true end
    if S.temp_area then return true end

    if S.sx <= 1 or S.sx >= SEED_W then return true end
    if S.sy <= 1 or S.sy >= SEED_H then return true end

    return false
  end


  local function check_enough_room__OLD()
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


  local function prob_for_rule(rule)
    if not rule.prob then return 0 end

    -- if (rule.pass or 1) != cur_pass then return 0 end

    -- TODO style adjustments
    -- TODO environment check??

    return rule.prob
  end


  local function collect_appropriate_rules()
    rule_tab = {}

    each name,rule in grammar do
      if rule.pass != pass then continue end

      local prob = prob_for_rule(rule)

      if prob > 0 then
        rule_tab[name] = prob
      end
    end
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


  local function transform_symmetry(T)
    if not cur_rule.new_room then return nil end

    local info = cur_rule.new_room.symmetry
    if not info then return nil end

    -- TODO : proper chance of not using the symmetry
    -- if not rand.odds(symmetry_prob) return nil end

    if info.list then
      info = rand.pick(info.list)
    end

--FIXME
--if pass != "root" then return nil end

    local sym = {}

    sym.x, sym.y = transform_coord(T, info.x, info.y)

    if info.x2 then
      sym.x2, sym.y2 = transform_coord(T, info.x2, info.y2)

      if sym.x > sym.x2 then sym.x, sym.x2 = sym.x2, sym.x end
      if sym.y > sym.y2 then sym.y, sym.y2 = sym.y2, sym.y end
    end

    if info.dir then
      sym.dir = transform_dir(T, info.dir)
    end

    sym.kind = info.kind or "mirror"
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
stderrf("transform_connection: (%d %d) dir %d --> (%d %d) S=%s dir=%d\n",
info.x, info.y, info.dir, sx, sy, S.name, dir2)
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

    local x1 = R.gx1 - (W - 1)
    local y1 = R.gy1 - (H - 1)

    local x2 = R.gx2 + (W - 1)
    local y2 = R.gy2 + (H - 1)

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


  local function on_axis_of_symmetry(sx, sy)
    -- no axis for 180-degree rotational symmetry
    if R.symmetry.kind == "rotate" then return false end

    -- on the "wide" version, axis is the line between two seeds
    if R.symmetry.wide then return false end

    if R.symmetry.dir == 2 or R.symmetry.dir == 8 then
      return sx == R.symmetry.x
    end

    if R.symmetry.dir == 4 or R.symmetry.dir == 6 then
      return sy == R.symmetry.y
    end

    local dx = R.symmetry.x - sx
    local dy = R.symmetry.y - sy

    if R.symmetry.dir == 3 or R.symmetry.dir == 7 then
      dx = -dx
    end

    return dx == dy
  end


  local function OLD__try_widen_connection(S)
    if not geom.is_straight(new_conn.dir) then return end

    if new_conn.long != 1 then return end

    local N = S:neighbor(10 - new_conn.dir)

    -- check that the area in parent room is the same
    if not (N and N.temp_area and N.temp_area.room == R) then return end

    if N.temp_area != new_conn.S.temp_area then return end

    -- check that seeds are side-by-side
    local SL = new_conn.S:neighbor(geom.LEFT [new_conn.dir])
    local SR = new_conn.S:neighbor(geom.RIGHT[new_conn.dir])

    if N != SR and N != SL then
      return  -- no good
    end

    -- OK --

    new_conn.long = 2

    if N == SL then
      new_conn.S = N
    end

    S.no_assignment = true
    N.no_assignment = true
  end


  local function OLD__check_connection(S)
    -- find connection between new room and old room

    -- FIXME : this is way too simplistic
    --         [ really need some processing of the rule itself ]

    assert(new_conn)

    if new_conn.S then
      -- try to widen an existing conn
      try_widen_connection(S)
      return
    end

    each dir in geom.ALL_DIRS do
      local N = S:neighbor(dir)

      if N and N.temp_area and N.temp_area.room == R and
         N.temp_area.mode == "floor"
      then
        assert(new_conn.R1 == R)
        assert(new_conn.R2 == new_room)

        S.no_assignment = true
        N.no_assignment = true

        new_conn.S = N
        new_conn.dir = 10-dir
        new_conn.long = 1
        return
      end
    end
  end


  local function OLD__check_for_conns()
    if check_seeds then
      each S in check_seeds do
        check_connection(S)
      end
    end
  end


  local function match_temp_area(E1, A)
    if A.mode != "floor" then return false end

stderrf("match temp area : map =\n%s\n", table.tostr(area_map))
    if area_map[1] == A then return (E1.area == 1) end
    if area_map[2] == A then return (E1.area == 2) end
    if area_map[3] == A then return (E1.area == 3) end

    if area_map[E1.area] == nil then
stderrf("---> setting to %s\n", tostring(A))
       area_map[E1.area] = A
       return true
    end

stderrf("---> fail\n")
    return false
  end


  local function match_an_element(S, E1, E2, T)
    if E1.kind == "dont_care" then return true end

    -- symmetry handling
    -- [ we prevent a pattern from overlapping its mirror ]
    -- [[ but we allow setting whole seeds *on* the axis of symmetry ]]
    -- [[[ except for new rooms, as they must remain distinct ]]]
    if T.is_first and E2.assignment then
      if E2.kind == "new_room" or
         E2.kind == "stair" or
         not on_axis_of_symmetry(S.sx, S.sy)
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

    -- seed is locked out of further changes?
    if E2.assignment and S.no_assignment then
      return false
    end

    -- do we have an area in current room?
    local A = S.temp_area
    if A and A.room != R then A = nil end

    if E1.kind == "free" then
      return not A
    end

    -- otherwise we require an area of this room
    if not (A and A.room == R) then return false end

    if E1.kind == "solid" or
       E1.kind == "liquid" or
       E1.kind == "cage"  or
       E1.kind == "closet"
    then
      return (A.mode == E1.kind)
    end

    if E1.kind == "area" then
      return match_temp_area(E1, A)
    end

    if E1.kind == "stair" then
      -- note: we do not check direction of stair
      return (S.stair_info and true)
    end

    error("Element kind not testable: " .. tostring(E1.kind))
  end


  local function install_an_element(S, E1, E2, T)
    if E1.kind == "dont_care" then return end

    -- FIXME: too simple!!!
    if E1.kind == E2.kind then return end

    if E2.kind == "free" then
      if S.temp_area then  ---??  if not (E1.kind == "free") then
        unset_seed(S)
      end

      return
    end

    if E2.kind == "area" then
      -- an assertion here usually means the grammar rule uses e.g. '2'
      -- in the output side but not in the input side.
stderrf("\narea_map = \n%s\n", table.tostr(area_map))
      local A = assert(area_map[E2.area])
      set_seed(S, A)
      return
    end

    if E2.kind == "new_area" then
      assert(pass != "root")

      if not new_area then
        new_area = Grower_temp_area(R, "floor")
        table.insert(R.temp_areas, new_area)
      end

      set_seed(S, new_area)
      return
    end

    if E2.kind == "new_room" then
      -- for initial shapes, 'R' is the current room
      if pass == "root" then
        new_room = R
      end

      if not new_room then
        new_room, new_conn = Grower_add_room(R)
      end

---##  if pass != "root" then
---##    table.insert(check_seeds, S)
---##  end

stderrf("new_room seed @ %s\n", S.name)
      set_seed(S, new_room.temp_areas[1])
      return
    end

    if E2.kind == "solid" or
       E2.kind == "liquid"
    then
      if R.temp_areas[E2.kind] == nil then
         R.temp_areas[E2.kind] = Grower_temp_area(R, E2.kind)
      end

      set_seed(S, R.temp_areas[E2.kind])
      return
    end

    if E2.kind == "cage" then
      if not new_cage then
        new_cage = Grower_temp_area(R, "cage")
        table.insert(R.temp_areas, new_cage)
      end
      set_seed(S, new_cage)
      return
    end

    -- TODO: stairs

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
    -- [ TODO : relax this a bit... ]
    if sx <= 1 or sx >= (SEED_W - 1) then return false end
    if sy <= 1 or sy >= (SEED_H - 1) then return false end

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
        if S .temp_area then unset_seed(S)  end
        if S2.temp_area then unset_seed(S2) end

stderrf("Joining halves @ %s\n", S:tostr())
        S:join_halves()

        install_an_element(S, E1, E2, T)
      end

      return true
    end


    assert(E1.diagonal)
    assert(E2.diagonal)


    -- in symmetrical rooms, forbid diagonals on axis of symmetry
    if (T.is_first or T.is_second) and on_axis_of_symmetry(sx, sy) then
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
        -- FIXME: this temp_area logic is unnecessarily complex...
        local A = S.temp_area
        if A then unset_seed(S) end

stderrf("splitting %s  with dir %d\n", S:tostr(), math.min(dir, 10 - dir))
        S:split(math.min(dir, 10 - dir))
        S2 = S.top

        if A then
          set_seed(S,  A)
          set_seed(S2, A)
        end

stderrf("install into bottom: %s --> %s\n", E1B.kind, E2B.kind)
stderrf("install into top   : %s --> %s\n", E1T.kind, E2T.kind)
        install_an_element(S,  E1B, E2B, T)
        install_an_element(S2, E1T, E2T, T)

stderrf("seed at %s\n", S:tostr())
stderrf("new temp areas:  %s  |  %s\n", tostring(S.temp_area), tostring(S2.temp_area))
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


  local function pre_install(T)
    new_room = nil
    new_conn = nil
  end


  local function post_install(T)
    Seed_squarify()

    if new_room then
      -- assumes best.T has set X/Y to best.x and best.y
--!!!!      new_room.symmetry = transform_symmetry(T)
stderrf("new_room.symmetry :\n%s\n", table.tostr(new_room.symmetry))

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

if what == "INSTALL" then
stderrf("=== install_pattern %s @ (%d %d) ===\n", cur_rule.name, T.x, T.y)
stderrf("T =\n%s\n", table.tostr(T))
end

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
      new_cage = nil
    end

--stderrf("=== match_or_install_pattern %s @ (%d %d) ===\n", cur_rule.name, x, y)
    T.is_first  = nil
    T.is_second = nil

    if R.symmetry and try_straddling_pattern(what, T) then
if what == "INSTALL" then
stderrf("[ straddler ]\n")
stderrf("T =\n%s\n", table.tostr(T))
end
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


  local function try_apply_a_rule(name)
    local rule = assert(grammar[name])

    cur_rule = rule

    -- Test all eight possible transforms (four rotations + mirroring)
    -- in all possible locations in the room.  If at least one is
    -- successful, pick it and apply the substitution.

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


  local function apply_a_rule()
    local rules2 = table.copy(rule_tab)

    for loop = 1, 20 do

      -- nothing left to try?
      if table.empty(rules2) then break; end

      local name = rand.key_by_probs(rules2)

      -- don't try it again
      rules2[name] = nil

--stderrf("Trying rule '%s'...\n", name)
      if try_apply_a_rule(name) then
--stderrf("  YES !!!!!!!!!!!!!!!!!!!!\n")

        return  -- Ok
      end
    end
  end


  ---| Grower_grammatical_room |---

stderrf("\n Grow room %s : %s pass\n", R.name, pass)

--if pass == "decorate" then return end

  -- FIXME
  if pass == "sprout" and #LEVEL.rooms >= 4 then return end

  if pass != "root" then
    assert(R.gx1) ; assert(R.gy2)
  end

  local apply_num = 14 --!!! rand.pick({ 2,4,7,11,15 })

  -- TODO: often no sprouts when room is near edge of map

  if pass == "root" then apply_num = 1 end
  if pass == "sprout" then apply_num = rand.pick({ 1,1,2,2,2,3 }) end
  if pass == "decorate" then apply_num = 5 end --- rand.pick({0,1,2}) end

  collect_appropriate_rules()

  for loop = 1, apply_num do
stderrf("LOOP %d\n", loop)
gui.debugf("LOOP %d\n", loop)
    apply_a_rule()
  end
end



function Grower_create_trunk(trunk_id)

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


  local trunk_R = Grower_add_room(nil)  -- no parent

  Grower_grammatical_room(trunk_R, "root")

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

      if not S.diagonal and not S.temp_area then
        -- a whole unused seed : split into two
        S:split(rand.sel(50, 1, 3))
      end

      S2 = S.top

      if S  and not S .temp_area then S .temp_area = new_temp_area(S)  end
      if S2 and not S2.temp_area then S2.temp_area = new_temp_area(S2) end
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


  ---| Grower_fill_gaps |---

  create_temp_areas()

  for loop = 1,20 do
    merge_temp_areas()
  end

  smoothen_out_pokers()

  Seed_squarify()

  LEVEL.gap_areas = temp_areas
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

  Grower_create_trunk(1)

  Grower_decorate_rooms()

  Grower_fill_gaps()

  Grower_make_all_areas()

  Area_calc_volumes()
  Area_find_neighbors()

  Grower_assign_boundary()

--DEBUG
Grower_save_svg()
end

