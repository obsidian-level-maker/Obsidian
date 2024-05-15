------------------------------------------------------------------------
--  STRIFE PARAMETERS and ACTIONS
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2015 Andrew Apted
--  Copyright (C) 2011-2012 Jared Blackburn

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
------------------------------------------------------------------------

STRIFE.PARAMETERS =
{
  max_name_length = 28,
  titlepic_lump   = "TITLEPIC",
  titlepic_format = "patch",
  -- This only works in conjunction with ZDoom's MAPINFO, as DEH/BEX don't work with vanilla Strife (I think)
  bex_map_prefix = "HUSTR_",
}

STRIFE.MUSIC_LIST =
{
  [1] = "D_ACTION",
  [2] = "D_FAST",
  [3] = "D_DANGER",
  [4] = "D_DARKER",
  [5] = "D_STRIKE",
  [6] = "D_SLIDE",
  [7] = "D_TRIBAL",
  [8] = "D_MARCH",
  [9] = "D_MOOD",
  [10] = "D_CASTLE",
  [11] = "D_FIGHT",
  [12] = "D_SPENSE",
  [13] = "D_DARK",
  [14] = "D_TECH",
  [15] = "D_DRONE",
  [16] = "D_PANTHR",
  [17] = "D_INSTRY"
}