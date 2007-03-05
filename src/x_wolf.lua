----------------------------------------------------------------
-- THEMES : Wolfenstein 3D
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006,2007 Andrew Apted
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


--[[
	switch (mat)
	{
		// Land
		case MAT_Grass:  return 18;
		case MAT_Sand:   return 53;
		case MAT_Rock:   return 0;
		case MAT_Stone:  return 7;

		// Water
		case MAT_Water:  return 4;
		case MAT_Lava:   return 2;
		case MAT_Nukage: return 47;
		case MAT_Slime:  return 47;
		case MAT_Blood:  return 30;

		// Building
		case MAT_Lead:   return 51;
		case MAT_Alum:   return 14;
		case MAT_Tech:   return 41;
		case MAT_Light:  return 15;
		case MAT_Wood:   return 11;
		case MAT_Brick:  return 16;
		case MAT_Marble: return 49;

		// Cave
		case MAT_Ash:    return 50;

		default:
			return 48;  // ILLEGAL
--]]


----------------------------------------------------------------

THEME_FACTORIES["wolf3d"] = function()

  local T = THEME_FACTORIES.doom2()  -- TEMP HACK

  return T
end


----------------------------------------------------------------

-- constants
WF_NO_TILE = 48
WF_NO_OBJ  = 0

WF_PLAYER_START = 19  -- fixme: directions
WF_AREA_TILE = 107  -- fixme: more available


function write_wolf_level(p)

  local function handle_block(x, y)
    if not valid_block(x, y) then return end
    local B = p.blocks[x][y]
    if not B then return end

    local tile = WF_NO_TILE
    local obj  = WF_NO_OBJ

    if B.solid then
      tile = 11
    else
      tile = WF_AREA_TILE
    end

    if B.things[1] then
      if B.things[1].kind == 1 then
        obj = WF_PLAYER_START
      end
    end

    wolf.add_block(x, y, tile, obj)
  end

  con.progress(66); if con.abort() then return end

  wolf.begin_level(lev_name);

  for y = 1,64 do
    for x = 1,64 do
      handle_block(x, y)
    end
  end
  
  wolf.end_level()

  con.progress(100)
end

