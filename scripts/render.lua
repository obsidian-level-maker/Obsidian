------------------------------------------------------------------------
--  RENDER : CONSTRUCT AREAS
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2008-2015 Andrew Apted
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


function calc_wall_mat(A1, A2)
  if not A1 then
    return "_ERROR"
  end

if A2.mode == "void" then return "COMPSPAN" end

  if not A1.is_outdoor then
    return assert(A1.wall_mat)
  end

  if not A2 or A2.is_outdoor then
    return assert(LEVEL.fence_mat)
  end
 
  return assert(A2.facade_mat)
end


function calc_straddle_mat(A1, A2)
  local mat1 = calc_wall_mat(A1, A2)
  local mat2 = calc_wall_mat(A2, A1)

  return mat1, mat2
end


function edge_get_rail(S, dir)
  assert(S.area)

  local N = S:neighbor(dir, "NODIR")

  assert(N != "NODIR")

  if not (N and N.area) then return nil end
  if N.area == S.area then return nil end

  local bord = S.border[dir]

  if bord.kind == "rail" then return bord end

  if bord.kind != nil then return nil end

  local junc = assert(bord.junction)

  if junc.kind == "rail" then return junc end

  return nil
end


function dummy_arch(S, dir)
  local mx, my = S:mid_point()

  if dir == 2 then my = int((my + S.y1 * 7) / 8) end
  if dir == 8 then my = int((my + S.y2 * 7) / 8) end
  if dir == 4 then mx = int((mx + S.x1 * 7) / 8) end
  if dir == 6 then mx = int((mx + S.x2 * 7) / 8) end

--[[ FIXME
  if dir == 1 then mx = mx - 40 ; my = my - 40 end
  if dir == 3 then mx = mx + 40 ; my = my - 40 end
  if dir == 7 then mx = mx - 40 ; my = my + 40 end
  if dir == 9 then mx = mx + 40 ; my = my + 40 end
--]]

  Trans.entity("candle", mx, my, assert(S.area.floor_h))
end



function Render_edge(A, S, dir)

  local info = S.border[dir]
  local LOCK = info.lock

  local NA  -- neighbor area

  local DIAG_DIR_MAP = { [1]=2, [9]=8, [3]=6, [7]=4 }


  local function raw_wall_brush()
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


  local function edge_wall(mat)
    local brush = raw_wall_brush()

    brushlib.set_mat(brush, mat, mat)

    Trans.brush(brush)
  end


  local function edge_trap_wall(mat)
    if NA.mode != "trap" then return end

    assert(info.trigger)

    local brush = raw_wall_brush()

    -- don't want to reveal trap on automap
    each C in brush do
      C.draw_secret = true
    end

    table.insert(brush, { b=A.floor_h + 2, delta_z=-2, tag=info.trigger.tag })

    brushlib.set_mat(brush, mat, mat)

    Trans.brush(brush)
  end


  local function edge_simple_sky(floor_h)
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


  local function straddle_fence()
    local mat = assert(info.fence_mat)
    local top_z = assert(info.fence_top_z)
    local TK = info.fence_thick or 16

    local x1, y1 = S.x1, S.y1
    local x2, y2 = S.x2, S.y2

    if dir == 2 then y2 = y1 end
    if dir == 8 then y1 = y2 end

    if dir == 4 then x2 = x1 end
    if dir == 6 then x1 = x2 end

    local brush

    if dir == 2 or dir == 4 or dir == 6 or dir == 8 then
      brush = brushlib.quad(x1 - TK, y1 - TK, x2 + TK, y2 + TK)

    elseif dir == 3 or dir == 7 then
      brush =
      {
        { x=x1 - TK, y=y1 + TK }
        { x=x1 - TK, y=y1 - TK }
        { x=x1 + TK, y=y1 - TK }

        { x=x2 + TK, y=y2 - TK }
        { x=x2 + TK, y=y2 + TK }
        { x=x2 - TK, y=y2 + TK }
      }
    else
      brush =
      {
        { x=x2 - TK, y=y1 - TK }
        { x=x2 + TK, y=y1 - TK }
        { x=x2 + TK, y=y1 + TK }

        { x=x1 + TK, y=y2 + TK }
        { x=x1 - TK, y=y2 + TK }
        { x=x1 - TK, y=y2 - TK }
      }
    end

    table.insert(brush, { t=top_z })

    brushlib.set_mat(brush, mat, mat)

    Trans.brush(brush)
  end


  local function seed_touches_junc(S, junc)
    each dir in geom.ALL_DIRS do
      if S.border[dir].junction == junc then return true end
    end

    return false
  end


  local function calc_step_A_mode(S, dir)
    local junc = S.border[dir].junction
    if not junc or junc.kind != "steps" then return "narrow" end

    local N, bord

    if geom.is_straight(dir) then
      N = S:neighbor(geom.LEFT[dir])
      if not (N and N.area == S.area) then return "" end

      N = N:neighbor(dir)
      if not (N and N.area == S.area) then return "" end

      bord = N.border[geom.RIGHT[dir]]
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
    local junc = S.border[dir].junction
    if not junc or junc.kind != "steps" then return "narrow" end

    local N, bord

    if geom.is_straight(dir) then
      N = S:neighbor(geom.RIGHT[dir])
      if not (N and N.area == S.area) then return "" end

      N = N:neighbor(dir)
      if not (N and N.area == S.area) then return "" end

      bord = N.border[geom.LEFT[dir]]
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
    local mat = assert(info.steps_mat)
    local steps_z1 =  A.floor_h
    local steps_z2 = NA.floor_h
    local thick = info.steps_thick or 48

    -- wrong side?
    if steps_z2 < steps_z1 then return end

    local diff_h = steps_z2 - steps_z1
    assert(diff_h > 8)
    assert(diff_h <= 96)

    local num_steps = 1

    if diff_h > 32 then num_steps = 2 end
    if diff_h > 64 then num_steps = 3 end

    -- determine A and B modes
    local a_mode = calc_step_A_mode(S, dir)
    local b_mode = calc_step_B_mode(S, dir)

    for i = 1, num_steps do
      local z = steps_z1 + i * diff_h / (num_steps + 1)
      local TK = thick * (num_steps + 1 - i) / num_steps

      local brush = make_step_brush(S, dir, a_mode, b_mode, TK)

      table.insert(brush, { t=z })

      brushlib.set_mat(brush, mat, mat)

      Trans.brush(brush)
    end
  end


  local function straddle_locked_door()
    local z = A.floor_h

    assert(LOCK)


    -- ensure it faces the correct direction
    if LOCK.conn.A1 != A then
      assert(LOCK.conn.A2 == A)

      if not geom.is_corner(dir) then
        S = S:neighbor(dir)
      end

      dir = 10 - dir
    end


    local inner_mat, outer_mat = calc_straddle_mat(A, NA)

    local skin1 = { wall=inner_mat, outer=outer_mat }

    if LOCK.goals[1].kind == "SWITCH" then
      skin1.lock_tag = assert(LOCK.goals[1].tag)
    end


    -- FIXME : find it properly
    local fab_name

    if #LOCK.goals == 2 then
      fab_name = "Locked_double"
    elseif #LOCK.goals == 3 then
      fab_name = "Locked_ks_ALL"
    else
      fab_name = "Locked_" .. LOCK.goals[1].item
    end

    local def


    if geom.is_corner(dir) then
      fab_name = fab_name .. "_diag"

      local def = PREFABS[fab_name]
      assert(def)

      local dir2 = DIAG_DIR_MAP[dir]

      local T = Trans.box_transform(S.x1, S.y1, S.x2, S.y2, z, dir2)

      Fabricate(R, def, T, { skin1 })

    else  -- axis-aligned edge

      local def = PREFABS[fab_name]
      assert(def)

      local S2 = S
      local seed_w = 1

      local T = Trans.edge_transform(S.x1, S.y1, S2.x2, S2.y2, z,
                                     dir, 0, seed_w * 192, def.deep, def.over)

      Fabricate(R, def, T, { skin1 })
  
---???    do_door_base(S, dir, z, w_tex, o_tex)
    end
  end


  local function straddle_window()
    -- FIXME: window_z1 in JUNC/BORD
    local z = math.max(A.floor_h, NA.floor_h)

    local inner_mat, outer_mat = calc_straddle_mat(A, NA)

    local skin1 = { wall=inner_mat, outer=outer_mat }


    -- FIXME : find it properly
    local fab_name = "Window_wide"

    local def


    if geom.is_corner(dir) then
      fab_name = fab_name .. "_diag"

      local def = PREFABS[fab_name]
      assert(def)

      local dir2 = DIAG_DIR_MAP[dir]

      local T = Trans.box_transform(S.x1, S.y1, S.x2, S.y2, z, dir2)

      Fabricate(R, def, T, { skin1 })

    else  -- axis-aligned edge

      local def = PREFABS[fab_name]
      assert(def)

      local S2 = S
      local seed_w = 1

      local T = Trans.edge_transform(S.x1, S.y1, S2.x2, S2.y2, z,
                                     dir, 0, seed_w * 192, def.deep, def.over)

      Fabricate(R, def, T, { skin1 })
    end
  end


  local function add_edge_line()
    local x1, y1 = S.x1, S.y1
    local x2, y2 = S.x2, S.y2

    if dir == 2 then y2 = y1 end
    if dir == 8 then y1 = y2 end

    if dir == 4 then x2 = x1 end
    if dir == 6 then x1 = x2 end

    if dir == 3 or dir == 7 then
      -- no change necessary
    end

    if dir == 1 or dir == 9 then
      y1, y2 = y2, y1
    end

    local E = { x1=x1, y1=y1, x2=x2, y2=y2 }

    table.insert(A.side_edges, E)
  end


  ---| Render_edge |---

  local N = S:neighbor(dir, "NODIR")

  if N == "NODIR" then return end


  -- same area?  nothing needed
  NA = N and N.area

  if NA and NA == A then return end


  add_edge_line()


  -- border[] entry overrides, junction is the fallback
  if info.kind == nil then
    info = info.junction
  end


  if not info or info.kind == nil or info.kind == "nothing" then
    return
  
  elseif info.kind == "wall" then
    assert(A)
    edge_wall(calc_wall_mat(A, NA))

  elseif info.kind == "trap_wall" then
    edge_trap_wall(calc_wall_mat(A, NA))

  elseif info.kind == "sky_edge" and A.floor_h then
    edge_simple_sky()

  elseif info.kind == "fence" then
    straddle_fence()

  elseif info.kind == "steps" then
    edge_steps()

  elseif info.kind == "arch" then
    dummy_arch(S, dir)

  elseif info.kind == "lock_door" then
    straddle_locked_door()

  elseif info.kind == "window" then
    straddle_window()

  end
end



function Render_seed(A, S)
  assert(S.area == A)

  -- get parent seed
  local PS = S
  if S.bottom then PS = S.bottom end

  local bare_brush =
  {
    { x=PS.x1, y=PS.y1, __dir=2 }
    { x=PS.x2, y=PS.y1, __dir=6 }
    { x=PS.x2, y=PS.y2, __dir=8 }
    { x=PS.x1, y=PS.y2, __dir=4 }
  }

  if S.diagonal == 3 then
    bare_brush[3].__dir = 7
    table.remove(bare_brush, 4)
  elseif S.diagonal == 7 then
    bare_brush[1].__dir = 3
    table.remove(bare_brush, 2)
  elseif S.diagonal == 1 then
    bare_brush[2].__dir = 9
    table.remove(bare_brush, 3)
  elseif S.diagonal == 9 then
    bare_brush[4].__dir = 1
    table.remove(bare_brush, 1)
  elseif S.diagonal then
    error("Invalid diagonal seed!")
  end


  if A.mode == "void" or (A.mode == "scenic" and not A.is_outdoor) then
    local w_brush = bare_brush

    brushlib.set_mat(w_brush, A.wall_mat)

    Trans.brush(w_brush)
    return
  end


  local light


local tag  ---##  = sel(A.ceil_mat == "_SKY", 1, 0)
-- if A.room then tag = A.room.id end
-- if A.quest and A.quest.id < 2 then tag = 1 end


  local f_brush = table.deep_copy(bare_brush)
  local c_brush = bare_brush


  -- handle railings [ must be done here ]
  each C in f_brush do
    local info = edge_get_rail(S, C.__dir)
    if info then
      C.rail = assert(info.rail_mat)
      C.v1 = 0
      C.back_rail = C.rail
      C.back_v1 = 0
      C.blocked = info.blocked
    end
  end


  table.insert(f_brush, { t=A.floor_h, light=light, tag=tag })
  table.insert(c_brush, { b=A. ceil_h })

  brushlib.set_mat(f_brush, A.floor_mat, A.floor_mat)
  brushlib.set_mat(c_brush, A. ceil_mat, A. ceil_mat)

  if A.ceil_mat == "_SKY" then
    brushlib.set_kind(c_brush, "sky")
  end

  Trans.brush(f_brush)
  Trans.brush(c_brush)


  -- remember floor brush for the spot logic
  table.insert(A.floor_brushes, f_brush)


  -- walls

  each dir in geom.ALL_DIRS do
    Render_edge(A, S, dir)
  end
end



function Render_area(A)
  -- stairwells are special little butterflies...
  if A.is_stairwell then
    Layout_build_stairwell(A)
    return
  end

  A.floor_brushes = {}
  A.side_edges = {}

  each S in A.seeds do
    Render_seed(A, S)
  end

-- TEST CRUD !!! 
--[[
    if A.mode != "void" then
      local ent_name = rand.pick({"potion", "stimpack", "helmet", "shells", "rocket", "cells", "allmap"});
      each P in A.inner_points do
        Trans.entity(ent_name, P.x1, P.y1, A.floor_h)
      end
    end
--]]
end



function dummy_properties(A)

  if A.mode == "void" then
    A.wall_mat = "BLAKWAL1"
    A.floor_mat = A.wall_mat
    A.facade_mat = "COMPSPAN" --!!!!FIXME  A.zone.facade_mat
    return
  end


  if not A.floor_h then
    A.floor_h = -7
  end

  if A.is_porch then
    A.ceil_h = A.floor_h + 144

  elseif not A.ceil_h then
    A.ceil_h = A.floor_h + 200
  end

--DEBUG
---##  A.kind = "building"
---##  if A.mode != "scenic" then A.mode = "normal" end

  if A.kind == "building" then
    A.wall_mat  = "STARTAN3"
    A.floor_mat = "FLOOR4_8"
    A.facade_mat = "STONE3" --!!!!FIXME  A.zone.facade_mat

  elseif A.kind == "courtyard" then
    A.floor_mat = "BROWN1"

  elseif A.kind == "landscape" then
    A.floor_mat = "RROCK19"

  elseif A.kind == "cave" then
    A.wall_mat  = "ASHWALL4"
    A.floor_mat = "RROCK04"
    A.facade_mat = A.wall_mat

  else
    A.floor_mat = "_ERROR"
  end

  if A.mode == "scenic" and A.kind == "water" then
    assert(A.floor_h)
    A.floor_mat = "FWATER1"

---    elseif A.mode == "scenic" then
---      A.floor_mat = "LAVA1"
---      A.floor_h   = -64

  elseif A.mode == "hallway" then
    A.floor_mat = "FLAT5_1"
    A.wall_mat  = "WOOD1"
    A.ceil_mat  = "WOOD1"

    if not A.is_outdoor then
    A.facade_mat = "STONE3" --!!!!FIXME  A.zone.facade_mat
    end

    if A.is_porch then
      A.ceil_h = A.floor_h + 128
    elseif not A.is_outdoor then
      A.ceil_h = A.floor_h + 80
    end
  end


  if A.mode == "trap" and not A.is_outdoor then
    A.ceil_h = A.floor_h + 144
  end


  if A.is_outdoor and not A.is_porch then
    A.ceil_mat = "_SKY"
  end

  A.wall_mat = A.wall_mat or A.floor_mat
  A.ceil_mat = A.ceil_mat or A.wall_mat

  A.facade_mat = A.facade_mat or A.wall_mat

  --DEBUG FOR SECRETS
  if A.room and A.room.is_secret then
  A.floor_mat = "REDWALL"
  end

  assert(A.wall_mat)
end



function Render_all_areas()
  each A in LEVEL.areas do
    dummy_properties(A)
  end

  each A in LEVEL.areas do
    Render_area(A)
  end
end


------------------------------------------------------------------------


function Render_importants()

  local R  -- the current room


  local function player_dir(spot)
    -- FIXME : analyse all 4 directions, pick one which can see the most
    --         [ or opposite of one which can see the least ]

    local S = Seed_from_coord(spot.x, spot.y)

    if R.sh > R.sw then
      if S.sy > (R.sy1 + R.sy2) / 2 then 
        return 2
      else
        return 8
      end
    else
      if S.sx > (R.sx1 + R.sx2) / 2 then 
        return 4
      else
        return 6
      end
    end
  end


  local function content_big_item(spot, item)
    local fab_name = "Item_pedestal"

    -- FIXME: TEMP RUBBISH
    if string.sub(item, 1, 2) == "kc" or
       string.sub(item, 1, 2) == "ks" then
      fab_name = "Item_podium"
    end

    local def = PREFABS[fab_name]
    assert(def)

    local skin1 = { item=item }

    local T = Trans.spot_transform(spot.x, spot.y, spot.z, spot.dir)

    Fabricate(R, def, T, { skin1 })

    Trans.entity("light", spot.x, spot.y, spot.z+112, { cave_light=176 })
  end


  local function content_very_big_item(spot, item, is_weapon)
--[[  FIXME : LOWERING PEDESTALS

    -- sometimes make a lowering pedestal
    local prob = sel(is_weapon, 40, 20)

    if rand.odds(prob) and
       THEME.lowering_pedestal_skin and
       not S.chunk[2]
    then
      local mx, my = spot.x, spot.y
      local z1 = spot.z

      local z_top

      if R.kind == "cave" then
        z_top = z1 + rand.pick({ 64, 96 })

      else
        local z2 = S.ceil_h or S.room.ceil_h or (z1 + 256)

        if z2 < z1 + 170 then
          z_top = z1 + 64
        else
          z_top = z1 + 128
        end
      end

      Build.lowering_pedestal(S, z_top, THEME.lowering_pedestal_skin)

      Trans.entity(item, mx, my, z_top)
      Trans.entity("light", mx, my, z_top + 24, { cave_light=176 })

      return
    end
--]]

    content_big_item(spot, item)
  end


  local function content_start_pad(spot, dir)
    local def = PREFABS["Start_basic"]
    assert(def)

    local T = Trans.spot_transform(spot.x, spot.y, spot.z, 10 - dir)

    Fabricate(R, def, T, { })
  end


  local function content_coop_pair(spot, dir)
    -- no prefab for this : add player entities directly

    local mx = spot.x
    local my = spot.y
    local  z = spot.z

    local angle = geom.ANGLES[dir]

    local dx, dy = geom.delta(dir)

    dx = dx * 24 ; dy = dy * 24

    Trans.entity(R.player_set[1], mx - dy, my + dx, z, { angle=angle })
    Trans.entity(R.player_set[2], mx + dy, my - dx, z, { angle=angle })

    if GAME.ENTITIES["player8"] then
      mx = mx - dx * 2
      my = my - dy * 2

      Trans.entity(R.player_set[3], mx - dy, my + dx, z, { angle=angle })
      Trans.entity(R.player_set[4], mx + dy, my - dx, z, { angle=angle })
    end
  end


  local function content_start(spot)
    local dir = player_dir(spot)

---???    if OB_CONFIG.game == "quake" then
---???      local skin = { floor="SLIP2", wall="SLIPSIDE" }
---???
---???      Build.quake_exit_pad(S, z1 + 16, skin, LEVEL.next_map)

    if R.player_set then
      content_coop_pair(spot, dir)

--[[
    elseif false and PARAM.raising_start and R.svolume >= 20 and
       R.kind != "cave" and
       THEME.raising_start_switch and rand.odds(25)
    then
      -- TODO: fix this
      gui.debugf("Raising Start made\n")

      local skin =
      {
        f_tex = S.f_tex or R.main_tex,
        switch_w = THEME.raising_start_switch,
      }

      Build.raising_start(S, 6, z1, skin)
      angle = 0

      S.no_floor = true
      S.raising_start = true
      R.has_raising_start = true
--]]
    else

      content_start_pad(spot, dir)
    end
  end


  local function content_exit(spot, secret_exit)
    local fab_name = "Exit_switch"

    if secret_exit then fab_name = "Exit_pillar_secret" end

    local def = PREFABS[fab_name]
    assert(def)

    local skin1 = { }

    local dir = spot.dir or 2

    local T = Trans.spot_transform(spot.x, spot.y, spot.z, 10 - dir)

    Fabricate(R, def, T, { skin1 })
  end


  local function content_switch(spot)
    -- TODO: find it properly
    local fab_name = "Switch_small_" .. spot.goal.item

    local def = PREFABS[fab_name]
    assert(def)

    local skin1 = { }

    skin1.lock_tag = assert(spot.goal.tag)

    if spot.goal.special then
      skin1.special = spot.goal.special
    end

    local T = Trans.spot_transform(spot.x, spot.y, spot.z, spot.dir)

    Fabricate(R, def, T, { skin1 })
  end


  local function content_weapon(spot)
    local weapon = assert(spot.content_item)

    if R.is_start or R.is_hallway then
      -- bare item
      Trans.entity(weapon, spot.x, spot.y, spot.z)
    else
      content_very_big_item(spot, weapon, "is_weapon")
    end

    gui.debugf("Placed weapon '%s' @ (%d,%d,%d)\n", weapon, spot.x, spot.y, spot.z)
  end


  local function content_item(spot)
    local item = assert(spot.content_item)

    if R.is_start or R.is_hallway then
      -- bare item
      Trans.entity(item, spot.x, spot.y, spot.z)
    else
      content_big_item(spot, item)
    end
  end


  local function content_flag(spot)
    -- TODO : prefab for flag base

    content_big_item(spot, assert(spot.item))
  end


  local function content_teleporter(spot)
    local C = assert(spot.conn)

    local def = PREFABS["Teleporter1"]
    assert(def)

    local skin1 = {}

    if C.A1.room == R then
      skin1. in_tag = C.tele_tag2
      skin1.out_tag = C.tele_tag1
    else
      skin1. in_tag = C.tele_tag1
      skin1.out_tag = C.tele_tag2
    end

    skin1. in_target = string.format("tele%d", skin1. in_tag)
    skin1.out_target = string.format("tele%d", skin1.out_tag)

    local spot_dir = 2  --!!! FIXME  10 - dir_for_wotsit(S)

    local T = Trans.spot_transform(spot.x, spot.y, spot.z, spot_dir)

    Fabricate(R, def, T, { skin1 })
  end


  local function build_important(spot)
    if spot.content_kind == "START" then
      content_start(spot)

    elseif spot.content_kind == "LEVEL_EXIT" then
      content_exit(spot)

    elseif spot.content_kind == "SECRET_EXIT" then
      content_exit(spot, "secret_exit")

    elseif spot.content_kind == "KEY" then
      content_very_big_item(spot, assert(spot.item))

    elseif spot.content_kind == "SWITCH" then
      content_switch(spot)

    elseif spot.content_kind == "WEAPON" then
      content_weapon(spot)

    elseif spot.content_kind == "ITEM" then
      content_item(spot)

    elseif spot.content_kind == "FLAG" then
      content_flag(spot)

    elseif spot.content_kind == "TELEPORTER" then
      content_teleporter(spot)
    else
      error("unknown important: " .. tostring(spot.content_kind))
    end
  end


  local function build_trigger(spot)
    local r = spot.trigger.r

    local special = assert(spot.trigger.special)
    local tag     = assert(spot.trigger.tag)

    local brush = brushlib.quad(spot.x - r, spot.y - r, spot.x + r, spot.y + r)

    each C in brush do
      C.special = special
      C.tag     = tag
    end

    brushlib.set_kind(brush, "trigger")

    Trans.brush(brush)
  end


  ---| Render_importants |---

  each room in LEVEL.rooms do
    R = room

    each spot in R.importants do
      build_important(spot)

      if spot.trigger then
        build_trigger(spot)
      end
    end
  end
end

