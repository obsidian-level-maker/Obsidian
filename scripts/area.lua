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

  touching : list(AREA)   -- NOTE: only used by cave code ATM

  floor_h  -- floor height

  target_h  -- if present, get as close to this height as possible
}


--------------------------------------------------------------]]


AREA_CLASS = {}

function AREA_CLASS.new(kind, room)
  local A =
  {
    id = Plan_alloc_id("area")
    kind = kind
    room = room
    chunks = {}
    touching = {}
  }
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

  each zone in L.exclusion_zones do
    if zone.kind == "empty" then
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

    spot.face_away = L:find_nonfacing_spot(spot.x1, spot.y1, spot.x2, spot.y2)

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


  -- another MUNDO HACK!  bring on V5....
  each C in A.chunks do
    if C.content.kind == "DECORATION" then
      local skin = GAME.SKIN[C.content.decor_prefab]
      assert(skin)

      local mx, my = C:mid_point()
      local r = assert(skin._radius)

      local poly = Brush_new_quad(mx - r, my - r, mx + r, my + r)

      gui.spots_fill_poly(poly, 1)
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


function AREA_CLASS.decide_picture(A)
  if (not LEVEL.has_logo) or rand.odds((A.room.has_logo ? 10 ; 30)) then
    A.pic_name = assert(A.room.zone.logo_name)

    A.room.has_logo = true
     LEVEL.has_logo = true

    return
  end

  local prob = style_sel("pictures", 0, 50, 85, 99)

  if A.room.zone.pictures and rand.odds(prob) then
    A.pic_name = rand.key_by_probs(A.room.zone.pictures)
  end
end


----------------------------------------------------------------


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

    if K.shape == "junction" then
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
---!!!!      if geom.is_vert(dir)  and K.sw >= 4 then sx2 = sx1 + 1 end
---!!!!      if geom.is_horiz(dir) and K.sh >= 4 then sy2 = sy1 + 1 end
    end

    -- when connecting to junctions, use the same size as the junction
    if other_K.shape == "junction" then
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
        if K.shape == "junction" then
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


  local function handle_conn(D)
    assert(D.K1 and D.dir1)
    assert(D.K2 and D.dir2)

    local is_double = (D.kind == "double_L" or D.kind == "double_R")

    local C1 = chunk_for_section_side(D.K1, D.dir1, D.K2, is_double)
    local C2 = chunk_for_section_side(D.K2, D.dir2, D.K1, is_double)

    D.C1 = C1 ; D.C2 = C2

    link_chunks(C1, D.dir1, C2, D)
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
      if S.section.shape == "junction" then cost = 500 end
      if N.section.shape == "junction" then cost = 500 end

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

    -- no monsters near start spot, please
    if R.purpose == "START" then
      R:add_exclusion_zone("empty",     C.x1, C.y1, C.x2, C.y2, 144)
      R:add_exclusion_zone("nonfacing", C.x1, C.y1, C.x2, C.y2, 768)
    end

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
      local chain_link = Hub_find_link("EXIT")

      if chain_link and chain_link.kind == "chain" then
        C.content.kind = "GATE"
        C.content.source_id = chain_link.dest.local_map
        C.content.dest_id   = chain_link.src .local_map
        C.content.dest_map  = chain_link.dest.map
      end
    end

    if R.purpose == "START" and LEVEL.hub_links then
      -- beginning of each level (except start) is a hub gate
      local from_link = Hub_find_link("START")

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

    -- prevent monsters being close to it (in target room)
    if R == conn.L2 then
      R:add_exclusion_zone("empty",     C.x1, C.y1, C.x2, C.y2, 224)
      R:add_exclusion_zone("nonfacing", C.x1, C.y1, C.x2, C.y2, 768)
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
    if (K.shape == "junction") and not K:touches_edge() then
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

  Areas_chunk_it_up_baby(R)
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
  Fabricate_old("STAIR_180", T, { R.skin })
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

gui.debugf("number_of_areas @ %s svol:%d --> %d [VHR %d .. %d]\n",
           R:tostr(), R.svolume, num_vhr, min_vhr, max_vhr)
  end


  local function can_alloc_grid(sx1, sy1, sx2, sy2)
    if not Seed_valid(sx1, sy1) or
       not Seed_valid(sx2, sy2)
    then
      return false
    end

    for sx = sx1, sx2 do
      for sy = sy1, sy2 do
        local S = SEEDS[sx][sy]

        if S.room != R or S.grid or S.void then
          return false
        end
      end
    end

    -- look for chunks which overlap the box (some inside and some outside)
    each C in R.chunks do
      if C.sx2 < sx1 or C.sx1 > sx2 then continue end
      if C.sy2 < sy1 or C.sy1 > sy2 then continue end

      if C.sx1 < sx1 or C.sx2 > sx2 then return false end
      if C.sy1 < sy1 or C.sy2 > sy2 then return false end
    end

    return true
  end


  local function alloc_grid(sx1, sy1, sx2, sy2)
    local G =
    {
      sx1 = sx1 , sy1 = sy1
      sx2 = sx2 , sy2 = sy2

      chunks = {}
    }

    -- determine size
    G.sw, G.sh = geom.group_size(G.sx1, G.sy1, G.sx2, G.sy2)

    -- add to room
    table.insert(R.grids, G)

    -- update seeds
    for sx = G.sx1, G.sx2 do
      for sy = G.sy1, G.sy2 do
        local S = SEEDS[sx][sy]

        S.grid = G
      end
    end

    -- collect chunks
    each C in R.chunks do
      if C.sx2 < sx1 or C.sx1 > sx2 then continue end
      if C.sy2 < sy1 or C.sy1 > sy2 then continue end

      table.insert(G.chunks, C)

      C.grid = G
    end

    return G
  end


  local function create_grids()
    R.grids = {}

    g_used  = 0

    --- step 1 : create grids from sections ---

    each K in R.sections do
      if K.shape != "rect" then continue end

      if K.room != R then continue end

      local sx1, sy1 = K.sx1, K.sy1
      local sx2, sy2 = K.sx2, K.sy2

      if not can_alloc_grid(sx1, sy1, sx2, sy2) then continue end

      -- try to expand on each four sides
      -- (deliberately NOT randomised here)

      for dir = 2,8,2 do
        local tx1, ty1 = sx1, sy1
        local tx2, ty2 = sx2, sy2

        if dir == 2 then ty1 = ty1 - 1 end
        if dir == 8 then ty2 = ty2 + 1 end
        if dir == 4 then tx1 = tx1 - 1 end
        if dir == 6 then tx2 = tx2 + 1 end

        if can_alloc_grid(tx1, ty1, tx2, ty2) then
          sx1, sy1 = tx1, ty1
          sx2, sy2 = tx2, ty2
        end
      end

      local G = alloc_grid(sx1, sy1, sx2, sy2)

      G.section = K
    end

    --- step 2 : turn any remaining spaces into grids ---

    each C in R.chunks do
      if not C.scenic and not C.grid then
        assert(can_alloc_grid(C.sx1, C.sy1, C.sx2, C.sy2))
        C.grid = alloc_grid(C.sx1, C.sy1, C.sx2, C.sy2)

        table.insert(C.grid.chunks, C)
      end
    end

    for sx = R.sx1, R.sx2 do
      for sy = R.sy1, R.sy2 do
        local S = SEEDS[sx][sy]

        if S.room != R then continue end
        if S.void then continue end

        -- already allocated?
        if S.grid then continue end

        local sx1, sy1 = sx, sy
        local sx2, sy2 = sx, sy

        -- try to expand on each four sides, upto 4 times
        for loop = 1,4 do
          for dir = 2,8,2 do
            local tx1, ty1 = sx1, sy1
            local tx2, ty2 = sx2, sy2

            if dir == 2 then ty1 = ty1 - 1 end
            if dir == 8 then ty2 = ty2 + 1 end
            if dir == 4 then tx1 = tx1 - 1 end
            if dir == 6 then tx2 = tx2 + 1 end

            if can_alloc_grid(tx1, ty1, tx2, ty2) then
              sx1, sy1 = tx1, ty1
              sx2, sy2 = tx2, ty2
            end
          end
        end

        alloc_grid(sx1, sy1, sx2, sy2)
      end
    end
  end


  local function valid_and_used(sx, sy)
    if not Seed_valid(sx, sy) then
      return false
    end

    local S = SEEDS[sx][sy]

    if S.room != R then return false end

    if not S.grid then return false end

    return S.grid.used
  end


  local function used_grid_neighbors(G)
    local count = 0

    for pass = 1,2 do
      for sx = G.sx1, G.sx2 do
        local sy = (pass == 1 ? G.sy1 - 1 ; G.sy2 + 1)
        if valid_and_used(sx, sy) then
          count = count + 1
        end
      end

      for sy = G.sy1, G.sy2 do
        local sx = (pass == 1 ? G.sx1 - 1 ; G.sx2 + 1)
        if valid_and_used(sx, sy) then
          count = count + 1
        end
      end
    end

    return count
  end


  local function find_free_spot()
    -- we want a grid spot next to an already used spot

    local best
    local best_score

    each G in R.grids do
      if not G  then continue end
      if G.used then continue end

      local score = used_grid_neighbors(G)

      if score > 6 then score = 6 end

      score = score + gui.random()

      if not best or score > best_score then
        best = G
        best_score = score
      end
    end
    
    return assert(best)
  end


  local function get_PLAIN_area(G)
    if g_used == 0 then
      local AREA = AREA_CLASS.new("floor", R)

      AREA.vhr = rand.irange(min_vhr, max_vhr)

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
      gui.printf("WARNING: failed to find any height in grid neighbors")

      local AREA = AREA_CLASS.new("floor", R)
      AREA.vhr = rand.irange(min_vhr, max_vhr)
      table.insert(R.areas, AREA)
      return AREA
    end

    -- TODO: pick the least used VHR so far

    local AREA = rand.pick(areas)

    return AREA
  end


  local function install_PLAIN(G)
    local AREA = get_PLAIN_area(G)
    local v = AREA.vhr

    -- update seeds
    for x = G.sx1, G.sx2 do
    for y = G.sy1, G.sy2 do
      local S = SEEDS[x][y]

      assert(S.room == R)
      assert(not S.void)
      assert(not S.v_areas[v])

      S.v_areas[v] = AREA
    end
    end

    -- transfer existing chunks
    each C in G.chunks do
      AREA:add_chunk(C)
    end

    assert(R.sx1 <= G.sx1 and G.sx2 <= R.sx2)
    assert(R.sy1 <= G.sy1 and G.sy2 <= R.sy2)

    -- create new chunks
    for x = G.sx1, G.sx2 do
    for y = G.sy1, G.sy2 do
      local S = SEEDS[x][y]

      if S.chunk or S.plain_chunk then continue end

      -- try to make bigger chunks
      local sw, sh = 1, 1

--[[ !!!!
      if x < G.sx2 and not SEEDS[x+1][y].chunk and
         not R:straddles_concave_corner(x, y, x + sw, y + sh - 1)
      then
        sw = 2
      end

      if y < G.sy2 and not SEEDS[x][y+1].chunk and
         not R:straddles_concave_corner(x, y, x + sw - 1, y + sh)
      then
        sh = 2
      end

      if sw == 2 and sh == 2 and (SEEDS[x+1][y+1].chunk or
         R:straddles_concave_corner(x, y, x + sw - 1, y + sh - 1))
      then
        sh = 1
      end 
--]]

      local C = CHUNK_CLASS.new(x, y, x + sw - 1, y + sh - 1)
      C:set_coords()
      if S:above_vhr(AREA.vhr) then C.no_ceil = true end
      AREA:add_chunk(C)
      C.room = R ; table.insert(R.chunks, C)

      -- mark seeds
      for sx = C.sx1, C.sx2 do
      for sy = C.sy1, C.sy2 do
        SEEDS[sx][sy].plain_chunk = true
        table.insert(SEEDS[sx][sy].chunks, C)
      end
      end

    end
    end
  end


  -------- PATTERN STUFF --------->>


  local function str_pos_size(s, i)
    local ch = string.sub(s, i, i)

    return 0 + ch
  end


  local function str_pos_at(s, i)
    local pos = 1

    while i > 1 do
      i = i - 1
      pos = pos + str_pos_size(s, i)
    end

    return pos
  end


  local function str_total_size(s)
    local size = 0

    for i = 1,#s do
      size = size + str_pos_size(s, i)
    end

    return size
  end


  local function set_pattern_min_max(pat)
    -- determines number of areas too

    if not pat.min_size then
      local min_size =  999
      local max_size = -999

      for pass = 1,2 do
        local sizes = (pass == 1 ? pat.x_sizes ; pat.y_sizes)
        
        each s in sizes do
          local w = str_total_size(s)

          min_size = math.min(min_size, w)
          max_size = math.max(max_size, w)
        end
      end

      assert(min_size <= max_size)

      pat.min_size = min_size
      pat.max_size = max_size

      pat.num_areas = 1

      while pat["area" .. (pat.num_areas + 1)] do
        pat.num_areas = pat.num_areas + 1
      end
    end

-- gui.debugf("MIN_MAX of %s = %d..%d\n", pat.name, pat.min_size, pat.max_size)

    return pat.min_size, pat.max_size
  end


  local function matching_sizes(sizes, w)
    local list = {}
    
    each s in sizes do
      if str_total_size(s) == w then
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


  local function morph_coord(x, y)
    if TR.x_flip then x = TR.long - x + 1 end
    if TR.y_flip then y = TR.deep - y + 1 end

    if TR.transpose then return y, x end

    return x, y
  end

  local function morph_dir(dir)
    if TR.x_flip and is_horiz(dir) then dir = 10-dir end
    if TR.y_flip and is_vert(dir)  then dir = 10-dir end

    if TR.transpose then dir = TRANSPOSE_DIRS[dir] end

    return dir
  end

  local function morph_char(ch)
    if TR.x_flip then ch = X_MIRROR_CHARS[ch] or ch end
    if TR.y_flip then ch = Y_MIRROR_CHARS[ch] or ch end

    if TR.transpose then ch = TRANSPOSE_CHARS[ch] or ch end

    return ch
  end


  local function convert_structure(G, pat, x_size, y_size)
    local stru_w = #x_size
    local stru_h = #y_size

    for ar_index = 1, pat.num_areas do
      local name = "area" .. ar_index
      local structure = pat[name]

      TR[name] = table.array_2D(G.sw, G.sh)

      -- source coordinates
      for x = 1, stru_w do
      for y = 1, stru_h do

        local line = structure[stru_h + 1 - y]
        if not line or #line != stru_w then
          error("bad structure in z-pattern: " .. pat.name)
        end

        local ch = string.sub(line, x, x)

        local elem_x = str_pos_at(x_size, x)
        local elem_y = str_pos_at(y_size, y)

        local elem_w = str_pos_size(x_size, x)
        local elem_h = str_pos_size(y_size, y)

        local ELEM = { ch = morph_char(ch) }

        for dx = 0, elem_w - 1 do
        for dy = 0, elem_h - 1 do
         
            -- target coordinates
            local tx = elem_x + dx
            local ty = elem_y + dy

            tx, ty = morph_coord(tx, ty)

            -- validation
            local sx = G.sx1 + tx - 1
            local sy = G.sy1 + ty - 1
            assert(geom.inside_box(sx, sy, G.sx1,G.sy1, G.sx2,G.sy2))

            TR[name][tx][ty] = ELEM

            -- determine final location of this element
            ELEM.sx1 = math.min(sx, ELEM.sx1 or sx)
            ELEM.sy1 = math.min(sy, ELEM.sy1 or sy)
            ELEM.sx2 = math.max(sx, ELEM.sx2 or sx)
            ELEM.sy2 = math.max(sy, ELEM.sy2 or sy)
        end
        end -- dx, dy

      end
      end  -- x, y

    end  -- ar_index
  end


  local function rand_vhr_list(pat)
    local list = {}

    local low  = min_vhr
    local high = max_vhr - pat.num_areas + 1

    assert(high >= low)  -- ensured by can_use_pat()

    for i = low, high do
      table.insert(list, i)
    end

    rand.shuffle(list)

    return list
  end


  local function handle_stair(stair_ch, C)
    local dir = STAIR_DIRS[stair_ch]

    if not dir then return end  -- not a stair

    C.stair =
    {
      C1  = C
      dir = dir
      skin = assert(GAME.SKINS["Stair_Up1"])  -- FIXME !!!
    }
  end


  local function check_elem_clobbers_chunk(G, v, ELEM)
    each C in G.chunks do
      if C.vhr != v then continue end

      if C.sx2 < ELEM.sx1 or C.sx1 > ELEM.sx2 then continue end
      if C.sy2 < ELEM.sy1 or C.sy1 > ELEM.sy2 then continue end

      return true
    end

    return nil
  end


  -- please forgive these function names, I'm so so sorry!

  local function chunk_is_mungeable(AREA, ELEM, sx, sy, sw, sh, above_vhr, sx2, sy2)
    -- does the chunk fit?
    if sx + sw - 1 > sx2 then return false end
    if sy + sh - 1 > sy2 then return false end

    local sx1 = sx ; sx2 = sx + sw - 1
    local sy1 = sy ; sy2 = sy + sh - 1

    -- part of the same elem?
    if sx1 < ELEM.sx1 or sx2 > ELEM.sx2 or
       sy1 < ELEM.sy1 or sy2 > ELEM.sy2
    then return false end

    for x = sx1, sx2 do
    for y = sy1, sy2 do
      if x == sx1 and y == sy1 then continue end
        
      local S = SEEDS[x][y]

      if S.room != R then return false end

      if S.chunk or S.munge_fuck then return false end

      -- never create chunks with different VHR's above them
      if S:above_vhr(AREA.vhr) != above_vhr2 then
        return false
      end
    end
    end

    if R:straddles_concave_corner(sx1, sy1, sx2, sy2) then
      return false
    end

    return true  -- OK!!
  end


  local function munge_the_chunk(AREA, ELEM, sx, sy, sx2, sy2)
    local S = SEEDS[sx][sy]

    if S.munge_fuck then
      return
    end

    local above_vhr = S:above_vhr(AREA.vhr)

    -- see if a bigger size is possible
    local sw, sh = 1, 1

--[[  BROKEN FOR 3D AREAS
    if chunk_is_mungeable(AREA, ELEM, sx, sy, 2, 2, above_vhr, sx2, sy2) then
      sw, sh = 2, 2
    elseif chunk_is_mungeable(AREA, ELEM, sx, sy, 2, 1, above_vhr, sx2, sy2) then
      sw = 2
    elseif chunk_is_mungeable(AREA, ELEM, sx, sy, 1, 2, above_vhr, sx2, sy2) then
      sh = 2
    end
--]]

    local sx1 = sx ; sx2 = sx + sw - 1
    local sy1 = sy ; sy2 = sy + sh - 1

    local C = CHUNK_CLASS.new(sx1, sy1, sx2, sy2)
    C:set_coords()

    if above_vhr then C.no_ceil = true end

    AREA:add_chunk(C)

    C.room = R ; table.insert(R.chunks, C)

    for x = sx1, sx2 do
    for y = sy1, sy2 do
--    SEEDS[x][y].munge_fuck = true
      table.insert(SEEDS[x][y].chunks, C)
    end
    end
  end


  local function test_or_install_pattern(G, pat, mode)

-- stderrf("test_or_install_pattern: %s %s\n", mode, pat.name)

    if mode == "test" then
      G.link_areas = {}  -- table [VHR] : list(AREA)

      each C in G.chunks do
        C.poss_vhrs = {}
      end
    end

    -- need to decide _now_ the VHR where existing chunks will go
    -- (so we know where new chunks can be created)
    if mode == "install" then
      each C in G.chunks do
        C.vhr = rand.pick(C.poss_vhrs)
      end

-- stderrf("install_pattern: %s in %s\n", pat.name, R:tostr())
    end


    for ar_index = 1, pat.num_areas do
      local structure = TR["area" .. ar_index]
      assert(structure)

      local v = TR.base_vhr + ar_index - 1
      
      local AREA

      if mode == "install" then
        if G.link_areas[v] then
          AREA = rand.pick(G.link_areas[v])  -- TODO : evaluate them (e.g. pick smallest)
        else
          AREA = AREA_CLASS.new("floor", R)
          AREA.vhr = v

          table.insert(R.areas, AREA)
        end

        each C in G.chunks do
          if C.vhr == v then
            AREA:add_chunk(C)
          end
        end
      end


      for x = 1, G.sw do
      for y = 1, G.sh do
        local ELEM = structure[x][y]

        if ELEM.ch == ' ' then continue end

        local sx = G.sx1 + x - 1
        local sy = G.sy1 + y - 1

        local S = SEEDS[sx][sy]


        -- prevent stairs or diagonals from being split at concave corners
        if mode == "test" and ELEM.ch != '#' and
           R:straddles_concave_corner(ELEM.sx1, ELEM.sy1, ELEM.sx2, ELEM.sy2)
        then
          return false -- FAIL
        end


        if mode == "install" then
          -- create area

          assert(S.room == R)
          assert(not S.void)
          assert(not S.v_areas[v])

          S.v_areas[v] = AREA

          -- create chunks : prefer one element = one chunk
          --                 (this is _REQUIRED_ for stairs)

          -- Note: this logic assumes we process the bottom left seed of
          --       the element first, and sets either 'bad' or 'chunk'
          --       field to control how to process the other seeds.

          if not ELEM.bad and not ELEM.chunk then
            if check_elem_clobbers_chunk(G, v, ELEM) or
               R:straddles_concave_corner(ELEM.sx1, ELEM.sy1, ELEM.sx2, ELEM.sy2)
               or true  --!!!!!!
            then
              ELEM.bad = true
            end
          end


          if ELEM.bad then
          
            if not (S.chunk and S.chunk.vhr == v) then
              -- create a chunk for a seed (trying bigger sizes too)
              munge_the_chunk(AREA, ELEM, sx, sy, G.sx2, G.sy2)
            end

          elseif not ELEM.chunk then

            -- create a chunk for whole element
            local C = CHUNK_CLASS.new(ELEM.sx1, ELEM.sy1, ELEM.sx2, ELEM.sy2)
            C:set_coords()
            if S:above_vhr(AREA.vhr) then C.no_ceil = true end
            AREA:add_chunk(C)
            C.room = R ; table.insert(R.chunks, C)

            for sx = C.sx1, C.sx2 do
            for sy = C.sy1, C.sy2 do
              table.insert(SEEDS[sx][sy].chunks, C)
            end
            end

            ELEM.chunk = C

            handle_stair(ELEM.ch, C)
          end
        end


        -- see what neighboring areas we can link with
        if mode == "test" then
          for dir = 2,8,2 do
            local N = S:neighbor(dir)
            if not (N and N.room == R) then continue end
            if N.void then continue end
            if not (N.grid and N.grid.used) then continue end
            assert(N.grid != G)
            
            if N.v_areas[v] then
              if not G.link_areas[v] then G.link_areas[v] = {} end
              table.add_unique(G.link_areas[v], N.v_areas[v])
            end
          end
        end

      end
      end

      -- require existing chunks (conns, etc) to fully fit into the area
      if mode == "test" then
        each C in G.chunks do

          local ok = true

          for sx = C.sx1, C.sx2 do
          for sy = C.sy1, C.sy2 do
            
            local x = sx - G.sx1 + 1
            local y = sy - G.sy1 + 1

            local ELEM = structure[x][y]

            if ELEM.ch == ' ' then
              ok = false ; break

            elseif ELEM.ch != "#" then
              return false  -- FAIL, chunk is clobbered (by stair, void, etc)
            end

          end
          end

          if ok then
            table.insert(C.poss_vhrs, v)
          end

        end
      end

    end -- ar_index


    -- nothing to link with?
    if mode == "test" then
      if g_used > 0 and table.empty(G.link_areas) then
        return false -- FAIL
      end
    end


    if mode == "test" then
      each C in G.chunks do
        if table.empty(C.poss_vhrs) then
          return false  -- FAIL
        end
      end
    end

    return true  -- OK 
  end


  local function try_pattern(G, pat)

    local t_rand = rand.sel(50, 0, 1)
    local x_rand = rand.sel(50, 0, 1)
    local y_rand = rand.sel(50, 0, 1)

    local vhr_list = rand_vhr_list(pat)

    for transpose = 0, 1 do
    
      TR.transpose = (transpose == t_rand)

      TR.long = (TR.transpose ? G.sh ; G.sw)
      TR.deep = (TR.transpose ? G.sw ; G.sh)

      each x_size in matching_sizes(pat.x_sizes, TR.long) do
      each y_size in matching_sizes(pat.y_sizes, TR.deep) do

        for x_flip = 0, (symmetry_match(pat, "x") ? 1 ; 0) do
        for y_flip = 0, (symmetry_match(pat, "y") ? 1 ; 0) do

          TR.x_flip = (x_flip == x_rand)
          TR.y_flip = (y_flip == y_rand)

          convert_structure(G, pat, x_size, y_size)

          each vhr in vhr_list do

            TR.base_vhr = vhr

            if test_or_install_pattern(G, pat, "test") then
              -- Yay, success
              test_or_install_pattern(G, pat, "install")
              return true
            end

          end -- vhr

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
    
    -- sometimes use no pattern (less likely for large grids)
    local plain_prob = 40 - (G.sw + G.sh) * 3
    if rand.odds(plain_prob) then
      return false
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


  local function fill_a_spot()
    local G = find_free_spot()

--    if not pick_a_pattern(G) then
      install_PLAIN(G)
--    end

    G.used = true

    g_used = g_used + 1
  end


  ---| Areas_create_with_patterns |---

  number_of_areas()
  
  create_grids()

  while g_used < #R.grids do
    fill_a_spot()
  end

  Areas_dump_vhr(R)

  -- DONT NEED THIS (we assign chunks when installing the pattern)
  -- Areas_assign_chunks_to_vhrs(R)
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
    assign_floor(base_v + i, R.entry_h + i * 16)
    assign_floor(base_v - i, R.entry_h - i * 16)
  end

  -- ceilings too
  local ceil_h = max_floor_h + 192

  for v = 9,1,-1 do
    if assign_ceil(v, ceil_h) then
      ceil_h = ceil_h + 128
    end
  end

  -- update chunks [ASSUMES: chunks already exist]
  each AR in R.areas do
    each C in AR.chunks do
      C.floor_h = assert(AR.floor_h)

      if C.stair then
        C.stair.low_h  = C.floor_h
        C.stair.high_h = C.floor_h + 64  -- FIXME
      end      
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
      local is_junc = (K.shape == "junction")
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

    each A in R.areas do
      A:decide_picture()
      A.use_fence = rand.odds(80)
    end

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

    -- fixme?
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

