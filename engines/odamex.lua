----------------------------------------------------------------
--  Engine: Odamex
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2012 Andrew Apted
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

ODAMEX = { }


ODAMEX.ENTITIES =
{
  -- TODO
}


ODAMEX.PARAMETERS =
{
  -- TODO
}


function ODAMEX.setup()
end


OB_ENGINES["odamex"] =
{
  label = "Odamex"
  extends = "boom"

  game = { doom1=1, doom2=1 }

  tables =
  {
    ODAMEX
  }

  hooks =
  {
    setup = ODAMEX.setup
  }
}

