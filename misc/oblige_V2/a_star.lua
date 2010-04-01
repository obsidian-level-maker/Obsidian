----------------------------------------------------------------
-- A* PATHING
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


--
-- Find path from start (sx,sy) to end (ex,ey)
--
-- Score function:
--   f(cx,cy, nx,ny, dir) -> distance, negative for impossible
--
function astar_find_path(w, h, sx, sy, ex, ey, scorer)
  local open   = array_2D(w, h)
  local closed = array_2D(w, h)
  local cx, cy

  local function calc_H(x,y)
    x = math.abs(x - ex)
    y = math.abs(y - ey)
    return math.sqrt(x * x + y * y) 
  end

  function lowest_F()  -- brute force search (SLOW!)
    local rx = nil
    local ry = nil
    local best_F = 99999999
    for x = 1,open.w do
      for y = 1,open.h do
        if open[x][y] then
          local F = open[x][y].G + open[x][y].H
          if F < best_F then
            best_F = F
          rx = x
          ry = y
          end
        end
      end
    end
    return rx, ry
  end

  local function try_dir(nx, ny, dir)
    if nx < 1 or nx > w then return end
    if ny < 1 or ny > h then return end

    local G = scorer(cx,cy, nx,ny, dir)

    if G < 0 then return false end

    if nx == ex and ny == ey then return true end

    if closed[nx][ny] then return false end

    G = G + closed[cx][cy].G  -- get total distance

    if not open[nx][ny] or G < open[nx][ny].G then
      open[nx][ny] = { G=G, H=calc_H(nx,ny), px=cx, py=cy }
    end
    
    return false
  end

  local function collect_path()
    local p = {}
    repeat
      table.insert(p, 1, { x=cx, y=cy })
      cx, cy = closed[cx][cy].px, closed[cx][cy].py
    until not cx
    return p
  end

  ---- BEGIN ALGORITHM ----
  
  if sx == ex and sy == ey then
    error("find_path: start and end are the same")
  end
  
  -- add the start point to open list
  open[sx][sy] = { G=0, H=0 }

  while true do
    cx, cy = lowest_F(open)

    if not cx then return nil end  -- no path!

    -- move from open list to closed list
    closed[cx][cy] = open[cx][cy]
    open[cx][cy] = nil

    if try_dir(cx, cy-1, 2) or try_dir(cx-1, cy, 4) or
       try_dir(cx, cy+1, 8) or try_dir(cx+1, cy, 6)
    then
      return collect_path()
    end
  end
end

