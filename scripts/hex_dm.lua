----------------------------------------------------------------
--  HEXAGONAL DEATH-MATCH
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2013 Andrew Apted
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

class HEXAGON
{
    cx, cy   -- position in cell map

    kind : keyword   -- "free", "thread", "room"
                     -- "edge", "wall"

    content : keyword  -- "START", "WEAPON", ...

    neighbor[HDIR] : HEXAGON   -- neighboring cells
                               -- will be NIL at edge of map
                               -- HDIR is 1 .. 6

    mid_x, mid_y  -- coordinate of mid point

    vertex[HDIR] : { x=#, y=# }  -- leftmost vertex for each edge

    thread : THREAD

    is_branch   -- true if a thread branched off here
}


class THREAD
{
    id : number

    start : HEXAGON   -- starting place (in an existing "room" cell)

    target : HEXAGON  -- ending place (an existing "room" cell)
    target_dir : dir  -- direction OUT of that cell

    pos : HEXAGON  -- last cell "converted" to this thread

    dir : HDIR  -- current direction

    cells : array(HEXAGON)  -- all cells in this thread

    history : array(HDIR)   -- directions to follow from start cell

    grow_prob : number

    limit : number  -- when this reached zero, make a room
}


Directions:
        _______
       /   5   \
      /4       6\
     /           \
     \           /
      \1       3/
       \___2___/


----------------------------------------------------------------]]


-- two dimensional grid / map
--
-- rows with an _even_ Y value are offset to the right:
--
--      1   2   3   4
--    1   2   3   4
--      1   2   3   4
--    1   2   3   4

HEX_MAP = {}

-- these must be odd (for CTF mode)
HEX_W = 15
HEX_H = 49

HEX_MID_X = 0  -- computed later
HEX_MID_Y = 0  --


HEX_LEFT  = { 2, 3, 6, 1, 4, 5 }
HEX_RIGHT = { 4, 1, 2, 5, 6, 3 }
HEX_OPP   = { 6, 5, 4, 3, 2, 1 }
HEX_DIRS  = { 1, 4, 5, 6, 3, 2 }


CTF_MODE = true


HEXAGON_CLASS = {}

function HEXAGON_CLASS.new(cx, cy)
  local C =
  {
    cx = cx
    cy = cy
    kind = "free"
    neighbor = {}
    vertex = {}
  }
  table.set_class(C, HEXAGON_CLASS)
  return C
end


function HEXAGON_CLASS.tostr(C)
  return string.format("CELL[%d,%d]", C.cx, C.cy)
end


function HEXAGON_CLASS.free_neighbors(C)
  local count = 0

  for dir = 1,6 do
    local N = C.neighbor[dir]

    if N and N.kind == "free" then
      count = count + 1
    end
  end

  return count
end


function HEXAGON_CLASS.is_leaf(C)
  local count = 0

  for dir = 1, 6 do
    local N = C.neighbor[dir]

    if N and (N.kind == "room" or N.kind == "thread") then
      count = count + 1
    end
  end

  if CTF_MODE and C.cy == HEX_MID_Y then
    return (count == 0)
  end

  return (count <= 1)
end


function HEXAGON_CLASS.can_join(C, T)
  local hit_room = false

  for i = 1, 6 do
    local N = C.neighbor[i]

    -- a thread cannot join onto itself

    if (N.kind == "room" or N.kind == "thread") and N.thread != T
    then
      hit_room = true
    end
  end

  return hit_room
end


function HEXAGON_CLASS.to_brush(C)
  local brush = {}

  for i = 6, 1, -1 do
    local dir = HEX_DIRS[i]

    local coord =
    {
      x = C.vertex[dir].x
      y = C.vertex[dir].y
    }

    table.insert(brush, coord)
  end

  return brush
end


function HEXAGON_CLASS.build(C)
  
  local f_h = rand.irange(0,6) * 0
  local c_h = rand.irange(4,8) * 32


  if C.kind == "edge" or C.kind == "wall" then --- or C.kind == "free" then
    local w_brush = C:to_brush()

    local w_mat = "ASHWALL4"

    if C.kind == "free" then w_mat = "COMPSPAN" end

    Brush_set_mat(w_brush, w_mat, w_mat)

    brush_helper(w_brush)
  else
    local f_brush = C:to_brush()

--    local f_mat = rand.pick({ "GRAY7", "MFLR8_3", "MFLR8_4", "STARTAN3",
--                              "TEKGREN2", "BROWN1" })

    if C.kind == "free" then
      f_mat = "NUKAGE1"
      f_h   = -16

    elseif C.kind == "room" then
      f_mat = "COMPBLUE"
    else
      f_mat = "GRAY7"
    end

    Brush_add_top(f_brush, f_h)
    Brush_set_mat(f_brush, f_mat, f_mat)

    brush_helper(f_brush)


    local c_brush = C:to_brush()

    Brush_add_bottom(c_brush, 256)
    Brush_mark_sky(c_brush)

    brush_helper(c_brush)
  end


  if C.content == "START" then
    entity_helper("dm_player", C.mid_x, C.mid_y, f_h, {})

    if not LEVEL.has_p1_start then
      entity_helper("player1", C.mid_x, C.mid_y, f_h, {})
      LEVEL.has_p1_start = true
    end
  end

  if C.content == "ENTITY" then
    entity_helper(C.entity, C.mid_x, C.mid_y, f_h, {})
  end
end


----------------------------------------------------------------

H_WIDTH  = 80 + 40
H_HEIGHT = 64 + 32


function Hex_middle_coord(cx, cy)
  local x = H_WIDTH  * (1 + (cx - 1) * 3 + (1 - (cy % 2)) * 1.5)
  local y = H_HEIGHT * cy

  return math.round(x), math.round(y)
end


function Hex_neighbor_pos(cx, cy, dir)
  if dir == 2 then return cx, cy - 2 end
  if dir == 5 then return cx, cy + 2 end

  if (cy % 2) == 0 then
    if dir == 1 then return cx, cy - 1 end
    if dir == 4 then return cx, cy + 1 end
    if dir == 3 then return cx + 1, cy - 1 end
    if dir == 6 then return cx + 1, cy + 1 end
  else
    if dir == 1 then return cx - 1, cy - 1 end
    if dir == 4 then return cx - 1, cy + 1 end
    if dir == 3 then return cx, cy - 1 end
    if dir == 6 then return cx, cy + 1 end
  end
end


function Hex_vertex_coord(C, dir)
  local x, y

  if dir == 1 then
    x = C.mid_x - H_WIDTH / 2
    y = C.mid_y - H_HEIGHT
  elseif dir == 2 then
    x = C.mid_x + H_WIDTH / 2
    y = C.mid_y - H_HEIGHT
  elseif dir == 3 then
    x = C.mid_x + H_WIDTH
    y = C.mid_y
  elseif dir == 4 then
    x = C.mid_x - H_WIDTH
    y = C.mid_y
  elseif dir == 5 then
    x = C.mid_x - H_WIDTH / 2
    y = C.mid_y + H_HEIGHT
  elseif dir == 6 then
    x = C.mid_x + H_WIDTH / 2
    y = C.mid_y + H_HEIGHT
  end

  return math.round(x), math.round(y)
end


function Hex_setup()
  HEX_MAP = table.array_2D(HEX_W, HEX_H)

  HEX_MID_X = int((HEX_W + 1) / 2)
  HEX_MID_Y = int((HEX_H + 1) / 2)

  -- 1. create the hexagon cells

  for cx = 1, HEX_W do
  for cy = 1, HEX_H do
    local C = HEXAGON_CLASS.new(cx, cy)

    C.mid_x, C.mid_y = Hex_middle_coord(cx, cy)

    HEX_MAP[cx][cy] = C
  end
  end

  -- 2. setup neighbor links

  for cx = 1, HEX_W do
  for cy = 1, HEX_H do
    local C = HEX_MAP[cx][cy]

    local far_W = HEX_W - sel(CTF_MODE, (cy % 2), 0)

    for dir = 1,6 do
      local nx, ny = Hex_neighbor_pos(cx, cy, dir)

      if (nx >= 1) and (nx <= far_W) and
         (ny >= 1) and (ny <= HEX_H)
      then
        C.neighbor[dir] = HEX_MAP[nx][ny]
      else
        C.kind = "edge"
      end
    end
  end
  end

  -- 3. setup vertices

  for cx = 1, HEX_W do
  for cy = 1, HEX_H do
    local C = HEX_MAP[cx][cy]
  
    for dir = 1,6 do
      local x, y = Hex_vertex_coord(C, dir)

      C.vertex[dir] = { x=x, y=y }
    end
  end
  end
end


function Hex_starting_area()
  LEVEL.start_cx = HEX_MID_X
  LEVEL.start_cy = HEX_MID_Y

  local C = HEX_MAP[LEVEL.start_cx][LEVEL.start_cy]

  C.kind = "room"
  C.content = "START"


  if CTF_MODE then
    local cx1 = HEX_MID_X - int(HEX_W / 4)
    local cx2 = HEX_MID_X + int(HEX_W / 4)

    if rand.odds(80) then
      -- sometimes remove middle
      if rand.odds(30) then
        C.kind = "free"
        C.content = nil
      end

      C = HEX_MAP[cx1][HEX_MID_Y]
      C.kind = "room"
      C.content = "ENTITY"
      C.entity  = "potion"

      C = HEX_MAP[cx2][HEX_MID_Y]
      C.kind = "room"
      C.content = "ENTITY"
      C.entity  = "potion"
    end
  end
end


function Hex_make_cycles()

  local threads = {}

  local MAX_THREAD = 30
  local total_thread = 0


  local function pick_dir(C)
    local dir_list = {}

    for dir = 1, 6 do
      local N = C.neighbor[dir]

      if CTF_MODE and dir >= 4 then continue end

      if N and N.kind == "free" and N:free_neighbors() == 5 then
        table.insert(dir_list, dir)
      end
    end

    if #dir_list == 0 then
      return nil
    end

    return rand.pick(dir_list)
  end


  local function pick_start()
    local list = {}

    -- collect all possible starting cells

    for cx = 1, HEX_W do
    for cy = 1, sel(CTF_MODE, HEX_MID_Y, HEX_H) do
      local C = HEX_MAP[cx][cy]

      if C.no_start then continue end

      if not (C.kind == "room" or
              (C.kind == "thread" and C.thread.dead))
      then continue end

      if C:free_neighbors() < 3 then continue end

      table.insert(list, C)
    end
    end

    while #list > 0 do
      local idx = rand.irange(1, #list)

      local C = table.remove(list, idx)

      local dir = pick_dir(C)

      if dir then
        return C, dir  -- success
      end

      -- never try this cell again
      C.no_start = true
    end

    return nil  -- fail
  end


  local function do_grow_thread(T, dir, N)
    N.kind = "thread"
    N.thread = T

    T.pos = N
    T.dir = dir

    table.insert(T.cells, N)
    table.insert(T.history, dir)
  end


  local function new_thread(start)
    return
    {
      id = Plan_alloc_id("hex_thread")

      start = start

      cells   = { }
      history = { }

      grow_dirs = rand.sel(50, { 2,3,4 }, { 4,3,2 })
      grow_prob = rand.pick({ 40, 60, 80 })

      limit = rand.irange(16, 48)
    }
  end


  local function add_thread()
    -- reached thread limit ?
    if total_thread >= MAX_THREAD then return end


    local start, dir = pick_start()

    if not start then return end

    local C1 = start.neighbor[dir]

    C1.is_branch = true


    local THREAD = new_thread(start)

    table.insert(threads, THREAD)

    do_grow_thread(THREAD, dir, C1)

    total_thread = total_thread + 1
  end


  local function respawn_thread(T)
    -- create a new thread which continues on where T left off

    local THREAD = new_thread(T.pos)

    THREAD.pos = T.pos
    THREAD.dir = T.dir

    table.insert(threads, THREAD)

    THREAD.pos.is_branch = true

    -- less quota for this thread
    total_thread = total_thread + 0.4

    return true
  end


  local function try_grow_thread_in_dir(T, dir)
    local N = T.pos.neighbor[dir]
    assert(N)

    if N.kind != "free" then return false end

    if CTF_MODE and N.cy >= HEX_MID_Y then return false end

    if N:free_neighbors() == 5 then
      do_grow_thread(T, dir, N)
      return true
    end

    if #T.history > 7 and N:can_join(T) then
      do_grow_thread(T, dir, N)

      T.target = N.neighbor[dir]
      T.target_dir = dir

      T.dead = true
      return true
    end

    return false
  end


  local function grow_a_thread(T)
    if T.limit <= 0 then
      -- turn into a room when reached the end
      T.pos.kind = "room"

      T.dead = true

      -- debug crud...
      T.pos.content = "ENTITY"
      T.pos.entity  = "evil_eye"

      -- continue sometimes...
      if rand.odds(25) then
        respawn_thread(T)
      end

      return
    end

    T.limit = T.limit - 1


    local dir_L = HEX_LEFT [T.dir]
    local dir_R = HEX_RIGHT[T.dir]

    local check_dirs = {}
    
    check_dirs[dir_L] = T.grow_dirs[1]
    check_dirs[T.dir] = T.grow_dirs[2]
    check_dirs[dir_R] = T.grow_dirs[3]

    local tc = #T.history

    -- prevent too many steps in the same direction
    if tc >= 2 and T.history[tc] == T.history[tc - 1] then
      local d = T.history[tc]
      assert(check_dirs[d])

      if tc >= 3 and T.history[tc] == T.history[tc - 2] then
        check_dirs[d] = nil
      else
        check_dirs[d] = check_dirs[d] / 3
      end
    end

    while not table.empty(check_dirs) do
      local dir = rand.key_by_probs(check_dirs)
      check_dirs[dir] = nil

      if try_grow_thread_in_dir(T, dir) then
        return -- OK
      end
    end

    -- no direction was possible

    T.dead = true
  end


  local function grow_threads()
    for index = #threads, 1, -1 do
      
      local T = threads[index]

      if rand.odds(T.grow_prob) then
        grow_a_thread(T)

        if T.dead then
          table.remove(threads, index)
        end
      end

    end  -- index
  end


  ---| Hex_make_cycles |---

  add_thread()
  
  if rand.odds(60) then add_thread() end
  if rand.odds(60) then add_thread() end

  -- loop until all threads are dead

  while #threads > 0 do
    
    grow_threads()
    grow_threads()
    grow_threads()

    if #threads == 0 or  rand.odds(2) then add_thread() end
    if #threads == 1 and rand.odds(5) then add_thread() end

  end
end


function Hex_trim_leaves()
  
  local function trim_pass()
    local changes = 0

    for cx = 1, HEX_W do
    for cy = 1, HEX_H do
      local C = HEX_MAP[cx][cy]

      if not (C.kind == "room" or C.kind == "thread") then
        continue
      end

      if C:is_leaf() then
      
        C.kind = "wall"
        C.content = nil

        changes = changes + 1
      end
   end
   end

   return changes > 0
 end


 ---| Hex_trim_leaves |---

 while trim_pass() do
  -- keep going until all nothing changes
 end
end


function Hex_mirror_map()
  for cx = 1, HEX_W do
  for cy = 1, HEX_MID_Y - 1 do
    local C = HEX_MAP[cx][cy]

    local dx = (HEX_W - cx) + (cy % 2)
    local dy = (HEX_H - cy) + 1

    if dx < 1 then continue end

    local D = HEX_MAP[dx][dy]

    D.kind = C.kind
  end
  end
end


function Hex_build_all()
  for cx = 1, HEX_W do
  for cy = 1, HEX_H do
    local C = HEX_MAP[cx][cy]

    C:build()
  end
  end
end


function Hex_create_level()
  LEVEL.sky_light = 192
  LEVEL.sky_shade = 160

  Hex_setup()
  Hex_starting_area()

  Hex_make_cycles()
  Hex_trim_leaves()

  if CTF_MODE then
    Hex_mirror_map()
  end

  Hex_build_all()
end

