----------------------------------------------------------------
--  AMAZING MAZES
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2011 Andrew Apted
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


function CAVE_CLASS.maze_generate(maze)

  -- Generates a maze in the current object.
  --
  -- The initial contents should form a mao where the maze will
  -- be generated.  The cells next to walls should be set to 1,
  -- and areas which must remain clear (in front of doors) set to -1.
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

  local map = maze.cells


  local function valid_and_free(x, y)
    return maze:valid_cell(x, y) and map[x][y] == 0
  end


  local function how_far_can_move(x, y, dir)
    -- when start is in open space, require all neighbors to be open too
    if map[x][y] == 0 then
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

    if not maze:valid_cell(x, y) then return true end

    if not map[x][y] then return true end

    return false
  end


  local function pick_start()
    -- TODO: optimise this (how ?)

    local middles = {}
    local edges   = {}

    for x = 1,W do for y = 1,H do
      if (map[x][y] or 0) > 0 or 
         (map[x][y] == 0 and (table.empty(middles) or rand.odds(2)))
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
    end end

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
    map[p.x][p.y] = 1

    for i = 1,p.len do
      p.x, p.y = geom.nudge(p.x, p.y, p.dir)

      map[p.x][p.y] = 1
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
    for x = 1,W do for y = 1,H do
      if map[x][y] == 0 then
         map[x][y] = -1
      end
    end end
  end


  ---| maze_generate |---

  while true do
    local pos = pick_start()

    -- stop if nothing is possible
    if not pos then break; end

    -- sometimes stop short, but usually go until cannot continue
    local max_steps = rand.irange(3, 40)

    for loop = 1,max_steps do
      if not trace_next(pos) then break; end
    end
  end

  tidy_up()
end



function CAVE_CLASS.maze_render()
  -- TODO
end



function Maze_test()
  local SIZE = 15

  for loop = 1,20 do
    local maze = CAVE_CLASS.new(SIZE, SIZE)

    -- solid on outside, empty in middle
    maze:fill( 1, 1,1, SIZE,SIZE)
    maze:fill( 0, 2,2, SIZE-1,SIZE-1)

    -- doorways at top and bottom
    local d1 = rand.irange(2,SIZE-3)
    local d2 = rand.irange(2,SIZE-3)

    maze:fill(-1, d1,1,      d1+2,3)
    maze:fill(-1, d2,SIZE-2, d2+2,SIZE)

    maze:maze_generate()

    gui.debugf("MAZE TEST %d\n\n", loop)

    maze:dump()
  end
end

