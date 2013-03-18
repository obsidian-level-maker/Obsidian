----------------------------------------------------------------
--  GAME DEFINITION : ULTIMATE DOOM
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2012 Andrew Apted
--  Copyright (C)      2011 Chris Pisarczyk
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
--
--  Note: common definitions are in doom.lua
--        (including entities, monsters and weapons)
--
----------------------------------------------------------------

DOOM1 = { }


DOOM1.THEME_DEFAULTS =
{
  big_junctions =
  {
    Junc_Octo = 70
    Junc_Spokey = 10
  }
}


------------------------------------------------------------

function DOOM1.setup()
  -- remove Doom II only stuff
  GAME.WEAPONS["super"] = nil
  GAME.PICKUPS["mega"]  = nil

  -- tweak monster probabilities
  GAME.MONSTERS["Cyberdemon"].crazy_prob = 8
  GAME.MONSTERS["Mastermind"].crazy_prob = 12
end



function DOOM1.end_level()
  if LEVEL.description and LEVEL.patch then
    DOOM.make_level_gfx()
  end
end


function DOOM1.all_done()
  DOOM.make_cool_gfx()

  gui.wad_merge_sections("doom_falls.wad");
end


------------------------------------------------------------


------------------------------------------------------------

