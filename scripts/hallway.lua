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

  big_junc  : SECTION
  crossover : ROOM

  double_fork : SECTION    -- only present for double hallways.
  double_dir  : direction

  belong_room : ROOM  -- the room that this hallway connects to
                      -- without any locked door in-between.

  cross_limit : { low, high }  -- a limitation of crossover heights

  wall_tex, floor_tex, ceil_tex 
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

    local C

if H.crossover then
stderrf("*** section : %s %s\n", K:tostr(), (K.used ? "USED" ; "free"))
end
    -- allocate chunk, mark section as used
    if K.used then
      assert(H.crossover)
      K:set_crossover(H)

      local over_R = H.crossover
      assert(over_R:can_alloc_chunk(K.sx1, K.sy1, K.sx2, K.sy2))
      
      C = over_R:alloc_chunk(K.sx1, K.sy1, K.sx2, K.sy2)

      C.foobage = "crossover"
      C.crossover_hall = H

      if K.orig_kind == "junction" then
        C.cross_junc = true
      end
    else
      K:set_hall(H)

      C = CHUNK_CLASS.new(K.sx1, K.sy1, K.sx2, K.sy2)
      C.hall = H
      C:install()
    end

    -- meh meh meh
    C.section = K

    table.insert(H.chunks, C)

    -- store hallway in seed map
    -- FIXME: do this in K:set_hall() or C:install()
    if not C.crossover_hall then
    for sx = C.sx1,C.sx2 do for sy = C.sy1,C.sy2 do
      local S = SEEDS[sx][sy]
      assert(not S.room and not S.hall)
      S.hall = H
    end end
    end
  end
stderrf("\n")
end


function HALLWAY_CLASS.add_it(H)
  table.insert(LEVEL.halls, H)

  if H.crossover then
    local over_R = H.crossover

    over_R.crossover_hall = H

stderrf("************* CROSSOVER @ %s\n", over_R:tostr())
  end

  H:make_chunks(false)

  if #H.sections > 1 then
    LEVEL.hall_quota = LEVEL.hall_quota - #H.sections
  end
end


function HALLWAY_CLASS.merge_it(old_H, new_H)
  -- gui.debugf("MERGING %s into %s\n", new_H:tostr(), old_H:tostr())

  assert(old_H != new_H)

  assert(not old_H.crossover)
  assert(not new_H.crossover)

  each K in new_H.sections do
    table.insert(old_H.sections, K)
  end

  old_H:make_chunks(true)

  LEVEL.hall_quota = LEVEL.hall_quota - #new_H.sections

  -- the new_H object is never used again
  new_H.sections = nil
  new_H.chunks   = nil
end


---?? function HALLWAY_CLASS.add_adjuster(H, D)
---??   each C in H.chunks do
---??     for dir = 2,8,2 do
---??       local LINK = C.links[dir]
---?? 
---??       if LINK and LINK.conn == D then
---??         C.adjuster_dir = dir
---??         return
---??       end
---??     end
---??   end
---?? 
---??   error("Cannot find chunk for adjuster")
---?? end


function HALLWAY_CLASS.build(H)
  -- FIXME !!!!
  if not H.height then
    H.height = 768
    each C in H.chunks do C.floor_h = C.floor_h or 0 end
    H:choose_textures()
  end

  each C in H.chunks do
    if not C.crossover_hall then
      C:build()
    end
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

    if not Connect_is_possible(start_K.room, MID.hall, mode) then return end

    if MID.hall.crossover then return end

    local score = -100 - MID.num_conn - gui.random()


    -- score is now computed : test it

    if score < LEVEL.best_conn.score then return end


    -- OK --

    local D1 = CONN_CLASS.new("normal", MID.hall, start_K.room, 10 - start_dir)

    D1.K1 = MID ; D1.K2 = start_K


    LEVEL.best_conn.D1 = D1
    LEVEL.best_conn.D2 = nil
    LEVEL.best_conn.hall  = nil
    LEVEL.best_conn.score = score
    LEVEL.best_conn.stats = {}
    LEVEL.best_conn.merge_K = nil
  end


  local function test_hall_conn(end_K, end_dir, visited, stats)
    if not (end_K.room or end_K.hall) then return end

    if not Connect_is_possible(start_K.room, end_K.room or end_K.hall, mode) then return end

    -- only connect to a big junction straight off a room
    if end_K.kind == "big_junc" and #visited != 1 then return end

    -- never connect to double hallways or crossovers
    if end_K.hall and (end_K.hall.double_fork or end_K.hall.crossover) then return end

    -- crossovers must be distinct (not same as start or end)
    if stats.crossover and end_K.room == stats.crossover then return end

    local merge = rand.odds(70)

    local score1 = start_K:eval_exit(start_dir)
    local score2 =   end_K:eval_exit(  end_dir)
    assert(score1 >= 0 and score2 >= 0)

    local score = (score1 + score2) * 10

    -- bonus for connecting to a central hub room
    if start_K.room.central_hub or (end_K.room and end_K.room.central_hub) then
      score = score + 155
    -- big bonus for using a big junction
    elseif end_K.kind == "big_junc" then
      score = score + 120
      merge = true
    elseif stats.big_junc then
      score = score + 60
      merge = false
    end

    if stats.crossover then
---///    score = score + style_sel("crossovers", 0, 0, 31, 99)
local len = 0
each K in visited do if K.used then len = len + 1 end end
      score = score + 500 * len
      merge = false
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

    if end_K.kind == "big_junc" then
      H.big_junc = end_K
    else
      H.big_junc = stats.big_junc
    end

    if stats.crossover then
      H.crossover = stats.crossover
    end

    if not end_K.hall or end_K.hall.crossover then
      merge = false
    end


    local D1 = CONN_CLASS.new("normal", start_K.room, H, start_dir)

    D1.K1 = start_K ; D1.K2 = H.sections[1]


    -- Note: some code assumes that D2.L2 is the destination room/hall

    local D2 = CONN_CLASS.new("normal", H, end_K.room or end_K.hall, 10 - end_dir)

    D2.K1 = table.last(H.sections) ; D2.K2 = end_K


    LEVEL.best_conn.D1 = D1
    LEVEL.best_conn.D2 = D2
    LEVEL.best_conn.hall  = H
    LEVEL.best_conn.score = score
    LEVEL.best_conn.stats = stats
    LEVEL.best_conn.merge_K = (merge ? end_K ; nil)

--stderrf(">>>>>>>>>> best now @ %s : score:%1.2f\n", H:tostr(), score)
  end


  local function can_begin_crossover(K, N, stats)
    if not PARAM.bridges then return false end

    if STYLE.crossovers == "none" then return false end

    -- never do crossovers for cycles (TODO: review this)
    if mode == "cycle" then return false end

    -- FIXME: LEVEL.crossover_quota

    -- only enter the room at a junction (i.e. through a hallway channel)
    if K.kind != "junction" then return false end

    if not N.room then return false end

    -- crossovers must be distinct (not same as start or end)
    if N.room == start_K.room then return false end

    -- limit of one per room
    -- [cannot do more because crossovers limit the floor heights and
    --  two crossovers can lead to an unsatisfiable range]
    if N.room.crossover_hall then return false end

    -- if re-entering a room, must be the same one!
    if stats.crossover and N.room != stats.crossover then return false end

    return true
  end


  local TEST_DIRS_NONE  = {}
  local TEST_DIRS_VERT  = { [4]=true, [6]=true }
  local TEST_DIRS_HORIZ = { [2]=true, [8]=true }


  local function hall_flow(K, from_dir, visited, stats, quota)
    assert(K)

    -- must be a free section except when crossing over a room
    if not (stats.crossover and stats.crossover == K.room) then
      assert(not K.used)
    end

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

    if K.orig_kind == "vert" then
      test_dirs = TEST_DIRS_VERT
    elseif K.orig_kind == "horiz" then
      test_dirs = TEST_DIRS_HORIZ
    elseif K.orig_kind == "junction" or K.kind == "big_junc" then
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
      -- !!! if test_dirs[dir] or (true and K.kind != "big_junc") then  
      if K.kind != "big_junc" and not K.used then
--stderrf("  testing conn @ dir:%d\n", dir)
        test_hall_conn(N, 10 - dir, visited, stats)
      end

      -- too many hallways already?
      if quota < 1 or LEVEL.hall_quota < 1 then continue end

      -- limit length of big junctions
      if stats.big_junc and #visited >= 3 then continue end

      local do_cross = false

      if N.used then
        -- don't allow crossover to walk into another room
        if K.used and N.room != stats.crossover then continue end

        -- begin crossover?
        if not K.used and not can_begin_crossover(K, N, stats) then continue end

        do_cross = true
      end

      if (not is_junction) or geom.is_perpendic(dir, from_dir) then --- or N.kind == "big_junc" then

--stderrf("  recursing @ dir:%d\n", dir)
        local new_stats = table.copy(stats)
        if do_cross then new_stats.crossover = N.room end
        local new_quota = quota - (N.used ? 0 ; 1)

        hall_flow(N, 10 - dir, table.copy(visited), new_stats, new_quota)
      end
    end
--stderrf("}\n")
  end


  ---| Hallway_test_branch |---

  -- always begin from a room
  assert(start_K.room)

  local MID = start_K:neighbor(start_dir)

  if not MID then return end

  -- if neighbor section is used, nothing is possible except
  -- branching off a nearby hallway.
  if MID.used then
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
      if D.kind == "normal" then
        if D.K1 == K1 and D.K2 == K2 then return D end
        if D.K1 == K2 and D.K2 == K1 then return D end
      end
    end

    return nil
  end


  local function try_add_at_section(H, K, dir)
    -- check if all the pieces we need are free
    local  left_dir = geom.LEFT [dir]
    local right_dir = geom.RIGHT[dir]

    local  left_J = K:neighbor(left_dir)
    local right_J = K:neighbor(right_dir)

    if not  left_J or  left_J.used then return false end
    if not right_J or right_J.used then return false end

    local  left_K =  left_J:neighbor(dir)
    local right_K = right_J:neighbor(dir)

    if not  left_K or  left_K.used then return false end
    if not right_K or right_K.used then return false end

    -- hallway widths on each side must be the same
    if geom.is_vert(dir) then
      if left_K.sw != right_K.sw then return false end
    else
      if left_K.sh != right_K.sh then return false end
    end

    -- size check
    local room_K = K:neighbor(dir)
    if not room_K.room then return false end

    assert(room_K ==  left_K:neighbor(right_dir))
    assert(room_K == right_K:neighbor( left_dir))

    local long, deep = room_K.sw, room_K.sh
    if geom.is_horiz(dir) then long, deep = deep, long end

    if deep < 3 then return false end

    -- fixme: this should not fail
    local D1 = find_conn_for_double(H, K, dir)
    if not D1 then return false end

    gui.debugf("Double hallway @ %s dir:%d\n", K:tostr(), dir)

    -- update existing connection, create peer
    D1.kind = "double_L"

    if D1.K1 != K then D1:swap() end
    assert(D1.K1 == K)
    assert(D1.K2 == room_K)

    D1.K1   = left_K
    D1.dir1 = right_dir
    D1.dir2 = 10 - right_dir

    local D2 = CONN_CLASS.new("double_R", H, room_K.room, left_dir)

    D2.K1 = right_K
    D2.K2 = room_K

    -- peer up the two connections, needed when locking one of them
    D1.peer = D2 ; D2.peer = D1

    D2:add_it()

    H.double_fork = K  -- meh, remove

    H:add_section(K)
    H:add_section(left_J) ; H:add_section(right_J)
    H:add_section(left_K) ; H:add_section(right_K)

    -- meh
    left_J.forky = true ; right_J.forky = true
    left_K.forky = true ; right_K.forky = true

    H:make_chunks(true)

    -- create chunk in room
    local CC = room_K.room:chunk_for_double(room_K, left_dir)

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

  local quota = 4  -- FIXME

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
  if LEVEL.special != "street" then return end

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


function HALLWAY_CLASS.set_cross_mode(H)
  assert(H.quest)
  assert(H.crossover)
  assert(H.crossover.quest)

  local id1 = H.quest.id
  local id2 = H.crossover.quest.id

  if id1 < id2 then
    -- the crossover bridge is part of a earlier quest, so
    -- we must not let the player fall down into this room
    -- (and subvert the quest structure).
    --
    -- Hence the crossover becomes a "cross under" :)

    H.cross_mode = "channel"
  else
    H.cross_mode = "bridge"
  end

 stderrf("CROSSOVER %s : %s (id %d over %d)\n", H:tostr(), H.cross_mode, id1, id2)
end


function HALLWAY_CLASS.cross_diff(H)
  assert(H.cross_mode)

  if H.cross_mode == "bridge" then
    return rand.pick { 96, 96, 128, 128, 128, 128, 160, 192, 256 }
  else
    return (PARAM.jump_height or 24) + rand.pick { 40, 40, 64, 64, 96, 128 }
  end
end


function HALLWAY_CLASS.limit_crossed_room(H)
  local R = H.crossover

  if R.done_heights then return end

  local min_h = H.min_floor_h
  local max_h = H.max_floor_h

  local diff = H:cross_diff()

  if H.cross_mode == "bridge" then
    R.floor_limit = { -9999, min_h - diff }
  else
    R.floor_limit = { max_h + diff, 9999 }
  end
end


function HALLWAY_CLASS.flesh_out(H, entry_conn)
  ---- if H.done_heights then return end
gui.debugf("FLESH OUT : %s\n", H:tostr())
entry_conn:dump()
  assert(not H.done_heights)

  H.done_heights = true

  assert(entry_conn)
  assert(entry_conn.C1)

  local entry_C = assert(entry_conn.C2)
  local entry_h = assert(entry_conn.C1.floor_h)

  if H.cross_limit then
    if entry_h < H.cross_limit[1] then entry_h = H.cross_limit[1] end
    if entry_h > H.cross_limit[2] then entry_h = H.cross_limit[2] end
stderrf("applied cross_limit: entry_h --> %d\n", entry_h)
  end

  H.floor_h = entry_h
  H.min_floor_h = entry_h
  H.max_floor_h = entry_h

  assert(H.chunks)

  each C in H.chunks do
    if C.crossover_hall then
      C.crossover_floor_h = entry_h  -- meh
    else
      C.floor_h = entry_h
    end
  end

  if H.crossover then
    H:limit_crossed_room()
  end

  if H.street then
    H.height = 512
  elseif H.is_cycle or H.crossover then
    H.height = 384  -- FIXME: temp crud
  elseif H.outdoor then
    H.height = 256
  elseif rand.odds(10) then
    H.height = 80
  else
    H.height = rand.sel(50, 128, 176)
  end

  H:choose_textures()
end

