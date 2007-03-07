----------------------------------------------------------------
-- THEMES : Spear of Destiny
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


SP_TILE_NUMS =
{
  area_min = 108,
  area_max = 143,

  deaf_guard = 106,
  elevator_secret = 107,

  door = { 90, 91 },

  door_silver = { 92, 93 },
  door_gold   = { 94, 95 },

  door_elevator = { 100, 101 },
}

----------------------------------------------------------------

SP_THEMES =
{
}
 

----------------------------------------------------------------

SP_MONSTERS =
{
  -- FIXME !!!
  mutant  = { prob=20, hp=50,  dm=20, fp=10, r=20,h=40, hitscan=true, },
}


SP_PICKUPS =
{
  clip_25 = { stat="bullet", give=25 },
}


----------------------------------------------------------------

THEME_FACTORIES["spear"] = function()

  local T = THEME_FACTORIES.wolf3d()

  T.monsters = copy_and_merge(T.monsters, SP_MONSTERS)

  T.themes   = copy_and_merge(T.themes,   SP_PICKUPS)
  T.pickups  = copy_and_merge(T.pickups,  SP_PICKUPS)

  return T
end

