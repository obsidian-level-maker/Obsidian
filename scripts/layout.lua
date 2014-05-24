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


X_MIRROR_CHARS =
{
  ['<'] = '>', ['>'] = '<',
  ['/'] = '%', ['%'] = '/',
  ['Z'] = 'N', ['N'] = 'Z',
  ['L'] = 'J', ['J'] = 'L',
  ['F'] = 'T', ['T'] = 'F',
}

Y_MIRROR_CHARS =
{
  ['v'] = '^', ['^'] = 'v',
  ['/'] = '%', ['%'] = '/',
  ['Z'] = 'N', ['N'] = 'Z',
  ['L'] = 'F', ['F'] = 'L',
  ['J'] = 'T', ['T'] = 'J',
}

TRANSPOSE_DIRS = { 1,4,7,2,5,8,3,6,9 }

TRANSPOSE_CHARS =
{
  ['<'] = 'v', ['v'] = '<',
  ['>'] = '^', ['^'] = '>',
  ['/'] = 'Z', ['Z'] = '/',
  ['%'] = 'N', ['N'] = '%',
  ['-'] = '|', ['|'] = '-',
  ['!'] = '=', ['='] = '!',
  ['F'] = 'J', ['J'] = 'F',
}

STAIR_DIRS =
{
  ['<'] = 4, ['>'] = 6,
  ['v'] = 2, ['^'] = 8,
}


function Layout_parse_char(ch)
  if ch == ' ' then return { kind="empty" } end

  if ch == '.' then return { kind="floor", floor=0 } end
  if ch == '1' then return { kind="floor", floor=1 } end
  if ch == '2' then return { kind="floor", floor=2 } end
  if ch == '3' then return { kind="floor", floor=3 } end
  if ch == '4' then return { kind="floor", floor=4 } end

  if ch == '~' then return { kind="liquid" } end
  if ch == '#' then return { kind="solid"  } end

  -- these can be curved, and 'dir' is towards the more open space
  if ch == '/' then return { kind="diagonal", dir=3 } end
  if ch == '%' then return { kind="diagonal", dir=1 } end
  if ch == 'N' then return { kind="diagonal", dir=9 } end
  if ch == 'Z' then return { kind="diagonal", dir=7 } end

  if ch == '<' then return { kind="stair", dir=4 } end
  if ch == '>' then return { kind="stair", dir=6 } end
  if ch == '^' then return { kind="stair", dir=8 } end
  if ch == 'v' then return { kind="stair", dir=2 } end

  -- these stairs turn 90 degrees, 'dir' is the middle angle
  if ch == 'F' then return { kind="curve_stair", dir=3 } end
  if ch == 'T' then return { kind="curve_stair", dir=1 } end
  if ch == 'L' then return { kind="curve_stair", dir=9 } end
  if ch == 'J' then return { kind="curve_stair", dir=7 } end

  -- in stairs to a 3D floor, 'dir' is always the "going up" direction
  if ch == 'K' then return { kind="3d_stair", dir=4 } end
  if ch == 'V' then return { kind="3d_stair", dir=2 } end

  if ch == '=' then return { kind="3d_bridge" } end

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

  local function find_stair_source(grid, x, y)
    -- determine the source floor for this stair
    -- (the destination floor is ALWAYS the pointed-to seed).
    local G = grid[x][y]
    assert(G.dir)

    -- we try the back first
    local DIRS =
    {
      10 - G.dir, geom.LEFT[G.dir], geom.RIGHT[G.dir]
    }

    each dir in DIRS do
      local nx, ny = geom.nudge(x, y, dir)

      if nx < 1 or nx > grid.w or ny < 1 or ny > grid.h then
        continue
      end

      if grid[nx][ny].kind == "floor" then
        -- found it
        grid[x][y].src_dir = dir
        return
      end
    end

    error("Stair in pattern lacks a walkable neighbor!")
  end


  local function analyse_stairs(grid)
    for x = 1, grid.w do
    for y = 1, grid.h do
      if grid[x][y].kind == "stair" then
        find_stair_source(grid, x, y)
      end
    end -- x, y
    end
  end


  local function convert_pattern(pat, structure)
    local W = #structure[1]
    local H = #structure

    local grid = table.array_2D(W, H)

    for x = 1, W do
    for y = 1, H do
      local line = structure[y]

      if #line != W then
        error("Malformed structure in room pattern: " .. pat.name)
      end

      local ch = string.sub(line, x, x)

      grid[x][y] = Layout_parse_char(ch)

      if grid[x][y].kind == "3d_bridge" then
        pat.has_3d_bridge = true
      end
    end -- x, y
    end

    analyse_stairs(grid)

    return grid
  end


  local function find_sub_area(grid, floor_id)
    local x1, y1 =  999,  999
    local x2, y2 = -999, -999

    for x = 1, grid.w do
    for y = 1, grid.h do
      if grid[x][y].kind == "floor" and
         grid[x][y].floor == floor_id
      then
        x1 = math.min(x1, x)
        y1 = math.min(y1, y)

        x2 = math.max(x2, x)
        y2 = math.max(y2, y)
      end
    end -- x, y
    end

    if x1 > x2 or y1 > y2 then
      error("Cannot find recursive sub-area in room pattern")
    end

    -- verify it
    for x = x1, x2 do
    for y = y1, y2 do
      if grid[x][y].floor != floor_id then
        error("Recursive sub-area in pattern is not a rectangle")
      end
    end
    end

    return { x1=x1, y1=y1, x2=x2, y2=y2 }
  end


  local function determine_sub_areas(pat)
    -- for recursive patterns, find the rectangle which corresponds
    -- to each sub-area.
    if pat.subs then
      each sub in pat.subs do
        if sub.recurse then
          local floor_id = _index
          sub.area = find_sub_area(pat._structure, floor_id)
        end
      end
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
    pat._structure = convert_pattern(pat, pat.structure)

    if pat.overlay then
       pat._overlay = convert_pattern(pat, pat.overlay)
    end

    determine_sub_areas(pat)

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
        local S = C:seed(R)
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

  S.content = "wotsit"
  S.content_kind = kind

  table.insert(R.goals, { S=S, kind=kind })

  -- no monsters near start spot or teleporters
  if kind == "START" or kind == "TELEPORTER" then
    R:add_exclusion("empty",     S.x1, S.y1, S.x2, S.y2, 96)
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

    -- FIXME !!!!  exclusion zone for teleporter
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
    if S.room == R and S.kind == "walk" then
      assert(S.floor_h)

      min_h = math.min(min_h, S.floor_h)
      max_h = math.max(max_h, S.floor_h)
    end
  end -- x, y
  end

  assert(min_h <= max_h)

  R.floor_min_h = min_h
  R.floor_max_h = max_h

  R.fence_h  = R.floor_max_h + 30
  R.liquid_h = R.floor_min_h - 48

  for x = R.sx1, R.sx2 do
  for y = R.sy1, R.sy2 do
    local S = SEEDS[x][y]
    if S.room == R and S.kind == "liquid" then
      S.floor_h = R.liquid_h
    end
  end -- x, y
  end
end


function Layout_scenic(R)
  local min_floor = 1000

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
    for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
      if x < tx1 or x > tx2 or y < ty1 or y > ty2 then
        SEEDS[x][y].kind = "void"
      end
    end end -- for x, y
  end

  local function make_O()
    for x = R.sx1+1,R.sx2-1 do for y = R.sy1+1,R.sy2-1 do
      local S = SEEDS[x][y]
      S.kind = "void"
    end end -- for x, y
  end

  local function make_L()
    local C1 = R.conns[1]
    local C2 = R.conns[2]

    local S1 = C1:seed(R)
    local S2 = C2:seed(R)

    if rand.odds(50) then S1,S2 = S2,S1 end

    for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
      if x < tx1 or x > tx2 or y < ty1 or y > ty2 or
         not (x == S1.sx or y == S2.sy)
      then
        SEEDS[x][y].kind = "void"
      end
    end end -- for x, y
  end

  local function criss_cross()
    -- block out seeds that don't "trace" from a connection
    local used_x = {}
    local used_y = {}

    each C in R.conns do
      if C.kind == "teleporter" then continue end
      local S = C:seed(R)
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

    for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
      if x < tx1 or x > tx2 or y < ty1 or y > ty2 or
         not (used_x[x] or used_y[y])
      then
        SEEDS[x][y].kind = "void"
      end
    end end -- for x, y

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
    C.conn_h = h
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

    if S.kind != "walk" or S.conn or S.pseudo_conn or S.must_walk then
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

      if A.kind != "liquid" then continue end
      if B.kind != "liquid" then continue end

      if A.bridge_h then continue end
      if B.bridge_h then continue end

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



function OLD__Layout_try_pattern(R, area, div_lev, req_sym, heights, f_texs)
  -- find a usable pattern in the ROOM_PATTERNS table and
  -- apply it to the room.

  -- this function is responsible for setting floor_h in every
  -- seed in the given 'area'.

  -- 'div_lev' is 1 for the main pattern, 2 or higher for recursive
  -- patterns (inside a previously chosen pattern).

  area.tw, area.th = geom.group_size(area.x1, area.y1, area.x2, area.y2)

  gui.debugf("Layout_try_pattern @ %s  div_lev:%d\n", R:tostr(), div_lev)
  gui.debugf("Area: (%d,%d)..(%d,%d) heights: %d %d %d\n",
    area.x1, area.y1, area.x2, area.y2,
    heights[1] or -1, heights[2] or -1, heights[3] or -1)


  local function pos_size(s, n)
    local ch = string.sub(s, n, n)
        if ch == 'A' then return 10
    elseif ch == 'B' then return 11
    elseif ch == 'C' then return 12
    elseif ch == 'D' then return 13
    else return 0 + (ch)
    end
  end


  local function total_size(s)
    local total = 0
    for i = 1,#s do
      total = total + pos_size(s, i)
    end
    return total
  end


  local function pad_line(src, x_sizes)
    assert(#src == #x_sizes)

    local padded = ""

    for x = 1,#x_sizes do
      local x_num = pos_size(x_sizes, x)
      local ch = string.sub(src, x, x)

      for i = 1,x_num do
        padded = padded .. ch
      end
    end

    return padded
  end


  local function matching_sizes(list, dim)
    local result
    
    each sz in list do
      if total_size(sz) == dim then
        if not result then result = {} end
        table.insert(result, sz)
      end
    end

    return result
  end


  local function morph_dir(T, dir)
    if T.x_flip and geom.is_horiz(dir) then dir = 10-dir end
    if T.y_flip and geom.is_vert(dir)  then dir = 10-dir end

    if T.transpose then dir = TRANSPOSE_DIRS[dir] end

    return dir
  end


  local function morph_char(T, ch)
    if T.x_flip then
      ch = X_MIRROR_CHARS[ch] or ch
    end

    if T.y_flip then
      ch = Y_MIRROR_CHARS[ch] or ch
    end

    if T.transpose then
      ch = TRANSPOSE_CHARS[ch] or ch
    end

    return ch
  end


  local function convert_structure(T, info, x_sizes, y_sizes)

    T.structure = table.array_2D(area.tw, area.th)

    local stru_w = #x_sizes
    local stru_h = #y_sizes

    local function morph_coord2(T, i, j)
      if T.x_flip then i = T.long+1 - i end
      if T.y_flip then j = T.deep+1 - j end

      if T.transpose then i,j = j,i end

      return i, j
    end

    local function analyse_stair(E, ch, i, j)
      -- determine source height of stair.
      -- (dest height is simply in the pointed-to seed)

      local dir = assert(STAIR_DIRS[ch])

      local SIDES =
      {
        10 - dir,  -- try back first
        geom.LEFT[dir],
        geom.RIGHT[dir],
      }

      each side in SIDES do
        local nch
        local nx, ny = geom.nudge(i, j, side)

        if (1 <= nx and nx <= stru_w) and (1 <= ny and ny <= stru_h) then
          local src = info.structure[stru_h+1 - ny]
          nch = string.sub(src, nx, nx)
        end

        if nch and (nch == '.' or string.is_digit(nch)) then
          E.stair_src = nch
          break;
        end
      end -- for side

      if not E.stair_src then
        error("Stair in pattern lacks a walkable neighbor!")
      end
    end


    ---| convert_structure |---

    local cur_j = 1

    for j = 1,stru_h do
      local j_num = pos_size(y_sizes, j)
      local src = info.structure[stru_h+1 - j]
      
      local cur_i = 1

      for i = 1,stru_w do
        local i_num = pos_size(x_sizes, i)
        local ch = string.sub(src, i, i)
        local mc = morph_char(T, ch)

        for di = 0,i_num-1 do for dj = 0,j_num-1 do
          local x, y = morph_coord2(T, cur_i+di, cur_j+dj)
          assert(1 <= x and x <= area.tw)
          assert(1 <= y and y <= area.th)

          local E = { char=mc }

          if ch == '<' or ch == '>' or ch == 'v' or ch == '^' then
            E.dir = STAIR_DIRS[mc]
            analyse_stair(E, ch, i, j)
          end

          T.structure[x][y] = E
        end end -- for di, dj

        cur_i = cur_i + i_num
      end -- for i

      cur_j = cur_j + j_num
    end -- for j


    --[[ Testing
    for ex = 1,area.tw do for ey = 1,area.th do
      local E = assert(T.structure[ex][ey])
    end end -- for ex, ey
    --]]
  end


  local function find_sub_area(T, match_ch)
    local x1, y1 = 999, 999
    local x2, y2 =-9, -9

    for ex = 1,area.tw do for ey = 1,area.th do
      local x  = area.x1 + ex-1
      local y  = area.y1 + ey-1

      local ch = T.structure[ex][ey].char

      if ch == match_ch then
        if x < x1 then x1 = x end
        if y < y1 then y1 = y end
        if x > x2 then x2 = x end
        if y > y2 then y2 = y end
      end
    end end -- for ex, ey

    if x2 < 0 then return nil end

    return { x1=x1, y1=y1, x2=x2, y2=y2 }
  end


  local function OLD__setup_floor(S, h, f_tex)
    S.floor_h = h

    S.f_tex = sel(R.is_outdoor, R.main_tex, f_tex)

    if S.conn or S.pseudo_conn then
      local C = S.conn or S.pseudo_conn

      C.conn_h = S.floor_h
      C.conn_ftex = f_tex
    end
  end


  local function setup_stair(T, S, E, h, f_tex)
    assert(not S.conn)

    S.kind = "stair"
    S.stair_dir = assert(E.dir)

    if not R.is_outdoor then
      S.f_tex = f_tex
    end

    
    -- determine height "around" the stair (source).
    -- the destination is done in process_stair()
    assert(E.stair_src)
    if E.stair_src == '.' then
      S.stair_z1 = h
      S.z1_tex   = f_tex
    else
      local s_idx = 0 + E.stair_src
      local sub = assert(T.info.subs[s_idx])
      S.stair_z1 = heights[1 + sub.height]
      S.z1_tex   = f_texs [1 + sub.height]
    end

    if R.is_outdoor then
      S.z1_tex = R.main_tex
    end

    assert(S.stair_z1)

    S.floor_h = S.stair_z1


    local N = S:neighbor(S.stair_dir)

    assert(N and N.room == R)
    assert(R:contains_seed(N.sx, N.sy))

    N.must_walk = true
  end


  local function setup_curve_stair(S, E, ch, h, f_tex)
    assert(not S.conn)

    S.kind = "curve_stair"

    S.x_side = sel(ch == 'L' or ch == 'F', 6, 4)
    S.y_side = sel(ch == 'L' or ch == 'J', 8, 2)

    if not R.is_outdoor then
      S.f_tex = f_tex
    end

---???  S.floor_h = h

    for pass = 1,2 do
      local dir = sel(pass == 1, S.x_side, S.y_side)

      local N = S:neighbor(dir)

      assert(N and N.room == R)
      assert(R:contains_seed(N.sx, N.sy))

      N.must_walk = true
    end
  end


  local function dump_structure(T)
    gui.debugf("T.structure =\n")
    for y = 1,area.th do
      local line = ""
      for x = 1,area.tw do
        line = line .. T.structure[x][y].char
      end
      gui.debugf("   %s\n", line)
    end
  end


  local function eval_pattern(T)
gui.debugf("eval_pattern %s\n", T.info.name)

    T.has_focus = false

    -- check symmetry
    local info_sym = T.info.symmetry
    if T.transpose then
          if info_sym == "x" then info_sym = "y"
      elseif info_sym == "y" then info_sym = "x"
      end
    end

    if not (not req_sym or req_sym == info_sym or info_sym == "xy") then
gui.debugf("SYMMETRY MISMATCH (%s != %s\n", req_sym or "NONE", info_sym or "NONE")
      return -1
    end

    -- check if enough heights are available
    if T.info.subs then
      each sub in T.info.subs do
        if (sub.height + 1) > #heights then
gui.debugf("NOT ENOUGH HEIGHTS\n")
        return -1 end
      end
    end

    local score = gui.random() * 99

    local matches = {}

    for ex = 1,area.tw do for ey = 1,area.th do
      local x = area.x1 + ex - 1
      local y = area.y1 + ey - 1
      assert(Seed_valid(x, y))

      local S = SEEDS[x][y]
      assert(S and S.room == R)

      local E  = T.structure[ex][ey]
      local ch = assert(E.char)

      if (S.conn or S.pseudo_conn or S.must_walk) then
        if not (ch == '.' or string.is_digit(ch)) then
gui.debugf("CONN needs PLAIN WALK\n")
          return -1
        end

        if string.is_digit(ch) then
          local s_idx = (0 + ch)
          matches[s_idx] = (matches[s_idx] or 0) + 1
---??     score = score + 20
        end
      end

      if ch == '.' and S.conn == R.focus_conn then
        T.has_focus = true
      end

    end end -- for ex, ey

    -- for top-level pattern we require focus seed to hit a '.'
    if div_lev == 1 and not T.has_focus then
gui.debugf("FOCUS not touch dot\n");
      return -1
    end

gui.debugf("matches: { %s %s }\n", tostring(matches[1]), tostring(matches[2]))

    -- check sub-area matches
    if T.info.subs then
      for s_idx,sub in ipairs(T.info.subs) do
        if sub.match == "one"  and not matches[s_idx] and
           not (R.kind == "purpose") then return -1 end

        if sub.match == "none" and matches[s_idx] then return -1 end

        if sub.match == "any" and matches[s_idx] then
          score = score + 100 * matches[s_idx]
        end
      end
    end

gui.debugf("OK : score = %1.4f\n", score)
    return score
  end


  local function install_pattern(T, want_subs)

gui.debugf("install_pattern %s :  hash_h:%d  (%d,%d)..(%d,%d)\n",
  T.info.name, heights[1],
  area.x1, area.y1, area.x2, area.y2)

    local use_solid_feature = rand.odds(75)

-- dump_structure(T)

    for ex = 1,area.tw do for ey = 1,area.th do
      local x = area.x1 + ex - 1
      local y = area.y1 + ey - 1

      local S = SEEDS[x][y]
      local E  = T.structure[ex][ey]
      local ch = E.char

      local hash_h    = assert(heights[1])
      local hash_ftex = assert(f_texs[1])

      -- Note: any recursion will overwrite this value
      S.div_lev = div_lev

      do
        if ch == '.' or string.is_digit(ch) then
          if string.is_digit(ch) then
            local s_idx = 0 + ch
            if want_subs[s_idx] then
              local sub = assert(T.info.subs[s_idx])
              hash_h = assert(heights[1 + sub.height])
              hash_ftex = f_texs[1 + sub.height]
            else
              ch = nil
            end
          end

          if ch then
            setup_floor(S, hash_h, hash_ftex)
          end

        elseif ch == '<' or ch == '>' or ch == 'v' or ch == '^' then
          setup_stair(T, S, E, hash_h, hash_ftex)

        elseif ch == 'L' or ch == 'F' or ch == 'J' or ch == 'T' then
          setup_curve_stair(S, E, ch, hash_h, hash_ftex)

        elseif ch == '/' or ch == '%' or ch == 'Z' or ch == 'N' then
          S.kind = "diagonal"
          S.diag_char = ch

        elseif ch == '#' then
          S.kind = "void"
          if use_solid_feature then
            S.solid_feature = T.info.solid_feature
          end

        elseif ch == '~' then
          -- NOTE: floor_h for liquids is determined later
          assert(LEVEL.liquid)
          S.kind = "liquid"
          R.has_liquid = true

        else
          error("unknown symbol in room pat: '" .. tostring(ch) .. "'")
        end
      end

    end end -- for ex, ey
gui.debugf("end install_fab\n")
  end


  local function install_flat_floor(h, f_tex)
    for x = area.x1, area.x2 do
    for y = area.y1, area.y2 do
      local S = SEEDS[x][y]

      if S.room == R and not S.floor_h then
        setup_floor(S, h, f_tex)
        S.div_lev = div_lev
      end
    end -- x, y
    end
  end


  local function mirror_seed(S, OT, sym)
    -- S  : destination
    -- OT : other (source)

    if OT.kind == "walk" and not OT.floor_h then
      error("mirror_seed : peer not setup yet!")
    end

    S.kind    = assert(OT.kind)
    S.div_lev = OT.div_lev

    S.floor_h = OT.floor_h
    S.ceil_h  = OT.ceil_h

    S.f_tex   = OT.f_tex
    S.c_tex   = OT.c_tex
    S.w_tex   = OT.w_tex

    -- NB: connection logic copied from setup_floor()
    if S.conn or S.pseudo_conn then
      local C = S.conn or S.pseudo_conn
      if C.conn_h then assert(C.conn_h == S.floor_h) end

      C.conn_h = S.floor_h
      if S.f_tex then C.conn_ftex = S.f_tex end
    end

    if OT.kind == "diagonal" then
      if sym == "x" then
        S.diag_char = X_MIRROR_CHARS[OT.diag_char]

      else assert(sym == "y")
        S.diag_char = Y_MIRROR_CHARS[OT.diag_char]
      end
    end

    assert(OT.kind != "lift")

    if OT.kind == "stair" then
      S.stair_dir = assert(OT.stair_dir)
      S.stair_z1  = assert(OT.stair_z1)
      S.z1_tex    = assert(OT.z1_tex)

      if sym == "x" and geom.is_horiz(S.stair_dir) then
        S.stair_dir = 10 - S.stair_dir
      end

      if sym == "y" and geom.is_vert(S.stair_dir) then
        S.stair_dir = 10 - S.stair_dir
      end
    end

    if OT.kind == "curve_stair" then
      S.x_side = assert(OT.x_side)
      S.y_side = assert(OT.y_side)

      if sym == "x" then S.x_side = 10 - S.x_side end
      if sym == "y" then S.y_side = 10 - S.y_side end
    end
  end


  local function symmetry_fill(T, box)
    gui.debugf("Symmetry fill @ %s : (%d %d) -> (%d %d)\n",
               R:tostr(), box.x1, box.y1, box.x2, box.y2)

gui.debugf("Fab.symmetry = %s\n", tostring(T.info.symmetry))
gui.debugf("Room.symmetry = %s\n", tostring(R.symmetry))
gui.debugf("Transposed : %s\n", string.bool(T.transpose))

    local do_x = (T.info.symmetry == "x")
    local do_y = (T.info.symmetry == "y")

    -- TODO: support "xy" symmetrical fabs
    assert(do_x or do_y)

    if T.transpose then do_x,do_y = do_y,do_x end

    -- first pass is merely a test
    for pass = 1,2 do
      for x = box.x1,box.x2 do for y = box.y1,box.y2 do
        local S = SEEDS[x][y]
        assert(S and S.room == R)

        if S.kind == "walk" and not S.floor_h then
          local ox, oy = x, y

          if do_x then
            ox = area.x2 - (x - area.x1)
          elseif do_y then
            oy = area.y2 - (y - area.y1)
          end

          assert(Seed_valid(ox, oy))

          local OT = SEEDS[ox][oy]
          assert(OT and OT.room == R)

          if pass == 1 then
            -- check that copy is possible
            -- (Note: most of the time it is OK)
            if (S.conn or S.pseudo_conn or S.must_walk) and
               not (OT.kind == "walk")
            then
gui.debugf("symmetry_fill FAILED  S:%s != OT:%s\n", S:tostr(), OT:tostr())
              R.symmetry = nil
              return false
            end

          elseif do_x then
            mirror_seed(S, OT, "x")
          elseif do_y then
            mirror_seed(S, OT, "y")
          end
        end
      end end -- for x, y
    end -- for pass

    return true  --OK--
  end


  local function clip_heights(tab, where)
    assert(tab and #tab >= 1)

    local new_tab = table.copy(tab)

    for i = 1,where do
      table.remove(new_tab, 1)
    end

    assert(#new_tab >= 1)
    return new_tab
  end


  local function try_one_pattern(name, info)
    local possibles = {}

    local T = { info=info }

    for tr_n = 0,1 do
      T.transpose = (tr_n == 1)

      T.long = sel(T.transpose, area.th, area.tw)
      T.deep = sel(T.transpose, area.tw, area.th)

      T.x_sizes = matching_sizes(info.x_sizes, T.long)
      T.y_sizes = matching_sizes(info.y_sizes, T.deep)

gui.debugf("  tr:%s  long:%d  deep:%d\n", string.bool(T.transpose), T.long, T.deep)
      if T.x_sizes and T.y_sizes then
        local xs = rand.pick(T.x_sizes)
        local ys = rand.pick(T.y_sizes)

        local xf_tot = 1
        local yf_tot = 1

        -- for symmetrical patterns no need to try the flipped version
        if T.info.symmetry == "x" or T.info.symmetry == "xy" then xf_tot = 0 end
        if T.info.symmetry == "y" or T.info.symmetry == "xy" then yf_tot = 0 end

        for xf_n = 0,xf_tot do for yf_n = 0,yf_tot do
          T.x_flip = (xf_n == 1)
          T.y_flip = (yf_n == 1)

          convert_structure(T, info, xs, ys)

          T.score = eval_pattern(T)

          if T.score > 0 then
            table.insert(possibles, table.copy(T))
          end
        end end -- for xf_n, yf_n
      end 
    end -- for tr_n

    if #possibles == 0 then
      return false
    end

gui.debugf("Possible patterns:\n%s\n", table.tostr(possibles, 2))

    T = table.pick_best(possibles,
        function(A,B) return A.score > B.score end)

gui.debugf("Chose pattern with score %1.4f\n", T.score)

    -- determine fill mode of each sub-area
    local want_subs = {}
    local sym_fills = {}

    for s_idx,sub in ipairs(info.subs or {}) do
      if sub.sym_fill and (req_sym or rand.odds(50)) then
        sym_fills[s_idx] = true
      elseif sub.recurse or sub.sym_fill then
        -- recursive fill
      else
        want_subs[s_idx] = true
      end
    end

    install_pattern(T, want_subs)


    -- recursive sub-division

    for s_idx,sub in ipairs(info.subs or {}) do
      local new_area = find_sub_area(T, tostring(s_idx))
      assert(new_area)

      if sym_fills[s_idx] and symmetry_fill(T, new_area) then
        -- OK, symmetry fill worked

      elseif sub.recurse or sub.sym_fill then
        local new_hs = clip_heights(heights, sub.height)
        local new_ft = clip_heights(f_texs,  sub.height)

        local new_sym = req_sym

        -- drop symmetry requirement??
        if (new_sym == "x" or new_sym == "xy") and
           ((new_area.x1 + new_area.x2) != (area.x1 + area.x2))
        then
          new_sym = nil
        end

        if (new_sym == "y" or new_sym == "xy") and
           ((new_area.y1 + new_area.y2) != (area.y1 + area.y2))
        then
          new_sym = nil
        end

        Layout_try_pattern(R, new_area, div_lev+1, new_sym, new_hs, new_ft)
      end
    end

    return true  -- YES !!
  end


  local function set_pattern_min_max(info)
    local min_size =  999
    local max_size = -999

    for pass = 1,2 do
      local sizes = sel(pass == 1, info.x_sizes, info.y_sizes)
      
      each sz_str in sizes do
        local w = total_size(sz_str)
        
        min_size = math.min(min_size, w)
        max_size = math.max(max_size, w)
      end
    end

    info.min_size = min_size
    info.max_size = max_size

gui.debugf("MIN_MAX of %s = %d..%d\n", info.name, info.min_size, info.max_size)
  end


  local function can_use_fab(info)
    if not info.prob then
      return false
    end

    -- check if too big or too small
    if not info.min_size then
      set_pattern_min_max(info)
    end

    if info.min_size > math.max(area.tw, area.th) or
       info.max_size < math.min(area.tw, area.th)
    then
      return false
    end


    if info.kind == "liquid" and not LEVEL.liquid then
      return false -- no liquids available
    end

    if (info.environment == "indoor"  and R.is_outdoor) or
       (info.environment == "outdoor" and not R.is_outdoor)
    then
      return false -- wrong environment
    end

    if (info.z_direction == "up"   and (#heights < 2 or (heights[1] > heights[2]))) or
       (info.z_direction == "down" and (#heights < 2 or (heights[1] < heights[2])))
    then
      return false -- wrong z_direction
    end

    if (info.level == "top" and div_lev != 1) or
       (info.level == "sub" and div_lev == 1)
    then
      return false -- wrong level
    end

    -- enough symmetry?
    -- [NOTE: because of transposing, treat "x" == "y" here]
    if not req_sym then return true end
    if info.symmetry == "xy" then return true end

    if req_sym == "xy" then return false end
    if not info.symmetry then return false end

    return true --OK--
  end


  local function add_fab_list(probs, infos, fabs, sol_mul, liq_mul)
    for name,info in pairs(fabs) do
      if can_use_fab(info) then
        infos[name] = info
        probs[name] = info.prob

        if info.kind == "solid" then
          probs[name] = probs[name] * sol_mul
        elseif info.kind == "liquid" then
          probs[name] = probs[name] * liq_mul
        end

        if info.shape == STYLE.room_shape then
          probs[name] = probs[name] * 20.0
        end
      end
    end
  end


  local function do_try_divide()
    if LEVEL.plain_rooms then return false end

    if R.children then return false end
    if R.kind == "cave" then return false end

    assert(R.kind != "hallway")
    assert(R.kind != "stairwell")

    local sol_mul = 1.0
    if STYLE.junk == "heaps" then sol_mul = 3.0 end

    local liq_mul = 1.0
    if STYLE.liquids == "few"   then liq_mul = 0.2 end
    if STYLE.liquids == "heaps" then liq_mul = 5.0 end

    local f_probs = {}
    local f_infos = {}

    add_fab_list(f_probs, f_infos, ROOM_PATTERNS, sol_mul, liq_mul)


    local try_count = 8 + area.tw + area.th

    for loop = 1,try_count do
      if table.empty(f_probs) then
        break;
      end

      local which = rand.key_by_probs(f_probs)
      f_probs[which] = nil

      gui.debugf("Trying pattern %s in %s (loop %d)......\n",
                 which, R:tostr(), loop)

      if try_one_pattern(which, f_infos[which]) then
        gui.debugf("SUCCESS with %s!\n", which)
        return true
      end
    end

    gui.debugf("FAILED to apply any room pattern.\n")
    return false
  end


  ---==| Layout_try_pattern |==---
 
  assert(R.kind != "cave")

  if do_try_divide() then
gui.debugf("Success @ %s (div_lev %d)\n\n", R:tostr(), div_lev)
  else
gui.debugf("Failed @ %s (div_lev %d)\n\n", R:tostr(), div_lev)
    install_flat_floor(heights[1], f_texs[1])
  end
end



function Layout_pattern_in_area(R, area, f_texs)
  -- find a usable pattern in the ROOM_PATTERNS table and
  -- apply it to the room.

  -- this function is responsible for setting floor_h in every
  -- seed in the given 'area'.

  local use_solid_feature = rand.odds(75)


  -- only show debug messages for the top-level pattern
  local function local_debugf(...)
    if area.is_top then
      gui.debugf(...)
    end
  end


  local function pattern_chance(pat)
    if not pat.prob then
      return 0
    end

--FIXME !!!!!! recursive patterns disabled for now
    if pat.recurse then return 0 end

    if pat.min_size > math.max(area.w, area.h) or
       pat.max_size < math.min(area.w, area.h)
    then
      return 0  -- too big or too small
    end

    if pat.kind == "liquid" and not LEVEL.liquid then
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

    if pat.overlay or pat.has_3d_bridge then
      if not PARAM.extra_floors then
        return 0  -- 3D floors not available
      end
    end

    -- enough symmetry?
    -- [NOTE: because of transposing, treat "x" == "y" here]

    if area.symmetry then
      if pat.symmetry != "xy" then
        if area.symmetry == "xy"  then return 0 end
        if not pat.symmetry then return 0 end
      end
    end

    return pat.prob  -- OK --
  end


  local function collect_usable_fabs()
    local solid_factor = 1.0
    if STYLE.junk == "heaps" then solid_factor = 3.0 end

    local liquid_factor = style_sel("liquids", 0, 0.2, 1.0, 5.0)

    local tab = {}

    each name,pat in ROOM_PATTERNS do
      local prob = pattern_chance(pat)

      if pat.kind == "solid" then
        prob = prob * solid_factor
      end

      if pat.kind == "liquid" then
        prob = prob * liquid_factor
      end

      if pat.shape == STYLE.room_shape then
        prob = prob * 20
      end

      if prob > 0 then
        tab[name] = pat.prob
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


  local function setup_floor(S, h, f_tex)
    S.floor_h = h

    S.f_tex = sel(R.is_outdoor, R.main_tex, f_tex)

    local C = S.conn or S.pseudo_conn

    if C then
      C.conn_h    = S.floor_h
      C.conn_ftex = S.f_tex
    end
  end


  local function setup_solid(S, pat)
    assert(not S.conn)

    S.kind = "void"

    if pat.solid_feature and use_solid_feature then 
      S.solid_feature = true
    end
  end


  local function setup_liquid(S)
    assert(LEVEL.liquid)
    S.kind = "liquid"
    R.has_liquid = true

    -- NOTE: floor_h for liquids is determined later
  end


  local function install_flat_floor()
    R.no_pattern = true

    local f_h   = assert(area.entry_h)
    local f_tex = f_texs[1]

    for x = area.x1, area.x2 do
    for y = area.y1, area.y2 do
      local S = SEEDS[x][y]

      -- currently this can only happen in rooms with sub-rooms
      if S.room != R then continue end

      setup_floor(S, f_h, f_tex)
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

    return dir
  end


  local function eval_a_chunk(pat, px, py, T, sx1, sy1, sw, sh)
    local sx2 = sx1 + sw - 1
    local sy2 = sy1 + sh - 1

    assert(area.x1 <= sx1 and sx2 <= area.x2)
    assert(area.y1 <= sy1 and sy2 <= area.y2)

    local P = pat._structure[px][py]

    for sx = sx1, sx2 do
    for sy = sy1, sy2 do
      local S = SEEDS[sx][sy]
      assert(S and S.room == R)

      -- connections must join onto a floor
      if (S == area.entry_S or S.conn or S.pseudo_conn or S.must_walk) then
        if P.kind != "floor" then
          return -1
        end
      end

      -- remember which floor-id we enter the area at
      if S == area.entry_S then
        T.entry_floor = P.floor
      end

    end -- sx, sy
    end

    return 1  -- OK --
  end


  local function install_a_chunk(pat, px, py, T, sx1, sy1, sw, sh)
    local sx2 = sx1 + sw - 1
    local sy2 = sy1 + sh - 1

    local f_h   = assert(area.entry_h)
    local f_tex = f_texs[1]

    local P = pat._structure[px][py]

    -- store the chunk information in a CHUNK object
    local CHUNK =
    {
      sx1 = sx1
      sy1 = sy1
      sx2 = sx2
      sy2 = sy2

      kind = P.kind

      overlay = {}
    }

    if P.dir then
      CHUNK.dir = transform_dir(T, dir)
    end

    if pat._overlay then
      if pat._overlay[px][py].kind != "empty" then
        CHUNK.overlay.kind = pat._overlay[px][py].kind
        CHUNK.overlay.dir  = pat._overlay[px][py].dir

        R.has_3d_floor = true
      end
    end

    -- update the seeds --

    for sx = sx1, sx2 do
    for sy = sy1, sy2 do
      local S = SEEDS[sx][sy]

      S.chunk = CHUNK

      -- FIXME !!!!! TEMPORARY CRUD !!!

      if P.kind == "liquid" then
        setup_liquid(S)

      elseif P.kind == "solid" then
        setup_solid(S, pat)

      else
        setup_floor(S, f_h, f_tex)
      end
    end -- sx, sy
    end
  end


  local function eval_pattern(pat, T)
    local score = 10

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

    score = score + gui.random()

    return score
  end


  local function install_pattern(pat, T)
    -- this only happens for START room and teleporter destinations
    if not T.entry_floor then
---      T.entry_floor = 0
    end

stderrf("install_pattern @ %s : entry_floor = %s\n", R:tostr(), tostring(T.entry_floor))

    for px = 1, pat._structure.w do
    for py = 1, pat._structure.h do
      local sx, sy, sw, sh = transform_coord(T, px, py)

      if sw == 0 or sh == 0 then continue end

      install_a_chunk(pat, px, py, T, sx, sy, sw, sh)
    end -- x, y
    end
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

          T.entry_floor = nil

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

  local_debugf("Layout_pattern_in_area @ %s : (%d %d) %dx%d\n", R:tostr(),
               area.x1, area.y1, area.w, area.h)

  assert(R.kind != "cave")
  assert(R.kind != "hallway")
  assert(R.kind != "stairwell")

  if not test_patterns() then
    install_flat_floor()
  end

  local_debugf("\n")
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

  Layout_set_floor_minmax(R)

  if R.no_pattern then return end

  handle_stairs()

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


  local function select_floor_texs()
    local f_texs  = {}

    local focus_C = R.entry_conn

    if focus_C and focus_C.conn_ftex and
       focus_C.R1.kind == focus_C.R2.kind and
       focus_C.kind != "teleporter" and
       not focus_C.fresh_floor
    then
      table.insert(f_texs, focus_C.conn_ftex)
    end

    for i = 1,7 do
      if R.theme.floors then
        table.insert(f_texs, rand.key_by_probs(R.theme.floors))
      else
        table.insert(f_texs, f_texs[1] or R.main_tex)
      end
    end

    return f_texs
  end


  local INDOOR_DELTAS  = { [16]=5,  [32]=10, [48]=20, [64]=20, [96]=10, [128]=5 }
  local OUTDOOR_DELTAS = { [32]=20, [48]=30, [80]=20, [112]=5 }

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


  local function select_deltas()
    -- resulting table is indexed by a virtual floor id.
    -- the [0] value is always 0, [-1] .. [-4] are negative and
    -- [1] .. [4] are positive.

    local tab = {}

    local delta_tab = sel(R.is_outdoor, OUTDOOR_DELTAS, INDOOR_DELTAS)

    tab[0] = 0

    for i = 1, 4 do
      local d1 = rand.key_by_probs(delta_tab)
      local d2 = rand.key_by_probs(delta_tab)

      tab[ i] = tab[ i - 1] + d1
      tab[-i] = tab[-i + 1] - d2
    end

    return tab
  end


  local function pick_unvisited_area()
    each A in R.areas do
      -- already done?
      if A.filled then continue end

      -- need an entry height
      if not A.entry_h then continue end

      return A  -- OK
    end

    return nil  -- all areas are filled
  end


  local function fill_room(entry_h)
    -- create intiial area
    local AREA =
    {
      x1 = R.tx1
      y1 = R.ty1
      x2 = R.tx2
      y2 = R.ty2

      entry_h = entry_h
    }

    if R.entry_conn then
      if R.entry_conn.R1 == R then
        AREA.entry_S = R.entry_conn.S1  -- may be nil (teleporters)
      else
        AREA.entry_S = R.entry_conn.S2  -- ditto
      end
    end

    R.areas = { AREA }

    AREA.deltas   = select_deltas()
    AREA.symmetry = R.symmetry
    AREA.is_top   = true

    local f_texs = select_floor_texs()

    -- iterate over areas until all are filled.
    -- recursive patterns will add extra areas to the list.

    while true do
      local A = pick_unvisited_area()

      if not A then break; end

      Layout_pattern_in_area(R, A, f_texs)

      A.filled = true
    end

    -- validate all areas were filled
    each A in R.areas do
      if not A.filled then
        error("Layout_room failed to fill all areas")
      end
    end
  end


  ---==| Layout_room |==---

gui.debugf("LAYOUT %s >>>>\n", R:tostr())

  local entry_h

  if R.entry_conn and R.entry_conn.conn_h then
    entry_h = R.entry_conn.conn_h

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

    local BORDER =
    {
      kind = "edge"
      side = side
      room = R

      sx1 = x1
      sy1 = y1
      sx2 = x2
      sy2 = y2
    }

    R.border_edges[side] = true

    install_border(BORDER)
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

    -- only build a corner if it will connect to an edge

    local L_dir = geom.LEFT_45 [corner]
    local R_dir = geom.RIGHT_45[corner]

    if not R.border_edges[L_dir] and
       not R.border_edges[R_dir]
    then return end

    -- check that we can build something there

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

    local BORDER =
    {
      kind = "corner"
      side = corner
      room = R

      sx1 = x1
      sy1 = y1
      sx2 = x2
      sy2 = y2
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

  LEVEL.border_group = GAME.GROUPS["border_dropoff"]
  assert(LEVEL.border_group)

  collect_rooms()

  stretch_buildings()

  plan_borders()
end



function Layout_build_outdoor_borders()

  local function build_border(B)
-- stderrf("build %s @ [%d %d] side:%d\n", B.kind, B.sx1, B.sy1, B.side)
    local x1 = SEEDS[B.sx1][B.sy1].x1
    local y1 = SEEDS[B.sx1][B.sy1].y1
    local x2 = SEEDS[B.sx2][B.sy2].x2
    local y2 = SEEDS[B.sx2][B.sy2].y2

    local skin0 = { wall=w_tex }

    local floor_h = assert(B.room.floor_max_h)

    if B.kind == "edge" then
      local skin1 = GAME.SKINS["Border_dropoff_t"]
      assert(skin1)

      local T = Trans.box_transform(x1, y1, x2, y2, floor_h, 10 - B.side)

      Fabricate_at(B.room, skin1, T, { skin0, skin1 })

    elseif B.kind == "corner" then
      local skin1 = GAME.SKINS["Border_dropoff_c"]
      assert(skin1)

      local dir = 10 - geom.LEFT_45[B.side]

      local T = Trans.box_transform(x1, y1, x2, y2, floor_h, dir)

      Fabricate_at(B.room, skin1, T, { skin0, skin1 })
    end
  end


  local function nearby_facade(S)
do return "CRACKLE2" end

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


  ---| Layout_build_outdoor_borders |---

  each B in LEVEL.map_borders do
    build_border(B)
  end

  fill_remaining_gaps()
end

