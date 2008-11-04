---------------------------------------------------------------
--  PLANNING : Single Player
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
  all_rooms  : array(ROOM) 
  all_conns  : array(CONN)
  all_arenas : array(ARENA)
  all_locks  : array(LOCK)

  free_tag  : number
  free_mark : number
  
  skyfence_h  -- height of fence at edge of map

  ....
}

--------------------------------------------------------------]]

require 'defs'
require 'util'


LAND_W = 0
LAND_H = 0
LAND_MAP = {}


PLAN_CLASS =
{
  alloc_tag = function(self)
    local result = self.free_tag
    self.free_tag = self.free_tag + 1
    return result
  end,
  
  alloc_mark = function(self)
    local result = self.free_mark
    self.free_mark = self.free_mark + 1
    return result
  end,
}


ROOM_CLASS =
{
  tostr = function(self)
    if self.floor_h then
      return string.format("ROOM[%d,%d %s h:%s]", self.sx1,self.sy1, self.kind, self.floor_h)
    else
      return string.format("ROOM[%d,%d %s]", self.sx1,self.sy1, self.kind)
    end
  end,

  contains_seed = function(self, x, y)
    if x < self.sx1 or x > self.sx2 then return false end
    if y < self.sy1 or y > self.sy2 then return false end
    return true
  end,
}


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


function Landmap_DoLiquid(mirrored)
 
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

  if LAND_W <= 3 or LAND_H <= 3 or mirrored then
    what = "none"
  end

  if what == "u_shape" or what == "surround" then
    LAND_W = LAND_W + 2
    LAND_H = LAND_H + 2
  end

  if not mirrored then
    Landmap_Init()
  end

gui.debugf("Landmap_DoLiquid: what=%s\n", what)

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
      ground = 50, valley = 70, hill = 35,
    }

    FILLERS.none = 60*5  -- variable?  --!!!!!!!!

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
    valley = 30, ground = 40, hill = 20,
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

  local SPURTS = rand_element { 0,2,5,12 }

  if SPURTS > 0 then
    plant_seedlings()
    for loop = 1,SPURTS do
      grow_seedlings()
    end
  end
end


function Landmap_DoIndoors()
  for x = 1,LAND_W do for y = 1,LAND_H do
    local L = LAND_MAP[x][y]
    if not L.kind then
      L.kind = "indoor"
    end
  end end -- x,y
end


function Landmap_Fill(mirrored)

  local old_LW = LAND_W
  local old_LH = LAND_H

  local half_LW = int((LAND_W+1)/2)
  local half_LH = int((LAND_H+1)/2)

  if not mirrored and LAND_W >= 4 and rand_odds(15) then
gui.debugf("(mirroring horizontally LAND_W=%d)\n", LAND_W)

    Landmap_Init(LAND_W, LAND_H)

    LAND_W = half_LW ; Landmap_Fill(true) ; LAND_W = old_LW

    local swappers = {}

    if rand_odds(25) then
      swappers = { ground="valley", valley="hill", hill="ground" }
    elseif rand_odds(25) then
      swappers = { ground="hill", valley="ground", hill="valley" }
    end

    for x = half_LW+1, LAND_W do
      for y = 1,LAND_H do
        local L = LAND_MAP[LAND_W-x+1][y]
        local N = LAND_MAP[x][y]

        N.kind = swappers[L.kind] or L.kind
      end
    end

    return -- ALL DONE
  end 
 
  Landmap_DoLiquid(mirrored)
  Landmap_DoGround()
  Landmap_DoIndoors()
end


function Landmap_Dump()

  local CHARS =
  {
    valley = "1",
    ground = "2",
    hill   = "3",

    indoor   = "r",
    liquid   = "~",
    void     = "#",
  }

  local function land_char(L)
    return (L.kind and CHARS[L.kind]) or "."
  end

  gui.debugf("Land Map\n")
  for y = LAND_H,1,-1 do
    local line = "  "
    for x = 1,LAND_W do
      line = line .. land_char(LAND_MAP[x][y])
    end
    gui.debugf("%s", line)
  end
  gui.debugf("\n")
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
    { 70, 70,  6 },
    { 15,  6,  3 },
  }

  local function prob_for_big_room(kind, w, h)
    if kind == "indoor" then
      if w >= 4 or h >= 4 then return 0 end
      return BIG_BUILDING_PROBS[w][h]
    else -- outdoor
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
  gui.debugf("  (%d,%d) w:%d h:%d dx:%d dy:%d\n", x, y, w, h, dx, dy)
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

    set_class(ROOM, ROOM_CLASS)

    if ROOM.kind ~= "indoor" then
      ROOM.outdoor = true
    end

    table.insert(PLAN.all_rooms, ROOM)

    local e_infos = { "none" }
    local e_probs = { BIG_BUILDING_PROBS[1][1] }
gui.debugf("Check expansions:\n{\n")

    for dx = -1,1,2 do for dy = -1,1,2 do
      check_expansion(e_infos, e_probs, ROOM.kind, x, y, dx, dy)
    end end -- dx, dy
gui.debugf("}\n")

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
    gui.debugf("Room Map\n")
    for y = LAND_H,1,-1 do
      local line = "  "
      for x = 1,LAND_W do
        line = line .. room_char(LAND_MAP[x][y])
      end
      gui.debugf("%s", line)
    end
    gui.debugf("\n")
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


function Rooms_CollectNeighbors()
  -- Determines neighboring rooms of each room.
  -- Big rooms can have multiple neighbors on some sides.
  
  for _,R in ipairs(PLAN.all_rooms) do
    R.neighbors = { }
  end

  local function add_neighbor(R, side, N)
    -- check if already there
    for _,O in ipairs(R.neighbors) do
      if O == N then return end
    end

    table.insert(R.neighbors, N)
  end

  for lx = 1,LAND_W do for ly = 1,LAND_H do
    local L = LAND_MAP[lx][ly]
    for side = 1,9 do if side ~= 5 then
      local nx, ny = nudge_coord(lx, ly, side)
      if Landmap_valid(nx, ny) then
        local N = LAND_MAP[nx][ny]

        if L.room and N.room and L.room ~= N.room then
          add_neighbor(L.room, side, N.room)
        end
      end
    end end -- side 1-9 except 5
  end end -- lx, ly
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

  local function volume_after_nudge(R, side, grow)
    if (side == 6 or side == 4) then
      return (R.sw + grow) * R.sh
    else
      return R.sw * (R.sh + grow)
    end
  end

  local function allow_nudge(R, side, grow, N, list)

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

    if (side == 6 or side == 4) then
      if (N.sy1 < R.sy1) or (N.sy2 > R.sy2) then return false end
    else
      if (N.sx1 < R.sx1) or (N.sx2 > R.sx2) then return false end
    end

    -- the nudge is possible (pushing the neighbor also)

    if N.no_nudge or N.nudges[10-side] then return false end

    if volume_after_nudge(N, 10-side, -grow) < 3 then return false end

--???    if side == 6 then assert(N.sx1 == R.sx2+1) end
--???    if side == 4 then assert(N.sx2 == R.sx1-1) end
--???    if side == 8 then assert(N.sy1 == R.sy2+1) end
--???    if side == 2 then assert(N.sy2 == R.sy1-1) end

    table.insert(list, { room=N, side=10-side, grow=-grow })

    return true
  end

  local function try_nudge_room(R, side, grow)
    -- 'grow' is positive to nudge outward, negative to nudge inward

    -- Note: any shrinkage must pull neighbors too

    if not grow then
      grow = rand_sel(75,1,-1)
    end

gui.debugf("Trying to nudge room %dx%d, side:%d grow:%d\n", R.sw, R.sh, side, grow)

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
      -- if grow > 0 then  -- TODO: probably too simple
        return false
      -- end
    end

    local push_list = {}

    for _,K in ipairs(R.neighbors) do
      if not allow_nudge(R, side, grow, K, push_list) then return false end
    end

    -- Nudge is OK!
    gui.printf("Nudging Room (%d,%d) side:%d grow:%d\n", R.lx1, R.ly1, side, grow)

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
          if not (rand_odds(30) and try_nudge_room(R, side, 1)) then
            try_nudge_room(R, side, -1)
          end
        end
      end
      R.no_nudge = true
    end
  end

  local function get_NE_corner_rooms(R)

    local E, N, NE -- East, North, NorthEast

    for _,K in ipairs(R.neighbors) do

      if K.sx2 == R.sx2 and K.sy1 > R.sy2 then N = K end
      if K.sy2 == R.sy2 and K.sx1 > R.sx2 then E = K end

      if K.sx1 > R.sx2 and K.sy1 > R.sy2 then NE = K end
    end

    return E, N, NE
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
      gui.printf("Nasty Corner @ (%d,%d) : %s %s | %s %s\n",
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
          success = try_nudge_room(R, 8) or try_nudge_room(R, 6) or
                    try_nudge_room(E, 8) or try_nudge_room(N, 6)
        else
          success = try_nudge_room(R, 6) or try_nudge_room(R, 8) or
                    try_nudge_room(N, 6) or try_nudge_room(E, 8)
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

  for _,R in ipairs(PLAN.all_rooms) do
    R.nudges = {}
  end

  nudge_nasty_corners()
  nudge_big_rooms()
  nudge_the_rest()

  for _,R in ipairs(PLAN.all_rooms) do
    gui.printf("Room (%d,%d)  seed size: %dx%d\n", R.lx1,R.ly1, R.sw,R.sh)
  end
end



function Rooms_MakeSeeds()

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
      for x = 1,SEED_W do for y = 1,SEED_H do

        local S = SEEDS[x][y][1]
        if not S.room then
          for dir = 2,8,2 do
            local nx, ny = nudge_coord(x, y, dir)
            local N = Seed_valid(nx, ny, 1) and SEEDS[nx][ny][1]

            -- the 'fill_loop' check prevents run-away filling

            if N and N.room and N.room.nowalk -- FIXME: UGH!!!
               and not (N.fill_loop and N.fill_loop == loop)
            then
              S.room = N.room
              S.fill_loop = loop
            end
          end -- dir
        end

      end end -- x, y
    end
  end

  local function Border_Up(R)
    for x = R.sx1, R.sx2 do for y = R.sy1, R.sy2 do
      local S = SEEDS[x][y][1]
      for dir = 2,8,2 do
        local nx, ny = nudge_coord(x, y, dir)
        local N
        if Seed_valid(nx, ny, 1) then
          N = SEEDS[nx][ny][1]
          assert(N)
        end

        if not N then
          if S.room and not S.room.outdoor then
            S.borders[dir] = { kind="solid" }
          else
            S.borders[dir] = { kind="skyfence" }
            S.thick[dir] = 48
          end

        elseif N.room == R then
          -- same room, do nothing
          
        elseif R.kind == "indoor" then
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

  Seed_init(LAND_W*3, LAND_H*3, 1)

  Plant_Rooms()
  Flow_Liquid()
  Fill_Holes()

  for _,R in ipairs(PLAN.all_rooms) do
    Border_Up(R)

    R.sw, R.sh = box_size(R.sx1, R.sy1, R.sx2, R.sy2)
    R.svolume  = R.sw * R.sh
  end

  Seed_dump_fabs()
end


function Plan_determine_size()
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
      LAND_W = int(5.5 + LEVEL.ep_along * 6)
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

    if rand_odds(33) then LAND_W = LAND_W - 1 end
    if rand_odds(20) then LAND_H = LAND_H - 1 end

    if rand_odds(50) then -- LAND_W < LAND_H then
      LAND_W, LAND_H = LAND_H, LAND_W
    end
  end

  gui.printf("Land size: %dx%d\n", LAND_W, LAND_H)
end


function Plan_rooms_sp()

  gui.printf("\n--==| Plan_rooms_sp |==--\n\n")

  assert(LEVEL.ep_along)

  -- create the global 'PLAN' object
  PLAN =
  {
    all_rooms = {},
    all_conns = {},

    free_tag  = 1,
    free_mark = 1,
  }

  set_class(PLAN, PLAN_CLASS)


  Plan_determine_size()

  Landmap_Fill()
  Landmap_Dump()
  Landmap_CreateRooms()

  Rooms_CollectNeighbors()
  Rooms_Nudge()
  Rooms_MakeSeeds()

  PLAN.skyfence_h = rand_sel(50, 192, rand_sel(50, 64, 320))

end -- Plan_rooms_sp

