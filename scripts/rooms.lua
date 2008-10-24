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


ROOM HEIGHT NOTES
~~~~~~~~~~~~~~~~~

To determine room heights (floor_h and ceil_h), we iterate
through the level and visit each room in turn, starting at
the very first room.

Some rooms already have a fixed height, currently these are
all the outdoor rooms.

Each connection also has a height (conn_h).  These values
are computed after the floor_h on each side
have been determined, and will try to maintain any
symmetry in the room [two symmetrical exits need to have
the same conn_h].  We prefer the conn_h to be equal one of
the floors on each side, but it isn't compulsory.


--------------------------------------------------------------]]

require 'defs'
require 'util'


function Rooms_decide_hallways()
  -- Marks certain rooms to be hallways, using the following criteria:
  --   - indoor non-leaf room
  --   - prefer small rooms
  --   - all neighbors are indoor
  --   - no purpose (not a start room, exit room, key room)
  --   - no teleporters
  --   - not the destination of a locked door (anti-climactic)

  local HALL_SIZE_PROBS = { 99, 90, 70, 40, 10 }
  local REVERT_PROBS    = {  0,  0, 20, 70, 90 }

  local function eval_hallway(R)
    -- Wolf3D: the outdoor areas become hallways
    if CAPS.no_sky then
      return (R.outdoor and R.num_branch >= 2)
    end

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

      if C.dest == R and C.lock and rand_odds(40) then
        return false
      end
    end

    local rw = math.min(R.sw, R.sh)

    if rw > 5 then return false end

    return rand_odds(HALL_SIZE_PROBS[rw])
  end

  local function hallway_neighbors(R)
    local hall_nb = 0
    for _,C in ipairs(R.conns) do
      local N = C:neighbor(R)
      if N.kind == "hallway" then hall_nb = hall_nb + 1 end
    end

    return hall_nb
  end

  local function surrounded_by_halls(R)
    local hall_nb = hallway_neighbors(R)
    return (hall_nb == #R.conns) or (hall_nb >= 3)
  end

  local function stairwell_neighbors(R)
    local swell_nb = 0
    for _,C in ipairs(R.conns) do
      local N = C:neighbor(R)
      if N.kind == "stairwell" then swell_nb = swell_nb + 1 end
    end

    return swell_nb
  end

  local function locked_neighbors(R)
    local count = 0
    for _,C in ipairs(R.conns) do
      if C.lock then count = count + 1 end
    end

    return count
  end


  ---| Room_decide_hallways |---
  
  for _,R in ipairs(PLAN.all_rooms) do
    if eval_hallway(R) then
gui.debugf("  Made Hallway at (%d,%d)\n", R.lx1,R.ly1)
      R.kind = "hallway"
      R.outdoor = nil
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
       stairwell_neighbors(R) == 0 and
       locked_neighbors(R) == 0
    then
      if rand_odds(80) then
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

  local function mirror_rotation(R)
    -- NOTE: currently disabled, punted for a future release
    R.symmetry = nil

    --[[
    for x = R.sx1, R.sx2 do for y = R.sy1, R.sy1 + int(R.sh/2) do
      local nx = R.sx1 + R.sx2 - x
      local ny = R.sy1 + R.sy2 - y

      if (y ~= ny or x < nx) and x ~= nx then
        local B = SEEDS[x][y][1]
        local T = SEEDS[nx][ny][1]

        B.x_peer = T
        T.x_peer = B
      end
    end end
    --]]
  end

  local function mirror_transpose(R)
    -- NOTE: currently disabled, punted for a future release
    R.symmetry = nil

  --[[
    assert(R.sw == R.sh and R.sw >= 2)
    assert(#R.conns == 2)

    local XC = R.conns[1]
    local YC = R.conns[2]

    local X_dir = assert(XC:seed(R).conn_dir)
    local Y_dir = assert(YC:seed(R).conn_dir)

    assert(is_perpendicular(X_dir, Y_dir))

    if X_dir == 2 or X_dir == 8 then
      XC, YC = YC, XC
      X_dir,Y_dir = Y_dir,X_dir
    end

    -- FIXME: determine this when 'symmetry' field is set
    local positive = true
    if X_dir == 6 then positive = not positive end
    if Y_dir == 8 then positive = not positive end

    if positive then
      R.symmetry = "tp"
    else
      R.symmetry = "tn"
    end

gui.printf("XC %s dir:%d\n", XC:tostr(), X_dir)
gui.printf("YC %s dir:%d\n", YC:tostr(), Y_dir)
gui.printf("TRANSPOSE %s @ %s\n", R.symmetry, R:tostr())
    for a = 0,R.sw-1 do
      for b = 0,R.sw-2-a do
        local x1 = R.sx1 + a
        local y1 = sel(positive, R.sy2 - b, R.sy1 + b)

        local x2 = sel(positive, R.sx2 - b, R.sx1 + b)
        local y2 = R.sy1 + a

        local S1 = SEEDS[x1][y1][1]
        local S2 = SEEDS[x2][y2][1]

        S1.x_peer = S2
        S2.x_peer = S1
      end
    end
    --]]
  end


  --| Rooms_setup_symmetry |--

  for _,R in ipairs(PLAN.all_rooms) do
    if R.symmetry == "x" or R.symmetry == "xy" then
      mirror_horizontally(R)

    elseif R.symmetry == "y" or R.symmetry == "xy" then
      mirror_vertically(R)

    elseif R.symmetry == "r" then
      mirror_rotation(R)

    elseif R.symmetry == "t" then
      mirror_transpose(R)
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

  local function remove_symmetry(R, break_peer)
    gui.debugf("Symmetry broken in Room S(%d,%d) %s dir\n", R.sx1, R.sy1, break_peer)

    if R.symmetry == "xy" then
      R.symmetry = sel(break_peer == "x", "y", "x") 
    else
      R.symmetry = "none"
    end

    -- remove all peers (they are setup again later)
    for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
      local S = SEEDS[x][y][1]

      S.x_peer = nil
      S.y_peer = nil
    end end -- for x,y
  end

  --| Rooms_find_broken_symmetry |--
  
  for _,R in ipairs(PLAN.all_rooms) do
    -- need two passes to handle four-way symmetrical rooms
    for pass = 1,2 do
      local break_peer = broken_symmetry(R)
      if break_peer then
        remove_symmetry(R, break_peer)
      end
    end
  end

  Rooms_setup_symmetry()
end


function Rooms_choose_heights()

  local function rand_height()
    return 64 * (-1 + rand_index_by_probs { 3,1,4,1,2 })
  end

  local function set_outdoor_heights(R)
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
  end

  local function set_tallness(R)
    if R.kind == "hallway" or R.kind == "stairwell" then
      R.tallness = 128
      return
    end

    local approx_size = (2 * math.min(R.sw, R.sh) + math.max(R.sw, R.sh)) / 3.0
    local tallness = (approx_size + rand_range(-0.5,1.5)) * 64.0

    if tallness < 128 then tallness = 128 end
    if tallness > 480 then tallness = 480 end

    R.tallness = int(tallness / 32.0) * 32

    gui.debugf("Room %dx%d --> tallness %d\n", R.sw, R.sh, R.tallness)
  end

  local function set_max_floor_h(R)
    assert(not R.outdoor)

    -- for rooms close to sky, prevent ceiling from being higher than sky
    for x = R.sx1-2, R.sx2+2 do
      for y = R.sy1-2, R.sy2+2 do
        if not box_contains_point(R.sx1,R.sy1, R.sx2,R.sy2, x,y) and
           Seed_valid(x, y, 1)
        then
          local S = SEEDS[x][y][1]
          if S.room and (S.room.outdoor or S.room.kind == "liquid") then
            R.max_floor_h = math.max(0, 512 - R.tallness)
            return
          end
        end
      end
    end

    R.max_floor_h = 384
  end

  local function neighbors_min_max(R, backwards)
    local min_h =  9999
    local max_h = -9999

    for _,C in ipairs(R.conns) do
      local N = C:neighbor(R)
--    gui.debugf("  Neighbor floor_h:%s kind:%s\n", sel(N.floor_h, N.floor_h, "NONE"), N.kind)

      if N.floor_h and (backwards or C.src == R) then
        min_h = math.min(min_h, N.floor_h)
        max_h = math.max(max_h, N.floor_h)
      end
    end

    return min_h, max_h
  end

  local function determine_floor_h(R, last_hs, E)
    assert(#last_hs >= 1)

    -- get a feel for the general vertical momentum
    local z_mom = 0

    if last_hs[2] and last_hs[1] ~= last_hs[2] then
      z_mom = sel(last_hs[1] > last_hs[2], 1, -1)
    elseif last_hs[3] and last_hs[1] ~= last_hs[3] then
      z_mom = sel(last_hs[1] > last_hs[3], 1, -1)
    end

gui.debugf("Visiting room: S(%d,%d) kind:%s tallness:%d\n", R.sx1, R.sy1, R.kind, R.tallness)
hnums = ""
for _,H in ipairs(last_hs) do hnums = hnums .. tostring(int(H)) .. " "; end
gui.debugf("  Z_Mom: %d  Last heights: { %s}\n", z_mom, hnums)


    if R.kind == "hallway" and E and E.src.kind == "hallway" then
      R.floor_h = last_hs[1]
gui.debugf("HALL-CONN RESULT --> %d\n", R.floor_h)
      return
    end

    if R.kind == "stairwell" then
      R.floor_h = last_hs[1]
      E.conn_h  = last_hs[1]
gui.debugf("STAIRWELL RESULT --> %d\n", R.floor_h)
      return
    end

    -- TODO: bigger bump for 180 degree stairwells
    local avoid_h

    if E and E.src.kind == "stairwell" then
      avoid_h = last_hs[1]
    end


    local min_h, max_h = neighbors_min_max(R, false)

    if max_h < min_h then
      min_h = -64
      max_h = 320
    else
      while max_h - min_h >= 192 do
        if rand_odds(50) then min_h = min_h + 32 end
        if rand_odds(50) then max_h = max_h - 32 end
      end
    end

    if min_h >= R.max_floor_h then
      R.floor_h = R.max_floor_h

      if avoid_h and math.abs(R.floor_h - avoid_h) < 64 then
        R.floor_h = R.floor_h - 64
gui.debugf("SQUISH-AVOID RESULT --> %d\n", R.floor_h)
        return
      end
gui.debugf("SQUISH RESULT --> %d\n", R.floor_h)
      return
    end

    max_h = math.min(max_h, R.max_floor_h)

    -- increase min/max when the range is small
    while max_h - min_h <= 80 do
      if rand_odds(50) then min_h = min_h - 32 end
      if rand_odds(50) then max_h = max_h + 32 end
    end

    assert(min_h < max_h)


    if avoid_h and prefer_h and math.abs(avoid_h - prefer_h) <= 40 then
      prefer_h = nil
    end
 

    local new_min = last_hs[1] - 96
    local new_max = last_hs[1] + 96

    if new_min >= max_h then
      R.floor_h = max_h
gui.debugf("MAXED OUT RESULT --> %d\n", R.floor_h)
      return

    elseif new_max <= min_h then
      R.floor_h = min_h
gui.debugf("MINNED OUT RESULT --> %d\n", R.floor_h)
      return
    end

    min_h = math.max(min_h, new_min)
    max_h = math.min(max_h, new_max)

    assert(min_h <= max_h)


    local step_min = int((min_h + 31) / 32)
    local step_max = int((max_h     ) / 32)

    local steps = step_max - step_min + 1


    if steps <= 1 then
      R.floor_h = rand_sel(50, min_h, max_h)
gui.debugf("NO_STEP RESULT --> %d\n", R.floor_h)
      return
    end


    local probs = {}

    local best_avoid
    local bav_dist = 999

    local best_prefer
    local bpr_dist = 999

    for i = 1, steps do
      local h = (step_min + i - 1) * 32

      probs[i] = 90

      if avoid_h then
        local d = math.abs(avoid_h - h)
        if d < bav_dist then
          bav_dist = d
          best_avoid = i
        end

        if d < 64 then
          probs[i] = probs[i] / 4
        end
      end

      if prefer_h then
        local d = math.abs(prefer_h - h)
        if d < bpr_dist then
          bpr_dist = d
          best_prefer = i
        end
      end

      -- heavy penalty for change in vertical momentum
      local bump = h - last_hs[1]
      local bump_abs = math.abs(bump)
      local new_z_mom

      if bump_abs <= 40 then
        new_z_mom = 0

        if bump_abs > 1 then
          probs[i] = probs[i] / 5
        end
      else
        new_z_mom = sel(bump > 0, 1, -1)

        if (new_z_mom * z_mom) < 0 then
          probs[i] = 0.2
        end

        if bump_abs >= 64 then
          local factor = bump_abs / 64
          probs[i] = probs[i] / factor
        end
      end
    end

    if best_prefer then
      probs[best_prefer] = probs[best_prefer] * 3
    end

    if best_avoid then
      probs[best_avoid] = 0
    end

    local idx = rand_index_by_probs(probs)

    R.floor_h = (step_min + idx - 1) * 32

if avoid_h then
  gui.debugf("[Tried to avoid %d] RESULT\n", avoid_h)
end
gui.debugf("RAND RESULT --> %d\n", R.floor_h)
  end

  local function visit(R, last_hs, E)
    if not R.floor_h then
      determine_floor_h(R, last_hs, E)
    end

    if not R.ceil_h then
      R.ceil_h = R.floor_h + R.tallness
    end

    if E and E.src.kind == "stairwell" then
      E.conn_h = R.floor_h
    end

    table.insert(last_hs, 1, R.floor_h)

    for _,C in pairs(R.conns) do
      if C.src == R then
        visit(C.dest, last_hs, C)
      end
    end

    table.remove(last_hs, 1)
  end

  local function hallway_conns(R)
    for _,C in ipairs(R.conns) do
      C.conn_h = assert(R.floor_h)
    end
  end

  local function determine_conn_h(C)
    assert(C.src.floor_h)
    assert(C.dest.floor_h)

    local src_small  = (C.src.svolume < 8)
    local dest_small = (C.dest.svolume < 8)

    if not src_small and not dest_small and
       math.abs(C.src.floor_h - C.dest.floor_h) >= 192
    then
      local mid_h = (C.src.floor_h + C.dest.floor_h) / 2.0
      -- ensure it is a multiple of 32
      C.conn_h = int(mid_h / 32 + 0.5) * 32
      return
    end

    if src_small and not dest_small then
      C.conn_h = C.src.floor_h
    elseif dest_small and not src_small then
      C.conn_h = C.dest.floor_h
    else
      C.conn_h = rand_sel(50, C.src.floor_h, C.dest.floor_h)
    end
  end

  local function symmetrical_conn_h(R, C, S)

    local C_list = { C }

    XC = S.x_peer and S.x_peer.conn
    YC = S.y_peer and S.y_peer.conn

    local peer_h = (XC and XC.conn_h) or (YC and YC.conn_h)

    if peer_h then
      -- some connections are so bad that symmetry should be broken
      if math.abs(peer_h - R.floor_h) > (R.svolume * 6) then
        gui.debugf("symmetrical_conn_h: Broke symmetry @ S(%d,%d)\n", R.sx1,R.sy1)
        C.conn_h = R.floor_h
        return
      end
      
    gui.debugf("symmetrical_conn_h @ S(%d,%d) peer_h:%d floor_h:%d\n",
               R.sx1,R.sy1, peer_h, R.floor_h)

      C.conn_h = peer_h
      return
    end

    
    local h_list = {}

    table.insert(h_list, R.floor_h)
    table.insert(h_list, C:neighbor(R).floor_h)

    if XC then
      table.insert(h_list, XC:neighbor(R).floor_h)
    end
    if YC then
      table.insert(h_list, YC:neighbor(R).floor_h)
    end

    C.conn_h = R.floor_h
  end

  local function normal_conns(R)
    -- TODO: should we visit conns in certain order??

    for _,C in ipairs(R.conns) do
      if not C.conn_h then
        local S = C:seed(R)
        local T = C:seed(C:neighbor(R))

        if (S.x_peer and S.x_peer.conn) or
           (S.y_peer and S.y_peer.conn)
        then
          symmetrical_conn_h(R, C, S)

        elseif (T.x_peer and T.x_peer.conn) or
               (T.y_peer and T.y_peer.conn)
        then
          -- let other room (with symmetry) determine the height
        else
          determine_conn_h(C)
        end
      end
    end -- for C
  end


  ---| Rooms_choose_heights |---

  -- dummy heights for Wolf3d
  if CAPS.no_height then
    for _,R in ipairs(PLAN.all_rooms) do
      R.floor_h = 0
      R.ceil_h  = 128
    end
    for _,C in ipairs(PLAN.all_conns) do
      C.conn_h = 0
    end
  end

  -- handle non-room stuff (liquids)
  for x = 1,SEED_W do for y = 1,SEED_H do
    local S = SEEDS[x][y][1]
    if S.room and S.room.kind == "liquid" and not S.room.floor_h then
      S.room.floor_h = -40
      S.room.ceil_h  = 512
    end
  end end -- for x, y

  if CAPS.no_height then
    return
  end


  for _,R in ipairs(PLAN.all_rooms) do
    if R.outdoor or R.kind == "scenic" then
      set_outdoor_heights(R)
    else
      set_tallness(R)
      set_max_floor_h(R)
    end
  end


  -- MAIN ALGORITHM: iterate through level
  local last_hs = { rand_height() }

  visit(PLAN.start_room, last_hs)


  -- SECONDARY ALGORITHM: connections
  local big_rooms = copy_table(PLAN.all_rooms)

  table.sort(big_rooms,
      function(A,B)
        return (A.svolume + sel(A.symmetry, 200, 0)) >
               (B.svolume + sel(B.symmetry, 200, 0))
      end)

  for _,R in ipairs(PLAN.all_rooms) do
    if R.kind == "hallway" then
      hallway_conns(R)
    end
  end

  for _,R in ipairs(big_rooms) do
    if R.kind ~= "hallway" and R.kind ~= "stairwell" and
       R.kind ~= "scenic"
    then
      normal_conns(R)
    end
  end


  -- VALIDATION
  for _,R in ipairs(PLAN.all_rooms) do
    assert(R.floor_h)
  end

  for _,C in ipairs(PLAN.all_conns) do
    assert(C.conn_h)
  end
end


function Rooms_fit_out()

  gui.printf("\n--==| Rooms_fit_out |==--\n\n")

  Rooms_setup_symmetry()
  Rooms_decide_hallways()

  Rooms_choose_heights()
  Rooms_find_broken_symmetry()
end

