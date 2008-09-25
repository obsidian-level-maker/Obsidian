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
  --   - MIN(w,h) == 1 (sometimes 2)
  --   - all neighbours are indoor
  --   - no purpose (not a start room, exit room, key room)
  --   - no teleporters
  --   - not the destination of a locked door

  local HALL_SIZE_PROBS = { 99, 75, 50, 25 }
  local REVERT_PROBS    = {  0, 50, 84, 99 }

  local function eval_hallway(R)
    if (R.kind ~= "indoor") then
      return false
    end

    if R.purpose then return false end

    if #R.teleports > 0 then return false end
    if R.num_branch < 2 then return false end
    if R.num_branch > 5 then return false end

    for _,C in ipairs(R.conns) do
      local N = sel(C.src == R, C.dest, C.src)
      if (N.kind ~= "indoor") then
        return false
      end

      if C.dest == R and C.lock then
        return false
      end
    end

    local rw = math.min(R.sw, R.sh)

    if rw > 4 then return false end

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
      assert(rw <= 4)

      if rand_odds(REVERT_PROBS[rw]) then
        R.kind = "indoor"
gui.debugf("Reverted HALLWAY @ (%d,%d)\n", R.lx1,R.ly1)
      end
    end
  end

  -- decide stairwells
  for _,R in ipairs(PLAN.all_rooms) do
    if R.kind == "hallway" and R.num_branch == 2 and
       #R.teleports == 0 and hallway_neighbours(R) <= 1  -- FIXME: hall_nb = chance modifier
       and stairwell_neighbours(R) == 0
       and rand_odds(90)
    then
      R.kind = "stairwell"
    end
  end
end


--##function OLD_rooms_select_heights()
--##
--##  local function spread(everything)
--##    local changed = false
--##
--##    for _,C in ipairs(PLAN.all_conns) do
--##      if C.lock or C.dest.kind == "hallway" or everything then
--##        if C.src.floor_h and not C.dest.floor_h then
--##          C.dest.floor_h = C.src.floor_h
--##          changed = true
--##        elseif C.dest.floor_h and not C.src.floor_h then
--##          C.src.floor_h = C.dest.floor_h
--##          changed = true
--##        end
--##      end
--##    end
--##
--##    return changed
--##  end
--##
--##  local function dump_along(list, prefix)
--##    for idx,L in ipairs(list) do
--##      gui.debugf("%sfloor_along_path: %d/%d = %s\n", prefix,
--##                 idx, #list, L.h or "UNSET")
--##    end
--##  end
--##
--##  local function find_stretch(list, min_num)
--##    local S, E
--##
--##    for idx = 1,#list do
--##      if list[idx].h then
--##        if S and (E - S + 1) >= min_num then
--##          return S, E
--##        end
--##        S = nil; E = nil
--##      else
--##        if not S then S = idx end
--##        E = idx
--##      end
--##    end
--##
--##    if S and (E - S + 1) >= min_num then
--##      return S, E
--##    end
--##
--##    return nil, nil
--##  end
--##
--##  local function rand_height()
--##    return 64 * (-1 + rand_index_by_probs { 5,1,6,1,4 })
--##  end
--##
--##  local function in_between(h1, h2)
--##    --!!!! FIXME : TEMP CRUD
--##    return int((h1 + h2) / 2)
--##  end
--##
--##  local function floor_along_path(target, path)
--##    local list = {}
--##
--##    for _,C in ipairs(path) do
--##      table.insert(list, { room = C.src })
--##    end
--##
--##    table.insert(list, { room = target })
--##
--##    local N = #list
--##
--##    for idx,L in ipairs(list) do
--##      if L.room.floor_h then
--##        L.h = L.room.floor_h
--##      end
--##    end
--##
--##    gui.debugf("Before:\n"); dump_along(list, "  ")
--##
--##    -- start
--##    if not list[1].h then
--##      if list[2] and list[2].h then
--##        list[1].h = list[2].h
--##      else
--##        list[1].h = rand_height()
--##      end
--##    end
--##
--##    -- target
--##    if not list[N].h then
--##      if list[N-1] and list[N-1].h then
--##        list[N].h = list[N-1].h
--##      else
--##        list[N].h = rand_height()
--##      end
--##    end
--##
--##    -- for large stretches of unset floors, split them
--##    repeat
--##      local S, E = find_stretch(list, 5)
--##      if S then
--##        gui.debugf("Splitting stretch %d..%d\n", S, E)
--##        list[int((S+E)/2)].h = rand_height()
--##      end
--##    until not S
--##
--##    -- fill all remaining gaps
--##    repeat
--##      local S, E = find_stretch(list, 1)
--##      if S then
--##        assert(S > 1 and E < N)
--##        
--##        --FIXME !!!! TERRIBLE
--##        local new_h = in_between(list[S-1].h, list[E+1].h)
--##        for idx = S, E do
--##          list[idx].h = new_h
--##        end
--##      end
--##    until not S
--##
--##---###    for idx = 2,N-1 do
--##---###      if not list[idx].h and list[idx-1].h and list[idx+1].h then
--##---###        list[idx].h = in_between(list[idx-1].h, list[idx+1].h)
--##---###      end
--##---###    end
--##
--##    gui.debugf("After:\n"); dump_along(list, "> ")
--##    gui.debugf("\n")
--##
--##    for _,L in ipairs(list) do
--##      L.room.floor_h = L.h
--##    end
--##  end
--##
--##
--##  ---| OLD_ooms_select_heights |---
--##
--##  -- handle non-room stuff (liquids)
--##  for x = 1,SEED_W do for y = 1,SEED_H do
--##    local S = SEEDS[x][y][1]
--##    if S.room and S.room.kind == "liquid" and not S.room.floor_h then
--##      S.room.floor_h = -40
--##      S.room.ceil_h  = 512
--##    end
--##  end end -- x, y
--##
--##  -- handle outdoor rooms
--##  for _,R in ipairs(PLAN.all_rooms) do
--##    if R.kind == "valley" then
--##      R.floor_h = 0
--##      R.ceil_h  = 512
--##    elseif R.kind == "ground" then
--##      R.floor_h = 128
--##      R.ceil_h  = 512
--##    elseif R.kind == "hill" then
--##      R.floor_h = 256
--##      R.ceil_h  = 512
--##    end
--##
--##    for _,C in ipairs(R.conns) do
--##      if (R == C.src) and (C.dest.kind == "indoor") then
--##        C.dest.floor_h = R.floor_h
--##      end
--##    end
--##  end
--##
--##  for _,A in ipairs(PLAN.all_arenas) do
--##    spread()
--##    floor_along_path(A.target, A.path)
--##  end
--##
--##  while spread() do end
--##  
--##  --!!!!!! TEMP CRUD
--##  for _,R in ipairs(PLAN.all_rooms) do
--##    if not R.floor_h then
--##      R.floor_h = 128
--##    end
--##    if not R.ceil_h then
--##      R.ceil_h  = math.min(512-32, R.floor_h + sel(R.hallway, 96, 256))
--##    end
--##  end
--##
--##  -- update seeds
--##  for x = 1,SEED_W do for y = 1,SEED_H do
--##    local S = SEEDS[x][y][1]
--##    if S.room then
--##      assert(S.room.floor_h)
--##      S.floor_h = S.room.floor_h
--##      S.ceil_h  = S.room.ceil_h
--##    end
--##  end end -- x, y
--##end


function Rooms_choose_heights()

--##  local function flood_connections()
--##    for _,C in ipairs(PLAN.all_conns) do
--##      if C.src_h and not C.dest_h then
--##        C.dest_h = C.src_h
--##      elseif C.dest_h and not C.src_h then
--##        C.src_h = C.dest_h
--##      end
--##    end
--##  end

  local function spread_hallway_height(R, seen_conns, h)
    assert(not R.floor_h)

    R.floor_h = h

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
      other_h += 128
    elseif other_h > 128 then
      other_h -= 128
    else
      other_h = sel(rand_odds(50), 0, 256)
    end

    if not A.conn_h then
      A.conn_h = other_h
    else
      B.conn_h = other_h
    end

    R.floor_h = math.min(A.conn_h, B.conn_h)
  end

  local function do_special_room(R)
    assert(not R.floor_h)

    -- keep it simple : flat

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
    end
  end

  -- handle start and exit rooms
  -- (this ensures that at least two rooms have heights which
  --  can flood into the rest of the map)
  -- FIXME for teleporters [a room per separate area]
  do_special_room(PLAN.start_room)
  do_special_room(PLAN.exit_room)

  -- final phase: flood heights into unset rooms
  -- We visit rooms in order of sizes (smallest first) to
  -- ensure that small rooms don't have too many different
  -- heights.

  for loop = 1,99 do
    local rooms = {}

    for _,R in ipairs(PLAN.all_rooms) do
      if not R.floor_h then
        table.insert(rooms, R)
      end
    end

    if #rooms == 0 then break; end

    table.sort(rooms, function(A, B) return A.lvol < B.lvol end)

    for _,R in ipairs(rooms) do
      -- !!!!!! FIXME
      R.floor_h = 1
    end
  end 
end


function Rooms_fit_out()

  gui.printf("\n--==| Rooms_fit_out |==--\n\n")

  Rooms_decide_hallways()

  Rooms_choose_heights()
end

