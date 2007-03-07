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


SP_THEMES =
{
  CONCRETE =
  {
    mat_pri=4,
    wall=57, void=57, floor=0, ceil=0,
  },

  GRAY_CONCRETE =
  {
    mat_pri=4,
    wall=54, void=54, floor=0, ceil=0,
  },

  BROWN_CONCRETE =
  {
    mat_pri=4,
    wall=62, void=62, floor=0, ceil=0,
  },

  PURPLE_BRICK=
  {
    mat_pri=1,
    wall=63, void=63, floor=0, ceil=0,
  }
}
 

----------------------------------------------------------------

SP_MONSTERS =
{
  mutant = { prob=20, hp=55, dm=35, fp=10, r=20,h=40, hitscan=true, },
}

SP_BOSSES =
{
  -- FIXME: dm values were pulled straight out of my arse

  trans_grosse = { hp=1000, dm=40, r=20,h=40, hitscan=true },
  wilhelm      = { hp=1100, dm=70, r=20,h=40, hitscan=true },
  uber_mutant  = { hp=1200, dm=60, r=20,h=40, hitscan=true },
  death_knight = { hp=1400, dm=90, r=20,h=40, hitscan=true },

  ghost        = { hp=15,   dm=20, r=20,h=40, melee=true },
  angel        = { hp=1600, dm=150,r=20,h=40, },
}


SP_PICKUPS =
{
  clip_25 = { stat="bullet", give=25 },
}


----------------------------------------------------------------

THEME_FACTORIES["spear"] = function()

  local T = THEME_FACTORIES.wolf3d()

  T.bosses   = SP_BOSSES
  T.monsters = copy_and_merge(T.monsters, SP_MONSTERS)

  T.themes   = copy_and_merge(T.themes,   SP_PICKUPS)
  T.pickups  = copy_and_merge(T.pickups,  SP_PICKUPS)

  return T
end

