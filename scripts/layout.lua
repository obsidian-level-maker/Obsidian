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
      if T ~= S and T.conn then
        if math.abs(T.conn.conn_h - C.conn_h) > 1 then
          return false
        end
      end

      -- strict test: don't put different heights next to each other
      for side = 2,8,2 do
        local nx, ny = nudge_coord(tx, ty, side)
        if R:contains_seed(nx, ny) then
          local N = SEEDS[nx][ny][1]
          if N ~= S and N.conn then
            if math.abs(N.conn.conn_h - C.conn_h) > 1 then
              return false
            end
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
      if required_seeds(sym) <= R.sw * R.sh then
        local prob = 0

        -- check if possible
        if sym == R.symmetry then
          prob = sel(sym == "xy", 6000, 400)
        elseif R.symmetry == "xy" then
          prob = 100
        elseif is_symmetry_possible(R, sym) then
          prob = sel(sym == "xy", 10, 40)
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


  ---| Layout_Indoor |---

  for _,C in ipairs(R.conns) do
    C.layout_char = char_for_height(h_set, C.conn_h)
  end


  decide_layout_symmetry()

  
  -- ETC ETC....

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

