----------------------------------------------------------------
--  CHUNKY STUFF
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2011-2012 Andrew Apted
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

--[[ *** CLASS INFORMATION ***

class CHUNK
{
  sx1, sy1, sx2, sy2  -- seed range

  x1, y1, x2, y2  -- 2D map coordinates

  room : ROOM
  hall : HALLWAY

  section : SECTION
  hx, hy  --  coordinates of chunk in section

  area : AREA

  content : table   -- kind field can be: "START", "EXIT", "KEY", "SWITCH",
                    --                    "WEAPON", "TELEPORTER", "GATE"

  link[DIR] : LINK

  parts[DIR] : PART  -- divides the chunk into 3x3 sub-areas
                     -- 2/4/6/8 directions are edges
                     -- 1/3/7/9 directions are corners
                     -- each can be NIL if nothing is there
                     -- edges may occupy whole side (no corner then)

  stair : STAIR

  liquid : bool

  hall_link[dir] : CHUNK   -- non-nil means this hallway chunk is
                           -- connected to another chunk in same hall
                           -- (other conns are handled by link[])

  crossover_hall : HALLWAY

  max_deep[DIR]   -- the maximum distance an edge (or corner) prefab can
                  -- intrude into this chunk.

  floor_h, ceil_h -- floor and ceiling heights

  f_tex,   c_tex  -- floor and ceiling textures

  z_low, z_high   -- vertical range of chunk
                  -- if absent, assume chunk requires whole Z range

  prefabs  -- list of prefabs which touch this chunk
           -- (only need ones which affect monster / item placement)
}


class PART
{
  chunk, side   -- identification

  x1, y1, x2, y2   -- coverage on 2D map

  fab  -- a prefab which fills the whole 2d area
}


--------------------------------------------------------------]]


CHUNK_CLASS = {}

function CHUNK_CLASS.new(sx1, sy1, sx2, sy2)
  local C =
  {
    sx1=sx1, sy1=sy1
    sx2=sx2, sy2=sy2
    
    content = {}
    parts = {}
    link = {}
    prefabs = {}
  }
  table.set_class(C, CHUNK_CLASS)
  return C
end


function CHUNK_CLASS.tostr(C)
  return string.format("CHUNK [%d,%d]", C.sx1, C.sy1)
end


function CHUNK_CLASS.set_coords(C)
  local S1 = SEEDS[C.sx1][C.sy1]
  local S2 = SEEDS[C.sx2][C.sy2]

  C.x1, C.y1 = S1.x1, S1.y1
  C.x2, C.y2 = S2.x2, S2.y2
end


function CHUNK_CLASS.install(C)
  for sx = C.sx1, C.sx2 do for sy = C.sy1, C.sy2 do
    local S = SEEDS[sx][sy]
    assert(S)

    -- verify not already allocated
    if S.chunk then
      error("tried to allocate overlapping chunks!")
    end

    S.chunk = C

    table.insert(S.chunks, C)
  end end

  C:set_coords()
end


function CHUNK_CLASS.long_deep(C, dir)
  return geom.long_deep(C.x2 - C.x1, C.y2 - C.y1, dir)
end


function CHUNK_CLASS.joining_chunks(C, dir)
  local list = {}

  local sx1, sy1, sx2, sy2 = geom.side_coords(dir, C.sx1, C.sy1, C.sx2, C.sy2)

  sx1, sy1 = geom.nudge(sx1, sy1, dir)
  sx2, sy2 = geom.nudge(sx2, sy2, dir)

  for sx = sx1,sx2 do for sy = sy1,sy2 do
    local S = SEEDS[sx][sy]

    if S and S.chunk and not table.has_elem(list, S.chunk) then
      table.insert(list, S.chunk)
    end
  end end

  return list
end


function CHUNK_CLASS.lower_area_can_fence(C, dir)
  assert(C.area)

  local sx1, sy1, sx2, sy2 = geom.side_coords(dir, C.sx1, C.sy1, C.sx2, C.sy2)

  sx1, sy1 = geom.nudge(sx1, sy1, dir)
  sx2, sy2 = geom.nudge(sx2, sy2, dir)

  for sx = sx1,sx2 do for sy = sy1,sy2 do
    local S = SEEDS[sx][sy]

    if S.room != C.room then return false end

    each C2 in S.chunks do
      if C2.floor_h >= C.floor_h then return false end

      if C2.stair and C2.stair.dir == (10 - dir) then return false end
    end
  end end

  return true
end


function CHUNK_CLASS.mid_point(C)
  return int((C.x1 + C.x2) / 2), int((C.y1 + C.y2) / 2)
end


function CHUNK_CLASS.seed_volume(C)
  return (C.sx2 - C.sx1 + 1) * (C.sy2 - C.sy1 + 1)
end


function CHUNK_CLASS.side_len(C, dir)
  return geom.vert_sel(dir, C.x2 - C.x1, C.y2 - C.y1)
end


function CHUNK_CLASS.is_adjacent(C1, C2)
  if C1.sx1 > (C2.sx2 + 1) then return false end
  if C1.sx2 < (C2.sx1 - 1) then return false end

  if C1.sy1 > (C2.sy2 + 1) then return false end
  if C1.sy2 < (C2.sy1 - 1) then return false end

  -- only touches at a corner?
  if (C1.sx1 > C2.sx2 or C1.sx2 < C2.sx1) and
     (C1.sy1 > C2.sy2 or C1.sy2 < C2.sy1)
  then return false end 

  return true
end


function CHUNK_CLASS.good_neighbor(C1, dir)
  -- a 'good' neighbor is one which is at least the same size as
  -- the current chunk (can be bigger, but not smaller).
  -- If such a chunk exists on the given side, return it,
  -- otherwise returns NIL.

  local nx, ny = C1.sx1, C1.sy1

  if dir == 2 then ny = C1.sy1 - 1 end
  if dir == 8 then ny = C1.sy2 + 1 end
  if dir == 4 then nx = C1.sx1 - 1 end
  if dir == 6 then nx = C1.sx2 + 1 end

  if not Seed_valid(nx, ny) then return nil end

  local C2 = SEEDS[nx][ny].chunk

  if not C2 then return nil end

  if geom.is_vert(dir) then
    if C2.x1 <= C1.x1 and C2.x2 >= C1.x2 then return C2 end
  else
    if C2.y1 <= C1.y1 and C2.y2 >= C1.y2 then return C2 end
  end

  return nil
end


function CHUNK_CLASS.middle_neighbor(C1, dir)
  -- returns the neighbor that touches the middle seed on the given side.
  -- If there is an even number of seeds, then only one of the middle
  -- pair of seeds is checked (which one is undefined).

  local nx = math.i_mid(C1.sx1, C1.sx2)
  local ny = math.i_mid(C1.sy1, C1.sy2)

  if dir == 2 then ny = C1.sy1 - 1 end
  if dir == 8 then ny = C1.sy2 + 1 end
  if dir == 4 then nx = C1.sx1 - 1 end
  if dir == 6 then nx = C1.sx2 + 1 end

  if not Seed_valid(nx, ny) then return nil end

  return SEEDS[nx][ny].chunk
end


function CHUNK_CLASS.classify_edge(C, dir)
  local sx1, sy1, sx2, sy2 = geom.side_coords(dir, C.sx1, C.sy1, C.sx2, C.sy2)

  sx1, sy1 = geom.nudge(sx1, sy1, dir)
  sx2, sy2 = geom.nudge(sx2, sy2, dir)

  if not Seed_valid(sx1, sy1) then return "wall" end

  local has_liquid
  local diff_area

  for sx = sx1,sx2 do for sy = sy1,sy2 do
    local S = SEEDS[sx][sy]

    if S.room != C.room then return "wall" end
    if S.hall != C.hall then return "wall" end

    local C2 = S.chunk

    if not C2 then return "wall" end
    if C2.scenic then return "wall" end

    if C2.liquid then has_liquid = true end

    if C.area != C2.area then diff_area = true end
  end end

  if has_liquid then return "liquid" end

  if diff_area then return "diff" end

  return "same"
end


function CHUNK_CLASS.neighbor_info(C, dir, info, sky_only)
  local sx1, sy1, sx2, sy2 = geom.side_coords(dir, C.sx1, C.sy1, C.sx2, C.sy2)

  sx1, sy1 = geom.nudge(sx1, sy1, dir)
  sx2, sy2 = geom.nudge(sx2, sy2, dir)

  if not Seed_valid(sx1, sy1) then return nil end

  local touch_sky

  for sx = sx1,sx2 do for sy = sy1,sy2 do
    local N = SEEDS[sx][sy].chunk

    if not N then N = SEEDS[sx][sy].chunks[1] end

    if not N then return nil end

    if N.room and N.room.kind == "outdoor" then
      info.sky = true
      touch_sky = true
    elseif sky_only then
      continue
    end

    if N.floor_h then info.f_min = math.min(info.f_min or  9999, N.floor_h) end
    if N.floor_h then info.f_max = math.max(info.f_max or -9999, N.floor_h) end

    local ceil_h = N.ceil_h or (N.room and N.room.sky_group and N.room.sky_group.h)

    if ceil_h then info.c_min = math.min(info.c_min or  9999, ceil_h) end
    if ceil_h then info.c_max = math.max(info.c_max or -9999, ceil_h) end
  end end

  return touch_sky
end


function CHUNK_CLASS.need_fence(C, dir)
  assert(C.room)

  local sx1, sy1, sx2, sy2 = geom.side_coords(dir, C.sx1, C.sy1, C.sx2, C.sy2)

  sx1, sy1 = geom.nudge(sx1, sy1, dir)
  sx2, sy2 = geom.nudge(sx2, sy2, dir)

  if not Seed_valid(sx1, sy1) then return false end

  for sx = sx1,sx2 do for sy = sy1,sy2 do
    local S = SEEDS[sx][sy]

    if S.room and S.room.kind == "outdoor" and S.room != C.room then
      local fence = C.room.fences[S.room.id]

      if fence then return true end
    end

  end end

  return false
end


function CHUNK_CLASS.quad_for_edge(C, dir, thick)
  local x1, y1 = C.x1, C.y1
  local x2, y2 = C.x2, C.y2

  if dir == 2 then y2 = y1 + thick end
  if dir == 8 then y1 = y2 - thick end
  if dir == 4 then x2 = x1 + thick end
  if dir == 6 then x1 = x2 - thick end

  return Brush_new_quad(x1, y1, x2, y2)
end


function CHUNK_CLASS.get_street_sky_h(C, dir)
  local sx1, sy1 = geom.side_coords(dir, C.sx1, C.sy1, C.sx2, C.sy2)

  sx1, sy1 = geom.nudge(sx1, sy1, dir)

  if Seed_valid(sx1, sy1) then
    local S = SEEDS[sx1][sy1]
    if S.room then return S.room.street_inner_h end
  end

  return 64
end


function CHUNK_CLASS.bridge_pos(C, dir)
  local sx, sy

  if geom.is_vert(dir) then
    sx = rand.irange(C.sx1, C.sx2)
    sy = (dir == 2 ? C.sy1 - 1 ; C.sy2 + 1)
  else
    sx = (dir == 4 ? C.sx1 - 1 ; C.sx2 + 1)
    sy = rand.irange(C.sy1, C.sy2)
  end

  return sx, sy
end


function CHUNK_CLASS.has_locked_door(C)
  for dir = 2,8,2 do
    local LINK = C.link[dir]

    if LINK and LINK.conn and LINK.conn.lock then
      return true
    end
  end

  return false
end


function CHUNK_CLASS.has_parallel_stair(C, dir)
  if C.stair and geom.is_parallel(C.stair.dir, dir) then
    return true
  end

  return false
end


function CHUNK_CLASS.has_walk(C)
  for sx = C.sx1, C.sx2 do for sy = C.sy1, C.sy2 do
    local S = SEEDS[sx][sy]
    if S.is_walk then return true end
  end end

  return false
end


function CHUNK_CLASS.eval_camera(C)
  -- no cameras in the void (or cages etc)
  if not C.area or not C.ceil_h then return nil end

  local info = { chunk=C }

  info.x1 = (C.x1 + C.x2) / 2
  info.y1 = (C.y1 + C.y2) / 2
  info.z1 = C.ceil_h * 0.75 + C.floor_h * 0.25

  -- FIXME: test a range of angles or spots

  local R = assert(C.room)

  local mid_x, mid_y = R:mid_point()

  local dist = geom.dist(info.x1, info.y1, mid_x, mid_y)
  if dist < 70 then return nil end

  info.x2 = mid_x
  info.y2 = mid_y
  info.z2 = R.min_floor_h - 64

  info.score = dist + gui.random() * 200

  return info
end


----------------------------------------------------------------


function CHUNK_CLASS.similar_neighbor(C, dir)
  local sx, sy

  local mx = int((C.sx1 + C.sx2) / 2)
  local my = int((C.sy1 + C.sy2) / 2)

      if dir == 2 then sx, sy = mx, C.sy1 - 1
  elseif dir == 8 then sx, sy = mx, C.sy2 + 1
  elseif dir == 4 then sx, sy = C.sx1 - 1, my
  elseif dir == 6 then sx, sy = C.sx2 + 1, my
  end

  if not Seed_valid(sx, sy) then
    return false
  end

  local S = SEEDS[sx][sy]
  local C2 = S.chunk

--do return (S and (S.room or S.hall)) end --!!!!!!!1

  if C2 and C.hall and C.hall == C2.hall and 
     C.section and C2.section and (C.section.forky != C2.section.forky) and
     C.section  != C.hall.double_fork and
     C2.section != C.hall.double_fork
  then return false end

  if C2 and C.hall and C.hall == C2.hall and C.hall.crossover and
     C.section and
     ( C.section == C.hall.crossover.MID_B or
      C2.section == C.hall.crossover.MID_B)
     and not geom.is_parallel(dir, C.hall.crossover.dir)
  then return false end

  if C.hall then return (S.hall == C.hall) end
  if C.room then return (S.room == C.room) end

  return false
end



function CHUNK_CLASS.inner_outer_mat(C, L1, L2)
  assert(L1)
  assert(L2)

  assert(L1.wall_mat)
  assert(L2.wall_mat)

  local skin2 = { wall = L1.wall_mat, outer = L2.wall_mat }

  if L1.kind == "outdoor" then skin2.wall  = L2.zone.facade_mat end
  if L2.kind == "outdoor" then skin2.outer = L1.zone.facade_mat end

  return skin2
end


function CHUNK_CLASS.build_wall(C, dir, f_h, c_h)
  local L = assert(C.room or C.hall)

  local long = geom.vert_sel(dir, C.x2 - C.x1, C.y2 - C.y1)
  local deep = 32

  local T = Trans.edge_transform(C.x1, C.y1, C.x2, C.y2, f_h, dir,
                                 0, long, deep, 0)

  local skin = (C.room and C.room.skin) or (C.hall and C.hall.skin)
  assert(skin)

  skin.outer = assert(skin.facade)

  -- WINDOWS !!!!
  local info = { f_max = f_h, c_min = c_h }

  if C:neighbor_info(dir, info, "sky_only") and
     info.c_min - info.f_max >= 64
  then
--???    Trans.set_fitted_z(T, info.f_max, info.c_min)

--[[
    -- FIXME: big hack !!!!!
    if (OB_CONFIG.game == "heretic" or OB_CONFIG.game == "hexen") and C.room and C.room.zone.fake_windows 
       and info.c_min - info.f_max >= 200
    then
      local skin2 = { pic="STNGLS1", pic_w=128, pic_h=128 }
      Fabricate_old("PICTURE_WINDOW", T, { skin, skin2 })
      return
    elseif LEVEL.special != "street" or rand.odds(31) then
      local skin0 = GAME.SKINS["Window1"]
      assert(skin0)
      Fabricate(skin0, T, { skin })
      return
    end
--]]
  end

  -- walls and windows use an "XYZ" fitted transform
---!!!  Trans.set_fitted_z(T, f_h, c_h)

  -- PICTURES!!!
  local pic_prob = style_sel("pictures", 0, 25, 50, 80)
  if c_h >= f_h + 128 and C.area and C.area.pic_name and rand.odds(pic_prob) then
    local skin2 = GAME.SKINS[C.area.pic_name]
    if not skin2 then
      error("No such picture skin: " .. tostring(C.area.pic_name))
    end

    Fabricate_at(L, skin2, T, { skin, skin2 })
    return
  end

  local skin2 = GAME.SKINS["Wall_plain"]
  assert(skin2)

  Fabricate_at(L, skin2, T, { skin })
end


function CHUNK_CLASS.build_fence(C, dir, low_fence)
  local L = assert(C.room or C.hall)

  local long = geom.vert_sel(dir, C.x2 - C.x1, C.y2 - C.y1)
  local deep = 16

  local fence_h  -- Note: bottom of the fence

  if low_fence then
    fence_h = C.area.floor_h + 8
  else
    fence_h = C.room.max_floor_h + PARAM.jump_height
  end

  local T = Trans.edge_transform(C.x1, C.y1, C.x2, C.y2, fence_h, dir,
                                 0, long, deep, 0)

  local skin1 = assert(GAME.SKINS["Fence1"])
  local skin2 = assert(C.room.skin)

  Fabricate_at(L, skin1, T, { skin2 })
end


function CHUNK_CLASS.build_scenic(C)
--[[  NOT USED ATM

  if C.prefab_skin then
    local skin0 = {}

    local skin1 = C.prefab_skin
    local skin2 = C.prefab_skin2

    local T = Trans.box_transform(C.x1, C.y1, C.x2, C.y2, C.floor_h or 0, C.prefab_dir or 2)

    Fabricate(skin1, T, { skin0, skin1, skin2 })

  else
    -- plain solid quad

    local brush = Brush_new_quad(C.x1, C.y1, C.x2, C.y2)

    local def_mat = "_ERROR"
    
    if C.room then
      def_mat = C.room.wall_mat or def_mat
    end

    Brush_set_mat(brush, C.mat or def_mat)

    brush_helper(brush)
  end
--]]
end


function CHUNK_CLASS.build_door(C, dir, LINK, f_h, c_h, long)
  local lock = LINK.conn.lock

  local C2 = LINK.C2
  local L2 = C2.room or C2.hall
  local L1 = C .room or C .hall
  assert(L1)
  assert(L2)

  local env =
  {
    room_kind  = L1.kind
    room2_kind = L2.kind
  }

  local reqs =
  {
    kind  = "door"
    where = "edge"
    -- long = long
    key    = lock.key
    switch = lock.switch
  }

--[[
  if ( C.hall and  C.hall.group.narrow) or
     (C2.hall and C2.hall.group.narrow)
  then
    reqs.narrow = 1
  end
--]]

  local skin = Room_pick_skin(env, reqs)

  local skin2 = C:inner_outer_mat(L1, L2)

  local T = Trans.edge_transform(C.x1, C.y1, C.x2, C.y2, f_h, dir,
                                 0, long, skin.deep or 48, 0)

  if lock.kind == "KEY" then
    -- Quake II bits
    skin2.keyname = lock.key
    skin2.targetname = "door" .. Plan_alloc_id("door")

  elseif lock.kind == "SWITCH" then
    skin2.tag_1 = lock.tag
    skin2.targetname = string.format("switch%d", skin2.tag_1)

  else
    error("Unknown lock kind: " .. tostring(lock.kind))
  end

  Fabricate_at(L1, skin, T, { skin, skin2 })
end


function CHUNK_CLASS.categorize_hall_piece(C)
  local cat, dir = Trans.categorize_linkage(
      C.link[2] or C.hall_link[2], C.link[4] or C.hall_link[4],
      C.link[6] or C.hall_link[6], C.link[8] or C.hall_link[8]);

  assert(cat != "N" and cat != "F")

  return cat, dir
end


function CHUNK_CLASS.categorize_floor_piece(C)
  local highers = {}

  local A = C.area

  if not (A and A.floor_h) then return "N", 2 end

  local N1 = SEEDS[C.sx1][C.sy2 + 1]
  local S1 = SEEDS[C.sx1][C.sy1 - 1]
  local E1 = SEEDS[C.sx2 + 1][C.sy1]
  local W1 = SEEDS[C.sx1 - 1][C.sy1]

  N1 = (N1 ? N1:first_chunk() ; nil)
  S1 = (S1 ? S1:first_chunk() ; nil)
  E1 = (E1 ? E1:first_chunk() ; nil)
  W1 = (W1 ? W1:first_chunk() ; nil)

  N1 = (N1 ? N1.area ; nil)
  S1 = (S1 ? S1.area ; nil)
  E1 = (E1 ? E1.area ; nil)
  W1 = (W1 ? W1.area ; nil)

  N1 = (N1 ? N1.floor_h ; nil)
  S1 = (S1 ? S1.floor_h ; nil)
  E1 = (E1 ? E1.floor_h ; nil)
  W1 = (W1 ? W1.floor_h ; nil)

  N1 = (N1 ? N1 > A.floor_h ; nil)
  S1 = (S1 ? S1 > A.floor_h ; nil)
  E1 = (E1 ? E1 > A.floor_h ; nil)
  W1 = (W1 ? W1 > A.floor_h ; nil)

  local cat, dir = Trans.categorize_linkage(S1, W1, E1, N1)

  if cat == "F" then cat = "E" end
  if cat == "N" then cat = "O" end
  if cat == "T" then cat = "O" end -- not supported yet

  dir = 10 - dir

  return cat, dir
end


function CHUNK_CLASS.build(C)

do return end  -- RIP chunks


  if C.scenic then
    C:build_scenic()
    return
  end

  assert(not C.hall)
  assert(not C.closet)


  local f_h
  local c_h
  local c_medium = "solid"
  local light = 0
  local f_special

  local x_hall = C.crossover_hall

  if C.cross_junc then
    f_h = x_hall.floor_h
    x_hall = nil
  elseif C.liquid then
    f_h = C.room.min_floor_h - (PARAM.deep_liquids ? 96 ; 24)
  else
    f_h = assert(C.floor_h)
  end

  c_h = (C.area and C.area.ceil_h) or C.ceil_h or ((C.bridge_h or f_h) + 128 - 16)

  if x_hall then
    if x_hall.cross_mode == "channel" then f_h = x_hall.floor_h end
    if x_hall.cross_mode == "bridge"  then c_h = math.max(c_h, x_hall.floor_h + 192) end
  end

  assert(f_h)
  assert(c_h)

  local brush
  local w_mat, w_tex
  local f_mat, f_tex
  local c_mat, c_tex

  local x1, y1 = C.x1, C.y1
  local x2, y2 = C.x2, C.y2


  if C.room then
    w_mat = assert(C.room.wall_mat)
    f_mat = (C.area ? C.area.floor_mat ; w_mat)
    c_mat = C.room:pick_ceil_mat()

    if f_h == -777 then
      f_mat = "RROCK01"
    end

  else
    error("Chunk not in a room!")
  end

  if (C.room and C.room.kind == "outdoor") or (C.hall and C.hall.outdoor) then
    c_mat = "_SKY"
    c_medium = "sky"
    if C.room then
      c_h = assert(C.room.sky_group.h)
    end

  else
    light = rand.irange(100, 200)
    if C.hall then light = light * 0.5 end
  end

  -- raise ceiling height to account for crossovers
  -- FIXME: this logic belongs elsewhere
  if C.room and C.room.crossover_hall then
    if c_h < C.room.crossover_hall.max_floor_h + 128 then
       c_h = C.room.crossover_hall.max_floor_h + 128
    end
  end


  if C.liquid then
    if PARAM.deep_liquids then
      local brush = Brush_new_quad(C.x1, C.y1, C.x2, C.y2, nil, f_h + 80)

      Brush_set_mat(brush, "_LIQUID", "_LIQUID")

      table.insert(brush, 1, { m="liquid", medium=LEVEL.liquid.medium })

      brush_helper(brush)

      -- TODO: lighting

      -- add some fireballs
      local fb_prob = 50
      if C.room and C.room.liquid_count then
        fb_prob = 140 / math.sqrt(C.room.liquid_count)
      end

      if LEVEL.liquid.fireballs and rand.odds(fb_prob) then
        local mx, my = C:mid_point()
        local speed = rand.pick { 200,300,350,450 }
        entity_helper("fireball", mx, my, f_h + 80 - 32, { speed=speed })
      end
    else
      f_mat = LEVEL.liquid.mat
      if OB_CONFIG.game != "hexen" then
        f_special = LEVEL.liquid.special
      end
    end
  end


  -- floor

  local f_matname = f_mat

  if C.no_floor then
    -- do nothing (e.g. caves)

--[[  NOT USED
  elseif C.floor_prefab then
    local T = Trans.box_transform(C.x1, C.y1, C.x2, C.y2, f_h)
    local skin1 = GAME.SKINS[C.floor_prefab]
    local skin0 = { floor=f_matname }

    Fabricate(skin1, T, { skin0, skin1 })

  elseif C.stair and false then
    local skin = C.stair.skin

    local skin0 = { side=f_matname, step=f_matname, top=f_matname, floor=f_matname, wall=f_matname }

    local low_h  = C.stair.low_h
    local high_h = C.stair.high_h
    local dir    = C.stair.dir

    assert(high_h > low_h)

    local skin2 = { stair_h = high_h - low_h }

    local T = Trans.box_transform(C.x1, C.y1, C.x2, C.y2, low_h, dir)

---## stderrf("STAIR STUFF: dir:%d h1:%d h2:%d delta:%d scale_z:%1.4f\n",
---##   C.stair.dir, C.stair.C1.floor_h, C.stair.C2.floor_h, delta_h, T.scale_z)

    Fabricate(skin, T, { skin0, skin, skin2 })
--]]


--!!!! TESTINK STUFF
  elseif OB_CONFIG.trim_floor then  

    local cat, dir = C:categorize_floor_piece()

    local T = Trans.box_transform(C.x1, C.y1, C.x2, C.y2, f_h, dir)

    local name = "floor/trimmed_" .. string.lower(cat) .. ".wad"

    local fab = Fab_load_from_wad(name)
    fab.state = "skinned"
    fab.fitted = "xy"

    Fab_transform_XY(fab, T)
    Fab_transform_Z (fab, T)
    Fab_render(fab)


  elseif not (C.room and C.room.kind == "cave") then
    f_mat = Mat_lookup(f_matname)
    f_tex = f_mat.f or f_mat.t

    local sub_x = (C.sx2 - C.sx1 + 1) * 4;
    local sub_y = (C.sy2 - C.sy1 + 1) * 4;

    for dx = 0,sub_x-1 do for dy = 0,sub_y-1 do
      local x1 = C.x1 + dx * 64
      local y1 = C.y1 + dy * 64

      brush = Brush_new_quad(x1, y1, x1 + 64, y1 + 64)

      Brush_set_tex(brush, f_mat.t)

      table.insert(brush, { t=f_h, tex=f_tex, special=f_special })

      if C.z1_cap then
        table.insert(brush, { b=C.z1_cap, tex=f_tex })
      end

      raw_add_brush(brush)
    end end
  end


  -- ceiling

  local c_matname = c_mat
  c_mat = Mat_lookup(c_matname)
  c_tex = c_mat.f or c_mat.t

  if C.no_ceil then
    -- do nothing (e.g. caves)

  else
    brush = Brush_new_quad(C.x1, C.y1, C.x2, C.y2)

    if c_medium == "sky" then
      table.insert(brush, 1, { m="sky" })
    end

    Brush_set_tex(brush, c_mat.t)

    table.insert(brush, { b=c_h, tex=c_tex })

    if C.z2_cap then
      table.insert(brush, { t=C.z2_cap, tex=f_tex })
    end

    brush_helper(brush)
  end


  if not C.ceil_h then C.ceil_h = c_h end  -- meh, crud


  -- walls

  local w_matname = w_mat
  w_mat = Mat_lookup(w_matname)
  w_tex = w_mat.t

if false then
  for dir = 2,8,2 do
    local long = geom.vert_sel(dir, C.x2 - C.x1, C.y2 - C.y1)

    if not C:similar_neighbor(dir) then

      if C.link[dir] then
        -- nothing

      elseif C.room and C.room.kind == "outdoor" then

        if C:need_fence(dir) then
          C:build_fence(dir)
        end

      else
        -- SOLID WALL
        C:build_wall(dir, f_h, c_h)
      end

    else
      -- EXPERIMENT : internal fences

      if C.room and C.room.kind != "cave" and
         C.area and C.area.use_fence and
         C:lower_area_can_fence(dir) and
         not (C.stair and C.stair.dir == dir)
      then
--!!!     C:build_fence(dir, "low")
      end
    end


    -- locked doors
    local LINK = C.link[dir]

    if LINK and LINK.conn and LINK.conn.lock and LINK.C1 == C then
      C:build_door(dir, LINK, f_h, c_h, long)
    end

  end -- dir
end


  -- crossover
  if x_hall and x_hall.cross_mode == "bridge" then
    local h = x_hall.floor_h

    local tx1, ty1 = C.x1, C.y1
    local tx2, ty2 = C.x2, C.y2

    if C.section.shape == "vert" and (tx2 - tx1) > 256 then
      tx1 = tx1 + 96
      tx2 = tx2 - 96
    elseif C.section.shape == "horiz" and (ty2 - ty1) > 256 then
      ty1 = ty1 + 96
      ty2 = ty2 - 96
    end

    local brush = Brush_new_quad(tx1, ty1, tx2, ty2)

    Brush_set_tex(brush, f_mat.t)

    table.insert(brush, { t=h,    tex=f_tex })
    table.insert(brush, { b=h-16, tex=f_tex })

    brush_helper(brush)
  end

  if x_hall and x_hall.cross_mode == "channel" then
    local h = C.floor_h
--!!!!    local dir = assert(C.crossover.dir)

    for sx = C.sx1, C.sx2 do for sy = C.sy1, C.sy2 do
      local S = SEEDS[sx][sy]

      local x1, y1, x2, y2 = S.x1, S.y1, S.x2, S.y2

      -- FIXME
      x1 = x1 + 32 ; y1 = y1 + 32
      x2 = x2 - 32 ; y2 = y2 - 32
--[[
      if geom.is_vert(dir) then
        y1 = y1 + 64 ; y2 = y2 - 64
      else
        x1 = x1 + 64 ; x2 = x2 - 64
      end
--]]

      local brush = Brush_new_quad(x1, y1, x2, y2)

      Brush_set_tex(brush, f_mat.t)

      table.insert(brush, { t=h,    tex=f_tex })
      table.insert(brush, { b=h-16, tex=f_tex })

      brush_helper(brush)
    end end -- sx, sy
  end


end

