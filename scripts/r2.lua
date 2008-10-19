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
  
  if #list < 3 then
    add_height(R.floor_h)
  end

  table.sort(list, function(A,B) return A < B end)

  return list
end


function dump_layout(R)

  local function outside_seed(x, y)
    x = R.sx1 + x - 1
    y = R.sy1 + y - 1
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
    local S = SEEDS[R.sx1 + x-1][R.sy1 + y-1][1]
    assert(S and S.room == R)

    if S.layout_char then
      return S.layout_char
    end

    return "."
  end


  --| dump_layout |--

  gui.debugf("Room %s @ (%d,%d) Layout:\n", R.kind, R.sx1, R.sy1)

  for y = R.sh+1,0,-1 do
    line = ""
    for x = 0,R.sw+1 do
      if box_contains_point(1,1, R.sw,R.sh, x,y) then
        line = line .. inside_seed(x, y)
      else
        line = line .. outside_seed(x, y)
      end
    end
    gui.debugf(" %s\n", line)
  end

  gui.debugf("\n");
end


function Conn_area(R)
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
  local lx,ly, hx,hy = Conn_area(R)

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

  -- easy if only one seed wide/tall
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
      S.layout_char = '0'
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
  -- FIXME
end

function Layout_Room(R)
  R.h_set = calc_height_set(R)

  local function char_for_height(h)
    for index,h2 in ipairs(R.h_set) do
      if math.abs(h - h2) < 1 then
        assert(index <= 10)
        return string.sub("0123456789", index, index)
      end
    end
    error("Height not found in set!!\n")
  end

  if R.kind == "stairwell" then
    -- nothing to do
    return

  elseif R.kind == "hallway" then
    Layout_Hallway(R)
    return

  elseif R.outdoor then
    Layout_Outdoor(R)
    return
  end

  for _,C in ipairs(R.conns) do
    local S = C:seed(R)
    S.layout_char = char_for_height(C.conn_h)
  end

  
  -- make rooms with lots of 'junk space' smaller sometimes

  local lx,ly, hx,hy = Conn_area(R)

  local jl = lx - R.sx1
  local jr = R.sx2 - hx
  local jb = ly - R.sy1
  local jt = R.sy2 - hy

  local n_sx1 = R.sx1
  local n_sy1 = R.sy1
  local n_sx2 = R.sx2
  local n_sy2 = R.sy2

  if not R.symmetry or R.symmetry == "y" then
    while jl >= 2 and rand_odds(99) do jl = jl-1 ; n_sx1 = n_sx1 + 1 end
    while jl >= 1 and rand_odds( 3) do jl = jl-1 ; n_sx1 = n_sx1 + 1 end

    while jr >= 2 and rand_odds(99) do jr = jr-1 ; n_sx2 = n_sx2 - 1 end
    while jr >= 1 and rand_odds( 3) do jr = jr-1 ; n_sx2 = n_sx2 - 1 end
  end

  if not R.symmetry or R.symmetry == "x" then
    while jb >= 2 and rand_odds(99) do jb = jb-1 ; n_sy1 = n_sy1 + 1 end
    while jb >= 1 and rand_odds( 3) do jb = jb-1 ; n_sy1 = n_sy1 + 1 end

    while jt >= 2 and rand_odds(99) do jt = jt-1 ; n_sy2 = n_sy2 - 1 end
    while jt >= 1 and rand_odds( 3) do jt = jt-1 ; n_sy2 = n_sy2 - 1 end
  end

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


  local function try_junk_side(side)
    local long,deep = get_long_deep(side, hx-lx+1, hy-ly+1)

    -- enough room?
    if deep < sel(R.symmetry,5,4) then return end

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

    if side == 2 or side == 8 then
      if R.symmetry == "y" or R.symmetry == "xy" then
        junk_side(10 - side)
      end
    else -- side == 4 or side == 6
      if R.symmetry == "x" or R.symmetry == "xy" then
        junk_side(10 - side)
      end
    end

    dump_layout(R)
  end


  for loop = 1,5 do
    if not R.symmetry or R.symmetry == "x" or R.symmetry == "y"
                      or R.symmetry == "xy"
    then
      try_junk_side(2)
      try_junk_side(4)
    end

    if not R.symmetry or R.symmetry == "x" then
      try_junk_side(8)
    end

    if not R.symmetry or R.symmetry == "y" then
      try_junk_side(6)
    end

  end

--  gui.debugf("JUNK SPACE W:%d L:%d R:%d  H:%d B:%d T:%d  @ %s\n",
--             R.sw, jl, jr,  R.sh, jb, jt,  R:tostr())

  Ultra_Lame_Layouter(R)

end


function Rooms_II()

  gui.printf("\n--==| Rooms_II |==--\n\n")

  for _,R in ipairs(PLAN.all_rooms) do
    Layout_Room(R)
  end
end

