---------------------------------------------------------------
--  PLANNING : Single Player
----------------------------------------------------------------
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
----------------------------------------------------------------

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
    LEVEL.sky_shade = 160
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

  gui.printf("Map Size: %dx%d sections\n", LEVEL.W, LEVEL.H)
end


function Plan_create_sections()
  
  local function show_sizes(name, t, N)
    name = name .. ": "
    for i = 1,N do
      name = name .. tostring(t[i]) .. " "
    end
    gui.debugf("%s\n", name)
  end

  local function get_column_sizes(W, limit)
    local cols = {}

    assert(4 + W*2 <= limit)

    for loop = 1,100 do
      local total = 4  -- border seeds around level

      for x = 1,W do
        cols[x] = 2 + rand.index_by_probs(ROOM_SIZE_TABLE)
        total = total + cols[x]
      end

      if total <= limit then
        return cols  -- OK!
      end
    end

    -- emergency fallback
    gui.printf("Using emergency column sizes.\n")

    for x = 1,W do cols[x] = 2 end

    return cols
  end


  ---| Plan_create_sections |---

  -- initial sizes of rooms in each row and column
  local cols = {}
  local rows = {}

  local limit = (PARAM.seed_limit or 56)

  -- take border seeds (2+2) and free space (3) into account
  limit = limit - 7

  cols = get_column_sizes(LEVEL.W, limit)
  rows = get_column_sizes(LEVEL.H, limit)

  LEVEL.col_W = cols
  LEVEL.row_H = rows

  show_sizes("col_W", cols, LEVEL.W)
  show_sizes("row_H", rows, LEVEL.H)


  local col_x = { 3 }  -- two border seeds at [1] and [2]
  local col_y = { 3 }  --

  for x = 2, LEVEL.W do col_x[x] = col_x[x-1] + LEVEL.col_W[x-1] end
  for y = 2, LEVEL.H do col_y[y] = col_y[y-1] + LEVEL.row_H[y-1] end

  LEVEL.col_x = col_x
  LEVEL.col_y = col_y


  -- create sections

  LEVEL.sections = table.array_2D(LEVEL.W, LEVEL.H)

  for x = 1, LEVEL.W do
  for y = 1, LEVEL.H do
    local SECTION =
    {
      kx = x
      ky = y

      -- FIXME: seed positions
    }

    LEVEL.sections[x][y] = SECTION
  end
  end
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


function Plan_add_normal_rooms()
  local sections = LEVEL.sections

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
    local raw = rand.key_by_probs(BIG_ROOM_TABLE)

    local big_w = int(raw / 10)
    local big_h =    (raw % 10)

    if rand.odds(50) then
      big_w, big_h = big_h, big_w
    end

    -- make sure it fits
    if bx+big_w-1 > LEVEL.W then big_w = LEVEL.W - bx + 1 end
    if by+big_h-1 > LEVEL.H then big_h = LEVEL.H - by + 1 end

    assert(big_w > 0 and big_h > 0)

    -- prefer to put big rooms away from the edge
    if (bx == 1 or bx+big_w-1 == LEVEL.W or
        by == 1 or by+big_h-1 == LEVEL.H)
        and rand.odds(50)
    then
      big_w, big_h = 1, 1
    end

    -- prevent excessively large rooms 
    while calc_width(bx, big_w) > 11 do
      big_w = big_w - 1
    end

    while calc_height(by, big_h) > 11 do
      big_h = big_h - 1
    end

    -- never use the whole map
    if big_w >= LEVEL.W and big_h >= LEVEL.H then
      big_w = big_w - 1
      big_h = big_h - 1
    end

    assert(big_w > 0 and big_h > 0)

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

    -- determine coverage on seed map
    R.sw = calc_width (bx, big_w)
    R.sh = calc_height(by, big_h)

    R.sx1 = LEVEL.col_x[bx]
    R.sy1 = LEVEL.col_y[by]

    R.sx2 = R.sx1 + R.sw - 1
    R.sy2 = R.sy1 + R.sh - 1

    for x = bx,bx+big_w-1 do
    for y = by,by+big_h-1 do
      sections[x][y].room = R
    end
    end

    gui.debugf("%s\n", R:tostr())
  end


  ---| Plan_add_normal_rooms |---

  local visits = {}

  for x = 1,LEVEL.W do
  for y = 1,LEVEL.H do
    table.insert(visits, { x=x, y=y })
  end
  end

  rand.shuffle(visits)

  each vis in visits do
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
      local K = Section_get_room(x, y)

      if not K:usable_for_room() then return false end
    end
    end

    return true
  end


  local function find_free_spot(side)
    local dx, dy = geom.delta(side)

    local mx1, mx2 = 1, MAP_W
    local my1, my2 = 1, MAP_H

        if dx < 0 then mx2 = 1
    elseif dx > 0 then mx1 = MAP_W
    end

        if dy < 0 then my2 = 1
    elseif dy > 0 then my1 = MAP_H
    end

    if side == 5 then
      mx1 = 2
      my1 = 2
      mx2 = MAP_W - 2
      my2 = MAP_H - 2
    end

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
    local R = ROOM_CLASS.new("odd")

    R.kind = "cave"

    for mx = spot.mx1, spot.mx2 do
    for my = spot.my1, spot.my2 do
      local K = Section_get_room(mx, my)

      K:set_room(R)
    end
    end

    -- this cost ensures large areas _tend_ to be at end of list,
    -- but are not forced to be (can be visited earlier).
    R.cave_cost = math.max(spot.mw, spot.mh) + gui.random() * 1.7

    return R
  end


  local function grow_room(R)
    -- too big already?
    if #R.sections >= MAP_W * (MAP_H - 1) then
      return false
    end

    local locs = {}

    for mx = 1, MAP_W do
    for my = 1, MAP_H do
      local K = Section_get_room(mx, my)

      if K.room != R then continue end

      for dir = 2,8,2 do
        local nx, ny = geom.nudge(mx, my, dir)
        N = Section_get_room(nx, ny)

        if N and N:usable_for_room() then
          table.insert(locs, { K=K, N=N })
        end
      end

    end -- mx, my
    end


    if table.empty(locs) then return false end

    local loc = rand.pick(locs)
    local N   = loc.N

    N:set_room(R)

    R.cave_cost = R.cave_cost + rand.range(0.5, 1.0)

    return true
  end

  
  ---| Plan_add_caves |---

  -- compute the quota
  local perc = style_sel("caves", 0, 15, 35, 65, 100)

  if perc == 0 or not THEME.caves then
    gui.printf("Caves: NONE\n")
    return
  end


  local num_free = Plan_count_free_room_sections()

  local quota = num_free * perc / 100

  gui.printf("Cave Quota: %d sections\n", quota)


  handle_surrounder()


  --- add starting spots ---

  -- best starting spots are in a corner.
  -- for middle of map, require a 2x2 sections
  local locations = { [1]=50, [3]=50, [7]=50, [9]=50,
                      [2]=20, [4]=20, [6]=20, [8]=20,
                      [5]=90
                    }

  local areas = { }

  -- this rough_size logic ensures that on bigger maps we tend to
  -- create larger caves (rather than lots of smaller caves).
  local rough_size = rand.irange(2, 5)
  if (MAP_W + MAP_H) > 6  then rough_size = rough_size + 1 end
  if (MAP_W + MAP_H) > 10 then rough_size = rough_size + 1 end

  local min_rooms = 1
  local max_rooms = 7

  if STYLE.caves != "few" and
     ((MAP_W + MAP_H) > 5 or rand.odds(perc))
  then
     min_rooms = 2
  end

  while #areas < max_rooms and
       (#areas < min_rooms or quota / #areas > rough_size + 0.4)
  do
    -- pick a location
    local side = rand.key_by_probs(locations)

    -- don't use this location again (except for middle)
    if side != 5 then
      locations[side] = nil
    end

    local spot = find_free_spot(side)

    if spot then
      table.insert(areas, new_room(spot))
      quota = quota - spot.mw * spot.mh
    end
  end


  --- grow these rooms ---

  for loop = 1,50 do
    if quota < 1 then break; end

    -- want to visit smallest ones first
    table.sort(areas, function(A, B) return A.cave_cost < B.cave_cost end)

    each R in areas do
      if quota < 1 then break; end

      if grow_room(R) then
        quota = quota - 1
      end
    end
  end

  Plan_dump_sections("Sections with caves:")
end


------------------------------------------------------------------------


function Plan_nudge_rooms()
  --
  -- This resizes rooms by moving certain borders either one seed
  -- outward or one seed inward.  There are various constraints,
  -- in particular each room must remain a rectangle shape (so we
  -- disallow nudges that would create an L shaped room).
  --
  -- Big rooms must be handled first, because small rooms are
  -- never able to nudge a big border.

  local function volume_after_nudge(R, side, grow)
    if (side == 6 or side == 4) then
      return (R.sw + grow) * R.sh
    else
      return R.sw * (R.sh + grow)
    end
  end

  local function depth_after_nudge(R, side, grow)
    return sel(side == 6 or side == 4, R.sw, R.sh) + grow
  end

  local function allow_nudge(R, side, grow, N, list)

    -- above or below a sidewards nudge?
    if (side == 6 or side == 4) then
      if N.sy1 > R.sy2 then return true end
      if R.sy1 > N.sy2 then return true end
    else
      if N.sx1 > R.sx2 then return true end
      if R.sx1 > N.sx2 then return true end
    end

    -- opposite side?
    if side == 6 and (N.sx2 < R.sx2) then return true end
    if side == 4 and (N.sx1 > R.sx1) then return true end
    if side == 8 and (N.sy2 < R.sy2) then return true end
    if side == 2 and (N.sy1 > R.sy1) then return true end

    if (side == 6 or side == 4) then
      if (N.sy1 < R.sy1) or (N.sy2 > R.sy2) then return false end
    else
      if (N.sx1 < R.sx1) or (N.sx2 > R.sx2) then return false end
    end

    -- the nudge is possible (pushing the neighbor also)

    if N.no_nudge or N.nudges[10-side] then return false end

---##   if volume_after_nudge(N, 10-side, -grow) < 3 then return false end

    if depth_after_nudge(N, 10-side, -grow) < 2 then return false end

--???    if side == 6 then assert(N.sx1 == R.sx2+1) end
--???    if side == 4 then assert(N.sx2 == R.sx1-1) end
--???    if side == 8 then assert(N.sy1 == R.sy2+1) end
--???    if side == 2 then assert(N.sy2 == R.sy1-1) end

    table.insert(list, { room=N, side=10-side, grow=-grow })

    return true
  end

  local function try_nudge_room(R, side, grow)
    -- 'grow' is positive to nudge outward, negative to nudge inward

    -- Note: any shrinkage must pull neighbors too

    if not grow then
      grow = rand.sel(75,1,-1)
    end

gui.debugf("Trying to nudge room %dx%d, side:%d grow:%d\n", R.sw, R.sh, side, grow)

    if R.no_nudge then return false end

--[[
    if R.no_grow   and grow > 0 then return false end
    if R.no_shrink and grow < 0 then return false end
--]]

    -- already moved this border?
    if R.nudges[side] then return false end

    -- would get too small?  or too big?
    local new_d = depth_after_nudge(R, side, grow)

    if new_d < 2 or new_d > 13 then return false end

    -- side sits on border of the map?
--[[
    if (side == 2 and R.ly1 == 1) or
       (side == 4 and R.lx1 == 1) or
       (side == 6 and R.lx2 == LAND_W) or
       (side == 8 and R.ly2 == LAND_H)
    then
      return false
    end
--]]

    local push_list = {}

    each K in R.neighbors do
      if not allow_nudge(R, side, grow, K, push_list) then return false end
    end

    -- Nudge is OK!
    gui.printf("Nudging %s side:%d grow:%d\n", R:tostr(), side, grow)

    table.insert(push_list, { room=R, side=side, grow=grow })

    each push in push_list do
      local R = push.room

          if push.side == 2 then R.sy1 = R.sy1 - push.grow
      elseif push.side == 8 then R.sy2 = R.sy2 + push.grow
      elseif push.side == 4 then R.sx1 = R.sx1 - push.grow
      elseif push.side == 6 then R.sx2 = R.sx2 + push.grow
      end

      -- fix up seed size
      R.sw, R.sh = geom.group_size(R.sx1, R.sy1, R.sx2, R.sy2)

      assert(not R.nudges[push.side])
      R.nudges[push.side] = true
    end

    return true
  end

  local function nudge_big_rooms()
    local rooms = {}

    each R in LEVEL.rooms do
      if R.big_w > 1 or R.big_h > 1 then
        R.big_volume = R.big_w * R.big_h
        table.insert(rooms, R)
      end
    end

    if #rooms == 0 then return end

    table.sort(rooms, function(A, B) return A.big_volume > B.big_volume end)

    local sides = { 2,4,6,8 }

    each R in rooms do
      rand.shuffle(sides)
      each side in sides do
        local depth = sel(side==4 or side==6, R.sw, R.sh)
        if (depth % 2) == 0 then
          if not (rand.odds(30) and try_nudge_room(R, side, 1)) then
            try_nudge_room(R, side, -1)
          end
        end
      end
      R.no_nudge = true
    end
  end

  local function get_NE_corner_rooms(R)

    local E, N, NE -- East, North, NorthEast

    each K in R.neighbors do

      if K.sx2 == R.sx2 and K.sy1 > R.sy2 then N = K end
      if K.sy2 == R.sy2 and K.sx1 > R.sx2 then E = K end

      if K.sx1 > R.sx2 and K.sy1 > R.sy2 then NE = K end
    end

    return E, N, NE
  end

  local function nudge_the_rest()
    local rooms = {}
    each R in LEVEL.rooms do
      if R.big_w == 1 and R.big_h == 1 then
        table.insert(rooms, R)
      end
    end

    local sides = { 2,4,6,8 }

    for pass = 1,2 do
      rand.shuffle(rooms)
      each R in rooms do
        rand.shuffle(sides)
        each side in sides do
          if rand.odds(30) then
            try_nudge_room(R, side)
          end
        end
      end -- R in rooms
    end -- pass
  end


  ---| Plan_nudge_rooms |---

  each R in LEVEL.rooms do
    R.nudges = {}
  end

  nudge_big_rooms()
  nudge_the_rest()
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
    local ROOM = ROOM_CLASS.new()

    ROOM.big_w = 1
    ROOM.big_h = 1

    table.set_class(ROOM, ROOM_CLASS)

    ROOM.parent = parent
    ROOM.neighbors = { }  -- ???

    ROOM.sx1 = info.x
    ROOM.sy1 = info.y

    ROOM.sx2 = info.x + info.w - 1
    ROOM.sy2 = info.y + info.h - 1

    ROOM.sw, ROOM.sh = geom.group_size(ROOM.sx1, ROOM.sy1, ROOM.sx2, ROOM.sy2)
    ROOM.svolume = ROOM.sw * ROOM.sh

    ROOM.is_island = (ROOM.sx1 > parent.sx1) and (ROOM.sx2 < parent.sx2) and
                     (ROOM.sy1 > parent.sy1) and (ROOM.sy2 < parent.sy2)

    if not parent.children then parent.children = {} end
    table.insert(parent.children, ROOM)

    parent.svolume = parent.svolume - ROOM.svolume

    -- update seed map
    for sx = ROOM.sx1,ROOM.sx2 do
      for sy = ROOM.sy1,ROOM.sy2 do
        SEEDS[sx][sy].room = ROOM
      end
    end
  end


  ---| Plan_sub_rooms |---

  if STYLE.subrooms == "none" then return end

  local chance_tab = sel(STYLE.subrooms == "heaps", SUB_HEAPS, SUB_CHANCES)

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
    each R in LEVEL.rooms do
      for sx = R.sx1, R.sx2 do
      for sy = R.sy1, R.sy2 do
        assert(Seed_valid(sx, sy))
        local S = SEEDS[sx][sy]
        assert(not S.room) -- no overlaps please!
        S.room = R
        S.kind = "walk"
      end -- sx, sy
      end
    end

    each R in LEVEL.scenic_rooms do
      for sx = R.sx1,R.sx2 do
      for sy = R.sy1,R.sy2 do
        local S = SEEDS[sx][sy]

        if not S.room then -- overlap is OK for scenics
          assert(LEVEL.liquid)
          S.room = R
          S.kind = "liquid"
---###    S.f_tex = "LAVA1"  -- TEMP CRUD !!!!
        end
      end -- sx, sy
      end
    end
  end

  local function fill_holes()
    local sc_list = table.copy(LEVEL.scenic_rooms)
    rand.shuffle(sc_list)

    each R in sc_list do
      local nx1, ny1 = R.sx1, R.sy1
      local nx2, ny2 = R.sx2, R.sy2

      for x = R.sx1-1, R.sx2+1 do
      for y = R.sy1-1, R.sy2+1 do
        if Seed_valid(x, y) and not R:contains_seed(x, y) then
          local S = SEEDS[x][y]
          if not S.room then
            S.room = R
            if x < R.sx1 then nx1 = x end
            if y < R.sy1 then ny1 = y end
            if x > R.sx2 then nx2 = x end
            if y > R.sy2 then ny2 = y end
          end
        end
      end -- x, y
      end

      R.sx1, R.sy1 = nx1, ny1
      R.sx2, R.sy2 = nx2, ny2

      R.sw, R.sh = geom.group_size(R.sx1, R.sy1, R.sx2, R.sy2)
    end
  end


  ---| Plan_make_seeds |---

  local max_sx = 1
  local max_sy = 1

  each R in LEVEL.rooms do
gui.debugf("seed range @ %s\n", R:tostr())
    max_sx = math.max(max_sx, R.sx2)
    max_sy = math.max(max_sy, R.sy2)

    R.svolume = R.sw * R.sh
  end

  -- two border seeds at top and right
  -- (the left and bottom were handled in Plan_initial_rooms)
  max_sx = max_sx + 2
  max_sy = max_sy + 2

  Seed_init(max_sx-1, max_sy-1, 1, 3, 3)

  plant_rooms()
  fill_holes()

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

--!! Plan_add_caves()
  Plan_add_normal_rooms()

  Plan_find_neighbors()
  Plan_dump_rooms()

  Plan_nudge_rooms()

  -- must create the seeds _AFTER_ nudging
  Plan_make_seeds()

-- !! FIXME: do before nudge rooms, BUT need 'svolume'
  Plan_decide_outdoors()

  gui.printf("Seed Map:\n")
  Seed_dump_rooms()

  Plan_sub_rooms()

  each R in LEVEL.rooms do
    gui.printf("Final %s   size: %dx%d\n", R:tostr(), R.sw,R.sh)
  end

  LEVEL.skyfence_h = rand.sel(50, 192, rand.sel(50, 64, 320))

end

