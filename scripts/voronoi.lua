----------------------------------------------------------------
-- VORONOI TESSELATOR
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2009 Andrew Apted
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


--============
--   NOTES
--============
-- 
-- This is Fortune's Algorithm for constructing the Voronoi
-- diagram from a set of points.
--
-- One difference is that I construct polygons by storing the
-- generated vertices with each site.  Infinite half-edges are
-- clipped to the bounding box (which is passed as a parameter),
-- and the corners of the bbox must be handled too.
--
-- STRUCTURES:
--
--   bbox  = { x1, y1, x2, y2 }
--   point = { x, y, verts, edges }
--   vert  = { x, y }
--   edge  = { p1, p2, v1, v2 }   -- p2 is nil for edges on bbox
--
--   arc    = { p, x1, x2 }
--   circle = { x, y, r }


function voronoi_tesselate(bbox, points)

  local function find_closest_point(x, y)
    local best
    local best_dist = 9e9

    for _,P in ipairs(points) do
      local dx = P.x - x
      local dy = P.y - y
      local dist = dx * dx + dy * dy

      if dist < best_dist then
        best = P
        best_dist = dist
      end
    end

    return best
  end

  function add_corner_point(x, y)
    local p = find_closest_point(x, y)

    local v = { x=x, y=y, corner=true }

    table.insert(p.verts, v)
  end


  --=-==| voronoi_tesselate |===---

  -- setup points
  for _,P in ipairs(points) do
    P.verts = {}
    P.edges = {}
    assert(bbox.x1 < P.x and P.x < bbox.x2)
    assert(bbox.y1 < P.y and P.y < bbox.y2)
  end

  -- handle corners
  add_corner_point(bbox.x1, bbox.y1)
  add_corner_point(bbox.x2, bbox.y1)
  add_corner_point(bbox.x1, bbox.y2)
  add_corner_point(bbox.x2, bbox.y2)

  -- ....
end

