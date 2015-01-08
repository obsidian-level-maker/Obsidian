------------------------------------------------------------------------
--  DEATH-MATCH / CAPTURE THE FLAG
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2015 Andrew Apted
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
------------------------------------------------------------------------


function Multiplayer_create_zones()
  --
  -- In competitive multiplayer maps we only need a single zone.
  --

  local Z = Zone_new()

  each R in LEVEL.rooms do
    R.zone = Z

    each A in R.areas do
      A.zone = Z
    end
  end

  Area_spread_zones()
end



function Multiplayer_flag_rooms()
  --
  -- pick the flag rooms for CTF mode
  --

  local function eval_flag_room(R)
    -- never in a hallway
    if R.is_hallway then return -1 end

    local score = 300

    -- too big?
    if R.svolume > 20 then score = score - 100 end

    -- too small?
    if R.svolume < 6 then score = score - 200 end

    -- tie breaker
    return score + gui.random()
  end


  local function setup_room(R, team)
    R.is_flag_room = true

    local GOAL =
    {
      kind = "FLAG"
      team = team
    }

    table.insert(R.goals, GOAL)
  end


  ---| Multiplayer_flag_rooms |---

  local best
  local best_score = 0

  each R in LEVEL.rooms do

    local A1 = R.areas[1]

    if not (A1.team == "blue" and R.sister) then continue end

    local score = eval_flag_room(R)

stderrf("trying %s : team:%s sister:%s --> %1.2f\n",
R:tostr(), A1.team or "???", tostring(R.sister), score)

    if score > best_score then
      best = R
      best_score = score
    end
  end

  if not best then
    error("CTF failure, no usable room for the flag")
  end

  setup_room(best, "blue")
  setup_room(best.sister, "red")

  LEVEL.blue_base = best
  LEVEL. red_base = best.sister

  gui.printf("CTF Blue Flag @ %s\n", LEVEL.blue_base:tostr())
  gui.printf("CTF Red  Flag @ %s\n", LEVEL. red_base:tostr())
end



function Multiplayer_add_items()
  -- TODO
end



function Multiplayer_setup_level()

  Multiplayer_create_zones()

  Quest_choose_themes()
  Quest_select_textures()

  if OB_CONFIG.mode == "ctf" then
    Multiplayer_flag_rooms()
  end

  -- FIXME : player starts

  -- FIXME : weapons
end

