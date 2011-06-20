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
  
  local NUM_PASS = 4


  local function link_chunks(C1, C2, dir, conn)
    assert(C1)
    assert(C2)
    assert(conn)

    if C1.room then conn.C1 = C1 end
    if C2.room then conn.C2 = C2 end

---## stderrf("link_chunks: %s --> %s\n", C1:tostr(), C2:tostr())
    local LINK =
    {
      C1 = C1,
      C2 = C2,
      dir = dir,
      conn = conn,
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


  local function do_section_conn(D, pass)
    local K1 = assert(D.K1)
    local K2 = assert(D.K2)

    local dir = assert(D.dir)

    local cx1, cy1, C1
    local cx2, cy2, C2

    if geom.is_vert(dir) then
      local sx1 = math.max(K1.sx1, K2.sx1)
      local sx2 = math.min(K1.sx2, K2.sx2)

      assert(sx1 <= sx2)

      cx1 = math.imid(sx1, sx2)
      cx2 = cx1

      cy1 = sel(dir == 2, K1.sy1, K1.sy2)
      cy2 = sel(dir == 2, K2.sy2, K2.sy1)
    else
      local sy1 = math.max(K1.sy1, K2.sy1)
      local sy2 = math.min(K1.sy2, K2.sy2)

      assert(sy1 <= sy2)

      cy1 = math.imid(sy1, sy2)
      cy2 = cy1

      cx1 = (dir == 4 ? K1.sx1 ; K1.sx2)
      cx2 = (dir == 4 ? K2.sx2 ; K2.sx1)
    end

    C1 = SEEDS[cx1][cy1].chunk
    if not C1 then
      C1 = K1.room:alloc_chunk(cx1, cy1, cx1, cy1)
      C1.foobage = "conn"
    end

    C2 = SEEDS[cx2][cy2].chunk
    if not C2 then
      C2 = K2.room:alloc_chunk(cx2, cy2, cx2, cy2)
      C2.foobage = "conn"
    end

    if pass == NUM_PASS then
      link_chunks(C1, C2, dir, D)
    end
  end


  local function do_hall_side(C, dir, K, D, pass, is_start)
    -- hallways off a hallway are naturally aligned
    if not K then
      -- FIXME !!!!  local C2 = ....

      if pass == NUM_PASS then
        link_chunks(C, C2, dir, D)
      end

      return;
    end

    -- the 'C' chunk is part of the hallway
    -- find 'C2' chunk which is part of the connected room

    local sx, sy

    if geom.is_vert(dir) then
      local sx1 = math.max(C.sx1, K.sx1)
      local sx2 = math.min(C.sx2, K.sx2)

      assert(sx1 <= sx2)

      sx = math.imid(sx1, sx2)
      sy = (dir == 2 ? K.sy2 ; K.sy1)
    else
      local sy1 = math.max(C.sy1, K.sy1)
      local sy2 = math.min(C.sy2, K.sy2)

      assert(sy1 <= sy2)

      sy = math.imid(sy1, sy2)
      sx = (dir == 4 ? K.sx2 ; K.sx1)
    end

    C2 = SEEDS[sx][sy].chunk

    if not C2 then
      C2 = K.room:alloc_chunk(sx, sy, sx, sy)
      C2.foobage = "conn"
    end

    if pass == NUM_PASS then
      if is_start then
        C, C2 = C2, C
        dir = 10 - dir
      end

      link_chunks(C, C2, dir, D)
    end
  end


  local function do_hallway_conn(D, pass)
    local hall = assert(D.hall)

    local start_C = hall.path[1].chunk
    local   end_C = hall.path[#hall.path].chunk

    assert(start_C and end_C)

    local start_K = hall.K1
    local   end_K = hall.K2

    local start_dir = hall.path[1].prev_dir
    local   end_dir = hall.path[#hall.path].next_dir

    assert(start_dir and end_dir)

    do_hall_side(start_C, start_dir, start_K, D, pass, true)
    do_hall_side(  end_C,   end_dir,   end_K, D, pass, false)
  end


  ---| Areas_handle_connections |---

  for pass = 1,NUM_PASS do
    each D in LEVEL.conns do
      if D.kind == "normal"  then do_section_conn(D, pass) end
      if D.kind == "hallway" then do_hallway_conn(D, pass) end
    end
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
      else
        S:set_edge(dir, "solid")
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

    -- mark the seed edges as "walk"
    for _,pos in ipairs(path) do
      local sx = R.sx1 + (pos.x - 1)
      local sy = R.sy1 + (pos.y - 1)

      local S = SEEDS[sx][sy]
      assert(S.room == R)

      S.is_walk = true

      S:set_edge(pos.dir, "walk")

      -- debugging stuff
      S.debug_path = true
      if false then
        local mx, my = S:mid_point()
        Trans.entity("potion", mx, my, 32)
      end
    end

    local last = table.last(path)
    local lx, ly = geom.nudge(last.x, last.y, last.dir)
    local sx = R.sx1 + lx - 1
    local sy = R.sy1 + ly - 1
    local S = SEEDS[sx][sy]
    assert(S.room == R)

    S.is_walk = true
    S.debug_path = true
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



function Areas_flesh_out()

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


  local function do_floors(R)
    -- the seeds which are left over from the previous allocations
    -- should form a contiguous area which ensures traversibility
    -- between all walk spots (doorways, switches, etc).
    --
    -- the task here is to allocate these seeds into chunks,
    -- organizing them into a number of separate floor areas
    -- (generally of different heights) and stairs between them.

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


  local function pick_stair_skin(stair)
    if not stair then return nil end

    local tab = {}

    each name,prob in THEME.stairs do
      local skin = GAME.SKINS[name]
      if not skin then error("Stair does not exist: " .. name) end
      tab[name] = prob
    end

    if table.empty(tab) then
      error("could not find usable stair!")
    end

    local name = rand.key_by_probs(tab)

    return GAME.SKINS[name]
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

    each dh in deltas do
      local h = base_h + dh
      h_probs[h] = (height_is_unique(h, touching) ? 100 ; 1)
    end

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


  local function try_3D_bridge(A2)
    rand.shuffle(A2.chunks)

    each C in A2.chunks do
      each dir in rand.dir_list() do

        local N = C:good_neighbor(dir)
        
        if not (N and N.area and N.room == C.room and N.area != C.area) then continue end
        if not N.floor_h then continue end

        -- don't place bridge over certain stuff
        if N.stair or N.purpose or N.foobage == "conn" then continue end
        if N.has_bridge then continue end

        local N2 = N:good_neighbor(dir)

        if not (N2 and N2.area and N2.room == C.room and N2.area != C.area and N2.area != N.area) then continue end
        if not N2.floor_h then continue end

        -- height check
        if N2.floor_h < N.floor_h + 96 then continue end

        local A1 = N2.area

        if A2:touches(A1) then continue end

        -- OK !
        set_area_floor(A2, A1.floor_h) 

        N.has_bridge = true

        -- build the bridge
        N:make_bridge(A1.floor_h, dir)

stderrf("!!!!!!!!!!!!!!!!!!! BRIDGE BRIDGE BRIDGE: %s --> %s\n", A2:tostr(), A1:tostr())
        return true

      end
    end

    return false
  end


  local function connect_areas(A1, A2)
    -- FIXME: do this separately (don't require A1 at all)
    if try_3D_bridge(A2) then return end

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

    local skin = pick_stair_skin(stair1)

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

      if R.entry_conn.hall then
        local hall = R.entry_conn.hall
        entry_h = assert(hall.chunks[#hall.chunks].floor_h)
      else
        local NC = assert(R.entry_conn.C1)
        entry_h  = assert(NC.floor_h)
      end

    else
      entry_area = rand.pick(R.areas)
      assert(entry_area)
      entry_h = rand.pick { 0,128,192,256,384 }
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


  local function hallway_heights(R)
    each D in R.conns do
      if D.R1 == R and D.hall then
        D.hall:do_floor(D)
      end
    end
  end


  local function prepare_ceiling(R)
    local h = R.floor_max_h + rand.pick { 128, 192, 256, 320, 384 }

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
    prepare_ceiling(R)
  end


  ---| Areas_flesh_out |---

  each R in LEVEL.rooms do decide_windows(R) end

  each R in LEVEL.rooms do expand_chunks(R) end

  each R in LEVEL.rooms do flesh_out(R) end
end

