----------------------------------------------------------------
--  ROOMS : FIT OUT
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

class ROOM
{
}


--------------------------------------------------------------]]

require 'defs'
require 'util'


function Rooms_decide_hallways()
  -- Marks certain rooms to be hallways, using the following criteria:
  --   - indoor non-leaf room
  --   - prefer small rooms
  --   - all neighbours are indoor
  --   - no purpose (not a start room, exit room, key room)
  --   - no teleporters
  --   - not the destination of a locked door (anti-climactic)

  local HALL_SIZE_PROBS = { 99, 90, 75, 50,  2 }
  local REVERT_PROBS    = {  0, 10, 45, 75, 99 }

  local function eval_hallway(R)
    if R.outdoor or R.kind == "scenic" then
      return false
    end

    if R.purpose then return false end

    if #R.teleports > 0 then return false end
    if R.num_branch < 2 then return false end
    if R.num_branch > 5 then return false end

    for _,C in ipairs(R.conns) do
      local N = C:neighbor(R)
      if N.outdoor then
        return false
      end

      if C.dest == R and C.lock and rand_odds(80) then
        return false
      end
    end

    local rw = math.min(R.sw, R.sh)

    if rw > 5 then return false end

    return rand_odds(HALL_SIZE_PROBS[rw])
  end

  local function hallway_neighbours(R)
    local hall_nb = 0
    for _,C in ipairs(R.conns) do
      local N = C:neighbor(R)
      if N.kind == "hallway" then hall_nb = hall_nb + 1 end
    end

    return hall_nb
  end

  local function surrounded_by_halls(R)
    local hall_nb = hallway_neighbours(R)
    return (hall_nb == #R.conns) or (hall_nb >= 3)
  end

  local function stairwell_neighbours(R)
    local swell_nb = 0
    for _,C in ipairs(R.conns) do
      local N = C:neighbor(R)
      if N.kind == "stairwell" then swell_nb = swell_nb + 1 end
    end

    return swell_nb
  end


  ---| Room_decide_hallways |---
  
  for _,R in ipairs(PLAN.all_rooms) do
    if eval_hallway(R) then
gui.debugf("  Made Hallway at (%d,%d)\n", R.lx1,R.ly1)
      R.kind = "hallway"
    end
  end

  -- large rooms which are surrounded by hallways are wasted,
  -- hence look for them and revert them back to normal.
  for _,R in ipairs(PLAN.all_rooms) do
    if R.kind == "hallway" and surrounded_by_halls(R) then
      local rw = math.min(R.sw, R.sh)
      assert(rw <= 5)

      if rand_odds(REVERT_PROBS[rw]) then
        R.kind = "indoor"
gui.debugf("Reverted HALLWAY @ (%d,%d)\n", R.lx1,R.ly1)
      end
    end
  end

  -- decide stairwells
  for _,R in ipairs(PLAN.all_rooms) do
    if R.kind == "hallway" and R.num_branch == 2 and
       stairwell_neighbours(R) == 0
    then
      local chance = 70
      if hallway_neighbours(R) > 0 then
        chance = 30
      end

      if rand_odds(chance) then
        R.kind = "stairwell"
      end
    end
  end -- for R
end


function Rooms_setup_symmetry()

  local function mirror_horizontally(R)
    if R.sw < 2 then
      -- room is too narrow
      R.symmetry = nil
      return
    end

    for y = R.sy1, R.sy2 do
      for dx = 0, int((R.sw-2) / 2) do
        local L = SEEDS[R.sx1 + dx][y][1]
        local R = SEEDS[R.sx2 - dx][y][1]

        L.x_peer = R
        R.x_peer = L
      end
    end
  end

  local function mirror_vertically(R)
    if R.sh < 2 then
      -- room is not deep enough
      R.symmetry = nil
      return
    end

    for x = R.sx1, R.sx2 do
      for dy = 0, int((R.sh-2) / 2) do
        local B = SEEDS[x][R.sy1 + dy][1]
        local T = SEEDS[x][R.sy2 - dy][1]

        B.y_peer = T
        T.y_peer = B
      end
    end
  end

  --| Rooms_setup_symmetry |--

  for _,R in ipairs(PLAN.all_rooms) do
    if R.symmetry then
      if R.symmetry == 6 then R.symmetry = 4 end
      if R.symmetry == 8 then R.symmetry = 2 end

--      -- true four-way symmetry should be rare
--      if R.symmetry == 5 and rand_odds(50) then
--        R.symmetry = rand_sel(50, 2, 4)
--      end

      if R.symmetry == 2 or R.symmetry == 5 then
        mirror_horizontally(R)
      end

      if R.symmetry == 4 or R.symmetry == 5 then
        mirror_vertically(R)
      end
    end
  end
end


function UPDATE_SEEDS(R) --!!!!
  -- update seeds
  for x = 1,SEED_W do for y = 1,SEED_H do
    local S = SEEDS[x][y][1]
    if S.room then
      assert(S.room.floor_h)
      S.floor_h = S.room.floor_h
      S.ceil_h  = S.room.ceil_h
    end
  end end -- x, y
end


function Rooms_choose_heights()

  local function spread_hallway_height(R, seen_conns, h)
    assert(not R.floor_h)

    R.floor_h = h
    R.ceil_h  = h + 128

    for _,C in ipairs(R.conns) do
      if not seen_conns[C] then
        seen_conns[C] = true

        C.conn_h = h

        local N = C:neighbor(R)
        if N.kind == "hallway" then
          spread_hallway_height(N, seen_conns, h)
        end
      end
    end
  end

  local function do_stairwell(R)
    local A = R.conns[1]
    local B = R.conns[2]

    assert(A and B)

    if A.conn_h and B.conn_h then
      -- nothing to do [should not happen]
      R.floor_h = math.min(A.conn_h, B.conn_h)
      return
    end

    local other_h = A.conn_h or B.conn_h

    if not other_h then
      -- purely random source and dest

      A.conn_h = rand_irange(0,1) * 128
      B.conn_h = A.conn_h + 128

      if rand_odds(50) then
        A.conn_h, B.conn_h = B.conn_h, A.conn_h
      end

      R.floor_h = math.min(A.conn_h, B.conn_h)
      return
    end

    if other_h < 128 then
      other_h = other_h + 128
    elseif other_h > 128 then
      other_h = other_h - 128
    else
      other_h = rand_sel(50, 0, 256)
    end

    if not A.conn_h then
      A.conn_h = other_h
    else
      B.conn_h = other_h
    end

    R.floor_h = math.min(A.conn_h, B.conn_h)
  end

--[[
  local function do_special_room(R)
    assert(not R.floor_h)

    for _,C in ipairs(R.conns) do
      if C.conn_h then
        R.floor_h = C.conn_h
      end
    end

    if not R.floor_h then
      R.floor_h = rand_irange(0,2) * 128
    end

    for _,C in ipairs(R.conns) do
      if not C.conn_h then
        C.conn_h = R.floor_h
      end
    end
  end
--]]

  local function dump_along(list, prefix)
    for idx,C in ipairs(list) do
      gui.debugf("%sfloor_along_path: %d/%d = %s\n", prefix,
                 idx, #list, C.conn_h or "UNSET")
    end
  end

  local function rand_height()
    return 64 * (-1 + rand_index_by_probs { 5,1,6,1,3 })
  end

  local function rand_delta(h)
    if h < 0   then return 0 end
    if h > 256 then return 256 end

    while true do
      local d = (rand_index_by_probs { 2,1,8,1,1 } - 3) * 64
      if (h+d) >= 0 and (h+d) <= 256 then
        return h+d
      end
    end
  end

  local function find_stretch(list, min_num)
    local S, E

    for idx = 1,#list do
      if list[idx].conn_h then
        if S and (E - S + 1) >= min_num then
          return S, E
        end
        S = nil; E = nil
      else
        if not S then S = idx end
        E = idx
      end
    end

    if S and (E - S + 1) >= min_num then
      return S, E
    end

    return nil, nil
  end


  local function poke_stretch(path, S, E)
    local s_h = path[S-1].conn_h
    local e_h = path[E+1].conn_h

    assert(s_h and e_h)

    -- small gap with large height difference
--[[ ?????
    if (E-S+1) >= 3 and math.abs(s_h - e_h) > 160 then
      local P = int((S+E)/2)
      
      path[P].conn_h = int((s_h + e_h) / 2)
      return
    end
--]]

    -- very large gap of unset floors, split them
    if (E-S+1) >= 5 then
      local P = int((S+E)/2)

      path[P].conn_h = (rand_index_by_probs({7,3,1,7,3}) - 1) * 64
      return

    end
    
---### assert((E-S+1) <= 2)

    while S <= E do
      if s_h == e_h then
        path[S].conn_h = s_h
        S = S + 1

      -- try and maintain symmetry
      elseif (path[S-1].dest_S.x_peer == path[S].src_S) or
             (path[S-1].dest_S.y_peer == path[S].src_S)
      then
        path[S].conn_h = s_h
        S = S + 1

      elseif (path[E].dest_S.x_peer == path[E+1].src_S) or
             (path[E].dest_S.y_peer == path[E+1].src_S)
      then
        path[E].conn_h = e_h
        E = E - 1

      -- choose common height for pair
      elseif (E-S+1) == 2 and math.min(s_h - e_h) > 100 and rand_odds(90) then

        path[S].conn_h = int((s_h + e_h) / 2)
        path[E].conn_h = path[S].conn_h
        break;

      elseif (E-S+1) == 1 and math.min(s_h - e_h) > 100 and rand_odds(90) then

        path[S].conn_h = int((s_h + e_h) / 2)
        break;

      elseif rand_odds(50) then
        path[S].conn_h = s_h
        S = S + 1

      else
        path[E].conn_h = e_h
        E = E - 1

      end -- if
    end -- while
  end

  local function floor_along_path(target, path)
    local N = #path
    
    if (N == 0) then return end

    gui.debugf("Before:\n"); dump_along(path, "  ")

    -- start
    if not path[1].conn_h then
      if path[2] and path[2].conn_h then
        path[1].conn_h = rand_delta(path[2].conn_h)
      else
        path[1].conn_h = rand_height()
      end
    end

    -- target
    if not path[N].conn_h then
      if path[N-1] and path[N-1].conn_h then
        path[N].conn_h = rand_delta(path[N-1].conn_h)
      else
        path[N].conn_h = rand_height()
      end
    end

    -- fill all remaining gaps
    repeat
      local S, E = find_stretch(path, 1)
      if S then
        assert(S > 1 and E < N)
        poke_stretch(path, S, E)
      end
    until not S

    gui.debugf("After:\n"); dump_along(path, "> ")
    gui.debugf("\n")

  end

  local function flood_room_conns(R)
    -- assign unset conn_h for the room

    for _,C in ipairs(R.conns) do
      local S = C:seed(R)

      -- try to preserve symmetry
      if not C.conn_h then
        C.conn_h = S.x_peer and S.x_peer.conn and S.x_peer.conn.conn_h
      end
      if not C.conn_h then
        C.conn_h = S.y_peer and S.y_peer.conn and S.y_peer.conn.conn_h
      end
      if not C.conn_h then
        C.conn_h = rand_delta(R.floor_h)
      end
    end
  end

  local function get_absolute_max_h(R)
    assert(not R.outdoor)

    -- for rooms close to sky, prevent ceiling from being higher than sky
    for x = R.sx1-2, R.sx2+2 do
      for y = R.sy1-2, R.sy2+2 do
        if not box_contains_point(R.sx1,R.sy1, R.sx2,R.sy2, x,y) and
           Seed_valid(x, y, 1)
        then
          local S = SEEDS[x][y][1]
          if S.room and (S.room.outdoor or S.room.kind == "liquid") then
            return math.max(0, 512 - R.tallness)
          end
        end
      end
    end

    return 256
  end

  local function try_flood_height(R)
    assert(R.tallness)
    assert(R.kind ~= "hallway")

    if #R.conns == 0 then  -- UGH!
      R.floor_h = rand_height()
      R.ceil_h  = R.floor_h + 256
      return
    end

    local min_h =  999
    local max_h = -999

    for _,C in ipairs(R.conns) do
      if C.conn_h then
        min_h = math.min(min_h, C.conn_h)
        max_h = math.max(max_h, C.conn_h)
      end
    end

    -- no connections have been set?
    if min_h > max_h then
      return -- try again later!
    end

    local absolute_max_h = get_absolute_max_h(R)

    -- if room connects to stairwell, use that as floor_h
    for _,C in ipairs(R.conns) do
      local N = C:neighbor(R)
      if N.kind == "stairwell" then
        R.floor_h = math.min(absolute_max_h, C.conn_h)
        if R.floor_h < C.conn_h then
          C.conn_h = R.floor_h
        end
      end
    end

    -- if room is destination of locked door, try that height
    if not R.floor_h then
      for _,C in ipairs(R.conns) do
        if C.lock and C.conn_h then
          R.floor_h = C.conn_h
        end
      end
    end

    local is_small = math.min(R.sw, R.sh) <= 2

    if not R.floor_h and is_small then
      R.floor_h = rand_sel(70, min_h, max_h)
    end

    if not R.floor_h then
      local probs = {}

      for i = 1,5 do
        local h = (i-1)*64
        probs[i] = 1
        if h > absolute_max_h then
          -- no change
        elseif h == min_h then
          probs[i] = 70
        elseif h == max_h then
          probs[i] = 30
        elseif h > min_h and h < max_h then
          probs[i] = sel(i==3, 70, 30)
        end
      end

      R.floor_h = (rand_index_by_probs(probs) - 1) * 64
    end

    if R.floor_h > absolute_max_h then
       R.floor_h = absolute_max_h
    end

    R.ceil_h = R.floor_h + R.tallness

    flood_room_conns(R)
  end


  ---| Rooms_choose_heights |---
  
  -- handle non-room stuff (liquids)
  for x = 1,SEED_W do for y = 1,SEED_H do
    local S = SEEDS[x][y][1]
    if S.room and S.room.kind == "liquid" and not S.room.floor_h then
      S.room.floor_h = -40
      S.room.ceil_h  = 512
    end
  end end -- for x, y

  -- handle outdoor rooms
  for _,R in ipairs(PLAN.all_rooms) do
    if R.kind == "valley" then
      R.floor_h = 0
      R.ceil_h  = 512
    elseif R.kind == "ground" then
      R.floor_h = 128
      R.ceil_h  = 512
    elseif R.kind == "hill" then
      R.floor_h = 256
      R.ceil_h  = 512
    elseif R.kind == "scenic" then
      R.floor_h = 128
      R.ceil_h  = 256
    end

    if R.floor_h then
      for _,C in ipairs(R.conns) do
        if not C.conn_h then
          C.conn_h = R.floor_h
        end
      end
    end
  end -- for R

  -- decide tallness of indoor rooms
  for _,R in ipairs(PLAN.all_rooms) do
    if R.kind == "indoor" then
      local approx_size = (2 * math.min(R.sw, R.sh) + math.max(R.sw, R.sh)) / 3.0
      local tallness = (approx_size + rand_range(-0.5,1.5)) * 64.0

      R.tallness = int(tallness / 32.0) * 32

      if R.tallness < 128 then R.tallness = 128 end
      if R.tallness > 480 then R.tallness = 480 end

      gui.debugf("Room %dx%d --> tallness %d\n", R.sw, R.sh, R.tallness)
    end
  end -- for R

  -- handle hallway groups
  for _,R in ipairs(PLAN.all_rooms) do
    if R.kind == "hallway" and not R.floor_h then
      local h = (rand_index_by_probs({4,2,6,2,1}) - 1) * 64
      spread_hallway_height(R, {}, h)
    end
  end

  -- handle stairwells
  for _,R in ipairs(PLAN.all_rooms) do
    if R.kind == "stairwell" then
      do_stairwell(R)
      R.ceil_h = R.floor_h + 128
    end
  end

  -- MAIN ALGORITHM
  -- decide heights along the main path in each area.
  -- we want to avoid up/down/up/down silliness.
  for _,A in ipairs(PLAN.all_arenas) do
    floor_along_path(A.target, A.path)
  end


--[[
  -- handle start and exit rooms
  -- (this ensures that at least two rooms have heights which
  --  can flood into the rest of the map)
  -- FIXME for teleporters [a room per separate area]
  do_special_room(PLAN.start_room)
  do_special_room(PLAN.exit_room)
--]]


  -- handle all remaining rooms [side quests]
  -- Also sets floor_h for rooms along main path

  for loop = 1,99 do
    local changed = false

    -- go from biggest room to smallest
    local list = {}

    for _,R in ipairs(PLAN.all_rooms) do
      if not R.floor_h then
        table.insert(list, R)
      end
    end

gui.debugf("Rooms_choose_heights: LOOP %d, UNSET %d\n", loop, #list)
    if #list == 0 then
      break; -- all done
    end

    table.sort(list,
      function(A,B)
        return (A.svol + (A.symmetry or 0) * 200) >
               (B.svol + (B.symmetry or 0) * 200)
      end)

    for _,R in ipairs(list) do
      try_flood_height(R)
    end
  end 
end


function Rooms_find_broken_symmetry()
  -- after the heights have been assigned (to rooms and
  -- connections), sometimes the symmetry in a room becomes
  -- broken because two opposite exits get different heights.
  -- This cannot be totally avoided.
  --
  -- Here we find the broken symmetry and remove it [since
  -- it's probably not possible to build rooms that are
  -- only partially symmetrical].

  local function broken_symmetry(R)
    if not R.symmetry then return nil end

    for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
      local S = SEEDS[x][y][1]
      local T = S.x_peer
      local V = S.y_peer

      if S.conn then
        if T and not T.conn then return "x" end
        if V and not V.conn then return "y" end

        if T and (S.conn.conn_h ~= T.conn.conn_h) then return "x" end
        if V and (S.conn.conn_h ~= V.conn.conn_h) then return "y" end
      end
    end end -- for x,y
  end

  local function remove_symmetry(R, break_dir)
    gui.debugf("Symmetry broken in Room S(%d,%d) %s dir\n", R.sx1, R.sy1, break_dir)

    if R.symmetry == 5 then
      R.symmetry = sel(break_dir == "x", 2, 4) 
    else
      R.symmetry = nil
    end

    for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
      local S = SEEDS[x][y][1]

      if break_dir == "x" then S.x_peer = nil end
      if break_dir == "y" then S.y_peer = nil end
    end end -- for x,y
  end

  --| Rooms_find_broken_symmetry |--
  
  for _,R in ipairs(PLAN.all_rooms) do
    -- need two passes to handle four-way symmetrical rooms
    for pass = 1,2 do
      local break_dir = broken_symmetry(R)
      if break_dir then
        remove_symmetry(R, break_dir)
      end
    end
  end
end


function Rooms_fit_out()

  gui.printf("\n--==| Rooms_fit_out |==--\n\n")

  Rooms_decide_hallways()
  Rooms_setup_symmetry()
  Rooms_choose_heights()
  Rooms_find_broken_symmetry()
end

