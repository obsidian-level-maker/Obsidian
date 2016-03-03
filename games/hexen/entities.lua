------------------------------------------------------------------------
--  HEXEN ENTITIES
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2011 Andrew Apted
--  Copyright (C) 2011-2012 Jared Blackburn
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

HEXEN.ENTITIES =
{
  --- players
  player1 = { id=1, r=16, h=64 }
  player2 = { id=2, r=16, h=64 }
  player3 = { id=3, r=16, h=64 }
  player4 = { id=4, r=16, h=64 }

  dm_player     = { id=11 }
  teleport_spot = { id=14 }
  
  --- PICKUPS ---

  -- keys
  k_steel   = { id=8030 }  -- KEY1 sprite
  k_cave    = { id=8031 }  -- KEY2
  k_axe     = { id=8032 }  -- KEY3
  k_fire    = { id=8033 }  -- KEY4
  k_emerald = { id=8034 }  -- KEY5
  k_dungeon = { id=8035 }  -- KEY6
  k_silver  = { id=8036 }  -- KEY7
  k_rusty   = { id=8037 }  -- KEY8
  k_horn    = { id=8038 }  -- KEY9
  k_swamp   = { id=8039 }  -- KEYA
  k_castle  = { id=8200 }  -- KEYB
 
  -- weapons
  c_staff   = { id=10,  r=20, h=16 }
  c_fire    = { id=8009,r=20, h=16 }
  c1_shaft  = { id=20,  r=20, h=16 }
  c2_cross  = { id=19,  r=20, h=16 }
  c3_arc    = { id=18,  r=20, h=16 }

  f_axe     = { id=8010,r=20, h=16 }
  f_hammer  = { id=123, r=20, h=16 }
  f1_hilt   = { id=16,  r=20, h=16 }
  f2_cross  = { id=13,  r=20, h=16 }
  f3_blade  = { id=12,  r=20, h=16 }

  m_cone    = { id=53,  r=20, h=16 }
  m_blitz   = { id=8040,r=20, h=16 }
  m1_stick  = { id=23,  r=20, h=16 }
  m2_stub   = { id=22,  r=20, h=16 }
  m3_skull  = { id=21,  r=20, h=16 }

  -- artifacts
  wings = { id=83 }
  chaos = { id=36 }
  torch = { id=33 }

  banish    = { id=10040 }
  boots     = { id=8002 }
  bracer    = { id=8041 }
  repulser  = { id=8000 }
  flechette = { id=10110 }
  servant   = { id=86 }
  porkies   = { id=30 }
  incant    = { id=10120 }
  defender  = { id=84 }
  krater    = { id=8003 }

  --- SCENERY ---

  -- lights
  candles       = { id=119,  r=20, h=20, light=255 }
  blue_candle   = { id=8066, r=20, h=20, light=255 }
  fire_skull    = { id=8060, r=12, h=12, light=255 }
  brass_brazier = { id=8061, r=12, h=40, light=255 }

  wall_torch      = { id=54,  r=20, h=48, light=255 }
  wall_torch_out  = { id=55,  r=20, h=48 }
  twine_torch     = { id=116, r=12, h=64, light=255 }
  twine_torch_out = { id=117, r=12, h=64 }
  chandelier      = { id=17,  r=20, h=60, light=255, ceil=true }
  chandelier_out  = { id=8063,r=20, h=60, light=255, ceil=true }

  cauldron        = { id=8069,r=16, h=32, light=255 }
  cauldron_out    = { id=8070,r=16, h=32 }
  fire_bull       = { id=8042,r=24, h=80, light=255 }
  fire_bull_out   = { id=8043,r=24, h=80 }

  -- urbane
  winged_statue1 = { id=5,   r=12, h=64 }
  winged_statue2 = { id=9011,r=12, h=64 }
  suit_of_armor  = { id=8064,r=16, h=72 }

  gargoyle_tall  = { id=72, r=16, h=108 }
  gargoyle_short = { id=74, r=16, h=64  }
  garg_ice_tall  = { id=73, r=16, h=108 }
  garg_ice_short = { id=76, r=16, h=64  }

  garg_corrode     = { id=8044, r=16, h=108 }
  garg_red_tall    = { id=8045, r=16, h=108 }
  garg_red_short   = { id=8049, r=16, h=64  }
  garg_lava_tall   = { id=8046, r=16, h=108 }
  garg_lava_short  = { id=8050, r=16, h=64  }

  garg_bronz_tall  = { id=8047, r=16, h=108 }
  garg_bronz_short = { id=8051, r=16, h=64  }
  garg_steel_tall  = { id=8048, r=16, h=108 }
  garg_steel_short = { id=8052, r=16, h=64  }

  bell   = { id=8065, r=56, h=120 }
  barrel = { id=8100, r=16, h=36 }
  bucket = { id=8103, r=12, h=72 }
  banner = { id=77,   r=12, h=120 }

  vase_pillar = { id=103, r=12, h=56 }

  -- nature
  tree1 = { id=25, r=16, h=128 }
  tree2 = { id=26, r=12, h=180 }
  tree3 = { id=27, r=12, h=160 }

  lean_tree1 = { id=78,  r=16, h=180 }
  lean_tree2 = { id=79,  r=16, h=180 }
  smash_tree = { id=8062,r=16, h=180 }
  xmas_tree  = { id=8068,r=12, h=132 }

  gnarled_tree1 = { id=80, r=24, h=96 }
  gnarled_tree2 = { id=87, r=24, h=96 }

  shrub1 = { id=8101, r=12, h=24 }
  shrub2 = { id=8102, r=16, h=40 }

  rock1  = { id=6,  r=20, h=16 }
  rock2  = { id=7,  r=20, h=16 }
  rock3  = { id=9,  r=20, h=16 }
  rock4  = { id=15, r=20, h=16 }

  stal_pillar   = { id=48, r=12, h=136 }
  stal_F_big    = { id=49, r=12, h=48 }
  stal_F_medium = { id=50, r=12, h=40 }
  stal_F_small  = { id=51, r=12, h=40 }

  stal_C_big    = { id=52, r=12, h=68 }
  stal_C_medium = { id=56, r=12, h=52 }
  stal_C_small  = { id=57, r=12, h=40 }

  ice_stal_F_big    = { id=93, r=12, h=68 }
  ice_stal_F_medium = { id=94, r=12, h=52 }
  ice_stal_F_small  = { id=95, r=12, h=36 }
  ice_stal_F_tiny   = { id=95, r=12, h=16 }

  ice_stal_C_big    = { id=89, r=12, h=68 }
  ice_stal_C_medium = { id=90, r=12, h=52 }
  ice_stal_C_small  = { id=91, r=12, h=36 }
  ice_stal_C_tiny   = { id=92, r=12, h=16 }

  -- gory
  impaled_corpse = { id=61,  r=12, h=96 }
  laying_corpse  = { id=62,  r=12, h=44 }
  hang_corpse_1  = { id=71,  r=12, h=75, ceil=true }
  hang_corpse_1  = { id=108, r=12, h=96, ceil=true }
  hang_corpse_1  = { id=109, r=12, h=100,ceil=true }
  smash_corpse   = { id=110, r=12, h=40 }

  iron_maiden    = { id=8067,r=16, h=60 }

  -- miscellaneous
  teleport_smoke = { id=140, r=20, h=80, pass=true }
  dummy = { id=55, r=16, h=20, pass=true }

  -- ambient sounds
  snd_stone  = { id=1400 }
  snd_heavy  = { id=1401 }
  snd_metal1 = { id=1402 }
  snd_creak  = { id=1403 }
  snd_silent = { id=1404 }
  snd_lava   = { id=1405 }
  snd_water  = { id=1406 }
  snd_ice    = { id=1407 }
  snd_earth  = { id=1408 }
  snd_metal2 = { id=1409 }
}


--------------------------------------------------

HEXEN.PLAYER_MODEL =
{
  fighter =
  {
    stats   = { health=0 }
    weapons = { f_gaunt=1 }
  }

  cleric =
  {
    stats   = { health=0 }
    weapons = { c_mace=1 }
  }

  mage =
  {
    stats   = { health=0 }
    weapons = { m_wand=1 }
  }
}

