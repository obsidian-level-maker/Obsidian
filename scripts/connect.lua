------------------------------------------------------------------------
--  CONNECTIONS
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2010 Andrew Apted
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
  kind   : keyword  -- "normal", "teleport", "intrusion"
  lock   : QUEST

  K1, K2 : sections
  R1, R2 : rooms

  dir    : direction 2/4/6/8 (from K1 to K2)

  conn_h : floor height for connection
}

--------------------------------------------------------------]]

require 'defs'
require 'util'


CONN_CLASS = {}

function CONN_CLASS.neighbor(self, R)
  return sel(R == self.R1, self.R2, self.R1)
end

function CONN_CLASS.section(self, R)
  return sel(R == self.R1, self.K1, self.K2)
end

---###  function CONN_CLASS.seed(self, R)
---###    return sel(R == self.R1, self.S1, self.S2)
---###  end

function CONN_CLASS.tostr(self)
  return string.format("CONN [%d,%d -> %d,%d %sh:%s]",
         self.K1.kx, self.K1.ky,
         self.K2.kx, self.K2.ky,
         sel(self.lock, "LOCK ", ""),
         tostring(self.conn_h or 0))
end

function CONN_CLASS.swap(self)
  self.K1, self.K2 = self.K2, self.K1
  self.R1, self.R2 = self.R2, self.R1
---###  self.S1, self.S2 = self.S2, self.S1

  if self.dir then self.dir = 10 - self.dir end
end



BIG_CONNECTIONS =
{
  ---==== TWO EXITS ====---

  -- pass through, directly centered
  PC1 = { w=3, h=2, score=3,0, exits={ 22, 58 }, symmetry="x" },
  PC2 = { w=3, h=3, score=3,0, exits={ 22, 88 }, symmetry="x" },

  -- pass through, opposite edges
  PO1 = { w=2, h=1, score=2.0, exits={ 12, 28 } },
  PO2 = { w=2, h=2, score=2.0, exits={ 12, 58 } },
  PO3 = { w=2, h=3, score=2.0, exits={ 12, 88 } },

  PO4 = { w=3, h=1, score=2.0, exits={ 12, 38 } },
  PO5 = { w=3, h=2, score=2.0, exits={ 12, 68 } },
  PO6 = { w=3, h=3, score=2.0, exits={ 12, 98 } },

  -- L shape
  L1 = { w=2, h=1, score=5.0, exits={ 14, 28 } },
  L2 = { w=2, h=2, score=5.0, exits={ 14, 58 } },
  L3 = { w=2, h=3, score=5.0, exits={ 14, 88 } },

  L4 = { w=3, h=1, score=5.0, exits={ 14, 38 } },
  L5 = { w=3, h=3, score=5.0, exits={ 14, 98 } },

  ---==== THREE EXITS ====---
  
  -- T shape, turning left and right
  T1 = { w=1, h=2, score=3.0, exits={ 12, 44, 46 }, symmetry="x" },
  T2 = { w=1, h=3, score=3.0, exits={ 12, 74, 76 }, symmetry="x" },

  T4 = { w=3, h=1, score=6.0, exits={ 22, 14, 36 }, symmetry="x" },
  T5 = { w=3, h=2, score=6.0, exits={ 22, 44, 66 }, symmetry="x" },
  T6 = { w=3, h=3, score=6.0, exits={ 22, 74, 96 }, symmetry="x" },

  -- Y shape
  Y1 = { w=3, h=1, score=4.5, exits={ 22, 18, 38 }, symmetry="x" },
  Y2 = { w=3, h=2, score=4.5, exits={ 22, 48, 68 }, symmetry="x" },
  Y3 = { w=3, h=3, score=4.5, exits={ 22, 78, 98 }, symmetry="x" },

  -- F shapes
  F1 = { w=2, h=1, score=2.1, exits={ 14, 12, 22 } },
  F2 = { w=2, h=2, score=2.1, exits={ 44, 12, 22 } },
  F3 = { w=2, h=3, score=2.1, exits={ 74, 12, 22 } },

  F4 = { w=3, h=1, score=1.5, exits={ 14, 12, 32 } },
  F5 = { w=3, h=2, score=2.4, exits={ 44, 12, 32 } },
  F6 = { w=3, h=3, score=1.5, exits={ 74, 12, 32 } },

  F7 = { w=3, h=1, score=1.3, exits={ 14, 22, 32 } },
  F8 = { w=3, h=2, score=1.3, exits={ 44, 22, 32 } },

  ---==== FOUR EXITS ====---

  -- cross shape, all stems perfectly centered
  XP = { w=3, h=3, score=16.0, exits={ 22, 44, 66, 88 }, symmetry="xy" },

  -- cross shape, stems at other places
  X1 = { w=3, h=1, score=9.0, exits={ 22, 28, 14, 36 }, symmetry="xy" },
  X2 = { w=3, h=2, score=9.0, exits={ 22, 58, 44, 66 }, symmetry="xy" },
  X3 = { w=3, h=3, score=9.0, exits={ 22, 88, 74, 96 }, symmetry="xy" },

  -- H shape, no turning
  H1 = { w=2, h=2, score=1.2, exits={ 12,22, 48,58 }, symmetry="xy" },
  H2 = { w=2, h=3, score=1.2, exits={ 12,22, 78,88 }, symmetry="xy" },
  H3 = { w=3, h=2, score=1.8, exits={ 12,32, 48,68 }, symmetry="xy" },
  H4 = { w=3, h=3, score=1.8, exits={ 12,32, 78,98 }, symmetry="xy" },

  -- H shape, turning at other end
  HT1 = { w=2, h=2, score=1.3, exits={ 12,22, 44,56 }, symmetry="x" },
  HT2 = { w=2, h=3, score=1.3, exits={ 12,22, 74,86 }, symmetry="x" },
  HT3 = { w=3, h=2, score=2.8, exits={ 12,32, 44,66 }, symmetry="x" },
  HT4 = { w=3, h=3, score=2.8, exits={ 12,32, 74,96 }, symmetry="x" },

  -- swastika shape
  SWA1 = { w=2, h=2, score=1.6, exits={ 12, 26, 44, 58 } },
  SWA2 = { w=3, h=2, score=1.6, exits={ 12, 36, 44, 68 } },
  SWA3 = { w=3, h=3, score=1.6, exits={ 12, 36, 74, 98 } },

  -- double F shape
  FF1 = { w=3, h=2, score=1.5, exits={ 14,44, 22,32 } },
  FF2 = { w=3, h=2, score=1.7, exits={ 14,44, 12,32 } },
  FF3 = { w=3, h=3, score=1.5, exits={ 44,74, 22,32 } },
  FF4 = { w=3, h=3, score=3.1, exits={ 14,74, 12,32 } },
}


CONN_POSITION_X = { 1,2,3, 1,2,3, 1,2,3 }
CONN_POSITION_Y = { 1,1,1, 2,2,2, 3,2,3 }



function Connect_test_big_conns()
  local require_volume -- = 6

  local function dump_exits(name, info)
    local W = assert(info.w)
    local H = assert(info.h)

    -- option to only show rooms of a certain size
    if require_volume and (W*H) ~= require_volume then
      return
    end

    name = name .. ":" .. "      "

    local DIR_CHARS = { [2]="|", [8]="|", [4]=">", [6]="<" }

    local P = table.array_2D(W+2, H+2)

    for y = 0,H+1 do for x = 0,W+1 do
      P[x+1][y+1] = sel(geom.inside_box(x,y, 1,1, W,H), "#", " ")
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

      if P[nx+1][ny+1] ~= " " then
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

    cost = cost + 10 * (gui.random() ^ 2)

    gui.debugf("Start cost @ %s (seeds:%d) --> %1.3f\n", R:tostr(), R.sw * R.sh, cost)

    return cost
  end

  ---| Connect_decide_start_room |---

  for _,R in ipairs(LEVEL.all_rooms) do
    R.start_cost = eval_room(R)
  end

  local start, index = table.pick_best(LEVEL.all_rooms,
    function(A, B) return A.start_cost < B.start_cost end)

  gui.printf("Start room: %s\n", start:tostr())

  -- move it to the front of the list
  table.remove(LEVEL.all_rooms, index)
  table.insert(LEVEL.all_rooms, 1, start)

  LEVEL.start_room = start

  start.purpose = "START"
end


function Connect_rooms()

  -- a "branch" is a room with 3 or more connections.
  -- a "stalk"  is a room with two connections.

  local function initial_groups()
    for index,R in ipairs(LEVEL.all_rooms) do
      R.conn_group = index
      R.conn_rand  = gui.random()
    end
  end

  local function merge_groups(id1, id2)
    if id1 > id2 then id1,id2 = id2,id1 end

    for _,R in ipairs(LEVEL.all_rooms) do
      if R.conn_group == id2 then
        R.conn_group = id1
      end
    end
  end

  local function section_neigbor(kx, ky, dir)
    local nx, ny = geom.nudge(kx, ky, dir)

    if nx < 1 or nx > LEVEL.W or ny < 1 or ny > LEVEL.H then
      return nil
    end

    return LEVEL.section_map[nx][ny]
  end


  local function can_connect(K1, K2)
    if not (K1 and K2) then return false end

    local R = K1.room
    local N = K2.room

    if not (R and N) then return false end

    if R.kind == "scenic" then return false end
    if N.kind == "scenic" then return false end

    if R.conn_group == N.conn_group then return false end

    -- only one way out of the starting room
    if R.purpose == "START" and #R.conns >= 1 then return false end
    if N.purpose == "START" and #N.conns >= 1 then return false end

    -- don't fill small rooms with lots of connections
    if R.sw <= 4 and R.sh <= 4 and #R.conns >= 3 then return false end
    if N.sw <= 4 and N.sh <= 4 and #N.conns >= 3 then return false end

    return true
  end

  local function add_connection(K1, K2, kind, dir)
    local R = assert(K1.room)
    local N = assert(K2.room)

stderrf("add_connection: K%d,%d %s --> K%d,%d %s\n",
        K1.kx, K1.ky, R:tostr(), K2.kx, K2.ky, N:tostr());

    merge_groups(R.conn_group, N.conn_group)

    local CONN =
    {
      kind = kind,
      K1 = K1, K2 = K2,
      R1 = R,  R2 = N,
      dir = dir,
    }

    table.set_class(CONN, CONN_CLASS)

    table.insert(LEVEL.all_conns, CONN)

    table.insert(R.conns, CONN)
    table.insert(N.conns, CONN)
  end


  local function big_room_score(R)
    local score = 0

    if R.shape == "plus" then
      score = 5
    elseif R.shape == "L" and (R.shape_kx == 1 or R.shape_kx == LEVEL.W)
                           and (R.shape_ky == 1 or R.shape_ky == LEVEL.H) then
      -- L shape at optimal position (map corner)
      score = 4
    elseif R.shape ~= "rect" or R.kw >= 3 or R.kh >= 3 then
      score = 3
    elseif R.kw >= 2 and R.kh >= 2 then
      score = 2
    elseif R.kw >= 2 or R.kh >= 2 then
      score = 1
    end

    return score + 2 * (R.conn_rand ^ 0.5)
  end


  local function branch_big_rooms()
    local visits = table.copy(LEVEL.all_rooms)

    for _,R in ipairs(visits) do
      R.big_score = big_room_score(R)
    end

    table.sort(visits, function(A, B) return A.big_score > B.big_score end)

    for _,R in ipairs(visits) do
      -- FIXME
    end
  end


  local function branch_small_rooms()
    local visits = table.copy(LEVEL.all_rooms)

    for _,R in ipairs(visits) do
      R.small_score = R.svolume + R.conn_rand*5
    end

    table.sort(visits, function(A, B) return A.small_score > B.small_score end)

    for _,R in ipairs(visits) do
      -- FIXME
    end
  end


  local function emergency_branches()
    
    -- TODO: teleporters

    local visits = { }
    local SIDES = { 2,4,6,8 }

    for kx = 1,LEVEL.W do for ky = 1,LEVEL.H do
      rand.shuffle(SIDES)
      table.insert(visits, { x=kx, y=ky, sides=table.copy(SIDES) })
    end end

    rand.shuffle(visits)

    for side_idx = 1,4 do
      for _,V in ipairs(visits) do

        local dir = V.sides[side_idx]
        local K = LEVEL.section_map[V.x][V.y]
        local N = section_neigbor(V.x, V.y, dir)

        if can_connect(K, N) then
          add_connection(K, N, "normal", dir)
        end

      end -- for V
    end -- for side_idx
  end


  local function natural_flow(R, visited)
    assert(R.kind ~= "scenic")

    if R.conn_group ~= 1 then
      error("Connecting rooms failed: separate groups exist")
    end

--stderrf("%s : conn_group=%d\n", R:tostr(), R.conn_group or -1)
    visited[R] = true

    for _,C in ipairs(R.conns) do
      if R == C.R2 and not visited[C.R1] then
        C:swap()
      end
      if R == C.R1 and not visited[C.R2] then
        -- recursively handle adjacent room
        natural_flow(C.R2, visited)
        C.R2.entry_conn = C
      end
    end
  end


  --==| Connect_rooms |==--

  gui.printf("\n--==| Connecting Rooms |==--\n\n")

  Connect_decide_start_room()

  -- give each room a 'conn_group' value, starting at one.
  -- connecting two rooms will merge the groups together.
  -- at the end, only a single group will remain (#1).
  initial_groups()

  Levels.invoke_hook("connect_rooms", LEVEL.seed)

  branch_big_rooms()
  branch_small_rooms()

  emergency_branches()

  -- update connections so that 'src' and 'dest' follow the natural
  -- flow of the level, i.e. player always walks src -> dest (except
  -- when backtracking).
  natural_flow(LEVEL.start_room, {})
end

