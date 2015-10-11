------------------------------------------------------------------------
--  CAVES and MAZES
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2009-2014 Andrew Apted
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

--[[ *** CLASS INFORMATION ***

class CAVE_INFO
{
  W, H  -- size of cave (# of cells)

  x1, y1, x2, y2  -- bounding coords

  liquid_mode : keyword  -- "none", "some", "lake"

  step_mode   : keyword  -- "walkway", "up", "down", "mixed"

  sky_mode    : keyword  -- "none"
                         -- "some", "walkway"  (indoor rooms only)
                         -- "low_wall", "high_wall"  (outdoor rooms)

  cave : CAVE  -- raw generated cave

  blocks : array(AREA)  -- info for each 64x64 block

  floors : list(AREA)
  lakes  : list(AREA)

  wall   : AREA
  fence  : AREA
}


class AREA
{
  --| this info is used to describe each cave cell
  --| (and generally shared between multiple cells).

  wall   : boolean  -- true for solid walls
  fence  : boolean  -- true for a lake fence

  liquid : boolean  -- true for a liquid floor
  sky    : boolean  -- true for a sky ceiling

  cx1, cy1, cx2, cy2   -- cell bounding box

  floor_h  -- floor height
   ceil_h  -- ceiling height

  floor_mat  -- floor material
   ceil_mat  -- ceiling material

  goal_type : keyword  -- set if area contains a goal (normally nil)
                       -- can be "portal" or "important".

  touching : list(AREA)   -- only used for visitable floors

  host_spots : list(BBOX)  -- spots which can host a torch/prefab

  -- stuff for walkways only
  children : list[AREA]
}

--------------------------------------------------------------]]


CELL_CORNERS = { 1,3,9,7 }


function Cave_brush(info, x, y)
  local bx = info.x1 + (x - 1) * 64
  local by = info.y1 + (y - 1) * 64

  local coords = {}

  each side in CELL_CORNERS do
    local dx, dy = geom.delta(side)

    local fx = bx + sel(dx < 0, 0, 64)
    local fy = by + sel(dy < 0, 0, 64)

    local cx =  x + sel(dx < 0, 0, 1)
    local cy =  y + sel(dy < 0, 0, 1)

    fx = fx + (info.delta_x_map[cx][cy] or 0)
    fy = fy + (info.delta_y_map[cx][cy] or 0)

    table.insert(coords, { x=fx, y=fy })
  end

  return coords
end



function Cave_generate_cave(R)
  local info = R.cave_info

  local map
  local cave

  local importants = {}
  local point_list = {}

  local is_lake = (info.liquid_mode == "lake")


  local function cave_box_for_seed(sx, sy)
    local box =
    {
      cx1 = (sx - R.sx1) * 3 + 1
      cy1 = (sy - R.sy1) * 3 + 1
    }

    box.cx2 = box.cx1 + 2
    box.cy2 = box.cy1 + 2
    
    return box
  end


  local function set_side(cx1, cy1, cx2, cy2, side, value)
    local x1,y1, x2,y2 = geom.side_coords(side, cx1,cy1, cx2,cy2)

    map:fill(x1, y1, x2, y2, value)
  end


  local function set_corner(cx1, cy1, cx2, cy2, side, value)
    local cx, cy = geom.pick_corner(side, cx1, cy1, cx2, cy2)

    map:set(cx, cy, value)
  end


  local function create_map()
    info.W = R.sw * 3
    info.H = R.sh * 3

    info.blocks = table.array_2D(info.W, info.H)

    info.x1 = SEEDS[R.sx1][R.sy1].x1
    info.y1 = SEEDS[R.sx1][R.sy1].y1

    info.x2 = SEEDS[R.sx2][R.sy2].x2
    info.y2 = SEEDS[R.sx2][R.sy2].y2

    info.floors = {}

    local WALL_AREA =
    {
      wall = true
    }

    info.wall = WALL_AREA

    map = AUTOMATA_CLASS.new(info.W, info.H)
  end


  local function mark_boundaries()
    -- this also sets most parts of the cave to zero

    for sx = R.sx1, R.sx2 do
    for sy = R.sy1, R.sy2 do
      local S = SEEDS[sx][sy]

      if S.room != R then continue end

      local cx = (sx - R.sx1) * 3 + 1
      local cy = (sy - R.sy1) * 3 + 1

      map:fill(cx, cy, cx+2, cy+2, 0)

      for dir = 2,8,2 do
        if not S:same_room(dir) then
          set_side(cx, cy, cx+2, cy+2, dir, sel(is_lake, -1, 1))
        end

        -- in lake mode, clear whole seeds that touch edge of map
        -- (i.e. which will have a sky border next to them)
        if is_lake and S:need_lake_fence(dir) then
          map:fill(cx, cy, cx+2, cy+2, -1)
        end
      end

      for dir = 1,9,2 do if dir != 5 then
        if not S:same_room(dir) then
          -- lakes require whole seed to be cleared (esp. at "innie corners")
          if is_lake then
            map:fill(cx, cy, cx+2, cy+2, -1)
          else
            set_corner(cx, cy, cx+2, cy+2, dir, 1)
          end
        end
      end end

    end -- sx, sy
    end
  end


--[[
  local function clear_walks()
    for sx = R.sx1, R.sx2 do for sy = R.sy1, R.sy2 do
      local S = SEEDS[sx][sy]

      if S.room != R then continue end

      if S.is_walk and rand.odds(25) then

        local cx = (sx - R.sx1) * 4 + 1
        local cy = (sy - R.sy1) * 4 + 1

        for cx = cx, cx+3 do
          for cy = cy, cy+3 do
            if map:get(cx, cy) == 0 and rand.odds(25) then
              map:set(cx, cy, -1)
            end
          end
        end

      end
    end end -- sx, sy
  end
--]]


  local function check_need_wall(S, dir)
    -- don't clobber connections
    if S.border[dir].kind then return false end

    local N = S:neighbor(dir)

    if not (N and N.room) then return true end

    if N.room == R then return false end

    return true
  end


  local function add_needed_cave_walls(S)
    -- a seed has been cleared, but it may need a wall or fence on
    -- one of the sides...

    for dir = 2,8,2 do
      if check_need_wall(S, dir) then
        -- merely mark it here, handled by border_up()
        S.border[dir].cave_gap = true
      end
    end
  end


  local function clear_some_seeds()
    for sx = R.sx1, R.sx2 do
    for sy = R.sy1, R.sy2 do
      local S = SEEDS[sx][sy]

      if S.room != R then continue end

      if S.wall_dist < 1.1 then continue end

      if rand.odds(85) then continue end

      local cx = 1 + (sx - R.sx1) * 3
      local cy = 1 + (sy - R.sy1) * 3

      map:fill(cx, cy, cx+2, cy+2, -1)
    end
    end
  end


  local function point_for_portal(P)
    -- determine cave cell range:
    -- 1. if side of portal touches side of room, omit those cells
    -- 2. clear cells which touch portal, and two more away from it

    local b1 = cave_box_for_seed(P.sx1, P.sy1)
    local b2 = cave_box_for_seed(P.sx2, P.sy2)

    local cx1, cy1, cx2, cy2
    
    if geom.is_vert(P.side) then
      cx1 = b1.cx1
      cx2 = b2.cx2

      local yy = sel(P.side == 2, P.sy1, P.sy2)

      local S1 = SEEDS[P.sx1][yy]
      local S2 = SEEDS[P.sx2][yy]

      local N1 = S1:neighbor(4)
      local N2 = S2:neighbor(6)

      if not (N1 and N1.room == R) then cx1 = cx1 + 1 end
      if not (N2 and N2.room == R) then cx2 = cx2 - 1 end

      if P.side == 2 then
        cy1 = b1.cy1
        cy2 = b1.cy1 + 2
      else
        cy1 = b1.cy2 - 2
        cy2 = b1.cy2
      end

    else -- is_horiz(P.side)
      cy1 = b1.cy1
      cy2 = b2.cy2

      local xx = sel(P.side == 4, P.sx1, P.sx2)

      local S1 = SEEDS[xx][P.sy1]
      local S2 = SEEDS[xx][P.sy2]

      local N1 = S1:neighbor(2)
      local N2 = S2:neighbor(8)

      if not (N1 and N1.room == R) then cy1 = cy1 + 1 end
      if not (N2 and N2.room == R) then cy2 = cy2 - 1 end

      if P.side == 4 then
        cx1 = b1.cx1
        cx2 = b1.cx1 + 2
      else
        cx1 = b1.cx2 - 2
        cx2 = b1.cx2
      end
    end


    local IMP =
    {
      cx1 = cx1
      cy1 = cy1
      cx2 = cx2
      cy2 = cy2

      portal = P
    }

    table.insert(importants, IMP)

    local POINT =
    {
      x = math.i_mid(cx1, cx2)
      y = math.i_mid(cy1, cy2)
    }

    table.insert(point_list, POINT)
  end


  local function point_for_conn(C, S, side)
    local b = cave_box_for_seed(S.sx, S.sy)

    local POINT =
    {
      x = b.cx1 + 1
      y = b.cy1 + 1
    }

    table.insert(point_list, POINT)

    local IMP =
    {
      cx1 = b.cx1
      cy1 = b.cy1
      cx2 = b.cx2
      cy2 = b.cy2

      conn = C
    }

    table.insert(importants, IMP)
  end


  local function point_for_goal(G)
    local b = cave_box_for_seed(G.S.sx, G.S.sy)

--[[ V5 METHOD
    -- expand bbox slightly
    local x1, y1 = G.x1 - 12, G.y1 - 12
    local x2, y2 = G.x2 + 12, G.y2 + 12

    -- convert to cell coordinates
    x1 = x1 - info.x1 ; y1 = y1 - info.y1
    x2 = x2 - info.x1 ; y2 = y2 - info.y1

    local cx1 = 1 + int(x1 / 64)
    local cy1 = 1 + int(y1 / 64)

    local cx2 = 1 + int((x2 + 63) / 64)
    local cy2 = 1 + int((y2 + 63) / 64)

    cx1 = math.clamp(1, cx1, map.w)
    cy1 = math.clamp(1, cy1, map.h)

    cx2 = math.clamp(1, cx2, map.w)
    cy2 = math.clamp(1, cy2, map.h)

--]]
    local cx1 = b.cx1
    local cy1 = b.cy1
    local cx2 = b.cx2
    local cy2 = b.cy2

    assert(cx1 <= cx2)
    assert(cy1 <= cy2)

    local IMP =
    {
      cx1 = cx1
      cy1 = cy1
      cx2 = cx2
      cy2 = cy2

      goal = G
    }

    table.insert(importants, IMP)

    local POINT =
    {
--[[
      x = math.i_mid(cx1, cx2)
      y = math.i_mid(cy1, cy2)
--]]
      x = b.cx1 + 1
      y = b.cy1 + 1
    }

    table.insert(point_list, POINT)
  end


  local function collect_important_points()
    each C in R.conns do
      if R == C.R1 and C.S1 then
        point_for_conn(C, C.S1, C.dir)
      end
      if R == C.R2 and C.S2 then
        point_for_conn(C, C.S2, 10 - C.dir)
      end
    end

    each G in R.goals do
      point_for_goal(G)
    end

    assert(#point_list > 0)

    R.point_list = point_list
    R.cave_imps  = importants
  end


  local function clear_importants()
    each imp in importants do
      map:fill(imp.cx1, imp.cy1, imp.cx2, imp.cy2, -1)

      if imp.conn or true then
        local sx = R.sx1 + int(imp.cx1 / 3)
        local sy = R.sy1 + int(imp.cy1 / 3)

        add_needed_cave_walls(SEEDS[sx][sy])
      end
    end
  end


  local function is_cave_good(cave)
    -- check that all important parts are connected

    if not cave:validate_conns(point_list) then
      gui.debugf("cave failed connection check\n")
      return false
    end

    local p1 = point_list[1]

    cave.empty_id = cave.flood[p1.x][p1.y]

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

    local solid_prob = 38

    if is_lake then
      solid_prob = 58
    end

    local MAX_LOOP = 20

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

      cave:generate(solid_prob)

      cave:dump("Generated Cave:")

      cave:remove_dots()
      cave:flood_fill()

      if is_cave_good(cave) then
        break;
      end

      -- randomly clear some seeds in the room.
      -- After each iteration the number of cleared cells will keep
      -- increasing, making it more likely to generate a valid cave.
      clear_some_seeds()
    end

    info.cave = cave

    if not is_lake then
      cave:solidify_pockets()
    end

    cave:dump("Filled Cave:")

    cave:find_islands()
  end


  ---| Cave_generate_cave |---

  -- create the cave object and make the boundaries solid
  create_map()

  collect_important_points()

  mark_boundaries()

  clear_importants()

  generate_cave()
end



function Cave_area_host_parts(R, A)
  --|
  --| figure out if this area can host something inside it
  --| (e.g. a torch or a cage prefab).
  --|
  --| stores a list of cell ranges in 'host_spots' field.
  --|

  local info = R.cave_info

  A.host_spots = {}

  -- TODO
end



function Cave_create_areas(R)
  --|
  --| sub-divide the floor of the cave into areas of differing heights.
  --|

  local info = R.cave_info
  local cave = info.cave

  local is_lake = (info.liquid_mode == "lake")

  -- groups are areas (rectangles) belonging to portals or importants
  -- and must be kept distinct (at the same height).
  local group_list
  local group_map


  local function install_area(A, a_cave, mul, empty_ok)
    for cx = 1, info.W do
    for cy = 1, info.H do
      if ((a_cave:get(cx, cy) or 0) * mul) > 0 then
        info.blocks[cx][cy] = A

        A.cx1 = math.min(A.cx1 or 9999, cx)
        A.cy1 = math.min(A.cy1 or 9999, cy)

        A.cx2 = math.max(A.cx2 or -9999, cx)
        A.cy2 = math.max(A.cy2 or -9999, cy)
      end
    end
    end

    if not A.cx1 and not empty_ok then
      error("Cave install_area: no cells!")
    end
  end


  local function copy_cave_without_fences()
    local new_cave = info.cave:copy()

    if info.fence then
      for cx = 1, info.W do
      for cy = 1, info.H do
        local A = info.blocks[cx][cy]

        if A and A.fence then
          new_cave:set(cx, cy, nil)
        end
      end
      end
    end

    return new_cave
  end


  local function alternate_floor_mat()
    for loop = 1,3 do
      R.alt_floor_mat = rand.key_by_probs(LEVEL.cave_theme.naturals)

      if R.alt_floor_mat != R.floor_mat then
        break;
      end
    end
  end


  local function make_walkway()
    -- only have one area : the indentation / liquidy bits are
    -- considered to be a variation of it (child areas)

    local AREA =
    {
      touching = {}

      children = {}

      floor_mat = R.floor_mat
    }

    table.insert(info.floors, AREA)

    each imp in R.cave_imps do
      imp.area = AREA
    end

    install_area(AREA, cave, -1)


    if info.liquid_mode == "lake" then return end


    local WALK1 =
    {
      indent = 1

      floor_mat = R.alt_floor_mat
    }

    local walk_way = copy_cave_without_fences()

    -- remove importants from it
    each imp in R.cave_imps do
      walk_way:fill(imp.cx1, imp.cy1, imp.cx2, imp.cy2, 1)
    end

    walk_way:negate()
    walk_way:shrink8(true)
--    walk_way:shrink(true)
    walk_way:remove_dots()

    install_area(WALK1, walk_way, 1, "empty_ok")


    local WALK2 =
    {
      indent = 2
      liquid = true
    }

    if info.sky_mode == "some" then
      WALK2.sky = true
    end

    walk_way:shrink8(true)
--    walk_way:shrink(true)
    walk_way:remove_dots()

    install_area(WALK2, walk_way, 1, "empty_ok")


    table.insert(AREA.children, WALK1)
    table.insert(AREA.children, WALK2)
  end


  local function add_group_to_map(G)
    table.insert(group_list, G)

    for x = G.cx1, G.cx2 do
    for y = G.cy1, G.cy2 do
      group_map.cells[x][y] = G
    end
    end
  end


  local function remove_group_from_map(G)
    table.kill_elem(group_list, G)

    for x = G.cx1, G.cx2 do
    for y = G.cy1, G.cy2 do
      group_map.cells[x][y] = nil
    end
    end
  end


  local function create_group_map()
    group_list = {}

    group_map = AUTOMATA_CLASS.blank_copy(info.cave)

    each G in R.cave_imps do
      add_group_to_map(G)
    end
  end


  local function grow_step_areas()

    local pos_list = { }

    pos_list[1] =
    {
      x = R.point_list[1].x
      y = R.point_list[1].y
    }


    local free  = copy_cave_without_fences()
    local f_cel = free.cells

    local step
    local s_cel
    local size

    local cw = free.w
    local ch = free.h

    -- current bbox : big speed up by limiting the scan area
    local cx1, cy1
    local cx2, cy2

    local touched_groups
    

    -- mark free areas with zero instead of negative
    for fx = 1, cw do
    for fy = 1, ch do
      if (f_cel[fx][fy] or 0) < 0 then
        f_cel[fx][fy] = 0
      end
    end
    end


    local function touch_a_group(G)
      remove_group_from_map(G)

      table.insert(touched_groups, G)

      -- add the whole group to the current step
      for x = G.cx1, G.cx2 do
      for y = G.cy1, G.cy2 do
        s_cel[x][y] = 1
        f_cel[x][y] = 1

        size = size + 1
      end
      end

      -- update bbox
      cx1 = math.min(cx1, G.cx1)
      cy1 = math.min(cy1, G.cy1)

      cx2 = math.max(cx2, G.cx2)
      cy2 = math.max(cy2, G.cy2)
    end


    local function grow_add(x, y)
      s_cel[x][y] = 1
      f_cel[x][y] = 1

      size = size + 1

      -- update bbox
      if x < cx1 then cx1 = x end
      if x > cx2 then cx2 = x end

      if y < cy1 then cy1 = y end
      if y > cy2 then cy2 = y end

      if group_map.cells[x][y] then
        touch_a_group(group_map.cells[x][y])
      end
    end


    local function grow_horiz(y, prob)
      for x = cx1, cx2 do
        if x > 1 and s_cel[x][y] == 1 and s_cel[x-1][y] == 0 and f_cel[x-1][y] == 0 and rand.odds(prob) then
          grow_add(x-1, y)
        end
      end

      for x = cx2, cx1, -1 do
        if x < cw and s_cel[x][y] == 1 and s_cel[x+1][y] == 0 and f_cel[x+1][y] == 0 and rand.odds(prob) then
          grow_add(x+1, y)
        end
      end
    end


    local function grow_vert(x, prob)
      for y = cy1, cy2 do
        if y > 1 and s_cel[x][y] == 1 and s_cel[x][y-1] == 0 and f_cel[x][y-1] == 0 and rand.odds(prob) then
          grow_add(x, y-1)
        end
      end

      for y = cy2, cy1, -1 do
        if y < ch and s_cel[x][y] == 1 and s_cel[x][y+1] == 0 and f_cel[x][y+1] == 0 and rand.odds(prob) then
          grow_add(x, y+1)
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
    end


    local function grow_an_area(cx, cy, prev_A)

-- free:dump("Free:")

      step  = AUTOMATA_CLASS.blank_copy(free)
      s_cel = step.cells

      step:set_all(0)

      size = 0

      touched_groups = {}

      cx1 = cx ; cx2 = cx
      cy1 = cy ; cy2 = cy

      -- set initial point
      grow_add(cx, cy)

      local count = rand.pick { 3, 4, 5 }

      grow_it(100)

      for loop = 1, count do
        grow_it(50)
      end

      if size < 4 or #touched_groups > 0 then
        grow_it(100)
        grow_it(40)
      end

step:dump("Step:")

      -- when the step is too small, merge it into previous area
      if size < 4 and prev_A then

        install_area(prev_A, step, 1)

      else
        local AREA =
        {
          touching = {}
        }

        table.insert(info.floors, AREA)

        install_area(AREA, step, 1)

        prev_A = AREA
      end


      -- remember area of covered groups (e.g. for outgoing heights)
      each G in touched_groups do
        G.area = prev_A

        if G.portal then
          prev_A.goal_type = "portal"
        else
          prev_A.goal_type = "important"
        end
      end


      -- find new positions for growth

      for x = cx1, cx2 do
      for y = cy1, cy2 do
        if s_cel[x][y] != 1 then continue end

        for dir = 2,8,2 do
          local nx, ny = geom.nudge(x, y, dir)
          if free:valid_cell(nx, ny) and f_cel[nx][ny] == 0 then
            table.insert(pos_list, { x=nx, y=ny, prev=prev_A })
          end
        end
      end -- x, y
      end
    end


    --| grow_step_areas |--

    while #pos_list > 0 do
      local pos = table.remove(pos_list, rand.irange(1, #pos_list))

      -- ignore out-of-date positions
      if f_cel[pos.x][pos.y] != 0 then continue end

      grow_an_area(pos.x, pos.y, pos.prev)
    end
  end


  local function determine_touching_areas()
    local W = info.W
    local H = info.H

    for x = 1, W do
    for y = 1, H do
      local A1 = info.blocks[x][y]

      if not (A1 and A1.touching) then continue end

      for dir = 2,4,2 do
        local nx, ny = geom.nudge(x, y, dir)

        if not cave:valid_cell(nx, ny) then continue end

        local A2 = info.blocks[nx][ny]

        if not (A2 and A2.touching) then continue end

        if A2 != A1 then
          table.add_unique(A1.touching, A2)
          table.add_unique(A2.touching, A1)
        end
      end
    end  -- x, y
    end

    -- verify all areas touch at least one other
    if #info.floors > 1 then
      each A in info.floors do
        assert(not table.empty(A.touching))
      end
    end
  end


  local function set_walls()
    for x = 1, info.W do
    for y = 1, info.H do
      local val = cave:get(x, y)

      if (val or 0) > 0 then
        info.blocks[x][y] = info.wall
      end
    end
    end
  end


  ---| Cave_create_areas |---

  alternate_floor_mat()

  if info.step_mode == "walkway" then
    make_walkway()
  else
    create_group_map()

    grow_step_areas()

    if #group_list > 0 then
      error("Cave steps failed to cover all important chunks\n")
    end
  end

  determine_touching_areas()

  if not is_lake then
    set_walls()
  end
end



function Cave_bunch_areas(R, mode)
  --|
  --| this picks a bunch of step areas which will become either liquid
  --| or sky (depending on 'mode' parameter).
  --| 
  
  local info = R.cave_info


  local function setup()
    each A in info.floors do
      if A.goal_type then A.near_bunch = 0 end
    end
  end


  local function pick_start_area()
    local poss = {}

    each A in info.floors do
      if not A.near_bunch then
        table.insert(poss, A)
      end
    end

    if table.empty(poss) then return nil end

    return rand.pick(poss)
  end


  local function touches_the_list(N, list, except)
    each N2 in N.touching do
      if list[N2] and N2 != except then
        return true
      end
    end

    return false
  end


  local function grow_bunch(list)
    local poss = {}

    each A,_ in list do
      each N in A.touching do
        if list[N] then continue end
        if N.near_bunch then continue end

        if touches_the_list(N, list, A) then continue end

        table.insert(poss, N)
      end
    end

    if table.empty(poss) then return false end

    local A2 = rand.pick(poss)

    list[A2] = 1

    return true
  end


  local function install_bunch(list)
    local head_A

    each A,_ in list do
      if not head_A then head_A = A end

      if mode == "sky"    then A.sky_bunch    = head_A ; A.sky    = true end
      if mode == "liquid" then A.liquid_bunch = head_A ; A.liquid = true end

      A.near_bunch = 0

      each N in A.touching do
        if not N.near_bunch or N.near_bunch > 1 then
          N.near_bunch = 1
        end
      end
    end

    -- extra health to compensate player for crossing the river
    if mode == "liquid" and LEVEL.liquid.damage then
      R.hazard_health = R.hazard_health + 20
    end
  end


  local function clear()
    each A in info.floors do
      A.near_bunch = nil
    end
  end


  ---| Cave_bunch_areas |---

  if info.step_mode == "walkway" then return end
  if info.liquid_mode == "lake"  then return end

  if mode == "sky"    and info.sky_mode    != "some" then return end
  if mode == "liquid" and info.liquid_mode != "some" then return end

  setup()

  local try_count = int(#info.floors / rand.sel(50, 8, 14))

  for i = 1, try_count do
    local A1 = pick_start_area()

    if not A1 then break; end  -- nothing is possible

    local list = { [A1] = 1 }

    while grow_bunch(list) and rand.odds(64) do
      -- keep growing...
    end

    if table.size(list) >= 2 then
      install_bunch(list)
    end
  end

  clear()
end



function Cave_heights_near_area(R, A)
  local info = R.cave_info
  local cave = info.cave

  local min_floor_h =  9e9
  local max_floor_h = -9e9

  local min_ceil_h =  9e9
  local max_ceil_h = -9e9

  for x = 1, info.W do
  for y = 1, info.H do
    for dir = 2,4 do
      local nx, ny = geom.nudge(x, y, dir)

      if not cave:valid_cell(nx, ny) then continue end

      local A1 = info.blocks[x][y]
      local A2 = info.blocks[nx][ny]

      if (A2 == A) then
        A1, A2 = A2, A1
      end

      if not A2 or (A1 != A) or (A2 == A) then continue end

      if A2.floor_h then
        min_floor_h = math.min(min_floor_h, A2.floor_h)
        max_floor_h = math.max(max_floor_h, A2.floor_h)
      end

      if A2.ceil_h then
        min_ceil_h = math.min(min_ceil_h, A2.ceil_h)
        max_ceil_h = math.max(max_ceil_h, A2.ceil_h)
      end
    end
  end -- x, y
  end

  if min_floor_h > max_floor_h then
    min_floor_h = nil
    max_floor_h = nil
  end

  if min_ceil_h > max_ceil_h then
    min_ceil_h = nil
    max_ceil_h = nil
  end

  return min_floor_h, max_floor_h,
         min_ceil_h,  max_ceil_h
end



function Cave_floor_heights(R, entry_h)
  assert(entry_h)

  local info = R.cave_info


  local z_change_prob = rand.sel(15, 40, 10)

  if info.step_mode == "up" or info.step_mode == "down" then
    z_change_prob = 0
  end


  local function floor_for_river(bunch_A, h)
    assert(not bunch_A.floor_h)

    local diff_h = 16

    -- determine minimum of all areas touching the river
    each A in info.floors do
      if A.liquid_bunch != bunch_A then continue end

      each N in A.touching do
        if N.liquid_bunch then continue end

        if N.floor_h then
          h = math.min(h, N.floor_h - diff_h)
        end
      end
    end

    each A in info.floors do
      if A.liquid_bunch == bunch_A then
        A.floor_h = h
      end
    end

    return h
  end


  local function spread_river_banks(bunch_A, h)
    --| ensure all areas touching the river get a floor height now
    --| (to prevent those areas becoming lower than the river).

    each A in info.floors do
      if A.liquid_bunch != bunch_A then continue end

      each N in A.touching do
        if N.liquid_bunch then continue end

        if not N.floor_h then
          N.floor_h = h + rand.pick({8, 16, 24})
        end
      end
    end
  end


  local function visit_area(A, z_dir, h)
    --|
    --| recursively spread floors heights into each area
    --|

    assert(not A.visited)
    A.visited = true

    if rand.odds(z_change_prob) then
      z_dir = - z_dir
    end


    -- floor --

    if A.floor_h then
      h = A.floor_h
    elseif A.liquid_bunch then
      h = floor_for_river(A.liquid_bunch, h)
    else
      A.floor_h = h
    end


    if A.liquid_bunch then
      spread_river_banks(A.liquid_bunch, h)
    end


    -- ceiling --

    if R.is_outdoor then
      -- no ceil_h (done later using sky_rects)
    elseif A.goal_type then
      A.ceil_h = h + 192
    else
      A.ceil_h = h + rand.pick { 128, 192,192,192, 288 }
    end


    rand.shuffle(A.touching)

    each N in A.touching do
      if not N.visited then
        local new_h = h + z_dir * rand.sel(35, 8, 16)
        visit_area(N, z_dir, new_h)
      end
    end
  end


  local function find_entry_area()
    each imp in R.cave_imps do
      assert(imp.area)
      if imp.conn and imp.conn.conn_h then
        return imp.area
      end
    end

    return rand.pick(info.floors)
  end


  local function transfer_heights()
    -- transfer heights to importants and portals
    each imp in R.cave_imps do
      assert(imp.area)
      assert(imp.area.floor_h)

      local G = imp.goal
      local C = imp.conn

      if G then
        G.z1 = imp.area.floor_h
        G.z2 = G.z1 + 160

        G.S.floor_h = G.z1
      end

      if C then
        local S = C:get_seed(R)
        S.floor_h = imp.area.floor_h

        if not C.conn_h then
          C.conn_h  = imp.area.floor_h
        end
      end
    end 
  end


  local function update_min_max_floor()
    R.floor_min_h = entry_h
    R.floor_max_h = entry_h

    each A in info.floors do
      R.floor_min_h = math.min(R.floor_min_h, A.floor_h)
      R.floor_max_h = math.max(R.floor_max_h, A.floor_h)
    end
  end


  local function update_walk_ways()
    each A in info.floors do
      if not A.children then continue end

      each WALK in A.children do
        WALK.floor_h = A.floor_h - WALK.indent * 12

        if A.ceil_h then
          WALK.ceil_h = A.ceil_h + WALK.indent * 64
        end
      end
    end
  end


  local function update_fences()
    if info.liquid_mode == "lake" then
      info.fence.floor_h = R.floor_max_h + 96
      info. wall.floor_h = info.fence.floor_h

      R.cave_fence_z = info.fence.floor_h
    
    elseif info.sky_mode == "low_wall" then
      info.wall.floor_h = R.floor_max_h + 80

      R.cave_fence_z = info.wall.floor_h
    
    else
      -- do not need a cave_fence_z
    end
  end


  local function update_lakes()
    for pass = 1,4 do
      each A in info.lakes do
        if not A.floor_h then
        
          local f_h = Cave_heights_near_area(R, A)

          if f_h then
            A.floor_h = f_h - rand.pick({ 8, 16, 24 })
          elseif pass == 4 then
            error("Lake failed to get a height")
          end

        end
      end
    end
  end


  local function ceiling_for_sky_bunch(bunch_A)
    local h = bunch_A.ceil_h or 0

    each A in info.floors do
      if A.sky_bunch != bunch_A then continue end

      each N in A.touching do
        if N.sky_bunch then continue end

        if N.ceil_h then
          h = math.max(h, N.ceil_h)
        end
      end
    end

    h = h + rand.pick({ 32,48,64,96 })

    each A in info.floors do
      if A.sky_bunch == bunch_A then
        A.ceil_h = h
      end
    end
  end


  local function update_sky_bunches()
    each A in info.floors do
      if A.sky_bunch == A then
        ceiling_for_sky_bunch(A)
      end
    end
  end


  ---| Cave_floor_heights |---

  local z_dir

  if info.step_mode == "up" then
    z_dir = 1
  elseif info.step_mode == "down" then
    z_dir = -1
  else
    z_dir = rand.sel(37, 1, -1)
  end

  local entry_area = find_entry_area()

  visit_area(entry_area, z_dir, entry_h)

  transfer_heights()

  update_min_max_floor()
  update_walk_ways()
  update_fences()
  update_lakes()
  update_sky_bunches()
end



function Cave_render_cave(R)

  local info = R.cave_info


  local cave = info.cave

  local is_lake = (info.liquid_mode == "lake")

  -- the delta map specifies how to move each corner of the 64x64 cells
  -- (where the cells form a continuous mesh).
  local delta_x_map
  local delta_y_map

  local dw = info.W + 1
  local dh = info.H + 1


  local function grab_cell(x, y)
    if not cave:valid_cell(x, y) then
      return nil
    end

    local A = info.blocks[x][y]

    -- in some places we build nothing (e.g. other rooms)
    if A == nil then return nil end

    -- check for a solid cell
    if A.wall then return EXTREME_H end

    -- otherwise there should be a floor area here

    assert(A)

    local f_h = assert(A.floor_h)

    -- take ceiling into account too
    local c_h = A.ceil_h

    if c_h then
      f_h = f_h + bit.band(c_h, 511) / 1024
    end

    return f_h
  end


  local function analyse_corner(x, y)
    --  A | B
    --  --+--
    --  C | D

    local A = grab_cell(x-1, y)
    local B = grab_cell(x,   y)
    local C = grab_cell(x-1, y-1)
    local D = grab_cell(x,   y-1)

    -- never move a corner at edge of room
    if not A or not B or not C or not D then
      return
    end

    -- pick highest floor (since that can block a lower floor)
    -- [solid cells will always override floor cells]

    local max_h = math.max(A, B, C, D) - 0.01

    A = (A > max_h)
    B = (B > max_h)
    C = (C > max_h)
    D = (D > max_h)

    -- no need to move when all cells are the same

    if A == B and A == C and A == D then
      return
    end

    local x_mul =  1
    local y_mul = -1

    -- flip horizontally and/or vertically to ease analysis
    if not A and B then
      A, B = B, A
      C, D = D, C
      x_mul = -1

    elseif not A and C then
      A, C = C, A
      B, D = D, B
      y_mul = 1

    elseif not A and D then
      A, D = D, A
      B, C = C, B
      x_mul = -1
      y_mul =  1
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
      -- an empty corner
      -- expand a bit, but not enough to block player movement
          if not B then y_mul = -y_mul
      elseif not C then x_mul = -x_mul
      end

      if rand.odds(80) then delta_x_map[x][y] = 12 * x_mul end
      if rand.odds(80) then delta_y_map[x][y] = 12 * y_mul end
    end
  end


  local function create_delta_map()
    delta_x_map = table.array_2D(dw, dh)
    delta_y_map = table.array_2D(dw, dh)

    info.delta_x_map = delta_x_map
    info.delta_y_map = delta_y_map

    if square_cave then return end

    for x = 1, dw do
    for y = 1, dh do
      analyse_corner(x, y)
    end
    end
  end


  local function cell_middle(x, y)
    local mx = info.x1 + (x - 1) * 64 + 32
    local my = info.y1 + (y - 1) * 64 + 32
  
    return mx, my
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


  local function render_floor_subdiv(x, y, A, f_mat, f_liquid)
    local coords = Cave_brush(info, x, y)

    local mid_x = info.x1 + (x - 0.5) * 64
    local mid_y = info.y1 + (y - 0.5) * 64

    local edge_points = {}

    for pass = 1, 4 do
      local n = (pass % 4) + 1

      local x1 = coords[pass].x
      local y1 = coords[pass].y
      local x2 = coords[n].x
      local y2 = coords[n].y

      local mx = (x1 + x2) / 2
      local my = (y1 + y2) / 2

      table.insert(edge_points, { x=mx, y=my })
    end

    for pass = 1, 4 do
      local n = (pass % 4) + 1

      local f_brush =
      {
        { t=A.floor_h, cavelit = 1 }
        { x=mid_x, y=mid_y }
        table.copy(edge_points[pass])
        table.copy(coords[n])
        table.copy(edge_points[n])
      }

      if f_liquid then
        brushlib.mark_liquid(f_brush)
      else
        brushlib.set_mat(f_brush, f_mat, f_mat)
      end

      Trans.brush(f_brush)
    end
  end


  local function render_floor(x, y, A)
    local f_h = A.floor_h

    local f_mat = A.floor_mat or R.floor_mat or R.main_tex

    if A.wall or A.fence then
      f_mat = A.wall_mat or R.main_tex or R.main_tex
    end

    local f_liquid = A.liquid


    -- for outdoor non-dark rooms, sub-divide the floor cell into
    -- smaller pieces to allow the Sun lighting to work better.
    if not A.wall and R.is_outdoor and not LEVEL.is_dark then
      return render_floor_subdiv(x, y, A, f_mat, f_liquid)
    end


    local f_brush = Cave_brush(info, x, y)

    if f_h then
      local top = { t=f_h }

      if info.cave_lighting then
        top.cavelit = 1
      end

      table.insert(f_brush, top)
    end

    if f_liquid then
      brushlib.mark_liquid(f_brush)
    else
      brushlib.set_mat(f_brush, f_mat, f_mat)
    end

    Trans.brush(f_brush)
  end


  local function render_ceiling(x, y, A)
    if not A.ceil_h then return end

    local c_mat = A.ceil_mat or R.ceil_mat or R.main_tex

    local c_brush = Cave_brush(info, x, y)

    brushlib.add_bottom(c_brush, A.ceil_h)

    if A.sky then
      brushlib.mark_sky(c_brush)
    else
      brushlib.set_mat(c_brush, c_mat, c_mat)
    end

    Trans.brush(c_brush)
  end


  local function render_cell(x, y)
    local A = info.blocks[x][y]

    if A then
      render_floor  (x, y, A)
      render_ceiling(x, y, A)
    end
  end


--[[ OLD
  local function heights_near_island(island)
    local min_floor =  9e9
    local max_ceil  = -9e9
  
    for x = 1, info.W do
    for y = 1, info.H do
      if ((island:get(x, y) or 0) > 0) then
        for dir = 2,8,2 do
          local nx, ny = geom.nudge(x, y, dir)

          if not island:valid_cell(nx, ny) then continue end

          local A = R.area_map:get(nx, ny)
          if not A then continue end

          min_floor = math.min(min_floor, A.floor_h)
          max_ceil  = math.max(max_ceil , A.ceil_h)
        end
      end
    end  -- x, y
    end

--!!! FIXME  assert(min_floor < max_ceil)

    return min_floor, max_ceil
  end


  local function render_liquid_area(island)
    -- create a lava/nukage pit

    local f_mat = R.floor_mat or cave_tex
    local c_mat = R.ceil_mat  or cave_tex
    local l_mat = LEVEL.liquid.mat

    local f_h, c_h = heights_near_island(island)

    -- FIXME!! should not happen
    if f_h >= c_h then return end

    f_h = f_h - 24
    c_h = c_h + 64

    -- TODO: fireballs for Quake

    for x = 1, cave.w do
    for y = 1, cave.h do

      if ((island:get(x, y) or 0) > 0) then

        -- do not render a wall here
        cave:set(x, y, 0)

        local f_brush = Cave_brush(info, x, y)
        local c_brush = Cave_brush(info, x, y)

        if PARAM.deep_liquids then
          brushlib.add_top(f_brush, f_h-128)
          brushlib.set_mat(f_brush, f_mat, f_mat)

          Trans.brush(f_brush)

          local l_brush = Cave_brush(info, x, y)

          table.insert(l_brush, 1, { m="liquid", medium=LEVEL.liquid.medium })

          brushlib.add_top(l_brush, f_h)
          brushlib.set_mat(l_brush, "_LIQUID", "_LIQUID")

          Trans.brush(l_brush)

          -- TODO: lighting

        else
          brushlib.add_top(f_brush, f_h)

          -- damaging
          f_brush[#f_brush].special = LEVEL.liquid.special

          -- lighting
          if LEVEL.liquid.light then
            f_brush[#f_brush].light = LEVEL.liquid.light
          end

          brushlib.set_mat(f_brush, l_mat, l_mat)

          Trans.brush(f_brush)
        end

        -- common ceiling code

        brushlib.add_bottom(c_brush, c_h)
        brushlib.set_mat(c_brush, c_mat, c_mat)

        if c_mat == "_SKY" then
          table.insert(c_brush, 1, { m="sky" })
        end

        Trans.brush(c_brush)
      end

    end end -- x, y
  end
--]]


  local function add_liquid_pools()
    if not LEVEL.liquid then return end

    local prob = 70  -- FIXME

    each island in cave.islands do
      if rand.odds(prob) then
        render_liquid_area(island)
      end
    end
  end


  local function add_sky_rects()
    for sx = R.sx1, R.sx2 do
    for sy = R.sy1, R.sy2 do
      local S = SEEDS[sx][sy]

      if S.room == R then
        local rect =
        {
          x1 = S.x1, y1 = S.y1
          x2 = S.x2, y2 = S.y2
        }

        table.insert(R.sky_rects, rect)
      end
    end -- sx, sy
    end
  end


  ---| Cave_render_cave |---
  
  Trans.clear()

  create_delta_map()

---???  add_liquid_pools()

  for x = 1, info.W do
  for y = 1, info.H do
    render_cell(x, y)
  end
  end

  if R.is_outdoor then
    add_sky_rects()
  end
end



function Cave_fill_lakes(R)
  local info = R.cave_info
  local cave = info.cave


  local function add_lake(id, reg)

    -- FIXME: if reg.size < 16 then emptify_region()

    local LAKE =
    {
      liquid = true

      region = reg

      cx1 = reg.x1
      cy1 = reg.y1
      cx2 = reg.x2
      cy2 = reg.y2
    }

    table.insert(info.lakes, LAKE)

    for x = LAKE.cx1, LAKE.cx2 do
    for y = LAKE.cy1, LAKE.cy2 do
      if cave.flood[x][y] == id then
        info.blocks[x][y] = LAKE
      end
    end
    end
  end


  local function handle_island(id, reg)

    -- TODO: if large, keep as island and add bridge to nearby ground

    add_lake(id, reg)
  end


  ---| Cave_fill_lakes |---

  info.lakes = {}

  if info.liquid_mode != "lake" then return end

  -- determine region id for the main walkway
  local p1 = R.point_list[1]

  local path_id = cave.flood[p1.x][p1.y]

  each id,reg in cave.regions do
    if (id > 0) then
      add_lake(id, reg)
    end

    if (id < 0) and (id != path_id) then
      handle_island(id, reg)
    end
  end
end



function Cave_lake_fences(R)
  local info = R.cave_info

  local function install_fence_post(cx1, cy1, cx2, cy2, dir, along_dir, i, deep)
    if along_dir == 6 then
      cx1 = cx1 + (i - 1)
      cx2 = cx1
    else
      cy1 = cy1 + (i - 1)
      cy2 = cy1
    end

        if dir == 2 then cy2 = cy1 + (deep - 1)
    elseif dir == 8 then cy1 = cy2 - (deep - 1)
    elseif dir == 4 then cx2 = cx1 + (deep - 1)
    elseif dir == 6 then cx1 = cx2 - (deep - 1)
    end

    for x = cx1, cx2 do
    for y = cy1, cy2 do
      info.blocks[x][y] = info.fence
    end
    end
  end


  local function try_fence_run(S, dir)
    if not S.lake_fences then S.lake_fences = {} end

    -- already done?
    if S.lake_fences[dir] then return end

    local along_dir = geom.vert_sel(dir, 6, 8)

    local count = 1

    local S1 = S
    local S2 = S:neighbor(along_dir)

    while S2 do
      if S2.room != R then break; end

      assert(not (S2.lake_fences and S2.lake_fences[dir]))

      if not S2:need_lake_fence(dir) then break; end

      if not S2.lake_fences then S2.lake_fences = {} end

      count = count + 1

      S2 = S2:neighbor(along_dir)
    end

    --- OK, install it ---

    for i = 1, count do
      local N = S:neighbor(along_dir, i - 1)

      N.lake_fences[dir] = true  -- prevent visiting again
    end

    local S2 = S:neighbor(along_dir, count - 1)

    local cx1 = 1 + (S.sx - R.sx1) * 3
    local cy1 = 1 + (S.sy - R.sy1) * 3

    local cx2 = 1 + (S2.sx - R.sx1) * 3 + 2
    local cy2 = 1 + (S2.sy - R.sy1) * 3 + 2

    assert(cx2 > cx1 and cy2 > cy1)

    -- starting depth
    local deep = rand.sel(50, 1, 2)

    for i = 1, count * 3 do
      install_fence_post(cx1, cy1, cx2, cy2, dir, along_dir, i, deep)

      -- pick next depth
      deep = rand.sel(50, 1, 2)
    end
  end


  local function do_innie_corners()
    -- logic in mark_boundaries() assures that the whole seed at an
    -- "innie corner" is cleared (and walkable).  Here we ensure there
    -- is a single fence block touching that corner, to make the lake
    -- fence flow nicely around the innie corner.

    for x = R.sx1, R.sx2 do
    for y = R.sy1, R.sy2 do
      local S = SEEDS[x][y]
      if S.room != R then continue end

      cx1 = (x - R.sx1) * 3 + 1
      cy1 = (y - R.sy1) * 3 + 1

      for dir = 1,9,2 do if dir != 5 then
        if S:same_room(dir) then continue end

        local A_dir = geom. LEFT_45[dir]
        local B_dir = geom.RIGHT_45[dir]

        local A = S:neighbor(A_dir)
        local B = S:neighbor(B_dir)

        if not A or (A.room != S.room) then continue end
        if not B or (B.room != S.room) then continue end

        if A:need_lake_fence(B_dir) or
           B:need_lake_fence(A_dir)
        then
          local cx, cy = geom.pick_corner(dir, cx1, cy1, cx1+2, cy1+2)
          info.blocks[cx][cy] = info.fence
        end

      end end -- dir

    end -- x, y
    end
  end


  --| Cave_lake_fences |--

  if info.liquid_mode != "lake" then
    return
  end

  local FENCE =  
  {
    fence = true

    -- floor_h
  }

  info.fence = FENCE

  for x = R.sx1, R.sx2 do
  for y = R.sy1, R.sy2 do
    local S = SEEDS[x][y]

    if S.room != R then continue end

    for dir = 2,8,2 do
      if S:need_lake_fence(dir) then
        try_fence_run(S, dir)
      end
    end

  end -- sx, sy
  end

  do_innie_corners()
end



function Cave_make_waterfalls(R)
  --| this checks if two lakes can be connected by a short run of
  --| intermediate cells.

  local info = R.cave_info
  local cave = info.cave


  local function can_still_traverse(cx, cy, dir)
    -- see if cells on each side has same floor

    local A_dir = geom.LEFT [dir]
    local B_dir = geom.RIGHT[dir]

    local ax, ay = geom.nudge(cx, cy, A_dir)
    local bx, by = geom.nudge(cx, cy, B_dir)

    if not cave:valid_cell(ax, ay) then return false end
    if not cave:valid_cell(bx, by) then return false end

    local A = info.blocks[ax][ay]
    local B = info.blocks[bx][by]

    if not A or not B then return false end

    if A.wall or not A.floor_h then return false end
    if B.wall or not B.floor_h then return false end

    return math.abs(A.floor_h - B.floor_h) < 4
  end


  local function try_from_loc(lake, x, y, dir)
    if info.blocks[x][y] != lake then
      return false
    end

    local nx, ny = geom.nudge(x, y, dir)

    if not cave:valid_cell(nx, ny) then return false end

    local B = info.blocks[nx][ny]

    if not B or B == lake then return false end
    if B.liquid or B.fence or B.wall then return false end

    local length = 1
    local max_length = 4

    for dist = 2, 9 do
      if length > max_length then return false end

      local ox, oy = geom.nudge(x, y, dir, dist)

      if not cave:valid_cell(ox, oy) then return false end

      local B2 = info.blocks[ox][oy]
      
      if not B2 or B2 == lake then return false end

      -- found another lake?
      if B2.liquid then
        if lake.floor_h - B2.floor_h < 50 then return false end
        break;
      end

      if B.fence or B.wall then return false end

      length = length + 1
    end

    -- check player can traverse (somewhere along the new channel)

    local trav_count = 0

    for dist = 1, length do
      local ox, oy = geom.nudge(x, y, dir, dist)

      if can_still_traverse(ox, oy, dir) then 
        trav_count = trav_count + 1
      end
    end

    if trav_count == 0 then return false end

    -- OK --

    for dist = 1, length do
      local ox, oy = geom.nudge(x, y, dir, dist)

      info.blocks[ox][oy] = lake
    end

    return true
  end


  local function try_waterfall(lake, dir)
    local cx1, cy1 = lake.cx1, lake.cy1
    local cx2, cy2 = lake.cx2, lake.cy2

    if dir == 2 then cy2 = math.min(lake.cy2, cy1 + 2) end
    if dir == 8 then cy1 = math.max(lake.cy1, cy2 - 2) end
    if dir == 4 then cx2 = math.min(lake.cx2, cx1 + 2) end
    if dir == 6 then cx1 = math.max(lake.cx1, cx2 - 2) end

    for x = cx1, cx2 do
    for y = cy1, cy2 do
      if try_from_loc(lake, x, y, dir, dist) then
        return true
      end
    end -- x, y
    end

    return false
  end


  local function connect_pools()
    each lake in info.lakes do
      local w, h = geom.group_size(lake.cx1, lake.cy1, lake.cx2, lake.cy2)

      -- too large?
      -- we skip the main lake (only test cases beginning at a pool)
      if w > 15 or h > 15 then continue end

      local DIRS = { 2,4,6,8 }
      rand.shuffle(DIRS)

      each dir in DIRS do
        if try_waterfall(lake, dir) then
          break;
        end
      end
    end
  end


  local function cells_are_fences(cx1, cy1, cx2, cy2)
    for x = cx1, cx2 do
    for y = cy1, cy2 do
      assert(cave:valid_cell(x, y))
      local B = info.blocks[x][y]
      if not (B and B.fence) then return false end
    end
    end

    return true
  end


  local function check_side_floors(cx, cy, dir, walk_A)
    dir = geom.RIGHT[dir]

    for pass = 1, 2 do
      local nx, ny = geom.nudge(cx, cy, dir)

      if not cave:valid_cell(nx, ny) then return false end

      local N = info.blocks[nx][ny]
      if not N then return false end

      -- allow fences
      if N.fence then continue end

      -- this check prevents odd-looking falls (want only a single side of
      -- the LOW_POOL to be visible)
      if N.liquid then return false end

      if N.wall or not N.floor_h then return false end

      if N != walk_A then return false end

      dir = 10 - dir
    end

    return true
  end


  local function attempt_a_fence_fall(cx, cy, dir)
    -- create a string describing what we can see
    local str = ""

    local low_floor
    local liq_area

    for i = 0, 7 do
      local nx, ny = geom.nudge(cx, cy, dir, i)
      if not cave:valid_cell(nx, ny) then return false end
      
      local BL = info.blocks[nx][ny]
      if not BL or BL.wall or BL.goal_type then return false end

      -- do not join onto a previously built waterfall
      if BL.waterfall then return false end
      
      if BL.fence then
        str = str .. "F"
      elseif BL.liquid then
        str = str .. "L"
        liq_area = BL
      elseif BL.floor_h then
        str = str .. "W"

        if not low_floor then
          low_floor = BL
        else
          if BL != low_floor then return end
        end

        if not check_side_floors(nx, ny, dir, BL) then
          return false
        end

      else
        return false
      end
    end


    -- check if possible
    if not string.match(str, "F+W+L") then
      return false
    end

    assert(low_floor)
    assert(liq_area)

    if low_floor.floor_h - liq_area.floor_h < 50 then
      return false  -- the "falls" would be too low
    end

    -- random chance of not making it
    if rand.odds(50) then
      return false
    end


    -- OK, do it --

    local F1 = info.blocks[cx][cy]
    assert(F1.floor_h)

    local HIGH_POOL =
    {
      liquid  = true
      floor_h = F1.floor_h - 16
      waterfall = true
    }

    local LOW_POOL =
    {
      liquid  = true
      floor_h = low_floor.floor_h - 12
      waterfall = true
    }

    info.blocks[cx][cy] = HIGH_POOL

    for i = 1, 7 do
      local ch = string.sub(str, i+1, i+1)
      local nx, ny = geom.nudge(cx, cy, dir, i)

      if ch == 'L' then break; end

      if ch == 'F' and i == 1 and string.sub(str, 3, 3) == 'F' then
        info.blocks[nx][ny] = HIGH_POOL
        continue
      end

      info.blocks[nx][ny] = LOW_POOL
    end

    return true
  end


  local function try_fence_fall(S, dir)
    -- Note: 'dir' faces inwards (away from fence)

    local along_dir = geom.vert_sel(dir, 6, 8)

    -- must be at edge of room
    local N = S:neighbor(10 - dir)
    if N and N.room == R then return end

    -- we only try pairs of seeds along the edge
    if geom.is_vert(dir) then
      if (S.sx % 2) == 0 then return end
    else
      if (S.sy % 2) == 0 then return end
    end

    -- check second seed in pair
    local S2 = S:neighbor(along_dir)
    if not (S2 and S2.room == R) then return end

    local N2 = S2:neighbor(10 - dir)
    if N2 and N2.room == R then return end


    local cx1 = 1 + (S.sx - R.sx1) * 3
    local cy1 = 1 + (S.sy - R.sy1) * 3

    if dir == 4 then cx1 = cx1 + 2 end
    if dir == 2 then cy1 = cy1 + 2 end

    local cx2, cy2 = cx1, cy1

    -- we test middle four cells in the seed pair
    if geom.is_vert(dir) then
      cx1 = cx1 + 1
      cx2 = cx1 + 3
    else
      cy1 = cy1 + 1
      cy2 = cy1 + 3
    end

    -- all these cells should be fences : verify
    if not cells_are_fences(cx1, cy1, cx2, cy2) then
      return
    end

    local deltas = { 0,1,2,3 }
    rand.shuffle(deltas)

    for i = 1, 4 do
      local cx, cy = geom.nudge(cx1, cy1, along_dir, i - 1)

      if attempt_a_fence_fall(cx, cy, dir) then
        -- yay!
        return
      end
    end
  end


  local function fence_falls()
    for x = R.sx1, R.sx2 do
    for y = R.sy1, R.sy2 do
      local S = SEEDS[x][y]

      if S.room != R then continue end

      for dir = 2,8,2 do
        try_fence_fall(S, dir)
      end

    end -- sx, sy
    end
  end


  ---| Cave_make_waterfalls |---

  if info.liquid_mode != "lake" then return end

  connect_pools()

  fence_falls()
end


function Cave_decorations(R)
  --|
  --| add torches (etc)
  --|

  local info = R.cave_info
  local cave = info.cave


  local function block_is_bounded(x, y, A, dir)
    local nx, ny = geom.nudge(x, y, dir)

    if not cave:valid_cell(nx, ny) then return true end

    local N = info.blocks[nx][ny]

    if not (N and N.floor_h) then return true end
    if N.wall or N.fence or N.liquid then return true end

    if math.abs(N.floor_h - A.floor_h) > 16 then return true end

    return false
  end


  local function usable_corner(x, y)
    local A = info.blocks[x][y]

    if not (A and A.floor_h) then return false end

    -- analyse neighborhood of cell
    local nb_str = ""

    for dir = 1,9 do
      if block_is_bounded(x, y, A, dir) then
        nb_str = nb_str .. "1"
      else
        nb_str = nb_str .. "0"
      end
    end

    -- match neighborhood string
    -- Note: each '.' in the pattern means "Dont Care"

    return string.match(nb_str, "^11.100.00$") or
           string.match(nb_str, "^.1100100.$") or
           string.match(nb_str, "^.0010011.$") or
           string.match(nb_str, "^00.001.11$")
  end


  local function find_corner_locs()
    local locs = {}

    for x = 2, info.W - 1 do
    for y = 2, info.H - 1 do
      if usable_corner(x, y) then
        table.insert(locs, { cx=x, cy=y })    
      end
    end
    end

    return locs
  end


  local function select_torch()
    local tab = R.theme.torches or THEME.cave_torches

    if not tab then return end

    return rand.key_by_probs(tab)
  end


  local function kill_nearby_locs(list, x, y)
    each loc in list do
      if math.abs(loc.cx - x) <= 2 and
         math.abs(loc.cy - y) <= 2
      then
        loc.dead = true
      end
    end
  end


  local function add_torch(x, y, torch_ent)
    local A = info.blocks[x][y]
    assert(A and A.floor_h)

    local mx = info.x1 + (x-1) * 64 + 32
    local my = info.y1 + (y-1) * 64 + 32

    Trans.entity(torch_ent, mx, my, A.floor_h, { cave_light=192, factor=1.2 })
    R:add_decor (torch_ent, mx, my, A.floor_h)
  end


  local function place_torches_in_corners(prob)
    local torch_ent = select_torch()

    if not torch_ent then return end

    local locs = find_corner_locs()

    rand.shuffle(locs)

    local perc  = sel(info.torch_mode == "few", 5, 12)
    local quota = #locs * perc / 100

    quota = quota * rand.range(0.8, 1.2)
    quota = int(quota + gui.random())

    -- very rarely add lots of torches
    if info.torch_mode != "few" and rand.odds(1) then
      quota = #locs / 2
    end

    while quota > 0 do
      if table.empty(locs) then break; end

      local loc = table.remove(locs, 1)
      if loc.dead then continue end

      add_torch(loc.cx, loc.cy, torch_ent)

      -- prevent adding a torch in a neighbor cell, since that can
      -- block the player's path.
      kill_nearby_locs(locs, loc.cx, loc.cy)

      quota = quota - 1
    end
  end


  ---| Cave_decorations |---

  if info.torch_mode != "none" then
    place_torches_in_corners()
  end
end



function Cave_decide_properties(R)
  local info = R.cave_info

  local   STEP_MODES = { walkway=25, up=20, down=20, mixed=75 }
  local LIQUID_MODES = { none=50, some=80, lake=80 }

  -- decide liquid mode
  if not LEVEL.liquid then
    info.liquid_mode = "none"
    STEP_MODES.walkway = nil
  else
    if not R.is_outdoor then
      LIQUID_MODES.lake = nil
    end

    info.liquid_mode = rand.key_by_probs(LIQUID_MODES)
  end

  -- decide step mode
  if info.liquid_mode == "lake" then
    STEP_MODES.walkway = nil
  end

  info.step_mode = rand.key_by_probs(STEP_MODES)

  -- decide sky mode
  if R.is_outdoor then
    info.sky_mode = rand.sel(50, "high_wall", "low_wall")
  else
    info.sky_mode = rand.sel(25, "some", "none")
  end

  if info.liquid_mode == "lake" then
    info.sky_mode = "low_wall"
  end

  if info.sky_mode == "high_wall" then
    R.high_wall = true
  end

  -- decide torch mode
  if R.is_outdoor and not LEVEL.is_dark then
    info.torch_mode = "none"
  elseif info.sky_mode != "none" and not LEVEL.is_dark then
    info.torch_mode = "few"
  elseif info.liquid_mode != "none" then
    info.torch_mode = rand.key_by_probs({ none=10, few=40, some=40 })
  else
    -- no other light sources!
    info.torch_mode = rand.key_by_probs({ none=2, few=10, some=90 })
  end

  if LEVEL.is_dark or not R.is_outdoor then
    info.cave_lighting = 1
  end

  -- extra health for damaging liquid
  if LEVEL.liquid and LEVEL.liquid.damage then
    if info.liquid_mode != "none" then
      R.hazard_health = R.hazard_health + R.svolume * 0.7
    end
  end

  gui.debugf("Cave properties in %s\n", R:tostr())
  gui.debugf("    step_mode : %s\n", info.step_mode)
  gui.debugf("  liquid_mode : %s\n", info.liquid_mode)
  gui.debugf("     sky_mode : %s\n", info.sky_mode)
  gui.debugf("   torch_mode : %s\n", info.torch_mode)
end



function Cave_build_room(R, entry_h)
  R.cave_info = {}

  Cave_decide_properties(R)
  Cave_generate_cave(R)

  Cave_lake_fences(R)
  Cave_fill_lakes(R)

  Cave_create_areas(R)

  Cave_bunch_areas(R, "liquid")
  Cave_bunch_areas(R, "sky")

  Cave_floor_heights(R, entry_h)
  Cave_make_waterfalls(R)
  Cave_decorations(R)

  Cave_render_cave(R)
end



function Cave_determine_spots(R)
  local info = R.cave_info
  local cave = info.cave


  local function do_spot_cell(A, x, y)
    if x < 1 or x > info.W then return end
    if y < 1 or y > info.H then return end

    local A2 = info.blocks[x][y]

    -- need to remove cells which are not part of the cave
    if not A2 then
      local x1 = info.x1 + (x - 1) * 64
      local y1 = info.y1 + (y - 1) * 64 

      gui.spots_fill_box(x1, y1, x1+64, y1+64, SPOT_WALL)
      return
    end

    if A2 == A then return end

    -- higher floors are handled by gui.spots_apply_brushes()
    if A.wall or A.fence then return end
    if A2.floor_h and A2.floor_h > A.floor_h + 1 then return end

    -- skip area if not near the floor
    if A2.cx1 then
      if A2.cx2 < A.cx1 then return end
      if A2.cy2 < A.cy1 then return end

      if A2.cx1 > A.cx2 then return end
      if A2.cy1 > A.cy2 then return end
    end

    local poly = Cave_brush(info, x, y)

    gui.spots_fill_poly(poly, SPOT_LEDGE)
  end


  local function do_spot_at_border(A, x, y)  -- NOT NEEDED ??
    -- only needed for lake mode
    if not is_lake then return end

    for dir = 1,9 do if dir != 5 then
      local nx, ny = geom.nudge(x, y, dir)

      local A
      if cave:valid_cell(nx, ny) then
        A = info.blocks[nx][ny]
      end

      if not A or A.fence then
        local poly = Cave_brush(info, x, y)
        gui.spots_fill_poly(poly, SPOT_WALL)
        return
      end

    end end -- dir
  end


  local function do_spot_wall(A, x, y)  -- NOT NEEDED ??
    local A2 = info.blocks[x][y]

    if A2 == A then
      return do_spot_at_border(A, x, y)
    end

    -- if this cell touches the current area, mark it as solid
    local touches = false

    for dir = 1,9 do if dir != 5 then
      local nx, ny = geom.nudge(x, y, dir)

      if not cave:valid_cell(nx, ny) then continue end

      if info.blocks[nx][ny] == A then
        touches = true
        break;
      end
    end end -- dir

    if touches then 
      local poly = Cave_brush(info, x, y)

      if not A2 or A2.wall then
        gui.spots_fill_poly(poly, SPOT_WALL)
      else
        gui.spots_fill_poly(poly, SPOT_LEDGE)
      end
    end
  end


  local function do_spot_conn(S)
    if not S.conn then return end
    if not S.conn_dir then return end

    local x1, y1 = S.x1, S.y1
    local x2, y2 = S.x2, S.y2

    if S.conn_dir == 2 then y2 = y1 + 64 end
    if S.conn_dir == 8 then y1 = y2 - 64 end
    if S.conn_dir == 4 then x2 = x1 + 64 end
    if S.conn_dir == 6 then x1 = x2 - 64 end

    gui.spots_fill_box(x1, y1, x2, y2, SPOT_WALL)
  end


  local function do_spot_important(imp)
    if not imp.goal then return end

    local G = imp.goal
    local S = assert(G.S)

    gui.spots_fill_box(S.x1, S.y1, S.x2, S.y2, SPOT_LEDGE)
  end


  local function determine_spots(A)
    assert(A.cx1 and A.cy2)

    -- determine bbox
    local x1 = info.x1 + (A.cx1 - 1) * 64
    local y1 = info.y1 + (A.cy1 - 1) * 64 

    local x2 = info.x1 + (A.cx2) * 64
    local y2 = info.y1 + (A.cy2) * 64

    gui.spots_begin(x1, y1, x2, y2, A.floor_h, SPOT_CLEAR)


    -- start with room edges
    R:spots_do_edges()

    -- handle nearby areas
    for cx = A.cx1 - 1, A.cx2 + 1 do
    for cy = A.cy1 - 1, A.cy2 + 1 do
      do_spot_cell(A, cx, cy)
    end
    end

    -- handle connections
    for sx = R.sx1, R.sx2 do
    for sy = R.sy1, R.sy2 do
      local S = SEEDS[sx][sy]

      if S.room == R then
        do_spot_conn(S)
      end
    end
    end

    -- remove importants
    each imp in R.cave_imps do
      do_spot_important(imp)
    end

    -- remove decorations
    R:spots_do_decor(A.floor_h)

    -- remove walls and blockers (using nearby brushes)
    gui.spots_apply_brushes()


--- gui.spots_dump("Spot dump")


    -- now grab all the spots...

    local item_spots = {}

    if not A.liquid then
      gui.spots_get_items(item_spots)
    end

    each spot in item_spots do
      table.insert(R.item_spots, spot)
    end


    local mon_spots = {}

    gui.spots_get_mons(mon_spots)

    each spot in mon_spots do
--FIXME  spot.face_away = R:find_nonfacing_spot(spot.x1, spot.y1, spot.x2, spot.y2)
      table.insert(R.mon_spots, spot)
    end

    gui.spots_end()
  end


  ---| Cave_determine_spots |---

  each A in info.floors do
    determine_spots(A)
  end
end



function Cave_outdoor_borders()
  --
  -- This adds sky fences where outdoor cave rooms touch the edge
  -- of the map.  It also adds them for outdoor rooms where the
  -- border pieces touch the edge of the map (which simplifies
  -- the design of border pieces).
  --
  -- These sky fences sit outside of any room seeds.  Hence they
  -- must occur at the real edge of the map -- otherwise the
  -- contents of normal seeds would muck them up.
  --

  local function need_sky_border(S, dir)
    -- really at edge of map?
    local N = S:neighbor(dir)

    if not (not N or N.free) then return false end

    if S.map_border then
      return S.map_border.kind != "solid"
    end

    local R = S.room

    if not R then return false end

    if R.kind == "outdoor" then return true end
    if R.kind == "scenic" and R.is_outdoor then return true end

    if R.kind != "cave" then return false end

    local info = R.cave_info

    return info.liquid_mode == "lake" or
           info.sky_mode == "low_wall"
  end


  local function build_sky_border(S, dir)
    local R = S.room
    if S.map_border then R = S.map_border.room end
    assert(R)

    local f_mat = assert(R.main_tex)
    local f_h   = R.floor_min_h - 256

    local x1, y1 = S.x1, S.y1
    local x2, y2 = S.x2, S.y2

    if dir == 2 then y2 = y1 ; y1 = y1 - 16 end
    if dir == 8 then y1 = y2 ; y2 = y2 + 16 end
    if dir == 4 then x2 = x1 ; x1 = x1 - 16 end
    if dir == 6 then x1 = x2 ; x2 = x2 + 16 end

    local brush = brushlib.quad(x1, y1, x2, y2)
    table.insert(brush, { t=f_h, reachable=true })
    brushlib.set_mat(brush, f_mat, f_mat)

    Trans.brush(brush)

    Trans.sky_quad(x1, y1, x2, y2, f_h + 4)
  end


  local function is_seed_outdoor(S)
    if S.room then return S.room.is_outdoor end

    if S.map_border then return true end

    return false
  end


  local function add_range_for_outdoor(sx1, sy1, sx2, sy2)
    for x = sx1, sx2 do
    for y = sy1, sy2 do
      SEEDS[x][y].sun_done = true
    end
    end

    local S1 = SEEDS[sx1][sy1]
    local S2 = SEEDS[sx2][sy2]

    local ent =
    {
      id = "box"
      
      box_type = "outdoor"

      x1 = S1.x1
      y1 = S1.y1
      x2 = S2.x2
      y2 = S2.y2
    }

    -- send it directly to the CSG [ no exporting to .map ]
    gui.add_entity(ent)
  end


  local function test_range_for_outdoor(sx, sy, sw, sh)
    local sx2 = sx + sw - 1
    local sy2 = sy + sh - 1

    if not Seed_valid(sx2, sy2) then return false end

    for x = sx, sx2 do
    for y = sy, sy2 do
      local S = SEEDS[x][y]
      if S.sun_done then return false end
      if not is_seed_outdoor(S) then return false end
    end
    end

    add_range_for_outdoor(sx, sy, sx2, sy2)

    return true
  end


  local function send_outdoor_areas(S, sx, sy)
    -- tell the CSG code which areas are outdoor, so it can limit
    -- the expensive Sun lighting tests to those areas.

    if S.sun_done then return end

    if not is_seed_outdoor(S) then return end
    
    if test_range_for_outdoor(sx, sy, 3, 3) or
       test_range_for_outdoor(sx, sy, 2, 2) or
       test_range_for_outdoor(sx, sy, 1, 1)
    then
       -- OK
    end
  end


  ---| Cave_outdoor_borders |---

  for sx = 1, SEED_W do
  for sy = 1, SEED_TOP do
    local S = SEEDS[sx][sy]

    for dir = 2,8,2 do
      if need_sky_border(S, dir) then
        build_sky_border(S, dir)
      end
    end

    send_outdoor_areas(S, sx, sy)

  end -- sx, sy
  end
end

