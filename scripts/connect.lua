------------------------------------------------------------------------
--  CONNECTIONS
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

--[[ *** CLASS INFORMATION ***

class CONN
{
  kind : keyword  -- "normal", "teleporter", "secret", "closet"

  lock : LOCK

  id : number  -- debugging aid

  -- The two areas are the vital (compulsory) information,
  -- especially for the quest system.  For teleporters the seed
  -- info will be absent (and area info done when pads are placed)

  A1 : source AREA
  A2 : destination AREA

  S1 : source SEED
  S2 : destination SEED

  dir    : direction 2/4/6/8 (from S1 to S2)

  conn_h : floor height for connection

  where1  : usually NIL, otherwise a FLOOR object
  where2  :
}

--------------------------------------------------------------]]


CONN_CLASS = {}


function CONN_CLASS.new(kind, A1, A2, dir)
  local C =
  {
    kind = kind
    id   = alloc_id("conn")
    A1   = A1
    A2   = A2
    dir  = dir
  }

  table.set_class(C, CONN_CLASS)

  table.insert(LEVEL.conns, C)

  return C
end


function CONN_CLASS.tostr(C)
  return string.format("CONN_%d [%s%s]", C.id, C.kind,
         sel(C.is_cycle, "/cycle", ""))
end


function CONN_CLASS.roomstr(C)
  return string.format("CONN_%d [%s:%s --> %s]", C.id, C.kind,
         C.R1:tostr(), C.R2:tostr())
end


function CONN_CLASS.swap(C)
  C.A1, C.A2 = C.A2, C.A1
  C.S1, C.S2 = C.S2, C.S1

  if C.dir then
    C.dir = 10 - C.dir
  end
end


function CONN_CLASS.neighbor(C, A)
  if A == C.A1 then
    return C.A2
  else
    return C.A1
  end
end


function CONN_CLASS.get_seed(C, A)
  if A == C.A1 then
    return C.S1
  else
    return C.S2
  end
end


function CONN_CLASS.get_dir(C, A)
  if not C.dir then return nil end

  if A == C.A1 then
    return C.dir
  else
    return 10 - C.dir
  end
end


function CONN_CLASS.set_where(C, R, floor)
  if R == C.R1 then
    C.where1 = floor
  else
    C.where2 = floor
  end
end


function CONN_CLASS.get_where(C, R)
  if R == C.R1 then
    return C.where1
  else
    return C.where2
  end
end



function Connect_merge_groups(A1, A2)
  local gr1 = A1.conn_group
  local gr2 = A2.conn_group

--- stderrf("merge_groups %d <--> %d\n", gr1, gr2)

  assert(gr1 and gr2)
  assert(gr1 != gr2)

  if gr1 > gr2 then gr1,gr2 = gr2,gr1 end

  each A in LEVEL.areas do
    if A.conn_group == gr2 then
       A.conn_group = gr1
    end
  end
end



function Connect_raw_seed_pair(S, T, dir, reverse, allow_same_id)
--- stderrf("Connect_seed_pair: %s dir:%d\n", S:tostr(), dir)

  assert(S.area and T.area)

  local same_id = (S.area.conn_group == T.area.conn_group)

  if same_id then
    if not allow_same_id then
      error("Connect to same conn_group")
    end
  else
    Connect_merge_groups(S.area, T.area)
  end

  -- this used for stairwells, to ensure the other room builds the arch or door
  if reverse then
    S, T = T, S
    dir  = 10 - dir
  end

--[[
stderrf("  AREA_%d (group %d) <---> AREA_%d (group %d)\n",
S.area.id, S.area.conn_group,
T.area.id, T.area.conn_group)
--]]

  assert(S.room and S.room.kind != "scenic")
  assert(T.room and T.room.kind != "scenic")

  assert(S.room.kind != "DEAD")
  assert(T.room.kind != "DEAD")

  -- create connection object

  local CONN = CONN_CLASS.new("normal", S.area, T.area, dir)

  CONN.S1 = S
  CONN.S2 = T

  S.conn = CONN
  T.conn = CONN

  table.insert(CONN.A1.conns, CONN)
  table.insert(CONN.A2.conns, CONN)

  -- if areas have same group, mark connection as a Cycle
  if same_id then
    CONN.is_cycle = true
  end

  -- setup border info

  S.border[dir].kind = "arch"
  S.border[dir].conn = CONN

  T.border[10-dir].kind = "nothing"

  S.thick[dir] = 16
  T.thick[10-dir] = 16

  return CONN
end


function Connect_seed_pair(S, T, dir, reverse)
  if not T then
    T = S:neighbor(dir)
  end

  local conn1 = Connect_raw_seed_pair(S, T, dir, reverse)
  local conn2

  -- handle CTF maps
  -- Note: sometimes the mirrored connection will connect to the same group,
  --       that is OK and unvoidable -- conn2 will be marked as a cycle.
  
  if S.area.sister or S.area.brother or
     T.area.sister or T.area.brother
  then
    local S2 = assert(S.ctf_peer)
    local T2 = assert(T.ctf_peer)

    conn2 = Connect_raw_seed_pair(S2, T2, 10 - dir, reverse, "allow_same_id")

    -- peer the connections
    conn1.sister  = conn2
    conn2.brother = conn1
  end

  return conn1, conn2
end



function Connect_teleporters()
  
  local function eval_room(R)
    -- can only have one teleporter per room
    if R.teleport_conn then return -1 end

    -- never in a secret exit room
    if R.purpose == "SECRET_EXIT" then return -1 end

    -- score based on size, ignore if too small
    if R.sw < 3 or R.sh < 3 or R.svolume < 8 then return -1 end

    local v = math.sqrt(R.svolume)

    local score = 10 - math.abs(v - 5.5)

    return score + 2.1 * gui.random() ^ 2
  end


  local function collect_teleporter_locs()
    local list = {}

    each R in LEVEL.rooms do
      local score = eval_room(R)

      if score >= 0 then
        table.insert(list, { R=R, score=score })
      end
    end

    return list
  end


  local function connect_is_possible(R1, R2, mode)
    -- FIXME : use areas !!!
    if A1.conn_group == A2.conn_group then return false end

    return true
  end


  local function add_teleporter(R1, R2)
    -- FIXME : use areas !!!
    error("add_teleporter : is broken dude")

    gui.debugf("Teleporter connection: %s -- >%s\n", R1:tostr(), R2:tostr())

    Connect_merge_groups(A1, A2)

    local C = CONN_CLASS.new("teleporter", A1, A2)

    -- area fields are set when pads are placed in room

    table.insert(A1.conns, C)
    table.insert(A2.conns, C)

    C.tele_tag1 = alloc_id("tag")
    C.tele_tag2 = alloc_id("tag")

    A1.teleport_conn = C
    A2.teleport_conn = C
  end


  local function try_add_teleporter()
    local loc_list = collect_teleporter_locs()

    -- sort the list, best score at the front
    table.sort(loc_list, function(A, B) return A.score > B.score end)

    -- need at least a source and a destination
    while #loc_list >= 2 do

      local R1 = loc_list[1].R
      table.remove(loc_list, 1)

      -- try to find a room we can connect to
      each loc in loc_list do
        local R2 = loc.R

        if connect_is_possible(R1, R2, "teleporter") then
          add_teleporter(R1, R2)
          return true
        end
      end
    end

    return false
  end


  ---| Connect_teleporters |---

  -- check if game / theme supports them
  if not PARAM.teleporters or
     STYLE.teleporters == "none"
  then
    gui.printf("Teleporter quota: NONE\n", quota)
    return
  end

  -- determine number to make
  local quota = style_sel("teleporters", 0, 1, 2, 3.7)

  quota = quota * SEED_W / 16
  quota = quota + rand.skew() * 1.7

  quota = int(quota) -- round down

  gui.printf("Teleporter quota: %d\n", quota)

  for i = 1,quota do
    if not try_add_teleporter() then
      break;
    end
  end
end


----------------------------------------------------------------


function Weird_connect_stuff()


  local function where_can_connect(R1, R2)
    -- returns a list where two rooms can connect.
    -- R1 is always a hallway.
    -- result is a list containing: { S=seed, N=seed, dir=dir }

    local list = {}

    each A in R1.areas do
    each S in A.seeds do
    each dir in geom.ALL_DIRS do
      local N = S:neighbor(dir)

      if N and N.room == R2 then
        table.insert(list, { S=S, N=N, dir=dir })
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

    for loop = 1, 20 do
      local loc1 = rand.pick(where1)
      local loc2 = rand.pick(where2)

      local mx1, my1 = loc1.S:edge_coord(loc1.dir)
      local mx2, my2 = loc2.S:edge_coord(loc2.dir)

      local dist = geom.dist(mx1, my1, mx2, my2)

      dist = dist + gui.random() * 96

      if where1.S != where2.S then
        dist = dist + 256
      end

      if not best_dist or dist > best_dist then
        best_dist = dist
        best1 = loc1
        best2 = loc2
      end
    end

    assert(best1 and best2)

    return best1, best2
  end


  local function kill_hallway(R)
    R:kill_it()
  end


  local function connect_hallway_pair(R, N1, N2)
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


  local function eval_hallway_pair(R, N1, N2)
    -- two rooms are already connected?
    if N1.areas[1].conn_group == N2.areas[1].conn_group then
      return -1
    end

    -- hallways should never touch [ enforced in area.lua ]
    assert(not N1.is_hallway)
    assert(not N2.is_hallway)

    -- TODO : volume % of path through hallway

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

    -- this also handles N1 == N2
    if N1.conn_group == N2.conn_group then return false end

    --- OK !! ---

    R.kind = "stairwell"

    A.is_stairwell = well

--FIXME : support outdoor stairwells
A.is_outdoor = false

    E1.conn = Connect_seed_pair(E1.S, nil, E1.dir, "reverse")
    E2.conn = Connect_seed_pair(E2.S, nil, E2.dir, "reverse")

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


  local function try_connect_hallway(R)
    local neighbor_rooms = {}

    each A in R.areas do
      each N in A.neighbors do
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
      if R.is_hallway and not R.brother then
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


  local function check_all_connected()
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


  local function eval_normal_conn(S, dir)
    local N = S:neighbor(dir)

    if not (N and N.room) then return -1 end

    local A1 = S.area
    local A2 = N.area

    assert(A1.conn_group)
    assert(A2.conn_group)

    if A1.conn_group == A2.conn_group then return -2 end

    if A1.sister then
      local A2_peer = A2.sister or A2.brother
      assert(A2_peer)
      assert(A1.conn_group != A2.conn_group)
    end

    -- connection is possible, evaluate it --

    local R1 = A1.room
    local R2 = A2.room

    local score

    -- we done hallways already, no more please
    if R1.is_hallway and R2.is_hallway then
      score =  200
    elseif R1.is_hallway or R2.is_hallway then
      score = 1200
    else
      score = 2200
    end

    -- try not to have more than one connection in a seed
    if not (S.conn or N.conn) then
      score = score + 500
    end

    -- TODO : dist from existing room conns

    local conn_max = math.max(R1:total_conns(), R2:total_conns())

    if conn_max >= 4 then score = score - 100 end
    if conn_max >= 3 then score = score - 50 end
    if conn_max >= 2 then score = score - 10  end

    -- tie breaker
    return score + 15 * gui.random()
  end


  local function add_a_connection()
    local best_S
    local best_dir
    local best_score = 0

    each R in LEVEL.rooms do
    each A in R.areas do
    each S in A.seeds do

        -- only need to try half the directions
        -- [ hence in CTF maps must try the mirrored rooms too ]
        for dir = 6, 9 do
          local score = eval_normal_conn(S, dir)

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
  end


  local function handle_the_rest()
    while not check_all_connected() do
      add_a_connection()
    end
  end


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
      end
    end

    if not best_A1 then
      error("Failed to internally connect " .. R:tostr())
    end

    -- OK --

    local A1 = best_A1
    local A2 = best_A2

    local S, dir = pick_internal_seed(R, A1, A2)

    Connect_seed_pair(S, nil, dir)
  end


  local function internal_connections(R)
    -- connect the areas inside each room (including hallways)

    while not check_internally_connected(R) do
      make_an_internal_connection(R)
    end

    if R.sister then
      assert(check_internally_connected(R.sister))
    end
  end


  ---| Weird_connect_stuff |---

  -- give each area of each room a conn_group
  each A in LEVEL.areas do
    if A.room then
      A.conn_group = A.id
    end
    A.teleports = {}
  end

  each R in LEVEL.rooms do
    if not R.brother then
      internal_connections(R)
    end
  end

  handle_hallways()

  --TODO teleporters

  handle_the_rest()  
end

