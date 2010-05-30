---------------------------------------------------------------
--  PLANNING (NEW!) : Single Player
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


function Plan_alloc_tag()
  LEVEL.last_tag = (LEVEL.last_tag or 0) + 1
  return LEVEL.last_tag
end

function Plan_alloc_mark()
  LEVEL.last_mark = (LEVEL.last_mark or 0) + 1
  return LEVEL.last_mark
end

function Plan_alloc_room_id()
  LEVEL.last_room = (LEVEL.last_room or 0) + 1
  return LEVEL.last_room
end


function Plan_decide_map_size()

  local function get_size_list(W, limit)
    local SIZE_TABLE = THEME.room_size_table or
                        GAME.room_size_table or
                        ROOM_SIZE_TABLE
    local sizes = {}

    assert(4 + W*2 <= limit)

    for loop = 1,99 do
      local total = 4  -- border seeds around level

      for x = 1,W do
        sizes[x] = rand.index_by_probs(SIZE_TABLE)
        total = total + sizes[x]
      end

      if total <= limit then
        return sizes  -- OK!
      end
    end

    -- emergency fallback
    gui.printf("Using emergency column sizes.\n")

    for x = 1,W do
      sizes[x] = 2
    end

    return sizes
  end

  local function get_position_list(size_list)
    local pos = {}

    pos[1] = 3  -- two border seeds at [1] and [2]

    for x = 2,#size_list do
      pos[x] = pos[x-1] + size_list[x-1]
    end

    return pos
  end

  local function dump_sizes(line, t, N)
    for i = 1,N do
      line = line .. tostring(t[i]) .. " "
    end
    gui.printf("%s\n", line)
  end


  ---| Plan_decide_map_size |---

  local W, H  -- number of rooms

  local ob_size = OB_CONFIG.size

  -- there is no real "progression" when making a single level
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

    local WIDTHS  = { 3,4,4, 5,5,6, 6,7,7 }
    local HEIGHTS = { 3,3,4, 4,5,5, 6,6,7 }

    W = WIDTHS[n]
    H = HEIGHTS[n]

  else
    local WIDTHS  = { small=4, regular=6, large=8 }
    local HEIGHTS = { small=3, regular=4, large=6 }

    W = WIDTHS[ob_size]
    H = HEIGHTS[ob_size]

    if not W then
      error("Unknown size keyword: " .. tostring(ob_size))
    end

    if rand.odds(30) then W = W - 1 end
  end

  LEVEL.W = W
  LEVEL.H = H

  gui.printf("Map Size: %dx%d sections\n", W, H)


  -- initial section sizes in each row and column
  local limit = (PARAM.seed_limit or 56)

  -- take border seeds (2+2) and free space (3) into account
  limit = limit - (2+2+3)

  LEVEL.section_W = get_size_list(W, limit)
  LEVEL.section_H = get_size_list(H, limit)
 
  LEVEL.section_X = get_position_list(LEVEL.section_W)
  LEVEL.section_Y = get_position_list(LEVEL.section_H)

  dump_sizes("Column widths: ", LEVEL.section_W, LEVEL.W)
  dump_sizes("Row heights:   ", LEVEL.section_H, LEVEL.H)

  LEVEL.seed_W = LEVEL.section_X[LEVEL.W] + LEVEL.section_W[LEVEL.W] - 1
  LEVEL.seed_H = LEVEL.section_Y[LEVEL.H] + LEVEL.section_H[LEVEL.H] - 1

  -- two border seeds at top and right
  LEVEL.seed_W = LEVEL.seed_W + 2
  LEVEL.seed_H = LEVEL.seed_H + 2
end


function Plan_create_sections()
  LEVEL.section_map = table.array_2D(LEVEL.W, LEVEL.H)

  for x = 1,LEVEL.W do for y = 1,LEVEL.H do
    LEVEL.section_map[x][y] = {}
  end end
end


function Plan_is_section_valid(x, y)
  return 1 <= x and x <= LEVEL.W and
         1 <= y and y <= LEVEL.H
end


function Plan_has_section(x, y)
  if LEVEL.section_map[x][y].room then
    return true
  else
    return false
  end
end


function Plan_dump_sections()

  local function section_char(x, y)
    local SEC = LEVEL.section_map[x][y]
    local R = SEC.room
    if not R then return '.' end
    if R.kind == "scenic" then return '=' end
    local n = 1 + ((R.id-1) % 26)
    if R.natural then
      return string.sub("abcdefghijklmnopqrstuvwxyz", n, n)
    else
      return string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZ", n, n)
    end
  end

  gui.printf("\n")
  gui.printf("Section Map:\n")

  for y = LEVEL.H,1,-1 do
    local line = "@c  "
    for x = 1,LEVEL.W do
      line = line .. section_char(x, y)
    end
    gui.printf("%s\n", line)
  end
  gui.printf("\n")
end


function Plan_new_room()
  local ROOM =
  {
    kind = "normal",
    shape = "rect",
    conns = {},
    neighbors = {},
---???    sections = {},
  }

  table.set_class(ROOM, ROOM_CLASS)

  ROOM.id = Plan_alloc_room_id()

  table.insert(LEVEL.all_rooms, ROOM)

  return ROOM
end


function Plan_add_small_rooms()
  for x = 1,LEVEL.W do for y = 1,LEVEL.H do
    local SEC = LEVEL.section_map[x][y]
    if not SEC.room then
      local R = Plan_new_room()

      R.lx1 = x ; R.lx2 = x
      R.ly1 = y ; R.ly2 = y

      SEC.room = R

      -- sometimes become a 2x1 / 1x2 sized room

      local can_x = (x < LEVEL.W and not Plan_has_section(x+1, y))
      local can_y = (y < LEVEL.H and not Plan_has_section(x, y+1))

      if (can_x or can_y) and rand.odds(50) then
        
        if can_x and (not can_y or rand.odds(60)) then
          SEC = LEVEL.section_map[x+1][y]
        else
          SEC = LEVEL.section_map[x][y+1]
        end

        assert(not SEC.room)

        SEC.room = R
      end
    end
  end end
end


function Plan_add_big_rooms()

  -- shapes are defined by a list of neighbors to set.

  local BIG_ROOM_SHAPES =
  {
    plus = { name="plus", dirs={ 5,2,4,6,8 }},

    T1 = { name="T", dirs={ 5,7,8,9 }},
    T2 = { name="T", dirs={ 5,7,8,9,2 }},

    L1 = { name="L", dirs={ 5,8,6 }},
    L2 = { name="L", dirs={ 5,8,2,3 }},
    L3 = { name="L", dirs={ 4,7,1,2,3 }},
  }

  local BIG_SHAPE_PROBS =
  {
    rect = 40,
    plus = 20,

    T1 = 20, T2 = 3,
    L1 = 40, L2 = 10, L3 = 2,
  }

  local BIG_RECT_PROBS =
  {
    [22] = 80, [33] = 30, [32] = 15, [31] = 3,
  }

  local function test_or_set_rect(lx, ly, rot, w, h, ROOM)
    if w >= LEVEL.W or h >= LEVEL.H then
      return false  -- would span the whole map
    end

    if bit.btest(rot, 2) then lx = lx - w + 1 end
    if bit.btest(rot, 4) then ly = ly - h + 1 end

    local lx2 = lx + w - 1
    local ly2 = ly + h - 1

    if lx < 1 or lx2 > LEVEL.W or
       ly < 1 or ly2 > LEVEL.H
    then
      return false
    end

    for x = lx,lx2 do for y = ly,ly2 do
      if ROOM then
        LEVEL.section_map[x][y].room = ROOM
      elseif Plan_has_section(x, y) then
        return false -- would overlap a room
      end
    end end

    return true
  end

  local function test_or_set_shape(lx, ly, rot, dir_list, ROOM)
    local touch_bottom, touch_top
    local touch_left, touch_right

    for _,orig_dir in ipairs(dir_list) do
      local dir  = geom.ROTATE[rot][orig_dir]
      local x, y = geom.nudge(lx, ly, dir)

      if not Plan_is_section_valid(x, y) then
        return false
      end

      if x == 1 then touch_left = true end
      if y == 1 then touch_bottom = true end

      if x == LEVEL.W then touch_right = true end
      if y == LEVEL.H then touch_top = true end

      if ROOM then
        LEVEL.section_map[x][y].room = ROOM
      elseif Plan_has_section(x, y) then
        return false -- would overlap a room
      end
    end -- orig_dir

    -- would span the whole map?
    if (touch_left and touch_right) or (touch_bottom and touch_top) then
      return false
    end

    return true
  end

  local function pick_rect_size()
    local raw = rand.key_by_probs(BIG_RECT_PROBS)

    local rw = int(raw / 10)
    local rh =    (raw % 10)

    -- bit less that 50%, since maps are usually wider than tall
    if rand.odds(40) then
      rw, rh = rh, rw
    end

    return rw, rh
  end


  ---| Plan_add_big_rooms |---

  local num_loop = int(LEVEL.W * LEVEL.H / 2) ---  + LEVEL.num_naturals * 10

  for loop = 1,num_loop do
    local lx  = rand.irange(1, LEVEL.W)
    local ly  = rand.irange(1, LEVEL.H)
    local rot = rand.irange(0, 3) * 2

    local ROOM

    local shape_name = rand.key_by_probs(BIG_SHAPE_PROBS)

    if shape_name == "rect" then
      local rw, rh = pick_rect_size()

      if test_or_set_rect(lx, ly, rot, rw, rh) then
        ROOM = Plan_new_room()
        ROOM.shape = "rect"
        test_or_set_rect(lx, ly, rot, rw, rh, ROOM)
      end

    else  -- shaped

      local shape = BIG_ROOM_SHAPES[shape_name]
      assert(shape)

      if test_or_set_shape(lx, ly, rot, shape.dirs) then
        ROOM = Plan_new_room()
        ROOM.shape = shape.name
        test_or_set_shape(lx, ly, rot, shape.dirs, ROOM)
      end
    end

    if ROOM then
---      gui.debugf("Loop: %d  shape:%s  ROOM:%s\n", loop, shape_name, tostring(ROOM))
---      Plan_dump_sections()
    end
  end

  Plan_dump_sections()
end


function Plan_add_natural_rooms()

    local perc = style_sel("naturals", 0, 18, 46, 92)
    local count = int(room_num * perc / 100)
    if count > room_num-2 then
       count = room_num-2
    end

  local function find_free_spot(x, y)
    if not Plan_has_section(x, y) then
      return x, y
    end

    -- try a neighbor : diagonals after straights

    for pass = 1,2 do
      local SIDES

      if pass == 1 then
        SIDES = { 2,4,6,8 }
      else
        SIDES = { 1,3,7,9 }
      end

      for _,side in ipairs(SIDES) do
        local nx, ny = geom.nudge(x, y, side)
        if Plan_is_section_valid(nx, ny) and not Plan_has_section(nx, ny) then
          return nx, ny
        end
      end
    end

    return nil -- not found
  end

  local function grow_natural(side, growth)
    local x, y = geom.delta(side)

    -- convert side value to a section coordinate
    x = 1 + int((LEVEL.W - 0.7) * (x+1) / 2)
    y = 1 + int((LEVEL.H - 0.7) * (y+1) / 2)

    if LEVEL.W > 5 then x = x + rand.pick { -1, 0, 1 } end
    if LEVEL.H > 5 then y = y + rand.pick { -1, 0, 1 } end

    x = math.clamp(1, x, LEVEL.W)
    y = math.clamp(1, y, LEVEL.H)

    -- find a usable spot
    local cx, cy = find_free_spot(x, y)

    if not cx then
      gui.printf("Failed to grow natural area @ (%d,%d)\n", x, y)
      return
    end
    
    -- randomise the growth value
    growth = int(growth * rand.range(0.8, 1.5))
    if growth < 2 then growth = 2 end

    -- create room
    local ROOM = Plan_new_room()
    ROOM.natural = true
    ROOM.shape = "odd"

    -- keep track of each natural section
    local sections = {}

    LEVEL.section_map[cx][cy].room = ROOM

    local sections = { { cx=cx, cy=cy } }

    growth = growth - 1

    for loop = 1,200 do
      if growth < 1 then break; end

      local start = rand.pick(sections)
      local dir   = rand.dir()

      local nx, ny = geom.nudge(start.cx, start.cy, dir)

      if Plan_is_section_valid(nx, ny) and not Plan_has_section(nx, ny) then
        
        LEVEL.section_map[nx][ny].room = ROOM

        table.insert(sections, { cx=nx, cy=ny })

        growth = growth - 1
      end
    end

    Plan_dump_sections()
  end


  ---| Plan_add_natural_rooms |---

  if not THEME.cave_walls then return end

  local count = style_sel("naturals", 0, 1.3, 2.4, 4.4)

  if count == 0 then return end

  count = int(count * rand.range(1, 1.7))

  local growth = LEVEL.H - gui.random()

  LEVEL.num_naturals = count

  gui.printf("Natural Areas: %s --> %d of %1.1f sections\n", STYLE.naturals,
             count, growth)


  local SIDES = { 2,4,6,8, 1,3,7,9 }

  -- middle area is not best place for caves
  if rand.odds(15) then
    table.insert(SIDES, 5)
  end

  rand.shuffle(SIDES)

  for i = 1,count do
    grow_natural(SIDES[i], growth)
  end
end


function Plan_add_special_rooms()
  -- nothing here YET...
end


function Plan_decide_outdoors()

  local function choose(R)
---???    if R.parent and R.parent.outdoor then return false end
---???    if R.parent then return rand.odds(5) end

    if R.natural then
      if not THEME.landscape_walls then return false end
    else
      if not THEME.courtyard_floors then return false end
    end

    if STYLE.skies == "none"   then return false end
    if STYLE.skies == "always" then return true end

    if R.natural then
      if STYLE.skies == "heaps" then return rand.odds(75) end
      return rand.odds(25)
    end

--[[
    if R.children then
      if STYLE.skies == "few" then
        return rand.odds(33)
      else
        return rand.odds(80)
      end
    end
--]]
    if STYLE.skies == "heaps" then return rand.odds(50) end
    if STYLE.skies == "few"   then return rand.odds(5) end

    -- room on edge of map?
    if R.touches_edge then
      return rand.odds(30)
    end

    return rand.odds(10)
  end

  ---| Plan_decide_outdoors |---

  for _,R in ipairs(LEVEL.all_rooms) do
    if R.outdoor == nil then
      R.outdoor = choose(R)
    end
    if R.outdoor then
      R.sky_h = SKY_H
    end
  end
end


function Plan_find_neighbors()

  -- determines neighboring rooms of each room
  -- (including diagonals, which may touch after nudging)

  local function add_neighbor(R, side, N)
    -- check if already there
    for _,O in ipairs(R.neighbors) do
      if O == N then return end
    end

    table.insert(R.neighbors, N)
  end

  for x = 1,LEVEL.W do for y = 1,LEVEL.H do

    local R = LEVEL.section_map[x][y].room

    if not R.neighbors then
      table.insert(LEVEL.all_rooms, R)
      R.neighbors = {}
    end

    for side = 1,9 do if side ~= 5 then
      local nx, ny = geom.nudge(x, y, side)
      if valid_R(nx, ny) then
        local N = room_map[nx][ny]
        if N ~= R then
          add_neighbor(R, side, N)
        end
      else
        R.touches_edge = true
      end
    end end -- side

  end end -- x, y
end


function Plan_merge_naturals()  -- REMOVE
 
  local function merge_one_natural(src, dest)
    gui.printf("Merging Natural: %s --> %s\n", src:tostr(), dest:tostr())

    dest.sx1 = math.min(src.sx1, dest.sx1)
    dest.sy1 = math.min(src.sy1, dest.sy1)

    dest.sx2 = math.max(src.sx2, dest.sx2)
    dest.sy2 = math.max(src.sy2, dest.sy2)

    dest.sw = dest.sx2 - dest.sx1 + 1
    dest.sh = dest.sy2 - dest.sy1 + 1
    dest.svolume = dest.sw * dest.sh  -- not accurate

    -- NB: connections are not established yet

    for x = src.sx1,src.sx2 do for y = src.sy1,src.sy2 do
      local S = SEEDS[x][y][1]
      if S.room == src then
         S.room = dest
      end
    end end -- for x, y
  end

  ---| Plan_merge_naturals |---

  local room_list = LEVEL.all_rooms
  LEVEL.all_rooms = {}

  for _,R in ipairs(room_list) do
    if R.nature_parent then
      -- this room is NOT added back into all_rooms list
      merge_one_natural(R, R.nature_parent)
    else
      table.insert(LEVEL.all_rooms, R)
    end
  end
end


function Plan_weird_experiment()  -- REMOVE

  local function try_move(S, dir)
    local N = S:neighbor(dir)

    if not (N and N.room) then return end

    if N.room == S.room then return end

    local A = N:neighbor(geom.RIGHT[dir])
    local B = N:neighbor(geom. LEFT[dir])
    local X = N:neighbor(dir)

    if X and X.room == N.room then

      if A and A.room == N.room then
        X = A:neighbor(dir)
        if not (X and X.room == N.room) then
          return -- fail
        end
      end

      if B and B.room == N.room then
        X = B:neighbor(dir)
        if not (X and X.room == N.room) then
          return -- fail
        end
      end

    else

      if A and A.room == N.room and B and B.room == N.room then
        return -- fail
      end
    end

    -- do it !

    N.room.shape = "odd"
    S.room.shape = "odd"

    local R = S.room

    N.room = R

    R.sx1 = math.min(R.sx1, N.sx)
    R.sy1 = math.min(R.sy1, N.sy)

    R.sx2 = math.max(R.sx2, N.sx)
    R.sy2 = math.max(R.sy2, N.sy)

    R.sw, R.sh = geom.group_size(R.sx1, R.sy1, R.sx2, R.sy2)
  end

  for loop = 1,9000 do
    local sx = rand.irange(1, SEED_W)
    local sy = rand.irange(1, SEED_H)

    local S = SEEDS[sx][sy][1]

    if S and S.room then
      try_move(S, rand.dir())
    end
  end
end


------------------------------------------------------------------------


function Plan_nudge_rooms()
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

    for _,K in ipairs(R.neighbors) do
      if not allow_nudge(R, side, grow, K, push_list) then return false end
    end

    -- Nudge is OK!
    gui.printf("Nudging %s side:%d grow:%d\n", R:tostr(), side, grow)

    table.insert(push_list, { room=R, side=side, grow=grow })

    for _,push in ipairs(push_list) do
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

    for _,R in ipairs(LEVEL.all_rooms) do
      if R.big_w > 1 or R.big_h > 1 then
        R.big_volume = R.big_w * R.big_h
        table.insert(rooms, R)
      end
    end

    if #rooms == 0 then return end

    table.sort(rooms, function(A, B) return A.big_volume > B.big_volume end)

    local sides = { 2,4,6,8 }

    for _,R in ipairs(rooms) do
      rand.shuffle(sides)
      for _,side in ipairs(sides) do
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

    for _,K in ipairs(R.neighbors) do

      if K.sx2 == R.sx2 and K.sy1 > R.sy2 then N = K end
      if K.sy2 == R.sy2 and K.sx1 > R.sx2 then E = K end

      if K.sx1 > R.sx2 and K.sy1 > R.sy2 then NE = K end
    end

    return E, N, NE
  end

  local function nudge_the_rest()
    local rooms = {}
    for _,R in ipairs(LEVEL.all_rooms) do
      if R.big_w == 1 and R.big_h == 1 then
        table.insert(rooms, R)
      end
    end

    local sides = { 2,4,6,8 }

    for pass = 1,2 do
      rand.shuffle(rooms)
      for _,R in ipairs(rooms) do
        rand.shuffle(sides)
        for _,side in ipairs(sides) do
          if rand.odds(30) then
            try_nudge_room(R, side)
          end
        end
      end -- R in all_rooms
    end -- pass
  end


  ---| Plan_nudge_rooms |---

  for _,R in ipairs(LEVEL.all_rooms) do
    R.nudges = {}

    if R.shape ~= "rect" then
      R.no_nudge = true
    end
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
      local S = SEEDS[sx][sy][1]
      if S.room ~= R then return nil end
    end end -- sx, sy

    local touches_other = nil

    for sx = x-1,x+w do for sy = y-1,y+h do
      if Seed.valid(sx, sy, 1) then
        local S = SEEDS[sx][sy][1]
        if S.room and S.room.parent == R then

          -- don't allow new sub-room to touch more than one
          -- existing sub-room, since it is possible to split
          -- the room into separate parts that way.
          if touches_other and touches_other ~= S.room then
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
    local ROOM =
    {
      id=id, kind="normal", conns={},
      big_w=1, big_h=1,
    }

    local id = Plan_alloc_room()

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

    table.insert(LEVEL.all_rooms, ROOM)

    if not parent.children then parent.children = {} end
    table.insert(parent.children, ROOM)

    parent.svolume = parent.svolume - ROOM.svolume

    -- update seed map
    for sx = ROOM.sx1,ROOM.sx2 do
      for sy = ROOM.sy1,ROOM.sy2 do
        SEEDS[sx][sy][1].room = ROOM
      end
    end
  end


  ---| Plan_sub_rooms |---

  if STYLE.subrooms == "none" then return end

  local chance_tab = sel(STYLE.subrooms == "heaps", SUB_HEAPS, SUB_CHANCES)

  for _,R in ipairs(LEVEL.all_rooms) do
    if not R.parent and not R.natural then
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


function OLD_Plan_make_seeds()

  local function plant_rooms()
    for _,R in ipairs(LEVEL.all_rooms) do
      for sx = R.sx1,R.sx2 do for sy = R.sy1,R.sy2 do
        assert(Seed.valid(sx, sy, 1))
        local S = SEEDS[sx][sy][1]
        assert(not S.room) -- no overlaps please!
        S.room = R
        S.kind = "walk"
      end end -- for sx,sy
    end -- for R

    for _,R in ipairs(LEVEL.scenic_rooms) do
      for sx = R.sx1,R.sx2 do for sy = R.sy1,R.sy2 do
        local S = SEEDS[sx][sy][1]
        if not S.room then -- overlap is OK for scenics
          assert(LEVEL.liquid)
          S.room = R
          S.kind = "liquid"
---###    S.f_tex = "LAVA1"  -- TEMP CRUD !!!!
        end
      end end -- for sx,sy
    end -- for R
  end

  local function fill_holes()
    local sc_list = table.copy(LEVEL.scenic_rooms)
    rand.shuffle(sc_list)

    for _,R in ipairs(sc_list) do
      local nx1,ny1 = R.sx1,R.sy1
      local nx2,ny2 = R.sx2,R.sy2

      for x = R.sx1-1, R.sx2+1 do for y = R.sy1-1, R.sy2+1 do
        if Seed.valid(x, y, 1) and not R:contains_seed(x, y) then
          local S = SEEDS[x][y][1]
          if not S.room then
            S.room = R
            if x < R.sx1 then nx1 = x end
            if y < R.sy1 then ny1 = y end
            if x > R.sx2 then nx2 = x end
            if y > R.sy2 then ny2 = y end
          end
        end
      end end -- for x,y

      R.sx1, R.sy1 = nx1, ny1
      R.sx2, R.sy2 = nx2, ny2

      R.sw, R.sh = geom.group_size(R.sx1, R.sy1, R.sx2, R.sy2)
    end -- for R
  end


  ---| Plan_make_seeds |---

  local max_sx = 1
  local max_sy = 1

  for _,R in ipairs(LEVEL.all_rooms) do
gui.debugf("seed range @ %s\n", R:tostr())
    max_sx = math.max(max_sx, R.sx2)
    max_sy = math.max(max_sy, R.sy2)

    R.svolume = R.sw * R.sh
  end

  -- two border seeds at top and right
  -- (the left and bottom were handled in Plan_initial_rooms)
  max_sx = max_sx + 2
  max_sy = max_sy + 2

  Seed.init(max_sx-1, max_sy-1, 1, 3, 3)

  plant_rooms()
  fill_holes()

  Seed.flood_fill_edges()
end


function Plan_make_seeds()
  
  local function init_seed(sx, sy, R)
    assert(Seed.valid(sx, sy, 1))

    local S = SEEDS[sx][sy][1]
    if S.room then
      error("Planner: rooms overlap!")
    end

    S.room = R
    S.kind = "walk"
  end

  local function fill_section(lx, ly)
    local SEC = LEVEL.section_map[lx][ly]

    local R = SEC.room
    if not R then return end

    local sx1 = LEVEL.section_X[lx]
    local sy1 = LEVEL.section_Y[ly]

    local sx2 = sx1 + LEVEL.section_W[lx] - 1
    local sy2 = sy1 + LEVEL.section_H[ly] - 1

    if not R.sx1 or sx1 < R.sx1 then R.sx1 = sx1 end
    if not R.sy1 or sy1 < R.sy1 then R.sy1 = sy1 end
    if not R.sx2 or sx2 > R.sx2 then R.sx2 = sx2 end
    if not R.sy2 or sy2 > R.sy2 then R.sy2 = sy2 end

    R:update_size()

    for x = sx1,sx2 do for y = sy1,sy2 do
      init_seed(x, y, R) 
    end end
  end

  ---| Plan_make_seeds |---

  Seed.init(LEVEL.seed_W, LEVEL.seed_H, 1, 3, 3)

  for lx = 1,LEVEL.W do for ly = 1,LEVEL.H do
    fill_section(lx, ly)
  end end
end


function Plan_create_rooms()

  -- Overview of room planning:
  --
  --   1. decide map size
  --   2. do any special rooms or patterns
  --   3. add big rooms (rect / shaped / natural)
  --   4. add small rooms
  --
  --   5. decide indoor/outdoor
  --   6. place sub-rooms
  --   7. convert section map to seeds
  --   8. nudge sides

  gui.printf("\n--==| Planning Rooms |==--\n\n")

  assert(LEVEL.ep_along)

  LEVEL.all_rooms = {}
  LEVEL.all_conns = {}

  LEVEL.scenic_rooms = {}
  LEVEL.scenic_conns = {}

  gui.random() ; gui.random()

  if not LEVEL.liquid and THEME.liquids and STYLE.liquids ~= "none" then
    local name = rand.key_by_probs(THEME.liquids)
    gui.printf("Liquid: %s\n\n", name)
    LEVEL.liquid = assert(GAME.LIQUIDS[name])
  else
    gui.printf("Liquids disabled.\n\n")
  end

  Plan_decide_map_size()

  Plan_create_sections()

  Plan_add_special_rooms()

  -- big rooms and natural rooms tend to work against each other
  -- with the current algorithms.  The following is a workaround.
  -- FIXME: find a better, simpler way.
  if rand.odds(40) or STYLE.naturals == "heaps" then
    Plan_add_natural_rooms()
    Plan_add_big_rooms()
  else
    Plan_add_big_rooms()
    Plan_add_natural_rooms()
  end

  Plan_add_small_rooms()

  Plan_dump_sections()
--!!!!  Plan_find_neighbors()

  Plan_decide_outdoors()

--!!!!  Plan_sub_rooms()

  Plan_make_seeds()

  Seed.flood_fill_edges()

--!!!!  Plan_nudge_rooms()

-- Plan_weird_experiment()

  Seed.dump_rooms("Seed Map:")

  for _,R in ipairs(LEVEL.all_rooms) do
    gui.printf("Final size of %s = %dx%d\n", R:tostr(), R.sw,R.sh)
  end
end

