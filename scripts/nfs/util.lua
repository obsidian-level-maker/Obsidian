------------------------------------------------------------------------
--  GENERIC UTILITIES
------------------------------------------------------------------------
--
--  RandTrack : track generator for NFS1 (SE)
--
--  Copyright (C) 2011-2014 Andrew Apted
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


----====| LOGGING STUFF |====----

function printf(fmt, ...)
  if fmt then
    gui.raw_con_print(string.format(fmt, ...))
  end
end

function debugf(fmt, ...)
  if fmt then
    gui.raw_debug_print(string.format(fmt, ...))
  end
end

function stderrf(fmt, ...)
  if fmt then
    io.stderr:write(string.format(fmt, ...))
  end
end

-- replace the standard 'print' function
print = function(...)
  local args = { ... }
  local line = ""

  for i = 1,select("#", ...) do
    line = line .. "\t" .. tostring(args[i])
  end

  printf("%s\n", line)
end



----====| GENERAL / MATHEMATICAL |====----

function int(val)
  return math.floor(val)
end

function side_str(side)
  if side == LF then return "left"  end
  if side == RT then return "right" end

  return "INVALID"
end

function convert_bool(value)
  if value == nil or value == false or value == 0 or value == "" or value == "0" then
    return 0
  else
    return 1
  end
end

-- a poor man's ?: operator
-- NOTE: both expressions are evaluated!
function sel(cond, yes_val, no_val)
  if cond then return yes_val end
  return no_val
end


function math.hypot(x, y)
  return math.sqrt(x * x + y * y)
end

function math.round(x)
  if x < 0 then
    return math.ceil(x - 0.5)
  else
    return math.floor(x + 0.5)
  end
end

function math.mid(x, y)
  return (x + y) / 2.0
end

function math.i_mid(x, y)
  return int((x + y) / 2.0)
end

function math.in_range(low, x, high)
  return low <= x and x <= high
end

function math.clamp(low, x, high)
  if x < low  then return low end
  if x > high then return high end
  return x
end

function math.low_high(a, b)
  if b < a then return b, a end
  return a, b
end

function math.quadratic(x, limit)
  if not limit then limit = 1 end

  if x < 0 or x > limit then return x end

  return x * (limit * 2 - x) / limit
end

function math.lerp(low, x, high, y1, y2)
  if x <= low  then return y1  end
  if x >= high then return y2 end

  return y1 + (y2 - y1) * (x - low) / (high - low)
end


function string.bool(n)
  if n == nil   then return "nil"   end
  if n == false then return "false" end
  return "TRUE"
end

function string.is_digit(ch)
  return ch == '0' or ch == '1' or ch == '2' or
         ch == '3' or ch == '4' or ch == '5' or
         ch == '6' or ch == '7' or ch == '8' or
         ch == '9'
end

function read_text_file(filename)
  local file = io.open(filename, "r")

  if not file then
    return nil
  end

  local lines = {}

  for L in file:lines() do
    table.insert(lines, L .. "\n")
  end

  file:close()
  
  return lines
end



----====| TABLE UTILITIES |====----

-- special value for merging
REMOVE_ME = "__REMOVE__"

function table.size(t)
  local count = 0;
  for k,v in pairs(t) do count = count+1 end
  return count
end

function table.empty(t)
  return not next(t)
end

function table.last(t)
  return t[#t]
end

function table.has_elem(t, v)
  for _,value in ipairs(t) do
    if v == value then return true end
  end
  return false
end

function table.kill_elem(t, v)
  for idx,value in ipairs(t) do
    if v == value then
      table.remove(t, idx) ; return true
    end
  end
  return false
end

function table.kill_matching(t, predicate)
  for idx = #t, 1, -1 do
    if predicate(t[idx]) then
      table.remove(t, idx)
    end
  end
end

function table.add_unique(t, v)
  if not table.has_elem(t, v) then
    table.insert(t, v)
  end
end

function table.add_after(t, oldie, newbie)
  for idx = 1, #t do
    if t[idx] == oldie then
      table.insert(t, idx + 1, newbie)
      return
    end
  end

  error("table.add_after: oldie not found")
end

function table.numbers(count)
  local t = {}
  for i = 1,count do t[i] = i end
  return t
end

function table.find_unused(t, start)
  if not start then start = 1 end

  while t[start] do
    start = start + 1
  end

  return start
end

function table.append(t1, t2)
  for _,value in ipairs(t2) do
    table.insert(t1, value)
  end

  return t1
end

function table.reverse(t)
  if not t then return nil end

  for x = 1, int(#t / 2) do
    local y = #t - (x-1)
    -- swap 'em
    t[x], t[y] = t[y], t[x]
  end
end

function table.subset(t, predicate)
  local new_t = {}

  if t then
    for _,e in ipairs(t) do
      if predicate(e) then
        table.insert(new_t, e)
      end
    end
  end

  return new_t
end

function table.subset_w_field(t, field, value)
  local new_t = {}

  if t then
    for _,e in ipairs(t) do
      if e[field] == value then
        table.insert(new_t, e)
      end
    end
  end

  return new_t
end

function table.keys(t)
  assert(t)

  local keys = {}

  for k,v in pairs(t) do
    table.insert(keys, k)
  end

  return keys
end

function table.keys_sorted(t)
  local keys = table.keys(t)

  table.sort(keys, function (A,B) return tostring(A) < tostring(B) end)

  return keys
end

function table.tostr(t, depth, prefix)
  if not t then return "NIL" end
  if table.empty(t) then return "{}" end

  depth = depth or 1
  prefix = prefix or ""

  local result = "{\n"

  for idx,k in ipairs(table.keys_sorted(t)) do
    local v = t[k]
    result = result .. prefix .. "  " .. tostring(k) .. " = "
    if type(v) == "table" and depth > 1 then
      result = result .. table.tostr(v, depth-1, prefix .. "  ")
    else
      result = result .. tostring(v)
    end
    result = result .. "\n"
  end

  result = result .. prefix .. "}"

  return result
end

function table.list_str(t)
  if not t then return "NIL" end
  if table.empty(t) then return "{}" end

  local result = "{ "

  for i = 1, #t do
    result = result .. tostring(t[i])
    if i < #t then result = result .. ", " end
  end

  return result .. " }"
end

function table.pick_best(list, comp, remove_it)
  assert(list)

  if #list == 0 then
    return nil
  end

  if not comp then
    comp = function(A,B) return (A > B) end
  end

  local best = 1

  for idx = 2,#list do
    if not comp(list[best], list[idx]) then
      best = idx
    end
  end

  local result = list[best]

  if remove_it then
    table.remove(list, best)
  end

  return result
end

function table.merge(dest, src)  -- shallow
  for k,v in pairs(src) do
    if v == REMOVE_ME then
      dest[k] = nil
    else
      dest[k] = v
    end
  end

  return dest
end

function table.copy(t)  -- shallow
  if type(t) == "table" then
    return table.merge({}, t)
  else
    return t
  end
end

function table.merge_missing(dest, src)
  for k,v in pairs(src) do
    if not dest[k] then dest[k] = v end
  end
  return dest
end

function table.deep_merge(dest, src, _curdepth)
  _curdepth = _curdepth or 1

  if _curdepth > 10 then
    error("deep_copy failure: loop detected")
  end

  for k,v in pairs(src) do
    if v == REMOVE_ME then
      dest[k] = nil
    elseif type(v) == "table" then
      -- the type check handles non-existing fields too.
      -- the # checks mean we merely copy a list (NOT merge it).
      if type(dest[k]) == "table" and #v == 0 and #dest[k] == 0 then
        table.deep_merge(dest[k], v, _curdepth+1)
      else
        dest[k] = table.deep_merge({}, v, _curdepth+1)
      end
    else
      dest[k] = v
    end
  end

  return dest
end

function table.deep_copy(t)
  if type(t) == "table" then
    return table.deep_merge({}, t)
  else
    return t
  end
end

function table.merge_w_copy(dest, src)
  for k,v in pairs(src) do
    if v == REMOVE_ME then
      dest[k] = nil
    elseif type(v) == "table" then
      dest[k] = table.deep_merge({}, v)
    else
      dest[k] = v
    end
  end

  return dest
end

function table.name_up(t)
  for name,info in pairs(t) do
    info.name = name
  end
end

function table.index_up(t)
  for index,info in ipairs(t) do
    info.index = index
  end
end

function table.expand_copies(t)

  local function expand_it(name, sub)
    if not sub.copy then return end

    if sub.__expanding then
      error("Cyclic copy ref in: " .. name)
    end

    local orig = t[sub.copy]
    if not orig then
      error("Unknown copy ref: " .. tostring(sub.copy) .. " in: " .. name)
    end

    sub.__expanding = true

    -- recursively expand the original
    expand_it(sub.copy, orig)

    table.merge_missing(sub, orig)

    sub.__expanding = nil
    sub.copy = nil
  end

  --| expand_copies |--

  for name,sub in pairs(t) do
    expand_it(name, sub)
  end
end

function table.array_2D(w, h)
  local array = { w=w, h=h }
  for x = 1,w do
    array[x] = {}
  end
  return array
end

function table.valid_pos(array, x, y)
  return 1 <= x and x <= array.w and
         1 <= y and y <= array.h
end


table.INHERIT_META =
{
  __index = function(t, k)
    if t.__parent then return t.__parent[k] end
  end
}

function table.set_class(child, parent)
  assert(parent)
  child.__parent = parent
  setmetatable(child, table.INHERIT_META)
end



----====| RANDOM NUMBERS |====----

rand = {}

function rand.odds(chance)
  return (gui.random() * 100) <= chance
end

function rand.range(L,H)
  return L + gui.random() * (H-L)
end

function rand.irange(L,H)
  return math.floor(L + gui.random() * (H-L+0.9999))
end

function rand.int(val)
  return math.floor(val + gui.random())
end

function rand.offset(max_val)
  return rand.range(-max_val, max_val)
end

function rand.skew(max_value)
  if not max_val then max_val = 1 end
  local r = gui.random() - gui.random()
  return r * max_val
end

function rand.dir()
  return rand.irange(1, 4) * 2
end

function rand.dir_list()
  local DIRS = { 2,4,6,8 }
  rand.shuffle(DIRS)
  return DIRS
end

function rand.sel(chance, yes_val, no_val)
  if (gui.random() * 100) <= chance then
    return yes_val
  else
    return no_val
  end
end

function rand.pick(list)
  if #list > 0 then
    return list[rand.irange(1, #list)]
  else
    return nil
  end
end

function rand.shuffle(t)
  -- implements Knuth's random shuffle algorithm.

  if #t > 1 then
    for i = 1,(#t-1) do
      local k = rand.irange(i,#t)
      -- swap the pair of values
      t[i], t[k] = t[k], t[i]
    end
  end

  return t
end

function rand.index_by_probs(p)
  -- each element in the table is a probability.
  -- returns a random index based on the probabilities
  -- (e.g. the highest value is returned more often).
  assert(#p > 0)

  local total = 0
  for _,prob in ipairs(p) do
    total = total + prob
  end

  if total > 0 then
    local value = gui.random() * total

    for idx, prob in ipairs(p) do
      value = value - prob
      if (value <= 0) then return idx end
    end
  end

  -- should not get here, but if we do, return a valid index
  return 1
end

function rand.key_by_probs(tab)
  -- each element in the table has the form: KEY = PROB.
  -- This function returns one of the keys.
  local key_list  = {}
  local prob_list = {}

  for key,prob in pairs(tab) do
    table.insert(key_list,  key)
    table.insert(prob_list, prob)
  end

  local idx = rand.index_by_probs(prob_list)

  return key_list[idx]
end



----====| GEOMETRY |====----

geom = {}


function geom.dist(x1,y1, x2,y2)
  return math.sqrt((x1-x2) * (x1-x2) + (y1-y2) * (y1-y2))
end

function geom.unit_vector(dx, dy)
  local len = math.sqrt(dx * dx + dy * dy)

  if len > 0.00001 then
    dx = dx / len
    dy = dy / len
  else
    dx = 0
    dy = 0
  end

  return dx, dy
end

function geom.perp_dist(x, y, sx,sy, ex,ey)
  x = x - sx ; ex = ex - sx
  y = y - sy ; ey = ey - sy

  local len = math.sqrt(ex*ex + ey*ey)

  if len < 0.001 then
    error("perp_dist: zero-length line")
  end

  return (x * ey - y * ex) / len
end

function geom.along_dist(x, y, sx,sy, ex,ey)
  x = x - sx ; ex = ex - sx
  y = y - sy ; ey = ey - sy

  local len = math.sqrt(ex*ex + ey*ey)
  
  if len < 0.001 then
    error("perp_dist: zero-length line")
  end

  return (x * ex + y * ey) / len;
end


function geom.angle_to_delta(ang)
  local dx = math.sin(ang * math.pi / 180)
  local dy = math.cos(ang * math.pi / 180)

  return dx, dy
end

function geom.delta_to_angle(dx, dy)
  if math.abs(dx) < 0.001 and math.abs(dy) < 0.001 then
    return nil
  end

  local angle = math.atan2(dx, dy) * 180 / math.pi

  if angle < 0 then angle = angle + 360 end

  return angle
end

function geom.polar_coord(x, y, ang, dist)
  local dx, dy = geom.angle_to_delta(ang)

  x = x + dx * dist
  y = y + dy * dist

  return x, y
end

function geom.angle_add(A, B)
  -- result ranges from 0 to 360
  local D = A + B

  while D <    0 do D = D + 360 end
  while D >= 360 do D = D - 360 end

  return D
end

function geom.angle_diff(A, B)
  -- A + result = B
  -- result ranges from -180 to +180

  local D = (B - A)

  while D >  180 do D = D - 360 end
  while D < -180 do D = D + 360 end

  return D
end

function geom.rotate_vec(x, y, angle)
  local cos_R = math.cos(angle * math.pi / 180)
  local sin_R = math.sin(angle * math.pi / 180)

  local nx = x * cos_R + y * sin_R
  local ny = y * cos_R - x * sin_R

  return nx, ny
end


function geom.box_mid(x1,y1, x2,y2)
  return int((x1 + x2) / 2), int((y1 + y2) / 2)
end

function geom.box_size(x1,y1, x2,y2)
  return x2 - x1, y2 - y1
end

function geom.group_size(x1,y1, x2,y2)
  return x2 - x1 + 1, y2 - y1 + 1
end

function geom.box_dist(ax1,ay1,ax2,ay2, bx1,by1,bx2,by2)
  -- support 'B' being just a point
  if not bx2 then
    bx2, by2 = bx1, by1
  end

  local x_dist = 0
  local y_dist = 0

  if bx1 > ax2 then
    x_dist = bx1 - ax2
  elseif ax1 > bx2 then
    x_dist = ax1 - bx2
  end

  if by1 > ay2 then
    y_dist = by1 - ay2
  elseif ay1 > by2 then
    y_dist = ay1 - by2
  end

  return math.hypot(x_dist, y_dist)
end

function geom.inside_box(x,y, bx1,by1, bx2,by2)
  return (bx1 <= x) and (x <= bx2) and
         (by1 <= y) and (y <= by2)
end

function geom.box_inside_box(x1,y1,x2,y2, x3,y3,x4,y4)
  assert(x1 < x2 and y1  < y2)
  assert(x3 < x4 and y3 < y4)

  if x1 < x3 or x2 > x4 then return false end
  if y1 < y3 or y2 > y4 then return false end

  return true
end

function geom.boxes_overlap(x1,y1,x2,y2, x3,y3,x4,y4)
  -- NOTE: mere touching is not enough

  assert(x1 < x2 and y1 < y2)
  assert(x3 < x4 and y3 < y4)

  if x3 >= x2 or x4 <= x1 then return false end
  if y3 >= y2 or y4 <= y1 then return false end

  return true
end


function geom.bbox_new()
  return { x1=9e9, y1=9e9, x2=-9e9, y2=-9e9 }
end

function geom.bbox_add_point(bbox, x, y)
  bbox.x1 = math.min(bbox.x1, x)
  bbox.y1 = math.min(bbox.y1, y)
  bbox.x2 = math.max(bbox.x2, x)
  bbox.y2 = math.max(bbox.y2, y)
end

function geom.bbox_add_rect(bbox, x1, y1, x2, y2)
  bbox.x1 = math.min(bbox.x1, x1)
  bbox.y1 = math.min(bbox.y1, y1)
  bbox.x2 = math.max(bbox.x2, x2)
  bbox.y2 = math.max(bbox.y2, y2)
end

function geom.bbox_sanitize(bbox)
  if bbox.x1 > bbox.x2 then bbox.x1, bbox.x2 = 0, 0 end
  if bbox.y1 > bbox.y2 then bbox.y1, bbox.y2 = 0, 0 end
end


function geom.long_deep(w, h, dir)
  if dir == 2 or dir == 8 then
    return w, h
  elseif dir == 4 or dir == 6 then
    return h, w
  else
    error("geom.long_deep: bad dir: " .. tostring(dir))
  end
end

function geom.side_coords(side, x1,y1, x2,y2, ofs)
  if not ofs then ofs = 0 end

  if side == 2 then return x1,y1+ofs, x2,y1+ofs end
  if side == 8 then return x1,y2-ofs, x2,y2-ofs end
  if side == 4 then return x1+ofs,y1, x1+ofs,y2 end
  if side == 6 then return x2-ofs,y1, x2-ofs,y2 end

  error("side_coords: bad side: " .. tostring(side))
end

function geom.pick_corner(side, x1,y1, x2,y2)
  if side == 1 then return x1,y1 end
  if side == 3 then return x2,y1 end
  if side == 7 then return x1,y2 end
  if side == 9 then return x2,y2 end

  error("pick_corner: bad side: " .. tostring(side))
end

