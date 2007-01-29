----------------------------------------------------------------
-- LEVEL WRITER (Doom, Heretic and Hexen)
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

private class Vertex
  index : number in WAD (starts at 0)
  x, y
  refcount : number
  index
end

private class Sector
  f_h, c_h      : floor/ceil heights
  f_tex, c_tex  : floor/ceil textures

  light : 0 to 255
  tag   : tag number -- optional

  index : number -- only set when writing
end

private class Sidedef
  upper, mid, lower : textures  -- optional
  x_offset, y_offset
  sector : Sector
end

private class Linedef
  v1, v2 : start/end Vertex refs
  front, back : Sidedefs
  flags : number
end

--]]


-- thing flags
MTF_EASY    = 1
MTF_MEDIUM  = 2
MTF_HARD    = 4
MTF_AMBUSH  = 8

-- hexen thing flags
XTF_FIGHTER = 32
XTF_CLERIC  = 64
XTF_MAGE    = 128
XTF_SP      = 256
XTF_COOP    = 512
XTF_DM      = 1024

-- linedef flags
ML_IMPASSABLE  = 1
ML_NO_MONSTER  = 2
ML_TWO_SIDED   = 4
ML_UPPER_UNPEG = 8
ML_LOWER_UNPEG = 16
ML_SECRET      = 32
ML_BLOCK_SOUND = 64
ML_MAPPED      = 128

-- hexen linedef flags
XL_REPEATABLE  = 512
XL_ACT_WALK    = (0 * 1024)
XL_ACT_USE     = (1 * 1024)
XL_ACT_MONSTER = (2 * 1024)
XL_ACT_SHOOT   = (3 * 1024)
XL_ACT_BUMP    = (4 * 1024)


function write_level(p, lev_name)
 
  local sec_list   = {}
  local vert_list  = {}
  local line_list  = {}
  local thing_list = {}

  local total_sec   = 0
  local total_vert  = 0
  local total_side  = 0

  local vert_map = {}  -- acting as a set.  key is string "%d:%d" | value is index
  local vert_num = 0

  local sec_map = {}
  local total_group = 0

  local tx_file  -- text mode output

  local DUMMY_BLOCK = { solid=THEME.ERROR_TEX }


  local function FRAGMENT_X(x) return (x-1-(BORDER_BLK+0)*FW)*16 end
  local function FRAGMENT_Y(y) return (y-1-(BORDER_BLK+0)*FH)*16 end

  local function BLOCK_X(x) return FRAGMENT_X((x-1)*FW + 1) end
  local function BLOCK_Y(y) return FRAGMENT_Y((y-1)*FH + 1) end

  local function NORMALIZE(n) return math.floor(n * 1.0) end


  local function make_mini_map()

    con.map_begin(p.blk_w, p.blk_h)

    for by = p.blk_h,1,-1 do
      for bx = 1,p.blk_w do
        local B = p.blocks[bx][by]
        if not B then con.map_pixel(0)
        elseif B.solid then con.map_pixel(1)
        elseif B.kind  then con.map_pixel(4)
        elseif B.c_tex == THEME.SKY_TEX then con.map_pixel(3)
        else con.map_pixel(2)
        end
      end
    end

    con.map_end()
  end

  local function construct_things()

    local function do_thing(bx, by, th)
      th.x = BLOCK_X(bx + 0.5) + (th.dx or 0)
      th.y = BLOCK_Y(by + 0.5) + (th.dy or 0)

      if th.options then
        th.flags = 0
        if th.options.easy   then th.flags = th.flags + MTF_EASY end
        if th.options.medium then th.flags = th.flags + MTF_MEDIUM end
        if th.options.hard   then th.flags = th.flags + MTF_HARD end
        if th.options.ambush then th.flags = th.flags + MTF_AMBUSH end
      end

      table.insert(thing_list, th)
    end

    --- construct_things ---

    for bx = 1,p.blk_w do
      for by = 1,p.blk_h do
        local B = p.blocks[bx][by]
        if B and B.things then
          for zzz,th in ipairs(B.things) do
            do_thing(bx, by, th)
          end
        end
      end
    end
  end

  local function construct_linedefs()

    local cur_line = nil

    local function create_vertex(x, y)
      local str = string.format("%d:%d", x, y)
      local index

      if vert_map[str] then
        index = vert_map[str]
        local V = vert_list[index]
        V.refcount = V.refcount + 1
        return V
      end

      index = vert_num
      vert_num = vert_num + 1

      local V = { x=x, y=y, refcount=1 }
      vert_list[index] = V
      vert_map[str] = index
      return V
    end

    local function is_step(tex)
      return tex and string.find(tex, "^STEP")
    end

---###    local function get_override(block, dir)
---###      return block and block.overrides and block.overrides[dir]
---###    end

    local function push_line()
      if not cur_line then return end

      assert(cur_line.front)

      -- swap vertices for backward lines
      if cur_line.norm == 4 or cur_line.norm == 8 then
        cur_line.sx, cur_line.ex = cur_line.ex, cur_line.sx
        cur_line.sy, cur_line.ey = cur_line.ey, cur_line.sy
      end

      cur_line.v1 = create_vertex(cur_line.sx, cur_line.sy)
      cur_line.v2 = create_vertex(cur_line.ex, cur_line.ey)

      table.insert(line_list, cur_line)

      cur_line = nil
    end

    local function create_sidedef(f, b, norm, sx, sy) 
      if f.solid then return nil end

      local SIDE = { block=f }

      local b_over = b[norm]    or DUMMY_BLOCK
      local f_over = f[10-norm] or DUMMY_BLOCK

      -- set textures
      if b.solid then
        SIDE.mid = b_over.l_tex or b.solid
      else
        SIDE.upper = b_over.u_tex or b.u_tex or THEME.ERROR_TEX
        SIDE.lower = b_over.l_tex or b.l_tex or THEME.ERROR_TEX
        SIDE.mid   = b_over.rail  or f_over.rail or b.rail or f.rail
      end

      SIDE.x_offset = b_over.x_offset or b.x_offset
      SIDE.y_offset = b_over.y_offset or b.y_offset

      return SIDE
    end

    local function compute_line_flags(f,b, f_side,b_side, norm)
      local flags = 0

      local b_over = b[norm]    or DUMMY_BLOCK
      local f_over = f[10-norm] or DUMMY_BLOCK

      if not b.solid then

        flags = flags + ML_TWO_SIDED

        -- railing textures (assume blocking)
        if f_side.mid or b_side.mid then
          flags = flags + ML_LOWER_UNPEG + ML_IMPASSABLE

        elseif not b.lift_kind and not
          -- FIXME: remove special check on texture name!
          (is_step(b_side.lower) or is_step(f_side.lower)) then
          flags = flags + ML_LOWER_UNPEG
        end

        if not b.door_kind then
          flags = flags + ML_UPPER_UNPEG
        end

      else  -- one sided --

        flags = flags + ML_IMPASSABLE

        if f.door_kind or b.switch_kind then
          flags = flags + ML_LOWER_UNPEG
        end
      end

      -- sound blocking.  Note some subtlety here, when (count == 1)
      -- we only want a single edge to block, for (count == 2) we
      -- allow all edges to block sound.
      local w = sel(norm < 5, f, b)
      if (w.block_sound == 1) or
         (f.block_sound == 2) or
         (b.block_sound == 2)
      then
        flags = flags + ML_BLOCK_SOUND
      end

      if b_over.block_mon or f_over.block_mon then
        flags = flags + ML_NO_MONSTER
      end

      return flags
    end

    
    local function new_group()
      total_group = total_group + 1
      return { id=total_group }
    end

    local function merge_groups(g, h)
      
      if g == h then return end

      -- simplify pointer chains
      while g.ptr and g.ptr.ptr do g.ptr = g.ptr.ptr end
      while h.ptr and h.ptr.ptr do h.ptr = h.ptr.ptr end

      if g.ptr then assert(g.id >= g.ptr.id); g.id = g.ptr.id end
      if h.ptr then assert(h.id >= h.ptr.id); h.id = h.ptr.id end

      if g.id > h.id then
        if g.ptr then g.ptr.ptr = h end
        g.ptr = h

      elseif g.id < h.id then
        if h.ptr then h.ptr.ptr = g end
        h.ptr = g

      else
        -- already the same!
      end
    end

    local function same_sector(b1, b2)

      return (not b1.solid == not b2.solid) and
             (b1.f_h   == b2.f_h) and
             (b1.c_h   == b2.c_h) and
             (b1.f_tex == b2.f_tex) and
             (b1.c_tex == b2.c_tex) and
             (b1.light == b2.light) and
             (b1.tag   == b2.tag) and
             (b1.kind  == b2.kind) and
             (b1.mark  == b2.mark) and
             (b1.same_sec == b2.same_sec)
    end

    local function same_sector_w_merge(b1, b2)

      if b1 == b2 then return true end

---###  if not b1 or not b2 then return false end
      
      if b1.group and b2.group and (b1.group.id == b2.group.id) then
        return true
      end

      if b1.same_sec and b1.same_sec == b2.same_sec then
        return true
      end

      if same_sector(b1, b2) then
        if b1.group and b2.group then
          merge_groups(b1.group, b2.group)
        elseif b2.group and not b1.group then
          b1.group = b2.group
        elseif b1.group and not b2.group then
          b2.group = b1.group
        else  -- neither has a group yet
          b1.group = new_group()
          b2.group = b1.group
        end

        return true

      else  -- not same sector

        -- we DONT create new groups here, since there is a very
        -- good chance that the block will share a group later.
        --
        -- THIS MEANS: singleton blocks (no matching neighbour)
        -- will never get a 'group' field.
 
        return false
      end
    end

    local function match_sidedefs(s1, s2)
      if not s1 or not s2 then return s1 == s2 end

      -- Note: no need to check sector/block reference

      return
         (s1.lower == s2.lower) and
         (s1.upper == s2.upper) and
         (s1.mid   == s2.mid) and
         (s1.x_offset == s2.x_offset) and
         (s1.y_offset == s2.y_offset)
    end

    local function line_length(L)
      local dx = L.ex - L.sx
      local dy = L.ey - L.sy
      return int(math.sqrt(dx*dx + dy*dy) + 0.5)
    end

    local function frag_pair(f,b,norm, x,y,dx,dy)

      if f == b then
        return push_line()
      end

      if not f then f = DUMMY_BLOCK end
      if not b then b = DUMMY_BLOCK end

      if f.solid and b.solid then
        return push_line()
      end

      if same_sector_w_merge(f, b) then
        return push_line()
      end

      -- linedefs must have a front, flip if needed.
      -- Also some lines need to face out (doors)
      if f.solid or
        (not b.solid and (f.door_kind or f.lift_kind or f.switch_kind))
      then
        norm = 10 - norm
        f, b = b, f
      end

      assert(not f.solid)

      local f_side = create_sidedef(f, b, norm)
      local b_side = create_sidedef(b, f, 10-norm)

      local flags = compute_line_flags(f,b, f_side,b_side, norm)

      local sx = FRAGMENT_X(x)
      local sy = FRAGMENT_Y(y)
      local ex = FRAGMENT_X(x + dx)
      local ey = FRAGMENT_Y(y + dy)

      if cur_line then
        local f_same = same_sector_w_merge(cur_line.f_block, f)
        local b_same = same_sector_w_merge(cur_line.b_block, b)
      
         if f_same and b_same and
            cur_line.norm  == norm and
            cur_line.flags == flags and
            match_sidedefs(cur_line.front, f_side) and
            match_sidedefs(cur_line.back,  b_side)
        then
          if not (f.short or b.short or cur_line.short) then
            -- simply extend current line
            cur_line.ex, cur_line.ey = ex, ey
            return
          end
        end
      end

      push_line()

      cur_line =
      {
        norm  = norm,
        flags = flags,

        f_block = f,
        b_block = b,

        front = f_side,
        back  = b_side,

        short = f.short or b.short,

        sx = sx, sy = sy,
        ex = ex, ey = ey,

        kind = not b.solid and (b.door_kind or b.lift_kind)
      }

      if not b.solid and b.lift_kind then
        cur_line.tag = b.tag

        if b.lift_walk and (b.f_h == f.f_h) then
          cur_line.kind = b.lift_walk
        end
      end

      if b.switch_kind then
        cur_line.kind = b.switch_kind
        cur_line.tag  = b.switch_tag

      elseif ((f.walk_kind ~= b.walk_kind) or (f.walk_tag ~= b.walk_tag))
             and not b.solid and not cur_line.kind
             and not (b.near_switch or f.near_switch)
      then
        if f.walk_kind then
          cur_line.kind = f.walk_kind
          cur_line.tag  = f.walk_tag
        else
          cur_line.kind = b.walk_kind
          cur_line.tag  = b.walk_tag
        end
      end
    end

    --==-- construct_linedefs --==--

    local frag_w = p.blk_w * FW
    local frag_h = p.blk_h * FH

    -- first do all horizontal lines...
    -- Note: we go ONE PAST the right/top edges.
    local x, y

    for y = 1,frag_h+1 do
      x = 1; while x <= frag_w do

        local bx,  fx  = div_mod(x, FW)
        local by0, fy0 = div_mod(y-1, FH)
        local by1, fy1 = div_mod(y, FH)

        local b0 = p.blocks[bx] and p.blocks[bx][by0]
        local b1 = p.blocks[bx] and p.blocks[bx][by1]

        local f0 = b0 and b0.fragments and b0.fragments[fx][fy0]
        local f1 = b1 and b1.fragments and b1.fragments[fx][fy1]

        if b0 and not b0.fragments then f0 = b0 end
        if b1 and not b1.fragments then f1 = b1 end

        local count = 1
        if f0 == b0 and f1 == b1 then count = 4 end

        frag_pair(f0,f1,2, x,y,count,0)

        x = x + count
      end

      con.ticker()
      push_line()
    end

print("TOTAL_GROUPS ", total_group)

    con.progress(75); if con.abort() then return end

    -- now do all vertical lines...

    for x = 1,frag_w+1 do
      y = 1; while y <= frag_h do

        local by,  fy  = div_mod(y, FH)
        local bx0, fx0 = div_mod(x-1, FW)
        local bx1, fx1 = div_mod(x, FW)

        local b0 = p.blocks[bx0] and p.blocks[bx0][by]
        local b1 = p.blocks[bx1] and p.blocks[bx1][by]

        local f0 = b0 and b0.fragments and b0.fragments[fx0][fy]
        local f1 = b1 and b1.fragments and b1.fragments[fx1][fy]

        if b0 and not b0.fragments then f0 = b0 end
        if b1 and not b1.fragments then f1 = b1 end

        local count = 1
        if f0 == b0 and f1 == b1 then count = 4 end

        frag_pair(f1,f0,6, x,y,0,count)

        y = y + count
      end

      con.ticker()
      push_line()
    end
print("TOTAL_GROUPS ", total_group)
  end

  local function adjust_vertices()

    local function v_adjust(x, y, adj)
      local str = string.format("%d:%d", x, y)
      local V = vert_map[str]
      if V then
        vert_list[V].dx = adj.dx
        vert_list[V].dy = adj.dy
      end
    end

    local function do_block(B, fx, fy, d)

      local x = FRAGMENT_X(fx)
      local y = FRAGMENT_Y(fy)

      if B[1] then v_adjust(x,   y,   B[1]) end
      if B[3] then v_adjust(x+d, y,   B[3]) end
      if B[7] then v_adjust(x,   y+d, B[7]) end
      if B[9] then v_adjust(x+d, y+d, B[9]) end
    end

    -- adjust_vertices --

    for bx = 1,p.blk_w do
      for by = 1,p.blk_h do
        local B = p.blocks[bx][by]
        if B and B.fragments then
          for fx=1,4 do for fy=1,4 do
            local F = B.fragments[fx][fy]
            if F then
              do_block(F, (bx-1)*4+fx, (by-1)*4+fy, 16)
            end
          end end
        elseif B then
          do_block(B, bx*4-3, by*4-3, 64)
        end
      end
    end
  end

  local function create_sector(B)
    if B.solid then return nil end

    if B.new_sec then return B.new_sec end

    if B.same_sec then return create_sector(B.same_sec) end

    local singleton = not B.group

    if B.group then
      while B.group.ptr do B.group = B.group.ptr end

      if sec_map[B.group.id] then return sec_map[B.group.id] end
    end

    SECT =
    {
      f_h = B.f_h,
      c_h = B.c_h,
      f_tex = B.f_tex,
      c_tex = B.c_tex,
      tag = B.tag,
      light = B.light,
      kind = B.kind,

      T_index = #sec_list
    }

    B.new_sec = SECT

    if B.group then sec_map[B.group.id] = SECT end

    table.insert(sec_list, SECT)

    return SECT
  end

  local function construct_sectors()

    for zzz,L in ipairs(line_list) do
      if L.front and L.front.block then
        L.front.sector = create_sector(L.front.block)
      end
      if L.back and L.back.block then
        L.back.sector = create_sector(L.back.block)
      end
    end
  end
  
  local function write_vertex(vert)

    vert.index = total_vert
    total_vert = total_vert + 1

    if vert.dx then vert.x = vert.x + vert.dx end
    if vert.dy then vert.y = vert.y + vert.dy end

    wad.add_vertex(NORMALIZE(vert.x), NORMALIZE(vert.y))
  end

  local function write_sector(sec)

    sec.index = total_sec
    total_sec = total_sec + 1

    wad.add_sector(sec.f_h, sec.c_h,
      sec.f_tex or THEME.ERROR_FLAT,
      sec.c_tex or THEME.ERROR_FLAT,
      sec.light or 0, sec.kind or 0, sec.tag or 0)
  end
  
  local function write_sidedef(sd)

    sd.index = total_side
    total_side = total_side + 1

    if not sd.sector.index then
      write_sector(sd.sector)
    end

    wad.add_sidedef(sd.sector.index,
      sd.lower or "-", sd.mid   or "-", sd.upper or "-",
      sd.x_offset or 0, sd.y_offset or 0)
  end

  local function write_linedefs()

    for zzz,L in ipairs(line_list) do
      con.ticker()

      if not L.v1.index then write_vertex(L.v1) end
      if not L.v2.index then write_vertex(L.v2) end
      
      if L.front and not L.front.index then
        write_sidedef(L.front)
      end
      if L.back  and not L.back.index  then
        write_sidedef(L.back)
      end
    
      wad.add_linedef(L.v1.index, L.v2.index,
            L.front and L.front.index or -1,
            L.back  and L.back.index  or -1,
            L.kind or 0, L.flags or 0, L.tag or 0, L.args);
    end
  end

  local function write_things()
    
    for zzz,th in pairs(thing_list) do

      wad.add_thing(NORMALIZE(th.x), NORMALIZE(th.y), th.z or 0,
            th.kind, th.angle or 0, th.flags or 7);
    end
  end

  ---- TEXT MODE ---------------

  local function T_write_vertexes()
    tx_file:write("VERTEXES_START\n")

    for IDX,vert in pairs(vert_list) do
      if vert.dx then vert.x = vert.x + vert.dx end
      if vert.dy then vert.y = vert.y + vert.dy end

      vert.index = IDX-1
      tx_file:write(
        string.format("V%d : %d %d\n", vert.index,
          NORMALIZE(vert.x), NORMALIZE(vert.y)))
    end

    tx_file:write("VERTEXES_END\n")
  end
  
  local function T_write_sectors()
    tx_file:write("SECTORS_START\n")

    for IDX,sec in ipairs(sec_list) do

      sec.index = IDX-1
      tx_file:write(
        string.format("S%d : %d %d %s %s %d %d %d\n",
          sec.T_index, sec.f_h, sec.c_h,
          sec.f_tex or THEME.ERROR_FLAT,
          sec.c_tex or THEME.ERROR_FLAT,
          sec.light or 0, sec.kind or 0, sec.tag or 0))
    end

    tx_file:write("SECTORS_END\n")
  end
  
    local function T_write_sidedef(sd)
      if sd then
        tx_file:write(
          string.format("   S%d %d %d %s %s %s\n",
            sd.sector.index,
            sd.x_offset or 0,
            sd.y_offset or 0,
            sd.upper or "-",
            sd.lower or "-",
            sd.mid   or "-"))
      else
        tx_file:write("   -\n")
      end
    end

  local function T_write_linedefs()

    tx_file:write("LINEDEFS_START\n")

    for zzz,L in ipairs(line_list) do
      tx_file:write(
        string.format("V%d V%d : %d %d %d\n",
          L.v1.index, L.v2.index,
          L.flags or 0, L.kind or 0, L.tag or 0))

      assert(L.front)

      T_write_sidedef(L.front)
      T_write_sidedef(L.back)
    end
    
    tx_file:write("LINEDEFS_END\n")
  end
  
  local function T_write_things()
    tx_file:write("THINGS_START\n")
    
    for zzz,th in pairs(thing_list) do
      tx_file:write(
        string.format("%d : %d %d %d %d\n",
          th.kind, NORMALIZE(th.x), NORMALIZE(th.y),
          th.angle or 0, th.flags or 7))
    end

    tx_file:write("THINGS_END\n")
  end
--]
--]]

  ---- BEGIN write_level ----

  construct_things()
  
  con.progress(50); if con.abort() then return end
 
  construct_linedefs()
  construct_sectors()

  adjust_vertices()

  if not wad then
    tx_file = io.open("TEMP.txt", "w")
    if not tx_file then error("Unable to create file: TEMP.txt") end
    
    tx_file:write("LEVEL_START 0 1 0 Doom2\n")

    T_write_vertexes()
    T_write_sectors()
    T_write_linedefs()
    T_write_things()

    tx_file:write("LEVEL_END\n")
    tx_file:close()

  else
    con.progress(90); if con.abort() then return end

    if con.map_begin then make_mini_map() end

    wad.begin_level(lev_name);

    write_things()
    write_linedefs()  -- does vert/side/secs along the way

    wad.end_level()

    con.progress(100)
  end
end

