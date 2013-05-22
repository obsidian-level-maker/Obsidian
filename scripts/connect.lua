------------------------------------------------------------------------
--  CONNECTIONS
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2013 Andrew Apted
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
  kind : keyword  -- "normal", "secret"
                  -- "double_L", "double_R"
                  -- "teleporter"
                  -- "closet" (e.g. starting niche)
  lock : LOCK

  id : number  -- debugging aid

  -- The two rooms are the vital (compulsory) information,
  -- especially for the quest system.  For teleporters the
  -- other info may be absent (sections and dir1/dir2).

  L1, L2 : location (either ROOM or HALLWAY)

  K1, K2 : SECTION

  dir1, dir2  -- direction value (2/4/6/8) 
              -- dir1 leading out of L1 / K1
              -- dir2 leading out of L2 / K2

  portal1, portal2 : PORTAL


  --- POSSIBLE_CONN ---

  score : number
  
}


--------------------------------------------------------------]]


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
  return string.format("CONN_%d [%s%s]", D.id, D.kind,
         sel(D.is_cycle, "/cycle", ""))
end


function CONN_CLASS.dump(D)
  gui.debugf("%s =\n", D:tostr())
  gui.debugf("{\n")
  gui.debugf("    L1 = %s\n", (D.L1 and D.L1:tostr()) or "nil")
  gui.debugf("    L2 = %s\n", (D.L2 and D.L2:tostr()) or "nil")
  gui.debugf("    K1 = %s\n", (D.K1 and D.K1:tostr()) or "nil")
  gui.debugf("    K2 = %s\n", (D.K2 and D.K2:tostr()) or "nil")
  gui.debugf("  dir1 = %s\n", (D.dir1 and tostring(D.dir1)) or "nil")
  gui.debugf("  dir2 = %s\n", (D.dir2 and tostring(D.dir2)) or "nil")
  gui.debugf("}\n")
end


function CONN_CLASS.neighbor(D, L)
  return sel(L == D.L1, D.L2, D.L1)
end


function CONN_CLASS.section(D, L)
  return sel(L == D.L1, D.K1, D.K2)
end


function CONN_CLASS.what_dir(D, L)
  if D.dir1 then
    return sel(L == D.L1, D.dir1, D.dir2)
  end
end


function CONN_CLASS.swap(D)
  D.L1, D.L2 = D.L2, D.L1
  D.K1, D.K2 = D.K2, D.K1

  D.dir1, D.dir2 = D.dir2, D.dir1
end


function CONN_CLASS.k_coord(D)
  return (D.K1.kx + D.K2.kx) / 2,
         (D.K1.ky + D.K2.ky) / 2
end


function CONN_CLASS.add_it(D)
  gui.printf("Connecting %s --> %s : %s\n", D.L1:tostr(), D.L2:tostr(), D.kind or "????")
  gui.debugf("group %d --> %d\n", D.L1.conn_group, D.L2.conn_group)
  if D.K1 and D.K2 then
    gui.debugf("via %s --> %s\n", D.K1:tostr(), D.K2:tostr())
  end

  table.insert(LEVEL.conns, D)

  table.insert(D.L1.conns, D)
  table.insert(D.L2.conns, D)

  if D.L1.conn_group != D.L2.conn_group then
    Connect_merge_groups(D.L1.conn_group, D.L2.conn_group)
  end

  if not (D.kind == "teleporter" or D.kind == "closet") then
    D.K1.num_conn = D.K1.num_conn + 1
    D.K2.num_conn = D.K2.num_conn + 1

    -- hallway stuff
    if D.K1.hall then D.K1.hall_link[D.dir1] = D.K2 end
    if D.K2.hall then D.K2.hall_link[D.dir2] = D.K1 end
  end
end


------------------------------------------------------------------------


function Connect_is_possible(L1, L2, mode)
  if L1 == L2 then return false end

  -- never to secret rooms (that is handled elsewhere)
  if L2.purpose == "SECRET_EXIT" then return false end

  if mode == "cycle" then
    if L1.kind == "hallway" then return false end
    if L2.kind == "hallway" then return false end

    -- no shortcuts to the exit please
    if L1.purpose == "EXIT" then return false end
    if L2.purpose == "EXIT" then return false end

    -- [FUTURE Todo: allow _one_way_ cycles to earlier room]

    if L1.quest == L2.quest then

      -- don't add cycles to rooms with teleporters
      if L1.kind != "hallway" and L1:has_teleporter() then return false end
      if L2.kind != "hallway" and L2:has_teleporter() then return false end

    else  -- different quests

      if L1.purpose == "SOLUTION" then return false end
      if L2.purpose == "SOLUTION" then return false end

    end

    return true
  end

  -- Note: require R1's group to be less than R2, which ensures that
  --       a connection between two rooms is only tested _once_.
  if mode != "cycle" and
     L1.kind != "hallway" and
     L2.kind != "hallway" and
     not L2.is_street
  then
    return (L1.conn_group < L2.conn_group)
  end

  return (L1.conn_group != L2.conn_group)
end



function Connect_dump_groups()
  gui.debugf("Connect groups:\n")

  each R in LEVEL.rooms do
    gui.debugf("  %s = %d\n", R:tostr(), R.conn_group or -1)
  end

  each H in LEVEL.halls do
    gui.debugf("  %s = %d\n", H:tostr(), H.conn_group or -1)
  end
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



function Connect_make_branch(info, mode)

  -- must add hallway to level now
  -- [so merge_groups in CONN:add_it() can find it]
  if info.hall then

    -- merge new hall into an existing one?
    if info.merge then
      assert(info.onto_hall_K)

      local new_hall = assert(info.hall)
      local old_hall = assert(info.onto_hall_K.hall)

      old_hall:add_to_existing(new_hall, info.D2)

      info.hall = nil

      -- update the CONN info -- only need one now
      if info.D1.L1 == new_hall then info.D1.L1 = old_hall end
      if info.D1.L2 == new_hall then info.D1.L2 = old_hall end
    
      info.D2 = nil

    else  -- normal creation

      info.hall:add_it()

      if mode == "cycle" then
        info.is_cycle = true
        info.hall.is_cycle = true
      end
    end
  end

  -- add connections
  info.D1:add_it()

  if info.D2 then
     info.D2:add_it()
  end

  -- for cycles, ensure new hallway gets a quest and zone
  if mode == "cycle" and info.hall then
    assert(info.D1.L1.quest)
    assert(info.D1.L1.zone)

    assert(not info.D1.L2.quest)
    assert(not info.D1.L2.zone)

    info.D1.L1.quest:add_room_or_hall(info.D1.L2)
    info.D1.L1.zone :add_room_or_hall(info.D1.L2)
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
  if not PARAM.teleporters then return end

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



function Connect_eval_direct(start_K, dir, mode)

  -- see if we can make a direct connection to a neighboring room
  -- (which touches the start room).

  local end_K = start_K:neighbor(dir)

  if not end_K then return end

  local L1 = start_K.room or start_K.hall
  local L2 =   end_K.room or   end_K.hall

  if not L2 then return end

  if L1 == L2 then return end

  if not Connect_is_possible(L1, L2, mode) then return end

  -- never extend onto big junction hallways
  if L2.big_junc then return end


  local score

  if end_K.room then
    local score1 = start_K:eval_exit(dir)
    local score2 =   end_K:eval_exit(10 - dir)

    score = (score1 + score2) * 10 + 100 * gui.random() ^ 1.7

    -- prefer secret exits DO NOT connect to the start room
    if L2.purpose == "START" then
      score = score - 300
    end
  else
    -- prefer not to connect onto existing hallways
    score = -100 - end_K.num_conn - gui.random()
  end

  -- try damn hard _not_ to connect to crossover hallways
  if end_K.hall and end_K.hall.crossover then
    if mode != "emergency" then return end

    score = score - 500
  end


  -- score is now computed : test it

  if score < LEVEL.best_conn.score then return end


  --- OK ---

  local D1 = CONN_CLASS.new("normal", L2, L1, 10 - dir)

  D1.K1 =   end_K
  D1.K2 = start_K


  LEVEL.best_conn =
  {
    score = score
    D1 = D1
    stats = {}
    onto_hall_K = MID
  }
end



function Connect_scan_sections(mode, min_score)
  --|
  --| evaluate all possible connections (within reason) and pick the
  --| one with the highest score.
  --|

  LEVEL.best_conn = { score=min_score }

  for kx = 1,SECTION_W do
  for ky = 1,SECTION_H do
    local K = SECTIONS[kx][ky]

    if not (K and K.used and K.room) then continue end

    -- only connect TO a street (never FROM one)
    if K.room.is_street then continue end

    -- ignore secret exits in normal mode, require them in secret mode
    if (mode == "secret_exit") != (K.room.purpose == "SECRET_EXIT") then
      continue
    end

    for dir = 2,8,2 do
      Connect_eval_direct(K, dir, mode)

      Hallway_scan(K, dir, mode)
    end

    -- this function can take a while to run, so check for user abort
    -- (return true so we don't trigger an error)
    if gui.abort() then return true end
  end
  end

  -- failed to make any connection?
  if not LEVEL.best_conn.D1 then
    return false
  end

--[[ debug
if mode == "cycle" then
stderrf("\n\n==== CYCLE : %s / %s\n\n", LEVEL.best_conn.D1.L1:tostr(), LEVEL.best_conn.D1.L2:tostr())
end
--]]

  Connect_make_branch(LEVEL.best_conn, mode)

  return true  -- OK
end



function Connect_start_room()
  local locs = {}

  each R in LEVEL.rooms do
    R.start_score = R:eval_start()

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

  room.purpose = "START"

  if LEVEL.special != "street" and
     not (LEVEL.hub_links and Hub_find_link("START")) and
     rand.odds(80)
  then

    if room:add_closet("start") then
      room.purpose_is_done = true
    end
  end
end



function Connect_rooms()
  
  -- this function ensures all rooms become connected together
  -- (as a simple undirected graph, i.e. no loops).  Rooms can be
  -- connected directly at a boundary, via a hallway, or via a
  -- pair of teleporters.

  -- we also decide the start room here.


  local function initial_groups()
    each R in LEVEL.rooms do
      R.conn_group = _index
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


  local function natural_flow(L, visited)
    assert(L.kind != "scenic")

--- stderrf("natural_flow @ %s\n", L:tostr())

    visited[L] = true

    if L.kind == "closet" then return end

    if L.kind != "hallway" then
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

  Hallway_prepare()

  Connect_teleporters()
  Connect_start_room()

  -- secret exit must be done first
  if LEVEL.secret_exit then
    if not Connect_scan_sections("secret_exit", -9999) then
      error("Failed to connect secret exit")
    end
  end

  Hallway_add_streets()

  -- add connections until all rooms are reachable
  while count_groups() >= 2 do
    if not Connect_scan_sections("normal", -999) then
      if not Connect_scan_sections("emergency", -99999) then
        Plan_dump_rooms("Current Map:")
        gui.printf("Rooms with no conns: %s\n", Room_list_no_conns())
        Connect_dump_groups()
        error("Failed to connect all rooms")
      end
    end

    if gui.abort() then return end
  end

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

  local function find_room(D)
    local L = D.L2

    if L.kind != "hallway" then return L end

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
        if D.L1 == R and not D.lock and not (D.kind == "teleporter" or D.kind == "closet") then
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

    local quota = style_sel("cycles", 0, 0.3, 1, 5)

    quota = int(quota * MAP_W + gui.random())

    gui.printf("Cycle quota: %d\n", quota)

    for i = 1,quota do
      Connect_scan_sections("cycle", -500)

      if gui.abort() then return end
    end
  end

---!!!!  Hallway_add_doubles()

  each H in LEVEL.halls do
    H:dump_path()
  end
end

