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
  src    : source ROOM
  dest   : destination ROOM

  src_S  : source SEED
  dest_S : destination SEED

  dir    : direction 2/4/6/8 (from src_S to dest_S)

  conn_h : floor height for connection

  lock   : LOCK
}

--------------------------------------------------------------]]

require 'defs'
require 'util'


Connect = { }


CONN_CLASS = {}

function CONN_CLASS.neighbor(self, R)
  if R == self.src then
    return self.dest
  else
    return self.src
  end
end

function CONN_CLASS.seed(self, R)
  if R == self.src then
    return self.src_S
  else
    return self.dest_S
  end
end

function CONN_CLASS.tostr(self)
  return string.format("CONN [%d,%d -> %d,%d %sh:%s]",
         self.src_S.sx,  self.src_S.sy,
         self.dest_S.sx, self.dest_S.sy,
         sel(self.lock, "LOCK ", ""),
         tostring(self.conn_h))
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

function Connect.gen_PC(long, deep)
  if long < 3 or long > 7 or (long % 2) == 0 or
     deep < 2 or deep > 7 or (long / deep) >= 3
  then
    return nil
  end

  local mx  = int((long+1)/2)

  return {{ mx,1,2, mx,deep,8 }}
end

function Connect.gen_PA(long, deep)
  if long < 2 or long > 4 or deep < 2 or deep > 5 then
    return nil
  end

  return {{ 1,1,2, 1,deep,8 }}
end

function Connect.gen_PR(long, deep)
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

function Connect.gen_PX(long, deep)
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

function Connect.gen_LS(long, deep)
  if long < 2 or long > 6 or deep ~= long then
    return nil
  end

  local configs = {}

  local lee = int((long-1)/2)

  for x = 0,lee do
    table.insert(configs, { 1,1+x,4, long-x,deep,8 })
  end

  return configs
end

function Connect.gen_LX(long, deep)
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

function Connect.gen_U2(long, deep)
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

function Connect.gen_TC(long, deep)
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

function Connect.gen_TX(long, deep)
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

function Connect.gen_TY(long, deep)
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

function Connect.gen_F3(long, deep)
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

function Connect.gen_M3(long, deep)
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

function Connect.gen_XC(long, deep)
  if long < 3 or (long % 2) == 0 or
     deep < 3 or (deep % 2) == 0
  then
     return nil
  end

  local mx = int((long+1)/2)
  local my = int((deep+1)/2)

  return {{ mx,1,2, mx,deep,8, 1,my,4, long,my,6 }}
end

function Connect.gen_XT(long, deep)
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

function Connect.gen_XX(long, deep)
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

function Connect.gen_SW(long, deep)
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

function Connect.gen_HP(long, deep)
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

function Connect.gen_HT(long, deep)
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

function Connect.gen_F4(long, deep)
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

function Connect.gen_KY(long, deep)
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

function Connect.gen_KT(long, deep)
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

function Connect.gen_M5(long, deep)
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

function Connect.gen_GG(long, deep)
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


Connect.BRANCHES =
{
  -- pass through (one side to the other), perfectly centered
  PC = { conn=2, prob=40, func=Connect.gen_PC, symmetry="x" },

  -- pass through, along one side
  PA = { conn=2, prob= 8, func=Connect.gen_PA, symmetry="y" },

  -- pass through, rotation symmetry
  PR = { conn=2, prob=50, func=Connect.gen_PR, symmetry="R" },

  -- pass through, garden variety
  PX = { conn=2, prob= 3, func=Connect.gen_PX },

  -- L shape for square room (transpose symmetrical)
  LS = { conn=2, prob=100, func=Connect.gen_LS, symmetry="T" },

  -- L shape, garden variety
  LX = { conn=2, prob= 3, func=Connect.gen_LX },

  -- U shape, both exits on a single wall
  U2 = { conn=2, prob= 1, func=Connect.gen_U2, symmetry="x" },


  -- T shape, centered main stem, leeway for side stems
  TC = { conn=3, prob=200, func=Connect.gen_TC, symmetry="x" },

  -- like TC but main stem not centered
  TX = { conn=3, prob= 50, func=Connect.gen_TX },

  -- Y shape, two exits parallel to single centered entry
  TY = { conn=3, prob=120, func=Connect.gen_TY, symmetry="x" },

  -- F shape with three exits (mainly for rooms at corner of map)
  F3 = { conn=3, prob=  2, func=Connect.gen_F3 },

  -- three exits along one wall, middle is centered
  M3 = { conn=3, prob=  5, func=Connect.gen_M3, symmetry="x" },


  -- Cross shape, all stems perfectly centered
  XC = { conn=4, prob=1800, func=Connect.gen_XC, symmetry="xy" },

  -- Cross shape, centered main stem, leeway for side stems
  XT = { conn=4, prob=200, func=Connect.gen_XT, symmetry="x" },

  -- Cross shape, no stems are centered
  XX = { conn=4, prob= 50, func=Connect.gen_XX },

  -- H shape, parallel entries/exits at the four corners
  HP = { conn=4, prob= 40, func=Connect.gen_HP, symmetry="x" },

  -- like HP but exits are perpendicular to entry dir
  HT = { conn=4, prob= 40, func=Connect.gen_HT, symmetry="x" },

  -- Swastika shape
  SW = { conn=4, prob= 50, func=Connect.gen_SW, symmetry="R" },

  -- F shape with two exits on each wall
  F4 = { conn=4, prob=  5, func=Connect.gen_F4 },


  -- five-way star shapes
  KY = { conn=5, prob=110, func=Connect.gen_KY, symmetry="x" },
  KT = { conn=5, prob=110, func=Connect.gen_KT, symmetry="x" },

  -- two exits at bottom and three at top, all parallel
  M5 = { conn=5, prob= 40, func=Connect.gen_M5, symmetry="x" },


  -- gigantic six-way shapes
  GG = { conn=6, prob=250, func=Connect.gen_GG, symmetry="x" },
}


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


BIG_CONN_POSITIONS =
{
  { x=1,y=1 }, { x=2,y=1 }, { x=3,y=1 },  -- 1 2 3
  { x=1,y=2 }, { x=2,y=2 }, { x=3,y=2 },  -- 4 5 6
  { x=1,y=3 }, { x=2,y=3 }, { x=3,y=3 },  -- 7 8 9
}



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

      local x = BIG_CONN_POSITIONS[pos].x
      local y = BIG_CONN_POSITIONS[pos].y

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

  local start, index = table.pick_best(LEVEL.all_rooms, function(A, B) return A.start_cost < B.start_cost end)

  gui.printf("Start room: %s\n", start:tostr())

  -- move it to the front of the list
  table.remove(LEVEL.all_rooms, index)
  table.insert(LEVEL.all_rooms, 1, start)

  LEVEL.start_room = start

  start.purpose = "START"
end


function Connect.connect_rooms()

  local function merge_groups(id1, id2)
    if id1 > id2 then id1,id2 = id2,id1 end

    for _,R in ipairs(LEVEL.all_rooms) do
      if R.c_group == id2 then
        R.c_group = id1
      end
    end
  end

  local function min_group_id()
    local result
    
    for _,R in ipairs(LEVEL.all_rooms) do
      if not result or R.c_group < result then
        result = R.c_group
      end
    end

    return assert(result)
  end

  local function group_size(id)
    local result = 0

    for _,R in ipairs(LEVEL.all_rooms) do
      if R.c_group == id then
        result = result + 1
      end
    end

    return assert(result)
  end

  local function swap_groups(id1, id2)
    assert(id1 ~= id2)

    for _,R in ipairs(LEVEL.all_rooms) do
      if R.c_group == id1 then
        R.c_group = id2
      elseif R.c_group == id2 then
        R.c_group = id1
      end
    end
  end

  local function connect_seeds(S, T, dir)
    assert(S.room and S.room.kind ~= "scenic")
    assert(T.room and T.room.kind ~= "scenic")

    S.border[dir].kind    = "arch"
    T.border[10-dir].kind = "straddle"

--!!!??    S.thick[dir] = 24
--!!!??    T.thick[10-dir] = 24

gui.debugf("connect_seeds S(%d,%d) ROOM_%d grp:%d --> S(%d,%d) ROOM_%d grp:%d\n",
S.sx,S.sy, S.room.id, S.room.c_group,
T.sx,T.sy, T.room.id, T.room.c_group)

    merge_groups(S.room.c_group, T.room.c_group)

    local CONN = { dir=dir, src=S.room, dest=T.room, src_S=S, dest_S=T }

    table.set_class(CONN, CONN_CLASS)

    assert(not S.conn and not S.conn_dir)
    assert(not T.conn and not T.conn_dir)

    S.conn = CONN
    T.conn = CONN

    S.conn_dir = dir
    T.conn_dir = 10-dir

    S.conn_peer = T
    T.conn_peer = S

    table.insert(LEVEL.all_conns, CONN)

    table.insert(S.room.conns, CONN)
    table.insert(T.room.conns, CONN)

    LEVEL.branched_one = true

    return CONN
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
    for _,C in ipairs(conns) do
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

      if not Seed.valid(nx, ny, 1) then return false end

      local S = SEEDS[ x][ y][1]
      local N = SEEDS[nx][ny][1]

      if S.room ~= R then return false end

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

    if hit_conns ~= #R.conns then
      return false
    end

    -- OK, all points were possible, do it for real

gui.debugf("USING CONFIGURATION: %s\n", K)
gui.debugf("hit_conns = %d\n", hit_conns)

    R.branch_kind = K

    if Connect.BRANCHES[K].symmetry then
      R.symmetry = morph_symmetry(MORPH, Connect.BRANCHES[K].symmetry)
    end

    dump_new_conns(conns)

    for _,C in ipairs(conns) do
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

    local info = assert(Connect.BRANCHES[K])

    local rotates = { 0, 4 }
    local morphs  = { 0, 1, 2, 3 }

    rand.shuffle(rotates)

    for _,ROT in ipairs(rotates) do
      local long, deep = morph_size(ROT, R)
      local configs = info.func(long, deep)

      if configs then
        rand.shuffle(configs)
        for _,CONF in ipairs(configs) do
          rand.shuffle(morphs)

          for _,SUB in ipairs(morphs) do
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

    for _,R in ipairs(LEVEL.all_rooms) do
      if R.svolume >= 1 and (R.kind == "normal") and not R.parent then
        R.k_score = sel((R.sw%2)==1 and (R.sh%2)==1, 5, 0) + R.svolume + gui.random()
        table.insert(rooms, R)
      end
    end

    if #rooms == 0 then return end

    table.sort(rooms, function(A, B) return A.k_score > B.k_score end)

    local big_bra_chance = rand.key_by_probs { [99] = 80, [50]=12, [10]=3 }
    gui.printf("Big Branch Mode: %d%%\n", big_bra_chance)

    for _,R in ipairs(rooms) do
      if (#R.conns <= 2) and rand.odds(big_bra_chance) then
        gui.debugf("Branching BIG %s k_score: %1.3f\n", R:tostr(), R.k_score)

        local kinds = {}
        for N,info in pairs(Connect.BRANCHES) do
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
    assert(R.kind ~= "scenic")

    R.kind = "scenic"

    -- move the room to the scenic list

    for index,N in ipairs(LEVEL.all_rooms) do
      if N == R then
        table.remove(LEVEL.all_rooms, index)
        R.c_group = -1
        break;
      end
    end

    assert(R.c_group == -1)
    
    table.insert(LEVEL.scenic_rooms, R)

    -- remove any arches (from connect_seeds)

    for x = R.sx1, R.sx2 do for y = R.sy1, R.sy2 do
      for side = 2,8,2 do
        local S = SEEDS[x][y][1]
        if S.room == R then
          local B = S.border[side]
          if B.kind == "arch" then
            B.kind = nil
          end
        end
      end
    end end -- for x, y
  end

  local function make_conn_scenic(C)
    local found

    for index,N in ipairs(LEVEL.all_conns) do
      if N == C then
        table.remove(LEVEL.all_conns, index)
        found = true
        break;
      end
    end

    assert(found)

    table.insert(LEVEL.scenic_conns, C)

    ---## C.src_S.conn  = nil; C.src_S.conn_dir  = nil
    ---## C.dest_S.conn = nil; C.dest_S.conn_dir = nil
  end

  local function try_emergency_connect(R, x, y, dir)
    local nx, ny = geom.nudge(x, y, dir)

    if not Seed.valid(nx, ny, 1) then return false end

    local S = SEEDS[ x][ y][1]
    local N = SEEDS[nx][ny][1]

    assert(S.room == R)
    assert(N.room ~= R)

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
      for side = 2,8,2 do if side ~= n_side then
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
      local S = SEEDS[x][y][1]
      if S.room == R then
        for side = 2,8,2 do
          local N = S:neighbor(side)
          if N and N.room and N.room ~= R then
            local score = score_emerg_branch(R, S, side)
            table.insert(try_list, { x=x, y=y, dir=side, score=score })
          end
        end -- for side
      end
    end end -- for x, y

    table.sort(try_list, function(A, B) return A.score > B.score end)

    for _,L in ipairs(try_list) do
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
      for _,R in ipairs(rebels) do
        R.rebel_cost = sel(R.symmetry, 500, 0) + R.svolume + gui.random()
      end

      table.sort(rebels, function(A,B) return A.rebel_cost < B.rebel_cost end)

      for _,R in ipairs(rebels) do
        if force_room_branch(R) then
          gui.debugf("Branched rebel group %d (now %d)\n", rebel_id, R.c_group)
          return -- OK
        end
      end
    end

    -- make all of them scenic, need to kill the connections
    gui.debugf("Killing rebel group %d (%d rooms)\n", rebel_id, #rebels)

    -- use a copy since we modify the original list
    local c_copy = table.copy(LEVEL.all_conns)

    for _,C in ipairs(c_copy) do
      if C.src.c_group == rebel_id then
        assert(C.dest.c_group == rebel_id)
        make_conn_scenic(C)
      end
    end

    for _,R in ipairs(rebels) do
      make_scenic(R)
    end
  end

  local function branch_the_rest()
    local min_g = min_group_id()

    -- use a copy since LEVEL.all_rooms may be modified
    local list = table.copy(LEVEL.all_rooms)

    local join_chance = 65
    if STYLE.scenics == "few"   then join_chance = 95 end
    if STYLE.scenics == "heaps" then join_chance = 40 end

    if STYLE.scenics == "none" or LEVEL.join_all then join_chance = 100 end

    gui.debugf("Join Chance: %d\n", join_chance)

    repeat
      local changed = false

      for _,R in ipairs(list) do
        if R.c_group ~= min_g and R.kind ~= "scenic" then
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
    for _,N in ipairs(R.neighbors) do
      if N.kind == "scenic" then return true end
    end
    return false
  end
    
  local function sprinkle_scenics()
    -- select some rooms as scenic rooms
    if STYLE.scenics == "none" or STYLE.scenics == "few" then
      return
    end

    local side_prob = sel(STYLE.scenics == "heaps", 60, 10)
    local mid_prob  = sel(STYLE.scenics == "heaps", 20, 3)

    local list = table.copy(LEVEL.all_rooms)
    rand.shuffle(list)

    for _,R in ipairs(list) do
      if rand.odds(sel(R.touches_edge, side_prob, mid_prob)) and
         not has_scenic_neigbour(R)
      then
        make_scenic(R)
      end
    end -- for R
  end

  local function count_branches()
    for _,R in ipairs(LEVEL.all_rooms) do
      R.num_branch = #R.conns + #R.teleports
      if R.num_branch == 0 then
        error("Room exists with no connections!")
      end
      gui.debugf("Branches in %s --> %d\n", R:tostr(), R.num_branch)
    end
  end


  --==| Connect.connect_rooms |==--

  gui.printf("\n--==| Connecting Rooms |==--\n\n")

-- Connect_test_big_conns()

  LEVEL.branched_one = false

  for c_group,R in ipairs(LEVEL.all_rooms) do
    R.c_group = c_group
    R.teleports = {}
  end

  Connect_decide_start_room()

--!!!  sprinkle_scenics()

  branch_big_rooms()
  branch_the_rest()

  count_branches()

  gui.printf("New Seed Map:\n")
  Seed.dump_rooms()
end

