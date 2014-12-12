------------------------------------------------------------------------
--  LAYOUTING UTILS
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


  local function nearest_conn(spot)
    local dist

    each C in R.conns do
      if C.kind == "normal" or C.kind == "closet" then
        local S = C:get_seed(R)
        local dir = sel(C.R1 == R, C.dir, 10 - C.dir)

        local ex, ey = S:edge_coord(dir)
        local d = geom.dist(ex, ey, spot.x, spot.y) / SEED_SIZE

        -- tie breaker
        d = d + gui.random() / 1024

        if not dist or d < dist then
          dist = d
        end
      end
    end

    return dist
  end


  local function nearest_goal(spot)
    local dist

    each goal in R.goals do
      local d = geom.dist(goal.x, goal.y, spot.x, spot.y) / SEED_SIZE

      -- tie breaker
      d = d + gui.random() / 1024

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
--- stderrf("FUCKED UP IN %s\n", R:tostr())
---    do return { x=0, y=0, z=0, wall_dist=0} end
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



  --- OK ---

  local spot = assert(best)


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
        local z = assert(S.floor_h)
        table.insert(R.normal_wotsits, { x=S.x1 + 32, y=S.y1 + 32, z=z, wall_dist=wall_dist })
      end
    end

    -- emergency spots are the middle of whole (square) seeds
    R.emergency_wotsits = {}

    each S in R.half_seeds do
      if S.conn then continue end
      if not S.diagonal then
        local mx, my = S:mid_point()
        local wall_dist = rand.range(0.4, 0.5)
        local z = assert(S.area and S.area.floor_h)
        table.insert(R.emergency_wotsits, { x=mx, y=my, z=z, wall_dist=wall_dist })
      end
    end

    -- dire emergency spots are inside diagonal seeds
    R.dire_wotsits = {}

    each S in R.half_seeds do
      if S.diagonal or S.conn then
        local mx, my = S:mid_point()
        local wall_dist = rand.range(0.2, 0.3)
        local z = assert(S.area and S.area.floor_h)
        table.insert(R.dire_wotsits, { x=mx, y=my, z=z, wall_dist=wall_dist })
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


------------------------------------------------------------------------


function Layout_build_importants()

  -- the current room
  local R


  local function player_dir(spot)
    -- FIXME : analyse all 4 directions, pick one which can see the most
    --         [ or opposite of one which can see the least ]

    local S = Seed_from_coord(spot.x, spot.y)

    if R.sh > R.sw then
      if S.sy > (R.sy1 + R.sy2) / 2 then 
        return 2
      else
        return 8
      end
    else
      if S.sx > (R.sx1 + R.sx2) / 2 then 
        return 4
      else
        return 6
      end
    end
  end


  local function content_big_item(spot, item)
    local fab_name = "Item_pedestal"

    -- FIXME: TEMP RUBBISH
    if string.sub(item, 1, 2) == "kc" or
       string.sub(item, 1, 2) == "ks" then
      fab_name = "Item_podium"
    end

    local def = PREFABS[fab_name]
    assert(def)

    local skin1 = { item=item }

    local T = Trans.spot_transform(spot.x, spot.y, spot.z, spot.dir)

    Fabricate(R, def, T, { skin1 })

    Trans.entity("light", spot.x, spot.y, spot.z+112, { cave_light=176 })
  end


  local function content_very_big_item(spot, item, is_weapon)
--[[  FIXME : LOWERING PEDESTALS

    -- sometimes make a lowering pedestal
    local prob = sel(is_weapon, 40, 20)

    if rand.odds(prob) and
       THEME.lowering_pedestal_skin and
       not S.chunk[2]
    then
      local mx, my = spot.x, spot.y
      local z1 = spot.z

      local z_top

      if R.kind == "cave" then
        z_top = z1 + rand.pick({ 64, 96 })

      else
        local z2 = S.ceil_h or S.room.ceil_h or (z1 + 256)

        if z2 < z1 + 170 then
          z_top = z1 + 64
        else
          z_top = z1 + 128
        end
      end

      Build.lowering_pedestal(S, z_top, THEME.lowering_pedestal_skin)

      Trans.entity(item, mx, my, z_top)
      Trans.entity("light", mx, my, z_top + 24, { cave_light=176 })

      return
    end
--]]

    content_big_item(spot, item)
  end


  local function content_start_pad(spot, dir)
    local def = PREFABS["Start_basic"]
    assert(def)

    local T = Trans.spot_transform(spot.x, spot.y, spot.z, 10 - dir)

    Fabricate(R, def, T, { })
  end


  local function content_coop_pair(spot, dir)
    -- no prefab for this : add player entities directly

    local mx = spot.x
    local my = spot.y
    local  z = spot.z

    local angle = geom.ANGLES[dir]

    local dx, dy = geom.delta(dir)

    dx = dx * 24 ; dy = dy * 24

    Trans.entity(R.player_set[1], mx - dy, my + dx, z, { angle=angle })
    Trans.entity(R.player_set[2], mx + dy, my - dx, z, { angle=angle })

    if GAME.ENTITIES["player8"] then
      mx = mx - dx * 2
      my = my - dy * 2

      Trans.entity(R.player_set[3], mx - dy, my + dx, z, { angle=angle })
      Trans.entity(R.player_set[4], mx + dy, my - dx, z, { angle=angle })
    end
  end


  local function content_start(spot)
    local dir = player_dir(spot)

    if R.player_set then
      content_coop_pair(spot, dir)

--[[
    elseif false and PARAM.raising_start and R.svolume >= 20 and
       R.kind != "cave" and
       THEME.raising_start_switch and rand.odds(25)
    then
      -- TODO: fix this
      gui.debugf("Raising Start made\n")

      local skin =
      {
        f_tex = S.f_tex or R.main_tex,
        switch_w = THEME.raising_start_switch,
      }

      Build.raising_start(S, 6, z1, skin)
      angle = 0

      S.no_floor = true
      S.raising_start = true
      R.has_raising_start = true
--]]
    else

      content_start_pad(spot, dir)
    end
  end


  local function content_exit(spot)
    local def = PREFABS["Exit_switch"]
    assert(def)

    local skin1 = { }

    if R.purpose == "SECRET_EXIT" then skin1.special = 51 end

    local dir = spot.dir or 2

    local T = Trans.spot_transform(spot.x, spot.y, spot.z, 10 - dir)

    Fabricate(R, def, T, { skin1 })
  end


  local function content_purpose(spot)
    if R.purpose == "START" then
      content_start(spot)

---???    elseif R.purpose == "EXIT" and OB_CONFIG.game == "quake" then
---???      local skin = { floor="SLIP2", wall="SLIPSIDE" }
---???
---???      Build.quake_exit_pad(S, z1 + 16, skin, LEVEL.next_map)

    elseif R.purpose == "EXIT" or R.purpose == "SECRET_EXIT" then
      content_exit(spot)

    elseif R.purpose == "KEY" then
      local LOCK = assert(R.purpose_lock)
      content_very_big_item(spot, LOCK.item)

    elseif R.purpose == "SWITCH" then
--[[ FIXME: BUILD SWITCHES
      local LOCK = assert(R.purpose_lock)
      local INFO = assert(GAME.SWITCHES[LOCK.switch])
      Build.small_switch(S, dir_for_wotsit(S), z1, INFO.skin, LOCK.tag)
      Trans.entity("light", mx, my, z1+112, { cave_light=176 })
--]]

    else
      error("unknown purpose: " .. tostring(R.purpose))
    end
  end


  local function content_weapon(spot)
    local weapon = assert(spot.content_item)

    if R.purpose == "START" or R.is_hallway then
      -- bare item
      Trans.entity(weapon, spot.x, spot.y, spot.z)
    else
      content_very_big_item(spot, weapon, "is_weapon")
    end

    gui.debugf("Placed weapon '%s' @ (%d,%d,%d)\n", weapon, spot.x, spot.y, spot.z)
  end


  local function content_item(spot)
    local item = assert(spot.content_item)

    if R.purpose == "START" or R.is_hallway then
      -- bare item
      Trans.entity(item, spot.x, spot.y, spot.z)
    else
      content_big_item(spot, item)
    end
  end


  local function content_teleporter(spot)
    -- FIXME !!!!  content_teleporter

    local C = R.teleport_conn
    assert(C)

    local def = PREFABS["Teleporter1"]
    assert(def)

    local skin1 = {}

    if C.R1 == R then
      skin1. in_tag = C.tele_tag2
      skin1.out_tag = C.tele_tag1
    else
      skin1. in_tag = C.tele_tag1
      skin1.out_tag = C.tele_tag2
    end

    skin1. in_target = string.format("tele%d", skin1. in_tag)
    skin1.out_target = string.format("tele%d", skin1.out_tag)

    local mx, my = S:mid_point()
    local spot_dir = 10 - dir_for_wotsit(S)
    local z = assert(S.floor_h)

    local T = Trans.spot_transform(mx, my, z, spot_dir)

    Fabricate(R, def, T, { skin1 })
  end


  local function build_goal(G)
    if G.content_kind == "WEAPON" then
      content_weapon(G)
    elseif G.content_kind == "ITEM" then
      content_item(G)
    elseif G.content_kind == "TELEPORTER" then
      content_teleporter(G)
    else
      content_purpose(G)
    end
  end


  ---| Layout_build_importants |---

  each room in LEVEL.rooms do
    R = room

    each goal in R.goals do
      build_goal(goal)
    end
  end
end


------------------------------------------------------------------------


function Layout_outer_borders()
  --
  -- Handles the "scenic" stuff outside of the normal map.
  -- For example: a watery "sea" around at one corner of the map.
  --
  -- This mainly sets up area information (and creates "scenic rooms").
  -- The actual brushwork is done by normal area-building code.
  --


  local function test_watery_corner()
    -- TODO
  end


  ---| Layout_outer_borders |---

  test_watery_corner()
end

