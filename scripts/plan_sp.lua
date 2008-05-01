----------------------------------------------------------------
-- PLANNER 4
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
require 'seeds'


--[[ CLASS INFORMATION
----------------------

class RLINK  -- Room Link
[
  rooms : table(ROOM)  -- table has two entries [1] and [2]

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

  zone_type : string  -- nil     : cannot contain rooms (not a Zone)
                      -- "solid" : nothing is between rooms
                      -- "view"  : area between rooms is viewable
                      --           but not traversable
                      -- "walk"  : area between rooms is traversable

  quest : Quest

  s1, s2 : Vector3  -- coverage over SEED map
}


--]]


MAP = {}


function show_room_allocation(R)
  
  print("room_allocation", R.s_size.y, "by", R.s_size.x, ":-")

  for y = R.s_size.y, 1, -1 do

    local line = ""

    for x = 1, R.s_size.x do

      local N = SEED_MAP[R.s_low.x + x - 1][R.s_low.y + y - 1]

      if not N then
        line = line .. "."

      elseif not N.quest then
        line = line .. "?"

      else
        line = line .. N.quest.level
      end
    end

    print(">", line)
  end
end


function plan_rooms_sp_0()

  print("plan_rooms_sp...")


  
  local function spot_is_free(x,y,z, w,h,t)
 
    for xx = x,x+w-1 do
      for yy = y,y+h-1 do
        if SEED_MAP[xx][yy] then
          return false;
        end
      end
    end

    return true;
  end

  local function assign_spot(x,y,z, w,h,t, room)
    assert(room)
    for xx = x,x+w-1 do
      for yy = y,y+h-1 do
        if not SEED_MAP[xx][yy] then
          SEED_MAP[xx][yy] = room
        end
      end
    end
  end

  local function find_spot_for_room(parent, R, conn_Q)
    --> RETURN: room we branched off from (when conn_Q ~= nil)

    -- FIXME !!!  does not find rooms connected to previous quest (conn_Q)

    local w = R.s_size.x
    local h = R.s_size.y
    local t = R.s_size.z

    for loop = 1,9999 do

      local sx = parent.s_low.x + rand_irange(0, parent.s_size.x - w);
      local sy = parent.s_low.y + rand_irange(0, parent.s_size.y - h);
      local sz = parent.s_low.z + rand_irange(0, parent.s_size.z - t);

      if spot_is_free(sx,sy,sz, w,h,t) then

        R.s_low  = { x=sx, y=sy, z=sz }
        R.s_high = { x=sx+w-1, y=sy+h-1, z=sz+t-1 }
        R.s_size = { x=w, y=h, z=t }

        return nil
      end
print("spot not free!", string.format("(%d %d %d)", sx, sy, sz),
       string.format("(%d %d %d)", w, h, t))
    end

show_room_allocation(parent);
    error("find_spot_for_room: FAILED! " .. w .. "x" .. h)
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

    if rand_odds(70) and parent.s_size.x >= 12 and parent.s_size.y >= 12
    then
      R.container_type = "walk"
      R.s_size.x = rand_irange(6, int(parent.s_size.x/2))
      R.s_size.y = rand_irange(6, int(parent.s_size.y/2))
    end

    local conn_R = find_spot_for_room(parent, R, conn_Q)

    if false then  --- FIXME  if conn_Q then
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

    assign_spot(R.s_low.x, R.s_low.y, R.s_low.z,
                R.s_size.x, R.s_size.y, R.s_size.z, R)
      
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

    s_low  = { x=1,     y=1,     z=1 },
    s_high = { x=max_W, y=max_H, z=5 },
    s_size = { x=max_W, y=max_H, z=5 },
  }


  -- start room
  add_room(head_room, QUESTS[1], nil)

  for i = 2,#QUESTS do
    add_room(head_room, QUESTS[i], QUESTS[i-1])
  end

  show_room_allocation(head_room)

  return head_room
end



----------------------------------------------------------------

function print_zone(Z)

  print("zone:", Z.grid.w, "by", Z.grid.h)


  local function zone_content(ZZ, x, y)
    
    local R = ZZ.grid[x][y]

    local C1 = " "
    if ZZ.zone_type == "walk" then
      C1 = "/"
    elseif ZZ.zone_type == "view" then
      C1 = "="
    end
    
    local C2 = C1

    if R then
      if R.zone_type then
        return zone_content(R, x - R.gx + 1, y - R.gy + 1)
      end

      C2 = tostring(R.quest.level)
    end

    return C1 .. C2
  end


  for y = Z.grid.h, 1, -1 do
    local line = ""

    for x = 1, Z.grid.w do
      line = line .. zone_content(Z, x, y) .. " "
    end

    print("> " .. line)
--  print("------")
  end
end


function populate_zone(Z)
  assert(Z)
  assert(Z.zone_type)
end


function Plan_rooms_sp()


  function create_zone(parent, Q)

    local min_W = 3 -- int(parent.grid.w * 4 / 10)
    local min_H = 3 -- int(parent.grid.h * 4 / 10)

    local max_W = int(parent.grid.w * 7 / 10)
    local max_H = int(parent.grid.h * 7 / 10)

    local W = rand_irange(min_W, max_W)
    local H = rand_irange(min_H, max_H)

    local dir = rand_element { 1,2,3,4, 6,7,8,9 }

    local x = 1
    local y = 1
    
    if dir == 2 or dir == 5 or dir == 8 then
      x = 1 + int((parent.grid.w - W) / 2)
    elseif dir == 3 or dir == 6 or dir == 9 then
      x = 1 + parent.grid.w - W
    end

    if dir == 4 or dir == 5 or dir == 6 then
      y = 1 + int((parent.grid.h - W) / 2)
    elseif dir == 7 or dir == 8 or dir == 9 then
      y = 1 + parent.grid.h - H
    end

    local Z =
    {
      parent = parent,
      quest  = Q,

      zone_type = sel(parent.zone_type == "walk", "view", "walk"),

      gx = x, gy = y,  -- index into parent's grid

      grid = array_2D(W, H)
    }

    for xx = x, x+W-1 do
      for yy = y, y+H-1 do
        parent.grid[xx][yy] = Z
      end
    end

    table.insert(ALL_ROOMS, Z)

    return Z
  end


  local function create_room(parent, Q)

    if rand_odds(50) and parent.grid.w > 5 and parent.grid.h >= 5 then
      Z = create_zone(parent, Q)

      return create_room(Z, Q)
    end

    local R =
    {
      parent = parent,
      quest  = Q,

      gx = rand_irange(1, parent.grid.w),
      gy = rand_irange(1, parent.grid.h),
    }

    R.parent.grid[R.gx][R.gy] = R

    table.insert(ALL_ROOMS, R)

    return R
  end




  ---===| plan_rooms_sp |===---

  print("EXPERIMENTAL plan_rooms_sp")



  local map_size = 32   -- FIXME: depends on GAME

  MAP =
  {
    seeds = array_2D(map_size, map_size), -- FIXME: Z dimension!!

    rooms = {},

    top_zone = 
    {
      zone_type = "solid",

      s1 = { 1,1,1 },
      s2 = { map_size,map_size,1 },
    }
  }

  populate_zone(MAP.top_zone)

end

