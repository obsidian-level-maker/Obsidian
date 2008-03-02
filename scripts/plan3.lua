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

  kind  : string  -- "neighbour" (the two rooms touch)
                  -- "contain"   (rooms[2] is inside rooms[1])
                  -- "teleport"

  connect : string  -- "view" (windows, railings)
                    -- "fall" (one-way, fall-off from [1] into [2])
                    -- "walk" (two-way, typically an arch or door)

  door : string  -- "arch", "door" etc..

  lock : string  -- optional, for keyed/switched doors
}


class ROOM
{
  links : table(RLINK) -- all connections with other rooms

  quest : Quest

  container_type : string  -- nil     : cannot contain rooms
                           -- "solid" : nothing is between rooms
                           -- "view"  : area between rooms is viewable
                           --           but not traversable
                           -- "walk"  : area between rooms is traversable

  s_low, s_high, s_size : Vector3  -- coverage over SEED map
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
    kind = "key", item = "k_yellow", level = 3,
  })

  table.insert(QUESTS,
  {
    kind = "exit", item = "normal", level = 4,
  })
end


function plan_rooms_sp()

  print("plan_rooms_sp...")

  
  local function find_spot_for_room(parent, R, conn_Q)
    --> RETURN: room we branched off from (when conn_Q ~= nil)

    for loop = 1,999 do

      local sx = parent.s_low.x + rand_irange(0, parent.s_size.x - R.s_size.x - 1);
      local sy = parent.s_low.y + rand_irange(0, parent.s_size.y - R.s_size.y - 1);
      local sz = parent.s_low.z + rand_irange(0, parent.s_size.z - R.s_size.z - 1);

      -- GEE WHIZ ....

    end

    error("find_spot_for_room: FAILED!")
  end


  local function add_room(parent, Q, conn_Q)

    local R =  -- new ROOM
    {
      links = {},
      quest = Q,
      s_low = {}, s_high = {}, s_size = {}
    }

    local RLINK =
    {
      rooms = { parent, R },
      kind  = "contain",
      connect = "walk",
    }

    table.insert(parent.links, RLINK);
    table.insert(R.links, RLINK)

    R.s_size.x = rand_irange(1,4)
    R.s_size.y = R.s_size.x
    R.s_size.z = 1

    if rand_odds(50) and parent.s_size.x > 7 and parent.s_size.y > 7
    then
      R.container_type = "walk"
      R.s_size.x = rand_irange(8, parent.s_size.x)
      R.s_size.y = rand_irange(8, parent.s_size.y)
    end

    local conn_R = find_spot_for_room(parent, R, conn_Q)

    if conn_Q then
      assert(conn_R);

      RLINK =
      {
        rooms = { conn_R, R },
        kind  = "neighbour",
        connect = "walk",
      }

      table.insert(conn_R.links, RLINK);
      table.insert(R.links, RLINK)
    end

    if R.container_type then
      add_room(R, Q, nil);
      add_room(R, Q, nil);
    end
  end


  ---===| plan_rooms_sp |===---


  temp_decide_quests()  -- FIXME: pass quest list as input to here
  
  
---###  -- make an initial room.  This is not explicitly the start room or
---###  -- the exit room, but will become some room along the first quest
---###  -- (and could become the start or exit room).

  -- create the ROOM which will contains the whole map

  local max_W = 30  -- TODO: base it on OB_CONFIG parameters
  local max_H = 30

  local head_room =
  {
    links = {},
--  quest = QUESTS[1],

    container_type = "solid",

    s_low  = { 1,     1,     1 },
    s_high = { max_W, max_H, 5 },
    s_size = { max_W, max_H, 5 },
  }


  -- start room
  add_room(head_room, QUESTS]1], nil)

  for i = 2,#QUESTS do
    add_room(head_room, QUESTS[i], QUESTS[i-1])
  end

  return head_room
end

