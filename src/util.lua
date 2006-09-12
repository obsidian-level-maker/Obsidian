----------------------------------------------------------------
-- UTILITY FUNCTIONS
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006 Andrew Apted
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

function do_nothing()
end

INHERIT_META =
{
  __index = function(t, k)
    if t.__parent then return t.__parent[k] end
  end
}

function inherit(child, parent)
  child.__parent = parent
  return setmetatable(child, INHERIT_META)
end

function int(val)
  return math.floor(val)
end

function sel(cond, yes_val, no_val)
  if cond then return yes_val else return no_val end
end

function count_entries(t)
  local count = 0;
  for k,v in pairs(t) do count = count+1 end
  return count
end

function dump_table(t, name)
	print((name or "ANON") .. " = {")
	for k,v in pairs(t) do
		print("  " .. tostring(k) .. " => " .. tostring(v))
	end
	print("}")
end

function merge_table(dest, src)
  assert(dest)
  if src then
    for k,v in pairs(src) do
      dest[k] = v
    end
  end
  return dest
end

-- Note: shallow copy
function copy_table(t)
  if t then return merge_table({}, t) end
  return nil
end

function array_2D(w, h)
  local t = { w=w, h=h }
  for x = 1,w do
    t[x] = {}
  end
  return t
end

function iterate_2D(arr, func, sx, sy, ex, ey)
  if not sx then
    sx = 1; sy = 1; ex = arr.w; ey = arr.h
  end
  for x = sx,ex do
    for y= sy,ey do
      if arr[x][y] then
        local res = func(arr, x, y)
        if not res then return res end
      end
    end
  end
end

-- note: assumes Y axis points upwards
function dir_to_delta(dir)
  if dir == 1 then return -1, -1 end
  if dir == 2 then return  0, -1 end
  if dir == 3 then return  1, -1 end

  if dir == 4 then return -1, 0 end
  if dir == 6 then return  1, 0 end

  if dir == 7 then return -1, 1 end
  if dir == 8 then return  0, 1 end
  if dir == 9 then return  1, 1 end

  error ("dir_to_delta: bad dir " .. dir)
end

function delta_to_dir(dx, dy)
  if math.abs(dx) > math.abs(dy) then
    if dx > 0 then return 6 else return 4 end
  else
    if dy > 0 then return 8 else return 2 end
  end
end

CW_45_ROTATES  = { 4, 1, 2,  7, 5, 3,  8, 9, 6 }
CCW_45_ROTATES = { 2, 3, 6,  1, 5, 9,  4, 7, 8 }

CW_90_ROTATES  = { 7, 4, 1,  8, 5, 2,  9, 6, 3 }
CCW_90_ROTATES = { 3, 6, 9,  2, 5, 8,  1, 4, 7 }

function rotate_cw(dir)
  return CW_90_ROTATES[dir]
end

function rotate_ccw(dir)
  return CCW_90_ROTATES[dir]
end

DIR_ANGLES = { 225,270,315, 180,0,0, 135,90,45 }

function dir_to_angle(dir)
  assert(1 <= dir and dir <= 9)
  return DIR_ANGLES[dir]
end

-- convert position into block/sub-block pair,
-- where all the index values start at 1
function div_mod(x, mod)
  x = x - 1
  return 1 + int(x / mod), 1 + (x % mod)
end


function rand_range(L,H)
  return L + math.random() * (H-L)
end

function rand_skew()
  return math.random() - math.random()
end

function rand_odds(chance)
  return math.random() * 100 <= chance
end

function dual_odds(test,t_chance,f_chance)
  if test then
    return rand_odds(t_chance)
  else
    return rand_odds(f_chance)
  end
end

-- implements Knuth's random shuffle algorithm.
-- returns first value after the shuffle.
-- the table can optionally be filled with integers.
function rand_shuffle(t, fill_size)
  if fill_size then
    for i = 1,fill_size do t[i] = i end
  end

  assert(#t > 0)

  for i = 1,(#t-1) do
    local j = math.random(i,#t)

    -- swap the pair of values
    t[i], t[j] = t[j], t[i]
  end

  return t[1]
end

-- each element in the table is a probability.
-- returns a random index based on the probabilities
-- (e.g. the highest value is returned more often).
function rand_index_by_probs(p)
  assert(#p > 0)

  local total = 0
  for zzz, prob in ipairs(p) do total = total + prob end

  if total == 0 then return nil end

  local value = math.random() * total

  for idx, prob in ipairs(p) do
    value = value - prob
    if (value <= 0) then return idx end
  end

  io.stderr:write("rand_index_by_probs: REACHED END" .. value)
  return 1
end

-- each element in the table has the form: KEY = PROB.
-- This function returns one of the keys.
function rand_key_by_probs(tab)
  local key_list  = {}
  local prob_list = {}

  for key,prob in pairs(tab) do
    table.insert(key_list,  key)
    table.insert(prob_list, prob)
  end

  local idx = rand_index_by_probs(prob_list)

  return key_list[idx]
end

