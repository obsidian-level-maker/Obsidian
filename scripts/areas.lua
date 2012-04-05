----------------------------------------------------------------
--  AREAS Within Rooms
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2010-2012 Andrew Apted
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
----------------------------------------------------------------

--[[ *** CLASS INFORMATION ***

class AREA
{
  kind : keyword

  id : number   -- identifier (for debugging)

  room : ROOM

  chunks : list(CHUNK)

  floor_map : CAVE  -- in cave rooms, this is the shape of the floor

  size : number of seeds occupied

  touching : list(AREA)

  floor_h  -- floor height

  target_h  -- if present, get as close to this height as possible
}


--------------------------------------------------------------]]


AREA_CLASS = {}

function AREA_CLASS.new(kind, room)
  local A = { kind=kind, id=Plan_alloc_id("area"), room=room, chunks={} }
  table.set_class(A, AREA_CLASS)
  return A
end


function AREA_CLASS.tostr(A)
  return string.format("AREA_%d", A.id)
end


function AREA_CLASS.add_chunk(A, C)
  C.area = A

  table.insert(A.chunks, C)
end


function AREA_CLASS.touches(A, A2)
  each N in A.touching do
    if A2 == N then return true end
  end

  return false
end


function AREA_CLASS.add_touching(A, N)
  table.add_unique(A.touching, N)
end


function AREA_CLASS.set_floor(A, floor_h)
  A.floor_h = floor_h

  each C in A.chunks do
    C.floor_h = floor_h
  end
end


function AREA_CLASS.shrink_bbox_for_room_edges(A, x1, y1, x2, y2)
  local R = assert(A.room)

  local rx1 = SEEDS[R.sx1][R.sy1].x1 + 40
  local ry1 = SEEDS[R.sx1][R.sy1].y1 + 40
  local rx2 = SEEDS[R.sx2][R.sy2].x2 - 40
  local ry2 = SEEDS[R.sx2][R.sy2].y2 - 40

  if x1 < rx1 then x1 = rx1 end
  if y1 < ry1 then y1 = ry1 end
  if x2 > rx2 then x2 = rx2 end
  if y2 > ry2 then y2 = ry2 end

  return x1,y1, x2,y2
end


function AREA_CLASS.chunk_bbox(A)
  local x1, y1 =  9e9,  9e9
  local x2, y2 = -9e9, -9e9

  each C in A.chunks do
    x1 = math.min(x1, C.x1)
    y1 = math.min(y1, C.y1)
    x2 = math.max(x2, C.x2)
    y2 = math.max(y2, C.y2)
  end

  assert(x1 < x2)
  assert(y1 < y2)

  return A:shrink_bbox_for_room_edges(x1,y1, x2,y2)
end


function AREA_CLASS.grab_spots(A)
  local L = A.room

  local item_spots = {}

  gui.spots_get_items(item_spots)


  -- mark exclusion zones (e.g. area around a teleporter)
  -- do it _after_ getting the item spots

  if L.exclusion_zones then
    each zone in L.exclusion_zones do
      local poly = Brush_new_quad(zone.x1, zone.y1, zone.x2, zone.y2)
      gui.spots_fill_poly(poly, 2)
    end
  end

--  gui.spots_dump("Spot grid")


  local mon_spots  = {}

  gui.spots_get_mons(mon_spots)


  if table.empty(item_spots) and mon_spots[1] then
    table.insert(item_spots, mon_spots[1])
  end

  -- add to room, set Z positions

  each spot in item_spots do
    spot.z1 = A.floor_h
    spot.z2 = A.ceil_h or (spot.z1 + 64)

    table.insert(L.item_spots, spot)
  end

  each spot in mon_spots do
    spot.z1 = A.floor_h
    spot.z2 = A.ceil_h  or (spot.z1 + 200)  -- FIXME

    table.insert(L.mon_spots, spot)
  end
end


function AREA_CLASS.determine_spots(A)
      
  local L = A.room

  -- Spot stuff : begin with "clear" rectangle (contents = 0).
  --              walls and high barriers get removed (contents = 1)
  --              as well as other unusable places (contents = 2).

  local x1, y1, x2, y2 = A:chunk_bbox()

  -- little bit of padding for extra safety
  gui.spots_begin(x1+4, y1+4, x2-4, y2-4, 2)


  each C in A.chunks do
    local poly = Brush_new_quad(C.x1, C.y1, C.x2, C.y2)

    if C.content.kind or C.stair or C.liquid then
      continue
    end

    gui.spots_fill_poly(poly, 0)

    for dir = 2,8,2 do
      local edge_k = C:classify_edge(dir)

      if edge_k == "same" then continue end

      local fill_k = (edge_k == "wall" or edge_k == "liquid" ? 1 ; 2)

      gui.spots_fill_poly(C:quad_for_edge(dir, 16), fill_k)
    end
  end


--[[
    -- TODO solidify brushes from prefabs (including WALLS !!!)
    for _,fab in ipairs(R.prefabs) do
      remove_prefab(fab)
    end

    -- TODO remove solid decor entities
    for _,dec in ipairs(R.decor) do
      remove_decor(dec)
    end
--]]


  A:grab_spots()

  gui.spots_end()
end


----------------------------------------------------------------


function Areas_handle_connections()

  -- this creates the connection chunks in each room and hallway
  -- where it connects to another room or hallway, and sets up the
  -- link[] entries in the chunks.

  local function chunk_for_double(K, dir, sx, sy)
    local sx1, sy1 = K.sx1, K.sy1
    local sx2, sy2 = K.sx2, K.sy2

    if geom.is_vert(dir) then
      sx1 = sx ; sx2 = sx
    else
      sy1 = sy ; sy2 = sy
    end

    local R = K.room

    assert(R:can_alloc_chunk(sx1,sy1, sx2,sy2))

    return R:alloc_chunk(sx1,sy1, sx2,sy2)
  end


  local function chunk_for_crossover(H, K)
    local R = K.room

    assert(R:can_alloc_chunk(K.sx1, K.sy1, K.sx2, K.sy2))
    
    C = R:alloc_chunk(K.sx1, K.sy1, K.sx2, K.sy2)

    C.foobage = "crossover"
    C.crossover_hall = H
    C.section = K

    if K.orig_kind == "junction" then
      C.cross_junc = true
    end

    return C
  end


  local function chunk_for_section_side(K, dir, other_K, is_double)
    -- sections are guaranteed to stay aligned, so calling this
    -- function on two touching sections will provide two chunks
    -- which touch each other.

    -- result chunk normally occupies a single seed.  Enlarging the
    -- chunk (to make wider doors etc) can be done after all the
    -- connections and importants have been given chunks.

    local sx1, sy1
    local sx2, sy2

    if geom.is_vert(dir) then
      sx1 = math.i_mid(K.sx1, K.sx2)
      sy1 = (dir == 2 ? K.sy1 ; K.sy2)
    else
      sy1 = math.i_mid(K.sy1, K.sy2)
      sx1 = (dir == 4 ? K.sx1 ; K.sx2)
    end

    sx2 = sx1
    sy2 = sy1

    -- when there are four (or more) seeds, use the middle two
    if not is_double then
      if geom.is_vert(dir)  and K.sw >= 4 then sx2 = sx1 + 1 end
      if geom.is_horiz(dir) and K.sh >= 4 then sy2 = sy1 + 1 end
    end

    -- when connecting to junctions, use the same size as the junction
    if other_K.kind == "junction" then
      if geom.is_vert(dir) then
        sx1, sx2 = other_K.sx1, other_K.sx2
      else
        sy1, sy2 = other_K.sy1, other_K.sy2
      end
    end

    -- if chunk already exists, use it
    local S = SEEDS[sx1][sy1]
    local C = S.chunk

    if not C then
      if K.hall then
        -- junctions become a single chunk
        if K.kind == "junction" then
          sx1, sy1, sx2, sy2 = K.sx1, K.sy1, K.sx2, K.sy2

        -- a hallway chunk must be as _deep_ as the hallway channel
        -- [but only when connecting to a room]
        elseif other_K.room then
          if K.sw >= 2 and dir == 4 then sx2 = K.sx2 end
          if K.sw >= 2 and dir == 6 then sx1 = K.sx1 end

          if K.sh >= 2 and dir == 2 then sy2 = K.sy2 end
          if K.sh >= 2 and dir == 8 then sy1 = K.sy1 end
        end

        C = K.hall:alloc_chunk(K, sx1, sy1, sx2, sy2)

      -- closet
      elseif K.closet then
        local long, deep = K:long_deep(dir)

        if deep >= 2 then
          if dir == 2 then sy2 = sy2 + 1 end
          if dir == 8 then sy1 = sy1 - 1 end
          if dir == 4 then sx2 = sx2 + 1 end
          if dir == 6 then sx1 = sx1 - 1 end
        end

        C = CHUNK_CLASS.new(sx1, sy1, sx2, sy2)

        C:install()

        C.closet = K.closet
        C.closet.chunk = C

      -- double hall chunk
      elseif K.room and is_double then
        C = chunk_for_double(K, dir, sx1, sy1)

      else
        C = K.room:alloc_chunk(sx1, sy1, sx2, sy2)
      end

      if not K.closet then
        C.foobage = "conn"
      end

      S.chunk = C  -- FIXME: REVIEW THIS (C:install does it, no?)
    end

    return C
  end


  local function link_chunks(C1, dir, C2, conn)
    assert(C1)
    assert(C2)

    -- prefer to build door on the room side
    if (C1.hall and C2.room) or
       (C1.room and C1.room.street)
    then
      C1, C2 = C2, C1
      dir = 10 - dir
    end

    gui.debugf("link_chunks: %s --> %s\n", C1:tostr(), C2:tostr())

    local LINK =
    {
      C1 = C1
      C2 = C2
      dir = dir
      conn = conn
    }

    if geom.is_vert(dir) then
      local x1 = math.max(C1.x1, C2.x1)
      local x2 = math.min(C1.x2, C2.x2)

      LINK.x1 = x1 + 16
      LINK.x2 = x2 - 16
    else
      local y1 = math.max(C1.y1, C2.y1)
      local y2 = math.min(C1.y2, C2.y2)

      LINK.y1 = y1 + 16
      LINK.y2 = y2 - 16
    end

    C1.link[dir]      = LINK
    C2.link[10 - dir] = LINK
  end


  local function need_adjuster(C1, C2)
    assert(C1.hall)

    if C1.hall.is_cycle then return true end

    if C1.hall.crossover then return true end

    if C2.room and C2.room.crossover_hall then return true end

    return false
  end


  local function handle_conn(D)
    assert(D.K1 and D.dir1)
    assert(D.K2 and D.dir2)

    local is_double = (D.kind == "double_L" or D.kind == "double_R")

    local C1 = chunk_for_section_side(D.K1, D.dir1, D.K2, is_double)
    local C2 = chunk_for_section_side(D.K2, D.dir2, D.K1, is_double)

    D.C1 = C1 ; D.C2 = C2

    link_chunks(C1, D.dir1, C2, D)

    if C1.hall and need_adjuster(C1, C2) then
      C1.adjuster_dir = D.dir1
    elseif C2.hall and need_adjuster(C2, C1) then
      C2.adjuster_dir = D.dir2
    end
  end


  local function handle_crossover(H)
    -- create the chunks in the room for the bridge / channel
    each K in H.sections do
      if K.room then
        chunk_for_crossover(H, K)
      end
    end

    -- link these chunks with the hallway outside of the room
    each K1 in H.sections do
      if not K1.room then continue end

      each dir,_ in K1.hall_link do
        local K2 = K1:neighbor(dir)

        if not K2.hall then continue end

        local C1 = chunk_for_section_side(K1,    dir, K2, false)
        local C2 = chunk_for_section_side(K2, 10-dir, K1, false)

        link_chunks(C1, dir, C2, nil)
      end
    end
  end


  ---| Areas_handle_connections |---

  each D in LEVEL.conns do
    -- teleporters are done elsewhere (as an "important")
    if D.kind != "teleporter" then
      handle_conn(D)

      assert(D.C1)
      assert(D.C2)
    end
  end

  each H in LEVEL.halls do
    if H.crossover then
      handle_crossover(H)
    end
  end

end


----------------------------------------------------------------


function Areas_important_stuff()

  -- this places the "important" stuff (keys, switches, teleporters)
  -- into the rooms.  It also creates a path between all the connection
  -- chunks and important chunks (the main point of that path is so we
  -- know which parts of the room can be used for non-walkable stuff
  -- like liquids, thick walls, cages etc).

  local function init_seed(R, S)
    for dir = 2,4,2 do
      local N = S:neighbor(dir)

      if not S:same_room(dir) then continue end

      -- cannot use crossover junctions as part of path
      if S.chunk and S.chunk.cross_junc then continue end
      if N.chunk and N.chunk.cross_junc then continue end

      local cost = 2 ^ rand.range(1, 5)

      -- avoid junctions  [FIXME: only avoid ones in middle of room]
      if S.section.orig_kind == "junction" then cost = 500 end
      if N.section.orig_kind == "junction" then cost = 500 end

      S.cost[dir]    = cost
      N.cost[10-dir] = cost
    end

    -- mark seeds which are near a wall
    for dir = 2,8,2 do
      if not S:same_room(dir) then
        S.near_wall = (S.near_wall or 0) + 1
      end
    end
  end


  local function init_room(R)
    for sx = R.sx1,R.sx2 do for sy = R.sy1,R.sy2 do
      local S = SEEDS[sx][sy]
      if S.room == R then
        init_seed(R, S)
      end
    end end
  end


  local function update_distances(R)
    -- in each unallocated seed in a room, compute the distance to
    -- the nearest allocated seed, and distance from a wall.
    
    -- Note: with teleporters it is possible that none of the seeds
    -- gets a 'chunk_dist' value.

    local function init_dists()
      for sx = R.sx1,R.sx2 do for sy = R.sy1,R.sy2 do
        local S = SEEDS[sx][sy]
        if S.room == R then
          
          -- ignore certain chunks [crossovers]
          if S.chunk and not S.chunk.crossover_hall then
            S.chunk_dist = 0
          else
            S.chunk_dist = nil
          end

          if S.near_wall then
            S.wall_dist = 0
          else
            S.wall_dist = nil
          end
        
          S.dist_random = gui.random()
        end
      end end
    end

    local function spread_dists()
      local changed = false

      for sx = R.sx1,R.sx2 do for sy = R.sy1,R.sy2 do
        local S = SEEDS[sx][sy]
        if S.room == R then

          for dir = 2,8,2 do
            if S:same_room(dir) then
              local N = S:neighbor(dir)

              if S.chunk_dist and S.chunk_dist + 1 < (N.chunk_dist or 999) then
                N.chunk_dist = S.chunk_dist + 1
                changed  = true
              end

              if S.wall_dist and S.wall_dist + 1 < (N.wall_dist or 999) then
                N.wall_dist = S.wall_dist + 1
                changed  = true
              end
            end
          end
        end
      end end

      return changed
    end

    init_dists()

    while spread_dists() do end
  end


  local function spot_for_wotsit(R)
    update_distances(R)

    local spot
    local best_dist = -9e9

    -- in caves we want the spot to be away from the edges of the room
    local wall_factor = (R.kind == "cave" or rand.odds(5) ? 15.2 ; 2.15)

    for sx = R.sx1, R.sx2 do for sy = R.sy1, R.sy2 do
      local S = SEEDS[sx][sy]

      if S.room == R and not S.chunk then
        local dist = (S.chunk_dist or 0) * 7 + (S.wall_dist or 0) * wall_factor + S.dist_random

        if dist > best_dist then
          spot = S
          best_dist = dist
        end
      end
    end end

    -- FIXME !!!! try to use an existing chunk
    if not spot then error("NO SPOT FOR WOTSIT") end

    -- create chunk

    local C = R:alloc_chunk(spot.sx, spot.sy, spot.sx, spot.sy)

    C.foobage = "important"

    return C
  end


  local function add_purpose(R)
    if R.purpose == "START" and R.has_start_closet then return end
    if R.purpose == "EXIT"  and R.has_exit_closet  then return end

    local C = spot_for_wotsit(R)

    C.content.kind = R.purpose

    if R.purpose == "SOLUTION" then
      local lock = assert(R.purpose_lock)

      C.content.lock = lock

      if lock.kind == "KEY" or lock.kind == "SWITCH" then
        C.content.kind = lock.kind
      else
        error("UNKNOWN LOCK KIND")
      end

      if lock.kind == "KEY" then
        C.content.key = assert(lock.key)
      end
    end

    --- Hexen stuff ---

    -- NOTE: arg1 of the player things is used to select which spot
    --       the hub gate takes you to.  We set it to the local_map
    --       number of the OTHER map.

    if R.purpose == "EXIT" and LEVEL.hub_key then
      -- goal of branch level is just a key
      C.content.kind = "KEY"
      C.content.key  = LEVEL.hub_key
    
    elseif R.purpose == "EXIT" and LEVEL.hub_links then
      -- goal of chain levels is gate to next level
      local chain_link

      each link in LEVEL.hub_links do
        if link.src.name == LEVEL.name then
          chain_link = link ; break
        end
      end

      if chain_link and chain_link.kind == "chain" then
        C.content.kind = "GATE"
        C.content.source_id = chain_link.dest.local_map
        C.content.dest_id   = chain_link.src .local_map
        C.content.dest_map  = chain_link.dest.map
      end
    end

    if R.purpose == "START" and LEVEL.hub_links then
      -- beginning of each level (except start) is a hub gate
      local from_link

      each link in LEVEL.hub_links do
        if link.dest.name == LEVEL.name then
          from_link = link ; break
        end
      end

      if from_link then
        C.content.kind = "GATE"
        C.content.source_id = from_link.src .local_map
        C.content.dest_id   = from_link.dest.local_map
        C.content.dest_map  = from_link.src .map
      end
    end
  end


  local function add_weapon(R, weapon)
    local C = spot_for_wotsit(R)

    C.content.kind = "WEAPON"
    C.content.weapon = weapon
  end


  local function add_teleporter(R)
    if R.has_teleporter_closet then return end

    local conn = R:get_teleport_conn()
    
    local C = spot_for_wotsit(R)

    C.content.kind = "TELEPORTER"
    C.content.teleporter = conn  -- FIXME?

        if conn.L1 == R then conn.C1 = C
    elseif conn.L2 == R then conn.C2 = C
    else   error("add_teleporter failure (bad conn?)")
    end
  end


  local function add_hub_gate(R, link)
    assert(link)

    -- FIXME
    if link.dest.kind == "SECRET" then
      gui.debugf("Skipping hub gate to secret level\n")
      return
    end

    local C = spot_for_wotsit(R)
    
    C.content.kind = "GATE"
    C.content.source_id = link.dest.local_map
    C.content.dest_id   = link.src .local_map
    C.content.dest_map  = link.dest.map
  end


  local function place_importants(R)
    if R.purpose then add_purpose(R) end

    if R:has_teleporter() then add_teleporter(R) end

    if R.weapons then
      each name in R.weapons do add_weapon(R, name) end
    end

    each link in R.gates do add_hub_gate(R, link) end
  end


  local function extra_stuff(R)

    -- this function is meant to ensure good traversibility in a room.
    -- e.g. put a nice item in sections without any connections or
    -- importants, or if the exit is close to the entrance then make
    -- the exit door require a far-away switch to open it.

    -- TODO
  end


  local function path_scorer(x, y, dir, data)
    local R = data

    local sx = R.sx1 + x - 1
    local sy = R.sy1 + y - 1

    local S = SEEDS[sx][sy]

    assert(S.room == R)

    -- must stay within the room
    if not S.cost[dir] then return -1 end

    return S.cost[dir]
  end


  local function create_a_path(R, C1, C2)
gui.debugf("create_a_path: %s : %s --> %s\n", R:tostr(), C1:tostr(), C2:tostr())

    -- pick start and ending seeds
    local sx = (C2.sx1 > C1.sx1 ? C1.sx2 ; C1.sx1)
    local sy = (C2.sy1 > C1.sy1 ? C1.sy2 ; C1.sy1)

    local ex = (C1.sx1 > C2.sx1 ? C2.sx2 ; C2.sx1)
    local ey = (C1.sy1 > C2.sy1 ? C2.sy2 ; C2.sy1)

    -- coordinates must be relative for A* algorithm
    sx, sy = (sx - R.sx1) + 1, (sy - R.sy1) + 1
    ex, ey = (ex - R.sx1) + 1, (ey - R.sy1) + 1

gui.debugf("  seeds: (%d %d) --> (%d %d)\n", sx, sy, ex, ey)
    local path = a_star.find_path(sx, sy, ex, ey, R.sw, R.sh, path_scorer, R)

    if not path then
      error("NO PATH INSIDE ROOM!\n")
    end

    -- mark the seeds as "walk"
    each pos in path do
      local sx = R.sx1 + (pos.x - 1)
      local sy = R.sy1 + (pos.y - 1)

      local S = SEEDS[sx][sy]
      assert(S.room == R)

      S.is_walk = true

--[[  -- DEBUGGING AID --
      local mx, my = S:mid_point()
      entity_helper("potion", mx, my, 32)
--]]
    end

    local last = table.last(path)
    local lx, ly = geom.nudge(last.x, last.y, last.dir)
    local sx = R.sx1 + lx - 1
    local sy = R.sy1 + ly - 1
    local S = SEEDS[sx][sy]

    assert(S.room == R)

    S.is_walk = true
  end


  local function make_paths(R)
    -- collect chunks which the player must be able to get to
    local list = {}

    each C in R.chunks do
      if C.cross_junc then continue end

      if C.foobage == "conn" or C.foobage == "important" or
         C.foobage == "crossover" or C.content.kind
      then
        table.insert(list, C)

        -- mark this chunk as walk
        for sx = C.sx1, C.sx2 do for sy = C.sy1, C.sy2 do
          SEEDS[sx][sy].is_walk = true
        end end
      end
    end

    -- pick two chunks in the list and "connect" them with a
    -- guaranteed path through the room.  Repeat until all the
    -- chunks are connected.
    while #list > 1 do
      rand.shuffle(list)

      local C1 = list[1]
      local C2 = list[2]

      table.remove(list, 1)

      create_a_path(R, C1, C2)
    end
  end


  local function visit_room(R)
    init_room(R)
    place_importants(R)
    extra_stuff(R)
    make_paths(R)
  end


  ---| Areas_important_stuff |---

  each R in LEVEL.rooms do
    visit_room(R)
  end
end


----------------------------------------------------------------


function Areas_dump_vhr(R)

  local function check_vhr(v)
    for y = R.sy2, R.sy1, -1 do
      for x = R.sx1, R.sx2 do
        local S = SEEDS[x][y]

        if S.room == R and S.v_areas[v] then
          return true
        end
      end
    end

    return false
  end


  local function dump_vhr(v)
    for y = R.sy2, R.sy1, -1 do
      local line = "  "

      for x = R.sx1, R.sx2 do
        local S = SEEDS[x][y]

        if S.room != R then
          line = line .. " "
        elseif S.v_areas[v] then
          line = line .. v
        elseif S.void then
          line = line .. "#"
        else
          line = line .. "."
        end
      end

      gui.debugf("%s\n", line)
    end

    gui.debugf("\n");
  end


  ---| Areas_dump_vhr |---

  gui.debugf("Virtual Areas in %s\n", R:tostr())

  for v = 9,1,-1 do
    if check_vhr(v) then
      dump_vhr(v)
    end
  end
end


function Areas_assign_chunks_to_vhrs(R)
  -- logic here is to try to place one chunk in the lowest area, and
  -- one chunk in the highest area, and the remaining chunks in the
  -- least used virtual areas.

  local occupied_vhrs = {}

  local low_chunks  = {}
  local high_chunks = {}

  each C in R.chunks do
    local S = SEEDS[C.sx1][C.sy1]

    -- if only one choice, use it
    if table.size(S.v_areas) == 1 then
      local v, AREA = next(S.v_areas)
      AREA:add_chunk(C)
      occupied_vhrs[v] = (occupied_vhrs[v] or 0) + 1
      continue
    end

    if S.v_areas[R.vhr1] then table.insert( low_chunks, C) end
    if S.v_areas[R.vhr2] then table.insert(high_chunks, C) end
  end

  -- we need to handle case like: low = { X Y }  high = { X }
  -- hence we handle the shortest table first.

  for pass = 1,2 do
    local C, v

    if (pass == 1) == (#low_chunks < #high_chunks) then

      -- LOW
      if not occupied_vhrs[R.vhr1] and #low_chunks > 0 then
        C = rand.pick(low_chunks)
        v = R.vhr1
      end
    
    else

      -- HIGH
      if not occupied_vhrs[R.vhr2] and #high_chunks > 0 then
        C = rand.pick(high_chunks)
        v = R.vhr2
      end
    end

    if C then
      local S = SEEDS[C.sx1][C.sy1]
      local AR = assert(S.v_areas[v])

      AR:add_chunk(C)

      occupied_vhrs[v] = (occupied_vhrs[v] or 0) + 1

      table.kill_elem( low_chunks, C)
      table.kill_elem(high_chunks, C)
    end
  end

  -- assign all other chunks  [TODO: take area size into account]

  each C in R.chunks do
    if C.area then continue end

    local S = SEEDS[C.sx1][C.sy1]

    -- filter probabilities based on areas that chunk may exist in
    local tab2 = {}

    for v = 1,9 do
      if S.v_areas[v] then
        tab2[v] = (occupied_vhrs[v] ? 10 ; 80)
      end
    end

    assert(not table.empty(tab2))

    local v = rand.key_by_probs(tab2)
    local AR = assert(S.v_areas[v])

    AR:add_chunk(C)

    occupied_vhrs[v] = (occupied_vhrs[v] or 0) + 1
  end
end



function Areas_create_all_areas(R)

  local min_size = 2 + R.map_volume * 2
  local max_size = int(R.svolume * 0.7)

  local total_seeds = 0
  local  used_seeds = 0

  local used_vhrs = {}

  local area = table.array_2D(R.sx2, R.sy2)
  local area_size


  local VHR_DECAY = { 10,10,10, 4,4,4, 10,10,10 }

  local function pick_vhr(tab)
    each v,usage in used_vhrs do
      if tab[v] then
--      tab[v] = tab[v] / (VHR_DECAY[v] ^ usage)
      end
    end

    return rand.index_by_probs(tab)
  end


  local function init()
    for sx = R.sx1, R.sx2 do for sy = R.sy1, R.sy2 do
      local S = SEEDS[sx][sy]
      if S.room == R then
        total_seeds = total_seeds + 1
      end
    end end
  end

  
  local function clear()
    for x = R.sx1, R.sx2 do
      if not table.empty(area[x]) then
        area[x] = {}
      end
    end

    area_size = 0
  end


  local function install(v)
    used_vhrs[v] = (used_vhrs[v] or 0) + 1

    -- create a new area object here
    local AREA = AREA_CLASS.new("floor", R)

    AREA.vhr = v
    AREA.size = area_size
    AREA.touching = {}     -- FIXME: never updated

    table.insert(R.areas, AREA)

    for x = R.sx1, R.sx2 do for y = R.sy1, R.sy2 do
      if area[x][y] then
        local S = SEEDS[x][y]
        assert(S.room == R)
        assert(not S.void)

        if table.empty(S.v_areas) then
          used_seeds = used_seeds + 1
        end

        assert(not S.v_areas[v])
        S.v_areas[v] = AREA
      end
    end end
  end


  local function test(x, y, v)
assert(Seed_valid(x, y))
    local sx1, sy1 = x, y
    local sx2, sy2 = x, y

    -- must expand range to whole chunk if present
    local C = SEEDS[x][y].chunk

    if C then
      sx1, sy1 = C.sx1, C.sy1
      sx2, sy2 = C.sx2, C.sy2
    end

    for nx = sx1,sx2 do for ny = sy1,sy2 do
      if not SEEDS[nx][ny]:can_add_vhr(R, v) then
        return false
      end
    end end

    return true
  end


  local function set(x, y)
    local sx1, sy1 = x, y
    local sx2, sy2 = x, y

    -- must expand range to whole chunk if present
    local C = SEEDS[x][y].chunk

    if C then
      sx1, sy1 = C.sx1, C.sy1
      sx2, sy2 = C.sx2, C.sy2
    end

    for nx = sx1,sx2 do for ny = sy1,sy2 do
      if not area[nx][ny] then
        area[nx][ny] = true
        area_size = area_size + 1
      end
    end end
  end


  local function test_box(x1, y1, x2, y2, v)
    for x = x1,x2 do for y = y1,y2 do
      if not test(x, y, v) then return false end
    end end

    return true
  end


  local function set_box(x1, y1, x2, y2)
    for x = x1,x2 do for y = y1,y2 do
      set(x, y)
    end end
  end


  local function test_box_no_edge(x1, y1, x2, y2, v)
    for x = x1,x2 do for y = y1,y2 do
      if SEEDS[x][y].room != R then return false end
      if SEEDS[x][y]:edge_of_room() then return false end
      if not test(x, y, v) then return false end
    end end

    return true
  end


  local function try_MIDDLE(junc, v)
    -- initial size
    local sx1, sy1 = junc.sx1, junc.sy1
    local sx2, sy2 = junc.sx2, junc.sy2

    if not test_box(sx1, sy1, sx2, sy2) then return end

    clear()

    set_box(sx1, sy1, sx2, sy2)

    -- try growing it  [FIXME: try each direction individually]
    for loop = 1,2 do
      sx1 = sx1 - 1 ; sx2 = sx2 + 1
      sy1 = sy1 - 1 ; sy2 = sy2 + 1

      local new_vol = (sx2 - sx1 + 1) * (sy2 - sy1 + 1)

      if new_vol > max_size then break end

      if test_box_no_edge(sx1, sy1, sx2, sy2) then
        set_box(sx1, sy1, sx2, sy2)
      end
    end

    if area_size < min_size then
      return
    end

    stderrf("try_MIDDLE @ v=%d size=%d\n", v, area_size)

    install(v)

    -- TODO: try to surround this one
  end


  local function try_CORNER(corner, v)
  end


  local function try_EDGE(side, v)
  end


  local function try_TWO_SIDE(corner, v, extend)
    local L_side = geom. LEFT_45[side]
    local R_side = geom.RIGHT_45[side]
  end


  local function try_THREE_SIDE(side, v, extend)
    local L_side = geom. LEFT[side]
    local R_side = geom.RIGHT[side]
  end


  local function random_spread_in_dir(bbox, dir, prob, v)
    -- returns FALSE only if nothing was possible
    local possible = false

    local x1, x2, xdir = bbox.x1, bbox.x2, 1
    local y1, y2, ydir = bbox.y1, bbox.y2, 1

    -- prevent run-on
    if dir == 6 then x1, x2 = x2, x1 ; xdir = -1 end
    if dir == 8 then y1, y2 = y2, y1 ; ydir = -1 end

    for y = y1, y2, ydir do
      for x = x1, x2, xdir do
        local S = SEEDS[x][y]
        if S.room != R then continue end

        if not area[x][y] then continue end

        local N = S:neighbor(dir)
        if not N or N.room != R then continue end

        local nx, ny = N.sx, N.sy

        if area[nx][ny] then continue end

        if not test(nx, ny, v) then continue end

        possible = true

        if rand.odds(prob) then
          set(nx, ny)

          -- update bbox!
          if nx < bbox.x1 then bbox.x1 = nx end
          if nx > bbox.x2 then bbox.x2 = nx end

          if ny < bbox.y1 then bbox.y1 = ny end
          if ny > bbox.y2 then bbox.y2 = ny end
        end
      end
    end

    return possible
  end


  local function random_spread(bbox, v)
    each dir in rand.dir_list() do
      if random_spread_in_dir(bbox, dir, 35, v) then
        return true
      end
    end

    return false
  end


  local function try_RANDOM(v)
stderrf("try_RANDOM begin, v=%d\n", v)
    if used_seeds >= total_seeds then return end

    local unused_seeds = {}

    for x = R.sx1, R.sx2 do for y = R.sy1, R.sy2 do
      local S = SEEDS[x][y]
      if S.room == R and table.empty(S.v_areas) then
        table.insert(unused_seeds, S)
      end
    end end

    assert(#unused_seeds == total_seeds - used_seeds)

    local first
    
    for loop = 1,10 do
      first = rand.pick(unused_seeds)

stderrf("  loop: %d  test(%d %d)\n", loop, first.sx, first.sy)
      if test(first.sx, first.sy, v) then break end

      first = nil
    end

    if not first then return end

stderrf("  first = %s\n", first:tostr())
    clear()

    local x = first.sx
    local y = first.sy

    set(x, y)

    local bbox = { x1=x, y1=y, x2=x, y2=y }

    while area_size < min_size do
      -- abort if cannot reach the minimum size
      if not random_spread(bbox, v) then return end
    end

    while rand.odds(80) and area_size < max_size * 0.8 do
      random_spread(bbox, v)
    end

    stderrf("try_RANDOM @ v=%d size=%d\n", v, area_size)

    install(v)
  end


  local function merge_areas(new_AR, old_AR)
stderrf("merge_areas %s --> %s\n", new_AR:tostr(), old_AR:tostr())
    local v = new_AR.vhr
    assert(v == old_AR.vhr)

    new_AR.size = new_AR.size + old_AR.size
    old_AR.size = 0

    table.kill_elem(R.areas, old_AR)

    each C in old_AR.chunks do
      assert(C.area == old_AR)
      C.area = new_AR
      table.insert(new_AR.chunks, C)
    end

    for x = R.sx1, R.sx2 do for y = R.sy1, R.sy2 do
      local S = SEEDS[x][y]
      if S.room == R and S.v_areas and S.v_areas[v] == old_AR then
        S.v_areas[v] = new_AR
      end
    end end

    old_AR.chunks = nil
  end


  local function try_grow_from_neighbors(S)
    -- collect possible areas
    local poss_areas = {}

    for dir = 2,8,2 do
      local N = S:neighbor(dir)
      if N and N.room == R and not N.void and not table.empty(N.v_areas) then
        each v,AREA in N.v_areas do
          table.add_unique(poss_areas, AREA)
        end
      end
    end

    if table.empty(poss_areas) then return false end

    -- if more than one possibility, try to pick one that does not require a merge
    if #poss_areas >= 2 then
      local poss2 = {}

      each AR in poss_areas do
        if test(S.sx, S.sy, AR.vhr) then
          table.insert(poss2, AR)
        end
      end

      if #poss2 > 0 then
        poss_areas = poss2
      end
    end

    assert(#poss_areas > 0)

    -- install the area in the seed/s
    local AREA = rand.pick(poss_areas)
    local v    = AREA.vhr

    local sx1, sy1 = S.sx, S.sy
    local sx2, sy2 = S.sx, S.sy

    -- must expand range to whole chunk if present
    local C = S.chunk

    if C then
      sx1, sy1 = C.sx1, C.sy1
      sx2, sy2 = C.sx2, C.sy2
    end

    for x = sx1,sx2 do for y = sy1,sy2 do
      local S2 = SEEDS[x][y]
      assert(table.empty(S2.v_areas))
      used_seeds = used_seeds + 1
      S2.v_areas[v] = AREA

      -- may need to merge areas
      for dir = 2,8,2 do
        local N2 = S:neighbor(dir)
        if N2 and N2.room == R and not N2.void and 
           N2.v_areas[v] and N2.v_areas[v] != AREA
        then
          merge_areas(AREA, N2.v_areas[v])
        end
      end
    end end

    return true
  end


  local function grow_the_rest()
    local unused_seeds = {}

    for x = R.sx1, R.sx2 do for y = R.sy1, R.sy2 do
      local S = SEEDS[x][y]
      if S.room == R and table.empty(S.v_areas) and not S.void then
        table.insert(unused_seeds, S)
      end
    end end

-- stderrf("unused:%d == %d - %d\n", #unused_seeds, total_seeds, used_seeds)
    assert(#unused_seeds == total_seeds - used_seeds)

    rand.shuffle(unused_seeds)

    local can_void = true
    if R.kind == "outdoor" then can_void = false end

    each S in unused_seeds do
      if can_void and not S.is_walk and not S.chunk and rand.odds(100) then
        S.void = true
        used_seeds = used_seeds + 1
        continue
      end

      if try_grow_from_neighbors(S) then
        break
      end
    end
  end


  local function remap_vhr(src_v, dest_v)
    gui.debugf("remap_vhr %d --> %d\n", src_v, dest_v)

    assert(not used_vhrs[dest_v])

    used_vhrs[dest_v] = used_vhrs[src_v]
    used_vhrs[ src_v] = nil

    for x = R.sx1, R.sx2 do for y = R.sy1, R.sy2 do
      local S = SEEDS[x][y]
      if S and S.room == R and S.v_areas[src_v] then
        assert(not S.v_areas[dest_v])
        S.v_areas[dest_v] = S.v_areas[src_v]
        S.v_areas[ src_v] = nil
      end
    end end

    each AREA in R.areas do
      if AREA.vhr == src_v then
        AREA.vhr = dest_v
      end
    end
  end


  local function gap_removal()
    -- ensure that the VHR numbers have no gaps (e.g. 3,4,6 --> 3,4,5)
    local mapping = {}

    -- determine lowest and highest VHRs
    local low
    local high

    for v = 1,9 do
      if used_vhrs[v] then
        if not low then low = v end
        high = v
      end
    end

    -- create a mapping where the destination numbers are contiguous
    local cur  = low
    local gaps = 0

    for v = low,high do
      if used_vhrs[v] then
        mapping[v] = cur
        cur = cur + 1
      else
        gaps = gaps + 1
      end
    end

    assert(table.size(used_vhrs) == table.size(mapping))

    if gaps == 0 then return end

    -- apply the mapping
    for v = 1,9 do
      if mapping[v] and mapping[v] != v then
        remap_vhr(v, mapping[v])
      end
    end

    R.vhr1 = mapping[low]
    R.vhr2 = R.vhr1 + table.size(mapping) - 1
  end


  local function VALIDATE()
    for x = R.sx1, R.sx2 do for y = R.sy1, R.sy2 do
      local S = SEEDS[x][y]
      if S.room == R and table.empty(S.v_areas) and not S.void then
        error("failed to create area @ " .. S:tostr())
      end
    end end
  end


  ---| Areas_create_all_areas |----

stderrf("Areas_create_all_areas @ %s : (%d %d) .. (%d %d)\n",
        R:tostr(), R.sx1, R.sy1, R.sx2, R.sy2)

  local SIDES   = { 2,4,6,8 }
  local CORNERS = { 1,3,7,9 }

  init()
 
  each K in R.sections do
    if (K.orig_kind == "junction") and not K:touches_edge() then
      try_MIDDLE(K, pick_vhr { 0,1,3, 7,9,5, 0,0,0})
    end
  end

  for loop = 1,16 do  
    local extend = (loop >= 11)
    local v = pick_vhr { 0,0,0, 3,6,9, 5,1,0 }

    if rand.odds(75) then
      -- nothing
    elseif rand.odds(75) then
      try_TWO_SIDE(rand.dir(), v, extend)
    else
      try_THREE_SIDE(rand.dir(), v, extend)
    end
  end

  for loop = 1,4 do
    if rand.odds(25) then
      try_RANDOM(pick_vhr { 0,0,1, 7,9,7, 1,0,0 })
    end
  end

  for loop = 1,16 do
    local v = pick_vhr { 0,1,5, 9,9,9, 5,1,0 }

    if rand.odds(50) then
      -- nothing
    elseif rand.odds(50) then
      try_CORNER(rand.pick(CORNERS), v)
    else
      try_EDGE(rand.dir(), v)
    end
  end

  for loop = 1, R.map_volume + 2 do
    try_RANDOM(pick_vhr { 0,0,3, 7,9,7, 3,0,0 })
  end

  -- must have created at least one area by now
  if used_seeds == 0 then
    error("failed to create any areas at all")
  end

  --- FINAL PASS : fill gaps by expanding from neighbors ---

  for loop = 1,200 do
    if used_seeds >= total_seeds then break end

    if loop == 200 then
      error("failed to create areas in some seeds")
    end

    grow_the_rest()
  end

  gap_removal()

  R.used_vhrs = used_vhrs

  dump()

  VALIDATE()

  Areas_assign_chunks_to_vhrs(R)
end



function Areas_connect_all_areas(R)
  --
  -- Connects areas via stairs or lifts.
  --

  -- GOALS HERE:
  -- (1) prevent / minimise stairs with a big height difference
  --     [ideally all differences are 1 VHR]
  --
  -- (2) stair has 1 seed before it, 2 after it, e.g.  4 4> <5 5
  --
  -- (3) before and after seeds are not stairs (strong preference)
  --     or importants (medium preference)
  --
  -- (4) stair is far away from any chunks
  --
  -- (5) slight preference for stairs _along_ a wall / void


  -- ALGORITHM: connect smallest area to a neighbor, until all
  --            areas are connected.  Score each stair spot.

  local poss_seeds = {}


  local function init()
    R.stairs = {}

    each AR in R.areas do
      AR.conn_group = _index
    end

    for sx = R.sx1,R.sx2 do for sy = R.sy1,R.sy2 do
      local S = SEEDS[sx][sy]

      if S.room == R and not S.void and not S.chunk then
        table.insert(poss_seeds, S)
      end
    end end
  end


  local function highest_group()
    local g = 0

    each AR in R.areas do
      g = math.max(g, AR.conn_group)
    end

    return g
  end


  local function merge(id1, id2)
    if id1 > id2 then id1,id2 = id2,id1 end

    each AR in R.areas do
      if AR.conn_group == id2 then
        AR.conn_group = id1
      end
    end
  end


  local function score_spot(S, N, dir, A1, A2)
    local N = S:neighbor(dir)

    local v_diff = math.abs(A1.vhr - A2.vhr)

    local score = (10 - v_diff) * 10

    -- TODO : THE OTHER CRITERIA

    -- bit of randomness is a tie-breaker
    return score + gui.random()
  end


  local function make_a_connection()
    local best

    each S in poss_seeds do
      for dir = 2,8,2 do
        local N = S:neighbor(dir)

        if not (N and N.room == R) then continue end
        if N.void then continue end
        if N.stair_info then continue end

        each v1,A1 in S.v_areas do
          each v2,A2 in N.v_areas do
            if v1 == v2 then continue end

            if A1.conn_group == A2.conn_group then continue end

            local score = score_spot(S, N, dir, A1, A2)

--stderrf("score_spot @ %s dir:%d --> %1.2f\n", S:tostr(), dir, score)

            if score >= 0 and (not best or score > best.score) then
              best = { S=S, dir=dir, A1=A1, A2=A2, score=score }
            end
          end
        end

      end
    end

    if not best then return false end

    -- place stair

    local S   = best.S
    local dir = best.dir
    local A1  = best.A1
    local A2  = best.A2

    gui.debugf("Added stair @ %s dir:%d  %s --> %s\n", S:tostr(), dir, A1:tostr(), A2:tostr())

    merge(A1.conn_group, A2.conn_group)

    local N = S:neighbor(dir)

    S.stair_info = best
    N.stair_from = 10 - dir

    table.kill_elem(poss_seeds, S)
    table.kill_elem(poss_seeds, N)

    table.insert(R.stairs, stair_info)

-- TEST
if S.v_areas[A2.vhr] and math.abs(A1.vhr - A2.vhr) == 1 and
   N.v_areas[A1.vhr] and N.v_areas[A2.vhr]
then
  --  for pass = 1,2 do
  --  local dir2 = (pass == 1 ? geom.RIGHT[dir] ; geom.LEFT[dir])
  --  local N = S:neighbor(dir2)
  --  if N and N.room == R and N.v_areas and N.v_areas[A1.vhr] and N.v_areas[A2.vhr] then

  local T = Trans.box_transform(S.x1, S.y1, S.x2, S.y2, math.min(A1.floor_h, A2.floor_h), 10 - dir)
  Fabricate("STAIR_180", T, { R.skin })
  S.wtf_bbq = true
end

    return true
  end


  ---| Areas_connect_all_areas |----

  gui.debugf("Areas_connect_all_areas @ %s\n", R:tostr())

  init()

  while highest_group() > 1 do
    if not make_a_connection() then
      error("unable to connect areas in room!")
    end
  end
end



function Areas_create_with_patterns(R)
  local num_vhr
  local min_vhr
  local max_vhr

  local grid

  local g_total
  local g_used


  local function number_of_areas()
    -- determine maximum # of areas
    num_vhr = int(1 + (R.svolume ^ 0.5) / 2)
    if num_vhr < 1 then num_vhr = 1 end
    if num_vhr > 9 then num_vhr = 9 end

    if R.crossover_hall then
      num_vhr = math.min(num_vhr, 7)
    end

    min_vhr = 5 - int(num_vhr / 2)
    max_vhr = min_vhr + num_vhr - 1
  end


  local function grid_neighbor(G, dir)
    local nx, ny = geom.nudge(G.gx, G.gy, dir)

    if nx < 1 or ny < 1 or nx > grid.w or ny > grid.h then return nil end

    return grid[nx][ny]
  end


  local function grid_for_box(sx1, sy1, sx2, sy2)
    for mx = 1,MAP_W do
      for my = 1,MAP_H do
        local G = grid[mx][my]

        if not G then continue end

        if G.sx1 <= sx1 and sx2 <= G.sx2 and
           G.sy1 <= sy1 and sy2 <= G.sy2
        then
          return G
        end
      end
    end

    return nil  -- stray chunk
  end


  local function verify_grid(G)
    assert(Seed_valid(G.sx1, G.sy1))
    assert(Seed_valid(G.sx2, G.sy2))

stderrf("Grid[%d %d] in %s = (%d %d) .. (%d %d)\n",
        G.gx, G.gy, R:tostr(),  G.sx1, G.sy1, G.sx2, G.sy2)

    for sx = G.sx1, G.sx2 do
      for sy = G.sy1, G.sy2 do
        local S = SEEDS[sx][sy]

        if S.room != R then
          error("grid cell overflowed @ " .. S:tostr())
        end
      end
    end
  end


  local function create_grid()
    -- subdivide room into an MxN grid of areas
    
    grid = table.array_2D(MAP_W, MAP_H)

    g_total = 0
    g_used  = 0

    for mx = 1,MAP_W do for my = 1,MAP_H do
      local K = SECTIONS[mx*2][my*2]

      if K.room != R then continue end

      grid[mx][my] =
      {
        gx = mx ; gy = my

        K = K

        sx1 = K.sx1 ; sy1 = K.sy1
        sx2 = K.sx2 ; sy2 = K.sy2

        chunks = {}
        strays = {}
      }

      g_total = g_total + 1
    end end

    -- close gaps between neighbors (the reclaimed VERT/HORIZ/JUNC sections)

    for mx = 1,MAP_W do for my = 1,MAP_H do
      local G = grid[mx][my]

      if not G then continue end

      for dir = 2,8,2 do
        local N  = grid_neighbor(G, dir)
        local K2 = G.K:neighbor(dir)

        if N and dir == 6 then G.sx2 = N.sx1 - 1 end
        if N and dir == 8 then G.sy2 = N.sy1 - 1 end

        if not N and K2 and K2.room == R then
          if dir == 4 then G.sx1 = K2.sx1 end
          if dir == 6 then G.sx2 = K2.sx2 end

          if dir == 2 then G.sy1 = K2.sy1 end
          if dir == 8 then G.sy2 = K2.sy2 end
        end
      end

      -- determine size
      G.sw, G.sh = geom.group_size(G.sx1, G.sy1, G.sx2, G.sy2)

      verify_grid(G)
    end end

    -- collect chunks
    each C in R.chunks do
      local G = grid_for_box(C.sx1, C.sy1, C.sx2, C.sy2)

      if G then
        table.insert(G.chunks, C)
      else
        --???  FIXME
      end
    end

  end


  local function assign_stray_seeds()
    -- some seeds may not be covered by the grid.
    -- they will be copied from a nearby grid seed.

    -- here we figure out which part of the grid they should copy.

    -- FIXME

    -- NOTE TOO : "stray chunks" are possible, handle it
  end


  local function find_free_spot()
    -- we want a grid spot next to an already used spot

    local best
    local best_score

    for mx = 1,MAP_W do for my = 1,MAP_H do
      local G = grid[mx][my]

      if not G then continue end

      if G.used then continue end

      local score = gui.random()

      for dir = 2,8,2 do
        local N = grid_neighbor(G, dir)

        if N and N.used then
          score = score + 10
          break
        end
      end

      if not best or score > best_score then
        best = G
        best_score = score
      end
    end end
    
    return assert(best)
  end


  local function get_PLAIN_area(G)
    if g_used == 0 then
      local AREA = AREA_CLASS.new("floor", R)

      AREA.vhr = rand.irange(min_vhr, max_vhr)

      AREA.touching = {}     -- FIXME: never updated

      table.insert(R.areas, AREA)

      return AREA
    end

    -- when g_used > 0, this grid spot must be adjacent to already filled stuff

    local areas = {}

    for sx = G.sx1, G.sx2 do
      for sy = G.sy1, G.sy2 do
        local S = SEEDS[sx][sy]

        for dir = 2,8,2 do
          local N = S:neighbor(dir)

          if not (N and N.room == R) then continue end

          if geom.inside_box(N.sx, N.sy, G.sx1,G.sy1, G.sx2,G.sy2) then continue end

          each v,AR in N.v_areas do
            table.add_unique(areas, AR)
          end
        end
      end
    end

    if table.empty(areas) then
Areas_dump_vhr(R)
      error("failed to find any height in grid neighbors")
    end

    -- TODO: pick the least used VHR so far

    local AREA = rand.pick(areas)

    return AREA
  end


  local function install_PLAIN(G)
    local AREA = get_PLAIN_area(G)
    local v = AREA.vhr

    for sx = G.sx1, G.sx2 do
      for sy = G.sy1, G.sy2 do

        local S = SEEDS[sx][sy]
        assert(S.room == R)
        assert(not S.void)
        assert(not S.v_areas[v])

        S.v_areas[v] = AREA
      end
    end
  end


  -------- PATTERN STUFF --------->>


  local function str_size(s)
    local size = 0

    for i = 1,#s do
      local ch = string.sub(s, i, i)
      size = size + (0 + ch)
    end

    return size
  end


  local function set_pattern_min_max(pat)
    if not pat.min_size then
      local min_size =  999
      local max_size = -999

      for pass = 1,2 do
        local sizes = (pass == 1 ? pat.x_sizes ; pat.y_sizes)
        
        each s in sizes do
          local w = str_size(s)

          min_size = math.min(min_size, w)
          max_size = math.max(max_size, w)
        end
      end

      assert(min_size <= max_size)

      pat.min_size = min_size
      pat.max_size = max_size
    end

-- gui.debugf("MIN_MAX of %s = %d..%d\n", pat.name, pat.min_size, pat.max_size)

    return pat.min_size, pat.max_size
  end


  local function matching_sizes(sizes, w)
    local list = {}
    
    each s in sizes do
      if str_size(s) == w then
        table.insert(list, s)
      end
    end

    return list
  end


  local function symmetry_match(pat, axis)
    return (pat.symmetry == axis) or (pat.symmetry == "xy")
  end


  -- current transform
  local TR = {}


  local function test_or_install_pattern(G, info, DO_IT)

    -- NOTE: must check chunks (require same area on chunk, don't put void on chunks), 
                                
    -- FIXME !!!

    return false 
  end


  local function try_pattern(G, pat)

    for transpose = 0, 1 do
    
      TR.transpose = (transpose == 1)

      TR.long = (TR.transpose ? G.sh ; G.sw)
      TR.deep = (TR.transpose ? G.sh ; G.sw)

      each x_size in matching_sizes(pat.x_sizes, TR.long) do
      each y_size in matching_sizes(pat.y_sizes, TR.deep) do

        for x_flip = 0, (symmetry_match(pat, "x") ? 1 ; 0) do
        for y_flip = 0, (symmetry_match(pat, "y") ? 1 ; 0) do

          TR.x_flip = (x_flip == 1)
          TR.y_flip = (y_flip == 1)

          convert_structure(pat, x_size, y_size)

          if test_or_install_pattern(xxx, false) then
             test_or_install_pattern(xxx, true)
             return true
          end

        end -- x_flip
        end -- y_flip

      end -- x_size
      end -- y_size

    end -- transpose

    return false 
  end


  local function can_use_pat(G, pat)
    --
    -- this does very basic checks to eliminate patterns early on
    --

    -- room kind check
    if pat.room_kind and pat.room_kind != R.kind then return -1 end

    -- 3D check
    if pat.overlap and not PARAM.extra_floors then return -1 end

    -- basic size check
    set_pattern_min_max(pat)

    if pat.min_size > math.max(G.sw, G.sh) then return -1 end
    if pat.max_size < math.min(G.sw, G.sh) then return -1 end

    -- check number of areas
    if pat["area" .. (num_vhr + 1)] then return -1 end

    -- nothing to extend?
    if pat.extender and g_used == 0 then return -1 end

    -- TODO: symmetry tests

    local prob = pat.prob or 50

    -- (Todo: could modify probability based on certain factors, e.g.
    --        whether pattern was used already in this room)

    return prob
  end


  local function pick_a_pattern(G)
    local tab = {}

    each name,pat in AREA_PATTERNS do
      -- filter out patterns that definitely cannot be used
      local prob = can_use_pat(G, pat)

      if prob > 0 then
        tab[name] = prob
      end
    end

    -- try patterns until something works or we run out of them
    while not table.empty(tab) do
      local name = rand.key_by_probs(tab)
      tab[name] = nil

      local pat = AREA_PATTERNS[name]

      if try_pattern(G, pat) then
        return true
      end
    end

    -- nothing was possible
    return false
  end


  local function update_strays(G)
    each S in G.strays do
      -- FIXME
    end
  end


  local function fill_a_spot()
    local G = find_free_spot()

stderrf("fill_a_spot @ (%d %d)\n", G.gx, G.gy)
    if not pick_a_pattern(G) then
      install_PLAIN(G)
    end

    update_strays(G)

    G.used = true

    g_used = g_used + 1
  end


  ---| Areas_create_with_patterns |---

  number_of_areas()
  
  create_grid()
  assign_stray_seeds()

  while g_used < g_total do
    fill_a_spot()
  end

  Areas_dump_vhr(R)

  Areas_assign_chunks_to_vhrs(R)
end



function Areas_height_realization(R)
  --
  -- the virtual becomes reality, and it happens here
  --

  local max_floor_h = R.entry_h

  local function assign_floor(v, floor_h)
    if v < 1 or v > 9 then return end

    each AR in R.areas do
      if AR.vhr == v then
        AR.floor_h = floor_h
        max_floor_h = math.max(max_floor_h, AR.floor_h)
      end
    end
  end

  local function assign_ceil(v, ceil_h)
    if v < 1 or v > 9 then return false end

    local seen = false

    each AR in R.areas do
      if AR.vhr == v then
        AR.ceil_h = ceil_h
        seen = true
      end
    end

    return seen
  end


  ---| Areas_height_realization |---

  assert(R.entry_h)

  assert(R.entry_C)
  assert(R.entry_C.area)
  assert(R.entry_C.area.vhr)
 
  local base_v = R.entry_C.area.vhr

  assign_floor(base_v, R.entry_h)

  for i = 1,9 do
    assign_floor(base_v + i, R.entry_h + i * 128)
    assign_floor(base_v - i, R.entry_h - i * 128)
  end

  -- ceilings too
  local ceil_h = max_floor_h + 192

  for v = 9,1,-1 do
    if assign_ceil(v, ceil_h) then
      ceil_h = ceil_h + 128
    end
  end
end



function Areas_chunk_it_up_baby(R)

  -- TODO : make bigger chunks

  local function chunkify_area(AR)
    for sx = R.sx1,R.sx2 do for sy = R.sy1,R.sy2 do
      local S = SEEDS[sx][sy]

      if S.room != R then continue end
      if S.chunk and S.chunk.area == AR then continue end
      if S.void or S.wtf_bbq then continue end

      if S.v_areas[AR.vhr] != AR then continue end

      local C = CHUNK_CLASS.new(sx, sy, sx, sy)

      C.room = R
      C.area = AR

      C:set_coords()

      if S:above_vhr(AR.vhr) then C.no_ceil = true end

      table.insert( R.chunks, C)
      table.insert(AR.chunks, C)
    end end
  end

  ---| Areas_chunk_it_up_baby |---

  each AR in R.areas do
    chunkify_area(AR)

    -- this takes care of other chunks too (conns & importants)
    each C in AR.chunks do
      C.floor_h = assert(AR.floor_h)
    end
  end
end



function Areas_flesh_out()

  -- this creates the actual walkable areas in each room, making sure
  -- that ensures the player can traverse the room, i.e. reach all the
  -- connections and importants.  It also adds in scenic stuff like
  -- liquids, thick walls, pillars (etc).

  local pass_h = GAME.ENTITIES.player1.h + (PARAM.step_height or 16) + 8


  local function expand_chunks(R)
    -- so far most chunks are only a single seed in size.
    -- this function can make them bigger, for reasons like:
    --   (a) to make a centered doorway
    --   (b) use a complex pedestal for a key or switch
    --   etc...

    -- Note: only applies to walkable chunks

    -- TODO
  end


  local function free_seeds_along_side(R, side)
    local seeds = {}

    local whole
    if side == "whole" then side = 2 ; whole = true end

    each K in R.sections do
      local N = K:neighbor(side)
      if not whole and N and N.room == R then continue end

      local sx1, sy1, sx2, sy2 = geom.side_coords(side, K.sx1, K.sy1, K.sx2, K.sy2)

      if whole then sx1,sy1, sx2,sy2 = K.sx1,K.sy1, K.sx2,K.sy2 end

      for sx = sx1,sx2 do for sy = sy1,sy2 do
        local S = SEEDS[sx][sy]

        -- really the edge of room ?
        local T = S:neighbor(side)
        if not whole then assert(not (T and T.room == R)) end

--[[    while true do
        if T and T.room == R then
            S = T
          else
            break
          end
        end --]]

        if R:can_alloc_chunk(sx, sy, sx, sy) and
              not R:has_walk(sx, sy, sx, sy)
        then
          table.insert(seeds, S)
        end
      end end
    end

    return seeds
  end


  local function nuke_up_side(R, side)
    if not LEVEL.liquid then return end

    local spots = free_seeds_along_side(R, side)

    if #spots < 3 then return end

    each S in spots do
      local C = R:alloc_chunk(S.sx, S.sy, S.sx, S.sy)
      C.liquid = true
    end

    R.liquid_count = (R.liquid_count or 0) + #spots
  end


  local function liquid_in_room(R)
    -- FIXME: this is a workaround for issue where a seed can become
    --        surrounded by liquids, causing the area to be isolated.
    if R.street then return end

    local side_prob = style_sel("liquids", 0, 10, 40, 80)

    local whole_prob = style_sel("liquids", 0, 2, 15, 50)

    if rand.odds(whole_prob) then
      nuke_up_side(R, "whole")
    else
      for side = 2,8,2 do
        if rand.odds(side_prob) then nuke_up_side(R, side) end
      end
    end
  end


  local function void_up_section(R, K)
    -- usually make a single chunk
    if R:can_alloc_chunk(K.sx1, K.sy1, K.sx2, K.sy2) and
          not R:has_walk(K.sx1, K.sy1, K.sx2, K.sy2)
    then
      local C = R:alloc_chunk(K.sx1, K.sy1, K.sx2, K.sy2)
      C.scenic = true
      return
    end

    for sx = K.sx1,K.sx2 do for sy = K.sy1,K.sy2 do
      local S = SEEDS[sx][sy]

      if R:can_alloc_chunk(sx, sy, sx, sy) and
            not R:has_walk(sx, sy, sx, sy)
      then
        local C = R:alloc_chunk(sx, sy, sx, sy)
        C.scenic = true
      end
    end end
  end


  local function void_in_room(R)
    -- never in outdoor rooms
    if R.kind == "outdoor" then return end

    -- room must be large enough
    if R.kw < 2 or R.kh < 2 then return end

    -- do it more often in large rooms
    local prob = (R.svolume >= 36 ? 90 ; 25)
    if not rand.odds(prob) then return end

    local edges = rand.odds(20)
    local cages = rand.odds(20)  -- FIXME: (a) check cage palette  (b) STYLE

    each K in R.sections do
      local is_junc = (K.orig_kind == "junction")
      local is_edge =  K:touches_edge()

      if not is_junc then continue end

      if is_edge and not edges then continue end

      -- TODO: if cages and not is_edge then cage_up_section(K) else

      void_up_section(R, K)
    end
  end


  local function decorative_chunks(R)
    -- this does scenic stuff like cages, nukage pits, etc...

-- TODO: this is not used, redo the void pillars

    void_in_room(R)

    liquid_in_room(R)
  end


  local function crosses_corner(sx, sy, ex, ey)
    -- check if potential chunk would cross an interior corner
    -- (i.e. have both room border and non-border on a single side)

    local B1 = SEEDS[sx][sy]
    local T1 = SEEDS[sx][ey]

    for x = sx+1, ex do
      local B2 = SEEDS[x][sy]
      local T2 = SEEDS[x][ey]

      if (not B1:same_room(2)) != (not B2:same_room(2)) then return true end
      if (not T1:same_room(8)) != (not T2:same_room(8)) then return true end
    end

    local L1 = SEEDS[sx][sy]
    local R1 = SEEDS[ex][sy]

    for y = sy+1, ey do
      local L2 = SEEDS[sx][y]
      local R2 = SEEDS[ex][y]

      if (not L1:same_room(4)) != (not L2:same_room(4)) then return true end
      if (not R1:same_room(6)) != (not R2:same_room(6)) then return true end
    end

    return false
  end



  local function XXX__merge_areas(C, N, area_tab)
    assert(C.area != N.area)

    if C.area.id > N.area.id then
      C, N = N, C
    end

    C.area.size = C.area.size + N.area.size
    N.area.size = 0

    C.foobage = C.foobage or N.foobage

    -- remove 2nd area from the area table
    local N_area = N.area

    area_tab[N_area.id] = nil

    -- update all chunks
    each C2 in C.room.chunks do
      if C2.area == N_area then C2.area = C.area end
    end

    assert(N.area == C.area)

    assert(N.room == C.room)

          each C2 in C.room.chunks do
            if C2.area then
              assert(C2.area.size > 0)
              assert(area_tab[C2.area.id])
            end
          end
  end


  local function collect_neighbors(list, C, sx1, sy1, sx2, sy2)
    for sx = sx1,sx2 do for sy = sy1,sy2 do
      if geom.inside_box(sx, sy, C.room.sx1, C.room.sy1, C.room.sx2, C.room.sy2) then
        local S = SEEDS[sx][sy]
        if S and S.room == C.room and S.chunk then
          local N = S.chunk

          if not N.area or N.area == C.area then continue end

          -- already have it?
          if table.has_elem(list, N) then continue end

          -- never merge crossover chunks
          if N.foobage == "crossover" then return end

          -- maximum size check
          local new_size = C.area.size + N.area.size

          if new_size > C.area.max_size then continue end
          if new_size > N.area.max_size then continue end

          -- prevent merging connections 
          -- FIXME !!!!!  TOO STRICT -- should only be tendency
          if C.area.foobage and N.area.foobage then continue end

          table.insert(list, N)
        end
      end
    end end
  end


  local function try_expand_area(C, area_tab)
    -- never merge crossover chunks
    if C.foobage == "crossover" then return end

    local neighbors = {}

    -- FIXME: have a C.neighbors field
    --        (will still need to filter it for different 'area')
    collect_neighbors(neighbors, C, C.sx1, C.sy1-1, C.sx2, C.sy1-1)
    collect_neighbors(neighbors, C, C.sx1, C.sy2+1, C.sx2, C.sy2+1)
    collect_neighbors(neighbors, C, C.sx1-1, C.sy1, C.sx1-1, C.sy2)
    collect_neighbors(neighbors, C, C.sx2+1, C.sy1, C.sx2+1, C.sy2)
    
    -- nothing possible?
    if table.empty(neighbors) then return end

    -- FIXME: better logic to decide
    --        ESPECIALLY: not make too big
    local N = rand.pick(neighbors)

    merge_areas(C, N, area_tab)
  end


  --
  -- CROSS-OVER NOTES:
  --
  -- +  when a room has a visited crossover, limit area heights
  --    (e.g. bridge : max_h, channel : min_h) and the entry
  --    hallway must account for that too.
  --
  -- +  when a room has unvisited crossover, determine height
  --    using room's min/max floor_h and the entry hallway of the
  --    crossover must account for that when reached.
  --


  local function areas_touching_chunk(R, C, list)
    each C2 in R.chunks do
      if C2.area and C2.area != C.area and C:is_adjacent(C2) then
        table.add_unique(list, C2.area)
      end
    end
  end


  local function areas_touching_area(R, A)
    local list = {}

    each C in R.chunks do
      if C.area == A then
        areas_touching_chunk(R, C, list)
      end
    end

    return list
  end


  local function set_all_touching(R)
    each A in R.areas do
      A.touching = areas_touching_area(R, A)
    end
  end


  local function OLD__create_areas(R)
    -- the seeds which are left over from the previous allocations
    -- should form a contiguous area which ensures traversibility
    -- between all walk spots (doorways, switches, etc).
    --
    -- the task here is to allocate these seeds into chunks,
    -- organizing them into a number of separate floor areas
    -- (with different heights) and place stairs between them.

    -- group chunks into areas
    local area_tab = {}

    -- filter out "scenic" chunks (cages etc)
    local fl_chunks = {}

    each C in R.chunks do
      if not (C.scenic or C.cross_junc or C.liquid) then
        table.insert(fl_chunks, C)
      end
    end

    each C in fl_chunks do
      local AREA = AREA_CLASS.new("floor", R)

      area_tab[AREA.id] = AREA
      
      C.area = AREA
      
      AREA.size = C:seed_volume()
      AREA.rand = gui.random()
      AREA.min_size = 7
      AREA.max_size = 24

      AREA.foobage = C.foobage

      if C.foobage == "crossover" then AREA.crossover = true end
    end

    for loop = 1,10 do
      rand.shuffle(fl_chunks)

      each C in fl_chunks do
        if C.area.size < C.area.min_size or rand.odds(3) then
          try_expand_area(C, area_tab)
        end
      end
    end

    each C in R.chunks do
      assert(C.room == R)
      if C.area then
        assert(C.area.size > 0)
        assert(area_tab[C.area.id])
      end
    end

    -- collect the final areas
    local debug_id = 1

    each _,A in area_tab do
      A.debug_id = debug_id ; debug_id = debug_id + 1
---   stderrf("In %s : AREA %d size %d (>= %d)\n", R:tostr(), A.id, A.size, A.min_size)
      table.insert(R.areas, A)
    end

    each C in R.chunks do
      if C.area then
        table.insert(C.area.chunks, C)
        assert(C.area.debug_id)
      end
    end

    each A in R.areas do
      local C = A.chunks[1]
      assert(C)
      gui.debugf("%s, Area %d, %s\n", R:tostr(), A.id, C:tostr())
    end

    set_all_touching(R)

    R:dump_areas()
  end


  local function height_is_unique(h, touching)
    each A in touching do
      if h == A.floor_h then return false end
    end

    return true
  end


  local function pick_stair_skin(R, base_h, stair_spot, reverse)
    assert(stair_spot)

    local tab = {}

    each name,prob in THEME.stairs do
      local skin = GAME.SKINS[name]
      if not skin then error("Stair does not exist: " .. name) end
      tab[name] = prob
    end

    -- keep trying until find one which fits
    while not table.empty(tab) do
      local name = rand.key_by_probs(tab)
      tab[name] = nil

      local skin = assert(GAME.SKINS[name])

      -- FIXME: 2D size check

      -- only check the first (smallest) delta
      local h = base_h + skin._deltas[1] * (reverse ? -1 ; 1)

      if R:in_floor_limit(h) then
        return skin -- OK --
      end
    end

    error("could not find usable stair!")
  end


  local function pick_area_height(N, base_h, stair_skin, reverse)
    local R = N.room

    local step_height = PARAM.step_height or 16
    local half_height = int(step_height / 2)

    local deltas

    if stair_skin then
      deltas = assert(stair_skin._deltas)
    else
      deltas = { step_height, -step_height,
                 half_height, -half_height }
    end

      -- TODO: MINI STAIR POSSIBILITIES:
          --[[ int(step_height / 2) * 3, --]]
          --[[ step_height * 2 --]]

    local h_probs = {}

    each dh in deltas do
      local h = base_h + (reverse ? -dh ; dh)
      if R:in_floor_limit(h) then
        h_probs[h] = (height_is_unique(h, N.touching) ? 100 ; 1)
      end
    end

    assert(not table.empty(h_probs))

    return rand.key_by_probs(h_probs)
  end


  local function eval_stair_pair(C1, C2, dir)
    -- never use purpose or conn chunks
    if C1.content.kind then return -1 end

    if C1.foobage == "conn" then return -1 end
    if C1.foobage == "crossover" then return -1 end

    -- already has stair?
    if C1.stair then return -1 end
    if C2.stair then return -1 end

    -- TODO: prefer chunk _behind_ C1 to be part of C1.area

    local long = geom.vert_sel(dir, C1.x2 - C1.x1, C1.y2 - C1.y1)

    local score = long + (gui.random() ^ 2) * 220

    return score
  end


  local function find_stair_spot(A1, A2)
    -- allow theme to not have any stairs
    if not THEME.stairs then return nil, nil end

    -- area must have more than one chunk
    if #A1.chunks <= 1 then return nil, nil end

    local best
    local best_mini

    each C1 in A1.chunks do
      for dir = 2,8,2 do
        local C2 = C1:good_neighbor(dir)

        if not (C2 and C2.area == A2) then continue end

        best_mini = { C1=C1, C2=C2, dir=dir, score=-99 }

        local score = eval_stair_pair(C1, C2, dir)

        if score > 0 and (not best or score > best.score) then
          best = { C1=C1, C2=C2, dir=dir, score=score }
        end
      end
    end

    return best, best_mini
  end


  local function bridge_target_possible(C, N, dir)
    if not N.area then return false end

    -- area must be free
    if N.area.floor_h then return false end

    -- new area should not touch existing one
    -- [since they will both get the same floor height, making the
    --  bridge redundant]
    if C.area:touches(N.area) then return false end

    if C:has_parallel_stair(dir) then return false end

    return true
  end


  local function bridge_passer_possible(C, N, dir)
    -- don't place bridge over certain stuff
    if N.stair or N.content.kind or N.foobage == "conn" then
      return false
    end

    -- only allow two bridges to cross at right angles
    if N.bridge_dir and geom.is_parallel(dir, N.bridge_dir) then
      return false
    end

    -- check the floor height underneath
    -- [it is required since the normal area assignment code does not
    --  know about bridges]
    if not N.floor_h then return false end

    local h = N.bridge_h or N.floor_h

    if h > C.floor_h - pass_h - 16 then return false end

    return true
  end


  local function make_3D_bridge(sx1, sy1, sx2, sy2, dir, floor_h, f_mat)
    if sx1 > sx2 then sx1, sx2 = sx2, sx1 end
    if sy1 > sy2 then sy1, sy2 = sy2, sy1 end

    -- mark the bridge
    for sx = sx1,sx2 do for sy = sy1,sy2 do
      local S = SEEDS[sx][sy]
      local C = assert(S.chunk)
      C.bridge_dir = dir
      C.bridge_h   = floor_h
    end end

    -- FIXME: do this somewhere else, and use a PREFAB !!

    local f_mat = Mat_lookup(f_mat)
    local f_tex = f_mat.f or f_mat.t

    local S1 = SEEDS[sx1][sy1]
    local S2 = SEEDS[sx2][sy2]

    local brush = Brush_new_quad(S1.x1, S1.y1, S2.x2, S2.y2)

    Brush_set_tex(brush, f_mat.t)

    table.insert(brush, { t=floor_h,    tex=f_tex })
    table.insert(brush, { b=floor_h-16, tex=f_tex })

    raw_add_brush(brush)
  end


  local function seed_has_parallel_bridge(C, S, dir)
    if S and S.room == C.room and S.chunk and S.chunk.bridge_dir then
      return geom.is_parallel(S.chunk.bridge_dir, dir)
    end

    return false
  end


  local function try_bridge_at_chunk(C, dir)
    -- start at a known floor height
    if not C.floor_h then return false end

    if C:has_parallel_stair(dir) then return false end

    -- use seeds for this logic (good idea??)

    local start_x, start_y = C:bridge_pos(dir)

    for dist = 1, 4 do
      local sx, sy = geom.nudge(start_x, start_y, dir, dist-1)
      if not Seed_valid(sx, sy) then return false end

      -- automatically stop at edge of room
      local S = SEEDS[sx][sy]
      if S.room != C.room then return false end

      -- stop if hit a non-traversable chunk (cages, void etc)
      if not (S.chunk or S.chunk.area) then return false end

      local N = S.chunk

      -- never pass a crossover [FIXME: relax this]
      if N.foobage == "crossover" then return false end

      -- must go off edge of area (not through middle) and should
      -- not reconnect to same area
      if N.area == C.area then return false end

      if dist >= 2 and bridge_target_possible(C, N, dir) then
        -- SUCCESS !
        N.area:set_floor(C.floor_h) 

        local end_x, end_y = geom.nudge(start_x, start_y, dir, dist-2)
        local f_mat = C.room:pick_floor_mat(C.floor_h)

        make_3D_bridge(start_x, start_y, end_x, end_y, dir, C.floor_h, f_mat)

        return true
      end

      -- nearby bridge only allowed if perpendicular or different height
      local SL = S:neighbor(geom. LEFT[dir])
      local SR = S:neighbor(geom.RIGHT[dir])

      if seed_has_parallel_bridge(C, SL, dir) or
         seed_has_parallel_bridge(C, SR, dir)
      then
        return false
      end

      if dist < 4 and not bridge_passer_possible(C, N, dir) then
        return false
      end
    end

    return false
  end


  local function try_3D_bridge(R)
    -- TODO: require THEME.bridges

    if not PARAM.bridges then return end

    rand.shuffle(R.chunks)

    local DIR_LIST = { 2,4,6,8 }

    each C in R.chunks do
      rand.shuffle(DIR_LIST)

      each dir in DIR_LIST do
        if try_bridge_at_chunk(C, dir) then
          return -- SUCCESS
        end
      end
    end
  end


  local function connect_areas(A1, A2)
    local base_h = assert(A1.floor_h)

    -- WISH: support "mini stairs"

    -- find a place for a stair (try both areas)
    local stair1 = find_stair_spot(A1, A2)
    local stair2 = find_stair_spot(A2, A1)
    local reverse = false

    if (stair2 and not stair1) or
       (stair1 and stair2 and stair1.score < stair2.score)
    then
      stair1 = stair2 ; stair2 = nil
      reverse = true
    end

    local skin

    if stair1 then
      skin = pick_stair_skin(A1.room, base_h, stair1, reverse)
    end

    local new_h = pick_area_height(A2, base_h, skin, reverse)

    A2:set_floor(new_h)

    if stair1 then
      stair1.skin    = skin
      stair1.reverse = reverse
      stair1.new_h   = new_h

      -- store stair info in the chunk
      stair1.C1.stair = stair1
    end
  end


  local function find_known_neighbor(A)
    rand.shuffle(A.touching)

    each N in A.touching do
      if N.floor_h then
        return N
      end
    end
  end


  local function find_next_areas(R)
    each A in R.areas do
      if not A.floor_h then
        local N = find_known_neighbor(A)
        
        if N then
          return N, A
        end
      end
    end
  end


  local function OLD__connect_all_areas(R)
    while true do
      -- find an area which is not connected, but touches one which is,
      -- then connect those two.

      try_3D_bridge(R)

      local A1, A2 = find_next_areas(R)

      if not A1 then return end

      connect_areas(A1, A2)
    end
  end


  local function dump_seed_list(title, list)
    gui.debugf("%s\n", title)
    each S in list do
      gui.debugf("  %s\n", S:tostr())
    end
  end


  local function add_seed_or_chunk(list, S)
    if S.chunk then
      local C = S.chunk

      for sx = C.sx1, C.sx2 do for sy = C.sy1, C.sy2 do
        table.insert(list, SEEDS[sx][sy])
      end end

    else
      table.insert(list, S)
    end
  end


  local function grow_area(R, seeds, DIRS)
    -- this is temporary crud

    rand.shuffle(seeds)
    rand.shuffle(DIRS)

    for index = 1,#seeds do
      each dir in DIRS do

        if rand.odds(35) then continue end

        local S = seeds[index]
        local N = S:neighbor(dir)

        if not N then continue end
        if N.unfilled != R then continue end

        -- Eek!  unset the 'unfilled' flag here?
        if table.has_elem(seeds, N) then continue end

        add_seed_or_chunk(seeds, N)

      end
    end
  end


  local function seeds_to_chunks(R, AREA, seeds)
    local list = table.copy(seeds)

    while not table.empty(list) do
      local S = table.remove(list)
      local C

      if S.chunk then
        -- existing chunk
        C = S.chunk

        -- remove other seeds in this chunk from the list
        for sx = C.sx1, C.sx2 do for sy = C.sy1, C.sy2 do
          table.kill_elem(list, SEEDS[sx][sy])
        end end

      else
        -- create a new chunk

        local sx1, sy1 = S.sx, S.sy
        local sx2, sy2 = S.sx, S.sy

        -- FIXME !!!! try to make a bigger chunk

        -- remove other seeds from the list
        if sx2 > sx1 or sy2 > sy1 then
          for sx = sx1, sx2 do for sy = sy1, sy2 do
            table.kill_elem(list, SEEDS[sx][sy])
          end end
        end

        assert(R:can_alloc_chunk(sx1,sy1, sx2,sy2))

        C = R:alloc_chunk(sx1,sy1, sx2,sy2)
      end

      AREA:add_chunk(C)
    end
  end


  local function find_start_for_area(R, unfilled_seeds)
    rand.shuffle(unfilled_seeds)

    local best_S
    local best_C, best_dir

    local DIRS = { 2,4,6,8 }

    each S in unfilled_seeds do
      assert(S.unfilled)

      rand.shuffle(DIRS)

      each dir in DIRS do
        if not S:same_room(dir) then continue end

        local N = S:neighbor(dir)

        if not (N.chunk and N.chunk.area) then continue end

        -- FIXME !!!!  evaluate it, pick best
        return S, N.chunk, 10 - dir
      end
    end

    return nil  -- nothing found
  end


  local function create_area(R, mode, unfilled_seeds)
    -- seed to begin new area
    local start_S

    -- chunk that new area branches off (none for first one)
    local from_C
    local from_dir  -- direction towards start_S


    if table.empty(R.areas) then
      start_S = SEEDS[R.entry_C.sx1][R.entry_C.sy1]

    elseif mode == "extra" then
      start_S, from_C, from_dir = nil --!!! find_start_for_EXTRA_area(R)

      if not start_S then return false end

    else
      start_S, from_C, from_dir = find_start_for_area(R, unfilled_seeds)

      if not start_S then
R:dump_areas()
        error("failed to create new area")
      end

    end

    -- create the new area now

    local AREA = AREA_CLASS.new("floor", R)

    table.insert(R.areas, AREA)

    -- grow it

    local seeds = {}

    add_seed_or_chunk(seeds, start_S)

    local DIRS = { 2,4,6,8 }

    for i = 1,4 do
      grow_area(R, seeds, DIRS)
    end

dump_seed_list("grown seeds", seeds)

    each S in seeds do
      S.unfilled = nil
      table.kill_elem(unfilled_seeds, S)
    end

    seeds_to_chunks(R, AREA, seeds)

    -- determine new height

    local floor_h

    if not from_C then
      floor_h = R.entry_h
    else
      floor_h = from_C.area.floor_h + rand.pick { 8,12,16,24 }
    end

    AREA:set_floor(floor_h)

-- TEMP DEBUG : show connection point
-- [[
    if from_C then
      local mx, my = from_C:mid_point()
      mx, my = geom.nudge(mx, my, from_dir, 72)
      entity_helper("candle", mx, my, 0)
    end
--]]

    return true  -- OK
  end


  local function XXX__connect_all_areas(R)
-- stderrf("connect_all_areas BEGIN\n")
    -- this also creates the areas too!

    -- collect all the seeds we need to fill
    -- include the allocated chunks too
    local unfilled_seeds = {}

    for sx = R.sx1, R.sx2 do for sy = R.sy1, R.sy2 do
      local S = SEEDS[sx][sy]

      if S.room == R and R:can_alloc_chunk(sx, sy, sx, sy) then
        S.unfilled = R
        table.insert(unfilled_seeds, S)
      end
    end end

    each C in R.chunks do
      if not (C.scenic or C.liquid) then
        for sx = C.sx1, C.sx2 do for sy = C.sy1, C.sy2 do
          local S = SEEDS[sx][sy]
          S.unfilled = R
          table.insert(unfilled_seeds, S)
        end end
      end
    end

-- dump_seed_list("unfilled @ " .. R:tostr(), unfilled_seeds)


    -- first pass : ensure all seeds are filled by new areas
    while not table.empty(unfilled_seeds) do
-- stderrf("creating area (%d unfilled)\n", #unfilled_seeds)
      create_area(R, "normal", unfilled_seeds)
    end

    -- second pass : some extra floors (mainly for the Quake games)
    local extra = int((R.sw + R.sh) / 9 + gui.random() * 2)

    for loop = 1,extra do
      if not create_area(R, "extra") then break; end
    end

    -- done!

    set_all_touching(R)

    R:dump_areas()
-- stderrf("connect_all_areas DONE\n")
  end


  local function entry_chunk_and_height(R)
    local C, floor_h

    if R.entry_conn and R.entry_conn.kind != "teleporter" then
      C = assert(R.entry_conn.C2)

---# if not C.floor_h then stderrf("No floor @ %s in %s\n", C:tostr(), R:tostr()) end

      h = assert(C.floor_h)  ---# or -777)

      assert(C.room == R)

    else
      -- TODO: if R.purpose == "START" then find_start_chunk
      --       elseif R.has_teleporter() then find_tele_chunk
      -- [BETTER: have R.entry_chunk field]

      assert(#R.chunks > 0)

      repeat
        C = rand.pick(R.chunks)
      until not (C.scenic or C.liquid)

      if R.floor_limit then
        h = rand.sel(50, R.floor_limit[1], R.floor_limit[2])
      else
        h = rand.pick { 0,128,192,256,384 }
      end
    end

    return C, h
  end


  local function initial_height(R)
-- stderrf("initial_height in %s\n", R:tostr())

    local entry_C, entry_h = entry_chunk_and_height(R)

    if not R:in_floor_limit(entry_h) then
      gui.debugf("WARNING !!!! entry_h not in floor_limit\n")

      if entry_h < R.floor_limit[1] then
         entry_h = R.floor_limit[1]
      else
         entry_h = R.floor_limit[2]
      end
    -- !!!! FIXME: entry hallway will need to compensate (have a stair or whatever)
    end

    R.entry_h = entry_h
    R.entry_C = entry_C
  end


  local function finish_heights(R)
    -- find minimum and maximum heights
    R.min_floor_h = R.entry_h
    R.max_floor_h = R.entry_h

    -- validate : all areas got a height
    each A in R.areas do
      each C in A.chunks do

        if not C.floor_h then
          -- stderrf("FUCKED UP IN %s @ %s\n", R:tostr(), C:tostr())
          -- C.floor_h = -999
          -- C. ceil_h =  999
          error("Area chunk failed to get a floor height")
        end

        local h = C.floor_h

        R.min_floor_h = math.min(R.min_floor_h, h)
        R.max_floor_h = math.max(R.max_floor_h, h)
      end
    end

    R.done_heights = true
  end


  local function pick_floor_tex(R, A)
    local source = R.theme.floors or THEME.floors

    if not source then
      error("missing floor materials in theme")
    end
    
    local tab = table.copy(source)

    -- try hard to prevent two touching areas from having the same floor
    each name,prob in source do
      local used = false

      each A2 in A.touching do
        if A2.floor_mat == name then
          used = true ; break
        end
      end

      if used then
        tab[name] = tab[name] / 100
      end
    end

    A.floor_mat = rand.key_by_probs(tab)
  end


  local function floor_textures(R)
    if R.kind == "cave" then return end

    each A in R.areas do
      pick_floor_tex(R, A)
    end
  end


  local function crossover_room(R)
    local hall = R.crossover_hall

    if not hall then return end

    -- already visited?
    if hall.done_heights then return end

    -- TODO: analyse nearby chunks to get min/max floor_h
    local min_h = R.min_floor_h
    local max_h = R.max_floor_h

    local diff = hall:cross_diff()

    if hall.cross_mode == "bridge" then
      hall.cross_limit = { max_h + diff, 9999 }
    else
      hall.cross_limit = { -9999, min_h - (PARAM.jump_height or 32) - 40 }
    end
  end


  local function outgoing_heights(L)
    each D in L.conns do
      if D.L1 == L and D.L2.kind == "hallway" and D.kind != "double_R" then
        local hall = D.L2

        -- cycles hallways are done after everything else
        if not hall.is_cycle then
          hall:floor_stuff(D)
        end

        -- recursively handle hallway networks
        outgoing_heights(hall)
      end

      -- for direct room-to-room connections (Street mode, Closets)
      if D.L1 == L and D.kind != "teleporter" and
         L.kind != "hallway" and D.L2.kind != "hallway"
      then
stderrf("outgoing_heights : DIRECT %s --> %s\n", D.L1:tostr(), D.L2:tostr())
        assert(D.C1)
        assert(D.C2)
        assert(D.C1.floor_h)

        D.C2.floor_h = D.C1.floor_h
      end
    end
  end


  local function outgoing_cycles(L)
    each D in L.conns do
      if D.L1 == L and D.L2.kind == "hallway" and D.L2.is_cycle then
        local hall = D.L2

        hall:floor_stuff(D)
      end
    end
  end


  local function floor_stuff(R)
    R.areas = {}

    if R.kind == "cave" then
      Simple_cave_or_maze(R)
      Simple_create_areas(R)
    end

    initial_height(R)
    
    if R.kind == "cave" then
      local entry_area = assert(R.entry_C.area)
      R.entry_area = entry_area
      entry_area:set_floor(R.entry_h)

      Simple_connect_all_areas(R)
    else
      Areas_create_with_patterns(R)
      Areas_height_realization(R)
      Areas_chunk_it_up_baby(R)
    end

    finish_heights(R)

    if R.kind != "cave" then
      floor_textures(R)
    end

    outgoing_heights(R)
    crossover_room(R)
  end


  local function determine_spots(R)
    -- Note: for caves this is done during render phase

    each A in R.areas do
      A:determine_spots()
    end
  end


  local function tizzy_up_room(R)

    -- TODO add "area" prefabs now (e.g. crates, cages, bookcases)

    if R.kind == "cave" then
      Simple_render_cave(R)
    else
      determine_spots(R)
    end
  end


  local function prepare_ceiling(R)
    local h = R.crossover_max_h or R.max_floor_h

    h = h + rand.pick { 128, 192, 256, 320, 384 }

    if R.kind == "outdoor" then
      R.sky_h = h + 128
    else
      R.ceil_h = h
    end
  end


  local function ceiling_stuff(R)
    prepare_ceiling(R)
  end


  local function sync_sky_heights()
    each R in LEVEL.rooms do
      if R.sky_group then
        R.sky_group.h = math.max(R.sky_group.h or -999, R.sky_h)
      end
    end

    each R in LEVEL.rooms do
      if R.sky_group then
        R.sky_h = R.sky_group.h
      end
    end
  end


  local function can_make_window(K, dir)
    local N = K:neighbor(dir)

    if not N then return false end

    if N.room == K.room then return false end

    if K.kind == "outdoor" and N.kind == "outdoor" then return false end
  end


  local function try_add_window(R, dir, quota)
    each K in R.sections do
      if can_make_window(K, dir) then
        add_window(K, dir)
      end
    end
  end


  local function decide_windows(R)
    if STYLE.windows == "none" then return end

    local quota = style_sel("windows", 0, 20, 40, 80)

    each dir in rand.dir_list() do
      try_add_window(R, dir, quota)
    end
  end


  ---| Areas_flesh_out |---

  each R in LEVEL.rooms do expand_chunks(R) end
  each R in LEVEL.rooms do floor_stuff(R) end
  each R in LEVEL.rooms do outgoing_cycles(R) end

  Rooms_decide_fences()

--each R in LEVEL.rooms do decide_windows(R) end
  each R in LEVEL.rooms do ceiling_stuff(R) end

  sync_sky_heights()

  each R in LEVEL.rooms do tizzy_up_room(R) end
end

