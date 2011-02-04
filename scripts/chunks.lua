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

  edge[DIR]   : EDGE
  corner[DIR] : CORNER

  floor_h, ceil_h -- floor and ceiling heights
  f_tex,   c_tex  -- floor and ceiling textures
}


--------------------------------------------------------------]]

require 'defs'
require 'util'


CHUNK_CLASS = {}

function CHUNK_CLASS.new(bx1, by1, bx2, by2)
  local H = { bx1=bx1, by1=by1, bx2=bx2, by2=by2, edge={}, corner={} }
  table.set_class(H, CHUNK_CLASS)
  return H
end

function CHUNK_CLASS.install(self)
  for x = self.bx1, self.bx2 do
    for y = self.by1, self.by2 do
      assert(BLOCKS[x][y])
      BLOCKS[x][y].chunk = self
    end
  end
end

function CHUNK_CLASS.tostr(self)
  return string.format("CHUNK [%d,%d]", self.bx1, self.by1)
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


  local function subdivide_section(sect)
    local bw = sect.sw * 3
    local bh = sect.sh * 3

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

    -- determine block sizes
    nw = int(bw / W)
    nh = int(bh / H)

    assert(nw >= 3 and nh >= 3)

    local S = SEEDS[sect.sx1][sect.sy1]
    local bx, by = S:block_range()

    local locs_X = calc_block_sizes(W, bx, bw)
    local locs_Y = calc_block_sizes(H, by, bh)

    -- create the chunks
    for x = 1,W do for y = 1,H do
      local K = CHUNK_CLASS.new(locs_X[x].low,  locs_Y[y].low,
                                locs_X[x].high, locs_Y[y].high)
      K.room    = R
      K.section = sect

      K.x1 = S.x1 + 64 * (locs_X[x].low  - bx)
      K.y1 = S.y1 + 64 * (locs_Y[y].low  - by)
      K.x2 = S.x1 + 64 * (locs_X[x].high - bx + 1)
      K.y2 = S.y1 + 64 * (locs_Y[y].high - by + 1)

      K:install()

      table.insert(R.chunks, K)
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



function Chunk_handle_connections()
  
  local function do_section_conn(C)

  end


  local function do_hallway_conn(C)
    local R = C.R2

    local S   = C.hall.start
    local dir = C.hall.start_dir

    if S.room ~= R then
      S   = C.hall.dest
      dir = C.hall.dest_dir

      -- make dir face outward
      dir = 10 - dir
    end

    assert(S.room == R)

    merge_blocks(geom.side_coords(dir, S:block_range()))
  end


  ---| Chunk_handle_connections |---

  for _,C in ipairs(LEVEL.all_conns) do
    if C.kind == "section" then do_section_conn(C) end
    if C.kind == "hallway" then do_hallway_conn(C) end
  end
end


----------------------------------------------------------------


function CHUNK_CLASS.similar_neighbor(H, side)
  local bx, by

  local mx = int((H.bx1 + H.bx2) / 2)
  local my = int((H.by1 + H.by2) / 2)

      if side == 2 then bx, by = H.bx1, H.by1 - 1
  elseif side == 8 then bx, by = H.bx1, H.by1 + 1
  elseif side == 4 then bx, by = H.bx1 - 1, H.by1
  elseif side == 6 then bx, by = H.bx1 + 1, H.by1
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

  local f_h = 0
  local c_h = 256

  local f_mat = "FLOOR4_8"
  local c_mat = "FLAT1"
  local w_mat = "STARTAN3"

  if H.hall then
    c_h = 128
    f_mat = "FWATER1"
    w_mat = "COMPSPAN"
  end

  if H.room and H.room.outdoor then
    c_mat = "F_SKY1"
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
    { m="solid" },
    { x=x1, y=y1, tex=c_mat },
    { x=x2, y=y1, tex=c_mat },
    { x=x2, y=y2, tex=c_mat },
    { x=x1, y=y2, tex=c_mat },
    { b=c_h, tex=c_mat },
  })

  -- walls
  for side = 2,8,2 do
    if not H:similar_neighbor(side) then
      local bx1, by1, bx2, by2 = x1,y1, x2,y2

      if side == 2 then by2 = by1 + 36 end
      if side == 8 then by1 = by2 - 36 end
      if side == 4 then bx2 = bx1 + 36 end
      if side == 6 then bx1 = bx2 - 36 end

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

  -- object
  local ent = "potion"
  if not LEVEL.seen_player then
    LEVEL.seen_player = true
    ent = "player1"
  end

  local mx = (H.x1 + H.x2) / 2
  local my = (H.y1 + H.y2) / 2

  Trans.entity(ent, mx, my, 32)
end

