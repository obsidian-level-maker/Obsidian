------------------------------------------------------------------------
--  WOLF3D ENTITIES
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

WOLF.ENTITIES =
{
  -- players
  player1 = { kind="other", r=30, h=60,
              id={ easy=19, medium=19, hard=19, dirs="player" },
            },

  -- enemies
  dog     = { kind="monster", r=30, h=60,
              id={ easy=138, medium=174, hard=210, dirs=true },
            },
  guard   = { kind="monster", r=30, h=60,
              id={ easy=108, medium=144, hard=180, dirs=true, patrol=4 },
            },
  officer = { kind="monster", r=30, h=60,
              id={ easy=116, medium=152, hard=188, dirs=true, patrol=4 },
            },
  ss_dude = { kind="monster", r=30, h=60,
              id={ easy=126, medium=162, hard=198, dirs=true, patrol=4 },
            },
  mutant  = { kind="monster", r=30, h=60,
              id={ easy=216, medium=234, hard=252, dirs=true, patrol=4 },
            },

  fake_hitler = { kind="monster", id=160, r=30, h=60 },

  -- bosses
  Fatface    = { kind="monster", id=179, r=30, h=60 },
  Gretel     = { kind="monster", id=197, r=30, h=60 },
  Hans       = { kind="monster", id=214, r=30, h=60 },
  Schabbs    = { kind="monster", id=196, r=30, h=60 },
  Giftmacher = { kind="monster", id=215, r=30, h=60 },
  Hitler     = { kind="monster", id=178, r=30, h=60 },

  -- ghosts (red, yellow, pink, blue)
  blinky = { kind="monster", id=224, r=30, h=60 },
  clyde  = { kind="monster", id=225, r=30, h=60 },
  pinky  = { kind="monster", id=226, r=30, h=60 },
  inky   = { kind="monster", id=227, r=30, h=60 },

  -- pickups
  k_silver = { kind="pickup", id=44, r=30, h=60, pass=true },
  k_gold   = { kind="pickup", id=43, r=30, h=60, pass=true },

  first_aid = { kind="pickup", id=48, r=30, h=60, pass=true },
  good_food = { kind="pickup", id=47, r=30, h=60, pass=true },
  dog_food  = { kind="pickup", id=29, r=30, h=60, pass=true },

  clip        = { kind="pickup", id=49, r=30, h=60, pass=true },
  machine_gun = { kind="pickup", id=50, r=30, h=60, pass=true },
  gatling_gun = { kind="pickup", id=51, r=30, h=60, pass=true },

  cross   = { kind="pickup", id=52, r=30, h=60, pass=true },
  chalice = { kind="pickup", id=53, r=30, h=60, pass=true },
  chest   = { kind="pickup", id=54, r=30, h=60, pass=true },
  crown   = { kind="pickup", id=55, r=30, h=60, pass=true },
  one_up  = { kind="pickup", id=56, r=30, h=60, pass=true },

  -- scenery
  green_barrel = { kind="scenery", id=24, r=30, h=60 },
  table_chairs = { kind="scenery", id=25, r=30, h=60, add_mode="island" },

  puddle     = { kind="scenery", id=23, r=30, h=60, pass=true },
  floor_lamp = { kind="scenery", id=26, r=30, h=60, light=255 },
  chandelier = { kind="scenery", id=27, r=30, h=60, light=255, pass=true, ceil=true, add_mode="island" },
  hanged_man = { kind="scenery", id=28, r=30, h=60, add_mode="island" },
  red_pillar = { kind="scenery", id=30, r=30, h=60, add_mode="island" },

  tree  = { kind="scenery", id=31, r=30, h=60 },
  sink  = { kind="scenery", id=33, r=30, h=60, add_mode="extend" },
  plant = { kind="scenery", id=34, r=30, h=60 },
  urn   = { kind="scenery", id=35, r=30, h=60 },

  bare_table    = { kind="scenery", id=36, r=30, h=60, add_mode="island" },
  ceil_light    = { kind="scenery", id=37, r=30, h=60, pass=true, ceil=true, light=255, add_mode="island" },
  skeleton_flat = { kind="scenery", id=32, r=30, h=60, pass=true },
  kitchen_stuff = { kind="scenery", id=38, r=30, h=60 },
  suit_of_armor = { kind="scenery", id=39, r=30, h=60, add_mode="extend" },
  hanging_cage  = { kind="scenery", id=40, r=30, h=60, add_mode="island" },

  skeleton_in_cage = { kind="scenery", id=41, r=30, h=60, add_mode="island" },
  skeleton_relax   = { kind="scenery", id=42, r=30, h=60, pass=true },

  bed    = { kind="scenery", id=45, r=30, h=60 },
  basket = { kind="scenery", id=46, r=30, h=60 },
  barrel = { kind="scenery", id=58, r=30, h=60 },
  gibs_1 = { kind="scenery", id=57, r=30, h=60, pass=true },
  gibs_2 = { kind="scenery", id=61, r=30, h=60, pass=true },
  flag   = { kind="scenery", id=62, r=30, h=60 },

  water_well = { kind="scenery", id=59, r=30, h=60 },
  empty_well = { kind="scenery", id=60, r=30, h=60 },
  aardwolf   = { kind="scenery", id=63, r=30, h=60 },

  junk_1 = { kind="scenery", id=64, r=30, h=60, pass=true },
  junk_2 = { kind="scenery", id=65, r=30, h=60, pass=true },
  junk_3 = { kind="scenery", id=66, r=30, h=60, pass=true },
  pots   = { kind="scenery", id=67, r=30, h=60, pass=true, add_mode="extend" },
  stove  = { kind="scenery", id=68, r=30, h=60 },
  spears = { kind="scenery", id=69, r=30, h=60, add_mode="extend" },
  vines  = { kind="scenery", id=70, r=30, h=60, pass=true },

  dud_clip   = { kind="scenery", id=71,  r=30, h=60, pass=true },
  dead_guard = { kind="scenery", id=124, r=30, h=60, pass=true },

  -- special
  secret  = { kind="other", id=98, r=30,h=60, pass=true },
  endgame = { kind="other", id=99, r=30,h=60, pass=true },

  turn_E  = { kind="other", id=90, r=30,h=60, pass=true },
  turn_NE = { kind="other", id=91, r=30,h=60, pass=true },
  turn_N  = { kind="other", id=92, r=30,h=60, pass=true },
  turn_NW = { kind="other", id=93, r=30,h=60, pass=true },
  turn_W  = { kind="other", id=94, r=30,h=60, pass=true },
  turn_SW = { kind="other", id=95, r=30,h=60, pass=true },
  turn_S  = { kind="other", id=96, r=30,h=60, pass=true },
  turn_SE = { kind="other", id=97, r=30,h=60, pass=true },


  ---===| Spear of Destiny |===---


  chest_of_ammo    = { kind="pickup", id=72, r=30, h=60 },
  spear_of_destiny = { kind="pickup", id=74, r=30, h=60 },

  ghost          = { kind="monster", id=106, r=30, h=60 },
  angel_of_death = { kind="monster", id=107, r=30, h=60 },
  trans_grosse   = { kind="monster", id=125, r=30, h=60 },
  uber_mutant    = { kind="monster", id=142, r=30, h=60 },
  wilhelm        = { kind="monster", id=143, r=30, h=60 },
  death_knight   = { kind="monster", id=161, r=30, h=60 },

  -- skull_stick REPLACES: sink
  -- skull_cage  REPLACES: bed
  -- ceil_light2 REPLACES: aardwolf

  skull_stick = { kind="scenery", id=33, r=30, h=60 },
  skull_cage  = { kind="scenery", id=45, r=30, h=60 },
  ceil_light2 = { kind="scenery", id=63, r=30, h=60, pass=true, ceil=true, light=255 },

  -- cow_skull     REPLACES: pots
  -- blood_well    REPLACES: stove
  -- angel_statue  REPLACES: spears
  -- marble_column REPLACES: dud_clip

  cow_skull    = { kind="scenery", id=67, r=30, h=60 },
  blood_well   = { kind="scenery", id=68, r=30, h=60 },
  angel_statue = { kind="scenery", id=69, r=30, h=60 },
  marble_column = { kind="scenery", id=71, r=30, h=60, add_mode="island" },
}

WOLF.PLAYER_MODEL =
{
  bj =
  {
    stats   = { health=0, bullet=0 },
    weapons = { pistol=1, knife=1  },
  }
}
