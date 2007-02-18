----------------------------------------------------------------
-- BUILDER
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


function copy_block(B)
  local b2 = copy_table(B)
  
  b2.things = {}
  
  -- copy the overrides and corner adjustments
  for i = 1,9 do
    if B[i] then b2[i] = copy_table(B[i]) end
  end

  return b2
end

function copy_sector(sec)
  return
  {
    f_h = sec.f_h,
    c_h = sec.c_h,
    f_tex = sec.f_tex,
    c_tex = sec.c_tex,
    light = sec.light,
    kind  = sec.kind,
    tag   = sec.tag
  }
end

function copy_chunk(K)
  return
  {
    room = K.room,
    void = K.void,
    link = K.link,
    cage = K.cage,
    liquid = K.liquid,
    closet = K.closet,
    place  = K.place,

---##    player = K.player,
---##    weapon = K.weapon,
---##    quest  = K.quest,

    floor_h = K.floor_h,
    ceil_h  = K.ceil_h,
  }
end

function dir_to_across(dir)
  if dir == 2 then return 1, 0 end
  if dir == 8 then return 1, 0 end
  if dir == 4 then return 0, 1 end
  if dir == 6 then return 0, 1 end
  error ("dir_to_across: bad dir " .. dir)
end


function side_to_chunk(side)
  if side == 2 then return 2, 1 end
  if side == 8 then return 2, 3 end
  if side == 4 then return 1, 2 end
  if side == 6 then return 3, 2 end
  error ("side_to_chunk: bad side " .. side)
end

function side_to_corner(side, W, H)
  if side == 2 then return 1,1, W,1 end
  if side == 8 then return 1,H, W,H end
  if side == 4 then return 1,1, 1,H end
  if side == 6 then return W,1, W,H end
  error ("side_to_corner: bad side " .. side)
end

function dir_to_corner(dir, W, H)
  if dir == 1 then return 1,1 end
  if dir == 3 then return W,1 end
  if dir == 7 then return 1,H end
  if dir == 9 then return W,H end
  error ("dir_to_corner: bad dir " .. dir)
end

function block_to_chunk(B)
  return 1 + int((B-1) * KW / BW)
end

function chunk_to_block(K)
  return 1 + int((K-1) * BW / KW)
end

function chunk_touches_side(kx, ky, side)
  if side == 4 then return kx == 1 end
  if side == 6 then return kx == 3 end
  if side == 2 then return ky == 1 end
  if side == 8 then return ky == 3 end
end

function valid_chunk(kx,ky)
  return 1 <= kx and kx <= KW and
         1 <= ky and ky <= KH
end

function is_roomy(cell, chunk)
  if not chunk or chunk.void then return false end
  if chunk.room then return true end
  return chunk.link.build == cell
end

function random_where(link)

  local LINK_WHERES = { 15, 40, 15, 90, 15, 40, 15 }

  if link.src.hallway or link.dest.hallway then
    return 0
  end

  if link.src.small_exit or link.dest.small_exit then
    return 0
  end

  if (link.kind == "door" and rand_odds(4)) or
     (link.kind ~= "door" and rand_odds(15))
  then
    return "double";
  end

  if (link.kind == "arch" and rand_odds(15)) or
     (link.kind == "falloff" and rand_odds(80))
  then
    return "wide";
  end

  if link.kind == "falloff" then return 0 end

  return rand_index_by_probs(LINK_WHERES) - 4
end


function show_blocks(cell) -- FIXME
  assert(cell.blocks)
  for y = BH,1,-1 do
    for x = 1,BW do
      local B = cell.blocks[x][y]
      con.printf(B and (B.fragments and "%" or
                      (B.sector and "/" or "#")) or ".")
    end
    con.printf("\n")
  end
end

function show_fragments(block)
  assert(block.fragments)
  for y = FH,1,-1 do
    for x = 1,FW do
      local fg = block.fragments[x][y]
      con.printf(fg and (fg.sector and "/" or "#") or ".")
    end
    con.printf("\n")
  end
end


function fill(p, c, sx, sy, ex, ey, B, B2)
  if sx > ex then sx, ex = ex, sx end
  if sy > ey then sy, ey = ey, sy end
  for x = sx,ex do
    for y = sy,ey do
      local N = copy_block(B)
      p.blocks[c.blk_x+x][c.blk_y+y] = N

      if B2 then
        merge_table(N, B2)
      end

      N.mark = N.mark or c.mark
    end
  end
end

function gap_fill(p, c, sx, sy, ex, ey, B, B2)
  if sx > ex then sx, ex = ex, sx end
  if sy > ey then sy, ey = ey, sy end
  for x = sx,ex do
    for y = sy,ey do

      if not p.blocks[c.blk_x+x][c.blk_y+y] then
        fill(p,c, x,y, x,y, B, B2)
--##        p.blocks[c.blk_x+x][c.blk_y+y] =
--##        { sector=sec, l_tex=l_tex, u_tex=u_tex, overrides=overrides,
-- FIXME          block_sound= sec and sec.block_sound }
      end
    end
  end
end

function frag_fill(p, c, sx, sy, ex, ey, F, F2)

  if sx > ex then sx, ex = ex, sx end
  if sy > ey then sy, ey = ey, sy end
  for x = sx,ex do
    for y = sy,ey do
      local bx, fx = div_mod(x, FW)
      local by, fy = div_mod(y, FH)
      
      if not p.blocks[c.blk_x+bx][c.blk_y+by] then
        p.blocks[c.blk_x+bx][c.blk_y+by] = {}
      end

      local B = p.blocks[c.blk_x+bx][c.blk_y+by]
      B.solid = nil

      if not B.fragments then
        B.fragments = array_2D(FW, FH)
      end

      local N = copy_block(F)
      B.fragments[fx][fy] = N

      if F2 then merge_table(N, F2) end

      N.mark = N.mark or c.mark
    end
  end
end

function move_frag(p,c, x,y,corner, dx,dy)
  local bx, fx = div_mod(x, FW)
  local by, fy = div_mod(y, FH)

  local B = p.blocks[c.blk_x+bx][c.blk_y+by]
  assert(B)
  assert(B.fragments)

  local F = B.fragments[fx][fy]
  assert(F)

  if not F[corner] then
    F[corner] = {}
  else
    dx = dx + (F[corner].dx or 0)
    dy = dy + (F[corner].dy or 0)
  end

  F[corner].dx = dx
  F[corner].dy = dy
end

 
-- convert 'where' value into block position
function where_to_block(wh, long)

  if wh == 0 then return JW+1 end

  if wh == -1 then return 3 end -- FIXME: not best place
  if wh == -2 then return 2 end -- FIXME
  if wh == -3 then return 1 end
  
  if wh == 1 then return BW-1 - long end -- FIXME
  if wh == 2 then return BW   - long end -- FIXME
  if wh == 3 then return BW+1 - long end

  error("bad where value: " .. tostring(wh))
end


function scale_block(B, scale)
  -- Note: doesn't set x_offsets
  scale = (scale - 1) * 32
  B[1] = { dx=-scale, dy=-scale }
  B[3] = { dx= scale, dy=-scale }
  B[7] = { dx=-scale, dy= scale }
  B[9] = { dx= scale, dy= scale }
end

function rotate_block(B, d)
  -- Note: doesn't set x_offsets
  B[1] = { dx= 32, dy= -d }
  B[3] = { dx=  d, dy= 32 }
  B[9] = { dx=-32, dy=  d }
  B[7] = { dx= -d, dy=-32 }
end

--
-- Build a door.
-- 
-- Valid sizes (long x deep) are:
--    4x3  4x2  4x1
--    3x3  3x2  3x1
--    2x3  2x2  2x1
--
function B_door(p, c, link, b_theme, x,y,z, dir, long,deep, door_info,
                kind,tag, key_tex)
 
  local high = door_info.h
  
  local dx, dy = dir_to_delta(dir)
  local ax, ay = dir_to_across(dir)
  local adir = delta_to_dir(ax, ay)

  assert (link.kind == "door")

  local wall_tex = c.theme.wall
  local track_tex = door_info.track or THEME.mats.TRACK.wall
  local door_tex = door_info.tex
  local side_tex
  local ceil_tex = THEME.mats.DOOR_FRAME.floor

  if key_tex then
    side_tex = nil
  else
    key_tex  = wall_tex
    side_tex = THEME.mats.DOOR_FRAME.wall -- can be nil
  end

  if deep >= 2 then
--    side_tex = key_tex
--    ceil_tex = door_info.ceil_tex or THEME.mats.DOOR_FRAME.ceil
  end

  local DOOR = { f_h = z+8, c_h = z+8,
                 f_tex = door_info.frame_bottom or THEME.mats.DOOR_FRAME.floor,
                 c_tex = door_info.bottom       or THEME.mats.DOOR_FRAME.floor,
                 light = 255,
                 l_tex = door_tex,
                 u_tex = door_tex,
                 door_kind = kind,
                 tag = tag,
                 [dir]  = { u_peg="bottom" }, [10-dir]  = { u_peg="bottom" },
                 [adir] = { l_peg="bottom" }, [10-adir] = { l_peg="bottom" }, -- TRACK
                 }

  local STEP = { f_h = z+8, c_h = z+8 + door_info.h,
                    f_tex = DOOR.f_tex,
                    c_tex = door_info.frame_top or THEME.mats.DOOR_FRAME.ceil,
                    light=224,
                    l_tex = door_info.step or c.theme.step or THEME.mats.STEP.wall,
                    u_tex = wall_tex,
                    [dir] = { l_peg="top" },
                    [10-dir] = { l_peg="top" },
                    }

  -- block based door (big 'n bulky)

  if long >= 3 and deep == 3 then

    local zx, zy = (long-1)*ax, (long-1)*ay
    local ex, ey = (long-2)*ax, (long-2)*ay

    fill (p,c, x,   y,    x+zx,y+zy, { solid=key_tex })
    fill (p,c, x+ax,y+ay, x+ex,y+ey, STEP )
    x = x + dx; y = y + dy

    fill (p,c, x,   y,    x+zx,y+zy, { solid=wall_tex })
    fill (p,c, x+ax,y+ay, x+ex,y+ey, DOOR)
    x = x + dx; y = y + dy

    fill (p,c, x,   y,    x+zx,y+zy, { solid=key_tex })
    fill (p,c, x+ax,y+ay, x+ex,y+ey, STEP )

    return
  end

  -- fragment based doors --

  local fx = 1 + (x-1)*FW
  local fy = 1 + (y-1)*FH

  if (dir == 4) then fx = fx + FW - 1 end
  if (dir == 2) then fy = fy + FH - 1 end

  if long >= 2 and deep <= 2 then

    local step = 1 + (deep - 1) * 2
    assert(step * 2 + 2 == deep * FW)

    local side = (long == 4) and 4 or 2
    long = long * 4 - side * 2
    assert(long == 4 or long == 8)

    local ex, ey = ax*(long+1), ay*(long+1)
    local zx, zy = ax*(long+side+1), ay*(long+side+1)

    local sx, sy = ax*side, ay*side

    -- align inner sides with outside wall
    local y_diff = link_other(link, c).ceil_h - STEP.c_h
    local far = deep * FW - 1

    local override

    if side_tex then
      override =
      {
        l_tex = side_tex,
        y_offset = y_diff
      }
    end

    frag_fill (p,c, fx,fy, fx+sx+dx*far,fy+zy-sy+dy*far,
      { solid=key_tex, [adir] = override })
    frag_fill (p,c, fx+zx-sx,fy+zy-sy, fx+zx+dx*far,fy+zy+dy*far, 
      { solid=key_tex, [10-adir] = override })

    for ff = 1,step do
      frag_fill (p,c, fx+sx,fy+sy, fx+ex,fy+ey, STEP)
      fx = fx + dx; fy = fy + dy
    end

    for mm = 1,2 do
      frag_fill (p,c, fx+ax,fy+ay, fx+zx-ax,fy+zy-ay, { solid=track_tex })
      frag_fill (p,c, fx+sx,fy+sy, fx+ex,fy+ey, DOOR)
      fx = fx + dx; fy = fy + dy
    end

    for bb = 1,step do
      frag_fill (p,c, fx+sx,fy+sy, fx+ex,fy+ey, STEP)
      fx = fx + dx; fy = fy + dy
    end

    return
  end

  error("UNIMPLEMENTED DOOR " .. long .. "x" .. deep)
end


function B_exit_door(p,c, theme, link, x,y,z, dir)
 
  assert (link.kind == "door")

  local door_info = theme.door
  assert(door_info)

  local door_w = int(door_info.w / 64)

  local long = link.long or (1 + door_w)
  local deep = 2
  local high = 72  -- FIXME: pass in "door_info"

---###  if theme.front_mark then long = long + 1 end -- FIXME: sync with link.long

  local dx, dy = dir_to_delta(dir)
  local ax, ay = dir_to_across(dir)
  local adir = delta_to_dir(ax, ay)

  local wall_tex = theme.wall
  local door_tex = door_info.tex
  local key_tex  = door_info.tex
  local track_tex = door_info.track or THEME.mats.TRACK.wall

  local DOOR = { f_h = z+8, c_h = z+8,
                 f_tex = THEME.mats.DOOR_FRAME.floor,
                 c_tex = THEME.mats.DOOR_FRAME.floor,
                 light = 255,
                 door_kind = 1,
                 l_tex = theme.wall,
                 u_tex = door_tex,
                 [dir]  = { u_peg="bottom" }, [10-dir]  = { u_peg="bottom" },
                 [adir] = { l_peg="bottom" }, [10-adir] = { l_peg="bottom" }, -- TRACK
               }

  local STEP = { f_h = z+8, c_h = z+8+high,
                    f_tex = DOOR.f_tex,
                    c_tex = door_info.frame_top or DOOR.f_tex,
                    light=255,
                    l_tex = door_info.step or theme.step or THEME.mats.STEP.wall,
                    u_tex = wall_tex,
                    [dir] = { l_peg="top" },
                    [10-dir] = { l_peg="top" },
                }

  local SIGN
  
  if theme.sign then
    SIGN = { f_h = z+8, c_h = z+8+high-16,
               f_tex = STEP.f_tex, c_tex = theme.sign_bottom,
               light=255,
               l_tex = theme.sign, u_tex = theme.sign }

  elseif theme.front_mark then
    SIGN = { solid = wall_tex, 
             [dir]    = { l_tex = theme.front_mark},
             [10-dir] = { l_tex = theme.front_mark} }
  end

  local fx = 1 + (x-1)*FW
  local fy = 1 + (y-1)*FH

  if (dir == 4) then fx = fx + FW - 1 end
  if (dir == 2) then fy = fy + FH - 1 end

  assert (long >= 2 and deep <= 2)

  local step = 1 + (deep - 1) * 2
  assert(step * 2 + 2 == deep * FW)

  local side = (long - door_w) * 2

--con.debugf("EXIT: door_w=%d long=%d side=%d\n", door_w, long, side)

  long = long * 4 - side * 2
  assert(long == 4 or long == 8)

  local sx, sy = ax*side, ay*side
  local ex, ey = ax*(long+side-1), ay*(long+side-1)
  local zx, zy = ax*(long+side*2-1), ay*(long+side*2-1)

--con.debugf("long_f=%d  ax=%d sx=%d ex=%d zx=%d\n", long, ax, sx, ex, zx)

  frag_fill(p,c, fx, fy, fx+zx+dx*7, fy+zy+dy*7, { solid=wall_tex })

  if door_info.frame_side then

    -- align inner sides y_offset with outside wall
    local y_diff = link_other(link, c).ceil_h - STEP.c_h
    frag_fill(p,c, fx+sx-ax, fy+sy-ay, fx+sx-ax+dx*7, fy+sy-ay+dy*7,
      { solid=wall_tex, [adir]={ l_tex=door_info.frame_side, y_offset=y_diff }} )
    frag_fill(p,c, fx+ex+ax, fy+ey+ay, fx+ex+ax+dx*7, fy+ey+ay+dy*7,
      { solid=wall_tex, [10-adir]={ l_tex=door_info.frame_side, y_offset=y_diff }} )
  end

  if theme.front_mark then
    frag_fill(p,c, fx, fy, fx+zx+dx, fy+zy+dy, STEP)

    frag_fill(p,c, fx+dx*2, fy+dy*2, fx+ax*3+dx*2, fy+ay*3+dy*2, SIGN)
    frag_fill(p,c, fx+zx-ax*3+dx*2, fy+zy-ay*3+dy*2, fx+zx+dx*2, fy+zy+dy*2, SIGN)
  end

  for ff = 1,4 do
    if ff == 4 then
      frag_fill (p,c, fx+ax,fy+ay, fx+ax,fy+ay,
        { solid=key_tex, [adir] = { x_offset = 112 }} )
      frag_fill (p,c, fx+zx-ax,fy+zy-ay, fx+zx-ax,fy+zy-ay,
        { solid=key_tex, [10-adir] = { x_offset = 112 }} )
    end

    frag_fill (p,c, fx+sx,fy+sy, fx+ex,fy+ey, STEP)

    -- EXIT SIGN
    if theme.sign and (ff == 2) then
      frag_fill (p,c, fx+sx+ax,fy+sy+ay, fx+sx+ax*2,fy+sy+ay*2, SIGN,
        { [10-adir] = { x_offset = 32 },
          [adir] = { x_offset = 32 }} )
    end

    fx = fx + dx; fy = fy + dy
  end

  for mm = 1,1 do
    frag_fill (p,c, fx+ax,fy+ay, fx+zx-ax,fy+zy-ay, { solid=track_tex })
    frag_fill (p,c, fx+sx,fy+sy, fx+ex,fy+ey, DOOR)
    fx = fx + dx; fy = fy + dy
  end

  for bb = 1,3 do
    if bb == 1 then
      frag_fill (p,c, fx+ax,fy+ay, fx+ax,fy+ay,
        { solid=key_tex, [adir] = { x_offset = 112 }} )
      frag_fill (p,c, fx+zx-ax,fy+zy-ay, fx+zx-ax,fy+zy-ay,
        { solid=key_tex, [10-adir] = { x_offset = 112 }} )
    end
    frag_fill (p,c, fx+sx,fy+sy, fx+ex,fy+ey, STEP)
    fx = fx + dx; fy = fy + dy
  end
end


--
-- Build an exit hole
--
function B_exit_hole(p,c, kx,ky, sec)

  assert(sec)

  local bx = chunk_to_block(kx)
  local by = chunk_to_block(ky)

  gap_fill(p,c, bx,by, bx+KW-1, by+KH-1, sec,
           { l_tex = c.theme.hole_tex or c.theme.void })

  -- we want the central block
  bx, by = bx+1,by+1

  local fx = (bx - 1) * FW
  local fy = (by - 1) * FH

  local HOLE = copy_block(sec)

  HOLE.f_h = HOLE.f_h - 16
  HOLE.f_tex = THEME.SKY_TEX

  HOLE.walk_kind = 52 -- "exit_W1"
  HOLE.short = true
  HOLE.is_cage = true  -- don't place items/monsters here

  frag_fill(p,c, fx+1,fy+1, fx+FW,fy+FH, HOLE)

  local radius = 60

  for y = 1,FH+1 do
    for x = 1,FW+1 do
      if (x==1 or x==FW+1 or y==1 or y==FH+1) then

        local zx = fx + math.min(x,FW)
        local zy = fy + math.min(y,FH)

        local dir
        if y == FH+1 then
          dir = sel(x==FW+1, 9, 7)
        else
          dir = sel(x==FW+1, 3, 1)
        end

        assert(dir)

        local cur_x = (x - 3) * 16
        local cur_y = (y - 3) * 16

        local len = dist(0,0, cur_x,cur_y)
        assert(len > 0)

        local want_x = cur_x/len * radius
        local want_y = cur_y/len * radius

        move_frag(p,c, zx,zy,dir, want_x - cur_x, want_y - cur_y)
      end
    end
  end
end


--
-- Build a stair
--
-- Z is the starting height
--
function B_stair(p, c, bx, by, z, dir, long, deep, step)

  local dx, dy = dir_to_delta(dir)
  local ax, ay = dir_to_across(dir)

  local fx = (bx - 1) * FW + 1
  local fy = (by - 1) * FH + 1

  if (dir == 4) then fx = fx + FW - 1 end
  if (dir == 2) then fy = fy + FH - 1 end

  local zx = ax * (long*4-1)
  local zy = ay * (long*4-1)

  local out_dir = sel(step < 0, dir, 10-dir)

  -- first step is always raised off the ground
  if step > 0 then z = z + step end

  for i = 1,deep*4 do

    local sec = { f_h = z,
                  c_h = c.ceil_h,   -- FIXME
                  f_tex = c.theme.step_flat or c.theme.floor,
                  c_tex = c.theme.ceil,
                  light = c.light,

                  l_tex = c.theme.wall,
                  u_tex = c.theme.wall,

                  [out_dir]={ l_tex=c.theme.step, l_peg="top" },
                }

    frag_fill(p,c, fx, fy, fx+zx, fy+zy, sec)

    fx = fx + dx; fy = fy + dy; z = z + step
  end
end


--
-- Build a lift
--
-- Z is the starting height
--
function B_lift(p, c, x, y, z, dir, long, deep)

  local dx, dy = dir_to_delta(dir)
  local ax, ay = dir_to_across(dir)

  local LIFT =
  {
    f_h = z,
    c_h = c.ceil_h,
    f_tex = c.theme.lift_flat or THEME.mats.LIFT.floor,
    c_tex = c.theme.ceil,
    light = c.light,

    lift_kind = 123,  -- 62 for slower kind
    lift_walk = 120,  -- 88 for slower kind
    tag = allocate_tag(p),

    l_tex = c.theme.lift or THEME.mats.LIFT.wall,
    u_tex = c.theme.wall,

    [2] = { l_peg="top" }, [4] = { l_peg="top" },
    [6] = { l_peg="top" }, [8] = { l_peg="top" },
  }

  fill(p,c, x, y,
       x + (long-1) * ax + (deep-1) * dx,
       y + (long-1) * ay + (deep-1) * dy, LIFT)
end


--
-- Build a pillar switch
--
function B_pillar_switch(p,c, K,x,y, info, kind, tag)

  local SWITCH =
  {
    solid = info.switch,

    switch_kind = kind,
    switch_tag = tag,

    [2] = { l_peg="bottom" },
    [4] = { l_peg="bottom" },
    [6] = { l_peg="bottom" },
    [8] = { l_peg="bottom" },
  }

  fill(p,c, x,y, x,y, SWITCH)
end


--
-- Build a floor-standing switch
--
function B_floor_switch(p,c, x,y,z, side, info, kind, tag)

  local fx = (x - 1) * FW
  local fy = (y - 1) * FH

  local BASE = copy_block(c.rmodel)

  BASE.f_h = z
  BASE.l_tex = c.theme.wall
  BASE.u_tex = c.theme.wall
  BASE.near_switch = true

  frag_fill(p,c, fx+1,fy+1, fx+FW,fy+FH, BASE)

  local SWITCH =
  {
    f_h = z + 64,
    c_h = c.ceil_h,
    f_tex = THEME.mats.METAL.floor,
    c_tex = c.theme.ceil,
    light = c.light,

    l_tex = info.switch,
    u_tex = c.theme.wall,

    switch_kind = kind,
    switch_tag  = tag,

    [2] = { l_peg="bottom" },
    [4] = { l_peg="bottom" },
    [6] = { l_peg="bottom" },
    [8] = { l_peg="bottom" },
  }

  local sx,sy, ex,ey = side_to_corner(side, FW, FH)

  frag_fill(p,c, fx+sx,fy+sy, fx+ex,fy+ey, SWITCH)
end


function B_wall_switch(p,c, x,y,z, side, long, sw_info, kind, tag)

  assert(long == 2 or long == 3)

  local ax, ay = dir_to_across(side)

  if long == 3 then x,y = x-ax, y-ay end

  local fx = (x - 1) * FW
  local fy = (y - 1) * FH

  frag_fill(p,c, fx+1,fy+1, fx+(long-1)*ax*FW+FW,fy+(long-1)*ay*FH+FH, { solid=c.theme.void })

  local SWITCH =
  {
    f_h = z,
    c_h = z + 64,
    f_tex = c.theme.floor,
    c_tex = c.theme.arch_ceil or c.theme.floor, -- SKY is no good
    light = 224,

    l_tex = c.theme.void,
    u_tex = c.theme.void,
    near_switch = true,
  }

  local sx,sy, ex,ey = side_to_corner(side, FW, FH)
  local dx,dy = dir_to_delta(10-side)

  local pos = (long - 1) * 2

  sx,sy = sx + pos*ax, sy + pos*ay
  ex,ey = ex + pos*ax, ey + pos*ay

  frag_fill(p,c, fx+sx,fy+sy, fx+ex,fy+ey, SWITCH)

  -- lights
  if THEME.mats.SW_FRAME then
    local sw_side = THEME.mats.SW_FRAME.wall

    local lit_dir = sel(side==2 or side==8, 6, 8)
    frag_fill(p,c, fx+sx-ax,fy+sy-ay, fx+sx-ax,fy+sy-ay,
         { solid=c.theme.void, [lit_dir]={ l_tex = sw_side }} )
    frag_fill(p,c, fx+ex+ax,fy+ey+ay, fx+ex+ax,fy+ey+ay,
         { solid=c.theme.void, [10-lit_dir]={ l_tex = sw_side }} )
  end

  sx,sy = sx+dx, sy+dy
  ex,ey = ex+dx, ey+dy

  local SWITCH_BACK =
  {
    solid = sw_info.switch,
    switch_kind = kind,
    switch_tag = tag,
    [side] = { l_peg="bottom" } 
  } 

  frag_fill(p,c, fx+sx,fy+sy, fx+ex,fy+ey, SWITCH_BACK);
end


--
-- Build a pedestal (items, players)
-- 
function B_pedestal(p, c, x, y, z, info, overrides)
 
  local PEDESTAL =
  {
    f_h   = z + info.h,
    f_tex = info.floor,
    c_h   = c.ceil_h,
    c_tex = c.theme.ceil,
    light = c.light,

    l_tex = info.wall,
    u_tex = c.theme.wall
  }

--FIXME temp (shouldn't be needed)
if (PEDESTAL.c_h - PEDESTAL.f_h) < 64 then
  PEDESTAL.c_h = PEDESTAL.f_h + 64
end

  fill(p,c, x,y, x,y, PEDESTAL, overrides)
end


function B_double_pedestal(p, c, bx, by, z, ped_info, overrides)
 
  local OUTER =
  {
    f_h   = ped_info.h + z,
    f_tex = ped_info.floor,
    l_tex = ped_info.wall,
    light = ped_info.light,

    c_h   = c.ceil_h - ped_info.h,
    c_tex = ped_info.floor,
    u_tex = ped_info.wall,

    kind  = ped_info.glow and 8 -- GLOW TYPE  (FIXME)
  }

  local INNER =
  {
    f_h   = ped_info.h2 + z,
    f_tex = ped_info.floor2,
    l_tex = ped_info.wall2,
    light = ped_info.light2,

    c_h   = c.ceil_h - ped_info.h2,
    c_tex = ped_info.floor2,
    u_tex = ped_info.wall2,

    kind = ped_info.glow2 and 8 -- GLOW TYPE  (FIXME)
  }

  if c.theme.outdoor then
    OUTER.c_h   = c.ceil_h
    OUTER.c_tex = c.theme.ceil

    INNER.c_h   = c.ceil_h
    INNER.c_tex = c.theme.ceil
  end

--FIXME temp (shouldn't be needed)
if (OUTER.c_h - OUTER.f_h) < 64 then
  OUTER.c_h = OUTER.f_h + 64
end
if (INNER.c_h - INNER.f_h) < 64 then
  INNER.c_h = INNER.f_h + 64
end

  local fx = (bx - 1) * FW
  local fy = (by - 1) * FH

  frag_fill(p,c, fx+1,fy+1, fx+4,fy+4, OUTER, overrides)

  if ped_info.rotate2 then
    frag_fill(p,c, fx+2,fy+2, fx+2,fy+2, INNER)

    move_frag(p,c, fx+2,fy+2, 1, 16, -6)
    move_frag(p,c, fx+2,fy+2, 3, 22, 16)
    move_frag(p,c, fx+2,fy+2, 7, -6,  0)
    move_frag(p,c, fx+2,fy+2, 9,  0, 22)
  else
    frag_fill(p,c, fx+2,fy+2, fx+3,fy+3, INNER)
  end
end


--
-- Build some bars
--
-- Use a nil 'tag' parameter for solid bars, otherwise
-- the bars will be openable (by LOWERING!).
--
-- size must be either 1 or 2.
--
function B_bars(p,c, x,y, dir,long, size,step, bar_theme, sec,tex,
                tag, need_sides)

  local dx, dy = dir_to_delta(dir)
  local ax, ay = dir_to_across(dir)

  local bar

  if tag then
    bar = copy_block(sec)
    bar.f_h = bar.c_h
    bar.f_tex = bar_theme.floor
    bar.c_tex = bar_theme.floor
    bar.kind = nil
    bar.tag = tag

    bar.l_tex = bar_theme.wall
    bar.u_tex = bar_theme.wall
  else
    bar = { solid=bar_theme.wall }
  end

  sec = copy_block(sec)
  sec.l_tex = tex
  sec.u_tex = tex

  for d_pos = 0,long-1 do
    local fx = (x + d_pos*ax - 1) * FW + 1
    local fy = (y + d_pos*ay - 1) * FH + 1

    frag_fill(p,c, fx,fy, fx+FW-1,fy+FH-1, sec)
  end

  for d_pos = 0,long*4-1,step do
    local fx = (x - 1) * FW + 1 + d_pos*ax
    local fy = (y - 1) * FH + 1 + d_pos*ay

    frag_fill(p,c, fx+1,fy+1, fx+size,fy+size, bar)
  end

  if need_sides then
    fill(p,c, x-ax,y-ay, x-ax,y-ay, { solid=tex })

    x,y = x+long*ax, y+long*ay
    fill(p,c, x,y, x,y, { solid=tex })
  end
end


--
-- fill a chunk with void, with pictures on the wall
--
function B_void_pic(p,c, kx,ky, pic, cuts)

  local z = (c.c_min + c.f_max) / 2
  local h = pic.h or (c.c_min - c.f_max - 32)

  local z1 = z-h/2
  local z2 = z+h/2

  local x1 = chunk_to_block(kx)
  local y1 = chunk_to_block(ky)
  local x2 = chunk_to_block(kx + 1) - 1
  local y2 = chunk_to_block(ky + 1) - 1

  local fx = (x1 - 1) * FW
  local fy = (y1 - 1) * FH

  frag_fill(p,c, fx+1,fy+1, fx+3*FW,fy+3*FH, { solid=c.theme.wall })

  local INNER =
  {
    solid = pic.tex or pic.wall,
    
    x_offset = pic.x_offset,
    y_offset = pic.y_offset,
  }
  assert(INNER.solid)

  frag_fill(p,c, fx+2,fy+2, fx+3*FW-1,fy+3*FH-1, INNER)

  local CUTOUT =
  {
    f_h = z1,
    c_h = z2,
    f_tex = c.theme.arch_floor or c.theme.floor,
    c_tex = c.theme.arch_ceil  or c.theme.floor, -- SKY is no good
    light = c.light,

    l_tex = c.theme.wall,
    u_tex = c.theme.wall,
  }

  if cuts >= 3 or pic.glow then  -- FIXME: better way to decide
    CUTOUT.light = 255
    CUTOUT.kind  = 8  -- GLOW TYPE  (FIXME)
  end

  for side = 2,8,2 do

      local ax,ay = dir_to_across(side)
--  local dx,dy = dir_to_delta(side)

      local sx,sy, ex,ey = side_to_corner(side, FW*3, FH*3)

      if cuts == 1 then
        frag_fill(p,c, fx+sx+2*ax,fy+sy+2*ay, fx+ex-2*ax,fy+ey-2*ay, CUTOUT)
      elseif cuts == 2 then
        frag_fill(p,c, fx+sx+ax,fy+sy+ay, fx+sx+4*ax,fy+sy+4*ay, CUTOUT)
        frag_fill(p,c, fx+ex-4*ax,fy+ey-4*ay, fx+ex-ax,fy+ey-ay, CUTOUT)
      elseif cuts == 3 then
        for i = 0,2 do
          local j = i*FW + 1
          frag_fill(p,c, fx+sx+j*ax,fy+sy+j*ay, fx+sx+(j+1)*ax,fy+sy+(j+1)*ay, CUTOUT)
        end
      elseif cuts == 4 then
        for i = 0,2,2 do
          local j = i*FW + sel(i==0, 2, 1)
          frag_fill(p,c, fx+sx+j*ax,fy+sy+j*ay, fx+sx+j*ax,fy+sy+j*ay, CUTOUT)
        end
      end

  end
end

function B_pillar(p,c, theme, kx,ky, bx,by)

  local K = c.chunks[kx][ky]

  local PILLAR =
  {
    solid = theme.pillar or theme.void or theme.wall,
    y_offset = 128 - (K.ceil_h - K.floor_h)
  }

  fill(p,c, bx, by, bx, by, PILLAR)
end

function B_crate(p,c, crate_info, base, kx,ky, bx,by)

  local K = c.chunks[kx][ky]

  local CRATE = copy_block(base)

  CRATE.f_h   = K.floor_h + crate_info.h
  CRATE.c_h   = math.max(base.c_h, CRATE.f_h)
  CRATE.f_tex = crate_info.floor
  CRATE.l_tex = crate_info.wall
  CRATE.is_cage = true  -- don't put monsters/pickups here
  CRATE.kind = nil      -- don't damage player (if chunk is lava)

  local x_ofs = crate_info.x_offset
  local y_ofs = crate_info.y_offset

  if c.theme.outdoor or not c.sky_light then
    if crate_info.can_rotate and rand_odds(50) then
      rotate_block(CRATE, 0)
      CRATE.rotated = true
      x_ofs = crate_info.rot_x_offset or 9
    end
  end

  if crate_info.can_xshift and rand_odds(50) then
    x_ofs = (x_ofs or 0) + crate_info.can_xshift
  end
  if crate_info.can_yshift and rand_odds(50) then
    y_ofs = (y_ofs or 0) + crate_info.can_yshift
  end

  local x_ofs2 = crate_info.side_x_offset or x_ofs
  local y_ofs2 = crate_info.side_y_offset or y_ofs

  if rand_odds(50) then x_ofs,x_ofs2 = x_ofs2,x_ofs end
  if rand_odds(50) then y_ofs,y_ofs2 = y_ofs2,y_ofs end

  fill(p,c, bx, by, bx, by, CRATE,
       { [2] = { l_peg="top", x_offset=x_ofs,  y_offset=y_ofs  },
         [4] = { l_peg="top", x_offset=x_ofs2, y_offset=y_ofs2 },
         [6] = { l_peg="top", x_offset=x_ofs2, y_offset=y_ofs2 },
         [8] = { l_peg="top", x_offset=x_ofs,  y_offset=y_ofs  } })

  -- sometimes put monsters on top
  if not CRATE.rotated and (CRATE.c_h >= CRATE.f_h + 80) and rand_odds(33) then
    local spot = { c=c, x=bx, y=by, different=true }
    add_cage_spot(p,c, spot)
  end
end

function cage_select_height(p,c, kind, theme,rail, floor_h, ceil_h)

  if c[kind] and c[kind].z >= floor_h and rand_odds(80) then
    return c[kind].z, c[kind].open_top
  end
  
  local open_top = false

  if rail.h < 72 then open_top = true end
  if ceil_h >= floor_h + 256 then open_top = true end
  if dual_odds(c.outdoor, 50, 10) then open_top = true end

  local z1 = floor_h + 32
  local z2 = math.min(floor_h + 128, ceil_h - 16 - rail.h)

  local r = con.random() * 100
      if r < 16 then z2 = z1
  elseif r < 50 then z1 = z2
  end

  z1 = (z1+z2)/2

  if not c[kind] then
    c[kind] = { z=z1, open_top=open_top }
  end

  return (z1+z2)/2, open_top
end

function B_pillar_cage(p,c, theme, kx,ky, bx,by)

  local K = c.chunks[kx][ky]

  local rail
  if K.ceil_h < K.floor_h+192 then
    rail = THEME.rails["r_1"]  -- FIXME: want "short" rail
  else
    rail = get_rand_rail()
  end
  assert(rail)

---###  local z = (c.f_max + c.ceil_h) / 2
---###  z = math.min(z, K.floor_h + 128)

  local kind = sel(kx==2 and ky==2, "middle_cage", "pillar_cage")

  local z, open_top = cage_select_height(p,c, kind, theme,rail, K.floor_h,K.ceil_h)

  if kx==2 and ky==2 and dual_odds(c.theme.outdoor, 90, 20) then
    open_top = true
  end

  local CAGE = copy_block(c.rmodel)

  CAGE.f_h   = z
  CAGE.f_tex = theme.floor
  CAGE.l_tex = theme.wall
  CAGE.u_tex = theme.wall
  CAGE.rail  = rail.tex

  CAGE.is_cage = true

  if not open_top then
    CAGE.c_h = CAGE.f_h + rail.h
    CAGE.c_tex = theme.ceil
    CAGE.light = 192  -- FIXME: from CAGE theme
  end

--  if K.dud_chunk and (c.theme.outdoor or not c.sky_light) then
--    rotate_block(CAGE,32)
--  end

  fill(p,c, bx,by, bx,by, CAGE)

  local spot = {c=c, x=bx, y=by}
  if kx==2 and ky==2 then spot.different = true end

  add_cage_spot(p,c, spot)
end

--
-- Build a chunk-sized monster cage
--
function B_big_cage(p,c, theme, kx,ky)

  local bx = chunk_to_block(kx)
  local by = chunk_to_block(ky)

  local rail = get_rand_rail()
  assert(rail)

  -- FIXME: some of this is duplicated above, merge it
 
  local rail
  if c.ceil_h < c.floor_h+192 then
    rail = THEME.rails["r_1"]
  else
    rail = get_rand_rail()
  end
  assert(rail)

  local z, open_top = cage_select_height(p,c, "big_cage", theme,rail, c.floor_h,c.ceil_h)

  local CAGE = copy_block(c.rmodel)

  CAGE.f_h   = z
  CAGE.f_tex = theme.floor
  CAGE.l_tex = theme.wall
  CAGE.u_tex = theme.wall

  CAGE.is_cage = true

  if not open_top then
    CAGE.c_h = CAGE.f_h + rail.h
    CAGE.c_tex = theme.ceil
    CAGE.light = 176
  end

  for x = 0,2 do for y = 0,2 do

    local overrides = {}
    if x == 0 then overrides[4] = { rail=rail.tex } end
    if x == 2 then overrides[6] = { rail=rail.tex } end
    if y == 0 then overrides[2] = { rail=rail.tex } end
    if y == 2 then overrides[8] = { rail=rail.tex } end

    fill(p,c, bx+x,by+y, bx+x,by+y, CAGE, overrides)
  end end

  local spot = {c=c, x=bx, y=by, double=true, dx=32, dy=32}
  if kx==2 and ky==2 then spot.different = true end

  add_cage_spot(p,c, spot)
end

--
-- Build a hidden monster closet
--
function B_monster_closet(p,c, kx,ky, z, tag)

  local bx = chunk_to_block(kx)
  local by = chunk_to_block(ky)

  local INNER =
  {
    f_h = z,
    c_h = c.ceil_h,
    f_tex = c.theme.floor,
    c_tex = c.theme.ceil, --!! c.theme.arch_ceil or c.theme.floor,
    light = c.light,

    l_tex = c.theme.void,
    u_tex = c.theme.void,
    is_cage = true
  }

  local OUTER = copy_block(INNER)

  OUTER.c_h = OUTER.f_h
  OUTER.c_tex = c.theme.arch_ceil or OUTER.f_tex
  OUTER.tag = tag

  local x1 = chunk_to_block(kx)
  local y1 = chunk_to_block(ky)
  local x2 = chunk_to_block(kx + 1) - 1
  local y2 = chunk_to_block(ky + 1) - 1

  local fx = (x1 - 1) * FW
  local fy = (y1 - 1) * FH

  frag_fill(p,c, fx+1,fy+1, fx+3*FW,fy+3*FH, OUTER);
  frag_fill(p,c, fx+2,fy+2, fx+3*FW-1,fy+3*FH-1, INNER)

  return { c=c, x=bx, y=by, double=true, dx=32, dy=32 }
end

--
-- create a deathmatch exit room
--
-- FIXME: it always faces south
--
function B_deathmatch_exit(p,c, kx,ky)

  local theme = p.exit_theme

  local x1 = chunk_to_block(kx)
  local y1 = chunk_to_block(ky)
  local x2 = chunk_to_block(kx + 1) - 1
  local y2 = chunk_to_block(ky + 1) - 1

  local fx = (x1 - 1) * FW
  local fy = (y1 - 1) * FH

  local door_info = theme.door

  local ROOM =
  {
    f_h = c.rmodel.f_h,
    c_h = c.rmodel.f_h + 72,
    f_tex = theme.floor,
    c_tex = theme.ceil,
    light = 176,

    l_tex = theme.void,
    u_tex = theme.void,
  }

  frag_fill(p,c, fx+1,fy+1, fx+3*FW,fy+3*FH, { solid=theme.void })
  frag_fill(p,c, fx+2,fy+5, fx+3*FW-1,fy+3*FH-1, ROOM)

  if theme.front_mark then
    frag_fill(p,c, fx+1,fy+1, fx+3*FW,fy+1, { solid=theme.front_mark })
  end

  local STEP =
  {
    f_h = c.rmodel.f_h + 8,
    c_h = c.rmodel.f_h + 80,
    f_tex = THEME.mats.DOOR_FRAME.floor,
    c_tex = THEME.mats.DOOR_FRAME.floor,
    light = 255,

    l_tex = theme.step or THEME.mats.STEP.wall,
    u_tex = theme.void,
  }

---##  frag_fill(p,c, fx+4,fy+1, fx+9,fy+4, { solid=theme.void})

  frag_fill(p,c, fx+5,fy+1, fx+8,fy+4, STEP)

  local DOOR =
  {
    f_h = c.rmodel.f_h + 8,
    c_h = c.rmodel.f_h + 8,
    f_tex = door_info.frame_bottom or STEP.f_tex,
    c_tex = door_info.bottom       or STEP.f_tex,
    light = 255,

    l_tex = c.theme.wall,
    u_tex = door_info.tex,
    door_kind = 1,

    [2] = { u_peg="bottom" }, [8] = { u_peg="bottom" },
    [4] = { l_peg="bottom" }, [6] = { l_peg="bottom" }, -- TRACK
  }

  frag_fill(p,c, fx+4,fy+2, fx+9,fy+3, { solid=THEME.mats.TRACK.wall })
  frag_fill(p,c, fx+5,fy+2, fx+8,fy+3, DOOR)

  local SWITCH =
  {
    solid = theme.switch.switch,
    switch_kind = 11
  }

  frag_fill(p,c, fx+5,fy+11, fx+8,fy+12, SWITCH)
end


----------------------------------------------------------------

SKY_LIGHT_FUNCS =
{
  all      = function(kx,ky, x,y) return true end,
  middle   = function(kx,ky, x,y) return kx==2 and ky==2 end,
  pillar   = function(kx,ky, x,y) return not (kx==2 and ky==2) end,

--  pillar_2 = function(kx,ky, x,y) return kx==2 and ky==2 end,

  double_x = function(kx,ky, x,y) return (x % 2) == 0 end,
  double_y = function(kx,ky, x,y) return (y % 2) == 0 end,

  triple_x = function(kx,ky, x,y) return (x % 3) == 2 end,
  triple_y = function(kx,ky, x,y) return (y % 3) == 2 end,

  holes_2 = function(kx,ky, x,y) return (x % 2) == 0 and (y % 2) == 0 end,
  holes_3 = function(kx,ky, x,y) return (x % 3) == 2 and (y % 3) == 2 end,

  boggle = function(kx,ky, x,y)
    return not ((x % 3) == 2 or (y % 3) == 2) end,

  pin_hole = function(kx,ky, x,y)
    return kx==2 and ky==2 and (x % 3 )== 2 and (y % 3) == 2 end,

  cross_1 = function(kx,ky, x,y)
    return (kx==2 and (x % 3) == 2) or 
           (ky==2 and (y % 3) == 2) end,

  cross_2 = function(kx,ky, x,y)
    return (kx==2 and ky==2) and
      ((x % 3) == 2 or (y % 3) == 2) end,

  pieces_1 = function(kx,ky, x,y)
    return (kx~=2 and ky==2 and (y%3)==2) or
           (kx==2 and ky~=2 and (x%3)==2) end,

  pieces_2 = function(kx,ky, x,y)
    return (kx~=2 and ky==2 and (x%3)==2) or
           (kx==2 and ky~=2 and (y%3)==2) end,

  weird = function(kx,ky, x,y)
    return (kx==2 or ky==2) and not (kx==2 and ky==2) and
      ((x % 3) == 2 or (y % 3) == 2) end,

--  cross = function(kx,ky, x,y) return kx==2 or  ky==2 end,
--  hash  = function(kx,ky, x,y)
--    return (kx==2 or ky==2) and not
--      ((x % 3) == 1 or (y % 3) == 1) end,
}

function random_sky_light()
  local names = {}
  for kind,func in pairs(SKY_LIGHT_FUNCS) do
    table.insert(names,kind)
  end
  return rand_element(names)
end


----------------------------------------------------------------


function setup_rmodel(p, c)

  if not c.light then
    c.light = sel(c.theme.outdoor, 192, 144)
  end

  c.rmodel =
  {
    f_h=c.floor_h,
    c_h=c.ceil_h,
    f_tex=c.theme.floor,
    c_tex=c.theme.ceil,
    light=c.light,
  }
end

function make_chunks(p)

  local function count_empty_chunks(c)
    local count = 0
    for kx = 1,KW do
      for ky = 1,KH do
        if not c.chunks[kx][ky] then
          count = count + 1
        end
      end
    end
    return count
  end

  local function empty_chunk(c)
    -- OPTIMISE with rand_shuffle
    for loop = 1,999 do
      local kx = rand_irange(1,KW)
      local ky = rand_irange(1,KH)

      if not c.chunks[kx][ky] then return kx, ky end
    end
  end


  local function alloc_door_spot(c, side, link)

    -- figure out which chunks are needed
    local coords = {}

    local kx, ky = side_to_chunk(side)
    local ax, ay = dir_to_across(side)

    assert(not c.chunks[kx][ky])

    if link.where == "double" then
      table.insert(coords, {x=kx+ax, y=ky+ay})
      table.insert(coords, {x=kx-ax, y=ky-ay})
      
      local no_void = c.closet[2] or c.closet[4] or c.closet[6] or c.closet[8]

      -- what shall we put in-between?
      local r = con.random() * 100
      if r < 40 then
        c.chunks[kx][ky] = { link=link }
      elseif r < 80 or no_void then
        c.chunks[kx][ky] = { room=true }
      else
        c.chunks[kx][ky] = { void=true }
      end

    elseif link.where == "wide" then
      table.insert(coords, {x=kx+ax, y=ky+ay})
      table.insert(coords, {x=kx   , y=ky   })
      table.insert(coords, {x=kx-ax, y=ky-ay})

    else
      local d_pos = where_to_block(link.where, link.long)
      -- FIXME DUPLICATED SHITE
      local d_min, d_max = 1, BW - (link.long-1)
      if (d_pos < d_min) then d_pos = d_min end
      if (d_pos > d_max) then d_pos = d_max end

      local j1 = int((d_pos - 1) / JW)
      local j2 = int((d_pos - 1 + link.long-1) / JW)
      
      for j = j1,j2 do
        assert (0 <= j and j < KW)
        table.insert(coords,
          { x = kx-ax + ax * j, y = ky-ay + ay * j })
      end

---###      if wh < 0 then wh, ax, ay = -wh, -ax, -ay end
---###      if wh > 2 then wh = 2 end
---###
---###      table.insert(coords,
---###        { x = kx+ax * int(wh/2),
---###          y = ky+ay * int(wh/2) })
---###
---###      if wh == 1 then -- straddles two chunks
---###        table.insert(coords, { x=kx+ax, y=ky+ay })
---###      end
    end

    -- now check for clashes
    local has_clash = false

    for zzz,loc in ipairs(coords) do

      kx, ky = loc.x, loc.y
      assert (1 <= kx and kx <= KW)
      assert (1 <= ky and ky <= KH)

      if c.chunks[kx][ky] then
        -- do c.chunks[kx][ky] = { link="#" }; return true end
        has_clash = true
        c.chunks.clasher = c.chunks[kx][ky]
      else
        c.chunks[kx][ky] = { link=link }
      end
    end
    return not has_clash
  end

  local function put_chunks_in_cell(c)

    if c.chunks then
      -- last time was successful, nothing to do
      return true
    end

    c.chunks = array_2D(KW, KH)

    for side,L in pairs(c.link) do

      if not alloc_door_spot(c, side, L) then
        assert(c.chunks.clasher)

        -- con.debugf("  CLASH IN (%d,%d)\n", c.x, c.y)

        -- be fair about which link we will blame
        if c.chunks.clasher.link and rand_odds(50) then
          L = c.chunks.clasher.link
        end

        -- remove the chunks from the offending cells and
        -- select a different exit position
        L.src.chunks  = nil
        L.dest.chunks = nil

        L.where = random_where(L)

        return false
      end
    end

    return true --OK--
  end


  local function add_essential_chunks(c)
    -- this makes sure that there is always a path
    -- from one chunk to another.  The problem areas
    -- look like this:
    -- 
    --    X |##   We need to make X and Y touch, so
    --    --+--   copy X or Y into an empty corner.
    --    ##| Y

    local function check_pair(x1,y1, x2,y2)

      -- are X or Y empty?
      if not (c.chunks[x1][y2] and c.chunks[x2][y1]) then
        return
      end

      local k1 = c.chunks[x1][y1]
      local k2 = c.chunks[x2][y2]

      if k1 and not k1.void then return end
      if k2 and not k2.void then return end

      -- from here on, k1 and k2 being non-nil implies
      -- they are void-space
      assert(not (k1 and k2))

      local src_x, src_y = x1,y2
      if rand_odds(50) then src_x, src_y = x2,y1 end

      local dest_x, dest_y = x1,y1

      if k1 or (not k2 and rand_odds(50)) then
        dest_x, dest_y = x2,y2
      end

      c.chunks[dest_x][dest_y] = copy_chunk(c.chunks[src_x][src_y])
    end

    local function check_corner(dir)
      local dx, dy = dir_to_delta(dir)
      dx,dy = 2+dx, 2+dy
      
      local K = c.chunks[dx][dy]
      if K and K.link and K.link.build == c then
        local A = c.chunks[dx][2]
        local B = c.chunks[2][dy]

        --if A and not is_roomy(A) then A = nil end
        --if B and not is_roomy(B) then B = nil end

        if not (A and is_roomy(c, A)) and
           not (B and is_roomy(c, B)) then

              if not A then c.chunks[dx][2] = { room=true }
          elseif not B then c.chunks[2][dy] = { room=true }
          end
        end
      end
    end

    -- centre chunk always roomy  (FIXME ??)
    c.chunks[2][2] = { room=true }  

    local pair_list =
    {
      { 2,1, 1,2 }, { 2,1, 3,2 },
      { 2,3, 1,2 }, { 2,3, 3,2 }
    }

    rand_shuffle(pair_list)

    for zzz, pair in ipairs(pair_list) do
      check_pair(unpack(pair))
    end

    -- finally, handle the case where a build-link
    -- (which are at room level) is isolated in a corner.
    -- [Not strictly essential, but prevents unneeded stairs]

    check_corner(1)
    check_corner(3)
    check_corner(7)
    check_corner(9)
  end

  local function chunk_similar(k1, k2)
    assert(k1 and k2)
    if k1.void and k2.void then return true end
    if k1.room and k2.room then return true end
    if k1.cage and k2.cage then return true end
    if k1.liquid and k2.liquid then return true end
    if k1.link and k2.link then return k1.link == k2.link end
    return false
  end

  local BIG_CAGE_ADJUST = { less=50, normal=75, more=90 }

  local function try_flush_side(c)

    -- select a side
    local side = rand_irange(1,4) * 2
    local x1, y1, x2, y2 = side_to_corner(side, KW, KH)

    local common
    local possible = true

    for x = x1,x2 do
      for y = y1,y2 do
        if not possible then break end
        
        local K = c.chunks[x][y]

        if not K then
          -- continue
        elseif not common then
          common = K
        elseif not chunk_similar(common, K) then
          possible = false
        end
      end
    end

    if not (possible and common) then return end

    if not p.coop then
      -- let user adjustment parameters control whether closets and
      -- cages are made bigger.
      if common.closet and not rand_odds(BIG_CAGE_ADJUST[settings.traps]) then
        return
      end
      if common.cage and not rand_odds(BIG_CAGE_ADJUST[settings.mons]) then
        return
      end
    end

    for x = x1,x2 do
      for y = y1,y2 do
        if not c.chunks[x][y] then
          c.chunks[x][y] = copy_chunk(common)
        end
      end
    end
  end

  local function try_grow_room(c)
    local kx, ky

    repeat
      kx, ky = rand_irange(1,KW), rand_irange(1,KH)
    until c.chunks[kx][ky] and c.chunks[kx][ky].room

    local dir_order = { 2,4,6,8 }
    rand_shuffle(dir_order)

    for zzz,dir in ipairs(dir_order) do
      local nx,ny = dir_to_delta(dir)
      nx, ny = kx+nx, ky+ny

      if valid_chunk(nx, ny) then
        if not c.chunks[nx][ny] then
          c.chunks[nx][ny] = { room=true }
          return -- SUCCESS --
        end
      end
    end
  end

  local function void_it_up(c)
    for kx = 1,KW do
      for ky = 1,KH do
        if not c.chunks[kx][ky] then
          c.chunks[kx][ky] = { void=true }
        end
      end
    end
  end

  local function try_add_special(c, name)
    
    if name == "liquid" then
      if not c.liquid then return end
      if c.is_exit and rand_odds(98) then return end
    end

    -- TODO: more cage themes...
    if name == "cage" then
      if not THEME.mats.CAGE then return end
      if c.scenic then return end
    end

    local posits = {}

    for kx = 1,KW do
      for ky = 1,KH do
        if not c.chunks[kx][ky] then
          -- make sure cage has a walkable neighbour
          for dir = 2,8,2 do
            local nx,ny = dir_to_delta(dir)
            nx, ny = kx+nx, ky+ny

            if valid_chunk(nx, ny) and c.chunks[nx][ny] and
               (c.chunks[nx][ny].room or c.chunks[nx][ny].link)
            then
              table.insert(posits, {x=kx, y=ky})
              break;
            end
          end
        end
      end
    end

    if #posits == 0 then return end

    local p = rand_element(posits)

    c.chunks[p.x][p.y] = { [name]=true }
  end

  local function add_closet_chunks(c)
    if not c.quest.closet then return end

    local closet = c.quest.closet

    for idx,place in ipairs(closet.places) do
      if place.c == c then

        -- !!! FIXME: determine side _HERE_ (not in planner)
        local kx,ky = side_to_chunk(place.side)

        if c.chunks[kx][ky] then
          con.printf("WARNING: monster closet stomped a chunk!\n")
          con.printf("CELL (%d,%d)  CHUNK (%d,%d)\n", c.x, c.y, kx, ky)
          con.printf("%s\n", table_to_string(c.chunks[kx][ky], 2))

          show_chunks(p)
        end

        con.debugf("CLOSET CHUNK @ (%d,%d)\n", c.x, c.y)

        c.chunks[kx][ky] = {void=true, closet=true, place=place}
      end
    end
  end

  local function grow_small_exit(c)
    assert(c.entry_dir)
    local kx,ky = side_to_chunk(10 - c.entry_dir)

    if c.chunks[kx][ky] then
      con.printf("WARNING: small_exit stomped a chunk!\n")
    end

    local r = con.random() * 100

    if r < 2 then
      c.chunks[kx][ky] = { room=true }
    elseif r < 12 then
      c.chunks[kx][ky] = { cage=true }
      c.smex_cage = true
    end

    void_it_up(c)
  end

  local function add_dm_exit(c)
    local kx, ky = 1, 3

    if c.chunks[1][3] then
      con.printf("WARNING: deathmatch exit stomped a chunk!\n")
    end

    c.chunks[1][3] = { void=true, dm_exit=true, dir=2 }

    if not c.chunks[1][2] then
      c.chunks[1][2] = { room=true }
    end
  end

  local function flesh_out_cell(c)
    
    if p.deathmatch and c.x == 1 and c.y == p.h then
      add_dm_exit(c)
    end

    -- possibilities:
    --   (a) fill unused chunks with void
    --   (b) fill unused chunks with room
    --   (c) fill unused chunk from nearby ledge

    -- FIXME get probabilities from theme
    local kinds = { "room", "void", "flush", "cage", "liquid" }
    local probs = { 60, 10, 97, 5, 70 }

    if not c.theme.outdoor then probs[2] = 15 end

    if settings.mons == "less" then probs[4] = 3.2 end
    if settings.mons == "more" then probs[4] = 7.5 end

    if p.deathmatch then probs[4] = 0 end

    if c.scenic then probs[2] = 2; probs[4] = 0 end

    -- special handling for hallways...
    if c.hallway then
      if rand_odds(probs[4]) then
        try_add_special(c, "cage")
      end
      void_it_up(c)
    end

    if c.small_exit then
      grow_small_exit(c)
    end

    while count_empty_chunks(c) > 0 do

      local idx = rand_index_by_probs(probs)
      local kind = kinds[idx]

      if kind == "room" then
        try_grow_room(c)
      elseif kind == "void" then
        void_it_up(c)
      elseif kind == "flush" then
        try_flush_side(c)
      else
        try_add_special(c, kind)
      end
    end
  end

  local function setup_chunk_rmodels(c)

      for kx = 1,KW do for ky = 1,KH do
        local K = c.chunks[kx][ky]
        assert(K)

        K.rmodel = copy_table(c.rmodel)
      end end
  end

  local function connect_chunks(c)

    -- connected value:
    --   1 for connected chunk 
    --   0 for not-yet connected chunk 
    --   nil for unconnectable chunks (void space)

    local function init_connx()
      for kx = 1,KW do
        for ky = 1,KH do
          local K = c.chunks[kx][ky]
          assert(K)

          if K.void or K.cage then
            -- skip it

          elseif K.room then
            K.connected = 1

            K.floor_h = c.floor_h
            K.ceil_h  = c.ceil_h

          elseif K.liquid then
            K.connected = 0

            K.floor_h = c.f_min - 12
            K.ceil_h  = c.ceil_h
            
          else
            assert(K.link)
            local other = link_other(K.link, c)

            K.connected = 0

            if K.link.build == c or K.link.kind == "falloff" then
              K.floor_h = c.floor_h
              K.ceil_h  = c.ceil_h
              -- Note: cannot assume that it connects
              -- (it might be an isolated corner).
            else
              
              K.floor_h = other.floor_h
              K.ceil_h  = math.max(c.ceil_h, other.ceil_h) --FIXME
            end
          end
        end
      end
    end

    local function grow_pass()

      local function grow_a_pair(K, N)
        if N.connected == 0 then
          if math.abs(K.floor_h - N.floor_h) <= 16 then
            N.connected = 1
          end
        end
      end

      for kx = 1,KW do for ky = 1,KH do
        local K = c.chunks[kx][ky]

        if K.connected == 1 then
          for dir = 2,8,2 do
            local dx,dy = dir_to_delta(dir)

            if valid_chunk(kx+dx,ky+dy) then
              grow_a_pair(K, c.chunks[kx+dx][ky+dy])
            end
          end
        end
      end end
    end

    local function grow_connx()
      for loop=1,10 do
        grow_pass()
      end
    end

    local function find_stair_pos()
      local best_diff = 999999
      local coords = {}

      for kx = 1,KW do for ky = 1,KH do
        local K = c.chunks[kx][ky]

        if K.connected == 0 then
          for dir = 2,8,2 do
            local dx,dy = dir_to_delta(dir)

            if valid_chunk(kx+dx, ky+dy) and
               c.chunks[kx+dx][ky+dy].connected == 1
            then
              local N = c.chunks[kx+dx][ky+dy]
              local diff = math.abs(K.floor_h - N.floor_h)

              if diff < best_diff then
                -- clear out previous (worse) results
                coords = {}
                best_diff = diff
              end

              if diff == best_diff then
                local loc = { x=kx, y=ky, dir=dir }
                table.insert(coords, loc)
              end
            end
          end
        end
      end end

      if #coords == 0 then return nil end

      return rand_shuffle(coords)
    end


    --- connect_chunks ---

    init_connx()
    grow_connx()

    for loop=1,99 do
      local loc = find_stair_pos()
      if not loc then break end

      local K = c.chunks[loc.x][loc.y]

--[[  DEBUG STAIR LOCS
local dx,dy = dir_to_delta(loc.dir)
  con.debugf(
  "CELL (%d,%d)  STAIR %d,%d facing %d  HT %d -> %d\n",
  c.x, c.y, loc.x, loc.y, loc.dir,
  K.delta_floor, c.chunks[loc.x+dx][loc.y+dy].delta_floor
  )
--]]
      assert(not K.stair_dir)

      K.stair_dir = loc.dir
      K.connected = 1

      grow_connx()
    end 

    --> result: certain chunks have a "stair_dir" field
    -->         Direction to neighbour chunk.  Stair will
    -->         be built inside this chunk.

    -- FIXME: randomly flip a few stairs.
    --   Requires:
    --     no stair_dir in neighbour
    --     neighbour "has space" (not building door, etc)
    --     ???
    --   Especially good: center -> ledge with centered door
  end

  local function good_Q_spot(c) -- REMOVE (use block-based alloc)

    assert(not p.deathmatch)

    local function k_dist(kx,ky)
      local side = c.entry_dir or c.exit_dir or 2

      if side==4 then return kx-1  end
      if side==6 then return KW-kx end
      if side==2 then return ky-1  end
      if side==8 then return KH-ky end
    end

---##  local in_x, in_y = side_to_chunk(c.entry_dir or c.exit_dir)

    local best_x, best_y
    local best_score = -10

    for kx = 1,KW do
      for ky = 1,KH do
        if c.chunks[kx][ky] and
           not (c.chunks[kx][ky].void or c.chunks[kx][ky].cage or c.chunks[kx][ky].quest)
        then
          local score = k_dist(kx, ky)
          score = score + con.random() * 0.5
          if c.chunks[kx][ky].floor_h == c.floor_h then score = score + 1.7 end

          if score > best_score then
            best_score = score
            best_x, best_y = kx,ky
          end
        end
      end
    end

---##  if not best_x then error("NO FREE SPOT!") end

    return best_x, best_y
  end

  local function position_sp_stuff(c)

    if c == p.quests[1].first then
      local kx, ky = good_Q_spot(c)
      if not kx then error("NO FREE SPOT for Player!") end
      c.chunks[kx][ky].player=true
    end

    if c == c.quest.last then
      local kx, ky = good_Q_spot(c)
      if not kx then error("NO FREE SPOT for Quest Item!") end
      c.chunks[kx][ky].quest=true

      --[[ NOT NEEDED?
      if p.coop and (c.quest.kind == "weapon") then
        local total = rand_index_by_probs { 10, 50, 90, 50 }
        for i = 2,total do
          local kx, ky = good_Q_spot(c)
          if kx then c.chunks[kx][ky].quest=true end
        end
      end
      --]]
    end
  end

  local function position_dm_stuff(c)

    local spots = {}

    local function get_spot()
      if #spots == 0 then return nil end
      return table.remove(spots, 1)
    end

    local function reusable_spot()
      if #spots == 0 then return nil end
      local S = table.remove(spots,1)
      table.insert(spots, S)
      return S
    end
    
    --- position_dm_stuff ---

    for kx = 1,KW do for ky = 1,KH do
      local K = c.chunks[kx][ky]
      if K and (K.room or K.liquid or K.link) and not K.stair_dir then
        table.insert(spots, {x=kx, y=ky, K=K})
      end
    end end

    rand_shuffle(spots)

    -- guarantee at least 4 players (each corner)
    if (c.x==1) or (c.x==p.w) or (c.y==1) or (c.y==p.h) or rand_odds(66) then
      local spot = get_spot()
      if spot then spot.K.player = true end
    end

    -- guarantee at least one weapon (central cell)
    if (c.x==int((p.w+1)/2)) or (c.y==int((p.h+1)/2)) or rand_odds(70) then
      local spot = get_spot()
      if spot then spot.K.dm_weapon = choose_dm_thing(THEME.dm.weapons, true) end
    end

    -- secondary players and weapons
    if rand_odds(33) then
      local spot = get_spot()
      if spot then spot.K.player = true end
    end
    if rand_odds(15) then
      local spot = get_spot()
      if spot then spot.K.dm_weapon = choose_dm_thing(THEME.dm.weapons, true) end
    end

    -- from here on we REUSE the spots --

    if #spots == 0 then return end

    -- health, ammo and items
    if rand_odds(70) then
      local spot = reusable_spot()
      spot.K.dm_health = choose_dm_thing(THEME.dm.health, false)
    end

    if rand_odds(90) then
      local spot = reusable_spot()
      spot.K.dm_ammo = choose_dm_thing(THEME.dm.ammo, true)
    end
 
    if rand_odds(10) then
      local spot = reusable_spot()
      spot.K.dm_item = choose_dm_thing(THEME.dm.items, true)
    end

    -- secondary health and ammo
    if rand_odds(10) then
      local spot = reusable_spot()
      spot.K.dm_health = choose_dm_thing(THEME.dm.health, false)
    end
    if rand_odds(30) then
      local spot = reusable_spot()
      spot.K.dm_ammo = choose_dm_thing(THEME.dm.ammo, true)
    end
  end

  --==-- make_chunks --==--

  for zzz,link in ipairs(p.all_links) do
    link.where = random_where(link)
  end

  -- firstly, allocate chunks based on exit locations
  for loop=1,999 do
    local clashes = 0

    for zzz,cell in ipairs(p.all_cells) do
      if not put_chunks_in_cell(cell) then
        clashes = clashes + 1
      end
    end

    con.debugf("MAKING CHUNKS: %d clashes\n", clashes)

    if clashes == 0 then break end
  end

  -- secondly, determine main walk areas

  for zzz,cell in ipairs(p.all_cells) do

      add_closet_chunks(cell)
      add_essential_chunks(cell)

      flesh_out_cell(cell)

      --- setup_chunk_rmodels(cell)

      connect_chunks(cell)

      if p.deathmatch then
        position_dm_stuff(cell)
      else
        position_sp_stuff(cell)
      end
  end
end


----------------------------------------------------------------


function build_cell(p, c)
 
  local function valid_and_empty(cx, cy)
    return valid_cell(p, cx, cy) and not p.cells[cx][cy]
  end

  local function player_angle(kx, ky)

    if c.exit_dir then
      return dir_to_angle(c.exit_dir)
    end

    -- when in middle of room, find an exit to look at
    if (kx==2 and ky==2) then
      for i = 1,20 do
        local dir = rand_irange(1,4)*2
        if c.link[dir] then
          return dir_to_angle(dir)
        end
      end

      return rand_irange(1,4)*2
    end

    return delta_to_angle(2-kx, 2-ky)
  end

  local function decide_void_pic(p, c)
    if c.theme.pic_wd and rand_odds(60) then
      c.void_pic = { tex=c.theme.pic_wd, w=128, h=c.theme.pic_wd_h or 128 }
      c.void_cut = 1
      return

    elseif not c.theme.outdoor and rand_odds(25) then
      c.void_pic = random_light_kind(false)
      c.void_cut = rand_irange(3,4)
      return

    else
      local name,info = rand_table_pair(THEME.pics)
      c.void_pic = info
      c.void_cut = 1
    end
  end

  local function build_real_link(link, side, where, what, b_theme)

    -- DIR here points to center of current cell
    local dir = 10-side  -- FIXME: remove

    if (link.build ~= c) then return end

    local other = link_other(link, c)
    assert(other)

    local x, y
    local dx, dy = dir_to_delta(dir)
    local ax, ay = dir_to_across(dir)

    local long = link.long or 2

    local d_min = 1
    local d_max = BW

    local d_pos
    
    if link.where == "wide" then
      d_pos = d_min + 1
      long  = d_max - d_min - 1
    else
      d_pos = where_to_block(where, long)
      d_max = d_max - (long-1)

      if (d_pos < d_min) then d_pos = d_min end
      if (d_pos > d_max) then d_pos = d_max end
    end

        if side == 2 then x,y = d_pos, 1
    elseif side == 8 then x,y = d_pos, BH
    elseif side == 4 then x,y =  1, d_pos
    elseif side == 6 then x,y = BW, d_pos
    end

    if (link.kind == "arch" or link.kind == "falloff") then

      if what == "empty" then return end  -- no arch needed

      x,y = x-dx, y-dy
      local ex, ey = x + ax*(long-1), y + ay*(long-1)
      local tex = c.theme.wall

      -- sometimes leave it empty
      if what == "wire" then link.arch_rand = link.arch_rand * 4 end

      if link.kind == "arch" and link.where ~= "wide" and
        c.theme.outdoor == other.theme.outdoor and
        ((c.theme.outdoor and link.arch_rand < 50) or
         (not c.theme.outdoor and link.arch_rand < 10))
      then
        local sec = copy_block(c.rmodel)
        sec.l_tex = tex
        sec.u_tex = tex
        fill(p,c, x, y, ex, ey, sec)
        return
      end

      local arch = copy_block(c.rmodel)
      arch.c_h = math.min(c.ceil_h-32, other.ceil_h-32, c.floor_h+128)
      arch.f_tex = c.theme.arch_floor or c.rmodel.f_tex
      arch.c_tex = c.theme.arch_ceil  or arch.f_tex

      if (arch.c_h - arch.f_h) < 64 then
        arch.c_h = arch.f_h + 64
      end

      if c.hallway and other.hallway then
        arch.light = (c.light + other.light) / 2.0
      elseif c.theme.outdoor then
        arch.light = arch.light - 32
      else
        arch.light = arch.light - 16
      end

      local special_arch

      if link.where == "wide" and THEME.mats.ARCH and rand_odds(70) then
        special_arch = true

        arch.c_h = math.max(arch.c_h, c.ceil_h - 48)
        arch.c_tex = THEME.mats.ARCH.ceil

        tex = THEME.mats.ARCH.wall

        fill(p,c, x-ax*2, y-ay*2, ex+ax*2, ey+ay*2, { solid=tex })
      end

      arch.l_tex = tex
      arch.u_tex = tex

      fill(p,c, x-ax, y-ay, ex+ax, ey+ay, { solid=tex })
      fill(p,c, x, y, ex, ey, arch)

      if link.block_sound then
        -- FIXME block_sound(p, c, x,y, ex,ey, 1)
      end

      -- pillar in middle of special arch
      if link.where == "wide" then
        long = int((long-1) / 2)
        x, y  = x+long*ax,  y+long*ay
        ex,ey = ex-long*ax, ey-long*ay

        if x == ex and y == ey then
          fill(p,c, x, y, ex, ey, { solid=tex })
        end
      end

    elseif link.kind == "door" and link.is_exit and not link.quest then

      B_exit_door(p,c, c.theme, link, x-dx, y-dy, c.floor_h, dir)

    elseif link.kind == "door" and link.quest and link.quest.kind == "switch" and
       THEME.switches[link.quest.item].bars
    then
      local info = THEME.switches[link.quest.item]
      local sec = copy_block(c.rmodel)
      sec.f_h = c.floor_h
      sec.f_tex = b_theme.floor
      sec.c_tex = b_theme.ceil

      if not link.src.outdoor or not link.dest.outdoor then
        sec.c_h = sec.c_h - 32
        while sec.c_h > (sec.c_h+sec.f_h+128)/2 do
          sec.c_h = sec.c_h - 32
        end
        if b_theme.outdoor then sec.c_tex = b_theme.arch_ceil or sec.f_tex end
      end

      local bar = link.bar_size
      local tag = link.quest.tag + 1

      B_bars(p,c, x-dx,y-dy, math.min(dir,10-dir),long, bar,bar*2, info, sec,b_theme.wall, tag,true)

    elseif link.kind == "door" then

      local kind = link.wide_door

      if link.src.quest == link.dest.quest and (link.door_rand < 25) then
        kind = link.narrow_door
      end

      local info = THEME.doors[kind]
      assert(info)

      local door_kind = 1
      local tag = nil
      local key_tex = nil

      if dual_odds(p.deathmatch, 75, 15) then
        door_kind = 117 -- Blaze
      end

      if link.quest and link.quest.kind == "key" then
        local bit = THEME.key_bits[link.quest.item]
        assert(bit)
        door_kind = sel(p.coop, bit.kind_once, bit.kind_rep)
        key_tex = bit.wall -- can be nil
        if bit.thing then
          -- FIXME: heretic statues !!!
        end
        if bit.door then
          kind = bit.door
          info = THEME.doors[kind]
          assert(info)
        end
      end

      if link.quest and link.quest.kind == "switch" then
        door_kind = nil
        tag = link.quest.tag + 1
        key_tex = THEME.switches[link.quest.item].wall
        assert(key_tex)
      end

      B_door(p, c, link, b_theme, x-dx, y-dy, c.floor_h, dir,
             1 + int(info.w / 64), 1, info, door_kind, tag, key_tex)
    else
      error("build_link: bad kind: " .. tostring(link.kind))
    end
  end

  local function build_link(link, other, side, what, b_theme)
    if not link then return end

    link.narrow_door = random_door_kind(64)
    link.wide_door   = random_door_kind(128)
    link.block_sound = rand_odds(90)
    link.bar_size    = rand_index_by_probs { 20,90 }
    link.arch_rand   = con.random() * 100
    link.door_rand   = con.random() * 100

    if link.where == "double" then
      local awh = rand_irange(2,3)
      build_real_link(link, side, -awh, what, b_theme)
      build_real_link(link, side,  awh, what, b_theme)
    else
      build_real_link(link, side, link.where, what, b_theme)
    end
  end

  local function chunk_pair(cell, other, side,n)
    local cx,cy, ox,oy
    
        if side == 2 then cx,cy,ox,oy = n,1,n,KH
    elseif side == 8 then cx,cy,ox,oy = n,KH,n,1
    elseif side == 4 then cx,cy,ox,oy = 1,n,KW,n
    elseif side == 6 then cx,cy,ox,oy = KW,n,1,n
    end

    return cell.chunks[cx][cy], other.chunks[ox][oy]
  end

  local function border_floor_range(other, side)
    assert(other)

    local f_min, f_max = 65536, -65536

    for n = 1,KW do
      local K1, K2 = chunk_pair(c, other, side,n)
 
      if not (K1.void or K1.cage) then
        f_max = math.max(f_max, K1.floor_h)
        f_min = math.min(f_min, K1.floor_h)
      end
      if not (K2.void or K2.cage) then
        f_max = math.max(f_max, K2.floor_h)
        f_min = math.min(f_min, K2.floor_h)
      end
    end

    if f_min == 65536 then return nil, nil end

    return f_min, f_max
  end

  local function what_border_type(cell, link, other, side)

    if link then assert(other) end

    if link and (link.kind == "arch") and
       (cell.quest.parent or cell.quest) == (other.quest.parent or other.quest) and
       cell.theme == other.theme and
       dual_odds(cell.theme.outdoor, 50, 33)
    then
       return "empty"
    end

    if not other then
      if cell.theme.outdoor then return "sky" end
      return "solid"
    end

    if cell.sc_solid or other.sc_solid then
      return "solid"
    end

    -- fencing anyone?
    if (cell.theme.outdoor == other.theme.outdoor) and
       (not cell.is_exit and not other.is_exit) and
       (not cell.is_depot and not other.is_depot) and
       math.min(cell.ceil_h, other.ceil_h) - math.max(cell.f_max, other.f_max) > 64
    then
      if cell.scenic or other.scenic then
        if rand_odds(30) then return "wire" end
        return "fence"
      end

      local i_W = sel(link, 3, 20)
      local i_F = sel(cell.theme == other.theme, 5, 0)

      if dual_odds(cell.theme.outdoor, 25, i_W) then return "wire" end
      if dual_odds(cell.theme.outdoor, 50, i_F) then return "fence" end
    end
 
    return "solid"
  end

  local function border_theme(c, other)
    if not other then return c.theme end

    local t1 = c.theme
    local t2 = other.theme

    if c.hallway ~= other.hallway then
      if c.hallway then
        t1 = c.quest.theme
      else
        t2 = other.quest.theme
      end
    end

    -- FIXME: verify this produces better results!!
    if t1.outdoor ~= t2.outdoor then
      if t1.outdoor then t1,t2 = t2,t1 end
      return t1
    end

    if t1.mat_pri < t2.mat_pri then t1,t2 = t2,t1 end

    local diff = t1.mat_pri - t2.mat_pri
    assert(diff >= 0)

    if diff <= 3 then
      local PROBS = { 100, 10, 3, 1 }
      if rand_odds(PROBS[1+diff]) then t1,t2 = t2,t1 end
    end

    return t1
  end

  local function corner_tex(c, dx, dy)
    -- FIXME: use *border* themes, not cell themes

    local themes = { }

    local function try_add_one(x, y)
      if not valid_cell(p, x, y) then return end
      local cell = p.cells[x][y]
      if not cell then return end
      assert(cell.theme)
      table.insert(themes, cell.theme)
    end

    try_add_one(c.x+dx, c.y)
    try_add_one(c.x,    c.y+dy)
    try_add_one(c.x+dx, c.y+dy)

    local best = c.theme

    for zzz,T in ipairs(themes) do
      if not T.outdoor and best.outdoor then
        best = T
      elseif T.outdoor == best.outdoor then
        if T.mat_pri > best.mat_pri then
          best = T
        elseif T.mat_pri == best.mat_pri and rand_odds(50) then
          best = T
        end
      end
    end
    --[[ ORIG
    for zzz,T in ipairs(themes) do
      if T.mat_pri > best.mat_pri then
        best = T
      elseif T.mat_pri == best.mat_pri then
        if not T.outdoor and best.outdoor then
          best = T
        elseif not (T.outdoor or best.outdoor) and rand_odds(50) then
          best = T
        end
      end
    end --]]

    return best.void
  end

  local function build_sky_border(side, x1,y1, x2,y2)

    local WALL =
    {
      f_h = c.f_max + 48, c_h = c.ceil_h,
      f_tex = c.theme.floor, c_tex = c.theme.ceil,
      light = c.light,
      l_tex = c.theme.wall,
      u_tex = c.theme.wall,
    }

    local BEHIND =
    {
      f_h = c.f_min - 512, c_h = c.f_min - 508,
      f_tex = c.theme.floor, c_tex = c.theme.ceil,
      light = c.light,
      l_tex = c.theme.wall,
      u_tex = c.theme.wall,
    }

---###    local dx, dy = dir_to_delta(side)

    local ax1, ay1, ax2, ay2 = side_to_corner(10-side, FW, FH)

---###    local bx1, by1, bx2, by2 = side_to_corner(side, FW, FH)
---###    local mx1, my1, mx2, my2
---###    mx1, my1 = ax1 + dx, ay1 + dy
---###    mx2, my2 = ax2 + dx*2, ay2 + dy*2

    for x = x1,x2 do for y = y1,y2 do

      if not p.blocks[c.blk_x+x][c.blk_y+y] then

        local fx = (x - 1) * FW
        local fy = (y - 1) * FH

        frag_fill(p,c, fx+  1, fy+  1, fx+ FW, fy+ FH, BEHIND)
        frag_fill(p,c, fx+ax1, fy+ay1, fx+ax2, fy+ay2, WALL)
      end

    end end
  end

  local function build_sky_corner(x, y, wx, wy)

    local WALL =
    {
      f_h = c.f_max + 48, c_h = c.ceil_h,
      f_tex = c.theme.floor, c_tex = c.theme.ceil,
      light = c.light,
      l_tex = c.theme.wall,
      u_tex = c.theme.wall,
    }

    local BEHIND =
    {
      f_h = c.f_min - 512, c_h = c.f_min - 508,
      f_tex = c.theme.floor, c_tex = c.theme.ceil,
      light = c.light,
      l_tex = c.theme.wall,
      u_tex = c.theme.wall,
    }

    if not p.blocks[c.blk_x+x][c.blk_y+y] then

      local fx = (x - 1) * FW
      local fy = (y - 1) * FH

      frag_fill(p,c, fx+ 1, fy+ 1, fx+FW, fy+FH, BEHIND)
      frag_fill(p,c, fx+wx, fy+wy, fx+wx, fy+wy, WALL)
    end
  end

  local function build_empty_border(x1,y1, x2,y2, other, side, what, b_theme)

    local EMPTY = 
    {
      f_h = c.floor_h,
      c_h = c.ceil_h,
      f_tex = b_theme.floor,
      c_tex = b_theme.ceil,
      light = c.light
    }

    local overrides
    if what == "wire" then
      local f_min, f_max = border_floor_range(other, side)
      EMPTY.f_h = f_max

      local rsd = side
      if b_theme ~= c.theme then rsd = 10 - side end

--print(string.format(
--"Cell %d,%d Side %d Themes: %s/%s/%s R %d",
--c.x, c.y, side, c.theme.floor, b_theme.floor, other.theme.floor, rsd))

      -- FIXME: choose fence rail
      overrides = { [rsd] = { rail = THEME.rails["r_1"].tex }}
    end

    for n = 1,KW do
        -- FIXME: ICK!!! FIXME
        local sx = x1 + (x2-x1+1) * (n-1) / KW
        local sy = y1 + (y2-y1+1) * (n-1) / KH
        local ex = x1 + (x2-x1+1) * (n  ) / KW
        local ey = y1 + (y2-y1+1) * (n  ) / KH
        if x1 == x2 then sx,ex = x1,x1 end
        if y1 == y2 then sy,ey = y1,y1 end
        ex = ex + (sx-ex)/KW
        ey = ey + (sy-ey)/KH

      local K1, K2 = chunk_pair(c, other, side,n)

      if (K1.void or K1.cage) and (K2.void or K2.cage) then
        gap_fill(p,c, sx,sy, ex,ey, { solid=b_theme.void})
      else
        local sec

        if what == "empty" then
          sec = copy_block(EMPTY)

          if K1.liquid or K2.liquid then
            sec.f_h = math.max(K1.floor_h or -65536, K2.floor_h or -65536)
            if K1.liquid == K2.liquid and K1.floor_h == K2.floor_h then
              sec.f_h = sec.f_h + 16
            end
          else
            sec.f_h = math.min(K1.floor_h or  65536, K2.floor_h or  65536)
          end

        else -- wire fence (floor already set)
          sec = EMPTY
        end

        sec.l_tex = b_theme.wall
        sec.u_tex = b_theme.wall

        gap_fill(p,c, sx,sy, ex,ey, sec, overrides)
      end
    end
  end

  local function build_window(link, other, side, what, b_theme)

    if what == "empty" then return end

    if c.sc_solid and other.sc_solid then return end

    -- don't build 'castley' walls indoors
    if what == "fence" and not c.theme.outdoor then return end
    if what == "wire" then return end

    -- cohabitate nicely with doors
    local min_x, max_x = 1, BW

    if link then
      if link.where == "double" then return end
      if link.where == "wide"   then return end

      local l_long = link.long or 2
      local l_pos = where_to_block(link.where, l_long)
      if l_pos > (BW+1)/2 then
        max_x = l_pos - 2
      else
        min_x = l_pos + l_long + 1
      end
    end

    local dx, dy = dir_to_delta(side)
    local ax, ay = dir_to_across(side)

    local x, y = side_to_corner(side, BW, BH)
    x,y = x+dx, y+dy

    local sec = 
    {
      f_h = math.max(c.f_max, other.f_max) + 32,
      c_h = math.min(c.ceil_h, other.ceil_h) - 32,
      f_tex = b_theme.floor,
      c_tex = b_theme.ceil,
      light = c.rmodel.light,

      l_tex = b_theme.wall,
      u_tex = b_theme.wall,
    }

    if other.scenic then sec.impassible = true end

    if what == "fence" then
      sec.c_h = c.ceil_h
    else
      sec.light = sec.light - 16
      sec.c_tex = b_theme.arch_ceil or sec.f_tex

      if (sec.c_h - sec.f_h) > 64 and rand_odds(30) then
        sec.c_h = sec.f_h + 64
      end
    end

    local long  = rand_index_by_probs { 30, 90, 10, 3 }
    local step  = long + rand_index_by_probs { 90, 30, 4 }
    local first = -1 + rand_index_by_probs { 90, 90, 30, 5, 2 }

    local bar, bar_step
    local bar_chance
    if what == "fence" then
      bar_chance = 0.1
    else
      bar_chance = 10 + math.min(long,4) * 15
    end

    if rand_odds(bar_chance) then
      if long == 1 then bar = 1
      else bar = rand_index_by_probs { 90, 30 }
      end
      if bar > 1 then bar_step = 2 * bar
      else bar_step = 2 * rand_index_by_probs { 40, 80 }
      end
    end

    -- !!! FIXME: test crud
    if not bar and what ~= "fence" then
      -- FIXME: choose window rail
      sec[side] = { rail = THEME.rails["r_2"].tex }
    end

    for d_pos = first, BW-long, step do
      local wx, wy = x + ax*d_pos, y + ay*d_pos

      if (d_pos+1) >= min_x and (d_pos+long) <= max_x then
        if bar then
          B_bars(p,c, wx,wy, math.min(side,10-side),long, bar,bar_step, THEME.mats.METAL, sec,b_theme.wall)
        else
          gap_fill(p,c, wx,wy, wx+ax*(long-1),wy+ay*(long-1), sec)
        end
      end
    end
  end

  local function build_border(side, pass)

    local link = c.link[side]
    local other = neighbour_by_side(p, c, side)

    -- should *we* build it, or the other side?
    if link then
      if link.build ~= c then return end

    elseif other then
---###      local dx, dy = dir_to_delta(side)
---###      local other = p.cells[c.x+dx] and p.cells[c.x+dx][c.y+dy]

      if c.theme.outdoor ~= other.theme.outdoor then
        if c.theme.outdoor then return end
      elseif c.scenic ~= other.scenic then
        if c.scenic then return end
      else
        if side > 5 then return end
      end
    end

    local what = what_border_type(c, link, other, side)

    if (pass == 1 and what ~= "sky") or
       (pass == 2 and what == "sky") then return end

    local b_theme = border_theme(c, other)

    build_link(link, other, side, what, b_theme)

    if c.window[side] then
      build_window(link, other, side, what, b_theme)
    end

    local x1, y1, x2, y2 = side_to_corner(side, BW, BH)
    local dx, dy = dir_to_delta(side)

    x1, y1 = x1 + dx, y1 + dy
    x2, y2 = x2 + dx, y2 + dy

    local corn_x1 = x1 - math.abs(dy)
    local corn_y1 = y1 - math.abs(dx)
    local corn_x2 = x2 + math.abs(dy)
    local corn_y2 = y2 + math.abs(dx)

    if what == "empty" or what == "wire" then

      build_empty_border(x1,y1, x2,y2, other, side, what, b_theme)

--print("EMPTY", c.x, c.y, side)
--print("  other", other.x, other.y)

    elseif what == "fence" then
--print("FENCE", c.x, c.y, side, c.floor_h, c.f_max)
--print("  other", other.x, other.y, other.floor_h, other.f_max)
      local FENCE =
      {
        f_h = math.max(c.f_max, other.f_max) + 64,
        c_h = c.ceil_h,
        f_tex = b_theme.floor,
        c_tex = b_theme.ceil,
        light = c.light
      }
      if rand_odds(95) then FENCE.block_sound = 2 end
      if other.scenic then FENCE.impassible = true end

      FENCE.l_tex = b_theme.void
      FENCE.u_tex = b_theme.void

      gap_fill(p,c, x1,y1, x2,y2, FENCE)

    elseif what == "sky" then
      build_sky_border(side, x1,y1, x2,y2)

      -- handle the corner (check adjacent side)
      for cr = 1,2 do
        local nb_side = 2
        if side == 2 or side == 8 then nb_side = 4 end
        if cr == 2 then nb_side = 10 - nb_side end

        local NB = neighbour_by_side(p, c, nb_side)

        local cx, cy = corn_x1, corn_y1
        if cr == 2 then cx, cy = corn_x2, corn_y2 end

        if NB then
          local NB_link = NB.link[side]
          local NB_other = neighbour_by_side(p, NB, side)

          if what_border_type(NB, NB_link, NB_other, side) == "sky" then
            build_sky_border(side, cx, cy, cx, cy)
          end
        else
          local wx, wy

          if cx < BW/2 then wx = FW else wx = 1 end
          if cy < BH/2 then wy = FH else wy = 1 end

          build_sky_corner(cx, cy, wx, wy)
        end
      end

    else -- solid
      gap_fill(p,c, x1,y1, x2,y2, { solid=b_theme.wall })
    end

    -- lucky last: corners

    local corn_dx1 = (side == 6) and  1 or -1
    local corn_dy1 = (side == 8) and  1 or -1
    local corn_dx2 = (side == 4) and -1 or  1
    local corn_dy2 = (side == 2) and -1 or  1

    local corn_tex1 = corner_tex(c, corn_dx1, corn_dy1)
    local corn_tex2 = corner_tex(c, corn_dx2, corn_dy2)

    gap_fill(p,c, corn_x1,corn_y1, corn_x1,corn_y1, { solid=corn_tex1 })
    gap_fill(p,c, corn_x2,corn_y2, corn_x2,corn_y2, { solid=corn_tex2 })
  end

  local function build_chunk(kx, ky)

    local function link_is_door(c, side)
      return c.link[side] and c.link[side].kind == "door"
    end

    local function add_overhang_pillars(c, K, kx, ky, sec, l_tex, u_tex)
      local basex = (kx - 1) * JW + 1
      local basey = (ky - 1) * JH + 1

      sec = copy_block(sec)
      sec.l_tex = l_tex
      sec.u_tex = u_tex
      
      for side = 1,9,2 do
        if side ~= 5 then
          local jx, jy = dir_to_corner(side, JW, JH)
          local fx, fy = dir_to_corner(side, FW, FH)

          local bx, by = (basex + jx-1), (basey + jy-1)

          local pillar = true

          if (bx ==  1 and link_is_door(c, 4)) or
             (bx == BW and link_is_door(c, 6)) or
             (by ==  1 and link_is_door(c, 2)) or
             (by == BH and link_is_door(c, 8))
          then
            pillar = false
          end

          -- FIXME: interact better with stairs/lift

          jx,jy = (bx - 1)*FW, (by - 1)*FH

          frag_fill(p,c, jx+1, jy+1, jx+FW, jy+FH, sec)

          if pillar then
            frag_fill(p,c, jx+fx, jy+fy, jx+fx, jy+fy, { solid=K.sup_tex})
          end
        end
      end
    end

    local function chunk_void_fill(c, K, kx, ky, tex)
      local x1 = chunk_to_block(kx)
      local y1 = chunk_to_block(ky)
      local x2 = chunk_to_block(kx + 1) - 1
      local y2 = chunk_to_block(ky + 1) - 1

      gap_fill(p,c, x1, y1, x2, y2, { solid=tex })
    end

    local function chunk_fill(c, K, kx, ky, sec, l_tex, u_tex)
      local x1 = chunk_to_block(kx)
      local y1 = chunk_to_block(ky)
      local x2 = chunk_to_block(kx + 1) - 1
      local y2 = chunk_to_block(ky + 1) - 1

      assert(sec)

      if K.overhang then
        add_overhang_pillars(c, K, kx, ky, sec, l_tex, u_tex)
      end

      if K.sky_light_sec then
        local x1,y1,x2,y2 = x1,y1,x2,y2
        if kx==1  then x1=x1+1 end
        if kx==KW then x2=x2-1 end
        if ky==1  then y1=y1+1 end
        if ky==KH then y2=y2-1 end

        ---### local xN = c.sky_light.xN
        ---### local yN = c.sky_light.yN

        local func = SKY_LIGHT_FUNCS[c.sky_light.pattern]
        assert(func)

        local BB = copy_block(K.sky_light_sec)
        BB.l_tex = l_tex
        BB.u_tex = K.sky_light_utex or u_tex

        for x = x1,x2 do for y = y1,y2 do
          ---### local xT = (x % xN) == (xN - 1)
          ---### local yT = (y % yN) == (yN - 1)
          if func(kx,ky, x,y) then
            gap_fill(p,c, x,y, x,y, BB)
          end
        end end
      end

      -- get this *after* doing sky lights
      local blocked = p.blocks[c.blk_x+x1+1][c.blk_y+y1+1]

      if K.crate and not blocked then
        local theme = c.crate_theme
        if not c.quest.image and not c.quest.mini and
           (c.quest.level == 1 or rand_odds(16))
        then
          theme = THEME.images[2]
          c.quest.image = "crate"
        end
        B_crate(p,c, theme, sec, kx,ky, x1+1,y1+1)
        blocked = true
      end

      if K.pillar and not blocked then

        -- TEST CRUD
        if rand_odds(22) and THEME.mats.CAGE and not p.deathmatch
          and K.ceil_h >= K.floor_h + 128
        then
          B_pillar_cage(p,c, THEME.mats.CAGE, kx,ky, x1+1,y1+1)
        else
          B_pillar(p,c, c.theme, kx,ky, x1+1,y1+1)
        end
        blocked = true
      end

      sec.l_tex = l_tex
      sec.u_tex = u_tex

      gap_fill(p,c, x1, y1, x2, y2, sec)

      if not blocked and c.theme.scenery and not K.stair_dir and
         (dual_odds(c.theme.outdoor, 37, 22)
          or (c.scenic and rand_odds(51)))
      then
        p.blocks[c.blk_x+x1+1][c.blk_y+y1+1].has_scenery = true
        local th = add_thing(p, c, x1+1, y1+1, c.theme.scenery, true)
        if c.scenic then
          th.dx = rand_irange(-64,64)
          th.dy = rand_irange(-64,64)
        end
      end
    end

    local function wall_switch_dir(kx, ky, entry_dir)
      if not entry_dir then
        entry_dir = rand_irange(1,4)*2
      end
      
      if kx==2 and ky==2 then
        return entry_dir
      end

      if kx==2 then return sel(ky < 2, 8, 2) end
      if ky==2 then return sel(kx < 2, 6, 4) end

      return entry_dir
    end

    local function chunk_dm_offset()
      while true do
        local dx = rand_irange(1,3) - 2
        local dy = rand_irange(1,3) - 2
        if not (dx==0 and dy==0) then return dx,dy end
      end
    end

    local function add_dm_pickup(c, bx,by, name)
      -- FIXME: (a) check if middle blocked, (b) good patterns

      local cluster = 1
      if THEME.dm.cluster then cluster = THEME.dm.cluster[name] or 1 end
      assert(cluster >= 1 and cluster <= 8)

      local offsets = { 1,2,3,4, 6,7,8,9 }
      rand_shuffle(offsets)

      for i = 1,cluster do
        local dx, dy = dir_to_delta(offsets[i])
        add_thing(p, c, bx+dx, by+dy, name, false)
      end
    end

    -- build_chunk --

    local K = c.chunks[kx][ky]
    assert(K)

    if c.sc_solid then
      chunk_void_fill(c, K, kx, ky, c.theme.void)
      return
    end

    if K.void then
      if K.closet then
        con.debugf("BUILDING CLOSET @ (%d,%d)\n", c.x, c.y)

        table.insert(K.place.spots,
          B_monster_closet(p,c, kx,ky, c.rmodel.f_h + 0,
            c.quest.closet.door_tag))

      elseif K.dm_exit then
        B_deathmatch_exit(p,c, kx,ky,K.dir)

      elseif THEME.pics and not c.small_exit
          and rand_odds(sel(c.theme.outdoor, 10, sel(c.hallway,20, 50)))
      then
        if not c.void_pic then decide_void_pic(p, c) end
        local pic,cut = c.void_pic,c.void_cut

        if not c.quest.image and c.quest.mini and rand_odds(35) then
          pic = THEME.images[1]
          cut = 1
          c.quest.image = "pic"
        end

        B_void_pic(p,c, kx,ky, pic,cut)

      else
        chunk_void_fill(c, K, kx, ky, c.theme.void)
      end
      return
    end

    if K.cage then
      B_big_cage(p,c, THEME.mats.CAGE, kx,ky)
      return
    end

    if K.stair_dir then
      
      local dx, dy = dir_to_delta(K.stair_dir)
      local NB = c.chunks[kx+dx][ky+dy]

      local diff = math.abs(K.floor_h - NB.floor_h)

      local long = 2
      local deep = 1

      -- prefer no lifts in deathmatch
      if p.deathmatch and diff > 64 and rand_odds(88) then deep = 2 end

      -- FIXME: replace with proper "can walk" test !!!
      if (K.stair_dir == 6 and kx == 1 and c.border[4]) or
         (K.stair_dir == 4 and kx == 3 and c.border[6]) or
         (K.stair_dir == 8 and ky == 1 and c.border[2]) or
         (K.stair_dir == 2 and ky == 3 and c.border[8]) then
        deep = 1
      end

      local bx = (kx-1) * JW
      local by = (ky-1) * JH 

      if K.stair_dir == 8 then
        by = by + JH + 1 - deep
      elseif K.stair_dir == 2 then
        by = by + deep
      elseif ky == 1 then
        by = by + JH - 1
      elseif ky == 3 then
        by = by + 1
      else
        by = by + 1; if JH >= 4 then by = by + 1 end
      end

      if K.stair_dir == 6 then
        bx = bx + JW + 1 - deep
      elseif K.stair_dir == 4 then
        bx = bx + deep
      elseif kx == 1 then
        bx = bx + JW - 1
      elseif kx == 3 then
        bx = bx + 1
      else
        bx = bx + 1; if JW >= 4 then bx = bx + 1 end
      end

      local step = (NB.floor_h - K.floor_h) / deep / 4

      if math.abs(step) <= 16 then
        B_stair(p, c, bx, by, K.floor_h, K.stair_dir,
                long, deep, (NB.floor_h - K.floor_h) / (deep * 4),
                { } )
      else
        B_lift(p, c, bx, by,
               math.max(K.floor_h, NB.floor_h), K.stair_dir,
               long, deep, { } )
      end
    end  -- if K.stair_dir

    local bx = chunk_to_block(kx) + 1
    local by = chunk_to_block(ky) + 1
    
    if K.player then
      local angle = player_angle(kx, ky)
      local offsets = sel(rand_odds(50), {1,3,7,9}, {2,4,6,8})
      if p.coop then
        for i = 1,4 do
          local dx,dy = dir_to_delta(offsets[i])
          if settings.game == "plutonia" then
            B_double_pedestal(p,c, bx+dx,by+dy, K.floor_h, THEME.special_ped)
          else
            B_pedestal(p, c, bx+dx, by+dy, K.floor_h, THEME.pedestals.PLAYER)
          end
          add_thing(p, c, bx+dx, by+dy, "player" .. tostring(i), true, angle)
          c.player_pos = {x=bx+dx, y=by+dy}
        end
      else
        if settings.game == "plutonia" then
          B_double_pedestal(p,c, bx,by, K.floor_h, THEME.special_ped)
        else
          B_pedestal(p, c, bx, by, K.floor_h, THEME.pedestals.PLAYER)
        end
        add_thing(p, c, bx, by, sel(p.deathmatch, "dm_player", "player1"), true, angle)
        c.player_pos = {x=bx, y=by}
      end

    elseif K.dm_weapon then
      B_pedestal(p, c, bx, by, K.floor_h, THEME.pedestals.WEAPON)
      add_thing(p, c, bx, by, K.dm_weapon, true)

    elseif K.quest then

      if c.quest.kind == "key" or c.quest.kind == "weapon" or c.quest.kind == "item" then
        B_pedestal(p, c, bx, by, K.floor_h, THEME.pedestals.QUEST)

        -- weapon and keys are non-blocking, but we don't want
        -- a monster sitting on top of our quest item (especially
        -- when it has a pedestal).
        add_thing(p, c, bx, by, c.quest.item, true)

      elseif c.quest.kind == "switch" then
        local info = THEME.switches[c.quest.item]
        assert(info.switch)
        local kind = 103; if info.bars then kind = 23 end
        if rand_odds(40) then
          local side = wall_switch_dir(kx, ky, c.entry_dir)
          B_wall_switch(p,c, bx,by, K.floor_h, side, 2, info, kind, c.quest.tag + 1)
        else
          B_pillar_switch(p,c, K,bx,by, info,kind, c.quest.tag + 1)
        end

      elseif c.quest.kind == "exit" then
        assert(c.theme.switch)

        local side = wall_switch_dir(kx, ky, c.entry_dir)

        if settings.game == "plutonia" then
          B_double_pedestal(p,c, bx,by, K.floor_h, THEME.special_ped,
            { walk_kind = 52 }) -- FIXME "exit_W1"

        elseif c.small_exit and not c.smex_cage and rand_odds(80) then
          B_wall_switch(p,c, bx,by, K.floor_h, side, 3, c.theme.switch, 11)

          -- make the area behind the switch solid
          local x1 = chunk_to_block(kx)
          local y1 = chunk_to_block(ky)
          local x2 = chunk_to_block(kx + 1) - 1
          local y2 = chunk_to_block(ky + 1) - 1
              if side == 4 then x1 = x1+2
          elseif side == 6 then x2 = x2-2
          elseif side == 2 then y1 = y1+2
          elseif side == 8 then y2 = y2-2
          else   error("Bad side for small_exit switch: " .. side)
          end

          gap_fill(p,c, x1,y1, x2,y2, { solid=c.theme.wall })
          
        elseif c.theme.hole_tex and rand_odds(75) then
          B_exit_hole(p,c, kx,ky, c.rmodel)
          return
        else
          B_floor_switch(p,c, bx,by, K.floor_h, side, c.theme.switch, 11)
        end
      end
    end -- if K.player | K.quest etc...

    -- fill in the rest

    local sec = c.rmodel
    local u_tex = c.theme.wall;

    if K.link and K.link.build ~= c then

      local other = link_other(K.link, c)

      sec = copy_block(c.rmodel)

      sec.f_h = K.floor_h
      sec.c_h = K.ceil_h
    end

    local surprise = c.quest.closet or c.quest.depot

    if K.quest and surprise and c == surprise.trigger_cell then
      sec = copy_block(sec)
      sec.mark = allocate_mark(p)
      sec.walk_kind = 2
      sec.walk_tag  = surprise.door_tag
    end

    if K.liquid then
      sec = copy_block(sec) -- FIXME??
      sec.f_tex = c.liquid.floor
      sec.kind = c.liquid.sec_kind
      sec.f_h = K.floor_h
    end

    if K.player then
      sec = copy_block(sec) -- FIXME??
      sec.near_player = true;
      sec.kind = 9  -- FIXME: "secret"

      if settings.mode == "coop" and settings.game == "plutonia" then
        sec.light = THEME.special_ped.coop_light
      end
    end

    -- TEST CRUD : overhangs
    if rand_odds(9) and c.theme.outdoor
      and (sec.c_h - sec.f_h <= 256)
      and not (c.quest.kind == "exit" and c.along == #c.quest.path-1)
      and not K.stair_dir
    then
      sec = copy_block(sec) -- FIXME??
      K.overhang = true

      if not c.overhang then
        local name
        name, c.overhang = rand_table_pair(THEME.hangs)
      end
      local overhang = c.overhang

      sec.c_tex = overhang.ceil
      u_tex = overhang.upper
      K.sup_tex = overhang.thin

      sec.c_h = sec.c_h - (overhang.h or 24)
      sec.light = sec.light - 48
    end

    -- TEST CRUD : crates
    if sec and not c.scenic and not K.stair_dir
      and THEME.crates
      and dual_odds(c.theme.outdoor, 20, 33)
      and (not c.hallway or rand_odds(25))
      and (not c.exit or rand_odds(50))
    then
      K.crate = true
      if not c.crate_theme then
        c.crate_theme = get_rand_crate()
      end
    end

    -- TEST CRUD : pillars
    if not K.crate and sec and not c.scenic and not K.stair_dir
      and dual_odds(c.theme.outdoor, 12, 25)
      and (not c.hallway or rand_odds(15))
      and (not c.exit or rand_odds(22))
    then
      K.pillar = true
    end

    --FIXME: very cruddy check...
    if c.is_exit and chunk_touches_side(kx, ky, c.entry_dir) then
      K.crate  = nil
      K.pillar = nil
    end

    -- TEST CRUD : sky lights
    if c.sky_light then
      if kx==2 and ky==2 and c.sky_light.pattern == "pillar" then
        K.pillar = true
      end

      K.sky_light_sec = copy_block(sec)
      K.sky_light_sec.c_h   = sel(c.sky_light.is_sky, c.sky_h, sec.c_h + c.sky_light.h)
      K.sky_light_sec.c_tex = sel(c.sky_light.is_sky, THEME.SKY_TEX, c.sky_light.light_info.flat)
      K.sky_light_sec.light = 176
      K.sky_light_utex = c.sky_light.light_info.side

      -- make sure sky light doesn't come down too low
      K.sky_light_sec.c_h = math.max(K.sky_light_sec.c_h,
        sel(c.sky_light.is_sky, c.c_max+16, c.c_min))
    end
 
---###    K.final_sec = copy_block(sec)

    chunk_fill(c, K, kx, ky, sec, c.theme.wall, u_tex)

    if K.dm_health then
      add_dm_pickup(c, bx,by, K.dm_health)
    end
    
    if K.dm_ammo then
      add_dm_pickup(c, bx,by, K.dm_ammo)
    end
    
    if K.dm_item then
      add_dm_pickup(c, bx,by, K.dm_item)
    end
  end


  ---=== build_cell ===---

  assert(not c.blk_x)

  c.mark = allocate_mark(p)

  -- these refer to the bottom/left corner block
  -- (not actually in the cell, but in the border)
  c.blk_x = BORDER_BLK + (c.x-1) * (BW+1)
  c.blk_y = BORDER_BLK + (c.y-1) * (BH+1)

  if not c.theme.outdoor and not c.is_exit and not c.hallway
     and rand_odds(70)
  then
    c.sky_light =
    {
      h  = 8 * rand_irange(2,4),
      pattern = random_sky_light(),
      is_sky = rand_odds(33),
      light_info = random_light_kind(true)
    }
    if not c.sky_light.is_sky and rand_odds(80) then
      c.sky_light.h = - c.sky_light.h
    end
  end

  -- on first pass, only build sky borders
  for pass = 1,2 do
    for side = 2,8,2 do
      build_border(side, pass)
    end
  end

  for kx = 1,KW do
    for ky = 1,KH do
      build_chunk(kx, ky)
    end
  end
end


local function build_depot(p, c)

  c.blk_x = BORDER_BLK + (c.x-1) * (BW+1)
  c.blk_y = BORDER_BLK + (c.y-1) * (BH+1)

  local depot = c.quest.depot
  assert(depot)

  local places = depot.places
  assert(#places >= 2)
  assert(#places <= 4)

  local start = p.quests[1].first
  assert(start.player_pos)

  local player_B = p.blocks[start.blk_x + start.player_pos.x][start.blk_y + start.player_pos.y]

  -- check for double pedestals (Plutonia)
  if player_B.fragments then
    player_B = player_B.fragments[1][1]
  end
  assert(player_B)
  assert(player_B.f_h)

  local sec = { f_h = player_B.f_h, c_h = player_B.f_h + 128,
                f_tex = c.theme.floor, c_tex = c.theme.ceil,
                l_tex = c.theme.void,  u_tex = c.theme.void,
                light = 0
              }

  mon_sec = copy_block(sec)
  mon_sec[8] = { block_mon=true }

  door_sec = copy_block(sec)
  door_sec.c_h = door_sec.f_h
  door_sec.tag = depot.door_tag

  tele_sec = copy_block(sec)
  tele_sec.walk_kind = 126

  local m1,m2 = 1,4
  local t1,t2 = 6,BW

  -- mirror the room horizontally
  if c.x > start.x then
    m1,m2, t1,t2 = t1,t2, m1,m2
  end

  for y = 1,#places do
    fill(p, c, 1,y*2-1, BW,y*2, mon_sec, { mark=y })
    places[y].spots = rectangle_to_spots(c, m1,y*2-1, m1+0,y*2) -- FIXME

    for x = t1,t2 do
      local t = 1 + ((x + y) % #places)
      fill(p, c, x,y*2-1, x,y*2, tele_sec, { mark=x*10+y, walk_tag=places[t].tag})
    end
  end

  -- door separating monsters from teleporter lines
  fill(p, c, 5,1, 5,2*#places, door_sec)

  -- bottom corner block is same sector as player start,
  -- to allow sound to wake up these monsters.
  fill(p, c, m1,1, m1,1, copy_block(player_B), { same_sec=player_B })

  -- put a border around the room
  gap_fill(p, c, 0, 0, BW+1, BH+1, { solid=c.theme.wall })
end


function build_level(p)

  for zzz,cell in ipairs(p.all_cells) do
    setup_rmodel(p, cell)
  end

  make_chunks(p)
--  show_chunks(p)

  for zzz,cell in ipairs(p.all_cells) do
    build_cell(p, cell)
  end

  for zzz,cell in ipairs(p.all_depots) do
    build_depot(p, cell)
  end

  con.progress(25); if con.abort() then return end
 
  if not p.deathmatch then
    battle_through_level(p)
  end

  con.progress(40); if con.abort() then return end
end

