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

  gui.debugf("Room @ (%d,%d) Layout:\n", R.sx1, R.sy1)

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


function Layout_Hallway(R)
  -- TODO
end

function Layout_Outdoor(R)
  -- TODO
end

function Layout_Room(R)
  R.h_set = calc_height_set(R)

  local function char_for_height(h)
    for index,h2 in ipairs(R.h_set) do
      if math.abs(h - h2) < 1 then
        assert(index <= 10)
        return string.sub("012345abcde", index, index)
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

  if #R.h_set == 1 then
    for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
      local S = SEEDS[x][y][1]
      S.layout_char = char_for_height(R.h_set[1])
    end end
  end

  dump_layout(R)
end


function Rooms_II()

  gui.printf("\n--==| Rooms_II |==--\n\n")

  for _,R in ipairs(PLAN.all_rooms) do
    Layout_Room(R)
  end
end

