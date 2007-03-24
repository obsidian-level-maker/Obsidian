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

SP_SCENERY =
{
  -- only differences to WF_SCENERY here

  ceil_light2 = { r=24,h=48, pass=true, ceil=true, light=true },

  skull_stick = { r=24,h=48 },
  skull_cage  = { r=24,h=48 },

  cow_skull    = { r=24,h=48 },
  blood_well   = { r=24,h=48 },
  angel_statue = { r=24,h=48 },

  marble_column = { r=24,h=48 },
}

----------------------------------------------------------------

THEME_FACTORIES["spear"] = function()

  local T = THEME_FACTORIES.wolf3d()

  T.bosses   = SP_BOSSES

  T.themes   = copy_and_merge(T.themes,   SP_THEMES)
  T.pickups  = copy_and_merge(T.pickups,  SP_PICKUPS)

  T.scenery  = copy_and_merge(T.scenery,  SP_SCENERY)

  -- remove Wolf3d only scenery

  T.scenery["sink"] = nil
  T.scenery["bed"]  = nil
  T.scenery["aardwolf"] = nil

  T.scenery["pots"]   = nil
  T.scenery["stove"]  = nil
  T.scenery["spears"] = nil
  T.scenery["dud_clip"] = nil

  return T
end

