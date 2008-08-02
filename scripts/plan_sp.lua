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
}



--------------------------------------------------------------]]

require 'defs'
require 'util'


LW = 9
LH = 9
LAND_MAP = array_2D(LW, LH)


function Landmap_Init()
  for x = 1,LW do for y = 1,LH do
    LAND_MAP[x][y] = { lx=x, ly=y }
  end end
end


function Landmap_valid(x, y)
  return (x >= 1) and (x <= LW) and
         (y >= 1) and (y <= LH)
end


function Landmap_at_edge(x, y)
  return (x == 1) or (x == LW) or
         (y == 1) or (y == LH)
end


function Landmap_rand_visits()
  local visits = {}
  for x = 1,LW do for y = 1,LH do
    table.insert(visits, { x=x, y=y })
  end end -- x,y
  rand_shuffle(visits)
  return visits
end


function Landmap_DoLiquid()
 
  if LW <= 2 or LH <= 2 then return end

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
    if (x == 1  and (extra % 4) == 0) or
       (x == LW and (extra % 4) == 1) or
       (y == 1  and (extra % 4) == 2) or
       (y == LH and (extra % 4) == 3)
    then
      -- skip that side
    else
      surround_mode(x, y)
    end
  end

  function river_mode(x, y)
    if (extra % 2) == 0 then
      if x == int((LW+1)/2) then
        LAND_MAP[x][y].kind = "liquid"
      end
    else
      if y == int((LH+1)/2) then
        LAND_MAP[x][y].kind = "liquid"
      end
    end
  end

  function pool_mode(x, y)
    local pw = 1
    local ph = 1

    if LW >= 7 then pw = 2 end
    if LH >= 7 then ph = 2 end

    local dx = math.abs(x - int((LW+1)/2))
    local dy = math.abs(y - int((LH+1)/2))

    if dx < pw and dy < ph then
      LAND_MAP[x][y].kind = "liquid"
    end
  end


  --- Landmap_DoLiquid ---

  local what = rand_key_by_probs
  {
    none = 200,

    river    = 80,
    pool     = 40,
    u_shape  = 40,
    surround = 20,
  }

con.debugf("(what: %s)\n", what)
  for x = 1,LW do for y = 1,LH do
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

    FILLERS.none = 60  -- variable?

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
    for x = 1,LW do
      local poss_y = {}

      for y = 1,LH do
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
    valley = 40, ground = 50, hill = 30,
    cave = 70, building = 70,
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

    rand_shuffle(x_order, LW)
    for _,x in ipairs(x_order) do

      rand_shuffle(y_order, LH)
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

  for x = 1,LW do for y = 1,LH do
    local L = LAND_MAP[x][y]
    if not L.kind then
      L.kind = what
    end
  end end -- x,y
end


function Landmap_Fill()

  local old_LW = LW
  local old_LH = LH

  local half_LW = int((LW+1)/2)
  local half_LH = int((LH+1)/2)

  if LW >= 5 and rand_odds(12) then

con.debugf("(mirroring horizontally LW=%d)\n", LW)
    LW = half_LW ; Landmap_Fill() ; LW = old_LW

    local swap_cave = rand_odds(25)
    local swap_hill = rand_odds(25)

    for x = half_LW+1, LW do
      for y = 1,LH do
        local L = LAND_MAP[LW-x+1][y]
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

  elseif LH >= 5 and rand_odds(3) then

con.debugf("(mirroring vertically LH=%d)\n", LW)
    LH = half_LH ; Landmap_Fill() ; LH = old_LH

    for y = half_LH+1, LH do
      for x = 1,LW do
        LAND_MAP[x][y].kind = LAND_MAP[x][LH-y+1].kind
      end
    end

    return -- NO MORE
  end 
 
  Landmap_DoLiquid()
  Landmap_DoGround()
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
  for y = LH,1,-1 do
    local line = "  "
    for x = 1,LW do
      line = line .. land_char(LAND_MAP[x][y])
    end
    con.debugf("%s", line)
  end
  con.debugf("\n")
end


function Landmap_GroupRooms()
  
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

    for x = x1,x2 do for y = y1,y2 do
      if LAND_MAP[x][y].room then return false end
      if LAND_MAP[x][y].kind ~= kind then return false end
    end end -- x, y

    return true
  end

  local BIG_BUILDING_PROBS =
  {
    {  0.0, 20.0, 3.0 },
    { 20.0, 10.0, 1.5 },
    {  3.0,  1.5, 0.5 },
  }

  local function prob_for_big_room(kind, w, h)
    if kind == "building" or kind == "cave" then
      if w >= 4 or h >= 4 then return 0 end
      return BIG_BUILDING_PROBS[w][h] * 5
    else -- ground
      return 100 * (w * h) * (w * h)
    end
  end

  local function check_expansion(exps, kind, x,y, dx,dy)
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

          exps[INFO] = prob_for_big_room(kind, w, h)
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

    ROOM.sx1 = x1*3-2
    ROOM.sy1 = y1*3-2
    ROOM.sx2 = x2*3
    ROOM.sy2 = y2*3

    for x = x1,x2 do for y = y1,y2 do
      LAND_MAP[x][y].room = ROOM
    end end
  end

  local function create_room(L, x, y)
    local ROOM =
    {
      kind = L.kind,
      group_id = 1 + #PLAN.all_rooms,
      num_conn = 0,

      lx1 = x, ly1 = y,
      lx2 = x, ly2 = y,

      sx1 = x*3-2, sy1 = y*3-2,
      sx2 = x*3,   sy2 = y*3,
    }

    table.insert(PLAN.all_rooms, ROOM)

    local expansions = { none = 50 }
con.debugf("Check expansions:\n{\n")

    for dx = -1,1,2 do for dy = -1,1,2 do
      check_expansion(expansions, ROOM.kind, x, y, dx, dy)
    end end -- dx, dy
con.debugf("}\n")

    local what = rand_key_by_probs(expansions)

    if what == "none" then
      L.room = ROOM
    else
      expand_room(ROOM, what)
    end
  end

  local function room_char(L)
    if not L.room then return "." end
    local n = 1 + (L.room.group_id % 62)
    return string.sub("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", n, n)
  end

  local function dump_rooms()
    con.debugf("Room Map\n")
    for y = LH,1,-1 do
      local line = "  "
      for x = 1,LW do
        line = line .. room_char(LAND_MAP[x][y])
      end
      con.debugf("%s", line)
    end
    con.debugf("\n")
  end


  ---| Landmap_GroupRooms |---

  for _,V in ipairs(Landmap_rand_visits()) do
    local L = LAND_MAP[V.x][V.y]
    if L.kind and walkable(L) and not L.room then
      create_room(L, V.x, V.y) 
    end
  end

  dump_rooms()
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
  -- We also give priority to "bad corners", which have two indoor
  -- areas diagonally opposite, and two outdoor areas diagonally
  -- opposite (like a chess-board).

  local function try_nudge_room(R, side, grow)
    -- grow is >0 to nudge outward, <0 to nudge inward
    if not grow then grow = rand_sel(50,1,-1) end

    if R.no_nudge then return false end

    -- already moved this edge?
    if R.nudges[side] then return false end

    -- FIXME
    return false
  end

  local function nudge_big_rooms()
    local rooms = {}
    for _,R in ipairs(PLAN.all_rooms) do
      if R.l_area and R.l_area >= 2 then
        table.insert(rooms, R)
      end
    end

    if #rooms == 0 then return end

    table.sort(rooms, function(A, B) return A.l_area > B.l_area end)

    local sides = { 2,4,6,8 }

    for _,R in ipairs(rooms) do
      rand_shuffle(sides)
      for _,side in ipairs(sides) do
        if rand_odds(30) then
          try_nudge_room(R, side, rand_sel(75,1,-1))
        end
      end
    end
  end

  local function get_NE_corner(R)
    local x = R.sx2 + 1
    local y = R.sy2 + 1

    print(x,y)
    return Seed_valid(x, y, 1) and SEEDS[x][y][1].room
  end

  local function is_corner_bad(R, NE)
    -- FIXME
  end

  local function nudge_bad_corners()
    for _,R in ipairs(PLAN.all_rooms) do
      local NE = get_NE_corner(R)
      if NE and is_corner_bad(R, NE) then
        if rand_odds(50) then
          local a = try_nudge_room(R,  8) or try_nudge_room(R,  6) or
                    try_nudge_room(NE, 2) or try_nudge_room(NE, 4)
        else
          local a = try_nudge_room(R,  6) or try_nudge_room(R,  8) or
                    try_nudge_room(NE, 4) or try_nudge_room(NE, 2)
        end
      end
    end -- R in all_rooms
  end

  local function nudge_the_rest()
    local rooms = {}
    for _,R in ipairs(PLAN.all_rooms) do
      if not (R.l_area and R.l_area >= 2) then
        table.insert(rooms, R)
      end
    end

    local sides = { 2,4,6,8 }

    for pass = 1,2 do
      rand_shuffle(rooms)
      for _,R in ipairs(rooms) do
        rand_shuffle(sides)
        for _,side in ipairs(sides) do
          if rand_odds(20) then
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

  nudge_big_rooms()
  nudge_bad_corners()
  nudge_the_rest()
end


function Rooms_border_up(R)
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

      else
        S.borders[dir] = { kind="fence" }
      end
    end
  end end -- x, y
end


function Rooms_MakeSeeds()
  Seed_init(LW*3, LH*3, 1, { zone_kind="solid"})

  -- firstly handle non-room stuff (Lava)
  for lx = 1,LW do for ly = 1,LH do
    local L = LAND_MAP[lx][ly]
    if not L.room then
      for sx = lx*3-2,lx*3 do for sy = ly*3-2,ly*3 do
        local S = SEEDS[sx][sy][1]
        S.room = { kind = L.kind, nowalk=true }
        S.borders = {}
      end end
    end -- L.room
  end end

  for _,R in ipairs(PLAN.all_rooms) do
    for sx = R.sx1,R.sx2 do for sy = R.sy1,R.sy2 do
      local S = SEEDS[sx][sy][1]
      S.room = R
      S.borders = {}
    end end

    Rooms_border_up(R)
  end

  Seed_dump_fabs()
end


function Rooms_Connect()

  -- Guidelines:
  -- 1. prefer a "tight" bond between ground areas of same kind.
  -- 2. prefer not to connect ground areas of different kinds.
  -- 3. prefer ground areas not to be leafs
  -- 4. prefer big rooms to have 3 or more connections.
  -- 5. prefer small isolated rooms to be leafs (1 connection).

  local function merge(id1, id2)
    if id1 > id2 then id1,id2 = id2,id1 end

    for x = 1,LW do for y = 1,LH do
      local L = LAND_MAP[x][y]
      if L.room and L.room.group_id == id2 then
        L.room.group_id = id1
      end
    end end -- x,y
  end

---##  local function seed_for_land_side(L, side)
---##    -- FIXME: this will fuck up after Nudging!!!
---##    local x1,y1, x2,y2 = side_coords(side, L.lx*3-2,L.ly*3-2, L.lx*3,L.ly*3)
---##
---##    local sx = int((x1+x2) / 2)
---##    local sy = int((y1+y2) / 2)
---##
---##    assert(Seed_valid(sx, sy, 1))
---##
---##    return SEEDS[sx][sy][1]
---##  end

  local function connect_seeds(S, T, dir, c_kind)
    S.borders[dir]    = { kind="open" }
    T.borders[10-dir] = { kind="open" }

    merge(S.room.group_id, T.room.group_id)

    S.room.num_conn = S.room.num_conn + 1
    T.room.num_conn = T.room.num_conn + 1
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

  local BIG_NUM_BRANCH_PROBS =
  {
    { 0, 0, 50, 30,  2, 0  },  -- 2 for max(W,H)
    { 0, 0, 30, 50, 10, 1  },  -- 3
    { 0, 0,  5, 50, 30, 10 },  -- 4
  }

  local BIG_BRANCH_PATTERNS =
  {
    -- each triplet is: x, y, dir
    -- where x is 1 for left, 2 for middle, 3 for right side
    -- where y is 1 for bottom, 2 for middle, 3 for top side

    { {2,1,2},{1,3,4},{3,3,6} },  -- T shape
    { {2,1,2},{1,3,8},{3,3,8} },  -- U shape

    { {2,1,2},{1,2,4},{3,2,6},{2,3,8 } },  -- plus shape
    { {2,1,2},{1,3,4},{3,3,6},{2,3,8 } },
    { {1,1,2},{1,3,2},{1,3,4},{3,3,6 } },  -- H shape
    { {1,1,2},{1,3,6},{3,1,4},{3,3,8 } },  -- swastika

    { {2,1,2},{1,2,4},{3,2,6},{1,3,8},{3,3,8} },
    { {1,1,2},{3,1,2},{1,3,8},{2,3,8},{3,3,8} },
    { {1,1,4},{3,1,6},{1,3,8},{2,3,8},{3,3,8} },

    { {2,1,2},{2,3,8},{1,1,4},{1,3,4},{3,1,6},{3,3,6} },
    { {2,1,2},{1,2,4},{3,2,6},{1,3,8},{2,3,8},{3,3,8} },
  }

  local function morph_triplet(R, T, MORPH)
    local x = T[1]
    local y = T[2]
    local dir = T[3]

    if (MORPH % 2) >= 1 then
      x = 4-x
      if (dir == 4) or (dir == 6) then dir = 10-dir end
    end

    if (MORPH % 4) >= 2 then
      y = 4-y
      if (dir == 2) or (dir == 8) then dir = 10-dir end
    end

    if (MORPH % 8) >= 4 then
      x, y = y, 4-x
      dir = rotate_cw90(dir)
      if (MORPH == 5) or (MORPH == 6) then MORPH = 11-MORPH end
    end


    local rw = R.sx2 - R.sx1 + 1
    local rh = R.sy2 - R.sy1 + 1

    local sx, sy

    -- TODO: ability to use sx=R.sx1+1 (etc) sometimes.
    --       We shouldn't use random here, hence probably need to
    --       use extra MORPH bits (maybe two: for X and Y).

        if x == 1 then sx = R.sx1
    elseif x == 3 then sx = R.sx2
    else
      sx = R.sx1 + int((rw-1) / 2);
      if (MORPH % 2) >= 1 and (rw % 2) == 1 then sx = sx + 1 end
    end

        if y == 1 then sy = R.sy1
    elseif y == 3 then sy = R.sy2
    else
      sy = R.sy1 + int((rh-1) / 2);
      if (MORPH % 4) >= 2 and (rh % 2) == 1 then sy = sy + 1 end
    end

--- con.debugf("ROOM LAND POS: L(%d,%d) .. L(%d,%d) = %dx%d\n", R.lx1,R.ly1, R.lx2,R.ly2, R.lw,R.lh)
--- con.debugf("MORPH %d: {%d,%d,%d} --> x:%d,y:%d --> +%d,+%d dir:%d\n", MORPH, T[1],T[2],T[3], x,y, lx,ly, dir)

    assert(Seed_valid(sx, sy, 1))
    assert(SEEDS[sx][sy][1].room == R)

    return sx, sy, dir
  end

  local function try_big_pattern(R, PAT, MORPH)
    local groups_seen = {}

    groups_seen[R.group_id] = 1
con.debugf("TRYINH BIG PATTERN: %s\n", table_to_str(PAT[1]))

    -- see if the pattern can be used on this room
    -- (e.g. all exits go somewhere and are different groups)

    for _,T in ipairs(PAT) do
      local sx, sy, dir = morph_triplet(R, T, MORPH)
      local nx, ny = nudge_coord(sx, sy, dir)

      if not Seed_valid(nx, ny, 1) then return false end

      local S = SEEDS[sx][sy][1]
      local N = SEEDS[nx][ny][1]

      assert(S.room == R)
      if not N.room or not N.room.group_id then return false end

      if groups_seen[N.room.group_id] then return false end

      groups_seen[N.room.group_id] = 1
    end

con.debugf("USING BIG PATTERN: %s\n", table_to_str(PAT,2))

    -- OK, all points were possible, do it for real
    for _,T in ipairs(PAT) do
      local sx, sy, dir = morph_triplet(R, T, MORPH)
      local nx, ny = nudge_coord(sx, sy, dir)

      local S = SEEDS[sx][sy][1]
      local N = SEEDS[nx][ny][1]

      connect_seeds(S, N, dir, "normal")
    end

    return true
  end

  local function try_branch_big_room(R, num)
    -- we don't bother with patterns if room already has 1 or more connections
    if R.num_conn > 0 then return false end
con.debugf("Try branch big room L(%d,%d) : conns = %d\n", R.lx1,R.ly1, num)

    -- There are THREE morph steps, done in this order:
    -- 1. either flip the pattern horizontally or not
    -- 2. either flip the pattern vertically or not
    -- 3. either rotate the pattern clockwise or not
    local morphs = { 0,1,2,3, 4,5,6,7 }

    for _,PAT in ipairs(BIG_BRANCH_PATTERNS) do if #PAT == num then
      rand_shuffle(morphs)
      
      for _,MORPH in ipairs(morphs) do
        if try_big_pattern(R, PAT, MORPH) then
          return true -- SUCCESS
        end
      end
    end end -- PAT, size check

    return false
  end

  local function branch_big_rooms()
    local rooms = {}

    for _,R in ipairs(PLAN.all_rooms) do

      R.lw, R.lh = box_size(R.lx1, R.ly1, R.lx2, R.ly2)

      -- add some randomness to area to break deadlocks
      R.l_area = R.lw * R.lh + con.random() / 3.0

      if R.l_area >= 2 and (R.kind == "building" or R.kind == "cave") then
        table.insert(rooms, R)
      end
    end

    if #rooms == 0 then return end

    table.sort(rooms, function(A, B) return A.l_area > B.l_area end)

    for _,R in ipairs(rooms) do
      con.debugf("Branching BIG ROOM at L(%d,%d) area: %1.3f\n", R.lx1,R.ly1, R.l_area)

      local lw, lh = box_size(R.lx1, R.ly1, R.lx2, R.ly2)
      local ln = math.max(lw, lh)
      if ln > 4 then ln = 4 end
      assert(ln >= 2)

      local try1 = rand_index_by_probs(BIG_NUM_BRANCH_PROBS[ln])

      if not try_branch_big_room(R, try1) then
        local try2

        repeat
          try2 = rand_index_by_probs(BIG_NUM_BRANCH_PROBS[ln])
        until try2 ~= try1

        try_branch_big_room(R, try2)
      end
    end
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
          if N and L.room and N.room and L.room.group_id ~= N.room.group_id then
            connect_land(L, N, dir, "normal")
            break;
          end
        end
      end

    end -- loop
  end

  local function add_bridges()
    -- Makes sure any non-contiguous groups of rooms become connected
    -- (either by an actual bridge or by a teleporter).
    
    -- FIXME !!!!
  end


  ---| Rooms_Connect |---

  join_ground()

  branch_big_rooms()
  branch_the_rest()

  add_bridges()
end


function Plan_rooms_sp()


  ---===| Plan_rooms_sp |===---

  con.printf("\n--==| Plan_rooms_sp |==--\n\n")

  PLAN =
  {
    all_rooms = {},
  }


for i = 1,1 do
  Landmap_Init()
  Landmap_Fill()
  Landmap_Dump()
end
-- error("TEST OVER")

  Landmap_GroupRooms()

  Rooms_Nudge()

  Rooms_MakeSeeds()

  Rooms_Connect()

end -- Plan_rooms_sp

