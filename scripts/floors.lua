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

require 'defs'
require 'util'



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
--FIXME FIXME !!!!!!     P.m_shadowed = pass
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

    local MONO =
    {
      sections = {},
      blocks = {},
    }

    table.insert(R.mono_list, MONO)

    repeat
      table.insert(MONO.sections, K)

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



function Layout_initial_space(mono)
  local list = {}

  for _,K in ipairs(mono.sections) do
    local BRUSH = Trans.bare_quad(K.x1, K.y1, K.x2, K.y2)

    table.insert(list, BRUSH)
  end

  return list
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



function Layout_possible_prefab_from_list(tab, where, req_key)

  assert(tab)

  -- FIXME: fix this rubbish somehow
  if tab == "SWITCH" then
    if where ~= "edge" then return nil end
    return "SWITCH"
  end


  local function match(skin)
    -- TODO: more sophisticated matches (prefab.environment)

    if skin._where ~= where then return false end

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



--[[  CLASS INFORMATION  ---------------------------------------

class FLOOR
{
}

----------------------------------]]


function Chunky_floor(R)

  local function touches_wall(C)
    -- Todo ??

    return false
  end


  local function do_floor(C)
    local h = R.floor_min_h + rand.irange(0,16)

    local name = rand.pick { "FLAT1", "FLAT10", "FLAT14", "FLAT1_1",
                             "FLAT20", "GRASS1", "FLAT5_1",
                             "FLAT5_3", "FLAT5_5" }
--[[
    if not touches_wall(K) then
      h = -3C
      name = "NUKAGE1"
    end
--]]
    local mat = Mat_lookup(name)

    local w_tex = mat.t
    local f_tex = mat.f or mat.t

    local brush = Trans.bare_quad(C.x1, C.y1, C.x2, C.y2)

    Trans.set_tex(brush, w_tex)

    table.insert(brush, { t=h, tex=f_tex })

    gui.add_brush(brush)
  end

  for _,C in ipairs(R.chunks) do
    do_floor(C)
  end
end


function Layout_the_floor(R)

  local function handle_entry_walk(brush)
    local b = Trans.brush_get_b(brush)

    if not b then
      error("Missing height in straddler walk brush")
    end

    R.entry_walk = brush
    R.entry_floor_h = b
  end


  local function find_entry_walk()
    for _,fab in ipairs(R.prefabs) do
      if fab.straddler and fab.straddler.R2 == R then
        for _,B in ipairs(fab.brushes) do
          if B[1].m == "walk" and B[1].room == 2 then
            -- found it
            handle_entry_walk(B)
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
    assert(not fab.rendered)

    local walk_z = assert(Trans.brush_get_b(walk))

    Fab_transform_Z(fab, { add_z = z - walk_z })
    Fab_render(fab)
  end


  local function floor_from_mono(mono)
    local F =
    {
      recursion = 0,
    }

    F.brushes = Layout_initial_space(mono)

    -- FIXME: only consider prefabs in current monotone
    F.walks    = collect_spaces("walk")
    F.nosplits = collect_spaces("nosplit")
    F.airs     = collect_spaces("air")

--!!!!!!    assert(#F.walks > 0)

    F.zones = determine_safe_zones(mono, F.walks)

    return F
  end


  local function initial_floors()
    R.all_floors = {}

    for _,mono in ipairs(R.mono_list) do
      local FLOOR = floor_from_mono(mono)

      table.insert(R.all_floors, FLOOR)
    end

    -- FIXME : properly find floor with the entry walk

    local F = R.all_floors[1]

    if R.entry_walk then
      -- should be a door which has already been rendered
      assert(R.entry_walk[1].fab.rendered)

      F.entry = R.entry_walk
    else
      -- entry must be a teleporter or start pedestal
      -- pick any walk brush and build it's prefab

--!!!!!! HALLWAY TOO      assert(R.purpose == "START" or R:has_teleporter())

      -- FIXME: some walks may not have a prefab (between monotonic spaces)

--!!!!!!!!
--[[
      F.entry = rand.pick(F.walks)

      local fab = assert(F.entry[1].fab)

      bump_and_build_fab(fab, F.entry, R.entry_floor_h)
--]]
    end

    F.z = 64 --!!!!!! assert(Trans.brush_get_b(F.entry))
  end


  local function render_floor(F)
    F.rendered = true

--!!!!!!    assert(F.entry)
    assert(F.z)

    -- set height
--Trans.dump_brush(F.entry, "F.entry")

    R.floor_min_h = math.min(R.floor_min_h, F.z)
    R.floor_max_h = math.max(R.floor_max_h, F.z)

    -- assign height to prefabs and out-going straddlers
    for _,W in ipairs(F.walks) do
      local fab = W[1].fab

      if not fab.rendered then
        bump_and_build_fab(fab, W, F.z)
      end

      -- FIXME : collect "hole" brushes, apply to this floor
    end

    -- update heights in air brushes
    for _,A in ipairs(F.airs) do
      local fab = A[1].fab
      fab.air_z = math.max(fab.air_z or -9999, F.z)
    end

    -- pick a floor texture
    if not F.mat then
      if R.outdoor then
        F.mat = rand.pick(LEVEL.courtyard_floors)
      else
        F.mat = rand.pick(LEVEL.building_floors)
      end
    end

    -- prepare bounding box
    F.bbox = geom.bbox_new()

    -- add the brushes
    local mat = Mat_lookup(F.mat)

    local w_tex = mat.t
    local f_tex = mat.f or mat.t

    for _,B in ipairs(F.brushes) do
      Trans.set_tex(B, w_tex)

      table.insert(B, { t=F.z, tex=f_tex })

---##   if F.z_low then
---##   --!!!! assert(F.z_low < F.z)
---##   if (F.z_low >= F.z) then F.z_low = F.z - 16 end
---##     table.insert(B, { b=F.z_low, tex=f_tex })
---##   end

---!!!!      Trans.brush(B)   -- TODO: gui.add_brush() may be sufficient

      geom.bbox_add_rect(F.bbox, Trans.brush_bbox(B))
    end

gui.debugf("render_floor @ %s  z:%d low:%s high:%s  (%d %d)..(%d %d)\n",
           R:tostr(), F.z, tostring(F.z_low), tostring(F.z_high),
           F.bbox.x1, F.bbox.y1, F.bbox.x2, F.bbox.y2)
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


  local function find_containing_spaces(fab, walk)
    local list = {}

    for _,B in ipairs(fab.brushes) do
      if B[1].m == "floor" then
        if Trans.brush_contains_brush(B, walk) then
          table.insert(list, B)
        end
      end
    end

    return list
  end


  local function check_air_clobbered(fab, A)
    -- FIXME
    return false
  end


  local function full_test_floor_fab(F, fab)
    --
    -- Requirements:
    --
    --   1. each existing walk brush lies completely inside one of
    --      the new floor spaces.
    --
    --TODO 2. no existing nosplit brush straddles one of the new floor
    --        spaces, or is clobbered by solid brushes.
    --
    --   3. existing air brushes do not touch any new solid which is
    --      infinitely tall or so.
    --
    --   4. each new floor space contains at least one existing walk brush.
    --      TODO: relax this requirement if num_spaces >= 3
    --
    --TODO 5. each new walk brush is not clobbered by existing solids.
    --

    local walk_counts = {}
    local entry_space

    -- FIXME: this is too simple, allow a walk (etc) to span two or more
    --        floor brushes of the same space.

    rand.shuffle(F.walks)

    -- #1 --
    for _,W in ipairs(F.walks) do
      local con = find_containing_spaces(fab, W)
      if con == "cut" then return nil end
---gui.debugf("|  walk con %d/%d : %d\n", _, #F.walks, #con)
      if table.empty(con) then return nil end

      if #con > 1 then
        -- FIXME !!!! WRONG
        if (_ % 2) == 0 then table.remove(con, 1) end
      end

      local brush = con[1]

      W[1].con = brush

      walk_counts[brush[1].space] = 1

      if W == F.entry then entry_space = brush[1].space end
    end

    -- #2 --
    for _,NS in ipairs(F.nosplits) do
      -- FIXME: is OK if nosplit ends up in no space (e.g. lava)
      local con = find_containing_spaces(fab, NS)
      if con == "cut" then return nil end
---gui.debugf("|  nosplit cons : %d\n", #con)
      if table.empty(con) then return nil end
    end
       
    -- #3 --
    for _,A in ipairs(F.airs) do
      if check_air_clobbered(fab, A) then return nil end
    end

    -- #4 --
    for n = 1,fab.num_spaces do
      if not walk_counts[n] then return false end
    end

    -- #5 --
    -- TODO

    -- find prefab walk brush in same space as the entry brush
    assert(entry_space)
    local ref_W
    for _,W in ipairs(fab.brushes) do
      if W[1].m == "walk" and W[1].space == entry_space then
        ref_W = W ; break;
      end
    end

    assert(ref_W)
    local ref_walk_z = assert(Trans.brush_get_b(ref_W))

    -- SUCCESS --
    local info = { fab=fab, add_z=F.z - ref_walk_z }

    return info
  end


  local function height_check_floor_fab(F, fab, add_z)
    assert(fab.bbox.z1)
    assert(fab.bbox.z2)

    local z1 = add_z + math.min(0,  fab.bbox.z1)
    local z2 = add_z + math.max(32, fab.bbox.z2)

gui.debugf("height_check_floor_fab: F (%s %s)  z_range: (%d %d)\n",
        tostring(F.z_low), tostring(F.z_high), z1, z2)

    if F.z_low  and z1 < (F.z_low+12)  then return false end
    if F.z_high and z2 > (F.z_high-96) then return false end

    return true
  end


  local function determine_1D_locs(low, high, size, scale_mode)
    -- make a set of good positions to try across a certain axis (X or Y)

    local list = {}

    local extra  = high - low - size
    if extra < 0 then extra = 0 end

    local s_half = int(size  / 2)
    local mx     = int((low + high) / 2)

    if scale_mode then
      if extra > size / 2.1 then
        table.insert(list, { low=low, high=high })
      end
      -- TODO: more scaling positions (touch low, mid, touch high)
    end

    if scale_mode == "whole" then return end

    table.insert(list, { low=mx-s_half, high=mx-s_half+size })

    if extra > math.min(size / 1.7, 100) then
---   table.insert(list, { low=low, high=low+size })
---   table.insert(list, { low=high-size, high=high })
    end

    -- TODO: more unscaled positions (2/5, 4/5)

    return list
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

    local xlocs = determine_1D_locs(zone.x1, zone.x2, x_size, raw_fab.scale_mode)
    local ylocs = determine_1D_locs(zone.y1, zone.y2, y_size, raw_fab.scale_mode)

    for _,XL in ipairs(xlocs) do
      for _,YL in ipairs(ylocs) do
        table.insert(locs, Trans.box_transform(XL.low, YL.low, XL.high, YL.high, nil, dir))
      end
    end

    -- FIXME!!!  score them or give probabilities and pick
    rand.shuffle(locs)

    -- check each location...

    for _,T in ipairs(locs) do
---gui.debugf("|  trying loc:\n%s\n", table.tostr(T, 1))
      -- create prefab to perform full check
      local fab = Fab_create(skin._prefab)

      table.insert(R.prefabs, fab)

      Fab_apply_skins(fab, { R.skin or {}, skin })

      Fab_transform_XY(fab, T)

      local info = full_test_floor_fab(F, fab)

      if info then
        Fab_transform_Z(info.fab, { add_z = info.add_z })

        if height_check_floor_fab(F, fab, info.add_z) then
          -- success!
          return info
        end
      end
    end

    return nil  -- fail
  end


  local function find_usable_floor_fab(F)
gui.debugf("find_usable_floor in %s recursion:%d\n", R:tostr(), F.recursion)
gui.debugf("zones = \n%s\n", table.tostr(F.zones, 2))

do return nil end

    if F.recursion >= 2 then return nil end

    local poss = possible_floor_prefabs()

    local ROTS = { 0, 90, 180, 270 }

    rand.shuffle(F.zones)

    for loop = 1,20 do
      if table.empty(poss) then break; end

      local skinname = rand.key_by_probs(poss)
      poss[skinname] = nil

      local skin = assert(GAME.SKINS[skinname])

      rand.shuffle(ROTS)

      for _,rotate in ipairs(ROTS) do
        for _,zone in ipairs(F.zones) do
          local info = test_floor_fab(F, skin, zone, rotate)

          -- found a usable prefab?
          if info then
gui.printf("|  USING_FLOOR_FAB ::::::: %s\n", skinname)
            return info
          end
        end
      end
    end

    return nil  -- failed
  end


  local function copy_floor_brush(brush)
    -- create a very minimal copy of the brush : 2D coords only
    local newb = {}

    for _,C in ipairs(brush) do
      if C.x then
        table.insert(newb, { x=C.x, y=C.y })
      end
    end

    return newb
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

    local B = copy_floor_brush(B)

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
        if not FB[1].infinite then
          -- normal sized brushes can simply be inserted as-is
          table.insert(list, copy_floor_brush(FB))
        else
          -- perform intersection with previous floor
          for _,B in ipairs(brushes) do
            do_intersection(list, info, FB, B)
          end
        end
      end
    end

    return list
  end


  local function air_touches_space(new_brushes, B)
    local x1,y1, x2,y2 = Trans.brush_bbox(B)

    -- add some leeway (to handle case of merely touching)
    x1 = x1 - 4 ; x2 = x2 + 4
    y1 = y1 - 4 ; y2 = y2 + 4

    for _,N in ipairs(new_brushes) do
      local x3,y3, x4,y4 = Trans.brush_bbox(N)

      -- TODO: proper intersection test
      if geom.boxes_overlap(x1,y1,x2,y2, x3,y3,x4,y4) then
        return true
      end
    end

    return false
  end


  local function transfer_spaces(walks, info, space, new_brushes)
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

        if air_touches_space(new_brushes, B) then
          table.insert(list, B)
        end
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
      recursion = F.recursion + 1,
      space = space,

      z_low  = F.z_low,
      z_high = F.z_high,
    }

    floor.brushes  = intersect_brushes(F.brushes, info, space)

    floor.walks    = transfer_spaces(F.walks,    info, space)
    floor.nosplits = transfer_spaces(F.nosplits, info, space)
    floor.airs     = transfer_spaces(F.airs,     info, space, floor.brushes)

    floor.zones    = transfer_zones(F.zones, info, space)

    -- add the walks/airs/nosplits from prefab
    for _,B in ipairs(info.fab.brushes) do
      if B[1].space == space then
        if B[1].m == "walk"    then table.insert(floor.walks, B) end
        if B[1].m == "air"     then table.insert(floor.airs,  B) end
        if B[1].m == "nosplit" then table.insert(floor.nosplits, B) end

        if B[1].m == "walk" then
          -- this brush will serve as new floor's entry
          -- Note: overridden later for the floor near entrance door
          assert(not floor.entry)
          floor.entry = B

          floor.z = assert(Trans.brush_get_b(B))

---???    -- support for 3D floors
---???    if B[1].dz_low  then floor.z_low  = floor.z + B[1].dz_low  end
---???    if B[1].dz_high then floor.z_high = floor.z + B[1].dz_high end
        end
      end
    end 

    return floor
  end


  local function space_has_entry(F, entry)
    for _,W in ipairs(F.walks) do
      if W == entry then return true end
    end

    return false
  end


  local function subdivide(F, info)
    local entry_floor

    for space = 1,info.fab.num_spaces do
      local F2 = create_new_floor(F, info, space)

      -- add new floor to room list
      table.insert(R.all_floors, F2)

      if space_has_entry(F2, F.entry) then
        entry_floor = F2
      end
    end

    if not entry_floor then error("missing entry floor?") end

    -- keep the same entry brush
    entry_floor.entry = F.entry

    return entry_floor
  end


  local function floor_can_be_subdivided(F)
    assert(F.entry)

  end


  function try_subdivide_a_floor()
    local has_unfinished

    for index,F in ipairs(R.all_floors) do
      if not F.rendered then
        -- floor can be subdivided when we know it's entry height
        if F.z then
          local info = find_usable_floor_fab(F)
           
          if info then
            -- bump and build the chosen floor fab
            -- (do it now to set the heights on walk brushes)

            Fab_bound_Z(info.fab, F.z_low, F.z_high)

            -- FIXME: clip infinite brushes to F.brushes
            Fab_render(info.fab)

            -- the subdivision will create new floor objects, so remove
            -- this one from the list.
            table.remove(R.all_floors, index)

            -- create the new floors
            F = subdivide(F, info)

            -- the floor on the entry side can now be rendered...
          end

          render_floor(F)
          return true
        end

        has_unfinished = true
      end
    end

    -- sanity check
    if has_unfinished then
      error("Floor subdivision failure : some floors not rendered")
    end

    -- all floors have been rendered
    return false
  end


  local function prepare_ceiling()
    local h = ROOM.floor_max_h + 192 -- rand.pick { 192, 256, 320, 384 }

    if R.outdoor then
      R.sky_h = h + 128
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

gui.debugf("entry_walk = %s\n%s\n", tostring(R.entry_walk), table.tostr(R.entry_walk, 2))

  R.floor_min_h = R.entry_floor_h
  R.floor_max_h = R.entry_floor_h

  initial_floors()

  -- this will render floors as it goes
--!!!!!!  while try_subdivide_a_floor() do end
for _,F in ipairs(R.all_floors) do render_floor(F) end

  Chunky_floor(R)

  prepare_ceiling()
end



function Layout_spots_in_room(R)

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
      if F ~= floor then
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



function Layout_flesh_out_floors(R)
  -- use the safe zones to place scenery in unused areas

  local function fill_zone_with_ents(F, zone, decor_item, info)
    local w = zone.x2 - zone.x1
    local h = zone.y2 - zone.y1

    w = int(w / info.r / 2)
    h = int(h / info.r / 2)

    if w <= 0 or h <= 0 then return end

    local count = (w + h) / rand.pick { 2.5, 3.7, 5 }
    count = int(count + gui.random())

    for i = 1,count do
      local x = rand.range(zone.x1 + info.r, zone.x2 - info.r)
      local y = rand.range(zone.y1 + info.r, zone.y2 - info.r)
      local z = F.z

      local DECOR =
      {
        x = x, y = y, z = z, info = info
      }

      table.insert(R.decor, DECOR)

      Trans.entity(decor_item, x, y, z) 
    end
  end


  local function fill_zone_with_fabs(F, zone, skin)
    local fab_name = assert(skin._prefab)
    local info = assert(PREFAB[fab_name])

    local fab_r = assert(skin._radius)

    local w = zone.x2 - zone.x1 - 64
    local h = zone.y2 - zone.y1 - 64

    w = int(w / fab_r / 2)
    h = int(h / fab_r / 2)

    if w <= 0 or h <= 0 then return end

    -- the pattern is a list of direction numbers
    local pattern

    if w >= 5 and h >= 5 and rand.odds(10) then
      pattern = {1,2,3, 4,5,6, 7,8,9}

    elseif w >= 4 and h >= 2 and rand.odds(20) then
      pattern = {1,2,3, 7,8,9}

    elseif h >= 4 and w >= 2 and rand.odds(20) then
      pattern = {1,4,7, 3,6,9}

    elseif w >= 2 and h >= 2 then
      if math.max(w, h) >= 4 and rand.odds(60) then
        pattern = rand.sel(50, {1,5,9}, {3,5,7})
      elseif rand.odds(40) then
        pattern = {1,3,7,9}
      else
        pattern = rand.sel(50, {1,9}, {3,7})
      end

    elseif w >= 3 and rand.odds(50) then
      pattern = {4,5,6}

    elseif h >= 3 and rand.odds(50) then
      pattern = {2,5,8}

    elseif w >= 2 and rand.odds(80) then
      pattern = {4,6}

    elseif h >= 2 and rand.odds(80) then
      pattern = {2,8}
  
    else
      pattern = {5}
    end

    local XS = { zone.x1 + fab_r, (zone.x1 + zone.x2) / 2, zone.x2 - fab_r }
    local YS = { zone.y1 + fab_r, (zone.y1 + zone.y2) / 2, zone.y2 - fab_r }

    local skins = { skin }

    for dir in ipairs(pattern) do
      local dx, dy = geom.delta(dir)

      local x = XS[2 + dx]
      local y = YS[2 + dx]
      local z = F.z

      local T = Trans.spot_transform(x, y, z, 0)

      local fab = Fabricate(fab_name, T, skins)

      fab.room = R
      table.insert(R.prefabs, fab)
    end
  end


  local function add_entities(tab, prob)
    if not tab then return end

    local decor_item = rand.key_by_probs(tab)

    local info = assert(GAME.ENTITIES[decor_item])

    for _,F in ipairs(R.all_floors) do
      for _,Z in ipairs(F.zones) do
        if rand.odds(prob) then
          fill_zone_with_ents(F, Z, decor_item, info)
        end
      end
    end
  end


  local function add_prefabs(tab, prob)
    if not tab then return end

    local skin_name = rand.key_by_probs(tab)
    local skin = assert(GAME.SKINS[skin_name])

    for _,F in ipairs(R.all_floors) do
      for _,Z in ipairs(F.zones) do
        if rand.odds(prob) then
          fill_zone_with_fabs(F, Z, skin)
        end
      end
    end
  end


  ---| Layout_flesh_out_floors |---

  if R.outdoor then
    add_entities(THEME.outdoor_decor, 99)
  elseif THEME.indoor_decor and rand.odds(50) then
    add_entities(THEME.indoor_decor, 99)
  else
    add_prefabs(THEME.indoor_fabs, 99)
  end
end



function Layout_all_floors()
  for _,R in ipairs(LEVEL.all_rooms) do
    Layout_the_floor(R)
    Layout_build_walls(R)
    Layout_flesh_out_floors(R)
  end
end


----------------------------------------------------------------


function Layout_all_ceilings()

  local function is_middle(K)
    if K:same_room(2) and K:same_room(8) then return true end
    if K:same_room(4) and K:same_room(6) then return true end
    return false
  end

  local function quake_temp_lights(R)
    for _,K in ipairs(R.sections) do
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
      for _,K in ipairs(R.sections) do
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

