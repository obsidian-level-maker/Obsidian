----------------------------------------------------------------
--  GAME DEFINITION : Blasphemer
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

BLASPHEMER = { }


function BLASPHEMER.setup()

  -- Blashphemer is lacking some scenery sprites

  GAME.ENTITIES.hang_arm_pair = nil
  GAME.ENTITIES.hang_leg_pair = nil
  GAME.ENTITIES.hang_leg_gone = nil
  GAME.ENTITIES.hang_leg      = nil
end


OB_GAMES["blasphemer"] =
{
  label = "Blasphemer"

  extends = "heretic"

  tables =
  {
    BLASPHEMER
  }

  hooks =
  {
    setup = BLASPHEMER.setup
  }

  -- no additional parameters
}

