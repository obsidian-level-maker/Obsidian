------------------------------------------------------------------------
--  ROOM MANAGEMENT
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2015 Andrew Apted
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


--class ROOM
--[[
    kind : keyword  -- "normal" (layoutable room, can place items)
                    -- "hallway", "stairwell"
                    -- "scenic" (unvisitable room)

    is_outdoor : bool  -- true for outdoor rooms / caves

    is_cave    : bool  -- true for caves (indoor or outdoor)


    areas = list(AREA)

    seeds = list(SEED)

    sx1, sy1, sx2, sy2  -- \ Seed range
    sw, sh, svolume     -- /


    conns = list(CONNS)   -- connections to other rooms

    quest : QUEST

    zone : ZONE


    hallway : HALLWAY_INFO   -- for hallways only

    symmetry : keyword   -- symmetry of room, or NIL
                         -- keywords are "x", "y", "xy"

    floor_mats[z] : name
     ceil_mats[z] : name
--]]


--class HALLWAY_INFO
--[[
    height : number   -- space between floor and ceiling

--]]


--------------------------------------------------------------]]


ROOM_CLASS = {}

function ROOM_CLASS.new()
  local id = alloc_id("room")

  local R =
  {
    id = id
    kind = "UNSET"
    name = string.format("ROOM_%d", id)

    svolume = 0
    total_inner_points = 0
    prelim_conn_num = 0
    num_windows = 0

    areas = {}
    seeds = {}
    conns = {}

    sections = {}
    weapons = {}
    items = {}

    mon_spots  = {}
    item_spots = {}
    big_spots  = {}
    cage_spots = {}
    trap_spots = {}
    important_spots = {}   -- NOT USED ATM

    goals = {}
    importants = {}
    teleporters = {}
    floor_mats = {}
    ceil_mats = {}

    closets = {}
    chunks  = {}    -- NOT USED
    floors  = {}    -- NOT USED
    decor   = {}

    sky_rects = {}
    exclusions = {}
    neighbors = {}  -- USED???

    hazard_health = 0
  }

  table.set_class(R, ROOM_CLASS)
  table.insert(LEVEL.rooms, R)
  return R
end


function ROOM_CLASS.tostr(R)
  return assert(R.name)
end


function ROOM_CLASS.add_area(R, A)
  assert(R.kind != "DEAD")

  A.room = R
  A.is_outdoor = R.is_outdoor

  table.insert(R.areas, A)

  R.svolume = R.svolume + A.svolume
  R.total_inner_points = R.total_inner_points + #A.inner_points
end


function ROOM_CLASS.kill_it(R)
  gui.debugf("Killing %s\n", R.name)

  -- sanity check
  each C in LEVEL.conns do
    if (C.A1.room == R and C.A2.room != R) or
       (C.A2.room == R and C.A1.room != R)
    then
      error("Killed a connected room!")
    end
  end

  table.kill_elem(LEVEL.rooms, R)

  each A in R.areas do
    gui.debugf("   kill %s\n", A.name)
    A:kill_it()
  end

  R.areas = nil

  R.name = "DEAD_ROOM"
  R.kind = "DEAD"
  R.hallway = nil

  R.sx1   = nil
  R.areas = nil
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


---## function ROOM_CLASS.has_lock(R, lock)
---##   each C in R.conns do
---##     if C.lock == lock then return true end
---##   end
---##   return false
---## end


function ROOM_CLASS.has_any_lock(R)
  each C in R.conns do
    if C.lock then return true end
  end
  return false
end


---## function ROOM_CLASS.has_lock_kind(R, kind)
---##   each C in R.conns do
---##     if C.lock and C.lock.kind == kind then return true end
---##   end
---##   return false
---## end


function ROOM_CLASS.has_sky_neighbor(R)
  each C in R.conns do
    if C.A1.room == C.A2.room then continue end
    local N = C:other_room(A)
    if N.is_outdoor and N.mode != "void" then return true end
  end

  return false
end


function ROOM_CLASS.has_teleporter(R)
  each C in R.conns do
    if C.kind == "teleporter" then return true end
  end

  return false
end


function ROOM_CLASS.total_conns(R, ignore_secrets)
  local count = 0

  each C in R.conns do
    if ignore_secrets and C.kind == "secret" then
      continue
    end

    count = count + 1
  end

  return count
end


function ROOM_CLASS.is_unused_leaf(R)
  if R.kind == "hallway"   then return false end
  if R.kind == "stairwell" then return false end

  if R.is_secret  then return false end
  if R.is_start   then return false end

  if R:total_conns("ignore_secrets") >= 2 then return false end

  if #R.goals   > 0 then return false end
  if #R.weapons > 0 then return false end

  return true
end


function secret_entry_conn(R, skip_room)
  -- find entry connection for a potential secret room
  -- skip_room is usually NIL

  each C in R.conns do
    if C.A1.room != C.A2.room and
       C.A1.room != skip_room and
       C.A2.room != skip_room
    then
      return C
    end
  end

  error("Cannot find entry conn for secret room")
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


function Room_prepare_skies()
  --
  -- Each zone gets a rough sky height (dist from floors).
  -- The final sky height of each zone is determined later.
  --

  local function new_sky_add_h()
    if rand.odds(2)  then return 320 end

    return rand.pick({ 144, 160, 176, 192, 208 })
  end


  ---| Room_prepare_skies |---

  each Z in LEVEL.zones do
    Z.sky_add_h = new_sky_add_h()
  end
end



function Room_reckon_doors()

  local  indoor_prob = style_sel("doors", 0, 15, 35,  65)
  local outdoor_prob = style_sel("doors", 0, 70, 95, 100)

  local woody = rand.odds(25)


  local DEFAULT_PROBS = {}

  local function door_chance(R1, R2)  -- NOTE : NOT USED ATM
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

    local E = C.E1
    local F = C.F1  -- used for split conns, usually NIL

    if E.kind != "arch" then
      E = C.E2
      F = C.F2
    end

    assert(E.kind == "arch")

    if F then assert(F.kind == "arch") end


    -- locked door?
    if C.lock then
      E.kind = "lock_door"

      if F then F.kind = E.kind end

      C.is_door = true
      C.fresh_floor = true
      return
    end


    -- secret door ?
    if C.R1.is_secret != C.R2.is_secret then
      E.kind = "secret_door"

      if F then F.kind = E.kind end

      C.is_door = true

      -- mark the first seed so it can have the secret special
      -- FIXME C.S2.mark_secret = true
      return
    end


    -- stairwells do their own thing
    if C.R1.kind == "stairwell" or C.R2.kind == "stairwell" then
      E.kind = "nothing"
      assert(not F)
      return
    end


    -- special archways for caves FIXME
--[[
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
--]]


    -- don't need anything between two outdoor rooms
    -- TODO : allow the arch if have "walls" touching both corners
    if C.R1.is_outdoor and C.R2.is_outdoor then
      E.kind = "nothing"
      if F then F.kind = E.kind end
      return
    end


    -- temp hack for Heretic
    if THEME.no_doors then return end


    -- apply the random check
    local prob = indoor_prob
    if (C.R1.is_outdoor and C.R2.kind != "cave") or
       (C.R2.is_outdoor and C.R1.kind != "cave")
    then
      prob = outdoor_prob
    end

    if rand.odds(prob) then
      E.kind = "door"

      if F then F.kind = E.kind end

      C.is_door = true
      C.fresh_floor = rand.odds(30)
      return
    end


--[[  FIXME
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
--]]


    -- keep the current ARCH
    return
  end


  ---| Room_reckon_doors |---

  each C in LEVEL.conns do
    visit_conn(C)
  end
end



function Room_detect_porches(R)
  --
  -- A "porch" is typically an area of an outdoor room that neighbors a
  -- building and will be given a solid low ceiling and some pillars to
  -- hold it up, and a floor higher than any nearby areas of the room.
  --
  -- It can also be used indoors (what previous code called a "periph").
  --
  -- Another use case is an outdoor hallway which is mostly surrounded
  -- by outdoor areas, and is higher than those areas.
  --

  local best_A
  local best_score


  local function set_as_porch(A)
    A.is_porch = true

    -- Note : keeping 'is_outdoor' on the area
  end


  local function detect_hallway_porch()
    -- keep it simple, ignore merged hallways
    if #R.areas > 1 then return false end

    local HA = R.areas[1]

    each edge in HA.edge_loops[1] do
      local N = edge.S:neighbor(edge.dir)

      if not (N and N.area) then return false end

      local A2 = N.area

      if A2.mode == "scenic" then
        -- ok
        continue
      end

      local R2 = A2.room
      assert(R2 != R)

      if not R2 then
        -- no void, thanks
        return false
      end

      -- same zone?
      if R2.zone != R.zone then
        -- ok
        continue
      end

      -- TODO : if hallway is large, allow a few edges
      if not R2.is_outdoor then
         return false
      end

      -- floor check
      if HA.floor_h + 64 < (A2.floor_h or 0) then
        return false
      end
    end

    gui.debugf("Hallway %s is now a PORCH\n", R.name)

    set_as_porch(HA)

    return true
  end


  local function eval_porch(A, mode)
    -- mode is either "indoor" or "outdoor"

    if A.pool_hack then return -1 end

    -- size check : never too much of room
    if A.svolume > R.svolume / 2 then return -1 end

    -- shape check : we want high twistiness, low openness
    if A.openness > 0.3 then return -1 end

    -- should not be surrounded by another area
    if #A.neighbors < 2 then return -1 end

    -- FIXME.....

    local score = 100 + A.svolume - A.openness * 100

    -- tie break
    return score + gui.random()
  end


  local function detect_normal_porch(mode)
    -- only one per room, so pick best
    best_A = nil
    best_score = 0

    each A in R.areas do
      local score = eval_porch(A, "indoor")

      if score > best_score then
        best_A = A
        best_score = score
      end
    end

    if best_A then
      set_as_porch(best_A)

      gui.debugf("Made %s into a PORCH\n", best_A.name)
    end
  end


  ---| Room_detect_porches |---

  local prob = style_sel("porches", 0, 25, 50, 75)

  if not rand.odds(prob) then
    return
  end

  if R.kind == "stairwell" then
    -- never

---??  elseif R.kind == "hallway" then
---??    detect_hallway_porch()

  elseif R.is_outdoor then
    detect_normal_porch("outdoor")

  else
    detect_normal_porch("indoor")
  end
end



function simple_wall_mat(A)
  if A.room and not A.room.is_outdoor then
    return assert(A.room.main_tex)
  end

  return assert(A.zone.facade_mat)
end


function simple_wall_edge(A)
  return
  {
    kind = "wall"
    wall_mat = simple_wall_mat(A)
    area = A
  }
end


function simple_fence_edge(A, top_z)
  return
  {
    kind = "fence"
    fence_mat = assert(A.zone.fence_mat)
    fence_top_z = top_z
    area = A
  }
end


function simple_steps_edge(A, A2)
  return
  {
    kind = "steps"
    steps_mat = assert(A.zone.steps_mat)
    steps_z1 = math.min(A.floor_h, A2.floor_h)
    steps_z2 = math.max(A.floor_h, A2.floor_h)
  }
end


function Junction_make_wall(junc)
  junc.E1 = simple_wall_edge(junc.A1)
  junc.E2 = simple_wall_edge(junc.A2)
end


function Junction_make_trap_wall(junc, trap_A)
stderrf("***** Junction_make_trap_wall....\n")
  junc.E1 =
  {
    kind = "trap_wall"
    trigger = assert(trap_A.trap_trigger)
  }

  junc.E2 =
  {
    kind = "nothing"
  }

  if junc.A1.mode == "trap" then
    junc.E1, junc.E2 = junc.E2, junc.E1
  end

  junc.E1.area = junc.A1
  junc.E2.area = junc.A2
end


function Junction_make_fence(junc)
  local top_z = math.max(junc.A1.floor_h, junc.A2.floor_h)

  if junc.A1.pool_hack or junc.A2.pool_hack then
    top_z = top_z + 16
  end

  if junc.A1.room then top_z = math.max(top_z, junc.A1.room.max_floor_h) end
  if junc.A2.room then top_z = math.max(top_z, junc.A2.room.max_floor_h) end

  top_z = top_z + PARAM.jump_height + 8

  junc.E1 = simple_fence_edge(junc.A1, top_z)
  junc.E2 = { kind="nothing", area=junc.A2 }

  junc.E1.peer = junc.E2
  junc.E2.peer = junc.E1
end


function Junction_make_window(junc)
  junc.E1 =
  {
    kind = "window"
    area = junc.A1
    window_z = math.max(junc.A1.floor_h, junc.A2.floor_h)
  }

  junc.E2 =
  {
    kind = "nothing"
    area = junc.A2
  }

  junc.E1.peer = junc.E2
  junc.E2.peer = junc.E1
end


function Junction_make_steps(junc)
  assert(not junc.E1)
  assert(not junc.E2)

  junc.E1 = simple_steps_edge(junc.A1, junc.A2)
  junc.E2 = { kind="nothing" }

  -- ensure edge is on the correct side (the lowest one)
  if junc.A1.floor_h > junc.A2.floor_h then
    junc.E1, junc.E2 = junc.E2, junc.E1
  end

  junc.E1.area = junc.A1
  junc.E2.area = junc.A2
end



function Room_border_up()

  local function area_can_window(A)
    if not A.room then return false end
    if not A.floor_h then return false end

    if A.room.kind == "stairwell" then return false end
--- if A.room.kind == "hallway"   then return false end

    return true
  end


  local function check_window_heights(A1, A2)
    local c1 = A1.ceil_h
    local c2 = A2.ceil_h

    if not c1 or (A1.is_outdoor and not A1.is_porch) then c1 = 9999 end
    if not c2 or (A2.is_outdoor and not A2.is_porch) then c2 = 9999 end

    local max_f = math.max(A1.floor_h, A2.floor_h)
    local min_c = math.min(c1, c2)

    return (min_c - max_f) >= 128
  end


  local function visit_junction(junc)
    local A1 = junc.A1
    local A2 = junc.A2

    assert(A1 != A2)


    -- handle edge of map
    -- [ normal rooms should not touch the edge ]

    if A2 == "map_edge" then
      if A1.room or A1.mode == "cage" or A1.mode == "trap" or A1.mode == "pool" then
        junc.E1 = simple_wall_edge(A1)
        junc.E2 = nil
      end

      return
    end


    -- zones : gotta keep 'em separated

    if A1.zone != A2.zone then
      Junction_make_wall(junc)
      return
    end


    -- already decided?  [ outdoor borders ]
    if junc.keep_empty then return end
    if junc.E1 then return end


    if A2.room and not A1.room then
      A1, A2 = A2, A1
    end


    -- void --

    if A1.mode == "void" or A2.mode == "void" then
      Junction_make_wall(junc)
      return
    end


    -- scenic to scenic --

    if not A1.room then
      -- nothing needed if both building or both outdoor
      if A1.is_outdoor == A2.is_outdoor then return end

      Junction_make_wall(junc)
      return
    end


    -- room to trap / cage --
    if A2.mode == "trap" then
      Junction_make_trap_wall(junc, A2)
      return
    end

    if A2.mode == "cage" then
      -- FIXME
      return
    end


    -- room to scenic --
    if not A2.room then
      -- TODO Sometimes make windows?  [ probably do elsewhere... ]
      Junction_make_wall(junc)
      return
    end


    -- inside a single room --
    if A1.room == A2.room then
      return
    end


    -- blended hallways --  [ NOTE: NOT USED ATM ]

    if A1.mode == "hallway" and
       A1.room.hallway.parent and
       A1.room.hallway.parent == A2.room
    then
      junc.keep_empty = true
      return
    end

    if A2.mode == "hallway" and
       A2.room.hallway.parent and
       A2.room.hallway.parent == A1.room
    then
      junc.keep_empty = true
      return
    end


    -- outdoor to outdoor
    if A1.is_outdoor and A2.is_outdoor then
      Junction_make_fence(junc)

      if A1.is_porch or A2.is_porch then
--??????  junc.kind2 = "pillar"
      end

      return
    end


    -- window test [ make A1 be the indoor room ]

    local w_in_prob  = style_sel("windows", 0, 10, 20, 50)
    local w_out_prob = style_sel("windows", 0, 20, 50, 80)

    if A1.is_outdoor and not A2.is_outdoor then
       A1, A2 = A2, A1
    end

    if not A1.is_outdoor and
       area_can_window(A1) and
       area_can_window(A2) and
       rand.odds(sel(A2.is_outdoor, w_out_prob, w_in_prob)) and
       check_window_heights(A1, A2)
    then
      Junction_make_window(junc)
      return
    end


    -- when in doubt, block it out!

    Junction_make_wall(junc)
  end


  ---| Room_border_up |---

  each _,junc in LEVEL.area_junctions do
    visit_junction(junc)
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

  -- TODO : move this into Fab_process_spots()

  each spot in list do
    seen[spot.kind] = 1

    if spot.kind == "cage" then
      table.insert(R.cage_spots, spot)
    elseif spot.kind == "trap" then
      table.insert(R.trap_spots, spot)
    elseif spot.kind == "pickup" or spot.kind == "big_item" then
      table.insert(R.item_spots, spot)
    elseif spot.kind == "important" then
      table.insert(R.important_spots, spot)
    else
      table.insert(R.mon_spots, spot)
    end
  end

  -- FIXME : do this ONCE (perhaps in item.lua) !!!

  -- 1. when no big item spots, convert important spots
  -- 2. when no small item spots, convert monster spots

  each spot in list do

    if not seen["big_item"] and spot.kind == "important" then
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


  local function spots_for_area(R, A, mode)
    -- the 'mode' is normally NIL, can also be "cage" or "trap"

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

--  stderrf("mon_spots @ %s floor:%d : %d\n", R.name, f_h, #mon_spots)

    -- this is mainly for traps
    if A.mon_focus then
      each spot in mon_spots do
        spot.face = A.mon_focus
      end
    end

    if mode == "cage" then
      table.append(R.cage_spots, mon_spots)

    elseif mode == "trap" then
      table.append(R.trap_spots, mon_spots)
      table.append(R.item_spots, item_spots)

    else
      table.append(R.mon_spots,  mon_spots)
      table.append(R.item_spots, item_spots)
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

  -- handle cages and traps

  each A in LEVEL.areas do
    if A.mode == "cage" or A.mode == "trap" then
      local R = assert(A.face_room)
      spots_for_area(R, A, A.mode)
    end
  end
end


------------------------------------------------------------------------


function walkable_svolume()
  local vol = 0

  each A in LEVEL.areas do
    -- in CTF mode, don't count the mirrored parts
    if A.brother then continue end

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



STAIRWELL_SHAPES =
{
  --
  -- each shape is a list of directions
  -- direction has 10 added for the entry/exit of the stairwell (20 for DOUBLE width)
  -- we only store a single rotation [ don't need to mirror either ]
  --
  -- fallback shapes are ones which don't make good use of the space
  -- [ we auto-detect 1x1 curve and 1x2 straight fallbacks ]
  --
  -- scx,scy and lcx,lcy are coordinates to override control points
  -- (on "short" and "long" side, respectively).  the four lines which
  -- join the bezier start/end points form the coordinate space.
  --

  -- single seed
  A1 = { dirs={ 12,  6, 18,  4 }, steps=4, straight=1 }
  A2 = { dirs={ 12, 16,  8,  4 }, steps=4 }

  -- two seeds
  B1 = { dirs={ 12, 6, 6, 18, 4, 4 }, steps=6, straight=1 }
  B2 = { dirs={ 22, 6, 28, 4 }, steps=4, straight=1 }

  -- 2x2 box
  C1 = { dirs={ 12, 2, 6, 16, 8, 8,  4, 4 }, steps=6 }

  C2 = { dirs={ 22,  6, 6, 28, 4, 4 }, steps=6, straight=1 }
  C3 = { dirs={ 22, 26, 8,  8, 4, 4 }, steps=6 }

  C4 = { dirs={ 22, 6, 16, 8, 8,  4, 4 }, steps=6 }  -- fat to thin

  -- diamond box
  D1 = { dirs={ 11,  3, 19,  7 }, steps=6, straight=1 }
  D2 = { dirs={ 11, 13,  9,  7 }, steps=4 }

  -- other 2x2 seed shapes

  E1 = { dirs={  1, 12,  6,  9, 17 }, steps=6, scx=0.4, scy=0.5 }
  E2 = { dirs={ 11,  2,  6, 19,  7 }, steps=4, fallback=1, straight=1 }
  E3 = { dirs={ 11,  2,  6,  9, 17 }, steps=4 }

  F1 = { dirs={  1, 12, 6,  9, 8, 14 }, steps=6 }
  F2 = { dirs={ 11,  2, 6, 19, 8,  4 }, steps=4, fallback=1, straight=1 }

  G1 = { dirs={ 12,  2, 6, 19,  7, 4 }, steps=6, scx=0.4, scy=0.5 }
  G2 = { dirs={ 22, 6, 19, 7, 4 }, steps=6 } -- fat to thin

  H1 = { dirs={ 12,  2,  6, 19,  8,  4,  4 }, steps=6 }
  H2 = { dirs={  2,  2, 16,  9, 18,  4,  4 }, steps=6 }
  H3 = { dirs={  2, 12,  6,  9,  8, 14,  4 }, steps=6 }

  H4 = { dirs={ 22, 6, 19, 8, 4, 4 }, steps=6 }  -- fat to thin
  H5 = { dirs={ 2, 2, 6, 19, 8, 24 }, steps=6 }  --

  -- larger (2x3 and 3x3) shapes

  I1 = { dirs={ 1, 2, 2, 16, 8, 9, 17 }, steps=6, scx=0.85, scy=0.35 }
  I2 = { dirs={ 11, 2, 2, 6, 8, 19, 7 }, steps=4, fallback=1, straight=1 }
  I3 = { dirs={ 1, 12, 2, 6, 8, 9, 17 }, steps=6, fallback=1 }
  I4 = { dirs={ 11, 2, 2, 6, 8, 9, 17 }, steps=6, fallback=1 }

  J1 = { dirs={ 1, 2, 2, 16, 8, 9, 18, 4 }, steps=6, scx=1.6, scy=0.5 }
  J2 = { dirs={ 11, 2, 2, 6, 8, 19, 8, 4 }, steps=4, fallback=1, straight=1 }
  J3 = { dirs={ 1, 12, 2, 6, 8, 9, 8, 14 }, steps=6, fallback=1 }

  K1 = { dirs={ 1, 2, 2, 16, 9, 8, 18, 4 }, steps=6 }
  K2 = { dirs={ 1, 22, 6, 9, 8, 8, 14 },    steps=6 }
  K3 = { dirs={ 11, 2, 2, 6, 19, 8, 8, 4 }, steps=6, straight=1 }

  K4 = { dirs={ 1, 12, 2, 6, 9, 8, 8, 14 }, steps=6, fallback=1 }
  K5 = { dirs={ 1, 12, 2, 6, 19, 8, 8, 4 }, steps=6, fallback=1 }

  -- any larger shapes are very rare (not worth supporting)
}


function Test_stairwell_shapes()
  --
  -- check all the shapes are actually closed and have two exits
  --

  local function test_shape(name, shape)
    local px = 9
    local py = 9

    local exits = {}

    each dir in shape.dirs do
      local is_wide = (dir >= 20)
      local is_exit = (dir >= 10)

      local d2 = dir % 10

      if d2 == 0 or d2 == 5 or dir >= 30 then
        error("Bad direction in shape " .. name)
      end

      if is_exit then
        table.insert(exits, d2)
      end

      local dx, dy = geom.delta(geom.LEFT[d2])

      if is_wide then
        dx = dx * 2
        dy = dy * 2
      end

      px = px + dx
      py = py + dy
    end

    -- check final position

    if px != 9 or py != 9 then
      error("Unclosed shape : " .. name)
    end

    -- check exits

    if #exits != 2 then
      error("Bad exits in shape " .. name)
    end

    if exits[1] == exits[2] then
      error("180 degree found in shape " .. name)
    end

    -- OK --
  end


  each name,shape in STAIRWELL_SHAPES do
    if not shape.dirs then
      error("Missing dirs in shape " .. name)
    end

    test_shape(name, shape)
  end
end



function calc_cave_section(sx, sy)
  local cx = 2
  local cy = 2

  if sx <= LEVEL.cave_grid_sx1 then cx = 1 end
  if sx >= LEVEL.cave_grid_sx2 then cx = 3 end

  if sy <= LEVEL.cave_grid_sy1 then cx = 1 end
  if sy >= LEVEL.cave_grid_sy2 then cy = 3 end

  return cx, cy
end


function touches_cave_section(sx1, sy1, sx2, sy2)
  local cx1, cy1 = calc_cave_section(sx1, sy1)
  local cx2, cy2 = calc_cave_section(sx2, sy2)

  for x = cx1, cx2 do
  for y = cy1, cy2 do
    if LEVEL.cave_grid[x][y] then return true end
  end
  end

  return false
end



function Room_set_kind(R, kind, is_outdoor, is_cave)
  R.kind = kind

  if kind == "hallway" then
    R.name = string.format("HALLWAY_%d", R.id)
    R.hallway = R.hallway or {}
  end

  R.is_outdoor = is_outdoor
  R.is_cave    = is_cave

  each A in R.areas do
    A.mode = "room"
    A.is_outdoor = R.is_outdoor
  end
end



function Room_choose_kind(P, last_R)
  if last_R and last_R.kind == "hallway" then
    last_R = last_R.grow_parent
  end

  -- these outdoor probs carefully chosen so that:
  --    few   is about 18%
  --    some  is about 35%
  --    heaps is about 75%
  local out_prob

  if not last_R then
    out_prob = style_sel("outdoors", 0, 18, 35, 75)
  elseif last_R.is_outdoor then
    out_prob = style_sel("outdoors", 0, 10, 25, 70)
  else
    out_prob = style_sel("outdoors", 0, 20, 40, 90)
  end

  local is_outdoor = rand.odds(out_prob)

  -- compute a bbox from the sprout (roughly where next room will be)
  -- and check it against cave grid
  local S = P.S

  local fx, fy = geom.nudge(S.sx, S.sy, P.dir, 4)
  local rx, ry = geom.nudge(S.sx, S.sy, geom.RIGHT[P.dir], P.long + 2)
  local lx, ly = geom.nudge(S.sx, S.sy, geom. LEFT[P.dir], 2)

  local sx1 = math.min(fx, lx, rx)
  local sy1 = math.min(fy, ly, ry)
  local sx2 = math.max(fx, lx, rx)
  local sy2 = math.max(fy, ly, ry)

  local is_cave = touches_cave_section(sx1, sy1, sx2, sy2)

  return is_outdoor, is_cave
end



function Room_create_cave_grid()
  --
  -- We divide the map into a large 3x3 grid.
  -- Each section is either "cavey" or non-cavey.
  -- Rooms which TOUCH a cavey section become actual caves.
  --

  local function set_a_cave_section()
    -- this try to avoid the middle section
    local COORDS = { 6, 1, 6 }

    for loop = 1,100 do
      local cx = rand.key_by_probs(COORDS)
      local cy = rand.key_by_probs(COORDS)

      if not LEVEL.cave_grid[cx][cy] then
        LEVEL.cave_grid[cx][cy] = true
        return
      end
    end
  end


  --| Room_create_cave_grid |--

  LEVEL.cave_grid_sx1 = int(SEED_W * 0.35)
  LEVEL.cave_grid_sx2 = int(SEED_W * 0.65)

  LEVEL.cave_grid_sy1 = int(SEED_H * 0.35)
  LEVEL.cave_grid_sy2 = int(SEED_H * 0.65)

  LEVEL.cave_grid = table.array_2D(3, 3)


  -- determine # of cells to become cavey

  local cave_skip  = style_sel("caves", 100, 50, 25, 0)

  if rand.odds(cave_skip) then
    gui.printf("Cave quota: skipped for level.\n")
    return
  end

  local cave_low   = style_sel("caves", 0, 1.2, 2.4, 4.4)
  local cave_high  = style_sel("caves", 0, 3.2, 4.8, 9.2)

  local cave_qty   = int(rand.range(cave_low, cave_high))

  gui.printf("Cave quota: %d sections (%d%% of map).\n", cave_qty, int(cave_qty * 100 / 9))

  for i = 1, cave_qty do
    set_a_cave_section()
  end
end


------------------------------------------------------------------------


function Room_floor_ceil_heights()

  -- the 'entry_h' field of rooms also serves as a "visited already" flag


  local function raw_set_floor(A, h)
    A.floor_h = h
  end


  local function set_floor(A, h)
    raw_set_floor(A, h)

    -- floor heights are mirrored in CTF mode
    local A2 = A.sister or A.brother

    if A2 then
      assert(not A2.floor_h)
      raw_set_floor(A2, h)
    end
  end


  local function set_ceil(A, h)
    A.ceil_h = h

    -- floor heights are mirrored in CTF mode
    local A2 = A.sister or A.brother

    if A2 then
      A2.ceil_h = h
    end
  end


  local function pick_delta_h(from_h, up_chance)
    local h = 12
    if rand.odds(33) then h = 24
      if rand.odds(75) then h = 40
        if rand.odds(33) then h = 64 end
      end
    end

    if STYLE.steepness == "rare" or STYLE.steepness == "few" then h = h / 2 end
    if STYLE.steepness == "more"  then h = h * 1.5 end
    if STYLE.steepness == "heaps" then h = h * 2.0 end

    -- limit it for now (due to lack of lifts)
    if h > 72 then h = 72 end

    if rand.odds(up_chance) then
      return from_h + h
    else
      return from_h - h
    end
  end


  local function areaconn_other(C, A)
    if C.A1 == A then return C.A2 end
    if C.A2 == A then return C.A1 end

    return nil
  end


  local function area_assign_delta(A, up_chance, cur_delta_h)

    A.delta_h = cur_delta_h

    each C in A.room.area_conns do
      local A2 = areaconn_other(C, A)
      
      -- not connected to this area?
      if not A2 then continue end

      assert(A2.room == A.room)

      if not A2.delta_h then
        area_assign_delta(A2, up_chance, pick_delta_h(cur_delta_h, up_chance))
      end
    end
  end


  local function fix_porch_delta(R)
    -- ensure any porch in the room is the highest area

    local step_h = rand.sel(50, 16, 32)

    if STYLE.steepness == "rare" or STYLE.steepness == "few" then
      step_h = step_h / 2
    end

    each A in R.areas do
      if A.is_porch then
        each N in A.neighbors do
          if N.room != R then continue end

          if N.delta_h then
            A.delta_h = math.max(A.delta_h, N.delta_h + step_h)
          end
        end
      end
    end
  end


  local function room_add_steps(R)
    each C in R.area_conns do
      local A1 = C.A1
      local A2 = C.A2

      -- ignore pools
      if A1.pool_hack or A2.pool_hack then continue end

      local diff = math.abs(A1.floor_h - A2.floor_h)
      if diff <= PARAM.jump_height then continue end

      -- FIXME : generally build single staircases (a la V6 and earlier)

      local junc = Junction_lookup(A1, A2)

      Junction_make_steps(junc)
    end
  end


  local function process_room_flat(R, entry_area)
    each A in R.areas do
      set_floor(A, R.entry_h)
    end
  end


  local function process_room(R, entry_area)
    if STYLE.steepness == "none" then
      process_room_flat(R, entry_area)
      return
    end

    local start_area = rand.pick(R.areas)

    local up_chance = rand.pick({ 10, 50, 90 })

    -- recursively flow delta heights from a random starting area
    local cur_delta_h = rand.irange(-4, 4) * 32

    area_assign_delta(start_area, up_chance, cur_delta_h)

    fix_porch_delta(R)

    local adjust_h = 0
    if entry_area then adjust_h = entry_area.delta_h end

    each A in R.areas do
      -- check each area got a delta_h
      assert(A.delta_h)

      set_floor(A, R.entry_h + A.delta_h - adjust_h)
    end

    room_add_steps(R)
  end


  local function categorize_hall_shape(S, enter_dir, leave_dir, z_dir, z_size)
    local info =
    {
      dir = enter_dir
      delta_h = sel(z_size == "big", 48, 24)

      z_dir = z_dir
      z_size = z_size
      z_offset = 0
    }

    if leave_dir == enter_dir then
      info.shape = "I"

    elseif leave_dir == geom.LEFT[enter_dir] then
      info.shape = "C"
      info.mirror = false

    elseif leave_dir == geom.RIGHT[enter_dir] then
      info.shape = "C"
      info.mirror = true

    else
      error("weird hallway dirs")
    end

    if z_dir < 0 then
      if info.shape == "I" then
        info.dir = 10 - info.dir
      else
        if info.mirror then
          info.dir = geom.LEFT[info.dir]
        else
          info.dir = geom.RIGHT[info.dir]
        end

        info.mirror = not info.mirror
      end

      info.z_offset = - info.delta_h
    end

    return info
  end


  -- not used/broken ATM
  local function flow_through_hallway(R, S, enter_dir, floor_h)

-- stderrf("flow_through_hallway @ %s : %s\n", S.name, R.name)

    table.insert(R.hallway.path, S)

    S.floor_h = floor_h
    S.hall_visited = true

    R.hallway.max_h = math.max(R.hallway.max_h, floor_h)
    R.hallway.min_h = math.min(R.hallway.min_h, floor_h)

    -- collect where we can go next + where can exit
    local next_dirs = {}
    local exit_dirs = {}

    local saw_fixed = false

    each dir in geom.ALL_DIRS do
      local N = S:neighbor(dir)

      if not (N and N.area) then continue end

      if N.area.room != R then
        if N.area.room == R.hallway.R1 then R.hallway.touch_R1 = R.hallway.touch_R1 + 1 end
        if N.area.room == R.hallway.R2 then R.hallway.touch_R2 = R.hallway.touch_R2 + 1 end

-- FIXME
--???        if S.border[dir].conn and not N.area.room.entry_h then
--???          table.insert(exit_dirs, dir)
--???        end
        continue
      end

      if N.not_path then continue end
      if N.hall_visited then continue end

      -- Note: this assume fixed diagonals never branch elsewhere
      if N.fixed_diagonal then
        if not N.floor_h then
          table.insert(R.hallway.path, N)  -- needed for ceilings
          N.floor_h = floor_h
          N.hall_visited = true
        end

        saw_fixed = true
        continue
      end

      table.insert(next_dirs, dir)
    end

    -- all done?
    local total = #next_dirs + #exit_dirs

    if total == 0 then
      return
    end

    -- branching?
    if total > 1 then
      R.hallway.branched = true

      each dir in next_dirs do
        flow_through_hallway(R, S:neighbor(dir), dir, floor_h)
      end

      return
    end

    -- a single direction --

    local dir = next_dirs[1] or exit_dirs[1]

    if not S.diagonal and not saw_fixed and not S:has_door_edge() then
      S.hall_piece = categorize_hall_shape(S, enter_dir, dir, R.hallway.z_dir, R.hallway.z_size)

      floor_h = floor_h + S.hall_piece.delta_h * S.hall_piece.z_dir

      R.hallway.max_h = math.max(R.hallway.max_h, floor_h)
      R.hallway.min_h = math.min(R.hallway.min_h, floor_h)
    end

    if #next_dirs > 0 then
      return flow_through_hallway(R, S:neighbor(dir), dir, floor_h)
    end
  end


  local function hallway_other_end(R, entry_R)
    -- if the hallway has multiple exits, then one is picked arbitrarily

    each C in R.conns do
      local R2 = sel(C.A1.room == R, C.A2.room, C.A1.room)

      if R2 != entry_R then return R2 end
    end

    error("hallway error : cannot find other end")
  end


  local function kill_hallway_arch(conn)
    -- fixme??
  end


  local function try_blend_hallway(R, which)
    -- which is either 1 or 2 (entry or exit)

    if R.hallway.no_blend then return end

    -- already blended?
    if R.hallway.parent then return end

    -- check height difference
    if R.hallway.max_h - R.hallway.min_h < 32 then return end

    -- random chance
    if not rand.odds(sel(which == 1, 75, 25)) then return end

    local parent  = sel(which == 1, R.hallway.R1, R.hallway.R2)
    local touches = sel(which == 1, R.hallway.touch_R1, R.hallway.touch_R2)

    -- different quest? (hence locked door)
    if R.quest != parent.quest then return end

    -- find the connection
    local conn

    each C in R.conns do
      if C.A1.room == parent or C.A2.room == parent then
        conn = C
      end
    end

    -- enough joinage?
    if touches < 3 then return end
    if (touches - 1) / #R.hallway.path < 0.48 then return end

    -- OK --

    assert(conn)

    R.hallway.parent = parent

    -- copy some parent properties, especially outdoors-ness
    R.is_outdoor = R.hallway.parent.is_outdoor

    each A in R.areas do
      A.is_outdoor = R.is_outdoor
    end

    kill_hallway_arch(conn)
  end


  local function do_hallway_ceiling(R)
    if R.is_outdoor then
      -- will be zone.sky_h

      -- FIXME: workaround for odd bug [ outdoors non-sync? ]
      R.areas[1].is_outdoor = true
      return
    end

    R.areas[1].ceil_h = R.areas[1].floor_h + R.hallway.height

    each S in R.hallway.path do
      if R.hallway.parent then
        S.ceil_h = R.areas[1].ceil_h
      else
        S.ceil_h = S.floor_h + R.hallway.height
      end
    end
  end


  local function process_RANDOM_hallway(R, conn)
    -- Note: this would be a problem if player starts could exist in a hallway
    assert(conn)

    R.hallway.max_h = R.entry_h
    R.hallway.min_h = R.entry_h

    local S, S_dir
    local from_A

    if conn.A1.room == R then
      S = conn.S1
      S_dir = 10 - conn.dir
      from_A = conn.A2
    else
      assert(conn.A2.room == R)
      S = conn.S2
      S_dir = conn.dir
      from_A = conn.A1
    end

    assert(S)
    assert(S_dir)

    R.hallway.height = 96

    R.hallway.path = {}

    R.hallway.R1 = from_A.room
    R.hallway.R2 = hallway_other_end(R, from_A.room)

    R.hallway.touch_R1 = 0
    R.hallway.touch_R2 = 0


    local flat_prob = sel(R.is_outdoor, 5, 20)

--??  if #R.areas > 1 or rand.odds(flat_prob) then
    if true then
      -- our flow logic cannot handle multiple areas [ which is not common ]
      -- hence these cases become a single flat hallway

      each A in R.areas do
        A.floor_h = R.entry_h

        if not A.is_outdoor then
          A.ceil_h = A.floor_h + R.hallway.height
        end
      end

      R.hallway.flat = true
      return
    end


    -- decide vertical direction and steepness

    R.hallway.z_dir  = rand.sel(R.zone.hall_up_prob, 1, -1)
    R.hallway.z_size = rand.sel(3, "big", "small")

    if R.hallway.z_size == "big" then
      -- steep stairs need a bit more headroom
      R.hallway.height = R.hallway.height + 24
    end


    flow_through_hallway(R, S, S_dir, R.entry_h)

    -- check all parts got a height
    each S in R.areas[1].seeds do
      if S.not_path then continue end
      assert(S.floor_h)
    end

    -- transfer heights to neighbors
    each C in R.conns do
      local N

      if C.A1.room == C.A2.room then continue end

      error("this is broken...")

      if C.A1.room == R then
        S = C.S1
        N = C.S2
      else
        assert(C.A2.room == R)
        S = C.S2
        N = C.S1
      end

      if not N.area.room.entry_h then
        local next_f = assert(S.floor_h)
        if S.hall_piece then next_f = next_f + S.hall_piece.delta_h * S.hall_piece.z_dir end
        N.area.room.next_f = next_f
      end
    end

    -- use highest floor for "the" floor_h (so that fences are high enough)
    set_floor(R.areas[1], R.hallway.max_h)

    -- check if can make hallway "blend" into one of connecting rooms
    try_blend_hallway(R, 1)
    try_blend_hallway(R, 2)

    -- set ceiling heights
    do_hallway_ceiling(R)
  end


  local function process_stairwell(R, prev_room)
    local A = R.areas[1]
    local well = A.is_stairwell

    local num_steps = well.info.steps

    local diff_h

    -- stairwells are never locked [ they are "downgraded" in quest code ]
    assert(not R:has_any_lock())

    do
      -- TODO : better logic to decide Z direction
      local z_dir = rand.sel(70, 1, -1)

      diff_h = rand.sel(50, 8, 12)
      if rand.odds(10) then diff_h = 16 end

      diff_h = diff_h * z_dir
    end

    -- with this logic, last step is same height as next room
    R.exit_h = R.entry_h + num_steps * diff_h

    A.floor_h = math.min(R.entry_h, R.exit_h)
    A.ceil_h  = A.floor_h + 192  -- dummy

    -- update the STAIRWELL information

    well.start_z    = R.entry_h
    well.num_steps  = num_steps
    well.diff_h     = diff_h

    assert(prev_room)

    if prev_room == well.room1 then
      -- OK
    elseif prev_room == well.room2 then
      well.edge1, well.edge2 = well.edge2, well.edge1
      well.wide1, well.wide2 = well.wide2, well.wide1
    else
      error("Bad stairwell (no match for prev_room)")
    end
  end


  local function maintain_material_across_conn(C)
    if C.kind != "normal" then return false end

    if C.A1.floor_h    != C.A2.floor_h then return false end
    if C.R1.is_outdoor != C.R2.is_outdoor then return false end

    if not (C.E1.kind == "nothing" or C.E1.kind == "arch") then return false end
    if not (C.E2.kind == "nothing" or C.E2.kind == "arch") then return false end

    return true
  end


  local function select_floor_mats(R, entry_conn)
    if not R.theme.floors then return end

    -- maintain floor material if same height and no door
    if entry_conn and maintain_material_across_conn(entry_conn) then
      local A1 = entry_conn.A1
      local A2 = entry_conn.A2

      if not A1.floor_mat then
        A1, A2 = A2, A1
      end

      assert(A1.floor_mat)
      assert(A1.floor_h)

      R.floor_mats[A1.floor_h] = A1.floor_mat
    end

    each A in R.areas do
      if A.pool_hack then continue end

      assert(A.floor_h)

      if not R.floor_mats[A.floor_h] then
        R.floor_mats[A.floor_h] = rand.key_by_probs(R.theme.floors)
      end

      A.floor_mat = assert(R.floor_mats[A.floor_h])
    end
  end


  local function select_ceiling_mats(R)
    -- outdoor room-themes do not specify ceiling materials
    if not R.theme.ceilings then
      return
    end

    each A in R.areas do
      if A.is_outdoor then continue end
      if A.is_porch   then continue end

      assert(A.ceil_h)

      if not R.ceil_mats[A.ceil_h] then
        R.ceil_mats[A.ceil_h] = rand.key_by_probs(R.theme.ceilings)
      end

      A.ceil_mat = assert(R.ceil_mats[A.ceil_h])
    end
  end


  local function visit_room(R, entry_h, entry_area, prev_room, via_conn)
    -- get peered room (for CTF mode)
    local R2 = R.sister or R.brother

    if entry_area then
      assert(entry_area.room == R)
    end

    -- handle start rooms and teleported-into rooms
    if not entry_h then
      entry_h = rand.irange(0, 4) * 64
    end

    R.entry_h = entry_h

    if via_conn then
      via_conn.door_h = entry_h
    end

    if R2 then
      R2.entry_h = entry_h
    end

    if not (R.kind == "hallway" or R.kind == "stairwell") then
      Room_detect_porches(R)
    end

    if R.kind == "stairwell" then
      process_stairwell(R, prev_room)
    elseif R.kind == "RANDOM_hallway" then  -- not used ATM
      process_RANDOM_hallway(R, via_conn, entry_h)
    else
      process_room(R, entry_area)
      select_floor_mats(R, via_conn)
    end

    -- recurse to neighbors
    each C in R.conns do
      if C.is_cycle then continue end

      local R2, A2, A1
      if C.R1 == R then R2 = C.R2 else R2 = C.R1 end
      if C.R1 == R then A2 = C.A2 else A2 = C.A1 end
      if C.R1 == R then A1 = C.A1 else A1 = C.A2 end

      -- already visited it?
      if R2.entry_h then continue end

      assert(A1.floor_h)

      local next_f = R.exit_h or A1.floor_h

      -- hallway crud (FIXME : HACKY)
      if R2.next_f then next_f = R2.next_f end

      visit_room(R2, next_f, A2, R, C)
    end
  end


  function fix_pool_hacks(R)
    local function pool_height(A)
      each N in A.neighbors do
        if N.room == R then
          return N.floor_h - 16
        end
      end
      error("fix_pool_hacks failed")
    end

    each A in R.areas do
      if A.pool_hack then
        A.floor_h = pool_height(A)
      end
    end
  end


  function calc_max_floor(R)
    R.max_floor_h = -7777

    each A in R.areas do
      if A.floor_h then
        R.max_floor_h = math.max(R.max_floor_h, A.floor_h)
      end
    end
  end


  function do_ceilings(R)
    each A in R.areas do
      local height = rand.pick({ 128, 192,192,192, 256,320 })

      if A.is_porch then
        height = 144
      end

      set_ceil(A, A.floor_h + height)
    end

    -- ensure enough vertical room for player to travel between areas
    local SPACE_Z = 80

    each C in R.area_conns do
      local min_c = math.max(C.A1.floor_h, C.A2.floor_h) + SPACE_Z

      if C.A1.ceil_h < min_c then set_ceil(C.A1, min_c) end
      if C.A2.ceil_h < min_c then set_ceil(C.A2, min_c) end
    end

    -- now pick textures
    select_ceiling_mats(R)
  end


  ---| Room_floor_ceil_heights |---

  -- give each zone a preferred hallway z_dir
  each Z in LEVEL.zones do
    Z.hall_up_prob = rand.sel(70, 80, 20)
  end

  local first = LEVEL.start_room or LEVEL.blue_base or LEVEL.rooms[1]

  -- recursively visit all rooms
  visit_room(first)

  each R in LEVEL.rooms do
    -- sanity check : all rooms were visited

--[[ "fubar" debug stuff
if not R.entry_h then
R.entry_h = -77
each A in R.areas do A.floor_h = R.entry_h end
end
--]]

    assert(R.entry_h)

    fix_pool_hacks(R)

    -- we do hallway porches when all heights are known
    if R.kind == "hallway" then
--???  Room_detect_porches(R)
    end

    do_ceilings(R)
    calc_max_floor(R)
  end
end



function Room_set_sky_heights()

  local function do_area(A)
    local sky_h = A.floor_h + A.zone.sky_add_h

    A.zone.sky_h = math.N_max(A.zone.sky_h, sky_h)

    if A.window_top_h then
      A.zone.sky_h = math.max(A.zone.sky_h, A.window_h)
    end

    if A.is_porch then
      A.zone.sky_h = math.max(A.zone.sky_h, A.ceil_h + 48)
    end
  end


  ---| Room_set_sky_heights |---

  each A in LEVEL.areas do
    -- visit all normal, outdoor areas
    if A.floor_h and A.is_outdoor and not A.is_boundary then
      do_area(A)

      -- include nearby buildings in same zone
      -- [ TODO : perhaps limit to where areas share a window or doorway ]
      each N in A.neighbors do
        if N.zone == A.zone and N.floor_h and not N.is_outdoor and not N.is_boundary then
          do_area(N)
        end
      end
    end
  end

  -- ensure every zone gets a sky_h
  each Z in LEVEL.zones do
    if not Z.sky_h then
      Z.sky_h = 0
      Z.no_outdoors = true
    end
  end

  -- transfer final results into areas

  each A in LEVEL.areas do
    if A.floor_h and A.is_outdoor and not A.is_porch then
      A.ceil_h = A.zone.sky_h
    end
  end
end



function Room_add_sun()
  -- game check
  if not GAME.ENTITIES["sun"] then return end

  local sun_r = 25000
  local sun_h = 40000

  -- nine lights in the sky, one is "the sun" and the rest provide
  -- ambient light (to keep outdoor areas from getting too dark).

  local dim = 4
  local bright = 40

  for i = 1,10 do
    local angle = i * 36 - 18

    local x = math.sin(angle * math.pi / 180.0) * sun_r
    local y = math.cos(angle * math.pi / 180.0) * sun_r

    local level = sel(i == 2, bright, dim)

    Trans.entity("sun", x, y, sun_h, { light=level })
  end

  Trans.entity("sun", 0, 0, sun_h, { light=dim })
end


function Room_pool_hacks()

  local function similar_room(A1, A2)
    local R1 = A1.room
    local R2 = A2.room

    if R1 == R2 then return true end

    return false
  end


  local function can_become_pool(A)
    if not A.room then return false end
    if A.is_porch then return false end

    -- room is too simple?
    if #A.room.areas < 2 then return false end

    -- too small?
    if A.svolume < 2 then return false end

    -- external connection?
    each C in A.room.conns do
      if C.A1 == A or C.A2 == A then return false end
    end

    -- check number of "roomy" neighbors
    local count = 0

    each N in A.neighbors do
      if N.room and similar_room(A, N) then
        count = count + 1
      end
    end

    return (count < 2)
  end

  ---| Room_pool_hacks |---

  if not LEVEL.liquid then return end

  local prob = style_sel("liquids", 0, 20, 40, 80);

  if prob == 0 then return end

  each A in LEVEL.areas do
    if not A.room then continue end

    if can_become_pool(A) and rand.odds(prob) then
      A.pool_hack = true
    end
  end
end


------------------------------------------------------------------------


function Room_build_all()

  gui.printf("\n---=====  Build Rooms =====---\n\n")

  Area_prune_hallways()

  Room_reckon_doors()

  Room_pool_hacks()
  Room_floor_ceil_heights()
  Room_prepare_skies()

  -- place importants -- done early as traps need to know where they are.
  -- it also sets LEVEL.player1_z -- needed for monster depots.
  each R in LEVEL.rooms do
    Layout_place_importants(R)
  end

  Layout_traps_and_cages()
  Layout_create_scenic_borders()
  Layout_liquid_stuff()
  Layout_update_cages()

  Room_border_up()
  Room_set_sky_heights()

  Layout_finish_scenic_borders()
  Layout_handle_corners()
  Layout_outdoor_shadows()

  Render_set_all_properties()

  Render_all_areas()
  Render_importants()

  Room_determine_spots()

  Room_add_sun()
  -- TODO intermission camera
end

