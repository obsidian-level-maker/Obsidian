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

  room : ROOM

  x1, y1, x2, y2  -- 2D map coordinates

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
  local K = { bx1=bx1, by1=by1, bx2=bx2, by2=by2, edge={}, corner={} }
  table.set_class(K, CHUNK_CLASS)
  return K
end

function CHUNK_CLASS.install(self)
  for x = self.bx1, self.bx2 do
    for y = self.by1, self.by2 do
      assert(not BLOCKS[x][y])
      BLOCKS[x][y] = self
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

    if bw >= 9 and rand.odds(80) then W = 3 end
    if bh >= 9 and rand.odds(80) then H = 3 end

    if bw >= 15 and rand.odds(50) then W = 5 end
    if bh >= 15 and rand.odds(50) then H = 5 end

    -- if chunks would be long and thin, adjust how many
    local nw = bw / W
    local nh = bh / H

    if nh > nw*2.2 then
      if H >= 3 and rand.odds(10) then
        W = W - 2
      elseif H < 5 and (bh / (H+2)) >= 2 then
        H = H + 2
      elseif W >= 3 then
        W = W - 2
      end

    elseif nw > nh*2.2 then
      if H >= 3 and rand.odds(10) then
        H = H - 2
      elseif W < 5 and (bw / (W+2)) >= 2 then
        W = W + 2
      elseif H >= 3 then
        H = H - 2
      end
    end

   gui.debugf("Section chunks: S%dx%d --> K%dx%d --> B%1.1fx%1.1f\n", sect.sw, sect.sh, W, H, bw / W, bh / H)

    -- determine block sizes
    nw = int(bw / W)
    nh = int(bh / H)

    assert(nw >= 2 and nh >= 2)

    local S = SEEDS[sect.sx1][sect.sy1]
    local bx, by = S:block_range()

    local locs_X = calc_block_sizes(W, bx, bw)
    local locs_Y = calc_block_sizes(H, by, bh)

gui.debugf("locs_X :\n%s\n", table.tostr(locs_X, 2))
gui.debugf("locs_Y :\n%s\n", table.tostr(locs_Y, 2))
gui.debugf("\n")

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

