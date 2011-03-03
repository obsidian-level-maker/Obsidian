----------------------------------------------------------------
--  Area Stuff
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2010-2011 Andrew Apted
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


function Rooms_flesh_out()

  local function init_seed(R, S)
    for dir = 2,8,2 do
      local N = S:neighbor(dir)
      local same_room = (N and N.room == R)
      
      if not same_room then
        S:set_edge(dir, "solid")
      end
    end
  end


  local function init_room(R)
    for sx = R.sx1,R.sx2 do for sy = R.sy1,R.sy2 do
      local S = SEEDS[sx][sy]
      if S.room == R then
        init_seed(R, S)
      end
    end end
  end


  local function place_importants(R)
    -- TODO
  end


  local function extra_stuff(R)

    -- this function is meant to ensure good traversibility in a room.
    -- e.g. put a nice item in sections without any connections or
    -- importants, or if the exit is close to the entrance then make
    -- the exit door require a far-away switch to open it.

    -- TODO
  end


  local function decorative_chunks(R)
    -- this does scenic stuff like cages, nukage pits, etc...

    -- TODO
  end


  local function do_floors(R)
    -- the seeds which are left over from the previous allocations
    -- should form a contiguous area which ensures traversibility
    -- between all walk spots (doorways, switches, etc).
    --
    -- the task here is to allocate these seeds into chunks,
    -- sub-dividing them into a number of separate floor areas
    -- (generally of different heights) and stairs between them.

    -- TODO
  end


  local function flesh_out(R)
    init_room(R)

    place_importants(R)

    extra_stuff(R)

    decorative_chunks(R)

    do_floors(R)
  end


  ---| Rooms_flesh_out |---

  for _,R in ipairs(LEVEL.all_rooms) do
    flesh_out(R)
  end
end
