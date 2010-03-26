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

  -- constants
  local DEMOMARKER = 0x80
  local MAXMOVE = 30
  local STOPSPEED = 1/16
  local FRICTION = 1 - 3/32

  local player = shallow_copy(assert(LEVEL.player_pos))

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

  local function p_thrust(angle, move)
    if player.on_ground then
      player.momx = player.momx + move * math.cos(angle * math.pi / 128.0)
      player.momy = player.momy + move * math.sin(angle * math.pi / 128.0)
    end
  end

  local function p_physics(impetus)
    -- DOOM physics emulation
    
    if player.momx < -MAXMOVE then player.momx = -MAXMOVE end
    if player.momy < -MAXMOVE then player.momy = -MAXMOVE end

    if player.momx > MAXMOVE then player.momx = MAXMOVE end
    if player.momy > MAXMOVE then player.momy = MAXMOVE end

    player.x = player.x + player.momx
    player.y = player.y + player.momy

    if not player.on_ground then
      return  --  no friction when airborne
    end

    if not impetus and
       math.abs(player.momx) < STOPSPEED and
       math.abs(player.momy) < STOPSPEED
    then
      player.momx = 0
      player.momy = 0
    else
      player.momx = player.momx * FRICTION
      player.momy = player.momy * FRICTION
    end
  end

  local function ticcmd(forward, side, turn, buttons)
    table.insert(data, forward)
    table.insert(data, side)
    table.insert(data, turn)
    table.insert(data, buttons)

    -- move the player
    p_thrust(player.angle,   forward / 32.0)
    p_thrust(player.angle - 64, side / 32.0)

    local impetus = (forward ~= 0) or (side ~= 0)

    p_physics(impetus)
  end

  local function wait(tics)
    for i = 1,tics do
      ticcmd(0, 0, 0, 0)
    end
  end

  local function end_stream()
    table.insert(data, DEMOMARKER)
  end

  local function give_up()
    gui.debugf("WTF?  I GIVE UP!\n")

    player.given_up = true

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
               player.x, player.y, player.z, player.angle,
               player.S:tostr(), player.R.id or "??")
  end

  local function quantize_angle(ang)
    -- convert angle from 0-359 floating point --> 0-255 integer.
    -- values are allowed to lie outside of this range (e.g. negative)
    return int(player.angle * 256 / 360 + 0.4)
  end

  local function angle_diff(A, B)  -- B minus A, result is -128..+128
    local D = int(B - A)

    while D >  128 do D = D - 256 end
    while D < -128 do D = D + 256 end

    return D
  end

  local function fast_turn(target_angle)
    local diff = angle_diff(player.angle, target_angle)

    if diff == 0 then return end  -- very fast indeed :)

    ticcmd(0, 0, diff, 0)

    player.angle = target_angle

    if math.abs(diff) < 128 then
      player.last_turn = diff
    end
  end

  local function slow_turn(target_angle, tics)
    assert(tics >= 1)

    local diff = angle_diff(player.angle, target_angle)

    -- exactly 180 degrees is ambiguous: could go left or right.
    -- we keep going in same direction as the last turn
    if math.abs(diff) == 128 then
      diff = sel(player.last_turn < 0, -1, 1) * 128
    end

    local orig_angle = player.angle

    for i = 1,tics do
      fast_turn(orig_angle + int(diff * i / tics))
    end

    fast_turn(target_angle)
  end

  local function solve_room(t_kind, what)
    if player.given_up then return end

    if t_kind == "purpose" then
      gui.debugf("  doing purpose %s/%s in %s\n",
                 player.R.arena.lock.kind or "-",
                 player.R.arena.lock.item or "-", player.R:tostr())

      -- FIXME

      if player.R.purpose == "EXIT" then
        player.finished = true
      end

    else
      -- TODO
    end
  end

  local function next_room(C, N)
    if not C then
      assert(N)
      for _,C2 in ipairs(N.conns) do
        if C2:neighbor(N) == player.R then
          C = C2 ; break
        end
      end
      assert(C)
    end

    if not N then
      N = C:neighbor(player.R)
      assert(N)
    end

    gui.debugf("  enter room %s via conn %s\n", N:tostr(), C:tostr())

    -- FIXME

    player.R = N
    player.S = C:seed(N)
  end

  local function follow_path(path)
    for _,C in ipairs(path) do
      next_room(C)
    end
  end

  local function solve_arenas()
    local arena = LEVEL.all_arenas[1]

    gui.debugf("start is %s\n", player.R:tostr())

    while not player.given_up do
      gui.debugf("\nsolving arena %d\n", arena.id)

      dump_pos()

      if player.R ~= arena.start then give_up() ; return end

      follow_path(arena.path)

      if player.R ~= arena.target then give_up() ; return end

      solve_room("purpose")

      if player.finished then
        gui.debugf("YEAH I MADE IT!\n")
        return
      end

      follow_path(assert(arena.back_path))

      if player.R ~= arena.lock.conn.src then give_up() ; return end

      next_room(arena.lock.conn)

      arena = player.R.arena
    end
  end


  -- MAKE A COOL DEMO !! --

  gui.printf("\nGenerating demo : %s\n\n", LEVEL.demo_lump)

  player.momx = 0
  player.momy = 0
  player.angle = quantize_angle(player.angle)
  player.last_turn = 0
  player.on_ground = true

  wait(16)

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

