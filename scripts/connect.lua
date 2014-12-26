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
  kind : keyword  -- "normal",  "closet"
                  -- "teleporter"

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



function Connect_merge_groups(id1, id2)
  if id1 > id2 then id1,id2 = id2,id1 end

  each A in LEVEL.areas do
    if A.conn_group == id2 then
       A.conn_group = id1
    end
  end
end


function Connect_seed_pair(S, T, dir)
  if not T then
    T = S:diag_neighbor(dir)
  end

-- stderrf("Connect_seed_pair: %s dir:%d\n", S:tostr(), dir)
  assert(S.area and T.area)

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

  table.insert(S.room.conns, CONN)
  table.insert(T.room.conns, CONN)

  -- setup border info

  S.border[dir].kind = "arch"
  S.border[dir].conn = CONN

  T.border[10-dir].kind = "nothing"

  S.thick[dir] = 16
  T.thick[10-dir] = 16

  return CONN
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

    Connect_merge_groups(A1.conn_group, A2.conn_group)

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


function Connect_start_room()

  local function eval_start(R)
    -- already has a purpose? (e.g. secret exit room)
    if R.purpose then return -1 end

    if R.is_hallway then return -1 end

    local score = 0

    -- not too small
    if R.total_inner_points >= 5 then score = score + 16 end

    -- not too big !!
    if R.svolume <= 49 then score = score + 6 end

    if not R.teleport_conn then score = score + 8 end

    -- prefer a room where could have a start closet
--TODO  if R:touches_void_area() then score = score + 4 end

    -- tie breaker
    return score + gui.random() * 4
  end


  ---| Connect_start_room |---

  local locs = {}

  each R in LEVEL.rooms do
    R.start_score = eval_start(R)

    gui.debugf("Start score @ %s (seeds:%d) --> %1.3f\n", R:tostr(), R.sw * R.sh, R.start_score)

    if R.start_score >= 0 then
      table.insert(locs, R)
    end
  end

  assert(#locs > 0)

  local room = table.pick_best(locs,
    function(A, B) return A.start_score > B.start_score end)

  gui.printf("Start room: %s\n", room:tostr())

  LEVEL.start_room = room
  LEVEL.start_area = room.areas[1]  -- FIXME

  room.purpose = "START"

  -- TODO: try add starting closet
end


function Connect_natural_flow()
  --
  -- Update connections so that 'src' and 'dest' follow the natural
  -- flow of the level, i.e. player always walks from src --> dest
  -- (except when backtracking).
  --
  -- The LEVEL.rooms list is also updated to be in visit order.
  --

  local function recursive_flow(A, seen)
--- stderrf("natural_flow @ AREA_%s\n", A.id)

    assert(A.room)

    if not A.room.visit_id then
      A.room.visit_id = alloc_id("visit_id")
    end

    seen[A] = true

---???    if A.mode == "closet" then return end

    each C in A.conns do
      if A == C.A2 and not seen[C.A1] then
        C:swap()
      end

      if A == C.A1 and not seen[C.A2] then
        C.A2.entry_conn = C

        -- recursively handle adjacent room
        recursive_flow(C.A2, seen)
      end
    end
  end


  ---| Connect_natural_flow |---

  recursive_flow(LEVEL.start_area, 1, {})

  table.sort(LEVEL.rooms,
      function(A, B) return A.visit_id < B.visit_id end)
end


----------------------------------------------------------------


function Connect_reserved_rooms()
  --
  -- This handled reserved rooms, which have been ignored so far.
  -- If the level requires a secret exit, one will be used for it.
  -- Otherwise they can be become plain secrets, storage rooms, or
  -- just something to look at (scenic rooms).
  --

  local best


  local function change_room_kind(R, kill_it)
    if R.is_outdoor then
      R.kind = "outdoor"
    else
      R.kind = "building"
    end

    R.num_branch = 1

    if kill_it then
      table.kill_elem(LEVEL.reserved_rooms, R)
    end

    table.insert(LEVEL.rooms, R)
  end


  local function change_room_to_scenic(R)
    R.kind = "scenic"

    R.is_outdoor = true

    table.insert(LEVEL.scenic_rooms, R)

    gui.debugf("Converted %s --> Scenic\n", R:tostr())
  end


  local function eval_conn_for_secret_exit(R, S, dir, N)
    local R2 = N.room

    if R2.kind == "scenic"   then return end
    if R2.kind == "reserved" then return end

    if N.conn then return end

    local score = 10 * (R2.quest.id / #LEVEL.quests)

    -- even better if other room is a secret
    if R2.quest.super_secret then
      score = score + 20
    elseif R2.quest.kind == "secret" then
      score = score + 8
    end

    -- tie-breaker
    score = score + gui.random() * 2

    if score > best.score then
      best.score = score
      best.R = R
      best.S = S
      best.dir = dir
    end
  end


  local function evaluate_secret_exit(R)
    for sx = R.sx1, R.sx2 do
    for sy = R.sy1, R.sy2 do
      for dir = 2,8,2 do

        local S = SEEDS[sx][sy]

        if S.room != R then continue end

        local N = S:neighbor(dir)

        if (N and N.room and N.room != R) then
          eval_conn_for_secret_exit(R, S, dir, N)
        end

      end -- dir
    end -- sx, sy
    end
  end


  local function pick_secret_exit()
    best = { score=-1 }

    each R in LEVEL.reserved_rooms do
      evaluate_secret_exit(R)    
    end
  end


  local function make_secret_exit()
    -- this can happen because the reserved room gets surrounded by
    -- scenic rooms (due to the connection logic).
    if not best.R then
      warning("Could not add secret exit (reserved room got cut off)\n")
      return
    end

    local R = best.R
    local S = best.S

    gui.debugf("Secret exit @ %s  (%d %d)\n", R:tostr(), R.sx1, R.sy1)

    change_room_kind(R, "kill_it")

    R.purpose = "SECRET_EXIT"
    R.is_secret = true


    -- actually connect the rooms
    local T = S:neighbor(best.dir)

    R.entry_conn = Connect_seed_pair(T, S, 10 - best.dir)


    -- create quest, link room into quest and zone
    R.zone  = T.room.zone
    R.quest = Quest_new(R)

    R.quest.kind = "secret"

    if T.room.is_secret then
      R.quest.super_secret = true
    end

    table.insert(R.quest.rooms, R)
    table.insert(R. zone.rooms, R)
  end


  local function eval_conn_for_alt_start(R, S, dir, N)
    local R2 = N.room

    if R2.kind == "scenic"   then return end
    if R2.kind == "reserved" then return end

    if N.conn then return end

    -- other room must be belong to the very first quest
    if R2.quest != LEVEL.start_room.quest then return end

    local score = 50

    if R2 == LEVEL.start_room then
      score = 30
    elseif R2.purpose then
      score = 40
    end

    -- prefer smaller rooms
    score = score - math.sqrt(R.svolume) * 2

    -- TODO: check if this doorway would be near another one

    -- tie-breaker
    score = score + gui.random() * 5

    if score > best.score then
      best.score = score
      best.R = R
      best.S = S
      best.dir = dir
    end
  end


  local function evaluate_alt_start(R)
    for sx = R.sx1, R.sx2 do
    for sy = R.sy1, R.sy2 do
      for dir = 2,8,2 do

        local S = SEEDS[sx][sy]

        if S.room != R then continue end

        local N = S:neighbor(dir)

        if (N and N.room and N.room != R) then
          eval_conn_for_alt_start(R, S, dir, N)
        end

      end -- dir
    end -- sx, sy
    end
  end


  local function make_alternate_start()
    local R = best.R
    local S = best.S

    gui.debugf("Alternate Start room @ %s (%d %d)\n", R:tostr(), R.sx1, R.sy1)

    LEVEL.alt_start = R

    change_room_kind(R, "kill_it")

    R.purpose = "START"


    -- actually connect the rooms
    local T = S:neighbor(best.dir)

    R.entry_conn = Connect_seed_pair(T, S, 10 - best.dir)


    -- link room into the level
    R.quest = T.room.quest
    R.zone  = T.room.zone

    -- place on end of room lists (ensuring it is laid out AFTER
    -- the room it connects to).
    table.insert(R.quest.rooms, R)
    table.insert(R. zone.rooms, R)


    -- partition players between the two rooms.  Since Co-op is often
    -- played by two people, have a large tendency to place 'player1'
    -- and 'player2' in different rooms.

    local set1, set2

    if rand.odds(10) then
      set1 = { "player1", "player2", "player5", "player6" }
      set2 = { "player3", "player4", "player7", "player8" } 
    elseif rand.odds(50) then
      set1 = { "player1", "player3", "player5", "player7" }
      set2 = { "player2", "player4", "player6", "player8" } 
    else
      set1 = { "player1", "player4", "player6", "player7" }
      set2 = { "player2", "player3", "player5", "player8" } 
    end

    if rand.odds(50) then
      set1, set2 = set2, set1
    end

    LEVEL.start_room.player_set = set1
    LEVEL.alt_start .player_set = set2
  end


  local function find_alternate_start()
    best = { score=-1 }

    each R in LEVEL.reserved_rooms do
      evaluate_alt_start(R)
    end

    if best.R then
      make_alternate_start()
    end
  end


  local function eval_conn_for_other(R, S, dir, N)
    local R2 = N.room

    if R2.kind == "scenic"   then return end
    if R2.kind == "reserved" then return end

    -- cannot build a storage room off a secret
    if R.is_secret and not R2.is_secret then return end

    if N.conn then return end

    local score = 20

    -- TODO: check if this doorway would be near another one

    -- tie-breaker
    score = score + gui.random() * 5

    if score > best.score then
      best.score = score
      best.R = R
      best.S = S
      best.dir = dir
    end
  end


  local function evaluate_other(R)
    for sx = R.sx1, R.sx2 do
    for sy = R.sy1, R.sy2 do
      for dir = 2,8,2 do

        local S = SEEDS[sx][sy]

        if S.room != R then continue end

        local N = S:neighbor(dir)

        if (N and N.room and N.room != R) then
          eval_conn_for_other(R, S, dir, N)
        end

      end -- dir
    end -- sx, sy
    end
  end


  local function convert_other(R)
    -- decide what to convert it into...

    local secret_prob = style_sel("secrets", 0, 25, 50, 90)
    local scenic_prob = style_sel("scenics", 0, 20, 40, 80)

    R.is_secret = rand.odds(secret_prob)

    if not R.is_secret and rand.odds(scenic_prob) then
      change_room_to_scenic(R)
      return
    end


    -- find where to connect to rest of map
    best = { score=-1 }

    evaluate_other(R)

    if not best.R then
      change_room_to_scenic(R)
      return
    end

    change_room_kind(R)


    -- actually connect the rooms
    local S = best.S
    local T = S:neighbor(best.dir)

    R.entry_conn = Connect_seed_pair(T, S, 10 - best.dir)

    R.zone = T.room.zone


    if R.is_secret then
      -- create a secret quest
      R.quest = Quest_new(R)
      R.quest.kind = "secret"

      if T.room.is_secret then
        R.quest.super_secret = true
      end

      table.insert(R.quest.secret_leafs, R)

      gui.debugf("Converted %s --> SECRET\n", R:tostr())
    else
      -- make storage
      R.quest = T.room.quest

      R.is_storage = true

      table.insert(R.quest.storage_leafs, R)

      gui.debugf("Converted %s --> Storage\n", R:tostr())
    end

    -- link room into quest and zone
    table.insert(R.quest.rooms, R)
    table.insert(R. zone.rooms, R)
  end


  ---| Connect_reserved_rooms |---

  if LEVEL.secret_exit then
    pick_secret_exit()
    make_secret_exit()
  end

  if OB_CONFIG.mode == "coop" then
    find_alternate_start()
  end

  each R in LEVEL.reserved_rooms do
    convert_other(R)
  end

  LEVEL.reserved_rooms = {}
end


------------------------------------------------------------------------


function Weird_connect_stuff()


  local function where_can_connect(R1, R2)
    -- returns a list where two rooms can connect.
    -- R1 is always a hallway.
    -- result is a list containing: { S=seed, N=seed, dir=dir }

    local list = {}

    each A in R1.areas do
    each S in A.half_seeds do
    each dir in geom.ALL_DIRS do
      local N = S:diag_neighbor(dir)

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

      local mx1, my1 = loc1.S:mid_point()
      local mx2, my2 = loc2.S:mid_point()

      local dist = geom.dist(mx1, my1, mx2, my2)

      dist = dist + gui.random()

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
    assert(N1.c_group != R.c_group)
    assert(N2.c_group != R.c_group)

    local where1 = where_can_connect(R, N1)
    local where2 = where_can_connect(R, N2)

    assert(not table.empty(where1))
    assert(not table.empty(where2))

    local loc1, loc2 = pick_hallway_conn_spots(R, where1, where2)

    Connect_merge_groups(R.c_group, N1.c_group)
    Connect_merge_groups(R.c_group, N2.c_group)

    Connect_seed_pair(loc1.S, loc1.N, loc1.dir)
    Connect_seed_pair(loc2.S, loc2.N, loc2.dir)

    return true
  end


  local function eval_hallway_pair(R, N1, N2)
    -- two rooms are already connected?
    if N1.c_group == N2.c_group then
      return -1
    end

    -- hallways should never touch [ enforced in area.lua ]
    assert(not N1.is_hallway)
    assert(not N2.is_hallway)

    -- TODO : scoring of a hallway pair
    --        e.g. volume % of path through the hallway

    local score = 100

    -- tie breaker
    return score + gui.random()
  end


  local function try_specific_stairwell(R, A, well)
    local outer_edges = A.edge_loops[1]

    local E1 = outer_edges[well.edge1]
    local E2 = outer_edges[well.edge2]

    assert(E1 and E2)
    assert(E1 !=  E2)

    -- TODO : handle WIDE edges

    local N1 = E1.S:diag_neighbor(E1.dir)
    local N2 = E2.S:diag_neighbor(E2.dir)

    if not (N1 and N1.area and N1.area.room) then return false end
    if not (N2 and N2.area and N2.area.room) then return false end

    N1 = N1.area.room
    N2 = N2.area.room

    assert(N1 != R)
    assert(N2 != R)

    -- this also handles N1 == N2
    if N1.c_group == N2.c_group then return false end

    --- OK !! ---

    R.kind = "stairwell"

    A.is_stairwell = well

    Connect_merge_groups(R.c_group, N1.c_group)
    Connect_merge_groups(R.c_group, N2.c_group)

    E1.conn = Connect_seed_pair(E1.S, nil, E1.dir)
    E2.conn = Connect_seed_pair(E2.S, nil, E2.dir)

    return true
  end


  local function try_make_a_stairwell(R)
    -- if two or more areas were merged, cannot make a stairwell
    if #R.areas > 1 then return false end

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

        if R2.c_group != R.c_group then
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
    end
  end


  local function handle_hallways()
    -- we handle all the hallways first, as sometimes it will not be
    -- possible to use a hallway (which requires connecting two previously
    -- unconnected groups) -- these hallways need to be detected early
    -- and merged into a normal room (or turned into VOID).

    -- visit from biggest to smallest
    -- (so less chance of needing to kill a large hallway)
    local visit_list = table.copy(LEVEL.rooms)

    -- randomize size (tie breaker)
    each R in visit_list do
      R.h_order = R.svolume + gui.random()
    end

    table.sort(visit_list, function(R1, R2)
        return R1.h_order > R2.h_order
    end)

    each R in visit_list do
      if R.is_hallway then
        if not try_make_a_stairwell(R) then
          try_connect_hallway(R)
        end
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
    local N = S:diag_neighbor(dir)

    if not (N and N.room) then return -1 end

    local A1 = S.area
    local A2 = N.area

    assert(A1.conn_group)
    assert(A2.conn_group)

    if A1.conn_group == A2.conn_group then return -2 end

    -- connection is possible, evaluate it --

    local score = 1

    -- we done hallways already, no more please
    if R1.is_hallway and R2.is_hallway then
      -- score = 1
    elseif R1.is_hallway or R2.is_hallway then
      score = 1000
    else
      score = 2000
    end

    -- try not to have more than one connection in a seed
    if not (S.conn or N.conn) then
      score = score + 500
    end

    -- TODO : more stuff, e.g. dist from existing conns

    -- prefer not making big hubs
    local conn_max = math.max(#R1.conns, #R2.conns, 8)
    score = score + (8 - conn_max) * 5

    -- tie breaker
    return score + 12 * gui.random()
  end


  local function add_a_connection()
    local best_S
    local best_dir
    local best_score = 0

    each A in LEVEL.areas do
      if not A.room then continue end

      each S in A.half_seeds do

        -- only need to try half the directions
        for dir = 6, 9 do
          local score = eval_normal_conn(S, dir)

          if score > best_score then
            best_S = S
            best_dir = dir
            best_score = score
          end
        end
      end 
    end

    -- perform the connection --

    if not best_S then
      error("Unable to find place for connection!")
    end

    local N = best_S:diag_neighbor(best_dir)

    local A1 = assert(best_S.area)
    local A2 = assert(N.area)

    Connect_merge_groups(A1.conn_group, A2.conn_group)

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

    if #A1.half_seeds > #A2.half_seeds then
      A1, A2 = A2, A1
    end

    local seed_list = rand.shuffle(table.copy(A1.half_seeds))

    each S in seed_list do
      rand.shuffle(DIRS)

      each dir in DIRS do
        local N = S:diag_neighbor(dir)

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


    local S, dir = pick_internal_seed(R, best_A1, best_A2)

    Connect_merge_groups(A1.conn_group, A2.conn_group)

    Connect_seed_pair(S, nil, dir)
  end


  local function internal_connections(R)
    -- connect the areas inside each room (including hallways)

    while not check_internally_connected(R) do
      make_an_internal_connection()   
    end
  end


  ---| Weird_connect_stuff |---

  -- give each area of each room a conn_group 
  each A in LEVEL.areas do
    A.conn_group = A.id
    A.teleports = {}
  end

  each R in LEVEL.rooms do
    internal_connections(R)
  end

  handle_hallways()

  --TODO teleporters

  handle_the_rest()  

  Connect_start_room()
  Connect_natural_flow()
end

