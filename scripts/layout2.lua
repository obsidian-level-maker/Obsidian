----------------------------------------------------------------
--  V4 Layouting Logic
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2010 Andrew Apted
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

class EDGE
{
  K, side  -- identification

  long  --  real length of edge

  corn1, corn2 : CORNER

  L_long, R_long  -- length allocated to corners
  L_deep, R_deep  -- depth (sticking out) at corners

  usage : USAGE   -- primary usage (door, window, etc)

  spans[] : SPAN  -- allocated stuff on this edge
}


class SPAN
{
  long1, long2  -- length range along edge
  deep1, deep2  -- depth (sticking out)

  FIXME: usage stuff
}


class CORNER
{
  K, side  -- identification

  concave  -- true for 270 degree corners

  horiz, vert  -- connecting sizes

  usage : USAGE  -- primary usage
}


class MIDDLE
{
  K  -- section

  usage : USAGE
}


----------------------------------------------------------------]]

require 'defs'
require 'util'


----
---  MINIMUM SIZES
---  -------------
---  
---  Door / Window / Important  @  EDGE  -->  192 x 64  (64 walk)
--- 
---  Item / Switch  @  MIDDLE  -->  128 x 128  (64 walk)
---  
---  Basic wall -->  32 thick
---  
---  Basic corner -->  32 x 32
--  

  --
  -- Straddlers are architecture which sits across two rooms.
  -- Currently there are only two kinds: DOORS and WINDOWS.
  -- 
  -- The prefab to use (and hence their size) are decided before
  -- everything else.  The actual prefab and heights will be
  -- decided later in the normal layout code.
  --



-- FIXME: appropriate place
DOOR_SILVER_KEY = 16
DOOR_GOLD_KEY   = 8


function Layout_initial_space(R)
  local S = SPACE_CLASS.new()

  if R.shape == "rect" then
    local K1 = SECTIONS[R.kx1][R.ky1]
    local K2 = SECTIONS[R.kx2][R.ky2]

    S:initial_rect(K1.x1, K1.y1, K2.x2, K2.y2)
  else
    for _,K in ipairs(R.sections) do
      S:initial_rect(K.x1, K.y1, K.x2, K.y2)
    end
  end

  return S
end


function Layout_initial_space2(R)
  local list = {}

  -- FIXME: blocks
  for _,B in ipairs(R.sections) do
    local BRUSH = Trans.bare_quad(B.x1, B.y1, B.x2, B.y2)

    table.insert(list, BRUSH)
  end

  return list
end



function Layout_monotonic_spaces(R)
  -- Monotonic here means that if you cut the space in half either
  -- horizontally or vertically, you will always end up with two
  -- contiguous pieces.
  --
  -- Rectangles, regular polygons, axis-aligned L shapes are all
  -- monotonic.  A counter example is a U shape, which if you cut it
  -- horizontally the top half will have two separated bits.
  --
  -- ALGORITHM:
  --   the basic idea is that "allocating" a free square will
  --   check each side, if the neighbor is solid then all free
  --   squares beyond that solid get "shadowed" and cannot be
  --   allocated for the current group.  The next square can be
  --   a free non-shadowed neighbor of one of the used squares.

  R.mono_list = {}

  local pass = 1


  local function starter()
    for x = R.kx1,R.kx2 do for y = R.ky1,R.ky2 do
      local K = SECTIONS[x][y]
      if K.room == R and not K.m_used then
        return K
      end
    end end

    return nil, nil  -- no more free squares
  end


  local function clear_shadows()
    for x = R.kx1,R.kx2 do for y = R.ky1,R.ky2 do
      local K = SECTIONS[x][y]
      K.m_shadowed = nil
    end end
  end


  local function alloc(K)
    assert(not K.m_used)
    assert(not K.m_shadowed)

    K.m_used = pass

    for side = 2,8,2 do
      local N = K:neighbor(side)

      if N and N.room ~= R then
        -- do the shadowing
        for dist = 2,60 do
          local P = K:neighbor(side, dist)
          if not P then break; end

          if P.room == R then
            P.m_shadowed = pass
          end
        end
      end
    end
  end


  local function find_next()
    for x = R.kx1,R.kx2 do for y = R.ky1,R.ky2 do
      local K = SECTIONS[x][y]
      if K.room == R and K.m_used == pass then

        for side = 2,8,2 do
          local N = K:neighbor(side)
          if N and N.room == R and not (N.m_used or N.m_shadowed) then
            return N
          end
        end
        
      end
    end end

    return nil  -- nothing usable
  end


  local function grab_space()
    clear_shadows()

    local K = starter()

    if not K then  -- finished?
      return false
    end

    local INFO =
    {
      sections = {},

      space = SPACE_CLASS.new(),

      blocks = {},
    }

    table.insert(R.mono_list, INFO)

    repeat
      table.insert(INFO.sections, K)

      INFO.space:initial_rect(K.x1, K.y1, K.x2, K.y2)

      alloc(K)

      K = find_next()
    until not K

    return true
  end


  local function dump_space()
    gui.debugf("space %d:\n", pass)

    for y = R.ky2,R.ky1,-1 do
      local line = ""
      for x = R.kx1,R.kx2 do
        local K = SECTIONS[x][y]

        if K.room ~= R then
          line = line .. "#"
        elseif K.m_used == pass then
          line = line .. "/"
        elseif K.m_used or K.m_shadowed then
          line = line .. "-"
        else
          line = line .. " "
        end
      end
      gui.debugf("  #%s#\n", line)
    end

    gui.debugf("\n")
  end


  local function block_is_contig(kx1, ky1, kw, kh)
    local kx2 = kx1 + kw - 1
    local ky2 = ky1 + kh - 1

    if kx2 > R.kx2 or ky2 > R.ky2 then
      return false
    end

    local id = SECTIONS[kx1][ky1].m_used

    for x = kx1,kx2 do for y = ky1,ky2 do
      local K = SECTIONS[x][y]
      if K.room ~= R    then return false end
      if K.m_used ~= id then return false end
      if K.contig_used  then return false end
    end end

    return true
  end


  local function mark_block(x, y, kw, kh)
    for dx = 0,kw-1 do for dy = 0,kh-1 do
      SECTIONS[x+dx][y+dy].contig_used = true
    end end
  end


  local function biggest_block(x, y)
    local kw, kh = 1,1

    if R.shape == "rect" then return R.kw, R.kh end

    while true do
      if block_is_contig(x, y, kw+1, kh) then
        kw = kw + 1
      elseif block_is_contig(x, y, kw, kh+1) then
        kh = kh + 1
      else
        return kw, kh
      end
    end
  end


  local function break_into_blocks()
    gui.debugf("Blocks:\n")

    for x = R.kx1,R.kx2 do for y = R.ky1,R.ky2 do
      local K = SECTIONS[x][y]
      if K.room == R and not K.contig_used then

        local kw,kh = biggest_block(x, y)
        mark_block(x, y, kw, kh)

        local BLOCK = { kx1=x, ky1=y, kx2=x+kw-1, ky2=y+kh-1 }

        table.insert(R.blocks, BLOCK)
        table.insert(R.mono_list[K.m_used].blocks, BLOCK)

        gui.debugf("  space:%d  K: (%d %d) .. (%d %d)\n", K.m_used,
                   BLOCK.kx1, BLOCK.ky1, BLOCK.kx2, BLOCK.ky2)
      end
    end end

    gui.debugf("\n")
  end

  
  --| Layout_monotonic_spaces |--

  gui.debugf("Monotonic spaces in %s\n", R:tostr())

  while grab_space() do
    dump_space()

    pass = pass + 1
  end

  break_into_blocks()
end



function Layout_add_span(E, long1, long2, deep)

-- stderrf("********** add_span %s @ %s : %d\n", kind, E.K:tostr(), E.side)

  assert(long2 > long1)

  -- check if valid
  assert(long1 >= 16)
  assert(long2 <= E.long - 16)

  -- corner check
  if E.L_long then assert(long1 >= E.L_long) end
  if E.R_long then assert(long2 <= E.R_long) end

  for _,SP in ipairs(E.spans) do
    if (long2 <= SP.long1) or (long1 >= SP.long2) then
      -- OK
    else
      error("Layout_add_span: overlaps existing one!")
    end
  end

  -- create and add it
  local SPAN =
  {
    long1 = long1,
    long2 = long2,
    deep1 = deep,
    deep2 = deep,
  }

  table.insert(E.spans, SPAN)

  -- keep them sorted
  if #E.spans > 1 then
    table.sort(E.spans,
        function(A, B) return A.long1 < B.long1 end)
  end

  return SPAN
end


function Layout_check_brush(coords, data)
  local R = data.R

  local allow = true

  local mode
  local m = coords[1].m

      if m == "used"    then allow = false ; mode = "solid"
  elseif m == "walk"    then allow = false ; mode = "walk"
  elseif m == "air"     then allow = false ; mode = "air"
  elseif m == "nosplit" then allow = false ; mode = "nosplit"
  elseif not m or m == "solid" or m == "sky" then
    mode = "solid"
  else
    -- don't update the space (e.g. light brushes)
  end

  if mode then
    local POLY = POLYGON_CLASS.from_brush(mode, coords)
    table.insert(data.polys, POLY:copy())
    R.wall_space:merge(POLY)
  end

  return false
end


function Layout_shrunk_section_coords(K)
  local x1, y1 = K.x1, K.y1
  local x2, y2 = K.x2, K.y2

  if not K:same_room(4) then x1 = x1 + 8 end
  if not K:same_room(6) then x2 = x2 - 8 end
  if not K:same_room(2) then y1 = y1 + 8 end
  if not K:same_room(8) then y2 = y2 - 8 end

  return x1,y1, x2,y2
end



function Layout_dists_from_entrance()

  local function spread_entry_dist(R)
    local count = 1
    local total = #R.sections

    local K = R.entry_conn:section(R)

    K.entry_dist = 0

    while count < total do
      for _,K in ipairs(R.sections) do
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

  --| Layout_dists_from_entrance |--

  for _,R in ipairs(LEVEL.all_rooms) do
    if R.entry_conn then
      spread_entry_dist(R)
    else
      for _,K in ipairs(R.sections) do
        K.entry_dist = 0
      end
    end
  end
end



function Layout_collect_targets(R)

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

    for _,K in ipairs(R.sections) do
      for _,E in pairs(K.edges) do
        if E.corn1 == C and E.usage then return false end
        if E.corn2 == C and E.usage then return false end
      end
    end
  
    return true
  end

  --| Layout_collect_targets |--

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


function Layout_sort_targets(targets, entry_factor, conn_factor, busy_factor)
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


function Layout_possible_prefabs(kind, where, lock)

  -- kind : "START", "EXIT", "ITEM", "SWITCH"

  -- where : "edge", "corner", "middle"

  local function match(skin)
    -- TODO: more sophisticated matches (prefab.environment)

    if skin._where ~= where then return false end

    if kind == "LOCK_DOOR" and not skin._keys[lock.key] then return false end

    return true
  end

  local KIND_MAP =
  {
    START   = "starts",
    EXIT    = "exits",
    ITEM    = "pedestals",
    KEY     = "pedestals",

    ARCH    = "arches",
    DOOR    = "doors",
    LOCK_DOOR   = "lock_doors",
    SWITCH_DOOR = "switch_doors",

    WINDOW  = "windows",
    FENCE   = "fences",
    TELEPORTER = "teleporters",
  }

  local tab

  if kind == "SWITCH" then
    if where ~= "edge" then return nil end  -- FIXME !!!
    return "SWITCH"
--- tab = assert(lock.switches)
  else
    local tab_name = assert(KIND_MAP[kind])
    tab = THEME[tab_name]
  end

  if not tab then return nil end

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


function Layout_possible_fab_group(usage, fab_kind, lock)
  usage.edge_fabs   = Layout_possible_prefabs(fab_kind, "edge",   lock)
  usage.corner_fabs = Layout_possible_prefabs(fab_kind, "corner", lock)
  usage.middle_fabs = Layout_possible_prefabs(fab_kind, "middle", lock)

  if not usage.edge_fabs and not usage.corner_fabs and not usage.middle_fabs then
    error("Theme is missing usable prefabs for: " .. tostring(fab_kind))
  end
end



function Layout_place_importants()

  local function clear_busyness(R)
    for _,K in ipairs(R.sections) do
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

stderrf("EDGE %s:%d ---> USAGE %s %s\n", edge.K:tostr(), edge.side, usage.kind, usage.sub or "-")

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
    R.targets = Layout_collect_targets(R, edges, corners, middles)

    if R.purpose then
      Layout_sort_targets(R.targets, 1, -0.6, -0.2)

      local USAGE =
      {
        kind = "important",
        sub  = R.purpose,
        lock = R.purpose_lock,
      }

      local fab_kind = R.purpose

      if R.purpose == "SOLUTION" then
        fab_kind = R.purpose_lock.kind
      end

      Layout_possible_fab_group(USAGE, fab_kind, R.purpose_lock)

      pick_target(R, USAGE)
--[[
        if R.purpose_lock and R.purpose_lock.kind == "KEY" then
          USAGE.middle_prefabs = 
          {
            { _prefab = "OCTO_PEDESTAL",
              item = R.purpose.lock.key,
              top = "CEIL1_2", base = "FLAT1"
            }
          }
        end
--]]
      -- FIXME: cheap hack, should just remove the invalidated targets
      --        (a bit complicated since corners use the nearby edges
      --         and hence one can invalidate the other)
      R.targets = Layout_collect_targets(R, edges, corners, middles)
    end

    Layout_sort_targets(R.targets, 0.4, -1, -0.8)

    if R:has_teleporter() then
      local USAGE =
      {
        kind = "important",
        sub  = "teleporter",
      }

      Layout_possible_fab_group(USAGE, "TELEPORTER")

      pick_target(R, USAGE)

      R.targets = Layout_collect_targets(R, edges, corners, middles)
    end


    -- ??? TODO: weapon (currently added by pickup code)

  end


  --| Layout_place_importants |--

  Layout_dists_from_entrance()

  for _,R in ipairs(LEVEL.all_rooms) do
    clear_busyness(R)
    place_importants(R)
  end
end



function Layout_extra_room_stuff()

  -- this function is meant to ensure good traversibility in a room.
  -- e.g. put a nice item in sections without any connections or
  -- importants, or if the exit is close to the entrance then make
  -- the exit door require a far-away switch to open it.

  local function extra_stuff(R)
    -- TODO
  end


  --| Layout_extra_room_stuff |--

  for _,R in ipairs(LEVEL.all_rooms) do
    extra_stuff(R)
  end
end



function Layout_initial_walls(R)
  --
  -- this picks the smallest prefab available for each usage on
  -- each edge.  It is assumed that everything will fit, since the
  -- minimum room size is 384x384 and there should be a prefab of
  -- each kind (door, window, start, exit, etc) which is small
  -- enough.
  --
  -- this also creates an initial "wall space" marking where those
  -- minimal prefabs are.  Later functions will try to enlarge some
  -- of the prefabs (and add new ones) and will verify placement
  -- using the wall_space (previous prefabs can get updated in it).
  --

  local function is_minimal_edge(skin)
    if not skin._long then return false end
    if not skin._deep then return false end

    return skin._long <= 192 and skin._deep <= 64
  end


  local function possible_doors(E)
    local kind = "ARCH"
    local lock
    local C = E.usage.conn

    if C.lock and C.lock.kind == "KEY" then
      kind = "LOCK_DOOR"
      lock = C.lock
    elseif C.lock and C.lock.kind == "SWITCH" then
      kind = "SWITCH_DOOR"
      lock = C.lock
    elseif rand.odds(20) then
      kind = "DOOR"
    end

    E.usage.edge_fabs = Layout_possible_prefabs(kind, "edge", lock)
  end


  local function possible_windows(E)
    local kind = "WINDOW"

    if E.usage.K1.room.outdoor and E.usage.K2.room.outdoor then
      kind = "FENCE"
    end

    E.usage.edge_fabs = Layout_possible_prefabs(kind, "edge")
  end


  local function create_span(E, skin, extra_skins)
    local long = assert(skin._long)
    local deep = assert(skin._deep)

    local long1 = int(E.long - long) / 2
    local long2 = int(E.long + long) / 2

    local SP = Layout_add_span(E, long1, long2, deep, prefab)

    if E.usage.FOOBIE then return end
    E.usage.FOOBIE = true


    if R.skin then table.insert(extra_skins, 1, R.skin) end
    if THEME.skin then table.insert(extra_skins, 1, THEME.skin) end

    local skins = table.copy(extra_skins)
    table.insert(skins, skin)

    local fab = Fab_create(skin._prefab)

    Fab_apply_skins(fab, skins)


    fab.room = R
    table.insert(R.prefabs, fab)

    SP.fab = fab
    SP.extra_skins = extra_skins


    local back = 0

    if E.usage.kind == "window" or E.usage.kind == "door" then
      back = -deep

      -- add the straddler prefab to the other room too

      local N = E.K:neighbor(E.side)

      fab.straddler = { E = E, R2 = N.room }

      table.insert(N.room.prefabs, fab)
    end

    local T = Trans.edge_transform(E.K.x1, E.K.y1, E.K.x2, E.K.y2, 0, E.side,
                                   long1, long2, back, deep)

    Fab_transform_XY(fab, T)
  end


  local function initial_edge(E)
    if not E.usage then
      return
    end

    if E.usage.kind == "door" then
      possible_doors(E)
    elseif E.usage.kind == "window" then
      possible_windows(E)
    end

    local fabs = assert(E.usage.edge_fabs)

    if fabs == "SWITCH" then
      fabs = assert(E.usage.lock.switches)
    end

    for name,_ in pairs(fabs) do
      local skin = GAME.SKINS[name]
      if not skin then
        error("No such skin: " .. tostring(name))
      end

      if is_minimal_edge(skin) then
        gui.printf("  minimal_fab @ %s:%d ---> %s\n", E.K:tostr(), E.side, name)
        E.minimal = { skin=skin }
        break;
      end
    end

    if not E.minimal then
      gui.printf("E.usage =\n%s\n", table.tostr(E.usage, 2))
      error("Lacking minimal prefab for: " .. tostring(E.usage.kind))
    end

    if E.usage.kind == "door" and E.usage.conn.lock and E.usage.conn.lock.kind == "SWITCH" then
      E.usage.conn.lock.switches = assert(E.minimal.skin._switches)
    end

    local extra_skins = {}

local CRUD = { item="none", outer="_ERROR",track="_ERROR",frame="_ERROR",
               rail="STEPTOP", metal="METAL", }
table.insert(extra_skins, CRUD)

    if E.usage.kind == "door" and E.usage.conn.lock then
      local lock = E.usage.conn.lock
      if lock.tag then
        table.insert(extra_skins, { tag = lock.tag, targetname = "sw" .. tostring(lock.tag) })
      end
    end

    if E.usage.kind == "important" and E.usage.lock and E.usage.lock.kind == "KEY" then
      table.insert(extra_skins, { item = E.usage.lock.key })
    end

    if E.usage.kind == "important" and E.usage.lock and E.usage.lock.kind == "SWITCH" then
      table.insert(extra_skins, { tag = E.usage.lock.tag })
    end

    if E.usage.sub == "EXIT" and GAME.format == "quake" then
      table.insert(extra_skins, { next_map = LEVEL.next_map })
    end

    create_span(E, E.minimal.skin, extra_skins)
  end


  ---| Layout_initial_walls |---

  R.wall_space = Layout_initial_space(R)

  -- FIXME!!!!  do initial middles here too

  for pass = 1,2 do
    for _,K in ipairs(R.sections) do
      for _,E in pairs(K.edges) do
        -- do doors before everything else, since switched doors
        -- control what switches will be available.
        local is_door = sel(E.usage and E.usage.kind == "door", 1, 2)
        if pass == is_door then
          initial_edge(E)
        end
      end
    end
  end
end



function Layout_flesh_out_walls(R)
  --
  -- the goal of this function is to fill in the gaps along walls
  -- (including the corners) with interesting prefabs.  It can also
  -- replace existing non-straddler prefabs with a bigger variation,
  -- of course ensuring that everything fits and nothing overlaps.
  --

  local function adjust_corner(C, side, long, deep)
    if geom.is_vert(side) then
      C.horiz = math.min(C.horiz, long)
--    C.vert  = math.min(C.vert,  deep)
    else
      C.vert  = math.min(C.vert,  long)
--    C.horiz = math.min(C.horiz, deep)
    end
  end


  local function adjust_corner_sizes(E)
    local L_long, L_deep
    local R_long, R_deep

    if E.spans[1] then
      L_long = E.spans[1].long1
      L_deep = E.spans[1].deep1

      R_long = E.long - E.spans[#E.spans].long2
      R_deep = E.spans[#E.spans].deep2

      if E.corn1 then
        adjust_corner(E.corn1, E.side, L_long, L_deep)
      end

      if E.corn2 then
        adjust_corner(E.corn2, E.side, L_long, L_deep)
      end
    end
  end


  local function decide_corner_sizes()
    for _,R in ipairs(LEVEL.all_rooms) do
      for _,K in ipairs(R.sections) do
        for _,C in pairs(K.corners) do
          if C.concave then
            C.horiz = 64
            C.vert  = 64
          else
            C.horiz = 72
            C.vert  = 72
          end
        end
      end
      for _,K in ipairs(R.sections) do
        for _,E in pairs(K.edges) do
---       adjust_corner_sizes(E)
        end
      end
    end
  end


  local function inner_outer_tex(skin, R, N)
    assert(R)
    if not N then return end

    skin.wall  = R.skin.wall
    skin.outer = N.skin.wall

    if R.outdoor and not N.outdoor then
      skin.wall  = skin.outer
    elseif N.outdoor and not R.outdoor then
      skin.outer = skin.inner
    end
  end


  ---| Layout_flesh_out_walls |---

  -- FIXME !!!!
end



function Layout_all_walls()
  for _,R in ipairs(LEVEL.all_rooms) do
    Layout_initial_walls(R)
  end

  -- do doors after windows, as doors may want to become really big
  -- and hence would need to know about the windows.

--##    Layout_select_windows()
--##    Layout_select_doors()

  for _,R in ipairs(LEVEL.all_rooms) do
   Layout_flesh_out_walls(R)
--TODO    Layout_flesh_out_middles(R)
  end
end



function Layout_build_walls(R)
  for _,fab in ipairs(R.prefabs) do
    if fab.room == R and not fab.built then

      if not fab.bumped then
        --FIXME !!!!!!!! TEMP CRUD
        local T = { add_z = rand.irange(128,384) }

        Fab_transform_Z(fab, T)
      end

      Fab_render(fab)
    end
  end
end



--------------------------------------------------------------------


function Layout_the_floor(R)

  -- fwd decl --
  local function try_subdivide_floor() end


  local function merge_walks(polys, tag1, tag2)
    if tag1 > tag2 then
      tag1, tag2 = tag2, tag1
    end

    for _,P in ipairs(polys) do
      if P.walk_tag == tag2 then
         P.walk_tag = tag1
      end
    end
  end


  local function try_merge_walks(polys, P1, P2)
    if P1.walk_tag == P2.walk_tag then
      return
    end

    if P1:touches(P2) then
      merge_walks(polys, P1.walk_tag, P2.walk_tag)
    end
  end


  local function collect_walk_groups()
    -- first collect the walk polys
    local walk_polys = {}

    for idx,P in ipairs(R.poly_assoc) do
      if P.kind == "walk" then
        P.walk_tag = idx
gui.debugf("walk poly #%d kind:%s fab:%s  loc: (%d %d)\n",
           idx, P.kind, (P.post_fab and P.post_fab.fab) or "NONE", P.bx1, P.by1)
        table.insert(walk_polys, P)
      end
    end
gui.debugf("walk_polys: %d\n", #walk_polys)

    -- now merge tags of walk areas which touch / overlap
    for pn1 = 1,#walk_polys do
      for pn2 = pn1+1,#walk_polys do
        local P1 = walk_polys[pn1]
        local P2 = walk_polys[pn1]
        try_merge_walks(walk_polys, P1, P2)
      end
    end

    -- finally collect all polys with same walk_tag, and compute bbox
    local walk_groups  = {}
    local tag_to_group = {}

    for _,P in ipairs(walk_polys) do
      local GROUP = tag_to_group[P.walk_tag]
      if not GROUP then
        GROUP = { polys={} }
        table.insert(walk_groups, GROUP)
        tag_to_group[P.walk_tag] = GROUP
      end
      table.insert(GROUP.polys, P)
    end

gui.debugf("%s has %d walk groups:\n", R:tostr(), #walk_groups)

    for _,G in ipairs(walk_groups) do
      -- FIXME: big hack (assumes GROUP == SPACE)
      G.x1, G.y1, G.x2, G.y2 = SPACE_CLASS.calc_bbox(G)

---## stderrf("  polys:%d  bbox: (%d %d) .. (%d %d)\n",
---##        #G.polys, G.x1, G.y1, G.x2, G.y2)
    end  

    return walk_groups
  end


  local function collect_airs()
    local air_polys = {}

    for idx,P in ipairs(R.poly_assoc) do
      if P.kind == "air" then
        table.insert(air_polys, P)
      end
    end

    return air_polys
  end


  local function collect_no_splits()
    local polys = {}

    for idx,P in ipairs(R.poly_assoc) do
      if P.kind == "nosplit" then
        table.insert(polys, P)
      end
    end

    return polys
  end




  local function neg_nb_coord(x)
    if not x then return nil end
    return -x
  end

  local function rotate_neighborhood_rect(NB, angle)
    local NB2 = table.copy(NB)

    if angle < 0 then angle = angle + 360 end
    
    if angle == 0 then
      -- nothing needed
    elseif angle == 90 then
      NB2.y1 = NB.x1
      NB2.y2 = NB.x2
      NB2.x1 = neg_nb_coord(NB.y2)
      NB2.x2 = neg_nb_coord(NB.y1)
    elseif angle == 180 then
      NB2.x1 = neg_nb_coord(NB.x2)
      NB2.x2 = neg_nb_coord(NB.x1)
      NB2.y1 = neg_nb_coord(NB.y2)
      NB2.y2 = neg_nb_coord(NB.y1)
    elseif angle == 270 then
      NB2.x1 = NB.y1
      NB2.x2 = NB.y2
      NB2.y1 = neg_nb_coord(NB.x2)
      NB2.y2 = neg_nb_coord(NB.x1)
    else
      error("bad angle for rotate_neighborhood_rect: " .. tostring(angle))
    end

    return NB2
  end


  local function translate_neighborhood(list, loc)
    local new_nb = {}

    for _,NB in ipairs(list) do
      table.insert(new_nb, rotate_neighborhood_rect(NB, loc.rotate))
    end

    local base_x, base_y

        if loc.rotate ==   0 then base_x, base_y = loc.x1, loc.y1
    elseif loc.rotate ==  90 then base_x, base_y = loc.x2, loc.y1
    elseif loc.rotate == 180 then base_x, base_y = loc.x2, loc.y2
    elseif loc.rotate == 270 then base_x, base_y = loc.x1, loc.y2
    else error("Bad rotate in floor loc")
    end

    loc.base_x = base_x
    loc.base_y = base_y

    for _,NB in ipairs(new_nb) do
      if NB.x1 then NB.x1 = NB.x1 + base_x end
      if NB.y1 then NB.y1 = NB.y1 + base_y end

      if NB.x2 then NB.x2 = NB.x2 + base_x end
      if NB.y2 then NB.y2 = NB.y2 + base_y end
    end

    return new_nb
  end


  local function transmit_height(PF, z)
    if not PF.z or z > PF.z then
      PF.z = z
    end
  end


  local function transmit_height_to_fabs(floor, z)
    for _,PF in ipairs(floor.fabs) do
      transmit_height(PF, z)
    end
  end


  local function collect_floor_fabs(floor)
    for _,G in ipairs(floor.walks) do
      for _,P in ipairs(G.polys) do
        if P.post_fab then
          table.insert(floor.fabs, P.post_fab)
          P.post_fab.for_floor = floor
        end
      end

      if G.fabs then
        for _,PF in ipairs(G.fabs) do
          table.insert(floor.fabs, PF)
          PF.for_floor = floor
        end
      end
    end

    for _,A in ipairs(floor.airs) do
      if A.post_fab then
        table.insert(floor.fabs, A.post_fab)
        A.post_fab.for_floor = floor
      end
    end
  end


  local function OLD__render_floor(floor)
    assert(floor.z)

    local mat

    if R.outdoor then
      mat = rand.pick(LEVEL.courtyard_floors)
    else
      mat = rand.pick(LEVEL.building_floors)
    end

    floor.mat = mat

    mat = Mat_lookup(mat)

    local w_tex = mat.t
    local f_tex = mat.f or mat.t

    local flavor = "floor:1"
    if floor.three_d then flavor = "exfloor:1" end

    for _,P in ipairs(floor.space.polys) do
      local BRUSH = P:to_brush(w_tex)

      table.insert(BRUSH, 1, { m="solid", flavor=flavor })
      table.insert(BRUSH,    { t=floor.z, tex=f_tex })

      if floor.three_d then
        table.insert(BRUSH,  { b=floor.z - floor.three_d, tex=f_tex })
      end

      Trans.brush(BRUSH)
    end
  end


  local function render_liquid(floor)
    assert(floor.z)

    for _,P in ipairs(floor.space.polys) do
      if GAME.format == "doom" then
        local BRUSH = P:to_brush("LAVA1")
        table.insert(BRUSH, { t=floor.z - 64, tex="LAVA1", special=16 })
        Trans.brush(BRUSH)

      else  -- QUAKE

        local mat = R.skin.wall
        local liq = "*lava1"

        local BRUSH = P:to_brush(mat)
        table.insert(BRUSH, { t=floor.z - 128, tex=mat })
        Trans.brush(BRUSH)

        local LIQUID = P:to_brush(liq)
        table.insert(LIQUID, 1, { m="liquid", medium="lava" })
        table.insert(LIQUID, { t=floor.z - 64, tex=liq })
        Trans.brush(LIQUID)

        -- FIXME: do this later, use spot finder to determine valid places
        if rand.odds(90) then
          local x, y = geom.box_mid(P.bx1, P.by1, P.bx2, P.by2)
          local speed = rand.pick { 200,300,350,450 }
          Trans.entity("fireball", x, y, floor.z - 32, { speed=speed })
        end
      end
    end
  end


  local function inside_nb_rect(NB, x1,y1, x2,y2)
    if NB.x1 and x1 < NB.x1 - 0.1 then return false end
    if NB.x2 and x2 > NB.x2 + 0.1 then return false end

    if NB.y1 and y1 < NB.y1 - 0.1 then return false end
    if NB.y2 and y2 > NB.y2 + 0.1 then return false end

    return true
  end


  local function find_walk_in_neighborhood(nb_list, x1,y1, x2,y2)

    -- FIXME: this fails if a walk group crosses the line where two
    --        rectangles of the same space touch.

    for _,NB in ipairs(nb_list) do
      if not NB.m then
        if inside_nb_rect(NB, x1,y1, x2,y2) then
          return assert(NB.space)
        end
      end
    end

    return -1  -- not found
  end


  local function transfer_walks(floor, loc, new_floors)
    for _,G in ipairs(floor.walks) do
      local space = find_walk_in_neighborhood(loc.neighborhood, G.x1,G.y1, G.x2,G.y2)
      
      assert(space >= 1)
      assert(new_floors[space])

      table.insert(new_floors[space].walks, G)
    end
  end


  local function transfer_airs(floor, loc, new_floors)
    -- air spaces may exist in both halves

    for _,A in ipairs(floor.airs) do
      local space = find_walk_in_neighborhood(loc.neighborhood, A.bx1,A.by1, A.bx2,A.by2)

      if space >= 1 then
        assert(new_floors[space])
        table.insert(new_floors[space].airs, A)
      else
        -- add it to all floors (FIXME)
        for _,F in ipairs(new_floors) do
          table.insert(F.airs, A)
        end
      end
    end
  end


  local function transfer_nosplits(floor, loc, new_floors)
    for _,A in ipairs(floor.nosplits) do
      local space = find_walk_in_neighborhood(loc.neighborhood, A.bx1,A.by1, A.bx2,A.by2)

      if space >= 1 then
        assert(new_floors[space])
        table.insert(new_floors[space].nosplits, A)
      else
        -- add it to all floors (FIXME)
        for _,F in ipairs(new_floors) do
          table.insert(F.nosplits, A)
        end
      end
    end
  end


  local function floor_check_brush(coords, data)
    local m = coords[1].m

    if m == "floor" then
      local space = coords[1].space
      if not space then
        error("bad or missing space field in floor brush")
      end

      local F = data.new_floors[space]
      local POLY = POLYGON_CLASS.from_brush("free", coords)

      F.space:merge(POLY)

    elseif m == "walk" then
      local space = coords[1].space
      if not space then
        error("bad or missing space field in walk brush")
      end

      local F = data.new_floors[space]
      local POLY = POLYGON_CLASS.from_brush("walk", coords)

      -- new walk group
      local G =
      {
        polys = { POLY },
        x1 = POLY.bx1, y1 = POLY.by1,
        x2 = POLY.bx2, y2 = POLY.by2,
        walk_dz = coords[1].walk_dz,
      }

      if G.walk_dz then data.walk_dz = G.walk_dz end

      table.insert(F.walks, G)

      if not data.new_walks[space] then
        data.new_walks[space] = G
      end
    end

    return false
  end


  local function check_floor_fab(floor, loc)
    -- Requirements:
    --   1. at least one walk group in each new space
    --   2. no walk group is "cut" by dividing lines

gui.debugf("check_floor_fab:\n%s\n", table.tostr(loc, 1))

    local fab_info = PREFAB[loc.fab]

    local neighborhood = translate_neighborhood(fab_info.neighborhood, loc)

    loc.neighborhood = neighborhood


    local num_spaces = fab_info.num_spaces or 2

    local walk_counts = {}

    for _,G in ipairs(floor.walks) do
      local space = find_walk_in_neighborhood(neighborhood, G.x1,G.y1, G.x2,G.y2)

      if space < 0 then
gui.debugf("  cut walk space: (%d %d) .. (%d %d)\n", G.x1,G.y1, G.x2,G.y2)
        return false  -- the group was cut
      end

      walk_counts[space] = 1
    end

    for _,G in ipairs(floor.nosplits) do
      local space = find_walk_in_neighborhood(neighborhood, G.bx1,G.by1, G.bx2,G.by2)

      if space < 0 then
        return false  -- was cut
      end
    end

    if not fab_info.legless then
      for n = 1,num_spaces do
        if not walk_counts[n] then return false end
      end
    end

    return true  -- OK
  end


  local function space_from_neighborhood(old_space, space_index, loc)
    local new_space = SPACE_CLASS.new()

    for _,NB in ipairs(loc.neighborhood) do
      if not NB.m and NB.space == space_index then
        local piece = old_space:intersect_rect(NB.x1, NB.y1, NB.x2, NB.y2)

        new_space:raw_union(piece)
      end
    end

    return new_space
  end


  local function zone_clip_to_nb(old_zone, NB)
    local new_zone = table.copy(old_zone)

    if NB.x1 and NB.x1 > new_zone.x1 then new_zone.x1 = NB.x1 end
    if NB.y1 and NB.y1 > new_zone.y1 then new_zone.y1 = NB.y1 end
    if NB.x2 and NB.x2 < new_zone.x2 then new_zone.x2 = NB.x2 end
    if NB.y2 and NB.y2 < new_zone.y2 then new_zone.y2 = NB.y2 end

    return new_zone
  end


  local function zones_from_neighborhood(old_list, space_index, loc)
    local new_list = {}

    for _,old_zone in ipairs(old_list) do
      for _,NB in ipairs(loc.neighborhood) do
        if NB.m == "zone" and NB.space == space_index then
          local zone = zone_clip_to_nb(old_zone, NB)

          if zone.x2 > zone.x1 and zone.y2 > zone.y1 then
            table.insert(new_list, zone)
          end
        end
      end
    end

    return new_list
  end


  local function liquid_from_neighborhood(old_space, loc)
    local new_space  -- return nothing if no liquid rects

    for _,NB in ipairs(loc.neighborhood) do
      if NB.m == "lava" then
        if not new_space then
          new_space = SPACE_CLASS.new()
        end

        local piece = old_space:intersect_rect(NB.x1, NB.y1, NB.x2, NB.y2)

        new_space:raw_union(piece)
      end
    end

    return new_space
  end


  local function choose_division(floor, zone, fab, rotate)
    local zone_dx = zone.x2 - zone.x1
    local zone_dy = zone.y2 - zone.y1
gui.debugf("choose_division: zone = %dx%d\n", zone_dx, zone_dy)

    -- FIXME we only support subdividing single monotones right now
    if #R.mono_list > 1 then return nil end

    local fab_info = assert(PREFAB[fab])

    local x_size = fab_info.x_size
    local y_size = fab_info.y_size

    if rotate == 90 or rotate == 270 then
      x_size, y_size = y_size, x_size
    end

---    if fab_info.z_size and fab_info.z_size > zone_dz then
---      return
---    end

    local extra_x = zone_dx - x_size
    local extra_y = zone_dy - y_size

    if extra_x < 0 or extra_y < 0 then
gui.debugf("choose_division: zone too small: %dx%d < %dx%d\n", zone_dx, zone_dy,
           x_size, y_size)
      return nil
    end

    local locs = {}

    local half_ex = int(extra_x / 2)
    local half_ey = int(extra_y / 2)

gui.debugf("extra_x/y: %dx%d\n", extra_x, extra_y)

    for xp = 1,3 do for yp = 1,3 do
      local can_x = (xp == 1) or (xp == 2 and half_ex >= 32) or (xp == 3 and extra_x >= 32)
      local can_y = (yp == 1) or (yp == 2 and half_ey >= 32) or (yp == 3 and extra_y >= 32)

      if can_x and can_y then
        local x1, x2
        if xp == 1 then x1 = zone.x1 ; x2 = x1 + x_size end
        if xp == 2 then x1 = zone.x1 + half_ex ; x2 = x1 + x_size end
        if xp == 3 then x2 = zone.x2 ; x1 = x2 - x_size end

        local y1, y2
        if yp == 1 then y1 = zone.y1 ; y2 = y1 + y_size end
        if yp == 2 then y1 = zone.y1 + half_ey ; y2 = y1 + y_size end
        if yp == 3 then y2 = zone.y2 ; y1 = y2 - y_size end

        table.insert(locs, { fab=fab, x1=x1, y1=y1, x2=x2, y2=y2, rotate=rotate })
      end
    end end

    rand.shuffle(locs)

    for _,loc in ipairs(locs) do
      if check_floor_fab(floor, loc) then
        return loc
      end
    end
gui.debugf("[all locs failed]\n")

    return nil
  end


  local function choose_div_lotsa_stuff(floor)
    local fabs = { "H1_DOWN_4", "H1_DOWN_4",
                   "L1_DOWN_4", "H_LIQ_BRIDGE_A",
                   "L_LIQUID_1", "H_WALL_1",
                   "H_DIAGONAL_A", "H_DIAGONAL_A" }

    local rots = { 0, 90, 180, 270 }

    rand.shuffle(fabs)

    for _,fab in ipairs(fabs) do
      rand.shuffle(rots)
      for _,rot in ipairs(rots) do

        -- try each safe zone
        rand.shuffle(floor.zones)
        for _,zone in ipairs(floor.zones) do
          loc  = choose_division(floor, zone, fab, rot)
          if loc then return loc, zone end
        end
      end
    end

    return nil, nil  -- failed
  end


  local function subdivide_floor(floor, recurse_lev)
    gui.debugf("\nsubdivide_floor in %s  lev:%d\n", R:tostr(), recurse_lev)

    for _,Z in ipairs(floor.zones) do
      gui.debugf("zone: (%d %d) .. (%d %d)\n", Z.x1, Z.y1, Z.x2, Z.y2)
    end
    for _,G in ipairs(floor.walks) do
      gui.debugf("WALK: (%d %d) .. (%d %d)\n", G.x1,G.y1, G.x2,G.y2)
    end

    local loc, zone

    if recurse_lev <= 5 and #floor.walks >= 2 then
      loc, zone = choose_div_lotsa_stuff(floor)
    end

loc = nil
gui.debugf("location =\n%s\n", table.tostr(loc, 3))

    if not loc then
      table.insert(R.all_floors, floor)

      for _,G in ipairs(floor.walks) do G.floor = floor end
      for _,A in ipairs(floor.airs)  do A.floor = floor end

      return
    end

-- stderrf("*************** : %s\n", loc.fab)

    ----- DO THE SUBDIVISION -----

    local fab        = loc.fab
    local fab_info   = PREFAB[fab]
    local num_spaces = fab_info.num_spaces or 2

    local new_floors = {}

    for i = 1,num_spaces do
      new_floors[i] = { walks={}, airs={}, nosplits={}, fabs={} }
    end

    transfer_walks(floor, loc, new_floors)
    transfer_airs (floor, loc, new_floors)
    transfer_nosplits (floor, loc, new_floors)

    for idx,F in ipairs(new_floors) do
      F.space = space_from_neighborhood(floor.space, idx, loc)
      F.zones = zones_from_neighborhood(floor.zones, idx, loc)

      if fab_info.neighborhood[1].z1 and idx == 2 then  -- FIXME !!!!!
        F.three_d = 16
      end
    end


    local liquid = liquid_from_neighborhood(floor.space, loc)

    if liquid then
      table.insert(R.all_liquids, { space=liquid })
    end


    -- create transform
    local T = {}

    T.add_x = loc.base_x
    T.add_y = loc.base_y
    T.add_z = 0  -- dummy value

    T.rotate = loc.rotate

    if loc.rotate == 90 or loc.rotate == 270 then
      T.fit_width = loc.y2 - loc.y1
      T.fit_depth = loc.x2 - loc.x1
    elseif loc.rotate == 0 or loc.rotate == 180 then
      T.fit_width = loc.x2 - loc.x1
      T.fit_depth = loc.y2 - loc.y1
    else
      error("Bad floor rotate: " .. tostring(loc.rotate))
    end


    local skin1 = { top="WIZMET1_1" }

    -- save info to render it later
    local POST_FAB =
    {
      fab = fab,
      trans = T,

      skin1 = skin1,
      skin2 = skin2,
      skin3 = skin3,

      R = R,
      fab_tag = Plan_alloc_id("prefab"),

      polys = {},

      loc = loc,
      new_floors = new_floors,
      new_walks = {},
    }

    -- FIXME: only process the skins ONCE
    table.insert(R.post_fabs, POST_FAB)

    Trans.set_override(floor_check_brush, POST_FAB)

    Fabricate(fab, T, { skin })

    Trans.clear_override()


    -- the prefab for this floor is associated with it's first walk area
    -- in the old space.  That is the mechanism which allows the old
    -- space to tbe further sub-divided and yet allow the prefab to
    -- get the correct floor height.
    assert(POST_FAB.new_walks[1])

    if not POST_FAB.new_walks[1].fabs then POST_FAB.new_walks[1].fabs = {} end

    table.insert(POST_FAB.new_walks[1].fabs, POST_FAB)


    -- similar logic for stairs, use the walk area to determine the
    -- correct floor -- cannot reference the floor directly since
    -- they "die" when they are split into two.

    -- FIXME: does not handle triple spaces
    local STAIR =
    {
      walk1 = assert(POST_FAB.new_walks[1]),
      walk2 = assert(POST_FAB.new_walks[2]),

      delta = assert(POST_FAB.walk_dz),
    }

    table.insert(R.all_stairs, STAIR)

    -- recursively handle new pieces (order does not matter)

    for _,F in ipairs(new_floors) do
      subdivide_floor(F, recurse_lev+1)
    end
  end


  local function assign_floor_heights()
    -- find the floor which touches the entrance
    local start_F

    for _,floor in ipairs(R.all_floors) do
      for _,G in ipairs(floor.walks) do
        for _,P in ipairs(G.polys) do
          if P.is_entry then
            start_F = floor
            break;
          end
        end
      end
      if start_F then break; end
    end

    -- if not found (e.g. start room, teleporter entry), pick any one
    if not start_F then
      start_F = R.all_floors[1]
    end

    assert(start_F)

    start_F.z = R.entry_floor_h

    for loop = 1, 2*#R.all_floors do
      for _,ST in ipairs(R.all_stairs) do
        local F1 = assert(ST.walk1.floor)
        local F2 = assert(ST.walk2.floor)
        assert(ST.delta)

        if F1.z and not F2.z then F2.z = F1.z + ST.delta end
        if F2.z and not F1.z then F1.z = F2.z - ST.delta end
      end
    end

    -- validate
    for _,F in ipairs(R.all_floors) do
      if not F.z then
        error("floor space did not get any height!")
      end
    end
  end


  local function build_floor()

    -- initial floor space

    local floor =
    {
      space = Layout_initial_space(R),
      walks = collect_walk_groups(),  -- FIXME only walks in each monotone
      airs  = collect_airs(),
      nosplits = collect_no_splits(),
      fabs  = {},
    }

    floor.zones = determine_safe_zones(R.mono_list[1], floor.walks)

    R.all_floors = {}
    R.all_stairs = {}
    R.all_liquids = {}

    subdivide_floor(floor, 1)

    assign_floor_heights()


    for _,F in ipairs(R.all_floors) do
      collect_floor_fabs(F)

      render_floor(F)

      R.floor_min_h = math.min(R.floor_min_h, F.z)
      R.floor_max_h = math.max(R.floor_max_h, F.z)

      transmit_height_to_fabs(F, F.z)

    end

    for _,F in ipairs(R.all_liquids) do
      F.z = R.floor_min_h
      render_liquid(F)
    end
  end


  --- NEW --- NEW --- NEW --- NEW --- NEW --- NEW --- NEW --- > > >

  local function extract_t(brush)
    local t = Trans.brush_get_t(brush)

    if t then
      R.entry_floor_h = t
      R.entry_walk = brush
      return
    end

    error("Missing height in straddler walk brush")
  end


  local function find_entry_walk()
    for _,fab in ipairs(R.prefabs) do
      if fab.straddler and fab.straddler.R2 == R then
        for _,B in ipairs(fab.brushes) do
          if B[1].m == "walk" and B[1].room == 2 then
            -- found it
            extract_t(B)
            return
          end
        end
      end
    end
  end


  local function collect_spaces(kind)
    local list = {}

    for _,fab in ipairs(R.prefabs) do
      local is_entry = (fab.straddler and fab.straddler.R2 == R)
      
      if fab.room == R or is_entry then
        for _,B in ipairs(fab.brushes) do
          if B[1].m == kind and
             (not B[1].room or B[1].room == sel(is_entry, 2, 1))
          then
            table.insert(list, B)
          end
        end
      end
    end

    return list
  end


  local function narrow_zone_for_edge(zone, E)
    if not E.max_deep then return end

    local K = E.K

    if E.side == 4 then
      local x = K.x1 + E.max_deep
      if x > zone.x1 then zone.x1 = x end

    elseif E.side == 6 then
      local x = K.x2 - E.max_deep
      if x < zone.x2 then zone.x2 = x end

    elseif E.side == 2 then
      local y = K.y1 + E.max_deep
      if y > zone.y1 then zone.y1 = y end

    elseif E.side == 8 then
      local y = K.y2 - E.max_deep
      if y < zone.y2 then zone.y2 = y end

    else
      error("bad edge side")
    end
  end

  
  local function narrow_zone_for_walk(zone, brush)
    -- this is meant to handle a walk group penetrating a small
    -- distance into one side of the zone.
    --
    -- it is NOT meant for a walk group IN THE MIDDLE of the zone
    -- (from a pickup or switch).  That should be prevented, e.g.
    -- create multiple zones around it.

    if zone.x2 < zone.x1 or zone.y2 < zone.y1 then
      return
    end

    local x1, y1, x2, y2 = Trans.brush_bbox(brush)

    if geom.boxes_overlap(zone.x1, zone.y1, zone.x2, zone.y2,
                          x1, y1, x2, y2)
    then
      local dx = math.max(16, zone.x2 - zone.x1)
      local dy = math.max(16, zone.y2 - zone.y1)

      -- pick side which wastes the least volume
      local vol_x1 = int(x2 - zone.x1) * int(dy)
      local vol_x2 = int(zone.x2 - x1) * int(dy)

      local vol_y1 = int(y2 - zone.y1) * int(dx)
      local vol_y2 = int(zone.y2 - y1) * int(dx)

      local min_vol = math.min(vol_x1, vol_y1, vol_x2, vol_y2)

          if vol_x1 == min_vol then zone.x1 = x2  -- move left side
      elseif vol_x2 == min_vol then zone.x2 = x1  -- move right side
      elseif vol_y1 == min_vol then zone.y1 = y2  -- move bottom side
      else                          zone.y2 = y1  -- move top side
      end
    end
  end


  local function zone_from_block(block, walks)
    local kx1, ky1 = block.kx1, block.ky1
    local kx2, ky2 = block.kx2, block.ky2

    local K1 = SECTIONS[kx1][ky1]
    local K2 = SECTIONS[kx2][ky2]

    local zone = 
    {
      x1 = K1.x1,
      y1 = K1.y1,
      x2 = K2.x2,
      y2 = K2.y2,
    }

    -- check wall edges

    for kx = kx1,kx2 do for ky = ky1,ky2 do
      local K = SECTIONS[kx][ky]
      for _,E in pairs(K.edges) do
        narrow_zone_for_edge(zone, E)
      end
    end end

    -- !!!! FIXME: check corners too

    -- allow some room for player
    zone.x1 = zone.x1 + 64
    zone.y1 = zone.y1 + 64
    zone.x2 = zone.x2 - 64
    zone.y2 = zone.y2 - 64

    -- check walk brushes
    -- (done AFTER allowing some room for player, since walk areas
    --  already guarantee the player can fit).

    for _,W in ipairs(walks) do
      narrow_zone_for_walk(zone, W)
    end

    zone.x1 = zone.x1 + 8
    zone.y1 = zone.y1 + 8
    zone.x2 = zone.x2 - 8
    zone.y2 = zone.y2 - 8

    return zone
  end


  local function determine_safe_zones(mono, walks)
    --
    -- A "safe zone" is a rectangle inside the current room which
    -- could be make solid while still allowing the player to fully
    -- traverse the room (from one door to another etc).
    --
    -- Since safe zones must be rectangles, but rooms can be more
    -- interesting shapes (plus, L, odd) then we allow multiple
    -- (non overlapping) safe zones to exist.

    local list = {}

    for _,block in ipairs(mono.blocks) do
      local zone = zone_from_block(block, walks)

      if zone.x2 > zone.x1 and zone.y2 > zone.y1 then
        table.insert(list, zone)
      end
    end

    return list
  end


  local function bump_and_build_fab(fab, walk, z)
    assert(not fab.built)

    local walk_t = assert(Trans.brush_get_t(walk))

    Fab_transform_Z(fab, { add_z = z - walk_t })

    Fab_render(fab)
  end


  local function initial_floor()
    local F =
    {
      level = 1,
    }

    F.brushes = Layout_initial_space2(R)

    F.walks    = collect_spaces("walk")
    F.nosplits = collect_spaces("nosplit")
    F.airs     = collect_spaces("air")

    assert(#F.walks > 0)

    F.zones = determine_safe_zones(R.mono_list[1], F.walks)

    if R.entry_walk then
      F.entry = R.entry_walk
      -- should be a door which has already been built
      assert(F.entry[1].fab.built)
    else
      -- entry must be a teleporter.
      -- pick any walk brush and built it's prefab

      F.entry = rand.pick(F.walks)

      local fab = assert(F.entry[1].fab)

      bump_and_build_fab(fab, F.entry, R.entry_floor_h)
    end

    return F
  end


  local function render_floor(F)
    assert(F.entry)

    F.z = assert(Trans.get_brush_t(F.entry))

    table.insert(R.all_floors, F)

    -- assign height to prefabs and out-going straddlers
    for _,W in ipairs(F.walks) do
gui.debugf("WALK = \n")
Trans.dump_brush(W)
      local fab = W[1].fab

      if not fab.built then
        bump_and_build_fab(fab, W, F.z)
      end
    end

    -- pick a floor texture
    if not F.mat then
      if R.outdoor then
        F.mat = rand.pick(LEVEL.courtyard_floors)
      else
        F.mat = rand.pick(LEVEL.building_floors)
      end
    end

    -- create the brushes
    local mat = Mat_lookup(F.mat)

    local w_tex = mat.t
    local f_tex = mat.f or mat.t

    for _,B in ipairs(F.brushes) do
      table.insert(B, { t=F.z, tex=f_tex })

      Trans.brush(B)
    end

    R.floor_min_h = math.min(R.floor_min_h, F.z)
    R.floor_max_h = math.max(R.floor_max_h, F.z)
  end


  local function possible_floor_prefabs()
    local tab = table.copy(THEME.floors)

    -- TODO: filter based on various stuff...
    
    if table.empty(tab) then
      error("No floor prefabs are possible in room")
    end

    return tab
  end


  local function count_spaces(fab)
    local count = 0

    for _,B in ipairs(fab.brushes) do
      if B[1].m and B[1].space then
        count = math.max(count, B[1].space)
      end
    end

    fab.num_spaces = count
  end


  local function find_containing_space(fab, walk)
    for _,B in ipairs(fab.brushes) do
      if B[1].m == "floor" then
--!!!!!!!!!!!
if R.id == 12 then
gui.debugf("brush_contains_brush:\n")
Trans.dump_brush(B)
Trans.dump_brush(walk)
end
        if Trans.brush_contains_brush(B, walk) then
gui.debugf("\nYES\n")
          return B
        end
      end
    end

    return nil -- not found
  end


  local function check_air_clobbered(fab, A)
    -- FIXME
    return false
  end


  local function full_test_floor_fab(F, fab)
    --
    -- Requirements:
    --
    --   1. each existing walk / nosplit brush exists completely inside
    --      one of the new floor spaces.
    --
    --   2. each new floor space contains at least one existing walk brush.
    --      TODO: relax this requirement if num_spaces >= 3
    --
    --   3. existing air brushes do not touch any new solid which is
    --      infinitely tall or so.
    --

    local space_has_walk = {}

    -- FIXME: this is too simple, allow a walk (etc) to span two or more
    --        floor brushes of the same space.

    for _,W in ipairs(F.walks) do
      local con = find_containing_space(fab, W)
gui.debugf("|  walk con : %s\n", tostring(con))
      if not con then return nil end

      W[1].con = con
      space_has_walk[con[1].space] = 1
    end

    for _,NS in ipairs(F.nosplits) do
      local con = find_containing_space(fab, NS)
gui.debugf("|  nosplit con : %s\n", tostring(con))
      if not con then return nil end
      NS[1].con = con
    end
       
    for _,A in ipairs(F.airs) do
      if check_air_clobbered(fab, A) then return nil end
    end

    -- SUCCESS --
    local info = { fab=fab }

    return info
  end


  local function test_floor_fab(F, skin, zone, rotate)
    -- preliminary size check
    -- (try to avoid the expensive prefab creation)

    local zone_dx = zone.x2 - zone.x1
    local zone_dy = zone.y2 - zone.y1
gui.debugf("choose_division: zone = %dx%d\n", zone_dx, zone_dy)

    local raw_fab = assert(PREFAB[skin._prefab])

    local x_size = raw_fab.x_size
    local y_size = raw_fab.y_size

    if rotate == 90 or rotate == 270 then
      x_size, y_size = y_size, x_size
    end

    local extra_x = zone_dx - x_size
    local extra_y = zone_dy - y_size

    if extra_x < 0 or extra_y < 0 then
gui.debugf("choose_division: zone too small: %dx%d < %dx%d\n", zone_dx, zone_dy, x_size, y_size)
      return nil
    end

    count_spaces(raw_fab)

    -- make a list of locations to try
    local locs = {}

    -- FIXME: check many places

    local dir = 2
    if rotate ==  90 then dir = 6 end
    if rotate == 180 then dir = 8 end
    if rotate == 270 then dir = 4 end

    table.insert(locs, Trans.box_transform(zone.x1, zone.y1,
                         zone.x1 + x_size, zone.y1 + y_size, nil, dir))

    -- check each location...

    for _,T in ipairs(locs) do
gui.debugf("|  trying loc:\n%s\n", table.tostr(T, 1))
      -- create prefab to perform full check
      local fab = Fab_create(skin._prefab)

      Fab_apply_skins(fab, { THEME.skin or {}, R.skin or {}, skin })
      Fab_transform_XY(fab, T)

---###      for _,W in ipairs(fab.brushes) do
---###        if W[1].m == "walk" then W[1].fab = fab end
---###      end

      local info = full_test_floor_fab(F, fab)

      -- success?
      if info then return info end
    end

    return nil  -- fail
  end


  local function find_usable_floor(F)
gui.debugf("find_usable_floor in %s level:%d\n", R:tostr(), F.level)
gui.debugf("zones = \n%s\n", table.tostr(F.zones, 2))
    -- FIXME we only support subdividing single monotones right now
    if #R.mono_list > 1 then return nil end

    -- FIXME: .....recursion limit for testing.....
    if F.level >= 2 then return nil end

    local poss = possible_floor_prefabs()

    local ROTS = { 0 }  --!!!!!! FIXME  { 0, 90, 180, 270 }

    rand.shuffle(F.zones)

    for loop = 1,20 do
      if table.empty(poss) then break; end

      local skinname = rand.key_by_probs(poss)
      poss[skinname] = nil

      local skin = assert(GAME.SKINS[skinname])

      rand.shuffle(ROTS)

      for _,rotate in ipairs(ROTS) do
        for _,zone in ipairs(F.zones) do
gui.printf("|  TEST_FLOOR_FAB ::::::: %s\n", skinname)
          local info = test_floor_fab(F, skin, zone, rotate)

          -- found a usable prefab?
          if info then return info end
        end
      end
    end

    return nil  -- failed
  end


  local function do_intersection(list, info, FB, B)
    local x1,y1,x2,y2 = Trans.brush_bbox(FB)
    local x3,y3,x4,y4 = Trans.brush_bbox(B)

    if not geom.boxes_overlap(x1,y1,x2,y2, x3,y3,x4,y4) then
      return
    end

    if Trans.brush_contains_brush(FB, B) then
      table.insert(list, B)
      return
    end

    -- FIXME !!!!
    assert(Trans.brush_is_quad(FB))

    local B = Trans.copy_brush(B)

    local function try_cut(px1, py1, px2, py2)
      if Trans.line_cuts_brush(B, px1, py1, px2, py2) then
         Trans.      cut_brush(B, px1, py1, px2, py2)
      end
    end

    try_cut(x1,  0, x1, 40)
    try_cut(x2, 40, x2,  0)
    try_cut( 0, y2, 40, y2)
    try_cut(40, y1,  0, y1)
      
    local x3,y3,x4,y4 = Trans.brush_bbox(B)

    if not geom.boxes_overlap(x1,y1,x2,y2, x3,y3,x4,y4) then
      return
    end

    table.insert(list, B)
  end


  local function intersect_brushes(brushes, info, space)
    local list = {}

    for _,FB in ipairs(info.fab.brushes) do
      if FB[1].m == "floor" and FB[1].space == space then
        for _,B in ipairs(brushes) do
          do_intersection(list, info, FB, B)
        end
      end
    end

    return list
  end


  local function transfer_spaces(walks, info, space)
    local list = {}

    for _,B in ipairs(walks) do
      -- the 'con' field was set by full_test_floor_fab()
      local con = B[1].con

      if con then
        assert(con[1].space)
        if con[1].space == space then
          table.insert(list, B)
        end

      else
        assert(B[1].m == "air")

        -- FIXME: if air_touches_space(info.fab, space, B) then ... end
      end
    end

    return list
  end


  local function transfer_zones(zones, info, space)
    local list = {}

    for _,zone in ipairs(zones) do
      for _,ZB in ipairs(info.fab.brushes) do
        if ZB[1].m == "zone" and ZB[1].space == space then
          local x1, y1, x2, y2 = Trans.brush_bbox(ZB)
          
          x1 = math.max(x1, zone.x1) ; x2 = math.min(x2, zone.x2)
          y1 = math.max(y1, zone.y1) ; y2 = math.min(y2, zone.y2)

          if x1 < x2 and y1 < y2 then
            table.insert(list, { x1=x1, y1=y1, x2=x2, y2=y2 })
          end
        end
      end
    end

    return list
  end


  local function create_new_floor(F, info, space)
    local floor =
    {
      level = F.level + 1,
      space = space,
    }

    floor.brushes  = intersect_brushes(F.brushes, info, space)

    floor.walks    = transfer_spaces(F.walks,    info, space)
    floor.nosplits = transfer_spaces(F.nosplits, info, space)
    floor.airs     = transfer_spaces(F.airs,     info, space)

    floor.zones    = transfer_zones(F.zones, info, space)

    -- is entry brush in this floor?
    for _,W in ipairs(floor.walks) do
      if W == F.entry then
        F.entry_space = space
      end
    end

    -- add the walks/airs/nosplits from prefab
    for _,B in ipairs(info.fab.brushes) do
      if B[1].space == space then
        if B[1].m == "walk"    then table.insert(floor.walks, B) end
        if B[1].m == "air"     then table.insert(floor.airs,  B) end
        if B[1].m == "nosplit" then table.insert(floor.nosplits, B) end
      end
    end 

    return floor
  end


  local function find_prefab_walk_t(fab)
    assert(fab.bumped)

    for _,B in ipairs(fab.brushes) do
      if B[1].m == "walk" and B[1].walk_z then
        return assert(Trans.brush_get_t(B))
      end
    end

    error("WTF")
  end


  local function find_new_entry_walk(F, info)
    for _,B in ipairs(info.fab.brushes) do
      if B[1].m == "walk" and B[1].space == F.space then
        return B
      end
    end

    error("unable to find new floor's entry walk")
  end


  local function subdivide(F, info)
    local new_floors = {}

    for i = 1,info.fab.num_spaces do
      new_floors[i] = create_new_floor(F, info, i)
    end

    -- grab the new floor which contains the entry walk brush.  That
    -- brush is the only one with a known fixed height, and we need
    -- to recursively handle that floor before the others (since the
    -- others floors have nothing to get their heights from).

    assert(F.entry_space)

    local first = table.remove(new_floors, F.entry_space)

    first.entry = F.entry

    -- TODO: if we allow prefab with "unused" spaces (i.e. there
    --       were less walk brushes than spaces), then we need to
    --       ensure that the entry brush exists in a used space.

    -- recursively handle it
    try_subdivide_floor(first)

---##    -- at this point, one of our prefab's walk brushes should have
---##    -- a known height (since the first floor has been rendered now).
---##    --
---##    -- Hence we can now transform and render the floor prefab, which
---##    -- will give all the other walk brushes in the prefab a known
---##    -- fixed height.
---##
---##    local walk_t = find_prefab_walk_t(info.fab)
---##
---##    Fab_transform_Z(info.fab, { add_z = add_z })
---##
---##    Fab_render(info.fab)

    -- recursively handle the remaining pieces
    for _,F2 in ipairs(new_floors) do
      F2.entry = find_new_entry_walk(F2, info)
      F2.entry[1].walk_z = assert(Trans.brush_get_t(F2.entry))

      try_subdivide_floor(F2)
    end
  end


  function try_subdivide_floor(F)
    local info = find_usable_floor(F)

    if info then
      subdivide(F, info)
      return
    end

    -- unable to divide further
    render_floor(F)
  end


  local function prepare_ceiling()
    local h = ROOM.floor_max_h + rand.pick { 192, 256, 320, 384 }

    if R.outdoor then
      R.sky_h = h
    else
      R.ceil_h = h
    end
  end


  ---===| Layout_the_floor |===---

  ROOM = R  -- set global

  gui.debugf("\nLayout_the_floor @ %s\n\n", ROOM:tostr())

  find_entry_walk()

  if not R.entry_floor_h then
    R.entry_floor_h = rand.pick { 128, 192, 256, 320 }
  end

  R.all_floors = {}

  R.floor_min_h = R.entry_floor_h
  R.floor_max_h = R.entry_floor_h


  local floor = initial_floor()

  -- this will render floors as it goes
  try_subdivide_floor(floor)

  prepare_ceiling()
end



function Layout_spots_in_room(R)

  local function fill_polygons(space, values)
    for _,P in ipairs(space.polys) do
      local val = values[P.kind]
      if val then
        gui.spots_fill_poly(val, P.coords)
      end
    end
  end


  local function spots_for_floor(floor)
if table.empty(floor.space.polys) then return end
    gui.spots_begin(floor.space:calc_bbox())

    fill_polygons(floor.space, { free=0, air=0, walk=0 })

    fill_polygons(R.wall_space, { solid=1 })

    for _,F in ipairs(R.all_floors) do
      if F ~= floor and F.layer == floor.layer then
        fill_polygons(F.space, { free=1, air=1, walk=1 })
      end
    end

    gui.spots_dump("Spot grid")

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
      spot.z = floor.z
      table.insert(R.item_spots, spot)
    end

--[[  TEST
    for _,spot in ipairs(R.item_spots) do
      Trans.entity("potion", spot.x, spot.y, 0)
    end
--]]
  end


  ---| Layout_spots_in_room |---

  -- collect spots for the monster code
  for _,F in ipairs(R.all_floors) do
--!!!!!! FIXME FIXME    spots_for_floor(F)
  end
end



function Layout_flesh_out_floors(R)
  -- use the safe zones to place scenery fabs in unused areas

  -- HMMMMMMM!!!!  similar to normal floor "divide" mechanism
  --               except that floor is not divided, lololol

  -- FIXME

--[[ TEST
  for _,F in ipairs(R.all_floors) do
      for _,Z in ipairs(F.zones) do
        if Z.x2 >= Z.x1+16 and Z.y2 >= Z.y1+16 then
--        Trans.quad(Z.x1, Z.y1, Z.x2, Z.y2, F.z - 2, F.z + 8, Mat_normal("ASHWALL"))
          
          local T = Trans.spot_transform(Z.x1 + 16, Z.y1 + 16, F.z)
          Fabricate("QUAKE_TECHLAMP", T, {})
        end
      end
  end
--]]
end



function Layout_all_floors()
  for _,R in ipairs(LEVEL.all_rooms) do
    Layout_the_floor(R)
    Layout_build_walls(R)
    Layout_flesh_out_floors(R)
  end
end



function Layout_all_ceilings()

  local function quake_temp_lights(R)
    for _,K in ipairs(R.sections) do
      local z = R.ceil_h - rand.pick { 50, 80, 110, 140 }
      local light = rand.pick { 50, 100, 150, 200 }
      local radius = ((K.x2 - K.x1) + (K.y2 - K.y1)) / 3

      local mx, my = geom.box_mid(K.x1, K.y1, K.x2, K.y2)

      Trans.entity("light", mx, my, z, { light=light, _radius=radius })
    end
  end


  local function build_ceiling(R)
    if R.sky_h then
      for _,K in ipairs(R.sections) do
        Trans.quad(K.x1, K.y1, K.x2, K.y2, 384+R.sky_h, nil, Mat_normal("_SKY"))
      end

      return
    end

    assert(R.ceil_h)

    local mat = rand.key_by_probs(THEME.building_ceilings)

    local props, w_face, p_face = Mat_normal(mat)

    for _,K in ipairs(R.sections) do
      local x1, y1, x2, y2 = Layout_shrunk_section_coords(K)
      Trans.quad(x1, y1, x2, y2, 512+R.ceil_h, nil, { m="solid", flavor="ceil:1" }, w_face, p_face)
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

    for _,K in ipairs(R.sections) do
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

  for _,R in ipairs(LEVEL.all_rooms) do
    build_ceiling(R)
    ambient_lighting(R)

    Layout_spots_in_room(R)
  end
end

