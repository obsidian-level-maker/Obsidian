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

  adjuster_dir   -- normally NIL
                 -- set for height adjusters : direction to other height

  max_deep[DIR]   -- the maximum distance an edge (or corner) prefab can
                  -- intrude into this chunk.

  floor_h, ceil_h -- floor and ceiling heights

  f_tex,   c_tex  -- floor and ceiling textures

  z_low, z_high   -- vertical range of chunk
                  -- if absent, assume chunk requires whole Z range
}


class LINK
{
  C1, C2  -- chunks which are linked

  dir     -- direction from C1 to C2

  conn : CONN   -- optional (not used for crossovers)

  x1, x2  |  y1, y2  -- coordinate range shared between chunks
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
  local C = { sx1=sx1, sy1=sy1, sx2=sx2, sy2=sy2, content={}, parts={}, link={} }
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


function CHUNK_CLASS.same_area(C, dir)
  assert(C.area)

  local sx1, sy1, sx2, sy2 = geom.side_coords(dir, C.sx1, C.sy1, C.sx2, C.sy2)

  sx1, sy1 = geom.nudge(sx1, sy1, dir)
  sx2, sy2 = geom.nudge(sx2, sy2, dir)

  for sx = sx1,sx2 do for sy = sy1,sy2 do
    local S = SEEDS[sx][sy]

    if not (S and S.chunk) then return false end

    if S.chunk.area != C.area then return false end
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
    local C = SEEDS[sx][sy].chunk

    if not C then return nil end

    if C.room and C.room.kind == "outdoor" then
      info.sky = true
      touch_sky = true
    elseif sky_only then
      continue
    end

    if C.floor_h then info.f_min = math.min(info.f_min or  9999, C.floor_h) end
    if C.floor_h then info.f_max = math.max(info.f_max or -9999, C.floor_h) end

    local ceil_h = C.ceil_h or (C.room and C.room.sky_h)

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


function CHUNK_CLASS.against_map_edge(C, dir)  -- TODO: REMOVE, OLD
  local sx1, sy1, sx2, sy2 = geom.side_coords(dir, C.sx1, C.sy1, C.sx2, C.sy2)

  sx1, sy1 = geom.nudge(sx1, sy1, dir)
  sx2, sy2 = geom.nudge(sx2, sy2, dir)

  if not Seed_valid(sx1, sy1) then return true end

  for sx = sx1,sx2 do for sy = sy1,sy2 do
    if SEEDS[sx][sy].free then return true end
--#  if SEEDS[sx][sy].edge_of_map then return true end
  end end

  return false
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


function CHUNK_CLASS.dir_for_spot(C)
  local R = C.room

  -- check which sides of chunk are against a wall or liquid
  local edges = {}

  local num_wall = 0
  local num_same = 0
  local num_diff = 0
  local num_liq  = 0

  for dir = 2,8,2 do
    edges[dir] = C:classify_edge(dir)

        if edges[dir] == "wall"   then num_wall = num_wall + 1
    elseif edges[dir] == "same"   then num_same = num_same + 1
    elseif edges[dir] == "diff"   then num_diff = num_diff + 1
    elseif edges[dir] == "liquid" then num_liq  = num_liq  + 1
    end
  end

  -- prefer direction which is in the same area
  if num_same == 1 then
    for dir = 2,8,2 do
      if edges[dir] == "same" then return dir end
    end
  end

  if num_same == 0 and num_diff == 1 then
    for dir = 2,8,2 do
      if edges[dir] == "diff" then return dir end
    end
  end

  -- handle corners
  local hemmed

  if edges[4] == "wall" and edges[6] == "wall" then hemmed = true end
  if edges[2] == "wall" and edges[8] == "wall" then hemmed = true end

  if num_wall == 2 and not hemmed and num_liq == 0 then
    if R.sh > R.sw then
      return (edges[2] == "wall" ? 8 ; 2)
    else
      return (edges[4] == "wall" ? 6 ; 4)
    end
  end

  -- find a wall to face away from
  for dir = 2,8,2 do
    if edges[10 - dir] == "wall" and edges[dir] == "same" then
      return dir
    end
  end

  -- otherwise use position in room
  local dir1 = ((C.sx1 + C.sx2) < (R.sx1 + R.sx2) ? 6 ; 4)
  local dir2 = ((C.sy1 + C.sy2) < (R.sy1 + R.sy2) ? 8 ; 2)

  if R.sh > R.sw then dir1, dir2 = dir2, dir1 end

  if edges[dir1] != "liquid" then return dir1 end
  if edges[dir2] != "liquid" then return dir2 end

  -- find any direction which does not face liquid
  for dir = 2,8,2 do
    if edges[dir] != "liquid" then return dir end
  end

  return 2
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



function CHUNK_CLASS.do_big_item(C, item_name)
  local mx, my = C:mid_point()

  -- simple method if no pedestals
  if not THEME.pedestals then
    entity_helper(item_name, mx, my, C.floor_h or 0)
    return
  end

  local list  = Rooms_filter_skins(C.room or C.hall, "pedestals", THEME.pedestals,
                                   { where="middle" })
  local name  = rand.key_by_probs(list)
  local skin1 = GAME.SKINS[name]

  local skin2 = { item = item_name }
  local skin0 = { wall = C.room.wall_mat }

  local T = Trans.spot_transform(mx, my, C.floor_h or 0, C.spot_dir)

  Fabricate(skin1._prefab, T, { skin0, skin1, skin2 })
end



function CHUNK_CLASS.content_start(C)
  local list = Rooms_filter_skins(C.room or C.hall, "starts", THEME.starts,
                                  { where="middle" })

  local name  = rand.key_by_probs(list)
  local skin1 = GAME.SKINS[name]

  local mx, my = C:mid_point()

  local T = Trans.spot_transform(mx, my, C.floor_h or 0, C.spot_dir)

  local skin2 = { }

  Fabricate(skin1._prefab, T, { skin1, skin2 })
end


function CHUNK_CLASS.content_exit(C)
  local list = Rooms_filter_skins(C.room or C.hall, "exits", THEME.exits,
                                  { where="middle" })
  local name = rand.key_by_probs(list)
  local skin1 = GAME.SKINS[name]

  local mx, my = C:mid_point()

  local T = Trans.spot_transform(mx, my, C.floor_h or 0, C.spot_dir)

  local skin2 = { next_map = LEVEL.next_map, targetname = "exit" }
  local skin0 = { wall = C.room.wall_mat }

  -- Hexen: on last map, exit will end the game
  if OB_CONFIG.game == "hexen" and not LEVEL.next_map then
    skin2.special = 75
  end

  Fabricate(skin1._prefab, T, { skin0, skin1, skin2 })
end


function CHUNK_CLASS.content_key(C)
  C:do_big_item(assert(C.content.key))
end


function CHUNK_CLASS.content_switch(C)
  local lock = C.content.lock

  assert(lock)
  assert(lock.switch)

  local skin1
  local skin2 = { tag=lock.tag }
  
  skin2.target = string.format("switch%d", skin2.tag)

  local poss_skins = Rooms_filter_skins(C.room or C.hall, 
                       "switch_fabs", THEME.switch_fabs,
                       { where="middle", key=lock.key, switch=lock.switch })

  local name  = rand.key_by_probs(poss_skins)
  local skin1 = assert(GAME.SKINS[name])

  local mx, my = C:mid_point()

  local T = Trans.spot_transform(mx, my, C.floor_h or 0, C.spot_dir)

  Fabricate(skin1._prefab, T, { skin1, skin2 })
end


function CHUNK_CLASS.content_teleporter(C)
  local conn = assert(C.content.teleporter)

  local list  = Rooms_filter_skins(C.room or C.hall, "teleporters", THEME.teleporters,
                                   { where="middle" })
  local name  = rand.key_by_probs(list)
  local skin1 = assert(GAME.SKINS[name])

  local skin0 = { wall = C.room.wall_mat }
  local skin2 = {}

  if conn.L1 == C.room then
    skin2. in_tag = conn.tele_tag2
    skin2.out_tag = conn.tele_tag1
  else
    skin2. in_tag = conn.tele_tag1
    skin2.out_tag = conn.tele_tag2
  end

  skin2. in_target = string.format("tele%d", skin2. in_tag)
  skin2.out_target = string.format("tele%d", skin2.out_tag)

  local mx, my = C:mid_point()

  local T = Trans.spot_transform(mx, my, C.floor_h or 0, 10 - C.spot_dir)


  Fabricate(skin1._prefab, T, { skin0, skin1, skin2 })

  -- prevent monsters being close to it (in target room)
  if C.room and conn.L2 == C.room then
    C.room:add_exclusion_zone(C.x1, C.y1, C.x2, C.y2, 288)
  end
end


function CHUNK_CLASS.content_hub_gate(C)
  local list  = Rooms_filter_skins(C.room or C.hall, "hub_gates", THEME.hub_gates,
                                   { where="middle" })
  local name  = rand.key_by_probs(list)
  local skin1 = assert(GAME.SKINS[name])

  local skin0 = { wall = C.room.wall_mat }
  local skin2 = {}

  skin2.source_id  = C.content.source_id
  skin2.  dest_id  = C.content.dest_id
  skin2.  dest_map = C.content.dest_map

stderrf("content_hub_gate: to map %d : %d --> %d\n", skin2.dest_map, skin2.source_id, skin2.dest_id)

---FIXME Hexen II and Quake II support
---??  skin2. in_target = string.format("tele%d", skin2. in_tag)
---??  skin2.out_target = string.format("tele%d", skin2.out_tag)

  local mx, my = C:mid_point()

  local T = Trans.spot_transform(mx, my, C.floor_h or 0, 10 - C.spot_dir)

  Fabricate(skin1._prefab, T, { skin0, skin1, skin2 })
end


function CHUNK_CLASS.do_hexen_triple(C)
  -- FIXME: this is temp hack !!!
  local skin_map =
  {
    weapon2 = "Weapon2_Set"
    weapon3 = "Weapon3_Set"

    piece1  = "Piece1_Set"
    piece2  = "Piece2_Set"
    piece3  = "Piece3_Set"
  }

  local name  = assert(skin_map[C.content.weapon])
  local skin1 = assert(GAME.SKINS[name])

  local mx, my = C:mid_point()

  local T = Trans.spot_transform(mx, my, C.floor_h or 0, C.spot_dir)

  local skin0 = { wall = C.room.wall_mat }
  local skin2 = { }

  Fabricate(skin1._prefab, T, { skin0, skin1, skin2 })
end


function CHUNK_CLASS.content_weapon(C)
  -- Hexen stuff
  local weapon = C.content.weapon

  if OB_CONFIG.game == "hexen" and
     (weapon == "weapon2" or weapon == "weapon3" or
      weapon == "piece1" or weapon == "piece2" or weapon == "piece3")
  then
    C:do_hexen_triple()
  else
    C:do_big_item(weapon)
  end
end


function CHUNK_CLASS.do_content(C)
  local kind = C.content.kind

  if not kind then return end

  C.spot_dir = C:dir_for_spot()

  if kind == "START" then
    C:content_start()

  elseif kind == "EXIT" then
    C:content_exit()

  elseif kind == "KEY" then
    C:content_key()

  elseif kind == "SWITCH" then
    C:content_switch()

  elseif kind == "WEAPON" then
    C:content_weapon()

  elseif kind == "TELEPORTER" then
    C:content_teleporter()

  elseif kind == "GATE" then
    C:content_hub_gate()

  else
    error("Unknown chunk content: " .. tostring(kind))
  end
end



function CHUNK_CLASS.cycle_stair(C, dir, N)
  local dir = C.adjuster_dir

  local LINK = C.link[dir]

  assert(LINK)
  assert(LINK.C1 == C or LINK.C2 == C)

  local N = (LINK.C1 == C ? LINK.C2 ; LINK.C1)

if N.floor_h then C.adjust_ceil_h = N.floor_h + 160 end

  -- FIXME: this don't work since stair handling will use N.floor_h
  --        but we need to use the bridge height here.
  if C.hall and C.crossover then return end

  if math.abs(N.floor_h - C.floor_h) <= (PARAM.jump_height or PARAM.step_height) then
    return
  end

  -- this is temporary crud

  local stair_name
  local  lift_name

  if N.floor_h > C.floor_h then
    stair_name = "Stair_Up1"
     lift_name =  "Lift_Up1"
  else
    stair_name = "Stair_Down1"
     lift_name =  "Lift_Down1"
  end

  local skin = GAME.SKINS[stair_name]
  if not skin then return end

  if math.abs(N.floor_h - C.floor_h) > 128 then
    skin = GAME.SKINS[lift_name] or skin
  end

  C.stair =
  {
    C1 = C
    C2 = N
    dir = dir
    skin = skin
  }
end



function CHUNK_CLASS.unpack_parts(C, filter_field)
  -- returns a list of rectangles which represent the area of the
  -- chunk _minus_ the areas of the parts.

  local spaces =
  {
    { x1=C.x1, y1=C.y1, x2=C.x2, y2=C.y2 }
  }

  local function split_space_X(S, N)
    if N.x1 > S.x1 then
      local T = table.copy(S)
      S.x1 = N.x1 ; T.x2 = N.x1
      table.insert(spaces, T)
    end

    if N.x2 < S.x2 then
      local T = table.copy(S)
      S.x2 = N.x2 ; T.x1 = N.x2
      table.insert(spaces, T)
    end

    if N.y1 > S.y1 then
      local T = table.copy(S)
      S.y1 = N.y1 ; T.y2 = N.y1
      table.insert(spaces, T)
    end

    if N.y2 < S.y2 then
      local T = table.copy(S)
      S.y2 = N.y2 ; T.y1 = N.y2
      table.insert(spaces, T)
    end
  end

  local function split_space_Y(S, N)
    -- same code as above, but do Y first

    if N.y1 > S.y1 then
      local T = table.copy(S)
      S.y1 = N.y1 ; T.y2 = N.y1
      table.insert(spaces, T)
    end

    if N.y2 < S.y2 then
      local T = table.copy(S)
      S.y2 = N.y2 ; T.y1 = N.y2
      table.insert(spaces, T)
    end
     
    if N.x1 > S.x1 then
      local T = table.copy(S)
      S.x1 = N.x1 ; T.x2 = N.x1
      table.insert(spaces, T)
    end

    if N.x2 < S.x2 then
      local T = table.copy(S)
      S.x2 = N.x2 ; T.x1 = N.x2
      table.insert(spaces, T)
    end
  end

  local function split_space(S, N)
    local x_dist = math.min(
      math.abs(S.x1 - N.x1), math.abs(S.x1 - N.x2),
      math.abs(S.x2 - N.x1), math.abs(S.x2 - N.x2))

    local y_dist = math.min(
      math.abs(S.y1 - N.y1), math.abs(S.y1 - N.y2),
      math.abs(S.y2 - N.y1), math.abs(S.y2 - N.y2))

    if x_dist < y_dist then
      split_space_X(S, N)
    else
      split_space_Y(S, N)
    end
  end

  local function remove_rect(N)
    -- rebuild the list
    local old_spaces = spaces
    spaces = {}

    each S in old_spaces do
      if geom.boxes_overlap(S.x1,S.y1,S.x2,S.y2, N.x1,N.y1,N.x2,N.y2) then
        split_space(S, N)
      end
    end
  end

  each P in C.parts do
    if filter_field and P[filter_field] then continue end
    remove_rect(P)
  end

  return spaces
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


function CHUNK_CLASS.build_wall(C, dir, f_h)
  local long = geom.vert_sel(dir, C.x2 - C.x1, C.y2 - C.y1)
  local deep = 24

  local T = Trans.edge_transform(C.x1, C.y1, C.x2, C.y2, f_h, dir,
                                 0, long, deep, 0)

  local skin = (C.room and C.room.skin) or (C.hall and C.hall.skin)
  assert(skin)
  assert(skin.facade)

  Fabricate("WALL", T, { skin })
end


function CHUNK_CLASS.build_fence(C, dir)
  local long = geom.vert_sel(dir, C.x2 - C.x1, C.y2 - C.y1)
  local deep = 16

  local fence_h = C.room.max_floor_h + PARAM.jump_height

  local T = Trans.edge_transform(C.x1, C.y1, C.x2, C.y2, fence_h, dir,
                                 0, long, deep, 0)

--  local skin1 = assert(GAME.SKINS["Fence_1"])  --!!!!
  local skin2 = assert(C.room.skin)

  Fabricate("FENCE", T, { skin2 })
end


function CHUNK_CLASS.build_scenic(C)
  if C.prefab_skin then
    local skin0 = {}

    local skin1 = C.prefab_skin
    local skin2 = C.prefab_skin2

    local T = Trans.box_transform(C.x1, C.y1, C.x2, C.y2, C.floor_h or 0, C.prefab_dir or 2)

    Fabricate(skin1._prefab, T, { skin0, skin1, skin2 })

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
end


function CHUNK_CLASS.build_fat_arch(C)
  
  local LINK, dir
  for s = 2,8,2 do
    if C.link[s] then LINK = C.link[s] ; dir = s ; break end
  end
  assert(dir)

  local L1 = LINK.C1.room or LINK.C1.hall
  local L2 = LINK.C2.room or LINK.C2.hall
  
  local skin1 = GAME.SKINS["Fat_Arch1"]  -- FIXME
  local skin2 = C:inner_outer_mat(L1, L2)

  local T = Trans.box_transform(C.x1, C.y1, C.x2, C.y2, C.floor_h or 0, dir)

  Fabricate(skin1._prefab, T, { skin1, skin2 })
end


function CHUNK_CLASS.categorize_hall_piece(C)
  local cat, dir = Trans.categorize_linkage(
      C.link[2] or C.hall_link[2], C.link[4] or C.hall_link[4],
      C.link[6] or C.hall_link[6], C.link[8] or C.hall_link[8]);

  assert(cat != "N" and cat != "F")

  return cat, dir
end


function CHUNK_CLASS.build(C)
  if C.scenic then
    C:build_scenic()
    return
  end

  assert(not C.hall)
  assert(not C.closet)


--[[
if C.hall and #C.hall.sections == 1 and GAME.SKINS.Fat_Arch1 then
  C:build_fat_arch()
  return
end --]]


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

  elseif C.hall then  -- FIXME !!!!!  decide this EARLIER
    w_mat = assert(C.hall.wall_mat)
    f_mat = assert(C.hall.floor_mat)
    c_mat = assert(C.hall.ceil_mat)

    c_h = f_h + C.hall.height
  else
    error("Chunk not in room or hall??")
  end

  if (C.room and C.room.kind == "outdoor") or (C.hall and C.hall.outdoor) then
    c_mat = "_SKY"
    c_medium = "sky"
    if C.room then
      c_h = assert(C.room.sky_h)
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
        f_special = 16  --- FIXME: LEVEL.liquid.special
      end
    end
  end


  -- cruddy handling of cycle/crossover height differences
  if C.adjuster_dir then
    C:cycle_stair()

    -- Fixme: more hackitude....
    if C.adjust_ceil_h then c_h = math.max(c_h, C.adjust_ceil_h) end
  end


  -- floor

  local f_matname = f_mat

  if C.no_floor then
    -- do nothing (e.g. caves)

  elseif C.stair then
    local skin = C.stair.skin

    local delta_h = C.stair.C2.floor_h - C.stair.C1.floor_h

    local skin0 = { side=f_matname, step=f_matname, top=f_matname, floor=f_matname, wall=f_matname }

    local low_h = math.min(C.stair.C1.floor_h, C.stair.C2.floor_h)
    local dir   = C.stair.dir

    -- stair prefabs always go upwards, rotate 180 when going down
    if delta_h < 0 then dir = 10 - dir end

    local T = Trans.box_transform(C.x1, C.y1, C.x2, C.y2, low_h, dir)

    -- stair prefabs use the Z range from 0 to 128.
    -- calculate the correct scaling (to fit the actual height diff)
    T.scale_z = math.abs(delta_h) / 128

    local skin2 = {}

---## stderrf("STAIR STUFF: dir:%d h1:%d h2:%d delta:%d scale_z:%1.4f\n",
---##   C.stair.dir, C.stair.C1.floor_h, C.stair.C2.floor_h, delta_h, T.scale_z)

    Fabricate(skin._prefab, T, { skin0, skin, skin2 })

  elseif not (C.room and C.room.kind == "cave") then
    f_mat = Mat_lookup(f_matname)
    f_tex = f_mat.f or f_mat.t

    brush = Brush_new_quad(C.x1, C.y1, C.x2, C.y2)

    Brush_set_tex(brush, f_mat.t)

    table.insert(brush, { t=f_h, tex=f_tex, special=f_special })
    table.insert(brush, { b=f_h-8, tex=f_tex })

    raw_add_brush(brush)
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
    table.insert(brush, { t=c_h+8, tex=c_tex })

    raw_add_brush(brush)
  end


  if not C.ceil_h then C.ceil_h = c_h end  -- meh, crud


  -- parts

  for dir = 1,9,2 do
    local P = C.parts[dir]

    if P then --[[ FIXME --]] end
  end


  -- walls

  local w_matname = w_mat
  w_mat = Mat_lookup(w_matname)
  w_tex = w_mat.t

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
        C:build_wall(dir, f_h)
      end

    end

    -- locked doors
    local LINK = C.link[dir]

    if LINK and LINK.conn and LINK.conn.lock and LINK.C1 == C then
      local lock = LINK.conn.lock

      local C2 = LINK.C2
      local L2 = C2.room or C2.hall
      local L1 = C .room or C .hall
      assert(L2)

      local reqs = { where="edge", key=lock.key, switch=lock.switch }

      if ( C.hall and  C.hall.group.narrow) or
         (C2.hall and C2.hall.group.narrow)
      then
        reqs.narrow = 1
      end

      local poss_skins = Rooms_filter_skins(C.room or C.hall,
                            "locked_doors", THEME.locked_doors, reqs)

      local name = rand.key_by_probs(poss_skins)

      local skin  = assert(GAME.SKINS[name])

      local skin2 = C:inner_outer_mat(L1, L2)

      local T = Trans.edge_transform(C.x1, C.y1, C.x2, C.y2, f_h, dir,
                                     0, long, skin._deep or 48, 0)

      if lock.kind == "KEY" then
        -- Quake II bits
        skin2.keyname = lock.key
        skin2.targetname = "door" .. Plan_alloc_id("door")

      elseif lock.kind == "SWITCH" then
        skin2.tag = lock.tag
        skin2.targetname = string.format("switch%d", skin2.tag)

      else
        error("Unknown lock kind: " .. tostring(lock.kind))
      end

      Fabricate(skin._prefab, T, { skin, skin2 })
    end

  end -- dir


  -- crossover
  if x_hall and x_hall.cross_mode == "bridge" then
    local h = x_hall.floor_h

    local tx1, ty1 = C.x1, C.y1
    local tx2, ty2 = C.x2, C.y2

    if C.section.orig_kind == "vert" and (tx2 - tx1) > 256 then
      tx1 = tx1 + 96
      tx2 = tx2 - 96
    elseif C.section.orig_kind == "horiz" and (ty2 - ty1) > 256 then
      ty1 = ty1 + 96
      ty2 = ty2 - 96
    end

    local brush = Brush_new_quad(tx1, ty1, tx2, ty2)

    Brush_set_tex(brush, f_mat.t)

    table.insert(brush, { t=h,    tex=f_tex })
    table.insert(brush, { b=h-16, tex=f_tex })

    raw_add_brush(brush)
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

      raw_add_brush(brush)
    end end -- sx, sy
  end


  -- object

  C:do_content()

  --[[ debugging aid
  local mx, my = C:mid_point()
  entity_helper("dummy", mx, my, f_h + 24)
  --]]


  -- lighting

  if light > 0 and GAME.format != "doom" then
    local x, y = C:mid_point()
    local z = rand.irange(64, c_h-32)
    entity_helper("light", x, y, z, { light=light })
  end

end

