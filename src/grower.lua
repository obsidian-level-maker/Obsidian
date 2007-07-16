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

require 'defs'

-- FIXME: temp stuff for util module
con = { }
function con.ticker() end
function con.abort() return false end
function con.rand_seed(value) math.randomseed(value) end
function con.random() return math.random() end


require 'util'


-- [[
require 'gd'

RENDER_NUM = 1

function debug_render_seeds(SEEDS)

  local im = gd.createTrueColor(500, 500);

  local black = im:colorAllocate(0, 0, 0);
  local white = im:colorAllocate(255, 255, 255);

  local red    = im:colorAllocate(255, 0, 0);
  local blue   = im:colorAllocate(0, 0, 255);
  local purple = im:colorAllocate(255, 0, 255);

  im:filledRectangle(0, 0, 500, 500, black);

  im:png(string.format("seeds%d.png", RENDER_NUM))

  for x = 1,SEEDS.w do for y = 1,SEEDS.h do
    local S = SEEDS[x][y]
    if S then
      -- FIXME....
    end
  end end

  RENDER_NUM = RENDER_NUM + 1
end
--]]


function grow_all(SEEDS)

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

  local function valid_seed(sx, sy)
    return sx >= 1 and sx <= SEEDS.w and sy >= 1 and sy <= SEEDS.h
  end

  local function get_seed_safe(sx, sy)
    return valid_seed(sx, sy) and SEEDS[sx][sy]
  end

  local function seed_new_size(S)
    
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
    S.grow  = true
    CHANGED = true
  end

  local function mark_shrink(S)
    S.shrink = true
    CHANGED  = true

    if DIR==4 or DIR==6 then
      if get_width(S) <= S.min_W then
        S.grow = true
      end
    else -- DIR==2 or DIR==8
      if get_height(S) <= S.min_H then
        S.grow = true
      end
    end
  end

  local function growth_overlap(G, T)

    local x1,y1, x2,y2 = G.x1, G.y1, G.x2, G.y2

    -- coordinates for just the "new growth"
        if DIR == 6 then x2 = x2 + 1 ; x1 = x2
    elseif DIR == 4 then x1 = x1 - 1 ; x2 = x1
    elseif DIR == 8 then y2 = y2 + 1 ; y1 = y2
    elseif DIR == 2 then y1 = y1 - 1 ; y2 = y1
    end
  
    return boxes_overlap(x1,y1, x2,y2, T.x1,T.y1, T.x2,T.y2)
  end

  local function check_for_overlap(S)

    -- FIXME: optimise, but how??
    for x = 1,SEEDS.w do for y = 1,SEEDS.h do
      local F = SEEDS[x][y]

      if F and F ~= S then
        if growth_overlap(S, F) then
          mark_shrink(F)
        end
      end
    end end
  end

  local function link_cur_long(S, N)
    if DIR == 4 or DIR == 6 then

      local x1 = math.max(S.x1, N.x1)
      local x2 = math.min(S.x2, N.x2)

      assert(x2 >= x1)

      return x2 - x1 + 1
    else

      local y1 = math.max(S.y1, N.y1)
      local y2 = math.min(S.y2, N.y2)

      assert(y2 >= y1)

      return y2 - y1 + 1
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

    -- both are stationary : nothing to do
    if not (S.grow or N.grow or S.shrink or N.shrink) then return end

    -- both are moving : nothing to do
    if S.grow and N.grow and S.shrink and N.shrink then return end

    -- both are growing : not a lot we can do
    if S.grow and N.grow then return end

    if not (S.shrink or N.shrink) then
      assert(S.grow or N.grow)

      -- FIXME: more to do here
      ----> need better ways specifying WHERE the link occurs

      return  -- overlap is not shrinking
    end

    -- at least one seed is shrinking : move it to S

    if not S.shrink then S,N = N,S end
    assert(S.shrink)

    @@@

    -- figure out overlap (after grow/shrink)
    local cur_long = link_cur_long(S, N)
    --FIXME !!! take new sizes into account

    if cur_long < L.long then
      S.grow = S.grow or N.grow   --- ???
      N.grow = S.grow
    end

    if N.mass > S.mass then S,N = N,S end

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
  end

  local function do_shrink(S)
        if DIR==2 then S.y2 = S.y2-1
    elseif DIR==8 then S.y1 = S.y1+1
    elseif DIR==4 then S.x2 = S.x2-1
    elseif DIR==6 then S.x1 = S.x1+1
    end
  end

  local function select_growers()

    for x = 1,SEEDS.w do for y = 1,SEEDS.h do
      local S = SEEDS[x][y]
      if S then
        
        local diff
        if (DIR==4 or DIR==6) then
          diff = S.min_W - get_width(S)
        else
          diff = S.min_H - get_height(S)
        end

        if diff > 0 then
          local chance = 33
          if diff >= 2 then chance = 66 end
          if diff >= 4 then chance = 99 end

          if rand_odds(chance) then
            mark_grow(S)
          end
        end

      end
    end end
  end

  local function perform_pass(cur_dir)

    DIR = cur_dir
     
    select_growers()

    repeat
      CHANGED = false

      maintain_links()
      maintain_symmetry()
    until not CHANGED

    for x = 1,SEEDS.w do for y = 1,SEEDS.h do
      local S = SEEDS[x][y]

      if S and S.grow   then do_grow(S)   ; S.grow   = nil end
      if S and S.shrink then do_shrink(S) ; S.shrink = nil end
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
        if N then assert(S.x2 < N.x1) end

        N = SEEDS[x][y+1]
        if N then assert(S.y2 < N.y1) end
      end

    end end

    min_x = min_x-1
    min_y = min_y-1

    for x = 1,SEEDS.w do for y = 1,SEEDS.h do
      S.x1 = S.x1 - min_x
      S.y1 = S.y1 - min_y

      S.x2 = S.x2 - min_x
      S.y2 = S.y2 - min_y
    end end
  end


  ----===| grow_all |===----


  initialise_seeds()

  -- perform growth passes until every seed is full-sized
  local SIDES = { 2,4,6,8 }

  repeat
    debug_render_seeds()

    rand_shuffle(SIDES)

    for zzz,side in ipairs(SIDES) do
      perform_pass(side)
    end

  until is_finished()

  adjust_coordinates();

end -- grow_all


function test_grow_all()

  print("test_grow_all...")

  local seeds = array_2D(16,12)

  grow_all(seeds)
end


math.randomseed(1)

test_grow_all()

