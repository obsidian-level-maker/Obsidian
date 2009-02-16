----------------------------------------------------------------
--  Room Layouting
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
require 'ht_fabs'


function Test_room_fabs()
  
  local function pos_size(s, n)
    local ch = string.sub(s, n, n)
        if ch == 'A' then return 10
    elseif ch == 'B' then return 11
    elseif ch == 'C' then return 12
    elseif ch == 'D' then return 13
    else return 0 + (ch)
    end
  end

  local function total_size(s)
    local total = 0
    for i = 1,#s do
      total = total + pos_size(s, i)
    end
    return total
  end

  local function pad_line(src, x_sizes)
    assert(#src == #x_sizes)

    local padded = ""

    for x = 1,#x_sizes do
      local x_num = pos_size(x_sizes, x)
      local ch = string.sub(src, x, x)

      for i = 1,x_num do
        padded = padded .. ch
      end
    end

    return padded
  end

  local function dump_one_pattern(info, x_sizes, y_sizes)
    assert(#info.structure == #y_sizes)

    for y = #y_sizes,1,-1 do
      local y_num = pos_size(y_sizes, y)
      local src = assert(info.structure[#y_sizes+1 - y])
      local padded = pad_line(src, x_sizes)
      for i = 1,y_num do
        gui.printf("  %s\n", padded)
      end
    end

    gui.printf("\n")
  end

  local function show_pattern(name, info, long, deep)
    assert(info.structure)
    assert(info.x_sizes)
    assert(info.y_sizes)

    gui.printf("==== %s %dx%d ==================\n\n", name, long, deep)

    local count = 0

    for _,ys in ipairs(info.y_sizes) do
      if total_size(ys) == deep then
        for _,xs in ipairs(info.x_sizes) do
          if total_size(xs) == long then
            dump_one_pattern(info, xs, ys)
            count = count + 1
          end
        end -- for xs
      end
    end -- for ys

    if count == 0 then
      gui.printf("Unsupported size\n\n")
    end
  end

  local function check_lines(info)
    local width = #info.structure[1]

    for _,line in ipairs(info.structure) do
      if #line ~= width then
        error("Bad structure (uneven widths)")
      end
    end
  end

  local function check_subs(info)
    local used_subs = {}

    -- first check the digits in the structure
    for y,line in ipairs(info.structure) do
      for x = 1,#line do
        local ch = string.sub(line, x, x)
        if ch == '0' then error("Invalid sub '0'") end
        if is_digit(ch) then
          local s_idx = 0 + ch  -- convert to number
          assert(s_idx >= 1 and s_idx <= 9)
          if not (info.subs and info.subs[s_idx]) then
            error("Missing subs entry [" .. ch .. "]")
          end

          -- determine 2D extent of sub-area
          local P = used_subs[s_idx]
          if not P then
            P = { x1=x, x2=x, y1=y, y2=y, ch=ch }
            used_subs[s_idx] = P
          else
            P.x1 = math.min(P.x1, x)
            P.y1 = math.min(P.y1, y)

            P.x2 = math.max(P.x2, x)
            P.y2 = math.max(P.y2, y)
          end
        end
      end -- for x
    end -- for y

    -- now make sure each sub-area is a full rectangle shape
    for _,P in ipairs(used_subs) do
      for x = P.x1,P.x2 do for y = P.y1,P.y2 do
        local line = info.structure[y]
        local ch = string.sub(line, x, x)
        if ch ~= P.ch then
          error("Bad shape for sub area (not a full rectangle)")
        end
      end end -- for x, y
    end

    -- check that each entry in info.subs is used
    for s_idx,_ in pairs(info.subs or {}) do
      if not used_subs[s_idx] then
        gui.printf("WARNING: sub entry %s is unused!\n", s_idx)
      end
    end
  end

  local function match_x_char(LC, RC)
    if LC == '<' then return (RC == '>') end
    if LC == '>' then return (RC == '<') end
    if LC == '/' then return (RC == '%') end
    if LC == '%' then return (RC == '/') end
    if LC == 'Z' then return (RC == 'N') end
    if LC == 'N' then return (RC == 'Z') end

    -- having different sub-areas is OK
    if is_digit(LC) and is_digit(RC) then return true end

    return (LC == RC)
  end

  local function match_y_char(TC, BC)
    if TC == '^' then return (BC == 'v') end
    if TC == 'v' then return (BC == '^') end
    if TC == '/' then return (BC == '%') end
    if TC == '%' then return (BC == '/') end
    if LC == 'Z' then return (RC == 'N') end
    if LC == 'N' then return (RC == 'Z') end

    -- having different sub-areas is OK
    if is_digit(TC) and is_digit(BC) then return true end

    return (TC == BC)
  end

  local function check_string_sym(mesg, s)
    local half_x = int(#s / 2)

    for x = 1,half_x do
      local x2 = #s+1 - x
      local LC = string.sub(s, x, x)
      local RC = string.sub(s, x2, x2)

      if not match_x_char(LC, RC) then
        error("Broken symmetry: " .. mesg)
      end
    end
  end

  local function check_vert_sym(top, bottom)
    assert(#top == #bottom)

    for x = 1,#top do
      local TC = string.sub(top, x, x)
      local BC = string.sub(bottom, x, x)

      if not match_y_char(TC, BC) then
        error("Broken symmetry: " .. mesg)
      end
    end
  end

  local function check_symmetry(info)
    -- Note: while it is techniclly possible to create a symmetrical
    -- pattern using non-symmetrical structure or size strings, we
    -- do not allow for that here.

    if info.symmetry == "x" or info.symmetry == "xy" then
      for _,line in ipairs(info.structure) do
        check_string_sym("structure X", line)
      end
      for _,xs in ipairs(info.x_sizes) do
        check_string_sym("x_size", xs)
      end
    end

    if info.symmetry == "y" or info.symmetry == "xy" then
      local half_y = int (#info.structure / 2)
      for y = 1,half_y do
        local top    = info.structure[y]
        local bottom = info.structure[#info.structure+1-y]

        check_vert_sym(top, bottom)
      end

      for _,ys in ipairs(info.y_sizes) do
        check_string_sym("y_size", ys)
      end
    end
  end

  local function show_fab_list(f_name, f_table)
    for name,info in pairs(f_table) do
      gui.printf("%s FAB: %s\n\n", f_name, name)

      check_lines(info)
      check_subs(info)
      check_symmetry(info)

      for deep = 2,11 do for long = 2,11 do
        show_pattern(name, info, long, deep)
      end end
    end
  end


  ---| Test_room_fabs |---
  
  show_fab_list("HEIGHT", HEIGHT_FABS)
  show_fab_list("SOLID",  SOLID_FABS)
  show_fab_list("LIQUID", LIQUID_FABS)

  error("TEST SUCCESSFUL")
end



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
      if R.sw == 4 then prob = prob / 2 end
      if R.sw == 3 then prob = prob / 5 end
--    if R.sw == 2 then prob = prob / 10 end
      if R.sw <= 2 then return 0 end
    end

    if new_sym == "y" or new_sym == "xy" then
      if R.sh == 4 then prob = prob / 2 end
      if R.sh == 3 then prob = prob / 5 end
--    if R.sh == 2 then prob = prob / 10 end
      if R.sh <= 2 then return 0 end
    end

    return prob

    --[[ OLD LOGIC -- USEFUL??
    -- two seeds for each connection
    local count = #R.conns * 2

    -- one seed for purpose (key/switch/etc)
    if R.purpose or #R.conns == 1 then
      count = count + 1
    end

    -- one seed for each row/column (space for monsters etc)
    count = count + math.max(R.sw, R.sh)

    if count > R.svolume then
      return false
    end

    return true --OK--  ]]
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


function Room_spot_for_wotsit(R, kind)
  local spots = {}

  for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
    local S = SEEDS[x][y][1]

    if S.room == R and S.kind == "walk" then
      local P = { x=x, y=y, S=S }

      P.score = gui.random() + (S.div_lev or 0) * 100

      if R.entry_conn then
        local dx = math.abs(R.entry_conn.dest_S.sx - x)
        local dy = math.abs(R.entry_conn.dest_S.sy - y)

        P.score = P.score + 50 + dx + dy
      end

      table.insert(spots, P)
    end
  end end -- for x, y


  local P = table_pick_best(spots,
        function(A,B) return A.score > B.score end)

  if not P then
    error("No usable spots in room!")
  end

  P.S.kind = "purpose"

  return P.x, P.y, P.S
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
      local d_left
      local d_right

      local N4 = S:neighbor(4)
      local N6 = S:neighbor(6)

      if not (N4 and N4.room and N4.room == R) or (N4 and N4.kind == "void") then
        d_left = "void"
      elseif N4.kind == "walk" and N4.floor_h then
        d_left = "ledge"
      end

      if not (N6 and N6.room and N6.room == R) or (N6 and N6.kind == "void") then
        d_right = "void"
      elseif N6.kind == "walk" and N6.floor_h then
        d_right = "ledge"
      end


      local diag_info =
      {
        t_face = { texture=f_tex },
        b_face = { texture=c_tex },
        w_face = { texture=w_tex },
      }

      if d_left == "void" and d_right == "void" then
        S.kind = "void"

      elseif d_left == d_right then
        S.kind = "walk"

      elseif d_left == "void" or d_right == "void" then
        local d_side

        if S.diag_char == '/' then
          d_side = sel(d_left == "void", 7, 3)

        else assert(S.diag_char == '%')
          d_side = sel(d_left == "void", 1, 9)
        end

        Build_diagonal(S, d_side, diag_info)

      elseif d_left == "ledge" or d_right == "ledge" then
        local d_side

        if S.diag_char == '/' then
          d_side = sel(d_left == "ledge", 7, 3)

        else assert(S.diag_char == '%')
          d_side = sel(d_left == "ledge", 1, 9)
        end

        local ledge_h

        if d_left == "ledge" then
          ledge_h = assert(N4 and N4.floor_h)
        else
          ledge_h = assert(N6 and N6.floor_h)
        end

        Build_diagonal(S, d_side, diag_info, ledge_h)

      else
        error("WTF diagonals: " .. tostring(d_left) .. " + " .. tostring(d_right))
      end


      if S.kind == "diagonal" or S.kind == "walk" then
        if S.diag_foobie == '~' then
          S.kind = "liquid"
        end
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
        w_face = { texture="ZZZFACE1" },
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
       (S.sx == S.room.sx1+1) and (S.sy == S.room.sy1+1) then
      -- THIS IS ESSENTIAL (for now) TO PREVENT FILLING by CSG

      local MON = next(GAME.monsters)
      assert(MON)
      MON = GAME.things[MON]
      assert(MON)
      assert(MON.id)

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


function Room_try_divide(R, is_top, div_lev, recurse, req_sym, area, heights, f_texs)
  -- find a usable pattern in the HEIGHT_FABS table and
  -- apply it to the room.

  -- this function is responsible for setting floor_h in every
  -- seed in the given 'area'.

  area.tw, area.th = box_size(area.x1, area.y1, area.x2, area.y2)

gui.debugf("Room_try_divide @ %s  div_lev:%d\n", R:tostr(), div_lev)
gui.debugf("Area: (%d,%d)..(%d,%d) heights: %d %d %d\n",
area.x1, area.y1, area.x2, area.y2,
heights[1] or -1, heights[2] or -1, heights[3] or -1)



  -- TODO: these little functions are duplicated in Test_height_patterns
  local function pos_size(s, n)
    local ch = string.sub(s, n, n)
        if ch == 'A' then return 10
    elseif ch == 'B' then return 11
    elseif ch == 'C' then return 12
    elseif ch == 'D' then return 13
    else return 0 + (ch)
    end
  end

  local function total_size(s)
    local total = 0
    for i = 1,#s do
      total = total + pos_size(s, i)
    end
    return total
  end

  local function pad_line(src, x_sizes)
    assert(#src == #x_sizes)

    local padded = ""

    for x = 1,#x_sizes do
      local x_num = pos_size(x_sizes, x)
      local ch = string.sub(src, x, x)

      for i = 1,x_num do
        padded = padded .. ch
      end
    end

    return padded
  end

  local function matching_sizes(list, dim)
    local result
    
    for _,sz in ipairs(list) do
      if total_size(sz) == dim then
        if not result then result = {} end
        table.insert(result, sz)
      end
    end

    return result
  end

  local function expand_structure(T, info, x_sizes, y_sizes)
    T.expanded = {}

    for y = 1,#y_sizes do
      local y_num = pos_size(y_sizes, y)
      local src = info.structure[#y_sizes+1 - y]
      local padded = pad_line(src, x_sizes)
      for i = 1,y_num do
        table.insert(T.expanded, 1, padded)
      end
    end
  end

  local function plain_walk(ch)
    return ch == '.' or is_digit(ch)
  end

  local TRANSPOSE_DIR_TAB = { 1,4,7,2,5,8,3,6,9 }

  local TRANSPOSE_CHAR_TAB =
  {
    ['<'] = 'v',  ['v']  = '<',
    ['>'] = '^',  ['^']  = '>',
    ['/'] = 'Z',  ['Z']  = '/',
    ['%'] = 'N',  ['N']  = '%',
    ['-'] = '|',  ['|']  = '-',
    ['!'] = '=',  ['=']  = '!',
  }

  local function morph_coord(T, i, j)
    if T.x_flip then i = T.long+1 - i end
    if T.y_flip then j = T.deep+1 - j end

    if T.transpose then
      i, j = j, i
    end

    return area.x1 + i-1, area.y1 + j-1
  end

  local function morph_dir(T, dir)
    if T.x_flip and is_horiz(dir) then dir = 10-dir end
    if T.y_flip and is_vert(dir)  then dir = 10-dir end

    if T.transpose then dir = TRANSPOSE_DIR_TAB[dir] end

    return dir
  end

  local function morph_char(T, ch)
    if T.x_flip then
          if ch == '<' then ch = '>'
      elseif ch == '>' then ch = '<'
      elseif ch == '/' then ch = '%'
      elseif ch == '%' then ch = '/'
      elseif ch == 'Z' then ch = 'N'
      elseif ch == 'N' then ch = 'Z'
      end
    end

    if T.y_flip then
          if ch == 'v' then ch = '^'
      elseif ch == '^' then ch = 'v'
      elseif ch == '/' then ch = '%'
      elseif ch == '%' then ch = '/'
      elseif ch == 'Z' then ch = 'N'
      elseif ch == 'N' then ch = 'Z'
      end
    end

    if T.transpose and TRANSPOSE_CHAR_TAB[ch] then
      ch = TRANSPOSE_CHAR_TAB[ch]
    end

    return ch
  end

  local function find_sub_area(T, match_ch)
    local x1, y1 = 999, 999
    local x2, y2 =-9, -9

    for i = 1,T.long do for j = 1,T.deep do
      local x, y = morph_coord(T, i, j)
      local ch = string.sub(T.expanded[T.deep+1-j], i, i)

      if ch == match_ch then
        if x < x1 then x1 = x end
        if y < y1 then y1 = y end
        if x > x2 then x2 = x end
        if y > y2 then y2 = y end
      end
    end end -- for i, j

    if x2 < 0 then return nil end

    return { x1=x1, y1=y1, x2=x2, y2=y2 }
  end

  local function set_seed_floor(S, h, f_tex)
    S.floor_h = h

    if not R.outdoor then
      S.f_tex = f_tex
    end

    if S.conn or S.pseudo_conn then
      local C = S.conn or S.pseudo_conn
      if C.conn_h then assert(C.conn_h == S.floor_h) end

      C.conn_h = S.floor_h
      C.conn_ftex = f_tex
    end
  end

  local function setup_stair(S, ch, hash_h, f_tex)
    local dir
    if ch == 'v' then dir = 2 end
    if ch == '<' then dir = 4 end
    if ch == '>' then dir = 6 end
    if ch == '^' then dir = 8 end
    assert(dir)

    local N = S:neighbor(dir)
    assert(N)
    assert(N.room == R)
    assert(R:contains_seed(N.sx, N.sy))

    S.stair_z1 = assert(hash_h)  
    S.stair_z2 = assert(N.floor_h)

    -- check if a stair is really needed
    if math.abs(S.stair_z1 - S.stair_z2) < 21 then
      hash_h = int((S.stair_z1 + S.stair_z2) / 2)

      S.kind = "walk"
      S.stair_z1 = nil
      S.stair_z2 = nil

      return set_seed_floor(S, hash_h, f_tex)
    end

    S.kind = "stair"
    S.stair_dir = dir

    assert(not S.conn)
    S.floor_h = hash_h

    if not R.outdoor then
      S.f_tex = f_tex
    end
  end

---#  local function has_void_neighbor(T, S, i, j)
---#    for side = 2,8,2 do
---#      -- check the room
---#      local N = S:neighbor(side)
---#      if not (N and N.room and N.room == R) then return true end
---#      if N and N.kind == "void" then return true end
---#
---#      -- check the pattern
---#      i, j = nudge_coord(i, j, side)
---#
---#      if (1 <= i and i <= T.long) and (1 <= j and j <= T.deep) then
---#        local ch = string.sub(T.expanded[T.deep+1-j], i, i)
---#        if ch == 'S' then return true end
---#      end
---#    end
---#
---#    return false
---#  end


  local function eval_fab(T)
gui.debugf("eval_fab...\nT =\n%s\n\nexpanded=\n%s\n\n", table_to_str(T,1), table_to_str(T.expanded,3))
-- gui.debugf("T = %s\n\n", table_to_str(T,1))
-- gui.debugf("expanded = %s\n\n", table_to_str(T.expanded,3))

    T.has_focus = false

    -- check symmetry
    local info_sym = T.info.symmetry
    if info_sym == "R" then info_sym = nil end
    if T.transpose then
          if info_sym == "x" then info_sym = "y"
      elseif info_sym == "y" then info_sym = "x"
      end
    end

    if not (not req_sym or req_sym == info_sym or info_sym == "xy") then
gui.debugf("SYMMETRY MISMATCH (%s ~= %s\n", req_sym or "NONE", info_sym or "NONE")
      return -1
    end

    -- check if enough heights are available
    if T.info.subs then
      for _,sub in ipairs(T.info.subs) do
        if (sub.height + 1) > #heights then
gui.debugf("NOT ENOUGH HEIGHTS\n")
        return -1 end
      end
    end

    local score = gui.random() * 99

    local matches = {}

    for i = 1,T.long do for j = 1,T.deep do
      local x, y = morph_coord(T, i, j)
      assert(Seed_valid(x, y, 1))

      local S = SEEDS[x][y][1]
      assert(S and S.room == R)

      local ch = string.sub(T.expanded[T.deep+1-j], i, i)
      assert(ch)
      ch = morph_char(T, ch)

      if (S.conn or S.pseudo_conn or S.must_walk) then
        -- TODO: if stair is "flat" (dest height == '.' height) then
        --       allow connection to sit on it.
        if not plain_walk(ch) then
gui.debugf("CONN needs PLAIN WALK\n")
          return -1
        end

        if is_digit(ch) then
          local s_idx = (0 + ch)
          matches[s_idx] = (matches[s_idx] or 0) + 1
---??     score = score + 20
        end
      end

      if ch == '.' and S.conn == R.focus_conn then
        T.has_focus = true
      end

    end end -- for i, j

    -- for top-level pattern we require focus seed to hit a '.'
    if is_top and not T.has_focus then
gui.debugf("FOCUS not touch dot\n");
      return -1
    end

    -- check sub-area matches
    if T.info.subs then
      for s_idx,sub in ipairs(T.info.subs) do
        if sub.match == "one"  and not matches[s_idx] and
           not (R.kind == "purpose") then return -1 end

        if sub.match == "none" and matches[s_idx] then return -1 end

        if sub.match == "any" and matches[s_idx] then
          score = score + 100
        end
      end
    end

gui.debugf("OK : score = %1.4f\n", score)
    return score
  end

  local function install_fab(T, hash_h, hash_ftex, hash_lev)

local ax,ay = morph_coord(T, 1,1)
local bx,by = morph_coord(T, T.long,T.deep)
gui.debugf("install_fab :  hash_h:%d  (%d,%d)..(%d,%d)\n", hash_h,
math.min(ax,bx), math.min(ay,by), math.max(ax,bx), math.max(ay,by))

--gui.debugf("T = %s\n\n", table_to_str(T,1))
--gui.debugf("expanded = %s\n\n", table_to_str(T.expanded,3))

    for i = 1,T.long do for j = 1,T.deep do
      local x, y = morph_coord(T, i, j)
      local S = SEEDS[x][y][1]

      local ch = string.sub(T.expanded[T.deep+1-j], i, i)
      ch = morph_char(T, ch)

      if is_digit(ch) then
        -- nothing to do, handled by recursive call

      else
        if ch == '.' then
          set_seed_floor(S, hash_h, hash_ftex)
          S.div_lev = hash_lev
  --- if true then S.ceil_h = S.floor_h + 256 ; S.c_tex = "FLAT10" end

        elseif ch == '<' or ch == '>' or
               ch == 'v' or ch == '^' then
          setup_stair(S, ch, hash_h, hash_ftex)

        elseif ch == '/' or ch == '%' then
          set_seed_floor(S, hash_h, hash_ftex)

          S.kind = "diagonal"
          S.diag_char = ch
          S.diag_foobie = T.info.foobie

        elseif ch == 'S' then
          S.kind = "void"

        elseif ch == '~' then
          -- NOTE: floor_h for liquids is determined later
          S.kind = "liquid"

        else
          error("unknown symbol in room fab: '" .. tostring(ch) .. "'")
        end
      end

    end end -- for i, j
gui.debugf("end install_fab\n")
  end

  local function install_flat_floor(h, f_tex)
    for x = area.x1,area.x2 do for y = area.y1,area.y2 do
      local S = SEEDS[x][y][1]
      if S.room == R and not S.floor_h then
        set_seed_floor(S, h, f_tex)
        S.div_lev = div_lev
      end
    end end -- for x, y
  end


  local function mirror_seed(S, N, sym)
    -- S : destination
    -- N : source (peer)

    if N.kind == "walk" and not N.floor_h then
gui.debugf("S =\n%s\n\n", table_to_str(S, 1))
gui.debugf("N =\n%s\n\n", table_to_str(N, 1))
      error("mirror_seed : peer not setup yet!")
    end

    S.kind    = assert(N.kind)
    S.div_lev = N.div_lev

    S.floor_h = N.floor_h
    S.ceil_h  = N.ceil_h

    S.f_tex   = N.f_tex
    S.c_tex   = N.c_tex
    S.w_tex   = N.w_tex

    -- NB: logic copied from set_seed_floor()
    if S.conn or S.pseudo_conn then
      local C = S.conn or S.pseudo_conn
      if C.conn_h then assert(C.conn_h == S.floor_h) end

      C.conn_h = S.floor_h
      if S.f_tex then C.conn_ftex = S.f_tex end
    end

    if N.kind == "diagonal" then
          if N.diag_char == '/' then S.diag_char = '%'
      elseif N.diag_char == '%' then S.diag_char = '/'
      else error("WTF diagonal")
      end
    end

    if N.kind == "stair" then
      S.stair_z1 = assert(N.stair_z1)
      S.stair_z2 = assert(N.stair_z2)

      S.stair_dir = assert(N.stair_dir)

      if sym == "x" and is_horiz(S.stair_dir) then
        S.stair_dir = 10 - S.stair_dir
      end

      if sym == "y" and is_vert(S.stair_dir) then
        S.stair_dir = 10 - S.stair_dir
      end
    end
  end

  local function symmetry_fill(T, box)
    gui.debugf("Symmetry fill @ %s : (%d %d) -> (%d %d)\n",
               R:tostr(), box.x1, box.y1, box.x2, box.y2)

gui.debugf("Fab.symmetry = %s\n", tostring(T.info.symmetry))
gui.debugf("Room.symmetry = %s\n", tostring(R.symmetry))
gui.debugf("Transposed : %s\n", bool_str(T.transpose))

    -- TODO: support "xy" symmetrical fabs
    assert(T.info.symmetry == "x" or T.info.symmetry == "y")

    local do_x = (T.info.symmetry == "x")
    local do_y = (T.info.symmetry == "y")

    if T.transpose then do_x,do_y = do_y,do_x end

---##    local mx = (box.x1 + box.x2) / 2 - 0.1
---##    local my = (box.y1 + box.y2) / 2 - 0.1

    for x = box.x1,box.x2 do for y = box.y1,box.y2 do
      local S = SEEDS[x][y][1]
      assert(S and S.room == R)

      if S.kind == "walk" and not S.floor_h then
        if do_x then
          local nx = area.x2 - (x - area.x1)
          assert(Seed_valid(nx, y, 1))

          local N = SEEDS[nx][y][1]
          assert(N and N.room == R)

          mirror_seed(S, N, "x")

        elseif do_y then
          local ny = area.y2 - (y - area.y1)
          assert(Seed_valid(x, ny, 1))

          local N = SEEDS[x][ny][1]
          assert(N and N.room == R)

          mirror_seed(S, N, "y")

        else
          error("symmetry_fill : no peer to copy!")
        end
      end
    end end -- for x, y
  end

  local function mark_stair_dests(T)

    for i = 1,T.long do for j = 1,T.deep do
      local x, y = morph_coord(T, i, j)
      local S = SEEDS[x][y][1]

      local ch = string.sub(T.expanded[T.deep+1-j], i, i)
      ch = morph_char(T, ch)

      local dir
          if ch == '<' then dir = 4
      elseif ch == '>' then dir = 6
      elseif ch == 'v' then dir = 2
      elseif ch == '^' then dir = 8
      end

      if dir then
        local N = S:neighbor(dir)
        assert(N and N.room == R)
        
        N.must_walk = true
      end

    end end -- for i, j
  end

  local function clip_heights(tab, where)
    assert(tab and #tab >= 1)

    local new_tab = shallow_copy(tab)

    for i = 1,where do
      table.remove(new_tab, 1)
    end

    assert(#new_tab >= 1)
    return new_tab
  end

  local function try_install_pattern(name, info)
    local possibles = {}

    local T = { info=info }

    for tr_n = 0,1 do
      T.transpose = (tr_n == 1)

      T.long = sel(T.transpose, area.th, area.tw)
      T.deep = sel(T.transpose, area.tw, area.th)

      T.x_sizes = matching_sizes(info.x_sizes, T.long)
      T.y_sizes = matching_sizes(info.y_sizes, T.deep)

gui.debugf("  tr:%s  long:%d  deep:%d\n", bool_str(T.transpose), T.long, T.deep)
      if T.x_sizes and T.y_sizes then
        local xs = rand_element(T.x_sizes)
        local ys = rand_element(T.y_sizes)

        expand_structure(T, info, xs, ys)

        for xf_n = 0,1 do for yf_n = 0,1 do
          T.x_flip = (xf_n == 1)
          T.y_flip = (yf_n == 1)

          T.score = eval_fab(T)

          if T.score > 0 then
            table.insert(possibles, shallow_copy(T))
          end
        end end -- for xf_n, yf_n
      end 
    end -- for tr_n

    if #possibles == 0 then
      return false
    end

gui.debugf("Possible patterns:\n%s\n", table_to_str(possibles, 2))

    T = table_pick_best(possibles,
        function(A,B) return A.score > B.score end)

gui.debugf("Chose pattern with score %1.4f\n", T.score)

    -- recursive sub-division

    mark_stair_dests(T)

    if info.subs then
      for s_idx,sub in ipairs(info.subs) do
        local new_area = find_sub_area(T, tostring(s_idx))
        assert(new_area)

        if sub.sym_fill and (req_sym or rand_odds(50)) then --!!!!
          symmetry_fill(T, new_area)
        else
          local new_hs = clip_heights(heights, sub.height)
          local new_ft = clip_heights(f_texs,  sub.height)

          local new_recurse = sub.recurse or true
          local new_sym = sel(sub.drop_sym, nil, req_sym)

          Room_try_divide(R, false, div_lev+1, new_recurse,
                          new_sym, new_area, new_hs, new_ft)
        end
      end
    end


    assert(heights[1])

    -- this must occur after sub-division (for stairs)
    install_fab(T, heights[1], f_texs[1], div_lev)

    return true  -- YES !!
  end


  local function can_use_fab(info)
    if (info.environment == "indoor"  and R.outdoor) or
       (info.environment == "outdoor" and not R.outdoor)
    then
      return false -- wrong environment
    end

    if (info.z_direction == "up"   and (#heights < 2 or (heights[1] > heights[2]))) or
       (info.z_direction == "down" and (#heights < 2 or (heights[1] < heights[2])))
    then
      return false -- wrong z_direction
    end

    if (info.level == "top" and not is_top) or
       (info.level == "sub" and is_top)
    then
      return false -- wrong level
    end

    -- enough symmetry?
    -- [NOTE: because of transposing, treat "x" == "y" here]
    if not req_sym then return true end
    if info.symmetry == "xy" then return true end

    if req_sym == "xy" then return false end
    if not info.symmetry or info.symmetry == "R" then return false end

    return true --OK--
  end

  local function add_fab_list(probs, infos, fabs, mul)
    for name,info in pairs(fabs) do
      if can_use_fab(info) then
        infos[name] = info
        probs[name] = (info.prob or 50) * mul
      end
    end
  end

  local function do_try_divide()
    if R.children then return false end

    assert(R.kind ~= "hallway")
    assert(R.kind ~= "stairwell")

    -- some chance of not dividing at all
    local skip_prob = 50 - (area.tw + area.th) * 4
    if skip_prob > 0 and rand_odds(skip_prob) then
      return false
    end

    local sol_mul = 3.0
    if PLAN.junk_mode == "heaps" then sol_mul = 6.0 end

    local liq_mul = 0.6
    if PLAN.liquid_mode == "few"   then liq_mul = 0.1 end
    if PLAN.liquid_mode == "heaps" then liq_mul = 7.0 end

    local f_probs = {}
    local f_infos = {}

    add_fab_list(f_probs, f_infos, HEIGHT_FABS, 1.0)
    add_fab_list(f_probs, f_infos, SOLID_FABS,  sol_mul)
    add_fab_list(f_probs, f_infos, LIQUID_FABS, liq_mul)


    local try_count = 8 + R.sw + R.sh

    for loop = 1,try_count do
      if table_empty(f_probs) then
        break;
      end

      local which = rand_key_by_probs(f_probs)
      f_probs[which] = nil

      gui.debugf("Trying pattern %s in %s (loop %d)......\n",
                 which, R:tostr(), loop)

      if try_install_pattern(which, f_infos[which]) then
        gui.debugf("SUCCESS with %s!\n", which)
        return true
      end
    end

    gui.debugf("FAILED to apply any room pattern.\n")
    return false
  end


  ---==| Room_divide |==---
 
  if recurse and do_try_divide() then
gui.debugf("Success @ %s (div_lev %d)\n\n", R:tostr(), div_lev)
  else
gui.debugf("Failed @ %s (div_lev %d)\n\n", R:tostr(), div_lev)
    install_flat_floor(heights[1], f_texs[1])
  end
end


function Room_choose_corner_stairs(R)

  local function try_convert_tall_stair(S, x, y, dir)
    local B = S:neighbor(10-dir)

    if B and B.room == S.room and B.kind ~= "void" then
      return  -- not possible
    end

    -- they look crappy outside
    if S.room.outdoor then return end

    if dir == 2 or dir == 8 then
      
      for other = 4,6,2 do
        local N = S:neighbor(other)

        if not N or N.room ~= S.room or N.kind == "void" then

          S.kind = "curve_stair"
          S.stair_kind = "tall"
          S.y_side = dir
          S.y_height = S.stair_z1
          S.x_side = 10-other
          S.x_height = S.stair_z2

          gui.debugf("TALL CURVE STAIR @ SEED (%d,%d)\n", S.sx, S.sy)
        end
      end

    else -- dir == 4 or dir == 6

      for other = 2,8,6 do
        local N = S:neighbor(other)

        if not N or N.room ~= S.room or N.kind == "void" then

          S.kind = "curve_stair"
          S.stair_kind = "tall"
          S.x_side = dir
          S.x_height = S.stair_z1
          S.y_side = 10-other
          S.y_height = S.stair_z2

          gui.debugf("TALL CURVE STAIR @ SEED (%d,%d)\n", S.sx, S.sy)
        end
      end
    end
  end

  local function try_convert_low_stair(S, x, y, dir)
    if S.kind ~= "stair" then return end

    local high_z = math.max(S.stair_z1, S.stair_z2)

    local B = S:neighbor(10-dir)
    if B and B.room == S.room and B.kind == "stair" then return end

    if dir == 2 or dir == 8 then
      
      for other = 4,6,2 do
        local N1 = S:neighbor(other)
        local N2 = S:neighbor(10-other)

        if (not N1 or N1.room ~= S.room or N1.kind == "void" or N1.floor_h >= high_z+32)
           and not (N1 and N1.kind == "stair") and
           (N2 and N2.room == S.room and N2.kind == "walk" and N2.floor_h == high_z)
        then
          S.kind = "curve_stair"
          S.stair_kind = "low"
          S.y_side = dir
          S.y_height = S.stair_z1
          S.x_side = 10-other
          S.x_height = S.stair_z2

          gui.debugf("LOW CURVE STAIR @ SEED (%d,%d)\n", S.sx, S.sy)
        end
      end

    else -- dir == 4 or dir == 6

      for other = 2,8,6 do
        local N1 = S:neighbor(other)
        local N2 = S:neighbor(10-other)

        if (not N1 or N1.room ~= S.room or N1.kind == "void" or N1.floor_h >= high_z+32)
           and not (N1 and N1.kind == "stair") and
           (N2 and N2.room == S.room and N2.kind == "walk" and N2.floor_h == high_z)
        then
          S.kind = "curve_stair"
          S.stair_kind = "low"
          S.x_side = dir
          S.x_height = S.stair_z1
          S.y_side = 10-other
          S.y_height = S.stair_z2

          gui.debugf("LOW CURVE STAIR @ SEED (%d,%d)\n", S.sx, S.sy)
        end
      end
    end
  end

  ---| Rooms_choose_corner_stairs |---

  for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
    local S = SEEDS[x][y][1]
    if S.room == R and S.kind == "stair" then
      try_convert_tall_stair(S, x, y, S.stair_dir)
      try_convert_low_stair(S, x, y, S.stair_dir)
    end
  end end -- for x, y
end


function Room_set_floor_minmax(R)
  local min_h =  9e9
  local max_h = -9e9

  for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
    local S = SEEDS[x][y][1]
    if S.room == R and 
       (S.kind == "walk" or S.kind == "purpose")
    then
      assert(S.floor_h)

      min_h = math.min(min_h, S.floor_h)
      max_h = math.max(max_h, S.floor_h)
    end
  end end -- for x, y

  assert(min_h <= max_h)

  R.floor_min_h = min_h
  R.floor_max_h = max_h

  R.fence_h  = R.floor_max_h + 30
  R.liquid_h = R.floor_min_h - 48

---#    for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
---#      local S = SEEDS[x][y][1]
---#      if S.room == R and S.kind == "liquid" then
---#        S.floor_h = R.liquid_h
---#      end
---#    end end -- for x, y
end


function Room_layout_scenic(R)

  local min_floor = 1000

  for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
    local S = SEEDS[x][y][1]
    if S.room == R then
      S.kind = "liquid"
      for side = 2,8,2 do
        local N = S:neighbor(side)
        if N and N.room and N.floor_h then
          min_floor = math.min(min_floor, N.floor_h)
        end
      end
    end
  end end -- for x,y

  if min_floor < 999 then
    local h1 = rand_irange(1,6)
    local h2 = rand_irange(1,6)

    R.liquid_h = min_floor - (h1 + h2) * 16
  else
    R.liquid_h = -24
  end
end


function Room_layout_hallway(R)

  local tx1,ty1, tx2,ty2 = R:conn_area()
  local tw = tx2 - tx1 + 1
  local th = ty2 - ty1 + 1

  local function T_fill()
    for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
      if x < tx1 or x > tx2 or y < ty1 or y > ty2 then
        SEEDS[x][y][1].kind = "void"
      end
    end end -- for x, y
  end

  local function make_O()
    for x = R.sx1+1,R.sx2-1 do for y = R.sy1+1,R.sy2-1 do
      local S = SEEDS[x][y][1]
      S.kind = "void"
    end end -- for x, y
  end

  local function make_L()
    local C1 = R.conns[1]
    local C2 = R.conns[2]

    local S1 = C1:seed(R)
    local S2 = C2:seed(R)

    if rand_odds(50) then S1,S2 = S2,S1 end

    for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
      if x < tx1 or x > tx2 or y < ty1 or y > ty2 or
         not (x == S1.sx or y == S2.sy)
      then
        SEEDS[x][y][1].kind = "void"
      end
    end end -- for x, y
  end

  local function criss_cross()
    -- block out seeds that don't "trace" from a connection
    local used_x = {}
    local used_y = {}

    for _,C in ipairs(R.conns) do
      local S = C:seed(R)
      if is_vert(S.conn_dir) then
        used_x[S.sx] = 1
      else
        used_y[S.sy] = 1
      end
    end

    -- all connections are parallel => fail
    if table_empty(used_x) or table_empty(used_y) then
      make_O()
      return
    end

    for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
      if x < tx1 or x > tx2 or y < ty1 or y > ty2 or
         not (used_x[x] or used_y[y])
      then
        SEEDS[x][y][1].kind = "void"
      end
    end end -- for x, y

    return true
  end


  ---| Room_layout_hallway |---

  local HALL_TEX   = { "BROWN1", "BROWNGRN", "GRAY1", "STARBR2" }
  local HALL_FLOOR = { "FLAT4", "CEIL5_1", "FLOOR1_1", "FLOOR3_3",  }
  local HALL_CEIL  = { "FLAT4", "CEIL5_1", "CEIL3_5", "CEIL3_3" }

  if not PLAN.hall_tex then
    PLAN.hall_tex   = rand_element(HALL_TEX)
    PLAN.hall_floor = rand_element(HALL_FLOOR)
    PLAN.hall_ceil  = rand_element(HALL_CEIL)

    PLAN.hall_trim   = rand_odds(50)
    PLAN.hall_lights = rand_odds(50)
  end


  local entry_C = assert(R.entry_conn)
  local h = assert(entry_C.conn_h)

  local O_CHANCES = { 0, 10, 40, 70 }
  local o_prob = O_CHANCES[math.min(4, #R.conns)]

  -- FIXME: more shapes (U, S)

  gui.debugf("Hall conn area: (%d,%d) .. (%d,%d)\n", tx1,ty1, tx2,ty2)

  if R.sw >= 3 and R.sh >= 3 and rand_odds(o_prob) then
    make_O()

  elseif tw == 1 or th == 1 then
    T_fill()

  elseif #R.conns == 2 then
    make_L()

  else
    criss_cross()
  end


  local height = 128
  local is_sky = false
  if rand_odds(30) then
    height = 192
  elseif rand_odds(10) then
    height = 256
    is_sky = true
  end

  for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
    local S = SEEDS[x][y][1]
    assert(S.room == R)
    if S.kind == "walk" then
      S.floor_h = h
      S.ceil_h = h + height

      S.f_tex = PLAN.hall_floor
      S.c_tex = PLAN.hall_ceil

      if is_sky then
        S.c_tex = PARAMS.sky_flat
      end
    end
  end end -- for x, y

  Room_set_floor_minmax(R)

  for _,C in ipairs(R.conns) do
    C.conn_h = h
  end
end



function Room_layout_one(R)

  local function junk_sides()
    -- Adds solid seeds (kind "void") to the edges of large rooms.
    -- These seeds can be put to other uses later, such as: cages,
    -- monster closets, or secrets.
    --
    -- The best side is on the largest axis (minimises number of
    -- junked seeds), and prefer no connections on that side.
    -- Each side is only junked once.

    -- FIXME: occasionaly make ledge-cages in OUTDOOR rooms

    local JUNK_PROBS = { 0, 0,  3, 12, 20, 30, 40, 50 }
    local JUNK_HEAPS = { 0, 0, 50, 75, 99, 99, 99, 99 }


---##    local function max_junking(size)
---##      if size < min_space then return 0 end
---##      return size - min_space
---##    end

    local function eval_side(side)
      local th = R.junk_thick[side]

---##       if side == 2 or side == 8 then
---##         if R.junk_thick[2] + R.junk_thick[8] >= y_max then return -1 end
---##       else
---##         if R.junk_thick[4] + R.junk_thick[6] >= x_max then return -1 end
---##       end

      if PLAN.junk_mode == "few" and rand_odds(70) then
        return false
      end

      -- size checking
      local long = R.sw - R.junk_thick[4] - R.junk_thick[6]
      local deep = R.sh - R.junk_thick[2] - R.junk_thick[8]

      if R.mirror_x then long = int((long+3) / 2) end
      if R.mirror_y then deep = int((deep+3) / 2) end

      if is_vert(side) then long,deep = deep,long end

      if long <= 2 then return false end

      long = math.min(long, 8)

      local prob = JUNK_PROBS[long]
      if PLAN.junk_mode == "heaps" then prob = JUNK_HEAPS[long] end

      assert(prob)
      if not rand_odds(prob) then return false end


      -- connection checking
      local x1,y1, x2,y2 = side_coords(side, R.sx1,R.sy1, R.sx2,R.sy2)
      local dx, dy = dir_to_delta(side)
      x1, y1 = x1-dx*th, y1-dy*th
      x2, y2 = x2-dx*th, y2-dy*th

      local hit_conn = 0

      for x = x1,x2 do for y = y1,y2 do
        for who = 1,3 do
          local S = SEEDS[x][y][1]
          if who == 2 then S = R.mirror_x and S.x_peer end
          if who == 3 then S = R.mirror_y and S.y_peer end

          if S then
            if S.room ~= R then return false end
            if not (S.kind == "walk" or S.kind == "void") then return false end

            if S.conn or S.pseudo_conn then
              hit_conn = hit_conn + 1
            end
          end
        end -- for who
      end end -- for x,y

      -- Cannot allow "gaps" for connections (yet....)
      if hit_conn > 0 then return false end

      return true
    end

    local function apply_junk_side(side)
      local th = R.junk_thick[side]

      local x1,y1, x2,y2 = side_coords(side, R.sx1,R.sy1, R.sx2,R.sy2)
      local dx, dy = dir_to_delta(side)
      x1, y1 = x1-dx*th, y1-dy*th
      x2, y2 = x2-dx*th, y2-dy*th

      local p_conns = {}

      for x = x1,x2 do for y = y1,y2 do
        for who = 1,3 do
          local S = SEEDS[x][y][1]
          if who == 2 then S = R.mirror_x and S.x_peer end
          if who == 3 then S = R.mirror_y and S.y_peer end

          if S then
            if S.conn or S.pseudo_conn then
              error("Junked CONN!")
--??              local P = { x=x-dx, y=y-dy, conn=S.conn or S.pseudo_conn }
--??              table.insert(p_conns, P)
            elseif S.kind == "walk" then
              S.kind = "void"
            end
          end
        end -- for who
      end end -- for x,y

--??      for _,P in ipairs(p_conns) do
--??        SEEDS[P.x][P.y][1].pseudo_conn = P.conn
--??      end

      R.junk_thick[side] = R.junk_thick[side] + 1

      gui.debugf("Junked side:%d @ %s\n", side, R:tostr())

      if (is_horiz(side) and R.mirror_x) or
         (is_vert(side) and R.mirror_y)
      then
        side = 10 - side

        R.junk_thick[side] = R.junk_thick[side] + 1

        gui.debugf("and Junked mirrored side:%d\n", side)
      end
    end


    --| junk_sides |--

    local SIDES = { 2,4 }
    if not R.mirror_x then table.insert(SIDES,6) end
    if not R.mirror_y then table.insert(SIDES,8) end

    rand_shuffle(SIDES)

    for _,side in ipairs(SIDES) do
      if eval_side(side) then
        apply_junk_side(side)
      end
    end

    R.tx1 = R.sx1 + R.junk_thick[4]
    R.ty1 = R.sy1 + R.junk_thick[2]

    R.tx2 = R.sx2 - R.junk_thick[6]
    R.ty2 = R.sy2 - R.junk_thick[8]

    R.tw, R.th = box_size(R.tx1, R.ty1, R.tx2, R.ty2)
  end


  local function dir_for_wotsit(S)
    local dirs  = {}
  
    for dir = 2,8,2 do
      local N = S:neighbor(dir)
      if N and N.room == R and N.kind == "walk" then
        table.insert(dirs, dir)
      end
    end

    if #dirs == 1 then return dirs[1] end

    if #dirs > 1 then return rand_element(dirs) end

    return rand_irange(1,4)*2
  end

  local function add_purpose()
    local sx, sy, S = Room_spot_for_wotsit(R, R.purpose)
    local z1 = S.floor_h or R.floor_h

    local mx, my = S:mid_point()

    if R.purpose == "START" then
      if rand_odds(10) then
        Build_raising_start(S, 6, z1, R.combo)
        gui.debugf("Raising Start made\n")
        S.no_floor = true
      else
        Build_pedestal(S, z1, "FLAT22")
      end

      local angle = 0  -- FIXME
      local dist = 56

      gui.add_entity(mx, my, z1 + 35,
      {
        name = tostring(GAME.things["player1"].id),
        angle = angle,
      })

      if GAME.things["player2"] then
        gui.add_entity(mx - dist, my, z1 + 35,
        {
          name = tostring(GAME.things["player2"].id),
          angle = angle,
        })

        gui.add_entity(mx + dist, my, z1 + 35,
        {
          name = tostring(GAME.things["player3"].id),
          angle = angle,
        })

        gui.add_entity(mx, my - dist, z1 + 35,
        {
          name = tostring(GAME.things["player4"].id),
          angle = angle,
        })
      end

    elseif R.purpose == "EXIT" then
      local CS = R.conns[1]:seed(R)
      local dir = dir_for_wotsit(S)

      if R.outdoor then
        Build_outdoor_exit_switch(S, dir, z1)
      else
        Build_exit_pillar(S, z1)
      end

    elseif R.purpose == "KEY" then
      Build_pedestal(S, z1, "CEIL1_2")
      gui.add_entity(mx, my, z1+40,
      {
        name = tostring(GAME.things[R.key_item].id),
      })
    elseif R.purpose == "SWITCH" then
gui.debugf("SWITCH ITEM = %s\n", R.do_switch)
      local LOCK = assert(R.lock_for_item)  -- eww
      local INFO = assert(GAME.switch_infos[R.do_switch])
      Build_small_switch(S, dir_for_wotsit(S), z1, INFO, LOCK.tag)

    else
      error("Room_layout_one: unknown purpose! " .. tostring(R.purpose))
    end
  end

  local function stairwell_height_diff(focus_C)
    local other_C = R.conns[2]
    if other_C == focus_C then other_C = R.conns[1] end

    assert(focus_C.conn_h)
    assert(not other_C.conn_h)

    other_C.conn_h = focus_C.conn_h

    if rand_odds(7) then
      -- no change
    else
      local delta = rand_element { -2,-2,-1, 1,2,2 }

      other_C.conn_h = other_C.conn_h + delta * 64

      if other_C.conn_h > 384 then other_C.conn_h = 384 end
      if other_C.conn_h <   0 then other_C.conn_h =   0 end
    end
  end

  local function flood_fill_for_junk()
    -- sets the floor_h (etc) for seeds in a junked side
    -- (which are ignored by Room_try_divide).

    gui.debugf("flood_fill_for_junk @ %s\n", R:tostr())

    local unset_list = {}

    for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
      local S = SEEDS[x][y][1]
      if S.room == R and S.kind == "walk" and not S.floor_h then
        if S.conn and S.conn.conn_h then
          S.floor_h = S.conn.conn_h
          S.f_tex   = S.conn.conn_ftex
        else
          table.insert(unset_list, S)
        end
      end
    end end -- for x, y

    local SIDES = { 2,4,6,8 }

    gui.debugf("  unset num: %d\n", #unset_list);

    while #unset_list > 0 do
      local new_list = {}

      for _,S in ipairs(unset_list) do
        local did_fix = false
        rand_shuffle(SIDES)
        for _,side in ipairs(SIDES) do
          local N = S:neighbor(side)
          if N and N.room and N.room == R and N.floor_h and
             (N.kind == "walk" or N.kind == "stair")
          then
            S.floor_h = N.floor_h
            S.f_tex   = N.f_tex
            did_fix   = true
            break;
          end
        end

        if not did_fix then
          table.insert(new_list, S)
        end
      end

      gui.debugf("  unset count now: %d\n", #new_list);

      if #new_list > 0 and #new_list == #unset_list then
        error("flood_fill_for_junk failed")
      end

      unset_list = new_list
    end
  end

  local function select_floor_texs(focus_C)
    local f_texs  = {}

    if focus_C.conn_ftex then
      table.insert(f_texs, focus_C.conn_ftex)
    end

    if R.combo.floors then
      for i = 1,4 do
        table.insert(f_texs, rand_element(R.combo.floors))
      end
    end
    
    while #f_texs < 4 do
      table.insert(f_texs, f_texs[1] or R.combo.floor)
    end

    return f_texs
  end

  local INDOOR_DELTAS  = { [64]=30, [96]=5,  [128]=10, [192]=2 }
  local OUTDOOR_DELTAS = { [48]=50, [96]=25, [144]=2 }

  local function select_heights(focus_C)

    local function gen_group(base_h, num, dir)
      local list = {}
      local delta_tab = sel(R.outdoor, OUTDOOR_DELTAS, INDOOR_DELTAS)

      for i = 1,num do
        table.insert(list, base_h)
        local delta = rand_key_by_probs(delta_tab)
        base_h = base_h + dir * delta
      end

      return list
    end


    ---| select_heights |---

    local base_h = focus_C.conn_h

    -- determine vertical momentum
    local mom_z = 0
    if R.entry_conn then
      local C2 = R.entry_conn.src.entry_conn
      if C2 and C2.conn_h and C2.conn_h ~= base_h then
        mom_z = sel(C2.conn_h < base_h, 1, -1)
      end 
      gui.debugf("Vertical momentum @ %s = %d\n", R:tostr(), mom_z)
    end

    local groups = {}

    for i = 1,10 do
      local dir = rand_sel(50, 1, -1)
      local hts = gen_group(base_h, 4, dir)

      local cost = math.abs(base_h - hts[4]) + gui.random()
      
      if dir ~= mom_z    then cost = cost + 100 end
      if hts[4] <= 0     then cost = cost + 200 end
      if hts[4] >= SKY_H then cost = cost + 300 end

      table.insert(groups, { hts=hts, dir=dir, cost=cost })
    end

    local g_info = table_pick_best(groups,
                      function(A,B) return A.cost < B.cost end)

    return g_info.hts
  end

  local PILLAR_PATTERNS =
  {
     "-2-",
     "1-1",
     "111",

     "-1-1-",
     "1-2-1",

     "1--1",
     "1111",

     "--1-1--",
     "-1---1-",
     "-1-2-1-",
     "1--2--1",
     "1-2-2-1",

     "-1--1-",
     "2-11-2",

     "--1--1--",
     "1-2--2-1",

     "--1-2-1--",
     "-1--2--1-",
     "-1-2-2-1-",
     "1---2---1",
     "2-1---1-2",

     "--1--2--1--",
     "-1---2---1-",
     "-1-1---1-1-",
     "1----2----1",
     "2--1---1--2",
  }

  local function can_pillar_pattern(side, offset, pat)
    local x1,y1, x2,y2 = side_coords(side, R.tx1,R.ty1, R.tx2,R.ty2)
    local pos = 1

    x1,y1 = nudge_coord(x1, y1, 10-side, offset)
    x2,y2 = nudge_coord(x2, y2, 10-side, offset)

    for x = x1,x2 do for y = y1,y2 do
      local S = SEEDS[x][y][1]

      local ch = string.sub(pat, pos, pos)
      pos = pos + 1
      assert(ch)

      if ch == '-' then
        if S.usage == "pillar" then return false end
      else
        assert(is_digit(ch))
        if S.kind ~= "walk" or S.room ~= R or S.usage or
           S.conn or S.pseudo_conn or S.must_walk
        then
          return false
        end
      end
    end end -- for x, y

    return true --OK--
  end

  local function make_pillar_pattern(side, offset, pat)
    local x1,y1, x2,y2 = side_coords(side, R.tx1,R.ty1, R.tx2,R.ty2)
    local pos = 1

    x1,y1 = nudge_coord(x1, y1, 10-side, offset)
    x2,y2 = nudge_coord(x2, y2, 10-side, offset)

    for x = x1,x2 do for y = y1,y2 do
      local S = SEEDS[x][y][1]

      local ch = string.sub(pat, pos, pos)
      pos = pos + 1

      if is_digit(ch) then
        S.usage = "pillar"
        S.pillar_tex = sel(ch == '1', "TEKLITE", "SILVER2")
      end

-- EXPERIMENT !!!!
if S.room == R then
S.ceil_h = math.max((S.floor_h or 0)+96, 512-64)
S.c_tex = S.room.combo.floor or S.f_tex
end
    end end -- for x, y
  end

  local function add_pillars()
    if R.parent then return end

    local SIDES = { 2, 4 }
    rand_shuffle(SIDES)

    for _,side in ipairs(SIDES) do for offset = 0,1 do
      local long, deep = R.tw, R.th
      if is_horiz(side) then long,deep = deep,long end

      if deep >= 3+offset*2 and long >= 3 then
        local lists = { {}, {} }

        for where = 1,2 do
          for _,pat in ipairs(PILLAR_PATTERNS) do
            if #pat == long and
               can_pillar_pattern(sel(where==1,side,10-side), offset, pat)
            then
              table.insert(lists[where], pat)
            end
          end -- for pat
        end -- for where

        if #lists[1] > 0 and #lists[2] > 0 then
          local pat1
          local pat2

          -- preference for same pattern
          for loop = 1,3 do
            pat1 = rand_element(lists[1])
            pat2 = rand_element(lists[2])
            if pat1 == pat2 then break; end
          end

          gui.debugf("Pillar patterns @ %s : %d=%s | %d=%s\n",
                     R:tostr(), side, pat1, 10-side, pat2)

          make_pillar_pattern(side,    offset, pat1)
          make_pillar_pattern(10-side, offset, pat2)

          return --OK--
        end
      end
    end end -- for side, offset
  end


  ---==| Room_layout_one |==---

gui.debugf("LAYOUT %s >>>>\n", R:tostr())

  local focus_C = R.entry_conn
  if not focus_C then
    focus_C = assert(R.conns[1])
  end

  R.focus_conn = focus_C


  if not focus_C.conn_h then
gui.debugf("NO ENTRY HEIGHT @ %s\n", R:tostr())
    focus_C.conn_h = SKY_H - rand_irange(4,7) * 64
  end

  R.floor_h = focus_C.conn_h  -- ??? BLEH

  -- special stuff
  if R.kind == "stairwell" then
    stairwell_height_diff(focus_C)

    local WELL_TEX = { "BROWN1", "GRAY1", "STARGR1", "METAL4" }
    if not PLAN.well_tex then
      PLAN.well_tex = rand_element(WELL_TEX)
    end

    local wall_info =
    {
      t_face = { texture="FLOOR7_1" },
      b_face = { texture="FLOOR7_1" },
      w_face = { texture=PLAN.well_tex },
    }
    local flat_info =
    {
      t_face = { texture="FLAT1" },
      b_face = { texture="FLOOR7_1" },
      w_face = { texture="BROWN1" },
    }

    Build_stairwell(R, wall_info, flat_info)
    return
  end

  if R.kind == "hallway" then
    Room_layout_hallway(R, focus_C.conn_h)
    return
  end

  if R.kind == "smallexit" then
    local item = tostring(GAME.things["medikit"].id)
    Build_small_exit(R, item)
    return
  end


  R.tx1, R.ty1 = R.sx1, R.sy1
  R.tx2, R.ty2 = R.sx2, R.sy2
  R.tw,  R.th  = R.sw,  R.sh

  R.junk_thick = { [2]=0, [4]=0, [6]=0, [8]=0 }

  if R.kind == "building" and not R.children then
    junk_sides()
  end


  local area =
  {
    x1 = R.tx1, y1 = R.ty1,
    x2 = R.tx2, y2 = R.ty2,
  }

  local heights = select_heights(focus_C)
  local f_texs  = select_floor_texs(focus_C)

  Room_try_divide(R, true, 1, true, R.symmetry, area, heights, f_texs)

---??  flood_fill_for_junk()

  for _,C in ipairs(R.conns) do
    assert(C.conn_h)
  end


  Room_set_floor_minmax(R)

  Room_choose_corner_stairs(R)

  if R.purpose then
    add_purpose()
  end

  if R.kind == "building" then
    add_pillars()
  end


  -- ETC ETC !!!

end



function Rooms_all_lay_out()

  gui.printf("\n--==| Rooms_all_lay_out |==--\n\n")

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

  PLAN.fence_mode = rand_key_by_probs { none=30, few=30, some=10 }
  gui.printf("Fence Mode: %s\n", PLAN.fence_mode)

  PLAN.symmetry_mode = rand_key_by_probs { few=30, some=60, heaps=10 }
  gui.printf("Symmetry Mode: %s\n", PLAN.symmetry_mode)


--[[ ]]
PLAN.liquid_mode = "heaps"
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
    Room_layout_one(R)
  end

  for _,R in ipairs(PLAN.scenic_rooms) do
    Room_layout_scenic(R)
  end

  Rooms_border_up()

  for _,R in ipairs(PLAN.scenic_rooms) do Room_build_seeds(R) end
  for _,R in ipairs(PLAN.all_rooms)    do Room_build_seeds(R) end
end

