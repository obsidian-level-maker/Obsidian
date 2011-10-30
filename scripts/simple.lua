----------------------------------------------------------------
--  SIMPLE ROOMS : CAVES and MAZES
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2009-2011 Andrew Apted
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


function Simple_cave_or_maze(R)

  local map
  local cave

  local point_list

--[[
  R.cave_floor_h = 0 --!!!!!!  R.entry_floor_h
  R.cave_h = rand.pick { 128, 128, 192, 256 }
--]]

--[[
  if R.outdoor and THEME.landscape_walls then
    R.cave_tex = rand.key_by_probs(THEME.landscape_walls)

    if LEVEL.liquid and
       R.svolume >= style_sel("lakes", 99, 49, 49, 30) and
       rand.odds(style_sel("lakes", 0, 10, 30, 90))
    then
      R.is_lake = true
    end
  else
    R.cave_tex = rand.key_by_probs(THEME.cave_walls)
  end
--]]


  local function set_whole(C, value)
    for cx = C.cave_x1, C.cave_x2 do
      for cy = C.cave_y1, C.cave_y2 do
        map:set(cx, cy, value)
      end
    end
  end


  local function set_side(C, side, value)
    local x1,y1, x2,y2 = geom.side_coords(side, C.cave_x1,C.cave_y1, C.cave_x2,C.cave_y2)

    for cx = x1,x2 do for cy = y1,y2 do
      map:set(cx, cy, value)
    end end
  end


--[[
  local function set_corner(S, side, value)
    local mx = (S.sx - R.sx1) * 3 + 1
    local my = (S.sy - R.sy1) * 3 + 1

    local dx, dy = geom.delta(side)

    mx = mx + 1 + dx
    my = my + 1 + dy

    map:set(mx, my, value)
  end


  local function handle_wall(S, side)
    local N = S:neighbor(side)

    if not N or not N.room then
      return set_side(S, side, (R.is_lake ? -1 ; 1))
    end

    if N.room == S.room then return end

    if N.room.natural then
      return set_side(S, side, (R.is_lake ? -1 ; 1))
    end

    set_side(S, side, (R.is_lake ? -1 ; 1))
  end


  local function handle_corner(S, side)
    local N = S:neighbor(side)

    local A = S:neighbor(geom.ROTATE[1][side])
    local B = S:neighbor(geom.ROTATE[7][side])

    if not (A and A.room == R) or not (B and B.room == R) then
      return
    end

    if not N or not N.room then
      if R.is_lake then set_corner(S, side, -1) end
      return
    end

    if N.room == S.room then return end

    if N.room.nature then return end

    set_corner(S, side, -1)
  end
--]]


  local function clear_importants()
    each C in R.chunks do
      if C.foobage == "important" or C.foobage == "conn" or
         C.crossover_hall
      then
        set_whole(C, -1)
      end
    end
  end


  local function create_map()
---##  local sx1, sx2 = 999, -999
---##  local sy1, sy2 = 999, -999
---##
---##  each C in R.chunks do
---##    sx1 = math.min(sx1, C.sx1)
---##    sy1 = math.min(sy1, C.sy1)
---##
---##    sx2 = math.max(sx2, C.sx2)
---##    sy2 = math.max(sy2, C.sy2)
---##  end
---##
---##  assert(sx1 <= sx2)
---##  assert(sy1 <= sy2)

    R.cave_base_x = SEEDS[R.sx1][R.sy1].x1
    R.cave_base_y = SEEDS[R.sx1][R.sy1].y1

    map = CAVE_CLASS.new(R.cave_base_x, R.cave_base_y, R.sw * 3, R.sh * 3)

    -- determine location of chunks inside this map
    each C in R.chunks do
      C.cave_x1 = (C.sx1 - R.sx1) * 3 + 1
      C.cave_y1 = (C.sy1 - R.sy1) * 3 + 1

      C.cave_x2 = (C.sx2 - R.sx1) * 3 + 3
      C.cave_y2 = (C.sy2 - R.sy1) * 3 + 3
    end
  end


  local function mark_boundaries()
    each C in R.chunks do
      if C.void or C.scenic or C.cross_junc then continue end

      map:fill(C.cave_x1, C.cave_y1, C.cave_x2, C.cave_y2, 0)

      for dir = 2,8,2 do
        if not C:similar_neighbor(dir) and not C.link[dir] and
           not (C.foobage == "important")
        then
          set_side(C, dir, (R.is_lake ? -1 ; 1))
        end
      end
    end
  end


  local function clear_walks()
    each C in R.chunks do
      if C:has_walk() and rand.odds(25) then

        for cx = C.cave_x1, C.cave_x2 do
          for cy = C.cave_y1, C.cave_y2 do
            if map:get(cx, cy) == 0 and rand.odds(25) then
              map:set(cx, cy, -1)
            end
          end
        end

      end
    end
  end


  local function collect_important_points()
    point_list = {}

    each C in R.chunks do
      if C.foobage == "important" or C.foobage == "conn" then

        local POINT =
        {
          x = math.i_mid(C.cave_x1, C.cave_x2)
          y = math.i_mid(C.cave_y1, C.cave_y2)
        }

        table.insert(point_list, POINT)
      end
    end

    assert(#point_list > 0)
  end


  local function is_cave_good(cave)
    -- check that all important parts are connected

    if not cave:validate_conns(point_list) then
      gui.debugf("cave failed connection check\n")
      return false
    end

    cave.empty_id = cave.flood[point_list[1].x][point_list[1].y]

    assert(cave.empty_id)
    assert(cave.empty_id < 0)

    if not cave:validate_size(cave.empty_id) then
      gui.debugf("cave failed size check\n")
      return false
    end

    return true
  end


  local function generate_cave()
    map:dump("Empty Cave:")

    local MAX_LOOP = 10

    for loop = 1,MAX_LOOP do
      gui.debugf("Trying to make a cave: loop %d\n", loop)

      cave = map:copy()

      if loop >= MAX_LOOP then
        gui.printf("Failed to generate a usable cave! (%s)\n", R:tostr())

        -- emergency fallback
        cave:gen_empty()

        cave:flood_fill()

        is_cave_good(cave)  -- set empty_id
        break
      end

      cave:generate((R.is_lake ? 58 ; 38))

      cave:remove_dots()

      cave:flood_fill()

      if is_cave_good(cave) then
        break
      end

      -- randomly clear some cells along the walk path.
      -- After each iteration the number of cleared cells will keep
      -- increasing, making it more likely to generate a valid cave.
      clear_walks()
    end

    R.cave_map = cave

    cave:solidify_pockets()

    cave:dump("Filled Cave:")

    cave:find_islands()
  end


  ----------->


  local w_tex  = cave_tex



  ---| Simple_cave_or_maze |---

  -- create the cave object and make the boundaries solid
  create_map()

  collect_important_points()

  mark_boundaries()

  clear_importants()

  generate_cave()

end



function Simple_create_areas(R)

  local function one_big_area()
    local AREA = AREA_CLASS.new("floor", R)

    table.insert(R.areas, AREA)

    each C in R.chunks do
      if not C.void and not C.scenic and not C.cross_junc then
        C.area = AREA
        C.cave = true
        table.insert(AREA.chunks, C)
      end
    end

    AREA.floor_map = R.cave_map:copy()

    AREA.floor_map:negate()
  end


  local cave_floor_h = 0 ---  assert(A.chunks[1].floor_h)


  local function step_test()

    local pos_list =
    {
      {
        x = point_list[1].x
        y = point_list[1].y
        area = R.entry_area
      }
    }


    local free = CAVE_CLASS.copy(cave)

    local cw = free.w
    local ch = free.h

    -- mark free areas with zero instead of negative [TODO: make into a cave method]
    for fx = 1,cw do for fy = 1,ch do
      if (free[fx][fy] or 0) < 0 then
        free[fx][fy] = 0
      end
    end end

    -- current bbox
    local cx1, cy1
    local cx2, cy2

    local GROW_PROBS = { 100, 80, 60, 40, 20 }


    local function grow_horiz(step, y, prob)
      for x = cx1, cx2 do
        if x > 1 and step[x][y] == 1 and step[x-1][y] == 0 and free[x-1][y] == 0 and rand.odds(prob) then
          step[x-1][y] = 1
          free[x-1][y] = 1
        end
      end

      for x = cx2, cx1, -1 do
        if x < cw and step[x][y] == 1 and step[x+1][y] == 0 and free[x+1][y] == 0 and rand.odds(prob) then
          step[x+1][y] = 1
          free[x+1][y] = 1
        end
      end
    end


    local function grow_vert(step, x, prob)
      for y = cy1, cy2 do
        if y > 1 and step[x][y] == 1 and step[x][y-1] == 0 and free[x][y-1] == 0 and rand.odds(prob) then
          step[x][y-1] = 1
          free[x][y-1] = 1
        end
      end

      for y = cy2, cy1, -1 do
        if y < ch and step[x][y] == 1 and step[x][y+1] == 0 and free[x][y+1] == 0 and rand.odds(prob) then
          step[x][y+1] = 1
          free[x][y+1] = 1
        end
      end
    end


    local function grow_it(step, loop)
      loop = 1 + (loop - 1) % 5
      local prob = 100 ---!!!!  GROW_PROBS[loop]
      
      for y = cy1, cy2 do
        grow_horiz(step, y, prob)
      end

      for x = cx1, cx2 do
        grow_vert(step, x, prob)
      end
    end


    local function grow_an_area(x, y, AREA)
      if not AREA then
        AREA = AREA_CLASS.new("floor", R) 

        table.insert(R.areas, AREA)
      end

      local step = CAVE_CLASS.blank_copy(cave)

      AREA.floor_map = step

      step:set_all(0)

      step.cells[x][y] = 1

      cx1 = x ; cx2 = x
      cy1 = x ; cy2 = y

      local count = 3  ---!!!  rand.pick { 2,2,3,3, 4,4,5,5, 8,12,20 }

      for loop = 1, count do
        grow_it(step, i)

        cx1 = cx1 - 1 ; cx2 = cx2 + 1
        cy1 = cy1 - 1 ; cy2 = cy2 + 1
      end

      -- !!!! FIXME FIXME: check if step overlaps any chunk [add chunk to area]

      step:subtract(freebies)

      -- it's possible the area got divided into two or more pieces.
      -- remove any piece not connected to the starting spot.
      step:flood_fill()

--[[ FIXME
      if step.solid_regions >= 2 then
        for id = 2,9999 do
          if step.regions[id] then
            step:kill_region(id)
          end
        end
      end
--]]
      freebies:union(step)

      step.square = true

      step:render(STEP_brush, { h=h })

      -- find new positions for growth  [FIXME: OPTIMISE]
      for x = 1, cave.w do for y = 1, cave.h do
        if (step:get(x, y) or 0) > 0 then
          for dir = 2,8,2 do
            local nx, ny = geom.nudge(x, y, dir)
            if freebies:valid_cell(nx, ny) and (freebies:get(nx, ny) or 0) < 0 then
              table.insert(pos_list, { x=nx, y=ny })
            end
          end
        end
      end end
    end

    ------>

    while #pos_list > 0 do
      local pos = table.remove(pos_list, rand.irange(1, #pos_list))

      -- ignore out-of-date positions
      if free:get(pos.x, pos.y) > 0 then continue end

      grow_an_area(pos.x, pos.y, pos.area)
    end
  end


  ---| Simple_create_areas |---

  if false then
    one_big_area()
  else
    step_test()
  end
end



function Simple_connect_all_areas(R)

  local z_dir = 1

  local function recurse(A)
    assert(A.floor_h)

    if not A.touching then return end

    each N in A.touching do
      if not N.floor_h then
        local new_h = A.floor_h + z_dir * rand.sel(35, 8, 16)

        N:set_floor(new_h)

        recurse(N)
      end
    end
  end


  ---| Simple_connect_all_areas |---

  recurse(R.entry_area)
end



function Simple_render_cave(R)

  local cave = R.cave_map

  local cave_tex = R.main_tex or "_ERROR"


  local function choose_tex(last, tab)
    local tex = rand.key_by_probs(tab)

    if last then
      for loop = 1,5 do
        if not Mat_similar(last, tex) then break; end
        tex = rand.key_by_probs(tab)
      end
    end

    return tex
  end


  local function WALL_brush(data, coords)
    if data.shadow_info then
      local sh_coords = Brush_shadowify(coords, 40)
--!!!!      Trans.old_brush(data.shadow_info, sh_coords, -EXTREME_H, (data.z2 or EXTREME_H) - 4)
    end

    if data.f_h then table.insert(coords, { t=data.f_h, delta_z=data.f_delta }) end
    if data.c_h then table.insert(coords, { b=data.c_h, delta_z=data.c_delta }) end

    Brush_set_mat(coords, data.w_mat, data.w_mat)

    brush_helper(coords)
  end


  local function FC_brush(data, coords)
    if data.f_h then
      local coord2 = table.deep_copy(coords)
      table.insert(coord2, { t=data.f_h, delta_z=data.f_delta })

      Brush_set_mat(coord2, data.f_mat, data.f_mat)

      brush_helper(coord2)
    end

    if data.c_h then
      local coord2 = table.deep_copy(coords)
      table.insert(coord2, { b=data.c_h, delta_z=data.c_delta })

      Brush_set_mat(coord2, data.c_mat, data.c_mat)

      brush_helper(coord2)
    end
  end


  local function render_walls()

    --- DO WALLS ---

    local data = { w_mat = cave_tex }

--[[
    if R.is_lake then
      local liq_mat = Mat_lookup(LEVEL.liquid.mat)
      data.delta_f = rand.sel(70, -48, -72)
      data.f_h = cave_floor_h + 8
      data.ftex = liq_mat.f or liq_mat.t
    end

    if R.outdoor and not R.is_lake and cave_floor_h + 144 < SKY_H and rand.odds(88) then
      data.f_h = R.cave_floor_h + rand.sel(65, 80, 144)
    end

    if PARAM.outdoor_shadows and R.outdoor and not R.is_lake then
  --!!!!!    data.shadow_info = get_light(-1)
    end
--]]

    -- grab walkway now (before main cave is modified)

---!!!!!!  local walkway = cave:copy_island(cave.empty_id)


    if THEME.square_caves or true then   --@@@@@@
      cave.square = true
    end

    cave:render(WALL_brush, data)


    -- handle islands first

--[[
    each island in cave.islands do

      -- FIXME
      if LEVEL.liquid and not R.is_lake and --(( reg.cells > 4 and --))
         rand.odds(1)
      then

        -- create a lava/nukage pit
        local pit = Mat_lookup(LEVEL.liquid.mat)

        island:render(WALL_brush,
                      { f_h=R.cave_floor_h+8, pit.f or pit.t,
                        delta_f=rand.sel(70, -52, -76) })

        cave:subtract(island)
      end
    end
--]]


do return end ----!!!!!!!


    if R.is_lake then return end
    if THEME.square_caves then return end
    if PARAM.simple_caves then return end


    local ceil_h = R.cave_floor_h + R.cave_h

    -- TODO: @ pass 3, 4 : come back up (ESP with liquid)

    local last_ftex = R.cave_tex

    for i = 1,rand.index_by_probs({ 10,10,70 })-1 do
      walkway:shrink(false)

  ---???    if rand.odds(sel(i==1, 20, 50)) then
  ---???      walkway:shrink(false)
  ---???    end

      walkway:remove_dots()


      -- DO FLOOR and CEILING --

      data = {}


      if R.outdoor then
        data.ftex = choose_tex(last_ftex, THEME.landscape_trims or THEME.landscape_walls)
      else
        data.ftex = choose_tex(last_ftex, THEME.cave_trims or THEME.cave_walls)
      end

      last_ftex = data.ftex

      data.do_floor = true

      if LEVEL.liquid and i==2 and rand.odds(60) then  -- TODO: theme specific prob
        local liq_mat = Mat_lookup(LEVEL.liquid.mat)
        data.ftex = liq_mat.f or liq_mat.t

        -- FIXME: this bugs up monster/pickup/key spots
        if rand.odds(0) then
          data.delta_f = -(i * 10 + 40)
        end
      end

      if true then
        data.delta_f = -(i * 10)
      end

      data.f_h = R.cave_floor_h + i

      data.do_ceil = false

      if not R.outdoor then
        data.do_ceil = true

        if i==2 and rand.odds(60) then
          local mat = Mat_lookup("_SKY")
          data.ctex = mat.f or mat.t
        elseif rand.odds(50) then
          data.ctex = data.ftex
        elseif rand.odds(80) then
          data.ctex = choose_tex(data.ctex, THEME.cave_trims or THEME.cave_walls)
        end

        data.delta_c = int((0.6 + (i-1)*0.3) * R.cave_h)

        data.c_z = ceil_h - i
      end


      walkway:render(FC_brush, data)
    end
  end


  local function render_floor_ceil(A)
    assert(A.floor_map)

    A.floor_map.square = true  --!!!

    local data =
    {
      f_h = A.floor_h + 2
      c_h = A.floor_h + 92

      f_mat = cave_tex
      c_mat = cave_tex
    }

    A.floor_map:render(FC_brush, data)
  end


  ---| Simple_connect_and_render |---
  
  render_walls()

  each A in R.areas do
    render_floor_ceil(A)
  end
end

