------------------------------------------------------------------------
--  HERETIC ENTITIES
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2015 Andrew Apted
--  Copyright (C)      2008 Sam Trenholme
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

HERETIC.ENTITIES =
{
  --- player stuff ---
  player1 = { id=1, r=16, h=56 }
  player2 = { id=2, r=16, h=56 }
  player3 = { id=3, r=16, h=56 }
  player4 = { id=4, r=16, h=56 }

  dm_player     = { id=11 }
  teleport_spot = { id=14 }

  --- keys ---
  k_yellow   = { id=80 }
  k_green    = { id=73 }
  k_blue     = { id=79 }

  --- powerups ---
  bag     = { id=8  }
  wings   = { id=83 }
  ovum    = { id=30 }
  torch   = { id=33 }
  bomb    = { id=34 }
  map     = { id=35 }
  chaos   = { id=36 }
  shadow  = { id=75 }
  ring    = { id=84 }
  tome    = { id=86 }

  --- scenery ---
  wall_torch    = { id=50, r=10, h=64, light=255, pass=true, add_mode="extend" }
  serpent_torch = { id=27, r=12, h=54, light=255 }
  fire_brazier  = { id=76, r=16, h=44, light=255 }
  chandelier    = { id=28, r=31, h=60, light=255, pass=true, ceil=true, add_mode="island" }

  barrel  = { id=44,   r=12, h=32 }
  pod     = { id=2035, r=16, h=54 }

  blue_statue   = { id=94, r=16, h=54 }
  green_statue  = { id=95, r=16, h=54 }
  yellow_statue = { id=96, r=16, h=54 }

  moss1   = { id=48, r=16, h=24, ceil=true, pass=true }
  moss2   = { id=49, r=16, h=28, ceil=true, pass=true }
  volcano = { id=87, r=12, h=32 }
  
  small_pillar = { id=29, r=16, h=36 }
  brown_pillar = { id=47, r=16, h=128 }
  glitter_red  = { id=74, r=20, h=16, pass=true }
  glitter_blue = { id=52, r=20, h=16, pass=true }

  stal_small_F = { id=37, r=12, h=36 }
  stal_small_C = { id=39, r=16, h=36, ceil=true }
  stal_big_F   = { id=38, r=12, h=72 }
  stal_big_C   = { id=40, r=16, h=72, ceil=true }

  hang_skull_1 = { id=17, r=20, h=64, ceil=true, pass=true }
  hang_skull_2 = { id=24, r=20, h=64, ceil=true, pass=true }
  hang_skull_3 = { id=25, r=20, h=64, ceil=true, pass=true }
  hang_skull_4 = { id=26, r=20, h=64, ceil=true, pass=true }
  hang_corpse  = { id=51, r=12, h=104,ceil=true }

  --- miscellaneous ---
  dummy = { id=49 }

  secret = { id="oblige_secret", r=1, h=1, pass=true }

  --- ambient sounds ---
  amb_scream = { id=1200 }
  amb_squish = { id=1201 }
  amb_drip   = { id=1202 }
  amb_feet   = { id=1203 }
  amb_heart  = { id=1204 }
  amb_bells  = { id=1205 }
  amb_growl  = { id=1206 }
  amb_magic  = { id=1207 }
  amb_laugh  = { id=1208 }
  amb_run    = { id=1209 }

  env_water  = { id=41 }
  env_wind   = { id=42 }
}


------------------------------------------------------------

HERETIC.PLAYER_MODEL =
{
  cleric =
  {
    stats = { health=0 }
    weapons = { staff=1, wand=1 }
  }
}

