------------------------------------------------------------------------
--  CONNECTIONS
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


--class CONN
--[[
    kind : keyword  -- "normal", "teleporter", "secret"

    lock : LOCK

    id : number  -- debugging aid

    -- The two areas are the vital (compulsory) information,
    -- especially for the quest system.  For teleporters the edge
    -- info will be absent (and area info done when pads are placed)

    R1 : source ROOM
    R2 : destination ROOM

    E1 : source EDGE
    E2 : destination EDGE

    A1 : source AREA
    A2 : destination AREA

    F1, F2 : EDGE  -- for "split" connections, the other side

    door_h : floor height for doors straddling the connection

    where1  : usually NIL, otherwise a FLOOR object
    where2  :
--]]


CONN_CLASS = {}


function CONN_CLASS.new(kind, R1, R2, dir)
  local C =
  {
    kind = kind
    id   = alloc_id("conn")
    R1   = R1
    R2   = R2
    dir  = dir
  }

  C.name = string.format("CONN_%d", C.id)

  table.set_class(C, CONN_CLASS)

  table.insert(LEVEL.conns, C)

  return C
end


function CONN_CLASS.kill_it(C)
  table.remove(LEVEL.conns, C)

  C.name = "DEAD_CONN"
  C.kind = "DEAD"
  C.id   = -1

  C.R1  = nil ; C.A1 = nil
  C.R2  = nil ; C.A2 = nil
  C.dir = nil
end


function CONN_CLASS.tostr(C)
  return assert(C.name)
end


function CONN_CLASS.swap(C)
  C.R1, C.R2 = C.R2, C.R1
  C.E1, C.E2 = C.E2, C.E1
  C.F1, C.F2 = C.F2, C.F1
  C.A1, C.A2 = C.A2, C.A1

  -- for split conns, keep E1 on left, F1 on right
  if C.F1 then
    C.E1, C.F1 = C.F1, C.E1
    C.E2, C.F2 = C.F2, C.E2
  end
end


function CONN_CLASS.other_area(C, A)
  if A == C.A1 then
    return C.A2
  else
    return C.A1
  end
end


function CONN_CLASS.other_room(C, R)
  if R == C.R1 then
    return C.R2
  else
    return C.R1
  end
end


function CONN_CLASS.set_where(C, R, floor)
  if R == C.R1 then  -- broken
    C.where1 = floor
  else
    C.where2 = floor
  end
end


function CONN_CLASS.get_where(C, R)
  if R == C.R1 then  -- broken
    return C.where1
  else
    return C.where2
  end
end


------------------------------------------------------------------------


function Connect_merge_groups(A1, A2)  -- NOTE : only used for internal conns now
  local gr1 = A1.conn_group
  local gr2 = A2.conn_group

  assert(gr1 and gr2)
  assert(gr1 != gr2)

  if gr1 > gr2 then gr1,gr2 = gr2,gr1 end

  each A in LEVEL.areas do
    if A.conn_group == gr2 then
       A.conn_group = gr1
    end
  end
end



function Connect_through_sprout(P)

--stderrf("Connecting... %s <--> %s\n", P.R1:tostr(), P.R2:tostr())

  local C = CONN_CLASS.new("normal", P.R1, P.R2)

  table.insert(C.R1.conns, C)
  table.insert(C.R2.conns, C)


  local S1   = P.S
  local long = P.long

  if P.split then long = P.split end


  local E1, E2 = Seed_create_edge_pair(S1, P.dir, long, "nothing")

  E1.kind = "arch"

  C.E1 = E1
  C.E2 = E2

  C.A1 = assert(E1.S.area)
  C.A2 = assert(E2.S.area)


  -- handle split connections
  if P.split then
    assert(not S1.diagonal)
    local S2 = S1:raw_neighbor(geom.RIGHT[P.dir], P.long - P.split)
    assert(not S2.diagonal)

    local F1, F2 = Seed_create_edge_pair(S2, P.dir, long, "nothing")

    F1.kind = "arch"

    C.F1 = F1
    C.F2 = F2
  end
end



function Connect_teleporters()

  -- FIXME : COMPLETELY BROKEN!!!  FIX FOR 'TRUNKS' FROM GROWER
  
  local function eval_room(R)
    -- never in hallways
    if R.kind == "hallway"   then return -1 end
    if R.kind == "stairwell" then return -1 end

    -- can only have one teleporter per room
    -- TODO : relax this to one per area [ but require a big room ]
    if R:has_teleporter() then return -1 end

    -- score based on size, ignore if too small
    if R.svolume < 10 then return -1 end

    local score = 100

    -- tie breaker
    return score + gui.random()
  end


  local function collect_teleporter_locs()
    local list = {}

    each R in LEVEL.rooms do
      local score = eval_room(R)

      if score > 0 then
        table.insert(list, { R=R, A=rand.pick(R.areas), score=score })
      end
    end

    return list
  end


  local function connect_is_possible(loc1, loc2)
    local A1 = loc1.A
    local A2 = loc2.A

    if A1.room == A2.room then
      return false
    end

-- FIXME
    return (A1.conn_group != A2.conn_group)
  end


  local function add_teleporter(loc1, loc2)
    local A1 = loc1.A
    local A2 = loc2.A

    gui.debugf("Teleporter connection: %s -- >%s\n", A1.name, A2.name)

---##  Connect_merge_groups(A1, A2)

    local C = CONN_CLASS.new("teleporter", A1, A2)

    table.insert(A1.room.conns, C)
    table.insert(A2.room.conns, C)

    -- setup tag information
    C.tele_tag1 = alloc_id("tag")
    C.tele_tag2 = alloc_id("tag")

    table.insert(A1.room.teleporters, C)
    table.insert(A2.room.teleporters, C)
  end


  local function try_add_teleporter()
    local loc_list = collect_teleporter_locs()

    -- sort the list, best score at the front
    table.sort(loc_list, function(A, B) return A.score > B.score end)

    -- need at least a source and a destination
    -- [we try all possible combinations of rooms)

gui.debugf("Teleport locs: %d\n", #loc_list)
    while #loc_list >= 2 do
      local loc1 = table.remove(loc_list, 1)

      -- try to find a room we can connect to
      each loc2 in loc_list do
        if connect_is_possible(loc1, loc2) then
          add_teleporter(loc1, loc2)
          return true
        end
      end
    end

    return false
  end


  ---| Connect_teleporters |---

  -- check if game / theme supports them
  if not PARAM.teleporters or
     OB_CONFIG.mode == "ctf"  -- TODO: support in CTF maps
  then
    gui.printf("Teleporters: not supported\n", quota)
    return
  end

  -- determine number to make
  local skip_prob = style_sel("teleporters", 100, 50, 25, 0)
  local quota     = style_sel("teleporters", 0, 0.5, 1.0, 2.5)

  if rand.odds(skip_prob) then
    gui.printf("Teleporters: skipped by style\n")
    return
  end

  quota = quota * SEED_W / rand.irange(15, 25)

  gui.printf("Teleporters: %d (%1.2f)\n", int(quota), quota)

  for i = 1, quota do
    try_add_teleporter()
  end
end


----------------------------------------------------------------


function Connect_stuff()


  local function is_connection_sharp(S, dir)
    -- sharp connections give player (and monsters) little room to fit
    -- through the door.
    -- returns "sharpness" value: 0, 1, or 2

    local N = S:neighbor(dir)

    if geom.is_straight(dir) then
      return sel(S.diagonal, 1, 0) + sel(N.diagonal, 1, 0)
    end

    -- diagonal

    return sel(S:has_inner_point(10 - dir), 0, 1) +
           sel(N:has_inner_point(dir), 0, 1)
  end


  local function is_near_another_conn(S, N)
    -- returns 0 for OK, 1 for meh, 2 for OMG

    local near_S = 0
    local near_N = 0

    each dir in geom.ALL_DIRS do
      local S2 = S:neighbor(dir)
      local N2 = N:neighbor(dir)

      if S2 and S2.area == S.area and S2.conn then near_S = near_S + 1 end
      if N2 and N2.area == N.area and N2.conn then near_N = near_N + 1 end
    end

    return math.min(near_S + near_N, 2)
  end


  local function where_can_connect(R1, R2)
    -- returns a list where two rooms can connect.
    -- R1 is always a hallway.
    -- result is a list containing: { S=seed, N=seed, dir=dir }

    local list = {}

    each A in R1.areas do
    each S in A.seeds do
    each dir in geom.ALL_DIRS do
      local N = S:neighbor(dir)

      if N and N.room == R2 and N.area.zone == A.zone then
        local sharp = is_connection_sharp(S, dir)
        table.insert(list, { S=S, N=N, dir=dir, sharp=sharp })
      end

    end -- A, S, dir
    end
    end

    return list
  end


  local function pick_hallway_conn_spots(R, where1, where2)
    -- main thing is to not use the same seed
    -- (also nice if seed pair is far apart)

    rand.shuffle(where1)
    rand.shuffle(where2)

    local best_dist
    local best1, best2

    each loc1 in where1 do
    each loc2 in where2 do
      local mx1, my1 = loc1.S:edge_coord(loc1.dir)
      local mx2, my2 = loc2.S:edge_coord(loc2.dir)

      local dist = geom.dist(mx1, my1, mx2, my2)

      dist = dist + gui.random() * 100

      if where1.S != where2.S then
        dist = dist + 520
      end

      -- try hard to avoid sharp places
      dist = dist + (2 - loc1.sharp) * 180
      dist = dist + (2 - loc2.sharp) * 180

      if not best_dist or dist > best_dist then
        best_dist = dist
        best1 = loc1
        best2 = loc2
      end
    end
    end

    assert(best1 and best2)

    return best1, best2
  end


  local function kill_hallway(R)
    error("kill_hallway called !!")
    --!!! R:kill_it()
  end


  local function connect_hallway_pair(R, N1, N2) -- OLD
    local  r_group =  R.areas[1].conn_group
    local n1_group = N1.areas[1].conn_group
    local n2_group = N2.areas[1].conn_group

    assert(n1_group != r_group)
    assert(n2_group != r_group)

    local where1 = where_can_connect(R, N1)
    local where2 = where_can_connect(R, N2)

    assert(not table.empty(where1))
    assert(not table.empty(where2))

    local loc1, loc2 = pick_hallway_conn_spots(R, where1, where2)

    Connect_seed_pair(loc1.S, loc1.N, loc1.dir)
    Connect_seed_pair(loc2.S, loc2.N, loc2.dir)

    return true
  end


  local function eval_hallway_pair(R, N1, N2)  -- OLD
    -- two rooms are already connected?
    if N1.areas[1].conn_group == N2.areas[1].conn_group then
      return -1
    end

    -- hallways never touch [ enforced in area.lua ]
    assert(N1.kind != "hallway")
    assert(N2.kind != "hallway")

    local score = 200

    local conn_max = math.max(N1:total_conns(), N2:total_conns())

    if conn_max >= 4 then score = score - 100 end
    if conn_max >= 3 then score = score - 50 end
    if conn_max >= 2 then score = score - 10  end

    -- tie breaker
    return score + gui.random() * 12
  end


  local function try_specific_stairwell(R, A, well)
    local outer_edges = A.edge_loops[1]

    local E1 = outer_edges[well.edge1]
    local E2 = outer_edges[well.edge2]

    assert(E1 and E2)
    assert(E1 !=  E2)

    -- TODO : handle WIDE edges

    local N1 = E1.S:neighbor(E1.dir)
    local N2 = E2.S:neighbor(E2.dir)

    if not (N1 and N1.area and N1.area.room) then return false end
    if not (N2 and N2.area and N2.area.room) then return false end

    N1 = N1.area
    N2 = N2.area

    assert(N1.room != R)
    assert(N2.room != R)

    if N1.zone != A.zone then return false end
    if N2.zone != A.zone then return false end

    -- this also handles N1 == N2
    if N1.conn_group == N2.conn_group then return false end

    --- OK !! ---

    R.kind = "stairwell"

    A.is_stairwell = well

    --TODO : support outdoor stairwells
    A.is_outdoor = false

    well.room1 = N1.room
    well.room2 = N2.room

    Connect_seed_pair(E1.S, nil, E1.dir, "reverse")
    Connect_seed_pair(E2.S, nil, E2.dir, "reverse")

    return true
  end


  local function try_make_a_stairwell(R)
    -- if two or more areas were merged, cannot make a stairwell
    if #R.areas > 1 then return false end

    -- FIXME !!!
    if OB_CONFIG.mode == "ctf" then return false end

    local A = R.areas[1]

    rand.shuffle(A.stairwells)

    -- ignore "fallback" stairwells on first pass
    for pass = 1, 2 do
      each well in A.stairwells do
        if pass == 1 and well.info.fallback then continue end 
        if pass == 2 and not well.info.fallback then continue end 

        if try_specific_stairwell(R, A, well) then
          return true -- SUCCESS
        end
      end
    end

    return false
  end


  local function try_connect_hallway(R) --OLD
    local neighbor_rooms = {}

    each A in R.areas do
    each N in A.neighbors do
      if N.zone != A.zone then continue end

      local R2 = N.room

      if not R2 or R2 == R then continue end

      if A.conn_group != N.conn_group then
        table.add_unique(neighbor_rooms, R2)
      end
    end
    end

    -- evaluate each possible pair of neighbors

    local best
    local best_score = 0

    for i = 1, #neighbor_rooms do
    for k = i + 1, #neighbor_rooms do
      local N1 = neighbor_rooms[i]
      local N2 = neighbor_rooms[k]

      local score = eval_hallway_pair(R, N1, N2)

      if score > best_score then
        best = { N1=N1, N2=N2 }
      end
    end -- i, k
    end

    -- connect best pair, or kill hallway if none

    if best then
      connect_hallway_pair(R, best.N1, best.N2)
    else
      gui.printf("hallway %s could not connect : killing it\n", R:tostr())

      kill_hallway(R)

      if R.sister then
        kill_hallway(R.sister)
      end
    end
  end


  local function handle_hallways()
    -- we handle all the hallways first, as sometimes it will not be
    -- possible to use a hallway (which requires connecting two previously
    -- unconnected groups) -- these hallways need to be detected early
    -- and merged into a normal room (or turned into VOID).

    local hall_list = {}

    -- visit from biggest to smallest
    -- (so less chance of needing to kill a large hallway)
    -- for CTF maps, we only visit one half of a peered area pair

    each R in LEVEL.rooms do
      if R.kind == "hallway" and not R.brother then
        R.h_order = R.svolume + gui.random()  -- tie breaker
        table.insert(hall_list, R)
      end
    end

    table.sort(hall_list, function(R1, R2)
        return R1.h_order > R2.h_order
    end)

    each R in hall_list do
      if try_make_a_stairwell(R) then
        -- OK
      else
        try_connect_hallway(R)
      end
    end
  end


  local function check_all_connected()  -- OLD
    local first = LEVEL.rooms[1].areas[1].conn_group

    each R in LEVEL.rooms do
    each A in R.areas do
      if A.conn_group != first then
        return false
      end
    end
    end

    return true
  end


  local function eval_normal_conn(S, dir, is_zone)
    local N = S:neighbor(dir)

    if not (N and N.room) then return -1 end

    local A1 = S.area
    local A2 = N.area

    assert(A1.conn_group)
    assert(A2.conn_group)

    local R1 = A1.room
    local R2 = A2.room

    if A1.conn_group == A2.conn_group then return -3 end

    if is_zone then
      assert(A1.zone != A2.zone)
    else
      if A1.zone != A2.zone then return -2 end
    end

    -- connection is possible, evaluate it --

    local score

    -- we done hallways already, no more please
    local hall_1 = (R1.kind == "hallway" or R1.kind == "stairwell")
    local hall_2 = (R2.kind == "hallway" or R2.kind == "stairwell")

    if hall_1 and hall_2 then
      score =  800
    elseif hall_1 or hall_2 then
      score = 1800
    else
      score = 2800
    end

    -- try not to have more than one connection in a seed
    if not (S.conn or N.conn) then
      score = score + 500
    end

    -- try hard to avoid sharp connections
    score = score - is_connection_sharp(S, dir) * 150

    -- prefer not being close to another connection
    score = score - is_near_another_conn(S, N) * 70

    local conn_max = math.max(R1:total_conns(), R2:total_conns())

    if conn_max >= 4 then score = score - 50 end
    if conn_max >= 3 then score = score - 30 end
    if conn_max >= 2 then score = score - 10 end

    -- tie breaker
    return score + 15 * gui.random()
  end


  local function add_a_connection()
    local best_S
    local best_dir
    local best_score = 0

-- stderrf("add_a_connection...\n")

    each R in LEVEL.rooms do
    each A in R.areas do
    each S in A.seeds do

        -- only need to try half the directions
        -- [ hence in CTF maps must try the mirrored rooms too ]
        for dir = 6, 9 do
          local score = eval_normal_conn(S, dir)

-- do stderrf("  try %s:%d --> %d\n", S:tostr(), dir, score) end

          if score > best_score then
            best_S = S
            best_dir = dir
            best_score = score
          end
        end

    end  -- R, A, S
    end 
    end

    -- perform the connection --

    if not best_S then

---   do return "fubar" end
      error("Unable to find place for connection!")
    end

    local N = best_S:neighbor(best_dir)

    local A1 = assert(best_S.area)
    local A2 = assert(N.area)

    -- cannot have three connections in a stairwell
    -- FIXME : check stairwells at end
    if A1.is_stairwell then
      A1.is_stairwell = nil
      A1.room.kind = "hallway"
    end
    if A2.is_stairwell then
      A2.is_stairwell = nil
      A2.room.kind = "hallway"
    end

    Connect_seed_pair(best_S, N, best_dir)
    return true
  end


  local function handle_the_rest()  -- OLD
    while not check_all_connected() do
      if add_a_connection() == "fubar" then break; end
    end
  end



  local function connect_grown_rooms()
    -- turn the preliminary connections into real ones

    each P in LEVEL.prelim_conns do
      Connect_through_sprout(P)
    end
  end


  ---| Connect_stuff |---

  gui.printf("\n---| Connect_stuff |---\n")


  connect_grown_rooms()

--[[
  handle_hallways()

  Connect_teleporters()

  handle_the_rest()  
--]]

end



function Connect_areas_in_rooms()

  local function check_internally_connected(R)
    local first = R.areas[1].conn_group

    each A in R.areas do
      if A.conn_group != first then
        return false
      end
    end

    return true
  end


  local function pick_internal_seed(R, A1, A2)
    local DIRS = table.copy(geom.ALL_DIRS)

    if #A1.seeds > #A2.seeds then
      A1, A2 = A2, A1
    end

    local seed_list = rand.shuffle(table.copy(A1.seeds))

    each S in seed_list do
      rand.shuffle(DIRS)

      each dir in DIRS do
        local N = S:neighbor(dir)

        if N and N.area == A2 then
          return S, dir, N
        end
      end
    end

    error("pick_internal_seed failed.")
  end


  local function make_an_internal_connection(R)
    local best_A1
    local best_A2
    local best_score = 0

    each A in R.areas do
    each N in A.neighbors do
      if N.room != R then continue end

      -- only try each pair ONCE
      if N.id > A.id then continue end

      if A.conn_group != N.conn_group then
        local score = 1 + gui.random()

        if score > best_score then
          best_A1 = A
          best_A2 = N
          best_score = score
        end
      end
    end -- A, N
    end

    if not best_A1 then
      error("Failed to internally connect " .. R:tostr())
    end

    -- OK --

    local A1 = best_A1
    local A2 = best_A2

    local S, dir = pick_internal_seed(R, A1, A2)

    local AREA_CONN =
    {
      A1 = A1, A2 = A2
      S1 = S,  S2 = S:neighbor(dir)
      dir = dir
    }

    table.insert(R.area_conns, AREA_CONN)

    Connect_merge_groups(A1, A2)
  end


  local function internal_connections(R)
    -- connect the areas inside each room (including hallways)

    R.area_conns = {}

    each A in R.areas do
      A.conn_group = assert(A.id)
    end

    while not check_internally_connected(R) do
      make_an_internal_connection(R)
    end

    if R.sister then
      assert(check_internally_connected(R.sister))
    end
  end


  ---| Connect_areas_in_rooms |---

  each R in LEVEL.rooms do
    if not R.brother then
      internal_connections(R)
    end
  end
end


