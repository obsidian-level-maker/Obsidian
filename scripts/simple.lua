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


function Simple_area(R, A)

  local map
  local cave

  local cave_tex = R.main_tex or "_ERROR"
  local cave_floor_h = assert(A.chunks[1].floor_h)

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


  local function setup_floor(S, h)
    S.floor_h = h

    S.f_tex = R.cave_tex
    S.w_tex = R.cave_tex

    if not R.outdoor then
      S.ceil_h  = h + R.cave_h
      S.c_tex = R.cave_tex
    end

    for side = 2,8,2 do
      local B = S.border[side]
      local C = B and B.conn

      if C then
        if C.conn_h then assert(C.conn_h == S.floor_h) end

        C.conn_h = h
      end
    end
  end


  local function set_cell(cx, cy, value)
    -- do not overwrite any cleared areas
---???    if (map:get(cx, cy) or 0) >= 0 then
      map:set(cx, cy, value)
---???    end
  end


  local function set_whole(C, value)
    for cx = C.cave_x1, C.cave_x2 do
      for cy = C.cave_y1, C.cave_y2 do
        set_cell(cx, cy, value)
      end
    end
  end


  local function set_side(C, side, value)
    local x1,y1, x2,y2 = geom.side_coords(side, C.cave_x1,C.cave_y1, C.cave_x2,C.cave_y2)

    for cx = x1,x2 do for cy = y1,y2 do
      set_cell(cx, cy, value)
    end end
  end


--[[
  local function set_corner(S, side, value)
    local mx = (S.sx - R.sx1) * 3 + 1
    local my = (S.sy - R.sy1) * 3 + 1

    local dx, dy = geom.delta(side)

    mx = mx + 1 + dx
    my = my + 1 + dy

    set_cell(mx, my, value)
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
    each C in A.chunks do
      if C.foobage == "important" or C.foobage == "conn" or
         C.crossover_hall
      then
        set_whole(C, -1)
      end
    end
  end


  local function FIXME_initial_map()
    for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
      local S = SEEDS[x][y]
      if S.room == R then
        local mx = (S.sx - R.sx1) * 3 + 1
        local my = (S.sy - R.sy1) * 3 + 1

        if not S.floor_h then
          setup_floor(S, cave_floor_h)
        end

        for dx = 0,2 do for dy = 0,2 do
          map:set(mx+dx, my+dy, 0)
        end end

        for side = 2,8,2 do
          handle_wall(S, side)
        end

        for side = 1,9,2 do if side != 5 then
          handle_corner(S, side)
        end end
      end
    end end -- for x, y
  end


  local function create_map()
    -- determine area bounds  [FIXME: make into AREA method]
    local sx1, sx2 = 999, -999
    local sy1, sy2 = 999, -999

    each C in A.chunks do
      sx1 = math.min(sx1, C.sx1)
      sy1 = math.min(sy1, C.sy1)

      sx2 = math.max(sx2, C.sx2)
      sy2 = math.max(sy2, C.sy2)
    end

    assert(sx1 <= sx2)
    assert(sy1 <= sy2)

    A.cave_sx1 = sx1
    A.cave_sy1 = sy1

    A.cave_sw = sx2 - sx1 + 1
    A.cave_sh = sy2 - sy1 + 1

    A.cave_base_x = SEEDS[sx1][sy1].x1
    A.cave_base_y = SEEDS[sy1][sy1].y1

    map = CAVE_CLASS.new(A.cave_sw * 3, A.cave_sh * 3)

    -- determine location of chunks inside this map
    each C in A.chunks do
      C.cave_x1 = (C.sx1 - A.cave_sx1) * 3 + 1
      C.cave_y1 = (C.sy1 - A.cave_sy1) * 3 + 1

      C.cave_x2 = (C.sx2 - A.cave_sx1) * 3 + 3
      C.cave_y2 = (C.sy2 - A.cave_sy1) * 3 + 3
    end
  end


  local function mark_boundaries()
    each C in A.chunks do
      map:fill(C.cave_x1, C.cave_y1, C.cave_x2, C.cave_y2, 0)

      for dir = 2,8,2 do
        if not C:similar_neighbor(dir) and not C.link[dir] and
           not (C.foobage == "important")
        then
          set_side(C, dir, (A.is_lake ? -1 ; 1))
        end
      end
    end
  end


  local function clear_walks()
    each C in A.chunks do
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


  local function is_cave_good(cave)
    -- check that all important parts are connected

    local point_list = {}

    each C in A.chunks do
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

    if not cave:validate_conns(point_list) then
      gui.debugf("cave failed connection check\n")
      return false
    end

    -- FIXME: size check

    --[[   ????
    local reg, size_ok = flood:main_empty_region()

    if not reg or not size_ok then
      gui.debugf("cave failed size check\n")
      return false
    end
    --]]

    return true
  end


  local function generate_cave()

    map:dump("Empty Cave:")

    -- FIXME !!!! on each failure, force a clear path between two importants

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

      cave:generate((A.is_lake ? 58 ; 38))

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

    cave:dump("Filled Cave:")

    cave:find_islands()
  end


  ----------->


  local w_tex  = cave_tex

  local high_z = EXTREME_H



  local function WALL_brush(data, coords)
    if data.shadow_info then
      local sh_coords = Brush_shadowify(coords, 40)
--!!!!      Trans.old_brush(data.shadow_info, sh_coords, -EXTREME_H, (data.z2 or EXTREME_H) - 4)
    end

    if data.f_z then table.insert(coords, { t=data.f_z, delta_z=data.f_delta_z }) end
    if data.c_z then table.insert(coords, { b=data.c_z, delta_z=data.c_delta_z }) end

    Brush_set_mat(coords, cave_tex, cave_tex)

    brush_helper(coords)
  end


  local function FC_brush(data, coords)
    if data.do_floor then
      local coord2 = table.deep_copy(coords)
      table.insert(coord2, { t=data.f_z, delta_z=data.delta_f })

      Brush_set_mat(coord2, data.wtex, data.ftex)

      brush_helper(coord2)
    end

    if data.do_ceil then
      local coord2 = table.deep_copy(coords)
      table.insert(coord2, { b=data.c_z, delta_z=data.delta_c })

      Brush_set_mat(coords, data.wtex, data.ctex)

      brush_helper(coord2)
    end
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


  local function render_cave()

    --- DO WALLS ---

    local data = { }  ---????  info=w_info, wtex=w_tex, ftex=w_tex, ctex=w_tex }

--[[
    if R.is_lake then
      local liq_mat = Mat_lookup(LEVEL.liquid.mat)
      data.delta_f = rand.sel(70, -48, -72)
      data.f_z = cave_floor_h + 8
      data.ftex = liq_mat.f or liq_mat.t
    end

    if R.outdoor and not R.is_lake and cave_floor_h + 144 < SKY_H and rand.odds(88) then
      data.f_z = R.cave_floor_h + rand.sel(65, 80, 144)
    end

    if PARAM.outdoor_shadows and R.outdoor and not R.is_lake then
  --!!!!!    data.shadow_info = get_light(-1)
    end
--]]

    -- grab walkway now (before main cave is modified)

---!!!!!!  local walkway = cave:copy_island(cave.empty_id)


    -- handle islands first

--[[
    each island in cave.islands do

      -- FIXME
      if LEVEL.liquid and not R.is_lake and --(( reg.cells > 4 and --))
         rand.odds(1)
      then

        -- create a lava/nukage pit
        local pit = Mat_lookup(LEVEL.liquid.mat)

        island:render(base_x, base_y, WALL_brush,
                      { f_z=R.cave_floor_h+8, pit.f or pit.t,
                        delta_f=rand.sel(70, -52, -76) })

        cave:subtract(island)
      end
    end
--]]


    cave:render(A.cave_base_x, A.cave_base_y, WALL_brush, data, THEME.square_caves)


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

      data.f_z = R.cave_floor_h + i

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


      walkway:render(base_x, base_y, FC_brush, data)
    end
  end


  ---| Simple_area |---

  -- create the cave object and make the boundaries solid
  create_map()

  mark_boundaries()

  clear_importants()

  generate_cave()

  render_cave()
end

