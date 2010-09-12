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
  table.set_class(S, SPACE_CLASS)
  return S
end

function SPACE_CLASS.bare_copy(other)
  local S = SPACE_CLASS.new(other.kind)
  S.floor_h = other.floor_h
  return S
end


function SPACE_CLASS.tostr(self)
  return string.format("SPACE_%d %s [%d %d .. %d %d]",
      self.id, self.kind,
      self.bx1 or 0, self.by1 or 0, self.bx2 or 0, self.by2 or 0)
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

  self.bx1, self.bx2 = 9e9, -9e9
  self.by1, self.by2 = 9e9, -9e9

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

function SPACE_CLASS.on_front(self, px1, py1, px2, py2, fudge)
  if not fudge then fudge = 0.5 end

  fudge = -fudge
  
  for _,C in ipairs(self.coords) do
    local d = geom.perp_dist(C.x1, C.y1, px1,py1, px2,py2)
    if d < fudge then return false end
  end

  return true
end

function SPACE_CLASS.line_cuts(self, px1, py1, px2, py2)
  local front, back

  for _,C in ipairs(self.coords) do
    local d = geom.perp_dist(C.x1, C.y1, px1,py1, px2,py2)
    if d >  0.5 then front = true end
    if d < -0.5 then  back = true end

    if front and back then return true end
  end

  return false
end


function SPACE_CLASS.overlaps(self, other)
  -- check bboxes first
  if other.bx2 < self.bx1 + 0.5 then return false end
  if other.bx1 > self.bx2 - 0.5 then return false end
  if other.by2 < self.by1 + 0.5 then return false end
  if other.by1 > self.by2 - 0.5 then return false end

  -- slower method, check if other space lies totally on back side of
  -- one of our edges.

  for _,C in ipairs(self.coords) do
    if other:on_front(C.x1, C.y1, C.x2, C.y2) then
      return false
    end
  end

  return true
end


function SPACE_CLASS.surrounds(self, other)
  -- check bboxes first
  if self.bx1 > other.bx1 + 0.5 then return false end
  if self.bx2 < other.bx2 - 0.5 then return false end
  if self.by1 > other.by1 + 0.5 then return false end
  if self.by2 < other.by2 - 0.5 then return false end

  for _,D in ipairs(other.coords) do
    if not self:contains(D.x1, D.y1) then
      return false
    end
  end

  return true
end


function SPACE_CLASS.cut(self, px1, py1, px2, py2)
  -- returns the cut-off piece (on back of given line)
  -- NOTE: assumes the line actually cuts the space

  local T = SPACE_CLASS.bare_copy(self)

  local coords = self.coords

  self.coords = {}
     T.coords = {}

  local ox, oy -- other intersection point

  for _,C in ipairs(coords) do
    local a = geom.perp_dist(C.x1, C.y1, px1,py1, px2,py2)
    local b = geom.perp_dist(C.x2, C.y2, px1,py1, px2,py2)

    if a > -0.5 and b > -0.5 then
      table.insert(self.coords, C)
    elseif a < 0.5 and b < 0.5 then
      table.insert(T.coords, C)
    else
      -- this side crosses the cutting line --

      -- calc the intersection point
      local along = a / (a - b)

      local ix = C.x1 + along * (C.x2 - C.x1)
      local iy = C.y1 + along * (C.y2 - C.y1)

      local C1 = { x1=C.x1, y1=C.y1, x2=ix, y2=iy }
      local C2 = { x2=C.x2, y2=C.y2, x1=ix, y1=iy }

      local N1, N2

      -- new edge along cutting line
      if ox then
        N1 = { x1=ix, y1=iy, x2=ox, y2=oy }
        N2 = { x2=ix, y2=iy, x1=ox, y1=oy }
      end

      -- destinations for new edges
      local D1 = T.coords
      local D2 = self.coords

      if a >= 0 then D1, D2 = D2, D1 end

      table.insert(D1, C1)
      if ox then
        table.insert(D1, N1)
        table.insert(D2, N2)
      end
      table.insert(D2, C2)

      if not ox then ox, oy = ix, iy end
    end
  end

  self:update_bbox()
     T:update_bbox()

  return T
end
  

-----==========================================================-----


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


function spacelib.test_stuff()
  LEVEL = {}

  gui.debugf("spacelib test_stuff\n")

  spacelib.clear()
  spacelib.initial_rect(0, 100, 300, 200)

  SPACES[1]:dump()

  for x = -50,350,100 do for y = -50,350,50 do
    local c = SPACES[1]:contains(x, y)
    gui.debugf("%-3d %-3d = %s\n", x, y, sel(c, "INSIDE", "OUTSIDE"))
  end end

  gui.debugf("\n")
  
  for y = -50,250,100 do
    local c = SPACES[1]:on_front(0, y, 20, y)
    gui.debugf("on_front of (%d %d) .. (%d %d) : %s\n",
               0, y, 20, y, sel(c, "YES", "no"))
  end

  gui.debugf("\n")

  for x = -50,350,100 do
    local c = SPACES[1]:on_front(x, 0, x, 20)
    gui.debugf("on_front of (%d %d) .. (%d %d) : %s\n",
               x, 0, x, 20, sel(c, "YES", "no"))
  end

  gui.debugf("\n")

  for x = -350,350,50 do
    local c = SPACES[1]:line_cuts(x, 0, x+20, 20)
    gui.debugf("line_cuts (%d %d) .. (%d %d) : %s\n",
               x, 0, x+20, 20, sel(c, "YES", "no"))
  end

  gui.debugf("\n")

  local T = SPACES[1]:cut(0, 160, 100, 0)

  SPACES[1]:dump()
          T:dump()

  error("TEST DONE")
end


