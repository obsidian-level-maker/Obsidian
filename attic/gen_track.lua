-----------------------------------------------------
--  TRACK GEN : EXPERIMENTAL RACE-TRACK GENERATOR  --
--  (c) 2014 Andrew Apted, all rights reserved     --
-----------------------------------------------------


require 'gd'


function render(points, cyclic)

  local im = gd.createTrueColor(500, 500)

  local black = im:colorAllocate(0, 0, 0)
  local gray  = im:colorAllocate(127, 127, 127)
  local white = im:colorAllocate(255, 255, 255)

  local red    = im:colorAllocate(200, 0, 0)
  local blue   = im:colorAllocate(0, 0, 200)
  local purple = im:colorAllocate(200, 0, 200)
  local yellow = im:colorAllocate(200, 200, 0)
  local green  = im:colorAllocate(0, 200, 0)

  im:filledRectangle(0, 0, 500, 500, black)


  local function transform(x, y)
    x = 250 + 250 * x
    y = 250 - 250 * y  -- adjust for positive Y being north
    return x, y
  end


  local function render_point(P)
    local x, y = transform(P.x, P.y)

    im:filledRectangle(x, y, x+1, y+1, red)
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

      im:line(x1, y1, x2, y2, yellow)
    end
  end


  -- draw the curves

  for i = 1,#points,2 do
    local k = i + 2

    if k > #points then
      if not cyclic then break; end
      k = 1
    end

    render_curve(points[i], points[i+1], points[k])
  end

  -- draw connection points

  for i = 1,#points,2 do
    render_point(points[i])
  end

  -- save image
  im:png("__shape.png")

  im = nil ; collectgarbage("collect")
end


TEST_SHAPE =
{
  -- normal points       -- control points
  { x=-0.9, y=-0.5 },    { x= 0,   y=-0.9 },
  { x= 0.9, y=-0.5 },    { x= 0.9, y= 0.9 },
  { x= 0,   y= 0.9 },    { x=-0.9, y= 0.9 },
}

render(TEST_SHAPE, "cyclic")

