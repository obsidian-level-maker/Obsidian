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


function voronoi_tesselate(bbox, points)

  for _,P in ipairs(points) do
    P.verts = {}
    assert(bbox.x1 < P.x and P.x < bbox.x2)
    assert(bbox.y1 < P.y and P.y < bbox.y2)
  end

  -- ....
end

