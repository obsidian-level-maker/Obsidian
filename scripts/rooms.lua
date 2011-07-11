----------------------------------------------------------------
--  Room Management
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2011 Andrew Apted
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
  kind : keyword  -- "normal" (layout-able room)
                  -- "scenic" (unvisitable room)
                  -- "hallway", "stairwell", "small_exit"

  shape : keyword -- "rect" (perfect rectangle)
                  -- "L"  "T"  "U"
                  -- "plus"
                  -- "odd"  (anything else)

  outdoor : bool  -- true for outdoor rooms
  natural : bool  -- true for cave/landscape areas
  scenic  : bool  -- true for scenic (unvisitable) areas

  conns : list(CONN)  -- connections with neighbor rooms
  entry_conn : CONN

  branch_kind : keyword

  hallway : HALLWAY_INFO   -- for hallways and stairwells

  symmetry : keyword   -- symmetry of room, or NIL
                       -- keywords are "x", "y", "xy"

  sx1, sy1, sx2, sy2  -- \ Seed range
  sw, sh, svolume     -- /

  chunks : list(CHUNK)  -- all chunks in the room
###  entry_chunk : CHUNK

  kx1, ky1, kx2, ky2  -- \ Section range
  kw, kh              -- /

  sections : list  -- all sections of room


  quest : QUEST

  purpose : keyword   -- usually NIL, can be "EXIT" etc... (FIXME)

  floor_h, ceil_h : number


  --- plan_sp code only:

  group_id : number  -- traversibility group

}


----------------------------------------------------------------]]

require 'defs'
require 'util'


ROOM_CLASS = {}

function ROOM_CLASS.new(shape)
  local id = Plan_alloc_id("room")
  local R =
  {
    id = id
    kind = "normal"
    shape = shape
    is_room = true

    conns = {}
    chunks = {}
    sections = {}
    middles = {}
    spaces = {}
    floor_mats = {}

    num_windows = 0

    cage_spots = {}
    trap_spots = {}
    mon_spots  = {}
    item_spots = {}

    prefabs = {}
    blocks  = {}
    decor   = {}
  }
  table.set_class(R, ROOM_CLASS)
  table.insert(LEVEL.rooms, R)
  return R
end


function ROOM_CLASS.tostr(R)
  return string.format("ROOM_%d", R.id)
end


function ROOM_CLASS.longstr(R)
  return string.format("%s_%s [%d,%d..%d,%d]",
      (R.parent ? "SUB_ROOM" ; "ROOM"),
      R.id, R.kx1, R.ky1, R.kx2, R.ky2)
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


function ROOM_CLASS.annex(R, K)
  K:set_room(R)

  K.kind = "annex"
  K.expanded = true

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
    if N.outdoor then return true end
  end
  return false
end


function ROOM_CLASS.has_teleporter(R)
  each D in R.conns do
    if D.kind == "teleporter" then return true end
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


function ROOM_CLASS.is_near_exit(R)
  if R.purpose == "EXIT" then return true end
  each D in R.conns do
    local N = D:neighbor(R)
    if N.purpose == "EXIT" then return true end
  end
  return false
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

  if not R.floor_mats[h] then
    if R.outdoor then
      R.floor_mats[h] = rand.pick(LEVEL.courtyard_floors)
    else
      R.floor_mats[h] = rand.pick(LEVEL.building_floors)
    end
  end

  return R.floor_mats[h]
end


function ROOM_CLASS.pick_ceil_mat(R)
  if not R.ceil_mat then
    R.ceil_mat = rand.key_by_probs(THEME.building_ceilings)
  end

  return R.ceil_mat
end


function ROOM_CLASS.can_alloc_chunk(R, sx1, sy1, sx2, sy2)
  if sx1 < R.sx1 or sx2 > R.sx2 then return false end
  if sy1 < R.sy1 or sy2 > R.sy2 then return false end
 
  for sx = sx1, sx2 do for sy = sy1, sy2 do
    local S = SEEDS[sx][sy]
    if S.room != R then return false end
    if S.chunk then return false end
  end end

  return true
end


function ROOM_CLASS.alloc_chunk(R, sx1, sy1, sx2, sy2)
  assert(R.sx1 <= sx1 and sx1 <= sx2 and sx2 <= R.sx2)
  assert(R.sy1 <= sy1 and sy1 <= sy2 and sy2 <= R.sy2)

  local C = CHUNK_CLASS.new(sx1, sy1, sx2, sy2)

  C.room = R

  C.x1, C.y1 = SEEDS[sx1][sy1].x1, SEEDS[sx1][sy1].y1
  C.x2, C.y2 = SEEDS[sx2][sy2].x2, SEEDS[sx2][sy2].y2

  table.insert(R.chunks, C)

  C:install()

  return C
end


function ROOM_CLASS.set_facade(R, facade)
  R.facade = facade

  each K in R.sections do
    K.facade = facade
  end

--??  each D in R.conns do
--??    if D.R1 == R and D.hall then
--??      D.hall.facade = facade
--??    end
--??  end
end


function ROOM_CLASS.num_crossovers(R)
  if R.crossover then return 1 end

  return 0
end


function ROOM_CLASS.mid_point(R)
  local x1 = SEEDS[R.sx1][R.sy1].x1
  local y1 = SEEDS[R.sx1][R.sy1].y1

  local x2 = SEEDS[R.sx2][R.sy2].x2
  local y2 = SEEDS[R.sx2][R.sy2].y2

  return (x1 + x2) / 2, (y1 + y2) / 2
end


----------------------------------------------------------------


function Rooms_setup_theme(R)
  R.skin = {}

  R.skin.spike_group = "spike" .. tostring(R.id)

  if not R.outdoor then
    R.main_tex = rand.pick(LEVEL.building_walls)
    R.skin.wall = R.main_tex
    return
  end

  if not R.quest.courtyard_floor then
    R.quest.courtyard_floor = rand.pick(LEVEL.courtyard_floors)
  end

  R.main_tex = R.quest.courtyard_floor

  R.skin.wall = R.main_tex
  R.skin.fence = "ICKWALL7"
end


function Rooms_setup_theme_Scenic(R)
  -- TODO
  R.outdoor = true
  Rooms_setup_theme(R)
end


function Rooms_assign_facades()
  --
  -- Algorithm:
  --   assign a facade to each corner of the map, and then grow
  --   randomly until every section has a facade.  When a section
  --   is part of a room, the whole room gets that facade.
  --
  each corner in { 1,3,7,9 } do
    local kx, ky = geom.pick_corner(corner, 1,1, SECTION_W,SECTION_H)
    local K = SECTIONS[kx][ky]

    local facade = rand.pick(LEVEL.building_facades)

    K:set_facade(facade)
  end

  for loop = 1,20 do
    local last_chance = (loop == 20)

    each K in Section_random_visits() do
      if K.facade then continue end

      local N = K:neighbor(rand.dir())

      local facade = N and N.facade
      
      -- prefer not to propagate via outdoor rooms
      if loop <= 10 and N and N.room and N.room.outdoor then
        continue
      end

      if not facade and last_chance then
        facade = rand.pick(LEVEL.building_facades)
      end

      if facade then
        K:set_facade(facade)
      end

    end -- K
  end -- loop

  -- verify that all went well
  each R in LEVEL.rooms do
    assert(R.facade)
  end

  -- TODO: handle this in SECTION_CLASS.set_facade()
  each R in LEVEL.scenics do
    if not R.facade then
      R.facade = R.sections[1].facade
      assert(R.facade)
    end
  end
end


function Rooms_choose_themes()
  each R in LEVEL.rooms do
    Rooms_setup_theme(R)
  end

  each R in LEVEL.scenics do
    Rooms_setup_theme_Scenic(R)
  end
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



function Rooms_synchronise_skies()
  -- make sure that any two outdoor rooms which touch have the same sky_h

  for loop = 1,10 do
    local changes = false

    for x = 1,SECTION_W do for y = 1,SECTION_H do
      local K = SECTIONS[x][y]
      if K and K.room and K.room.sky_h then
        for side = 2,8,2 do
          local N = K:neighbor(side)
          if N and N.room and N.room != K.room and N.room.sky_h and
             K.room.sky_h != N.room.sky_h
          then
            K.room.sky_h = math.max(K.room.sky_h, N.room.sky_h)
            N.room.sky_h = K.room.sky_h
            changes = true
          end
        end -- for side
      end
    end end -- for x, y

    if not changes then break; end
  end -- for loop
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

      if can_add_window(K, side) and N.room.outdoor
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
    if R.natural then return end

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


function Rooms_place_importants()

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
  if GAME.format == "doom" then
    return
  end

  local sun_r = 25000
  local sun_h = 40000

  -- nine lights in the sky, one is "the sun" and the rest are
  -- to keep outdoor areas from getting too dark.

  for i = 1,8 do
    local angle = i * 45 - 22.5

    local x = math.sin(angle * math.pi / 180.0) * sun_r
    local y = math.cos(angle * math.pi / 180.0) * sun_r

    local level = (i == 1 ? 32 ; 6)

    Trans.entity("sun", x, y, sun_h, { light=level })
  end

  Trans.entity("sun", 0, 0, sun_h, { light=12 })
end



function Rooms_intermission_camera()
  -- game check
  if not GAME.ENTITIES["camera"] then return end

  -- determine the room (biggest one, excluding starts and exits)
  local room

  each R in LEVEL.rooms do
    if R.purpose != "START" and R.purpose != "EXIT" then
      if not room or (R.kvolume > room.kvolume) then
        room = R
      end
    end
  end

  if not room then return end

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

--[[ TO BE REMOVED : OLD SECTION-BASED METHOD
  local K
  local dir

  local CORNERS = { 1,3,7,9 }
  rand.shuffle(CORNERS)

  each dir in CORNERS do
    local kx = (side == 1 or side == 7 ? room.kx1 ; room.kx2)
    local ky = (side == 1 or side == 3 ? room.ky1 ; room.ky2)

    if SECTIONS[kx][ky].room == room then
      K = SECTIONS[kx][ky]
      dir = 10 - side
      break
    end
  end

  if not K then
    K = room.sections[1]
    dir = 1

    if K:same_room(6) then dir = 3 end
    if K:same_room(8) then dir = dir + 6 end
  end

  local z1
  local z2 = room.entry_floor_h

  if room.ceil_h then z1 = room.ceil_h - 64
  elseif room.sky_h then z1 = room.sky_h - 96
  else z1 = room.entry_floor_h + 128
  end

  local K2 = K

      if (dir == 3 or dir == 9) and K2:same_room(6) then K2 = K2:neighbor(6)
  elseif (dir == 7 or dir == 9) and K2:same_room(8) then K2 = K2:neighbor(8)
  elseif (dir == 1 or dir == 3) and K2:same_room(2) then K2 = K2:neighbor(2)
  elseif (dir == 1 or dir == 7) and K2:same_room(4) then K2 = K2:neighbor(4)
  end

  local x1 = math.min(K.x1, K2.x1)
  local y1 = math.min(K.y1, K2.y1)
  local x2 = math.max(K.x2, K2.x2)
  local y2 = math.max(K.y2, K2.y2)
  
  local W = x2 - x1
  local H = y2 - y1

  x1 = x1 + int(W / 3) ; x2 = x2 - int(W / 3)
  y1 = y1 + int(H / 3) ; y2 = y2 - int(H / 3)

  if dir == 1 or dir == 7 then x1,x2 = x2,x1 end
  if dir == 1 or dir == 3 then y1,y2 = y2,y1 end
--]]

  local x1, y1, z1 = info.x1, info.y1, info.z1
  local x2, y2, z2 = info.x2, info.y2, info.z2

  local dist  = geom.dist(x1,y1, x2,y2)
  local angle = geom.calc_angle(x2 - x1, y2 - y1)
  local mlook = geom.calc_angle(dist, z1 - z2)

  local mangle = string.format("%d %d 0", mlook, angle)

  Trans.entity("camera", x1, y1, z1, { mangle=mangle })
end



function Rooms_blow_chunks()

  -- TEMP TEMP CRUD CRUD

  each R in LEVEL.rooms do
    each C in R.chunks do
      C:build()
    end

    --!!!!!!!! TEST
    if R.purpose != "START" then
---    Layout_simple_room(R)
    end
  end

  each H in LEVEL.halls do
    H:build()
  end

--???    if D.crossover then
--???      D.crossover.hall_A:build()
--???      D.crossover.hall_B:build()
--???    end  
end



function Layout_inner_outer_tex(skin, K, K2)
  assert(K)
  if not K2 then return end

  local R = K.room
  local N = K2.room

  if N.kind == "REMOVED" then return end

  skin.wall  = R.skin.wall
  skin.outer = N.skin.wall

  if R.outdoor and not N.outdoor then
    skin.wall  = N.facade or skin.outer
  elseif N.outdoor and not R.outdoor then
    skin.outer = R.facade or skin.wall
  end
end



function Layout_possible_prefab_from_list(tab, where, req_key)

  assert(tab)

  -- FIXME: fix this rubbish somehow
  if tab == "SWITCH" then
    if where != "edge" then return nil end
    return "SWITCH"
  end


  local function match(skin)
    -- TODO: more sophisticated matches (prefab.environment)

    if skin._where != where then return false end

    if req_key and not skin._keys[req_key] then return false end

    return true
  end

  local result = {}

  for name,prob in pairs(tab) do
    local skin = GAME.SKINS[name]

    if not skin then
      -- FIXME: WARNING or ERROR ??
      error("no such skin: " .. tostring(name))
    else
      if match(skin) then
        result[name] = prob
      end
    end
  end

  if table.empty(result) then return nil end

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


function Layout_possible_doors(E)
  local list, lock, key

  local C = E.usage.conn

  if C.lock and C.lock.kind == "KEY" then
    list = THEME.lock_doors
    lock = C.lock
    key  = lock.key
  elseif C.lock and C.lock.kind == "SWITCH" then
    list = THEME.switch_doors
    lock = C.lock
  elseif rand.odds(20) then
    list = THEME.doors
  else
    list = THEME.arches
  end

  E.usage.edge_fabs = Layout_possible_prefab_from_list(list, "edge", key)
end

function Layout_possible_windows(E)
  if E.usage.K1.room.outdoor and E.usage.K2.room.outdoor then
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

    gui.spots_fill_poly(Trans.bare_quad(x1,y1, x2,y2), 2)
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
      Trans.entity("potion", spot.x1 + 8, spot.y1 + 8, 0)
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

      local mx, my = geom.box_mid(K.x1, K.y1, K.x2, K.y2)

      Trans.entity("light", mx, my, z, { light=light, _radius=radius })
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
    if R.outdoor then light = 192 end

    each K in R.sections do
      gui.add_brush(
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


function Rooms_build_all()

  gui.printf("\n--==| Build Rooms |==--\n\n")

  Rooms_choose_themes()
  Rooms_assign_facades()

---!!!  Rooms_setup_symmetry()

  Areas_handle_connections()
  Areas_important_stuff()
  Areas_flesh_out()

  if PARAM.tiled then
    -- this is as far as we go for TILE based games
    Tiler_layout_all()
    return
  end

  Rooms_blow_chunks()

  -- scenic rooms ??

  Rooms_add_sun()

  Rooms_intermission_camera()
end

