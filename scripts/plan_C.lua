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


LW = 7
LH = 7
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
      none = 70, valley = 20, ground = 70, hill = 70,
    }

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
    valley = 30, ground = 50, hill = 40,
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

  local SPURTS = 4   -- 0 to 12

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
        local L = copy_table(LAND_MAP[LW-x+1][y])
        LAND_MAP[x][y] = L

        if swap_cave then
          if L.kind == "building" then L.kind = "cave"
          elseif L.kind == "cave" then L.kind = "building"
          end
        end

        if swap_hill then
          if L.kind == "ground"   then L.kind = "hill"
          elseif L.kind == "hill" then L.kind = "ground"
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
        LAND_MAP[x][y] = copy_table(LAND_MAP[x][LH-y+1])
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
  
  -- creates rooms out of contiguous areas.

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
      return BIG_BUILDING_PROBS[w][h]
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

con.debugf("Big room kind:%s at (%d,%d) .. (%d,%d)\n", ROOM.kind, x1,y1, x2,y2)

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

  local visits = Landmap_rand_visits()

  for _,V in ipairs(visits) do
con.printf("VISIT (%d,%d)\n", V.x, V.y)
    local L = LAND_MAP[V.x][V.y]
    if L.kind and walkable(L) and not L.room then
      create_room(L, V.x, V.y) 
    end
  end

  dump_rooms()
end


function Rooms_border_up(R)
  for x = R.sx1, R.sx2 do for y = R.sy1, R.sy2 do
    local S = SEEDS[x][y][1]
    S.borders = {}
    for dir = 2,8,2 do
      local nx, ny = nudge_coord(x, y, dir)
      if not Seed_valid(nx, ny, 1) then
        S.borders[dir] = { kind="solid" }
      elseif R.kind == "building" or R.kind == "cave" then
        if x == R.sx1 then S.borders[4] = { kind="solid" } end
        if x == R.sx2 then S.borders[6] = { kind="solid" } end
        if y == R.sy1 then S.borders[2] = { kind="solid" } end
        if y == R.sy2 then S.borders[8] = { kind="solid" } end
      end
    end
  end end -- x, y
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

  local function seed_for_land_side(L, side)
    -- FIXME: this will fuck up after Nudging!!!
    local x1,y1, x2,y2 = side_coords(side, L.lx*3-2,L.ly*3-2, L.lx*3,L.ly*3)

    local sx = int((x1+x2) / 2)
    local sy = int((y1+y2) / 2)

    assert(Seed_valid(sx, sy, 1))

    return SEEDS[sx][sy][1]
  end

  local function connect(L, N, dir, c_kind)
    
    local S = seed_for_land_side(L, dir)
    local T = seed_for_land_side(N, 10-dir)

--  print("S", S.sx,S.sy)
--  print("T", T.sx,T.sy)
    assert(T.sx == S.sx or T.sy == S.sy)

    S.borders[dir]    = { kind="open" }
    T.borders[10-dir] = { kind="open" }

    merge(L.room.group_id, N.room.group_id)
  end

  local function is_ground(L)
    return (L.kind == "valley") or (L.kind == "ground") or
           (L.kind == "hill")
  end

  local function bind_ground()
    local visits = Landmap_rand_visits()
    for _,V in ipairs(visits) do
      local L = LAND_MAP[V.x][V.y]
      if is_ground(L) then
        for dir = 2,8,2 do
          local nx, ny = nudge_coord(V.x, V.y, dir)
          local N = Landmap_valid(nx,ny) and LAND_MAP[nx][ny]
          if N and N.kind == L.kind and N.room.group_id ~= L.room.group_id then
            connect(L, N, dir, "tight")
          end
        end -- for dir
      end
    end -- for V in visits
  end

  local function branch_big_rooms()
    
  end

  local function branch_the_rest()
    for loop = 1,4 do  -- FIXME: HACK

    local visits = Landmap_rand_visits()
    local dirs = { 2,4,6,8 }
    for _,V in ipairs(visits) do
      local L = LAND_MAP[V.x][V.y]
      rand_shuffle(dirs)
      for _,dir in ipairs(dirs) do
        local nx, ny = nudge_coord(V.x, V.y, dir)
        local N = Landmap_valid(nx,ny) and LAND_MAP[nx][ny]
        if N and L.room and N.room and L.room.group_id ~= N.room.group_id then
          connect(L, N, dir, "normal")
          break;
        end
      end
    end

    end -- loop
  end

  local function add_bridges()
    
  end


  ---| Rooms_Connect |---

  bind_ground()

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
  Landmap_GroupRooms()
end
-- error("TEST OVER")


  -- NUDGE PASS!


  Seed_init(LW*3, LH*3, 1, { zone_kind="solid"})

  for lx = 1,LW do for ly = 1,LH do
    local L = LAND_MAP[lx][ly]
    for sx = lx*3-2,lx*3 do for sy = ly*3-2,ly*3 do
      local S = SEEDS[sx][sy][1]
      S.room = L.room or { kind = L.kind, nowalk=true }
      S.borders = {}
    end end
  end end

  for _,R in ipairs(PLAN.all_rooms) do
    Rooms_border_up(R)
  end

  Seed_dump_fabs()


  Rooms_Connect()


end -- Plan_rooms_sp

