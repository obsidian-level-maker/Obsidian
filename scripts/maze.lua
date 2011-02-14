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

  local function pick_start()
    -- TODO
  end


  local function trace_next(x, y, dir, len)
    for i = 1,len do
      x, y = geom.nudge(x, y, dir)

      maze.cells[x][y] = 1
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

