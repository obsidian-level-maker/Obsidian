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

  local function ticcmd(forward, side, turn, buttons)
    table.insert(data, forward)
    table.insert(data, side)
    table.insert(data, turn)
    table.insert(data, buttons)
  end

  local function wait(tics)
    for i = 1,tics do
      ticcmd(0, 0, 0, 0)
    end
  end

  local function end_stream()
    table.insert(data, 0x80)  -- DEMOMARKER
  end

  local function give_up()
    gui.debugf("WTF?  I GIVE UP!\n")

    pos.given_up = true

    wait(35*2)

    -- shake his head
    for i = 4,35 do
      ticcmd(0, 0, sel(gui.bit_and(i,8) == 0, 3, -3), 0)
    end

    wait(35*2)

    end_stream()
  end

  local function dump_pos()
    gui.debugf("Pos:(%1.1f %1.1f %1.1f) ang:%1.1f  @  %s in ROOM_%s\n",
               pos.x, pos.y, pos.z, pos.angle,
               pos.S:tostr(), pos.R.id or "??")
  end

  local function quantize_angle(ang)
    -- convert angle from 0-359 floating point --> 0-255 integer.
    -- values are allowed to lie outside of this range (e.g. negative)
    return int(pos.angle * 256 / 360 + 0.4)
  end

  local function angle_diff(A, B)  -- B minus A, result is -128..+128
    local D = int(B - A)

    while D >  128 do D = D - 256 end
    while D < -128 do D = D + 256 end

    return D
  end

  local function fast_turn(target_angle)
    local diff = angle_diff(pos.angle, target_angle)

    if diff == 0 then return end  -- very fast indeed :)

    ticcmd(0, 0, diff, 0)

    pos.angle = target_angle

    if math.abs(diff) < 128 then
      pos.last_turn = diff
    end
  end

  local function slow_turn(target_angle, tics)
    assert(tics >= 1)

    local diff = angle_diff(pos.angle, target_angle)

    -- exactly 180 degrees is ambiguous: could go left or right.
    -- we keep going in same direction as the last turn.
    if math.abs(diff) == 128 then
      diff = sel(pos.last_turn < 0, -1, 1) * 128
    end

    local orig_angle = pos.angle

    for i = 1,tics do
      fast_turn(orig_angle + int(diff * i / tics))
    end

    fast_turn(target_angle)
  end

  local function solve_room(t_kind, what)
    if pos.given_up then return end

    if t_kind == "purpose" then
      gui.debugf("  doing purpose %s/%s in %s\n",
                 pos.R.arena.lock.kind or "-",
                 pos.R.arena.lock.item or "-", pos.R:tostr())

      -- FIXME

      if pos.R.purpose == "EXIT" then
        pos.finished = true
      end

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
      N = C:neighbor(pos.R)
      assert(N)
    end

    gui.debugf("  enter room %s via conn %s\n", N:tostr(), C:tostr())

    -- FIXME

    pos.R = N
    pos.S = C:seed(N)
  end

  local function follow_path(path)
    for _,C in ipairs(path) do
      next_room(C)
    end
  end

  local function solve_arenas()
    local arena = LEVEL.all_arenas[1]

    gui.debugf("start is %s\n", pos.R:tostr())

    while not pos.given_up do
      gui.debugf("\nsolving arena %d\n", arena.id)

      dump_pos()

      if pos.R ~= arena.start then give_up() ; return end

      follow_path(arena.path)

      if pos.R ~= arena.target then give_up() ; return end

      solve_room("purpose")

      if pos.finished then
        gui.debugf("YEAH I MADE IT!\n")
        return
      end

      follow_path(assert(arena.back_path))

      if pos.R ~= arena.lock.conn.src then give_up() ; return end

      next_room(arena.lock.conn)

      arena = pos.R.arena
    end
  end


  -- MAKE A COOL DEMO !! --

  pos.angle = quantize_angle(pos.angle)
  pos.last_turn = 0

  wait(16)

  slow_turn(64, 16) ; wait(16);
  slow_turn(-64, 30) ; wait(16);
  slow_turn(128, 16) ; wait(16);
  slow_turn(0, 30) ; wait(16);

  solve_arenas()

  wait(35*2)

  end_stream()

  gui.wad_add_binary_lump(LEVEL.demo_lump, data)
end


OB_MODULES["demo_gen"] =
{
  label = "Demo Generator (DOOM)",

  for_games = { doom1=1, doom2=1 },

  end_level_func = Demo_make_for_doom,
}

