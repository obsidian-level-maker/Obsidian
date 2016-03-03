-------------------------------------------
--- Space Generation Test
-------------------------------------------


-- TODO >>   mirroring


-- create a fake 'gui' module for the util code
gui =
{
  random = function() return math.random() end
}

require 'util'


SEED_W = 32
SEED_H = 32

SEEDS = array_2D(SEED_W, SEED_H)


HALL = 1
ROOM = 2

DIVIDE_ODDS = { 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 }
DIVIDE_ODDS = { 0,  5, 10, 20, 40, 60, 70, 80, 90, 95, 98, 99, 100 }
-- DIVIDE_ODDS = { 0, 60, 60, 60, 60, 60, 60, 60, 60, 60, 100 }

SHAPE_PROBS = { N=150, t=70, s=70, l=30, u=30, h=15, o=15 }


function valid(x, y)
  return x >= 1 and x <= SEED_W and 
         y >= 1 and y <= SEED_H
end


function generate_noise()
  for y = 1,SEED_H do
    for x = 1,SEED_W do
      SEEDS[x][y] = rand_index_by_probs({ 80, 40, 20, 10, 5 }) - 1
    end
  end
end


function fill_area(x, y, w, h, R)
  for sy = y, y+h-1 do
    for sx = x, x+w-1 do
      SEEDS[sx][sy] = R
    end
  end
end


function divide_horiz(x, y, w, h)
  if (w >= 3) and rand_odds(math.min(50, (w-1)*10)) then
    local w2 = int(w / 3)

    recursive_fill(x, y, w2, h)
    recursive_fill(x+w-w2, y, w2, h)
    recursive_fill(x+w2, y, w-w2-w2, h)

    return
  end

  local w2 = int(w / 2)

  if (w % 2) == 1 and rand_odds(50) then
    w2 = w2 + 1
  end

  if w > 4 then
    w2 = rand_irange(2, w-2)
  end

  recursive_fill(x, y, w2, h)
  recursive_fill(x+w2, y, w-w2, h)
end


function divide_vert(x, y, w, h)
  if (h >= 3) and rand_odds(math.min(50, (h-1)*10)) then
    local h2 = int(h / 3)

    recursive_fill(x, y, w, h2)
    recursive_fill(x, y+h-h2, w, h2)
    recursive_fill(x, y+h2, w, h-h2-h2)

    return
  end

  local h2 = int(h / 2)

  if (h % 2) == 1 and rand_odds(50) then
    h2 = h2 + 1
  end

  if h > 4 then
    h2 = rand_irange(2, h-2)
  end

  recursive_fill(x, y, w, h2)
  recursive_fill(x, y+h2, w, h-h2)
end


function L_shape(x, y, w, h)
  local w2 = 1
  if w > 2 and rand_odds(math.min(80, w*10)) then w2 = w2 + 1 end
  if w > 4 and rand_odds(25) then w2 = w2 + 1 end

  local h2 = 1
  if h > 2 and rand_odds(math.min(80, h*10)) then h2 = h2 + 1 end
  if h > 4 and rand_odds(25) then h2 = h2 + 1 end

  local corner = rand_element { 1, 3, 7, 9 }

  fill_area(x, y, w, h, ROOM)
  ROOM = ROOM + 1

  w = w - w2
  h = h - h2

  if corner > 5 then y = y + h2 end
  if corner == 3 or corner == 9 then x = x + w2 end

  recursive_fill(x, y, w, h)
end


function U_shape(x, y, w, h, side)
  local ww = w
  local hh = h

  if is_vert(side) then ww = int(w/2) else hh = int(h/2) end

  local w2 = 1
  if ww > 2 and rand_odds(math.min(80, ww*10)) then w2 = w2 + 1 end
  if ww > 4 and rand_odds(25) then w2 = w2 + 1 end

  local h2 = 1
  if hh > 2 and rand_odds(math.min(80, hh*10)) then h2 = h2 + 1 end
  if hh > 4 and rand_odds(25) then h2 = h2 + 1 end

  fill_area(x, y, w, h, ROOM)
  ROOM = ROOM + 1

  if is_vert(side) then
    w = w - w2 * 2
    h = h - h2
    x = x + w2
    if side == 8 then y = y + h2 end
  else
    w = w - w2
    h = h - h2 * 2
    y = y + h2
    if side == 6 then x = x + w2 end
  end

  recursive_fill(x, y, w, h)
end


function O_shape(x, y, w, h)
  local ww = int(w / 2)
  local hh = int(h / 2)

  local w2 = 1
  if ww > 2 and rand_odds(math.min(80, ww*10)) then w2 = w2 + 1 end
  if ww > 4 and rand_odds(25) then w2 = w2 + 1 end

  local h2 = 1
  if hh > 2 and rand_odds(math.min(80, hh*10)) then h2 = h2 + 1 end
  if hh > 4 and rand_odds(25) then h2 = h2 + 1 end

  fill_area(x, y, w, h, ROOM)
  ROOM = ROOM + 1

  x = x + w2
  y = y + h2

  w = w - w2 - w2
  h = h - h2 - h2

  recursive_fill(x, y, w, h)
end


function T_shape(x, y, w, h, side)
  local ww = w
  local hh = h

  if is_vert(side) then ww = int((w-1)/2) else hh = int((h-1)/2) end

  local w2 = 1
  if ww > 2 and rand_odds(math.min(80, ww*10)) then w2 = w2 + 1 end
  if ww > 4 and rand_odds(25) then w2 = w2 + 1 end

  local h2 = 1
  if hh > 2 and rand_odds(math.min(80, hh*10)) then h2 = h2 + 1 end
  if hh > 4 and rand_odds(25) then h2 = h2 + 1 end

  fill_area(x, y, w, h, ROOM)
  ROOM = ROOM + 1

  if is_vert(side) then
    h = h - h2
    if side == 8 then y = y + h2 end

    recursive_fill(x, y, ww, h)
    recursive_fill(x+w-ww, y, ww, h)
  else
    w = w - w2
    if side == 6 then x = x + w2 end

    recursive_fill(x, y, w, hh)
    recursive_fill(x, y+h-hh, w, hh)
  end
end


function H_shape(x, y, w, h, side)
  local ww = w
  local hh = h

  ww = int((w-1)/2)
  hh = int((h-1)/2)

  local w2 = 1
  if ww > 2 and rand_odds(math.min(80, ww*10)) then w2 = w2 + 1 end
  if ww > 4 and rand_odds(25) then w2 = w2 + 1 end

  local h2 = 1
  if hh > 2 and rand_odds(math.min(80, hh*10)) then h2 = h2 + 1 end
  if hh > 4 and rand_odds(25) then h2 = h2 + 1 end

  fill_area(x, y, w, h, ROOM)
  ROOM = ROOM + 1

--print("H_shape", x, y, w, h, side)
--print("\t", ww, hh, w2, h2)
  if is_vert(side) then
    recursive_fill(x+w2, y,       w-w2-w2, hh)
    recursive_fill(x+w2, y+h-hh,  w-w2-w2, hh)
  else
    recursive_fill(x,      y+h2,  ww, h-h2-h2)
    recursive_fill(x+w-ww, y+h2,  ww, h-h2-h2)
  end
end


function S_shape(x, y, w, h, side)
  local ww = w
  local hh = h

  ww = int((w-1)/2)
  hh = int((h-1)/2)

  local w2 = 1
  if ww > 2 and rand_odds(math.min(80, ww*10)) then w2 = w2 + 1 end
  if ww > 4 and rand_odds(25) then w2 = w2 + 1 end

  local h2 = 1
  if hh > 2 and rand_odds(math.min(80, hh*10)) then h2 = h2 + 1 end
  if hh > 4 and rand_odds(25) then h2 = h2 + 1 end

  fill_area(x, y, w, h, ROOM)
  ROOM = ROOM + 1

--print("S_shape", x, y, w, h, side)
--print("\t", ww, hh, w2, h2)
  if side == 2 then
    recursive_fill(x, y,          ww, h-h2)
    recursive_fill(x+w-ww, y+h2,  ww, h-h2)
  elseif side == 8 then
    recursive_fill(x, y+h2,    ww, h-h2)
    recursive_fill(x+w-ww, y,  ww, h-h2)
  elseif side == 4 then
    recursive_fill(x, y,          w-w2, hh)
    recursive_fill(x+w2, y+h-hh,  w-w2, hh)
  else
    recursive_fill(x, y+h-hh,  w-w2, hh)
    recursive_fill(x+w2, y,    w-w2, hh)
  end
end



function recursive_fill(x, y, w, h)
--print("recursive_fill", x, y, w, h)
  assert(w >= 1)
  assert(h >= 1)

  local shape = rand_key_by_probs(SHAPE_PROBS)

  local side = rand_irange(1,4) * 2


  if math.min(w, h) >= 2 then

    if math.min(w, h) >= 3 and math.max(w, h) <= 9 then
      
      if shape == "s" then S_shape(x, y, w, h, side) ; return end
      if shape == "t" then T_shape(x, y, w, h, side) ; return end
      if shape == "h" then H_shape(x, y, w, h, side) ; return end
      if shape == "u" then U_shape(x, y, w, h, side) ; return end
      if shape == "o" then O_shape(x, y, w, h, side) ; return end
    end

    if shape == "l" then L_shape(x, y, w, h) ; return end

    if (w > h) or (w == h and rand_odds(50)) then
      local d = math.min(w, #DIVIDE_ODDS)

      if rand_odds(DIVIDE_ODDS[d]) then
        return divide_horiz(x, y, w, h)
      end
    else
      local d = math.min(h, #DIVIDE_ODDS)

      if rand_odds(DIVIDE_ODDS[d]) then
        return divide_vert(x, y, w, h)
      end
    end

  end  -- min(w, h) >= 2

  -- no subdivision, just fill the space

  fill_area(x, y, w, h, ROOM)

  ROOM = ROOM + 1
end


function merge_two_rooms(R1, R2)
  local new_size = 0

  for y = 1,SEED_H do
    for x = 1,SEED_W do
      if SEEDS[x][y] == R1 or SEEDS[x][y] == R2 then
        new_size = new_size + 1
      end
    end
  end

  -- don't let new room become too big
  if new_size > (SEED_W * SEED_H / 8) then
    return false
  end

  for y = 1,SEED_H do
    for x = 1,SEED_W do
      if SEEDS[x][y] == R2 then
        SEEDS[x][y] = R1
      end
    end
  end
end


function merge_at_point(x, y, side)
  local nx, ny = nudge_coord(x, y, side)
  if not valid(nx, ny) then
    return false
  end

  if SEEDS[nx][ny] == SEEDS[x][y] then
    return false
  end

  merge_two_rooms(SEEDS[x][y], SEEDS[nx][ny])

  return true
end


function merge_areas(count)
  for i = 1, count do
    local x = rand_irange(1, SEED_W)
    local y = rand_irange(1, SEED_H)

    local SIDES = {2,4,6,8}
    rand_shuffle(SIDES)

    for _,side in ipairs(SIDES) do
      if merge_at_point(x, y, side) then break; end
    end
  end
end


function area_used(x1, y1, x2, y2)
  if x1 < 1 or x2 > SEED_W or y1 < 1 or y2 > SEED_H then
    return true
  end

  for x = x1, x2 do for y = y1, y2 do
    if SEEDS[x][y] then
      return true
    end
  end end

  return false
end


function try_build_room(x, y, dir, loop)
  if not valid(x, y) or SEEDS[x][y] then
    return false
  end

  local deep = rand_irange(1,4) * 2 + 1
  local long = rand_irange(1,4)

  local hall_len = rand_sel(70, 1, 0)

--print("deep", deep)
--print("long", long)
  local dx, dy = dir_to_delta(dir)
  local ax, ay = dir_to_delta(rotate_ccw90(dir))

  if hall_len == 1 and valid(x+dx, y+dy) and not SEEDS[x+dx][y+dy] and rand_odds(25) then
    hall_len = 2
  end

  -- no hallway when no other room
  if ROOM == 2 then hall_len = 0 end

  local rx = x + hall_len * dx
  local ry = y + hall_len * dy

  local x1, y1, x2, y2

  if is_vert(dir) then
    x1 = rx - long
    x2 = rx + long
    y1 = ry
    y2 = ry + (deep-1) * dy
    if y1 > y2 then y1, y2 = y2, y1 end
  else
    y1 = ry - long
    y2 = ry + long
    x1 = rx
    x2 = rx + (deep-1) * dx
    if x1 > x2 then x1, x2 = x2, x1 end
  end

  if area_used(x1, y1, x2, y2) then
    return false
  end


  if hall_len > 0 then
    for i = 1, hall_len do
      SEEDS[x+(i-1)*dx][y+(i-1)*dy] = HALL
    end
  end

  fill_area(x1, y1, x2-x1+1, y2-y1+1, ROOM)
  if rand_odds(99) or hall_len > 0 then
    ROOM = ROOM + 1
  end

  local half = int(deep/2)

  spots = {}

  if rand_odds(80) then
    table.insert(spots,
    {
      x = rx + half * dx + (long+1) * ax,
      y = ry + half * dy + (long+1) * ay,
      dir = rotate_ccw90(dir),
    })
  end

  if rand_odds(80) then
    table.insert(spots,
    {
      x = rx + half * dx - (long+1) * ax,
      y = ry + half * dy - (long+1) * ay,
      dir = rotate_cw90(dir),
    })
  end

  if rand_odds(40) or #spots == 0 then
    table.insert(spots,
    {
      x = rx + deep * dx,
      y = ry + deep * dy,
      dir = dir,
    })
  end

  rand_shuffle(spots)

  for _,P in ipairs(spots) do
    build_rooms(P.x, P.y, P.dir)
  end

  return true
end


function build_rooms(x, y, dir)
--print("build_rooms...")
  for loop = 1,20 do
    if try_build_room(x, y, dir, loop) then
      return true
    end
  end

  return false
end


function write_seeds()
  for y = 1,SEED_W do
    for x = 1,SEED_H do
      print(SEEDS[x][y] or 0)
    end
  end
end


math.randomseed(0 + 1 * os.time())

recursive_fill(1,1, SEED_W,SEED_H)
--merge_areas(SEED_W * 3)

--build_rooms(rand_irange(8,24), rand_irange(4,12), 8)

write_seeds()
