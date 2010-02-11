----------------------------------------------------------------
--  CAVE GENERATION
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2009-2010 Andrew Apted
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


function Cave_gen(map)

--**
--**  This algorithm was described by Jim Babcock in his article
--**  "Cellular Automata Method for Generating Random Cave-Like Levels"
--**

  -- The 'map' parameter must be created with array_2D().
  -- The result is a totally new array.
  --
  -- Elements of the array can start with these values:
  --    nil : never touched
  --     -1 : forced off
  --      0 : computed normally
  --     +1 : forced on
  --
  -- Result elements can be: nil, -1 or +1.
  --

  local W = map.w
  local H = map.h

  local work = array_2D(W, H)
  local temp = array_2D(W, H)

  -- populate initial map
  for x = 1,W do for y = 1,H do
    if not map[x][y] or map[x][y] < 0 then
      work[x][y] = 0
    elseif map[x][y] > 0 then
      work[x][y] = 1
    else
      work[x][y] = rand_sel(40, 1, 0)
    end
  end end

  local function calc_new(x, y, loop)
    if not map[x][y] then return 0 end
    if map[x][y] > 0 then return 1 end
    if map[x][y] < 0 then return 0 end

    if x == 1 or x == W or y == 1 or y == H then
      return work[x][y]
    end

    local neighbors = 0
    for nx = x-1,x+1 do for ny = y-1,y+1 do
      neighbors = neighbors + work[nx][ny]
    end end

    if neighbors >= 5 then return 1 end

    if loop >= 5 then return 0 end

    if x <= 2 or x >= W-1 or y <= 2 or y >= H-1 then return 0 end

    -- check larger area
    local neighbors = 0
    for nx = x-2,x+2 do for ny = y-2,y+2 do
      if math.abs(x-nx) == 2 and math.abs(y-ny) == 2 then
        -- skip the corners of the 5x5 block
      else
        neighbors = neighbors + work[nx][ny]
      end
    end end

    if neighbors <= 2 then return 1 end

    return 0
  end

  -- perform the cellular automation steps
  for loop = 1,7 do
    for x = 1,W do for y = 1,H do
      temp[x][y] = calc_new(x, y, loop)
    end end

    work, temp = temp, work
  end

  -- convert values for the result
  for x = 1,W do for y = 1,H do
    if map[x][y] == 0 then
      work[x][y] = sel(work[x][y] > 0, 1, -1)
    else
      work[x][y] = map[x][y]
    end
  end end

  return work
end


function Cave_fallback(map)
  local W = map.w
  local H = map.h

  local work = array_2D(W, H)

  for x = 1,W do for y = 1,H do
    if not map[x][y] then
      -- skip it
    elseif map[x][y] > 0 then
      work[x][y] = 1
    else
      work[x][y] = -1
    end
  end end

  return work
end


function Cave_dump(map)
  gui.debugf("Cave_Map:\n")

  for y = map.h,1,-1 do
    local line = "| ";
    for x = 1,map.w do
      local ch = " "
      if map[x][y] == 0       then ch = "?" end
      if (map[x][y] or 0) > 0 then ch = "#" end
      if (map[x][y] or 0) < 0 then ch = "." end
      line = line .. ch
    end
    gui.debugf(line)
  end
end


function Cave_flood_fill(cave)
  -- returns a new array where each contiguous region has a unique id.
  -- Empty areas use negative values, Solid areas use positive values.
  -- Zero is invalid.  Nil cells remain nil.

  local W = cave.w
  local H = cave.h

  local flood = array_2D(W, H)
  local empty_id = -1
  local solid_id =  1

  for x = 1,W do for y = 1,H do
    if not cave[x][y] then
      -- ignore it
    elseif cave[x][y] < 0 then
      flood[x][y] = empty_id ; empty_id = empty_id - 1
    else
      flood[x][y] = solid_id ; solid_id = solid_id + 1
    end
  end end

  local function flood_point(x, y)
    local changed = false
    for side = 2,8,2 do
      local nx, ny = nudge_coord(x, y, side)
      if nx >= 1 and nx <= W and ny >= 1 and ny <= H then
        local A = flood[x][y]
        local B = flood[nx][ny]

        if A and B and ((B > 0 and B < A) or (B < 0 and B > A)) then
          flood[x][y] = B
          changed = true
        end
      end
    end

    return changed
  end

  local function update_info(x, y)
    local f = flood[x][y]
    if not f then return end

    if f < 0 then
      flood.empty_cells = flood.empty_cells + 1
    else
      flood.solid_cells = flood.solid_cells + 1
    end

    local reg = flood.regions[f]

    if not reg then
      reg =
      {
        id = f,
        x1 = x, y1 = y,
        x2 = x, y2 = y,
        cells = 0,
      }

      flood.regions[f] = reg

      if f < 0 then
        flood.empty_regions = flood.empty_regions + 1
      else
        flood.solid_regions = flood.solid_regions + 1
      end
    end

    if x < reg.x1 then reg.x1 = x end
    if y < reg.y1 then reg.y1 = y end
    if x > reg.x2 then reg.x2 = x end
    if y > reg.y2 then reg.y2 = y end

    reg.cells = reg.cells + 1
  end

  -- perform the flood-fill
  repeat
    local changed = false
    for x = 1,W do for y = 1,H do
      if flood[x][y] then
        if flood_point(x, y) then changed = true end
      end
    end end
  until not changed

  -- create information for each region
  flood.regions = {}

  flood.empty_cells = 0
  flood.solid_cells = 0
  flood.empty_regions = 0
  flood.solid_regions = 0

  for x = 1,W do for y = 1,H do
    update_info(x, y)
  end end

  return flood
end


function Cave_main_empty_region(flood)

  -- find the largest empty region

  local empty_reg

  for what,reg in pairs(flood.regions) do
    if what < 0 then
      if not empty_reg or reg.cells > empty_reg.cells then
        empty_reg = reg
      end
    end
  end

  if not empty_reg then
    return
  end

  -- size check
  local W = flood.w
  local H = flood.h

  local size_ok = true

  local size_x = empty_reg.x2 - empty_reg.x1 + 1
  local size_y = empty_reg.y2 - empty_reg.y1 + 1

  if (size_x*1.6 < W and size_y*1.6 < H) or
     (size_x*3.2 < W or  size_y*3.2 < H) then
    size_ok = false
  end 

  return empty_reg, size_ok
end

