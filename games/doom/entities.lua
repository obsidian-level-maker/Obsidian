--------------------------------------------------------------------
--  DOOM ENTITIES
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2013 Andrew Apted
--  Copyright (C) 2011, 2019 Armaetus
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------

DOOM.ENTITIES =
{
  --- PLAYERS ---

  player1 = { id=1, r=16, h=56 },
  player2 = { id=2, r=16, h=56 },
  player3 = { id=3, r=16, h=56 },
  player4 = { id=4, r=16, h=56 },

  dm_player     = { id=11 },
  teleport_spot = { id=14 },

  --- KEYS ---

  k_red      = { id=13 },
  k_yellow   = { id=6  },
  k_blue     = { id=5  },

  ks_red     = { id=38 },
  ks_yellow  = { id=39 },
  ks_blue    = { id=40 },

  --- SCENERY ---

  -- lights --
  lamp         = { id=2028, r=16, h=48,  light=255 },
  tech_column  = { id=48,   r=16, h=128, light=255 },

  -- these two lamps are not available in DOOM 1,
  mercury_lamp   = { id=85,  r=16, h=80, light=255 },
  mercury_small  = { id=86,  r=16, h=60, light=255 },

  candle         = { id=34, r=16, h=16, light=111, pass=true },
  candelabra     = { id=35, r=16, h=56, light=255 },
  burning_barrel = { id=70, r=16, h=44, light=255 },

  blue_torch     = { id=44, r=16, h=96, light=255 },
  blue_torch_sm  = { id=55, r=16, h=72, light=255 },
  green_torch    = { id=45, r=16, h=96, light=255 },
  green_torch_sm = { id=56, r=16, h=72, light=255 },
  red_torch      = { id=46, r=16, h=96, light=255 },
  red_torch_sm   = { id=57, r=16, h=72, light=255 },

  -- decoration --
  barrel = { id=2035, r=12, h=44 }, -- Explosive barrel

  green_pillar     = { id=30, r=16, h=56 }, -- Short green pillar
  green_column     = { id=31, r=16, h=40 }, -- Tall green pillar
  green_column_hrt = { id=36, r=16, h=56, add_mode="island" }, -- Green pillar with beating heart

  red_pillar     = { id=32, r=16, h=52 }, -- Short red pillar
  red_column     = { id=33, r=16, h=56 }, -- Tall red pillar
  red_column_skl = { id=37, r=16, h=56, add_mode="island" }, -- Red pillar with skull on it

  burnt_tree = { id=43, r=16, h=56, add_mode="island" }, -- Small gray tree
  brown_stub = { id=47, r=16, h=56, add_mode="island" }, -- Brown stub
  big_tree   = { id=54, r=31, h=120,add_mode="island" }, -- Large brown tree

  -- gore --
  evil_eye    = { id=41, r=16, h=56, add_mode="island" },
  skull_rock  = { id=42, r=16, h=48 }, -- Firey rock with skulls
  skull_pole  = { id=27, r=16, h=52 }, -- Human head on pike
  skull_kebab = { id=28, r=20, h=64 }, -- Multiple human heads on a pike
  skull_cairn = { id=29, r=20, h=40, add_mode="island" }, -- Flaming skull pile with candles

  impaled_human  = { id=25,r=20, h=64 }, -- Dead human on pike
  impaled_twitch = { id=26,r=16, h=64 }, -- Dying human on pike

  -- these "gutted_XXX" things are not available in DOOM 1,
  gutted_victim1 = { id=73, r=16, h=88, ceil=true }, -- Hanging corpse, intestines exposed
  gutted_victim2 = { id=74, r=16, h=88, ceil=true }, -- Hanging corpse, hole in head, no intestines and missing leg
  gutted_torso1  = { id=75, r=16, h=64, ceil=true }, -- Hanging torso, looking down
  gutted_torso2  = { id=76, r=16, h=64, ceil=true }, -- Hanging torso, brain exposed
  gutted_torso3  = { id=77, r=16, h=64, ceil=true }, -- Hanging torso, looking up
  gutted_torso4  = { id=78, r=16, h=64, ceil=true }, -- Hanging torso, empty cranial cavity

  hang_arm_pair  = { id=59, r=20, h=84, ceil=true, pass=true }, -- Hanging corpse, arms out, intact body
  hang_leg_gone  = { id=61, r=20, h=52, ceil=true, pass=true }, -- Hanging corpse, hung by one leg
  hang_torso     = { id=60, r=20, h=68, ceil=true, pass=true }, -- Hanging torso, formerly used for hang_lamp
  hang_leg       = { id=62, r=20, h=52, ceil=true, pass=true }, -- Hanging leg
  hang_twitching = { id=63, r=20, h=68, ceil=true, pass=true }, -- Hanging corpse, twitching

  gibs          = { id=24, r=20, h=16, pass=true }, -- Blood and bones
  gibbed_player = { id=10, r=20, h=16, pass=true }, -- Gibbed player

  -- these three are not available in DOOM 1,
  pool_blood_1  = { id=79, r=20, h=16, pass=true }, -- Pool of blood and skin/guts
  pool_blood_2  = { id=80, r=20, h=16, pass=true }, -- Small pool of blood
  pool_brains   = { id=81, r=20, h=16, pass=true }, -- Pool of brains in blood

  -- Note: id=12 exists, but is exactly the same as id=10,

  dead_player  = { id=15, r=16, h=16, pass=true },
  dead_zombie  = { id=18, r=16, h=16, pass=true },
  dead_shooter = { id=19, r=16, h=16, pass=true },
  dead_imp     = { id=20, r=16, h=16, pass=true },
  dead_demon   = { id=21, r=16, h=16, pass=true },
  dead_caco    = { id=22, r=16, h=16, pass=true },
  dead_skull   = { id=23, r=16, h=16, pass=true },

  -- special stuff --
  keen  = { id=72, r=16, h=72, ceil=true },

  brain_boss    = { id=88, r=16, h=16 },
  brain_shooter = { id=89, r=20, h=32 },
  brain_target  = { id=87, r=20, h=32, pass=true },

  dummy = { id=23, r=16, h=16, pass=true },

  light  = { id="light", r=1, h=1, pass=true },
  secret = { id="oblige_secret", r=1, h=1, pass=true },
  depot_ref = { id="oblige_depot", r=1, h=1, pass=true },

  -- These are ZDoom only entitles --
  -- I'm adding these so these potentially may have use in the future.
  actor_mover = { id=9074, r=28, h=16, pass=true }, -- Class: ActorMover
  aiming_camera = { id=9073, r=28, h=16, pass=true }, -- Class: AimingCamera
  eternity_skybox_viewpoint = { id=9083, r=28, h=16, pass=true }, -- Class: SkyCamCompat
  interpol_point = { id=9070, r=28, h=16, pass=true }, -- Class: InterpolationPoint
  interpol_special = { id=9075, r=28, h=16, pass=true }, -- Class: InterpolationSpecial
  moving_camera = { id=9072, r=28, h=16, pass=true }, -- Class: MovingCamera
  path_follower = { id=9071, r=28, h=16, pass=true }, -- Class: PathFollower
  patrol_spec = { id=9047, r=28, h=16, pass=true }, -- Class: PatrolSpecial
  patrol_point = { id=9024, r=28, h=20, pass=true }, -- Class: PatrolPoint
  security_camera = { id=9025, r=28, h=16, pass=true }, -- Class: SecurityCamera
  decal = { id=9200, r=28, h=20, pass=true }, -- Class: Decal
  spark_effect = { id=9026, r=28, h=20, pass=true }, -- Class: Spark. Just like the Quake spark effect! Exploitable on prefabs!

}


----------------------------------------------------------------

DOOM.PLAYER_MODEL =
{
  doomguy =
  {
    stats   = { health=0 },
    weapons = { pistol=1, fist=1 }
  }
}
