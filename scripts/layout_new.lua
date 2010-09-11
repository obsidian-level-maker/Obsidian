----------------------------------------------------------------
--  Layouting Logic
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2010 Andrew Apted
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
require 'util'


function Layout_prepare_room(R)
  R.spaces = {}

  local function block_is_contig(kx1, ky1, kw, kh)
    local kx2 = kx1 + kw - 1
    local ky2 = ky1 + kh - 1

    if kx2 > R.kx2 or ky2 > R.ky2 then
      return false
    end

    for x = kx1,kx2 do for y = ky1,ky2 do
      local K = SECTIONS[x][y]
      if K.room ~= R then return false end
      if K.contig_used then return false end
    end end

    return true
  end

  local function biggest_block(x, y)
    local kw, kh = 1,1

    while true do
      if block_is_contig(x, y, kw+1, kh) then
        kw = kw + 1
      elseif block_is_contig(x, y, kw, kh+1) then
        kh = kh + 1
      else
        return kw, kh
      end
    end
  end

  local function mark_block(x, y, kw, kh)
    for dx = 0,kw-1 do for dy = 0,kh-1 do
      SECTIONS[x+dx][y+dy].contig_used = true
    end end
  end

  --| Layout_prepare_room |--

  for x = R.kx1,R.kx2 do for y = R.ky1,R.ky2 do
    local K = SECTIONS[x][y]
    if K.room == R and not K.contig_used then
      
      local kw,kh = biggest_block(x, y)

      local SPACE =
      {
        free = true,
        x1 = K.x1, y1 = K.y1,
        x2 = SECTIONS[x + kw - 1][y].x2,
        y2 = SECTIONS[x][y + kh - 1].y2,
      }

      table.insert(R.spaces, SPACE)
stderrf("initial space in %s : (%d %d) .. (%d %d)\n", R:tostr(),
        SPACE.x1, SPACE.y1, SPACE.x2, SPACE.y2)

      mark_block(x, y, kw, kh)
    end
  end end
end


function Layout_merge_space(R, N)  -- N is new one
  assert(N.x1 < N.x2)
  assert(N.y1 < N.y2)

  -- rebuild list
  local spaces = R.spaces
  R.spaces = {}

  local function split_space_X(S, N)
    if N.x1 > S.x1 then
      local T = table.copy(S)
      S.x1 = N.x1 ; T.x2 = N.x1
      table.insert(spaces, T)
    end

    if N.x2 < S.x2 then
      local T = table.copy(S)
      S.x2 = N.x2 ; T.x1 = N.x2
      table.insert(spaces, T)
    end

    if N.y1 > S.y1 then
      local T = table.copy(S)
      S.y1 = N.y1 ; T.y2 = N.y1
      table.insert(spaces, T)
    end

    if N.y2 < S.y2 then
      local T = table.copy(S)
      S.y2 = N.y2 ; T.y1 = N.y2
      table.insert(spaces, T)
    end
  end
  
  local function split_space_Y(S, N)
    -- same code as above, but do Y first

    if N.y1 > S.y1 then
      local T = table.copy(S)
      S.y1 = N.y1 ; T.y2 = N.y1
      table.insert(spaces, T)
    end

    if N.y2 < S.y2 then
      local T = table.copy(S)
      S.y2 = N.y2 ; T.y1 = N.y2
      table.insert(spaces, T)
    end
     
    if N.x1 > S.x1 then
      local T = table.copy(S)
      S.x1 = N.x1 ; T.x2 = N.x1
      table.insert(spaces, T)
    end

    if N.x2 < S.x2 then
      local T = table.copy(S)
      S.x2 = N.x2 ; T.x1 = N.x2
      table.insert(spaces, T)
    end
  end

  local function split_space(S, N)
    local x_dist = math.min(
      math.abs(S.x1 - N.x1), math.abs(S.x1 - N.x2),
      math.abs(S.x2 - N.x1), math.abs(S.x2 - N.x2))

    local y_dist = math.min(
      math.abs(S.y1 - N.y1), math.abs(S.y1 - N.y2),
      math.abs(S.y2 - N.y1), math.abs(S.y2 - N.y2))

    if x_dist < y_dist then
      split_space_X(S, N)
    else
      split_space_Y(S, N)
    end
  end

  for _,S in ipairs(spaces) do
    if geom.boxes_overlap(S.x1,S.y1,S.x2,S.y2, N.x1,N.y1,N.x2,N.y2) then
      assert(S.free)    
      split_space(S, N)
    else
      table.insert(R.spaces, S)
    end
  end

  table.insert(R.spaces, N)
end



function Layout_place_straddlers(R)
  -- Straddlers are architecture which sits across two rooms.
  -- Currently there are only two kinds: DOORS and WINDOWS.
  -- 
  -- There are placed (i.e. allocated on a 2D map) before
  -- everything else.  The actual prefab and heights will be
  -- decided later in the normal layout code.

  local function place_straddler(kind, K, N, side)
    local deep1 = 24
    local deep2 = 124
    local long = 304

    local mx = int((K.x1 + K.x2) / 2)
    local my = int((K.y1 + K.y2) / 2)

    local x1,y1, x2,y2

    if geom.is_vert(side) then
      x1 = mx - long/2
      x2 = mx + long/2

      if side == 8 then
        y1 = K.y2 - deep1
        y2 = K.y2 + deep2
      else
        y1 = K.y1 - deep2
        y2 = K.y1 + deep1
      end
    else
      y1 = my - long/2
      y2 = my + long/2

      if side == 6 then
        x1 = K.x2 - deep1
        x2 = K.x2 + deep2
      else
        x1 = K.x1 - deep2
        x2 = K.x1 + deep1
      end
    end

    assert(x1 < x2)
    assert(y1 < y2)

    local SPACE =
    {
      straddle = kind,
      side = side,
      builder = N.room,

      x1 = x1, y1 = y1,
      x2 = x2, y2 = y2,
    }

    Layout_merge_space(K.room, SPACE)
    Layout_merge_space(N.room, SPACE)

stderrf(">>>>>>>>>>>> %s straddler %s --> %s\n", kind, K:tostr(), N:tostr())
stderrf("             (%d %d) --> (%d %d)\n", x1, y1, x2, y2)
  end
  
  --| Layout_place_straddlers |--

  for _,C in ipairs(R.conns) do
    if not C.placed and C.kind == "normal" and C.K1.room == R then
      place_straddler("door", C.K1, C.K2, C.dir)
      C.placed = true
    end
  end

  for _,W in ipairs(R.windows) do
    if not W.placed and W.K1.room == R then
      place_straddler("window", W.K1, W.K2, W.dir)
      W.placed = true
    end
  end
end


function Layout_room(R)


--  R.entry_conn

--  if R.purpose then add_purpose() end
--  if R:has_teleporter() then add_teleporter() end
--  if R.weapon  then add_weapon(R.weapon)  end


  local function touches_side(S, side)
    for _,K in ipairs(R.sections) do
      if side == 4 and math.abs(S.x1 - K.x1) < 1 then return true end
      if side == 6 and math.abs(S.x2 - K.x2) < 1 then return true end
      if side == 2 and math.abs(S.y1 - K.y1) < 1 then return true end
      if side == 8 and math.abs(S.y2 - K.y2) < 1 then return true end
    end
    return false
  end

  local function touches_corner(S, side)
    return touches_side(S, geom.RIGHT_45[side]) and
           touches_side(S, geom. LEFT_45[side])
  end


  local function add_corners()
    for _,S in ipairs(R.spaces) do
      for side = 1,9,2 do if side ~= 5 then
        if touches_corner(S, side) then
          
          local x1, y1 = S.x1, S.y1
          local x2, y2 = S.x2, S.y2

          if x2 - x1 >= 96 then
            if side == 1 or side == 7 then
              x2 = x1 + 64
            else
              x1 = x2 - 64
            end
          end

          if y2 - y1 >= 96 then
            if side == 1 or side == 3 then
              y2 = y1 + 64
            else
              y1 = y2 - 64
            end
          end

          local SPACE =
          {
            wall = true,  corner = true,
            x1 = x1, y1 = y1,
            x2 = x2, y2 = y2,
          }

          Layout_merge_space(R, SPACE)
        end
      end end
    end
  end


  local function add_walls()
    for _,S in ipairs(R.spaces) do
    end
  end


  local function build_space(S)
    local c_mat = sel(R.outdoor, "_SKY", "FLAT10")
    local f_mat = "FLAT1"
    local w_mat = "STARTAN3"
    local corn_mat = "CRACKLE2"
    local d_mat = "TEKGREN3"
    local win_mat = "COMPBLUE"

    local kind, w_face, p_face = Mat_normal(f_mat)
    p_face.mark = Plan_alloc_mark()

    Trans.quad(S.x1,S.y1, S.x2,S.y2, nil, 0, kind, w_face, p_face)

    if S.straddle == "door" then
      Trans.quad(S.x1,S.y1, S.x2,S.y2, 128, nil, Mat_normal(d_mat))
    elseif S.straddle == "window" then
      Trans.quad(S.x1,S.y1, S.x2,S.y2, 64, nil, Mat_normal(win_mat))
    elseif S.corner then
      Trans.quad(S.x1,S.y1, S.x2,S.y2, nil, nil, Mat_normal(corn_mat))
    elseif S.wall then
      Trans.quad(S.x1,S.y1, S.x2,S.y2, nil, nil, Mat_normal(w_mat))
    else
      Trans.quad(S.x1,S.y1, S.x2,S.y2, 256, nil, Mat_normal(c_mat))
    end
  end


  ---==| Layout_room |==---

  R.sections = {}  -- FIXME: create this in planner

  for kx = R.kx1,R.kx2 do for ky = R.ky1,R.ky2 do
    local K = SECTIONS[kx][ky]
    if K.room == R then
      table.insert(R.sections, K)

      Trans.entity("zombie", K.x2 - 96, K.y2 - 96, 0)
    end
  end end


  add_corners()

  add_walls()

  for _,S in ipairs(R.spaces) do
    build_space(S)
  end


  --!!! TEMP SHIT !!!--

  local kx = R.kx1
  local ky = R.ky1

  while SECTIONS[kx][ky].room ~= R do
    kx = kx + 1
  end

  local K = SECTIONS[kx][ky]

  local ex = (K.x1 + K.x2) / 2
  local ey = (K.y1 + K.y2) / 2
  local ent = "potion"

  if R.purpose == "START" then
    ent = "player1"
  end

  if R.purpose == "EXIT" then
    ent = "evil_eye"
  end

  Trans.entity(ent, ex, ey, 0)
  Trans.entity("light", ex, ey, 170, { light=150, _radius=600 })
end


----------------------------------------------------------------


function Layout_edge_of_map()
  
  local function stretch_buildings()
    -- TODO: OPTIMISE
    for loop = 1,3 do
      for x = 1,SEED_W do for y = 1,SEED_H do
        local S = SEEDS[x][y]
        if (S.room and not S.room.outdoor) or (S.edge_of_map and S.building) then
          if (S.move_loop or 0) < loop then
            for side = 2,8,2 do
              if not S.edge_of_map or S.building_side == side then
                local N = S:neighbor(side)
                if N and N.edge_of_map and not N.building then
                  N.building = S.room or S.building
                  N.building_side = side
                  N.move_loop = loop
                end
              end
            end -- for side
          end
        end
      end end -- for x, y
    end -- for loop
  end

  local function determine_walk_heights()
    -- TODO: OPTIMISE
    for loop = 1,5 do
      for x = 1,SEED_W do for y = 1,SEED_H do
        local S = SEEDS[x][y]
        if S.edge_of_map and not S.building then
          for side = 2,8,2 do
            local N = S:neighbor(side)
            local other_h
            if N and N.edge_of_map and not N.building then
              other_h = N.walk_h
            elseif N and N.room and N.room.outdoor then
              other_h = N.room.floor_max_h
            end

            if other_h then
              S.walk_h = math.max(S.walk_h or 0, other_h)
            end
          end -- for side
        end
      end end -- for x, y
    end -- for loop
  end

  local function build_edge(S)
    if S.building then
      local tex = S.building.cave_tex or S.building.facade or S.building.main_tex
      assert(tex)

      local kind, w_face, p_face = Mat_normal(tex)

      Trans.quad(S.x1,S.y1, S.x2,S.y2, nil,nil, { k=kind }, w_face, p_face)
      return
    end

    S.fence_h = SKY_H - 128  -- fallback value

    if S.walk_h then
      S.fence_h = math.min(S.walk_h + 64, SKY_H - 64)
    end

    local x1 = S.x1
    local y1 = S.y1
    local x2 = S.x2
    local y2 = S.y2

    local function side_quad(side,len, z1,z2, props, w_face, p_face)
      local ax1, ay1 = x1, y1
      local ax2, ay2 = x2, y2

      if side == 2 then ay2 = ay1 + len end
      if side == 8 then ay1 = ay2 - len end
      if side == 4 then ax2 = ax1 + len end
      if side == 6 then ax1 = ax2 - len end

      Trans.quad(ax1,ay1, ax2,ay2, z1,z2, props, w_face, p_face)
    end

    local function sky_side(side, fh, ch, props, w_face, p_face)
      if GAME.format == "doom" then
        -- use delta_z to make the sky go down to the floor
        -- (as per MAP01 of DOOM II)
        local p_face2 = table.copy(p_face)
        p_face2.delta_z = fh - (ch-4);

        side_quad(side, 16, ch-4,nil, props, w_face, p_face2)
      else
        -- solid sky wall for Quake engines
        side_quad(side, 16, nil,nil, props, w_face, p_face)
      end
    end

    local kind, w_face, p_face = Mat_normal(LEVEL.outer_fence_tex)
    Trans.quad(x1,y1, x2,y2, nil,S.fence_h, { k=kind }, w_face, p_face)

    kind, w_face, p_face = Mat_sky()
    Trans.quad(x1,y1, x2,y2, SKY_H,nil, { k=kind }, w_face, p_face)

    for side = 2,8,2 do
      local N = S:neighbor(side)
      if not N or N.free then
        sky_side(side, S.fence_h, SKY_H, { k=kind }, w_face, p_face)
      end

      if N and ((N.room and not N.room.outdoor) or
                (N.edge_of_map and N.building))
      then
--!!!!        Build_shadow(S, side, 64)
      end
    end
  end

  ---| Layout_edge_of_map |---
  
  gui.debugf("Layout_edge_of_map\n")

  stretch_buildings()

  determine_walk_heights()

  for x = 1,SEED_W do for y = 1,SEED_H do
    local S = SEEDS[x][y]
    if S.edge_of_map then
      build_edge(S)
    end
  end end -- for x, y
end

