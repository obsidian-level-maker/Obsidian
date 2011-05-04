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


function Rooms_flesh_out()

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

    -- FIXME !!! use a connection chunk if nothing else free
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
    if R.purpose then add_purpose(R) end
    if R.weapon  then add_weapon(R)  end
  end


  local function pick_tele_spot(R, other_K)
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


  local function decorative_chunks(R)
    -- this does scenic stuff like cages, nukage pits, etc...

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
stderrf("create_a_path: %s : %s --> %s\n", R:tostr(), C1:tostr(), C2:tostr())

    -- pick start and ending seeds
    local sx = (C2.sx1 > C1.sx1 ? C1.sx2, C1.sx1)
    local sy = (C2.sy1 > C1.sy1 ? C1.sy2, C1.sy1)

    local ex = (C1.sx1 > C2.sx1 ? C2.sx2, C2.sx1)
    local ey = (C1.sy1 > C2.sy1 ? C2.sy2, C2.sy1)

    -- coordinates must be relative for A* algorithm
    sx, sy = (sx - R.sx1) + 1, (sy - R.sy1) + 1
    ex, ey = (ex - R.sx1) + 1, (ey - R.sy1) + 1

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

      S:set_edge(pos.dir, "walk")

      -- debugging stuff
      S.debug_path = true
      if true then
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

    S.debug_path = true
  end


  local function make_paths(R)
    -- collect chunks which the player must be able to get to
    local list = {}

    for index,C in ipairs(R.chunks) do
      if C.foobage == "conn" or C.foobage == "important" then
        table.insert(list, C)
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


  local function do_floors(R)
    -- the seeds which are left over from the previous allocations
    -- should form a contiguous area which ensures traversibility
    -- between all walk spots (doorways, switches, etc).
    --
    -- the task here is to allocate these seeds into chunks,
    -- sub-dividing them into a number of separate floor areas
    -- (generally of different heights) and stairs between them.

    -- TODO
  end


  local function dummy_chunks(R)
    for sx = R.sx1, R.sx2 do for sy = R.sy1, R.sy2 do
      local S = SEEDS[sx][sy]
      if S.room == R and not S.chunk then
        local C = R:alloc_chunk(sx, sy, sx, sy)
        C.foobage = "dummy"
      end
    end end
  end


  local function flesh_out(R)
    init_room(R)
    place_importants(R)
    extra_stuff(R)
    make_paths(R)
    decorative_chunks(R)
    do_floors(R)

dummy_chunks(R)

stderrf("\n")
  end


  ---| Rooms_flesh_out |---

  place_teleporters()

  each R in LEVEL.rooms do
    flesh_out(R)
  end
end

