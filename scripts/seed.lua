------------------------------------------------------------------------
--  SEED MANAGEMENT / GROWING
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2008-2016 Andrew Apted
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

    edge[DIR] : EDGE   -- set when an EDGE object exists at this seed
                       -- Note: it may be several seeds wide

    chunk : CHUNK   -- only set when seed is part of a chunk


    kind : keyword  -- main usage of seed:
                    --   "walk", "void", "diagonal",
                    --   "stair", "curve_stair", "tall_stair",
                    --   "liquid"

    content : keyword  -- normally nil, but can be:
                       --   "wotsit", "pillar"

    x1, y1, x2, y2  -- 2D map coordinates

    mid_x, mid_y  -- mid point coordinate

    floor_h, ceil_h -- floor and ceiling heights
    f_tex,   c_tex  -- floor and ceiling textures

--]]


--class EDGE
--[[
    --
    -- An "edge" is the side of a seed (or a row of seeds).
    --
    -- Primary use is for connections between a room and another room or
    -- hallway.  Also used for windows and wide walls / pictures.
    --
    -- Edges are one-sided.  For connections there will be two edges
    -- back-to-back which refer to each other via the 'peer' field.
    --
    -- For long edges, the seed in 'S' here is the left-most one
    -- (relative to the 'dir' value).  So when dir == 8 then 'S' has
    -- the lowest sx coord, and when dir == 4 it has lowest sy coord.
    --

    kind : keyword  -- "nothing" (keep it empty)
                    -- "ignore" (use the junction instead)
                    -- "arch", "door", "lock_door"
                    -- "wall", "fence", "window"
                    -- "steps", "trap_wall", "sky_edge"

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
    -- a rectangle of seeds within an area of a room

    kind : keyword  -- "area" (part of a walkable area)
                    -- "liquid"
                    -- "stair"
                    -- "closet" ('T' elements in rules)
                    -- "joiner" ('J' elements in rules)

    area : AREA

    sx1, sy1, sx2, sy2   -- seed range

    sw, sh  -- seed size

    x1, y1, x2, y2   -- map coordinates

    mx, my           -- coordinate of middle point

    place : keyword  -- "floor" (needs a ceiling + walls)
                     -- "ceil"  (needs a floor + walls)
                     -- "whole" (provides both floor, ceiling, walls)

    shape : keyword  -- "U" or "I" or "L" or "T" or "P"
                     -- only used for stairs, closets, joiners

    content_kind : keyword  -- is NIL when unused / free
                            -- "START", "EXIT", "TELEPORTER"
                            -- "KEY", "WEAPON", "ITEM", "SWITCH"
                            -- "CAGE", "TRAP", "DECORATION"

    peer : CHUNK   -- in symmetrical rooms, this is mirrored chunk

    from_dir  : DIR
    from_area : AREA

    dest_dir  : DIR
    dest_area : AREA

    flipped          -- when TRUE, joiner should be rotated 180 deg

    encroach[SIDE]   -- how much distance is used on each side, often zero
                     -- [ used by walls, archways, etc... ]
--]]


--------------------------------------------------------------]]


SEED_W = 0
SEED_H = 0

BASE_X = 0
BASE_Y = 0


SEED_CLASS = {}

function SEED_CLASS.tostr(S)
return assert(S.name)
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

  S .name = string.format("SEED [%d,%d,B]", S.sx, S.sy)
  S2.name = string.format("SEED [%d,%d,T]", S.sx, S.sy)

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

  S.diagonal = nil
  S.top = nil

  S.name = string.format("SEED [%d,%d]", S.sx, S.sy)

  S:calc_mid_point()

  -- kill the other half

  S2.name = "DEAD_SEED"
  S2.kind = "dead"
  S2.diagonal = "dead"

  S2.area = nil
  S2.room = nil
  S2.edge = nil
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


function SEED_CLASS.get_line(S, dir)
  local x1, y1 = S.x1, S.y1
  local x2, y2 = S.x2, S.y2

  if dir == 8 then y1 = y2 end
  if dir == 2 then y2 = y1 end
  if dir == 4 then x2 = x1 end
  if dir == 6 then x1 = x2 end

  if dir == 2 then
    x1, x2 = x2, x1
  end

  if dir == 6 or dir == 1 or dir == 9 then
    y1, y2 = y2, y1
  end

  return { x1=x1, y1=y1, x2=x2, y2=y2 }
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


----------------------------------------------------------------------


function Seed_create(sx, sy, x1, y1)
  local S =
  {
    sx = sx
    sy = sy

    x1 = x1
    y1 = y1

    name = string.format("SEED [%d,%d]", sx, sy)

    edge   = {}
    border = {}
    m_cell = {}
  }

  S.x2 = S.x1 + SEED_SIZE
  S.y2 = S.y1 + SEED_SIZE

  table.set_class(S, SEED_CLASS)

  S:calc_mid_point()

  return S
end


function Seed_init(map_W, map_H)
  -- setup globals 
  SEED_W = map_W
  SEED_H = map_H

  gui.printf("Map size: %dx%d seeds\n", map_W, map_H)


  SEEDS = table.array_2D(SEED_W, SEED_H)

  -- offset the map in DOOM for flat alignment
  BASE_X = 32
  BASE_Y = 32

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

  for row = 0, 2 do
  for col = 0, int(SEED_W / 3) - 1 do
    local x = depot_x + col * 3 * SEED_SIZE
    local y = depot_y + row * 6 * SEED_SIZE + 64

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


function Seed_squarify()
  -- detects when a diagonal seed has same area on each half, and
  -- merges the two halves into a full seed

  for sx = 1, SEED_W do
  for sy = 1, SEED_H do
    local S = SEEDS[sx][sy]

    if S.diagonal and S.top.area == S.area then
      S:join_halves()
    end
  end -- sx, sy
  end

  each A in LEVEL.areas do
    A:remove_dead_seeds()
  end
end


function Seed_create_edge(S, dir, long, kind)
  -- Note: 'S' must be the left-most seed of a long edge

  local EDGE =
  {
    S = S
    dir = dir
    long = long
    kind = kind
    area = S.area
  }

  -- add it into each seed
  for i = 1, long do
    if S.edge[dir] then
      error("Seed already has an EDGE")
    end

    S.edge[dir] = EDGE

    S = S:raw_neighbor(geom.RIGHT[dir])
  end

  -- add it to area list
  if true then
    local A = assert(EDGE.area)
    table.insert(A.edges, EDGE)
  end

  -- add it to corners
  Corner_add_edge(EDGE)

  return EDGE
end


function Seed_create_edge_pair(S, dir, long, kind)
  local E1 = Seed_create_edge(S, dir, long, kind)

  local N = S:neighbor(dir)
  assert(N)

  if long > 1 then
    N = N:raw_neighbor(geom.RIGHT[dir], long - 1)
    assert(N)
  end

  local E2 = Seed_create_edge(N, 10-dir, long, kind)

  E1.peer = E2
  E2.peer = E1

  return E1, E2
end


function Seed_create_chunk_edge(chunk, side, kind)
  local sx, sy

  if side == 2 then sx = chunk.sx1 ; sy = chunk.sy1 - 1 end
  if side == 8 then sx = chunk.sx2 ; sy = chunk.sy2 + 1 end

  if side == 4 then sx = chunk.sx1 - 1 ; sy = chunk.sy2 end
  if side == 6 then sx = chunk.sx2 + 1 ; sy = chunk.sy1 end

  assert(Seed_valid(sx, sy))

  local long = geom.vert_sel(side, chunk.sw, chunk.sh)

  local S = SEEDS[sx][sy]

  return Seed_create_edge(S, 10-side, long, kind)
end


function Edge_mid_point(E)
  -- FIXME: this does not handle long edges

  local S = E.S

  return S:edge_coord(E.dir)
end


function Edge_is_wallish(E)
  if E.kind == "wall" or E.kind == "window" or
     E.kind == "arch" or E.kind == "locked_door" or
     E.kind == "door" or E.kind == "secret_door"
  then
    return true
  end

  if E.to_chunk and E.to_chunk.kind == "closet" then
    return true
  end

  -- handle straddling stuff
  if E.peer and E.kind == "nothing" then
    local kind2 = E.peer.kind

    if kind2 == "window" or
       kind2 == "arch" or kind2 == "locked_door" or
       kind2 == "door" or kind2 == "secret_door"
    then
      return true
    end
  end

  return false
end


function Edge_calc_wallish_mat(E)
  -- this handles most cases
  if E.wall_mat then
    return E.wall_mat
  end

  -- closets
  if E.to_chunk and E.to_chunk.kind == "closet" then
    local A = E.to_chunk.area
    local tex_ref = E.to_chunk.tex_ref or E.to_chunk.from_area

    if tex_ref then
      if tex_ref.is_outdoor then
        return A.facade_mat or A.zone.facade_mat
      end

      return assert(tex_ref.wall_mat)
    end
  end

  -- TODO : straddling stuff??

  -- fallback
  return "METAL"
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


function Seed_over_map_edge(S)
  if S.sx <= LEVEL.edge_sx1 or S.sx >= LEVEL.edge_sx2 then return true end
  if S.sy <= LEVEL.edge_sy1 or S.sy >= LEVEL.edge_sy2 then return true end

  return false
end


function Seed_over_boundary(S)
  if S.sx <= LEVEL.boundary_sx1 or S.sx >= LEVEL.boundary_sx2 then return true end
  if S.sy <= LEVEL.boundary_sy1 or S.sy >= LEVEL.boundary_sy2 then return true end

  return false
end


function Seed_alloc_depot(room)
  -- returns NIL if no more are possible

  if table.empty(LEVEL.depot_locs) then
    return nil
  end

  local loc = table.remove(LEVEL.depot_locs, 1)

  local DEPOT =
  {
    room = room
    x1 = loc.x
    y1 = loc.y
    skin = {}
  }

  DEPOT.skin.wall = "METAL"

  table.insert(LEVEL.depots, DEPOT)

  return DEPOT
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


------------------------------------------------------------------------


function Chunk_new(kind, sx1,sy1, sx2,sy2)
  local CHUNK =
  {
    id = alloc_id("chunk")

    kind = kind

    sx1 = sx1, sy1 = sy1
    sx2 = sx2, sy2 = sy2

    sw = (sx2 - sx1 + 1)
    sh = (sy2 - sy1 + 1)

    encroach = {}
  }

  CHUNK.name = string.format("CHUNK_%d", CHUNK.id)

  local S1 = SEEDS[sx1][sy1]
  local S2 = SEEDS[sx2][sy2]

  CHUNK.x1, CHUNK.y1 = S1.x1, S1.y1
  CHUNK.x2, CHUNK.y2 = S2.x2, S2.y2

  CHUNK.mx = math.mid(S1.x1, S2.x2)
  CHUNK.my = math.mid(S1.y1, S2.y2)

  return CHUNK
end


function Chunk_base_reqs(chunk, dir)
  local reqs =
  {
    where  = "seeds"

    seed_w = chunk.sw
    seed_h = chunk.sh
  }

  if geom.is_horiz(dir) then
    reqs.seed_w = chunk.sh
    reqs.seed_h = chunk.sw
  end

  return reqs
end


function Chunk_is_slave(chunk)
  -- the "slave" chunk is a peered chunk with a higher ID number

  if not chunk.peer then return false end

  return chunk.id > chunk.peer.id
end


function Chunk_flip(chunk)
  local A1 = chunk.from_area
  local A2 = chunk.dest_area

  chunk.from_area = A2
  chunk.dest_area = A1

  if chunk.shape == "L" then
    chunk.from_dir, chunk.dest_dir = chunk.dest_dir, chunk.from_dir
  else
    chunk.from_dir = 10 - chunk.from_dir

    -- TODO : review this  [ main point of dest_dir is for "L" shapes ]
    if chunk.dest_dir then
      chunk.dest_dir = 10 - chunk.dest_dir
    end
  end
end

