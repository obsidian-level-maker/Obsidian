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

  coords  -- array of { x, y } for edges of this space
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
  local P = { kind=kind, id=Plan_alloc_id("poly"), coords={} }
  table.set_class(P, POLYGON_CLASS)
  return P
end


function POLYGON_CLASS.add_coord(self, x, y)
  table.insert(self.coords, { x=x, y=y })
end


function POLYGON_CLASS.second(self, idx)
  local k = 1 + (idx % #self.coords)

  return self.coords[k].x, self.coords[k].y
end


function POLYGON_CLASS.new_quad(kind, x1, y1, x2, y2)
  assert(x1 < x2)
  assert(y1 < y2)

  local P = POLYGON_CLASS.new(kind)

  P:add_coord(x1, y1)
  P:add_coord(x2, y1)
  P:add_coord(x2, y2)
  P:add_coord(x1, y2)

  P.bx1 = x1 ; P.bx2 = x2
  P.by1 = y1 ; P.by2 = y2

  return P
end


function POLYGON_CLASS.bare_copy(self)
  local P = POLYGON_CLASS.new(self.kind)
  P.post_fab = self.post_fab
  return P
end


function POLYGON_CLASS.copy(self)
  local P = POLYGON_CLASS.new(self.kind)
  
  for _,C in ipairs(self.coords) do
    table.insert(P.coords, table.copy(C))
  end

  P.bx1, P.by1 = self.bx1, self.by1
  P.bx2, P.by2 = self.bx2, self.by2

  P.post_fab = self.post_fab

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
    gui.debugf("  (%d %d)\n", C.x, C.y)
  end
  gui.debugf("}\n")
end


function POLYGON_CLASS.coord_str(self)
  local line = string.format("POLY_%d", self.id)
  for _,C in ipairs(self.coords) do
    line = line .. string.format("  (%d %d)", C.x, C.y)
  end
  return line
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

  assert(self.bx2 > self.bx1 + 0.01)
  assert(self.by2 > self.by1 + 0.01)
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

  P:update_bbox()

  return P
end


function POLYGON_CLASS.to_brush(self, mat)
  local B = {}

  for _,C in ipairs(self.coords) do
    table.insert(B, { x=C.x, y=C.y, tex=mat })
  end

  return B
end


function POLYGON_CLASS.contains(self, x, y, fudge)
  if not fudge then fudge = 0.5 end

  for idx,C in ipairs(self.coords) do
    local d = geom.perp_dist(x, y, C.x, C.y, self:second(idx))
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

  for idx,C in ipairs(self.coords) do
    if other:on_front(C.x, C.y, self:second(idx)) then
      return false
    end
  end

  return true
end


function POLYGON_CLASS.touches(self, other)
  if other.bx2 < self.bx1 - 0.5 then return false end
  if other.bx1 > self.bx2 + 0.5 then return false end
  if other.by2 < self.by1 - 0.5 then return false end
  if other.by1 > self.by2 + 0.5 then return false end

  for idx,C in ipairs(self.coords) do
    if other:on_front(C.x, C.y, self:second(idx), -0.5) then
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

  for idx,C in ipairs(coords) do
    local k = 1 + (idx % #coords)

    local cx2 = coords[k].x
    local cy2 = coords[k].y

    local a = geom.perp_dist(C.x, C.y, px1,py1, px2,py2)
    local b = geom.perp_dist(cx2, cy2, px1,py1, px2,py2)

    local a_side = 0
    local b_side = 0
    
    if a < -0.5 then a_side = -1 end
    if a >  0.5 then a_side =  1 end

    if b < -0.5 then b_side = -1 end
    if b >  0.5 then b_side =  1 end

    if a_side >= 0 then table.insert(self.coords, C) end
    if a_side <= 0 then T:add_coord(C.x, C.y) end

    if a_side ~= 0 and b_side ~= 0 and a_side ~= b_side then
      -- this edge crosses the cutting line --

      -- calc the intersection point
      local along = a / (a - b)

      local ix = C.x + along * (cx2 - C.x)
      local iy = C.y + along * (cy2 - C.y)

      self:add_coord(ix, iy)
         T:add_coord(ix, iy)
    end
  end

--self:dump()
--  T:dump()

  assert(#self.coords >= 3)
  assert(#   T.coords >= 3)

  self:update_bbox()
     T:update_bbox()

  return T
end
  

-----==========================================================-----


SPACE_CLASS = {}

function SPACE_CLASS.new()
  local S = { polys={}, id=Plan_alloc_id("space") }
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


function SPACE_CLASS.tostr(self)
  return string.format("SPACE_%d [%d polys]", self.id, #self.polys)
end


function SPACE_CLASS.dump(self)
  gui.debugf("%s =\n{\n", self:tostr())

  for _,P in ipairs(self.polys) do
    gui.debugf("  %s\n", P:coord_str())
  end

  gui.debugf("}\n")
end


function SPACE_CLASS.initial_rect(self, x1, y1, x2, y2)
  local P = POLYGON_CLASS.new_quad("free", x1,y1, x2,y2)
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


  gui.debugf("\n---- merge test ----\n\n")

  local S = SPACE_CLASS.new()

  S:initial_rect(0, 0, 90, 90)

  gui.debugf("ORIG SPACE:\n\n")

  S.polys[1]:dump()

  local M = POLYGON_CLASS.new("walk")

  M:add_coord(50, 10)
  M:add_coord(80, 20)
  M:add_coord(60, 60)
  M:add_coord(30, 30)

  M:update_bbox()

  gui.debugf("\nMerge with:\n");
  M:dump()

  S:merge(M)

  gui.debugf("\nNEW SPACE:\n\n")

  for _,P in ipairs(S.polys) do
    P:dump()
  end

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

  if #overlaps == 0 then
    table.insert(self.polys, M)
    return
  end

  local final_kind = M.kind

  for _,P in ipairs(overlaps) do
    if M.post_fab and M.post_fab == P.post_fab then
      -- skip test if part of same prefab
    else
--[[
      if not SPACE_CLASS.can_merge(P.kind, M.kind) then
gui.debugf("M.fab_tag:%s  P.fab_tag:%s\n", tostring(M.fab_tag), tostring(P.fab_tag))
gui.debugf("M=\n"); M:dump()
gui.debugf("P=\n"); P:dump()
        error(string.format("Attempt to merge %s space into %s", M.kind, P.kind))
      end
--]]

      -- this is a bit rude, when an AIR space overlaps any WALK space,
      -- then we "upgrade" the new one to be a WALK space.  Otherwise
      -- the AIR space would replace the WALK space (because we never
      -- subdivide the incoming space in M).

      if P.kind == "walk" and M.kind == "air" then
        final_kind = "walk"
      end
    end

    for idx,C in ipairs(M.coords) do
      local x1, y1 = M:second(idx)
      local x2, y2 = C.x, C.y

      if P:line_cuts(x1,y1, x2,y2) then
        local T = P:cut(x1,y1, x2,y2)

        -- T is the piece outside of M
        table.insert(self.polys, T)
      end
    end

    -- at here, P will lie completely inside M
    -- hence we drop P and keep M in the polygon list
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


function SPACE_CLASS.calc_bbox(self)
  local x1, x2 = 9e9, -9e9
  local y1, y2 = 9e9, -9e9

  for _,P in ipairs(self.polys) do
    if P.bx1 < x1 then x1 = P.bx1 end
    if P.bx2 > x2 then x2 = P.bx2 end
    if P.by1 < y1 then y1 = P.by1 end
    if P.by2 > y2 then y2 = P.by2 end
  end

  assert(x2 > x1)
  assert(y2 > y1)

  return x1, y1, x2, y2
end


function POLYGON_CLASS.do_tjunc(self, tx, ty)
  local coords = self.coords
  self.coords = {}

  for idx,C in ipairs(coords) do
    table.insert(self.coords, C)

    local k = 1 + (idx % #coords)

    local x1, y1 = C.x, C.y
    
    local x2 = coords[k].x
    local y2 = coords[k].y

    local d = geom.perp_dist(tx,ty, x1,y1, x2,y2)

    if math.abs(d) < 0.1 then
      local a = geom.along_dist(tx,ty, x1,y1, x2,y2)

      if a > 1 and a < geom.dist(x1,y1, x2,y2)-1 then
        self:add_coord(tx, ty)

        for N = idx+1,#coords do
          table.insert(self.coords, coords[N])
        end

        return
      end
    end
  end
end


function SPACE_CLASS.fix_tjuncs(self)
  for _,P in ipairs(self.polys) do
    for _,O in ipairs(self.polys) do
      if P ~= O and geom.boxes_overlap(P.bx1,P.by1, P.bx2,P.by2,
                                       O.bx1-2,O.by1-2, O.bx2+2,O.by2+2)
      then
        for _,C in ipairs(O.coords) do
          P:do_tjunc(C.x, C.y)
        end
      end
    end
  end
end


function SPACE_CLASS.cut_in_half_X(self, mx)
  -- returns two new spaces: left and right
  
  local left  = SPACE_CLASS.new()  
  local right = SPACE_CLASS.new()

  for _,P in ipairs(self.polys) do
    local N = P:copy()

    if P:line_cuts(mx, 0, mx, 40) then
      local N2 = N:cut(mx, 0, mx, 40)
      table.insert(left.polys,  N2)
      table.insert(right.polys, N)
    elseif P.bx2 < mx+0.5 then
      table.insert(left.polys, N)
    else
      table.insert(right.polys, N)
    end
  end

  return left, right
end


function SPACE_CLASS.cut_in_half_Y(self, my)
  -- returns two new spaces: bottom and top
  
  local bottom = SPACE_CLASS.new()  
  local top    = SPACE_CLASS.new()

  for _,P in ipairs(self.polys) do
    local N = P:copy()

    if P:line_cuts(0, my, 40, my) then
      local N2 = N:cut(0, my, 40, my)
      table.insert(bottom.polys,  N)
      table.insert(top.polys, N2)
    elseif P.by2 < my+0.5 then
      table.insert(bottom.polys, N)
    else
      table.insert(top.polys, N)
    end
  end

  return bottom, top
end


function SPACE_CLASS.raw_union(self, other)
  -- assumes both spaces never overlap anywhere : USE WITH CAUTION
  -- also destroys the other space

  for _,P in ipairs(other.polys) do
    table.insert(self.polys, P)
  end

  other.polys = {}
end


function SPACE_CLASS.intersect_rect(self, x1, y1, x2, y2)
  -- produces a new space by intersecting this space with the
  -- given rectangle.  Coordinates may be NIL, and this means
  -- that coordinate is +/- infinity.

  if not (x1 or y1 or x2 or y2) then
    return self:copy()
  end

  local result = self
  local temp

  -- TODO: optimise this

  if x1 then temp, result = result:cut_in_half_X(x1) end
  if x2 then result, temp = result:cut_in_half_X(x2) end

  if y1 then temp, result = result:cut_in_half_Y(y1) end
  if y2 then result, temp = result:cut_in_half_Y(y2) end

  return result
end

