------------------------------------------------------------------------
--  CONNECTIONS
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2011 Andrew Apted
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
  kind   : keyword  -- "direct", "hallway", "teleporter"

  lock   : LOCK

  id : number  -- debugging aid

  -- The two rooms are the vital (compulsory) information,
  -- especially for the quest system.  For teleporters the
  -- other info (sections and dir1/dir2) may be absent.

  R1, R2 : ROOM
  K1, K2 : SECTION
  C1, C2 : CHUNK   -- decided later (at chunk creation)

  hall      : HALLWAY
  crossover : CROSSOVER

  dir1, dir2  -- direction value (2/4/6/8) 
              -- dir1 leading out of R1 / K1 / C1
              -- dir2 leading out of R2 / K2 / C2

  is_cycle : boolean

  conn_h  -- floor height for connection
}


--------------------------------------------------------------]]

require 'defs'
require 'util'


CONN_CLASS = {}

function CONN_CLASS.new(kind, R1, R2, dir)
  local D = { kind=kind, R1=R1, R2=R2 }
  D.id = Plan_alloc_id("conn")
  table.set_class(D, CONN_CLASS)
  if dir then
    D.dir1 = dir
    D.dir2 = 10 - dir
  end
  return D
end


function CONN_CLASS.tostr(D)
  return string.format("CONN_%d [%d > %d]", D.id, D.R1.id, D.R2.id)
end


function CONN_CLASS.dump(D)
  gui.debugf("%s =\n", D:tostr())
  gui.debugf("{\n")
  gui.debugf("    K1 = %s\n", (D.K1 ? D.K1:tostr() ; "nil"))
  gui.debugf("    K2 = %s\n", (D.K2 ? D.K2:tostr() ; "nil"))
  gui.debugf("    C1 = %s\n", (D.C1 ? D.C1:tostr() ; "nil"))
  gui.debugf("    C2 = %s\n", (D.C2 ? D.C2:tostr() ; "nil"))
  gui.debugf("  dir1 = %s\n", (D.dir1 ? tostring(D.dir1) ; "nil"))
  gui.debugf("  dir2 = %s\n", (D.dir2 ? tostring(D.dir2) ; "nil"))
  gui.debugf("   cyc = %s\n", string.bool(D.is_cycle))
  gui.debugf("}\n")
end


function CONN_CLASS.neighbor(D, R)
  return (R == D.R1 ? D.R2 ; D.R1)
end


function CONN_CLASS.section(D, R)
  return (R == D.R1 ? D.K1 ; D.K2)
end


function CONN_CLASS.what_dir(D, R)
  if D.dir1 then
    return (R == D.R1 ? D.dir1 ; D.dir2)
  end
end


function CONN_CLASS.swap(D)
  D.R1, D.R2 = D.R2, D.R1
  D.K1, D.K2 = D.K2, D.K1
  D.C1, D.C2 = D.C2, D.C1

  D.dir1, D.dir2 = D.dir2, D.dir1

  if D.hall and D.hall.R1 != D.R1 then D.hall:reverse() end
end


function CONN_CLASS.k_coord(D)
  return (D.K1.kx + D.K2.kx) / 2,
         (D.K1.ky + D.K2.ky) / 2
end


------------------------------------------------------------------------


function Connect_decide_start_room()

  local function eval_room(R)
    local cost = R.sw * R.sh

    cost = cost + #R.conns * 40

    cost = cost + 10 * (gui.random() ^ 2)

    gui.debugf("Start cost @ %s (seeds:%d) --> %1.3f\n", R:tostr(), R.sw * R.sh, cost)

    return cost
  end

  ---| Connect_decide_start_room |---

  each R in LEVEL.rooms do
    R.start_cost = eval_room(R)
  end

  local start, index = table.pick_best(LEVEL.rooms,
    function(A, B) return A.start_cost < B.start_cost end)

  gui.printf("Start room: %s\n", start:tostr())

  -- move it to the front of the list
  table.remove(LEVEL.rooms, index)
  table.insert(LEVEL.rooms, 1, start)

  LEVEL.start_room = start

  start.purpose = "START"
end



function Connect_possibility(R1, R2)
  -- check if connecting two rooms is possible.
  -- returns: -1 : not possible
  --           0 : possible but not good
  --          +1 : possible and good

  if not (R1 and R2) then return -1 end

  -- already connected?
  if R1.conn_group == R2.conn_group then return -1 end

  local is_good = true

  for pass = 1,2 do
    local R = (pass == 1 ? R1 ; R2)

    if R.kind == "scenic" then return -1 end

    -- only one way out of the starting room (unless large)
    if R.purpose == "START" and #R.conns >= 1 then
      if R.svolume < 9 then return -1 end
      is_good = false
    end

    -- more than 4 connections is usually too many
    if R.full or (#R.conns >= 4 and not R.natural) then
      is_good = false
    end

    -- don't fill small rooms with lots of connections
    if R.sw <= 4 and R.sh <= 4 and #R.conns >= 3 then
      is_good = false
    end
  end

  return (is_good ? 1 ; 0)
end



function Connect_merge_groups(id1, id2)
  if id1 > id2 then id1,id2 = id2,id1 end

  each R in LEVEL.rooms do
    if R.conn_group == id2 then
      R.conn_group = id1
    end
  end
end



function Connect_rooms()

  -- a "branch" is a room with 3 or more connections.
  -- a "stalk"  is a room with two connections.

  local function initial_groups()
    each R in LEVEL.rooms do
      R.conn_group = _index
    end
  end


  local function already_connected(K1, K2)
    if not (K1 and K2 and K1.room) then return false end
    
    each D in K1.room.conns do
      if (D.K1 == K1 and D.K2 == K2) or
         (D.K1 == K2 and D.K2 == K1)
      then
        return true
      end
    end
  end


  local function can_connect(K1, dir)
    if not K1 then return false end

    local MID = K1:neighbor(dir)
    if not MID or MID.used then return false end

    local K2 = K1:neighbor(dir, 2)
    if not K2 then return false end

    -- sections must be touching
--[[  -- NOTE: sections don't move in new logic  (JUNE 2011)
    if K1.sx1 > K2.sx2 + 1 then return false end
    if K2.sx1 > K1.sx2 + 1 then return false end
    if K1.sy1 > K2.sy2 + 1 then return false end
    if K2.sy1 > K1.sy2 + 1 then return false end
--]]
    return Connect_possibility(K1.room, K2.room) >= 0
  end


  local function good_connect(K1, dir)
    if not can_connect(K1, dir) then return false end

    local K2 = K1:neighbor(dir, 2)

    return Connect_possibility(K1.room, K2.room) > 0
  end


  local function add_connection(K1, K2, dir)
    local R = assert(K1.room)
    local N = assert(K2.room)

    gui.printf("Connection from %s --> %s\n", K1:tostr(), K2:tostr())
    gui.debugf("Possibility value: %d\n", Connect_possibility(R, N))

    Connect_merge_groups(R.conn_group, N.conn_group)

    local D = CONN_CLASS.new("direct", R, N, dir)

    D.K1 = K1 ; D.K2 = K2

    table.insert(LEVEL.conns, D)

    table.insert(R.conns, D)
    table.insert(N.conns, D)

    K1.num_conn = K1.num_conn + 1
    K2.num_conn = K2.num_conn + 1

    -- setup the section in the middle
    local MID
    if true then
      MID = assert(K1:neighbor(dir))

      MID.conn = D ; D.middle = MID 

      Hallway_simple(K1, MID, K2, D, dir)
    end

    return D
  end


  local function can_make_crossover(K1, dir)
    -- TODO: support right angle turn or zig-zag

    local MID_A = K1:neighbor(dir, 1)
    local MID_B = K1:neighbor(dir, 3)

    if not MID_A or MID_A.used then return false end
    if not MID_B or MID_B.used then return false end

    local K2 = K1:neighbor(dir, 2)
    local K3 = K1:neighbor(dir, 4)

    if not K2 or not K2.room or K2.room == K1.room then return false end
    if not K3 or not K3.room or K3.room == K1.room or K3.room == K2.room then return false end

    -- limit of one per room
    -- [cannot do more since crossovers limit the floor heights and
    --  two crossovers can lead to an unsatisfiable range]
    if K2.room.crossover then return false end

    local poss = Connect_possibility(K1.room, K3.room)
    if poss < 0 then return false end

    -- size check
    local long, deep = K2.sw, K2.sh
    if geom.is_horiz(dir) then long, deep = deep, long end

    if long < 3 or deep > 4 then return false end

    -- TODO: evaluate the goodness (e.g. poss == 1) and return score

    return true
  end


  local function add_crossover(K1, dir)
    local MID_A = K1:neighbor(dir, 1)
    local MID_B = K1:neighbor(dir, 3)

    local K2 = K1:neighbor(dir, 2)
    local K3 = K1:neighbor(dir, 4)

    gui.printf("!!!!!! Crossover %s --> %s --> %s\n", K1:tostr(), K2:tostr(), K3:tostr())

    local R = K1.room
    local N = K3.room

    Connect_merge_groups(R.conn_group, N.conn_group)

    local D = CONN_CLASS.new("crossover", R, N, dir)

    D.K1 = K1 ; D.K2 = K3

    local CROSSOVER =
    {
      conn = D

      MID_A = MID_A
      MID_B = MID_B
      MID_K = K2
    }

    D.crossover = CROSSOVER
    K2.room.crossover = CROSSOVER

    table.insert(LEVEL.conns, D)

    table.insert(R.conns, D)
    table.insert(N.conns, D)

    K1.num_conn = K1.num_conn + 1
    K3.num_conn = K3.num_conn + 1

    -- setup the middle pieces  [FIXME: FIX THIS SHIT]
    -- Note: this will mark the MID_A/B sections as used
    local crap_A = {}
    local crap_B = {}

    Hallway_simple(K1, MID_A, K2, crap_A, dir)
    Hallway_simple(K2, MID_B, K3, crap_B, dir)

    CROSSOVER.hall_A = crap_A.hall
    CROSSOVER.hall_B = crap_B.hall

    -- allocate the chunk in the crossed-over room
    -- [TODO: this may be an overly cautious approach, but it does
    --        keep the logic fairly simple for now]
    -- TODO II: probably move this into AREA code

    local sx1, sy1
    local sx2, sy2

    if geom.is_vert(dir) then
      sx1 = math.i_mid(K2.sx1, K2.sx2)
      sx2 = sx1

      sy1 = K2.sy1
      sy2 = K2.sy2
    else
      sy1 = math.i_mid(K2.sy1, K2.sy2)
      sy2 = sy1

      sx1 = K2.sx1
      sx2 = K2.sx2
    end

    local C = K2.room:alloc_chunk(sx1,sy1, sx2,sy2)

    C.foobage = "crossover"
    C.crossover = CROSSOVER

    CROSSOVER.chunk = C
  end


  local function conn_is_possible(R, K, dir)
    -- FIXME !!!!!
  end


  local function try_make_exit(R, K, dir)
    -- FIXME !!!!!
  end


  local function eval_big_exit(R, K, dir)
    -- check if direction is unique
    local uniq_dir = true

    each D in R.conns do
      if D.R1 == R and D.dir1 == dir then
        uniq_dir = false ; break
      end
    end

    local rand = ((uniq_dir ? 1 ; 0) + gui.random()) / 2

    -- a free section please
    if K.num_conn > 0 then
      return rand
    end

    -- a "foot" is a section sticking out (three non-room neighbors).
    -- these are considered the best possible place for an exit
    local foot_dir = K:is_foot()

    if foot_dir then
      return (foot_dir == dir ? 9 ; 8) + rand 
    end

    -- sections far away from existing connections are preferred
    local conn_d = R:dist_to_closest_conn(K, dir)

    conn_d = conn_d / 2  -- adjust for hallway channels

    if conn_d > 4 then conn_d = 4 end

    -- an "uncrowded middler" is the middle of a wide edge and does
    -- not have any neighbors with connections
    if K:same_room(geom.RIGHT(dir)) and
       K:same_room(geom. LEFT(dir)) and conn_d >= 2
    then
      return 7 + rand
    end

    -- all other cases
    return 6 - conn_d + rand
  end


  local function try_add_big_exit(R)
    local exits = {}

    each K in R.sections do
      if K.kind != "section" then continue end

      for dir = 2,8,2 do
        if not conn_is_possible(R, K, dir) then continue end

        local score = eval_big_exit(R, K, dir)

        if score >= 0 then
          table.insert(exits, { K=K, dir=dir, score=score })
        end
      end
    end

    table.sort(exits, function(A, B) return A.score > B.score end)

    each EX in exits do
      if try_make_exit(R, EX.K, EX.dir) then
        return true -- SUCCESS
      end
    end

    return false -- fail
  end


  local function visit_big_room(R)
    -- determine number of connections to try
    local want_conn

    if R.shape == "rect" or R.shape == "odd" then
      if R.map_volume <= 4 then
        want_conn = 2
      elseif R.map_volume <= rand.sel(30, 8, 9) then
        want_conn = 3
      else
        want_conn = 4
      end

    else -- shaped room
      if R.shape == "L" or R.shape == "S" then
        want_conn = 2
      elseif R.shape == "plus" or R.shape == "H" then
        want_conn = 4
      else
        want_conn = 3
      end
    end

    want_conn = want_conn - #R.conns  -- FIXME: include teleporters here?

    -- try to add them, aborting on a failure
    for i = 1,want_conn do
      if not try_add_big_exit(R) then
        break
      end
    end

    R.full = true
  end


  local function branch_big_rooms()
    local visits = table.copy(LEVEL.rooms)

    each R in visits do
      R.big_score = R.map_volume + 2.5 * gui.random() ^ 2
    end

    table.sort(visits, function(A, B) return A.big_score > B.big_score end)

    each R in visits do
      if R.kw >= 3 and R.kh >= 3 then
        visit_big_room(R)
      end
    end
  end


  local function eval_normal_exit(R, K, dir)
    if not can_connect(K, dir) then return -1 end

    local score = 0

    if good_connect(K, dir) then
      score = score + 10
    end

    local N = K:neighbor(dir, 2)
    assert(N and N.room)

    local total_conn = K.num_conn + N.num_conn

    if total_conn == 0 then
      score = score + 5 - math.min(total_conn, 5)
    end

    return score + gui.random() , N
  end


  local function try_normal_branch()
    local loc
    local cross_loc

    for mx = 1,MAP_W do for my = 1,MAP_H do
      local K = SECTIONS[mx*2][my*2]
      local count = 0

      if not K.room then continue end

      for dir = 2,8,2 do
        local score, N = eval_normal_exit(K.room, K, dir)

        if score >= 0 then count = count + 1 end

        if score >= 0 and (not loc or score > loc.score) then
          loc = { K=K, N=N, dir=dir, score=score }
        end

        -- Cross-Over checks --

        -- FIXME: check THEME.bridges (prefab skins) too
        if not PARAM.bridges then continue end
        if STYLE.crossovers == "none" then continue end

        local cross_score = -1
        if can_make_crossover(K, dir) then cross_score = gui.random() end

        if cross_score >= 0 and (not cross_loc or cross_score > cross_loc.score) then
          cross_loc = { K=K, dir=dir, score=cross_score }
        end

      end
    end end -- mx, my

    -- make a crossover?
    if cross_loc and (STYLE.crossovers == "heaps" or rand.odds(24)) then
      add_crossover(cross_loc.K, cross_loc.dir)
      return true
    end

    -- nothing possible? hence we are done
    if not loc then return false end

-- stderrf("Normal branch: %s --> %s  score:%1.2f\n", loc.K:tostr(), loc.N:tostr(), loc.score)

    add_connection(loc.K, loc.N, loc.dir)

    return true
  end


  local function add_teleporter(R1, R2)
    gui.debugf("Teleporter connection %s -- >%s\n", R1:tostr(), R2:tostr())

    Connect_merge_groups(R1.conn_group, R2.conn_group)

    local D = CONN_CLASS.new("teleporter", R1, R2)

    table.insert(LEVEL.conns, D)

    table.insert(R1.conns, D)
    table.insert(R2.conns, D)

    D.tele_tag1 = Plan_alloc_id("tag")
    D.tele_tag2 = Plan_alloc_id("tag")
  end


  local function eval_teleporter_room(R)
    -- no teleporters already
    if R:has_teleporter() then return -1 end

    if #R.conns > 0 then return -1 end

    -- too small?
    if R.sw <= 2 or R.sh <= 2 then return -1 end

    local score = 0

    if R.purpose == "START" then score = score + 0.3 end

    -- better if more than one section
    if R.kvolume >= 2 then score = score + 0.8 end

    return score + gui.random()
  end


  local function collect_teleporter_locs()
    local loc_list = {}

    each R in LEVEL.rooms do
      local score = eval_teleporter_room(R)
      if score > 0 then
        table.insert(loc_list, { R=R, score=score })
      end
    end

    table.sort(loc_list, function(A, B) return A.score > B.score end)

    return loc_list
  end


  local function try_add_teleporter(loc_list)
    -- need at least a source and destination
    if #loc_list < 2 then return false end

    local R = loc_list[1].R
    table.remove(loc_list, 1)

    for index,loc in ipairs(loc_list) do
      local N = loc.R

      if R.conn_group != N.conn_group and
         eval_teleporter_room(N) >= 0
      then
        add_teleporter(R, N)

        table.remove(loc_list, index)
        return true
      end
    end

    return false
  end


  local function decide_teleporters()
    LEVEL.teleporter_list = {}

do return end --!!!!!! FIXME

    if not THEME.teleporters then return end

    if STYLE.teleporters == "none" then return end

    local quota = 2

    if STYLE.teleporters == "few"   then quota = 1 end
    if STYLE.teleporters == "heaps" then quota = 5 end

    gui.debugf("Teleporter quota: %d\n", quota)

    local loc_list = collect_teleporter_locs()

    for i = 1,quota*3 do
      if try_add_teleporter(loc_list) then
        quota = quota - 1
        if quota <= 0 then break; end
      end
    end
  end


  local function count_groups()
    local groups = {}

    each R in LEVEL.rooms do
      if R.conn_group then
        groups[R.conn_group] = 1
      end
    end

    return table.size(groups)
  end


  local function get_group_counts()
    local groups = {}

    for i = 1,999 do groups[i] = 0 end

    local last_g = 0

    each R in LEVEL.rooms do
      if R.kind != "scenic" then
        local g = R.conn_group
        groups[g] = groups[g] + 1
        if g > last_g then last_g = g end
      end
    end

    return groups, last_g
  end


  local function OLD__kill_room(R)
    R.kind = "REMOVED"

    each D in R.conns do
      D.kind = "REMOVED"
    end

    each K in R.sections do
      -- TODO ?!?
    end

    for sx = R.sx1,R.sx2 do for sy = R.sy1,R.sy2 do
      local S = SEEDS[sx][sy]

      if S.room == R then
        S.room = nil
        S.section = nil
      end
    end end
  end


  local function OLD__remove_group(g)
    -- process rooms
    for i = #LEVEL.rooms,1,-1 do
      local R = LEVEL.rooms[i]

      if R.conn_group == g then
        gui.printf("Removing dead room: %s\n", R:tostr())
        
        table.remove(LEVEL.rooms, i)

        kill_room(R)
      end
    end

    -- process connections
    for i = #LEVEL.conns,1,-1 do
      local D = LEVEL.conns[i]

      if D.kind == "REMOVED" then
        table.remove(LEVEL.conns, i)
      end
    end
  end


  local function OLD__remove_dead_rooms()
    local groups, last_g = get_group_counts()

    -- do separate groups exist?
    if last_g == 1 then return; end

    -- find group with most members, all others will die
    local best

    for g = 1,last_g do
      local num = groups[g]
      if num > 0 and (not best or num > groups[best]) then
        best = g
      end
    end

    assert(best)

    -- hallways are the only reason for separate groups, hence at
    -- least two rooms must have gotten connected.
    assert(groups[best] >= 2)

    for g = 1,last_g do
      local num = groups[g]
      if g != best and num > 0 then
        remove_group(g)
      end
    end

Plan_dump_rooms("Dead Room Map")
  end


  local function natural_flow(R, visited)
    assert(R.kind != "scenic")

    visited[R] = true

    table.insert(LEVEL.rooms, R)

    each D in R.conns do
      if R == D.R2 and not visited[D.R1] then
        D:swap()
      end
      if R == D.R1 and not visited[D.R2] then
        -- recursively handle adjacent room
        natural_flow(D.R2, visited)
        D.R2.entry_conn = D
      end
    end
  end


  --==| Connect_rooms |==--

  gui.printf("\n--==| Connecting Rooms |==--\n\n")

  table.name_up(BIG_CONNECTIONS)

  -- give each room a 'conn_group' value, starting at one.
  -- connecting two rooms will merge the groups together.
  -- at the end, only a single group will remain (#1).
  initial_groups()

  Levels_invoke_hook("connect_rooms")

---???  NOTE: want to do hallways in more natural way
---???        i.e. as attempt to connect outward from K+dir
---???  Hallway_place_em()

  decide_teleporters()

--!!!!!! FIXME  branch_big_rooms()

  while try_normal_branch() do end

  if count_groups() >= 2 then
    error("Connection failure: separate groups exist")
  end

---###  remove_dead_rooms()

  Connect_decide_start_room()

  -- update connections so that 'src' and 'dest' follow the natural
  -- flow of the level, i.e. player always walks src -> dest (except
  -- when backtracking).  Room order is updated too, though quests
  -- will normally change it again.
  LEVEL.rooms = {}

  natural_flow(LEVEL.start_room, {})
end


------------------------------------------------------------------------


function Connect_cycles()
  
  -- TODO: describe cycles........


  local function next_door_to_existing(R, K, dir)
    for dist = 1,1 do
      local N1 = K:neighbor(geom.RIGHT[dir], dist)
      local N2 = K:neighbor(geom. LEFT[dir], dist)

      each D in R.conns do
        if D.dir1 == dir and D.K1 and (D.K1 == N1 or D.K1 == N2) then
          return true
        end
      end
    end

    return false
  end


  local function add_cycle(K1, MID, K2, dir)
    gui.debugf("Cycle @ %s dir:%d (%s -> %s)\n", K1:tostr(), dir,
               K1.room:tostr(), K2.room:tostr())

    local D = CONN_CLASS.new("cycle", K1.room, K2.room, dir)

    D.K1 = K1 ; D.K2 = K2

    table.insert(LEVEL.conns, D)

    table.insert(K1.room.conns, D)
    table.insert(K2.room.conns, D)

    Hallway_simple(K1, MID, K2, D, dir)
    D.kind = "cycle"  -- FIXME

    table.insert(LEVEL.conns, D)
  end


  local function try_connect_rooms(R1, R2)
    local existing_dir

    each D in R1.conns do
      if D.R1 == R1 and D.R2 == R2 and D.dir1 then
        existing_dir = D.dir1 ; break
      end
    end

    local visits = {}

    for kx = R1.kx1, R1.kx2 do for ky = R1.ky1, R1.ky2 do
      local K = SECTIONS[kx][ky]
      if K.room == R1 then
        table.insert(visits, K)
      end
    end end -- kx, ky

    rand.shuffle(visits)

    each K1 in visits do
      for dir = 2,8,2 do

        local MID = K1:neighbor(dir, 1)
        if not MID or MID.used then continue end

        local K2 = K1:neighbor(dir, 2)
        if not K2 or K2.room != R2 then continue end

        if existing_dir == dir then
          if STYLE.cycles != "heaps" then continue end

          -- prevent connection next door to existing one with same direction
          if next_door_to_existing(R1, K1, dir) then continue end
        end

        add_cycle(K1, MID, K2, dir)
        return true

      end -- dir
    end -- K1

    return false
  end


  local function try_cycles_from_room(R1)
    local nexties = {}
    local futures = {}

    each D1 in R1.conns do
      if D1.R1 != R1 then continue end
      if D1.kind == "teleporter" then continue end

      local R2 = D1:neighbor(R1)
      if R2.quest != R1.quest then continue end

      table.insert(nexties, R2)

      each D2 in R2.conns do
        if D2.R1 != R2 then continue end
        if D2.kind == "teleporter" then continue end

        local R3 = D2:neighbor(R2)
        if R3.quest != R1.quest then continue end

        table.insert(futures, R3)
      end
    end

    local check_list = {}

    table.append(check_list, futures)
    table.append(check_list, nexties)

    local success = false

    each R2 in check_list do
      if try_connect_rooms(R1, R2) then
        success = true

        if STYLE.cycles != "heaps" then break; end
      end
    end

    return success
  end


  local function look_for_cycles()
    local quest_visits = table.copy(LEVEL.quests)

    rand.shuffle(quest_visits)

    each Q in quest_visits do
      -- usually only make one cycle per quest
      local quota = int(#Q.rooms / 5 + gui.random())

      each R in Q.rooms do
        if not try_cycles_from_room(R) then continue end

        quota = quota - 1

        if quota < 1 and STYLE.cycles != "heaps" then
          break;
        end
      end
    end
  end


  ---| Connect_cycles |---

  if STYLE.cycles != "none" then
    look_for_cycles()
  end

  Plan_expand_rooms()
  Plan_dump_rooms("Expanded Map:")
end

