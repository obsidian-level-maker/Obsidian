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

  -- The two rooms are the vital (compulsory) information,
  -- especially for the quest system.  For teleporters the
  -- other info will be absent.

  R1 : source ROOM
  R2 : destination ROOM

  S1 : source SEED
  S2 : destination SEED

  dir    : direction 2/4/6/8 (from S1 to S2)

  conn_h : floor height for connection

  where1  : usually NIL, otherwise a FLOOR object
  where2  :
}

--------------------------------------------------------------]]


CONN_CLASS = {}


function CONN_CLASS.new(kind, R1, R2, dir)
  local C =
  {
    kind = kind
    id   = Plan_alloc_id("conn")
    R1   = R1
    R2   = R2
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
  C.R1, C.R2 = C.R2, C.R1
  C.S1, C.S2 = C.S2, C.S1

  if C.dir then
    C.dir = 10 - C.dir
  end
end


function CONN_CLASS.neighbor(C, R)
  if R == C.R1 then
    return C.R2
  else
    return C.R1
  end
end


function CONN_CLASS.get_seed(C, R)
  if R == C.R1 then
    return C.S1
  else
    return C.S2
  end
end


function CONN_CLASS.get_dir(C, R)
  if not C.dir then return nil end

  if R == C.R1 then
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


-- Generator functions for "big branches" (mostly for large rooms
-- which deserve 3/4/5 exits).
-- 
-- Each function generates a list of configurations.  Each config
-- describes the exits for a single room, and is a list of tuples
-- in the form (x, y, dir) but unpacked.  NIL returned means that
-- the given size was not suitable for that pattern (e.g. a pure
-- cross requires an odd width and an odd height).
--
-- It is assumed that the caller will try all the four possible
-- mirrorings (none/X/Y/XY) and rotations (none/90) of each
-- configuration, and these generator functions are optimised
-- with that in mind.
--
-- The symmetry field can have the following keywords:
--   "x"  mirrored horizontally (i.e. left side = right side)
--   "y"  mirrored vertically
--   "xy" mirrored both horizontally and vertically
--   "R"  rotation symmetry (180 degrees)
--   "T"  transpose symmetry (square rooms only)
--


--- 2 way --->

function Connect_gen_PC(long, deep)
  if long < 3 or long > 7 or (long % 2) == 0 or
     deep < 2 or deep > 7 or (long / deep) >= 3
  then
    return nil
  end

  local mx  = int((long+1)/2)

  return {{ mx,1,2, mx,deep,8 }}
end

function Connect_gen_PA(long, deep)
  if long < 2 or long > 4 or deep < 2 or deep > 5 then
    return nil
  end

  return {{ 1,1,2, 1,deep,8 }}
end

function Connect_gen_PR(long, deep)
  if long < 2 or deep < 1 or deep > 5 or
     (long*deep) >= 30 or (deep/long) > 2.1
  then
    return nil
  end

  local configs = {}
  local lee = int((long-2)/4)

  for x = 0,lee do
    table.insert(configs, { 1+x,1,2, long-x,deep,8 })
  end

  return configs
end

function Connect_gen_PX(long, deep)
  if long < 3 or long > 5 or deep < 1 or deep > 5 then
    return nil
  end

  local configs = {}
  local mx = int(long/2)

  for b = 1,mx do for t = 2,long-1 do
    if not (deep == 1 and b == t) then
      table.insert(configs, { b,1,2, t,deep,8 })
    end
  end end

  return configs
end

function Connect_gen_LS(long, deep)
  if long < 2 or long > 6 or deep != long then
    return nil
  end

  local configs = {}

  local lee = int((long-1)/2)

  for x = 0,lee do
    table.insert(configs, { 1,1+x,4, long-x,deep,8 })
  end

  return configs
end

function Connect_gen_LX(long, deep)
  if long < 3 or deep < 1 or long==deep or (long*deep) >= 30 then
    return nil
  end

  local configs = {}

  local x_lee = int((long-2)/3)
  local y_lee = int((deep-1)/2)

  for x = 0,x_lee do for y = 0,y_lee do
    table.insert(configs, { 1,1+y,4, long-x-1,deep,8 })
  end end

  return configs
end

function Connect_gen_U2(long, deep)
  if long < 3 or deep < 1 or long < deep or deep > 4 then
    return nil
  end

  local configs = {}

  local x_lee = int((long-2)/4)

  for x = 0,x_lee do
    table.insert(configs, { 1+x,deep,8, long-x,deep,8 })
  end

  return configs
end


--- 3 way --->

function Connect_gen_TC(long, deep)
  if long < 3 or deep < 1 or deep > 7 or (long % 2) == 0 or (long*deep) >= 42 then
    return nil
  end

  local configs = {}

  local mx  = int((long+1)/2)
  local lee = int((deep-1)/2)

  for y = 0,lee do
    table.insert(configs, { mx,1,2, 1,deep-y,4, long,deep-y,6 })
  end

  return configs
end

function Connect_gen_TX(long, deep)
  if long < 4 or deep < 1 or deep > 7 or (long*deep) >= 42 then
    return nil
  end

  local configs = {}

  local mx    = int((long  )/2)
  local y_lee = int((deep-1)/2)

  for x = 2,mx do for y = 0,y_lee do
    table.insert(configs, { x,1,2, 1,deep-y,4, long,deep-y,6 })
  end end

  return configs
end

function Connect_gen_TY(long, deep)
  if long < 3 or deep < 1 or deep > 5 or (long % 2) == 0 then
    return nil
  end

  local configs = {}

  local mx  = int((long+1)/2)
  local lee = int((long-2)/3)

  for x = 0,lee do
    table.insert(configs, { mx,1,2, 1+x,deep,8, long-x,deep,8 })
  end

  return configs
end

function Connect_gen_F3(long, deep)
  if long < 4 or deep < 1 or (long/deep) < 2 then
    return nil
  end

  local configs = {}

  local mx    = int((long  )/2)
  local y_lee = int((deep-1)/2)

  for x = mx,long-2 do for y = 0,y_lee do
    table.insert(configs, { 1,1+y,4, x,deep,8, long,deep,8 })
  end end

  return configs
end

function Connect_gen_M3(long, deep)
  if long < 5 or (long % 2) == 0 or long < deep or
     deep < 1 or deep > 5
  then
    return nil
  end

  local configs = {}

  local mx    = int((long+1)/2)
  local x_lee = int((long-3)/4)

  for x = 0,x_lee do
    table.insert(configs, { 1+x,1,2, mx,1,2, long-x,1,2 })
  end

  return configs
end


--- 4 way --->

function Connect_gen_XC(long, deep)
  if long < 3 or (long % 2) == 0 or
     deep < 3 or (deep % 2) == 0
  then
     return nil
  end

  local mx = int((long+1)/2)
  local my = int((deep+1)/2)

  return {{ mx,1,2, mx,deep,8, 1,my,4, long,my,6 }}
end

function Connect_gen_XT(long, deep)
  if long < 3 or deep < 3 or (long % 2) == 0 then
    return nil
  end

  local configs = {}
  local mx = int((long+1)/2)
  local my = int(deep/2)

  for y = 1,my do
    table.insert(configs, { mx,1,2, mx,deep,8, 1,y,4, long,y,6 })
  end

  return configs
end

function Connect_gen_XX(long, deep)
  if long < 5 or deep < 3 or (long*deep) >= 50 then
    return nil
  end

  local configs = {}
  local mx = int(long/2)
  local my = int(deep/2)

  for x = 2,mx do for y = 1,my do
    table.insert(configs, { x,1,2, x,deep,8, 1,y,4, long,y,6 })
  end end

  return configs
end

function Connect_gen_SW(long, deep)
  if long < 3 or deep < 3 then
    return nil
  end

  local configs = {}

  local x_lee = int((long-1)/4)
  local y_lee = int((deep-1)/4)

  for x = 0,x_lee do for y = 0,y_lee do
    table.insert(configs, { 1+x,1,2, long,1+y,6, long-x,deep,8, 1,deep-y,4 })
  end end

  return configs
end

function Connect_gen_HP(long, deep)
  if long < 3 or deep < 2 then
    return nil
  end

  local configs = {}

  local b_lee = int((long-2)/3)
  local t_lee = int((long-2)/5)
  
  for b = 0,b_lee do for t = 0,t_lee do
    if b >= t then
      table.insert(configs, { 1+b,1,2, long-b,1,2, 1+t,deep,8, long-t,deep,8 })
    end
  end end

  return configs
end

function Connect_gen_HT(long, deep)
  if long < 3 or deep < 2 or (long*deep) >= 50 then
    return nil
  end

  local configs = {}

  local x_lee = int((long-2)/3)
  local y_lee = int((deep-1)/2)
  
  for x = 0,x_lee do for y = 0,y_lee do
    table.insert(configs, { 1+x,1,2, long-x,1,2, 1,deep-y,4, long,deep-y,6 })
  end end

  return configs
end

function Connect_gen_F4(long, deep)
  if long < 4 or deep < 4 then
    return nil
  end

  local configs = {}

  local x_dist = int((long)/2)
  local y_dist = int((deep)/2)

  local x_lee = int((long-1)/4)
  local y_lee = int((deep-1)/4)

  for x = 0,x_lee do for y = 0,y_lee do
    table.insert(configs, { 1,1+y,4, 1,1+y+y_dist,4, long-x,deep,8, long-x-x_dist,deep,8 })
  end end

  return configs
end


--- 5,6 way --->

function Connect_gen_KY(long, deep)
  if long < 5 or deep < 3 or (long*deep) < 21 or (long % 2) == 0 then
    return nil
  end

  local configs = {}

  local mx    = int((long+1)/2)
  local x_lee = int((long-2)/3)
 
  for x = 0,x_lee do for y = 1,deep-1 do
    table.insert(configs, { mx,1,2, 1,y,4, long,y,6, 1+x,deep,8, long-x,deep,8 })
  end end

  return configs
end

function Connect_gen_KT(long, deep)
  if long < 3 or deep < 4 or (long*deep) < 21 or (long % 2) == 0 then
    return nil
  end

  local configs = {}

  local mx    = int((long+1)/2)
  local my    = int(deep / 2)
  local t_lee = int((deep-2)/3)
 
  for t = 0,t_lee do for y = 1,my do
    table.insert(configs, { mx,1,2, 1,y,4, long,y,6, 1,deep-t,4, long,deep-t,6 })
  end end

  return configs
end

function Connect_gen_M5(long, deep)
  if long < 5 or deep < 3 or (long % 2) == 0 or long < deep then
    return nil
  end

  local configs = {}

  local mx    = int((long+1)/2)
  local t_lee = int((long-4)/3)
--  local b_lee = int((long-3)/4)

  for b = 0,mx-2 do for t = 0,t_lee do
    table.insert(configs, { mx-1-b,1,2, mx+1+b,1,2, 1+t,deep,8, mx,deep,8, long-t,deep,8 })
  end end

  return configs
end

function Connect_gen_GG(long, deep)
  if long < 5 or deep < 3 or (long*deep) < 21 or (long % 2) == 0 then
    return nil
  end

  local configs = {}

  local mx    = int((long+1)/2)
  local y_lee = int((deep-3)/2)
 
  for y = 0,y_lee do
    table.insert(configs, { mx,1,2, mx,deep,8, 1,1+y,4, 1,deep-y,4, long,1+y,6, long,deep-y,6 })
  end

  return configs
end


BRANCH_TABLE =
{
  -- pass through (one side to the other), perfectly centered
  PC = { conn=2, prob=40, func=Connect_gen_PC, symmetry="x" },

  -- pass through, along one side
  PA = { conn=2, prob= 8, func=Connect_gen_PA, symmetry="y" },

  -- pass through, rotation symmetry
  PR = { conn=2, prob=50, func=Connect_gen_PR, symmetry="R" },

  -- pass through, garden variety
  PX = { conn=2, prob= 3, func=Connect_gen_PX },

  -- L shape for square room (transpose symmetrical)
  LS = { conn=2, prob=100, func=Connect_gen_LS, symmetry="T" },

  -- L shape, garden variety
  LX = { conn=2, prob= 3, func=Connect_gen_LX },

  -- U shape, both exits on a single wall
  U2 = { conn=2, prob= 1, func=Connect_gen_U2, symmetry="x" },


  -- T shape, centered main stem, leeway for side stems
  TC = { conn=3, prob=200, func=Connect_gen_TC, symmetry="x" },

  -- like TC but main stem not centered
  TX = { conn=3, prob= 50, func=Connect_gen_TX },

  -- Y shape, two exits parallel to single centered entry
  TY = { conn=3, prob=120, func=Connect_gen_TY, symmetry="x" },

  -- F shape with three exits (mainly for rooms at corner of map)
  F3 = { conn=3, prob=  2, func=Connect_gen_F3 },

  -- three exits along one wall, middle is centered
  M3 = { conn=3, prob=  5, func=Connect_gen_M3, symmetry="x" },


  -- Cross shape, all stems perfectly centered
  XC = { conn=4, prob=1800, func=Connect_gen_XC, symmetry="xy" },

  -- Cross shape, centered main stem, leeway for side stems
  XT = { conn=4, prob=200, func=Connect_gen_XT, symmetry="x" },

  -- Cross shape, no stems are centered
  XX = { conn=4, prob= 50, func=Connect_gen_XX },

  -- H shape, parallel entries/exits at the four corners
  HP = { conn=4, prob= 40, func=Connect_gen_HP, symmetry="x" },

  -- like HP but exits are perpendicular to entry dir
  HT = { conn=4, prob= 40, func=Connect_gen_HT, symmetry="x" },

  -- Swastika shape
  SW = { conn=4, prob= 50, func=Connect_gen_SW, symmetry="R" },

  -- F shape with two exits on each wall
  F4 = { conn=4, prob=  5, func=Connect_gen_F4 },


  -- five-way star shapes
  KY = { conn=5, prob=110, func=Connect_gen_KY, symmetry="x" },
  KT = { conn=5, prob=110, func=Connect_gen_KT, symmetry="x" },

  -- two exits at bottom and three at top, all parallel
  M5 = { conn=5, prob= 40, func=Connect_gen_M5, symmetry="x" },


  -- gigantic six-way shapes
  GG = { conn=6, prob=250, func=Connect_gen_GG, symmetry="x" },
}


function Connect_test_branch_gen(name)
  local info = assert(BRANCH_TABLE[name])

  local function dump_exits(config, W, H)
    local DIR_CHARS = { [2]="|", [8]="|", [4]=">", [6]="<" }

    local P = table.array_2D(W+2, H+2)

    for y = 0,H+1 do for x = 0,W+1 do
      P[x+1][y+1] = sel(geom.inside_box(x,y, 1,1, W,H), "#", " ")
    end end

    for idx = 1,#config,3 do
      local x   = config[idx+0]
      local y   = config[idx+1]
      local dir = config[idx+2]

      assert(x, y, dir)
      assert(geom.inside_box(x,y, 1,1, W,H))

      local nx, ny = geom.nudge(x, y, dir)
      assert(nx==0 or nx==W+1 or ny==0 or ny==H+1)

      if P[nx+1][ny+1] != " " then
        gui.printf("spot: (%d,%d):%d to (%d,%d)\n", x,y,dir, nx,ny)
        error("Bad branch!")
      end

      P[nx+1][ny+1] = DIR_CHARS[dir] or "?"
    end

    for y = H+1,0,-1 do
      for x = 0,W+1 do
        gui.printf("%s", P[x+1][y+1])
      end
      gui.printf("\n")
    end
    gui.printf("\n")
  end

  for deep = 1,9 do for long = 1,9 do
    gui.printf("==== %s %dx%d ==================\n\n", name, long, deep)

    local configs = info.func(long, deep)
    if not configs then
      gui.printf("Unsupported size\n\n")
    else
      each CONF in configs do
        dump_exits(CONF, long, deep)
      end
    end
  end end -- deep, long
end


----------------------------------------------------------------------


function Connect_merge_groups(id1, id2)
  if id1 > id2 then id1,id2 = id2,id1 end

  each R in LEVEL.rooms do
    if R.c_group == id2 then
      R.c_group = id1
    end
  end
end


function Connect_seed_pair(S, T, dir)
  assert(S.room and S.room.kind != "scenic")
  assert(T.room and T.room.kind != "scenic")

  assert(not S.conn and not S.conn_dir)
  assert(not T.conn and not T.conn_dir)

  -- create connection object

  local CONN = CONN_CLASS.new("normal", S.room, T.room, dir)

  CONN.S1 = S
  CONN.S2 = T

  S.conn = CONN
  T.conn = CONN

  S.conn_dir = dir
  T.conn_dir = 10-dir

  S.border[dir].conn = CONN

  table.insert(S.room.conns, CONN)
  table.insert(T.room.conns, CONN)

  -- setup border info

  S.border[dir].kind    = "arch"
  T.border[10-dir].kind = "straddle"

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
    if R1.c_group == R2.c_group then return false end

    return true
  end


  local function add_teleporter(R1, R2)
    gui.debugf("Teleporter connection: %s -- >%s\n", R1:tostr(), R2:tostr())

    Connect_merge_groups(R1.c_group, R2.c_group)

    local C = CONN_CLASS.new("teleporter", R1, R2)

    table.insert(R1.conns, C)
    table.insert(R2.conns, C)

    C.tele_tag1 = Plan_alloc_id("tag")
    C.tele_tag2 = Plan_alloc_id("tag")

    R1.teleport_conn = C
    R2.teleport_conn = C
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

  quota = quota * LEVEL.W / 5
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

    local score = gui.random() * 10

    -- prefer a room touching the edge of the map
    -- (since it is guaranteed to have room for a start closet)
--TODO  if R:touches_map_edge() then score = score + 12 end

    -- not too big !!
    if R.svolume <= 49 then score = score + 10 end

    -- not too small
    if R.svolume >= 12 then score = score + 2 end

    if not R.teleport_conn then score = score + 5 end

    return score
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

  room.purpose = "START"

  -- TODO: try add starting closet
end


function Connect_natural_flow()
  --
  -- Update connections so that 'src' and 'dest' follow the natural
  -- flow of the level, i.e. player always walks from src --> dest
  -- (except when backtracking).
  --

  local function recursive_flow(R, visited)
    assert(R.kind != "scenic")

  --- stderrf("natural_flow @ %s\n", R:tostr())

    visited[R] = true

    if R.kind == "closet" then return end

    if R.kind != "hallway" then
      table.insert(LEVEL.rooms, R)
    end

    each C in R.conns do
      if R == C.R2 and not visited[C.R1] then
        C:swap()
      end

      if R == C.R1 and not visited[C.R2] then
        C.R2.entry_conn = C

        -- recursively handle adjacent room
        recursive_flow(C.R2, visited)
      end
    end
  end


  ---| Connect_natural_flow |---

  LEVEL.rooms = {}

  recursive_flow(LEVEL.start_room, {})
end



function Connect_rooms()
  --
  -- This function ensures all rooms become connected together
  -- (as a simple undirected graph, i.e. no loops).  The exception
  -- is reserved rooms which are handled later.  Rooms can be
  -- connected directly at a boundary or via teleporters.
  --
  -- We also decide the start room here.
  --

  local function min_group_id()
    local result
    
    each R in LEVEL.rooms do
      if not result or R.c_group < result then
        result = R.c_group
      end
    end

    return assert(result)
  end

  local function group_size(id)
    local result = 0

    each R in LEVEL.rooms do
      if R.c_group == id then
        result = result + 1
      end
    end

    return assert(result)
  end

  local function swap_groups(id1, id2)
    assert(id1 != id2)

    each R in LEVEL.rooms do
      if R.c_group == id1 then
        R.c_group = id2
      elseif R.c_group == id2 then
        R.c_group = id1
      end
    end
  end


  local function connect_seeds(S, T, dir)
    gui.debugf("connect_seeds S(%d,%d) %s grp:%d --> S(%d,%d) %s grp:%d\n",
      S.sx, S.sy, S.room:tostr(), S.room.c_group,
      T.sx, T.sy, T.room:tostr(), T.room.c_group)

    Connect_merge_groups(S.room.c_group, T.room.c_group)

    Connect_seed_pair(S, T, dir)

    LEVEL.branched_one = true
  end


  local function morph_size(MORPH, R)
    if MORPH >= 4 then
      return R.sh, R.sw
    else
      return R.sw, R.sh
    end
  end

  local function morph_dir(MORPH, dir)
    if dir == 5 then
      return 5
    end

    if (MORPH % 2) >= 1 then
      if (dir == 4) or (dir == 6) then dir = 10-dir end
    end

    if (MORPH % 4) >= 2 then
      if (dir == 2) or (dir == 8) then dir = 10-dir end
    end

    if MORPH >= 4 then
      dir = geom.RIGHT[dir]
    end

    return dir
  end

  local function morph_coord(MORPH, R, x, y, long, deep)
    assert(1 <= x and x <= long)
    assert(1 <= y and y <= deep)

    if (MORPH % 2) >= 1 then
      x = long+1 - x
    end

    if (MORPH % 4) >= 2 then
      y = deep+1 - y
    end

    if MORPH >= 4 then
      x, y = y, long+1-x
    end

    return R.sx1 + (x-1), R.sy1 + (y-1)
  end

  local function morph_symmetry(MORPH, sym)
    if sym == "x" then
      return sel(MORPH >= 4, "y", "x")
    end

    if sym == "y" then
      return sel(MORPH >= 4, "x", "y")
    end

    -- no change for XY, R and T kinds
    return sym
  end

  local function dump_new_conns(conns)
    gui.debugf("NEW CONNS:\n")
    each C in conns do
      gui.debugf("  S(%d,%d) --> S(%d,%d)  dir:%d\n", C.S.sx,C.S.sy, C.N.sx,C.N.sy, C.dir)
    end
  end

  local function try_configuration(MORPH, R, K, config, long, deep)
    assert(R.c_group)

    local groups_seen = {}
    local conns = {}

    groups_seen[R.c_group] = true

-- gui.debugf("TRY configuration: %s\n", table.tostr(config))

    -- see if the pattern can be used on this room
    -- (e.g. all exits go somewhere and are different groups)

    local hit_conns = 0

    for idx = 1,#config,3 do
      local x   = config[idx+0]
      local y   = config[idx+1]
      local dir = config[idx+2]

      x, y = morph_coord(MORPH, R, x, y, long, deep)
      dir  = morph_dir(MORPH, dir)

      local nx, ny = geom.nudge(x, y, dir)

      if not Seed_valid(nx, ny) then return false end

      local S = SEEDS[ x][ y]
      local N = SEEDS[nx][ny]

      if S.room != R then return false end

      -- handle hits on existing connections
      local existing = false

      if S.conn then
        if S.conn_dir == dir then
          existing = true
        else
          return false -- only one connection per seed!
        end
      end

      if existing then
        hit_conns = hit_conns + 1
      else
        if not N.room or
           not N.room.c_group or
           N.room.kind == "scenic" or
           N.room.branch_kind or
           groups_seen[N.room.c_group] or
           N.conn -- only one connection per seed!
        then
          return false
        end

        -- OK --

        groups_seen[N.room.c_group] = true

        table.insert(conns, { S=S, N=N, dir=dir })
      end
    end

    if hit_conns != #R.conns then
      return false
    end

    -- OK, all points were possible, do it for real

gui.debugf("USING CONFIGURATION: %s\n", K)
gui.debugf("hit_conns = %d\n", hit_conns)

    R.branch_kind = K

    if BRANCH_TABLE[K].symmetry then
      R.symmetry = morph_symmetry(MORPH, BRANCH_TABLE[K].symmetry)
    end

    dump_new_conns(conns)

    each C in conns do
      connect_seeds(C.S, C.N, C.dir)
    end

    return true
  end

  local function try_branch_big_room(R, K)

    gui.debugf("TRYING CONFIGURATION: %s\n", K)

    -- There are THREE morph steps, done in this order:
    -- 1. either rotate the pattern clockwise or not
    -- 2. either flip the pattern horizontally or not
    -- 3. either flip the pattern vertically or not

    local info = assert(BRANCH_TABLE[K])

    local rotates = { 0, 4 }
    local morphs  = { 0, 1, 2, 3 }

    rand.shuffle(rotates)

    each ROT in rotates do
      local long, deep = morph_size(ROT, R)
      local configs = info.func(long, deep)

      if configs then
        rand.shuffle(configs)
        each CONF in configs do
          rand.shuffle(morphs)

          each SUB in morphs do
            local MORPH = ROT + SUB  -- the full morph

            if try_configuration(MORPH, R, K, CONF, long, deep) then
              gui.debugf("Config %s (MORPH:%d) successful @ %s\n",
                         K, MORPH, R:tostr())
              return true -- SUCCESS
            end
          end -- SUB
        end -- CONF
      end
    end -- ROT

gui.debugf("Failed\n")
    return false
  end

  local function branch_big_rooms()
    local rooms = {}

    each R in LEVEL.rooms do
      if R.svolume >= 1 and (R.kind == "building") and not R.parent then
        R.k_score = sel((R.sw%2)==1 and (R.sh%2)==1, 5, 0) + R.svolume + gui.random()
        table.insert(rooms, R)
      end
    end

    if #rooms == 0 then return end

    table.sort(rooms, function(A, B) return A.k_score > B.k_score end)

    local big_bra_chance = rand.key_by_probs { [99] = 80, [50]=12, [10]=3 }
    gui.printf("Big Branch Mode: %d%%\n", big_bra_chance)

    each R in rooms do
      if (#R.conns <= 2) and rand.odds(big_bra_chance) then
        gui.debugf("Branching BIG %s k_score: %1.3f\n", R:tostr(), R.k_score)

        local kinds = {}
        for N,info in pairs(BRANCH_TABLE) do
          kinds[N] = assert(info.prob)
        end

        while not table.empty(kinds) do
          local K = assert(rand.key_by_probs(kinds))

          kinds[K] = nil  -- don't try this branch kind again

          if try_branch_big_room(R, K) then
            break; -- SUCCESS
          end
        end -- while kinds
      end
    end -- for R in rooms
  end


  local function make_scenic(R)
    -- Note: connections must be handled elsewhere

    gui.debugf("Making %s SCENIC\n", R:tostr())
    assert(R.kind != "scenic")

    R.kind = "scenic"
    R.c_group = -1

    R.is_outdoor = true

    -- move the room to the scenic list

    table.kill_elem(LEVEL.rooms, R)

    table.insert(LEVEL.scenic_rooms, R)

    -- remove any arches (from connect_seeds)

    for x = R.sx1, R.sx2 do
    for y = R.sy1, R.sy2 do
      for side = 2,8,2 do
        
        local S = SEEDS[x][y]
        if S.room != R then continue end

        local N  = S:neighbor(side)

        local B1 = S.border[side]
        local B2 = N and N.border[10 - side]

        if B1.kind == "arch" then
          B1.kind = nil

          if B2 then B2.kind = nil end
        end

      end -- side
    end -- x, y
    end
  end


  local function make_conn_scenic(C)
    local found

    each N in LEVEL.conns do
      if N == C then
        table.remove(LEVEL.conns, _index)
        found = true ; break
      end
    end

    assert(found)

    if C.S1 then C.S1.conn = nil ; C.S1.conn_dir = nil end
    if C.S2 then C.S2.conn = nil ; C.S2.conn_dir = nil end

    C.kind = "DEAD"
  end


  local function try_emergency_connect(R, x, y, dir)
    local nx, ny = geom.nudge(x, y, dir)

    if not Seed_valid(nx, ny) then return false end

    local S = SEEDS[ x][ y]
    local N = SEEDS[nx][ny]

    assert(S.room == R)
    assert(N.room != R)

    if not N.room or
       not N.room.c_group or
       N.room.kind == "scenic" or
       N.room.c_group == R.c_group
    then
      return false
    end

    -- only one connection per seed!
    if S.conn or N.conn  then return false end

    connect_seeds(S, N, dir)

    R.branch_kind = "EM"
--  R.old_sym  = R.symmetry
    R.symmetry = nil

    N.room.branch_kind = "EM"
    N.room.symmetry = nil

    return true
  end

  local function score_emerg_branch(R, S, n_side)
    local score = 200 + gui.random()

    -- prefer it away from other connections
    for dist = 1,3 do
      for side = 2,8,2 do if side != n_side then
        local N = S:neighbor(side, dist)
        if N and N.conn_dir then
          score = score - 40 / (dist ^ 2)
        end
      end end -- for side
    end -- for dist

    return score
  end

  local function force_room_branch(R)
    gui.debugf("Emergency connection in %s\n", R:tostr())

    local try_list = {}

    for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
      local S = SEEDS[x][y]
      if S.room == R then
        for side = 2,8,2 do
          local N = S:neighbor(side)
          if N and N.room and N.room != R then
            local score = score_emerg_branch(R, S, side)
            table.insert(try_list, { x=x, y=y, dir=side, score=score })
          end
        end -- for side
      end
    end end -- for x, y

    table.sort(try_list, function(A, B) return A.score > B.score end)

    each L in try_list do
      if try_emergency_connect(R, L.x, L.y, L.dir) then
        return true -- OK
      end
    end

    -- this is not necesarily bad, it could be a group of rooms
    -- where only one of them can make a connection.
    gui.debugf("FAILED!\n")
    return false
  end

  local function handle_isolate(R, join_chance)
    if rand.odds(join_chance) or R.parent or not LEVEL.branched_one then
      if force_room_branch(R) then
        return -- OK
      end
    end

    make_scenic(R)
  end


  local function handle_rebel_group(list, rebel_id, min_g)

    -- if this group is bigger than the main group, swap them
    if group_size(rebel_id) > group_size(min_g) then
      gui.debugf("Crowning rebel group %d (x%d) -> %d (x%d)\n",
          rebel_id, group_size(rebel_id), min_g, group_size(min_g))

      swap_groups(rebel_id, min_g)
    end

    local join_chance = 99
    if STYLE.scenics == "heaps" then join_chance = 66 end

    local rebels = table.subset_w_field(list, "c_group", rebel_id)
    assert(#rebels > 0)
    gui.debugf("#rebels : %d\n", #rebels)

    if rand.odds(join_chance) then
      -- try the least important rooms first
      each R in rebels do
        R.rebel_cost = sel(R.symmetry, 500, 0) + R.svolume + gui.random()
      end

      table.sort(rebels, function(A,B) return A.rebel_cost < B.rebel_cost end)

      each R in rebels do
        if force_room_branch(R) then
          gui.debugf("Branched rebel group %d (now %d)\n", rebel_id, R.c_group)
          return -- OK
        end
      end
    end

    -- make all of them scenic, need to kill the connections
    gui.debugf("Killing rebel group %d (%d rooms)\n", rebel_id, #rebels)

    -- use a copy since we modify the original list
    each C in table.copy(LEVEL.conns) do
      if C.R1.c_group == rebel_id then
        assert(C.R2.c_group == rebel_id)
        make_conn_scenic(C)
      end
    end

    each R in rebels do
      make_scenic(R)
    end
  end

  local function branch_the_rest()
    local min_g = min_group_id()

    -- use a copy since LEVEL.rooms may be modified
    local list = table.copy(LEVEL.rooms)

    local join_chance = 65
    if STYLE.scenics == "few"   then join_chance = 95 end
    if STYLE.scenics == "heaps" then join_chance = 40 end

    if STYLE.scenics == "none" or LEVEL.join_all then join_chance = 100 end

    gui.debugf("Join Chance: %d\n", join_chance)

    repeat
      local changed = false

      each R in list do
        if R.c_group != min_g and R.kind != "scenic" then
          if #R.conns == 0 then
            handle_isolate(R, join_chance)
          else
            handle_rebel_group(list, R.c_group, min_g)
          end

          -- minimum group_id may have changed
          min_g = min_group_id()
          changed = true
        end
      end -- for R
    until not changed
  end

  local function has_scenic_neigbour(R)
    each N in R.neighbors do
      if N.kind == "scenic" then return true end
    end
    return false
  end
    
  local function sprinkle_scenics__OLD()
    -- select some rooms as scenic rooms
    if STYLE.scenics == "none" or STYLE.scenics == "few" then
      return
    end

    local side_prob = sel(STYLE.scenics == "heaps", 60, 10)
    local mid_prob  = sel(STYLE.scenics == "heaps", 20, 3)

    local list = table.copy(LEVEL.rooms)
    rand.shuffle(list)

    each R in list do
      if rand.odds(sel(R.touches_edge, side_prob, mid_prob)) and
         not has_scenic_neigbour(R)
      then
        make_scenic(R)
      end
    end -- for R
  end

  local function count_branches()
    each R in LEVEL.rooms do
      R.num_branch = #R.conns + #R.teleports
      if R.num_branch == 0 then
        error("Room exists with no connections!")
      end
      gui.debugf("Branches in %s --> %d\n", R:tostr(), R.num_branch)
    end
  end


  --==| Connect_rooms |==--

  gui.printf("\n--==| Connecting Rooms |==--\n\n")

  LEVEL.branched_one = false

  each R in LEVEL.rooms do
    R.c_group = _index
    R.teleports = {}
  end

  Connect_teleporters()

  branch_big_rooms()
  branch_the_rest()

  count_branches()

  Connect_start_room()
  Connect_natural_flow()

---  gui.printf("Updated Map:\n")
---  Seed_dump_rooms()
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

