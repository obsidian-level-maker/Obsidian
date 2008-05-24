----------------------------------------------------------------
--  QUEST ASSIGNMENT
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2008 Andrew Apted
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

--[[ *** CLASS INFORMATION ***

class Quest
{
}

--------------------------------------------------------------]]

require 'defs'
require 'util'


function Quest_assign()

  -- FIXME proper Quest_assign() function

  -- make a random room the start room (TEMP CRUD)

  con.printf("\n--==| Quest_assign |==--\n\n")


  local sx, sy

  repeat
    sx = rand_irange(1, SEED_W)
    sy = rand_irange(1, SEED_H)
  until SEEDS[sx][sy][1].room


--[[ older method

  local start_R

  repeat
    start_R = rand_element(PLAN.all_rooms)
  until not start_R.zone_kind

  start_R.is_start = true

  local sx, sy

  repeat
    sx = rand_irange(start_R.sx1, start_R.sx2)
    sy = rand_irange(start_R.sy1, start_R.sy2)
  until SEEDS[sx][sy][1].room == start_R

--]]
  SEEDS[sx][sy][1].is_start = true

  con.printf("Start seed @ (%d,%d)\n", sx, sy)

end

