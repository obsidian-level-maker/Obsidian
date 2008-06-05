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

--[[ *** CLASS INFORMATION ***

class PLAN
{
}


class CONN
{
  x, y : location of the entry seed

  dir  : direction room fab faces (the "up" vector)

}


--------------------------------------------------------------]]

require 'defs'
require 'util'
require 'room_fabs'


SIZE_LIST = { tiny=16, small=20, regular=24, big=30, xlarge=36 }
WANT_SIZE = "small"

FABS = {}

CONNS = {}



function pos_adjust(old_w, new_w, x)
  
  if x == 1     then return 1 end
  if x == old_w then return new_w end

  if (old_w % 2) == 1 and (new_w % 2) == 1 then
    if x == (old_w + 1) / 2 then
      return (new_w + 1) / 2
    end
  end
 
  -- lerp it
  if (x-1) < (old_w-1)/2 then
    return 1 + int((new_w-1)*(x-1)/(old_w-1))
  else
    return new_w - int((new_w-1)*(old_w-x)/(old_w-1))
  end
end


function install_loc(F, size, x, y, dir, mirror)

  local ow = F.long
  local oh = F.deep

  local nw = size.w
  local nh = size.h

  local enter_x = F.enter_x
  if mirror then
    enter_x = ow - (enter_x-1)
  end
  enter_x = pos_adjust(ow, nw, enter_x)


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

  local ow = F.long
  local oh = F.deep

  local nw = p.size.w
  local nh = p.size.h

  local enter_x = p.fab.enter_x
  if p.mirror then
    enter_x = ow - (enter_x-1)
  end
  enter_x = pos_adjust(ow, nw, enter_x)


  local col_map = {}
  local row_map = {}

  local col_inv = {}
  local row_inv = {}

  local function create_mapping(map, inv, fx, nx, grow)
    assert(fx <= nx)

    if fx == nx then
      for i = 1,nx do
        map[i] = i
        inv[i] = { i,i }
      end
      return
    end

    assert(grow)
    assert(#grow >= 1)

    -- determine how large each column/row will be
    local sizes = {}
    for i = 1,fx do sizes[i] = 1 end

    local g_idx = 1
    local g_tot = fx

    while g_tot < nx do
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

    assert(#map == nx)

    -- inverse mapping
    local pos = 1
    for i = 1,fx do
      inv[i] = { pos, pos+sizes[i]-1 }
      pos = pos + sizes[i]
    end
  end -- create_mapping


  ---| install_room_fab |---

  con.debugf("Installing room fab '%s' %dx%d at (%d,%d) dir:%d\n",
             F.name, nw,nh, x, y, dir)

  create_mapping(col_map, col_inv, ow, nw, F.x_grow)
  create_mapping(row_map, row_inv, oh, nh, F.y_grow)

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

    if p.mirror then ox = ow - (ox-1) end

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

    for _,exit in ipairs(p.exit.exits) do

      local inv_x = col_inv[exit.x]
      local inv_y = row_inv[exit.y]
      assert(inv_x and inv_y)

      local inv_midx = int((inv_x[1] + inv_x[2] + sel(ox>ow/2,1,0)) / 2)
      local inv_midy = int((inv_y[1] + inv_y[2] + sel(oy>oh/2,1,0)) / 2)

      local n_ex, n_ey

          if exit.dir == 2 then   n_ex,n_ey = inv_midx, inv_y[1]
      elseif exit.dir == 8 then   n_ex,n_ey = inv_midx, inv_y[2]
      elseif exit.dir == 4 then   n_ex,n_ey = inv_x[1], inv_midy
      else assert(exit.dir == 6); n_ex,n_ey = inv_x[2], inv_midy
      end

      assert(n_ex and n_ey)

      if nx == n_ex and ny == n_ey then
        local p2 =
        {
          dir = rotate_dir(exit.dir, p.dir),

          last_fab = F,

          optional = exit.optional,
        }

        p2.x, p2.y = nudge_coord(sx, sy, p2.dir)

        table.insert(CONNS, p2)
      end
    end

  end end -- nx, ny


  -- TODO: handle sub areas


  -- fix the two adjacent seeds to allow walking between them
  if not p.level_fab then
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
end


function space_at_point(x, y, dir)

  -- determines number of free seeds at the branch point

  local dx, dy = dir_to_delta(dir)

  local out_n = 0

  for n = 0,100 do
    local sx = x + dx * n
    local sy = y + dy * n

    if not Seed_valid_and_free(sx, sy, 1) then break; end

    out_n = n + 1
  end

  if out_n == 0 then
    con.debugf("--> Connection at (%d,%d) cut off!\n", x, y)
    return 0,0,0
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

  return out_n, a_n, b_n
end


function try_install_room_fab(p)
  local F = assert(p.fab)

  -- check if all seeds are free
  local x1,y1, x2,y2 = install_loc(F, p.size, p.x, p.y, p.dir)

  con.debugf("BLOCK RANGE: (%d,%d) .. (%d,%d)\n", x1,y1, x2,y2)

  assert(Seed_valid(x1,y1,1))
  assert(Seed_valid(x2,y2,1))

  if not Seed_block_valid_and_free(x1,y1,1, x2,y2,1) then
    return false
  end

  -- check whether new fab cuts off a connection point
  for _,CP in ipairs(CONNS) do
    if not CP.optional then
      if box_contains_point(x1,y1, x2,y2, CP.x, CP.y) then
        return false
      end
    end
  end

  -- FIXME: make sure seeds at each connection point are
  --        valid and free

  install_room_fab(p)

  return true
end


function try_room_fab_sizes(p)

  local function room_fab_fits(p)

    -- this is only a very basic test designed to weed out many
    -- unsuitable candidates early on.

    if p.size.h > p.up then return false end

    local ex = p.fab.enter_x
    local ow = p.fab.long
    local nw = p.size.w

    if p.mirror then
      ex = ow - (ex-1)
    end

    ex = pos_adjust(ow, nw, ex)

    return (p.left >= ex) and (p.right >= nw-(ex-1))
  end

  -- try_room_fab_sizes --

  local avail_sizes = {}
  for _,SZ in ipairs(p.fab.sizes) do
    avail_sizes[SZ] = SZ.prob or 50
  end

  while not table_empty(avail_sizes) do
    p.size = rand_key_by_probs(avail_sizes)
    assert(p.size)

    if room_fab_fits(p) then

      local avail_exits = {}
      for _,EX in ipairs(p.fab.connections) do
        avail_exits[EX] = EX.prob or 50
      end

      while not table_empty(avail_exits) do
        p.exit = rand_key_by_probs(avail_exits)
        assert(p.exit)

        if try_install_room_fab(p) then
          return true -- SUCCESS
        end

        avail_exits[p.exit] = nil
      end -- while

    end -- if

    avail_sizes[p.size] = nil
  end -- while

  return false -- FAILED
end


function process_conn()

  assert(#CONNS > 0)

  -- TODO: sort in priority order
  local p = table.remove(CONNS, 1)

  con.debugf("Branching at point (%d,%d) dir:%d\n", p.x, p.y, p.dir)

---###  local dx, dy = dir_to_delta(p.dir)
---###  local x, y = p.x, p.y

  p.up, p.left, p.right = space_at_point(p.x, p.y, p.dir)

  con.debugf("--> up:%d left:%d right:%d\n", p.up, p.left, p.right)


  local avail_fabs = {}
  for _,R in pairs(ROOM_FABS) do
    local prob = R.prob or 50
      if p.last_fab then
        local n1 = p.last_fab.kind .. "/" .. R.kind
        local n2 = R.kind .. "/" .. p.last_fab.kind

        local mul = ROOM_CONN_MODIFIERS[n1] or
                    ROOM_CONN_MODIFIERS[n2] or 1.0

        prob = prob * mul
      end
    avail_fabs[R] = prob
  end

  -- FIXME: modify probs here (EG: ROOM_CONN_MODIFIERS)

  for loop = 1,50 do
    if table_empty(avail_fabs) then
      break;
    end

    p.fab = rand_key_by_probs(avail_fabs)
    assert(p.fab)

    local m_start = rand_irange(0,1)

    for mirror = 0,0 do -- FIXME!!!! m_start,m_start+1 do
      p.mirror = (mirror == 1)

      if try_room_fab_sizes(p) then
        return -- SUCCESS
      end
    end

    avail_fabs[p.fab] = nil
  end

  -- Failed!

  con.debugf("--> UNABLE TO SELECT ANY ROOM FAB\n")


  --TODO: function handle_hall_failure(p)
  -- if p.source.kind == "hall" then
  --   p.hall_fails = p.hall_fails + 1
  --   if p.hall_fails == p.hall_exit_num then
  --     DELETE HALL
  --     RE-ACTIVATE PREVIOUS CONNECTION
  --     IF prev.source.kind == "hall" and TOO_MANY_REACTIVATIONS then
  --       handle_hall_failure(prev)
  --     END
  --   end
  -- end

end


function Plan_rooms_sp()


  ---===| Plan_rooms_sp |===---

  con.printf("\n--==| Plan_rooms_sp |==--\n\n")

  local SW = assert(SIZE_LIST[WANT_SIZE])
  local SH = SW

  local adjust = rand_irange(0, int(SW / 4))

  if rand_odds(50) then adjust = -adjust end

  SW = SW + adjust
  SH = SH - adjust

  con.printf("Map size: %dx%d\n", SW, SH)

  Seed_init(SW, SH, 1, { zone_kind="solid"})

  
  -- select Level fab

  local lev_fabs = {}
  for _,F in pairs(LEVEL_FABS) do
    -- FIXME size check
    lev_fabs[F] = F.prob or 50
  end

  if table_empty(lev_fabs) then
    error("NO USABLE LEVEL FAB FOUND!")
  end

  local fab = rand_key_by_probs(lev_fabs)

  fab.enter_x = 1

  local p =
  {
    level_fab = true,
    x = 1, y = 1,
    dir = 8,
    fab = fab,
    mirror = false,
    size = { w=SW, h=SH },
    exit = rand_element(fab.connections),
  }

  if not try_install_room_fab(p) then
    error("FAILURE INSTALLING LEVEL FAB: " .. fab.name)
  end

--[[ OLD CODE

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

--]]


  -- branch stuff out from connections

  for loop = 1,999 do
    process_conn()

    if #CONNS == 0 then break; end
  end

  Seed_dump_fabs()

end -- Plan_rooms_sp

