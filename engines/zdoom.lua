----------------------------------------------------------------
--  Engine: ZDoom
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2008 Andrew Apted
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

ZDOOM = { }

ZDOOM.ENTITIES =
{
  -- players --

  player5 = { id=4001, kind="other", r=16,h=56 }
  player6 = { id=4002, kind="other", r=16,h=56 }
  player7 = { id=4003, kind="other", r=16,h=56 }
  player8 = { id=4004, kind="other", r=16,h=56 }

  -- monsters --

  mbf_dog = { id=888, kind="monster", r=12,h=28 }

  -- scenery --

  fountain_red    = { id=9027, kind="scenery", r=16,h=16, pass=true }
  fountain_green  = { id=9028, kind="scenery", r=16,h=16, pass=true }
  fountain_blue   = { id=9029, kind="scenery", r=16,h=16, pass=true }
  fountain_yellow = { id=9030, kind="scenery", r=16,h=16, pass=true }
  fountain_purple = { id=9031, kind="scenery", r=16,h=16, pass=true }
  fountain_black  = { id=9032, kind="scenery", r=16,h=16, pass=true }
  fountain_white  = { id=9033, kind="scenery", r=16,h=16, pass=true }
}


ZDOOM.PARAMETERS =
{
  -- TODO
}


OB_ENGINES["zdoom"] =
{
  label = "ZDoom"

  extends = "boom"

  game =
  {
    chex3=1, doom1=1, doom2=1, heretic=1, hexen=1
  }

  tables =
  {
    ZDOOM
  }
}


----------------------------------------------------------------

GZDOOM = { }

GZDOOM.PARAMETERS =
{
  bridges = true
  extra_floors = true
  liquid_floors = true
}


function GZDOOM.setup()
  -- extrafloors : use Legacy types
  gui.property("ef_solid_type",  281)
  gui.property("ef_liquid_type", 301)

  -- currently using Fragglescript for things on 3D floors
  -- [later we will use the Hexen map format]
  gui.property("ef_thing_mode", 1)
end


OB_ENGINES["gzdoom"] =
{
  label = "GZDoom"
  priority = -1  -- keep at bottom with ZDoom

  extends = "zdoom"

  game =
  {
    chex3=1, doom1=1, doom2=1, heretic=1, hexen=1
  }

  tables =
  {
    GZDOOM
  }

  hooks =
  {
    setup = GZDOOM.setup
  }
}

