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
  bx1, by1, bx2, by2  -- block coordinates

  x1, y1, x2, y2  -- 2D map coordinates

  room : ROOM
  hall : HALL

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
  H1, H2  -- chunks which are linked

  dir     -- direction from H1 to H2

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

function CHUNK_CLASS.new(bx1, by1, bx2, by2)
  local H = { bx1=bx1, by1=by1, bx2=bx2, by2=by2, parts={}, link={} }
  table.set_class(H, CHUNK_CLASS)
  return H
end

function CHUNK_CLASS.install(H)
  for x = H.bx1, H.bx2 do for y = H.by1, H.by2 do
    assert(BLOCKS[x][y])
    BLOCKS[x][y].chunk = H
  end end
end

function CHUNK_CLASS.tostr(H)
  return string.format("CHUNK [%d,%d]", H.bx1, H.by1)
end

function CHUNK_CLASS.joining_chunks(H, dir)
  local list = {}

  local bx1, by1, bx2, by2 = geom.side_coords(dir, H.bx1, H.by1, H.bx2, H.by2)

  bx1, by1 = geom.nudge(bx1, by1, dir)
  bx2, by2 = geom.nudge(bx2, by2, dir)

  for bx = bx1,bx2 do for by = by1,by2 do
    assert(Block_valid(bx, by))

    local B = BLOCKS[bx][by]

    if B and B.chunk and not table.has_elem(list, B.chunk) then
      table.insert(list, B.chunk)
    end
  end end

  return list
end

function CHUNK_CLASS.side_len(H, dir)
  return geom.vert_sel(dir, H.x2 - H.x1, H.y2 - H.y1)
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
    local bw = K.sw * 3
    local bh = K.sh * 3

    -- choose number of chunk columns and rows
    local W = 1
    local H = 1

    local INC_PROB = 90

    if bw >= 9 and rand.odds(INC_PROB) then W = 3 end
    if bh >= 9 and rand.odds(INC_PROB) then H = 3 end

    if bw >= 15 and rand.odds(INC_PROB) then W = 5 end
    if bh >= 15 and rand.odds(INC_PROB) then H = 5 end

    -- if chunks would be long and thin, adjust how many
    local nw = bw / W
    local nh = bh / H

    if nh > nw*2.2 then
      if H < 5 and (bh / (H+2)) >= 3 then
        H = H + 2
      elseif W >= 3 then
        W = W - 2
      end

    elseif nw > nh*2.2 then
      if W < 5 and (bw / (W+2)) >= 3 then
        W = W + 2
      elseif H >= 3 then
        H = H - 2
      end
    end

--  gui.debugf("Section chunks: S%dx%d --> H%dx%d --> B%1.1fx%1.1f\n", sect.sw, sect.sh, W, H, bw / W, bh / H)

    K.chunk_W = W
    K.chunk_H = H

    K.chunk = table.array_2D(W, H)

    -- determine block sizes
    nw = int(bw / W)
    nh = int(bh / H)

    assert(nw >= 3 and nh >= 3)

    local S = SEEDS[K.sx1][K.sy1]
    local bx, by = S:block_range()

    local locs_X = calc_block_sizes(W, bx, bw)
    local locs_Y = calc_block_sizes(H, by, bh)

    -- create the chunks
    for x = 1,W do for y = 1,H do
      local H = CHUNK_CLASS.new(locs_X[x].low,  locs_Y[y].low,
                                locs_X[x].high, locs_Y[y].high)
      K.chunk[x][y] = H

      H.room    = R
      H.section = K

      H.x1 = S.x1 + 64 * (locs_X[x].low  - bx)
      H.y1 = S.y1 + 64 * (locs_Y[y].low  - by)
      H.x2 = S.x1 + 64 * (locs_X[x].high - bx + 1)
      H.y2 = S.y1 + 64 * (locs_Y[y].high - by + 1)

      H:install()

      table.insert(R.chunks, H)
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
    for _,H2 in ipairs(list) do
      if H2.x1 ~= x1 or H2.x2 ~= x2 then return false end
    end
    return true
  end

  local function all_vert_aligned(y1, y2)
    for _,H2 in ipairs(list) do
      if H2.y1 ~= y1 or H2.y2 ~= y2 then return false end
    end
    return true
  end

  local function do_merge(H, old_H, update_array)
    if H == old_H then return; end

    H.bx1 = math.min(H.bx1, old_H.bx1)
    H.by1 = math.min(H.by1, old_H.by1)
    H.bx2 = math.max(H.bx2, old_H.bx2)
    H.by2 = math.max(H.by2, old_H.by2)

    H.x1 = math.min(H.x1, old_H.x1)
    H.y1 = math.min(H.y1, old_H.y1)
    H.x2 = math.max(H.x2, old_H.x2)
    H.y2 = math.max(H.y2, old_H.y2)

    -- update the section's chunk array
    if update_array and H.section then
      local K = H.section

      for hx = 1,K.chunk_W do for hy = 1,K.chunk_H do
        if K.chunk[hx][hy] == old_H then
          K.chunk[hx][hy] = H
        end
      end end
    end

    -- update the block map
    for bx = old_H.bx1, old_H.bx2 do for by = old_H.by1, old_H.by2 do
      local B = BLOCKS[bx][by]
      B.chunk = H
    end end

    -- update room list
    if H.room then
      table.kill_elem(H.room.chunks, old_H)
    end
  end


  ---| Chunk_merge_list |---

  if #list < 2 then return; end

  local H1 = table.remove(list, 1)

  local K = H1.section
  local R =  K.room

  -- make sure all chunks belong to same section
  for _,H2 in ipairs(list) do
    assert(H2.section == K)
  end

  -- make sure all chunks have either:
  --   (1) same top and bottom coordinates, or
  --   (2) same left and right side coordinates

  
  if all_horiz_aligned(H1.x1, H1.x2) or all_vert_aligned(H1.y1, H1.y2) then
    -- chunks are alignment, can merge them  
    for _,H2 in ipairs(list) do
      do_merge(H1, H2, true)
    end

  else
    -- bad alignment, need to merge all chunks into one big one

    for hx = 1,K.chunk_W do for hy = 1,K.chunk_H do
      do_merge(H1, K.chunk[hx][hy], false)
    end end

    -- setup new array
    K.chunk_W = 1
    K.chunk_H = 1

    K.chunk = table.array_2D(1, 1)

    K.chunk[1][1] = H1
  end
end



function Chunk_handle_connections()
  
  local NUM_PASS = 4


  local function link_chunks(H1, H2, dir, conn)
    local LINK =
    {
      H1 = H1,
      H2 = H2,
      dir = dir,
      conn = conn,
    }

    if geom.is_vert(dir) then
      local x1 = math.max(H1.x1, H2.x1)
      local x2 = math.min(H1.x2, H2.x2)

      LINK.x1 = x1 + 16
      LINK.x2 = x2 - 16
    else
      local y1 = math.max(H1.y1, H2.y1)
      local y2 = math.min(H1.y2, H2.y2)

      LINK.y1 = y1 + 16
      LINK.y2 = y2 - 16
    end

    H1.link[dir]      = LINK
    H2.link[10 - dir] = LINK
  end


  local function merge_stuff(H, dir, C, pass)
    local joins = H:joining_chunks(dir)

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

    local H2 = joins[1]

    link_chunks(H, H2, dir, C)
  end


  local function good_linkage(H1, dir, H2)
    -- check if chunks touch nicely

    if geom.is_vert(dir) then
      local x1 = math.max(H1.x1, H2.x1)
      local x2 = math.min(H1.x2, H2.x2)

      if (x2 - x1) >= 192 then return true end
    else
      local y1 = math.max(H1.y1, H2.y1)
      local y2 = math.min(H1.y2, H2.y2)

      if (y2 - y1) >= 192 then return true end
    end

    return false
  end


  local function do_section_conn(C, pass)
    local K1 = assert(C.K1)
    local K2 = assert(C.K2)

    local dir = assert(C.dir)

    -- pick middle chunks
    local H1, H2

    local H1 = K1:middle_chunk(dir)
    local H2 = K2:middle_chunk(10 - dir)

    if good_linkage(H1, dir, H2) then
      if pass == NUM_PASS then
        link_chunks(H1, H2, dir, C)
      end

      return;
    end

    -- awkward link : merge chunks on one side
    local H, dir = H1, dir

    if H2:side_len(dir) < H1:side_len(dir) then
      H, dir = H2, (10-dir)
    end

    merge_stuff(H, dir, C, pass)
  end


  local function do_hall_side(H, dir, K, C, pass)
    if K then
      local H2 = K:middle_chunk(10 - dir)

      if good_linkage(H, dir, H2) then
        if pass == NUM_PASS then
          link_chunks(H, H2, dir, C)
        end

        return;
      end      
    end

    merge_stuff(H, dir, C, pass)
  end


  local function do_hallway_conn(C, pass)
    local hall = assert(C.hall)

    local first_H = hall.path[1].chunk
    local  last_H = hall.path[#hall.path].chunk

    assert(first_H and last_H)

    local first_K = hall.K1
    local  last_K = hall.K2

    local first_dir = hall.path[1].prev_dir
    local  last_dir = hall.path[#hall.path].next_dir

    assert(first_dir and last_dir)

    do_hall_side(first_H, first_dir, first_K, C, pass)
    do_hall_side( last_H,  last_dir,  last_K, C, pass)
  end


  ---| Chunk_handle_connections |---

  for pass = 1,NUM_PASS do
    for _,C in ipairs(LEVEL.all_conns) do
      if C.kind == "normal"  then do_section_conn(C, pass) end
      if C.kind == "hallway" then do_hallway_conn(C, pass) end
    end
  end
end


----------------------------------------------------------------


function Chunk_make_parts()

  local function make_parts()
  end


  for _,R in ipairs(LEVEL.all_rooms) do
    for _,H in ipairs(R.chunks) do
      make_parts(H)
    end
  end

  for _,C in ipairs(LEVEL.all_conns) do
    if C.hall then
      for _,H in ipairs(C.hall.chunks) do
        make_parts(H)
      end
    end
  end
end



function CHUNK_CLASS.similar_neighbor(H, dir)
  local bx, by

  local mx = int((H.bx1 + H.bx2) / 2)
  local my = int((H.by1 + H.by2) / 2)

      if dir == 2 then bx, by = mx, H.by1 - 1
  elseif dir == 8 then bx, by = mx, H.by2 + 1
  elseif dir == 4 then bx, by = H.bx1 - 1, my
  elseif dir == 6 then bx, by = H.bx2 + 1, my
  end

  if not Block_valid(bx, by) then
    return false
  end

  local B = BLOCKS[bx][by]

  if not (B and B.chunk) then
    return false
  end

  local H2 = B.chunk

  if H.hall then return (H.hall == H2.hall) end
  if H.room then return (H.room == H2.room) end

  return false
end



function CHUNK_CLASS.build(H)

  -- TEMP TEMP CRUD CRUD

  local f_h = rand.irange(0,24)
  local c_h = 256
  local light = 0
  local c_medium = "solid"

  local f_mat = rand.pick {"FLAT1", "FLOOR4_8", "FLOOR0_1", "CEIL1_1", "FLAT14", "FLOOR5_2"}
  local c_mat = "FLAT1"
  local w_mat = "STARTAN3"

  if H.hall then
    c_h = 128
    f_mat = "FWATER1"
    w_mat = "COMPSPAN"
  end

  if H.room and H.room.outdoor then
    f_mat = rand.pick {"GRASS1", "FLAT10", "RROCK16", "RROCK03", "RROCK01", "FLAT5_3"}
    c_mat = "F_SKY1"
    c_medium = "sky"

    if GAME.format == "quake" then c_mat = "sky1" end
  else
    light = rand.irange(40, 100)
    if H.hall then light = light * 0.5 end
  end

  local x1, y1 = H.x1, H.y1
  local x2, y2 = H.x2, H.y2

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
    local P = H.parts[dir]

    if P then --[[ FIXME --]] end
  end

  -- walls
  for dir = 2,8,2 do
    if not H:similar_neighbor(dir) then
      local bx1, by1, bx2, by2 = x1,y1, x2,y2

      if dir == 2 then by2 = by1 + 36 end
      if dir == 8 then by1 = by2 - 36 end
      if dir == 4 then bx2 = bx1 + 36 end
      if dir == 6 then bx1 = bx2 - 36 end

      if H.link[dir] then
        local LINK = H.link[dir]

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

  local mx = (H.x1 + H.x2) / 2
  local my = (H.y1 + H.y2) / 2

  Trans.entity(ent, mx, my, 32)

  -- lighting
  if light > 0 and GAME.format ~= "doom" then
    local z = rand.irange(64, c_h-32)
    Trans.entity("light", mx, my, z, { light=light, _radius=400 })
  end
end

