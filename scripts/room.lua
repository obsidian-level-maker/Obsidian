----------------------------------------------------------------
--  Room Management
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2014 Andrew Apted
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
  kind : keyword  -- "building" (layout-able room)
                  -- "outdoor", "cave"
                  -- "hallway", "stairwell", "small_exit"
                  -- "scenic" (unvisitable room)

  is_outdoor : bool  -- true for outdoor rooms / caves

  conns : array(CONN)  -- connections with neighbor rooms
  entry_conn : CONN

  branch_kind : keyword

  hallway : HALLWAY_INFO   -- for hallways and stairwells

  symmetry : keyword   -- symmetry of room, or NIL
                       -- keywords are "x", "y", "xy"

  sx1, sy1, sx2, sy2  -- \ Seed range
  sw, sh, svolume     -- /

  zone  : ZONE
  quest : QUEST

  purpose : keyword   -- usually NIL, can be "EXIT" etc... (FIXME)
  purpose_lock : LOCK

  teleport_conn : CONN  -- if exists, the teleporter connection to/from this room

  floor_h, ceil_h : number

  c_group : number    -- connection group (used for Connect logic)

  sky_group : number  -- outdoor rooms which directly touch will belong
                      -- to the same sky_group (unless a solid wall is
                      -- enforced, e.g. between zones).
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


ROOM_CLASS = {}

function ROOM_CLASS.new()
  local id = Plan_alloc_id("room")

  local R =
  {
    id = id
    kind = "building"
    num_windows = 0

    conns = {}
    sections = {}
    weapons = {}
    items = {}

    mon_spots  = {}
    item_spots = {}
    big_spots  = {}
    goal_spots = {}
    cage_spots = {}

    goals   = {}
    closets = {}
    prefabs = {}
    decor   = {}

    sky_rects = {}
    exclusions = {}
    neighbors = {}

    hazard_health = 0
  }

  table.set_class(R, ROOM_CLASS)
  table.insert(LEVEL.rooms, R)
  return R
end

function ROOM_CLASS.tostr(R)
  return string.format("%sROOM_%d", sel(R.parent, "SUB_", ""), R.id)
end

function ROOM_CLASS.contains_seed(R, x, y)
  if x < R.sx1 or x > R.sx2 then return false end
  if y < R.sy1 or y > R.sy2 then return false end
  return true
end

function ROOM_CLASS.has_lock(R, lock)
  each C in R.conns do
    if C.lock == lock then return true end
  end
  return false
end

function ROOM_CLASS.has_any_lock(R)
  each C in R.conns do
    if C.lock then return true end
  end
  return false
end

function ROOM_CLASS.has_lock_kind(R, kind)
  each C in R.conns do
    if C.lock and C.lock.kind == kind then return true end
  end
  return false
end

function ROOM_CLASS.has_sky_neighbor(R)
  each C in R.conns do
    local N = C:neighbor(R)
    if N.is_outdoor then return true end
  end
  return false
end

function ROOM_CLASS.valid_T(R, x, y)
  if x < R.tx1 or x > R.tx2 then return false end
  if y < R.ty1 or y > R.ty2 then return false end
  return true
end

function ROOM_CLASS.get_exits(R)
  local exits = {}

  each C in R.conns do
    if C.R1 == R and not (C.kind == "double_R" or C.kind == "closet") then
      table.insert(exits, C)
    end
  end

  return exits
end

function ROOM_CLASS.conn_area(R)
  local lx, ly = 999,999
  local hx, hy = 0,0

  each C in R.conns do
    if C.kind == "teleporter" then continue end
    local S = C:seed(R)
    lx = math.min(lx, S.sx)
    ly = math.min(ly, S.sy)
    hx = math.max(hx, S.sx)
    hy = math.max(hy, S.sy)
  end

  assert(lx <= hx and ly <= hy)

  return lx,ly, hx,hy
end


function ROOM_CLASS.is_near_exit(R)
  if R.purpose == "EXIT" then return true end
  each C in R.conns do
    local N = C:neighbor(R)
    if N.purpose == "EXIT" then return true end
  end
  return false
end


function ROOM_CLASS.find_guard_spot(R)
  -- finds a KEY or EXIT to guard -- returns coordinate table
  if R.purpose == "KEY" or R.purpose == "EXIT" then

    if R.guard_spot then
      local mx, my = R.guard_spot:mid_point()

      return { x=mx, y=my }
    end
  end

--[[  FUTURE
  each CL in R.closets do
    if CL.closet_kind == "exit" or
       CL.closet_kind == "item"
    then
      -- create a fake spot in front of closet
      local x, y = CL.section:edge_mid_point(CL.dir)
      local dx, dy = geom.delta(CL.dir)

      x = x + dx * 70
      y = y + dy * 70

      return { x=x, y=y }
    end
  end
--]]

  return nil  -- none
end


function ROOM_CLASS.furthest_dist_from_entry(R)
  if not R.entry_coord then
    -- rough guess
    local S1 = SEEDS[R.sx1][R.sy1]
    local S2 = SEEDS[R.sx2][R.sy2]

    local w = S2.x2 - S1.x1
    local h = S2.y2 - S1.y1

    return math.max(w, h)
  end

  local result = 512

  local ex = R.entry_coord.x
  local ey = R.entry_coord.y

  for sx = R.sx1, R.sx2 do
  for sy = R.sy1, R.sy2 do
    local S = SEEDS[sx][sy]

    if S.room != R then continue end

    local ox = sel(S.x1 < ex, S.x1, S.x2)
    local oy = sel(S.y1 < ey, S.y1, S.y2)

    local dist = geom.dist(ex, ey, ox, oy)

    result = math.max(result, dist)
  end
  end

  return result
end


function ROOM_CLASS.add_exclusion(R, kind, x1, y1, x2, y2, extra_dist)
  local area =
  {
    kind = kind
    x1 = x1 - (extra_dist or 0)
    y1 = y1 - (extra_dist or 0)
    x2 = x2 + (extra_dist or 0)
    y2 = y2 + (extra_dist or 0)
  }

  table.insert(R.exclusions, area)
end


function ROOM_CLASS.clip_spot_list(R, list, x1, y1, x2, y2, strict_mode)
  local new_list = {}

  each spot in list do
    if (spot.x2 <= x1) or (spot.x1 >= x2) or
       (spot.y2 <= y1) or (spot.y1 >= y2)
    then
      -- unclipped

    elseif strict_mode then
      -- drop this spot
      continue

    else
      local w1 = x1 - spot.x1
      local w2 = spot.x2 - x2

      local h1 = y1 - spot.y1
      local h2 = spot.y2 - y2

      -- totally clipped?
      if math.max(w1, w2, h1, h2) < 8 then
        continue
      end

      -- shrink the existing box (keep side with most free space)

      if w1 >= math.max(w2, h1, h2) then
        spot.x2 = spot.x1 + w1
      elseif w2 >= math.max(w1, h1, h2) then
        spot.x1 = spot.x2 - w2
      elseif h1 >= math.max(w1, w2, h2) then
        spot.y2 = spot.y1 + h1
      else
        spot.y1 = spot.y2 - h2
      end

      assert(spot.x2 > spot.x1)
      assert(spot.y2 > spot.y1)
    end

    table.insert(new_list, spot)
  end

  return new_list
end


function ROOM_CLASS.clip_spots(R, x1, y1, x2, y2)
  -- the given rectangle is where we _cannot_ have a spot

  assert(x1 < x2)
  assert(y1 < y2)

  -- enlarge the area a bit
  x1, y1 = x1 - 4, y1 - 4
  x2, y2 = x2 + 4, y2 + 4

  R.mon_spots  = R:clip_spot_list(R.mon_spots,  x1, y1, x2, y2)
  R.item_spots = R:clip_spot_list(R.item_spots, x1, y1, x2, y2)
  R.big_spots  = R:clip_spot_list(R.big_spots,  x1, y1, x2, y2, "strict")
end


function ROOM_CLASS.exclude_monsters(R)
  each area in R.exclusions do
    if area.kind == "empty" then
      R:clip_spots(area.x1, area.y1, area.x2, area.y2)
    end
  end
end


------------------------------------------------------------------------


function Room_setup_theme(R)
  R.facade = assert(R.zone.facade_mat)

  if R.kind == "cave" then
    R.main_tex = rand.key_by_probs(R.theme.naturals)
    return
  end

  if not R.is_outdoor then
    R.main_tex = rand.key_by_probs(R.theme.walls)
    return
  end

  R.main_tex = rand.key_by_probs(R.theme.naturals or R.theme.floors)
end


function Room_setup_theme_Scenic(R)
  R.is_outdoor = true  -- ???

  -- find closest non-scenic room
  local near_room

  local mx, my = geom.box_mid(R.sx1, R.sy1, R.sx2, R.sy2)

  for dist = 1, SEED_W do
  for  dir = 1,9 do  if dir != 5 then

    local sx, sy = geom.nudge(mx, my, dir, dist)

    if Seed_valid(sx, sy) then
      local S = SEEDS[sx][sy]

      if S.room and S.room.kind != "scenic" and
         S.room.kind != "hallway"
      then
        near_room = R
        break;
      end
    end

  end end  -- dir
  end  -- dist

  if not near_room then
    near_room = LEVEL.rooms[1]
  end

  R.theme = near_room.theme

  if R.is_outdoor then
    R.main_tex = rand.key_by_probs(R.theme.naturals or R.theme.floors)
  else
    R.main_tex = rand.key_by_probs(R.theme.walls)
  end
end



function Room_choose_themes()
  each R in LEVEL.rooms do
    Room_setup_theme(R)
  end

  each R in LEVEL.scenic_rooms do
    Room_setup_theme_Scenic(R)
  end
end



function Room_decide_hallways()
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
    if R.is_outdoor or (R.kind == "cave") or R.children or R.purpose then
      return false
    end

    if R.teleport_conn  then return false end
    if R.num_branch < 2 then return false end
    if R.num_branch > 4 then return false end

    local outdoor_chance = 5
    local lock_chance    = 50

    if STYLE.hallways == "heaps" then
      outdoor_chance = 50
      lock_chance = 90
    end

    each C in R.conns do
      local N = C:neighbor(R)
      if N.is_outdoor and not rand.odds(outdoor_chance) then
        return false
      end

      if C.R2 == R and C.lock and not rand.odds(lock_chance) then
        return false
      end

      if N.quest.kind == "secret" then return false end
    end

    local min_d = math.min(R.sw, R.sh)

    if min_d > 6 then return false end

    if STYLE.hallways == "heaps" then
      return rand.odds(HALL_SIZE_HEAPS[min_d])
    end

    if STYLE.hallways == "few" and rand.odds(66) then
      return false end

    return rand.odds(HALL_SIZE_PROBS[min_d])
  end

  local function hallway_neighbors(R)
    local hall_nb = 0
    each C in R.conns do
      local N = C:neighbor(R)
      if N.hallway then hall_nb = hall_nb + 1 end
    end

    return hall_nb
  end

  local function surrounded_by_halls(R)
    local hall_nb = hallway_neighbors(R)
    return (hall_nb == #R.conns) or (hall_nb >= 3)
  end

  local function stairwell_neighbors(R)
    local count = 0

    each C in R.conns do
      local N = C:neighbor(R)
      if N.kind == "stairwell" then count = count + 1 end
    end

    return count
  end

  local function locked_neighbors(R)
    local count = 0

    each C in R.conns do
      if C.lock then count = count + 1 end
    end

    return count
  end

  local function check_stairwell_extents(R)
    local sx1, sx2 = 999, 0
    local sy1, sy2 = 999, 0

    each C in R.conns do
      local S = C:seed(R)

      sx1 = math.min(sx1, S.sx) ; sx2 = math.max(sx2, S.sx)
      sy1 = math.min(sy1, S.sy) ; sy2 = math.max(sy2, S.sy)
    end

    local seed_w = (sx2 - sx1 + 1)
    local seed_h = (sy2 - sy1 + 1)

    local C1 = R.conns[1]
    local C2 = R.conns[2]

---??    if geom.is_perpendic(C1.dir, C2.dir) then
---??    end

    return (seed_w >= 3) and (seed_h >= 3)
  end


  local function try_make_stairwell(R)
    if R.hallway and R.num_branch == 2 and
       not R.purpose and
       #R.weapons == 0 and
       #R.items == 0 and
       not R.teleport_conn and
       locked_neighbors(R) == 0 and
       stairwell_neighbors(R) == 0 and
       check_stairwell_extents(R)
    then
      gui.printf("--> Stairwell @ %s\n", R:tostr())
      R.kind = "stairwell"
    end
  end


  ---| Room_decide_hallways |---

  if not THEME.hallway_walls then
    gui.printf("Hallways disabled (no theme info)\n")
    return
  end

  if STYLE.hallways == "none" then
    return
  end

  each R in LEVEL.rooms do
    if eval_hallway(R) then
      R.kind = "hallway"
      R.hallway = { }
      R.is_outdoor = nil

      gui.debugf("Hallway @ %s\n", R:tostr())
    end
  end

  -- large rooms which are surrounded by hallways are wasted,
  -- hence look for them and revert them back to normal.
  each R in LEVEL.rooms do
    if R.hallway and surrounded_by_halls(R) then
      local min_d = math.min(R.sw, R.sh)

      assert(min_d <= 6)

      if rand.odds(REVERT_PROBS[min_d]) then
        R.kind = "building"
        R.hallway = nil

        gui.debugf("Hallway REVERTED @ %s\n", R:tostr())
      end
    end
  end


  --- decide stairwells ---

  if not THEME.stairwell_walls then return end

  -- FIXME: the Build.stairwell() code is fucked, hence disabled.
  --
  --  Note: enabling this also requires placing Archways between a stairwell
  --        and a normal hallway
  do return end

  -- visit rooms in random order
  local room_list = table.copy(LEVEL.rooms)
  rand.shuffle(room_list)

  each R in room_list do
    try_make_stairwell(R)
  end
end



function Room_setup_symmetry()
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

    if STYLE.symmetry == "none" then return end

    local SYM_LIST = { "x", "y", "xy" }

    local syms  = { "none" }
    local probs = { 100 }

    if STYLE.symmetry == "few"   then probs[1] = 500 end
    if STYLE.symmetry == "heaps" then probs[1] = 10  end

    each sym in SYM_LIST do
      local p1 = prob_for_size(R, sym)
      local p2 = prob_for_match(R.symmetry, sym)

      if p1 > 0 and p2 > 0 then
        table.insert(syms, sym)
        table.insert(probs, p1*p2/100)
      end
    end

    local index = rand.index_by_probs(probs)

    R.symmetry = sel(index > 1, syms[index], nil)
  end

  local function mirror_horizontally(R)
    if R.sw >= 2 then
      for y = R.sy1, R.sy2 do
        for dx = 0, int((R.sw-2) / 2) do
          local LS = SEEDS[R.sx1 + dx][y]
          local RS = SEEDS[R.sx2 - dx][y]

          if LS.room == R and RS.room == R then
            LS.x_peer = RS
            RS.x_peer = LS
          end
        end
      end
    end
  end

  local function mirror_vertically(R)
    if R.sh >= 2 then
      for x = R.sx1, R.sx2 do
        for dy = 0, int((R.sh-2) / 2) do
          local BS = SEEDS[x][R.sy1 + dy]
          local TS = SEEDS[x][R.sy2 - dy]

          if BS.room == R and TS.room == R then
            BS.y_peer = TS
            TS.y_peer = BS
          end
        end
      end
    end
  end


  --| Room_setup_symmetry |--

  each R in LEVEL.rooms do
    decide_layout_symmetry(R)

    gui.debugf("Final symmetry @ %s : %s --> %s\n", R:tostr(),
               tostring(R.conn_symmetry), tostring(R.symmetry))

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



function Room_merge_sky_groups(R1, R2)
  assert(R1.sky_group)
  assert(R2.sky_group)

  if R1.sky_group == R2.sky_group then
    return
  end

  if R1.id > R2.id then R1, R2 = R2, R1 end

  -- the second SKY_GROUP table will never be used again
  local dead_group = R2.sky_group

  dead_group.h = "dead"

  each T in LEVEL.rooms do
    if T.sky_group == dead_group then
       T.sky_group = R1.sky_group
    end
  end

  each T in LEVEL.scenic_rooms do
    if T.sky_group == dead_group then
       T.sky_group = R1.sky_group
    end
  end
end



function Room_create_sky_groups()
  --
  -- This makes sure that any two outdoor rooms which touch will belong
  -- to the same 'sky_group' and hence get the same sky height.
  --
  -- Note: actual sky heights are determined later.
  --

  -- setup each room

  local all_rooms = {}

  table.append(all_rooms, LEVEL.rooms)
  table.append(all_rooms, LEVEL.scenic_rooms)

  each R in all_rooms do
    if R.is_outdoor then
      R.sky_group = {}
    end
  end

  -- merge neighbors which touch each other

  each R in all_rooms do
    each N in R.neighbors do
      if R.sky_group and N.sky_group then
        Room_merge_sky_groups(R, N)
      end
    end
  end
end



function Room_reckon_doors()

  local  indoor_prob = style_sel("doors", 0, 10, 30,  90)
  local outdoor_prob = style_sel("doors", 0, 30, 90, 100)


  local DEFAULT_PROBS = {}

  local function door_chance(R1, R2)
    local door_probs = THEME.door_probs or
                       GAME.door_probs or
                       DEFAULT_PROBS

    if R1.is_outdoor and R2.is_outdoor then
      return door_probs.out_both or 0

    elseif R1.is_outdoor or R2.is_outdoor then
      return door_probs.out_diff or 80

    elseif R1.kind == "stairwell" or R2.kind == "stairwell" then
      return door_probs.stairwell or 1

    elseif R1.hallway and R2.hallway then
      return door_probs.hall_both or 2

    elseif R1.hallway or R2.hallway then
      return door_probs.hall_diff or 60

    elseif R1.main_tex != R2.main_tex then
      return door_probs.combo_diff or 40

    else
      return door_probs.normal or 20
    end
  end


  local function visit_conn(C)
    if C.kind == "teleporter" then return end
    if C.kind == "closet"     then return end

    local S = C.S1
    local N = C.S2

    assert(S.conn_dir)
    assert(N.conn_dir)

    local B  = S.border[S.conn_dir]
    local B2 = N.border[N.conn_dir]

    if B.kind != "arch" then
      S, N  = N, S
      B, B2 = B2, B
    end

    assert(B.kind == "arch")

    -- ensure when going from outside to inside that the arch/door
    -- is made using the building combo (NOT the outdoor combo)
    if B.kind == "arch" and
       ((S.room.is_outdoor and not N.room.is_outdoor) or
        (S.room == N.room.parent))
    then
      -- swap borders
      S, N = N, S

      S.border[S.conn_dir] = B
      N.border[N.conn_dir] = B2
    end

    -- locked door?

    if C.lock then
      B.kind = "lock_door"
      B.lock = C.lock

      -- FIXME: smells like a hack!!
      if B.lock.switch and string.sub(B.lock.switch, 1, 4) == "bar_" then
        B.kind = "bars"
      end

      C.fresh_floor = true
      return
    end

    -- secret door ?

    local quest1 = S.room.quest
    local quest2 = N.room.quest

    if quest1 != quest2 and 
       (quest1.kind == "secret" or quest2.kind == "secret")
    then
      -- TODO: if both rooms are outdoor, make a ''secret fence''

      B.kind = "secret_door"

      -- mark the first seed so it can have the secret special
      C.S2.mark_secret = true
      return
    end

    -- don't need anything between two outdoor rooms
    if (S.room.is_outdoor and N.room.is_outdoor) and rand.odds(90) then
      B.kind  = "nothing"
      B2.kind = "nothing"
      return
    end

    -- don't need archways where two hallways connect
    if S.room.hallway and N.room.hallway then
      B.kind  = "nothing"
      B2.kind = "nothing"
      return
    end

    -- apply the random check
    local prob = indoor_prob
    if S.room.is_outdoor or N.room.is_outdoor then
      prob = outdoor_prob
    end

    if rand.odds(prob) then
      B.kind = "door"

      if rand.odds(30) then
        C.fresh_floor = true
      end

      return
    end

    -- support arches which have a step in them
    if (S.room.is_outdoor != N.room.is_outdoor) or rand.odds(50) then
      if not (S.room.hallway or N.room.hallway) then
        if S == C.S1 then
          C.diff_h = 16
        else
          C.diff_h = -16
        end
        C.fresh_floor = true
      end
    end
  end


  ---| Room_reckon_doors |---

  each C in LEVEL.conns do
    visit_conn(C)
  end
end



function Room_border_up()

  local function make_map_edge(R, S, side)
    if R.is_outdoor then
      -- a fence will be created by Layout_edge_of_map()
      S.border[side].kind = "nothing"
    else
      S.border[side].kind = "wall"
      S.border[side].can_fake_sky = true
      S.thick[side] = 16
    end
  end


  local function make_border(R1, S, R2, N, side)
    if R1 == R2 then
      -- same room : do nothing
      S.border[side].kind = "nothing"
      return
    end

    if R1.is_outdoor and R2.kind == "cave" then
      S.border[side].kind = "fence"

    elseif R1.kind == "cave" and R2.is_outdoor then
      S.border[side].kind = "nothing"

    elseif R1.is_outdoor then
      if R2.is_outdoor or R2.kind == "cave" then
        S.border[side].kind = "fence"
      else
        S.border[side].kind = "facade"
        S.border[side].w_tex = R2.facade
      end

      if N.kind == "liquid" and R2.is_outdoor and
        (S.kind == "liquid" or R1.quest == R2.quest)
        --!!! or (N.room.kind == "scenic" and safe_falloff(S, side))
      then
        S.border[side].kind = "nothing"
      end

      if STYLE.fences == "none" and R1.quest == R2.quest and R2.is_outdoor and
         (S.kind != "liquid" or S.floor_h == N.floor_h) and
         (R2.purpose != "EXIT") and
         not R1.teleport_conn and not R2.teleport_conn and
         R1.theme == R2.theme
      then
        S.border[side].kind = "nothing"
      end

    else -- R1 indoor

      S.border[side].kind = "wall"
      S.thick[side] = 16

      if R2.parent == R1 then
        S.border[side].kind  = "facade"
        S.border[side].w_tex = R2.main_tex
      end

      -- liquid arches are a kind of window
      if S.kind == "liquid" and N.kind == "liquid" and
         (S.floor_h == N.floor_h)  --- and rand.odds(50)
      then
        S.border[side].kind = "liquid_arch"
        N.border[10-side].kind = "nothing"

        S.thick[side] = 24
        N.thick[10 - side] = 24
        return
      end

      -- TODO: do this better, honor symmetry
      if S.kind == "liquid" and S.border[side].kind == "wall"
         and rand.odds(15)
      then
        S.border[side].kind = "liquid_fall"
      end
    end
  end


  local function try_make_corner(S, corner)
    local R = S.room
    local N = S:neighbor(corner)

    if not (N and N.room) then return end
    if N.room == R then return end

    if not (N.room.is_outdoor or N.room == R.parent) then return end

    local A = S:neighbor(geom.RIGHT_45[corner])
    local B = S:neighbor(geom. LEFT_45[corner])

    if not (A and A.room) then return end
    if not (B and B.room) then return end

    if (A.room == R) or (B.room == R) then return end

    if N.room.is_outdoor then
      -- don't need external corners unless all three sides are outdoor
      if not A.room.is_outdoor or not B.room.is_outdoor then return end
    else
      -- don't need internal corners unless the parent is on all three
      -- sides of the corner.
      if A.room != N.room or B.room != N.room then return end
    end

    -- OK

    local thick = 16

    local facade = R.facade

    if not N.room.is_outdoor then facade = R.main_tex end

    if "cool_corners" then
      thick  = 24
      facade = "METAL"
    end

    local x1, y1 = N.x1, N.y1
    local x2, y2 = N.x2, N.y2

    if corner == 1 then x1 = x2 - thick ; y1 = y2 - thick end
    if corner == 9 then x2 = x1 + thick ; y2 = y1 + thick end
    if corner == 3 then x2 = x1 + thick ; y1 = y2 - thick end
    if corner == 7 then x1 = x2 - thick ; y2 = y1 + thick end

    Trans.clear()
    Trans.solid_quad(x1, y1, x2, y2, facade)
  end


  local function border_up(R)
    local B_CORNERS = { 1,3,9,7 }

    for x = R.sx1, R.sx2 do
    for y = R.sy1, R.sy2 do
      local S = SEEDS[x][y]

      if S.room != R then continue end
        
      for side = 2,8,2 do
        if not S.border[side].kind then  -- don't clobber connections
          local N = S:neighbor(side)

          if not (N and N.room) then
            make_map_edge(R, S, side)
          else
            make_border(R, S, N.room, N, side)
          end
        end

        assert(S.border[side].kind)
      end -- side

      each corner in B_CORNERS do
        if not R.is_outdoor and R.kind != "cave" and R.kind != "hallway" then
          try_make_corner(S, corner)
        end
      end

    end -- x, y
    end
  end


  local function can_travel(R, R2, S0, side, off_dir, off_dist)
    local N0 = S0:neighbor(side)

    local S = S0:neighbor(off_dir, off_dist)

    if not (S and S.room == R) then return false end

    local N = S:neighbor(side)

    if not (N and N.room == R2) then return false end

    if S.kind != "walk" then return false end
    if N.kind != "walk" then return false end

    if S.floor_h != S0.floor_h then return false end
    if N.floor_h != N0.floor_h then return false end

    local S_kind = S.border[     side].kind
    local N_kind = N.border[10 - side].kind

    if S_kind != "wall" then return false end
    if N_kind != "wall" then return false end

    return true
  end

  
  local function repeat_arch(S0, side, off_dir, off_count)
    local N0 = S0:neighbor(side)

    for off_dist = 1, off_count do
      local S = S0:neighbor(off_dir, off_dist)
      local N = S:neighbor(side)

      -- hmmmm, is it kosher to just re-use the border tables?

      S.border[side]      = S0.border[side]
      N.border[10 - side] = N0.border[10 - side]
    end
  end


  local function apply_repeat_arch(S, side, A_dir, A_num, B_dir, B_num)
    repeat_arch(S, side, A_dir, A_num)
    repeat_arch(S, side, B_dir, B_num)

    -- sometimes only keep the two arches on the edges

    if (A_num + B_num) >= 2 and rand.odds(75) then
      for i = -A_num + 1, B_num - 1 do
        local T
        if i < 0 then
          T = S:neighbor(A_dir, -i)
        else
          T = S:neighbor(B_dir,  i)
        end

        local TN = T:neighbor(side)

        -- reconstruct the walls

        T.border[side] = {}
        TN.border[10 - side] = {}

        make_border(T.room, T, TN.room, TN, side)
        make_border(TN.room, TN, T.room, T, 10 - side)
      end
    end
  end


  local function apply_widen_arch(S, side, A_dir, A_num, B_dir, B_num)
    -- setup the leftmost/bottommost seed border as the wide arch

    local base = S:neighbor(A_dir, A_num)

    base.border[side] = S.border[side]
    base.border[side].seed_w = 1 + A_num + B_num

    if S != base then
      S.border[side] = {}
    end

    -- and make all other seed borders be "straddle"

    for dist = 0, A_num + B_num do
      local T = base:neighbor(B_dir, dist)

      if T != base then
        T.border[side].kind = "straddle"
      end

      local TN = T:neighbor(side)

      TN.border[10 - side].kind = "straddle"
    end
  end


  local function try_widen_arch(R, R2, S, S2, side)
    if R.kind == "stairwell" or R2.kind == "stairwell" then
      return
    end

    -- got the wrong side?
    if S.border[side].kind == "straddle" then
      R, R2 = R2, R
      S, S2 = S2, S
      side = 10 - side
    end

    -- we don't do doors yet...
    if S.border[side].kind != "arch" then return end

    local A_dir = geom.RIGHT[side]
    local B_dir = geom. LEFT[side]

    if A_dir > B_dir then
       A_dir, B_dir = B_dir, A_dir
    end

    local A_num = 0
    local B_num = 0

    while A_num < 3 and can_travel(R, R2, S, side, A_dir, A_num+1) do
      A_num = A_num + 1
    end

    while B_num < 3 and can_travel(R, R2, S, side, B_dir, B_num+1) do
      B_num = B_num + 1
    end


    -- nothing possible?
    if A_num == 0 and B_num == 0 then
      return
    end

    -- don't make TOO wide
    while A_num + B_num > 4 do
      if A_num > B_num or (A_num == B_num and rand.odds(50)) then
        A_num = A_num - 1
      else
        B_num = B_num - 1
      end
    end

    assert(A_num >= 0)
    assert(B_num >= 0)

    -- the wider the space, the less chance we make a single arch
    local repeat_prob = (A_num + B_num + 1) * 15

    if rand.odds(repeat_prob) then
      apply_repeat_arch(S, side, A_dir,A_num, B_dir,B_num)
    else
      apply_widen_arch (S, side, A_dir,A_num, B_dir,B_num)
    end
  end


  local function widen_arches()
    -- sometimes make an archway or door between two rooms wider

    each C in LEVEL.conns do
      if C.kind != "normal" then continue end
      if C.lock then continue end

      assert(C.S1)

      try_widen_arch(C.R1, C.R2, C.S1, C.S2, C.dir)
    end
  end


  local function seed_is_blocked(S)
    if S.kind == "void" then return true end
    if S.kind == "diagonal" then return true end
    if S.kind == "tall_stair" then return true end

    return false
  end


  local function get_border_list(R)
    local list = {}

    for x = R.sx1, R.sx2 do
    for y = R.sy1, R.sy2 do
      local S = SEEDS[x][y]

      if S.room == R and not seed_is_blocked(S) then
        for side = 2,8,2 do
          if S.border[side].kind == "wall" then
            table.insert(list, { S=S, side=side })
          end
        end
      end

    end -- for x, y
    end

    return list
  end


  local function score_window_side(R, side, border_list)
    local min_c1, max_f1 = 999, -999
    local min_c2, max_f2 = 999, -999

    local count   = 0
    local scenics = 0
    local doors   = 0
    local futures = 0
    local indoors = 0
    local entry   = 0

    local info = { side=side, seeds={} }

    each C in R.conns do
      if C.kind == "teleporter" then continue end

      local S = C:seed(R)
      local B = S.border[side]

      if S.conn_dir != side then continue end

      -- never any windows near a locked door
      if C.lock then
        return nil
      end

      if B.kind == "door" or B.kind == "arch" then
        doors = doors + 1
      end

      if C == R.entry_conn then
        entry = 1
      end
    end


    each bd in border_list do
      local S = bd.S
      local N = S:neighbor(side)

      if (bd.side == side) and S.floor_h and
         (N and N.room) and N.floor_h and
         not seed_is_blocked(N)
      then
        table.insert(info.seeds, S)

        count = count + 1

        if not N.room.is_outdoor then
          indoors = indoors + 1
        end

        if N.room.kind == "scenic" then
          scenics = scenics + 1
        end

        if S.room.quest and N.room.quest and (S.room.quest.id < N.room.quest.id) then
          futures = futures + 1
        end

        min_c1 = math.min(min_c1, assert(S.ceil_h or R.ceil_h))
        min_c2 = math.min(min_c2, assert(N.ceil_h or N.room.ceil_h))

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

    -- sub-rooms are much better with windows
    if R.parent then score = score + 60 end

    if scenics >= 1 then score = score + 120 end
    if entry   == 0 then score = score + 40 end

    if indoors == 0 then score = score + 25 end
    if doors   == 0 then score = score + 20 end
    if futures == 0 then score = score + 10 end

    gui.debugf("Window score @ %s ^%d --> %d\n", R:tostr(), side, score)

    info.score = score


    -- prevent mixture of indoor and outdoor
    info.outdoor = true

    if indoors >= count / 2 then
      info.outdoor = false
    end


    -- implement the window style
    if (STYLE.windows == "few"  and score < 370) or
       (STYLE.windows == "some" and score < 280)
    then
      return nil
    end

    -- determine height of window
    if (min_c - max_f) >= 160 and rand.odds(65) and info.outdoor then
      info.z1 = max_f
      info.z2 = min_c
      info.is_tall = true
    -- !!! FIXME short windows which are up high
    elseif (max_f1 < max_f2) and rand.odds(30 * 0) then
      info.z1 = min_c - 112
    else
      info.z1 = max_f
    end

    -- determine width & doubleness
    local thin_chance = math.min(6, usable) * 20 - 40
    local dbl_chance  = 80 - math.min(3, usable) * 20

    if usable >= 3 and rand.odds(thin_chance) then
      info.kind = "narrow"
    elseif usable <= 3 and rand.odds(dbl_chance) then
      info.kind = "double"
    else
      info.kind = "wide"
    end

    return info
  end


  local function add_windows(R, info, border_list)
    local side = info.side

    each S in info.seeds do
      local N = S:neighbor(side)
      assert(N and N.room)

      if sel(N.room.is_outdoor, 1, 0) != sel(info.outdoor, 1, 0) then
        continue
      end

      S.border[side].kind = "window"

      S.border[side].win_kind  = info.kind
      S.border[side].win_z1    = info.z1
      S.border[side].win_z2    = info.z2  -- can be absent (=> non-fitted)

      N.border[10-side].kind = "straddle"
    end
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
    if R.kind != "building" then return end
    if R.semi_outdoor then return end
    if STYLE.windows == "none" then return end

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
    v_space = v_space - 16
    -- FIXME: needs more v_space checking

    if not THEME.logos then
      error("Game is missing logo skins")
    end

    if rand.odds(sel(LEVEL.has_logo,7,40)) then
      LEVEL.has_logo = true
      return rand.key_by_probs(THEME.logos)
    end

    if R.has_liquid and index == 1 and rand.odds(75) then
      if THEME.liquid_pics then
        return rand.key_by_probs(THEME.liquid_pics)
      end
    end

    local pic_tab = {}

    local pictures = THEME.pictures

    if pictures then
      for name,prob in pairs(pictures) do
        local info = GAME.PICTURES[name]
        if info and info.height <= v_space then
          pic_tab[name] = prob
        end
      end
    end

    if not table.empty(pic_tab) then
      return rand.key_by_probs(pic_tab)
    end

    -- fallback
    return rand.key_by_probs(THEME.logos)
  end


  local function install_pic(R, bd, pic_name, v_space)
    skin = assert(GAME.PICTURES[pic_name])

    local cross_hack  -- FIXME: TEMP RUBBISH
    if THEME.keys and THEME.keys["ks_red"] then
      cross_hack = true -- rand.odds(30)
    end

    -- handles symmetry

    for dx = 1,sel(R.mirror_x, 2, 1) do
    for dy = 1,sel(R.mirror_y, 2, 1) do
        local S    = bd.S
        local side = bd.side

        if dx == 2 then
          S = S.x_peer
          if not S then break; end
          if geom.is_horiz(side) then side = 10-side end
        end

        if S and dy == 2 then
          S = S.y_peer
          if not S then break; end
          if geom.is_vert(side) then side = 10-side end
        end

        local B = S.border[side]

        if B.kind == "wall" and S.floor_h then
          local raise = skin.raise or 32
          if raise + skin.height > v_space-4 then
            raise = int((v_space - skin.height) / 2)
          end
          B.kind = "picture"
          B.pic_skin = skin
          B.pic_z1 = S.floor_h + raise

          if cross_hack then B.kind = "cross" end
        end

    end -- dx, dy
    end
  end


  local function decide_pictures(R, border_list)
    if R.kind != "building" then return end
    if R.semi_outdoor then return end

    -- filter border list to remove symmetrical peers, seeds
    -- with pillars, etc..  Also determine vertical space.
    local new_list = {}

    local v_space = 999

    each bd in border_list do
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
    local perc = rand.pick { 20,30,40 }

    if STYLE.pictures == "heaps" then perc = 50 end
    if STYLE.pictures == "few"   then perc = 10 end

    -- FIXME: support "none" but also force logos to appear
    if STYLE.pictures == "none"  then perc =  7 end

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
        if pics[2].pic_w != pics[1].pic_w then break; end
      end
    end

    gui.debugf("Selected pics: %s %s\n", pics[1], pics[2])


    for loop = 1,count do
      if #new_list == 0 then break; end

      -- FIXME !!!! SELECT GOOD SPOT
      local b_index = rand.irange(1, #new_list)

      local bd = table.remove(new_list, b_index)
      
      install_pic(R, bd, pics[1 + (loop-1) % 2], v_space)
    end -- for loop
  end


  ---| Room_border_up |---
  
  each R in LEVEL.rooms do
    border_up(R)
  end
  each R in LEVEL.scenic_rooms do
    border_up(R)
  end

  widen_arches()

  each R in LEVEL.rooms do
    decide_windows( R, get_border_list(R))
    decide_pictures(R, get_border_list(R))
  end
end



function Room_make_ceiling(R)

  local function outdoor_ceiling()
    local sky_h = R.floor_max_h + rand.pick { 144, 160, 176 }

    R.sky_group.h = math.max(R.sky_group.h or SKY_H, sky_h)

    -- ceil_h is set later, as this sky group may be raised again
  end


  local function periph_size(PER)
    if PER[2] then return 3 end
    if PER[1] then return 2 end
    if PER[0] then return 1 end
    return 0
  end


  local function get_max_drop(side, offset)
    local drop_z
    local x1,y1, x2,y2 = geom.side_coords(side, R.tx1,R.ty1, R.tx2,R.ty2, offset)

    for x = x1,x2 do for y = y1,y2 do
      local S = SEEDS[x][y]
      if S.room == R then

        local f_h
        if S.kind == "walk" then
          f_h = S.floor_h
        elseif S.diag_new_kind == "walk" then
          f_h = S.diag_new_z or S.floor_h
        elseif S.kind == "stair" or S.kind == "lift" then
          f_h = math.max(S.stair_z1, S.stair_z2)
        elseif S.kind == "curve_stair" or S.kind == "tall_stair" then
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
    if not THEME.periph_pillar_mat then
      return
    end

    local info = add_pegging(get_mat(THEME.periph_pillar_mat))

    local x1,y1, x2,y2 = geom.side_coords(side, R.tx1,R.ty1, R.tx2,R.ty2, offset)

    if geom.is_vert(side) then x2 = x2-1 else y2 = y2-1 end

    local x_dir = sel(side == 6, -1, 1)
    local y_dir = sel(side == 8, -1, 1)

    for x = x1,x2 do for y = y1,y2 do
      local S = SEEDS[x][y]

      -- check if all neighbors are in same room
      local count = 0

      for dx = 0,1 do for dy = 0,1 do
        local nx = x + dx * x_dir
        local ny = y + dy * y_dir

        if Seed_valid(nx, ny) and SEEDS[nx][ny].room == R then
          count = count + 1
        end
      end end -- for dx,dy

      if count == 4 then
        local w = 12

        local px = sel(x_dir < 0, S.x1, S.x2)
        local py = sel(y_dir < 0, S.y1, S.y2)

        Trans.old_quad(info, px-w, py-w, px+w, py+w, -EXTREME_H, EXTREME_H)
        
        R.has_periph_pillars = true

        -- mark seeds [crude way to prevent stuck masterminds]
        for dx = 0,1 do for dy = 0,1 do
          local nx = x + dx * x_dir
          local ny = y + dy * y_dir

          SEEDS[nx][ny].solid_corner = true
        end end -- for dx,dy
      end
    end end -- for x, y
  end


  local function create_periph_info(side, offset)
    local t_size = sel(geom.is_horiz(side), R.tw, R.th)

    if t_size < (3+offset*2) then return nil end

    local drop_z = get_max_drop(side, offset)

    if not drop_z or drop_z < 30 then return nil end

    local PER = { max_drop=drop_z }

    if t_size == (3+offset*2) then
      PER.tight = true
    end

    if R.pillar_rows then
      each row in R.pillar_rows do
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

    if P1.tight and rand.odds(90) then return nil end

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
    if (R.th > R.tw) or (R.th == R.tw and rand.odds(50)) then
      SIDES = { 4,2 }
    end
    if rand.odds(10) then  -- swap 'em
      SIDES[1], SIDES[2] = SIDES[2], SIDES[1]
    end

    for idx,side in ipairs(SIDES) do
      if (R.symmetry == "xy" or R.symmetry == sel(side==2, "y", "x")) or
         R.pillar_rows and geom.is_parallel(R.pillar_rows[1].side, side) or
         rand.odds(50)
      then
        --- Symmetrical Mode ---

        local PER_0 = merge_periphs(side, 0)
        local PER_1 = merge_periphs(side, 1)

        if PER_0 and PER_1 and rand.odds(sel(PER_1.pillars, 70, 10)) then
          PER_0 = nil
        end

        if PER_0 then PER_0.drop_z = PER_0.max_drop / idx end
        if PER_1 then PER_1.drop_z = PER_1.max_drop / idx / 2 end

        R.periphs[side][0] = PER_0 ; R.periphs[10-side][0] = PER_0
        R.periphs[side][1] = PER_1 ; R.periphs[10-side][1] = PER_1
        R.periphs[side][2] = nil   ; R.periphs[10-side][2] = nil

        if idx==1 and PER_0 and not R.pillar_rows and rand.odds(50) then
          add_periph_pillars(side)
          add_periph_pillars(10-side)
        end
      else
        --- Funky Mode ---

        -- pick one side to use   [FIXME]
        local keep = rand.sel(50, side, 10-side)

        for n = 0,2 do R.periphs[10-keep][n] = nil end

        local PER_0 = R.periphs[keep][0]
        local PER_1 = R.periphs[keep][1]

        if PER_0 and PER_1 and rand.odds(5) then
          PER_0 = nil
        end

        if PER_0 then PER_0.drop_z = PER_0.max_drop / idx end
        if PER_1 then PER_1.drop_z = PER_1.max_drop / idx / 2 end

        R.periphs[keep][2] = nil

        if idx==1 and PER_0 and not R.pillar_rows and rand.odds(75) then
          add_periph_pillars(keep)

        --??  if PER_1 and rand.odds(10) then
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

    R.cw, R.ch = geom.group_size(R.cx1, R.cy1, R.cx2, R.cy2)

    assert(R.cw >= 1)
    assert(R.ch >= 1)
  end


  local function install_periphs()
    for x = R.tx1, R.tx2 do for y = R.ty1, R.ty2 do
      local S = SEEDS[x][y]
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


  local function fill_xyz(ch, is_sky, c_tex, c_light)
    for x = R.cx1, R.cx2 do for y = R.cy1, R.cy2 do
      local S = SEEDS[x][y]
      if S.room == R then
      
        S.ceil_h  = ch
        S.is_sky  = is_sky
        S.c_tex   = c_tex
        S.c_light = c_light

      end -- if S.room == R
    end end -- for x, y
  end


  local function add_central_pillar()
    -- big rooms only
    if R.cw < 3 or R.ch < 3 then return end

    -- centred only
    if (R.cw % 2) == 0 or (R.ch % 2) == 0 then return end

    local skin_names = THEME.big_pillars or THEME.pillars
    if not skin_names then return end


    local mx = R.cx1 + int(R.cw / 2)
    local my = R.cy1 + int(R.ch / 2)

    local S = SEEDS[mx][my]

    -- seed is usable?
    if S.room != R or S.content then return end
    if not (S.kind == "walk" or S.kind == "liquid") then return end

    -- neighbors the same?
    for side = 2,8,2 do
      local N = S:neighbor(side)
      if not (N and N.room == S.room and N.kind == S.kind) then
        return
      end
    end

    -- OK !!
    local which = rand.key_by_probs(skin_names)

    S.content = "pillar"
    S.is_big_pillar = true
    S.pillar_skin = assert(GAME.PILLARS[which])

    R.has_central_pillar = true

    gui.debugf("Central pillar @ (%d,%d) skin:%s\n", S.sx, S.sy, which)
  end


  local function central_niceness()
    local nice = 2

    for x = R.cx1, R.cx2 do
    for y = R.cy1, R.cy2 do
      local S = SEEDS[x][y]
      
      if S.room != R then return 0 end
      
      if S.kind == "void" or
         S.kind == "tall_stair" or
         S.content == "pillar" or
         S.mark_secret
      then
        nice = 1
      end
    end -- x, y
    end

    return nice
  end


  local function test_cross_beam(dir, x1,y1, x2,y2, mode)
    -- FIXME: count usable spots, return false for zero

    for x = x1,x2 do for y = y1,y2 do
      local S = SEEDS[x][y]
      assert(S.room == R)

      if S.kind == "lift" or S.kind == "tall_stair" or
         S.raising_start or S.mark_secret
      then
        return false
      end

      if mode == "light" and (S.kind == "diagonal") then
        return false
      end
    end end -- for x, y

    return true
  end


  local function add_cross_beam(dir, x1,y1, x2,y2, mode)
    local skin
    
    if mode == "light" then
      if not R.quest.ceil_light then return end
      skin = { w=R.lite_w, h=R.lite_h, lite_f=R.quest.ceil_light, trim=THEME.light_trim }
    end

    for x = x1,x2 do for y = y1,y2 do
      local S = SEEDS[x][y]
      local ceil_h = S.ceil_h or R.ceil_h

      if ceil_h and S.kind != "void" then
        if mode == "light" then
          if S.content != "pillar" and not S.mark_secret then
            Build.ceil_light(S, ceil_h, skin)
          end
        else
          Build.cross_beam(S, dir, 64, ceil_h - 16, THEME.beam_mat)
        end
      end
    end end -- for x, y
  end


  local function decide_beam_pattern(poss, total, mode)
    if table.empty(poss) then return false end

    -- FIXME !!!
    return true
  end


  local function criss_cross_beams(mode)
    if not THEME.beam_mat then return false end

    if R.children then return false end

    R.lite_w = 64
    R.lite_h = 64

    local poss = {}

    if R.cw > R.ch or (R.cw == R.ch and rand.odds(50)) then
      -- vertical beams

      if rand.odds(20) then R.lite_h = 192 end
      if rand.odds(10) then R.lite_h = 128 end
      if rand.odds(30) then R.lite_h = R.lite_w end

      for x = R.cx1, R.cx2 do
        poss[x - R.cx1 + 1] = test_cross_beam(8, x, R.ty1, x, R.ty2, mode)
      end

      if not decide_beam_pattern(poss, R.cx2 - R.cx1 + 1, mode) then
        return false
      end

      for x = R.cx1, R.cx2 do
        if poss[x - R.cx1 + 1] then
          add_cross_beam(8, x, R.ty1, x, R.ty2)
        end
      end

    else -- horizontal beams

      if rand.odds(20) then R.lite_w = 192 end
      if rand.odds(10) then R.lite_w = 128 end
      if rand.odds(30) then R.lite_w = R.lite_h end

      for y = R.cy1, R.cy2 do
        poss[y - R.cy1 + 1] = test_cross_beam(6, R.tx1, y, R.tx2, y, mode)
      end

      if not decide_beam_pattern(poss, R.cy2 - R.cy1 + 1, mode) then
        return false
      end

      for y = R.cy1, R.cy2 do
        if poss[y - R.cy1 + 1] then
          add_cross_beam(6, R.tx1, y, R.tx2, y, mode)
        end
      end
    end

    return true
  end


  local function corner_supports()
    if not THEME.corner_supports then
      return false
    end

    local mat = rand.key_by_probs(THEME.corner_supports)

    local SIDES = { 1, 7, 3, 9 }

    -- first pass only checks if possible
    for loop = 1,2 do
      local poss = 0

      for where = 1,4 do
        local cx = sel((where <= 2), R.tx1, R.tx2)
        local cy = sel((where % 2) == 1, R.ty1, R.ty2)
        local S = SEEDS[cx][cy]
        if S.room == R and not S.conn and
           (S.kind == "walk" or S.kind == "liquid")
        then

          poss = poss + 1

          if loop == 2 then
            local skin = { w=24, beam_w=mat, x_offset=0 }
            ---## if R.has_lift or (R.id % 5) == 4 then
            ---##   skin = { w=24, beam_w="SUPPORT3", x_offset=0 }
            ---## end
            Build.corner_beam(S, SIDES[where], skin)
          end

        end
      end

      if poss < 3 then return false end
    end

    return true
  end


  local function do_central_area()
    calc_central_area()

    local has_sky_nb = R:has_sky_neighbor()

    if R.has_periph_pillars and not has_sky_nb and rand.odds(16) then
      fill_xyz(R.ceil_h, true)
      R.semi_outdoor = true
      return
    end


    if rand.odds(20) then return end

    if not R.quest.ceil_light and THEME.ceil_lights then
      R.quest.ceil_light = rand.key_by_probs(THEME.ceil_lights)
    end

    local beam_chance = style_sel("beams", 0, 5, 20, 50)

    if rand.odds(beam_chance) then
      if criss_cross_beams("beam") then return end
    end

    if rand.odds(35) then
      if criss_cross_beams("light") then return end
    end


    -- shrink central area until there are nothing which will
    -- get in the way of a ceiling prefab.
    local nice = central_niceness()

gui.debugf("Original @ %s over %dx%d -> %d\n", R:tostr(), R.cw, R.ch, nice)

    while nice < 2 and (R.cw >= 3 or R.ch >= 3) do
      
      if R.cw > R.ch or (R.cw == R.ch and rand.odds(50)) then
        assert(R.cw >= 3)
        R.cx1 = R.cx1 + 1
        R.cx2 = R.cx2 - 1
      else
        assert(R.ch >= 3)
        R.cy1 = R.cy1 + 1
        R.cy2 = R.cy2 - 1
      end

      R.cw, R.ch = geom.group_size(R.cx1, R.cy1, R.cx2, R.cy2)

      nice = central_niceness()
    end
      
gui.debugf("Niceness @ %s over %dx%d -> %d\n", R:tostr(), R.cw, R.ch, nice)


    add_central_pillar()

    if nice != 2 then return end

      local ceil_info  = get_mat(R.main_tex)
      local sky_info   = get_fake_sky()
      local brown_info = get_mat(rand.key_by_probs(R.theme.ceilings))

      local light_name = rand.key_by_probs(THEME.big_lights or { FLOOR0_1=50 })
      local light_info = get_mat(light_name)
      light_info.b_face.light = 176

      -- lighting effects
      -- (They can break lifts, hence the check here)
      -- FIXME !!
      if not R.has_lift and false then
            if rand.odds(10) then light_info.sec_kind = 8
        elseif rand.odds(6)  then light_info.sec_kind = 3
        elseif rand.odds(3)  then light_info.sec_kind = 2
        end
      end

    local trim   = THEME.ceiling_trim
    local spokes = THEME.ceiling_spoke

    if STYLE.lt_swapped != "none" then
      trim, spokes = spokes, trim
    end

    if STYLE.lt_trim == "none" or (STYLE.lt_trim == "some" and rand.odds(50)) then
      trim = nil
    end
    if STYLE.lt_spokes == "none" or (STYLE.lt_spokes == "some" and rand.odds(70)) then
      spokes = nil
    end

    if R.cw == 1 or R.ch == 1 then
      fill_xyz(R.ceil_h+32, false, light_name, 0.75)
      return
    end

    local shape = rand.sel(30, "square", "round")

    local w = 96 + 140 * (R.cw - 1)
    local h = 96 + 140 * (R.ch - 1)
    local z = (R.cw + R.ch) * 8

    local prob = sel(THEME.big_lights, 60, 80)

    if (not has_sky_nb or (R.sh >= 4 and R.sw >= 4)) and
       not R.parent and rand.odds(prob)
    then
      light_info = sky_info
    else
      if not THEME.big_lights then return end

      if rand.odds(20) then light_info = brown_info end
    end

    Build.sky_hole(R.cx1,R.cy1, R.cx2,R.cy2, shape, w, h,
                   ceil_info, R.ceil_h,
                   light_info, R.ceil_h + z,
                   trim, spokes)
  end


  local function indoor_ceiling()
    if R.kind != "building" then
      return
    end

    assert(R.floor_max_h)

    local avg_h = int((R.floor_min_h + R.floor_max_h) / 2)
    local min_h = R.floor_max_h + 128

    local tw = R.tw or R.sw
    local th = R.th or R.sh

    local approx_size = (2 * math.min(tw, th) + math.max(tw, th)) / 3.0
    local tallness = (approx_size + rand.range(-0.6,1.6)) * 64.0

    if tallness < 128 then tallness = 128 end
    if tallness > 448 then tallness = 448 end

    R.tallness = int(tallness / 32.0) * 32

    gui.debugf("Tallness @ %s --> %d\n", R:tostr(), R.tallness)
 
    R.ceil_h = math.max(min_h, avg_h + R.tallness)

    R.ceil_tex = rand.key_by_probs(R.theme.ceilings)


    decide_periphs()

    install_periphs()

    do_central_area()
  end


  ---| Room_make_ceiling |---

  if R.is_outdoor then
    outdoor_ceiling()
  else
    indoor_ceiling()
  end
end



function Room_layout_all()
  each R in LEVEL.rooms do
    Layout_room(R)
  end

  each R in LEVEL.scenic_rooms do
    Layout_scenic(R)
  end
end



function Room_plaster_ceilings()
  each R in LEVEL.rooms do
    Room_make_ceiling(R)
  end

  each R in LEVEL.scenic_rooms do
    Room_make_ceiling(R)
  end

  -- get the final 'ceil_h' value for each room

  each R in LEVEL.rooms do
    if R.is_outdoor then R.ceil_h = R.sky_group.h end
  end

  each R in LEVEL.scenic_rooms do
    if R.is_outdoor then R.ceil_h = R.sky_group.h end
  end
end



function Room_add_crates(R)

  -- NOTE: temporary crap!
  -- (might be slightly useful for finding big spots for masterminds)

  local function test_spot(S, x, y)
    if S.solid_corner then return false end

    for dx = 0,1 do
    for dy = 0,1 do
      local N = SEEDS[x+dx][y+dy]

      if not N or N.room != S.room then return false end

      if N.kind != "walk" or not N.floor_h then return false end

      if math.abs(N.floor_h - S.floor_h) > 0.5 then return false end
    end -- dx, dy
    end

    return true
  end

  local function find_spots()
    local list = {}

    for x = R.tx1, R.tx2-1 do
    for y = R.ty1, R.ty2-1 do
      local S = SEEDS[x][y]

      if S.room == R and S.kind == "walk" and S.floor_h then
        if test_spot(S, x, y) then
          table.insert(list, { S=S, x=x, y=y })
        end
      end
    end
    end

    return list
  end


  --| Room_add_crates |--

  if STYLE.crates == "none" then return end

  if not (R.kind == "building" or R.kind == "outdoor") then return end

  local skin
  local skin_names

  if R.is_outdoor then
    -- FIXME: don't separate them
    skin_names = THEME.out_crates
  else
    skin_names = THEME.crates
  end

  if not skin_names then return end
  skin = assert(GAME.CRATES[rand.key_by_probs(skin_names)])

  local chance

  if STYLE.crates == "heaps" then
    chance = sel(R.is_outdoor, 25, 40)
    if rand.odds(20) then chance = chance * 2 end
  else
    chance = sel(R.is_outdoor, 15, 25)
    if rand.odds(10) then chance = chance * 3 end
  end

  each spot in find_spots() do
    if rand.odds(chance) then
      spot.S.solid_corner = true
      local z_top = spot.S.floor_h + (skin.h or 64)
      Build.crate(spot.S.x2, spot.S.y2, z_top, skin, R.is_outdoor)
    end
  end
end



function Room_tizzy_up()

  ---| Room_tizzy_up |---

  each R in LEVEL.rooms do
    Room_add_crates(R)
  end
end



function Room_do_small_exit()
  local C = R.conns[1]
  local T = C:seed(C:neighbor(R))
  local out_combo = T.room.main_tex
  if T.room.is_outdoor then out_combo = R.main_tex end

  -- FIXME: use single one over a whole episode
  local skin_name = rand.key_by_probs(THEME.small_exits)
  local skin = assert(GAME.EXITS[skin_name])

  local skin2 =
  {
    wall = out_combo,
    floor = T.f_tex or C.conn_ftex,
    ceil = out_combo,
  }

  assert(THEME.exit.switches)
  -- FIXME: hacky
  skin.switch = rand.key_by_probs(THEME.exit.switches)

  Build.small_exit(R, THEME.exit, skin, skin2)
  return
end


function Room_do_stairwell(R)
  if not LEVEL.well_tex then
    LEVEL.well_tex   = rand.key_by_probs(THEME.stairwell_walls)
    LEVEL.well_floor = rand.key_by_probs(THEME.stairwell_floors)
  end

  local skin = { wall=LEVEL.well_tex, floor=LEVEL.wall_floor }
  Build.stairwell(R, skin)
end


function Room_build_seeds(R)

  local function dir_for_wotsit(S)
    local dirs  = {}
    local missing_dir
  
    for dir = 2,8,2 do
      local N = S:neighbor(dir)
      if N and N.room == R and N.kind == "walk" and
         N.floor_h and math.abs(N.floor_h - S.floor_h) < 17
      then
        table.insert(dirs, dir)
      else
        missing_dir = dir
      end
    end

    if #dirs == 1 then return dirs[1] end

    if #dirs == 3 then return 10 - missing_dir end

    if S.room.entry_conn and S.room.entry_conn.kind != "teleporter" then
      local entry_S = S.room.entry_conn:seed(S.room)
      local exit_dir = assert(entry_S.conn_dir)

      if #dirs == 0 then return exit_dir end

      each dir in dirs do
        if dir == exit_dir then return exit_dir end
      end
    end

    if #dirs > 0 then
      return rand.pick(dirs)
    end

    return rand.irange(1,4)*2
  end


  local function player_dir(S)
    if R.sh > R.sw then
      if S.sy > (R.sy1 + R.sy2) / 2 then 
        return 2
      else
        return 8
      end
    else
      if S.sx > (R.sx1 + R.sx2) / 2 then 
        return 4
      else
        return 6
      end
    end
  end


  local function outer_tex(S, dir, w_tex)
    local N = S:neighbor(dir)

    if not (N and N.room) then
      return w_tex
    elseif N.room.hallway then
      return LEVEL.hall_tex
    elseif N.room.stairwell then
      return LEVEL.well_tex
    elseif not N.room.is_outdoor and N.room != R.parent then
      return N.w_tex or N.room.main_tex
    elseif N.room.is_outdoor and not (R.is_outdoor or R.kind == "cave") then
      return R.facade or w_tex
    else
      return w_tex
    end
  end


  local function content_big_item(item, mx, my, z)
    local fab_name = "Item_pedestal"

    -- FIXME: TEMP RUBBISH
    if string.sub(item, 1, 2) == "ks" then
      fab_name = "Item_pentagram"
    end

    local skin1 = GAME.SKINS[fab_name]
    assert(skin1)

    local skin0 = { wall=R.main_tex }
    local skin2 = { item=item }

    local T = Trans.spot_transform(mx, my, z, 2) -- TODO: spot_dir

    Fabricate_at(R, skin1, T, { skin0, skin1, skin2 })
  end


  local function content_start_pad(mx, my, z, dir)
    local skin1 = GAME.SKINS["Start_basic"]
    assert(skin1)

    local skin0 = { wall=R.main_tex }
    local skin2 = { }

    local T = Trans.spot_transform(mx, my, z, 10 - dir)

    Fabricate_at(R, skin1, T, { skin0, skin1, skin2 })
  end


  local function content_coop_pair(mx, my, z, dir)
    -- no prefab for this : add player entities directly

    local angle = geom.ANGLES[dir]

    local dx, dy = geom.delta(dir)

    dx = dx * 24 ; dy = dy * 24

    Trans.entity(R.player_pair[1], mx - dy, my + dx, z, { angle=angle })
    Trans.entity(R.player_pair[2], mx + dy, my - dx, z, { angle=angle })
  end


  local function content_start(S, mx, my, z1)
    local dir = player_dir(S)

    if R.player_pair then
      content_coop_pair(mx, my, z1, dir)

    elseif false and PARAM.raising_start and R.svolume >= 20 and
       R.kind != "cave" and
       THEME.raising_start_switch and rand.odds(25)
    then
      -- TODO: fix this
      gui.debugf("Raising Start made\n")

      local skin =
      {
        f_tex = S.f_tex or R.main_tex,
        switch_w = THEME.raising_start_switch,
      }

      Build.raising_start(S, 6, z1, skin)
      angle = 0

      S.no_floor = true
      S.raising_start = true
      R.has_raising_start = true
    else
      content_start_pad(mx, my, z1, dir)
    end

    -- save position for the demo generator
    LEVEL.player_pos =
    {
      S=S, R=R, x=mx, y=my, z=z1, angle=angle
    }
  end


  local function content_exit(S, mx, my, z1)
    local CS = R.conns[1]:seed(R)
    local dir = dir_for_wotsit(S)

    local sw_special = 11
    if R.purpose == "SECRET_EXIT" then sw_special = 51 end

    if R.is_outdoor and THEME.out_exits then
      -- FIXME: use single one for a whole episode
      local skin_name = rand.key_by_probs(THEME.out_exits)
      local skin = assert(GAME.EXITS[skin_name])
      Build.outdoor_exit_switch(S, dir, z1, skin, sw_special)

    elseif THEME.exits then
      -- FIXME: use single one for a whole episode
      local skin_name = rand.key_by_probs(THEME.exits)
      local skin = assert(GAME.EXITS[skin_name])
      Build.exit_pillar(S, z1, skin, sw_special)
    end
  end


  local function content_purpose(S)
    local sx, sy = S.sx, S.sy

    local z1 = S.floor_h or R.floor_h
    local z2 = S.ceil_h  or R.ceil_h

    local mx, my = S:mid_point()

    if R.purpose == "START" then
      content_start(S, mx, my, z1)

    elseif R.purpose == "EXIT" and OB_CONFIG.game == "quake" then
      local skin = { floor="SLIP2", wall="SLIPSIDE" }

      Build.quake_exit_pad(S, z1 + 16, skin, LEVEL.next_map)

    elseif R.purpose == "EXIT" or R.purpose == "SECRET_EXIT" then
      content_exit(S, mx, my, z1)

    elseif R.purpose == "KEY" then
      local LOCK = assert(R.purpose_lock)

      if rand.odds(15) and THEME.lowering_pedestal_skin then
        local z_top = math.max(z1+128, R.floor_max_h+64)
        if z_top > z2-32 then
           z_top = z2-32
        end

        Build.lowering_pedestal(S, z_top, THEME.lowering_pedestal_skin)

        Trans.entity(LOCK.item, mx, my, z_top)
      else
        if rand.odds(2) then
          -- bare item
          Trans.entity(LOCK.item, mx, my, z1)
        else
          content_big_item(LOCK.item, mx, my, z1)
        end
      end

    elseif R.purpose == "SWITCH" then
      local LOCK = assert(R.purpose_lock)
gui.debugf("SWITCH ITEM = %s\n", LOCK.switch)
      local INFO = assert(GAME.SWITCHES[LOCK.switch])
      Build.small_switch(S, dir_for_wotsit(S), z1, INFO.skin, LOCK.tag)

    else
      error("unknown purpose: " .. tostring(R.purpose))
    end
  end


  local function content_weapon(S)
    local sx, sy = S.sx, S.sy

    local z1 = S.floor_h or R.floor_h
    local z2 = S.ceil_h  or R.ceil_h

    local mx, my = S:mid_point()

    local weapon = assert(S.content_item)

    if R == LEVEL.start_room or R.hallway then
      -- bare item
      Trans.entity(weapon, mx, my, z1)

    elseif rand.odds(40) and THEME.lowering_pedestal_skin2 then
      local z_top = math.max(z1+80, R.floor_max_h+40)
      if z_top > z2-32 then
         z_top = z2-32
      end

      Build.lowering_pedestal(S, z_top, THEME.lowering_pedestal_skin2)

      Trans.entity(weapon, mx, my, z_top)
    else
      content_big_item(weapon, mx, my, z1)
    end

    gui.debugf("Placed weapon '%s' @ (%d,%d,%d)\n", weapon, mx, my, z1)
  end


  local function content_item(S)
    local item = assert(S.content_item)

    local mx, my = S:mid_point()
    local z1 = S.floor_h or R.floor_h

    if R == LEVEL.start_room or R.hallway then
      -- bare item
      Trans.entity(item, mx, my, z1)
    else
      content_big_item(item, mx, my, z1)
    end
  end


  local function content_teleporter(S)
    local C = R.teleport_conn
    assert(C)

    local skin1 = GAME.SKINS["Teleporter1"]
    assert(skin1)

    local skin0 = { wall = R.main_tex }
    local skin2 = {}

    if C.R1 == R then
      skin2. in_tag = C.tele_tag2
      skin2.out_tag = C.tele_tag1
    else
      skin2. in_tag = C.tele_tag1
      skin2.out_tag = C.tele_tag2
    end

    skin2. in_target = string.format("tele%d", skin2. in_tag)
    skin2.out_target = string.format("tele%d", skin2.out_tag)

    local mx, my = S:mid_point()
    local spot_dir = 10 - dir_for_wotsit(S)
    local z = S.floor_h or R.floor_h

    local T = Trans.spot_transform(mx, my, z, spot_dir)

    Fabricate_at(R, skin1, T, { skin0, skin1, skin2 })
  end


  local function do_wall(S, side, w_tex)
    local skin1 = GAME.SKINS["Wall_plain"]
    assert(skin1)

    local skin0 = { wall=w_tex }

    local deep = assert(skin1.deep)

    local T = Trans.edge_transform(S.x1, S.y1, S.x2, S.y2, S.floor_h,
                                   side, 0, 192, deep, 0)

    Fabricate_at(R, skin1, T, { skin0, skin1 })
  end


  local function do_liquid_fall(S, side, w_tex, z2)
    if z2 < S.floor_h + 160 then
      do_wall(S, side, w_tex)
      return
    end

    local skin1 = GAME.SKINS["Wall_liquid_fall"]
    assert(skin1)

    local skin0 = { wall=w_tex }

    local deep = assert(skin1.deep)

    local T = Trans.edge_transform(S.x1, S.y1, S.x2, S.y2, S.floor_h,
                                   side, 0, 192, deep, 0)

    if skin1.z_fit then
      T.fitted_z = z2 - S.floor_h
    end

    Fabricate_at(R, skin1, T, { skin0, skin1 })
  end


  local function do_cross(S, side, f_tex, w_tex)
    local skin1 = GAME.SKINS["Wall_cross"]
    assert(skin1)

    local skin0 = { wall=w_tex }

    local T = Trans.edge_transform(S.x1, S.y1, S.x2, S.y2, S.floor_h,
                                   side, 0, 192, skin1.deep, 0)

    Fabricate_at(R, skin1, T, { skin0, skin1 })
  end


  local function do_window(S, side, w_tex)
    local B = S.border[side]

    local fab_name = "Window_" .. B.win_kind

    if B.win_z2 then
      fab_name = fab_name .. "_tall"
    end

    local skin1 = GAME.SKINS[fab_name]
    assert(skin1)

    local o_tex = outer_tex(S, side, w_tex)
    local skin0 = { wall=w_tex, outer=o_tex or w_tex }

    assert(skin1.deep)
    assert(skin1.over)

    local T = Trans.edge_transform(S.x1, S.y1, S.x2, S.y2, B.win_z1,
                                   side, 0, 192, skin1.deep, skin1.over)

    if B.win_z2 then
      T.fitted_z = B.win_z2 - B.win_z1
    end

    Fabricate_at(R, skin1, T, { skin0, skin1 })
  end


  local function do_archway(S, side, f_tex, w_tex)
    local conn = S.border[side].conn

    local z = assert(conn and conn.conn_h)

    if conn.diff_h and conn.diff_h > 0 then
      z = z - conn.diff_h
    end

    local fab_name = "Arch_plain"
    if conn.diff_h then fab_name = "Arch_stair" end

    local skin1 = GAME.SKINS[fab_name]
    assert(skin1)

    local o_tex = outer_tex(S, side, w_tex)
    local skin2 = { wall=w_tex, floor=f_tex, outer=o_tex, track=THEME.track_mat }

    if skin2.wall == skin2.outer then
      skin2.track = skin2.wall
    end

    -- handling for extra-wide archways
    local S2 = S
    local seed_w = S.border[side].seed_w or 1

    if seed_w > 1 then
      if geom.is_horiz(side) then
        S2 = SEEDS[S.sx][S.sy + seed_w - 1]
      else
        S2 = SEEDS[S.sx + seed_w - 1][S.sy]
      end
    end

    local T = Trans.edge_transform(S.x1, S.y1, S2.x2, S2.y2, z,
                                   side, 0, seed_w * 192, skin1.deep, skin1.over)

    Fabricate_at(R, skin1, T, { skin1, skin2 })
  end


  function do_door(S, side, f_tex, w_tex)
    local z = assert(S.conn and S.conn.conn_h)

    -- FIXME: better logic for selecting doors
    local doors = THEME.doors
    if not doors then
      error("Game is missing doors table")
    end

    local door_name = rand.key_by_probs(doors)
    local skin = assert(GAME.DOORS[door_name])

    local o_tex = outer_tex(S, side, w_tex)
    local skin2 = { inner=w_tex, outer=o_tex }

    assert(skin.track)
    assert(skin.step_w)

    Build.door(S, side, z, skin, skin2, 0)
  end


  function do_locked_door(S, side, f_tex, w_tex)
    local z = assert(S.conn and S.conn.conn_h)

    local LOCK = assert(S.border[side].lock)
    local skin = assert(GAME.DOORS[LOCK.switch or LOCK.item])

--if not skin.track then gui.printf("%s", table.tostr(skin,1)); end
    assert(skin.track)

    local o_tex = outer_tex(S, side, w_tex)
    local skin2 = { inner=w_tex, outer=o_tex }

    local reversed = (S == S.conn.S2)

    Build.door(S, side, z, skin, skin2, LOCK.tag, reversed)
  end


  local function do_secret_door(S, side, f_tex, w_tex)
    local conn = S.border[side].conn

    local z = assert(conn and conn.conn_h)

    local fab_name = "Door_secret"
    local skin1 = GAME.SKINS[fab_name]
    assert(skin1)

    local o_tex = outer_tex(S, side, w_tex)
    local skin2 = { wall=w_tex, floor=f_tex, outer=o_tex }

    local T = Trans.edge_transform(S.x1, S.y1, S.x2, S.y2, z,
                                   side, 0, 192, skin1.deep, skin1.over)

    Fabricate_at(R, skin1, T, { skin1, skin2 })
  end


  function do_lowering_bars(S, side, f_tex, w_tex)
    local z = assert(S.conn and S.conn.conn_h)

    local LOCK = assert(S.border[side].lock)
    local skin = assert(GAME.DOORS[LOCK.switch or LOCK.item])

    local N = S:neighbor(side)
    assert(N and N.room)

    -- determine how much higher to make bars, based on nearby high
    -- floors which the player could jump over them from.

    local extra_z = math.max(S.room.floor_max_h, N.room.floor_max_h) - z
    if extra_z < 0 then extra_z = 0 end

    local z_max = math.min(S.room.ceil_h, N.room.ceil_h) - 96

    if extra_z > z_max - z then
       extra_z = z_max - z
    end

    if extra_z < 0 then extra_z = 0 end

    local fab_name = "Bars_shiny"

    local skin1 = GAME.SKINS[fab_name]
    assert(skin1)

    local o_tex = outer_tex(S, side, w_tex)
    local skin2 = { wall=w_tex, floor=f_tex, outer=o_tex }

    skin2.tag_1 = LOCK.tag

    local T = Trans.edge_transform(S.x1, S.y1, S.x2, S.y2, z,
                                   side, 0, 192, skin1.deep, skin1.over)

    T.fitted_z = skin1.bound_z2 + extra_z

    Fabricate_at(R, skin1, T, { skin1, skin2 })
  end


  local function do_secret_floor(S, z, indents, w_tex, f_tex)
    -- FIXME: this is game specific!!

    local kind, w_face, t_face = Mat_normal(S.l_tex or w_tex, f_tex)

    t_face.special = 9

    local fx1 = S.x1 + (indents[4] or 0)
    local fy1 = S.y1 + (indents[2] or 0)
    local fx2 = S.x2 - (indents[6] or 0)
    local fy2 = S.y2 - (indents[8] or 0)

    Trans.quad(fx1,fy1, fx2,fy2, nil,z, kind, w_face, t_face)
  end


  local function do_floor(S, z, indents, w_tex, f_tex, liq_info)
    local kind, w_face, t_face = Mat_normal(S.l_tex or w_tex, f_tex)

    if liq_info then
      w_face = liq_info.w_face
      t_face = liq_info.t_face
    end

    for bx = 0, 2 do
    for by = 0, 2 do
      local x1 = S.x1 + int((S.x2 - S.x1) * bx / 3)
      local y1 = S.y1 + int((S.y2 - S.y1) * by / 3)
      local x2 = S.x1 + int((S.x2 - S.x1) * (bx + 1) / 3)
      local y2 = S.y1 + int((S.y2 - S.y1) * (by + 1) / 3)

      if bx == 0 then x1 = x1 + (indents[4] or 0) end
      if bx == 2 then x2 = x2 - (indents[6] or 0) end
      if by == 0 then y1 = y1 + (indents[2] or 0) end
      if by == 2 then y2 = y2 - (indents[8] or 0) end

      Trans.quad(x1,y1, x2,y2, nil,z, kind, w_face, t_face)
    end
    end
  end


  local function vis_mark_wall(S, side)
    gui.debugf("VIS %d %d %s\n", S.sx, S.sy, side)
  end

  local function vis_seed(S)
    if S.kind == "void" then
      -- vis_mark_solid(S)
      return
    end

    for side = 2,8,2 do
      local N = S:neighbor(side)
      local B_kind = S.border[side].kind

      if not N or N.free or N.kind == "void" or
         B_kind == "wall" or B_kind == "facade" or
         B_kind == "picture"
      then
        vis_mark_wall(S, side)
      end
    end
  end

  local function Split_quad(S, info, x1,y1, x2,y2, z1,z2)
    local prec = GAME.lighting_precision or "medium"

    if OB_CONFIG.game == "quake" then prec = "low" end
    if R.is_outdoor then prec = "low" end
    if S.content == "wotsit" then prec = "low" end

    if prec == "high" then
      for i = 0,5 do for k = 0,5 do
        local ax = int((x1*i+x2*(6-i)) / 6)
        local ay = int((y1*k+y2*(6-k)) / 6)
        local bx = int((x1*(i+1)+x2*(5-i)) / 6)
        local by = int((y1*(k+1)+y2*(5-k)) / 6)
        
        Trans.old_quad(info, ax,ay, bx,by, z1,z2)
      end end

    elseif prec == "medium" then
      local ax = int((x1*2+x2) / 3)
      local ay = int((y1*2+y2) / 3)
      local bx = int((x1+x2*2) / 3)
      local by = int((y1+y2*2) / 3)

      Trans.old_quad(info, x1,y1, ax,ay, z1,z2)
      Trans.old_quad(info, ax,y1, bx,ay, z1,z2)
      Trans.old_quad(info, bx,y1, x2,ay, z1,z2)

      Trans.old_quad(info, x1,ay, ax,by, z1,z2)
      Trans.old_quad(info, ax,ay, bx,by, z1,z2)
      Trans.old_quad(info, bx,ay, x2,by, z1,z2)

      Trans.old_quad(info, x1,by, ax,y2, z1,z2)
      Trans.old_quad(info, ax,by, bx,y2, z1,z2)
      Trans.old_quad(info, bx,by, x2,y2, z1,z2)

    else
      Trans.old_quad(info, x1,y1, x2,y2, z1,z2)
    end
  end


  local function build_seed(S)
    if S.already_built then
      return
    end

    vis_seed(S)

    local z1 = S.floor_h or R.floor_h or (S.conn and S.conn.conn_h) or 0
    local z2 = S.ceil_h  or R.ceil_h  or (z1 + 256)

    assert(z1 and z2)


    local w_tex = S.w_tex or R.main_tex
    local f_tex = S.f_tex or R.main_tex
    local c_tex = S.c_tex or sel(R.is_outdoor, "_SKY", R.ceil_tex)

if R.kind == "cave" then f_tex = "RROCK04" end --!!!!! TEMP
if R.quest and R.quest.kind == "secret" then f_tex = "FLAT1_3" end


    if R.kind == "hallway" then
      w_tex = assert(LEVEL.hall_tex)
    elseif R.kind == "stairwell" then
      w_tex = assert(LEVEL.well_tex)
    end


    local sec_kind


    -- coords for solid block floor and ceiling
    local f_indents = {}
    local c_indents = {}

    local function shrink_floor(side, len)
      assert(len <= 40)
      f_indents[side] = len
    end

    local function shrink_ceiling(side, len)
      assert(len <= 40)
      c_indents[side] = len
    end

    local function shrink_both(side, len)
      shrink_floor  (side, len)
      shrink_ceiling(side, len)
    end


    -- SIDES

    for side = 2,8,2 do
      local N = S:neighbor(side)

      local border = S.border[side]
      local B_kind = S.border[side].kind

      -- hallway hack
      if R.hallway and not (S.kind == "void") and
         ( (B_kind == "wall")
          or
           (S:neighbor(side) and S:neighbor(side).room == R and
            S:neighbor(side).kind == "void")
         )
         and R.kind != "stairwell"
      then
        local skin = { wall=LEVEL.hall_tex, trim1=THEME.hall_trim1, trim2=THEME.hall_trim2 }
        Build.detailed_hall(S, side, z1, z2, skin)

        S.border[side].kind = nil
        B_kind = nil
      end

      if B_kind == "wall" or B_kind == "facade" then
        do_wall(S, side, border.w_tex or w_tex)
        shrink_both(side, 16)
      end

      if B_kind == "window" then
        do_window(S, side, w_tex)
        shrink_both(side, 16)
      end

      if B_kind == "picture" then
        local B = S.border[side]
        B.pic_skin.wall = w_tex

        Build.picture(S, side, B.pic_z1, B.pic_z2, B.pic_skin)
        shrink_both(side, 16)
      end

      if B_kind == "cross" then  -- TEMPORARY !!
        do_cross(S, side, f_tex, w_tex)
        shrink_both(side, 16)
      end

      if B_kind == "fence"  then
        local skin = { h=30, wall=w_tex, floor=f_tex }
        local fence_h = R.fence_h or ((R.floor_h or z1) + skin.h)
        if S.content == "wotsit" then
          fence_h = fence_h + 24
        end
        Build.fence(S, side, fence_h, skin)
        shrink_floor(side, 16)
      end

      if B_kind == "straddle" then
        -- TODO: ideally do both, cannot now due to lowering_bars
        shrink_floor(side, 16)
      end

      if B_kind == "arch" then
        do_archway(S, side, f_tex, w_tex)
        shrink_both(side, 16)
      end

      if B_kind == "liquid_arch" then
        local o_tex = outer_tex(S, side, w_tex)
        local skin = { wall=w_tex, floor=f_tex, outer=o_tex, break_t=THEME.track_mat }
        local z_top = math.max(R.liquid_h + 80, N.room.liquid_h + 48)

        Build.archway(S, side, z1, z_top, skin)
        shrink_ceiling(side, 16)  -- Note: cannot shrink floor (atm)
      end

      if B_kind == "liquid_fall" then
        do_liquid_fall(S, side, w_tex, z2)
        shrink_both(side, 16)
      end

      if B_kind == "door" then
        do_door(S, side, f_tex, w_tex)
        shrink_both(side, 16)
      end

      if B_kind == "secret_door" then
        do_secret_door(S, side, f_tex, w_tex)
        shrink_both(side, 16)
      end

      if B_kind == "lock_door" then
        do_locked_door(S, side, f_tex, w_tex)
        shrink_both(side, 16)

        assert(not S.conn.already_made_lock)
        S.conn.already_made_lock = true
      end

      if B_kind == "bars" then
        do_lowering_bars(S, side, f_tex, w_tex)
        shrink_floor(side, 16)

        assert(not S.conn.already_made_lock)
        S.conn.already_made_lock = true
      end
    end -- for side


    if R.sides_only then return end


    -- DIAGONALS

    if S.kind == "diagonal" then

      local diag_info = get_mat(w_tex, S.stuckie_ftex) ---### , c_tex)

      Build.diagonal(S, S.stuckie_side, diag_info, S.stuckie_z)

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

    local cx1 = S.x1 + (c_indents[4] or 0)
    local cy1 = S.y1 + (c_indents[2] or 0)
    local cx2 = S.x2 - (c_indents[6] or 0)
    local cy2 = S.y2 - (c_indents[8] or 0)

    if S.kind != "void" and not S.no_ceil and 
       (S.is_sky or c_tex == "_SKY")
    then
      local info = sel(R.is_outdoor, get_sky(), get_fake_sky())

      Trans.old_quad(info, cx1,cy1, cx2,cy2, z2, EXTREME_H)

    elseif S.kind != "void" and not S.no_ceil then
      ---## local info = get_mat(S.u_tex or c_tex or w_tex, c_tex)
      ---## info.b_face.light = S.c_light
      ---## Trans.old_quad(info, cx1,cy1, cx2,cy2, z2, EXTREME_H)

      local kind, w_face, p_face = Mat_normal(S.u_tex or c_tex or w_tex, c_tex)
---##      p_face.light = S.c_light

      Trans.quad(cx1,cy1, cx2,cy2, z2,nil, kind, w_face, p_face)

      -- FIXME: this does not belong here
      if R.hallway and LEVEL.hall_lights then
        local x_num, y_num = 0,0

        for side = 2,8,2 do
          local N = S:neighbor(side)
          if N and N.room == R and N.kind != "void" then
            if side == 2 or side == 8 then
              y_num = y_num + 1
            else
              x_num = x_num + 1
            end
          end
        end

        if x_num == 1 and y_num == 1 and LEVEL.hall_lite_ftex then
          Build.ceil_light(S, z2, { lite_f=LEVEL.hall_lite_ftex, trim=THEME.light_trim }, 168)
        end
      end
    end


    -- FLOOR

    local fx1 = S.x1 + (f_indents[4] or 0)
    local fy1 = S.y1 + (f_indents[2] or 0)
    local fx2 = S.x2 - (f_indents[6] or 0)
    local fy2 = S.y2 - (f_indents[8] or 0)

    if S.kind == "void" then

      if S.solid_feature and THEME.building_corners then
        if not R.corner_tex then
          R.corner_tex = rand.key_by_probs(THEME.building_corners)
        end
        w_tex = R.corner_tex
      end

      Trans.old_quad(get_mat(w_tex), fx1,fy1, fx2,fy2, -EXTREME_H, EXTREME_H);

    elseif S.kind == "stair" then
      local skin2 = { wall=S.room.main_tex, floor=S.f_tex or S.room.main_tex }

      Build.niche_stair(S, LEVEL.step_skin, skin2)

    elseif S.kind == "curve_stair" then
      Build.low_curved_stair(S, LEVEL.step_skin, S.x_side, S.y_side, S.x_height, S.y_height)

    elseif S.kind == "tall_stair" then
      Build.tall_curved_stair(S, LEVEL.step_skin, S.x_side, S.y_side, S.x_height, S.y_height)

    elseif S.kind == "lift" then
      local skin2 = { wall=S.room.main_tex, floor=S.f_tex or S.room.main_tex }
      local tag = Plan_alloc_id("tag")

      Build.lift(S, LEVEL.lift_skin, skin2, tag)

    elseif S.kind == "popup" then
      -- FIXME: monster!!
      local skin = { wall=w_tex, floor=f_tex }
      Build.popup_trap(S, z1, skin, "revenant")

    elseif S.kind == "liquid" then
      assert(LEVEL.liquid)
      do_floor(S, z1, f_indents, w_tex, f_tex, get_liquid(R.is_outdoor))

    elseif not S.no_floor then
      if S.mark_secret then
        do_secret_floor(S, z1, f_indents, w_tex, f_tex)
      else
        do_floor(S, z1, f_indents, w_tex, f_tex)
      end
    end


    -- PREFABS

    if S.content == "pillar" then
      Build.pillar(S, z1, z2, assert(S.pillar_skin), S.is_big_pillar)
    end

    if S.content == "wotsit" then
      if S.content_kind == "WEAPON" then
        content_weapon(S)
      elseif S.content_kind == "ITEM" then
        content_item(S)
      elseif S.content_kind == "TELEPORTER" then
        content_teleporter(S)
      else
        content_purpose(S)
      end
    end


    -- restore diagonal kind for monster/item code
    if S.diag_new_kind then
      S.kind = "diagonal"
    end

  end -- build_seed()


  ---==| Room_build_seeds |==---

  if R.cave then
    Room_build_cave(R)
  end

  if R.kind == "smallexit" then
    Room_do_small_exit(R)
    return
  end

  if R.kind == "stairwell" then
    Room_do_stairwell(R)
    R.sides_only = true
  end

  for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
    local S = SEEDS[x][y]
    if S.room == R then
      build_seed(S)
    end
  end end -- for x, y
end


function Room_distribute_spots(R, list)
  local seen = {}

  each spot in list do
    seen[spot.kind] = 1

    if spot.kind == "cage" or spot.kind == "trap" then
      table.insert(R.cage_spots, spot)
    elseif spot.kind == "pickup" or spot.kind == "big_item" then
      table.insert(R.item_spots, spot)
    elseif spot.kind == "goal" then
      if R.kind == "hallway" then
        error("Goal spot used in hallway prefab")
      end
      table.insert(R.goal_spots, spot)
    else
      table.insert(R.mon_spots, spot)
    end
  end

  -- 1. when no big item spots, convert goal spots
  -- 2. when no small item spots, convert monster spots

  each spot in list do

    if not seen["big_item"] and spot.kind == "goal" then
      local new_spot = table.copy(spot)
      new_spot.kind = "big_item"
      table.insert(R.item_spots, new_spot)
    end

    if not seen["pickup"] and spot.kind == "monster" then
      local new_spot = table.copy(spot)
      new_spot.kind = "pickup"
      table.insert(R.item_spots, new_spot)
    end

  end
end


function Room_find_pickup_spots(R)
  --
  -- Creates a map over the room where we can place pickup items.
  -- We distinguish two types:
  --
  -- 1. 'big items' prefer to have a seed for itself, and
  --    somewhere near to the centre of the room.
  --
  -- 2. 'small items' prefer to sit next to walls (or ledges)
  --    and be grouped in clusters.
  --

  local function add_big_spot(R, S, score)
    local mx, my = S:mid_point()
    table.insert(R.big_spots,
    {
      S = S
      score = score

      x1 = mx - 24, y1 = my - 24, z1 = (S.floor_h or 0)
      x2 = mx + 24, y2 = my + 24, z2 = (S.floor_h or 0) + 64

      -- FIXME: REMOVE
      x=mx, y=my
    })
  end

  local function add_small_spots(R, S, side, count, score)
    local dist = 38

    for i = 1,count do  -- out from wall
    for k = 1,5     do  -- along wall
      local mx, my = S:mid_point()

      local dx, dy = geom.delta(geom.RIGHT[side])

      mx = mx + (k - 3) * 28 * dx
      my = my + (k - 3) * 28 * dy

      if side == 4 then mx = S.x1 + S.thick[4] + i*dist end
      if side == 6 then mx = S.x2 - S.thick[6] - i*dist end
      if side == 2 then my = S.y1 + S.thick[2] + i*dist end
      if side == 8 then my = S.y2 - S.thick[8] - i*dist end

      if side == 1 then mx, my = mx + i*dist, my + i*dist end
      if side == 3 then mx, my = mx - i*dist, my + i*dist end
      if side == 7 then mx, my = mx + i*dist, my - i*dist end
      if side == 9 then mx, my = mx - i*dist, my - i*dist end

      local dir = geom.RIGHT[side]  -- FIXME: NOT NEEDED, REMOVE

      table.insert(R.item_spots,
      {
        S = S
        dir = dir
        wall_dist = (i - 1)

        x1 = mx - 12, y1 = my - 12, z1 = (S.floor_h or 0)
        x2 = mx + 12, y2 = my + 12, z2 = (S.floor_h or 0) + 64

        -- FIXME: REMOVE
        x=mx, y=my
      })
    end
    end
  end

  local function try_add_big_spot(R, S)
    local score = gui.random()

    if S.div_lev and S.div_lev >= 2 then score = score + 10 end

    if S.sx > (R.tx1 or R.sx1) and S.sx < (R.tx2 or R.sx2) then score = score + 2.4 end
    if S.sy > (R.ty1 or R.sy1) and S.sy < (R.ty2 or R.sy2) then score = score + 2.4 end

    if not S.content then score = score + 1 end

    add_big_spot(R, S, score)
  end

  local function try_add_small_spot(R, S)
    local score = gui.random()

    if R.entry_conn and R.entry_conn.kind != "teleporter" then
      local e_dist
      if geom.is_vert(R.entry_conn.dir) then
        e_dist = math.abs(R.entry_conn.S2.sy - S.sy)
      else
        e_dist = math.abs(R.entry_conn.S2.sx - S.sx)
      end

      score = score + e_dist / 2.5
    end

    local walls = {}

    for side = 2,8,2 do
      local N = S:neighbor(side)
      if not N then
        walls[side] = 1
      elseif N.room != S.room then
        if not S.conn then walls[side] = 2 end
      elseif N.kind == "void" then
        walls[side] = 3
      elseif N.kind == "walk" and N.floor_h > S.floor_h then
        walls[side] = 4
      end
    end -- for side

    if table.empty(walls) then return end

    if walls[4] and walls[6] then
      add_small_spots(R, S, 4, 2, score)
      add_small_spots(R, S, 6, 2, score - 0.3)

    elseif walls[2] and walls[8] then
      add_small_spots(R, S, 2, 2, score)
      add_small_spots(R, S, 8, 2, score - 0.3)

    else
      for loop = 1,100 do
        local side = rand.irange(1,4) * 2
        if walls[side] then
          add_small_spots(R, S, side, 4, score)
          break;
        end
      end
    end
  end

  local function try_add_diagonal_spot(R, S)
    if S.diag_new_kind != "walk" then return end

    local score = 80 + gui.random()

    add_small_spots(R, S, S.stuckie_side, 2, score)
  end


  ---| Room_find_pickup_spots |---

  if R.kind == "cave" then return end

  if R.kind == "stairwell" then return end
  if R.kind == "smallexit" then return end

  gui.debugf("find_pickup_spots @ %s\n", R:tostr())


  local emerg_big
  local emerg_small

  for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
    local S = SEEDS[x][y]
    local score

    if S.room == R and S.kind == "walk" and
       (not S.content or S.content == "monster")
    then
      try_add_big_spot(R, S)
      try_add_small_spot(R, S)

      if not emerg_big then emerg_big = S end
      emerg_small = S
    end

    if S.room == R and S.kind == "diagonal" then
      try_add_diagonal_spot(R, S)
    end
  end end -- for x, y

  -- luckily this is very rare
  if not emerg_small then
    gui.printf("No spots for pickups in %s\n", R:tostr())
    R.no_pickup_spots = true
    return
  end

  assert(emerg_big)

  if #R.big_spots == 0 then
    gui.debugf("No big spots found : using emergency\n")
    add_big_spot(R, emerg_big, 0)
  end

  if #R.item_spots == 0 then
    gui.debugf("No small spots found : using emergency\n")
    add_small_spots(R, emerg_small, 2, 4, 0)
  end
end



function Room_find_monster_spots(R)

  local function add_small_mon_spot(S, h_diff)
    -- FIXME: take walls (etc) into consideration

    local mx, my = S:mid_point()

    table.insert(R.mon_spots,
    {
      S=S, score=gui.random(),  -- FIXME score

      x1=mx-64, y1=my-64, z1=(S.floor_h or 0),
      x2=mx+64, y2=my+64, z2=(S.floor_h or 0) + h_diff,
    })

    SEEDS[S.sx][S.sy].no_monster = true
  end


  local function add_large_mon_spot(S, h_diff)
    -- FIXME: take walls (etc) into consideration

    local mx, my = S.x2, S.y2

    table.insert(R.mon_spots,
    {
      S=S, score=gui.random(),  -- FIXME score

      x1=mx-128, y1=my-128, z1=(S.floor_h or 0),
      x2=mx+128, y2=my+128, z2=(S.floor_h or 0) + h_diff,
    })

    -- prevent other seeds in 2x2 group from being used
    SEEDS[S.sx  ][S.sy  ].no_monster = true
    SEEDS[S.sx+1][S.sy  ].no_monster = true
    SEEDS[S.sx  ][S.sy+1].no_monster = true
    SEEDS[S.sx+1][S.sy+1].no_monster = true
  end


  local function can_accommodate_small(S)
    if S.content or S.no_monster or not S.floor_h then
      return false
    end

    -- keep entryway clear
    if R.entry_conn and S.conn == R.entry_conn then
      return false
    end

    -- check seed kind
    if S.kind != "walk" then
      return false
    end

    local h_diff = (S.ceil_h or R.ceil_h) - (S.floor_h or 0)

    return true, h_diff
  end


  local function can_accommodate_large(S, sx, sy)
    if (sx+1 > R.sx2) or (sy+1 > R.sy2) then
      return false
    end

    local low_ceil = S.ceil_h or R.ceil_h
    local hi_floor = S.floor_h or 0

    for dx = 0,1 do
    for dy = 0,1 do
        local S2 = SEEDS[sx+dx][sy+dy]

        if S2.room != S.room then return false end

        if not can_accommodate_small(S2) then return false end

        if S2.solid_corner then return false end

        if S2.ceil_h then
          low_ceil = math.min(low_ceil, S2.ceil_h)
        end

        -- ensure no floor difference for huge monsters
        local diff = math.abs((S.floor_h or 0) - (S2.floor_h or 0))

        if diff > 1 then return false end

    end -- dx, dy
    end

    local h_diff = (low_ceil - hi_floor)

    return true, h_diff
  end


  ---| Room_find_monster_spots |---

  if R.kind == "cave" then return end

  if R.kind == "stairwell" then return end
  if R.kind == "smallexit" then return end

  -- find large 2x2 spots in first pass, small 1x1 spots in second

  for pass = 1,2 do
    for x = R.sx1, R.sx2 do
    for y = R.sy1, R.sy2 do
      local S = SEEDS[x][y]
    
      if S.room != R then continue end

      if pass == 1 then
        local large_ok, large_diff = can_accommodate_large(S, x, y)

        if large_ok then
          add_large_mon_spot(S, large_diff)
        end

      else
        local small_ok, small_diff = can_accommodate_small(S)

        if small_ok then
          add_small_mon_spot(S, small_diff)
        end
      end
    end
  end end
end


function Room_find_ambush_focus(R)
  -- Note: computes 'entry_coord' too

  -- FIXME: handle teleporter entry

  if R.kind == "stairwell" then return end

  local C = R.entry_conn

  if not C then return end
  if C.kind == "teleporter" then return end

  local S, side
  if C.R1 == R then
    S = C.S1
    side = C.dir
  else
    S = C.S2
    side = 10 - C.dir
  end

  assert(S)
  assert(S.floor_h)


  local mx, my = S:mid_point()

  local dx, dy = geom.delta(side)
  local angle  = geom.ANGLES[10 - side]

  mx = mx + dx * 48
  my = my + dy * 48

  R.entry_coord = { x=mx, y=my, z=S.floor_h + 40, angle=angle }

  R.ambush_focus = R.entry_coord
end



function Room_run_builders()
  each R in LEVEL.scenic_rooms do
    Room_build_seeds(R)
  end

  each R in LEVEL.rooms do
    Room_build_seeds(R)

    Room_find_monster_spots(R)
    Room_find_pickup_spots(R)
    Room_find_ambush_focus(R)

    if R.kind != "cave" then
      R:exclude_monsters()
    end
  end
end



function Room_build_all()

  gui.printf("\n--==| Build Rooms |==--\n\n")

  gui.prog_step("Rooms")

  Levels_invoke_hook("build_rooms", LEVEL.seed)

  Room_choose_themes()
  Room_decide_hallways()

  Room_setup_symmetry()
  Room_reckon_doors()
  Room_create_sky_groups()

  Room_layout_all()

  Room_plaster_ceilings()
  Room_tizzy_up()
  Room_border_up()

  Layout_edge_of_map()

  Room_run_builders()
end

