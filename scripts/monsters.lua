----------------------------------------------------------------
--  MONSTERS/HEALTH/AMMO
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2008 Andrew Apted
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

MONSTER SELECTION
=================

Main usages:
(a) free-range
(b) guarding something [keys]
(c) cages
(d) traps (triggered closets, teleport in)
(e) surprises (behind entry door, closests on back path)


IDEAS:

Free range monsters make up the bulk of the level, and are
subject to the palette.  The palette applies to a fair size
of a map, on "small" setting --> 1 palette only, upto 2 on
"regular", between 2-3 on "large" maps.

[Palette probably needs to handle "families", e.g. Baron
and Hellknight, Mummy and Leader]

Trap and Surprise monsters can use any monster (actually
better when different from palette and different from
previous traps/surprises).

Cages and Guarding monsters should have a smaller and
longer-term palette, changing about 4 times less often
than the free-range palette.  MORE PRECISELY: palette
evolves about same rate IN TERMS OF # MONSTERS ADDED.

Evolving a palette: replace some monsters with different
ones.  Especially replace weaker with stronger (we assume
the player will have better weapons).  Probably replace
only 1 monster each time over the course of an EPISODE
(faster and/or more palettes when making SINGLE maps).

--------------------------------------------------------------]]

require 'defs'
require 'util'


function Player_init()
  PLAN.hmodels = {}

  for _,SK in ipairs(SKILLS) do
    local hm_set = deep_copy(GAME.initial_model)

    for CL,hmodel in pairs(hm_set) do
      hmodel.skill = SK
      hmodel.class = CL
    end -- for CL

    PLAN.hmodels[SK] = hm_set
  end -- for SK
end

function Player_give_weapon(weapon, to_CL)
  gui.debugf("Giving weapon: %s\n", weapon)

  for _,SK in ipairs(SKILLS) do
    for CL,hmodel in pairs(PLAN.hmodels[SK]) do
      if not to_CL or (to_CL == CL) then
        hmodel.weapons[weapon] = true
      end
    end -- for CL
  end -- for SK
end


function Monsters_in_room(R)
  -- FIXME: monsters

  gui.debugf("Monsters_in_room @ %s\n", R:tostr())
end


function Monsters_do_pickups()
  -- FIXME: pickups
end


function Monsters_add_some()
  
  gui.printf("\n--==| Monsters_add_some |==--\n\n")

  Player_init()

  if PLAN.start_room.weapon then
    Player_give_weapon(PLAN.start_room.weapon)
  end

  local cur_arena = 1

  for _,R in ipairs(PLAN.all_rooms) do
    if R.arena.weapon and (R.arena.id > cur_arena) and not R.skip_weapon then
      cur_arena = R.arena.id
      Player_give_weapon(R.arena.weapon)
    end

    Monsters_in_room(R)
  end -- for R

  Monsters_do_pickups()
end

