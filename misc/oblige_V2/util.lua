----------------------------------------------------------------
-- UTILITY FUNCTIONS
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006,2007 Andrew Apted
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


----====| GENERAL STUFF |====----

function do_nothing()
end

function int(val)
  return math.floor(val)
end

function sel(cond, yes_val, no_val)
  if cond then return yes_val else return no_val end
end

function dist(x1,y1, x2,y2)
  return math.sqrt( (x1-x2)*(x1-x2) + (y1-y2)*(y1-y2) )
end

function low_high(a, b)
  if b < a then return b, a end
  return a, b
end


----====| TABLE UTILITIES |====----

function table_size(t)
  local count = 0;
  for k,v in pairs(t) do count = count+1 end
  return count
end

function table_empty(t)
  return not next(t)
end

function table_to_str(t, depth, prefix)
  if not t then return "NIL" end
  if table_empty(t) then return "{}" end

  depth = depth or 1
  prefix = prefix or ""

  local keys = {}
  for k,v in pairs(t) do
    table.insert(keys, k)
  end

  table.sort(keys, function (A,B) return tostring(A) < tostring(B) end)

  local result = "{\n"

  for idx,k in ipairs(keys) do
    local v = t[k]
    result = result .. prefix .. "  " .. tostring(k) .. " = "
    if type(v) == "table" and depth > 1 then
      result = result .. table_to_str(v, depth-1, prefix .. "  ")
    else
      result = result .. tostring(v)
    end
    result = result .. "\n"
  end

  result = result .. prefix .. "}"

  return result
end

function merge_table(dest, src)
  for k,v in pairs(src) do
    dest[k] = v
  end
  return dest
end

-- Note: shallow copy
function copy_table(t)
  return t and merge_table({}, t)
end

function copy_and_merge(orig, t1, t2, t3, t4)
  local result = {}
  merge_table(result, orig)

  if t1 then merge_table(result, t1) end
  if t2 then merge_table(result, t2) end
  if t3 then merge_table(result, t3) end
  if t4 then merge_table(result, t4) end

  return result
end

function merge_missing(dest, src)
  for k,v in pairs(src) do
    if not dest[k] then dest[k] = v end
  end
  return dest
end

function name_it_up(LIST)
  for name,info in pairs(LIST) do
    info.name = name
  end
end

function expand_copies(LIST)

  local function expand_it(name, sub)
    if not sub.copy then return end

    if sub._expanding then
      error("Cyclic copy refs: " .. name)
    end

    sub._expanding = true

    local orig = LIST[sub.copy]

    if not orig then
      error("Unknown copy ref: " .. name .. " -> " .. tostring(sub.copy))
    end

    -- recursively expand the original
    expand_it(sub.copy, orig)

    merge_missing(sub, orig)

    sub._expanding = nil
    sub.copy = nil
  end

  -- expand_copies --

  for name,sub in pairs(LIST) do
    expand_it(name, sub)
  end
end

function reverse_array(t)
  if not t then return nil end
  local result = {}
  for zzz,val in ipairs(t) do
    table.insert(result, 1, val)
  end
  return result
end

function array_2D(w, h)
  local array = { w=w, h=h }
  for x = 1,w do
    array[x] = {}
  end
  return array
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


----====| RANDOM NUMBERS |====----

function rand_range(L,H)
  return L + con.random() * (H-L)
end

function rand_irange(L,H)
  return math.floor(L + con.random() * (H-L+0.9999))
end

function rand_skew()
  return con.random() - con.random()
end

function rand_odds(chance)
  return (con.random() * 100) <= chance
end

function rand_sel(chance, yes_val, no_val)
  if (con.random() * 100) <= chance then
    return yes_val
  else
    return no_val
  end
end

function dual_odds(test,t_chance,f_chance)
  if test then
    return rand_odds(t_chance)
  else
    return rand_odds(f_chance)
  end
end

function rand_element(list)
  if #list == 0 then return nil end
  return list[rand_irange(1,#list)]
end

function rand_table_pair(tab)
  local count = 0
  for k,v in pairs(tab) do count = count+1 end

  if count == 0 then return nil, nil end
  local index = rand_irange(1,count)

  for k,v in pairs(tab) do
    if index==1 then return k,v end
    index = index-1
  end

  error("rand_table_kv: miscounted!")
end

-- implements Knuth's random shuffle algorithm.
-- returns first value after the shuffle.
-- the table can optionally be filled with integers.
function rand_shuffle(t, fill_size)
  if fill_size then
    for i = 1,fill_size do t[i] = i end
  end

  if #t <= 1 then return end

  for i = 1,(#t-1) do
    local j = rand_irange(i,#t)

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

  local value = con.random() * total

  for idx, prob in ipairs(p) do
    value = value - prob
    if (value <= 0) then return idx end
  end

  -- shouldn't get here, but if we do, return a valid index
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


----====| CELL/BLOCK UTILITIES |====----

function valid_cell(cx, cy)
  return not (cx < 1 or cy < 1 or cx > PLAN.w or cy > PLAN.h)
end

function valid_block(bx, by)
  return not (bx < 1 or by < 1 or bx > PLAN.blk_w or by > PLAN.blk_h)
end

function valid_cell_block(c, x, y)
  return
    (c.bx1 <= x and x <= c.bx2) and
    (c.by1 <= y and y <= c.by2)
end

function valid_chunk(kx,ky)
  return 1 <= kx and kx <= 3 and
         1 <= ky and ky <= 3
end

function valid_chunk_block(K, x, y)
  return
    (K.x1 <= x and x <= K.x2) and
    (K.y1 <= y and y <= K.y2)
end


-- convert position into block/sub-block pair,
-- where all the index values start at 1
function div_mod(x, mod)
  x = x - 1
  return 1 + int(x / mod), 1 + (x % mod)
end

function dir_to_delta(dir)
  if dir == 1 then return -1, -1 end
  if dir == 2 then return  0, -1 end
  if dir == 3 then return  1, -1 end

  if dir == 4 then return -1, 0 end
  if dir == 5 then return  0, 0 end
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

function dir_to_across(dir)
  if dir == 2 then return 1, 0 end
  if dir == 4 then return 0, 1 end
  if dir == 6 then return 0, 1 end
  if dir == 8 then return 1, 0 end

  error ("dir_to_across: bad dir " .. dir)
end

function is_parallel(dir1, dir2)
  return (dir1 == 2 or dir1 == 8) == (dir2 == 2 or dir2 == 8)
end

function is_perpendicular(dir1, dir2)
  return (dir1 == 2 or dir1 == 8) == (dir2 == 4 or dir2 == 6)
end

CW_45_ROTATES  = { 4, 1, 2,  7, 5, 3,  8, 9, 6 }
CCW_45_ROTATES = { 2, 3, 6,  1, 5, 9,  4, 7, 8 }

CW_90_ROTATES  = { 7, 4, 1,  8, 5, 2,  9, 6, 3 }
CCW_90_ROTATES = { 3, 6, 9,  2, 5, 8,  1, 4, 7 }

function rotate_cw45(dir)
  return CW_45_ROTATES[dir]
end

function rotate_ccw45(dir)
  return CCW_45_ROTATES[dir]
end

function rotate_cw90(dir)
  return CW_90_ROTATES[dir]
end

function rotate_ccw90(dir)
  return CCW_90_ROTATES[dir]
end

DIR_ANGLES = { 225,270,315, 180,0,0, 135,90,45 }

function dir_to_angle(dir)
  assert(1 <= dir and dir <= 9)
  return DIR_ANGLES[dir]
end

function delta_to_angle(dx,dy)
  if math.abs(dy) < math.abs(dx)/2 then
    return sel(dx < 0, 180, 0)
  end
  if math.abs(dx) < math.abs(dy)/2 then
    return sel(dy < 0, 270, 90)
  end
  if dy > 0 then
    return sel(dx < 0, 135, 45)
  else
    return sel(dx < 0, 225, 315)
  end
end

function box_size(x1, y1, x2, y2)
  return (x2-x1+1), (y2-y1+1)
end

function boxes_overlap(x1,y1,x2,y2,  x3,y3,x4,y4)
  assert(x2 >= x1 and y2 >= y1)
  assert(x4 >= x3 and y4 >= y3)

  if x3 > x2 or x4 < x1 then return false end
  if y3 > y2 or y4 < y1 then return false end

  return true
end

function boxes_touch_sides(x1,y1,x2,y2,  x3,y3,x4,y4)

  if x3 > x2+1 or x4 < x1-1 then return false end
  if y3 > y2+1 or y4 < y1-1 then return false end

  if not (x3 > x2+1 or x4 < x1-1) and not (y3 > y2 or y4 < y1)
  then return true end

  if not (y3 > y2+1 or y4 < y1-1) and not (x3 > x2 or x4 < x1)
  then return true end

  return false
end

function get_long_deep(dir, w, h)
  if (dir == 2) or (dir == 8) then
    return w, h
  else
    return h, w
  end
end

function side_coords(side, x1,y1, x2,y2)
  if side == 2 then return x1,y1, x2,y1 end
  if side == 4 then return x1,y1, x1,y2 end
  if side == 6 then return x2,y1, x2,y2 end
  if side == 8 then return x1,y2, x2,y2 end

  error ("side_coords: bad side " .. side)
end

function corner_coords(side, x1,y1, x2,y2)
  if side == 1 then return x1,y1 end
  if side == 3 then return x2,y1 end
  if side == 7 then return x1,y2 end
  if side == 9 then return x2,y2 end

  error ("corner_coords: bad side " .. side)
end

function neighbour_by_side(c, dir)
  local dx, dy = dir_to_delta(dir)
  if valid_cell(c.x + dx, c.y + dy) then
    return PLAN.cells[c.x + dx][c.y + dy]
  end
end

function chunk_neighbour(c, K, dir)
  local dx, dy = dir_to_delta(dir)
  if valid_chunk(K.kx + dx, K.ky + dy) then
    return c.chunks[K.kx+dx][K.ky+dy]
  end
end

