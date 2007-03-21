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

--[[

class BuildItem
{
   x1,y1,x2,y2 : used area (not including the "walk zone")

   prefab : name    -- for prefabs
   skin
   parm
   dir
OR
   connx  : name  e.g. "stairs"
   dir
OR
   thing  : name
   angle
   options
}

--]]


function copy_block(B, ...)
  local result = copy_table(B)

  result.things = {}
  
  -- copy the overrides and corner adjustments
  for i = 1,9 do
    if B[i] then result[i] = copy_table(B[i]) end
  end

  return result
end

function copy_block_with_new(B, newbie)
  return merge_table(copy_block(B), newbie)
end


function side_to_chunk(side)
  if side == 2 then return 2, 1 end
  if side == 8 then return 2, 3 end
  if side == 4 then return 1, 2 end
  if side == 6 then return 3, 2 end
  error ("side_to_chunk: bad side " .. side)
end

---###  function side_to_corner(side, W, H)
---###    if side == 2 then return 1,1, W,1 end
---###    if side == 8 then return 1,H, W,H end
---###    if side == 4 then return 1,1, 1,H end
---###    if side == 6 then return W,1, W,H end
---###    error ("side_to_corner: bad side " .. side)
---###  end

function dir_to_corner(dir, W, H)
  if dir == 1 then return 1,1 end
  if dir == 3 then return W,1 end
  if dir == 7 then return 1,H end
  if dir == 9 then return W,H end
  error ("dir_to_corner: bad dir " .. dir)
end

function block_to_chunk(bx)
  return 1 + int((bx-1) * KW / BW)
end

function chunk_to_block(kx)
  return 1 + int((kx-1) * BW / KW)
end

function new_foo_chunk(c, kx, ky, kind, value)
  return
  {
    [kind] = value or true,

    x1 = c.bx1-1 + chunk_to_block(kx),
    y1 = c.by1-1 + chunk_to_block(ky),
    x2 = c.bx1-1 + chunk_to_block(kx + 1) - 1,
    y2 = c.by1-1 + chunk_to_block(ky + 1) - 1,
  }
end

function copy_foo_chunk(c, kx, ky, K)

  assert(not K.vista)

  local COPY = new_chunk(c, kx, ky, "is_copy")

  COPY.room = K.room
  COPY.void = K.void
  COPY.link = K.link
  COPY.cage = K.cage
  COPY.liquid = K.liquid
  COPY.closet = K.closet
  COPY.place  = K.place

  if K.rmodel then
    COPY.rmodel = copy_block(K.rmodel)
  end

  return COPY
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

function is_roomy(chunk)
  return chunk and (chunk.room or chunk.link)
end

function random_where(link, border)

  local LINK_WHERES = { 3, 3, 9, 3, 3 }

  if THEME.caps.blocky_doors or
     (link.quest and link.quest.kind == "key") or
     link.cells[1].is_exit or link.cells[2].is_exit
  then
    LINK_WHERES = { 1, 3, 9, 3, 1 }
  end

  for zzz,c in ipairs(link.cells) do
--???    if c.small_exit then return 0 end
  end

  if (link.kind == "door" and rand_odds(4)) or
     (link.kind ~= "door" and rand_odds(15))
  then
    if border.long >= 7 then
--!!!!      return "double";
    end
  end

  if (link.kind == "arch" and rand_odds(33)) or
     (link.kind == "falloff" and rand_odds(99)) or
     (link.kind == "vista" and rand_odds(50))
  then
--!!!!    return "wide";
  end

---???  if link.kind == "falloff" then return 0 end

  return rand_index_by_probs(LINK_WHERES) - 3
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
      assert(valid_block(p, x, y))

      local N = copy_block(B)
      p.blocks[x][y] = N

      if B2 then
        merge_table(N, B2)
      end

      N.mark = N.mark or c.mark
    end
  end
end

function c_fill(p, c, sx, sy, ex, ey, B, B2)

  fill(p,c, c.bx1-1+sx, c.by1-1+sy, c.bx1-1+ex, c.by1-1+ey, B, B2)
end

function gap_fill(p, c, sx, sy, ex, ey, B, B2)
  if sx > ex then sx, ex = ex, sx end
  if sy > ey then sy, ey = ey, sy end
  for x = sx,ex do
    for y = sy,ey do

if not valid_block(p,x,y) then
con.printf("gap_fill: invalid block (%d,%d)  max: (%d,%d)\n", x,y, p.blk_w, p.blk_h)
error("invalid block")
end
      assert(valid_block(p, x, y))

      local X = p.blocks[x][y]

      if not X or not (X.solid or X.f_tex or X.fragments) then
        fill(p,c, x,y, x,y, B, B2)
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
      
      if not p.blocks[bx][by] then
        p.blocks[bx][by] = {}
      end

      local B = p.blocks[bx][by]
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


function move_corner(p,c, x,y,corner, dx,dy)

  local B = p.blocks[x][y]
  assert(B)

  if not B[corner] then
    B[corner] = {}
  else
    dx = dx + (B[corner].dx or 0)
    dy = dy + (B[corner].dy or 0)
  end

  B[corner].dx = dx
  B[corner].dy = dy

  -- ensure that the writer doesn't swallow up this block
  -- (which would lose the vertex we want to move)
  B.mark = allocate_mark(p)
end

-- the c_ prefix means (x,y) are cell-relative coords
function c_move_frag_corner(p,c, x,y,corner, dx,dy)

  local bx, fx = div_mod(x, FW)
  local by, fy = div_mod(y, FH)

  local B = p.blocks[c.bx1-1+bx][c.by1-1+by]
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

  F.mark = allocate_mark(p)
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


FAB_DIRECTION_MAP =
{
  [8] = { 1,2,3, 4,5,6, 7,8,9 },
  [2] = { 9,8,7, 6,5,4, 3,2,1 },

  [4] = { 3,6,9, 2,5,8, 1,4,7 },
  [6] = { 7,4,1, 8,5,2, 9,6,3 },

  -- mirror --

  [18] = { 3,2,1, 6,5,4, 9,8,7 },
  [12] = { 7,8,9, 4,5,6, 1,2,3 },

  [14] = { 9,6,3, 8,5,2, 7,4,1 },
  [16] = { 1,4,7, 2,5,8, 3,6,9 },
}

function B_prefab(p, c, fab, skin, parm, theme, x,y, dir,mirror_x,mirror_y)

  -- (x,y) is always the block with the lowest coordinate.
  -- dir == 8 is the natural mode, other values rotate it.

  assert(fab and skin and parm and theme)

  -- simulate Y mirroring using X mirroring instead
  if mirror_y then
    mirror_x = not mirror_x
    dir = 10-dir
  end

  local long = fab.long
  local deep = fab.deep
  
  if fab.scale ~= 64 then
    long, deep = long*4, deep*4
  end

  local function f_coords(ex, ey)
    if mirror_x then ex = long+1-ex end

        if dir == 2 then ex,ey = long+1-ex, deep+1-ey
    elseif dir == 4 then ex,ey = deep+1-ey, ex
    elseif dir == 6 then ex,ey =        ey, long+1-ex
    end

    if fab.scale == 64 then
      return x + ex - 1, y + ey - 1
    end
  
    local fx = 1 + (x-1)*FW + ex - 1
    local fy = 1 + (y-1)*FH + ey - 1

    return fx, fy
  end

  local function dd_coords(dx, dy)
    if mirror_x then dx = -dx end

        if dir == 2 then return -dx, -dy
    elseif dir == 4 then return -dy,  dx
    elseif dir == 6 then return  dy, -dx
    else return dx, dy -- dir == 8
    end
  end

  local function th_coords(tx, ty)
    local mid_x = long * 8
    local mid_y = deep * 8

    tx, ty = dd_coords(tx - mid_x, ty - mid_y)

    if dir == 4 or dir == 6 then mid_x,mid_y = mid_y,mid_x end

    tx, ty = mid_x + tx, mid_y + ty

    local bx = x + int(tx / 64)
    local by = y + int(ty / 64)

    local dx = (tx % 64) - 32
    local dy = (ty % 64) - 32

    return bx,by, dx,dy
  end

  local function skin_val(key)
    local V = skin[key]
    if not V then V = theme[key] end
    if not V then
      error("Bad fab/skin combo: missing entry for " .. key)
    end
    return V
  end

  local function parm_val(key)
    local V = parm[key]
    if not V then V = c.rmodel[key] end
    if not V then
      error("Bad fab/parameters: missing value for " .. key)
    end
    return V
  end

  local function what_h_ref(base, rel, h)

    local result = base

    if rel then
      if not parm[rel] then
        error("Missing f/c relative value: " .. rel)
      end
      result = parm[rel]
    end

    if h then result = result + h end

    return result
  end

  local function what_tex(base, key)
    if skin[key] then return skin[key] end
    if parm[key] then return parm[key] end

    if skin[base] then return skin[base] end
    if not theme[base] then
      error("Unknown texture ref in prefab: " .. key)
    end
    return theme[base]
  end

  local function what_thing(name)
    if skin[name] then return skin[name] end
    if parm[name] then return parm[name] end

    error("Unknown thing ref in prefab: " .. name)
  end

  local function compile_element(elem)

    local sec

    if elem.solid then
      sec = { solid=what_tex("wall", elem.solid) }
    else
      sec = copy_block(c.rmodel)

      sec.f_h = what_h_ref(sec.f_h, elem.f_rel, elem.f_h)
      sec.c_h = what_h_ref(sec.c_h, elem.c_rel, elem.c_h)

      sec.f_tex = what_tex("floor",elem.f_tex)
      sec.c_tex = what_tex("ceil", elem.c_tex)

      sec.l_tex = what_tex("wall", elem.l_tex)
      sec.u_tex = what_tex("wall", elem.u_tex)

      if elem.x_offset then sec.x_offset = elem.x_offset end
      if elem.y_offset then sec.y_offset = elem.y_offset end

      if elem.l_peg then sec.l_peg = elem.l_peg end
      if elem.u_peg then sec.u_peg = elem.u_peg end

      if elem.kind then sec[elem.kind] = parm_val(elem.kind) end
      if elem.tag  then sec.tag = parm_val("tag") end

      if elem.kind == "door_kind" then sec.door_dir = parm.door_dir end

      if elem.light then sec.light = elem.light
      elseif elem.light_add then sec.light = sec.light + elem.light_add
      end
    end

    -- handle overrides

    for i = 1,9 do
      local OV = elem[i]
      if OV then
        OV = copy_block(OV)  -- don't modify the prefab!

        if OV.l_tex and skin[OV.l_tex] then OV.l_tex = skin[OV.l_tex] end
        if OV.u_tex and skin[OV.u_tex] then OV.u_tex = skin[OV.u_tex] end
        if OV.f_tex and skin[OV.f_tex] then OV.f_tex = skin[OV.f_tex] end
        if OV.c_tex and skin[OV.c_tex] then OV.c_tex = skin[OV.c_tex] end

        if OV.dx or OV.dy then
          OV.dx, OV.dy = dd_coords(OV.dx or 0, OV.dy or 0)

          -- ensure that the writer doesn't swallow up the block
          -- (which would lose the vertex we want to move)
          if not sec.mark then
            sec.mark = allocate_mark(p)
          end
        end

        local s_dir = FAB_DIRECTION_MAP[dir + sel(mirror_x,10,0)][i]
        assert(s_dir)

        sec[s_dir] = OV
      end
    end

    return sec
  end

  local ROOM = c.rmodel
  local WALL = { solid=what_tex("wall", "wall") }

  -- cache for compiled elements
  local cache = {}

  for ey = 1,deep do for ex = 1,long do
    local fx, fy = f_coords(ex,ey)

    local e = string.sub(fab.structure[deep+1-ey], ex, ex)

    if e == " " then
      -- do nothing
    else
      local sec, elem

      if e == "#" then
        sec = WALL
      elseif e == "." then
        sec = ROOM
      else
        elem = fab.elements[e]

        if not elem then
          error("Unknown element '" .. e .. "' in Prefab")
        end

        if not cache[e] then
          cache[e] = compile_element(elem)
        end

        sec = cache[e]
      end

      if fab.scale == 64 then
        fill(p,c, fx,fy, fx,fy, sec)
      else
        frag_fill(p,c, fx,fy, fx,fy, sec)
      end

      if elem and elem.thing then
        local bx, by
        if fab.scale == 64 then
          bx,by = fx,fy
        else
          -- FIXME: offsets
          bx = div_mod(fx, FW)
          by = div_mod(fy, FH)
        end

        add_thing(p, c, bx,by, what_thing(elem.thing), false, elem.angle)
      end
    end
  end end

  -- add the final touches: things

  if fab.things then
    for zzz,tdef in ipairs(fab.things) do

      local bx,by, dx,dy = th_coords(tdef.x, tdef.y)

      -- FIXME: blocking
      local th = add_thing(p, c, bx,by, what_thing(tdef.kind), false)

      th.dx = dx
      th.dy = dy
    end
  end
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

  local wall_tex = b_theme.wall
  local track_tex = door_info.track or THEME.mats.TRACK.wall
  local door_tex = door_info.wall
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
                 f_tex = door_info.frame_floor or THEME.mats.DOOR_FRAME.floor,
                 c_tex = door_info.ceil        or THEME.mats.DOOR_FRAME.floor,
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
                    c_tex = door_info.frame_ceil or THEME.mats.DOOR_FRAME.ceil,
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
  local door_tex = door_info.wall
  local key_tex  = door_info.wall
  local track_tex = door_info.track or THEME.mats.TRACK.wall

  local DOOR = { f_h = z+8, c_h = z+8,
                 f_tex = door_info.frame_floor or THEME.mats.DOOR_FRAME.floor,
                 c_tex = door_info.ceil        or THEME.mats.DOOR_FRAME.floor,
                 light = 255,
                 door_kind = 1,
                 l_tex = theme.wall,
                 u_tex = door_tex,
                 [dir]  = { u_peg="bottom" }, [10-dir]  = { u_peg="bottom" },
                 [adir] = { l_peg="bottom" }, [10-adir] = { l_peg="bottom" }, -- TRACK
               }

  local STEP = { f_h = z+8, c_h = z+8+high,
                    f_tex = DOOR.f_tex,
                    c_tex = door_info.frame_ceil or DOOR.f_tex,
                    light=255,
                    l_tex = door_info.step or theme.step or THEME.mats.STEP.wall,
                    u_tex = wall_tex,
                    [dir] = { l_peg="top" },
                    [10-dir] = { l_peg="top" },
                }

  local SIGN
  
  if theme.sign then
    SIGN = { f_h = z+8, c_h = z+8+high-16,
               f_tex = STEP.f_tex, c_tex = theme.sign_ceil,
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

  if door_info.frame_wall then

    -- align inner sides y_offset with outside wall
    local y_diff = link_other(link, c).ceil_h - STEP.c_h
    frag_fill(p,c, fx+sx-ax, fy+sy-ay, fx+sx-ax+dx*7, fy+sy-ay+dy*7,
      { solid=wall_tex, [adir]={ l_tex=door_info.frame_wall, y_offset=y_diff }} )
    frag_fill(p,c, fx+ex+ax, fy+ey+ay, fx+ex+ax+dx*7, fy+ey+ay+dy*7,
      { solid=wall_tex, [10-adir]={ l_tex=door_info.frame_wall, y_offset=y_diff }} )
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
function B_exit_hole(p,c, K,kx,ky, sec)

  assert(K and sec)

  local bx = K.x1
  local by = K.y1

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

        c_move_frag_corner(p,c, zx,zy,dir, want_x - cur_x, want_y - cur_y)
      end
    end
  end
end


--
-- Build a stair
--
-- (bx,by) is the lowest left corner (cf. B_prefab)
-- Z is the starting height
--
function B_stair(p, c, bx,by, z, dir, long, deep, step)

  local dx, dy = dir_to_delta(dir)
  local ax, ay = dir_to_across(dir)

  if (dir == 2 or dir == 4) then
    bx,by = bx-(deep-1)*dx, by-(deep-1)*dy
  end

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

    local sec = copy_block_with_new(c.rmodel, -- !!!! FIXME: K.rmodel
    {
      f_h = z,
      f_tex = c.theme.step_floor, -- might be nil (=> rmodel.f_tex)

      [out_dir] = { l_tex=c.theme.step, l_peg="top" },
    })

    frag_fill(p,c, fx, fy, fx+zx, fy+zy, sec)

    fx = fx + dx; fy = fy + dy; z = z + step
  end
end


--
-- Build a lift
--
-- Z is the starting height
--
function B_lift(p, c, bx,by, z, dir, long, deep)

  local dx, dy = dir_to_delta(dir)
  local ax, ay = dir_to_across(dir)

  if (dir == 2 or dir == 4) then
    bx,by = bx-(deep-1)*dx, by-(deep-1)*dy
  end

  local LIFT = copy_block_with_new(c.rmodel,
  {
    f_h = z,
    f_tex = c.theme.lift_floor or THEME.mats.LIFT.floor,
    l_tex = c.theme.lift or THEME.mats.LIFT.wall,

    lift_kind = 123,  -- 62 for slower kind
    lift_walk = 120,  -- 88 for slower kind

    tag = allocate_tag(p),

    [2] = { l_peg="top" }, [4] = { l_peg="top" },
    [6] = { l_peg="top" }, [8] = { l_peg="top" },
  })

  fill(p,c, bx, by,
       bx + (long-1) * ax + (deep-1) * dx,
       by + (long-1) * ay + (deep-1) * dy, LIFT)
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

  local BASE = copy_block_with_new(c.rmodel,
  {
    f_h = z, near_switch = true,
  })

  frag_fill(p,c, fx+1,fy+1, fx+FW,fy+FH, BASE)

  local SWITCH = copy_block_with_new(c.rmodel,
  {
    f_h = z + 64,

    f_tex = THEME.mats.METAL.floor,
    l_tex = info.switch,

    switch_kind = kind,
    switch_tag  = tag,
  })

  do
    local tex_h = 128  -- FIXME: assumption !!!
    local y_ofs = tex_h - (SWITCH.c_h - z)

    for side = 2,8,2 do
      SWITCH[side] = { l_peg="bottom", y_offset=y_ofs }
    end
  end

  local sx,sy, ex,ey = side_coords(side, 1,1, FW,FH)

  frag_fill(p,c, fx+sx,fy+sy, fx+ex,fy+ey, SWITCH)
end


function B_wall_switch(p,c, x,y,z, side, long, sw_info, kind, tag)

  assert(long == 2 or long == 3)

  local ax, ay = dir_to_across(side)

  if long == 3 then x,y = x-ax, y-ay end

  local fx = (x - 1) * FW
  local fy = (y - 1) * FH

  frag_fill(p,c, fx+1,fy+1, fx+(long-1)*ax*FW+FW,fy+(long-1)*ay*FH+FH, { solid=c.theme.void })

  local GAP =
  {
    f_h = z,
    c_h = z + 64,
    f_tex = c.rmodel.f_tex,
    c_tex = c.theme.arch_ceil or c.rmodel.f_tex, -- SKY is no good
    light = 224,

    l_tex = c.theme.void,
    u_tex = c.theme.void,
    near_switch = true,
  }

  local sx,sy, ex,ey = side_coords(side, 1,1, FW,FH)
  local dx,dy = dir_to_delta(10-side)

  local pos = (long - 1) * 2

  sx,sy = sx + pos*ax, sy + pos*ay
  ex,ey = ex + pos*ax, ey + pos*ay

  frag_fill(p,c, fx+sx,fy+sy, fx+ex,fy+ey, GAP)

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

  local SWITCH =
  {
    solid = sw_info.switch,

    switch_kind = kind,
    switch_tag = tag,

    [side] = { l_peg="bottom" } 
  } 

  frag_fill(p,c, fx+sx,fy+sy, fx+ex,fy+ey, SWITCH);
end


function B_flush_switch(p,c, x,y,z, side, sw_info, kind, tag)

  local ax, ay = dir_to_across(side)

  local flu1 = c.theme.flush_left
  local flu2 = c.theme.flush_right

  if (side == 4) or (side == 8) then
    flu1, flu2 = flu2, flu1
  end

  fill(p,c, x-ax,y-ay, x-ax,y-ay,
       { solid = flu1 or c.theme.void, [side] = {l_peg="bottom"} })

  fill(p,c, x+ax,y+ay, x+ax,y+ay,
       { solid = flu2 or c.theme.void, [side] = {l_peg="bottom"} })

  local SWITCH =
  {
    solid = sw_info.switch,
    switch_kind = kind,
    switch_tag = tag,

    [side] = {l_peg="bottom"} 
  } 

  fill(p,c, x,y, x,y, SWITCH);
end


--
-- Build a pedestal (items, players)
-- 
function B_pedestal(p, c, x, y, base, info, overrides)
 
  local PEDESTAL = copy_block_with_new(base,
  {
    f_h   = base.f_h + info.h,
    f_tex = info.floor,
    l_tex = info.wall,
  })

  assert((PEDESTAL.c_h - PEDESTAL.f_h) >= 64)

  fill(p,c, x,y, x,y, PEDESTAL, overrides)
end


function B_double_pedestal(p, c, bx, by, base, ped_info, overrides)
 
  local OUTER =
  {
    f_h   = ped_info.h + base.f_h,
    f_tex = ped_info.floor,
    l_tex = ped_info.wall,
    light = ped_info.light,

    c_h   = c.rmodel.c_h - ped_info.h,
    c_tex = ped_info.floor,
    u_tex = ped_info.wall,

    kind  = ped_info.glow and 8 -- GLOW TYPE  (FIXME)
  }

  local INNER =
  {
    f_h   = ped_info.h2 + base.f_h,
    f_tex = ped_info.floor2,
    l_tex = ped_info.wall2,
    light = ped_info.light2,

    c_h   = c.rmodel.c_h - ped_info.h2,
    c_tex = ped_info.floor2,
    u_tex = ped_info.wall2,

    kind = ped_info.glow2 and 8 -- GLOW TYPE  (FIXME)
  }

  if c.theme.outdoor then
    OUTER.c_h   = c.rmodel.c_h
    OUTER.c_tex = c.rmodel.c_tex

    INNER.c_h   = c.rmodel.c_h
    INNER.c_tex = c.rmodel.c_tex
  end

  assert((OUTER.c_h - OUTER.f_h) >= 64)
  assert((INNER.c_h - INNER.f_h) >= 64)

  local fx = (bx - 1) * FW
  local fy = (by - 1) * FH

  frag_fill(p,c, fx+1,fy+1, fx+4,fy+4, OUTER, overrides)

  if ped_info.rotate2 then
    frag_fill(p,c, fx+2,fy+2, fx+2,fy+2, INNER)

    c_move_frag_corner(p,c, fx+2,fy+2, 1, 16, -6)
    c_move_frag_corner(p,c, fx+2,fy+2, 3, 22, 16)
    c_move_frag_corner(p,c, fx+2,fy+2, 7, -6,  0)
    c_move_frag_corner(p,c, fx+2,fy+2, 9,  0, 22)
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
function B_void_pic(p,c, K,kx,ky, pic, cuts)

  local z = (c.c_min + c.f_max) / 2
  local h = pic.h or (c.c_min - c.f_max - 32)

  local z1 = z-h/2
  local z2 = z+h/2

  local fx = (K.x1 - 1) * FW
  local fy = (K.y1 - 1) * FH

  frag_fill(p,c, fx+1,fy+1, fx+3*FW,fy+3*FH, { solid=c.theme.wall })

  local INNER =
  {
    solid = pic.wall,
    
    x_offset = pic.x_offset,
    y_offset = pic.y_offset,
  }
  assert(INNER.solid)

  frag_fill(p,c, fx+2,fy+2, fx+3*FW-1,fy+3*FH-1, INNER)

  local CUTOUT = copy_block_with_new(c.rmodel,
  {
    f_h = z1,
    c_h = z2,
    f_tex = c.theme.arch_floor, -- may be nil (=> rmodel.f_tex)
    c_tex = c.theme.arch_ceil  or c.rmodel.f_tex, -- SKY is no good
  })

  if cuts >= 3 or pic.glow then  -- FIXME: better way to decide
    CUTOUT.light = 255
    CUTOUT.kind  = 8  -- GLOW TYPE  (FIXME)
  end

  for side = 2,8,2 do

    local ax,ay = dir_to_across(side)
    local dx,dy = dir_to_delta(side)

    local sx,sy, ex,ey = side_coords(side, 1,1, FW*3, FH*3)

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

    y_offset = 128 - (K.rmodel.c_h - K.rmodel.f_h)
  }

  fill(p,c, bx, by, bx, by, PILLAR)
end

function B_crate(p,c, crate_info, base, kx,ky, bx,by)

  local K = c.chunks[kx][ky]

  local CRATE = copy_block_with_new(base,
  {
    f_h   = K.rmodel.f_h + crate_info.h,
    f_tex = crate_info.floor,
    l_tex = crate_info.wall,
    is_cage = true,  -- don't put monsters/pickups here
  })

  CRATE.c_h = math.max(base.c_h, CRATE.f_h)

  -- don't damage player if chunk is lava/nukage/etc
  CRATE.kind = nil

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
  if K.rmodel.c_h < K.rmodel.f_h+192 then
    rail = THEME.rails["r_1"]  -- FIXME: want "short" rail
  else
    rail = get_rand_rail()
  end
  assert(rail)

  local kind = sel(kx==2 and ky==2, "middle_cage", "pillar_cage")

  local z, open_top = cage_select_height(p,c, kind, theme,rail, K.rmodel.f_h,K.rmodel.c_h)

  if kx==2 and ky==2 and dual_odds(c.theme.outdoor, 90, 20) then
    open_top = true
  end

  local CAGE = copy_block_with_new(K.rmodel,
  {
    f_h   = z,
    f_tex = theme.floor,
    l_tex = theme.wall,
    u_tex = theme.wall,
    rail  = rail.wall,
    is_cage = true,
  })

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
function B_big_cage(p,c, theme, K,kx,ky)

  local bx, by = K.x1, K.y1

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

  local CAGE = copy_block_with_new(K.rmodel,
  {
    f_h   = z,
    f_tex = theme.floor,
    l_tex = theme.wall,
    u_tex = theme.wall,
    rail  = rail.wall,   -- FIXME: why here and down there???
    is_cage = true,
  })

  if not open_top then
    CAGE.c_h = CAGE.f_h + rail.h
    CAGE.c_tex = theme.ceil
    CAGE.light = 176
  end

  for x = 0,2 do for y = 0,2 do

    local overrides = {}
    if x == 0 then overrides[4] = { rail=rail.wall } end
    if x == 2 then overrides[6] = { rail=rail.wall } end
    if y == 0 then overrides[2] = { rail=rail.wall } end
    if y == 2 then overrides[8] = { rail=rail.wall } end

    fill(p,c, bx+x,by+y, bx+x,by+y, CAGE, overrides)
  end end

  local spot = {c=c, x=bx, y=by, double=true, dx=32, dy=32}
  if kx==2 and ky==2 then spot.different = true end

  add_cage_spot(p,c, spot)
end

--
-- Build a hidden monster closet
--
function B_monster_closet(p,c, K,kx,ky, z, tag)

  local bx, by = K.x1, K.y1

  local INNER = copy_block_with_new(c.rmodel,
  {
    f_h = z,

    --!! c_tex = c.theme.arch_ceil or c.rmodel.f_tex,

    l_tex = c.theme.void,
    u_tex = c.theme.void,

    is_cage = true,
  })

  local OUTER = copy_block_with_new(INNER,
  {
    c_h   = INNER.f_h,
    c_tex = c.theme.arch_ceil or INNER.f_tex,
    tag   = tag,
  })

  local fx = (bx - 1) * FW
  local fy = (by - 1) * FH

  frag_fill(p,c, fx+1,fy+1, fx+3*FW,fy+3*FH, OUTER);
  frag_fill(p,c, fx+2,fy+2, fx+3*FW-1,fy+3*FH-1, INNER)

  return { c=c, x=bx, y=by, double=true, dx=32, dy=32 }
end


function B_arch(p,c, bx,by, side,long, theme)

  local dx,dy = dir_to_delta(side)
  local ax,ay = dir_to_across(side)

  local ARCH = copy_block(c.rmodel)

  if not c.theme.outdoor then
    ARCH.c_h = ARCH.f_h + 96
  end

  local WALL = { solid=theme.wall }

  local fx1 = (bx - 1) * FW + 1
  local fy1 = (by - 1) * FH + 1

  local fx2 = fx1 + ax * FW * long - 1
  local fy2 = fy1 + ay * FH * long - 1

  frag_fill(p,c, fx1,fy1, fx2,fy2, WALL)

  local T = 2

  frag_fill(p,c, fx1+ax*T,fy1+ay*T, fx2-ax*T,fy2-ay*T, ARCH)
end


--
-- Build a scenic vista!
--
-- The 'kind' value can be: "solid", "frame", "open", "wire"
--
function B_vista(p,c, x1,y1, x2,y2, long,deep, side, theme,kind)

if false then
gap_fill(p,c, x1,y1, x2,y2, c.rmodel,
{ f_tex="LAVA1", kind=8 })

if (c.x==2 or c.x==3) and c.y==4 then
  add_thing(p, c, x1, y1, "red_torch", false)
con.printf("B_vista: blocks (%d,%d) to (%d,%d)\n",
x1,y1, x2,y2)
end

return
end

  local other = neighbour_by_side(p,c,side)
  assert(other)

---###  local x1,y1, x2,y2 = side_coords(side, 1,1, BW,BH)

  local dx,dy = dir_to_delta(side)
  local ax,ay = dir_to_across(side)

---###  x1,y1 = c.bx1-1 + (x1+ax*3+dx), c.by1-1 + (y1+ay*3+dy)
---###  x2,y2 = c.bx1-1 + (x2-ax*3+dx), c.by1-1 + (y2-ay*3+dy)

--[[
  local ARCH = copy_block(c.rmodel)

  ARCH.l_tex = theme.wall
  ARCH.u_tex = theme.wall

  if not other.theme.outdoor then
    ARCH.c_tex = sel(theme.outdoor, theme.floor, theme.ceil)
  end

  if ARCH.c_tex ~= THEME.SKY_TEX then
    ARCH.c_h = ARCH.f_h + 96
  end

  if kind ~= "solid" then
    ARCH.light = int((c.rmodel.light+other.rmodel.light)/2)
  end

  local fx1 = (x1 - 1) * FW + 1
  local fy1 = (y1 - 1) * FH + 1

  local fx2 = x2 * FW
  local fy2 = y2 * FH

  frag_fill(p,c, fx1,fy1, fx2,fy2, sel(ARCH.c_tex == THEME.SKY_TEX, ARCH, { solid=ARCH.l_tex }))
  frag_fill(p,c, fx1+ax,fy1+ay, fx2-ax,fy2-ay, ARCH)
--]]


  local ROOM   = copy_block(c.rmodel)
  local WINDOW = copy_block(c.rmodel)

  ROOM.l_tex = theme.wall
  ROOM.u_tex = theme.wall
  ROOM.c_tex = theme.ceil

  WINDOW.l_tex = theme.wall
  WINDOW.u_tex = theme.wall
  WINDOW.c_tex = theme.ceil

  ROOM.light   = other.rmodel.light
  WINDOW.light = other.rmodel.light

  WINDOW.f_h = ROOM.f_h + 32

  if kind == "open" or kind == "wire" then
    ROOM.c_h   = other.rmodel.c_h
    ROOM.c_tex = other.theme.ceil
  
    WINDOW.c_h   = other.rmodel.c_h
    WINDOW.c_tex = other.theme.ceil

  elseif kind == "frame" then
    ROOM.c_h   = other.rmodel.c_h
    ROOM.c_tex = other.theme.ceil
  
    WINDOW.c_h = ROOM.c_h - 24
    WINDOW.c_tex = sel(theme.outdoor, theme.floor, theme.ceil)
    WINDOW.light = other.rmodel.light - 16

  else -- "solid"
    local h = rand_index_by_probs { 20, 80, 20, 40 }
    ROOM.c_h   = ROOM.f_h + 96 + (h-1)*32
    ROOM.c_tex = sel(theme.outdoor, theme.floor, theme.ceil)

    if ROOM.c_h > other.sky_h then
       ROOM.c_h = math.max(other.sky_h, ROOM.f_h + 96)
    end

    WINDOW.c_h = ROOM.f_h + 96
    WINDOW.c_tex = sel(theme.outdoor, theme.floor, theme.ceil)

    ROOM.light   = other.rmodel.light - 32
    WINDOW.light = other.rmodel.light - 16
  end

  WINDOW.impassible = true  -- FIXME

  -- save ROOM for later
  other.vista_room = ROOM

--[[
  x1,y1 = x1+dx*1, y1+dy*1
  x2,y2 = x2+dx*deep, y2+dy*deep

  if x1 > x2 then x1,x2 = x2,x1 end
  if y1 > y2 then y1,y2 = y2,y1 end
--]]

  fx1 = (x1 - 1) * FW + 1
  fy1 = (y1 - 1) * FH + 1

  fx2 = x2 * FW
  fy2 = y2 * FH

  local px1,py1, px2,py2 = side_coords(side,    fx1,fy1, fx2,fy2)
  local wx1,wy1, wx2,wy2 = side_coords(10-side, fx1,fy1, fx2,fy2)


  if kind == "wire" then

    local rail = get_rand_rail()

    local curved = true
    local far_x, far_y, far_corner

        if side == 4 then far_x, far_y, far_corner = 0, 0, 7
    elseif side == 2 then far_x, far_y, far_corner = 0, 0, 3
    elseif side == 8 then far_x, far_y, far_corner = 0, (y2-y1), 9
    elseif side == 6 then far_x, far_y, far_corner = (x2-x1), 0, 9
    end

    for x = 0,(x2-x1) do
      for y = 0,(y2-y1) do

        local overrides = {}

        if x == 0       then overrides[4] = { rail=rail.wall } end
        if x == (x2-x1) then overrides[6] = { rail=rail.wall } end
        if y == 0       then overrides[2] = { rail=rail.wall } end
        if y == (y2-y1) then overrides[8] = { rail=rail.wall } end

        -- don't block the entryway
        overrides[10-side] = nil

        -- curve ball!
        if curved then
          if (x == far_x and y == far_y) or
             (x == (far_x+ax) and y == (far_y+ay))
          then
            -- 48 is the magical distance to align the railing
            overrides[far_corner] = { dx=(dx*48), dy=(dy*48) }
            overrides.mark = allocate_mark(p)
          end  
        end

        fill(p,c, x1+x,y1+y, x1+x,y1+y, ROOM, overrides)
      end
    end

  else -- solid, frame or open
  
    frag_fill(p,c, fx1,fy1, fx2,fy2, WINDOW)
    frag_fill(p,c, fx1+1,fy1+1, fx2-1,fy2-1, ROOM)

    --- walkway ---

    frag_fill(p,c, wx1+ax,wy1+ay, wx2-ax,wy2-ay, ROOM)
  end


  --- pillars ---
  if kind == "solid" or kind == "frame" then

    local support = theme.wall  -- FIXME: "SUPPORT2"
    
    frag_fill(p,c, px1,py1, px1,py1, { solid=support })
    frag_fill(p,c, px2,py2, px2,py2, { solid=support })


    if false then  -- FIXME
      px1 = int((px1+wx1)/2)
      py1 = int((py1+wy1)/2)
      px2 = int((px2+wx2)/2)
      py2 = int((py2+wy2)/2)

      frag_fill(p,c, px1,py1, px1,py1, { solid=support })
      frag_fill(p,c, px2,py2, px2,py2, { solid=support })
    end
  end 


  -- rest of chunk in other room
  if false then
    local extra = 3 - (deep % 3)

    if side < 5 then
      x1,y1 = x1+dx*extra, y1+dy*extra
    else
      x2,y2 = x2+dx*extra, y2+dy*extra
    end

    gap_fill(p,c, x1,y1, x2,y2, other.rmodel)
  end

  -- FIXME !!! add spots to room
  -- return { c=c, x=x1+dx, y=y1+dy, double=true, dx=32, dy=32 }
end

--
-- create a deathmatch exit room
--
-- FIXME: it always faces south
--
function B_deathmatch_exit(p,c, K,kx,ky)

  local theme = p.exit_theme

  local x1, y1 = K.x1, K.y1
  local x2, y2 = K.x2, K.y2

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
    f_tex = door_info.frame_floor or STEP.f_tex,
    c_tex = door_info.ceil        or STEP.f_tex,
    light = 255,

    l_tex = c.rmodel.l_tex,
    u_tex = door_info.wall,
    door_kind = 1,

    [2] = { u_peg="bottom" }, [8] = { u_peg="bottom" },
    [4] = { l_peg="bottom" }, [6] = { l_peg="bottom" }, -- TRACK
  }

  frag_fill(p,c, fx+4,fy+2, fx+9,fy+3, { solid=THEME.mats.TRACK.wall })
  frag_fill(p,c, fx+5,fy+2, fx+8,fy+3, DOOR)

  local SWITCH =
  {
    solid = theme.switch.switch,
    switch_kind = 11,

    [2] = { l_peg="bottom" }, [8] = { l_peg="bottom" },
    [4] = { l_peg="bottom" }, [6] = { l_peg="bottom" },
  }

  frag_fill(p,c, fx+5,fy+11, fx+8,fy+12, SWITCH)
end

function B_exit_elevator(p, c, x, y, side)

  fab = PREFABS["WOLF_ELEVATOR"]
  assert(fab)
  local parm =
  {
    door_kind = "door_elevator", door_dir = side,
  }
  local skin =
  {
    elevator = 21, front = 14,
  }

  local dir = 10-side
  -- FIXME: generalise this
  if side == 2 then x=x-1
  elseif side == 8 then x=x-1; y=y-fab.deep+1
  elseif side == 4 then y=y-1
  elseif side == 6 then x=x-fab.deep+1; y=y-1
  end

  B_prefab(p, c, fab, skin, parm, c.theme, x, y, dir)
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

  c.rmodel =
  {
    f_h=c.floor_h,
    f_tex=c.theme.floor,
    l_tex=c.theme.wall,

    c_h=c.ceil_h,
    c_tex=c.theme.ceil,
    u_tex=c.theme.wall,

    light=c.light,

    floor_code=c.floor_code,
  }

  if not c.rmodel.light then
    c.rmodel.light = sel(c.theme.outdoor, 192, 144)
  end

  c.mark = allocate_mark(p)
end

function make_chunks(p)

  local K_BORD_PROBS = { 0, 60, 90, 12, 3 }

  local function create_chunks(c)

    local cell_w = c.bx2 - c.bx1 + 1
    local cell_h = c.by2 - c.by1 + 1

    assert(cell_w >= THEME.cell_min_size)
    assert(cell_h >= THEME.cell_min_size)

    c.chunks = array_2D(3, 3)

    -- decide depths of each side
    local L, R, T, B
    local M, N

    if cell_w < 6 then
      L = 1
      R = 1
      M = cell_w - L - R
    else
      repeat
        L = rand_index_by_probs(K_BORD_PROBS)
        R = rand_index_by_probs(K_BORD_PROBS)
        M = cell_w - L - R
      until M >= 2
    end

    if cell_h < 6 then
      T = 1
      B = 1
      N = cell_h - T - B
    else
      repeat
        T = rand_index_by_probs(K_BORD_PROBS)
        B = rand_index_by_probs(K_BORD_PROBS)
        N = cell_h - T - B
      until N >= 2
    end

    -- actually create the chunks

    for kx = 1,3 do for ky = 1,3 do
       local w  = sel(kx == 1, L, sel(kx == 2, M, R))
       local h  = sel(ky == 1, B, sel(ky == 2, N, T))

       local dx = sel(kx == 1, 0, sel(kx == 2, L, L+M))
       local dy = sel(ky == 1, 0, sel(ky == 2, B, B+N))

       c.chunks[kx][ky] =
       {
         kx=kx, ky=ky, w=w, h=h,

         x1 = c.bx1 + dx,
         y1 = c.by1 + dy,
         x2 = c.bx1 + dx + w-1,
         y2 = c.by1 + dy + h-1,

         empty=true
       }
    end end
  end
  
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


  local function set_link_coords(c, side, link)
    
    local D = c.border[side]
    assert(D)

    assert(link.long <= D.long)

    if link.where == "double" or link.where == "wide" or
       link.long == D.long
    then
      link.x1, link.y1 = D.x1, D.y1
      link.x2, link.y2 = D.x2, D.y2

      return
    end

    local diff = D.long - link.long
    local pos

        if link.where == -2 then pos = 0
    elseif link.where == -1 then pos = int((diff+2)/4)
    elseif link.where ==  0 then pos = int(diff / 2)
    elseif link.where ==  1 then pos = diff - int((diff+2)/4)
    elseif link.where ==  2 then pos = diff
    else
      error("Bad where value: " .. tostring(link.where))
    end

    if link.where == 0 and (diff % 2) == 1 and (side < 5) then
      pos = pos + 1
    end

    local ax, ay = dir_to_across(side)

    link.x1 = D.x1 + pos * ax
    link.y1 = D.y1 + pos * ay

--con.printf("link_L:%d border_L:%d  where:%d -> pos:%d..%d\n",
--link.long, D.long, link.where, pos, pos + link.long - 1)

    pos = pos + link.long - 1

    link.x2 = D.x1 + pos * ax
    link.y2 = D.y1 + pos * ay

--con.printf("BORDER: (%d,%d) .. (%d,%d)\n", D.x1, D.y1, D.x2, D.y2)
--con.printf("LINK:   (%d,%d) .. (%d,%d)\n", link.x1, link.y1, link.x2, link.y2)

    assert(link.x1 >= D.x1); assert(link.y1 >= D.y1)
    assert(link.x2 <= D.x2); assert(link.y2 <= D.y2)
  end

  local function overlaps_chunk(K, x1,y1, x2,y2)

    if x2 < K.x1 or x1 > K.x2 then return false end
    if y2 < K.y1 or y1 > K.y2 then return false end

    return true
  end
  
  local function alloc_door_spot(c, side, link)

    local clasher
    local dx,dy = dir_to_delta(side)

    for kx = 1,3 do for ky = 1,3 do
      local K = c.chunks[kx][ky]

      if overlaps_chunk(K, link.x1-dx, link.y1-dy, link.x2-dx, link.y2-dy) then
--[[
con.printf("alloc_door_spot: overlap (%d,%d) [%d,%d] on side:%d\n",
c.x, c.y, kx, ky, side)
con.printf(">> K=(%d,%d,%d,%d) L=(%d,%d,%d,%d)\n",
K.x1,K.y1,K.x2,K.y2, link.x1-dx,link.y1-dy, link.x2-dx, link.y2-dy)
--]]
        if K.link then
--[[
con.printf("___ OLD LINK: (%d,%d)..(%d,%d)\n",
K.link.cells[1].x, K.link.cells[1].y,
K.link.cells[2].x, K.link.cells[2].y)
con.printf("___ NEW LINK: (%d,%d)..(%d,%d)\n",
link.cells[1].x, link.cells[1].y,
link.cells[2].x, link.cells[2].y)
--]]
          clasher = K.link
        else
          K.link = link
          K.empty = nil
        end
      end 
    end end

    return clasher

--[[ OLDIES BUT GOODIES...

    -- figure out which chunks are needed

    local kx, ky = side_to_chunk(side)
    local ax, ay = dir_to_across(side)

    assert(not c.chunks[kx][ky].link)

    if link.where == "double" then
      table.insert(coords, {x=kx+ax, y=ky+ay})
      table.insert(coords, {x=kx-ax, y=ky-ay})
      
      local no_void = c.closet[2] or c.closet[4] or c.closet[6] or c.closet[8]

      -- what shall we put in-between?
      local r = con.random() * 100
      local K
      if r < 40 then
        c.chunks[kx][ky] = new_chunk(c, kx,ky, "link",link)
      elseif r < 80 or no_void then
        c.chunks[kx][ky] = new_chunk(c, kx,ky, "room")
      else
        c.chunks[kx][ky] = new_chunk(c, kx,ky, "void")
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
        c.chunks[kx][ky] = new_chunk(c, kx,ky, "link",link )
      end
    end
    return not has_clash
--]]
  end

  local function clear_link_allocs(c)
    c.got_links = nil

    for kx = 1,3 do for ky = 1,3 do
      c.chunks[kx][ky].link  = nil
      c.chunks[kx][ky].empty = true
    end end
  end

  local function alloc_link_chunks(c, loop)

    -- last time was successful, nothing to do
    if c.got_links then return true end

    for side,L in pairs(c.link) do

      local clash_L = alloc_door_spot(c, side, L)

      if clash_L then

        con.debugf("CLASH (%d,%d) -> (%d,%d)  L:%s/%s  K:%s/%s\n",
          clash_L.cells[1].x, clash_L.cells[1].y,
          clash_L.cells[2].x, clash_L.cells[2].y,
          L.kind, L.where, clash_L.kind, clash_L.where)

        -- be fair about which link we will blame
        if rand_odds(50) then
          L = clash_L

          for i = 2,8,2 do
            if c.link[i] == L then
              side = i
              break
            end
          end
        end

        assert(c.link[side] == L)

        local other = link_other(L, c)

        -- reset the allocation in the offending cells
        clear_link_allocs(c)
        clear_link_allocs(other)

        -- choose a new place
        L.where = random_where(L, c.border[side])
        set_link_coords(c, side, L)

        if loop >= 512 then

          -- Emergency!! our options are to:
          --   1. reorganise chunks
          --   2. make links narrower
          --   3. remove falloffs/vistas

          if (loop % 8) < 3 then
            create_chunks(c)
          elseif (loop % 8) < 6 then
            L.long = 2
          elseif (L.kind == "vista") or (L.kind == "falloff") then
            c.link[side] = nil
            other.link[10-side] = nil
          end
        end

        return false
      end
    end

    c.got_links = true

    return true
  end


  local function add_travel_chunks(c)

    -- give each chunk a travel ID.  Touching chunks can
    -- merge the id's (choose lowest value).  After some
    -- iterations, the existence of multiple IDS means that
    -- we need to add extra chunks.

    -- These are shuffled to give better randomness of the
    -- grow algorithm.  They are re-used for efficiency.
    local SIDES  = { 2,4,6,8 }
    local KX_MAP = { 1,2,3 }
    local KY_MAP = { 1,2,3 }

    local function init()
      local chunk_list = {}
      
      for kx = 1,3 do for ky = 1,3 do
        local K = c.chunks[kx][ky]
        K.travel_id = ky*10 + kx
        if not K.empty then
          table.insert(chunk_list, { x=kx,y=ky })
        end
      end end
      
      return chunk_list
    end
    
    local function merge()
      for loop=1,12 do
        for kx = 1,3 do for ky = 1,3 do
          for side = 6,8,2 do
            local dx, dy = dir_to_delta(side)
            local nx, ny = kx+dx, ky+dy

            if valid_chunk(nx,ny) then
              local K1 = c.chunks[kx][ky]
              local K2 = c.chunks[nx][ny]

              if not K1.empty and not K2.empty then
                K1.travel_id = math.min(K1.travel_id, K2.travel_id)
                K2.travel_id = K1.travel_id
              end
            end
          end
        end end
      end
    end

    local function has_islands()
      local last
      for kx = 1,3 do for ky = 1,3 do
        local K = c.chunks[kx][ky]
        if K.empty then
          -- skip it
        elseif not last then last = K
        elseif K.travel_id ~= last.travel_id then 
          return true
        end
      end end
      return false
    end

    local function grow(chunk_list)
      
      local function grow_a_pair(K,kx,ky, N,nx,ny, bridge)

        assert(N.empty)
        N.empty = false

        if nx==2 and ny==2 and rand_odds(50) then
          N.room = true
        elseif K.vista then
          if bridge and bridge.link and not bridge.vista then
            N.link = bridge.link
          else
            N.room = true
          end
        else
          assert(K.link or K.room)
          N.link = K.link
          N.room = K.room
        end

        table.insert(chunk_list, { x=nx, y=ny })
      end

      -- look for the optimal solution: a "bridge" between two
      -- different groups.  Do it by studying the empty chunks.

      rand_shuffle(SIDES)
      rand_shuffle(KX_MAP)
      rand_shuffle(KY_MAP)

      for ix=1,3 do for iy=1,3 do
        local kx,ky = KX_MAP[ix], KY_MAP[iy]
        local K = c.chunks[kx][ky]

        if K.empty then
          local last_K, last_x, last_y

          for zzz,side in ipairs(SIDES) do
            local dx,dy = dir_to_delta(side)
            local nx,ny = kx+dx, ky+dy

            if valid_chunk(nx, ny) then
              local N = c.chunks[nx][ny]
              if not N.empty then
                if not last_K then
                  last_K, last_x, last_y = N, nx, ny
                elseif N.travel_id ~= last_K.travel_id then
                  -- FOUND ONE !!
                  con.debugf("Found travel bridge @ (%d,%d) [%d,%d]^%d\n", c.x,c.y, kx,ky,side)
                  if rand_odds(50) then
                    grow_a_pair(last_K,last_x,last_y, K,kx,ky, N)
                  else
                    grow_a_pair(N,nx,ny, K,kx,ky, last_K)
                  end
                  return true
                end
              end
            end

          end
        end
      end end

      -- failing that, grow a chunk at random

      for i = 1,#chunk_list do

        local kx,ky = chunk_list[i].x, chunk_list[i].y
        local K1 = c.chunks[kx][ky]
        assert(K1 and not K1.empty)

        for zzz,side in ipairs(SIDES) do
          local dx,dy = dir_to_delta(side)
          if valid_chunk(kx+dx, ky+dy) then
            local K2 = c.chunks[kx+dx][ky+dy]
            assert(K2)
        
            if K2.empty then
              grow_a_pair(K1,kx,ky, K2,kx+dx,ky+dy)
              return true
            end

          end
        end

        -- try next chunk in list...
      end

      error("add_travel_chunks: grow failed!")
    end

    --- add_travel_chunks ---

    if c.scenic then return end

    do
      local MID = c.chunks[2][2]

      if MID.empty and not c.hallway and
         (c == p.quests[1].first or c == c.quest.last or rand_odds(25))
      then
        MID.room = true
        MID.empty = nil
      end
    end
 
    chunk_list = init()

    assert(#chunk_list >= 1)

    merge()

    for loop=1,99 do
      if not has_islands() then break end
      
      rand_shuffle(chunk_list)
      rand_shuffle(SIDES)
      
      grow(chunk_list)
      merge()
    end
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
    local x1, y1, x2, y2 = side_coords(side, 1,1, KW,KH)

    local common
    local possible = true

    for x = x1,x2 do
      for y = y1,y2 do
        if not possible then break end
        
        local K = c.chunks[x][y]

        if not K then
          -- continue
        elseif K.vista then
          possible = false
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

    for kx = x1,x2 do
      for ky = y1,y2 do
        if not c.chunks[kx][ky] then
          c.chunks[kx][ky] = copy_chunk(c, kx, ky, common)
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
          c.chunks[nx][ny] = new_chunk(c, nx, ny, "room")
          return -- SUCCESS --
        end
      end
    end
  end

  local function void_it_up(c, kind)
    if not kind then kind = "void" end
    for kx = 1,3 do
      for ky = 1,3 do
        local K = c.chunks[kx][ky]
        if K.empty then
          K[kind] = true
          K.empty = nil
        end
      end
    end
  end

  local function try_add_special(c, kind)
    
    if kind == "liquid" then
      if not c.liquid then return end
      if c.is_exit and rand_odds(98) then return end
    end

    -- TODO: more cage themes...
    if kind == "cage" then
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

    c.chunks[p.x][p.y] = new_chunk(c, p.x, p.y, kind)
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
          con.printf("%s\n", table_to_str(c.chunks[kx][ky], 2))

          show_chunks(p)
        end

        con.debugf("CLOSET CHUNK @ (%d,%d) [%d,%d]\n", c.x, c.y, kx, ky)

        local K = new_chunk(c, kx,ky, "void")
        K.closet = true
        K.place = place

        c.chunks[kx][ky] = K
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
      c.chunks[kx][ky] = new_chunk(c, kx,ky, "room")
    elseif r < 12 then
      c.chunks[kx][ky] = new_chunk(c, kx,ky, "cage")
      c.smex_cage = true
    end

    void_it_up(c)
  end

  local function add_dm_exit(c)

    if c.chunks[1][3] then
      con.printf("WARNING: deathmatch exit stomped a chunk!\n")
    end

    local K = new_chunk(c, 1,3, "void")
    K.dm_exit = true
    K.dir = 2

    c.chunks[1][3] = K

    if not c.chunks[1][2] then
      c.chunks[1][2] = new_chunk(c, 1,2, "room")
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

    if c.scenic and c.vista_from then
      -- Bleh...
      if c.liquid and rand_odds(75) then
        void_it_up(c, "liquid")
      else
        void_it_up(c, "room")
      end
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

    for kx = 1,3 do for ky = 1,3 do
      local K = c.chunks[kx][ky]
      assert(K)

      if not K.rmodel then
        K.rmodel = copy_table(c.rmodel)

K.rmodel.light =
sel(kx==2 and ky==2, 176,
  sel(kx==2 or ky==2, 144, 112))
  
        if K.link then
          local other = link_other(K.link, c)

          if K.link.build == c or K.link.kind == "falloff" then
            -- no change
          elseif K.link.kind == "vista" then
            K.rmodel = copy_table(other.rmodel)
          else
            K.rmodel.f_h = other.rmodel.f_h
            K.rmodel.c_h = math.max(c.rmodel.c_h, other.rmodel.c_h) --FIXME (??)
          end

        elseif K.liquid then
          K.rmodel.f_h   = K.rmodel.f_h - 12
          K.rmodel.f_tex = c.liquid.floor
        end
      end
    end end
  end

  local function mark_vista_chunks(c)

    -- mark the chunks containing the intruder
    for kx = 1,3 do for ky = 1,3 do
      local K = c.chunks[kx][ky]
      if K.link and K.link.kind == "vista" and c ~= K.link.build then
        K.vista = true
      end
    end end
  end

  local function create_huge_vista(c)

    if not c.chunks[2][2].empty then return end

    local vista_x, vista_y

    local side_vistas   = 0
    local corner_vistas = 0
    
    for kx = 1,3 do for ky = 1,3 do
      local K = c.chunks[kx][ky]
      if K.vista then
        vista_x, vista_y = kx, ky
        if kx==2 or ky==2 then
          side_vistas = side_vistas + 1
        else
          corner_vistas = corner_vistas + 1
        end
      end
    end end

    if side_vistas ~= 1 or corner_vistas > 0 then return end

    con.debugf("Making HUGE VISTA @ (%d,%d)\n", c.x, c.y);

    local K = c.chunks[vista_x][vista_y]
    assert(K and K.vista)

    local N = c.chunks[2][2]

    N.link  = K.link
    N.vista = K.vista
    N.empty = nil

    K.link.shallow = nil
    K.link.huge = true
  end

  local function add_vista_environs(c)

    -- make sure the vista(s) have something to see

    for loop = 1,10 do
      for kx = 1,3 do for ky = 1,3 do
        local K = c.chunks[kx][ky]
        local near_vista = false
        local link_neighbour
        local room_neighbour

        if K.empty then
          for side = 1,9 do if side ~= 5 then
            local dx,dy = dir_to_delta(side)
            local nx,ny = kx+dx, ky+dy
            if valid_chunk(nx,ny) then
              local N = c.chunks[nx][ny]
              if N.vista then
                near_vista = true
              end

              if (side % 2) == 0 and not N.vista then
                if (kx==2 and ky==2) and rand_odds(50) then
                  room_neighbour = true
                elseif N.link then
                  link_neighbour  = N.link
                elseif N.room then
                  room_neighbour  = N.room
                end
              end
            end
          end end

          if near_vista then
            if room_neighbour then
              K.room = true
              K.empty = nil
            elseif link_neighbour then
              K.link = link_neighbour
              K.empty = nil
            end
          end
        end -- K.empty

      end end
    end
  end

  local function add_stairs(c)

    --> result: certain chunks have a "stair_dir" field.
    -->         Direction to neighbour chunk.  Stair/Lift will
    -->         be built inside that chunk.

    local function init_connx()

      for kx = 1,3 do for ky = 1,3 do
        local K = c.chunks[kx][ky]
        assert(K)

        K.stair = {}

        if K.room or (K.link and not K.vista) or K.liquid then
          K.connect_id = ky*10 + kx
        end
      end end
    end

    local function is_fully_connected()
      local last
      for kx = 1,3 do for ky = 1,3 do
        local K = c.chunks[kx][ky]
        if not K.connect_id then
          -- skip it
        elseif not last then last = K
        elseif K.connect_id ~= last.connect_id then 
          return false
        end
      end end
      return true
    end

    local function merge_connx()

      local function are_connected(K, N, dir)
        if math.abs(K.rmodel.f_h - N.rmodel.f_h) <= 16 then
          return true
        end
        if K.stair[dir] then return true end
        return false
      end

      for loop = 1,12 do
        for kx = 1,3 do for ky = 1,3 do
          local K1 = c.chunks[kx][ky]
          for dir = 6,8,2 do
            local dx,dy = dir_to_delta(dir)
            if valid_chunk(kx+dx,ky+dy) then
              local K2 = c.chunks[kx+dx][ky+dy]
              if K1.connect_id and K2.connect_id and are_connected(K1,K2, dir) then
                K1.connect_id = math.min(K1.connect_id, K2.connect_id)
                K2.connect_id = K1.connect_id
              end
            end
          end
        end end
      end
    end

    local function add_one_stair()

      -- find the best chunk pair to use

      local best_diff = 999999
      local coords = {}

      for kx = 1,3 do for ky = 1,3 do
        local K = c.chunks[kx][ky]

          for side = 6,8,2 do
            local dx,dy = dir_to_delta(side)

            if valid_chunk(kx+dx, ky+dy) then
              local N = c.chunks[kx+dx][ky+dy]
              if K.connect_id and N.connect_id and K.connect_id ~= N.connect_id then

                local diff = math.abs(K.rmodel.f_h - N.rmodel.f_h)
                assert(diff > 16)

                if diff < best_diff then
                  -- clear out the previous (worse) results
                  coords = {}
                  best_diff = diff
                end

                if diff == best_diff then
                  table.insert(coords, { x=kx, y=ky, side=side, K=K, N=N })
                end
            end
          end
        end
      end end

      if #coords == 0 then
        error("Cannot find stair position!")
      end

      rand_shuffle(coords)

      local loc = coords[1]

      local K1, K2, dir = loc.K, loc.N, loc.side

      assert(K1 and not K1.stair[dir])
      assert(K2 and not K2.stair[10-dir])

      local STAIR =
      {
        k1 = K1, k2 = K2, dir = dir, build = k1
      }

      K1.stair[dir] = STAIR
      K2.stair[10-dir] = STAIR
    end

    local function select_stair_spots()
      for kx=1,3 do for ky=1,3 do
        local K = c.chunks[kx][ky]
        K.stair_dir = nil  

        for side=2,8,2 do
          local stair = K.stair[side]
          if stair and stair.build == K then
            if K.stair_dir then return false end  --FAIL--
            K.stair_dir = side
          end
        end
      end end

      return true --OK--
    end

    local function shuffle_stair_builds()
      for kx=1,3 do for ky=1,3 do
        local K = c.chunks[kx][ky]
        for side=6,8,2 do
          local stair = K.stair[side]
          if stair then
            local chance = 50

            local deep1 = sel(side==6, stair.k1.w, stair.k1.h)
            local deep2 = sel(side==6, stair.k2.w, stair.k2.h)

            if deep1 > deep2 then chance = 90 end
            if deep1 < deep2 then chance = 10 end

            stair.build = rand_sel(chance, stair.k1, stair.k2)
          end
        end
      end end
    end


    --- add_stairs ---

    init_connx()

    for loop=1,99 do
      merge_connx()
      if is_fully_connected() then break end
con.debugf("CONNECT CHUNKS @ (%d,%d) loop: %d\n", c.x, c.y, loop)
      add_one_stair()
    end 

    for loop=1,99 do
      shuffle_stair_builds()
      if select_stair_spots() then break end
con.debugf("SELECT STAIR SPOTS @ (%d,%d) loop: %d\n", c.x, c.y, loop);
    end
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
           not (c.chunks[kx][ky].void or c.chunks[kx][ky].cage or
                c.chunks[kx][ky].quest or c.chunks[kx][ky].vista)
        then
          local score = k_dist(kx, ky)
          score = score + con.random() * 0.5
          if c.chunks[kx][ky].rmodel.f_h == c.rmodel.f_h then score = score + 1.7 end

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

  --==-- make_chunks --==--

  for zzz,cell in ipairs(p.all_cells) do
    create_chunks(cell)
  end

  for zzz,cell in ipairs(p.all_cells) do
    for side = 2,8,2 do
      local L = cell.link[side]
      if L and not L.where then
        L.where = random_where(L, cell.border[side])
        set_link_coords(cell, side, L)
      end
    end
  end


  -- allocate chunks based on entry/exit locations

  local clashes

  for loop=1,(512+80) do 
    clashes = 0

    for zzz,cell in ipairs(p.all_cells) do
      if not alloc_link_chunks(cell, loop) then
        clashes = clashes + 1
      end
    end

    con.debugf("MAKING CHUNKS: %d clashes (loop %d)\n", clashes, loop)

    if clashes == 0 then break end
  end

  if clashes > 0 then
    -- Shit!
    error("Unable to allocate link chunks!")
  end

  -- secondly, determine main walk areas

  for zzz,cell in ipairs(p.all_cells) do

    mark_vista_chunks(cell)
    create_huge_vista(cell)

    add_travel_chunks(cell)

    add_vista_environs(cell)

--!!!!  flesh_out_cell(cell)

    setup_chunk_rmodels(cell)

if (cell == p.quests[1].first or cell == cell.quest.last) then
        void_it_up(cell, "room")
else
        void_it_up(cell, "void")
end

    add_stairs(cell)
  end

-- !!!!  add_closet_chunks(cell)
end


function build_borders(p)

  local c

  local function setup_borders_and_corners(p)

    -- for each border and corner: decide on the type, the theme,
    -- and which cell is ultimately responsible for building it.

    local function border_theme(cells)
      assert(#cells >= 1)

      if #cells == 1 then return cells[1].theme end

      for zzz,c in ipairs(cells) do
        if c.is_exit then return c.theme end
      end

  --[[    for zzz,c in ipairs(cells) do
        if c.scenic == "solid" then return c.theme end
      end
  --]]
      local themes = {}
      local hall_num = 0

      for zzz,c in ipairs(cells) do
        if c.hallway then hall_num = hall_num + 1 end
        table.insert(themes, c.theme)
      end
    
      -- when some cells are hallways and some are not, we
      -- upgrade the hallways to their "outer" theme.

      if (hall_num > 0) and (#cells - hall_num > 0) then
        for idx = 1,#themes do
          if cells[idx].hallway then
            themes[idx] = cells[idx].quest.theme
          end
        end
      end

      -- when some cells are outdoor and some are indoor,
      -- remove the outdoor themes from consideration.

      local out_num = 0

      for zzz,T in ipairs(themes) do
        if T.outdoor then out_num = out_num + 1 end
      end
      
      if (out_num > 0) and (#themes - out_num > 0) then
        for idx = #themes,1,-1 do
          if themes[idx].outdoor then
            table.remove(themes, idx)
          end
        end
      end

      if #themes >= 2 then
        table.sort(themes, function(t1, t2) return t1.mat_pri < t2.mat_pri end)
      end

      return themes[1]
    end


    local function border_kind(c1, c2, side)

      if not c2 or c2.is_depot then
        if c1.theme.outdoor and THEME.caps.sky then return "sky" end
        return "solid"
      end

      if c1.scenic == "solid" or c2.scenic == "solid" then
        return "solid"
      end

      if c1.hallway or c2.hallway then return "solid" end

      -- TODO: sometimes allow it
      if c1.is_exit or c2.is_exit then return "solid" end

      if not THEME.caps.heights then return "solid" end

      if c1.border[side].window then return "window" end

  ---###    if link and (link.kind == "arch") and c1.theme == c2.theme and
  ---###       (c1.quest.parent or c1.quest) == (c2.quest.parent or c2.quest) and
  ---###       dual_odds(c1.theme.outdoor, 50, 33)
  ---###    then
  ---###       return "empty"
  ---###    end

      -- fencing anyone?   FIXME: move tests into Planner
      local diff_h = math.min(c1.ceil_h, c2.ceil_h) - math.max(c1.f_max, c2.f_max)

      if (c1.theme.outdoor == c2.theme.outdoor) and
         (not c1.is_exit  and not c2.is_exit) and
         (not c1.is_depot and not c2.is_depot) and diff_h > 64
      then
        if c1.scenic or c2.scenic then
          return "fence"
        end

        if dual_odds(c1.theme.outdoor, 60, 7) then
          return "fence"
        end
      end
   
      return "solid"
    end

    local function init_border(c, side)

      local D = c.border[side]
      if D.build then return end -- already done

      -- which cell actually builds the border is arbitrary, unless
      -- there is a link with the other cell
      if c.link[side] then
        D.build = c.link[side].build
      else
        D.build = c
      end

      local other = neighbour_by_side(p,c, side)

      D.theme = border_theme(D.cells)
      D.kind  = border_kind (c, other, side)
    end

    local function init_corner(c, side)

      local E = c.corner[side]
      if E.build then return end -- already done

      E.build = c
      E.theme = border_theme(E.cells)
      E.kind  = "solid"
    end

    --- setup_borders_and_corners ---

    for zzz,c in ipairs(p.all_cells) do

      for side = 1,9 do
        if c.border[side] then init_border(c, side) end
      end
      for side = 1,9,2 do
        if c.corner[side] then init_corner(c, side) end
      end
    end
  end

  local function build_real_link(link, side, double_who)

    local D = c.border[side]
    assert(D)

if THEME.caps.elevator_exits and link.is_exit then
local other = link_other(link, c)
B_exit_elevator(p, other, link.x1, link.y1, side)
return
end

if link.kind == "door" and THEME.caps.blocky_doors then
  local bit
  if link.quest and link.quest.kind == "key" then
    bit = THEME.key_bits[link.quest.item]
    assert(bit)
    assert(bit.kind_rep)
  end

  -- door sides
  local side_tex
  local ax,ay = dir_to_across(side)
  
  if bit and bit.lock_side then
    side_tex = bit.lock_side
  elseif not bit and D.theme.door_side then
    side_tex = D.theme.door_side
  end

  if side_tex then
    gap_fill(p, c, link.x1-ax, link.y1-ay, link.x1+ax, link.y1+ay,
      { solid=side_tex })
  end
  
  p.blocks[link.x1][link.y1] =
  {
    door_kind = (bit and bit.kind_rep) or "door",
    door_dir  = side,
    blocked = true,
  }
  return
end
if link.kind == "arch" and THEME.caps.blocky_doors then
  gap_fill(p,c, link.x1,link.y1, link.x2,link.y2,
    D.build.rmodel)
  return
end
if THEME.caps.blocky_doors then
  error("Cannot build " .. link.kind)
end


if link.kind == "arch" then --!!!!!
local fab = "ARCH" -- rand_element { "ARCH", "ARCH_ARCHED", "ARCH_TRUSS", "ARCH_BEAMS", "ARCH_RUSSIAN", "ARCH_CURVY" }
fab = PREFABS[fab]
assert(fab)
local parm =
{ floor = link.build.rmodel.f_h,
  ceil  = link.build.rmodel.c_h,
  door_top = math.min(link.build.rmodel.c_h-32, link.build.floor_h+128),
  door_kind = 1, tag = 0,

  frame_c = D.theme.floor
}
local skin =
{
--  wall="COMPBLUE",
--  frame="ROCK1", frame_c="RROCK13", -- frame_f="RROCK13",

  beam    = "WOOD1", beam_c = "FLAT5_2",
  support = "WOOD1", supp_u = "WOOD1", supp_c = "FLAT5_2",
  test_t = "lamp"
}

B_prefab(p,c, fab, skin, parm, D.theme, link.x1, link.y1, side)
return
end

if not (link.kind == "falloff" or link.kind == "vista") then --!!!!! TESTING
local door_info = THEME.doors[link.wide_door]
assert(door_info)
if not door_info.prefab then print(table_to_str(door_info)) end
assert(door_info.prefab)
local fab = PREFABS[door_info.prefab]
assert(fab)
local parm =
{ floor = link.build.rmodel.f_h,
  ceil  = link.build.rmodel.c_h,
  door_top = link.build.rmodel.f_h + door_info.h,
  door_kind = 1, tag = 0,
}
B_prefab(p,c, fab, door_info, parm, D.theme, link.x1, link.y1, side)
return
end

do
gap_fill(p, c, link.x1, link.y1, link.x2, link.y2,
copy_block_with_new(link.build.rmodel,
{ f_tex = "NUKAGE1" }))
return
end

    -- DIR here points to center of current cell
    local dir = 10-side  -- FIXME: remove

    assert (link.build == c)

    local other = link_other(link, c)
    assert(other)


    local b_theme = D.theme

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
      d_pos = where_to_block(where, long) --!!!!! MOVE
      d_max = d_max - (long-1)

      if (d_pos < d_min) then d_pos = d_min end
      if (d_pos > d_max) then d_pos = d_max end
    end

        if side == 2 then x,y = d_pos, 1
    elseif side == 8 then x,y = d_pos, BH
    elseif side == 4 then x,y =  1, d_pos
    elseif side == 6 then x,y = BW, d_pos
    end

    x = D.x1
    y = D.y1

    if (link.kind == "arch" or link.kind == "falloff") then

---###      if D.kind == "empty" then return end  -- no arch needed

      local ex, ey = x + ax*(long-1), y + ay*(long-1)
      local tex = b_theme.wall

      -- sometimes leave it empty
      if D.kind == "wire" then link.arch_rand = link.arch_rand * 4 end

      if link.kind == "arch" and link.where ~= "wide" and
        c.theme.outdoor == other.theme.outdoor and
        ((c.theme.outdoor and link.arch_rand < 50) or
         (not c.theme.outdoor and link.arch_rand < 10))
      then
        local sec = copy_block(c.rmodel)
sec.f_tex = "FWATER1"
        sec.l_tex = tex
        sec.u_tex = tex
        fill(p,c, x, y, ex, ey, sec)
        return
      end

      local arch = copy_block(c.rmodel)
      arch.c_h = math.min(c.ceil_h-32, other.ceil_h-32, c.floor_h+128)
      arch.f_tex = c.theme.arch_floor or c.rmodel.f_tex
      arch.c_tex = c.theme.arch_ceil  or arch.f_tex
arch.f_tex = "TLITE6_6"

      if (arch.c_h - arch.f_h) < 64 then
        arch.c_h = arch.f_h + 64
      end

      if c.hallway and other.hallway then
        arch.light = (c.rmodel.light + other.rmodel.light) / 2.0
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

        fill(p,c, x, y, ex+ax, ey+ay, { solid=tex })
      end

      arch.l_tex = tex
      arch.u_tex = tex

      fill(p,c, x, y, ex+ax, ey+ay, { solid=tex })
      fill(p,c, x+ax, y+ay, ex, ey, arch)

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

      B_exit_door(p,c, c.theme, link, x, y, c.floor_h, dir)

    elseif link.kind == "door" and link.quest and link.quest.kind == "switch" and
       THEME.switches[link.quest.item].bars
    then
      local info = THEME.switches[link.quest.item]
      local sec = copy_block_with_new(c.rmodel,
      {
        f_tex = b_theme.floor,
        c_tex = b_theme.ceil,
      })

      if not (c.theme.outdoor and other.theme.outdoor) then
        sec.c_h = sec.c_h - 32
        while sec.c_h > (sec.c_h+sec.f_h+128)/2 do
          sec.c_h = sec.c_h - 32
        end
        if b_theme.outdoor then sec.c_tex = b_theme.arch_ceil or sec.f_tex end
      end

      local bar = link.bar_size
      local tag = link.quest.tag + 1

      B_bars(p,c, x,y, math.min(dir,10-dir),long, bar,bar*2, info, sec,b_theme.wall, tag,true)

    elseif link.kind == "door" then

      local kind = link.wide_door

      if c.quest == other.quest
        and link.door_rand < sel(c.theme.outdoor or other.theme.outdoor, 10, 20)
      then
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

      B_door(p, c, link, b_theme, x, y, c.floor_h, dir,
             1 + int(info.w / 64), 1, info, door_kind, tag, key_tex)
    else
      error("build_link: bad kind: " .. tostring(link.kind))
    end
  end

  local function build_link(side)

    local link = c.link[side]
    if not (link and link.build == c) then return end

    if THEME.doors then
      link.narrow_door = random_door_kind(64)
      link.wide_door   = random_door_kind(128)
    end
    link.block_sound = rand_odds(90)
    link.bar_size    = rand_index_by_probs { 20,90 }
    link.arch_rand   = con.random() * 100
    link.door_rand   = con.random() * 100

    if link.where == "double" then
      local awh = rand_irange(2,3)
      build_real_link(link, side, 1)
      build_real_link(link, side, 2)
    else
      build_real_link(link, side, 0)
    end
  end

  local function build_corner(side)

    local E = c.corner[side]
    if not E then return end
    if E.build ~= c then return end

    -- handle outside corners
    local out_num = 0
    local f_max = -99999

    for zzz,c in ipairs(E.cells) do
      if c.theme.outdoor then out_num = out_num + 1 end
      f_max = math.max(c.f_max, f_max)
    end

    -- FIXME: determine corner_kind (like border_kind)
    if E.kind == "sky" then

      local CORN = copy_block_with_new(E.cells[1].rmodel,
      {
        f_h = f_max + 64,
        f_tex = E.theme.floor,
        l_tex = E.theme.wall,
      })

      -- crappy substitute to using a real sky corner
      if out_num < 4 then CORN.c_h = CORN.f_h + 1 end

      if CORN.f_h < CORN.c_h then
        gap_fill(p,c, E.bx, E.by, E.bx, E.by, CORN)
        return
      end
    end

    gap_fill(p,c, E.bx, E.by, E.bx, E.by, { solid=E.theme.wall })
  end

  local function build_sky_border(side, x1,y1, x2,y2)

    local WALL =
    {
      f_h = c.f_max + 48,
      f_tex = c.rmodel.f_tex,
      l_tex = c.rmodel.l_tex,

      c_h = c.rmodel.c_h,
      c_tex = c.rmodel.c_tex,
      u_tex = c.rmodel.u_tex,

      light = c.rmodel.light,
    }

    local BEHIND =
    {
      f_h = c.f_min - 512,
      c_h = c.f_min - 508,
      f_tex = c.rmodel.f_tex,
      c_tex = c.rmodel.c_tex,
      l_tex = c.rmodel.l_tex,
      u_tex = c.rmodel.u_tex,
      light = c.rmodel.light,
    }

    local ax1, ay1, ax2, ay2 = side_coords(10-side, 1,1, FW,FH)

    for x = x1,x2 do for y = y1,y2 do

      local B = p.blocks[x][y]

      -- overwrite a 64x64 block, but not a fragmented one
      if (not B) or (not B.fragments) then

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
      f_h = c.f_max + 48, c_h = c.rmodel.c_h,
      f_tex = c.rmodel.f_tex, c_tex = c.rmodel.c_tex,
      light = c.rmodel.light,
      l_tex = c.rmodel.l_tex,
      u_tex = c.rmodel.u_tex,
    }

    local BEHIND =
    {
      f_h = c.f_min - 512, c_h = c.f_min - 508,
      f_tex = c.rmodel.f_tex, c_tex = c.rmodel.c_tex,
      light = c.rmodel.light,
      l_tex = c.rmodel.l_tex,
      u_tex = c.rmodel.u_tex,
    }

    if not p.blocks[x][y] then

      local fx = (x - 1) * FW
      local fy = (y - 1) * FH

      frag_fill(p,c, fx+ 1, fy+ 1, fx+FW, fy+FH, BEHIND)
      frag_fill(p,c, fx+wx, fy+wy, fx+wx, fy+wy, WALL)
    end
  end

  local function build_fence(side, x1,y1, x2,y2, other, what, b_theme)

    local D = c.border[side]

      local FENCE = copy_block_with_new(c.rmodel,
      {
        f_h = math.max(c.f_max, other.f_max),
        f_tex = b_theme.floor,
        c_tex = b_theme.ceil,
        
        l_tex = b_theme.void,
        u_tex = b_theme.void,
      })

--?? local f_min, f_max = border_floor_range(other, side)

    if rand_odds(95) then FENCE.block_sound = 2 end

FENCE.f_tex = "LAVA1" --!!! TESTING

    -- determine fence kind

    local kind = "plain"
    
    if THEME.caps.rails and rand_odds(30) then kind = "wire" end

    -- FIXME: "castley"

--[[ 
    if c1.scenic or c2.scenic then
      return rand_sel(30, "wire", "fence")
    end

    local i_W = sel(link, 3, 20)
    local i_F = sel(c1.theme == c2.theme, 5, 0)

    if dual_odds(c1.theme.outdoor, 25, i_W) then return "wire" end
    if dual_odds(c1.theme.outdoor, 60, i_F) then return "fence" end
--]]

    -- FIXME: choose fence rail

    if kind == "plain" then
      FENCE.f_h = FENCE.f_h + 48+16*rand_irange(0,2)
      if other.scenic then FENCE.impassible = true end

    elseif kind == "wire" then
      local rail_tex =THEME.rails["r_1"].wall

      if x1==x2 and y1==y2 then
        FENCE.rail = rail_tex
      else
        local rsd = side

        if (rsd % 2) == 1 then
          rsd = sel(x1==x2, 4, 2)
        end

        if b_theme ~= c.theme then rsd = 10 - side end

        FENCE[rsd] = { rail = rail_tex }
      end
    else
      error("build_fence: unknown kind: " .. kind)
    end

    gap_fill(p,c, x1,y1, x2,y2, FENCE)

--[[
    for n = 1,KW do --!!!!! 1,KW   FIXME: sx,sy (etc) are floats!!!
        -- FIXME: ICK!!! FIXME
        local sx = x1 + (x2-x1+1) * (n-1) / KW
        local sy = y1 + (y2-y1+1) * (n-1) / KH
        local ex = x1 + (x2-x1+1) * (n  ) / KW
        local ey = y1 + (y2-y1+1) * (n  ) / KH
        if x1 == x2 then sx,ex = x1,x1 end
        if y1 == y2 then sy,ey = y1,y1 end
        ex = ex + (sx-ex)/KW
        ey = ey + (sy-ey)/KH

      local K1, K2 = chunk_pair(c, other, side, n)

      if (K1.void or K1.cage) and (K2.void or K2.cage) then
        gap_fill(p,c, c.bx1-1+sx,c.bx1-1+sy, c.by1-1+ex,c.by1-1+ey, { solid=b_theme.void})
      else
        local sec

        if what == "empty" then
          sec = copy_block(EMPTY)

          if K1.liquid or K2.liquid then
            sec.f_h = math.max(K1.rmodel.f_h or -65536, K2.rmodel.f_h or -65536)
            if K1.liquid == K2.liquid and K1.rmodel.f_h == K2.rmodel.f_h then
              sec.f_h = sec.f_h + 16
            end
          else
            sec.f_h = math.min(K1.rmodel.f_h or  65536, K2.rmodel.f_h or  65536)
          end

        else -- wire fence (floor already set)
          sec = EMPTY
        end

        sec.l_tex = b_theme.wall
        sec.u_tex = b_theme.wall

        gap_fill(p,c, c.bx1-1+sx,c.by1-1+sy, c.bx1-1+ex,c.by1-1+ey, sec, overrides)
      end
    end
--]]
  end

  local function build_window(side)

    local D = c.border[side]

    if not (D and D.window and D.build == c) then return end

    local link = c.link[side]
    local other = neighbour_by_side(p,c,side)

    local b_theme = D.theme

    local WINDOW = 
    {
      f_h = math.max(c.f_max, other.f_max) + 32,
      c_h = math.min(c.rmodel.c_h, other.rmodel.c_h) - 32,

      f_tex = b_theme.floor,
      c_tex = b_theme.ceil,

      l_tex = b_theme.wall,
      u_tex = b_theme.wall,

      light = c.rmodel.light,
    }

--if (side%2)==1 then WINDOW.light=255; WINDOW.kind=8 end

    if other.scenic then WINDOW.impassible = true end

    WINDOW.light = WINDOW.light - 16
    WINDOW.c_tex = b_theme.arch_ceil or WINDOW.f_tex

---### YUCK  if (WINDOW.c_h - WINDOW.f_h) > 64 and rand_odds(30) then
---###         WINDOW.c_h = WINDOW.f_h + 64
---###       end

    local x = D.x1
    local y = D.y1

    local ax, ay = dir_to_across(D.side)

    while x <= D.x2 and y <= D.y2 do
      gap_fill(p,c, x, y, x, y, WINDOW)
      x, y = x+ax, y+ay
    end

--[[ GOOD OLD STUFF

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

    elseif c.vista[side] then
      if rand_odds(50) then
        max_x = 3
      else
        min_x = BW-3+1
      end
    end

    local dx, dy = dir_to_delta(D.side)

    local x, y = side_coords(side, 1,1, BW,BH)

    x = c.bx1-1 + x+dx
    y = c.by1-1 + y+dy


    local long  = rand_index_by_probs { 30, 90, 10, 3 }
    local step  = long + rand_index_by_probs { 90, 30, 4 }
    local first = -1 + rand_index_by_probs { 90, 90, 30, 5, 2 }

    local bar, bar_step
    local bar_chance

    if D.kind == "fence" then
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
    if not bar and D.kind ~= "fence" then
      -- FIXME: choose window rail
      sec[side] = { rail = THEME.rails["r_2"].wall }
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
--]]
  end

  local function build_one_border(side)

    local D = c.border[side]
    if not D then return end
    if D.build ~= c then return end

    local link = c.link[side]
    local other = neighbour_by_side(p, c, side)

    local what = D.kind
    assert(what)

    local b_theme = D.theme
    assert(b_theme)

    if false then --!!!!! c.vista[side] then
    end

    local x1,y1, x2,y2 = D.x1, D.y1, D.x2, D.y2

---if (side % 2) == 1 then
---gap_fill(p,c, x1,y1, x2,y2, { solid="COMPBLUE" })
---return
---end

    if what == "wire" or what == "fence" then

      build_fence(side, x1,y1, x2,y2, other, what, b_theme)

---###      if other.scenic then FENCE.impassible = true end

    elseif what == "window" then
      build_window(side)

    elseif what == "sky" then
      build_sky_border(D.side, x1,y1, x2,y2)

      -- handle the corner (check adjacent side)
--[[ FIXME !!!!! "sky"
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

          if false then --!!!!! FIXME what_border_type(NB, NB_link, NB_other, side) == "sky" then
            build_sky_border(side, cx, cy, cx, cy)
          end
        else
          local wx, wy

          if cx < BW/2 then wx = FW else wx = 1 end
          if cy < BH/2 then wy = FH else wy = 1 end

          build_sky_corner(cx, cy, wx, wy)
        end
      end
--]]

    else -- solid
      gap_fill(p,c, x1,y1, x2,y2, { solid=b_theme.wall })
    end

  end


  --== build_borders ==--

  setup_borders_and_corners(p)

  for zzz,cell in ipairs(p.all_cells) do

    c = cell

    for side = 1,9,2 do
      build_corner(side)
      build_one_border(side)
    end

    for side = 2,8,2 do
      build_link(side)
      build_one_border(side)
    end
  end
end


----------------------------------------------------------------

function build_maze(p, c, x1,y1, x2,y2)
  -- FIXME
end

function build_grotto(p, c, x1,y1, x2,y2)
  
  local ROOM = c.rmodel
  local WALL = { solid=c.theme.wall }

  for y = y1+1, y2-1, 2 do
    for x = x1+1+(int(y/2)%2)*2, x2-3, 4 do
      gap_fill(p,c, x-2,y, x-2,y, WALL)
      gap_fill(p,c, x+2,y, x+2,y, WALL)

      local ax, ay = dir_to_across(rand_sel(50, 2, 4))
      gap_fill(p,c, x-ax,y-ay, x+ax,y+ay, WALL)
    end
  end

  gap_fill(p,c, x1,y1, x2-3,y2-1, ROOM)
end

function build_pacman_level(p, c)

  local function free_spot(bx, by)
    local B = p.blocks[bx][by]
    return B and not B.solid and not B.has_blocker
  end

  local function solid_spot(bx, by)
    local B = p.blocks[bx][by]
    return B and B.solid
  end

  local PACMAN_MID_FABS  = { "WOLF_PACMAN_MID_1", "WOLF_PACMAN_MID_2", "WOLF_PACMAN_MID_3" }
  local PACMAN_CORN_FABS = { "WOLF_PACMAN_CORN_1", "WOLF_PACMAN_CORN_2", "WOLF_PACMAN_CORN_3" }
 
  local mid_fab = PREFABS[rand_element(PACMAN_MID_FABS)]
  assert(mid_fab)

  local mid_x = 32 - int(mid_fab.long/2)
  local mid_y = 30 - int(mid_fab.deep/2)

  local top_fab = PREFABS[rand_element(PACMAN_CORN_FABS)]
  local bot_fab = PREFABS[rand_element(PACMAN_CORN_FABS)]
  assert(top_fab and bot_fab)

  local top_flip = rand_odds(50)
  local bot_flip = not top_flip

  local theme = THEME.themes[rand_sel(50,"BLUE_STONE","BLUE_BRICK")]
  assert(theme)

  local skin =
  {
    ghost_w = THEME.themes[rand_sel(50,"RED_BRICK","PURPLE_STONE")].wall,

    dot_t = rand_sel(50,"chalice","cross"),

    treasure1 = "bible",
    treasure2 = "crown",

    blinky = "blinky",
    clyde = "clyde",
    inky = "inky",
    pinky = "pinky",
    first_aid = "first_aid",
  }
  local parm =
  {
  }

  B_prefab(p,c, mid_fab,skin,parm,theme, mid_x-2, mid_y, 8, false)

  B_prefab(p,c, top_fab,skin,parm,theme, mid_x-10, mid_y+16, 8,false,top_flip)
  B_prefab(p,c, top_fab,skin,parm,theme, mid_x+10, mid_y+16, 8,true, top_flip)

  B_prefab(p,c, bot_fab,skin,parm,theme, mid_x-10, mid_y-12, 8,false,bot_flip)
  B_prefab(p,c, bot_fab,skin,parm,theme, mid_x+10, mid_y-12, 8,true, bot_flip)

  B_exit_elevator(p,c, mid_x+19, mid_y+28, 2)

  gap_fill(p,c, 2,2, 63,63, { solid=theme.wall })
  
  -- player spot
  local px
  local py = rand_irange(mid_y-11, mid_y-3)
  local p_ang = 0

  for x = mid_x-7,mid_x+12 do
    if free_spot(x, py) then
      px = x
      if solid_spot(x+1, py) or solid_spot(x+2,py) then
        p_ang = 90
        if solid_spot(x,py+1) or solid_spot(x,py+2) then p_ang = 270 end
      end
      break;
    end 
  end

  if not px then error("Could not find spot for pacman!") end

  add_thing(p, c, px, py, "player1", true, p_ang)
end

----------------------------------------------------------------


function build_cell(p, c)
 
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
      c.void_pic = { wall=c.theme.pic_wd, w=128, h=c.theme.pic_wd_h or 128 }
      c.void_cut = 1
      return

    elseif not c.theme.outdoor and rand_odds(25) then
      c.void_pic = get_rand_wall_light()
      c.void_cut = rand_irange(3,4)
      return

    else
      c.void_pic = get_rand_pic()
      c.void_cut = 1
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

--[[ OLD CRUD
  local function border_floor_range(other, side)
    assert(other)

    local f_min, f_max = 65536, -65536

    for n = 1,KW do
      local K1, K2 = chunk_pair(c, other, side,n)
 
      if not (K1.void or K1.cage or K1.vista) then
        f_max = math.max(f_max, K1.rmodel.f_h)
        f_min = math.min(f_min, K1.rmodel.f_h)
      end
      if not (K2.void or K2.cage or K2.vista) then
        f_max = math.max(f_max, K2.rmodel.f_h)
        f_min = math.min(f_min, K2.rmodel.f_h)
      end
    end

    if f_min == 65536 then return nil, nil end

    return f_min, f_max
  end
--]]

  local dummy_pos_filler_crud_grunk

--[[ OLD CRUD
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

    return best.void
  end
--]]

  --[[ OLD STUFF, REMOVE SOON
  local function who_build_border(c, side, other, link)

    if not other then
      return c
    end

    if link then
      return link.build
    end

    if c.vista_from == side then
      return other
    elseif c.vista[side] then
      return c
    end

    if c.theme.outdoor ~= other.theme.outdoor then
      return sel(c.theme.outdoor, other, c)
    end

    -- using 'not' because the scenic field has multiple values,
    -- but the decision must be binary.
    if (not c.scenic) ~= (not other.scenic) then
      return sel(c.scenic, other, c)
    end

---##  elseif (c.scenic == "solid") ~= (other.scenic == "solid") then
---##    return sel(c.scenic == "solid", 

    return sel(side > 5, other, c)
  end
  --]]

  local function position_sp_stuff(c)

    if c == p.quests[1].first then
      local kx, ky = good_Q_spot(c, true)
      if not kx then error("NO FREE SPOT for Player!") end
      c.chunks[kx][ky].player=true
    end

    if c == c.quest.last then
      local can_vista = (c.quest.kind == "key") or
              (c.quest.kind == "weapon") or (c.quest.kind == "item")
      local kx, ky = good_Q_spot(c, can_vista)
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

  local function position_dm_stuff(c) -- FIXME: MOVE_TO monster.lua

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

---###    -- guarantee at least 4 players (each corner)
---###    if (c.x==1) or (c.x==p.w) or (c.y==1) or (c.y==p.h) or rand_odds(66) then
---###      local spot = get_spot()
---###      if spot then spot.K.player = true end
---###    end
---###
---###    -- guarantee at least one weapon (central cell)
---###    if (c.x==int((p.w+1)/2)) or (c.y==int((p.h+1)/2)) or rand_odds(70) then
---###      local spot = get_spot()
---###      if spot then spot.K.dm_weapon = choose_dm_thing(THEME.dm.weapons, true) end
---###    end
---###
---###    -- secondary players and weapons
---###    if rand_odds(33) then
---###      local spot = get_spot()
---###      if spot then spot.K.player = true end
---###    end
---###    if rand_odds(15) then
---###      local spot = get_spot()
---###      if spot then spot.K.dm_weapon = choose_dm_thing(THEME.dm.weapons, true) end
---###    end

    -- from here on we REUSE the spots --

    if #spots == 0 then return end

  end

  local function OLD_build_chunk(kx, ky)

    local function link_is_door(c, side)
      return c.link[side] and c.link[side].kind == "door"
    end

    local function add_overhang_pillars(c, K, kx, ky, sec, l_tex, u_tex)
      local basex = K.x1
      local basey = K.y1

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

---###    local function chunk_dm_offset()
---###      while true do
---###        local dx = rand_irange(1,3) - 2
---###        local dy = rand_irange(1,3) - 2
---###        if not (dx==0 and dy==0) then return dx,dy end
---###      end
---###    end


    ---=== OLD_build_chunk ===---

    local K = c.chunks[kx][ky]
    assert(K)

---###    if c.scenic == "solid" then
---###      gap_fill(p,c, K.x1, K.y1, K.x2, K.y2, { solid=c.theme.void })
---###      return
---###    end

    -- elevator exits are done in build_link
    if THEME.caps.elevator_exits and c.is_exit then return end

---###    if K.stair_dir then
---###
---###      local x1,y1, x2,y2 = side_coords(K.stair_dir,
---###        K.x1, K.y1, K.x2, K.y2)
---###
---###      local long
---###      if (K.stair_dir==2 or K.stair_dir==8) then
---###        long = x2-x1+1
---###      else
---###        long = y2-y1+1
---###      end
---###
---###      local deep = 1
---###
---###      local dx,dy = dir_to_delta(K.stair_dir)
---###      local NB = c.chunks[kx+dx][ky+dy]
---###      local diff = math.abs(K.rmodel.f_h - NB.rmodel.f_h)
---###
---###      local step = (NB.rmodel.f_h - K.rmodel.f_h) / (deep * 4)
---###
---###      B_stair(p, c, x1, y1, K.rmodel.f_h, K.stair_dir, long, deep, step)
---###  end

gap_fill(p,c, K.x1, K.y1, K.x2, K.y2, K.rmodel,
{
  light = sel(K.room, 192, sel(K.empty, 96, 144))
})
do return end

    -- vista chunks are built by other room
    if K.vista then return end

    if K.void then
      --!!!!! TEST CRAP
      gap_fill(p,c, K.x1, K.y1, K.x2, K.y2, c.rmodel)
      do return end

      if K.closet then
        con.debugf("BUILDING CLOSET @ (%d,%d)\n", c.x, c.y)

        table.insert(K.place.spots,
          B_monster_closet(p,c, K,kx,ky, c.floor_h + 0,
            c.quest.closet.door_tag))

      elseif K.dm_exit then
        B_deathmatch_exit(p,c, K,kx,ky,K.dir)

      elseif THEME.pics and not c.small_exit
          and rand_odds(sel(c.theme.outdoor, 10, sel(c.hallway,20, 50)))
      then
        if not c.void_pic then decide_void_pic(p, c) end
        local pic,cut = c.void_pic,c.void_cut

        if not c.quest.image and (p.deathmatch or
             (c.quest.mini and rand_odds(33)))
        then
          pic = THEME.images[1]
          cut = 1
          c.quest.image = "pic"
        end

        B_void_pic(p,c, K,kx,ky, pic,cut)

      else
        gap_fill(p,c, K.x1, K.y1, K.x2, K.y2, { solid=c.theme.void })
      end
      return
    end -- K.void

    if K.cage then
      B_big_cage(p,c, THEME.mats.CAGE, K,kx,ky)
      return
    end

---###    if K.stair_dir then
---###
---###      local dx, dy = dir_to_delta(K.stair_dir)
---###      local NB = c.chunks[kx+dx][ky+dy]
---###
---###      local diff = math.abs(K.rmodel.f_h - NB.rmodel.f_h)
---###
---###      local long = 2
---###      local deep = 1
---###
---###      -- prefer no lifts in deathmatch
---###      if p.deathmatch and diff > 64 and rand_odds(88) then deep = 2 end
---###
---###      -- FIXME: replace with proper "can walk" test !!!
---###      if (K.stair_dir == 6 and kx == 1 and c.border[4]) or
---###         (K.stair_dir == 4 and kx == 3 and c.border[6]) or
---###         (K.stair_dir == 8 and ky == 1 and c.border[2]) or
---###         (K.stair_dir == 2 and ky == 3 and c.border[8]) then
---###        deep = 1
---###      end
---###
---###      local bx = (kx-1) * JW
---###      local by = (ky-1) * JH 
---###
---###      if K.stair_dir == 8 then
---###        by = by + JH + 1 - deep
---###      elseif K.stair_dir == 2 then
---###        by = by + deep
---###      elseif ky == 1 then
---###        by = by + JH - 1
---###      elseif ky == 3 then
---###        by = by + 1
---###      else
---###        by = by + 1; if JH >= 4 then by = by + 1 end
---###      end
---###
---###      if K.stair_dir == 6 then
---###        bx = bx + JW + 1 - deep
---###      elseif K.stair_dir == 4 then
---###        bx = bx + deep
---###      elseif kx == 1 then
---###        bx = bx + JW - 1
---###      elseif kx == 3 then
---###        bx = bx + 1
---###      else
---###        bx = bx + 1; if JW >= 4 then bx = bx + 1 end
---###      end
---###
---###      local step = (NB.rmodel.f_h - K.rmodel.f_h) / deep / 4
---###
---###      if math.abs(step) <= 16 then
---###        B_stair(p, c, c.bx1-1+bx, c.by1-1+by, K.rmodel.f_h, K.stair_dir,
---###                long, deep, (NB.rmodel.f_h - K.rmodel.f_h) / (deep * 4),
---###                { } )
---###      else
---###        B_lift(p, c, c.bx1-1+bx, c.by1-1+by,
---###               math.max(K.rmodel.f_h, NB.rmodel.f_h), K.stair_dir,
---###               long, deep, { } )
---###      end
---###    end  -- K.stair_dir


    local bx = K.x1 + 1
    local by = K.y1 + 1
    
    if K.player then
      local angle = player_angle(kx, ky)
      local offsets = sel(rand_odds(50), {1,3,7,9}, {2,4,6,8})
      if p.coop then
        for i = 1,4 do
          local dx,dy = dir_to_delta(offsets[i])
          if settings.game == "plutonia" then
            B_double_pedestal(p,c, bx+dx,by+dy, K.rmodel, THEME.special_ped)
          else
            B_pedestal(p, c, bx+dx, by+dy, K.rmodel, THEME.pedestals.PLAYER)
          end
          add_thing(p, c, bx+dx, by+dy, "player" .. tostring(i), true, angle)
          c.player_pos = {x=bx+dx, y=by+dy}
        end
      else
        if settings.game == "plutonia" then
          B_double_pedestal(p,c, bx,by, K.rmodel, THEME.special_ped)
        else
          B_pedestal(p, c, bx, by, K.rmodel, THEME.pedestals.PLAYER)
        end
        add_thing(p, c, bx, by, sel(p.deathmatch, "dm_player", "player1"), true, angle)
        c.player_pos = {x=bx, y=by}

      end

    elseif K.dm_weapon then
      B_pedestal(p, c, bx, by, K.rmodel, THEME.pedestals.WEAPON)
      add_thing(p, c, bx, by, K.dm_weapon, true)

    elseif K.quest then

      if c.quest.kind == "key" or c.quest.kind == "weapon" or c.quest.kind == "item" then
        B_pedestal(p, c, bx, by, K.rmodel, THEME.pedestals.QUEST)

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
          B_wall_switch(p,c, bx,by, K.rmodel.f_h, side, 2, info, kind, c.quest.tag + 1)
        else
          B_pillar_switch(p,c, K,bx,by, info,kind, c.quest.tag + 1)
        end

      elseif c.quest.kind == "exit" then
        assert(c.theme.switch)

        local side = wall_switch_dir(kx, ky, c.entry_dir)

        if settings.game == "plutonia" then
          B_double_pedestal(p,c, bx,by, K.rmodel, THEME.special_ped,
            { walk_kind = 52 }) -- FIXME "exit_W1"

        elseif c.small_exit and not c.smex_cage and rand_odds(80) then
          if c.theme.flush then
            B_flush_switch(p,c, bx,by, K.rmodel.f_h,side, c.theme.switch, 11)
          else
            B_wall_switch(p,c, bx,by, K.rmodel.f_h,side, 3, c.theme.switch, 11)
          end

          -- make the area behind the switch solid
          local x1, y1 = K.x1, K.y1
          local x2, y2 = K.x2, K.y2
              if side == 4 then x1 = x1+2
          elseif side == 6 then x2 = x2-2
          elseif side == 2 then y1 = y1+2
          elseif side == 8 then y2 = y2-2
          else   error("Bad side for small_exit switch: " .. side)
          end

          gap_fill(p,c, x1,y1, x2,y2, { solid=c.theme.wall })
          
        elseif c.theme.hole_tex and rand_odds(75) then
          B_exit_hole(p,c, K,kx,ky, c.rmodel)
          return
        elseif rand_odds(85) then
          B_floor_switch(p,c, bx,by, K.rmodel.f_h, side, c.theme.switch, 11)
        else
          B_pillar_switch(p,c, K,bx,by, c.theme.switch, 11)
        end
      end
    end -- if K.player | K.quest etc...


    ---| fill in the rest |---

    local sec = copy_block(K.rmodel)

    local surprise = c.quest.closet or c.quest.depot

    if K.quest and surprise and c == surprise.trigger_cell then

      sec.mark = allocate_mark(p)
      sec.walk_kind = 2
      sec.walk_tag  = surprise.door_tag
    end

    if K.liquid then  -- FIXME: put into setup_chunk_rmodels
      sec.kind = c.liquid.sec_kind
    end

    if K.player then

      sec.near_player = true;
      if not sec.kind then
        sec.kind = 9  -- FIXME: "secret"
      end

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

      K.overhang = true

      if not c.overhang then
        local name
        name, c.overhang = rand_table_pair(THEME.hangs)
      end
      local overhang = c.overhang

      K.sup_tex = overhang.thin

      sec.c_tex = overhang.ceil
      sec.u_tex = overhang.upper

      sec.c_h = sec.c_h - (overhang.h or 24)
      sec.light = sec.light - 48
    end

    -- TEST CRUD : crates
    if not c.scenic and not K.stair_dir
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
    if not K.crate and not c.scenic and not K.stair_dir
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
      K.sky_light_sec.c_tex = sel(c.sky_light.is_sky, THEME.SKY_TEX, c.sky_light.light_info.floor)
      K.sky_light_sec.light = 176
      K.sky_light_utex = c.sky_light.light_info.side

      -- make sure sky light doesn't come down too low
      K.sky_light_sec.c_h = math.max(K.sky_light_sec.c_h,
        sel(c.sky_light.is_sky, c.c_max+16, c.c_min))
    end
 
    ---- Chunk Fill ----

    local l_tex = c.rmodel.l_tex

    do
      assert(sec)

      if K.overhang then
        add_overhang_pillars(c, K, kx, ky, sec, sec.l_tex, sec.u_tex)
      end

      if K.sky_light_sec then
        local x1,y1,x2,y2 = K.x1,K.y1,K.x2,K.y2
        if kx==1  then x1=x1+1 end
        if kx==KW then x2=x2-1 end
        if ky==1  then y1=y1+1 end
        if ky==KH then y2=y2-1 end

        local func = SKY_LIGHT_FUNCS[c.sky_light.pattern]
        assert(func)

        local BB = copy_block(K.sky_light_sec)
        BB.l_tex = sec.l_tex
        BB.u_tex = K.sky_light_utex or sec.u_tex

        for x = x1,x2 do for y = y1,y2 do
          if func(kx,ky, x,y) then
            gap_fill(p,c, x,y, x,y, BB)
          end
        end end
      end

      -- get this *after* doing sky lights
      local blocked = p.blocks[K.x1+1][K.y1+1] --!!!

      if K.crate and not blocked then
        local theme = c.crate_theme
        if not c.quest.image and not c.quest.mini and
           (not p.image or rand_odds(11))
        then
          theme = THEME.images[2]
          c.quest.image = "crate"
          p.image = true
        end
        B_crate(p,c, theme, sec, kx,ky, K.x1+1,K.y1+1)
        blocked = true
      end

      if K.pillar and not blocked then

        -- TEST CRUD
        if rand_odds(22) and THEME.mats.CAGE and not p.deathmatch
          and K.rmodel.c_h >= K.rmodel.f_h + 128
        then
          B_pillar_cage(p,c, THEME.mats.CAGE, kx,ky, K.x1+1,K.y1+1)
        else
          B_pillar(p,c, c.theme, kx,ky, K.x1+1,K.y1+1)
        end
        blocked = true
      end

---###      sec.l_tex = l_tex
---###      sec.u_tex = u_tex

      gap_fill(p,c, K.x1, K.y1, K.x2, K.y2, sec)

      if not blocked and c.theme.scenery and not K.stair_dir and
         (dual_odds(c.theme.outdoor, 37, 22)
          or (c.scenic and rand_odds(51)))
      then
--!!!!!        p.blocks[K.x1+1][K.y1+1].has_scenery = true
        local th = add_thing(p, c, K.x1+1, K.y1+1, c.theme.scenery, true)
        if c.scenic then
          th.dx = rand_irange(-64,64)
          th.dy = rand_irange(-64,64)
        end
      end
    end


---###    if K.dm_health then
---###      add_dm_pickup(c, bx,by, K.dm_health)
---###    end
---###    
---###    if K.dm_ammo then
---###      add_dm_pickup(c, bx,by, K.dm_ammo)
---###    end
---###    
---###    if K.dm_item then
---###      add_dm_pickup(c, bx,by, K.dm_item)
---###    end
  end

  local function decide_sky_lights(c)
    if not c.theme.outdoor and not c.is_exit and not c.hallway
       and THEME.lights and rand_odds(70)
    then
      c.sky_light =
      {
        h  = 8 * rand_irange(2,4),
        pattern = random_sky_light(),
        is_sky = rand_odds(33),
        light_info = get_rand_light()
      }
      if not c.sky_light.is_sky and rand_odds(80) then
        c.sky_light.h = - c.sky_light.h
      end
    end
  end

  local function void_up_chunk(c, K)

    --!!!!!! TESTING
    if c.theme.decorate and not c.scenic and K.void and
      (K.x2 > K.x1 or rand_odds(50)) and  -- FIXME: better randomness
      (K.y2 > K.y1 or rand_odds(50)) and
      rand_odds(65)
    then
      local dec_tex = c.theme.decorate
      if type(dec_tex) == "table" then
        dec_tex = rand_element(dec_tex)
      end
      gap_fill(p, c, K.x1,K.y1, K.x1,K.y1, { solid=dec_tex })
      gap_fill(p, c, K.x2,K.y2, K.x2,K.y2, { solid=dec_tex })
    end

    gap_fill(p, c, K.x1,K.y1, K.x2,K.y2, { solid=c.theme.void })
  end

  local function build_void_space(c)
    for kx = 1,3 do for ky = 1,3 do
      local K = c.chunks[kx][ky]
      if K.void then
        void_up_chunk(c, K)
      end
    end end
  end

  local function get_vista_coords(c, side, link, other)

    local x1, y1, x2, y2

    for kx = 1,3 do for ky = 1,3 do
      local K = other.chunks[kx][ky]
      if K.vista and K.link == link then
        if not x1 then
          x1,y1, x2,y2 = K.x1,K.y1, K.x2,K.y2
        else
          x1 = math.min(x1, K.x1)
          y1 = math.min(y1, K.y1)
          x2 = math.max(x2, K.x2)
          y2 = math.max(y2, K.y2)
        end
      end
    end end

con.printf("get_vista_coords @ (%d,%d) --> (%d,%d)\n",
c.x, c.y, other.x, other.y)
    if not x1 then error("missing vista chunks!?!?") end

    local long = x2 - x1 + 1
    local deep = y2 - y1 + 1

    if (side == 4) or (side == 6) then
      long,deep = deep,long
    end

    return x1,y1, x2,y2, long,deep
  end
  
  local function build_one_vista(c, side, link)

    local other = neighbour_by_side(p, c, side)

    local kind = "open"
    local diff_h = c.floor_h - other.floor_h

    if diff_h >= 48 and rand_odds(35) then kind = "wire" end

    if not c.theme.outdoor then
      local space_h = other.ceil_h - c.floor_h
      local r = con.random() * 100

      if space_h >= 96 and space_h <= 256 and r < 15 then
        kind = "frame"
      elseif r < 60 then
        kind = "solid"
      end
    end

    local x1,y1, x2,y2, long,deep = get_vista_coords(c, side, link, other)

    B_vista(p,c, x1,y1, x2,y2, long,deep, side, c.border[side].theme or c.theme, kind)
  end

  local function build_vistas(c)
    for side = 2,8,2 do
      local L = c.link[side]
      if L and L.kind == "vista" and L.build == c then
        build_one_vista(c, side, L)
      end
    end
  end


  local function mark_walkable_area(c, x1,y1, x2,y2)
    assert(x2 >= x1 and y2 >= y1)
    assert(c.bx1 <= x1 and x2 <= c.bx2)
    assert(c.by1 <= y1 and y2 <= c.by2)

    for x = x1,x2 do for y = y1,y2 do
      local B = p.blocks[x][y]
      assert(B)
--!!!      assert(not (B.solid or B.f_tex))
      B.walk = true
    end end
  end

  local function mark_links(c)
    
    for side = 2,8,2 do
      local dx,dy = dir_to_delta(10-side) -- inwards

      local L = c.link[side]
      if L then
        mark_walkable_area(c, L.x1+dx, L.y1+dy, L.x2+dx, L.y2+dy)
      end

      local D = c.border[side]
      if D and D.kind == "window" then
        mark_walkable_area(c, D.x1+dx, D.y1+dy, D.x2+dx, D.y2+dy)
      end
    end
  end

  local function check_fab_position(c, x1,y1, x2,y2)
    assert(x1 <= x2 and y1 <= y2)

    if not (c.bx1 <= x1 and x2 <= c.bx2) or
       not (c.by1 <= y1 and y2 <= c.by2)
    then
      return false
    end
    
    for x = x1-1,x2+1 do for y = y1-1,y2+1 do
      if x < x1 or x > x2 or y < y1 or y > y2 then
        -- check sides
        if x < c.bx1 or x > c.bx2 or y < c.by1 or y > c.by2 then
          return false
        end
        local B = p.blocks[x][y]
        assert(B)
        if (B.solid or B.f_tex) then --!!!!! or not is_roomy(B.chunk) then
          return false
        end
      else
        -- check middle area
        local B = p.blocks[x][y]
        assert(B and B.chunk)
---???  if not B.empty or B.walk or not is_roomy(B.chunk) then
        if B.walk or not is_roomy(B.chunk) then
          return false
        end
      end
    end end

    return true --OK--
  end

  local function mark_fab_walk(c, x1,y1, x2,y2)
    assert(x1 <= x2 and y1 <= y2)
    assert(c.bx1 <= x1 and x2 <= c.bx2)
    assert(c.by1 <= y1 and y2 <= c.by2)
    
    for x = x1-1,x2+1 do for y = y1-1,y2+1 do
      if (x < x1 or x > x2 or y < y1 or y > y2) and
         (c.bx1 <= x and x <= c.bx2) and
         (c.by1 <= y and y <= c.by2)
      then
--con.printf("mark_fab_walk @ (%d,%d)...\n", x, y)
        mark_walkable_area(c, x,y, x,y)
      end
    end end
  end

  local function stair_depths(diff_h)
    diff_h = math.abs(diff_h)

    local low = 1
    if diff_h >= 72  then low = 2 end
    if diff_h >= 168 then low = 3 end
    if diff_h >= 264 then low = 4 end
    
    local high = 1
    if diff_h >= 48  then high = 2 end
    if diff_h >= 96  then high = 3 end
    if diff_h >= 144 then high = 4 end

    return low,high
  end

  local function sort_stair_chunks(c)

    -- Requirements:
    --   That chunks with 'stair_dir' field are placed _after_ the
    --   chunk pointed to.

    -- Algorithm:
    --   (a) give each chunk a unique ID
    --   (b) let low IDs "flow down" stair directions
    --   (c) repeat step (b) many times until stable
    --   (d) sort chunks into ascending ID numbers
    --
    -- NOTE: cyclic references prevent it from becoming truly
    --       stable. We ignore this problem (should be rare).

    local ids = {}
    rand_shuffle(ids, 3*3)

    local result = {}

    for kx = 1,3 do for ky = 1,3 do
      local K = c.chunks[kx][ky]
      K.sort_id = table.remove(ids, 1)
      table.insert(result, K)
    end end

    for loop = 1,10 do
      for kx = 1,3 do for ky = 1,3 do
        local K = c.chunks[kx][ky]
        if K.stair_dir then
          local dx,dy = dir_to_delta(K.stair_dir)
          local J = c.chunks[kx+dx][ky+dy]
          if K.sort_id < J.sort_id then
            K.sort_id, J.sort_id = J.sort_id, K.sort_id
          end
        end
       end end 
    end

    table.sort(result, function(k1,k2) return k1.sort_id < k2.sort_id end)

-- con.printf("RESULT = \n%s\n", table_to_str(result,2))
    return result
  end

  local function find_stair_loc(K, behind_K,side1_K,side2_K, min_deep,want_deep)

    -- Requirements:
    --   (a) blocks which stair will occupy are empty
    --   (b) blocks vor und hinter the stair are walkable
    --
    -- Preferences:
    --   (c) depth >= min_deep
    --   (d) width at least 2 blocks
    --   (e) prefer away from side edges

    local in_dir = 10-K.stair_dir
    local dx,dy = dir_to_delta(in_dir)
    local ax,ay = dir_to_across(in_dir)

    local x1,y1, x2,y2 = side_coords(K.stair_dir, K.x1,K.y1, K.x2,K.y2)

    local long = sel(x1 < x2, x2-x1+1, y2-y1+1)

    local function check_stair_pos(pos, w)

      local x, y = x1 + ax*pos, y1 + ay*pos
      assert(K.x1 <= x and x <= K.x2)
      assert(K.y1 <= y and y <= K.y2)

      for h = want_deep,1,-1 do
        local able = true

        local sx, sy = x1 + ax*pos, y1 + ay*pos
        local ex, ey = sx + (h-1)*dx + (w-1)*ax, sy + (h-1)*dy + (w-1)*ay

        local st_x1 = math.min(sx,ex)
        local st_y1 = math.min(sy,ey)
        local st_x2 = math.max(sx,ex)
        local st_y2 = math.max(sy,ey)

        if (ex < K.x1 or ex > K.x2) or
           (ey < K.y1 or ey > K.y2)
        then
          able = false
        else

          assert(K.x1 <= st_x1 and st_x2 <= K.x2)
          assert(K.y1 <= st_y1 and st_y2 <= K.y2)

          -- first: check stair itself
          for qx = st_x1,st_x2 do for qy = st_y1,st_y2 do
            local B = p.blocks[qx][qy]
            assert(B)
---???      if not B.empty or B.walk or not is_roomy(B.chunk)
            if B.walk or not is_roomy(B.chunk)
            then
              able = false
            end
          end end

          -- second: check walkable ends
          for i = 0,w-1 do
            local qx, qy = sx + i*ax -   dx, sy + i*ay -   dy
            local rx, ry = sx + i*ax + h*dx, sy + i*ay + h*dy

            assert(c.bx1 <= qx and qx <= c.bx2)
            assert(c.by1 <= qy and qy <= c.by2)

            if not (c.bx1 <= rx and rx <= c.bx2 and
                    c.by1 <= ry and ry <= c.by2)
            then
              able = false

            elseif behind_K and behind_K.stair_dir and
               (behind_K.x1 <= rx and rx <= behind_K.x2) and
               (behind_K.y1 <= ry and ry <= behind_K.y2)
            then
              able = false

            else
              local B1 = p.blocks[qx][qy]
              local B2 = p.blocks[rx][ry]
              assert(B1)
              assert(B2)

              if (B1.solid or B1.f_tex) or not is_roomy(B1.chunk) or
                 (B2.solid or B2.f_tex) or not is_roomy(B2.chunk)
              then
                able = false
              end
            end
          end
        end

        if able then
          local info = { x=x, y=y, sx=st_x1,sy=st_y1,ex=st_x2,ey=st_y2, pos=pos, long=w, deep=h, score=0 }

          if h == want_deep then info.score = 400
          elseif h >= min_deep then info.score = 200
          end

          if not (pos == 0 and side1_K and side1_K.stair_dir) and
             not (pos+w == long and side2_K and side2_K.stair_dir)
          then
            info.score = info.score + 100
          end

          info.score = info.score + math.min(w-1,4) * 10

          -- deadlock breaker
          info.score = info.score + con.random()

          return info
        end          
      end

      return nil
    end

    -- find_stair_loc --

    local best

    for pos = 0,long-1 do
      for w = 1,long-pos do
        info = check_stair_pos(pos, w)
        if info and (not best or info.score > best.score) then
          best = info
        end
      end
    end

    if not best then
      -- Fuck!
      error("Unable to find stair position!")
    end

    return best
  end
  
  local function build_stair_chunk(c, K)
    local kx,ky = K.kx, K.ky
    local dx,dy = dir_to_delta(K.stair_dir)
    local ax,ay = dir_to_across(K.stair_dir)

    assert(1<=kx+dx and kx+dx<=3)
    assert(1<=ky+dy and ky+dy<=3)

    local J = c.chunks[kx+dx][ky+dy]
    local diff_h = K.rmodel.f_h - J.rmodel.f_h
    local max_fh = math.max(K.rmodel.f_h, J.rmodel.f_h)

    local behind_K
    if (1<=kx-dx and kx-dx<=3) and
       (1<=ky-dy and ky-dy<=3)
    then
      behind_K = c.chunks[kx-dx][ky-dy]
    end

    local function side_is_bad(dir)
      local kdx,kdy = dir_to_delta(dir)
      local nx,ny   = kx+kdx, ky+kdy
      if nx<1 or nx>3 or ny<1 or ny>3 then return nil end
      local N = c.chunks[nx][ny]
      if not N.stair_dir then return nil end
      if N.stair_dir ~= (10-dir) then return nil end
      return N
    end
    
    local side1_K, side2_K

    if K.stair_dir==2 or K.stair_dir==8 then
      side1_K = side_is_bad(4)
      side2_K = side_is_bad(6)
    else
      side1_K = side_is_bad(2)
      side2_K = side_is_bad(8)
    end

---###  local side1_K, side2_K
---###  if (1<=kx-ax and kx-ax<=3) and
---###     (1<=ky-ay and ky-ay<=3)
---###  then
---###    side1_K = c.chunks[kx-ax][ky-ay]
---###  end
---###  if (1<=kx+ax and kx+ax<=3) and
---###     (1<=ky+ay and ky+ay<=3)
---###  then
---###    side2_K = c.chunks[kx+ax][ky+ay]
---###  end

con.debugf("Building stair @ (%d,%d) chunk [%d,%d] dir:%d\n", c.x, c.y, kx,ky, K.stair_dir)
con.debugf("  Chunk: (%d,%d)..(%d,%d)\n", K.x1,K.y1, K.x2,K.y2)

    local info = find_stair_loc(K, behind_K,side1_K,side2_K, stair_depths(diff_h))

    -- failsafe
    if not info then return end

    local step = -diff_h / (info.deep * 4)

if true then
con.debugf("  Stair coords: (%d,%d)..(%d,%d) size:%dx%d\n", info.sx,info.sy, info.ex,info.ey, info.long, info.deep)
--gap_fill(p,c, info.sx,info.sy, info.ex,info.ey, K.rmodel, { light=255, kind=8 })
--else
    if math.abs(step) <= 16 then
    
      B_stair(p,c, info.sx,info.sy, K.rmodel.f_h, K.stair_dir,
              info.long, info.deep, step)
    else
      B_lift(p,c, info.sx,info.sy, max_fh, K.stair_dir,
             info.long, info.deep)
    end
end
    -- reserve space vor und hinter the staircase
    do
    local dx,dy = dir_to_delta(K.stair_dir)

    local x1,y1,x2,y2 = side_coords(K.stair_dir, info.sx,info.sy,info.ex,info.ey)
    mark_walkable_area(c, x1+dx,y1+dy, x2+dx,y2+dy)

    local x3,y3,x4,y4 = side_coords(10-K.stair_dir, info.sx,info.sy,info.ex,info.ey)
    mark_walkable_area(c, x3-dx,y3-dy, x4-dx,y4-dy)
    end
  end

  local function build_stairs(c)

    local chunk_list = sort_stair_chunks(c)
    
    for i = 1,#chunk_list do
      local K = chunk_list[i]
      if K.stair_dir then
        build_stair_chunk(c, K)
      end
    end
  end


  local function find_fab_loc(c, long, deep)

    local dir = 8
    if rand_odds(50) then long,deep,dir = deep,long,4 end
    if rand_odds(50) then dir = 10-dir end

    -- FIXME: TEMP CRUD

    for x = c.bx1,c.bx2 do for y = c.by1,c.by2 do
      if check_fab_position(c, x,y, x+long-1, y+deep-1) then
        return x,y,dir
      end
    end end
  end
  
  local function add_object(c, name)
    local x,y,dir = find_fab_loc(c, 1, 1)
    if not x then
      show_cell_blocks(p,c)
      error("Could not find place for: " .. name)
    end
con.printf("add_object @ (%d,%d)\n", x, y)
    gap_fill(p,c, x,y, x,y, p.blocks[x][y].chunk.rmodel, { light=255, kind=8 })
    add_thing(p, c, x, y, name, true)
    mark_fab_walk(c, x,y, x,y)
  end

  local function add_player(c, name)
    add_object(c, name);
  end

  local function add_dm_weapon(c)
    add_object(c, choose_dm_thing(THEME.dm.weapons, true))
  end

  local function add_switch(c)
    -- FIXME
  end

  local function add_scenery(c)
    -- FIXME !!!! prefabs | scenery items

fab = PREFABS["PILLAR_LIGHT1"]
assert(fab)
local x,y,dir = find_fab_loc(c, fab.long, fab.deep)
if x and rand_odds(30) then
  skin = { beam = "METAL", beam_f = "CEIL5_2",
           light="LITE5" }

  parm = { floor = c.rmodel.f_h, --!!! wrong
           ceil  = c.rmodel.c_h,
         }

  B_prefab(p,c, fab,skin,parm, c.theme, x, y, dir)
end

fab = PREFABS["BILLBOARD"]
assert(fab)
local x,y,dir = find_fab_loc(c, fab.long, fab.deep)
if x and rand_odds(30) then

  skin = {
           corner = "WOOD7", corn_f = "FLAT5_1",
           step   = "STEP5", step_f = "FLAT5_2",
--           corner = "SHAWN2", corn_f = "FLAT19",
--           step = "STEP4",    step_f = "FLAT19",
           pic = "ZZWOLF13", pic_back = "ZZWOLF11", pic_f = "FLAT5_3"
         }

  parm = { floor = c.rmodel.f_h,
           ceil  = c.rmodel.c_h,
           pic_h = c.rmodel.f_h + 128,
           corn_h = c.rmodel.f_h + 104
         }

  B_prefab(p,c, fab,skin,parm, c.theme, x, y, dir)
end

fab = PREFABS["TECH_PICKUP_LARGE"]
assert(fab)
local x,y,dir = find_fab_loc(c, fab.long, fab.deep)
if x and rand_odds(30) then

  skin = { wall="STONE2", floor="CEIL5_2", ceil="CEIL3_5",
           light="LITE5", sky="F_SKY1",
           step="STEP1", carpet="FLOOR1_1",
         }

  parm = { floor = c.rmodel.f_h,
           ceil  = c.rmodel.c_h,
         }

  B_prefab(p,c, fab,skin,parm, c.theme, x, y, dir)
end

fab = PREFABS["BILLBOARD_LIT"]
assert(fab)
local x,y,dir = find_fab_loc(c, fab.long, fab.deep)
if x and rand_odds(30) then
  skin = {
--           corner = "WOOD7", corn_f = "FLAT5_1",
--           step   = "STEP5", step_f = "FLAT5_2",
           corner = "SHAWN2", corn_f = "FLAT19", corn2="DOORSTOP",
           step = "STEP4",    step_f = "CEIL3_5",
           pic = "SHAWN1", pic_back = "SHAWN2", pic_f = "CEIL3_5",
           light = "LITE5"
         }

  parm = { floor = c.rmodel.f_h,
           ceil  = c.rmodel.c_h,
           pic_h = c.rmodel.f_h + 88,
           corn_h = c.rmodel.f_h + 112
         }

  B_prefab(p,c, fab,skin,parm, c.theme, x, y, dir)
return
end

fab = PREFABS["STATUE_TECH_1"]
assert(fab)
local x,y,dir = find_fab_loc(c, fab.long, fab.deep)

if x and rand_odds(30) then

  skin = { wall="COMPWERD", comp1 = "SPACEW3", comp2 = "COMPTALL",
           step="STEP1",    u_span="COMPSPAN",

           floor="FLAT14", ceil="FLOOR4_8",
           carpet="FLOOR1_1", c_lite="TLITE6_5",
           comp_top="CEIL5_1",

           thing1="lamp"
         }

  parm = { floor = c.rmodel.f_h,
           ceil  = c.rmodel.c_h,
         }

  B_prefab(p,c, fab,skin,parm, c.theme, x, y, dir)
end

fab = PREFABS["GROUND_LIGHT"]
assert(fab)
if x and rand_odds(30) then

  skin = { 
           shawn = "SHAWN3",
           light = "LITE5",         

           shawn_top = "FLAT1",
           lite_top = "CEIL5_1",
         }

  parm = { floor = c.rmodel.f_h,
           ceil  = c.rmodel.c_h,
         }

  B_prefab(p,c, fab,skin,parm, c.theme, x, y, dir)
end

    
    if c.theme.scenery then
      local item = c.theme.scenery
      if type(item) == "table" then
        item = rand_element(item)
      end
      assert(item)

      local x,y,dir = find_fab_loc(c, 1, 1)
      if not x then return end

      gap_fill(p,c, x,y, x,y, p.blocks[x][y].chunk.rmodel)
      add_thing(p, c, x, y, item, true)
      mark_fab_walk(c, x,y, x,y)
    end
  end

  local function tizzy_up_room(c)

    -- the order here is important, earlier items may cause
    -- later items to no longer fit.

    -- PLAYERS
    if not p.deathmatch and c == p.quests[1].first then
      for i = 1,sel(settings.mode == "coop",4,1) do
        add_player(c, "player" .. tostring(i))
      end

    elseif p.deathmatch and (c.require_player or rand_odds(50)) then
      add_player(c, "dm_player")
    end

    if p.deathmatch and c.x==2 and not p.have_sp_player then
      add_player(c, "player1")
      p.have_sp_player = true
    end

    -- QUEST ITEM
    if not p.deathmatch and c == c.quest.last then
      if (c.quest.kind == "key") or
         (c.quest.kind == "weapon") or
         (c.quest.kind == "item")
      then
        add_object(c, c.quest.item)
      else
        add_switch(c)
      end
    elseif p.deathmatch and (c.require_weapon or rand_odds(75)) then
      add_dm_weapon(c)
    end

    -- TODO: 'room switch'

    if p.deathmatch then
      -- secondary DM PLAYER
      if rand_odds(30) then
        add_object(c, "dm_player")
      end
      -- secondary DM WEAPON
      if rand_odds(15) then
        add_dm_weapon(c)
      end
    end

    -- SCENERY
    for loop = 1,20 do
--!!!!     add_scenery(c)
    end

  end

  ---=== build_cell ===---

  if c.scenic == "solid" then
    fill(p,c, c.bx1, c.by1, c.bx2, c.by2, { solid=c.theme.void })
    return
  end

  decide_sky_lights(c)

  build_void_space(c)
  build_vistas(c)

  mark_links(c)

  build_stairs(c)

  tizzy_up_room(c)

-- !!!!  position_dm_stuff(cell)  MOVE_TO: monster.lua

if c == p.quests[1].first then

if false then
  fab = PREFABS["DRINKS_BAR"]
  assert(fab)

  skin = { bar_w   = "PANBORD1", bar_f = "FLAT5_2",
           drink   = "potion",
         }

  parm = { floor = c.rmodel.f_h,
           ceil  = c.rmodel.c_h,
         }

  B_prefab(p,c, fab,skin,parm, c.theme, c.bx1+1, c.by1+1, 2)
end

if false then
  fab = PREFABS["MEGA_SKYLIGHT_2"]
  assert(fab)

  skin = { 
           sky = "F_SKY1",
           frame = "METAL",
           frame_ceil = "CEIL5_2",

           --!! beam = "METAL",
           --!! beam_ceil  = "CEIL5_2",
           beam = "WOOD12",
           beam_ceil = "FLAT5_2",
         }

  parm = { floor = c.rmodel.f_h,
           ceil  = c.rmodel.c_h,
         }

  B_prefab(p,c, fab,skin,parm, c.theme, c.bx1+1, c.by1+6, 4)
end

end -- if c.x==XX

end

function build_rooms(p)

  local function create_blocks(p, c)
    
    for kx=1,3 do for ky=1,3 do
      local K = c.chunks[kx][ky]
      for x = K.x1,K.x2 do for y = K.y1,K.y2 do
        p.blocks[x][y] = { chunk = K }
      end end
    end end
  end

  
  local function GAP_FILL_ROOM(p, c)
    
    local function gap_fill_block(B)
      if B.solid then return end

      local model = c.rmodel
      if B.chunk then model = B.chunk.rmodel end

      -- floor
      if not B.f_tex then
        B.f_tex = model.f_tex
        B.f_h   = model.f_h
        B.l_tex = model.l_tex
      end

      -- ceiling
      if not B.c_tex then
        B.c_tex = model.c_tex
        B.c_h   = model.c_h
        B.u_tex = model.u_tex
      end

      -- lighting
      if not B.light then
        B.light = model.light
      end
    end

    -- GAP_FILL_ROOM --

    for x = c.bx1,c.bx2 do for y = c.by1,c.by2 do
      local B = p.blocks[x][y]

      if B.fragments then
        for fx = 1,FW do for fy = 1,FH do
          local F = B.fragments[fx][fy]
          gap_fill_block(B.fragments[fx][fy])
        end end
      else
        gap_fill_block(B)
      end
    end end
  end

  -- build_rooms --

  for zzz,cell in ipairs(p.all_cells) do
    create_blocks(p, cell)
  end

  for zzz,cell in ipairs(p.all_cells) do
    build_cell(p, cell)
  end

  for zzz,cell in ipairs(p.all_cells) do
    GAP_FILL_ROOM(p, cell)
  end
end

function build_depots(p)

  local function build_one_depot(p, c)

    setup_rmodel(p, c)

    c.bx1 = BORDER_BLK + (c.x-1) * (BW+1) + 1
    c.by1 = BORDER_BLK + (c.y-1) * (BH+1) + 1

    c.bx2 = c.bx1 + BW - 1
    c.by2 = c.by1 + BW - 1

    local depot = c.quest.depot
    assert(depot)

    local places = depot.places
    assert(#places >= 2)
    assert(#places <= 4)

    local start = p.quests[1].first
  --!!!!
  --[[
    assert(start.player_pos)
    local player_B = p.blocks[start.player_pos.x][start.player_pos.y]
  --]] local player_B = start.rmodel

    -- check for double pedestals (Plutonia)
    if player_B.fragments then
      player_B = player_B.fragments[1][1]
    end
    assert(player_B)
    assert(player_B.f_h)

    local sec = { f_h = player_B.f_h, c_h = player_B.f_h + 128,
                  f_tex = c.rmodel.f_tex, c_tex = c.rmodel.c_tex,
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
      c_fill(p, c, 1,y*2-1, BW,y*2, mon_sec, { mark=y })
      places[y].spots = rectangle_to_spots(c, c.bx1-1+m1, c.by1-1+y*2-1,
            c.bx1-1+m1+0, c.by1-1+y*2)

      for x = t1,t2 do
        local t = 1 + ((x + y) % #places)
        c_fill(p, c, x,y*2-1, x,y*2, tele_sec, { mark=x*10+y, walk_tag=places[t].tag})
      end
    end

    -- door separating monsters from teleporter lines
    c_fill(p, c, 5,1, 5,2*#places, door_sec)

    -- bottom corner block is same sector as player start,
    -- to allow sound to wake up these monsters.
    c_fill(p, c, m1,1, m1,1, copy_block(player_B), { same_sec=player_B })

    -- put a border around the room
    gap_fill(p, c, c.bx1-1, c.by1-1, c.bx2+1, c.by2+1, { solid=c.theme.wall })
  end

  --- build_depots ---

  for zzz,cell in ipairs(p.all_depots) do
    build_one_depot(p, cell)
  end
end


function build_level(p)

  for zzz,cell in ipairs(p.all_cells) do
    setup_rmodel(p, cell)
  end

if string.find(p.lev_name, "L10") then
build_pacman_level(p, p.quests[1].first);
return
end

  make_chunks(p)
  con.ticker()

  show_chunks(p)

  build_rooms(p)
  con.ticker()

  build_borders(p)
  con.ticker()

  build_depots(p)
  con.ticker()

  con.progress(25); if con.abort() then return end
 
  if p.deathmatch then
    deathmatch_through_level(p)
  else
    battle_through_level(p)
  end

  con.progress(40); if con.abort() then return end
end

