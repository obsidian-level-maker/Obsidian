------------------------------------------------------------------------
--  CELLULAR AUTOMATA (CAVE GENERATION, ETC)
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2009-2017 Andrew Apted
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
------------------------------------------------------------------------
--
--  The cave algorithm used here in the generate() function was
--  described by Jim Babcock in his article: "Cellular Automata
--  Method for Generating Random Cave-Like Levels".
--
------------------------------------------------------------------------


--class GRID : extends ARRAY_2D
--[[
    -- when used for caves, each cell can be:
    --    NIL        : unused (e.g. another room)
    --    number > 0 : solid (i.e. wall)
    --    number < 0 : empty (i.e. a floor)

    flood : array_2D(number)  -- contiguous areas have the same value
                              -- (positive for solid, negative for empty)

    regions : table[id] -> REGION
--]]


--class REGION
--[[
    id : number

    cx1, cy1, cx2, cy2  -- bounding box

    size  -- number of cells

    neighbors : list(REGION)  -- only for blobs
--]]


GRID_CLASS = {}


function GRID_CLASS.new(w, h)
  local grid = table.array_2D(w, h)

  table.set_class(grid, GRID_CLASS)

  return grid
end


function GRID_CLASS.blank_copy(grid)
  return GRID_CLASS.new(grid.w, grid.h)
end


function GRID_CLASS.valid(grid, x, y)
  return (1 <= x and x <= grid.w) and (1 <= y and y <= grid.h)
end


function GRID_CLASS.get(grid, x, y)
  return grid[x][y]
end


function GRID_CLASS.set(grid, x, y, val)
  grid[x][y] = val
end


function GRID_CLASS.fill(grid, cx1,cy1, cx2,cy2, val)
  for x = cx1, cx2 do
  for y = cy1, cy2 do
    grid[x][y] = val
  end
  end
end


function GRID_CLASS.set_all(grid, val)
  grid:fill(1, 1, grid.w, grid.h, val)
end


function GRID_CLASS.negate(grid, cx1,cy1, cx2,cy2)
  if not cx1 then
    cx1, cx2 = 1, grid.w
    cy1, cy2 = 1, grid.h
  end

  for x = cx1, cx2 do
  for y = cy1, cy2 do
    if grid[x][y] then
      grid[x][y] = 0 - grid[x][y]
    end
  end
  end

  return grid
end


function GRID_CLASS.copy(grid)
  -- a fairly shallow copy, only "w" and "h" members are copied
  -- (NOT additional stuff like "flood" or "regions"), and each
  -- cell is copied by value.

  local newbie = grid:blank_copy()

  for x = 1, grid.w do
  for y = 1, grid.h do
    newbie[x][y] = grid[x][y]
  end
  end

  return newbie
end


function GRID_CLASS.swap_data(grid, other)
  assert(grid.w == other.w)
  assert(grid.h == other.h)

  for y = 1, grid.h do
    local row1 =  grid[y]
    local row2 = other[y]

     grid[y] = row2
    other[y] = row1
  end
end


function GRID_CLASS.dump(grid, title)
  if title then
    gui.debugf("%s\n", title)
  end

  for y = grid.h,1,-1 do
    local line = "| "

    for x = 1,grid.w do
      local ch = " "
      local cell = grid[x][y]

      if  cell == 0      then ch = "/" end
      if (cell or 0) > 0 then ch = "#" end
      if (cell or 0) < 0 then ch = "." end

      line = line .. ch
    end

    line = line .. " |"

    gui.debugf("%s\n", line)
  end

  gui.debugf("\n")
end


function GRID_CLASS.union(grid, other)
  -- make empty cells in 'grid' solid if they are solid in 'other'.
  -- when either cell is NIL, nothing happens.

  local W = math.min(grid.w, other.w)
  local H = math.min(grid.h, other.h)

  for x = 1, W do
  for y = 1, H do
    if ( grid[x][y] or 0) < 0 and
       (other[x][y] or 0) > 0
    then
      grid[x][y] = other[x][y]
    end
  end
  end
end


function GRID_CLASS.intersection(grid, other)
  -- make solid cells in 'grid' empty if they are empty in 'other'.
  -- when either cell is NIL, nothing happens.

  local W = math.min(grid.w, other.w)
  local H = math.min(grid.h, other.h)

  for x = 1, W do
  for y = 1, H do
    if ( grid[x][y] or 0) > 0 and
       (other[x][y] or 0) < 0
    then
      grid[x][y] = other[x][y]
    end
  end
  end
end


function GRID_CLASS.subtract(grid, other, new_id)
  -- set cells in 'grid' to new_id, defaulting to -1, when both cells
  -- in 'grid' and 'other' are solid.
  --
  -- when either cell is NIL, nothing happens.

  new_id = new_id or -1

  local W = math.min(grid.w, other.w)
  local H = math.min(grid.h, other.h)

  for x = 1, W do
  for y = 1, H do
    if ( grid[x][y] or 0) > 0 and
       (other[x][y] or 0) > 0
    then
      grid[x][y] = new_id
    end
  end
  end
end


function GRID_CLASS.generate_cave(grid, solid_prob)
  --
  -- The contents of the input grid form a map where a cave
  -- will be generated.  The following values can be used:
  --
  --    nil : never touched
  --     -1 : forced off
  --      0 : computed normally
  --     +1 : forced on
  --
  -- A new grid is returned, the elements can be: nil, -1 or +1.
  --

  solid_prob = solid_prob or 40

  local W = grid.w
  local H = grid.h

  -- these arrays only use 0 and 1 as values
  local work = grid:blank_copy()
  local temp = grid:blank_copy()

  -- populate initial map
  for x = 1, W do
  for y = 1, H do
    if not grid[x][y] or grid[x][y] < 0 then
      work[x][y] = 0
    elseif grid[x][y] > 0 then
      work[x][y] = 1
    else
      work[x][y] = rand.sel(solid_prob, 1, 0)
    end
  end
  end


  local function calc_new(x, y, loop)
    if not grid[x][y] then return 0 end

    if grid[x][y] > 0 then return 1 end
    if grid[x][y] < 0 then return 0 end

    if x == 1 or x == W or y == 1 or y == H then
      return work[x][y]
    end

    local neighbors = 0
    for nx = x-1,x+1 do
    for ny = y-1,y+1 do
      neighbors = neighbors + work[nx][ny]
    end
    end

    if neighbors >= 5 then return 1 end

    if loop >= 5 then return 0 end

    if x <= 2 or x >= W-1 or y <= 2 or y >= H-1 then return 0 end

    -- check larger area
    local neighbors = 0
    for nx = x-2,x+2 do
    for ny = y-2,y+2 do
      if math.abs(x-nx) == 2 and math.abs(y-ny) == 2 then
        -- skip the corners of the 5x5 block
      else
        neighbors = neighbors + work[nx][ny]
      end
    end
    end

    if neighbors <= 2 then return 1 end

    return 0
  end


  -- perform the cellular automation steps
  for loop = 1,7 do
    for x = 1, W do
    for y = 1, H do
      temp[x][y] = calc_new(x, y, loop)
    end
    end

    work, temp = temp, work
  end

  -- convert values for the result
  for x = 1, W do
  for y = 1, H do
    if grid[x][y] == 0 then
      work[x][y] = sel(work[x][y] > 0, 1, -1)
    else
      work[x][y] = grid[x][y]
    end
  end
  end

  return work
end


function GRID_CLASS.gen_empty_cave(grid)
  --
  -- This is like generate_cave(), but making the largest possible
  -- area of empty cells.
  --

  local W = grid.w
  local H = grid.h

  local result = grid:blank_copy()

  for x = 1, W do
  for y = 1, H do
    if not grid[x][y] then
      -- skip it
    elseif grid[x][y] > 0 then
      result[x][y] = 1
    else
      result[x][y] = -1
    end
  end
  end

  return result
end


function GRID_CLASS.dump_regions(grid)
  if not grid.regions then
    gui.debugf("No region info (flood_fill not called yet)\n")
    return
  end

  gui.debugf("Regions:\n")

  local empty_regs  = 0
  local empty_cells = 0

  local solid_regs  = 0
  local solid_cells = 0

  for id, REG in pairs(grid.regions) do
    gui.debugf("  %+4d : (%d %d) .. (%d %d) size:%d\n",
               REG.id, REG.cx1, REG.cy1, REG.cx2, REG.cy2, REG.size)

    if id < 0 then
      empty_regs  = empty_regs  + 1
      empty_cells = empty_cells + REG.size
    elseif id > 0 then
      solid_regs  = solid_regs  + 1
      solid_cells = solid_cells + REG.size
    end
  end

  gui.debugf("  total empty: %d (with %d cells)\n", empty_regions, empty_cells)
  gui.debugf("  total solid: %d (with %d cells)\n", solid_regions, solid_cells)
end


function GRID_CLASS.flood_fill(grid)
  --
  -- Generate the 'flood' member, an array where each contiguous region
  -- has a unique id.  Empty areas are negative, solid areas are positive,
  -- and everything else is NIL.
  --
  -- This also creates the 'regions' table.
  --

  local W = grid.w
  local H = grid.h

  local flood = table.array_2D(W, H)

  local cur_solid =  1
  local cur_empty = -1

  local next_points = {}


  local function flood_point(x, y)
    -- spread value from this cell to neighbors

    local A = flood[x][y]
    assert(A)

    for dir = 2,8,2 do
      local nx, ny = geom.nudge(x, y, dir)
      if nx >= 1 and nx <= W and ny >= 1 and ny <= H then
        local B = flood[nx][ny]

        if B and ((A > 0 and A < B) or (A < 0 and A > B)) then
          flood[nx][ny] = A
          table.insert(next_points, { x=nx, y=ny })
        end
      end
    end
  end


  local function update_info(x, y)
    local id = flood[x][y]

    if not id then return end

    assert(id ~= 0)

    local REG = grid.regions[id]

    if not REG then
      REG =
      {
        id = id,
        cx1 = x, cy1 = y,
        cx2 = x, cy2 = y,
        size = 0,
      }

      grid.regions[id] = REG
    end

    if x < REG.cx1 then REG.cx1 = x end
    if y < REG.cy1 then REG.cy1 = y end
    if x > REG.cx2 then REG.cx2 = x end
    if y > REG.cy2 then REG.cy2 = y end

    REG.size = REG.size + 1
  end


  -- initial setup

  for x = 1, W do
  for y = 1, H do
    if not grid[x][y] then
      -- ignore it
    elseif grid[x][y] < 0 then
      flood[x][y] = cur_empty ; cur_empty = cur_empty - 1
    else
      flood[x][y] = cur_solid ; cur_solid = cur_solid + 1
    end
  end
  end

  -- perform the flood-fill

  for x = 1, W do
  for y = 1, H do
    if flood[x][y] then
      flood_point(x, y)
    end
  end
  end

  while #next_points > 0 do
    local np_list = next_points ; next_points = {}

    for _,P in pairs(np_list) do
      flood_point(P.x, P.y)
    end
  end

  -- create information for each region

  grid.regions = {}

  for x = 1, W do
  for y = 1, H do
    update_info(x, y)
  end
  end

  grid.flood = flood
end


function GRID_CLASS.solidify_pockets(grid, walk_id, solid_id)
  -- this removes the empty areas which are surrounded by solid
  -- (i.e. not part of the main walk area).
  --
  -- the 'walk_id' parameter is the main walkable region.
  -- the 'solid_id' parameter is what to set the pockets to,
  -- defaulting to 1.

  assert(walk_id)

  solid_id = solid_id or 1


  local function find_next()
    for id, REG in pairs(grid.regions) do
      if id < 0 and id ~= walk_id then
        return id, REG
      end
    end

    -- nothing found
    return nil
  end


  while true do
    local pocket_id, REG = find_next()

    -- nil means nothing else exists
    if not pocket_id then break; end

    -- solidify the cells
    for x = REG.cx1, REG.cx2 do
    for y = REG.cy1, REG.cy2 do
      if grid.flood[x][y] == pocket_id then
        grid.flood[x][y] = nil
        grid[x][y] = solid_id
      end
    end
    end

    -- remove the region info
    grid.regions[pocket_id] = nil
  end
end


function GRID_CLASS.copy_region(grid, reg_id)
  -- creates a new grid where the cells are 1 when the given
  -- region is, -1 where other regions are (empty or solid),
  -- and NIL where nothing is.

  local flood = assert(grid.flood)

  local result = grid:blank_copy()

  for x = 1, grid.w do
  for y = 1, grid.h do
    local val = flood[x][y]

    if val == nil then
      -- nothing to copy
    elseif val == reg_id then
      result[x][y] = 1
    else
      result[x][y] = -1
    end
  end
  end

  return result
end


function GRID_CLASS.find_islands(grid)
  --
  -- Detects islands, which are a contiguous *solid* area of a
  -- cave which is completely surrounded by an empty area.
  --
  -- The result is a list of island grids.
  --
  -- The input grid must have been flood-filled already.
  -- Nothing is modified in the input grid.
  --

  assert(grid.flood)

  local islands = {}

  local W = grid.w
  local H = grid.h

  local flood = grid.flood

  -- scan the cave, determine which regions are islands --

  -- a table mapping region ids to a string value: "maybe" if could be
  -- an island, and "no" when definitely not an island.
  local potentials = {}

  for x = 1, W do
  for y = 1, H do
    local reg = flood[x][y]
    if (reg or 0) > 0 then

      if not potentials[reg] then
        potentials[reg] = "maybe"
      end

      if x == 1 or x == W or y == 1 or y == H then
        potentials[reg] = "no"
      end

      if potentials[reg] ~= "no" then
        for dir = 2,8,2 do
          local nx, ny = geom.nudge(x, y, dir)

          if grid:valid(nx, ny) and flood[nx][ny] == nil then
            potentials[reg] = "no"
            break;
          end
        end
      end

    end
  end -- x, y
  end

  -- create the grids --

  for reg, pot in pairs(potentials) do
    if pot == "maybe" then
      local island = grid:copy_region(reg)

      table.insert(list, island)

      -- island:dump("Island for " .. tostring(reg))
    end
  end

  return list
end


function GRID_CLASS.grow(grid, keep_edges)
  -- grow the cave : it will have more solids, less empties.
  -- nil cells are not affected.

  local W = grid.w
  local H = grid.h

  local work = table.array_2D(W, H)


  local function value_for_spot(x, y)
    local val = grid[x][y]
    local hit_edge

    for dir = 2,8,2 do
      local nx, ny = geom.nudge(x, y, dir)

      if not grid:valid(nx, ny) or not grid[nx][ny] then
        hit_edge = true
      elseif grid[nx][ny] > 0 then
        val = grid[nx][ny]
      end
    end

    if keep_edges and hit_edge then
      return grid[x][y]
    end

    return val
  end

  -- compute the new cells
  for x = 1, W do
  for y = 1, H do
    if grid[x][y] then
      work[x][y] = value_for_spot(x, y)
    end
  end
  end

  -- transfer result into input grid
  grid:swap_data(work)
end


function GRID_CLASS.grow8(grid, keep_edges)
  -- like grow() method but expands in all 8 directions

  local W = grid.w
  local H = grid.h

  local work = table.array_2D(W, H)


  local function value_for_spot(x, y)
    local val = grid[x][y]
    local hit_edge

    for dir = 1,9 do if dir ~= 5 then
      local nx, ny = geom.nudge(x, y, dir)

      if not grid:valid(nx, ny) or not grid[nx][ny] then
        hit_edge = true
      elseif grid[nx][ny] > 0 then
        val = grid[nx][ny]
      end
    end end -- dir

    if keep_edges and hit_edge then
      return grid[x][y]
    end

    return val
  end

  -- compute the new cells
  for x = 1, W do
  for y = 1, H do
    if grid[x][y] then
      work[x][y] = value_for_spot(x, y)
    end
  end
  end

  -- transfer result into input grid
  grid:swap_data(work)
end


function GRID_CLASS.shrink(grid, keep_edges)
  -- shrink the cave : it will have more empties, less solids.
  -- when 'keep_edges' is true, cells at edges are not touched.
  -- nil cells are not affected.

  local W = grid.w
  local H = grid.h

  local work = table.array_2D(W, H)

  local function value_for_spot(x, y)
    local val = grid[x][y]
    local hit_edge

    for dir = 2,8,2 do
      local nx, ny = geom.nudge(x, y, dir)

      if not grid:valid(nx, ny) or not grid[nx][ny] then
        hit_edge = true
      elseif grid[nx][ny] < 0 then
        val = grid[nx][ny]
      end
    end

    if keep_edges and hit_edge then
      return grid[x][y]
    end

    return val
  end

  -- compute the new cells
  for x = 1, W do
  for y = 1, H do
    if grid[x][y] then
      work[x][y] = value_for_spot(x, y)
    end
  end
  end

  -- transfer result into input grid
  grid:swap_data(work)
end


function GRID_CLASS.shrink8(grid, keep_edges)
  -- like shrink() method but checks all 8 directions

  local W = grid.w
  local H = grid.h

  local work = table.array_2D(W, H)

  local function value_for_spot(x, y)
    local val = grid[x][y]
    local hit_edge

    for dir = 1,9 do if dir ~= 5 then
      local nx, ny = geom.nudge(x, y, dir)

      if not grid:valid(nx, ny) or not grid[nx][ny] then
        hit_edge = true
      elseif grid[nx][ny] < 0 then
        val = grid[nx][ny]
      end
    end end -- dir

    if keep_edges and hit_edge then
      return grid[x][y]
    end

    return val
  end

  -- compute the new cells
  for x = 1, W do
  for y = 1, H do
    if grid[x][y] then
      work[x][y] = value_for_spot(x, y)
    end
  end
  end

  -- transfer result into input grid
  grid:swap_data(work)
end


function GRID_CLASS.remove_dots(grid)
  -- removes isolated cells (solid or empty) from the cave.
  -- diagonal cells are NOT checked.

  local W = grid.w
  local H = grid.h


  local function is_isolated(x, y, val)
    for dir = 2,8,2 do
      local nx, ny = geom.nudge(x, y, dir)

      if not grid:valid(nx, ny) or not grid[nx][ny] then
        -- ignore it
      elseif grid[nx][ny] == val then
        return false
      end
    end

    return true
  end


  for x = 1, W do
  for y = 1, H do
    local val = grid[x][y]

    if val and val ~= 0 and is_isolated(x, y, val) then
      local dx = sel(x > W/2, -1, 1)

      grid[x][y] = grid[x+dx][y]
    end
  end
  end
end


function GRID_CLASS.is_land_locked(grid, x, y)
  if x <= 1 or x >= grid.w or y <= 1 or y >= grid.h then
    return false
  end

  for dx = -1, 1 do
  for dy = -1, 1 do
    if (grid[x+dx][y+dy] or 0) < 0 then
      return false
    end
  end
  end

  return true
end


function GRID_CLASS.is_empty_locked(grid, x, y)
  if x <= 1 or x >= grid.w or y <= 1 or y >= grid.h then
    return false
  end

  for dx = -1, 1 do
  for dy = -1, 1 do
    if (grid[x+dx][y+dy] or 0) >= 0 then
      return false
    end
  end
  end

  return true
end


function GRID_CLASS.distance_map(grid, ref_points)
  assert(grid.flood)
  assert(grid.empty_id)

  local W = grid.w
  local H = grid.h

  local work = table.array_2D(W, H)
  local flood = grid.flood

  local next_points = {}

  local function flood_point(x, y)

    -- spread this distance into neighbor cells
    local dist = work[x][y] + 1

    for side = 2,8,2 do
      local nx, ny = geom.nudge(x, y, side)
      if nx >= 1 and nx <= W and ny >= 1 and ny <= H then
        local F = flood[nx][ny]
        local W =  work[nx][ny]

        if F == grid.empty_id and (not W or W > dist) then
          flood[nx][ny] = dist
          table.insert(next_points, { x=nx, y=ny })
        end
      end
    end
  end

  -- perform the fill

  for _,P in pairs(ipairs(ref_points)) do
    work[P.x][P.y] = 0,
    flood_point(P.x, P.y)
  end

  while #next_points > 0 do
    local np_list = next_points ; next_points = {}

    for _,P in pairs(ipairs(np_list)) do
      flood_point(P.x, P.y)
    end
  end

  return work
end


function GRID_CLASS.furthest_point(grid, ref_points)
  local dist_map = grid:distance_map(ref_points)

  local best_x, best_y
  local best_dist = 9e9

  for x = 1, W do
  for y = 1, H do
    local dist = dist_map[x][y]
    if dist and dist < (best_dist+3) then

      -- prefer away from edges
      if x == 1 or x == W then dist = dist + 0.1 end
      if y == 1 or y == H then dist = dist + 0.2 end

      -- prefer a spot away from the wall
      if grid:is_empty_locked(x, y) then
        dist = dist - 2.4
      end

      if dist < best_dist then
        best_x, best_y = x, y
        best_dist = dist
      end

    end
  end  -- x, y
  end

  return best_x, best_y  -- could be nil !
end



----------------------------------------------------------------
--  BLOB STUFF
----------------------------------------------------------------


function GRID_CLASS.dump_blobs(grid)

  local function char_for_cell(cx, cy)
    local id = grid[cx][cy]

    if id == nil then return " " end

    if id < 0 then return "." end

    id = 1 + (id - 1) % 36

    return string.sub("1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ", id, id)
  end


  local function dump_map()
    gui.debugf("Blob map:\n")

    for cy = grid.h, 1, -1 do
      local line = ""

      for cx = 1, grid.w do
        line = line .. char_for_cell(cx, cy)
      end

      gui.debugf("| %s\n", line)
    end
  end


  local function dump_sizes()
    gui.debugf("Blob sizes:\n")

    local line = ""

    for id, reg in pairs(grid.regions) do
      line = line .. "  " .. string.format("%2d", reg.size)

      if #line > 40 then
        gui.debugf("%s\n", line)
        line = ""
      end
    end

    if #line > 0 then
      gui.debugf("%s\n", line)
    end
  end


  ---| dump_blobs |---

  dump_map()
  dump_sizes()

  gui.debugf("\n")
end


function GRID_CLASS.create_blobs(grid, step_x, step_y)
  --
  -- Divide the given grid into "blobs", which are small groups
  -- of contiguous cells.
  --
  -- Returns a new grid, where each valid cell will contain a blob
  -- identity number.
  --
  -- NOTE: the input region MUST be contiguous
  --       [ if not, expect unfilled places ]

  local result = grid:blank_copy()

  result.regions = {}


  local W = grid.w
  local H = grid.h

  local total_blobs = 0

  local grow_dirs = {}


  local function is_usable(cx, cy)
    if cx < 1 or cx > W then return false end
    if cy < 1 or cy > H then return false end

    if grid[cx][cy] == nil then return false end

    return grid[cx][cy] > 0
  end


  local function is_free(cx, cy)
    if not is_usable(cx, cy) then return false end

    if result[cx][cy] then return false end

    return true
  end


  local function neighbor_blob(cx, cy, dir)
    cx, cy = geom.nudge(cx, cy, dir)

    if not is_usable(cx, cy) then return nil end

    return result[cx][cy]
  end


  local function set_cell(cx, cy, id)
    assert(is_free(cx, cy))

    result[cx][cy] = id

    local reg = result.regions[id]

    if not reg then
      reg = { id=id, size=0 }

      result.regions[id] = reg
    end

    reg.size = reg.size + 1
  end


  local function try_set_cell(cx, cy, id)
    if is_free(cx, cy) then
      set_cell(cx, cy, id)
    end
  end


  local function spawn_blobs()
    for cx = 1, W, step_x do
    for cy = 1, H, step_y do
      if rand.odds(5) then goto continue end

      local dx = rand.irange(0, step_x - 1)
      local dy = rand.irange(0, step_y - 1)

      if not is_free(cx+dx, cy+dy) then
        goto continue
      end

      total_blobs = total_blobs + 1

      set_cell(cx+dx, cy+dy, total_blobs)
      ::continue::
    end
    end

    if total_blobs > 0 then return end

    -- in the unlikely event that no blobs were created, force
    -- the creation of one now

    for cx = 1, W, step_x do
    for cy = 1, H, step_y do
      if is_free(cx, cy) then
        total_blobs = total_blobs + 1
        set_cell(cx, cy, total_blobs)
        return
      end
    end
    end

    error("create_blobs: no usable cells")
  end


  local function growth_spurt_one()
    -- takes the single-cell blobs created by spawn_blobs() and
    -- expands them in several (or all) of the N/S/E/W directions
    -- to make L/T/+ shapes, or occasionally a 2x2 block of cells.

    for cx = 1, W do
    for cy = 1, H do
      local id = result[cx][cy]
      if not id then goto continue end

      if result.regions[id].size >= 2 then goto continue end

      if rand.odds(15) then
        local dx = rand.sel(50, -1, 1)
        local dy = rand.sel(50, -1, 1)

        try_set_cell(cx+dx, cy   , id)
        try_set_cell(cx   , cy+dy, id)
        try_set_cell(cx+dx, cy+dy, id)
        goto continue
      end

      local x_dir = rand.irange(-2, 2)
      local y_dir = rand.irange(-2, 2)

      if x_dir <=  1 then try_set_cell(cx-1, cy, id) end
      if x_dir >= -1 then try_set_cell(cx+1, cy, id) end

      if y_dir <=  1 then try_set_cell(cx, cy-1, id) end
      if y_dir >= -1 then try_set_cell(cx, cy+1, id) end
      ::continue::
    end
    end
  end


  local function try_grow_at_cell(cx, cy, dir)
    if not is_free(cx, cy) then return end

    local id = neighbor_blob(cx, cy, dir)
    if not id then return end

    if grow_dirs[id] ~= dir then return end

    if rand.odds(15) then return end

    set_cell(cx, cy, id)
  end


  local function directional_pass(dir)
    -- prevent run-on effects by iterating in the correct order
    if dir == 2 or dir == 4 then

      for cx = W, 1, -1 do
      for cy = H, 1, -1 do
        try_grow_at_cell(cx, cy, dir)
      end
      end

    else  -- dir == 6 or dir == 8,

      for cx = 1, W do
      for cy = 1, H do
        try_grow_at_cell(cx, cy, dir)
      end
      end
    end
  end


  local function check_all_done()
    for cx = 1, W do
    for cy = 1, H do
      if is_usable(cx, cy) and is_free(cx, cy) then
        return false
      end
    end
    end

    return true
  end


  local function normal_grow_pass()
    for i = 1, total_blobs do
      grow_dirs[i] = rand.dir()
    end

    for dir = 2,8,2 do
      directional_pass(dir)
    end
  end


  ---| create_blobs |---

  spawn_blobs()

  growth_spurt_one()

  local MAX_LOOP = 500

  for loop = 1, MAX_LOOP do
    normal_grow_pass()
    normal_grow_pass()
    normal_grow_pass()

    if check_all_done() then
      break;
    end

    if loop >= MAX_LOOP then
      error("blob creation failed!")
    end
  end

  return result
end


function GRID_CLASS.merge_two_blobs(grid, id1, id2)
  -- merges the second blob into the first one

  for cx = 1, grid.w do
  for cy = 1, grid.h do
    if grid[cx][cy] == id2 then
       grid[cx][cy] = id1
    end
  end
  end

  local reg1 = grid.regions[id1]
  local reg2 = grid.regions[id2]

  reg1.size = reg1.size + reg2.size
  reg2.size = -1

  reg1.is_walk = reg1.is_walk or reg2.is_walk

  grid.regions[id2] = nil
end


function GRID_CLASS.merge_small_blobs(grid, min_size)

  local allow_large


  local function candidate_to_merge(id)
    local best
    local best_cost = 9e9

    local seen = {}

    for cx = 1, grid.w do
    for cy = 1, grid.h do
      if grid[cx][cy] ~= id then goto continue end

      for dir = 2,8,2 do
        local nx, ny = geom.nudge(cx, cy, dir)

        local nb
        if grid:valid(nx, ny) then nb = grid[nx][ny] end

        if nb and nb ~= id and not seen[nb] and
           (allow_large or grid.regions[nb].size < min_size)
        then
          seen[nb] = true

          local cost = grid.regions[nb].size + gui.random() * 0.1

          if cost < best_cost then
            best = nb
            best_cost = cost
          end
        end
      end -- dir
      ::continue::
    end -- cx, cy
    end

    return best
  end


  local function merge_pass()
    -- need to copy the keys, since we modify the table as we go
    local id_list = table.keys(grid.regions)

    for _,id in pairs(id_list) do
      if grid.regions[id] and grid.regions[id].size < min_size then
        local nb = candidate_to_merge(id)

        if nb then
          grid:merge_two_blobs(id, nb)
        end
      end
    end
  end


  ---| merge_small_blobs |---

  for loop = 1, 8 do
    allow_large = (loop > 4)

    merge_pass()
  end
end


function GRID_CLASS.walkify_blobs(grid, walk_rects)
  --
  -- For each cell rectangle in the walk_rects list,
  -- merge any group of blobs that span that rectangle
  -- (so that afterwards, only a single blob spans it).
  --

  local function handle_rect(rect)
    local cur_blob

    for cx = rect.cx1, rect.cx2 do
    for cy = rect.cy1, rect.cy2 do
      local id = grid[cx][cy]

      -- walk rectangles should be covered by a floor
      assert(id)

      if cur_blob == nil then
         cur_blob = id
         goto continue
      end

      grid.regions[cur_blob].is_walk = true

      if cur_blob ~= id then
        grid:merge_two_blobs(cur_blob, id)
      end
      ::continue::
    end
    end
  end


  ---| walkify_blobs |---

  for _,rect in pairs(walk_rects) do
    handle_rect(rect)
  end
end


function GRID_CLASS.merge_diagonal_blobs(grid, diagonals)
  -- ensure half-cells are merged with the blob touching the
  -- corner away from the diagonal, otherwise the gap which
  -- could exist there may be too narrow for players to pass.

  for cx = 1, grid.w do
  for cy = 1, grid.h do
    local C = grid[cx][cy]
    if not C then goto continue end

    local dir = diagonals[cx][cy]
    if not dir then goto continue end

    local nx, ny = geom.nudge(cx, cy, dir)
    local ax, ay = geom.nudge(cx, cy, geom. LEFT_45[dir])
    local bx, by = geom.nudge(cx, cy, geom.RIGHT_45[dir])

    local N = grid:valid(nx, ny) and grid[nx][ny]

    -- check the cell directly opposite
    if N and N ~= C then
      grid:merge_two_blobs(C, N)
    end

    -- check the two neighbors (which touch both C and N)
    -- [ must grab these values AFTER the merge above ]
    local A = grid:valid(ax, ay) and grid[ax][ay]
    local B = grid:valid(bx, by) and grid[bx][by]

--  stderrf(": %s %s / %s %s\n", tostring(C), tostring(N), tostring(A), tostring(B))

    if not (A or B) then goto continue end

    if not A then A = B ; B = nil end

    if A and A == C then goto continue end
    if B and B == C then goto continue end

    if A and B then A = math.min(A, B) end

    grid:merge_two_blobs(C, A)
    ::continue::
  end
  end
end


function GRID_CLASS.extent_of_blobs(grid)
  -- determines bounding box for each blob

  for cx = 1, grid.w do
  for cy = 1, grid.h do
    local id = grid[cx][cy]

    if id == nil then goto continue end

    local reg = grid.regions[id]
    assert(reg)

    if not reg.cx1 then
      reg.cx1, reg.cy1 = cx, cy
      reg.cx2, reg.cy2 = cx, cy
    else
      reg.cx1 = math.min(reg.cx1, cx)
      reg.cy1 = math.min(reg.cy1, cy)
      reg.cx2 = math.max(reg.cx2, cx)
      reg.cy2 = math.max(reg.cy2, cy)
    end
    ::continue::
  end
  end
end


function GRID_CLASS.random_blob_cell(grid, id, req_four)
  -- when 'req_four' is true, require that all four sides of
  -- the cell are the same blob.

  -- NOTE: this can return nil

  local reg = grid.regions[id]
  assert(reg and reg.cx1)

  local best_cx
  local best_cy
  local best_score = 0

  for loop = 1, 20 do
    local cx = rand.irange(reg.cx1, reg.cx2)
    local cy = rand.irange(reg.cy1, reg.cy2)

    if grid[cx][cy] ~= id then goto continue end

    local score = gui.random()

    for dir = 2,8,2 do
      local nx, ny = geom.nudge(cx, cy, dir)
      if grid:valid(nx, ny) and grid[nx][ny] == id then
        score = score + 1
      elseif req_four then
        score = -1
        break;
      end
    end

    if not best_score or score > best_score then
      best_cx = cx
      best_cy = cy
      best_score = score
    end
    ::continue::
  end

  return best_cx, best_cy
end


function GRID_CLASS.neighbors_of_blobs(grid)
  for id, reg in pairs(grid.regions) do
    reg.neighbors = {}
  end

  for cx = 1, grid.w do
  for cy = 1, grid.h do
    local id = grid[cx][cy]

    if id == nil then goto continue end

    local reg1 = grid.regions[id]
    assert(reg1)

    for dir = 2,8,2 do
      local nx, ny = geom.nudge(cx, cy, dir)

      local nb
      if grid:valid(nx, ny) then nb = grid[nx][ny] end

      if not nb or nb == id then goto continue end

      local reg2 = grid.regions[nb]
      assert(reg2)

      table.add_unique(reg1.neighbors, reg2)
      table.add_unique(reg2.neighbors, reg1)
      ::continue::
    end
    ::continue::
  end
  end
end


function GRID_CLASS.spread_blob_dists(grid, field)
  -- spreads a distance value of the given field (e.g. "room_dist").
  -- these values are integers (representing # of blobs) and NOT
  -- true distances of any kind.

  local changes

  repeat
    changes = false

    for _,B1 in pairs(grid.regions) do
      -- compute minimum of neighbors
      local min_val

      for _,B2 in pairs(B1.neighbors) do
        if B2[field] and (not min_val or B2[field] < min_val) then
          min_val = B2[field]
        end
      end

      -- cannot do anything if all neighbors are unset
      if not min_val then goto continue end

      min_val = min_val + 1

      if not B1[field] or min_val < B1[field] then
        B1[field] = min_val
        changes   = true
      end
      ::continue::
    end

  until not changes
end


----------------------------------------------------------------
--  MAZE STUFF
----------------------------------------------------------------


function GRID_CLASS.maze_generate(maze)
  --
  -- Generates a maze in the current object.
  --
  -- The initial contents should form a map where the maze will be
  -- generated.  The cells next to walls should be set to 1 and
  -- areas which must remain clear (in front of doors) set to -1.
  --
  -- These values can be used:
  --
  --    nil : never touched
  --     -1 : forced off
  --      0 : computed normally
  --     +1 : forced on
  --
  -- Result elements can be: nil, -1 or +1.
  --

  local W = maze.w
  local H = maze.h


  local function valid_and_free(x, y)
    return maze:valid(x, y) and maze[x][y] == 0
  end


  local function how_far_can_move(x, y, dir)
    -- when start is in open space, require all neighbors to be open too
    if maze[x][y] == 0 then
      for side = 1,9 do
        local nx, ny = geom.nudge(x, y, side)
        if not valid_and_free(nx, ny) then return 0 end
      end
    end

    local len = 0

    while len < 5 do
      -- check the next spot is free, and also the cells on either side
      x, y = geom.nudge(x, y, dir)

      if not valid_and_free(x, y) then break; end

      local ax, ay = geom.nudge(x, y, geom.RIGHT[dir])
      local bx, by = geom.nudge(x, y, geom.LEFT [dir])

      if not valid_and_free(ax, ay) then break; end
      if not valid_and_free(bx, by) then break; end

      len = len + 1
    end

    -- don't touch the far wall
    len = len -1

    -- usually move two steps, occasionally more
    if len >= 3 and rand.odds(75) then len = 2 end
    if len >= 4 and rand.odds(95) then len = 3 end

    assert(len <= 4)

    return len
  end


  local function is_edge(x, y, dir)
    x, y = geom.nudge(x, y, 10-dir)

    if not maze:valid(x, y) then return true end

    if not maze[x][y] then return true end

    return false
  end


  local function pick_start()
    local middles = {}
    local edges   = {}

    for x = 1, W do
    for y = 1, H do
      if (maze[x][y] or 0) > 0 or
         (maze[x][y] == 0 and (table.empty(middles) or rand.odds(2)))
      then
        for dir = 2,8,2 do
          local len = how_far_can_move(x, y, dir)

          if len >= 2 then
            local SPOT = { x=x, y=y, dir=dir, len=len }

            if is_edge(x, y, dir) then
              table.insert(edges, SPOT)
            else
              table.insert(middles, SPOT)
            end
          end
        end
      end
    end -- x, y
    end

    -- we much prefer starting at an edge
    if #edges > 0 then
      return rand.pick(edges)
    end

    if #middles > 0 then
      return rand.pick(middles)
    end

    return nil
  end


  local function trace_next(p)
    maze[p.x][p.y] = 1

    for i = 1,p.len do
      p.x, p.y = geom.nudge(p.x, p.y, p.dir)

      maze[p.x][p.y] = 1
    end

    -- set how far we can move in each direction
    local lens = {}

    for dir = 2,8,2 do
      if dir ~= p.dir then
        local len = how_far_can_move(p.x, p.y, dir)

        if len > 0 then
          lens[dir] = len
        end
      end
    end

    -- nowhere else to go?
    if table.empty(lens) then return false end

    for loop = 1,20 do
      local dir = rand.dir()

      if dir == p.dir and rand.odds(60) then
        dir = 5  -- i.e. continue
      end

      if lens[dir] then
        p.dir = dir
        p.len = lens[dir]
        return true
      end
    end

    return false
  end


  local function tidy_up()
    for x = 1, W do
    for y = 1, H do
      if maze[x][y] == 0 then
         maze[x][y] = -1
      end
    end
    end
  end


  ---| maze_generate |---

  while true do
    -- choose starting spot for a wall run
    local pos = pick_start()

    -- stop if nothing is possible
    if not pos then break; end

    -- occasionally stop short, but usually go as far as possible
    local max_steps = rand.irange(3, 40)

    for loop = 1,max_steps do
      if not trace_next(pos) then break; end
    end
  end

  tidy_up()
end



function GRID_CLASS.maze_render(maze, brush_func, data)
  local W = maze.w
  local H = maze.h


  local function visit_cell(x, y)
    if (maze[x][y] or 0) <= 0 then return; end

    local bx = maze.base_x + (x - 1) * 64
    local by = maze.base_y + (y - 1) * 64

    -- most basic method (mostly for debugging)
    if true then
      brush_func(data,
      {
        { x=bx+64, y=by },
        { x=bx+64, y=by+64 },
        { x=bx,    y=by+64 },
        { x=bx,    y=by }
      })

      return
    end

    -- FIXME: better method, find "wall spans",
  end


  ---| maze_render |---

  for x = 1, W do
  for y = 1, H do
    visit_cell(x, y)
  end
  end
end



function Maze_test()
  local SIZE = 15

  for loop = 1,20 do
    local maze = GRID_CLASS.new(SIZE, SIZE)

    -- solid on outside, empty in middle
    maze:fill(1,1, SIZE,SIZE,     1)
    maze:fill(2,2, SIZE-1,SIZE-1, 0)

    -- doorways at top and bottom
    local d1 = rand.irange(2,SIZE-3)
    local d2 = rand.irange(2,SIZE-3)

    maze:fill(d1,1,      d1+2,3,    -1)
    maze:fill(d2,SIZE-2, d2+2,SIZE, -1)

    maze:maze_generate()

    gui.debugf("MAZE TEST %d\n\n", loop)

    maze:dump()
  end
end

