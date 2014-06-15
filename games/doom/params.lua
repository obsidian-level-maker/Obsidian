--------------------------------------------------------------------
--  DOOM PARAMETERS (Feature Set)
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2013 Andrew Apted
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------

DOOM.PARAMETERS =
{
  teleporters = true

  jump_height = 24

  map_limit = 12800

  -- this is roughly how many characters can fit on the
  -- intermission screens (the CWILVxx patches).  It does not
  -- reflect any buffer limits in the DOOM.EXE
  max_name_length = 28

  skip_monsters = { 15,25,35 }

  time_factor    = 1.0
  ammo_factor    = 1.0
  health_factor  = 0.8
  monster_factor = 1.0

  bex_map_prefix = "HUSTR_"
}


DOOM2.PARAMETERS =
{
  -- these are in addition to the above

  doom2_monsters = true
  doom2_weapons  = true
  doom2_skies    = true  -- RSKY# patches

  skip_monsters = { 20,30,45 }
}


TNT.PARAMETERS =
{
  bex_map_prefix = "THUSTR_"
}


PLUTONIA.PARAMETERS =
{
  bex_map_prefix = "PHUSTR_"
}

