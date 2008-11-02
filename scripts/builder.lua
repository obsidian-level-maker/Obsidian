----------------------------------------------------------------
--  BUILDER
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2008 Andrew Apted
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

require 'defs'
require 'util'
require 'seeds'


TK = 16  -- wall thickness


-- TEMPORARY CRUD

ENT_PLAYER  = "1"
ENT_MONSTER = "9"
ENT_EXIT    = "41"

--[[ QUAKE
ENT_PLAYER  = "info_player_start"
ENT_MONSTER = "monster_army"
ENT_EXIT    = "item_artifact_super_damage"
--]]

--[[ QUAKE2
ENT_PLAYER  = "info_player_start"
ENT_MONSTER = "monster_soldier_light"
ENT_EXIT    = "item_quad"
--]]


function make_arrow(S, dir, f_h, tex)
  
  local mx = int((S.x1 + S.x2)/2)
  local my = int((S.y1 + S.y2)/2)

  local dx, dy = dir_to_delta(dir)
  local ax, ay = dir_to_delta(rotate_cw90(dir))

  gui.add_brush(
  {
    t_face = { texture=tex },
    b_face = { texture=tex },
    w_face = { texture=tex },
  },
  {
    { x = mx + dx*100, y = my + dy * 100 },
    { x = mx + ax*20,  y = my + ay * 20  },
    { x = mx - ax*20,  y = my - ay * 20  },
  },
  -2000, f_h + 8)
end


function make_curved_hall(steps, corn_x, corn_y,
                          dx0, dx1, dx2, dx3,
                          dy0, dy1, dy2, dy3,
                          x_h, y_h, gap_h,
                          wall_info, floor_info, ceil_info)

gui.printf("corner (%d,%d)  DX %d,%d,%d,%d  DY %d,%d,%d,%d\n",
           corn_x,corn_y, dx0,dx1,dx2,dx3, dy0,dy1,dy2,dy3);

  assert((0 < dx0 and dx0 < dx1 and dx1 < dx2 and dx2 < dx3) or
         (0 > dx0 and dx0 > dx1 and dx1 > dx2 and dx2 > dx3))

  assert((0 < dy0 and dy0 < dy1 and dy1 < dy2 and dy2 < dy3) or
         (0 > dy0 and dy0 > dy1 and dy1 > dy2 and dy2 > dy3))

  local flipped = false
  if sel(dx3 < 0, 1, 0) == sel(dy3 < 0, 1, 0) then
    flipped = true
  end

  local function arc_coords(p0, p1, dx0,dx1, dy0,dy1)
    local px0 = math.cos(math.pi * p0 / 2.0)
    local py0 = math.sin(math.pi * p0 / 2.0)

    local px1 = math.cos(math.pi * p1 / 2.0)
    local py1 = math.sin(math.pi * p1 / 2.0)

    local cx0 = int(corn_x + 0.5 + dx0 * px0)
    local cy0 = int(corn_y + 0.5 + dy0 * py0)
    local fx0 = int(corn_x + 0.5 + dx1 * px0)
    local fy0 = int(corn_y + 0.5 + dy1 * py0)

    local cx1 = int(corn_x + 0.5 + dx0 * px1)
    local cy1 = int(corn_y + 0.5 + dy0 * py1)
    local fx1 = int(corn_x + 0.5 + dx1 * px1)
    local fy1 = int(corn_y + 0.5 + dy1 * py1)

    if flipped then
      return
      {
        { x = cx1, y = cy1 },
        { x = fx1, y = fy1 },
        { x = fx0, y = fy0 },
        { x = cx0, y = cy0 },
      }
    else
      return
      {
        { x = cx0, y = cy0 },
        { x = fx0, y = fy0 },
        { x = fx1, y = fy1 },
        { x = cx1, y = cy1 },
      }
    end
  end

  --| make_curved_hall |--

  assert(steps >= 2)

  for i = 1,steps do
    local p0 = (i-1)/steps
    local p1 = (i  )/steps

    local f_h = x_h + (y_h - x_h) * (i-1) / (steps-1)
    local c_h = f_h + gap_h

    gui.add_brush(wall_info, arc_coords(p0,p1, dx0,dx1, dy0,dy1), -2000,2000)
    gui.add_brush(wall_info, arc_coords(p0,p1, dx2,dx3, dy2,dy3), -2000,2000)

    local coords = arc_coords(p0,p1, dx1,dx2, dy1,dy2)

    gui.add_brush(floor_info, coords, -2000, f_h)
    gui.add_brush(ceil_info,  coords, c_h, 2000)
  end
end


function do_ramp_x(bx1,bx2,y1, tx1,tx2,y2, az,bz, exact)
  assert(az and bz)

  local steps = int(math.abs(az-bz) / 14 + 0.9)
  local z

  if steps < 2 then steps = 2 end

  if exact then steps = steps + 1 end

  for i = 0,steps-1 do 
    if exact then
      z = az + (bz - az) * (i  ) / (steps-1)
    else
      z = az + (bz - az) * (i+1) / (steps+1)
    end

    local bx3 = bx1 + (bx2 - bx1) * i / steps
    local bx4 = bx1 + (bx2 - bx1) * (i+1) / steps

    local tx3 = tx1 + (tx2 - tx1) * i / steps
    local tx4 = tx1 + (tx2 - tx1) * (i+1) / steps

    bx3 = int(bx3) ; tx3 = int(tx3)
    bx4 = int(bx4) ; tx4 = int(tx4)

    gui.add_brush(
    {
      t_face = { texture="STEP1" },
      b_face = { texture="STEP1" },
      w_face = { texture="STEP1" },
    },
    {
      { x=bx3, y=y1 }, { x=tx3, y=y2 },
      { x=tx4, y=y2 }, { x=bx4, y=y1 },
    },
    -2000, z);
  end
end


function do_ramp_y(x1,ly1,ly2, x2,ry1,ry2, az,bz, exact)
  assert(az and bz)

  local steps = int(math.abs(az-bz) / 14 + 0.9)
  local z

  if steps < 2 then steps = 2 end

  if exact then steps = steps + 1 end

  for i = 0,steps-1 do 
    if exact then
      z = az + (bz - az) * (i  ) / (steps-1)
    else
      z = az + (bz - az) * (i+1) / (steps+1)
    end

    local ly3 = ly1 + (ly2 - ly1) * i / steps
    local ly4 = ly1 + (ly2 - ly1) * (i+1) / steps

    local ry3 = ry1 + (ry2 - ry1) * i / steps
    local ry4 = ry1 + (ry2 - ry1) * (i+1) / steps

    ly3 = int(ly3) ; ry3 = int(ry3)
    ly4 = int(ly4) ; ry4 = int(ry4)

    gui.add_brush(
    {
      t_face = { texture="STEP2" },
      b_face = { texture="STEP2" },
      w_face = { texture="STEP1" },
    },
    {
      { x=x1, y=ly3 }, { x=x1, y=ly4 },
      { x=x2, y=ry4 }, { x=x2, y=ry3 },
    },
    -2000, z);
  end
end


function do_corner_ramp_CURVED(S, x1,y1, x2,y2, x_h,y_h)
  assert(x_h and y_h)

  local steps = int(math.abs(x_h-y_h) / 14 + 0.9)

  if steps < 4 then
    steps = 4
  end

  local w = x2 - x1 + 1
  local h = y2 - y1 + 1

  local corn_x = x1
  local corn_y = y1

  local dx0, dx1, dx2, dx3 = 8, 32, w-32, w
  local dy0, dy1, dy2, dy3 = 8, 32, h-32, h

  if S.layout_char == "L" or S.layout_char == "F" then
    corn_x = x2
    dx0 = -dx0 ; dx1 = -dx1
    dx2 = -dx2 ; dx3 = -dx3
  end

  if S.layout_char == "L" or S.layout_char == "J" then
    corn_y = y2
    dy0 = -dy0 ; dy1 = -dy1
    dy2 = -dy2 ; dy3 = -dy3
  end

  local info =
  {
    t_face = { texture="FLAT1" },
    b_face = { texture="FLAT1" },
    w_face = { texture="SLADWALL" },
  }

  make_curved_hall(steps, corn_x, corn_y,
                   dx0, dx1, dx2, dx3,
                   dy0, dy1, dy2, dy3,
                   x_h, y_h, 256,
                   info, info, info)
end

function do_corner_ramp_JAGGY(S, x1,y1, x2,y2, x_h,y_h)
  assert(x_h and y_h)

  local d_h = sel(x_h < y_h, 1, -1)
  local m_h = int((x_h + y_h) / 2)

  local pw = (x2 - x1) / 4
  local ph = (y2 - y1) / 4
  local pz = math.max(x_h, y_h)

  local info =
  {
    t_face = { texture="FLAT1" },
    b_face = { texture="FLAT1" },
    w_face = { texture="SLADWALL" },
  }

  if S.layout_char == "L" then

    do_ramp_y(x1,y1,y2, x2-pw,y2-ph,y2, m_h-d_h*4, x_h, "exact")
    do_ramp_x(x1,x2,y1, x2-pw,x2,y2-ph, m_h+d_h*4, y_h, "exact")

    gui.add_brush(info,
    {
      { x=x2-pw, y=y2-ph },
      { x=x2-pw, y=y2 },
      { x=x2,    y=y2 },
      { x=x2,    y=y2-ph },
    }, -2000, pz)

  elseif S.layout_char == "J" then

    do_ramp_y(x1+pw,y2-ph,y2, x2,y1,y2, m_h-d_h*4, x_h, "exact")
    do_ramp_x(x1,x2,y1, x1,x1+pw,y2-ph, y_h, m_h+d_h*4, "exact")

    gui.add_brush(info,
    {
      { x=x1,    y=y2-ph },
      { x=x1,    y=y2 },
      { x=x1+pw, y=y2 },
      { x=x1+pw, y=y2-ph },
    }, -2000, pz)

  elseif S.layout_char == "F" then

    do_ramp_y(x1,y1,y2, x2-pw,y1,y1+ph, x_h, m_h-d_h*4, "exact")
    do_ramp_x(x2-pw,x2,y1+ph, x1,x2,y2, m_h+d_h*4, y_h, "exact")

    gui.add_brush(info,
    {
      { x=x2-pw, y=y1 },
      { x=x2-pw, y=y1+ph },
      { x=x2,    y=y1+ph },
      { x=x2,    y=y1 },
    }, -2000, pz)

  elseif S.layout_char == "T" then

    do_ramp_y(x1+pw,y1,y1+ph, x2,y1,y2, x_h, m_h-d_h*4, "exact")
    do_ramp_x(x1,x1+pw,y1+ph, x1,x2,y2, y_h, m_h+d_h*4, "exact")

    gui.add_brush(info,
    {
      { x=x1,    y=y1 },
      { x=x1,    y=y1+ph },
      { x=x1+pw, y=y1+ph },
      { x=x1+pw, y=y1 },
    }, -2000, pz)
  end

end

function do_corner_ramp_STRAIGHT(S, x1,y1, x2,y2, x_h,y_h)
  assert(x_h and y_h)

  local d_h = sel(x_h < y_h, 1, -1)
  local m_h = int((x_h + y_h) / 2)

  local pw = int((x2 - x1) * 0.35)
  local ph = int((y2 - y1) * 0.35)
  local pz = math.max(x_h, y_h)

  local info =
  {
    t_face = { texture="FLAT10" },
    b_face = { texture="FLAT10" },
    w_face = { texture="ASHWALL4" },
  }

  local pilla, mezza

  if S.layout_char == "L" then

    do_ramp_y(x1,y2-ph,y2, x2-pw,y2-ph,y2, m_h-d_h*4, x_h, "exact")
    do_ramp_x(x2-pw,x2,y1, x2-pw,x2,y2-ph, m_h+d_h*4, y_h, "exact")

    pilla =
    {
      { x=x2-pw, y=y2-ph },
      { x=x2-pw, y=y2 },
      { x=x2,    y=y2 },
      { x=x2,    y=y2-ph },
    }

    mezza =
    {
      { x=x1,    y=y1 },
      { x=x1,    y=y2-ph },
      { x=x2-pw, y=y2-ph },
      { x=x2-pw, y=y1 },
    }

  elseif S.layout_char == "J" then

    do_ramp_y(x1+pw,y2-ph,y2, x2,y2-ph,y2, m_h-d_h*4, x_h, "exact")
    do_ramp_x(x1,x1+pw,y1, x1,x1+pw,y2-ph, y_h, m_h+d_h*4, "exact")

    pilla =
    {
      { x=x1,    y=y2-ph },
      { x=x1,    y=y2 },
      { x=x1+pw, y=y2 },
      { x=x1+pw, y=y2-ph },
    }

    mezza =
    {
      { x=x1+pw, y=y1 },
      { x=x1+pw, y=y2-ph },
      { x=x2   , y=y2-ph },
      { x=x2   , y=y1 },
    }

  elseif S.layout_char == "F" then

    do_ramp_y(x1,y1,y1+ph, x2-pw,y1,y1+ph, x_h, m_h-d_h*4, "exact")
    do_ramp_x(x2-pw,x2,y1+ph, x2-pw,x2,y2, m_h+d_h*4, y_h, "exact")

    pilla =
    {
      { x=x2-pw, y=y1 },
      { x=x2-pw, y=y1+ph },
      { x=x2,    y=y1+ph },
      { x=x2,    y=y1 },
    }

    mezza =
    {
      { x=x1,    y=y1+ph },
      { x=x1,    y=y2 },
      { x=x2-pw, y=y2 },
      { x=x2-pw, y=y1+ph },
    }

  elseif S.layout_char == "T" then

    do_ramp_y(x1+pw,y1,y1+ph, x2,y1,y1+ph, x_h, m_h-d_h*4, "exact")
    do_ramp_x(x1,x1+pw,y1+ph, x1,x1+pw,y2, y_h, m_h+d_h*4, "exact")

    pilla =
    {
      { x=x1,    y=y1 },
      { x=x1,    y=y1+ph },
      { x=x1+pw, y=y1+ph },
      { x=x1+pw, y=y1 },
    }

    mezza =
    {
      { x=x1+pw, y=y1+ph },
      { x=x1+pw, y=y2    },
      { x=x2   , y=y2 },
      { x=x2   , y=y1+ph },
    }
  end

  gui.add_brush(info, pilla, -2000, pz)
  gui.add_brush(info, mezza, -2000, m_h)
end


function do_outdoor_ramp_down(ST, f_tex, w_tex)
  local conn_dir = assert(ST.S.conn_dir)

  local oh  = ST.outer_h
  local ih  = ST.inner_h

  -- outer rectangle
  local ox1 = SEEDS[ST.x1][ST.y1][1].x1
  local oy1 = SEEDS[ST.x1][ST.y1][1].y1
  local ox2 = SEEDS[ST.x2][ST.y2][1].x2
  local oy2 = SEEDS[ST.x2][ST.y2][1].y2

  -- inner rectangle
  local ix1 = ST.S.x1
  local iy1 = ST.S.y1
  local ix2 = ST.S.x2
  local iy2 = ST.S.y2

gui.debugf("do_outdoor_ramp_down: S:(%d,%d) conn_dir:%d\n", ST.S.sx, ST.S.sy, conn_dir)

  if conn_dir == 6 then

    ix1 = ST.S.x2 - 96

    do_ramp_x(ox1,ix1,oy1, ox1,ix1,oy2, oh, ih, "exact")

    if iy2 < oy2-64 then
      do_ramp_y(ox1,iy2,oy2, ox2,iy2,oy2, ih, oh, "exact")
    end

    if iy1 > oy1+64 then
      do_ramp_y(ox1,oy1,iy1, ox2,oy1,iy1, oh, ih, "exact")
    end
  end

  -- FIXME

  ST.done = true
end

function do_outdoor_ramp_up(ST, f_tex, w_tex)
  local conn_dir = assert(ST.S.conn_dir)

  local oh  = ST.outer_h
  local ih  = ST.inner_h

  -- outer rectangle
  local ox1 = SEEDS[ST.x1][ST.y1][1].x1
  local oy1 = SEEDS[ST.x1][ST.y1][1].y1
  local ox2 = SEEDS[ST.x2][ST.y2][1].x2
  local oy2 = SEEDS[ST.x2][ST.y2][1].y2

  -- inner rectangle
  local ix1 = ST.S.x1
  local iy1 = ST.S.y1
  local ix2 = ST.S.x2
  local iy2 = ST.S.y2

gui.debugf("do_outdoor_ramp_up: S:(%d,%d) conn_dir:%d\n", ST.S.sx, ST.S.sy, conn_dir)

  if conn_dir == 6 then

    ix1 = ST.S.x2 - 64
    ox1 = ox1 + 32
  end
  -- FIXME


  assert(ih > oh)

  local steps = int((ih - oh) / 12 + 0.9)
  if steps < 4 then steps = 4 end

  for i = 0,steps do

    local z = ih + (oh - ih) * i / (steps+1)

    local nx1 = ix1 + (ox1 - ix1) * i / (steps+0)
    local ny1 = iy1 + (oy1 - iy1) * i / (steps+0)

    local nx2 = ix2 + (ox2 - ix2) * i / (steps+0)
    local ny2 = iy2 + (oy2 - iy2) * i / (steps+0)

    if nx1 > nx2 then nx1,nx2 = nx2,nx1 end
    if ny1 > ny2 then ny1,ny2 = ny2,ny1 end

    nx1 = int(nx1) ; ny1 = int(ny1)
    nx2 = int(nx2) ; ny2 = int(ny2)
    z   = int(z)

    gui.add_brush(
    {
      t_face = { texture=f_tex },
      b_face = { texture=f_tex },
      w_face = { texture=w_tex },
    },
      {
        { x=nx1, y=ny1 },
        { x=nx1, y=ny2 },
        { x=nx2, y=ny2 },
        { x=nx2, y=ny1 },
      },
    -2000, z)
  end 

  ST.done = true
end


function dummy_builder()


  local function get_wall_coords(dir, x1,y1, x2,y2)
  
    if dir == 4 then
      return
      {
        { x = x1   ,  y = y1 },
        { x = x1   ,  y = y2 },
        { x = x1+TK,  y = y2 },
        { x = x1+TK,  y = y1 },
      }
    end

    if dir == 6 then
      return
      {
        { x = x2   ,  y = y2 },
        { x = x2   ,  y = y1 },
        { x = x2-TK,  y = y1 },
        { x = x2-TK,  y = y2 },
      }
    end

    if dir == 2 then
      return
      {
        { x = x2, y = y1 },
        { x = x1, y = y1 },
        { x = x1, y = y1+TK },
        { x = x2, y = y1+TK },
      }
    end

    if dir == 8 then
      return
      {
        { x = x1, y = y2    },
        { x = x2, y = y2    },
        { x = x2, y = y2-TK },
        { x = x1, y = y2-TK },
      }
    end

    error("BAD SIDE for get_seed_wall: " .. tostring(side))
  end


  local function build_stairwell_90(R)
    assert(R.conns)

    local A = R.conns[1]
    local B = R.conns[2]

    assert(A and B)

    if A.dir == 2 or A.dir == 8 then
      B, A = A, B
    end

    assert(A.dir == 4 or A.dir == 6)
    assert(B.dir == 2 or B.dir == 8)

    local AS = A:seed(R)
    local BS = B:seed(R)

    -- room size
    local BL = SEEDS[R.sx1][R.sy1][1]
    local TR = SEEDS[R.sx2][R.sy2][1]

    local rx1, ry1 = BL.x1, BL.y1
    local rx2, ry2 = TR.x2, TR.y2
    local rw, rh   = rx2 - rx1, ry2 - ry1

    local ax  = sel(AS.conn_dir == 4, rx1, rx2)
    local ay1 = AS.y1
    local ay2 = AS.y2

    local by  = sel(BS.conn_dir == 2, ry1, ry2)
    local bx1 = BS.x1
    local bx2 = BS.x2

    local dx1, dx2
    local dy1, dy2

    if AS.conn_dir == 4 then
      dx1, dx2 = bx1 - ax, bx2 - ax
---## if dx1 < MARG then dx1 = MARG end
    else
      dx1, dx2 = bx2 - ax, bx1 - ax
    end

    if BS.conn_dir == 2 then
      dy1, dy2 = ay1 - by, ay2 - by
    else
      dy1, dy2 = ay2 - by, ay1 - by
    end

gui.printf("A @ (%d,%d/%d)  B @ (%d/%d,%d)\n", ax,ay1,ay2, bx1,bx2,by)
gui.printf("DX %d,%d  DY %d,%d\n", dx1,dx2, dy1,dy2)


    -- when space is tight, need to narrow the hallway
    -- (so there is space for the wall brushes)
    local MARG = 64

    if math.abs(dx1) < MARG then dx1 = sel(dx2 < 0, -MARG, MARG) end
    if math.abs(dy1) < MARG then dy1 = sel(dy2 < 0, -MARG, MARG) end

    if math.abs(dx2) > rw-MARG then dx2 = sel(dx2 < 0, -(rw-MARG), rw-MARG) end
    if math.abs(dy2) > rh-MARG then dy2 = sel(dy2 < 0, -(rh-MARG), rh-MARG) end

    assert(math.abs(dx1) < math.abs(dx2))
    assert(math.abs(dy1) < math.abs(dy2))

    local dx0 = sel(dx2 < 0, -32, 32)
    local dy0 = sel(dy2 < 0, -32, 32)

    local dx3 = dx2 + sel(dx2 < 0, -32, 32)
    local dy3 = dy2 + sel(dy2 < 0, -32, 32)


    -- FIXME: need brushes to fill space at sides of each doorway

    local x_h = B.conn_h  -- FIXME: if steep, offset both by 16
    local y_h = A.conn_h

    local steps = int(math.abs(x_h - y_h) / 16)
    if steps < 5 then steps = 5 end

    local info =
    {
      t_face = { texture="FLAT10" },
      b_face = { texture="FLAT10" },
      w_face = { texture="BROWN1" },
    }

    make_curved_hall(steps, ax, by,
                     dx0, dx1, dx2, dx3,
                     dy0, dy1, dy2, dy3,
                     x_h, y_h, 128,
                     info, info, info)
  end

  local function build_stairwell_180(R)
    local A = R.conns[1]
    local B = R.conns[2]

    -- require 180 degrees
    local AS = A:seed(R)
    local BS = B:seed(R)

    -- swap so that A has lowest coords
    if ((AS.conn_dir == 2 or AS.conn_dir == 8) and BS.x1 < AS.x1) or
       ((AS.conn_dir == 4 or AS.conn_dir == 6) and BS.y1 < AS.y1)
    then
      A,  B  = B,  A
      AS, BS = BS, AS
    end

    -- room size
    local BL = SEEDS[R.sx1][R.sy1][1]
    local TR = SEEDS[R.sx2][R.sy2][1]

    local rx1, ry1 = BL.x1, BL.y1
    local rx2, ry2 = TR.x2, TR.y2
    local rw, rh   = rx2 - rx1, ry2 - ry1

    local corn_x = (AS.x2 + BS.x1) / 2
    local corn_y = (AS.y2 + BS.y1) / 2

        if AS.conn_dir == 2 then corn_y = ry1
    elseif AS.conn_dir == 8 then corn_y = ry2
    elseif AS.conn_dir == 4 then corn_x = rx1
    elseif AS.conn_dir == 6 then corn_x = rx2
    else
      error("Bad/missing conn_dir for stairwell!")
    end

    local info =
    {
      t_face = { texture="FLOOR0_1" },
      b_face = { texture="FLOOR0_1" },
      w_face = { texture="STARGR1" },
    }

    local h1 = A.conn_h
    local h3 = B.conn_h
    local h2 = (h1 + h3) / 2

    local steps = int(math.abs(h2 - h1) / 16)
    if steps < 6 then steps = 6 end

    if AS.conn_dir == 2 or AS.conn_dir == 8 then

      local dx0 = corn_x - AS.x2 + 16
      local dx3 = corn_x - AS.x1 - 16
      local dx1 = dx0 + 32
      local dx2 = dx3 - 32

      local dy0 = 24
      local dy3 = ry2 - ry1 - 24
      local dy2 = dy3 - 24
      local dy1 = dy2 - 136

      if AS.conn_dir == 8 then
        dy0 = -dy0
        dy1 = -dy1
        dy2 = -dy2
        dy3 = -dy3
      end

      -- left side
      make_curved_hall(steps, corn_x, corn_y,
                       -dx0, -dx1, -dx2, -dx3,
                       dy0, dy1, dy2, dy3,
                       h1, h2, 128,
                       info, info, info)

      -- right side
      make_curved_hall(steps, corn_x, corn_y,
                       dx0, dx1, dx2, dx3,
                       dy0, dy1, dy2, dy3,
                       h3, h2, 128,
                       info, info, info)
    else
      local dy0 = corn_y - AS.y2 + 16
      local dy3 = corn_y - AS.y1 - 16
      local dy1 = dy0 + 32
      local dy2 = dy3 - 32

      local dx0 = 24
      local dx3 = rx2 - rx1 - 24
      local dx2 = dx3 - 24
      local dx1 = dx2 - 136

      if AS.conn_dir == 6 then
        dx0 = -dx0
        dx1 = -dx1
        dx2 = -dx2
        dx3 = -dx3
      end

      -- bottom section
      make_curved_hall(steps, corn_x, corn_y,
                       dx0, dx1, dx2, dx3,
                       -dy0, -dy1, -dy2, -dy3,
                       h2, h1, 128,
                       info, info, info)

      -- top section
      make_curved_hall(steps, corn_x, corn_y,
                       dx0, dx1, dx2, dx3,
                       dy0, dy1, dy2, dy3,
                       h2, h3, 128,
                       info, info, info)

    end
  end

  local function build_stairwell_0(R)
    local A = R.conns[1]
    local B = R.conns[2]

    local AS = A:seed(R)
    local BS = B:seed(R)

    -- swap so that A has lowest coords
    if ((AS.conn_dir == 2 or AS.conn_dir == 8) and BS.sx < AS.sx) or
       ((AS.conn_dir == 4 or AS.conn_dir == 6) and BS.sy < AS.sy)
    then
      A,  B  = B,  A
      AS, BS = BS, AS
    end

    -- room size
    local BL = SEEDS[R.sx1][R.sy1][1]
    local TR = SEEDS[R.sx2][R.sy2][1]

    local rx1, ry1 = BL.x1, BL.y1
    local rx2, ry2 = TR.x2, TR.y2
    local rw, rh   = rx2 - rx1, ry2 - ry1


    local h1 = A.conn_h
    local h3 = B.conn_h
    local h2 = (h1 + h3) / 2

    local steps = int(math.abs(h2 - h1) / 16)
    if steps < 5 then steps = 5 end

    local info =
    {
      t_face = { texture="FLOOR3_3" },
      b_face = { texture="FLOOR3_3" },
      w_face = { texture="STARBR2" },
    }


    if AS.conn_dir == 2 or AS.conn_dir == 8 then

      local corn_x = (AS.x2 + BS.x1) / 2
      local corn_y = sel(AS.conn_dir == 2, ry1, ry2)

      local dy1 = (ry2 - ry1) / 2 - 80
      local dy2 = (ry2 - ry1) / 2 + 80
      local dy0 = dy1 - 24
      local dy3 = dy2 + 24

      local dx0 = corn_x - AS.x2 + 16
      local dx3 = corn_x - AS.x1 - 16
      local dx1 = dx0 + 32
      local dx2 = dx3 - 32

      if AS.conn_dir == 8 then
        dy0 = -dy0
        dy1 = -dy1
        dy2 = -dy2
        dy3 = -dy3
      end

      -- left side
      make_curved_hall(steps, corn_x, corn_y,
                       -dx0, -dx1, -dx2, -dx3,
                       dy0, dy1, dy2, dy3,
                       h1, h2, 128,
                       info, info, info)

      -- right side
      corn_y = (ry1 + ry2) - corn_y

      local dx0 = BS.x1 - corn_x + 16
      local dx3 = BS.x2 - corn_x - 16
      local dx1 = dx0 + 32
      local dx2 = dx3 - 32

      make_curved_hall(steps, corn_x, corn_y,
                       dx0, dx1, dx2, dx3,
                       -dy0, -dy1, -dy2, -dy3,
                       h3, h2, 128,
                       info, info, info)
    else
      local corn_y = (AS.y2 + BS.y1) / 2
      local corn_x = sel(AS.conn_dir == 4, rx1, rx2)

      local dx1 = (rx2 - rx1) / 2 - 80
      local dx2 = (rx2 - rx1) / 2 + 80
      local dx0 = dx1 - 24
      local dx3 = dx2 + 24

      local dy0 = corn_y - AS.y2 + 16
      local dy3 = corn_y - AS.y1 - 16
      local dy1 = dy0 + 32
      local dy2 = dy3 - 32

      if AS.conn_dir == 6 then
        dx0 = -dx0
        dx1 = -dx1
        dx2 = -dx2
        dx3 = -dx3
      end

      -- bottom section
      make_curved_hall(steps, corn_x, corn_y,
                       dx0, dx1, dx2, dx3,
                       -dy0, -dy1, -dy2, -dy3,
                       h2, h1, 128,
                       info, info, info)

      -- top section
      corn_x = (rx1 + rx2) - corn_x

      local dy0 = BS.y1 - corn_y + 16
      local dy3 = BS.y2 - corn_y - 16
      local dy1 = dy0 + 32
      local dy2 = dy3 - 32

      make_curved_hall(steps, corn_x, corn_y,
                       -dx0, -dx1, -dx2, -dx3,
                       dy0, dy1, dy2, dy3,
                       h2, h3, 128,
                       info, info, info)
    end
  end

  local function build_stairwell_straight(R)
    local A = R.conns[1]
    local B = R.conns[2]

    local AS = A:seed(R)
    local BS = B:seed(R)

    -- swap so that A has lowest coords
    if ((AS.conn_dir == 2 or AS.conn_dir == 8) and BS.sy < AS.sy) or
       ((AS.conn_dir == 4 or AS.conn_dir == 6) and BS.sx < AS.sx)
    then
      A,  B  = B,  A
      AS, BS = BS, AS
    end

    local x1 = math.min(AS.x1, BS.x1)
    local x2 = math.max(AS.x2, BS.x2)

    local y1 = math.min(AS.y1, BS.y1)
    local y2 = math.max(AS.y2, BS.y2)

    local x_diff = x2 - x1
    local y_diff = y2 - y1

    local function step_coords(p0, p1, side0, side1)
      local cx, cy, fx, fy

      if AS.conn_dir == 2 or AS.conn_dir == 8 then
        cx = int(x1 + x_diff * side0)
        fx = int(x1 + x_diff * side1)
        cy = int(y1 + y_diff * p0)
        fy = int(y1 + y_diff * p1)
      else
        cx = int(x1 + x_diff * p0)
        fx = int(x1 + x_diff * p1)
        cy = int(y1 + y_diff * side0)
        fy = int(y1 + y_diff * side1)
      end

      return
      {
        { x=cx, y=cy }, { x=cx, y=fy },
        { x=fx, y=fy }, { x=fx, y=cy },
      }
    end

    local info =
    {
      t_face = { texture="FLOOR0_6" },
      b_face = { texture="FLOOR0_1" },
      w_face = { texture="STARGR1" },
    }

    local h1 = A.conn_h
    local h2 = B.conn_h

    local gap_h = 128

    local steps = int(math.abs(h2 - h1) / 16)
    if steps < 5 then steps = 5 end

    for i = 1,steps do
      local p0 = (i-1)/steps
      local p1 = (i  )/steps

      local f_h = h1 + (h2 - h1) * (i-1) / (steps-1)
      local c_h = f_h + gap_h

      gui.add_brush(info, step_coords(p0,p1, 0/6, 1/6), -2000,2000)
      gui.add_brush(info, step_coords(p0,p1, 5/6, 6/6), -2000,2000)

      local coords = step_coords(p0,p1, 1/6, 5/6)

      gui.add_brush(info, coords, -2000,f_h)
      gui.add_brush(info, coords,  c_h,2000)
    end
  end

  local function build_stairwell(R)
    assert(R.conns)

    local A = R.conns[1]
    local B = R.conns[2]
    assert(A and B)

    local AS = A:seed(R)
    local BS = B:seed(R)
    assert(AS and BS)

    if is_perpendicular(AS.conn_dir, BS.conn_dir) then
      build_stairwell_90(R)

    elseif AS.conn_dir == BS.conn_dir then
      build_stairwell_180(R)

    else
      assert(AS.conn_dir == 10-BS.conn_dir)

      -- check for misalignment
      local aligned = false
      if AS.conn_dir == 2 or AS.conn_dir == 8 then
        if AS.sx == BS.sx then aligned = true end
      else
        if AS.sy == BS.sy then aligned = true end
      end

      if aligned then
        build_stairwell_straight(R)
      else
        build_stairwell_0(R)
      end
    end

    -- mark all seeds as done
    for sx = R.sx1,R.sx2 do for sy = R.sy1,R.sy2 do
      SEEDS[sx][sy][1].already_built = true
    end end
  end

  local function do_teleporter(S)
    -- TEMP HACK SHIT

    local idx = S.sx - S.room.sx1 + 1

if idx < 1 then return end

    if idx > #S.room.teleports then return end

    local TELEP = S.room.teleports[idx]


    local mx = int((S.x1 + S.x2)/2)
    local my = int((S.y1 + S.y2)/2)

    local x1 = mx - 32
    local y1 = my - 32
    local x2 = mx + 32
    local y2 = my + 32

    local z1 = S.z1 + 16

    local tag = sel(TELEP.src == S.room, TELEP.src_tag, TELEP.dest_tag)
    assert(tag)


gui.printf("do_teleport\n")
    gui.add_brush(
    {
      t_face = { texture="GATE3" },
      b_face = { texture="GATE3" },
      w_face = { texture="METAL" },

      sec_tag = tag,
    },
    {
      { x=x1, y=y1 },
      { x=x1, y=y2 },
      { x=x2, y=y2 },
      { x=x2, y=y1 },
    },
    -2000, z1)

    gui.add_entity((x1+x2)/2, (y1+y2)/2, z1 + 25, { name="14" })
  end


  local function build_seed(S)
    assert(S)

    if not S.room then
--    S.room = { kind = "liquid" }
      return
    end

    if S.already_built then
      return
    end

    local x1 = S.x1
    local y1 = S.y1
    local x2 = S.x2
    local y2 = S.y2

    local z1 = S.floor_h
    local z2 = S.ceil_h
    local f_tex, c_tex, w_tex
    local do_sides = true
    local sec_kind



      z1 = z1 or (S.conn and S.conn.conn_h) or S.room.floor_h or 0
      z2 = z2 or S.room.ceil_h or 256

-- z2 = 512

      assert(z1 and z2)

      local do_corners = false --!!

      
      if S.room.kind == "valley" then
        f_tex = "FLOOR7_1"
        c_tex = "F_SKY1"
        w_tex = "BROWN144"
        do_corners = false
        do_sides = false --!!!

      elseif S.room.kind == "ground" then
        f_tex = "MFLR8_4"
        c_tex = "F_SKY1"
        w_tex = "ASHWALL2"
        do_corners = false
        do_sides = false --!!!

      elseif S.room.kind == "hill" then
        f_tex = "FLOOR7_1"
        c_tex = "F_SKY1"
        w_tex = "BROWN144"
        do_corners = false
        do_sides = false --!!!

      elseif S.room.kind == "liquid" then
        f_tex = "NUKAGE1"
        c_tex = "F_SKY1"
        w_tex = "COMPBLUE"
        sec_kind = 16
        do_corners = false
        do_sides = false --!!!

      elseif S.room.kind == "hallway" then

        f_tex = "FLAT1"
        c_tex = "CEIL3_5"
        w_tex = "GRAY7"

      elseif S.room.kind == "stairwell" then

        f_tex = "FLAT5_3"
        c_tex = "FLAT1"
        w_tex = "BROWN1"

      else -- building
      
        f_tex = "FLOOR0_1"
        c_tex = "CEIL3_5"
        w_tex = "STARTAN3"

      end

--      if S.room.branch_kind then f_tex = "CEIL5_2" end


--[[ QUAKE
f_tex = sel(c_tex == "F_SKY1", "ground1_6", "wood1_1")
c_tex = sel(c_tex == "F_SKY1", "sky1", "metal1_1")
w_tex = "tech01_1"
--]]

--[[ QUAKE2
c_tex = "e1u1/grnx2_3"
f_tex = "e1u1/floor3_3"
w_tex = "e1u1/exitdr01_2"
--]]

      S.z1 = z1 --!!!!!! REMOVE CRAP

      if do_corners then
      gui.add_brush(
      {
        t_face = { texture=w_tex },
        b_face = { texture=w_tex },
        w_face = { texture=w_tex },
      },
      {
        { x=x1,    y=y1 },
        { x=x1,    y=y1+TK },
        { x=x1+TK, y=y1+TK },
        { x=x1+TK, y=y1 },
      },
      -2000, 4000)

      gui.add_brush(
      {
        t_face = { texture=w_tex },
        b_face = { texture=w_tex },
        w_face = { texture=w_tex },
      },
      {
        { x=x1,    y=y2-TK },
        { x=x1,    y=y2 },
        { x=x1+TK, y=y2 },
        { x=x1+TK, y=y2-TK },
      },
      -2000, 4000)

      gui.add_brush(
      {
        t_face = { texture=w_tex },
        b_face = { texture=w_tex },
        w_face = { texture=w_tex },
      },
      {
        { x=x2-TK, y=y1 },
        { x=x2-TK, y=y1+TK },
        { x=x2,    y=y1+TK },
        { x=x2,    y=y1 },
      },
      -2000, 4000)

      gui.add_brush(
      {
        t_face = { texture=w_tex },
        b_face = { texture=w_tex },
        w_face = { texture=w_tex },
      },
      {
        { x=x2-TK, y=y2-TK },
        { x=x2-TK, y=y2 },
        { x=x2,    y=y2 },
        { x=x2,    y=y2-TK },
      },
      -2000, 4000)
      end -- do_corners


    -- floor and ceiling brushes

if S.layout_char == "#" then

    gui.add_brush(
    {
      t_face = { texture=f_tex },
      b_face = { texture=f_tex },
      w_face = { texture=w_tex },
    },
    {
      { x=x1, y=y1 }, { x=x1, y=y2 },
      { x=x2, y=y2 }, { x=x2, y=y1 },
    },
    -2000, 2000);
elseif S.layout_char == "%" then
    gui.add_brush(
    {
      t_face = { texture="FWATER1" },
      b_face = { texture=f_tex },
      w_face = { texture="FIREMAG1" },
    },
    {
      { x=x1, y=y1 }, { x=x1, y=y2 },
      { x=x2, y=y2 }, { x=x2, y=y1 },
    },
    -2000, -32);

    gui.add_brush(
    {
      t_face = { texture=f_tex },
      b_face = { texture=f_tex },
      w_face = { texture=w_tex },
    },
    {
      { x=x1, y=y1 }, { x=x1, y=y2 },
      { x=x2, y=y2 }, { x=x2, y=y1 },
    },
    256, 2000);
else

if S.layout_char == ">" then
   do_ramp_x(x1,x2,y1, x1,x2,y2, S.stair_z1, S.stair_z2)
elseif S.layout_char == "<" then
   do_ramp_x(x1,x2,y1, x1,x2,y2, S.stair_z2, S.stair_z1)
elseif S.layout_char == "^" then
   do_ramp_y(x1,y1,y2, x2,y1,y2, S.stair_z1, S.stair_z2)
elseif S.layout_char == "v" then
   do_ramp_y(x1,y1,y2, x2,y1,y2, S.stair_z2, S.stair_z1)
elseif S.layout_char == "L" or S.layout_char == "J" or
       S.layout_char == "F" or S.layout_char == "T" then

   if (S.sx == S.room.sx1 or S.sx == S.room.sx2) and
      (S.sy == S.room.sy1 or S.sy == S.room.sy2)
   then
     do_corner_ramp_CURVED(S, x1,y1, x2,y2, S.stair_z1, S.stair_z2)
   else
     do_corner_ramp_STRAIGHT(S, x1,y1, x2,y2, S.stair_z1, S.stair_z2)
   end
else
    gui.add_brush(
    {
      t_face = { texture=f_tex },
      b_face = { texture=f_tex },
      w_face = { texture=w_tex },
      sec_kind = sec_kind,
    },
    {
      { x=x1, y=y1 }, { x=x1, y=y2 },
      { x=x2, y=y2 }, { x=x2, y=y1 },
    },
    -2000, z1);
end

-- if c_tex=="F_SKY1" then c_tex = "MFLR8_4" end --!!!!!!

    gui.add_brush(
    {
      t_face = { texture=c_tex },
      b_face = { texture=c_tex },
      w_face = { texture=w_tex },
    },
    {
      { x=x1, y=y1 }, { x=x1, y=y2 },
      { x=x2, y=y2 }, { x=x2, y=y1 },
    },
    z2, 4000)

end -- layout_char ~= "#"


if S.assign_stair and not S.assign_stair.done then
  if S.assign_stair.inner_h < S.assign_stair.outer_h then
    do_outdoor_ramp_down(S.assign_stair, f_tex, w_tex)
  else
    do_outdoor_ramp_up(S.assign_stair, f_tex, w_tex)
  end
end


if true then -- if do_sides then
    for side = 2,8,2 do
      local nx, ny = nudge_coord(S.sx, S.sy, side)
      local N
      if Seed_valid(nx,ny,1) then N = SEEDS[nx][ny][1] end

      if S.borders and S.borders[side] and S.borders[side].kind == "solid"
         and not (N and S.room and N.room and
                  S.room.arena == N.room.arena and
                  S.room.kind == N.room.kind and
                  not (S.room.hallway or N.room.hallway) and
                  false)
      then
        gui.add_brush(
        {
          t_face = { texture=f_tex },
          b_face = { texture=f_tex },
          w_face = { texture=w_tex },
        },
        get_wall_coords(side, x1,y1, x2,y2),
        -2000, 4000)
      end
      if S.borders and S.borders[side] and S.borders[side].kind == "fence"
         and not (N and S.room and N.room and S.room.arena == N.room.arena and S.room.kind == N.room.kind)
      then
        gui.add_brush(
        {
          t_face = { texture=f_tex },
          b_face = { texture=f_tex },
          w_face = { texture=w_tex },
        },
        get_wall_coords(side, x1,y1, x2,y2),
        -2000, z1+36)
      end
      if S.borders and S.borders[side] and S.borders[side].kind == "lock_door" then
        local LOCK_TEXS = { "DOORRED", "DOORYEL", "DOORBLU", "TEKGREN3",
                            "DOORRED2","DOORYEL2","DOORBLU2", "MARBFAC2" }
        local w_tex = LOCK_TEXS[S.borders[side].key_item] or "METAL"
gui.printf("ADDING LOCK DOOR %s\n", w_tex)
        gui.add_brush(
        {
          t_face = { texture=f_tex },
          b_face = { texture=f_tex },
          w_face = { texture=w_tex },
        },
        get_wall_coords(side, x1,y1, x2,y2),
        z1 + 36, 4000)
      end
    end
end -- do_sides

    local mx = int((x1+x2) / 2)
    local my = int((y1+y2) / 2)

    if S.is_start then
      gui.add_entity(mx, my, z1 + 25,
      {
        name = tostring(GAME.things["player1"].id)
      })
    elseif S.is_exit then
      gui.add_entity(mx, my, z1 + 25,
      {
        name = ENT_EXIT
      })
    elseif S.room and S.room.kind ~= "scenic" and
           (S.sx == S.room.sx1) and (S.sy == S.room.sy1) then
      -- THIS IS ESSENTIAL (for now) TO PREVENT FILLING by CSG
      gui.add_entity(mx, my, z1 + 25,
      {
        name = ENT_MONSTER
      })
    end

if S.conn_dir then
  make_arrow(S, S.conn_dir, z1, "FWATER1")
end

-- symmetry tester
if S.x_peer and S.sx == S.room.sx1 then
  local dx = rand_irange(-20,20)
  local dy = rand_irange(-20,20)
  local mx2 = int((S.x_peer.x1 + S.x_peer.x2) / 2)
  local my2 = int((S.x_peer.y1 + S.x_peer.y2) / 2)

  gui.add_entity(mx+dx, my+dy, z1 + 25,   { name="35" })
  gui.add_entity(mx2-dx, my2+dy, z1 + 25, { name="35" })
end

if S.y_peer and S.sy == S.room.sy1 then
  local dx = rand_irange(-20,20)
  local dy = rand_irange(-20,20)
  local mx2 = int((S.y_peer.x1 + S.y_peer.x2) / 2)
  local my2 = int((S.y_peer.y1 + S.y_peer.y2) / 2)

  gui.add_entity(mx+dx, my+dy, z1 + 25,   { name="43" })
  gui.add_entity(mx2+dx, my2-dy, z1 + 25, { name="43" })
end

    if S.room and S.sy == S.room.sy2 then
      do_teleporter(S)
    end

    if S.room and S.room.key_item and S.sx == S.room.sx2 and S.sy == S.room.sy2 then
      local KEYS = { 13,6,5,7015, 38,39,40, 7017 }
gui.printf("ADDING KEY %d\n", KEYS[S.room.key_item] or 2014)
      gui.add_entity(mx, my, z1+25,
      {
        name = tostring(KEYS[S.room.key_item] or 2014),
      })
    end
  end


  --==| dummy_builder |==--

  gui.printf("\n--==| dummy_builder |==--\n\n")

  gui.begin_level()
  gui.property("level_name", LEVEL.name);
  gui.property("error_tex",  "BLAKWAL1");

  gui.ticker()

  for _,R in ipairs(PLAN.all_rooms or {}) do
    if R.kind == "stairwell" then
      build_stairwell(R)
    end
  end

  for y = 1, SEED_H do
    for x = 1, SEED_W do
      for z = 1, SEED_D do
        build_seed(SEEDS[x][y][z])
      end
    end

--    gui.progress(100 * y / SEED_H)
  end

  gui.end_level()
end

