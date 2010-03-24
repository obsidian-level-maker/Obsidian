----------------------------------------------------------------
--  MODULE: demo maker
----------------------------------------------------------------
--
--  Copyright (C) 2010 Andrew Apted
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


function Demo_make_for_doom()
  if not LEVEL.demo_lump then return end

  gui.printf("\nGenerating demo : %s\n\n", LEVEL.demo_lump)

  local pos = shallow_copy(assert(LEVEL.player_pos))

  local data =
  {
    109,  -- DOOM_VERSION
    2,    -- skill (HMP)
    LEVEL.episode,
    LEVEL.map,
    0,    -- deathmatch
    0,    -- respawnparm
    0,    -- fastparm
    1,    -- nomonsters
    0,    -- consoleplayer

    1, 0, 0, 0  -- playersingame
  }

  local function add_ticcmd(forward, side, turn, buttons)
    table.insert(data, forward)
    table.insert(data, side)
    table.insert(data, turn)
    table.insert(data, buttons)
  end

  local function wait(tics)
    for i = 1,tics do
      add_ticcmd(0, 0, 0, 0)
    end
  end

  local function solve_room(t_kind, what)
    if t_kind == "purpose" then
      gui.debugf("  doing purpose %s/%s in %s\n",
                 pos.R.arena.lock.kind or "-",
                 pos.R.arena.lock.item or "-", pos.R:tostr())
      -- FIXME
    else
      -- TODO
    end
  end

  local function next_room(C, N)
    if not C then
      assert(N)
      for _,C2 in ipairs(N.conns) do
        if C2:neighbor(N) == pos.R then
          C = C2 ; break
        end
      end
      assert(C)
    end

    if not N then
      local N = C:neighbor(pos.R)
      assert(N)
    end

    gui.debugf("  enter room %s via conn %s\n", N:tostr(), C:tostr())

    -- FIXME

    pos.R = N
    pos.S = C:seed(N)
  end

  local function follow_path(path)
  end

  local function solve_arenas()
    local arena = LEVEL.all_arenas[1]

    gui.debugf("start is %s\n", pos.R:tostr())

    while true do
      gui.debugf("solving arena %d\n", arena.id)

      for _,C in ipairs(path) do
        next_room(C)
      end

      solve_room("purpose")

      if arena.lock.kind == "EXIT" then
        gui.debugf("EXIT")
        return
      end

      for _,R in ipairs(arena.back_path) do
        next_room(nil, R)
      end

      next_room(arena.lock.conn)

      arena = pos.R.arena
    end
  end


  -- BEGIN!
  wait(10)

  solve_arenas()

  wait(35*2)

  -- mark the end
  table.insert(data, 0x80)  -- DEMOMARKER

  gui.wad_add_binary_lump(LEVEL.demo_lump, data)
end


OB_MODULES["demo_gen"] =
{
  label = "Demo Generator (DOOM)",

  for_games = { doom1=1, doom2=1 },

  end_level_func = Demo_make_for_doom,
}

