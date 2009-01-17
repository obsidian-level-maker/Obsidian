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
  kind : keyword  -- Indoor values: "room", "hallway", "stairwell"
                  -- Outdoor values: "ground", "hill", "valley"

  outdoor : bool  -- true for outdoor rooms

  conns : array(CONN)  -- connections with neighbor rooms
  entry_conn : CONN

  branch_kind : keyword

  symmetry : keyword   -- symmetry of connections, or NIL
                       -- keywords are "x", "y", "xy", "r", "t"

  sx1, sy1, sx2, sy2  -- \ Seed range
  sw, sh, svolume     -- /

  floor_h, ceil_h : number

  purpose : keyword   -- usually NIL, can be "EXIT" etc... (FIXME)

  arena : ARENA


  --- plan_sp code only:

  lx1, ly1, lx2, ly2  -- coverage on the Land Map

  group_id : number  -- traversibility group

  --- layout code only:

  tx1, ty1, tx2, ty2, tw, th  -- Seed range for layouting

  layout_symmetry : keyword  -- can be "none", "x", "y", "xy"
}


----------------------------------------------------------------


Room Layouting Notes
====================

IDEAS:

- height diffs:
  - basic (if all else fails) algorithm:
    flood fill heights from conn seeds to remaining seeds
    [BUT: floor_h of room]
    add a stair seed at some meeting spots

    if height diff is huge, deserves more seeds

  - patterns:
    (a) L shape is nice
    (b) U shape is possible
    (c) plain side fill (two deep if room is big)

--------------------------------------------------------------]]


require 'defs'
require 'util'


HEIGHT_PATTERNS =
{
  I1 =
  {
    structure =
    {
      "...",
      "#^#",
      "###",
    },

    x_sizes =
    {
      "111", "212", "313", "414", "515", "616",
    },

    y_sizes =
    {
      "011", "012", "013",
      "112", "113", "114", "115",
      "212", "213", "214", "215", "216",
      "313", "314", "315", "316", "317", "318", "319",
      "413", "415", "416", "417", "418",
    },
  },


  I2 =
  {
    structure =
    {
      "...",
      "^#^",
      "###",
    },

    x_sizes =
    {
      "111", "121", "131", "141", "151", "161", "171",
      "181", "191", "1A1", "1B1",
    },

    y_sizes =
    {
      "011", "012", "013",
      "112", "113", "114", "115",
      "212", "213", "214", "215", "216",
      "313", "314", "315", "316", "317", "318", "319",
      "413", "415", "416", "417", "418",
    },
  },


  L1 =
  {
    structure =
    {
      "#..",
      "##^",
      "###",
    },

    x_sizes =
    {
      "111", "121", "131", "141", "151", "161",
      "221", "231", "241", "251", "261", "271", "281", "291", "2A1",
      "341", "351", "361", "371", "381", "391",
      "441", "461", "481",
    },

    y_sizes =
    {
      "011", "012", "013", "014", "015", "016", "017",
      "112", "113", "114", "115", "116", "117", "118", "119", "11A", "11B",
      "214", "216", "217", "218", "219", "21A",
      "316", "317", "318", "319",
    },
  },


  L2 =
  {
    structure =
    {
      "#..",
      "#^#",
      "###",
    },

    x_sizes =
    {
      "111", "112", "113", "114", "115", "116",
      "212", "213", "214", "215", "216", "217", "218", "219", "21A",
      "314", "315", "316", "317", "318", "319",
--    "414", "416", "418",
    },

    y_sizes =
    {
      "011", "012", "013", "014", "015", "016", "017",
      "112", "113", "114", "115", "116", "117", "118", "119", "11A", "11B",
      "214", "216", "217", "218", "219", "21A",
      "316", "317", "318", "319",
    },
  },


  U1 =
  {
    structure =
    {
      "#>.<#",
      "##.##",
      "#####",
    },

    x_sizes =
    {
      "01210", "01310",
      "11211", "11311", "11411", "11511", "11611", "11711", "11811",
      "21412", "21512", "21612", "21712",
    },

    y_sizes =
    {
      "101", "111", "121", "131", "141", "151", "161", "171", "181",
      "221", "231", "241", "251", "261", "271", "281", "291", "2A1",
      "341", "361", "391",
--    "441", "461", "481",
    },
  },


  U2 =
  {
    structure =
    {
      "##.##",
      "#>.<#",
      "#####",
    },

    x_sizes =
    {
      "01210", "01310",
      "11211", "11311", "11411", "11511", "11611", "11711", "11811",
      "21312", "21412", "21512", "21612", "21712",
    },

    y_sizes =
    {
      "111", "112", "113", "114", "115", "116", "117", "118",
      "212", "213", "214", "215", "216", "217", "218", "219", "21A",
      "314", "316", "319",
      "414", "416", "418",
    },
  },


  U3 =
  {
    structure =
    {
      "#...#",
      "##^##",
      "#####",
    },

    x_sizes =
    {
      "11111", "12121", "13131", "14141", "15151",
      "22122", "23132", "24142",
    },

    y_sizes =
    {
      "112", "113", "114", "115", "116", "117", "118",
      "212", "213", "214", "215", "216", "217", "218", "219", "21A",
      "314", "316", "319",
      "414", "416", "418",
    },
  },


  U4 =
  {
    structure =
    {
      "#...#",
      "#^#^#",
      "#####",
    },

    x_sizes =
    {
      "11111", "11211", "11311", "11411", "11511",
      "11611", "11711", "11811",
      "21312", "21412", "21512", "21612", "21712",
    },

    y_sizes =
    {
      "112", "113", "114", "115", "116", "117", "118",
      "212", "213", "214", "215", "216", "217", "218", "219", "21A",
      "314", "316", "319",
      "414", "416", "418",
    },
  },


  O1 =
  {
    structure =
    {
      "#####",
      "#####",
      "#...#",
      "##^##",
      "#####",
    },

    x_sizes =
    {
      "11111", "12121", "13131", "14141", "15151",
      "22122", "23132", "24142",
    },

    y_sizes =
    {
      "01210", "01310", "01410", "01510", "01610",
      "11311", "11411", "11511", "11611", "11711", "11811", "11911",
      "21312", "21412", "21512", "21612", "21712",
    },
  },


  O2 =
  {
    structure =
    {
      "#####",
      "##v##",
      "#...#",
      "##^##",
      "#####",
    },

    x_sizes =
    {
      "11111", "12121", "13131", "14141", "15151",
      "22122", "23132", "24142",
    },

    y_sizes =
    {
      "01210", "01310", "01410", "01510", "01610",
      "11311", "11411", "11511", "11611", "11711", "11811", "11911",
      "21312", "21412", "21512", "21612", "21712",
    },
  },


  O3 =
  {
    structure =
    {
      "#####",
      "#v#v#",
      "#...#",
      "#^#^#",
      "#####",
    },

    x_sizes =
    {
      "11111", "11211", "11311", "11411", "11511", "11611",
      "11711", "11811", "11911",
      "21312", "21412", "21512", "21612", "21712",
    },

    y_sizes =
    {
      "01210", "01310", "01410", "01510", "01610",
      "11311", "11411", "11511", "11611", "11711", "11811", "11911",
      "21312", "21412", "21512", "21612", "21712",
    },
  },


  -- TODO: T shape

  -- TODO: H shape

  -- TODO: Z shape
}


function Test_height_patterns()
  
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

  ---| dump_height_patterns |---
  
  for name,info in pairs(HEIGHT_PATTERNS) do
    gui.printf("HEIGHT PATTERN: %s\n\n", name)

    for deep = 2,11 do for long = 2,11 do
      show_pattern(name, info, long, deep)
    end end
  end
end



function Rooms_decide_outdoors()
  local function choose(R)
    if R.parent and R.parent.outdoor then return false end
    if R.parent then return rand_odds(5) end

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
      return rand_odds(27)
    end

    return rand_odds(9)
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


function Room_SetupTheme(R)
 
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

function Room_SetupTheme_Scenic(R)
  R.outdoor = true
  R.kind = "liquid"

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
    Room_SetupTheme(R)
  end
  for _,R in ipairs(PLAN.scenic_rooms) do
    Room_SetupTheme_Scenic(R)
  end
end


function calc_conn_area(R)
  local lx, ly = 999,999
  local hx, hy = 0,0

  for _,C in ipairs(R.conns) do
    local S = C:seed(R)
    lx = math.min(lx, S.sx)
    ly = math.min(ly, S.sy)
    hx = math.max(hx, S.sx)
    hy = math.max(hy, S.sy)
  end

  assert(lx <= hx and ly <= hy)

  return lx,ly, hx,hy
end


function dump_layout(R)

  local function outside_seed(x, y)
    for dir = 2,8,2 do
      local sx, sy = nudge_coord(x, y, dir)
      if R:valid_T(sx, sy) then
        local T = SEEDS[sx][sy][1]
        if T.conn_dirs and T.conn_dirs[10-dir] then
          return '*'
        end
      end
    end
      
    for _,C in ipairs(R.conns) do
      local S = C:seed(R)
      local ox, oy = nudge_coord(S.sx, S.sy, S.conn_dir)
      if ox == x and oy == y then
        return '+'
      end
    end

    return ' '
  end

  local function inside_seed(x, y)
    local S = SEEDS[x][y][1]
    assert(S and S.room == R)

    if S.layout then
      return S.layout.char
    end

    return '.'
  end


  --| dump_layout |--

  gui.debugf("Room %s @ (%d,%d) Layout:\n", R.kind, R.sx1, R.sy1)

  for y = R.ty2+1, R.ty1-1, -1 do
    line = ""
    for x = R.tx1-1, R.tx2+1 do
      if x < R.tx1 or x > R.tx2 or y < R.ty1 or y > R.ty2 then
        line = line .. outside_seed(x, y)
      else
        line = line .. inside_seed(x, y)
      end
    end
    gui.debugf(" %s\n", line)
  end

  gui.debugf("\n");
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
    if R.num_branch > 5 then return false end

    for _,C in ipairs(R.conns) do
      local N = C:neighbor(R)
      if N.outdoor and rand_odds(95) then
        return false
      end

      if C.dest == R and C.lock and rand_odds(50) then
        return false
      end
    end

    local min_d = math.min(R.sw, R.sh)

    if min_d > 6 then return false end

    if PLAN.hallway_mode == "heaps" then
      return rand_odds(HALL_SIZE_HEAPS[min_d])
    end

    if PLAN.hallway_mode == "few" and rand_odds(66) then return false end

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
    if C.src.kind == "hallway" and C.dest.kind == "hallway" then
      local S = C.src_S
      local T = C.dest_S
      local dir = S.conn_dir

      if S.border[S.conn_dir].kind == "arch" or
         T.border[T.conn_dir].kind == "arch"
      then
        S.border[S.conn_dir].kind = nil
        T.border[T.conn_dir].kind = nil
      end
    end
  end -- for C
end


function Room_spot_for_wotsit(R, kind)
  -- FIXME !!!! CRUD
  local sx, sy, S

  repeat
    sx = rand_irange(R.sx1, R.sx2)
    sy = rand_irange(R.sy1, R.sy2)

    S = SEEDS[sx][sy][1]
  until S.room == R and S.kind == "walk"

  S.kind = "purpose"

  return sx, sy, S
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
    transformed_brush2(nil,
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


    -- SIDES

    for side = 2,8,2 do
      local N = S:neighbor(side)

      local B_kind = S.border[side].kind

      -- hallway hack
      if R.kind == "hallway" and not (S.layout and S.layout.char == '#') and
         ( (B_kind == "wall")
          or
           (S:neighbor(side) and S:neighbor(side).room == R and
            S:neighbor(side).layout and
            S:neighbor(side).layout.char == '#')
         )
      then
        make_detailed_hall(S, side, z1, z2)

        S.border[side].kind = nil
        B_kind = nil
      end

      local could_lose_wall = -- FIXME: decide this in earlier code
            N and S.room and N.room and
            S.room.arena == N.room.arena and
            S.room.kind == N.room.kind and
            not (S.room.hallway or N.room.hallway) and
            not (S.room.purpose or N.room.purpose)

      if B_kind == "wall" then --- and not could_lose_wall
        make_wall(S, side, f_tex, w_tex)
---     make_picture(S, side, 128, z1+64, z1+192, f_tex, w_tex, "ZZWOLF6")
      end

      if B_kind == "picture" then
        make_picture(S, side, 128, z1+64, z1+192, f_tex, w_tex, "SPACEW3")
      end

      if B_kind == "window" then
--!!!        make_window(S, side, 192, z1+64, z2-32, f_tex, w_tex)
        make_window(S, side, 192, z1+32, z1+80, f_tex, w_tex)
      end

      if B_kind == "fence" then   --FIXME: R.fence_h
--!!!!     and not (N and S.room and N.room and S.room.arena == N.room.arena and S.room.kind == N.room.kind then
        make_fence(S, side, R.floor_h or z1, f_tex, w_tex)
      end

      if B_kind == "mini_fence" then
        -- do nothing
      end

      if B_kind == "sky_fence" then
        make_sky_fence(S, side)
      end

      if B_kind == "arch" then
        make_archway(S, side, z1, z2, f_tex, w_tex) 
      end

      if B_kind == "lock_door" and
         not (S.conn and S.conn.already_made_lock)
      then
        local LOCK = assert(S.border[side].lock)
        local INFO
        if LOCK.kind == "KEY" then
          INFO = assert(GAME.key_doors[LOCK.item])
        else
          assert(LOCK.kind == "SWITCH")
          INFO = assert(GAME.switch_doors[LOCK.item])
        end

        make_locked_door(S, side, z1, w_tex, INFO, LOCK.tag)
        S.conn.already_made_lock = true
      end

      if B_kind == "bars" and
         not (S.conn and S.conn.already_made_lock)
      then
---     make_lowering_bars(S, side, z1, "FLAT23", "SUPPORT2")
---     make_lowering_bars(S, side, z1, "CEIL5_2", "SUPPORT3")
        make_lowering_bars(S, side, z1, "FLAT5_2", "WOOD9")
        S.conn.already_made_lock = true
      end
    end -- for side


    if S.sides_only then return end


    -- DIAGONALS

--[[ FIXME
if (not S.room.outdoor or false) and not (S.room.kind == "hallway") and
   not S.is_start
then
  local z1
  if S.conn then z1 = (S.conn.conn_h or S.floor_h or S.room.floor_h or 320) + 128 end
  local diag_info =
  {
    t_face = { texture=f_tex },
    b_face = { texture=c_tex },
    w_face = { texture=w_tex },
  }
  if S.sx == S.room.sx1 and S.sy == S.room.sy1 then
    make_diagonal(S, 1, diag_info, z1)
  elseif S.sx == S.room.sx2 and S.sy == S.room.sy1 then
    make_diagonal(S, 3, diag_info, z1)
  elseif S.sx == S.room.sx1 and S.sy == S.room.sy2 then
    make_diagonal(S, 7, diag_info, z1)
  elseif S.sx == S.room.sx2 and S.sy == S.room.sy2 then
    make_diagonal(S, 9, diag_info, z1)
  end
end
--]]


    -- CEILING

    if S.kind ~= "void" then
      transformed_brush2(nil,
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
    end


    -- FLOOR

    if S.kind == "void" then

      transformed_brush2(nil,
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

      transformed_brush2(nil,
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

      transformed_brush2(nil,
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

  local CH = S.layout and S.layout.char

      local stair_info =
      {
        t_face = { texture="FLAT1" },
        b_face = { texture="FLAT1" },
        w_face = { texture="STEP4" },
      }

      if S.stair_dir == 6 then
         make_ramp_x(stair_info, x1,x2,y1, x1,x2,y2, S.layout.stair_z1, S.layout.stair_z2)
      elseif S.stair_dir == 4 then
         make_ramp_x(stair_info, x1,x2,y1, x1,x2,y2, S.layout.stair_z2, S.layout.stair_z1)
      elseif S.stair_dir == 8 then
         make_ramp_y(stair_info, x1,y1,y2, x2,y1,y2, S.layout.stair_z1, S.layout.stair_z2)
      else assert(S.stair_dir == 2)
         make_ramp_y(stair_info, x1,y1,y2, x2,y1,y2, S.layout.stair_z2, S.layout.stair_z1)
      end

    elseif S.kind == "curve_stair" then

      if S.stair_in_corner then
        Build_tall_curved_stair(S, x1,y1, x2,y2, S.x_side, S.y_side, S.x_height, S.y_height)
      else
        Build_low_curved_stair(S, S.x_side, S.y_side, S.x_height, S.y_height)
      end

    elseif S.kind == "lift" then
      make_lift(S, 10-S.conn_dir, assert(S.layout.lift_h))

    elseif S.kind == "popup" then
      make_popup_trap(S, z1, {}, S.room.combo)

    elseif not S.no_floor then

      transformed_brush2(nil,
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


    -- MISCELLANEOUS

    if S.has_pillar then
      make_pillar(S, z1, z2, "TEKLITE")
    end


    -- TEMP SHIT
    local mx = int((x1+x2) / 2)
    local my = int((y1+y2) / 2)

    if S.room and S.room.kind ~= "scenic" and
       (S.sx == S.room.sx1+2) and (S.sy == S.room.sy1+2) then
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


function Room_try_divide(R, div_lev, area, heights)
  -- find a usable pattern in the HEIGHT_PATTERNS table and
  -- apply it to the room.

  local tw, th = box_size(area.x1, area.y1, area.x2, area.y2)

  if tw <= 2 and th <= 2 then return false end

  if #heights < 2 then return false end



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

  local function expand_structure(info, x_sizes, y_sizes)
    local expanded = {}

    for y = 1,#y_sizes do
      local y_num = pos_size(y_sizes, y)
      local src = info.structure[#y_sizes+1 - y]
      local padded = pad_line(src, x_sizes)
      for i = 1,y_num do
        table.insert(expanded, 1, padded)
      end
    end

    return expanded
  end

  local TRANSPOSE_DIR_TAB = { 1,4,7,2,5,8,3,6,9 }

  local TRANSPOSE_STAIR_TAB =
  {
    ['<'] = 'v', ['v'] = '<',
    ['>'] = '^', ['^'] = '>',
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

  local function morph_stair(T, ch)
    if T.x_flip then
          if ch == '<' then ch = '>'
      elseif ch == '>' then ch = '<'
      end
    end

    if T.y_flip then
          if ch == '<' then ch = '>'
      elseif ch == '>' then ch = '<'
      end
    end

    if T.transpose then
      ch = assert(TRANSPOSE_STAIR_TAB[ch])
    end

    return ch
  end

  local function eval_fab(T)
    -- prefer patterns where some of the connections touch
    -- the old area and some touch the new area.

    local score = 1 + gui.random()

    for i = 1,T.long do for j = 1,T.deep do
      local x, y = morph_coord(T, i, j)
      assert(Seed_valid(x, y, 1))

      local S = SEEDS[x][y][1]
      assert(S and S.room == R)

      local ch = string.sub(expanded[deep+1-j], i, i)
      assert(ch)
      ch = morph_stair(ch)

      -- FIXME: TEST STUFF !!!
    end end -- for i, j

    return score
  end

  local function install_it(T)

    -- these vars compute the new area (where the dots are).
    local nx_min, nx_max = 999, -999
    local ny_min, ny_max = 999, -999

    for i = 1,T.long do for j = 1,T.deep do
      local x, y = morph_coord(T, i, j)
      local S = SEEDS[x][y][1]

      local ch = string.sub(expanded[deep+1-j], i, i)
      ch = morph_ch(T, ch)

      if ch == '#' then
        S.floor_h = heights[1]
      elseif ch == '.' then
        -- write in new height
---        S.floor_h = new_h

        if S.conn then S.conn.conn_h = new_h end

        nx_min = math.min(nx_min, x) ; nx_max = math.max(nx_max, x)
        ny_min = math.min(ny_min, y) ; ny_max = math.max(ny_max, y)
      else
        -- FIXME !!!!!! STAIRS
      end
    end end -- for i, j

    assert(nx_max > 0)

    local new_a = { x1=nx_min, y1=ny_min, x2=nx_max, y2=ny_max }
    local new_hs = shallow_copy(heights)
    table.remove(new_hs, 1)

    -- recursive call
    Room_try_divide(R, div_lev+1, new_a, new_hs)
  end

  local function try_install_pattern(name)
    local info = assert(HEIGHT_PATTERNS[name])

    local possibles = {}

    local T = { info=info }

    for tr_n = 0,0 do  --!!!! FIXME
      T.transpose = (tr_n == 1)

      T.long = sel(T.transpose, th, tw)
      T.deep = sel(T.transpose, tw, th)

      T.x_sizes = matching_sizes(info.x_sizes, T.long)
      T.y_sizes = matching_sizes(info.y_sizes, T.deep)

gui.debugf("  tr:%s  long:%d  deep:%d\n", bool_str(tr), long, deep)
      if T.x_sizes and T.y_sizes then
        local xs = rand_element(T.x_sizes)
        local ys = rand_element(T.y_sizes)

        T.expanded = expand_structure(info, xs, ys)

        for xf_n = 0,1 do for yf_n = 0,1 do
          T.x_flip = (xf_n == 1)
          T.y_flip = (yf_n == 1)

          T.score = eval_fab(T)

          if T.score > 0 then
            table.insert(possibles, T)
          end
        end end -- for xf_n, yf_n
      end 
    end -- for tr_n

    if #possibles == 0 then
      return false
    end

    local good_T = table_sorted_first(possibles,
        function(A,B) return A.score > B.score end)

    install_it(good_T)

    return true  -- YES !!
  end


  ---==| Room_divide |==---
 
  if R.children then return false end

  if R.kind == "hallway" or R.kind == "stairwell" then return false end

  local try_fabs = {}
  for name,info in pairs(HEIGHT_PATTERNS) do
    -- TODO: symmetry matching
    try_fabs[name] = info.prob or 50
  end


  for loop = 1,10 do
    if table_empty(try_fabs) then
      break;
    end

    local which = rand_key_by_probs(try_fabs)
    try_fabs[which] = nil

    gui.debugf("Trying pattern %s in %s (loop %d)......\n",
               which, R:tostr(), loop)

    if try_install_pattern(which) then
      gui.debugf("SUCCESS with %s!\n", which)
      return true
    end
  end

  gui.debugf("FAILED to apply any room pattern.\n")
  return false
end


function Room_layout_II(R)

  local function junk_sides()
    -- Adds solid seeds (kind "void") to the edges of large rooms.
    -- These seeds can be put to other uses later, such as: cages,
    -- monster closets, or secrets.
    --
    -- The best side is on the largest axis (minimises number of
    -- junked seeds), and prefer no connections on that side.
    --
    -- Usually only junk one side, sometimes two.

    -- FIXME: occasionaly make ledge-cages in OUTDOOR rooms

    local min_space = 2

    local JUNK_MAX_COSTS = { few=0.7, some=1.2, heaps=2.5 }
    local JUNK_MAX_LOOP  = { few=4,   some=7,   heaps=10 }

    local max_cost = JUNK_MAX_COSTS[PLAN.junk_mode]
    local max_loop = JUNK_MAX_LOOP [PLAN.junk_mode]


    local function max_junking(size)
      if size < min_space then return 0 end
      return size - min_space
    end

    local function eval_side(side, x_max, y_max)
      local th = R.junk_thick[side]

      if side == 2 or side == 8 then
        if R.junk_thick[2] + R.junk_thick[8] >= y_max then return -1 end
      else
        if R.junk_thick[4] + R.junk_thick[6] >= x_max then return -1 end
      end

      local x1,y1, x2,y2 = side_coords(side, R.sx1,R.sy1, R.sx2,R.sy2)
      local dx, dy = dir_to_delta(side)
      x1, y1 = x1-dx*th, y1-dy*th
      x2, y2 = x2-dx*th, y2-dy*th

      local hit_conn = 0

      for x = x1,x2 do for y = y1,y2 do
        local S = SEEDS[x][y][1]
        if S.room ~= R then return -1 end
        if not (S.kind == "walk" or S.kind == "void") then return -1 end

        if S.conn or S.pseudo_conn then
          hit_conn = hit_conn + 1
        end
      end end -- for x,y

      -- FIXME: add a cost if side could be used for windows

      return R.junk_thick[side] * 1.4 + hit_conn / 1.5 + gui.random()
    end

    local function apply_junk_side(side)
      local th = R.junk_thick[side]

      local x1,y1, x2,y2 = side_coords(side, R.sx1,R.sy1, R.sx2,R.sy2)
      local dx, dy = dir_to_delta(side)
      x1, y1 = x1-dx*th, y1-dy*th
      x2, y2 = x2-dx*th, y2-dy*th

      local did_change = false
      local p_conns = {}

      for x = x1,x2 do for y = y1,y2 do
        local S = SEEDS[x][y][1]
        if S.conn or S.pseudo_conn then
          local P = { x=x-dx, y=y-dy, conn=S.conn or S.pseudo_conn }
          table.insert(p_conns, P)
        elseif S.kind == "walk" then
          S.kind = "void"
          did_change = true
        end
      end end -- for x,y

      for _,P in ipairs(p_conns) do
        SEEDS[P.x][P.y][1].pseudo_conn = P.conn
      end

      R.junk_thick[side] = R.junk_thick[side] + 1
    end


    --| junk_sides |--

    local x_max = max_junking(R.sw)
    local y_max = max_junking(R.sh)

    for loop = 1,max_loop do
      local evals = {}

      for side = 2,8,2 do
        local cost = eval_side(side, x_max, y_max)
        if cost > 0 and cost < max_cost then
          table.insert(evals, { side=side, cost=cost })
        end
      end

      if #evals > 0 then
        table.sort(evals, function(A,B) return A.cost < B.cost end)

        apply_junk_side(evals[1].side)
      end
    end
  end


  local function make_fences()
    for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
      local S = SEEDS[x][y][1]
      for side = 2,8,2 do
        local N = S:neighbor(side)

        if S.room == R and S.border[side].kind == "wall"
           and (R.outdoor or (N and N.room and N.room.parent == R))
        then

          if not (N and N.room) then
            S.border[side].kind = "sky_fence"
          end

          if N and N.room and N.room ~= R and N.room.outdoor then
             S.border[side].kind = "fence"
          end

          if N and N.room and N.room ~= R and not N.room.outdoor then
             S.border[side].kind = "mini_fence"
          end
        end
      end
    end end -- for x,y
  end

  local function make_windows()
    if not (R.kind == "building" and R.purpose ~= "EXIT") then
      return
    end

    for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
      local S = SEEDS[x][y][1]
      if S.room == R and S.kind ~= "void" and
         (x == R.sx1 or x == R.sx2 or y == R.sy1 or y == R.sy2)
      then
        for side = 2,8,2 do
          local N = S:neighbor(side)
          if N and (N.sx < R.sx1 or N.sx > R.sx2 or N.sy < R.sy1 or N.sy > R.sy2) and
             N.room and (N.room.outdoor or R.parent) and
             S.border[side].kind == "wall"
          then
             S.border[side].kind = "window"
          end
        end
      end
    end end -- for x,y
  end

  local function add_purpose()
    local sx, sy, S = Room_spot_for_wotsit(R, R.purpose)
    local z1 = S.floor_h or R.floor_h

    local mx, my = S:mid_point()

    if R.purpose == "START" then
      if rand_odds(20) then
        make_raising_start(S, 6, z1, R.combo)
        gui.debugf("Raising Start made\n")
        S.no_floor = true
      else
        make_pedestal(S, z1, "FLAT22")
      end

      gui.add_entity(mx, my, z1 + 35,
      {
        name = tostring(GAME.things["player1"].id)
      })

    elseif R.purpose == "EXIT" then
      local CS = R.conns[1]:seed(R)
      local dir = assert(CS.conn_dir)

      if R.outdoor then
        make_outdoor_exit_switch(S, dir, z1)
      else
        make_exit_pillar(S, z1)
      end

    elseif R.purpose == "KEY" then
      make_pedestal(S, z1, "CEIL1_2")
      gui.add_entity(mx, my, z1+40,
      {
        name = tostring(GAME.things[R.key_item].id),
      })
    elseif R.purpose == "SWITCH" then
gui.debugf("SWITCH ITEM = %s\n", R.do_switch)
      local LOCK = assert(R.lock_for_item)  -- eww
      local INFO = assert(GAME.switch_infos[R.do_switch])
      make_small_switch(S, 4, z1, INFO, LOCK.tag)

    else
      error("Room_layout_II: unknown purpose! " .. tostring(R.purpose))
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


  ---==| Room_layout_II |==---

  local focus_C = R.entry_conn
  if not focus_C then
    focus_C = assert(R.conns[1])
  end

  if not focus_C.conn_h then
gui.debugf("NO ENTRY HEIGHT @ %s\n", R:tostr())
    focus_C.conn_h = SKY_H - 256 --!!!!  rand_irange(1,3) * 128
  end

  R.floor_h = focus_C.conn_h  -- ??? BLEH

  -- special stuff
  if R.kind == "stairwell" then
    stairwell_height_diff(focus_C)

    Build_stairwell(R)
    return
  end

  if R.purpose == "EXIT" and not R.outdoor and not R:has_any_lock() then
    Build_small_exit(R)
    return
  end


  -- TEMP CRUD !!!
  for _,C in ipairs(R.conns) do
    if not C.conn_h then
      C.conn_h = focus_C.conn_h --##  + rand_irange(-1,1)*16
    end
  end


  R.junk_thick = { [2]=0, [4]=0, [6]=0, [8]=0 }

  if R.kind == "building" and not R.children then
    junk_sides()
  end


  make_fences()

  make_windows()


  -- MORE TEMP JUNK
  for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
    local S = SEEDS[x][y][1]
    if S.room == R then
      if not S.floor_h then S.floor_h = R.floor_h ; S.f_tex = "LAVA1" end
    end
  end end -- for x,y



  local area =
  {
    x1 = R.sx1 + R.junk_thick[4], y1 = R.sy1 + R.junk_thick[2],
    x2 = R.sx2 - R.junk_thick[6], y2 = R.sy2 - R.junk_thick[8],
  }

  -- FIXME: proper height selection
  local delta = 64 * rand_element { -1, 1 }
  if (R.floor_h >= 256 and delta > 0) or
     (R.floor_h <= 128 and delta < 0) then delta = -delta end

  local heights = { R.floor_h, R.floor_h + delta, R.floor_h + delta * 2, R.floor_h + delta * 3 }

  Room_try_divide(R, 1, area, heights)


  if R.purpose then
    add_purpose()
  end

  -- ETC ETC !!!

end



function Room_do_scenic(R)

  local function build_scenic_seed(S)
    local z1 = -24
    local z2  = SKY_H

    transformed_brush2(nil,
    {
      t_face = { texture="NUKAGE1" },
      b_face = { texture="NUKAGE1" },
      w_face = { texture="SFALL1" },
      sec_kind = 16,
    },
    {
      { x=S.x2, y=S.y1 }, { x=S.x2, y=S.y2 },
      { x=S.x1, y=S.y2 }, { x=S.x1, y=S.y1 },
    },
    -2000, z1);

    transformed_brush2(nil,
    {
      t_face = { texture=PARAMS.sky_flat },
      b_face = { texture=PARAMS.sky_flat },
      w_face = { texture=PARAMS.sky_tex  },
    },
    {
      { x=S.x2, y=S.y1 }, { x=S.x2, y=S.y2 },
      { x=S.x1, y=S.y2 }, { x=S.x1, y=S.y1 },
    },
    z2, 2000)
  end

  ---| Room_do_scenic |---

  for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
    local S = SEEDS[x][y][1]
    if S.room == R then
      build_scenic_seed(S)
    end
  end end -- for x,y
end



function Rooms_lay_out_II()

  gui.printf("\n--==| Rooms_lay_out II |==--\n\n")

  PLAN.theme = GAME.themes["TECH"] -- FIXME

  PLAN.sky_mode = rand_key_by_probs { few=20, some=70, heaps=10 }
  gui.printf("Sky Mode: %s\n", PLAN.sky_mode)

  PLAN.hallway_mode = rand_key_by_probs { few=10, some=90, heaps=20 }
  gui.printf("Hallway Mode: %s\n", PLAN.hallway_mode)

  PLAN.junk_mode = rand_key_by_probs { few=40, some=30, heaps=10 }
  gui.printf("Junk Mode: %s\n", PLAN.junk_mode)

  PLAN.cage_mode = rand_key_by_probs { none=50, few=20, some=50, heaps=5 }
  gui.printf("Cage Mode: %s\n", PLAN.cage_mode)


--!!!!!
PLAN.sky_mode = "few"
PLAN.hallway_mode = "few"
PLAN.junk_mode = "heaps"

  Rooms_decide_outdoors()
  Rooms_choose_themes()
  Rooms_decide_hallways_II()

  Seed_dump_fabs()

  for _,R in ipairs(PLAN.all_rooms) do
    Room_layout_II(R)
    Room_build_seeds(R)
  end

  for _,R in ipairs(PLAN.scenic_rooms) do
    Room_do_scenic(R)
  end

---  Test_height_patterns()
end

