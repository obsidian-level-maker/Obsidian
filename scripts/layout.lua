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

  local function do_exclusions(spot)
    -- FIXME : for closets

    local x1 = spot.mx - 76
    local y1 = spot.my - 76
    local x2 = spot.mx + 76
    local y2 = spot.my + 76

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
      R.guard_spot = spot
    end

    if goal.kind == "START" then
      if not spot.closet then
-- FIXME broken since our "spot" does not have x1/y1/x2/y2 
--        R:add_entry_spot(spot)
      end
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

    --FIXME  do_exclusions(spot)
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

    if not R.guard_spot then
      R.guard_spot = spot
    end
  end


  local function add_item(item)
    local spot = Layout_spot_for_wotsit(R, "ITEM")

    if not spot then return end

    spot.content_item = item

    if not R.guard_spot then
      R.guard_spot = spot
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



-- NOT USED ATM
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



function Layout_decorate_rooms()
  -- 
  -- Decorate the rooms with crates, pillars, etc....
  --
  -- Also handles all the unused closets in a room, turning them
  -- into cages, secret items (etc).
  --

  local function make_cage(A)
    chunk.content_kind = "CAGE"
  end

  local function make_item_or_secret(A)
    chunk.content_kind = "NICE_ITEM"
  end


  local function kill_closet(chunk)
    chunk.area.mode = "void"
    chunk.content_kind = "void"
  end


  local function visit_room_KK(R)
    -- FIXME : traps, cages, etc !!!!

    each chunk in R.closets do
      if not chunk.closet_kind then
        make_item_or_secret(A)
      end
    end
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


  local function visit_room(R)
    try_intraroom_lock(R)
    try_intraroom_lock(R)

    -- kill any unused closets
    each CL in R.closets do
      if not CL.content_kind then
        kill_closet(CL)
      end
    end
  end


  ---| Layout_decorate_rooms |---

  -- TODO : handle unused closets

  each R in LEVEL.rooms do
    visit_room(R)
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

        if A.zone != N.zone then continue end

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
          Junction_make_empty(junc)
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
      Junction_make_empty(junc)
      return
    end

    -- handle pool <--> pool

    if N.mode == "pool" then
      if N.pool_id == A.pool_id then
        Junction_make_empty(junc)
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
        Junction_make_empty(junc)
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

