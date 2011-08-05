----------------------------------------------------------------
--  SEED MANAGEMENT / GROWING
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

class SEED
{
  sx, sy, sz : location in seed map

  zone : ZONE, never nil!

  room : ROOM

  borders : table(DIR -> BORDER)  -- DIR can be (2 4 6 8)

  target_w, target_h : map size we want to be (bigger is OK)

  x1, y1, z1, x2, y2, z2 : map coordinates for 3D bbox 

  -- grow phase only:
  grow, shrink : map size to grow/shrink along current axis
}


class BORDER
{
  kind  : "solid" | "view" | "walk"

  other : SEED  -- seed we are connected to, or nil 

  rlink : RLINK
}

--------------------------------------------------------------]]

require 'defs'
require 'util'


SEED_SIZE = 256


function Seed_init(W, H, D, zone)

  assert(zone)

  SEED_W = W
  SEED_H = H
  SEED_D = D

  SEEDS = array_2D(W, H)

  for x = 1,W do for y = 1,H do
    SEEDS[x][y] = {}

    for z = 1,D do
      SEEDS[x][y][z] = { sx=x, sy=y, sz=z, zone=zone }
    end
  end end -- x,y
end


function Seed_close()
  SEEDS = nil

  SEED_W = nil
  SEED_H = nil
  SEED_D = nil
end


function Seed_valid(x, y, z)
  return (x >= 1 and x <= SEED_W) and
         (y >= 1 and y <= SEED_H) and
         (z >= 1 and z <= SEED_D)
end


function Seed_get_safe(x, y, z)
  return Seed_valid(x, y, z) and SEEDS[x][y][z]
end


function Seed_is_free(x, y, z, zone)
  assert(Seed_valid(x, y, z))

  return not SEEDS[x][y][z].room
end


function Seed_valid_and_free(x, y, z)
  if not Seed_valid(x, y, z) then
    return false
  end

  if SEEDS[x][y][z].room then
    return false
  end

  return true
end


function Seed_block_valid_and_free(x1,y1,z1, x2,y2,z2)

  assert(x1 <= x2 and y1 <= y2 and z1 <= z2)

  if not Seed_valid(x1, y1, z1) then return false end
  if not Seed_valid(x2, y2, z2) then return false end

  for x = x1,x2 do for y = y1,y2 do for z = z1,z2 do
    local S = SEEDS[x][y][z]
    if S.room then
      return false
    end
  end end end -- x, y, z

  return true
end


function Seed_dump_rooms()
  gui.printf("Seed room map:\n")

  local ROOM_IDX = 0
  local HALL_IDX = 0

  local ROOMS = "BFGHIDKLPTQJY"
  local HALLS = "acmunorvsewxz"

  local function seed_to_char(S)
    if not S or not S.zone then return "!" end

    if not S.room then
      if S.zone.zone_kind == "walk" then return "/" end
      if S.zone.zone_kind == "view" then return "%" end
      if S.zone.parent then return "#" end
      return "."
    end

    if not S.room.dump_char then
      if S.room.kind == "hall" then
        S.room.dump_char = string.sub(HALLS, 1+HALL_IDX, 1+HALL_IDX)
        HALL_IDX = (HALL_IDX + 1) % string.len(HALLS)
      else
        S.room.dump_char = string.sub(ROOMS, 1+ROOM_IDX, 1+ROOM_IDX)
        ROOM_IDX = (ROOM_IDX + 1) % string.len(ROOMS)
      end
    end

    return S.room.dump_char
  end

  for y = SEED_H,1,-1 do
    for x = 1,SEED_W do
      gui.printf("%s", seed_to_char(SEEDS[x][y][1]))
    end
    gui.printf("\n")
  end

  gui.printf("\n")
end


function Seed_dump_fabs()
  local function char_for_seed(S)

    if not S or not S.kind then return "." end

    if S.kind == "ground" then return "2" end
    if S.kind == "valley" then return "1" end
    if S.kind == "hill"   then return "3" end

    if S.kind == "indoor" then return "#" end
    if S.kind == "hall"   then return "+" end
    if S.kind == "liquid" then return "~" end

    return "?"
  end

  gui.printf("Room Fabs:\n")

  for y = SEED_H,1,-1 do
    
    for x = 1,SEED_W do
      gui.printf("%s", char_for_seed(SEEDS[x][y][1].room))
    end

    gui.printf("\n")
  end

  gui.printf("\n")
end


--[[
require 'gd'

RENDER_NUM = 1

function debug_render()

  local im = gd.createTrueColor(500, 300);

  local black = im:colorAllocate(0, 0, 0);
  local gray  = im:colorAllocate(127, 127, 127);
  local white = im:colorAllocate(255, 255, 255);

  local red    = im:colorAllocate(200, 0, 0);
  local blue   = im:colorAllocate(0, 0, 200);
  local purple = im:colorAllocate(200, 0, 200);
  local yellow = im:colorAllocate(200, 200, 0);
  local green  = im:colorAllocate(0, 200, 0);

  im:filledRectangle(0, 0, 500, 300, black);

  local function draw_seed(x, y, S)
    
    local x1 = (S.x1 + 16) * 6
    local y1 = (S.y1 + 16) * 6

    local x2 = (S.x2 + 16) * 6 + 5
    local y2 = (S.y2 + 16) * 6 + 5

    y1,y2 = 300-y2, 300-y1

local aa = (S.x2 - S.x1 + 1) - S.min_W
local bb = (S.y2 - S.y1 + 1) - S.min_H

    im:filledRectangle(x1,y1,x2,y2,
      sel(aa < 0 or bb < 0, blue,
      sel(aa > 4 or bb > 4, red,
      sel(aa > 2 or bb > 2, yellow, green))))

--      sel(S.room.mass > 3, yellow,
--      sel(S.room.mass < 1, blue, red)))

    for side=2,8,2 do
      local dx,dy = dir_to_delta(side)
      local N = get_seed_safe(x+dx,y-dy)
      local ax,ay, bx,by = side_coords(side, x1,y1, x2,y2)
      if (N and N.room == S.room) then
        im:filledRectangle(ax,ay, bx,by, black)
      else
        im:filledRectangle(ax,ay, bx,by, white)
      end
    end
  end

  for x = 1,SEEDS.w do for y = 1,SEEDS.h do
    local S = SEEDS[x][y]
    if S then
      draw_seed(x, y, S)
    end
  end end

  im:png(string.format("pics/%04d.png", RENDER_NUM))

  print("WROTE PIC", RENDER_NUM)
  print()

  RENDER_NUM = RENDER_NUM + 1

  im = nil ; collectgarbage("collect");

end
--]]


function Seed_grow()

  -- FIXME: ULTRA BASIC VERSION OF SEED_GROW

  for x = 1,SEED_W do for y = 1,SEED_H do for z = 1,SEED_D do

    local S = SEEDS[x][y][z]

    S.x1 = x * SEED_SIZE
    S.y1 = y * SEED_SIZE

    S.x2 = (x+1) * SEED_SIZE
    S.y2 = (y+1) * SEED_SIZE

  end end end --- x, y, z

  return
end


function TODO_REAL_Seed_grow()

-- TODO:  2. implement symmetry preservation

  local DIR
  local CHANGED

  local function get_width(S)
    return S.x2 - S.x1 + 1
  end
    
  local function get_height(S)
    return S.y2 - S.y1 + 1
  end

  local function same_room(S1, S2)
    return S1.room == S2.room
  end

  local function seed_new_pos(S)
    
    local x1,y1 = S.x1, S.y1
    local x2,y2 = S.x2, S.y2

    if S.grow then
          if DIR==2 then y1 = y1-1
      elseif DIR==8 then y2 = y2+1
      elseif DIR==4 then x1 = x1-1
      elseif DIR==6 then x2 = x2+1
      end
    end

    if S.shrink then
          if DIR==2 then y2 = y2-1
      elseif DIR==8 then y1 = y1+1
      elseif DIR==4 then x2 = x2-1
      elseif DIR==6 then x1 = x1+1
      end
    end

    return x1,y1, x2,y2
  end

  local function mark_grow(S)
    if S.grow then return end

    S.grow  = true
    CHANGED = true
  end

  local function mark_move(S)
    if S.grow and S.shrink then return end

    S.grow   = true
    S.shrink = true
    CHANGED  = true
  end

  local function mark_shrink(S)
    if S.shrink then return end

    S.shrink = true
    CHANGED  = true

    -- once a seed reaches its minimum size, never make it smaller.
    -- (It turns out that this check is very important).

    if DIR==4 or DIR==6 then
      if get_width(S)  <= S.min_W then S.grow = true end
    else
      if get_height(S) <= S.min_H then S.grow = true end
    end
  end

  local function check_for_overlap(S)

    local x1,y1, x2,y2 = S.x1, S.y1, S.x2, S.y2

    -- coordinates for just the "new growth"
        if DIR == 6 then x2 = x2 + 1 ; x1 = x2
    elseif DIR == 4 then x1 = x1 - 1 ; x2 = x1
    elseif DIR == 8 then y2 = y2 + 1 ; y1 = y2
    elseif DIR == 2 then y1 = y1 - 1 ; y2 = y1
    end
  
    -- FIXME: optimise, but how??
    for x = 1,SEEDS.w do for y = 1,SEEDS.h do
      local F = SEEDS[x][y]

      if F and F ~= S then
        if boxes_overlap(x1,y1, x2,y2, F.x1,F.y1, F.x2,F.y2) then
          mark_shrink(F)
        end
      end
    end end
  end

  local function link_cur_length(S, N)

    if DIR==4 or DIR==6 then
      return math.min(S.x2,N.x2) - math.max(S.x1,N.x1) + 1
    else
      return math.min(S.x2,N.x2) - math.max(S.x1,N.x1) + 1
    end
  end

  local function link_new_length(S, N)

    local sx1,sy1, sx2,sy2 = seed_new_pos(S)
    local nx1,ny1, nx2,ny2 = seed_new_pos(N)

    local low, high

    if DIR==4 or DIR==6 then
      return math.min(sx2,nx2) - math.max(sx1,nx1)
    else
      return math.min(sx2,nx2) - math.max(sx1,nx1)
    end
  end

  local function check_side_link(S, N, L)

    -- keep rooms in lock-step
    if same_room(S, N) then

      if S.grow ~= N.grow then
        mark_grow(sel(S.grow, N, S))
      end

      if S.shrink ~= N.shrink then
        mark_shrink(sel(S.shrink, N, S))
      end

      return
    end


    -- actually linked?
    if not L then return end

--!!!    -- both are stationary : nothing to do
--!!!    if not (S.grow or N.grow or S.shrink or N.shrink) then return end

    -- both are moving : nothing to do
    if S.grow and N.grow and S.shrink and N.shrink then return end


    -- for "low" and "high" WHERE values, we simply ensure that
    -- the corresponding side is lock-stepped.

    if (L.where == "low"  and (DIR==6 or DIR==8)) or
       (L.where == "high" and (DIR==4 or DIR==2))
    then
      if S.shrink ~= N.shrink then
        mark_shrink(sel(S.shrink, N, S))
      end
      return
    end

    if (L.where == "high" and (DIR==6 or DIR==8)) or
       (L.where == "low"  and (DIR==4 or DIR==2))
    then
      if S.grow ~= N.grow then
        mark_grow(sel(S.grow, N, S))
      end
      return
    end

    if L.where == "middle" then

      if S.shrink and S.grow then mark_move(N) ; return end
      if N.shrink and N.grow then mark_move(S) ; return end

      -- both are growing : not much we can do
      if S.grow and N.grow then return end

      -- Put the non-growing one into S.
      -- If neither are growing, then use the lightest one
      if S.grow or (not N.grow and S.room.mass < N.room.mass) then S,N = N,S end

      local s_add = sel(S.shrink or S.grow, 1, 0)
      local n_add = sel(N.shrink or N.grow, 1, 0)

      local diff

      if DIR==4 or DIR==6 then
        diff = (N.x1 + N.x2 + n_add) - (S.x1 + S.x2 + s_add)
      else
        diff = (N.y1 + N.y2 + n_add) - (S.y1 + S.y2 + s_add)
      end

      if DIR==4 or DIR==2 then diff = -diff end

      if diff >= 2 then
        mark_grow(S)
      end

      return
    end

    error("Link contains bad WHERE mode.")

--[[
    ---> "lazy" mode : only grow when necessary

    -- neither seeds are shrinking : nothing to do
    if not S.shrink and not N.shrink then return end

    -- both are growing : not much we can do
    if S.grow and N.grow then return end

    local long = link_new_length(S, N)

    if long < L.long then

      -- Put the non-growing one into S.
      -- If neither are growing, then use the lightest one
      if S.grow or (not N.grow and S.room.mass < N.room.mass) then S,N = N,S end

      mark_grow(S)
    end
--]]
  end

  local function check_back_link(S, B, L)

    -- actually linked?
    if not L and not same_room(S, B) then return end

    if S.shrink then mark_grow(B)   end

    -- the "B.grow" case already handled (in check_for_overlap)

  end

  local function maintain_links()

    local dx,dy = dir_to_delta(DIR)

    local side = sel(DIR==4 or DIR==6, 8, 6)
    local sdx, sdy = dir_to_delta(side)

    for x = 1,SEEDS.w do for y = 1,SEEDS.h do
      local S = SEEDS[x][y]
      if S then

        -- forwards
        if S.grow then
          check_for_overlap(S)
        end

        -- sideways
        local N = get_seed_safe(x+sdx, y+sdy)

        if N then
          local L = S.link[side]
          check_side_link(S, N, L)
        end

        -- backwards
        local B = get_seed_safe(x-dx, y-dy)

        if B then
          check_back_link(S, B, S.link[10-DIR])
        end

      end
    end end
  end

  local function maintain_symmetry()

    --!!! FIXME maintain_symmetry

    -- FIXME: support "symmetric" links (L.twin ??)
  end

  local function do_grow(S)
        if DIR==2 then S.y1 = S.y1-1
    elseif DIR==8 then S.y2 = S.y2+1
    elseif DIR==4 then S.x1 = S.x1-1
    elseif DIR==6 then S.x2 = S.x2+1
    end

    S.grow = nil
  end

  local function do_shrink(S)
        if DIR==2 then S.y2 = S.y2-1
    elseif DIR==8 then S.y1 = S.y1+1
    elseif DIR==4 then S.x2 = S.x2-1
    elseif DIR==6 then S.x1 = S.x1+1
    end

    S.shrink = nil
  end

  local GROW_CHANCE   = { 25, 37, 50, 75, 99 }
  local SHRINK_CHANCE = {  5, 10, 15, 25, 50 }
 
  local function select_growers()

    for x = 1,SEEDS.w do for y = 1,SEEDS.h do
      local S = SEEDS[x][y]
      if S then
        
        local w = get_width(S)
        local h = get_height(S)

        local diff  = S.min_W - w
        local other = S.min_H - h

        if (DIR==2 or DIR==8) then diff,other = other,diff end

        if sel(DIR==4 or DIR==6, S.min_W, S.min_H) < 3 then
          mark_grow(S)

        elseif diff > 0 and rand_odds(GROW_CHANCE[math.min(diff,5)]) then
          mark_grow(S)

        elseif diff < 0 and rand_odds(SHRINK_CHANCE[math.min(-diff,5)]) then
          mark_shrink(S)

        end

---#        if force then
---#          mark_grow(S)
---#        elseif diff > 0 then
---#          local chance = 33
---#          if diff >= 2 then chance = 66 end
---#          if diff >= 4 then chance = 99 end
---#
---#          if true then --!!! rand_odds(chance) then
---#            mark_grow(S)
---#          end
---#        end

      end
    end end
  end

  local function perform_pass(cur_dir)

    DIR = cur_dir
--print("perform_pass: DIR=", DIR)
     
    select_growers()

    repeat
      CHANGED = false

      maintain_links()
      maintain_symmetry()

    until not CHANGED

    for x = 1,SEEDS.w do for y = 1,SEEDS.h do
      local S = SEEDS[x][y]

      if S and S.grow   then do_grow(S)   end
      if S and S.shrink then do_shrink(S) end
    end end
  end

  local function initialise_seeds()

    -- initialize all seeds, aligned to a 3x3 grid

    for x = 1,SEEDS.w do for y = 1,SEEDS.h do
      local S = SEEDS[x][y]
      if S then
        S.sx, S.sy = x, y

        S.x1, S.y1 = x*3+0, y*3+0
        S.x2, S.y2 = x*3+2, y*3+2

---     S.grow   = { [2]=0, [4]=0, [6]=0, [8]=0 }
---     S.shrink = { [2]=0, [4]=0, [6]=0, [8]=0 }
      end
    end end
  end

  local function is_finished()

    for x = 1,SEEDS.w do for y = 1,SEEDS.h do
      local S = SEEDS[x][y]
      if S then
        if get_width (S) < S.min_W then return false end
        if get_height(S) < S.min_H then return false end
      end
    end end

    return true
  end

  local function adjust_coordinates()

    -- make sure seeds have valid block ranges
    -- (in particular: negative coords are not allowed).

    local min_x = 999
    local min_y = 999

    for x = 1,SEEDS.w do for y = 1,SEEDS.h do
      local S = SEEDS[x][y]

      if S then
        S.w = get_width(S)
        S.h = get_height(S)

        min_x = math.min(min_x, S.x1)
        min_y = math.min(min_y, S.y1)

        -- sanity checking
        assert(S.w >= S.min_W)
        assert(S.h >= S.min_H)

        local N = SEEDS[x+1] and SEEDS[x+1][y]
--!!!        if N then assert(S.x2 < N.x1) end

        N = SEEDS[x][y+1]
--!!!        if N then assert(S.y2 < N.y1) end
      end

    end end

    min_x = min_x-1
    min_y = min_y-1

    for x = 1,SEEDS.w do for y = 1,SEEDS.h do
      local S = SEEDS[x][y]
      if S then
        S.x1 = S.x1 - min_x
        S.y1 = S.y1 - min_y

        S.x2 = S.x2 - min_x
        S.y2 = S.y2 - min_y
      end
    end end
  end


  ----===| grow_seeds |===----


  initialise_seeds()

  -- perform growth passes until every seed is full-sized
  local SIDES = { 2,4,6,8 }

  repeat
    --debug_render()

    rand_shuffle(SIDES)

    for zzz,side in ipairs(SIDES) do
      perform_pass(side)
    end

  until is_finished()

  --debug_render()

  adjust_coordinates();

end -- grow_seeds


function test_grow_all()

  print("test_grow_all...")

  SEEDS = array_2D(16,12)

  local function add_room(room, sx, sy, sw, sh)
    sw = sw or 1
    sh = sh or 1
    
    for x = sx,sx+sw-1,1 do
      for y = sy,sy+sh-1,1 do
        assert(not SEEDS[x][y])
        SEEDS[x][y] = { sx=x, sy=y, room=room,
                        min_W=room.size, min_H=room.size,
                        link={}
                      }
      end
    end
  end

  local function add_link(sx, sy, ex, ey, long, where)
    long  = long or 3
    where = where or "lax"

    local dir = delta_to_dir(ex-sx, ey-sy)
    assert(dir==2 or dir==4 or dir==6 or dir==8)

    local S = SEEDS[sx][sy] ; assert(S)
    local N = SEEDS[ex][ey] ; assert(N)

    local L = { where=where, long=long }

    S.link[dir] = L
    N.link[10-dir] = L

    L.seeds = { S, N }
  end


  -- rooms

  local r1 = { mass=6.5, size=4 }
  local r2 = { mass=4.3, size=9 }

  local r3 = { mass=2.8, size=11 }
  local r4 = { mass=1.3, size=6 }
  local r5 = { mass=1.3, size=10 }

  local r6 = { mass=1.2, size=8 }
  local r7 = { mass=1.9, size=6 }
  local r8 = { mass=1.5, size=9 }

  add_room(r1, 4,3, 2,3)
  add_room(r2, 1,3, 2,2)

  add_room(r3, 3,4)
  add_room(r4, 1,5)
  add_room(r5, 2,2)

  add_room(r6, 5,1)
  add_room(r7, 6,1)
  add_room(r8, 7,6)


  -- halls

  local h1  = { mass=0.5, size=3, max=4 }
  local h1x = { mass=0.1, size=3 }
  local h2  = { mass=0.5, size=3, max=4 }
  local h2x = { mass=0.1, size=3 }
  local h3  = { mass=0.5, size=3 }

  local h4 = { mass=0.5, size=5 }
  local h5 = { mass=0.5, size=3 }
  local h6 = { mass=0.5, size=3 }

  add_room(h1,  3,5, 1,2)
  add_room(h1x, 4,6)

  add_room(h2,  3,2, 1,2)
  add_room(h2x, 4,2)

  add_room(h3, 1,2)
  add_room(h4, 2,1, 3,1)
  add_room(h5, 6,5, 1,2)
  add_room(h6, 6,2, 1,2)


  -- linkage

  add_link(3,4, 4,4, 5, "middle")
  add_link(4,5, 4,6, nil, "high")
  add_link(4,3, 4,2, nil, "high")
  add_link(5,5, 6,5, 2)
  add_link(5,3, 6,3, 2)

  add_link(1,4, 1,5)
  add_link(1,3, 1,2)
  add_link(2,4, 3,4)
  add_link(2,2, 2,3, 6)

  add_link(3,6, 4,6, nil, "high")
  add_link(3,2, 4,2, nil, "low")

  add_link(3,4, 3,5, nil, "middle")
  add_link(3,4, 3,3, nil, "middle")

  add_link(2,2, 1,2)
  add_link(2,2, 2,1)

  add_link(5,1, 4,1, nil)
  add_link(5,1, 6,1)
  add_link(6,1, 6,2)

  add_link(7,6, 6,6)


  grow_seeds()
end


------------------------------------------------------------------------

MIN_Z = -2048
MAX_Z =  2048

PAD = 0

function get_seed_wall(S, side)
  
  if side == 4 then
    return
    {
      { x = S.x1-PAD,  y = S.y1-PAD },
      { x = S.x1-PAD,  y = S.y2+PAD },
      { x = S.x1+16,   y = S.y2+PAD },
      { x = S.x1+16,   y = S.y1-PAD },
    }
  end

  if side == 6 then
    return
    {
      { x = S.x2+PAD,  y = S.y2+PAD },
      { x = S.x2+PAD,  y = S.y1-PAD },
      { x = S.x2-16,   y = S.y1-PAD },
      { x = S.x2-16,   y = S.y2+PAD },
    }
  end

  if side == 2 then
    return
    {
      { x = S.x2+PAD, y = S.y1 },
      { x = S.x1-PAD, y = S.y1 },
      { x = S.x1-PAD, y = S.y1+16 },
      { x = S.x2+PAD, y = S.y1+16 },
    }
  end

  if side == 8 then
    return
    {
      { x = S.x1-PAD, y = S.y2+PAD },
      { x = S.x2+PAD, y = S.y2+PAD },
      { x = S.x2+PAD, y = S.y2-16 },
      { x = S.x1-PAD, y = S.y2-16 },
    }
  end

  error("BAD SIDE for get_seed_wall: " .. tostring(side))
end

function render_seed(S)
  
  if S.kind == "solid" then return end

  local tex = "rock1_2" -- "STARTAN3"

  if S.z1 > 100 then tex = "tech01_1"  end
  if S.z1 > 200 then tex = "ground1_1" end

  -- floor
  if S.kind == "walkway" then
    gui.add_brush(
    {
      t_face = { texture=tex },
      b_face = { texture=tex },
      w_face = { texture=tex },
    },
    {
      { x = S.x1, y = S.y1 },
      { x = S.x1, y = S.y2 },
      { x = S.x2, y = S.y2 },
      { x = S.x2, y = S.y1 },
    },
    S.z1-PAD, S.z1+16)
  end

  -- ceiling
  if not S.link[9] or
     (S.link[9].src == S and S.link[9].dest.kind == "solid") or
     (S.link[9].dest == S and S.link[9].src.kind == "solid")
  then
    
    gui.add_brush(
    {
      t_face = { texture=tex },
      b_face = { texture=tex },
      w_face = { texture=tex },
    },
    {
      { x = S.x1, y = S.y1 },
      { x = S.x1, y = S.y2 },
      { x = S.x2, y = S.y2 },
      { x = S.x2, y = S.y1 },
    },
    S.z2-16, S.z2+PAD)
  end

  -- walls
  for side = 2,8,2 do
    local L = S.link[side]
    local other
    if L then other = assert(sel(S == L.src, L.dest, L.src)) end
    
    if not L or other.kind == "solid" then
    
      gui.add_brush(
      {
        t_face = { texture=tex },
        b_face = { texture=tex },
        w_face = { texture=tex },
      },
      get_seed_wall(S, side),
      S.z1-PAD, S.z2+PAD)
    end
  end
end


function test_grow_3D()

  print("test_grow_3D...")

  SEED_LIST = {}
  SEED_MAP  = {}


  local function coord_key(x, y, z)
    return tostring(10+x) .. tostring(10+y) .. tostring(10+z)
  end

  local function add_seed(x, y, z, rm, f_h, c_h, kind)

    if not kind then kind = "walkway" end
    
    local S =
    {
      sx = x, sy = y, sz = z,

      -- hard code the coordinates (NOT GROWN)
      x1 = x*192, y1=y*192, z1=f_h,
      x2 = (x+1)*192, y2=(y+1)*192, z2=c_h,

---   f_h = f_h, c_h = c_h,

      room = rm, kind = kind,

      link = {}
    }

    if SEED_MAP[coord_key(x,y,z)] then
      error(string.format("Seed already exists at %d,%d,%d", x,y,z))
    end

    SEED_MAP[coord_key(x,y,z)] = S

    table.insert(SEED_LIST, S)
  end

  local function add_link(x1,y1,z1, x2,y2,z2)

    local dx = math.abs(x2-x1)
    local dy = math.abs(y2-y1)
    local dz = math.abs(z2-z1)

    assert( (dx==0 and dy==0 and dz==1) or
            (dx==0 and dy==1 and dz==0) or
            (dx==1 and dy==0 and dz==0))

    local S = SEED_MAP[coord_key(x1,y1,z1)]
    local T = SEED_MAP[coord_key(x2,y2,z2)]

    if not S then error(string.format("No such source for link: %d,%d,%d", x1,y1,z1)) end
    if not T then error(string.format("No such dest for link: %d,%d,%d", x2,y2,z2)) end

    local dir
        if (dx == 1) then dir = sel(x1 > x2, 4, 6)
    elseif (dy == 1) then dir = sel(y1 > y2, 2, 8)
    else                  dir = sel(z1 > z2, 1, 9)
    end

    local tdir = 10 - dir

    assert(not S.link[dir])
    assert(not T.link[tdir])

    local LINK =
    {
      src = S, dest = T,
      kind = "empty"
    }

    S.link[dir]  = LINK
    T.link[tdir] = LINK
  end


  -- rooms --

  local room = { mass=6.0, f_h=0, c_h=384 }

  local h_green = { mass=1.0, f_h=0,   c_h=128 }
  local h_blue  = { mass=1.0, f_h=128, c_h=256 }
  local h_red   = { mass=1.0, f_h=256, c_h=384 }

  -- seeds --

  -- GREEN:
  add_seed(3,3,1, room, 0,128)
  add_seed(4,3,1, room, 0,128)
  add_seed(5,3,1, room, 0,128)
  --
  add_seed(3,4,1, room, 0,128)
  add_seed(4,4,1, room, 0,128, "solid")
  add_seed(5,4,1, room, 0,128)
  --
  add_seed(3,5,1, room, 0,128)
  add_seed(4,5,1, room, 0,128)
  add_seed(5,5,1, room, 0,128)
  --
  add_seed(2,5,1, h_green, 0,128)
  add_seed(6,5,1, h_green, 0,128)

  -- BLUE:
  add_seed(1,3,2, h_blue, 128,256) 
  add_seed(2,3,2, h_blue, 128,256)
  add_seed(6,3,2, h_blue, 128,256)
  add_seed(7,3,2, h_blue, 128,256)
  --
  add_seed(3,3,2, room, 128,256)
  add_seed(4,3,2, room, 128,256,"solid")
  add_seed(5,3,2, room, 128,256)
  --
  add_seed(3,4,2, room, 128,256)
  add_seed(4,4,2, room, 128,256)
  add_seed(5,4,2, room, 128,256)
  --
  add_seed(3,5,2, room, 128,256,"empty")
  add_seed(4,5,2, room, 128,256)
  add_seed(5,5,2, room, 128,256,"empty")
  --
  add_seed(4,6,2, h_blue, 128,256)
  add_seed(4,7,2, h_blue, 128,256)
  
  -- RED:
  add_seed(4,1,3, h_red, 256,364)
  add_seed(4,2,3, h_red, 256,364)
  --
  add_seed(3,3,3, room, 256,384)
  add_seed(4,3,3, room, 256,384)
  add_seed(5,3,3, room, 256,384)
  --
  add_seed(3,4,3, room, 256,384,"empty")
  add_seed(4,4,3, room, 256,384,"empty")
  add_seed(5,4,3, room, 256,384,"empty")
  --
  add_seed(3,5,3, room, 256,384,"empty")
  add_seed(4,5,3, room, 256,384,"empty")
  add_seed(5,5,3, room, 256,384,"empty")


  -- links --

  -- ROOM
  for x = 3,5 do for y = 3,5 do for z = 1,3 do
    if (x < 5) then
      add_link(x,y,z, x+1,y,z)
    end
    if (y < 5) then
      add_link(x,y,z, x,y+1,z)
    end
    if (z < 3) then
      add_link(x,y,z, x,y,z+1)
    end
  end end end

  -- BLUE
  add_link(1,3,2, 2,3,2)
  add_link(2,3,2, 3,3,2)
  
  add_link(5,3,2, 6,3,2)
  add_link(6,3,2, 7,3,2)
  
  add_link(4,5,2, 4,6,2)
  add_link(4,6,2, 4,7,2)

  -- GREEN
  add_link(2,5,1, 3,5,1)
  add_link(5,5,1, 6,5,1)

  -- RED
  add_link(4,1,3, 4,2,3)
  add_link(4,2,3, 4,3,3)


  -- convert seeds into brushes

  for zzz,S in ipairs(SEED_LIST) do
    render_seed(S)
  end

  gui.add_entity("info_player_start", 800, 800, 260)
---!!!  gui.add_entity("1", 800, 800, 260)
end


--[[
math.randomseed(1)

test_grow_3D()
--]]
