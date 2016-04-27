------------------------------------------------------------------------
--  LAYOUTING UTILS
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2016 Andrew Apted
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


function Layout_compute_dists(R)
  --
  -- Compute various distances in a room:
  --
  -- (1) give each seed a 'sig_dist' value, which is roughly the #
  --     of seeds the player must walk to reach a significant thing
  --     in the room (including entry and exit points).
  --

  local function can_traverse(S, N)
    -- FIXME
    return true
  end


  local function mark_chunk(chunk)
    for sx = chunk.sx1, chunk.sx2 do
    for sy = chunk.sy1, chunk.sy2 do
      SEEDS[sx][sy].sig_dist = 0
    end
    end
  end


  local function init_sig_dists()
    each S in R.seeds do
      S.sig_dist = nil

      each dir in geom.ALL_DIRS do
        local E = S.edge[dir]

        if E and E.conn then
          S.sig_dist = 0.7
        end
      end
    end

    -- now check teleporters
    each chunk in R.chunks do
      if chunk.content_kind == "TELEPORTER" then
        mark_chunk(chunk)
      end
    end

    each chunk in R.closets do
      if chunk.content_kind == "TELEPORTER" then
        mark_chunk(chunk)
      end
    end

    -- finally handle goal spots
    each goal in R.goals do
      if goal.kk_spot then
        mark_chunk(goal.kk_spot)
      end
    end
  end


  local function collect_fillable_seeds()
    local list = {}

    each S in R.seeds do
      if S.sig_dist then continue end

      each dir in geom.ALL_DIRS do
        local N = S:neighbor(dir)

        if N and N.room == R and N.sig_dist and can_traverse(S, N) then
          table.insert(list, S)
          break;
        end
      end
    end

    return list
  end


  local function spread_sig_dists()
    local list = collect_fillable_seeds()

    if table.empty(list) then
      return false
    end

    each S in list do
      each dir in geom.ALL_DIRS do
        local N = S:neighbor(dir)

        if N and N.room == R and N.sig_dist and can_traverse(S, N) then
          S.sig_dist = math.min(N.sig_dist + 1, S.sig_dist or 999)
        end
      end

      assert(S.sig_dist)
    end

    return true
  end


  local function calc_chunk_sig_dist(chunk)
    -- compute average of all seeds in chunk
    local sum = 0
    local total = 0

    for sx = chunk.sx1, chunk.sx2 do
    for sy = chunk.sy1, chunk.sy2 do
      local dist = SEEDS[sx][sy].sig_dist

      if dist then
        sum = sum + dist
        total = total + 1
      end
    end
    end

--  stderrf("chunk %s in %s --> %1.1f / %d\n", chunk.kind or "??", R.name, sum, total)

    if total > 0 then
      chunk.sig_dist = sum / total
    end
  end


  local function visit_chunks(list)
    each chunk in list do
      calc_chunk_sig_dist(chunk)
    end
  end


--[[
  local function init_wall_dists()
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


  local function spread_wall_dists()
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
--]]


  ---| Layout_compute_dists |---

  init_sig_dists()

  for loop = 1, 999 do
    if not spread_sig_dists() then break; end
  end

  visit_chunks(R.chunks)
  visit_chunks(R.closets)
end



function Layout_reclaim_floor_chunk(R)
end



function Layout_spot_for_wotsit(R, kind, required)

  local function eval_spot(chunk)
    -- already used?
    if chunk.content_kind then return -1 end

    -- handle symmetrical room
    if chunk.peer and chunk.peer.content_kind == kind then
      return 700 + gui.random()
    end

    -- TODO: review this
    if kind == "SWITCH" then
      if chunk.kind != "closet" then return -1 end
    end

    local score = (chunk.sig_dist or 0) * 10

    if kind == "TELEPORTER" then
      if chunk.kind == "closet" then
        score = score + 27
      end

      if chunk.sw >= 2 or chunk.sh >= 2 then
        score = score + 7
      end

    else
      if chunk.sw >= 2 and chunk.sh >= 2 then
        score = score + 17

        if chunk.is_straddler then
          if kind == "EXIT"  then score = score + 25 end
          if kind == "START" then score = score + 25 end
          if kind == "KEY"   then score = score +  5 end
        end
      elseif chunk.sw >= 2 or chunk.sh >= 2 then
        score = score + 5
      end

      if kind == "START" and chunk.kind != "closet" then
        score = score + 12
      end
    end

    -- tie breaker
    return score + gui.random() ^ 2
  end


  ---| Layout_spot_for_wotsit |---
 
  Layout_compute_dists(R)

  local best
  local best_score = 0

  -- first, try floor chunks
  each chunk in R.chunks do
    local score = eval_spot(chunk)

    if score > best_score then
      best = chunk
      best_score = score
    end
  end

  -- now try closets
  each chunk in R.closets do
    local score = eval_spot(chunk)

    if score > best_score then
      best = chunk
      best_score = score
    end
  end


  if best then
    local spot = assert(best)

    -- never use it again
    spot.content_kind = kind

    return spot
  end


  -- nothing available!

  return nil
end



function Layout_place_importants(R)

  local function point_in_front_of_closet(chunk, r)
    local mx, my = chunk.mx, chunk.my

    if chunk.from_dir == 2 then return mx, chunk.y1 - r end
    if chunk.from_dir == 8 then return mx, chunk.y2 + r end

    if chunk.from_dir == 4 then return chunk.x1 - r, my end
    if chunk.from_dir == 6 then return chunk.x2 + r, my end

    error("point_in_front_of_closet : unknown dir")
  end


  local function add_goal(goal)
    local spot = Layout_spot_for_wotsit(R, goal.kind, "required")

    if not spot then
      error("No spot in room for " .. goal.kind)
    end

-- stderrf("Layout_place_importants: goal '%s' @ %s\n", goal.kind, R.name)

    spot.content_item = goal.item
    spot.goal = goal

    goal.kk_spot = spot

    if goal.kind != "START" then
      R.guard_chunk = spot
    end

    if goal.kind == "START" then
      if not spot.closet then
-- FIXME broken since our "spot" does not have x1/y1/x2/y2 
--        R:add_entry_spot(spot)
      end

      -- exclude monsters
      local mx, my = spot.mx, spot.my

      if spot.kind == "closet" then
        mx, my = point_in_front_of_closet(spot, 96)
      end

      R:add_exclusion("keep_empty", mx, my,  640)
      R:add_exclusion("non_facing", mx, my, 1280)
    end

---!!!  -- remember floor height of players (needed by monster depots)
---!!!  if goal.kind == "START" and not goal.alt_start then
---!!!    LEVEL.player1_z = spot.area.floor_h
---!!!  end
  end


  local function add_teleporter(conn)
    local spot = Layout_spot_for_wotsit(R, "TELEPORTER", "required")

    if not spot then
      error("No spot in room for teleporter!")
    end

    spot.conn = conn

    -- exclude monsters from being nearby

    local mx, my = spot.mx, spot.my

    if spot.kind == "closet" then
      mx, my = point_in_front_of_closet(spot, 96)
    end

    R:add_exclusion("keep_empty", mx, my, 192)
    R:add_exclusion("non_facing", mx, my, 384)
  end


  local function add_weapon(weapon)
    local spot = Layout_spot_for_wotsit(R, "WEAPON")

    if not spot then
      gui.printf("WARNING: no space for %s!\n", weapon)

      -- try to place it in a future room
      table.insert(LEVEL.unplaced_weapons, weapon)
      return
    end

    spot.content_item = weapon

    if not R.guard_chunk then
      R.guard_chunk = spot
    end
  end


  local function add_item(item)
    local spot = Layout_spot_for_wotsit(R, "ITEM")

    if not spot then return end

    spot.content_item = item

    if not R.guard_chunk then
      R.guard_chunk = spot
    end
  end


  local function try_teleportation_trap(spot)
    local A = assert(spot.area)
    local R = assert(A.room)

    -- we will need several places for teleport destinations
    if R.total_inner_points < 5 then return false end

    local dests = {}

    -- FIXME : do not use Layout_spot_for_wotsit
    dests[1] = Layout_spot_for_wotsit(R, "MON_TELEPORT")
    dests[2] = Layout_spot_for_wotsit(R, "MON_TELEPORT")
    dests[3] = Layout_spot_for_wotsit(R, "MON_TELEPORT")

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


  ---| Layout_place_importants |---

  each tel in R.teleporters do
    add_teleporter(tel)
  end

  each goal in R.goals do
    add_goal(goal)
  end

  if not table.empty(LEVEL.unplaced_weapons) then
    table.append(R.weapons, LEVEL.unplaced_weapons)
    LEVEL.unplaced_weapons = {}
  end

  each name in R.weapons do
    add_weapon(name)
  end

  each name in R.items do
    add_item(name)
  end

  -- TODO : teleportation trap spots
end



function Layout_place_all_importants()
  each R in LEVEL.rooms do
    Layout_place_importants(R)
  end
end



function Layout_choose_face_area(A)
  -- used for scenic liquid pools

  local best
  local best_score = -1

  each N in A.neighbors do
    if not N.room then continue end
    if not N.is_outdoor then continue end

    if N.mode != "floor" then continue end
    if not N.floor_h then continue end

    if N.zone != A.zone then continue end

    if N.room.kind == "hallway" then continue end

    -- ok --

    local junc = Junction_lookup(A, N)

    local score = junc.perimeter + 2.2 * gui.random() ^ 3

    if score > best_score then
      best = N
      best_score = score
    end
  end

  return best
end



function Layout_add_traps()
  --
  -- Add traps into rooms, especially monster closets.
  --


  local function make_trap(A)
    chunk.content_kind = "TRAP"
  end


  local function make_trap_OLD(A, parent_A, spot)
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



  ---| Layout_add_traps |---

  -- TODO
end



function Layout_decorate_rooms(KKK_PASS)
  -- 
  -- Decorate the rooms with crates, pillars, etc....
  --
  -- Also handles all the unused closets in a room, turning them
  -- into cages, secret items (etc).
  --

  local function make_cage(chunk)
    chunk.content_kind = "CAGE"

    -- select cage prefab
    local A = chunk.area
    local reqs

    if chunk.kind == "closet" then
      -- FIXME !!!
      error("TODO")

    else
      reqs =
      {
        kind  = "cage"
        where = "point"

        size  = 96
        height = A.ceil_h - A.floor_h
      }
    end

    if A.room then
      reqs.env = A.room:get_env()
    end

    chunk.prefab_def = Fab_pick(reqs)
  end


  local function make_item_or_secret(A)
    chunk.content_kind = "NICE_ITEM"
  end


  local function kill_closet(chunk)
    chunk.area.mode = "void"
    chunk.content_kind = "void"
  end


  local function try_intraroom_lock(R)
    -- try to lock an unlocked exit and place switch for it
    
    if R.is_start then return end
    if R.is_exit  then return end

    local conn_list = {}

    each C in R.conns do
      local N = C:other_room(R)

      if (C.kind == "joiner" or C.kind == "edge") and not C.lock and
         N.lev_along > R.lev_along
      then
        table.insert(conn_list, C)
      end
    end

    if table.empty(conn_list) then return end

    local spot = Layout_spot_for_wotsit(R, "SWITCH")

    if spot == nil then return end

    -- Ok, can make it

    local C = rand.pick(conn_list)

    local LOCK =
    {
      kind = "intraroom"
      conn = C
      spot = spot
      tag  = alloc_id("tag")
    }

    C.lock    = LOCK
    spot.lock = LOCK
  end


  local function try_decoration_in_chunk(chunk)
    if chunk.sw < 2 then return end
    if chunk.sh < 2 then return end

    -- only try mirrored chunks *once*
    if chunk.peer and chunk.peer.id < chunk.id then return end

    local A = chunk.area

    local reqs =
    {
      kind  = "decor"
      where = "point"

      size  = 96
      height = A.ceil_h - A.floor_h
    }

    if A.room then
      reqs.env = A.room:get_env()
    end

    local def = Fab_pick(reqs, "none_ok")
    if not def then return end

    chunk.content_kind = "DECORATION"
    chunk.prefab_def = def
    chunk.prefab_dir = rand.dir()

    if chunk.peer then
      assert(A.room.symmetry)
      local peer = chunk.peer

      peer.content_kind = chunk.content_kind
      peer.prefab_def   = chunk.prefab_def
      peer.prefab_dir   = A.room.symmetry:conv_dir(chunk.prefab_dir)
    end
  end


  local function switch_up_room(R)
    -- locking exits

    local switch_prob = style_sel("switches", 0, 35, 70, 99)

    for loop = 1, 2 do
      if rand.odds(switch_prob) then
        try_intraroom_lock(R)
      end
    end
  end


  local function pick_cage_spot(locs)
    -- TODO : improve this
    return rand.pick(locs) 
  end


  local function try_extra_cages(R)
    -- determine current quantity of free-range cages
    local cage_vol = 0

    each A in R.areas do
      if A.mode == "cage" then
        cage_vol = cage_vol + A.svolume
      end
    end

    cage_vol = cage_vol / R:calc_walk_vol()

--- stderrf("Cage vol = %1.2f  in %s\n", cage_vol, R.name)

    -- collect usable chunks
    local locs = {}

    each chunk in R.chunks do
      if chunk.sw >= 2 and chunk.sh >= 2 and not chunk.content_kind then
        table.insert(locs, chunk)
      end
    end
--[[
    each chunk in R.closets do
      if not chunk.content_kind then
        table.insert(locs, chunk)
      end
    end
--]]

    -- FIXME decide quota (closets + floors)
    local quota = 99


    -- fill the quota
    while quota > 0 and not table.empty(locs) do
      local chunk = pick_cage_spot(locs)
      if not chunk then break; end

      make_cage(chunk)

      table.kill_elem(locs, chunk)
      quota = quota - 1

      if chunk.peer and not chunk.peer.content_kind then
        local peer = chunk.peer

        peer.content_kind = chunk.content_kind
        peer.prefab_def   = chunk.prefab_def

        if chunk.prefab_dir then
          local A = chunk.area
          assert(A.room.symmetry)
          peer.prefab_dir = A.room.symmetry:conv_dir(chunk.prefab_dir)
        end

        table.kill_elem(locs, chunk.peer)
        quota = quota - 1
      end
    end
  end


  local function tizzy_up_room(R)
    -- more cages, oh yes!
    try_extra_cages(R)

    -- decorative bling
    local decor_prob = rand.pick({ 20, 50, 50, 80 })

    each chunk in R.chunks do
      if chunk.content_kind == nil and rand.odds(decor_prob) then
        try_decoration_in_chunk(chunk)
      end
    end

    -- TODO : handle unused closets

    -- kill any unused closets
    each CL in R.closets do
      if not CL.content_kind then
        kill_closet(CL)
      end
    end
  end


  ---| Layout_decorate_rooms |---

  if KKK_PASS == 1 then
    Layout_add_traps()
  end

  each R in LEVEL.rooms do
    if KKK_PASS == 1 then
      switch_up_room(R)
    else
      tizzy_up_room(R)
    end
  end
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

  local function collect_border_areas(Z)
    Z.border_areas = {}

    each A in LEVEL.areas do
      if A.is_boundary and A.zone == Z then
        table.insert(Z.border_areas, A)
      end
    end
  end


  local function neighbor_min_max(Z)
    local min_f
    local max_f

    each A in Z.border_areas do
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


  local function set_junctions(A)
    each N in A.neighbors do
      if N.room and N.is_outdoor then
        local junc = Junction_lookup(A, N)
        assert(junc)

        if junc.E1 != nil then continue end

        if A.zone != N.zone then continue end

        Junction_make_empty(junc)
      end
    end
  end


  local function setup_zone(Z)
    Z.border_info = {}

    collect_border_areas(Z)

    neighbor_min_max(Z)

--[[  UNUSED STUFF
    -- this only possible if a LOT of void areas
    if not Z.border_info.nb_min_f then
      Z.border_info.kind = "void"
    elseif LEVEL.liquid and rand.odds(40) then
      Z.border_info.kind = "water"
    else
      Z.border_info.kind = "mountain"
    end
--]]

    each A in Z.border_areas do
      if A.mode != "void" then
        A.is_outdoor = true
        A.lighting   = LEVEL.sky_light
      end
    end

    each A in Z.border_areas do
      set_junctions(A)
    end
  end


  ---| Layout_create_scenic_borders |---
   
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

    A.ceil_h   = A.zone.scenic_sky_h
    A.ceil_mat = "_SKY"

    if A.mode != "liquid" then
      A.floor_h = math.min(max_f + 64, A.ceil_h - 32)
      A.floor_mat = LEVEL.cliff_mat
      A.wall_mat  = A.floor_mat
    end
  end


  local function do_outer_skies(A)
    if A.mode == "void" then return end

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
    if A.mode != "scenic" then return end

    -- random chance
--!!!    if rand.odds(60) then return end

    -- never touching edge of map
    if A.touches_edge then return end

    -- size check
    if A.svolume < 4  then return end
    if A.svolume > 20 then return end

    -- choose facing room (might be NIL)
    local face_area = Layout_choose_face_area(A)
    if not face_area then return end

    local face_room = face_area.room

    -- OK --

    A.mode = "liquid"
    A.pool_id = alloc_id("pool")

    A.face_room = face_room

    -- determine floor height
    local min_f

    each N in A.neighbors do
      if N.room == face_room and N.mode == "floor" and N.floor_h then
        min_f = math.N_min(N.floor_h, min_f)
      end
    end

    assert(min_f)

    A.floor_h = min_f - 16
  end


  local function merge_pools()
    for pass = 1, 3 do
      each A in LEVEL.areas do
      each N in A.neighbors do
        if A.pool_id and N.pool_id and A.face_room == N.face_room then
          A.floor_h = math.min(A.floor_h, N.floor_h)
          N.floor_h = A.floor_h
        end
      end -- A, N
      end
    end
  end


  local function do_pool_junction(junc)
    local A = junc.A1
    local N = junc.A2

    if N.zone != A.zone then return end

    if not A.pool_id then A, N = N, A end

    -- neither is a pool?
    if not A.pool_id then return end

    -- pool to pool --

    if N.pool_id then
      if A.face_room == N.face_room then
        Junction_make_empty(junc)
      else
        -- TODO : liquid fences (if one much higher than other)

        Junction_make_fence(junc)
      end

      return
    end


    -- pool to room --

    if not N.room then return end
    if not N.is_outdoor then return end
    if N.mode == "void" then return end

    if A.face_room == N.room then
      Junction_make_empty(junc)
      return
    end

    Junction_make_fence(junc)
  end


  local function do_junctions()
    each _,junc in LEVEL.area_junctions do
      if junc.E1 == nil then
        do_pool_junction(junc)
      end
    end
  end


  ---| Layout_liquid_stuff |---

  if LEVEL.liquid_usage == 0 then return end

  each A in LEVEL.areas do
    try_pool_in_area(A)
  end

  merge_pools()

  do_junctions()

--[[
  each A in LEVEL.areas do
  each N in A.neighbors do
    if A.mode == "pool" and N.mode == "pool" then
      try_merge_pools(A, N)
    end
  end
  end

  -- do junctions now (to handle two touching pools)

--]]
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
    local dy = 96

    local brush
    local wall
    
    if dir == 2 then
      brush =
      {
        { m = "light", sky_shadow=LEVEL.sky_shadow }
        { x = S.x1     , y = S.y1      }
        { x = S.x1 - dx, y = S.y1 - dy }
        { x = S.x2 - dx, y = S.y1 - dy }
        { x = S.x2     , y = S.y1 - 16 }
        { x = S.x2     , y = S.y1      }
      }
    elseif dir == 4 then
      brush =
      {
        { m = "light", sky_shadow=LEVEL.sky_shadow }
        { x = S.x1     , y = S.y1      }
        { x = S.x1     , y = S.y2      }
        { x = S.x1 - 16, y = S.y2      }
        { x = S.x1 - dx, y = S.y2 - dy }
        { x = S.x1 - dx, y = S.y1 - dy }
      }
    elseif dir == 1 then
      brush =
      {
        { m = "light", sky_shadow=LEVEL.sky_shadow }
        { x = S.x1     , y = S.y2      }
        { x = S.x1 - dx, y = S.y2 - dy }
        { x = S.x2 - dx, y = S.y1 - dy }
        { x = S.x2     , y = S.y1      }
      }
    elseif dir == 3 then
      brush =
      {
        { m = "light", sky_shadow=LEVEL.sky_shadow }
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

  if LEVEL.sky_shadow < 8 then
    return
  end

  each A in LEVEL.areas do
  each S in A.seeds do
  each dir in geom.ALL_DIRS do
    if need_shadow(S, dir) then
      shadow_from_seed(S, dir)
    end
  end -- A, S, dir
  end
  end
end

