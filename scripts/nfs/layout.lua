------------------------------------------------------------------------
--  GENERATE 2D LAYOUT
------------------------------------------------------------------------
--
--  RandTrack : track generator for NFS1 (SE)
--
--  Copyright (C) 2014-2015 Andrew Apted
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 3
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this software.  If not, please visit the following
--  web page: http://www.gnu.org/licenses/gpl.html
--
------------------------------------------------------------------------


--
-- NOTES :
--
-- All pieces start at coordinate (0, 0) going due north.
-- That point is implied in the points[] list.
--
-- The list of points form bezier splines, where the control points
-- are computed based on the angles at each point.
--
-- Angles are: 0 = north, 90 = east, -90 = west, 180 = south.
--

PIECES = {}


PIECES.begin_1 =
{
  -- begin pieces are only used at start of track
  begin_prob = 50

  curviness = 0

  points =
  {
    { x=0, y=8,  ang=0 }
    { x=0, y=16, ang=0 }
    { x=0, y=24, ang=0 }
    { x=0, y=32, ang=0 }
  }
}


PIECES.straight_1 =
{
  prob = 40

  curviness = 0

  points =
  {
    { x=0, y=5, ang=0 }
  }
}


PIECES.straight_2 =
{
  prob = 150

  curviness = 0

  points =
  {
    { x=0, y=15, ang=0 }
  }
}


PIECES.straight_3 =
{
  prob = 20

  curviness = 0

  points =
  {
    { x=0, y=15, ang=0 }
    { x=0, y=30, ang=0 }
  }
}


PIECES.small_curve_30 =
{
  prob = 20

  curviness = 1

  points =
  {
    { x=1.5, y=5, ang=30 }
  }
}


PIECES.small_curve_70 =
{
  prob = 12

  curviness = 2

  points =
  {
    { x=3, y=5, ang=70 }
  }
}


PIECES.curve_30 =
{
  prob = 80

  curviness = 1

  points =
  {
    { x=3.5, y=15, ang=30 }
  }
}


PIECES.curve_70 =
{
  prob = 60

  curviness = 2

  points =
  {
    { x=9, y=15, ang=70 }
  }
}


PIECES.curve_90 =
{
  prob = 40

  curviness = 3

  points =
  {
    { x=12, y=12, ang=90 }
  }
}


PIECES.curve_120 =
{
  prob = 40

  curviness = 3

  points =
  {
    { x=15, y=5, ang=120 }
  }
}


------------------------------------------------------------------------


function approx_track_length()
  --
  -- we don't have bezier control points while constructing the
  -- track, hence this only measures the lines between the node
  -- points.
  --
  -- for closed tracks, does NOT include last node --> first node
  -- (we assume they will become the same coordinate)
  --
  local points = TRACK.points

  local length = 0

  for i = 1, #points - 1 do
    local P1 = points[i]
    local P2 = points[i + 1]

    length = length + geom.dist(P1.x, P1.y, P2.x, P2.y)
  end

  return length
end



function reconstruct_points()
  TRACK.points = {}

  each piece in TRACK.pieces do
    each P in piece.points do
      table.insert(TRACK.points, P)
    end
  end
end



function add_bezier_controls()
  --
  -- compute bezier control points (from angle information)
  --
  local points = TRACK.points

  TRACK.old_points = points

  TRACK.points = {}


  local function calc_intersection(P1, P2)
    local ax1 = P1.x
    local ay1 = P1.y
    local ax2, ay2 = geom.polar_coord(ax1, ay1, P1.ang, 64)

    local bx1 = P2.x
    local by1 = P2.y
    local bx2, by2 = geom.polar_coord(bx1, by1, P2.ang, 64)

    local k1 = geom.perp_dist(bx1, by1, ax1,ay1,ax2,ay2)
    local k2 = geom.perp_dist(bx2, by2, ax1,ay1,ax2,ay2)

    -- straight line?
    if math.abs(k1 - k2) < 1 then
      local ix = (ax1 + bx1) / 2
      local iy = (ay1 + by1) / 2

      return ix, iy
    end

    local d = k1 / (k1 - k2)

    local ix = bx1 + d * (bx2 - bx1)
    local iy = by1 + d * (by2 - by1)

    return ix, iy
  end


  for i = 1, #points - 1 do
    local P1 = points[i]
    local P2 = points[i + 1]

    table.insert(TRACK.points, P1)

    local ix, iy = calc_intersection(P1, P2)

    table.insert(TRACK.points, { x=ix, y=iy })
  end

  table.insert(TRACK.points, points[#points])
end



function subdivide_beziers(min_len)
  --
  -- Here we divide each bezier curve of a minimum length into two
  -- smaller ones.  This can be repeated several times.
  --
  -- (this must be done _after_ computing the control points)
  --

  local points = TRACK.points

  TRACK.points = {}

  for i = 1, #points-2, 2 do
    local P1 = points[i]
    local C  = points[i + 1]
    local P2 = points[i + 2]

    table.insert(TRACK.points, P1)

    if geom.dist(P1.x, P1.y, P2.x, P2.y) < min_len then
      table.insert(TRACK.points, C)
      continue
    end

    local ax = (P1.x + C.x) / 2
    local ay = (P1.y + C.y) / 2

    local bx = (P2.x + C.x) / 2
    local by = (P2.y + C.y) / 2

    local mx = (ax + bx) / 2
    local my = (ay + by) / 2

    table.insert(TRACK.points, { x=ax, y=ay })
    table.insert(TRACK.points, { x=mx, y=my })
    table.insert(TRACK.points, { x=bx, y=by })
  end

  table.insert(TRACK.points, points[#points])

  return TRACK.points
end



function accurate_curve_length(sx,sy, cx,cy, ex,ey, deep)
  if deep >= 6 then
    return geom.dist(sx,sy, ex,ey)
  end

  local ax = (sx + cx) / 2
  local ay = (sy + cy) / 2

  local bx = (ex + cx) / 2
  local by = (ey + cy) / 2

  local mx = (ax + bx) / 2
  local my = (ay + by) / 2

  local len1 = accurate_curve_length(sx,sy, ax,ay, mx,my, deep + 1)
  local len2 = accurate_curve_length(mx,my, bx,by, ex,ey, deep + 1)

  return len1 + len2
end



function accurate_track_length()
  --
  -- measures the final track length, after the bezier control points
  -- have been added (and possibly sub-divided).
  --
  local points = TRACK.points


  local length = 0

  for i = 1, #points - 2, 2 do
    local P1 = points[i]
    local C  = points[i + 1]
    local P2 = points[i + 2]

    length = length + accurate_curve_length(P1.x,P1.y, C.x,C.y, P2.x,P2.y, 1)
  end

  return length
end



local function adjust_angles(delta_ang)
  --
  -- spread the angle difference over most of the track
  -- (we skip the start area, which must remain straight).
  --
  -- we do this by converting the points to a pure angle/length form,
  -- apply the differences to that form, then convert everything back.
  --
  -- NOTE : not currently used.
  --
  local points = TRACK.points

  local function convert_to_polar()
    for i = 1, #points - 1 do
      local P1 = points[i]
      local P2 = points[i + 1]

      local dist = geom.dist(P1.x, P1.y, P2.x, P2.y)
      local ang  = geom.delta_to_angle(P2.x - P1.x, P2.y - P1.y)

      P1.pol_dist = dist
      P1.pol_ang  = assert(ang)
    end
  end


  local function recode_from_polar()
    for i = 1, #points - 1 do
      local P1 = points[i]
      local P2 = points[i + 1]

      local nx, ny = geom.polar_coord(P1.x, P1.y, P1.pol_ang, P1.pol_dist)

      P2.x = nx
      P2.y = ny

      P1.pol_dist = nil
      P1.pol_ang  = nil
    end
  end


  local function total_weight(start)
    local weight = 0

    for i = start, #points - 1 do
      local P1 = points[i]
      local P2 = points[i + 1]

      weight = weight + P1.pol_dist
    end

    return weight
  end


  local function apply_differences(start, total_w)
    local weight = 0

    for i = start, #points - 1 do
      local P1 = points[i]
      local P2 = points[i + 1]

      weight = weight + P1.pol_dist

      P1.pol_ang = P1.pol_ang + delta_ang * weight / total_w
    end
  end


  ---| adjust_angles |---

  convert_to_polar()

  local start_idx = int(#points / 5)

  local total_w = total_weight(start_idx)
  assert(total_w > 1)

  apply_differences(start_idx, total_w)

  recode_from_polar()
end



local function adjust_positions(delta_x, delta_y)
  --
  -- spread the position difference over most of the track, so that
  -- the last node becomes the same as the first.
  --
  -- (we do not modify the start area, which must remain straight).
  --
  local points = TRACK.points

  local function total_weight(start)
    local weight = 0

    for i = start, #points - 1 do
      local P1 = points[i]
      local P2 = points[i + 1]

      weight = weight + geom.dist(P1.x, P1.y, P2.x, P2.y)

      P1.weight = weight
    end

    return weight
  end


  local function apply_differences(start, total_w)
    local weight = 0

    for i = start, #points - 1 do
      local P1 = points[i]
      local P2 = points[i + 1]

      P2.x = P2.x + delta_x * P1.weight / total_w
      P2.y = P2.y + delta_y * P1.weight / total_w

      P1.weight = nil
    end
  end


  ---| adjust_positions |---

  local start_idx = int(#points / 5)

  local total_w = total_weight(start_idx)
  assert(total_w > 1)

  apply_differences(start_idx, total_w)
end



function check_segment_overlaps(nx1,ny1, nx2, ny2, is_first)
  --
  -- test if a new segment would overlap part of the existing track.
  --
  -- we pretend all segments are actually circles!
  --
  local extra_space = 2

  local n_rad = geom.dist(nx1, ny1, nx2, ny2) / 2
  local n_mx  = (nx1 + nx2) / 2
  local n_my  = (ny1 + ny2) / 2

  local end_idx = #TRACK.points

  -- allow new piece to join onto existing track
  if is_first then
    end_idx = end_idx - 1
  end

  for i = 1, end_idx - 1 do
    local P1 = TRACK.points[i]
    local P2 = TRACK.points[i + 1]

    local p_rad = geom.dist(P1.x, P1.y, P2.x, P2.y) / 2
    local p_mx = (P1.x + P2.x) / 2
    local p_my = (P1.y + P2.y) / 2

    local dist = geom.dist(p_mx, p_my, n_mx, n_my)

    if dist < p_rad + n_rad + extra_space then
      return true
    end
  end

  return false -- no overlap
end



local function check_inside_donut(x1, y1, x2, y2)
  local mid_x = TRACK.donut.mid_x

  local inner_r = TRACK.donut.inner_r
  local outer_r = TRACK.donut.outer_r

  local d = geom.dist(mid_x, 0, x2, y2)

  if d < inner_r then return false end
  if d > outer_r then return false end


  -- test a mid point too
  local mx = (x1 + x2) / 2
  local my = (y1 + y2) / 2

  local d2 = geom.dist(mid_x, 0, mx, my)

  if d2 < inner_r then return false end


  -- prevent crossing X axis on left side
  if x1 < mid_x then
    if math.abs(y2) < 5 then return false end

    if y1 < 0 and y2 > 0 then return false end
    if y1 > 0 and y2 < 0 then return false end
  end

  return true
end



function add_piece_to_track(info, mirror, scale, TEST_ONLY)
  local origin = table.last(TRACK.points)

  local last_x = origin.x
  local last_y = origin.y

  local new_piece
  if not TEST_ONLY then
    new_piece = { info=info, points={} }
    table.insert(TRACK.pieces, new_piece)
  end

  each P in info.points do
    local px   = scale * sel(mirror, - P.x,   P.x)
    local py   = scale * P.y 
    local pang = sel(mirror, - P.ang, P.ang)

    local dx, dy = geom.rotate_vec(px, py, origin.ang)

    local nx = origin.x + dx
    local ny = origin.y + dy
    local n_ang = origin.ang + pang

    if TEST_ONLY then
      -- bounds check
      if TRACK.bbox then
        if nx < TRACK.bbox.x1 or nx > TRACK.bbox.x2 then return false end
        if ny < TRACK.bbox.y1 or ny > TRACK.bbox.y2 then return false end
      end
  
      -- on closed tracks, coordinate is restricted to a donut shape
      if TRACK.donut then
        if not check_inside_donut(last_x, last_y, nx, ny) then
          return false
        end
      end

      local is_first = (_index == 1)

      if check_segment_overlaps(last_x, last_y, nx, ny, is_first) then
        return false
      end

    else
      local N = { x=nx, y=ny, ang=n_ang }

      table.insert(new_piece.points, N)
      table.insert(TRACK.points, N)
    end

    last_x = nx
    last_y = ny
  end

  return true  -- OK --
end



function add_adjustment_piece()
  --
  -- adds a piece to the closed track to bring the final angle to be
  -- exactly 360 degrees.
  --

  local final_P = table.last(TRACK.points)

  local diff_ang = 360 - final_P.ang
  local mirror   = false

  if diff_ang < 0 then
    diff_ang = - diff_ang
    mirror   = true
  end

  assert(diff_ang <= 90)

  if diff_ang < 0.1 then
    -- nothing needed
    return
  end

  -- construct the piece

  local PIECE =
  {
    points =
    {
      {
        x = diff_ang / 9
        y = 10
        ang = diff_ang
      }
    }
  }

  local scale = 1
  if diff_ang > 45 then
    scale = scale + (diff_ang - 45) / 45
  end

  add_piece_to_track(PIECE, mirror, scale)

-- debugging...
--[[
  final_P = table.last(TRACK.points)
  stderrf("\n***  FINAL ANGLE AFTER ADJUST PIECE --> %1.4f\n\n", final_P.ang)
--]]
end



function set_high_water_mark()
  TRACK.water_mark = #TRACK.pieces
end



function do_backtracking(steps)
  for i = 1, steps do
    -- never go past the high water mark
    -- (e.g. prevents removing the ORIGIN and BEGIN pieces)
    if #TRACK.pieces <= TRACK.water_mark then
      break;
    end

    table.remove(TRACK.pieces)
  end

  reconstruct_points()
end



function test_if_long_enough()
  TRACK.approx_len = approx_track_length()

  return TRACK.approx_len > TRACK.want_length
end



function test_if_acceptable()
  -- open roads don't have any angle/position requirements
  if TRACK.open then
    return true
  end


  -- for closed tracks, final angle must be in a certain range,
  -- and final position must be not too far away from the origin

  local final_P = table.last(TRACK.points)


  debugf("  final pos: (%d %d) angle %d\n", final_P.x, final_P.y, final_P.ang)


  if final_P.ang < 270 or final_P.ang > 450 then
    debugf("  FAILED, final angle out of range (%d)\n", final_P.ang)
    return false
  end


  local right_x = TRACK.donut.mid_x + TRACK.donut.inner_r
  local top_y   = -5

  if final_P.x > right_x or final_P.y > top_y then
    debugf("  FAILED, final position too far away (%d %d)\n", final_P.x, final_P.y)
    return false
  end

  return true
end



function collect_usable_pieces(reqs)
  --
  -- Select next piece to use.
  --
  -- The 'reqs' parameter is a table of requirements for the piece:
  --    begin   :  if set, piece must be a beginning piece
  --    curved  :  if set, piece must have curviness > 0
  --

  local tab = {}

  local function prob_for_piece(piece)
    if reqs.curved and piece.curviness == 0 then
      return 0
    end

    local prob

    if reqs.begin then
      prob = piece.begin_prob
    else
      prob = piece.prob
    end

    if not prob then return 0 end

    -- in OPEN tracks, more preference for straights and low curviness
    if TRACK.open then
      if piece.curviness  > 2 then prob = prob / 8 end
      if piece.curviness == 2 then prob = prob / 2 end
    end

    -- TODO : other requirements

    -- TODO : adjust for user settings [curviness]

    return prob
  end


  ---| collect_usable_pieces |---

  each name, piece in PIECES do
    local prob = prob_for_piece(piece)

    if prob > 0 then
      tab[name] = prob
    end
  end

  return tab
end



function dump_pieces()
  each piece in TRACK.pieces do
    if piece.info then
      printf("  [%d] : %s\n", _index, piece.info.name)
    end
  end
end



function adjust_track()

  if TRACK.closed then
    -- for closed circuits we must adjust the track to make the
    -- final point be at same position and angle as first point.

    -- this takes care of the angle, positions are done a bit later
    add_adjustment_piece()
  end


  add_bezier_controls()

  for sub_loop = 1, 3 do
    subdivide_beziers(1)
  end


  if TRACK.closed then
    -- now fix the positions

    -- NOTE : we keep the final point in TRACK.points[]
    --        (it is more useful in than out)

    local final_P = table.last(TRACK.points)

    local delta_x = 0 - final_P.x
    local delta_y = 0 - final_P.y

    adjust_positions(delta_x, delta_y)
  end
end



function check_track_overlaps_itself()
  --
  -- After adjusting positions of a closed track, we sometimes get a track
  -- which overlaps itself (even though the un-adjusted track never did).
  -- This function detects this situation (so we can build another).
  --
  -- For NFS1 this is not strictly necessary, an overlapping track is still
  -- playable, albeit often with some visual glitches.  But for other games
  -- this will be necessary.
  --
  -- To make this checking significantly faster, we group the track segments
  -- into a quadtree structure, which greatly reduces the number of seg-seg
  -- pairs we need to check.
  --
  -- NOTE : we only detect actual overlap (segments crossing), but not
  --        track getting too close to itself.
  --

  local bbox
  local quad_tree
  local all_lines

  local leaf_stat = 0
  local compare_stat = 0

  local epsilon = 0.05


  local function calc_bbox()
    bbox = geom.bbox_new()

    each P in TRACK.points do
      geom.bbox_add_point(bbox, P.x, P.y)
    end

    assert(bbox.x1 < bbox.x2)
    assert(bbox.y1 < bbox.y2)

    printf("Track Bounds : (%1.1f %1.1f) --> (%1.1f %1.1f)\n",
           bbox.x1, bbox.y1, bbox.x2, bbox.y2)
  end


  local function create_quad_tree(x1, y1, x2, y2)
    -- leaf?
    if (x2 - x1) < 8 and (y2 - y1) < 8 then
      leaf_stat = leaf_stat + 1
      return { lines={} }
    end

    local N =
    {
      mx = (x1 + x2) / 2
      my = (y1 + y2) / 2

      lines = {}
    }

    -- Bottom Left ... Top Right

    N.BL = create_quad_tree(  x1,   y1, N.mx, N.my)
    N.BR = create_quad_tree(N.mx,   y1,   x2, N.my)
    N.TL = create_quad_tree(  x1, N.my, N.mx,   y2)
    N.TR = create_quad_tree(N.mx, N.my,   x2,   y2)

    return N
  end


  local function create_lines()
    all_lines = {}

    for i = 1, #TRACK.points - 1 do
      local P1 = TRACK.points[i]
      local P2 = TRACK.points[i + 1]

      local L =
      {
        x1 = P1.x
        y1 = P1.y
        x2 = P2.x
        y2 = P2.y
      }

      table.insert(all_lines, L)
    end

    -- mark which lines join each other

    for k = 1, #all_lines do
      local L = all_lines[k]

      if k > 1 then
        L.before = all_lines[k - 1]
      else
        L.before = all_lines[#all_lines]
      end

      if k < #all_lines then
        L.after = all_lines[k + 1]
      else
        L.after = all_lines[1]
      end
    end
  end


  local function add_line_to_node(L, N)
    -- leaf?
    if not N.BL then
      table.insert(N.lines, L)
      return
    end

    -- see if the line fits inside a child node

    local bx1 = math.min(L.x1, L.x2) - epsilon * 2
    local by1 = math.min(L.y1, L.y2) - epsilon * 2
    local bx2 = math.max(L.x1, L.x2) + epsilon * 2
    local by2 = math.max(L.y1, L.y2) + epsilon * 2

    if bx2 < N.mx and by2 < N.my then
      add_line_to_node(L, N.BL)

    elseif bx1 > N.mx and by2 < N.my then
      add_line_to_node(L, N.BR)

    elseif bx2 < N.mx and by1 > N.my then
      add_line_to_node(L, N.TL)

    elseif bx1 > N.mx and by1 > N.my then
      add_line_to_node(L, N.TR)

    else
      table.insert(N.lines, L)
    end
  end


  local function fill_quad_tree()
    each L in all_lines do
      add_line_to_node(L, quad_tree)
    end
  end


  local function lines_overlap(L1, L2)
    compare_stat = compare_stat + 1

    -- ignore self
    if L1 == L2 then return false end

    -- ignore direct neighbor
    if L1.before == L2 then return false end
    if L1.after  == L2 then return false end

    -- bbox check
    if math.min(L1.x1, L1.x2) > math.max(L2.x1, L2.x2) + epsilon then return false end
    if math.min(L1.y1, L1.y2) > math.max(L2.y1, L2.y2) + epsilon then return false end

    if math.min(L2.x1, L2.x2) > math.max(L1.x1, L1.x2) + epsilon then return false end
    if math.min(L2.y1, L2.y2) > math.max(L1.y1, L1.y2) + epsilon then return false end

    -- slower but more precise test

    for pass = 1, 2 do
      local c = geom.perp_dist(L2.x1, L2.y1,  L1.x1, L1.y1, L1.x2, L1.y2);
      local d = geom.perp_dist(L2.x2, L2.y2,  L1.x1, L1.y1, L1.x2, L1.y2);

      if math.min(c, d) >  epsilon then return false end
      if math.max(c, d) < -epsilon then return false end

      L1, L2 = L2, L1
    end

    return true  -- OVERLAP
  end


  local function check_line_recursive(L1, N)
    each L2 in N.lines do
      if L1 != L2 and lines_overlap(L1, L2) then
        return true
      end
    end

    if N.BL then
      if check_line_recursive(L1, N.BL) or
         check_line_recursive(L1, N.BR) or
         check_line_recursive(L1, N.TL) or
         check_line_recursive(L1, N.TR)
      then
        return true
      end
    end

    return false -- OK
  end


  local function check_node(N)
    -- test all lines in node N itself against all lines in N _and_ all
    -- children of N

    each L1 in N.lines do
      if check_line_recursive(L1, N) then
        return true
      end
    end

    if N.BL then
      if check_node(N.BL) or check_node(N.BR) then return true end
      if check_node(N.TL) or check_node(N.TR) then return true end
    end

    return false
  end


  local function brute_force_check()
    -- this is only for testing that the quad-tree algorithm actually works,
    -- and seeing how much faster it is.

    compare_stat = 0

    local overlap = false

    for i = 1, #all_lines - 1 do
      for k = i + 1, #all_lines do
        if lines_overlap(all_lines[i], all_lines[k]) then
          overlap = true
        end
      end
    end

    stderrf("brute_force_check : overlap:%s  compares:%d\n",
            string.bool(overlap), compare_stat)
  end


  ---| check_track_overlaps_itself |---

  calc_bbox()

  quad_tree = create_quad_tree(bbox.x1, bbox.y1, bbox.x2, bbox.y2)

  create_lines()

  fill_quad_tree()

  local overlap = check_node(quad_tree)

--[[ Debug
  stderrf("quad_tree check   : overlap:%s  compares:%d\n",
          string.bool(overlap), compare_stat)

  brute_force_check()
--]]

  return overlap
end



function try_generate_section()
  --
  -- add pieces until desired length is reached...
  --

  local function try_add_piece()
    local reqs = {}

    -- if last piece was a STRAIGHT, next piece cannot be one
    local last_piece = table.last(TRACK.pieces)
    local last_info  = last_piece.info
    
    if not last_info or last_info.curviness == 0 then
      reqs.curved = 1
    end

    -- TODO : more reqs

    local tab = collect_usable_pieces(reqs)

    local mirror_prob = 35
    local scale_prob  = 50


    -- in OPEN roads, make mirror prob depend on current X coord
    -- (i.e. steer the track away from the X bounds)

    if TRACK.open then
      local last_P = table.last(TRACK.points)

      mirror_prob = 50

      if last_P.x < TRACK.bbox.x1 / 2 then
        mirror_prob = 40
      elseif last_P.x > TRACK.bbox.x2 / 2 then
        mirror_prob = 60
      end

      -- more tendency for larger (smoother) pieces too
      scale_prob = 80
    end

    -- larget pieces on LONG closed tracks
    if TRACK.closed and TRACK.num_segments > 300 then
      scale_prob = 80
    end


    -- try some of these pieces

    for n = 1, 5 do
      if table.empty(tab) then break; end

      local mirror = rand.odds(mirror_prob)
      local scale  = rand.sel(scale_prob, 1.7, 1.0)

      local name = rand.key_by_probs(tab)
      tab[name] = nil

      local piece = PIECES[name]
      assert(piece)

      -- test if the piece is usable
      if add_piece_to_track(piece, mirror, scale, "TEST_ONLY") then
         add_piece_to_track(piece, mirror, scale)
         return true
      end
    end 

    return false  -- no joy
  end


  ---| try_generate_section |---

  local count = 0
  local max_count = 2000

  while not test_if_long_enough() do
    count = count + 1

    if count > max_count then return false end

    if not try_add_piece() then
      -- failed to add a piece, need to backtrack
      local steps = rand.index_by_probs({ 64, 32, 16, 8, 4, 4,0, 4,0,0, 4 })

      do_backtracking(steps)
    end
  end


  debugf("try_gen steps : %d\n", count)

  if not test_if_acceptable() then
    return false
  end

  adjust_track()

  if check_track_overlaps_itself() then
    TRACK.points = TRACK.old_points
    TRACK.old_points = nil

    return false
  end

  -- TODO : test if adjusted track overlaps itself

  set_high_water_mark()
  return true
end



function select_begin_piece()
  local reqs = { begin=1 }

  local tab = collect_usable_pieces(reqs)
  assert(not table.empty(tab))

  local name = rand.key_by_probs(tab)

  return PIECES[name]
end



function generate_section()
  --
  -- the generator often fails to make an acceptable track, e.g. not
  -- long enough or bad end position (for closed tracks).  Hence we
  -- keep trying until it succeeds...
  --
  for loop = 1, 999 do
    stderrf("Loop %d....\n", loop)

    if try_generate_section() then
      return true -- OK--
    end

    -- backtrack  (more than a single piece failure)

    do_backtracking(loop * 3)
  end

  error("Failed to generate a track!")
end



function mirror_horizontally()
  --
  -- This done after track is finished and bezier control points
  -- have been added.  Only the 'x' coordinates in points[] are
  -- changed.
  --
  TRACK.mirrored = true

  each P in TRACK.points do
    P.x = - P.x
  end
end



function location_next_point(loc)
  local S = TRACK.points[loc.idx]
  local C = TRACK.points[loc.idx + 1]
  local E = TRACK.points[loc.idx + 2]

  if not E then
    error("move_along_track : went past end!")
  end

  loc.S = S ; loc.C = C ; loc.E = E

  loc.length = accurate_curve_length(S.x, S.y, C.x, C.y, E.x, E.y, 1)
end



function location_calc_coord(loc)
  local t = loc.along / loc.length

  -- current position
  loc.x, loc.y = bezier_coord(loc.S, loc.C, loc.E, t)

  -- tangent vector
  loc.tan_x, loc.tan_y = bezier_tangent(loc.S, loc.C, loc.E, t)

  -- normal vector
  loc.norm_x =   loc.tan_y
  loc.norm_y = - loc.tan_x
end



function move_along_track(loc)
  --
  -- move a single virtual node along the track.
  --
  -- 'loc' is a table containing the current location:
  --
  --   idx     :  index into TRACK.points[]
  --   along   :  how far along into that curve we are
  --   length  :  length of the current curve
  --
  --   S  : bezier start coord
  --   C  : bezier control point
  --   E  : bezier end coord
  --
  --   x, y           : computed coordinate
  --   tan_x, tan_y   : computed tangent, unit length
  --   norm_x, norm_y : computed normal (to the right), unit length
  --

  loc.along = loc.along + TRACK.stepping

  loc.total_along = loc.total_along + TRACK.stepping

  -- if we have gone past end of current curve, pick next one

  while loc.along >= loc.length do
    loc.along = loc.along - loc.length

    loc.idx = loc.idx + 2

    location_next_point(loc)
  end

  location_calc_coord(loc)
end



function create_virtual_nodes()
  --
  -- Move through the generated bezier curves and make a virtual
  -- road node at each step.
  --
  -- We also record tangent and normal vectors.
  --

  TRACK.road = {}

  -- current location along generated track
  local loc =
  {
    idx = 1
    along = 0
    total_along = 0
  }

  location_next_point(loc)
  location_calc_coord(loc)

  assert(loc.length > 0)


  for n = 1, TRACK.num_nodes do
    local node =
    {
      x = loc.x
      y = loc.y

      -- this is overwritten later
      z = 0

      index = n

      space = {}
      coords = {}
      objects = {}
      hard = {}
      signage = {}
    }

    table.insert(TRACK.road, node)

    node.tan_x = loc.tan_x
    node.tan_y = loc.tan_y

    node.norm_x = loc.norm_x
    node.norm_y = loc.norm_y

    node.angle = math.atan2(node.tan_x, node.tan_y) * 180.0 / math.pi

    -- step now [except at very last node]
    if n < TRACK.num_nodes then
      move_along_track(loc)
    end
  end


  printf("final pos = %1.8f  (~= %1.8f)\n", loc.total_along, TRACK.final_length)
end



function create_segments()
  TRACK.segments = {}

  for i = 1, TRACK.num_segments do
    local seg =
    {
      index = i

      textures = {}
      railing = {}
      edges = {}
    }

    table.insert(TRACK.segments, seg)

    -- set textures to default
    local def_tex = assert(TRACK.info.textures.default)

    for k = -5, 5 do
      seg.textures[k] = def_tex
    end

    -- link nodes and segments
    seg.first_node = TRACK.road[i*4 - 3]

    for k = 1, 4 do
      TRACK.road[(i - 1) * 4 + k].seg = seg
    end
  end
end



function determine_side_spaces()
  --
  -- At each node in virtual road, determine how much space there is on
  -- each side (for the road textures + landscape textures).
  --
  -- The intersection test checks where the normal lines of nodes which
  -- are adjacent (or a few steps away) intersect.  The proximity test
  -- checks many nodes (upto a certain distance) to see if it comes
  -- near to the current node.
  --
  -- We limit the result to a certain minimum distance, to ensure we
  -- can always generate the road itself and _something_ nearby.
  --
  local max_dist = 15.0
  local min_dist =  3.0

  local isec_steps = 10
  local prox_steps = sel(TRACK.closed, 400, 200)


  local function intersect_normals(C, N)
    local ax1 = C.x
    local ay1 = C.y
    local ax2 = ax1 + C.norm_x
    local ay2 = ay1 + C.norm_y

    local bx1 = N.x
    local by1 = N.y
    local bx2 = bx1 + N.norm_x
    local by2 = by1 + N.norm_y

    local k1 = geom.perp_dist(bx1, by1, ax1,ay1,ax2,ay2)
    local k2 = geom.perp_dist(bx2, by2, ax1,ay1,ax2,ay2)

    -- the parallel test in calling func ensures that (k1 - k2) can
    -- never be zero (or extremely close to zero) here.

    local d = k1 / (k1 - k2)

    local ix = bx1 + d * (bx2 - bx1)
    local iy = by1 + d * (by2 - by1)

    return ix, iy
  end


  local function side_for_point(N, ix, iy)
    local delta_x = ix - N.x
    local delta_y = iy - N.y

    local d = delta_x * N.tan_y - delta_y * N.tan_x

    return sel(d < 0, LF, RT), d
  end


  local function intersection_test(node, index, side)
    local C = node

    local cx = C.x
    local cy = C.y

    for i = - isec_steps, isec_steps do
      if i == 0 then continue end

      local N = lookup_node(index + i)
      if not N then continue end

      local N_x = N.x
      local N_y = N.y
    
      -- skip if parallel (or close to it)
      if math.abs(C.tan_x - N.tan_x) < 0.002 and
         math.abs(C.tan_y - N.tan_y) < 0.002
      then continue end

      -- calc intersection point
      local ix, iy = intersect_normals(C, N)

      -- check if intersection is on current side
      if side_for_point(C, ix, iy) != side then continue end
      if side_for_point(N, ix, iy) != side then continue end

      local d = geom.dist(cx, cy, ix, iy) / 1.1

      node.space[side] = math.min(node.space[side], d)
    end
  end


  local function proximity_test(node, index, side)
    local cx = node.x
    local cy = node.y

    -- define two half-planes, together they form a wedge coming
    -- out from the current node, angle of wedge is roughly 60 degrees
    -- (30 degrees on each side of the normal).
    --
    -- we only test neighbor points that occur in this wedge

    local hp1_nx = node.tan_x + node.norm_x * 0.5
    local hp1_ny = node.tan_y + node.norm_y * 0.5

    local hp2_nx = node.tan_x - node.norm_x * 0.5
    local hp2_ny = node.tan_y - node.norm_y * 0.5

    hp1_nx, hp1_ny = geom.unit_vector(hp1_nx, hp1_ny)
    hp2_nx, hp2_ny = geom.unit_vector(hp2_nx, hp2_ny)


    for i = - prox_steps, prox_steps do
      -- ignore node itself and immediate neighbors
      if math.abs(i) < 4 then continue end

      local N = lookup_node(index + i)
      if not N then continue end

      local delta_x = N.x - cx
      local delta_y = N.y - cy

      local hp1 = delta_x * hp1_nx + delta_y * hp1_ny
      local hp2 = delta_x * hp2_nx + delta_y * hp2_ny

      if side > 0 then
        if not (hp1 > 0 and hp2 < 0) then continue end
      else
        if not (hp2 > 0 and hp1 < 0) then continue end
      end

      -- neighbor lies in the wedge, check distance
      local d = delta_x * node.tan_y - delta_y * node.tan_x

      -- can only use half of the space (a bit less even)
      d = math.abs(d) / 2.2

      node.space[side] = math.min(node.space[side], d)
    end
  end


  local function calc_smooth_dist(dists, pos)
    local orig_val = dists[pos]

    local val = orig_val

    for pass = 1,2 do
      for i = 1,19 do
        local k = pos + sel(pass == 2, -i, i)

        -- wrap around [even for open roads -- won't matter]
        if k > #dists then k = k - #dists end
        if k < 1 then k = k + #dists end

        local diff = dists[k] - orig_val
        
        -- never increase the value
        if diff > 0 then diff = 0 end

        local factor = 0.5 * (math.cos(i/6) + 1)
        local new_val = orig_val + diff * factor

        val = math.min(val, new_val)
      end
    end

    return val
  end


  local function smooth_dists(side)
    local dists = {}

    each node in TRACK.road do
      table.insert(dists, node.space[side])
    end

    for n = 1, #TRACK.road do
      local node = TRACK.road[n]

      node.space[side] = calc_smooth_dist(dists, n)
    end
  end


  ---| determine_side_spaces |---

stderrf("determine_side_spaces...\n")

  for side = LF, RT do
    each node in TRACK.road do
      -- the tests below can shorten this distances
      node.space[side] = max_dist

      intersection_test(node, _index, side)

      proximity_test(node, _index, side)

      -- enforce the minimum
      node.space[side] = math.max(node.space[side], min_dist)
    end

    -- make the side distances more continuous (without raising them!)
    smooth_dists(side)
  end
end



function determine_curvature()
  --
  -- For each node, determine the 'curvature' value of the road,
  -- which is the angle difference + smoothing.
  --
  -- This information is useful for placing road signs.
  --
  -- We also categorize turns into three kinds :
  --   1 = fairly mild
  --   2 = quite sharp
  --   3 = very sharp, needing hazard signs (black and yellow arrow)
  --


  local look_dist = 1
  local avg_dist  = 7

  local speed_dist = 40
  local speed_peak = 4.5

  local curves = {}


  local function angle_difference(node, other)
    -- result is always >= 0
    -- (i.e. does NOT distinguish between left or right side)

    -- dot product of unit vectors gives cosine of angle diff
    local dp = node.tan_x * other.tan_x +
               node.tan_y * other.tan_y

    return math.acos(dp) * 180 / math.pi
  end


  local function compute_average(idx, dist)
    local sum = 0

    for ofs = -dist, dist do
      sum = sum + (curves[idx + ofs] or 0)
    end

    return sum / (dist * 2 + 1)
  end


  local function compute_bend(idx)
    local sum   = 0
    local total = 0

    for ofs = -2, 1 do
      local node1 = TRACK.road[idx + ofs]
      local node2 = TRACK.road[idx + ofs + 1]

      if node1 and node2 then
        sum   = sum + geom.angle_diff(node1.angle, node2.angle)
        total = total + 1
      end
    end

    if total < 0 then total = 1 end

    return sum / total
  end


  local function categorize_turns_at_node(n, start_ofs, end_ofs, min_angle, cat)
    local max_left  = 0
    local max_right = 0

    local diff = 0

    for ofs = start_ofs, end_ofs do
      local node1 = lookup_node(n + ofs - 1)
      local node2 = lookup_node(n + ofs)

      if node1 and node2 then
        -- this summing means we can detect turns >= 180 degrees
        diff = diff + geom.angle_diff(node1.angle, node2.angle) 

        if diff < 0 then max_left  = math.max(max_left,  -diff) end
        if diff > 0 then max_right = math.max(max_right,  diff) end
      end
    end

    local node = lookup_node(n)

    if max_left  >= min_angle then node.cat_L = cat end
    if max_right >= min_angle then node.cat_R = cat end
  end


  local function dump_cat_group(n, len)
    local L = ""
    local R = ""

    for i = 1, len do
      local node = lookup_node(n + i - 1)
      if not node then break; end

      L = L .. (node.cat_L or "-")
      R = R .. (node.cat_R or "-")
    end

    printf("%04d: %s\n", n, L)
    printf("      %s\n",    R)
    printf("\n")
  end


  local function dump_categories()
    printf("\n")
    printf("Turn Categories:\n")

    local PER_LINE = 50

    for n = 1, TRACK.num_nodes, PER_LINE do
      dump_cat_group(n, PER_LINE)
    end
  end


  ---| determine_curvature |---

  each node in TRACK.road do
    local best_diff = 0

    for i = -look_dist, look_dist do
      local other = lookup_node(_index + i)

      if other then
        local diff = angle_difference(node, other)

        best_diff = math.max(best_diff, diff)
      end
    end

    table.insert(curves, best_diff)
  end


  each node in TRACK.road do
    node.curvature = compute_average(_index, avg_dist)

    node.bend = compute_bend(_index)

    node.cat_L = 0
    node.cat_R = 0

    categorize_turns_at_node(_index, -14, 14, 34, 1)
    categorize_turns_at_node(_index, -10, 10, 47, 2)
    categorize_turns_at_node(_index, -6,  6,  60, 3)
    categorize_turns_at_node(_index, -6,  6,  95, 4)
  end

  -- dump_categories()
end



function process_the_layout()
  -- sometimes mirror a closed track, which means the player will
  -- travel anti-clockwise around it (instead of clockwise).
  if TRACK.closed and rand.odds(25) then
    mirror_horizontally()
  end


  if TRACK.open then
    TRACK.outer_side = rand.sel(75, RT, LF)
  elseif TRACK.mirrored then
    TRACK.outer_side = RT
  else
    TRACK.outer_side = LF
  end


  local final_length = accurate_track_length()

  TRACK.final_length = final_length


  -- for closed tracks, the number of segments is fixed
  -- for open roads, compute number of segments now...

  if TRACK.open then
    TRACK.num_segments = int(final_length / 3.0)

    -- on the "long" setting we often go a little over the limit
    if TRACK.num_segments > (MAX_SEGMENTS-4) then
       TRACK.num_segments = (MAX_SEGMENTS-4)
    end
  end

  -- always four virtual nodes per segment
  TRACK.num_nodes = TRACK.num_segments * 4


  TRACK.stepping = final_length / TRACK.num_nodes

  printf("Track length %1.3f  | num_segs %d  --> stepping %1.6f\n",
         final_length, TRACK.num_segments, TRACK.stepping)


  create_virtual_nodes()
  create_segments()
end



function generate_a_track(info)
  --
  -- Generate a single track.
  --

  printf("\n--- Generating %s ---\n\n", info.track_file)

  TRACK =
  {
    info = info
  }

  if info.kind == "closed" then
    TRACK.closed = true
  else
    TRACK.open = true
  end


  if TRACK.closed then
    local SEGMENTS = { short=128, medium=256, long=512 }

    TRACK.num_segments = SEGMENTS[PREFS.c_length]

    if TRACK.num_segments == nil then
      error("Unknown length setting: " .. tostring(PREFS.c_length))
    end

    TRACK.want_length  = TRACK.num_segments * 3.0 - 20

    local DONUTS =
    {
      short  = { mid_x=40,  inner_r=30, outer_r=120 }
      medium = { mid_x=70,  inner_r=60, outer_r=170 }
      long   = { mid_x=100, inner_r=90, outer_r=230 }
    }

    TRACK.donut = DONUTS[PREFS.c_length]
    assert(TRACK.donut)

  else -- open --

    local LENGTHS = { short=740, medium=1240, long=1740 }

    TRACK.want_length = LENGTHS[PREFS.o_length]

    if TRACK.want_length == nil then
      error("Unknown length setting: " .. tostring(PREFS.o_length))
    end

    TRACK.bbox = { x1=-500, x2=500, y1=0, y2=2000 }
  end

  debugf("generate_a_track : want_length %d\n", TRACK.want_length)


  TRACK.pieces = {}

  local ORIGIN_PIECE =
  {
    points =
    {
      { x=0, y=0, ang=0 }
    }
  }

  table.insert(TRACK.pieces, ORIGIN_PIECE)

  reconstruct_points()


  -- pick beginning piece
  -- (the NFS1 game engine seems to require a straight piece of road
  --  at the very start of each track)

  local begin_piece = select_begin_piece()

  if not begin_piece then
    error("failed to selecting a beginning piece!")
  end

  add_piece_to_track(begin_piece, false, 1.0)

  -- do not back-track past the BEGIN piece
  set_high_water_mark()


  generate_section()

  process_the_layout()

  determine_curvature()
  determine_side_spaces()

  create_scenery()

  Drive_Simulator()
end

