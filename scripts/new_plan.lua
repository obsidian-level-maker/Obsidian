---------------------------------------------------------------
--  PLANNING (NEW!) : Single Player
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
    return string.format("ROOM[%s %d,%d..%d,%d]",
        self.kind, self.sx1,self.sy1, self.sx2,self.sy2)
  end,

  contains_seed = function(self, x, y)
    if x < self.sx1 or x > self.sx2 then return false end
    if y < self.sy1 or y > self.sy2 then return false end
    return true
  end,

  valid_T = function(self, x, y)
    if x < self.tx1 or x > self.tx2 then return false end
    if y < self.ty1 or y > self.ty2 then return false end
    return true
  end,
}


function Plan_CreateRooms()
  
  -- creates rooms out of contiguous areas on the land-map

  local room_map = array_2D(PLAN.W, PLAN.H)


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


  local function room_char(R)
    if not R then return '.' end
    if R.is_scenic then return '/' end
--  if (R.lw == 1 or R.lh == 1) then return '%' end
    local n = 1 + (R.group_id % 62)
    return string.sub("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", n, n)
  end

  local function dump_rooms()
    gui.debugf("Room Map\n")
    for y = PLAN.H,1,-1 do
      local line = "  "
      for x = 1,PLAN.W do
        line = line .. room_char(room_map[x][y])
      end
      gui.debugf("%s", line)
    end
    gui.debugf("\n")
  end

  local function try_expand_room(x, y, bw, bh, R)
    
    -- fits?
    if x+bw-1 > PLAN.W or y+bh-1 > PLAN.H then
      return false
    end

    -- never use whole width/height of map
    if bw >= PLAN.W or bh >= PLAN.H then
      return false
    end

    for dx = 0,bw-1 do for dy = 0,bh-1 do
      if (dx > 0 or dy > 0) and room_map[x+dx][y+dy] then
        return false
      end
    end end

    -- actually expand the room
    R.lw = bw
    R.lh = bh

    for dx = 0,bw-1 do for dy = 0,bh-1 do
      room_map[x+dx][y+dy] = R
    end end

    return true
  end


  ---| Plan_CreateRooms |---

  local BIG_ROOMS =
  {
    [11] = 35,
    [12] = 50, [22] = 90,
    [23] = 15, [33] = 15
  }

  local visits = {}

  for x = 1,PLAN.W do for y = 1,PLAN.H do
    table.insert(visits, { x=x, y=y })
  end end

  rand_shuffle(visits)

  for group_id,vis in ipairs(visits) do
    local x, y = vis.x, vis.y
    
    if not room_map[x][y] then

      local ROOM = { lw=1, lh=1, group_id=group_id }

---##      -- give top/left room and bottom/right room a 'corner' field to
---##      -- prevent rooms in a small map from glomming into one big room.
---##      if (x == 1 and y == 1) or (x == PLAN.W and y == PLAN.H) then
---##        ROOM.corner = true
---##      end

      room_map[x][y] = ROOM

      local big = rand_key_by_probs(BIG_ROOMS)

      local big_w = int(big / 10)
      local big_h = big % 10

      if big_w > 1 or big_h > 1 then
        if rand_odds(50) then big_w, big_h = big_h, big_w end
        
        -- prefer to put big rooms away from the edge
        if (big_w >= 2 and big_h >= 2) and
           (x == 1 or y == 1 or x == PLAN.W-big_w+1 or y == PLAN.H-big_h+1) and
           rand_odds(80)
        then
          -- forget it
        else
          try_expand_room(x, y, big_w, big_h, ROOM)
        end
      end
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


function Plan_CollectNeighbors()
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


function Plan_Nudge()
  
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

    -- side sits on border of the map?
    if (side == 2 and R.ly1 == 1) or
       (side == 4 and R.lx1 == 1) or
       (side == 6 and R.lx2 == LAND_W) or
       (side == 8 and R.ly2 == LAND_H)
    then
      return false
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


  ---| Plan_Nudge |---

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



function Plan_MakeSeeds()

  local function plant_rooms()
    for _,R in ipairs(PLAN.all_rooms) do
      for sx = R.sx1,R.sx2 do for sy = R.sy1,R.sy2 do
        assert(Seed_valid(sx, sy, 1))
        local S = SEEDS[sx][sy][1]
        assert(not S.room) -- no overlaps please!
        S.room = R
      end end -- for sx,sy
    end -- for R

    for _,R in ipairs(PLAN.scenic_rooms) do
      for sx = R.sx1,R.sx2 do for sy = R.sy1,R.sy2 do
        local S = SEEDS[sx][sy][1]
        if not S.room then -- overlap is OK for scenics
          S.room = R
        end
      end end -- for sx,sy
    end -- for R
  end

  local function fill_holes()
    local sc_list = shallow_copy(PLAN.scenic_rooms)
    rand_shuffle(sc_list)

    for _,R in ipairs(sc_list) do
      local nx1,ny1 = R.sx1,R.sy1
      local nx2,ny2 = R.sx2,R.sy2

      for x = R.sx1-1, R.sx2+1 do for y = R.sy1-1, R.sy2+1 do
        if Seed_valid(x, y, 1) and not R:contains_seed(x, y) then
          local S = SEEDS[x][y][1]
          if not S.room then
            S.room = R
            if x < R.sx1 then nx1 = x end
            if y < R.sy1 then ny1 = y end
            if x > R.sx2 then nx2 = x end
            if y > R.sy2 then ny2 = y end
          end
        end
      end end -- for x,y

      R.sx1, R.sy1 = nx1, ny1
      R.sx2, R.sy2 = nx2, ny2

      R.sw, R.sh = box_size(R.sx1, R.sy1, R.sx2, R.sy2)
    end -- for R
  end

  local function border_up(R)
    for x = R.sx1, R.sx2 do for y = R.sy1, R.sy2 do
      local S = SEEDS[x][y][1]
      assert(S.room == R)
      for dir = 2,8,2 do
        local N = S:neighbor(dir)

        if not N then  -- edge of map
          if S.room.outdoor then
            S.border[dir].kind = "skyfence"
            S.thick[dir] = 48
          else
            S.border[dir].kind = "wall"
            S.border[dir].can_fake_sky = true
            S.thick[dir] = 24
          end

        elseif N.room == R then
          -- same room : do nothing
         
        elseif R.outdoor then
          S.border[dir].kind = "fence"

        else
          -- Note: windows (etc) are decided later
          S.border[dir].kind = "wall"
          S.thick[dir] = 24
        end
      end
    end end -- for x, y
  end

  local function border_up_scenic(R)
    for x = R.sx1, R.sx2 do for y = R.sy1, R.sy2 do
      local S = SEEDS[x][y][1]
      if S.room ~= R then
        -- skip different room
      else
        for dir = 2,8,2 do
          local N = S:neighbor(dir)
          if not N then
            if S.room.outdoor then
              S.border[dir].kind = "skyfence"
              S.thick[dir] = 48
            else
              S.border[dir].kind = "wall"
              S.thick[dir] = 24
            end
          end
        end -- for dir
      end
    end end -- for x, y
  end


  ---| Plan_MakeSeeds |---

  Seed_init(LAND_W*3, LAND_H*3, 1)

  plant_rooms()
  fill_holes()

  for _,R in ipairs(PLAN.all_rooms) do
    border_up(R)

    -- FIXME: should not be needed: maintain sw/sh along with sx1 etc
    R.sw, R.sh = box_size(R.sx1, R.sy1, R.sx2, R.sy2)

    R.svolume  = R.sw * R.sh
  end

  for _,R in ipairs(PLAN.scenic_rooms) do
    border_up_scenic(R)

    R.sw, R.sh = box_size(R.sx1, R.sy1, R.sx2, R.sy2)
  end

  Seed_dump_fabs()
end


function Plan_determine_size()
  local W, H

  local ob_size = OB_CONFIG.size

  -- there is no real "progression" when making a single level
  -- hence use mixed mode instead.
  if ob_size == "prog" and OB_CONFIG.length == "single" then
    ob_size = "mixed"
  end

  if ob_size == "mixed" then
    W = 3 + rand_index_by_probs { 2,4,6,10,6,4,2,1 }
    H = 3 + rand_index_by_probs { 2,4,6,10,6,4,2 }

    if W < H then W, H = H, W end
  else
    if ob_size == "prog" then
      local n = 1 + int(LEVEL.ep_along * 8.9)
      if n > 9 then n = 9 end

      local SIZES = { 5,6,6, 7,7,7, 8,9,10 }

      W = SIZES[n]
    else
      local SIZES = { small=6, normal=8, large=11 }

      W = SIZES[ob_size]

      if not W then
        error("Unknown size keyword: " .. tostring(ob_size))
      end
    end

    H = W

    if rand_odds(40) then W = W - 1 end

    if rand_odds(60) then H = H - 1 end
    if rand_odds(60) then H = H - 1 end
  end

  PLAN.W = W
  PLAN.H = H

  gui.printf("Land size: %dx%d\n", PLAN.W, PLAN.H)


  -- initial sizes of rooms in each row and column
  local cols = {}
  local rows = {}

  for x = 1, W do cols[x] = 3 end
  for y = 1, H do rows[y] = 3 end

  for i = 1,rand_irange(2,4) do
    local x = rand_irange(1, W)
    local y = rand_irange(1, H)

    cols[x] = cols[x] + 1
    rows[y] = rows[y] + 1
  end

  for i = 1,rand_irange(0,2) do
    local x = rand_irange(1, W)
    local y = rand_irange(1, H)

    if cols[x] >= 3 then cols[x] = cols[x] - 1 end
    if rows[y] >= 3 then rows[y] = rows[y] - 1 end
  end

  PLAN.col_W = cols
  PLAN.row_H = rows
end


function Plan_rooms_sp()

  gui.printf("\n--==| Plan_rooms_sp |==--\n\n")

  assert(LEVEL.ep_along)

  -- create the global 'PLAN' object
  PLAN =
  {
    all_rooms = {},
    all_conns = {},

    scenic_rooms = {},
    scenic_conns = {},

    free_tag  = 1,
    free_mark = 1,
  }

  set_class(PLAN, PLAN_CLASS)


  Plan_determine_size()

  PLAN.skyfence_h = rand_sel(50, 192, rand_sel(50, 64, 320))


  Plan_CreateRooms()

  Plan_CollectNeighbors()
  Plan_Nudge()

  -- must create the seeds _AFTER_ nudging
  Plan_MakeSeeds()

end -- Plan_rooms_sp

