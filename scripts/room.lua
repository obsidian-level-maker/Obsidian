------------------------------------------------------------------------
--  Room Management
------------------------------------------------------------------------
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
------------------------------------------------------------------------

--[[ *** CLASS INFORMATION ***

class ROOM
{
  kind : keyword  -- "building" (layout-able room)
                  -- "outdoor", "cave"
                  -- "hallway", "stairwell"
                  -- "scenic" (unvisitable room)

  is_outdoor : bool  -- true for outdoor rooms / caves

  conns : list(CONN)  -- connections with neighbor rooms
  entry_conn : CONN

  branch_kind : keyword

  hallway : HALLWAY_INFO   -- for hallways and stairwells

  symmetry : keyword   -- symmetry of room, or NIL
                       -- keywords are "x", "y", "xy"

  sx1, sy1, sx2, sy2  -- \ Seed range
  sw, sh, svolume     -- /

  zone  : ZONE
  quest : QUEST

  tx1, ty1, tx2, ty2  -- \ non-junk seed range
  tw, th              -- /

  purpose : keyword   -- usually NIL, can be "EXIT" etc... (FIXME)
  purpose_lock : LOCK

  teleport_conn : CONN  -- if exists, the teleporter connection to/from this room

  floor_h, ceil_h : number

  c_group : number    -- connection group (used for Connect logic)

  sky_group : number  -- outdoor rooms which directly touch will belong
                      -- to the same sky_group (unless a solid wall is
                      -- enforced, e.g. between zones).
}


class FLOOR
{
  vhr : number  -- virtual height (1..9)

  floor_h
  floor_tex

  conns : list(CONN)   -- all the connections which join this floor
}


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
    chunks  = {}
    floors  = {}
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


function ROOM_CLASS.str_prefix(R)
  if R.kind == "hallway" then return "HALLWAY_" end
  if R.kind == "scenic" then return "SCENIC_" end
  if R.parent then return "SUB_" end
  return ""
end


function ROOM_CLASS.tostr(R)
  return string.format("%sROOM_%d", R:str_prefix(), R.id)
end


function ROOM_CLASS.contains_seed(R, x, y)
  if x < R.sx1 or x > R.sx2 then return false end
  if y < R.sy1 or y > R.sy2 then return false end
  return true
end


function ROOM_CLASS.get_bbox(R)
  local S1 = SEEDS[R.sx1][R.sy1]
  local S2 = SEEDS[R.sx2][R.sy2]

  return S1.x1, S1.y1, S2.x2, S2.y2
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
    local S = C:get_seed(R)
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


function ROOM_CLASS.spots_do_edges(R)
  for side = 2,8,2 do
    local x1, y1, x2, y2 = R:get_bbox()

    if geom.is_vert(side) then
      x1 = x1 - 200 ; x2 = x2 + 200
    else
      y1 = y1 - 200 ; y2 = y2 + 200
    end

    if side == 2 then y2 = y1 ; y1 = y1 - 200 end
    if side == 8 then y1 = y2 ; y2 = y2 + 200 end
    if side == 4 then x2 = x1 ; x1 = x1 - 200 end
    if side == 6 then x1 = x2 ; x2 = x2 + 200 end

    gui.spots_fill_box(x1, y1, x2, y2, SPOT_LEDGE)
  end
end


function ROOM_CLASS.add_decor(R, name, x, y, z)
  local info = GAME.ENTITIES[name]

  if not info then
    warning("Unknown decor entity: %s\n", tostring(name))

    info = { r=32, h=96 }
  end

  local DECOR =
  {
    name = name
    x = x
    y = y
    z = z

    r = info.r
    h = info.h
    pass = info.pass
  }

  table.insert(R.decor, DECOR)
end


function ROOM_CLASS.spots_do_decor(R, floor_h)
  local low_h  = PARAM.spot_low_h
  local high_h = PARAM.spot_high_h

  each D in R.decor do
    -- not solid?
    if D.pass then continue end

    local z1 = D.z
    local z2 = D.z + D.h

    if z1 >= floor_h + high_h then continue end
    if z2 <= floor_h then continue end

    local content = SPOT_LEDGE
    if z1 >= floor_h + low_h then content = SPOT_LOW_CEIL end

    local x1, y1 = D.x - D.r, D.y - D.r
    local x2, y2 = D.x + D.r, D.y + D.r

    gui.spots_fill_box(x1, y1, x2, y2, content)
  end
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

---??  R.item_spots = R:clip_spot_list(R.item_spots, x1, y1, x2, y2)
---??  R.big_spots  = R:clip_spot_list(R.big_spots,  x1, y1, x2, y2, "strict")
end


function ROOM_CLASS.exclude_monsters(R)
  each box in R.exclusions do
    if box.kind == "empty" then
      R:clip_spots(box.x1, box.y1, box.x2, box.y2)
    end
  end
end


------------------------------------------------------------------------


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
    if R.is_outdoor or (R.kind == "cave") or R.children then
      return false
    end

    if R.purpose or R.final_battle then return false end

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
      local S = C:get_seed(R)

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
    local theme = R.zone.stairwell_theme or LEVEL.stairwell_theme

    if theme and
       R.hallway and
       #R.conns == 2 and
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
      R.theme = theme
    end
  end


  ---| Room_decide_hallways |---

  if not LEVEL.hallway_theme then
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

      R.theme = R.zone.hallway_theme or LEVEL.hallway_theme
      assert(R.theme)

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

  local function calc_branch_factor(old_sym, new_sym)
    if old_sym == new_sym then
      return sel(old_sym == "xy", 100, 6)

    elseif new_sym == "xy" then
      -- rarely upgrade from NONE --> XY
      return sel(old_sym, 1, 0.1)

    elseif old_sym == "xy" then
      -- rarely downgrade from XY --> NONE
      return sel(new_sym, 1, 0.1)

    elseif old_sym and new_sym then
      -- rarely change from X --> Y or vice versa
      return 0.1

    else
      return 1
    end
  end


  local function calc_size_factor(R, new_sym)
    -- never in tiny rooms
    if R.sw <= 2 then return 0 end
    if R.sh <= 2 then return 0 end

    -- never in very narrow / tall rooms
    if R.sw > R.sh * 2.4 then return 0 end
    if R.sh > R.sw * 2.4 then return 0 end

    -- we need to use symmetry sparingly in small rooms, since it
    -- greatly limits which room patterns can be used in the room.
    local factor = 1

    if R.svolume <= 20 then factor = factor / 2 end
    if R.svolume <= 10 then factor = factor / 2 end

    -- symmetry works best indoors
    if R.is_outdoor then factor = factor / 1.5 end

    return factor
  end


  local function decide_layout_symmetry(R)
    R.branch_symmetry = R.symmetry

    -- discard 'R' rotate and 'T' transpose symmetry
    if not (R.symmetry == "x" or R.symmetry == "y" or R.symmetry == "xy") then
      R.symmetry = nil
      return
    end

    if STYLE.symmetry == "none" or
       R.kind == "cave" or R.kind == "hallway"
    then
      R.symmetry = nil
      return
    end


    -- build the probability table....

    local tab =
    {
      none = 100
    }

    local SYM_LIST = { "x", "y", "xy" }

    each sym in SYM_LIST do
      local p = style_sel("symmetry", 0, 10, 50, 200)

      p = p * calc_branch_factor(R.symmetry, sym)
      p = p * calc_size_factor(R, sym)

      if p > 0 then
        tab[sym] = p
      end
    end


    local result = rand.key_by_probs(tab)

    if result == "none" then
      R.symmetry = nil
    else
      R.symmetry = result
    end
  end


  local function mirror_horizontally(R)
    if R.sw < 2 then return end

    local half_W = int(R.sw / 2)

    for y = R.sy1, R.sy2 do
      for dx = 0, half_W - 1 do
        local S1 = SEEDS[R.sx1 + dx][y]
        local S2 = SEEDS[R.sx2 - dx][y]

        if S1.room == R and S2.room == R then
          S1.x_peer = S2
          S2.x_peer = S1
        end
      end
    end
  end


  local function mirror_vertically(R)
    if R.sh < 2 then return end

    local half_H = int(R.sh / 2)

    for x = R.sx1, R.sx2 do
      for dy = 0, half_H - 1 do
        local S1 = SEEDS[x][R.sy1 + dy]
        local S2 = SEEDS[x][R.sy2 - dy]

        if S1.room == R and S2.room == R then
          S1.y_peer = S2
          S2.y_peer = S1
        end
      end
    end
  end


  --| Room_setup_symmetry |--

  each R in LEVEL.rooms do
    decide_layout_symmetry(R)

    gui.debugf("Symmetry in %s --> %s (was: %s)\n", R:tostr(),
               R.symmetry or "none",
               R.branch_symmetry or "none")

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

  local woody = rand.odds(25)


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

    S.thick[S.conn_dir] = 40
    N.thick[N.conn_dir] = 40

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
    -- [ the style check prevents silly "free standing" arches ]
    if (S.room.is_outdoor and N.room.is_outdoor) and
       (rand.odds(90) or STYLE.fences == "none")
    then
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
    if (S.room.is_outdoor and N.room.kind != "cave") or
       (N.room.is_outdoor and S.room.kind != "cave")
    then
      prob = outdoor_prob
    end

    if rand.odds(prob) then
      B.kind = "door"

      if rand.odds(30) then
        C.fresh_floor = true
      end

      return
    end

    -- special archways for caves
    local R1 = S.room
    local R2 = N.room

    if R2.kind == "cave" and not R2.is_outdoor then
      R1, R2 = R2, R1
    end

    if R1.kind == "cave" and not R1.is_outdoor then
      if R2.kind != "building" then
        B.fab_name = sel(woody, "Arch_woody", "Arch_viney")
        return
      end
    end

    -- support arches which have a step in them
    if (S.room.is_outdoor != N.room.is_outdoor) or rand.odds(50) then
      if THEME.archy_arches then return end
      if STYLE.steepness == "none" then return end

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

  local function try_make_liquid_arch(S, R1, N, R2, side)
    -- liquid arches are a kind of window

    if not (R1.kind == "building" or R2.kind == "building") then
      return
    end

    if R1.kind != "building" then
      S,  N  = N,  S
      R1, R2 = R2, R1
      side = 10 - side
    end

    if R2.kind == "cave" then return end

    if S.kind != "liquid" then return end
    if N.kind != "liquid" then return end

    -- floor height check
    if math.abs(S.floor_h - N.floor_h) > 24 then return end

    -- player can travel between rooms, so limit their scope
    if R1.zone != R2.zone then return end

    local SB = S.border[side]
    local NB = N.border[10 - side]

    SB.kind = "liquid_arch"
    NB.kind = "nothing"

    S.thick[side] = 24
    N.thick[10 - side] = 24

    return true
  end


  local function try_make_fence(S, side)
    local N = S:neighbor(side)

    if not N or N.free then return end

    if S.kind == "void" or N.kind == "void" then return end

    local R1 = S.room
    local R2 = N.room

    if S.map_border and S.map_border.room then
      R1 = S.map_border.room
    end

    if N.map_border and N.map_border.room then
      R2 = N.map_border.room
    end

    if not R1 or not R2 then return end
    if R1 == R2 then return end

    if try_make_liquid_arch(S, R1, N, R2, side) then
      return
    end

    local SB = S.border[side]
    local NB = N.border[10 - side]

    -- require both rooms be outdoors
    if not (R1.is_outdoor and R2.is_outdoor) then return end

    -- not needed between two scenic rooms
    if R1.kind == "scenic" and R2.kind == "scenic" then
      SB.kind = "nothing"
      NB.kind = "nothing"
      return
    end

    if R1.kind == "cave" then
      S,  N  = N,  S
      SB, NB = NB, SB
      R1, R2 = R2, R1
      side   = 10 - side
    end

    -- NEVER need a fence between two caves
    if R1.kind == "cave" then return end

    -- don't add a normal fence next to a cave UNLESS the high parts
    -- of the cave are lower than the room's highest floor (which would
    -- allow the player to travel into the outdoor cave).
    if R2.kind == "cave" then
      if not R2.cave_fence_z then return end

      if R2.cave_fence_z >= R1.floor_max_h + PARAM.jump_height + 4 then return end
    end

    -- don't place fences in a map_border which touch the very edge
    -- of the map, purely for aesthetic reasons

    if S.map_border and R2.kind != "cave" then
      for pass = 1,2 do
        local dir = sel(pass == 1, geom.LEFT[side], geom.RIGHT[side])
        local T = S:neighbor(dir)

        if not T or T.free then
          SB.kind = "nothing"
          NB.kind = "nothing"
          return
        end
      end
    end

    -- OK --

    SB.kind = "fence"
    NB.kind = "straddle"
  end


-- TODO : SUPPORT FENCE DROPPING
--[[
    if STYLE.fences == "none" and R1.quest == R2.quest and R2.is_outdoor and
       (S.kind != "liquid" or S.floor_h == N.floor_h) and
       (R2.purpose != "EXIT") and
       not R1.teleport_conn and not R2.teleport_conn and
       R1.theme == R2.theme
    then
      S.border[side].kind = "nothing"
    end
--]]

-- TODO : LIQUID DROP-OFFS
--[[
      if N.kind == "liquid" and R2.is_outdoor and
        (S.kind == "liquid" or R1.quest == R2.quest)
        --!!! or (N.room.kind == "scenic" and safe_falloff(S, side))
      then
        S.border[side].kind = "nothing"
      end
--]]


  local function make_all_fences()
    for x = 1, SEED_W do
    for y = 1, SEED_TOP do
      local S = SEEDS[x][y]

      for side = 2,4,2 do
        -- don't clobber connections
        if S.border[side].kind then continue end

        try_make_fence(S, side)
      end
    end
    end
  end


  local function try_make_border(R1, S, R2, N, side)
    local SB = S.border[side]

    SB.kind = "nothing"

    -- solid seed?
    if S.kind == "void" then return end

    -- same room : do nothing
    if R1 == R2 then return end

    -- handle cave_gap here (it can occur at edge of map)
    if SB.cave_gap then
      SB.kind = "cave_wall"
      SB.w_tex = R1.main_tex
      S.thick[side] = 48

      -- make a fence instead?
      if R1.is_outdoor and R1.cave_fence_z then
        SB.kind = "cave_fence"
        SB.cave_fence_h = R1.cave_fence_z
      end
    end

    -- edge of map?
    if not R2 then
      if R1.kind == "building" then
        SB.kind = "wall"
        SB.touches_edge = true
        S.thick[side] = 16
      end

      return
    end

    assert(N)

    --- Caves ---

    if R1.kind == "cave" then
      -- caves (both indoor and outdoor) are usually self-bounded
      -- and only need a wall in special circumstances, e.g. when a
      -- whole seed was cleared for a connection.

      -- however outdoor caves with low walls need to build the facades
      -- of nearby buildings
      if not R1.is_outdoor or R1.high_wall then
        return
      end
    end

    --- Indoor room ---

    if not R1.is_outdoor then
      if R2.parent == R1 then
        SB.kind  = "facade"
        SB.w_tex = R2.main_tex
      else
        SB.kind = "wall"
      end

      S.thick[side] = 16

      -- FIXME: this is a kind of picture, do it better, honor symmetry
      if SB.kind == "wall" and S.kind == "liquid" and
         not S.chunk[2] and rand.odds(15)
      then
        SB.kind = "liquid_fall"
      end

      return
    end

    --- Outdoor room ---

    if R2.kind == "cave" then
      SB.kind  = "cave_wall"
      SB.w_tex = R2.main_tex

      S.thick[side] = 48

      -- see if actually need a cave fence
      if R2.is_outdoor and R2.cave_fence_z then
        SB.kind = "cave_fence"
        SB.cave_fence_h = R2.cave_fence_z
      end

    elseif R2.kind == "building" or R2.kind == "hallway" then
      SB.kind = "facade"
      SB.w_tex = R2.facade
    end
  end


  local function try_make_corner(S, corner)
    local R = S.room
    local N = S:neighbor(corner)

    if not R then return end

    if R.is_outdoor or R.kind == "cave" then return end

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


  local function make_outdoor_corners()
    for x = 1, SEED_W do
    for y = 1, SEED_TOP do
      local S = SEEDS[x][y]

      each corner in geom.CORNERS do
        try_make_corner(S, corner)
      end
    end
    end
  end


  local function calc_fence_height(R)
    if not R.fence_z then
      -- fence_z is the _bottom_ height of the fence
      R.fence_z = R.floor_max_h

      -- prevent player from getting over the fence via a border piece
      if R.has_map_border then
        R.fence_z = R.fence_z + (LEVEL.border_group.fence_boost or 0)
      end
    end
  end


  local function border_up(R)
    calc_fence_height(R)

    -- expand bbox so we can handle border pieces
    -- [ mainly ones which touch a cave ]
    for x = R.sx1 - 4, R.sx2 + 4 do
    for y = R.sy1 - 4, R.sy2 + 4 do
      if not Seed_valid(x, y) then continue end

      local S = SEEDS[x][y]

      local S_frame = (S.map_border and S.map_border.room)

      if not (S.room == R or S_frame == R) then continue end
        
      for side = 2,8,2 do
        if S.border[side].kind then
          -- don't clobber connections
          continue
        end

        local N = S:neighbor(side)

        local N_frame = (N and N.map_border and N.map_border.room)

        try_make_border(S_frame or R, S, N_frame or (N and N.room), N, side)
      end

    end -- x, y
    end
  end


  local function same_floors(S1, S2)
    -- this checks 3D floors too...

    for i = 1,9 do
      local K1 = S1.chunk[i]
      local K2 = S2.chunk[i]

      if not K1 and not K2 then break; end

      if not K1 or not K2 then return false end

      if K1.floor != K2.floor then return false end
    end

    return true
  end


  local function can_travel(R, R2, S0, side, off_dir, off_dist)
    local N0 = S0:neighbor(side)

    local S = S0:neighbor(off_dir, off_dist)

    if not (S and S.room == R) then return false end

    local N = S:neighbor(side)

    if not (N and N.room == R2) then return false end

    if S.kind != "walk" then return false end
    if N.kind != "walk" then return false end

    if not same_floors(S, S0) then return false end
    if not same_floors(N, N0) then return false end

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

        try_make_border(T.room, T, TN.room, TN, side)
        try_make_border(TN.room, TN, T.room, T, 10 - side)
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

      local S = C:get_seed(R)
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


    -- FIXME : properly handle 3D floors
    -- (current logic just uses floor_max_h)


    each bd in border_list do
      local S = bd.S
      local N = S:neighbor(side)

      if (bd.side == side) and S.floor_max_h and
         (N and N.room) and N.floor_max_h and
         not seed_is_blocked(N) and
         not (N.room.kind == "cave")
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

        max_f1 = math.max(max_f1, S.floor_max_h)
        max_f2 = math.max(max_f2, N.floor_max_h)

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


  local function collect_usable_pictures(z_space, kind)
    local tab = {}

    each name,info in PREFABS do
      if (kind == "logo" and string.match(name, "^Logo_")) or
         (kind != "logo" and string.match(name, "^Pic_"))
      then
        -- FIXME: proper theme check
        if info.theme and info.theme != LEVEL.theme_name then continue end

        -- FIXME: proper room_type check
        if info.room_type and info.room_type != string.upper(kind) then
          continue
        end

        local height = info.height or info.bound_z2 or 128

        if height > z_space then continue end

        tab[name] = info.prob or 50
      end
    end

    -- FIXME !!! HACK HACK HACK
    if table.empty(tab) then
      tab["Logo_Carve"] = 50
    end

    return tab
  end


  local function select_picture(R, z_space, index)
    z_space = z_space - 16
    -- FIXME: needs more z_space checking

    if not THEME.logos then
      error("Game is missing logo skins")
    end

    if rand.odds(sel(LEVEL.has_logo,7,40)) then
      LEVEL.has_logo = true
      return rand.key_by_probs(collect_usable_pictures(z_space, "logo"))
    end

    if R.has_liquid and index == 1 and rand.odds(75) then
      return rand.key_by_probs(collect_usable_pictures(z_space, "waste"))
    end

    return rand.key_by_probs(collect_usable_pictures(z_space, "generic"))
  end


  local function install_pic(R, bd, pic_name, z_space)
    local skin = assert(PREFABS[pic_name])

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
          B.kind = "picture"
          B.pic_skin = skin
          B.pic_z1 = S.floor_max_h
          B.pic_fit_z = z_space
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

    local z_space = 999

    -- FIXME : properly handle 3D floors

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

        local h = (S.ceil_h or R.ceil_h) - S.floor_max_h
        z_space = math.min(z_space, h)
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
    pics[1] = select_picture(R, z_space, 1)
    pics[2] = pics[1]

    if #border_list >= 12 then
      -- prefer a different pic for #2
      for loop = 1,3 do
        pics[2] = select_picture(R, z_space, 2)
        if pics[2].pic_w != pics[1].pic_w then break; end
      end
    end

    gui.debugf("Selected pics: %s %s\n", pics[1], pics[2])


    for loop = 1,count do
      if #new_list == 0 then break; end

      -- FIXME !!! SELECT GOOD SPOT
      local b_index = rand.irange(1, #new_list)

      local bd = table.remove(new_list, b_index)
      
      install_pic(R, bd, pics[1 + (loop-1) % 2], z_space)
    end -- for loop
  end


  ---| Room_border_up |---

  -- fences straddle two rooms, so handle them first
  make_all_fences()

  each R in LEVEL.rooms do
    border_up(R)
  end
  each R in LEVEL.scenic_rooms do
    border_up(R)
  end

  make_outdoor_corners()

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

    for x = x1,x2 do
    for y = y1,y2 do
      local S = SEEDS[x][y]

      if S.room != R then continue end

      -- ignore void seeds (cages too)
      if S.kind == "void" then continue end

      local f_h = S.floor_max_h or S.floor_h

      assert(f_h)

      local diff_h = (S.ceil_h or R.ceil_h) - (f_h + 144)

      if diff_h < 1 then return nil end

      if not drop_z or (diff_h < drop_z) then
        drop_z = diff_h
      end

    end -- x, y
    end

    return drop_z
  end


  local function add_3d_corner_pillar(S, top_h)
    -- already a periph pillar?
    if S.solid_corner then return end

    if not THEME.periph_pillar_mat then
      return
    end

    local px = S.x2
    local py = S.y2
    local pw = 12

    local info = add_pegging(get_mat(THEME.periph_pillar_mat))

    Trans.old_quad(info, px-pw, py-pw, px+pw, py+pw, -EXTREME_H, top_h)

    S.solid_corner = true
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

    for x = x1,x2 do
    for y = y1,y2 do
      local S = SEEDS[x][y]

      -- check if all neighbors are in same room
      local count = 0

      for dx = 0,1 do
      for dy = 0,1 do
        local nx = x + dx * x_dir
        local ny = y + dy * y_dir

        if Seed_valid(nx, ny) and SEEDS[nx][ny].room == R then
          count = count + 1
        end
      end -- for dx,dy
      end

      if count == 4 then
        local w = 12

        local px = sel(x_dir < 0, S.x1, S.x2)
        local py = sel(y_dir < 0, S.y1, S.y2)

        Trans.old_quad(info, px-w, py-w, px+w, py+w, -EXTREME_H, EXTREME_H)
        
        R.has_periph_pillars = true

        -- mark seed
        local nx = x + sel(x_dir < 0, -1, 0)
        local ny = y + sel(y_dir < 0, -1, 0)

        SEEDS[nx][ny].solid_corner = true
      end

    end -- for x, y
    end
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
    for x = R.tx1, R.tx2 do
    for y = R.ty1, R.ty2 do
      local S = SEEDS[x][y]

      if S.room != R then continue end
      
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

    end -- for x, y
    end
  end


  local function shrink_to_volume(frac)
    local vert_first = 0

    if R.cy2 - R.cy1 > R.cx2 - R.cx1 then
      vert_first = 1
    end

    local max_vol = R.tvolume * frac
    if max_vol < 2 then max_vol = 2 end

    for pass = 1, 4 do
      local cw, ch = geom.group_size(R.cx1, R.cy1, R.cx2, R.cy2)

      -- stop when small enough
      if cw * ch <= max_vol then break; end

      local do_vert = (((pass + vert_first) % 2) == 0)

      if do_vert then
        if ch < 2 then continue end

        -- do both sides?
        if ch >= 5 or (ch >= 4 and rand.odds(50)) then
          R.cy1 = R.cy1 + 1
          R.cy2 = R.cy2 - 1

        -- prefer move a side away from the edge of room
        elseif R.cy1 <= R.ty1 and R.cy2 < R.ty2 then
          R.cy1 = R.cy1 + 1
        elseif R.cy2 >= R.ty2 and R.cy1 > R.ty1 then
          R.cy2 = R.cy2 - 1

        -- otherwise pick randomly
        elseif rand.odds(50) then
          R.cy1 = R.cy1 + 1
        else
          R.cy2 = R.cy2 - 1
        end

      else
        -- horizontal (same logic as above)

        if cw < 2 then continue end

        if cw >= 5 or (cw >= 4 and rand.odds(50)) then
          R.cx1 = R.cx1 + 1
          R.cx2 = R.cx2 - 1

        elseif R.cx1 <= R.tx1 and R.cx2 < R.tx2 then
          R.cx1 = R.cx1 + 1
        elseif R.cx2 >= R.tx2 and R.cx1 > R.tx1 then
          R.cx2 = R.cx2 - 1

        elseif rand.odds(50) then
          R.cx1 = R.cx1 + 1
        else
          R.cx2 = R.cx2 - 1
        end
      end -- do_vert

    end -- pass
  end


  local function fill_xyz(ceil_h, is_sky, c_tex, c_light)
    -- for sky ceilings, don't make them too large
    if is_sky then
      shrink_to_volume(0.31)
      local cw, ch = geom.group_size(R.cx1, R.cy1, R.cx2, R.cy2)
      ceil_h = ceil_h + (ch + cw) * 12
    else
      shrink_to_volume(0.62)
      ceil_h = ceil_h + 24
    end

    for x = R.cx1, R.cx2 do
    for y = R.cy1, R.cy2 do
      local S = SEEDS[x][y]

      if S.room != R then continue end
      
      S.ceil_h  = ceil_h
      S.c_tex   = c_tex
      S.c_light = c_light
      S.is_sky  = is_sky

    end -- for x, y
    end
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
    if S.chunk[2] then return end

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

    for x = x1,x2 do
    for y = y1,y2 do
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
    end -- for x, y
    end

    return true
  end


  local function add_cross_beam(dir, x1,y1, x2,y2, mode)
    local skin
    
    if mode == "light" then
      if not R.quest.ceil_light then return end
      skin = { w=R.lite_w, h=R.lite_h, lite_f=R.quest.ceil_light, trim=THEME.light_trim }
    end

    for x = x1,x2 do
    for y = y1,y2 do
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

    end -- for x, y
    end
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

    if R.has_periph_pillars and not has_sky_nb and rand.odds(18) then
      fill_xyz(R.ceil_h, "is_sky")
      R.semi_outdoor = true
      return
    end


    if rand.odds(20) then
      add_central_pillar()
      return
    end

    if not R.quest.ceil_light and THEME.ceil_lights then
      R.quest.ceil_light = rand.key_by_probs(THEME.ceil_lights)
    end

    local beam_chance = style_sel("beams", 0, 5, 20, 50)

    if rand.odds(beam_chance) then
      if criss_cross_beams("beam") then
        add_central_pillar()
        return
      end
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
      fill_xyz(R.ceil_h, false, light_name, 0.75)
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


  local function test_3d_corner_for_floor(x, y, corner, f_idx)
    if corner == 3 or corner == 9 then x = x + 1 end
    if corner == 7 or corner == 9 then y = y + 1 end

    local S = SEEDS[x][y]
    corner = 10 - corner

    local K = S.chunk[f_idx]
    if not K then return nil end

    local floor = assert(K.floor)
    local f_h   = assert(floor.floor_h)

    for pass = 1,2 do
      local dir

      -- only need to test two neighbors (connected edges)
      if pass == 1 then
        dir = geom.LEFT_45[corner]
      else
        dir = geom.RIGHT_45[corner]
      end

      local N = S:neighbor(dir)
      assert(N.room == R)

      -- ground floor is equal / above this floor?
      if N.floor_h >= f_h - 16 then return nil end

      -- other floor connects?
      for i = 2,9 do
        local K2 = N.chunk[i]
        if not K2 then break; end
        if K2.floor and math.abs(K2.floor.floor_h - f_h) < 12 then return nil end
      end
    end

    -- OK, this corner is jutting out

    return f_h
  end


  local function find_3d_corner_at_seed(x, y)
    -- basic usability test...
    local overlays = false

    for dx = 0, 1 do
    for dy = 0, 1 do
      local S = SEEDS[x + dx][y + dy]
      if S.room != R then return end

      if S.kind == "void" then return end

      if S.chunk[2] then overlays = true end
    end -- dx, dy
    end

    if not overlays then return end

    -- more complex tests...

    for f_idx = 9,2,-1 do
      -- test all four corners, pick highest pillar (if any)
      local best_h

      each corner in geom.CORNERS do
        local top_h = test_3d_corner_for_floor(x, y, corner, f_idx)

        if top_h and (not best_h or top_h > best_h) then
          best_h = top_h
        end
      end

      if best_h then
        add_3d_corner_pillar(SEEDS[x][y], best_h + 1)
        return
      end
    end
  end


  local function find_3d_corners()
    -- find corners of 3D floors that jut out into the room, and
    -- place a narrow pillar there (seeming to support the floor).

    for x = R.sx1, R.sx2 - 1 do
    for y = R.sy1, R.sy2 - 1 do
      find_3d_corner_at_seed(x, y, corner)
    end
    end
  end

  
  local function eval_3d_beam(bx, by, f_idx)
    local S = SEEDS[bx][by]

    if S.conn or S.content then return -1 end

    local K1 = S.chunk[f_idx]

    if not K1 or not K1.floor then return -1 end

    -- count number of neighbors with same floor
    local count = 0

    for dir = 2,8,2 do
      local N = S:neighbor(dir)

      if not N or N.free then continue end
      if N.room != R then continue end

      each n_idx, K2 in N.chunk do
        if n_idx >= 2 and K2.floor == K1.floor then
          count = count + 1
        end
      end
    end

    if count < 2 then return -1 end

    local h = K1.floor.floor_h

    local score = h + count * 100 + gui.random()

    return score, h
  end


  local function place_one_support_beam(bx, by, top_h)
    local S = SEEDS[bx][by]

    local mx, my = S:mid_point()

    local brush = brushlib.quad(mx - 32, my - 32, mx + 32, my + 32)

    -- FIXME: - 25 is a hack (just below the 3d floor)
    brushlib.add_top(brush, top_h - 25)
    brushlib.set_mat(brush, "METAL", "METAL")

    Trans.brush(brush)
  end


  local function place_3d_support_beams()
    -- look for three seeds in a row which have an overlay floor
    -- (the same one), and attempt to place a 64x64 support under
    -- the middle one.

    local list = {}

    for x = R.sx1, R.sx2 do
    for y = R.sy1, R.sy2 do
      local S = SEEDS[x][y]

      if S.room != R then continue end

      for f_idx = 2,9 do
        if not S.chunk[f_idx] then break; end

        local score, h = eval_3d_beam(x, y, f_idx)

        if score >= 0 then
          table.insert(list, { x=x, y=y, h=h, score=score })
        end
      end
    end
    end

    if #list == 0 then return end


    -- add the beams, doing the highest score ones first

    table.sort(list,
        function (A, B) return A.score > B.score end)

    for i = 1,#list do
      if list[i].dead then continue end

      local bx = list[i].x
      local by = list[i].y

      place_one_support_beam(bx, by, list[i].h)

      -- dud any immediate neighbors
      for k = 1,#list do
        local dist = geom.dist(bx, by, list[k].x, list[k].y)

        if dist < 1.2 then list[k].dead = true end
      end
    end
  end


  ---| Room_make_ceiling |---

  if R.is_outdoor then
    outdoor_ceiling()
  else
    indoor_ceiling()
  end

  find_3d_corners()

  place_3d_support_beams()
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

    local tx1 = R.tx1 or R.sx1
    local ty1 = R.ty1 or R.sy1
    local tx2 = R.tx2 or R.sx2
    local ty2 = R.ty2 or R.sy2

    for x = tx1, tx2-1 do
    for y = ty1, ty2-1 do
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


  local function mark_spot(S)
    S.solid_corner = true
  end


  local function get_entity_coord(S, delta)
    local x = S.x2 + rand.irange(-delta, delta)
    local y = S.y2 + rand.irange(-delta, delta)

    return x, y, S.floor_h
  end


  local function add_outdoor_torches()
    if not (LEVEL.is_dark or rand.odds(5)) then return end

    local torch_names = THEME.outdoor_torches or THEME.cave_torches
    if not torch_names then return end

    local torch_ent = rand.key_by_probs(torch_names)

    local chance = rand.pick({ 15, 25, 35 })

    each spot in find_spots() do
      if rand.odds(chance) then
        mark_spot(spot.S)
        local x, y, z = get_entity_coord(spot.S, 16)
        Trans.entity(torch_ent, x, y, z, { light=192, factor=1.2 })
        R:add_decor (torch_ent, x, y, z)
      end
    end
  end


  local function add_barrels()
    if not GAME.ENTITIES["barrel"] then return end

    local chance = THEME.barrel_prob or 3

    each spot in find_spots() do
      if rand.odds(chance) then
        mark_spot(spot.S)
        for loop = 1, 1 do
          local x, y, z = get_entity_coord(spot.S, 20)
          Trans.entity("barrel", x, y, z)
          R:add_decor ("barrel", x, y, z)
        end
      end
    end
  end


  local function add_crates()
    if STYLE.crates == "none" then return end

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
        mark_spot(spot.S)
        local z_top = spot.S.floor_h + (skin.h or 64)
        Build.crate(spot.S.x2, spot.S.y2, z_top, skin, R.is_outdoor)
      end
    end
  end


  --| Room_add_crates |--

  if R.kind == "outdoor" then
    add_outdoor_torches()
  end

  add_barrels()

  if R.kind == "building" or R.kind == "outdoor" then
    add_crates()
  end
end



function Room_tizzy_up()

  ---| Room_tizzy_up |---

  each R in LEVEL.rooms do
    Room_add_crates(R)
  end
end



function Room_do_small_exit__OLD()
  local C = R.conns[1]
  local T = C:get_seed(C:neighbor(R))
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
end



function Room_do_stairwell(R)
  R.well_tex   = rand.key_by_probs(R.theme.walls)
  R.well_floor = rand.key_by_probs(R.theme.floors)

  local skin = { wall=R.well_tex, floor=R.well_floor }

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
      local entry_S = S.room.entry_conn:get_seed(S.room)
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
      return N.room.zone.hall_tex
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
      fab_name = "Item_podium"
    end

    local def = PREFABS[fab_name]
    assert(def)

    local skin1 = { item=item }

    local T = Trans.spot_transform(mx, my, z, 2) -- TODO: spot_dir

    Fabricate(R, def, T, { skin1 })

    Trans.entity("light", mx, my, z+112, { cave_light=176 })
  end


  local function content_very_big_item(S, item, z1, is_weapon)
    -- sometimes make a lowering pedestal
    local prob = sel(is_weapon, 40, 20)

    local mx, my = S:mid_point()

    if rand.odds(prob) and
       THEME.lowering_pedestal_skin and
       not S.chunk[2]
    then
      local z_top

      if R.kind == "cave" then
        z_top = z1 + rand.pick({ 64, 96 })

      else
        local z2 = S.ceil_h or S.room.ceil_h or (z1 + 256)

        if z2 < z1 + 170 then
          z_top = z1 + 64
        else
          z_top = z1 + 128
        end
      end

      Build.lowering_pedestal(S, z_top, THEME.lowering_pedestal_skin)

      Trans.entity(item, mx, my, z_top)
      Trans.entity("light", mx, my, z_top + 24, { cave_light=176 })

    else
      content_big_item(item, mx, my, z1)
    end
  end


  local function content_start_pad(mx, my, z, dir)
    local def = PREFABS["Start_basic"]
    assert(def)

    local T = Trans.spot_transform(mx, my, z, 10 - dir)

    Fabricate(R, def, T, { })
  end


  local function content_coop_pair(mx, my, z, dir)
    -- no prefab for this : add player entities directly

    local angle = geom.ANGLES[dir]

    local dx, dy = geom.delta(dir)

    dx = dx * 24 ; dy = dy * 24

    Trans.entity(R.player_set[1], mx - dy, my + dx, z, { angle=angle })
    Trans.entity(R.player_set[2], mx + dy, my - dx, z, { angle=angle })

    if GAME.ENTITIES["player8"] then
      mx = mx - dx * 2
      my = my - dy * 2

      Trans.entity(R.player_set[3], mx - dy, my + dx, z, { angle=angle })
      Trans.entity(R.player_set[4], mx + dy, my - dx, z, { angle=angle })
    end
  end


  local function content_start(S, mx, my, z1)
    local dir = player_dir(S)

    if R.player_set then
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
    local CS = R.conns[1]:get_seed(R)
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
      Trans.entity("light", mx, my, z1+144, { cave_light=176 })
    end
  end


  local function content_purpose(S)
    local sx, sy = S.sx, S.sy

    local z1 = assert(S.floor_h)
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
      content_very_big_item(S, LOCK.item, z1)

    elseif R.purpose == "SWITCH" then
      local LOCK = assert(R.purpose_lock)
      local INFO = assert(GAME.SWITCHES[LOCK.switch])
      Build.small_switch(S, dir_for_wotsit(S), z1, INFO.skin, LOCK.tag)
      Trans.entity("light", mx, my, z1+112, { cave_light=176 })

    else
      error("unknown purpose: " .. tostring(R.purpose))
    end
  end


  local function content_weapon(S)
    local sx, sy = S.sx, S.sy

    local z1 = assert(S.floor_h)
    local z2 = S.ceil_h  or R.ceil_h or 999

    local mx, my = S:mid_point()

    local weapon = assert(S.content_item)

    if R == LEVEL.start_room or R.hallway then
      -- bare item
      Trans.entity(weapon, mx, my, z1)
    else
      content_very_big_item(S, weapon, z1, "is_weapon")
    end

    gui.debugf("Placed weapon '%s' @ (%d,%d,%d)\n", weapon, mx, my, z1)
  end


  local function content_item(S)
    local item = assert(S.content_item)

    local mx, my = S:mid_point()
    local z1 = assert(S.floor_h)

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

    local def = PREFABS["Teleporter1"]
    assert(def)

    local skin1 = {}

    if C.R1 == R then
      skin1. in_tag = C.tele_tag2
      skin1.out_tag = C.tele_tag1
    else
      skin1. in_tag = C.tele_tag1
      skin1.out_tag = C.tele_tag2
    end

    skin1. in_target = string.format("tele%d", skin1. in_tag)
    skin1.out_target = string.format("tele%d", skin1.out_tag)

    local mx, my = S:mid_point()
    local spot_dir = 10 - dir_for_wotsit(S)
    local z = assert(S.floor_h)

    local T = Trans.spot_transform(mx, my, z, spot_dir)

    Fabricate(R, def, T, { skin1 })
  end


  local function do_wall(S, side, w_tex)
    local def = PREFABS["Wall_plain"]
    assert(def)

    local skin1 = { wall=w_tex }

    local deep = assert(def.deep)

    local T = Trans.edge_transform(S.x1, S.y1, S.x2, S.y2, S.floor_h,
                                   side, 0, 192, deep, 0)

    Fabricate(R, def, T, { skin1 })
  end


  local function do_liquid_fall(S, side, w_tex, z2)
    if z2 < S.floor_h + 160 then
      do_wall(S, side, w_tex)
      return
    end

    local def = PREFABS["Wall_liquid_fall"]
    assert(def)

    local skin1 = { wall=w_tex }

    local deep = assert(def.deep)

    local T = Trans.edge_transform(S.x1, S.y1, S.x2, S.y2, S.floor_h,
                                   side, 0, 192, deep, 0)

    if def.z_fit then
      T.fitted_z = z2 - S.floor_h
    end

    Fabricate(R, def, T, { skin1 })
  end


  local function do_window(S, side, w_tex)
    local B = S.border[side]

    local fab_name = "Window_" .. B.win_kind

    if B.win_z2 then
      fab_name = fab_name .. "_tall"
    end

    local def = PREFABS[fab_name]
    assert(def)

    local o_tex = outer_tex(S, side, w_tex)
    local skin1 = { wall=w_tex, outer=o_tex or w_tex }

    assert(def.deep)
    assert(def.over)

    local T = Trans.edge_transform(S.x1, S.y1, S.x2, S.y2, B.win_z1,
                                   side, 0, 192, def.deep, def.over)

    if B.win_z2 then
      T.fitted_z = B.win_z2 - B.win_z1
    end

    Fabricate(R, def, T, { skin1 })
  end


  local function do_picture(S, side, w_tex)
    local B = S.border[side]

    local def = B.pic_skin
    assert(def)
    assert(def.deep)

    local skin1 = { wall=w_tex }

    local T = Trans.edge_transform(S.x1, S.y1, S.x2, S.y2, B.pic_z1,
                                   side, 0, 192, def.deep, 0)

    T.fitted_z = B.pic_fit_z

    Fabricate(R, def, T, { skin1 })
  end


  local function do_fat_cage(S, w_tex)
    local def = PREFABS["Cage_fat"]
    assert(def)

    local skin1 = { wall=w_tex }

    local T = Trans.box_transform(S.x1, S.y1, S.x2, S.y2, S.cage_z, S.cage_dir)

    Fabricate(R, def, T, { skin1 })
  end


  local function do_door_base(S, side, z, w_tex, o_tex)
    -- ensure that doors that connect to a 3D floor have a decent
    -- wall underneath them.

    -- need to try both sides
    for pass = 1,2 do
      local N = S ; if pass == 2 then N = S:neighbor(side) end
      local N_side = side
      local N_tex = w_tex

      if pass == 2 then
        N = S:neighbor(side)
        N_side = 10 - side
        N_tex = o_tex
      end

      if not N.chunk[2] then continue end

      local x1, y1 = N.x1, N.y1
      local x2, y2 = N.x2, N.y2

      if N_side == 2 then y2 = y1 + 64 end
      if N_side == 8 then y1 = y2 - 64 end
      if N_side == 4 then x2 = x1 + 64 end
      if N_side == 6 then x1 = x2 - 64 end
--[[
      if geom.is_vert(N_side) then
        x1 = x1 + 8 ; x2 = x2 - 8
      else
        y1 = y1 + 8 ; y2 = y2 - 8
      end
--]]
      local brush = brushlib.quad(x1, y1, x2, y2)

      brushlib.add_top(brush, z - 6)
      brushlib.set_mat(brush, N_tex, N_tex)

      Trans.brush(brush)
    end
  end


  local function do_archway(S, side, f_tex, w_tex)
    local conn = S.border[side].conn

    if conn.conn_ftex then
      f_tex = conn.conn_ftex
    end

    local z = assert(conn and conn.conn_h)

    if conn.diff_h and conn.diff_h < 0 then
      z = z + conn.diff_h
    end

    local fab_name = S.border[side].fab_name or "Arch_plain"
    if conn.diff_h then fab_name = "Arch_stair" end
    
    if fab_name == "Arch_plain" and THEME.archy_arches then
       fab_name = "Arch_archy"
    end

    local def = PREFABS[fab_name]
    assert(def)

    local o_tex = outer_tex(S, side, w_tex)
    local skin1 = { wall=w_tex, floor=f_tex, outer=o_tex }

    if skin1.wall == skin1.outer then
      skin1.track = skin1.wall
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
                                   side, 0, seed_w * 192, def.deep, def.over)

    Fabricate(R, def, T, { skin1 })

    do_door_base(S, side, z, w_tex, o_tex)
  end


  function do_door(S, side, f_tex, w_tex)
    local z = assert(S.conn and S.conn.conn_h)

    -- FIXME : pick one properly
    local fab_name
    if LEVEL.theme_name == "wolf" then
      fab_name = "Door_wolf"
    elseif THEME.techy_doors then
      fab_name = "Door_techy"
    else
      fab_name = "Door_large"
    end

    local def = PREFABS[fab_name]
    assert(def)

    local o_tex = outer_tex(S, side, w_tex)
    local skin1 = { wall=w_tex, floor=f_tex, outer=o_tex }

    if skin1.wall == skin1.outer then
      skin1.track = skin1.wall
    end

    local S2 = S
    local seed_w = 1

    local T = Trans.edge_transform(S.x1, S.y1, S2.x2, S2.y2, z,
                                   side, 0, seed_w * 192, def.deep, def.over)

    Fabricate(R, def, T, { skin1 })

    do_door_base(S, side, z, w_tex, o_tex)
  end


  function do_keyed_door(S, side, f_tex, w_tex)
    local z = assert(S.conn and S.conn.conn_h)

    local LOCK = assert(S.border[side].lock)

    -- FIXME : find it properly
    local fab_name = "Locked_" .. LOCK.item

    local def = PREFABS[fab_name]
    assert(def)

    local o_tex = outer_tex(S, side, w_tex)
    local skin1 = { wall=w_tex, floor=f_tex, outer=o_tex }

    local S2 = S
    local seed_w = 1

    local T = Trans.edge_transform(S.x1, S.y1, S2.x2, S2.y2, z,
                                   side, 0, seed_w * 192, def.deep, def.over)

    Fabricate(R, def, T, { skin1 })

    do_door_base(S, side, z, w_tex, o_tex)
  end


  function do_locked_door(S, side, f_tex, w_tex)
    local z = assert(S.conn and S.conn.conn_h)

    local LOCK = assert(S.border[side].lock)

    if LOCK.item then
      do_keyed_door(S, side, f_tex, w_tex)
      return
    end

    -- FIXME : find it properly
    local fab_name = "Door_with_bars" --!!! Door_SW_blue

    local def = PREFABS[fab_name]
    assert(def)

    local o_tex = outer_tex(S, side, w_tex)
    local skin1 = { wall=w_tex, floor=f_tex, outer=o_tex }

    skin1.lock_tag = LOCK.tag

    local S2 = S
    local seed_w = 1

    local T = Trans.edge_transform(S.x1, S.y1, S2.x2, S2.y2, z,
                                   side, 0, seed_w * 192, def.deep, def.over)

    Fabricate(R, def, T, { skin1 })

    do_door_base(S, side, z, w_tex, o_tex)
  end


  local function do_liquid_arch(S, side, f_tex, w_tex)
    local z = S.floor_h

    local fab_name = "Window_liquid_arch"
    
    local def = PREFABS[fab_name]
    assert(def)

    local o_tex = outer_tex(S, side, w_tex)
    local skin1 = { wall=w_tex, floor=f_tex, outer=o_tex }

    if skin1.wall == skin1.outer then
      skin1.track = skin1.wall
    end

    local S2 = S
    local seed_w = 1

    local T = Trans.edge_transform(S.x1, S.y1, S2.x2, S2.y2, z,
                                   side, 0, seed_w * 192, def.deep, def.over)

    Fabricate(R, def, T, { skin1 })
  end


  local function calc_fence_extra_z(S, side, z)
    -- determine how much higher to make a fence, based on nearby high
    -- floors which the player could jump over it from.

gui.debugf("calc @ %s side:%d\n", S:tostr(), side)
    local N = S:neighbor(side)
    assert(N)

    -- we may be inside a map border
    N_room = N.room
    if not N_room then
      assert(N.map_border)
      N_room = assert(N.map_border.room)
    end

    local f_max = math.max(R.fence_z, N_room.fence_z)
    local c_min = math.min(R.ceil_h,  N_room.ceil_h)

    local FENCE_H = 32  -- must match the prefab (ugh, hack)

    -- this is where we get to when extra_z == 0
    z = z + FENCE_H

    local extra_z     = f_max + LEVEL.fence_h - z
    local extra_limit = c_min - z - 64

    -- make fence higher near item pedestals (etc)
    if S.content == "wotsit" then
      extra_z = math.max(extra_z, S.floor_max_h + 56 - z)
    end
    if N.content == "wotsit" then
      extra_z = math.max(extra_z, N.floor_max_h + 56 - z)
    end

    if extra_z > extra_limit then
       extra_z = extra_limit
    end

    if extra_z < 0 then extra_z = 0 end

    return extra_z
  end


  local function do_secret_door(S, side, f_tex, w_tex)
    local conn = S.border[side].conn

    local z = assert(conn and conn.conn_h)

    local is_fence = conn.R1.is_outdoor and
                     conn.R2.is_outdoor and
                     not conn.R1.high_wall and
                     not conn.R2.high_wall

    local extra_z

    if is_fence then
      extra_z = calc_fence_extra_z(S, side, z)
    end

    -- this fixes a problem with caves (bit of a hack)
    if conn.R1.kind == "cave" or conn.R2.kind == "cave" then
      z = z + 2

      if extra_z and extra_z >= 2 then extra_z = extra_z - 2 end
    end

    local fab_name = "Door_secret"
    if is_fence then
      fab_name = "Fence_secret"
      w_tex = LEVEL.fence_mat or w_tex
    end

    local def = PREFABS[fab_name]
    assert(def)

    local o_tex = outer_tex(S, side, w_tex)
    local skin1 = { wall=w_tex, floor=f_tex, outer=o_tex }

    local T = Trans.edge_transform(S.x1, S.y1, S.x2, S.y2, z,
                                   side, 0, 192, def.deep, def.over)

    if is_fence then
      T.fitted_z = def.bound_z2 + extra_z
    end

    Fabricate(R, def, T, { skin1 })
  end


  function do_lowering_bars(S, side, f_tex, w_tex)
    local LOCK = assert(S.border[side].lock)

    local z = assert(S.conn and S.conn.conn_h)

    local extra_z = calc_fence_extra_z(S, side, z)

    w_tex = LEVEL.fence_mat or w_tex

    local fab_name = "Bars_shiny"

    local def = PREFABS[fab_name]
    assert(def)

    local o_tex = outer_tex(S, side, w_tex)
    local skin1 = { wall=w_tex, floor=f_tex, outer=o_tex }

    skin1.lock_tag = LOCK.tag

    local T = Trans.edge_transform(S.x1, S.y1, S.x2, S.y2, z,
                                   side, 0, 192, def.deep, def.over)

    T.fitted_z = def.bound_z2 + extra_z

    Fabricate(R, def, T, { skin1 })
  end


  local function do_fence(S, side, w_tex, f_tex)
    local z = R.fence_z

    local extra_z = calc_fence_extra_z(S, side, z)

    w_tex = LEVEL.fence_mat or w_tex

    local fab_name = "Fence_gappy"

    local def = PREFABS[fab_name]
    assert(def)

    local o_tex = outer_tex(S, side, w_tex)
    local skin1 = { wall=w_tex, floor=f_tex, outer=o_tex }

    -- ??? TODO : less wide at edge of room

    local T = Trans.edge_transform(S.x1, S.y1, S.x2, S.y2, z,
                                   side, 0, 192, def.deep, def.over)

    T.fitted_z = def.bound_z2 + extra_z

    Fabricate(R, def, T, { skin1 })
  end


  local function do_secret_floor(S, z, indents, w_tex, f_tex)
    -- FIXME: this is game specific!!

    local kind, w_face, t_face = Mat_normal(w_tex, f_tex)

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


  local function do_extra_floor(S, z, indents, w_tex, f_tex)
    local kind, w_face, t_face = Mat_normal(S.l_tex or w_tex, f_tex)

    local x1 = S.x1 + (indents[4] or 0)
    local y1 = S.y1 + (indents[2] or 0)
    local x2 = S.x2 - (indents[6] or 0)
    local y2 = S.y2 - (indents[8] or 0)

    Trans.quad(x1,y1, x2,y2, z-24,z, kind, w_face, t_face)
  end


  local function do_stair(S, w_tex, f_indents)
    local K = assert(S.chunk[1])
    assert(K.src_floor and K.dest_floor)

    local z1 = K. src_floor.floor_h
    local z2 = K.dest_floor.floor_h

    local dir, high_tex

    if z1 < z2 then
      do_floor(S, z1, f_indents, w_tex, K.src_floor.floor_tex)
      high_tex = K.dest_floor.floor_tex
      dir = K.dir
    else
      do_floor(S, z2, f_indents, w_tex, K.dest_floor.floor_tex)
      high_tex = K.src_floor.floor_tex
      dir = 10 - K.dir
    end

    -- really need one?
    local diff_z = math.abs(z1 - z2)

    if diff_z <= PARAM.step_height then return end

    -- TODO select properly
    local fab_name

    local mode = sel(z1 > z2, "niche", "outie")
    local top_z

    if diff_z > 96 then
      top_z = 96 ; fab_name = "Lift_" .. mode
    elseif diff_z >= 56 then
      top_z = 56 ; fab_name = "Stair_".. mode .. "_56"
    elseif diff_z >= 32 then
      top_z = 32 ; fab_name = "Stair_".. mode .. "_32"
    else
      error("no stair for floor height difference of " .. diff_z)
    end

    local def = PREFABS[fab_name]
    assert(def)

    local skin1 = { wall=w_tex, floor=high_tex }

    -- FIXME: chunk coordinates
    local x1 = S.x1
    local y1 = S.y1
    local x2 = S.x2
    local y2 = S.y2

    local T = Trans.box_transform(x1, y1, x2, y2, math.min(z1, z2), dir)

    T.fitted_z = diff_z

    Fabricate(R, def, T, { skin1 })
  end


  local function do_small_bridge(S)
    local def = PREFABS["Bridge_curvey"]
    assert(def)

    local skin1 = { floor=S.bridge_tex, wall=R.main_tex }

    local T = Trans.box_transform(S.x1, S.y1, S.x2, S.y2, S.bridge_h, S.bridge_dir)

    Fabricate(R, def, T, { skin1 })
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
         B_kind == "picture" or B_kind == "cave_wall"
      then
        vis_mark_wall(S, side)
      end
    end
  end


  local function build_seed(S, sides_only)
    if S.already_built then
      return
    end

    vis_seed(S)

    local z1 = S.floor_h or (S.conn and S.conn.conn_h) or 0
    local z2 = S.ceil_h  or R.ceil_h  or (z1 + 256)

    assert(z1 and z2)


    local w_tex = S.w_tex or R.main_tex
    local f_tex = S.f_tex or R.main_tex
    local c_tex = S.c_tex or sel(R.is_outdoor, "_SKY", R.ceil_tex)

    if R.kind == "hallway" then
      w_tex = assert(R.zone.hall_tex)
    elseif R.kind == "stairwell" then
      w_tex = assert(R.well_tex)
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


    --- WALLS ---

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
        local skin = { wall=R.zone.hall_tex, trim1=THEME.hall_trim1, trim2=THEME.hall_trim2 }
        Build.detailed_hall(S, side, z1, z2, skin)

        S.border[side].kind = nil
        B_kind = nil
      end

      if B_kind == "wall" or B_kind == "facade" then
        do_wall(S, side, border.w_tex or w_tex)
        shrink_both(side, 16)
      end

      if B_kind == "cave_wall" or B_kind == "cave_fence" then
        local narrow = (S.conn or S.content)
        Build.cave_wall(S, side, border.w_tex or w_tex, border.cave_fence_h, narrow)

        if B_kind == "cave_wall" then
          shrink_ceiling(side, 4)
        end
        shrink_floor(side, 4)
      end

      if B_kind == "fence" then
        do_fence(S, side, w_tex, f_tex)
        shrink_floor(side, 16)
      end

      if B_kind == "window" then
        do_window(S, side, w_tex)
        shrink_both(side, 16)
      end

      if B_kind == "picture" then
        do_picture(S, side, w_tex)
        shrink_both(side, 16)
      end

      if B_kind == "straddle" then
        -- TODO: ideally do both, cannot now due to fences / lowering_bars
        shrink_floor(side, 16)
      end

      if B_kind == "arch" then
        do_archway(S, side, f_tex, w_tex)
        shrink_both(side, 16)
      end

      if B_kind == "liquid_arch" then
        do_liquid_arch(S, side, f_tex, w_tex)
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

      if B_kind == "lock_door" then
        do_locked_door(S, side, f_tex, w_tex)
        shrink_both(side, 16)

        assert(not S.conn.already_made_lock)
        S.conn.already_made_lock = true
      end

      if B_kind == "secret_door" then
        do_secret_door(S, side, f_tex, w_tex)
        -- no base necessary
        shrink_floor(side, 16) --!!! both for door
      end

      if B_kind == "bars" then
        do_lowering_bars(S, side, f_tex, w_tex)
        shrink_floor(side, 16)

        assert(not S.conn.already_made_lock)
        S.conn.already_made_lock = true
      end
    end -- for side


    if sides_only or R.sides_only then return end


    --- DIAGONALS ---

    if S.kind == "diagonal" then

      local diag_info = get_mat(w_tex, S.stuckie_ftex)

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


    --- CEILING ---

    local cx1 = S.x1 + (c_indents[4] or 0)
    local cy1 = S.y1 + (c_indents[2] or 0)
    local cx2 = S.x2 - (c_indents[6] or 0)
    local cy2 = S.y2 - (c_indents[8] or 0)

    if R.kind == "cave" and not R.is_outdoor then
      -- nothing needed

    elseif S.kind != "void" and not S.no_ceil and 
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


    --- FLOOR ---

    local fx1 = S.x1 + (f_indents[4] or 0)
    local fy1 = S.y1 + (f_indents[2] or 0)
    local fx2 = S.x2 - (f_indents[6] or 0)
    local fy2 = S.y2 - (f_indents[8] or 0)

    if R.kind == "cave" then
      -- nothing needed for caves (almost)

      if S.mark_secret then
        -- determine floor height (it's not in the seed itself)
        local z

        each C in R.conns do
          if C.S1 == S or C.S2 == S then
            z = C.conn_h + 1 ; break
          end
        end

        local mat = R.floor_mat or R.zone.cave_wall_mat or R.main_tex
        assert(mat)

        if z then
          do_secret_floor(S, z, f_indents, mat, mat)
        end
      end

    elseif S.kind == "void" then

      if S.solid_feature and R.zone.corner_mats then
        if not R.corner_mat then
          R.corner_mat = rand.key_by_probs(R.zone.corner_mats)
        end
        w_tex = R.corner_mat
      end

      if S.cage_dir then
        do_fat_cage(S, w_tex)
      else
        Trans.old_quad(get_mat(w_tex), S.x1,S.y1, S.x2,S.y2, -EXTREME_H, EXTREME_H);
      end

    elseif S.kind == "stair" then
      do_stair(S, w_tex, f_indents)

    elseif S.kind == "curve_stair" then
      Build.low_curved_stair(S, LEVEL.step_skin, S.x_side, S.y_side, S.x_height, S.y_height)

    elseif S.kind == "tall_stair" then
      Build.tall_curved_stair(S, LEVEL.step_skin, S.x_side, S.y_side, S.x_height, S.y_height)

    elseif S.kind == "popup" then
      -- FIXME: monster!!
      local skin = { wall=w_tex, floor=f_tex }
      Build.popup_trap(S, z1, skin, "revenant")

    elseif S.kind == "liquid" then
      assert(LEVEL.liquid)
      do_floor(S, z1, f_indents, w_tex, f_tex, get_liquid(R.is_outdoor))

    elseif not S.no_floor then
      if S.mark_secret then
        do_secret_floor(S, z1, f_indents, S.l_tex or w_tex, f_tex)
      else
        do_floor(S, z1, f_indents, w_tex, f_tex)
      end
    end


    --- 3D FLOORS ---

    for i = 2, 9 do
      local K2 = S.chunk[i]

      if not K2 then break; end
      
      if K2.floor then
        local z2 = assert(K2.floor.floor_h)

        do_extra_floor(S, z2, f_indents, w_tex, K2.floor.floor_tex)
      end
    end


    --- GOALS / PREFABS ---

    if S.content == "pillar" then
      Build.pillar(S, z1, z2, assert(S.pillar_skin), S.is_big_pillar)

    elseif S.content == "bridge" then
      do_small_bridge(S)

    elseif S.content == "wotsit" then
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


  local function build_mapborder_bits(B)
    for x = B.sx1, B.sx2 do
    for y = B.sy1, B.sy2 do
      local S = SEEDS[x][y]
      build_seed(S, "sides_only")
    end -- x, y
    end
  end


  ---==| Room_build_seeds |==---

  if R.kind == "smallexit" then
    Room_do_small_exit(R)
    return
  end

  if R.kind == "stairwell" then
    Room_do_stairwell(R)
    R.sides_only = true
  end

  for x = R.sx1, R.sx2 do
  for y = R.sy1, R.sy2 do
    local S = SEEDS[x][y]
    if S.room == R then
      build_seed(S)
    end
  end -- x, y
  end

  each B in LEVEL.map_borders do
    if B.room == R then
      build_mapborder_bits(B)
    end
  end
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



function Room_find_ambush_focus(R)
  -- Note: computes 'entry_coord' too

  -- FIXME: handle teleporter entry

  if R.kind == "stairwell" then return end

  if R.kind == "cave" then return end

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

    Room_find_ambush_focus(R)
  end
end



function Room_determine_spots()
  
  -- Algorithm:
  --
  -- For each floor of each room:
  --
  --   1. initialize grid to be CLEAR, to represent the current floor.
  --      the floor itself is never set or cleared, as polygon drawing
  --      always fills any pixel touched by the polygon, leading to
  --      making somewhat too big areas
  --  
  --   2. kill the sides of the room
  --
  --   3. kill all seeds not part of the current floor
  --
  --   4. use the CSG code to kill any blocking brushes 
  --

  local function clear_chunk(K)
    local S1 = SEEDS[K.sx1][K.sy1]
    local S2 = SEEDS[K.sx2][K.sy2]

    gui.spots_fill_box(S1.x1, S1.y1, S2.x2, S2.y2, SPOT_CLEAR)
  end


  local function solidify_seed(S)
    gui.spots_fill_box(S.x1, S.y1, S.x2, S.y2, SPOT_LEDGE)
  end


  local function try_solidify_seed(S, floor)
    for i = 1,9 do
      local K = S.chunk[i]

      if not K then break; end

      if K.kind == "floor" and K.floor == floor then
        return -- found the floor, so leave it alone
      end
    end

    -- that floor is not here
    solidify_seed(S)
  end


  local function spots_for_floor(R, floor)
    -- get bbox of room
    local rx1, ry1, rx2, ry2 = R:get_bbox()

    -- initialize grid to "clear"
    gui.spots_begin(rx1 - 48, ry1 - 48, rx2 + 48, ry2 + 48,
                    floor.floor_h, SPOT_CLEAR)

    -- handle edges of room
    R:spots_do_edges()

    -- any seeds which _DONT_ belong to this floor, solidify them
    for sx = R.sx1, R.sx2 do
    for sy = R.sy1, R.sy2 do
      local S = SEEDS[sx][sy]

      -- this check handles sub-rooms
      if S.room != R then
        solidify_seed(S)
        continue
      end

      if S.content == "bridge" then
        solidify_seed(S)
        continue
      end

      try_solidify_seed(S, floor)
    end
    end

    -- remove decoration entities
    R:spots_do_decor(floor.floor_h)

    -- remove walls and blockers (using nearby brushes)
    gui.spots_apply_brushes();

    -- add the spots to the room

    local item_spots = {}
    local  mon_spots = {}

    gui.spots_get_items(item_spots)
    gui.spots_get_mons(mon_spots)

--  stderrf("mon_spots @ %s floor:%d : %d\n", R:tostr(), f_h, #mon_spots)

    each spot in item_spots do
      table.insert(R.item_spots, spot)
    end

    each spot in mon_spots do
      table.insert(R.mon_spots, spot)
    end

    gui.spots_end();
  end


  local function spots_in_room(R)
    -- special code for caves 
    if R.kind == "cave" then
      Cave_determine_spots(R)
      return
    end

    if R.kind == "stairwell" then return end
    if R.kind == "smallexit" then return end

    each vhr,floor in R.floors do
      spots_for_floor(R, floor)
    end
  end


  ---| Room_determine_spots |---

  each R in LEVEL.rooms do
    spots_in_room(R)

    R:exclude_monsters()
  end
end



function Room_build_all()

  gui.printf("\n--==| Build Rooms |==--\n\n")

  gui.prog_step("Rooms")

  LEVEL.fence_h = 32

  Room_decide_hallways()

  Room_setup_symmetry()
  Room_reckon_doors()
  Room_create_sky_groups()

  Layout_plan_outdoor_borders()

  Room_layout_all()

  Room_plaster_ceilings()
  Room_tizzy_up()
  Room_border_up()

  Cave_outdoor_borders()
  Layout_build_outdoor_borders()

  Room_run_builders()

  Room_determine_spots()
end

