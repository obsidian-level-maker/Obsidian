----------------------------------------------------------------
--  Engine: ZDoom
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2008-2017  Andrew Apted
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
----------------------------------------------------------------

ZDOOM = {}


ZDOOM.ENTITIES =
{
  -- monsters --

  mbf_dog = { id=888, r=12,h=28 },

  -- scenery --

  fountain_red    = { id=9027, r=16,h=16, pass=true },
  fountain_green  = { id=9028, r=16,h=16, pass=true },
  fountain_blue   = { id=9029, r=16,h=16, pass=true },
  fountain_yellow = { id=9030, r=16,h=16, pass=true },
  fountain_purple = { id=9031, r=16,h=16, pass=true },
  fountain_black  = { id=9032, r=16,h=16, pass=true },
  fountain_white  = { id=9033, r=16,h=16, pass=true }
}


ZDOOM.PARAMETERS =
{
  bridges = true,
  extra_floors = true,
  liquid_floors = true,
  tga_images = true
}

function ZDOOM.setup()
  -- extrafloors : use Legacy types
  gui.property("ef_solid_type",  281)
  gui.property("ef_liquid_type", 301)

  -- currently using Fragglescript for things on 3D floors
  -- [later we will use the Hexen map format]
  gui.property("ef_thing_mode", 1)
end

OB_PORTS["zdoom"] =
{
  label = _("GZDoom"),
  priority = 100,

  extends = "advanced",

  game =
  {
    chex1=0, doom1=1, doom2=1, heretic=1, hacx=0, harmony=0, strife=0, rekkr=0
  },

  tables =
  {
    ZDOOM
  },
  
  hooks =
  {
    setup = ZDOOM.setup
  }
  
}

