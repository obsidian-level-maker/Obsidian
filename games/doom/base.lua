----------------------------------------------------------------
--  BASE DEFINITIONS for DOOM, DOOM II (etc)
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2014 Andrew Apted
--  Copyright (C) 2011,2014 Chris Pisarczyk
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

DOOM  = { }  -- common stuff

DOOM1 = { }  -- stuff specific to each game
DOOM2 = { }  --

TNT      = { }
PLUTONIA = { }
FREEDOOM = { }


-- prefab stuff

PREFABS = {}

GROUPS = {}


------------------------------------------------------------


require "params"

require "entities"
require "monsters"
require "pickups"
require "weapons"

require "materials"
require "themes"
require "v3_skins"

require "levels"
require "resources"


------------------------------------------------------------


function DOOM1.setup()
  -- tweak monster probabilities
  GAME.MONSTERS["Cyberdemon"].crazy_prob = 5
  GAME.MONSTERS["Mastermind"].crazy_prob = 12
end


------------------------------------------------------------

OB_GAMES["doom2"] =
{
  label = "Doom 2"

  priority = 99  -- keep at top

  format = "doom"

  tables =
  {
    DOOM, DOOM2
  }

  hooks =
  {
    get_levels = DOOM2.get_levels
    end_level  = DOOM2.end_level
    all_done   = DOOM2.all_done
  }
}


OB_GAMES["doom1"] =
{
  label = "Doom 1"

  priority = 98  -- keep at second spot

  format = "doom"

  tables =
  {
    DOOM, DOOM1
  }

  hooks =
  {
    setup        = DOOM1.setup
    get_levels   = DOOM1.get_levels
    end_level    = DOOM1.end_level
    all_done     = DOOM1.all_done
  }
}


OB_GAMES["ultdoom"] =
{
  label = "Ultimate Doom"

  extends = "doom1"

  priority = 97  -- keep at third spot
  
  -- no additional tables

  -- no additional hooks
}


OB_GAMES["tnt"] =
{
  label = "TNT Evilution"

  extends = "doom2"

  tables =
  {
    TNT
  }
}


OB_GAMES["plutonia"] =
{
  label = "Plutonia Exp."

  extends = "doom2"

  tables =
  {
    PLUTONIA
  }
}


OB_GAMES["freedoom"] =
{
  label = "FreeDoom"

  extends = "doom2"

  tables =
  {
    FREEDOOM
  }
}

