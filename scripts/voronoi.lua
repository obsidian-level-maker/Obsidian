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
-- diagram from a set of points.  This version sweeps downwards
-- (instead of left to right).
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
--   arc    = { p }
--   circle = { x, y, r, circle=true }


function voronoi_tesselate(bbox, points)

  local events
  local beach

  local function dist_squared(x1, y1, x2, y2)
    x2 = x2 - x1
    y2 = y2 - y1
    return x2 * x2 + y2 * y2
  end

  local function parabola_dist_from_line(p, qx, line_y)
    local px = p.x - qx
    local py = p.y - line_y
    assert(py > 0)

    -- parabola invariant: dist(p->q) = dist(q->line)
    -- Hence (px-qx)^2 + (py-qy)^2 = qy^2
    -- Therefore qy = ((px-qx)^2 + py^2) / 2py

    return math.sqrt(px * px + py * py) / (2 * py)
  end

  local function find_closest_point(x, y)
    local best
    local best_dist = 9e9

    for _,P in ipairs(points) do
      local dist = dist_squared(x, y, P.x, P.y)
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

  function invalidate_circles(P)
    -- circles must be empty (contain no points).
    -- This checks to see if the new point is inside a circle

    for i = #events,1,-1 do  -- must traverse backwards
      local E = events[i]
      if E.circle and dist_squared(E.x, E.y, P.x, P.y) + 0.01 < (E.r * E.r) then
        table.remove(events, i)
      end
    end
  end

  function check_for_new_circles()
    -- TODO
  end

  function new_arc(P)
    local arc = { p=P }

    local N = #beach

    if N == 0 then
      table.insert(beach, arc)
      return
    end

    -- FIXME: this cannot handle two points at same Y

    -- find the existing arc which is split by the new one
    local split
    local best_dist = 9e9

    for idx,A in ipairs(beach) do  -- TODO: skip points already seen
      if A.p.y < P.y + 0.01 then
        -- skip points on same line as new point
      else
        local dist = parabola_dist_from_line(A.p, P.x, P.y)
        if dist < best_dist then
          split = idx
          best_dist = dist
        end
      end
    end

    assert(split)

    table.insert(beach, split, arc)
    table.insert(beach, split, beach[split+1])
  end

  function new_vertex(C)
    local visited = {}
    for _,arc in ipairs(beach) do
      if not visited[arc.p] then
        local v = { x=C.x, y=C.y }
        table.insert(arc.p.verts, v)
        visited[arc.p] = true
      end
    end
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

  -- create event list and beach line
  events = shallow_copy(points)
  beach  = { }

  table.sort(events, function (A,B) return A.y > B.y end)

  -- LOOP
  while events[1] do
    local E = table.remove(events, 1)

    if E.circle then
      new_vertex(E)
    else
      new_arc(E)
      invalidate_circles(E)
    end
  end
end

