----------------------------------------------------------------
--  Room Management
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
      if PLAN.sky_mode == "few" then
        return rand_odds(33)
      else
        return rand_odds(80)
      end
    end

    if PLAN.sky_mode == "heaps" then return rand_odds(50) end
    if PLAN.sky_mode == "few"   then return rand_odds(5) end

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

    if PLAN.hallway_mode == "heaps" then
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

    if PLAN.hallway_mode == "heaps" then
      return rand_odds(HALL_SIZE_HEAPS[min_d])
    end

    if PLAN.hallway_mode == "few" and rand_odds(66) then
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
      if R.sw > R.sh * 2.1 then prob = prob / 4 end
    end

    if new_sym == "y" or new_sym == "xy" then
      if R.sh <= 2 then return 0 end
      if R.sh <= 4 then prob = prob / 2 end

      if R.sh > R.sw * 3.1 then return 0 end
      if R.sh > R.sw * 2.1 then prob = prob / 4 end
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

    if PLAN.symmetry_mode == "few"   then probs[1] = 500 end
    if PLAN.symmetry_mode == "heaps" then probs[1] = 10  end

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
          
          elseif (PLAN.fence_mode == "none" or PLAN.fence_mode == "few") and
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
      S.border[side].kind = "fence"

      if N.kind == "smallexit" then
        S.border[side].kind = "nothing"
      end

      if N.kind == "liquid" and
        (S.kind == "liquid" or --!!!! N.room.kind == "scenic"
         R1.arena == R2.arena)
      then
        S.border[side].kind = "nothing"
      end

      if PLAN.fence_mode == "none" and R1.arena == R2.arena then
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
      end

      --[[ choose_fences(R)

      if R.outdoor or (N2.room.parent == R) then



        elseif N.room.outdoor and not R.outdoor and
               (R.sx1 <= N.sx and N.sx <= R.sx2) and
               (R.sy1 <= N.sy and N.sy <= R.sy2)
        then
           S.border[side].kind = "window"

        elseif N.room.outdoor then
           S.border[side].kind = "fence"

        else
           -- the other border will be a solid wall or window
           S.border[side].kind = "nothing"
        end
      end  --]]


    end

  -- choose_windows(R)

--FIXME
--[[
    if R1.kind == "building" then

      if S.room == R and S.kind ~= "void" and
         (x == R.sx1 or x == R.sx2 or y == R.sy1 or y == R.sy2)
      then
       

          if N and (N.sx < R.sx1 or N.sx > R.sx2 or N.sy < R.sy1 or N.sy > R.sy2) and
             N.room and (N.room.outdoor or R.parent) and
             S.border[side].kind == "wall" and
             rand_odds(25) 
          then
             S.border[side].kind = "window"
          end
        
      end
    end
--]]
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


  ---| Rooms_border_up |---
  
  for _,R in ipairs(PLAN.all_rooms) do
    border_up(R)
  end
  for _,R in ipairs(PLAN.scenic_rooms) do
    border_up(R)
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
    -2000, z1)

    gui.add_entity((x1+x2)/2, (y1+y2)/2, z1 + 25, { name="14" })
  end


  local function build_seed(S)

    if S.already_built then
      return
    end

    local x1 = S.x1
    local y1 = S.y1
    local x2 = S.x2
    local y2 = S.y2

    local z1 = S.floor_h or R.floor_h
    local z2 = S.ceil_h  or R.ceil_h
    local sec_kind


    z1 = z1 or (S.conn and S.conn.conn_h) or S.room.floor_h or 0
    z2 = z2 or S.room.ceil_h or SKY_H

-- z2 = 512

      assert(z1 and z2)


    local w_tex = S.w_tex or R.combo.wall
    local f_tex = S.f_tex or R.combo.floor
    local c_tex = S.c_tex or sel(R.outdoor, PARAMS.sky_flat, R.combo.ceil)



--[[
if not R.outdoor and S.sx > R.sx1+1 and S.sx < R.sx2-1 and S.sy > R.sy1+1 and S.sy < R.sy2-1 then
  z2 = z2 + 32
  c_tex = PARAMS.sky_flat
end --]]


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

      local could_lose_wall = -- FIXME: decide this in earlier code
            N and S.room and N.room and
            S.room.arena == N.room.arena and
            S.room.kind == N.room.kind and
            not (S.room.purpose or N.room.purpose)


      if B_kind == "wall" and R.kind ~= "scenic" then
        Build_wall(S, side, f_tex, w_tex)
      end

      if B_kind == "liquid_arch" then
        local z_top = math.max(R.liquid_h + 80, N.room.liquid_h + 48)
        Build_archway(S, side, z1, z_top, f_tex, w_tex, w_tex) 
      end

      if B_kind == "picture" then
        Build_picture(S, side, 128, z1+64, z1+192, f_tex, w_tex, "SPACEW3")
      end

      if B_kind == "window" then
--!!!        Build_window(S, side, 192, z1+64, z2-32, f_tex, w_tex)
        Build_window(S, side, 192, z1+32, z1+80, f_tex, w_tex)
      end

      if B_kind == "fence"  then
        Build_fence(S, side, R.fence_h or ((R.floor_h or z1)+30), f_tex, w_tex)
      end

      if B_kind == "sky_fence" then
        Build_sky_fence(S, side)
      end

      if B_kind == "arch" then
        local z = assert(S.conn and S.conn.conn_h)

        local N = S:neighbor(side)
        local o_tex = w_tex
        if not N.room.outdoor and N.room ~= R.parent then
          o_tex = N.w_tex or N.room.combo.wall
        end

        Build_archway(S, side, z, z+128, f_tex, w_tex, o_tex) 

        assert(not S.conn.already_made_lock)
        S.conn.already_made_lock = true
      end

      if B_kind == "door" then
        local z = assert(S.conn and S.conn.conn_h)
        local INFO = assert(GAME.door_fabs["silver_lit"])

        local N = S:neighbor(side)
        local o_tex = w_tex
        if not N.room.outdoor and N.room ~= R.parent then
          o_tex = N.w_tex or N.room.combo.wall
        end

        Build_locked_door(S, side, z, w_tex, o_tex, INFO, 0)

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

        local N = S:neighbor(side)
        local o_tex = w_tex
        if not N.room.outdoor and N.room ~= R.parent then
          o_tex = N.w_tex or N.room.combo.wall
        end

        Build_locked_door(S, side, S.conn.conn_h, w_tex, o_tex, INFO, LOCK.tag)

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

      S.kind    = assert(S.diag_new_kind)

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
        t_face = { texture=c_tex },
        b_face = { texture=c_tex },
        w_face = { texture=w_tex },
      },
      {
        { x=x2, y=y1 }, { x=x2, y=y2 },
        { x=x1, y=y2 }, { x=x1, y=y1 },
      },
      z2, 4000)

      if R.kind == "hallway" and PLAN.hall_lights then
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


    -- FLOOR

    local step_info =
    {
      t_face = { texture="FLAT1" },
      b_face = { texture="FLAT1" },
      w_face = { texture="STEP4", peg=true, y_offset=0 },
    }

    if S.kind == "void" then

      transformed_brush(nil,
      {
        t_face = { texture=f_tex },
        b_face = { texture=f_tex },
        w_face = { texture=w_tex },  --- "ZZZFACE1"
      },
      {
        { x=x2, y=y1 }, { x=x2, y=y2 },
        { x=x1, y=y2 }, { x=x1, y=y1 },
      },
      2000, 2000);

    elseif S.kind == "foobar" then

      transformed_brush(nil,
      {
        t_face = { texture="NUKAGE1" },
        b_face = { texture=f_tex },
        w_face = { texture="SFALL1" },
      },
      {
        { x=x2, y=y1 }, { x=x2, y=y2 },
        { x=x1, y=y2 }, { x=x1, y=y1 },
      },
      -2000, -32);

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
      256, 2000);

    elseif S.kind == "stair" then

      Build_niche_stair(S, step_info)

    elseif S.kind == "curve_stair" then

      if S.stair_kind == "tall" then
        Build_tall_curved_stair(S, step_info, S.x_side, S.y_side, S.x_height, S.y_height)
      else
        Build_low_curved_stair(S, step_info, S.x_side, S.y_side, S.x_height, S.y_height)
      end

    elseif S.kind == "lift" then
      Build_lift(S, 10-S.conn_dir, assert(S.layout.lift_h))

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
      -2000, assert(R.liquid_h));

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
      -2000, z1);
    end


    -- PREFABS

    if S.usage == "pillar" then
      Build_pillar(S, z1, z2, S.pillar_tex)
    end


    -- TEMP SHIT
    local mx = int((x1+x2) / 2)
    local my = int((y1+y2) / 2)

    if S.room and S.room.kind ~= "scenic" and
       S.kind == "walk" and not S.usage and not S.content and
       not S.purpose
    then
      -- THIS IS ESSENTIAL (for now) TO PREVENT FILLING by CSG

      local MON = GAME.things["candle"]
      assert(MON)

      gui.add_entity(mx, my, z1 + 25,
      {
        name = tostring(MON.id)
      })
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


  PLAN.sky_mode = rand_key_by_probs { few=15, some=90, heaps=30 }
  gui.printf("Sky Mode: %s\n", PLAN.sky_mode)

  PLAN.hallway_mode = rand_key_by_probs { few=10, some=90, heaps=30 }
  gui.printf("Hallway Mode: %s\n", PLAN.hallway_mode)

  PLAN.liquid_mode = rand_key_by_probs { few=15, some=60, heaps=20 }
  gui.printf("Liquid Mode: %s\n", PLAN.liquid_mode)

  PLAN.junk_mode = rand_key_by_probs { few=10, some=60, heaps=20 }
  gui.printf("Junk Mode: %s\n", PLAN.junk_mode)

  PLAN.cage_mode = rand_key_by_probs { none=50, some=50, heaps=6 }
  gui.printf("Cage Mode: %s\n", PLAN.cage_mode)

  PLAN.pillar_mode = rand_key_by_probs { few=10, some=70, heaps=20 }
  gui.printf("Pillar Mode: %s\n", PLAN.pillar_mode)

  PLAN.fence_mode = rand_key_by_probs { none=30, few=30, some=10 }
  gui.printf("Fence Mode: %s\n", PLAN.fence_mode)

  PLAN.window_mode = rand_key_by_probs { few=30, some=90, heaps=10 }
  gui.printf("Window Mode: %s\n", PLAN.window_mode)

  PLAN.picture_mode = rand_key_by_probs { few=10, some=50, heaps=10 }
  gui.printf("Picture Mode: %s\n", PLAN.picture_mode)

  PLAN.symmetry_mode = rand_key_by_probs { few=30, some=60, heaps=10 }
  gui.printf("Symmetry Mode: %s\n", PLAN.symmetry_mode)


--[[ ]]
PLAN.liquid_mode = "some"
PLAN.hallway_mode = "few"
PLAN.symmetry_mode = "some"
PLAN.junk_mode = "some"
PLAN.sky_mode = "few"

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
  end

  for _,R in ipairs(PLAN.scenic_rooms) do
    Layout_scenic(R)
  end

  Rooms_border_up()

  for _,R in ipairs(PLAN.scenic_rooms) do Room_build_seeds(R) end
  for _,R in ipairs(PLAN.all_rooms)    do Room_build_seeds(R) end
end

