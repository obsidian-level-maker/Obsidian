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


  local function evaluate_spot(spot)
    -- Factors we take into account:
    --   1. distance from walls
    --   2. distance from entrance / exits
    --   3. distance from other goals
    --   4. rank value from prefab

    local wall_dist = assert(spot.wall_dist)
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

    -- want a different height   [ FIXME !!!! ]
    if R.entry_conn and R.entry_conn.conn_h and spot.floor_h then
      local diff_h = math.abs(R.entry_conn.conn_h - spot.floor_h)

      score = score + diff_h / 10
    end

---???    -- for symmetrical rooms, prefer a centred item
---???    if sx == bonus_x then score = score + 0.8 end
---???    if sy == bonus_y then score = score + 0.8 end
 
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

  local list = R.normal_wotsits
  if table.empty(list) then list = R.emergency_wotsits end
  if table.empty(list) then list = R.dire_wotsits end
  
  if table.empty(list) then
    if none_OK then return nil end
    error("No usable spots in room!")
  end


  local best
  local best_score = 0

  each spot in list do
    local score = evaluate_spot(spot)

    if score > best_score then
      best = spot
      best_score = score
    end
  end

  assert(best)



  --- OK ---


  -- never use it again
  table.kill_elem(list, spot)

  spot.content_kind = kind
  
  table.insert(R.goals, spot)


  local x1 = spot.x - 96
  local y1 = spot.y - 96
  local x2 = spot.x + 96
  local y2 = spot.y + 96

  -- no monsters near start spot or teleporters
  -- FIXME: do this later (for chunks)
  if kind == "START" then
    R:add_exclusion("empty",     x1, y1, x2, y2, 96)
    R:add_exclusion("nonfacing", x1, y1, x2, y2, 512)

  elseif kind == "TELEPORTER" then
    R:add_exclusion("empty",     x1, y1, x2, y2, 144)
    R:add_exclusion("nonfacing", x1, y1, x2, y2, 384)
  end


  return spot
end



function Layout_place_importants(R)

  local function add_purpose()
    local spot = Layout_spot_for_wotsit(R, R.purpose)

    R.guard_spot = spot
  end


  local function add_teleporter()
    local spot = Layout_spot_for_wotsit(R, "TELEPORTER")

    -- sometimes guard it, but only for out-going teleporters
    if not R.guard_spot and (R.teleport_conn.R1 == R) and
       rand.odds(60)
    then
      R.guard_spot = spot
    end
  end


  local function add_weapon(weapon)
    local spot = Layout_spot_for_wotsit(R, "WEAPON", "none_OK")

    if not spot then
      gui.printf("WARNING: no space for %s!\n", weapon)
      return
    end

    spot.content_item = weapon

    if not R.guard_spot then
      R.guard_spot = spot
    end
  end


  local function add_item(item)
    local spot = Layout_spot_for_wotsit(R, "ITEM", "none_OK")

    if not spot then return end

    spot.content_item = item

    if not R.guard_spot then
      R.guard_spot = spot
    end
  end


  local function collect_wotsit_spots()
    -- main spots are "inner points" of areas

    R.normal_wotsits = {}

    each A in R.areas do
      each S in A.inner_points do
        -- FIXME : wall_dist
        local wall_dist = rand.range(0.5, 2.5)
        table.insert(R.normal_wotsits, { x=S.x1, y=S.y1, wall_dist=wall_dist })
      end
    end

    -- emergency spots are the middle of whole (square) seeds
    R.emergency_wotsits = {}

    each S in R.seeds do
      if S.content or S.conn then continue end
      if not S.diagonal then
        local mx, my = S.mid_point()
        local wall_dist = rand.range(0.4, 0.5)
        table.insert(R.emergency_wotsits, { x=mx, y=my, wall_dist=wall_dist })
      end
    end

    -- dire emergency spots are the middle of diagonal seeds
    R.dire_wotsits = {}

    each S in R.seeds do
      if S.diagonal then
        local mx, my = S.mid_point()
        local wall_dist = rand.range(0.2, 0.3)
        table.insert(R.dire_wotsits, { x=mx, y=my, wall_dist=wall_dist })
      end
    end
  end


  ---| Layout_place_importants |---

  collect_wotsit_spots()

---???  Layout_compute_wall_dists(R)

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

