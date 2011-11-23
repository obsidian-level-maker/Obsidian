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

    R.point_list = point_list
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

  local cover_chunks


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


  local function collect_cover_chunks()
    -- find the chunks which must be completed covered by any area.
    cover_chunks = {}

    each C in R.chunks do
      if C.foobage == "important" or C.foobage == "conn" then
        table.insert(cover_chunks, C)
      end
    end
  end


  local cave_floor_h = 0 ---  assert(A.chunks[1].floor_h)


  local function step_test()

    local pos_list = { }

    pos_list[1] =
    {
      x = R.point_list[1].x
      y = R.point_list[1].y
    }


    local free  = CAVE_CLASS.copy(R.cave_map)
    local f_cel = free.cells

    local step
    local s_cel
    local size

    local cw = free.w
    local ch = free.h

    -- current bbox : big speed up by limiting the scan area
    local cx1, cy1
    local cx2, cy2


    -- mark free areas with zero instead of negative [TODO: make into a cave method]
    for fx = 1,cw do for fy = 1,ch do
      if (f_cel[fx][fy] or 0) < 0 then
        f_cel[fx][fy] = 0
      end
    end end


    local function grow_horiz(y, prob)
      for x = cx1, cx2 do
        if x > 1 and s_cel[x][y] == 1 and s_cel[x-1][y] == 0 and f_cel[x-1][y] == 0 and rand.odds(prob) then
          s_cel[x-1][y] = 1
          f_cel[x-1][y] = 1
          size = size + 1
        end
      end

      for x = cx2, cx1, -1 do
        if x < cw and s_cel[x][y] == 1 and s_cel[x+1][y] == 0 and f_cel[x+1][y] == 0 and rand.odds(prob) then
          s_cel[x+1][y] = 1
          f_cel[x+1][y] = 1
          size = size + 1
        end
      end
    end


    local function grow_vert(x, prob)
      for y = cy1, cy2 do
        if y > 1 and s_cel[x][y] == 1 and s_cel[x][y-1] == 0 and f_cel[x][y-1] == 0 and rand.odds(prob) then
          s_cel[x][y-1] = 1
          f_cel[x][y-1] = 1
          size = size + 1
        end
      end

      for y = cy2, cy1, -1 do
        if y < ch and s_cel[x][y] == 1 and s_cel[x][y+1] == 0 and f_cel[x][y+1] == 0 and rand.odds(prob) then
          s_cel[x][y+1] = 1
          f_cel[x][y+1] = 1
          size = size + 1
        end
      end
    end


    local function grow_it(prob)
      for y = cy1, cy2 do
        grow_horiz(y, prob)
      end

      for x = cx1, cx2 do
        grow_vert(x, prob)
      end

      -- expand bbox
      if cx1 > 1  then cx1 = cx1 - 1 end
      if cy1 > 1  then cy1 = cy1 - 1 end

      if cx2 < cw then cx2 = cx2 + 1 end
      if cy2 < ch then cy2 = cy2 + 1 end
    end


    local function chunk_touches_step(C)
      -- early out by checking the bbox
      if C.cave_x1 > cx2 or C.cave_x2 < cx1 or
         C.cave_y1 > cy2 or C.cave_y2 < cy1
      then
        return "no"
      end

      local hit  = 0
      local miss = 0

      for x = C.cave_x1, C.cave_x2 do
        for y = C.cave_y1, C.cave_y2 do
          if s_cel[x][y] == 1 then
            hit = hit + 1
          else
            miss = miss + 1
          end
        end
      end

      if hit == 0 then return "no" end

      if miss == 0 then return "cover" end

      return "partial"
    end


    local function test_cover_chunks(finished_chunks)
      -- Note: the growth here can cause more chunks to be touched,
      --       hence need to repeat the test when that happens.
      repeat
        local grew = false

        for index = #cover_chunks, 1, -1 do
          local C = cover_chunks[index]

          local what = chunk_touches_step(C)

          if what == "no" then continue end

          -- while the step only partially covers the chunk, keep growing it
          -- (this should always stop, but limit the loop just in case)
          for loop = 1,30 do
            if what == "cover" then break end

            if loop == 30 then
              gui.printf("WARNING: failed to cover a chunk\n")
            end

            grow_it(100)

            grew = true
--step:dump("After touching growth")

            what = chunk_touches_step(C)
            assert(what != "no")
          end

          -- chunk is now covered, add to area and remove from list
          table.insert(finished_chunks, C)

          table.remove(cover_chunks, index)
        end

      until not grew
    end

    
    local function merge_step(prev)
      -- meh, need this functions because union() method does not
      --      consider '0' as a valid value.
      -- At least this one is a bit more efficient :)

      for x = cx1, cx2 do for y = cy1, cy2 do
        if s_cel[x][y] == 1 then
          prev.cells[x][y] = 1
        end
      end end
    end


    local function grow_an_area(cx, cy, prev_A)

-- free:dump("Free:")

      step  = CAVE_CLASS.blank_copy(free)
      s_cel = step.cells

      step:set_all(0)

      -- set initial point
      s_cel[cx][cy] = 1
      f_cel[cx][cy] = 1
      size = 1

      cx1 = cx ; cx2 = cx
      cy1 = cy ; cy2 = cy

      local count = 4  ---!!!  rand.pick { 2,2,3,3, 4,4,5,5, 8,12,20 }

      grow_it(100)

      for loop = 1, count do
        grow_it(50)
      end

      if size < 4 then grow_it(100) end

-- step:dump("Step before:")

      -- check if the step overlaps any important chunk.
      -- these will require the step to keep growing to cover the chunk,
      -- and the chunk gets added to the AREA's chunk list (which is
      -- vital for height distribution ETC).
      local chunks = {}

      test_cover_chunks(chunks)

-- step:dump("Step after:")

      -- when the step is too small, merge it into previous area
      if size < 4 and prev_A then
        
        merge_step(prev_A.floor_map)

      else
        local AREA = AREA_CLASS.new("floor", R) 

        AREA.touching = {}

        table.insert(R.areas, AREA)

        AREA.floor_map = step

---##        if prev_A then
---##          prev_A:add_touching(AREA)
---##            AREA:add_touching(prev_A)
---##        end

        prev_A = AREA
      end

      each C in chunks do
        table.insert(prev_A.chunks, C)

        C.area = prev_A
      end


      -- find new positions for growth

      for x = cx1, cx2 do for y = cy1, cy2 do
        if s_cel[x][y] == 1 then
          for dir = 2,8,2 do
            local nx, ny = geom.nudge(x, y, dir)
            if free:valid_cell(nx, ny) and f_cel[nx][ny] == 0 then
              table.insert(pos_list, { x=nx, y=ny, prev=prev_A })
            end
          end
        end
      end end

-- LIGHTING TEST CRAP
  if GAME.format != "doom" then
    prev_A.light_x = step.base_x + 32 + (cx-1) * 64
    prev_A.light_y = step.base_y + 32 + (cy-1) * 64
  end

    end

    ------>

    while #pos_list > 0 do
      local pos = table.remove(pos_list, rand.irange(1, #pos_list))

      -- ignore out-of-date positions
      if f_cel[pos.x][pos.y] != 0 then continue end

      grow_an_area(pos.x, pos.y, pos.prev)
    end
  end


  local function create_area_map()
    -- create a map where each cell refers to an AREA, or is NIL.

    local area_map = CAVE_CLASS.blank_copy(R.cave_map)

    local W = R.cave_map.w
    local H = R.cave_map.h

    each A in R.areas do
      for x = 1,W do for y = 1,H do
        if (A.floor_map.cells[x][y] or 0) > 0 then
          area_map.cells[x][y] = A
        end
      end end
    end

    R.area_map = area_map
  end


  local function determine_touching_areas()
    local W = R.cave_map.w
    local H = R.cave_map.h

    local area_map = R.area_map

    for x = 1,W do for y = 1,H do
      local A1 = area_map.cells[x][y]

      if not A1 then continue end

      for dir = 2,8,2 do
        local nx, ny = geom.nudge(x, y, dir)

        if not area_map:valid_cell(nx, ny) then continue end

        local A2 = area_map.cells[nx][ny]

        if A2 and A2 != A1 then
          A1:add_touching(A2)
          A2:add_touching(A1)
        end
      end
    end end

    -- verify all areas touch at least one other
    if #R.areas > 1 then
      each A in R.areas do
        assert(not table.empty(A.touching))
      end
    end
  end


  ---| Simple_create_areas |---

  if false then
    one_big_area()
  else
    collect_cover_chunks()

    step_test()

    if #cover_chunks > 0 then
      error("Cave steps failed to cover all important chunks\n")
    end
  end

  create_area_map()

  determine_touching_areas()

--[[ debugging
  each A in R.areas do
    assert(A.floor_map)

    A.floor_map:dump("Step for " .. A:tostr())
  end
--]]
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

-- LIGHTING TEST CRAP
  if GAME.format != "doom" then
    local x = assert(N.light_x)
    local y = assert(N.light_y)
    local z = N.floor_h + rand.pick { 40,60,80 }
    local rad = rand.pick { 100, 200, 300 }
    entity_helper("light", x, y, z, { light=128, _radius=rad })
  end

        recurse(N)
      end
    end
  end


  ---| Simple_connect_all_areas |---

  recurse(R.entry_area)
end



function Simple_render_cave(R)

  local cave = R.cave_map

  local cave_tex = R.wall_mat or "_ERROR"

  -- the delta map specifies how to move each corner of the 64x64 cells
  -- (where the cells form a continuous mesh).
  local delta_x_map
  local delta_y_map

  local dw = cave.w + 1
  local dh = cave.h + 1


  local function corner_nb(x, y, dir)
    -- FIXME !!!!
  end


  local function analyse_corner(x, y)
    --  A | B
    --  --+--
    --  C | D

    local A = corner_nb(x, y, 7)
    local B = corner_nb(x, y, 9)
    local C = corner_nb(x, y, 1)
    local D = corner_nb(x, y, 3)

    -- don't move a corner at edge of room
    if not A or not B or not C or not D then
      return
    end

    -- solid cells always override floor cells
    if A == "#" or B == "#" or C == "#" or D == "#" then
      A = (A == "#")
      B = (B == "#")
      C = (C == "#")
      D = (D == "#")
    else
      -- otherwise pick highest floor (since that can block a lower floor)
      local max_h = math.max(A, B, C, D) - 2

      A = (A > max_h)
      B = (B > max_h)
      C = (C > max_h)
      D = (D > max_h)
    end

    -- no need to move when all cells are the same
    if A == B and A == C and A == D then
      return
    end

    local x_mul = 1
    local y_mul = 1

    -- flip horizontally and/or vertically to ease analysis
    if not A then
      A, B = B, A
      C, D = D, C
      x_mul = -1
    end

    if not A then
      A, C = C, A
      B, D = D, B
      y_mul = -1
    end
      
    assert(A)

    --- ANALYSE! ---

    if not B and not C and not D then
      -- sticking out corner
      if rand.odds(90) then delta_x_map[x][y] = -16 * x_mul end
      if rand.odds(90) then delta_y_map[x][y] = -16 * y_mul end

    elseif B and not C and not D then
      -- horizontal wall
      if rand.odds(55) then delta_y_map[x][y] = -24 * y_mul end

    elseif C and not B and not D then
      -- vertical wall
      if rand.odds(55) then delta_x_map[x][y] = -24 * x_mul end

    elseif D and not B and not C then
      -- checkerboard
      -- (not moving it : this situation should not occur)

    else
      -- sticking out empty corner
      -- expand a bit, but not enough to block player movement
          if not B then y_mul = -y_mul
      elseif not C then x_mul = -x_mul
      end

      if rand.odds(90) then delta_x_map[x][y] = 12 * x_mul end
      if rand.odds(90) then delta_y_map[x][y] = 12 * y_mul end
    end
  end


  local function create_delta_map()
    delta_x_map = table.array_2D(dw, dh)
    delta_y_map = table.array_2D(dw, dh)

    for x = 1,dw do for y = 1,dh do
      analyse_corner(x, y)
    end end
  end


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

      if R.kind != "outdoor" then
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

    A.floor_map.square = false  --!!!
    A.floor_map.expand = true

    local data =
    {
      f_h = A.floor_h + 2
      c_h = A.floor_h + 122

      f_mat = cave_tex
      c_mat = cave_tex
    }

    A.floor_map:render(FC_brush, data)
  end


  ---| Simple_render_cave |---
  
  create_delta_map()

  render_walls()

  each A in R.areas do
    render_floor_ceil(A)
  end
end

