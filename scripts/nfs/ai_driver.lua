------------------------------------------------------------------------
--  AI DRIVER : Drive Simulator
------------------------------------------------------------------------
--
--  RandTrack : track generator for NFS1 (SE)
--
--  Copyright (C) 2015 Andrew Apted
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 3
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this software.  If not, please visit the following
--  web page: http://www.gnu.org/licenses/gpl.html
--
------------------------------------------------------------------------


function Drive_Simulator()
  --
  -- Simulate a skilled player driving along the generated track
  -- and set the 'ai_speed' field of each segment.
  --
  -- On closed tracks, we perform two passes over the track and
  -- only record the speeds of the second loop.
  --

  local user_setting


  -- TODO: detect top of steep hills, where car would go flying if going
  --       too fast, and make the target speed there lower.


  -- target speeds, indexed by category of turn (first entry for straights)
  local SPEEDS = { 140, 120, 95, 75, 50 }

  -- normal acceleration rates (on a perfectly flat, non-sloped road)
  -- first value is when driving slow, second value for fast.
  -- values are speed change PER NODE.
  local ACCEL_RATES = { 1.3, 0.7 }

  -- deceleration rate (speed change PER NODE)
  -- [ this should not be too low, or cars will go round sharp bends at much
  --   higher speeds than the player could in-game ]
  local DECEL_RATE = 1.5

  -- slope stuff (value at 45 degrees, very steep)
  local SLOPE_DECEL = 2.5


  local function compute_target_speed(n)
    -- look ahead to see how sharp the turns coming up are

    local speed = SPEEDS[1]

    for dist = 1, 60 do
      local node = lookup_node(n + dist - 4)

      if not node then break; end

      local cat = math.max(node.cat_L, node.cat_R)

      local future = SPEEDS[1 + cat]
      assert(future)

      -- assume we can decelerate from here to there
      future = future + DECEL_RATE * (dist - 1)

      speed = math.min(speed, future)
    end

    return speed
  end


  local function slope_acceleration(dr, n)
    -- apply gravity when going up or down slopes.
    -- steep climbs provide a high deceleration value.
    -- we currently ignore steep descents.

    -- compute slope
    local node1 = lookup_node(n)
    local node2 = lookup_node(n + 1)

    if not node2 then return end

    local dz = (node2.z - node1.z) / TRACK.stepping

    -- slow down even when going downhill
    -- [ not correct physics, but seems to match the data ]

    if dr.speed > 50 then
      dr.speed = dr.speed - math.abs(dz) * SLOPE_DECEL
    end
  end


  local function visit_node(dr, n)
    local node = lookup_node(n)
    assert(node)

    node.ai_speed = dr.speed

    local target = compute_target_speed(n)

    if math.abs(target - dr.speed) < 1.0 then
      dr.speed = target

    elseif target < dr.speed then
      -- decelerate
      local decel = dr.speed - target
      if decel > DECEL_RATE then decel = DECEL_RATE end

      dr.speed = dr.speed - decel
    
    else
      -- accelerate
      local accel = math.lerp(0, dr.speed, SPEEDS[2],  ACCEL_RATES[1], ACCEL_RATES[2])

      if dr.speed + accel < target then
        dr.speed = dr.speed + accel
      else
        dr.speed = target
      end
    end

    slope_acceleration(dr, n)

-- DEBUG:
--  stderrf("Speed [%04d] = %1.2f  (target %d)\n", n, dr.speed, target)
  end


  local function traverse_track()
    local start = 1

    -- on closed tracks, first pass will have negative node indices
    if TRACK.closed then
      start = 1 - TRACK.num_nodes
    end

    -- setup current state
    local drive_state =
    {
      speed = 0
    }

    for n = start, TRACK.num_nodes do
      visit_node(drive_state, n)
    end
  end


  local function averages_per_segment()
    for _,seg in pairs(TRACK.segments) do
      local sum = 0

      for i = 1, 4 do
        local n = (seg.index - 1) * 4 + i
        local node = TRACK.road[n]

        sum = sum + (node.ai_speed or 0)
      end

      -- apply user setting here
      seg.ai_speed = (sum / 4) * user_setting
    end
  end


  local function calc_user_setting()
    local val = sel(TRACK.open, PREFS.o_speed, PREFS.c_speed)

    if val == nil then
      error("Missing speed setting?")
    end

    -- convert to a number (really a percentage)
    val = (0 + val)

    user_setting = math.clamp(20, val, 400) / 100
  end


  ---| Drive_Simulator |---

  calc_user_setting()

  traverse_track()

  averages_per_segment()
end

