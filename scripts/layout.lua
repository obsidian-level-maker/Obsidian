----------------------------------------------------------------
--  Room Layouting
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2008 Andrew Apted
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

--[[

Room Layouting Notes
====================

DESCRIPTION OF PROBLEM:

+ Primary goal is to ensure all exit seeds in a room
  are traversable, i.e. there exists a path from X to Y
  such that each element is either a symbolic height ('0' .. '3')
  or a staircase ('>', '<', 'v', '^', 'F', 'T', 'L', 'J').

  Certain staircases are never usable on certain rows or
  columns (e.g. cannot use 'F' on top row if vertically mirrored).

  In emergencies we can mark certain seeds as "laddering"
  onto an adjacent height-difference seed.  We must try hard
  to (a) avoid this or (b) minimise its use and (c) pick
  the best seed pair to ladder [not an exit seed, low diff, etc]

+ Secondary goal is "niceness" of the room layout:
  (a) staircases are not used in two adjacent seeds

  (b) F/T/L/J staircases only used in corners
      (or "pseudo-corners" i.e. floor seeds at higher heights)

  (c) height diff between staircases is '1' unit
      [any is possible, the lower the better]

  (d) small preference for staircases parallel to main direction
      of room (esp. PC/PR/PX and TY types).

+ Tertiary goal is to assign diagonal corners and solid
  seeds, as well as flood filling floor heights, in a
  pleasing/interesting way.


IDEA:
  Primitive operations:

  1) start at exit A, go (anti)clockwise around the edge of the
     room until hit exit B, use suitable connections
     (especially corner stairwells).

  2) start at exit A, go inward until hit exit B.
     If hit a blank wall instead, assume hit the R.floor_h
     seed [if none: one closer to it] and put stairs
     appropriately for that.

  3) start at exit A, go inward a certain dist then turn left
     or right and run towards exit B.

  3) ?? void up edges [if not empty, replicated exit seeds into inner area]
  4) ?? ledge up edges [need exits all at same height, or use R.floor_h]

  Repeat the primitive operations for random exit seeds
  until full traversibility is reached (or run out of
  usable directions]

  Add emergency "ladders" when no more traversifying can be done.

  Score the final result.  Perform ### fillings for each room
  and pick the one with the best result.

  [Can fill holes and decide solid corners last]

--]]



function calc_conn_area(R)
  local lx, ly = 999,999
  local hx, hy = 0,0

  for _,C in ipairs(R.conns) do
    local S = C:seed(R)
    lx = math.min(lx, S.sx)
    ly = math.min(ly, S.sy)
    hx = math.max(hx, S.sx)
    hy = math.max(hy, S.sy)
  end

  assert(lx <= hx and ly <= hy)

  return lx,ly, hx,hy
end


function calc_height_set(R)
  local list = { }

  local function add_height(new_h)
    for _,h in ipairs(list) do
      if math.abs(h - new_h) < 1 then
        return
      end
    end
    
    table.insert(list, new_h)
  end

  for _,C in ipairs(R.conns) do
    add_height(C.conn_h)
  end
  
  if #list < 3 and math.min(R.sw, R.sh) >= 3 then
    add_height(R.floor_h)
  end

  table.sort(list, function(A,B) return A < B end)

  return list
end


function dump_layout(R)

  local function outside_seed(x, y)
    for _,C in ipairs(R.conns) do
      local S = C:seed(R)
      local ox, oy = nudge_coord(S.sx, S.sy, S.conn_dir)
      if ox == x and oy == y then
        return "+"
      end
    end

    return " "
  end

  local function inside_seed(x, y)
    local S = SEEDS[x][y][1]
    assert(S and S.room == R)

    if S.layout_char then
      return S.layout_char
    end

    return "."
  end


  --| dump_layout |--

  gui.debugf("Room %s @ (%d,%d) Layout:\n", R.kind, R.sx1, R.sy1)

  for y = R.ty2+1, R.ty1-1, -1 do
    line = ""
    for x = R.tx1-1, R.tx2+1 do
      if x < R.tx1 or x > R.tx2 or y < R.ty1 or y > R.ty2 then
        line = line .. outside_seed(x, y)
      else
        line = line .. inside_seed(x, y)
      end
    end
    gui.debugf(" %s\n", line)
  end

  gui.debugf("\n");
end


function Junk_fill_room(R, n_sx1, n_sy1, n_sx2, n_sy2)
  for y = R.sy1,R.sy2 do for x = R.sx1,R.sx2 do
    if not box_contains_point(n_sx1,n_sy1, n_sx2,n_sy2, x,y) then
      SEEDS[x][y][1].layout_char = "#"
    end
  end end -- for y, x

  if R.kind ~= "hallway" then
    dump_layout(R)
  end

  R.sx1, R.sy1 = n_sx1, n_sy1
  R.sx2, R.sy2 = n_sx2, n_sy2

  R.sw = R.sx2 - R.sx1 + 1
  R.sh = R.sy2 - R.sy1 + 1

  assert(R.sw >= 1 and R.sh >= 1)
end


function Layout_Hallway(R)
  local lx,ly, hx,hy = calc_conn_area(R)

  Junk_fill_room(R, lx,ly, hx,hy)

  -- sometimes make "O" shape
  if rand_odds(20) then
    if R.sw >= 3 and R.sh >= 3 then
      for x = R.sx1+1,R.sx2-1 do for y = R.sy1+1,R.sy2-1 do
        SEEDS[x][y][1].layout_char = "#"
      end end

      return;
    end

---##    -- special check for central pass-through halls
---##    FIXME borken due to junk fill above
---##    if R.sw >= 3 and R.sh >= 3 and R.branch_kind == "PC" then
---##      for x = R.sx1+1,R.sx2-1 do for y = R.sy1+1,R.sy2-1 do
---##        SEEDS[x][y][1].layout_char = "#"
---##      end end
---##
---##      return;
---##    end
  end

  -- TODO: sometimes make "U" shape (for U2, TC, TY)

  -- easy if only one seed wide or tall
  if lx==hx or ly==hy then
    return
  end


  -- block out seeds that don't "trace" from a connection
  local used_x = {}
  local used_y = {}

  for _,C in ipairs(R.conns) do
    local S = C:seed(R)
    if S.conn_dir == 2 or S.conn_dir == 8 then
      used_x[S.sx] = 1
    else
      used_y[S.sy] = 1
    end
  end

  for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
    if not (used_x[x] or used_y[y]) then
      SEEDS[x][y][1].layout_char = "#"
    end
  end end -- for y,x

  -- handle when all connections are parallel
  if table_empty(used_x) then
    local x = int((R.sx1 + R.sx2) / 2)
    for y = R.sy1,R.sy2 do
      SEEDS[x][y][1].layout_char = nil
    end

  elseif table_empty(used_y) then
    local y = int((R.sy1 + R.sy2) / 2)
    for x = R.sx1,R.sx2 do
      SEEDS[x][y][1].layout_char = nil
    end
  end
end


function Ultra_Lame_Layouter(R)
  -- purpose of this function is solely to make a functional
  -- room layout with absolutely no regard (or very little)
  -- to making a pleasing layout.  It's the last resort.

  if #R.h_set == 1 then
    -- easy: no height changes
    for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
      local S = SEEDS[x][y][1]
      if not S.layout_char then
        S.layout_char = '0'
      end
    end end

    return
  end

  -- add the room floor_h if wanted and necessary
  local need_rf
  for index,h in ipairs(R.h_set) do
    if math.abs(h - R.floor_h) < 1 then
      need_rf = string.sub("0123456789", index, index)
      break;
    end
  end
  for _,C in ipairs(R.conns) do
    if math.abs(C.conn_h - R.floor_h) < 1 then
      need_rf = nil
    end
  end

need_rf = false --!!!!

  if need_rf then
    local best_spot
    local best_score = -1

    for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
      local S = SEEDS[x][y][1]
      if not S.layout_char and (x == R.sx1 or x == R.sx2 or y == R.sy1 or y == R.sy2) then
        local score = gui.random()
        local has_nb = false
        for dx = -1,1 do for dy = -1,1 do
          local N = Seed_get_safe(x+dx, y+dy, 1)
          if N and N ~= S and N.room == R then
            if N.layout_char then
              has_nb = true
            else
              score = score + sel(dx==0 or dy==0, 5, 1)
            end
          end
        end end

        if not has_nb then
          score = score + 100
        end

        if score > best_score then
          best_score = score
          best_spot  = { x=x, y=y }
        end
      end
    end end -- for x, y

    assert(best_spot)  -- BAD !!!

    local S = SEEDS[best_spot.x][best_spot.y][1]

    S.layout_char = need_rf
  end

--  dump_layout(R)

  if #R.conns == 1  then
    
  end
  
end


function Layout_Outdoor(R)
  -- FIXME !!!
end


function Layout_Indoor(R)

  local h_set = calc_height_set(R)

  local function char_for_height(set, h)
    for index,h2 in ipairs(set) do
      if math.abs(h - h2) < 1 then
        assert(index <= 10)
        return string.sub("0123456789", index, index)
      end
    end
    error("Height not found in set!!\n")
  end

  local function height_for_char(set, ch)
    if ch == "0" then return set[1] end
    if ch == "1" then return set[2] end
    if ch == "2" then return set[3] end
    if ch == "3" then return set[4] end
    if ch == "4" then return set[5] end
    if ch == "5" then return set[6] end
    if ch == "6" then return set[7] end
    if ch == "7" then return set[8] end
    if ch == "8" then return set[9] end
    if ch == "9" then return set[10] end

    return nil
  end

  local function valid_T(x, y)
    if x < R.tx1 or x > R.tx2 or y < R.ty1 or y > R.ty2 then
      return false
    end
    return true
  end

  local function size_for_symmetry(kind)
    local w, h = R.sw, R.sh

    if kind == "x" or kind == "xy" then
      w = int((w+1) / 2)
    end

    if kind == "y" or kind == "xy" then
      h = int((h+1) / 2)
    end
    
    return w, h
  end

  local function required_seeds(kind)
    -- one seed for each connection
    local count = #R.conns

    -- one seed for each height difference
    -- (with some redundancy, regions may be non-contiguous)
    count = count + #h_set

    if kind == "xy" then
      count = count * 4  -- exaggeration
    
    elseif kind == "x" or kind == "y" then
      count = count * 2
    end

    -- one seed for purpose (key/switch/etc)
    if R.purpose or #R.conns == 0 then
      count = count + 1
    end

    -- one seed for row/column, space for monsters or pillars
    count = count + math.max(R.sw, R.sh)

    return count
  end

  local function is_symmetry_possible(R, sym)
    if sym == "xy" then
      return is_symmetry_possible(R, "x") and
             is_symmetry_possible(R, "y")
    end

    for _,C in ipairs(R.conns) do
      local S = C:seed(R)
      local tx, ty = S.sx, S.sy

      if sym == "x" then
        tx = R.sx1 + R.sx2 - tx
      else -- sym == "y"
        ty = R.sy1 + R.sy2 - ty
      end


      -- basic test: peer seed must be free or have same height
      local T = SEEDS[tx][ty][1]
      if T.conn and T.conn.layout_char ~= C.layout_char then
        return false
      end

      -- strict test: don't put different heights next to each other
      for side = 2,8,2 do
        local nx, ny = nudge_coord(tx, ty, side)
        if R:contains_seed(nx, ny) then
          local N = SEEDS[nx][ny][1]
          if N.conn and N.conn.layout_char ~= C.layout_char then
            return false
          end
        end
      end -- for side

      -- this connection is OK!
    end

    return true
  end

  local function decide_layout_symmetry()

    local SYM_LIST = { "x", "y", "xy" }

    local syms  = { "none" }
    local probs = { 10 }

    for _,sym in ipairs(SYM_LIST) do
      if required_seeds(sym) <= R.sw * R.sh and
         is_symmetry_possible(R, sym)
      then
        local prob = 0

        -- check if possible
        if sym == R.symmetry then
          prob = sel(sym == "xy", 6000, 400)
        elseif R.symmetry == "xy" then
          -- TODO: take width/height into account
          prob = 100
        elseif sym == "xy" and (R.symmetry ~= "x") and (R.symmetry ~= "y") then
          -- never upgrade to XY symmetry from no symmetry
          -- because is_symmetry_possible() does not fully test
          -- the double folding of connections.
          prob = 0
        else
          -- TODO: take width/height into account
          prob = sel(sym == "xy", 20, 40)
        end

        if prob > 0 then
          table.insert(syms, sym)
          table.insert(probs, prob)
        end
      end
    end

    R.layout_symmetry = syms[rand_index_by_probs(probs)]

-- dump_layout(R)

    gui.debugf("Layout symmetry @ %s (%s) --> %s\n",
               R:tostr(), R.symmetry or "none", R.layout_symmetry);

    --- FIXME: update layouting area
  end

  local function clear_layout()
    for x = R.tx1, R.tx2 do for y = R.ty1, R.ty2 do
      SEEDS[x][y][1].layout_char = nil
    end end
  end

  local function try_add_conn(list, S, flip_x, flip_y)
    assert(S.conn and S.conn.layout_char)

    local tx, ty = S.sx, S.sy

    if flip_x then tx = R.tx1 + R.otx2 - tx end
    if flip_y then ty = R.ty1 + R.oty2 - ty end

    if not valid_T(tx, ty) then
      return
    end

-- gui.debugf("  try_add_conn: S @ (%d,%d)  T @ (%d,%d)\n", S.sx,S.sy, tx,ty)
    local T = SEEDS[tx][ty][1]

--  dump_layout(R)

    local INFO =
    {
      group_id = 1 + #list,
      conn  = S.conn,
      T = T, tx = tx, ty = ty,
      layout_char = T.layout_char,
    }

    if T.layout_char then
      assert(T.layout_char == S.conn.layout_char)
    else
      T.layout_char = S.conn.layout_char
      T.group_id    = INFO.group_id
    end

    table.insert(list, INFO)
  end

  local function insert_conns()
gui.debugf("LAYOUT AREA: (%d,%d) .. (%d,%d)\n", R.tx1,R.ty1, R.tx2,R.ty2)
    local list = {}

    for _,C in ipairs(R.conns) do
      local S = C:seed(R)
      
      try_add_conn(list, S, false, false)

      if R.layout_symmetry == "x" then
        try_add_conn(list, S, true, false)
      elseif R.layout_symmetry == "y" then
        try_add_conn(list, S, false, true)
      elseif R.layout_symmetry == "xy" then
        try_add_conn(list, S, false, true)
        try_add_conn(list, S, true,  false)
        try_add_conn(list, S, true,  true)
      end
    end

    return list
  end

  local function read_layout()
    local L = {}

    L.chars = array_2D(R.tx2 - R.tx1 + 1, R.ty2 - R.ty1 + 1)

    for x = R.tx1, R.tx2 do for y = R.ty1, R.ty2 do
      L.chars[x - R.tx1 + 1][y - R.ty1 + 1] = SEEDS[x][y][1].layout_char
    end end

    return L
  end

  local function write_layout(L)
    for x = R.tx1, R.tx2 do for y = R.ty1, R.ty2 do
      local S = SEEDS[x][y][1]

      S.layout_char = L.chars[x - R.tx1 + 1][y - R.ty1 + 1]

      local k = height_for_char(h_set, S.layout_char)

      if k then S.floor_h = k end
    end end
  end


  local function mirror_horizontally(old_w, new_w)
    for y = R.ty1, R.ty2 do
      for x = new_w, old_w-1 do
        local D = SEEDS[R.tx1 + x][y][1]
        local S = SEEDS[R.tx1 + old_w - 1 - x][y][1]

            if S.layout_char == "<" then D.layout_char = ">"
        elseif S.layout_char == ">" then D.layout_char = "<"
        elseif S.layout_char == "L" then D.layout_char = "J"
        elseif S.layout_char == "J" then D.layout_char = "L"
        elseif S.layout_char == "F" then D.layout_char = "T"
        elseif S.layout_char == "T" then D.layout_char = "F"
        elseif S.layout_char == "/" then D.layout_char = "\\"
        elseif S.layout_char =="\\" then D.layout_char = "/"
        else
          D.layout_char = S.layout_char
        end

        D.floor_h = S.floor_h
      end
    end

    -- restore old width
    R.tx2 = R.tx1 + old_w - 1
  end

  local function mirror_vertically(old_h, new_h)
    for x = R.tx1, R.tx2 do
      for y = new_h, old_h-1 do
        local D = SEEDS[x][R.ty1 + y][1]
        local S = SEEDS[x][R.ty1 + old_h - 1 - y][1]

            if S.layout_char == "v" then D.layout_char = "^"
        elseif S.layout_char == "^" then D.layout_char = "v"
        elseif S.layout_char == "L" then D.layout_char = "F"
        elseif S.layout_char == "F" then D.layout_char = "L"
        elseif S.layout_char == "J" then D.layout_char = "T"
        elseif S.layout_char == "T" then D.layout_char = "J"
        elseif S.layout_char == "/" then D.layout_char = "\\"
        elseif S.layout_char =="\\" then D.layout_char = "/"
        else
          D.layout_char = S.layout_char
        end

        D.floor_h = S.floor_h
      end
    end

    -- restore old height
    R.ty2 = R.ty1 + old_h - 1
  end
  

  local function is_fully_connected(EX)
    local g

    for _,E in ipairs(EX) do
      if not g then
        g = E.T.group_id

      elseif g ~= E.T.group_id then
        return false
      end
    end

    return true
  end

  local function merge_groups(EX, id1, id2)
    if id1 > id2 then
      id1,id2 = id2,id1
    end

    for _,E in ipairs(EX) do
      if E.group_id == id2 then
         E.group_id = id1
      end
    end

    for x = R.tx1, R.tx2 do for y = R.ty1, R.ty2 do
      local S = SEEDS[x][y][1]
      if S.group_id == id2 then
         S.group_id = id1
      end
    end end
  end

  local function dist_to_something(x, y, dir)
    local dx, dy = dir_to_delta(dir)
    local dist = 0

    while true do
      x = x + dx
      y = y + dy

      if not valid_T(x, y) then
        return nil
      end

      local T = SEEDS[x][y][1]

      if T.layout_char then
        return dist, T
      end

      dist = dist + 1
    end
  end

  local function try_linear(E, EX, loop)
    local poss_dirs = {}
    local emer_dirs = {}

    for dir = 2,8,2 do
      local nx, ny = nudge_coord(E.tx, E.ty, dir)
      if not valid_T(nx, ny) then
        -- outside of area
      else
        local N = SEEDS[nx][ny][1]

        if not N.layout_char then
          table.insert(poss_dirs, dir)
        elseif N.layout_char == E.T.layout_char and
               assert(N.group_id) ~= E.T.group_id then

          -- direct connection
          merge_groups(EX, N.group_id, E.T.group_id)
          return 0

        elseif N.layout_char ~= E.T.layout_char then
          table.insert(emer_dirs, dir)
        end
      end
    end

--!!!!    assert(#poss_dirs + #emerg_dirs > 0)


    rand_shuffle(poss_dirs)

    if #poss_dirs > 0 then

      local dir = table.remove(poss_dirs, 1)

      local dx, dy = dir_to_delta(dir)

      local x, y = E.tx, E.ty
      gui.debugf("Linear @ %d,%d in direction %d\n", x, y, dir)

      local ds1, T1 = dist_to_something(x, y, dir)
--    local ds2 = dist_to_something(x, y, rotate_cw90(dir))
--    local ds3 = dist_to_something(x, y, rotate_ccw90(dir))

      if T1 and T1.group_id ~= E.T.group_id then
gui.debugf("  something dist=%d\n", ds1);
        if ds1 >= 1 then
          x = x + dx
          y = y + dy

          SEEDS[x][y][1].layout_char = sel(dir==4 or dir==6, ">", "^")
          SEEDS[x][y][1].group_id = E.T.group_id

          ds1 = ds1 - 1
        end

        while ds1 >= 1 do
          x = x + dx
          y = y + dy

          SEEDS[x][y][1].layout_char = T1.layout_char
          SEEDS[x][y][1].group_id    = T1.group_id

          ds1 = ds1 - 1
        end

        merge_groups(EX, T1.group_id, E.T.group_id)

        return 80;
      end

      while true do
        x = x + dx
        y = y + dy

--gui.debugf("  next pos %d,%d\n", x, y);
        if not valid_T(x, y) then
--gui.debugf("  INVALID\n");
          break;
        end

        local T = SEEDS[x][y][1]

        if T.layout_char then
-- gui.debugf("  ALREADY HAS LAYOUT CHAR: %s\n", T.layout_char)
          break;
        end

        T.layout_char = E.T.layout_char
        T.group_id    = E.T.group_id
      end

      return nil -- BLEH
    end


    -- emergency connect

    if #emer_dirs == 0 then
      return nil
    end

    local e_dir = rand_element(emer_dirs)

    local nx, ny = nudge_coord(E.tx, E.ty, e_dir)
    local N = SEEDS[nx][ny][1]

    E.T.emer_stair = e_dir

gui.debugf("Emergency connect\n");
    merge_groups(EX, E.T.group_id, N.group_id)

    return 1000
  end

  local function try_clockwise(E, EX, loop)
    return nil -- FIXME
  end

  local function try_anticlockwise(E, EX, loop)
    return nil -- FIXME
  end

  local function make_basic_layout(EX)
    assert(#EX > 0)

    local cost = 0
    local loop = 0

    EX[1].T.group_id = 1

    while true do
      loop = loop + 1

      gui.debugf("MAKE BASIC LAYOUT loop=%d:\n", loop);
      dump_layout(R)

      if is_fully_connected(EX) then
        break;  -- complete connected now
      end

      local E = rand_element(EX)


      local METHODS =
      {
        CW = 50, ACW = 50, LIN = 200
      }

      local did_cost

      while not table_empty(METHODS) do
        local meth = rand_key_by_probs(METHODS)

        METHODS[meth] = nil -- don't try again this loop

        if meth == "CW" then
          did_cost = try_clockwise(E, EX, loop)
        elseif meth == "ACW" then
          did_cost = try_anticlockwise(E, EX, loop)
        else
          did_cost = try_linear(E, EX, loop)
        end
      end

      if did_cost then
        cost = cost + did_cost
      end
    end

    return cost
  end

  function ensure_mirror_x_traversible()
    for y = R.ty1, R.ty2 do
      if SEEDS[R.tx2][y][1].layout_char then
        return; -- OK
      end
    end

    for y = R.ty1, R.ty2 do
      local did = false
      for x = R.tx1, R.tx2-1 do
        local S = SEEDS[x][y][1]
        local D = SEEDS[x+1][y][1]

        if S.layout_char and not D.layout_char then
          D.layout_char = S.layout_char
          did = true
        end
      end

      if did then return; end
    end

    error("ensure_mirror_x_traversible FAILED!!")
  end

  function ensure_mirror_y_traversible()
    for x = R.tx1, R.tx2 do
      if SEEDS[x][R.ty2][1].layout_char then
        return; -- OK
      end
    end

    for x = R.tx1, R.tx2 do
      local did = false
      for y = R.ty1, R.ty2-1 do
        local S = SEEDS[x][y][1]
        local D = SEEDS[x][y+1][1]

        if S.layout_char and not D.layout_char then
          D.layout_char = S.layout_char
          did = true
        end
      end

      if did then return; end
    end

    error("ensure_mirror_y_traversible FAILED!!")
  end


  ---| Layout_Indoor |---

  for _,C in ipairs(R.conns) do
    C.layout_char = char_for_height(h_set, C.conn_h)
  end

  dump_layout(R);

  decide_layout_symmetry()

  -- update layout area
  local old_w, old_h = box_size(R.tx1, R.ty1, R.tx2, R.ty2)
  local new_w, new_h = size_for_symmetry(R.layout_symmetry)

  R.otx2, R.oty2 = R.tx2, R.ty2

  if new_w < old_w then
    R.tx2 = R.tx1 + new_w - 1
    if (old_w % 2) == 1 then
      R.layout_shared_x = R.tx2
    end
  end

  if new_h < old_h then
    R.ty2 = R.ty1 + new_h - 1
    if (old_h % 2) == 1 then
      R.layout_shared_y = R.ty2
    end
  end

  -- TODO: junk sides


  local best_layout
  local best_cost

  dump_layout(R)

  for i = 1,1 do
    clear_layout()
    local EX = insert_conns()

    local cost = make_basic_layout(EX)

    if not best_layout or cost < best_cost then
      best_layout = read_layout()
      best_cost   = cost
    end
  end

  write_layout(best_layout)

  dump_layout(R);


  if R.layout_symmetry == "x" or R.layout_symmetry == "xy" then
    ensure_mirror_x_traversible()
  dump_layout(R);
  end

  if R.layout_symmetry == "y" or R.layout_symmetry == "xy" then
    ensure_mirror_y_traversible()
  dump_layout(R);
  end



  -- TODO: fill holes
  -- TEMP JUNK !!!
  for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
    local S = SEEDS[x][y][1]
    if not S.layout_char then
      local kkk = rand_irange(1,16)
      S.layout_char = "%" -- string.sub("abcdefghijklmnop", kkk,kkk)
    end
  end end


  -- TODO: boundary shape


  if new_w < old_w then
    mirror_horizontally(old_w, new_w)
  end

  if new_h < old_h then
    mirror_vertically(old_h, new_h)
  end


  gui.debugf("FINAL LAYOUT:\n")
  dump_layout(R);
end


function Room_Layout(R)

  -- set seed range for layouting algorithms to whole room
  R.tx1, R.ty1 = R.sx1, R.sy1
  R.tx2, R.ty2 = R.sx2, R.sy2


  if R.kind == "stairwell" then
    -- nothing to do (handled in builder.lua)
    return

  elseif R.kind == "hallway" then
    Layout_Hallway(R)
    return

  elseif R.outdoor then
    Layout_Outdoor(R)
    return
  end
  
  -- TODO: decide 'special' rooms:
  --       (A) pathway across nukage or lava pit
  --       (B) hallway which surrounds an inner room

  Layout_Indoor(R);


  --[[
  
  -- make rooms with lots of 'junk space' smaller sometimes

  local lx,ly, hx,hy = calc_conn_area(R)

  local jl = lx - R.sx1
  local jr = R.sx2 - hx
  local jb = ly - R.sy1
  local jt = R.sy2 - hy

  local n_sx1 = R.sx1
  local n_sy1 = R.sy1
  local n_sx2 = R.sx2
  local n_sy2 = R.sy2

--!!!  if not R.symmetry or R.symmetry == "y" then
--!!!    while jl >= 2 and rand_odds(99) do jl = jl-1 ; n_sx1 = n_sx1 + 1 end
--!!!    while jl >= 1 and rand_odds( 3) do jl = jl-1 ; n_sx1 = n_sx1 + 1 end
--!!!
--!!!    while jr >= 2 and rand_odds(99) do jr = jr-1 ; n_sx2 = n_sx2 - 1 end
--!!!    while jr >= 1 and rand_odds( 3) do jr = jr-1 ; n_sx2 = n_sx2 - 1 end
--!!!  end
--!!!
--!!!  if not R.symmetry or R.symmetry == "x" then
--!!!    while jb >= 2 and rand_odds(99) do jb = jb-1 ; n_sy1 = n_sy1 + 1 end
--!!!    while jb >= 1 and rand_odds( 3) do jb = jb-1 ; n_sy1 = n_sy1 + 1 end
--!!!
--!!!    while jt >= 2 and rand_odds(99) do jt = jt-1 ; n_sy2 = n_sy2 - 1 end
--!!!    while jt >= 1 and rand_odds( 3) do jt = jt-1 ; n_sy2 = n_sy2 - 1 end
--!!!  end

  Junk_fill_room(R, n_sx1, n_sy1, n_sx2, n_sy2)


  lx,ly, hx,hy = R.sx1,R.sy1, R.sx2,R.sy2


  local function junk_side(side)
    local dx,dy = dir_to_delta(10-side)
    local x1,y1, x2,y2 = side_coords(side, lx,ly, hx,hy)

    for x = x1,x2 do for y = y1,y2 do
      local S = SEEDS[x][y][1]
      if S.layout_char and S.layout_char ~= "%" then
        SEEDS[x+dx][y+dy][1].layout_char = S.layout_char
      end
      if not S.layout_char then
        S.layout_char = "%"
      end
    end end -- for x,y

    if side == 2 then ly = ly + 1 end
    if side == 8 then hy = hy - 1 end
    if side == 4 then lx = lx + 1 end
    if side == 6 then hx = hx - 1 end
  end


  local function try_junk_side(side, opp_sym)

    local long,deep = get_long_deep(side, hx-lx+1, hy-ly+1)

    -- enough room?
    if deep < sel(opp_sym,5,4) then return end

    local dx,dy = dir_to_delta(10-side)
    local x1,y1, x2,y2 = side_coords(side, lx,ly, hx,hy)

    -- side must have connection
    local has_conn = false
    for x = x1,x2 do for y = y1,y2 do
      local S = SEEDS[x][y][1]
      if S.layout_char then
        has_conn = true
        break;
      end
    end end -- for x,y

    if not has_conn then return end

    -- must not be any connections in next row/column
    for x = x1+dx,x2+dx do for y = y1+dy,y2+dy do
      local S = SEEDS[x][y][1]
      if S.layout_char then
        return
      end
    end end -- for x,y

    -- OK !!
    gui.debugf("JUNKED SIDE %d\n", side)

    junk_side(side)

    if opp_sym then
      junk_side(10 - side)
    end

---###    if side == 2 or side == 8 then
---###      if R.symmetry == "y" or R.symmetry == "xy" then
---###        junk_side(10 - side)
---###      end
---###    else -- side == 4 or side == 6
---###      if R.symmetry == "x" or R.symmetry == "xy" then
---###        junk_side(10 - side)
---###      end
---###    end

    if R.symmetry == "tp" then
      local SIDE_MAP = { [2]=4, [4]=2, [6]=8, [8]=6 }
      junk_side(SIDE_MAP[side])
    elseif R.symmetry == "tn" then
      local SIDE_MAP = { [2]=6, [6]=2, [4]=8, [8]=4 }
      junk_side(SIDE_MAP[side])
    end

    dump_layout(R)
  end


  for loop = 1,5 do
    -- TODO: randomise side ordering [make a list]
    
    if not R.symmetry or R.symmetry == "x" or R.symmetry == "y"
                      or R.symmetry == "xy"
    then
      try_junk_side(2, R.symmetry == "y" or R.symmetry == "xy")
      try_junk_side(4, R.symmetry == "x" or R.symmetry == "xy")
    
    elseif R.symmetry == "tn" or R.symmetry == "tp" then
      try_junk_side(2)
      try_junk_side(8)
    end

    if not R.symmetry or R.symmetry == "x" then
      try_junk_side(8)
    end

    if not R.symmetry or R.symmetry == "y" then
      try_junk_side(6)
    end

  end

  --]]

--  gui.debugf("JUNK SPACE W:%d L:%d R:%d  H:%d B:%d T:%d  @ %s\n",
--             R.sw, jl, jr,  R.sh, jb, jt,  R:tostr())

end


function Rooms_II()

  gui.printf("\n--==| Rooms_II |==--\n\n")

  for _,R in ipairs(PLAN.all_rooms) do
    Room_Layout(R)
  end
end

