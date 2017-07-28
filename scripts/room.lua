------------------------------------------------------------------------
--  ROOM MANAGEMENT
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2017 Andrew Apted
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
    is_hallway : bool  -- true for hallways
    is_outdoor : bool  -- true for outdoor rooms

    is_cave    : bool  -- true for caves (indoors)
    is_park    : bool  -- true for parks (outdoors)


    areas = list(AREA)

    seeds = list(SEED)

    sx1, sy1, sx2, sy2  -- \ Seed range
    sw, sh, svolume     -- /

     size_limit   -- \  limits on ergonomic growth
    floor_limit   -- /


    conns : list(CONNS)   -- connections to other rooms

    quest : QUEST

    zone : ZONE

    peer : ROOM     -- links rooms created via symmetry


    goals    : list(GOAL)   -- what goals are here (e.g. keys)
    weapons  : list(NAME)   -- what weapons to place in this room
    items    : list(NAME)   -- what nice items to place
    closet_items : list     -- what items to use in secret closets


    floor_chunks : list(CHUNK)   -- chunks in a walkable area
     ceil_chunks : list(CHUNK)

    closets  : list(CHUNK)
    stairs   : list(CHUNK)
    joiners  : list(CHUNK)
    pieces   : list(CHUNK)  -- for hallways

    triggers : list(TRIGGER)  -- used for traps


    light_level : keyword    -- "bright", "normal", "dark" or "verydark"

    symmetry : SYMMETRY_INFO

    border : AREA

    gx1, gy1, gx2, gy2   -- seed range while growing

    floor_mats[z] : name
     ceil_mats[z] : name

    guard_chunk : CHUNK   -- what a bossy monster is guarding

    aversions : table[name] -> factor
--]]


--class SPOT
--[[
    x1, y1, x2, y2, z1, z2   -- coordinate range

    mx, my, mz   -- middle point

    kind : keyword    -- "monster", "item", "big_item"
                      -- FIXME : what else?

    where : keyword   -- "floor", "closet",
                      -- "cage", "trap",

    closet : CLOSET_INFO    -- only present for closets
--]]


--class TRIGGER
--[[
    kind : keyword    -- "edge" or "spot"

    edge   : EDGE     -- place trigger near this edge (of a door/joiner/closet)
    spot   : CHUNK    -- place trigger around this floor chunk (of an item/switch)

    action : number   -- the "special" to use
    tag    : number   -- the tag for the trap-doors
--]]


------------------------------------------------------------------------


ROOM_CLASS = {}

function ROOM_CLASS.new()
  local id = alloc_id("room")

  local R =
  {
    id = id
    name = string.format("ROOM_%d", id)

    svolume = 0
    total_inner_points = 0
    num_windows = 0
    need_teleports = 0

    areas = {}
    seeds = {}
    conns = {}
    internal_conns = {}
    temp_areas = {}

    goals = {}
    teleporters = {}
    weapons = {}
    items = {}
    closet_items = {}

    mon_spots  = {}
    item_spots = {}
    big_spots  = {}
    entry_spots = {}
    important_spots = {}   -- from prefabs

    floor_chunks  = {}
     ceil_chunks  = {}
    liquid_chunks = {}

    closets = {}
    stairs  = {}
    joiners = {}
    pieces  = {}

    cages = {}
    traps = {}
    triggers = {}
    aversions = {}

    used_chunks = 0  -- includes closets

    floor_mats = {}
     ceil_mats = {}

    floor_groups = {}
     ceil_groups = {}

    solid_ents = {}
    exclusions = {}
    avoid_mons = {}
    locked_fences = {}

    hazard_health = 0
  }

  table.set_class(R, ROOM_CLASS)
  table.insert(LEVEL.rooms, R)
  return R
end


function ROOM_CLASS.add_area(R, A)
  assert(not R.is_dead)

  A.room = R
  A.is_outdoor = R.is_outdoor

  table.insert(R.areas, A)

  R.svolume = R.svolume + A.svolume
  R.total_inner_points = R.total_inner_points + #A.inner_points
end


function ROOM_CLASS.get_env(R)
  if R.is_hallway then return "hallway" end

  if R.is_cave then return "cave" end
  if R.is_park then return "park" end

  if R.is_outdoor then return "outdoor" end

  return "building"
end


function ROOM_CLASS.rough_size(R)
  local count = 0

  each A in R.areas do
    count = count + #A.seeds
  end

  return count
end


function ROOM_CLASS.num_floors(R)
  local count = 0

  each A in R.areas do
    if A.mode == "floor" then
      count = count + 1
    end
  end

  return count
end


function ROOM_CLASS.kill_it(R)
  gui.debugf("Killing %s\n", R.name)
  assert(not R.is_dead)

  -- sanity check
  each C in LEVEL.conns do
    if (C.R1 == R) or (C.R2 == R) then
      error("Killed a connected room!")
    end
  end

  table.kill_elem(LEVEL.rooms, R)

  -- remove from the trunk object
  table.kill_elem(R.trunk.rooms, R)

  each A in R.areas do
    gui.debugf("   kill %s\n", A.name)
    A:kill_it()
  end

  R.name = "DEAD_" .. R.name
  R.is_dead = true

  R.areas = nil
  R.trunk = nil

  R.sx1   = nil
  R.areas = nil
end


function ROOM_CLASS.try_collect_seed(R, S)
  if not S.area then return end
  if S.area.room != R then return end

  S.room = R

  table.insert(R.seeds, S)

  -- update ROOM's bounding box

  R.sx1 = math.min(R.sx1 or  999, S.sx)
  R.sy1 = math.min(R.sy1 or  999, S.sy)
  R.sx2 = math.max(R.sx2 or -999, S.sx)
  R.sy2 = math.max(R.sy2 or -999, S.sy)
end


function ROOM_CLASS.collect_seeds(R)
  for sx = 1, SEED_W do
  for sy = 1, SEED_H do
    local S  = SEEDS[sx][sy]
    local S2 = S.top

    R:try_collect_seed(S)

    if S2 then R:try_collect_seed(S2) end
  end
  end

  if not R.sx1 then
    error("Room with no seeds!")
  end

  R.sw = R.sx2 - R.sx1 + 1
  R.sh = R.sy2 - R.sy1 + 1
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


function ROOM_CLASS.prelim_conn_num(R)
  local count = 0

  each PC in LEVEL.prelim_conns do
    if PC.R1 == R or PC.R2 == R then
      count = count + 1
    end
  end

  return count
end


function ROOM_CLASS.calc_walk_vol(R)
  local vol = 0

  each A in R.areas do
    if (A.mode == "floor" or A.mode == "nature") or
       (A.chunk and A.chunk.kind == "stair")
    then
      A:calc_volume()
      vol = vol + A.svolume
    end
  end

  -- this should not happen
  if vol < 1 then vol = 1 end

  return vol
end


function ROOM_CLASS.total_conns(R, ignore_secrets)
  local count = 0

  each C in R.conns do
    if ignore_secrets and C.is_secret then
      continue
    end

    count = count + 1
  end

  return count
end


function ROOM_CLASS.is_unused_leaf(R)
  if R.is_hallway then return false end
  if R.is_secret  then return false end
  if R.is_start   then return false end

  if R:total_conns("ignore_secrets") >= 2 then return false end

  if #R.goals   > 0 then return false end
  if #R.weapons > 0 then return false end

  return true
end


function ROOM_CLASS.hallway_other_conn(H, C1)
  -- if hallway only has one other connection, return it,
  -- otherwise return NIL.

  if #H.conns == 2 then
    if H.conns[1] == C1 then return H.conns[2] end
    if H.conns[2] == C1 then return H.conns[1] end
  end

  return nil
end


function ROOM_CLASS.secret_entry_conn(R, skip_room)
  -- find entry connection for a potential secret room.
  -- when skip_room is non-nil, ignore it.

  each C in R.conns do
    local R2 = C:other_room(R)

    if R2 == skip_room then continue end

    return C
  end

  error("Cannot find entry conn for secret room")
end


function ROOM_CLASS.add_entry_spot(R, spot)
  table.insert(R.entry_spots, spot)

  if not R.entry_coord then
    local mx = (spot.x1 + spot.x2) / 2
    local my = (spot.y1 + spot.y2) / 2

    R.entry_coord = { x=mx, y=my, z=spot.z1 + 40, angle=spot.angle }
  end
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


function ROOM_CLASS.usable_chunks(R)
  local num = #R.floor_chunks + #R.closets - R.used_chunks
  if num < 0 then num = 0 end
  return num
end


function ROOM_CLASS.add_solid_ent(R, id, x, y, z)
  -- the "id" can be a name or a number.
  -- for names, we can use the proper size and ignore passable ents.

  local info

  if type(id) != "number" then
    info = GAME.ENTITIES[id]
  end

  if not info then
    info = { r=32, h=96 }
  end

  if info.pass then return end

  local SOLID_ENT =
  {
    id = id

    x = x
    y = y
    z = z

    r = info.r
    h = info.h
  }

  table.insert(R.solid_ents, SOLID_ENT)
end


function ROOM_CLASS.spots_do_decor(R, floor_h)
  local low_h  = PARAM.spot_low_h
  local high_h = PARAM.spot_high_h

  each ent in R.solid_ents do
    local z1 = ent.z
    local z2 = ent.z + ent.h

    if z1 >= floor_h + high_h then continue end
    if z2 <= floor_h then continue end

    local content = SPOT_LEDGE
    if z1 >= floor_h + low_h then content = SPOT_LOW_CEIL end

    local x1, y1 = ent.x - ent.r, ent.y - ent.r
    local x2, y2 = ent.x + ent.r, ent.y + ent.r

    gui.spots_fill_box(x1, y1, x2, y2, content)
  end
end


function ROOM_CLASS.add_exclusion(R, kind, x1, y1, r, x2, y2)
  -- x2 and y2 are optional
  if x2 == nil then x2 = x1 end
  if y2 == nil then y2 = y1 end

  local area =
  {
    kind = kind

    x1 = x1 - r
    y1 = y1 - r
    x2 = x2 + r
    y2 = y2 + r
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
    if box.kind == "keep_empty" then
      R:clip_spots(box.x1, box.y1, box.x2, box.y2)
    end
  end
end


function ROOM_CLASS.usable_delta_h(R, from_h, h)
  if not rand.odds(R.delta_up_chance) then
    h = - h
  end

  if R.delta_limit_mode == "positive" then
    if from_h + h <= 0 then h = - h end
  else
    if from_h + h >= 0 then h = - h end
  end

  return from_h + h
end


function ROOM_CLASS.pick_direct_delta_h(R, from_h, A1, A2)
  if STYLE.steepness == "none" then
    return from_h
  end

  -- only change height if floor_groups are different
  if A1.floor_group and A1.floor_group == A2.floor_group then
    return from_h
  end

  local h = 8

  return R:usable_delta_h(from_h, h)
end


function ROOM_CLASS.pick_stair_delta_h(R, from_h, chunk)
  local h = chunk.prefab_def.delta_h
  assert(h)

  return R:usable_delta_h(from_h, h)
end


------------------------------------------------------------------------


function Room_prepare_skies()
  --
  -- Each zone gets a rough sky height (dist from floors).
  -- The final sky height of each zone is determined later.
  --

  local function new_sky_add_h()
    if rand.odds(2)  then return 256 end
    if rand.odds(10) then return 192 end

    return 144
  end


  ---| Room_prepare_skies |---

  each Z in LEVEL.zones do
    Z.sky_add_h = new_sky_add_h()
  end
end



function Room_reckon_door_tex()

  local function visit_conn(C, E1, E2)
    if E1 == nil then return end
    assert(E2)

    local A1 = assert(E1.area)
    local A2 = assert(E2.area)

    for pass = 1,2 do
      E1.wall_mat = Junction_calc_wall_tex(A1, A2)

      A1, A2 = A2, A1
      E1, E2 = E2, E1
    end
  end


  ---| Room_reckon_door_tex |---

  each C in LEVEL.conns do
    if C.kind == "edge" then
      visit_conn(C, C.E1, C.E2)
      visit_conn(C, C.F1, C.F2)
    end
  end
end



function Room_pick_joiner_prefab(C, chunk)
  -- Note: this also used for hallway terminators

  assert(chunk)

  local reqs = chunk:base_reqs(chunk.from_dir)

  reqs.kind  = C.kind
  reqs.shape = assert(chunk.shape)

  if C.kind == "joiner" then
    local A1 = chunk.from_area
    local A2 = chunk.dest_area

    reqs.env      = A1.room:get_env()
    reqs.neighbor = A2.room:get_env()

  elseif C.kind == "terminator" then
    reqs.group = assert(chunk.area.room.hall_group)
  end

  C:get_lock_reqs(reqs)

  chunk.prefab_def = Fab_pick(reqs)

  -- should we flip the joiner?
  -- [ hallway terminators are already ok, done in Connect_directly ]
  -- [[ only straight pieces can be flipped ]]

  if C.kind == "joiner" and chunk.shape == "I" then
    local flip_it

    -- we generally want the joiner to face the earlier room
    -- (i.e. travel direction is toward the later room).
    -- this is critical for some locked types of joiners.
    if C.R1.lev_along > C.R2.lev_along then
      flip_it = true
    end

    if chunk.prefab_def.can_flip and rand.odds(35) then
      flip_it = not flip_it
    end

    -- this is needed when the environment on each side is important,
    -- such as the joiner connecting a normal room to a cave.
    if chunk.prefab_def.force_flip != nil then
      flip_it = chunk.prefab_def.force_flip
    end

    if flip_it then
      -- this reverses from_dir and dest_dir, and adjusts the
      -- from_area and dest_area fields accordingly.
      chunk:flip()
    end
  end
end



function Room_pick_edge_prefab(C)

  local function make_fence(E)
    E.kind = "fence"
    E.fence_mat = assert(E.area.zone.fence_mat)

    -- fence_top_z computed later...
    table.insert(E.area.room.locked_fences, E)
  end


  -- hack for unfinished games
  if THEME.no_doors then return end


  local  indoor_prob = style_sel("doors", 0, 15, 35,  65)
  local outdoor_prob = style_sel("doors", 0, 70, 90, 100)

  local E = C.E1

  if E.kind != "doorway" then
    E = C.E2
  end

  assert(E.kind == "doorway")


  -- get orientation right, "front" of prefab faces earlier room

  local R1 = C.R1
  local R2 = C.R2

  if R1 != E.area.room then
    R1, R2 = R2, R1
  end

  if R1.lev_along > R2.lev_along then
    E.flip_it = true
  end


  -- requirements for the prefab

  local reqs =
  {
    kind = "arch"

    seed_w = assert(E.long)
  }

  local goal

  if geom.is_corner(E.dir) then
    reqs.where = "diagonal"
    reqs.seed_h = reqs.seed_w
  else
    reqs.where = "edge"
  end

  reqs.env      = R1:get_env()
  reqs.neighbor = R2:get_env()


  -- locked door?
  C:get_lock_reqs(reqs)

  if C.lock then
    reqs.kind = "door"

    goal = C.lock.goals[1]

    E.door_tag = goal.tag

    C.is_door = true
    C.fresh_floor = true

    -- use lowering bars between outdoor rooms (usually)
    if R1.is_outdoor and R2.is_outdoor and
       goal.kind == "LOCAL_SWITCH" and
       rand.odds(80+20)
    then
      reqs.kind = "fence"

      make_fence(E)
    end

  -- secret door ?
  elseif C.is_secret then
    reqs.kind = "door"

    C.is_door = true

    if R1.is_outdoor and R2.is_outdoor then
      reqs.kind = "fence"

      make_fence(E)
    end

  else
    -- make a normal door?
    local prob = indoor_prob

    if R1.is_outdoor or R2.is_outdoor then
      prob = outdoor_prob
    end

    if rand.odds(prob) then
      -- TODO : reqs.kind = "door"

      C.is_door = true
      C.fresh_floor = rand.odds(30)
    end
  end


  -- Ok, select it --

  E.prefab_def = Fab_pick(reqs)

  if goal then
    goal.action = E.prefab_def.door_action
  end
end



function Room_reckon_doors()
  each C in LEVEL.conns do
    if C.kind == "edge" then
      Room_pick_edge_prefab(C)

    elseif C.kind == "joiner" then
      Room_pick_joiner_prefab(C, C.joiner_chunk)
    end
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

    if A.mode != "floor" then return -1 end

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

-- FIXME : porches disabled due to blocking pillars
do return end

  local prob = style_sel("porches", 0, 25, 50, 75)

  if not rand.odds(prob) then
    return
  end

---??  if R.is_hallway then
---??    detect_hallway_porch()

  if R.is_outdoor then
    detect_normal_porch("outdoor")

  else
    detect_normal_porch("indoor")
  end
end



function Room_make_windows(A1, A2)

  local edge_list = {}
  local total_len = 0

  local WINDOW_PATTERNS =
  {
    "1", "2", "3", "22", "2-2", "33", "3-3"
  }

  if rand.odds(50) then
    WINDOW_PATTERNS[6] = "222"
  end


  local function area_can_window(A)
    if not A.room then return false end
    if not A.floor_h then return false end

    -- disable windows into caves [ for now... ]
    if A.room and A.room.is_cave then return false end

    if A.mode == "void" then return false end
    if A.chunk and A.chunk.kind != "floor" then return false end

    if A.room.is_hallway then return false end

    return true
  end


  local function decide_window_group()
    local R1 = A1.room
    local R2 = A2.room

    local group1 = A1.zone.window_group
    local group2 = A2.zone.window_group

    if group1 == nil then return group2 end
    if group2 == nil then return group1 end

    if R1.zone.along <= R2.zone.along then
      return group1
    else
      return group2
    end

--[[ OLD CRUD
    if sel(R1.is_outdoor, 1, 0) != sel(R2.is_outdoor, 1, 0) then
      if R1.is_outdoor then return group2 end
      if R2.is_outdoor then return group1 end
    end

    if R1.svolume >= R2.svolume then
      return group1
    else
      return group2
    end
--]]
  end


  local function calc_vertical_space(A1, A2)
    if A1.is_outdoor and not A2.is_outdoor then
       A1, A2 = A2, A1
    end

    local c1 = A1.ceil_h
    local c2 = A2.ceil_h

    if not c1 or not c2 then return -77,-99 end

    -- TODO : handle "nature" areas better (checks cells along the junction)
    local f1 = A1.max_floor_h or A1.floor_h
    local f2 = A2.max_floor_h or A2.floor_h

    local max_f = math.max(f1, f2)
    local min_c = math.min(c1, c2)

    return max_f, (min_c - max_f)
  end


  local function is_possible_at_seed(S, dir)
    if not S then return false end

    if S.area != A1 then return false end

    local N = S:neighbor(dir)

    if not N then return false end

    if N.area != A2 then return false end

    -- already have edges here?
    if S.edge[dir]    then return false end
    if N.edge[10-dir] then return false end

    return true
  end


  local function kill_seed(S, seed_list)
    for k = 1, #seed_list do
      if seed_list[k] == S then
         seed_list[k] = "DEAD"
      end
    end
  end


  local function add_piece(S, dir, long)
    local E = { S=S, dir=dir, long=long }

--stderrf("  %s dir:%d long:%d\n", E.S.name, dir, long)

    table.insert(edge_list, E)

    total_len = total_len + long
  end


  local function check_for_edge(S, dir, seed_list)
    if not is_possible_at_seed(S, dir) then return end

    -- determine maximum length of window, and update 'S' to be
    -- the left-most seed of that run.

    local L_dir = geom.LEFT [dir]
    local R_dir = geom.RIGHT[dir]

    local LS = S
    local RS = S

    local long = 1

    for pass = 1, 9 do
      RS = RS:neighbor(R_dir)

      if not is_possible_at_seed(RS, dir) then
        break;
      end

      long = long + 1

      kill_seed(RS, seed_list)
    end

    for pass = 1, 9 do
      LS = LS:neighbor(L_dir)

      if not is_possible_at_seed(LS, dir) then
        break;
      end

      S = LS
      long = long + 1

      kill_seed(LS, seed_list)
    end

    -- limit width of window
    -- [ currently windows this wide *never* occur ]
    while long >= 9 do
      S = S:neighbor(R_dir)
      long = long - 2
    end

    if long >= 8 then
      long = 7
    end

    -- divide really wide windows into smaller ones

    local pattern = assert(WINDOW_PATTERNS[long])

    for i = 1, #pattern do
      local ch = string.sub(pattern, i, i)

      if ch == '-' then
        S = S:neighbor(R_dir)
        continue
      end

      local want_len = 0 + ch
      assert(want_len > 0)

      add_piece(S, dir, want_len)

      for i = 1, want_len do
        S = S:neighbor(R_dir)
      end
    end
  end


  local function find_window_edges()
-- stderrf("Window edges %s --> %s\n", A1.name, A2.name)

    for dir = 2,8,2 do
      local seed_list = table.copy(A1.seeds)

      for i = 1, #seed_list do
        local S = seed_list[i]

        if S != "DEAD" then
          check_for_edge(S, dir, seed_list)
        end
      end
    end

    return edge_list, total_len
  end


  local function install_windows(group, z, height, base_prob)
    each E in edge_list do
      -- wide windows occur quite rarely, so bump up their chance
      local prob = base_prob
      if E.long >= 2 then
        prob = math.min((prob + 100) / 2, prob * 2.5)
      end

      if (A1.room and A1.room.force_windows) or
         (A2.room and A2.room.force_windows) or
         rand.odds(prob)
      then
        local E1, E2 = Edge_new_pair("window", "nothing", E.S, E.dir, E.long)

        E1.window_z = z
        E1.window_group  = group
        E1.window_height = height

        E1.wall_mat = Junction_calc_wall_tex(A1, A2)
        E2.wall_mat = Junction_calc_wall_tex(A2, A1)
      end
    end
  end


  ---| Room_make_windows |---

  if not area_can_window(A1) then return end
  if not area_can_window(A2) then return end

  local z, height = calc_vertical_space(A1, A2)
  if height < 128 then return end

  -- if theme has no window groups, we cannot make any windows
  local group = decide_window_group()
  if not group then return end

  find_window_edges()

  -- check style
  local prob = style_sel("windows", 0, 35, 70, 140)

  -- less chance between indoor rooms
  if (not A1.is_outdoor and not A2.is_outdoor) then
    prob = prob * 0.7
  end

  -- much less chance between zones
  if A1.zone != A2.zone then
    prob = prob * 0.3
  end

  install_windows(group, z, height, prob)
end



function Room_border_up()
  --
  -- Decide the default bordering between any two adjacent areas.
  -- This default can be overridden by EDGE objects, e.g. for doors.
  -- Also some code has already set up the junctions [ TODO : list them ].
  --

  local omit_fence_prob = rand.pick({ 10,50,90 })


  local function can_omit_fence(A1, A2)
    -- TODO : support mode == "nature"
    if not (A1.mode == "floor" and A1.room) then return false end
    if not (A2.mode == "floor" and A2.room) then return false end

    -- start rooms need protection from monsters in neighbor rooms
    if (A1.room and A1.room.is_start) or (A2.room and A2.room.is_start) then
      if rand.odds(80) then return false end
    end

    -- never fall down into a secret
    if A1.room.is_secret or A2.room.is_secret then
      return false
    end

    if A1.room.lev_along > A2.room.lev_along then
      return A1.floor_h > A2.floor_h + 78
    else
      return A2.floor_h > A1.floor_h + 78
    end
  end


  local function visit_junction(junc)
    local A1 = junc.A1
    local A2 = junc.A2

    assert(A1 != A2)


    -- already decided?
    if junc.E1 then return end


    -- handle edge of map
    -- [ normal rooms should not touch the edge ]

    if A2 == "map_edge" then
      Junction_make_map_edge(junc)
      return
    end


    -- zones : gotta keep 'em separated

    if A1.zone != A2.zone then
      Room_make_windows(A1, A2)
      Junction_make_wall(junc)
      return
    end


    -- void --

    if A1.mode == "void" or A2.mode == "void" then
      Junction_make_wall(junc)
      return
    end


    -- closets --

    if (A1.mode == "chunk" and A1.chunk.occupy == "whole") or
       (A2.mode == "chunk" and A2.chunk.occupy == "whole")
    then
      Junction_make_wall(junc)
      return
    end


    -- scenic to scenic --

    if A2.room and not A1.room then
      A1, A2 = A2, A1
    end

    if not A1.room then
      -- nothing needed when both are building/cave
      if A1.is_outdoor or A2.is_outdoor then
        Cave_join_scenic_borders(junc)
      end

      return
    end


    -- room to scenic --

    if not A2.room then
      if A1.room.border != A2 then
        Junction_make_wall(junc)

      elseif A2.border_type == "watery_drop" then
        Junction_make_railing(junc, "MIDBARS3", "block")

      else
        Junction_make_empty(junc)
      end

      return
    end


    -- the same room --

    if A1.room == A2.room then
      return
    end


    -- fences --

    if A1.is_outdoor and A2.is_outdoor then
      -- occasionally omit it when big height difference
      if can_omit_fence(A1, A2) and rand.odds(omit_fence_prob) then
        Junction_make_empty(junc)
      else
        Junction_make_fence(junc)
      end

      return
    end


    -- windows --

    Room_make_windows(A1, A2)


    -- when in doubt, block it out!

    Junction_make_wall(junc)
  end


  local function assign_window_groups()
    if not THEME.window_groups then return end

    local tab = table.copy(THEME.window_groups)

    each Z in LEVEL.zones do
      Z.window_group = rand.key_by_probs(tab)

      tab[Z.window_group] = tab[Z.window_group] / 2
    end
  end


  local function decide_window_boosts()
    each R in LEVEL.rooms do
      if R.is_outdoor then continue end
      if R.is_cave    then continue end

      local prob = style_sel("windows", 0, 2, 5, 8)
      if R.is_secret then prob = prob * 2 end
      if R.symmetry  then prob = prob * 2 end

      if rand.odds(prob) then
        R.force_windows = true
      end
    end
  end


  local function check_sky_closets()
    each A in LEVEL.areas do
      if A.mode != "chunk" then continue end

      if not A.room then continue end
      if not A.room.is_outdoor then continue end

      local T = A.chunk
      if T.kind != "closet" then continue end

      if T:is_open_to_sky(A.room) then
        T.open_to_sky = true
      end
    end
  end


  ---| Room_border_up |---

  assign_window_groups()
  decide_window_boosts()

  check_sky_closets()

  each _,junc in LEVEL.junctions do
    if junc.E1 == nil then
      visit_junction(junc)
    end
  end
end


------------------------------------------------------------------------


function Room_set_kind(R, is_hallway, is_outdoor, is_cave)
  R.is_hallway = is_hallway
  R.is_outdoor = is_outdoor
  R.is_cave    = is_cave

  if is_hallway then
    R.name = string.format("HALLWAY_%d", R.id)
  end

  -- determine if outdoor room should be a park
  -- TODO : exit room cannot be a park, remove that restriction
  if is_outdoor and not (is_hallway or is_cave) and
     R.id != 1
  then
    local park_prob = style_sel("parks", 0, 22, 45, 90)

    if rand.odds(park_prob) then
      R.is_park = true
    end
  end

  each A in R.areas do
    A.is_outdoor = R.is_outdoor
  end
end



function Room_choose_kind(R, last_R)
  -- these outdoor probs carefully chosen so that:
  --    few   is about 15%
  --    some  is about 35%
  --    heaps is about 75%
  local out_prob

  if not last_R then
    out_prob = style_sel("outdoors", 0, 15, 30, 75)
  elseif last_R.is_outdoor then
    out_prob = style_sel("outdoors", 0,  7, 20, 70)
  else
    out_prob = style_sel("outdoors", 0, 20, 40, 90)
  end

  local is_outdoor = rand.odds(out_prob)

  return is_outdoor, false  -- is_cave
end



function Room_choose_size(R, not_big)
  -- decides whether room will be "big" or not.
  -- room kind (building, cave, etc) should have been set already.

  local prob

  if not_big then
    prob = 0
  elseif R.is_cave then
    prob = 100
  elseif R.is_start or R.is_exit then
    prob = 0
  elseif R.is_outdoor then
    prob = style_sel("big_rooms", 0, 10, 20, 50)
  else
    prob = style_sel("big_rooms", 0, 20, 40, 80)
  end

  if rand.odds(prob) then
    R.is_big = true
  end

  local sum = LEVEL.map_W * 2/3 + 30

  if R.is_cave then
    R.size_limit  = sum * rand.pick({ 1.7, 2.2, 2.7 })
    R.floor_limit = 8

  elseif R.is_big then
    R. size_limit = sum * 2.3
    R.floor_limit = rand.pick({ 9,10,11,12 })

  else
    R. size_limit = sum
    R.floor_limit = rand.pick({ 4,5,5,6,6,7 })
  end
end


------------------------------------------------------------------------


function Room_prepare_hallways()
  --
  -- Collects all the pieces of each hallway, and determines the
  -- shape and orientation of each piece.
  --

  local function pick_hallway_fab(R, chunk)
    -- Note: does not handle terminator pieces (they are done like joiners)

    assert(chunk.from_dir)
    assert(chunk.shape)

    local reqs = chunk:base_reqs(chunk.from_dir)

    reqs.kind  = "hall"
    reqs.shape = chunk.shape
    reqs.group = assert(chunk.area.room.hall_group)

    local def = Fab_pick(reqs)

    chunk.prefab_def = def
  end


  local function flow(R, piece, h, seen)
    seen[piece.id] = 1

    table.insert(R.pieces, piece)

    local A = piece.area
    assert(A and A.room == R)

    A.prelim_h = h

    -- determine shape and orientation
    local cat_dir

    piece.shape, cat_dir = geom.categorize_shape(
        piece.h_join[2], piece.h_join[4], piece.h_join[6], piece.h_join[8])

    -- terminators get mis-categorized as dead-ends...
    if piece.is_terminator and piece.shape == "U" then
      piece.shape = "I"
    end

    -- an L shape needs a dest_dir, so piece can be mirrored when needed
    if piece.shape == "L" then
      for dir = 2,8,2 do
        if piece.h_join[dir] and piece.from_dir != dir then
          piece.dest_dir = dir
        end
      end
    end

    -- a T shape needs a specific from_dir
    local old_dir = piece.from_dir

    if piece.shape == "T" then
      piece.from_dir = cat_dir
    end

    if piece.is_terminator then
      Room_pick_joiner_prefab(assert(piece.conn), piece)
    else
      pick_hallway_fab(R, piece)
    end

    local delta_h = piece.prefab_def.delta_h or 0

    -- recurse to other pieces

    each dir, P in piece.h_join do
      if not seen[P.id] then
        local new_h = h

        -- most prefabs are orientated along the flow, so only need to
        -- adjust  delta_h for certain "T" pieces (and maybe terminators...)
        if piece.shape == "T" and piece.from_dir != old_dir then
          if dir == piece.from_dir then
            new_h = new_h - delta_h
          end
        else
          new_h = new_h + delta_h
        end

        flow(R, P, new_h, seen)
      end
    end
  end


  local function visit_hallway(R)
    flow(R, R.first_piece, 0, {})
  end


  ---| Room_prepare_hallways |---

  each R in LEVEL.rooms do
    if R.is_hallway then
      visit_hallway(R)
    end
  end
end



function Room_floor_ceil_heights()
  --
  -- Computes the floor and ceiling heights of all the areas of
  -- each room, including liquids and closets.
  --
  -- Also constructs CAVES and PARK rooms.
  --

  -- Note: the 'entry_h' field also serves as a "visited already" flag

  local TRAVERSE_H = 80


  local function set_floor(A, h)
    A.floor_h = h
  end


  local function set_ceil(A, h)
    A.ceil_h = h
  end


  local function areaconn_other(IC, A)
    if IC.A1 == A then return IC.A2 end
    if IC.A2 == A then return IC.A1 end

    return nil
  end


  local function prob_for_new_floor_group(A1, A2)
    local vol_1 = A1.svolume / sel(A1.room.symmetry, 2, 1)
    local vol_2 = A2.svolume / sel(A2.room.symmetry, 2, 1)

    -- TODO

    return 0
  end


  local function visit_floor_area(R, A, grp)
    if grp == "new" then
      grp = { id=alloc_id("floor_group") }
    end

    A.floor_group = grp

    each IC in R.internal_conns do
      local A2 = areaconn_other(IC, A)

      if not A2 then continue end
      if A2.floor_group then continue end

      -- stair connections *must* use another group.
      -- direct connections generally use the same group.

      if IC.kind != "direct" or rand.odds(prob_for_new_floor_group(A, A2)) then
        visit_floor_area(R, A2, "new")
      else
        visit_floor_area(R, A2, A.floor_group)
      end
    end
  end


  local function group_floors(R)
    if R.is_park then return end
    if R.is_cave then return end
    if R.is_hallway then return end

    local start_area

    repeat
      start_area = rand.pick(R.areas)
    until start_area.mode == "floor"

    visit_floor_area(R, start_area, "new")
  end


  local function merge_floor_groups(R, group1, group2)
    if group1.id > group2.id then
      group1, group2 = group2, group1
    end

    each A in R.areas do
      if A.floor_group == group2 then
         A.floor_group =  group1
      end
    end

    group2.id = "DEAD"
  end


  local function do_floor_groups_touch(R, group1, group2)
    each A3 in R.areas do
    each A4 in R.areas do
      if A3.floor_group == group1 and
         A4.floor_group == group2 and
         A3:touches(A4)
      then
        return true
      end
    end
    end

    return false
  end


  local function try_regroup_floors(R, A1, A2)
    local group1 = A1.floor_group
    local group2 = A2.floor_group

    if not (group1 and group2) then return end

    if group1 == group2 then return end

    if group1.h != group2.h then return end

    if do_floor_groups_touch(R, group1, group2) then
      merge_floor_groups(R, group1, group2)
    end
  end


  local function regroup_floors(R)
    -- after setting floor heights in the room, this checks if two
    -- groups which touch each other have the same height

    for pass = 1, 3 do
      each A1 in R.areas do
      each A2 in R.areas do
        try_regroup_floors(R, A1, A2)
      end
      end
    end

    each A in R.areas do
      if A.floor_group then
        table.add_unique(R.floor_groups, A.floor_group)
      end
    end

    each group in R.floor_groups do
      Area_inner_points_for_group(R, group, "floor")
    end
  end


  local function ceilings_must_stay_separated(R, A1, A2)
    assert(A1 != A2)

    each IC in R.internal_conns do
      if (IC.A1 == A1 and IC.A2 == A2) or
         (IC.A1 == A2 and IC.A2 == A1)
      then
        if IC.foobie_bletch then return false end

        return (IC.kind == "direct")
      end
    end

--[[
    if not A1:touches(A2) then return false end

    return (A1.floor_group == A2.floor_group)
--]]
    return false
  end


  local function merge_ceil_groups(R, group1, group2)
    if group1.id > group2.id then
      group1, group2 = group2, group1
    end

-- stderrf("%s : merging ceil %d --> %d\n", R.name, group2.id, group1.id)

    each A in R.areas do
      if A.ceil_group == group2 then
         A.ceil_group =  group1
      end
    end

    group2.id = "DEAD"
  end


  local function try_merge_ceil_groups(R, group1, group2)
    assert(group1 != group2)

    local do_touch = false

    each A1 in R.areas do
    each A2 in R.areas do
      if A1.ceil_group != group1 then continue end
      if A2.ceil_group != group2 then continue end

      if ceilings_must_stay_separated(R, A1, A2) then return false end

      if A1:touches(A2) then do_touch = true end

      each IC in R.internal_conns do
        if (IC.A1 == A1 and IC.A2 == A2) or
           (IC.A1 == A2 and IC.A2 == A1)
        then
          do_touch = true
        end
      end
    end  -- A1, A2
    end

    if not do_touch then return false end

    merge_ceil_groups(R, group1, group2)
    return true
  end


  local function group_ceiling_pass(R)
    local groups = {}

    each A in R.areas do
      if A.ceil_group then
        table.add_unique(groups, A.ceil_group)
      end
    end

    if #groups < 2 then return false end

    rand.shuffle(groups)

    for i = 2, #groups do
    for k = 1, i - 1 do
      if try_merge_ceil_groups(R, groups[i], groups[k]) then
        return true
      end
    end
    end

    return false
  end


  local function group_ceilings(R)
    if R.is_outdoor then return end

    each A in R.areas do
      if A.mode == "floor" then
        A.ceil_group = { id=alloc_id("ceil_group") }
      end
    end

--[[
    -- pick some internal connections that should BLAH BLAH
    each IC in R.internal_conns do
      if IC.kind == "stair" or rand.odds(30) then
        IC.same_ceiling = true
      end
    end
--]]

    for loop = 1, 1 do
      group_ceiling_pass(R)
    end

    -- handle stairs
    each A in R.areas do
      if A.chunk and A.chunk.kind == "stair" and not A.chunk.prefab_def.plain_ceiling then
        local N1 = A.chunk.from_area
        local N2 = A.chunk.dest_area

        if N1.floor_h < N2.floor_h then
          A.ceil_group = N1.ceil_group
        else
          A.ceil_group = N2.ceil_group
        end
      end
    end


    each A in R.areas do
      if A.ceil_group then
        table.add_unique(R.ceil_groups, A.ceil_group)
      end
    end

    each group in R.ceil_groups do
      Area_inner_points_for_group(R, group, "ceil")
    end
  end


  local function room_add_steps(R)
    -- NOT USED ATM [ should be done while flowing through room ]

    each C in R.internal_conns do
      local A1 = C.A1
      local A2 = C.A2

      if C.kind == "stair" then continue end

      local diff = math.abs(A1.floor_h - A2.floor_h)
      if diff <= PARAM.jump_height then continue end

      -- FIXME : generally build single staircases (a la V6 and earlier)

      local junc = Junction_lookup(A1, A2)

      Junction_make_steps(junc)
    end
  end


  local function process_room(R, entry_area)
    gui.debugf("ASSIGN FLOORS IN %s\n", R.name)

    local base_h = 0

    if entry_area then
      base_h = R.entry_h - assert(entry_area.prelim_h)
    end

    -- compute the actual floor heights, ensuring entry_area becomes 'entry_h'
    each A in R.areas do
      if A.prelim_h then
        set_floor(A, base_h + A.prelim_h)
      end

--    stderrf("%s %s = %s : floor_h = %s\n", R.name, A.name, tostring(A.mode), tostring(A.floor_h))
    end
  end


--[[  OLD CRUD, REVIEW IF USEFUL....

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
--]]


  local function process_cave(R)
    Cave_build_a_cave(R, R.entry_h)
  end


  local function process_park(R)
    R.walkway_height = 256
    R.areas[1].base_light = 144

    Cave_build_a_park(R, R.entry_h)
  end


  local function maintain_material_across_conn(C)
    if C.kind != "edge" then return false end

    if C.R1.is_cave or C.R2.is_cave then return false end
    if C.R1.is_hallway or C.R2.is_hallway then return false end

    if C.A1.floor_h    != C.A2.floor_h then return false end
    if C.R1.is_outdoor != C.R2.is_outdoor then return false end

    if not (C.E1.kind == "nothing" or C.E1.kind == "doorway") then return false end
    if not (C.E2.kind == "nothing" or C.E2.kind == "doorway") then return false end

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

      if A1.floor_mat then
        assert(A1.floor_h)

        R.floor_mats[A1.floor_h] = A1.floor_mat
      end
    end

    each A in R.areas do
      if A.mode != "floor" then continue end

      assert(A.floor_h)

      if A.peer and A.peer.floor_mat then
        A.floor_mat = A.peer.floor_mat
        continue
      end

      if not R.floor_mats[A.floor_h] then
        R.floor_mats[A.floor_h] = rand.key_by_probs(R.theme.floors)
      end

      A.floor_mat = assert(R.floor_mats[A.floor_h])
    end
  end


  local function select_ceiling_mats(R)
    -- outdoor rooms do not require ceiling materials
    if R.is_outdoor then return end

    local tab = R.theme.ceilings or R.theme.floors
    assert(tab)

    each A in R.areas do
      if A.is_outdoor then continue end
      if A.is_porch   then continue end

      if A.mode != "floor" then continue end

      assert(A.ceil_h)

      if A.peer and A.peer.ceil_mat then
        A.ceil_mat = A.peer.ceil_mat
        continue
      end

      if not R.ceil_mats[A.ceil_h] then
        R.ceil_mats[A.ceil_h] = rand.key_by_probs(tab)
      end

      A.ceil_mat = assert(R.ceil_mats[A.ceil_h])
    end
  end


  local function visit_joiner(entry_h, prev_room, conn)
    local chunk = assert(conn.joiner_chunk)
    assert(chunk.prefab_def)

    -- FIXME: this smells like a hack
    if chunk.occupy == "whole" then
      chunk.area.is_outdoor = nil
    end

    local delta_h = chunk.prefab_def.delta_h or 0

    -- are we entering the joiner from the opposite side?
    if chunk.from_area.room != prev_room then
      delta_h = 0 - delta_h
    end

    local joiner_h = math.min(entry_h, entry_h + delta_h)

    set_floor(chunk.area, joiner_h)

-- stderrf("  setting joiner in %s to %d\n", C.joiner_chunk.area.name, C.joiner_chunk.area.floor_h)
-- stderrf("  loc: (%d %d)\n", C.joiner_chunk.sx1, C.joiner_chunk.sy1)

    return entry_h + delta_h
  end


  local function visit_room(R, entry_h, entry_area, prev_room, via_conn)
    group_floors(R)

    if entry_area then
      assert(entry_area.room == R)
      assert(entry_area.mode != "joiner")
    end

    -- handle start rooms and teleported-into rooms
    if not entry_h then
      entry_h = rand.irange(0, 4) * 64
    end

    R.entry_h = entry_h

    if via_conn then
      via_conn.door_h = entry_h
    end

    if R.is_hallway then
      process_room(R, entry_area)

    elseif R.is_cave then
      process_cave(R)

    elseif R.is_park then
      process_park(R)

    else
---???  Room_detect_porches(R)

      process_room(R, entry_area)
      select_floor_mats(R, via_conn)
    end

    -- recurse to neighbors
    each C in R.conns do
      if C.is_cycle then continue end

      local R2 = C:other_room(R)

      local A1, A2
      if C.R1 == R then A1 = C.A1 else A1 = C.A2 end
      if C.R1 == R then A2 = C.A2 else A2 = C.A1 end

      -- already visited it?
      if R2.entry_h then continue end

      gui.debugf("Recursing though %s (%s)\n", C.name, C.kind)
-- if C.kind != "teleporter"then
-- stderrf("  %s / %s ---> %s / %s\n", A1.name, A1.mode, A2.name, A2.mode)
-- end

      if C.kind == "teleporter" then
        visit_room(R2, nil, nil, R, C)
        continue
      end

      assert(A1.mode != "joiner")
      assert(A2.mode != "joiner")

      assert(A1.floor_h)

      local next_h = C.conn_h or A1.floor_h

      if C.kind == "joiner" then  --FIXME???  or C.kind == "terminator" then
        next_h = visit_joiner(next_h, R, C)
      end

      visit_room(R2, next_h, A2, R, C)
    end
  end


  local function do_liquid_areas(R)
    each A in R.areas do
      if A.mode == "liquid" then
        local N = A:lowest_neighbor()

        if not N then
--!!!! FIXME : temp stuff for park-border experiment....
--!!!!    error("failed to find liquid neighbor")
          A.floor_h = 977
          A.ceil_h  = 999
          continue
        end

        A.floor_h  = N.floor_h - 16
        A.ceil_h   = N.ceil_h
        A.ceil_mat = N.ceil_mat

        A.max_floor_h = N.floor_h
      end
    end
  end


  local function get_cage_neighbor(A)
    local N = A:highest_neighbor()

    if N then return N end

    each N2 in A.neighbors do
      if N2.room == A.room and N2.mode == "liquid" then return N2 end
    end

    each N3 in A.neighbors do
      if N3.room == A.room and N3.mode == "nature" then return N3 end
    end

    error("failed to find cage neighbor")
  end


  local function kill_cages(R, want_void)
    -- turn cages in start rooms into a plain floor

    each A in R.areas do
      if A.mode != "cage" then continue end

      if R.is_park or R.is_cave or want_void then
        A.mode = "void"
        continue
      end

      local N

      if A.peer and A.peer.floor_h then
        N = A.peer
      else
        N = get_cage_neighbor(A)
      end

      A.mode = N.mode

      A.floor_h   = N.floor_h
      A.floor_mat = N.floor_mat

      A.ceil_h    = N.ceil_h
      A.ceil_mat  = N.ceil_mat
    end
  end


  local function add_cage_lighting(R, A)
    if not R.cage_light_fx then
      --  8 = oscillates
      -- 17 = flickering
      -- 12 = flashes @ 1 hz
      -- 13 = flashes @ 2 hz
      R.cage_light_fx = rand.pick({ 0,8,12,13,17 })
    end

    if R.cage_light_fx == 0 then
      -- no effect
      A.bump_light = 32
      return
    end

    A.bump_light = 48
    A.sector_fx  = R.cage_light_fx
  end


  local function do_a_cage(R, A)
    -- for symmetry, ensure second cage is same as first
    if A.peer and A.peer.floor_h then
      local P = A.peer

      A.floor_h   = P.floor_h
      A.floor_mat = P.floor_mat

      A.ceil_h    = P.ceil_h
      A.ceil_mat  = P.ceil_mat

      A.bump_light = P.bump_light
      A.sector_fx  = P.sector_fx

      if table.has_elem(R.cage_rail_areas, P) then
        table.insert(R.cage_rail_areas, A)
      end

      return
    end

    local N = get_cage_neighbor(A)

    if not N.cage_floor_h then
      N.cage_floor_h = (N.max_floor_h or N.floor_h) + rand.pick({48,64})
    end

    A.floor_h  = N.cage_floor_h
    if N.ceil_h then
      A.floor_h = math.min(A.floor_h, N.ceil_h - 64)
    end

    A.ceil_h   = A.floor_h + 72
    A.ceil_mat = N.ceil_mat

    if A.is_outdoor then
      A.floor_mat = LEVEL.cliff_mat
    else
      A.floor_mat = A.zone.cage_mat
    end
    assert(A.floor_mat)

    -- fancy cages
    if A.cage_mode or (#A.seeds >= 4 and rand.odds(50)) then
      A.floor_mat = A.zone.cage_mat

      table.insert(R.cage_rail_areas, A)

      if not R.is_outdoor then
        if N.ceil_h and N.ceil_h > A.ceil_h + 72 then
          A.ceil_h = N.ceil_h
        else
          A.ceil_mat = A.floor_mat
        end

        add_cage_lighting(R, A)
      end
    end
  end


  local function do_cage_areas(R)
    if R.is_start then
      kill_cages(R)
      return
    end

    if R.is_secret and rand.odds(90) then
      kill_cages(R, "want_void")
      return
    end

    R.cage_rail_areas = {}

    each A in R.areas do
      if A.mode == "cage" then
        do_a_cage(R, A)
      end
    end
  end


  local function do_stairs(R)
    each chunk in R.stairs do
      local A = chunk.area

      -- outdoor heights are done later, get a dummy now
      if A.is_outdoor then
        A.ceil_h = A.floor_h + R.zone.sky_add_h - 8
        continue
      end

      local N = chunk.from_area
      assert(N.ceil_h)

      A.ceil_h   = N.ceil_h
      A.ceil_mat = N.ceil_mat
    end
  end


  local function do_closets(R)
    each chunk in R.closets do
      local A = chunk.area

      assert(chunk.from_area)
      A.floor_h = assert(chunk.from_area.floor_h)

      -- FIXME: this smells like a hack
      if chunk.occupy == "whole" then
        A.is_outdoor = nil
      end
    end
  end


  local function calc_min_max_floor(R)
    R.max_floor_h = -EXTREME_H
    R.min_floor_h =  EXTREME_H

    each A in R.areas do
      if A.floor_h then
        R.max_floor_h = math.max(R.max_floor_h, A.max_floor_h or A.floor_h)
        R.min_floor_h = math.min(R.min_floor_h, A.min_floor_h or A.floor_h)

        if A.floor_group then A.floor_group.h = A.floor_h end
      end
    end

    assert(R.max_floor_h >= R.min_floor_h)
  end


  local function check_joiner_nearby_h(A)
    -- FIXME for terminators
    each C in LEVEL.conns do
      if (C.kind == "joiner" or C.kind == "XXX_terminator") and
         (C.A1 == A or C.A2 == A)
      then
        return C.joiner_chunk.prefab_def.nearby_h
      end
    end

    return nil
  end


  local function calc_ceil_stuff(R, group)
    group.vol = 0

    each A in R.areas do
      if A.ceil_group == group then
        group.vol = group.vol + A.svolume

        group.min_floor_h = math.N_min(A.floor_h, group.min_floor_h)
        group.max_floor_h = math.N_max(A.floor_h, group.max_floor_h)
      end
    end

    if R.symmetry then group.vol = group.vol / 2 end

    assert(group.max_floor_h)

    group.min_h = 96

    each A in R.areas do
      if A.ceil_group == group and A:has_conn() then
        -- TODO : get nearby_h from arch/door prefab  [ but it aint picked yet... ]
        local min_h = A.floor_h + 128 - group.max_floor_h
        group.min_h = math.max(group.min_h, min_h)

        min_h = check_joiner_nearby_h(A)
        if min_h then
          min_h = A.floor_h + min_h - group.max_floor_h
          group.min_h = math.max(group.min_h, min_h)
        end
      end
    end

--[[
    stderrf("%s : ceil group %d : vol=%d  min=%d  max=%d\n", R.name, group.id,
        group.vol, group.min_floor_h, group.max_floor_h)
--]]
  end


  local function calc_a_ceiling_height(R, group)
    local add_h

        if group.vol <  8 then add_h = 96
    elseif group.vol < 16 then add_h = 128
    elseif group.vol < 32 then add_h = 160
    elseif group.vol < 48 then add_h = 192
    else                       add_h = 256
    end

    if add_h > 128 and group.max_floor_h >= group.min_floor_h + 64 then
      add_h = add_h - 32
    end

    add_h = math.max(group.min_h, add_h)

    group.h = group.max_floor_h + add_h
  end


  local function ceil_ensure_traversibility(R)
    -- ensure enough vertical room for player to travel between two
    -- internally connected areas

    each IC in R.internal_conns do
      local A1 = IC.A1
      local A2 = IC.A2

      local top_z = math.max(A1.floor_h, A2.floor_h)

      if A1.stair_top_h then top_z = math.max(top_z, A1.stair_top_h) end
      if A2.stair_top_h then top_z = math.max(top_z, A2.stair_top_h) end

      top_z = top_z + TRAVERSE_H

      if A1.ceil_group then
        while A1.ceil_group.h < top_z do A1.ceil_group.h = A1.ceil_group.h + 32 end
      else
        A1.traverse_ceil_h = top_z
      end

      if A2.ceil_group then
        while A2.ceil_group.h < top_z do A2.ceil_group.h = A2.ceil_group.h + 32 end
      else
        A2.traverse_ceil_h = top_z
      end
    end
  end


  local function ceiling_group_heights(R)
    --
    -- Notes:
    --   a major requirement is the ceiling groups which neighbor
    --   each other (incl. via a stair) get a unique ceil_h.
    --
    --   a lesser goal is that larger ceiling groups get a higher
    --   ceiling than smaller ones.
    --

    local groups = {}

    each A in R.areas do
      if A.ceil_group then
        table.add_unique(groups, A.ceil_group)
      end
    end

    each group in groups do
      calc_ceil_stuff(R, group)
    end

    rand.shuffle(groups)

    each group in groups do
      calc_a_ceiling_height(R, group)
    end

    ceil_ensure_traversibility(R)

    -- TODO if largest ceil-group is same as a neighbor, raise by 32 until different
  end


  local function do_ceilings(R)
    group_ceilings(R)

    if not R.is_outdoor then
      ceiling_group_heights(R)
    end

    each A in R.areas do
      if A.mode != "floor" then continue end

      -- outdoor heights are done later, get a dummy now
      if A.is_outdoor then
        A.ceil_h = A.floor_h + R.zone.sky_add_h - 8
        continue
      end

      if A.peer and A.peer.ceil_h then
        A.ceil_h = A.peer.ceil_h
        continue
      end

      if A.ceil_group then
        set_ceil(A, assert(A.ceil_group.h))
        continue
      end

      local height = rand.pick({ 128, 192,192,192, 256,320 })

      if A.is_porch then
        height = 144
      end

---## if not A.floor_h then
---## gui.debugf("do_ceilings : no floor_h in %s %s in %s\n", A.name, A.mode, A.room.name)
---## end
      assert(A.floor_h)

      local new_h = R.max_floor_h + 128

      if A.traverse_ceil_h then new_h = math.max(new_h, A.traverse_ceil_h) end

      set_ceil(A, new_h)
    end

    -- now pick textures
    select_ceiling_mats(R)
  end


  local function sanity_check()
    each R in LEVEL.rooms do
      if not R.entry_h then
--[[ "fubar" debug stuff
R.entry_h = -77
each A in R.areas do A.floor_h = R.entry_h end
end
--]]
        error("Room did not get an entry_h")
      end
    end
  end


  ---| Room_floor_ceil_heights |---

  -- give each zone a preferred hallway z_dir  [ NOT USED ATM ]
  each Z in LEVEL.zones do
    Z.hall_up_prob = rand.sel(70, 80, 20)
  end

  local first = LEVEL.start_room or LEVEL.blue_base or LEVEL.rooms[1]

  -- recursively visit all rooms
  visit_room(first)

  -- sanity check : all rooms were visited
  sanity_check()

  each R in LEVEL.rooms do
    calc_min_max_floor(R)

    if not (R.is_cave or R.is_park) then
      regroup_floors(R)

      do_ceilings(R)
      do_liquid_areas(R)
    end

    do_cage_areas(R)
    do_stairs(R)

    do_closets(R)
  end
end



function Room_add_cage_rails()
  -- this must be called AFTER scenic borders are finished, since
  -- otherwise we won't know the floor_h of border areas.

  local function rails_in_cage(A, R)
    each N in A.neighbors do
      if N.zone != A.zone then continue end

      local junc = Junction_lookup(A, N)

      if junc.E1 and junc.E1.kind != "nothing" then continue end
      if junc.E2 and junc.E2.kind != "nothing" then continue end

      -- don't place railings on higher floors (it looks silly)
      if N.floor_h and N.floor_h > A.floor_h then continue end

      Junction_make_railing(junc, "MIDBARS3", "block")
    end
  end


  ---| Room_add_cage_rails |---

  each R in LEVEL.rooms do
    if R.cage_rail_areas then
      each A in R.cage_rail_areas do
        rails_in_cage(A, R)
      end
    end
  end
end



function Room_set_sky_heights()

  local function do_area(A)
    local sky_h = (A.max_floor_h or A.floor_h) + A.zone.sky_add_h

    A.zone.sky_h = math.N_max(A.zone.sky_h, sky_h)

    if A.is_porch then
      A.zone.sky_h = math.max(A.zone.sky_h, A.ceil_h + 48)
    end
  end


  local function do_fence(E)
    assert(E.peer)

    local A1 = E.area
    local A2 = E.peer.area

    E.fence_top_z = Junction_calc_fence_z(A1, A2)
  end


  ---| Room_set_sky_heights |---

  each A in LEVEL.areas do
    -- visit all normal, outdoor areas
    if A.floor_h and A.is_outdoor and not A.mode != "scenic" then
      do_area(A)

      -- include nearby buildings in same zone
      -- [ TODO : perhaps limit to where areas share a window or doorway ]
--???      each N in A.neighbors do
--???        if N.zone == A.zone and N.floor_h and not N.is_outdoor and not N.is_boundary then
--???          do_area(N)
--???        end
--???      end
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
  -- [ SCENIC areas are done later.... ]

  each A in LEVEL.areas do
    if A.floor_h and A.zone and A.is_outdoor and not A.is_porch then
      A.ceil_h = A.zone.sky_h
    end
  end

  -- handle locked and secret fences
  each R in LEVEL.rooms do
    each E in R.locked_fences do
      do_fence(E)
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



function Room_add_camera()
  -- this is used for Quake intermissions

  -- game check
  if not GAME.ENTITIES["camera"] then return end

  -- TODO
end


------------------------------------------------------------------------


function Room_build_all()

  gui.printf("\n--==|  Build Rooms |==--\n\n")

  Area_building_facades()

  -- place importants early as traps need to know where they are.
  Layout_place_all_importants()

  Layout_indoor_lighting()

  -- this does traps, and may add switches which lock a door / joiner
  Layout_add_traps()
  Layout_decorate_rooms(1)

  -- do doors before floor heights, they may have a delta_h (esp. joiners)
  Room_reckon_door_tex()
  Room_prepare_skies()

  Room_reckon_doors()
  Room_prepare_hallways()

  Room_floor_ceil_heights()
  Room_set_sky_heights()

  -- this does other stuff (crates, free-standing cages, etc..)
  Layout_decorate_rooms(2)
  Layout_scenic_vistas()

  Room_border_up()

  Room_add_cage_rails()

  Layout_handle_corners()
  Layout_outdoor_shadows()

  Render_set_all_properties()

  Render_all_chunks()
  Render_all_areas()

  Render_triggers()
  Render_determine_spots()

  Room_add_sun()
  Room_add_camera()
end

