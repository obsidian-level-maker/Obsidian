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


function Landmap_DoLiquid()
 
  if LW <= 2 or LH <= 2 then return end

  -- Possible liquid patterns:
  --   1. completely surrounded
  --   2. partially surrounded (U shape)
  --   3. river down the middle
  --   4. pool in the middle

  local extra = rand_irange(0,255)

  function surround_mode(x, y)
    if (x == 1) or (x == LW) or (y == 1) or (y == LH) then
      LAND_MAP[x][y].kind = "liquid"
    end
  end

  function ushape_mode(x, y)
    if (x == 1  and (extra % 4) == 0) or
       (x == LW and (extra % 4) == 1) or
       (y == 1  and (extra % 4) == 2) or
       (y == LH and (extra % 4) == 3)
    then
      return
    end
    surround_mode(x, y)
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
    none = 1,

    surround = 90,
    river    = 90,
    u_shape  = 90,
    pool     = 90,
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
        LAND_MAP[x][y].kind = rand_key_by_probs
        {
          valley = 30, ground = 80, hill = 50,
          cave   = 40
        }
      end
    end
  end

  local GROW_PROBS =
  {
    valley = 50, ground = 70, hill = 40, cave = 40
  }

  local function grow_spot(x, y, dir)

    local nx, ny = nudge_coord(x, y, dir)
    if nx < 1 or nx > LW or ny < 1 or ny > LH then return false end

    if not LAND_MAP[x][y].kind then return false end
    if LAND_MAP[nx][ny].kind   then return false end

    local prob = GROW_PROBS[LAND_MAP[x][y].kind]

    if not prob then return false end
    if not rand_odds(prob) then return false end

    LAND_MAP[nx][ny].kind = LAND_MAP[x][y].kind
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
          if grow_spot(x, y, d*2) then break; end
        end
      end
    end
  end


  --- Landmap_DoGround ---

  for loop = 1,2 do
    plant_seedlings()
    for grow_loop = 1,math.max(LW,LH)*2 do
      grow_seedlings()
    end
  end
end


function Landmap_DoIndoors()
end


function Landmap_Fill()

  local old_LW = LW
  local old_LH = LH

  local half_LW = int((LW+1)/2)
  local half_LH = int((LH+1)/2)

  if LW >= 5 and rand_odds(25) then

con.debugf("(mirroring horizontally LW=%d)\n", LW)
    LW = half_LW ; Landmap_Fill() ; LW = old_LW

    for x = half_LW+1, LW do
      for y = 1,LH do
        LAND_MAP[x][y] = copy_table(LAND_MAP[LW-x+1][y])
      end
    end

    return -- NO MORE

  elseif LH >= 5 and rand_odds(25) then

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


function Plan_rooms_sp()


  ---===| Plan_rooms_sp |===---

  con.printf("\n--==| Plan_rooms_sp |==--\n\n")


for i = 1,300 do
  Landmap_Init()
  Landmap_Fill()
  Landmap_Dump()
end
error("TEST OVER")


  Seed_init(LW*3, LH*3, 1, { zone_kind="solid"})
  
  Seed_dump_fabs()

end -- Plan_rooms_sp

