---------------------------------------------------------------
--  PLANNING : Single Player
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

TODO: describe the section/map system

class SECTION
{
  kx, ky  -- location in section map 

  sx1, sy1, sx2, sy2, sw, sh  -- location in seed map

  kind : keyword   -- "section", "section2", "annex", "intrusion"
                   -- "junction", "big_junc", "vert", "horiz"
                   -- "intrusion"

  orig_kind : keyword  -- "section", "junction", "vert", "horiz"

  used : boolean

  room : ROOM
  hall : HALLWAY

  num_conn  -- number of connections

  crossover_hall : HALLWAY

  hall_link[dir] : ROOM/HALL  -- non-nil means that this section in a
                              -- hallway is "pathing" in the given
                              -- direction to the given room, which
                              -- is usually the same as 'hall' field.
}


----------------------------------------------------------------]]


MAP_W = 0  -- number of non-hallway sections
MAP_H = 0  --

SECTION_W = 0
SECTION_H = 0


SECTION_CLASS = { }


function SECTION_CLASS.new(kind, kx, ky)
  local K =
  {
    kind = kind
    orig_kind = kind
    kx = kx
    ky = ky
    num_conn = 0
    hall_link = {}
  }
  table.set_class(K, SECTION_CLASS)
  return K
end


function SECTION_CLASS.tostr(K)
  return string.format("%s [%d,%d]", string.upper(K.kind), K.kx, K.ky)
end


function SECTION_CLASS.set_room(K, R)
  assert(not K.used)
  K.room = R ; K.used = true
end

function SECTION_CLASS.set_hall(K, H)
  assert(not K.used)
  K.hall = H ; K.used = true

  -- TODO: review this (wrong place?)
  for sx = K.sx1, K.sx2 do for sy = K.sy1, K.sy2 do
    SEEDS[sx][sy].hall = H
  end end
end

function SECTION_CLASS.set_crossover(K, H)
  assert(K.used)
  K.crossover_hall = H
end

function SECTION_CLASS.set_big_junc(K)
  assert(not K.used)
  K.kind = "big_junc" ; K.used = true
end

function SECTION_CLASS.set_closet(K, CL)
  assert(not K.used)
  K.closet = CL ; K.used = true
end


function SECTION_CLASS.update_size(K)
  K.sw, K.sh = geom.group_size(K.sx1, K.sy1, K.sx2, K.sy2)
end


function SECTION_CLASS.long_deep(K, dir)
  return geom.long_deep(K.sw, K.sh, dir)
end


function Section_is_valid(x, y)
  return 1 <= x and x <= SECTION_W and
         1 <= y and y <= SECTION_H
end


function Section_random_visits()
  local list = {}

  for kx = 1,SECTION_W do for ky = 1,SECTION_H do
    table.insert(list, SECTIONS[kx][ky])
  end end

  rand.shuffle(list)

  return list
end


function SECTION_CLASS.neighbor(K, dir, dist)
  local nx, ny = geom.nudge(K.kx, K.ky, dir, dist)

  if Section_is_valid(nx, ny) then
    return SECTIONS[nx][ny]
  end

  return nil
end


function SECTION_CLASS.same_room(K, dir, dist)
  local N = K:neighbor(dir, dist)
  return N and N.room == K.room
end


--[[
function SECTION_CLASS.same_room_mask(K)  -- MEH
  local result = 0
  
  if K:same_room(8,2) then result = result + 8 end
  if K:same_room(4,2) then result = result + 4 end
  if K:same_room(2,2) then result = result + 2 end
  if K:same_room(6,2) then result = result + 1 end

  return result
end


function SECTION_CLASS.same_neighbors(K)
  local count = 0
  
  for dir = 2,8,2 do
    if K:same_room(dir, 2) then
      count = count + 1
    end
  end

  return count
end
--]]


function SECTION_CLASS.approx_side_coord(K, dir)
  return geom.nudge(K.kx, K.ky, dir, 0.5)
end


function SECTION_CLASS.touches_edge(K)
  for dir = 2,8,2 do
    if not K:same_room(dir) then return true end
  end

  return false
end


function SECTION_CLASS.contains_chunk(K, C)
  return (C.sx1 >= K.sx1) and (C.sx2 <= K.sx2) and
         (C.sy1 >= K.sy1) and (C.sy2 <= K.sy2)
end


function SECTION_CLASS.clear_expanded(K)
  K.expanded_dirs = nil
end


function SECTION_CLASS.set_expanded(K, dir)
  if not K.expanded_dirs then
    K.expanded_dirs = {}
  end

  K.expanded_dirs[dir] = true
end


function SECTION_CLASS.is_foot(K)  -- returns direction, or nil
  for dir = 2,8,2 do
    if not K:same_room(dir) and
       not K:same_room(geom.RIGHT[dir]) and
       not K:same_room(geom. LEFT[dir]) and
       K:same_room(10 - dir)
    then
      return dir
    end
  end
end


function SECTION_CLASS.eval_exit(K, dir)
  -- evaluate exit from this section + direction
  -- returns value between 0 and 10, or -1 if not possible at all

  if not K:neighbor(dir) then return -1 end

  -- check if direction is unique
  local uniq_dir = true

  local parent = K.room or K.hall
  assert(parent)

  each D in parent.conns do
    if D.L1 == parent and D.dir1 == dir then
      uniq_dir = false ; break
    end
  end

  local rand = ((uniq_dir ? 1 ; 0) + gui.random()) / 2

  -- a free section please
  if K.num_conn > 0 then
    return math.min(K.num_conn, 4) / 4 + rand
  end

  -- a "foot" is a section sticking out (three non-room neighbors).
  -- these are considered the best possible place for an exit
  -- TODO: determine this in preparation phase
  if K.room and K.room.map_volume >= 3 then
    local foot_dir = K:is_foot()

    if foot_dir then
      return (foot_dir == dir ? 9 ; 8) + rand 
    end
  end

  -- sections far away from existing connections are preferred
  local conn_d
  
  if K.room then
    conn_d = K.room:dist_to_closest_conn(K, dir)
  end

  conn_d = (conn_d or 10) / 2  -- adjust for hallway channels

  if conn_d > 4 then conn_d = 4 end

  -- an "uncrowded middler" is the middle of a wide edge and does
  -- not have any neighbors with connections
  if K.room and K.kind == "section" and conn_d >= 2 and
     K:same_room(geom.RIGHT[dir], 2) and
     K:same_room(geom. LEFT[dir], 2)
  then
    return 7 + rand
  end

  -- all other cases
  return 2 + conn_d + rand
end


------------------------------------------------------------------------


function Plan_alloc_id(kind)
  local result = (LEVEL.ids[kind] or 0) + 1
  LEVEL.ids[kind] = result
  return result
end



function Plan_choose_liquid()
  if not LEVEL.liquid and THEME.liquids and STYLE.liquids != "none" then
    local name = rand.key_by_probs(THEME.liquids)
    LEVEL.liquid = assert(GAME.LIQUIDS[name])
    gui.printf("Liquid: %s\n\n", name)

    -- setup the special '_LIQUID' material
    assert(LEVEL.liquid.mat)
    local mat = assert(GAME.MATERIALS[LEVEL.liquid.mat])
    GAME.MATERIALS["_LIQUID"] = mat
  else
    gui.printf("Liquids disabled.\n\n")

    -- leave '_LIQUID' unset : it should not be used, but if does then
    -- the _ERROR texture will appear (like any other unknown material)
  end
end



function Plan_decide_map_size()
  local ob_size = OB_CONFIG.size

  local W, H

  -- there is no real "progression" when making a single level
  -- hence use mixed mode instead.
  if ob_size == "prog" and OB_CONFIG.length == "single" then
    ob_size = "mixed"
  end

  if ob_size == "mixed" then
    W = 2 + rand.index_by_probs { 1,4,7,4,2,1 }
    H = 1 + rand.index_by_probs { 1,4,7,4,2,1 }

    if W < H then W, H = H, W end

  elseif ob_size == "prog" then
    local n = 1 + LEVEL.ep_along * 8.9

    n = int(n)
    if n < 1 then n = 1 end
    if n > 9 then n = 9 end

    local WIDTHS  = { 3,3,3, 4,5,6, 6,8,8 }
    local HEIGHTS = { 2,2,3, 3,4,4, 5,5,6 }

    W = WIDTHS[n]
    H = HEIGHTS[n]

  else
    local WIDTHS  = { tiny=3, small=4, regular=6, large=9, extreme=12 }
    local HEIGHTS = { tiny=2, small=3, regular=4, large=6, extreme=10 }

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
  local SIZE_TABLE = THEME.room_size_table or { 60,30,10 }  -- 3, 4 or 5

  local free_seeds = 4


  local function dump_sizes(line, t, N)
    for i = 1,N do
      line = line .. tostring(t[i]) .. " "
    end
    gui.printf("%s\n", line)
  end


  local function pick_sizes(W, limit)
    local min_size = 3

    -- one spare seed on each edge of the map
    limit = limit - 2

    assert(W >= 2)
    assert(limit >= 1 + W * (min_size+1) + 1)

    -- this lists holds the result sizes
    local sizes = {}

    -- set very left and right (or top and bottom) hallway channels
    sizes[1]     = 1
    sizes[W*2+1] = 1

    local total

    -- try many times to find a usable set of sizes
    for loop = 1,50 do
      total = sizes[1] + sizes[W*2 + 1]

      for x = 1,W do
        sizes[x*2] = 2 + rand.index_by_probs(SIZE_TABLE)
        total = total + sizes[x*2]

        if x < W then
          sizes[x*2+1] = rand.sel(50, 1, 2)
          total = total + sizes[x*2+1]
        end
      end

      if total <= limit then
        return sizes  -- OK!
      end
    end

    -- the above failed, so adjust the last set of sizes it made

    gui.printf("Adjusting column/row sizes....\n")

    for loop = 1,200 do
      if total <= limit then
        return sizes  -- OK!
      end

      -- find a section size to shrink
      local x = rand.irange(1, W)

      while x <= W and sizes[x*2] <= min_size do
        x = x + 1
      end

      if x <= W then
        sizes[x*2] = sizes[x*2] - 1
        total = total - 1
      end

      -- reduce fat hallways too
      if total > limit and rand.odds(25) then
        x = rand.irange(1, W-1)

        while x <= W-1 and sizes[x*2+1] <= 1 do
          x = x + 1
        end

        if x <= W-1 then
          sizes[x*2+1] = sizes[x*2+1] - 1
          total = total - 1
        end
      end 
    end

    -- the assert() above should mean we never get here

    gui.debugf("W:%d min_size:%d limit:%d\n", W, min_size, limit)
    dump_sizes("Failed sizes: ", sizes, W*2 + 1)

    error("pick_sizes failed")
  end


  local function get_positions(W, sizes)
    -- begins at 2 since there is 1 spare seed surrounding the map
    local pos = { 2 }

    for x = 1, W*2 do
      pos[x+1] = pos[x] + sizes[x]
    end

    return pos
  end


  ---| Plan_create_sections |---

  local limit = int(PARAM.map_limit / SEED_SIZE)

  -- reduce level size if rooms would become too small
  -- (this must take hallway channels into account too).

  local max_W = int(limit / 4.3)
  local max_H = int((limit - free_seeds) / 4.3)

  if MAP_W > max_W then MAP_W = max_W end
  if MAP_H > max_H then MAP_H = max_H end

  SECTION_W = MAP_W * 2 + 1
  SECTION_H = MAP_H * 2 + 1

  gui.printf("Map Size: %dx%d --> %dx%d sections\n", MAP_W, MAP_H, SECTION_W, SECTION_H)


  local section_W = pick_sizes(MAP_W, limit)
  local section_H = pick_sizes(MAP_H, limit - free_seeds)

  local section_X = get_positions(MAP_W, section_W)
  local section_Y = get_positions(MAP_H, section_H)

  dump_sizes("Section widths:  ", section_W, SECTION_W)
  dump_sizes("Section heights: ", section_H, SECTION_H)


  SECTIONS = table.array_2D(SECTION_W, SECTION_H)

  for x = 1,SECTION_W do for y = 1,SECTION_H do
    local kind

    if (x % 2) == 0 and (y % 2) == 0 then
      kind = "section"
    elseif (x % 2) == 0 then
      kind = "horiz"
    elseif (y % 2) == 0 then
      kind = "vert"
    else
      kind = "junction"
    end

    local K = SECTION_CLASS.new(kind, x, y)

    SECTIONS[x][y] = K

    K.sw = section_W[x]
    K.sh = section_H[y]

    K.sx1 = section_X[x]
    K.sy1 = section_Y[y]

    K.sx2 = K.sx1 + K.sw - 1
    K.sy2 = K.sy1 + K.sh - 1

    -- remember original location
    K.ox1, K.oy1 = K.sx1, K.sy1
    K.ox2, K.oy2 = K.sx2, K.sy2
  end end


  --- create the SEED map ---

  local seed_W = section_X[SECTION_W] + section_W[SECTION_W]
  local seed_H = section_Y[SECTION_H] + section_H[SECTION_H]

  Seed_init(seed_W, seed_H, 0, free_seeds)
end



function Plan_count_free_room_sections()
  local count = 0

  for mx = 1,MAP_W do for my = 1,MAP_H do
    local K = SECTIONS[mx*2][my*2]

    if not K.used then
      count = count + 1
    end
  end end

  return count
end



function Plan_get_visit_list()
  local visits = {}

  for mx = 1,MAP_W do for my = 1,MAP_H do
    local K = SECTIONS[mx*2][my*2]

    if not K.used then
      table.insert(visits, { mx=mx, my=my, K=K })
    end
  end end

  rand.shuffle(visits)

  return visits
end



function Plan_dump_sections(title)

  local function section_char(x, y)
    local K = SECTIONS[x][y]
    if not K then return ' ' end

    if K.hall then return '#' end
    if K.kind == "junction" then return '+' end
    if K.kind == "big_junc" then return '*' end
    if K.kind == "vert"     then return '|' end
    if K.kind == "horiz"    then return '-' end

    if not K.used then return '.' end
    if not K.room then return '?' end
    
    local R = assert(K.room)

    if R.kind == "scenic" then return '%' end
    local n = 1 + ((R.id - 1) % 26)
    if R.odd_shape then
      return string.sub("abcdefghijklmnopqrstuvwxyz", n, n)
    else
      return string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZ", n, n)
    end
  end

  gui.printf("\n")
  gui.printf("%s\n", title or "Section Map:")

  for y = SECTIONS.h, 1, -1 do
    local line = "  "

    for x = 1, SECTIONS.w do
      line = line .. section_char(x, y)
    end

    gui.printf("%s\n", line)
  end

  gui.printf("\n")
end



function Plan_add_big_junctions()

  local function try_make_big_junc(mx, my, prob)
    if not rand.odds(prob) then return false end

    local K = SECTIONS[mx*2][my*2]

    -- less chance at edges (even less at corners).
    -- that's because we want three or four connections.
    if (mx == 1 or mx == MAP_W) and rand.odds(25) then return false end
    if (my == 1 or my == MAP_H) and rand.odds(25) then return false end

    -- don't want anyone touching our junc!
    for dx = -1,1 do for dy = -1,1 do
      -- allow diagonal touching in one direction only
      if dx == dy then continue end

      local nx, ny = mx + dx, my + dy

      if Section_is_valid(nx*2, ny*2) then
        local N = SECTIONS[nx*2][ny*2]

        if N and N.kind == "big_junc" then return false end
      end
    end end -- dx, dy

    -- width and height must be 3 or 4 seeds (2 is too small, 5 or more
    -- would cause big_junc prefabs to not mesh with the hallway bits).
    if K.sw < 3 or K.sw > 4 then return false end
    if K.sh < 3 or K.sh > 4 then return false end

    -- OK --

    K:set_big_junc()

    return true
  end


  ---| Plan_add_big_junctions |---

  local small_level = (MAP_W + MAP_H <= 5)

  -- decide how many big hallway junctions to make
  local prob = style_sel("big_juncs", 0, 25, 50, 80)

  if not THEME.big_junctions or prob < 1 then
    gui.printf("Big junctions: disabled\n")
    return
  end

  local visits = Plan_get_visit_list()

  each V in visits do
    local did_it = try_make_big_junc(V.mx, V.my, prob)

    -- limit of one big junction in a small level
    if small_level and did_it then break; end
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
    local can_x = (mx < MAP_W) and not SECTIONS[(mx+1)*2][my*2].used
    local can_y = (my < MAP_H) and not SECTIONS[mx*2][(my+1)*2].used

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
        K = SECTIONS[(mx+1)*2][my*2]
      else
        K = SECTIONS[mx*2][(my+1)*2]
      end

      K:set_room(R)
    end
  end


  ---| Plan_add_small_rooms |---

  for mx = 1,MAP_W do for my = 1,MAP_H do
    local K = SECTIONS[mx*2][my*2]

    if not K.used then
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
      local K = SECTIONS[mx*2][my*2]

      if set_R then
        K:set_room(set_R) 
      elseif K.used then
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

      if not Section_is_valid(mx*2, my*2) then
        return false
      end

      if mx == 1 then touch_left = true end
      if my == 1 then touch_bottom = true end

      if mx == MAP_W then touch_right = true end
      if my == MAP_H then touch_top = true end

      local K = SECTIONS[mx*2][my*2]

      if set_R then
        K:set_room(set_R)
      elseif K.used then
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



function Plan_add_odd_shapes()

  local function find_free_spot(mx, my)
    if not SECTIONS[mx*2][my*2].used then
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
        if Section_is_valid(nx*2, ny*2) and not SECTIONS[nx*2][ny*2].used then
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

    local K = SECTIONS[mx*2][my*2]

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

        if Section_is_valid(nx*2, ny*2) and not SECTIONS[nx*2][ny*2].used then
          -- OK --
          local K = SECTIONS[nx*2][ny*2]
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

        local K = SECTIONS[mx*2][my*2]
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

    for mx = 1,MAP_W do for my = 1,MAP_H do
      if mx == x1 or mx == x2 or my == y1 or my == y2 then
        local K = SECTIONS[mx*2][my*2]
        assert(not K.room)
        K:set_room(room)
      end
    end end

    Plan_dump_sections("Sections for surrounder:")
  end


  local function secret_exit_room()
    local K

    -- pick a spot
    repeat
      local mx = rand.sel(50, 2, MAP_W-1)
      local my = rand.irange(1, MAP_H)

      K = SECTIONS[mx*2][my*2]
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

  local function try_join(K, dir)
    local N  = K:neighbor(dir, 1)
    local K2 = K:neighbor(dir, 2)

    if not (N and K2) then return end

    -- require in-between section to be free
    if N.used then return end

    -- require section on far side to be same room
    if K2.room != K.room then return end

    N:set_room(K.room)

    N.kind = "section2"

    table.insert(K.room.sections, N)
  end


  ---| Plan_contiguous_sections |---

  for loop = 1,2 do
    for kx = 1, SECTION_W-1 do for ky = 1, SECTION_H-1 do
      local K = SECTIONS[kx][ky]

      if K.room then
        try_join(K, 6)
        try_join(K, 8)
      end
    end end -- kx, ky
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

---!!!!    if R.shape == "odd" then
---!!!!      keep_stems = false
---!!!!    end

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
    for kx = kx1,kx2 do for ky = ky1,ky2 do
      local KP = SECTIONS[kx][ky]
      if KP.room != K.room then continue end
      if KP:same_room(dir) then continue end

      if not can_nudge(KP, dir) then return false end
      count = count + 1
    end end

    if count == 0 then return false end

    -- actually nudge them
    for kx = kx1,kx2 do for ky = ky1,ky2 do
      local KP = SECTIONS[kx][ky]
      if KP.room != K.room then continue end
      if KP:same_room(dir) then continue end

      local N = KP:neighbor(dir)

      K.room:annex(N)
      K:set_expanded(dir)
    end end

    return true
  end


  local function clear_expanded_dirs()
    for mx = 1,MAP_W do for my = 1,MAP_H do
      local K = SECTIONS[mx*2][my*2]

      K:clear_expanded()
    end end
  end


  local function nudge_rooms()
    local visits  = {}
    local narrows = {}

    for mx = 1,MAP_W do for my = 1,MAP_H do
      local K = SECTIONS[mx*2][my*2]

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
    end end

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
    for kx = 1,SECTION_W do for ky = 1,SECTION_H do
      local K = SECTIONS[kx][ky]

      if not K.used and K.kind == "junction" then
        try_fill_junc(K)
      end
    end end
  end


  ---| Plan_expand_rooms |---

  -- main stuff : expand rooms on sides
  nudge_rooms()

  -- fill in gaps
  Plan_contiguous_sections()

  -- fill unused junctions that border a room on two sides
  fill_junctions()

  -- update the seeds themselves and the room bboxes
  Plan_make_seeds()

  Plan_dump_sections("Sections after expanded:")
end



function Plan_collect_sections()
  for kx = 1,SECTION_W do for ky = 1,SECTION_H do
    local K = SECTIONS[kx][ky]
    local R = K.room

    if R then
      R:add_section(K)
    end
  end end

  -- determine sizes
  each R in LEVEL.rooms do
    assert(R.kx1 and R.ky2 and R.kvolume)
    R.kw, R.kh = geom.group_size(R.kx1, R.ky1, R.kx2, R.ky2)
  end
end



function Plan_decide_outdoors()

  local function score_room(R)
    -- too small ?
    if R.svolume < 8 then return -1 end

    -- never for secret exit
    if R.purpose == "SECRET_EXIT" then return -1 end

    local score = R.svolume

    local what = 0

    -- higher probs for sides of map, even higher for the corners
    if R.kx1 <= 2 or R.kx2 >= SECTION_W-1 then what = what + 1 end
    if R.ky1 <= 2 or R.ky2 >= SECTION_H-1 then what = what + 1 end

    score = score + 10 * what

    score = score + 25 * gui.random() ^ 2

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
    if #list >= 2 and rand.odds(35) then
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

  -- sort rooms by score (highest first)
  table.sort(room_list,
    function(A, B) return A.outdoor_score > B.outdoor_score end)

  -- compute the quota
  local perc = style_sel("outdoors", 0, 15, 35, 60)

  local quota = total_seeds * perc / 100

  gui.printf("Outdoor Quota: %d seeds (%d total)\n", quota, total_seeds)

  while quota > 0 do
    local R = pick_room(room_list, quota)

    -- nothing possible?
    if not R then break end

    R.kind = "outdoor"

    quota = quota - R.svolume
  end
end


function Plan_decide_caves()

  local function score_room(R)
    -- sometimes turn surrounder room into a big cave
    if R.is_surrounder and rand.odds(style_sel("caves", 0, 15, 35, 90)) then
      R.kind = "cave"
      return -1  -- ignore it now
    end

    -- too small ?
    if R.svolume < 24 then return -1 end

    local score = R.svolume

---##  -- prefer not to eat the outdoor rooms
---##  if R.kind == "outdoor" then return score / 2 + gui.random() end

    local what = 0

    -- higher probs for sides of map, even higher for the corners
    if R.kx1 <= 2 or R.kx2 >= SECTION_W-1 then what = what + 1 end
    if R.ky1 <= 2 or R.ky2 >= SECTION_H-1 then what = what + 1 end

    score = score + 10 * what ^ 2

    -- prefer odd-shaped rooms
    if R.odd_shape then score = score * 2 end 

    return score + 25 * gui.random() ^ 2
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
    if #list >= 2 and rand.odds(35) then
      return table.remove(list, 2)
    end

    return table.remove(list, 1)
  end


  ---| Plan_decide_caves |---

  -- collect rooms which can be made into a cave
  local room_list = {}
  local total_seeds = 0

  each R in LEVEL.rooms do
    R.cave_score = score_room(R)

    if R.cave_score > 0 then
      table.insert(room_list, R)
      total_seeds = total_seeds + R.svolume
    end
  end

  if table.empty(room_list) or not THEME.caves then
    gui.printf("Cave Quota: NONE\n")
    return
  end

  -- sort rooms by score (highest first)
  table.sort(room_list,
    function(A, B) return A.cave_score > B.cave_score end)

  -- compute the quota
  local perc = style_sel("caves", 0, 15, 35, 65)

  local quota = total_seeds * perc / 100

  gui.printf("Cave Quota: %d seeds (%d total)\n", quota, total_seeds)

  while quota > 0 do
    local R = pick_room(room_list, quota)

    -- nothing possible?
    if not R then break end

    -- if the room was outdoor, then randomly re-assign as cave,
    -- with a probability depending on the STYLE setting.
    if R.kind == "outdoor" and not rand.odds(perc + 30) then continue end

    R.old_kind = R.kind

    -- re-assign room as a cave
    R.kind = "cave"

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

    if S.edge_of_map then return "/" end

    if S.section and S.section.hall then return "#" end

    local R = S.room
    if not R then return "." end

    if R.kind == "scenic" then return "=" end
    if R.street then return "#" end

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
  --  ??? create edge and corner lists
  --
  gui.printf("\n--==| Planning Rooms |==--\n\n")

  assert(LEVEL.ep_along)

  LEVEL.rooms = {}
  LEVEL.conns = {}
  LEVEL.halls = {}
  LEVEL.scenics = {}
  LEVEL.closets = {}

  Plan_choose_liquid()

  Plan_decide_map_size()
  Plan_create_sections()

  Levels_invoke_hook("add_rooms")

  Plan_add_special_rooms()
  Plan_add_odd_shapes()
  Plan_add_big_rooms()

  Plan_add_big_junctions()
  Plan_add_small_rooms()

  Plan_collect_sections()
  Plan_contiguous_sections()
  Plan_dump_sections()

  Plan_make_seeds()

  Plan_decide_outdoors()
  Plan_decide_caves()

  Plan_dump_rooms()
end

