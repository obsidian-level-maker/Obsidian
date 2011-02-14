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
    return maze:valid(x, y) and map[x][y] == 0
  end


  local function how_far_start_spot(x, y, dir)
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
    end

    return len
  end


  local function pick_start()
    -- TODO: optimise this (how ?)

    local list = {}

    for x = 1,W do for y = 1,H do
      if (map[x][y] and 0) > 0 or 
         (map[x][y] == 0 and (table.empty(list) or rand.odds(2)))
      then
        for dir = 2,8,2 do
          local len = how_far_start_spot(x, y, dir)

          if len >= 2 then
            -- usually move two steps, occasionally more
            if len >= 4 and rand.odds(97) then len = len - 1 end
            if len >= 3 and rand.odds(90) then len = len - 1 end

            local SPOT = { x=x, y=y, dir=dir, len=len }

            table.insert(list, SPOT)

            -- FIXME: insert twice if on edge of room
          end
        end
      end
    end end

    if table.empty(list) then return nil; end
      
    return rand.pick(list)
  end


  local function trace_next(x, y, dir, len)
    for i = 1,len do
      x, y = geom.nudge(x, y, dir)

      map[x][y] = 1
    end

    -- TODO
  end


  ---| maze_generate |---

  while true do
    local x, y, dir, len = pick_start()

    -- stop if nothing is possible
    if not x then break; end

    repeat
      x, y, dir, len = trace_next(x, y, dir, len)
    until not x
  end
end



function CAVE_CLASS.maze_render()
  -- TODO
end

