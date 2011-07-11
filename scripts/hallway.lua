----------------------------------------------------------------
--  DECK THE HALLS
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2011 Andrew Apted
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

class HALLWAY
{
  R1, K1  -- starting ROOM and SECTION
  R2, K2  -- ending ROOM and SECTION

  id : number (for debugging)

  path : list  -- the path between the start and the destination
               -- (not including either start or dest).
               -- each element contains: G (section), next_dir, prev_dir

  belong_room : ROOM  -- the room that this hallway connects to
                      -- without any locked door in-between.

  wall_tex, floor_tex, ceil_tex 
}


struct CROSSOVER
{
  conn : CONN

  MID_A, MID_K, MID_B : SECTION

  hall_A, hall_B : HALLWAY

  chunk : CHUNK

  floor_h 
}


--------------------------------------------------------------]]

require 'defs'
require 'util'


HALLWAY_CLASS = {}

function HALLWAY_CLASS.new()
  local H =
  {
    id       = Plan_alloc_id("hall")
    is_hall  = true
    conns    = {}
    sections = {}
    chunks   = {}
  }
  table.set_class(H, HALLWAY_CLASS)

  return H
end


function HALLWAY_CLASS.tostr(H)
  return string.format("HALL_%d", H.id)
end


function HALLWAY_CLASS.dump_chunks(H)
  gui.debugf("%s chunks:\n{\n", H:tostr())

  each C in H.chunks do
    gui.debugf("  %s\n", C:tostr())
  end

  gui.debugf("}\n")
end


function HALLWAY_CLASS.dump_path(H)
  if not H.path then
    gui.debugf("No Path.\n")
    return
  end

  gui.debugf("Path:\n")
  gui.debugf("  {\n")

  each loc in H.path do
    gui.debugf("  %s prev:%d next:%d\n", loc.G:tostr(),
               loc.prev_dir or -1, loc.next_dir or -1)
  end

  gui.debugf("  }\n")
end


function HALLWAY_CLASS.dump(H)
  gui.debugf("%s =\n", H:tostr())
  gui.debugf("{\n")
  gui.debugf("    R1 = %s\n", (H.R1 ? H.R1:tostr() ; "nil"))
  gui.debugf("    R2 = %s\n", (H.R2 ? H.R2:tostr() ; "nil"))
  gui.debugf("    K1 = %s\n", (H.K1 ? H.K1:tostr() ; "nil"))
  gui.debugf("    K2 = %s\n", (H.K2 ? H.K2:tostr() ; "nil"))
  gui.debugf("belong = %s\n", (H.belong_room ? H.belong_room:tostr() ; "nil"))

  H:dump_path()
  gui.debugf("}\n")
end


function HALLWAY_CLASS.add_section(H, K)
  table.insert(H.sections, K)
end


function HALLWAY_CLASS.first_chunk(H)
  return H.chunks[1]
end

function HALLWAY_CLASS.last_chunk(H)
  return H.chunks[#H.chunks]
end


function HALLWAY_CLASS.reverse(H)
  H.R1, H.R2 = H.R2, H.R1
  H.K1, H.K2 = H.K2, H.K1

  if H.path then
    table.reverse(H.path)

    each P in H.path do
      P.next_dir, P.prev_dir = P.prev_dir, P.next_dir
    end
  end

  if H.chunks then
    table.reverse(H.chunks)
  end
end


function HALLWAY_CLASS.render_path(H)
  for _,loc in ipairs(H.path) do
    local G = loc.G

    G:set_hall(H)

  end
end


function HALLWAY_CLASS.make_chunks(H)
  each K in H.sections do
    -- mark section as used
    K:set_hall(H)

    local C = CHUNK_CLASS.new(K.sx1, K.sy1, K.sx2, K.sy2)

    C.hall = H
    C:install()

    table.insert(H.chunks, C)

    -- store hallway in seed map
    -- FIXME: do this in K:set_hall() or C:install()
    for sx = C.sx1,C.sx2 do for sy = C.sy1,C.sy2 do
      local S = SEEDS[sx][sy]
      assert(not S.room and not S.hall)
      S.hall = H
    end end
  end
end



function HALLWAY_CLASS.add_it(H)
  table.insert(LEVEL.halls, H)

  H:make_chunks()
end



function HALLWAY_CLASS.build(H)
  -- FIXME !!!!
  if not H.height then
    H.height = 768
    each C in H.chunks do C.floor_h = C.floor_h or 0 end
    H:choose_textures()
  end

  each C in H.chunks do
    C:build()
  end
end


----------------------------------------------------------------


function Hallway_simple(K1, MID, K2, conn, dir)
  --- creates a simple one-section hallway between two rooms

  local H = HALLWAY_CLASS.new()

  conn.kind = "hallway"
  conn.hall = H

  H.K1 = K1 ; H.R1 = assert(K1.room)
  H.K2 = K2 ; H.R2 = assert(K2.room)

  table.insert(H.path, { G=MID, next_dir=dir, prev_dir=10-dir })

  H:render_path()
  H:make_chunks()
end


function Hallways_how_many()
  local perc = style_sel("hallways", 0, 15, 35, 100)

  local num = (SECTION_W + 1) * perc / 100

  return int(num + gui.random())
end



function Hallway_test_branch(start_K, start_dir, mode)

  local function can_make_crossover(K1, dir) --!!!! MERGE INTO test_crossover
    -- TODO: support right angle turn or zig-zag

    local MID_A = K1:neighbor(dir, 1)
    local MID_B = K1:neighbor(dir, 3)

    if not MID_A or MID_A.used then return false end
    if not MID_B or MID_B.used then return false end

    local K2 = K1:neighbor(dir, 2)
    local K3 = K1:neighbor(dir, 4)

    if not K2 or not K2.room or K2.room == K1.room then return false end
    if not K3 or not K3.room or K3.room == K1.room or K3.room == K2.room then return false end

    -- limit of one per room
    -- [cannot do more since crossovers limit the floor heights and
    --  two crossovers can lead to an unsatisfiable range]
    if K2.room.crossover then return false end

    if not Connect_is_possible(K1.room, K3.room, mode) then return false end

    -- size check
    local long, deep = K2.sw, K2.sh
    if geom.is_horiz(dir) then long, deep = deep, long end

    if long < 3 or deep > 4 then return false end

    -- TODO: evaluate the goodness (e.g. poss == 1) and return score

    return true
  end


  local function test_crossover(K1, dir)

    -- FIXME

        -- FIXME: check THEME.bridges (prefab skins) too
--[[
        if not PARAM.bridges then continue end
        if STYLE.crossovers == "none" then continue end

        local cross_score = -1
        if can_make_crossover(K, dir) then cross_score = gui.random() end

        if cross_score >= 0 and (not cross_loc or cross_score > cross_loc.score) then
          cross_loc = { K=K, dir=dir, score=cross_score }
        end
--]]
  end


  local function test_off_hall(MID)
    if not MID.hall then return end

    if MID.hall.conn_group == start_K.room.conn_group then return end

    local score = -100 - MID.num_conn - gui.random()

    if score < LEVEL.best_conn.score then return end


    -- OK --

    local D1 = CONN_CLASS.new("hallway", start_K.room, MID.hall, start_dir)

    D1.K1 = start_K ; D1.K2 = MID


    LEVEL.best_conn.D1 = D1
    LEVEL.best_conn.D2 = nil
    LEVEL.best_conn.hall  = nil
    LEVEL.best_conn.score = score
  end


  local function OLD__test_direct(MID)
    local K2 = K1:neighbor(dir, 2)

    if not (K2 and K2.room) then return end

    if not Connect_is_possible(K1.room, K2.room or K2.hall, mode) then return end

    local score = 50 + gui.random()

    if score < LEVEL.best_conn.score then return end

    -- OK --

    local H = HALLWAY_CLASS.new()

    H:add_section(MID)

    H.conn_group = K1.room.conn_group


    local D1 = CONN_CLASS.new("hallway", K1.room, H, dir)

    D1.K1 = K1 ; D1.K2 = MID


    local D2 = CONN_CLASS.new("hallway", H, K2.room, dir)

    D2.K1 = MID ; D2.K2 = K2


    LEVEL.best_conn.D1 = D1
    LEVEL.best_conn.D2 = D2
    LEVEL.best_conn.hall  = H
    LEVEL.best_conn.score = score
  end


  local function test_hall_conn(end_K, end_dir, visited)
    if not (end_K and end_K.room) then return end

    if not Connect_is_possible(start_K.room, end_K.room or end_K.hall, mode) then return end

    local score = 50 + #visited + gui.random()
    -- TODO: BIG BONUS for big_junc

    if score < LEVEL.best_conn.score then return end


    -- OK --

    local H = HALLWAY_CLASS.new()

    each MID in visited do
      H:add_section(MID)
    end

    H.conn_group = start_K.room.conn_group


    local D1 = CONN_CLASS.new("hallway", start_K.room, H, start_dir)

    D1.K1 = start_K ; D1.K2 = H.sections[1]


    local D2 = CONN_CLASS.new("hallway", end_K.room, H, end_dir)

    D2.K1 = end_K   ; D2.K2 = table.last(H.sections)


    LEVEL.best_conn.D1 = D1
    LEVEL.best_conn.D2 = D2
    LEVEL.best_conn.hall  = H
    LEVEL.best_conn.score = score

--stderrf(">>>>>>>>>> best now @ %s : score:%1.2f\n", H:tostr(), score)
  end


  local TEST_DIRS_NONE  = {}
  local TEST_DIRS_VERT  = { [4]=true, [6]=true }
  local TEST_DIRS_HORIZ = { [2]=true, [8]=true }


  local function hall_flow(K, from_dir, visited, quota)
    assert(K)
    assert(not K.used)

    -- already part of hallway path?
    if table.has_elem(visited, K) then return end

--stderrf("hall_flow: visited @ %s from:%d\n", K:tostr(), from_dir)
--stderrf("{\n")
    table.insert(visited, K)

    local test_dirs
    local is_junction

    if K.kind == "vert" then
      test_dirs = TEST_DIRS_VERT
    elseif K.kind == "horiz" then
      test_dirs = TEST_DIRS_HORIZ
    elseif K.kind == "junction" or K.kind == "big_junc" then
      test_dirs = TEST_DIRS_NONE
      is_junction = true
    else
      return  -- not a hallway section
    end

    for dir = 2,8,2 do
      if dir != from_dir then

        if test_dirs[dir] then
--stderrf("  testing conn @ dir:%d\n", dir)
          test_hall_conn(K:neighbor(dir), 10 - dir, visited)
        end

        if quota > 0 and (not is_junction or geom.is_perpendic(dir, from_dir)) then
          local N = K:neighbor(dir)

          if N and not N.used then
--stderrf("  recursing @ dir:%d\n", dir)
            hall_flow(N, 10 - dir, table.copy(visited), quota - 1)
          end
        end
      end
    end
--stderrf("}\n")
  end


  ---| Hallway_test_branch |---

  assert(start_K.room)  -- always begin from a room

  local MID = start_K:neighbor(start_dir)

  if not MID then return end

  if MID.used then
    -- if neighbor section is used, nothing is possible except
    -- branching off an existing hallway.
    test_off_hall(MID)
    return
  end

  local quota = 4

  if STYLE.hallways == "none"  then quota = 0 end
  if STYLE.hallways == "heaps" then quota = 6 end

  hall_flow(MID, 10 - start_dir, {}, quota)
end



function Hallway_add_streets()
  if STYLE.streets != "heaps" then return end

  local hall = HALLWAY_CLASS.new()

  hall.outdoor = true
  hall.street  = true
  hall.conn_group = 999

  for kx = 1,SECTION_W do for ky = 1,SECTION_H do
    local K = SECTIONS[kx][ky]

    if K and not K.used then
---   if K.kind == "vert"  and (kx == 1 or kx == SECTION_W) then continue end
---   if K.kind == "horiz" and (ky == 1 or ky == SECTION_H) then continue end

      table.insert(hall.sections, K)
    end
  end end

  hall:add_it()
end


--------------------------------------------------------------------


function HALLWAY_CLASS.choose_textures(H)
  H.wall_tex  = rand.key_by_probs(THEME.hallway_walls    or THEME.building_walls)
  H.floor_tex = rand.key_by_probs(THEME.hallway_floors   or THEME.building_floors)
  H.ceil_tex  = rand.key_by_probs(THEME.hallway_ceilings or THEME.building_ceilings or THEME.building_floors)

  if H.outdoor then
    H.floor_tex = rand.key_by_probs(THEME.street_floors or THEME.courtyard_floors or THEME.building_floors)
  end

  H.trimmed = rand.sel(50)
end


function HALLWAY_CLASS.do_heights(H, base_h)
  -- FIXME: this is rubbish
  local delta_h = rand.pick { -24, -16, -8, 0, 8, 16, 24 }

  each C in H.chunks do
    C.floor_h = base_h
  end

  if H.outdoor then
    H.height = 256
  elseif math.abs(delta_h) < 12 and rand.odds(10) then
    H.height = 80
  else
    H.height = rand.sel(50, 128, 176)
  end

  H:choose_textures()
end

