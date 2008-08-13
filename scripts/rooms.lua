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


  ---| Rooms_select_heights |---

  -- handle non-room stuff (liquids)
  for x = 1,SEED_W do for y = 1,SEED_H do
    local S = SEEDS[x][y][1]
    if S.room and S.room.kind == "liquid" and not S.room.floor_h then
      S.room.floor_h = -40
      S.room.ceil_h  = 512
      S.room.is_sky  = true
    end
  end end -- x, y

  -- handle outdoor rooms
  for _,R in ipairs(PLAN.all_rooms) do
    if R.kind == "valley" then
      R.floor_h = 0
      R.ceil_h  = 512
      R.is_sky  = true
    elseif R.kind == "ground" then
      R.floor_h = 128
      R.ceil_h  = 512
      R.is_sky  = true
    elseif R.kind == "hill" then
      R.floor_h = 256
      R.ceil_h  = 512
      R.is_sky  = true
    end
  end

  --!!!!!! TEMP CRUD
  for _,R in ipairs(PLAN.all_rooms) do
    if not R.floor_h then
      R.floor_h = 128 * (-1 + rand_index_by_probs {5,3,1} )
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
      S.is_sky  = S.room.is_sky
    end
  end end -- x, y
end


function Rooms_fit_out()

  con.printf("\n--==| Rooms_fit_out |==--\n\n")

  Rooms_select_heights()
end

