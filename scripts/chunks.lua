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
      BLOCKS[x][y].chunk = self
    end
  end
end

function CHUNK_CLASS.tostr(self)
  return string.format("CHUNK [%d,%d]", self.bx1, self.by1)
end

