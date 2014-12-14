------------------------------------------------------------------------
--  ROOM MANAGEMENT
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


  areas = list(AREA)

  half_seeds = list(SEED)


  //////////////////////


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
    total_inner_points = 0

    areas = {}
    half_seeds = {}

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


function ROOM_CLASS.kill_it(R)
  each A in R.areas do
    A.mode = "void"
    A.room = nil

    each S in A.half_seeds do
      S.room = nil
    end
  end

  table.kill_elem(LEVEL.rooms, R)

  R.kind = "DEAD"

  R.sx1   = nil
  R.areas = nil
  R.conns = nil
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


function Room_create_sky_groups()
  --
  -- This makes sure that any two outdoor rooms which touch will belong
  -- to the same 'sky_group' and hence get the same sky height.
  --
  -- Note: actual sky heights are determined later.
  --

  local function new_sky_group()
    local group =
    {
      id = Plan_alloc_id("sky_group")
      add_h = rand.pick({ 144, 176, 208 })
    }
    table.insert(LEVEL.sky_groups, group)
    return group
  end


  local function spread_group(A)
    each N in A.neighbors do
      if N.is_outdoor and not N.sky_group then
        N.sky_group = A.sky_group
        spread_group(N)
      end
    end
  end


  ---| Room_create_sky_groups |---

  -- this is area based, will handle VOID and HALLWAYs too (as sky may
  -- potentially be used there, e.g. if VOID becomes an outdoor cage)

  LEVEL.sky_groups = {}

  each A in LEVEL.areas do
    if A.is_outdoor and not A.sky_group then
      A.sky_group = new_sky_group()
      spread_group(A)
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
    local dir = C.dir

    local B  = S.border[dir]
    local B2 = N.border[10 - dir]

    if B.kind != "arch" then
      S, N  = N, S
      B, B2 = B2, B
      dir = 10 - dir
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

      S.border[     dir] = B
      N.border[10 - dir] = B2
    end

    S.thick[     dir] = 40
    N.thick[10 - dir] = 40

    -- locked door?

    if C.lock then
      B.kind = "lock_door"
      B.conn = C
      B.lock = C.lock

      C.is_door = true

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
      C.is_door = true

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


--!!!!!!1 DISABLED NORMAL DOORS (etc) FOR NOW
do return end


    -- apply the random check
    local prob = indoor_prob
    if (S.room.is_outdoor and N.room.kind != "cave") or
       (N.room.is_outdoor and S.room.kind != "cave")
    then
      prob = outdoor_prob
    end

    if rand.odds(prob) then
      B.kind = "door"
      C.is_door = true

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








function Room_tizzy_up()

  ---| Room_tizzy_up |---

  each R in LEVEL.rooms do
--    Room_add_crates(R)
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
  -- For each area of each room:
  --
  --   1. initialize grid to be LEDGE.
  --
  --   2. CLEAR the polygons for area's floor.  This will produce areas
  --      which are somewhat too large.
  --
  --   3. use draw_line to set edges of area to LEDGE again, fixing the
  --      "too large" problem of the above step.
  --
  --   4. use the CSG code to kill any blocking brushes.
  --      This step creates the WALL cells.
  --


  local function spots_for_area(R, A)
    -- get bbox of room
    local rx1, ry1, rx2, ry2 = area_get_bbox(A)

    -- initialize grid to "ledge"
    gui.spots_begin(rx1 - 48, ry1 - 48, rx2 + 48, ry2 + 48, A.floor_h, SPOT_LEDGE)

    -- clear polygons making up the floor
    each brush in A.floor_brushes do
      gui.spots_fill_poly(brush, SPOT_CLEAR)
    end

    -- set the edges of the area
    each E in A.side_edges do
      gui.spots_draw_line(E.x1, E.y1, E.x2, E.y2, SPOT_LEDGE)
    end

    -- remove decoration entities
    R:spots_do_decor(A.floor_h)

    -- remove walls and blockers (using nearby brushes)
    gui.spots_apply_brushes()

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

    gui.spots_end()

--- DEBUG:
--- stderrf("AREA_%d has %d mon spots, %d item spots\n", A.id, #mon_spots, #item_spots)
  end


  local function spots_in_room(R)
    if R.kind == "stairwell" then return end
    if R.kind == "smallexit" then return end

    each A in R.areas do
      spots_for_area(R, A)
    end
  end


  ---| Room_determine_spots |---

  each R in LEVEL.rooms do
    spots_in_room(R)

    R:exclude_monsters()
  end
end


------------------------------------------------------------------------


function walkable_svolume()
  local vol = 0

  each A in LEVEL.areas do
    if A.mode == "normal" then
      vol = vol + A.svolume
    end
  end

  return vol
end


function sort_areas_by_volume()
  -- biggest first

  local list = table.copy(LEVEL.areas)

  each A in list do A.sort_rand = gui.random() end

  table.sort(list, function(A, B) return A.svolume + A.sort_rand > B.svolume + B.sort_rand end)

  return list
end


function largest_area()
  local best

  each A in LEVEL.areas do
    if A.mode == "normal" then
      if not best or (A.svolume > best.svolume) then
        best = A
      end
    end
  end

  assert(best)

  return best
end



function Weird_void_some_areas()
  local largest

  local visit_list


  local function flood_fill(A, visited)
    visited[A.id] = true

    each N in A.neighbors do
      if N.mode == "normal" and not visited[N.id] then
        flood_fill(N, visited)
      end
    end

    return visited
  end


  local function check_visited(visited)
    each A in LEVEL.areas do
      if A.mode == "normal" then
        if not visited[A.id] then return false end
      end
    end

    return true -- OK --
  end


  local function can_void_area(A)
    -- make sure than if 'A' is voided, all other areas remain reachable
    
    A.mode = "void"

    -- we flood first starting from the largest area (which is never void)
    local start = largest
    assert(start.mode == "normal")

    local visited = flood_fill(start, {})

    local result = check_visited(visited)

    -- leave it void if check succeeded
    if result then
      return true
    end

    A.mode = "normal"
    return false
  end


  local function pick_area_to_void()
    while not table.empty(visit_list) do
      local A = table.remove(visit_list, 1)

      if A.no_void then continue end

      if A.mode != "normal" then continue end

      if A.svolume > 20 then continue end

      if can_void_area(A) then return A end
    end

    return nil  -- nothing was possible    
  end


  ---| Weird_void_some_areas |---

  -- have a quota
  local quota = walkable_svolume() * 0.2
  
  -- the largest area can never become VOID
  largest = largest_area()

  largest.no_void = true

  -- visit areas in random order
  visit_list = table.copy(LEVEL.areas)

  rand.shuffle(visit_list)

  while quota > 0 do
    local A = pick_area_to_void()

    if not A then break; end

    quota = quota - A.svolume
  end
end



function Weird_assign_hallways()
  -- pick some areas to become hallways
  -- [ does not actually connect them here ]


  local function num_neighbor_with_mode(A, mode)
    local count = 0

    each N in A.neighbors do
      if N.mode == mode then count = count + 1 end
    end

    return count
  end


  local function eval_hallway(A)
    if A.no_hallway then return -1 end

    -- ignore scenic or void areas
    if A.mode != "normal" then return -1 end

    -- too big?
    if A.svolume > 24 then return -1 end

    -- too open?
    if A.openness > 0.4 then return -1 end

    -- don't touch an existing hallway
    -- [ TODO : relax this when style == "heaps" ]
    if num_neighbor_with_mode(A, "hallway") > 0 then return -1 end

    -- need at least two normal neighbors
    if num_neighbor_with_mode(A, "normal") < 2 then return -1 end

    -- often use very small areas
    if A.svolume <= 2.0 then
      return gui.random() * 10
    end

    local score = (1.0 - A.openness) * 10

    score = score + A.svolume / 4

    return score + gui.random()
  end


  local function pick_area_to_hall_up()
    local best
    local best_score = 0

    each A in LEVEL.areas do
      local score = eval_hallway(A)

      if score < 0 then
        A.no_hallway = true
      end

      if score > best_score then
        best = A
        best_score = score
      end
    end

    return best
  end


  ---| Weird_assign_hallways |---

  local quota = walkable_svolume() * 0.3

  local largest = largest_area()

  largest.no_hallway = true

  while quota > 0 do
    local A = pick_area_to_hall_up()

    if not A then break; end

    A.mode = "hallway"

    quota = quota - A.svolume
  end
end



function Weird_choose_area_kinds()

  local resolve_outdoor_prob


  local function kind_for_small_area(A)
    rand.shuffle(A.neighbors)

    each N in A.neighbors do
      if N.kind then
        A.kind = N.kind

        if A.mode != "hallway" then
          A.is_outdoor = N.is_outdoor
        end
        return true
      end
    end

    return false
  end


  local function OLD__pick_kind_for_area(A, prev)
    local tab = table.copy(KIND_TAB)

    -- small areas : prefer same as a neighbor
    if A.svolume < 8 then
      if kind_for_small_area(A) then return end

    else
    -- for large areas, choose different kind than previous one

      if A.svolume >= 8 and prev and prev.kind then
        tab[prev.kind] = nil
      end
    end

    A.kind = rand.key_by_probs(tab)

    if A.mode != "hallway" then
      if A.kind == "courtyard" or A.kind == "landscape" then
        A.is_outdoor = true
      end
    end
  end


  local function waterify_some_areas()
    local list = table.copy(LEVEL.areas)
    rand.shuffle(list)

    each A in list do
      if A.mode == "normal" and rand.odds(30) then
        if A.kind == "cave" or A.kind == "landscape" then
          A.mode = "water"
        end
      end
    end
  end


  local function starts_from_quota(seed_quota)
    local rough_size = 90 * rand.skew(1.0, 0.4)

    local num = rand.int(seed_quota / rough_size)

    return math.min(num, 1)
  end


  local function area_for_position(pos)
    local dx, dy = geom.delta(pos)

    local sx = 0.5 + dx * rand.sel(50, 0.25, 0.4)
    local sy = 0.5 + dy * rand.sel(50, 0.25, 0.4)

    if pos == 5 then
      sx = sx + rand.pick({ -0.1, 0, 0.1 })
      sy = sy + rand.pick({ -0.1, 0, 0.1 })
    end

    sx = int(sx * SEED_W)
    sy = int(sy * SEED_H)

    assert(Seed_valid(sx, sy))

    local S = SEEDS[sx][sy]
    assert(S)

    if S.top and rand.odds(50) then
      S = S.top
    end

    -- for this, void and hallways are OK
    return assert(S.area)
  end


  local function already_set(A, what)
    if what == "outdoor" then return A.is_outdoor end
    if what == "cave"    then return A.is_cave end

    error("internal error: unknown area what: " .. tostring(what))
  end


  local function set_area(L, A, what)
    if what == "outdoor" then A.is_outdoor = true end
    if what == "cave"    then A.is_cave    = true end

    table.insert(L.areas, A)

    L.quota = L.quota - A.svolume
  end


  local function set_area_or_room(L, A, what)
    if A.room then
      each B in A.room.areas do
        set_area(L, B, what)
      end

    else
      set_area(L, A, what)
    end
  end


  local function pick_area(L, what)
    -- collect possible neighbors
    local poss = {}

    each A in L.areas do
      each N in A.neighbors do
        if not already_set(N, what) then
          -- could use 'add_unique' here, but this favors common neighbors
          -- (which should make these groups more "clumpy" -- what we want)
          table.insert(poss, N)
        end
      end
    end

    -- poss may be empty (returns nil)
    return rand.pick(poss)
  end


  local function spread_kind(what, start_num, seed_quota)
gui.printf("spread_kind '%s' : starts=%d  quota=%d\n", what, start_num, seed_quota)
    if start_num  < 1 then return end
    if seed_quota < 1 then return end


    local list = {}

    local POSITIONS =
    {
      [5] = 50,
      [1] = 70, [3] = 70, [7] = 70, [9] = 70,
      [2] = 10, [4] = 10, [6] = 10, [8] = 10
    }

    for i = 1, start_num do
      local quota = seed_quota / start_num
      quota = quota * rand.skew(1.0, 0.5)

      list[i] = { quota=quota, areas={} }

      -- pick start area
      local pos = rand.key_by_probs(POSITIONS)
      POSITIONS[pos] = nil

      local A = area_for_position(pos)
      assert(A)

      set_area_or_room(list[i], A, what)
    end


    -- spread stuff round-robin until quotas are reached

    for loop = 1, 999 do
      if table.empty(list) then
        break;
      end

      for i = #list, 1, -1 do
        local L = list[i]

        if L.quota < 1 then
          table.remove(list, i)
          continue
        end

        local A = pick_area(L, what)

        -- nothing possible
        if not A then
          L.quota = -1
          continue
        end

        set_area_or_room(L, A, what)
      end
    end
  end


  local function resolve_conflicts()
    each R in LEVEL.rooms do
      local A1 = R.areas[1]

      if A1.is_outdoor and A1.is_cave then
        if rand.odds(resolve_outdoor_prob) then
          each A in R.areas do A.is_cave = nil end
        else
          each A in R.areas do A.is_outdoor = nil end
        end
      end
    end

    -- for scenic areas, cave always overrides
    -- [ seems better than having a messy mixture of the two ]

    each A in LEVEL.areas do
      if A.is_outdoor and A.is_cave then
        A.is_outdoor = nil
      end
    end
  end


  local function convert_to_proper_kinds()
    -- converts 'is_outdoor' / 'is_cave' fields to a kind value

    each A in LEVEL.areas do
      if A.is_cave then
        A.kind = "cave"
      elseif A.is_outdoor then
        A.kind = rand.sel(50, "landscape", "courtyard")
      else
        A.kind = "building"
      end
    end
  end


  ---| Weird_choose_area_kinds |---

  local total_seeds = SEED_W * SEED_H

  local out_quota = style_sel("outdoors", 0, 6, 30, 70)
  local cav_quota = style_sel("cave",     0, 6, 30, 70)

  -- if rooms become both cave + outdoor, use this chance to pick one
  resolve_outdoor_prob = 50
  if out_quota < cav_quota then resolve_outdoor_prob = 25 end
  if out_quota > cav_quota then resolve_outdoor_prob = 75 end

  out_quota = total_seeds * out_quota / 100
  cav_quota = total_seeds * cav_quota / 125  -- a bit less

  local out_starts = starts_from_quota(out_quota)
  local cav_starts = starts_from_quota(cav_quota)

  if rand.odds(65) then
    out_starts = out_starts + 1
  end

  spread_kind("outdoor", out_starts, out_quota)
  spread_kind("cave",    cav_starts, cav_quota)

  resolve_conflicts()
  convert_to_proper_kinds()

--???  fixup_small_areas()

---  waterify_some_areas()
end


------------------------------------------------------------------------


function Weird_floor_heights()

  local function fix_up_seeds(A)
    each S in A.half_seeds do
      S.floor_h = A.floor_h
    end
  end


  local function pick_delta_h(min_d, max_d, up_chance)
    if rand.odds(up_chance) then
      return max_d + 24
    else
      return min_d - 24
    end
  end


  local function area_assign_delta(A, up_chance)
    local min_d, max_d

    each N in A.neighbors do
      if N.room == A.room and N.delta_h then
        min_d = math.min(N.delta_h, min_d or  9999)
        max_d = math.max(N.delta_h, max_d or -9999)
      end
    end

    if not min_d then
      A.delta_h = 0
    else
      A.delta_h = pick_delta_h(min_d, max_d, up_chance)
    end

    each N in A.neighbors do
      if N.room == A.room and not N.delta_h then
        area_assign_delta(N, up_chance)
      end
    end
  end


  local function process_room(R, entry_h, entry_area)
    local start_area = rand.pick(R.areas)

    local up_chance = rand.pick({ 10, 50, 90 })

    -- recursively flow delta heights from a random starting area
    -- TODO : remember the "path" through the areas
    area_assign_delta(start_area, up_chance)

    local adjust_h = 0
    if entry_area then adjust_h = entry_area.delta_h end

    each A in R.areas do
      -- check each area got a delta_h
      assert(A.delta_h)

      A.floor_h = entry_h + A.delta_h - adjust_h

      fix_up_seeds(A)
    end
  end


  local function visit_room(R, entry_h, entry_area)
    if entry_area then
      assert(entry_area.room == R)
    end

    if not entry_h then
      entry_h = rand.irange(0, 4) * 64
    end

    process_room(R, entry_h, entry_area)

    -- recurse to neighbors
    each C in R.conns do
      if C.R1 == R then
        assert(C.A1)
        assert(C.A1.room == R)
        assert(C.A1.floor_h)

        local next_f = C.A1.floor_h
        if not C.is_door then
          next_f = next_f - 8
        end

        visit_room(C.R2, next_f, C.A2)
      end
    end
  end


  ---| Weird_floor_heights |---

  visit_room(LEVEL.start_room)
end



function Room_update_sky_groups()
  each A in LEVEL.areas do
    if A.floor_h and A.sky_group then
      local sky_h = A.floor_h + A.sky_group.add_h

      A.sky_group.h = math.max(sky_h, A.sky_group.h or 0)
    end
  end

  each A in LEVEL.areas do
    if A.floor_h and A.sky_group then
      A.ceil_h = A.sky_group.h
    end
  end
end


------------------------------------------------------------------------



function Weird_build_rooms()
  
  gui.printf("\n---=====  Build WEIRD rooms =====---\n\n")

  Room_reckon_doors()

  Weird_floor_heights()

  Layout_outer_borders()

  Room_create_sky_groups()

  each R in LEVEL.rooms do
    Layout_place_importants(R)
  end

  Room_update_sky_groups()

  Render_all_areas()
  Render_importants()

  Room_determine_spots()
end

