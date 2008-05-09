----------------------------------------------------------------
--  BUILDER
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

require 'defs'
require 'util'
require 'seeds'


function dummy_builder(Z)

---##  local function zone_content(ZZ, x, y)
---##    local R = ZZ.grid[x][y]
---##
---##    if not R then return nil end
---##
---##    if R.zone_type then
---##
---##      local CH, lx, ly = zone_content(R, x - R.gx + 1, y - R.gy + 1)
---##
---##      if CH then return CH, lx, ly end
---##    end
---##
---##    return R, x, y
---##  end


  local function get_wall_coords(dir, x1,y1, x2,y2)
  
    if dir == 4 then
      return
      {
        { x = x1   ,  y = y1 },
        { x = x1   ,  y = y2 },
        { x = x1+16,  y = y2 },
        { x = x1+16,  y = y1 },
      }
    end

    if dir == 6 then
      return
      {
        { x = x2   ,  y = y2 },
        { x = x2   ,  y = y1 },
        { x = x2-16,  y = y1 },
        { x = x2-16,  y = y2 },
      }
    end

    if dir == 2 then
      return
      {
        { x = x2, y = y1 },
        { x = x1, y = y1 },
        { x = x1, y = y1+16 },
        { x = x2, y = y1+16 },
      }
    end

    if dir == 8 then
      return
      {
        { x = x1, y = y2    },
        { x = x2, y = y2    },
        { x = x2, y = y2-16 },
        { x = x1, y = y2-16 },
      }
    end

    error("BAD SIDE for get_seed_wall: " .. tostring(side))
  end


  local function OLD_build_room()
--[[
    local walls = {}

    if R.zone_type then

      if R.zone_type == "walk" then
        z1 = 0
        z2 = 256
        f_tex = "GRASS1"
        c_tex = "F_SKY1"
        w_tex = "ZIMMER8"

      elseif R.zone_type == "view" then
        z1 = -128
        z2 = 256
        f_tex = "LAVA1"
        c_tex = "F_SKY1"
        w_tex = "ASHWALL3"

      else
        error("UNKNOWN ZONE TYPE: " .. tostring(R.zone_type))
      end

      for dir = 2,8,2 do
        local dx,dy = dir_to_delta(dir)

        local nx = lx - R.gx + 1 + dx
        local ny = ly - R.gy + 1 + dy


        if nx < 1 or nx > R.grid.w or
           ny < 1 or ny > R.grid.h
        then
          if R.parent.zone_type == "solid" or
             (lx+dx) < 1 or (lx+dx) > R.parent.grid.w or
             (ly+dy) < 1 or (ly+dy) > R.parent.grid.h
          then
            walls[dir] = "solid"
          end
        else
          local N = R.grid[nx][ny]

          -- do nothing (if N is a normal room, his responsibility to make the wall)
        end
      end

    else  -- normal room

      z1 = 24
      z2 = 160
      f_tex = "FLAT1"
      c_tex = "TLITE6_6"
      w_tex = "METAL2"

      for dir = 2,8,2 do
        local dx,dy = dir_to_delta(dir)

        local nx = lx + dx
        local ny = ly + dy

        if nx < 1 or nx > R.parent.grid.w or
           ny < 1 or ny > R.parent.grid.h
        then
          walls[dir] = "solid"
        else
          local N = R.parent.grid[nx][ny]
          if N and (N.prev == R or R.prev == N) then
            walls[dir] = "arch"
          else
            if (R.parent.zone_type == "solid") or rand_odds(75) then
              walls[dir] = "solid"
            end
          end
        end
      end
    end

        
    csg2.add_brush(
    {
      t_face = { texture=f_tex },
      b_face = { texture=f_tex },
      w_face = { texture=f_tex },
    },
    {
      { x=x1, y=y1 }, { x=x1, y=y2 },
      { x=x2, y=y2 }, { x=x2, y=y1 },
    },
    -2000, z1);
      
    csg2.add_brush(
    {
      t_face = { texture=c_tex },
      b_face = { texture=c_tex },
      w_face = { texture=c_tex },
    },
    {
      { x=x1, y=y1 }, { x=x1, y=y2 },
      { x=x2, y=y2 }, { x=x2, y=y1 },
    },
    z2, 2000)

    for dir = 2,8,2 do
      if walls[dir] == "solid" then
        csg2.add_brush(
        {
          t_face = { texture=w_tex },
          b_face = { texture=w_tex },
          w_face = { texture=w_tex },
        },
        get_wall_coords(dir, x1,y1, x2,y2),
        -2000, 2000)
      end
    end
--]]
  end


  local function build_seed(S)
    assert(S)
    assert(S.zone)

    if not S.room and S.zone.zone_kind == "solid" then
      return
    end

    local x1 = S.x1
    local y1 = S.y1
    local x2 = S.x2
    local y2 = S.y2

    local z1, z2
    local f_tex, c_tex, w_tex

    if S.room then

      z1 = 24
      z2 = 160
      f_tex = "FLAT1"
      c_tex = "TLITE6_6"
      w_tex = "METAL2"

      csg2.add_brush(
      {
        t_face = { texture=w_tex },
        b_face = { texture=w_tex },
        w_face = { texture=w_tex },
      },
      {
        { x=x1,    y=y1 },
        { x=x1,    y=y1+24 },
        { x=x1+24, y=y1+24 },
        { x=x1+24, y=y1 },
      },
      -2000, 2000)

      csg2.add_brush(
      {
        t_face = { texture=w_tex },
        b_face = { texture=w_tex },
        w_face = { texture=w_tex },
      },
      {
        { x=x1,    y=y2-24 },
        { x=x1,    y=y2 },
        { x=x1+24, y=y2 },
        { x=x1+24, y=y2-24 },
      },
      -2000, 2000)

      csg2.add_brush(
      {
        t_face = { texture=w_tex },
        b_face = { texture=w_tex },
        w_face = { texture=w_tex },
      },
      {
        { x=x2-24, y=y1 },
        { x=x2-24, y=y1+24 },
        { x=x2,    y=y1+24 },
        { x=x2,    y=y1 },
      },
      -2000, 2000)

      csg2.add_brush(
      {
        t_face = { texture=w_tex },
        b_face = { texture=w_tex },
        w_face = { texture=w_tex },
      },
      {
        { x=x2-24, y=y2-24 },
        { x=x2-24, y=y2 },
        { x=x2,    y=y2 },
        { x=x2,    y=y2-24 },
      },
      -2000, 2000)

    else -- ZONE ONLY

      if S.zone.zone_kind == "walk" then
        z1 = 0
        z2 = 256
        f_tex = "GRASS1"
        c_tex = "F_SKY1"
        w_tex = "ZIMMER8"

      elseif S.zone.zone_kind == "view" then
        z1 = -128
        z2 = 256
        f_tex = "LAVA1"
        c_tex = "F_SKY1"
        w_tex = "ASHWALL3"

      else
        error("UNKNOWN ZONE KIND: " .. tostring(S.zone.zone_kind))
      end
    end


    -- floor and ceiling brushes

    csg2.add_brush(
    {
      t_face = { texture=f_tex },
      b_face = { texture=f_tex },
      w_face = { texture=f_tex },
    },
    {
      { x=x1, y=y1 }, { x=x1, y=y2 },
      { x=x2, y=y2 }, { x=x2, y=y1 },
    },
    -2000, z1);
      
    csg2.add_brush(
    {
      t_face = { texture=c_tex },
      b_face = { texture=c_tex },
      w_face = { texture=c_tex },
    },
    {
      { x=x1, y=y1 }, { x=x1, y=y2 },
      { x=x2, y=y2 }, { x=x2, y=y1 },
    },
    z2, 2000)

    --[[
    for dir = 2,8,2 do
      if walls[dir] == "solid" then
        csg2.add_brush(
        {
          t_face = { texture=w_tex },
          b_face = { texture=w_tex },
          w_face = { texture=w_tex },
        },
        get_wall_coords(dir, x1,y1, x2,y2),
        -2000, 2000)
      end
    end
    --]]

    if S.is_start then
      csg2.add_entity(--[[ "info_player_start" ]] "1", (x1+x2)/2, (y1+y2)/2, z1 + 25)
    else
      -- THIS IS ESSENTIAL (for now) TO PREVENT FILLING by CSG
      csg2.add_entity(--[[ "item_health" ]] "2014", (x1+x2)/2, (y1+y2)/2, z1 + 25)
    end
  end


  --==| dummy_builder |==--

  con.printf("\n--==| dummy_builder |==--\n\n")

  csg2.begin_level()
  csg2.level_prop("level_name", "MAP01");

  for y = 1, SEED_H do
    for x = 1, SEED_W do
      for z = 1, SEED_D do
        build_seed(SEEDS[x][y][z])
      end
    end

--    con.progress(100 * y / SEED_H)
  end

  csg2.end_level()
end

