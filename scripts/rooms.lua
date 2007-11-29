----------------------------------------------------------------
-- ROOMS
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006,2007 Andrew Apted
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

require 'defs'

-- FIXME: temp stuff for util module
con = { }
function con.ticker() end
function con.abort() return false end
function con.rand_seed(value) math.randomseed(value) end
function con.random() return math.random() end


require 'util'

SEEDS = {}

function valid_seed(sx, sy)
  return sx >= 1 and sx <= SEEDS.w and sy >= 1 and sy <= SEEDS.h
end

function get_seed_safe(sx, sy)
  return valid_seed(sx, sy) and SEEDS[sx][sy]
end

function printf(fmt, ...)
  if fmt then io.stdout:write(string.format(fmt, ...)) end
end

function dump_rooms()

  for y=SEEDS.h,1,-1 do
    for x=1,SEEDS.w do
      local S = SEEDS[x][y]
      if S and S.room and S.room.room_id then
        printf("%c", sel(S.room.kind=="room",65,97)+(S.room.room_id%26))
      else
        printf(".");
      end
    end
    printf("\n")
  end
end


function make_rooms1()

  SEEDS = array_2D(16,16)
  
end


function make_rooms_by_subdiv()

  SEEDS = array_2D(16,16)
  ROOMS = {}

  local function add_room(pos, w, h)

    local room =
    {
      w=w, x1=pos.x1, y1=pos.y1,
      h=h, x2=pos.x2, y2=pos.y2,

      room_id = #ROOMS,
    }

    if (w==1 or h==1) and rand_odds(70) then
      room.kind = "hall"
    else
      room.kind = "room"
    end

    table.insert(ROOMS, room)

    for x = pos.x1,pos.x2 do
      for y = pos.y1,pos.y2 do
        assert(not SEEDS[x][y])
        SEEDS[x][y] = { sx=x, sy=y, room=room, link={} }

---     SEEDS[SEEDS.w+1-x][y] = { sx=x, sy=y, room=room, link={} }
---     SEEDS[x][SEEDS.h+1-y] = { sx=x, sy=y, room=room, link={} }
---     SEEDS[SEEDS.w+1-x][SEEDS.h+1-y] = { sx=x, sy=y, room=room, link={} }
      end
    end

  end

  local function try_divide(pos)

    local w = pos.x2-pos.x1+1 ; assert(w >= 1)
    local h = pos.y2-pos.y1+1 ; assert(h >= 1)

    local lo,hi,axis = h,w,8
    if (lo >= hi+2) or
       (lo == hi+1 and lo > 1 and rand_odds(85)) or
       (lo == hi              and rand_odds(50)) or
       (lo == hi-1 and lo > 1 and rand_odds(15))
    then
      lo,hi = hi,lo ; axis=6
    end
--printf("try_divide: (%d,%d) .. (%d,%d)\n", pos.x1,pos.y1, pos.x2,pos.y2, axis)

    -- firstly decide if keep whole thing as a room

    local foo = int(hi + lo/2.0)

    local FOO_PROBS = { 0, 99,99,99, 1,1,1,1,0 } -- 50, 20, 6, 2, 0 }

    if hi < 2 or rand_odds(FOO_PROBS[math.min(9,foo)]) then
      add_room(pos, w, h)
      return
    end

    -- not a room?  then sub-divide this area...
    assert(hi >= 2)

    local sub
    repeat
      sub = rand_index_by_probs { 50, 2, 50, 2, 50 }
    until sub <= hi/2

    if axis == 8 then
      try_divide {x1=pos.x1, y1=pos.y1, x2=pos.x1+sub-1, y2=pos.y2}
      try_divide {x1=pos.x1+sub, y1=pos.y1,   x2=pos.x2, y2=pos.y2}
    else
      try_divide {y1=pos.y1, x1=pos.x1, y2=pos.y1+sub-1, x2=pos.x2}
      try_divide {y1=pos.y1+sub, x1=pos.x1,   y2=pos.y2, x2=pos.x2}
    end
  end

  try_divide {x1=1,y1=1,x2=SEEDS.w/2,y2=SEEDS.h/2}

end


math.randomseed(os.time())

make_rooms_by_subdiv()

dump_rooms()

