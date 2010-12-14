---------------------------------------------------------------
--  PLANNING : Single Player
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

class SECTION
{
  kx, ky  -- location in section map 

  room : ROOM

  x1, y1, x2, y2  -- map coordinates

  sx1, sy1, sx2, sy2, sw, sh  -- location in seed map

  num_conn  -- number of connections

  corners[DIR] : CORNER  -- each can be nil

  edges[DIR] : EDGE   -- each can be nil
}


----------------------------------------------------------------]]

require 'defs'
require 'util'


SEED_W = 0
SEED_H = 0

SEED_DX = 0
SEED_DY = 0

SECTION_W = 0
SECTION_H = 0


SECTION_CLASS = {}

function SECTION_CLASS.new(x, y)
  local K = { kx=x, ky=y, num_conn=0, corners={}, edges={} }
  table.set_class(K, SECTION_CLASS)
  return K
end

function SECTION_CLASS.tostr(self)
  return string.format("SECTION [%d,%d]", self.kx, self.ky)
end

function SECTION_CLASS.update_size(self)
  self.sw, self.sh = geom.group_size(self.sx1, self.sy1, self.sx2, self.sy2)
end

function SECTION_CLASS.neighbor(self, dir, dist)
  local nx, ny = geom.nudge(self.kx, self.ky, dir, dist)
  if nx < 1 or nx > SECTION_W or ny < 1 or ny > SECTION_H then
    return nil
  end
  return SECTIONS[nx][ny]
end

function SECTION_CLASS.same_room(self, dir)
  local N = self:neighbor(dir)
  return N and N.room == self.room
end

function SECTION_CLASS.same_neighbors(self)
  local count = 0
  for side = 2,8,2 do
    if self:same_room(side) then
      count = count + 1
    end
  end
  return count
end

function SECTION_CLASS.side_has_conn(self, side)
  for _,C in ipairs(self.room.conns) do
    if C.K1 == self and C.dir == side    then return true end
    if C.K2 == self and C.dir == 10-side then return true end
  end
  return false
end


------------------------------------------------------------------------


function Plan_alloc_id(kind)
  local result = (LEVEL.ids[kind] or 0) + 1
  LEVEL.ids[kind] = result
  return result
end


function Plan_choose_liquid()
  if not LEVEL.liquid and THEME.liquids and STYLE.liquids ~= "none" then
    local name = rand.key_by_probs(THEME.liquids)
    LEVEL.liquid = assert(GAME.LIQUIDS[name])
    gui.printf("Liquid: %s\n\n", name)
  else
    gui.printf("Liquids disabled.\n\n")
  end
end


function Plan_decide_map_size()
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

  return W, H
end


function Plan_create_sections(W, H)

  local SIZE_TABLE = THEME.room_size_table or { 0,30,70,70,40,4 }

  local border_seeds = PARAM.border_seeds or 2
  local free_seeds   = PARAM.free_seeds   or 4

  local function pick_sizes(W, limit)
    local sizes = {}
    local total

    -- adjust for Wolf3D, where each seed is 2x2 blocks, but we add a
    -- block to every section row and column for centered doors (etc).
    if PARAM.tiled then
      limit = PARAM.block_limit - W
      limit = int(limit / 2)
    end

    -- take border seeds into account
    limit = limit - border_seeds*2

    assert(limit >= W * 2)

    for loop = 1,50 do
      total = 0

      for x = 1,W do
        sizes[x] = rand.index_by_probs(SIZE_TABLE)
        total = total + sizes[x]
      end

      if total <= limit then
        return sizes  -- OK!
      end
    end

    gui.printf("Adjusting column sizes to fit...\n")

    while total > limit do
      local x = rand.irange(1,W)

      while x < W and sizes[x] <= 2 do
        x = x + 1
      end

      if x < W then
        sizes[x] = sizes[x] - 1
        total = total - 1
      end
    end

    return sizes
  end

  local function get_positions(size_list)
    local pos = {}

    pos[1] = 1 + border_seeds

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


  ---| Plan_create_sections |---

  local limit = PARAM.seed_limit or 56

  -- reduce level size if rooms would become too small
  -- (2x2 seeds is the absolute minimum)

  local max_W = int(limit / 2.5)
  local max_H = int((limit - free_seeds) / 2.5)

  if W > max_W then W = max_W end
  if H > max_H then H = max_H end

  gui.printf("Map Size: %dx%d sections\n", W, H)

  SECTION_W = W
  SECTION_H = H

  local section_W = pick_sizes(W, limit)
  local section_H = pick_sizes(H, limit - free_seeds)

  local section_X = get_positions(section_W)
  local section_Y = get_positions(section_H)

  dump_sizes("Column widths: ", section_W, SECTION_W)
  dump_sizes("Row heights:   ", section_H, SECTION_H)


  SECTIONS = table.array_2D(SECTION_W, SECTION_H)

  for x = 1,SECTION_W do for y = 1,SECTION_H do
    local K = SECTION_CLASS.new(x, y)

    SECTIONS[x][y] = K

    K.sw = section_W[x]
    K.sh = section_H[y]

    K.sx1 = section_X[x]
    K.sy1 = section_Y[y]
    K.sx2 = K.sx1 + K.sw - 1
    K.sy2 = K.sy1 + K.sh - 1
  end end


  --- create the SEED mapping ---

  local seed_W = section_X[SECTION_W] + section_W[SECTION_W] + border_seeds - 1
  local seed_H = section_Y[SECTION_H] + section_H[SECTION_H] + border_seeds - 1

  -- setup globals 
  SEED_W = seed_W
  SEED_H = seed_H + free_seeds

  -- centre the map : needed for Quake, OK for other games.
  -- this formula ensures that 'coord 0' is still a seed boundary,
  -- which is VITAL for the Quake visibility code.

  SEED_DX = int(SEED_W / 2) * SEED_SIZE
  SEED_DY = int(SEED_H / 2) * SEED_SIZE

  for x = 1,SECTION_W do for y = 1,SECTION_H do
    local K = SECTIONS[x][y]

    K.x1 = (K.sx1 - 1) * SEED_SIZE - SEED_DX
    K.y1 = (K.sy1 - 1) * SEED_SIZE - SEED_DY

    K.x2 = K.sx2 * SEED_SIZE - SEED_DX
    K.y2 = K.sy2 * SEED_SIZE - SEED_DY
  end end
end


function Plan_is_section_valid(x, y)
  return 1 <= x and x <= SECTION_W and
         1 <= y and y <= SECTION_H
end


function Plan_has_section(x, y)
  if SECTIONS[x][y].room then
    return true
  else
    return false
  end
end


function Plan_count_free_sections(x, y)
  local count = 0

  for x = 1,SECTION_W do for y = 1,SECTION_H do
    if not Plan_has_section(x, y) then
      count = count + 1
    end
  end end

  return count
end


function Plan_get_visit_list(x1, y1, x2, y2)
  local visits = {}

  if not x1 then
    x1, x2 = 1, SECTION_W
    y1, y2 = 1, SECTION_H
  end

  for x = x1,x2 do for y = y1,y2 do
    if not Plan_has_section(x, y) then
      table.insert(visits, { x=x, y=y })
    end
  end end

  rand.shuffle(visits)

  return visits
end


function Plan_dump_sections(title)

  local function section_char(x, y)
    local K = SECTIONS[x][y]
    local R = K.room
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
  gui.printf("%s\n", title or "Section Map:")

  for y = SECTION_H,1,-1 do
    local line = "@c  "
    for x = 1,SECTION_W do
      line = line .. section_char(x, y)
    end
    gui.printf("%s\n", line)
  end
  gui.printf("\n")
end


function Plan_add_small_rooms()

  local function can_make_double(K, x, y)
    local can_x = (x < SECTION_W and not Plan_has_section(x+1, y))
    local can_y = (y < SECTION_H and not Plan_has_section(x, y+1))

    if can_x and can_y then
      -- prefer making the room "squarer"
      if K.sh > K.sw+1 and rand.odds(90) then return "x" end
      if K.sw > K.sh+1 and rand.odds(90) then return "y" end

      return rand.sel(33, "x", "y")
    end

    if can_x then return "x" end
    if can_y then return "y" end

    return nil
  end

  ---| Plan_add_small_rooms |---

  for x = 1,SECTION_W do for y = 1,SECTION_H do
    local K = SECTIONS[x][y]
    if not K.room then
      local R = ROOM_CLASS.new("rect")

      K.room = R

      -- sometimes become a 2x1 / 1x2 sized room
      local can_xy = can_make_double(K, x, y)

      if can_xy and rand.odds(40) then
        if can_xy == "x" then
          K = SECTIONS[x+1][y]
        else
          K = SECTIONS[x][y+1]
        end

        assert(not K.room)

        K.room = R
      end
    end
  end end
end


function Plan_add_big_rooms()

  -- shapes are defined by a list of neighbors to set.
  -- numbers over 10 are two seeds away instead of one.
  -- numbers 4xx are moved left, 6xx are moved right.
  -- TODO: use a better system

  local BIG_ROOM_SHAPES =
  {
    plus = { name="plus", size=5, dirs={ 5,2,4,6,8 }},

    T1 = { name="T", size=4, dirs={ 5,4,6,2 }},
    T2 = { name="T", size=5, dirs={ 5,4,6,2,12 }},

    L1 = { name="L", size=3, dirs={ 5,8,6 }},
    L2 = { name="L", size=4, dirs={ 5,8,18,6 }},
    L3 = { name="L", size=4, dirs={ 5,8,6,16 }},
    L4 = { name="L", size=5, dirs={ 5,8,18,6,16 }},

    U1 = { name="U", size=5, dirs={ 5,4,6,402,602 }},
    U2 = { name="U", size=7, dirs={ 5,4,6,402,602,412,612 }},

    HH = { name="odd", size=7, dirs={ 5,4,6,402,602,408,608 }},
  }

  local BIG_SHAPE_PROBS =
  {
    rect = 70,
    plus = 15,

    T1 = 25, T2 = 6,
    L1 = 40, L2 = 10, L3 = 10, L4=5,
    U1 = 15, U2 = 4,  HH = 4,
  }

  local BIG_RECT_PROBS =
  {
    [22] = 80, [33] = 40, [32] = 20, [31] = 4,
  }

  local function test_or_set_rect(kx, ky, rot, w, h, ROOM)
    if w >= SECTION_W or h >= SECTION_H then
      return false  -- would span the whole map
    end

    if bit.btest(rot, 2) then kx = kx - w + 1 end
    if bit.btest(rot, 4) then ky = ky - h + 1 end

    local kx2 = kx + w - 1
    local ky2 = ky + h - 1

    if kx < 1 or kx2 > SECTION_W or
       ky < 1 or ky2 > SECTION_H
    then
      return false
    end

    for x = kx,kx2 do for y = ky,ky2 do
      if ROOM then
        SECTIONS[x][y].room = ROOM
      elseif Plan_has_section(x, y) then
        return false -- would overlap a room
      end
    end end

    return true
  end

  local function test_or_set_shape(kx, ky, rot, dir_list, ROOM)
    local touch_bottom, touch_top
    local touch_left, touch_right

    for _,orig_dir in ipairs(dir_list) do
      local perp = int(orig_dir / 100)

      local dist = 1 + int(orig_dir / 10) % 10
      orig_dir = orig_dir % 10

      local dir  = geom.ROTATE[rot][orig_dir]
      local x, y = geom.nudge(kx, ky, dir, dist)

      if perp > 0 then
        x, y = geom.nudge(x, y, geom.ROTATE[rot][perp])
      end

      if not Plan_is_section_valid(x, y) then
        return false
      end

      if x == 1 then touch_left = true end
      if y == 1 then touch_bottom = true end

      if x == SECTION_W then touch_right = true end
      if y == SECTION_H then touch_top = true end

      if ROOM then
        SECTIONS[x][y].room = ROOM
      elseif Plan_has_section(x, y) then
        return false -- would overlap a room
      end
    end -- orig_dir

    -- would span the whole map? (horizontally)
    if (touch_left and touch_right) then ---??? or (touch_bottom and touch_top) then
      return false
    end

    return true
  end


  local function adjust_shape_probs()
    local shape = STYLE.room_shape

    if shape == "none" then return end

    local new_prob = rand.sel(50, 100, 900)

    gui.printf("Prefer room shape '%s' with prob %d\n", shape, new_prob)

    for name,prob in pairs(BIG_SHAPE_PROBS) do
      if string.sub(name, 1, 1) == shape then
        BIG_SHAPE_PROBS[name] = new_prob
      end
    end
  end


  local function pick_rect_size()
    local raw = rand.key_by_probs(BIG_RECT_PROBS)

    local rw = int(raw / 10)
    local rh =    (raw % 10)

    -- bit less that 50%, since maps are usually wider than tall
    if rand.odds(40) then
      rw, rh = rh, rw
    end

    -- never span the whole map (horizontally)
    if rw >= SECTION_W then rw = SECTION_W - 1 end
    if rh >= SECTION_H then rh = SECTION_H     end

    return rw, rh
  end


  local function try_add_biggie(shape_name, kx, ky, rot, rw, rh)

    if shape_name == "rect" then

      if test_or_set_rect(kx, ky, rot, rw, rh) then
        local R = ROOM_CLASS.new("rect")

        test_or_set_rect(kx, ky, rot, rw, rh, R)

        return rw * rh
      end

    else  -- shaped

      local shape = BIG_ROOM_SHAPES[shape_name]
      assert(shape)

      if test_or_set_shape(kx, ky, rot, shape.dirs) then
        local R = ROOM_CLASS.new(shape.name)

        R.shape_kx  = kx
        R.shape_ky  = ky
        R.shape_rot = rot

        test_or_set_shape(kx, ky, rot, shape.dirs, R)

        return assert(shape.size)
      end
    end
  end


  local function ideal_L_spots(visits)
    local CORNERS = rand.shuffle { 1,3,7,9 }
    
    for _,side in ipairs(CORNERS) do
      if rand.odds(60) then
        local x, y = geom.pick_corner(side, 1,1, SECTION_W, SECTION_H)
        table.insert(visits, 1, { x=x, y=y })
      end
    end
  end

  local function ideal_T_spots(visits)
    local mx = int((SECTION_W+1) / 2)
    local my = int((SECTION_H+1) / 2)

    local SPOTS =
    {
      { x=mx, y=1 },
      { x=mx, y=SECTION_H },
      { y=my, x=1 },
      { y=my, x=SECTION_W },
    }

    for _,spot in ipairs(SPOTS) do
      if rand.odds(60) then
        table.insert(visits, 1, spot)
      end
    end
  end

  local function ideal_PLUS_spots(visits)
    if SECTION_W < 5 or SECTION_H < 5 then return end

    local mx = int((SECTION_W+1) / 2)
    local my = int((SECTION_H+1) / 2)

    if rand.odds(85) then
      table.insert(visits, 1, {x=mx, y=my})
    end
  end

  local function ideal_RECT_spots(visits, rw, rh)
    local x2 = SECTION_W - rw
    local y2 = SECTION_H - rh

    if x2 < 2 or y2 < 2 then return end

    local CORNERS = { 1,3,7,9 }
    rand.shuffle(CORNERS)

    for _,side in ipairs(CORNERS) do
      if rand.odds(50) then
        local mx, my = geom.pick_corner(side, 2,2, x2,y2)
        table.insert(visits, 1, {x=mx, y=my})
      end
    end
  end


  local function add_biggie(quota)
    -- returns size of room

    local shape_name = rand.key_by_probs(BIG_SHAPE_PROBS)

    local rw, rh = pick_rect_size()
    local rot    = rand.irange(0, 3) * 2

    while shape_name == "rect" and (rw * rh) > quota do
      if rw > rh then rw = rw - 1 else rh = rh - 1 end
      assert(rw > 0 and rh > 0)
    end

    local visits = Plan_get_visit_list(1,1, SECTION_W-1, SECTION_H-1)

    -- some shapes fit very well at certain spots.
    -- here we add those spots to the front of the visit list.
    local letter = string.sub(shape_name, 1, 1)

    if letter == "L" then
      ideal_L_spots(visits)

    elseif letter == "T" or letter == "U" then
      ideal_T_spots(visits)

    elseif shape_name == "plus" then
      ideal_PLUS_spots(visits)

    elseif shape_name == "rect" and (rw >= 3 or rh >= 3) then
      ideal_RECT_spots(visits, rw, rh)
    end

    local ROTS
    if shape_name == "rect" or shape_name == "plus" then
      ROTS = { 0 }
    else
      ROTS = rand.shuffle { 0,2,4,6 }
    end

    for _,V in ipairs(visits) do
      for _,rot in ipairs(ROTS) do
        local size = try_add_biggie(shape_name, V.x, V.y, rot, rw, rh)

        if size then return size end  -- SUCCESS !
      end
    end

    -- FAILED

    -- use up some quota, to prevent an infinite loop
    return 0.2
  end


  ---| Plan_add_big_rooms |---

  if rand.odds(2) then return end  -- None!

  adjust_shape_probs()

  local num_sec = Plan_count_free_sections()

  local quota = num_sec * rand.pick { 0.4, 0.6, 0.8 }

  gui.printf("Big Room Quota: %1.1f sections\n", quota)

  while quota >= 3 do
    local size = add_biggie(quota)
    quota = quota - size
  end

Plan_dump_sections("Sections with big rooms:")
end


function Plan_add_natural_rooms()

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

      rand.shuffle(SIDES)

      for _,side in ipairs(SIDES) do
        local nx, ny = geom.nudge(x, y, side)
        if Plan_is_section_valid(nx, ny) and not Plan_has_section(nx, ny) then
          return nx, ny
        end
      end
    end

    return nil -- not found
  end

  local function side_to_coordinate(side)
    local x, y = geom.delta(side)

    x = 1 + int((SECTION_W - 0.7) * (x+1) / 2)
    y = 1 + int((SECTION_H - 0.7) * (y+1) / 2)

    if SECTION_W > 5 then x = x + rand.pick { -1, 0, 1 } end
    if SECTION_H > 5 then y = y + rand.pick { -1, 0, 1 } end

    x = math.clamp(1, x, SECTION_W)
    y = math.clamp(1, y, SECTION_H)

    return x, y
  end

  local function new_area(x, y)
    local R = ROOM_CLASS.new("odd")

    R.natural = true

    SECTIONS[x][y].room = R

    local AREA =
    {
      room = R,
      active = { {x=x, y=y} },
    }

    return AREA
  end

  local function grow_area(area)
    if area.dead then return false end

    -- try all possibilities
    rand.shuffle(area.active)

    for _,A in ipairs(area.active) do
      for _,dir in ipairs(rand.dir_list()) do
        local nx, ny = geom.nudge(A.x, A.y, dir)

        if Plan_is_section_valid(nx, ny) and not Plan_has_section(nx, ny) then
          SECTIONS[nx][ny].room = area.room
          table.insert(area.active, { x=nx, y=ny })
          return true -- OK
        end
      end -- dir
    end -- A

    area.dead = true

    return false
  end


  ---| Plan_add_natural_rooms |---

  if not THEME.cave_walls then return end

  local num_sec = Plan_count_free_sections()

  local perc = style_sel("naturals", 0, 20, 45, 90)

  local quota = int(num_sec * perc / 100)
  if quota > num_sec-3 then
     quota = num_sec-3
  end

  gui.printf("Natural Area Quota: %s --> %d sections\n", STYLE.naturals, quota)

  if quota < 2 then return end


  -- best starting spots are in a corner
  -- worst starting spot is in the middle of the map
  local locations = { [1]=50, [3]=50, [7]=50, [9]=50,
                      [2]=20, [4]=20, [6]=20, [8]=20,
                      [5]=5
                    }

  local areas = { }

  while quota / #areas > rand.irange(6,12) and #areas < 7 do
    if table.empty(locations) then
      break;
    end

    -- pick a location
    local side = rand.key_by_probs(locations)
    locations[side] = nil

    local x, y = find_free_spot(side_to_coordinate(side))

    if x then
      table.insert(areas, new_area(x, y))
    end
  end

  assert(#areas > 0)

  quota = quota - #areas

  -- round-robin grow the areas, using up the quota.

  local loop = 0

  for loop = 0,200 do
    if quota <= 0 then break; end

    -- sometimes skip an area
    if rand.odds(70) then
      local index = 1 + (loop % #areas)

      if grow_area(areas[index]) then
        quota = quota - 1
      end
    end
  end

  Plan_dump_sections("Sections with natural areas:")
end


function Plan_add_special_rooms()
  -- nothing here.... YET!
end


function Plan_collect_sections()
  for kx = 1,SECTION_W do for ky = 1,SECTION_H do
    local K = SECTIONS[kx][ky]
    local R = K.room

    table.insert(R.sections, K)

    R.kx1 = math.min(kx, R.kx1 or 99)
    R.ky1 = math.min(ky, R.ky1 or 99)

    R.kx2 = math.max(kx, R.kx2 or -1)
    R.ky2 = math.max(ky, R.ky2 or -1)

    R.kvolume = (R.kvolume or 0) + 1
  end end

  -- determine sizes
  for _,R in ipairs(LEVEL.all_rooms) do
    assert(R.kx1 and R.ky2 and R.kvolume)
    R.kw, R.kh = geom.group_size(R.kx1, R.ky1, R.kx2, R.ky2)
  end
end


function Plan_decide_outdoors()
  local OUTDOOR_PROBS = THEME.outdoor_probs or { 10, 25, 35, 60 }

  if #OUTDOOR_PROBS ~= 4 then
    error("Theme has bad outdoor_probs table")
  end

  local function choose(R)
    if R.parent then return false end

    if R.natural then
      if not THEME.landscape_walls then return false end
    else
      if not THEME.courtyard_floors then return false end
    end

    if STYLE.skies == "none"   then return false end
    if STYLE.skies == "always" then return true end

    if STYLE.skies == "heaps" then return rand.odds(OUTDOOR_PROBS[4]) end
    if STYLE.skies == "few"   then return rand.odds(OUTDOOR_PROBS[1] / 2) end

    if R.natural then return rand.odds(OUTDOOR_PROBS[2]) end

    -- higher probs for sides of map, even higher for the corners
    local what = 1

    if R.kx1 == 1 or R.kx2 == SECTION_W then what = what + 1 end
    if R.ky1 == 1 or R.ky2 == SECTION_H then what = what + 1 end

    return rand.odds(OUTDOOR_PROBS[what])
  end

  ---| Plan_decide_outdoors |---

  for _,R in ipairs(LEVEL.all_rooms) do
    if R.outdoor == nil then
      R.outdoor = choose(R)
    end
  end
end


function Plan_find_neighbors()

  -- determines neighboring rooms of each room
  -- (including diagonals, which may touch after nudging)

  local function add_neighbor(R, N)
    -- already there?
    for _,O in ipairs(R.neighbors) do
      if O == N then return end
    end

    table.insert(R.neighbors, N)
  end

  for x = 1,SECTION_W do for y = 1,SECTION_H do
    local K = SECTIONS[x][y]
    local R = K.room

    if not R.neighbors then
      R.neighbors = {}
    end

    for side = 1,9 do if side ~= 5 then
      local NK = K:neighbor(side)
      if NK and NK.room ~= R then
        add_neighbor(R, NK.room)
      end
    end end -- side

  end end -- x, y
end


------------------------------------------------------------------------


function Plan_make_seeds()
  
  local function fill_section(kx, ky)
    local K = SECTIONS[kx][ky]
    local R = K.room

    if not R then return end

    if not R.sx1 or K.sx1 < R.sx1 then R.sx1 = K.sx1 end
    if not R.sy1 or K.sy1 < R.sy1 then R.sy1 = K.sy1 end
    if not R.sx2 or K.sx2 > R.sx2 then R.sx2 = K.sx2 end
    if not R.sy2 or K.sy2 > R.sy2 then R.sy2 = K.sy2 end

    R:update_size()

    R.svolume = (R.svolume or 0) + (K.sw * K.sh)
  end

  ---| Plan_make_seeds |---

  for kx = 1,SECTION_W do for ky = 1,SECTION_H do
    fill_section(kx, ky)
  end end
end


function Plan_dump_rooms(title)

  local function seed_to_char(sx, sy)
    -- find the section
    for kx = 1,SECTION_W do for ky = 1,SECTION_H do
      local K = SECTIONS[kx][ky]

      if geom.inside_box(sx,sy, K.sx1,K.sy1, K.sx2,K.sy2) then
        local R = K.room

        if R.kind == "scenic" then return "=" end

        local n = 1 + ((R.id - 1) % 26)

        if R.natural then
          return string.sub("abcdefghijklmnopqrstuvwxyz", n, n)
        else
          return string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZ", n, n)
        end
      end
    end end

    return "."
  end

  gui.printf("%s\n", title or "Seed Map:")

  for y = SEED_H,1,-1 do
    local line = ""
    for x = 1,SEED_W do
      line = line .. seed_to_char(x, y)
    end
    gui.printf("%s\n", line)
  end

  gui.printf("\n")
end


function Plan_prepare_rooms()

  local function add_edges(K)
    for side = 2,8,2 do
      local N = K:neighbor(side)

      if not (N and N.room == K.room) then
        local EDGE = { K=K, side=side, spans={} }

        if geom.is_vert(side) then
          EDGE.real_len = K.x2 - K.x1
        else
          EDGE.real_len = K.y2 - K.y1
        end

        K.edges[side] = EDGE
      end
    end
  end


  local function add_corners(K)
    for side = 1,9,2 do if side ~= 5 then
      local R_dir = geom.RIGHT_45[side]
      local L_dir = geom. LEFT_45[side]

      local N = K:neighbor(side)
      local R = K:neighbor(R_dir)
      local L = K:neighbor(L_dir)

      local R_same = (R and R.room == K.room)
      local L_same = (L and L.room == K.room)

      if not R_same and not L_same then
        K.corners[side] = { K=K, side=side }
      end

      -- detect the "concave" kind, these turn 270 degrees
      if R_same and L_same and not (N and N.room == K.room) then
        K.corners[side] = { K=K, side=side, concave=true }
      end
    end end
  end


  local function add_middle(R, K)
    local MIDDLE =
    {
      K = K
    }

    table.insert(R.middles, MIDDLE)
  end


  local function corner_near_edge(E, want_left)
    local side
    if want_left then side = geom.LEFT_45 [E.side]
                 else side = geom.RIGHT_45[E.side]
    end

    local C = E.K.corners[side]

    if C then
      assert(not C.concave)
      return C
    end

    -- check for concave corners, a bit trickier since it will be
    -- in a different section.

    if want_left then side = geom.LEFT_45 [side]
                 else side = geom.RIGHT_45[side]
    end

    local N = E.K:neighbor(side)

    if not (N and N.room == E.K.room) then
      return nil
    end

    if want_left then side = geom.RIGHT_45[E.side]
                 else side = geom.LEFT_45 [E.side]
    end

    return N.corners[side]
  end


  local function connect_corners(R)
    for _,K in ipairs(R.sections) do
      for _,E in pairs(K.edges) do
        E.corn_L = corner_near_edge(E, true)
        E.corn_R = corner_near_edge(E, false)
      end
    end
  end


  local function prepare_room(R)
    for _,K in ipairs(R.sections) do
      add_edges(K)
      add_corners(K)
      add_middle(R, K)
    end

    connect_corners(R)
  end


  ---| Plan_prepare_rooms |---

  for _,R in ipairs(LEVEL.all_rooms) do
    prepare_room(R)
  end
end



function Plan_create_rooms()
  --
  -- Overview of room planning:
  --
  --   1. decide map size
  --   2. do any special rooms or patterns
  --   3. add big rooms (rect / shaped / natural)
  --   4. add small rooms
  --   5. decide indoor/outdoor
  --   6. create edge and corner lists
  --
  gui.printf("\n--==| Planning Rooms |==--\n\n")

  assert(LEVEL.ep_along)

  LEVEL.all_rooms = {}
  LEVEL.all_conns = {}

  LEVEL.scenic_rooms = {}
  LEVEL.scenic_conns = {}

  gui.random() ; gui.random()

  Plan_choose_liquid()

  local W, H = Plan_decide_map_size()

  Plan_create_sections(W, H)

  Levels_invoke_hook("add_rooms")

  Plan_add_special_rooms()
  Plan_add_natural_rooms()
  Plan_add_big_rooms()
  Plan_add_small_rooms()

  Levels_invoke_hook("adjust_rooms")

  Plan_collect_sections()
  Plan_dump_sections()

  Plan_find_neighbors()

  Plan_decide_outdoors()

  Plan_make_seeds()
  Plan_dump_rooms()

  Plan_prepare_rooms()

  for _,R in ipairs(LEVEL.all_rooms) do
    gui.printf("Final size of %s = %dx%d volume:%d\n", R:tostr(), R.sw, R.sh, R.svolume)
  end
end

