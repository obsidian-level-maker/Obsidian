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

function grow_all(SEEDS)

  local DIR

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

  local function mark_seed(S, dir, mode)

    -- we also mark all the seeds in the same room and column/row
    local friends = { S }

    local ax,ay = dir_to_across(dir)

    for dist = 1,20 do for sign = -1,1,2 do
      local nx = S.sx + ax*dist*sign
      local ny = S.sy + ay*dist*sign

      local N = valid_seed(nx,ny) and SEEDS[nx][ny]
      if N and same_room(S, N) then
        table.insert(friends, N)
      end
    end end

    if mode == "shrink" then
      for zzz,T in ipairs(friends) do
        T.shrink[dir] = T.shrink[dir] + 1

---        if T.twin and not same_room(T.twin, T) then
---          T.twin.shrink[10-dir] = T.twin.shrink[10-dir] + 1
---        end

        if T.cur_W <= T.min_W then
          mode = "grow"
        end
      end
    end

    if mode == "grow" then
      for zzz,T in ipairs(friends) do
        T.grow[dir] = T.grow[dir] + 1

---        if T.twin then
---          T.twin.grow[10-dir] = T.twin.grow[10-dir] + 1
---        end

      end
    end
  end

--[[
  local function mark_seed(S, dir, mode)
    table.insert(MARKAGE, { S=S, dir=dir, mode=mode })
  end

  local function apply_markage()
    for zzz, M in ipairs(MARKAGE) do
      mark_seed(M.S, M.dir, M.mode)
    end

    MARKAGE = {}
  end
--]]

  local function maintain_link(S, L, dir, mode)

    N = get_neighbour(L, S)

    s1,s2 = S.pos[10-dir], S.pos[dir]
    if mode == "grow" then s2 += 1 else s1 += 1 end

    n1, n2 = N.pos[10-dir], N.pos[dir]
    
    b1 = math.max(s1,n1)
    b2 = math.min(s2,n2)

    long = (b2-b1+1)

    -- FIXME: need better ways specifying WHERE the link occurs

    if long < L.long or rand_odds(33) then
      mark_seed(N, dir, "grow")
    end
  end

  local function do_growth(S)

        if DIR==2 then S.y1 = S.y1-1
    elseif DIR==8 then S.y2 = S.y2+1
    elseif DIR==4 then S.x1 = S.x1-1
    elseif DIR==6 then S.x2 = S.x2+1
    end

    for x = 1,SEEDS.w do for y = 1,SEEDS.h do
      local T = SEEDS[x][y]
      if T and overlaps(S, T) then
        -- TODO: optimise when N.shrink[dir]  -- possible???
        mark_seed(T, DIR, "shrink")
      end
    end

    for L in S.links do
      N = get_neighbour(L, S)
      if dir_is_perp(L_dir, DIR) and not same_room(N,S) then
        maintain_link(S, L, DIR, "grow")
      end
    end

    return true
  end

  local function do_shrink(S)

        if DIR==2 then S.y2 = S.y2-1
    elseif DIR==8 then S.y1 = S.y1+1
    elseif DIR==4 then S.x2 = S.x2-1
    elseif DIR==6 then S.x1 = S.x1+1
    end

    for L in S.links do
      N = get_neighbour(L, S)

      if L_dir == DIR then
        -- no problem
      elseif L_dir == 10-DIR then
        mark_seed(N, DIR, "grow")
        if get_width(N) >= N.min_W and rand_odds(XXX) then
          mark_seed(N, DIR, "shrink")
        end
      elseif same_room(L, N) then
        mark_seed(N, DIR, "shrink") @@@
      elseif not same_room(L, N) then   -- HMMM link implies !same_room ???
        -- perpendicular
        maintain_link(S, L, DIR, "shrink")
      end
    end

    return true
  end

  local function perform_pass(cur_dir)

    DIR = cur_dir
     
    -- 1. mark which seeds we want to grow in this pass

    visit_list = {}

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
            mark_seed(S, DIR, "grow")
            table.insert(grow_list, {S=S, dir=DIR, mode="grow"})
          end
        end

      end
    end end

    -- 2. repeat the growth spurts until all done

    local done

    local a_max, b_max = SEEDS.w, SEEDS.h
    if (DIR==2 or DIR==8) then
      a_max, b_max = SEEDS.h, SEEDS.w
    end

    local function collect(mode)
      local result = {}

      for x = 1,SEEDS.w do for y = 1,SEEDS.h do
        local S = SEEDS[x][y]
        if S and S[mode][DIR] > 0 then
          table.insert(result, S)
          S[mode][DIR] = S[mode][DIR] - 1
        end
      end end

      return result
    end
    
    local function growth_spurt()
      done = true
      for pass = 1,2 do
        local list = collect(sel(pass==1, "grow", "shrink"))

        --???  sort list

        for zzz,S in ipairs(list) do
            if pass==1 then
              if do_growth(S) then done=false end
            else
              if do_shrink(S) then done=false end
            end
        end

--[[
        for a = 1,a_max do for b = 1,b_max do

          local x,y = a,b
          if (DIR==2 or DIR==8) then y,x = a,b end

          if (DIR==6 or DIR==8) then
            x = SEED.w+1-x ; y = SEED.h+1-y
          end

          local S = SEEDS[x][y] 
          if S then
            if pass==1 then
              if do_growth(S) then done=false end
            else
              if do_shrink(S) then done=false end
            end
          end

        end end -- a,b
--]]

      end -- pass
    end

    repeat growth_spurt() until done
  end

  local function initialise_seeds()

    -- initialize all seeds, aligned to a 3x3 grid

    for x = 1,SEEDS.w do for y = 1,SEEDS.h do
      local S = SEEDS[x][y]
      if S then
        S.x1, S.y1 = x*3+0, y*3+0
        S.x2, S.y2 = x*3+2, y*3+2

        S.grow   = { [2]=0, [4]=0, [6]=0, [8]=0 }
        S.shrink = { [2]=0, [4]=0, [6]=0, [8]=0 }
      end
    end end
  end

  local function is_finished()

    for x = 1,SEEDS.w do for y = 1,SEEDS.h do
      local S = SEEDS[x][y]
      if S then
        if get_width (S) < S.min_W then return false end
        if get_height(S) < S.min_H then return false end

        for dir = 2,8,2 do
          if S.grow[dir]   > 0 then return false end
          if S.shrink[dir] > 0 then return false end
        end
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
    for loop = 1,4 do
      rand_shuffle(SIDES)
      for zzz,side in ipairs(SIDES) do
        perform_pass(side)
      end
    end
  until is_finished()

  adjust_coordinates();

end -- grow_all

