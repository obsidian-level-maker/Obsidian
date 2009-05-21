----------------------------------------------------------------
--  TILE-BASED LAYOUTER
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2009 Andrew Apted
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


function Tiler_tester()
  for x = 1,64 do for y = 1,64 do

    local wall = 108
    if x <= 4 or x >= 61 or y <= 4 or y >= 61 then
      wall = 18
    end

    local thing = 0
    if x == 8 and y == 8 then thing = 19 end
    if x == 12 and y == 12 then thing = 24 end

    gui.wolf_block(x, y, 1, wall)
    gui.wolf_block(x, y, 2, thing)
  end end
end


