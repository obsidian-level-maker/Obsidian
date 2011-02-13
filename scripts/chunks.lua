----------------------------------------------------------------
--  CHUNKY STUFF
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2011 Andrew Apted
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

class CHUNK
{
  sx1, sy1, sx2, sy2  -- seed range

  x1, y1, x2, y2  -- 2D map coordinates

  room : ROOM
  hall : HALL

  section : SECTION
  hx, hy  --  coordinates of chunk in section

  link[DIR] : LINK

  parts[DIR] : PART  -- divides the chunk into 3x3 sub-areas
                     -- 2/4/6/8 directions are edges
                     -- 1/3/7/9 directions are corners
                     -- each can be NIL if nothing is there
                     -- edges may occupy whole side (no corner then)

  floor_h, ceil_h -- floor and ceiling heights

  f_tex,   c_tex  -- floor and ceiling textures
}


class LINK
{
  C1, C2  -- chunks which are linked

  dir     -- direction from C1 to C2

  conn : CONN

  x1, x2  |  y1, y2  -- coordinate range shared between chunks
}


class PART
{
  chunk, side   -- identification

  x1, y1, x2, y2   -- coverage on 2D map

  fab  -- a prefab which fills the whole 2d area
}


--------------------------------------------------------------]]

require 'defs'
require 'util'


CHUNK_CLASS = {}

function CHUNK_CLASS.new(sx1, sy1, sx2, sy2)
  local C = { sx1=sx1, sy1=sy1, sx2=sx2, sy2=sy2, parts={}, link={} }
  table.set_class(C, CHUNK_CLASS)
  return C
end

function CHUNK_CLASS.install(C)
  for sx = C.sx1, C.sx2 do for sy = C.sy1, C.sy2 do
    local S = SEEDS[sx][sy]
    assert(S)
    S.chunk = C
  end end
end

function CHUNK_CLASS.tostr(C)
  return string.format("CHUNK [%d,%d]", C.sx1, C.sy1)
end

function CHUNK_CLASS.joining_chunks(C, dir)
  local list = {}

  local sx1, sy1, sx2, sy2 = geom.side_coords(dir, C.sx1, C.sy1, C.sx2, C.sy2)

  sx1, sy1 = geom.nudge(sx1, sy1, dir)
  sx2, sy2 = geom.nudge(sx2, sy2, dir)

  for sx = sx1,sx2 do for sy = sy1,sy2 do
    assert(Seed_valid(sx, sy))

    local S = SEEDS[sx][sy]

    if S and S.chunk and not table.has_elem(list, S.chunk) then
      table.insert(list, S.chunk)
    end
  end end

  return list
end

function CHUNK_CLASS.side_len(C, dir)
  return geom.vert_sel(dir, C.x2 - C.x1, C.y2 - C.y1)
end


----------------------------------------------------------------


function Chunk_divide_room(R)
  --
  -- Subdivides the room into chunks.
  --
  -- Goals:
  --  + require odd number of chunks on each axis in each section
  --
  --  + prefer squarish chunks over long and thin ones
  --
  --  + want straddler stuff (doors, windows) to align nicely [TODO]
  --
  --  + prefer intra-room chunks to align nicely [TODO]
  -- 

  local function calc_block_sizes(W, bx, bw)
    assert(W == 1 or W == 3 or W == 5)

    -- begin with all chunks the same width (or height)
    local sizes = {}

    for x = 1,W do
      sizes[x] = int(bw / W)
    end

    -- distribute extra blocks
    local extra = bw - W * sizes[1]
    assert(extra >= 0 and extra < W)

    local dist = 0
    local mid  = int((W+1) / 2)

    while extra >= 2 do
      sizes[1+dist] = sizes[1+dist] + 1
      sizes[W-dist] = sizes[W-dist] + 1

      extra = extra - 2
    end

    if extra >= 1 then
      sizes[mid] = sizes[mid] + 1
    end

    -- convert to locations
    local locs = {}

    for x = 1,W do
      local bx_next = bx + sizes[x]
      locs[x] = { low=bx, high=bx_next-1 }
      bx = bx_next
    end

    return locs
  end


  local function subdivide_section(K)
    -- begin initially with each seed becoming a chunk

    K.chunk_W = K.sw
    K.chunk_H = K.sh

    K.chunk = table.array_2D(K.chunk_W, K.chunk_H)

    -- create the chunks
    for sx = K.sx1, K.sx2 do for sy = K.sy1, K.sy2 do
      local S = SEEDS[sx][sy]

      local C = CHUNK_CLASS.new(sx, sy, sx, sy)

      C.x1, C.y1 = S.x1, S.y1
      C.x2, C.y2 = S.x2, S.y2

      local x = sx - K.sx1 + 1
      local y = sy - K.sy1 + 1

      K.chunk[x][y] = C

      C.room    = R
      C.section = K

      C.hx = x
      C.hy = y 

      C:install()

      table.insert(R.chunks, C)
    end end -- x, y
  end


  ---| Chunk_divide_room |---

  for _,K in ipairs(R.sections) do
    subdivide_section(K)
  end
end



function Chunk_prepare_rooms()
  for _,R in ipairs(LEVEL.all_rooms) do
    Chunk_divide_room(R)
  end
end



function Chunk_merge_list(list)

  local function all_horiz_aligned(x1, x2)
    for _,C2 in ipairs(list) do
      if C2.x1 ~= x1 or C2.x2 ~= x2 then return false end
    end
    return true
  end

  local function all_vert_aligned(y1, y2)
    for _,C2 in ipairs(list) do
      if C2.y1 ~= y1 or C2.y2 ~= y2 then return false end
    end
    return true
  end

  local function do_merge(C, old_C, update_array)
    if C == old_C then return; end

    C.sx1 = math.min(C.sx1, old_C.sx1)
    C.sy1 = math.min(C.sy1, old_C.sy1)
    C.sx2 = math.max(C.sx2, old_C.sx2)
    C.sy2 = math.max(C.sy2, old_C.sy2)

    C.x1 = math.min(C.x1, old_C.x1)
    C.y1 = math.min(C.y1, old_C.y1)
    C.x2 = math.max(C.x2, old_C.x2)
    C.y2 = math.max(C.y2, old_C.y2)

    -- update the section's chunk array
    if update_array and C.section then
      local K = C.section

      for hx = 1,K.chunk_W do for hy = 1,K.chunk_H do
        if K.chunk[hx][hy] == old_C then
          K.chunk[hx][hy] = C
        end
      end end
    end

    -- update the seed map
    C:install()

    -- update room list
    if C.room then
      table.kill_elem(C.room.chunks, old_C)
    end
  end


  local function dump_list()
    gui.debugf("Chunk_merge_list: %d chunks...\n", #list)

    for _,H in ipairs(list) do
      gui.debugf("  %s in %s in %s\n", H:tostr(),
                 (H.section and H.section:tostr()) or "HALL",
                 (H.room and H.room:tostr()) or "-")
    end
  end


  ---| Chunk_merge_list |---

dump_list()

  if #list < 2 then return; end

  local C1 = table.remove(list, 1)

  local K = C1.section
  local R =  K.room

  -- make sure all chunks belong to same section
  for _,C2 in ipairs(list) do
    assert(C2.section == K)
  end

  -- make sure all chunks have either:
  --   (1) same top and bottom coordinates, or
  --   (2) same left and right side coordinates

  
  if all_horiz_aligned(C1.x1, C1.x2) or all_vert_aligned(C1.y1, C1.y2) then
    -- chunks are alignment, can merge them  
    for _,C2 in ipairs(list) do
      do_merge(C1, C2, true)
    end

  else
    -- bad alignment, need to merge all chunks into one big one

    for hx = 1,K.chunk_W do for hy = 1,K.chunk_H do
      do_merge(C1, K.chunk[hx][hy], false)
    end end

    -- setup new array
    K.chunk_W = 1
    K.chunk_H = 1

    K.chunk = table.array_2D(1, 1)

    K.chunk[1][1] = C1

    C1.hx = 1
    C1.hy = 1
  end
end



function Chunk_handle_connections()
  
  local NUM_PASS = 4


  local function link_chunks(C1, C2, dir, conn)
    local LINK =
    {
      C1 = C1,
      C2 = C2,
      dir = dir,
      conn = conn,
    }

    if geom.is_vert(dir) then
      local x1 = math.max(C1.x1, C2.x1)
      local x2 = math.min(C1.x2, C2.x2)

      LINK.x1 = x1 + 16
      LINK.x2 = x2 - 16
    else
      local y1 = math.max(C1.y1, C2.y1)
      local y2 = math.min(C1.y2, C2.y2)

      LINK.y1 = y1 + 16
      LINK.y2 = y2 - 16
    end

    C1.link[dir]      = LINK
    C2.link[10 - dir] = LINK
  end


  local function merge_stuff(C, dir, D, pass)
    local joins = C:joining_chunks(dir)

    if pass < NUM_PASS then
      if #joins == 0 then
        error("Bad connection : no chunks on other side??")
      end

      if #joins >= 2 then
        Chunk_merge_list(joins)
      end

      return
    end

    assert(#joins == 1)

    local C2 = joins[1]

    link_chunks(C, C2, dir, D)
  end


  local function good_linkage(C1, dir, C2)
    -- check if chunks touch nicely

    if geom.is_vert(dir) then
      local x1 = math.max(C1.x1, C2.x1)
      local x2 = math.min(C1.x2, C2.x2)

      if (x2 - x1) >= 192 then return true end
    else
      local y1 = math.max(C1.y1, C2.y1)
      local y2 = math.min(C1.y2, C2.y2)

      if (y2 - y1) >= 192 then return true end
    end

    return false
  end


  local function do_section_conn(D, pass)
    local K1 = assert(D.K1)
    local K2 = assert(D.K2)

    local dir = assert(D.dir)

    -- pick middle chunks
    local C1, C2

    local C1 = K1:middle_chunk(dir)
    local C2 = K2:middle_chunk(10 - dir)

    if good_linkage(C1, dir, C2) then
      if pass == NUM_PASS then
        link_chunks(C1, C2, dir, D)
      end

      return;
    end

    -- awkward link : merge chunks on one side
    local C, dir = C1, dir

    if C2:side_len(dir) < C1:side_len(dir) then
      C, dir = C2, (10-dir)
    end

    merge_stuff(C, dir, D, pass)
  end


  local function do_hall_side(C, dir, K, D, pass)
    -- hallways off a hallway are naturally aligned
    if not K then
      -- FIXME !!!!  local C2 = ....

      if pass == NUM_PASS then
        link_chunks(C, C2, dir, D)
      end

      return;
    end


    local C2 = K:middle_chunk(10 - dir)

    if good_linkage(C, dir, C2) then
      if pass == NUM_PASS then
        link_chunks(C, C2, dir, D)
      end

      return;
    end

    merge_stuff(C, dir, D, pass)
  end


  local function do_hallway_conn(D, pass)
    local hall = assert(D.hall)

    local start_C = hall.path[1].chunk
    local   end_C = hall.path[#hall.path].chunk

    assert(start_C and end_C)

    local start_K = hall.K1
    local   end_K = hall.K2

    local start_dir = hall.path[1].prev_dir
    local   end_dir = hall.path[#hall.path].next_dir

    assert(start_dir and end_dir)

    do_hall_side(start_C, start_dir, start_K, D, pass)
    do_hall_side(  end_C,   end_dir,   end_K, D, pass)
  end


  ---| Chunk_handle_connections |---

do return end --!!!!!

  for pass = 1,NUM_PASS do
    for _,D in ipairs(LEVEL.all_conns) do
      if D.kind == "normal"  then do_section_conn(D, pass) end
      if D.kind == "hallway" then do_hallway_conn(D, pass) end
    end
  end
end


----------------------------------------------------------------


function Chunk_make_parts()

  local function make_parts()
  end


  for _,R in ipairs(LEVEL.all_rooms) do
    for _,H in ipairs(R.chunks) do
      make_parts(C)
    end
  end

  for _,D in ipairs(LEVEL.all_conns) do
    if D.hall then
      for _,C in ipairs(D.hall.chunks) do
        make_parts(C)
      end
    end
  end
end



function CHUNK_CLASS.similar_neighbor(C, dir)
  local sx, sy

  local mx = int((C.sx1 + C.sx2) / 2)
  local my = int((C.sy1 + C.sy2) / 2)

      if dir == 2 then sx, sy = mx, C.sy1 - 1
  elseif dir == 8 then sx, sy = mx, C.sy2 + 1
  elseif dir == 4 then sx, sy = C.sx1 - 1, my
  elseif dir == 6 then sx, sy = C.sx2 + 1, my
  end

  if not Seed_valid(sx, sy) then
    return false
  end

  local S = SEEDS[sx][sy]

  if C.hall then return (S.hall == C.hall) end
  if C.room then return (S.room == C.room) end

  return false
end



function CHUNK_CLASS.build(C)

  -- TEMP TEMP CRUD CRUD

  local f_h = 24 - rand.irange(0,24)
  local c_h = 256
  local light = 0
  local c_medium = "solid"

  local f_mat = "FLAT1" and rand.pick {"FLAT1", "FLOOR4_8", "FLOOR0_1", "CEIL1_1", "FLAT14", "FLOOR5_2"}
  local c_mat = "FLAT1"
  local w_mat = "STARTAN3"

  if not C.hall and --- not (C.room and C.room.outdoor) and
     C:similar_neighbor(2) and C:similar_neighbor(8) and
     C:similar_neighbor(4) and C:similar_neighbor(6)
     and false
  then
    f_mat = "FLOOR4_8"
    f_h   = 0
    c_h   = 384
  end

  if C.hall then
    c_h = 128
    f_mat = "FWATER1"
    w_mat = "COMPSPAN"
  end

  if C.room and C.room.outdoor then
    f_mat = rand.pick {"GRASS1", "FLAT10", "RROCK16", "RROCK03", "RROCK01", "FLAT5_3"}
    c_mat = "F_SKY1"
    c_medium = "sky"
    c_h   = 384

    if GAME.format == "quake" then c_mat = "sky1" end
  else
    light = rand.irange(40, 100)
    if C.hall then light = light * 0.5 end
  end

  local x1, y1 = C.x1, C.y1
  local x2, y2 = C.x2, C.y2

  -- floor
  gui.add_brush(
  {
    { m="solid" },
    { x=x1, y=y1, tex=f_mat },
    { x=x2, y=y1, tex=f_mat },
    { x=x2, y=y2, tex=f_mat },
    { x=x1, y=y2, tex=f_mat },
    { t=f_h, tex=f_mat },
  })

  -- ceiling
  gui.add_brush(
  {
    { m=c_medium },
    { x=x1, y=y1, tex=c_mat },
    { x=x2, y=y1, tex=c_mat },
    { x=x2, y=y2, tex=c_mat },
    { x=x1, y=y2, tex=c_mat },
    { b=c_h, tex=c_mat },
  })

  for dir = 1,9,2 do
    local P = C.parts[dir]

    if P then --[[ FIXME --]] end
  end

  -- walls
  for dir = 2,8,2 do
    if not C:similar_neighbor(dir) then
      local bx1, by1, bx2, by2 = x1,y1, x2,y2

      if dir == 2 then by2 = by1 + 36 end
      if dir == 8 then by1 = by2 - 36 end
      if dir == 4 then bx2 = bx1 + 36 end
      if dir == 6 then bx1 = bx2 - 36 end

      if C.link[dir] then
        local LINK = C.link[dir]

        local cx1, cy1, cx2, cy2 = bx1, by1, bx2, by2

        if geom.is_vert(dir) then
          bx2 = assert(LINK.x1)
          cx1 = assert(LINK.x2)
        else
          by2 = assert(LINK.y1)
          cy1 = assert(LINK.y2)
        end

        if bx2 > bx1 then
          gui.add_brush(
          {
            { m="solid" },
            { x=bx1, y=by1, tex=w_mat },
            { x=bx2, y=by1, tex=w_mat },
            { x=bx2, y=by2, tex=w_mat },
            { x=bx1, y=by2, tex=w_mat },
          })
        end

        if cx2 > cx1 then
          gui.add_brush(
          {
            { m="solid" },
            { x=cx1, y=cy1, tex=w_mat },
            { x=cx2, y=cy1, tex=w_mat },
            { x=cx2, y=cy2, tex=w_mat },
            { x=cx1, y=cy2, tex=w_mat },
          })
        end

      else
        gui.add_brush(
        {
          { m="solid" },
          { x=bx1, y=by1, tex=w_mat },
          { x=bx2, y=by1, tex=w_mat },
          { x=bx2, y=by2, tex=w_mat },
          { x=bx1, y=by2, tex=w_mat },
        })
      end
    end
  end

  -- object
  local ent = "dummy"
  if not LEVEL.seen_player then
    LEVEL.seen_player = true
    ent = "player1"
  end

  local mx = (C.x1 + C.x2) / 2
  local my = (C.y1 + C.y2) / 2

  Trans.entity(ent, mx, my, 32)

  -- lighting
  if light > 0 and GAME.format ~= "doom" then
    local z = rand.irange(64, c_h-32)
    Trans.entity("light", mx, my, z, { light=light, _radius=400 })
  end


  -- TEST CRUD : pillars

  if ent ~= "player1" and C.section then
    local hx = C.section:mid_HX()
    local hy = C.section:mid_HY()

    if C.hx == hx and C.hy == hy then

      local mx = math.imid(x1, x2)
      local my = math.imid(y1, y2)
      
      local T = Trans.spot_transform(mx, my, f_h, 0)

      local skin1 = { pillar="TEKWALL4" }

      Fabricate("ROUND_PILLAR", T, { skin1 })
    end
  end
end

