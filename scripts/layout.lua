------------------------------------------------------------------------
--  LAYOUTING UTILS
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2015 Andrew Apted
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
      if C.kind == "teleporter" then continue end

      for pass = 1, 2 do
        local E = sel(pass == 1, C.E1, C.F1)

        if not E then continue end
        
        local ex, ey = Edge_mid_point(E)

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


  local function nearest_important(spot)
    local dist

    each imp in R.importants do
      local d = geom.dist(imp.x, imp.y, spot.x, spot.y) / SEED_SIZE

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
    --   3. distance from importants
    --   4. rank value from prefab

    local wall_dist = assert(spot.wall_dist)
    local conn_dist = nearest_conn(spot) or 20
    local  imp_dist = nearest_important(spot) or 20

    -- combine conn_dist and imp_dist
    local score = math.min(imp_dist, conn_dist * 1.5)

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
--[[ FIXME
    if kind == "TELEPORTER" and spot.chunk[2] then
      score = score - 10
    end
--]]

    -- apply the skill bits from prefab
    if spot.rank then
      score = score + (spot.rank - 1) * 5 
    end

    -- want a different height   [ FIXME !!!! ]
    if R.entry_conn and R.entry_conn.conn_h and spot.floor_h then
      local diff_h = math.abs(R.entry_conn.conn_h - spot.floor_h)

      score = score + diff_h / 10
    end

    -- tie breaker
    score = score + gui.random() ^ 2

--[[
if R.id == 6 then
stderrf("  (%2d %2d) : wall:%1.1f conn:%1.1f imp:%1.1f --> score:%1.2f\n",
    sx, sy, wall_dist, conn_dist,  imp_dist, score)
end
--]]
    return score
  end


  local function evaluate_closet(area)
    if not (kind == "START" or kind == "LEVEL_EXIT" or
            kind == "KEY"   or kind == "ITEM"  or kind == "WEAPON")
    then
      return -1
    end

    -- already used?
    if area.closet_kind then return -1 end

    -- OK
    return 9999
  end


  local function do_exclusions(spot)
    local x1 = spot.x - 76
    local y1 = spot.y - 76
    local x2 = spot.x + 76
    local y2 = spot.y + 76

    -- no monsters near start spot or teleporters
    -- Fixme: do this later (for chunks)
    if kind == "START" then
      R:add_exclusion("empty",     x1, y1, x2, y2, 96)
      R:add_exclusion("nonfacing", x1, y1, x2, y2, 512)

    elseif kind == "TELEPORTER" then
      R:add_exclusion("empty",     x1, y1, x2, y2, 144)
      R:add_exclusion("nonfacing", x1, y1, x2, y2, 384)
    end
  end


  ---| Layout_spot_for_wotsit |---

  if R.mirror_x and R.tw >= 3 then bonus_x = int((R.tx1 + R.tx2) / 2) end
  if R.mirror_y and R.th >= 3 then bonus_y = int((R.ty1 + R.ty2) / 2) end

  local list = R.normal_wotsits
  if table.empty(list) then list = R.emergency_wotsits end
  if table.empty(list) then list = R.dire_wotsits end
  

  local best
  local best_score = 0

  each spot in list do
    local score = evaluate_spot(spot)

    if score > best_score then
      best = spot
      best_score = score
    end
  end

  -- now try closets
  each area in R.areas do
    if area.mode == "closet" then
      local score = evaluate_closet(area)

      if score > best_score then
        best = { closet=area }
        best_score = score
      end
    end
  end


  if not best then
    if none_OK then return nil end
--- stderrf("FUCKED UP IN %s\n", R.name)
---    do return { x=0, y=0, z=0, wall_dist=0} end
    error("No usable spots in room!")
  end


  --- OK ---

  local spot = assert(best)

  if spot.closet then
    -- mark closet area as used
    spot.closet.closet_kind = kind
    spot.closet.closet_spot = spot

    spot.area = spot.closet

  else
    -- never use it again
    table.kill_elem(list, spot)

    spot.content_kind = kind

    table.insert(R.importants, spot)

    --TODO support closets here too
    do_exclusions(spot)
  end

  return spot
end



function Layout_place_importants(R)

  local function add_goal(goal)
    local spot = Layout_spot_for_wotsit(R, goal.kind)

-- stderrf("Layout_place_importants: goal '%s' @ %s\n", goal.kind, R.name)

    spot.item = goal.item
    spot.goal = goal

    if goal.kind != "START" then
      R.guard_spot = spot
    end

    -- remember floor height of players (needed by monster depots)
    if goal.kind == "START" and not goal.alt_start then
      LEVEL.player1_z = spot.area.floor_h
    end
  end


  local function add_teleporter(conn)
    local spot = Layout_spot_for_wotsit(R, "TELEPORTER")

    spot.conn = conn
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
    if A.mode == "cage" or A.rect_info then continue end
    each corner in A.inner_points do
      -- FIXME : wall_dist
      local wall_dist = rand.range(0.5, 2.5)
     local z = assert(A.floor_h)
     table.insert(R.normal_wotsits, { x=corner.x + 0, y=corner.y + 0, z=z, wall_dist=wall_dist, area=A })
    end
    end

    -- emergency spots are the middle of whole (square) seeds
    R.emergency_wotsits = {}

    each S in R.seeds do
      if S.conn then continue end
      if not S.diagonal then
        local mx, my = S:mid_point()
        local wall_dist = rand.range(0.4, 0.5)
        local z = assert(S.area and S.area.floor_h)
        table.insert(R.emergency_wotsits, { x=mx, y=my, z=z, wall_dist=wall_dist, area=S.area })
      end
    end

    -- dire emergency spots are inside diagonal seeds
    R.dire_wotsits = {}

    each S in R.seeds do
      if S.diagonal or S.conn then
        local mx, my = S:mid_point()
        local wall_dist = rand.range(0.2, 0.3)
        local z = assert(S.area and S.area.floor_h)
        table.insert(R.dire_wotsits, { x=mx, y=my, z=z, wall_dist=wall_dist, area=S.area, is_dire=true })
      end
    end
  end


  ---| Layout_place_importants |---

  if R.kind == "stairwell" then
    return
  end

  collect_wotsit_spots()

---???  Layout_compute_wall_dists(R)

  if R.kind == "cave" or
     (rand.odds(5) and R.sw >= 3 and R.sh >= 3)
  then
    R.cave_placement = true
  end

  each goal in R.goals do
    add_goal(goal)
  end

  each tel in R.teleporters do
    add_teleporter(tel)
  end

  each name in R.weapons do
    add_weapon(name)
  end

  each name in R.items do
    add_item(name)
  end
end



function Layout_choose_face_room(A)
  -- used for big cages and liquid pools (converted from void)

  local best
  local best_score = 0

  each N in A.neighbors do
    if N.zone != A.zone then continue end
    if not N.floor_h then continue end

    local junc = Junction_lookup(A, N)

    local score = junc.perimeter + 2.2 * gui.random() ^ 2

    if N.mode == "hallway" then
      score = score / 10
    end

    if score > best_score then
      best = N.room
      best_score = score
    end
  end

  return best
end



function Layout_traps_and_cages()
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


  local function eval_area_for_cage(A)
    -- must be VOID or SCENIC
    if not (A.mode == "void" or A.mode == "scenic") then return -1 end
    if A.closety then return -1 end

    if A.svolume > 6 then return -1 end

    -- must touch a room (but not START room)
    local touch_a_room = false

    each N in A.neighbors do
      if N.zone != A.zone then continue end

      if N.room and not N.room.is_start then
        touch_a_room = true
      end
    end

    if not touch_a_room then return -1 end

    return 100  -- OK --
  end


  local function collect_big_cages()
    -- find all void areas that could be turned into a large cage

    local list = {}
    local svolume = 0

    each A in LEVEL.areas do
      -- reserved for closets?
      if A.is_closety then continue end

      if eval_area_for_cage(A) > 0 then
        table.insert(list, A)
        svolume = svolume + A.svolume
      end
    end

    rand.shuffle(list)

    return list, svolume
  end


  local function try_teleportation_trap(spot)
    local A = assert(spot.area)
    local R = assert(A.room)

    -- we will need several places for teleport destinations
    if R.total_inner_points < 5 then return false end

    local dests = {}

    dests[1] = Layout_spot_for_wotsit(R, "MON_TELEPORT", "none_OK")
    dests[2] = Layout_spot_for_wotsit(R, "MON_TELEPORT", "none_OK")
    dests[3] = Layout_spot_for_wotsit(R, "MON_TELEPORT", "none_OK")

    -- do not use the "dire" emergency spots
    if not (dests[1] and not dests[1].is_dire) then return false end
    if not (dests[2] and not dests[2].is_dire) then return false end

    if dests[3] and dests[3].is_dire then dests[3] = nil end

    -- need a free depot too
    local x1, y1 = Seed_alloc_depot()

    if not x1 then
      gui.debugf("Cannot make teleportation trap: out of depots\n")
      return
    end

    -- OK --

    gui.debugf("Making teleportation trap in %s\n", A.name)

    each dest in dests do
      dest.tag = alloc_id("tag")

---###  table.insert(R.mon_teleports, dest)
    end

    local TRIGGER =
    {
      r = 64
      action = 109  -- W1 : open and stay /fast
      tag = alloc_id("tag")
    }

    spot.trigger = TRIGGER

    -- create the DEPOT information

    local skin =
    {
      trigger_tag = TRIGGER.tag

      out_tag1 = dests[1].tag
      out_tag2 = dests[2].tag
      out_tag3 = dests[1].tag  -- not a typo
    }

    if dests[3] then
      skin.out_tag3 = dests[3].tag
    end

    local DEPOT =
    {
      room = R
      x1 = x1
      y1 = y1
      skin = skin
      trigger = spot.trigger
    }

    table.insert(LEVEL.depots, DEPOT)

    return true
  end


  local function make_trap(A, parent_A, spot)
    gui.debugf("Making big trap in %s\n", A.name)

    A.mode = "trap"
    A.is_boundary = false

    A.floor_h   = parent_A.floor_h
    A.face_room = parent_A.room

    A.kind  = parent_A.kind
    A.zone  = parent_A.zone

    -- if facing room is outdoor, make trap have a ceiling
    -- (better than walls going all the way up to the sky)
    if parent_A.is_outdoor then
      A.is_outdoor = nil
    end

    -- make monsters in trap look at spot
    A.mon_focus = spot

    if not spot.trigger then
      local TRIGGER =
      {
        r = 64
        action = 2
        tag = alloc_id("tag")
      }

      -- the trigger brush is done by Render_importants()
      spot.trigger = TRIGGER
    end

    -- trap wall is created in Room_border_up...
    A.trap_trigger = spot.trigger
  end


  local function try_trapify_important(spot, areas)
    if not
       (spot.content_kind == "KEY"    or spot.content_kind == "SWITCH" or
        spot.content_kind == "WEAPON" or spot.content_kind == "ITEM")
    then
      return false
    end

    -- less chance for mere items
    if (spot.content_kind == "WEAPON" or spot.content_kind == "ITEM") and
       rand.odds(5) then
      return false
    end

    local A = assert(spot.area)
    local R = assert(A.room)

    -- never in secrets
    if R.is_secret then return end

    -- never in a start room
    if R.is_start then return end

    -- check for a usable trap area neighboring the spot area
    -- TODO : this is too restrictive

    if rand.odds(10) and try_teleportation_trap(spot) then
      return true
    end

    local prob = 100
    local count = 0

    local neighbors = rand.shuffle(table.copy(A.neighbors))

    each N in neighbors do
      if table.has_elem(areas, N) and rand.odds(prob) then
        make_trap(N, A, spot)

        table.kill_elem(areas, N)
        count = count + 1

        prob = prob / 2
      end
    end

    if count == 0 and rand.odds(50) then
      return try_teleportation_trap(spot)
    end

    return (count > 0)
  end


  local function add_traps()
    local make_prob = style_sel("traps", 0, 20, 40, 75)
   
    if make_prob == 0 then
      gui.printf("Traps: skipped for level (by style).\n")
      return
    end

    local areas = collect_big_cages()

    -- FIXME : visit importants in random order

    each R in LEVEL.rooms do
      each spot in R.importants do
        if rand.odds(make_prob) then
          try_trapify_important(spot, areas)
        end
      end
    end
  end


  local function make_cage(A)
    gui.debugf("Making big cage in %s\n", A.name)

    A.face_room = Layout_choose_face_room(A)
    if not A.face_room then return end

    A.mode = "cage"
    A.is_boundary = nil

    -- determine height and set junctions

    each N in A.neighbors do
      if N.zone != A.zone then continue end

      if N.room then
        A.floor_h = math.N_max(N.floor_h, A.floor_h)

        -- railing (etc) is handled in Room_border_up...
      end
    end

    assert(A.floor_h)

    A.floor_h = A.floor_h + 40
  end


  local function add_cages()
    local quota     = style_sel("cages", 0, 10, 30, 90)
    local skip_prob = style_sel("cages", 100, 40, 20, 0)

    if rand.odds(skip_prob) then
      gui.printf("Cages: skipped for level (by style).\n")
      return
    end

    gui.printf("Cages: quota = %d%%\n", quota)


    local areas, svolume = collect_big_cages()

    quota = int(svolume * quota * rand.range(1.0, 1.2))

    each A in areas do
      if quota < 1 then break; end

      if A.svolume <= quota then
        make_cage(A)

        quota = quota - A.svolume
      end
    end
  end


  ---| Layout_traps_and_cages |---

  -- never in DM or CTF maps
  if OB_CONFIG.mode == "dm" or OB_CONFIG.mode == "ctf" then
    return
  end

  add_traps()

--!!!  add_cages()
end



function Layout_update_cages()
  -- TODO

end


------------------------------------------------------------------------


function Layout_create_scenic_borders()
  --
  -- Handles the "scenic" stuff outside of the normal map.
  -- For example: a watery "sea" around at one corner of the map.
  --
  -- This mainly sets up area information (and creates "scenic rooms").
  -- The actual brushwork is done by normal area-building code.
  --

  local function neighbor_min_max(Z)
    local min_f
    local max_f

    each A in Z.border_info.areas do
    each N in A.neighbors do
      if N.zone != Z then continue end

      if N.room and N.floor_h then
        min_f = math.N_min(N.floor_h, min_f)
        max_f = math.N_max(N.floor_h, max_f)
      end
    end
    end

    -- possible for min_h and max_h to be NIL here

    Z.border_info.nb_min_f = min_f
    Z.border_info.nb_max_f = max_f
  end


  local function collect_border_areas(Z)
    Z.border_info.areas = {}

    each A in LEVEL.areas do
      if A.is_boundary and A.zone == Z then
        table.insert(Z.border_info.areas, A)
      end
    end
  end


  local function set_junctions(A)
    each N in A.neighbors do
      if N.room and N.is_outdoor then
        local junc = Junction_lookup(A, N)
        assert(junc)

        if A.kind == "water" and N.room.kind == "hallway" then
--!!!!!! FIXME
--[[
          junc.kind = "fence"
          junc.fence_mat = A.zone.fence_mat
          junc.fence_top_z = N.room.hallway.max_h + 32
--]]
        elseif A.kind == "water" then
--!!!!!! FIXME
--[[
          junc.kind = "rail"
          junc.rail_mat = "MIDBARS3"
          junc.post_h   = 84
          junc.blocked  = true
--]]
        elseif A.kind != "void" then
          junc.keep_empty = true
        end
      end
    end
  end


  local function setup_zone(Z)
    Z.border_info = {}

    collect_border_areas(Z)

    neighbor_min_max(Z)

    -- this only possible if a LOT of void areas
    if not Z.border_info.nb_min_f then
      Z.border_info.kind = "void"
    elseif LEVEL.liquid and rand.odds(40 * 0) then  --!!! FIXME
      Z.border_info.kind = "water"
    else
      Z.border_info.kind = "mountain"
    end

    each A in Z.border_info.areas do
      A.kind = Z.border_info.kind
      
      if A.kind != "void" then
        A.is_outdoor = true
      end
    end

    each A in Z.border_info.areas do
      set_junctions(A)
    end
  end


  ---| Layout_create_scenic_borders |---
   
  LEVEL.hill_mode = rand.sel(70, "high", "low")

  each Z in LEVEL.zones do
    setup_zone(Z)
  end
end



function Layout_finish_scenic_borders()

  local function max_neighbor_floor(A)
    local max_f

    each N in A.neighbors do
      if N.is_boundary then continue end
      if N.zone != A.zone then continue end
      if not N.is_outdoor then continue end  -- TODO check for window junctions?

      if N.room and N.floor_h then
        max_f = math.N_max(N.floor_h, max_f)
      end
    end

    return max_f
  end


  local function temp_properties(A)
    local max_f = max_neighbor_floor(A)

    if not max_f then
      max_f = A.zone.scenic_sky_h - rand.pick({ 16, 160, 192, 224, 400 }) / 2
    end

    A. ceil_h = A.zone.scenic_sky_h
    A.floor_h = math.min(max_f + 64, A.ceil_h - 32)

    A.floor_mat = LEVEL.cliff_mat
    A.ceil_mat  = "_SKY"
    A.wall_mat  = A.floor_mat
  end


  local function do_outer_skies(A)
    if A.kind == "void" then return end

    if not A.floor_h then return end

    each S in A.seeds do
      for dir = 2,8,2 do
        if S:neighbor(dir, "NODIR") == "NODIR" then continue end

        if not S:raw_neighbor(dir) then
          Render_outer_sky(S, dir, A.floor_h)
        end
      end
    end
  end


  ---| Layout_finish_scenic_borders |---

  each Z in LEVEL.zones do
    local add_h = rand.pick({ 128,256,384 })
    Z.scenic_sky_h = Z.sky_h ---!!! + add_h
  end

  each A in LEVEL.areas do
    if A.is_boundary then
      temp_properties(A)
      do_outer_skies(A)
    end
  end
end



function Layout_liquid_stuff()


  local function try_pool_in_area(A)
    -- random chance
    if rand.odds(60) then return end

    -- ensure large enough  [ very large is OK too ]
    if A.svolume < 2.0 then return end

    -- choose facing room (might be NIL)
    local face_room = Layout_choose_face_room(A)
    if not face_room then return end

    -- if it is a hallway, it must be flat
    if face_room.kind == "hallway" and not face_room.hallway.flat then
      return
    end

    -- OK --

    A.mode = "pool"
    A.pool_id = alloc_id("pool")

    A.face_rooms = { face_room }
    A.face_room  = face_room
    A.is_outdoor = face_room.is_outdoor
    A.is_boundary = nil

    -- determine floor height
    local min_f

    each N in A.neighbors do
      if N.room == face_room and N.floor_h then
        min_f = math.N_min(N.floor_h, min_f)
      end
    end

    assert(min_f)

    if face_room.kind == "hallway" and face_room.hallway.min_h then
      min_f = math.N_min(min_f, face_room.hallway.min_h)
    end

    A.floor_h = min_f - 16
  end


  local function merge_pool_groups(gr1, gr2, floor_h)
    assert(gr1 and gr2)
    assert(gr1 != gr2)

    if gr1 > gr2 then gr1,gr2 = gr2,gr1 end

    each A in LEVEL.areas do
      if A.pool_id == gr2 then
         A.pool_id = gr1
      end

      if A.pool_id == gr1 then
        A.floor_h = floor_h
      end
    end
  end


  local function try_merge_pools(A, N)
    if A.zone != N.zone then return end

    -- already done?
    if A.pool_id == N.pool_id then return end

    local R1 = A.face_rooms[1]
    local R2 = N.face_rooms[1]

    -- must be same quest
    if R1.quest != R2.quest then return end

    -- must be same outdoors-ness
    if A.is_outdoor != N.is_outdoor then return end

    -- OK --

    local new_floor_h = math.min(A.floor_h, N.floor_h)

    merge_pool_groups(A.pool_id, N.pool_id, new_floor_h)

    table.append(A.face_rooms, N.face_rooms)
    N.face_rooms = A.face_rooms
  end


  local function faces_room(A, room)
    each R in A.face_rooms do
      if R == room then return true end
    end

    return false
  end


  local function do_pool_junction(A, N)
    if N.zone != A.zone then return end

    local junc = Junction_lookup(A, N)

    -- room which faces into the pool?

    if N.room and faces_room(A, N.room) then
      junc.keep_empty = true
      return
    end

    -- handle pool <--> pool

    if N.mode == "pool" then
      if N.pool_id == A.pool_id then
        junc.keep_empty = true
        return
      end
    end

    -- use railing to with nearby room with higher floor

    if N.room and N.is_outdoor and A.is_outdoor and
       N.mode != "hallway" and
       N.floor_h and N.floor_h > A.floor_h
    then
--!!!!!! FIXME
--[[
      junc.kind = "rail"
      junc.rail_mat = "MIDBARS3"
      junc.post_h   = 84
      junc.blocked  = true
--]]
      return
    end

    -- near a map border ?

    if N.is_boundary and A.face_rooms[1].is_outdoor then
      -- mountains will prevent travel
      if A.zone.border_info.kind != "water" then
        junc.keep_empty = true
        return
      end
    end


    -- FIXME : fences !!!

--!!!!!!    junc.kind = "wall"
  end


  ---| Layout_liquid_stuff |---

do return end  -- very broken atm

  if LEVEL.liquid_usage == 0 then return end

  each A in LEVEL.areas do
    if A.mode == "void" and not A.closety then
      try_pool_in_area(A)
    end
  end

  -- merge pools where possible

  each A in LEVEL.areas do
  each N in A.neighbors do
    if A.mode == "pool" and N.mode == "pool" then
      try_merge_pools(A, N)
    end
  end
  end

  -- do junctions now (to handle two touching pools)

  each A in LEVEL.areas do
  each N in A.neighbors do
    if A.mode == "pool" then
      do_pool_junction(A, N)
    end
  end
  end
end



function Layout_handle_corners()

  local function need_fencepost(corner) --OLD
    --
    -- need a fence post where :
    --   1. three or more areas meet (w/ different heights)
    --   2. all the areas are outdoor
    --   3. one of the junctions/edges is "rail"
    --   4. none of the junctions/edges are "wall"
    --

    if #corner.areas < 3 then return false end

    post_h = nil

    local heights = {}

    each A in corner.areas do
      if not A.is_outdoor then return false end
      if not A.floor_h then return false end

      table.add_unique(heights, A.floor_h)

      each B in corner.areas do
        local junc = Junction_lookup(A, B)
        if junc then
          if junc.kind == "wall" then return false end
          if junc.kind == "rail" then post_h = assert(junc.post_h) end
        end
      end
    end

    if #heights < 3 then return false end

    return (post_h != nil)
  end


  local function fencepost_base_z(corner)
    local z

    each A in corner.areas do
      z = math.N_max(A.floor_h, z)
    end

    return z
  end


  local function near_porch(corner)
    each A in corner.areas do
      if A.is_porch then return true end
    end

    return false
  end


  local function check_corner(cx, cy)
    local corner = Corner_lookup(cx, cy)
    
    if not corner.kind and
       #corner.areas > 1 and
       near_porch(corner) and
       not Corner_touches_wall(corner)
    then
      corner.kind = "post"
    end
  end


  ---| Layout_handle_corners |---

  for cx = 1, SEED_W + 1 do
  for cy = 1, SEED_H + 1 do
    check_corner(cx, cy)
  end
  end
end



function Layout_outdoor_shadows()

  local function need_shadow(S, dir)
    if not S.area then return false end

    local N = S:neighbor(dir)

    if not (N and N.area) then return false end

    local SA = S.area
    local NA = N.area

    if N.kind == "void" or not NA.is_outdoor or NA.mode == "void" or NA.is_porch then return false end
    if S.kind == "void" or not SA.is_outdoor or SA.mode == "void" or SA.is_porch then return true end

    if SA == NA then return false end

    local E1 = S.edge[dir]
    local E2 = N.edge[10 - dir]

    local junc = Junction_lookup(SA, NA)

    if not E1 then E1 = junc.E1 end
    if not E2 then E2 = junc.E2 end

    if E1 and Edge_is_wallish(E1) then return true end
    if E2 and Edge_is_wallish(E2) then return true end

    return false
  end
 

  local function shadow_from_seed(S, dir)
    local dx = 64
    local dy = 128

    local brush
    
    if dir == 2 then
      brush =
      {
        { m = "light", shadow=1 }
        { x = S.x1     , y = S.y1      }
        { x = S.x1 - dx, y = S.y1 - dy }
        { x = S.x2 - dx, y = S.y1 - dy }
        { x = S.x2     , y = S.y1      }
      }
    elseif dir == 4 then
      brush =
      {
        { m = "light", shadow=1 }
        { x = S.x1     , y = S.y1      }
        { x = S.x1     , y = S.y2      }
        { x = S.x1 - dx, y = S.y2 - dy }
        { x = S.x1 - dx, y = S.y1 - dy }
      }
    elseif dir == 1 then
      brush =
      {
        { m = "light", shadow=1 }
        { x = S.x1     , y = S.y2      }
        { x = S.x1 - dx, y = S.y2 - dy }
        { x = S.x2 - dx, y = S.y1 - dy }
        { x = S.x2     , y = S.y1      }
      }
    elseif dir == 3 then
      brush =
      {
        { m = "light", shadow=1 }
        { x = S.x1     , y = S.y1      }
        { x = S.x1 - dx, y = S.y1 - dy }
        { x = S.x2 - dx, y = S.y2 - dy }
        { x = S.x2     , y = S.y2      }
      }
    else
      -- nothing needed
      return
    end

    raw_add_brush(brush)    
  end


  ---| Layout_outdoor_shadows |---

  each A in LEVEL.areas do
    each S in A.seeds do
      each dir in geom.ALL_DIRS do
        if need_shadow(S, dir) then
          shadow_from_seed(S, dir)
        end
      end
    end
  end
end



------------------------------------------------------------------------
--   STAIRWELLS
------------------------------------------------------------------------


function Layout_build_stairwell(A)

  local R = A.room


  local function edge_vector(S, dir)
    -- TODO : make SEED method, use in render.lua in add_edge_line()

    local x1, y1 = S.x1, S.y1
    local x2, y2 = S.x2, S.y2

    if dir == 2 then return x1,y1, x2,y1 end
    if dir == 8 then return x2,y2, x1,y2 end

    if dir == 4 then return x1,y2, x1,y1 end
    if dir == 6 then return x2,y1, x2,y2 end

    if dir == 1 then return x1,y2, x2,y1 end
    if dir == 3 then return x1,y1, x2,y2 end

    if dir == 7 then return x2,y2, x1,y1 end
    if dir == 9 then return x2,y1, x1,y2 end

    error ("edge_vector: bad dir")
  end


  local function control_coord(cx, cy,
                               sc_x1, sc_y1, sc_x2, sc_y2,
                               lc_x1, lc_y1, lc_x2, lc_y2)

    sc_x1 = sc_x1 + (sc_x2 - sc_x1) * cy
    sc_y1 = sc_y1 + (sc_y2 - sc_y1) * cy

    lc_x1 = lc_x1 + (lc_x2 - lc_x1) * cy
    lc_y1 = lc_y1 + (lc_y2 - lc_y1) * cy

    local x = sc_x1 + (lc_x1 - sc_x1) * cx
    local y = sc_y1 + (lc_y1 - sc_y1) * cx

    return x, y
  end


  local function calc_inner_line(L, l_dist, R, r_dist)
    -- vector from L --> R
    dx, dy = geom.unit_vector(R.x - L.x, R.y - L.y)

    local LI =
    {
      x = L.x + l_dist * dx
      y = L.y + l_dist * dy
    }

    local RI =
    {
      x = R.x - r_dist * dx
      y = R.y - r_dist * dy
    }

    return LI, RI
  end


  local function calc_arch_mat(edge)
    local N = edge.S:neighbor(edge.dir)

    assert(N)
    assert(N.area != A)

    return calc_wall_mat(N.area, A)
  end


  local function make_archway(P0, P1, P2, P3, dir, mat, arch_h)
    local TK = 16

    if geom.is_corner(dir) then
      TK = 11
    end

    local nx, ny = geom.delta(dir)

    nx = nx * TK
    ny = ny * TK

    -- left part

    local l_brush =
    {
      { x = P0.x,      y = P0.y }
      { x = P0.x + nx, y = P0.y + ny }
      { x = P1.x + nx, y = P1.y + ny }
      { x = P1.x,      y = P1.y }
    }

    brushlib.set_mat(l_brush, mat)

    Trans.brush(l_brush)

    -- middle part

    local m_brush =
    {
      { x = P1.x,      y = P1.y }
      { x = P1.x + nx, y = P1.y + ny }
      { x = P2.x + nx, y = P2.y + ny }
      { x = P2.x,      y = P2.y }
    }

    brushlib.add_bottom(m_brush, arch_h)
    brushlib.set_mat(m_brush, mat, mat)

    Trans.brush(m_brush)

    -- right part

    local r_brush =
    {
      { x = P2.x,      y = P2.y }
      { x = P2.x + nx, y = P2.y + ny }
      { x = P3.x + nx, y = P3.y + ny }
      { x = P3.x,      y = P3.y }
    }

    brushlib.set_mat(r_brush, mat)

    Trans.brush(r_brush)
  end


  ---| Layout_build_stairwell |---

  local well = A.is_stairwell

  -- FIXME : use the new EDGE objects !!
  local edge1 = A.edge_loops[1][well.edge1]
  local edge2 = A.edge_loops[1][well.edge2]


  -- starting coords [ L for left side, R for right side ]

  local lx1,ly1, rx1,ry1 = edge_vector(edge1.S, edge1.dir)

  local L1 = { x=lx1, y=ly1 }
  local R1 = { x=rx1, y=ry1 }

  -- ending coords

  local rx2,ry2, lx2,ly2 = edge_vector(edge2.S, edge2.dir)

  local L2 = { x=lx2, y=ly2 }
  local R2 = { x=rx2, y=ry2 }

  -- normals (facing inward here)
  local nx1, ny1 = geom.unit_vector(geom.delta(10 - edge1.dir))
  local nx2, ny2 = geom.unit_vector(geom.delta(10 - edge2.dir))


  -- control points

  local lx3, ly3
  local rx3, ry3

  local l_pivot
  local r_pivot

  if well.info.straight then
    lx3, ly3 = (lx1 + lx2) / 2, (ly1 + ly2) / 2
    rx3, ry3 = (rx1 + rx2) / 2, (ry1 + ry2) / 2

  else
    -- with same shapes, one side stays at same coordinate ("pivot")
    if geom.dist(lx1, ly1, lx2, ly2) < 1 then
      lx3, ly3 = lx1, ly1
      l_pivot  = true
    else
      lx3, ly3 = geom.intersect_lines(lx1, ly1, lx1 + nx1, ly1 + ny1,
                                      lx2, ly2, lx2 + nx2, ly2 + ny2)
    end

    if geom.dist(rx1, ry1, rx2, ry2) < 1 then
      rx3, ry3 = rx1, ry1
      r_pivot  = true
    else
      rx3, ry3 = geom.intersect_lines(rx1, ry1, rx1 + nx1, ry1 + ny1,
                                      rx2, ry2, rx2 + nx2, ry2 + ny2)
    end
  end


  -- ability to override control points
  -- [ needed by certain shapes, e.g. I1 ]
  -- s = short side, l = long side

  local short_side = "L"
  local sc_x1, sc_y1, sc_x2, sc_y2 = lx1,ly1, lx2,ly2
  local lc_x1, lc_y1, lc_x2, lc_y2 = rx1,ry1, rx2,ry2

  if geom.dist(lx1,ly1,lx2,ly2) > geom.dist(rx1,ry1,rx2,ry2) then
    short_side = "R"
    sc_x1, sc_y1, sc_x2, sc_y2 = rx1,ry1, rx2,ry2
    lc_x1, lc_y1, lc_x2, lc_y2 = lx1,ly1, lx2,ly2
  end

  if well.info.scx then
    local x, y = control_coord(well.info.scx, well.info.scy,
                               sc_x1, sc_y1, sc_x2, sc_y2,
                               lc_x1, lc_y1, lc_x2, lc_y2)
    if short_side == "L" then
      lx3, ly3 = x, y
    else
      rx3, ry3 = x, y
    end
  end

  if well.info.lcx then
    local x, y = control_coord(well.info.lcx, well.info.lcy,
                               sc_x1, sc_y1, sc_x2, sc_y2,
                               lc_x1, lc_y1, lc_x2, lc_y2)
    if short_side != "L" then
      lx3, ly3 = x, y
    else
      rx3, ry3 = x, y
    end
  end


  local L3 = { x=lx3, y=ly3 }
  local R3 = { x=rx3, y=ry3 }


  local num_steps = well.num_steps 
  assert(num_steps)

  -- collect bounding points (one more than num_steps)
  local L0_points = {}
  local R0_points = {}

  for i = 0, num_steps do
    local lx, ly = geom.bezier_coord(L1, L3, L2, i / num_steps)
    local rx, ry = geom.bezier_coord(R1, R3, R2, i / num_steps)

    L0_points[i] = { x=lx, y=ly }
    R0_points[i] = { x=rx, y=ry }
--stderrf("%d/%d ---> L (%d %d)  |  R (%d %d)\n", i,num_steps, lx,
  end

  -- compute wall and stair points (coming in from the boundary)
  local L1_points = {}
  local L2_points = {}

  local R1_points = {}
  local R2_points = {}

  for i = 0, num_steps do
    local L1, R1 = calc_inner_line(L0_points[i], sel(l_pivot, 48, 16),
                                   R0_points[i], sel(r_pivot, 48, 16))

    local L2, R2 = calc_inner_line(L0_points[i], sel(l_pivot, 64, 24),
                                   R0_points[i], sel(r_pivot, 64, 24))

    L1_points[i] = L1 ; R1_points[i] = R1
    L2_points[i] = L2 ; R2_points[i] = R2
  end


  -- TODO : local floor_hs = {}  ceil_hs = {}


  -- actually build something --


-- HANDY TEST STUFF
--[[
do
  for i = 0,30 do
    local lx, ly = geom.bezier_coord(L1, L3, L2, i / 30)
    local rx, ry = geom.bezier_coord(R1, R3, R2, i / 30)

    Trans.entity("candle", lx, ly, A.floor_h)
    Trans.entity("potion", rx, ry, A.floor_h)
  end

return end
--]]


  local cur_z = well.start_z

  local stair_diff_h = well.diff_h
  local headroom     = 128

  local step_mat = Mat_lookup_tex("STEP1")

  local f_st_idx = sel(stair_diff_h < 0, 3, 1)


  if stair_diff_h > 0 then
    cur_z = cur_z + stair_diff_h
  end


  for i = 0, num_steps - 1 do
    local k = i + 1

    local z = cur_z + i * stair_diff_h

    -- step floor

    local f_brush =
    {
      { x = L2_points[i].x, y = L2_points[i].y }
      { x = R2_points[i].x, y = R2_points[i].y }
      { x = R2_points[k].x, y = R2_points[k].y }
      { x = L2_points[k].x, y = L2_points[k].y }
    }

    brushlib.add_top(f_brush, z)

    brushlib.set_mat(f_brush, "CEIL5_1", "CEIL5_1")

    f_brush[f_st_idx].tex = step_mat.t
    f_brush[f_st_idx].v1  = 0
    f_brush[f_st_idx].u1  = 0

    Trans.brush(f_brush)


    -- step ceiling

    local c_brush =
    {
      { x = L2_points[i].x, y = L2_points[i].y }
      { x = R2_points[i].x, y = R2_points[i].y }
      { x = R2_points[k].x, y = R2_points[k].y }
      { x = L2_points[k].x, y = L2_points[k].y }
    }

    brushlib.add_bottom(c_brush, z + headroom)

    brushlib.set_mat(c_brush, "FLAT1", "FLAT1")

    Trans.brush(c_brush)


    -- left wall

    local l_brush =
    {
      { x = L1_points[i].x, y = L1_points[i].y }
      { x = L2_points[i].x, y = L2_points[i].y }
      { x = L2_points[k].x, y = L2_points[k].y }
      { x = L1_points[k].x, y = L1_points[k].y }
    }

    brushlib.set_mat(l_brush, "GRAY7")

    Trans.brush(l_brush)

    -- right wall

    local r_brush =
    {
      { x = R2_points[i].x, y = R2_points[i].y }
      { x = R1_points[i].x, y = R1_points[i].y }
      { x = R1_points[k].x, y = R1_points[k].y }
      { x = R2_points[k].x, y = R2_points[k].y }
    }

    brushlib.set_mat(r_brush, "GRAY7")

    Trans.brush(r_brush)
  end


  -- archways (done with code to align nicely with stairwell walls)
  if true then
    local E = num_steps

    local arch_h1 = cur_z + headroom + (0) * stair_diff_h
    local arch_h2 = cur_z + headroom + (num_steps-1) * stair_diff_h

    local mat1 = calc_arch_mat(edge1)
    local mat2 = calc_arch_mat(edge2)

    make_archway(L0_points[0], L2_points[0], R2_points[0], R0_points[0],
                 edge1.dir, mat1, arch_h1)

    make_archway(R0_points[E], R2_points[E], L2_points[E], L0_points[E],
                 edge2.dir, mat2, arch_h2)
  end
end

