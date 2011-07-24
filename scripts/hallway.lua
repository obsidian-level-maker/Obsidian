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
  id : number (for debugging)

  conns : list(CONN)  -- connections with neighbor rooms / hallways
  entry_conn

  sections : list(SECTION)
  chunks   : list(CHUNK)

  big_junc : SECTION

  double_fork : SECTION    -- only present for double hallways.
  double_dir  : direction

  belong_room : ROOM  -- the room that this hallway connects to
                      -- without any locked door in-between.

  wall_tex, floor_tex, ceil_tex 
}


struct CROSSOVER
{
  conn : CONN

  over_K : SECTION

  MID_A, MID_B : SECTION

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


function HALLWAY_CLASS.dump(H)
  gui.debugf("%s =\n", H:tostr())
  gui.debugf("{\n")
  -- FIXME
  gui.debugf("belong = %s\n", (H.belong_room ? H.belong_room:tostr() ; "nil"))
  gui.debugf("chunks = %s\n", (H.chunks ? tostring(#H.chunks) ; "nil"))
  gui.debugf("}\n")
end


function HALLWAY_CLASS.add_section(H, K)
  table.insert(H.sections, K)
end


function HALLWAY_CLASS.make_chunks(H, skip_old)
  each K in H.sections do
    if skip_old and K.used then continue end

    -- mark section as used
    K:set_hall(H)

    local C = CHUNK_CLASS.new(K.sx1, K.sy1, K.sx2, K.sy2)

    C.hall = H
    C:install()

    -- meh meh meh
    C.section = K

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

  H:make_chunks(false)

  if #H.sections > 1 then
    LEVEL.hall_quota = LEVEL.hall_quota - #H.sections
  end
end


function HALLWAY_CLASS.merge_it(old_H, new_H)
  assert(old_H != new_H)

  each K in new_H.sections do
    table.insert(old_H.sections, K)
  end

  old_H:make_chunks(true)

  LEVEL.hall_quota = LEVEL.hall_quota - #new_H.sections

  -- the new_H object is never used again
  new_H.sections = nil
  new_H.chunks   = nil
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


function Hallway_prepare()
  local quota = 0

  if STYLE.hallways != "none" then
    local perc = style_sel("hallways", 0, 20, 50, 120)

    quota = (MAP_W * MAP_H * rand.range(1, 2)) * perc / 100 - 1
    
    quota = int(quota)  -- round down
  end

  gui.printf("Hallway quota: %d sections\n", quota)

  LEVEL.hall_quota = quota

  -- big junctions are marked as "used" during the planning phase,
  -- which simplifies that code.  But now we want to actually use
  -- them, so mark them as free again.
  for kx = 1,SECTION_W do for ky = 1,SECTION_H do
    local K = SECTIONS[kx][ky]

    if K.kind == "big_junc" then
      K.used = false
    end
  end end
end



function Hallway_test_branch(start_K, start_dir, mode)

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
    LEVEL.best_conn.stats = {}
    LEVEL.best_conn.merge = false
  end


  local function test_hall_conn(end_K, end_dir, visited, stats)
    if not (end_K.room or end_K.hall) then return end

    if not Connect_is_possible(start_K.room, end_K.room or end_K.hall, mode) then return end

    -- only connect to a big junction straight off a room
    if end_K.kind == "big_junc" and #visited != 1 then return end

    -- never connect to double hallways or crossovers
    if end_K.hall and (end_K.hall.double_fork or end_K.hall.crossover) then return end

    local merge = rand.odds(70)

    local score1 = start_K:eval_exit(start_dir)
    local score2 =   end_K:eval_exit(  end_dir)
    assert(score1 >= 0 and score2 >= 0)

    local score = (score1 + score2) * 10

    -- big bonus for using a big junction
    if end_K.kind == "big_junc" then
      score = score + 120
      merge = true
    elseif stats.big_junc then
      score = score + 60
      merge = false
---///  elseif stats.crossover then
---///    score = score + style_sel("crossovers", 0, 0, 31, 99)
---///    merge = false
    end

    -- minor tendency for longer halls.
    -- [I don't think that hallway length should be a major factor in
    --  deciding whether to make a hallway or not]
    score = score + #visited / 5.4


    -- score is now computed : test it

    if score < LEVEL.best_conn.score then return end


    -- OK --

    local H = HALLWAY_CLASS.new()

    H.sections = visited
    H.conn_group = start_K.room.conn_group

    H.big_junc = stats.big_junc

    if end_K.kind == "big_junc" then H.big_junc = end_K end


    local D1 = CONN_CLASS.new("hallway", start_K.room, H, start_dir)

    D1.K1 = start_K ; D1.K2 = H.sections[1]


    -- Note: some code assumes that D2.L1 is the destination room/hall

    local D2 = CONN_CLASS.new("hallway", end_K.room or end_K.hall, H, end_dir)

    D2.K1 = end_K   ; D2.K2 = table.last(H.sections)


    LEVEL.best_conn.D1 = D1
    LEVEL.best_conn.D2 = D2
    LEVEL.best_conn.hall  = H
    LEVEL.best_conn.score = score
    LEVEL.best_conn.stats = stats
    LEVEL.best_conn.merge = merge

--stderrf(">>>>>>>>>> best now @ %s : score:%1.2f\n", H:tostr(), score)
  end


  -- WISH: make crossovers merely a part of normal hall_flow() processing.
  --       would need to store them in stats and 

  local function test_crossover(K, dir, visited, stats)
    if not PARAM.bridges then return end

    -- FIXME: LEVEL.crossover_quota
    if STYLE.crossovers == "none" then return end

    -- WISH: support right angle turn or zig-zag

    local MID_A = K:neighbor(dir, 1)
    local MID_B = K:neighbor(dir, 3)

    if not MID_A or MID_A.used then return end
    if not MID_B or MID_B.used then return end

    local mid_K = K:neighbor(dir, 2)
    local end_K = K:neighbor(dir, 4)
    local end_dir = 10 - dir

    if not (mid_K and mid_K.kind == "section" and mid_K.room) then return end
    if not (end_K and end_K.kind == "section" and end_K.room) then return end

    -- rooms must be distinct
    if end_K.room == start_K.room then return end
    if mid_K.room == start_K.room then return end
    if mid_K.room ==   end_K.room then return end

    -- connection check
    if not Connect_is_possible(start_K.room, end_K.room, mode) then return end

    -- limit of one per room
    -- [cannot do more because crossovers limit the floor heights and
    --  two crossovers can lead to an unsatisfiable range]
    if mid_K.room.crossover then return false end

    -- size check
    local long, deep = K2.sw, K2.sh
    if geom.is_horiz(dir) then long, deep = deep, long end

    if long < 3 or deep > 4 then return false end


    -- compute score

    local score1 = start_K:eval_exit(start_dir)
    local score2 =   end_K:eval_exit(  end_dir)
    assert(score1 >= 0 and score2 >= 0)

    local score = (score1 + score2) * 10

    -- bonus for using a crossover
    score = score + style_sel("crossovers", 0, 0, 56, 108)

    -- minor tendency for longer halls.
    score = score + #visited / 9.4


    -- score is now computed : test it

    if score < LEVEL.best_conn.score then return end


    -- OK --

    local H = HALLWAY_CLASS.new()

    H.sections = visited
    H.conn_group = start_K.room.conn_group

    H.big_junc = stats.big_junc

    if end_K.kind == "big_junc" then H.big_junc = end_K end


    local D1 = CONN_CLASS.new("hallway", start_K.room, H, start_dir)

    D1.K1 = start_K ; D1.K2 = H.sections[1]


    -- Note: some code assumes that D2.L1 is the destination room/hall

    local D2 = CONN_CLASS.new("hallway", end_K.room or end_K.hall, H, end_dir)

    D2.K1 = end_K   ; D2.K2 = table.last(H.sections)


    LEVEL.best_conn.D1 = D1
    LEVEL.best_conn.D2 = D2
    LEVEL.best_conn.hall  = H
    LEVEL.best_conn.score = score
    LEVEL.best_conn.stats = stats
    LEVEL.best_conn.merge = nil

--stderrf(">>>>>>>>>> best now @ %s : score:%1.2f\n", H:tostr(), score)
  end


  local TEST_DIRS_NONE  = {}
  local TEST_DIRS_VERT  = { [4]=true, [6]=true }
  local TEST_DIRS_HORIZ = { [2]=true, [8]=true }


  local function hall_flow(K, from_dir, visited, stats, quota)
    assert(K)
    assert(not K.used)

    -- already part of hallway path?
    if table.has_elem(visited, K) then return end

    -- can only flow through a big junction when coming straight off
    -- a room (i.e. ROOM, MID, BIG_JUNC).
    if K.kind == "big_junc" and #visited != 1 then return end

--stderrf("hall_flow: visited @ %s from:%d\n", K:tostr(), from_dir)
--stderrf("{\n")
    table.insert(visited, K)

    if K.kind == "big_junc" then
      stats.big_junc = K
    end

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
      -- never able to go back the way we came
      if dir == from_dir then continue end

      local N = K:neighbor(dir)
      if not N then continue end

      -- FIXME: disabled test_dirs[] logic for now -- review this!!
      if test_dirs[dir] or (true and K.kind != "big_junc") then  
--stderrf("  testing conn @ dir:%d\n", dir)
        test_hall_conn(N, 10 - dir, visited, stats)

        test_crossover(K, dir, visited, stats)
      end

      if N.used then continue end

      -- too many hallways already?
      if quota < 1 or LEVEL.hall_quota < 1 then continue end

      -- limit length of big junctions
      if stats.big_junc and #visited >= 3 then continue end

      if (not is_junction) or geom.is_perpendic(dir, from_dir) then --- or N.kind == "big_junc" then

--stderrf("  recursing @ dir:%d\n", dir)
        hall_flow(N, 10 - dir, table.copy(visited), table.copy(stats), quota - 1)
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
    -- branching off a nearby hallway.
    test_off_hall(MID)
    return
  end

  local quota = 4

  if STYLE.hallways == "none"  then quota = 0 end
  if STYLE.hallways == "heaps" then quota = 6 end

  hall_flow(MID, 10 - start_dir, {}, {}, quota)
end



function Hallway_add_doubles()
  -- looks for places where a "double hallway" can be added.
  -- these are where the hallways comes around two sides of a room
  -- and connects on both sides (instead of straight on).

  -- Note: this is done _after_ all the connections have been made
  -- for two reasons:
  --    (1) don't want these to block normal connections
  --    (2) don't want other connections joining onto these

  local function find_conn_for_double(H, K1, dir)
    local K2 = K1:neighbor(dir)

    each D in LEVEL.conns do
      if D.kind != "hallway" then continue end

      if D.K1 == K1 and D.K2 == K2 then return D end
      if D.K1 == K2 and D.K2 == K1 then return D end
    end

    error("failed to find connection for hallway")
  end


  local function try_add_at_section(H, K, dir)
    local  left_J = K:neighbor(geom.LEFT [dir])
    local right_J = K:neighbor(geom.RIGHT[dir])

    if not  left_J or  left_J.used then return false end
    if not right_J or right_J.used then return false end

    local  left_K =  left_J:neighbor(dir)
    local right_K = right_J:neighbor(dir)

    if not  left_K or  left_K.used then return false end
    if not right_K or right_K.used then return false end

    -- size check
    local room_K = K:neighbor(dir)

    local long, deep = room_K.sw, room_K.sh
    if geom.is_horiz(dir) then long, deep = deep, long end

    if deep < 3 then return false end

    stderrf("Double hallway @ %s dir:%d\n", K:tostr(), dir)

    H.double_fork  = K
    H.double_dir   = dir
    H.double_left  = left_K
    H.double_right = right_K

    H:add_section(K)
    H:add_section(left_J) ; H:add_section(right_J)
    H:add_section(left_K) ; H:add_section(right_K)

    -- meh
    left_J.forky = true ; right_J.forky = true
    left_K.forky = true ; right_K.forky = true

    H:make_chunks(true)

    -- update the connection object
    local D = find_conn_for_double(H, K, dir)
    D.kind = "double_hall"

    return true
  end


  local function try_add_double(H)
    local big_K = H.big_junc

    if not (#H.sections == 1 or big_K) then return end

    local SIDES = { 2,4,6,8 }
    rand.shuffle(SIDES)

    each dir in SIDES do
      local K = H.sections[1]

      if big_K then
        K = big_K:neighbor(dir)  
      end

      if try_add_at_section(H, K, dir) then
        return true
      end
    end

    return false
  end


  --| Hallway_add_doubles |--

  local quota = 5  -- FIXME

  local visits = table.copy(LEVEL.halls)
  rand.shuffle(visits)  -- score and sort them??

  each H in visits do
    if quota < 1 then break end

    if try_add_double(H) then
      quota = quota - 1
    end
  end
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

  -- give each room an apparent height
  each R in LEVEL.rooms do
    R.street_inner_h = rand.pick { 160, 192, 224, 256, 288 }
  end
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

  assert(H.chunks)

  each C in H.chunks do
    C.floor_h = base_h
  end

  if H.street then
    H.height = 512
  elseif H.outdoor then
    H.height = 256
  elseif math.abs(delta_h) < 12 and rand.odds(10) then
    H.height = 80
  else
    H.height = rand.sel(50, 128, 176)
  end

  H:choose_textures()
end

