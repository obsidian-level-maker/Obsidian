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
  kind   : keyword  -- "direct", "cycle", "crossover"
                    -- "hallway", "double_hall"
                    -- "teleporter"
  lock   : LOCK

  id : number  -- debugging aid

  -- The two rooms are the vital (compulsory) information,
  -- especially for the quest system.  For teleporters the
  -- other info (sections and dir1/dir2) may be absent.

  L1, L2 : location (either ROOM or HALLWAY)

  K1, K2 : SECTION

  C1, C2 : CHUNK   -- decided later (at chunk creation)

  hall      : HALLWAY
  crossover : CROSSOVER

  dir1, dir2  -- direction value (2/4/6/8) 
              -- dir1 leading out of L1 / K1 / C1
              -- dir2 leading out of L2 / K2 / C2

  is_cycle : boolean

  conn_h  -- floor height for connection

  
  --- POSSIBLE_CONN ---

  score : number
  
  hall_path : list(DIR)
}


--------------------------------------------------------------]]

require 'defs'
require 'util'


CONN_CLASS = {}

function CONN_CLASS.new(kind, L1, L2, dir)
  local D = { kind=kind, L1=L1, L2=L2 }
  D.id = Plan_alloc_id("conn")
  table.set_class(D, CONN_CLASS)
  if dir then
    D.dir1 = dir
    D.dir2 = 10 - dir
  end
  return D
end


function CONN_CLASS.tostr(D)
  return string.format("CONN_%d [%s]", D.id, D.kind)
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


function CONN_CLASS.neighbor(D, L)
  return (L == D.L1 ? D.L2 ; D.L1)
end


function CONN_CLASS.section(D, L)
  return (L == D.L1 ? D.K1 ; D.K2)
end


function CONN_CLASS.what_dir(D, L)
  if D.dir1 then
    return (L == D.L1 ? D.dir1 ; D.dir2)
  end
end


function CONN_CLASS.swap(D)
  D.L1, D.L2 = D.L2, D.L1
  D.K1, D.K2 = D.K2, D.K1
  D.C1, D.C2 = D.C2, D.C1

  D.dir1, D.dir2 = D.dir2, D.dir1

---##  if D.hall and D.hall.L1 != D.L1 then D.hall:reverse() end
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

    if R:has_teleporter() then cost = cost + 100 end

    gui.debugf("Start cost @ %s (seeds:%d) --> %1.3f\n", R:tostr(), R.sw * R.sh, cost)

    return cost
  end


  ---| Connect_decide_start_room |---

  each R in LEVEL.rooms do
    R.start_cost = eval_room(R)
  end

  local room, index = table.pick_best(LEVEL.rooms,
    function(A, B) return A.start_cost < B.start_cost end)

  gui.printf("Start room: %s\n", room:tostr())

  LEVEL.start_room = room

  room.purpose = "START"
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

  each H in LEVEL.halls do
    if H.conn_group == id2 then
      H.conn_group = id1
    end
  end
end



function Connect_find_branches(K, dir, cycle_target_R)

  local function test_direct_branch(K1, dir)
    local allow_sub_hall

    local MID = K1:neighbor(dir, 1)
    local K2  = K1:neighbor(dir, 2)

    if not K2 or not K2.room then return end

    if cycle_target_R and K2.room != cycle_target_R then return end

    if MID.used then return end

    -- FIXME: this will fail for cycles
    local poss = Connect_possibility(K1.room, K2.room)

    if poss < 0 then return end

    local score = 20 + int(poss * 9) + gui.random()

    if score < LEVEL.best_conn.score then return end

    -- OK --

    local D = CONN_CLASS.new("direct", K1.room, K2.room, dir)

    D.K1 = K1 ; D.K2 = K2

    D.middle = MID

    LEVEL.best_conn.D1 = D
    LEVEL.best_conn.D2 = nil
    LEVEL.best_conn.score = score
  end


  --| Connect_find_branches |--

  -- these functions will update 'best_conn' if the score is better
  test_direct_branch(K, dir)

  Hallway_test_branch(K, dir, cycle_target_R)
end



function CONN_CLASS.add_it(D)
  gui.printf("Connecting %s --> %s : %s\n", D.L1:tostr(), D.L2:tostr(), D.kind or "????")
  gui.debugf("via %s --> %s\n", D.K1:tostr(), D.K2:tostr())
  gui.debugf("group %d --> %d\n", D.L1.conn_group, D.L2.conn_group)

  if D.L1.conn_group != D.L2.conn_group then
    Connect_merge_groups(D.L1.conn_group, D.L2.conn_group)
  end

  assert(D.K1)
  assert(D.K2)

  table.insert(LEVEL.conns, D)

  table.insert(D.L1.conns, D)
  table.insert(D.L2.conns, D)

  -- direct connections absorb the middle section into one of the rooms
  if D.kind == "direct" then
    local R = D.L1
    if R.is_hall then R = D.L2 end
    assert(not R.is_hall)

    R:annex(D.middle)
    R:update_seed_bbox()

    if R == D.L1 then D.K1 = D.middle else D.K2 = D.middle end
  end

  D.K1.num_conn = D.K1.num_conn + 1
  D.K2.num_conn = D.K2.num_conn + 1
end


function Connect_make_branch()
gui.debugf("\nmake_branch\n\n")
  local info = LEVEL.best_conn

  -- must add hallway first (so that merge_groups can find it)
  if info.hall then
     info.hall:add_it()
  end

  info.D1:add_it()

  if info.D2 then
     info.D2:add_it()
  end
end



function Connect_teleporters()

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
    if R.map_volume >= 2 then score = score + 0.8 end

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


  --| Connect_teleporters |--

  LEVEL.teleporters = {}  --????

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



function Connect_scan_sections(mode, min_score)
  LEVEL.best_conn = { score=min_score }

  for kx = 1,SECTION_W do for ky = 1,SECTION_H do
    local K = SECTIONS[kx][ky]

    if not (K and K.used and K.room) then continue end

    -- TODO: relax this
    if K.kind != "section" then continue end

    for dir = 2,8,2 do
      Hallway_test_branch(K, dir, mode)
    end
  end end

  if mode == "cycle" then return end

  if not LEVEL.best_conn.D1 then
    error("Connection failure: separate groups exist")
  end

  Connect_make_branch()
end



function Connect_rooms()

  -- a "branch" is a room with 3 or more connections.
  -- a "stalk"  is a room with two connections.

  local function initial_groups()
    each R in LEVEL.rooms do
      R.conn_group = _index
    end
  end


  local function OLD__add_crossover(K1, dir)
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


  function Hallway_make_conn(D)  -- FIXME: MOVE IT MOVE IT

    -- FIXME: handle long hallways, crossovers ETC

    local MID = assert(D.K1:neighbor(D.dir1))

    MID.conn = D ; D.middle = MID 

    Hallway_simple(D.K1, MID, D.K2, D, D.dir1)
  end


  local function try_add_big_exit(R)
    local exits = {}

    each K in R.sections do
      if K.kind != "section" then continue end

      for dir = 2,8,2 do
        local score = eval_big_exit(R, K, dir)

        if score >= 0 then
          table.insert(exits, { K=K, dir=dir, score=score })
        end
      end
    end

    table.sort(exits, function(A, B) return A.score > B.score end)

    each EX in exits do
      LEVEL.best_conn = { score=0 }  -- TODO: have a threshhold of goodness

      Connect_find_branches(EX.K, EX.dir)

      -- something worked?
      if LEVEL.best_conn.D1 then
        Connect_make_branch()
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

      -- large bonus for shaped rooms
      if R.shape != "rect" and R.shape != "odd" then
        R.big_score = R.big_score * 1.7
      end
    end

    table.sort(visits, function(A, B) return A.big_score > B.big_score end)

    each R in visits do
      if R.kw >= 3 and R.kh >= 3 then
        visit_big_room(R)
      end
    end
  end


  local function try_normal_branch()
    
    LEVEL.best_conn = { score=-999 }

    for mx = 1,MAP_W do for my = 1,MAP_H do
      local K = SECTIONS[mx*2][my*2]
      local count = 0

      if not K.room then continue end

      for dir = 2,8,2 do

        Connect_find_branches(K, dir)
--[[
        local score, N = eval_normal_exit(K.room, K, dir)

        if score >= 0 then count = count + 1 end

        if score >= 0 and (not loc or score > loc.score) then
          loc = { K=K, N=N, dir=dir, score=score }
        end
--]]
      end
    end end -- mx, my

    --[[ make a crossover? 
    if cross_loc and (STYLE.crossovers == "heaps" or rand.odds(24)) then
      add_crossover(cross_loc.K, cross_loc.dir)
      return true
    end --]]

    -- nothing possible? hence we are done
    if not LEVEL.best_conn.D1 then return false end

-- stderrf("Normal branch: %s --> %s  score:%1.2f\n", loc.K:tostr(), loc.N:tostr(), loc.score)

    Connect_make_branch()

---###    add_connection(loc.K, loc.N, loc.dir)

    return true
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


  local function natural_flow(L, visited)
    assert(L.kind != "scenic")

--- stderrf("natural_flow @ %s\n", L:tostr())

    visited[L] = true

    if L.is_room then
      table.insert(LEVEL.rooms, L)
    end

    each D in L.conns do
      if L == D.L2 and not visited[D.L1] then
        D:swap()
      end

      if L == D.L1 and not visited[D.L2] then
        D.L2.entry_conn = D

        -- recursively handle adjacent room
        natural_flow(D.L2, visited)
      end
    end
  end


  --==| Connect_rooms |==--

  gui.printf("\n--==| Connecting Rooms |==--\n\n")

  -- give each room a 'conn_group' value, starting at one.
  -- connecting two rooms will merge the groups together.
  -- at the end, only a single group will remain (#1).
  initial_groups()

  Levels_invoke_hook("connect_rooms")

  Hallway_add_streets()

  Connect_teleporters()

  while count_groups() >= 2 do
    Connect_scan_sections("normal", -999)
  end
--[[ OLD WAY
  branch_big_rooms()

  while try_normal_branch() do end

  if count_groups() >= 2 then
    error("Connection failure: separate groups exist")
  end
--]]

  Connect_decide_start_room()

  -- update connections so that 'src' and 'dest' follow the natural
  -- flow of the level, i.e. player always walks src -> dest (except
  -- when backtracking).  Room order is updated too, though quests
  -- will normally change it again.
  LEVEL.rooms = {}

  natural_flow(LEVEL.start_room, {})

  -- need this due to direct connections annexing a section
  Plan_make_seeds()
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


  local function OLD__add_cycle(K1, MID, K2, dir)
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

    LEVEL.best_conn = { score=0 }  -- TODO: better threshhold ?

    for kx = R1.kx1, R1.kx2 do for ky = R1.ky1, R1.ky2 do
      local K1 = SECTIONS[kx][ky]

      if K1.room == R1 then
        for dir = 2,8,2 do

          Connect_find_branches(K1, dir, R2)

        --[[ FIXME !!!!!! do this in test_direct_branch
        if existing_dir == dir then
          if STYLE.cycles != "heaps" then continue end

          -- prevent connection next door to existing one with same direction
          if next_door_to_existing(R1, K1, dir) then continue end
        end
        --]]

        end -- dir
      end
    end end -- kx, ky

    if LEVEL.best_conn.D1 then
      Connect_make_branch(LEVEL.best_conn)
      return true
    end

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
        if try_cycles_from_room(R) then
          quota = quota - 1
          if quota < 1 then break end
        end
      end
    end
  end


  ---| Connect_cycles |---

if false then  --!!!!! FIXME: disabled until use new system

  if STYLE.cycles != "none" then

    prepare_cycles()

    local quota = 5 ---FIXME

    if STYLE.cycles == "heaps" then quota = 50 end

    for i = 1,quota do
      Connect_scan_sections("cycle", 0)
    end
  end
end

  Plan_expand_rooms()
  Plan_dump_rooms("Expanded Map:")
end

