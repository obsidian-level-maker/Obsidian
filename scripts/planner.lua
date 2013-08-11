----------------------------------------------------------------
--  PLANNING : Single Player
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


MAP_W = 0  -- number of non-hallway sections
MAP_H = 0  --


function Plan_alloc_id(kind)
  local result = (LEVEL.ids[kind] or 0) + 1
  LEVEL.ids[kind] = result
  return result
end



function Plan_choose_darkness()
  local prob = EPISODE.dark_prob or 0

  -- NOTE: this style is only set via the Level Control module
  if STYLE.darkness then
    prob = style_sel("darkness", 0, 10, 30, 90)
  end

  if rand.odds(prob) then
    gui.printf("Darkness falls across the land...\n")

    LEVEL.is_dark = true
    LEVEL.sky_light = 0
    LEVEL.sky_shade = 0
  else
    LEVEL.sky_light = 192
    LEVEL.sky_shade = 160
  end
end



function Plan_choose_liquid()
  if THEME.liquids and STYLE.liquids != "none" then
    local name = rand.key_by_probs(THEME.liquids)
    local liquid = assert(GAME.LIQUIDS[name])

    LEVEL.liquid = liquid

    gui.printf("Liquid: %s\n\n", name)

    -- setup the special '_LIQUID' material
    assert(liquid.mat)
    local info = assert(GAME.MATERIALS[liquid.mat])

    GAME.MATERIALS["_LIQUID"] = info

  else
    gui.printf("Liquids disabled.\n\n")

    -- leave '_LIQUID' unset : it should not be used, but if does then
    -- the _ERROR texture will appear (like any other unknown material)
  end
end



function Plan_decide_map_size()
  assert(LEVEL.ep_along)

  local ob_size = OB_CONFIG.size

  local W, H

  -- there is no real "progression" when making a single level
  -- hence use mixed mode instead.
  if ob_size == "prog" and OB_CONFIG.length == "single" then
    ob_size = "mixed"
  end

  if ob_size == "mixed" then
    W = 2 + rand.index_by_probs { 2,4,6,4,2,1 }
    H = 1 + rand.index_by_probs { 2,4,6,4,2,1 }

    if W < H then W, H = H, W end

  elseif ob_size == "prog" then
    local n = 1 + LEVEL.ep_along * 8.9

    n = int(n)
    if n < 1 then n = 1 end
    if n > 9 then n = 9 end

    local WIDTHS  = { 3,3,3, 4,5,6, 6,7,7 }
    local HEIGHTS = { 2,2,3, 3,4,4, 5,5,6 }

    W = WIDTHS[n]
    H = HEIGHTS[n]

  else
    local WIDTHS  = { tiny=3, small=4, regular=6, large=8, extreme=8 }
    local HEIGHTS = { tiny=2, small=3, regular=4, large=5, extreme=8 }

    W = WIDTHS[ob_size]
    H = HEIGHTS[ob_size]

    if not W then
      error("Unknown size keyword: " .. tostring(ob_size))
    end

    if rand.odds(35) and not LEVEL.secret_exit then
      W = W - 1
    end
  end


  -- remember the size in global variables
  MAP_W = W
  MAP_H = H
end



function Plan_create_sections()

  local function dump_sizes(line, t, N)
    for i = 1,N do
      line = line .. tostring(t[i]) .. " "
    end
    gui.printf("%s\n", line)
  end


  local function pick_sizes(W, limit)

    local sizes = {}
 
    -- set edge sections
    sizes[1]       = EDGE_SEEDS
    sizes[W*2 + 3] = EDGE_SEEDS

    -- set hallway channels next to edge sections
    sizes[2]       = 1
    sizes[W*2 + 2] = 1

    limit = limit - (EDGE_SEEDS + 1) * 2


    for x = 1,W do
      -- room
      sizes[x*2 + 1] = 3
      limit = limit  - 3

      if x < W then
        -- hallway
        sizes[x*2 + 2] = 1
        limit = limit  - 1
      end
    end

    assert(limit >= 0)

    return sizes
  end


  local function get_positions(W, sizes)
    local pos = { 1 }

    for x = 1, W*2 + 2 do
      pos[x+1] = pos[x] + sizes[x]
    end

    return pos
  end


  ---| Plan_create_sections |---

  local limit = int(PARAM.map_limit / SEED_SIZE)

  -- reduce level size if rooms would become too small
  -- (this must take hallway channels into account too).

  local max_W = int((limit - 1) / 4.1)
  local max_H = int((limit - DEPOT_SEEDS - 1) / 4.1)

  if MAP_W > max_W then MAP_W = max_W end
  if MAP_H > max_H then MAP_H = max_H end

  SECTION_W = MAP_W * 2 + 3
  SECTION_H = MAP_H * 2 + 3

  gui.printf("Map Size: %dx%d --> %dx%d sections\n", MAP_W, MAP_H, SECTION_W, SECTION_H)


  local section_W = pick_sizes(MAP_W, limit)
  local section_H = pick_sizes(MAP_H, limit - DEPOT_SEEDS)

  local section_X = get_positions(MAP_W, section_W)
  local section_Y = get_positions(MAP_H, section_H)

  dump_sizes("Section widths:  ", section_W, SECTION_W)
  dump_sizes("Section heights: ", section_H, SECTION_H)


  SECTIONS = table.array_2D(SECTION_W, SECTION_H)

  for x = 1,SECTION_W do
  for y = 1,SECTION_H do
    local shape

    if x == 1 or x == SECTION_W or y == 1 or y == SECTION_H then
      shape = "edge"
    elseif (x % 2) == 1 and (y % 2) == 1 then
      shape = "rect"
    elseif (x % 2) == 1 then
      shape = "horiz"
    elseif (y % 2) == 1 then
      shape = "vert"
    else
      shape = "junction"
    end

    local K = SECTION_CLASS.new(shape, x, y)

    SECTIONS[x][y] = K

    K:set_seed_range(section_X[x], section_Y[y], section_W[x], section_H[y])

    if x == 2 or x == (SECTION_W - 1) or y == 2 or y == (SECTION_H - 1) then
      K.near_edge = true
    end

    -- remember original location
    K.ox1, K.oy1 = K.sx1, K.sy1
    K.ox2, K.oy2 = K.sx2, K.sy2

  end  -- x, y
  end


  --- create the SEED map ---

  local seed_W = section_X[SECTION_W] - 1 + section_W[SECTION_W]
  local seed_H = section_Y[SECTION_H] - 1 + section_H[SECTION_H]

  Seed_init(seed_W, seed_H, 0, DEPOT_SEEDS)
end



function Plan_add_depot_sections()
  LEVEL.depots = {}

  local across_num = int(SEED_W / 3)

  for dy = 1, DEPOT_SEEDS do
  for dx = 1, across_num  do

    local K = SECTION_CLASS.new("depot")  -- no kx/ky coords

    K:set_seed_range(1 + (dx - 1) * 3, SEED_H - (dy - 1), 3, 1)

    table.insert(LEVEL.depots, K)

  end -- dy, dx
  end
end



function Plan_count_free_room_sections()
  local count = 0

  for mx = 1,MAP_W do
  for my = 1,MAP_H do
    local K = Section_get_room(mx, my)

    if K:usable_for_room() then
      count = count + 1
    end
  end
  end

  return count
end



function Plan_get_visit_list()
  local visits = {}

  for mx = 1,MAP_W do
  for my = 1,MAP_H do
    local K = Section_get_room(mx, my)

    if K:usable_for_room() then
      table.insert(visits, { mx=mx, my=my, K=K })
    end
  end
  end

  rand.shuffle(visits)

  return visits
end



function Plan_dump_sections(title)

  local function section_char(x, y)
    local K = SECTIONS[x][y]
    if not K then return ' ' end

    if K.hall then return '#' end

    if not K.room then
      if K.shape == "edge"     then return '/' end
      if K.shape == "vert"     then return '|' end
      if K.shape == "horiz"    then return '-' end
      if K.shape == "junction" then return '+' end
      if K.shape == "big_junc" then return '*' end

      if not K.used then return '.' end
    end

    local R = assert(K.room)

    if R.kind == "scenic" then return '=' end

    local n = 1 + ((R.id - 1) % 26)

    if R.odd_shape then
      return string.sub("abcdefghijklmnopqrstuvwxyz", n, n)
    else
      return string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZ", n, n)
    end
  end

  gui.printf("\n")
  gui.printf("%s\n", title or "Section Map:")

  for y = SECTION_H, 1, -1 do
    local line = "  "

    for x = 1, SECTION_W do
      line = line .. section_char(x, y)
    end

    gui.printf("%s\n", line)
  end

  gui.printf("\n")
end



function Plan_add_big_junctions()

  local function try_make_big_junc(mx, my, prob)
    if not rand.odds(prob) then return false end

    local K = Section_get_room(mx, my)

    -- less chance at edges (even less at corners).
    -- that's because we want three or four connections.
    if (mx == 1 or mx == MAP_W) and rand.odds(30) then return false end
    if (my == 1 or my == MAP_H) and rand.odds(30) then return false end

    -- don't want anyone touching our junc!
    for dx = -1,1 do for dy = -1,1 do
      -- allow diagonal touching in one direction only
      if dx == dy then continue end

      local N = Section_get_room(mx + dx, my + dy)

      if N and N.shape == "big_junc" then return false end

    end end -- dx, dy

    -- width and height must be 3 or 4 seeds (2 is too small, 5 or more
    -- would cause big_junc prefabs to not mesh with the hallway bits).
    if K.sw < 3 or K.sw > 4 then return false end
    if K.sh < 3 or K.sh > 4 then return false end

    -- OK --

    K.shape = "big_junc"

    return true
  end


  ---| Plan_add_big_junctions |---

  local small_level = (MAP_W + MAP_H <= 5)

  -- decide how many big hallway junctions to make
  local prob = style_sel("big_juncs", 0, 15, 35, 70)

  if prob < 1 then
    gui.printf("Big junctions: disabled\n")
    return
  end

  local visits = Plan_get_visit_list()

  each V in visits do
    local did_it = try_make_big_junc(V.mx, V.my, prob)

    -- limit of one big junction in a small level
    if small_level and did_it then break; end
  end

  -- occasionally don't use them  [maybe make into scenic rooms?]
  if rand.odds(10) then
    LEVEL.ignore_big_junctions = true
  end
end



function Plan_add_small_rooms()

  local function new_aspect(K, dir)
    local N = K:neighbor(dir)
    local sw = math.max(K.sx2, N.sx2) - math.min(K.sx1, N.sx1) + 1
    local sh = math.max(K.sy2, N.sy2) - math.min(K.sy1, N.sy1) + 1
    -- normalize the aspect to be >= 1.0
    if sw < sh then sw, sh = sh, sw end
    return sw / sh
  end

  local function can_make_double(K, mx, my)
    local K1 = Section_get_room(mx+1, my)
    local K2 = Section_get_room(mx, my+1)

    local can_x = (mx < MAP_W) and K1:usable_for_room()
    local can_y = (my < MAP_H) and K2:usable_for_room()

    if can_x and can_y then
      -- prefer making the room "squarer"
      local aspect_x = new_aspect(K, 6)
      local aspect_y = new_aspect(K, 8)

      if aspect_x < aspect_y and rand.odds(90) then return "x" end
      if aspect_x > aspect_y and rand.odds(90) then return "y" end

      return rand.sel(50, "x", "y")
    end

    if can_x then return "x" end
    if can_y then return "y" end

    return nil
  end


  local function make_small_room(K, mx, my)
    local kind = rand.sel(33, "rect", "odd")

    local R = ROOM_CLASS.new(kind)

    K:set_room(R)

    -- sometimes become a 2x1 / 1x2 sized room
    local can_xy = can_make_double(K, mx, my)

    if can_xy and rand.odds(40) then
      if can_xy == "x" then
        K = Section_get_room(mx+1, my)
      else
        K = Section_get_room(mx, my+1)
      end

      K:set_room(R)
    end
  end


  ---| Plan_add_small_rooms |---

  for mx = 1,MAP_W do for my = 1,MAP_H do
    local K = Section_get_room(mx, my)

    if K:usable_for_room() then
      make_small_room(K, mx, my)
    end
  end end
end



function Plan_add_big_rooms()
  local BIG_ROOM_SHAPES =
  {
    plus = { name="plus", locs={ 0,0, 0,-1, -1,0, 1,0, 0,1 } }

    T1 = { name="T", locs={ 0,0, -1,0, 1,0, 0,1 } }
    T2 = { name="T", locs={ 0,0, -1,0, 1,0, 0,1, 0,2 } }

    L1 = { name="L", locs={ 0,0, 0,1, 1,0 } }
    L2 = { name="L", locs={ 0,0, 0,1, 0,2, 1,0 } }
    L3 = { name="L", locs={ 0,0, 0,1, 1,0, 2,0 } }
    L4 = { name="L", locs={ 0,0, 0,1, 0,2, 1,0, 2,0 } }

    U1 = { name="U", locs={ 0,0, -1,0, 1,0, -1,1, 1,1 } }
    U2 = { name="U", locs={ 0,0, -1,0, 1,0, -1,1, 1,1, -1,2, 1,2 } }

    SS = { name="S", locs={ 0,0, -1,0, 1,0, -1,-1, 1,1 } }
    HH = { name="H", locs={ 0,0, -1,0, 1,0, -1,-1, 1,-1, -1,1, 1,1 } }
  }

  local BIG_SHAPE_PROBS =
  {
    rect = 220,
    plus = 15,

    T1 = 25, T2 = 6,
    L1 = 40, L2 = 10, L3 = 10, L4=5,
    U1 = 15, U2 = 2,
    SS = 10, HH = 7,
  }

  local BIG_RECT_PROBS =
  {
    [22] = 80, [33] = 40, [32] = 20
  }


  local function adjust_shape_probs()
    -- occasionally don't make any rectangles
    if rand.odds(5) then
      BIG_SHAPE_PROBS.rect = 1
    end

    -- promote a certain shape
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


  local function test_or_set_rect(mx1, my1, rot, w, h, set_R)
    if w >= MAP_W or h >= MAP_H then
      return false  -- would span the whole map
    end

    if bit.btest(rot, 2) then mx1 = mx1 - w + 1 end
    if bit.btest(rot, 4) then my1 = my1 - h + 1 end

    local mx2 = mx1 + w - 1
    local my2 = my1 + h - 1

    if mx1 < 1 or my1 < 1 or mx2 > MAP_W or my2 > MAP_H then
      return false
    end

    for mx = mx1,mx2 do for my = my1,my2 do
      local K = Section_get_room(mx, my)

      if set_R then
        K:set_room(set_R) 
      elseif not K:usable_for_room() then
        return false -- would overlap a room
      end
    end end

    return true
  end


  local function test_or_set_shape(mx1, my1, rot, locs, set_R)
    local touch_left, touch_right
    local touch_bottom, touch_top

    for index = 1, #locs-1, 2 do
      local dx = locs[index]
      local dy = locs[index+1]
      
      local mx, my

          if rot == 0 then mx, my = mx1 + dx, my1 + dy
      elseif rot == 4 then mx, my = mx1 - dx, my1 - dy
      elseif rot == 2 then mx, my = mx1 + dy, my1 - dx
      elseif rot == 6 then mx, my = mx1 - dy, my1 + dx
      else error("Bad rot in test_or_set_shape: " .. tostring(rot))
      end

      if not Section_get_room(mx, my) then
        return false
      end

      if mx == 1 then touch_left = true end
      if my == 1 then touch_bottom = true end

      if mx == MAP_W then touch_right = true end
      if my == MAP_H then touch_top = true end

      local K = Section_get_room(mx, my)

      if set_R then
        K:set_room(set_R)
      elseif not K:usable_for_room() then
        return false -- would overlap a room
      end
    end -- index

    -- would span the whole map? (horizontally)
    if touch_left and touch_right then
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

    -- never span the whole map (horizontally)
    if rw >= MAP_W then rw = MAP_W - 1 end
    if rh >= MAP_H then rh = MAP_H     end

    return rw, rh
  end


  local function try_add_biggie(shape_name, mx, my, rot, rw, rh)
    if shape_name == "rect" then

      if test_or_set_rect(mx, my, rot, rw, rh) then
        local R = ROOM_CLASS.new("rect")

        test_or_set_rect(mx, my, rot, rw, rh, R)

        return rw * rh
      end

    else  -- shaped
      local shape = BIG_ROOM_SHAPES[shape_name]
      assert(shape)

      if test_or_set_shape(mx, my, rot, shape.locs) then
        local R = ROOM_CLASS.new(shape.name)

        R.shape_kx  = mx*2
        R.shape_ky  = my*2
        R.shape_rot = rot

        test_or_set_shape(mx, my, rot, shape.locs, R)

        return #shape.locs / 2
      end
    end
  end


  local function ideal_L_spots(visits)
    local CORNERS = rand.shuffle { 1,3,7,9 }
    
    each side in CORNERS do
      if rand.odds(75) then
        local mx, my = geom.pick_corner(side, 1,1, MAP_W, MAP_H)
        table.insert(visits, 1, { mx=mx, my=my })
      end
    end
  end


  local function ideal_T_spots(visits)
    local mid_x = int((MAP_W+1) / 2)
    local mid_y = int((MAP_H+1) / 2)

    local SPOTS =
    {
      { mx=mid_x, my=1 }
      { mx=mid_x, my=MAP_H }
      { my=mid_y, mx=1 }
      { my=mid_y, mx=MAP_W }
    }

    rand.shuffle(SPOTS)

    each spot in SPOTS do
      if rand.odds(75) then
        table.insert(visits, 1, spot)
      end
    end
  end


  local function ideal_PLUS_spots(visits)
    if MAP_W < 5 or MAP_H < 5 then return end

    local mid_x = int((MAP_W+1) / 2)
    local mid_y = int((MAP_H+1) / 2)

    if rand.odds(90) then
      table.insert(visits, 1, {mx=mid_x, my=mid_y})
    end
  end


--[[
  local function ideal_RECT_spots(visits, rw, rh)
    local x2 = SECTION_W - rw
    local y2 = SECTION_H - rh

    if x2 < 2 or y2 < 2 then return end

    local CORNERS = { 1,3,7,9 }
    rand.shuffle(CORNERS)

    each side in CORNERS do
      if rand.odds(50) then
        local mx, my = geom.pick_corner(side, 2,2, x2,y2)
        table.insert(visits, 1, {mx=mx, my=my})
      end
    end
  end
--]]


  local function add_biggie(quota)
    -- returns size of room

    local shape_name = rand.key_by_probs(BIG_SHAPE_PROBS)

    local rw, rh = pick_rect_size()

    while shape_name == "rect" and (rw * rh) > quota do
      if rw > rh then rw = rw - 1 else rh = rh - 1 end
      assert(rw > 0 and rh > 0)
    end

    local visits = Plan_get_visit_list()

    -- some shapes fit very well at certain spots.
    -- here we add those spots to the front of the visit list.
    local letter = string.sub(shape_name, 1, 1)

    if letter == "L" then
      ideal_L_spots(visits)

    elseif letter == "T" or letter == "U" then
      ideal_T_spots(visits)

    elseif shape_name == "plus" then
      ideal_PLUS_spots(visits)

---???    elseif shape_name == "rect" and (rw >= 3 or rh >= 3) then
---???      ideal_RECT_spots(visits, rw, rh)
    end

    local ROTS
    if shape_name == "rect" or shape_name == "plus" then
      ROTS = { 0 }
    else
      ROTS = rand.shuffle { 0,2,4,6 }
    end

    each V in visits do
      each rot in ROTS do
        local size = try_add_biggie(shape_name, V.mx, V.my, rot, rw, rh)

        if size then return size end  -- SUCCESS !
      end
    end

    -- FAILED

    -- use up some quota, to prevent an infinite loop
    return 0.1
  end


  ---| Plan_add_big_rooms |---

  adjust_shape_probs()

  local perc = style_sel("big_rooms", 0, 17, 35, 70)

  local num_free = Plan_count_free_room_sections()

  local quota = num_free * perc / 100

  gui.printf("Big Room Quota: %d sections\n", quota)

  while quota >= 3 do
    local size = add_biggie(quota)
    quota = quota - size
  end

  Plan_dump_sections("Sections with big rooms:")
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



function Plan_add_odd_shapes__OLD()

  local function find_free_spot(mx, my)
    local K = Section_get_room(mx, my)

    if K:usable_for_room() then
      return mx, my
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

      each side in SIDES do
        local nx, ny = geom.nudge(mx, my, side)
        K = Section_get_room(nx, ny)
        if K and K:usable_for_room() then
          return nx, ny
        end
      end
    end

    return nil -- not found
  end


  local function side_to_coordinate(side)
    local mx, my = geom.delta(side)

    mx = 1 + int((MAP_W - 0.7) * (mx+1) / 2)
    my = 1 + int((MAP_H - 0.7) * (my+1) / 2)

    if MAP_W > 5 then mx = mx + rand.pick { -1, 0, 1 } end
    if MAP_H > 5 then my = my + rand.pick { -1, 0, 1 } end

    mx = math.clamp(1, mx, MAP_W)
    my = math.clamp(1, my, MAP_H)

    return mx, my
  end


  local function new_area(mx, my)
    local R = ROOM_CLASS.new("odd")

    R.odd_shape = true

    local K = Section_get_room(mx, my)

    K:set_room(R)

    local AREA =
    {
      room = R,
      active = { {mx=mx, my=my} },
    }

    return AREA
  end


  local function grow_area(area)
    if area.dead then return false end

    -- try all possibilities
    rand.shuffle(area.active)

    each A in area.active do
      each dir in rand.dir_list() do
        
        local nx, ny = geom.nudge(A.mx, A.my, dir)

        local K = Section_get_room(nx, ny)

        if K and K:usable_for_room() then
          -- OK --
          K:set_room(area.room)

          table.insert(area.active, { mx=nx, my=ny })
          return true
        end

      end
    end

    area.dead = true

    return false
  end


  ---| Plan_add_odd_shapes |---

  local perc = style_sel("odd_shapes", 0, 14, 30, 70)

  local num_free = Plan_count_free_room_sections()

  local quota = int(num_free * perc / 100)

  gui.printf("Odd Shape Quota: %d sections\n", quota)

  if quota < 2 then return end


  -- add starting spots (one for each area)

  -- best starting spots are in a corner
  -- worst starting spot is in the middle of the map
  local locations = { [1]=50, [3]=50, [7]=50, [9]=50,
                      [2]=20, [4]=20, [6]=20, [8]=20,
                      [5]=7
                    }

  local areas = { }

  while not table.empty(locations) and #areas < 7 and
       (#areas == 0 or quota / #areas > rand.irange(6,12))
  do
    -- pick a location
    local side = rand.key_by_probs(locations)
    locations[side] = nil

    local mx, my = find_free_spot(side_to_coordinate(side))

    if mx then
      table.insert(areas, new_area(mx, my))
      quota = quota - 1
    end
  end

  assert(#areas > 0)


  -- grow the areas (round-robin style) until quota is used up

  for loop = 1,200 do
    if quota < 1 then break; end

    -- sometimes skip an area
    if rand.odds(35) then continue; end

    local index = 1 + (loop % #areas)

    if grow_area(areas[index]) then
      quota = quota - 1
    end
  end

  Plan_dump_sections("Sections with odd shapes areas:")
end



function Plan_add_special_rooms()

  local function central_hub_room()
    -- size check
    if MAP_W < 4 or MAP_H < 3 then return end

    local room = ROOM_CLASS.new("odd")

    room.central_hub = true

    local hub_W = (MAP_W + 1) * 0.4
    local hub_H = (MAP_H + 1) * 0.4

    if MAP_W > 3 then hub_W = hub_W + gui.random() end
    if MAP_H > 3 then hub_H = hub_H + gui.random() end

    -- round values down and clamp
    hub_W = int(hub_W)
    hub_H = int(hub_H)

    if hub_W > 3 then hub_W = 3 end
    if hub_H > 3 then hub_H = 3 end

    local hub_X = 1 + int((MAP_W - hub_W) / 2)
    local hub_Y = 1 + int((MAP_H - hub_H) / 2)

    for mx = hub_X, hub_X+hub_W-1 do
      for my = hub_Y, hub_Y+hub_H-1 do

        local K = Section_get_room(mx, my)
        assert(not K.room)

        K:set_room(room)
      end
    end

    Plan_dump_sections("Sections for hub mode:")
  end


  local function surround_map()
    -- size check
    if MAP_W < 4 or MAP_H < 3 then return end

    local room = ROOM_CLASS.new("odd")

    room.is_surrounder = true

    local x1, x2 = 1, MAP_W
    local y1, y2 = 1, MAP_H

    if MAP_W >= 6  then x2 = x2 - 1 end
    if MAP_W >= 8  then x1 = x1 + 1 end
    if MAP_W >= 10 then x1 = x1 + 1 end

    if MAP_H >= 6 then y2 = y2 - 1 end
    if MAP_H >= 8 then y1 = y1 + 1 end

    for mx = 1, MAP_W do
    for my = 1, MAP_H do
      if mx == x1 or mx == x2 or my == y1 or my == y2 then
        local K = Section_get_room(mx, my)
        assert(not K.room)
        K:set_room(room)
      end
    end
    end

    Plan_dump_sections("Sections for surrounder:")
  end


  local function secret_exit_room()
    local K

    -- pick a spot
    repeat
      local mx = rand.sel(50, 2, MAP_W-1)
      local my = rand.irange(1, MAP_H)

      K = Section_get_room(mx, my)
    until not K.room

    local room = ROOM_CLASS.new("odd")

    room.purpose = "SECRET_EXIT"

    K:set_room(room)

    gui.debugf("Secret exit is %s @ %s\n", room:tostr(), K:tostr())
  end


  ---| Plan_add_special_rooms |---

  if LEVEL.special == "surround" then
    surround_map()

  elseif LEVEL.special == "wagon" then
    central_hub_room()
  end

  -- secret exit
  if LEVEL.secret_exit then
    secret_exit_room()
  end
end



function Plan_contiguous_sections()
  -- make sure that multi-section rooms are contiguous, i.e. each section
  -- touches a nearby section of the same room (no hallway in between).

  local function try_join(K1, dir)
    local N  = K1:neighbor(dir, 1)
    local K2 = K1:neighbor(dir, 2)

    if not (N and K2) then return end

    if N.used then return end

    -- require section on far side to be same room
    if K2.room != K1.room then return end

    local R = K1.room

    N:set_room(R)

    table.insert(R.sections, N)
  end


  ---| Plan_contiguous_sections |---

  for loop = 1,2 do
    for kx = 1, SECTION_W do
    for ky = 1, SECTION_H do
      local K = SECTIONS[kx][ky]

      if K.room then
        try_join(K, 6)
        try_join(K, 8)
      end
    end -- kx, ky
    end
  end -- loop
end



function Plan_expand_rooms()
  -- this must be called after hallways are generated, and will
  -- assign unused sections to belong to a neighboring room.

  local function can_nudge(K, dir)
    -- prevent flow on
    if K.expanded_dirs and K.expanded_dirs[dir] then
      return false
    end

    local N = K:neighbor(dir)

    if not N  then return false end
    if N.used then return false end

    return true -- OK
  end


  local function try_nudge_section(K, dir)
    local R = K.room

    -- for shaped rooms require all stems to be nudged together
    -- (in order to keep the shape synchronised).
    local keep_stems = true

---!!!    if R.shape == "odd" then
---!!!      keep_stems = false
---!!!    end

    local kx1, ky1 = K.kx, K.ky
    local kx2, ky2 = K.kx, K.ky
    
    if keep_stems then
      if geom.is_vert(dir) then
        kx1, kx2 = R.kx1, R.kx2
      else
        ky1, ky2 = R.ky1, R.ky2
      end
    end

    local count = 0

    -- test if all sections can be nudged
    for kx = kx1,kx2 do
    for ky = ky1,ky2 do
      local KP = SECTIONS[kx][ky]
      if KP.room != K.room then continue end
      if KP:same_room(dir) then continue end

      if not can_nudge(KP, dir) then return false end
      count = count + 1
    end
    end

    if count == 0 then return false end

    -- actually nudge them
    for kx = kx1,kx2 do
    for ky = ky1,ky2 do
      local KP = SECTIONS[kx][ky]
      if KP.room != K.room then continue end
      if KP:same_room(dir) then continue end

      local N = KP:neighbor(dir)

      K.room:annex(N)
      K:set_expanded(dir)
    end
    end

    return true
  end


  local function clear_expanded_dirs()
    for mx = 1,MAP_W do for my = 1,MAP_H do
      local K = Section_get_room(mx, my)

      K:clear_expanded()
    end end
  end


  local function nudge_rooms()
    local visits  = {}
    local narrows = {}

    for mx = 1,MAP_W do
    for my = 1,MAP_H do
      local K = Section_get_room(mx, my)

      if K.room then
        table.insert(visits, { K=K, dirs={2,4,6,8} })

        if K.sh == 2 then
          table.insert(narrows, { K=K, dir=2 })
          table.insert(narrows, { K=K, dir=8 })
        end

        if K.sw == 2 then
          table.insert(narrows, { K=K, dir=4 })
          table.insert(narrows, { K=K, dir=6 })
        end
      end
    end  -- mx, my
    end

    -- do an initial pass to try and expand very narrow rooms
    rand.shuffle(narrows)

    each spot in narrows do
      try_nudge_section(spot.K, spot.dir)
    end

    clear_expanded_dirs()

    for loop = 1,4 do
      rand.shuffle(visits)

      each V in visits do
        local dir = table.remove(V.dirs, rand.irange(1, #V.dirs))

        try_nudge_section(V.K, dir)
      end
    end
  end


  local function try_fill_junc(K)
    local rooms = {}

    for dir = 2,8,2 do
      local N = K:neighbor(dir)
      if N and N.room then rooms[dir] = N.room end
    end

    local DIR_LIST = { 4,6 }
    rand.shuffle(DIR_LIST)

    each dir in DIR_LIST do
      local R = rooms[dir]

      if not R then continue end
      if R.shape != "odd" then continue end

      if rooms[2] == R or rooms[8] == R then
        R:annex(K)
        K.expanded_dirs = { 2,4,6,8 }
        return true
      end
    end

    return false
  end


  local function fill_junctions()
    for kx = 1,SECTION_W do
    for ky = 1,SECTION_H do
      local K = SECTIONS[kx][ky]

      if K.shape == "junction" and not K.used then
        try_fill_junc(K)
      end
    end
    end
  end


  local function neighbor_cave_room(K, dir)
    local N = K:neighbor(dir)

    if (N and N.room and N.room.kind == "cave") then
      return N.room
    end

    return nil
  end


  local function try_expand_cave_at_edge(K, dir)
    local N  = K:neighbor(dir, 1)
    local N2 = K:neighbor(dir, 2)

    if not N or N.used then return end

    if not N.near_edge then return end

    -- OK

    K.room:annex(N)

    if N2 and not N2.used then
      K.room:annex(N2)
      K.expanded_dirs = { 2,4,6,8 }
    end
  end


  local function try_expand_cave_corner(K)
    local A = neighbor_cave_room(K, 4) 
    local B = neighbor_cave_room(K, 6) 

    local C = neighbor_cave_room(K, 2) 
    local D = neighbor_cave_room(K, 8) 

    if (A or B) and (C or D) and ((A or B) == (C or D)) then
      local R = A or B
      R:annex(K)
      K.expanded_dirs = { 2,4,6,8 }
    end
  end


  local function expand_caves()
    -- Note: done in two distinct steps to prevent run-on along the
    --       edges of the map.

    -- step 1 : expand out to edges

    for kx = 3, SECTION_W-2 do
    for ky = 3, SECTION_H-2 do
      local K = SECTIONS[kx][ky]

      if not (K.room and K.room.kind == "cave") then continue end

      for dir = 2,8,2 do
        try_expand_cave_at_edge(K, dir)
      end
    end
    end

    -- step 2 : fill in corners (require two sides to be cave)

    for loop = 1, 2 do
      for kx = 1, SECTION_W do
      for ky = 1, SECTION_H do
        local K = SECTIONS[kx][ky]

        if not (K.near_edge or K.shape == "edge") then continue end

        if K.used then continue end

        try_expand_cave_corner(K)
      end
      end
    end -- loop
  end


  ---| Plan_expand_rooms |---

  -- main stuff : expand rooms on sides
  expand_caves()

---!!!!  nudge_rooms()

  -- fill in gaps
  Plan_contiguous_sections()

  -- fill unused junctions that border a room on two sides
--???  fill_junctions()

  -- update the seeds themselves and the room bboxes
  Plan_make_seeds()

  Plan_dump_sections("Sections after expanded:")
end



function Plan_collect_sections()
  for kx = 1,SECTION_W do
  for ky = 1,SECTION_H do
    local K = SECTIONS[kx][ky]
    local R = K.room

    if R then
      R:add_section(K)
    end
  end -- kx, ky
  end

  -- determine sizes
  each R in LEVEL.rooms do
    assert(R.kx1 and R.ky2 and R.kvolume)
    R.kw, R.kh = geom.group_size(R.kx1, R.ky1, R.kx2, R.ky2)
  end
end



function Plan_decide_outdoors()

  local function turn_into_outdoor(R)
    if R.kind != "cave" then
       R.kind = "outdoor"
    end

    R.is_outdoor = true
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
    if R.kx1 <= 3 or R.kx2 >= SECTION_W-2 then what = what + 1 end
    if R.ky1 <= 3 or R.ky2 >= SECTION_H-2 then what = what + 1 end

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

  gui.printf("Outdoor Quota: %d seeds (%d total)\n", quota, total_seeds)

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



------------------------------------------------------------------------


function Plan_make_seeds()
  
  local function fill_section(kx, ky)
    local K = SECTIONS[kx][ky]

    for sx = K.sx1,K.sx2 do for sy = K.sy1,K.sy2 do
      SEEDS[sx][sy].section = K
    end end

    if K.room then
      K.room:fill_section(K)
    end
  end


  ---| Plan_make_seeds |---

  -- meh! (needed since this function is called multiple times)
  each R in LEVEL.rooms do
    R.svolume = 0
  end

  for kx = 1,SECTION_W do for ky = 1,SECTION_H do
    fill_section(kx, ky)
  end end
end



function Plan_dump_rooms(title, match_kind)
  
  local function seed_to_char(sx, sy)
    local S = SEEDS[sx][sy]

    local K = S.section

    if K and K.used then
      if K.shape == "big_junc" then return "@" end

      if K.hall then return "#" end
    end

    local R = S.room

    if not R then
      if S.closet then return "$" end
      if S.border then return "%" end

      if S.edge_of_map or S.free then return "/" end

      return " "
    end

    if R.kind == "scenic" then return "=" end

    if R.is_street then return ":" end

    local n = 1 + ((R.id - 1) % 26)

    if R.kind == "outdoor" then
      return string.sub("abcdefghijklmnopqrstuvwxyz", n, n)
    else
      return string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZ", n, n)
    end
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


--[[ OLD STUFF

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
    for side = 1,9,2 do if side != 5 then
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
    each K in R.sections do
      for _,E in pairs(K.edges) do
        E.corn_L = corner_near_edge(E, true)
        E.corn_R = corner_near_edge(E, false)
      end
    end
  end


  local function prepare_room(R)
    each K in R.sections do
      add_edges(K)
      add_corners(K)
      add_middle(R, K)
    end

    connect_corners(R)
  end


  ---| Plan_prepare_rooms |---

  each R in LEVEL.rooms do
    prepare_room(R)

    gui.printf("Final size of %s = %dx%d volume:%d\n", R:tostr(), R.sw, R.sh, R.svolume)
  end
end

--]]


function Plan_create_rooms()
  --
  -- Overview of room planning:
  --
  --   1. decide map size
  --   2. do any special rooms or patterns
  --   3. add odd-shaped and big rooms
  --   4. add small rooms
  --   5. decide outdoors and caves
  --
  gui.printf("\n--==| Planning Rooms |==--\n\n")

  LEVEL.rooms = {}
  LEVEL.conns = {}
  LEVEL.halls = {}
  LEVEL.scenics = {}

  Plan_choose_darkness()
  Plan_choose_liquid()

  Plan_decide_map_size()
  Plan_create_sections()
  Plan_add_depot_sections()

  Levels_invoke_hook("add_rooms")

  Plan_add_special_rooms()
  Plan_add_caves()
  Plan_add_big_rooms()
  Plan_add_big_junctions()
  Plan_add_small_rooms()

  Plan_collect_sections()
  Plan_contiguous_sections()
  Plan_dump_sections()

  Plan_make_seeds()

  Plan_decide_outdoors()

  Plan_dump_rooms()
end

