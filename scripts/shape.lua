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
      size = 0
      seeds = { first_S }
    }

    if first_S.diagonal then
      TEMP.size = 0.5
    else
      TEMP.size = 1.0
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

    if A2.size > A1.size then
      A1, A2 = A2, A1
    end

    A1.size = A1.size + A2.size

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
    A2.size  = nil
    A2.seeds = nil
  end


  local function eval_merge(A1, A2, dir)
    local score = 1

    if A1.size + A2.size <= MAX_SIZE then
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
      perform_merge(A1, A2)
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

      if A1.size < MIN_SIZE then
        try_merge_an_area(A1)
      end
    end

    prune_dead_areas()
  end


  local function make_real_areas()
    -- FIXME
  end


  ---| Shape_fill_gaps |---

  create_temp_areas()

  for loop = 1,30 do
    merge_temp_areas()
  end

  make_real_areas()
end



function Shape_create_areas()

-- TODO : Shape_add_shapes()

-- TODO : Shape_make_hallways()

  Shape_fill_gaps()

  Area_squarify_seeds()
  Area_find_neighbors()
end

