----------------------------------------------------------------
--  Room Management
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2013 Andrew Apted
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
  kind : keyword  -- "building" : constructed room
                  -- "outdoor"  : room with sky
                  -- "cave"     : natural room

  shape : keyword -- "rect" (perfect rectangle)
                  -- "L"  "T"  "U"  "S"  "H"
                  -- "plus"
                  -- "odd" (everything else)

  is_outdoor : bool  -- true for "outdoor" kind, or some caves
  is_street  : bool  -- used in Street mode

  conns : list(CONN)  -- connections with neighbor rooms

  entry_conn : CONN  -- the main connection used to enter the room
  exit_conn  : CONN  -- the main unlocked connection which exits the room

  branch_kind : keyword

  symmetry : keyword   -- symmetry of room, or NIL
                       -- keywords are "x", "y", "xy"

  sx1, sy1, sx2, sy2  -- \ Seed range
  sw, sh, svolume     -- /

  kx1, ky1, kx2, ky2  -- \ Section range
  kw, kh              -- /

  sections : list  -- all sections of room

  crossover_hall : HALLWAY  -- if present, a hallway crosses over this room

  floor_limit : { low, high }  -- a limitation of floor heights


  quest : QUEST

  purpose : keyword   -- usually NIL, can be "EXIT" etc... (FIXME)

  weapons : list(NAME)  -- weapons to add into room

  walls   : list(WALL)
  corners : list(CORNER)

  fences[ROOM ID] : FENCE  -- what fences that this room has to make
                           -- at the border to other outdoor rooms.
                           -- NIL for none.

  conn_group : number  -- traversibility group (used for Connect logic)

  sky_group : number  -- outdoor rooms which directly touch will belong
                      -- to the same sky_group (unless a solid wall is
                      -- enforced, e.g. between zones).

  hazard_health  -- health provided to offset environment hazards

  cave_info : CAVE_INFO  -- (see simple.lua)
}


class CLOSET
{
  kind : keyword  -- "closet"  (differentiates from room types)


  closet_kind : keyword  -- "START", "EXIT"
                         -- "secret", "trap"

  section : SECTION

  parent : ROOM  -- parent room

  conn : CONN  -- connection to parent room

  dir : 2/4/6/8

}


class WALL extends PORTAL
{
  kind : keyword  -- "wall" or "door"

  corner_L : CORNER  -- corner to left (ACW) of wall
  corner_R : CORNER  -- corner to right (CW) of wall
}


class CORNER extends PORTAL
{
  kind : keyword  -- "corner" or "outie"

  (side will be 1, 3, 7 or 9)

  wall_L : WALL   -- wall to left (ACW) of corner
  wall_R : WALL   -- wall to right (CW) of corner
}


class FENCE
{
  kind : keyword   -- "none"   : can allow player to fall off
                   -- "solid"  : make solid wall (no shared sky)

  R1 : ROOM   -- room containing the fence
  R2 : ROOM   -- the other room

}


class SKY_GROUP
{
  h : number  -- the sky height for the group
}


----------------------------------------------------------------]]


ROOM_CLASS = {}

function ROOM_CLASS.new(shape)
  local id = Plan_alloc_id("room")
  local R =
  {
    id = id
    kind = "building"
    shape = shape

    conns = {}
    sections = {}
    middles = {}
    spaces = {}
    floor_mats = {}

    walls = {}
    corners = {}
    fences = {}   -- FIXME: just use 'walls' ??
    gates = {}

    num_windows = 0

    goal_spots = {}
    mon_spots  = {}
    item_spots = {}
    cage_spots = {}

    prefabs = {}
    decor   = {}

    sky_rects = {}
    exclusion_zones = {}

    hazard_health = 0
  }
  table.set_class(R, ROOM_CLASS)
  table.insert(LEVEL.rooms, R)
  return R
end


function ROOM_CLASS.tostr(R)
  return string.format("ROOM_%d", R.id)
end


function ROOM_CLASS.longstr(R)
  return string.format("%s_ROOM_%d [%d,%d..%d,%d]",
      string.upper(R.kind), R.id,
      R.sx1, R.sy1, R.sx2, R.sy2)
end


function ROOM_CLASS.list_sections(R)
  gui.debugf("SECTION LIST for %s:\n", R:tostr())
  gui.debugf("{\n")
  
  for kx = 1,SECTION_W do for ky = 1,SECTION_H do
    local K = SECTIONS[kx][ky]
    if K.room == R then
      gui.debugf("  %s : S(%d %d) .. (%d %d)\n", K:tostr(),
                 K.sx1, K.sy1, K.sx2, K.sy2)
    end
  end end

  gui.debugf("}\n")
end


function ROOM_CLASS.update_size(R)
  R.sw, R.sh = geom.group_size(R.sx1, R.sy1, R.sx2, R.sy2)
end


function ROOM_CLASS.update_seed_bbox(R)
  each K in R.sections do
    R.sx1 = math.min(R.sx1, K.sx1)
    R.sy1 = math.min(R.sy1, K.sy1)

    R.sx2 = math.max(R.sx2, K.sx2)
    R.sy2 = math.max(R.sy2, K.sy2)
  end

  R:update_size()
end


function ROOM_CLASS.add_section(R, K)
  table.insert(R.sections, K)

  R.kx1 = math.min(K.kx, R.kx1 or 99)
  R.ky1 = math.min(K.ky, R.ky1 or 99)

  R.kx2 = math.max(K.kx, R.kx2 or -1)
  R.ky2 = math.max(K.ky, R.ky2 or -1)

  R.kw, R.kh = geom.group_size(R.kx1, R.ky1, R.kx2, R.ky2)

  R.kvolume = (R.kvolume or 0) + 1

  if K.shape == "rect" then
    R.map_volume = (R.map_volume or 0) + 1
  end
end


function ROOM_CLASS.remove_section(R, K)
  table.kill_elem(R.sections, K)

  K.room = nil

  for sx = K.sx1, K.sx2 do
  for sy = K.sy1, K.sy2 do
    local S = SEEDS[sx][sy]
    S.room = nil
  end
  end
end


function ROOM_CLASS.fill_section(R, K)
  for sx = K.sx1, K.sx2 do
  for sy = K.sy1, K.sy2 do
    local S = SEEDS[sx][sy]
    assert(not S.hall)

    S.room = K.room
    S.section = K
  end
  end

  if not R.sx1 or K.sx1 < R.sx1 then R.sx1 = K.sx1 end
  if not R.sy1 or K.sy1 < R.sy1 then R.sy1 = K.sy1 end
  if not R.sx2 or K.sx2 > R.sx2 then R.sx2 = K.sx2 end
  if not R.sy2 or K.sy2 > R.sy2 then R.sy2 = K.sy2 end

  R:update_size()

  R.svolume = (R.svolume or 0) + (K.sw * K.sh)
end


function ROOM_CLASS.annex(R, K)
  K:set_room(R)

  R:add_section(K)
end


function ROOM_CLASS.contains_seed(R, x, y)
  if x < R.sx1 or x > R.sx2 then return false end
  if y < R.sy1 or y > R.sy2 then return false end
  return true
end


function ROOM_CLASS.has_lock(R, lock)
  each D in R.conns do
    if D.lock == lock then return true end
  end
  return false
end


function ROOM_CLASS.has_any_lock(R)
  each D in R.conns do
    if D.lock then return true end
  end
  return false
end


function ROOM_CLASS.has_lock_kind(R, kind)
  each D in R.conns do
    if D.lock and D.lock.kind == kind then return true end
  end
  return false
end


function ROOM_CLASS.has_teleporter(R)
  each D in R.conns do
    if D.kind == "teleporter" then return true end
  end
  return false
end

function ROOM_CLASS.get_teleport_conn(R)
  each D in R.conns do
    if D.kind == "teleporter" then
      return D
    end
  end

  error("cannot find teleport conn")
end


function ROOM_CLASS.has_weapon_using_ammo(R, ammo)
  if R.weapons and not PARAM.hexen_weapons then
    each name in R.weapons do
      local info = GAME.WEAPONS[name]
      if info.ammo == ammo then return true end
    end
  end
  return false
end


function ROOM_CLASS.dist_to_closest_conn(R, K, side)
  -- TODO: improve this by calculating side coordinates
  local best

  each D in R.conns do
    local K2 = D:section(R)
    if K2 then
      local dist = geom.dist(K.kx, K.ky, K2.kx, K2.ky)

      if not best or dist < best then
        best = dist
      end
    end
  end

  return best
end


function ROOM_CLASS.touches_map_edge(R)
  if R.kx1 <= 2 or R.kx2 >= SECTION_W-1 then return true end
  if R.ky1 <= 2 or R.ky2 >= SECTION_H-1 then return true end

  return false
end


function ROOM_CLASS.eval_start(R)
  -- already has a purpose? (e.g. secret exit room)
  if R.purpose then return -1 end

  local score = gui.random() * 10

  -- really want a room touching the edge of the map
  -- (since that gives two seeds for the start prefab)
  if R:touches_map_edge() then score = score + 100 end

  -- not too big !!
  if R.svolume <= 70 then score = score + 10 end

  -- not too small
  if R.svolume >= 12 then score = score + 2 end

  -- prefer an unusual shape
  if R.shape != "rect" then score = score + 4 end

  --??  if not R:has_teleporter() then score = score + 8 end

  return score
end


function ROOM_CLASS.eval_teleporter(R)
  -- can only have one teleporter per room
  if R:has_teleporter() then return -1 end

  -- not in a secret exit room
  if R.purpose == "SECRET_EXIT" then return -1 end

  -- room too small?
  if R.sw < 3 or R.sh < 3 or R.svolume < 10 then return -1 end

  -- sweet spot for size is around 2..4 map sections
  local score = 10 - math.abs(R.map_volume - 3.2)

  return score + 2.4 * gui.random() ^ 2
end


function ROOM_CLASS.is_near_exit(R)
  if R.purpose == "EXIT" then return true end
  each D in R.conns do
    local N = D:neighbor(R)
    if N.purpose == "EXIT" then return true end
  end
  return false
end


function ROOM_CLASS.in_floor_limit(R, h)
  if not R.floor_limit then return true end

  return math.in_range(R.floor_limit[1], h, R.floor_limit[2])
end


function ROOM_CLASS.ideal_conns(R)
  -- determine number of connections to try

  if R.shape == "rect" or R.shape == "odd" then
    if R.map_volume <= 4 then
      return 2
    elseif R.map_volume <= rand.sel(30, 8, 9) then
      return 3
    else
      return 4
    end

  else -- shaped room

    if R.shape == "L" or R.shape == "S" then
      return 2
    elseif R.shape == "plus" or R.shape == "H" then
      return 4
    else
      return 3
    end
  end
end


function ROOM_CLASS.big_score(R)
  local score = R.map_volume + 2.5 * gui.random() ^ 2

  -- large bonus for shaped rooms
  if R.shape != "rect" and R.shape != "odd" then
    score = score * 1.7
  end

  return score
end


function ROOM_CLASS.void_up_parts(R)
  if not rand.odds(95) then return end

  -- section list can be modified, need to iterate over a copy
  each K in table.copy(R.sections) do
    if K.sw == 1 and K.sh == 1 and K.shape == "junction" then
      R:remove_section(K)
    end
  end
end


function ROOM_CLASS.pick_floor_mat(R, h)
  -- use same material for same height

-- FIXME !!!!
do return assert(R.floor_mat or R.wall_mat) end

  if not R.floor_mats[h] then
    if R.kind == "outdoor" then
      R.floor_mats[h] = rand.key_by_probs(R.zone.courtyard_floors)
    else
      R.floor_mats[h] = rand.key_by_probs(R.zone.building_floors)
    end
  end

  return R.floor_mats[h]
end


function ROOM_CLASS.pick_ceil_mat(R)
-- FIXME !!!!
do return assert(R.ceil_mat or R.wall_mat) end

  if not R.ceil_mat then
    R.ceil_mat = rand.key_by_probs(R.zone.building_ceilings)
  end

  return R.ceil_mat
end


function ROOM_CLASS.has_walk(R, sx1, sy1, sx2, sy2)
  for sx = sx1,sx2 do for sy = sy1,sy2 do
    local S = SEEDS[sx][sy]
    assert(S)

    if S.is_walk then return true end
  end end

  return false
end


function ROOM_CLASS.straddles_concave_corner(R, sx1, sy1, sx2, sy2)
  -- assumes all seeds in the range belong to this room

  assert(R.sx1 <= sx1 and sx2 <= R.sx2)
  assert(R.sy1 <= sy1 and sy2 <= R.sy2)

  assert(SEEDS[sx1][sy1].room == R)
  assert(SEEDS[sx2][sy2].room == R)

  return (SEEDS[sx1][sy1]:same_room(2) != SEEDS[sx2][sy1]:same_room(2)) or
         (SEEDS[sx1][sy2]:same_room(8) != SEEDS[sx2][sy2]:same_room(8)) or
         (SEEDS[sx1][sy1]:same_room(4) != SEEDS[sx1][sy2]:same_room(4)) or
         (SEEDS[sx2][sy1]:same_room(6) != SEEDS[sx2][sy2]:same_room(6))
end


function ROOM_CLASS.add_exclusion_zone(R, kind, x1, y1, x2, y2, extra_dist)
  local zone =
  {
    kind = kind
    x1 = x1 - (extra_dist or 0)
    y1 = y1 - (extra_dist or 0)
    x2 = x2 + (extra_dist or 0)
    y2 = y2 + (extra_dist or 0)
  }

  table.insert(R.exclusion_zones, zone)
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
  --| the given rectangle is where we _cannot_ have a spot

  assert(x1 < x2)
  assert(y1 < y2)

  -- enlarge the zone a tiny bit
  x1, y1 = x1 - 4, y1 - 4
  x2, y2 = x2 + 4, y2 + 4

  R.mon_spots  = R:clip_spot_list(R.mon_spots,  x1, y1, x2, y2)
  R.item_spots = R:clip_spot_list(R.item_spots, x1, y1, x2, y2)
  R.goal_spots = R:clip_spot_list(R.goal_spots, x1, y1, x2, y2, "strict")
end


function ROOM_CLASS.exclude_monsters_in_zones(R)
  each zone in R.exclusion_zones do
    if zone.kind == "empty" then
      R:clip_spots(zone.x1, zone.y1, zone.x2, zone.y2)
    end
  end
end


function ROOM_CLASS.find_nonfacing_spot(R, x1, y1, x2, y2)
  each zone in R.exclusion_zones do
    if zone.kind == "nonfacing" and
       geom.boxes_overlap(x1,y1, x2,y2, zone.x1,zone.y1, zone.x2,zone.y2)
    then
      local x = (zone.x1 + zone.x2) / 2
      local y = (zone.y1 + zone.y2) / 2

      return { x = x, y = y }
    end
  end

  return nil  -- nothing touches
end


function ROOM_CLASS.num_crossovers(R)
  if R.crossover_hall then return 1 end

  return 0
end


function ROOM_CLASS.mid_point(R)
  local x1 = SEEDS[R.sx1][R.sy1].x1
  local y1 = SEEDS[R.sx1][R.sy1].y1

  local x2 = SEEDS[R.sx2][R.sy2].x2
  local y2 = SEEDS[R.sx2][R.sy2].y2

  return (x1 + x2) / 2, (y1 + y2) / 2
end


function ROOM_CLASS.random_seed(R)
  for loop = 1,999 do
    local sx = rand.irange(R.sx1, R.sx2)
    local sy = rand.irange(R.sy1, R.sy2)

    local S = SEEDS[sx][sy]
    if S.room == R then return S end
  end

  error("failure finding a random seed??")
end


function ROOM_CLASS.init_wall_dists(R)
  for sx = R.sx1, R.sx2 do
  for sy = R.sy1, R.sy2 do
    local S = SEEDS[sx][sy]
    if S.room != R then continue end

    for dir = 1,9 do if dir != 5 then
      if not S:same_room(dir) then
        S.wall_dist = 0.5
      end
    end end -- dir

  end -- sx, sy
  end
end


function ROOM_CLASS.spread_wall_dists(R)
  local changed = false

  for sx = R.sx1, R.sx2 do
  for sy = R.sy1, R.sy2 do
    local S = SEEDS[sx][sy]
    if S.room != R then continue end

    for dir = 2,8,2 do
      if S:same_room(dir) then
        local N = S:neighbor(dir)

        if S.wall_dist and S.wall_dist + 1 < (N.wall_dist or 999) then
          N.wall_dist = S.wall_dist + 1
          changed  = true
        end
      end
    end

  end  -- sx, sy
  end

  return changed
end


function ROOM_CLASS.compute_wall_dists(R)
  R:init_wall_dists()

  while R:spread_wall_dists() do end
end


function ROOM_CLASS.dist_to_edge(R, S, dir)
  local count = 0

  while true do
    local N = S:neighbor(dir)

    if not (N and N.room == R) then return count end

    count = count + 1 ; S = N
  end
end


function ROOM_CLASS.build(R)
  if R.is_outdoor then
    local sky_h = assert(R.sky_group.h)

    each rect in R.sky_rects do
      Build_sky_quad(rect.x1, rect.y1, rect.x2, rect.y2, sky_h)
    end
  end

  Areas_kick_the_goals(R)
end


function Room_distribute_spots(L, list)
  each spot in list do
    if spot.kind == "cage" or spot.kind == "trap" then
      table.insert(L.cage_spots, spot)
    elseif spot.kind == "pickup" or spot.kind == "big_item" then
      table.insert(L.item_spots, spot)
    elseif spot.kind == "goal" then
      if L.kind == "hallway" then
        error("Goal spot used in hallway prefab")
      end
      table.insert(L.goal_spots, spot)
    else
      table.insert(L.mon_spots, spot)
    end
  end
end


function Room_list_no_conns()
  local list = ""

  each R in LEVEL.rooms do
    if #R.conns == 0 then
      list = list .. R.id
      list = list .. " "
    end
  end

  return "{ " .. list .. "}"
end


----------------------------------------------------------------


CLOSET_CLASS = {}

function CLOSET_CLASS.new(kind, parent)
  local CL =
  {
    id = Plan_alloc_id("closet")
    kind = "closet"
    closet_kind = kind
    parent = parent
    conns = {}
  }

  table.set_class(CL, CLOSET_CLASS)
  table.insert(LEVEL.closets, CL)
  return CL
end


function CLOSET_CLASS.tostr(CL)
  return string.format("CLOSET_%d", CL.id)
end


function CLOSET_CLASS.install(CL)
  local K = CL.section

  for sx = K.sx1, K.sx2 do
  for sy = K.sy1, K.sy2 do
    local S = SEEDS[sx][sy]

    assert(not S:used())

    S.closet = CL
  end
  end
end


function CLOSET_CLASS.build(CL)
  local portal = CL.conn.portal1 or CL.conn.portal2
  assert(portal)

  local skin1 = CL.skin

  local skin0 = table.copy(CL.parent.skin)

  if CL.parent.is_outdoor then
    skin0.wall = CL.section.facade
  end

  -- FIXME: test room behind closet for 'outer' field

  -- TODO:  get floor texture from touching area [via portal]

  local skin2 = { }

  if CL.closet_kind == "teleporter" then
    local conn = CL.parent:get_teleport_conn()

    if conn.L1 == CL.parent then
      skin2. in_tag = conn.tele_tag2
      skin2.out_tag = conn.tele_tag1
    else
      skin2. in_tag = conn.tele_tag1
      skin2.out_tag = conn.tele_tag2
    end

    skin2. in_target = string.format("tele%d", skin2. in_tag)
    skin2.out_target = string.format("tele%d", skin2.out_tag)
  end

  if CL.closet_kind == "switch" then
    skin2.tag_1 = CL.parent.purpose_lock.tag
  end

  if CL.closet_kind == "item" then
    skin2.item = assert(CL.item)
  end

  local floor_h = assert(portal.floor_h)

  local x1, y1, x2, y2 = CL.section:get_coords()

  -- align indoor closets with wall
  local dx, dy = 0, 0
  if not CL.parent.is_outdoor then
    if CL.dir == 2 then y1 = y1 - 32 end
    if CL.dir == 4 then x1 = x1 - 32 end
    if CL.dir == 6 then x2 = x2 + 32 end
    if CL.dir == 8 then y2 = y2 + 32 end
  end

  local T = Trans.box_transform(x1, y1, x2, y2, floor_h, CL.dir)

  Fabricate_at(CL.parent, skin1, T, { skin0, skin1, skin2 })

  CL.parent:clip_spots(x1, y1, x2, y2)

--[[
  -- experiment !!
  if CL.parent.kind == "outdoor" and C.floor_h + 208 < CL.parent.sky_h then
    local sky_h = C.floor_h + 192

    brush = Brush_new_quad(C.x1-16, C.y1-16, C.x2+16, C.y2+16, sky_h)

    Brush_set_mat(brush, "_SKY", "_SKY")
    table.insert(brush, 1, { m="sky" })

    brush_helper(brush)
  end
--]]
end


----------------------------------------------------------------


function Room_player_angle(R, C)
  if R.sh > R.sw then
    if (C.sy1 + C.sy2) / 2 > (R.sy1 + R.sy2) / 2 then 
      return 270
    else
      return 90
    end
  else
    if (C.sx1 + C.sx2) / 2 > (R.sx1 + R.sx2) / 2 then 
      return 180
    else
      return 0
    end
  end
end


function Room_select_textures()

  local function select_textures(L)
    local tab

    if L.kind == "outdoor" or L.kind == "cave" then
      tab = L.theme.naturals or THEME.naturals
    else
      tab = L.theme.walls or THEME.walls
    end

    assert(tab)

    -- FIXME: too simple?

    L.wall_mat = rand.key_by_probs(tab)

    if L.kind == "cave" then

      for loop = 1,2 do
        L.floor_mat = rand.key_by_probs(L.theme.floors or tab)
        if L.floor_mat != L.wall_mat then break; end
      end

      if L.is_outdoor then
        L.ceil_mat = "_SKY"
      else
        L.ceil_mat = L.wall_mat
      end

    else
      if L.theme.floors then
        L.floor_mat = rand.key_by_probs(L.theme.floors)
      else
        L.floor_mat = L.wall_mat
      end

      if L.theme.ceilings then
        L.ceil_mat = rand.key_by_probs(L.theme.ceilings)
      else
        L.ceil_mat = L.wall_mat
      end
    end
  end 


  local function setup_skin(L)
    L.skin = {}

    L.skin.wall   = L.wall_mat
    L.skin.facade = L.wall_mat
    L.skin.spike_group = "spike" .. tostring(L.id)

    if L.kind != "outdoor" and L.zone.facade_mat and
       LEVEL.special != "street" -- in street mode, want distinctive buildings
    then
      L.skin.facade = L.zone.facade_mat
    end
  end


  ---| Room_select_textures |---

  each R in LEVEL.rooms do
    select_textures(R)
    setup_skin(R)
  end

  each H in LEVEL.halls do
    select_textures(H)
    setup_skin(H)
  end

--[[
  assign_to_zones("building_walls",    THEME.building_walls)
  assign_to_zones("building_facades",  THEME.building_facades or THEME.building_walls)
  assign_to_zones("building_floors",   THEME.building_floors)
  assign_to_zones("building_ceilings", THEME.building_ceilings)

  assign_to_zones("hallway_walls",    THEME.hallway_walls    or THEME.building_walls)
  assign_to_zones("hallway_floors",   THEME.hallway_floors   or THEME.building_floors)
  assign_to_zones("hallway_ceilings", THEME.hallway_ceilings or THEME.building_ceilings)

  assign_to_zones("courtyard_floors", THEME.courtyard_floors or THEME.building_floors)
--]]

---##  local base_num = 3
---##
---##  -- more variety in large levels
---##  if SECTION_W * SECTION_H >= 30 then
---##    base_num = 4
---##  end
---##
---##  if not LEVEL.building_facades then
---##    LEVEL.building_facades = {}
---##
---##    for num = 1,base_num - rand.sel(75,1,0) do
---##      local name = rand.key_by_probs(THEME.building_facades or THEME.building_walls)
---##      LEVEL.building_facades[num] = name
---##    end
---##  end
---##
---##  if not LEVEL.building_walls then
---##    LEVEL.building_walls = {}
---##
---##    for num = 1,base_num do
---##      local name = rand.key_by_probs(THEME.building_walls)
---##      LEVEL.building_walls[num] = name
---##    end
---##  end
---##
---##  if not LEVEL.building_floors then
---##    LEVEL.building_floors = {}
---##
---##    for num = 1,base_num do
---##      local name = rand.key_by_probs(THEME.building_floors)
---##      LEVEL.building_floors[num] = name
---##    end
---##  end
---##
---##  if not LEVEL.courtyard_floors then
---##    LEVEL.courtyard_floors = {}
---##
---##    if not THEME.courtyard_floors then
---##      LEVEL.courtyard_floors[1] = rand.key_by_probs(THEME.building_floors)
---##    else
---##      for num = 1,base_num do
---##        local name = rand.key_by_probs(THEME.courtyard_floors)
---##        LEVEL.courtyard_floors[num] = name
---##      end
---##    end
---##  end


--???  if not LEVEL.outer_fence_tex then
--???    if THEME.outer_fences then
--???      LEVEL.outer_fence_tex = rand.key_by_probs(THEME.outer_fences)
--???    end
--???  end
end



function Layout_inner_outer_tex(skin, K, K2)
  assert(K)
  if not K2 then return end

  local R = K.room
  local N = K2.room

  if N.kind == "REMOVED" then return end

  skin.wall  = R.skin.wall
  skin.outer = N.skin.wall

  if R.kind == "outdoor" and N.kind != "outdoor" then
    skin.wall  = N.facade or skin.outer
  elseif N.kind == "outdoor" and R.kind != "outdoor" then
    skin.outer = R.facade or skin.wall
  end
end



function Room_match_user_stuff(tab)
  -- 'tab' can be a skin or a group table.
  -- returns a probability multiplier >= 0

  local factor = 1

  local function match(field, user)
    if type(field) == "table" then
      local v = field[user]
      if not v then v = field["other"] or 0 end
      factor = factor * v

    else
      if string.sub(field, 1, 1) == '!' then
        field = string.sub(field, 2)
        if field == user then factor = 0 end
      else
        if field != user then factor = 0 end
      end
    end
  end

  if tab.game  then match(tab.game,  OB_CONFIG.game) end
  if tab.theme then match(tab.theme, LEVEL.super_theme) end
  if tab.psycho and OB_CONFIG.theme != "psycho" then return 0 end

  if factor <= 0 then return 0 end

  if tab.engine   then match(tab.engine,   OB_CONFIG.engine) end
  if tab.playmode then match(tab.playmode, OB_CONFIG.mode) end
 
  if factor <= 0 then return 0 end

  -- style stuff

  if tab.liquid then
    factor = factor * style_sel("liquids", 0, 0.25, 1.0, 3.0)
  end

  if tab.style then
    local list = tab.style
    if type(list) != "table" then
      list = { [list]=1 }
    end

    each name,_ in list do
      if not STYLE[name] then
        error("Unknown style name in prefab skin: " .. tostring(name))
      end

      factor = factor * style_sel(name, 0, 0.25, 1.0, 3.0)
    end
  end

  return factor
end



function Room_matching_skins_for_req(env, reqs)

  local function kind_from_filename(name)
    assert(name)

    local kind = string.match(name, "([%w_]+)/")

    if not kind then
      error("weird skin filename: " .. tostring(name))
    end

    return kind
  end


  local function match_size(env_w, skin_w)
    -- skin defaults to 1
    if not skin_w then skin_w = 1 end

    if type(env_w) == "table" then
      if #env_w != 2 or env_w[1] > env_w[2] then
        error("Bad seed range in env table")
      end

      return env_w[1] <= skin_w and skin_w <= env_w[2]
    end

    return env_w == skin_w
  end


  local function match_size_with_rot(skin, rotate)
    if rotate then
      if env.seed_w and not match_size(env.seed_w, skin.seed_h) then return false end
      if env.seed_h and not match_size(env.seed_h, skin.seed_w) then return false end
    else
      if env.seed_w and not match_size(env.seed_w, skin.seed_w) then return false end
      if env.seed_h and not match_size(env.seed_h, skin.seed_h) then return false end
    end

    return true
  end


  local function match_room_kind(env_k, skin_k)
    if skin_k == "indoor" then
      return env_k != "outdoor"
    end

    return env_k == skin_k
  end


  local function match_word_or_table(req, tab)
    if type(tab) == "table" then
      return tab[req] and tab[req] > 0
    else
      return req == tab
    end
  end


  local function match_requirements(skin)
    -- type check
    local kind = skin.kind or kind_from_filename(skin.file)

    if reqs.kind != kind then return 0 end

    -- placement check
    if reqs.where != skin.where then return 0 end

    -- group check
    if not match_word_or_table(reqs.group, skin.group) then return 0 end

    -- shape check
    if not match_word_or_table(reqs.shape, skin.shape) then return 0 end

    -- complexity check
    if (skin.complexity or 1) > (reqs.max_complexity or 3) then return 0 end

    -- key and switch check
    if reqs.key != skin.key then return 0 end

    if not match_word_or_table(reqs.switch, skin.switch) then return 0 end

    -- hallway stuff
    if reqs.narrow != skin.narrow then return 0 end
    if reqs.door   != skin.door   then return 0 end
    if reqs.secret != skin.secret then return 0 end

    return 1
  end


  local function match_environment(skin)
    -- size check -- seed based
    if not match_size_with_rot(skin, false) then
      if not env.can_rotate then return 0 end
      if not match_size_with_rot(skin, true) then return 0 end
    end

    -- size check -- map units
--!!!! FIXME   if not Fab_size_check(skin, env.long, env.deep) then return 0 end

    -- building type checks
    if skin.room_kind then
      if not match_room_kind(env.room_kind, skin.room_kind) then return 0 end
    end

    if skin.neighbor then
      if not match_room_kind(env.neighbor, skin.neighbor) then return 0 end
    end

    -- door check
    if env.has_door and skin.no_door then return 0 end

    -- liquid check
    if skin.liquid then
      if not LEVEL.liquid then return 0 end
      if skin.liquid == "harmless" and     LEVEL.liquid.damage then return 0 end
      if skin.liquid == "harmful"  and not LEVEL.liquid.damage then return 0 end
    end

    -- darkness check
    if skin.dark_map and not LEVEL.is_dark then return 0 end

    return 1
  end


  ---| Room_matching_skins_for_req |---

  assert(reqs.kind)

  local list = { }

  each name,skin in GAME.SKINS do
    if match_requirements(skin) <= 0 then continue end
    if match_environment (skin) <= 0 then continue end

    -- game, theme (etc) check
    local prob = Room_match_user_stuff(skin)

    prob = prob * (skin.prob or 50) * (reqs.prob_mul or 1)

    if prob > 0 then
      list[name] = prob
    end
  end

  return list
end


function Room_match_skins(env, req_list)
  local list = {}

  each reqs in req_list do
    local list2 = Room_matching_skins_for_req(env, reqs)

    -- ensure earlier matches are kept (override later ones)
    list = table.merge(list2, list)
  end

  return list
end


function Room_pick_skin(env, req_list)
  local list = Room_match_skins(env, req_list)

if DEBUG_MULTI_SKIN then
   DEBUG_MULTI_SKIN = nil
   stderrf("\n\nDEBUG MULTI SKIN = \n%s\n\n", table.tostr(list))
end

  if table.empty(list) then
    gui.debugf("Room_pick_skin:\n")
    gui.debugf("env  = \n%s\n", table.tostr(env))
    gui.debugf("reqs = \n%s\n", table.tostr(reqs))

    error("No matching prefabs for: " .. reqs.kind)
  end

  local name = rand.key_by_probs(list)

  return assert(GAME.SKINS[name])
end



function Room_match_groups(reqs)

  local function match(group)
    -- type check
    if reqs.kind != group.kind then return 0 end

    -- liquid check
    if group.liquid then
      if not LEVEL.liquid then return 0 end
      if group.liquid == "harmless" and     LEVEL.liquid.damage then return 0 end
      if group.liquid == "damaging" and not LEVEL.liquid.damage then return 0 end
    end

    -- hallway stuff
    if group.narrow != group.narrow then return 0 end

    -- game, theme (etc) check
    return Room_match_user_stuff(group)
  end


  local list = { }

  each name,group in GAME.GROUPS do
    local prob = match(group) * (group.prob or 50)

    if prob > 0 then
      list[name] = prob
    end
  end

  return list
end


function Room_pick_group(reqs)
  assert(reqs.kind)

  local list = Room_match_groups(reqs)

  if table.empty(list) then
    gui.debugf("Room_pick_group:\n")
    gui.debugf("reqs = \n%s\n", table.tostr(reqs))

    error("No matching groups for: " .. reqs.kind)
  end

  return rand.key_by_probs(list)
end


----------------------------------------------------------------


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

    for _,sym in ipairs(SYM_LIST) do
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
  end
end



function Room_merge_sky_groups(L1, L2)
  assert(L1.sky_group)
  assert(L2.sky_group)

  if L1.sky_group == L2.sky_group then
    return
  end

  if L1.id > L2.id then L1, L2 = L2, L1 end

  -- the second SKY_GROUP table will never be used again
  local dead_group = L2.sky_group

  dead_group.h = "dead"

  each T in LEVEL.rooms do
    if T.sky_group == dead_group then
       T.sky_group = L1.sky_group
    end
  end

  each T in LEVEL.halls do
    if T.sky_group == dead_group then
       T.sky_group = L1.sky_group
    end
  end
end



function Room_create_sky_groups()

  -- this makes sure that any two outdoor rooms which touch will belong
  -- to the same sky_group and hence get the same sky height.

  -- setup each room

  each R in LEVEL.rooms do
    if R.is_outdoor then
      R.sky_group = { }
    end
  end

  -- merge neighbors which touch each other

  for kx = 1,SECTION_W do
  for ky = 1,SECTION_H do

    local K = SECTIONS[kx][ky]

    if not (K and K.room and K.room.sky_group) then
      continue
    end

    -- only need to test south and west
    for dir = 2,4,2 do
      local N = K:neighbor(dir, dist)

      if not (N and N.room and N.room.sky_group) then
        continue
      end

      Room_merge_sky_groups(N.room, K.room)

    end -- dir

  end -- kx, ky
  end --


  -- Note: sky heights are determined later
end


function OLD_Room_decide_windows()

  local function add_window(K, N, side)
    gui.printf("Window from %s --> %s\n", K:tostr(), N:tostr())

    -- FIXME

    --[[ OLD OLD OLD
    local USAGE =
    {
      kind = "window",
      K1 = K, K2 = N, dir = side
    }

    local E1 = K.edges[side]
    local E2 = N.edges[10-side]

    E1.usage = USAGE
    E2.usage = USAGE
    --]]

    K.room.num_windows = K.room.num_windows + 1
    N.room.num_windows = N.room.num_windows + 1
  end


  local function can_add_window(K, side)
    local N = K:neighbor(side)

    if not N then return false end
    if N.room == K.room then return false end
    if N.room.kind == "REMOVED" then return false end

    local E1 = K.edges[side]
    local E2 = N.edges[10-side]

    if not E1 or not E2 then return false end

    if E1.usage or E2.usage then return false end

    return true
  end


  local function try_add_windows(R, side, prob)
    if STYLE.windows == "few"  and R.num_windows > 0 then return end
    if STYLE.windows == "some" and R.num_windows > 2 then return end

    each K in R.sections do
      local N = K:neighbor(side)

      -- FIXME: sometimes make windows from indoor to indoor

      if can_add_window(K, side) and N.room.kind == "outdoor"
         and rand.odds(prob)
      then
        add_window(K, N, side)      
      end
    end
  end

  
  local function do_windows(R)
    R.num_windows = 0

    if STYLE.windows == "none" then return end

    if R.is_outdoor then return end

    -- TODO: cavey see-through holes
    if R.kind != "building" then return end

    local prob = style_sel("windows", 0, 20, 40, 80+19)

    local SIDES = { 2,4,6,8 }
    rand.shuffle(SIDES)

    for _,side in ipairs(SIDES) do
      try_add_windows(R, side, prob)
    end
  end


  ---| Room_decide_windows |---

  if STYLE.windows == "none" then return end

  each R in LEVEL.rooms do
    do_windows(R)
  end
end



function Room_select_picture(R, v_space, index)
  v_space = v_space - 16
  -- FIXME: needs more v_space checking

  if THEME.logos and rand.odds(sel(LEVEL.has_logo, 7, 40)) then
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

  return nil  -- failed
end


------------------------------------------------------------------------


function ROOM_CLASS.find_closet_spot(R, want_deep)

  local function eval_closet_spot(K, dir)
    -- returns a score, or negative value if not possible at all
    -- 'K' parameter is a section in the room

    local N = K:neighbor(dir)

    if  not N then return -1 end
    if N.used then return -1 end

    local score = gui.random() * 10

    local long, deep = N:long_deep(dir)

    -- FIXME: sections at the edges can go 1 seed deeper

    score = score + deep * 8

    -- prefer edge of map (leave interior hallway channels free)
    -- FIXME but only for START / EXIT closets
    if (geom.is_horiz(dir) and (N.kx <= 2 or N.kx >= SECTION_W - 1)) or
       (geom. is_vert(dir) and (N.ky <= 2 or N.ky >= SECTION_H - 1))
    then
      score = score + 50
    end

    return score
  end

  --- find_closet_spot ---

  local deep = sel(want_deep, 2, 1)  -- FIXME!! not used yet

  local best
  local best_score = -9e9

  each K in R.sections do
    for dir = 2,8,2 do
      local score = eval_closet_spot(K, dir)

-- stderrf("eval_closet_spot @ %s dir:%d --> %1.1f\n", K:tostr(), dir, score)

      if score >= 0 and score > best_score then
        best = { K=K, dir=dir }
        best_score = score
      end
    end
  end

  if best then
    return best.K, best.dir
  end

  return nil
end


function ROOM_CLASS.install_closet(R, K, dir, kind, skin)
  local N = K:neighbor(dir)
  assert(N)

  -- create closet object
  local CL = CLOSET_CLASS.new(kind, R)

  gui.debugf("%s @ %s dir:%d\n", CL:tostr(), N:tostr(), 10 - dir)

  CL.closet_kind = kind
  CL.skin = skin

  CL.section = N
  CL.dir = 10 - dir

  CL.conn_group = R.conn_group  -- keep CONN:add_it() happy

  -- FIXME: assumes a key, need a way to have other items
  if kind == "item" then
    CL.item = R.purpose_lock.key
  end

  -- mark section as used
  N:set_closet(CL)

  CL:install()


  -- create connection
  local D = CONN_CLASS.new("closet", R, CL, dir)

  D.K1 = K
  D.K2 = N

  D:add_it()

  CL.conn = D
end


function ROOM_CLASS.add_closet(R, closet_kind)
  -- check styles
  local STYLE_NAMES =
  {
    trap = "traps"
    secret = "secrets"
  }

  local style_name = STYLE_NAMES[closet_kind] or "closets"

  if style_name then
    local prob = style_sel(style_name, 0, 20, 60, 95)

    if not rand.odds(prob) then return false end
  end


  local env =
  {
    seed_w = 1
    seed_h = 1
    room_kind = R.kind
  }

  local reqs =
  {
    kind  = closet_kind
    where = "closet"
  }

  if closet_kind == "switch" then
    reqs.switch = R.purpose_lock.switch
  end


  local list = Room_match_skins(env, { reqs })

  -- keep trying prefabs until one fits
  while not table.empty(list) do
    local skin_name = rand.key_by_probs(list)
    list[skin_name] = nil

    local skin = GAME.SKINS[skin_name]

    local want_deep = false -- FIXME: proper "can fit" checking
                            -- local long, deep = blah....

    local K, dir = R:find_closet_spot(R, want_deep)

    if not K then continue end

    R:install_closet(K, dir, closet_kind, skin)

    return true  -- OK
  end

  return false  -- nothing worked
end



function Room_add_closets()

  -- handle exit room first (give it priority)
  if LEVEL.exit_room:add_closet("exit") then
    LEVEL.exit_room.purpose_is_done = true
  end

  local room_list = table.copy(LEVEL.rooms)

  -- now do teleporters
  rand.shuffle(room_list)

  each R in room_list do
    if R:has_teleporter() then
      if R:add_closet("teleporter") then
        R.has_teleporter_closet = true
      end
    end
  end

  -- switch closets and key niches
  rand.shuffle(room_list)

  each R in room_list do
    if R.purpose == "SOLUTION" and R.purpose_lock.kind == "SWITCH" then
      if R:add_closet("switch") then
        R.purpose_is_done = true
      end
    end

    if R.purpose == "SOLUTION" and R.purpose_lock.kind == "KEY" then
      if R:add_closet("item") then
        R.purpose_is_done = true
      end
    end
  end

  -- TODO: weapon niches

  -- TODO ITEM / SECRET closets in start room

  -- do the other kinds of closets now, visiting rooms in random order

  for loop = 1,4 do
    rand.shuffle(room_list)

    each R in room_list do

      local kind = rand.key_by_probs { trap=60, secret=10, item=20 }

--!!!!      R:add_closet(kind)
    end
  end      
end



function Room_add_voids()
  each R in LEVEL.rooms do
    if R.kind == "building" then
      R:void_up_parts()
    end
  end
end



function Room_dists_from_entrance()

  local function spread_entry_dist(R)
    local count = 1
    local total = #R.sections

    local K = R.entry_conn:section(R)

--FIXME !!!!!! (broken after hallways)
if not K then K = R.sections[1] end

    K.entry_dist = 0

    while count < total do
      each K in R.sections do
        for side = 2,8,2 do
          local N = K:neighbor(side)
          if N and N.room == R and N.entry_dist then

            local dist = N.entry_dist + 1
            if not K.entry_dist then
              K.entry_dist = dist
              count = count + 1
            elseif dist < K.entry_dist then
              K.entry_dist = dist
            end

          end
        end
      end
    end
  end

  --| Room_dists_from_entrance |--

  each R in LEVEL.rooms do
    if R.entry_conn then
      spread_entry_dist(R)
    else
      each K in R.sections do
        K.entry_dist = 0
      end
    end
  end
end



function OLD__Room_collect_targets(R)

  local targets =
  {
    edges = {},
    corners = {},
    middles = {},
  }

  local function corner_very_free(C)
    if C.usage then return false end

    -- size check (TODO: probably better elsewhere)
    if (C.K.x2 - C.K.x1) < 512 then return false end
    if (C.K.y2 - C.K.y1) < 512 then return false end

    -- check if the edges touching the corner are also free

    each K in R.sections do
      for _,E in pairs(K.edges) do
        if E.corn1 == C and E.usage then return false end
        if E.corn2 == C and E.usage then return false end
      end
    end
  
    return true
  end

  --| Room_collect_targets |--

  for _,M in ipairs(R.middles) do
    if not M.usage then
      table.insert(targets.middles, M)
    end
  end

  for _,K in ipairs(R.sections) do
    for _,C in pairs(K.corners) do
      if not C.concave and corner_very_free(C) then
        table.insert(targets.corners, C)
      end
    end

    for _,E in pairs(K.edges) do
      if not E.usage then
        table.insert(targets.edges, E)
      end
    end
  end

  return targets
end


function Room_sort_targets(targets, entry_factor, conn_factor, busy_factor)
  for _,listname in ipairs { "edges", "corners", "middles" } do
    local list = targets[listname]
    if list then
      for _,E in ipairs(list) do
        E.free_score = E.K.entry_dist * entry_factor +
                       E.K.num_conn   * conn_factor  +
                       E.K.num_busy   * busy_factor  +
                       gui.random()   * 0.1
      end

      table.sort(list, function(A, B) return A.free_score > B.free_score end)
    end
  end
end


------------------------------------------------------------------------



function Room_add_sun()
  -- game check
  if not GAME.ENTITIES["sun"] then return end

  local sun_r = 25000
  local sun_h = 40000

  -- nine lights in the sky, one is "the sun" and the rest are
  -- to keep outdoor areas from getting too dark.

  for i = 1,8 do
    local angle = i * 45 - 22.5

    local x = math.sin(angle * math.pi / 180.0) * sun_r
    local y = math.cos(angle * math.pi / 180.0) * sun_r

    local level = sel(i == 1, 32, 6)

    entity_helper("sun", x, y, sun_h, { light=level })
  end

  entity_helper("sun", 0, 0, sun_h, { light=12 })
end



function Room_intermission_camera()
  -- game check
  if not GAME.ENTITIES["camera"] then return end

  -- determine the room (biggest one, excluding starts and exits)
  local room

  each R in LEVEL.rooms do
    if R.purpose != "START" and R.purpose != "EXIT" and
       R.kind != "cave" and R.kind != "hallway" and not R.is_street
    then
      if not room or (R.kvolume > room.kvolume) then
        room = R
      end
    end
  end

  if not room then room = rand.pick(LEVEL.rooms) end

  -- determine place in room
  local info

  each C in room.chunks do  -- FIXME
    local info2 = C:eval_camera()

    if not info2 then continue end

    if not info or info2.score > info.score then
      info = info2
    end
  end

  -- this should not happen, but just in case...
  if not info then return end

  gui.printf("Camera @ (%d %d %d)\n", info.x1, info.y1, info.z1)

  local x1, y1, z1 = info.x1, info.y1, info.z1
  local x2, y2, z2 = info.x2, info.y2, info.z2

  local dist  = geom.dist(x1,y1, x2,y2)
  local angle = geom.calc_angle(x2 - x1, y2 - y1)
  local mlook = geom.calc_angle(dist, z1 - z2)

  local angles = string.format("%d %d 0", mlook, angle)

  entity_helper("camera", x1, y1, z1, { angles=angles })
end




function Room_ambient_lighting__OLD()

  -- FIXME: probably should pick colors from a list (e.g. ROOM_THEME.colors or THEME.colors)

  local function rand_color()
    local color = rand.irange(10000,10137)
    if color == 10014 then color = color + 1 end
    return color
  end


  local function colorize_loc(L)
    local color

    if L.kind == "outdoor" then
      color = LEVEL.outdoor_color

--- elseif L.kind == "hallway" then
---   color = L.zone.hall_color

    else
      color = rand_color()
    end

    -- caves aren't made of chunks, need special logic for them
    if L.kind == "cave" then

      for sx = L.sx1, L.sx2 do
      for sy = L.sy1, L.sy2 do
        local S = SEEDS[sx][sy]

        if S.room != L then continue end

        raw_add_brush(
        {
          { m = "light", color = color }
          { x = S.x1, y = S.y1 }
          { x = S.x2, y = S.y1 }
          { x = S.x2, y = S.y2 }
          { x = S.x1, y = S.y2 }
        })
      end
      end

    else

      each C in L.chunks do
        raw_add_brush(
        {
          { m = "light", color = color }
          { x = C.x1, y = C.y1 }
          { x = C.x2, y = C.y1 }
          { x = C.x2, y = C.y2 }
          { x = C.x1, y = C.y2 }
        })
      end
    end
  end


  ---| Room_ambient_lighting |---

  if not PARAM.light_brushes then
    return
  end

  -- At the moment this code only colorizes rooms for the Doom64 TC
  if OB_CONFIG.game != "absolution" then return end

  -- whole level has a single outdoor color
  LEVEL.outdoor_color = rand_color()

  -- each zone gets a hall color
  each Z in LEVEL.zones do
    Z.hall_color = rand_color()
  end

  each R in LEVEL.rooms do
    colorize_loc(R)
  end

  each H in LEVEL.halls do
    colorize_loc(H)
  end
end


----------------------------------------------------------------


function Room_place_hub_gates()
  if not LEVEL.hub_links then return end

  local function calc_rough_space(R)
    local space = R.svolume

    if R.purpose then space = space - 4 end

    space = space - 2 * #R.conns

    if R.weapons then
      space = space - 2 * #R.weapons
    end

    -- tie breaker
    space = space - gui.random()

    return space
  end

  local function pick_gate_room()
    return table.pick_best(LEVEL.rooms, function(A, B) return A.rough_space > B.rough_space end)
  end

  --| Room_place_hub_gates |--

  each R in LEVEL.rooms do
    R.rough_space = calc_rough_space(R)
  end

  each link in LEVEL.hub_links do
    if link.src.name == LEVEL.name and link.kind == "branch" then
      local R = pick_gate_room()
      table.insert(R.gates, link)

      R.rough_space = R.rough_space - 4

      gui.debugf("Adding gate to %s @ %s\n", link.dest.name, R:tostr())
    end
  end
end



function Room_analyse_fat_fences()
  -- find places where fat fences are possible (between two outdoor
  -- rooms), and decide whether or not to allow them.
  --
  -- allowing them means that the sky heights of the rooms become
  -- synchronised, and doing this too much can create levels with
  -- overly high skies.

  local seen = { }

  for sx = 1, SEED_W do
  for sy = 1, SEED_TOP do

    local S = SEEDS[sx][sy]

    if S:used() then continue end

    for dir = 2,4,2 do
      local N1 = S:neighbor(dir)
      local N2 = S:neighbor(10 - dir)

      if not (N1 and N1.room) then continue end
      if not (N2 and N2.room) then continue end

      local R1 = N1.room
      local R2 = N2.room

      if R1 == R2 then continue end

      if R1.kind != "outdoor" then continue end
      if R2.kind != "outdoor" then continue end

      -- ok, here is a possible pair.

      -- create a unique id for the pair
      local id1 = math.min(R1.id, R2.id)
      local id2 = math.max(R1.id, R2.id)

      local pair = tostring(id1) .. "_" .. tostring(id2)

      -- already processed this pair of rooms?
      if seen[pair] then continue end

      seen[pair] = true

      if rand.odds(35 - 65) then  --!!!! FIXME
        Room_merge_sky_groups(R1, R2)
      end

    end -- dir

  end  -- sx, sy
  end  --
end



function Room_analyse_outside_joiners()
  -- find joiner hallways which connect two outdoor rooms, and
  -- decide whether or not to allow an "outside" joiner.

  each H in LEVEL.halls do
    if H.is_joiner then
      local R1, R2 = H:joiner_rooms()

      if not (R1.sky_group and R2.sky_group) then continue end

      if rand.odds(35 + 65) then  --!!!!! FIXME
        Room_merge_sky_groups(R1, R2)

        H.sky_group = R1.sky_group
      end
    end
  end
end



function Room_outdoor_borders()
  --
  --  BORDER ALGORITHM
  --
  --  (1) find unused seeds between TWO outdoor rooms and place
  --      "fat_fences" there (or fake buildings or fat cages).
  --
  --      seeds get marked as 'scenic'
  --
  --  (2) at each edge of an outdoor room, check if edge would
  --      touch edge of map if extended (check at least 4 seeds).
  --
  --      mark these seeds and sections as 'border'.
  --
  --         aa./        aa%%
  --         aa./   -->  aa%%
  --         .../        .../
  --
  --  (3) unused seeds which touch two scenic borders at a corner
  --      (and don't touch any rooms) also become scenic border.
  --
  --         aa%%        aa%%
  --         aa%%   -->  aa%%
  --         %%..        %%%%
  --      
  --  (4) everywhere else that an outdoor room touches an unused
  --      seed we need a fake building in that unused seed.
  --      this includes seeds near the scenic_borders of a room.
  --
  --      where a run a these fake-building spots touches (or could
  --      extend to touch) the edge of map, set texture of them all
  --      to the same building (e.g. zone texture of nearest indoor
  --      building).
  --
  --      otherwise get texture from a touching indoor building, or
  --      some fallback method (e.g. zone of touching outdoor room).
  -- 

  local function build_fake_building(env, reqs, x1, y1, x2, y2, dir,
                                     room, facade, floor_h)

    local skin1 = Room_pick_skin(env, { reqs })

    assert(facade)

    local skin2 = { wall=facade }

    if not floor_h then
      floor_h = assert(room.max_floor_h)
    end

    if dir == 1 or dir == 3 or dir == 7 or dir == 9 then
      dir = geom.LEFT_45[dir]
    end

    local T = Trans.box_transform(x1, y1, x2, y2, floor_h, dir)

    Fabricate_at(room, skin1, T, { skin1, skin2 })
  end


  local function add_fat_fence(S, dir)
    local N1 = S:neighbor(dir)
    local N2 = S:neighbor(10 - dir)

    -- require same sky height on each side
    local R1 = N1.room
    local R2 = N2.room

    if R1.sky_group != R2.sky_group then return end

stderrf("fat fence @ %s dir:%d\n", S:tostr(), dir)

    -- mark as used
    S.border = { kind = "fat_fence" }

    local floor_h = math.max(R1.max_floor_h, R2.max_floor_h)

    -- find matching prefab
    local env =
    {
      seed_w = 1
      seed_h = 1
    }

    local reqs =
    {
      kind   = "fake"
      shape  = "I"
    }

    build_fake_building(env, reqs, S.x1, S.y1, S.x2, S.y2, dir,
                        R1, S.facade, floor_h)
  end


  local function find_fat_fences()
    for sx = 1, SEED_W do
    for sy = 1, SEED_TOP do
      local S = SEEDS[sx][sy]

      if S:used() then continue end

      local cat_str = ""

      for dir = 2,8,2 do
        local N = S:neighbor(dir)

        if not N then continue end

        -- FIXME !!!  check that seed edge is "walk" or "liquid"

        if N.room and N.room.kind == "outdoor" then
          cat_str = cat_str .. tostring(dir)
        end
      end

      local cat_dir

      if cat_str == "46" then cat_dir = rand.sel(50, 4, 6) end
      if cat_str == "28" then cat_dir = rand.sel(50, 2, 8) end

      -- FIXME: support 2x1 or 3x1 size (find runs)

      if cat_dir then
        add_fat_fence(S, cat_dir)
      end
    end end
  end


  local function extends_to_edge(S, dir, try_num, no_side_check)
    local perp_dir = geom.RIGHT[dir]

    for i = 0, try_num do
      local N = S:neighbor(dir, i)

      if not N then break; end

      if N:used() then return false end

      if no_side_check then continue end

      local A = N:neighbor(perp_dir)
      local B = N:neighbor(10 - perp_dir)

      if A.room and A.room.kind == "outdoor" then return false end
      if B.room and B.room.kind == "outdoor" then return false end
    end

    return true
  end


  local function do_mark_border(B)
    for sx = B.sx1, B.sx2 do
    for sy = B.sy1, B.sy2 do
      SEEDS[sx][sy].border = B
    end
    end

    table.insert(LEVEL.borders, B)
  end


  local function unmark_border(B)
    for sx = B.sx1, B.sx2 do
    for sy = B.sy1, B.sy2 do
      SEEDS[sx][sy].border = nil
    end
    end

    B.kind = "invalid"

    table.kill_elem(LEVEL.borders, B)
  end


  local function try_mark_edge_group(SA, sx, sy, dir, room)
    local along_dir = geom.vert_sel(dir, 6, 8)
    local found = 0

    for i = 0, 99 do
      local S = SA:neighbor(along_dir, i)

      if not S or S:used() then break; end
      if not S:neighbor(10 - dir) then break; end

      if not extends_to_edge(S, 10 - dir, 3) then break; end

      local N = S:neighbor(dir)

      if not (N and N.room == room) then break; end

      found = found + 1
    end

    if found == 0 then return end

    -- determine seed bbox
    local sx2, sy2

    if geom.is_horiz(dir) then
      if dir == 6 then sx = sx - 1 end
      sx2 = sx + 1
      sy2 = sy + found - 1
    else
      if dir == 8 then sy = sy - 1 end
      sy2 = sy + 1
      sx2 = sx + found - 1
    end

    local BORDER =
    {
      kind = "edge"
      dir  = dir
      room = room

      sx1  = sx
      sy1  = sy
      sx2  = sx2
      sy2  = sy2
    }

    do_mark_border(BORDER)
  end


  local function outdoor_edges()
    local mid_x1 = 8
    local mid_y1 = 8
    local mid_x2 = SEED_W - 8
    local mid_y2 = SEED_TOP - 8

    for sx = 1, SEED_W do
    for sy = 1, SEED_TOP do
      
      -- skip middle of level (speed up large maps)
      if mid_x1 <= sx and sx <= mid_x2 and
         mid_y1 <= sy and sy <= mid_y2
      then continue end

      local S = SEEDS[sx][sy]

      if S:used() then continue end

      for dir = 2,8,2 do
        local N = S:neighbor(dir)

        if not N then continue end
        if not (N.room and N.room.kind == "outdoor") then continue end

        try_mark_edge_group(S, sx, sy, dir, N.room)
      end

    end -- sx, sy
    end
  end


  local function corner_is_free(S, dir)
    local T = S:neighbor(10 - dir)

    if not T then return false end

    local sx1 = math.min(S.sx, T.sx)
    local sy1 = math.min(S.sy, T.sy)
    local sx2 = math.max(S.sx, T.sx)
    local sy2 = math.max(S.sy, T.sy)

    for sx = sx1, sx2 do
    for sy = sy1, sy2 do
      local N = SEEDS[sx][sy]

      if not N or N:used() then return false end
    end
    end

    return true
  end


  local function outdoor_outies()
    -- an "outie" is a corner sitting at a 270 degree bend in the room
    -- (whereas normal corners sit at a 90 degree bend).

    local mid_x1 = 8
    local mid_y1 = 8
    local mid_x2 = SEED_W - 8
    local mid_y2 = SEED_TOP - 8

    for sx = 1, SEED_W do
    for sy = 1, SEED_TOP do
      
      -- skip middle of level (speed up large maps)
      if mid_x1 <= sx and sx <= mid_x2 and
         mid_y1 <= sy and sy <= mid_y2
      then continue end

      local S = SEEDS[sx][sy]

      if S:used() then continue end

      for dir = 1,9,2 do if dir != 5 then
        local N = S:neighbor(dir)

        if not N then continue end
        if not (N.room and N.room.kind == "outdoor") then continue end

        if not corner_is_free(S, dir) then continue end

        local L_dir = geom. LEFT_45[dir]
        local R_dir = geom.RIGHT_45[dir]

        local N2 = S:neighbor(L_dir)
        local N3 = S:neighbor(R_dir)

        if not (N2 and N2.room == N.room and
                N3 and N3.room == N.room)
        then continue end

        local N4 = N2:neighbor(10 - R_dir)
        local N5 = N3:neighbor(10 - L_dir)

        if not (N4 and N4.room == N.room and
                N5 and N5.room == N.room)
        then continue end

        if not extends_to_edge(S, 10 - R_dir, 3, "noside") or
           not extends_to_edge(S, 10 - L_dir, 3, "noside")
        then continue end

        local SL = S:neighbor(10 - L_dir)
        local SR = S:neighbor(10 - R_dir)

        if not (SL and SR) then continue end

        if not extends_to_edge(SL, 10 - R_dir, 3) or
           not extends_to_edge(SR, 10 - L_dir, 3)
        then continue end

        local T = S:neighbor(10 - dir)

stderrf("\n****** OUTIE @ %s dir:%d\n\n", S:tostr(), dir)

        local BORDER =
        {
          kind = "outie"
          dir  = dir
          room = N.room

          sx1  = math.min(S.sx, T.sx)
          sy1  = math.min(S.sy, T.sy)
          sx2  = math.max(S.sx, T.sx)
          sy2  = math.max(S.sy, T.sy)
        }

        do_mark_border(BORDER)

      end end  -- dir

    end -- sx, sy
    end
  end


  local function validate_outies()
    -- we require outies to mate up with normal borders on the two sides

    each B in table.copy(LEVEL.borders) do
      if B.kind == "outie" then

        local L_dir = 10 - geom. LEFT_45[B.dir]
        local R_dir = 10 - geom.RIGHT_45[B.dir]

        local bad = false

        for sx = B.sx1, B.sx2 do
        for sy = B.sy1, B.sy2 do

          local S = SEEDS[sx][sy]

          if (L_dir == 2 and sy == B.sy1) or
             (L_dir == 8 and sy == B.sy2) or
             (L_dir == 4 and sx == B.sx1) or
             (L_dir == 6 and sx == B.sx2)
          then
            local N = S:neighbor(L_dir)

            if not (N.border and N.border.kind != "fat_fence") then bad = true end
          end
          
          if (R_dir == 2 and sy == B.sy1) or
             (R_dir == 8 and sy == B.sy2) or
             (R_dir == 4 and sx == B.sx1) or
             (R_dir == 6 and sx == B.sx2)
          then
            local N = S:neighbor(R_dir)

            if not (N.border and N.border.kind != "fat_fence") then bad = true end
          end

        end -- sx, sy
        end

        if bad then
          unmark_border(B)
        end
      end
    end
  end


  local function find_border_mate(sx1, sy1, sx2, sy2, side, room)
    each B in LEVEL.borders do
      if B.room != room then continue end

      if geom.is_horiz(side) then
        
        if B.sy1 != sy1 then continue end
        if B.sy2 != sy2 then continue end

        if side == 4 and B.sx2 == sx1 - 1 then return B end
        if side == 6 and B.sx1 == sx2 + 1 then return B end
      
      else  -- vert

        if B.sx1 != sx1 then continue end
        if B.sx2 != sx2 then continue end

        if side == 2 and B.sy2 == sy1 - 1 then return B end
        if side == 8 and B.sy1 == sy2 + 1 then return B end
      end
    end

    return nil  -- not found
  end


  local function outdoor_corners()
    local mid_x1 = 8
    local mid_y1 = 8
    local mid_x2 = SEED_W - 8
    local mid_y2 = SEED_TOP - 8

    for sx = 1, SEED_W do
    for sy = 1, SEED_TOP do
      
      -- skip middle of level (speed up large maps)
      if mid_x1 <= sx and sx <= mid_x2 and
         mid_y1 <= sy and sy <= mid_y2
      then continue end

      local S = SEEDS[sx][sy]

      if S:used() then continue end

      for dir = 1,9,2 do if dir != 5 then
        local N = S:neighbor(dir)

        if not N then continue end
        if not (N.room and N.room.kind == "outdoor") then continue end

        if not corner_is_free(S, dir) then continue end

        -- look for edge borders that mate up with this corner

        local T = S:neighbor(10 - dir)

        local sx1 = math.min(S.sx, T.sx)
        local sy1 = math.min(S.sy, T.sy)
        local sx2 = math.max(S.sx, T.sx)
        local sy2 = math.max(S.sy, T.sy)

        local L_dir = geom. LEFT_45[dir]
        local R_dir = geom.RIGHT_45[dir]

        if find_border_mate(sx1, sy1, sx2, sy2, L_dir, N.room) and
           find_border_mate(sx1, sy1, sx2, sy2, R_dir, N.room)
        then
          -- OK --

          local BORDER =
          {
            kind = "corner"
            dir  = dir
            room = N.room

            sx1  = sx1
            sy1  = sy1
            sx2  = sx2
            sy2  = sy2
          }

          do_mark_border(BORDER)

          break;
        end

      end end  -- dir

    end -- sx, sy
    end
  end


  local function try_vert_betweener(B1, side, B2)
    if B1.sy1 != B2.sy1 then return end
    if B1.sy2 != B2.sy2 then return end

    if side == 4 and B2.sx2 != B1.sx1 - 2 then return end
    if side == 6 and B2.sx1 != B1.sx2 + 2 then return end

    -- may be possible : check seeds in-between them

    local sx = sel(side == 4, B1.sx1 - 1, B1.sx2 + 1)

    local sy = sel(B1.dir == 2, B1.sy1, B1.sy2)

    local S = SEEDS[sx][sy]

    if not extends_to_edge(S, 10 - B1.dir, 3) then return end

    -- OK, so enlarge B1 (the edge border)

    if side == 4 then
      B1.sx1 = B1.sx1 - 1
    else
      B1.sx2 = B1.sx2 + 1
    end

    for ny = B1.sy1, B1.sy2 do
      SEEDS[sx][ny].border = B1
    end
  end


  local function try_horiz_betweener(B1, side, B2)
    if B1.sx1 != B2.sx1 then return end
    if B1.sx2 != B2.sx2 then return end

    if side == 2 and B2.sy2 != B1.sy1 - 2 then return end
    if side == 8 and B2.sy1 != B1.sy2 + 2 then return end

    -- may be possible : check seeds in-between them

    local sy = sel(side == 2, B1.sy1 - 1, B1.sy2 + 1)

    local sx = sel(B1.dir == 4, B1.sx1, B1.sx2)

    local S = SEEDS[sx][sy]

    if not extends_to_edge(S, 10 - B1.dir, 3) then return end

    -- OK, so enlarge B1 (the edge border)

    if side == 2 then
      B1.sy1 = B1.sy1 - 1
    else
      B1.sy2 = B1.sy2 + 1
    end

    for nx = B1.sx1, B1.sx2 do
      SEEDS[nx][sy].border = B1
    end
  end


  local function outdoor_betweeners()
    -- Example:
    --        aa bb       aa bb
    --        %% %%  -->  %%%%%
    --        %% %%       %%%%%

    each B1 in LEVEL.borders do
      
      -- we want edge borders, since we can enlarge them easily
      if B1.kind != "edge" then continue end

      each B2 in LEVEL.borders do
        if geom.is_vert(B1.dir) then
          try_vert_betweener(B1, 4, B2)
          try_vert_betweener(B1, 6, B2)
        else
          try_horiz_betweener(B1, 2, B2)
          try_horiz_betweener(B1, 8, B2)
        end
      end
    end
  end


  local function build_border_fab(B, sx1, sy1, sx2, sy2, shape)
    local S1 = SEEDS[sx1][sy1]
    local S2 = SEEDS[sx2][sy2]

    local cw = sx2 - sx1 + 1
    local ch = sy2 - sy1 + 1

    assert(cw <= 2 and ch <= 2)

    if geom.is_horiz(B.dir) then
      cw, ch = ch, cw
    end

    -- find matching prefab
    local env =
    {
      seed_w = cw
      seed_h = ch
    }

    local reqs =
    {
      kind   = "border"
      group  = LEVEL.border_group
      shape  = shape
    }

    local skin1 = Room_pick_skin(env, { reqs })

    local skin2 = { wall=S1.facade }

    local x1, y1 = S1.x1, S1.y1
    local x2, y2 = S2.x2, S2.y2

    local floor_h = assert(B.room.max_floor_h)

    local dir = B.dir
    if dir == 1 or dir == 3 or dir == 7 or dir == 9 then
      dir = geom.LEFT_45[dir]
    end

    local T = Trans.box_transform(x1, y1, x2, y2, floor_h, dir)

    Fabricate_at(B.room, skin1, T, { skin1, skin2 })
  end


  local function build_border_edge(B, sx1, sy1, sx2, sy2)
    -- edge can be very wide (or tall) -- need to split it

    local cw = sx2 - sx1 + 1
    local ch = sy2 - sy1 + 1

    while cw > 2 do
      local w = rand.sel(75, 2, 1)

      build_border_fab(B, sx1, sy1, sx1 + w - 1, sy2, "T")

      sx1 = sx1 + w
       cw =  cw - w
    end
      
    while ch > 2 do
      local h = rand.sel(75, 2, 1)

      build_border_fab(B, sx1, sy1, sx2, sy1 + h - 1, "T")

      sy1 = sy1 + h
       ch =  ch - h
    end
      
    build_border_fab(B, sx1, sy1, sx2, sy2, "T")
  end


  local function build_borders()
    each B in LEVEL.borders do
      
      if B.kind == "edge" then
        build_border_edge(B, B.sx1, B.sy1, B.sx2, B.sy2)

      elseif B.kind == "corner" then
        build_border_fab(B, B.sx1, B.sy1, B.sx2, B.sy2, "C")

      elseif B.kind == "outie" then
        build_border_fab(B, B.sx1, B.sy1, B.sx2, B.sy2, "O")

      end
    end
  end


  local function touches_outdoor_or_border(S, dir)
    local N = S:neighbor(dir)

    if not N then return nil end

    if N.room and N.room.kind == "outdoor" then return N.room end

    -- Note: border check is disabled, since some prefabs (esp. Cages)
    --       do not work well against a border prefab.
    do return nil end

    if not N.border then return nil end

    if N.border.kind != "edge" then return nil end

    -- hits _back_ of the edge border?
    if dir == N.border.dir then return nil end

    return N.border.room  -- OK
  end


  local function try_fake_corner_at_seed(S, pass)
    for dir = 1,9,2 do if dir != 5 then
      local N = S:neighbor(dir)

      if not N then continue end
      if not (N.room and N.room.kind == "outdoor") then continue end

      local L_dir = geom. LEFT_45[dir]
      local R_dir = geom.RIGHT_45[dir]

      -- only allow borders in second pass

      if pass == 1 then
        local N2 = S:neighbor(L_dir)
        local N3 = S:neighbor(R_dir)

        if not (N2 and N2.room and N2.room == N.room) then continue end
        if not (N3 and N3.room and N3.room == N.room) then continue end

      else
        if touches_outdoor_or_border(S, L_dir) != N.room then continue end
        if touches_outdoor_or_border(S, R_dir) != N.room then continue end
      end

      -- OK --

      -- mark as used
      S.border = { kind = "fake_building" }

      local env =
      {
        seed_w = 1
        seed_h = 1
      }

      local reqs =
      {
        kind   = "fake"
        shape  = "C"
      }

      build_fake_building(env, reqs, S.x1, S.y1, S.x2, S.y2, dir,
                          N.room, S.facade)

      return true

    end end  -- dir

    return false
  end


  local function fake_corners()
    for sx = 1, SEED_W do
    for sy = 1, SEED_TOP do
      local S = SEEDS[sx][sy]

      if S:used() then continue end

      if not try_fake_corner_at_seed(S, 1) then
             try_fake_corner_at_seed(S, 2)
      end

    end -- sx, sy
    end
  end


  local function try_run_of_fake_edges(SA, sx, sy, dir, room)
    local along_dir = geom.vert_sel(dir, 6, 8)
    local found = 0

    for i = 0, 99 do
      local S = SA:neighbor(along_dir, i)

      if not S or S:used() then break; end

      if touches_outdoor_or_border(S, dir) != room then break; end

      found = found + 1
    end

    if found == 0 then return end

    -- OK --

    local SZ = SA:neighbor(along_dir, found - 1)

    local sx1 = math.min(sx, SZ.sx)
    local sy1 = math.min(sy, SZ.sy)
    local sx2 = math.max(sx, SZ.sx)
    local sy2 = math.max(sy, SZ.sy)

    SA = SEEDS[sx1][sy1]
    SZ = SEEDS[sx2][sy2]

--    Build_solid_quad(SA.x1, SA.y1, SZ.x2, SZ.y2, "COMPBLUE")

    -- mark as used
    for sx = sx1, sx2 do
    for sy = sy1, sy2 do
      SEEDS[sx][sy].border = { kind = "fake_building" }

        local S = SEEDS[sx][sy]

        local env =
        {
          seed_w = 1
          seed_h = 1
        }

        local reqs =
        {
          kind   = "fake"
          shape  = "F"
        }

        build_fake_building(env, reqs, S.x1, S.y1, S.x2, S.y2, dir,
                            room, S.facade)
    end
    end
  end


  local function fake_edges()
    for sx = 1, SEED_W do
    for sy = 1, SEED_TOP do
      local S = SEEDS[sx][sy]

      if S:used() then continue end

      for dir = 2,8,2 do
        local room = touches_outdoor_or_border(S, dir)

        if not room then continue end

        try_run_of_fake_edges(S, sx, sy, dir, room)
      end

    end -- sx, sy
    end
  end


  local function fill_remaining_seeds()
    -- this is mainly to fix the borders of Sky Halls
    -- (or other unintended gaps in the geometry)

    for sx = 1, SEED_W do
    for sy = 1, SEED_TOP do
      local S = SEEDS[sx][sy]

      if S:used() then continue end

      Build_solid_quad(S.x1, S.y1, S.x2, S.y2, S.facade)
    end
    end
  end


  ---| Room_outdoor_borders |---

  -- decide the border group now
  LEVEL.border_group = Room_pick_group({ kind = "border" })

  gui.printf("Border group: %s\n", LEVEL.border_group)

  LEVEL.borders = {}

  find_fat_fences()

  outdoor_outies()
  outdoor_edges()
  outdoor_corners()

  -- betweeners are disabled, since we want border prefabs which are
  -- open at the sides, and enabling betweeners would allow the player
  -- to travel into rooms they shouldn't be able to get to.
  if false then
    outdoor_betweeners()
  end

  validate_outies()

  Plan_dump_rooms("Border Map:")

  build_borders()

  fake_corners()
  fake_edges()

  fill_remaining_seeds()
end



function Room_reckon_doors()

  local  indoor_prob = style_sel("doors", 0, 10, 30,  90, 100)
  local outdoor_prob = style_sel("doors", 0, 30, 90, 100, 100)


  local function room_cost(L)
    if L.kind == "hallway" then return 5 end
    if L.kind == "cave" then return sel(L.is_outdoor, 4, 3) end
    return sel(L.is_outdoor, 2, 1)
  end


  local function visit_conn(D)
    -- locked doors are handled already
    if D.lock then return end

    if D.kind == "teleporter" then return end
    if D.kind == "closet"     then return end
    if D.kind == "secret"     then return end

    -- for double halls, only decide a single side (the left)
    if D.kind == "double_R"   then return end

    local L1 = D.L1
    local L2 = D.L2

    if L1.is_outdoor and L2.is_outdoor then return end

    local P1 = D.portal1
    local P2 = D.portal2

    if room_cost(L1) > room_cost(L2) then
      L1, L2 = L2, L1
      P1, P2 = P2, P1
    end

    assert(L1.kind != "hallway")


    if not P1 then return end


    -- we nearly always want an arch (if no door)
    P1.door_kind = "arch"


    -- don't add two doors to a short hallway
    if L2.kind == "hallway" then
      if #L2.sections <= 2 and L2.has_a_door then return end

      if L2.is_joiner then return end
    end


    -- apply the random check
    if L1.is_outdoor then
      if not rand.odds(outdoor_prob) then return end
    else
      if not rand.odds(indoor_prob) then return end
    end

    -- OK --

    P1.door_kind = "door"

    L1.has_a_door = true
    L2.has_a_door = true
  end


  ---| Room_reckon_doors |---

  each D in LEVEL.conns do
    visit_conn(D)
  end
end



function Room_decide_fences()

  local function check_room_pair(R1, R2, S, N)
    if R1.quest == R2.quest then return end

    if R1.quest.id > R2.quest.id then
      R1, R2 = R2, R1
       S, N  =  N, S
    end

    -- at here, R1 is an earlier quest than R2

    if R1.max_floor_h + PARAM.jump_height + 14 < R2.min_floor_h then
      -- cannot reach R2 from R1 due to height difference
      return
    end
 
-- stderrf("need fence @ %s (bordering %s)\n", R1:tostr(), R2:tostr())

    R1.fences[R2.id] = { kind="low", R1=R1, R2=R2 }
  end


  local function do_fences(R)
    for sx = R.sx1, R.sx2 do for sy = R.sy1, R.sy2 do
      local S = SEEDS[sx][sy]
      if S.room != R then continue end

      -- only check two directions (south and west)
      for dir = 2,4,2 do
        local N = S:neighbor(dir)

        if not (N and N.room) or N.room == R then continue end

        if N.room.kind != "outdoor" then continue end

        check_room_pair(R, N.room, S, N) 
      end
    end end
  end


  ---| Room_decide_fences |---

  gui.debugf("Room_decide_fences.........\n")

  each R in LEVEL.rooms do
    if R.kind == "outdoor" then
      do_fences(R)
    end
  end
end



function Room_blow_chunks()
  each R in LEVEL.rooms do
    R:build()
  end

  each H in LEVEL.halls do
    H:build()
  end

  each CL in LEVEL.closets do
    CL:build()
  end
end



function Room_build_all()

  gui.printf("\n--==| Build Rooms |==--\n\n")

  gui.prog_step("Rooms");

  Room_select_textures()

---!!!  Room_setup_symmetry()

  Room_place_hub_gates()

  Hallway_divide_sections()

  Areas_handle_connections()

  Room_reckon_doors()

  Room_create_sky_groups()
  Room_analyse_fat_fences()
  Room_analyse_outside_joiners()

  Areas_flesh_out()

  Room_outdoor_borders()
---??  Room_ambient_lighting()

  Room_blow_chunks()

  Room_add_sun()
  Room_intermission_camera()
end

