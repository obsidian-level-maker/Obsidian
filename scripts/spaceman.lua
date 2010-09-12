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
  kind  -- keyword:
        --   "empty" : space is not used, free
        --   "floor" : area with known floor height
        --   "walk"  : player always can walk here
        --   "solid" : for walls, stairs, lifts, decoration

  id  -- identifying number (to help debugging)

  coords  -- array of {x1,y1,x2,y2} for edges of this space
          -- spaces are always convex, coords go anti-clockwise

  bx1, by1, bx2, by2 -- bounding box

  floor_h -- height for "floor" kind
}


--------------------------------------------------------------]]

require 'defs'
require 'util'


spacelib = {}


SPACE_CLASS = {}

function SPACE_CLASS.new(kind)
  local S = { kind=kind, id=Plan_alloc_mark() }
  table.set_class(S, SPACECLASS)
  return S
end


function SPACE_CLASS.tostr(self)
  return string.format("SPACE_%d %s [%d %d .. %d %d]",
      self.id, self.kind,
      self.bx1, self.by1, self.bx2, self.by2)
end

function SPACE_CLASS.dump(self)
  gui.debugf("%s =\n{\n", self:tostr())
  for _,C in ipairs(self.coords) do
    gui.debugf("  (%d %d) .. (%d %d)\n", C.x1, C.y1, C.x2, C.y2)
  end
  gui.debugf("}\n")
end


function SPACE_CLASS.update_bbox(self)
  assert(#self.coords > 0)

  self.bx1, self.by1 =  9e9
  self.bx2, self.by2 = -9e9

  for _,C in ipairs(self.coords) do
    if C.x1 < self.bx1 then self.bx1 = C.x1 end
    if C.x1 > self.bx2 then self.bx2 = C.x2 end
    if C.y1 < self.by1 then self.by1 = C.y1 end
    if C.y1 > self.by2 then self.by2 = C.y2 end
  end
end


function SPACE_CLASS.contains(self, x, y, fudge)
  if not fudge then fudge = 0.5 end

  for _,C in ipairs(self.coords) do
    local d = geom.perp_dist(x, y, C.x1,C.y1, C.x2,C.y2)
    if d > fudge then return false end
  end

  return true
end


function SPACE_CLASS.overlaps(self, other)
  -- check bboxes first
  if other.bx2 < self.bx1 + 0.5 then return false end
  if other.bx1 > self.bx2 - 0.5 then return false end
  if other.by2 < self.by1 + 0.5 then return false end
  if other.by1 > self.by2 - 0.5 then return false end

  -- FIXME

  return true
end


function SPACE_CLASS.surrounds(self, other)
  -- check bboxes first
  if self.bx1 > other.bx1 + 0.5 then return false end
  if self.bx2 < other.bx2 - 0.5 then return false end
  if self.by1 > other.by1 + 0.5 then return false end
  if self.by2 < other.by2 - 0.5 then return false end

  if self.coords then
    for _,D in ipairs(other.coords) do
      if not self:contains(D.x1, D.y1) then return false end
    end
  end

  return true
end
  


function spacelib.clear()
  SPACES = {}
end


function spacelib.initial_rect(x1, y1, x2, y2)
  assert(x1 < x2)
  assert(y1 < y2)

  local S = SPACE_CLASS.new("empty")

  S.coords =
  {
    { x1=x1, y1=y1, x2=x2, y2=y1 },
    { x1=x2, y1=y1, x2=x2, y2=y2 },
    { x1=x2, y1=y2, x2=x1, y2=y2 },
    { x1=x1, y1=y2, x2=x1, y2=y1 },
  }

  S.bx1 = x1 ; S.bx2 = x2
  S.by1 = y1 ; S.by2 = y2

  table.insert(SPACES, S)
end


function spacelib.find_point(x, y)
  for _,S in ipairs(SPACES) do
    if S:contains(x, y) then
      return S
    end
  end
  return nil  -- not found
end

