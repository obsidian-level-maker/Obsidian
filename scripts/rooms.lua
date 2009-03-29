----------------------------------------------------------------
--  Room Management
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2009 Andrew Apted
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
  kind : keyword  -- "building", "hallway", "stairwell",
                  -- "smallexit", "ground", "scenic"

  outdoor : bool  -- true for outdoor rooms

  conns : array(CONN)  -- connections with neighbor rooms
  entry_conn : CONN

  branch_kind : keyword

  symmetry : keyword   -- symmetry of room, or NIL
                       -- keywords are "x", "y", "xy"

  sx1, sy1, sx2, sy2  -- \ Seed range
  sw, sh, svolume     -- /

  floor_h, ceil_h : number

  purpose : keyword   -- usually NIL, can be "EXIT" etc... (FIXME)

  arena : ARENA


  --- plan_sp code only:

  lx1, ly1, lx2, ly2  -- coverage on the Land Map

  group_id : number  -- traversibility group

}


----------------------------------------------------------------


Room Layouting Notes
====================


DIAGONALS:
   How they work:

   1. basic model: seed is a liquid or walk area which has an
      extra piece stuck in it (the diagonal) which is
      either totally solid or same as a neighbouring higher floor.
      We first build the extra bit, then convert the seed to what
      it should be (change S.kind from "diagonal" --> "liquid" or "walk")
      and build the ceiling/floor normally.

   2. The '/' and '%' in patterns go horizontally, whereas
      the 'Z' and 'N' go vertically.  If the pattern is
      transposed then we exchange '/' with 'Z', '%' with 'N'.

   3. once the room is fully laid out, then we can process
      these diagonals and determine the main seed info
      (e.g. liquid) and the Stuckie piece (e.g. void).


--------------------------------------------------------------]]


require 'defs'
require 'util'



function Rooms_decide_outdoors()
  local function choose(R)
    if R.parent and R.parent.outdoor then return false end
    if R.parent then return rand_odds(5) end

--[[ DISABLED -- KEYS/SWITCHES NOT DECIDED YET
    -- preference for KEY locked doors to have at least one
    -- indoor room on one side.  50% on each side --> 75% that
    -- one of the sides will be indoor.
    if R:has_lock_kind("KEY") and rand_odds(50) then
      return false
    end
--]]

    if R:has_any_lock() and rand_odds(20) then return false end

    if R.children then
      if STYLE.skies == "few" then
        return rand_odds(33)
      else
        return rand_odds(80)
      end
    end

    if STYLE.skies == "heaps" then return rand_odds(50) end
    if STYLE.skies == "few"   then return rand_odds(5) end

    -- room on edge of map?
    if R.sx1 <= 2 or R.sy1 <= 2 or R.sx2 >= SEED_W-1 or R.sy2 >= SEED_H-1 then
      return rand_odds(30)
    end

    return rand_odds(10)
  end

  ---| Rooms_decide_outdoors |---

  for _,R in ipairs(PLAN.all_rooms) do
    if R.outdoor == nil then
      R.outdoor = choose(R)
    end
    if R.outdoor and R.kind == "building" then
      R.kind = "ground"
    end
  end
end


function Room_setup_theme(R)
 
  if not PLAN.outdoor_combos then
    PLAN.outdoor_combos = {}

    for num = 1,2 do
      local name = rand_key_by_probs(PLAN.theme.ground)
      PLAN.outdoor_combos[num] = assert(GAME.combos[name]) 
    end
  end

  if not PLAN.indoor_combos then
    PLAN.indoor_combos = {}

    for num = 1,3 do
      local name = rand_key_by_probs(PLAN.theme.building)
      PLAN.indoor_combos[num] = assert(GAME.combos[name]) 
    end
  end


  if R.outdoor then
    R.combo = rand_element(PLAN.outdoor_combos)
  else
    R.combo = rand_element(PLAN.indoor_combos)
  end
end

function Room_setup_theme_Scenic(R)
  R.outdoor = true
---###  R.kind = "scenic"

  --[[

  -- find closest non-scenic room
  local mx = int((R.sx1 + R.sx2) / 2)
  local my = int((R.sy1 + R.sy2) / 2)

  for dist = -SEED_W,SEED_W do
    if Seed_valid(mx + dist, my, 1) then
      local S = SEEDS[mx + dist][my][1]
      if S.room and S.room.kind ~= "scenic" and
         S.room.combo
---      and (not S.room.outdoor) == (not R.outdoor)
      then
        R.combo = S.room.combo
        -- R.outdoor = S.room.outdoor
        return
      end
    end

    if Seed_valid(mx, my + dist, 1) then
      local S = SEEDS[mx][my + dist][1]
      if S.room and S.room.kind ~= "scenic" and
         S.room.combo
---      and (not S.room.outdoor) == (not R.outdoor)
      then
        R.combo = S.room.combo
        R.outdoor = S.room.outdoor
        return
      end
    end
  end

  --]]

  -- fallback
  if R.outdoor then
    R.combo = rand_element(PLAN.outdoor_combos)
  else
    R.combo = rand_element(PLAN.indoor_combos)
  end
end

function Rooms_choose_themes()
  for _,R in ipairs(PLAN.all_rooms) do
    Room_setup_theme(R)
  end
  for _,R in ipairs(PLAN.scenic_rooms) do
    Room_setup_theme_Scenic(R)
  end
end


function Rooms_decide_hallways_II()
  -- Marks certain rooms to be hallways, using the following criteria:
  --   - indoor non-leaf room
  --   - prefer small rooms
  --   - prefer all neighbors are indoor
  --   - no purpose (not a start room, exit room, key room)
  --   - no teleporters
  --   - not the destination of a locked door (anti-climactic)

  local HALL_SIZE_PROBS = { 98, 84, 60, 40, 20, 10 }
  local HALL_SIZE_HEAPS = { 98, 95, 90, 70, 50, 30 }
  local REVERT_PROBS    = {  0,  0, 25, 75, 90, 98 }

  local function eval_hallway(R)

    if R.outdoor or R.kind == "scenic" or R.children then
      return false
    end

    if R.purpose then return false end

    if #R.teleports > 0 then return false end
    if R.num_branch < 2 then return false end
    if R.num_branch > 4 then return false end

    local outdoor_chance = 5
    local lock_chance    = 50

    if STYLE.hallways == "heaps" then
      outdoor_chance = 50
      lock_chance = 90
    end

    for _,C in ipairs(R.conns) do
      local N = C:neighbor(R)
      if N.outdoor and not rand_odds(outdoor_chance) then
        return false
      end

      if C.dest == R and C.lock and not rand_odds(lock_chance) then
        return false
      end
    end

    local min_d = math.min(R.sw, R.sh)

    if min_d > 6 then return false end

    if STYLE.hallways == "heaps" then
      return rand_odds(HALL_SIZE_HEAPS[min_d])
    end

    if STYLE.hallways == "few" and rand_odds(66) then
      return false end

    return rand_odds(HALL_SIZE_PROBS[min_d])
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
gui.debugf("  Made Hallway @ %s\n", R:tostr())
      R.kind = "hallway"
      R.outdoor = nil
    end
  end

  -- large rooms which are surrounded by hallways are wasted,
  -- hence look for them and revert them back to normal.
  for _,R in ipairs(PLAN.all_rooms) do
    if R.kind == "hallway" and surrounded_by_halls(R) then
      local min_d = math.min(R.sw, R.sh)

      assert(min_d <= 6)

      if rand_odds(REVERT_PROBS[min_d]) then
        R.kind = "building"
gui.debugf("Reverted HALLWAY @ %s\n", R:tostr())
      end
    end
  end

  -- decide stairwells
  for _,R in ipairs(PLAN.all_rooms) do
    if R.kind == "hallway" and R.num_branch == 2 and
       stairwell_neighbors(R) == 0 and
       locked_neighbors(R) == 0
    then
      local hall_nb = hallway_neighbors(R) 

      local prob = 80
      if hall_nb >= 2 then prob = 2  end
      if hall_nb == 1 then prob = 40 end

      if rand_odds(prob) then
        R.kind = "stairwell"
      end
    end
  end -- for R

  -- we don't need archways where two hallways connect
  for _,C in ipairs(PLAN.all_conns) do
    if not C.lock and C.src.kind == "hallway" and C.dest.kind == "hallway" then
      local S = C.src_S
      local T = C.dest_S
      local dir = S.conn_dir

      if S.border[S.conn_dir].kind == "arch" or
         T.border[T.conn_dir].kind == "arch"
      then
        S.border[S.conn_dir].kind = "nothing"
        T.border[T.conn_dir].kind = "nothing"
      end
    end
  end -- for C
end


function Rooms_setup_symmetry()
  -- The 'symmetry' field of each room already has a value
  -- (from the big-branch connection system).  Here we choose
  -- whether to keep that, expand it (rare) or discard it.
  --
  -- The new value applies to everything made in the room
  -- (as much as possible) from now on.

  local function prob_for_match(old_sym, new_sym)
    if old_sym == new_sym then
      return sel(old_sym == "xy", 8000, 400)

    elseif new_sym == "xy" then
      -- rarely upgrade from NONE --> XY symmetry
      return sel(old_sym, 30, 3)

    elseif old_sym == "xy" then
      return 150

    else
      -- rarely change from X --> Y or vice versa
      return sel(old_sym, 6, 60)
    end
  end

  local function prob_for_size(R, new_sym)
    local prob = 200

    if new_sym == "x" or new_sym == "xy" then
      if R.sw <= 2 then return 0 end
      if R.sw <= 4 then prob = prob / 2 end

      if R.sw > R.sh * 3.1 then return 0 end
      if R.sw > R.sh * 2.1 then prob = prob / 3 end
    end

    if new_sym == "y" or new_sym == "xy" then
      if R.sh <= 2 then return 0 end
      if R.sh <= 4 then prob = prob / 2 end

      if R.sh > R.sw * 3.1 then return 0 end
      if R.sh > R.sw * 2.1 then prob = prob / 3 end
    end

    return prob
  end

  local function decide_layout_symmetry(R)
    R.conn_symmetry = R.symmetry

    -- We discard 'R' rotate and 'T' transpose symmetry (for now...)
    if not (R.symmetry == "x" or R.symmetry == "y" or R.symmetry == "xy") then
      R.symmetry = nil
    end

    local SYM_LIST = { "x", "y", "xy" }

    local syms  = { "none" }
    local probs = { 100 }

    if STYLE.symmetry == "few"   then probs[1] = 500 end
    if STYLE.symmetry == "heaps" then probs[1] = 10  end

    for _,sym in ipairs(SYM_LIST) do
      local p1 = prob_for_size(R, sym)
      local p2 = prob_for_match(R.symmetry, sym)

      if p1 > 0 and p2 > 0 then
        table.insert(syms, sym)
        table.insert(probs, p1*p2/100)
      end
    end

    local index = rand_index_by_probs(probs)

    R.symmetry = sel(index > 1, syms[index], nil)

    gui.debugf("Final symmetry @ %s : %s --> %s\n", R:tostr(),
               tostring(R.conn_symmetry), tostring(R.symmetry))
  end

  local function mirror_horizontally(R)
    if R.sw >= 2 then
      for y = R.sy1, R.sy2 do
        for dx = 0, int((R.sw-2) / 2) do
          local LS = SEEDS[R.sx1 + dx][y][1]
          local RS = SEEDS[R.sx2 - dx][y][1]

          LS.x_peer = RS
          RS.x_peer = LS
        end
      end
    end
  end

  local function mirror_vertically(R)
    if R.sh >= 2 then
      for x = R.sx1, R.sx2 do
        for dy = 0, int((R.sh-2) / 2) do
          local BS = SEEDS[x][R.sy1 + dy][1]
          local TS = SEEDS[x][R.sy2 - dy][1]

          BS.y_peer = TS
          TS.y_peer = BS
        end
      end
    end
  end


  --| Rooms_setup_symmetry |--

  for _,R in ipairs(PLAN.all_rooms) do
    decide_layout_symmetry(R)

    if R.symmetry == "x" or R.symmetry == "xy" then
      R.mirror_x = true
    end

    if R.symmetry == "y" or R.symmetry == "xy" then
      R.mirror_y = true
    end

    -- we ALWAYS setup the x_peer / y_peer refs
    mirror_horizontally(R)
    mirror_vertically(R)
  end
end


function Rooms_reckon_doors()
  local DEFAULT_PROBS = {}

  local function door_chance(R1, R2)
    local door_probs = PLAN.theme.door_probs or
                       GAME.door_probs or
                       DEFAULT_PROBS

    if R1.outdoor and R2.outdoor then
      return door_probs.out_both or 0

    elseif R1.outdoor or R2.outdoor then
      return door_probs.out_diff or 80

    elseif R1.kind == "stairwell" or R2.kind == "stairwell" then
      return door_probs.stairwell or 1

    elseif R1.kind == "hallway" and R2.kind == "hallway" then
      return door_probs.hall_both or 2

    elseif R1.kind == "hallway" or R2.kind == "hallway" then
      return door_probs.hall_diff or 60

    elseif R1.combo ~= R2.combo then
      return door_probs.combo_diff or 40

    else
      return door_probs.normal or 20
    end
  end


  ---| Rooms_reckon_doors |---

  for _,C in ipairs(PLAN.all_conns) do
    for who = 1,2 do
      local S = sel(who == 1, C.src_S, C.dest_S)
      local N = sel(who == 2, C.src_S, C.dest_S)
      assert(S)

      if S.conn_dir then
        local B  = S.border[S.conn_dir]
        local B2 = N.border[10 - S.conn_dir]

        -- ensure when going from outside to inside that the arch/door
        -- is made using the building combo (NOT the outdoor combo)
        if B.kind == "arch" and
           ((S.room.outdoor and not N.room.outdoor) or
            (S.room == N.room.parent))
        then
          -- swap borders
          S, N = N, S

          S.border[S.conn_dir] = B
          N.border[10 - S.conn_dir] = B2
        end

        if B.kind == "arch" and not B.tried_door then
          B.tried_door = true

          local prob = door_chance(C.src, C.dest)

          if S.conn.lock then
            B.kind = "lock_door"
            B.lock = S.conn.lock

            -- FIXME: smells like a hack!!
            if B.lock.item and string.sub(B.lock.item, 1, 4) == "bar_" then
              B.kind = "bars"
            end

          elseif rand_odds(prob) then
            B.kind = "door"
          
          elseif (STYLE.fences == "none" or STYLE.fences == "few") and
                 C.src.outdoor and C.dest.outdoor then
            B.kind = "nothing"
          end
        end

      end
    end -- for who
  end -- for C
end


function Rooms_border_up()

  local function make_map_edge(R, S, side)
    if R.outdoor then
      S.border[side].kind = "sky_fence"
      S.thick[side] = 48
    else
      S.border[side].kind = "wall"
      S.border[side].can_fake_sky = true
      S.thick[side] = 24
    end
  end

  local function make_border(R1, S, R2, N, side)

    if R1 == R2 then
      -- same room : do nothing
      S.border[side].kind = "nothing"
      return
    end


    if R1.outdoor then
      if R2.outdoor then
        S.border[side].kind = "fence"
      else
        S.border[side].kind = "nothing"
      end

      if N.kind == "smallexit" then
        S.border[side].kind = "nothing"
      end

      if N.kind == "liquid" and
        (S.kind == "liquid" or R1.arena == R2.arena)
        --!!! or (N.room.kind == "scenic" and safe_falloff(S, side))
      then
        S.border[side].kind = "nothing"
      end

      if STYLE.fences == "none" and R1.arena == R2.arena then
        S.border[side].kind = "nothing"
      end

    else -- R1 indoor

      if R2.parent == R1 and not R2.outdoor then
        S.border[side].kind = "nothing"
        return
      end

      S.border[side].kind = "wall"
      S.thick[side] = 24

      -- liquid arches are a kind of window
      if S.kind == "liquid" and N.kind == "liquid" then
        S.border[side].kind = "liquid_arch"
        return
      end
    end
  end


  local function border_up(R)
    for x = R.sx1, R.sx2 do for y = R.sy1, R.sy2 do
      local S = SEEDS[x][y][1]
      if S.room == R then
        for side = 2,8,2 do
          if not S.border[side].kind then
            local N = S:neighbor(side)
  
            if not (N and N.room) then
              make_map_edge(R, S, side)
            else
              make_border(R, S, N.room, N, side)
            end
          end

          assert(S.border[side].kind)
        end -- for side
      end
    end end -- for x, y
  end


  local function get_border_list(R)
    local list = {}

    for x = R.sx1, R.sx2 do for y = R.sy1, R.sy2 do
      local S = SEEDS[x][y][1]
      if S.room == R and not
         (S.kind == "void" or S.kind == "diagonal" or
          S.stair_kind == "tall")
      then
        for side = 2,8,2 do
          if S.border[side].kind == "wall" then
            table.insert(list, { S=S, side=side })
          end
        end -- for side
      end
    end end -- for x, y

    return list
  end

---## local function can_make_window(S, side)
---##    return true
---##  end

  local function score_window_side(R, side, border_list)
    local min_c1, max_f1 = 999, -999
    local min_c2, max_f2 = 999, -999

    local total   = 0
    local scenics = 0
    local doors   = 0
    local futures = 0
    local entry   = 0

    local info = { side=side, seeds={} }

    for _,C in ipairs(R.conns) do
      local S = C:seed(R)
      local B = S.border[side]

      if S.conn_dir == side then
        -- never any windows near a locked door
        if B.kind == "lock_door" then
          return nil
        end

        if B.kind == "door" or B.kind == "arch" then
          doors = doors + 1
        end

        if C == R.entry_conn then
          entry = 1
        end
      end
    end


    for _,bd in ipairs(border_list) do
      local S = bd.S
      local N = S:neighbor(side)

      total = total + 1

      if (bd.side == side) and S.floor_h and
         (N and N.room and N.room.outdoor) and N.floor_h
      -- (N.kind == "walk" or N.kind == "liquid")
      then
        table.insert(info.seeds, S)

        if N.kind == "scenic" then
          scenics = scenics + 1
        end

        if S.room.arena and N.room.arena and (S.room.arena.id < N.room.arena.id) then
          futures = futures + 1
        end
        
        min_c1 = math.min(min_c1, assert(S.ceil_h or R.ceil_h))
        min_c2 = SKY_H

        max_f1 = math.max(max_f1, S.floor_h)
        max_f2 = math.max(max_f2, N.floor_h)
      end 
    end  -- for bd


    -- nothing possible??
    local usable = #info.seeds

    if usable == 0 then return end

    local min_c = math.min(min_c1, min_c2)
    local max_f = math.max(max_f1, max_f2)

    if min_c - max_f < 95 then return end

    local score = 200 + gui.random() * 20

    -- primary score is floor drop off
    score = score + (max_f1 - max_f2)

    score = score + (min_c  - max_f) / 8
    score = score - usable * 22

    if scenics >= 1 then score = score + 120 end
    if entry   == 0 then score = score + 60 end

    if doors   == 0 then score = score + 20 end
    if futures == 0 then score = score + 10 end

    gui.debugf("Window score @ %s ^%d --> %d\n", R:tostr(), side, score)

    info.score = score


    -- implement the window style
    if (STYLE.windows == "few"  and score < 350) or
       (STYLE.windows == "some" and score < 260)
    then
      return nil
    end


    -- determine height of window
    if (min_c - max_f) >= 192 and rand_odds(20) then
      info.z1 = max_f + 64
      info.z2 = min_c - 64
      info.is_tall = true
    elseif (min_c - max_f) >= 160 and rand_odds(60) then
      info.z1 = max_f + 32
      info.z2 = min_c - 24
      info.is_tall = true
    elseif (max_f1 < max_f2) and rand_odds(30) then
      info.z1 = min_c - 80
      info.z2 = min_c - 32
    else
      info.z1 = max_f + 32
      info.z2 = max_f + 80
    end

    -- determine width & doubleness
    local thin_chance = math.min(6, usable) * 20 - 40
    local dbl_chance  = 80 - math.min(3, usable) * 20

    if usable >= 3 and rand_odds(thin_chance) then
      info.width = 64
    elseif usable <= 3 and rand_odds(dbl_chance) then
      info.width = 192
      info.mid_w = 64
    elseif info.is_tall then
      info.width = rand_sel(80, 128, 192)
    else
      info.width = rand_sel(20, 128, 192)
    end

    return info
  end

  local function add_windows(R, info, border_list)
    local side = info.side

    for _,S in ipairs(info.seeds) do
      S.border[side].kind = "window"

      S.border[side].win_width = info.width
      S.border[side].win_mid_w = info.mid_w
      S.border[side].win_z1    = info.z1
      S.border[side].win_z2    = info.z2
    end -- for S
  end

  local function pick_best_side(poss)
    local best

    for side = 2,8,2 do
      if poss[side] and (not best or poss[best].score < poss[side].score) then
        best = side
      end
    end

    return best
  end

  local function decide_windows(R, border_list)
    if R.kind ~= "building" then return end
    if R.semi_outdoor then return end

    local poss = {}

    for side = 2,8,2 do
      poss[side] = score_window_side(R, side, border_list)
    end

    for loop = 1,2 do
      local best = pick_best_side(poss)

      if best then
        add_windows(R, poss[best], border_list)

        poss[best] = nil

        -- remove the opposite side too
        poss[10-best] = nil
      end
    end
  end


  local function select_picture(R, v_space, index)

    -- FIXME: move into GAME !!!
    local compsta1 =
    {
      pic_w="COMPSTA1", width=128, height=52,
      x_offset=0, y_offset=0,
      side_w="DOORSTOP", depth=8, 
      top_f="FLAT23", light=0.8,
    }
    local compsta2 =
    {
      pic_w="COMPSTA2", width=128, height=52,
      x_offset=0, y_offset=0,
      side_w="DOORSTOP", depth=8, 
      top_f="FLAT23", light=0.8,
    }
    local lite5 =
    {
      count=3, gap=32,
      pic_w="LITE5", width=16, height=64,
      x_offset=0, y_offset=0,
      side_w="DOORSTOP", top_f="FLAT23", depth=8, 
      sec_kind=8, light=0.9,  -- oscillate
    }
    local liteblu4 =
    {
      count=3, gap=32,
      pic_w="LITEBLU4", width=16, height=64,
      x_offset=0, y_offset=0,
      side_w="LITEBLU4", top_f="FLAT14", depth=8, 
      sec_kind=8, light=0.9,
    }
    local redwall =
    {
      count=2, gap=48,
      pic_w="REDWALL", width=16, height=128, raise=20,
      x_offset=0, y_offset=0,
      side_w="REDWALL", top_f="FLAT5_3", depth=8, 
      sec_kind=8, light=0.99,
    }
    local silver3 =
    {
      count=1, gap=32,
      pic_w="SILVER3", width=64, height=96,
      x_offset=0, y_offset=16,
      side_w="DOORSTOP", top_f="FLAT23", depth=8, 
      light=0.8,
    }
    local shawn1 =
    {
      count=1,
      pic_w="SHAWN1", width=128, height=72,
      x_offset=-4, y_offset=0,
      side_w="DOORSTOP", top_f="FLAT23", depth=8, 
    }
    local pill =
    {
      count=1,
      pic_w="CEMENT1", width=128, height=32, raise=16,
      x_offset=0, y_offset=0,
      side_w="METAL", top_f="CEIL5_2", depth=8, 
      light=0.7,
    }
    local carve =
    {
      count=1,
      pic_w="CEMENT4", width=64, height=64,
      x_offset=0, y_offset=0,
      side_w="METAL", top_f="CEIL5_2", depth=8, 
      light=0.7,
    }
    local tekwall1 =
    {
      count=1,
      pic_w="TEKWALL1", width=160, height=80,
      x_offset=0, y_offset=24,
      side_w="METAL", top_f="CEIL5_2", depth=8, 
      line_kind=48, -- scroll
      light=0.7,
    }
    local tekwall4 =
    {
      count=1,
      pic_w="TEKWALL4", width=128, height=80,
      x_offset=0, y_offset=24,
      side_w="METAL", top_f="CEIL5_2", depth=8, 
      line_kind=48, -- scroll
      light=0.7,
    }
    local pois1 =
    {
      count=2, gap=32,
      pic_w="BRNPOIS", width=64, height=56,
      x_offset=0, y_offset=48,
      side_w="METAL", top_f="CEIL5_2", depth=8, 
    }
    local pois2 =
    {
      count=1, gap=32,
      pic_w="GRAYPOIS", width=64, height=64,
      x_offset=0, y_offset=0,
      side_w="DOORSTOP", top_f="FLAT23",
      depth=8, 
    }
    
    --------------------

    if rand_odds(sel(PLAN.has_logo,7,40)) then
      PLAN.has_logo = true
      return rand_sel(50, carve, pill)
    end

    if R.has_liquid and index == 1 and rand_odds(75) then
      return rand_sel(70, pois1, pois2)
    end

    if v_space >= 160 and rand_odds(30) then
      return rand_sel(80, silver3, redwall)
    end

    if rand_odds(10) then
      return shawn1
    elseif rand_odds(4) then
      return rand_sel(60, tekwall1, tekwall4)
    end

    if rand_odds(64) then
      if rand_odds(5) then
        compsta1.sec_kind = 1
        compsta2.sec_kind = 1
      end
      return rand_sel(50, compsta1, compsta2)
    else
      return rand_sel(50, lite5, liteblu4)
    end
  end

  local function install_pic(R, bd, skin)
    -- handles symmetry

    for dx = 1,sel(R.mirror_x, 2, 1) do
      for dy = 1,sel(R.mirror_y, 2, 1) do
        local S    = bd.S
        local side = bd.side

        if dx == 2 then
          S = S.x_peer
          if not S then break; end
          if is_horiz(side) then side = 10-side end
        end

        if S and dy == 2 then
          S = S.y_peer
          if not S then break; end
          if is_vert(side) then side = 10-side end
        end

        local B = S.border[side]

        if B.kind == "wall" and S.floor_h then
          B.kind = "picture"
          B.pic_skin = skin
          B.pic_z1 = S.floor_h + (skin.raise or 32)
        end

      end -- for dy
    end -- for dx
  end

  local function decide_pictures(R, border_list)
    if R.kind ~= "building" then return end
    if R.semi_outdoor then return end

    -- filter border list to remove symmetrical peers, seeds
    -- with pillars, etc..  Also determine vertical space.
    local new_list = {}

    local v_space = 999

    for _,bd in ipairs(border_list) do
      local S = bd.S
      local side = bd.side

      if (R.mirror_x and S.x_peer and S.sx > S.x_peer.sx) or
         (R.mirror_y and S.y_peer and S.sy > S.y_peer.sy) or
         (S.content == "pillar") or (S.kind == "lift")
      then
        -- skip it
      else
        table.insert(new_list, bd)

        local h = (S.ceil_h or R.ceil_h) - S.floor_h
        v_space = math.min(v_space, h)
      end
    end

    if #new_list == 0 then return end


    -- deice how many pictures we want
    local perc = rand_element { 20,30,40 }

    if STYLE.pictures == "heaps" then perc = 50 end
    if STYLE.pictures == "few"   then perc = 10 end

    local count = int(#border_list * perc / 100)

    gui.debugf("Picture count @ %s --> %d\n", R:tostr(), count)

    if R.mirror_x then count = int(count / 2) + 1 end
    if R.mirror_y then count = int(count / 2) end


    -- select one or two pictures to use
    local pics = {}
    pics[1] = select_picture(R, v_space, 1)
    pics[2] = pics[1]

    if #border_list >= 12 then
      -- prefer a different pic for #2
      for loop = 1,3 do
        pics[2] = select_picture(R, v_space, 2)
        if pics[2].pic_w ~= pics[1].pic_w then break; end
      end
    end

    gui.debugf("Selected pics: %s %s\n", pics[1].pic_w, pics[2].pic_w)


    for loop = 1,count do
      if #new_list == 0 then break; end

      -- FIXME !!!! SELECT GOOD SPOT
      local b_index = rand_irange(1, #new_list)

      local bd = table.remove(new_list, b_index)
      
      install_pic(R, bd, pics[1 + (loop-1) % 2])
    end -- for loop
  end


  ---| Rooms_border_up |---
  
  for _,R in ipairs(PLAN.all_rooms) do
    border_up(R)
  end
  for _,R in ipairs(PLAN.scenic_rooms) do
    border_up(R)
  end

  for _,R in ipairs(PLAN.all_rooms) do
    decide_windows( R, get_border_list(R))
    decide_pictures(R, get_border_list(R))
  end
end


function Room_make_ceiling(R)

  local function outdoor_ceiling()
    assert(R.floor_max_h)
    if R.floor_max_h > SKY_H - 128 then
      R.ceil_h = R.floor_max_h + 128
    end
  end

  local function periph_size(PER)
    if PER[2] then return 3 end
    if PER[1] then return 2 end
    if PER[0] then return 1 end
    return 0
  end

  local function get_max_drop(side, offset)
    local drop_z
    local x1,y1, x2,y2 = side_coords(side, R.tx1,R.ty1, R.tx2,R.ty2, offset)

    for x = x1,x2 do for y = y1,y2 do
      local S = SEEDS[x][y][1]
      if S.room == R then

        local f_h
        if S.kind == "walk" then
          f_h = S.floor_h
        elseif S.kind == "stair" or S.kind == "lift" then
          f_h = math.max(S.stair_z1, S.stair_z2)
        elseif S.kind == "curve_stair" then
          f_h = math.max(S.x_height, S.y_height)
        end

        if f_h then
          local diff_h = (S.ceil_h or R.ceil_h) - (f_h + 144)

          if diff_h < 1 then return nil end

          if not drop_z or (diff_h < drop_z) then
            drop_z = diff_h
          end
        end
      end
    end end -- for x, y

    return drop_z
  end

  local function add_periph_pillars(side, offset)
    local x1,y1, x2,y2 = side_coords(side, R.tx1,R.ty1, R.tx2,R.ty2, offset)

    if is_vert(side) then x2 = x2-1 else y2 = y2-1 end

    local x_dir = sel(side == 6, -1, 1)
    local y_dir = sel(side == 8, -1, 1)

    local metal =
    {
      t_face = { texture="CEIL5_2" },
      b_face = { texture="CEIL5_2" },
      w_face = { texture="SUPPORT3", x_offset=0 },
    }

    for x = x1,x2 do for y = y1,y2 do
      local S = SEEDS[x][y][1]

      -- check if all neighbors are in same room
      local count = 0

      for dx = 0,1 do for dy = 0,1 do
        local nx = x + dx * x_dir
        local ny = y + dy * y_dir

        if Seed_valid(nx, ny, 1) and SEEDS[nx][ny][1].room == R then
          count = count + 1
        end
      end end -- for dx,dy

      if count == 4 then
        local w = 12

        local px = sel(x_dir < 0, S.x1, S.x2)
        local py = sel(y_dir < 0, S.y1, S.y2)

        transformed_brush(nil, metal,
            rect_coords(px-w, py-w, px+w, py+w),
            -EXTREME_H, EXTREME_H)
        
        R.has_periph_pillars = true

        -- mark seeds [crude way to prevent stuck masterminds]
        for dx = 0,1 do for dy = 0,1 do
          local nx = x + dx * x_dir
          local ny = y + dy * y_dir

          SEEDS[nx][ny][1].solid_corner = true
        end end -- for dx,dy
      end
    end end -- for x, y
  end

  local function create_periph_info(side, offset)
    local t_size = sel(is_horiz(side), R.tw, R.th)

    if t_size < (3+offset*2) then return nil end

    local drop_z = get_max_drop(side, offset)

    if not drop_z or drop_z < 30 then return nil end

    local PER = { max_drop=drop_z }

    if t_size == (3+offset*2) then
      PER.tight = true
    end

    if R.pillar_rows then
      for _,row in ipairs(R.pillar_rows) do
        if row.side == side and row.offset == offset then
          PER.pillars = true
        end
      end
    end

    return PER
  end

  local function merge_periphs(side, offset)
    local P1 = R.periphs[side][offset]
    local P2 = R.periphs[10-side][offset]

    if not (P1 and P2) then return nil end

    if P1.tight and rand_odds(90) then return nil end

    return
    {
      max_drop = math.min(P1.max_drop, P2.max_drop),
      pillars  = P1.pillars or P2.pillars
    }
  end

  local function decide_periphs()
    -- a "periph" is a side of the room where we might lower
    -- the ceiling height.  There is a "outer" one (touches the
    -- wall) and an "inner" one (next to the outer one).

    R.periphs = {}

    for side = 2,8,2 do
      R.periphs[side] = {}

      for offset = 0,2 do
        local PER = create_periph_info(side, offset)
        R.periphs[side][offset] = PER
      end
    end


    local SIDES = { 2,4 }
    if (R.th > R.tw) or (R.th == R.tw and rand_odds(50)) then
      SIDES = { 4,2 }
    end
    if rand_odds(10) then  -- swap 'em
      SIDES[1], SIDES[2] = SIDES[2], SIDES[1]
    end

    for idx,side in ipairs(SIDES) do
      if (R.symmetry == "xy" or R.symmetry == sel(side==2, "y", "x")) or
         R.pillar_rows and is_parallel(R.pillar_rows[1].side, side) or
         rand_odds(50)
      then
        --- Symmetrical Mode ---

        local PER_0 = merge_periphs(side, 0)
        local PER_1 = merge_periphs(side, 1)

        if PER_0 and PER_1 and rand_odds(sel(PER_1.pillars, 70, 10)) then
          PER_0 = nil
        end

        if PER_0 then PER_0.drop_z = PER_0.max_drop / idx end
        if PER_1 then PER_1.drop_z = PER_1.max_drop / idx / 2 end

        R.periphs[side][0] = PER_0 ; R.periphs[10-side][0] = PER_0
        R.periphs[side][1] = PER_1 ; R.periphs[10-side][1] = PER_1
        R.periphs[side][2] = nil   ; R.periphs[10-side][2] = nil

        if idx==1 and PER_0 and not R.pillar_rows and rand_odds(50) then
          add_periph_pillars(side)
          add_periph_pillars(10-side)
        end
      else
        --- Funky Mode ---

        -- pick one side to use   [FIXME]
        local keep = rand_sel(50, side, 10-side)

        for n = 0,2 do R.periphs[10-keep][n] = nil end

        local PER_0 = R.periphs[keep][0]
        local PER_1 = R.periphs[keep][1]

        if PER_0 and PER_1 and rand_odds(5) then
          PER_0 = nil
        end

        if PER_0 then PER_0.drop_z = PER_0.max_drop / idx end
        if PER_1 then PER_1.drop_z = PER_1.max_drop / idx / 2 end

        R.periphs[keep][2] = nil

        if idx==1 and PER_0 and not R.pillar_rows and rand_odds(75) then
          add_periph_pillars(keep)

        --??  if PER_1 and rand_odds(10) then
        --??    add_periph_pillars(keep, 1)
        --??  end
        end
      end
    end
  end

  local function calc_central_area()
    R.cx1, R.cy1 = R.tx1, R.ty1
    R.cx2, R.cy2 = R.tx2, R.ty2

    for side = 2,8,2 do
      local w = periph_size(R.periphs[side])

          if side == 4 then R.cx1 = R.cx1 + w
      elseif side == 6 then R.cx2 = R.cx2 - w
      elseif side == 2 then R.cy1 = R.cy1 + w
      elseif side == 8 then R.cy2 = R.cy2 - w
      end
    end

    R.cw, R.ch = box_size(R.cx1, R.cy1, R.cx2, R.cy2)

    assert(R.cw >= 1)
    assert(R.ch >= 1)
  end

  local function install_periphs()
    for x = R.tx1, R.tx2 do for y = R.ty1, R.ty2 do
      local S = SEEDS[x][y][1]
      if S.room == R then
      
        local PX, PY

            if x == R.tx1   then PX = R.periphs[4][0]
        elseif x == R.tx2   then PX = R.periphs[6][0]
        elseif x == R.tx1+1 then PX = R.periphs[4][1]
        elseif x == R.tx2-1 then PX = R.periphs[6][1]
        elseif x == R.tx1+2 then PX = R.periphs[4][2]
        elseif x == R.tx2-2 then PX = R.periphs[6][2]
        end

            if y == R.ty1   then PY = R.periphs[2][0]
        elseif y == R.ty2   then PY = R.periphs[8][0]
        elseif y == R.ty1+1 then PY = R.periphs[2][1]
        elseif y == R.ty2-1 then PY = R.periphs[8][1]
        elseif y == R.ty1+2 then PY = R.periphs[2][2]
        elseif y == R.ty2-2 then PY = R.periphs[8][2]
        end

        if PX and not PX.drop_z then PX = nil end
        if PY and not PY.drop_z then PY = nil end

        if PX or PY then
          local drop_z = math.max((PX and PX.drop_z) or 0,
                                  (PY and PY.drop_z) or 0)

          S.ceil_h = R.ceil_h - drop_z
        end

      end -- if S.room == R
    end end -- for x, y
  end

  local function fill_xyz(c_tex, ch)
    for x = R.cx1, R.cx2 do for y = R.cy1, R.cy2 do
      local S = SEEDS[x][y][1]
      if S.room == R then
      
        S.ceil_h  = ch
        S.c_tex   = c_tex
        S.c_light = 0.75

      end -- if S.room == R
    end end -- for x, y
  end

  local function add_central_pillar()
    -- big rooms only
    if R.tw < 5 or R.th < 5 then return end

    -- centred only
    if R.cw < 3 or R.ch < 3 then return end
    if (R.cw % 2) == 0 or (R.ch % 2) == 0 then return end

    local mx = R.cx1 + int(R.cw / 2)
    local my = R.cy1 + int(R.ch / 2)

    local S = SEEDS[mx][my][1]

    -- seed is usable?
    if S.room ~= R or S.content then return end
    if not (S.kind == "walk" or S.kind == "liquid") then return end

    -- neighbors the same?
    for side = 2,8,2 do
      local N = S:neighbor(side)
      if not (N and N.room == S.room and N.kind == S.kind) then
        return
      end
    end

    -- OK !!
    S.content = "pillar"
    S.pillar_tex = rand_sel(20, "LITEBLU4", "REDWALL")

    R.has_central_pillar = true
  end

  local function central_niceness()
    local nice = 2

    for x = R.cx1, R.cx2 do for y = R.cy1, R.cy2 do
      local S = SEEDS[x][y][1]
      
      if S.room ~= R then return 0 end
      
      if S.kind == "void" or ---#  S.kind == "diagonal" or
         S.stair_kind == "tall" or S.content == "pillar"
      then
        nice = 1
      end
    end end -- for x, y

    return nice
  end

  local function criss_cross_beams()
    -- !!! FIXME: criss_cross_beams
  end

  local function simple_outer_trim()
    -- !!! FIXME: simple_outer_trim
  end

  local function do_central_area()
    calc_central_area()

    local has_sky_nb = R:has_sky_neighbor()

    if R.has_periph_pillars and not has_sky_nb and rand_odds(16) then
      fill_xyz(PARAMS.sky_flat, R.ceil_h)
      R.semi_outdoor = true
      return
    end


    if R.cw <= 4 and R.ch <= 4 and rand_odds(1) then
      criss_cross_beams()
      return
    end

    
    if R.cw <= 3 and R.ch <= 3 and rand_odds(20) then
      simple_outer_trim()
      return
    end


    -- shrink central area until there are nothing which will
    -- get in the way of a ceiling prefab.
    local nice = central_niceness()

gui.debugf("Original @ %s over %dx%d -> %d\n", R:tostr(), R.cw, R.ch, nice)

    while nice < 2 and (R.cw >= 3 or R.ch >= 3) do
      
      if R.cw > R.ch or (R.cw == R.ch and rand_odds(50)) then
        assert(R.cw >= 3)
        R.cx1 = R.cx1 + 1
        R.cx2 = R.cx2 - 1
      else
        assert(R.ch >= 3)
        R.cy1 = R.cy1 + 1
        R.cy2 = R.cy2 - 1
      end

      R.cw, R.ch = box_size(R.cx1, R.cy1, R.cx2, R.cy2)

      nice = central_niceness()
    end
      
gui.debugf("Niceness @ %s over %dx%d -> %d\n", R:tostr(), R.cw, R.ch, nice)


    add_central_pillar()

    if nice ~= 2 then return end

      local ceil_info =
      {
        t_face = { texture=R.combo.ceil },
        b_face = { texture=R.combo.ceil },
        w_face = { texture=R.combo.wall },
      }

      local sky_info =
      {
        t_face = { texture=PARAMS.sky_flat },
        b_face = { texture=PARAMS.sky_flat, light=0.75 },
        w_face = { texture=PARAMS.sky_tex },
      }

      local brown_info =
      {
        t_face = { texture="CEIL3_3" },
        b_face = { texture="CEIL3_3" },
        w_face = { texture="STARTAN2" },
      }

      local lights = { "TLITE6_5", "TLITE6_6", "GRNLITE1", "FLAT17", "CEIL3_4" }

      local light_info =
      {
        t_face = { texture="CEIL5_2" },
        b_face = { texture=rand_element(lights), light=0.85 },
        w_face = { texture="METAL" },
      }

    local trim   = material_to_info("metal")
    local spokes = material_to_info("shiny")

    if STYLE.lt_swapped ~= "none" then
      trim, spokes = spokes, trim
    end

    if STYLE.lt_trim == "none" or (STYLE.lt_trim == "some" and rand_odds(50)) then
      trim = nil
    end
    if STYLE.lt_spokes == "none" or (STYLE.lt_spokes == "some" and rand_odds(70)) then
      spokes = nil
    end

    if R.cw == 1 or R.ch == 1 then
      fill_xyz(light_info.b_face.texture, R.ceil_h + 32)
      return
    end

    local shape = rand_sel(30, "square", "round")

    local w = 96 + 140 * (R.cw - 1)
    local h = 96 + 140 * (R.ch - 1)
    local z = (R.cw + R.ch) * 8

    Build_sky_hole(R.cx1,R.cy1, R.cx2,R.cy2, shape, w, h,
                   ceil_info, R.ceil_h,
                   sel(not has_sky_nb and not R.parent and rand_odds(60), sky_info,
                       rand_sel(75, light_info, brown_info)), R.ceil_h + z,
                   trim, spokes)
  end

  local function indoor_ceiling()
    assert(R.floor_max_h)

    local avg_h = int((R.floor_min_h + R.floor_max_h) / 2)
    local min_h = R.floor_max_h + 128

    local tw = R.tw or R.sw
    local th = R.th or R.sh

    local approx_size = (2 * math.min(tw, th) + math.max(tw, th)) / 3.0
    local tallness = (approx_size + rand_range(-0.6,1.6)) * 64.0

    if tallness < 128 then tallness = 128 end
    if tallness > 448 then tallness = 448 end

    R.tallness = int(tallness / 32.0) * 32

    gui.debugf("Tallness @ %s --> %d\n", R:tostr(), R.tallness)
 
    R.ceil_h = math.max(min_h, avg_h + R.tallness)

    decide_periphs()
    install_periphs()

    do_central_area()

--[[
    if R.tx1 and R.tw >= 7 and R.th >= 7 then

      Build_sky_hole(R.tx1,R.ty1, R.tx2,R.ty2,
                     "round", w, h,
                     outer_info, R.ceil_h,
                     nil, R.ceil_h , ---  + z,
                     metal, nil)

      w = 96 + 110 * (R.tx2 - R.tx1 - 4)
      h = 96 + 110 * (R.ty2 - R.ty1 - 4)

      outer_info.b_face.texture = "F_SKY1"
      outer_info.b_face.light = 0.8

      Build_sky_hole(R.tx1+2,R.ty1+2, R.tx2-2,R.ty2-2,
                     "round", w, h,
                     outer_info, R.ceil_h + 96,
                     inner_info, R.ceil_h + 104,
                     metal, silver)
    end

    if R.tx1 and R.tw == 4 and R.th == 4 then
      local w = 256
      local h = 256

      for dx = 0,1 do for dy = 0,0 do
        local tx1 = R.tx1 + dx * 2
        local ty1 = R.ty1 + dy * 2

        local tx2 = R.tx1 + dx * 2 + 1
        local ty2 = R.ty1 + dy * 2 + 3

        Build_sky_hole(tx1,ty1, tx2,ty2,
                       "square", w, h,
                       outer_info, R.ceil_h,
                       inner_info, R.ceil_h + 36,
                       metal, metal)
      end end -- for dx, dy
    end

    if R.tx1 and (R.tw == 3 or R.tw == 5) and (R.th == 3 or R.th == 5) then
      for x = R.tx1+1, R.tx2-1, 2 do
        for y = R.ty1+1, R.ty2-1, 2 do
          local S = SEEDS[x][y][1]
          if not (S.kind == "void" or S.kind == "diagonal") then
            Build_sky_hole(x,y, x,y, "square", 160,160,
                           metal,      R.ceil_h+16,
                           inner_info, R.ceil_h+32,
                           nil, silver)
          end
        end -- for y
      end -- for x
    end
--]]
  end


  ---| Room_make_ceiling |---

  if R.kind == "ground" then
    outdoor_ceiling()
  
  elseif R.kind == "building" then
    indoor_ceiling()
  end
end


function Room_build_seeds(R)

  local function do_teleporter(S)
    -- TEMP HACK SHIT

    local idx = S.sx - S.room.sx1 + 1

if idx < 1 then return end

    if idx > #S.room.teleports then return end

    local TELEP = S.room.teleports[idx]


    local mx = int((S.x1 + S.x2)/2)
    local my = int((S.y1 + S.y2)/2)

    local x1 = mx - 32
    local y1 = my - 32
    local x2 = mx + 32
    local y2 = my + 32

    local z1 = (S.floor_h or R.floor_h) + 16

    local tag = sel(TELEP.src == S.room, TELEP.src_tag, TELEP.dest_tag)
    assert(tag)


gui.printf("do_teleport\n")
    transformed_brush(nil,
    {
      t_face = { texture="GATE3" },
      b_face = { texture="GATE3" },
      w_face = { texture="METAL" },

      sec_tag = tag,
    },
    {
      { x=x2, y=y1 }, { x=x2, y=y2 },
      { x=x1, y=y2 }, { x=x1, y=y1 },
    },
    -EXTREME_H, z1)

    gui.add_entity("14", (x1+x2)/2, (y1+y2)/2, z1 + 25)
  end


  local function build_seed(S)

    if S.already_built then
      return
    end

    local x1 = S.x1
    local y1 = S.y1
    local x2 = S.x2
    local y2 = S.y2

    local z1 = S.floor_h or R.floor_h or (S.conn and S.conn.conn_h) or 0
    local z2 = S.ceil_h  or R.ceil_h or SKY_H

    assert(z1 and z2)


    local w_tex = S.w_tex or R.combo.wall
    local f_tex = S.f_tex or R.combo.floor
    local c_tex = S.c_tex or sel(R.outdoor, PARAMS.sky_flat, R.combo.ceil)

    if R.kind == "hallway" then
      w_tex = assert(PLAN.hall_tex)
    elseif R.kind == "stairwell" then
      w_tex = assert(PLAN.well_tex)
    end

    local o_tex = w_tex

    if S.conn_dir then
      local N = S:neighbor(S.conn_dir)

      if N.room.kind == "hallway" then
        o_tex = PLAN.hall_tex
      elseif N.room.kind == "stairwell" then
        o_tex = PLAN.well_tex
      elseif not N.room.outdoor and N.room ~= R.parent then
        o_tex = N.w_tex or N.room.combo.wall
      end
    end


    local sec_kind


    -- SIDES

    for side = 2,8,2 do
      local N = S:neighbor(side)

      local B_kind = S.border[side].kind

      -- hallway hack
      if R.kind == "hallway" and not (S.kind == "void") and
         ( (B_kind == "wall")
          or
           (S:neighbor(side) and S:neighbor(side).room == R and
            S:neighbor(side).kind == "void")
         )
      then
        Build_detailed_hall(S, side, z1, z2)

        S.border[side].kind = nil
        B_kind = nil
      end

      if B_kind == "wall" and R.kind ~= "scenic" then
        Build_wall(S, side, f_tex, w_tex)
      end

      if B_kind == "liquid_arch" then
        local z_top = math.max(R.liquid_h + 80, N.room.liquid_h + 48)
        Build_archway(S, side, z1, z_top, f_tex, w_tex, w_tex) 
      end

      if B_kind == "picture" then
        local B = S.border[side]

        Build_picture(S, side, B.pic_skin, B.pic_z1, B.pic_z2, w_tex, f_tex)
      end

      if B_kind == "window" then
        local B = S.border[side]

        Build_window(S, side, B.win_width, B.win_mid_w,
                     B.win_z1, B.win_z2, f_tex, w_tex)
      end

      if B_kind == "fence"  then
        Build_fence(S, side, R.fence_h or ((R.floor_h or z1)+30), f_tex, w_tex)
      end

      if B_kind == "sky_fence" then
        Build_sky_fence(S, side)
      end

      if B_kind == "arch" then
        local z = assert(S.conn and S.conn.conn_h)

        Build_archway(S, side, z, z+112, f_tex, w_tex, o_tex or w_tex) 

        assert(not S.conn.already_made_lock)
        S.conn.already_made_lock = true
      end

      if B_kind == "door" then
        local z = assert(S.conn and S.conn.conn_h)
        local INFO = assert(GAME.door_fabs["silver_lit"])

        Build_door(S, side, z, w_tex, o_tex or w_tex, INFO, 0)

        assert(not S.conn.already_made_lock)
        S.conn.already_made_lock = true
      end

      if B_kind == "lock_door" then
        local z = assert(S.conn and S.conn.conn_h)

        local LOCK = assert(S.border[side].lock)
        local INFO
        if LOCK.kind == "KEY" then
          INFO = assert(GAME.key_doors[LOCK.item])
        else
          assert(LOCK.kind == "SWITCH")
          INFO = assert(GAME.switch_doors[LOCK.item])
        end

        Build_door(S, side, S.conn.conn_h, w_tex, o_tex or w_tex, INFO, LOCK.tag)

        assert(not S.conn.already_made_lock)
        S.conn.already_made_lock = true
      end

      if B_kind == "bars" then
        local LOCK = assert(S.border[side].lock)
        local INFO = assert(GAME.switch_doors[LOCK.item])

        Build_lowering_bars(S, side, z1, INFO.skin, LOCK.tag)

        assert(not S.conn.already_made_lock)
        S.conn.already_made_lock = true
      end
    end -- for side


    if S.sides_only then return end


    -- DIAGONALS

    if S.kind == "diagonal" then

      local diag_info =
      {
        t_face = { texture=S.stuckie_ftex or f_tex },
        b_face = { texture=c_tex },
        w_face = { texture=w_tex },
      }

      Build_diagonal(S, S.stuckie_side, diag_info, S.stuckie_z)

      S.kind = assert(S.diag_new_kind)

      if S.diag_new_z then
        S.floor_h = S.diag_new_z
        z1 = S.floor_h
      end
      
      if S.diag_new_ftex then
        S.f_tex = S.diag_new_ftex
        f_tex = S.f_tex
      end
    end


    -- CEILING

    if S.kind ~= "void" and not S.no_ceil then
      transformed_brush(nil,
      {
        kind = sel(c_tex == PARAMS.sky_flat, "sky", nil),
        t_face = { texture=c_tex },
        b_face = { texture=c_tex, light=S.c_light },
        w_face = { texture=S.u_tex or w_tex },
      },
      {
        { x=x2, y=y1 }, { x=x2, y=y2 },
        { x=x1, y=y2 }, { x=x1, y=y1 },
      },
      z2, EXTREME_H)

      if R.kind == "hallway" and PLAN.hall_lights and not R.hall_sky then
        local x_num, y_num = 0,0

        for side = 2,8,2 do
          local N = S:neighbor(side)
          if N and N.room == R and N.kind ~= "void" then
            if side == 2 or side == 8 then
              y_num = y_num + 1
            else
              x_num = x_num + 1
            end
          end
        end

        if x_num == 1 and y_num == 1 then
          Build_hall_light(S, z2)
        end
      end
    end


local STEP_SKINS =
{
  { step_w="STEP4", side_w="STONE4",   top_f="FLAT1" },
  { step_w="STEP6", side_w="STUCCO",   top_f="FLAT5" },
  { step_w="STEP3", side_w="COMPSPAN", top_f="CEIL5_1" },
  { step_w="STEP1", side_w="BROWNHUG", top_f="RROCK10" },
}
local LIFT_SKINS =
{
  { side_w="SUPPORT2", top_f="FLAT20" },
}
if not PLAN.step_skin then
  PLAN.step_skin = rand_element(STEP_SKINS)
  PLAN.lift_skin = LIFT_SKINS[1]
end


    -- FLOOR

    if S.kind == "void" then

      transformed_brush(nil,
      {
        t_face = { texture=f_tex },
        b_face = { texture=f_tex },
        w_face = { texture="TEKWALL6" },  -- FIXME w_tex
      },
      {
        { x=x2, y=y1 }, { x=x2, y=y2 },
        { x=x1, y=y2 }, { x=x1, y=y1 },
      },
      EXTREME_H, EXTREME_H);

    elseif S.kind == "foobar" then

      transformed_brush(nil,
      {
        t_face = { texture="LAVA1" },
        b_face = { texture=f_tex },
        w_face = { texture="DBRAIN1" },
      },
      {
        { x=x2, y=y1 }, { x=x2, y=y2 },
        { x=x1, y=y2 }, { x=x1, y=y1 },
      },
      -EXTREME_H, -32);

      transformed_brush(nil,
      {
        t_face = { texture=f_tex },
        b_face = { texture=f_tex },
        w_face = { texture=w_tex },
      },
      {
        { x=x2, y=y1 }, { x=x2, y=y2 },
        { x=x1, y=y2 }, { x=x1, y=y1 },
      },
      256, EXTREME_H);

    elseif S.kind == "stair" then

      Build_niche_stair(S, PLAN.step_skin)

    elseif S.kind == "curve_stair" then

      if S.stair_kind == "tall" then
        Build_tall_curved_stair(S, PLAN.step_skin, S.x_side, S.y_side, S.x_height, S.y_height)
      else
        Build_low_curved_stair(S, PLAN.step_skin, S.x_side, S.y_side, S.x_height, S.y_height)
      end

    elseif S.kind == "lift" then
      local tag = PLAN:alloc_tag()

      Build_lift(S, PLAN.lift_skin, tag)

    elseif S.kind == "popup" then
      Build_popup_trap(S, z1, {}, S.room.combo)

    elseif S.kind == "liquid" then
      transformed_brush(nil,
      {
        t_face = { texture="NUKAGE3" },
        b_face = { texture="NUKAGE3" },
        w_face = { texture="SFALL3"  },
        sec_kind = 16,
      },
      {
        { x=x2, y=y1 }, { x=x2, y=y2 },
        { x=x1, y=y2 }, { x=x1, y=y1 },
      },
      -EXTREME_H, z1)

    elseif not S.no_floor then

      transformed_brush(nil,
      {
        t_face = { texture=f_tex },
        b_face = { texture=f_tex },
        w_face = { texture=w_tex },
        sec_kind = sec_kind,
      },
      {
        { x=x2, y=y1 }, { x=x2, y=y2 },
        { x=x1, y=y2 }, { x=x1, y=y1 },
      },
      -EXTREME_H, z1)
    end


    -- PREFABS

    if S.content == "pillar" then
      Build_pillar(S, z1, z2, S.pillar_tex)
    end


    -- restore diagonal kind for monster/item code
    if S.diag_new_kind then
      S.kind = "diagonal"
    end

  end -- build_seed()


  ---==| Room_build_seeds |==---

  for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
    local S = SEEDS[x][y][1]
    if S.room == R then
      build_seed(S)
    end
  end end -- for x, y
end


function Rooms_build_all()

  gui.printf("\n--==| Rooms_build_all |==--\n\n")

  PLAN.theme = GAME.themes["TECH"] -- FIXME

---  Test_room_fabs()

  Rooms_decide_outdoors()
  Rooms_choose_themes()

  Quest_choose_keys()
  Quest_add_keys()

  Rooms_decide_hallways_II()
  Rooms_setup_symmetry()
  Rooms_reckon_doors()

  Seed_dump_fabs()

  for _,R in ipairs(PLAN.all_rooms) do
    Layout_one(R)
    Room_make_ceiling(R)
  end

  for _,R in ipairs(PLAN.scenic_rooms) do
    Layout_scenic(R)
    Room_make_ceiling(R)
  end

  Rooms_border_up()

  for _,R in ipairs(PLAN.scenic_rooms) do Room_build_seeds(R) end
  for _,R in ipairs(PLAN.all_rooms)    do Room_build_seeds(R) end
end

