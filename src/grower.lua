----------------------------------------------------------------
-- GROWER
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


-- TODO:  1. fix the "middle" link mode
-- TODO:  2. implement symmetry preservation
-- TODO:  3. tidy up


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


-- [[
require 'gd'

RENDER_NUM = 1

function debug_render_seeds()

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
      sel(aa > 5 or bb > 5, red,
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


function grow_all()

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

--!!!!!    -- both are stationary : nothing to do
--!!!!!    if not (S.grow or N.grow or S.shrink or N.shrink) then return end

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

    --!!!! FIXME maintain_symmetry

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
---#          if true then --!!!!!! rand_odds(chance) then
---#            mark_grow(S)
---#          end
---#        end

      end
    end end
  end

  local function perform_pass(cur_dir)

    DIR = cur_dir
print("perform_pass: DIR=", DIR)
     
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
--!!!!!!        if N then assert(S.x2 < N.x1) end

        N = SEEDS[x][y+1]
--!!!!!!        if N then assert(S.y2 < N.y1) end
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


  ----===| grow_all |===----


  initialise_seeds()

  -- perform growth passes until every seed is full-sized
  local SIDES = { 2,4,6,8 }

  local extra = 0

  repeat
debug_render_seeds()

    rand_shuffle(SIDES)

    for zzz,side in ipairs(SIDES) do
      perform_pass(side)
    end

    if is_finished() then extra = extra + 1 end

  until extra >= 4

debug_render_seeds()
  adjust_coordinates();

end -- grow_all


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
    where = where or "low"

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

  add_link(5,1, 4,1)
  add_link(5,1, 6,1, 4)
  add_link(6,1, 6,2)

  add_link(7,6, 6,6)


  grow_all()
end


math.randomseed(2)

test_grow_all()

