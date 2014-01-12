-------------------------------------------------------------------
--  PLANNING : Single Player
-------------------------------------------------------------------
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
-------------------------------------------------------------------

--[[ *** CLASS INFORMATION ***

class SECTION
{
  -- a section is a rectangular group of seeds.
  -- sections are used for planning where to place rooms.

  kx, ky  -- location in section map 

  sx1, sy1, sx2, sy2, sw, sh  -- location in seed map

  room   : ROOM
}

--------------------------------------------------------------]]


function Plan_alloc_id(kind)
  local result = (LEVEL.ids[kind] or 0) + 1
  LEVEL.ids[kind] = result
  return result
end


function Plan_dump_rooms()
  local function room_char(R)
    if not R then return '.' end
    if R.kind == "scenic" then return '=' end
    if R.kind == "cave" then return '/' end
    if not R.id then return '?' end
    local n = 1 + (R.id % 26)
    return string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZ", n, n)
  end

  --- dump_rooms ---

  local sections = LEVEL.sections

  gui.printf("\n")
  gui.printf("Room Map:\n")

  for y = LEVEL.H,1,-1 do
    local line = "  "
    for x = 1,LEVEL.W do
      line = line .. room_char(sections[x][y].room)
    end
    gui.printf("%s\n", line)
  end
  gui.printf("\n")
end



function Plan_choose_liquid()
  if THEME.liquids and STYLE.liquids != "none" then
    local name = rand.key_by_probs(THEME.liquids)
    local liquid = GAME.LIQUIDS[name]

    if not liquid then
      error("No such liquid: " .. name)
    end

    gui.printf("Liquid: %s\n\n", name)

    LEVEL.liquid = liquid

     -- setup the special '_LIQUID' material
    assert(liquid.mat)
    assert(GAME.MATERIALS[liquid.mat])

    GAME.MATERIALS["_LIQUID"] = GAME.MATERIALS[liquid.mat]

  else
    -- leave '_LIQUID' unset : it should not be used, but if does then
    -- the _ERROR texture will appear (like any other unknown material.

    gui.printf("Liquids disabled.\n\n")
  end
end


function Plan_choose_darkness()
  local prob = EPISODE.dark_prob or 0

  -- NOTE: this style is only set via the Level Control module
  if STYLE.darkness then
    prob = style_sel("darkness", 0, 10, 30, 90)
  end

  if rand.odds(prob) then
    gui.printf("Darkness falls across the land...\n\n")

    LEVEL.is_dark = true
    LEVEL.sky_light = 0
    LEVEL.sky_shade = 0
  else
    LEVEL.sky_light = 192
    LEVEL.sky_shade = 144
  end
end


function Plan_determine_size()
  local W, H  -- width and height

  local ob_size = OB_CONFIG.size

  -- there is no real "progression" when making a single level.
  -- hence use mixed mode instead.
  if ob_size == "prog" and OB_CONFIG.length == "single" then
    ob_size = "mixed"
  end

  if ob_size == "mixed" then
    W = 2 + rand.index_by_probs { 1,4,7,4,2,1 }
    H = 2 + rand.index_by_probs { 4,7,4,2,1 }

    if W < H then W, H = H, W end

  elseif ob_size == "prog" then
    local n = 1 + LEVEL.ep_along * 8.9

    n = int(n)
    if n < 1 then n = 1 end
    if n > 9 then n = 9 end

    local WIDTHS  = { 3,3,4, 5,5,6, 6,7,7 }
    local HEIGHTS = { 2,3,3, 3,4,4, 5,5,6 }

    W = WIDTHS[n]
    H = HEIGHTS[n]

  else
    local WIDTHS  = { tiny=3, small=4, regular=6, large=7, extreme=9 }
    local HEIGHTS = { tiny=2, small=3, regular=4, large=6, extreme=8 }

    W =  WIDTHS[ob_size]
    H = HEIGHTS[ob_size]

    if not W then
      error("Unknown size keyword: " .. tostring(ob_size))
    end

    if rand.odds(30) and not LEVEL.secret_exit then
      W = W - 1
    end
  end

  LEVEL.W = W
  LEVEL.H = H
end


function Plan_create_sections()
  
  local function show_sizes(name, t, N)
    name = name .. ": "
    for i = 1,N do
      name = name .. tostring(t[i]) .. " "
    end
    gui.printf("%s\n", name)
  end


  local function pick_sizes(W, limit)
    local sizes = {}

    for loop = 1,100 do
      local total = 0

      for x = 1, W do
        sizes[x] = 2 + rand.index_by_probs(ROOM_SIZE_TABLE)
        total = total + sizes[x]
      end

      if total <= limit then
        return sizes  -- OK!
      end
    end

    -- the above failed, so adjust the last set of sizes it made

    gui.printf("Adjusting column/row sizes....\n")

    for loop = 1,200 do
      -- find a section size to shrink
      local x = rand.irange(1, W)

      local min_size = sel(loop < 100, 3, 2)

      while x <= W and sizes[x] <= min_size do
        x = x + 1
      end

      if x <= W then
        sizes[x] = sizes[x] - 1
        total    = total - 1

        if total <= limit then
          return sizes
        end
      end
    end

    -- extremely unlikely to get here
    error("failed to pick usable column/row sizes")
  end


  ---| Plan_create_sections |---

  -- initial sizes of rooms in each row and column
  local col_W = {}
  local row_H = {}

  local limit = (PARAM.seed_limit or 56)

  -- take border seeds into account
  limit = limit - EDGE_SEEDS * 2


  -- reduce level size if rooms would become too small
  local max_W = int(limit / 3.5)
  local max_H = int((limit - DEPOT_SEEDS) / 3.5)

  if LEVEL.W > max_W then LEVEL.W = max_W end
  if LEVEL.H > max_H then LEVEL.H = max_H end

  gui.printf("Map Size: %dx%d sections\n", LEVEL.W, LEVEL.H)


  col_W = pick_sizes(LEVEL.W, limit)
  row_H = pick_sizes(LEVEL.H, limit - DEPOT_SEEDS)

  show_sizes("col_W", col_W, LEVEL.W)
  show_sizes("row_H", row_H, LEVEL.H)

  LEVEL.col_W = col_W
  LEVEL.row_H = row_H


  local col_X = { EDGE_SEEDS+1 }
  local row_Y = { EDGE_SEEDS+1 }

  for x = 2, LEVEL.W + 1 do col_X[x] = col_X[x-1] + col_W[x-1] end
  for y = 2, LEVEL.H + 1 do row_Y[y] = row_Y[y-1] + row_H[y-1] end

  LEVEL.col_X = col_X
  LEVEL.row_Y = row_Y

  local total_W = col_X[LEVEL.W + 1] + EDGE_SEEDS - 1
  local total_H = row_Y[LEVEL.H + 1] + EDGE_SEEDS - 1


  -- create sections

  LEVEL.sections = table.array_2D(LEVEL.W, LEVEL.H)

  for x = 1, LEVEL.W do
  for y = 1, LEVEL.H do
    local SECTION =
    {
      kx = x
      ky = y

      sw = col_W[x]
      sh = row_H[y]

      sx1 = col_X[x]
      sy1 = row_Y[y]
      sx2 = col_X[x] + col_W[x] - 1
      sy2 = row_Y[y] + row_H[y] - 1
    }

    LEVEL.sections[x][y] = SECTION
  end
  end


  -- create seeds

  Seed_init(total_W, total_H, 0, DEPOT_SEEDS)
end


function Section_valid(kx, ky)
  if kx < 1 or kx > LEVEL.W then return false end
  if ky < 1 or ky > LEVEL.H then return false end

  return true
end


function Plan_find_neighbors()
  -- determines neighboring rooms of each room
  -- (including diagonals, which may touch after nudging)
  
  local sections = LEVEL.sections

  local function valid_R(x, y)
    return 1 <= x and x <= LEVEL.W and
           1 <= y and y <= LEVEL.H
  end

  local function add_neighbor(R, side, N)
    if not table.has_elem(R.neighbors, N) then
      table.insert(R.neighbors, N)
    end
  end

  for x = 1, LEVEL.W do
  for y = 1, LEVEL.H do
    local R = sections[x][y].room

    if not R then continue end

    if not R.neighbors then
      R.neighbors = {}
    end

    for side = 1,9 do if side != 5 then
      local nx, ny = geom.nudge(x, y, side)
      if valid_R(nx, ny) then
        local N = sections[nx][ny].room
        if N and N != R then
          add_neighbor(R, side, N)
        end
      else
        R.touches_edge = true
      end
    end -- for side
    end

  end -- for x, y
  end
end


function Plan_count_free_sections()
  local count = 0

  for mx = 1, LEVEL.W do
  for my = 1, LEVEL.H do
    local K = LEVEL.sections[mx][my]

    if not K.room then
      count = count + 1
    end
  end
  end

  return count
end


function Plan_random_section_list()
  local visits = {}

  for x = 1, LEVEL.W do
  for y = 1, LEVEL.H do
    table.insert(visits, { x=x, y=y })
  end
  end

  rand.shuffle(visits)

  return visits
end


function Plan_add_normal_rooms()
  local sections = LEVEL.sections

  local big_tab


  local function adjust_for_styles()
    big_tab = table.copy(BIG_ROOM_TABLE)

    if STYLE.big_rooms == "few" then
      big_tab[11] = big_tab[11] * 10
    elseif STYLE.big_rooms == "heaps" then
      big_tab[11] = big_tab[11] / 10
    end
  end


  local function calc_width(bx, big_w)
    local w = 0
    for x = bx,bx+big_w-1 do
      w = w + LEVEL.col_W[x]
    end
    return w
  end


  local function calc_height(by, big_h)
    local h = 0
    for y = by,by+big_h-1 do
      h = h + LEVEL.row_H[y]
    end
    return h
  end


  local function choose_big_size(bx, by)
    if STYLE.big_rooms == "none" then
      return 1, 1
    end

    local raw = rand.key_by_probs(big_tab)

    local big_w = int(raw / 10)
    local big_h =    (raw % 10)

    if rand.odds(50) then
      big_w, big_h = big_h, big_w
    end

    -- make sure it fits
    if bx + big_w - 1 > LEVEL.W then big_w = LEVEL.W - bx + 1 end
    if by + big_h - 1 > LEVEL.H then big_h = LEVEL.H - by + 1 end

    assert(big_w > 0 and big_h > 0)

    -- never use the whole map (horizontally)
    if big_w >= LEVEL.W then big_w = big_w - 1 end

    -- prevent excessively large rooms 
    local sw, sh
    local max_size = 11

    sw = calc_width (bx, big_w)
    sh = calc_height(by, big_h)

    while sw > max_size do
      big_w = big_w - 1 ;
      sw = calc_width(bx, big_w)
    end

    while sh > max_size do
      big_h = big_h - 1
      sh = calc_height(by, big_h)
    end

    assert(big_w > 0 and big_h > 0)

    -- prevent very tall / narrow rooms
    local max_aspect = 2.6

    if big_w > big_h and sw / sh > max_aspect then big_w = big_w - 1 end
    if big_h > big_w and sh / sw > max_aspect then big_h = big_h - 1 end

    -- any other rooms in the way?
    for x = bx,bx+big_w-1 do for y=by,by+big_h-1 do
      if sections[x][y].room then
        return 1, 1
      end
    end end

    return big_w, big_h
  end


  local function add_room(bx, by)
    local big_w, big_h = choose_big_size(bx, by)

    local R = ROOM_CLASS.new()

    R.big_w = big_w
    R.big_h = big_h

    for x = bx, bx+big_w-1 do
    for y = by, by+big_h-1 do
      assert(not sections[x][y].room)
      sections[x][y].room = R
    end
    end

    -- determine coverage on seed map
    local sw = calc_width (bx, big_w)
    local sh = calc_height(by, big_h)

    R.svolume = sw * sh

    gui.debugf("%s @ section[%d,%d]\n", R:tostr(), bx, by)
  end


  ---| Plan_add_normal_rooms |---

  adjust_for_styles()

  each vis in Plan_random_section_list() do
    local bx, by = vis.x, vis.y
    
    if not sections[bx][by].room then
      add_room(bx, by)
    end
  end
end


function Plan_add_caves()

  local function handle_surrounder()
    each R in LEVEL.rooms do
      if R.is_surrounder then
        if rand.odds(style_sel("caves", 0, 15, 35, 90)) then
          R.kind = "cave"
        end
      end
    end
  end


  local function spot_is_free(mx1, my1, mx2, my2)
    for x = mx1, mx2 do
    for y = my1, my2 do
      local K = LEVEL.sections[x][y]

      if K.room then return false end
    end
    end

    return true
  end


  local function find_free_spot(side)
    local dx, dy = geom.delta(side)

    local mx1, mx2 = 1, LEVEL.W
    local my1, my2 = 1, LEVEL.H

        if dx < 0 then mx2 = 1
    elseif dx > 0 then mx1 = LEVEL.W
    end

        if dy < 0 then my2 = 1
    elseif dy > 0 then my1 = LEVEL.H
    end

    if side == 5 then
      mx1 = 2
      my1 = 2
      mx2 = LEVEL.W - 2
      my2 = LEVEL.H - 2
    end

    -- wanted size : big for the middle of the map
    local mw = sel(side == 5, 2, 1)
    local mh = mw

    local spots = {}

    for mx = mx1, mx2 do
    for my = my1, my2 do
      if spot_is_free(mx, my, mx + mw - 1, my + mh - 1) then
        local SPOT =
        {
          mx1 = mx, mx2 = mx + mw - 1
          my1 = my, my2 = my + mh - 1
          mw  = mw, mh  = mh
        }
        table.insert(spots, SPOT)
      end
    end
    end

    if table.empty(spots) then
      return nil
    end

    return rand.pick(spots)
  end


  local function new_room(spot)
    local R = ROOM_CLASS.new()

    R.kind = "cave"
    R.svolume = 0

    for mx = spot.mx1, spot.mx2 do
    for my = spot.my1, spot.my2 do
      local K = LEVEL.sections[mx][my]

      K.room = R

      R.svolume = R.svolume + (K.sw * K.sh)
    end
    end

    -- this cost ensures large rooms _tend_ to be at end of list,
    -- but may be visited earlier.
    R.cave_cost = math.max(spot.mw, spot.mh) + gui.random() * 1.7

    return R
  end


  local function grow_room(R)
--????  -- too big already?
--????  if #R.svolume >= LEVEL.W * (LEVEL.H - 1) then
--????    return false
--????  end

    -- collect all possible grow spots
    local locs = {}

    for mx = 1, LEVEL.W do
    for my = 1, LEVEL.H do
      local K = LEVEL.sections[mx][my]

      if K.room != R then continue end

      for dir = 2,8,2 do
        local nx, ny = geom.nudge(mx, my, dir)

        if not Section_valid(nx, ny) then continue end

        local N = LEVEL.sections[nx][ny]

        if not N.room then
          table.insert(locs, N)
        end
      end

    end -- mx, my
    end


    if table.empty(locs) then
      -- nothing was possible
      return false
    end


    local N = rand.pick(locs)

    N.room = R

    R.svolume = R.svolume + (N.sw * N.sh)

    R.cave_cost = R.cave_cost + rand.range(0.5, 1.0)

    return true
  end


  ---| Plan_add_caves |---

  -- compute the quota
  local perc = style_sel("caves", 0, 15, 35, 65, 100)

  if perc == 0 or not THEME.caves or true then  --!!!! FIXME
    gui.printf("Caves: NONE\n")
    return
  end


  local num_free = Plan_count_free_sections()

  local quota = num_free * perc / 100

  gui.printf("Cave Quota: %d sections\n", quota)


  handle_surrounder()


  --- add starting spots ---

  -- best starting spots are in a corner.
  -- for middle of map, require a 2x2 sections
  local locations =
  {
    [1]=50, [3]=50, [7]=50, [9]=50
    [2]=20, [4]=20, [6]=20, [8]=20
    [5]=90
  }

  local rooms = { }

  -- this rough_size logic ensures that on bigger maps we tend to
  -- create larger caves (rather than lots of smaller caves).
  local rough_size = rand.irange(2, 5)
  local level_ext  = LEVEL.W + LEVEL.H

  if level_ext > 6  then rough_size = rough_size + 1 end
  if level_ext > 10 then rough_size = rough_size + 1 end

  local min_rooms = 1
  local max_rooms = 7

  if STYLE.caves != "few" and
     (level_ext > 5 or rand.odds(perc))
  then
     min_rooms = 2
  end


  while #rooms < max_rooms and
       (#rooms < min_rooms or quota / #rooms > rough_size + 0.4)
  do
    -- pick a location
    local side = rand.key_by_probs(locations)

    -- don't use this location again (except for middle)
    if side != 5 then
      locations[side] = nil
    end

    local spot = find_free_spot(side)

    if spot then
      table.insert(rooms, new_room(spot))
      quota = quota - spot.mw * spot.mh
    end
  end


  --- grow these rooms ---

  for loop = 1,50 do
    if quota < 1 then break; end

    -- want to visit smallest ones first
    table.sort(rooms, function(A, B) return A.cave_cost < B.cave_cost end)

    each R in rooms do
      if grow_room(R) then
        quota = quota - 1
      end

      if quota < 1 then break; end
    end
  end

---  Plan_dump_sections("Sections with caves:")
end


------------------------------------------------------------------------


function Plan_nudge_rooms()
  --
  -- This resizes rooms by moving certain borders either one seed
  -- outward or one seed inward.  There are various constraints,
  -- in particular each room must remain a rectangle shape (so we
  -- disallow nudges that would create an L shaped room).
  --

  function do_nudge_section(K, side, dist)
    if side == 2 then K.sy1 = K.sy1 - dist end
    if side == 8 then K.sy2 = K.sy2 + dist end
    if side == 4 then K.sx1 = K.sx1 - dist end
    if side == 6 then K.sx2 = K.sx2 + dist end

    K.sw, K.sh = geom.group_size(K.sx1, K.sy1, K.sx2, K.sy2)
  end


  function try_nudge_border(kx, ky, side)
    local K = LEVEL.sections[kx][ky]

    local R = K.room
    if not R then return end

    -- not edge of map?
    local nx, ny = geom.nudge(kx, ky, side)

    if Section_valid(nx, ny) then return end

    -- outdoor rooms need their border [except caves]
    if R.is_outdoor and K.room.kind != "cave" then
      return
    end

    -- leave big rectangular rooms alone
    if R.kind != "cave" then
      if geom.is_vert (side) and (R.big_w or 0) > 1 then return end
      if geom.is_horiz(side) and (R.big_h or 0) > 1 then return end
    end

    -- sometimes just leave it
    if rand.odds(10) then return end

    -- OK, nudge it
    local dist = rand.irange(1, EDGE_SEEDS - 1)

    do_nudge_section(K, side, dist)
  end


  function nudge_borders(side)
    each pos in Plan_random_section_list() do
      try_nudge_border(pos.x, pos.y, side)
    end
  end


  function try_nudge_room(kx, ky, side)
    local K = LEVEL.sections[kx][ky]

    local R = K.room
    if not R then return end

    -- is neighbor valid?
    local nx, ny = geom.nudge(kx, ky, side)

    if not Section_valid(nx, ny) then return end

    local K2 = LEVEL.sections[nx][ny]
    local R2 = K2.room

    if not R2 or R2 == R then return end

    -- check for big rooms : never nudge a "wide" edge
    if R.kind != "cave" then
      if geom.is_vert (side) and (R.big_w or 0) > 1 then return end
      if geom.is_horiz(side) and (R.big_h or 0) > 1 then return end
    end

    if R2.kind != "cave" then
      if geom.is_vert (side) and (R2.big_w or 0) > 1 then return end
      if geom.is_horiz(side) and (R2.big_h or 0) > 1 then return end
    end

    -- require sections to be flush (except at edge of map)
    if geom.is_vert(side) then
      if kx > 1       and K.sx1 != K2.sx1 then return end
      if kx < LEVEL.W and K.sx2 != K2.sx2 then return end
    else
      if ky > 1       and K.sy1 != K2.sy1 then return end
      if ky < LEVEL.H and K.sy2 != K2.sy2 then return end
    end

    -- already nudged in opposite direction?
    if (K.nudges[side] or 1) < 0 then return end

    -- don't make this section too large
    if geom.vert_sel(side, K.sh, K.sw) >= 7 then return end

    -- don't make other section too small
    if geom.vert_sel(side, K2.sh, K2.sw) <= 3 then return end

    -- OK, nudge it
    local opp = 10 - side

    do_nudge_section(K,  side, 1)
    do_nudge_section(K2, opp, -1)

    K .nudges[side] =  1
    K2.nudges[opp]  = -1
  end


  function nudge_rooms(pass)
    each pos in Plan_random_section_list() do
      local side
      if pass == 1 then
        side = rand.sel(50, 2, 8)
      else
        side = rand.sel(50, 4, 6)
      end

      try_nudge_room(pos.x, pos.y, side)
    end
  end


  ---| Plan_nudge_rooms |---

  for x = 1, LEVEL.W do
  for y = 1, LEVEL.H do
    LEVEL.sections[x][y].nudges = {}
  end
  end

  for dir = 2,8,2 do
    nudge_borders(dir)
  end

  -- move vertically in first pass, horizontally in second
  for pass = 1,2 do
  for loop = 1,6 do
    nudge_rooms(pass)
  end
  end
end


function Plan_sub_rooms()

  --                    1  2  3   4   5   6   7   8+
  local SUB_CHANCES = { 0, 0, 1,  3,  6, 10, 20, 30 }
  local SUB_HEAPS   = { 0, 0, 6, 20, 40, 60, 75, 90 }

  local function can_fit(R, x, y, w, h)
    if w >= R.sw or h >= R.sh then return nil end

    if x+w > R.sx2 or y+h > R.sy2 then return nil end

    local touches_wall = false
    if x == R.sx1 or x+w == R.sx2 or y == R.sy1 or y+h == R.sy2 then
      touches_wall = true
    end
    
    for sx = x,x+w-1 do for sy = y,y+h-1 do
      local S = SEEDS[sx][sy]
      if S.room != R then return nil end
    end end -- sx, sy

    local touches_other = nil

    for sx = x-1,x+w do for sy = y-1,y+h do
      if Seed_valid(sx, sy) then
        local S = SEEDS[sx][sy]
        if S.room and S.room.parent == R then

          -- don't allow new sub-room to touch more than one
          -- existing sub-room, since it is possible to split
          -- the room into separate parts that way.
          if touches_other and touches_other != S.room then
            return nil
          end

          touches_other = S.room
        end
      end
    end end -- sx, sy

    -- if it touches the outside wall, make sure it does NOT touch
    -- another sub-room (otherwise the room could be split into
    -- two separated parts, which is bad).
    -- TODO: smarter test
    if touches_wall and touches_other then
      return nil
    end

    if STYLE.islands == "heaps" then
      if touches_wall  then return 10 end
      if touches_other then return 40 end
      return 200
    end

    -- probability based on volume ratio
    local vr = w * h * 3 / R.svolume
    if vr < 1 then vr = 1 / vr end

    return 200 / (vr * vr)
  end


  local function try_add_sub_room(parent)
    local infos = {}
    local probs = {}
    for x = parent.sx1,parent.sx2 do for y = parent.sy1,parent.sy2 do
      for w = 2,6 do
        local prob = can_fit(parent, x, y, w, w)
        if prob then
          local INFO = { x=x, y=y, w=w, h=w, islandy=islandy }

          -- make rectangles sometimes
          if INFO.w >= 3 and rand.odds(30) then
            INFO.w = INFO.w - 1
            if rand.odds(50) then INFO.x = INFO.x + 1 end
          elseif INFO.h >= 3 and rand.odds(30) then
            INFO.h = INFO.h - 1
            if rand.odds(50) then INFO.y = INFO.y + 1 end
          end

          table.insert(infos, INFO)
          table.insert(probs, prob)
        end
      end
    end end -- x, y

    if #infos == 0 then return end

    local info = infos[rand.index_by_probs(probs)]


    -- actually add it !
    local R = ROOM_CLASS.new()

    R.parent = parent
    R.neighbors = { }  -- ???

    R.sx1 = info.x
    R.sy1 = info.y
    R.sx2 = info.x + info.w - 1
    R.sy2 = info.y + info.h - 1

    R.sw  = info.w
    R.sh  = info.h

    R.svolume = R.sw * R.sh

    R.is_island = (R.sx1 > parent.sx1) and (R.sx2 < parent.sx2) and
                     (R.sy1 > parent.sy1) and (R.sy2 < parent.sy2)

    if not parent.children then parent.children = {} end
    table.insert(parent.children, R)

    parent.svolume = parent.svolume - R.svolume

    -- update seed map
    for sx = R.sx1, R.sx2 do
    for sy = R.sy1, R.sy2 do
      SEEDS[sx][sy].room = R
    end
    end
  end


  ---| Plan_sub_rooms |---

  if STYLE.sub_rooms == "none" then return end

  local chance_tab = sel(STYLE.sub_rooms == "heaps", SUB_HEAPS, SUB_CHANCES)

  each R in LEVEL.rooms do
    if not R.parent and R.kind != "cave" then
      local min_d = math.max(R.sw, R.sh)
      if min_d > 8 then min_d = 8 end

      if rand.odds(chance_tab[min_d]) then
        try_add_sub_room(R)

        if min_d >= 5 and rand.odds(10) then try_add_sub_room(R) end
        if min_d >= 6 and rand.odds(65) then try_add_sub_room(R) end
        if min_d >= 7 and rand.odds(25) then try_add_sub_room(R) end
        if min_d >= 8 and rand.odds(90) then try_add_sub_room(R) end
      end
    end
  end
end


function Plan_make_seeds()

  local function plant_rooms()
    for kx = 1, LEVEL.W do
    for ky = 1, LEVEL.H do

      local K = LEVEL.sections[kx][ky]
      local R = K.room

      if not R then continue end

      R.sx1 = math.min(K.sx1, R.sx1 or  9999)
      R.sy1 = math.min(K.sy1, R.sy1 or  9999)
      R.sx2 = math.max(K.sx2, R.sx2 or -9999)
      R.sy2 = math.max(K.sy2, R.sy2 or -9999)

      R.svolume = R.svolume + (K.sw * K.sh)

      for sx = K.sx1, K.sx2 do
      for sy = K.sy1, K.sy2 do
        assert(Seed_valid(sx, sy))
        local S = SEEDS[sx][sy]

        assert(not S.room) -- no overlaps please!

        S.room = R
        S.kind = "walk"
      end -- sx, sy
      end

    end -- kx, ky
    end
  end


  ---| Plan_make_seeds |---

  -- recompute seed volume
  each R in LEVEL.rooms do
    R.svolume = 0
  end

  plant_rooms()

  each R in LEVEL.rooms do
    R.sw = R.sx2 - R.sx1 + 1
    R.sh = R.sy2 - R.sy1 + 1
  end

  Seed_flood_fill_edges()
end


function Plan_decide_outdoors()

  local function turn_into_outdoor(R)
    if R.kind != "cave" then
       R.kind = "outdoor"
    end

    R.is_outdoor = true

    R.sky_h = SKY_H  -- FIXME: use sky groups
  end


  local function score_room(R)
    -- handle the surrounder room
    if R.is_surrounder and rand.odds(style_sel("outdoors", 0, 15, 35, 80)) then
      turn_into_outdoor(R)
      return -1  -- ignore it now
    end

    -- too small ?
    if R.svolume < 4 then return -1 end

    -- never for secret exit
    if R.purpose == "SECRET_EXIT" then return -1 end

    local score = R.svolume

    local what = 0

    -- preference for the sides of map, even higher for the corners
--!!!! FIXME    if R.kx1 <= 3 or R.kx2 >= SECTION_W-2 then what = what + 1 end
--!!!! FIXME    if R.ky1 <= 3 or R.ky2 >= SECTION_H-2 then what = what + 1 end
    if R.touches_edge then what = 1 end

    score = score + 10 * what

    score = score + 20 * gui.random() ^ 2

    return score
  end

  
  local function pick_room(list, quota)
    -- remove rooms which don't meet the quota
    for index = #list, 1, -1 do
      local R = list[index]

      if R.svolume > quota then
        table.remove(list, index)
      end
    end

    if table.empty(list) then return nil end

    -- don't always pick the largest room
    if #list >= 2 and rand.odds(40) then
      return table.remove(list, 2)
    end

    return table.remove(list, 1)
  end


  ---| Plan_decide_outdoors |---

  -- collect rooms which can be made outdoor
  local room_list = {}
  local total_seeds = 0

  each R in LEVEL.rooms do
    R.outdoor_score = score_room(R)

    if R.outdoor_score > 0 then
      table.insert(room_list, R)
      total_seeds = total_seeds + R.svolume
    end
  end

  if table.empty(room_list) or not THEME.outdoors then
    gui.printf("Outdoor Quota: NONE\n")
    return
  end


  -- compute the quota
  local perc = style_sel("outdoors", 0, 15, 40, 75, 100)

  local quota = total_seeds * perc / 100

  gui.printf("Outdoor Quota: %d%% (%d seeds)\n", perc, quota)


  -- sort rooms by score (highest first)
  table.sort(room_list,
    function(A, B) return A.outdoor_score > B.outdoor_score end)


  while quota > 0 do
    local R = pick_room(room_list, quota)

    -- nothing possible?
    if not R then break end

    turn_into_outdoor(R)

    quota = quota - R.svolume
  end
end


function Plan_create_rooms()

  gui.printf("\n--==| Planning Rooms |==--\n\n")

  assert(LEVEL.ep_along)

  LEVEL.rooms = {}
  LEVEL.conns = {}

  LEVEL.scenic_rooms = {}
  LEVEL.scenic_conns = {}

  LEVEL.free_tag  = 1
  LEVEL.free_mark = 1
  LEVEL.ids = {}

  gui.random()

  Plan_choose_liquid()
  Plan_choose_darkness()

  Plan_determine_size()
  Plan_create_sections()

  Plan_add_caves()
  Plan_add_normal_rooms()

  Plan_find_neighbors()
  Plan_dump_rooms()

  Plan_decide_outdoors()

  Plan_nudge_rooms()

  -- must create the seeds _AFTER_ nudging
  Plan_make_seeds()

  gui.printf("Seed Map:\n")
  Seed_dump_rooms()

  Plan_sub_rooms()

  each R in LEVEL.rooms do
    gui.printf("Final %s   size: %dx%d\n", R:tostr(), R.sw,R.sh)
  end

  LEVEL.skyfence_h = rand.sel(50, 192, rand.sel(50, 64, 320))

end

