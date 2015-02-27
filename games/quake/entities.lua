------------------------------------------------------------------------
--  QUAKE ENTITIES
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2012 Andrew Apted
--  Copyright (C)      2011 Chris Pisarczyk
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

QUAKE.ENTITIES =
{
  -- players
  player1 = { id="info_player_start", r=16, h=56 }
  player2 = { id="info_player_coop",  r=16, h=56 }
  player3 = { id="info_player_coop",  r=16, h=56 }
  player4 = { id="info_player_coop",  r=16, h=56 }

  dm_player = { id="info_player_deathmatch" }

  teleport_spot = { id="info_teleport_destination" }

  -- keys
  k_silver = { id="item_key1" }
  k_gold   = { id="item_key2" }

  -- powerups
  suit   = { id="item_artifact_envirosuit" }
  invis  = { id="item_artifact_invisibility" }
  invuln = { id="item_artifact_invulnerability" }
  quad   = { id="item_artifact_super_damage" }

  -- scenery
  barrel     = { id="misc_explobox",  r=30, h=80 }
  explode_bg = { id="misc_explobox2", r=30, h=40 }
  crucified  = { id="monster_zombie", spawnflags=1, r=32, h=64 }

  -- light sources
  torch      = { id="light_torch_small_walltorch",  r=30, h=60, pass=true }
  globe      = { id="light_globe", r=10, h=10, pass=true }
  flame1     = { id="light_flame_small_white", r=10, h=10, pass=true }
  flame2     = { id="light_flame_small_yellow", r=10, h=10, pass=true }
  flame3     = { id="light_flame_large_yellow", r=10, h=10, pass=true }

  fireball   = { id="misc_fireball",  r=10, h=10, pass=true }

  -- ambient sounds
  snd_computer = { id="ambient_comp_hum",  r=30, h=30, pass=true }
  snd_buzz     = { id="ambient_light_buzz",r=30, h=30, pass=true }
  snd_buzz2    = { id="ambient_flouro_buzz",r=30, h=30, pass=true }
  snd_drip     = { id="ambient_drip",      r=30, h=30, pass=true }
  snd_drone    = { id="ambient_drone",     r=30, h=30, pass=true }
  snd_wind     = { id="ambient_suck_wind", r=30, h=30, pass=true }
  snd_swamp1   = { id="ambient_swamp1",    r=30, h=30, pass=true }
  snd_swamp2   = { id="ambient_swamp2",    r=30, h=30, pass=true }
  snd_thunder  = { id="ambient_thunder",   r=30, h=30, pass=true }

  -- special

  dummy = { id="info_null" }

  light = { id="light" }
  sun   = { id="oblige_sun" }

  trigger    = { id="trigger_multiple" }
  change_lev = { id="trigger_changelevel" }
  teleport   = { id="trigger_teleport" }

  door = { id="func_door" }
  lift = { id="func_plat" }
  wall = { id="func_wall" }
  button = { id="func_button" }

  secret = { id="trigger_secret" }
  secret_door = { id="func_door_secret" }

  camera = { id="info_intermission" }
  spiker = { id="trap_spikeshooter" }
}


----------------------------------------------------

QUAKE.PLAYER_MODEL =
{
  quakeguy =
  {
    stats   = { health=0 }
    weapons = { pistol=1, axe=1 }
  }
}

