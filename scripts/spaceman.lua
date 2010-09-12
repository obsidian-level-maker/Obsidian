----------------------------------------------------------------
--  SPACE MANAGER
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2010 Andrew Apted
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

class SPACE
{
  mode  -- keyword:
        --   "empty" : space is not used, free
        --   "floor" : area with known floor height
        --   "walk"  : player always can walk here
        --   "solid" : for walls, stairs, lifts, decoration

  id  -- identifying number (to help debugging)

  x1, y1, x2, y2  -- bounding box

  coords  -- array of {x,y} for sides of space, convex shape
          -- NIL for simple boxes.

  floor_h -- height for "floor"
}


--------------------------------------------------------------]]

require 'defs'
require 'util'


spacelib = {}


SPACE_CLASS = {}

function SPACE_CLASS.new(mode)
  local S = { mode=mode, id=Plan_alloc_mark() }
  table.set_class(S, SPACECLASS)
  return S
end

function SPACE_CLASS.tostr(self)
  return string.format("SPACE_%d %s [%d %d .. %d %d]",
      self.id, self.mode,
      self.x1, self.y1, self.x2, self.y2)
end

function SPACE_CLASS.dump(self)
  -- TODO
end

function SPACE_CLASS.contains(self, x, y, fudge)
  if not fudge then fudge = 0.5 end

  if coords then
    for _,C in ipairs(self.coords) do

    end
  else
    if x < self.x1 - fudge then return false end
    if x > self.x2 + fudge then return false end
    if y < self.y1 - fudge then return false end
    if y > self.y2 + fudge then return false end
    return true
  end
end


function spacelib.clear()
  SPACES = {}
end


function spacelib.initial_rect(x1, y1, x2, y2)
  assert(x1 < x2)
  assert(y1 < y2)

  local S = SPACE_CLASS.new("empty")

  S.x1, S.y1 = x1, y1
  S.x2, S.y2 = x2, y2

  table.insert(SPACES, S)
end

