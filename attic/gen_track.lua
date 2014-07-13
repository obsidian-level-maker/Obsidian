-----------------------------------------------------
--  TRACK GEN : EXPERIMENTAL RACE-TRACK GENERATOR  --
--  (c) 2014 Andrew Apted, all rights reserved     --
-----------------------------------------------------


require 'gd'

require 'util'


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


  local function bezier_calc(P1, PC, P2, t)
    local k1 = (1 - t) * (1 - t)
    local kc = 2 * (1 - t) * t
    local k2 = t * t

    local x = P1.x * k1 + PC.x * kc + P2.x * k2
    local y = P1.y * k1 + PC.y * kc + P2.y * k2

    return transform(x, y)
  end


  local function render_curve(P1, PC, P2)
    -- PC is the bezier control point

    local step = 0.002

    for t = 0, 1 - step, step do
      local x1, y1 = bezier_calc(P1, PC, P2, t)
      local x2, y2 = bezier_calc(P1, PC, P2, t + step)

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


-- main --

preprocess_all_shapes()

inspect_raw_shape(5)

