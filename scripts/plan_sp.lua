---------------------------------------------------------------
--  PLANNER : EXPERIMENTAL SHIT
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
require 'room_fabs'


SW = 24
SH = 24

FABS = {}

CONNS = {}



function OLD_OLD_build_fab(r)
  
  local F = assert(r.fab)

  local fw = string.len(F.structure[1])
  local fh = # F.structure

  local col_map = {}
  local row_map = {}


  local function create_mapping(map, fx, rx, grow)

    assert(fx <= rx)

    if fx == rx then
      for i = 1,rx do map[i] = i end
      return
    end

    assert(grow)
    assert(#grow >= 1)

    -- determine how large each column/row will be
    local sizes = {}
    for i = 1,fx do sizes[i] = 1 end

    local g_idx = 1
    local g_tot = fx

    while g_tot < rx do
      local ax = grow[g_idx]
      sizes[ax] = sizes[ax] + 1
      g_tot = g_tot + 1
      g_idx = g_idx + 1
      if g_idx > #grow then g_idx = 1 end
    end

    local idx = 1
    for i = 1,fx do
      for n = 1,sizes[i] do
        map[idx] = i
        idx = idx + 1
      end
    end

    assert(#map == rx)
  end


  --- build_fab ---

  create_mapping(col_map, fw, r.w, F.x_grow)
  create_mapping(row_map, fh, r.h, F.y_grow)

  local sub_dims = {}


  for y = 1,r.h do for x = 1,r.w do
    
    local sx = r.x + x - 1
    local sy = r.y + y - 1

    assert(SEEDS[sx][sy][1].room == nil)

    local mx = col_map[x]
    local my = row_map[y]

    assert(1 <= mx and mx <= fw)
    assert(1 <= my and my <= fh)

    local ch = string.sub(F.structure[my], mx, mx)

    if ch == '.' then
      -- nothing
    else

      local e = F.elements[ch]

      if e == nil then
        error("Unknown element '" .. ch .. "' in room fab")
      end

      assert(e.kind)

      if e.kind == "sub" then

        if not sub_dims[ch] then
          sub_dims[ch] = { x1=99,y1=99,x2=1,y2=1, ch=ch, e=e }
        end

        local D = sub_dims[ch]

        if sx < D.x1 then D.x1 = sx end
        if sx > D.x2 then D.x2 = sx end

        if sy < D.y1 then D.y1 = sy end
        if sy > D.y2 then D.y2 = sy end

      else
        SEEDS[sx][sy][1].room =
        {
          kind = e.kind,
        }

      end

    end -- if ch == '.'
  end end


  -- handle sub areas

  for _,D in pairs(sub_dims) do
    
    local n =
    {
      x = D.x1,
      y = D.y1,

      w = D.x2 - D.x1 + 1,
      h = D.y2 - D.y1 + 1,

      dir = rand_dir(),
    }

    select_room_fab(n)

    table.insert(FABS, n)
  end
end


function pos_adjust(old_w, new_w, x)
  
  if x == 1     then return 1 end
  if x == old_w then return new_w end

  if (old_w % 2) == 1 and (new_w % 2) == 1 then
    if x == (old_w + 1) / 2 then
      return (new_w + 1) / 2
    end
  end
 
  -- lerp it
  return int(1 + (new_w-1)*(x-1)/(old_w-1))
end


function install_loc(F, SZ_IDX, x, y, dir)

  local ow = F.sizes[1].w
  local oh = F.sizes[1].h

  local nw = F.sizes[SZ_IDX].w
  local nh = F.sizes[SZ_IDX].h

  local enter_x = pos_adjust(ow, nw, F.enter_x)


  if dir == 8 then
    x = x - (enter_x - 1)
    return x, y, x+nw-1, y+nh-1

  elseif dir == 2 then
    x = x - (nw - enter_x)
    return x, y-nh+1, x+nw-1, y

  elseif dir == 4 then
    y = y - (enter_x - 1)
    return x-nh+1, y, x, y+nw-1

  else assert(dir == 6)
    y = y - (nw - enter_x)
    return x, y, x+nh-1, y+nw-1
  end
end


function install_room_fab(p)
 
  local F = p.fab
  local x = p.x
  local y = p.y
  local dir = p.dir

  local ow = F.sizes[1].w
  local oh = F.sizes[1].h

  local nw = F.sizes[p.SZ_IDX].w
  local nh = F.sizes[p.SZ_IDX].h

  local enter_x = pos_adjust(ow, nw, F.enter_x)


  local col_map = {}
  local row_map = {}

  local function create_mapping(map, fx, rx, grow)
    assert(fx <= rx)

    if fx == rx then
      for i = 1,rx do map[i] = i end
      return
    end

    assert(grow)
    assert(#grow >= 1)

    -- determine how large each column/row will be
    local sizes = {}
    for i = 1,fx do sizes[i] = 1 end

    local g_idx = 1
    local g_tot = fx

    while g_tot < rx do
      local ax = grow[g_idx]
      sizes[ax] = sizes[ax] + 1
      g_tot = g_tot + 1
      g_idx = g_idx + 1
      if g_idx > #grow then g_idx = 1 end
    end

    local idx = 1
    for i = 1,fx do
      for n = 1,sizes[i] do
        map[idx] = i
        idx = idx + 1
      end
    end

    assert(#map == rx)
  end


  --- install_room_fab ---

  con.debugf("Installing room fab '%s' %dx%d at (%d,%d) dir:%d\n",
             F.name, nw,nh, x, y, dir)

  create_mapping(col_map, ow, nw, F.x_grow)
  create_mapping(row_map, oh, nh, F.y_grow)

  for ny = 1,nh do for nx = 1,nw do

    local sx, sy

    if dir == 8 then
      sx, sy = x + (nx - enter_x), y + (ny-1)

    elseif dir == 2 then
      sx, sy = x - (nx - enter_x), y - (ny-1)

    elseif dir == 4 then
      sx, sy = x - (ny-1), y + (nx - enter_x)

    else assert(dir == 6)
      sx, sy = x + (ny-1), y - (nx - enter_x)
    end

    assert(Seed_valid_and_free(sx, sy, 1))

    local ox = col_map[nx]
    local oy = row_map[ny]

    assert(1 <= ox and ox <= ow)
    assert(1 <= oy and oy <= oh)

    local ch = string.sub(F.structure[oh-oy+1], ox, ox)

    if ch == '.' then
      -- do nothing
    else

      local e = F.elements[ch]

      if e == nil then
        error("Unknown element '" .. ch .. "' in room fab")
      end

      assert(e.kind)

      if e.kind == "sub" then

        error("SUB ???")
        if not sub_dims[ch] then
          sub_dims[ch] = { x1=99,y1=99,x2=1,y2=1, ch=ch, e=e }
        end

        local D = sub_dims[ch]

        if sx < D.x1 then D.x1 = sx end
        if sx > D.x2 then D.x2 = sx end

        if sy < D.y1 then D.y1 = sy end
        if sy > D.y2 then D.y2 = sy end

      else
        local S = SEEDS[sx][sy][1]

        --FIXME: make proper room objects
        S.room =
        {
          kind = e.kind,
        }

        S.borders = {}

        if nx == 1  then S.borders[rotate_dir(4,dir)] = { kind="solid" } end
        if nx == nw then S.borders[rotate_dir(6,dir)] = { kind="solid" } end
        if ny == 1  then S.borders[rotate_dir(2,dir)] = { kind="solid" } end
        if ny == nh then S.borders[rotate_dir(8,dir)] = { kind="solid" } end
      end

    end -- if ch == '.'

    -- handle connection points

    for _,exit in ipairs(p.connections.exits) do
      local n_ex = pos_adjust(ow, nw, exit.x)
      local n_ey = pos_adjust(oh, nh, exit.y)
      if nx == n_ex and ny == n_ey then
        local p2 =
        {
          dir = rotate_dir(exit.dir, p.dir),

          last_fab = F,
        }

        p2.x, p2.y = nudge_coord(sx, sy, p2.dir)

        table.insert(CONNS, p2)
      end
    end

  end end -- nx, ny


  -- TODO: handle sub areas

end


function choose_room_fab(p, x, y, out_n, a_n, b_n)

  local W = math.min(a_n, b_n)
  local H = out_n

  if math.max(a_n, b_n) == 2 then W = 2 end


  local function usable(F)
    local SZ_IDX = #F.sizes

    if F.sizes[SZ_IDX].w > W   then return false end
    if F.sizes[SZ_IDX].h > H-1 then return false end

    local x1,y1, x2,y2 = install_loc(F, SZ_IDX, p.x, p.y, p.dir)

    if not Seed_block_valid_and_free(x1,y1,1, x2,y2,1) then
      return false
    end

    -- FIXME: make sure seeds at each connection point are
    --        valid and free

    return true
  end


  local fabs  = { }
  local probs = { }

  for _,F in pairs(ROOM_FABS) do
    if usable(F) then

      local prob = F.prob or 50

      if p.last_fab then
        local n1 = p.last_fab.kind .. "/" .. F.kind
        local n2 = F.kind .. "/" .. p.last_fab.kind

        local mul = ROOM_CONN_MODIFIERS[n1] or
                    ROOM_CONN_MODIFIERS[n2] or 1.0

        prob = prob * mul
      end

      table.insert(fabs, F)
      table.insert(probs, prob)
    end
  end

  if #fabs == 0 then
    con.debugf("No usable room fab found!\n")
    return
  end

  p.fab = fabs[rand_index_by_probs(probs)]

  p.SZ_IDX = #p.fab.sizes  -- FIXME: UGH!!!!


  -- connections !
  -- FIXME: integrate choice with usable() test

  assert(#p.fab.connections > 0)

  if #p.fab.connections == 1 then
    p.connections = p.fab.connections[1]
  else
    local conns = {}
    local probs = {}

    for _,C in ipairs(p.fab.connections) do
      table.insert(conns, C)
      table.insert(probs, C.prob or 50)
    end

    p.connections = p.fab.connections[rand_index_by_probs(probs)]
  end
end


function process_conns()

  assert(#CONNS > 0)

  -- TODO: sort in priority order
  local p = table.remove(CONNS, 1)

  con.debugf("Branching at point (%d,%d) dir:%d\n", p.x, p.y, p.dir)

  local dx, dy = dir_to_delta(p.dir)

  local x, y = p.x, p.y

  -- determine number of free seeds near the branch point

  local out_n  = 0

  for n = 0,100 do
    local sx = x + dx * n
    local sy = y + dy * n

    if not Seed_valid_and_free(sx, sy, 1) then break; end

    out_n = n + 1
  end

  if out_n == 0 then
    con.debugf("--> Cut off!\n")
    return
  end


  local a_n = 1
  local b_n = 1

  for n = 1,100 do
    local sx = x - dy * n
    local sy = y + dx * n

    if not Seed_valid_and_free(sx, sy, 1) then break; end

    a_n = n + 1
  end

  for n = 1,100 do
    local sx = x + dy * n
    local sy = y - dx * n

    if not Seed_valid_and_free(sx, sy, 1) then break; end

    b_n = n + 1
  end

  con.debugf("--> out_n:%d a_n:%d b_n:%d\n", out_n, a_n, b_n)


  choose_room_fab(p, x, y, out_n, a_n, b_n)

  if not p.fab then
    con.debugf("--> UNABLE TO SELECT ANY ROOM FAB\n")
    return
  end


  install_room_fab(p)


  -- create connections
  local S1 = SEEDS[p.x][p.y][1]

  local sx2, sy2 = nudge_coord(p.x, p.y, p.dir, -1)
  local S2 = SEEDS[sx2][sy2][1]

  if S1 and S1.borders then
    S1.borders[10 - p.dir] = { kind="walk" }
  end

  if S2 and S2.borders then
    S2.borders[p.dir] = { kind="walk" }
  end
end


function Plan_rooms_sp()

  local function char_for_seed(S)

    if not S or not S.kind then return "." end

    if S.kind == "ground" then return "/" end
    if S.kind == "liquid" then return "~" end
    if S.kind == "cave" then return "%" end
    if S.kind == "building" then return "#" end
    if S.kind == "hall" then return "+" end

    return "?"
  end


  ---===| Plan_rooms_sp |===---

  con.printf("\n--==| Plan_rooms_sp |==--\n\n")

  Seed_init(SW, SH, 1, { zone_kind="solid"})

  -- initial connection points
  -- (TWO of them, to create something on each side)
  local p1 =
  {
    x = rand_irange(int(SW/4), int(SW*3/4)),
    y = rand_irange(int(SH/4), int(SH/2)),
    dir = 8,
    hall = true
  }

  local p2 =
  {
    x = p1.x, y = p1.y - 1, dir = 2,
  }

  table.insert(CONNS, p1)
  table.insert(CONNS, p2)


  -- branch stuff out from connections

  for loop = 1,999 do
    process_conns()

    if #CONNS == 0 then break; end
  end


  -- dump the results

  con.printf("FAB MAP:\n")

  for y = SH,1,-1 do
    
    for x = 1,SW do
      con.printf("%s", char_for_seed(SEEDS[x][y][1].room))
    end

    con.printf("\n")
  end

end -- Plan_rooms_sp

