-----------------------------------------------------
--  TRACK GEN : EXPERIMENTAL RACE-TRACK GENERATOR  --
--  (c) 2014 Andrew Apted, all rights reserved     --
-----------------------------------------------------


require 'gd'


gui =
{
  random = math.random
}

require '_util'


if arg[1] then
  local seed = 0 + arg[1]
  print("Seed =", seed)
  math.randomseed(seed)
end


-- coordinate range : -100 to +100
-- points go clockwise from TOP to BOTTOM.
-- start and end points are implied (added in preprocess)


ALL_SHAPES =
{
  -- very basic curve --
  {
    comp = 0,

    points =
    {
      { x= 50, y=0, ang=270 },
    },
  },

  -- half a bell --
  {
    comp = 1,

    points =
    {
      { x= 30, y= 25, ang=270 },
      { x= 60, y=-40, ang=315 },
    },
  },

  -- nose --
  {
    comp = 1,

    points =
    {
      { x= 20, y= 60, ang=315 },
      { x= 60, y= 10, ang=315 },
      { x= 50, y=-10, ang=205 },

      { x= 30, y=-10, ang=180 },
      { x= 12, y=-20, ang= 90 },
      { x= 12, y=-60, ang= 90 },
    },
  },

  -- whale's head --
  {
    comp = 1,

    points =
    {
      { x= 90, y= 10, ang=270 },
      { x= 60, y=-20, ang=180 },
      { x= 30, y=-45, ang=270 },
    },
  },

  -- number '3' shape --
  {
    comp = 2,

    points =
    {
      { x= 50, y= 70, ang=0   },
      { x= 80, y= 60, ang=270 },
      { x= 45, y= 40, ang=180 },
      { x= 45, y=-20, ang=315 },
      { x= 57, y=-60, ang=270 },
      { x= 35, y=-80, ang=145 },
    },
  },

  -- elephant trunk --
  {
    comp = 2,

    points =
    {
      { x= 50, y= 30, ang=260 },
      { x= 70, y=-50, ang=300 },
      { x= 60, y=-70, ang=210 },
      { x= 30, y=-10, ang=100 },
      { x= 15, y=-35, ang=260 },
    },
  },

  -- door knob --
  {
    comp = 3,

    points =
    {
      { x= 15, y= 60, ang=285 },
      { x= 35, y= 30, ang=0   },
      { x= 55, y= 60, ang=65  },
      { x= 70, y= 30, ang=280 },

      { x= 65, y=-10, ang=260 },
      { x= 65, y=-40, ang=260 },
      { x= 40, y=-60, ang=150 },
      { x= 20, y=-60, ang=245 },
    },
  },

  -- squiggly --
  {
    comp = 3,

    points =
    {
      { x= 30, y= 65, ang=335 },
      { x= 30, y= 50, ang=200 },
      { x= 10, y= 32, ang=270 },
      { x= 30, y= 15, ang=0   },

      { x= 70, y=  0, ang=270 },

      { x= 50, y=-10, ang=180 },
      { x= 30, y=-30, ang=270 },
      { x= 50, y=-50, ang=330 },
      { x= 35, y=-67, ang=200 },
    },
  },

  -- yawning hippo --
  {
    comp = 3,

    points =
    {
      { x= 35, y= 85, ang=45  },
      { x= 62, y=100, ang=0   },
      { x= 90, y= 70, ang=270 },
      { x= 62, y= 35, ang=180 },

      { x= 40, y=  0, ang=270 },

      { x= 50, y=-35, ang=315 },
      { x= 60, y=-70, ang=205 },
      { x= 45, y=-60, ang=115 },
      { x= 27, y=-40, ang=180 },
      { x= 15, y=-60, ang=245 },
    },
  },

  -- lizard tongue --
  {
    comp = 5,

    points =
    {
      { x= 95, y=  0, ang=270 },
      { x= 65, y=-40, ang=180 },
      { x= 30, y=  0, ang=90  },

      { x= 42, y= 15, ang=0   },
      { x= 53, y=  0, ang=270 },
      { x= 65, y=-15, ang=0   },

      { x= 75, y=  0, ang=90  },
      { x= 45, y= 40, ang=180 },
      { x= 12, y=  0, ang=270 },
      { x= 12, y=-45, ang=270 },
    },
  },

  -- square with hairpin --
  {
    comp = 3,

    points =
    {
      { x= 55, y= 70, ang=0   },
      { x= 75, y= 40, ang=270 },
      { x= 75, y=-50, ang=270 },

      { x= 69, y=-70, ang=195 },
      { x= 59, y=-50, ang=105 },
      { x= 51, y= -5, ang=105 },

      { x= 40, y= 10, ang=195 },
      { x= 33, y=-10, ang=290 },
      { x= 27, y=-70, ang=187 },
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



IMG_W = 800
IMG_H = 600

-- create image, alloc colors

im = gd.createTrueColor(IMG_W, IMG_H)

BLACK  = im:colorAllocate(0, 0, 0)
WHITE  = im:colorAllocate(255, 255, 255)
RED    = im:colorAllocate(200, 0, 0)
BLUE   = im:colorAllocate(0, 0, 200)
YELLOW = im:colorAllocate(200, 200, 0)
GREEN  = im:colorAllocate(0, 200, 0)

im:filledRectangle(0, 0, IMG_W, IMG_H, BLACK)


function render_track(points, cyclic, lx, ly, hx, hy)
  if not lx then
    lx, hx = 0, IMG_W
    ly, hy = 0, IMG_H
  end

  local mx = (lx + hx) / 2
  local my = (ly + hy) / 2

  local x_scale = (hx - lx) / 200
  local y_scale = (hy - ly) / 200

  im:rectangle(lx + 1, ly + 1, hx - 1, hy - 1, BLUE)

  im:line(mx, ly, mx, hy, BLUE)
  im:line(lx, my, hx, my, BLUE)


  local function transform(x, y)
    x = mx + x * x_scale
    y = my - y * y_scale  -- adjust for positive Y being north
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

  -- draw the points, control first

  for i = 1,#points do
    if points[i].ctl then
      render_point(points[i].ctl, GREEN)
    end
  end

  for i = 1,#points do
    render_point(points[i], RED)
  end
end



function save_image()
  im:png("__shape.png")

  im = nil ; collectgarbage("collect")
end



function inspect_raw_shapes(start)
  local wx = 0
  local wy = 0

  for idx = start, 999 do
    local shape = ALL_SHAPES[idx]
    if not shape then return end

    render_track(shape.points, false, wx, wy, wx + 190, wy + 190)

    wx = wx + 200
    if wx > (IMG_W - 8) then
      wx = 0
      wy = wy + 200
    end
  end
end



function concatenate_shapes(idx1, rev1, idx2, rev2)
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


  add_shape(s1.points, rev1 and "reverse", nil)
  add_shape(s2.points, rev2 and "reverse", "mirror")

  return points
end



local function scale_down_track(points, cyclic)
  -- check if track is too large (due to skewing, or certain patterns)
  -- and shrink it if necessary.

  local bbox = measure_track(points, cyclic)

  -- print(string.format("bbox: (%1.1f %1.1f) .. (%1.1f %1.1f)", bbox.x1, bbox.y1, bbox.x2, bbox.y2))

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



function create_a_track(lx, ly, hx, hy)
  local num_shapes = #ALL_SHAPES

  -- TODO : shuffle two lists from 1..#ALL_SHAPES (in parent func)
  --        and pick s1 and s2 from each list
  --        add in some extra shapes with comp <= 2
  --        tendency to have comp1 + comp2 >= 2, <= 6

  local s1 = rand.irange(1, num_shapes)
  local s2 = rand.irange(1, num_shapes)

  while s1 == s2 do
    s2 = rand.irange(1, num_shapes)
  end

  local rev1 = rand.odds(50)
  local rev2 = rand.odds(50)

  local track = concatenate_shapes(s1, rev1, s2, rev2)

  if rand.odds(50) then
    if rand.odds(20) then
      local y_skew = rand.pick({ -0.5, 0.5 })
      skew_track(track, 0, y_skew)
    else
      local x_skew = rand.pick({ -0.7, 0.7 })
      skew_track(track, x_skew, 0)
    end
  end

  if rand.odds(50) then
    rotate_track(track)
  end

  scale_down_track(track, "cyclic")

  render_track(track, "cyclic", lx, ly, hx, hy)
end



function create_some_tracks()
  local wx = 0
  local wy = 0

  for loop = 1, 12 do
    create_a_track(wx, wy, wx + 190, wy + 190)

    wx = wx + 200
    if wx > (IMG_W - 8) then
      wx = 0
      wy = wy + 200
    end
  end
end


-- main --

preprocess_all_shapes()

if false then
  inspect_raw_shapes(1)
else
  create_some_tracks()
end

save_image()

