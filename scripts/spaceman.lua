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

class POLYGON
{
  kind  -- keyword:
        --   "free"   : space is not used, free
        --   "air"    : somewhat free, but disallow solids
        --   "walk"   : player always can walk here
        --
        --   "floor"  : used area, known floor height
        --   "liquid" : used area with a liquid floor
        --   "solid"  : used area, blocks the player

  id  -- identifying number (to help debugging)

  coords  -- array of {x,y,x2,y2} for edges of this space
          -- spaces are always convex, coords go anti-clockwise

  bx1, by1, bx2, by2 -- bounding box
}


class SPACE
{
  polys : array(POLYGON)
}


--------------------------------------------------------------]]

require 'defs'
require 'util'


POLYGON_CLASS = {}

function POLYGON_CLASS.new(kind)
  local P = { kind=kind, id=Plan_alloc_mark(), coords={} }
  table.set_class(P, POLYGON_CLASS)
  return P
end


function POLYGON_CLASS.add_coord(self, x1, y1, x2, y2)
  table.insert(self.coords, { x=x1, y=y1, x2=x2, y2=y2 })
end


function POLYGON_CLASS.new_quad(kind, x1, y1, x2, y2)
  assert(x1 < x2)
  assert(y1 < y2)

  local M = POLYGON_CLASS.new(kind)

  M:add_coord(x1,y1, x2,y1)
  M:add_coord(x2,y1, x2,y2)
  M:add_coord(x2,y2, x1,y2)
  M:add_coord(x1,y2, x1,y1)

  M:update_bbox()

  return M
end


function POLYGON_CLASS.bare_copy(self)
  local P = POLYGON_CLASS.new(self.kind)
  return P
end


function POLYGON_CLASS.copy(self)
  local P = POLYGON_CLASS.new(self.kind)
  
  for _,C in ipairs(self.coords) do
    table.insert(P.coords, table.copy(C))
  end

  P.bx1, P.by1 = self.bx1, self.by1
  P.bx2, P.by2 = self.bx2, self.by2

  return P
end


function POLYGON_CLASS.tostr(self)
  return string.format("POLY_%d %s [%1.1f %1.1f .. %1.1f %1.1f]",
      self.id, self.kind,
      self.bx1 or 0, self.by1 or 0, self.bx2 or 0, self.by2 or 0)
end


function POLYGON_CLASS.dump(self)
  gui.debugf("%s =\n{\n", self:tostr())
  for _,C in ipairs(self.coords) do
    gui.debugf("  (%d %d) .. (%d %d)\n", C.x, C.y, C.x2, C.y2)
  end
  gui.debugf("}\n")
end


function POLYGON_CLASS.update_bbox(self)
  assert(#self.coords > 0)

  self.bx1, self.bx2 = 9e9, -9e9
  self.by1, self.by2 = 9e9, -9e9

  for _,C in ipairs(self.coords) do
    if C.x < self.bx1 then self.bx1 = C.x end
    if C.x > self.bx2 then self.bx2 = C.x end
    if C.y < self.by1 then self.by1 = C.y end
    if C.y > self.by2 then self.by2 = C.y end
  end

  assert(self.bx2 > self.bx1 + 0.001)
  assert(self.by2 > self.by1 + 0.001)
end


function POLYGON_CLASS.calc_mid(self)
  local x = 0
  local y = 0

  for _,C in ipairs(self.coords) do
    x = x + C.x
    y = y + C.y
  end

  local total = #self.coords

  return x / total, y / total
end


function POLYGON_CLASS.from_brush(kind, coords)
  local P = POLYGON_CLASS.new(kind)

  for _,C in ipairs(coords) do
    if C.x then
      P:add_coord(C.x, C.y)
    end
  end

  -- add the x2/y2 values now
  for i = 1,#P.coords do
    local k = 1 + (i % #P.coords)

    P.coords[i].x2 = P.coords[k].x
    P.coords[i].y2 = P.coords[k].y
  end

  P:update_bbox()

  return P
end


function POLYGON_CLASS.to_brush(self, mat)
  local B = {}

  for _,C in ipairs(self, coords) do
    table.insert(B, { x=C.x, y=C.y, mat=mat })
  end

  return B
end


--[[
function POLYGON_CLASS.to_boundary(self, x, y, dx, dy)
  -- starting with a point inside the space, move along the vector in
  -- (dx, dy) until we hit a boundary and return that coordinate.
  -- returns NIL if something goes wrong.

  local x2 = x + dx * 10000
  local y2 = y + dy * 10000

  local best_d

  for _,C in ipairs(self.coords) do
    local a = geom.perp_dist(C.x1, C.y1, x,y,x2,y2)
    local b = geom.perp_dist(C.x2, C.y2, x,y,x2,y2)

    INTERSECTION TEST
  end

  return nil
end
--]]


function POLYGON_CLASS.contains(self, x, y, fudge)
  if not fudge then fudge = 0.5 end

  for _,C in ipairs(self.coords) do
    local d = geom.perp_dist(x, y, C.x,C.y, C.x2,C.y2)
    if d > fudge then return false end
  end

  return true
end


function POLYGON_CLASS.on_front(self, px1, py1, px2, py2, fudge)
  if not fudge then fudge = 0.5 end

  fudge = -fudge
  
  for _,C in ipairs(self.coords) do
    local d = geom.perp_dist(C.x, C.y, px1,py1, px2,py2)
    if d < fudge then return false end
  end

  return true
end


function POLYGON_CLASS.line_cuts(self, px1, py1, px2, py2)
  local front, back

  for _,C in ipairs(self.coords) do
    local d = geom.perp_dist(C.x, C.y, px1,py1, px2,py2)
    if d >  0.5 then front = true end
    if d < -0.5 then  back = true end

    if front and back then return true end
  end

  return false
end


function POLYGON_CLASS.overlaps(self, other)
  -- check bboxes first
  if other.bx2 < self.bx1 + 0.5 then return false end
  if other.bx1 > self.bx2 - 0.5 then return false end
  if other.by2 < self.by1 + 0.5 then return false end
  if other.by1 > self.by2 - 0.5 then return false end

  -- slower method, check if other space lies totally on back side of
  -- one of our edges.

  for _,C in ipairs(self.coords) do
    if other:on_front(C.x, C.y, C.x2, C.y2) then
      return false
    end
  end

  return true
end


function POLYGON_CLASS.surrounds(self, other)
  -- check bboxes first
  if self.bx1 > other.bx1 + 0.5 then return false end
  if self.bx2 < other.bx2 - 0.5 then return false end
  if self.by1 > other.by1 + 0.5 then return false end
  if self.by2 < other.by2 - 0.5 then return false end

  for _,D in ipairs(other.coords) do
    if not self:contains(D.x, D.y) then
      return false
    end
  end

  return true
end


function POLYGON_CLASS.cut(self, px1, py1, px2, py2)
  -- returns the cut-off piece (on back of given line)
  -- NOTE: assumes the line actually cuts the space

  local T = self:bare_copy()

  local coords = self.coords
  self.coords = {}

  local ox, oy -- other intersection point

  for _,C in ipairs(coords) do
    local a = geom.perp_dist(C.x , C.y , px1,py1, px2,py2)
    local b = geom.perp_dist(C.x2, C.y2, px1,py1, px2,py2)

    if a > -0.5 and b > -0.5 then
      table.insert(self.coords, C)
    elseif a < 0.5 and b < 0.5 then
      table.insert(T.coords, C)
    else
      -- this side crosses the cutting line --

      -- calc the intersection point
      local along = a / (a - b)

      local ix = C.x + along * (C.x2 - C.x)
      local iy = C.y + along * (C.y2 - C.y)

      local C1 = { x=C.x, y=C.y, x2=ix,   y2=iy }
      local C2 = { x=ix,  y=iy,  x2=C.x2, y2=C.y2 }

      local N1, N2

      -- new edge along cutting line
      if ox then
        N1 = { x=ix, y=iy, x2=ox, y2=oy }
        N2 = { x=ox, y=oy, x2=ix, y2=iy }
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


SPACE_CLASS = {}

function SPACE_CLASS.new()
  local S = { polys={} }
  table.set_class(S, SPACE_CLASS)
  return S
end


function SPACE_CLASS.copy(self)
  local S = SPACE_CLASS.new()

  for _,P in ipairs(self.polys) do
    table.insert(S.polys, P:copy())
  end

  return S
end


function SPACE_CLASS.initial_rect(self, x1, y1, x2, y2)
  assert(x1 < x2)
  assert(y1 < y2)

  local P = POLYGON_CLASS.new("free")

  P:add_coord(x1, y1, x2, y1)
  P:add_coord(x2, y1, x2, y2)
  P:add_coord(x2, y2, x1, y2)
  P:add_coord(x1, y2, x1, y1)

  P.bx1 = x1 ; P.bx2 = x2
  P.by1 = y1 ; P.by2 = y2

  table.insert(self.polys, P)
end


function SPACE_CLASS.debugging_test()
  LEVEL = {}

  gui.debugf("---- spacelib debugging_test ----\n")

  local S = SPACE_CLASS.new()

  S:initial_rect(0, 100, 300, 200)

  local P1 = S.polys[1]

  P1:dump()

  for x = -50,350,100 do for y = -50,350,50 do
    local c = P1:contains(x, y)
    gui.debugf("%-3d %-3d = %s\n", x, y, sel(c, "INSIDE", "OUTSIDE"))
  end end

  gui.debugf("\n")
  
  for y = -50,250,100 do
    local c = P1:on_front(0, y, 20, y)
    gui.debugf("on_front of (%d %d) .. (%d %d) : %s\n",
               0, y, 20, y, sel(c, "YES", "no"))
  end

  gui.debugf("\n")

  for x = -50,350,100 do
    local c = P1:on_front(x, 0, x, 20)
    gui.debugf("on_front of (%d %d) .. (%d %d) : %s\n",
               x, 0, x, 20, sel(c, "YES", "no"))
  end

  gui.debugf("\n")

  for x = -350,350,50 do
    local c = P1:line_cuts(x, 0, x+20, 20)
    gui.debugf("line_cuts (%d %d) .. (%d %d) : %s\n",
               x, 0, x+20, 20, sel(c, "YES", "no"))
  end

  gui.debugf("\n")

  local T = P1:cut(0, 160, 100, 0)

  P1:dump()
   T:dump()

  error("TEST DONE")
end


function SPACE_CLASS.find_point(self, x, y)
  for _,P in ipairs(self.polys) do
    if P:contains(x, y) then
      return P
    end
  end
  return nil  -- not found
end


--[[
function spacelib.next_space(S, x, y, dx, dy)
  local nx, ny = S:to_boundary(x, y, dx, dy)

  if not nx then return nil end

  nx = nx + dx*2
  ny = ny + dy*2

  return spacelib.find_point(nx, ny), nx, ny
end
--]]


function SPACE_CLASS.can_merge(exist_kind, new_kind)  -- NOT a method
  assert(new_kind ~= "free")

  if exist_kind == "free"  then return true end

  if exist_kind == "solid" then return false end
  if new_kind   == "solid" then return false end

  if exist_kind == "air"  then return true end
  if exist_kind ~= "walk" then return false end

  if new_kind == "liquid" then return false end

  return true
end


function SPACE_CLASS.merge(self, M)
  -- validate our parameter
  assert(M)
  assert(M.coords)
  assert(#M.coords >= 3)

  assert(M.bx1)
  assert(M.bx1 < M.bx2)
  assert(M.by1 < M.by2)

  -- collect overlapping spaces, removing them from main set
  local overlaps = {}

  for i = #self.polys,1,-1 do
    local P = self.polys[i]

    if P:overlaps(M) then
      table.insert(overlaps, P)
      table.remove(self.polys, i)
    end
  end

  assert(#overlaps > 0)

  local final_kind = M.kind

  for _,P in ipairs(overlaps) do
    if not SPACE_CLASS.can_merge(P.kind, M.kind) then
      error(string.format("Attempt to merge %s space into %s", M.kind, P.kind))
    end

    -- this is a bit rude, when an AIR space overlaps any WALK space,
    -- then we "upgrade" the new one to be a WALK space.  Otherwise
    -- the AIR space would replace the WALK space (because we never
    -- subdivide the incoming space in M).

    if P.kind == "walk" and M.kind == "air" then
      final_kind = "walk"
    end

    for _,C in ipairs(M.coords) do
      if P:line_cuts(C.x2,C.y2, C.x,C.y) then
        local T = P:cut(C.x2,C.y2, C.x,C.y)

        -- T is the piece outside of M
        table.insert(self.polys, T)
      end
    end

    -- at here, S will lie completely inside M
    -- hence we drop S and keep M in the polygon list
  end

  M.kind = final_kind 

  table.insert(self.polys, M)
end


function SPACE_CLASS.test(self, M, keep_air)
  -- dry-run of doing a merge()
  --
  -- returns NIL on success, otherwise the kinds of the conflicting
  -- spaces (existing first, new one second).
  --
  -- with 'keep_air' is true, this fails if an AIR space would overlap
  -- any WALK spaces.

  for _,P in ipairs(self.polys) do
    if P:overlaps(M) then
      if not SPACE_CLASS.can_merge(P.kind, M.kind) then
        return P.kind, M.kind
      end

      if keep_air and P.kind == "walk" and M.kind == "air" then
        return P.kind, M.kind
      end
    end
  end

  return nil
end


function SPACE_CLASS.find_overlaps(self, M)
  local list = {}

  for _,P in ipairs(self.polys) do
    if P:overlaps(M) then
      table.insert(list, P)
    end
  end
 
  return list
end

