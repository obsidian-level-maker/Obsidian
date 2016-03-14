------------------------------------------------------------------------
--  CONNECTIONS
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2016 Andrew Apted
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


--class CONN
--[[
    kind : keyword  -- "edge", "joiner", "teleporter"

    lock : LOCK

    is_secret : boolean

    id : number  -- debugging aid

    -- The two areas are the vital (compulsory) information,
    -- especially for the quest system.  For joiners and teleporters
    -- the edge info will be absent.

    R1 : source ROOM
    R2 : destination ROOM

    E1 : source EDGE
    E2 : destination EDGE

    A1 : source AREA
    A2 : destination AREA

    F1, F2 : EDGE  -- for "split" connections, the other side

    door_h : floor height for doors straddling the connection

--]]


CONN_CLASS = {}


function CONN_CLASS.new(kind, R1, R2)
  local C =
  {
    kind = kind
    id   = alloc_id("conn")
    R1   = R1
    R2   = R2
  }

  C.name = string.format("CONN_%d", C.id)

  table.set_class(C, CONN_CLASS)

  table.insert(LEVEL.conns, C)

  return C
end


function CONN_CLASS.kill_it(C)
  table.remove(LEVEL.conns, C)

  C.name = "DEAD_CONN"
  C.kind = "DEAD"
  C.id   = -1

  C.R1  = nil ; C.A1 = nil
  C.R2  = nil ; C.A2 = nil
  C.dir = nil
end


function CONN_CLASS.tostr(C)
  return assert(C.name)
end


function CONN_CLASS.swap(C)
  C.R1, C.R2 = C.R2, C.R1
  C.E1, C.E2 = C.E2, C.E1
  C.F1, C.F2 = C.F2, C.F1
  C.A1, C.A2 = C.A2, C.A1

  -- for split conns, keep E1 on left, F1 on right
  -- [ not strictly necessary, handy for debugging though ]
  if C.F1 then
    C.E1, C.F1 = C.F1, C.E1
    C.E2, C.F2 = C.F2, C.E2
  end
end


function CONN_CLASS.other_area(C, A)
  if A == C.A1 then
    return C.A2
  else
    return C.A1
  end
end


function CONN_CLASS.other_room(C, R)
  if R == C.R1 then
    return C.R2
  else
    return C.R1
  end
end


------------------------------------------------------------------------


function Connect_directly(P)
  local kind = P.kind or "edge"

  gui.debugf("Connection: %s --> %s (via %s)\n", P.R1.name, P.R2.name, kind)

  local C = CONN_CLASS.new(kind, P.R1, P.R2)

  table.insert(C.R1.conns, C)
  table.insert(C.R2.conns, C)


  local S1   = P.S
  local long = P.long

  if P.split then long = P.split end


  assert(kind != "teleporter")

  if kind == "joiner" then
    C.A1 = assert(P.A1)
    C.A2 = assert(P.A2)

    C.joiner_chunk = assert(P.chunk)
    C.joiner_chunk.conn = C

stderrf("CONNECT: %s / %s (%s) --> %s / %s (%s)\n",
  C.R1.name, C.A1.name, C.A1.room.name,
  C.R2.name, C.A2.name, C.A2.room.name)

--assert(C.A1.room == C.R1)


  else
    local E1, E2 = Seed_create_edge_pair(S1, P.dir, long, "nothing")

    E1.kind = "arch"

    C.E1 = E1 ; E1.conn = C
    C.E2 = E2 ; E2.conn = C

    C.A1 = assert(E1.S.area)
    C.A2 = assert(E2.S.area)
  end

--[[
gui.debugf("Creating conn %s from %s --> %s\n", C.name, C.R1.name, C.R2.name)
gui.debugf("  seed %s  dir:%d  long:%d\n", P.S.name, P.dir, P.long)
gui.debugf("  area %s(%s) --> %s(%s)\n", C.A1.name, C.A1.mode, C.A2.name, C.A2.mode)
--]]


  -- handle split connections
  -- [ FIXME : broken, must be done a different way ]
--[[
  if P.split then
    assert(not S1.diagonal)
    local S2 = S1:raw_neighbor(geom.RIGHT[P.dir], P.long - P.split)
    assert(not S2.diagonal)

    local F1, F2 = Seed_create_edge_pair(S2, P.dir, long, "nothing")

    F1.kind = "arch"

    C.F1 = F1 ; F1.conn = C
    C.F2 = F2 ; F2.conn = C
  end
--]]
end



function Connect_teleporters()

  local function eval_room(R)
    -- never in hallways
    if R.kind == "hallway" then return -1 end

    local score = R:usable_chunks() * 10

    -- tie breaker
    return score + gui.random() * 22
  end


  local function add_teleporter(R1, R2)
    gui.debugf("Teleporter connection: %s --> %s\n", R1.name, R2.name)

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


  local function pick_room_in_trunk(trunk)
    local best
    local best_score

    each R in trunk.rooms do
      local score = eval_room(R)

      if score < 0 then continue end

      if not best or score > best_score then
        best = R
        best_score = score
      end
    end

    return assert(best)
  end


  local function connect_trunks(trunk1, trunk2)
    local R1 = pick_room_in_trunk(trunk1)
    local R2 = pick_room_in_trunk(trunk2)

    add_teleporter(R1, R2)
  end


  ---| Connect_teleporters |---

  for i = 2, #LEVEL.trunks do
    local k = rand.irange(1, i - 1)

    local trunk1 = LEVEL.trunks[k]
    local trunk2 = LEVEL.trunks[i]

    connect_trunks(trunk1, trunk2)
  end
end

