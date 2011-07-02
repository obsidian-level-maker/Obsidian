----------------------------------------------------------------
--  AREAS Within Rooms
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2010-2011 Andrew Apted
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

  size : number of seeds occupied

  touching : list(AREA)

  floor_h  -- floor height
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


function AREA_CLASS.touches(A, A2)
  each N in A.touching do
    if A2 == N then return true end
  end

  return false
end


----------------------------------------------------------------


function Areas_handle_connections()
  --[[
  -- this creates the chunks in a room where it connects to a
  -- hallway or another room, and sets up the link[] entries in
  -- the chunks.
  --]]

  local function chunk_for_section_side(K, dir)
    -- sections are guaranteed to stay aligned, so calling this
    -- function on two touching sections will provide two chunks
    -- which touch each other.

    -- result chunk only occupies a single seed.  Enlarging the
    -- chunk (to make wider doors etc) can be done after all the
    -- connections and importants have been given chunks.

    local sx, sy

    if geom.is_vert(dir) then
      sx = math.i_mid(K.sx1, K.sx2)
      sy = (dir == 2 ? K.sy1 ; K.sy2)
    else
      sy = math.i_mid(K.sy1, K.sy2)
      sx = (dir == 4 ? K.sx1 ; K.sx2)
    end

    local S = SEEDS[sx][sy]

    if not S.chunk then
      local C = K.room:alloc_chunk(sx, sy, sx, sy)
      C.foobage = "conn"
      S.chunk = C
    end

    return S.chunk
  end


  local function link_chunks(C1, dir, C2, conn)
    assert(C1)
    assert(C2)
    assert(conn)

--  gui.debugf("link_chunks: %s --> %s\n", C1:tostr(), C2:tostr())

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


  local function handle_conn(D)
    -- teleporters are done elsewhere (as an "important")
    if D.kind == "teleporter" then return end

    assert(D.K1 and D.dir1)
    assert(D.K2 and D.dir2)

    local C1 = chunk_for_section_side(D.K1, D.dir1)
    local C2 = chunk_for_section_side(D.K2, D.dir2)

    D.C1 = C1 ; D.C2 = C2

    if D.kind == "direct" then
      link_chunks(C1, D.dir1, C2, D)

    elseif D.kind == "crossover" then
      local info = D.crossover

      local CA = chunk_for_section_side(info.MID_K, D.dir2)
      local CB = chunk_for_section_side(info.MID_K, D.dir1)

      local HA_1 = info.hall_A:first_chunk()
      local HA_2 = info.hall_A:last_chunk()

      local HB_1 = info.hall_B:first_chunk()
      local HB_2 = info.hall_B:last_chunk()

      link_chunks(C1, D.dir1, HA_1, D)
      link_chunks(CA, D.dir2, HA_2, D)

      link_chunks(CB, D.dir1, HB_1, D)
      link_chunks(C2, D.dir2, HB_2, D)
      
    else
      -- hallway
      local H1 = D.hall:first_chunk()
      local H2 = D.hall:last_chunk()  -- may be same as first

      link_chunks(C1, D.dir1, H1, D)
      link_chunks(C2, D.dir2, H2, D)
    end
  end


  ---| Areas_handle_connections |---

  each D in LEVEL.conns do
    handle_conn(D)
  end
end


----------------------------------------------------------------


function Areas_important_stuff()

  local function init_seed(R, S)
    for dir = 2,4,2 do
      local N = S:neighbor(dir)
      
      if S:same_room(dir) then
        local cost = 2 ^ rand.range(1, 5)

        S.cost[dir] = cost
        N.cost[10-dir] = cost
---### else
---###   S:set_edge(dir, "solid")
      end
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
    
    local function init_dists()
      for sx = R.sx1,R.sx2 do for sy = R.sy1,R.sy2 do
        local S = SEEDS[sx][sy]
        if S.room == R then
          
          if S.chunk then
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

              if S.chunk_dist and (N.chunk_dist or 999) > S.chunk_dist + 1 then
                N.chunk_dist = S.chunk_dist + 1
                changed  = true
              end

              if S.wall_dist and (N.wall_dist or 999) > S.wall_dist + 1 then
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

    for sx = R.sx1, R.sx2 do for sy = R.sy1, R.sy2 do
      local S = SEEDS[sx][sy]

      if S.room == R and not S.chunk then
        local dist = S.chunk_dist * 7 + S.wall_dist * 2.15 + S.dist_random

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
    local C = spot_for_wotsit(R)

    if R.purpose == "SOLUTION" then
      C.lock = assert(R.purpose_lock)

      if C.lock.kind == "KEY" or C.lock.kind == "SWITCH" then
        C.purpose = C.lock.kind
      else
        error("UNKNOWN LOCK KIND")
      end

    else
      C.purpose = R.purpose
    end
  end


  local function add_weapon(R)
    local C = spot_for_wotsit(R)

    C.weapon = R.weapon
  end


  local function place_importants(R)
    -- FIXME: do teleporter here !!!!

    if R.purpose then add_purpose(R) end
    if R.weapon  then add_weapon(R)  end
  end


  local function pick_tele_spot(R, other_K)
    -- FIXME: broken???

    local loc_list = {}

    for x = R.kx1,R.kx2 do for y = R.ky1,R.ky2 do
      local K = SECTIONS[x][y]
      if K.room == R then
        local score
        
        if other_K then
          score = geom.dist(x, y, other_K.kx, other_K.ky)
        else
          score = R:dist_to_closest_conn(K) or 9
        end

        if K.num_conn == 0 and K != other_K then
          score = score + 11
        end

        score = score + gui.random() / 5

        table.insert(loc_list, { K=K, score=score })
      end
    end end -- x, y

    local loc = table.pick_best(loc_list,
        function(A, B) return A.score > B.score end)

    return loc.K  
  end


  local function place_one_tele(R)
    -- we choose two sections, one for outgoing teleporter and one
    -- for the returning spot.

    local out_K = pick_tele_spot(R)
    local in_K  = pick_tele_spot(R, out_K)

    out_K.teleport_out = true
     in_K.teleport_in  = true

    return out_K
  end


  local function place_teleporters()
    -- determine which section(s) of each room to use for teleporters
    each D in LEVEL.conns do
      if D.kind == "teleporter" then
        if not D.K1 then D.K1 = place_one_tele(D.R1) end
        if not D.K2 then D.K2 = place_one_tele(D.R2) end
      end
    end
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

    -- must stay inside room
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

---###  S:set_edge(pos.dir, "walk")

      S.is_walk = true

--[[  -- DEBUGGING AID --
      local mx, my = S:mid_point()
      Trans.entity("potion", mx, my, 32)
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

    for index,C in ipairs(R.chunks) do
      if C.foobage == "conn" or C.foobage == "important" then
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


function Areas_flesh_out()

  local pass_h = GAME.ENTITIES.player1.h + (PARAM.step_height or 16) + 8


  local function decide_windows(R)
    -- allocate chunks on side of room
    -- [TODO: allow windows in existing chunks]

    -- TODO !!!
  end


  local function expand_chunks(R)
    -- so far all chunks are only a single seed in size.
    -- this function can make them bigger, for reasons like:
    --   (a) to make a centered doorway
    --   (b) use a complex pedestal for a key or switch
    --   etc...

    -- TODO
  end


  local function decorative_chunks(R)
    -- this does scenic stuff like cages, nukage pits, etc...

    -- TODO
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


  local function filler_chunks(R)
    for sx = R.sx1, R.sx2 do for sy = R.sy1, R.sy2 do
      local S = SEEDS[sx][sy]
      if S.room == R and not S.chunk then
        
        local W, H = 1, 1
        local do_x_match = rand.sel(50, 0, 1)

        local EXPAND_PROBS = { 50, 18, 5 }

        for pass = 1,6 do
          local do_x = ((pass % 2) == do_x_match)
          local expand_prob = EXPAND_PROBS[int((pass + 1) / 2)]

          if not rand.odds(expand_prob) then continue end

          if do_x and R:can_alloc_chunk(sx, sy, sx+W, sy+H-1) and
                  not crosses_corner(sx, sy, sx+W, sy+H-1)
          then
            W = W + 1
          elseif not do_x and R:can_alloc_chunk(sx, sy, sx+W-1, sy+H) and
                          not crosses_corner(sx, sy, sx+W-1, sy+H)
          then
            H = H + 1
          end
        end

        local C = R:alloc_chunk(sx, sy, sx+W-1, sy+H-1)
---???  C.foobage = "filler"
      end
    end end
  end


  local function merge_areas(C, N, area_tab)
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
  --    hallway must account for that too
  --
  -- +  when a room has unvisited crossover, determine height
  --    using room's min/max floor_h and the entry hallway of the
  --    crossover must account for that when reached.
  --


  local function do_floors(R)
    -- the seeds which are left over from the previous allocations
    -- should form a contiguous area which ensures traversibility
    -- between all walk spots (doorways, switches, etc).
    --
    -- the task here is to allocate these seeds into chunks,
    -- organizing them into a number of separate floor areas
    -- (generally of different heights) and stairs between them.

    R.floor_limit = { -512, 1024 }

    if R.crossover and R.crossover.floor_h then
      if R.crossover.mode == "bridge" then
        R.floor_limit[2] = R.crossover.floor_h - 128
      else
        R.floor_limit[1] = R.crossover.floor_h + 128
      end
    end

    -- 1. create chunks for remaining seeds
    filler_chunks(R)

    -- 2. group chunks into areas
    local area_tab = {}

    -- FIXME: filter out "scenic" chunks (cages etc)
    local fl_chunks = table.copy(R.chunks)

    each C in fl_chunks do
      local AREA = AREA_CLASS.new("floor", R)

      area_tab[AREA.id] = AREA
      
      C.area = AREA
      
      AREA.size = C:seed_volume()
      AREA.rand = gui.random()
      AREA.min_size = rand.sel(50, 3, 4)
      AREA.max_size = 20 --!!! math.min(R.svolume * X, Y)

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
    R.areas = {}

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
  end


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


  local function height_is_unique(h, touching)
    each A in touching do
      if h == A.floor_h then return false end
    end

    return true
  end


  local function pick_stair_skin(R, base_h, stair_spot)
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

      -- only check the first (smallest) delta
      local z = base_h + skin._deltas[1]

      if math.in_range(R.floor_limit[1], z, R.floor_limit[2]) then
        return skin -- OK --
      end
    end

    error("could not find usable stair!")
  end


  local function pick_area_height(N, base_h, stair_skin)
    local R = N.room

    -- !!!! FIXME: EXPENSIVE : collect only once
    local touching = areas_touching_area(R, N)

    local step_height = PARAM.step_height or 16
    local half_height = int(step_height / 2)

--?? local GOOD_DIFFS = { 16,32,32,48,48,64,80,96 } -- FIXME: probability distribution

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

    each dz in deltas do
      local z = base_h + dz
      if math.in_range(R.floor_limit[1], z, R.floor_limit[2]) then
        h_probs[z] = (height_is_unique(z, touching) ? 100 ; 1)
      end
    end

    assert(not table.empty(h_probs))

    return rand.key_by_probs(h_probs)
  end


  local function set_area_floor(A, floor_h)
    A.floor_h = floor_h

    each C in A.chunks do
      C.floor_h = floor_h
    end
  end


  local function eval_stair_pair(C1, C2, dir)
    -- never use purpose or conn chunks
    if C1.purpose or C1.weapon then return -1 end

    if C1.foobage == "conn" then return -1 end
    if C1.foobage == "crossover" then return -1 end

    -- already has stair?
    if C1.stair then return -1 end
    if C2.stair then return -1 end

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
    if N.stair or N.purpose or N.foobage == "conn" then
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

    local brush = Trans.bare_quad(S1.x1, S1.y1, S2.x2, S2.y2)

    Trans.set_tex(brush, f_mat.t)

    table.insert(brush, { t=floor_h,    tex=f_tex })
    table.insert(brush, { b=floor_h-16, tex=f_tex })

    gui.add_brush(brush)
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
--stderrf("!!!!!!!!!!!!!! BRIDGE BRIDGE BRIDGE: %d,%d --> %d,%d\n", start_x, start_y, sx, sy)

        set_area_floor(N.area, C.floor_h) 

        local end_x, end_y = geom.nudge(start_x, start_y, dir, dist-2)
        local f_mat = C.room:pick_floor_mat(C.floor_h
        )
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

    -- find a place for a stair (try both areas)
    local stair1, mini_stair1 = find_stair_spot(A1, A2)
    local stair2, mini_stair2 = nil, nil ---!!! find_stair_spot(A2, A1)

    if (stair2 and not stair1) or
       (stair1 and stair2 and stair1.score < stair2.score)
    then
      stair1 = stair2 ; stair2 = nil
    end

---??    if mini_stair2 and not mini_stair1 then
---??      mini_stair1 = mini_stair2 ; mini_stair2 = nil
---??    end

    local skin
    if stair1 then skin = pick_stair_skin(A1.room, base_h, stair1) end

    local new_h = pick_area_height(A2, base_h, skin)

    set_area_floor(A2, new_h)

    -- store stair info in the chunk
    if stair1 then
      stair1.C1.stair = stair1
      stair1.C1.stair.skin = skin

---??? elseif mini_stair1 then
---???   mini_stair1.C1.mini_stair = mini_stair1
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


  local function connect_all_areas(R)
    while true do
      -- find an area which is not connected, but touches one which is,
      -- then connect those two.

      try_3D_bridge(R)

      local A1, A2 = find_next_areas(R)

      if not A1 then return end

      connect_areas(A1, A2)
    end
  end


  local function area_heights(R)
    set_all_touching(R)

    -- determine entry area
    --   1. for start room : starting chunk
    --   2. for teleport entries : teleporter chunk
    --   3. for everything else : connection chunk
    local entry_area
    local entry_h

--- stderrf("area_heights in %s\n", R:tostr())

    if R.entry_conn then
      local C = assert(R.entry_conn.C2)
      assert(C.room == R)
      entry_area = assert(C.area)
--- stderrf("  entry_conn: %s -> %s\n", R.entry_conn.R1:tostr(), R.entry_conn.R2:tostr())

      if R.entry_conn.crossover then
        local info = R.entry_conn.crossover
stderrf("area_heights @ %s with CROSSOVER %s\n", R:tostr(), info.chunk:tostr())
        entry_h = assert(info.floor_h)

      elseif R.entry_conn.hall then
        local hall = R.entry_conn.hall
        entry_h = assert(hall.chunks[#hall.chunks].floor_h)

      else
        local NC = assert(R.entry_conn.C1)
        entry_h  = assert(NC.floor_h)
      end
    
    else
      entry_area = rand.pick(R.areas)
      assert(entry_area)
    end

    if not entry_h then
      entry_h = rand.pick { 0,128,192,256,384 }
    end

    if not math.in_range(R.floor_limit[1], entry_h, R.floor_limit[2]) then
      stderrf("!!! entry_h not in floor_limit\n")
      if entry_h < R.floor_limit[1] then
         entry_h = R.floor_limit[1]
      else
         entry_h = R.floor_limit[2]
      end
      -- !!!! FIXME: entry hallway will need to compensate (have a stair or whatever)
    end

    R.entry_h = entry_h
    R.entry_area = entry_area

    set_area_floor(entry_area, entry_h)

    connect_all_areas(R)

    -- find minimum and maximum heights
    R.floor_min_h = R.entry_h
    R.floor_max_h = R.entry_h

    each A in R.areas do
      each C in A.chunks do
        -- validate : all areas got a height
        local h = assert(C.floor_h)

        R.floor_min_h = math.min(R.floor_min_h, h)
        R.floor_max_h = math.max(R.floor_max_h, h)
      end
    end
  end


  local function set_crossover_mode(info)
    local id1 = info.conn.R2.quest.id
    local id2 = info.MID_K.room.quest.id

    if id1 < id2 or (id1 == id2 and rand.odds(10)) then
      -- the crossover bridge is part of a earlier quest, so
      -- we must not let the player fall down into this room
      -- (and subvert the quest structure).
      --
      -- Hence the crossover becomes a "cross under" :)

      info.mode = "channel"
    else
      info.mode = "bridge"
    end

stderrf("CROSSOVER %s : %s (id %d,%d)\n", info.chunk:tostr(), info.mode, id1, id2)
  end


  local function crossover_conn(R, D)
    local info = D.crossover

    -- get start height
    assert(D.C1)
    local h = assert(D.C1.floor_h)

    -- already has a height ??
    if info.floor_h then
      -- FIXME: mark info.hall_A to have a stair
      return
    end

    set_crossover_mode(info)

    info.floor_h = h

    info.hall_A.chunks[1].floor_h = h
    info.hall_B.chunks[1].floor_h = h
  end


  local function crossover_heights(R)
    if not R.crossover then return end

    local info = R.crossover

    -- already has a height?
    if info.floor_h then return end

    set_crossover_mode(info)

    -- TODO: analyse nearby chunks to get min/max floor_h
    local min_h = R.floor_min_h
    local max_h = R.floor_max_h

    local h

    if info.mode == "bridge" then
      h = max_h + 128
    else
      h = min_h - 128
    end

    info.floor_h = h

    info.hall_A.chunks[1].floor_h = h
    info.hall_B.chunks[1].floor_h = h
  end


  local function hallway_heights(R)
    each D in R.conns do
      if D.R1 != R then continue end

      if D.hall then D.hall:do_floor(D) end
      if D.crossover then crossover_conn(R, D) end
    end
  end



  local function prepare_ceiling(R)
    local h = R.crossover_max_h or R.floor_max_h

    h = h + rand.pick { 128, 192, 256, 320, 384 }

    if R.outdoor then
      R.sky_h = h + 128
    else
      R.ceil_h = h
    end
  end


  local function flesh_out(R)
    decorative_chunks(R)
    do_floors(R)
    area_heights(R)
    hallway_heights(R)
    crossover_heights(R)
    prepare_ceiling(R)
  end


  ---| Areas_flesh_out |---

  each R in LEVEL.rooms do decide_windows(R) end

  each R in LEVEL.rooms do expand_chunks(R) end

  each R in LEVEL.rooms do flesh_out(R) end
end

