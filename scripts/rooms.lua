----------------------------------------------------------------
--  Room Management
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2012 Andrew Apted
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
                  -- "cave"     : natural room
                  -- "outdoor"  : room with sky
                  -- "hallway"  : corridor / passage

  shape : keyword -- "rect" (perfect rectangle)
                  -- "L"  "T"  "U"  "S"  "H"
                  -- "plus"
                  -- "odd" (everything else)

  scenic  : bool  -- true for scenic (unvisitable) rooms

  conns : list(CONN)  -- connections with neighbor rooms

  entry_conn : CONN  -- the main connection used to enter the room
  exit_conn  : CONN  -- the main unlocked connection which exits the room

  branch_kind : keyword

  symmetry : keyword   -- symmetry of room, or NIL
                       -- keywords are "x", "y", "xy"

  sx1, sy1, sx2, sy2  -- \ Seed range
  sw, sh, svolume     -- /

  chunks : list(CHUNK)  -- all chunks in the room
###  entry_chunk : CHUNK

  kx1, ky1, kx2, ky2  -- \ Section range
  kw, kh              -- /

  sections : list  -- all sections of room

  crossover_hall : HALLWAY  -- if present, a hallway crosses over this room

  floor_limit : { low, high }  -- a limitation of floor heights


  quest : QUEST

  purpose : keyword   -- usually NIL, can be "EXIT" etc... (FIXME)

  weapons : list(NAME)  -- weapons to add into room

  fences[ROOM ID] : FENCE  -- what fences that this room has to make
                           -- at the border to other outdoor rooms.
                           -- NIL for none.

???  floor_h, ceil_h : number

  cave_map : CAVE  -- the generated cave / maze

  conn_group : number  -- traversibility group (used for Connect logic)

  sky_group : number  -- outdoor rooms which directly touch will belong
                      -- to the same sky_group (unless a solid wall is
                      -- enforced, e.g. between zones).
}


class CLOSET
{
  kind : keyword  -- "closet"  (differentiates from room types)

  closet_kind : keyword  -- "START", "EXIT"
                         -- "secret", "trap"

  parent : ROOM  -- parent room

  entry_conn : CONN  -- connection to parent room

  dir : 2/4/6/8

  chunk : CHUNK


???   sx1, sy1, sx2, sy2  -- \ Seed range
???   sw, sh, svolume     -- /
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
  rooms : list(ROOM)

  sky_h : number  -- the final sky height for the group
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
    chunks = {}
    sections = {}
    middles = {}
    spaces = {}
    floor_mats = {}

    gates = {}
    fences = {}

    num_windows = 0

    mon_spots  = {}
    item_spots = {}
    cage_spots = {}
    trap_spots = {}

    prefabs = {}
    blocks  = {}
    decor   = {}
    exclusion_zones = {}
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

  if K.kind == "section" then
    R.map_volume = (R.map_volume or 0) + 1
  end
end


function ROOM_CLASS.fill_section(R, K)
  for sx = K.sx1,K.sx2 do for sy = K.sy1,K.sy2 do
    local S = SEEDS[sx][sy]
    assert(not S.hall)

    S.room = K.room
    S.section = K
  end end

  if not R.sx1 or K.sx1 < R.sx1 then R.sx1 = K.sx1 end
  if not R.sy1 or K.sy1 < R.sy1 then R.sy1 = K.sy1 end
  if not R.sx2 or K.sx2 > R.sx2 then R.sx2 = K.sx2 end
  if not R.sy2 or K.sy2 > R.sy2 then R.sy2 = K.sy2 end

  R:update_size()

  R.svolume = (R.svolume or 0) + (K.sw * K.sh)
end


function ROOM_CLASS.annex(R, K)
  K:set_room(R)

  K.kind = "annex"

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


function ROOM_CLASS.has_sky_neighbor(R)
  each D in R.conns do
    local N = D:neighbor(R)
    if N.kind == "outdoor" then return true end
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


function ROOM_CLASS.can_alloc_chunk(R, sx1, sy1, sx2, sy2)
  if sx1 < R.sx1 or sx2 > R.sx2 then return false end
  if sy1 < R.sy1 or sy2 > R.sy2 then return false end
 
  for sx = sx1, sx2 do for sy = sy1, sy2 do
    local S = SEEDS[sx][sy]
    if S.room != R then return false end
    if S.chunk or S.void then return false end
  end end

  return true
end


function ROOM_CLASS.alloc_chunk(R, sx1, sy1, sx2, sy2)
  assert(R.sx1 <= sx1 and sx1 <= sx2 and sx2 <= R.sx2)
  assert(R.sy1 <= sy1 and sy1 <= sy2 and sy2 <= R.sy2)

  local C = CHUNK_CLASS.new(sx1, sy1, sx2, sy2)

  C.room = R

  table.insert(R.chunks, C)

  C:install()

  return C
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


function ROOM_CLASS.add_exclusion_zone(R, x1, y1, x2, y2, extra_dist)
  local ZONE =
  {
    x1 = x1 - (extra_dist or 0)
    y1 = y1 - (extra_dist or 0)
    x2 = x2 + (extra_dist or 0)
    y2 = y2 + (extra_dist or 0)
  }

  table.insert(R.exclusion_zones, ZONE)
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


function ROOM_CLASS.dump_areas(R)
  local function seed_char(x, y)
    local S = SEEDS[x][y]

    if not S or S.room != R then return ' ' end
    if not S.chunk then return '!' end

    if S.chunk.liquid then return '~' end
    if S.chunk.scenic then return '#' end

    local A = S.chunk.area

    if not A then return '.' end
    if not A.id then return '?' end

    local n = 1 + ((A.id - 1) % 26)

    return string.sub("abcdefghijklmnopqrstuvwxyz", n, n)
  end

  gui.debugf("AREAS IN %s @ (%d %d) :\n", R:tostr(), R.sx1, R.sy1)

  for y = R.sy2, R.sy1, -1 do
    local line = "  "

    for x = R.sx1, R.sx2 do
      line = line .. seed_char(x, y)
    end

    gui.debugf("%s\n", line)
  end

  gui.debugf("\n")
end


function Rooms_distribute_spots(L, list)
  each spot in list do
    if spot.kind == "cage" then
      table.insert(L.cage_spots, spot)
    elseif spot.kind == "trap" then
      table.insert(L.trap_spots, spot)
    else
      table.insert(L.mon_spots, spot)
    end
  end
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


function CLOSET_CLASS.build(CL)
  local C = assert(CL.chunk)

  local skin_name = rand.key_by_probs(CL.skins)

  local skin0 = table.copy(CL.parent.skin)
  local skin1 = assert(GAME.SKINS[skin_name])
  local skin2 = {}

  -- FIXME !!  get floor texture from touching area

  if CL.parent.kind == "outdoor" then
    -- FIXME: this won't match neighboring walls
    skin0.wall = CL.parent.zone.facade_mat
  end

  if CL.closet_kind == "TELEPORTER" then
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

  assert(C.floor_h)

  local T = Trans.box_transform(C.x1, C.y1, C.x2, C.y2, C.floor_h, 10 - CL.dir)

  Fabricate(skin1._prefab, T, { skin0, skin1, skin2 })

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


function OLD__Rooms_setup_theme(R)
  R.skin = {}

  R.skin.spike_group = "spike" .. tostring(R.id)

  if R.kind == "cave" then
    assert(THEME.cave_walls)
    R.main_tex = rand.key_by_probs(THEME.cave_walls)
    R.skin.wall = R.main_tex
    assert(R.main_tex)
    return
  end

  if not R.kind == "outdoor" then
    R.main_tex = rand.key_by_probs(R.zone.building_walls)
    R.skin.wall = R.main_tex
    assert(R.main_tex)
    return
  end

  if not R.quest.courtyard_floor then
    R.quest.courtyard_floor = rand.key_by_probs(R.zone.courtyard_floors)
  end

  R.main_tex = R.quest.courtyard_floor

  R.skin.wall = R.main_tex
end


function Rooms_select_textures()

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
      L.ceil_mat = rand.sel(15, "_SKY", L.wall_mat)
      for loop = 1,2 do
        L.floor_mat = rand.key_by_probs(L.theme.floors or tab)
        if L.floor_mat != L.wall_mat then break; end
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

    if L.kind != "outdoor" and L.zone.facade_mat then
      L.skin.facade = L.zone.facade_mat
    end
  end


  ---| Rooms_select_textures |---

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



function Rooms_setup_symmetry()
  -- The 'symmetry' field of each room already has a value
  -- (from the big-branch connection system).  Here we choose
  -- whether to keep that, expand it (rare) or discard it.
  --
  -- The new value applies to everything made in the room
  -- (as much as possible) from now on.

  local function prob_for_match(old_sym, new_sym)
    if old_sym == new_sym then
      return (old_sym == "xy" ? 8000 ; 400)

    elseif new_sym == "xy" then
      -- rarely upgrade from NONE --> XY symmetry
      return (old_sym ? 30 ; 3)

    elseif old_sym == "xy" then
      return 150

    else
      -- rarely change from X --> Y or vice versa
      return (old_sym ? 6 ; 60)
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

    R.symmetry = (index > 1 ? syms[index] ; nil)
  end


  --| Rooms_setup_symmetry |--

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



function Rooms_collect_sky_groups()

  -- this makes sure that any two outdoor rooms which touch will belong
  -- to the same sky_group and hence get the same sky height.

  local outdoor_rooms = {}


  local function init_sky_groups()
    each R in LEVEL.rooms do
      if R.kind == "outdoor" then
        table.insert(outdoor_rooms, R)
        R.sky_group = _index
      end
    end
  end


  local function merge_groups(id1, id2)
    if id1 > id2 then id1,id2 = id2,id1 end

    gui.debugf("merge_sky_groups: %d --> %d\n", id2, id1)

    each R in outdoor_rooms do
      if R.sky_group == id2 then
        R.sky_group = id1
      end
    end
  end


  local function spread_sky_groups()
    -- returns true if there was a change, false on no changes.

    -- TODO: we may need to include the simple (one section) hallways
    --       between two outdoor rooms, as it might be nice to allow
    --       some "open top" prefabs to connect them.

    local changes = false

    for kx = 1,SECTION_W do for ky = 1,SECTION_H do
      local K = SECTIONS[kx][ky]

      if not (K and K.room and K.room.kind == "outdoor") then
        continue
      end

      -- only need to test south and west
      for dir = 2,4,2 do
        local N = K:neighbor(dir)

        if not (N and N.room and N.room.kind == "outdoor") then
          continue
        end

        if N.room.sky_group != K.room.sky_group then
          merge_groups(N.room.sky_group, K.room.sky_group)
        end

        changes = true

      end -- for dir
    end end -- for kx, ky

    return changes
  end


  ---| Rooms_synchronise_skies |---

  init_sky_groups()

  for loop = 1,20 do
    if not spread_sky_groups() then
      break;
    end
  end

  -- collect all the sky groups
  LEVEL.sky_groups = {}

  gui.debugf("\nSky group list:\n")

  each R in outdoor_rooms do
    gui.debugf("%d @ %s\n", R.sky_group, R:tostr())

    local group = LEVEL.sky_groups[R.sky_group]

    if not group then
      group = { rooms={} }
      LEVEL.sky_groups[R.sky_group] = group
    end

    table.insert(group.rooms, R)

    -- change the ID number to a group reference
    R.sky_group = group
  end
end


function OLD_Rooms_decide_windows()

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

---    if R.outdoor or R.semi_outdoor then return end

    -- TODO: cavey see-through holes
    if R.kind != "building" then return end

    local prob = style_sel("windows", 0, 20, 40, 80+19)

    local SIDES = { 2,4,6,8 }
    rand.shuffle(SIDES)

    for _,side in ipairs(SIDES) do
      try_add_windows(R, side, prob)
    end
  end


  ---| Rooms_decide_windows |---

  if STYLE.windows == "none" then return end

  each R in LEVEL.rooms do
    do_windows(R)
  end
end



function Room_select_picture(R, v_space, index)
  v_space = v_space - 16
  -- FIXME: needs more v_space checking

  if THEME.logos and rand.odds((LEVEL.has_logo ? 7 ; 40)) then
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
    if (geom.is_horiz(dir) and (N.kx == 1 or N.kx == SECTION_W)) or
       (geom. is_vert(dir) and (N.ky == 1 or N.ky == SECTION_W))
    then
      score = score + 50
    end

    return score
  end

  --- find_closet_spot ---

  local deep = (want_deep ? 2 ; 1)  -- FIXME!! not used yet

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


function ROOM_CLASS.add_closet(R, closet_kind)
  local source_tab

      if closet_kind == "START" then source_tab = THEME.starts
  elseif closet_kind == "EXIT"  then source_tab = THEME.exits
  elseif closet_kind == "ITEM"  then source_tab = THEME.pedestals
  elseif closet_kind == "TRAP"  then source_tab = THEME.traps
  elseif closet_kind == "SECRET" then source_tab = THEME.secrets
  elseif closet_kind == "TELEPORTER" then source_tab = THEME.teleporters
  elseif closet_kind == "HUB_GATE" then source_tab = THEME.hub_gates
  else
    error("Bad closet kind: " .. tostring(closet_kind))
  end

  if not source_tab then return false end

  local list = Rooms_filter_skins(R, closet_kind .. "-closets", source_tab,
                                  { where="closet" }, "empty_ok")

  if table.empty(list) then return false end


  -- pick location to attach closet to room
  local want_deep = (kind == "START" or kind == "EXIT" or rand.odds(10))

  local K, dir = R:find_closet_spot(R, want_deep)

  if not K then return false end

  -- !!!! FIXME : only pick prefabs that can fit
  -- local long, deep = blah....
  -- list = Rooms_filter_skins(R, closet_kind .. "-closets", list,
  --                           { where="closet", long=long, deep=deep })

  local N = K:neighbor(dir)

  -- create closet object
  local CL = CLOSET_CLASS.new(closet_kind, R)

  gui.debugf("%s @ %s dir:%d\n", CL:tostr(), N:tostr(), 10-dir)

  CL.dir = 10 - dir
  CL.section = N
  CL.skins = list

  CL.conn_group = R.conn_group  -- keep D:add_it() happy

  -- mark section as used
  N:set_closet(CL)

  -- create connection
  local D = CONN_CLASS.new("closet", R, CL, dir)

  D.K1 = K
  D.K2 = N

  D:add_it()

  return true
end



function Rooms_add_closets()

  -- handle exit room first (give it priority)
  if LEVEL.exit_room:add_closet("EXIT") then
    LEVEL.exit_room.has_exit_closet = true
  end

  -- now do teleporters
  each R in LEVEL.rooms do
    if R:has_teleporter() then
      if R:add_closet("TELEPORTER") then
        R.has_teleporter_closet = true
      end
    end
  end

  -- TODO ITEM / SECRET closets in start room

  -- do the other kinds of closets now, visiting rooms in random order
  local room_list = table.copy(LEVEL.rooms)

  for loop = 1,4 do
    rand.shuffle(room_list)

    each R in room_list do
      local kind = rand.key_by_probs { TRAP=60, SECRET=10, ITEM=20 }

      R:add_closet(kind)
    end
  end      
end



function Rooms_dists_from_entrance()

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

  --| Rooms_dists_from_entrance |--

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



function Rooms_collect_targets(R)

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

  --| Rooms_collect_targets |--

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


function Rooms_sort_targets(targets, entry_factor, conn_factor, busy_factor)
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


function OLD__Rooms_place_importants()  -- NOT USED

  local function clear_busyness(R)
    each K in R.sections do
      K.num_busy = 0
    end
  end


  local function pick_target(R, usage)
    local prob_tab = {}

    if #R.targets.edges > 0 and usage.edge_fabs then
      prob_tab["edge"] = #R.targets.edges * 5
    end
    if #R.targets.corners > 0 and usage.corner_fabs then
      prob_tab["corner"] = #R.targets.corners * 3
    end
    if #R.targets.middles > 0 and usage.middle_fabs then
      prob_tab["middle"] = #R.targets.middles * 11
    end

    if table.empty(prob_tab) then
      error("could not place important stuff in room!")
    end

    local what = rand.key_by_probs(prob_tab)

    if what == "edge" then

      local edge = table.remove(R.targets.edges, 1)
      edge.usage = usage

--stderrf("EDGE %s:%d ---> USAGE %s %s\n", edge.K:tostr(), edge.side, usage.kind, usage.sub or "-")

      edge.K.num_busy = edge.K.num_busy + 1

    elseif what == "corner" then

      local corner = table.remove(R.targets.corners, 1)
      corner.usage = usage

      corner.K.num_busy = corner.K.num_busy + 1

    else assert(what == "middle")

      local middle = table.remove(R.targets.middles, 1)
      middle.usage = usage

      middle.K.num_busy = middle.K.num_busy + 1

    end
  end


  local function place_importants(R)
    -- determine available places
    R.targets = Rooms_collect_targets(R, edges, corners, middles)

    if R.purpose then
      Rooms_sort_targets(R.targets, 1, -0.6, -0.2)

      local USAGE =
      {
        kind = "important",
        sub  = R.purpose,
        lock = R.purpose_lock,
      }

      local list

      if R.purpose == "START" then
        list = THEME.starts

      elseif R.purpose == "EXIT" then
        list = THEME.exits

      elseif R.purpose == "SOLUTION" then

        if R.purpose_lock.kind == "KEY" then
          list = THEME.pedestals
        elseif R.purpose_lock.kind == "SWITCH" then
          -- Umm WTF ??
          list = "SWITCH"
        else
          error("Unknown purpose_lock.kind: " .. tostring(R.purpose_lock.kind))
        end

      else
        error("Unknown room purpose: " .. tostring(R.purpose))
      end

      Layout_possible_fab_group(USAGE, list)

      pick_target(R, USAGE)

      -- FIXME: cheap hack, should just remove the invalidated targets
      --        (a bit complicated since corners use the nearby edges
      --         and hence one can invalidate the other)
      R.targets = Rooms_collect_targets(R, edges, corners, middles)
    end

    Rooms_sort_targets(R.targets, 0.4, -1, -0.8)

    if R:has_teleporter() then
      local USAGE =
      {
        kind = "important",
        sub  = "teleporter",
      }

      Layout_possible_fab_group(USAGE, THEME.teleporters)

      pick_target(R, USAGE)

      R.targets = Rooms_collect_targets(R, edges, corners, middles)
    end


    -- ??? TODO: weapon (currently added by pickup code)

  end


  --| Rooms_place_importants |--

  Rooms_dists_from_entrance()

  each R in LEVEL.rooms do
    clear_busyness(R)
    place_importants(R)
  end
end



function Rooms_bound_outdoor_areas()
end



------------------------------------------------------------------------



function Rooms_player_angle(R, C)
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



function Rooms_add_sun()
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

    local level = (i == 1 ? 32 ; 6)

    entity_helper("sun", x, y, sun_h, { light=level })
  end

  entity_helper("sun", 0, 0, sun_h, { light=12 })
end



function Rooms_intermission_camera()
  -- game check
  if not GAME.ENTITIES["camera"] then return end

  -- determine the room (biggest one, excluding starts and exits)
  local room

  each R in LEVEL.rooms do
    if R.purpose != "START" and R.purpose != "EXIT" and
       R.kind != "cave" and R.kind != "hallway" and not R.street
    then
      if not room or (R.kvolume > room.kvolume) then
        room = R
      end
    end
  end

  if not room then room = rand.pick(LEVEL.rooms) end

  -- determine place in room
  local info

  each C in room.chunks do
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



function Rooms_blow_chunks()

  each H in LEVEL.halls do
    H:pick_group()
  end

  each R in LEVEL.rooms do
    each C in R.chunks do
      C:build()
    end
  end

  -- scenic rooms ??

  each H in LEVEL.halls do
    H:build()
  end

  each CL in LEVEL.closets do
    CL:build()
  end
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



function Rooms_filter_skins(L, tab_name, tab, reqs, empty_ok)
  assert(tab)
  
  local function match(skin)
    -- placement check
    if reqs.where and skin._where != reqs.where then return false end

    -- size check
    if not Fab_size_check(skin, reqs.long, reqs.deep) then return false end

    -- building type checks
    if L then
      if skin._cave     and skin._cave     != convert_bool(L.kind == "cave")     then return false end
      if skin._outdoor  and skin._outdoor  != convert_bool(L.kind == "outdoor")  then return false end
      if skin._building and skin._building != convert_bool(L.kind == "building") then return false end
      if skin._hallway  and skin._hallway  != convert_bool(L.kind == "hallway")  then return false end
    end

    -- liquid check
    if skin._liquid and not LEVEL.liquid then return false end

    -- key and switch check
    if skin._key != reqs.key then return false end

    if skin._switch != reqs.switch then
      if not (reqs.switch and skin._switches) then return false end
      if not skin._switches[reqs.switch] then return false end
    end

    -- hallway stuff
    if skin._shape != reqs.shape then return false end

    if reqs.narrow and not skin._narrow then return false end

    return true
  end

  local result = {}

  each name,prob in tab do
    local skin = GAME.SKINS[name]

    if not skin then
      error("No such skin: " .. tostring(name) .. " in: " .. tab_name)
    end

    if match(skin) then
      result[name] = prob
    end
  end

  if table.empty(result) and not empty_ok then
    error("No matching prefab for: " .. tab_name)
  end

  return result
end



function Layout_possible_fab_group(usage, list, req_key)
  usage.edge_fabs   = Layout_possible_prefab_from_list(list, "edge",   req_key)
  usage.corner_fabs = Layout_possible_prefab_from_list(list, "corner", req_key)
  usage.middle_fabs = Layout_possible_prefab_from_list(list, "middle", req_key)

  if not usage.edge_fabs and not usage.corner_fabs and not usage.middle_fabs then
    error("Theme is missing usable prefabs for: " .. tostring("XXX"))
  end
end


function Layout_possible_windows(E)
  if E.usage.K1.room.kind == "outdoor" and E.usage.K2.room.kind == "outdoor" then
    list = THEME.fences
  else
    list = THEME.windows
  end

  E.usage.edge_fabs = Layout_possible_prefab_from_list(list, "edge")
end



function OLD__Layout_spots_in_room(R)

  local function remove_prefab(fab)
    -- OPTIMISE: do a bbox check

    for _,B in ipairs(fab.brushes) do
      if B[1].m == "solid" then
        -- TODO: height check
        gui.spots_fill_poly(B, 1)
      end
    end
  end


  local function remove_decor(dec)
    if dec.info.pass then return end

    -- TODO: height check???

    local x1 = dec.x - dec.info.r - 2
    local y1 = dec.y - dec.info.r - 2
    local x2 = dec.x + dec.info.r + 2
    local y2 = dec.y + dec.info.r + 2

    gui.spots_fill_poly(Brush_new_quad(x1,y1, x2,y2), 2)
  end


  local function remove_neighbor_floor(floor, N)
    -- FIXME
  end


  local function spots_for_floor(floor)
    local bbox = assert(floor.bbox)

    -- begin with a completely solid area
    gui.spots_begin(bbox.x1, bbox.y1, bbox.x2, bbox.y2, 2)

    -- carve out the floor brushes (make them empty)
    for _,B in ipairs(floor.brushes) do
      gui.spots_fill_poly(B, 0)
    end

    -- solidify brushes from prefabs
    for _,fab in ipairs(R.prefabs) do
      remove_prefab(fab)
    end

    -- remove solid decor entities
    for _,dec in ipairs(R.decor) do
      remove_decor(dec)
    end

    -- mark edges with neighboring floors
    for _,F in ipairs(R.all_floors) do
      if F != floor then
        remove_neighbor_floor(floor, F)
      end
    end

--  gui.spots_dump("Spot grid")

    -- use local lists, since we will process multiple floors
    local mon_spots  = {}
    local item_spots = {}

    gui.spots_get_mons (mon_spots)
    gui.spots_get_items(item_spots)

    gui.spots_end()

    -- set Z positions

    for _,spot in ipairs(mon_spots) do
      spot.z1 = floor.z
      spot.z2 = floor.z2 or (spot.z1 + 200)  -- FIXME

      table.insert(R.mon_spots, spot)
    end

    for _,spot in ipairs(item_spots) do
      spot.z1 = floor.z
      spot.z2 = floor.z2 or (spot.z1 + 64)

      table.insert(R.item_spots, spot)
    end

--[[  TEST
    for _,spot in ipairs(R.item_spots) do
      entity_helper("potion", spot.x1 + 8, spot.y1 + 8, 0)
    end
--]]
  end


  local function distribute_spots(list)
    for _,spot in ipairs(list) do
      if spot.kind == "cage" then
        table.insert(R.cage_spots, spot)
      elseif spot.kind == "trap" then
        table.insert(R.trap_spots, spot)
      end
    end
  end


  local function cage_trap_spots()
    for _,fab in ipairs(R.prefabs) do
      if fab.has_spots then
        distribute_spots(Fab_read_spots(fab))
      end
    end
  end


  ---| Layout_spots_in_room |---

  -- collect spots for the monster code
  for _,F in ipairs(R.all_floors) do
    spots_for_floor(F)
  end

  cage_trap_spots()
end


function OLD__Layout_all_ceilings()

  local function is_middle(K)
    if K:same_room(2) and K:same_room(8) then return true end
    if K:same_room(4) and K:same_room(6) then return true end
    return false
  end

  local function quake_temp_lights(R)
    each K in R.sections do
     if is_middle(K) then
      local z = R.ceil_h - rand.pick { 50, 80, 110, 140 }
      local light = rand.pick { 50, 100, 150, 200 }
      local radius = ((K.x2 - K.x1) + (K.y2 - K.y1)) / 3

      local x, y = geom.box_mid(K.x1, K.y1, K.x2, K.y2)

      raw_add_entity { id="light", x=x, y=y, z=z, light=light, _radius=radius }
     end
    end
  end


  local function build_ceiling(R)
    if R.sky_h then
      each K in R.sections do
        Trans.quad(K.x1, K.y1, K.x2, K.y2, R.sky_h, nil, Mat_normal("_SKY"))
      end

      return
    end

    assert(R.ceil_h)

    local mat = rand.key_by_probs(THEME.building_ceilings)

    local props, w_face, p_face = Mat_normal(mat)

    for _,K in ipairs(R.sections) do
      local x1, y1, x2, y2 = Layout_shrunk_section_coords(K)
      Trans.quad(x1, y1, x2, y2, R.ceil_h, nil, { m="solid" }, w_face, p_face)
    end

    if R.shape == "rect" and R.sw >= 3 and R.sh >= 3 then
      local K1 = SECTIONS[R.kx1][R.ky1]
      local K2 = SECTIONS[R.kx2][R.ky2]

      local mx, my = geom.box_mid(K1.x1, K1.y1, K2.x2, K2.y2)

      local T = Trans.spot_transform(mx, my, R.ceil_h)

---???   Fabricate("SKYLITE_1", T, {{ trim="WIZWOOD1_5", metal="WIZMET1_2" }})
    else
      if GAME.format == "quake" then
        quake_temp_lights(R)
      end
    end
  end


  local function ambient_lighting(R)
    if not (GAME.format == "doom" or GAME.format == "nukem") then
      return
    end

    local light = rand.pick { 128, 144, 160 }
    if R.kind == "outdoor" then light = 192 end

    each K in R.sections do
      raw_add_brush(
      {
        { m="light", ambient=light },
        { x=K.x1, y=K.y1 },
        { x=K.x2, y=K.y1 },
        { x=K.x2, y=K.y2 },
        { x=K.x1, y=K.y2 },
      })
    end
  end


  --| Layout_all_ceilings |--

  Rooms_synchronise_skies()

  each R in LEVEL.rooms do
    build_ceiling(R)
    ambient_lighting(R)

    Layout_spots_in_room(R)
  end
end



----------------------------------------------------------------


function Rooms_place_gates()
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

  --| Rooms_place_gates |--

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



function ROOM_CLASS.add_cage_or_trap(R, fab)
  local spots = Fab_read_spots(fab)

  each spot in spots do
    if spot.kind == "cage" then
      table.insert(R.cage_spots, spot)
    elseif spot.kind == "trap" then
      table.insert(R.trap_spots, spot)
    end
  end
end



function Rooms_fake_building(sx1, sy1, sx2, sy2, kind, dir, face_room, zone)
  -- mark it
  for sx = sx1,sx2 do for sy = sy1,sy2 do
    local S = SEEDS[sx][sy]

    S.scenic = true
    S.fake_zone = zone
    S.edge_of_map = nil
  end end

  local x1 = SEEDS[sx1][sy1].x1
  local y1 = SEEDS[sx1][sy1].y1

  local x2 = SEEDS[sx2][sy2].x2
  local y2 = SEEDS[sx2][sy2].y2

  local mat = assert(zone.facade_mat)

-- stderrf("Rooms_fake_building @ (%d %d) .. (%d %d) : %s\n", sx1, sy1, sx2, sy2, kind)

  -- cages!
  local cage_prob = style_sel("cages", 0, 10, 30, 80)

  if face_room and face_room.purpose != "START" and
     THEME.fat_cages and rand.odds(cage_prob)
  then
    if not LEVEL.fat_cage_kind then
      LEVEL.fat_cage_kind = rand.key_by_probs(THEME.fat_cages)
    end

    local skin1 = assert(GAME.SKINS[LEVEL.fat_cage_kind])

    -- FIXME: use nearby floors 
    local f_h = face_room.max_floor_h + 48
    local c_h = face_room.sky_h

    local cage_h = skin1._cage_h or 208  -- FIXME

    gui.debugf("Trying cage @ %s: f_h=%d c_h=%d\n", face_room:tostr(), f_h, c_h)

    if f_h - c_h >= cage_h then
      if not R.cage_floor_h then
        R.cage_floor_h = rand.sel(75, f_h, c_h - cage_h)
      end
      f_h = R.cage_floor_h
    end
    
    local skin2 = { sky_ofs=face_room.sky_h - f_h, wall=mat }

    local T = Trans.box_transform(x1, y1, x2, y2, f_h, 10 - dir)

    local fab = Fabricate(skin1._prefab, T, { skin1, skin2 })

    face_room:add_cage_or_trap(fab)
    return
  end

  local brush = Brush_new_quad(x1, y1, x2, y2)
  Brush_set_mat(brush, mat)
  brush_helper(brush)
end



function OLD_____Rooms_fake_corner(R, S, corner, B)
stderrf("FAKE CORNER @ %s corner:%d\n", S:tostr(), corner)

  -- mark it
  S.scenic = true
  S.edge_of_map = nil

  local mat = assert(B.zone.facade_mat)

  local f_h = -512

  local T = Trans.corner_transform(S.x1, S.y1, S.x2, S.y2, f_h, corner, 192, 192)

  local skin1 = GAME.SKINS["Fat_Outside_Corner1"]

  if not skin1 then
    Rooms_fake_building(S.sx, S.sy, S.sx, S.sy, geom.LEFT_45[corner], B, false)
    return
  end

  local skin2 = { sky_h=R.sky_h - f_h, wall=mat }

  Fabricate(skin1._prefab, T, { skin1, skin2 })
end



function Rooms_outdoor_borders()
  --
  --  BORDER ALGORITHM
  --
  --  (1) find all unused seeds which border TWO outdoor rooms (or more).
  --      place fake buildings there ('scenic' field in seeds).
  --
  --  (2) flood fill the 'edge_of_map' flag in seeds.
  --
  --      [any fake buildings will prevent the flag spreading]
  --
  --  (3) analyse from edge : if hit an indoor (or fake) AND touches
  --      an outdoor room, then place fake buildings all the way to edge.
  --
  --      [at this point, all 'edge_of_map' seeds should only touch
  --       a single outdoor room]
  --
  --  (4) find all unused non-edge seeds which border ONE outdoor room,
  --      place fake buildings there.  Same code for step (1) but with
  --      a different check and probably different prefabs.
  --
  --  (5) scan around edges of each outdoor room, place sky fences
  --      in unused 'edge_of_map' seeds.  Place sky corners only where
  --      a seed places a fence in two directions (e.g. 2 and 4).
  --

  local function categorize_touches(T)
    local cat, dir = Trans.categorize_linkage(T[2], T[4], T[6], T[8])
     
    assert(cat != "N")

    return cat, dir
  end


  local function scan_for_unused_seeds(pass)
    for sx = 1, SEED_W do for sy = 1, SEED_TOP do
      local S = SEEDS[sx][sy]

      if S:used() then continue end

      if pass == 2 and S.edge_of_map then continue end

      local outdoors = {}
      local touches  = {}
      local zone

      for dir = 2,8,2 do
        local N = S:neighbor(dir)

        if not N then continue end

        if N.room and N.room.kind == "outdoor" then
          table.add_unique(outdoors, N.room)
          touches[dir] = N.room
        end

        local N_zone

        if N.room and N.room.kind != "outdoor" then N_zone = N.room.zone
        elseif N.hall then N_zone = N.hall.zone
        elseif N.fake_zone then N_zone = N.fake_zone
        end

        if N_zone and (not zone or N_zone.id < zone.id) then
          zone = N_zone
        end
      end

      if (pass == 1 and #outdoors >= 2) or
         (pass == 2 and #outdoors == 1)
      then
        local t_kind, t_dir = categorize_touches(touches)

        local face_room = rand.pick(outdoors)

        Rooms_fake_building(S.sx, S.sy, S.sx, S.sy, t_kind, t_dir,
                            face_room, zone or face_room.zone)
      end
    end end
  end


  local function check_touches_outdoor(S, dir)
    -- we check 90 degrees to the left and right of 'dir'.
    -- if found, returns a table mapping DIR --> ROOM.
    -- otherwise returns NIL.

    local dir1 = geom. LEFT[dir]
    local dir2 = geom.RIGHT[dir]

    local P1 = S:neighbor(dir1)
    local P2 = S:neighbor(dir2)

    local touch1 = P1 and P1.room and P1.room.kind == "outdoor"
    local touch2 = P2 and P2.room and P2.room.kind == "outdoor"

    if touch1 or touch2 then
      local dirs = {}

      if touch1 then dirs[dir1] = P1.room end
      if touch2 then dirs[dir2] = P2.room end

      return dirs
    end

    return nil
  end

  
  local function are_touches_same(T1, T2)
    for dir = 2,8,2 do
      if (T1[dir] and 1) != (T2[dir] and 1) then
        return false
      end
    end

    return true
  end


  local function fake_building_from_edge(sx, sy, dir, max_dist)
    local S = SEEDS[sx][sy]

    if not S.edge_of_map then return end

    local count  -- number of seeds from edge to fill
    local building

    local touches = {}

    touches[1] = check_touches_outdoor(S, dir)

    -- look for a building near the edge
    for i = 1,max_dist do
      local N = S:neighbor(dir, i)

      if not N then return end

      touches[i+1] = check_touches_outdoor(N, dir)

      if N.hall then
        building = N.hall ; count = i
        break
      end

      if N.room then
        -- hit an outdoor room, this case is handled by other code
        if N.room.kind == "outdoor" then return end

        building = N.room ; count = i
        break
      end

      if N.scenic or N.chunk then
        -- FIXME: remember previous fake building, grab it here
        building = LEVEL.rooms[1] ; count = i
        break
      end

      if not N.edge_of_map then return end
    end

    -- no building found?
    if not building then return end

    for i = 1,count do
      local N1 = S:neighbor(dir, i-1)
      local N2 = S:neighbor(dir, i)

      if touches[i] == "skip" then
        continue

      elseif not touches[i] then
        Rooms_fake_building(N1.sx, N1.sy, N1.sx, N1.sy, "X", 2,
                            nil, building.zone)
      else

        -- Note: a bit overkill, always "F" with current logic
        local t_kind, t_dir = categorize_touches(touches[i])

        local sx1, sy1 = N1.sx, N1.sy
        local sx2, sy2 = N1.sx, N1.sy

        if i < count and touches[i+1] and are_touches_same(touches[i], touches[i+1]) then
          touches[i+1] = "skip"

          sx1 = math.min(sx1, N2.sx)
          sy1 = math.min(sy1, N2.sy)

          sx2 = math.max(sx2, N2.sx)
          sy2 = math.max(sy2, N2.sy)
        end

        local dir1 = geom.LEFT [dir]
        local dir2 = geom.RIGHT[dir]

        local face_room = touches[i][dir1] or touches[i][dir2]

        Rooms_fake_building(sx1, sy1, sx2, sy2, t_kind, t_dir,
                            face_room, building.zone)
      end
    end
  end


  local function analyse_edges()
    local max_w = int(SEED_W   / 2)
    local max_h = int(SEED_TOP / 2)

    for sx = 2, SEED_W-1 do
      fake_building_from_edge(sx, 1, 8, max_h)
      fake_building_from_edge(sx, SEED_TOP, 2, max_h)
    end

    for sy = 2, SEED_TOP-1 do
      fake_building_from_edge(1, sy, 6, max_w)
      fake_building_from_edge(SEED_W, sy, 4, max_w)
    end
  end


  local function make_sky_fence(R, S, dir)
    local skin = R.skin
    assert(skin)

    local sky_fence_h = assert(R.max_floor_h)

    local skin2 = { sky_h = R.sky_h - sky_fence_h }

    local T = Trans.box_transform(S.x1, S.y1, S.x2, S.y2, sky_fence_h, dir)

    Fabricate("SKY_FENCE", T, { skin, skin2 })
  end


  local function make_sky_corner(R, S, dir)
    local skin = R.skin
    assert(skin)

    local sky_fence_h = assert(R.max_floor_h)

    local skin2 = { sky_h = R.sky_h - sky_fence_h }

        if dir == 9 then dir = 2
    elseif dir == 1 then dir = 8
    elseif dir == 7 then dir = 6
    elseif dir == 3 then dir = 4
    end

    local T = Trans.box_transform(S.x1, S.y1, S.x2, S.y2, sky_fence_h, dir)

    Fabricate("SKY_CORNER", T, { skin, skin2 })
  end


  local function handle_side(R, S, dir)
    local N = S:neighbor(dir)
    assert(N)

    if not N.edge_of_map then return false end

    assert(not N:used())

    make_sky_fence(R, N, dir)

    return true
  end


  local function handle_corner(R, S, dir)
    local N = S:neighbor(dir)
    assert(N)

    if not N.edge_of_map then return false end

    assert(not N:used())

    make_sky_corner(R, N, dir)

    return true
  end


  local function scan_room(R)
    for sx = R.sx1, R.sx2 do for sy = R.sy1, R.sy2 do
      local S = SEEDS[sx][sy]
        
      if S.room != R then continue end

      local which_dirs = {}

      for dir = 2,8,2 do
        if handle_side(R, S, dir) then
          which_dirs[dir] = true
        end
      end

      -- check for corners
      for corner = 1,9,2 do if corner ~= 5 then
        if which_dirs[geom.LEFT_45 [corner]] and
           which_dirs[geom.RIGHT_45[corner]]
        then
          handle_corner(R, S, corner)
        end
      end end  -- corner

    end end -- sx, sy
  end


  local function OLD__check_fake_corner(S)
    local open_dirs = {}

    for dir = 2,8,2 do
      local N = S:neighbor(dir)

      if N and N.room and N.room.kind == "outdoor" then
        table.insert(open_dirs, dir)
      end
    end

    --!!!! FIXME: special handling if >= 3
    if #open_dirs != 2 then return nil end

    local dir1 = open_dirs[1]
    local dir2 = open_dirs[2]

    if dir1 > dir2 then dir1, dir2 = dir2, dir1 end

    -- FIXME: special handling for dir1 == (10 - dir2)

    if dir1 == 2 and dir2 == 4 then return 9 end
    if dir1 == 2 and dir2 == 6 then return 7 end
    if dir1 == 4 and dir2 == 8 then return 3 end
    if dir1 == 6 and dir2 == 8 then return 1 end

    return nil
  end


  local function OLD__touches_start(list, info)
    local T = list[1]

    if geom.is_vert(T.dir) then
      return (info.N.sy == T.N.sy) and
             (info.N.sx == T.N.sx - 1)
    else
      return (info.N.sx == T.N.sx) and
             (info.N.sy == T.N.sy - 1)
    end
  end


  local function OLD__touches_end(list, info)
    local T = list[#list]

    if geom.is_vert(T.dir) then
      return (info.N.sy == T.N.sy) and
             (info.N.sx == T.N.sx + 1)
    else
      return (info.N.sx == T.N.sx) and
             (info.N.sy == T.N.sy + 1)
    end
  end


  local function OLD__collect_fake_row(R)
    -- find a group of touching seeds which would become a fake building

    if table.empty(R.fake_buildings) then return nil end

    local list = {}
    local dir

    list[1] = table.remove(R.fake_buildings)

    local added

    repeat
      added = false

      for index = #R.fake_buildings, 1, -1 do
        local info = R.fake_buildings[index]

        if info.dir != list[1].dir then continue end

        if touches_start(list, info) then
          table.remove(R.fake_buildings, index)
          table.insert(list, 1, info)
          added = true
        elseif touches_end(list, info) then
          table.remove(R.fake_buildings, index)
          table.insert(list, info)
          added = true
        end
      end

    until not added

    return list
  end


  local function OLD__building_on_side_of_row(row, sx1, sy1, sx2, sy2, delta)
    local sx, sy
    local dir = row[1].dir  -- dir faces out of room

    if geom.is_vert(dir) then
      sx = (delta < 0 ? sx1 - 1 ; sx2 + 1)
      sy = sy1
    else
      sx = sx1
      sy = (delta < 0 ? sy1 - 1 ; sy2 + 1)
    end

    if Seed_valid(sx, sy) then
      local S = SEEDS[sx][sy]

      if S.room then return S.room end
      if S.hall then return S.hall end
    end

    -- try behind it
    if geom.is_vert(dir) then
      sx = (delta < 0 ? sx1 ; sx2)
      sy = sy1
    else
      sx = sx1
      sy = (delta < 0 ? sy1 ; sy2)
    end

    sx, sy = geom.nudge(sx, sy, dir)

    if Seed_valid(sx, sy) then
      local S = SEEDS[sx][sy]

      if S.room then return S.room end
      if S.hall then return S.hall end
    end

    return nil
  end


  local function OLD__make_the_fake(R)
    while not table.empty(R.fake_buildings) do
      local row = collect_fake_row(R)
      assert(row)

      local dir = 10 - row[1].dir

      local sx1 = row[1].N.sx
      local sy1 = row[1].N.sy

      local sx2 = row[#row].N.sx
      local sy2 = row[#row].N.sy

      assert(sx1 <= sx2)
      assert(sy1 <= sy2)

      -- look for a building on each side
      local B = building_on_side_of_row(row, sx1, sy1, sx2, sy2, -1) or
                building_on_side_of_row(row, sx1, sy1, sx2, sy2,  1)

    end
  end


  ---| Rooms_do_outdoor_borders |---

  Seed_flood_fill_edges()

-- Plan_dump_rooms("Edges of Map:")

  scan_for_unused_seeds(1)

  analyse_edges()

  scan_for_unused_seeds(2)

  each R in LEVEL.rooms do
    if R.kind == "outdoor" then
      scan_room(R)
    end
  end
end



function Rooms_decide_fences()

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

        if not N or not N.room or N.room == R then continue end

        if N.room.kind != "outdoor" then continue end

        check_room_pair(R, N.room, S, N) 
      end
    end end
  end


  ---| Rooms_decide_fences |---

  gui.debugf("Rooms_decide_fences.........\n")

  each R in LEVEL.rooms do
    if R.kind == "outdoor" then
      do_fences(R)
    end
  end
end



function Rooms_build_all()

  gui.printf("\n--==| Build Rooms |==--\n\n")

  gui.prog_step("Rooms");

  Rooms_select_textures()

---!!!  Rooms_setup_symmetry()

  Rooms_place_gates()

  Rooms_collect_sky_groups()

  Areas_handle_connections()
  Areas_important_stuff()
  Areas_flesh_out()

  Rooms_outdoor_borders()

  -- Rooms_indoor_walls()

  Rooms_blow_chunks()
  Rooms_add_sun()
  Rooms_intermission_camera()


--[[ DEBUG
local T = Trans.box_transform(-7*192, -6*192, -6*192, -5*192, 448, 2)
local skin = { item="quad", wall="TECH08_2", outer="CITY6_3" }
Fabricate("SECRET_NICHE_W_JUMPS", T, { skin })
--]]
end

