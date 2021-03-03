------------------------------------------------------------------------
--  STRIFE ENTITIES
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2011 Andrew Apted
--  Copyright (C) 2011-2012 Jared Blackburn
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

STRIFE.ENTITIES =
{
  --- players
  player1 = { id=1, r=16, h=56 },
  player2 = { id=2, r=16, h=56 },
  player3 = { id=3, r=16, h=56 },
  player4 = { id=4, r=16, h=56 },

  dm_player     = { id=11 },
  teleport_spot = { id=14 },

  --- pickups ---
  k_yellow   = { id=80 },

  --- scenery ---
  wall_torch  = { id=50, r=10, h=64, light=255 },
}

STRIFE.PLAYER_MODEL =
{
  strifeguy =
  {
    stats   = { health=0 },
    weapons = { dagger=1 },
  },
}
