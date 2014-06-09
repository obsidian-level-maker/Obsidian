--------------------------------------------------------------------
--  DOOM ENTITIES
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2013 Andrew Apted
--  Copyright (C)      2011 Chris Pisarczyk
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------

DOOM.ENTITIES =
{
  --- PLAYERS ---

  player1 = { id=1, r=16, h=56 }
  player2 = { id=2, r=16, h=56 }
  player3 = { id=3, r=16, h=56 }
  player4 = { id=4, r=16, h=56 }

  -- these are not standard, but most source ports will handle them or
  -- ignore them with a warning.
  player5 = { id=4001, r=16, h=56 }
  player6 = { id=4002, r=16, h=56 }
  player7 = { id=4003, r=16, h=56 }
  player8 = { id=4004, r=16, h=56 }

  dm_player     = { id=11 }
  teleport_spot = { id=14 }

  --- KEYS ---

  kc_red     = { id=13 }
  kc_yellow  = { id=6  }
  kc_blue    = { id=5  }

  ks_red     = { id=38 }
  ks_yellow  = { id=39 }
  ks_blue    = { id=40 }

  --- POWERUPS ---

  backpack = { id=8 }   -- FIXME: REMOVE

  suit = { id=2025 }


  --- SCENERY ---

  -- lights --
  lamp         = { id=2028,r=16, h=48, light=255 }
  mercury_lamp = { id=85,  r=16, h=80, light=255 }
  short_lamp   = { id=86,  r=16, h=60, light=255 }
  tech_column  = { id=48,  r=16, h=128,light=255 }

  candle         = { id=34, r=16, h=16, light=111, pass=true }
  candelabra     = { id=35, r=16, h=56, light=255 }
  burning_barrel = { id=70, r=16, h=44, light=255 }

  blue_torch     = { id=44, r=16, h=96, light=255 }
  blue_torch_sm  = { id=55, r=16, h=72, light=255 }
  green_torch    = { id=45, r=16, h=96, light=255 }
  green_torch_sm = { id=56, r=16, h=72, light=255 }
  red_torch      = { id=46, r=16, h=96, light=255 }
  red_torch_sm   = { id=57, r=16, h=72, light=255 }

  -- decoration --
  barrel = { id=2035, r=12, h=44 }

  green_pillar     = { id=30, r=16, h=56 }
  green_column     = { id=31, r=16, h=40 }
  green_column_hrt = { id=36, r=16, h=56, add_mode="island" }

  red_pillar     = { id=32, r=16, h=52 }
  red_column     = { id=33, r=16, h=56 }
  red_column_skl = { id=37, r=16, h=56, add_mode="island" }

  burnt_tree = { id=43, r=16, h=56, add_mode="island" }
  brown_stub = { id=47, r=16, h=56, add_mode="island" }
  big_tree   = { id=54, r=31, h=120,add_mode="island" }

  -- gore --
  evil_eye    = { id=41, r=16, h=56, add_mode="island" }
  skull_rock  = { id=42, r=16, h=48 }
  skull_pole  = { id=27, r=16, h=52 }
  skull_kebab = { id=28, r=20, h=64 }
  skull_cairn = { id=29, r=20, h=40, add_mode="island" }

  impaled_human  = { id=25,r=20, h=64 }
  impaled_twitch = { id=26,r=16, h=64 }

  gutted_victim1 = { id=73, r=16, h=88, ceil=true }
  gutted_victim2 = { id=74, r=16, h=88, ceil=true }
  gutted_torso1  = { id=75, r=16, h=64, ceil=true }
  gutted_torso2  = { id=76, r=16, h=64, ceil=true }
  gutted_torso3  = { id=77, r=16, h=64, ceil=true }
  gutted_torso4  = { id=78, r=16, h=64, ceil=true }

  hang_arm_pair  = { id=59, r=20, h=84, ceil=true, pass=true }
  hang_leg_pair  = { id=60, r=20, h=68, ceil=true, pass=true }
  hang_leg_gone  = { id=61, r=20, h=52, ceil=true, pass=true }
  hang_leg       = { id=62, r=20, h=52, ceil=true, pass=true }
  hang_twitching = { id=63, r=20, h=68, ceil=true, pass=true }

  gibs          = { id=24, r=20, h=16, pass=true }
  gibbed_player = { id=10, r=20, h=16, pass=true }
  pool_blood_1  = { id=79, r=20, h=16, pass=true }
  pool_blood_2  = { id=80, r=20, h=16, pass=true }
  pool_brains   = { id=81, r=20, h=16, pass=true }

  -- Note: id=12 exists, but is exactly the same as id=10

  dead_player  = { id=15, r=16, h=16, pass=true }
  dead_zombie  = { id=18, r=16, h=16, pass=true }
  dead_shooter = { id=19, r=16, h=16, pass=true }
  dead_imp     = { id=20, r=16, h=16, pass=true }
  dead_demon   = { id=21, r=16, h=16, pass=true }
  dead_caco    = { id=22, r=16, h=16, pass=true }
  dead_skull   = { id=23, r=16, h=16, pass=true }

  -- CTF things (NOTE: these don't exist in vanilla DOOM)
  ctf_blue_flag  = { id=5130, r=16, h=56, pass=true }
  ctf_blue_start = { id=5080, r=16, h=56, pass=true }
  ctf_red_flag   = { id=5131, r=16, h=56, pass=true }
  ctf_red_start  = { id=5081, r=16, h=56, pass=true }

  -- special stuff --
  dummy = { id=23, r=16, h=16, pass=true }

  keen  = { id=72, r=16, h=72, ceil=true }

  brain_boss    = { id=88, r=16, h=16 }
  brain_shooter = { id=89, r=20, h=32 }
  brain_target  = { id=87, r=20, h=32, pass=true }

  light = { id="light", r=1, h=1, pass=true }
}


----------------------------------------------------------------

DOOM.PLAYER_MODEL =
{
  doomguy =
  {
    stats   = { health=0 }
    weapons = { pistol=1, fist=1 }
  }
}

