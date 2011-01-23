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
      BLOCKS[x][y] = self
    end
  end
end

function CHUNK_CLASS.tostr(self)
  return string.format("CHUNK [%d,%d]", self.bx1, self.by1)
end


----------------------------------------------------------------


function Chunk_divide_room(R)

  -- Subdivides the room into chunks.
  --
  -- Goals:
  --  + require odd number of chunks on each axis in each section
  --
  --  + want straddler stuff (doors, windows) to align nicely
  --
  --  + prefer intra-room chunks to align nicely
  -- 
  --  + prefer squarish chunks over long and thin ones


  local function subdivide_section(sect)
    local bw = sect.sw * 3
    local bh = sect.sh * 3

    local W = 1
    local H = 1

    if bw >= 9 and rand.odds(80) then W = 3 end
    if bh >= 9 and rand.odds(80) then H = 3 end

    if bw >= 15 and rand.odds(50) then W = 5 end
    if bh >= 15 and rand.odds(50) then H = 5 end

    local nw = bw / W
    local nh = bh / H

    if nh > nw*2.2 then
      if H >= 3 and rand.odds(20) then
        W = W - 2
      elseif H < 5 and (bh / (H+2)) >= 2 then
        H = H + 2
      elseif W >= 3 then
        W = W - 2
      end

    elseif nw > nh*2.2 then
      if H >= 3 and rand.odds(20) then
        H = H - 2
      elseif W < 5 and (bw / (W+2)) >= 2 then
        W = W + 2
      elseif H >= 3 then
        H = H - 2
      end
    end

-- gui.debugf("Section chunks: S%dx%d --> K%dx%d --> B%1.1fx%1.1f\n", sect.sw, sect.sh, W, H, bw / W, bh / H)

    -- FIXME: BLOW CHUNKS
  end

  ---| Chunk_divide_room |---

  for _,K in ipairs(R.sections) do
    subdivide_section(K)
  end
end

