----------------------------------------------------------------
--  Room Layouting
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

class ROOM
{
  kind : keyword  -- Indoor values: "room", "hallway", "stairwell"
                  -- Outdoor values: "ground", "hill", "valley"

  outdoor : bool  -- true for outdoor rooms

  conns : array(CONN)  -- connections with neighbor rooms

  branch_kind : keyword

  symmetry : keyword   -- symmetry of connections, or NIL
                       -- keywords are "x", "y", "xy", "r", "t"

  sx1, sy1, sx2, sy2  -- \ Seed range
  sw, sh, svolume     -- /

  floor_h, ceil_h : number

  purpose : keyword   -- usually NIL, can be "EXIT" etc... (FIXME)

  arena : ARENA


  --- plan_sp code only:

  lx1, ly1, lx2, ly2  -- coverage on the Land Map

  group_id : number  -- traversibility group

  --- layout code only:

  tx1, ty1, tx2, ty2, tw, th  -- Seed range for layouting

  layout_symmetry : keyword  -- can be "none", "x", "y", "xy"
}


----------------------------------------------------------------


Room Layouting Notes
====================

IDEAS:

- height diffs:
  - basic (if all else fails) algorithm:
    flood fill heights from conn seeds to remaining seeds
    [BUT: floor_h of room]
    add a stair seed at some meeting spots

    if height diff is huge, deserves more seeds

  - patterns:
    (a) L shape is nice
    (b) U shape is possible
    (c) plain side fill (two deep if room is big)

--------------------------------------------------------------]]


require 'defs'
require 'util'


function Rooms_decide_outdoors()
  local function choose(R)
    if R.parent and R.parent.outdoor then return false end
    if R.parent then return rand_odds(5) end

    if R.children then
      if PLAN.sky_mode == "few" then
        return rand_odds(33)
      else
        return rand_odds(80)
      end
    end

    if PLAN.sky_mode == "heaps" then return rand_odds(50) end
    if PLAN.sky_mode == "few"   then return rand_odds(5) end

    -- room on edge of map?
    if R.sx1 <= 2 or R.sy1 <= 2 or R.sx2 >= SEED_W-1 or R.sy2 >= SEED_H-1 then
      return rand_odds(27)
    end

    return rand_odds(9)
  end

  ---| Rooms_decide_outdoors |---

  for _,R in ipairs(PLAN.all_rooms) do
    if R.outdoor == nil then
      R.outdoor = choose(R)
    end
  end
end


function Room_SetupTheme(R)
 
  if not PLAN.outdoor_combos then
    PLAN.outdoor_combos = {}

    for num = 1,2 do
      local name = rand_key_by_probs(PLAN.theme.ground)
      PLAN.outdoor_combos[num] = assert(GAME.combos[name]) 
    end
  end

  if not PLAN.indoor_combos then
    PLAN.indoor_combos = {}

    for num = 1,3 do
      local name = rand_key_by_probs(PLAN.theme.building)
      PLAN.indoor_combos[num] = assert(GAME.combos[name]) 
    end
  end


  if R.outdoor then
    R.combo = rand_element(PLAN.outdoor_combos)
  else
    R.combo = rand_element(PLAN.indoor_combos)
  end
end

function Room_SetupTheme_Scenic(R)
  R.outdoor = true

  --[[

  -- find closest non-scenic room
  local mx = int((R.sx1 + R.sx2) / 2)
  local my = int((R.sy1 + R.sy2) / 2)

  for dist = -SEED_W,SEED_W do
    if Seed_valid(mx + dist, my, 1) then
      local S = SEEDS[mx + dist][my][1]
      if S.room and S.room.kind ~= "scenic" and
         S.room.combo
---      and (not S.room.outdoor) == (not R.outdoor)
      then
        R.combo = S.room.combo
        -- R.outdoor = S.room.outdoor
        return
      end
    end

    if Seed_valid(mx, my + dist, 1) then
      local S = SEEDS[mx][my + dist][1]
      if S.room and S.room.kind ~= "scenic" and
         S.room.combo
---      and (not S.room.outdoor) == (not R.outdoor)
      then
        R.combo = S.room.combo
        R.outdoor = S.room.outdoor
        return
      end
    end
  end

  --]]

  -- fallback
  if R.outdoor then
    R.combo = rand_element(PLAN.outdoor_combos)
  else
    R.combo = rand_element(PLAN.indoor_combos)
  end
end

function Rooms_choose_themes()
  for _,R in ipairs(PLAN.all_rooms) do
    Room_SetupTheme(R)
  end
  for _,R in ipairs(PLAN.scenic_rooms) do
    Room_SetupTheme_Scenic(R)
  end
end


function calc_conn_area(R)
  local lx, ly = 999,999
  local hx, hy = 0,0

  for _,C in ipairs(R.conns) do
    local S = C:seed(R)
    lx = math.min(lx, S.sx)
    ly = math.min(ly, S.sy)
    hx = math.max(hx, S.sx)
    hy = math.max(hy, S.sy)
  end

  assert(lx <= hx and ly <= hy)

  return lx,ly, hx,hy
end


function dump_layout(R)

  local function outside_seed(x, y)
    for dir = 2,8,2 do
      local sx, sy = nudge_coord(x, y, dir)
      if R:valid_T(sx, sy) then
        local T = SEEDS[sx][sy][1]
        if T.conn_dirs and T.conn_dirs[10-dir] then
          return '*'
        end
      end
    end
      
    for _,C in ipairs(R.conns) do
      local S = C:seed(R)
      local ox, oy = nudge_coord(S.sx, S.sy, S.conn_dir)
      if ox == x and oy == y then
        return '+'
      end
    end

    return ' '
  end

  local function inside_seed(x, y)
    local S = SEEDS[x][y][1]
    assert(S and S.room == R)

    if S.layout then
      return S.layout.char
    end

    return '.'
  end


  --| dump_layout |--

  gui.debugf("Room %s @ (%d,%d) Layout:\n", R.kind, R.sx1, R.sy1)

  for y = R.ty2+1, R.ty1-1, -1 do
    line = ""
    for x = R.tx1-1, R.tx2+1 do
      if x < R.tx1 or x > R.tx2 or y < R.ty1 or y > R.ty2 then
        line = line .. outside_seed(x, y)
      else
        line = line .. inside_seed(x, y)
      end
    end
    gui.debugf(" %s\n", line)
  end

  gui.debugf("\n");
end


function Rooms_decide_hallways_II()
  -- Marks certain rooms to be hallways, using the following criteria:
  --   - indoor non-leaf room
  --   - prefer small rooms
  --   - prefer all neighbors are indoor
  --   - no purpose (not a start room, exit room, key room)
  --   - no teleporters
  --   - not the destination of a locked door (anti-climactic)

  local HALL_SIZE_PROBS = { 98, 84, 60, 40, 20, 10 }
  local HALL_SIZE_HEAPS = { 98, 95, 90, 70, 50, 30 }
  local REVERT_PROBS    = {  0,  0, 25, 75, 90, 98 }

  local function eval_hallway(R)
---##     -- Wolf3D: the outdoor areas become hallways
---##     if CAPS.no_sky then
---##       return (R.outdoor and R.num_branch >= 2)
---##     end

    if R.outdoor or R.kind == "scenic" or R.children then
      return false
    end

    if R.purpose then return false end

    if #R.teleports > 0 then return false end
    if R.num_branch < 2 then return false end
    if R.num_branch > 5 then return false end

    for _,C in ipairs(R.conns) do
      local N = C:neighbor(R)
      if N.outdoor and rand_odds(95) then
        return false
      end

      if C.dest == R and C.lock and rand_odds(50) then
        return false
      end
    end

    local min_d = math.min(R.sw, R.sh)

    if min_d > 6 then return false end

    if PLAN.hallway_mode == "heaps" then
      return rand_odds(HALL_SIZE_HEAPS[min_d])
    end

    if PLAN.hallway_mode == "few" and rand_odds(66) then return false end

    return rand_odds(HALL_SIZE_PROBS[min_d])
  end

  local function hallway_neighbors(R)
    local hall_nb = 0
    for _,C in ipairs(R.conns) do
      local N = C:neighbor(R)
      if N.kind == "hallway" then hall_nb = hall_nb + 1 end
    end

    return hall_nb
  end

  local function surrounded_by_halls(R)
    local hall_nb = hallway_neighbors(R)
    return (hall_nb == #R.conns) or (hall_nb >= 3)
  end

  local function stairwell_neighbors(R)
    local swell_nb = 0
    for _,C in ipairs(R.conns) do
      local N = C:neighbor(R)
      if N.kind == "stairwell" then swell_nb = swell_nb + 1 end
    end

    return swell_nb
  end

  local function locked_neighbors(R)
    local count = 0
    for _,C in ipairs(R.conns) do
      if C.lock then count = count + 1 end
    end

    return count
  end


  ---| Room_decide_hallways |---
  
  for _,R in ipairs(PLAN.all_rooms) do
    if eval_hallway(R) then
gui.debugf("  Made Hallway @ %s\n", R:tostr())
      R.kind = "hallway"
      R.outdoor = nil
    end
  end

  -- large rooms which are surrounded by hallways are wasted,
  -- hence look for them and revert them back to normal.
  for _,R in ipairs(PLAN.all_rooms) do
    if R.kind == "hallway" and surrounded_by_halls(R) then
      local min_d = math.min(R.sw, R.sh)

      assert(min_d <= 6)

      if rand_odds(REVERT_PROBS[min_d]) then
        R.kind = "indoor"
gui.debugf("Reverted HALLWAY @ %s\n", R:tostr())
      end
    end
  end

  -- decide stairwells
  for _,R in ipairs(PLAN.all_rooms) do
    if R.kind == "hallway" and R.num_branch == 2 and
       stairwell_neighbors(R) == 0 and
       locked_neighbors(R) == 0
    then
      local hall_nb = hallway_neighbors(R) 

      local prob = 70
      if hall_nb >= 2 then prob = 2  end
      if hall_nb == 1 then prob = 30 end

      if rand_odds(prob) then
        R.kind = "stairwell"
      end
    end
  end -- for R

  -- we don't need archways where two hallways connect
  for _,C in ipairs(PLAN.all_conns) do
    if C.src.kind == "hallway" and C.dest.kind == "hallway" then
      local S = C.src_S
      local T = C.dest_S
      local dir = S.conn_dir

      if S.border[S.conn_dir].kind == "arch" or
         T.border[T.conn_dir].kind == "arch"
      then
        S.border[S.conn_dir].kind = nil
        T.border[T.conn_dir].kind = nil
      end
    end
  end -- for C
end


function Room_spot_for_wotsit(R, kind)
  -- FIXME !!!! CRUD
  local sx, sy, S

  repeat
    sx = rand_irange(R.sx1, R.sx2)
    sy = rand_irange(R.sy1, R.sy2)

    S = SEEDS[sx][sy][1]
  until S.room == R and not S.has_wotsit

  S.has_wotsit = true

  return sx, sy, S
end


function Room_build_seeds(R)

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

    local z1 = (S.floor_h or S.room.floor_h) + 16

    local tag = sel(TELEP.src == S.room, TELEP.src_tag, TELEP.dest_tag)
    assert(tag)


gui.printf("do_teleport\n")
    transformed_brush2(nil,
    {
      t_face = { texture="GATE3" },
      b_face = { texture="GATE3" },
      w_face = { texture="METAL" },

      sec_tag = tag,
    },
    {
      { x=x2, y=y1 }, { x=x2, y=y2 },
      { x=x1, y=y2 }, { x=x1, y=y1 },
    },
    -2000, z1)

    gui.add_entity((x1+x2)/2, (y1+y2)/2, z1 + 25, { name="14" })
  end


  local function build_seed(S)
    assert(S)

    if S.already_built then
      return
    end

    if not S.room then
      return
    end

    local R = S.room

    --- assert(R.kind ~= "scenic")

    local x1 = S.x1
    local y1 = S.y1
    local x2 = S.x2
    local y2 = S.y2

    -- FIXME CRUD GUNK SHIT POO !
    if not S.floor_h and S.layout then
      S.floor_h = S.layout.floor_h
    end

    local z1 = S.floor_h or R.floor_h
    local z2 = S.ceil_h  or R.ceil_h
    local f_tex, c_tex, w_tex
    local sec_kind



      z1 = z1 or (S.conn and S.conn.conn_h) or S.room.floor_h or 0
      z2 = z2 or S.room.ceil_h or 256

-- z2 = 512

      assert(z1 and z2)


      if R.combo then
        f_tex = R.combo.floor
        c_tex = sel(R.outdoor, PARAMS.sky_flat, R.combo.ceil)
        w_tex = R.combo.wall
      else
        w_tex = "DBRAIN1"
        f_tex = "LAVA1"
        c_tex = f_tex
      end


      if R.scenic_kind == "liquid" then
        f_tex = "NUKAGE1"
        c_tex = PARAMS.sky_flat
        w_tex = "COMPBLUE"
        sec_kind = 16

      elseif R.kind == "hallway" then

        f_tex = "FLOOR0_2"
        c_tex = "FLAT4"

--!!!        make_hall_light(S, z2)

----        f_tex = "FLAT23" ; c_tex = "FLAT23"

---     w_tex = "GRAY7"

      elseif R.kind == "stairwell" then

      else -- building
      
      end


      if S.f_tex then f_tex = S.f_tex end
      if S.c_tex then c_tex = S.c_tex end
      if S.w_tex then w_tex = S.w_tex end



    -- make sides

    for side = 2,8,2 do
      local N = S:neighbor(side)

      local B_kind = S.border[side].kind

      -- hallway hack
      if R.kind == "hallway" and not (S.layout and S.layout.char == '#') and
         ( (B_kind == "wall")
          or
           (S:neighbor(side) and S:neighbor(side).room == R and
            S:neighbor(side).layout and
            S:neighbor(side).layout.char == '#')
         )
      then
        make_detailed_hall(S, side, z1, z2)

        S.border[side].kind = nil
        B_kind = nil
      end

      local could_lose_wall =
            N and S.room and N.room and
            S.room.arena == N.room.arena and
            S.room.kind == N.room.kind and
            not (S.room.hallway or N.room.hallway) and
            not (S.room.purpose or N.room.purpose)

      if B_kind == "wall" then --- and not could_lose_wall
        make_wall(S, side, f_tex, w_tex)
---     make_picture(S, side, 128, z1+64, z1+192, f_tex, w_tex, "ZZWOLF6")
      end

      if B_kind == "picture" then
        make_picture(S, side, 128, z1+64, z1+192, f_tex, w_tex, "SPACEW3")
      end

      if B_kind == "window" then
--!!!        make_window(S, side, 192, z1+64, z2-32, f_tex, w_tex)
        make_window(S, side, 192, z1+32, z1+80, f_tex, w_tex)
      end

      if B_kind == "fence" then
--!!!!     and not (N and S.room and N.room and S.room.arena == N.room.arena and S.room.kind == N.room.kind then
        make_fence(S, side, R.floor_h or z1, f_tex, w_tex)
      end

      if B_kind == "mini_fence" then
        -- do nothing
      end

      if B_kind == "sky_fence" then
        make_sky_fence(S, side)
      end

      if B_kind == "arch" then
        make_archway(S, side, z1, z2, f_tex, w_tex) 
      end

      if B_kind == "lock_door" and
         not (S.conn and S.conn.already_made_lock)
      then
        local LOCK = assert(S.border[side].lock)
        local INFO
        if LOCK.kind == "KEY" then
          INFO = assert(GAME.key_doors[LOCK.item])
        else
          assert(LOCK.kind == "SWITCH")
          INFO = assert(GAME.switch_doors[LOCK.item])
        end

        make_locked_door(S, side, z1, w_tex, INFO, LOCK.tag)
        S.conn.already_made_lock = true
      end

      if B_kind == "bars" and
         not (S.conn and S.conn.already_made_lock)
      then
---     make_lowering_bars(S, side, z1, "FLAT23", "SUPPORT2")
---     make_lowering_bars(S, side, z1, "CEIL5_2", "SUPPORT3")
        make_lowering_bars(S, side, z1, "FLAT5_2", "WOOD9")
        S.conn.already_made_lock = true
      end
    end -- for side


    if S.sides_only then return end


    -- floor and ceiling brushes

if S.layout and S.layout.char == '#' then

    transformed_brush2(nil,
    {
      t_face = { texture=f_tex },
      b_face = { texture=f_tex },
      w_face = { texture=w_tex },
    },
    {
      { x=x2, y=y1 }, { x=x2, y=y2 },
      { x=x1, y=y2 }, { x=x1, y=y1 },
    },
    2000, 2000);

elseif S.layout and S.layout.char == '%' then

    transformed_brush2(nil,
    {
      t_face = { texture="NUKAGE1" },
      b_face = { texture=f_tex },
      w_face = { texture="SFALL1" },
    },
    {
      { x=x2, y=y1 }, { x=x2, y=y2 },
      { x=x1, y=y2 }, { x=x1, y=y1 },
    },
    -2000, -32);

    transformed_brush2(nil,
    {
      t_face = { texture=f_tex },
      b_face = { texture=f_tex },
      w_face = { texture=w_tex },
    },
    {
      { x=x2, y=y1 }, { x=x2, y=y2 },
      { x=x1, y=y2 }, { x=x1, y=y1 },
    },
    256, 2000);

else

local CH = S.layout and S.layout.char

local stair_info =
{
  t_face = { texture="FLAT1" },
  b_face = { texture="FLAT1" },
  w_face = { texture="STEP4" },
}

if CH == ">" then
   make_ramp_x(stair_info, x1,x2,y1, x1,x2,y2, S.layout.stair_z1, S.layout.stair_z2)
elseif CH == "<" then
   make_ramp_x(stair_info, x1,x2,y1, x1,x2,y2, S.layout.stair_z2, S.layout.stair_z1)
elseif CH == "^" then
   make_ramp_y(stair_info, x1,y1,y2, x2,y1,y2, S.layout.stair_z1, S.layout.stair_z2)
elseif CH == "v" then
   make_ramp_y(stair_info, x1,y1,y2, x2,y1,y2, S.layout.stair_z2, S.layout.stair_z1)
elseif CH == "L" or CH == "J" or
       CH == "F" or CH == "T" then

   if (S.sx == S.room.sx1 or S.sx == S.room.sx2) and
      (S.sy == S.room.sy1 or S.sy == S.room.sy2)
   then
     do_corner_ramp_CURVED(S, x1,y1, x2,y2, S.layout.stair_z1, S.layout.stair_z2)
   else
     make_low_curved_stair(S, S.layout.stair_z1, S.layout.stair_z2)
---###     do_corner_ramp_STRAIGHT(S, x1,y1, x2,y2, S.layout.stair_z1, S.layout.stair_z2)
   end

elseif CH == '=' then
  make_lift(S, 10-S.conn_dir, assert(S.layout.lift_h))

elseif CH == '!' then
  make_popup_trap(S, z1, {}, S.room.combo)

elseif not S.no_floor then
    transformed_brush2(nil,
    {
      t_face = { texture=f_tex },
      b_face = { texture=f_tex },
      w_face = { texture=w_tex },
      sec_kind = sec_kind,
    },
    {
      { x=x2, y=y1 }, { x=x2, y=y2 },
      { x=x1, y=y2 }, { x=x1, y=y1 },
    },
    -2000, z1);
end

    transformed_brush2(nil,
    {
      t_face = { texture=c_tex },
      b_face = { texture=c_tex },
      w_face = { texture=w_tex },
    },
    {
      { x=x2, y=y1 }, { x=x2, y=y2 },
      { x=x1, y=y2 }, { x=x1, y=y1 },
    },
    z2, 4000)

end -- layout_char ~= '#'


if S.layout and S.layout.assign_stair and not S.layout.assign_stair.done then
  local INFO = S.layout.assign_stair
  if INFO.inner_h < INFO.outer_h then
    do_outdoor_ramp_down(INFO, f_tex, w_tex)
  else
    do_outdoor_ramp_up(INFO, f_tex, w_tex)
  end
end


-- diagonal corners
if (not S.room.outdoor or false) and not (S.room.kind == "hallway") and
   not S.is_start
then
  local z1
  if S.conn then z1 = (S.conn.conn_h or S.floor_h or S.room.floor_h or 320) + 128 end
  local diag_info =
  {
    t_face = { texture=f_tex },
    b_face = { texture=c_tex },
    w_face = { texture=w_tex },
  }
  if S.sx == S.room.sx1 and S.sy == S.room.sy1 then
    make_diagonal(S, 1, diag_info, z1)
  elseif S.sx == S.room.sx2 and S.sy == S.room.sy1 then
    make_diagonal(S, 3, diag_info, z1)
  elseif S.sx == S.room.sx1 and S.sy == S.room.sy2 then
    make_diagonal(S, 7, diag_info, z1)
  elseif S.sx == S.room.sx2 and S.sy == S.room.sy2 then
    make_diagonal(S, 9, diag_info, z1)
  end
end



    local mx = int((x1+x2) / 2)
    local my = int((y1+y2) / 2)

    if DIAGONAL_CORNERS then
    if S.sx == R.sx1 then mx = mx + 48 end
    if S.sx == R.sx2 then mx = mx - 48 end
    if S.sy == R.sy1 then my = my + 48 end
    if S.sy == R.sy2 then my = my - 48 end
    end

    if S.room and S.room.kind ~= "scenic" and
           (S.sx == S.room.sx1) and (S.sy == S.room.sy1) then
      -- THIS IS ESSENTIAL (for now) TO PREVENT FILLING by CSG

      local MON = next(GAME.monsters)
      assert(MON)
      MON = GAME.things[MON]
      assert(MON)
      assert(MON.id)

      gui.add_entity(mx, my, z1 + 25,
      {
        name = tostring(MON.id)
      })
    end

    if S.layout and S.layout.pillar and not S.is_start then
      make_pillar(S, z1, z2, "TEKLITE")
    end

--[[ connection tester
    if S.conn_dir then
      make_arrow(S, S.conn_dir, z1)
    end
--]]

  end


  ---==| Room_build_seeds |==---

  gui.printf("\n---==| Room_build_seeds |==---\n\n")

  for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
    build_seed(SEEDS[x][y][1])
  end end -- x, y
end



local function Room_layout_II(R)

  local function make_fences()
    for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
      local S = SEEDS[x][y][1]
      for side = 2,8,2 do
        local N = S:neighbor(side)

        if S.room == R and S.border[side].kind == "wall"
           and (R.outdoor or (N and N.room and N.room.parent == R))
        then

          if not (N and N.room) then
            S.border[side].kind = "sky_fence"
          end

          if N and N.room and N.room ~= R and N.room.outdoor then
             S.border[side].kind = "fence"
          end

          if N and N.room and N.room ~= R and not N.room.outdoor then
             S.border[side].kind = "mini_fence"
          end
        end
      end
    end end -- for x,y
  end

  local function make_windows()
    if not (R.kind == "indoor" and R.purpose ~= "EXIT") then
      return
    end

    for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
      local S = SEEDS[x][y][1]
      if S.room == R and (x == R.sx1 or x == R.sx2 or y == R.sy1 or y == R.sy2) then
        for side = 2,8,2 do
          local N = S:neighbor(side)
          if N and (N.sx < R.sx1 or N.sx > R.sx2 or N.sy < R.sy1 or N.sy > R.sy2) and
             N.room and (N.room.outdoor or R.parent) and
             S.border[side].kind == "wall"
          then
             S.border[side].kind = "window"
          end
        end
      end
    end end -- for x,y
  end

  local function add_purpose()
    local sx, sy, S = Room_spot_for_wotsit(R, R.purpose)
    local z1 = 0 --!!!!

    local mx, my = S:mid_point()

    if R.purpose == "START" then
      if rand_odds(20) then
        make_raising_start(S, 6, z1, R.combo)
        gui.debugf("Raising Start made\n")
        S.no_floor = true
      else
        make_pedestal(S, z1, "FLAT22")
      end

      gui.add_entity(mx, my, z1 + 35,
      {
        name = tostring(GAME.things["player1"].id)
      })

    elseif R.purpose == "EXIT" then
      local CS = R.conns[1]:seed(R)
      local dir = assert(CS.conn_dir)

      if R.outdoor then
        make_outdoor_exit_switch(S, dir, z1)
      else
        make_exit_pillar(S, z1)
      end

    elseif R.purpose == "KEY" then
      make_pedestal(S, z1, "CEIL1_2")
      gui.add_entity(mx, my, z1+40,
      {
        name = tostring(GAME.things[R.key_item].id),
      })
    elseif R.purpose == "SWITCH" then
gui.debugf("SWITCH ITEM = %s\n", R.do_switch)
      local LOCK = assert(R.lock_for_item)  -- eww
      local INFO = assert(GAME.switch_infos[R.do_switch])
      make_small_switch(S, 4, z1, INFO, LOCK.tag)

    else
      error("Room_layout_II: unknown purpose! " .. tostring(R.purpose))
    end
  end


  ---==| Room_layout_II |==---

  -- special stuff
  if R.kind == "stairwell" then
    Build_stairwell(R)
    return
  end

  if R.purpose == "EXIT" and not R.outdoor and not R:has_any_lock() then
    Build_small_exit(R)
    return
  end


  make_fences()
  make_windows()

  if R.purpose then
    add_purpose()
  end

  -- ETC ETC !!!

end


function Rooms_lay_out_II()

  gui.printf("\n--==| Rooms_lay_out II |==--\n\n")

  PLAN.theme = GAME.themes["TECH"] -- FIXME

  PLAN.sky_mode = rand_key_by_probs { few=20, some=70, heaps=10 }
  gui.debugf("Sky Mode: %s\n", PLAN.sky_mode)

  PLAN.hallway_mode = rand_key_by_probs { few=10, some=90, heaps=20 }
  gui.debugf("Hallway Mode: %s\n", PLAN.hallway_mode)

  PLAN.cage_mode = rand_key_by_probs { none=50, few=20, some=50, heaps=5 }
  gui.debugf("Cage Mode: %s\n", PLAN.cage_mode)

  Rooms_decide_outdoors()
  Rooms_choose_themes()
  Rooms_decide_hallways_II()

  for _,R in ipairs(PLAN.all_rooms) do
    Room_layout_II(R)
    Room_build_seeds(R)
  end

  for _,R in ipairs(PLAN.scenic_rooms) do
    -- FIXME !!!  Room_build_scenic(R)
  end
end

