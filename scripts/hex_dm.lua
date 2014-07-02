------------------------------------------------------------------------
--  HEXAGONAL DEATH-MATCH / CTF
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2013-2014 Andrew Apted
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
------------------------------------------------------------------------

--[[ *** CLASS INFORMATION ***

class HEXAGON
{
    cx, cy   -- position in cell map

    kind : keyword   -- "free", "used"
                     -- "edge", "solid", "dead"

    neighbor[HDIR] : HEXAGON   -- neighboring cells
                               -- will be NIL at edge of map
                               -- HDIR is 1 .. 6

    content : CONTENT      -- what to make in middle of cell

    border[HDIR] : BORDER  -- what to make on edge of cell
    corner[HDIR] : BORDER  -- these corners are ON THE OUTSIDE

    mid_x, mid_y  -- coordinate of mid point

    vertex[HDIR] : { x=#, y=# }  -- leftmost vertex for each edge

    wall_vert[HDIR] : { x=#, y=# }
     mid_vert[HDIR] : { x=#, y=# }

    path[HDIR] : HEXAGON  -- forms a cyclical pathway around the map

    peer : HEXAGON  -- in CTF mode, this is the cell on opposite
                    -- side of the map

    thread : THREAD

    is_branch   -- true if a thread branched off here

    dist[keyword]   -- distance to various stuff (e.g. "wall")
}


class THREAD
{
    id : number

    start : HEXAGON   -- starting place (in an existing "used" cell)

    pos : HEXAGON  -- last cell 'converted' to this thread

    dir : HDIR  -- current direction

    cells : array(HEXAGON)  -- all cells in this thread

    history : array(HDIR)   -- directions to follow from start cell

    grow_prob : number

    limit : number  -- when this reached zero, make a room
}


class ROOM
{
    id : number  -- normally > 0, negative for a mirrored room

    cells : list(HEXAGON)

    peer : ROOM   -- opposite room when level is mirrored (CTF)

    flag_room : boolean

    base : keyword  -- "red" or "blue" if part of a team's base
                    -- unset for the neutral zone

    kind : keyword  -- "building", "cave", "outdoors"
    is_outdoor : boolean  -- true for outdoor room

     wall_mat : string  -- texturing for this room
    floor_mat : string  --
     ceil_mat : string  --

    floor_h : number  -- floor height

    walk_neighbors : list(ROOM)
}


class BORDER
{
    kind : keyword  -- "wall", "fence", "step"

     wall_mat : string  --
    floor_mat : string  -- texturing info
     ceil_mat : string  --

    floor_h : number  -- height for the fence or step

    ceil_h  : number
}


class CONTENT
{
    kind : keyword  -- "START", "WEAPON", "ENTITY", etc...

    entity : name

    team : keyword  -- "red" or "blue"  (for FLAG and START)
                    -- not used for DM maps

    no_mirror : boolean  -- do not mirror this
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

HEX_CELLS = {}

-- these must be odd (for CTF mode)
HEX_W = 15
HEX_H = 49

HEX_MID_X = 0  -- computed later
HEX_MID_Y = 0  --


HEX_LEFT  = { 2, 3, 6, 1, 4, 5 }
HEX_RIGHT = { 4, 1, 2, 5, 6, 3 }
HEX_OPP   = { 6, 5, 4, 3, 2, 1 }
HEX_DIRS  = { 1, 4, 5, 6, 3, 2 }


HEXAGON_CLASS = {}

function HEXAGON_CLASS.new(cx, cy)
  local C =
  {
    cx = cx
    cy = cy

    kind = "free"

    neighbor = {}
    vertex = {}
    wall_vert = {}
    mid_vert = {}

    border = {}
    corner = {}
    path = {}
    dist = {}

    random1 = gui.random()
    random2 = gui.random()
  }
  table.set_class(C, HEXAGON_CLASS)
  return C
end


function HEXAGON_CLASS.tostr(C)
  return string.format("CELL[%d,%d]", C.cx, C.cy)
end


function HEXAGON_CLASS.is_active(C)
  if not C.thread then return false end

  return not C.thread.dead
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

    if C.path[dir] then count = count + 1 end
  end

  if LEVEL.CTF and C.cy == HEX_MID_Y then
    return (count == 0)
  end

  return (count <= 1)
end


function HEXAGON_CLASS.trim(C)
  C.kind = "free"
  C.content = nil
  C.trimmed = true

  -- we keep C.thread

  -- handle path links
  for dir = 1, 6 do
    local N = C.path[dir]

    if N then
      N.path[HEX_OPP[dir]] = nil
    end
  end

  C.path = {}
end


function HEXAGON_CLASS.can_join(C, T)
  local hit_dir

  for dir = 1, 6 do
    local N = C.neighbor[dir]

    -- a thread cannot join onto itself

    if N.kind == "used" and N.thread != T then
      hit_dir = dir
    end
  end

  return hit_dir
end


function HEXAGON_CLASS.used_dist_from_neighbors(C)
  local dist

  for i = 1, 6 do
    local N = C.neighbor[i]

    if N and N.dist.used and (N.dist.used < (dist or 999)) then
      dist = N.dist.used
    end
  end
  
  return dist
end


function HEXAGON_CLASS.touches_edge(C)
  for dir = 1, 6 do
    local N = C.neighbor[dir]

    if not N or N.kind == "edge" then
      return true
    end
  end
 
  return false
end


function HEXAGON_CLASS.can_travel_in_dir(C, dir)
  local N = C.neighbor[dir]

  if not (N and N.room) then return false end

  if C.path[dir] then return true end
  
  if N.room != C.room then return false end

  return true
end


function HEXAGON_CLASS.near_wall(C)
  for dir = 1, 6 do
    if not C:can_travel_in_dir(dir) then
      return true
    end
  end

  return false
end


function HEXAGON_CLASS.get_brush(C)
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


function HEXAGON_CLASS.get_small_brush(C)
  local brush = {}

  for i = 6, 1, -1 do
    local dir = HEX_DIRS[i]

    local coord =
    {
      x = C.mid_vert[dir].x
      y = C.mid_vert[dir].y
    }

    table.insert(brush, coord)
  end

  return brush
end


function HEXAGON_CLASS.get_wall_brush(C, dir)
  local dir2 = HEX_RIGHT[dir]

  local brush = {}

  table.insert(brush, table.copy(C.wall_vert[dir]))
  table.insert(brush, table.copy(C.wall_vert[dir2]))
  table.insert(brush, table.copy(C.vertex[dir2]))
  table.insert(brush, table.copy(C.vertex[dir]))

  return brush
end


function HEXAGON_CLASS.get_corner_brush(C, dir)
  local dir2 = HEX_LEFT[dir]

  local A = C.neighbor[dir2]
  local B = C.neighbor[dir]

  if not A or not B then
    error("get_corner_brush: bad cell")
  end

  local dir3 = HEX_LEFT [HEX_LEFT [dir]]
  local dir4 = HEX_RIGHT[HEX_RIGHT[dir]]

  local brush = {}

  table.insert(brush, table.copy(C.vertex[dir]))
  table.insert(brush, table.copy(B.wall_vert[dir3]))
  table.insert(brush, table.copy(A.wall_vert[dir4]))

  return brush
end


function HEXAGON_CLASS.build_floor(C, f_h, mat)
  -- for lighting system we subdivide the cell into a small hexagon
  -- and six trapezoids...

  local m_brush = C:get_small_brush(C)
  
  brushlib.add_top(m_brush, f_h)
  brushlib.set_mat(m_brush, mat, mat)

  Trans.brush(m_brush)

  for i = 1, 6 do
    local k = HEX_LEFT[i]

    local brush =
    {
      table.copy(C.mid_vert[i])
      table.copy(C.vertex  [i])
      table.copy(C.vertex  [k])
      table.copy(C.mid_vert[k])
    }

    brushlib.add_top(brush, f_h)
    brushlib.set_mat(brush, mat, mat)

    Trans.brush(brush)
  end
end


function HEXAGON_CLASS.build_border(C, coords, B)
  if B.kind == "nothing" then
    return
  end

  if B.kind == "wall" then
    brushlib.set_mat(coords, B.wall_mat, B.wall_mat)

    Trans.brush(coords)
  end

  if B.kind == "fence" or B.kind == "step" then
    assert(B.floor_h)

    brushlib.add_top(coords, B.floor_h)
    brushlib.set_mat(coords, B.floor_mat, B.floor_mat)

    Trans.brush(coords)
  end
end


function HEXAGON_CLASS.build_wall(C, dir)
  local B = C.border[dir]

  if not B then return end

  local brush = C:get_wall_brush(dir)

  C:build_border(brush, B)
end


function HEXAGON_CLASS.build_corner(C, dir)
  local B = C.corner[dir]

  if not B then return end

  local brush = C:get_corner_brush(dir)

  C:build_border(brush, B)
end


function HEXAGON_CLASS.debug_path(C, dir)
  if not C.path[dir] then return end

  local dir2 = HEX_RIGHT[dir]

  local x = (C.vertex[dir].x + C.vertex[dir2].x) * 0.35 + C.mid_x * 0.3
  local y = (C.vertex[dir].y + C.vertex[dir2].y) * 0.35 + C.mid_y * 0.3

  Trans.entity("lamp", x, y, 0)
end


function HEXAGON_CLASS.build_content(C)
  local content = C.content

  local f_h = C.room.floor_h or 0

  if content.kind == "START" then
    local ent = "dm_player"
    if content.team then
      ent = "ctf_" .. content.team .. "_start"
    end
    Trans.entity(ent, C.mid_x, C.mid_y, f_h, { angle=content.angle })
  end

  if content.kind == "FLAG" then
    assert(content.team)

    -- simple pedestal
    local brush = C:get_small_brush()
    brushlib.add_top(brush, f_h + 12)
    brushlib.set_mat(brush, "COMPSPAN", "COMPSPAN")
    Trans.brush(brush)

    local ent = "ctf_" .. content.team .. "_flag"
    Trans.entity(ent, C.mid_x, C.mid_y, f_h + 12, { light=224 })
  end

  if content.kind == "ENTITY" or
     content.kind == "WEAPON"
  then
    -- FIXME: prefab for weapons
    Trans.entity(content.entity, C.mid_x, C.mid_y, f_h, { angle=content.angle, light=160 })
  end
end


function HEXAGON_CLASS.build(C)
  
  for dir = 1, 6 do
    C:build_corner(dir)
  end


  if C.kind == "edge" or C.kind == "solid" or C.kind == "dead" then
    local w_brush = C:get_brush()

    local w_mat = "ASHWALL4"

    brushlib.set_mat(w_brush, w_mat, w_mat)

    Trans.brush(w_brush)
    return
  end


  local R = assert(C.room)


  -- floor --

  local f_h = C.room.floor_h

  assert(f_h)

  C:build_floor(f_h, R.floor_mat)


  -- ceiling --

  local c_h = f_h + 160

  if R.is_outdoor then
    c_h = LEVEL.sky_h
  end

  local c_brush = C:get_brush()

  brushlib.add_bottom(c_brush, c_h)

  if R.is_outdoor then
    brushlib.mark_sky(c_brush)
  else
    brushlib.set_mat(c_brush, R.wall_mat, R.ceil_mat)
  end

  Trans.brush(c_brush)


  -- walls --

  for dir = 1, 6 do
    C:build_wall(dir)
  end


  -- content --

  if C.content then
    C:build_content(C)
  end
end


----------------------------------------------------------------


HEX_ROOM_CLASS = {}

function HEX_ROOM_CLASS.new()
  local R =
  {
    id = Plan_alloc_id("hex_room")

    cells = {}
  }
  table.set_class(R, HEX_ROOM_CLASS)
  return R
end


function HEX_ROOM_CLASS.copy(R)
  -- does not copy 'id' or the 'cells' list

  local R2 = HEX_ROOM_CLASS.new()

  R2.floor_h   = R.floor_h
  R2.flag_room = R.flag_room

  return R2
end


function HEX_ROOM_CLASS.tostr(R)
assert(R.id)
  if R.id < 0 then
    return string.format("MIRROR_%d", 0 - R.id)
  else
    return string.format("ROOM_%d", R.id)
  end
end


function HEX_ROOM_CLASS.add_cell(R, C)
  C.room = R

  table.insert(R.cells, C)
end


function HEX_ROOM_CLASS.kill(R)
  each C in R.cells do
    C.kind = "dead"
    C.room = nil
  end

  R.dead  = true
  R.cells = {}
end


function HEX_ROOM_CLASS.merge(R, old)
  assert(not R.dead)

  each C in old.cells do
    R:add_cell(C)
  end

  old.dead  = true
  old.cells = {}
end


function HEX_ROOM_CLASS.calc_bbox(R)
  each C in R.cells do
    R.min_cx = math.min(R.min_cx or 999, C.cx)
    R.min_cy = math.min(R.min_cy or 999, C.cy)

    R.max_cx = math.max(R.max_cx or 0, C.cx)
    R.max_cy = math.max(R.max_cy or 0, C.cy)
  end
end


function HEX_ROOM_CLASS.dump_cells(R)
  stderrf("Cells for %s :\n", R:tostr())
  stderrf("{\n")

  each C in R.cells do
    stderrf("  %s\n", C:tostr())
  end

  stderrf("}\n")
end


function HEX_ROOM_CLASS.dump_bbox(R)
  if R.min_cx then
    stderrf("bbox for %s : NONE!\n", R:tostr())
  else
    stderrf("bbox for %s : (%d %d) .. (%d %d)\n",
             R:tostr(), R.min_cx, R.min_cy, R.max_cx, R.max_cy)
  end
end


function HEX_ROOM_CLASS.find_walk_neighbors(R)
  R.walk_neighbors = {}

  each C in R.cells do
    for dir = 1, 6 do
      local N = C.path[dir]

      if N and N.room != R then
        table.add_unique(R.walk_neighbors, N.room)
      end
    end
  end

  assert(not table.empty(R.walk_neighbors))
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

  return
  {
    x = math.round(x)
    y = math.round(y)
  }
end


function Hex_vertex_along(C, dir, along)
  local x = C.vertex[dir].x
  local y = C.vertex[dir].y

  return
  {
    x = math.round(x * along + C.mid_x * (1 - along))
    y = math.round(y * along + C.mid_y * (1 - along))
  }
end



function Hex_setup()
  HEX_CELLS = table.array_2D(HEX_W, HEX_H)

  HEX_MID_X = int((HEX_W + 1) / 2)
  HEX_MID_Y = int((HEX_H + 1) / 2)

  -- 1. create the hexagon cells

  for cx = 1, HEX_W do
  for cy = 1, HEX_H do
    local C = HEXAGON_CLASS.new(cx, cy)

    C.mid_x, C.mid_y = Hex_middle_coord(cx, cy)

    HEX_CELLS[cx][cy] = C
  end
  end

  -- 2. setup neighbor links

  for cx = 1, HEX_W do
  for cy = 1, HEX_H do
    local C = HEX_CELLS[cx][cy]

    local far_W = HEX_W - sel(LEVEL.CTF, (cy % 2), 0)

    for dir = 1,6 do
      local nx, ny = Hex_neighbor_pos(cx, cy, dir)

      if (nx >= 1) and (nx <= far_W) and
         (ny >= 1) and (ny <= HEX_H)
      then
        C.neighbor[dir] = HEX_CELLS[nx][ny]
      else
        C.kind = "edge"
      end
    end
  end
  end

  -- 3. setup vertices

  for cx = 1, HEX_W do
  for cy = 1, HEX_H do
    local C = HEX_CELLS[cx][cy]
  
    for dir = 1,6 do
      C.vertex[dir] = Hex_vertex_coord(C, dir)

      C.wall_vert[dir] = Hex_vertex_along(C, dir, 0.75)
      C. mid_vert[dir] = Hex_vertex_along(C, dir, 0.50)
    end
  end
  end

  -- 4. reset other stuff

  LEVEL.areas = {}
  LEVEL.rooms = {}
  LEVEL.scenic_rooms = {}

  collectgarbage()
end



function Hex_starting_area()
  LEVEL.start_cx = HEX_MID_X
  LEVEL.start_cy = HEX_MID_Y

  local C = HEX_CELLS[LEVEL.start_cx][LEVEL.start_cy]

  C.kind = "used"


  if LEVEL.CTF then
    local cx1 = HEX_MID_X - int(HEX_W / 4)
    local cx2 = HEX_MID_X + int(HEX_W / 4)

    if rand.odds(80) then
      -- sometimes remove middle
      if rand.odds(30) then
        C.kind = "free"
      end

      local C1, C2

      C1 = HEX_CELLS[cx1][HEX_MID_Y]
      C1.kind = "used"

      C2 = HEX_CELLS[cx2][HEX_MID_Y]
      C2.kind = "used"

      C1.peer = C2
      C2.peer = C1
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

      if LEVEL.CTF and dir >= 4 then continue end

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
    for cy = 1, sel(LEVEL.CTF, HEX_MID_Y, HEX_H) do
      local C = HEX_CELLS[cx][cy]

      if C.no_start then continue end

      if not (C.kind == "used" and not C:is_active()) then
        continue
      end

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
    N.kind = "used"
    N.thread = T

    -- update 'path' links
    local B = assert(T.pos)

    B.path[dir] = N
    N.path[HEX_OPP[dir]] = B

    -- update the thread itself
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

    THREAD.pos = start

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


  local function join_thread(T, dir, N, hit_dir)
    do_grow_thread(T, dir, N)

    local N2 = N.neighbor[hit_dir]

    N .path[hit_dir] = N2
    N2.path[HEX_OPP[hit_dir]] = N

    T.dead = true
  end


  local function try_grow_thread_in_dir(T, dir)
    local N = T.pos.neighbor[dir]
    assert(N)

    if N.kind != "free" then return false end

    if LEVEL.CTF and N.cy >= HEX_MID_Y then return false end

    if N:free_neighbors() == 5 then
      do_grow_thread(T, dir, N)
      return true
    end

    if #T.history > 7 then
      local hit_dir = N:can_join(T)

      if hit_dir then
        join_thread(T, dir, N, hit_dir)
        return true
      end
    end

    return false
  end


  local function grow_a_thread(T)
    if T.limit <= 0 then
      T.dead = true

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
      local C = HEX_CELLS[cx][cy]

      if C.kind != "used" then
        continue
      end

      if C:is_leaf() then
        C:trim()

        changes = changes + 1
      end
    end
    end
 
    return (changes > 0)
  end


  ---| Hex_trim_leaves |---

  while trim_pass() do
    -- keep going until all nothing changes
  end
end



function Hex_check_map_is_valid()

  local function size_check()
    local cx_min, cx_max = 999, -999
    local cy_min, cy_max = 999, -999

    local count = 0

    for cx = 1, HEX_W do
    for cy = 1, HEX_H do
      local C = HEX_CELLS[cx][cy]

      if C.kind == "used" then
        count = count + 1

        cx_min = math.min(cx, cx_min)
        cy_min = math.min(cy, cy_min)

        cx_max = math.max(cx, cx_max)
        cy_max = math.max(cy, cy_max)
      end
    end
    end

    count = count / (HEX_W * HEX_H)

    local width  = (cx_max - cx_min + 1) / HEX_W
    local height = (cy_max - cy_min + 1) / HEX_H

    if LEVEL.CTF then
      count  = count * 2
      height = height * 2
    end

    gui.debugf("Volume: %1.3f  width: %1.2f  height: %1.2f\n", count, width, height)

    -- Note: no check on volume

    if width < 0.6 or height < 0.6 then
      return false
    end

    return true  -- OK
  end


  local function grow_contiguity(C, seen)
    C.contiguous = true 

    seen[C] = 1

    for dir = 1, 6 do
      local N = C.path[dir]

      if N and not seen[N] then
        grow_contiguity(N, seen)
      end
    end
  end


  local function contiguous_check()
    -- pick start cell
    local start

    for cx = 1, HEX_W do
      local C = HEX_CELLS[cx][HEX_MID_Y]

      if C.kind == "used" then
        start = C
        break
      end
    end

    assert(start)

    local seen = {}

    -- recursively spread the 'contiguous' flag
    grow_contiguity(start, seen)

    for cx = 1, HEX_W do
    for cy = 1, HEX_MID_Y do
      local C = HEX_CELLS[cx][cy]
      
      if C.kind == "used" and not C.contiguous then
        return false
      end
    end
    end

    return true  -- OK
  end


  ---| Hex_check_map_is_valid |---

  if not size_check() then
    gui.printf("Size test failed, retrying...\n")
    return false
  end

  if LEVEL.CTF then
    -- ensure the starting cells survived

    for cx = 1, HEX_W do
      local C = HEX_CELLS[cx][HEX_MID_Y]

      if C.trimmed then
        gui.printf("Blocked starting cells, retrying...\n")
        return false
      end
    end
  end

  if LEVEL.CTF and not contiguous_check() then
    gui.printf("Contiguous test failed, retrying...\n")
    return false
  end

  gui.printf("Plan validated as OK\n\n")

  return true
end



function Hex_plan()
  -- keep trying until a plan comes together
  -- (mainly for CTF mode, which sometimes fails)

  repeat
    Hex_setup()
    Hex_starting_area()

    Hex_make_cycles()
    Hex_trim_leaves()

  until Hex_check_map_is_valid()
end


----------------------------------------------------------------


function Hex_kill_unused_rooms(list)

  -- remove rooms which don't contain a planned pathway

  local function is_room_used(R)
    each C in R.cells do
      if C.kind == "used" then return true end
    end

    return false
  end

  ---| Hex_kill_unused_rooms |---

  for idx = #list, 1, -1 do
    local R = list[idx]

    if not is_room_used(R) then
      -- TODO: turn into a LAKE (sometimes)
      R:kill()
      table.remove(list, idx)
    end
  end
end



function Hex_merge_rooms(room_list)
  --
  -- Rooms which are too small get merged into a neighboring room.
  --

  local MIN_ROOM_SIZE = 8


  local function neighbor_for_merge(R)
    local best

    each C in R.cells do
      for dir = 1, 6 do
        local N = C.neighbor[dir]

        if not (N and N.room) then continue end

        local R2 = N.room

        if (R2 == R) or (R2 == best) then continue end

        if not best then
          best = R2
          continue
        end

        -- pick the smallest neighbor
        if #R2.cells > #best.cells then continue end

        if #R2.cells == #best.cells and rand.odds(50) then continue end

        best = R2
      end
    end

    -- best can be NIL, this only happens in CTF mode with rooms on the middle row
    -- and near the far left / right edges.  Such a room will be removed.

    return best
  end


  local function merge_rooms()

    for idx = #room_list, 1, -1 do
      local R = room_list[idx]

      assert(not R.dead)

      if R.flag_room then continue end

      if #R.cells >= MIN_ROOM_SIZE then continue end

      local N = neighbor_for_merge(R)

      if N then
        N:merge(R)
      else
        R:kill()
      end

      table.remove(room_list, idx)
    end
  end


  ---| Hex_merge_rooms |---

  for loop = 1, 2 do
    merge_rooms()
  end
end



function Hex_add_rooms_DM()
  --
  -- Algorithm:
  --
  --   1. spawn "seed" rooms around the usable map area.  Each one
  --      will be _TWO_ hexagonal cells.
  --
  --   2. find all places where a unused cell can "grow" -- it needs
  --      two neighbors of the same room to become part of that room.
  --
  --   3. repeat step 2 until the whole map is filled.
  --
  --   4. ensure rooms are of a minimum size by merging tiny rooms
  --      with a neighboring room.
  --
  local room_list = {}

  local top_H = sel(LEVEL.CTF, HEX_MID_Y, HEX_H)


  local function new_room()
    local ROOM = HEX_ROOM_CLASS.new()
    ROOM.grow_prob = rand.pick({ 10, 20, 40, 80 })
    table.insert(room_list, ROOM)
    return ROOM
  end

  
  local function fungible_cell(C)
    if C.kind == "edge" then return false end
    if C.room then return false end

    return true
  end


  local function num_fungible_cells()
    local count = 0

    for cx = 1, HEX_W do
    for cy = 1, top_H do
      local C = HEX_CELLS[cx][cy]

      if fungible_cell(C) then
        count = count + 1
      end
    end
    end

    return count
  end


  local function test_spot_for_seed(cx, cy, dir)
    local C = HEX_CELLS[cx][cy]

    local N = C.neighbor[dir]

    return (N and fungible_cell(N))
  end


  local function add_room_seed(required)
    -- pick spot
    local MAX_LOOP = 8000

    for loop = 1, MAX_LOOP do
      local cx = rand.irange(2, HEX_W - 1)
      local cy = rand.irange(2, top_H - 1)

      local C = HEX_CELLS[cx][cy]

      if not fungible_cell(C) then continue end

      -- require cell be on the path (unless we are getting desperate)
      if loop < 200 and C.kind != "used" then continue end

      for pass = 1,4 do
        local dir = rand.irange(1, 6)

        local N = C.neighbor[dir]

        if N and fungible_cell(N) then
          -- found a usable spot!
          local R = new_room()
          R:add_cell(C)
          R:add_cell(N)
          return
        end

      end  -- pass
    end  -- loop

    if required then
      error("Failed to add an initial room")
    end
  end


  local function initial_rooms()
    -- decide number of starting rooms
    local quota = num_fungible_cells()

    quota = quota / rand.pick({ 8, 12, 16 }) + 1
    quota = rand.int(quota)

    gui.printf("Room quota: %d\n", quota)

    for i = 1, quota do
      add_room_seed(i <= 4)
    end
  end


  local function collect_possible_buds()
    local list = {}

    for cx = 1, HEX_W do
    for cy = 1, top_H do
      local C = HEX_CELLS[cx][cy]

      if not fungible_cell(C) then continue end

      local room_tab = {}  -- keys are ROOM objects, value is direction

      for dir = 1,6 do
        local dir2 = HEX_RIGHT[dir]

        local N1 = C.neighbor[dir]
        local N2 = C.neighbor[dir2]

        if N1 and N1.room and N2 and N2.room and N1.room == N2.room then
          room_tab[N1.room] = dir
        end
      end

      each room,dir in room_tab do
        local BUD =
        {
          C    = C
          room = room
          dir  = dir
          prob = room.grow_prob
        }

        -- strong preference to grow along the path
        if C.kind == "used" then
          BUD.prob = BUD.prob * 5
        end

        table.insert(list, BUD)
      end
      
    end -- cx, cy
    end

    return list
  end


  local function grow_a_room()
    local buds = collect_possible_buds()

    -- nothing possible?  map must be completely filled...
    if table.empty(buds) then return false end

    local prob_tab = {}
    for i = 1, #buds do
      prob_tab[i] = buds[i].prob
    end

    local index = rand.index_by_probs(prob_tab)

    local C = buds[index].C
    local R = buds[index].room

    R:add_cell(C)

    return true
  end


  ---| Hex_add_rooms_DM |---

  initial_rooms()

  while grow_a_room() do end

  Hex_merge_rooms(room_list)

  Hex_kill_unused_rooms(room_list)

  LEVEL.rooms = room_list

-- FIXME!!!
for cx = 1, HEX_W do
for cy = 1, top_H do
  local C = HEX_CELLS[cx][cy]
  if fungible_cell(C) then
    stderrf("Missed : %s\n", C:tostr())
    C.kind = "dead"
  end
end
end

end



function Hex_add_rooms_CTF()
  --
  -- Algorithm:
  --
  --   1. setup rooms on the middle row.
  --
  --   2. pick location for flag room.
  --
  --   3. process each row away from that, pick room for each cell
  --      and occasionally create new rooms.
  --

  local room_list = {}


  local function new_room()
    local ROOM = HEX_ROOM_CLASS.new()
    table.insert(room_list, ROOM)
    return ROOM
  end


  local function initial_row()
    -- these must be mirrored horizontally, otherwise when the other
    -- half of the map is mirrored there would be a mismatch.

    local cy = HEX_MID_Y

    local last_room

    for cx = HEX_MID_X, 1, -1 do
      local C = HEX_CELLS[cx][cy]

      if C.kind == "edge" then continue end

      if last_room and #last_room.cells == 1 and rand.odds(50) then
        last_room:add_cell(C)
        continue
      end

      last_room = new_room()

      last_room:add_cell(C)
    end

    -- do the mirroring

    for cx = 1, HEX_MID_X - 1 do
      local dx = HEX_MID_X + (HEX_MID_X - cx)

      local C = HEX_CELLS[cx][cy]
      local D = HEX_CELLS[dx][cy]

      if C.kind == "edge" then continue end

      assert(D.kind != "edge")

      C.room:add_cell(D)
    end
  end


  local function bottom_cell_in_column(cx)
    for cy = 1, HEX_MID_Y - 8 do
      local C = HEX_CELLS[cx][cy]

      if C.kind == "used" then return cy end
    end

    return nil  -- none at all
  end


  local function pick_flag_pos()
    local cx, cy

    repeat
      cx = math.random(1 + 2, HEX_W - 3)
    
      cy = bottom_cell_in_column(cx)
    until cy

    return cx, cy
  end


  local function plant_the_flag()
    -- determine middle of flag room
    -- (pick lowest of two tries)

    local cx,  cy  = pick_flag_pos()
    local cx2, cy2 = pick_flag_pos()

    if cy2 < cy then
      cx, cy = cx2, cy2
    end


    -- apply a vertical adjustment

    while cy < 4 do cy = cy + 2 end

    if cy >= 6 and rand.odds(35) then cy = cy - 2 end

        if rand.odds(10) then cy = cy + 4
    elseif rand.odds(35) then cy = cy + 2
    end


    -- create the room

    local R = new_room()

    R.flag_room = true

    local C = HEX_CELLS[cx][cy]
    C.kind = "used"
    R:add_cell(C)

    for dir = 1,6 do
      local N = C.neighbor[dir]
      N.kind = "used"
      R:add_cell(N)
    end


    -- mark location of flag

    local fy = cy - rand.sel(40, 2, 0)

    local F = HEX_CELLS[cx][fy]

    F.content = { kind="FLAG" }
  end


  local function choose_room_from_nb(C)
    local N4 = C.neighbor[4]
    local N5 = C.neighbor[5]
    local N6 = C.neighbor[6]

    if N4 and not N4.room then N4 = nil end
    if N5 and not N5.room then N5 = nil end
    if N6 and not N6.room then N6 = nil end

    if not (N4 or N6) then
      if N5 then return N5.room end

      -- ouch!
      return new_room()
    end

    local T
    if C.thread and not C.trimmed then T = C.thread end

    if N5 and rand.odds(sel(N5.thread == T, 90, 20)) then
      return N5.room
    end

    if not N4 then return N6.room end
    if not N6 then return N4.room end

    if N4.room == N6.room then return N4.room end

    -- tend to prefer the same thread
    local prob = 50

    if N4.thread == T then prob = prob + 40 end
    if N6.thread == T then prob = prob - 40 end

    return rand.sel(prob, N4.room, N6.room)
  end


  local function process_row(cy)
    local last_new_room = false

    for cx = 1, HEX_W do
      local C = HEX_CELLS[cx][cy]

      -- already set?
      if C.room then continue end

      if C.kind == "edge" then continue end

      -- occasionally create a new room (unless last cell was new)

      if not last_new_room and rand.odds(15) then
        local R = new_room()
        R:add_cell(C)
        last_new_room = true
        continue
      end

      last_new_room = false

      -- otherwise we choose between two above neighbors (diagonals)

      local R = choose_room_from_nb(C)

      R:add_cell(C)
    end
  end


  ---| Hex_add_rooms_CTF |---

  initial_row()

  plant_the_flag()

  for cy = HEX_MID_Y - 1, 1, -1 do
    process_row(cy)
  end

  Hex_merge_rooms(room_list)

  Hex_kill_unused_rooms(room_list)

  LEVEL.rooms = room_list
end



function Hex_add_rooms()

  ---| Hex_add_rooms |---

  if LEVEL.CTF then
    Hex_add_rooms_CTF()
  else
    Hex_add_rooms_DM()
  end
end



function Hex_floor_heights()
  --
  -- The difficulty here is that we require all the cycles to remain
  -- walkable, which puts many constraints on the room heights.  For
  -- example, we assume '48' is the maximum difference between any
  -- two cells.
  --
  -- Algorithm:
  --   1. set all rooms to zero.
  --
  --   2. pick a room move the floor_h by 24 units up or down, but only
  --      when it is compatible with nearby visitable rooms.
  --
  --   3. repeat step 2 many times.
  --
  -- NOTE: we also pick a room as an "anchor" room, which remains at
  --       height zero.  It will prevent run-away height values.
  --

  local MAX_STEP = 48

  local anchor_room
  local main_z_dir


  local function find_anchor_room()
    local C
    local top_H = sel(LEVEL.CTF, HEX_MID_Y, HEX_H)

    if LEVEL.CTF and rand.odds(50) then
      local C = HEX_CELLS[HEX_MID_X][HEX_MID_Y]
    end

    while not (C and C.room) do
      local cx = rand.irange(2, HEX_W - 1)
      local cy = rand.irange(2, top_H - 1)

      C = HEX_CELLS[cx][cy]
    end

    anchor_room = C.room
  end


  local function try_adjust_room(R)
    local nb_min
    local nb_max

    each N in R.walk_neighbors do
      nb_min = math.min(nb_min or  9999, N.floor_h)
      nb_max = math.max(nb_max or -9999, N.floor_h)
    end

    assert(nb_min <= nb_max)

    local min_h = nb_max - MAX_STEP
    local max_h = nb_min + MAX_STEP

    assert(min_h <= max_h)

    local step_h = rand.sel(70, 48, 24)
    local z_dir  = rand.sel(75, 1, -1) * main_z_dir

    local new_h = R.floor_h + step_h * z_dir

    if math.in_range(min_h, new_h, max_h) then
      R.floor_h = new_h
      return true
    end

    return false
  end


  local function determine_floor_min_max()
    local min_h, max_h

    each R in LEVEL.rooms do
      min_h = math.min(min_h or  9999, R.floor_h)
      max_h = math.max(max_h or -9999, R.floor_h)
    end

    LEVEL.max_floor_h = max_h
    LEVEL.min_floor_h = min_h

    LEVEL.sky_h = LEVEL.max_floor_h + rand.pick({ 144, 192, 256, 320 })
  end


  ---| Hex_floor_heights |---

  find_anchor_room()

  each R in LEVEL.rooms do
    R.floor_h = 0

    R:find_walk_neighbors()
  end

  main_z_dir = rand.sel(70, 1, -1)


  local MAX_LOOP = 300 + #LEVEL.rooms * 30

  for loop = 1, MAX_LOOP do
    local idx = rand.irange(1, #LEVEL.rooms)
    local R = LEVEL.rooms[idx]

    if R != anchor_room then
      try_adjust_room(R)
    end
  end

  determine_floor_min_max()
end



function Hex_place_stuff()
  local top_H = sel(LEVEL.CTF, HEX_MID_Y - 1, HEX_H)

  local walkable_cells = {}

  local MAX_DIST = 9


  local function dir_to_angle(dir)
    if dir == 1 then return 225 end
    if dir == 2 then return 270 end
    if dir == 3 then return 315 end

    if dir == 4 then return 135 end
    if dir == 5 then return  90 end
    if dir == 6 then return  45 end

    return 0
  end


  local function dist_to_edge(C, dir)
    local dist = 0

    while C:can_travel_in_dir(dir) do
      dist = dist + 1
      C = C.neighbor[dir]
    end

    return dist
  end


  local function angle_for_player(C)
    local best_dir
    local best_dist

    for dir = 1, 6 do
      local dist = dist_to_edge(C, dir)

      dist = dist + gui.random() / 10

      if not best_dist or dist > best_dist then
        best_dir  = dir
        best_dist = dist
      end
    end

    return dir_to_angle(best_dir)
  end


  local function place_anywhere(ent, is_single)
    for loop = 1, 9000 do
      local cx = rand.irange(1, HEX_W)
      local cy = rand.irange(1, top_H)

      local C = HEX_CELLS[cx][cy]

      if not C.room then continue end

      if C.content then continue end

      C.content =
      {
        kind   = "ENTITY"
        entity = ent
        no_mirror = is_single
      }

      if string.match(ent, "player") then
        C.content.angle = angle_for_player(C)
      end

      return -- OK
    end

    if is_single then
      error("Failed to place: " .. tostring(ent))
    end
  end


  local function collect_cells()
    for cx = 1, HEX_W do
    for cy = 1, HEX_H do
      local C = HEX_CELLS[cx][cy]

      if C.room then
        table.insert(walkable_cells, C)
      end
    end
    end
  end


  local function grow_dist_kind(what)
    each C in walkable_cells do
      if not C.dist[what] then continue end

      local new_dist = C.dist[what] + 1

      for dir = 1, 6 do
        if not C:can_travel_in_dir(dir) then continue end

        local N = C.neighbor[dir]

        if not N.dist[what] or N.dist[what] > new_dist then
          N.dist[what] = new_dist
          if N.peer then N.peer.dist[what] = N.dist[what] end
        end
      end
    end
  end


  local function update_distances(what, count)
    for loop = 1, count do
      grow_dist_kind(what)
    end

    each C in walkable_cells do
      C.dist[what] = math.min(C.dist[what] or 999, count)
    end
  end


  local function calc_wall_dists()
    each C in walkable_cells do
      if C:near_wall() then
        C.dist.wall = 0
        if C.peer then C.peer.dist.wall = 0 end
      end
    end

    update_distances("wall", MAX_DIST)
  end


  local function calc_flag_dists()
    if not LEVEL.CTF then return end

    each C in walkable_cells do
      if C.content and C.content.kind == "FLAG" then
        C.dist.item = 0
      end
    end

    update_distances("item", MAX_DIST)
  end


  local function put_item(C, kind, item)
    assert(not C.content)
    assert(not C.peer)

    C.content =
    {
      kind   = kind
      entity = item
    }

    C.dist.item = 0

    update_distances("item", MAX_DIST)
  end


  local function put_start(C)
    assert(not C.content)
    assert(not C.peer)

    -- the 'team' field for CTF maps is decided in Hex_assign_bases

    C.content = { kind="START" }
    C.content.angle = angle_for_player(C)

    C.dist.start = 0

    update_distances("start", MAX_DIST)
  end


  local function how_many_weapons()
    -- TODO: adjust based on map size

    return 2 + rand.index_by_probs({ 4, 6, 2 })
  end


  local function how_many_player_starts()
    -- TODO: adjust based on map size

    if LEVEL.CTF then
      -- CTF starts will be duplicated when map is mirrored
      return rand.irange(4, 6)
    else
      return rand.irange(5, 10)
    end
  end


  local function prob_for_weapon(name, info)
    local prob = info.mp_prob or info.add_prob

    if not prob or prob <= 0 then return 0 end

    return prob
  end


  local function decide_weapons()
    local tab = {}

    each name,info in GAME.WEAPONS do
      local prob = prob_for_weapon(name, info, R)

      if prob > 0 then
        tab[name] = prob
      end
    end

    assert(not table.empty(tab))

    
    local want_num = how_many_weapons()

    LEVEL.weapons = {}

    for i = 1, want_num do
      if table.empty(tab) then break; end

      local name = rand.key_by_probs(tab)
      tab[name] = nil

      table.insert(LEVEL.weapons, name)
    end

--??    rand.shuffle(LEVEL.weapons)


    gui.printf("Weapons:\n")

    each name in LEVEL.weapons do
      gui.printf("   %s\n", name)
    end

    gui.printf("\n")
  end


  local function decide_big_item()
    local tab = {}

    tab["NONE"] = 20

    each name,info in GAME.NICE_ITEMS do
      tab[name] = 10
    end

    local item = rand.key_by_probs(tab)

    gui.printf("Big item: %s\n\n", item)

    if item != "NONE" then
      -- add to weapon list (for simpler code later)
      table.insert(LEVEL.weapons, rand.sel(70, 1, 2), item)
    end
  end


  local function score_for_weapon(C)
    local score = 0

    score = score + C.dist.wall * 12

    score = score + (C.dist.item or 0) * 5

    return score + C.random1 * 11
  end


  local function score_for_start(C)
    local score = 0

    if C.dist.wall == 0 then score = score + 20.0 end
    if C.dist.wall == 1 then score = score + 6.0 end

    score = score + (C.dist.item  or 0) * 2
    score = score + (C.dist.start or 0) * 5

    return score + C.random2 * 9
  end


  local function spot_for_wotsit(kind)
    each C in walkable_cells do
      C.score = -999

      -- already used?
      if C.content then continue end

      -- ignore the middle row (simplifies some cases)
      if LEVEL.CTF and C.cy == HEX_MID_Y then continue end

      if kind == "START" then
        C.score = score_for_start(C)
      else
        C.score = score_for_weapon(C)
      end
    end

    local spot = table.pick_best(walkable_cells, 
        function(A, B) return A.score > B.score end)

    return assert(spot)
  end


  local function place_item_in_middle()
    local C = HEX_CELLS[HEX_MID_X][HEX_MID_Y]

    if not C.room then return end

    local name = table.remove(LEVEL.weapons, 1)

    put_item(C, "WEAPON", name)
  end


  local function place_weapons()
    each name in LEVEL.weapons do
      local C = spot_for_wotsit("WEAPON")

      put_item(C, "WEAPON", name)
    end
  end


  local function place_player_starts()
    local want_num = how_many_player_starts()

    for i = 1, want_num do
      local C = spot_for_wotsit("START")

      put_start(C)
    end
  end


  ---| Hex_place_stuff |---

  collect_cells()

  calc_wall_dists()
  calc_flag_dists()

  decide_weapons()
  decide_big_item()

  if LEVEL.CTF and rand.odds(50) then
    place_item_in_middle()
  end

  place_weapons()
  place_player_starts()

  -- finally, add a single player start
  place_anywhere("player1", true)

  -- and some deathmatch starts
  place_anywhere("dm_player", false)
  place_anywhere("dm_player", false)
  place_anywhere("dm_player", false)
  place_anywhere("dm_player", false)
end



function Hex_mirror_map()

  local function mirror_angle(ang)
    if ang < 180 then
      return ang + 180
    else
      return ang - 180
    end
  end


  local function mirror_path(C, D)
    for dir = 1, 6 do
      if C.path[HEX_OPP[dir]] then
        D.path[dir] = D.neighbor[dir]
      end
    end
  end


  local function mirror_cell(C, D)
    D.kind = C.kind
    D.room = C.room

    if C.content and not C.content.no_mirror then
      D.content = table.copy(C.content)

      if D.content.angle then
         D.content.angle = mirror_angle(D.content.angle)
      end
    end

    C.peer = D
    D.peer = C
  end


  ---| Hex_mirror_map |---

  for cx = 1, HEX_W do
  for cy = 1, HEX_MID_Y - 1 do
    local C = HEX_CELLS[cx][cy]

    local dx = (HEX_W - cx) + (cy % 2)
    local dy = (HEX_H - cy) + 1

    if dx < 1 then continue end

    local D = HEX_CELLS[dx][dy]

    mirror_cell(C, D)
    mirror_path(C, D)
  end
  end


  -- handle middle row
  local cy = HEX_MID_Y

  for cx = 1, HEX_W do
    if cx == HEX_MID_X then continue end

    local dx = HEX_MID_X + (HEX_MID_X - cx)

    local C = HEX_CELLS[cx][cy]
    local D = HEX_CELLS[dx][cy]

    mirror_path(C, D)
  end


  -- handle middle-most cell
  local M = HEX_CELLS[HEX_MID_X][HEX_MID_Y]

  mirror_path(M, M)
end



function Hex_shrink_edges()
  -- compute a distance from each used cell.
  -- free cells which touch an edge and are far away become edge cells.

  local top_H = sel(LEVEL.CTF, HEX_MID_Y - 1, HEX_H)

  local function mark_cells()
    for cx = 1, HEX_W do
    for cy = 1, top_H do
      local C = HEX_CELLS[cx][cy]

      if C.kind == "used" then
        C.dist.used = 0
      end
    end
    end
  end


  local function sweep_cells()
    local changes = 0

    for cx = 1, HEX_W do
    for cy = 1, top_H do
      local C = HEX_CELLS[cx][cy]

      local dist = C:used_dist_from_neighbors()

      if not dist then continue end

      dist = dist + 1

      if not C.dist.used or dist < C.dist.used then
        C.dist.used = dist

        changes = changes + 1
      end
    end
    end

    return (changes > 0)
  end


  local function set_edge(C)
    C.kind = "edge"
  end


  local function grow_edges()
    local changes = 0

    for cx = 1, HEX_W do
    for cy = 1, top_H do
      local C = HEX_CELLS[cx][cy]

      if C.kind == "edge" then continue end

      if C.dist.used and
         C.dist.used > 3 and
         C:touches_edge()
      then
        set_edge(C)

        changes = changes + 1
      end
    end
    end

    return (changes > 0)
  end


  ---| Hex_shrink_edges |---

  mark_cells()

  while sweep_cells() do end

  while grow_edges() do end
end



function Hex_recollect_rooms()
  --
  -- After mirroring the level, a "room" may consist of two separate
  -- pieces.  Here we reconstitute the rooms from contiguous areas.
  --

  local function setup()
    LEVEL.rooms = {}

    -- rename the 'room' fields

    for cx = 1, HEX_W do
    for cy = 1, HEX_H do
      local C = HEX_CELLS[cx][cy]

      C.old_room = C.room
      C.room     = nil
    end
    end
  end


  local function grow_room(R)
    local changes = 0

    for idx = 1, #R.cells do
      local C = R.cells[idx]

      for dir = 1, 6 do
        local N = C.neighbor[dir]

        if N and not N.room and N.old_room == C.old_room then
          R:add_cell(N)
          changes = changes + 1
        end
      end
    end

    return (changes > 0)
  end


  local function recreate_room_from_cell(C)
    local R = HEX_ROOM_CLASS.copy(C.old_room)

    table.insert(LEVEL.rooms, R)

    R:add_cell(C)

    while grow_room(R) do
      -- keep going until claimed all contiguous cells
    end

    R:calc_bbox()

    return R
  end


  local function handle_mirror(C)
    -- check whther mirror'd cell is a separate room or not
    local R = C.room

    local N = C.peer
    if not N then return end

    if N and not N.room then
      assert(N.old_room == C.old_room)

      local R2 = recreate_room_from_cell(N)

      assert(#R.cells == #R2.cells)

      -- peer the mirrored rooms
      R .peer = R2
      R2.peer = R

      R2.id = 0 - R.id
    end
  end


  ---| Hex_recollect_rooms |---

  setup()

  for cy = 1, HEX_H do
  for cx = 1, HEX_W do
    local C = HEX_CELLS[cx][cy]

    if C.old_room and not C.room then
      if C.peer then assert(not C.peer.room) end
      recreate_room_from_cell(C)
      handle_mirror(C)
    end
  end
  end

  -- validate : check we recreated all rooms
  for cx = 1, HEX_W do
  for cy = 1, HEX_H do
    local C = HEX_CELLS[cx][cy]

    if C.old_room then assert(C.room) end
  end
  end

  -- due to separation, some rooms are now unvisitible : kill 'em!

  Hex_kill_unused_rooms(LEVEL.rooms)
end



function Hex_assign_bases()
  --
  -- Decide which rooms are part of a team's base.
  -- Also assigns the 'team' field for FLAGs and player STARTs.
  --

  local top_Y  = int((HEX_MID_Y - 1) * rand.pick({ 0.6, 0.8, 1.0 }))
  local left_X = int((HEX_MID_X - 1) * rand.pick({ 0,   0.7, 1.0 }))
  local right_X = HEX_W + 1

  if rand.odds(50) then
    right_X = HEX_W + 1 - left_X
    left_X  = -1
  end

  each R in LEVEL.rooms do
    if not R.peer then continue end

    -- already done?
    if R.base then continue end

    if R.max_cy <= top_Y or
       R.max_cx <= left_X or
       R.min_cx >= right_X
    then
      R.base = "blue"
      R.peer.base = "red"
    end
  end

  -- handle flags

  for cx = 1, HEX_W do
  for cy = 1, HEX_H do
    local C = HEX_CELLS[cx][cy]

    if C.content and C.content.kind == "FLAG" then
      if cy < HEX_MID_Y then
        C.content.team = "blue"
        C.room.base    = "blue"
      else
        C.content.team = "red"
        C.room.base    = "red"
      end
    end
  end
  end

  -- handle player starts

  for cx = 1, HEX_W do
  for cy = 1, HEX_H do
    local C = HEX_CELLS[cx][cy]

    if C.content and C.content.kind == "START" and not C.content.team then
      if C.base then
        C.content.team = C.base
      else
        local blue_prob = 50
        if cy < HEX_MID_Y then blue_prob = 75 end
        if cy > HEX_MID_Y then blue_prob = 25 end

        C.content.team = rand.sel(blue_prob, "blue", "red")

        local D = assert(C.peer)

        if C.content.team == "blue" then
          D.content.team = "red"
        else
          D.content.team = "blue"
        end
      end 
    end

  end
  end
end



function Hex_decide_room_kinds()
  
  local function decide_room_kind(R)
    -- choose between outdoor/indoor and cave/building

    -- already set?
    if R.kind then return end

    R.is_outdoor = rand.odds(LEVEL.outdoor_prob)
    R.is_cave    = rand.odds(LEVEL.cave_prob)

    if R.is_cave then
      R.kind = "cave"
    elseif R.is_outdoor then
      R.kind = "outdoors"
    else
      R.kind = "building"
    end

    -- prefer the CTF flag room to be indoor
    if R.flag_room and rand.odds(50) then R.is_outdoor = false end

    local N = R.peer

    if N then
      N.is_outdoor = R.is_outdoor
      N.is_cave    = R.is_cave
    end
  end



  ---| Hex_decide_room_kinds |---

  LEVEL.outdoor_prob = style_sel("outdoors", 0, 15, 40, 75, 100)
  LEVEL.cave_prob    = style_sel("caves",    0, 15, 35, 65, 100)

  each R in LEVEL.rooms do
    decide_room_kind(R)
  end
end



function Hex_choose_themes()

  local UNWANTED_MATS =
  {
    -- these materials use base colors, and hence should not be used for
    -- the walls/floors/ceilings of rooms.

    -- TODO: move into game-specific data

    BRICK11  = 1, COMPBLUE = 1, COMPTILE = 1, COMPOHSO = 1
    CRACKLE2 = 1, FIREBLU1 = 1, FIRELAVA = 1, REDWALL  = 1
    REDWALL1 = 1, ROCKRED1 = 1, SP_HOT1  = 1, A_REDROK = 1
    DORED    = 1, EGREDI   = 1

    CEIL4_1  = 1, CEIL4_2  = 1, CEIL4_3  = 1, FLAT14   = 1
    FLAT22   = 1, FLOOR1_1 = 1, FLAT5_3  = 1, FLOOR1_6 = 1
    FLOOR1_7 = 1, FLOOR6_1 = 1, RROCK01  = 1, RROCK05  = 1
    SLIME09  = 1, TLITE6_5 = 1
  }


  local function match_level_theme(name)
    local kind = string.match(name, "([%w]+)_")

    if string.match(name, "DEFAULT") then return false end

    return (kind == LEVEL.theme_name) or (kind == "generic")
  end


  local function collect_usable_themes(kind)
    local tab = {}

    each name,info in GAME.THEMES do
      if info.kind == kind and match_level_theme(name) then
        tab[name] = info.prob or 50
      end
    end

    return tab
  end


  local function pick_zone_theme(theme_tab)
    assert(theme_tab)

    if table.empty(theme_tab) then
      error("pick_zone_theme: nothing matched!")
    end

    local tab = table.copy(theme_tab)

    local name = rand.key_by_probs(tab)

    return assert(GAME.THEMES[name])
  end


  local function decide_room_theme(R)
    -- already set?
    if R.theme then return end

    if R.is_outdoor then
      R.theme = LEVEL.outdoor_theme
    elseif R.is_cave then
      R.theme = LEVEL.cave_theme
    else
      R.theme = LEVEL.building_theme
    end

    assert(R.theme)

    if R.peer then
       R.peer.theme = R.theme
    end
  end


  local function sel_usable_material(tab, fallback)
    -- remove any base-colored materials in CTF mode
    if LEVEL.CTF then
      tab = table.copy(tab)

      each name,_ in UNWANTED_MATS do
        tab[name] = nil
      end

      if table.empty(tab) then
        return fallback
      end
    end

    return rand.key_by_probs(tab)
  end


  local function do_set_tex(R, w_mat, f_mat, c_mat)
    R.wall_mat  = w_mat
    R.floor_mat = f_mat
    R.ceil_mat  = c_mat

    local N = R.peer

    if N then
      N.wall_mat  = w_mat
      N.floor_mat = f_mat
      N.ceil_mat  = c_mat
    end
  end


  local function select_textures(R)
    -- already set?
    if R.wall_mat then return end

    local tab

    if R.is_outdoor or R.is_cave then
      tab = R.theme.naturals or THEME.naturals
    else
      tab = R.theme.walls or THEME.walls
    end

    assert(tab)


    local  wall_mat
    local floor_mat
    local  ceil_mat

    if R.is_cave then
       wall_mat = LEVEL.cave_wall
      floor_mat = LEVEL.cave_floor
       ceil_mat = wall_mat

    elseif R.is_outdoor then
       wall_mat = LEVEL.outdoor_mat
      floor_mat = wall_mat
       ceil_mat = wall_mat  -- not used (ceiling will be sky)

    else
       wall_mat = sel_usable_material(tab, "BROWN96")
      floor_mat = sel_usable_material(R.theme.floors   or tab, wall_mat)
       ceil_mat = sel_usable_material(R.theme.ceilings or tab, wall_mat)
    end

    do_set_tex(R, wall_mat, floor_mat, ceil_mat)
  end


  local function base_trim_textures(R)
    local is_red  = (R.base == "red")
    local is_blue = (R.base == "blue")

    if not (is_red or is_blue) then return end

    local mat1 = sel(is_red, "ROCKRED1", "COMPBLUE")

    R.base_trim = mat1

    if R.flag_room then
      R. wall_mat = mat1
      R.floor_mat = mat1
    end
  end


  ---| Hex_choose_themes |---

  LEVEL.building_theme = pick_zone_theme(collect_usable_themes("building"))
  LEVEL.outdoor_theme  = pick_zone_theme(collect_usable_themes("outdoors"))
  LEVEL.cave_theme     = pick_zone_theme(collect_usable_themes("cave"))

  LEVEL.outdoor_mat = sel_usable_material(LEVEL.outdoor_theme.naturals or THEME.naturals, "MFLR8_4")

  LEVEL.cave_wall   = sel_usable_material(LEVEL.cave_theme.naturals or THEME.naturals, "ASHWALL4")
  LEVEL.cave_floor  = sel_usable_material(LEVEL.cave_theme.naturals or THEME.naturals, LEVEL.cave_wall)

  each R in LEVEL.rooms do
    decide_room_theme(R)
  end

  each R in LEVEL.rooms do
    select_textures(R)
  end

  each R in LEVEL.rooms do
    base_trim_textures(R)
  end
end



function Hex_border_up()

  local function border_on_side(C, dir)
    local N = C.neighbor[dir]

    -- no need if outdoor and neighbor is solid
    if C.room.is_outdoor then
      if N and (N.kind == "edge" or N.kind == "solid" or N.kind == "dead") then return end
    end

    -- no need if part of same room
    if N and N.room == C.room then return end

    -- no need if connection part of the path (i.e. walkable)
    if C.path[dir] then
      -- may need a stair though
      local diff_h = N.room.floor_h - C.room.floor_h

      -- down stair is handled by other cell
      if diff_h <= 24 then return end

      C.border[dir] =
      {
        kind = "step"
        floor_h = math.i_mid(C.room.floor_h, N.room.floor_h)
        floor_mat = "GRAY7"
      }
      return
    end

    local B = {}
    C.border[dir] = B

    if not C.room.is_outdoor then
      B.kind = "wall"
      B.wall_mat = assert(C.room.wall_mat)

    else
      B.kind = "fence"
      B.floor_h = C.room.floor_h + 32
      B.floor_mat = assert(C.room.wall_mat)
    end
  end


  local function border_up(C)
    if C.kind == "edge" or C.kind == "solid" or C.kind == "dead" then
      return
    end

    for dir = 1,6 do
      border_on_side(C, dir)
    end
  end


  local function corner_at_point(C, dir)
    -- NOTE: this corner is on the OUTSIDE of the cell

    -- get other two cells
    local dir2 = HEX_LEFT[dir]

    local A = C.neighbor[dir2]
    local B = C.neighbor[dir]

    if not A or not B then
      return
    end

    if A.kind == "edge" or A.kind == "solid" or A.kind == "dead" or
       B.kind == "edge" or B.kind == "solid" or B.kind == "dead"
    then
      return
    end

    local dir3 = HEX_LEFT[HEX_OPP[dir2]]

    local CORN

    local AB = A.border[HEX_OPP[dir2]]
    local AD = A.border[dir3]

    local BB = B.border[HEX_OPP[dir]]
    local BD = B.border[HEX_OPP[dir3]]

    if AB and AB.kind == "wall" and
       BB and BB.kind == "wall" and
       not (AD and AD.kind == "wall") and
       not (BD and BD.kind == "wall")
    then
      CORN =
      {
        kind = "wall"
      }

      if AB.wall_mat == BB.wall_mat then
        CORN.wall_mat = AB.wall_mat
      else
        CORN.wall_mat = "METAL"
      end

      C.corner[dir] = CORN
    end

    if AB and AB.kind == "fence" and
       BB and BB.kind == "fence" and
       not AD and
       not BD
    then
      CORN =
      {
        kind = "fence"
      }

      if AB.floor_mat == BB.floor_mat then
        CORN.floor_mat = AB.floor_mat
      else
        CORN.floor_mat = "METAL"
      end

      CORN.floor_h = math.max(AB.floor_h, BB.floor_h)

      C.corner[dir] = CORN
    end
  end


  local function corner_up(C)
    for dir = 1,6 do
      corner_at_point(C, dir)
    end
  end


  ---| Hex_border_up |---

  for cx = 1, HEX_W do
  for cy = 1, HEX_H do
    local C = HEX_CELLS[cx][cy]
    
    border_up(C)
  end
  end

  -- must do corners _after_ borders

  for cx = 1, HEX_W do
  for cy = 1, HEX_H do
    local C = HEX_CELLS[cx][cy]
    
    corner_up(C)
  end
  end
end



function Hex_build_all()
  Trans.clear()

  for cx = 1, HEX_W do
  for cy = 1, HEX_H do
    local C = HEX_CELLS[cx][cy]

    C:build()
  end
  end
end



function Hex_create_level()
  
  gui.printf("\n--==| Hexagonal Construction |==--\n\n")

  LEVEL.CTF = (OB_CONFIG.mode == "ctf")

  Plan_choose_liquid()

  LEVEL.sky_bright = 192
  LEVEL.sky_shade  = 160

  Hex_plan()
  Hex_shrink_edges()

  Hex_add_rooms()
  Hex_floor_heights()

  Hex_place_stuff()

  if LEVEL.CTF then
    Hex_mirror_map()
    Hex_recollect_rooms()
    Hex_assign_bases()
  end

  -- create a zone
  local ZONE =
  {
    id = 1
    rooms = table.copy(LEVEL.rooms)
  }
  LEVEL.zones = { ZONE }

  Hex_decide_room_kinds()
  Hex_choose_themes()

  Hex_border_up()
  Hex_build_all()
end

