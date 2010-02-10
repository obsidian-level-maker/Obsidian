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

  -- The 'map' parameter is created with array_2D().
  --
  -- Elements of the array can start with these values:
  --    nil : never touched
  --     -1 : forced off
  --      0 : computed normally
  --     +1 : forced on
  --
  -- After generation, the values can be nil, -1 or +1.
  --

  local W = map.w
  local H = map.h

  local work  = array_2D(W, H)
  local other = array_2D(W, H)

  -- populate initial map
  for x = 1,W do for y = 1,H do
    if map[x][y] == 0 then
      work[x][y] = rand_sel(36, 1, -1)
    elseif map[x][y] > 0 then
      work[x][y] = 1
    else -- nil or negative
      work[x][y] = 0
    end
  end end

  local function calc_new(x, y, loop)
    if map[x][y] ~= 0 then return end

    if x == 1 or x == W or y == 1 or y == H then
      return work[x][y]
    end

    if work[x][y] < 0 then return work[x][y] end

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
      other[x][y] = calc_new(x, y, loop)
    end end

    work, other = other, work
  end

  for x = 1,W do for y = 1,H do
    if map[x][y] == 0 then
      map[x][y] = sel(work[x][y] > 0, 1, -1)
    end
  end end
end


function Cave_dump(map)
  gui.debugf("Cave_Map:\n")

  for y = map.h,1,-1 do
    local line = "    ";
    for x = 1,map.w do
      local ch = " "
      if (map[x][y] or 0) > 0 then ch = "#" end
      if (map[x][y] or 0) < 0 then ch = "." end
      line = line .. ch
    end
    gui.debugf(line)
  end
end


function Cave_validate(map)
  local W = map.w
  local H = map.h

  local id = 1
  local min_x, min_y =  999,  999
  local max_x, max_y = -999, -999

  local work = array_2D(map.w, map.h)

  for x = 1,W do for y = 1,H do
    if map[x][y] > 0 then
      work[x][y] = 0
    else
      work[x][y] = id ; id = id + 1

      min_x = math.min(min_x, x) ; min_y = math.min(min_y, y)
      max_x = math.max(max_x, x) ; max_y = math.max(max_y, y)
    end
  end end

  -- preliminary size check
  local size_x = max_x - min_x + 1
  local size_y = max_y - min_y + 1

  if (size_x*1.6 < W and size_y*1.6 < H) or
     (size_x*3.2 < W or  size_y*3.2 < H) then
    return false
  end 

  -- perform flood-fill on empty areas
  local function flood_point(x, y)
    local changed = false
    for side = 2,8,2 do
      local nx, ny = nudge_coord(x, y, side)
      if nx >= 1 and nx <= W and ny >= 1 and ny <= H then
        local W1 = work[x][y]
        local W2 = work[nx][ny]

        if W2 > 0 and W2 < W1 then
          work[x][y] = W2
          changed = true
        end
      end
    end

    return changed
  end

  repeat
    local changed = false
    for x = 1,W do for y = 1,H do
      if work[x][y] > 0 then
        if flood_point(x, y) then changed = true end
      end
    end end
  until not changed

  -- after flood fill, all areas should have id == 1
  for x = 1,W do for y = 1,H do
    if work[x][y] >= 2 then return false end
  end end

  return true
end


function Cave_remove_children(R, map)
  for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
    local S = SEEDS[x][y][1]
    if S.room ~= R then
      local nx1 = (S.sx - R.sx1) * 5 + 1
      local ny1 = (S.sy - R.sy1) * 5 + 1

      for dx = 0,4 do for dy = 0,4 do
        map[nx1+dx][ny1+dy] = 1
      end end -- for dx, dy
    end
  end end -- for x, y
end

