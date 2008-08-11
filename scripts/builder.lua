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


TK = 16  -- wall thickness


function dummy_builder(level_name)

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
        { x = x1+TK,  y = y2 },
        { x = x1+TK,  y = y1 },
      }
    end

    if dir == 6 then
      return
      {
        { x = x2   ,  y = y2 },
        { x = x2   ,  y = y1 },
        { x = x2-TK,  y = y1 },
        { x = x2-TK,  y = y2 },
      }
    end

    if dir == 2 then
      return
      {
        { x = x2, y = y1 },
        { x = x1, y = y1 },
        { x = x1, y = y1+TK },
        { x = x2, y = y1+TK },
      }
    end

    if dir == 8 then
      return
      {
        { x = x1, y = y2    },
        { x = x2, y = y2    },
        { x = x2, y = y2-TK },
        { x = x1, y = y2-TK },
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


  local function do_teleporter(S)
    -- TEMP HACK SHIT

    local idx = S.sx - S.room.sx1 + 1
    assert(idx >= 1)
    if idx > #S.room.teleports then return end

    local TELEP = S.room.teleports[idx]


    local mx = int((S.x1 + S.x2)/2)
    local my = int((S.y1 + S.y2)/2)

    local x1 = mx - 32
    local y1 = my - 32
    local x2 = mx + 32
    local y2 = my + 32

    local z1 = S.z1 + 16

    local tag = sel(TELEP.src == S.room, TELEP.src_tag, TELEP.dest_tag)
    assert(tag)


con.printf("do_teleport\n")
    csg2.add_brush(
    {
      t_face = { texture="GATE3" },
      b_face = { texture="GATE3" },
      w_face = { texture="METAL" },

      sec_tag = tag,
    },
    {
      { x=x1, y=y1 },
      { x=x1, y=y2 },
      { x=x2, y=y2 },
      { x=x2, y=y1 },
    },
    -2000, z1)

    csg2.add_entity("14", (x1+x2)/2, (y1+y2)/2, z1 + 25)
  end


  local function build_seed(S)
    assert(S)
    assert(S.zone)

    if not S.room --[[ and S.zone.zone_kind == "solid" ]] then
--    S.room = { kind = "liquid" }
      return
    end

    local x1 = S.x1
    local y1 = S.y1
    local x2 = S.x2
    local y2 = S.y2

    local z1, z2
    local f_tex, c_tex, w_tex
    local do_sides = true
    local sec_kind

    if S.room then

      local do_corners = false --!!

--!!!!!!
-- if S.room.kind == "building" then S.room.kind = "ground" end

      if S.room.hallway then
        z1 = 256+24
        z2 = z1 + 96

        f_tex = "FLAT1"
        c_tex = f_tex
        w_tex = "GRAY7"

      elseif S.room.kind == "valley" then
        z1 = 0
        z2 = 512
        f_tex = "GRASS1"
        c_tex = "F_SKY1"
        w_tex = "ZIMMER8"
        do_corners = false
        do_sides = false --!!!

      elseif S.room.kind == "ground" then
        z1 = 128
        z2 = 512
        f_tex = "RROCK11"
        c_tex = "F_SKY1"
        w_tex = "ROCK4"
        do_corners = false
        do_sides = false --!!!

      elseif S.room.kind == "hill" then
        z1 = 256
        z2 = 512
        f_tex = "MFLR8_4"
        c_tex = "F_SKY1"
        w_tex = "ASHWALL2"
        do_corners = false
        do_sides = false --!!!

      elseif S.room.kind == "liquid" then
        z1 = -24
        z2 = 512
        f_tex = "LAVA1"
        c_tex = "F_SKY1"
        w_tex = "COMPBLUE"
        sec_kind = 16
        do_corners = false
        do_sides = false --!!!

      elseif S.room.kind == "cave" then
        z1 = 128+16
        z2 = z1+192+128
      
        f_tex = "FLAT10"
        c_tex = "FLAT10"
        w_tex = "ASHWALL4"

      else -- building
        z1 = 256+16
        z2 = z1+192
      
        f_tex = "FLAT14"
        c_tex = "CEIL3_3"
        w_tex = "STARTAN3"
      end

      S.z1 = z1 --!!!!!! REMOVE CRAP

      if do_corners then
      csg2.add_brush(
      {
        t_face = { texture=w_tex },
        b_face = { texture=w_tex },
        w_face = { texture=w_tex },
      },
      {
        { x=x1,    y=y1 },
        { x=x1,    y=y1+TK },
        { x=x1+TK, y=y1+TK },
        { x=x1+TK, y=y1 },
      },
      -2000, 4000)

      csg2.add_brush(
      {
        t_face = { texture=w_tex },
        b_face = { texture=w_tex },
        w_face = { texture=w_tex },
      },
      {
        { x=x1,    y=y2-TK },
        { x=x1,    y=y2 },
        { x=x1+TK, y=y2 },
        { x=x1+TK, y=y2-TK },
      },
      -2000, 4000)

      csg2.add_brush(
      {
        t_face = { texture=w_tex },
        b_face = { texture=w_tex },
        w_face = { texture=w_tex },
      },
      {
        { x=x2-TK, y=y1 },
        { x=x2-TK, y=y1+TK },
        { x=x2,    y=y1+TK },
        { x=x2,    y=y1 },
      },
      -2000, 4000)

      csg2.add_brush(
      {
        t_face = { texture=w_tex },
        b_face = { texture=w_tex },
        w_face = { texture=w_tex },
      },
      {
        { x=x2-TK, y=y2-TK },
        { x=x2-TK, y=y2 },
        { x=x2,    y=y2 },
        { x=x2,    y=y2-TK },
      },
      -2000, 4000)
      end -- do_corners

    else -- ZONE ONLY

      do
        error("UNKNOWN ZONE KIND: " .. tostring(S.zone.zone_kind))
      end
    end


    -- floor and ceiling brushes

    csg2.add_brush(
    {
      t_face = { texture=f_tex },
      b_face = { texture=f_tex },
      w_face = { texture=w_tex },
      sec_kind = sec_kind,
    },
    {
      { x=x1, y=y1 }, { x=x1, y=y2 },
      { x=x2, y=y2 }, { x=x2, y=y1 },
    },
    -2000, z1);

-- if c_tex=="F_SKY1" then c_tex = "MFLR8_4" end --!!!!!!

    csg2.add_brush(
    {
      t_face = { texture=c_tex },
      b_face = { texture=c_tex },
      w_face = { texture=w_tex },
    },
    {
      { x=x1, y=y1 }, { x=x1, y=y2 },
      { x=x2, y=y2 }, { x=x2, y=y1 },
    },
    z2, 4000)

if true then -- if do_sides then
    for side = 2,8,2 do
      if S.borders and S.borders[side] and S.borders[side].kind == "solid" then
        csg2.add_brush(
        {
          t_face = { texture=f_tex },
          b_face = { texture=f_tex },
          w_face = { texture=w_tex },
        },
        get_wall_coords(side, x1,y1, x2,y2),
        -2000, 4000)
      end
      if S.borders and S.borders[side] and S.borders[side].kind == "fence" then
        csg2.add_brush(
        {
          t_face = { texture=f_tex },
          b_face = { texture=f_tex },
          w_face = { texture=w_tex },
        },
        get_wall_coords(side, x1,y1, x2,y2),
        -2000, z1+36)
      end
      if S.borders and S.borders[side] and S.borders[side].kind == "lock_door" then
        local LOCK_TEXS = { "DOORRED", "DOORYEL", "DOORBLU", "TEKGREN3",
                            "DOORRED2","DOORYEL2","DOORBLU2","MARBFAC2" }
        local w_tex = LOCK_TEXS[S.borders[side].key_item] or "METAL"
con.printf("ADDING LOCK DOOR %s\n", w_tex)
        csg2.add_brush(
        {
          t_face = { texture=f_tex },
          b_face = { texture=f_tex },
          w_face = { texture=w_tex },
        },
        get_wall_coords(side, x1,y1, x2,y2),
        z1 + 36, 4000)
      end
    end
end -- do_sides

    if S.is_start then
      csg2.add_entity(--[[ "info_player_start" ]] "1", (x1+x2)/2, (y1+y2)/2, z1 + 25)
    elseif S.is_exit then
      csg2.add_entity(--[[ "info_player_start" ]] "41", (x1+x2)/2, (y1+y2)/2, z1 + 25)
    elseif S.room and not S.room.hallway and
           (S.sx == S.room.sx1) and (S.sy == S.room.sy1) then
      -- THIS IS ESSENTIAL (for now) TO PREVENT FILLING by CSG
      csg2.add_entity(--[[ "item_health" ]] "2014", (x1+x2)/2, (y1+y2)/2, z1 + 25)
    end

    if S.room and S.sy == S.room.sy2 then
      do_teleporter(S)
    end

    if S.room and S.room.key_item and S.sx == S.room.sx2 and S.sy == S.room.sy2 then
      local KEYS = { 13,6,5,7015, 38,39,40,7017 }
con.printf("ADDING KEY %d\n", KEYS[S.room.key_item])
      csg2.add_entity(tostring(KEYS[S.room.key_item] or 2014), (x1+x2)/2, (y1+y2)/2, z1 + 25)
    end
  end


  --==| dummy_builder |==--

  con.printf("\n--==| dummy_builder |==--\n\n")

  csg2.begin_level()
  csg2.level_prop("level_name", level_name);
  csg2.level_prop("error_tex",  "BLAKWAL1");

  con.ticker()

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

