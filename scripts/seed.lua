------------------------------------------------------------------------
--  SEED MANAGEMENT / GROWING
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2008-2015 Andrew Apted
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


--class SEED
--[[
    --
    -- A "seed" is a square or triangle-shaped half-square on the map,
    -- used for many space allocation tasks.  The corners exist on a
    -- regular grid (currently spaced at 192 units on each axis).
    --

    sx, sy  -- location in seed map

    diagonal : DIR  -- if non-nil, then seed is split into two halves.
                    -- DIR is the corner associated with the triangle
                    -- (and the direction *away* from the diagonal line)

                       +---+   +---+
                       |\ 9|   |7 /|
                       | \ |   | / |
                       |1 \|   |/ 3|
                       +---+   +---+

    top : SEED   -- if seed is split by a diagonal, then this refers to the
                 -- information for the TOP half (i.e. the half occupying the
                 -- top edge), and the main seed contains the BOTTOM half.

    bottom : SEED   -- used in 'top' seed to refer to the other half.


    ////////////////////////

    area : AREA

    room : ROOM

    kind : keyword  -- main usage of seed:
                    -- "walk", "void", "diagonal",
                    -- "stair", "curve_stair", "tall_stair",
                    -- "liquid"

    content : keyword  -- normally nil, but can be:
                       -- "wotsit", "pillar"

    border[DIR] : BORDER

    thick[DIR]  -- thickness of each border

    x1, y1, x2, y2  -- 2D map coordinates

    mid_x, mid_y  -- mid point coordinate

    floor_h, ceil_h -- floor and ceiling heights
    f_tex,   c_tex  -- floor and ceiling textures

    m_cell[DIR] : CELL  -- use for mountains (normally NIL)
                        -- DIR is the side (2/4/6/8)
                        -- only used in 'bottom' seed
                        -- cells can be absent (for diagonal seeds)

    -- NOTE: THIS NOT USED ATM
    chunk[1..n] : CHUNK  -- [1] is the ground floor (or liquid), NIL for void (etc)
                         -- [2] is the 3D floor above (usually NIL)
                         -- [3] can be yet another 3D floor, etc...
--]]


--class EDGE
--[[
    --
    -- An "edge" is the side of a seed (or a row of seeds).
    --
    -- Primary use is for connections between a room and another room or
    -- hallway.  Also used for windows and wide walls / pictures.
    --
    -- Not used between areas of the same room.
    --
    -- Edges are one-sided.  For connections there will be two edges
    -- back-to-back which refer to each other via the 'peer' field.
    --

    kind : keyword  -- "conn", "window", "wall"  [TODO]

    S : SEED        -- first seed (the "left-most" one when facing the edge)

    dir : DIR       -- which side of the seed(s)

    long : number   -- width of edge (in seeds)


    area : AREA

    conn : CONN

    peer : EDGE  -- for connections and windows, the edge on other side


    floor_h  -- floor height (set during room layouting)

    door_kind : keyword   -- can be NIL, or "door" or "arch"
--]]


--class CHUNK
--[[
    kind : keyword  -- "floor", "liquid", "void" (etc)

    floor : FLOOR
--]]


--class CELL
--[[
    area : AREA

    dist  -- how far away from normal parts of the level

    solid : bool

    floor_h
    floor_mat
--]]


--------------------------------------------------------------]]


SEED_W = 0
SEED_H = 0

BASE_X = 0
BASE_Y = 0


SEED_CLASS = {}

function SEED_CLASS.tostr(S)
  return string.format("SEED [%d,%d]", S.sx, S.sy)
end


--
-- convert a square seed to a pair of diagonal seeds.
-- the 'S' parameter becomes the bottom half.
--
-- NOTE: must be done fairly early, e.g. assumes nothing in border[] yet
--
function SEED_CLASS.split(S, diagonal)
  assert(diagonal == 1 or diagonal == 3)
  assert(not S.diagonal)

  S.diagonal = diagonal

  local S2 = Seed_create(S.sx, S.sy, S.x1, S.y1)

  S2.diagonal = 10 - diagonal

  S2.x1 = S.x1 ; S2.y1 = S.y1
  S2.x2 = S.x2 ; S2.y2 = S.y2

  S2.edge_of_map = S.edge_of_map
  S2.fluff_room  = S.fluff_room

  -- link fake seed with real one
  S.top = S2 ; S2.bottom = S

  -- update mid-points
  S :calc_mid_point()
  S2:calc_mid_point()
end


function SEED_CLASS.join_halves(S)
  assert(S.diagonal)
  assert(S.top and not S.bottom)

  local S2 = S.top

  for dir = 2,8,2 do
    S.border[dir].edge_kind = S.border[dir].edge_kind or S2.border[dir].edge_kind
  end

  each dir in geom.CORNERS do
    S.border[dir].edge_kind = nil
  end

  S.diagonal = nil
  S.top = nil

  S:calc_mid_point()

  -- kill the other half
  S2.kind = "dead"
  S2.diagonal = "dead"

  S2.border = nil
  S2.area = nil
  S2.room = nil
end


function Seed_squarify()
  -- detects when a diagonal seed has same area on each half, and
  -- merges the two halves into a full seed

  for sx = 1, SEED_W do
  for sy = 1, SEED_H do
    local S = SEEDS[sx][sy]

    if S.diagonal and S.top.area == S.area then
      S:join_halves()
    end
  end
  end
end


-- NOTE: this is "raw" and does not handle diagonal seeds
function SEED_CLASS.raw_neighbor(S, dir, dist)
  local nx, ny = geom.nudge(S.sx, S.sy, dir, dist)

  if nx < 1 or nx > SEED_W or ny < 1 or ny > SEED_H then
    return nil
  end

  return SEEDS[nx][ny]
end


--
-- This method handles diagonal seeds.  'S' should be one particular half
-- ('top' or 'bottom'), and the result 'N' will also be a certain half.
--
-- Returns 'nodir' parameter when 'dir' makes no sense
-- (i.e. for square seed, only 2/4/6/8, and for a diagonal, only 3 dirs).
--
-- Returns NIL for edge of map (like the raw_neighbor method).
--
function SEED_CLASS.neighbor(S, dir, nodir)
  local N

  -- handle square seeds

  if not S.diagonal then
    if not (dir == 2 or dir == 4 or dir == 6 or dir == 8) then
      return nodir
    end

    N = S:raw_neighbor(dir)

    if N then
      if dir == 2 and N.diagonal then return N.top end

      if dir == 4 and N.diagonal == 1 then return N.top end
      if dir == 6 and N.diagonal == 3 then return N.top end
    end

    return N
  end

  -- handle diagonal seeds

  if (S.diagonal == 7 or S.diagonal == 9) and dir == 8 then
    return S:raw_neighbor(dir)
  end
  
  if (S.diagonal == 1 or S.diagonal == 3) and dir == 2 then
    N = S:raw_neighbor(dir)
    if N and N.diagonal then return N.top end
    return N
  end

  if (S.diagonal == 1 or S.diagonal == 7) and dir == 4 then
    N = S:raw_neighbor(dir)
    if N and N.diagonal == 1 then return N.top end
    return N
  end
  
  if (S.diagonal == 3 or S.diagonal == 9) and dir == 6 then
    N = S:raw_neighbor(dir)
    if N and N.diagonal == 3 then return N.top end
    return N
  end
  
  -- diagonal directions in directions seeds

  if S.diagonal == 1 and dir == 9 then return S.top end
  if S.diagonal == 3 and dir == 7 then return S.top end

  if S.diagonal == 7 and dir == 3 then return S.bottom end
  if S.diagonal == 9 and dir == 1 then return S.bottom end

  return nodir
end


function SEED_CLASS.same_room(S, dir)
  local N = S:neighbor(dir)

  return N and (N.room == S.room)
end


function SEED_CLASS.calc_mid_point(S)
  -- 'S' can be a half-seed too
  local mx = (S.x1 + S.x2) / 2
  local my = (S.y1 + S.y2) / 2

  if S.diagonal == 1 then
    mx = (S.x1 + mx) / 2
    my = (S.y1 + my) / 2

  elseif S.diagonal == 3 then
    mx = (S.x2 + mx) / 2
    my = (S.y1 + my) / 2

  elseif S.diagonal == 7 then
    mx = (S.x1 + mx) / 2
    my = (S.y2 + my) / 2

  elseif S.diagonal == 9 then
    mx = (S.x2 + mx) / 2
    my = (S.y2 + my) / 2
  end 

  S.mid_x = int(mx)
  S.mid_y = int(my)
end


function SEED_CLASS.mid_point(S)
  assert(S.mid_x)

  return S.mid_x, S.mid_y
end


function SEED_CLASS.midstr(S)
  return string.format("SEED(%+5d %+5d)", S.mid_x, S.mid_y)
end


function SEED_CLASS.raw_edge_coord(S, dir)
  -- ignores diagonals
  local mx = S.x1 + SEED_SIZE / 2
  local my = S.y1 + SEED_SIZE / 2

  if dir == 2 then return mx, S.y1 end
  if dir == 8 then return mx, S.y2 end

  if dir == 4 then return S.x1, my end
  if dir == 6 then return S.x2, my end

  error("bad dir to SEED:raw_edge_coord")
end


function SEED_CLASS.edge_coord(S, dir)
  -- assumes 'dir' is a valid direction

  local mx, my = S:mid_point()

  if dir == 2 then return mx, S.y1 end
  if dir == 8 then return mx, S.y2 end

  if dir == 4 then return S.x1, my end
  if dir == 6 then return S.x2, my end

  -- diagonal edge
  return mx, my
end


function SEED_CLASS.in_use(S)
  return S.room or S.closet or S.map_border
end


function SEED_CLASS.raw_corner(S, dir)
  -- this method is RAW: it does not care about diagonals

  local cx = S.sx
  local cy = S.sy

  if dir == 3 or dir == 9 then cx = cx + 1 end
  if dir == 7 or dir == 9 then cy = cy + 1 end

  return Corner_lookup(cx, cy)
end


function SEED_CLASS.get_corner(S, dir)
  -- check for invalid dir (e.g. when looping over all corners)
  if S.diagonal == (10 - dir) then
    return nil
  end

  return S:raw_corner(dir)
end


function SEED_CLASS.has_inner_point(S, dir)
  local corner = S:get_corner(dir)

  return corner and corner.inner_point
end


function SEED_CLASS.make_brush(S)
  -- get parent seed
  local PS = S.bottom or S

  local brush =
  {
    { x=PS.x1, y=PS.y1, __dir=2 }
    { x=PS.x2, y=PS.y1, __dir=6 }
    { x=PS.x2, y=PS.y2, __dir=8 }
    { x=PS.x1, y=PS.y2, __dir=4 }
  }

  if S.diagonal == 3 then
    brush[3].__dir = 7
    table.remove(brush, 4)
  elseif S.diagonal == 7 then
    brush[1].__dir = 3
    table.remove(brush, 2)
  elseif S.diagonal == 1 then
    brush[2].__dir = 9
    table.remove(brush, 3)
  elseif S.diagonal == 9 then
    brush[4].__dir = 1
    table.remove(brush, 1)
  elseif S.diagonal then
    error("Invalid diagonal seed!")
  end

  return brush
end


function SEED_CLASS.cell_neighbor(S, cell_side, dir)
  if S.bottom then S = S.bottom end

  if dir == cell_side then
    S = S:raw_neighbor(dir)
    if not (S and S.m_cell) then return nil end

    cell_side = 10 - cell_side
    local cell = S.m_cell[cell_side]

    return cell, S, cell_side
  end

  -- neighbor is along a diagonal edge, hence in same seed

  if geom.is_vert (cell_side) and geom.is_vert (dir) then return nil end
  if geom.is_horiz(cell_side) and geom.is_horiz(dir) then return nil end

  local cell = S.m_cell[dir]

  return cell, S, dir
end


function SEED_CLASS.brush_for_cell(S, cell_side)
  if S.bottom then S = S.bottom end

  -- first vertex of brush is at center point
  local x1 = S.x1 + (SEED_SIZE / 2)
  local y1 = S.y1 + (SEED_SIZE / 2)

  local corn2 = S:raw_corner(geom.RIGHT_45[cell_side])
  local corn3 = S:raw_corner(geom. LEFT_45[cell_side])

  assert(corn2 and corn3)

  local x2 = corn2.x + (corn2.delta_x or 0)
  local y2 = corn2.y + (corn2.delta_y or 0)

  local x3 = corn3.x + (corn3.delta_x or 0)
  local y3 = corn3.y + (corn3.delta_y or 0)

  local brush =
  {
    { x=x1, y=y1 }
    { x=x2, y=y2 }
    { x=x3, y=y3 }
  }

  return brush
end


----------------------------------------------------------------------


function Seed_create(sx, sy, x1, y1)
  local S =
  {
    sx = sx
    sy = sy

    x1 = x1
    y1 = y1

    thick  = {}
    border = {}
    chunk  = {}
    m_cell = {}
  }

  S.x2 = S.x1 + SEED_SIZE
  S.y2 = S.y1 + SEED_SIZE

  table.set_class(S, SEED_CLASS)

  each dir in geom.ALL_DIRS do
    S.border[dir] = {}
    S.thick [dir] = 16
  end

  S:calc_mid_point()

  return S
end


function Seed_init(map_W, map_H)
  gui.printf("Seed_init: %dx%d\n", map_W, map_H)

  -- setup globals 
  SEED_W = map_W
  SEED_H = map_H


  SEEDS = table.array_2D(SEED_W, SEED_H)

  BASE_X = 0
  BASE_Y = 0

  -- Centre the map : needed for Quake, Hexen2 (etc).
  -- This formula ensures that 'coord 0' is still a seed boundary,
  -- which is VITAL for the Quake visibility code.
  if PARAM.centre_map then
    BASE_X = 0 - int(SEED_W / 2) * SEED_SIZE
    BASE_Y = 0 - int(SEED_H / 2) * SEED_SIZE
  end

  for sx = 1, SEED_W do
  for sy = 1, SEED_H do
    local x1 = BASE_X + (sx-1) * SEED_SIZE
    local y1 = BASE_Y + (sy-1) * SEED_SIZE

    SEEDS[sx][sy] = Seed_create(sx, sy, x1, y1)
  end -- x,y
  end

  -- init depot locations [ for teleport-in monsters ]

  LEVEL.depot_locs = {}

  local depot_x = BASE_X
  local depot_y = BASE_Y + SEED_H * SEED_SIZE

  for row = 0, 1 do
  for col = 0, int(SEED_W / 2) - 1 do
    local x = depot_x + col * 2 * SEED_SIZE
    local y = depot_y + row * 4 * SEED_SIZE + 64

    table.insert(LEVEL.depot_locs, { x=x, y=y })
  end
  end
end


function Seed_close()
  SEEDS = nil

  SEED_W = 0
  SEED_H = 0
end


function Seed_valid(x, y)
  return (x >= 1 and x <= SEED_W) and
         (y >= 1 and y <= SEED_H)
end


function Seed_get_safe(x, y)
  return Seed_valid(x, y) and SEEDS[x][y]
end


function Seed_is_free(x, y)
  assert(Seed_valid(x, y))

  return not SEEDS[x][y].room
end


function Seed_valid_and_free(x, y)
  if not Seed_valid(x, y) then
    return false
  end

  return Seed_is_free(x, y)
end


function Seed_block_valid_and_free(x1,y1, x2,y2)

  assert(x1 <= x2 and y1 <= y2)

  if not Seed_valid(x1, y1) then return false end
  if not Seed_valid(x2, y2) then return false end

  for x = x1,x2 do
  for y = y1,y2 do
    local S = SEEDS[x][y][z]
    if S.room then
      return false
    end
  end -- x, y
  end

  return true
end


function Seed_coord_range(sx1, sy1, sx2, sy2)
  assert(Seed_valid(sx1, sy1))
  assert(Seed_valid(sx2, sy2))

  local S1 = SEEDS[sx1][sy1]
  local S2 = SEEDS[sx2][sy2]

  return S1.x1, S1.y1, S2.x2, S2.y2
end


function Seed_from_coord(x, y)
  local sx = 1 + math.floor((x - BASE_X) / SEED_SIZE)
  local sy = 1 + math.floor((y - BASE_Y) / SEED_SIZE)

  -- clamp to usable range, mainly to handle edge cases
  sx = math.clamp(1, sx, SEED_W)
  sy = math.clamp(1, sy, SEED_H)

  return SEEDS[sx][sy]
end


function Seed_from_loc(loc)
  -- loc is 1 .. 9 (like number on the numeric keypad)

  local dx, dy = geom.delta(loc)

  dx = 0.5 + dx * 0.3 + rand.irange(-2, 2) / 20
  dy = 0.5 + dy * 0.3 + rand.irange(-2, 2) / 20

  local sx = rand.int(SEED_W * dx - 1.5)
  local sy = rand.int(SEED_H * dy - 1.5)

  sx = math.clamp(1, sx, SEED_W)
  sy = math.clamp(1, sy, SEED_H)

  return sx, sy
end


function Seed_over_boundary(N)
  if N.sx <= LEVEL.boundary_sx1 or N.sx >= LEVEL.boundary_sx2 then return true end
  if N.sy <= LEVEL.boundary_sy1 or N.sy >= LEVEL.boundary_sy2 then return true end

  return false
end


function Seed_alloc_depot()
  -- returns NIL if no more are possible

  if table.empty(LEVEL.depot_locs) then
    return nil, nil
  end

  local loc = table.remove(LEVEL.depot_locs, 1)

  return loc.x, loc.y
end


function Seed_setup_CTF()

  local function mirror(S, N)
    if S != N then
      S.ctf_peer = N
      N.ctf_peer = S
    end
  end

  local mid_SW = int((SEED_W + 1) / 2)

  for sx = 1, mid_SW do
  for sy = 1, SEED_H do
    local nx = SEED_W + 1 - sx
    local ny = SEED_H + 1 - sy

    local S = SEEDS[sx][sy]
    local N = SEEDS[nx][ny]

    if S.diagonal then
      assert(N.diagonal)

      mirror(S, N.top)
      mirror(S.top, N)
    else
      mirror(S, N)
    end
  end
  end
end


function Seed_dump_rooms()
  local function seed_to_char(S)
    if not S then return "!" end
    if S.free then return "!" end

    local R = S.room or (S.top and S.top.room)

    if not R then return " " end

    if S.diagonal == 1 then return "\\" end
    if S.diagonal == 3 then return "/" end

    if R.kind == "scenic"   then return "=" end
    if R.kind == "reserved" then return "*" end

    if R.is_outdoor then
      local n = 1 + ((R.id - 1) % 26)
      return string.sub("abcdefghijklmnopqrstuvwxyz", n, n)
    end

    local n = 1 + ((R.id - 1) % 26)
    return string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZ", n, n)
  end

  for y = SEED_H,1,-1 do
    local line = "  "
    for x = 1,SEED_W do
      line = line .. seed_to_char(SEEDS[x][y])
    end
    gui.printf("%s\n", line)
  end

  gui.printf("\n")
end

