---------------------------------------------------------------
--  PLANNER : EXPERIMENTAL CRAP
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2008 Andrew Apted
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
----------------------------------------------------------------

--[[ *** CLASS INFORMATION ***

class PLAN
{
  all_rooms : array(ROOM) 
  all_conns : array(CONN)

  free_tag  : number
  free_mark : number
}



--------------------------------------------------------------]]

require 'defs'
require 'util'


LAND_W = 0
LAND_H = 0
LAND_MAP = {}


function Plan_alloc_tag()
  local result = PLAN.free_tag
  PLAN.free_tag = PLAN.free_tag + 1

  return result
end

function Plan_alloc_mark()
  local result = PLAN.free_mark
  PLAN.free_mark = PLAN.free_mark + 1

  return result
end


function Landmap_Init()
  LAND_MAP = array_2D(LAND_W, LAND_H)

  for x = 1,LAND_W do for y = 1,LAND_H do
    LAND_MAP[x][y] = { lx=x, ly=y }
  end end
end


function Landmap_valid(x, y)
  return (x >= 1) and (x <= LAND_W) and
         (y >= 1) and (y <= LAND_H)
end


function Landmap_at_edge(x, y)
  return (x == 1) or (x == LAND_W) or
         (y == 1) or (y == LAND_H)
end


function Landmap_rand_visits()
  local visits = {}
  for x = 1,LAND_W do for y = 1,LAND_H do
    table.insert(visits, { x=x, y=y })
  end end -- x,y
  rand_shuffle(visits)
  return visits
end


function Landmap_DoLiquid()
 
  if LAND_W <= 2 or LAND_H <= 2 then return end

  -- Possible liquid patterns:
  --   1. completely surrounded
  --   2. partially surrounded (U shape)
  --   3. river down the middle
  --   4. pool in the middle

  local extra = rand_irange(0,255)

  function surround_mode(x, y)
    if Landmap_at_edge(x, y) then
      LAND_MAP[x][y].kind = "liquid"
    end
  end

  function ushape_mode(x, y)
    if (x == 1      and (extra % 4) == 0) or
       (x == LAND_W and (extra % 4) == 1) or
       (y == 1      and (extra % 4) == 2) or
       (y == LAND_H and (extra % 4) == 3)
    then
      -- skip that side
    else
      surround_mode(x, y)
    end
  end

  function river_mode(x, y)
    if (extra % 2) == 0 then
      if x == int((LAND_W+1)/2) then
        LAND_MAP[x][y].kind = "liquid"
      end
    else
      if y == int((LAND_H+1)/2) then
        LAND_MAP[x][y].kind = "liquid"
      end
    end
  end

  function pool_mode(x, y)
    local pw = 1
    local ph = 1

    if LAND_W >= 7 then pw = 2 end
    if LAND_H >= 7 then ph = 2 end

    local dx = math.abs(x - int((LAND_W+1)/2))
    local dy = math.abs(y - int((LAND_H+1)/2))

    if dx < pw and dy < ph then
      LAND_MAP[x][y].kind = "liquid"
    end
  end


  --- Landmap_DoLiquid ---

  local what = rand_key_by_probs
  {
    none = 200,

--!!!!!    river    = 50,
--(disabled until teleporter logic is sorted out)

    pool     = 50,
    u_shape  = 50,
    surround = 50,
  }

con.debugf("(what: %s)\n", what)
  for x = 1,LAND_W do for y = 1,LAND_H do
    if what == "surround" then surround_mode(x, y) end
    if what == "river"    then river_mode(x, y) end
    if what == "u_shape"  then ushape_mode(x, y) end
    if what == "pool"     then pool_mode(x, y) end
  end end
end


function Landmap_DoGround()

  local function fill_spot(x, y)
    local FILLERS =
    {
      ground = 70, valley = 50, hill = 35,
    }

    FILLERS.none = 60*5  -- variable?  --!!!!!!!!

---###    if false --[[USE_CAVE]] then
---###      FILLERS.cave = sel(Landmap_at_edge(x,y), 60, 5)
---###    end

    local near_lava = false
    for dx = -1,1 do for dy = -1,1 do
      if Landmap_valid(x+dx, y+dy) then
        local L = LAND_MAP[x+dx][y+dy]
        if L.kind == "liquid" then
          near_lava = true
        end
      end
    end end -- dx, dy

    if near_lava then
      FILLERS.valley = 400
    end

    local what = rand_key_by_probs(FILLERS)

    if what ~= "none" then
      LAND_MAP[x][y].kind = what
    end
  end

  local function plant_seedlings()
    for x = 1,LAND_W do
      local poss_y = {}

      for y = 1,LAND_H do
        if not LAND_MAP[x][y].kind then
          table.insert(poss_y, y)
        end
      end

      if #poss_y > 0 then
        local y = rand_element(poss_y)
        fill_spot(x, y)
      end
    end
  end

  local NOLI_TANGERE =
  {
    liquid = true,
    valley = true, ground = true, hill = true
  }

  local GROW_PROBS =
  {
    valley = 40/2, ground = 50/2, hill = 30/2, --!!!!!!
    cave = 70, building = 70, --<< these two have no effect
  }

  local function try_grow_spot(x, y, dir)

    local nx, ny = nudge_coord(x, y, dir)
    if not Landmap_valid(nx, ny) then return false end
     
    local kind = LAND_MAP[x][y].kind
    if not kind then return false end

    if LAND_MAP[nx][ny].kind then return false end

    if NOLI_TANGERE[kind] then
      local ax, ay = nudge_coord(nx, ny, rotate_cw90(dir))
      local bx, by = nudge_coord(nx, ny, rotate_ccw90(dir))

      if Landmap_valid(ax, ay) and LAND_MAP[ax][ay].kind == kind then return false end
      if Landmap_valid(bx, by) and LAND_MAP[bx][by].kind == kind then return false end
    end

    local prob = GROW_PROBS[LAND_MAP[x][y].kind] or 0

    if not prob then return false end

    if rand_odds(prob) then
      LAND_MAP[nx][ny].kind = LAND_MAP[x][y].kind
    end

    -- NOTE: return true here even if did not install anything,
    --       because we have "used up" our growing turn.
    return true
  end

  local function grow_seedlings()
    local x_order = {}
    local y_order = {}
    local d_order = {}

    rand_shuffle(x_order, LAND_W)
    for _,x in ipairs(x_order) do

      rand_shuffle(y_order, LAND_H)
      for _,y in ipairs(y_order) do

        rand_shuffle(d_order, 4)
        for _,d in ipairs(d_order) do
          if try_grow_spot(x, y, d*2) then break; end
        end
      end
    end
  end


  --- Landmap_DoGround ---

  local SPURTS = 12   -- 0 to 12

  plant_seedlings()
  for loop = 1,SPURTS do
    grow_seedlings()
  end
end


function Landmap_DoIndoors()
  local what = rand_key_by_probs
  {
    building = 90, cave = 20
  }

  for x = 1,LAND_W do for y = 1,LAND_H do
    local L = LAND_MAP[x][y]
    if not L.kind then
      L.kind = what
    end
  end end -- x,y
end


function Landmap_Fill()

  local old_LW = LAND_W
  local old_LH = LAND_H

  local half_LW = int((LAND_W+1)/2)
  local half_LH = int((LAND_H+1)/2)

  if LAND_W >= 5 and rand_odds(10) then

con.debugf("(mirroring horizontally LAND_W=%d)\n", LAND_W)
    LAND_W = half_LW ; Landmap_Fill() ; LAND_W = old_LW

    local swap_cave = rand_odds(25)
    local swap_hill = rand_odds(25)

    for x = half_LW+1, LAND_W do
      for y = 1,LAND_H do
        local L = LAND_MAP[LAND_W-x+1][y]
        local N = LAND_MAP[x][y]

        N.kind = L.kind

        if swap_cave then
          if N.kind == "building" then N.kind = "cave"
          elseif N.kind == "cave" then N.kind = "building"
          end
        end

        if swap_hill then
          if N.kind == "ground"   then N.kind = "hill"
          elseif N.kind == "hill" then N.kind = "ground"
          end
        end
      end
    end

    return -- NO MORE

  elseif LAND_H >= 5 and rand_odds(5) then

con.debugf("(mirroring vertically LAND_H=%d)\n", LAND_W)
    LAND_H = half_LH ; Landmap_Fill() ; LAND_H = old_LH

    for y = half_LH+1, LAND_H do
      for x = 1,LAND_W do
        LAND_MAP[x][y].kind = LAND_MAP[x][LAND_H-y+1].kind
      end
    end

    return -- NO MORE
  end 
 
  Landmap_DoLiquid()
---!!!!!!!  Landmap_DoGround()
  Landmap_DoIndoors()
end


function Landmap_Dump()

  local CHARS =
  {
    valley = "1",
    ground = "2",
    hill   = "3",

    building = "r",
    cave     = "c",
    liquid   = "~",
    void     = "#",
  }

  local function land_char(L)
    return (L.kind and CHARS[L.kind]) or "."
  end

  con.debugf("Land Map\n")
  for y = LAND_H,1,-1 do
    local line = "  "
    for x = 1,LAND_W do
      line = line .. land_char(LAND_MAP[x][y])
    end
    con.debugf("%s", line)
  end
  con.debugf("\n")
end


function Landmap_AddBridges()
--[[
    local x_visit = {}
    rand_shuffle(x_visit, LAND_W)

    for _,lx in ipairs(x_visit) do
      local group
      for ly = 1,LAND_H do
        local L = LAND_MAP[lx][ly]
        if L.room and L.room.group_id then
    end -- lx
--]]
end


function Landmap_CreateRooms()
  
  -- creates rooms out of contiguous areas on the land-map

  local function walkable(L)
    if L.kind == "liquid" then return false end
    if L.kind == "void"   then return false end
    return true
  end

  local function block_same(x1,y1, x2,y2)
    if x1 > x2 then x1,x2 = x2,x1 end
    if y1 > y2 then y1,y2 = y2,y1 end

    if not Landmap_valid(x1,y1) then return false end
    if not Landmap_valid(x2,y2) then return false end

    local kind = LAND_MAP[x1][y1].kind

    local corner

    for x = x1,x2 do for y = y1,y2 do
      if LAND_MAP[x][y].room then return false end
      if LAND_MAP[x][y].kind ~= kind then return false end

      -- this logic prevents creating only 1 room on the map
      if LAND_MAP[x][y].corner then
        if corner then return false end
        corner = LAND_MAP[x][y].corner
      end
    end end -- x, y

    return true
  end

  local BIG_BUILDING_PROBS =
  {
    { 40, 70, 15 },
    { 70, 90,  5 },
    { 15,  5,  1 },
  }

  local function prob_for_big_room(kind, w, h)
    if kind == "building" or kind == "cave" then
      if w >= 4 or h >= 4 then return 0 end
      return BIG_BUILDING_PROBS[w][h]
    else -- ground
      if w * h >= 4 then return 0 end
      return 100 * (w * h) * (w * h)
    end
  end

  local function check_expansion(e_infos, e_probs, kind, x,y, dx,dy)
    for w = 1,4 do
      for h = sel(w==1,2,1),4 do
        -- prevent duplicate entries for pure vertical / horizontal
        if (w==1 and dx<0) or (h==1 and dy<0) then
          -- nop
        elseif block_same(x, y, x + (w-1)*dx, y + (h-1)*dy) then

          local INFO =
          {
            x=x, y=y, dx=dx, dy=dy, w=w, h=h
          }

          table.insert(e_infos, INFO)
          table.insert(e_probs, prob_for_big_room(kind, w, h))
  con.debugf("  (%d,%d) w:%d h:%d dx:%d dy:%d\n", x, y, w, h, dx, dy)
        end
      end -- h
    end -- w
  end

  local function expand_room(ROOM, exp)
    local x1, y1 = exp.x, exp.y

    local x2 = x1 + (exp.w - 1)*exp.dx
    local y2 = y1 + (exp.h - 1)*exp.dy

    if x1 > x2 then x1,x2 = x2,x1 end
    if y1 > y2 then y1,y2 = y2,y1 end

    ROOM.lx1 = x1
    ROOM.ly1 = y1
    ROOM.lx2 = x2
    ROOM.ly2 = y2

    for x = x1,x2 do for y = y1,y2 do
      LAND_MAP[x][y].room = ROOM
    end end

    ROOM.is_big = true
  end

  local function create_room(L, x, y)

    local ROOM =
    {
      kind = L.kind,
      group_id = 1 + #PLAN.all_rooms,
      conns = {},
      teleports = {},

      lx1 = x, ly1 = y,
      lx2 = x, ly2 = y,
    }

    table.insert(PLAN.all_rooms, ROOM)

    local e_infos = { "none" }
    local e_probs = { BIG_BUILDING_PROBS[1][1] }
con.debugf("Check expansions:\n{\n")

    for dx = -1,1,2 do for dy = -1,1,2 do
      check_expansion(e_infos, e_probs, ROOM.kind, x, y, dx, dy)
    end end -- dx, dy
con.debugf("}\n")

    local idx = rand_index_by_probs(e_probs)

    local what = e_infos[idx]

    if what == "none" then
      L.room = ROOM
    else
      expand_room(ROOM, what)
    end

    ROOM.sx1 = ROOM.lx1*3-2
    ROOM.sy1 = ROOM.ly1*3-2
    ROOM.sx2 = ROOM.lx2*3
    ROOM.sy2 = ROOM.ly2*3

    ROOM.sw, ROOM.sh = box_size(ROOM.sx1, ROOM.sy1, ROOM.sx2, ROOM.sy2)
    ROOM.lw, ROOM.lh = box_size(ROOM.lx1, ROOM.ly1, ROOM.lx2, ROOM.ly2)

    ROOM.lvol = ROOM.lw * ROOM.lh
  end

  local function assign_corners()
    -- give top/left room and bottom/right room a 'corner' field to
    -- prevent rooms in a small map from glomming into one big room.

    local function top_left()
      for y = LAND_H,1,-1 do for x = 1,LAND_W do
        local L = LAND_MAP[x][y]
        if L.kind and walkable(L) and not L.corner then
          L.corner = 1
          return;
        end
      end end -- y, x
      error("No top-left corner!")
    end

    local function bottom_right()
      for y = 1,LAND_H do for x = LAND_W,1,-1 do
        local L = LAND_MAP[x][y]
        if L.kind and walkable(L) and not L.corner then
          L.corner = 2
          return;
        end
      end end -- y, x
      error("No bottom-right corner!")
    end

    --| assign_corners |--

    top_left()
    bottom_right()
  end

  local function room_char(L)
    if not L.room then return "." end
    local n = 1 + (L.room.group_id % 62)
    return string.sub("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", n, n)
  end

  local function dump_rooms()
    con.debugf("Room Map\n")
    for y = LAND_H,1,-1 do
      local line = "  "
      for x = 1,LAND_W do
        line = line .. room_char(LAND_MAP[x][y])
      end
      con.debugf("%s", line)
    end
    con.debugf("\n")
  end


  ---| Landmap_CreateRooms |---

  assign_corners()

  for _,V in ipairs(Landmap_rand_visits()) do
    local L = LAND_MAP[V.x][V.y]
    if L.kind and walkable(L) and not L.room then
      create_room(L, V.x, V.y) 
    end
  end

  dump_rooms()
end


------------------------------------------------------------------------


function Room_side_len(R, side)
  if (side == 2 or side == 8) then
    return R.sx2 + 1 - R.sx1
  else
    return R.sy2 + 1 - R.sy1
  end
end

function Room_side_coord(R, side, i)
  local x, y

      if side == 2 then x, y = R.sx1 + (i-1), R.sy1
  elseif side == 8 then x, y = R.sx1 + (i-1), R.sy2
  elseif side == 4 then x, y = R.sx1, R.sy1 + (i-1)
  elseif side == 6 then x, y = R.sx2, R.sy1 + (i-1)
  else
    error("Bad side for Room_side_coord!")
  end

  return x, y
end


function Rooms_Nudge()
  
  -- This resizes rooms by moving certain borders either one seed
  -- outward or one seed inward.  There are various constraints,
  -- in particular each room must remain a rectangle shape (so we
  -- disallow nudges that would create an L shaped room).
  --
  -- Big rooms must be handled first, because small rooms are
  -- never able to nudge a big border (one which touches three or
  -- more rooms).
  --
  -- We also give priority to "nasty corners", which have two indoor
  -- areas diagonally opposite, and two outdoor areas diagonally
  -- opposite (like a chess-board).

  local function collect_neighbours()
    -- Determines neighbouring rooms of each room.
    -- Big rooms can have multiple neighbours on some sides.
    
    for _,R in ipairs(PLAN.all_rooms) do
      R.neighbours = { }
    end

    local function add_neighbour(R, side, N)
      -- check if already there
      for _,O in ipairs(R.neighbours) do
        if O == N then return end
      end

      table.insert(R.neighbours, N)
    end

    for lx = 1,LAND_W do for ly = 1,LAND_H do
      local L = LAND_MAP[lx][ly]
      for side = 1,9 do if side ~= 5 then
        local nx, ny = nudge_coord(lx, ly, side)
        if Landmap_valid(nx, ny) then
          local N = LAND_MAP[nx][ny]

          if L.room and N.room and L.room ~= N.room then
            add_neighbour(L.room, side, N.room)
          end
        end
      end end -- side 1-9 except 5
    end end -- lx, ly
  end

  local function volume_after_nudge(R, side, grow)
---###    local rw, rh = box_size(R.sx1,R.sy1, R.sx2,R.sy2)

    if (side == 6 or side == 4) then
      return (R.sw + grow) * R.sh
    else
      return R.sw * (R.sh + grow)
    end
  end

  local function allow_nudge(R, side, pull, grow, N, list)

    -- above or below a sidewards nudge?
    if (side == 6 or side == 4) then
      if N.sy1 > R.sy2 then return true end
      if R.sy1 > N.sy2 then return true end
    else
      if N.sx1 > R.sx2 then return true end
      if R.sx1 > N.sx2 then return true end
    end

    -- opposite side?
    if side == 6 and (N.sx2 < R.sx2) then return true end
    if side == 4 and (N.sx1 > R.sx1) then return true end
    if side == 8 and (N.sy2 < R.sy2) then return true end
    if side == 2 and (N.sy1 > R.sy1) then return true end

--!!!! experiment
if grow < 0 and not pull and not (R.kind == N.kind and
(R.kind == "ground" or R.kind == "valley" or R.kind == "hill"))
then return true end

    if (side == 6 or side == 4) then
      if (N.sy1 < R.sy1) or (N.sy2 > R.sy2) then return false end
    else
      if (N.sx1 < R.sx1) or (N.sx2 > R.sx2) then return false end
    end

    -- the nudge is possible (pushing the neighbour also)

    if N.no_nudge or N.nudges[10-side] then return false end

    if volume_after_nudge(N, 10-side, -grow) < 3 then return false end

--!!!!!!    if side == 6 then assert(N.sx1 == R.sx2+1) end
--!!!!!!    if side == 4 then assert(N.sx2 == R.sx1-1) end
--!!!!!!    if side == 8 then assert(N.sy1 == R.sy2+1) end
--!!!!!!    if side == 2 then assert(N.sy2 == R.sy1-1) end

    table.insert(list, { room=N, side=10-side, grow=-grow })

    return true
  end

  local function try_nudge_room(R, side, pull, grow)
    -- 'pull' true => any shrinkage must pull neighbours too
    -- 'grow' is positive to nudge outward, negative to nudge inward

    if not grow then grow = rand_sel(75,1,-1) end

pull=true; --!!!!!!

con.debugf("Trying to nudge room %dx%d, side:%d grow:%d\n", R.sw, R.sh, side, grow)

    if R.no_nudge then return false end

--[[
    if R.no_grow   and grow > 0 then return false end
    if R.no_shrink and grow < 0 then return false end
--]]

    -- already moved this border?
    if R.nudges[side] then return false end

    -- would get too small?
    if volume_after_nudge(R, side, grow) < 3 then return false end

    -- growth is add edge of map
    if (side == 2 and R.ly1 == 1) or
       (side == 4 and R.lx1 == 1) or
       (side == 6 and R.lx2 == LAND_W) or
       (side == 8 and R.ly2 == LAND_H)
    then
      if grow > 0 then  -- TODO: probably too simple
        return false
      end
    end

    local push_list = {}

    for _,K in ipairs(R.neighbours) do
      if not allow_nudge(R, side, pull, grow, K, push_list) then return false end
    end

    -- Nudge is OK!
    con.printf("Nudging Room (%d,%d) side:%d grow:%d\n", R.lx1, R.ly1, side, grow)

    table.insert(push_list, { room=R, side=side, grow=grow })

    for _,push in ipairs(push_list) do
      local R = push.room

          if push.side == 2 then R.sy1 = R.sy1 - push.grow
      elseif push.side == 8 then R.sy2 = R.sy2 + push.grow
      elseif push.side == 4 then R.sx1 = R.sx1 - push.grow
      elseif push.side == 6 then R.sx2 = R.sx2 + push.grow
      end

      -- fix up seed size
      R.sw, R.sh = box_size(R.sx1, R.sy1, R.sx2, R.sy2)

      assert(not R.nudges[push.side])
      R.nudges[push.side] = true
    end

    return true
  end

  local function nudge_big_rooms()
    local rooms = {}

    for _,R in ipairs(PLAN.all_rooms) do
      if R.lvol >= 2 then
        table.insert(rooms, R)
      end
    end

    if #rooms == 0 then return end

    table.sort(rooms, function(A, B) return A.lvol > B.lvol end)

    local sides = { 2,4,6,8 }

    for _,R in ipairs(rooms) do
      rand_shuffle(sides)
      for _,side in ipairs(sides) do
        local depth = sel(side==4 or side==6, R.sw, R.sh)
        if (depth % 2) == 0 then
          if not (rand_odds(30) and try_nudge_room(R, side, false, 1)) then
            try_nudge_room(R, side, false, -1)
          end
        end
      end
      R.no_nudge = true
    end
  end

  local function get_NE_corner_rooms(R)

    local E, N, NE -- East, North, NorthEast

    for _,K in ipairs(R.neighbours) do

      if K.sx2 == R.sx2 and K.sy1 > R.sy2 then N = K end
      if K.sy2 == R.sy2 and K.sx1 > R.sx2 then E = K end

      if K.sx1 > R.sx2 and K.sy1 > R.sy2 then NE = K end
    end

    return E, N, NE

---##    for _,K in ipairs(R.neighbours[6]) do
---##      if not E or (K.sx1 > E.sx2) then E = K end
---##    end
---##
---##    for _,K in ipairs(R.neighbours[8]) do
---##      if not N or (K.sy1 > N.sy2) then N = K end
---##    end
---##
---##    local A, B
---##
---##    if N then
---##      for _,K in ipairs(N.neighbours[6]) do
---##        if not A or (K.sy2 < A.sy1) then A = K end
---##      end
---##    end
---##
---##    if E then
---##      for _,K in ipairs(E.neighbours[8]) do
---##        if not B or (K.sy2 < B.sy1) then B = K end
---##      end
---##    end
---##
---##    if A and (A.sx1 == R.sx2+1) and (A.sy1 == R.sy2+1) then return E,N,A end
---##    if B and (B.sx1 == R.sx2+1) and (B.sy1 == R.sy2+1) then return E,N,B end
---##
---##    return nil, nil, nil
  end

  local function is_corner_nasty(R, E, N, NE)
    assert(E and N)

    -- has the corner already been nudged?

--[[ THIS CHECK TOO SIMPLE
    if R.nudges[8] or E.nudges[8] or R.nudges[6] or N.nudges[6] then
      return false
    end
--]]

    -- TODO: this check may be too simple....
    if (R.kind == (NE and NE.kind) or N.kind ==  E.kind) and
       (R.kind ~=  E.kind         and N.kind ~= (NE and NE.kind))
    then
      con.printf("Nasty Corner @ (%d,%d) : %s %s | %s %s\n",
                 R.sx2, R.sy2, R.kind, E.kind, N.kind, (NE and NE.kind) or "NIL")
      return true
    end

    return false
  end

  local function nudge_nasty_corners()
    local success

    for _,R in ipairs(PLAN.all_rooms) do
      local E, N, NE = get_NE_corner_rooms(R)
      if N and E and NE and is_corner_nasty(R, E, N, NE) then
        if rand_odds(50) then
          success = try_nudge_room(R, 8, true) or try_nudge_room(R, 6, true) or
                    try_nudge_room(E, 8, true) or try_nudge_room(N, 6, true)
        else
          success = try_nudge_room(R, 6, true) or try_nudge_room(R, 8, true) or
                    try_nudge_room(N, 6, true) or try_nudge_room(E, 8, true)
        end

        if success then
          R.nudges[6] = true; NE.nudges[4] = true
          R.nudges[8] = true; NE.nudges[2] = true
        end
      end
    end -- R in all_rooms
  end

  local function nudge_the_rest()
    local rooms = {}
    for _,R in ipairs(PLAN.all_rooms) do
      if R.lvol < 2 then
        table.insert(rooms, R)
      end
    end

    local sides = { 2,4,6,8 }

    for pass = 1,2 do
      rand_shuffle(rooms)
      for _,R in ipairs(rooms) do
        rand_shuffle(sides)
        for _,side in ipairs(sides) do
          if rand_odds(30) then
            try_nudge_room(R, side)
          end
        end
      end -- R in all_rooms
    end -- pass
  end


  ---| Rooms_Nudge |---

  collect_neighbours()

  for _,R in ipairs(PLAN.all_rooms) do
    R.nudges = {}
  end

  nudge_nasty_corners()
  nudge_big_rooms()
  nudge_the_rest()

  for _,R in ipairs(PLAN.all_rooms) do
    con.printf("Room (%d,%d)  seed size: %dx%d\n", R.lx1,R.ly1, R.sw,R.sh)
  end
end



function Rooms_Make_Seeds()

  local function Plant_Rooms()
    for _,R in ipairs(PLAN.all_rooms) do
      for sx = R.sx1,R.sx2 do for sy = R.sy1,R.sy2 do
        assert(Seed_valid(sx, sy, 1))
        local S = SEEDS[sx][sy][1]
        assert(not S.room) -- no overlaps please!
        S.room = R
        S.borders = {}
      end end
    end
  end

  local function Flow_Liquid()
    for lx = 1,LAND_W do for ly = 1,LAND_H do
      local L = LAND_MAP[lx][ly]
      if not L.room then
        for sx = lx*3-2,lx*3 do for sy = ly*3-2,ly*3 do
          local S = SEEDS[sx][sy][1]
          if not S.room then
            S.room = { kind = L.kind, nowalk=true }
            S.borders = {}
          end
        end end -- sx, sy
      end -- L.room
    end end
  end

  local function Fill_Holes()
    for loop = 1,3 do
      local changed = false

      for x = 1,SEED_W do for y = 1,SEED_H do
        local S = SEEDS[x][y][1]
        if not S.room then
          for dir = 2,8,2 do
            local nx, ny = nudge_coord(x, y, dir)
            local N = Seed_valid(nx, ny, 1) and SEEDS[nx][ny][1]

            if N and N.room and N.room.nowalk then  -- FIXME: UGH!!!
              S.room = N.room
              changed = true
            end
          end
        end
      end end -- x, y

    end ---- until not changed
  end

  local function Border_Up(R)
    for x = R.sx1, R.sx2 do for y = R.sy1, R.sy2 do
      local S = SEEDS[x][y][1]
      for dir = 2,8,2 do
        local nx, ny = nudge_coord(x, y, dir)
        local N
        if Seed_valid(nx, ny, 1) then
          N = SEEDS[nx][ny][1]
        end

        if not N then
          S.borders[dir] = { kind="solid" }

        elseif N.room == R then
          -- same room, do nothing
          
        elseif R.kind == "building" or R.kind == "cave" then
          S.borders[dir] = { kind="solid" }

---#    elseif N.room and N.room.nowalk then
---#      -- deadly lava, nothing needed

--[[
        elseif N.room and (N.room.kind == R.kind) and
               (R.kind == "ground" or R.kind == "valley" or R.kind == "hill")
        then
          -- same outdoor area, do nothing
          -- FIXME: ONLY DO IT FOR C.src/C.dest and not C.lock
--]]
        else
          S.borders[dir] = { kind="fence" }
        end
      end
    end end -- x, y
  end


  ---| Rooms_MakeSeeds |---

  Seed_init(LAND_W*3, LAND_H*3, 1, { zone_kind="solid"})

  Plant_Rooms()
  Flow_Liquid()
  Fill_Holes()

  for _,R in ipairs(PLAN.all_rooms) do
    Border_Up(R)
  end

  Seed_dump_fabs()
end


------------------------------------------------------------------------


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
-- mirrorings (none/X/Y/XY) of each configuration, and these
-- generator functions are optimised with that in mind.
--
-- The 'symmetry' field, when set, is a direction (1-9) of the
-- axis of symmetry.  Hence "2" means the pattern will be the same
-- when flipped horizontally.  The value "5" is used for four-way
-- symmetry (pattern is mirrored both horizontally or vertically).


--- 2 way --->

function branch_gen_PC(long, deep)
  if long < 3 or long > 7 or (long % 2) == 0 or
     deep < 2 or deep > 7 or (long / deep) >= 3
  then
    return nil
  end

  local mx  = int((long+1)/2)

  return {{ mx,1,2, mx,deep,8 }}
end

function branch_gen_PA(long, deep)
  if long < 2 or long > 4 or deep > 5 then
    return nil
  end

  return {{ 1,1,2, 1,deep,8 }}
end

function branch_gen_PR(long, deep)
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

function branch_gen_PX(long, deep)
  if long < 3 or long > 5 or deep < 1 or deep > 5 then
    return nil
  end

  local configs = {}
  local mx = int(long/2)

  for b = 1,mx do for t = 2,long-1 do
    table.insert(configs, { b,1,2, t,deep,8 })
  end end

  return configs
end

function branch_gen_LS(long, deep)
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

function branch_gen_LX(long, deep)
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

function branch_gen_U2(long, deep)
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

function branch_gen_TC(long, deep)
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

function branch_gen_TX(long, deep)
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

function branch_gen_TY(long, deep)
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

function branch_gen_F3(long, deep)
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

function branch_gen_M3(long, deep)
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

function branch_gen_XC(long, deep)
  if long < 3 or (long % 2) == 0 or
     deep < 3 or (deep % 2) == 0
  then
     return nil
  end

  local mx = int((long+1)/2)
  local my = int((deep+1)/2)

  return {{ mx,1,2, mx,deep,8, 1,my,4, long,my,6 }}
end

function branch_gen_XT(long, deep)
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

function branch_gen_XX(long, deep)
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

function branch_gen_SW(long, deep)
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

function branch_gen_HP(long, deep)
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

function branch_gen_HT(long, deep)
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

function branch_gen_F4(long, deep)
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

function branch_gen_KY(long, deep)
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

function branch_gen_KT(long, deep)
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

function branch_gen_M5(long, deep)
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

function branch_gen_GG(long, deep)
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


BIG_BRANCH_KINDS =
{
  -- pass through (one side to the other), perfectly centered
  PC = { conn=2, prob=40, func=branch_gen_PC, symmetry=5 },

  -- pass through, along one side
  PA = { conn=2, prob= 8, func=branch_gen_PA, symmetry=6 },

  -- pass through, rotation symmetry
  PR = { conn=2, prob=20, func=branch_gen_PR },

  -- pass through, garden variety
  PX = { conn=2, prob= 3, func=branch_gen_PX },

  -- L shape for square room (transpose symmetrical)
  LS = { conn=2, prob=20, func=branch_gen_LS },

  -- L shape, garden variety
  LX = { conn=2, prob= 3, func=branch_gen_LX },

  -- U shape, both exits on a single wall
  U2 = { conn=2, prob= 1, func=branch_gen_U2, symmetrical=2 },


  -- T shape, centered main stem, leeway for side stems
  TC = { conn=3, prob=200, func=branch_gen_TC, symmetry=2 },

  -- like TC but main stem not centered
  TX = { conn=3, prob= 50, func=branch_gen_TX },

  -- Y shape, two exits parallel to single centered entry
  TY = { conn=3, prob=120, func=branch_gen_TY, symmetry=2 },

  -- F shape with three exits (mainly for rooms at corner of map)
  F3 = { conn=3, prob=  2, func=branch_gen_F3 },

  -- three exits along one wall, middle is centered
  M3 = { conn=3, prob=  5, func=branch_gen_M3, symmetry=2 },


  -- Cross shape, all stems perfectly centered
  XC = { conn=4, prob=900, func=branch_gen_XC, symmetry=5 },

  -- Cross shape, centered main stem, leeway for side stems
  XT = { conn=4, prob=300, func=branch_gen_XT, symmetry=2 },

  -- Cross shape, no stems are centered
  XX = { conn=4, prob=100, func=branch_gen_XX },

  -- H shape, parallel entries/exits at the four corners
  HP = { conn=4, prob= 60, func=branch_gen_HP, symmetry=2 },

  -- like HP but exits are perpendicular to entry dir
  HT = { conn=4, prob= 60, func=branch_gen_HT, symmetry=2 },

  -- Swastika shape
  SW = { conn=4, prob=  5, func=branch_gen_SW },

  -- F shape with two exits on each wall
  F4 = { conn=4, prob=  5, func=branch_gen_F4 },


  -- five-way star shapes
  KY = { conn=5, prob=150, func=branch_gen_KY, symmetry=2 },
  KT = { conn=5, prob=150, func=branch_gen_KT, symmetry=2 },

  -- two exits at bottom and three at top, all parallel
  M5 = { conn=5, prob= 40, func=branch_gen_M5, symmetry=2 },


  -- gigantic six-way shapes
  GG = { conn=6, prob=350, func=branch_gen_GG, symmetry=2 },
}


function Test_Branch_Gen(name)
  local info = assert(BIG_BRANCH_KINDS[name])

  local function dump_exits(config, W, H)
    local DIR_CHARS = { [2]="|", [8]="|", [4]=">", [6]="<" }

    local P = array_2D(W+2, H+2)

    for y = 0,H+1 do for x = 0,W+1 do
      P[x+1][y+1] = sel(box_contains_point(1,1,W,H, x,y), "#", " ")
    end end

    for idx = 1,#config,3 do
      local x   = config[idx+0]
      local y   = config[idx+1]
      local dir = config[idx+2]

      assert(x, y, dir)
      assert(box_contains_point(1,1,W,H, x,y))

      local nx, ny = nudge_coord(x, y, dir)
      assert(nx==0 or nx==W+1 or ny==0 or ny==H+1)

      if P[nx+1][ny+1] ~= " " then
        con.printf("spot: (%d,%d):%d to (%d,%d)\n", x,y,dir, nx,ny)
        error("Bad branch!")
      end

      P[nx+1][ny+1] = DIR_CHARS[dir] or "?"
    end

    for y = H+1,0,-1 do
      for x = 0,W+1 do
        con.printf("%s", P[x+1][y+1])
      end
      con.printf("\n")
    end
    con.printf("\n")
  end

  for deep = 1,9 do for long = 1,9 do
    con.printf("==== %s %dx%d ==================\n\n", name, long, deep)

    local configs = info.func(long, deep)
    if not configs then
      con.printf("Unsupported size\n\n")
    else
      for _,CONF in ipairs(configs) do
        dump_exits(CONF, long, deep)
      end
    end
  end end -- deep, long
end


function Rooms_Connect()

  -- Guidelines:
  -- 1. prefer a "wide" bond between ground areas of same kind.
  -- 2. prefer not to connect ground areas of different kinds.
  -- 3. prefer ground areas not to be leafs
  -- 4. prefer big rooms to have 3 or more connections.
  -- 5. prefer small isolated rooms to be leafs (1 connection).

  local function merge(id1, id2)
    if id1 > id2 then id1,id2 = id2,id1 end

    for x = 1,LAND_W do for y = 1,LAND_H do
      local L = LAND_MAP[x][y]
      if L.room and L.room.group_id == id2 then
        L.room.group_id = id1
      end
    end end -- x,y
  end

  local function connect_seeds(S, T, dir, c_kind)
    S.borders[dir]    = { kind="open" }
    T.borders[10-dir] = { kind="open" }

    merge(S.room.group_id, T.room.group_id)

    local CONN = { dir=dir, src=S.room, dest=T.room, src_S=S, dest_S=T }

    table.insert(PLAN.all_conns, CONN)

    table.insert(S.room.conns, CONN)
    table.insert(T.room.conns, CONN)

    return CONN
  end

  local function connect_land(L, N, dir, c_kind)

    assert(L.room ~= N.room)

    -- the middle seed of a 3x3 land block is always valid
    -- (since we never nudge more than 1 seed in any direction).
    -- So start there and find the border....

    local sx = L.lx * 3 - 1
    local sy = L.ly * 3 - 1

    local R = SEEDS[sx][sy][1].room
    assert(R)

    while true do
      local tx, ty = nudge_coord(sx, sy, dir)
      assert(Seed_valid(tx, ty, 1))

      if SEEDS[tx][ty][1].room ~= R then
        break;
      end

      sx, sy = tx, ty
    end

    local tx, ty = nudge_coord(sx, sy, dir)

    -- try moving to the side sometimes
    if rand_odds(14) then
      local ax, ay = dir_to_across(dir)
      if rand_odds(50) then ax, ay = -ax, -ay end

      if Seed_valid(sx+ax, sy+ay, 1) and
         Seed_valid(tx+ax, ty+ay, 1) and
         SEEDS[sx+ax][sy+ay][1].room == SEEDS[sx][sy][1].room and
         SEEDS[tx+ax][ty+ay][1].room == SEEDS[tx][ty][1].room
      then
        sx, sy = sx+ax, sy+ay
        tx, ty = tx+ax, ty+ay
      end
    end

    local S = SEEDS[sx][sy][1]
    local T = SEEDS[tx][ty][1]

    assert(T.sx == S.sx or T.sy == S.sy)

    connect_seeds(S, T, dir, c_kind)
  end

  local function is_ground(L)
    return (L.kind == "valley") or (L.kind == "ground") or
           (L.kind == "hill")
  end

  local function join_ground()
    for _,V in ipairs(Landmap_rand_visits()) do
      local L = LAND_MAP[V.x][V.y]
      if is_ground(L) then
        for dir = 2,8,2 do
          local nx, ny = nudge_coord(V.x, V.y, dir)
          local N = Landmap_valid(nx,ny) and LAND_MAP[nx][ny]
          if N and N.kind == L.kind and N.room and
             N.room.group_id ~= L.room.group_id
          then
            connect_land(L, N, dir, "tight")
          end
        end -- for dir
      end
    end -- for V in visits
  end


  local function morph_size(MORPH, R)
    if MORPH >= 4 then
      return R.sh, R.sw
    else
      return R.sw, R.sh
    end
  end

  local function morph_dir(MORPH, dir)
    if (MORPH % 2) >= 1 then
      if (dir == 4) or (dir == 6) then dir = 10-dir end
    end

    if (MORPH % 4) >= 2 then
      if (dir == 2) or (dir == 8) then dir = 10-dir end
    end

    if MORPH >= 4 then
      dir = rotate_cw90(dir)
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

  local function try_configuration(MORPH, R, K, config, long, deep)
    assert(R.group_id)

    local groups_seen = {}
    local conns = {}

    groups_seen[R.group_id] = true

-- con.debugf("TRY configuration: %s\n", table_to_str(config))

    -- see if the pattern can be used on this room
    -- (e.g. all exits go somewhere and are different groups)

    local hit_conns = 0

    for idx = 1,#config,3 do
      local x   = config[idx+0]
      local y   = config[idx+1]
      local dir = config[idx+2]

      x, y = morph_coord(MORPH, R, x, y, long, deep)
      dir  = morph_dir(MORPH, dir)

      local nx, ny = nudge_coord(x, y, dir)

      if not Seed_valid(nx, ny, 1) then return false end

      local S = SEEDS[ x][ y][1]
      local N = SEEDS[nx][ny][1]

      if S.room ~= R then return false end

      -- handle hits on existing connections
      local existing = false

      for _,C in ipairs(R.conns) do
        if (C.src  == R and C.src_S  == S and C.dir == dir) or
           (C.dest == R and C.dest_S == S and C.dir == 10-dir)
        then
          existing = true; break;
        end
      end

      if existing then
        hit_conns = hit_conns + 1
      else
        local gap

        -- handle rooms separated by a nudge gap
        if not N.room then
          gap = N
          nx, ny = nudge_coord(nx, ny, dir)
          if not Seed_valid(nx, ny, 1) then return false end
          N = SEEDS[nx][ny][1]
        end

        if not N.room or not N.room.group_id then return false end
        if N.room.branch_kind then return false end

        if N.bridged_dir and (N.bridged_dir ~= dir) and (N.bridged_dir ~= 10-dir) then return false end

        if groups_seen[N.room.group_id] then return false end

        -- OK --

        groups_seen[N.room.group_id] = true

        table.insert(conns, { S=S, N=N, dir=dir, gap=gap })
      end
    end

    if hit_conns ~= #R.conns then
      return false
    end

con.debugf("USING CONFIGURATION: %s\n", K)
con.debugf("hit_conns = %d\n", hit_conns)

    -- OK, all points were possible, do it for real
    for _,C in ipairs(conns) do

      local CONN = connect_seeds(C.S, C.N, C.dir, "normal")

---!!!      if T[1] == 2 and T[2] == 1 then
---!!!        R.big_orientation = 10-dir
---!!!        CONN.big_entrance = R
---!!!con.debugf("Room (%d,%d) : big_orientation:%d\n", R.lx1,R.ly1, R.big_orientation)
---!!!      end

      if C.gap then
        con.debugf("Bridged the GAP!!!\n")
        C.gap.room = R --!!!!!!!!! FIXME FIXME FIXME
        C.gap.bridged_dir = C.dir
      end
    end

    R.branch_kind = K

    return true
  end

  local function try_branch_big_room(R, K)

    con.debugf("TRYING CONFIGURATION: %s\n", K)

    -- There are THREE morph steps, done in this order:
    -- 1. either rotate the pattern clockwise or not
    -- 2. either flip the pattern horizontally or not
    -- 3. either flip the pattern vertically or not

    local info = assert(BIG_BRANCH_KINDS[K])

    local rotates = { 0, 4 }
    local morphs  = { 0, 1, 2, 3 }

    rand_shuffle(rotates)

    for _,ROT in ipairs(rotates) do
      local long, deep = morph_size(ROT, R)
      local configs = info.func(long, deep)

      if configs then
        rand_shuffle(configs)
        for _,CONF in ipairs(configs) do
          rand_shuffle(morphs)

          for _,SUB in ipairs(morphs) do
            local MORPH = ROT + SUB  -- the full morph

            if try_configuration(MORPH, R, K, CONF, long, deep) then
              con.debugf("Config %s (MORPH:%d) successful @ Room (%d,%d)\n",
                         K, MORPH, R.lx1, R.ly1)
              return true -- SUCCESS
            end
          end -- SUB
        end -- CONF
      end
    end -- ROT

con.debugf("Failed\n")
    return false
  end

  local function branch_big_rooms()
    local rooms = {}

    for _,R in ipairs(PLAN.all_rooms) do
      R.svol = R.sw * R.sh -- FIXME !!!!!! OUT OF HERE

      if R.svol >= 1 and (R.kind == "building" or R.kind == "cave") then
        table.insert(rooms, R)
      end
    end

    if #rooms == 0 then return end

    -- add some randomness (break deadlocks)
    rand_shuffle(rooms)

    table.sort(rooms, function(A, B) return A.svol > B.svol end)

    for _,R in ipairs(rooms) do
      if (#R.conns <= 2) and rand_odds(99) then
        con.debugf("Branching BIG ROOM at L(%d,%d) area: %1.3f\n", R.lx1,R.ly1, R.svol)

        local kinds = {}
        for N,info in pairs(BIG_BRANCH_KINDS) do
          kinds[N] = assert(info.prob)
        end

        while not table_empty(kinds) do
          local K = assert(rand_key_by_probs(kinds))

          kinds[K] = nil  -- don't try this branch kind again

          if try_branch_big_room(R, K) then
            break; -- SUCCESS
          end
        end -- while kinds
      end
    end -- for R in rooms
  end

  local function branch_the_rest()
    -- Make sure all contiguous rooms are connected.

    -- need to repeat this a few times since we only branch off a
    -- room once in each pass (the break; after connect).  Hackish.
    for loop = 1,4 do

      local dirs = { 2,4,6,8 }
      for _,V in ipairs(Landmap_rand_visits()) do
        local L = LAND_MAP[V.x][V.y]
        rand_shuffle(dirs)
        for _,dir in ipairs(dirs) do
          local nx, ny = nudge_coord(V.x, V.y, dir)
          local N = Landmap_valid(nx,ny) and LAND_MAP[nx][ny]
          if N and L.room and N.room and L.room.group_id ~= N.room.group_id and
             not (L.room.branch_kind or N.room.branch_kind)
          then
            connect_land(L, N, dir, "normal")
            break;
          end
        end
      end

    end -- loop
  end

  local function add_teleporters()
    -- FIXME !!!!! DO TELEPORTERS WITH QUEST STUFF

    -- Makes sure any non-contiguous groups of rooms become connected
    -- (either by an actual bridge or by a teleporter).
    
    -- FIXME: MAKE PHYSIC BRIDGES EARLIER (only do teleporters here)  

    local rooms = copy_table(PLAN.all_rooms)

    local function do_teleport(R)
      -- find a room for the teleporter
      for _,N in ipairs(rooms) do
        if (N.group_id == 1) and (#N.teleports < 2) then
          local TELEP = { src=N, dest=R, is_teleport=true }

          TELEP.src_tag  = Plan_alloc_tag()
          TELEP.dest_tag = Plan_alloc_tag()

          table.insert(R.teleports, TELEP)
          table.insert(N.teleports, TELEP)

          merge(R.group_id, N.group_id)

          con.debugf("ADDED TELEPORT (%d,%d) --> (%d,%d)\n", N.lx1,N.ly1, R.lx1,R.ly1)
          return;
        end
      end

      error("do_teleport: no group#1 rooms!")
    end

    --| add_teleporters |--

    repeat
      local did_merge = false

      rand_shuffle(rooms)
      for _,R in ipairs(rooms) do
        if (R.group_id >= 2) and (#R.teleports < 2) then
          do_teleport(R)
          did_merge = true
          break;
        end
      end

    until not did_merge

    for _,R in ipairs(rooms) do
      if R.group_id ~= 1 then
        error("add_teleporters: unable to connect all rooms!")
      end
    end
  end


  ---| Rooms_Connect |---

  join_ground()

  branch_big_rooms()
--!!!!!  branch_the_rest()

  add_teleporters()
end


function Plan_determine_size(epi_along)
  local ob_size = OB_CONFIG.size

  -- there is no real "progression" when making a single level
  -- so used mixed mode instead.
  if ob_size == "prog" and OB_CONFIG.length == "single" then
    ob_size = "mixed"
  end

  if ob_size == "mixed" then
    LAND_W = 3 + rand_index_by_probs { 2,4,6,10,6,4,2,0,1 }
    LAND_H = 3 + rand_index_by_probs { 2,4,6,10,6,4,2 }

  else
    if ob_size == "prog" then
      LAND_W = int(5.5 + epi_along * 6)
    else
      local LAND_SIZES = { small=5, normal=7, large=10, xlarge=13 }

      LAND_W = LAND_SIZES[ob_size]

      if not LAND_W then
        error("Unknown size keyword: " .. tostring(ob_size))
      end
    end

    LAND_H = LAND_W

    while LAND_H > math.max(4, LAND_W/2) and rand_odds(50) do
      LAND_H = LAND_H - 1
    end

    if rand_odds(40) then LAND_W = LAND_W - 1 end
    if rand_odds(30) then LAND_H = LAND_H - 1 end

    if rand_odds(50) then -- LAND_W < LAND_H then
      LAND_W, LAND_H = LAND_H, LAND_W
    end
  end

  con.printf("Land size: %dx%d\n", LAND_W, LAND_H)
end


function Plan_rooms_sp(epi_along)

  con.printf("\n--==| Plan_rooms_sp |==--\n\n")

  PLAN =
  {
    all_rooms = {},
    all_conns = {},

    free_tag  = 1,
    free_mark = 1,
  }



  Plan_determine_size(epi_along)

  Landmap_Init()
  Landmap_Fill()
  Landmap_Dump()

  Landmap_CreateRooms()
  Landmap_AddBridges()

  Rooms_Nudge()
  Rooms_Make_Seeds()
  Rooms_Connect()


--!!!!!
for _,R in ipairs(PLAN.all_rooms) do
  if #R.conns > 1 and not R.branch_kind then
    R.hallway = true
  end
end

end -- Plan_rooms_sp

