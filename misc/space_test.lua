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


ROOM = 1

DIVIDE_ODDS = { 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 }
DIVIDE_ODDS = { 0,  5, 10, 20, 40, 60, 70, 80, 90, 95, 98, 99, 100 }
-- DIVIDE_ODDS = { 0, 60, 60, 60, 60, 60, 60, 60, 60, 60, 100 }

SHAPE_PROBS = { N=150, t=70, s=70, l=30, u=30, h=15, o=15 }


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

    if math.min(w, h) >= 3 then
      
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


function generate_noise()
  for y = 1,SEED_H do
    for x = 1,SEED_W do
      SEEDS[x][y] = rand_index_by_probs({ 80, 40, 20, 10, 5 }) - 1
    end
  end
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

write_seeds()
