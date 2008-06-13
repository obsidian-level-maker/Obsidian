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
  --   4. cross shape
  --   5. H shape
  --   6. S shape
  --   7. blob in the middle
  --   8. checkerboard

  local extra = rand_irange(0,255)

  function surround_mode(x, y)
    if (x == 1) or (x == LW) or (y == 1) or (y == LH) then
      LAND_MAP[x][y].kind = "liquid"
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

  local what = rand_key_by_probs
  {
    none = 9,

    surround = 90,
    river    = 90,
    u_shape  = 9,
    l_shape  = 2,
    s_shape  = 2,
    pool     = 5,
  }

  if what == "none" then
    return
  end

con.debugf("(what: %s)\n", what)
  for x = 1,LW do for y = 1,LH do
    if what == "surround" then surround_mode(x, y) end
    if what == "river"    then river_mode(x, y) end
  end end
end


function Landmap_DoGround()
end


function Landmap_DoIndoors()
end


function Landmap_Fill()

  local old_LW = LW
  local old_LH = LH

  local half_LW = int((LW+1)/2)
  local half_LH = int((LH+1)/2)

  if LW >= 4 and rand_odds(30) then

con.debugf("(mirroring horizontally LW=%d)\n", LW)
    LW = half_LW ; Landmap_Fill() ; LW = old_LW

    for x = half_LW+1, LW do
      for y = 1,LH do
        LAND_MAP[x][y] = copy_table(LAND_MAP[LW-x+1][y])
      end
    end

    return -- NO MORE

  elseif LH >= 4 and rand_odds(30) then

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

