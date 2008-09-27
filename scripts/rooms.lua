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
    if R.outdoor then
      return false
    end

    if R.purpose then return false end

    if #R.teleports > 0 then return false end
    if R.num_branch < 2 then return false end
    if R.num_branch > 5 then return false end

    for _,C in ipairs(R.conns) do
      local N = sel(C.src == R, C.dest, C.src)
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
      local N = sel(C.src == R, C.dest, C.src)
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
      local N = sel(C.src == R, C.dest, C.src)
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
      local chance = 60
      if hallway_neighbours(R) > 0 then
        chance = 20
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
      for dx = 0, int((R.sw-1) / 2) do
        local L = SEEDS[R.sx1+dx][y][1]
        local R = SEEDS[R.sx2-dx][y][1]

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
      for dy = 0, int((R.sh-1) / 2) do
        local B = SEEDS[x][R.sy1+dy][1]
        local T = SEEDS[x][R.sy2-dy][1]

        B.y_peer = T
        T.y_peer = B
      end
    end
  end

  --| Rooms_setup_symmetry |--

  for _,R in ipairs(PLAN.all_rooms) do
    if R.symmetry then
      if R.symmetry == 4 then R.symmetry = 6 end
      if R.symmetry == 8 then R.symmetry = 2 end

      -- true four-way symmetry should be quite rare
      if R.symmetry == 5 and rand_odds(50) then
        R.symmetry = rand_sel(50, 2, 6)
      end

      if R.symmetry == 2 or R.symmetry == 5 then
        mirror_horizontally(R)
      end

      if R.symmetry == 6 or R.symmetry == 5 then
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

        local N = sel(C.src == R, C.dest, C.src)
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
    return 64 * (-1 + rand_index_by_probs { 5,1,6,1,4 })
  end

  local function rand_delta(h)
    if h < 0   then return 0 end
    if h > 256 then return 256 end

    while true do
      local d = (rand_index_by_probs { 2,1,8,1,2 } - 3) * 64
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
    local s_h = path[S].conn_h
    local e_h = path[E].conn_h

    assert(s_h and e_h)

    local diff = math.abs(s_h - e_h)

    -- for large stretches of unset floors, split them
    if (E-S+1) >= 5 then
      local P = int((S+E)/2)

      if math.min(s_h, e_h) > 160 then
        path[P].conn_h = rand_sel(50, 64, 0)
        return
      end 

      if math.max(s_h, e_h) < 96 then
        path[P].conn_h = rand_sel(50, 192, 256)
        return
      end 

      path[P].conn_h = rand_sel(50, 0, 256)
      return
    end

    -- mitigate a big change
    if (E-S+1) == 3 and diff > 160 then
      path[S+1].conn_h = s_h + sel(s_h < e_h, 128, -128)
      return
    end

    -- roughly iterpolate between S and E, in 64 chunks
    while (E-S+1) >= 3 do
      diff = math.abs(s_h - e_h)

      local bump = 0
      if diff >= 64 and rand_odds(75) then
        bump = 64
      end

      if rand_odds(50) then
        S = S + 1
        s_h = s_h + sel(s_h < e_h, bump, -bump)
        path[S].conn_h = s_h
      else
        E = E - 1
        e_h = e_h + sel(e_h < s_h, bump, -bump)
        path[E].conn_h = e_h
      end
    end
  end

  local function floor_along_path(target, path)
    local N = #path
    assert(N >= 1)

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

--[[
    repeat
      local S, E = find_stretch(list, 5)
      if S then
        gui.debugf("Splitting stretch %d..%d\n", S, E)
        path[int((S+E)/2)].conn_h = rand_height()
      end
    until not S
--]]

    -- fill all remaining gaps
    repeat
      local S, E = find_stretch(path, 1)
      if S then
        assert(S > 1 and E < N)
        poke_stretch(path, S-1, E+1)
      end
    until not S

    gui.debugf("After:\n"); dump_along(path, "> ")
    gui.debugf("\n")

  end

  local function try_flood_height(R)
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

    -- try to maintain symmetry
    --!!!!!!!! FIXME

    local is_small = math.min(R.sw, R.sh) <= 2

    assert(R.tallness)

    if max_h + R.tallness >= 512 then
      R.floor_h = min_h
    elseif (max_h - min_h) > 160 then
      R.floor_h = min_h + rand_sel(40, 128, 0)
    else
      R.floor_h = rand_sel(60, max_h, min_h)
    end

    R.ceil_h = R.floor_h + (R.tallness or 128)

    -- update unset connections
    for _,C in ipairs(R.conns) do
      if not C.conn_h then
        C.conn_h = R.floor_h
      end
    end
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
      local h = rand_irange(0,2) * 128
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

    -- go from smallest room to largest
    local list = {}

    for _,R in ipairs(PLAN.all_rooms) do
      if not R.floor_h then
        table.insert(list, R)
      end
    end

    if #list == 0 then
      break; -- all done
    end

    table.sort(list, function(A,B) return A.svol < B.svol end)

    for _,R in ipairs(list) do
      try_flood_height(R)
    end
  end 
end


function Rooms_fit_out()

  gui.printf("\n--==| Rooms_fit_out |==--\n\n")

  Rooms_decide_hallways()
  
  Rooms_setup_symmetry()

  Rooms_choose_heights()
end

