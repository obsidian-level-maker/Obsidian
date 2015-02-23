------------------------------------------------------------------------
--  SHAPE SYSTEM
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2015 Andrew Apted
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
------------------------------------------------------------------------


function Shape_save_svg()

  -- grid size
  local SIZE = 14

  local fp


  local function wr_line(fp, x1, y1, x2, y2, color, width)
    fp:write(string.format('<line x1="%d" y1="%d" x2="%d" y2="%d" stroke="%s" stroke-width="%d" />\n',
             x1, y1, x2, y2, color, width or 1))
  end

  local function visit_seed(A1, S1, dir)
    local S2 = S1:neighbor(dir)

    if not (S2 and S2.area) then return end

    local A2 = S2.area

    if A2 == A1 then return end

    local color = "#00f"
    if A1.is_boundary != A2.is_boundary then color = "#0f0" end

    local sx1, sy1 = S1.sx, S1.sy
    local sx2, sy2 = sx1 + 1, sy1 + 1

    if dir == 3 or dir == 7 then
      -- no change

    elseif dir == 1 or dir == 9 then
      sy1, sy2 = sy2, sy1

    elseif dir == 2 then sy2 = sy1
    elseif dir == 8 then sy1 = sy2
    elseif dir == 4 then sx2 = sx1
    elseif dir == 6 then sx1 = sx2
    else
      error("uhhh what")
    end

    wr_line(fp, (sx1 - 1) * SIZE, (sy1 - 1) * SIZE,
                (sx2 - 1) * SIZE, (sy2 - 1) * SIZE, color, 2)
  end


  ---| Shape_save_svg |---

  local filename = "shape_" .. LEVEL.name .. ".svg"

  fp = io.open(filename, "w")

  if not fp then error("Cannot create file") end

  -- header
  fp:write('<?xml version="1.0" encoding="UTF-8" standalone="no"?>')
  fp:write('<svg xmlns="http://www.w3.org/2000/svg" version="1.1">\n')

  -- grid
  local min_x = 1 * SIZE
  local min_y = 1 * SIZE

  local max_x = SEED_W * SIZE
  local max_y = SEED_H * SIZE

  for x = 1, SEED_W do
    wr_line(fp, x * SIZE, SIZE, x * SIZE, max_y, "#bbb")
  end

  for y = 1, SEED_H do
    wr_line(fp, SIZE, y * SIZE, max_x, y * SIZE, "#bbb")
  end

  -- edges
  each A in LEVEL.areas do
  each S in A.seeds do
  each dir in geom.ALL_DIRS do
    visit_seed(A, S, dir)
  end
  end
  end
  
  -- end
  fp:write('</svg>\n')

  fp:close()
end




function Shape_fill_gaps()
  --
  -- Creates areas from all currently unused seeds (ones which have not
  -- received a shape yet).
  --
  -- Algorithm is very simple : assign a new "temp_area" to each half-seed
  -- and randomly merge them until size of all temp_areas has reached a
  -- certain threshhold.
  --

  local temp_areas = {}

  local MIN_SIZE = 5
  local MAX_SIZE = 15


  local function new_temp_area(first_S)
    local TEMP =
    {
      svolume = 0
      seeds = { first_S }
    }

    if first_S.diagonal then
      TEMP.svolume = 0.5
    else
      TEMP.svolume = 1.0
    end

    table.insert(temp_areas, TEMP)

    return TEMP
  end


  local function create_temp_areas()
    for sx = 1, SEED_W do
    for sy = 1, SEED_H do
      local S = SEEDS[sx][sy]

      if not S.diagonal and not S.area then
        -- a whole unused seed : split into two
        S:split(rand.sel(50, 1, 3))
      end

      S2 = S.top

      if S  and not S.area  then S .temp_area = new_temp_area(S)  end
      if S2 and not S2.area then S2.temp_area = new_temp_area(S2) end
    end
    end
  end


  local function perform_merge(A1, A2)
    -- merges A2 into A1 (killing A1)

    if A2.svolume > A1.svolume then
      A1, A2 = A2, A1
    end

    A1.svolume = A1.svolume + A2.svolume

    table.append(A1.seeds, A2.seeds)

    -- fix all seeds
    for sx = 1, SEED_W do
    for sy = 1, SEED_H do
      local S = SEEDS[sx][sy]
      local S2 = S.top

      if S .temp_area == A2 then S .temp_area = A1 end
      if S2.temp_area == A2 then S2.temp_area = A1 end
    end
    end

    -- mark A2 as dead
    A2.is_dead = true
    A2.svolume = nil
    A2.seeds = nil
  end


  local function eval_merge(A1, A2, dir)
    local score = 1

    if A1.svolume + A2.svolume <= MAX_SIZE then
      score = 2
    end

    return score + gui.random()    
  end


  local function try_merge_an_area(A1)
    local best_A2
    local best_score = 0

    each S in A1.seeds do
    each dir in geom.ALL_DIRS do
      local N = S:neighbor(dir)

      if not (N and N.temp_area) then continue end

      local A2 = N.temp_area

      if A2 == A1 then continue end

      assert(not A2.is_dead)

      local score = eval_merge(A1, A2, dir)

      if score > best_score then
        best_A2 = A2
        best_score = score
      end
    end
    end

    if best_A2 then
      perform_merge(A1, best_A2)
    end
  end


  local function prune_dead_areas()
    for i = #temp_areas, 1, -1 do
      if temp_areas[i].is_dead then
        table.remove(temp_areas, i)
      end
    end
  end


  local function merge_temp_areas()
    rand.shuffle(temp_areas)

    each A1 in temp_areas do
      if A1.is_dead then continue end

      if A1.svolume < MIN_SIZE then
        try_merge_an_area(A1)
      end
    end

    prune_dead_areas()
  end


  local function make_real_areas()
    each T in temp_areas do
      local area = AREA_CLASS.new("normal")

      area.is_filler = true

      area.seeds = T.seeds

      -- install into seeds
      each S in area.seeds do
        S.area = area
      end
    end
  end


  ---| Shape_fill_gaps |---

  create_temp_areas()

  for loop = 1,30 do
    merge_temp_areas()
  end

  make_real_areas()

  Area_squarify_seeds()
end



function Shape_do_boundary()

  local function area_touches_edge(A)
    each S in A.seeds do
      if S.sx == 1 or S.sx == SEED_W then return true end
      if S.sy == 1 or S.sy == SEED_H then return true end
    end

    return false
  end


  local function area_is_inside_box(A)
    local sx1 = LEVEL.boundary_margin
    local sx2 = SEED_W + 1 - LEVEL.boundary_margin

    local sy1 = LEVEL.boundary_margin
    local sy2 = SEED_H + 1 - LEVEL.boundary_margin

    each S in A.seeds do
      if sx1 < S.sx and S.sx < sx2 and
         sy1 < S.sy and S.sy < sy2
      then
        return true
      end
    end

    return false
  end


  ---| Shape_do_boundary |---

  local map_size = SEED_W + SEED_H

  if map_size < 52 then
    LEVEL.boundary_margin = 4
  elseif map_size < 72 then
    LEVEL.boundary_margin = 5
  else
    LEVEL.boundary_margin = 6
  end

  each A in LEVEL.areas do
    if not area_touches_edge(A) and area_is_inside_box(A) then
      A.is_inner = true
    else
      A.mode = "scenic"
      A.is_boundary = true
    end
  end
end



function Shape_create_areas()

-- TODO : Shape_add_shapes()

-- TODO : Shape_make_hallways()

  Shape_fill_gaps()

  Area_find_neighbors()

  Shape_do_boundary()

  Shape_save_svg()
end

