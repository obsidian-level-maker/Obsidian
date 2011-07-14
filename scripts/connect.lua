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
end


function CONN_CLASS.k_coord(D)
  return (D.K1.kx + D.K2.kx) / 2,
         (D.K1.ky + D.K2.ky) / 2
end


------------------------------------------------------------------------


function Connect_decide_start_room()
  each R in LEVEL.rooms do
    R.start_score = R:eval_start()

    gui.debugf("Start score @ %s (seeds:%d) --> %1.3f\n", R:tostr(), R.sw * R.sh, R.start_score)
  end

  local room, index = table.pick_best(LEVEL.rooms,
    function(A, B) return A.start_score > B.start_score end)

  gui.printf("Start room: %s\n", room:tostr())

  LEVEL.start_room = room

  room.purpose = "START"
end



function Connect_is_possible(L1, L2, mode)
  if mode == "cycle" then
    if L1.is_hall then return false end
    if L2.is_hall then return false end

    if L1.next_in_quest == L2 then return true end
    if L1.next_in_quest and L1.next_in_quest.next_in_quest == L2 then return true end

    return false
  end

  -- Note: require R1's group to be less than R2, which ensures that
  --       a connection between two rooms is only tested _once_.
  if mode == "normal" and L1.is_room and L2.is_room then
    return (L1.conn_group < L2.conn_group)
  end

  return (L1.conn_group != L2.conn_group)
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



function CONN_CLASS.add_it(D)
  gui.printf("Connecting %s --> %s : %s\n", D.L1:tostr(), D.L2:tostr(), D.kind or "????")
  gui.debugf("group %d --> %d\n", D.L1.conn_group, D.L2.conn_group)
  if D.K1 and D.K2 then
    gui.debugf("via %s --> %s\n", D.K1:tostr(), D.K2:tostr())
  end

  if D.L1.conn_group != D.L2.conn_group then
    Connect_merge_groups(D.L1.conn_group, D.L2.conn_group)
  end

  table.insert(LEVEL.conns, D)

  table.insert(D.L1.conns, D)
  table.insert(D.L2.conns, D)

  -- direct connections absorb the middle section into one of the rooms
  if D.kind == "direct" then
    assert(D.K1)
    assert(D.K2)

    local R = D.L1
    if R.is_hall then R = D.L2 end
    assert(not R.is_hall)

    R:annex(D.middle)
    R:update_seed_bbox()

    if R == D.L1 then D.K1 = D.middle else D.K2 = D.middle end
  end

  if D.kind != "teleporter" then
    D.K1.num_conn = D.K1.num_conn + 1
    D.K2.num_conn = D.K2.num_conn + 1
  end
end


function Connect_make_branch(mode)
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

  local function collect_teleporter_locs()
    local loc_list = {}

    each R in LEVEL.rooms do
      local score = R:eval_teleporter()

      if score >= 0 then
        table.insert(loc_list, { R=R, score=score })
      end
    end

    table.sort(loc_list, function(A, B) return A.score > B.score end)

    return loc_list
  end


  local function add_teleporter(R1, R2)
    local D = CONN_CLASS.new("teleporter", R1, R2)

    D.tele_tag1 = Plan_alloc_id("tag")
    D.tele_tag2 = Plan_alloc_id("tag")

    D:add_it()
  end


  local function try_add_teleporter()
    local loc_list = collect_teleporter_locs()

    -- need at least a source and a destination
    while #loc_list >= 2 do

      -- grab the first room (with highest score)
      local R1 = loc_list[1].R
      table.remove(loc_list, 1)

      -- try to find a room we can connect to
      each loc in loc_list do
        local R2 = loc.R

        if Connect_is_possible(R1, R2, "teleporter") then
          add_teleporter(R1, R2)
          return true
        end
      end
    end

    return false
  end


  ---| Connect_teleporters |---

  -- check if game / theme supports them
  if not THEME.teleporters then return end

  if STYLE.teleporters == "none" then return end

  -- determine number to make
  local quota = style_sel("teleporters", 0, 1, 2, 3.7)

  quota = quota * MAP_W / 5
  quota = quota + rand.skew() * 1.7

  quota = int(quota) -- round down

  gui.printf("Teleporter quota: %d\n", quota)

  if quota < 1 then return end

  for i = 1,quota do
    if not try_add_teleporter() then
      break
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

  if not LEVEL.best_conn.D1 then
    if mode == "cycle" then return end
    error("Connection failure: separate groups exist")
  end

if mode == "cycle" then stderrf(">>>>>>>>>>>>>>>> CYCLE score:%1.2f\n", LEVEL.best_conn.score) end
  Connect_make_branch(mode)
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

  Hallway_how_many()
  Hallway_add_streets()

  Connect_teleporters()

  while count_groups() >= 2 do
    Connect_scan_sections("normal", -999)
  end

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


  local function next_door_to_existing(R, K, dir) -- FIXME: not used, need to do it in new system
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


  local function find_room(D)
    local L = D.L2

    if L.is_room then return L end

    each D2 in L.conns do
      if D2.L1 == L and not D2.lock then
        return find_room(D2)
      end
    end

    error("cycles: finding next room failed")
  end

  local function prepare_cycles()   -- FIXME: MOVE TO quests.lua
    -- give each room a 'next_in_quest' field

    each R in LEVEL.rooms do
      each D in R.conns do
        if D.L1 == R and not D.lock and D.kind != "teleporter" then
          R.next_in_quest = find_room(D)
          assert(R.quest == R.next_in_quest.quest)
          break
        end
      end
    end
  end


  ---| Connect_cycles |---

  if STYLE.cycles != "none" then

    prepare_cycles()

    local quota = 5 ---FIXME

    if STYLE.cycles == "heaps" then quota = 30 end

    for i = 1,quota do
      Connect_scan_sections("cycle", 0)
    end
  end

  Plan_expand_rooms()
  Plan_dump_rooms("Expanded Map:")
end

