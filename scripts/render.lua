------------------------------------------------------------------------
--  RENDER : CONSTRUCT AREAS
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2008-2014 Andrew Apted
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


function dummy_fence_or_wall(S, dir, mat, fence_h)
  local TK = 16

  local x1 = S.x1
  local y1 = S.y1
  local x2 = S.x2
  local y2 = S.y2

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

  if fence_h then
    table.insert(brush, { t=fence_h })
  end

  brushlib.set_mat(brush, mat, mat)

  Trans.brush(brush)
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



function build_edge(A, S, dir)

  local bord = S.border[dir]
  local LOCK = bord.lock


  local function do_keyed_door()
    local z = A.floor_h

    assert(LOCK)

---!!!    local o_tex = outer_tex(S, dir, w_tex)
---!!!    local skin1 = { wall=w_tex, floor=f_tex, outer=o_tex }

    local skin1 = { }


    -- FIXME : find it properly
    local fab_name = "Locked_" .. LOCK.item

    local def


    if geom.is_corner(dir) then
      fab_name = fab_name .. "_diag"

      local def = PREFABS[fab_name]
      assert(def)

      local DIR_MAP = { [1]=2, [9]=8, [3]=4, [7]=6 }
      local dir2 = DIR_MAP[dir]

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


  local function do_locked_door()
    assert(LOCK)

    if LOCK.item then
      do_keyed_door()
      return
    end

    error("WTF : switched door")

--[[  TODO

    local z = assert(S.conn and S.conn.conn_h)

    -- FIXME : find it properly
    local fab_name = "Door_with_bars" --!!! Door_SW_blue

    local def = PREFABS[fab_name]
    assert(def)

    local o_tex = outer_tex(S, dir, w_tex)
    local skin1 = { wall=w_tex, floor=f_tex, outer=o_tex }

    skin1.lock_tag = LOCK.tag

    local S2 = S
    local seed_w = 1

    local T = Trans.edge_transform(S.x1, S.y1, S2.x2, S2.y2, z,
                                   dir, 0, seed_w * 192, def.deep, def.over)

    Fabricate(R, def, T, { skin1 })

    do_door_base(S, dir, z, w_tex, o_tex)
--]]
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


  ---| build_edge |---

  local N = S:diag_neighbor(dir, "NODIR")

  if N == "NODIR" then return end

  -- edge of map  :  FIXME
  if not (N and N.area) then return end

  -- same area ?   nothing needed
  if N.area == S.area then return end

  local NA = N.area


  add_edge_line()


  local same_room = (N.room and N.room == S.room)

  if bord.kind == "arch" then
    dummy_arch(S, dir)

  elseif bord.kind == "lock_door" then
    do_locked_door()

  elseif bord.kind == "straddle" then
    -- nothing

--!!!!    elseif A.mode == "hallway" or
--!!!!        (rand.odds(80) and (A.kind == "building" or A.kind == "cave"))
--!!!!    then
  
  elseif A.mode == "scenic" and A.is_outdoor then
    -- nothing

  elseif A.is_outdoor and NA and NA.mode == "scenic" and NA.kind == "water" then
    -- nothing

  elseif not same_room then
    dummy_fence_or_wall(S, dir, A.wall_mat)
    
  else
--!!!      dummy_fence_or_wall(S, dir, A.wall_mat, A.floor_h + 8)
  end
end



function dummy_sector(A, S)
  assert(S.area == A)

  -- get parent seed
  local PS = S
  if S.bottom then PS = S.bottom end

  local bare_brush =
  {
    { x=PS.x1, y=PS.y1 }
    { x=PS.x2, y=PS.y1 }
    { x=PS.x2, y=PS.y2 }
    { x=PS.x1, y=PS.y2 }
  }

  if S.diagonal == 3 then
    table.remove(bare_brush, 4)
  elseif S.diagonal == 7 then
    table.remove(bare_brush, 2)
  elseif S.diagonal == 1 then
    table.remove(bare_brush, 3)
  elseif S.diagonal == 9 then
    table.remove(bare_brush, 1)
  elseif S.diagonal then
    error("Invalid diagonal seed!")
  end


  if A.mode == "void" then
    local w_brush = bare_brush

    brushlib.set_mat(w_brush, "BLAKWAL1")

    Trans.brush(w_brush)
    return
  end


  local light = 160
  if A.ceil_mat == "_SKY" then light = 192 end


local tag  ---##  = sel(A.ceil_mat == "_SKY", 1, 0)
if A.room then tag = A.room.id end


  local f_brush = table.deep_copy(bare_brush)
  local c_brush = bare_brush

  table.insert(f_brush, { t=A.floor_h, tag=tag })
  table.insert(c_brush, { b=A. ceil_h, light=light })

  brushlib.set_mat(f_brush, A.floor_mat, A.floor_mat)
  brushlib.set_mat(c_brush, A. ceil_mat, A. ceil_mat)

  Trans.brush(f_brush)
  Trans.brush(c_brush)


  -- remember floor brush for the spot logic
  table.insert(A.floor_brushes, f_brush)


  -- walls

  each dir in geom.ALL_DIRS do
    build_edge(A, S, dir)
  end
end



function Render_area(A)
  A.floor_brushes = {}
  A.side_edges = {}

  each S in A.half_seeds do
    dummy_sector(A, S)
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
    if not A.floor_h then
      A.floor_h = -7
    end

    if not A.ceil_h then
      A.ceil_h = A.floor_h + 200
    end

--DEBUG
---##  A.kind = "building"
---##  if A.mode != "scenic" then A.mode = "normal" end

    if A.kind == "building" then
      A.wall_mat  = "STARTAN3"
      A.floor_mat = "FLOOR4_8"

    elseif A.kind == "courtyard" then
      A.floor_mat = "BROWN1"

    elseif A.kind == "landscape" then
      A.floor_mat = "RROCK19"

    elseif A.kind == "cave" then
      A.wall_mat  = "ASHWALL4"
      A.floor_mat = "RROCK04"

    else
      A.floor_mat = "CRACKLE2"
    end

    if A.mode == "scenic" and A.kind == "water" then
      assert(A.floor_h)
      A.floor_mat = "FWATER1"

    elseif A.mode == "scenic" then
      A.floor_mat = "LAVA1"
      A.floor_h   = -64

    elseif A.mode == "hallway" then
      A.ceil_h = A.floor_h + 72
      A.floor_mat = "FLAT5_1"
      A.wall_mat  = "WOOD1"
      A.ceil_mat  = "WOOD1"

    elseif A.mode == "water" then
      A.floor_h = -8
      A.floor_mat = "FWATER1"

    end

    if A.is_outdoor then
      A.ceil_mat = "_SKY"
      A.ceil_h   = 512
    end

    A.wall_mat = A.wall_mat or A.floor_mat
    A.ceil_mat = A.ceil_mat or A.wall_mat
end



function Render_all_areas()
  each A in LEVEL.areas do
    dummy_properties(A)

    Render_area(A)
  end
end

