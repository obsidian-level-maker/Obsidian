----------------------------------------------------------------
-- PLANNER 3
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

require 'defs'
require 'util'


--[[ CLASS INFORMATION
----------------------

class RLINK  -- Room Link
[
  rooms : table(ROOM)  -- table has two entries ]1] and [2]

  type  : string  -- "neighbour" (the two rooms touch)
                  -- "contain"   (rooms[2] is inside rooms[1])
                  -- "teleport"

  connect : string  -- "view" (windows, railings)
                    -- "fall" (one-way, typically fall-offs)
                    -- "walk" (two-way, typically an arch or door)

  door : string  -- "arch", "door" etc..

  lock : string  -- optional, for keyed/switched doors
}


class ROOM
{
  links : table(RLINK) -- all connections with other rooms

  quest : Quest

  is_big : true  -- can contain other rooms

  s_low, s_high, s_size : Vector3  -- coordinates within SEED map
}


class QUEST     -- FIXME: probably doesn't belong here
{
  kind : string  -- "key" | "exit"
  item : string  -- name of key (etc)

  level : integer  -- increases for each main quest
}

--]]


function temp_decide_quests()

  QUESTS = { }

  table.insert(QUESTS,
  {
    kind = "key", item = "k_red", level = 1,
  })

  table.insert(QUESTS,
  {
    kind = "key", item = "k_blue", level = 2,
  })

  table.insert(QUESTS,
  {
    kind = "exit", item = "normal", level = 3,
  })
end


function plan_rooms_sp()

  print("plan_rooms_sp...")

  temp_decide_quests()  -- FIXME: pass quest list as input to here
  
  
  -- make an initial room.  This is not explicitly the start room or
  -- the exit room, but will become some room along the first quest
  -- (and could become the start or exit room).

  ROOMS = {}

  local initial_R =
  {
    links = {}, quest = QUESTS[1]

    -- no seed allocation yet
  }

  table.insert(ROOMS, initial_R)

  if rand_odds(80) then
    enlarge_room(initial_R)
  end

end

