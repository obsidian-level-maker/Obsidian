------------------------------------------------------------------------
--  Layouting Logic
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2014 Andrew Apted
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

require "ht_fabs"


function Layout_parse_char(ch)
  if ch == ' ' then return { kind="empty"  } end
  if ch == '#' then return { kind="solid"  } end
  if ch == '~' then return { kind="liquid" } end

  -- walkable floors
  if ch == '.' then return { kind="floor", floor=0 } end
  if ch == '1' then return { kind="floor", floor=1 } end
  if ch == '2' then return { kind="floor", floor=2 } end
  if ch == '3' then return { kind="floor", floor=3 } end
  if ch == '4' then return { kind="floor", floor=4 } end
  if ch == '5' then return { kind="floor", floor=5 } end
  if ch == '6' then return { kind="floor", floor=6 } end
  if ch == '7' then return { kind="floor", floor=7 } end

  -- sub-areas (recursive patterns)
  if ch == 'a' then return { kind="sub_area", area=1 } end
  if ch == 'b' then return { kind="sub_area", area=2 } end
  if ch == 'c' then return { kind="sub_area", area=3 } end
  if ch == 'd' then return { kind="sub_area", area=4 } end
  if ch == 'e' then return { kind="sub_area", area=5 } end
  if ch == 'f' then return { kind="sub_area", area=6 } end

  -- diagonals : can be curved, so 'dir' is towards the more open space
-- FIXME !!!!!! diagonal
  if ch == '/' then return { kind="solid", dir=3 } end
  if ch == '%' then return { kind="solid", dir=1 } end
  if ch == 'N' then return { kind="solid", dir=9 } end
  if ch == 'Z' then return { kind="solid", dir=7 } end

  -- straight stairs
  if ch == '<' then return { kind="stair", dir=4 } end
  if ch == '>' then return { kind="stair", dir=6 } end
  if ch == '^' then return { kind="stair", dir=8 } end
  if ch == 'v' then return { kind="stair", dir=2 } end

  -- these stairs turn 90 degrees, 'dir' is the middle angle
  if ch == 'F' then return { kind="curve_stair", dir=3 } end
  if ch == 'T' then return { kind="curve_stair", dir=1 } end
  if ch == 'L' then return { kind="curve_stair", dir=9 } end
  if ch == 'J' then return { kind="curve_stair", dir=7 } end

  -- stairs to a higher layer, 'dir' is always the "going up" direction
  if ch == '{' then return { kind="3d_stair", dir=4 } end
  if ch == '}' then return { kind="3d_stair", dir=6 } end
  if ch == 'A' then return { kind="3d_stair", dir=8 } end
  if ch == 'V' then return { kind="3d_stair", dir=2 } end

  error("Layout_parse_char: unknown symbol: " .. tostring(ch))
end


function Layout_parse_size_digit(ch)
  -- treat as hexadecimal
  return 0 + ("0x" .. ch)
end


function Layout_total_size(s)
  local seeds = 0

  for i = 1, #s do
    seeds = seeds + Layout_parse_size_digit(string.sub(s, i, i))
  end

  return seeds
end


-- function Layout_mirror_X(cell)


function Layout_preprocess_patterns()
  --
  -- Process each room pattern and convert the human-readable
  -- structure into a more easily accessed form.
  --
  local floor_tab


  local function neighbor(grid, x, y, dir, dist)
    local nx, ny = geom.nudge(x, y, dir, dist)

    if nx < 1 or nx > grid.w then return nil end
    if ny < 1 or ny > grid.h then return nil end

    return grid[nx][ny]
  end


  local function analyse_floor(pat, P)
    floor_tab[P.floor] = 1
  end


  local function analyse_stair(grid, x, y)
    -- determine the source floor for this stair
    -- (the destination floor is ALWAYS the pointed-to seed).
    local P = grid[x][y]
    assert(P.dir)

    local N = neighbor(grid, x, y, P.dir)

-- FIXME: need to handle destination being a sub-area
--!!!!!    if not (N and N.kind == "floor") then
--!!!!!      error("bad stair in pattern: destination not a floor")
--!!!!!    end

    P.dest_floor = N.floor

    -- we try the back first
    local DIRS =
    {
      10 - P.dir, geom.LEFT[P.dir], geom.RIGHT[P.dir]
    }

    each dir in DIRS do
      local back = neighbor(grid, x, y, dir)

      if back and back.kind == "floor" then
        -- found it
        P.src_dir   = dir
        P.src_floor = back.floor
        return
      end
    end

    error("Bad stair in pattern: no walkable neighbor")
  end


  local function analyse_curve_stair(grid, x, y)
    local P = grid[x][y]
    assert(P.dir)

    local L_dir = geom.LEFT_45 [P.dir]
    local R_dir = geom.RIGHT_45[P.dir]

    local NL = neighbor(grid, x, y, L_dir)
    local NR = neighbor(grid, x, y, R_dir)

    if not (NL and NL.kind == "floor") or
       not (NR and NR.kind == "floor")
    then
      error("Bad curve stair in pattern: not connecting to a floor")
    end

    -- record the floors
    P. left_floor = NL.floor
    P.right_floor = NR.floor
  end


  local function process_elements(pat, grid)
    for x = 1, grid.w do
    for y = 1, grid.h do
      local kind = grid[x][y].kind

      pat.elements[kind] = (pat.elements[kind] or 0) + 1

      if kind == "floor" then
        analyse_floor(pat, grid[x][y])

      elseif kind == "stair" then
        analyse_stair(grid, x, y)
      
      elseif kind == "curve_stair" then
        analyse_curve_stair(grid, x, y)
      end

      -- NOTE: 3d_stair is not handled here, since it needs to
      --       access both _structure and _overlay grids.

    end -- x, y
    end
  end


  local function convert_pattern(pat, structure)
    local W = #structure[1]
    local H = #structure

    local grid = table.array_2D(W, H)

    for x = 1, W do
    for y = 1, H do
      -- textural representation must be inverted
      local line = structure[H + 1 - y]

      if #line != W then
        error("Malformed structure in room pattern: " .. pat.name)
      end

      local ch = string.sub(line, x, x)

      grid[x][y] = Layout_parse_char(ch)
    end -- x, y
    end

    process_elements(pat, grid)

    return grid
  end


  local function count_floors(pat)
    if not floor_tab[0] then
      if pat.recurse == "pure" then return end

      error("Missing floors in pattern: " .. pat.name)
    end

    local num = 5

    while num > 0 and not floor_tab[num] do
      num = num - 1
    end

    for i = 0, num do
      if not floor_tab[num] then
        error("Floor gaps in pattern: " .. pat.name)
      end
    end

    pat.num_floors = num + 1
  end


  local function find_sub_area(grid, area_id)
    local x1, y1 =  999,  999
    local x2, y2 = -999, -999

    for x = 1, grid.w do
    for y = 1, grid.h do
      if grid[x][y].kind == "sub_area" and
         grid[x][y].area == area_id
      then
        x1 = math.min(x1, x)
        y1 = math.min(y1, y)

        x2 = math.max(x2, x)
        y2 = math.max(y2, y)
      end
    end -- x, y
    end

    if x1 > x2 or y1 > y2 then
      return nil  -- NONE
    end

    -- verify it
    for x = x1, x2 do
    for y = y1, y2 do
      if grid[x][y].area != area_id then
        error("Recursive sub-area in pattern is not a rectangle")
      end
    end
    end

    return { x1=x1, y1=y1, x2=x2, y2=y2 }
  end


  local function determine_sub_areas(pat)
    -- for recursive patterns, find the rectangle which corresponds
    -- to each sub-area.

    pat.sub_areas = {}

    for id = 1, 4 do
      local area = find_sub_area(pat._structure, id)
      if not area then break; end
      pat.sub_areas[id] = area
    end

    if table.empty(pat.sub_areas) then
      error("Recursive pattern has no sub-areas: " .. pat.name)
    end
  end


  local function calc_extents(pat)
    local min_size =  999
    local max_size = -999

    for pass = 1,2 do
      local size_list = sel(pass == 1, pat.x_sizes, pat.y_sizes)
      
      each s in size_list do
        local w = Layout_total_size(s)

        min_size = math.min(min_size, w)
        max_size = math.max(max_size, w)
      end
    end

    assert(min_size <= max_size)

    pat.min_size = min_size
    pat.max_size = max_size
  end


  local function verify_extents(pat)
    if pat._overlay then
      if pat._overlay.w != pat._structure.w or
         pat._overlay.h != pat._structure.h
      then
        error("Malformed overlay in room pattern: " .. pat.name)
      end
    end

    each s in pat.x_sizes do
      if #s != pat._structure.w then
        error("Wrong x_size length in pattern: " .. pat.name)
      end
    end

    each s in pat.y_sizes do
      if #s != pat._structure.h then
        error("Wrong y_size length in pattern: " .. pat.name)
      end
    end
  end


  local function check_is_symmetrical(grid, axis)
    -- axis is either "x" or "y" [nothing else]

    for x = 1, grid.w do
    for y = 1, grid.h do
      local nx, ny = x, y
      local dir_mapping

      if axis == "x" then
        nx = grid.w + 1 - x
        dir_mapping = geom.MIRROR_X
      else
        ny = grid.h + 1 - y
        dir_mapping = geom.MIRROR_Y
      end

      local G1 = grid[x][y]
      local G2 = grid[nx][ny]

      if G1.kind != G2.kind then return false end

      if G1.dir then
        assert(G2.dir)

        if G1.dir != dir_mapping[G2.dir] then return false end
      end

    end -- x, y
    end

    return true
  end

  
  local function verify_symmetry(pat, grid)
    if not grid then return end

    if not pat.symmetry then return end

    if pat.symmetry == "x" or pat.symmetry == "xy" then
      if not check_is_symmetrical(grid, "x") then
        error("Room pattern failed X symmetry test: " .. pat.name)
      end
    end

    if pat.symmetry == "y" or pat.symmetry == "xy" then
      if not check_is_symmetrical(grid, "y") then
        error("Room pattern failed Y symmetry test: " .. pat.name)
      end
    end
  end


  local function verify_size_symmetry(pat, axis, sizes)
    if not pat.symmetry then return end

    if not string.match(pat.symmetry, axis) then return end

    each s in sizes do
      for i = 1, #s do
        local k = #s + 1 - i

        if string.sub(s, i, i) != string.sub(s, k, k) then
          error("Broken size symmetry in " .. pat.name .. " : " .. s)
        end
      end
    end
  end


  ---| Layout_preprocess_patterns |---

  table.name_up(ROOM_PATTERNS)

  table.expand_copies(ROOM_PATTERNS)

  each name,pat in ROOM_PATTERNS do
    floor_tab = {}

    pat.elements = {}

    pat._structure = convert_pattern(pat, pat.structure)

    if pat.overlay then
       pat._overlay = convert_pattern(pat, pat.overlay)
    end

    count_floors(pat)

    if pat.recurse then
      determine_sub_areas(pat)
    end

    calc_extents(pat)

    -- validate various things --

    verify_extents(pat)

    verify_symmetry(pat, pat._structure)
    verify_symmetry(pat, pat._overlay)

    verify_size_symmetry(pat, "x", pat.x_sizes)
    verify_size_symmetry(pat, "y", pat.y_sizes)
  end
end


------------------------------------------------------------------------


function Layout_compute_wall_dists(R)

  local function init_dists()
    for x = R.sx1, R.sx2 do
    for y = R.sy1, R.sy2 do
      local S = SEEDS[x][y]
      if S.room != R then continue end

      for dir = 1,9 do if dir != 5 then
        local N = S:neighbor(dir)

        if not (N and N.room == R) then
          S.wall_dist = 0.5
        end
      end end -- dir

    end -- sx, sy
    end
  end


  local function spread_dists()
    local changed = false

    for x = R.sx1, R.sx2 do
    for y = R.sy1, R.sy2 do
      local S = SEEDS[x][y]
      if S.room != R then continue end

      for dir = 2,8,2 do
        local N = S:neighbor(dir)
        if not (N and N.room == R) then continue end

        if S.wall_dist and S.wall_dist + 1 < (N.wall_dist or 999) then
          N.wall_dist = S.wall_dist + 1
          changed  = true
        end
      end

    end  -- sx, sy
    end

    return changed
  end


  ---| Layout_compute_wall_dists |---

  init_dists()

  while spread_dists() do end
end



function Layout_spot_for_wotsit(R, kind, none_OK)
  local bonus_x, bonus_y


  local function nearest_wall(T)
    -- get the wall_dist from seed containing the spot

    local S = Seed_from_coord(T.x1 + 32, T.y1 + 32)

    -- sanity check
    if S.room != R then return nil end

    return assert(S.wall_dist)
  end


  local function fuzzy_dist(mx, my, T)
    local tx, ty = geom.box_mid(T.x1, T.y1, T.x2, T.y2)

    local dx = math.abs(mx - tx)
    local dy = math.abs(my - ty)

    return dx + dy
  end


  local function nearest_conn(T)
    local dist

    each C in R.conns do
      if C.kind == "normal" or C.kind == "closet" then
        local S = C:get_seed(R)
        local dir = sel(C.R1 == R, C.dir, 10 - C.dir)

        local ex, ey = S:edge_coord(dir)
        local d = fuzzy_dist(ex, ey, T) / SEED_SIZE

        if not dist or d < dist then
          dist = d
        end
      end
    end

    return dist
  end


  local function nearest_goal(T)
    local dist

    each goal in R.goals do
      local S = assert(goal.S)
      local mx, my = S:mid_point()
      local d = fuzzy_dist(mx, my, T) / SEED_SIZE

      if not dist or d < dist then
        dist = d
      end
    end

    return dist
  end


  local function evaluate_spot(spot, sx, sy)
    -- Factors we take into account:
    --   1. distance from walls
    --   2. distance from entrance / exits
    --   3. distance from other goals
    --   4. rank value from prefab

    local wall_dist = nearest_wall(spot) or 20
    local conn_dist = nearest_conn(spot) or 20
    local goal_dist = nearest_goal(spot) or 20

    -- combine conn_dist and goal_dist
    local score = math.min(goal_dist, conn_dist * 1.5)

    -- now combine with wall_dist.
    -- in caves we need the spot to be away from the edges of the room
    if R.cave_placement then
      if wall_dist >= 1.2 then score = score + 100 end
    else
      score = score + wall_dist / 5
    end

    -- teleporters should never be underneath a 3D floor, because
    -- player will unexpected activate it while on the floor above,
    -- and because the sector tag is needed by the teleporter.
    if kind == "TELEPORTER" and spot.chunk[2] then
      score = score - 10
    end

    -- apply the skill bits from prefab
    if spot.rank then
      score = score + (spot.rank - 1) * 5 
    end

    -- want a different height
    if R.entry_conn and R.entry_conn.conn_h and spot.floor_h then
      local diff_h = math.abs(R.entry_conn.conn_h - spot.floor_h)

      score = score + diff_h / 10
    end

    -- for symmetrical rooms, prefer a centred item
    if sx == bonus_x then score = score + 0.8 end
    if sy == bonus_y then score = score + 0.8 end
 
    -- tie breaker
    score = score + gui.random() ^ 2

--[[
if R.id == 6 then
stderrf("  (%2d %2d) : wall:%1.1f conn:%1.1f goal:%1.1f --> score:%1.2f\n",
    sx, sy, wall_dist, conn_dist, goal_dist, score)
end
--]]
    return score
  end


  ---| Layout_spot_for_wotsit |---

  if R.mirror_x and R.tw >= 3 then bonus_x = int((R.tx1 + R.tx2) / 2) end
  if R.mirror_y and R.th >= 3 then bonus_y = int((R.ty1 + R.ty2) / 2) end

  local best = {}

  for x = R.sx1, R.sx2 do
  for y = R.sy1, R.sy2 do
    local S = SEEDS[x][y]

    if S.room != R then continue end
    if S.kind != "walk" or S.content then continue end

    local score = evaluate_spot(S, x, y)

    if not best.S or score > best.score then
      best.x = x ; best.y = y
      best.S = S ; best.score = score
    end
  end -- x, y
  end

  local S = best.S

  if not S then
    if none_OK then return nil end
    error("No usable spots in room!")
  end


  -- OK --

  S.content = "wotsit"
  S.content_kind = kind

  table.insert(R.goals, { S=S, kind=kind })

  -- no monsters near start spot or teleporters
  -- FIXME: do this later (for chunks)
  if kind == "START" then
    R:add_exclusion("empty",     S.x1, S.y1, S.x2, S.y2, 96)
    R:add_exclusion("nonfacing", S.x1, S.y1, S.x2, S.y2, 512)

  elseif kind == "TELEPORTER" then
    R:add_exclusion("empty",     S.x1, S.y1, S.x2, S.y2, 144)
    R:add_exclusion("nonfacing", S.x1, S.y1, S.x2, S.y2, 384)
  end

  return best.x, best.y, best.S
end



function Layout_place_importants(R)

  local function add_purpose()
    local sx, sy, S = Layout_spot_for_wotsit(R, R.purpose)

    R.guard_spot = S
  end


  local function add_teleporter()
    local sx, sy, S = Layout_spot_for_wotsit(R, "TELEPORTER")

    -- sometimes guard it, but only for out-going teleporters
    if not R.guard_spot and (R.teleport_conn.R1 == R) and
       rand.odds(60)
    then
      R.guard_spot = S
    end
  end


  local function add_weapon(weapon)
    local sx, sy, S = Layout_spot_for_wotsit(R, "WEAPON", "none_OK")

    if not S then
      gui.printf("WARNING: no space for %s!\n", weapon)
      return
    end

    S.content_item = weapon

    if not R.guard_spot then
      R.guard_spot = S
    end
  end


  local function add_item(item)
    local sx, sy, S = Layout_spot_for_wotsit(R, "ITEM", "none_OK")

    if not S then return end

    S.content_item = item

    if not R.guard_spot then
      R.guard_spot = S
    end
  end


  ---| Layout_place_importants |---

  Layout_compute_wall_dists(R)

  if R.kind == "cave" or
     (rand.odds(5) and R.sw >= 3 and R.sh >= 3)
  then
    R.cave_placement = true
  end

  if R.purpose then
    add_purpose()
  end

  if R.teleport_conn then
    add_teleporter()
  end

  each name in R.weapons do
    add_weapon(name)
  end

  each name in R.items do
    add_item(name)
  end
end



function Layout_set_floor_minmax(R)
  local min_h =  9e9
  local max_h = -9e9

  for x = R.sx1, R.sx2 do
  for y = R.sy1, R.sy2 do
    local S = SEEDS[x][y]

    if S.room != R then continue end

    if S.kind == "void" then continue end

    -- this for hallways
    if S.floor_h then
      min_h = math.min(min_h, S.floor_h)
      max_h = math.max(max_h, S.floor_h)
    end

    for i = 1,9 do
      local K = S.chunk[i]

      if not K then break; end

      -- ignore liquids : height not set yet

      if K.kind == "floor" then
        local f_h = assert(K.floor.floor_h)

        S.floor_h     = math.min(S.floor_h     or f_h, f_h)
        S.floor_max_h = math.max(S.floor_max_h or f_h, f_h)

        min_h = math.min(min_h, f_h)
        max_h = math.max(max_h, f_h)
      end
    end -- i

  end -- x, y
  end

  assert(min_h <= max_h)

  R.floor_min_h = min_h
  R.floor_max_h = max_h

  -- set liquid height

  R.liquid_h = R.floor_min_h - 48

  if R.has_3d_liq_bridge then
    R.liquid_h = R.liquid_h - 48
  end

  for x = R.sx1, R.sx2 do
  for y = R.sy1, R.sy2 do
    local S = SEEDS[x][y]
    if S.room == R and S.kind == "liquid" then
      S.floor_h = R.liquid_h
      S.floor_max_h = S.floor_max_h or S.floor_h
    end
  end -- x, y
  end
end


function Layout_scenic(R)
  local min_floor = 1000

  if not LEVEL.liquid then
    R.main_tex = R.zone.facade_mat
  end

  for x = R.sx1,R.sx2 do
  for y = R.sy1,R.sy2 do
    local S = SEEDS[x][y]
    
    if S.room != R then continue end

    S.kind = sel(LEVEL.liquid, "liquid", "void")

    for side = 2,8,2 do
      local N = S:neighbor(side)
      if N and N.room and N.floor_h then
        min_floor = math.min(min_floor, N.floor_h)
      end
    end
  end -- x,y
  end

  if min_floor < 999 then
    local h1 = rand.irange(1,6)
    local h2 = rand.irange(1,6)

    R.liquid_h = min_floor - (h1 + h2) * 16
  else
    R.liquid_h = 0
  end

  R.floor_max_h = R.liquid_h
  R.floor_min_h = R.liquid_h
  R.floor_h     = R.liquid_h

  for x = R.sx1, R.sx2 do
  for y = R.sy1, R.sy2 do
    local S = SEEDS[x][y]
    if S.room == R and S.kind == "liquid" then
      S.floor_h = R.liquid_h
    end
  end -- for x, y
  end
end


function Layout_hallway(R)
  local tx1,ty1, tx2,ty2 = R:conn_area()
  local tw, th = geom.group_size(tx1,ty1, tx2,ty2)

  local function T_fill()
    for x = R.sx1,R.sx2 do
    for y = R.sy1,R.sy2 do
      if x < tx1 or x > tx2 or y < ty1 or y > ty2 then
        SEEDS[x][y].kind = "void"
      end
    end -- x, y
    end
  end

  local function make_O()
    for x = R.sx1+1,R.sx2-1 do
    for y = R.sy1+1,R.sy2-1 do
      local S = SEEDS[x][y]
      S.kind = "void"
    end -- x, y
    end
  end

  local function make_L()
    local C1 = R.conns[1]
    local C2 = R.conns[2]

    local S1 = C1:get_seed(R)
    local S2 = C2:get_seed(R)

    if rand.odds(50) then S1,S2 = S2,S1 end

    for x = R.sx1,R.sx2 do
    for y = R.sy1,R.sy2 do
      if x < tx1 or x > tx2 or y < ty1 or y > ty2 or
         not (x == S1.sx or y == S2.sy)
      then
        SEEDS[x][y].kind = "void"
      end
    end -- x, y
    end
  end

  local function criss_cross()
    -- block out seeds that don't "trace" from a connection
    local used_x = {}
    local used_y = {}

    each C in R.conns do
      if C.kind == "teleporter" then continue end
      local S = C:get_seed(R)
      if geom.is_vert(S.conn_dir) then
        used_x[S.sx] = 1
      else
        used_y[S.sy] = 1
      end
    end

    -- all connections are parallel => fail
    if table.empty(used_x) or table.empty(used_y) then
      make_O()
      return
    end

    for x = R.sx1,R.sx2 do
    for y = R.sy1,R.sy2 do
      if x < tx1 or x > tx2 or y < ty1 or y > ty2 or
         not (used_x[x] or used_y[y])
      then
        SEEDS[x][y].kind = "void"
      end
    end -- x, y
    end

    return true
  end


  ---| Layout_hallway |---

  R.tx1, R.ty1 = R.sx1, R.sy1
  R.tx2, R.ty2 = R.sx2, R.sy2
  R.tw,  R.th  = R.sw,  R.sh

  if not LEVEL.hall_trim then
    LEVEL.hall_trim   = rand.odds(50)
    LEVEL.hall_lights = rand.odds(50)

    if THEME.ceil_lights then
      LEVEL.hall_lite_ftex = rand.key_by_probs(THEME.ceil_lights)
    end
  end


  local entry_C = assert(R.entry_conn)
  local h = assert(entry_C.conn_h)

  local O_CHANCES = { 0, 10, 40, 70 }
  local o_prob = O_CHANCES[math.min(4, #R.conns)]

  -- FIXME: more shapes (U, S)

  gui.debugf("Hall conn area: (%d,%d) .. (%d,%d)\n", tx1,ty1, tx2,ty2)

  if R.sw >= 3 and R.sh >= 3 and rand.odds(o_prob) then
    make_O()

  elseif tw == 1 or th == 1 then
    T_fill()

  elseif #R.conns == 2 then
    make_L()

  else
    criss_cross()
  end


  local height = 128
  if rand.odds(20) then
    height = 192
  elseif rand.odds(10) then
    height = 256
    R.hall_sky = true
  end

  for x = R.sx1, R.sx2 do
  for y = R.sy1, R.sy2 do
    local S = SEEDS[x][y]
    assert(S.room == R)
    if S.kind == "walk" then
      S.floor_h = h
      S.ceil_h = h + height

      S.f_tex = R.zone.hall_floor
      S.c_tex = R.zone.hall_ceil

      if R.hall_sky then
        S.is_sky = true
      end
    end
  end -- x, y
  end

  Layout_set_floor_minmax(R)

  R.ceil_h = R.floor_max_h + height

  each C in R.conns do
    if not C.conn_h then
      C.conn_h = h
    end
  end
end



function Layout_add_pillars(R)

  local PILLAR_PATTERNS =
  {
     "-2-",
     "1-1",
     "111",

     "-1-1-",
     "1-2-1",

     "1--1",
     "1111",

     "--1-1--",
     "-1---1-",
     "-1-2-1-",
     "1--2--1",
     "1-2-2-1",

     "-1--1-",
     "2-11-2",

     "--1--1--",
     "1-2--2-1",

     "--1-2-1--",
     "-1--2--1-",
     "-1-2-2-1-",
     "1---2---1",
     "2-1---1-2",

     "--1--2--1--",
     "-1---2---1-",
     "-1-1---1-1-",
     "1----2----1",
     "2--1---1--2",
  }


  local function cpp_is_seed_bad(R, S, N)
    if not N then return true end
    if N.room != R then return true end
    if N.kind == "void" then return true end
    if not N.floor_h then return true end
    if S.floor_h and N.floor_h > S.floor_h + 24 then return true end

    return false
  end


  local function can_put_pillar_at(R, S)
    if S.room != R then return false end

    if S.content then return false end

    if S.kind != "walk" or S.conn or S.pseudo_conn or S.walk_group or S.must_walk then
      return false
    end

    -- see if pillar would be annoyingly blocking
    for dir = 2,4,2 do
      local A = S:neighbor(dir)
      local B = S:neighbor(10 - dir)

      if cpp_is_seed_bad(R, S, A) and cpp_is_seed_bad(R, S, B) then
        return false
      end

      if (A and A.kind == "liquid") and (B and B.kind == "liquid") then
        return false
      end
    end

    -- OK !
    return true
  end


  local function can_pillar_pattern(side, offset, pat)
    local x1,y1, x2,y2 = geom.side_coords(side, R.tx1,R.ty1, R.tx2,R.ty2)
    local pos = 1

    x1,y1 = geom.nudge(x1, y1, 10-side, offset)
    x2,y2 = geom.nudge(x2, y2, 10-side, offset)

    for x = x1,x2 do
    for y = y1,y2 do
      local S = SEEDS[x][y]

      local ch = string.sub(pat, pos, pos)
      pos = pos + 1
      assert(ch)

      if ch == '-' then
        if S.content == "pillar" then return false end
      else
        assert(string.is_digit(ch))

        if not can_put_pillar_at(R, S) then return false end

      end
    end -- x, y
    end

    return true --OK--
  end


  local function make_pillar_pattern(side, offset, pat)
    local x1,y1, x2,y2 = geom.side_coords(side, R.tx1,R.ty1, R.tx2,R.ty2)
    local pos = 1

    x1,y1 = geom.nudge(x1, y1, 10-side, offset)
    x2,y2 = geom.nudge(x2, y2, 10-side, offset)

    for x = x1,x2 do for y = y1,y2 do
      local S = SEEDS[x][y]

      local ch = string.sub(pat, pos, pos)
      pos = pos + 1

      if string.is_digit(ch) then
        S.content = "pillar"
        S.pillar_skin = assert(GAME.PILLARS[R.pillar_what])
      end
    end end -- for x, y
  end


  ---| Layout_add_pillars |---

  if R.parent then return end

  if not THEME.pillars then
    return
  end

  -- FIXME this is too crude!
  if STYLE.pillars == "none" or STYLE.pillars == "few" then
    return
  end

  local skin_names = THEME.pillars
  if not skin_names then return end
  R.pillar_what = rand.key_by_probs(skin_names)

  local SIDES = { 2, 4 }
  rand.shuffle(SIDES)

  each side in SIDES do
  for offset = 0,1 do
    local long, deep = R.tw, R.th
    if geom.is_horiz(side) then long,deep = deep,long end

    if deep >= 3+offset*2 and long >= 3 then
      local lists = { {}, {} }

      for where = 1,2 do
        each pat in PILLAR_PATTERNS do
          if #pat == long and
             can_pillar_pattern(sel(where==1,side,10-side), offset, pat)
          then
            table.insert(lists[where], pat)
          end
        end -- for pat
      end -- for where

      -- FIXME: maintain symmetry : limit to symmetrical patterns
      --        and on certain sides we require the same pattern.

      if #lists[1] > 0 and #lists[2] > 0 then
        local pat1
        local pat2

        -- preference for same pattern
        for loop = 1,3 do
          pat1 = rand.pick(lists[1])
          pat2 = rand.pick(lists[2])
          if pat1 == pat2 then break; end
        end

        gui.debugf("Pillar patterns @ %s : %d=%s | %d=%s\n",
                   R:tostr(), side, pat1, 10-side, pat2)

        make_pillar_pattern(side,    offset, pat1)
        make_pillar_pattern(10-side, offset, pat2)

        R.pillar_rows =
        { 
          { side=side,    offset=offset }
          { side=10-side, offset=offset }
        }

        return --OK--
      end
    end
  end -- side, offset
  end
end



function Layout_escape_from_pits(R)

  local function new_pit()
    local PIT =
    {
      id = Plan_alloc_id("slime_pit")
    }

    return PIT
  end


  local function merge_pits(pit1, pit2)
    if pit1.cost and pit2.cost and pit2.cost < pit1.cost then
      pit1, pit2 = pit2, pit1
    end

    -- kill the other pit
    pit2.id = "dead"
    pit2.liquid_h = nil
    pit2.out_h = nil

    for sx = R.sx1, R.sx2 do
    for sy = R.sy1, R.sy2 do
      local S = SEEDS[sx][sy]

      if S.slime_pit == pit2 then
         S.slime_pit = pit1
      end
    end
    end

    -- return the kept one
    return pit1
  end


  local function find_neighbor_pit(S)
    local pit

    for dir = 2,8,2 do
      local N = S:neighbor(dir)

      if not N or N.room != R then continue end

      if N.kind != "liquid" then continue end

      if not N.slime_pit then continue end

      if pit == N.slime_pit then continue end

      if pit then
        -- we have found two different pits, need to merge them
        pit = merge_pits(pit, N.slime_pit)
      else
        pit = N.slime_pit
      end
    end

    return pit
  end


  local function evaluate_escape_pod(pit, S, dir, N)
    local cost

    if N.kind == "walk" then
      cost = 0
---##    elseif N.kind == "stair" then
---##      cost = 80
    else
      -- not walkable
      return
    end

    -- cannot escape through a 3D floor
    if S.chunk[2] then return end

    -- don't want to bump into a pillar or switch
    if N.content then
      cost = cost + 20
    end

    -- determine floor height once we get out
    local out_h = assert(N.floor_h)

    local diff_h = out_h - pit.liquid_h

    if diff_h < 4 then
      return
    end

    -- disabled this, which prefers to place the step next to the
    -- lowest nearby floor.  Step placement is less predictable now.
    --[[  cost = cost + diff_h  --]]

    -- tie breaker
    cost = cost + gui.random()

    -- replace current pod with new one if better
    if not pit.cost or (cost < pit.cost) then
      pit.cost = cost
      pit.out_h = out_h
      pit.S = S
      pit.N = N
      pit.dir = dir

      -- coordinates for the step / lift
      local x1, y1, x2, y2

      local mx, my = S:mid_point()

      local long = 64
      local deep = 24

      if geom.is_vert(dir) then
        x1, x2 = mx - long/2, mx + long/2
      else
        y1, y2 = my - long/2, my + long/2
      end

      if dir == 2 then y1 = S.y1 ; y2 = y1 + deep end
      if dir == 8 then y2 = S.y2 ; y1 = y2 - deep end
      if dir == 4 then x1 = S.x1 ; x2 = x1 + deep end
      if dir == 6 then x2 = S.x2 ; x1 = x2 - deep end

      assert(x1 and x2 and y1 and y2)

      pit.bx1 = x1 ; pit.by1 = y1
      pit.bx2 = x2 ; pit.by2 = y2
    end
  end


  local function add_seed_to_pit(pit, S)
    S.slime_pit = pit

    pit.liquid_h = math.min(S.floor_h, pit.liquid_h or 999)

    -- check neighbors for a floor spot
    for dir = 2,8,2 do
      local N = S:neighbor(dir)

      if not N or N.room != R then continue end

      evaluate_escape_pod(pit, S, dir, N)
    end
  end


  local function collect_pits()
    local list = {}

    for sx = R.sx1, R.sx2 do
    for sy = R.sy1, R.sy2 do
      local S = SEEDS[sx][sy]

      if S.room != R then continue end
      if S.kind != "liquid" then continue end

      local pit = find_neighbor_pit(S)

      if not pit then
        pit = new_pit()
        table.insert(list, pit)
      end

      add_seed_to_pit(pit, S)
    end
    end

    return list
  end


  local function build_escape(pit)
    -- check for invalid pits
    if pit.out_h  == nil or
       pit.liquid_h == nil or
       pit.bx1 == nil
    then
      warning("unescapable pit in %s\n", R:tostr())
      return
    end

    local diff_h = pit.out_h - pit.liquid_h

    if diff_h <= PARAM.jump_height then
      -- nothing needed : player can walk/jump out
      return
    end

    pit.N.escape_target = true

    local brush = brushlib.quad(pit.bx1, pit.by1, pit.bx2, pit.by2)

    if diff_h <= (PARAM.jump_height * 2) then
      -- a single stair will suffice

      brushlib.add_top(brush, pit.liquid_h + int(diff_h / 2))
      brushlib.set_mat(brush, "METAL", "METAL")

      Trans.brush(brush)

    else
      -- need a lift?

      table.insert(brush, 1, { m="solid", mover=1 })

      brushlib.add_top(brush, pit.out_h - 12)
      brushlib.set_mat(brush, "SUPPORT2", "SUPPORT2")
      brushlib.set_line_flag(brush, "y_offset", 0)

      local tag = Plan_alloc_id("tag")

      each C in brush do
        if C.t then C.tag = tag end
      end

      each C in brush do
        if C.x then
          C.special = 62  -- FIXME : game specific
          C.tag = tag
        end
      end

      Trans.brush(brush)
    end
  end


  ---| Layout_escape_from_pits |---

  each pit in collect_pits() do
    if pit.id != "dead" then
      build_escape(pit)
    end
  end
end



function Layout_add_bridges(R)

  local function install_bridge(S, dir, L)
    -- L is a liquid neighbor

    S.content  = "bridge"
    S.bridge_h = S.floor_h
    S.bridge_dir = geom.RIGHT[dir]
    S.bridge_tex = S.f_tex

    S.kind = "liquid"
    S.floor_h = L.floor_h

-- stderrf("Bridge @ %s\n", S:tostr())
  end


  local function seed_is_liquidy(N)
    if N.kind != "liquid" then return false end

    -- ignore previously made bridges
    if N.bridge_h then return false end

    -- ignore a 3D floor -- it probably joins onto the "walk" seed
    if N.chunk[2] then return false end

    return true
  end


  local function test_spot(S)
    if S.kind != "walk" then return end

    if S.content then return end
    if S.conn then return end
    if S.escape_target then return end

    for dir = 2,4,2 do
      local A = S:neighbor(dir)
      local B = S:neighbor(10 - dir)

      if not (A and A.room == R) then continue end
      if not (B and B.room == R) then continue end

      if not seed_is_liquidy(A) then continue end
      if not seed_is_liquidy(B) then continue end

      if math.abs(A.floor_h - B.floor_h) > 1 then continue end

      -- OK --

      install_bridge(S, dir, B)
      return
    end
  end


  ---| Layout_add_bridges |---

  for x = R.sx1, R.sx2 do
  for y = R.sy1, R.sy2 do
    local S = SEEDS[x][y]

    if S.room != R then continue end

    test_spot(S)
  end
  end
end



function Layout_add_cages(R)
  local  junk_list = {}
  local other_list = {}

  local DIR_LIST

  local function test_seed(S)
    local best_dir
    local best_z

    each dir in DIR_LIST do
      local N = S:neighbor(dir)

      if not (N and N.room == R) then continue end

      if N.kind != "walk" then continue end
      if N.content then continue end
      if not N.floor_h then continue end

      best_dir = dir
      best_z   = N.floor_h + 16

      -- 3D floors [MEH : TODO better logic]
      if N.chunk[2] and N.chunk[2].floor then
        local z2 = N.chunk[2].floor.floor_h

        if z2 - best_z < (128 + 32) then
          best_z = z2 + 16
        end
      end
    end

    if best_dir then
      local LOC = { S=S, dir=best_dir, z=best_z }

      if S.junked then
        table.insert(junk_list, LOC)
      else
        table.insert(other_list, LOC)
      end
    end
  end


  local function collect_cage_seeds()
    for x = R.sx1, R.sx2 do
    for y = R.sy1, R.sy2 do
      local S = SEEDS[x][y]

      if S.room != R then continue end
    
      if S.kind != "void" then continue end

      test_seed(S)
    end
    end
  end


  local function convert_list(list, limited)
    each loc in list do
      local S = loc.S

      if limited then
        if geom.is_vert (loc.dir) and (S.sx % 2) == 0 then continue end
        if geom.is_horiz(loc.dir) and (S.sy % 2) == 0 then continue end
      end

      -- convert it
      S.cage_dir = loc.dir
      S.cage_z   = loc.z
    end
  end


  ---| Layout_add_cages |---

  -- never add cages to a start room
  if R.purpose == "START" then return end

  -- or rarely in secrets
  if R.quest.kind == "secret" and rand.odds(90) then return end

  -- style check...
  local prob = style_sel("cages", 0, 20, 50, 90)

  if not rand.odds(prob) then return end

  if rand.odds(50)then
    -- try verticals before horizontals (for symmetry)
    DIR_LIST = { 2,8,4,6 }
  else
    DIR_LIST = { 6,4,8,2 }
  end

  collect_cage_seeds()

  -- either use the junked seeds OR the solid-room-fab seeds
  local list

  if #junk_list > 0 and #other_list > 0 then
    list = rand.sel(35, junk_list, other_list)
  elseif #junk_list > 0 then
    list = junk_list
  else
    list = other_list
  end

  -- rarely use ALL the junked seeds
  local limited
  if list == junk_list and
     rand.odds(sel(STYLE.cages == "heaps", 50, 80))
  then
    limited = true
  end

  convert_list(list, limited)
end



function Layout_pattern_in_area(R, area)
  --
  -- This picks and installs a SINGLE room pattern into a SINGLE
  -- area of the room.
  --
  -- Recursive patterns merely add extra areas to the room's areas
  -- list, causing the caller to call this function again, until
  -- all areas are filled.  (i.e. we do not use recursion here)
  --


  local MIN_VHR = area.min_vhr or 1
  local MAX_VHR = area.max_vhr or 9

  assert(area.entry_vhr >= MIN_VHR)
  assert(area.entry_vhr <= MAX_VHR)


  -- only show debug messages for the top-level pattern
  local function local_debugf(...)
    if area.is_top or true then
      gui.debugf(...)
    end
  end


  local function new_floor(vhr)
    if not R.floors[vhr] then
      local FLOOR =
      {
        vhr = vhr
        conns = {}
      }

      R.floors[vhr] = FLOOR
    end

    return R.floors[vhr]
  end


  local SYMMETRY_SUMMARY =
  {
    x = 1, y = 1, xy = 2
  }


  local function new_walk_group()
    local GROUP =
    {
      seeds =
      {
        -- each element is: { S, sub }
      }

      -- 'vhr' field : non-NIL for installed groups
    }

    return GROUP
  end


  local function add_seed_to_walk_group(group, S, sub)
    table.insert(group.seeds, { S=S, sub=sub })

    -- if walk group has a vhr already, activate the sub-area now

    if group.vhr and not sub.entry_vhr then
      sub.entry_vhr = group.vhr
      sub.entry_S   = S
    end
  end


  local function install_vhr_to_walk_group(S, vhr)
    assert(vhr)

    local group = S.walk_group

    if not group then return end
    if group.vhr then return end

    group.vhr = vhr

    -- activate all inactive sub-areas in this group

    each G in group.seeds do
      -- already active?
      if not G.sub.entry_vhr then
        G.sub.entry_vhr = vhr
        G.sub.entry_S   = G.S
      end
    end
  end


  local function pattern_chance(pat)
    local factor = 1

    if not pat.prob then
      return 0
    end

--FIXME !!!!!! non-pure recursive patterns disabled for now
    if pat.recurse and pat.recurse != "pure" then return 0 end

if pat.recurse == "pure" then factor = factor * 100 end

    if pat.min_size > math.max(area.w, area.h) or
       pat.max_size < math.min(area.w, area.h)
    then
      return 0  -- too big or too small
    end

    if pat.elements["liquid"] and not LEVEL.liquid then
      return 0  -- liquids not available
    end

    if (pat.environment == "indoor"  and R.is_outdoor) or
       (pat.environment == "outdoor" and not R.is_outdoor)
    then
      return 0  -- wrong environment
    end

--[[
    if (pat.z_direction == "up"   and (#heights < 2 or (heights[1] > heights[2]))) or
       (pat.z_direction == "down" and (#heights < 2 or (heights[1] < heights[2])))
    then
      return 0  -- wrong z_direction
    end
--]]

    if (pat.level == "top" and not area.is_top) or
       (pat.level == "sub" and     area.is_top)
    then
      return 0  -- wrong level
    end

    if pat._overlay then
      if not PARAM.extra_floors then
        return 0  -- 3D floors not available
      end
    end

    -- enough symmetry?
    -- [NOTE: because of transposing, treat "x" == "y" here]
    local area_sym = SYMMETRY_SUMMARY[area.symmetry] or 0
    local  pat_sym = SYMMETRY_SUMMARY[ pat.symmetry] or 0

    if pat_sym < area_sym then return 0 end

    -- allow patterns with more symmetry than room, but reduce chance
    if pat_sym > area_sym then
      factor = factor / 10
    end

    -- OK --

    return pat.prob * factor
  end


  local function collect_usable_fabs()
    local solid_factor = 1.0
    if STYLE.junk == "heaps" then solid_factor = 3.0 end

    local liquid_factor = style_sel("liquids", 0, 0.2, 1.0, 5.0)

    local exfl_factor = style_sel("ex_floors", 0, 0.2, 1.0, 5.0)

    local tab = {}

    each name,pat in ROOM_PATTERNS do
      local prob = pattern_chance(pat)

      if pat.elements["solid"] then
        prob = prob * solid_factor
      end

      if pat.elements["liquid"] then
        prob = prob * liquid_factor
      end

      if pat._overlay then
        prob = prob * exfl_factor
      end

      if pat.shape == STYLE.room_shape then
        prob = prob * 20
      end

-- FIXME !!! : DISABLED CURVE_STAIR patterns for now
if pat.elements["curve_stair"] then
  prob = 0
end

      if prob > 0 then
        tab[name] = prob
      end
    end

    return tab
  end


  local function matching_sizes(list, target)
    local result

    each s in list do
      if Layout_total_size(s) == target then
        if not result then result = {} end
        table.insert(result, s)
      end
    end

    return result
  end


  local function setup_solid(S, pat, solid_tex)
    assert(not S.conn)

    S.kind = "void"
    S.w_tex = solid_tex  -- can be NIL

    if pat.solid_feature and R.use_solid_feature then 
      S.solid_feature = true
    end
  end


  local function setup_liquid(S)
    assert(LEVEL.liquid)
    S.kind = "liquid"
    R.has_liquid = true

    -- NOTE: floor_h for liquids is determined later
  end


  local function setup_stair(S)
    S.kind = "stair"
  end


  local function install_flat_floor()
    R.no_pattern = true

    local FLOOR = new_floor(area.entry_vhr)

    for x = area.x1, area.x2 do
    for y = area.y1, area.y2 do
      local S = SEEDS[x][y]

      -- currently this only happens in rooms with sub-rooms
      if S.room != R then continue end

      -- FIXME: BETTER CHUNK ARRANGEMENT
      local CHUNK =
      {
        sx1 = x, sx2 = x
        sy1 = y, sy2 = y

        kind = "floor"

        floor = FLOOR
      }

      table.insert(R.chunks, CHUNK)

      S.chunk[1] = CHUNK

      local C = S.conn or S.pseudo_conn

      if C then
        table.insert(FLOOR.conns, C)
      end

      install_vhr_to_walk_group(S, FLOOR.vhr)

    end -- x, y
    end
  end


  local function transform_by_size(s, x)
    local out_w = Layout_parse_size_digit(string.sub(s, x, x))

    local out_x = 1

    while x >= 2 do
      x = x - 1
      out_x = out_x + Layout_parse_size_digit(string.sub(s, x, x))
    end

    return out_x, out_w
  end


  local function transform_coord(T, x, y)
    -- input  : coordinate in pattern space
    -- output : coord range in room space : (1,1) is bottom left of area

    local w, h

    x, w = transform_by_size(T.x_size, x)
    y, h = transform_by_size(T.y_size, y)

    if T.mirror_x then
      x = T.long + 2 - x - w
    end

    if T.mirror_y then
      y = T.deep + 2 - y - h
    end

    if T.transpose then
      x, y = y, x
      w, h = h, w
    end

    x = area.x1 + x - 1
    y = area.y1 + y - 1

    return x, y, w, h
  end


  local function transform_dir(T, dir)
    if T.mirror_x then
      dir = geom.MIRROR_X[dir]
    end

    if T.mirror_y then
      dir = geom.MIRROR_Y[dir]
    end

    if T.transpose then
      dir = geom.TRANSPOSE[dir]
    end

    return assert(dir)
  end

  
  local function clear_sub_areas()
    for x = area.x1, area.x2 do
    for y = area.y1, area.y2 do
      SEEDS[x][y].sub_area = nil
    end
    end
  end


  local function activate_entry_sub(sub_areas)
    if table.empty(sub_areas) then return end

    -- this happens in start rooms or teleporter entry
    -- hence pick a random sub-area to activate
    if not area.entry_S then
      local idx = rand.irange(1, table.size(sub_areas))
      local sub = sub_areas[idx]

      sub.entry_vhr = area.entry_vhr
      return
    end

    local sx = area.entry_S.sx
    local sy = area.entry_S.sy

    each index,sub in sub_areas do
      if geom.inside_box(sx, sy, sub.x1, sub.y1, sub.x2, sub.y2)
      then
        sub.entry_vhr = area.entry_vhr
        sub.entry_S   = area.entry_S
        return
      end
    end

    -- getting here means area.entry_S touches a non-sub part of
    -- the pattern (i.e. a normal floor), and therefore a sub
    -- should have been activated already via a walk_group.
  end


  local function all_subs_connected(sub_areas)
    local g = sub_areas[1].group

    each index,sub in sub_areas do
      if sub.group != g then return false end
    end

    return true
  end


  local function merge_two_subs(sub_areas, A, B)
    assert(A and B)
    assert(A.group != B.group)

    local old_g = A.group
    local new_g = B.group

    each index,sub in sub_areas do
      if sub.group == old_g then
         sub.group =  new_g
      end
    end
  end


  local function try_connect_two_subs(sub_areas)
    local locs = {}

    for x = area.x1, area.x2 do
    for y = area.y1, area.y2 do
      local S = SEEDS[x][y]

      if not S.sub_area then continue end

      for dir = 6,8,2 do
        local N = S:neighbor(dir)

        if not N or N.free then continue end

        if N.sx > area.x2 then continue end
        if N.sy > area.y2 then continue end

        if not N.sub_area then continue end

        -- sub areas already connected (or the same) ?
        if N.sub_area.group == S.sub_area.group then continue end

        -- both seeds already in a walk_group
        -- ( not allowed because we cannot merge walkgroups )
        if S.walk_group and N.walk_group then continue end

        -- OK this is possible
        table.insert(locs, { S=S, N=N, dir=dir, score=gui.random() })

      end -- dir

    end -- x, y
    end

    if #locs == 0 then
      error("Failed to connect sub-areas in recursive pattern")
    end

    local loc = table.pick_best(locs, function(A, B) return A.score > B.score end)

    local S = loc.S
    local N = loc.N

    local group = S.walk_group or N.walk_group
    if not group then
      group = new_walk_group()
    end

    add_seed_to_walk_group(group, S, S.sub_area)
    add_seed_to_walk_group(group, N, N.sub_area)

    S.walk_group = group
    N.walk_group = group

    gui.debugf("Connected subs %d --> %d @ %s dir:%d\n",
               S.sub_area.id, N.sub_area.id, S:tostr(), loc.dir)

    merge_two_subs(sub_areas, S.sub_area, N.sub_area)
  end


  local function connect_sub_areas(sub_areas)
    if table.size(sub_areas) < 2 then return end

    each index,sub in sub_areas do
      sub.group = index
    end

    while not all_subs_connected(sub_areas) do
      try_connect_two_subs(sub_areas)
    end
  end


  local function dump_sub_areas(sub_areas)
    if table.empty(sub_areas) then return end

    gui.debugf("Sub areas:\n")

    each idx,sub in sub_areas do
      gui.debugf("  SUB_%d : (%d %d) .. (%d %d)  entry: %s  %s\n",
                 sub.id, sub.x1, sub.y1, sub.x2, sub.y2,
                 tostring(sub.entry_vhr), sel(sub.filled, "FILLED", ""))
    end
  end


  local function touches_outdoor_border(tx1, ty1, tx2, ty2)
    for x = tx1, tx2 do
    for y = ty1, ty2 do
      if not Seed_valid(x, y) then continue end

      local B = SEEDS[x][y].map_border

      if B and B.room == R then return true end
    end
    end

    return false
  end


  local function touches_building_on_side(tx1, ty1, tx2, ty2)
    local seen_R

    for x = tx1, tx2 do
    for y = ty1, ty2 do
      if not Seed_valid(x, y) then continue end

      local S = SEEDS[x][y]

      local R2 = S.room

      if not R2 then return nil end
      if R2 == R then return nil end

      if R2.is_outdoor then return nil end
      if R2.kind == "cave" then return nil end

      seen_R = R2

    end -- x, y
    end

    return seen_R
  end


  local function touches_a_building(sx1, sy1, sx2, sy2)
    local got_R
    local got_side

    for side = 2,8,2 do
      local tx1, ty1 = sx1, sy1
      local tx2, ty2 = sx2, sy2

      if side == 2 then ty1 = ty1 - 1 ; ty2 = ty1 end
      if side == 8 then ty2 = ty2 + 1 ; ty1 = ty2 end
      if side == 4 then tx1 = tx1 - 1 ; tx2 = tx1 end
      if side == 6 then tx2 = tx2 + 1 ; tx1 = tx2 end

      -- do not allow outdoor solids to touch a border piece
      if touches_outdoor_border(tx1, ty1, tx2, ty2) then
        return nil
      end

      local R2 = touches_building_on_side(tx1, ty1, tx2, ty2)

      if R2 then
        got_R = R2
        got_side = side
      end
    end

    return got_R, got_side
  end


  local function update_seen_floors(T, floor_num)
    T.min_floor = math.min(T.min_floor or  99, floor_num)
    T.max_floor = math.max(T.max_floor or -99, floor_num)
  end


  local function eval_a_chunk(pat, px, py, T, sx1, sy1, sw, sh)
    local sx2 = sx1 + sw - 1
    local sy2 = sy1 + sh - 1

    assert(area.x1 <= sx1 and sx2 <= area.x2)
    assert(area.y1 <= sy1 and sy2 <= area.y2)

    local P = pat._structure[px][py]

    if P.kind == "sub_area" then
      -- sub-areas of recursive patterns trivially succeed
      return 0
    end

    local OV
    if pat._overlay then
      OV = pat._overlay[px][py]
    end

    -- in outdoor rooms, a solid at edge of pattern must touch a building
    if P.kind == "solid" and R.is_outdoor and
       (px == 1 or px == pat._structure.w or
        py == 1 or py == pat._structure.h)
    then
      if not touches_a_building(sx1, sy1, sx2, sy2) then
        return -1
      end
    end 

    -- the overlay floor overrides any floor underneath
    local floor = P.floor
    if OV and OV.kind == "floor" then
      floor = OV.floor
    end

    if         P.kind == "floor" then update_seen_floors(T,  P.floor) end
    if OV and OV.kind == "floor" then update_seen_floors(T, OV.floor) end


    for sx = sx1, sx2 do
    for sy = sy1, sy2 do
      local S = SEEDS[sx][sy]
      assert(S and S.room == R)

      -- don't place 3D floors on a marked secret
      -- (it does not work well with the DOOM secret sector special)
      -- FIXME : relax this for Quake
      if S.mark_secret and OV and OV.kind != "empty" then
        return -1
      end

      -- connections must join onto a floor
      if (S == area.entry_S or S.conn or S.pseudo_conn or S.walk_group or S.must_walk) then
        if not floor then
          return -1  -- FAIL --
        end

        T.joined_floors[floor] = 1
      end

      -- remember which floor-id we enter the area at
      if S == area.entry_S then
        T.entry_floor = floor
      end

    end -- sx, sy
    end

    return 0  -- OK --
  end


  local function install_a_chunk(pat, px, py, T, sx1, sy1, sw, sh)
    local sx2 = sx1 + sw - 1
    local sy2 = sy1 + sh - 1

    local P = pat._structure[px][py]

    -- for recursive sub-areas, merely mark the bounds
    if P.kind == "sub_area" then
      local sub = T.sub_areas[P.area]

      if not sub then
        sub =
        {
          id = Plan_alloc_id("sub_area")
        }

        T.sub_areas[P.area] = sub

        table.insert(R.areas, sub)
      end

      sub.x1 = math.min(sx1, sub.x1 or  999)
      sub.y1 = math.min(sy1, sub.y1 or  999)
      sub.x2 = math.max(sx2, sub.x2 or -999)
      sub.y2 = math.max(sy2, sub.y2 or -999)

      -- this is only needed for connect_sub_areas()
      for sx = sx1, sx2 do
      for sy = sy1, sy2 do
        SEEDS[sx][sy].sub_area = sub
      end
      end

      return
    end

    -- store the chunk information in a CHUNK object
    local CHUNK =
    {
      sx1 = sx1
      sy1 = sy1
      sx2 = sx2
      sy2 = sy2

      kind = P.kind
    }

    table.insert(R.chunks, CHUNK)

    if P.dir then
      CHUNK.dir = transform_dir(T, P.dir)
    end

    if P.kind == "stair" then
      assert(CHUNK.dir)

      local vhr1 = area.entry_vhr + (P.src_floor  - T.entry_floor)
      local vhr2 = area.entry_vhr + (P.dest_floor - T.entry_floor)

      CHUNK.src_floor  = new_floor(vhr1)
      CHUNK.dest_floor = new_floor(vhr2)

    elseif P.kind == "floor" then

      local vhr = area.entry_vhr + P.floor - T.entry_floor

      CHUNK.floor = new_floor(vhr)
    end


    local OVERLAY

    if pat._overlay then
      local OV = pat._overlay[px][py]

      if OV.kind == "floor" then
        local vhr = area.entry_vhr + OV.floor - T.entry_floor

        OVERLAY =
        {
          kind = "floor"

          sx1 = sx1
          sy1 = sy1
          sx2 = sx2
          sy2 = sy2

          floor = new_floor(vhr)

          is_overlay = true
        }

        table.insert(R.chunks, OVERLAY)
      end

      R.has_3d_floor = true

      if CHUNK.kind == "liquid" then
        R.has_3d_liq_bridge = true
      end
    end

    -- solid edge bits in outdoor rooms -- they conceptually extend the
    -- touching building
    local solid_tex

    if P.kind == "solid" and R.is_outdoor and
       (px == 1 or px == pat._structure.w or
        py == 1 or py == pat._structure.h)
    then
      local R2 = touches_a_building(sx1, sy1, sx2, sy2)
      assert(R2)

      solid_tex = R2.facade
    end

    -- update the seeds --

    for sx = sx1, sx2 do
    for sy = sy1, sy2 do
      local S = SEEDS[sx][sy]

      S.chunk[1] = CHUNK
      S.chunk[2] = OVERLAY

      if S.walk_group then
        local vhr

        if CHUNK.kind == "floor" then
          vhr = CHUNK.floor.vhr
        end
        if OVERLAY and OVERLAY.kind == "floor" then
          if not vhr or rand.odds(50) then
            vhr = OVERLAY.floor.vhr
          end
        end

        install_vhr_to_walk_group(S, vhr)
      end

      if P.kind == "liquid" then
        setup_liquid(S)

      elseif P.kind == "solid" then
        setup_solid(S, pat, solid_tex)

      elseif P.kind == "stair" then
        S.kind = "stair"

      elseif P.kind == "floor" then
        --???

      end
    end -- sx, sy
    end
  end


  local function check_vhr_overflow(T)
    -- there will be NO floors with pure recursive patterns
    if not T.min_floor then return end
    assert(T.max_floor)

    local vhr1 = area.entry_vhr + T.min_floor - T.entry_floor
    local vhr2 = area.entry_vhr + T.max_floor - T.entry_floor

    if vhr1 < MIN_VHR then return true end
    if vhr2 > MAX_VHR then return true end

    return false  -- all is well
  end


  local function eval_pattern(pat, T)
    local score = 0

    T.min_floor = nil
    T.max_floor = nil

    T.entry_floor = nil

    T.joined_floors = {}

    local W = pat._structure.w
    local H = pat._structure.h

    for px = 1, W do
    for py = 1, H do
      local sx, sy, sw, sh = transform_coord(T, px, py)

      if sw == 0 or sh == 0 then continue end

      local eval = eval_a_chunk(pat, px, py, T, sx, sy, sw, sh)

      if eval < 0 then
        return -1  -- pattern not possible
      end

      score = score + eval
    end -- px, py
    end

    -- this only happens for START room and teleporter destinations
    -- (and pure recursive patterns)
    if not T.entry_floor then
      T.entry_floor = 0
    end

    if check_vhr_overflow(T) then
      return -1
    end

    -- the more used floors, the better
    score = score + 100 * table.size(T.joined_floors)

    -- tie breaker
    return score + gui.random()
  end


  local function install_pattern(pat, T)
    T.sub_areas = {}

    local W = pat._structure.w
    local H = pat._structure.h

    for px = 1, W do
    for py = 1, H do
      local sx, sy, sw, sh = transform_coord(T, px, py)

      if sw == 0 or sh == 0 then continue end

      install_a_chunk(pat, px, py, T, sx, sy, sw, sh)
    end -- x, y
    end

    activate_entry_sub(T.sub_areas)

    connect_sub_areas(T.sub_areas)

    dump_sub_areas(T.sub_areas)

    -- remove seed.sub_area fields
    clear_sub_areas()
  end


  local function try_one_pattern(pat)
    -- test all eight possible transforms (transpose + mirror_x + mirror_y)
    -- and check which versions can be used in the area.  If at least one
    -- is successful, then pick it and install it into the room.

    local list = {}

    local T = {}  -- represents current transform

    for trans = 0, 1 do
      T.transpose = (trans == 1)

      T.long = sel(T.transpose, area.h, area.w)
      T.deep = sel(T.transpose, area.w, area.h)

      local x_sizes = matching_sizes(pat.x_sizes, T.long)
      local y_sizes = matching_sizes(pat.y_sizes, T.deep)

      -- check if the pattern can fit in the area
      if not x_sizes or not y_sizes then
        continue
      end

      rand.shuffle(x_sizes)
      rand.shuffle(y_sizes)

      -- iterate over the size possibilities
      each xs in x_sizes do
      each ys in y_sizes do
        T.x_size = xs
        T.y_size = ys

        local x_mir_tot = 1
        local y_mir_tot = 1

        -- no need to try the mirrored version when symmetrical
        if pat.symmetry == "x" or pat.symmetry == "xy" then x_mir_tot = 0 end
        if pat.symmetry == "y" or pat.symmetry == "xy" then y_mir_tot = 0 end

        -- iterate over each mirroring transform
        for x_mir = 0, x_mir_tot do
        for y_mir = 0, y_mir_tot do
          T.mirror_x = (x_mir == 1)
          T.mirror_y = (y_mir == 1)

          T.score = eval_pattern(pat, T)

          if T.score > 0 then
            table.insert(list, table.copy(T))
          end
        end -- x_mir, y_mir
        end

      end -- xs, ys 
      end

    end -- trans

    local_debugf("    Possible transforms: %d\n", #list)

    if #list == 0 then
      return false
    end

    -- pick one to install

    T = table.pick_best(list, function(A, B) return A.score > B.score end)

    install_pattern(pat, T)

    return true
  end


  local function test_patterns()
    if R.children then return false end

    local prob_tab = collect_usable_fabs()

    -- for speed reasons, limit number of patterns we try
    local try_count = 20

    for loop = 1, try_count do
      if table.empty(prob_tab) then
        break;
      end

      local name = rand.key_by_probs(prob_tab)
      prob_tab[name] = nil

      local_debugf("  Trying %s in %s..... (loop %d)\n",
                   name, R:tostr(), loop)

      local pat = ROOM_PATTERNS[name]
      assert(pat)

      if try_one_pattern(pat) then
        local_debugf("  SUCCESS with %s\n", name)
        return true
      end
    end -- loop

    local_debugf("  FAILED to apply any room pattern\n")
    return false
  end


  ---| Layout_pattern_in_area |---

  area.w, area.h = geom.group_size(area.x1, area.y1, area.x2, area.y2)

  local_debugf("Layout_pattern @ %s : SUB_%d (%d %d) %dx%d\n",
               R:tostr(), area.id, area.x1, area.y1, area.w, area.h)

  assert(R.kind != "cave")
  assert(R.kind != "hallway")
  assert(R.kind != "stairwell")

  if not test_patterns() then
    install_flat_floor()
  end

  local_debugf("\n")
end



function Layout_height_realization(R, entry_h)
  --
  -- the virtual becomes reality, and it happens here...
  --

  local INDOOR_DELTAS  = { [16]=5,  [32]=10, [48]=20, [64]=20, [96]=10, [128]=5 }
  local OUTDOOR_DELTAS = {          [32]=20, [48]=30, [80]=20, [112]=5 }


  local function find_vhr_range()
    R.min_vhr =  999
    R.max_vhr = -999

    local function add_floor(F)
      if not F then return end
      assert(F.vhr)
      R.min_vhr = math.min(R.min_vhr, F.vhr)
      R.max_vhr = math.max(R.max_vhr, F.vhr)
    end

    each chunk in R.chunks do
      add_floor(chunk.floor)
      add_floor(chunk.src_floor)
      add_floor(chunk.dest_floor)
    end

    assert(R.min_vhr <= R.max_vhr)
  end


  local function adjust_list(deltas, vhr, dir, extra_z)
    while deltas[vhr] do
      deltas[vhr] = deltas[vhr] + extra_z
      vhr = vhr + dir
    end
  end


  local function adjust_for_3d_floors(deltas)
    -- this ensures that there is enough room between two storeys
    -- for the player to pass, even more space for connections.

    -- TODO : support more than one overlay !!!

    for x = R.tx1, R.tx2 do
    for y = R.ty1, R.ty2 do
      local S = SEEDS[x][y]
      if S.room != R then continue end

      local chunk   = S.chunk[1]
      local overlay = S.chunk[2]

      if not chunk then continue end
      if not chunk.floor then continue end

      if not overlay then continue end
      if not overlay.floor then continue end

      local v_low  =   chunk.floor.vhr
      local v_high = overlay.floor.vhr

      assert(v_low)
      assert(v_high)

      if not v_low then
        if chunk.kind == "liquid" then
          v_low = assert(R.min_vhr)
        else  -- FIXME !!!! handle stairs (etc) here
          continue
        end
      end

gui.debugf("adjust_deltas : vhr range %d..%d\n", v_low, v_high)
      assert(v_high > v_low)

      assert(deltas[v_low])
      assert(deltas[v_high])

      local gap_z = deltas[v_high] - deltas[v_low]

      -- gap includes thickness of floor
      local want_gap = 104

      if S.conn then
        local where = S.conn:get_where(R)
gui.debugf("  conn where = %s\n", tostring(where))

        if where and where.vhr < v_high then
          want_gap = 176
        end
      end
gui.debugf("  gap_z --> %d  want_gap --> %d\n", gap_z, want_gap)

      if gap_z < want_gap then
        -- need to increase the gap between these two floors
        -- TODO : if vhr diff >= 2, adjust vhrs in between
        if v_high > R.entry_vhr then
          adjust_list(deltas, v_high, 1, want_gap - gap_z)
        else
          assert(v_low < R.entry_vhr)
          adjust_list(deltas, v_low, -1, gap_z - want_gap)
        end
      end
    end -- x, y
    end
  end


  local function delta_tab_for_room()
    -- apply the Steepness style

    if STYLE.steepness == "none" then
      return { [16] = 50 }
    end

    local tab

    if R.is_outdoor then
      tab = table.copy(OUTDOOR_DELTAS)
    else
      tab = table.copy(INDOOR_DELTAS)
    end

    if STYLE.steepness == "few" then
      if tab[16] then tab[16] = tab[16] * 8 end
      if tab[32] then tab[32] = tab[32] * 4 end
      if tab[48] then tab[48] = tab[48] * 2 end

    elseif STYLE.steepness == "heaps" then
      if tab[16] then tab[16] = tab[16] / 8 end
      if tab[32] then tab[32] = tab[32] / 4 end
      if tab[48] then tab[48] = tab[48] / 2 end
    end

    return tab
  end


  local function select_deltas()
    -- resulting table is indexed by a virtual floor id.

    local tab = {}

    local delta_tab = delta_tab_for_room() sel(R.is_outdoor, OUTDOOR_DELTAS, INDOOR_DELTAS)

    tab[5] = 0

    for i = 0, 4 do
      local d1 = rand.key_by_probs(delta_tab)
      local d2 = rand.key_by_probs(delta_tab)

      tab[6 + i] = tab[5 + i] + d1
      tab[4 - i] = tab[5 - i] - d2
    end

    return tab
  end


  local function assign_heights(deltas)
    each vhr,F in R.floors do
      assert(deltas[vhr])

      F.floor_h = entry_h + deltas[vhr]

      each C in F.conns do
        if C.R1 == R then
          C.conn_h = F.floor_h
        end
      end
    end
  end


  local function fix_up_seeds()
    for x = R.tx1, R.tx2 do
    for y = R.ty1, R.ty2 do
      local S = SEEDS[x][y]
      if S.room != R then continue end

      local chunk = S.chunk[1]

      if chunk and chunk.floor then
        S.floor_h = assert(chunk.floor.floor_h)

      elseif chunk and chunk.src_floor then
        -- stairs
        local z1 = assert(chunk. src_floor.floor_h)
        local z2 = assert(chunk.dest_floor.floor_h)

        S.floor_h     = math.min(z1, z2)
        S.floor_max_h = math.max(z1, z2)
      end
    end -- x, y
    end
  end


  ---| Layout_height_realization |---

  find_vhr_range()

  assert(R.min_vhr)

  -- NOTE: gaps in R.floors[] are allowed


  -- which virtual floor did we enter this room?
  local entry_vhr = assert(R.entry_vhr)

  assert(R.min_vhr <= entry_vhr and entry_vhr <= R.max_vhr)

  local deltas = select_deltas()

  adjust_for_3d_floors(deltas)

gui.debugf("entry_h:%d deltas =\n%s\n", entry_h, table.tostr(deltas))


  -- apply the results to all the FLOOR objects
  assign_heights(deltas)

  fix_up_seeds()

  Layout_set_floor_minmax(R)
end



function Layout_post_processing(R)
  --
  -- This function sets up some stuff after a room pattern has
  -- been installed.  In particular it :
  --   1. determines heights for stairs
  --   2. handles diagonal seeds
  --

  local function process_stair(S)
    local N = S:neighbor(S.stair_dir)

    assert(N and N.room == R)
    assert(R:contains_seed(N.sx, N.sy))

    -- source height already determined (in setup_stair)
    assert(S.stair_z1)

    if not N.floor_h then
      gui.debugf("Bad stair @ %s in %s\n", S:tostr(), S.room:tostr())
      error("Bad stair : destination not walkable")
    end

    S.stair_z2 = N.floor_h
    S.z2_tex   = N.f_tex

    -- check if a stair is really needed
    if math.abs(S.stair_z1 - S.stair_z2) < 17 then
      S.kind = "walk"
      S.floor_h = int((S.stair_z1 + S.stair_z2) / 2)

      S.f_tex = N.f_tex
      S.w_tex = N.w_tex
    end

    -- check if too high, make a lift instead
    -- TODO: "lifty" mode, use > 55 or whatever
    if THEME.lifts and math.abs(S.stair_z1 - S.stair_z2) > 110 then
      S.kind = "lift"
      S.room.has_lift = true
    end
  end

  local function process_curve_stair(S)
    assert(S.x_side and S.y_side)

    local NX = S:neighbor(S.x_side)
    local NY = S:neighbor(S.y_side)

    S.x_height = assert(NX.floor_h)
    S.y_height = assert(NY.floor_h)

    S.floor_h = math.max(S.x_height, S.y_height)

    -- check if a stair is really needed
    if math.abs(S.x_height - S.y_height) < 17 then
      S.kind = "walk"
      S.floor_h = int((S.x_height + S.y_height) / 2)

      S.f_tex = NX.f_tex or NY.f_tex
      S.w_tex = NX.w_tex or NY.w_tex

      return
    end

    -- determine if can use tall stair

    if not R.is_outdoor then
      local OX = S:neighbor(10 - S.x_side)
      local OY = S:neighbor(10 - S.y_side)

      local x_void = not (OX and OX.room and OX.room == R) or (OX.kind == "void")
      local y_void = not (OY and OY.room and OY.room == R) or (OY.kind == "void")

      if x_void and y_void then
        S.kind = "tall_stair"
      end
    end
  end


  local function diag_neighbor(N)
    if not (N and N.room and N.room == R) then
      return "void"
    end

    if N.kind == "void" or N.kind == "diagonal" then
      return "void"
    end

    if N.kind == "liquid" then
      return "liquid", assert(N.floor_h), N.f_tex
    end

    return "walk", assert(N.floor_h), N.f_tex
  end

  local DIAG_CORNER_TAB =
  {
    ["L/"] = 7, ["L%"] = 1, ["LZ"] = 3, ["LN"] = 1,
    ["H/"] = 3, ["H%"] = 9, ["HZ"] = 7, ["HN"] = 9,
  }

  local function process_diagonal(S)
gui.debugf("Processing diagonal @ %s\n", S:tostr())
    local low, high

    if S.diag_char == 'Z' or S.diag_char == 'N' then
      low  = S:neighbor(2)
      high = S:neighbor(8)
    else
      low  = S:neighbor(4)
      high = S:neighbor(6)
    end

    local l_kind, l_z, l_ftex
    local h_kind, h_z, h_ftex

    l_kind, l_z, l_ftex = diag_neighbor(low)
    h_kind, h_z, h_ftex = diag_neighbor(high)

    if l_kind == "void" and h_kind == "void" then
gui.debugf("BOTH VOID\n")
      S.kind = "void"
      return
    end

    if l_kind == "liquid" and h_kind == "liquid" then
gui.debugf("BOTH LIQUID\n")
      S.kind = "liquid"
      return
    end

    if l_kind == "walk" and h_kind == "walk" and math.abs(l_z-h_z) < 0.5 then
gui.debugf("BOTH SAME HEIGHT\n")
      S.kind = "walk"
      S.floor_h = l_z
      return
    end

    local who_solid

        if l_kind == "void"   then who_solid = 'L'
    elseif h_kind == "void"   then who_solid = 'H'
    elseif l_kind == "liquid" then who_solid = 'H'
    elseif h_kind == "liquid" then who_solid = 'L'
    else
      who_solid = sel(l_z > h_z, 'L', 'H')
    end

    S.stuckie_side = DIAG_CORNER_TAB[who_solid .. S.diag_char]
    assert(S.stuckie_side)

    S.stuckie_kind = sel(who_solid == 'L', l_kind, h_kind)
    S.stuckie_z    = sel(who_solid == 'L', l_z   , h_z)
    S.stuckie_ftex = sel(who_solid == 'L', l_ftex, h_ftex)

    S.diag_new_kind = sel(who_solid == 'L', h_kind, l_kind)
    S.diag_new_z    = sel(who_solid == 'L', h_z   , l_z)
    S.diag_new_ftex = sel(who_solid == 'L', h_ftex, l_ftex)

    assert(S.diag_new_kind != "void")

    if low  and  low.room == R then  low.solid_feature = nil end
    if high and high.room == R then high.solid_feature = nil end
  end


  local function handle_stairs()
    for x = R.tx1, R.tx2 do
    for y = R.ty1, R.ty2 do
      local S = SEEDS[x][y]

      assert(S.room == R)

      if S.kind == "stair" then
        process_stair(S)

      elseif S.kind == "curve_stair" then
        process_curve_stair(S)
      end
    end -- x, y
    end
  end


  local function handle_diagonals()
    for x = R.tx1, R.tx2 do
    for y = R.ty1, R.ty2 do
      local S = SEEDS[x][y]

      assert(S.room == R)

      if S.kind == "diagonal" then
        process_diagonal(S)
      end
    end -- x, y
    end
  end


  ---| Layout_post_processing |---

  if R.no_pattern then return end

---???  handle_stairs()

  -- need to do diagonals AFTER stairs
  handle_diagonals()
end



function Layout_room(R)

  local function junk_sides()
    -- Adds solid seeds (kind "void") to the edges of large rooms.
    -- These seeds can be put to other uses later, such as: cages,
    -- monster closets, or secrets.
    --
    -- The best side is on the largest axis (minimises number of
    -- junked seeds), and prefer no connections on that side.
    -- Each side is only junked once.

    -- FIXME: occasionaly make ledge-cages in OUTDOOR rooms

    local JUNK_PROBS = { 0, 0, 20, 35, 50 }
    local JUNK_HEAPS = { 0, 0, 50, 85, 99 }


    local function eval_side(side)
      local th = R.junk_thick[side]

      if STYLE.junk == "none" or (STYLE.junk == "few" and rand.odds(70)) then
        return false
      end

      -- size checking
      local long = R.sw - R.junk_thick[4] - R.junk_thick[6]
      local deep = R.sh - R.junk_thick[2] - R.junk_thick[8]

      if R.mirror_x then long = int((long+3) / 2) end
      if R.mirror_y then deep = int((deep+3) / 2) end

      if geom.is_vert(side) then long,deep = deep,long end

      if long <= 2 then return false end

      if long > 5 then long = 5 end

      local prob = JUNK_PROBS[long]
      if STYLE.junk == "heaps" then prob = JUNK_HEAPS[long] end

      assert(prob)
      if not rand.odds(prob) then return false end


      -- connection checking
      local x1,y1, x2,y2 = geom.side_coords(side, R.sx1,R.sy1, R.sx2,R.sy2)
      local dx, dy = geom.delta(side)

      x1, y1 = x1-dx*th, y1-dy*th
      x2, y2 = x2-dx*th, y2-dy*th

      local hit_conn = 0

      for x = x1, x2 do
      for y = y1, y2 do
        for who = 1,3 do
          local S = SEEDS[x][y]
          if who == 2 then S = R.mirror_x and S.x_peer end
          if who == 3 then S = R.mirror_y and S.y_peer end

          if S then
            if S.room != R then return false end
            if not (S.kind == "walk" or S.kind == "void") then return false end

            if S.conn or S.pseudo_conn then
              hit_conn = hit_conn + 1
            end
          end
        end -- who
      end -- x,y
      end

      -- Cannot allow "gaps" for connections (yet....)
      if hit_conn > 0 then return false end

      return true
    end


    local function apply_junk_side(side)
      local th = R.junk_thick[side]

      local x1,y1, x2,y2 = geom.side_coords(side, R.sx1,R.sy1, R.sx2,R.sy2)
      local dx, dy = geom.delta(side)

      x1, y1 = x1-dx*th, y1-dy*th
      x2, y2 = x2-dx*th, y2-dy*th

      local p_conns = {}

      for x = x1, x2 do
      for y = y1, y2 do
        for who = 1,3 do
          local S = SEEDS[x][y]
          if who == 2 then S = R.mirror_x and S.x_peer end
          if who == 3 then S = R.mirror_y and S.y_peer end

          if S then
            if S.conn or S.pseudo_conn then
              error("Junked CONN!")
--??              local P = { x=x-dx, y=y-dy, conn=S.conn or S.pseudo_conn }
--??              table.insert(p_conns, P)
            elseif S.kind == "walk" then
              S.kind = "void"
              S.junked = true

              R.tvolume = R.tvolume - 1
            end
          end
        end -- who
      end -- x,y
      end

--??      each P in p_conns do
--??        SEEDS[P.x][P.y].pseudo_conn = P.conn
--??      end

      R.junk_thick[side] = R.junk_thick[side] + 1

      gui.debugf("Junked side:%d @ %s\n", side, R:tostr())

      if (geom.is_horiz(side) and R.mirror_x) or
         (geom.is_vert (side) and R.mirror_y)
      then
        side = 10 - side

        R.junk_thick[side] = R.junk_thick[side] + 1

        gui.debugf("and Junked mirrored side:%d\n", side)
      end
    end


    --| junk_sides |--

    R.tx1, R.ty1 = R.sx1, R.sy1
    R.tx2, R.ty2 = R.sx2, R.sy2
    R.tw,  R.th  = R.sw,  R.sh

    R.tvolume = R.svolume

    R.junk_thick = { [2]=0, [4]=0, [6]=0, [8]=0 }

    if R.kind != "building" then return end
    if R.children then return end


    local SIDES = { 2,4 }
    if not R.mirror_x then table.insert(SIDES,6) end
    if not R.mirror_y then table.insert(SIDES,8) end

    rand.shuffle(SIDES)

    each side in SIDES do
      if eval_side(side) then
        apply_junk_side(side)
      end
    end

    R.tx1 = R.sx1 + R.junk_thick[4]
    R.ty1 = R.sy1 + R.junk_thick[2]

    R.tx2 = R.sx2 - R.junk_thick[6]
    R.ty2 = R.sy2 - R.junk_thick[8]

    R.tw, R.th = geom.group_size(R.tx1, R.ty1, R.tx2, R.ty2)
  end


  local function stairwell_height_diff()
    -- FIXME: check all this
    local focus_C = R.conns[1]

    local other_C = R.conns[2]
    if other_C == focus_C then other_C = R.conns[1] end

    assert(focus_C.conn_h)
    assert(not other_C.conn_h)

    other_C.conn_h = focus_C.conn_h

    if true then
      local delta = rand.pick { -2,-2,-1, 1,2,2 }

      other_C.conn_h = other_C.conn_h + delta * 64

      if other_C.conn_h > 384 then other_C.conn_h = 384 end
      if other_C.conn_h <   0 then other_C.conn_h =   0 end
    end
  end


  local function pick_floor_texture(last_tex)
    if R.kind == "outdoor" then
      return R.main_tex
    end

    if not R.theme.floors then
      return R.main_tex
    end

    local tex

    for loop = 1, 3 do
      tex = rand.key_by_probs(R.theme.floors)

      if not last_tex or tex != last_tex then
        break;
      end
    end

    return tex
  end


  -- TODO : this is similar to fix_up_seeds(), maybe merge ??
  local function assign_floor_texs()
    for x = R.tx1, R.tx2 do
    for y = R.ty1, R.ty2 do
      local S = SEEDS[x][y]
      if S.room != R then continue end

      local chunk = S.chunk[1]

      if chunk and chunk.floor then
        S.f_tex = assert(chunk.floor.floor_tex)
      end
    end -- x, y
    end
  end


  local function select_floor_texs()
    local entry_f_tex
    local entry_vhr = R.entry_vhr

    local focus_C = R.entry_conn

    if focus_C and focus_C.conn_ftex and
       focus_C.R1.kind == focus_C.R2.kind and
       focus_C.kind != "teleporter" and
       not focus_C.fresh_floor
    then
      entry_f_tex = focus_C.conn_ftex
    end

    local last_tex

    each vhr,F in R.floors do
      if vhr == entry_vhr and entry_f_tex then
        F.floor_tex = entry_f_tex

      elseif vhr == (entry_vhr - 1) and entry_f_tex then
        F.floor_tex = pick_floor_texture(entry_f_tex)

      else
        F.floor_tex = pick_floor_texture(last_tex)
      end

      last_tex = F.floor_tex

      -- handle connections too
      each C in F.conns do
        if C.R1 == R then
          C.conn_ftex = F.floor_tex
        end
      end
    end

    assign_floor_texs()
  end


  local function OLD__select_heights(focus_C)

    local function gen_group(base_h, num, dir)
      local list = {}
      local delta_tab = sel(R.is_outdoor, OUTDOOR_DELTAS, INDOOR_DELTAS)

      for i = 1,num do
        table.insert(list, base_h)
        local delta = rand.key_by_probs(delta_tab)
        base_h = base_h + dir * delta
      end

      return list
    end


    ---| select_heights |---

    local base_h = focus_C.conn_h

    -- determine vertical momentum
    local mom_z = 0
    if R.entry_conn then
      local C2 = R.entry_conn.R1.entry_conn
      if C2 and C2.conn_h and C2.conn_h != base_h then
        mom_z = sel(C2.conn_h < base_h, 1, -1)
      end

      if mom_z == 0 then
        if base_h <= 128 then mom_z = 1 end
        if base_h >= SKY_H-128 then mom_z = -1 end
      end

      gui.debugf("Vertical momentum @ %s = %d\n", R:tostr(), mom_z)
    end

    local groups = {}

    for i = 1,10 do
      local dir = rand.sel(50, 1, -1)
      local hts = gen_group(base_h, 4, dir)

      local cost = math.abs(base_h - hts[4])

      cost = cost + gui.random() * 40

      if dir != mom_z       then cost = cost + 100 end
      if hts[4] <= -100     then cost = cost + 200 end
      if hts[4] >= SKY_H+60 then cost = cost + 300 end

      table.insert(groups, { hts=hts, dir=dir, cost=cost })
    end

    local g_info = table.pick_best(groups,
                      function(A,B) return A.cost < B.cost end)

    return g_info.hts
  end


  local function pick_unvisited_area()
    each A in R.areas do
      -- already done?
      if A.filled then continue end

      -- need an entry height
      if not A.entry_vhr then
gui.debugf("(skip SUB_%s : no entry_vhr)\n", tostring(A.id))
      continue end

      return A  -- OK
    end

    return nil  -- all areas are filled
  end


  local function fill_room(entry_h)
    R.entry_vhr = 5

    R.use_solid_feature = rand.odds(75) and (not R.is_outdoor)

    -- create intiial area
    local AREA =
    {
      id = Plan_alloc_id("sub_area")

      x1 = R.tx1
      y1 = R.ty1
      x2 = R.tx2
      y2 = R.ty2

      entry_vhr = R.entry_vhr
    }

    if R.entry_conn then
      if R.entry_conn.R1 == R then
        AREA.entry_S = R.entry_conn.S1  -- may be nil (teleporters)
      else
        AREA.entry_S = R.entry_conn.S2  -- ditto
      end
    end

    R.areas = { AREA }

    AREA.symmetry = R.symmetry
    AREA.is_top   = true

    -- iterate over areas until all are filled.
    -- recursive patterns will add extra areas as we go.

    while true do
      local A = pick_unvisited_area()

      if not A then break; end

      Layout_pattern_in_area(R, A)

      A.filled = true
    end

    -- validate all areas were filled
    each A in R.areas do
      if not A.filled then
        error("Layout_room failed to fill all areas")
      end
    end
  end


  local function assign_a_conn(C, S, place)
    -- place is "lower" for the ground floor and "upper" for any 3D
    -- floor above the ground floor.

    local chunk = S.chunk[1]

    if place == "upper" then
      local n = 2

      while S.chunk[n + 1] and rand.odds(60) do
        n = n + 1
      end

      chunk = assert(S.chunk[n])
    end


    local floor = assert(chunk.floor)

    assert(floor.vhr)
    assert(R.floors[floor.vhr] == floor)

    C:set_where(R, floor)

    table.insert(floor.conns, C)
  end


  local function assign_conns_to_floors()
    --
    -- Pick which connections will enter/leave on what (3D) floors.
    --
    -- When there are 2 or more conns, we want at least one of each.
    -- If only one connection, usually pick the upper floor since
    -- most importants can only exist in a 3D-floor-free spot.
    --
    -- The decision logic here only looks at two floors (lower and
    -- upper), however when assigning connections to "upper" it can
    -- use any extra 3D floors that exist.
    --

    local lower = 0
    local upper = 0

    local hit_both = {}

    each C in R.conns do
      local S = C:get_seed(R)

      -- ignore teleporters
      if not S then continue end

      assert(S.conn == C)

      local chunk = assert(S.chunk[1])
      local overlay = S.chunk[2]

      local hit_lower = (chunk.floor)
      local hit_upper = (overlay and overlay.floor)

      if hit_lower and hit_upper then
        table.insert(hit_both, S)

      elseif hit_upper then
        upper = upper + 1
        assign_a_conn(C, S, "upper")

      else
        lower = lower + 1
        assign_a_conn(C, S, "lower")
      end
    end

--[[ DEBUG
    stderrf("assign_conns @ %s : lower:%d  upper:%d  both:%d  ",
            R:tostr(), lower, upper, #hit_both)
--]]

    -- nothing to do?
    local both = #hit_both

    if both == 0 then return end


    -- decide how many of hit_both[] to assign to an overlay.
    local raise_min = sel(upper < 1 and rand.odds(50), 1, 0)
    local raise_max = both - sel(upper > lower, 1, 0)

    assert(raise_min <= raise_max)

    local raise_num = rand.irange(raise_min, raise_max)


    -- actually assign them...
    rand.shuffle(hit_both)

    for i = 1, #hit_both do
      local S = hit_both[i]
      local C = S.conn

      if i <= raise_num then
        assign_a_conn(C, S, "upper")
      else
        assign_a_conn(C, S, "lower")
      end
    end
  end


  ---==| Layout_room |==---

  gui.debugf("LAYOUT %s >>>>\n", R:tostr())

  local entry_h

  if R.entry_conn and R.entry_conn.conn_h then
    entry_h = R.entry_conn.conn_h

gui.debugf("  ENTRY_H %d from %s\n", entry_h, R.entry_conn:tostr())

    -- support archways with steps
    if R.entry_conn.diff_h then
      entry_h = entry_h + R.entry_conn.diff_h
    end
  end

  if not entry_h then
    entry_h = SKY_H - rand.irange(4,7) * 64
  end


  -- special logic for certain kinds of rooms --

  if R.kind == "small_exit" then
    return
  end

  if R.kind == "stairwell" then
    stairwell_height_diff()
    return
  end

  if R.kind == "hallway" then
    Layout_hallway(R, entry_h)
    Layout_place_importants(R)
    return
  end

  if R.kind == "cave" then
    Layout_place_importants(R)
    Cave_build_room(R, entry_h)
    return
  end


  junk_sides()

  fill_room(entry_h)

  assign_conns_to_floors()

  select_floor_texs()


  Layout_height_realization(R, entry_h)

  Layout_post_processing(R)

  Layout_escape_from_pits(R)


  --- place importants ---

  Layout_place_importants(R)

  if R.kind == "building" then
    Layout_add_pillars(R)
  end

  Layout_add_bridges(R)

  Layout_add_cages(R)
end


------------------------------------------------------------------------


function Layout_plan_outdoor_borders()

  local all_rooms

  local CORNERS = { 1,3,7,9 }

  
  local function collect_rooms()
    all_rooms = {}

    table.append(all_rooms, LEVEL.rooms)
    table.append(all_rooms, LEVEL.scenic_rooms)
  end


  local function extent_to_edge(S, dir)
    -- see if this seed could be extended to the edge of the map,
    -- via a number of unused seeds.  Return number of fillable seeds
    -- or NIL if not possible.

    for dist = 1, 4 do
      local N = S:neighbor(dir, dist)

      if not N or N.free then
        return dist - 1
      end

      if N.room then return nil end
    end

    return nil
  end


  local function try_extend_building(S, dir)
    local dist = extent_to_edge(S, dir)

    if not (dist and dist > 0) then
      return
    end

-- gui.debugf("Filling @ %s dir:%d dist:%d\n", S:tostr(), dir, dist)

    local tex = S.room.facade or S.room.main_tex
    assert(tex)

    for i = 1, dist do
      local N = S:neighbor(dir, i)

      -- TODO : perhaps check for a nearby outdoor room (like V5)
      --        and build_fake_building()

      N.map_border = { kind="solid", tex=tex }
    end
  end


  local function stretch_room(R)
    for x = R.sx1, R.sx2 do
    for y = R.sy1, R.sy2 do
      local S = SEEDS[x][y]
      if S.room != R then continue end

      if x == R.sx1 then try_extend_building(S, 4) end
      if x == R.sx2 then try_extend_building(S, 6) end

      if y == R.sy1 then try_extend_building(S, 2) end
      if y == R.sy2 then try_extend_building(S, 8) end
    end
    end
  end


  local function stretch_buildings()
    each R in all_rooms do
      if not R.is_outdoor then
        stretch_room(R)
      end
    end
  end


  local function install_border(B)
    for x = B.sx1, B.sx2 do
    for y = B.sy1, B.sy2 do
      SEEDS[x][y].map_border = B
    end
    end

    B.room.has_map_border = true

    table.insert(LEVEL.map_borders, B)
  end


  local function subdivide_foo(long, num) 
    local num = int(long / 3)
    assert(num >= 1)

    local foo = {}

    for i = 1, num do
      foo[i] = 3 ; long = long - 3
    end

    assert(long >= 0)
    assert(long <  3)

    for pass = 1,2 do
      for i = 1, num do
        if long > 0 then
          foo[i] = foo[i] + 1 ; long = long - 1
        end
      end
    end

    return foo
  end


  local function plan_edge_fabs(R, side)
    local x1, y1 = R.sx1, R.sy1
    local x2, y2 = R.sx2, R.sy2

    if side == 2 then y2 = y1 end
    if side == 8 then y1 = y2 end
    if side == 4 then x2 = x1 end
    if side == 6 then x1 = x2 end

    -- ensure we are actually at the edge of the map

    if side == 2 and y1 != 1 + 3 then return end
    if side == 8 and y1 != SEED_TOP - 3 then return end
    if side == 4 and x1 != 1 + 3 then return end
    if side == 6 and x1 != SEED_W - 3 then return end

    -- check that we can build something (to be safe)

    for sx = x1, x2 do
    for sy = y1, y2 do
      local S = SEEDS[sx][sy]

      if S.room != R then return end

      for dist = 1, 3 do
        local N = S:neighbor(side, dist)

        if not N or N.free then return end

        if N:in_use() then return end
      end
    end
    end

    -- OK, this edge will have border fabs

    x1, y1 = R.sx1, R.sy1
    x2, y2 = R.sx2, R.sy2

    if side == 2 then y2 = y1 - 1 ; y1 = y2 - 2 end
    if side == 8 then y1 = y2 + 1 ; y2 = y1 + 2 end
    if side == 4 then x2 = x1 - 1 ; x1 = x2 - 2 end
    if side == 6 then x1 = x2 + 1 ; x2 = x1 + 2 end

    -- if very wide, sub-divide
    local long = geom.vert_sel(side, x2 - x1, y2 - y1) + 1

    local widths = subdivide_foo(long)

    each W in widths do
      local nw = x2 - x1 + 1
      local nh = y2 - y1 + 1

      if geom.is_vert(side) then
        nw = W
      else
        nh = W
      end

      -- occasionally skip it (allow using seeds for closets or cages)
      -- TODO : large "fake building" prefabs

      if rand.odds(20) then
        -- skip it
      else
        local BORDER =
        {
          kind = "edge"
          side = side
          room = R

          sx1 = x1
          sy1 = y1
          sx2 = x1 + nw - 1
          sy2 = y1 + nh - 1
        }

        install_border(BORDER)
      end

      if geom.is_vert(side) then
        x1 = x1 + W
      else
        y1 = y1 + W
      end
    end

    R.border_edges[side] = true
  end


  local function corner_joins_to_edge(R, side, sx1, sy1, sx2, sy2)
    -- the 'side' parameter is relative to corner itself

    -- we only test a single seed
    local tx = math.i_mid(sx1, sx2)
    local ty = math.i_mid(sy1, sy2)

    if side == 2 then ty = sy1 - 1 end
    if side == 8 then ty = sy2 + 1 end
    if side == 4 then tx = sx1 - 1 end
    if side == 6 then tx = sx2 + 1 end

    if not Seed_valid(tx, ty) then return false end

    local T = SEEDS[tx][ty]

    return T.map_border and
           T.map_border.room == R and
           T.map_border.kind == "edge"
  end


  local function plan_corner_fabs(R, corner)
    local sx, sy

    if corner == 1 or corner == 3 then
      sy = R.sy1
    else
      sy = R.sy2
    end

    if corner == 1 or corner == 7 then
      sx = R.sx1
    else
      sx = R.sx2
    end

    local S = SEEDS[sx][sy]

    if S.room != R then return end

    -- ensure we are actually at a corner of the map

    local VR = S:neighbor(corner, 3)

    if not VR then return end

    if not (VR.sx == 1 or VR.sx == SEED_W)   then return end
    if not (VR.sy == 1 or VR.sy == SEED_TOP) then return end

    -- check that we can build something there

    local L_dir = geom.LEFT_45 [corner]
    local R_dir = geom.RIGHT_45[corner]

    local x1, y1, x2, y2

    for i = 1, 3 do
    for k = 1, 3 do
      local tmp = S:neighbor(L_dir, i)
      if not tmp then return end

      local N = tmp:neighbor(R_dir, k)
      if not N then return end

      if N:in_use() then return end

      x1 = math.min(N.sx, x1 or  999)
      y1 = math.min(N.sy, y1 or  999)
      x2 = math.max(N.sx, x2 or -999)
      y2 = math.max(N.sy, y2 or -999)
    end
    end

    -- only build a corner if it joins an edge (ideally TWO edges)

    local L_join = corner_joins_to_edge(R, 10 - R_dir, x1, y1, x2, y2)
    local R_join = corner_joins_to_edge(R, 10 - L_dir, x1, y1, x2, y2)

    if L_join and R_join then
      -- occasionally skip (when touches two edges)
      -- TODO: large fake building corner thingy
      if rand.odds(10) then return end
    
    elseif L_join or R_join then
      if rand.odds(50) then return end

    else
      return
    end

    -- OK --

    local BORDER =
    {
      kind = "corner"
      side = corner
      room = R

      sx1 = x1
      sy1 = y1
      sx2 = x2
      sy2 = y2

      fully_joined = (L_join and R_join)
    }

    install_border(BORDER)
  end


  local function outdoor_or_scenic(R)
    -- ignore sub-rooms
    if R.parent then return false end

    if R.kind == "outdoor" then return true end

    if R.kind != "scenic" then return false end

    return R.is_outdoor
  end


  local function plan_borders()
    each R in all_rooms do
      R.border_edges = {}

      if outdoor_or_scenic(R) then
        for side = 2,8,2 do
          plan_edge_fabs(R, side)
        end
      end
    end
    
    -- must do all edges _before_ all corners

    each R in all_rooms do
      if outdoor_or_scenic(R) then
        each corner in CORNERS do
          plan_corner_fabs(R, corner)
        end
      end
    end
  end


  ---| Layout_plan_outdoor_borders |---

  gui.debugf("Layout_plan_outdoor_borders...\n")

  if rand.odds(35) then
    LEVEL.border_name  = "Border_dropoff"
  else
    LEVEL.border_name  = "Border_rocky"
  end

  LEVEL.border_group = GROUPS[string.lower(LEVEL.border_name)]
  assert(LEVEL.border_group)

  collect_rooms()

  stretch_buildings()

  plan_borders()
end



function Layout_build_outdoor_borders()

  local prefix = LEVEL.border_name


  local function do_edge_piece(B)
    local skin1 = {}

    -- TODO : proper way to find the prefabs
    local fab_name = prefix .. "_t"

    if B.content_kind == "START" then
      fab_name = prefix .. "_start"

    elseif B.content_kind == "EXIT" then
      fab_name = prefix .. "_exit"
      
    elseif B.content_kind == "KEY" then
      fab_name = prefix .. "_item"

      skin1.item = B.content_item
    end

    local def = PREFABS[fab_name]
    assert(def)

    local x1, y1, x2, y2 = Seed_coord_range(B.sx1, B.sy1, B.sx2, B.sy2)
    local floor_h = assert(B.room.floor_max_h)

    local T = Trans.box_transform(x1, y1, x2, y2, floor_h, 10 - B.side)

    Fabricate(B.room, def, T, { skin1 })
  end


  local function do_corner_piece(B)
    local fab_name = prefix .. "_c"

    local def = PREFABS[fab_name]
    assert(def)

    local dir = 10 - geom.LEFT_45[B.side]

    local x1, y1, x2, y2 = Seed_coord_range(B.sx1, B.sy1, B.sx2, B.sy2)
    local floor_h = assert(B.room.floor_max_h)

    local T = Trans.box_transform(x1, y1, x2, y2, floor_h, dir)

    Fabricate(B.room, def, T, { })
  end


  local function build_border(B)
    if B.kind == "edge" then
      do_edge_piece(B)

    elseif B.kind == "corner" then
      do_corner_piece(B)
    end
  end


  local function nearby_facade(S)
    for pass = 1,2 do

      for dist = 1,4 do
      for dir = 2,8,2 do
        local N = S:neighbor(dir, dist)

        if not (N and N.room) then continue end

        if pass == 1 and N.room.facade then
          return N.room.facade
        end

        if pass == 2 and N.room.zone then
          return assert(N.room.zone.facade_mat)
        end
      end -- dist, dir
      end

    end -- pass

    -- emergency fallback --

    local tex = LEVEL.zones[1].facade_mat
    assert(tex)

    return tex
  end


  local function fill_remaining_gaps()
    -- this fills any unintended gaps in the geometry

    for sx = 1, SEED_W do
    for sy = 1, SEED_TOP do
      local S = SEEDS[sx][sy]

      if S.map_border and S.map_border.kind == "solid" then
        Trans.solid_quad(S.x1, S.y1, S.x2, S.y2, S.map_border.tex)

      elseif not (S.room or S.map_border) then
        Trans.solid_quad(S.x1, S.y1, S.x2, S.y2, nearby_facade(S))
      end
    end
    end
  end


  local function compute_entry_dist(R, B)
    -- compute distance from entrace
    if R.entry_conn then
      local entry_S = R.entry_conn:get_seed(R)
      if entry_S then
        local mx = (B.sx1 + B.sx2) / 2
        local my = (B.sy1 + B.sy2) / 2

        local dist = geom.dist(entry_S.sx, entry_S.sy, mx, my)

        -- tie breaker
        return dist + gui.random() / 10
      end

      -- TODO : handle teleporter entry
    end

    -- arbitrary fallback value
    return gui.random() * 10
  end


  local function check_border_accessible(R, B, list)
    if B.kind == "corner" then return end

    -- range of seeds to test  [ B.side is relative to room, not piece ]
    local tx1, ty1 = B.sx1, B.sy1
    local tx2, ty2 = B.sx2, B.sy2

    local piece_floor_h = assert(R.floor_max_h)

    if B.side == 8 then ty1 = ty1 - 1 ; ty2 = ty1 end
    if B.side == 2 then ty2 = ty2 + 1 ; ty1 = ty2 end
    if B.side == 6 then tx1 = tx1 - 1 ; tx2 = tx1 end
    if B.side == 4 then tx2 = tx2 + 1 ; tx1 = tx2 end

    for x = tx1, tx2 do
    for y = ty1, ty2 do
      assert(Seed_valid(x, y))

      local S = SEEDS[x][y]

      if S.room != R then return end  -- child room

      if S.kind != "walk" then return end  -- e.g. stairs, liquid

      local floor_h = assert(S.floor_max_h)

      if math.abs(floor_h - piece_floor_h) > 8 then return end

    end -- x, y
    end

    -- OK --

    B.is_accessible = true

    table.insert(list, B)

    B.entry_dist = compute_entry_dist(R, B)
  end


  local function remove_wotsit(S)
    S.content = nil
    S.content_kind = nil
    S.content_item = nil
  end


  local function try_replace_goal(kind, B)
    local R = B.room
    local R_height = R.sky_group.h - R.floor_max_h
    
    if R.kind == "scenic" then return end

    -- level has two starting rooms for CO-OP ?
    if kind == "START" and LEVEL.alt_start then return end

    -- FIXME : check if a usable prefab exists  (i.e. def.purpose == B.content_kind) 

    each goal in R.goals do
      if goal.kind != kind then continue end

      if goal.closet then continue end

      -- FIXME : proper height check (use prefab .height)
      if kind == "KEY" and R_height < 224 then return end

      -- found it --

      local S = assert(goal.S)

      -- FIXME : check distance, if border is much closer then do not use it
      --         (not really an issue from non-key ITEMs)

      B.content_kind = kind

      if kind == "KEY" then
        local LOCK = assert(B.room.purpose_lock)
        B.content_item = assert(LOCK.item)
      end

      goal.border = B

      -- disable the original wotsit
      remove_wotsit(goal.S)

      goal.S = nil

      -- TODO : R.guard_spot

      gui.debugf("\nUsing border piece for %s\n\n", kind)

      break;
    end
  end


  local function look_for_special_usage(R)
    local list = {}

    each B in LEVEL.map_borders do
      if B.room != R then continue end

      check_border_accessible(R, B, list)
    end

    if #list == 0 then return end

    local use_B = table.pick_best(list, function(A, B) return A.entry_dist > B.entry_dist end)

    if try_replace_goal("START", use_B) or
       try_replace_goal("EXIT",  use_B) or
       try_replace_goal("KEY",   use_B)
    then
      -- Woohoo
    end
  end


  ---| Layout_build_outdoor_borders |---

  each R in LEVEL.rooms do
    look_for_special_usage(R)
  end

  each B in LEVEL.map_borders do
    build_border(B)
  end

  fill_remaining_gaps()
end

