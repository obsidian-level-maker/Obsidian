----------------------------------------------------------------
--  ROOMS : FIT OUT
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2008 Andrew Apted
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

class ROOM
{
}


--------------------------------------------------------------]]

require 'defs'
require 'util'



function Rooms_select_heights()

  local function spread()
    for _,C in ipairs(PLAN.all_conns) do
      if C.lock or C.dest.hallway then
        if C.src.floor_h and not C.dest.floor_h then
          C.dest.floor_h = C.src.floor_h
        elseif C.dest.floor_h and not C.src.floor_h then
          C.src.floor_h = C.dest.floor_h
        end
      end
    end
  end

  local function dump_along(list, prefix)
    for idx,L in ipairs(list) do
      con.debugf("%sfloor_along_path: %d/%d = %s\n", prefix,
                 idx, #list, L.h or "UNSET")
    end
  end

  local function find_stretch(list, min_num)
    local S, E

    for idx = 1,#list do
      if list[idx].h then
        if S and (E - S + 1) >= min_num then
          return S, E
        end
        S = nil; E = nil
      else
        if not S then S = idx end
        E = idx
      end
    end

    if S and (E - S + 1) >= min_num then
      return S, E
    end

    return nil, nil
  end

  local function rand_height()
    return 64 * (-1 + rand_index_by_probs { 5,1,6,1,4 })
  end

  local function in_between(h1, h2)
    --!!!! FIXME : TEMP CRUD
    return int((h1 + h2) / 2)
  end

  local function floor_along_path(target, path)
    local list = {}

    for _,C in ipairs(path) do
      table.insert(list, { room = C.src })
    end

    table.insert(list, { room = target })

    local N = #list

    for idx,L in ipairs(list) do
      if L.room.floor_h then
        L.h = L.room.floor_h
      end
    end

    con.debugf("Before:\n"); dump_along(list, "  ")

    -- start
    if not list[1].h then
      if list[2] and list[2].h then
        list[1].h = list[2].h
      else
        list[1].h = rand_height()
      end
    end

    -- target
    if not list[N].h then
      if list[N-1] and list[N-1].h then
        list[N].h = list[N-1].h
      else
        list[N].h = rand_height()
      end
    end

    -- for large stretches of unset floors, split them
    repeat
      local S, E = find_stretch(list, 5)
      if S then
        con.debugf("Splitting stretch %d..%d\n", S, E)
        list[int((S+E)/2)].h = rand_height()
      end
    until not S

    -- fill all remaining gaps
    repeat
      local S, E = find_stretch(list, 1)
      if S then
        assert(S > 1 and E < N)
        
        --FIXME !!!! TERRIBLE
        local new_h = in_between(list[S-1].h, list[E+1].h)
        for idx = S, E do
          list[idx].h = new_h
        end
      end
    until not S

---###    for idx = 2,N-1 do
---###      if not list[idx].h and list[idx-1].h and list[idx+1].h then
---###        list[idx].h = in_between(list[idx-1].h, list[idx+1].h)
---###      end
---###    end

    con.debugf("After:\n"); dump_along(list, "> ")
    con.debugf("\n")

    for _,L in ipairs(list) do
      L.room.floor_h = L.h
    end
  end


  ---| Rooms_select_heights |---

  -- handle non-room stuff (liquids)
  for x = 1,SEED_W do for y = 1,SEED_H do
    local S = SEEDS[x][y][1]
    if S.room and S.room.kind == "liquid" and not S.room.floor_h then
      S.room.floor_h = -40
      S.room.ceil_h  = 512
    end
  end end -- x, y

  -- handle outdoor rooms
  for _,R in ipairs(PLAN.all_rooms) do
    if R.kind == "valley" then
      R.floor_h = 0
      R.ceil_h  = 512
    elseif R.kind == "ground" then
      R.floor_h = 128
      R.ceil_h  = 512
    elseif R.kind == "hill" then
      R.floor_h = 256
      R.ceil_h  = 512
    end

    for _,C in ipairs(R.conns) do
      if (R == C.src) and (C.dest.kind == "building" or C.dest.kind == "cave") then
        C.dest.floor_h = R.floor_h
      end
    end
  end

  for _,A in ipairs(PLAN.all_arenas) do
    spread()
    floor_along_path(A.target, A.path)
  end

  --!!!!!! TEMP CRUD
  for _,R in ipairs(PLAN.all_rooms) do
    if not R.floor_h then
      R.floor_h = 128 * (-1 + rand_index_by_probs {5,3,1} )
      R.f_unset = true
    end
    if not R.ceil_h then
      R.ceil_h  = 320
    end
  end

  -- update seeds
  for x = 1,SEED_W do for y = 1,SEED_H do
    local S = SEEDS[x][y][1]
    if S.room then
      assert(S.room.floor_h)
      S.floor_h = S.room.floor_h
      S.ceil_h  = S.room.ceil_h
    end
  end end -- x, y
end


function Rooms_fit_out()

  con.printf("\n--==| Rooms_fit_out |==--\n\n")

  Rooms_select_heights()
end

