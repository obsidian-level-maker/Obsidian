----------------------------------------------------------------
--  MODULE: disable prebuilt maps
----------------------------------------------------------------
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


NO_PREBUILT_DOOM = {}


NO_PREBUILT_DOOM.PREBUILT_LEVELS =
{
  -- NOTE: keep the boss maps (ExM8 and MAP30), since they have
  --       special stuff going on.

  MAP07  = REMOVE_ME
  GOTCHA = REMOVE_ME
  GALLOW = REMOVE_ME
}


OB_MODULES["no_prebuilt_doom"] =
{
  label = "Disable Prebuilt Non-Boss Maps"

  game = { doom1=1, doom2=1 }

  tables =
  {
    NO_PREBUILT_DOOM
  }
}

