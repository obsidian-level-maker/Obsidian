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


-- TEMPORARY CRUD

ENT_PLAYER  = "1"
ENT_MONSTER = "9"
ENT_EXIT    = "41"

--[[ QUAKE
ENT_PLAYER  = "info_player_start"
ENT_MONSTER = "monster_army"
ENT_EXIT    = "item_artifact_super_damage"
--]]

--[[ QUAKE2
ENT_PLAYER  = "info_player_start"
ENT_MONSTER = "monster_soldier_light"
ENT_EXIT    = "item_quad"
--]]


function make_arrow(S, dir, f_h, tex)
  
  local mx = int((S.x1 + S.x2)/2)
  local my = int((S.y1 + S.y2)/2)

  local dx, dy = dir_to_delta(dir)
  local ax, ay = dir_to_delta(rotate_cw90(dir))

  gui.add_brush(
  {
    t_face = { texture=tex },
    b_face = { texture=tex },
    w_face = { texture=tex },
  },
  {
    { x = mx + dx*100, y = my + dy * 100 },
    { x = mx + ax*20,  y = my + ay * 20  },
    { x = mx - ax*20,  y = my - ay * 20  },
  },
  -2000, f_h + 8)
end


function dummy_builder(level_name)


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


  local function build_stairwell(R)
    assert(R.conns)

    local A = R.conns[1]
    local B = R.conns[2]

    assert(A and B)

    if not is_perpendicular(A.dir, B.dir) then
      return
    end

    if A.dir == 2 or A.dir == 8 then
      B, A = A, B
    end

    assert(A.dir == 4 or A.dir == 6)
    assert(B.dir == 2 or B.dir == 8)

    if A.src_S.room ~= R then
      A.src_S, A.dest_S = A.dest_S, A.src_S
    end

    if B.src_S.room ~= R then
      B.src_S, B.dest_S = B.dest_S, B.src_S
    end

    assert(A.src_S.room == R)
    assert(B.src_S.room == R)

    local BL = SEEDS[R.sx1][R.sy1][1]
    local TR = SEEDS[R.sx2][R.sy2][1]

    local ax  = sel(A.src_S.conn_dir == 4, BL.x1, TR.x2)
    local ay1 = A.src_S.y1
    local ay2 = A.src_S.y2

    local by  = sel(B.src_S.conn_dir == 2, BL.y1, TR.y2)
    local bx1 = B.src_S.x1
    local bx2 = B.src_S.x2

gui.printf("A @ (%d,%d/%d)  B @ (%d/%d,%d)\n",
           ax,ay1,ay2, bx1,bx2,by)
if by > ay2 then return end
if ax < bx2 then return end


    -- no room for inner circle
    if math.abs(ax - bx1) < 32 or math.abs(ax - bx2) < 32 or
       math.abs(by - ay1) < 32 or math.abs(by - ay2) < 32
    then return end

    -- mark all seeds as done
    for sx = R.sx1,R.sx2 do for sy = R.sy1,R.sy2 do
      SEEDS[sx][sy][1].already_built = true
    end end

    local steps = int(math.abs(A.conn_h - B.conn_h) / 16)
    if steps < 4 then steps = 4 end

    local function get_arc_coords(p0, p1)
      px0 = math.cos(math.pi * p0 / 2.0)
      py0 = math.sin(math.pi * p0 / 2.0)

      px1 = math.cos(math.pi * p1 / 2.0)
      py1 = math.sin(math.pi * p1 / 2.0)

      cx0 = ax + (bx2 - ax) * px0
      cy0 = by + (ay1 - by) * py0
      cx1 = ax + (bx2 - ax) * px1
      cy1 = by + (ay1 - by) * py1

      fx0 = ax + (bx1 - ax) * px0
      fy0 = by + (ay2 - by) * py0
      fx1 = ax + (bx1 - ax) * px1
      fy1 = by + (ay2 - by) * py1

gui.printf("Line loop: %d,%d  %d,%d  %d,%d  %d,%d\n",
           int(cx0),int(cy0),
           int(fx0),int(fy0),
           int(fx1),int(fy1),
           int(cx1),int(cy1))

      return
      {
        { x = int(cx0), y = int(cy0) },
        { x = int(fx0), y = int(fy0) },
        { x = int(fx1), y = int(fy1) },
        { x = int(cx1), y = int(cy1) },
      }
    end

    for i = 1,steps do
      local z1 = B.conn_h + (A.conn_h - B.conn_h) * (i-1) / steps
      local z2 = B.conn_h + (A.conn_h - B.conn_h) * (i  ) / steps

gui.printf("step %d  range %d..%d\n", i, int(z1), int(z2))
      gui.add_brush(
      {
        t_face = { texture="FLOOR0_7" },
        b_face = { texture="FLOOR0_7" },
        w_face = { texture="STARGR1" },
      },
      get_arc_coords((i-1)/steps, i/steps, 1, 1),
      -2000, z1)

      gui.add_brush(
      {
        t_face = { texture="FLOOR0_7" },
        b_face = { texture="FLOOR0_7" },
        w_face = { texture="STARGR1" },
      },
      get_arc_coords((i-1)/steps, i/steps, 1, 1),
      z2 + 128, 2000)

      --[[
      gui.add_brush(
      {
        t_face = { texture="FLOOR0_7" },
        b_face = { texture="FLOOR0_7" },
        w_face = { texture="STARGR1" },
      },
      get_arc_coords((i-1)/steps, i/steps, 1, 0.5),
      -2000, 2000)

      gui.add_brush(
      {
        t_face = { texture="FLOOR0_7" },
        b_face = { texture="FLOOR0_7" },
        w_face = { texture="STARGR1" },
      },
      get_arc_coords((i-1)/steps, i/steps, , 1),
      -2000, 2000)
      --]]
    end
  end


  local function do_teleporter(S)
    -- TEMP HACK SHIT

    local idx = S.sx - S.room.sx1 + 1

if idx < 1 then return end

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


gui.printf("do_teleport\n")
    gui.add_brush(
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

    gui.add_entity((x1+x2)/2, (y1+y2)/2, z1 + 25, { name="14" })
  end


  local function build_seed(S)
    assert(S)
    assert(S.zone)

    if not S.room --[[ and S.zone.zone_kind == "solid" ]] then
--    S.room = { kind = "liquid" }
      return
    end

    if S.already_built then
      return
    end

    local x1 = S.x1
    local y1 = S.y1
    local x2 = S.x2
    local y2 = S.y2

    local z1 = S.floor_h
    local z2 = S.ceil_h
    local f_tex, c_tex, w_tex
    local do_sides = true
    local sec_kind

    if S.room then

      z1 = z1 or (S.conn and S.conn.conn_h) or S.room.floor_h --!!! or 0
      z2 = z2 or S.room.ceil_h  --!!! or 256

      assert(z1 and z2)

      local do_corners = false --!!

      
      if S.room.kind == "valley" then
        f_tex = "FLOOR7_1"
        c_tex = "F_SKY1"
        w_tex = "BROWN144"
        do_corners = false
        do_sides = false --!!!

      elseif S.room.kind == "ground" then
        f_tex = "MFLR8_4"
        c_tex = "F_SKY1"
        w_tex = "ASHWALL2"
        do_corners = false
        do_sides = false --!!!

      elseif S.room.kind == "hill" then
        f_tex = "FLOOR7_1"
        c_tex = "F_SKY1"
        w_tex = "BROWN144"
        do_corners = false
        do_sides = false --!!!

      elseif S.room.kind == "liquid" then
        f_tex = "NUKAGE1"
        c_tex = "F_SKY1"
        w_tex = "COMPBLUE"
        sec_kind = 16
        do_corners = false
        do_sides = false --!!!

      elseif S.room.kind == "hallway" then

        f_tex = "FLAT1"
        c_tex = "CEIL3_5"
        w_tex = "GRAY7"

      elseif S.room.kind == "stairwell" then

        f_tex = "FLAT5_3"
        c_tex = "FLAT1"
        w_tex = "BROWN1"

      else -- building
      
        f_tex = "FLOOR4_8"
        c_tex = "TLITE6_4"
        w_tex = "STARG3"

      end

--      if S.room.branch_kind then f_tex = "CEIL5_2" end


--[[ QUAKE
f_tex = sel(c_tex == "F_SKY1", "ground1_6", "wood1_1")
c_tex = sel(c_tex == "F_SKY1", "sky1", "metal1_1")
w_tex = "tech01_1"
--]]

--[[ QUAKE2
c_tex = "e1u1/grnx2_3"
f_tex = "e1u1/floor3_3"
w_tex = "e1u1/exitdr01_2"
--]]

      S.z1 = z1 --!!!!!! REMOVE CRAP

      if do_corners then
      gui.add_brush(
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

      gui.add_brush(
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

      gui.add_brush(
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

      gui.add_brush(
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

    gui.add_brush(
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

    gui.add_brush(
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
      local nx, ny = nudge_coord(S.sx, S.sy, side)
      local N
      if Seed_valid(nx,ny,1) then N = SEEDS[nx][ny][1] end

      if S.borders and S.borders[side] and S.borders[side].kind == "solid"
         and not (N and S.room and N.room and
                  S.room.arena == N.room.arena and
                  S.room.kind == N.room.kind and
                  not (S.room.hallway or N.room.hallway) and
                  false)
      then
        gui.add_brush(
        {
          t_face = { texture=f_tex },
          b_face = { texture=f_tex },
          w_face = { texture=w_tex },
        },
        get_wall_coords(side, x1,y1, x2,y2),
        -2000, 4000)
      end
      if S.borders and S.borders[side] and S.borders[side].kind == "fence"
         and not (N and S.room and N.room and S.room.arena == N.room.arena and S.room.kind == N.room.kind)
      then
        gui.add_brush(
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
gui.printf("ADDING LOCK DOOR %s\n", w_tex)
        gui.add_brush(
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

    local mx = int((x1+x2) / 2)
    local my = int((y1+y2) / 2)

    if S.is_start then
      gui.add_entity(mx, my, z1 + 25,
      {
        name = ENT_PLAYER
      })
    elseif S.is_exit then
      gui.add_entity(mx, my, z1 + 25,
      {
        name = ENT_EXIT
      })
    elseif S.room and
           (S.sx == S.room.sx1) and (S.sy == S.room.sy1) then
      -- THIS IS ESSENTIAL (for now) TO PREVENT FILLING by CSG
      gui.add_entity(mx, my, z1 + 25,
      {
        name = ENT_MONSTER
      })
    end

if S.conn_dir then
  make_arrow(S, S.conn_dir, z1, "FWATER1")
end

-- symmetry tester
if S.x_peer and S.sx < S.x_peer.sx then
  local dx = rand_irange(-70,70)
  local dy = rand_irange(-70,70)
  local mx2 = int((S.x_peer.x1 + S.x_peer.x2) / 2)
  local my2 = int((S.x_peer.y1 + S.x_peer.y2) / 2)

  gui.add_entity(mx+dx, my+dy, z1 + 25,   { name="35" })
  gui.add_entity(mx2-dx, my2+dy, z1 + 25, { name="35" })
end

if S.y_peer and S.sy < S.y_peer.sy then
  
  local dx = rand_irange(-70,70)
  local dy = rand_irange(-70,70)
  local mx2 = int((S.y_peer.x1 + S.y_peer.x2) / 2)
  local my2 = int((S.y_peer.y1 + S.y_peer.y2) / 2)

  gui.add_entity(mx+dx, my+dy, z1 + 25,   { name="43" })
  gui.add_entity(mx2+dx, my2-dy, z1 + 25, { name="43" })
end

    if S.room and S.sy == S.room.sy2 then
      do_teleporter(S)
    end

    if S.room and S.room.key_item and S.sx == S.room.sx2 and S.sy == S.room.sy2 then
      local KEYS = { 13,6,5,7015, 38,39,40,7017 }
gui.printf("ADDING KEY %d\n", KEYS[S.room.key_item] or 2014)
--      gui.add_entity(tostring(KEYS[S.room.key_item] or 2014), (x1+x2)/2, (y1+y2)/2, z1 + 25)
    end
  end


  --==| dummy_builder |==--

  gui.printf("\n--==| dummy_builder |==--\n\n")

  gui.begin_level()
  gui.property("level_name", level_name);
  gui.property("error_tex",  "BLAKWAL1");

  gui.ticker()

  for _,R in ipairs(PLAN.all_rooms or {}) do
    if R.kind == "stairwell" then
      build_stairwell(R)
    end
  end

  for y = 1, SEED_H do
    for x = 1, SEED_W do
      for z = 1, SEED_D do
        build_seed(SEEDS[x][y][z])
      end
    end

--    gui.progress(100 * y / SEED_H)
  end

  gui.end_level()
end

