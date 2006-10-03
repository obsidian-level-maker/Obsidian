----------------------------------------------------------------
-- BUILDER
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006 Andrew Apted
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
require 'planner'
require 'monster'


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

  local LINK_WHERES =  -- TODO: theme based?
  {
     15, 40, 15, 90, 15, 40, 15
  }

  if (link.kind == "door" and rand_odds(4)) or
     (link.kind ~= "door" and rand_odds(15)) then
    link.where = "double";
    return
  end

  if (link.kind == "arch" and rand_odds(15)) or
     (link.kind == "falloff" and rand_odds(80)) then
    link.where = "wide";
    return
  end

  if link.kind == "falloff" then link.where = 0; return end

  link.where = rand_index_by_probs(LINK_WHERES) - 4
end


function show_blocks(cell) -- FIXME
  assert(cell.blocks)
  for y = BH,1,-1 do
    for x = 1,BW do
      local B = cell.blocks[x][y]
      io.stderr:write(B and (B.fragments and "%" or
                      (B.sector and "/" or "#")) or ".")
    end
    io.stderr:write("\n")
  end
end

function show_fragments(block)
  assert(block.fragments)
  for y = FH,1,-1 do
    for x = 1,FW do
      local fg = block.fragments[x][y]
      io.stderr:write(fg and (fg.sector and "/" or "#") or ".")
    end
    io.stderr:write("\n")
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

      N.mark = p.mark
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

      if F2 then
        merge_table(N, F2)
      end

      N.mark = p.mark
    end
  end
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


--
-- Build a door.
-- 
-- Valid sizes (long x deep) are:
--    4x3  4x2  4x1
--    3x3  3x2  3x1
--    2x3  2x2  2x1
--
function B_door(p, c, link, b_theme, x, y, z, dir, long,deep, door_info)
 
  local high = door_info.h
  
  local dx, dy = dir_to_delta(dir)
  local ax, ay = dir_to_across(dir)
  local adir = delta_to_dir(ax, ay)

  assert (link.kind == "door")

  local wall_tex = c.theme.wall
  local key_tex  = wall_tex
  local track_tex = door_info.track or "DOORTRAK"
  local door_tex = door_info.tex
  local side_tex = "LITE5"
  local ceil_tex = "FLAT1"

  if deep >= 2 then
    side_tex = key_tex
    ceil_tex = "TLITE6_5"
  end

  local door_kind = 1
  if p.deathmatch and rand_odds(66) then door_kind = 117 end -- blaze
    
  local door = { f_h = z+8, c_h = z+8,
                 f_tex = "FLAT1",
                 c_tex = door_info.bottom or "FLAT1",
                 light = 255,
                 l_tex = door_tex,
                 u_tex = door_tex,
                 door_kind = door_kind }

  -- FIXME MOVE OUT OF HERE PLEASE !!!
  if link.quest then

    if link.quest.kind == "key" then
          if link.quest.item == "k_red"    then door.door_kind = 28; key_tex = "DOORRED2"
      elseif link.quest.item == "k_blue"   then door.door_kind = 26; key_tex = "DOORBLU2"
      elseif link.quest.item == "k_yellow" then door.door_kind = 27; key_tex = "DOORYEL2"
      end

    elseif link.quest.kind == "switch" then
      door.door_kind = nil;
      door.tag = link.quest.tag + 1
---###      door_tex = "BIGDOOR3"
      local info = TH_SWITCHES[link.quest.item]
      key_tex = info.wall
      assert(key_tex)

      if info.bars then
        local sec = copy_block(c.room_sec)
        sec.f_h = z
        sec.f_tex = b_theme.floor
        sec.c_tex = b_theme.ceil
        if not link.src.outdoor or not link.dest.outdoor then
          sec.c_h = sec.c_h - 32
          if b_theme.outdoor then sec.c_tex = sec.f_tex end
        end
        local bar = link.bar_size
        B_bars(p,c, x,y, math.min(dir,10-dir),long, bar,bar*2, info, sec,b_theme.wall, door.tag)
        return;
      end
    end

    side_tex = key_tex
    ceil_tex = "TLITE6_6"
  end


  local d_front = { f_h = z+8, c_h = z+8 + door_info.h,
                    f_tex = "FLAT1", c_tex = ceil_tex,
                    light=224,
                    l_tex = c.theme.step,
                    u_tex = wall_tex }

  local d_back = d_front

  -- block based door (big 'n bulky)

  if long >= 3 and deep == 3 then

    local zx, zy = (long-1)*ax, (long-1)*ay
    local ex, ey = (long-2)*ax, (long-2)*ay

    fill (p,c, x,   y,    x+zx,y+zy, { solid=key_tex })
    fill (p,c, x+ax,y+ay, x+ex,y+ey, d_back )
    x = x + dx; y = y + dy

    fill (p,c, x,   y,    x+zx,y+zy, { solid=wall_tex })
    fill (p,c, x+ax,y+ay, x+ex,y+ey, door)
    x = x + dx; y = y + dy

    fill (p,c, x,   y,    x+zx,y+zy, { solid=key_tex })
    fill (p,c, x+ax,y+ay, x+ex,y+ey, d_front )

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
    local y_diff = link_other(link, c).ceil_h - d_front.c_h
    local far = deep * FW - 1

    local override =
    {
      l_tex = side_tex,
      y_offset = y_diff
    }

    frag_fill (p,c, fx,fy, fx+sx+dx*far,fy+zy-sy+dy*far,
      { solid=key_tex, [adir] = override })
    frag_fill (p,c, fx+zx-sx,fy+zy-sy, fx+zx+dx*far,fy+zy+dy*far, 
      { solid=key_tex, [10-adir] = override })

    for ff = 1,step do
      frag_fill (p,c, fx+sx,fy+sy, fx+ex,fy+ey, d_front)
      fx = fx + dx; fy = fy + dy
    end

    for mm = 1,2 do
      frag_fill (p,c, fx+ax,fy+ay, fx+zx-ax,fy+zy-ay, { solid=track_tex })
      frag_fill (p,c, fx+sx,fy+sy, fx+ex,fy+ey, door)
      fx = fx + dx; fy = fy + dy
    end

    for bb = 1,step do
      frag_fill (p,c, fx+sx,fy+sy, fx+ex,fy+ey, d_back)
      fx = fx + dx; fy = fy + dy
    end

    return
  end

  error("UNIMPLEMENTED DOOR " .. long .. "x" .. deep)
end


function B_exitdoor(p, c, link, x, y, z, dir)
 
  local long = 2
  local deep = 2
  local high = 72  -- FIXME: pass in "door_info"

  local dx, dy = dir_to_delta(dir)
  local ax, ay = dir_to_across(dir)
  local adir = delta_to_dir(ax, ay)

  assert (link.kind == "door")

  local wall_tex = c.theme.wall
  local door_tex = TH_DOORS.d_exit.tex
  local key_tex  = door_tex
  local track_tex = "DOORTRAK"

  local door = { f_h = z+8, c_h = z+8,
                 f_tex = "FLAT1", c_tex = "FLAT1",
                 light = 255,
                 door_kind = 1,
                 l_tex = c.theme.wall,
                 u_tex = door_tex
               }

  local d_front = { f_h = z+8, c_h = z+8+high,
                    f_tex = "FLAT1", c_tex = "TLITE6_5",
                    light=255,
                    l_tex = c.theme.step,
                    u_tex = wall_tex }

  local d_back = d_front

  local d_exit = { f_h = z+8, c_h = z+8+high-16,
                   f_tex = d_front.f_tex, c_tex = "CEIL5_2",
                   light=255,
                   l_tex = "EXITSIGN", u_tex = "EXITSIGN" }

  local fx = 1 + (x-1)*FW
  local fy = 1 + (y-1)*FH

  if (dir == 4) then fx = fx + FW - 1 end
  if (dir == 2) then fy = fy + FH - 1 end

  assert (long >= 2 and deep <= 2)

  local step = 1 + (deep - 1) * 2
  assert(step * 2 + 2 == deep * FW)

  local side = (long == 4) and 4 or 2
  long = long * 4 - side * 2
  assert(long == 4 or long == 8)

  local sx, sy = ax*side, ay*side
  local ex, ey = ax*(long+1), ay*(long+1)
  local zx, zy = ax*(long+side+1), ay*(long+side+1)

  frag_fill(p,c, fx, fy, fx+zx+dx*7, fy+zy+dy*7, { solid=wall_tex })

  -- align inner sides with outside wall
  local y_diff = link_other(link, c).ceil_h - d_front.c_h
  frag_fill(p,c, fx+ax, fy+ay, fx+ax+dx*7, fy+ay+dy*7,
    { solid=wall_tex, [adir]={ l_tex=c.theme.misc, y_offset=y_diff }} )
  frag_fill(p,c, fx+zx-ax, fy+zy-ay, fx+zx-ax+dx*7, fy+zy-ay+dy*7,
    { solid=wall_tex, [10-adir]={ l_tex=c.theme.misc, y_offset=y_diff }} )

  for ff = 1,4 do
    if ff == 4 then
      frag_fill (p,c, fx+ax,fy+ay, fx+ax,fy+ay,
        { solid=key_tex, [adir] = { x_offset = 112 }} )
      frag_fill (p,c, fx+zx-ax,fy+zy-ay, fx+zx-ax,fy+zy-ay,
        { solid=key_tex, [10-adir] = { x_offset = 112 }} )
    end

    frag_fill (p,c, fx+sx,fy+sy, fx+ex,fy+ey, d_front)

    -- EXIT SIGN
    if ff == 2 then
      frag_fill (p,c, fx+ax*3,fy+ay*3, fx+ax*3,fy+ay*3, d_exit,
        { [10-adir] = { x_offset = 32 }} )
      frag_fill (p,c, fx+ax*4,fy+ay*4, fx+ax*4,fy+ay*4, d_exit,
        { [adir] = { x_offset = 32 }} )
    end

    fx = fx + dx; fy = fy + dy
  end

  for mm = 1,1 do
    frag_fill (p,c, fx+ax,fy+ay, fx+zx-ax,fy+zy-ay, { solid=track_tex })
    frag_fill (p,c, fx+sx,fy+sy, fx+ex,fy+ey, door)
    fx = fx + dx; fy = fy + dy
  end

  for bb = 1,3 do
    if bb == 1 then
      frag_fill (p,c, fx+ax,fy+ay, fx+ax,fy+ay,
        { solid=key_tex, [adir] = { x_offset = 112 }} )
      frag_fill (p,c, fx+zx-ax,fy+zy-ay, fx+zx-ax,fy+zy-ay,
        { solid=key_tex, [10-adir] = { x_offset = 112 }} )
    end
    frag_fill (p,c, fx+sx,fy+sy, fx+ex,fy+ey, d_back)
    fx = fx + dx; fy = fy + dy
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
                  light = c.lighting,

                  l_tex = c.theme.wall,
                  u_tex = c.theme.wall,

                  [out_dir]={ l_tex = c.theme.step },
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
    f_tex = c.theme.lift_flat or TH_LIFT.floor,
    c_tex = c.theme.ceil,
    light = c.lighting,

    lift_kind = 123,  -- 62 for slower kind
    lift_walk = 120,  -- 88 for slower kind
    tag = allocate_tag(p),

    l_tex = c.theme.lift or TH_LIFT.wall,
    u_tex = c.theme.wall
  }

  fill(p,c, x, y,
          x + (long-1) * ax + (deep-1) * dx,
          y + (long-1) * ay + (deep-1) * dy,
          LIFT)
end


--
-- Build a pillar switch
--
function B_pillar_switch(p,c, x,y, info, kind, tag)

  fill(p,c, x,y, x,y,
     { solid=info.switch,
         switch_kind = kind,
         switch_tag = tag,
         y_offset = 128 - (c.ceil_h - c.floor_h)
     }) 

--##  local B = p.blocks[c.blk_x+x][c.blk_y+y]
--##
--##  B.switch_kind = kind
--##  B.switch_tag  = tag

end


--
-- Build a floor-standing switch
--
function B_floor_switch(p,c, x,y,z, side, info, kind, tag)

  local fx = (x - 1) * FW
  local fy = (y - 1) * FH

  BASE = copy_block(c.room_sec)
  BASE.f_h = z
  BASE.l_tex = c.theme.wall
  BASE.u_tex = c.theme.wall

  frag_fill(p,c, fx+1,fy+1, fx+FW,fy+FH, BASE)

  SWITCH =
  {
    f_h = z + 64,
    c_h = c.ceil_h,
    f_tex = TH_METAL.floor,
    c_tex = c.theme.ceil,
    light = c.lighting,

    l_tex = info.switch,
    u_tex = c.theme.wall,

    switch_kind = kind,
    switch_tag  = tag,
  }

  local sx,sy, ex,ey = side_to_corner(side, FW, FH)

  frag_fill(p,c, fx+sx,fy+sy, fx+ex,fy+ey, SWITCH)
end


function B_wall_switch(p,c, x,y,z, side, info, kind, tag)

  local ax, ay = dir_to_across(side)

  local fx = (x - 1) * FW
  local fy = (y - 1) * FH

  frag_fill(p,c, fx+1,fy+1, fx+(ax+1)*FW,fy+(ay+1)*FH, { solid=c.theme.wall })

  SWITCH =
  {
    f_h = z,
    c_h = z + 64,
    f_tex = c.theme.floor,
    c_tex = c.theme.floor, -- F_SKY1 is no good
    light = 224,

    l_tex = c.theme.wall,
    u_tex = c.theme.wall,
  }

  local sx,sy, ex,ey = side_to_corner(side, FW, FH)
  local dx,dy = dir_to_delta(10-side)

  sx,sy = sx + 2*ax, sy + 2*ay
  ex,ey = ex + 2*ax, ey + 2*ay

  frag_fill(p,c, fx+sx,fy+sy, fx+ex,fy+ey, SWITCH)

  -- lights
  local lit_dir = sel(side==2 or side==8, 6, 8)
  frag_fill(p,c, fx+sx-ax,fy+sy-ay, fx+sx-ax,fy+sy-ay,
       { solid=c.theme.wall, [lit_dir]={ l_tex = "LITE5" }} )
  frag_fill(p,c, fx+ex+ax,fy+ey+ay, fx+ex+ax,fy+ey+ay,
       { solid=c.theme.wall, [10-lit_dir]={ l_tex = "LITE5" }} )

  sx,sy = sx+dx, sy+dy
  ex,ey = ex+dx, ey+dy

  frag_fill(p,c, fx+sx,fy+sy, fx+ex,fy+ey,
       { solid=info.switch,
         switch_kind = kind,
         switch_tag = tag,
         -- y_offset = 
       }) 
end


--
-- Build a pedestal (items, players)
-- 
function B_pedestal(p, c, x, y, z, info)
 
  local PEDESTAL =
  {
    f_h   = z + info.h,
    f_tex = info.floor,
    c_h   = c.ceil_h,
    c_tex = c.theme.ceil,
    light = c.lighting,

    l_tex = info.wall,
    u_tex = c.theme.wall
  }

--FIXME temp (shouldn't be needed)
if (PEDESTAL.c_h - PEDESTAL.f_h) < 64 then
  PEDESTAL.c_h = PEDESTAL.f_h + 64
end

  fill(p,c, x,y, x,y, PEDESTAL)
end


--
-- Build some bars
--
-- Use a nil 'tag' parameter for solid bars, otherwise
-- the bars will be openable (by LOWERING!).
--
-- size must be either 1 or 2.
--
function B_bars(p,c, x,y, dir,long, size,step, bar_theme, sec,tex, tag)

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
end


--
-- fill a chunk with void, with pictures on the wall
--
function B_void_pic(p,c, kx,ky, pic,cuts, z1,z2)

  local x1 = chunk_to_block(kx)
  local y1 = chunk_to_block(ky)
  local x2 = chunk_to_block(kx + 1) - 1
  local y2 = chunk_to_block(ky + 1) - 1

  local fx = (x1 - 1) * FW
  local fy = (y1 - 1) * FH

  frag_fill(p,c, fx+1,fy+1, fx+3*FW,fy+3*FH, { solid=c.theme.wall })
  frag_fill(p,c, fx+2,fy+2, fx+3*FW-1,fy+3*FH-1, { solid=pic })

  CUTOUT =
  {
    f_h = z1,
    c_h = z2,
    f_tex = c.theme.floor,
    c_tex = c.theme.floor, -- F_SKY1 is no good
    light = c.lighting,

    l_tex = c.theme.wall,
    u_tex = c.theme.wall,
  }

  if cuts >= 3 then
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

--
-- create a chunk-sized monster cage
--
function B_big_cage(p,c, kx,ky)

  local bx = chunk_to_block(kx)
  local by = chunk_to_block(ky)

  CAGE =
  {
    f_h = c.ceil_h - 16 - 72,
    c_h = c.ceil_h - 16,
    f_tex = TH_CAGE.floor,
    c_tex = TH_CAGE.ceil,
    light = 176,

    l_tex = TH_CAGE.wall,
    u_tex = TH_CAGE.wall,
    is_cage = true
  }

  for x = 0,2 do for y = 0,2 do
    local overrides = {}
    if x == 0 then overrides[4] = { rail="MIDBARS3" } end
    if x == 2 then overrides[6] = { rail="MIDBARS3" } end
    if y == 0 then overrides[2] = { rail="MIDBARS3" } end
    if y == 2 then overrides[8] = { rail="MIDBARS3" } end

    fill(p,c, bx+x,by+y, bx+x,by+y, CAGE, overrides)
  end end

  local spot = {x=bx, y=by, double=true, dx=32, dy=32}
  add_cage_spot(p,c, spot)
end

--
-- create a deathmatch exit room
--
-- FIXME: it always faces south
--
function B_deathmatch_exit(p,c, kx,ky)

  local theme = TH_EXITROOM

  local x1 = chunk_to_block(kx)
  local y1 = chunk_to_block(ky)
  local x2 = chunk_to_block(kx + 1) - 1
  local y2 = chunk_to_block(ky + 1) - 1

  local fx = (x1 - 1) * FW
  local fy = (y1 - 1) * FH

  local ROOM =
  {
    f_h = c.room_sec.f_h,
    c_h = c.room_sec.f_h + 72,
    f_tex = theme.floor,
    c_tex = theme.ceil,
    light = 176,

    l_tex = theme.void,
    u_tex = theme.void,
  }

  frag_fill(p,c, fx+1,fy+1, fx+3*FW,fy+3*FH, { solid=theme.void })
  frag_fill(p,c, fx+2,fy+2, fx+3*FW-1,fy+3*FH-1, ROOM)

  local STEP =
  {
    f_h = c.room_sec.f_h + 8,
    c_h = c.room_sec.f_h + 80,
    f_tex = "FLAT1",
    c_tex = "FLAT1",
    light = 255,

    l_tex = "STEP1",
    u_tex = theme.void,
  }

  frag_fill(p,c, fx+4,fy+1, fx+9,fy+4, { solid=theme.void})
  frag_fill(p,c, fx+5,fy+1, fx+8,fy+4, STEP)

  local DOOR =
  {
    f_h = c.room_sec.f_h + 8,
    c_h = c.room_sec.f_h + 8,
    f_tex = "FLAT1",
    c_tex = "FLAT1",
    light = 255,

    l_tex = c.theme.wall,
    u_tex = TH_DOORS.d_exit.tex,
    door_kind = 1,  -- blaze door
  }

  frag_fill(p,c, fx+4,fy+2, fx+9,fy+3, { solid="DOORTRAK" })
  frag_fill(p,c, fx+5,fy+2, fx+8,fy+3, DOOR)

  local SWITCH =
  {
    solid = "SW1COMM",
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

function random_light_kind(is_flat)
  local infos = {}
  for zzz,info in ipairs(TH_LIGHTS) do
    if sel(is_flat, info.flat, info.tex) then
      table.insert(infos,info)
    end
  end
  assert(#infos > 0)
  return rand_element(infos)
end

function random_door_kind(w)
  local names = {}
  for kind,info in pairs(TH_DOORS) do
    if kind ~= "d_exit" and info.w == w then
      table.insert(names,kind)
    end
  end
  assert(#names > 0)
  return rand_element(names)
end


----------------------------------------------------------------



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

      -- what shall we put in-between?
      local r = con.random() * 100
      if r < 40 then
        c.chunks[kx][ky] = { link=link }
      elseif r < 80 then
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
---### print("d_pos", d_pos, "j", j, "K", kx, ky, "A", ax, ay)
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

--[[!!!!
if (link.src.x==1 and link.src.y>1 and link.dest.x==1 and link.dest.y>1) then
 print("cell ", c.x, c.y)
 print("link where=", link.where)
 for zzz,loc in ipairs(coords) do
 print("__", loc.x, loc.y);
 end
end
--]]

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

-- io.stderr:write(string.format("  CLASH IN (%d,%d)\n", c.x, c.y))

        -- be fair about which link we will blame
        if c.chunks.clasher.link and rand_odds(50) then
          L = c.chunks.clasher.link
        end

        -- remove the chunks from the offending cells and
        -- select a different exit position
        L.src.chunks  = nil
        L.dest.chunks = nil

        random_where(L)

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
    if k1.link and k2.link then return k1.link == k2.link end
    return false
  end

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

    if possible and common and common.link then
      for x = x1,x2 do
        for y = y1,y2 do
          if not c.chunks[x][y] then
            c.chunks[x][y] = copy_chunk(common)
          end
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

  local function add_dm_exit(c)
    local kx, ky = 1, 3

    if c.chunks[1][3] then
      print("WARNING: deathmatch exit stomped a chunk!")
    end

    c.chunks[1][3] = { void=true, dm_exit=true, dir=2 }

    if not c.chunks[1][2] then
      c.chunks[1][2] = { room=true }
    end
  end

  local function flesh_out_cell(c)
    
    -- possibilities:
    --   (a) fill unused chunks with void
    --   (b) fill unused chunks with room
    --   (c) fill unused chunk from nearby ledge

    -- FIXME get info from theme
    local kinds = { "room", "void", "flush", "cage", "liquid" }
    local probs = { 33, 5, 50, 7, 35 }

    if not c.outdoor then probs[2] = 20 end
    if p.deathmatch then probs[4] = 0 end

    if c.scenic then probs[1] = 200 end

    if p.deathmatch and c.x == 1 and c.y == p.h then
      add_dm_exit(c)
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
io.stdout:write(string.format(
  "CELL (%d,%d)  STAIR %d,%d facing %d  HT %d -> %d\n",
  c.x, c.y, loc.x, loc.y, loc.dir,
  K.delta_floor, c.chunks[loc.x+dx][loc.y+dy].delta_floor
  ))
--]]
      assert(not K.stair_dir)

      K.stair_dir = loc.dir
      K.connected = 1

      grow_connx()
    end 

    --> result: certain chunks have a "stair_dir" field
    -->         Direction to neighbour chunk.  Stair will
    -->         be built inside that chunk.

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
    if (c.x==1) or (c.x==p.w) or (c.y==1) or (c.y==p.h) or rand_odds(75) then
      local spot = get_spot()
      if spot then spot.K.player = true end
    end

    -- guarantee at least one weapon (central cell)
    if (c.x==int((p.w+1)/2)) or (c.y==int((p.h+1)/2)) or rand_odds(80) then
      local spot = get_spot()
      if spot then spot.K.dm_weapon = choose_dm_thing(p, DM_WEAPON_LIST, true) end
    end

    -- secondary players and weapons
    if rand_odds(33) then
      local spot = get_spot()
      if spot then spot.K.player = true end
    end
    if rand_odds(25) then
      local spot = get_spot()
      if spot then spot.K.dm_weapon = choose_dm_thing(p, DM_WEAPON_LIST, true) end
    end

    -- from here on we REUSE the spots --

    if #spots == 0 then return end

    -- health, ammo and items
    if rand_odds(70) then
      local spot = reusable_spot()
      spot.K.dm_health = choose_dm_thing(p, DM_HEALTH_LIST, false)
    end

    if rand_odds(90) then
      local spot = reusable_spot()
      spot.K.dm_ammo = choose_dm_thing(p, DM_AMMO_LIST, true)
    end
 
    if rand_odds(10) then
      local spot = reusable_spot()
      spot.K.dm_item = choose_dm_thing(p, DM_ITEM_LIST, true)
    end

    -- secondary health and ammo
    if rand_odds(10) then
      local spot = reusable_spot()
      spot.K.dm_health = choose_dm_thing(p, DM_HEALTH_LIST, false)
    end
    if rand_odds(30) then
      local spot = reusable_spot()
      spot.K.dm_ammo = choose_dm_thing(p, DM_AMMO_LIST, true)
    end
  end

  --==-- make_chunks --==--

  for zzz,link in ipairs(p.all_links) do
    random_where(link)
  end

  -- firstly, allocate chunks based on exit locations
  for loop=1,999 do
    local clashes = 0

    for zzz,cell in ipairs(p.all_cells) do
      if not put_chunks_in_cell(cell) then
        clashes = clashes + 1
      end
    end

--  io.stderr:write("MAKING CHUNKS: ", clashes, " clashes\n")

    if clashes == 0 then break end
  end

  -- secondly, determine main walk areas

  for zzz,cell in ipairs(p.all_cells) do

      add_essential_chunks(cell)

      flesh_out_cell(cell)

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
    end

    -- look towards center of room
    local ANGLES =
    {
      [11] =  45, [21] =  90, [31] = 135,
      [12] =   0,             [32] = 180,
      [13] = 315, [23] = 270, [33] = 225
    }

    local kk = (kx * 10) + ky

    if ANGLES[kk] then return ANGLES[kk] end

    return rand_irange(0,7) * 45
  end

  local function decide_void_pic(p, c)
    if c.theme.pic_wd and rand_odds(60) then
      c.void_pic = { tex=c.theme.pic_wd, w=128, h=c.theme.pic_wd_h or 128 }
      c.void_cut = 1
    elseif not c.theme.outdoor and rand_odds(25) then
      local pic
      repeat
        pic = rand_element(TH_LIGHTS)
      until pic.tex
      c.void_pic = pic
      c.void_cut = rand_irange(3,4)
    else
      c.void_pic = rand_element(TH_PICS)
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
        local sec = copy_block(c.room_sec)
        sec.l_tex = tex
        sec.u_tex = tex
        fill(p,c, x, y, ex, ey, sec)
        return
      end

      local arch = copy_block(c.room_sec)
      arch.c_h = math.min(c.ceil_h-32, other.ceil_h-32, c.floor_h+128)
      arch.c_tex = c.room_sec.f_tex --!!

      if (arch.c_h - arch.f_h) < 64 then
        arch.c_h = arch.f_h + 64
      end

      if c.theme.outdoor then
        arch.light = arch.light - 32
      else
        arch.light = arch.light - 16
      end

      local special_arch

      if link.where == "wide" and rand_odds(70) then
        special_arch = true

        arch.c_h = math.max(arch.c_h, c.ceil_h - 48)
        arch.c_tex = "SLIME14"

        tex = TH_METAL.wall  -- FIXME: TH_ARCH
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

      B_exitdoor(p, c, link,  x-dx, y-dy, c.floor_h, dir)

    elseif link.kind == "door" then

      local kind = link.wide_door

      if link.src.quest == link.dest.quest and (link.door_rand < 25) then
        kind = link.narrow_door
      end

      local info = TH_DOORS[kind]
      assert(info)

      B_door(p, c, link, b_theme, x-dx, y-dy, c.floor_h, dir,
             1 + int(info.w / 64), 1, info)

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

  local function get_bordering_cell(c, bx, by)
    if bx == 1  and c.x > 1   then return p.cells[c.x-1][c.y], c.link[4] end
    if bx == BW and c.x < p.w then return p.cells[c.x+1][c.y], c.link[6] end
    if by == 1  and c.y > 1   then return p.cells[c.x][c.y-1], c.link[2] end
    if by == BH and c.y < p.h then return p.cells[c.x][c.y+1], c.link[8] end
  end
  
  local function neighbour_by_side(c, dir)
    if dir == 4 and c.x > 1   then return p.cells[c.x-1][c.y], c.link[4] end
    if dir == 6 and c.x < p.w then return p.cells[c.x+1][c.y], c.link[6] end
    if dir == 2 and c.y > 1   then return p.cells[c.x][c.y-1], c.link[2] end
    if dir == 8 and c.y < p.h then return p.cells[c.x][c.y+1], c.link[8] end
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
       dual_odds(cell.theme.outdoor, 40, 25)
    then
       return "empty"
    end

    if not other then
      if cell.theme.outdoor then return "sky" end
      return "solid"
    end

    -- fencing anyone?
    if (cell.theme.outdoor == other.theme.outdoor) and
       (not cell.is_exit and not other.is_exit) and
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

  local function border_theme(other)
    if not other then return c.theme end

    local t1 = c.theme
    local t2 = other.theme

    if t1.mat_pri < t2.mat_pri then t1,t2 = t2,t1 end

    local diff = t1.mat_pri - t2.mat_pri
    assert(diff >= 0)

    if diff <= 3 then
      local PROBS = { 100, 10, 3, 1 }
      if rand_odds(PROBS[1+diff]) then t1,t2 = t2,t1 end
    end

    return t1
  end

  local function corner_theme(dx, dy)
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

    return best
  end

  local function build_sky_border(side, x1,y1, x2,y2)

    local WALL =
    {
      f_h = c.f_max + 48, c_h = c.ceil_h,
      f_tex = c.theme.floor, c_tex = c.theme.ceil,
      light = c.lighting,
      l_tex = c.theme.wall,
      u_tex = c.theme.wall,
    }

    local BEHIND =
    {
      f_h = c.f_min - 512, c_h = c.f_min - 508,
      f_tex = c.theme.floor, c_tex = c.theme.ceil,
      light = c.lighting,
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
      light = c.lighting,
      l_tex = c.theme.wall,
      u_tex = c.theme.wall,
    }

    local BEHIND =
    {
      f_h = c.f_min - 512, c_h = c.f_min - 508,
      f_tex = c.theme.floor, c_tex = c.theme.ceil,
      light = c.lighting,
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
      light = c.lighting
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

      overrides = { [rsd] = { rail = TH_RAILS["r_1"].tex }}
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
      light = c.room_sec.light,

      l_tex = b_theme.wall,
      u_tex = b_theme.wall,
    }

    if what == "fence" then
      sec.c_h = c.ceil_h
    else
      sec.light = sec.light - 16
      sec.c_tex = sec.f_tex

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

    -- !!!! FIXME: test crud
    if not bar and what ~= "fence" then
      sec[side] = { rail = TH_RAILS["r_2"].tex }
    end

    for d_pos = first, BW-long, step do
      local wx, wy = x + ax*d_pos, y + ay*d_pos

      if (d_pos+1) >= min_x and (d_pos+long) <= max_x then
        if bar then
          B_bars(p,c, wx,wy, math.min(side,10-side),long, bar,bar_step, TH_METAL, sec,b_theme.wall)
        else
          gap_fill(p,c, wx,wy, wx+ax*(long-1),wy+ay*(long-1), sec)
        end
      end
    end
  end

  local function build_border(side, pass)

    local link = c.link[side]
    local other = neighbour_by_side(c, side)

    -- should *we* build it, or the other side?
    if link then
      if link.build ~= c then return end
    else
      local dx, dy = dir_to_delta(side)
      local other = p.cells[c.x+dx] and p.cells[c.x+dx][c.y+dy]

      if other then
        if c.theme.outdoor == other.theme.outdoor then
          if side > 5 then return end
        else
          if c.theme.outdoor then return end
        end
      end
    end

    local what = what_border_type(c, link, other, side)

    if (pass == 1 and what ~= "sky") or
       (pass == 2 and what == "sky") then return end

    local b_theme = border_theme(other)

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
        light = c.lighting
      }
      if rand_odds(95) then FENCE.block_sound = 2 end

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

        local NB = neighbour_by_side(c, nb_side)

        local cx, cy = corn_x1, corn_y1
        if cr == 2 then cx, cy = corn_x2, corn_y2 end

        if NB then
          local NB_link = NB.link[side]
          local NB_other = neighbour_by_side(NB, side)

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

    local corn_t1 = corner_theme(corn_dx1, corn_dy1)
    local corn_t2 = corner_theme(corn_dx2, corn_dy2)

    gap_fill(p,c, corn_x1,corn_y1, corn_x1,corn_y1, { solid=corn_t1.void })
    gap_fill(p,c, corn_x2,corn_y2, corn_x2,corn_y2, { solid=corn_t2.void })
  end

  local function build_chunk(kx, ky)

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

          -- FIXME: don't put pillar on "must_walk" blocks

          jx,jy = (bx - 1)*FW, (by - 1)*FH

          -- FIXME: interact well with stairs/lift

          frag_fill(p,c, jx+1, jy+1, jx+FW, jy+FH, sec)
          frag_fill(p,c, jx+fx, jy+fy, jx+fx, jy+fy, { solid=K.sup_tex})
        end
      end
    end

    local function chunk_fill(c, K, kx, ky, sec, l_tex, u_tex)
      local x1 = chunk_to_block(kx)
      local y1 = chunk_to_block(ky)
      local x2 = chunk_to_block(kx + 1) - 1
      local y2 = chunk_to_block(ky + 1) - 1

      if not sec then
        gap_fill(p,c, x1, y1, x2, y2, { solid=l_tex })
        return
      end

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

      if K.pillar and not blocked then

-- TEST CRUD
if rand_odds(24) and TH_CAGE and not p.deathmatch then
  local CAGE = copy_block(c.room_sec)
  local z = (c.f_max + c.ceil_h) / 2
  CAGE.f_tex = TH_CAGE.floor
  CAGE.l_tex = TH_CAGE.wall
  CAGE.u_tex = TH_CAGE.wall
  CAGE.is_cage = true

  if kx==2 and ky==2 and dual_odds(c.theme.outdoor, 90, 20) then
    CAGE.f_h = z
    CAGE.c_h = c.ceil_h
    CAGE.c_tex = c.theme.ceil

    if rand_odds(50) then
      CAGE.rail = TH_RAILS["r_1"].tex
      if CAGE.f_h > CAGE.c_h - 72 then
        CAGE.f_h = CAGE.c_h - 72
      end
    end
  else
    CAGE.f_h = z - 32
    CAGE.c_h = z + 40
    CAGE.c_tex = TH_CAGE.ceil
    CAGE.light = 192
    CAGE.rail  = TH_RAILS[TH_CAGE.rail].tex
  end

  fill(p,c, x1+1, y1+1, x1+1, y1+1, CAGE)

  local spot = {x=x1+1, y=y1+1}
  if kx==2 and ky==2 then spot.different = true end

  add_cage_spot(p,c, spot)

--[[ corner adjustment testing (REMOVE)
elseif true then

   local fx = x1 * FW
   local fy = y1 * FH

   local sec = copy_block(c.room_sec)

   frag_fill(p,c, fx+1,fy+1, fx+FW, fy+FH, { solid="CRACKLE2" })

   frag_fill(p,c, fx+1 ,fy+1 , fx+1 ,fy+1 , { solid="CRACKLE2", short=1, [1] = { dx=5, dy=5 }})
   frag_fill(p,c, fx+FW,fy+1,  fx+FW,fy+1,  { solid="CRACKLE2", short=2, [3] = { dx=-5, dy=5 }})
   frag_fill(p,c, fx+1, fy+FH, fx+1, fy+FH, { solid="CRACKLE2", short=3, [7] = { dx=5,  dy=-5 }})
   frag_fill(p,c, fx+FW,fy+FH, fx+FW,fy+FH, { solid="CRACKLE2", short=4, [9] = { dx=-5, dy=-5 }})

   local sec2 = copy_block(c.room_sec)
   sec2.f_tex = "LAVA1"

   gap_fill(p,c, x1+0,y1+1, x1+0,y1+1, sec2, { [1]={dx= 9,dy=9}, [7]={dx= 9,dy=-9}, short=true })
   gap_fill(p,c, x1+2,y1+1, x1+2,y1+1, sec2, { [3]={dx=-9,dy=9}, [9]={dx=-9,dy=-9}, short=true })
--]]
else
        fill(p,c, x1+1, y1+1, x1+1, y1+1,
          { solid= c.theme.pillar or c.theme.void,
            y_offset= 128 - (sec.c_h - sec.f_h) })
end
      blocked = true
      end

      sec.l_tex = l_tex
      sec.u_tex = u_tex

      gap_fill(p,c, x1, y1, x2, y2, sec)

      if not blocked and c.theme.scenery and not K.stair_dir and
         dual_odds(c.theme.outdoor, 45, 22)
      then
        add_thing(p, c, x1+1, y1+1, SCENERY_NUMS[c.theme.scenery], true)
        p.blocks[c.blk_x+x1+1][c.blk_y+y1+1].has_scenery = true
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

      local cluster = CLUSTER_THINGS[name] or 1
      assert(cluster >= 1 and cluster <= 8)

      local offsets = { 1,2,3,4, 6,7,8,9 }
      rand_shuffle(offsets)

      for i = 1,cluster do
        local dx, dy = dir_to_delta(offsets[i])
        add_thing(p, c, bx+dx, by+dy, THING_NUMS[name], false)
      end
    end

    -- build_chunk --

    local K = c.chunks[kx][ky]
    assert(K)

    if K.void then
      if K.dm_exit then
        B_deathmatch_exit(p,c, kx,ky,K.dir)

      elseif TH_PICS and dual_odds(c.theme.outdoor, 10, 50) then
        if not c.void_pic then decide_void_pic(p, c) end
        local h = c.void_pic.h or (c.c_min - c.f_max - 32)
        local z = (c.c_min + c.f_max) / 2
        B_void_pic(p,c, kx,ky, c.void_pic.tex,c.void_cut, z-h/2, z+h/2)

      else
        chunk_fill(c, K, kx, ky, nil, c.theme.void, c.theme.void)
      end
      return
    end

    if K.cage then
      B_big_cage(p,c, kx,ky)
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

      -- FIXME: replace with proper "can walk" test !!!!
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

--[[ ???
    if true and (c.floor_h ~= other.floor_h) then

      if BW > 12 then
        x = x + 1 * dx
        y = y + 1 * dy
      end

      if diff < 128 or (diff == 128 and rand_odds(75)) then

        B_stair(p, c, link,  x, y, other.floor_h, dir,
                2, 2, (c.floor_h - other.floor_h) / 8,
                { } )
      else
        B_lift(p, c, link,  x, y,
               math.max(c.floor_h, other.floor_h), dir,
                2, 2, { } )
      end
    end
--]]
    end

    local bx = chunk_to_block(kx) + 1
    local by = chunk_to_block(ky) + 1

    if K.player then
      local angle = player_angle(kx, ky)
      local offsets = sel(rand_odds(50), {1,3,7,9}, {2,4,6,8})
      if p.coop then
        for i = 1,4 do
          local dx,dy = dir_to_delta(offsets[i])
          B_pedestal(p, c, bx+dx, by+dy, K.floor_h, PED_PLAYER)
          add_thing(p, c, bx+dx, by+dy, i, true, angle)
        end
      else
        B_pedestal(p, c, bx, by, K.floor_h, PED_PLAYER)
        add_thing(p, c, bx, by, p.deathmatch and 11 or 1, true, angle)
      end

    elseif K.dm_weapon then
      B_pedestal(p, c, bx, by, K.floor_h, PED_WEAPON)
      add_thing(p, c, bx, by, THING_NUMS[K.dm_weapon], true)

    elseif K.quest then

      if c.quest.kind == "key" or c.quest.kind == "weapon" or c.quest.kind == "item" then
        B_pedestal(p, c, bx, by, K.floor_h, PED_QUEST)

        -- weapon and keys are non-blocking, but we don't want
        -- a monster sitting on top of our quest item (especially
        -- when it has a pedestal).
        add_thing(p, c, bx, by, THING_NUMS[c.quest.item], true)

      elseif c.quest.kind == "switch" then
        local info = TH_SWITCHES[c.quest.item]
        assert(info.switch)
        local kind = 103; if info.bars then kind = 23 end
        if rand_odds(50) then
          local side = wall_switch_dir(kx, ky, c.entry_dir)
          B_wall_switch(p,c, bx,by, K.floor_h, side, info, kind, c.quest.tag + 1)
        else
          B_pillar_switch(p,c, bx,by, info,kind, c.quest.tag + 1)
        end

      elseif c.quest.kind == "exit" then
        local side = wall_switch_dir(kx, ky, c.entry_dir)
        B_floor_switch(p,c, bx,by, K.floor_h, side, TH_SWITCHES.sw_exit, 11)
      end
    end

    -- fill in the rest

    local sec = c.room_sec
    local u_tex = c.theme.wall;

    if K.link and K.link.build ~= c then

      local other = link_other(K.link, c)

      sec = copy_block(c.room_sec)

      sec.f_h = K.floor_h
      sec.c_h = K.ceil_h
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
    end

-- TEST CRUD : overhangs
if rand_odds(10) and c.theme.outdoor and
  not (c.quest.kind == "exit" and c.along == #c.quest.path-1)
then
  sec = copy_block(sec) -- FIXME??
  K.overhang = true

  if not c.overhang then
    c.overhang = rand_element(ALL_OVERHANGS)
  end
  local overhang = c.overhang

  sec.c_tex = overhang.ceil
  u_tex = overhang.upper
  K.sup_tex = overhang.thin

  sec.c_h = sec.c_h - (overhang.h or 24)
  sec.light = sec.light - 48
end

-- TEST CRUD : pillars
if sec and not c.is_exit and not c.scenic and not K.stair_dir and
  dual_odds(c.theme.outdoor, 12, 25)
then
  K.pillar = true
end

-- TEST CRUD : sky lights
if c.sky_light then
  if kx==2 and ky==2 and c.sky_light.pattern == "pillar" then
    K.pillar = true
  end

  K.sky_light_sec = copy_block(sec)
  K.sky_light_sec.c_h = sec.c_h + c.sky_light.h
  K.sky_light_sec.c_tex = sel(c.sky_light.is_sky, TH_STONY.ceil, c.sky_light.light_info.flat)
  K.sky_light_sec.light = 176
  K.sky_light_utex = c.sky_light.light_info.side
end
 
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

  p.mark = p.mark + 1

  -- these refer to the bottom/left corner block
  -- (not actually in the cell, but in the border)
  c.blk_x = BORDER_BLK + (c.x-1) * (BW+1)
  c.blk_y = BORDER_BLK + (c.y-1) * (BH+1)

  c.lighting = 144
  if (c.theme.outdoor) then
    c.lighting = 192
  end

  c.room_sec = { f_h=c.floor_h, c_h=c.ceil_h,
                 f_tex=c.theme.floor, c_tex=c.theme.ceil,
                 light=c.lighting,
                 }

  if not c.theme.outdoor and not c.is_exit and rand_odds(70) then
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

  -- FIXME: pre-battle stuff (monster cages, cyberdemon)

--[[  -- TEST ONLY!
    local middle = { f_h=room.f_h+24/3, c_h=room.f_h+192,
                   f_tex="FLAT1", c_tex="FLAT1",
                   light=128 }

    local L, H = (BW/4+1), (BW*3/4)

    fill(c, L, L, H, H, room, "METAL6", "METAL7")

    fill(c, L, L, L, L, nil, "WOOD10"); -- c.blocks[L][L].corner_ne = { dx=-12, dy=-12 }
    fill(c, L, H, L, H, nil, "WOOD10"); -- c.blocks[L][H].corner_se = { dx=-12, dy= 12 }
    fill(c, H, L, H, L, nil, "WOOD10"); -- c.blocks[H][L].corner_nw = { dx= 12, dy=-12 }
    fill(c, H, H, H, H, nil, "WOOD10"); -- c.blocks[H][H].corner_sw = { dx= 12, dy= 12 }
--]]

end


function build_level(p)

  make_chunks(p)
--  show_chunks(p)

  for zzz,cell in ipairs(p.all_cells) do
    build_cell(p, cell)
  end

  con.progress(25); if con.abort() then return end
 
  if not p.deathmatch then
    battle_through_level(p)
  end

  con.progress(40); if con.abort() then return end

  -- DETAIL CELL (???)
end

