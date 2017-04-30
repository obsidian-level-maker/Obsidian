------------------------------------------------------------------------
--  RENDER : CONSTRUCT AREAS
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2008-2017 Andrew Apted
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


function edge_get_rail(S, dir)
  assert(S.area)

  local N = S:neighbor(dir, "NODIR")

  assert(N != "NODIR")

  if not (N and N.area) then return nil end
  if N.area == S.area then return nil end

  local E = S.edge[dir]
  if E and E.rail_mat then return E end

  local junc = Junction_lookup(S.area, N.area)
  if junc.rail_mat then return junc end

  return nil
end



function Render_outer_sky(S, dir, floor_h)
  assert(not geom.is_corner(dir))

  local x1, y1 = S.x1, S.y1
  local x2, y2 = S.x2, S.y2

  if dir == 2 then y2 = y1 ; y1 = y1 - 8 end
  if dir == 8 then y1 = y2 ; y2 = y2 + 8 end

  if dir == 4 then x2 = x1 ; x1 = x1 - 8 end
  if dir == 6 then x1 = x2 ; x2 = x2 + 8 end

  local f_brush = brushlib.quad(x1, y1, x2, y2)

  each C in f_brush do
    C.flags = DOOM_LINE_FLAGS.draw_never
  end

  Ambient_push(LEVEL.sky_light)

  local c_brush = brushlib.copy(f_brush)

  table.insert(f_brush, { t=floor_h, reachable=true })
  table.insert(c_brush, { b=floor_h + 16, delta_z = -16 })

  brushlib.set_mat(f_brush, "_SKY", "_SKY")
  brushlib.set_mat(c_brush, "_SKY", "_SKY")

  Trans.brush(f_brush)
  Trans.brush(c_brush)

  Ambient_pop()
end



function Render_edge(E)
  assert(E)
  assert(E.kind)

  if Edge_is_wallish(E) then
    Corner_mark_walls(E)
  end

  if E.kind == "nothing" or E.kind == "ignore" then
    return
  end


  local A   = assert(E.area)
  local dir = assert(E.dir)

  if A.mode == "void" then return end


  local DIAG_DIR_MAP = { [1]=8, [9]=2, [3]=4, [7]=6 }


  local function raw_wall_brush()
    local S = E.S

    local TK = 16

    local x1, y1 = S.x1, S.y1
    local x2, y2 = S.x2, S.y2

    if dir == 2 then y2 = y1 + TK end
    if dir == 8 then y1 = y2 - TK end

    if dir == 4 then x2 = x1 + TK end
    if dir == 6 then x1 = x2 - TK end


    if dir == 2 or dir == 4 or dir == 6 or dir == 8 then
      return brushlib.quad(x1, y1, x2, y2)

    elseif dir == 1 then
      return
      {
        { x=x1,      y=y2      }
        { x=x2,      y=y1      }
        { x=x2,      y=y1 + TK }
        { x=x1 + TK, y=y2      }
      }

    elseif dir == 9 then
      return
      {
        { x=x1,      y=y2      }
        { x=x1,      y=y2 - TK }
        { x=x2 - TK, y=y1      }
        { x=x2,      y=y1      }
      }

    elseif dir == 3 then
      return
      {
        { x=x1,      y=y1 }
        { x=x2,      y=y2 }
        { x=x2 - TK, y=y2 }
        { x=x1,      y=y1 + TK }
      }

    elseif dir == 7 then
      return
      {
        { x=x1,      y=y1 }
        { x=x1 + TK, y=y1 }
        { x=x2,      y=y2 - TK }
        { x=x2,      y=y2 }
      }

    else
      error("edge_wall : bad dir")
    end
  end


  local function pick_window_fab()
    -- find a window prefab to use
    local reqs =
    {
      kind = "window"

      seed_w = assert(E.long)
      group  = assert(E.window_group)
      height = assert(E.window_height)
    }

    if geom.is_corner(E.dir) then
      reqs.where = "diagonal"
      reqs.seed_h = reqs.seed_w
    else
      reqs.where = "edge"
    end

    local def = Fab_pick(reqs)

    return def
  end


  local function pick_wall_prefab()
    local reqs =
    {
      kind = "wall"

      seed_w = assert(E.long)

      height = A.ceil_h - A.floor_h
    }

    if geom.is_corner(dir) then
      reqs.where = "diagonal"
      reqs.seed_h = reqs.seed_w
    else
      reqs.where = "edge"
    end

    if A.room then
      reqs.env = A.room:get_env()
    end


    if E.area.floor_group and E.area.floor_group.wall_group then
      reqs.group = E.area.floor_group.wall_group
    end

    local def = Fab_pick(reqs, sel(reqs.group, "none_ok", nil))

    -- when a fancy wall is not available, use the plain one
    if not def then
      reqs.group = nil
      def = Fab_pick(reqs)
    end

    return def
  end


  local function pick_fence_prefab()
    local reqs =
    {
      kind = "fence"

      seed_w = assert(E.long)
    }

    if geom.is_corner(dir) then
      reqs.where = "diagonal"
      reqs.seed_h = reqs.seed_w
    else
      reqs.where = "edge"
    end

    -- TODO : secret fences, barred fences

    local def = Fab_pick(reqs)

    return def
  end


  local function edge_inner_sky()
    local floor_h = assert(A.floor_h)

    assert(not geom.is_corner(dir))

    local x1, y1 = S.x1, S.y1
    local x2, y2 = S.x2, S.y2

    if dir == 2 then y2 = y1 + 8 end
    if dir == 8 then y1 = y2 - 8 end

    if dir == 4 then x2 = x1 + 8 end
    if dir == 6 then x1 = x2 - 8 end

    local brush = brushlib.quad(x1, y1, x2, y2)

    each C in brush do
      C.flags = DOOM_LINE_FLAGS.draw_never
    end

    table.insert(brush, { b=floor_h + 16, delta_z = -16 })

    brushlib.set_mat(brush, "_SKY", "_SKY")

    Trans.brush(brush)
  end


  local function edge_wall()

    -- TODO : pictures

    local skin = {}

    skin.wall = assert(E.wall_mat)

    local def = pick_wall_prefab()

    local z = A.floor_h

    local T

    if geom.is_corner(dir) then
      local dir2 = DIAG_DIR_MAP[dir]
      local S = E.S

      T = Trans.box_transform(S.x1, S.y1, S.x2, S.y2, z, dir2)

    else  -- axis-aligned edge

      T = Trans.edge_transform(E, z, 0, 0, def.deep, 0, false)
    end

    Trans.set_fitted_z(T, A.floor_h, A.ceil_h)

    Fabricate(A.room, def, T, { skin })
  end


  local function straddle_fence()
    assert(E.fence_mat)
    local skin = { wall=E.fence_mat }


    local def = pick_fence_prefab()

    local z = assert(E.fence_top_z) - def.fence_h

    local T

    if geom.is_corner(dir) then
      local dir2 = DIAG_DIR_MAP[dir]
      local S = E.S

      T = Trans.box_transform(S.x1, S.y1, S.x2, S.y2, z, dir2)

    else  -- axis-aligned edge

      T = Trans.edge_transform(E, z, 0, 0, def.deep, def.over)
    end

    Fabricate(A.room, def, T, { skin })
  end


  local function seed_touches_junc(S, junc)
    -- FIXME

    return false
  end


  local function calc_step_A_mode(S, dir)
--FIXME
do return "narrow" end

    local junc = S.foo  -- FIXME
    if not junc or junc.kind != "steps" then return "narrow" end

    local N, bord

    if geom.is_straight(dir) then
      N = S:neighbor(geom.LEFT[dir])
      if not (N and N.area == S.area) then return "" end

      N = N:neighbor(dir)
      if not (N and N.area == S.area) then return "" end

      bord = N.foo  -- FIXME
      if bord.junction == junc then return "wide" end

      return "xx"

    else  -- corner

      local dir2 = geom.ROTATE[5][dir]
      local dir3 = geom.RIGHT[dir2]

      N = S:neighbor(dir2)
      if not (N and N.area == S.area) then return "" end

      N = N:neighbor(dir3)
      if not (N and N.area == S.area) then return "" end

      if seed_touches_junc(N, junc) then return "wide" end

      N = N:neighbor(10 - dir2)
      if not (N and N.area == S.area) then return "" end

      if seed_touches_junc(N, junc) then return "wide" end

      return "xx"
    end
  end


  local function calc_step_B_mode(S, dir)
--FIXME
do return "narrow" end

    local junc = S.foo -- FIXME
    if not junc or junc.kind != "steps" then return "narrow" end

    local N, bord

    if geom.is_straight(dir) then
      N = S:neighbor(geom.RIGHT[dir])
      if not (N and N.area == S.area) then return "" end

      N = N:neighbor(dir)
      if not (N and N.area == S.area) then return "" end

      bord = N.foo -- FIXME
      if bord.junction == junc then return "wide" end

      return "xx"

    else  -- corner

      local dir2 = geom.ROTATE[3][dir]
      local dir3 = geom.LEFT[dir2]

      N = S:neighbor(dir2)
      if not (N and N.area == S.area) then return "" end

      N = N:neighbor(dir3)
      if not (N and N.area == S.area) then return "" end

      if seed_touches_junc(N, junc) then return "wide" end

      N = N:neighbor(10 - dir2)
      if not (N and N.area == S.area) then return "" end

      if seed_touches_junc(N, junc) then return "wide" end

      return "wide"
    end
  end


  local function make_step_brush(S, dir, a_mode, b_mode, TK)
    -- define points A and B

    local ax, ay = S.x1, S.y1
    local bx, by = S.x2, S.y2

    if dir == 2 then by = ay ; ax,bx = bx,ax end
    if dir == 8 then ay = by end
    if dir == 4 then bx = ax end
    if dir == 6 then ax = bx ; ay,by = by,ay end

    if dir == 1 or dir == 9 then
      ax,bx = bx,ax
    end

    if dir == 3 or dir == 9 then
      ax,bx = bx,ax
      ay,by = by,ay
    end

    -- compute vectors of points A and B

    local adx, ady = 0, 0
    local bdx, bdy = 0, 0

    if dir == 8 then
      ady, bdy = -1, -1
      if a_mode == "narrow" then adx =  0.5 elseif a_mode == "wide" then adx = -1 end
      if b_mode == "narrow" then bdx = -0.5 elseif b_mode == "wide" then bdx =  1 end
    elseif dir == 2 then
      ady, bdy = 1, 1
      if a_mode == "narrow" then adx = -0.5 elseif a_mode == "wide" then adx =  1 end
      if b_mode == "narrow" then bdx =  0.5 elseif b_mode == "wide" then bdx = -1 end
    elseif dir == 4 then
      adx, bdx = 1, 1
      if a_mode == "narrow" then ady =  0.5 elseif a_mode == "wide" then ady = -1 end
      if b_mode == "narrow" then bdy = -0.5 elseif b_mode == "wide" then bdy =  1 end
    elseif dir == 6 then
      adx, bdx = -1, -1
      if a_mode == "narrow" then ady = -0.5 elseif a_mode == "wide" then ady =  1 end
      if b_mode == "narrow" then bdy =  0.5 elseif b_mode == "wide" then bdy = -1 end

    elseif dir == 1 then
      if a_mode != "wide" then ady = 1 else adx = 1 end
      if b_mode != "wide" then bdx = 1 else bdy = 1 end
    elseif dir == 9 then
      if a_mode != "wide" then ady = -1 else adx = -1 end
      if b_mode != "wide" then bdx = -1 else bdy = -1 end
    elseif dir == 3 then
      if a_mode != "wide" then adx = -1 else ady =  1 end
      if b_mode != "wide" then bdy =  1 else bdx = -1 end
    elseif dir == 7 then
      if a_mode != "wide" then adx =  1 else ady = -1 end
      if b_mode != "wide" then bdy = -1 else bdx =  1 end
    else
      error("bad dir in make_step_brush")
    end

--[[ HANDY DEBUG
stderrf("dir = %d\n", dir)
stderrf("A = (%d %d)  B = (%d %d)\n", ax - S.x1, ay - S.y1, bx - S.x1, by - S.y1)
stderrf("dA = (%1.1f %1.1f)  dB = (%1.1f %1.1f)\n", adx, ady, bdx, bdy)
--]]

    local brush =
    {
      { x = bx, y = by }
      { x = ax, y = ay }
      { x = ax + adx * TK, y = ay + ady * TK }
      { x = bx + bdx * TK, y = by + bdy * TK }
    }

    return brush
  end


  local function edge_steps()
    local mat = assert(E.steps_mat)
    local steps_z1 = E.steps_z1
    local steps_z2 = E.steps_z2

    -- wrong side?
    assert(steps_z2 > steps_z1)

    local diff_h = steps_z2 - steps_z1
    assert(diff_h > 8)

    local num_steps = 1

    while (diff_h / num_steps) > 24 do
      num_steps = num_steps + 1
    end

    local thick = 16 * num_steps
    if thick > 64 then thick = 64 end

    -- determine A and B modes (FIXME? quite broken atm)
    local a_mode = calc_step_A_mode(S, dir)
    local b_mode = calc_step_B_mode(S, dir)

    for i = 1, num_steps do
      local z = steps_z1 + i * diff_h / (num_steps + 1)
      local TK = thick * (num_steps + 1 - i) / num_steps

      local brush = make_step_brush(E.S, E.dir, a_mode, b_mode, TK)

      table.insert(brush, { t=z })

      brushlib.set_mat(brush, mat, mat)

      Trans.brush(brush)
    end
  end


  local function straddle_door()
    assert(E.peer)

    local z

    if E.kind == "window" then
      z = E.window_z
    else
      assert(E.conn)
      z = E.conn.door_h or A.floor_h
    end

    assert(z)


    local flip_it = E.flip_it


    -- setup skin
    local inner_mat = assert(E.wall_mat)
    local outer_mat = assert(E.peer.wall_mat)

    local floor1_mat = E.area.floor_mat
    local floor2_mat = E.peer.area.floor_mat

    local ceil1_mat = E.area.ceil_mat
    local ceil2_mat = E.peer.area.ceil_mat

    if flip_it then
      inner_mat,  outer_mat  = outer_mat,  inner_mat
      floor1_mat, floor2_mat = floor2_mat, floor1_mat
      ceil1_mat,  ceil2_mat  = ceil2_mat,  ceil1_mat
    end

    local skin1 =
    {
      wall   = inner_mat
      outer  = outer_mat
      floor  = floor1_mat
      floor2 = floor2_mat
      ceil   = ceil1_mat
      ceil2  = ceil2_mat
    }

    skin1.lock_tag = E.lock_tag

    local def

    if E.kind == "window" then
      def = pick_window_fab()
    else
      def = assert(E.prefab_def)
    end

    local T

    if geom.is_corner(dir) then
      if flip_it then dir = 10 - dir end

      local dir2 = DIAG_DIR_MAP[dir]

      local S = E.S

      T = Trans.box_transform(S.x1, S.y1, S.x2, S.y2, z, dir2)

    else  -- axis-aligned edge

      T = Trans.edge_transform(E, z, 0, 0, def.deep, def.over, flip_it)
    end

    Fabricate(A.room, def, T, { skin1 })
  end


  ---| Render_edge |---

  if E.kind == "wall" then
    edge_wall()

  elseif E.kind == "sky_edge" and A.floor_h then
    edge_inner_sky()

  elseif E.kind == "steps" then
    edge_steps()

  elseif E.kind == "fence" or
         E.kind == "lock_fence" or
         E.kind == "secret_fence" then
    straddle_fence()

  elseif E.kind == "arch" or
         E.kind == "door" or
         E.kind == "lock_door" or
         E.kind == "secret_door" or
         E.kind == "window" then
    straddle_door()

  else
    error("Unknown edge kind: " .. tostring(E.kind))
  end
end



function Render_junction(A, S, dir)
  -- this actually only does ONE side of the junction

  local N = S:neighbor(dir, "NODIR")

  if N == "NODIR" then return end

  -- create edge-lines for spot finding code
  if N and N.area != A then
    table.insert(A.side_edges, S:get_line(dir))
  end

  if S.done_all then return end

  -- whole chunks never build walls inside them
  if A.chunk and A.chunk.place == "whole" then return end

  -- proper EDGE objects are handled elsewhere
  if S.edge[dir] and S.edge[dir].kind != "ignore" then return end


  -- same area?  absolutely nothing needed
  if N and N.area == A then return end

  -- find the junction (N.area may be NIL)
  local junc

  if N and N.area then
    junc = Junction_lookup(A, N.area)
  else
    junc = Junction_lookup(A, "map_edge")
  end

  if not junc then return end


  -- get the corresponding EDGE info
  local E = sel(junc.A1 == A, junc.E1, junc.E2)

  if not E then return end

  E.S    = S
  E.dir  = dir
  E.long = 1

  Render_edge(E)
end



function Render_corner(cx, cy)

  local corner

  local analysis


  local function make_post()
    local mx, my = corner.x, corner.y
    local mat    = corner.post_mat or "METAL"

    local brush  = brushlib.quad(mx - 12, my - 12, mx + 12, my + 12)

    if corner.post_top_h then
      brushlib.add_top(brush, corner.post_top_h)
    end

    brushlib.set_mat(brush, mat, mat)

    Trans.brush(brush)
  end


  local function make_pillar()
    -- TODO
  end


  local function init_analysis()
    analysis = {}

    each dir in geom.ALL_DIRS do
      if corner.walls[dir] then
        analysis[dir] = corner.walls[dir]
      else
        analysis[dir] = {}
      end
    end
  end


  local function build_filler_normal(dir, L_tex, R_tex)
    -- builds a triangle at the given corner.

    local x = corner.x
    local y = corner.y

    local ax, ay = geom.delta(geom.RIGHT_45[dir])
    local bx, by = geom.delta(geom. LEFT_45[dir])

    ax = ax * 16 ; ay = ay * 16
    bx = bx * 16 ; by = by * 16

    local w_brush = brushlib.triangle(x, y, x+ax, y+ay, x+bx, y+by)

    brushlib.set_mat(w_brush, L_tex)

    Trans.brush(w_brush)
  end


  local function build_filler_sharp(dir, L_tex, R_tex)
    -- builds a wedge shape suitable for a sharp-ish corner.
    -- 'dir' parameter is a side (2, 4, 6 or 8).

    local x = corner.x
    local y = corner.y

    local nx, ny = geom.delta(dir)
    local ax, ay = geom.delta(geom.LEFT[dir])

    local w_brush =
    {
      { x = x + ax*16, y = y + ay*16 }
      { x = x - ax*16, y = y - ay*16 }

      { x = x - ax*8 + nx*8, y = y - ay*8 + ny*8 }
      { x = x + ax*8 + nx*8, y = y + ay*8 + ny*8 }
    }

    brushlib.set_mat(w_brush, L_tex)

    Trans.brush(w_brush)
  end


  local function detect_gap(dir, num_left, num_right, is_sharp)
    -- dir is a corner direction (1, 3, 7, 9)

    -- the starting line must be clear
    if analysis[dir].L or analysis[dir].R then return false end

    local L_dir = dir
    local R_dir = dir

    -- require given number of lines to the left to be clear
    for i = 1, num_left do
      L_dir = geom.LEFT_45[L_dir]

      if analysis[L_dir].L or analysis[L_dir].R then return false end
    end

    -- require given number of lines to the right to be clear
    for i = 1, num_right do
      R_dir = geom.RIGHT_45[R_dir]

      if analysis[R_dir].L or analysis[R_dir].R then return false end
    end

    L_dir = geom.LEFT_45 [L_dir]
    R_dir = geom.RIGHT_45[R_dir]

    local L_tex = analysis[L_dir].R
    local R_tex = analysis[R_dir].L

    -- need solid walls now
    if not (L_tex and R_tex) then return false end

    -- OK --

    -- handle different textures, use a neutral value
    if L_tex != R_tex then
      L_tex = "METAL"
    end

    if is_sharp then
      build_filler_sharp(dir, L_tex)
    else
      build_filler_normal(dir, L_tex)
    end

    return true
  end


  local function polish_walls()
    --
    -- Find gaps where two walls meet at a corner, and fill that gap
    -- (producing a nice polished finish).
    --
    -- Algorithm:
    --   1. analyse the eight lines coming off this corner.
    --      each line may have a wall on each side (left and right).
    --      [ this data is collected while rendering all the edges ]
    --
    --   2. detect the cases where we need a gap filler.
    --      e.g. two axis-aligned walls 90 degrees apart do not need
    --      anything (no gap), but two diagonal walls with a 180 degree
    --      gap needs to be filled at the corner.
    --

    if table.empty(corner.walls) then return end

    init_analysis()

    each dir in geom.CORNERS do
      if detect_gap(dir, 1, 1) or
         detect_gap(dir, 1, 2) or
         detect_gap(dir, 2, 1) or
         detect_gap(dir, 2, 2)
      then
        -- Ok, gap was filled
      end
    end

    each dir in geom.SIDES do
      if detect_gap(dir, 2, 2, "is_sharp") or
         detect_gap(dir, 3, 2, "is_sharp") or
         detect_gap(dir, 2, 3, "is_sharp")
      then
        -- Ok, gap at sharp corner was filled
      end
    end
  end


  ---| Render_corner |---

  corner = Corner_lookup(cx, cy)

  -- TODO: fix this
  Ambient_push(LEVEL.sky_light)

  if corner.kind == nil or corner.kind == "nothing" then
    polish_walls()

  elseif corner.kind == "post" then
    make_post()

  elseif corner.kind == "pillar" then
    make_pillar()

  else
    error("Unknown corner kind: " .. tostring(corner.kind))
  end

  Ambient_pop()
end



function Render_sink_part(A, S, where, sink)

  local corner_field = where .. "_inner"


  local function check_inner_point(cx, cy)
    local corner = Corner_lookup(cx, cy)

    if corner and corner[corner_field] then
      return true
    else
      return false
    end
  end


  local function corner_coord(C)
    local x, y = S.x1, S.y1

    if C == 3 or C == 9 then x = S.x2 end
    if C == 7 or C == 9 then y = S.y2 end

    return x, y
  end


  local function apply_brush(brush, is_trim)
    local mul
    local base_dz

    if where == "floor" then
      brushlib.add_top(brush, A.floor_h + 1)
      base_dz = 1
    else
      brushlib.add_bottom(brush, A.ceil_h - 1)
      base_dz = -1
    end

    local T = brush[#brush]

    if is_trim then
      if not sink.trim_mat then return end

      if sink.trim_dz then
        T.delta_z = sink.trim_dz - base_dz
      end

      T.light_add = sink.trim_light

      brushlib.set_mat(brush, sink.trim_mat, sink.trim_mat)

    else
      if sink.dz then
        T.delta_z = sink.dz - base_dz
      end

      -- these can be nil
      T.light_add = sink.light
      T.special   = sink.special

      brushlib.set_mat(brush, sink.mat, sink.mat)
    end

    Trans.brush(brush)
  end


  local function do_whole_square()
    local brush =
    {
      { x = S.x1, y = S.y1 }
      { x = S.x2, y = S.y1 }
      { x = S.x2, y = S.y2 }
      { x = S.x1, y = S.y2 }
    }

    apply_brush(brush)
  end


  local function do_whole_triangle(A, C, B)
    local cx, cy = corner_coord(C)
    local ax, ay = corner_coord(A)
    local bx, by = corner_coord(B)

    local brush =
    {
      { x = ax, y = ay }
      { x = cx, y = cy }
      { x = bx, y = by }
    }

    apply_brush(brush)
  end


  local function do_triangle(A, C, B, away)
    -- A, B, C are corner numbers
    -- C is the corner either near or away from where the sink goes
    -- the brush formed by A->C->B should be valid (anti-clockwise)

    local curve_mode = away

    if away == "curve" then away = false end
    if away == "outie" then away = true  end

    local cx, cy = corner_coord(C)
    local ax, ay = corner_coord(A)
    local bx, by = corner_coord(B)

    local ax2, ay2 = (ax + cx) / 2, (ay + cy) / 2
    local bx2, by2 = (bx + cx) / 2, (by + cy) / 2

    local k1 = 0.375
    local k2 = 1 - k1

    if away then k1, k2 = k2, k1 end

    local ax3, ay3 = ax * k2 + cx * k1, ay * k2 + cy * k1
    local bx3, by3 = bx * k2 + cx * k1, by * k2 + cy * k1

    if curve_mode == "curve" or curve_mode == "outie" then
      -- either B and C are on the diagonal line, otherwise A and C are

      if B + C == 10 then
        if curve_mode == "outie" then
          bx3 = bx * 0.25 + cx * 0.75
          by3 = by * 0.25 + cy * 0.75
        else
          bx3, by3 = bx2, by2
        end

        bx2 = bx * 0.375 + cx * 0.625
        by2 = by * 0.375 + cy * 0.625

      elseif A + C == 10 then
        if curve_mode == "outie" then
          ax3 = ax * 0.25 + cx * 0.75
          ay3 = ay * 0.25 + cy * 0.75
        else
          ax3, ay3 = ax2, ay2
        end

        ax2 = ax * 0.375 + cx * 0.625
        ay2 = ay * 0.375 + cy * 0.625

      else
        error("do_triangle problem")
      end
    end

--[[ DEBUG
stderrf("C = (%d %d)\n", cx, cy)
stderrf("A = (%d %d)  | (%d %d)  | (%d %d)\n", ax,ay, ax2,ay2, ax3,ay3)
stderrf("B = (%d %d)  | (%d %d)  | (%d %d)\n", bx,by, bx2,by2, bx3,by3)
stderrf("away = %s\n\n", string.bool(away))
--]]

    local brush, trim

    if away then
      brush =
      {
        { x = ax,  y = ay  }
        { x = ax2, y = ay2 }
        { x = bx2, y = by2 }
        { x = bx,  y = by  }
      }

      trim =
      {
        { x = ax2, y = ay2 }
        { x = ax3, y = ay3 }
        { x = bx3, y = by3 }
        { x = bx2, y = by2 }
      }

    else -- near
      brush =
      {
        { x = ax2, y = ay2 }
        { x = cx,  y = cy  }
        { x = bx2, y = by2 }
      }

      trim =
      {
        { x = ax3, y = ay3 }
        { x = ax2, y = ay2 }
        { x = bx2, y = by2 }
        { x = bx3, y = by3 }
      }
    end

    apply_brush(brush)
    apply_brush(trim, "is_trim")
  end


  ---| Render_sink_part |---


  -- categorize corners
  local p1 = check_inner_point(S.sx    , S.sy)
  local p3 = check_inner_point(S.sx + 1, S.sy)
  local p7 = check_inner_point(S.sx    , S.sy + 1)
  local p9 = check_inner_point(S.sx + 1, S.sy + 1)


  if S.diagonal == 1 then
    local p_val = sel(p1,1,0) + sel(p3,2,0) + sel(p7,4,0)

    if p_val == 7 then do_whole_triangle(1,3,7) end

    if p_val == 1 then do_triangle(7,1,3, false) end
    if p_val == 2 then do_triangle(1,3,7, false) end
    if p_val == 4 then do_triangle(3,7,1, false) end

    if p_val == 6 then do_triangle(7,1,3, true) end
    if p_val == 5 then do_triangle(1,3,7, true) end
    if p_val == 3 then do_triangle(3,7,1, true) end

  elseif S.diagonal == 3 then
    local p_val = sel(p1,1,0) + sel(p3,2,0) + sel(p9,4,0)

    if p_val == 7 then do_whole_triangle(1,3,9) end

    if p_val == 1 then do_triangle(9,1,3, false) end
    if p_val == 2 then do_triangle(1,3,9, false) end
    if p_val == 4 then do_triangle(3,9,1, false) end

    if p_val == 6 then do_triangle(9,1,3, true) end
    if p_val == 5 then do_triangle(1,3,9, true) end
    if p_val == 3 then do_triangle(3,9,1, true) end

  elseif S.diagonal == 9 then
    local p_val = sel(p9,1,0) + sel(p7,2,0) + sel(p3,4,0)

    if p_val == 7 then do_whole_triangle(9,7,3) end

    if p_val == 1 then do_triangle(3,9,7, false) end
    if p_val == 2 then do_triangle(9,7,3, false) end
    if p_val == 4 then do_triangle(7,3,9, false) end

    if p_val == 6 then do_triangle(3,9,7, true) end
    if p_val == 5 then do_triangle(9,7,3, true) end
    if p_val == 3 then do_triangle(7,3,9, true) end

  elseif S.diagonal == 7 then

    local p_val = sel(p9,1,0) + sel(p7,2,0) + sel(p1,4,0)

    if p_val == 7 then do_whole_triangle(9,7,1) end

    if p_val == 1 then do_triangle(1,9,7, false) end
    if p_val == 2 then do_triangle(9,7,1, false) end
    if p_val == 4 then do_triangle(7,1,9, false) end

    if p_val == 6 then do_triangle(1,9,7, true) end
    if p_val == 5 then do_triangle(9,7,1, true) end
    if p_val == 3 then do_triangle(7,1,9, true) end

  else  -- Square --

    local p_val = sel(p1,1,0) + sel(p3,2,0) + sel(p7,4,0) + sel(p9,8,0)

    -- nothing open
    if p_val == 0 then return end

    -- all corners open
    if p_val == 15 then do_whole_square() end

    -- one corner open

    if p_val ==  1 then do_triangle(7,1,9, "curve") ; do_triangle(9,1,3, "curve") end
    if p_val ==  2 then do_triangle(1,3,7, "curve") ; do_triangle(7,3,9, "curve") end

    if p_val ==  4 then do_triangle(3,7,1, "curve") ; do_triangle(9,7,3, "curve") end
    if p_val ==  8 then do_triangle(1,9,7, "curve") ; do_triangle(3,9,1, "curve") end

    -- two open, two closed

    if p_val == 3  then do_triangle(7,1,9, false) ; do_triangle(3,9,1, true)  end
    if p_val == 12 then do_triangle(7,1,9, true)  ; do_triangle(3,9,1, false) end

    if p_val == 5  then do_triangle(1,3,7, true)  ; do_triangle(9,7,3, false) end
    if p_val == 10 then do_triangle(1,3,7, false) ; do_triangle(9,7,3, true)  end

    -- the "proper" way
    --if p_val ==  9 then do_triangle(7,1,3, false) ; do_triangle(3,9,7, false) end
    --if p_val ==  6 then do_triangle(9,7,1, false) ; do_triangle(1,3,9, false) end

    -- the "alternative" way : connects the two sub-areas
    if p_val ==  6 then do_triangle(7,1,3, true) ; do_triangle(3,9,7, true) end
    if p_val ==  9 then do_triangle(9,7,1, true) ; do_triangle(1,3,9, true) end

    -- three corners open

    if p_val == 14 then do_triangle(7,1,9, "outie")  ; do_triangle(9,1,3, "outie")  end
    if p_val == 13 then do_triangle(1,3,7, "outie")  ; do_triangle(7,3,9, "outie")  end

    if p_val == 11 then do_triangle(3,7,1, "outie")  ; do_triangle(9,7,3, "outie")  end
    if p_val ==  7 then do_triangle(1,9,7, "outie")  ; do_triangle(3,9,1, "outie")  end
  end
end



function Render_void(A, S)
  -- used for VOID areas

  local w_brush = S:make_brush()

  local mat = "_DEFAULT" -- A.zone.facade_mat

  brushlib.set_mat(w_brush, mat)

  Trans.brush(w_brush)
end



function Render_floor(A, S)
  if S.done_floor then return end

  local f_brush = S:make_brush()

  local f_h = S.floor_h or A.floor_h
  assert(f_h)

  local f_mat = S.floor_mat or A.floor_mat
  local f_side = S.floor_side or S.floor_mat or A.floor_side or f_mat

  local tag = S.tag
-- tag = A.id
-- if A.room then tag = A.room.id end
-- if A.pool_id then tag = 1000 + A.pool_id end
-- if A.ceil_group then tag = A.ceil_group.id end

  -- handle railings [ must be done here ]
  each C in f_brush do
    local info = edge_get_rail(S, C.__dir)
    if info then
      local mat = Mat_lookup_tex(assert(info.rail_mat))
      assert(mat.t)

      C.rail = mat.t
      C.v1 = 0
      C.back_rail = mat.t
      C.back_v1 = 0
      C.blocked = info.rail_block
    end
  end


  table.insert(f_brush, { t=f_h, tag=tag })

  if A.sector_fx then f_brush[#f_brush].special = A.sector_fx end

  brushlib.set_mat(f_brush, f_side, f_mat)


  -- sound blocking for border areas
  if A.is_boundary and A.mode != "liquid" then
    local top_C = f_brush[#f_brush]
    top_C.sound_area = 70000 + A.id
  end


  Trans.brush(f_brush)

  -- remember floor brush for the spot logic
  table.insert(A.floor_brushes, f_brush)

  if A.floor_group and A.floor_group.sink then
    Render_sink_part(A, S, "floor",   A.floor_group.sink)
  end
end



function Render_ceiling(A, S)
  if S.done_ceil then return end

  local c_h = S.ceil_h or A.ceil_h
if not c_h then stderrf("%s : %s\n", (A.chunk and A.chunk.kind) or "-", table.tostr(A)) end
  assert(c_h)

  local c_mat  = S.ceil_mat  or A.ceil_mat
  local c_side = S.ceil_side or S.ceil_mat or A.ceil_side or c_mat

  local c_brush = S:make_brush()

  table.insert(c_brush, { b=c_h })

  brushlib.set_mat(c_brush, c_side, c_mat)

  Trans.brush(c_brush)

  if A.ceil_group and A.ceil_group.sink then
    Render_sink_part(A, S, "ceil", A.ceil_group.sink)
  end
end



function Render_hallway__OLD(A, S)
  local R = A.room

  -- determine common part of prefab name
  local fab_common

  if S.hall_piece then
    if S.hall_piece.shape == "I" then
      fab_common = "stair_"
    else
      fab_common = "curve_"
    end

    -- append "big" or "small"
    fab_common = fab_common .. S.hall_piece.z_size
  end

  local skin = {}


  if S.hall_piece then
    local fab_name = "Hall_f_" .. fab_common
    local def = Fab_lookup(fab_name)

    local z = S.floor_h + S.hall_piece.z_offset
    local T = Trans.box_transform(S.x1, S.y1, S.x2, S.y2, z, S.hall_piece.dir)

    if S.hall_piece.mirror then T.mirror_x = SEED_SIZE / 2 end

    Fabricate(A.room, def, T, { skin })

  else
    Render_floor(A, S)
  end


  if S.hall_piece and not A.is_outdoor and not R.hallway.parent then
    local fab_name = "Hall_c_" .. fab_common
    local def = Fab_lookup(fab_name)

    local z = S.ceil_h + S.hall_piece.z_offset
    local T = Trans.box_transform(S.x1, S.y1, S.x2, S.y2, z, S.hall_piece.dir)

    if S.hall_piece.mirror then T.mirror_x = 96 end

    Fabricate(A.room, def, T, { skin })
  else
    Render_ceiling(A, S)
  end
end



function Render_seed(A, S)
  assert(S.area == A)

  if S.done_all then
    -- done elsewhere
    return
  end

  if S.kind == "void" or A.mode == "void" then
    Render_void(A, S)
    return
  end

  Render_floor  (A, S)
  Render_ceiling(A, S)
end



function Render_mark_done(chunk, mode)
  -- mode can be "all", "floor" or "ceil"

  mode = "done_" .. mode

  for sx = chunk.sx1, chunk.sx2 do
  for sy = chunk.sy1, chunk.sy2 do
    local S = SEEDS[sx][sy]

    S[mode] = true
  end
  end
end



function Render_chunk(chunk)
  --
  -- this handles prefabs which occupy a seed rectangle (chunk) and
  -- are responsible for making the whole floor and/or ceiling.
  --

  -- unused closets will be rendered as void
  if chunk.kind == "closet" and chunk.content_kind == "void" then
    return
  end

  local A = chunk.area

  gui.debugf("\n\n Render_chunk %d in %s (%s / %s)\n", chunk.id, A.room.name, chunk.kind, chunk.content_kind or "-")

  local dir = chunk.from_dir or chunk.dir or 2

  local skin = {}

  local reqs = Chunk_base_reqs(chunk, dir)


  local function do_start()
    reqs.kind = "start"
  end

  local function do_exit()
    reqs.kind = "exit"
  end

  local function do_secret_exit()
    reqs.kind = "secret_exit"
  end

  local function do_cage()
    reqs.kind = "cage"
  end

  local function do_trap()
    reqs.kind  = "trap"
    reqs.shape = "U"

    assert(chunk.trigger)

    skin.trap_tag = assert(chunk.trigger.tag)
  end

  local function do_decoration()
    -- prefab already chosen
    assert(chunk.prefab_def)
  end

  local function do_teleporter()
    reqs.kind = "teleporter"

    local C = assert(chunk.conn)

    if C.R1 == A.room then
      skin. in_tag = C.tele_tag2
      skin.out_tag = C.tele_tag1
    else
      skin. in_tag = C.tele_tag1
      skin.out_tag = C.tele_tag2
    end

    skin. in_target = string.format("tele%d", skin. in_tag)
    skin.out_target = string.format("tele%d", skin.out_tag)
  end

  local function do_stairs()
    assert(chunk.prefab_def)
  end

  local function do_joiner()
    assert(chunk.prefab_def)

    local C = assert(chunk.conn)

    if C.lock and C.lock.kind == "intraroom" then
      skin.lock_tag = assert(C.lock.tag)
    end
  end

  local function do_hallway()
    assert(chunk.prefab_def)
  end

  local function do_switch()
    reqs.kind = "switch"

    assert(chunk.lock)

    skin.lock_tag = assert(chunk.lock.tag)
    skin.action   = 103  -- open door

    -- FIXME BIG HACK for LOWERING PEDESTALS
    if chunk.lock.item then
      skin.action = 23
    end
  end

  local function do_item()
    reqs.kind = "item"

    if chunk.content_kind == "KEY" then
      reqs.item_kind = "key"
    end

    -- for entity remapping (e.g. skull keys), rely on prefab system
    skin.object = assert(chunk.content_item)
  end


  local function chunk_coords(def)
    local x1, y1 = chunk.x1, chunk.y1
    local x2, y2 = chunk.x2, chunk.y2

    -- move closets and joiners to align with nearby walls
    local dir = chunk.from_dir

    if def.deep then
      if dir == 2 then y1 = y1 - def.deep end
      if dir == 8 then y2 = y2 + def.deep end
      if dir == 4 then x1 = x1 - def.deep end
      if dir == 6 then x2 = x2 + def.deep end
    end

    if def.over then
      if dir == 2 then y2 = y2 + def.over end
      if dir == 8 then y1 = y1 - def.over end
      if dir == 4 then x2 = x2 + def.over end
      if dir == 6 then x1 = x1 - def.over end
    end

    return x1,y1, x2,y2
  end


  ---| Render_chunk |---

  -- handle a ceiling paired with a floor
  if chunk.next_highest then
    Render_chunk(chunk.next_highest)
  end

  -- FIXME : reqs.shape

  -- room kind and (for joiners) neighbor room kind
  if A.room then
    reqs.env = A.room:get_env()
  end

  -- handle secret closets and joiners to a secret room
  if chunk.is_secret then
    reqs.key = "secret"
  end

  local what = chunk.content_kind

  if chunk.kind == "stair" then
    do_stairs()

  elseif chunk.kind == "joiner" then
    do_joiner()

  elseif chunk.kind == "hallway" then
    do_hallway()

  elseif what == "START" then
    do_start()

  elseif what == "EXIT" then
    do_exit()

  elseif what == "SECRET_EXIT" then
    do_secret_exit()

  elseif what == "TELEPORTER" then
    do_teleporter()

  elseif what == "SWITCH" then
    do_switch()

  elseif what == "KEY" or what == "WEAPON" or what == "ITEM" then
    do_item()

  elseif what == "CAGE" then
    do_cage()

  elseif what == "TRAP" then
    do_trap()

  elseif what == "DECORATION" then
    do_decoration()

  else
    error("Unsupported chunk kind: " .. tostring(chunk.kind) .. " / " .. tostring(what))
  end


  --- pick the prefab ---

  local def = chunk.prefab_def or Fab_pick(reqs)


  -- build the prefab --

  if chunk.from_area then
    skin.wall  = Junction_calc_wall_tex(chunk.from_area, A)

    skin.floor = chunk.from_area.floor_mat
    skin.ceil  = chunk.from_area.ceil_mat
  end

  if chunk.dest_area then
    skin.outer  = Junction_calc_wall_tex(chunk.dest_area, A)

    skin.floor2 = chunk.dest_area.floor_mat
    skin.ceil2  = chunk.dest_area.ceil_mat
  end


  local x1, y1, x2, y2 = chunk_coords(def)

  local floor_h = assert(A.floor_h) + (def.raise_z or 0)

  local T = Trans.box_transform(x1, y1, x2, y2, floor_h, dir)

  if (chunk.kind == "stair" or chunk.kind == "joiner") and
     chunk.shape == "L" and
     chunk.dest_dir == geom.LEFT[chunk.from_dir]
  then
    T.mirror_x = chunk.sw * SEED_SIZE / 2
  end


  Ambient_push(A.lighting)

  Fabricate(A.room, def, T, { skin })

  Ambient_pop()


  -- mark seeds as done --

  local done_mode

  if def.done_mode then
    done_mode = def.done_mode

  elseif def.kind == "floor" or def.kind == "stairs" then
    done_mode = "floor"

  elseif def.kind == "ceil" then
    done_mode = "ceil"

  else
    done_mode = "all"
  end

  Render_mark_done(chunk, done_mode)
end



function Render_area(A)
  Ambient_push(A.lighting)

  -- handle caves, parks and landscapes
  if A.mode == "nature" or A.mode == "scenic" then
    Render_cells(A.cells)
  else
    each S in A.seeds do
      Render_seed(A, S)
    end
  end

  each E in A.edges do
    assert(E.area == A)
    Render_edge(E)
  end

  each S in A.seeds do
    each dir in geom.ALL_DIRS do
      Render_junction(A, S, dir)
    end
  end

  Ambient_pop()
end



function Render_full_chunks()

  local function build_a_pool(chunk)

    -- TEMPORARY TESTING STUFF, NOT USED ATM

    if chunk.sw < 2 then return end
    if chunk.sh < 2 then return end

    local floor_mat = chunk.area.floor_mat
    if not floor_mat then return end

    local reqs =
    {
      kind  = "floor"
      where = "seeds"

      seed_w = chunk.sw
      seed_h = chunk.sh
    }

    local def = Fab_pick(reqs)
    local skin1 = { floor=floor_mat }

    local S1 = SEEDS[chunk.sx1][chunk.sy1]
    local S2 = SEEDS[chunk.sx2][chunk.sy2]

    local T = Trans.box_transform(S1.x1, S1.y1, S2.x2, S2.y2, chunk.area.floor_h, 2)

    Fabricate(chunk.area.room, def, T, { skin1 })

    -- only for pit test
    Render_mark_done(chunk, "floor")
  end


  ---| Render_full_chunks |---

  each R in LEVEL.rooms do
    each chunk in R.floor_chunks do
      if chunk.content_kind == "floor_fab" then
        Render_chunk(chunk)
      end
    end

    each chunk in R.closets do Render_chunk(chunk) end
    each chunk in R.stairs  do Render_chunk(chunk) end
    each chunk in R.joiners do Render_chunk(chunk) end
    each chunk in R.pieces  do Render_chunk(chunk) end
  end
end



function Render_depot(depot)
  -- dest_R is the room which gets the trap spots
  local dest_R = assert(depot.room)

  gui.debugf("Render_depot for %s\n", dest_R.name)

  local x1 = depot.x1
  local y1 = depot.y1

  local z1 = 0

  -- TODO : use Fab_pick() system
  local def = PREFABS["Depot_raise"]
  assert(def)

  local x2 = x1 + def.seed_w * SEED_SIZE
  local y2 = y1 + def.seed_h * SEED_SIZE

  local T = Trans.box_transform(x1, y1, x2, y2, z1, 2)

  Ambient_push(96)

  Fabricate(dest_R, def, T, { depot.skin })

  Ambient_pop()
end



function Render_all_areas()
  Render_full_chunks()

  each A in LEVEL.areas do
    Render_area(A)
  end

  for cx = 1, SEED_W + 1 do
  for cy = 1, SEED_H + 1 do
    Render_corner(cx, cy)
  end
  end

  each depot in LEVEL.depots do
    Render_depot(depot)
  end
end


------------------------------------------------------------------------


function Render_properties_for_area(A)

  local R = A.room

  -- natural parts done elsewhere...
  if A.mode == "nature" or A.mode == "scenic" then
    if not A.lighting then
      A.lighting = LEVEL.sky_light
    end
    return
  end

  -- nothing needed for void areas
  if A.mode == "void" then
    A.lighting = 144
    return
  end


  if not A.lighting then
    if A.is_outdoor then
      A.lighting = LEVEL.sky_light

    elseif A.room and A.room.is_outdoor then
      -- this for outdoor closets
      A.lighting = LEVEL.sky_light - LEVEL.sky_shadow

    else
      A.lighting = A.base_light or 144
      A.lighting = A.lighting + (A.bump_light or 0)
    end
  end


  if not A.floor_h then
    A.floor_h = -7
  end


  if R then
---##  A.wall_mat = assert(R.main_tex)

  else
    A.floor_mat = "_ERROR"
  end

  if A.mode == "liquid" then
    A.floor_mat = "_LIQUID"
  end

  if A.is_outdoor and not A.is_porch then
    A.ceil_mat = "_SKY"
  end


  A.floor_mat = A.floor_mat or R.main_tex
  A.ceil_mat  = A.ceil_mat  or R.main_tex


  --DEBUG FOR SECRETS
  if A.room and A.room.is_secret then
---  A.floor_mat = "REDWALL"
  end

--[[ PRESSURE TESTING
if A.room and A.room.pressure == "low"    then A.floor_mat = "FWATER1" end
if A.room and A.room.pressure == "medium" then A.floor_mat = "NUKAGE1" end
if A.room and A.room.pressure == "high"   then A.floor_mat = "LAVA1" end
--]]

--[[ ZONE TESTING
if A.mode != "hallway" then
if A.zone.id == 1 then A.floor_mat = "FWATER1" end
if A.zone.id == 2 then A.floor_mat = "NUKAGE1" end
if A.zone.id == 3 then A.floor_mat = "LAVA1" end
if A.zone.id == 4 then A.floor_mat = "CEIL5_2" end
end
--]]
end



function Render_set_all_properties()
  each A in LEVEL.areas do
    Render_properties_for_area(A)
  end
end



------------------------------------------------------------------------


function Render_importants()

  local R  -- the current room


  local function calc_player_see_dist(spot, dir)
    local dx, dy = geom.delta(dir)
    local z = spot.z1 + 48

    local n = 1

    while n < 18 do
      local x2 = spot.mx + n * dx * 64
      local y2 = spot.my + n * dy * 64

      if gui.trace_ray(spot.mx, spot.my, z, x2, y2, z, "v") then
        break;
      end

      n = n + 1
    end

    local dist = (n - 1) / 3

--- stderrf("***** can_see_dist [%d] --> %1.2f\n", dir, dist)

    return dist

--[[ OLD SEED-BASED LOGIC
    -- returns # of whole seeds, zero if a wall directly nearby

    local R = S.area and S.area.room

    if not R then return 0 end

    local dist = 0

    while dist < 20 do
      local N = S:neighbor(dir, "NODIR")
      if not N then break; end

      -- step across a diagonal boundary
      if N == "NODIR" then
        N = S.top or S.bottom
        if N then N = S:neighbor(dir) end
        if not N then break; end
      end

      if (N.area and N.area.room) != R then break; end

      S = N ; dist = dist + 1.0
    end

stderrf("***** can_see_dist [%d] --> %d\n", dir, dist)
    return dist
--]]
  end


  local function player_face_dir(spot)
    local D2 = calc_player_see_dist(spot, 2)
    local D4 = calc_player_see_dist(spot, 4)
    local D6 = calc_player_see_dist(spot, 6)
    local D8 = calc_player_see_dist(spot, 8)

--- stderrf("player_face_dir :  %1.1f  %1.1f  %1.1f  %1.1f\n", D2,D4,D6,D8)

    -- up against a wall?
    if D2 <= 1 and D8 > 1 then D8 = D8 * 1.8 end
    if D8 <= 1 and D2 > 1 then D2 = D2 * 1.8 end
    if D4 <= 1 and D6 > 1 then D6 = D6 * 1.8 end
    if D6 <= 1 and D4 > 1 then D4 = D4 * 1.8 end

    local D_max = math.max(D2, D4, D6, D8)

    if D2 < D_max and D4 < D_max and D6 < D_max then return 8 end
    if D2 < D_max and D4 < D_max and D8 < D_max then return 6 end
    if D2 < D_max and D6 < D_max and D8 < D_max then return 4 end
    if D4 < D_max and D6 < D_max and D8 < D_max then return 2 end

    -- more than one direction is maximal, break the tie
    for loop = 1,50 do
      if D2 == D_max and rand.odds(20) then return 2 end
      if D4 == D_max and rand.odds(20) then return 4 end
      if D6 == D_max and rand.odds(20) then return 6 end
      if D8 == D_max and rand.odds(20) then return 8 end
    end

    return rand.dir()
  end


  local function content_big_item(spot, item)
    local dir = player_face_dir(spot)

    --TODO : area_base_reqs()

    local reqs =
    {
      kind  = "item"
      where = "point"

      size   = assert(spot.space)
      height = spot.area.ceil_h - spot.area.floor_h
    }

    local skin = { object=item }

    if spot.goal and spot.goal.kind == "KEY" then
      reqs.item_kind = "key"
    end

    if spot.lock then
      reqs.key = "lowering"  -- UGH
      skin.lock_tag = assert(spot.lock.tag)
    end

    local def = Fab_pick(reqs)

    local T = Trans.spot_transform(spot.mx, spot.my, spot.z1, dir)

    Fabricate(R, def, T, { skin })
  end


  local function content_start_pad(spot, dir)
    local reqs =
    {
      kind  = "start"
      where = "point"

      size  = assert(spot.space)
      height = spot.area.ceil_h - spot.area.floor_h
    }

    local def = Fab_pick(reqs)

    local T = Trans.spot_transform(spot.mx, spot.my, spot.z1, dir)

    Fabricate(R, def, T, { })
  end


  local function content_coop_pair(spot, dir)
    -- no prefab for this : add player entities directly

    local mx = spot.mx
    local my = spot.my
    local  z = spot.z1

    local angle = geom.ANGLES[dir]

    local dx, dy = geom.delta(dir)

    dx = dx * 24 ; dy = dy * 24

    Trans.entity(R.player_set[1], mx - dy, my + dx, z, { angle=angle })
    Trans.entity(R.player_set[2], mx + dy, my - dx, z, { angle=angle })
  end


  local function content_start(spot)
    local dir = player_face_dir(spot)

    if R.player_set then
      content_coop_pair(spot, dir)
    else
      content_start_pad(spot, dir)
    end
  end


  local function content_exit(spot, secret_exit)
    local dir = player_face_dir(spot)

    local reqs =
    {
      kind  = "exit"
      where = "point"

      size  = assert(spot.space)
      height = spot.area.ceil_h - spot.area.floor_h
    }

    if secret_exit then
      reqs.kind = "secret_exit"
    end

    local def = Fab_pick(reqs)

    local skin1 = { }

    local T = Trans.spot_transform(spot.mx, spot.my, spot.z1, dir)

    Fabricate(R, def, T, { skin1 })
  end


  local function content_switch(spot)
    local dir = player_face_dir(spot)

    local reqs =
    {
      kind  = "switch"
      where = "point"

      size   = assert(spot.space)
      height = spot.area.ceil_h - spot.area.floor_h

      --??  switch = spot.goal.item
    }

    local def = Fab_pick(reqs)

    local skin1 = { }

    skin1.lock_tag = assert(spot.goal.tag)

    skin1.action = spot.goal.action  -- can be NIL

    local T = Trans.spot_transform(spot.mx, spot.my, spot.z1, dir)

    Fabricate(R, def, T, { skin1 })
  end


  local function content_weapon(spot)
    local weapon = assert(spot.content_item)

    if R.is_start or R.is_hallway then
      -- bare item
      Trans.entity(weapon, spot.mx, spot.my, spot.z1)
    else
      content_big_item(spot, weapon)
    end

    gui.debugf("Placed weapon '%s' @ (%d,%d,%d)\n", weapon, spot.mx, spot.my, spot.z1)
  end


  local function content_item(spot)
    local item = assert(spot.content_item)

    if R.is_start or R.is_hallway then
      -- bare item
      Trans.entity(item, spot.mx, spot.my, spot.z1)
    else
      content_big_item(spot, item)
    end
  end


  local function content_flag(spot)
    -- TODO : prefab for flag base

    content_big_item(spot, assert(spot.content_item))
  end


  local function content_teleporter(spot)
    local C = assert(spot.conn)

    local reqs =
    {
      kind  = "teleporter"
      where = "point"

      size   = assert(spot.space)
      height = spot.area.ceil_h - spot.area.floor_h
    }

    local def = Fab_pick(reqs)

    local skin1 = {}

    if C.R1 == R then
      skin1. in_tag = C.tele_tag2
      skin1.out_tag = C.tele_tag1
    else
      skin1. in_tag = C.tele_tag1
      skin1.out_tag = C.tele_tag2
    end

    skin1. in_target = string.format("tele%d", skin1. in_tag)
    skin1.out_target = string.format("tele%d", skin1.out_tag)

    local dir = player_face_dir(spot)

    local T = Trans.spot_transform(spot.mx, spot.my, spot.z1, dir)

    Fabricate(R, def, T, { skin1 })
  end


  local function content_mon_teleport(chunk)
    -- creates a small sector with a tag and teleportman entity

    local mx = chunk.mx
    local my = chunk.my

    local r = 16

    local brush = brushlib.quad(mx - r, my - r, mx + r, my + r)

    -- mark as "no draw"
    each C in brush do
      C.draw_never = 1
    end

    local A = assert(chunk.area)

    -- make it higher to ensure it doesn't get eaten by the floor brush
    -- (use delta_z to lower to real height)

    local top =
    {
      t = A.floor_h + 1
      delta_z = -1
      tag = assert(chunk.out_tag)
    }

    table.insert(brush, top)

    brushlib.set_mat(brush, A.floor_mat, A.floor_mat)

    Trans.brush(brush)

    -- add teleport entity
    Trans.entity("teleport_spot", mx, my, top.t + 1)
  end


  local function content_decoration(chunk)
    local def = assert(chunk.prefab_def)
    local A   = chunk.area

    local floor_h = A.floor_h + (chunk.floor_dz or 0)
    local ceil_h  = A.ceil_h  + (chunk.ceil_dz  or 0)

    local skin = { floor=A.floor_mat, ceil=A.ceil_mat }

    if def.face_open then
      chunk.prefab_dir = player_face_dir(chunk)
    end

    local T = Trans.spot_transform(chunk.mx, chunk.my, floor_h, chunk.prefab_dir or 2)

    if def.z_fit then
      Trans.set_fitted_z(T, floor_h, ceil_h)
    end

    Fabricate(A.room, def, T, { skin })
  end


  local function build_important(chunk)
    chunk.z1 = assert(chunk.area.floor_h)

    Ambient_push(chunk.area.lighting)

    if chunk.content_kind == "START" then
      content_start(chunk)

    elseif chunk.content_kind == "EXIT" then
      content_exit(chunk)

    elseif chunk.content_kind == "SECRET_EXIT" then
      content_exit(chunk, "secret_exit")

    elseif chunk.content_kind == "KEY" then
      content_big_item(chunk, assert(chunk.content_item))

    elseif chunk.content_kind == "SWITCH" then
      content_switch(chunk)

    elseif chunk.content_kind == "WEAPON" then
      content_weapon(chunk)

    elseif chunk.content_kind == "ITEM" then
      content_item(chunk)

    elseif chunk.content_kind == "FLAG" then
      content_flag(chunk)

    elseif chunk.content_kind == "TELEPORTER" then
      content_teleporter(chunk)

    elseif chunk.content_kind == "MON_TELEPORT" then
      content_mon_teleport(chunk)

    elseif chunk.content_kind == "DECORATION" or chunk.content_kind == "CAGE" then
      content_decoration(chunk)

    else
      error("unknown important: " .. tostring(chunk.content_kind))
    end

    Ambient_pop()
  end


  local function build_ceiling_thang(chunk)
    if chunk.content_kind != "DECORATION" then
      error("Unknown ceiling thang: " .. tostring(chunk.content_kind))
    end

    local def = assert(chunk.prefab_def)
    local A   = chunk.area

    local ceil_h = assert(A.ceil_h) + (chunk.ceil_dz or 0)

    local skin = { ceil=A.ceil_mat }
    local T = Trans.spot_transform(chunk.mx, chunk.my, ceil_h, chunk.prefab_dir or 2)

    assert(def.z_fit == nil)

    Fabricate(A.room, def, T, { skin })
  end


  ---| Render_importants |---

  each room in LEVEL.rooms do
    R = room

    each chunk in R.floor_chunks do
      if chunk.content_kind and chunk.content_kind != "NOTHING" then
        build_important(chunk)
      end
    end

    each chunk in R.ceil_chunks do
      if chunk.content_kind and chunk.content_kind != "NOTHING" then
        build_ceiling_thang(chunk)
      end
    end
  end
end



function Render_triggers()

  local function setup_coord(C, trig)
    C.special = assert(trig.action)
    C.tag     = assert(trig.tag)
  end


  local function handle_brush(brush, trig)
    brushlib.set_kind(brush, "trigger")

    Trans.brush(brush)
  end


  local function do_spot_trigger(R, trig)
    local chunk = assert(trig.spot)
    local brush

    if chunk.trig_radius then
      local r = chunk.trig_radius

      brush = brushlib.quad(chunk.mx - r, chunk.my - r, chunk.mx + r, chunk.my + r)
    else
      local w = chunk.sw * 24
      local h = chunk.sh * 24

      brush = brushlib.quad(chunk.x1 + w, chunk.y1 + h, chunk.x2 - w, chunk.y2 - h)
    end

    each C in brush do
      setup_coord(C, trig)
    end

    handle_brush(brush, trig)
  end


  local function do_diagonal_trigger(R, trig)
    local E = assert(trig.edge)

    -- FIXME : handle long diagonal edges

    local x1, y1 = E.S.x1, E.S.y1
    local x2, y2 = E.S.x2, E.S.y2

    -- offset from the sides, in case another trigger would overlap us
    x1 = x1 + 16 ; y1 = y1 + 16
    x2 = x2 - 16 ; y2 = y2 - 16

    -- construct the brush
    local brush = {}

    local side_dir = geom.RIGHT_45[E.dir]

    for side_num = 1, 4 do
      local C = {}

      if side_dir == 2 then C.x = x1 ; C.y = y1 end
      if side_dir == 4 then C.x = x1 ; C.y = y2 end
      if side_dir == 6 then C.x = x2 ; C.y = y1 end
      if side_dir == 8 then C.x = x2 ; C.y = y2 end

      assert(C.x)

      -- two sides have the trigger info, other two sides are empty
      if side_num >= 3 then
        setup_coord(C, trig)
      end

      table.insert(brush, C)

      side_dir = geom.LEFT[side_dir]
    end

    handle_brush(brush, trig)
  end


  local function do_edge_trigger(R, trig, E)
    if geom.is_corner(E.dir) then
      do_diagonal_trigger(R, trig)
      return
    end

    local out_dist = trig.out_dist or 64

    -- compute the bounding box of the trigger
    local x1, y1 = E.S.x1, E.S.y1
    local x2, y2 = E.S.x2, E.S.y2

    local l_add = (E.long - 1) * SEED_SIZE - 16

    if E.dir == 8 then x1 = x1 + 16 ; x2 = x2 + l_add ; y1 = y2 - out_dist end
    if E.dir == 4 then y1 = y1 + 16 ; y2 = y2 + l_add ; x2 = x1 + out_dist end

    if E.dir == 2 then x1 = x1 - l_add ; x2 = x2 - 16 ; y2 = y1 + out_dist end
    if E.dir == 6 then y1 = y1 - l_add ; y2 = y2 - 16 ; x1 = x2 - out_dist end

    -- construct the brush
    local brush = {}

    local side_dir = E.dir

    for side_num = 1, 4 do
      local C = {}

      if side_dir == 2 then C.x = x1 ; C.y = y1 end
      if side_dir == 4 then C.x = x1 ; C.y = y2 end
      if side_dir == 6 then C.x = x2 ; C.y = y1 end
      if side_dir == 8 then C.x = x2 ; C.y = y2 end

      assert(C.x)

      -- three sides have the trigger info, other one is empty
      if side_num >= 2 then
        setup_coord(C, trig)
      end

      table.insert(brush, C)

      side_dir = geom.LEFT[side_dir]
    end

    handle_brush(brush, trig)
  end


  local function build_trigger(R, trig)
    if trig.kind == "spot" then
      do_spot_trigger(R, trig)

    elseif trig.kind == "edge" then
      each E in trig.edges do
        do_edge_trigger(R, trig, E)
      end

    else
      error("Unknown trigger kind: " .. tostring(trig.kind))
    end
  end


  local function test_triggers()
    each C in LEVEL.conns do
      local E = C.E1
      if C.R1.lev_along > C.R2.lev_along then E = C.E2 end
      if E then
        local TRIG =
        {
          kind = "edge"
          edge = E
          action = 1
          tag = C.R1.id
        }
        build_trigger(R, TRIG)
      end
    end
  end


  ---| Render_triggers |---

  each R in LEVEL.rooms do
    each trig in R.triggers do
      build_trigger(R, trig)
    end
  end
end


------------------------------------------------------------------------


function Render_determine_spots()
  --
  -- ALGORITHM:
  --
  -- For each area of each room:
  --
  --   1. initialize grid to be LEDGE.
  --
  --   2. CLEAR the polygons for area's floor.  This will produce areas
  --      which are somewhat too large.
  --
  --   3. use draw_line to set edges of area to LEDGE again, fixing the
  --      "too large" problem of the above step.
  --
  --   4. use the CSG code to kill any blocking brushes.
  --      This step creates the WALL cells.
  --
  local info


  local function spots_in_flat_floor(R, A, mode)
    -- the 'mode' is normally NIL, can also be "cage" or "trap"
    if not mode then mode = A.mode end

    -- get bbox of room
    local rx1, ry1, rx2, ry2 = A:calc_real_bbox()

    -- initialize grid to "ledge"
    gui.spots_begin(rx1 - 48, ry1 - 48, rx2 + 48, ry2 + 48, A.floor_h, SPOT_LEDGE)

    -- clear polygons making up the floor
    each brush in A.floor_brushes do
      gui.spots_fill_poly(brush, SPOT_CLEAR)
    end

    -- set the edges of the area
    each E in A.side_edges do
      gui.spots_draw_line(E.x1, E.y1, E.x2, E.y2, SPOT_LEDGE)
    end

    -- remove decoration entities
    R:spots_do_decor(A.floor_h)

    -- remove walls and blockers (using nearby brushes)
    gui.spots_apply_brushes()

--- gui.spots_dump("Spot dump in " .. R.name .. "/" .. A.mode)

    -- add the spots to the room
    local item_spots = {}
    local  mon_spots = {}

    gui.spots_get_items(item_spots)
    gui.spots_get_mons(mon_spots)

--- gui.debugf("mon_spots @ %s floor:%d : %d\n", R.name, A.floor_h, #mon_spots)

    -- this is mainly for traps
    if A.mon_focus then
      each spot in mon_spots do
        spot.face = A.mon_focus
      end
    end

    -- for large cages/traps, adjust quantities
    if mode == "cage" or mode == "trap" then
      each spot in mon_spots do
        spot.use_factor = 1.0 / (A.svolume ^ 0.64)
      end
    end

    if mode == "cage" then
      table.insert(R.cages, { mon_spots=mon_spots })

    elseif mode == "trap" then
      table.insert(R.traps, { mon_spots=mon_spots })
      table.append(R.item_spots, item_spots)

    else
      -- do not place items in damaging liquids
      -- [ we skip monsters too because we can place big items in a mon spot ]
      if A.mode != "liquid" then
        table.append(R.item_spots, item_spots)
        table.append(R.mon_spots,  mon_spots)
      end
    end

    gui.spots_end()

--- DEBUG:
--- stderrf("AREA_%d has %d mon spots, %d item spots\n", A.id, #mon_spots, #item_spots)
  end


  local function do_floor_cell(x, y)
    if x < 1 or x > info.W then return end
    if y < 1 or y > info.H then return end

    local A = info.blocks[x][y]

    if not A then return end
    if not A.floor_h then return end

    local poly = Cave_brush(info, x, y)

    gui.spots_fill_poly(poly, SPOT_CLEAR)
  end


  local function spots_in_cave_floor(R, FL)
    assert(FL.cx1 and FL.cy2)

    -- determine bbox (with a bit extra)
    local x1 = info.x1 + (FL.cx1 - 2) * 64
    local y1 = info.y1 + (FL.cy1 - 2) * 64

    local x2 = info.x1 + (FL.cx2 + 1) * 64
    local y2 = info.y1 + (FL.cy2 + 1) * 64

    -- initialize grid to "ledge"
    gui.spots_begin(x1, y1, x2, y2, FL.floor_h, SPOT_LEDGE)

    -- clear the floors
    for cx = FL.cx1, FL.cx2 do
    for cy = FL.cy1, FL.cy2 do
      do_floor_cell(cx, cy)
    end
    end

    -- set the edges of the room
    each E in info.area.side_edges do
      gui.spots_draw_line(E.x1, E.y1, E.x2, E.y2, SPOT_LEDGE)
    end

    -- remove decoration entities
    R:spots_do_decor(FL.floor_h)

    -- remove walls and blockers (using nearby brushes)
    gui.spots_apply_brushes()

gui.spots_dump("Cave spot dump")


    -- now grab all the spots...

    local item_spots = {}
    local  mon_spots = {}

    gui.spots_get_items(item_spots)
    gui.spots_get_mons(mon_spots)

    table.append(R.item_spots, item_spots)
    table.append(R.mon_spots,  mon_spots)

    gui.spots_end()
  end


  local function spots_in_natural_area(R, area)
    info = assert(area.cells)

    each FL in info.floors do
      spots_in_cave_floor(R, FL)
    end
  end


  local function spots_in_room(R)
    each A in R.areas do
      if A.mode == "floor" or A.mode == "cage" then
        spots_in_flat_floor(R, A)

      elseif A.mode == "nature" then
        spots_in_natural_area(R, A)
      end
    end
  end


  local function entry_spot_for_conn(R, C)
    -- FIXME : entry_spot_for_conn
  end


  local function find_entry_spots(R)
    if R.entry_conn then
      entry_spot_for_conn(R, C)
    end

    -- TODO : start pad, teleporter pad

    -- TODO : closets
  end


  ---| Render_determine_spots |---

  each R in LEVEL.rooms do
    spots_in_room(R)

    R:exclude_monsters()

    find_entry_spots(R)
  end
end


------------------------------------------------------------------------


function Render_cells(info)
  assert(info)


  local is_lake = (info.liquid_mode == "lake")

  -- the delta map specifies how to move each corner of the 64x64 cells
  -- (where the cells form a continuous mesh).
  local delta_x_map
  local delta_y_map


  local function grab_cell(x, y)
    -- Produce a string representing the cell, or NIL for invalid cells.
    -- The string is of the form "S-FFFFF-CCCCC-LLL", where:
    --    S is solidity (2 for solid, 1 is normal)
    --    F is floor height (adjusted to prevent negative values)
    --    C is ceiling height (negated, since lower ceils can block the player)

    if x < 1 or x > info.W or y < 1 or y > info.H then
      return nil
    end

    local A = info.blocks[x][y]

    -- in some places we build nothing (e.g. other rooms)
    if A == nil then return nil end

    -- check for a solid cell
    if A.is_wall then return "2-99999-99999" end

    -- otherwise there should be a floor area here

    assert(A)
    assert(A.floor_h)
    assert(A.ceil_h)

    return string.format("1-%5d-%5d", A.floor_h + 50000, 50000 - A.ceil_h)
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

    -- pick highest floor (since that can block a lower floor).
    -- solid cells will always override floor cells.

    local max_h = A
    if B > A then max_h = B end
    if C > A then max_h = C end
    if D > A then max_h = D end

    -- convert A/B/C/D to boolean values
    A = (A == max_h)
    B = (B == max_h)
    C = (C == max_h)
    D = (D == max_h)

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

    -- get nearby values
    local prev_x, prev_y

    if y >= 2 then prev_x = delta_x_map[x][y-1] end
    if x >= 2 then prev_y = delta_y_map[x-1][y] end

    prev_x = (prev_x or 0) * x_mul
    prev_y = (prev_y or 0) * y_mul

    --- ANALYSE! ---

    if not B and not C and not D then
      -- sticking out corner
      if prev_x == 0 or (prev_x > 0 and rand.odds(75)) then delta_x_map[x][y] = -16 * x_mul end
      if prev_y == 0 or (prev_y > 0 and rand.odds(75)) then delta_y_map[x][y] = -16 * y_mul end

    elseif B and not C and not D then
      -- horizontal wall
      if prev_y == 0 or (prev_y > 0 and rand.odds(25)) then delta_y_map[x][y] = -24 * y_mul end

    elseif C and not B and not D then
      -- vertical wall
      if prev_x == 0 or (prev_x > 0 and rand.odds(25)) then delta_x_map[x][y] = -24 * x_mul end

    elseif D and not B and not C then
      -- checkerboard
      -- (not moving it : this situation should not occur)

    else
      -- an empty corner
      -- expand a bit, but not enough to block player movement
          if not B then y_mul = -y_mul
      elseif not C then x_mul = -x_mul
      end

      if prev_x == 0 or (prev_x < 0 and rand.odds(90)) then delta_x_map[x][y] = 12 * x_mul end
      if prev_y == 0 or (prev_y < 0 and rand.odds(90)) then delta_y_map[x][y] = 12 * y_mul end
    end
  end


  local function create_delta_map()
    local dw = info.W + 1
    local dh = info.H + 1

    delta_x_map = table.array_2D(dw, dh)
    delta_y_map = table.array_2D(dw, dh)

    info.delta_x_map = delta_x_map
    info.delta_y_map = delta_y_map

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


  local function dist_to_light_level(d)
    if d >= 312 then return 0  end
    if d >= 208 then return 16 end
    if d >= 104 then return 32 end
    return 48
  end

--[[
  local function OLD__dist_to_light_level(d)
    if d >  276 then return 0  end
    if d >  104 then return 16 end
    if d >   40 then return 32 end
    if R.light_level != "verydark" then return 32 end
    return 48
  end
--]]


  local function calc_lighting_for_cell(x, y, A)
    if not A then return 0 end
    if not A.floor_h then return 0 end

    local cell_x, cell_y = cell_middle(x, y)
    local cell_z = A.floor_h + 80

    local result = 0

    each L in info.lights do
      -- compute distance
      local dx = L.x - cell_x
      local dy = L.y - cell_y

      local dist = math.sqrt(dx * dx + dy * dy)

      local val = dist_to_light_level(dist)

      -- check if result would be updated.
      -- this does a distance check too (val is zero for far away lights)
      if val <= result then continue end

      -- check if line of sight is blocked
      -- [ this is expensive, so call it AFTER distance test ]
      if not gui.trace_ray(L.x, L.y, L.z, cell_x, cell_y, cell_z, "v") then
        result = val
      end
    end

    return result
  end


  local function render_floor(x, y, A)
    local f_h = A.floor_h

    -- TODO : review this
    local R = info.area.room or {}

    local f_mat = A.floor_mat or R.floor_mat or R.main_tex or "_ERROR"

    if A.is_wall or A.is_fence then
      f_mat = A.wall_mat or R.main_tex or R.main_tex
    end


    local f_brush = Cave_brush(info, x, y)

    if f_h then
      local top = { t=f_h }

      if info.torch_mode != "none" then
        top.is_cave = 1
      end

top.reachable = 1  --!!!!!! FIXME: remove

      table.insert(f_brush, top)
    end

    if A.is_liquid then
      f_mat = "_LIQUID"
    end

    brushlib.set_mat(f_brush, f_mat, f_mat)

    Trans.brush(f_brush)
  end


  local function render_ceiling(x, y, A)
    if not A.ceil_h then return end

    -- TODO : review this
    local R = info.area.room or {}

    local c_mat = A.ceil_mat or R.ceil_mat or R.main_tex or "_ERROR"

    local c_brush = Cave_brush(info, x, y)

    local bottom = { b=A.ceil_h }
    table.insert(c_brush, bottom)

    if A.is_sky then
      c_mat = "_SKY"

      if not LEVEL.is_dark then
        bottom.light_add = 32
      end
    end

    brushlib.set_mat(c_brush, c_mat, c_mat)

    Trans.brush(c_brush)
  end


  local function render_lit_cell(x, y, A)
    local light

    if info.torch_mode != "none" then
      light = calc_lighting_for_cell(x, y, A)
      if light <= 0 then light = nil end
    end

    if light then
      Ambient_push(info.area.base_light + light)
    end

    render_floor  (x, y, A)
    render_ceiling(x, y, A)

    if light then
      Ambient_pop()
    end
  end


  local function render_cell(x, y, pass)
    local A = info.blocks[x][y]

    if not A then return end

    local is_solid = (A.floor_h == nil)

    if is_solid and pass == 1 then
      render_floor(x, y, A)
    end

    if not is_solid and pass == 2 then
      render_lit_cell(x, y, A)
    end
  end


--[[ OLD STUFF.... TODO: REVIEW IF USEFUL

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

--FIXME  assert(min_floor < max_ceil)

    return min_floor, max_ceil
  end


  local function render_liquid_area(island)
    -- create a lava/nukage pit

    local f_mat = R.floor_mat or cave_tex
    local c_mat = R.ceil_mat  or cave_tex
    local l_mat = LEVEL.liquid.mat

    local f_h, c_h = heights_near_island(island)

    -- FIXME! should not happen
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
    each S in info.area.seeds do
      local rect =
      {
        x1 = S.x1, y1 = S.y1
        x2 = S.x2, y2 = S.y2
      }

      table.insert(R.sky_rects, rect)
    end
  end


  local function render_all_cells(pass)
    -- pass is 1 for solid cells, 2 for normal (open) cells

    for x = 1, info.W do
    for y = 1, info.H do
      render_cell(x, y, pass)
    end
    end
  end


  ---| Render_cells |---

  Trans.clear()

  create_delta_map()

---???  add_liquid_pools()

  -- send all solid cells to the CSG system
  -- [ to allow gui.trace_ray() to hit them ]

  render_all_cells(1)

  if info.torch_mode != "none" then
---    do_torch_lighting()
  end

  render_all_cells(2)

  if info.area.is_outdoor and false then --!!!!
    add_sky_rects()
  end
end

