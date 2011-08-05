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


BIG_CONNECTIONS =
{
  ---==== TWO EXITS ====---

  -- pass through, directly centered
  P1 = { w=3, h=2, prob=30, exits={ 22, 58 }, symmetry="x" }
  P2 = { w=3, h=3, prob=30, exits={ 22, 88 }, symmetry="x" }

  -- pass through, opposite edges
  O1 = { w=2, h=1, prob=25, exits={ 12, 28 } }
  O2 = { w=2, h=2, prob=20, exits={ 12, 58 } }
  O3 = { w=2, h=3, prob=10, exits={ 12, 88 } }

  O4 = { w=3, h=1, prob=25, exits={ 12, 38 } }
  O5 = { w=3, h=2, prob=20, exits={ 12, 68 } }
  O6 = { w=3, h=3, prob=10, exits={ 12, 98 } }

  -- L shape
  L1 = { w=2, h=1, prob=50, exits={ 14, 28 } }
  L2 = { w=2, h=2, prob=40, exits={ 14, 58 } }
  L3 = { w=2, h=3, prob=30, exits={ 14, 88 } }

  L4 = { w=3, h=1, prob=50, exits={ 14, 38 } }
  L5 = { w=3, h=3, prob=20, exits={ 14, 98 } }

  ---==== THREE EXITS ====---
  
  -- T shape, turning left and right
  T1 = { w=1, h=2, prob=70, exits={ 12, 44, 46 }, symmetry="x" }
  T2 = { w=1, h=3, prob=70, exits={ 12, 74, 76 }, symmetry="x" }

  T4 = { w=3, h=1, prob=90, exits={ 22, 14, 36 }, symmetry="x" }
  T5 = { w=3, h=2, prob=90, exits={ 22, 44, 66 }, symmetry="x" }
  T6 = { w=3, h=3, prob=90, exits={ 22, 74, 96 }, symmetry="x" }

  -- Y shape
  Y1 = { w=3, h=1, prob=70, exits={ 22, 18, 38 }, symmetry="x" }
  Y2 = { w=3, h=2, prob=70, exits={ 22, 48, 68 }, symmetry="x" }
  Y3 = { w=3, h=3, prob=70, exits={ 22, 78, 98 }, symmetry="x" }

  -- F shapes
  F1 = { w=2, h=1, prob=21, exits={ 14, 12, 22 } }
  F2 = { w=2, h=2, prob=21, exits={ 44, 12, 22 } }
  F3 = { w=2, h=3, prob=21, exits={ 74, 12, 22 } }

  F4 = { w=3, h=1, prob=15, exits={ 14, 12, 32 } }
  F5 = { w=3, h=2, prob=25, exits={ 44, 12, 32 } }
  F6 = { w=3, h=3, prob=15, exits={ 74, 12, 32 } }

  F7 = { w=3, h=1, prob=15, exits={ 14, 22, 32 } }
  F8 = { w=3, h=2, prob=15, exits={ 44, 22, 32 } }

  ---==== FOUR EXITS ====---

  -- cross shape, all stems perfectly centered
  XP = { w=3, h=3, prob=900, exits={ 22, 44, 66, 88 }, symmetry="xy" }

  -- cross shape, stems at other places
  X1 = { w=3, h=1, prob=400, exits={ 22, 28, 14, 36 }, symmetry="xy" }
  X2 = { w=3, h=2, prob=400, exits={ 22, 58, 44, 66 }, symmetry="xy" }
  X3 = { w=3, h=3, prob=400, exits={ 22, 88, 74, 96 }, symmetry="xy" }

  -- H shape
  H1 = { w=2, h=2, prob=20, exits={ 12,22, 48,58 }, symmetry="xy" }
  H2 = { w=2, h=3, prob=20, exits={ 12,22, 78,88 }, symmetry="xy" }
  H3 = { w=3, h=2, prob=30, exits={ 12,32, 48,68 }, symmetry="xy" }
  H4 = { w=3, h=3, prob=30, exits={ 12,32, 78,98 }, symmetry="xy" }

  -- double-stem T shape
  TT1 = { w=2, h=2, prob=15, exits={ 12,22, 44,56 }, symmetry="x" }
  TT2 = { w=2, h=3, prob=15, exits={ 12,22, 74,86 }, symmetry="x" }
  TT3 = { w=3, h=2, prob=25, exits={ 12,32, 44,66 }, symmetry="x" }
  TT4 = { w=3, h=3, prob=25, exits={ 12,32, 74,96 }, symmetry="x" }

  -- swastika shape
  SWA1 = { w=2, h=2, prob=20, exits={ 12, 26, 44, 58 } }
  SWA2 = { w=3, h=2, prob=20, exits={ 12, 36, 44, 68 } }
  SWA3 = { w=3, h=3, prob=20, exits={ 12, 36, 74, 98 } }

  -- double F shape
  FF1 = { w=3, h=2, prob=15, exits={ 14,44, 22,32 } }
  FF2 = { w=3, h=2, prob=15, exits={ 14,44, 12,32 } }
  FF3 = { w=3, h=3, prob=15, exits={ 44,74, 22,32 } }
  FF4 = { w=3, h=3, prob=30, exits={ 14,74, 12,32 } }
}


CONN_POSITION_X = { 1,2,3, 1,2,3, 1,2,3 }
CONN_POSITION_Y = { 1,1,1, 2,2,2, 3,3,3 }



function Connect_test_big_conns()
  local require_volume -- = 6

  local function dump_exits(name, info)
    local W = assert(info.w)
    local H = assert(info.h)

    -- option to only show rooms of a certain size
    if require_volume and (W*H) != require_volume then
      return
    end

    name = name .. ":" .. "      "

    local DIR_CHARS = { [2]="|", [8]="|", [4]=">", [6]="<" }

    local P = table.array_2D(W+2, H+2)

    for y = 0,H+1 do for x = 0,W+1 do
      P[x+1][y+1] = (geom.inside_box(x,y, 1,1, W,H) ? "#" ; " ")
    end end

    for _,exit in ipairs(info.exits) do
      local pos = int(exit / 10)
      local dir =     exit % 10

      local x = CONN_POSITION_X[pos]
      local y = CONN_POSITION_Y[pos]

      assert(x and y)
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
      local line = "      "
      
      if y == H then
        line = string.sub(name, 1, 6)
      end

      for x = 0,W+1 do
        line = line .. P[x+1][y+1]
      end

      gui.printf("%s\n", line)
    end

    gui.printf("\n")
  end

  gui.printf("\n============ BIG CONNECTIONS ==============\n\n")

  local name_list = {}

  for name,_ in pairs(BIG_CONNECTIONS) do
    table.insert(name_list, name)
  end

  table.sort(name_list)

  for _,name in ipairs(name_list) do
    dump_exits(name, BIG_CONNECTIONS[name])
  end

  gui.printf("\n===========================================\n\n")

  error("Connect_test_big_conns finished.")
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


  local function try_add_natural_conn(R)
    local loc_list = {}

    for x = R.kx1,R.kx2 do for y = R.ky1,R.ky2 do
      local K = SECTIONS[x][y]
      if K.room == R and K.num_conn == 0 then

        for dir = 2,8,2 do
          local N = K:neighbor(dir)
          if good_connect(K, dir) then
            local LOC = { K=K, N=N, dir=dir }
            LOC.dist = R:dist_to_closest_conn(K, dir) or 9
            LOC.dist = LOC.dist + gui.random()
            table.insert(loc_list, LOC)
          end
        end

      end
    end end -- x, y

    if #loc_list == 0 then return end

    local loc = table.pick_best(loc_list,
        function(A, B) return A.dist > B.dist end)

-- stderrf("add natural conn: %s --> %s  dist:%1.2f\n", loc.K:tostr(), loc.N:tostr(), loc.dist)
--    add_connection(loc.K, loc.N, loc.dir1)
  end


  local function handle_natural_room(R)
    -- the goal here (as usual) is to force the player to traverse
    -- as much of the cave as possible.  So we want new connections
    -- to be far away from all existing ones.

    local want_conn = rand.key_by_probs { 1, 10, 40, 80, 40 }    

    want_conn = want_conn + math.min(4, R.kvolume) - 4
-- stderrf("handle_natural_room: kvolume:%d --> want_conn:%d\n", R.kvolume, want_conn)
    want_conn = want_conn - #R.conns

    for i = 1,want_conn do
      try_add_natural_conn(R)
    end

    R.full = true
  end


  local function handle_shaped_room(R)
    local mid_K = SECTIONS[R.shape_kx][R.shape_ky]
    assert(mid_K and mid_K.room == R)

    -- determine optimal locations, which are at the extremities of
    -- the shape and going the same way (e.g. for "plus" shape, they
    -- are the North end going North, East end going East etc...)
    local optimal_locs = {}

    if R.shape == "U" then
      local dir = geom.ROTATE[R.shape_rot][2]

      local N1 = mid_K:neighbor(geom.RIGHT[dir])
      local N2 = mid_K:neighbor(geom.LEFT[dir])

      assert(N1.room == R and N2.room == R)

      N1 = N1:neighbor(dir)
      N2 = N2:neighbor(dir)

      assert(N1.room == R and N2.room == R)

      if N1:same_room(dir) then N1 = N1:neighbor(dir) end
      if N2:same_room(dir) then N2 = N2:neighbor(dir) end
        
      table.insert(optimal_locs, { K=N1, dir=dir })
      table.insert(optimal_locs, { K=N2, dir=dir })

    else  -- T or L or plus
      for dir = 2,8,2 do
        if mid_K:same_room(dir) then
          local N = mid_K:neighbor(dir)

          if N:same_room(dir) then N = N:neighbor(dir) end

          table.insert(optimal_locs, { K=N, dir=dir })
        end
      end
    end

    -- for T shapes, sometimes try to go out the middle section
    if (R.shape == "T" or R.shape == "U") and rand.odds(25) then
      for dir = 2,8,2 do
        local N = mid_K:neighbor(dir)
        if N and N.room != R then
          table.insert(optimal_locs, { K=mid_K, dir=dir })
          break;
        end
      end
    end

    -- actually try the connections

--stderrf("ADDING CONNS TO %s SHAPED %s\n", R.shape, R:tostr())

    for _,loc in ipairs(optimal_locs) do
      local K = loc.K
      local N = loc.K:neighbor(loc.dir)
--stderrf("  optimal loc: K(%d,%d) dir=%d\n", K.kx, K.ky, loc.dir)

      if K.num_conn > 0 then
        -- OK
      elseif good_connect(K, loc.dir) then
        add_connection(K, N, loc.dir)
      else
        -- try the other sides
        for dir = 2,8,2 do
          local N = loc.K:neighbor(dir)
          if good_connect(K, dir) then
            add_connection(K, N, dir)
            break;
          end
        end
      end
    end

--stderrf("DONE\n")

    -- mark room as full (prevent further connections) if all the
    -- optimal locations worked.  For "plus" shaped rooms, three out
    -- of four ain't bad.
    if #R.conns >= (R.shape == "L" or R.shape == "U" ? 2 ; 3) then
      R.full = true
    end
  end


  local function test_or_set_pattern(do_it, R, info, MORPH)
    local transpose = bit.btest(MORPH, 1)
    local mirror_x  = bit.btest(MORPH, 2)
    local mirror_y  = bit.btest(MORPH, 4)

    -- size check
    if R.kw != (transpose ? info.h ; info.w) or
       R.kh != (transpose ? info.w ; info.h)
    then
      return false
    end

    local num_matched = 0

    -- allow a teleporter in the room
    if R:has_teleporter() then
      num_matched = 1
    end

    for _,exit in ipairs(info.exits) do
      local pos = int(exit / 10)
      local dir =     exit % 10

      local x = CONN_POSITION_X[pos] - 1
      local y = CONN_POSITION_Y[pos] - 1

      if transpose then
        x,y = y,x
        dir = geom.TRANSPOSE[dir]
      end

      if mirror_x then
        x = R.kw - 1 - x
        if geom.is_horiz(dir) then dir = 10-dir end
      end

      if mirror_y then
        y = R.kh - 1 - y
        if geom.is_vert(dir) then dir = 10-dir end
      end

      assert(0 <= x and x < R.kw)
      assert(0 <= y and y < R.kh)

      local K = SECTIONS[R.kx1 + x][R.ky1 + y]
      assert(K.room == R)

      local N = K:neighbor(dir)

      if already_connected(K, N) then
        num_matched = num_matched + 1

      elseif not can_connect(K, dir) then
        return false
      
      elseif do_it then
        add_connection(K, N, dir)
      end
    end

    -- fail if some of the connections don't match up
    if #R.conns > num_matched then return false end

    return true
  end

  local function try_big_pattern(R, info)
    --
    -- MORPH VALUES
    --   bit 0 : transpose the pattern or not
    --   bit 1 : mirror horizontally or not
    --   bit 2 : mirror vertically or not
    --
    -- (transpose is done before mirroring)
    --
    local morphs = { 0,1,2,3,4,5,6,7 }

    rand.shuffle(morphs)

    for _,MORPH in ipairs(morphs) do
      if test_or_set_pattern(false, R, info, MORPH) then
-- stderrf("BIG PATTERN %s morph:%d in %s\n", info.name, MORPH, R:tostr())
         test_or_set_pattern(true,  R, info, MORPH)
         return true
      end
    end
  end


  local function visit_big_room(R)
    if R.natural then
      handle_natural_room(R)
      return
    end

    if R.shape != "rect" then
      handle_shaped_room(R)
      return
    end

    -- find all BIG-CONN patterns which match this room
    local patterns = {}

    for name,info in pairs(BIG_CONNECTIONS) do
      if (R.kw == info.w and R.kh == info.h) or
         (R.kw == info.h and R.kh == info.w)
      then
        patterns[name] = info.prob
      end
    end

    while not table.empty(patterns) do
      local name = rand.key_by_probs(patterns)

      patterns[name] = nil  -- don't try it again

      if try_big_pattern(R, BIG_CONNECTIONS[name]) then
        -- SUCCESS
        R.big_pattern = name
        R.full = true
        return
      end
    end
  end


  local function branch_big_rooms()
    local visits = table.copy(LEVEL.rooms)

    each R in visits do
      R.big_score = R.kvolume + 2.5 * gui.random() ^ 2
    end

    table.sort(visits, function(A, B) return A.big_score > B.big_score end)

    each R in visits do
      if R.kvolume >= 2 then
        visit_big_room(R)
      end
    end
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


  local function normal_score(K, dir)
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
        local score, N = normal_score(K, dir)

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


  local function teleporter_score(R)
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
      local score = teleporter_score(R)
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
         teleporter_score(N) >= 0
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

    if not PARAM.teleporters then return end

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

