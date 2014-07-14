-----------------------------------------------------
--  TRACK GEN : EXPERIMENTAL RACE-TRACK GENERATOR  --
--  (c) 2014 Andrew Apted, all rights reserved     --
-----------------------------------------------------


require 'gd'

require '_util'


-- coordinate range : -100 to +100
-- points go clockwise from TOP to BOTTOM.
-- start and end points are implied (added in preprocess)


ALL_SHAPES =
{
  -- very basic curve --
  {
    comp = 1,

    points =
    {
      { x= 50,  y=  0,  ang=270 },
    },
  },

  -- half a bell --
  {
    comp = 2,

    points =
    {
      { x= 30,  y= 25, ang=270 },
      { x= 60,  y=-40, ang=315 },
    },
  },

  -- number '3' shape --
  {
    comp = 4,

    points =
    {
      { x= 50,  y= 70, ang=0   },
      { x= 80,  y= 60, ang=270 },
      { x= 45,  y= 40, ang=180 },
      { x= 45,  y=-20, ang=315 },
      { x= 57,  y=-60, ang=270 },
      { x= 35,  y=-80, ang=145 },
    },
  },

  -- elephant nose --
  {
    comp = 3,

    points =
    {
      { x= 50,  y= 30,  ang=260 },
      { x= 70,  y=-50,  ang=300 },
      { x= 60,  y=-70,  ang=210 },
      { x= 30,  y=-10,  ang=100 },
      { x= 15,  y=-35,  ang=260 },
    },
  },

  -- door knob --
  {
    comp = 4,

    points =
    {
      { x= 15,  y= 60, ang=285 },
      { x= 35,  y= 30, ang=0   },
      { x= 55,  y= 60, ang=65  },
      { x= 70,  y= 30, ang=280 },

      { x= 65,  y=-10, ang=260 },
      { x= 65,  y=-40, ang=260 },
      { x= 40,  y=-60, ang=150 },
      { x= 20,  y=-60, ang=245 },
    },
  },

}



function compute_controls(points, cyclic)
  -- compute bezier control points (from angle information)
  

  local function project_end(x, y, ang)
    x = x + 64 * math.cos(ang * math.pi / 180)
    y = y + 64 * math.sin(ang * math.pi / 180)

    return x, y
  end


  local function calc_intersection(P1, P2)
    local ax1 = P1.x
    local ay1 = P1.y
    local ax2, ay2 = project_end(ax1, ay1, P1.ang)

    local bx1 = P2.x
    local by1 = P2.y
    local bx2, by2 = project_end(bx1, by1, P2.ang)

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


  for i = 1,#points do
    local k = i + 1

    if k > #points then
      if not cyclic then break; end
      k = 1
    end

    local P1 = points[i]
    local P2 = points[k]

    local ix, iy = calc_intersection(P1, P2)

    P1.ctl = { x=ix, y=iy }

    -- use this if we need to reverse the points
    P2.back_ctl = P1.ctl
  end
end



function preprocess_all_shapes()
  for i = 1, #ALL_SHAPES do
    local shape = ALL_SHAPES[i]

    -- add common start and end points
    table.insert(shape.points, 1, { x= 0, y= 70, ang=0   })
    table.insert(shape.points,    { x= 0, y=-70, ang=180 })

    compute_controls(shape.points)
  end
end



function skew_track(points, x_factor, y_factor)
  -- this must be used _after_ computing the bezier control points,
  -- since we do not modify the angle fields here.
  -- one of 'x_factor' or 'y_factor' should be zero!

  local function transform(P)
    local nx = P.x + P.y * x_factor
    local ny = P.y + P.x * y_factor

    P.x = nx
    P.y = ny
  end


  for i = 1, #points do
    local P = points[i]

    transform(P)

    if P.ctl then
      transform(P.ctl)
    end

    -- no need to do 'back_ctl' (always corresponds to a normal 'ctl')
  end
end



function scale_track(points, x_factor, y_factor)
  -- simple scaling, only used by shrinking logic

  local function transform(P)
    P.x = P.x * x_factor
    P.y = P.y * y_factor
  end

  for i = 1, #points do
    local P = points[i]

    transform(P)

    if P.ctl then
      transform(P.ctl)
    end
  end
end



function rotate_track(points)
  -- rotate track by 90 degrees

  local function transform(P)
    local nx =  P.y
    local ny = -P.x

    P.x = nx
    P.y = ny
  end

  for i = 1, #points do
    local P = points[i]

    transform(P)

    if P.ctl then
      transform(P.ctl)
    end
  end
end



function bezier_calc(P1, PC, P2, t)
  local k1 = (1 - t) * (1 - t)
  local kc = 2 * (1 - t) * t
  local k2 = t * t

  local x = P1.x * k1 + PC.x * kc + P2.x * k2
  local y = P1.y * k1 + PC.y * kc + P2.y * k2

  return x, y
end



function measure_track(points, cyclic)
  -- compute the bounding box of all curves
  -- result won't be 100% accurate

  local bbox =
  {
    x1 =  9e9,
    y1 =  9e9,
    x2 = -9e9,
    y2 = -9e9,
  }

  local function do_curve(P1, PC, P2)
    -- PC is the bezier control point

    local step = 0.01

    for t = 0, 1 - step, step do
      local x1, y1 = bezier_calc(P1, PC, P2, t)
      local x2, y2 = bezier_calc(P1, PC, P2, t + step)

      bbox.x1 = math.min(bbox.x1, x1, x2)
      bbox.y1 = math.min(bbox.y1, y1, y2)

      bbox.x2 = math.max(bbox.x2, x1, x2)
      bbox.y2 = math.max(bbox.y2, y1, y2)
    end
  end


  -- measure the curves

  for i = 1,#points do
    local k = i + 1

    if k > #points then
      if not cyclic then break; end
      k = 1
    end

    do_curve(points[i], points[i].ctl, points[k])
  end

  assert(bbox.x1 < bbox.x2)
  assert(bbox.y1 < bbox.y2)

  return bbox
end



function render_track(points, cyclic)

  local im = gd.createTrueColor(500, 500)

  local BLACK  = im:colorAllocate(0, 0, 0)
  local WHITE  = im:colorAllocate(255, 255, 255)
  local RED    = im:colorAllocate(200, 0, 0)
  local BLUE   = im:colorAllocate(0, 0, 200)
  local YELLOW = im:colorAllocate(200, 200, 0)
  local GREEN  = im:colorAllocate(0, 200, 0)

  im:filledRectangle(0, 0, 500, 500, BLACK)

  im:line(250, 0, 250, 500, BLUE)
  im:line(0, 250, 500, 250, BLUE)


  local function transform(x, y)
    x = 250 + 2.5 * x
    y = 250 - 2.5 * y  -- adjust for positive Y being north
    return x, y
  end


  local function render_point(P, col)
    local x, y = transform(P.x, P.y)

    im:filledRectangle(x-1, y-1, x+1, y+1, col)
  end


  local function render_curve(P1, PC, P2)
    -- PC is the bezier control point

    local step = 0.002

    for t = 0, 1 - step, step do
      local x1, y1 = bezier_calc(P1, PC, P2, t)
      local x2, y2 = bezier_calc(P1, PC, P2, t + step)

      x1, y1 = transform(x1, y1)
      x2, y2 = transform(x2, y2)

      im:line(x1, y1, x2, y2, YELLOW)
    end
  end


  -- draw the curves

  for i = 1,#points do
    local k = i + 1

    if k > #points then
      if not cyclic then break; end
      k = 1
    end

    render_curve(points[i], points[i].ctl, points[k])
  end

  -- draw the points

  for i = 1,#points do
    render_point(points[i], RED)

    if points[i].ctl then
      render_point(points[i].ctl, GREEN)
    end
  end

  -- save image
  im:png("__shape.png")

  im = nil ; collectgarbage("collect")
end



function inspect_raw_shape(idx)
  local shape = ALL_SHAPES[idx]
  assert(shape)

  render_track(shape.points)
end



function concatenate_shapes(idx1, idx2)
  local s1 = ALL_SHAPES[idx1]
  local s2 = ALL_SHAPES[idx2]

  assert(s1 and s2)

  local points = {}


  local function add_point(P, reverse, mirror)
    -- make a copy
    P = table.copy(P)

    if reverse then
      P.ctl = P.back_ctl
    end

    P.back_ctl = nil

    if P.ctl then
      P.ctl = table.copy(P.ctl)
    end

    if reverse then
      P.y = -P.y

      if P.ctl then
        P.ctl.y = -P.ctl.y
      end
    end

    if mirror then
      P.x = -P.x
      P.y = -P.y

      if P.ctl then
        P.ctl.x = -P.ctl.x
        P.ctl.y = -P.ctl.y
      end
    end

    table.insert(points, P)
  end


  local function add_shape(points, reverse, mirror)
    for i = 1, #points - 1 do
      local k = i
      if reverse then k = #points - (i - 1) end

      add_point(points[k], reverse, mirror)
    end
  end


  add_shape(s1.points, "reverse" or nil, nil)
  add_shape(s2.points, nil, "mirror")

  return points
end



local function scale_down_track(points, cyclic)
  -- check if track is too large (due to skewing, or certain patterns)
  -- and shrink it if necessary.

  local bbox = measure_track(points, cyclic)

  print(string.format("bbox: (%1.1f %1.1f) .. (%1.1f %1.1f)", bbox.x1, bbox.y1, bbox.x2, bbox.y2))

  local xx = math.max(math.abs(bbox.x1), bbox.x2)
  local yy = math.max(math.abs(bbox.y1), bbox.y2)

  local x_scale = 90 / xx
  local y_scale = 90 / yy

  if x_scale > 1 and y_scale > 1 then return end

  if x_scale > y_scale then
    x_scale = math.max(y_scale, math.min(x_scale, 0.6))
  else
    y_scale = math.max(x_scale, math.min(y_scale, 0.6))
  end

  scale_track(points, x_scale, y_scale)  
end


-- main --

preprocess_all_shapes()

track = concatenate_shapes(2, 3)

-- rotate_track(track)

skew_track(track, -0.9, 0)

scale_down_track(track, "cyclic")

render_track(track, "cyclic")

