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
    LAND_MAP[x][y] = { }
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
    cave = 70, building = 70, liquid = 2
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

  local BIG_BUILDING_PROBS = { 30, 5, 0.4, 0.01, 0, 0, 0, 0 }

  local function prob_for_big_room(kind, w, h)
    if kind == "building" or kind == "cave" then
      local n = w + h - 2
      assert(n >= 1 and n <= 8)
      return BIG_BUILDING_PROBS[n]
    else -- ground
      return 100 * (w * h)
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

    ROOM.sx1 = x1
    ROOM.sy1 = y1
    ROOM.sx2 = x2
    ROOM.sy2 = y2

    for x = x1,x2 do for y = y1,y2 do
      LAND_MAP[x][y].room = ROOM
    end end
  end

  local function create_room(L, x, y)
    local ROOM =
    {
      kind = L.kind,
      ident = 1 + #PLAN.all_rooms,

      sx1 = x, sy1 = y,
      sx2 = x, sy2 = y,
    }

    table.insert(PLAN.all_rooms, ROOM)

    local expansions = { none=50 }
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
    local n = 1 + (L.room.ident % 62)
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

  for pass = 1,3 do for x = 1,LW do for y = 1,LH do
    local L = LAND_MAP[x][y]
    if L.kind and walkable(L) and not L.room and
       (pass == 3 or rand_odds(22))
    then
      create_room(L, x, y) 
    end
  end end end -- pass, x, y

  dump_rooms()
end


function Plan_rooms_sp()


  ---===| Plan_rooms_sp |===---

  con.printf("\n--==| Plan_rooms_sp |==--\n\n")

  PLAN =
  {
    all_rooms = {},
  }


for i = 1,20 do
  Landmap_Init()
  Landmap_Fill()
  Landmap_Dump()
  Landmap_GroupRooms()
end
   error("TEST OVER")



  Seed_init(LW*3, LH*3, 1, { zone_kind="solid"})

  for lx = 1,LW do for ly = 1,LH do
    local L = LAND_MAP[lx][ly]
    for sx = lx*3-2,lx*3 do for sy = ly*3-2,ly*3 do
      local S = SEEDS[sx][sy][1]
      S.room = { kind = L.kind }
    end end
  end end
  
  Seed_dump_fabs()

end -- Plan_rooms_sp

