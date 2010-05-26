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

CAVE_CLASS = {}


function Cave_new(w, h)
  local cave = { w=w, h=h }

  cave.cells = table.array_2D(w, h)

  table.set_class(cave, CAVE_CLASS)

  return cave
end


function CAVE_CLASS.get(self, x, y)
  return self.cells[x][y]
end


function CAVE_CLASS.set(self, x, y, val)
  self.cells[x][y] = val
end


function CAVE_CLASS.set_block(self, x1,y1, x2,y2, val)
  for x = x1,x2 do for y = y1,y2 do
    self.cells[x][y] = val
  end end
end


function CAVE_CLASS.copy(self)
  local newbie = Cave_new(self.w, self.h)

  for x = 1,self.w do for y = 1,self.h do
    newbie.cells[x][y] = self.cells[x][y]
  end end

  return newbie
end


function CAVE_CLASS.negate(self)
  for x = 1,self.w do for y = 1,self.h do
    if self.cells[x][y] then
      self.cells[x][y] = - self.cells[x][y]
    end
  end end

  return self
end



function CAVE_CLASS.generate(self, solid_prob)

--**
--**  This algorithm was described by Jim Babcock in his article
--**  "Cellular Automata Method for Generating Random Cave-Like Levels"
--**

  -- The initial contents of the cave form a map where the cave
  -- will be generated.  The following values can be used:
  --
  --    nil : never touched
  --     -1 : forced off
  --      0 : computed normally
  --     +1 : forced on
  --
  -- Result elements can be: nil, -1 or +1.
  --

-- FIXME: support -2, +2 as 'forced' on, -1,+1 as initial values

  solid_prob = solid_prob or 40

  local W = map.w
  local H = map.h

  local work = table.array_2D(W, H)
  local temp = table.array_2D(W, H)

  -- populate initial map
  for x = 1,W do for y = 1,H do
    if not map[x][y] or map[x][y] < 0 then
      work[x][y] = 0
    elseif map[x][y] > 0 then
      work[x][y] = 1
    else
      work[x][y] = rand.sel(solid_prob, 1, 0)
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


function CAVE_CLASS.gen_empty(self)
  
  -- this is akin to generate(), but making all target cells empty

  local W = map.w
  local H = map.h

  local work = table.array_2D(W, H)

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


function CAVE_CLASS.dump(self, title)
  gui.debugf("%s\n", title or "Cave Map:")

  for y = self.h,1,-1 do
    local line = "@c| ";
    for x = 1,self.w do
      local ch = " "
      local cell = self.cells[x][y]
      if  cell == 0      then ch = "?" end
      if (cell or 0) > 0 then ch = "#" end
      if (cell or 0) < 0 then ch = "." end
      line = line .. ch
    end
    gui.debugf("%s\n", line)
  end
end


function CAVE_CLASS.flood_fill(self)
  -- returns a new array where each contiguous region has a unique id.
  -- Empty areas use negative values, Solid areas use positive values.
  -- Zero is invalid.  Nil cells remain nil.
  --
  -- This also creates a table of regions, and various other statistics
  -- (as named fields of the result).

  local W = cave.w
  local H = cave.h

  local flood = table.array_2D(W, H)
  local empty_id = -1
  local solid_id =  1

  local points = {}

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
    for side = 2,8,2 do
      local nx, ny = geom.nudge(x, y, side)
      if nx >= 1 and nx <= W and ny >= 1 and ny <= H then
        local A = flood[x][y]
        local B = flood[nx][ny]

        if A and B and ((A > 0 and A < B) or (A < 0 and A > B)) then
          flood[nx][ny] = A
          table.insert(points, {x=nx, y=ny})
        end
      end
    end
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
  for x = 1,W do for y = 1,H do
    if flood[x][y] then
      flood_point(x, y)
    end
  end end

  while #points > 0 do
    local p_list = points ; points = {}

    for _,P in ipairs(p_list) do
      flood_point(P.x, P.y)
    end
  end

  -- create information for each region
  flood.regions = {}

  flood.empty_cells = 0
  flood.solid_cells = 0
  flood.empty_regions = 0
  flood.solid_regions = 0

  for x = 1,W do for y = 1,H do
    update_info(x, y)
  end end

  -- find largest regions
  for what,reg in pairs(flood.regions) do
    if what < 0 then
      if not flood.largest_empty or reg.cells > flood.largest_empty.cells then
        flood.largest_empty = reg
      end
    else
      if not flood.largest_solid or reg.cells > flood.largest_solid.cells then
        flood.largest_solid = reg
      end
    end
  end

  return flood
end


function CAVE_CLASS.region_is_island(self, reg)

  -- returns true if the region is an "island", i.e. touches neither the
  -- edge of the 2D matrix or a NIL cell.  In other words, it will be
  -- completely surrounded by its opposite (solid or empty).

  local W = flood.w
  local H = flood.h

  if reg.x1 <= 1 or reg.x2 >= W or reg.y1 <= 1 or reg.y2 >= H then
    return false
  end

  for x = reg.x1,reg.x2 do for y = reg.y1,reg.y2 do
    if flood[x][y] == reg.id then
      for side = 2,8,2 do
        local nx, ny = geom.nudge(x, y, side)
        if not flood[x][y] then
          return false
        end
      end
    end
  end end

  return true
end


function CAVE_CLASS.main_empty_region(self)

  -- find the largest empty region

  local empty_reg = flood.largest_empty

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


function CAVE_CLASS.grow(self)
  -- grow the cave : it will have more solids, less empties.
  -- nil cells are not affected.

  local W = self.w
  local H = self.h

  local work = table.array_2D(W, H)
  local cells = self.cells

  local function handle_neighbor(x, y, side)
    local nx, ny = geom.nudge(x, y, side)
    
    if nx < 1 or nx > W or ny < 1 or ny > H then
      return
    end

    if (cells[nx][ny] or 0) < 0 then
      work[nx][ny] = cells[x][y]
    end
  end

  for x = 1,W do for y = 1,H do
    work[x][y] = cells[x][y]

    if (cells[x][y] or 0) > 0 then
      for side = 2,8,2 do
        handle_neighbor(x, y, side)
      end
    end
  end end

  self.cells = work
end


function CAVE_CLASS.shrink(self, keep_edges)
  -- shrink the cave : it will have more empties, less solids.
  -- when 'keep_edges' is true, cells at edges are not touched.
  -- nil cells are not affected.

  local W = self.w
  local H = self.h

  local work = table.array_2D(W, H)
  local cells = self.cells

  local SIDES = { 2,4,6,8 }

  local function value_for_spot(x, y)
    rand.shuffle(SIDES)

    local hit_edge = false

    for _,side in ipairs(SIDES) do
      local nx, ny = geom.nudge(x, y, side)
    
      if nx < 1 or nx > W or ny < 1 or ny > H or not cells[nx][ny] then
        hit_edge = true
      elseif cells[nx][ny] < 0 then
        return cells[nx][ny]
      end
    end

    if hit_edge and not keep_sides then
      return nil
    end

    return cells[x][y]
  end

  for x = 1,W do for y = 1,H do
    if (cells[x][y] or 0) > 0 then
      work[x][y] = value_for_spot(x, y)
    else
      work[x][y] = cells[x][y]
    end
  end end

  self.cells = work
end


function CAVE_CLASS.remove_dots(self, keep_edges, callback)
  -- removes isolated solid cells from the cave.
  -- diagonal cells are NOT checked.

  local W = self.w
  local H = self.h

  local cells = self.cells

  local function is_isolated(x, y)
    local count = 0

    for side = 2,8,2 do
      local nx, ny = geom.nudge(x, y, side)

      if nx < 1 or nx > W or ny < 1 or ny > H or not cells[nx][ny] then
        if keep_edges then return false end
      elseif cells[nx][ny] > 0 then
        count = count + 1
      end
    end

    return (count == 0)
  end

  for x = 1,W do for y = 1,H do
    if is_isolated(x, y) then
      local dx = sel(x > W/2, -1, 1)
      cells[x][y] = cells[x+dx][y]
      if callback then
        callback(self, x, y)
      end
    end
  end end
end


function CAVE_CLASS.render(reg_id, base_x, base_y, brush_func, data,
                           square_caves)
  -- FIXME: make base_x/y and square_caves a class field

  -- only solid regions are handled
  assert(reg_id > 0)

  local W = cave.w
  local H = cave.h

  local corner_map = table.array_2D(W + 1, H + 1)


  local function is_land_locked(x, y)
    if x <= 1 or x >= W or y <= 1 or y >= H then
      return false
    end

    for dx = -1,1 do for dy = -1,1 do
      if cave[x+dx][y+dy] ~= reg_id then
        return false
      end
    end end

    return true
  end

  local function analyse_corner(corner_map, x, y, side)
    local dx, dy = geom.delta(side)

    local cx = x + sel(dx < 0, 0, 1)
    local cy = y + sel(dy < 0, 0, 1)

    if corner_map[cx][cy] then return end  -- already decided

    local function test_nb(dx, dy)
      local nx = x + dx
      local ny = y + dy

      if nx < 1 or nx > W or ny < 1 or ny > H then return true end

      return not cave[nx][ny] or (cave[nx][ny] > 0)
    end

    local A = test_nb(0, dy)
    local B = test_nb(dx, 0)
    local C = test_nb(dx, dy)

    if C then return end

    if not A and not B then

      if test_nb(-dx, 0) and test_nb(0, -dy) and rand.odds(70) then
        corner_map[cx][cy] = "drop"
        return
      end

      corner_map[cx][cy] = rand.pick { "x", "y", "xy", "split" }
      return
    end

    if A and not B then
      if rand.odds(40) then corner_map[cx][cy] = "x" end
      return
    end

    if B and not A then
      if rand.odds(40) then corner_map[cx][cy] = "y" end
      return
    end

    -- assert(A and B and not C)

    if rand.odds(1) then corner_map[cx][cy] = "split" end
    return
  end


  local function add_brush(corner_map, x, y, bx, by)
    bx = bx + (x - 1) * 64
    by = by + (y - 1) * 64

    -- most basic method (mostly for debugging)
    if square_caves then
      brush_func(data,
      {
        { x=bx+64, y=by },
        { x=bx+64, y=by+64 },
        { x=bx,    y=by+64 },
        { x=bx,    y=by },
      })

      return
    end

    local coords = { }
    local SIDES  = { 1,3,9,7 }

    for _,side in ipairs(SIDES) do
      local dx, dy = geom.delta(side)

      local cx = x + sel(dx < 0, 0, 1)
      local cy = y + sel(dy < 0, 0, 1)

      local fx = bx + sel(dx < 0, 0, 64)
      local fy = by + sel(dy < 0, 0, 64)

      local what = corner_map[cx][cy]

      if what == "drop" then
        -- ignore it

      elseif what == "split" then
        if side == 1 or side == 9 then
          table.insert(coords, { x=fx, y=fy-dy*24 })
          table.insert(coords, { x=fx-dx*24, y=fy })
        else
          table.insert(coords, { x=fx-dx*24, y=fy })
          table.insert(coords, { x=fx, y=fy-dy*24 })
        end

      else
        if what == "x" then fx = fx - dx*24 end
        if what == "y" then fy = fy - dy*24 end

        if what == "xy" then
          fx = fx - dx*16
          fy = fy - dy*16
        end

        table.insert(coords, { x=fx, y=fy })
      end
    end

  --- gui.debugf("CAVE BRUSH:\n%s\n\n", table.tostr(coords,2))

    brush_func(data, coords)
  end


  ---| Cave.render |---

  for x = 1,W do for y = 1,H do
    if cave[x][y] == reg_id then
      for side = 1,9,2 do if side ~= 5 then
        analyse_corner(corner_map, x, y, side)
      end end
    end
  end end -- for x, y

  for x = 1,W do for y = 1,H do
    if cave[x][y] == reg_id then
      add_brush(corner_map, x, y, base_x, base_y)
    end
  end end
end

