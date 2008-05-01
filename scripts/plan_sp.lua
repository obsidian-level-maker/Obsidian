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

  parent_zone : ROOM

  quest : QUEST

  s1, s2 : Vector3  -- coverage over SEED map
}


--]]


function Room_W(R)
  return R.s2.x - R.s1.x + 1
end

function Room_H(R)
  return R.s2.y - R.s1.y + 1
end



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


function populate_zone(ZN)
  assert(ZN)
  assert(ZN.zone_type)

  local num_subzones = 0
  local num_hubs = 0
  local num_normal = 0


  local function dump_div_map(div_map)
    
    local function div_content(x, y)
      local M = div_map[x][y]
      if not M then return "---" end
      if M.kind == "zone" then
        if M.zone.zone_type == "walk" then
          return string.format("//%d", M.id % 10);
        elseif M.zone.zone_type == "view" then
          return string.format("::%d", M.id % 10);
        elseif M.zone.zone_type == "solid" then
          return string.format("##%d", M.id % 10);
        else
          return "Z??"
        end
      end
      if M.kind == "hub"  then return string.format("H%02d", M.id); end
      return string.format("R%02d", M.id) end
    end

    for y = div_map.h,1,-1 do
      local line = ""

      for x = 1,div_map.w do
        line = line .. div_content(x, y) .. " "
      end

      con.printf("> " .. line)
    end
  end


  local function allocate_sub_zone(div_map, zone_id)

    -- find usable spot
    local x1,y1, x2,y2

    local function touches_a_zone(x, y)
      for dx = -1,1 do for dy = -1,1 do
        if not (dx==0 and dy==0) and
           (x+dx >= 1 && x+dx <= div_map.w) and
           (y+dy >= 1 && y+dy <= div_map.h) and
           div_map[x][y] and
           div_map[x][y].kind == "zone"
        then
          return true;
        end
      end end
      return false
    end

    for loop = 100,1,-1 do

      -- unable to find a spot
      if loop == 1 then return end

      local x = rand_irange(1, div_map.w)
      local y = rand_irange(1, div_map.h)

      if not div_map[x][y] and not touches_a_zone(x,y) then

        x1,y1, x2,y2 = x,y, x,y

        -- FIXME!!!  try to expand

        break;
      end
    end


    local Z_New =
    {
      -- FIXME: zone info

      parent_zone = ZN
    }

    repeat
      Z_New.zone_type = rand_key_by_probs { walk=70, view=50, solid=15 }
    until Z_New.zone_type ~= ZN.zone_type

    --!!!!! FIXME: PLACE THE ROOM IN SEED MAP

    for xx = x1,x2 do for yy = y1,y2 do
      div_map[xx][yy] = { kind="zone", id=zone_id, zone=Z_New }
    end end

    num_subzones = num_subzones + 1

    -- recursively populate it
    populate_zone(Z_New)
  end


  local function allocate_hub(div_map, hub_id)

    local hub_list = {}

    for axis2 = 1,math.min(div_map.w, div_map.h) do

      local xx, yy
      if div_map.w >= div_map.h then
        xx, yy = hub_id, axis2
      else
        xx, yy = axis2, hub_id
      end

      if not div_map[xx][yy] then
        local H = { kind="hub", id=hub_id, x=xx, y=yy }
        table.insert(hub_list, H)
      end
    end

    if #hub_list == 0 then return end

    local H = rand_element(hub_list)

    div_map[H.x][H.y] = H

    num_hubs = num_hubs + 1

    --!!!!! FIXME: ACTUALLY CREATE THE ROOM
  end


  local function allocate_normal(div_map, xx, yy)
    -- something already there?
    if div_map[xx][yy] then return end

    -- don't fill every spot
    if rand_odds(30) then return end

    div_map[xx][yy] = { kind="normal", id=yy*10+xx }

    num_normal = num_normal + 1

    --!!!!! FIXME: ACTUALLY CREATE THE ROOM
  end


  ---| populate_zone |---


  local W, H = Room_W(ZN), Room_H(ZN)

  local space_W = rand_irange(6,10)
  local space_H = rand_irange(6,10)

  space_W = math.min(space_W, W)
  space_H = math.min(space_H, H)

  local div_W = int(W / space_W)
  local div_H = int(H / space_H)

  assert(div_W >= 1 and div_H >= 1)

  local div_map = array_2D(div_W, div_H)

  -- add sub-zones
  local max_SUBZONE = int((div_W + div_H + 1) / 2)

  for i = 2,max_SUBZONE do
    if rand_odds(50) then
      local Z2 = allocate_sub_zone(div_map, i)
    end
  end

  -- add hubs
  if div_W == 1 and div_H == 1 then
    local HUB_chance = (space_W + space_H - 10) * 6
    if rand_odds(HUB_chance) then
      allocate_hub(div_map, i)
    end
  else
    for i = 1,math.max(div_W, div_H) do
      if rand_odds(60) then
        allocate_hub(div_map, i)
      end
    end
  end -- div_W == 1

  -- add normal rooms
  repeat
    for xx = 1,div_W do for yy = 1,div_H do
      allocate_normal(div_map, xx, yy)
    end end  
  until (num_hubs + num_normal) > 0


  -- !!!! FIXME grow everything until all is good

  if not ZN.parent_zone then
    dump_div_map(div_map)
  end
end


function Plan_rooms_sp()


--[[
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
--]]

  ---===| plan_rooms_sp |===---

  print("EXPERIMENTAL plan_rooms_sp")


  local map_size = 32   -- FIXME: depends on GAME and LEVEL_SIZE_SETTING

  Seed_init(1, map_size, map_size)

  PLAN =
  {
    rooms = {},

    top_zone = 
    {
      zone_type = "solid",

      s1 = { 1, 1, 1 },
      s2 = { 1, map_size, map_size },
    }
  }

  populate_zone(MAP.top_zone)

end

