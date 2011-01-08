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
  kind   : keyword  -- "normal", "teleporter", "intrusion"
  lock   : QUEST

  K1, K2 : sections
  R1, R2 : rooms

  dir    : direction 2/4/6/8 (from K1 to K2)
           nil for teleporters.

  conn_h : floor height for connection
}


class HALLWAY
{
  start : SEED   -- the starting seed (in a room)
  dest  : SEED   -- destination seed  (in a room)

  start_dir  --  direction from start --> hallway
  dest_dir   --  direction from hallway --> dest

  path : list  -- the path between the start and the destination
               -- (not including either start or dest).
               -- each element holds the seed and direction.

  sub_halls   -- number of hallways branching off this one
              -- (normally zero)
}

--------------------------------------------------------------]]

require 'defs'
require 'util'


CONN_CLASS = {}

function CONN_CLASS.new_K(K1, K2, kind, dir)
  local C = { K1=K1, K2=K2, R1=K1.room, R2=K2.room, kind=kind, dir=dir }
  table.set_class(C, CONN_CLASS)
  return C
end

function CONN_CLASS.new_R(R1, R2, kind, dir)
  local C = { R1=R1, R2=R2, kind=kind, dir=dir }
  table.set_class(C, CONN_CLASS)
  return C
end

function CONN_CLASS.neighbor(self, R)
  return sel(R == self.R1, self.R2, self.R1)
end

function CONN_CLASS.section(self, R)
  return sel(R == self.R1, self.K1, self.K2)
end

function CONN_CLASS.what_dir(self, R)
  if self.dir then
    return sel(R == self.R1, self.dir, 10 - self.dir)
  end
  return nil
end

function CONN_CLASS.tostr(self)
  return string.format("CONN [%d,%d -> %d,%d]",
         self.K1.kx, self.K1.ky,
         self.K2.kx, self.K2.ky)
end

function CONN_CLASS.swap(self)
  self.K1, self.K2 = self.K2, self.K1
  self.R1, self.R2 = self.R2, self.R1

  if self.dir then self.dir = 10 - self.dir end
end

function CONN_CLASS.k_coord(self)
  return (self.K1.kx + self.K2.kx) / 2,
         (self.K1.ky + self.K2.ky) / 2
end



BIG_CONNECTIONS =
{
  ---==== TWO EXITS ====---

  -- pass through, directly centered
  P1 = { w=3, h=2, prob=30, exits={ 22, 58 }, symmetry="x" },
  P2 = { w=3, h=3, prob=30, exits={ 22, 88 }, symmetry="x" },

  -- pass through, opposite edges
  O1 = { w=2, h=1, prob=25, exits={ 12, 28 } },
  O2 = { w=2, h=2, prob=20, exits={ 12, 58 } },
  O3 = { w=2, h=3, prob=10, exits={ 12, 88 } },

  O4 = { w=3, h=1, prob=25, exits={ 12, 38 } },
  O5 = { w=3, h=2, prob=20, exits={ 12, 68 } },
  O6 = { w=3, h=3, prob=10, exits={ 12, 98 } },

  -- L shape
  L1 = { w=2, h=1, prob=50, exits={ 14, 28 } },
  L2 = { w=2, h=2, prob=40, exits={ 14, 58 } },
  L3 = { w=2, h=3, prob=30, exits={ 14, 88 } },

  L4 = { w=3, h=1, prob=50, exits={ 14, 38 } },
  L5 = { w=3, h=3, prob=20, exits={ 14, 98 } },

  ---==== THREE EXITS ====---
  
  -- T shape, turning left and right
  T1 = { w=1, h=2, prob=70, exits={ 12, 44, 46 }, symmetry="x" },
  T2 = { w=1, h=3, prob=70, exits={ 12, 74, 76 }, symmetry="x" },

  T4 = { w=3, h=1, prob=90, exits={ 22, 14, 36 }, symmetry="x" },
  T5 = { w=3, h=2, prob=90, exits={ 22, 44, 66 }, symmetry="x" },
  T6 = { w=3, h=3, prob=90, exits={ 22, 74, 96 }, symmetry="x" },

  -- Y shape
  Y1 = { w=3, h=1, prob=70, exits={ 22, 18, 38 }, symmetry="x" },
  Y2 = { w=3, h=2, prob=70, exits={ 22, 48, 68 }, symmetry="x" },
  Y3 = { w=3, h=3, prob=70, exits={ 22, 78, 98 }, symmetry="x" },

  -- F shapes
  F1 = { w=2, h=1, prob=21, exits={ 14, 12, 22 } },
  F2 = { w=2, h=2, prob=21, exits={ 44, 12, 22 } },
  F3 = { w=2, h=3, prob=21, exits={ 74, 12, 22 } },

  F4 = { w=3, h=1, prob=15, exits={ 14, 12, 32 } },
  F5 = { w=3, h=2, prob=25, exits={ 44, 12, 32 } },
  F6 = { w=3, h=3, prob=15, exits={ 74, 12, 32 } },

  F7 = { w=3, h=1, prob=15, exits={ 14, 22, 32 } },
  F8 = { w=3, h=2, prob=15, exits={ 44, 22, 32 } },

  ---==== FOUR EXITS ====---

  -- cross shape, all stems perfectly centered
  XP = { w=3, h=3, prob=900, exits={ 22, 44, 66, 88 }, symmetry="xy" },

  -- cross shape, stems at other places
  X1 = { w=3, h=1, prob=400, exits={ 22, 28, 14, 36 }, symmetry="xy" },
  X2 = { w=3, h=2, prob=400, exits={ 22, 58, 44, 66 }, symmetry="xy" },
  X3 = { w=3, h=3, prob=400, exits={ 22, 88, 74, 96 }, symmetry="xy" },

  -- H shape
  H1 = { w=2, h=2, prob=20, exits={ 12,22, 48,58 }, symmetry="xy" },
  H2 = { w=2, h=3, prob=20, exits={ 12,22, 78,88 }, symmetry="xy" },
  H3 = { w=3, h=2, prob=30, exits={ 12,32, 48,68 }, symmetry="xy" },
  H4 = { w=3, h=3, prob=30, exits={ 12,32, 78,98 }, symmetry="xy" },

  -- double-stem T shape
  TT1 = { w=2, h=2, prob=15, exits={ 12,22, 44,56 }, symmetry="x" },
  TT2 = { w=2, h=3, prob=15, exits={ 12,22, 74,86 }, symmetry="x" },
  TT3 = { w=3, h=2, prob=25, exits={ 12,32, 44,66 }, symmetry="x" },
  TT4 = { w=3, h=3, prob=25, exits={ 12,32, 74,96 }, symmetry="x" },

  -- swastika shape
  SWA1 = { w=2, h=2, prob=20, exits={ 12, 26, 44, 58 } },
  SWA2 = { w=3, h=2, prob=20, exits={ 12, 36, 44, 68 } },
  SWA3 = { w=3, h=3, prob=20, exits={ 12, 36, 74, 98 } },

  -- double F shape
  FF1 = { w=3, h=2, prob=15, exits={ 14,44, 22,32 } },
  FF2 = { w=3, h=2, prob=15, exits={ 14,44, 12,32 } },
  FF3 = { w=3, h=3, prob=15, exits={ 44,74, 22,32 } },
  FF4 = { w=3, h=3, prob=30, exits={ 14,74, 12,32 } },
}


CONN_POSITION_X = { 1,2,3, 1,2,3, 1,2,3 }
CONN_POSITION_Y = { 1,1,1, 2,2,2, 3,3,3 }



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
    local R = sel(pass == 1, R1, R2)

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

  return sel(is_good, 1, 0)
end



function Connect_merge_groups(id1, id2)
  if id1 > id2 then id1,id2 = id2,id1 end

  for _,R in ipairs(LEVEL.all_rooms) do
    if R.conn_group == id2 then
      R.conn_group = id1
    end
  end
end



function Connect_make_hallways()

  -- NOTES:
  --
  -- Hallways are created using the "spare" sides of sections, e.g.
  -- if a section is 4 or more seeds wide, then the left or right
  -- side can potentially be used as part of a hallway.
  -- 
  -- Some rules for hallway generation:
  -- 
  -- 1. the "start" of a hallway is the seed on one side of a room
  --    section, and heading outwards.  We have a strong preference
  --    for the seeds left and right of the start (if vertical) to
  --    belong to the same room.
  --
  -- 2. the "destination" of a hallway is also a seed on one side
  --    of a room section, coming inwards.  Also have a strong
  --    preferences for same room on the left or right (if vertical)
  --    or above and below (if horizontal).
  --
  -- 3. the best starts and destinations have the longest number of
  --    seeds which lead directly from/to the room.
  --
  -- 4. seeds belonging to the start section or destination section
  --    cannot be used as part of the hallway path.  i.e. we require
  --    the section side to be kept where it joins a hallway (never
  --    allocated for hallway usage).
  --
  -- 5. starts and destinations are never created directly next to an
  --    existing start or destination.
  --
  -- 6. each segment of a hallway should consist of least 3 seeds
  --    and no more than 7 or 8.  Sometimes allow 2 seeds to create
  --    more zig-zaggy paths.
  --
  -- 7: need ability to start a hallway off an existing hallway.
  --    Probably prefer coming off the middle of a segment rather than
  --    off a junction.
  --

  local function dump_hall_map()
    gui.debugf("Hallway map:\n")

    for sy = SEED_H,1,-1 do
      local line = ""
      
      for sx = 1,SEED_W do
        local S = SEEDS[sx][sy]

        local ch = "."
        if S.hall then ch = "#"
        elseif S.can_hall then ch = "/"
        end

        line = line .. ch
      end

      gui.debugf("%s\n", line)
    end
  end


  local function add_side_to_map(K, side)
    local sx1,sy1, sx2,sy2 = geom.side_coords(side, K.sx1,K.sy1, K.sx2,K.sy2)

    for sx = sx1,sx2 do for sy = sy1,sy2 do
      local S = SEEDS[sx][sy]

      assert(S.K == K)

      S.can_hall = side

      -- check if it a corner
      for corner = 1,9,2 do if corner ~= 5 then
        local cx, cy = geom.pick_corner(corner, K.sx1,K.sy1, K.sx2, K.sy2)
        if sx == cx and sy == cy then
          S.can_hall = corner
        end
      end end

    end end
  end


  local function remove_side_from_map(K, side)
    local sx1,sy1, sx2,sy2 = geom.side_coords(side, K.sx1,K.sy1, K.sx2,K.sy2)

    for sx = sx1,sx2 do for sy = sy1,sy2 do
      local S = SEEDS[sx][sy]

      S.can_hall = nil
    end end
  end


  local function build_hall_map()
    -- can use seeds around edge of map, or any unused seeds
    for sx = 2,SEED_W-1 do for sy = 2,SEED_H-5 do
      local S = SEEDS[sx][sy]
      if not (S.room or S.hall) then
        SEEDS[sx][sy].can_hall = 5
      end
    end end

    -- find the "spare" sides of sections
    for kx = 1,SECTION_W do for ky = 1,SECTION_H do
      local K = SECTIONS[kx][ky]
      if K and K.room then
        
        for side = 2,8,2 do
          local deep = geom.vert_sel(side, K.sh, K.sw)
          if K:same_room(10-side) then deep = deep + 1 end
          if deep >= 4 and not K:same_room(side) then
            add_side_to_map(K, side)
          end
        end

      end
    end end
  end


  local function evaluate_start(S, dir)
    local score = 0

    -- prevent two hallways coming from a single seed
    if S.hall_spot then return -1 end

    -- check seeds on either side
    local A = S:neighbor(geom.RIGHT[dir])
    local B = S:neighbor(geom.LEFT [dir])

    if A and A.hall_spot then return -1 end
    if B and B.hall_spot then return -1 end

    if A and A.room == S.room and B and B.room == S.room then
      score = score + 100
    else
      if rand.odds(90/9) then return -1 end --!!!!!!!
    end

    -- check length of hallway leaving the room
    for i = 2,5 do
      local N = S:neighbor(dir, i)

      if not (N and N.can_hall) then break; end

      score = score + 10
    end

    A = S:neighbor(dir, 2)
    B = S:neighbor(dir, 3)

    return score + (gui.random() ^ 3) * 25
  end


  local function find_starts()
    local list = {}

    for sx = 2,SEED_W-1 do for sy = 2,SEED_H-1 do
      local S = SEEDS[sx][sy]
      if S.K and not S.tried_hall then
        if true ---## not ((sx == S.K.sx1 or sx == S.K.sx2) and
                ---## (sy == S.K.sy1 or sy == S.K.sy2))
        then

          for dir = 2,8,2 do
            local N = S:neighbor(dir)
            if N and N.can_hall and N.room ~= S.room then

              local score = evaluate_start(S, dir)

              if score >= 0 then
                local HALLWAY =
                {
                  start = S,
                  start_dir = dir,
                  score = score,
                }
                table.insert(list, HALLWAY)
              end

            end 
          end -- for dir

        end
      end
    end end -- for sx, sy

do
  return table.pick_best(list, function(A, B) return A.score > B.score end)
end

    table.sort(list, function(A, B) return A.score > B.score end)

    return list
  end


  local function clear(field)
    for sx = 1,SEED_W do for sy = 1,SEED_H do
      local S = SEEDS[sx][sy]
      S[field] = nil
    end end
  end


  local function add_hallway(HALLWAY)
    local S1 = HALLWAY.start
    local S2 = HALLWAY.dest

    S1.hall_spot = true
    S2.hall_spot = true

    local R1 = S1.room
    local R2 = S2.room

    gui.debugf("Hallway connection %s -- >%s\n", R1:tostr(), R2:tostr())

    Connect_merge_groups(R1.conn_group, R2.conn_group)

    local C = CONN_CLASS.new_R(R1, R2, "hallway")

    C.hall = HALLWAY

    table.insert(LEVEL.all_conns, C)

    -- FIXME: section stuff too ???

    table.insert(R1.conns, C)
    table.insert(R2.conns, C)
  end


  local function resize_section(K)
    -- this is complicated since we want to handle corners in the most
    -- optimal way.

    local shrink_sides = {}

    for side = 2,8,2 do
      if K.hall_parts[side] == 1 then
        shrink_sides[side] = true
        assert(not K:same_room(side))
      end
    end

    for corner = 1,9,2 do if corner ~= 5 then
      if K.hall_parts[corner] == 1 then
        local left_dir  = geom.LEFT_45 [corner]
        local right_dir = geom.RIGHT_45[corner]

        local L = shrink_sides[left_dir]
        local R = shrink_sides[right_dir]

        if L or R then
          -- nothing needed

        else
          -- pick a side, prefer largest depth

          local L_deep = K.sw
          local R_deep = K.sh

          if corner == 1 or corner == 9 then
            L_deep, R_deep = K.sh, K.sw
          end

          local L_same = K:same_room(left_dir)
          local R_same = K:same_room(right_dir)

          assert(not (L_same and R_same))

          if L_same then L_deep = -1 end
          if R_same then R_deep = -1 end

          if L_deep >= R_deep then
            shrink_sides[left_dir] = true
          else
            shrink_sides[right_dir] = true
          end
        end
      end
    end end

    -- actually shrink the section
    for side = 2,8,2 do
      if shrink_sides[side] then
        -- mark side as already shrunk
        K.hall_parts[side] = 2

        K:shrink(side)
      end
    end

    for corner = 1,9,2 do
      K.hall_parts[corner] = nil
    end
  end


  -- FIXME FIXME VERY TEMP SHITE !!!  DO THIS ELSEWHERE !!!!
  local function build_seed(P)
    local S = P.S

    local sdx = S.sx - SECTIONS[1][1].sx1
    local sdy = S.sy - SECTIONS[1][1].sy1

    local x1 = SECTIONS[1][1].x1 + sdx * SEED_SIZE
    local y1 = SECTIONS[1][1].y1 + sdy * SEED_SIZE

    local x2 = x1 + SEED_SIZE
    local y2 = y1 + SEED_SIZE

    gui.add_brush(
    {
      { m="solid" },
      { x=x1, y=y1, tex="SILVER1" },
      { x=x2, y=y1, tex="SILVER1" },
      { x=x2, y=y2, tex="SILVER1" },
      { x=x1, y=y2, tex="SILVER1" },
      { b=176, tex="FLAT22", special=9 },
    })

    gui.add_brush(
    {
      { m="solid" },
      { x=x1, y=y1, tex="COMPBLUE" },
      { x=x2, y=y1, tex="COMPBLUE" },
      { x=x2, y=y2, tex="COMPBLUE" },
      { x=x1, y=y2, tex="COMPBLUE" },
      { t=48, tex="FWATER1" },
    })

    for side = 2,8,2 do
      if not P.exits[side] then
        local bx1, by1, bx2, by2 = x1,y1, x2,y2
        if side == 2 then by2 = by1 + 36 end
        if side == 8 then by1 = by2 - 36 end
        if side == 4 then bx2 = bx1 + 36 end
        if side == 6 then bx1 = bx2 - 36 end

        gui.add_brush(
        {
          { m="solid" },
          { x=bx1, y=by1, tex="COMPSPAN" },
          { x=bx2, y=by1, tex="COMPSPAN" },
          { x=bx2, y=by2, tex="COMPSPAN" },
          { x=bx1, y=by2, tex="COMPSPAN" },
        })
      end
    end

    gui.add_entity({ id="2001", x=x1+96, y=y1+96, z=0 })
  end


  local function build_hallway(info)
    -- determine which sides of each seed are an exit
    for index,P in ipairs(info.path) do
      if not P.exits then P.exits = {} end
      P.exits[P.dir] = 1

      if index > 1 then
        P.exits[10 - info.path[index-1].dir] = 1
      else
        P.exits[10 - info.start_dir] = 1
      end
    end

    for _,P in ipairs(info.path) do
      build_seed(P)
    end
  end


  local function add_to_path(info, H, dir, count)
    for d = 1,count do
      local S = H:neighbor(dir, d-1)

      assert(S.can_hall)

      table.insert(info.path, { S=S, dir=dir })

      if S.K then
        info.used_sections[S.K] = true
      end

      H.trace_hall = true
    end
  end


  local function dump_path(path)
    gui.debugf("Path:\n")
    gui.debugf("{\n")
    for _,P in ipairs(path) do
      gui.debugf("  Seed @ (%d,%d) dir:%d\n", P.S.sx, P.S.sy, P.dir)
    end
    gui.debugf("}\n")
  end


  local function render_path(info)
    for _,P in ipairs(info.path) do
      local S = P.S

      assert(S.can_hall)

      if S.K then
        S.K.hall_parts[S.can_hall] = 1
      end

      S.hall = info

      S.can_hall   = nil
      S.trace_hall = nil
    end

    for K,_ in pairs(info.used_sections) do
      resize_section(K)
    end
  end


  local function test_junction(info, juncs, along, H, dir)
    local test_num = sel(info.twisty or rand.odds(0), 2, 3)

    for d = 1,test_num do
      local S = H:neighbor(dir, d) 

      if not (S and S.can_hall) or S.trace_hall then return false end
    end

    -- OK --

    table.insert(juncs, { S=H, dir=dir, along=along })
  end


  local function test_terminator(info, terms, along, H, dir, is_perp)
    local S = H:neighbor(dir)

    if not (S and S.room) then return false end

    if info.used_sections[S.K] then return false end

    if S.hall_spot then return false end

    local K2 = S.K
    local R2 = S.room

    -- cannot enter a room while using the section side for the hallway
    if S.K == H.K then return false end

--FIXME ??????    if K2.hall_parts[10-dir] then return false end

    local R1 = info.start.room

    if Connect_possibility(R1, R2) <= 0 then return false end

    -- OK --

    table.insert(terms, { S=H, dir=dir, dest=S, along=along, K2=K2, R2=R2 })
  end


  local function find_junctions(info, pos, dir)
    local juncs = {}  -- junctions
    local terms = {}  -- terminating places

    local left_dir  = geom.LEFT [dir]
    local right_dir = geom.RIGHT[dir]

    for along = 1,6 do
      local S = pos:neighbor(dir, along)

      -- stop if we run out of usable seeds
      if not (S and S.can_hall) or S.trace_hall or S.bad_hall then
        break;
      end

      -- never use the same section as the start seed
      if pos.K == info.start.K then break; end

      -- segments normally must be 3 or more seeds wide
      if along >= 2 or info.twisty or rand.odds(0) then

        test_junction(info, juncs, along, S, left_dir)
        test_junction(info, juncs, along, S, right_dir)

        test_terminator(info, terms, along, S, dir, true)
        test_terminator(info, terms, along, S, left_dir)
        test_terminator(info, terms, along, S, right_dir)
      end
    end

    return juncs, terms
  end


  local function try_trace_hall(info)
    clear("trace_hall")

    -- did start get removed by previous hallway?
    if not info.start.K then return end

    local K1 = info.start.K
    local R1 = info.start.room

    assert(R1)

--???????    -- side of section already in use?    FIXME for hallway branch-offs
--???????    if K1.hall_parts[info.start_dir] then return false end

    local dir = info.start_dir 
    local pos = info.start:neighbor(dir)

    if not (pos and pos.can_hall) or pos.bad_hall then return false end

    info.path = {}
    info.used_sections = {}

    info.used_sections[K1] = true

    while true do
      local juncs, terms = find_junctions(info, pos, dir)

      -- FIXME: score them and pick best
      local junc = rand.pick(juncs)
      local term = rand.pick(terms)

      if not junc and not term then
        -- nowhere to go?
        -- mark spot as bad for future attempts
        pos.bad_hall = true

        return false
      end

      if junc and term then
        -- TODO: better choice (e.g. prefer junction if none already)
        if rand.odds(30) then
          junc = nil
        else
          term = nil
        end
      end

      -- TERMINATE ? --

      if term then
        info.dest = term.dest
        info.dest_dir = term.dir

        add_to_path(info, pos, dir, term.along)
        add_to_path(info, term.S, term.dir, 1)

        dump_path(info.path)

        render_path(info)

        assert(info.start.room)

        -- OOPS
        if not info.dest.room then
          for _,P in ipairs(info.path) do
            P.S.hall = nil
          end

          return false
        end

        remove_side_from_map(info.start.K, info.start_dir)
        remove_side_from_map(info.dest.K,  10 - info.dest_dir)

Plan_dump_rooms("After Render")
        add_hallway(info)

        return true
      end

      -- TURN LEFT / RIGHT --

      -- mark seeds including start but excluding the next position
      add_to_path(info, pos, dir, junc.along)

      pos = junc.S
      dir = junc.dir
    end
  end


  local function make_hallway(info)
    clear("bad_hall")

gui.debugf("\n\n")
gui.debugf("trying hallway @ %s dir:%d\n", info.start:tostr(), info.start_dir)

    -- occasionally allow short segments
    info.twisty = rand.odds(100)  --!!!! FIXME

    for loop = 1,15 do
      if try_trace_hall(info) then
        -- we're golden
        build_hallway(info)
        dump_hall_map()
        Plan_dump_rooms("After Hallways")
        return;
      end
    end

    info.start.tried_hall = true
  end


  ---| Connect_make_hallways |---

  build_hall_map()

  dump_hall_map()

--  local starts = find_starts()

  for loop = 1,100 do
    local info = find_starts()

--!!!  for _,info in ipairs(starts) do
    make_hallway(info)
  end

  dump_hall_map()

  Plan_dump_rooms("After Hallways")
end



function Connect_rooms()

  -- a "branch" is a room with 3 or more connections.
  -- a "stalk"  is a room with two connections.

  local function initial_groups()
    for index,R in ipairs(LEVEL.all_rooms) do
      R.conn_group = index
    end
  end


  local function already_connected(K1, K2)
    if not (K1 and K2 and K1.room) then return false end
    
    for _,C in ipairs(K1.room.conns) do
      if (C.K1 == K1 and C.K2 == K2) or
         (C.K1 == K2 and C.K2 == K1)
      then
        return true
      end
    end
  end


  local function can_connect(K1, K2)
    if not (K1 and K2) then return false end
    return Connect_possibility(K1.room, K2.room) >= 0
  end

  local function good_connect(K1, dir)
    if not K1 then return false end
    if K1.hall_parts[dir] then return false end

    local K2 = K1:neighbor(dir)
    if not K2 then return false end
    if K2.hall_parts[10-dir] then return false end

    return Connect_possibility(K1.room, K2.room) > 0
  end


  local function add_connection(K1, K2, kind, dir)
    local R = assert(K1.room)
    local N = assert(K2.room)

    gui.printf("Connection from %s --> %s\n", K1:tostr(), K2:tostr())
    gui.debugf("Possibility value: %d\n", Connect_possibility(R, N))

    Connect_merge_groups(R.conn_group, N.conn_group)

    local C = CONN_CLASS.new_K(K1, K2, kind, dir)

    table.insert(LEVEL.all_conns, C)

    table.insert(R.conns, C)
    table.insert(N.conns, C)

    K1.num_conn = K1.num_conn + 1
    K2.num_conn = K2.num_conn + 1

    local E1 = K1.edges[dir]
    local E2 = K2.edges[10-dir]

    local USAGE =
    {
      kind = "door",
      conn = C,
    }

    E1.usage = USAGE
    E2.usage = USAGE

    return C
  end


  local function add_teleporter(R1, R2)
    gui.debugf("Teleporter connection %s -- >%s\n", R1:tostr(), R2:tostr())

    Connect_merge_groups(R1.conn_group, R2.conn_group)

    local C = CONN_CLASS.new_R(R1, R2, "teleporter")

    table.insert(LEVEL.all_conns, C)

    table.insert(R1.conns, C)
    table.insert(R2.conns, C)

    C.tele_tag1 = Plan_alloc_id("tag")
    C.tele_tag2 = Plan_alloc_id("tag")
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
--    add_connection(loc.K, loc.N, "normal", loc.dir)
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
        if N and N.room ~= R then
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
        add_connection(K, N, "normal", loc.dir)
      else
        -- try the other sides
        for dir = 2,8,2 do
          local N = loc.K:neighbor(dir)
          if good_connect(K, dir) then
            add_connection(K, N, "normal", dir)
            break;
          end
        end
      end
    end

--stderrf("DONE\n")

    -- mark room as full (prevent further connections) if all the
    -- optimal locations worked.  For "plus" shaped rooms, three out
    -- of four ain't bad.
    if #R.conns >= sel(R.shape == "L" or R.shape == "U", 2, 3) then
      R.full = true
    end
  end


  local function test_or_set_pattern(do_it, R, info, MORPH)
    local transpose = bit.btest(MORPH, 1)
    local mirror_x  = bit.btest(MORPH, 2)
    local mirror_y  = bit.btest(MORPH, 4)

    -- size check
    if R.kw ~= sel(transpose, info.h, info.w) or
       R.kh ~= sel(transpose, info.w, info.h)
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

      elseif not can_connect(K, N) then
        return false
      
      elseif K.hall_parts[dir] or N.hall_parts[10-dir] then
        return false

      elseif do_it then
        add_connection(K, N, "normal", dir)
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

    if R.shape ~= "rect" then
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
    local visits = table.copy(LEVEL.all_rooms)

    for _,R in ipairs(visits) do
      R.big_score = R.kvolume + 2.5 * gui.random() ^ 2
    end

    table.sort(visits, function(A, B) return A.big_score > B.big_score end)

    for _,R in ipairs(visits) do
      if R.kvolume >= 2 then
        visit_big_room(R)
      end
    end
  end


  local function visit_small_room(R)
    if #R.conns >= 2 then return end

    local list = {}

    for x = R.kx1,R.kx2 do for y = R.ky1,R.ky2 do
      local K = SECTIONS[x][y]
      if K.room == R then

        for dir = 2,8,2 do
          local N = K:neighbor(dir)

          if good_connect(K, dir) and #N.room.conns < 2 then
            table.insert(list, { K=K, N=N, dir=dir })
          end
        end

      end
    end end -- x, y

    if #list == 0 then return end

    local loc = table.pick_best(list,
        function(A, B) return A.K.room.small_score < B.K.room.small_score end)

    add_connection(loc.K, loc.N, "normal", loc.dir)
  end


  local function branch_small_rooms()
    --
    -- Goal here is to make stalks
    --
    local visits = table.copy(LEVEL.all_rooms)

    for _,R in ipairs(visits) do
      R.small_score = R.svolume + 5.0 * gui.random()
    end

    table.sort(visits, function(A, B) return A.small_score < B.small_score end)

    for _,R in ipairs(visits) do
      if R.kvolume <= 2 then
        visit_small_room(R)
      end
    end
  end


  local function emergency_score(K, N, dir)
    if not can_connect(K, N) then return -1 end

    if K.hall_parts[dir] or N.hall_parts[10-dir] then return -1 end

    local score = 0

    if good_connect(K, dir) then
      score = score + 10
    end

    local total_conn = K.num_conn + N.num_conn

    if total_conn == 0 then
      score = score + 5 - math.min(total_conn, 5)
    end

    return score + gui.random()
  end


  local function emergency_branch()
    local loc

    for x = 1,SECTION_W do for y = 1,SECTION_H do
      local K = SECTIONS[x][y]
      for dir = 2,8,2 do
        local N = K:neighbor(dir)
        local score = emergency_score(K, N, dir)
        if score >= 0 and (not loc or score > loc.score) then
          loc = { K=K, N=N, dir=dir, score=score }
        end
      end
    end end -- x, y

    -- nothing possible? hence we are done
    if not loc then return false end

-- stderrf("Emergency conn: %s --> %s  score:%1.2f\n", loc.K:tostr(), loc.N:tostr(), loc.score)

    add_connection(loc.K, loc.N, "normal", loc.dir)

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

    for _,R in ipairs(LEVEL.all_rooms) do
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

      if R.conn_group ~= N.conn_group and
         teleporter_score(N) >= 0
      then
        add_teleporter(R, N)

        table.remove(loc_list, index)
        return true
      end
    end

    return false
  end


  local function decide_teleporters(list)
    LEVEL.teleporter_list = {}

    do return end --!!!!!!

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


  local function pick_tele_spot(R, other_K)
    local loc_list = {}

    for x = R.kx1,R.kx2 do for y = R.ky1,R.ky2 do
      local K = SECTIONS[x][y]
      if K.room == R then
        local score
        
        if other_K then
          score = geom.dist(x, y, other_K.kx, other_K.ky)
        else
          score = R:dist_to_closest_conn(K) or 9
        end

        if K.num_conn == 0 and K ~= other_K then
          score = score + 11
        end

        score = score + gui.random() / 5

        table.insert(loc_list, { K=K, score=score })
      end
    end end -- x, y

    local loc = table.pick_best(loc_list,
        function(A, B) return A.score > B.score end)

    return loc.K  
  end


  local function place_one_tele(R)
    -- we choose two sections, one for outgoing teleporter and one
    -- for the returning spot.

    local out_K = pick_tele_spot(R)
    local in_K  = pick_tele_spot(R, out_K)

    out_K.teleport_out = true
     in_K.teleport_in  = true

    return out_K
  end


  local function place_teleporters()
    -- determine which section(s) of each room to use for teleporters
    for _,C in ipairs(LEVEL.all_conns) do
      if C.kind == "teleporter" then
        if not C.K1 then C.K1 = place_one_tele(C.R1) end
        if not C.K2 then C.K2 = place_one_tele(C.R2) end
      end
    end
  end


  local function validate_connections()
    for _,R in ipairs(LEVEL.all_rooms) do
      if R.kind ~= "scenic" then
        if R.conn_group ~= 1 then
          error("Connecting rooms failed: separate groups exist")
        end
      end
    end
  end


  local function natural_flow(R, visited)
    assert(R.kind ~= "scenic")

    visited[R] = true

    table.insert(LEVEL.all_rooms, R)

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

  table.name_up(BIG_CONNECTIONS)

  Connect_decide_start_room()

  -- give each room a 'conn_group' value, starting at one.
  -- connecting two rooms will merge the groups together.
  -- at the end, only a single group will remain (#1).
  initial_groups()

  Levels_invoke_hook("connect_rooms")

  Connect_make_hallways()

  -- NOTE: doing this here since hallways change the sizes of sections
  Plan_prepare_rooms()

  decide_teleporters()

  branch_big_rooms()
  branch_small_rooms()

  while emergency_branch() do end

  -- FIXME: this is a layout task, move to appropriate file
  place_teleporters()

  validate_connections()

  -- update connections so that 'src' and 'dest' follow the natural
  -- flow of the level, i.e. player always walks src -> dest (except
  -- when backtracking).  Room order is updated too, though quests
  -- will normally change it again.
  LEVEL.all_rooms = {}

  natural_flow(LEVEL.start_room, {})
end

