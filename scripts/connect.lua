------------------------------------------------------------------------
--  CONNECTIONS
------------------------------------------------------------------------
--
--  Oblige Level Maker // ObAddon
--
--  Copyright (C) 2006-2017 Andrew Apted
--  Copyright (C) 2018-2020 MsrSgtShooterPerson
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
------------------------------------------------------------------------


--class CONN
--[[
    --
    -- A connection between two rooms.
    --
    -- The two rooms are the vital (compulsory) information,
    -- especially for the quest system.
    --
    -- For teleporters the edge and area info will be absent.
    -- For joiners, neither A1 and A2 are the actual joiner and
    -- the edges are NOT peered.
    --

    id, name   -- debugging aids

    kind : keyword  -- "edge", "joiner", "terminator", "teleporter",

    lock : LOCK

    is_secret : boolean

    R1 : source ROOM
    R2 : destination ROOM

    E1 : source EDGE
    E2 : destination EDGE

    A1 : source AREA
    A2 : destination AREA

    joiner_chunk : CHUNK

    door_h : floor height for doors straddling the connection
--]]


--class LOCK
--[[
    --
    -- A lock marks when something (mainly connections) is locked
    -- and requires some goal (like a key) to open it.
    -- In other words, an "obstacle" with an external solution.
    --

    id, name   -- debugging aids

    kind : keyword  -- "quest" (significant goal)
                    -- "intraroom" (a barred exit)
                    -- "itemlock" (e.g. lowering pedestal)

    conn : CONN     -- connection which is locked
    item : CHUNK    -- item chunk which is locked

    goals : list(GOAL)  -- the goal(s) which solve the lock
                        -- [ only used with "quest" kind ]
--]]


CONN_CLASS = {}


function CONN_CLASS.new(kind, R1, R2)
  local C =
  {
    kind = kind,
    id   = alloc_id("conn"),
    R1   = R1,
    R2   = R2,
  }

  C.name = string.format("CONN_%d", C.id)

  table.set_class(C, CONN_CLASS)

  table.insert(LEVEL.conns, C)

  return C
end


function CONN_CLASS.kill_it(C)
  table.remove(LEVEL.conns, C)

  C.name = "DEAD_" .. C.name
  C.kind = "DEAD"
  C.id   = -1

  C.R1  = nil ; C.A1 = nil
  C.R2  = nil ; C.A2 = nil
  C.dir = nil
end


function CONN_CLASS.dump(C)
  gui.debugf("Connect object %s:  kind:%s\n", C.name, C.kind)
  gui.debugf("  Rooms: %s --> %s\n", C.R1.name, C.R2.name)

  if C.lock then
    gui.debugf("  Locked: kind=%s goalnum=%s\n",
      C.lock.kind or "<nil>",
      tostring((C.lock.goals and #C.lock.goals) or "-"))
  end

  if C.A1 then
    gui.debugf("  Areas: %s in %s --> %s in %s\n",
        C.A1.name, C.A1.room.name, C.A2.name, C.A2.room.name)
  end

  if C.E1 then
    gui.debugf("  Edge 1 @ %s dir:%d long:%d\n", C.E1.S.name, C.E1.dir, C.E1.long)
    gui.debugf("  Edge 2 @ %s dir:%d long:%d\n", C.E2.S.name, C.E2.dir, C.E2.long)
  end
end


function CONN_CLASS.other_area(C, A)
  if A == C.A1 then return C.A2 end
  if A == C.A2 then return C.A1 end

  error("wrong area for CONN_CLASS.other_area")
end


function CONN_CLASS.other_room(C, R)
  if R == C.R1 then return C.R2 end
  if R == C.R2 then return C.R1 end

  error("wrong room for CONN_CLASS.other_room")
end


function CONN_CLASS.edge_for_room(C, R)
  if R == C.R1 then return C.E1, C.F1 end
  if R == C.R2 then return C.E2, C.F2 end

  error("wrong room for CONN_CLASS.edge_for_room")
end


function CONN_CLASS.get_lock_reqs(C, reqs)
  if C.is_secret then
    reqs.key = "secret"
    return
  end

  if not C.lock then return end

  if C.lock.kind == "intraroom" then
    reqs.key = "barred"

  elseif #C.lock.goals == 2 then
    error("Locked double")

  elseif #C.lock.goals == 3 then
    reqs.key = "k_ALL"

  else
    reqs.key = C.lock.goals[1].item
  end
end


------------------------------------------------------------------------


function Lock_new(kind, conn)
  local LOCK =
  {
    id   = alloc_id("lock"),
    kind = kind,
    conn = conn
  }

  LOCK.name = "LOCK_" .. kind .. "_" .. LOCK.id

  if conn then
    conn.lock = LOCK
  end

  return LOCK
end


------------------------------------------------------------------------


function Connect_directly(P)
  local kind = P.kind

  if PARAM.print_shape_steps and PARAM.print_shape_steps ~= "no" then
    gui.printf("Connection: %s --> %s (via %s)\n", P.R1.name, P.R2.name, kind)
  end

  local C = CONN_CLASS.new(kind, P.R1, P.R2)

  table.insert(C.R1.conns, C)
  table.insert(C.R2.conns, C)

  local S1   = P.S
  local long = P.long

  local E1, E2


  if kind == "edge" then

    E1, E2 = Edge_new_pair("doorway", "nothing",  P.S, P.dir, long)

  elseif kind == "joiner" then

    C.joiner_chunk = assert(P.chunk)
    C.joiner_chunk.conn = C

    local dir1 = assert(P.chunk.from_dir)
    local dir2 = assert(P.chunk.dest_dir)

    E1 = P.chunk:create_edge("nothing", dir1)
    E2 = P.chunk:create_edge("nothing", dir2)

    -- TODO : this shape check is hacky, REVIEW THIS
    if P.chunk.shape == "I" then
      E1.is_wallish = true
      E2.is_wallish = true
    end

  elseif kind == "terminator" then

    C.terminator_chunk = P.chunk
    C.terminator_chunk.conn = C

    -- terminator pieces always point INTO the hallway (from_dir goes OUT)
    if C.R1.is_hallway then
      P.chunk:flip()
    end

    local dir1 = assert(P.chunk.from_dir)
    local dir2 = 10 - dir1  -- terminators are always "I" shape

    E1, E2 = P.chunk:create_edge_pair("nothing", dir1)

    if C.R1.is_hallway then
      E1, E2 = E2, E1
    end

    E1.is_wallish = true
    E2.is_wallish = true

  else
    error("Connect_directly: unknown kind: " .. tostring(P.kind))
  end

  C.E1 = E1 ; E1.conn = C
  C.E2 = E2 ; E2.conn = C

  C.A1 = assert(E1.S.area)
  C.A2 = assert(E2.S.area)

  -- error check from MSSP
  if C.A1.room ~= C.R1 or C.A2.room ~= C.R2 then
    if C.R1 then
      print(table.tostr(C.R1))
    else
      print("Hof")
    end
    if C.R2 then
      print(table.tostr(C.R2))
    else
      print("Haf")
    end
  end

  assert(C.A1.room == C.R1)
  assert(C.A2.room == C.R2)

  Edge_mark_walk(E1)
  Edge_mark_walk(E2)

--[[
gui.debugf("E1.S = %s  dir = %d  area = %s\n", E1.S.name, E1.dir, E1.S.area.name)
gui.debugf("E2.S = %s  dir = %d  area = %s\n", E2.S.name, E2.dir, E2.S.area.name)
--]]

--[[
gui.debugf("Creating conn %s from %s --> %s\n", C.name, C.R1.name, C.R2.name)
gui.debugf("  seed %s  dir:%d  long:%d\n", P.S.name, P.dir, P.long)
gui.debugf("  area %s(%s) of %s --> %s(%s) of %s\n",
C.A1.name, C.A1.mode, C.A1.room.name,
C.A2.name, C.A2.mode, C.A2.room.name)
--]]
end



function Connect_teleporter_rooms(P)
  local R1 = P.R1
  local R2 = P.R2

  gui.printf("Teleporter connection: %s --> %s\n", R1.name, R2.name)

  local C = CONN_CLASS.new("teleporter", R1, R2)

  table.insert(C.R1.conns, C)
  table.insert(C.R2.conns, C)

  table.insert(C.R1.teleporters, C)
  table.insert(C.R2.teleporters, C)

  -- setup tag information
  C.tele_tag1 = alloc_id("tag")
  C.tele_tag2 = alloc_id("tag")

  R1.used_chunks = R1.used_chunks + 1
  R2.used_chunks = R2.used_chunks + 1
end



function Connect_finalize()
  for _,P in pairs(LEVEL.prelim_conns) do
    assert(P.kind)

    if P.kind == "teleporter" then
      Connect_teleporter_rooms(P)
    else
      Connect_directly(P)
    end
  end
end
