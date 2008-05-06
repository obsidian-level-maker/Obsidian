----------------------------------------------------------------
--  PLANNER : Single Player / Co-Op
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

class PLAN
{
  all_rooms : array(ROOM) 

  head_zone : ZONE
}


class ROOM
{
  sx1, sy1, sx2, sy2 : coverage over SEED map

  links : array(RLINK) -- all connections with other rooms

  parent : ZONE -- zone this room is directly contained in

  quest : QUEST
}


class ZONE extends ROOM
{
  zone_kind : string  -- "solid" : nothing is between rooms
                      -- "view"  : area between rooms is viewable
                      --           but not traversable
                      -- "walk"  : area between rooms is traversable

  children : array(ROOM)
}


class RLINK  -- Room Link
[
  rooms : array(ROOM) -- two entries for the linked rooms

  kind  : string  -- "nb"        (the two rooms touch)
                  -- "contain"   (rooms[2] is inside rooms[1])
                  -- "teleport"

  connect : string  -- "view" (windows, railings)
                    -- "fall" (one-way, fall-off from [1] into [2])
                    -- "walk" (two-way, typically an arch or door)

  door : string  -- "arch", "door" etc..

  lock : string  -- optional, for keyed/switched doors
}


--------------------------------------------------------------]]

require 'defs'
require 'util'
require 'seeds'


function Room_W(R)
  return R.sx2 - R.sx1 + 1
end

function Room_H(R)
  return R.sy2 - R.sy1 + 1
end

function Room_assign_seeds(R)
  for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
    SEEDS[x][y][1].room = R
  end end
end

function Room_create(parent, Q, conn_Q)

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


function populate_zone(ZN)
  assert(ZN)
  assert(ZN.zone_kind)

  local zone_W, zone_H = Room_W(ZN), Room_H(ZN)

  local num_subzones = 0
  local num_hubs = 0
  local num_normal = 0


  local function dump_div_map(div_map)
    
    local function div_content(x, y)
      local M = div_map[x][y]
      if not M then return "---" end
      if M.kind == "zone" then
        if M.zone.zone_kind == "walk" then
          return string.format("//%d", M.id % 10);
        elseif M.zone.zone_kind == "view" then
          return string.format("::%d", M.id % 10);
        elseif M.zone.zone_kind == "solid" then
          return string.format("##%d", M.id % 10);
        else
          return "Z??"
        end
      end
      if M.kind == "hub"  then return string.format("Hu%d", M.id % 10); end
      return string.format("R%02d", M.id)
    end

    for y = div_map.h,1,-1 do
      local line = ""

      for x = 1,div_map.w do
        line = line .. div_content(x, y) .. " "
      end

      con.printf("> %s\n", line)
    end

    con.printf("\n")
  end


  local function div_to_seed_range(R, div_map, x1,y1, x2,y2)
    
    R.sx1 = 1 + int((x1 - 1) * zone_W / div_map.w)
    R.sy1 = 1 + int((y1 - 1) * zone_H / div_map.h)

    R.sx2 = int(x2 * zone_W / div_map.w)
    R.sy2 = int(y2 * zone_H / div_map.h)

    assert(0 <= R.sx1 and R.sx1 <= R.sx2 and R.sx2 <= zone_W)
    assert(0 <= R.sy1 and R.sy1 <= R.sy2 and R.sy2 <= zone_H)
  end


  local function allocate_sub_zone(div_map, zone_id)

    -- find usable spot
    local x1,y1, x2,y2

    local function area_free(x1,y1, x2,y2)
      assert(1 <= x1 and x1 <= x2 and x2 <= div_map.w)
      assert(1 <= y1 and y1 <= y2 and y2 <= div_map.h)

      for x = x1,x2 do for y = y1,y2 do
        if div_map[x][y] then
          return false;
        end
      end end
      return true
    end

    local function touches_a_zone(x1,y1, x2,y2)
      for x = x1-1,x2+1 do for y = y1-1,y2+1 do
        if (x >= 1 and x <= div_map.w) and
           (y >= 1 and y <= div_map.h) and
           div_map[x][y] and
           div_map[x][y].kind == "zone"
        then
          return true;
        end
      end end
      return false
    end

    local function expand_zone(x, y)
      x1,y1 = x,y
      x2,y2 = x,y

      -- decide maximum size of zone
      local SIZE_MAP = { 1,1,2,3,3,4,5,5,6 }

      local max_w = SIZE_MAP[math.min(9,div_map.w)]
      local max_h = SIZE_MAP[math.min(9,div_map.h)]

--    con.printf("div_map %dx%d  prelim %dx%d  ", div_map.w, div_map.h, max_w, max_h)

      local REDUCE_MAP1 = { 0, 25, 33, 50 }
      local REDUCE_MAP2 = { 0,  0, 10, 20, 40 }

      if rand_odds(REDUCE_MAP1[math.min(4,max_w)]) then max_w = max_w - 1 end
      if rand_odds(REDUCE_MAP1[math.min(4,max_h)]) then max_h = max_h - 1 end

      if rand_odds(REDUCE_MAP2[math.min(5,max_w)]) then max_w = max_w - 1 end
      if rand_odds(REDUCE_MAP2[math.min(5,max_h)]) then max_h = max_h - 1 end

--    con.printf("final %dx%d\n", max_w, max_h)

      for loop = 1,20 do
        local dir = rand_irange(1,4) * 2

        local tx1,ty1 = x1,y1
        local tx2,ty2 = x2,y2

            if dir == 2 then ty1 = ty1 - 1
        elseif dir == 4 then tx1 = tx1 - 1
        elseif dir == 6 then tx2 = tx2 + 1
        elseif dir == 8 then ty2 = ty2 + 1
        end

        if (tx1 < 1 or ty1 < 1 or tx2 > div_map.w or ty2 > div_map.h) or
           (tx2 - tx1 + 1) > max_w or
           (ty2 - ty1 + 1) > max_h or
           not area_free(tx1,ty1, tx2,ty2) or
           touches_a_zone(tx1,ty1, tx2,ty2)
        then
          -- not valid, skip it
        else
          -- OK!
          x1,y1 = tx1,ty1
          x2,y2 = tx2,ty2
        end
      end -- for loop
    end

    for loop = 100,1,-1 do

      -- unable to find a spot
      if loop == 1 then return end

      local x = rand_irange(1, div_map.w)
      local y = rand_irange(1, div_map.h)

      if not div_map[x][y] and not touches_a_zone(x,y, x,y) then
        expand_zone(x, y)
        break;
      end
    end


    local Z_New =
    {
      -- FIXME: zone info

      parent_zone = ZN
    }

    div_to_seed_range(Z_New, div_map, x1,y1, x2,y2)

    repeat
      Z_New.zone_kind = rand_key_by_probs { walk=70, view=50, solid=15 }
    until Z_New.zone_kind ~= ZN.zone_kind

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
    if rand_odds(50) then return end

    div_map[xx][yy] = { kind="normal", id=yy*10+xx }

    num_normal = num_normal + 1

    --!!!!! FIXME: ACTUALLY CREATE THE ROOM
  end


  ---| populate_zone |---


  local space_W = rand_irange(6,10)
  local space_H = rand_irange(6,10)

  space_W = math.min(space_W, zone_W)
  space_H = math.min(space_H, zone_H)

  local div_W = int(zone_W / space_W)
  local div_H = int(zone_H / space_H)

  assert(div_W >= 1 and div_H >= 1)

  local div_map = array_2D(div_W, div_H)

  -- add sub-zones
  local max_SUBZONE = int((div_W + div_H + 1) / 2) - 1

  for i = 1,max_SUBZONE do
    if rand_odds(50) then
      local Z2 = allocate_sub_zone(div_map, i)
    end
  end

  -- add hubs
  if div_W == 1 and div_H == 1 then
    local HUB_chance = (space_W + space_H - 10) * 6
    if rand_odds(HUB_chance) then
      allocate_hub(div_map, 1)
    end
  else
    for i = 1,math.max(div_W, div_H) do
      if rand_odds(50) then
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

  if true then --- not ZN.parent_zone then
    dump_div_map(div_map)
  end

end


function Plan_rooms_sp()


  ---===| Plan_rooms_sp |===---

  print("EXPERIMENTAL Plan_rooms_sp")


  local map_size = 32   -- FIXME: depends on GAME and LEVEL_SIZE_SETTING

  Seed_init(map_size, map_size, 1)

  PLAN =
  {
    all_rooms = {},

    head_zone = 
    {
      zone_kind = "solid",

      children = {},

      sx1 = 1, sx2 = map_size,
      sy1 = 1, sy2 = map_size,

      links = {},
    }
  }

  populate_zone(PLAN.head_zone)

  -- !!!!!! FIXME grow everything until all is good

end

