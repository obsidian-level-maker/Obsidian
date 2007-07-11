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

function grow_all(ROOMS, SEEDS)

  local DIR

  local function mark_seed(S, dir, mode)

    friends = list of seeds in same room and same column of S
    
    if mode == "grow" then

    for S2 in friends do
      S2.grow[dir] = true
    end

    elseif mode == "shrink" then

      must_grow = false
      
      for S2 in friends do
        S2.shrink[dir] = true

        if S2.cur_W <= S2.min_W then
          must_grow = true
        end
      end

      if must_grow then
        for S2 in friends do
          S2.grow[dir] = true
        end
      end

    else
      error("mark_seed: unknown mode: " .. tostring(mode))
    end
  end

  local function maintain_link(S, L, dir, mode)

    N = get_neighbour(L, S)

    s1,s2 = S.pos[10-dir], S.pos[dir]
    if mode == "grow" then s2 += 1 else s1 += 1 end

    n1, n2 = N.pos[10-dir], N.pos[dir]
    
    b1 = math.max(s1,n1)
    b2 = math.min(s2,n2)

    long = (b2-b1+1)

    -- FIXME: need better ways specifying WHERE the link occurs

    if long < L.long then
      mark_seed(N, dir, "grow")
    end
  end

  local function do_grow(S, dir)

    S.pos[dir] += 1

    for N in all ROOMS do
      if overlaps(R, N) then
        -- TODO: optimise when N.shrink[dir]  -- possible???
        mark_seed(N, dir, "shrink")
      end
    end

    for L in S.links do
      N = get_neighbour(L, S)
      if dir_is_perp(L_dir, dir) and not same_room(N,S) then
        maintain_link(S, L, dir, "grow")
      end
    end
  end

  local function do_shrink(S, dir)

    S.pos[10-dir] += 1

    for L in S.links do
      N = get_neighbour(L, S)

      if L_dir == dir then
        -- no problem
      elseif L_dir == 10-dir then
        mark_seed(N, dir, "grow")
        if get_width(N) >= N.min_W and rand_odds(XXX) then
          mark_seed(N, dir, "shrink")
        end
      elseif not same_room(L, N) then   -- HMMM link implies !same_room ???
        -- perpendicular
        maintain_link(S, L, dir, "shrink")
      end
    end
    
  end

  local function perform_pass(cur_dir)

    DIR = cur_dir
      
    for R in all ROOMS do
      if get_width(R) < R.min_W then
        if rand_odds(XXXX) then  -- chance of growing in this pass
          S = XXX -- pick one of the seeds in the room
          mark_seed(S, dir, "grow")
        end
      end
    end

    seeds = list of all seeds sorted along (10-dir) direction
            (e.g. if dir=6 then rightmost rooms are first)

    done = true

    repeat
      for S in seeds do
        if S.grow[dir] then do_grow(S, dir) ; done=false end
      end
      for S in seeds do
        if S.shrink[dir] then do_shrink(S, dir); done=false end
      end
    until done
  end

  local function is_finished()

    for x = 1,SEEDS.w do for y = 1,SEEDS.h do
      local S = SEEDS[y][x]
      if S then
        if (S.x2 - S.x1 + 1) < S.min_W then return false end
        if (S.y2 - S.y1 + 1) < S.min_H then return false end

        for dir = 2,8,2 do
          if S.grow[dir]   then return false end
          if S.shrink[dir] then return false end
        end
      end
    end end

    return true
  end

  local function initialise_seeds()

    -- initialize all seeds, aligned to a 3x3 grid

    for x = 1,SEEDS.w do for y = 1,SEEDS.h do
      local S = SEEDS[y][x]
      if S then
        S.x1, S.y1 = x*3+0, y*3+0
        S.x2, S.y2 = x*3+2, y*3+2

        S.grow = {}
        S.shrink = {}
      end
    end end
  end

  local function adjust_coordinates()

    -- make sure seeds have valid block ranges
    -- (in particular: zero or negative is not allowed).

    local min_x = 999
    local min_y = 999

    for x = 1,SEEDS.w do for y = 1,SEEDS.h do
      local S = SEEDS[y][x]

      if S then
        S.w = S.x2 - S.x1 + 1
        S.h = S.y2 - S.y1 + 1

        min_x = math.min(min_x, S.x1)
        min_y = math.min(min_y, S.y1)

        -- sanity checking
        assert(S.w >= S.min_W and S.h >= S.min_H)

        local N = SEEDS[y][x+1]
        if N then assert(S.x2 < N.x1) end

        N = SEEDS[y+1] and SEEDS[y+1][x]
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


  ---==| grow_all |==---

  initialise_seeds()

  -- perform growth passes until every seed is full-sized
  local SIDES = { 2,4,6,8 }

  repeat
    for loop = 1,3 do
      randle_shuffle(SIDES)
      for zzz,side in ipairs(SIDES) do
        perform_pass(side)
      end
    end
  until is_finished()

  adjust_coordinates();

end -- grow_all

